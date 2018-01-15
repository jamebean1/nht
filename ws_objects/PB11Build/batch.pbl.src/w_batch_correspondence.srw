$PBExportHeader$w_batch_correspondence.srw
$PBExportComments$Batch Correspondence Window
forward
global type w_batch_correspondence from w_main_std
end type
type st_4 from statictext within w_batch_correspondence
end type
type p_1 from picture within w_batch_correspondence
end type
type st_2 from statictext within w_batch_correspondence
end type
type dw_search_criteria from u_dw_search within w_batch_correspondence
end type
type dw_matched_records from u_dw_std within w_batch_correspondence
end type
type ln_3 from line within w_batch_correspondence
end type
type ln_4 from line within w_batch_correspondence
end type
end forward

global type w_batch_correspondence from w_main_std
integer x = 87
integer y = 136
integer width = 3653
integer height = 2060
string title = "Batch Correspondence"
string menuname = "m_batch_correspondence"
boolean maxbox = false
boolean resizable = false
boolean toolbarvisible = true
st_4 st_4
p_1 p_1
st_2 st_2
dw_search_criteria dw_search_criteria
dw_matched_records dw_matched_records
ln_3 ln_3
ln_4 ln_4
end type
global w_batch_correspondence w_batch_correspondence

type variables
STRING i_cSearchColumn[]
STRING i_cSearchTable[]
STRING i_cMatchColumn[]

STRING i_cLetterType = 'L'
STRING i_cSurveyType = 'S'
STRING i_cUserID

STRING i_cWORDEXE

OLEOBJECT i_oleCorrespondence

BOOLEAN i_bOutOfOffice
BOOLEAN i_bFromPrint = FALSE

end variables

forward prototypes
public subroutine fw_clearsearch ()
public subroutine fw_checkoutofoffice ()
public function integer fw_validatedate (string searchcolumn, long searchrow)
end prototypes

public subroutine fw_clearsearch ();/**************************************************************************************

				Function:		fw_clearsearch
				Purpose:			To clear the search criteria for a new search
				Parameters:		None
				Returns:			None
	
*************************************************************************************/


//-------------------------------------------------------------------------------------
//		Clear the Search Criteria
//-------------------------------------------------------------------------------------

dw_matched_records.Reset()
dw_search_criteria.fu_Reset()

dw_search_criteria.SetFocus()
end subroutine

public subroutine fw_checkoutofoffice ();//********************************************************************************************
//
//  Function: fw_checkoutofoffice
//  Purpose:  To mark the out of office menu item
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  12/15/00 cjackson    Original Verison
//
//********************************************************************************************

LONG l_nCount

// Get userid
i_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

// If the user is currently mark as out of the office, setting the Check on the menu item
SELECT count(*) INTO :l_nCount
  FROM cusfocus.out_of_office
 WHERE out_user_id = :i_cUserID
 USING SQLCA;
 
// Update the clicked property based on whether not the user if Out of Office 
IF l_nCount > 0 THEN
	m_batch_correspondence.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_batch_correspondence.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
END IF


end subroutine

