$PBExportHeader$u_document_registration.sru
$PBExportComments$Search Criteria User Object
forward
global type u_document_registration from u_container_std
end type
type st_1 from statictext within u_document_registration
end type
type dw_doc_reg_type from u_dw_std within u_document_registration
end type
type dw_search_criteria from u_dw_search within u_document_registration
end type
type dw_matched_records from u_dw_std within u_document_registration
end type
type gb_criteria from groupbox within u_document_registration
end type
end forward

global type u_document_registration from u_container_std
integer width = 3579
integer height = 1592
boolean border = false
long backcolor = 79748288
event ue_rowselected pbm_custom01
event ue_deletedocument ( )
st_1 st_1
dw_doc_reg_type dw_doc_reg_type
dw_search_criteria dw_search_criteria
dw_matched_records dw_matched_records
gb_criteria gb_criteria
end type
global u_document_registration u_document_registration

type variables
STRING  i_cCriteriaColumn[]
STRING  i_cSearchTable[]
STRING  i_cSearchColumn[]
STRING  i_cDocID
STRING  i_cDocTypeID
STRING  i_cOpenDoc
STRING  i_cOpenDocID
STRING  i_bPDFOpen
STRING  i_bWordOpen
STRING  i_bExcelOpen
LONG    i_nMaxValue


W_CREATE_MAINTAIN_CASE i_wParentWindow

BOOLEAN i_bDocSelected



end variables

forward prototypes
public function integer fu_refinteg ()
public subroutine fu_retrievedocreg ()
end prototypes

event ue_deletedocument;//**********************************************************************************************
//
//  Event:   ue_deletedocument
//  Purpose: To delete documents
//  
//  Date     Developer    Description
//  -------- ------------ ----------------------------------------------------------------------
//  04/03/01 C. Jackson   Original Version
//
//**********************************************************************************************

INT l_nRtn
LONG l_Rows[]

IF dw_matched_records.RowCount() = 0 THEN
	messagebox(gs_AppName,'There are no rows to delete.')
	RETURN
END IF

l_nRtn = MessageBox(gs_AppName,'Delete selected document?', Question!, YesNo!)

IF l_nRtn = 2 THEN
	RETURN
END IF

THIS.SetReDraw(FALSE)

l_nRtn = fu_refinteg()

IF l_nRtn = 0 THEN

	l_Rows[1] = dw_matched_records.i_CursorRow
	
	dw_matched_records.fu_Delete(1, l_Rows[], dw_matched_records.c_IgnoreChanges)
	
	dw_matched_records.fu_save(dw_matched_records.c_SaveChanges)
	
	IF dw_matched_records.RowCount() > 0 THEN
		
		l_nRtn = dw_matched_records.fu_Retrieve(dw_matched_records.c_IgnoreChanges, dw_matched_records.c_NoReselectRows)
		
	END IF
	
END IF

THIS.SetRedraw(TRUE)


end event

public function integer fu_refinteg ();//*********************************************************************************************
//
//  Function: fu_refinteg
//  Purpose:  To check to see if a row the user wants to delete has related data in another 
//            table.
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  12/07/00 C. Jackson  Original Version
//  12/05/01 C. Jackson  Spelling: changed "can not" to "cannot" (SCR 2497)
//
//*********************************************************************************************

STRING l_cKeyValue 
INT    l_nKeyValue
LONG 	 l_nRowCount, l_nRow

l_nRow = dw_matched_records.GetRow()

l_cKeyValue = dw_matched_records.GetItemString(l_nRow, 'documents_doc_id')
	
SELECT COUNT (*) INTO :l_nRowCount 
  FROM cusfocus.document_ownership
 WHERE doc_id = :l_cKeyValue;
 
IF l_nRowCount <> 0 THEN 
	Messagebox(gs_AppName,'You cannot delete this Document since it is has been assigned to a Provider or Group.')
	 RETURN -1
ELSE
	RETURN 0
END IF


end function

