$PBExportHeader$w_docs_full_interface.srw
$PBExportComments$Documents Full Interface
forward
global type w_docs_full_interface from w_main_std
end type
type st_4 from statictext within w_docs_full_interface
end type
type p_1 from picture within w_docs_full_interface
end type
type st_3 from statictext within w_docs_full_interface
end type
type st_2 from statictext within w_docs_full_interface
end type
type st_1 from statictext within w_docs_full_interface
end type
type dw_doc_type from u_dw_std within w_docs_full_interface
end type
type dw_search_criteria from u_dw_search within w_docs_full_interface
end type
type dw_matched_records from u_dw_std within w_docs_full_interface
end type
type gb_criteria from groupbox within w_docs_full_interface
end type
type ln_1 from line within w_docs_full_interface
end type
type ln_2 from line within w_docs_full_interface
end type
type ln_3 from line within w_docs_full_interface
end type
type ln_4 from line within w_docs_full_interface
end type
end forward

global type w_docs_full_interface from w_main_std
integer width = 3671
integer height = 2124
string title = "Documents Full Interface"
string menuname = "m_docs_full_interface"
st_4 st_4
p_1 p_1
st_3 st_3
st_2 st_2
st_1 st_1
dw_doc_type dw_doc_type
dw_search_criteria dw_search_criteria
dw_matched_records dw_matched_records
gb_criteria gb_criteria
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
end type
global w_docs_full_interface w_docs_full_interface

type prototypes
FUNCTION long ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "SHELL32.DLL" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
STRING i_cSearchColumn[]
STRING i_cSearchTable[]
STRING i_cMatchColumn[]
STRING i_cOpenDocs[]
STRING i_cDocID
STRING i_cUserID

LONG i_nDocCounter

BOOLEAN i_bOutOfOffice


end variables

forward prototypes
public subroutine fw_checkoutofoffice ()
public subroutine fw_clearsearch ()
end prototypes

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
	m_docs_full_interface.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_docs_full_interface.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
END IF







end subroutine

public subroutine fw_clearsearch ();/**************************************************************************************

				Function:		fw_clearsearch
				Purpose:			To clear the search criteria for a new search
				Parameters:		None
				Returns:			None
	
*************************************************************************************/

string ls_test, ls_syntax
//-------------------------------------------------------------------------------------
//		Clear the Search Criteria
//-------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------

// I can't figure out where the heck the where clause gets built in this thing, so I am just doing a big manual
// reset of the syntax when the clearsearch function is called. This is to fix a bug where the doc_type_id wasn't
// getting cleared before it moved on to the next search. So it would be searching where doc_type_id = 53 and doc_type_id = 6
// which will never return rows. This was only happening after opening a document, so there is your info if you want to 
// fix it the right way. I don't have enough time.
//-----------------------------------------------------------------------------------------------------------------------------------

dw_matched_records.i_SQLSelect = 'SELECT cusfocus.documents.doc_id,   ' + &
'         cusfocus.documents.doc_type_id,   ' + &
'         cusfocus.documents.doc_name,   ' + &
'         cusfocus.documents.doc_desc,   ' + &
'         cusfocus.documents.doc_create_dt,   ' + &
'         cusfocus.documents.doc_orig_dt,   ' + &
'         cusfocus.documents.doc_expire_dt,   ' + &
'         cusfocus.documents.doc_version,   ' + &
'         cusfocus.documents.doc_status_id,   ' + &
'         cusfocus.documents.doc_general_flag,   ' + &
'         cusfocus.documents.updated_by,   ' + &
'         cusfocus.documents.updated_timestamp, ' + &  
'         cusfocus.documents.doc_config_1,   ' + &
'         cusfocus.documents.doc_config_2,   ' + &
'         cusfocus.documents.doc_config_3,   ' + &
'         cusfocus.documents.doc_config_4,   ' + &
'        cusfocus.documents.doc_config_5,   ' + &
'         cusfocus.documents.doc_config_6,   ' + &
'         cusfocus.documents.doc_config_7,   ' + &
'         cusfocus.documents.doc_config_8,   ' + &
'         cusfocus.documents.doc_config_9,   ' + &
'         cusfocus.documents.doc_config_10,   ' + &
'         cusfocus.document_types.doc_type_desc,   ' + &
'         cusfocus.document_status.doc_status_desc,   ' + &
'         cusfocus.documents.doc_filename,   ' + &
'         cusfocus.documents.doc_image_flag,   ' + &
'         cusfocus.cusfocus_user.active,   ' + &
'         cusfocus.documents.link  ' + &
'    FROM cusfocus.document_status,   ' + &
'         cusfocus.document_types,   ' + &
'         cusfocus.documents,   ' + &
'         cusfocus.cusfocus_user  ' + &
'   WHERE ( cusfocus.document_types.doc_type_id = cusfocus.documents.doc_type_id ) and  ' + &
'         ( cusfocus.document_status.doc_status_id = cusfocus.documents.doc_status_id ) and  ' + &
'         ( cusfocus.documents.updated_by = cusfocus.cusfocus_user.user_id )    '


