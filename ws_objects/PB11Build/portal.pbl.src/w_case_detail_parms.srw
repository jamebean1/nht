$PBExportHeader$w_case_detail_parms.srw
$PBExportComments$Case Detial History Report parameter entry window.
forward
global type w_case_detail_parms from w_response_std
end type
type rb_parameters from radiobutton within w_case_detail_parms
end type
type rb_case_numbers from radiobutton within w_case_detail_parms
end type
type st_category from statictext within w_case_detail_parms
end type
type sle_case_number from singlelineedit within w_case_detail_parms
end type
type st_2 from statictext within w_case_detail_parms
end type
type cbx_allcasetypes from checkbox within w_case_detail_parms
end type
type st_1 from statictext within w_case_detail_parms
end type
type ddlb_case_status from dropdownlistbox within w_case_detail_parms
end type
type ddlb_source_type from dropdownlistbox within w_case_detail_parms
end type
type cbx_all from checkbox within w_case_detail_parms
end type
type st_5 from statictext within w_case_detail_parms
end type
type cb_category_details from commandbutton within w_case_detail_parms
end type
type ddlb_case_type from dropdownlistbox within w_case_detail_parms
end type
type cb_cancel from commandbutton within w_case_detail_parms
end type
type cb_ok from commandbutton within w_case_detail_parms
end type
type b_calendar_from from commandbutton within w_case_detail_parms
end type
type b_calendar_to from commandbutton within w_case_detail_parms
end type
type st_report_subject from statictext within w_case_detail_parms
end type
type em_from from editmask within w_case_detail_parms
end type
type em_to from editmask within w_case_detail_parms
end type
type st_from from statictext within w_case_detail_parms
end type
type st_to from statictext within w_case_detail_parms
end type
type st_case_type from statictext within w_case_detail_parms
end type
type gb_date_range from groupbox within w_case_detail_parms
end type
type dw_category_org from u_outliner_std within w_case_detail_parms
end type
type dw_user_list from u_outliner_std within w_case_detail_parms
end type
type ln_1 from line within w_case_detail_parms
end type
end forward

global type w_case_detail_parms from w_response_std
integer width = 2446
integer height = 2200
string title = "Case Detail History Report"
rb_parameters rb_parameters
rb_case_numbers rb_case_numbers
st_category st_category
sle_case_number sle_case_number
st_2 st_2
cbx_allcasetypes cbx_allcasetypes
st_1 st_1
ddlb_case_status ddlb_case_status
ddlb_source_type ddlb_source_type
cbx_all cbx_all
st_5 st_5
cb_category_details cb_category_details
ddlb_case_type ddlb_case_type
cb_cancel cb_cancel
cb_ok cb_ok
b_calendar_from b_calendar_from
b_calendar_to b_calendar_to
st_report_subject st_report_subject
em_from em_from
em_to em_to
st_from st_from
st_to st_to
st_case_type st_case_type
gb_date_range gb_date_range
dw_category_org dw_category_org
dw_user_list dw_user_list
ln_1 ln_1
end type
global w_case_detail_parms w_case_detail_parms

type variables
STRING i_cDetailView

BOOLEAN	i_bOK
BOOLEAN	i_bMultiCategory

INTEGER  i_nSelectedLevel
INTEGER  i_nSelectedCat
INTEGER  i_nSelectedUsr

DATE		i_dFromDate
DATE		i_dToDate

DATETIME i_dtStartDate
DATETIME i_dtEndDate

STRING	i_cUserorDept = 'A'
STRING	i_cUserList
STRING	i_cWindowTitle
STRING   i_cDateColumn
STRING   i_cWhereGroupID
STRING   i_cWhereProfID
STRING   i_cCaseType = 'I'
STRING   i_cSourceType = 'C'
STRING   i_cSingleCategory
STRING   i_cCaseString[]

S_REPORT_PARMS	i_sReportParms
S_CATEGORY_INFO	i_sCurrentCategory

STRING  i_cResetArray[]
end variables

forward prototypes
public subroutine fw_initcategory (string case_type)
public subroutine fw_calcdaterange ()
public subroutine fw_case_number (string a_ccasestring)
end prototypes

public subroutine fw_initcategory (string case_type);//*********************************************************************************************
//
//  Event:   fw_initcategory
//  Purpose: Initlialize the category tree view based on the specified case_type.
//	
//	Parameters:
//		STRING	case_type		The ID used to determine the case type
//	Returns:
//		INTEGER	 0 = success
//					-1 = failure
//					
//  Date     Developer     Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/18/02 C. Jackson  Original Version
//*********************************************************************************************
	
CONSTANT	INTEGER	l_nMaxLevels = 5
STRING	l_cParentCategoryID, l_cTableName,l_cWhereClause
INTEGER	l_nIndex