public subroutine fu_retrievedocreg ();//****************************************************************************************
//
//	 function: fu_RetrieveDocReg
//	 Purpose:	Trigger the search function when the user presses the Enter key.
//	
//	 date     developer   description
//  -------- ----------- ---------------------------------------------------------------------
//  01/15/01 C. Jackson  original version
//  04/10/01 C. Jackson  Add retrieve of child datawindow to catch new types that have 
//                       added (SCR 1615)
//
//****************************************************************************************

STRING	l_sSearchType
LONG 		l_nReturn
DATAWINDOWCHILD l_dwcDocStatus, l_dwcDoctype

// Retrieve children datawindows
dw_doc_reg_type.GetChild('doc_type_id',l_dwcDocType)
l_dwcDocType.SetTransObject(SQLCA)
l_dwcDocType.Retrieve()

dw_search_criteria.GetChild('doc_status_id', l_dwcDocStatus)
l_dwcDocStatus.SetTransObject(SQLCA)
l_dwcDocStatus.Retrieve()

//---------------------------------------------------------------------------------------
//		Initialize the search results datawindow.
//--------------------------------------------------------------------------------------

dw_doc_reg_type.SetTransObject(SQLCA)
dw_doc_reg_type.Retrieve()

		dw_search_criteria.Visible = TRUE
		
		i_cCriteriaColumn[1] = "doc_type_id"
		i_cCriteriaColumn[2] = "doc_name"
		i_cCriteriaColumn[3] = "doc_desc"
		i_cCriteriaColumn[4] = "doc_create_dt"
		i_cCriteriaColumn[5] = "doc_orig_dt"
		i_cCriteriaColumn[6] = "doc_expire_dt"
		i_cCriteriaColumn[7] = "doc_version"		
		i_cCriteriaColumn[8] = "doc_status_id"
		i_cCriteriaColumn[9] = "doc_filename"
		i_cCriteriaColumn[10] = "doc_general_flag"
		i_cCriteriaColumn[11] = "doc_config_1"
		i_cCriteriaColumn[12] = "doc_config_2"
		i_cCriteriaColumn[13] = "doc_config_3"
		i_cCriteriaColumn[14] = "doc_config_4"
		i_cCriteriaColumn[15] = "doc_config_5"
		i_cCriteriaColumn[16] = "doc_config_6"
		i_cCriteriaColumn[17] = "doc_config_7"
		i_cCriteriaColumn[18] = "doc_config_8"
		i_cCriteriaColumn[19] = "doc_config_9"
		i_cCriteriaColumn[20] = "doc_config_10"
		
		i_cSearchTable[1] = "cusfocus.documents"
		i_cSearchTable[2] = "cusfocus.documents"
		i_cSearchTable[3] = "cusfocus.documents"
		i_cSearchTable[4] = "cusfocus.documents"
		i_cSearchTable[5] = "cusfocus.documents"
		i_cSearchTable[6] = "cusfocus.documents"
		i_cSearchTable[7] = "cusfocus.documents"
		i_cSearchTable[8] = "cusfocus.documents"
		i_cSearchTable[9] = "cusfocus.documents"
		i_cSearchTable[10] = "cusfocus.documents"
		i_cSearchTable[11] = "cusfocus.documents"
		i_cSearchTable[12] = "cusfocus.documents"
		i_cSearchTable[13] = "cusfocus.documents"
		i_cSearchTable[14] = "cusfocus.documents"
		i_cSearchTable[15] = "cusfocus.documents"
		i_cSearchTable[16] = "cusfocus.documents"
		i_cSearchTable[17] = "cusfocus.documents"
		i_cSearchTable[18] = "cusfocus.documents"
		i_cSearchTable[19] = "cusfocus.documents"
		i_cSearchTable[20] = "cusfocus.documents"
		
		i_cSearchColumn[1] = "doc_type_id"
		i_cSearchColumn[2] = "doc_name"
		i_cSearchColumn[3] = "doc_desc"
		i_cSearchColumn[4] = "doc_create_dt"
		i_cSearchColumn[5] = "doc_orig_dt"
		i_cSearchColumn[6] = "doc_expire_dt"
		i_cSearchColumn[7] = "doc_version"
		i_cSearchColumn[8] = "doc_status_id"
		i_cSearchColumn[9] = "doc_filename"
		i_cSearchColumn[10] = "doc_general_flag"
		i_cSearchColumn[11] = "doc_config_1"
		i_cSearchColumn[12] = "doc_config_2"
		i_cSearchColumn[13] = "doc_config_3"
		i_cSearchColumn[14] = "doc_config_4"
		i_cSearchColumn[15] = "doc_config_5"
		i_cSearchColumn[16] = "doc_config_6"
		i_cSearchColumn[17] = "doc_config_7"
		i_cSearchColumn[18] = "doc_config_8"
		i_cSearchColumn[19] = "doc_config_9"
		i_cSearchColumn[20] = "doc_config_10"
		
dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, &
		i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
dw_search_criteria.SetFocus()


end subroutine

event pc_setoptions;call super::pc_setoptions;//****************************************************************************************
//
//	Event:	pc_setoptions
//	Purpose:	Trigger the search function when the user presses the Enter key.
//	
//	Revisions:
//	Date     Developer     Description
//	======== ============= ==============================================================
//	03/11/00 C. Jackson    Original Version
// 03/21/00 C. Jackson    Remove InsertRow
// 03/23/00 C. Jackson    Add retrieval of doc_status_id
//
//****************************************************************************************/

STRING	l_sSearchType
LONG 		l_nReturn, l_nCount
DATAWINDOWCHILD l_dwcDocStatus

w_table_maintenance.i_nDocCounter = 0

// Since this is a query window, need to populate the drop down for status
dw_search_criteria.GetChild('doc_status_id', l_dwcDocStatus)
l_dwcDocStatus.SetTransObject(SQLCA)
l_dwcDocStatus.Retrieve()

//---------------------------------------------------------------------------------------
//		Initialize the search results datawindow.
//--------------------------------------------------------------------------------------

dw_doc_reg_type.SetTransObject(SQLCA)
dw_doc_reg_type.Retrieve()

SELECT COUNT (*) INTO :l_nCount
  FROM cusfocus.document_types
 USING SQLCA;
 
IF l_nCount > 0 THEN
	i_cDocTypeID = dw_doc_reg_type.GetItemString(1,'doc_type_id')