dw_matched_records.fu_searchReset()
dw_search_criteria.fu_Reset()

dw_search_criteria.SetFocus()


end subroutine

on w_docs_full_interface.create
int iCurrent
call super::create
if this.MenuName = "m_docs_full_interface" then this.MenuID = create m_docs_full_interface
this.st_4=create st_4
this.p_1=create p_1
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_doc_type=create dw_doc_type
this.dw_search_criteria=create dw_search_criteria
this.dw_matched_records=create dw_matched_records
this.gb_criteria=create gb_criteria
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_doc_type
this.Control[iCurrent+7]=this.dw_search_criteria
this.Control[iCurrent+8]=this.dw_matched_records
this.Control[iCurrent+9]=this.gb_criteria
this.Control[iCurrent+10]=this.ln_1
this.Control[iCurrent+11]=this.ln_2
this.Control[iCurrent+12]=this.ln_3
this.Control[iCurrent+13]=this.ln_4
end on

on w_docs_full_interface.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.p_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_doc_type)
destroy(this.dw_search_criteria)
destroy(this.dw_matched_records)
destroy(this.gb_criteria)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
end on

event pc_setcodetables;call super::pc_setcodetables;//****************************************************************************************
//
//		Event:	pc_setddlb
//		Purpose:	To populate the Case Type DropDown List Boxes.
//
//****************************************************************************************/

LONG l_nReturn 

//-------------------------------------------------------------------------------------
//
//		Populate the Case Type DropDown List Bow.
//
//--------------------------------------------------------------------------------------

//l_nReturn = dw_search_criteria.fu_LoadCode("doc_status_id","cusfocus.document_status", &
//									"doc_status_id", "doc_status_desc", "Active='Y'", "(All)")
 


end event

event pc_setoptions;call super::pc_setoptions;//****************************************************************************************
//
//        Event: pc_setwindow
//      Purpose: To initialize the search object, wire it to the matched records 
//						data window, populate the cusfocus user dropdown and to get the 
//						users first name, last name and mi.
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//  03/24/00 C. Jackson  Removed dw_search_criteria.InsertRow(0)
//  03/30/00 C. Jackson  Corrected typo in the search initialization array
//  03/31/00 C. Jackson  Removed document_ownership from initialization array
//  01/14/01 cjackosn    Add resize
//
//****************************************************************************************/

STRING l_cFirstName, l_cLastName, l_cMI
DATAWINDOWCHILD l_dwcDocType, l_dwcLetterCat

fw_SetOptions(c_default + c_ToolBarTop)	

dw_doc_type.SetTransObject(SQLCA)
dw_doc_type.Retrieve()

//dw_search_criteria.insertrow(0) - CAJ don't need to insert a row, only causes search to not work
dw_search_criteria.Visible = TRUE

//--------------------------------------------------------------------------------------
//
//			Initialize the Search Column, Search Table and Match Column arrays.
//
//--------------------------------------------------------------------------------------

i_cSearchColumn[1] = 'documents_doc_type_id'
i_cSearchColumn[2] = 'documents_doc_name'
i_cSearchColumn[3] = 'documents_doc_desc'
i_cSearchColumn[4] = 'documents_doc_create_dt'
i_cSearchColumn[5] = 'documents_doc_orig_dt'
i_cSearchColumn[6] = 'documents_doc_expire_dt'
i_cSearchColumn[7] = 'documents_doc_version'
i_cSearchColumn[8] = 'documents_doc_status_id'
i_cSearchColumn[9] = 'documents_doc_general_flag'
i_cSearchColumn[10] = 'documents_doc_config_1'
i_cSearchColumn[11] = 'documents_doc_config_2'
i_cSearchColumn[12] = 'documents_doc_config_3'
i_cSearchColumn[13] = 'documents_doc_config_4'
i_cSearchColumn[14] = 'documents_doc_config_5'
i_cSearchColumn[15] = 'documents_doc_config_6'
i_cSearchColumn[16] = 'documents_doc_config_7'
i_cSearchColumn[17] = 'documents_doc_config_8'
i_cSearchColumn[18] = 'documents_doc_config_9'
i_cSearchColumn[19] = 'documents_doc_config_10'