FOR l_nIndex = 1 TO l_nMaxLevels
	IF l_nIndex = 1 THEN
		l_cTableName = "cusfocus.categories"
		l_cParentCategoryID = ""
			l_cWhereClause = l_cTableName + ".category_level = 1 AND " + &
								  l_cTableName + ".case_type = '" + case_type + "'"
	ELSE
		l_cTableName = "cusfocus.category_" + STRING (l_nIndex - 1) + "_vw"
		l_cParentCategoryID = l_cTableName + ".prnt_category_id"
		l_cWhereClause = l_cTableName + ".case_type = '" + case_type + "'"
	END IF
	
	// define retrieval options for all levels
	dw_category_org.fu_HLRetrieveOptions (l_nIndex, &
		"open.bmp", "closed.bmp", l_cTableName + ".category_id", + &
		l_cParentCategoryID, l_cTableName + ".category_name", &
		l_cTableName + ".category_name", l_cTableName, &
		l_cWhereClause, dw_category_org.c_KeyString)
NEXT

dw_category_org.fu_HLOptions(dw_category_org.c_ShowLines)

dw_category_org.fu_HLCreate (SQLCA, l_nMaxLevels)

dw_category_org.fu_HLSetSelectedRow(1)

i_nSelectedCat = 1




end subroutine

public subroutine fw_calcdaterange ();/*****************************************************************************************
   Function:   fw_calcdaterange
   Purpose:    Calculate the date range specified on the window.
   Parameters: NONE
   Returns:    NONE

   Date     Developer    Description
   ======== ============ =================================================================
	12/10/02 C. Jackson   Original Version
*****************************************************************************************/

DATE		l_dStartDate, l_dEndDate
TIME		l_tStartOfDay, l_tEndOfDay

l_tStartOfDay = Time ('00:00:00.000')
l_tEndOfDay = Time ('23:59:59.999')

em_from.GetData (l_dStartDate)
em_to.GetData (l_dEndDate)
i_dtStartDate = DATETIME (l_dStartDate, l_tStartOfDay)
i_dtEndDate = DATETIME (l_dEndDate, l_tEndOfDay)
end subroutine

public subroutine fw_case_number (string a_ccasestring);//***********************************************************************************************
//
//  Function: fw_case_number
//  Purpose:  compute case number string
//  
//  Date     Developer    Description
//  -------- ------------ -----------------------------------------------------------------------
//  12/10/02 C. Jackson   Original Version
//  11/21/04 C. Haxel     Strip spaces from input string
//***********************************************************************************************

LONG l_nPos, l_nCtr, l_nIndex

// Remove spaces
l_nPos = POS(a_cCaseString,' ',1)
l_nCtr = 0

DO WHILE l_nPos > 0
	
	a_cCaseString =  REPLACE(a_cCaseString,l_nPos,1,'')
	l_nPos = POS(a_cCaseString,' ',1)
	
LOOP

// Replace commas with semi-colons
l_nPos = POS(a_cCaseString,',',1)
l_nCtr = 0

DO WHILE l_nPos > 0
	
	l_nCtr ++
	a_cCaseString =  REPLACE(a_cCaseString,l_nPos,1,';')
	l_nPos = POS(a_cCaseString,',',1)
	
LOOP

l_nCtr = l_nCtr + 1

FOR l_nIndex = 1 TO l_nCtr
	
	l_nPos = POS(a_cCaseString,';',1)
	i_cCaseString[l_nIndex] = TRIM(MID(a_cCaseString,1,l_nPos - 1))
	a_cCaseString = MID(a_cCaseString,l_nPos + 1 )
	
	IF l_nIndex = l_nCtr THEN
		i_cCaseString[l_nIndex] = a_cCaseString
	END IF

NEXT


end subroutine

on w_case_detail_parms.create
int iCurrent
call super::create
this.rb_parameters=create rb_parameters
this.rb_case_numbers=create rb_case_numbers
this.st_category=create st_category
this.sle_case_number=create sle_case_number
this.st_2=create st_2
this.cbx_allcasetypes=create cbx_allcasetypes
this.st_1=create st_1
this.ddlb_case_status=create ddlb_case_status
this.ddlb_source_type=create ddlb_source_type
this.cbx_all=create cbx_all
this.st_5=create st_5
this.cb_category_details=create cb_category_details
this.ddlb_case_type=create ddlb_case_type
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.b_calendar_from=create b_calendar_from
this.b_calendar_to=create b_calendar_to
this.st_report_subject=create st_report_subject
this.em_from=create em_from
this.em_to=create em_to
this.st_from=create st_from
this.st_to=create st_to
this.st_case_type=create st_case_type
this.gb_date_range=create gb_date_range
this.dw_category_org=create dw_category_org
this.dw_user_list=create dw_user_list
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_parameters
this.Control[iCurrent+2]=this.rb_case_numbers
this.Control[iCurrent+3]=this.st_category
this.Control[iCurrent+4]=this.sle_case_number
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cbx_allcasetypes
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.ddlb_case_status
this.Control[iCurrent+9]=this.ddlb_source_type
this.Control[iCurrent+10]=this.cbx_all
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.cb_category_details
this.Control[iCurrent+13]=this.ddlb_case_type
this.Control[iCurrent+14]=this.cb_cancel
this.Control[iCurrent+15]=this.cb_ok
this.Control[iCurrent+16]=this.b_calendar_from
this.Control[iCurrent+17]=this.b_calendar_to
this.Control[iCurrent+18]=this.st_report_subject
this.Control[iCurrent+19]=this.em_from
this.Control[iCurrent+20]=this.em_to
this.Control[iCurrent+21]=this.st_from
this.Control[iCurrent+22]=this.st_to
this.Control[iCurrent+23]=this.st_case_type
this.Control[iCurrent+24]=this.gb_date_range
this.Control[iCurrent+25]=this.dw_category_org
this.Control[iCurrent+26]=this.dw_user_list
this.Control[iCurrent+27]=this.ln_1
end on