END IF

		dw_search_criteria.Visible = TRUE
		
		i_cCriteriaColumn[1] = "doc_type_id"
		i_cCriteriaColumn[2] = "doc_name"
		i_cCriteriaColumn[3] = "doc_desc"
		i_cCriteriaColumn[4] = "doc_create_dt"
		i_cCriteriaColumn[5] = "doc_orig_dt"
		i_cCriteriaColumn[6] = "doc_expire_dt"
		i_cCriteriaColumn[7] = "doc_version"		
		i_cCriteriaColumn[8] = "doc_status_id"
		i_cCriteriaColumn[9] = "doc_general_flag"
		i_cCriteriaColumn[10] = "doc_config_1"
		i_cCriteriaColumn[11] = "doc_config_2"
		i_cCriteriaColumn[12] = "doc_config_3"
		i_cCriteriaColumn[13] = "doc_config_4"
		i_cCriteriaColumn[14] = "doc_config_5"
		i_cCriteriaColumn[15] = "doc_config_6"
		i_cCriteriaColumn[16] = "doc_config_7"
		i_cCriteriaColumn[17] = "doc_config_8"
		i_cCriteriaColumn[18] = "doc_config_9"
		i_cCriteriaColumn[19] = "doc_config_10"
		
		i_cSearchTable[1] = "cusfocus.documents"
		i_cSearchTable[2] = "cusfocus.documents"
		i_cSearchTable[3] = "cusfocus.documents"
		i_cSearchTable[4] = "cusfocus.documents"
		i_cSearchTable[5] = "cusfocus.documents"
		i_cSearchTable[6] = "cusfocus.documents"
		i_cSearchTable[7] = "cusfocus.documents"
		i_cSearchTable[8] = "cusfocus.documents"
		i_cSearchTable[9] = "cusfocus.documents"
		i_cSearchTable[10] = "cusfocus.documents"
		i_cSearchTable[11] = "cusfocus.documents"
		i_cSearchTable[12] = "cusfocus.documents"
		i_cSearchTable[13] = "cusfocus.documents"
		i_cSearchTable[14] = "cusfocus.documents"
		i_cSearchTable[15] = "cusfocus.documents"
		i_cSearchTable[16] = "cusfocus.documents"
		i_cSearchTable[17] = "cusfocus.documents"
		i_cSearchTable[18] = "cusfocus.documents"
		i_cSearchTable[19] = "cusfocus.documents"
		
		i_cSearchColumn[1] = "doc_type_id"
		i_cSearchColumn[2] = "doc_name"
		i_cSearchColumn[3] = "doc_desc"
		i_cSearchColumn[4] = "doc_create_dt"
		i_cSearchColumn[5] = "doc_orig_dt"
		i_cSearchColumn[6] = "doc_expire_dt"
		i_cSearchColumn[7] = "doc_version"
		i_cSearchColumn[8] = "doc_status_id"
		i_cSearchColumn[9] = "doc_general_flag"
		i_cSearchColumn[10] = "doc_config_1"
		i_cSearchColumn[11] = "doc_config_2"
		i_cSearchColumn[12] = "doc_config_3"
		i_cSearchColumn[13] = "doc_config_4"
		i_cSearchColumn[14] = "doc_config_5"
		i_cSearchColumn[15] = "doc_config_6"
		i_cSearchColumn[16] = "doc_config_7"
		i_cSearchColumn[17] = "doc_config_8"
		i_cSearchColumn[18] = "doc_config_9"
		i_cSearchColumn[19] = "doc_config_10"

dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, &
		i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
dw_search_criteria.SetFocus()


end event

on u_document_registration.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_doc_reg_type=create dw_doc_reg_type
this.dw_search_criteria=create dw_search_criteria
this.dw_matched_records=create dw_matched_records
this.gb_criteria=create gb_criteria
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_doc_reg_type
this.Control[iCurrent+3]=this.dw_search_criteria
this.Control[iCurrent+4]=this.dw_matched_records
this.Control[iCurrent+5]=this.gb_criteria
end on

on u_document_registration.destroy
call super::destroy
destroy(this.st_1)
destroy(this.dw_doc_reg_type)
destroy(this.dw_search_criteria)
destroy(this.dw_matched_records)
destroy(this.gb_criteria)
end on

event pc_closequery;call super::pc_closequery;//*************************************************************************************************
//
//  Event:        pc_closequery
//  Description:  Close any documents that might be open
//  
//  Date     Developer    Description
//  -------- ------------ -------------------------------------------------------------------------
//  04/01/01 C. Jackson   Original Version
//  
//*************************************************************************************************  

STRING l_cDocExt, l_cDocShortName, l_cDocName
LONG l_nIndex, l_nDocNameLength
BOOLEAN l_bDeleted

FOR l_nIndex = 1 TO w_table_maintenance.i_nDocCounter
	
	l_cDocName = w_table_maintenance.i_cOpenDocs[l_nIndex]
	
	IF FileExists(l_cDocName) THEN
		l_bDeleted = FileDelete(l_cDocName)
		
		IF NOT l_bDeleted THEN
			
			l_nDocNameLength = LEN(l_cDocName)
			l_cDocExt = MID(l_cDocName, (l_nDocNameLength - 3))
			
			l_cDocShortName = MID (l_cDocName, 4)
			
			CHOOSE CASE UPPER(l_cDocExt)
				CASE '.PDF'
					messagebox(gs_AppName,'You must close the Adobe Acrobat file "'+l_cDocName+'" before closing this window.')
					Error.i_FWError = c_Fatal
					EXIT
					
				CASE '.DOC'
					messagebox(gs_AppName,'You must close the Word document "'+l_cDocName+'" before closing this window.')
					Error.i_FWError = c_Fatal
					EXIT
					
				CASE '.XLS'
					messagebox(gs_AppName,'You must close the Excel spreadsheet "'+l_cDocName+'" before closing this window.')
					Error.i_FWError = c_Fatal
					EXIT

			END CHOOSE
			
			
		END IF
		
	END IF
	