i_cSearchTable[1] = 'cusfocus.documents'
i_cSearchTable[2] = 'cusfocus.documents'
i_cSearchTable[3] = 'cusfocus.documents'
i_cSearchTable[4] = 'cusfocus.documents'
i_cSearchTable[5] = 'cusfocus.documents'
i_cSearchTable[6] = 'cusfocus.documents'
i_cSearchTable[7] = 'cusfocus.documents'
i_cSearchTable[8] = 'cusfocus.documents'
i_cSearchTable[9] = 'cusfocus.documents'
i_cSearchTable[10] = 'cusfocus.documents'
i_cSearchTable[11] = 'cusfocus.documents'
i_cSearchTable[12] = 'cusfocus.documents'
i_cSearchTable[13] = 'cusfocus.documents'
i_cSearchTable[14] = 'cusfocus.documents'
i_cSearchTable[15] = 'cusfocus.documents'
i_cSearchTable[16] = 'cusfocus.documents'
i_cSearchTable[17] = 'cusfocus.documents'
i_cSearchTable[18] = 'cusfocus.documents'
i_cSearchTable[19] = 'cusfocus.documents'

i_cMatchColumn[1] = 'documents_doc_type_id'
i_cMatchColumn[2] = 'documents_doc_name'
i_cMatchColumn[3] = 'documents_doc_desc'
i_cMatchColumn[4] = 'documents_doc_create_dt'
i_cMatchColumn[5] = 'documents_doc_orig_dt'
i_cMatchColumn[6] = 'documents_doc_expire_dt'
i_cMatchColumn[7] = 'documents_doc_version'
i_cMatchColumn[8] = 'documents_doc_status_id'
i_cMatchColumn[9] = 'documents_doc_general_flag'
i_cMatchColumn[10] = 'documents_doc_config_1'
i_cMatchColumn[11] = 'documents_doc_config_2'
i_cMatchColumn[12] = 'documents_doc_config_3'
i_cMatchColumn[13] = 'documents_doc_config_4'
i_cMatchColumn[14] = 'documents_doc_config_5'
i_cMatchColumn[15] = 'documents_doc_config_6'
i_cMatchColumn[16] = 'documents_doc_config_7'
i_cMatchColumn[17] = 'documents_doc_config_8'
i_cMatchColumn[18] = 'documents_doc_config_9'
i_cMatchColumn[19] = 'documents_doc_config_10'

//--------------------------------------------------------------------------------------
//
//		Populate the user dropdown data window and add a record for an All match.
//
//--------------------------------------------------------------------------------------

dw_search_criteria.GetChild('documents_doc_status_id', l_dwcDocType)
l_dwcDocType.SetTransObject(SQLCA)
l_dwcDocType.Retrieve()
l_dwcDocType.InsertRow(0)


//---------------------------------------------------------------------------------------
//
//		Set the Options the matched records.
//
//---------------------------------------------------------------------------------------

dw_matched_records.fu_SetOptions( SQLCA, & 
 		dw_matched_records.c_NulLDW, & 
 		dw_matched_records.c_SelectOnRowFocusChange + &
 		dw_matched_records.c_ModifyOK + &
 		dw_matched_records.c_MultiSelect + &
 		dw_matched_records.c_NoRetrieveOnOpen + &
 		dw_matched_records.c_ShowHighlight + &
		dw_matched_records.c_TabularFormStyle + &
 		dw_matched_records.c_ActiveRowPointer + &
 		dw_matched_records.c_NoInactiveRowPointer + &
		dw_matched_records.c_SortClickedOK) 

//---------------------------------------------------------------------------------------
//
//		Wire the Search object to the matching datawindow.
//
//---------------------------------------------------------------------------------------

dw_search_criteria.fu_WireDW(i_cSearchColumn[], dw_matched_records, &
			i_cSearchTable[], i_cMatchColumn[], SQLCA)

dw_doc_type.SetFocus()

fw_CheckOutOfOffice()

// initialize the resize service for this window

of_SetResize (TRUE)

IF IsValid (inv_resize) THEN
	inv_resize.of_SetOrigSize ((Width - 30), (Height - 178))
	inv_resize.of_SetMinSize ((Width - 30), (Height - 178))
	
	inv_resize.of_Register (dw_search_criteria, inv_resize.SCALERIGHT)
	inv_resize.of_Register (gb_criteria, inv_resize.SCALERIGHT)
	inv_resize.of_Register (dw_matched_records, inv_resize.SCALERIGHTBOTTOM)
	
END IF


end event

event open;call super::open;//****************************************************************************************
//
//  Event:   open
//  Purpose: Trigger itemchanged event of dw_doc_type to cause user configured fields to 
//		       paint
//
//	 Date     Developer    Description
//	 -------- ------------ ----------------------------------------------------------------
//	 03/03/00 C. Jackson   Original Version
//  04/05/00 C. Jackson   Correct logic for getting document labels (needed to allow for
//                        'gaps' in field order)
//  04/06/00 C. Jackson   Add modify for editmask on document fields (SCR 498)
//
//****************************************************************************************/