on w_case_detail_parms.destroy
call super::destroy
destroy(this.rb_parameters)
destroy(this.rb_case_numbers)
destroy(this.st_category)
destroy(this.sle_case_number)
destroy(this.st_2)
destroy(this.cbx_allcasetypes)
destroy(this.st_1)
destroy(this.ddlb_case_status)
destroy(this.ddlb_source_type)
destroy(this.cbx_all)
destroy(this.st_5)
destroy(this.cb_category_details)
destroy(this.ddlb_case_type)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.b_calendar_from)
destroy(this.b_calendar_to)
destroy(this.st_report_subject)
destroy(this.em_from)
destroy(this.em_to)
destroy(this.st_from)
destroy(this.st_to)
destroy(this.st_case_type)
destroy(this.gb_date_range)
destroy(this.dw_category_org)
destroy(this.dw_user_list)
destroy(this.ln_1)
end on

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//  Event:   pc_setoptions
//  Purpose: To set User Object options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/10/02 C. Jackson  Original Version
//***********************************************************************************************

STRING l_cStringDate, l_cSuperLogin, l_cDeptID, l_cDateParm
LONG l_nDeptRow, l_nRtn, l_nRow
DATAWINDOWCHILD	ldwc_FieldList
CONSTANT	INTEGER	l_nMaxLevels = 5
STRING	l_cParentCategoryID, l_cTableName,l_cWhereClause
INTEGER	l_nIndex


fw_SetOptions (c_NoEnablePopup)

ddlb_source_type.Enabled = FALSE
em_from.Enabled = FALSE
em_to.Enabled = FALSE
ddlb_case_status.Enabled = FALSE
ddlb_case_type.Enabled = FALSE
dw_user_list.Enabled = FALSE
cbx_all.Enabled = FALSE
dw_category_org.Enabled = FALSE
cbx_allcasetypes.Enabled = FALSE
b_calendar_from.Enabled = FALSE
b_calendar_to.Enabled = FALSE
cb_category_details.Enabled = FALSE

sle_case_number.Enabled = TRUE
sle_case_number.SetFocus()

// Build the User/Dept Tree View
dw_user_list.fu_HLRetrieveOptions (1, &
		"smallminus.bmp", &
		"smallplus.bmp", &
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		" ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept", & 
		"cusfocus.cusfocus_user_dept.active <> 'N'", & 
		dw_user_list.c_KeyString )

dw_user_list.fu_HLRetrieveOptions (2, &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.user_id", & 
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user", & 
		"cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id AND " + &
		"cusfocus.cusfocus_user.active <> 'N'", & 
		dw_user_list.c_KeyString + dw_user_list.c_BMPFromColumn)
	
dw_user_list.fu_HLOptions(dw_user_list.c_MultiSelect + dw_user_list.c_ShowLines)

dw_user_list.fu_HLCreate (SQLCA, 2)

// Build the User/Dept Tree View
FOR l_nIndex = 1 TO l_nMaxLevels
	IF l_nIndex = 1 THEN
		l_cTableName = "cusfocus.categories"
		l_cParentCategoryID = ""
			l_cWhereClause = l_cTableName + ".category_level = 1 AND " + &
								  l_cTableName + ".case_type = 'I'"
	ELSE
		l_cTableName = "cusfocus.category_" + STRING (l_nIndex - 1) + "_vw"
		l_cParentCategoryID = l_cTableName + ".prnt_category_id"
		l_cWhereClause = l_cTableName + ".case_type = 'I'"
	END IF
	
	// define retrieval options for all levels
	dw_category_org.fu_HLRetrieveOptions (l_nIndex, &
		"open.bmp", "closed.bmp", l_cTableName + ".category_id", + &
		l_cParentCategoryID, l_cTableName + ".category_name", &
		l_cTableName + ".category_name", l_cTableName, &
		l_cWhereClause, dw_category_org.c_KeyString)
NEXT

dw_category_org.fu_HLOptions(dw_category_org.c_ShowLines)

dw_category_org.fu_HLCreate (SQLCA, l_nMaxLevels)

//dw_category_org.fu_HLSetSelectedRow(1)

i_nSelectedCat = 1

dw_user_list.fu_HLOptions(dw_user_list.c_SingleSelect + dw_user_list.c_ShowLines)

l_nIndex = ddlb_case_type.FindItem ( 'configurable', 0)
ddlb_case_type.DeleteItem ( l_nIndex )
ddlb_case_type.InsertItem ( gs_ConfigCaseType,  l_nIndex )
ddlb_case_status.SelectItem (2)
ddlb_case_type.SelectItem (2)