NEXT


end event

event resize;call super::resize;dw_matched_records.height = this.height - 1032
dw_matched_records.width = this.width - 59
end event

type st_1 from statictext within u_document_registration
integer x = 50
integer y = 12
integer width = 448
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Document Type:"
boolean focusrectangle = false
end type

type dw_doc_reg_type from u_dw_std within u_document_registration
integer x = 475
integer width = 1239
integer height = 104
integer taborder = 20
string dataobject = "d_doc_type"
boolean border = false
end type

event itemchanged;call super::itemchanged;//****************************************************************************************
//
//  Event:	 itemchanged
//  Purpose: Prep the system to update the updated_by and updated_timestamp columns when
//	          the changed category is saved.
//				
//	 Date     Developer   Description
//	 -------- ----------- ----------------------------------------------------------------
//	 02/28/00 C. Jackson  Original Version
//  04/05/00 C. Jackson  Correct logic for drawing the configurable columns.  Need to 
//                       allow for 'gaps' in doc order
//  04/06/00 C. Jackson  Add modify statement for editmask in Document Fields (SCR 498)
//  04/17/00 C. Jackson  Trigger clicked event for m_clearsearchcriteria (SCR 503)
//  10/15/01 C. Jackson  For Sybase issue: if display_format is general, set edit mask
//                       to 'a' (to the lenghth of the defined column)
//  12/03/01 C. Jackson  Correct handling of quotes so that Label with an apostrophe will 
//                       display correctly.
//  03/06/02 C. Jackson  Use GetRow for GetItemString
//  4/11/2002 K. Claver  Removed GetRow as should only ever have one row.
//****************************************************************************************

LONG 		l_nRtn, l_nRecordCount, l_nCounter, l_nFieldLength, l_nIndex,l_nRow
STRING   l_cDocTypeID, l_cNewFieldLabel, l_cColName, l_cColFormat, l_cColFormatID
STRING	l_cModLabelString1, l_cModLabelString2, l_cModLabelVisible, l_cModDataVisible, l_cModEditMask

THIS.AcceptText()
i_cDocTypeID = THIS.GetItemString(1,'doc_type_id')

// Clear Search Criteria
m_table_maintenance.m_file.m_clearsearchcriteria.TriggerEvent (clicked!)

// Reset all to not visible
FOR l_nCounter = 1 TO 10
	l_cModLabelVisible = "doc_config_"+string(l_nCounter)+"_t.Visible = 0"
	l_cModDataVisible = "doc_config_"+string(l_nCounter)+".Visible = 0"
	dw_search_criteria.Modify(l_cModLabelVisible)
	dw_search_criteria.Modify(l_cModDataVisible)
	dw_matched_records.Modify(l_cModLabelVisible)
	dw_matched_records.Modify(l_cModDataVisible)
NEXT