LONG 		l_nRtn, l_nRecordCount, l_nCounter
STRING   l_cDocTypeID, l_cNewFieldLabel, l_cColName, l_cColFormatID, l_cColFormat
STRING	l_cModLabelString1, l_cModLabelString2, l_cModLabelVisible, l_cModDataVisible, l_cModEditMask

// Reset all configurable columns to not visible
FOR l_nCounter = 1 TO 10
	l_cModLabelVisible = "documents_doc_config_"+string(l_nCounter)+"_t.Visible = 0"
	l_cModDataVisible = "documents_doc_config_"+string(l_nCounter)+".Visible = 0"
	dw_search_criteria.Modify(l_cModLabelVisible)
	dw_search_criteria.Modify(l_cModDataVisible)
NEXT

// Grab the Document Type 
l_cDocTypeID = dw_doc_type.GetText()

// Count the number of records for this DocTypeID
	SELECT max(doc_field_order) INTO :l_nRecordCount
	  FROM cusfocus.document_fields
	 WHERE doc_type_id = :l_cDocTypeID
	 USING SQLCA;

l_nCounter = 1
DO WHILE l_nCounter <= l_nRecordCount
	
	// Initialize field label
	SETNULL(l_cNewFieldLabel)
	
	// Get the field label from document_fields table
	SELECT  doc_field_label, doc_column_name, doc_format_id INTO :l_cNewFieldLabel, :l_cColName, :l_cColFormatID
	  FROM cusfocus.document_fields
	 WHERE doc_type_id = :l_cDocTypeID
	   AND doc_field_order = :l_nCounter
	 USING SQLCA;

   // Get the Format Type
	SELECT edit_mask INTO :l_cColFormat
	  FROM cusfocus.display_formats
	 WHERE format_id = :l_cColFormatID
	 USING SQLCA;

	IF NOT ISNULL(l_cNewFieldLabel) THEN
		l_cModLabelString1 = "documents_doc_config_"+string(l_nCounter)+"_t.text = '"+l_cNewFieldLabel+":'"
		l_cModLabelString2 = "documents_doc_config_"+string(l_nCounter)+"_t.text = '"+l_cNewFieldLabel+"'"
		l_cModLabelVisible = "documents_doc_config_"+string(l_nCounter)+"_t.Visible = 1"
		l_cModDataVisible = "documents_doc_config_"+string(l_nCounter)+".Visible = 1"
		dw_search_criteria.Modify(l_cModLabelString1)
		dw_search_criteria.Modify(l_cModLabelVisible)
		dw_search_criteria.Modify(l_cModDataVisible)
		dw_matched_records.Modify(l_cModLabelString2)
		dw_matched_records.Modify(l_cModLabelVisible)
		dw_matched_records.Modify(l_cModDataVisible)
		IF NOT ISNULL(l_cColFormat) and l_cColFormat <> "" THEN
			l_cModEditMask = "documents_doc_config_"+string(l_nCounter)+".EditMask.Mask='"+l_cColFormat+"'"
			dw_search_criteria.Modify(l_cModEditMask)
		END IF
		
	END IF
	
	l_nCounter++
	
LOOP

dw_search_criteria.SetItem(1,"documents_doc_type_id",l_cDocTypeID)

dw_search_criteria.SetFocus()
dw_search_criteria.SetColumn('documents_doc_name')

this.dw_search_criteria.SetFocus()
this.dw_search_criteria.SetColumn('documents_doc_name')

end event

event pc_setvariables;call super::pc_setvariables;//*****************************************************************************************
//
//  Event: 		pc_setvariables
//  Description:	Set Initial Variables
//  
//  Date     Developer    Description
//  -------- ------------ -----------------------------------------------------------------
//  04/04/00 C. Jackson   Original Version
//  
//*****************************************************************************************  

i_nDocCounter =  1
end event

event pc_closequery;call super::pc_closequery;//*************************************************************************************************
//
//  Event:        pc_closequery
//  Description:  Close any documents that might be open
//  
//  Date     Developer    Description
//  -------- ------------ -------------------------------------------------------------------------
//  04/04/00 C. Jackson   Original Version
//  11/10/00 C. Jackson   Add Excel
//  
//*************************************************************************************************  

LONG l_nCounter, l_nDocNameLength
STRING l_cDocName, l_cDocExt, l_cDocShortName
BOOLEAN l_bDeleted

l_nCounter = 1