public function integer fw_validatedate (string searchcolumn, long searchrow);/*****************************************************************************************
   Function:   fw_ValidateDate
   Purpose:    Validate the specified date field with it's paired value.
   Parameters: STRING	searchcolumn - The column to validate
					LONG		searchrow - The row being validated
   Returns:    INTEGER - c_ValOK, c_ValFixed, c_ValField (see datawindow value definitions)

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/27/02 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nSearchError
STRING	l_cCompareColumn, l_cOp
DATETIME	l_dtValue, l_dtCompare, l_dtInitial

l_dtInitial = dw_search_criteria.GetItemDateTime (searchrow, searchcolumn)

// accept the new value into the field
dw_search_criteria.AcceptText ()

CHOOSE CASE SearchColumn
	CASE 'corspnd_from_create_date'
		l_cCompareColumn = 'corspnd_to_create_date'
		l_cOp = '<'
		
	CASE 'corspnd_to_create_date'
		l_cCompareColumn = 'corspnd_from_create_date'
		l_cOp = '>'
		
	CASE 'case_log_from_opnd_date'
		l_cCompareColumn = 'case_log_to_opnd_date'
		l_cOp = '<'
		
	CASE 'case_log_to_opnd_date'
		l_cCompareColumn = 'case_log_from_opnd_date'
		l_cOp = '>'
		
END CHOOSE

// get the values for processing
l_dtValue = dw_search_criteria.GetItemDateTime (searchrow, searchcolumn)
l_dtCompare = dw_search_criteria.GetItemDateTime (searchrow, l_cCompareColumn)

// compare the values
IF l_cOp = '>' THEN
	IF DaysAfter (DATE (l_dtValue), DATE(l_dtCompare)) > 0 THEN
		MessageBox (gs_appname, 'The TO date must be after the FROM date.')
		l_dtValue = l_dtInitial
		dw_search_criteria.SetItem (searchrow, SearchColumn, l_dtValue)
		l_nSearchError = dw_search_criteria.c_ValFailed
	ELSE
		l_nSearchError = dw_search_criteria.c_ValOK
	END IF
ELSE
	IF DaysAfter (DATE (l_dtValue), DATE(l_dtCompare)) < 0 THEN
		MessageBox (gs_appname, 'The FROM date must be prior to the TO date.')
		l_dtValue = l_dtInitial
		dw_search_criteria.SetItem (searchrow, SearchColumn, l_dtValue)
		l_nSearchError = dw_search_criteria.c_ValFailed
	ELSE
		l_nSearchError = dw_search_criteria.c_ValOK
	END IF
END IF

RETURN l_nSearchError
end function

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setwindow
//  Purpose: To initialize the search object, wire it to the matched records data window, 
//           populate the cusfocus user dropdown and to get the users first name, last name 
//			  and mi.
//			  
//  Date
//  -------- ----------- -----------------------------------------------------------------------
//  05/21/99 M. Caruso   Change toolbar initialization from c_ToolbarLeft to c_ToolbarTop
//  04/11/01 K. Claver   Changed search processing to use ue_search event of dw_matched_records
//  10/17/2001 K. Claver Enhanced to use registry.
//  
//**********************************************************************************************


STRING l_cFirstName, l_cLastName, l_cMI
DATAWINDOWCHILD l_dwcUserRep, l_dwcLetterCat, l_dwcDept, l_dwcCaseType

fw_SetOptions(c_default + c_ToolBarTop)	// RAE 4/5/99; MPC   5/21/99

//--------------------------------------------------------------------------------------
//
//			Initialize the Search Column, Search Table and Match Column arrays.
//
//--------------------------------------------------------------------------------------

//i_cSearchColumn[1] = 'case_number'
//i_cSearchColumn[2] = 'letter_id'
//i_cSearchColumn[3] = 'corspnd_create_date'
//i_cSearchColumn[4] = 'case_type'
//i_cSearchColumn[5] = 'corspnd_created_by'
//i_cSearchColumn[6] = 'case_log_opnd_date'
//i_cSearchColumn[7] = 'user_dept_id'
//
//i_cSearchTable[1] = 'cusfocus.correspondence'
//i_cSearchTable[2] = 'cusfocus.correspondence'
//i_cSearchTable[3] = 'cusfocus.correspondence'
//i_cSearchTable[4] = 'cusfocus.correspondence'
//i_cSearchTable[5] = 'cusfocus.correspondence'
//i_cSearchTable[6] = 'cusfocus.case_log'
//i_cSearchTable[7] = 'cusfocus.cusfocus_user'
//
//i_cMatchColumn[1] = 'case_number'
//i_cMatchColumn[2] = 'letter_id'
//i_cMatchColumn[3] = 'corspnd_create_date'
//i_cMatchColumn[4] = 'case_type'
//i_cMatchColumn[5] = 'corspnd_created_by'
//i_cMatchColumn[6] = 'case_log_opnd_date'
//i_cMatchColumn[7] = 'user_dept_id'

//--------------------------------------------------------------------------------------
//
//		Populate the user dropdown data window and add a record for an All match.
//
//--------------------------------------------------------------------------------------

dw_search_criteria.GetChild('corspnd_created_by', l_dwcUserRep)
l_dwcUserRep.SetTransObject(SQLCA)
l_dwcUserRep.Retrieve()
l_dwcUserRep.InsertRow(1)
l_dwcUserRep.SetItem(1, 'user_id', '^')
l_dwcUserRep.SetItem(1, 'user_last_name', '(All)')

//-------------------------------------------------------------------------------------
//
//		Populate the Letter Category DropDown DatWindow and add a record for an
//		All match.
//
//--------------------------------------------------------------------------------------

dw_search_criteria.GetChild('letter_id', l_dwcLetterCat)
l_dwcLetterCat.SetTransObject(SQLCA)
l_dwcLetterCat.Retrieve()
l_dwcLetterCat.InsertRow(1)
l_dwcLetterCat.SetItem(1,'letter_id', '^')
l_dwcLetterCat.SetItem(1, 'letter_name', '(All)')

//--------------------------------------------------------------------------------------
//
//		Populate the department dropdown data window and add a record for an All match.
//
//--------------------------------------------------------------------------------------

dw_search_criteria.GetChild('user_dept_id', l_dwcDept)
l_dwcDept.SetTransObject(SQLCA)
l_dwcDept.Retrieve()
l_dwcDept.InsertRow(1)
l_dwcDept.SetItem(1, 'cusfocus_user_dept_user_dept_id', '^')
l_dwcDept.SetItem(1, 'cusfocus_user_dept_dept_desc', '(All)')

//--------------------------------------------------------------------------------------
//
//		Populate the case type dropdown data window and add a record for an All match.
//
//--------------------------------------------------------------------------------------

dw_search_criteria.GetChild('case_type', l_dwcCaseType)
l_dwcCaseType.SetTransObject(SQLCA)
l_dwcCaseType.Retrieve()
l_dwcCaseType.InsertRow(1)
l_dwcCaseType.SetItem(1, 'case_type', '^')
l_dwcCaseType.SetItem(1, 'case_type_desc', '(All)')


//---------------------------------------------------------------------------------------
//
//		Wire the Search object to the matching datawindow.
//
//---------------------------------------------------------------------------------------

//dw_search_criteria.fu_WireDW(i_cSearchColumn[], dw_matched_records, &
//			i_cSearchTable[], i_cMatchColumn[], SQLCA)

//--------------------------------------------------------------------------------------
//		Find out from the INI file where WINWORD is located.
//--------------------------------------------------------------------------------------

IF OBJCA.MGR.i_Source = "R" THEN
	RegistryGet( ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info\winword" ), "exeloc", &
					 RegString!, i_cWORDExe )
ELSE
	i_cWORDExe = ProfileString(OBJCA.MGR.i_ProgINI, 'WINWORD','EXELOC', '')
END IF

fw_CheckOutOfOffice()

m_batch_correspondence.m_file.m_search.enabled = TRUE
m_batch_correspondence.m_file.m_search.toolbaritemvisible = TRUE
m_batch_correspondence.m_file.m_clearsearch.enabled = TRUE
m_batch_correspondence.m_file.m_clearsearch.toolbaritemvisible = TRUE
m_batch_correspondence.m_file.m_printselectedcorrespondence.enabled = TRUE
m_batch_correspondence.m_file.m_printselectedcorrespondence.toolbaritemvisible = TRUE

end event

event pc_setcodetables;call super::pc_setcodetables;////*********************************************************************************************
////
////		Event:	pc_setddlb
////		Purpose:	To populate the Case Type DropDown List Boxes.
////
////*********************************************************************************************
//
//LONG l_nReturn 
//
////-------------------------------------------------------------------------------------
////
////		Populate the Case Type DropDown List Bow.
////
////--------------------------------------------------------------------------------------
//
//l_nReturn = dw_search_criteria.fu_LoadCode("case_type","cusfocus.case_types", &
//									"case_type", "case_type_desc", "", "(All)")
// 
//
//
end event

on w_batch_correspondence.create
int iCurrent
call super::create
if this.MenuName = "m_batch_correspondence" then this.MenuID = create m_batch_correspondence
this.st_4=create st_4
this.p_1=create p_1
this.st_2=create st_2
this.dw_search_criteria=create dw_search_criteria
this.dw_matched_records=create dw_matched_records
this.ln_3=create ln_3
this.ln_4=create ln_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_search_criteria
this.Control[iCurrent+5]=this.dw_matched_records
this.Control[iCurrent+6]=this.ln_3
this.Control[iCurrent+7]=this.ln_4
end on

on w_batch_correspondence.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.p_1)
destroy(this.st_2)
destroy(this.dw_search_criteria)
destroy(this.dw_matched_records)
destroy(this.ln_3)
destroy(this.ln_4)
end on

type st_4 from statictext within w_batch_correspondence
integer x = 201
integer y = 60
integer width = 1691
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Batch Correspondence"
boolean focusrectangle = false
end type

type p_1 from picture within w_batch_correspondence
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_2 from statictext within w_batch_correspondence
integer width = 3863
integer height = 168
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type dw_search_criteria from u_dw_search within w_batch_correspondence
event ue_searchtrigger pbm_dwnkey
integer x = 18
integer y = 192
integer width = 3607
integer height = 472
integer taborder = 10
string dataobject = "d_search_batch_correspondence"
boolean border = false
end type

event ue_searchtrigger;/****************************************************************************************

	Event:	ue_searchtrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/25/99  M. Caruso     Created.

****************************************************************************************/