end event

event pc_closequery;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Perform final window processing and determine if Close process should continue.
//
//  Date     Developer    Description
//  -------- ----------- -----------------------------------------------------------------------
//  12/10/02 C. Jackson   Original Version
//  07/03/03 M. Caruso    Changed the comparison value for ddlb_case_status.text from 'Close' to
//								  'Closed' which matches the value in the list box.
//**********************************************************************************************


STRING	l_cStartDate, l_cEndDate, l_cBlankDate = '00/00/0000', l_cKeys[], l_cSelectedKeys[]
STRING   l_cResetArray[]
LONG     l_nIndex, l_nLastRow, l_nNumSelected, l_nRtn, l_nArraySize

l_nArraySize = UPPERBOUND(i_cCaseString[])

IF i_bOK THEN

		IF rb_parameters.Checked = TRUE THEN
			i_sReportParms.case_selected = 'N'
	
				l_cStartDate = em_from.Text
				l_cEndDate = em_to.Text
				
				// validate subject selection
				IF i_cUserorDept = '' OR IsNull(i_cUserorDept) THEN
					
					MessageBox (gs_appname, 'You must select a User or Department from the list.')
					Error.i_FWError = c_Fatal
					RETURN 0
					
				ELSE
					
					l_nLastRow = dw_user_list.RowCount()
					l_nIndex = 1
					l_nNumSelected = 0
					
					IF cbx_all.Checked = FALSE THEN
						DO
						  l_nIndex = dw_user_list.fu_HLGetSelectedRow(l_nIndex)
						  
						  IF l_nIndex > 0 THEN
							 l_nNumSelected = l_nNumSelected + 1
							 
							 dw_user_list.fu_HLGetRowKey(l_nIndex, l_cKeys[])
							 
							 i_sReportParms.user_array[l_nNumSelected] = l_cKeys[UPPERBOUND(l_cKeys)]
							 
							 l_nIndex = l_nIndex + 1
							 
							 IF l_nIndex > l_nLastRow THEN
								l_nIndex = 0
							 END IF
							 
						  END IF
						  
						LOOP UNTIL l_nIndex = 0
				
					END IF
					
				END IF
				
				// if a custom date range is specified and either date is not set, notify the user
				IF l_cStartDate = l_cBlankDate THEN
					
					IF l_cEndDate = l_cBlankDate THEN
						MessageBox (gs_appname, 'You must specify Begin and End dates.')
					ELSE
						MessageBox (gs_appname, 'You must specify a Begin Date.')
					END IF
					Error.i_FWError = c_Fatal
					em_from.SetFocus ()
					RETURN 0
					
				ELSE
					
					IF l_cEndDate = l_cBlankDate THEN
				
						// if a custom date range is specified and either date is not set, notify the user
						MessageBox (gs_appname, 'You must specify an end date.')
						Error.i_FWError = c_Fatal
						em_to.SetFocus ()
						RETURN 0
						
					ELSE
					
						IF DaysAfter(Date(l_cEndDate),Date(l_cStartDate)) > 0 THEN
							messagebox(gs_AppName, 'The End Date must be greater than the Begin Date.')
							Error.i_FWError = c_Fatal
							em_to.SetFocus()
							RETURN 0
						END IF			
						
					END IF
					
					
				END IF
					
				// determine the specified date range
				fw_CalcDateRange ()
				
				// convert date to string to pass to stored procedure
				l_cStartDate = STRING(i_dtStartDate)
				l_cEndDate = STRING(i_dtEndDate)
				
				IF DaysAfter(DATE(i_dtStartDate), DATE(i_dtEndDate)) > 5 THEN
					l_nRtn = MessageBox(gs_AppName, 'Too large a date range may result in Out of Memory error.  Do you wish to continue?'	, Question!, OKCancel!, 2 )
					IF l_nRtn = 2 THEN
						Error.i_FWError = c_Fatal
						em_from.SetFocus ()
						RETURN 0
					END IF
					
				END IF
			
				
				IF cbx_all.Checked = TRUE OR i_cUserorDept = 'A' THEN
					l_nRtn = MessageBox(gs_AppName, 'Not specifying a user or department may result in Out of Memory error.  Do you wish to continue?'	, Question!, OKCancel!, 2 )
					IF l_nRtn = 2 THEN
						Error.i_FWError = c_Fatal
						dw_user_list.SetFocus ()
						RETURN 0
					END IF
				END IF
				
				IF cbx_allcasetypes.Checked = TRUE THEN
					l_nRtn = MessageBox(gs_AppName, 'Not specifying a category may result in Out of Memory error.  Do you wish to continue?'	, Question!, OKCancel!, 2 )
					IF l_nRtn = 2 THEN
						Error.i_FWError = c_Fatal
						dw_category_org.SetFocus ()
						RETURN 0
					END IF
				END IF
			
				
				// set the return values based on the settings in the window.
				i_sReportParms.user_or_dept = i_cUserorDept
				
				CHOOSE CASE ddlb_case_status.text
					CASE 'Open'
						i_sReportParms.case_status = 'O'
					CASE 'Closed'
						i_sReportParms.case_status = 'C'
					CASE ELSE
						i_sReportParms.case_status = 'V'
				END CHOOSE
				
				CHOOSE CASE ddlb_source_type.text
					CASE 'Employer Group' 
						i_sReportParms.source_type = 'E'
					CASE 'Member' 
						i_sReportParms.source_type = 'C'
					CASE ELSE
						i_sReportParms.source_type = 'P'
				END CHOOSE
				
				CHOOSE CASE ddlb_case_type.text
					CASE gs_ConfigCaseType
						i_sReportParms.case_type = 'M'
					CASE 'Issue/Concern'
						i_sReportParms.case_type = 'C'
					CASE 'Inquiry'
						i_sReportParms.case_type = 'I'
					CASE ELSE
						i_sReportParms.case_type = 'P'
				END CHOOSE
				
				IF i_sReportParms.category_id <> 'All' AND ( IsNull(w_case_detail_parms.i_sReportParms.category_array[1]) OR &
					  w_case_detail_parms.i_sReportParms.category_array[1] = '' ) THEN
					  i_sReportParms.category_array[1] = i_sReportParms.category_id
				END IF
					
				i_sReportParms.user_list = i_cUserList
				
				IF i_sReportParms.user_list = 'All' THEN
					i_sReportParms.user_or_dept = 'A'
				END IF
				
				i_sReportParms.start_date = i_dtStartDate
				i_sReportParms.end_date = i_dtEndDate
				
				IF i_sReportParms.category_id = 'All' THEN
					i_sReportParms.category_selected = 'N'
				ELSE
					i_sReportParms.category_selected = 'Y'
				END IF
			
	ELSE
		
			
		IF IsNull(i_sReportParms.case_number[1]) OR i_sReportParms.case_number[1] = '' THEN
			messagebox(gs_AppName,'You must enter at least one case number.')
			sle_case_number.SetFocus()
					Error.i_FWError = c_Fatal
					RETURN 0
					
			// Clear out the case number array
			i_sReportParms.case_number = l_cResetArray

		END IF
		
		i_sReportParms.case_selected = 'Y'
				
		// set blank return values
		SetNull(i_sReportParms.user_or_dept)
		SetNull(i_sReportParms.source_type)
		SetNull(i_sReportParms.case_status)
		SetNull(i_sReportParms.user_list)
		SetNull(i_sReportParms.case_type)
		SetNull(i_sReportParms.user_list)
		SetNull(i_sReportParms.start_date)
		SetNull(i_sReportParms.end_date)
		
	END IF
		
			