DO WHILE l_nCounter < i_nDocCounter
	
	// Get the doc name from the instance array
	l_cDocName = i_cOpenDocs[l_nCounter]

	IF FileExists(l_cDocName) THEN
		
		// Attempt to delete the file
		l_bDeleted = FileDelete(l_cDocName)
		
		// If unsuccessful, since the file does exist, this means the file is open and cannot be deleted
		IF l_bDeleted = FALSE THEN
			
			// Get the file extension to display error message
			l_nDocNameLength = LEN(l_cDocName)
			l_cDocExt = MID(l_cDocName, (l_nDocNameLength - 3))

			l_cDocShortName = MID(l_cDocName,4)

			CHOOSE CASE UPPER(l_cDocExt)
				CASE '.PDF'
					messagebox(gs_AppName,'You must close the Adobe Acrobat File "' + l_cDocShortName + '" before closing this window.')
				CASE '.DOC'
					messagebox(gs_AppName,'You must close the Word Document "' + l_cDocShortName + '" before closing this window.')
				CASE '.XLS'
					messagebox(gs_AppName,'You must close the Excel Spreadsheet "' + l_cDocShortName + '" before closing this window.')
			END CHOOSE			
			Error.i_FWError = c_Fatal
			EXIT
			
		END IF
			
	END IF
	
l_nCounter++	
LOOP
end event

event resize;call super::resize;st_2.width = this.workspacewidth()
ln_3.endx = st_2.width
ln_4.endx = st_2.width
end event

type st_4 from statictext within w_docs_full_interface
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
string text = "Document Interface"
boolean focusrectangle = false
end type

type p_1 from picture within w_docs_full_interface
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_3 from statictext within w_docs_full_interface
boolean visible = false
integer x = 5
integer y = 1904
integer width = 2350
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217730
boolean focusrectangle = false
end type

type st_2 from statictext within w_docs_full_interface
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

type st_1 from statictext within w_docs_full_interface
integer x = 69
integer y = 216
integer width = 471
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Document Type:"
boolean focusrectangle = false
end type

type dw_doc_type from u_dw_std within w_docs_full_interface
integer x = 530
integer y = 200
integer width = 1239
integer height = 104
integer taborder = 10
string dataobject = "d_doc_type"
boolean border = false
end type

event itemchanged;call super::itemchanged;//****************************************************************************************
//
//	 Event:	itemchanged
//	 Purpose: Prep the system to update the updated_by and updated_timestamp columns when
//	          the changed category is saved.
//				
//	 Date     Developer    Description
//	 -------- ------------ ---------------------------------------------------------------
//	 03/03/00 C. Jackson   Original Version
//  04/05/00 C. Jackson   Correct logic for getting document labels (needed to allow for
//                        'gaps' in field order)
//  04/06/00 C. Jackson   Add modify for formats on document types (SCR 498)
// 
//****************************************************************************************/

LONG 		l_nRtn, l_nRecordCount, l_nCounter
STRING   l_cDocTypeID, l_cNewFieldLabel, l_cColName, l_cColFormatID, l_cColFormat
STRING	l_cModLabelString1, l_cModLabelString2, l_cModLabelVisible, l_cModDataVisible, l_cModEditMask

// Clear Search Criteria
m_docs_full_interface.m_file.m_clearsearchcriteria.TriggerEvent (clicked!)

// Disable view details menu item until rows have been retrieve
m_docs_full_interface.m_file.m_viewdetails.Enabled = FALSE

// Reset all to not visible
FOR l_nCounter = 1 TO 10
	l_cModLabelVisible = "documents_doc_config_"+string(l_nCounter)+"_t.Visible = 0"
	l_cModDataVisible = "documents_doc_config_"+string(l_nCounter)+".Visible = 0"
	dw_search_criteria.Modify(l_cModLabelVisible)
	dw_search_criteria.Modify(l_cModDataVisible)
	dw_matched_records.Modify(l_cModLabelVisible)
	dw_matched_records.Modify(l_cModDataVisible)
NEXT

// Grab the Document Type 
l_cDocTypeID = dw_doc_type.GetText()

// Count the number of records for this DocTypeID
	SELECT max(doc_field_order) INTO :l_nRecordCount
	  FROM cusfocus.document_fields
	 WHERE doc_type_id = :l_cDocTypeID
	 USING SQLCA;