IF key = KeyEnter! THEN
	m_batch_correspondence.m_file.m_search.TriggerEvent (clicked!)
END IF
end event

event buttonclicked;call super::buttonclicked;/****************************************************************************************

	Event:	buttonclicked
	Purpose:	Please see PB documentation for this event
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	4/10/2001 K. Claver    Added code to process the button clicked events

****************************************************************************************/
INTEGER	l_nX, l_nY, l_nHeight
DATETIME	l_dtValue, l_dtInitial, l_dtCompare
STRING	l_cValue, l_cParm, l_cX, l_cY, l_cColName

CHOOSE CASE dwo.name
	CASE 'b_corspnd_from'
		l_cColName = 'corspnd_from_create_date'
		
	CASE 'b_corspnd_to'
		l_cColName = 'corspnd_to_create_date'
		
	CASE 'b_opnd_from'
		l_cColName = 'case_log_from_opnd_date'
		
	CASE 'b_opnd_to'
		l_cColName = 'case_log_to_opnd_date'
		
END CHOOSE

// set focus to the column associated with the selected button
SetColumn (l_cColName)

// Get the button's dimensions to position the calendar window
l_nX = Integer (dwo.X) + dw_search_criteria.X + PARENT.X
l_nY = Integer (dwo.Y) + Integer (dwo.Height) + dw_search_criteria.Y + PARENT.Y
l_cX = String (l_nX)
l_cY = String (l_nY)