END IF
end event

event pc_close;call super::pc_close;//**********************************************************************************************
//
//  Event:   pc_close
//  Purpose: Pass the return values via Message.
//
//  Date     Developer    Description
//  -------- ----------- -----------------------------------------------------------------------
//  12/10/02 C. Jackson   Original Version
//**********************************************************************************************


message.PowerObjectParm = i_sReportParms
end event

type rb_parameters from radiobutton within w_case_detail_parms
integer x = 1093
integer y = 48
integer width = 672
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Designate Parameters"
end type

event clicked;//*****************************************************************************************
//
//  Event:   clicked
//  Purpose: To enable/disable specific fields
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//  02/21/03 C. Jackson  Original Version
//*****************************************************************************************


sle_case_number.Enabled = FALSE
sle_case_number.text = ''

ddlb_source_type.Enabled = TRUE
em_from.Enabled = TRUE
em_to.Enabled = TRUE
ddlb_case_status.Enabled = TRUE
ddlb_case_type.Enabled = TRUE
dw_user_list.Enabled = TRUE
cbx_all.Enabled = TRUE
dw_category_org.Enabled = TRUE
cbx_allcasetypes.Enabled = TRUE
b_calendar_from.Enabled = TRUE
b_calendar_to.Enabled = TRUE
cb_category_details.Enabled = TRUE

ddlb_source_type.SetFocus()

dw_category_org.fu_HLSetSelectedRow(1)
dw_user_list.fu_HLSetSelectedRow(1)
		
i_cSourceType = 'C'		

ddlb_source_type.SelectItem ('Member',0)



end event

type rb_case_numbers from radiobutton within w_case_detail_parms
integer x = 402
integer y = 56
integer width = 590
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "List Case Numbers"
boolean checked = true
end type

event clicked;//*****************************************************************************************
//
//  Event:   clicked
//  Purpose: To enable/disable specific fields
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//  02/21/03 C. Jackson  Original Version
//*****************************************************************************************

ddlb_source_type.Enabled = FALSE
em_from.text = '00/00/0000'
em_from.Enabled = FALSE
em_to.text = '00/00/0000'
em_to.Enabled = FALSE
ddlb_case_status.Enabled = FALSE
ddlb_case_type.Enabled = FALSE
dw_user_list.Enabled = FALSE
cbx_all.Enabled = FALSE
dw_category_org.Enabled = FALSE
cbx_allcasetypes.Enabled = FALSE
b_calendar_from.Enabled = FALSE
b_calendar_to.Enabled = FALSE
cb_category_details.Enabled = FALSE