l_nCounter = 1
DO WHILE l_nCounter <= l_nRecordCount
	
	// Initialize field label
	SETNULL(l_cNewFieldLabel)
	
	// Get the field label from document_fields table
	SELECT  doc_field_label, doc_column_name, doc_format_id INTO :l_cNewFieldLabel, :l_cColName, :l_cColFormatID
	  FROM cusfocus.document_fields
	 WHERE doc_type_id = :l_cDocTypeID
	   AND doc_field_order = :l_nCounter
    USING SQLCA;

   // Get the Format Type
	SELECT edit_mask INTO :l_cColFormat
	  FROM cusfocus.display_formats
	 WHERE format_id = :l_cColFormatID
	 USING SQLCA;
	 
	IF NOT ISNULL(l_cNewFieldLabel) THEN
		l_cModLabelString1 = "documents_doc_config_"+string(l_nCounter)+"_t.text = '"+l_cNewFieldLabel+":'"
		l_cModLabelString2 = "documents_doc_config_"+string(l_nCounter)+"_t.text = '"+l_cNewFieldLabel+"'"
		l_cModLabelVisible = "documents_doc_config_"+string(l_nCounter)+"_t.Visible=1"
		l_cModDataVisible = "documents_doc_config_"+string(l_nCounter)+".Visible=1"
		dw_search_criteria.Modify(l_cModLabelString1)
		dw_search_criteria.Modify(l_cModLabelVisible)
		dw_search_criteria.Modify(l_cModDataVisible)
		dw_matched_records.Modify(l_cModLabelString2)
		dw_matched_records.Modify(l_cModLabelVisible)
		dw_matched_records.Modify(l_cModDataVisible)
		IF NOT ISNULL(l_cColFormat) and l_cColFormat <> "" THEN
			l_cModEditMask = "documents_doc_config_"+string(l_nCounter)+".EditMask.Mask='"+l_cColFormat+"'"
			dw_search_criteria.Modify(l_cModEditMask)
		END IF
	END IF
	
	l_nCounter++
	
LOOP

// Set the hidden doc_type_id field on dw_search_criteria to that selected in the drop-down above
dw_search_criteria.SetItem(1,"documents_doc_type_id",'')
dw_search_criteria.SetItem(1,"documents_doc_type_id",l_cDocTypeID)
dw_search_criteria.SetFocus()



end event

event pcd_retrieve;call super::pcd_retrieve;//****************************************************************************************
//	Event         : pcd_Retrieve
//	Description   : Retrieve data from the database for this DataWindow.
//
//	Parameters    : DATAWINDOW Parent_DW -
//            	        Parent of this DataWindow.  If this 
//                     DataWindow is root-level, this value will
//                     be NULL.
//	                LONG       Num_Selected -
//                     The number of selected records in the
//                     parent DataWindow.
//                   LONG       Selected_Rows[] -
//                     The row numbers of the selected records
//                     in the parent DataWindow.
//
//	Return Value  : Error.i_FWError -
//                     c_Success - the event completed succesfully.
//                     c_Fatal   - the event encountered an error.
//
//	Change History:
//
//	Date     Person     Description of Change
//	-------- ---------- --------------------------------------------
//	03/03/00 C. Jackson Original Version
//****************************************************************************************/

//------------------------------------------------------------------
//  If this DataWindow does not have a parent DataWindow, then
//  the following sample code may be all that you need.
//------------------------------------------------------------------
//
//LONG 		l_nRtn
//STRING	l_cCategoryID
//
//l_cCategoryID = Message.StringParm
//l_nRtn = Retrieve(l_cCategoryID)
//
//IF l_nRtn < 0 THEN
//   Error.i_FWError = c_Fatal
//END IF
end event

type dw_search_criteria from u_dw_search within w_docs_full_interface
event ue_searchtrigger pbm_dwnkey
integer x = 41
integer y = 364
integer width = 3529
integer height = 784
integer taborder = 20
string dataobject = "d_docs_search_full"
boolean border = false
end type

event ue_searchtrigger;//****************************************************************************************
//
//	Event:	ue_searchtrigger
//	Purpose:	Trigger the search function when the user presses the Enter key.
//	
//	Revisions:
//	Date     Developer     Description
//	======== ============= ==============================================================
//	03/03/00 C. Jackson    Original Version
//
//****************************************************************************************/

IF key = KeyEnter! THEN
	m_docs_full_interface.m_file.m_search.TriggerEvent (clicked!)
END IF
end event

type dw_matched_records from u_dw_std within w_docs_full_interface
integer x = 27
integer y = 1200
integer width = 3561
integer height = 700
integer taborder = 30
string dataobject = "d_docs_matched_full"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;//***************************************************************************************
//
//			Event:	pcd_retrieve
//			Purpose:	To retrieve the records based on the search criteria
//
// Date     Developer   Description
// -------- ----------- -----------------------------------------------------------------
// 03/01/00 C. Jackson  Original Version
//
//***************************************************************************************/

LONG l_nReturn

l_nReturn = Retrieve()

IF l_nReturn > 0 THEN
	m_docs_full_interface.m_file.m_viewdetails.Enabled = TRUE
ELSE
	m_docs_full_interface.m_file.m_viewdetails.Enabled = FALSE
END IF

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF
end event