// open the calendar window
AcceptText ()
l_dtValue = GetItemDateTime (row, l_cColName)
l_dtInitial = l_dtValue
l_cParm = (String (Date (l_dtValue), "mm/dd/yyyy")+"&"+l_cX+"&"+l_cY)
FWCA.MGR.fu_OpenWindow (w_calendar, l_cParm)

// Get the date passed back
l_cValue = Message.StringParm

// If it's a date, convert to a datetime and update the field.
IF IsDate (l_cValue) THEN
	l_dtValue = DateTime (Date (l_cValue), Time ("00:00:00.000"))
	CHOOSE CASE l_cColName
		CASE 'corspnd_from_create_date'
			l_dtCompare = GetItemDateTime (row, 'corspnd_to_create_date')
			IF DaysAfter (DATE (l_dtValue), DATE(l_dtCompare)) < 0 THEN
				MessageBox (gs_appname, 'The FROM date must be prior to the TO date.')
				l_dtValue = l_dtInitial
			END IF
			
		CASE 'corspnd_to_create_date'
			l_dtCompare = GetItemDateTime (row, 'corspnd_from_create_date')
			IF DaysAfter (DATE (l_dtValue), DATE(l_dtCompare)) > 0 THEN
				MessageBox (gs_appname, 'The TO date must be after the FROM date.')
				l_dtValue = l_dtInitial
			END IF
			
		CASE 'case_log_from_opnd_date'
			l_dtCompare = GetItemDateTime (row, 'case_log_to_opnd_date')
			IF DaysAfter (DATE (l_dtValue), DATE(l_dtCompare)) < 0 THEN
				MessageBox (gs_appname, 'The FROM date must be prior to the TO date.')
				l_dtValue = l_dtInitial
			END IF
			
		CASE 'case_log_to_opnd_date'
			l_dtCompare = GetItemDateTime (row, 'case_log_from_opnd_date')
			IF DaysAfter (DATE (l_dtValue), DATE(l_dtCompare)) > 0 THEN
				MessageBox (gs_appname, 'The TO date must be after the FROM date.')
				l_dtValue = l_dtInitial
			END IF
			
	END CHOOSE
ELSE
	SetNull (l_dtValue)
END IF

SetItem (row, l_cColName, l_dtValue)
end event

event po_validate;call super::po_validate;/*****************************************************************************************
   Event:      po_validate
   Purpose:    Validate the specified field in the search criteria datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/27/02 M. Caruso    Created.
*****************************************************************************************/