sle_case_number.Enabled = TRUE
sle_case_number.SetFocus()

dw_category_org.fu_HLClearSelectedRows()
dw_user_list.fu_HLClearSelectedRows()

end event

type st_category from statictext within w_case_detail_parms
integer x = 1111
integer y = 920
integer width = 553
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Category:"
boolean focusrectangle = false
end type

type sle_case_number from singlelineedit within w_case_detail_parms
integer x = 55
integer y = 264
integer width = 2181
integer height = 96
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_case_detail_parms
integer x = 55
integer y = 188
integer width = 498
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Number(s):  "
boolean focusrectangle = false
end type

type cbx_allcasetypes from checkbox within w_case_detail_parms
integer x = 1687
integer y = 908
integer width = 567
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All for Case Type"
end type

event clicked;//**********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To enable/disable Department outliner
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  04/30/02 C. Jackson  Original Version
//**********************************************************************************************

IF this.Checked THEN
	
	dw_category_org.fu_HLClearSelectedRows()
	dw_category_org.Enabled = FALSE
	i_sReportParms.category_id = 'All'
	i_sReportParms.category_selected = 'N'
	cb_category_details.Enabled = FALSE
	st_category.Text = ' All for '+ddlb_case_type.text
	
	
ELSE
	
	dw_category_org.Enabled = TRUE
	dw_category_org.fu_HLSetSelectedRow(i_nSelectedCat)
	cb_category_details.Enabled = TRUE
	i_sReportParms.category_selected = 'Y'

END IF
end event

type st_1 from statictext within w_case_detail_parms
integer x = 1111
integer y = 544
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Case Status:"
boolean focusrectangle = false
end type

type ddlb_case_status from dropdownlistbox within w_case_detail_parms
integer x = 1111
integer y = 616
integer width = 1129
integer height = 400
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"Open","Closed","Void"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_source_type from dropdownlistbox within w_case_detail_parms
integer x = 55
integer y = 488
integer width = 983
integer height = 400
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"Member","Provider","Employer Group"}
borderstyle borderstyle = stylelowered!
end type

type cbx_all from checkbox within w_case_detail_parms
integer x = 713
integer y = 908
integer width = 325
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All CSRs"
end type

event clicked;//**********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To enable/disable Department outliner
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  04/30/02 C. Jackson  Original Version
//**********************************************************************************************

IF this.Checked THEN
	
	dw_user_list.fu_HLClearSelectedRows()
	dw_user_list.Enabled = FALSE
	i_cUserorDept = 'A'
	i_cuserlist = 'All'
ELSE
	
	dw_user_list.Enabled = TRUE
	SetNull(i_cuserlist)
	dw_user_list.fu_HLSetSelectedRow(i_nSelectedUsr)
	
END IF

IF i_nSelectedLevel = 1 THEN
	i_cUserorDept = 'D'
ELSE
	i_cUserorDept = 'U'
END IF
end event

type st_5 from statictext within w_case_detail_parms
integer x = 55
integer y = 412
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Source Type:"
boolean focusrectangle = false
end type

type cb_category_details from commandbutton within w_case_detail_parms
integer x = 2267
integer y = 1844
integer width = 110
integer height = 80
integer taborder = 130
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Open the details datawindow for categories
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//  06/03/02 C. Jackson  Disable ddlb_case_type is multiple categories
//**********************************************************************************************

LONG l_nSelected

FWCA.MGR.fu_OpenWindow(w_category_details, 0) 

IF UpperBound( i_sReportParms.category_array ) > 0 THEN	
	
	// Disable the outliner if multiple have been selected
	l_nSelected = 1
	l_nSelected = dw_category_org.fu_HLGetSelectedRow(l_nSelected)

	IF l_nSelected > 0 THEN
		//Need to deselect all rows in Category Outliner
		dw_category_org.fu_HLClearSelectedRows()

	END IF
	
	dw_category_org.Enabled = FALSE	
	ddlb_case_type.Enabled = FALSE
	IF POS(st_category.Text,"(") = 0 THEN
		st_category.Text = 'Multiple selected'
	END IF		
	cbx_allcasetypes.Enabled = FALSE
	
ELSE
	
	st_category.text = 'Category:'
	dw_category_org.Enabled = TRUE
	ddlb_case_type.Enabled = TRUE
	
	l_nSelected = 1
	l_nSelected = dw_category_org.fu_HLGetSelectedRow(l_nSelected)
	
	IF l_nSelected = 0 THEN
		// If there are no rows selected then select the first
		dw_category_org.fu_HLSetSelectedRow(1)
	END IF
	
	cbx_allcasetypes.Enabled = TRUE


END IF



end event

type ddlb_case_type from dropdownlistbox within w_case_detail_parms
integer x = 1111
integer y = 788
integer width = 1129
integer height = 448
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"Configurable","Inquiry","Issue/Concern","Proactive"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;//*******************************************************************************************
//
//  Event:   selectionchanged
//  Purpose: Update the contents of the category tree control based on the new selection.
//  
//  Date     Developer   Desription
//  -------- ----------- --------------------------------------------------------------------
//  03/18/02 C. Jackson  Original Version
//*******************************************************************************************