event doubleclicked;call super::doubleclicked;//*******************************************************************************************
//
//  Event:	 doubleclicked
//  Purpose: To allow the user to view the document
//				
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------
//  04/04/00 C. Jackson  Original Version
//	 06/02/00 M. Caruso   Added code to prevent processing unless a row is selected.
//  11/10/00 C. Jackson  Add Excel
//  06/27/01 C. Jackson  Initialize l_cAppPath to null
//  11/28/01 C. Jackson  Change document path from C Drive to the Temp Path from the Environment
//                       Variables.
//  10/19/06 R. Post     Changed how URLs were opened.
//
//*******************************************************************************************

STRING l_cDocID, l_cAppPath, l_cFileName, l_cExt
LONG l_nRowCount, l_nFileNameLength, l_nPathLength, l_nFileNum, l_nFileLength, l_nLoops, l_nCounter
LONG l_nBytes, l_nBlobStart, l_nRow, l_nRV
BLOB l_bTotalImage, l_bPartialImage
ContextKeyword lcxk_base
string ls_temp[]
n_cst_kernel32 l_nKernelFuncs
inet linet_base

SETNULL(l_cAppPath)

l_nRow = dw_matched_records.GetRow()
IF l_nRow > 0 THEN

	// Get Filename
	l_cFileName = dw_matched_records.GetItemString(l_nRow,'documents_doc_filename')
	
	//JWhite 8.22.2006 Adding Link Code
	string	ls_link, ls_null
	long		ll_null
	ls_link = dw_matched_records.GetItemString(l_nRow,'documents_link')
	SetNull(ll_null)
	SetNull(ls_null)
	
	
	If Len(ls_link) > 0 and Not IsNull(ls_link) Then
		
		IF lower(MID(ls_link,1,5)) = "https" THEN ls_link = MID(ls_link,9)
		IF lower(MID(ls_link,1,4)) = "http" THEN ls_link = MID(ls_link,8)
		
		GetContextService("Internet", linet_base)
		l_nRV = linet_base.HyperlinkToURL(ls_link)

		//FUNCTION long ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd)
		//l_nRV = ShellExecuteA( 0, "open", ls_link, "" , ls_null, ll_null)
		
		
	Else
		IF ISNULL(l_cFileName) THEN
			messagebox(gs_AppName,'There is no image associated with this Document.')
			RETURN
		END IF
		
		// Get DocID
		l_cDocID = dw_matched_records.GetItemString(l_nRow,'documents_doc_id')
		
		// Set a wait cursor
		SetPointer(HourGlass!)
		
		// Get Blob, l_bDocImage is the total blob
		SELECTBLOB doc_image
				INTO :l_bTotalImage
				FROM cusfocus.documents
			  WHERE doc_id = :l_cDocID;
			  
		// Determine the filetype based on the file extension
		l_nFileNameLength = LEN(l_cFileName)
		l_cExt = MID(l_cFileName, (l_nFileNameLength - 3))
		
		// Process based on filetype
		CHOOSE CASE UPPER(l_cExt)
			CASE '.PDF'
		
				// Make sure the user has Adobe Acrobat installed and get the path
				RegistryGet( &
					 "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Software\Adobe\Acrobat\Exe","",RegString!, l_cAppPath)
					 
					IF ISNULL(l_cAppPath) THEN
						Messagebox(gs_AppName,'This workstation does not have Acrobat Reader installed.')
					END IF
					
					
			CASE '.DOC'
				// Make sure the user has Microsoft Word installed and get the path
				RegistryGet( &
					 "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Winword.exe","",RegString!, l_cAppPath)
					 
					IF ISNULL(l_cAppPath) THEN
						Messagebox(gs_AppName,'This workstation does not have Microsoft Word installed.')
					END IF
	
			CASE '.XLS'
				// Make sure the user has Microsoft Excel installed and get the path
				RegistryGet( &
					 "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Excel.exe","",RegString!, l_cAppPath)
					 
					IF ISNULL(l_cAppPath) THEN
						Messagebox(gs_AppName,'This workstation does not have Microsoft Excel installed.')
					END IF
		END CHOOSE
	

		//Prepare to open the document
		// Get the Temp Path from Environment Variables
		THIS.GetContextService("Keyword", lcxk_base)
		lcxk_base.getContextKeywords("TEMP", ls_temp)
		
		// Temp Path is not available, use Root drive
		If Not l_nKernelFuncs.of_DirectoryExists(ls_temp[1]) Then 
			ls_Temp[1] = 'C:\'
		END IF
	
		l_cFileName = ls_temp[1] + '\' + l_cFileName
		l_nFileNum = FileOpen(l_cFileName,StreamMode!,Write!)
		l_nFileLength = LEN(l_bTotalImage)
		
		// Determine the number of times to call FileWrite
		IF l_nFileLength > 32765 THEN
		
			IF Mod(l_nFileLength, 32765) = 0 THEN
				l_nLoops = l_nFileLength/32765
			ELSE 
				l_nLoops = CEILING(l_nFileLength/32765)
			END IF
			
		ELSE
			l_nLoops = 1
		END IF
		
		l_nBlobStart = 1
		
		FOR l_nCounter = 1 TO l_nLoops
			l_bPartialImage  = BLOBMID(l_bTotalImage,l_nBlobStart,32765)
			l_nBytes = FileWrite(l_nFileNum,l_bPartialImage)
			l_nBlobStart = (l_nBlobStart + 32765)
		NEXT
		
		FileClose(l_nFileNum)
		
		// Get the path to pass to the Run Command
		IF POS(l_cAppPath,'"',1) <> 1 THEN
			l_cAppPath = '"'+l_cAppPath
		END IF
		l_nPathLength = LEN(l_cAppPath)
		IF POS(l_cAppPath,'"',l_nPathLength) <> l_nPathLength THEN
			l_cAppPath = l_cAppPath + '"'
		END IF
		
	//	l_cAppPath = l_cAppPath + l_cFileName
		l_cAppPath = l_cAppPath + ' "'+l_cFileName+'"'
		
		// Keep track of Documents that are open
		i_cOpenDocs[i_nDocCounter] = l_cFileName
		i_nDocCounter = i_nDocCounter + 1
		
		// Run the application to view the document
		RUN(l_cAppPath)
	
	END IF