// Grab the Document Type 
l_cDocTypeID = dw_doc_reg_type.GetText()

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
	SELECT  doc_field_label, doc_column_name, doc_format_id, doc_field_length
	  INTO :l_cNewFieldLabel, :l_cColName, :l_cColFormatID, :l_nFieldLength
	  FROM cusfocus.document_fields
	 WHERE doc_type_id = :l_cDocTypeID
	   AND doc_field_order = :l_nCounter
    USING SQLCA;

   // Get the Format Type
	SELECT edit_mask INTO :l_cColFormat
	  FROM cusfocus.display_formats
	 WHERE format_id = :l_cColFormatID
	 USING SQLCA;
	 
	IF TRIM(l_cColFormat) = "" THEN
		SetNull(l_cColFormat)
	END IF
	
	FOR l_nIndex = 1 TO l_nFieldLength
		IF l_nIndex = 1 THEN
			l_cColFormat = 'a'
		ELSE
			l_cColFormat = l_cColFormat + 'a'
		END IF
	NEXT
	
	IF NOT ISNULL(l_cNewFieldLabel) THEN
		l_cModLabelString1 = 'doc_config_'+string(l_nCounter)+'_t.text = "'+l_cNewFieldLabel+':"'
		l_cModLabelString2 = 'doc_config_'+string(l_nCounter)+'_t.text = "'+l_cNewFieldLabel+'"'
		l_cModLabelVisible = "doc_config_"+string(l_nCounter)+"_t.Visible=1"
		l_cModDataVisible = "doc_config_"+string(l_nCounter)+".Visible=1"
		dw_search_criteria.Modify(l_cModLabelString1)
		dw_search_criteria.Modify(l_cModLabelVisible)
		dw_search_criteria.Modify(l_cModDataVisible)
		dw_matched_records.Modify(l_cModLabelString2)
		dw_matched_records.Modify(l_cModLabelVisible)
		dw_matched_records.Modify(l_cModDataVisible)
		IF NOT ISNULL(l_cColFormat) and TRIM(l_cColFormat) <> "" THEN
			l_cModEditMask = "doc_config_"+string(l_nCounter)+".EditMask.Mask='"+l_cColFormat+"'"
			dw_search_criteria.Modify(l_cModEditMask)
		END IF
	END IF
	
	l_nCounter++
	
LOOP

// Set the hidden doc_type_id field on dw_search_criteria to that selected in the drop-down above
dw_search_criteria.SetItem(1,"doc_type_id",l_cDocTypeID)
dw_search_criteria.SetFocus()

// Set menu items to not enabled - will be set to enable pcd_retrieve if there are matching rows
m_table_maintenance.m_edit.m_delete.Enabled = FALSE
m_table_maintenance.m_file.m_viewdetails.Enabled = FALSE
m_table_maintenance.m_file.m_editdocument.Enabled = FALSE
i_bDocSelected = FALSE


end event

type dw_search_criteria from u_dw_search within u_document_registration
event ue_searchtrigger pbm_dwnkey
integer x = 27
integer y = 136
integer width = 3483
integer height = 856
integer taborder = 10
string dataobject = "d_search_docs_reg"
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
//	03/02/00 C. Jackson    Original Version
//
//****************************************************************************************/

IF key = KeyEnter! THEN
	m_table_maintenance.m_file.m_search.TriggerEvent (clicked!)
END IF
end event

event itemfocuschanged;call super::itemfocuschanged;//*****************************************************************************************
//   Event:      itemfocuschanged
//   Purpose:    Update the list of reports when the appropriate column is selected.
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	  03/28/00 C. Jackson   Original Version
//*****************************************************************************************/

STRING				l_cStatusID
DWItemStatus		l_eStatus
DATAWINDOWCHILD	l_dwcStatusList

CHOOSE CASE dwo.name
	CASE 'doc_status_id'
		GetChild ('doc_status_id', l_dwcStatusList)
		IF NOT IsNull (l_dwcStatusList) THEN
			
			l_cStatusID = GetItemString (row, 'doc_status_id')
			l_eStatus = GetItemStatus (row, 0, Primary!)
			l_dwcStatusList.SetTransObject (SQLCA)
			l_dwcStatusList.Retrieve ()
			SetItem (row, 'doc_status_id', l_cStatusID)
			SetItemStatus (row, 0, Primary!, l_eStatus)
			
		END IF
		
END CHOOSE
end event