CHOOSE CASE SearchColumn
	CASE 'corspnd_from_create_date', 'corspnd_to_create_date', &
		  'case_log_from_opnd_date', 'case_log_to_opnd_date'
		i_SearchError = fw_ValidateDate (SearchColumn, SearchRow)
		
	CASE ELSE
		IF TRIM (searchvalue) = '' THEN
			SetNull (searchvalue)
			SetItem (searchrow, searchcolumn, searchvalue)
			i_SearchError = c_ValFixed
		ELSE
			i_SearchError = c_ValOK
		END IF
		
END CHOOSE
end event

type dw_matched_records from u_dw_std within w_batch_correspondence
event ue_search ( )
integer x = 32
integer y = 676
integer width = 3575
integer height = 1188
integer taborder = 20
string dataobject = "d_matched_batched_correspondence"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_search();/*****************************************************************************************
   Event:      ue_search
   Purpose:    Add search criteria to the datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/10/2001 K. Claver   Created in place of the PowerClass search functionality as it does
								 not accomodate for date ranges.
	4/11/2001 K. Claver   Added code to accomodate for the MS-SQL Server year limitation.
*****************************************************************************************/
String l_cSQLSelect, l_cCaseType, l_cCaseNumber, l_cRep, l_cCategory, l_cDepartment, l_cRV
String l_cAddToWhere = "", l_cCorrFrom, l_cCorrTo, l_cOpenFrom, l_cOpenTo, l_cOrigSQLSelect
String l_cModify
DateTime l_dtCorrCreatedFrom, l_dtCorrCreatedTo, l_dtCaseOpenedFrom, l_dtCaseOpenedTo
Boolean l_bAll = FALSE