// Initialize dw_category_org for the new case type.

st_category.Text = ''

CHOOSE CASE This.Text(index)
		
	CASE "Inquiry"
		i_cCaseType = "I"
		
	CASE "Issue/Concern"
		i_cCaseType = "C"
		
	CASE "Proactive"
		i_cCaseType = "P"
		
	CASE ELSE
		i_cCaseType = "M"
		
END CHOOSE

fw_initcategory (i_cCaseType)

cbx_allcasetypes.Checked = FALSE
st_category.text = ''



end event

type cb_cancel from commandbutton within w_case_detail_parms
integer x = 1925
integer y = 1948
integer width = 320
integer height = 76
integer taborder = 150
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process the Cancel button

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/10/02 C. Jackson  Original Version
*****************************************************************************************/

STRING l_cResetArray[]

// Clear out the case number array
i_sReportParms.case_number = l_cResetArray

i_bOK = FALSE
Close (PARENT)
end event

type cb_ok from commandbutton within w_case_detail_parms
integer x = 1577
integer y = 1948
integer width = 320
integer height = 76
integer taborder = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Process the OK button
//
//  Date     Developer    Description
//  -------- ----------- -----------------------------------------------------------------------
//  12/10/02 C. Jackson   Original Version
//**********************************************************************************************

STRING l_cGroupId, l_cProfID
DATE l_dStartDate, l_dEndDate
BOOLEAN	l_bBadData = FALSE
LONG l_nSelectedRows1[], l_nSelectedRows2[], l_nSelectedRows3[], l_nIndex, l_nSelected
LONG l_nLength, l_nRtn

IF rb_parameters.Checked = TRUE THEN
	// Validate parameters
	l_dStartDate = DATE(em_from.Text)
	l_dEndDate = DATE(em_to.Text)
	
	IF YEAR(l_dStartDate) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid start date.')
		em_from.SetFocus()
		l_bBadData = TRUE
		
	ELSEIF YEAR(l_dEndDate) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid end date.')
		em_to.SetFocus()
	
		l_bBadData = TRUE
	END IF

ELSE
	// Make sure there is a case number specified
	fw_case_number(sle_case_number.text)

	IF rb_case_numbers.Checked = TRUE THEN
		i_sReportParms.case_number = i_ccasestring[]
	END IF
	
END IF	
	
IF NOT i_bMultiCategory THEN
	i_sReportParms.category_array[1] = i_cSingleCategory
END IF
	
	
IF l_bBadData THEN
	RETURN
ELSE
	i_bOK = TRUE
	CloseWithReturn (PARENT, i_sReportParms)
END IF


end event

type b_calendar_from from commandbutton within w_case_detail_parms
integer x = 859
integer y = 656
integer width = 110
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the calendar window to allow for date selection
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/10/02 C. Jackson  Original Version
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = PARENT.X + THIS.X
l_nY = PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX )
l_cY = String( l_nY + l_nHeight )

l_cCalendarDate = em_from.Text
IF l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's not a valid set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

i_dFromDate = l_dtCalendarDate
i_dToDate = date(em_to.text)

// Validate the value against the TO field
IF (em_to.Text <> '00/00/0000') AND (i_dToDate < i_dFromDate) THEN
	
	messagebox(gs_AppName,'Begin Date must be less than End Date.')
	em_from.SetFocus()
	
ELSE

	//Add the date to the datawindow
	em_from.Text = string(l_dtCalendarDate)
	
	//Move the cursor to the next field
	em_to.SetFocus()

END IF


end event

type b_calendar_to from commandbutton within w_case_detail_parms
integer x = 859
integer y = 780
integer width = 110
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the calendar window to allow for date selection
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/10/02 C. Jackson  Original Version
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = PARENT.X + THIS.X
l_nY = PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX )
l_cY = String( l_nY + l_nHeight )

//Only one button(calendar) so open the calendar window
l_cCalendarDate = em_to.Text
IF l_cCalendarDate = 'none' OR l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's not a valid date set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

i_dToDate = l_dtCalendarDate

IF em_from.Text = '00/00/0000' THEN
	messagebox(gs_AppName,'A Begin Date is required.')
	em_from.SetFocus()
END IF
IF i_dFromDate > i_dToDate THEN
	messagebox(gs_AppName,'The End Date must be greater than the Begin Date.')
	em_to.SetFocus()
ELSE
	//Add the date to the datawindow
	em_to.Text = string(l_dtCalendarDate)
END IF

end event

type st_report_subject from statictext within w_case_detail_parms
integer x = 55
integer y = 920
integer width = 503
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Department/User:"
boolean focusrectangle = false
end type