type dw_matched_records from u_dw_std within u_document_registration
event ue_selecttrigger pbm_dwnkey
integer x = 27
integer y = 1004
integer width = 3520
integer height = 560
integer taborder = 30
string dataobject = "d_matched_docs_reg"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;//****************************************************************************************
//
//	Event:	ue_selecttrigger
//	Purpose:	Trigger the search function when the user presses the Enter key.
//	
//	Revisions:
//	Date     Developer     Description
//	======== ============= ==============================================================
//	03/11/00 C. Jackson    Original Version
//
//****************************************************************************************/
S_DOCFIELDPROPERTIES l_sParms
LONG l_nRow

l_nRow = dw_matched_records.GetRow()

IF (key = KeyEnter!) AND (GetRow() > 0) THEN

	// Get the selected document id
	l_sparms.doc_id = this.GetItemString (l_nrow, "documents_doc_id")

	IF l_sparms.doc_id > '0' THEN
		// Open w_doc_detail
		FWCA.MGR.fu_OpenWindow(w_doc_reg_detail,l_sParms)
			 
	END IF
	
	RETURN 1
	
END IF


end event

event pcd_retrieve;call super::pcd_retrieve;//***************************************************************************************
//
//	Event:	pcd_retrieve
//	Purpose:	To retrieve the data, set appropriate tabs and select appropriate 
//					 rows.
//						
//   Revisions:
//	Date     Developer     Description
//	======== ============= ==============================================================
//	03/03/00 C. Jackson    Original Version
//								  
//***************************************************************************************/

LONG 		l_nReturn, l_nSelectedRow[1]

IF DataObject = 'd_matched_cases' THEN
	l_nReturn = Retrieve(i_wParentWindow.i_nRepConfidLevel, OBJCA.WIN.fu_GetLogin(SQLCA))
ELSE
	l_nReturn = Retrieve()
END IF

IF l_nReturn > 0 THEN
	// Enable the document details menu item
	i_bDocSelected = TRUE
	i_cDocID = THIS.GetItemString(1,'documents_doc_id')
	
	m_table_maintenance.m_file.m_viewdetails.Enabled = TRUE
	m_table_maintenance.m_file.m_editdocument.Enabled = TRUE
	m_table_maintenance.m_edit.m_delete.Enabled = TRUE
ELSE
	m_table_maintenance.m_edit.m_delete.Enabled = FALSE
	m_table_maintenance.m_file.m_viewdetails.Enabled = FALSE
	m_table_maintenance.m_file.m_editdocument.Enabled = FALSE
	i_bDocSelected = FALSE
END IF

IF l_nReturn < 0 THEN
	Error.i_FWError = c_Fatal
	
END IF


end event

event clicked;call super::clicked;//*******************************************************************************************
//
//  Event:   clicked
//  Purpose: To find out if the user did a Control-Click to de-select a case.
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------
//  03/03/00 C. Jackson  Original Version
//  03/28/01 C. Jackson  Grab the doc id for viewing details
//  
//*******************************************************************************************

LONG l_nRow
STRING ls_link
inet	linet_base

l_nRow = THIS.GetRow()

IF l_nRow > 0 THEN
	i_cDocID = THIS.GetItemString(l_nRow,'documents_doc_id')

	//RPost 10.19.2006 Adding the ability to open a link with a single click if they 
	// 						click on the new document link field
	IF dwo.type = "column" THEN
		Choose Case dwo.Name
			Case 'documents_link'
				
			ls_link = THIS.GetItemString(row,'documents_link')
			
			If Len(ls_link) > 0 and Not IsNull(ls_link) Then
				IF lower(MID(ls_link,1,5)) = "https" THEN ls_link = MID(ls_link,9)
				IF lower(MID(ls_link,1,4)) = "http" THEN ls_link = MID(ls_link,8)
				
				GetContextService("Internet", linet_base)
				linet_base.HyperlinkToURL(ls_link)
	
			End If		
		End Choose
	END IF
END IF



end event