IF dw_search_criteria.RowCount( ) > 0 THEN
	//Get the values from the search datawindow
	l_cCaseNumber = dw_search_criteria.Object.case_number[ 1 ]
	l_cCaseType = dw_search_criteria.Object.case_type[ 1 ]
	l_cRep = dw_search_criteria.Object.corspnd_created_by[ 1 ]
	l_cCategory = dw_search_criteria.Object.letter_id[ 1 ]
	l_cDepartment = dw_search_criteria.Object.user_dept_id[ 1 ]
	l_dtCorrCreatedFrom = dw_search_criteria.Object.corspnd_from_create_date[ 1 ]
	l_dtCorrCreatedTo = dw_search_criteria.Object.corspnd_to_create_date[ 1 ]
	l_dtCaseOpenedFrom = dw_search_criteria.Object.case_log_from_opnd_date[ 1 ]
	l_dtCaseOpenedTo = dw_search_criteria.Object.case_log_to_opnd_date[ 1 ]
	
	//First, check for start dates with no end dates
	IF NOT IsNull( l_dtCorrCreatedFrom ) AND IsNull( l_dtCorrCreatedTo ) THEN
		IF Year( Date( l_dtCorrCreatedFrom ) ) < 1753 THEN
			MessageBox( gs_AppName, "Invalid year for date range", Stopsign!, OK! )
			dw_search_criteria.SetFocus( )
			dw_search_criteria.SetColumn( "corspnd_from_create_date" )
			RETURN
		ELSE		
			dw_search_criteria.Object.corspnd_to_create_date[ 1 ] = l_dtCorrCreatedFrom
			l_dtCorrCreatedTo = l_dtCorrCreatedFrom
		END IF
	END IF
	
	IF NOT IsNull( l_dtCaseOpenedFrom ) AND IsNull( l_dtCaseOpenedTo ) THEN
		IF Year( Date( l_dtCaseOpenedFrom ) ) < 1753 THEN
			MessageBox( gs_AppName, "Invalid year for date range", Stopsign!, OK! )
			dw_search_criteria.SetFocus( )
			dw_search_criteria.SetColumn( "case_log_from_opnd_date" )
			RETURN
		ELSE
			dw_search_criteria.Object.case_log_to_opnd_date[ 1 ] = l_dtCaseOpenedFrom
			l_dtCaseOpenedTo = l_dtCaseOpenedFrom
		END IF
	END IF
	
	//Get the current sql select for the matched records datawindow
	l_cSQLSelect = THIS.GetSQLSelect( )
	l_cOrigSQLSelect = l_cSQLSelect
	
	//Add to the where clause
	//Case Number
	IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
		IF Pos( l_cCaseNumber, "%" ) > 0 THEN
			l_cAddToWhere += " AND cusfocus.correspondence.case_number LIKE '"+l_cCaseNumber+"'"
		ELSE
			l_cAddToWhere += " AND cusfocus.correspondence.case_number = '"+l_cCaseNumber+"'"
		END IF
	END IF
	
	//Case Type
	IF NOT IsNull( l_cCaseType ) AND Trim( l_cCaseType ) <> "" THEN
		IF l_cCaseType = "^" THEN
			l_bAll = TRUE
		ELSE
			l_cAddToWhere += " AND cusfocus.correspondence.case_type = '"+l_cCaseType+"'"
		END IF
	END IF
	
	//Created By
	IF NOT IsNull( l_cRep ) AND Trim( l_cRep ) <> "" THEN
		IF l_cRep = "^" THEN
			l_bAll = TRUE
		ELSE
			l_cAddToWhere += " AND cusfocus.correspondence.corspnd_created_by = '"+l_cRep+"'"
		END IF
	END IF
	
	//Letter Category
	IF NOT IsNull( l_cCategory ) AND Trim( l_cCategory ) <> "" THEN
		IF l_cCategory = "^" THEN
			l_bAll = TRUE
		ELSE
			l_cAddToWhere += " AND cusfocus.correspondence.letter_id = '"+l_cCategory+"'"
		END IF
	END IF
	
	//Department
	IF NOT IsNull( l_cDepartment ) AND Trim( l_cDepartment ) <> "" THEN
		IF l_cDepartment = "^" THEN
			l_bAll = TRUE
		ELSE
			l_cAddToWhere += " AND cusfocus.cusfocus_user.user_dept_id = '"+l_cDepartment+"'"
		END IF
	END IF
	
	//Correspondence Created Date - From
	IF NOT IsNull( l_dtCorrCreatedFrom ) THEN
		l_cCorrFrom = String( Date( l_dtCorrCreatedFrom ), "mm/dd/yyyy" )
		l_cCorrFrom += " 00:00:00.000"
		l_cAddToWhere += " AND cusfocus.correspondence.corspnd_create_date >= '"+l_cCorrFrom+"'"
	ELSE
		IF NOT IsNull( l_dtCorrCreatedTo ) THEN
			MessageBox( gs_AppName, "Start Date required for date range", Stopsign!, OK! )
			dw_search_criteria.SetFocus( )
			dw_search_criteria.SetColumn( "corspnd_from_create_date" )
			RETURN
		END IF
	END IF
	
	//Correspondence Created Date - To
	IF NOT IsNull( l_dtCorrCreatedTo) THEN
		l_cCorrTo = String( Date( l_dtCorrCreatedTo ), "mm/dd/yyyy" )
		l_cCorrTo += " 23:59:59.999"
		
		IF Year( Date( l_dtCorrCreatedTo ) ) < 1753 THEN
			MessageBox( gs_AppName, "Invalid year for date range", Stopsign!, OK! )
			dw_search_criteria.SetFocus( )
			dw_search_criteria.SetColumn( "corspnd_to_create_date" )
			RETURN
		ELSE
			l_cAddToWhere += " AND cusfocus.correspondence.corspnd_create_date <= '"+l_cCorrTo+"'"
		END IF
	ELSE
		IF NOT IsNull( l_dtCorrCreatedFrom ) THEN
			MessageBox( gs_AppName, "End Date required for date range", Stopsign!, OK! )
			dw_search_criteria.SetFocus( )
			dw_search_criteria.SetColumn( "corspnd_to_create_date" )
			RETURN
		END IF
	END IF
	
	//Case Opened Date - From
	IF NOT IsNull( l_dtCaseOpenedFrom ) THEN
		l_cOpenFrom = String( Date( l_dtCaseOpenedFrom ), "mm/dd/yyyy" )
		l_cOpenFrom += " 00:00:00.000"
		l_cAddToWhere += " AND cusfocus.case_log.case_log_opnd_date >= '"+l_cOpenFrom+"'"
	ELSE
		IF NOT IsNull( l_dtCaseOpenedTo ) THEN
			MessageBox( gs_AppName, "Start Date required for date range", Stopsign!, OK! )
			dw_search_criteria.SetFocus( )
			dw_search_criteria.SetColumn( "case_log_from_opnd_date" )
			RETURN
		END IF
	END IF
	
	//Case Opened Date - To
	IF NOT IsNull( l_dtCaseOpenedTo ) THEN
		l_cOpenTo = String( Date( l_dtCaseOpenedTo ), "mm/dd/yyyy" )
		l_cOpenTo += " 23:59:59.999"
		
		IF Year( Date( l_dtCaseOpenedTo ) ) < 1753 THEN
			MessageBox( gs_AppName, "Invalid year for date range", Stopsign!, OK! )
			dw_search_criteria.SetFocus( )
			dw_search_criteria.SetColumn( "case_log_to_opnd_date" )
			RETURN
		ELSE
			l_cAddToWhere += " AND cusfocus.case_log.case_log_opnd_date <= '"+l_cOpenTo+"'"
		END IF
	ELSE
		IF NOT IsNull( l_dtCaseOpenedFrom ) THEN
			MessageBox( gs_AppName, "End Date required for date range", Stopsign!, OK! )
			dw_search_criteria.SetFocus( )
			dw_search_criteria.SetColumn( "case_log_to_opnd_date" )
			RETURN
		END IF
	END IF
	
	IF Trim( l_cAddToWhere ) <> "" OR l_bAll THEN
		l_cSQLSelect += l_cAddToWhere
		l_cModify = "DataWindow.Table.Select=~""+l_cSQLSelect+"~""
		l_cRV = THIS.Modify( l_cModify )
		
		IF Trim( l_cRV ) <> "" THEN
			MessageBox( gs_AppName, "Unable to set the criteria for the search.~r~n"+l_cRV, StopSign!, OK! )
		ELSE
			//Re-retrieve the datawindow
			THIS.fu_Retrieve( c_IgnoreChanges, c_NoReselectRows )
		END IF
	ELSE
		MessageBox( gs_AppName, "You must either use a date range or more specific criteria than 'All' to execute the search.", StopSign!, OK! )
	END IF	
	
	//Set the sql select back to the original
	l_cModify = "DataWindow.Table.Select=~""+l_cOrigSQLSelect+"~""
	THIS.Modify( l_cModify )
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/***************************************************************************************
	Event:	pcd_retrieve
	Purpose:	To retrieve the records based on the search criteria

	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	02/12/02 M. Caruso     Implemented conditional "no matching records" message.
***************************************************************************************/