type em_from from editmask within w_case_detail_parms
integer x = 466
integer y = 656
integer width = 379
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "00/00/0000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type em_to from editmask within w_case_detail_parms
integer x = 466
integer y = 772
integer width = 379
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "00/00/0000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type st_from from statictext within w_case_detail_parms
integer x = 137
integer y = 664
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Start Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_to from statictext within w_case_detail_parms
integer x = 183
integer y = 788
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "End Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_case_type from statictext within w_case_detail_parms
integer x = 1111
integer y = 716
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Case Type:"
boolean focusrectangle = false
end type

type gb_date_range from groupbox within w_case_detail_parms
integer x = 55
integer y = 584
integer width = 983
integer height = 304
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
end type

type dw_category_org from u_outliner_std within w_case_detail_parms
integer x = 1111
integer y = 992
integer width = 1129
integer height = 932
integer taborder = 120
boolean bringtotop = true
boolean hscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event po_pickedrow;//********************************************************************************************
//
//  Event:   po_pickedrow
//  Purpose: Retrieve the details of the selected row into the detail datawindow.
//
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  03/18/02 C. Jackson  Original Version
//********************************************************************************************

STRING	l_cKeys[]
LONG		l_nLevel, l_nRow

// If this event was trigger by another function/event then set defaults.
IF IsNull (clickedlevel) THEN
	l_nLevel = 1
	l_nRow = 1
ELSE
	l_nLevel = clickedlevel
	l_nRow = clickedrow
END IF

// Get the key of the Picked Row and view it's details
fu_HLGetRowKey(l_nRow, l_cKeys[])
i_cSingleCategory = l_cKeys[l_nLevel]

i_nSelectedCat = l_nRow




end event

event po_validaterow;call super::po_validaterow;//********************************************************************************************
//
//  Event:   po_ValidateRow
//  Purpose: Provides an opportunity for the developer to validate a previously selected row 
//           before moving on with the currently selected row.
//
//  Parameters: LONG    ClickedRow - Row number of the new record.
//              INTEGER ClickedLevel - Level of the new record.
//              LONG    SelectedRow - Row number of the currently selected record.
//              INTEGER SelectedLevel - Level of the currently selected record.
//              INTEGER MaxLevels - Maximum levels for outliner.
//
//   Return Value: i_RowError - Indicates if an error has occured in the processing of this event.  
//	              Return -1 to stop the new row from becoming the current row.
//					  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  03/18/02 C. Jackson  Original version
//********************************************************************************************

STRING	l_cKeys1[], l_cKeys2[]
INTEGER	l_nNumKeys1, l_nNumKeys2
BOOLEAN	l_bHasChildren

// Check if the current row has visible children.
IF selectedrow = 0 THEN selectedrow = 1

l_nNumKeys1 = fu_HLGetRowKey (selectedrow, l_cKeys1[])
l_nNumKeys2 = fu_HLGetRowKey (selectedrow + 1, l_cKeys2[])
IF l_nNumKeys2 > l_nNumKeys1 THEN
	
	IF l_cKeys1[l_nNumKeys1] = l_cKeys2[l_nNumKeys1] THEN
		l_bHasChildren = TRUE
	ELSE
		l_bHasChildren = FALSE
	END IF
	
ELSE
	
	l_bHasChildren = FALSE
	
END IF

// If the current row does not have visible children, collapse that row.
IF NOT l_bHasChildren THEN
	
	i_ClickedRow = selectedrow
	fu_HLCollapseBranch ()
	i_ClickedRow = clickedrow
	
END IF
end event

event po_selectedrow;//**********************************************************************************************
//
//  Event:   po_selectedrow
//  Purpose: Store the key information about the current category.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/18/02 C. Jackson  Original Version
//**********************************************************************************************

STRING	l_cKeys[], l_cCurrentKey
INTEGER	l_nLevel

// get the level
i_scurrentcategory.level = selectedlevel

// get the category ID
fu_HLGetRowKey (SelectedRow, l_cKeys[])
i_scurrentcategory.category_id = l_cKeys[i_scurrentcategory.level]

i_sReportParms.category_id = i_scurrentcategory.category_id

// get the parent ID case_type and lineage
SELECT prnt_category_id, case_type, category_lineage
  INTO :i_scurrentcategory.parent_id, :i_scurrentcategory.case_type, :i_scurrentcategory.lineage
  FROM cusfocus.categories
 WHERE category_id = :i_scurrentcategory.category_id
 USING SQLCA;
 

end event

type dw_user_list from u_outliner_std within w_case_detail_parms
integer x = 55
integer y = 992
integer width = 983
integer height = 932
integer taborder = 70
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
end type

event po_pickedrow;call super::po_pickedrow;/*****************************************************************************************
   Event:      po_pickedrow
   Purpose:    

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/10/02 C. Jackson  Original Version
*****************************************************************************************/

// determine the subject type
IF clickedlevel = 1 THEN
	
	i_cUserorDept = 'D'
	
ELSE

	i_cUserorDept = 'U'
	
END IF

i_nSelectedLevel = clickedlevel
i_nSelectedUsr = clickedrow
end event

type ln_1 from line within w_case_detail_parms
integer linethickness = 1
integer beginx = 55
integer beginy = 396
integer endx = 2235
integer endy = 396
end type