event doubleclicked;call super::doubleclicked;//*******************************************************************************************
//
//  Event:	 doubleclicked
//  Purpose: To allow the user to view the document
//				
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------
//  04/01/01 C. Jackson  Original Version
//  06/26/01 C. Jackson  Correct the check for application to include l_cAppPath 
//  08/22/01 C. Jackson  Correct l_cAppPath for Sybase
//  11/28/01 C. Jackson  Change document path from C Drive to the Temp Path from the Environment
//                       Variables.
//
//*******************************************************************************************

STRING l_cDocID, l_cAppPath, l_cFileName, l_cExt
LONG l_nRowCount, l_nFileNameLength, l_nPathLength, l_nFileNum, l_nFileLength, l_nLoops, l_nCounter
LONG l_nBytes, l_nBlobStart, l_nRow
BLOB l_bTotalImage, l_bPartialImage
ContextKeyword lcxk_base
string ls_temp[]
n_cst_kernel32 l_nKernelFuncs

SETNULL(l_cAppPath)

l_nRow = dw_matched_records.GetRow()
IF l_nRow > 0 THEN

	// Get Filename
	l_cFileName = dw_matched_records.GetItemString(l_nRow,'documents_doc_filename')
	
	//RPost 10.19.2006 Adding Link Code
	String 	ls_link
	inet 		linet_base

	ls_link = THIS.GetItemString(row,'documents_link')
	
	If Len(ls_link) > 0 and Not IsNull(ls_link) Then
		IF lower(MID(ls_link,1,5)) = "https" THEN ls_link = MID(ls_link,9)
		IF lower(MID(ls_link,1,4)) = "http" THEN ls_link = MID(ls_link,8)
		
		GetContextService("Internet", linet_base)
		linet_base.HyperlinkToURL(ls_link)
	ELSE
	
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
			  
		IF sqlca.sqlcode <> 0 THEN
			messagebox(gs_AppName,'Unable to read document from the database, see you System Administrator.')
		END IF
	
	l_nFileLength = LEN(l_bTotalImage)
	
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
		l_nFileLength = 2644992
		
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
		
		l_cAppPath = l_cAppPath + ' "'+l_cFileName+'"'
		
		// Keep track of Documents that are open
		w_table_maintenance.i_nDocCounter = w_table_maintenance.i_nDocCounter + 1
		w_table_maintenance.i_cOpenDocs[w_table_maintenance.i_nDocCounter] = l_cFileName
		
		// Run the application to view the document
		RUN(l_cAppPath)
	END IF
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;//***************************************************************************************
//
//	Event:	pcd_retrieve
//	Purpose:	Set the default behavior of the datawindow.
//						
//   Revisions:
//	Date     Developer     Description
//	======== ============= ==============================================================
//	03/03/00 C. Jackson    Original Version
//								  
//***************************************************************************************/


THIS.fu_SetOptions( SQLCA, & 
						  c_NullDW, & 
						  c_SelectOnRowFocusChange + &
						  c_ViewOnSelect + &
						  c_TabularFormStyle + &
						  c_NewOK + &
						  c_ModifyOK + &
						  c_DeleteOK + &
						  c_NoMenuButtonActivation + &
						  c_SortClickedOK ) 

end event

event rbuttondown;/*****************************************************************************************
   Event:      rbuttondown
   Purpose:    Select the row that was clicked before doing anything else like displaying
					a pop-up menu.  If the user did not click in a valid row, then process as
					normal.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/19/03 M. Caruso	 Created.
*****************************************************************************************/LONG	l_nSelectedRows[], l_nRowCount

IF row > 0 THEN
	
	l_nRowCount = 1
	l_nSelectedRows[l_nRowCount] = row
	fu_SetSelectedRows (l_nRowCount, l_nSelectedRows[], c_IgnoreChanges, c_NoRefreshChildren)
	
END IF

CALL SUPER::rbuttondown
end event

type gb_criteria from groupbox within u_document_registration
integer x = 9
integer y = 80
integer width = 3520
integer height = 924
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Criteria"
end type