End If
end event

event rbuttondown;call super::rbuttondown;////**********************************************************************************************
////
////  Event:   rbuttondown
////  Purpose: To open the Document Details Response window
////
////  Date     Developer   Description
////  -------- ----------- -----------------------------------------------------------------------
////  08/22/00 C. Jackson  Original Version
////  04/03/01 C. Jackson  Commented out.  Details will only be available via the menu
////
////**********************************************************************************************
//
//LONG		l_nRow
//STRING	l_cDocID
//
//l_nRow = this.GetRow()
//
//IF l_nRow > 0 THEN
//
//	l_cDocID = this.GetItemString(l_nRow,"documents_doc_id")
//	
//	OpenWithParm(w_doc_details,l_cDocID)
//	
//END IF
end event

event clicked;call super::clicked;//******************************************************************************************
//  Event:   clicked
//  Purpose: Select Rows
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//  04/04/01 C. Jackson  Original Version
//
//******************************************************************************************

LONG l_nSelected[], l_nRtn, l_nCurrentRow, l_nNumRows
BOOLEAN l_bDWClicked
string	ls_link, ls_null
long		ll_null, l_nRV
inet		linet_base

l_nRtn = fu_GetSelectedRows(l_nSelected[])

IF dwo.type = "column" THEN
	m_docs_full_interface.m_file.m_viewdetails.Enabled = TRUE
	
	//JWhite 8.24.2006 Adding the ability to open a link with a single click if they 
	// 						click on the new document link field
	Choose Case dwo.Name
		Case 'documents_link'
			
		ls_link = dw_matched_records.GetItemString(row,'documents_link')
		SetNull(ll_null)
		SetNull(ls_null)
		
		//RPost 10.19.2006 Changed the way 
		If Len(ls_link) > 0 and Not IsNull(ls_link) Then
			IF lower(MID(ls_link,1,5)) = "https" THEN ls_link = MID(ls_link,9)
			IF lower(MID(ls_link,1,4)) = "http" THEN ls_link = MID(ls_link,8)
			
			GetContextService("Internet", linet_base)
			l_nRV = linet_base.HyperlinkToURL(ls_link)

			//FUNCTION long ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd)
			//l_nRV = ShellExecuteA( 0, "open", ls_link, "" , ls_null, ll_null)
		End If		
	End Choose
END IF

IF dwo.name = "datawindow" THEN
	l_nCurrentRow = GetRow()
	l_bDWClicked = TRUE

END IF

fu_SetOptions( SQLCA,c_NullDW, c_NoEnablePopup + c_NoMenuButtonActivation + c_NoMultiSelect + &
		c_SelectOnRowFocusChange + c_SortClickedOK )

IF l_bDWClicked THEN
	SetRow(l_nCurrentRow)
END IF


end event

type gb_criteria from groupbox within w_docs_full_interface
integer x = 27
integer y = 308
integer width = 3561
integer height = 884
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Criteria"
end type

type ln_1 from line within w_docs_full_interface
boolean visible = false
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1900
integer endx = 2400
integer endy = 1900
end type

type ln_2 from line within w_docs_full_interface
boolean visible = false
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1896
integer endx = 2400
integer endy = 1896
end type

type ln_3 from line within w_docs_full_interface
long linecolor = 16777215
integer linethickness = 4
integer beginy = 172
integer endx = 4000
integer endy = 172
end type

type ln_4 from line within w_docs_full_interface
long linecolor = 8421504
integer linethickness = 4
integer beginy = 168
integer endx = 4000
integer endy = 168
end type