LONG l_nReturn

l_nReturn = Retrieve()

CHOOSE CASE l_nReturn
	CASE IS < 0
	 	Error.i_FWError = c_Fatal
		 
	CASE 0
		IF NOT PARENT.i_bFromPrint THEN
			MessageBox( gs_AppName, "There are not any records which meet the search criteria." )
		END IF
		
		PARENT.i_bFromPrint = FALSE
		
END CHOOSE
end event

event clicked;call super::clicked;/******************************************************************************************
     Event: clicked
	Purpose: Sort the datawindow by the column that was clicked.
	
 Revisions: Date     Developer       Description
            ======== =============== =====================================================
				05/25/99 M. Caruso       Created.
******************************************************************************************/
//STRING ls_name
//
//IF dwo.Type = "text" THEN
//		ls_name = dwo.Name
//		ls_name = Left(ls_name, Len(ls_name) - 2)
//
//		This.SetSort(ls_name + ", A")
//		This.Sort()
//END IF
end event

event pcd_setoptions;call super::pcd_setoptions;///*****************************************************************************************
//   Event:      pcd_setoptions
//   Purpose:    Initialize the datawindow
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	12/29/00 M. Caruso    Created.
//*****************************************************************************************/

THIS.fu_SetOptions( SQLCA, & 
 		c_NullDW, & 
 		c_SelectOnRowFocusChange + &
 		c_ModifyOK + &
 		c_MultiSelect + &
 		c_NoRetrieveOnOpen + &
 		c_ShowHighlight + &
		c_TabularFormStyle + &
 		c_ActiveRowPointer + &
 		c_NoInactiveRowPointer + &
		c_NoMenuButtonActivation + &
		c_NoEnablePopup + &
		c_SortClickedOK) 
end event

type ln_3 from line within w_batch_correspondence
long linecolor = 16777215
integer linethickness = 4
integer beginy = 172
integer endx = 4000
integer endy = 172
end type

type ln_4 from line within w_batch_correspondence
long linecolor = 8421504
integer linethickness = 4
integer beginy = 168
integer endx = 4000
integer endy = 168
end type

