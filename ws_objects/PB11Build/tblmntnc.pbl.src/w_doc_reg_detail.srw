$PBExportHeader$w_doc_reg_detail.srw
$PBExportComments$Detail Window for Inserting and Modifying Documents
forward
global type w_doc_reg_detail from w_response_std
end type
type cb_save from u_cb_ok within w_doc_reg_detail
end type
type cb_cancel from commandbutton within w_doc_reg_detail
end type
type cb_ok from u_cb_ok within w_doc_reg_detail
end type
type dw_docs_edit from u_dw_std within w_doc_reg_detail
end type
end forward

global type w_doc_reg_detail from w_response_std
integer x = 0
integer y = 376
integer width = 3589
integer height = 1140
string title = "Add Document"
long backcolor = 79748288
cb_save cb_save
cb_cancel cb_cancel
cb_ok cb_ok
dw_docs_edit dw_docs_edit
end type
global w_doc_reg_detail w_doc_reg_detail

type variables
LONG			i_nMaxValue
LONG			i_nPrevRow
LONG        i_nFileLength
BOOLEAN		i_bNew
BOOLEAN		i_bDocSaved
BOOLEAN     i_bChanges
BOOLEAN     i_bSaved = FALSE
BOOLEAN     i_bImageOK
BOOLEAN     i_bCancel
BOOLEAN     i_bCreateValid = TRUE
BOOLEAN     i_bOrigValid = TRUE
BOOLEAN     i_bExpireValid = TRUE

STRING i_cDocID
STRING i_cWindowState
STRING i_cFileandPath
STRING i_cFileName
STRING i_cCreateDate
STRING i_cOrigDate
STRING i_cExpireDate
STRING i_cCreateYear
STRING i_cOrigYear
STRING i_cExpireYear
STRING i_cCurrentDocType

N_DWSRV_MAIN		i_DWSRV_EDIT

S_DOCFIELDPROPERTIES			 i_sConfigurableField[]
end variables

forward prototypes
public function integer fw_addimage (string fileandpath)
public function long fw_buildfieldlist ()
public function long fw_displayfields ()
public subroutine fu_clearfields ()
end prototypes

public function integer fw_addimage (string fileandpath);//**************************************************************************************************
//
//  Function: fw_AddImage
//  Purpose:  To add the document image file after document placeholder record has been saved
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------------
//  03/30/01 C. Jackson  Original Version
//  
//**************************************************************************************************

STRING l_cDocPart1, l_cDocPart2
LONG l_nLoops, l_nCounter, l_nBytes, l_nNumSpaces
INT l_nFileNum
BLOB l_bTotalImage, l_bPartialImage

// Get the File Length
i_nFileLength = FileLength(FileAndPath)

// Get the File Number
l_nFileNum = FileOpen(FileAndPath, StreamMode!)

IF l_nFileNum = -1 THEN
	messagebox(gs_AppName, 'Unable to Add document '+i_cFileName+'.  Please make sure the file is not open.')
	RETURN 0
END IF

// Determine how many times to call FileRead
IF i_nFileLength > 32765 THEN
	IF Mod(i_nFileLength,32765) = 0 THEN
		l_nLoops = i_nFileLength/32765
	ELSE
		l_nLoops = CEILING(i_nFileLength/32765)
	END IF
ELSE
	l_nLoops = 1
END IF

IF l_nFileNum <> - 1 THEN
	
	FOR l_nCounter = 1 TO l_nLoops
		l_nBytes = FileRead(l_nFileNum, l_bPartialImage)
		l_bTotalImage = l_bTotalImage + l_bPartialImage
	NEXT
	
	//Close the File
	FileClose(l_nFileNum)
	
	//Insert the blob into the document table
	SetPointer(HourGlass!)
	i_cDocID = dw_docs_edit.GetItemString(1,'documents_doc_id')
	
	UPDATEBLOB cusfocus.documents
	       SET doc_image = :l_bTotalImage
		  WHERE doc_id = :i_cDocID
		  USING SQLCA;
		  
		  
	IF SQLCA.SQLCode <> 0 THEN
		   Messagebox(gs_AppName,'Unable to add document image.')
			RETURN 0
	END IF
	
		SELECTBLOB doc_image
			INTO :l_bTotalImage
			FROM cusfocus.documents
		  WHERE doc_id = :i_cDocID
		  USING SQLCA;

	//Remove any spaces from the i_cFileName before writing to the database 
	l_nNumSpaces = Len(i_cFileName)
	
	DO UNTIL l_nNumSpaces = 0
		l_nNumSpaces = POS(i_cFileName," ")
		l_cDocPart1 = MID(i_cFileName,1,l_nNumSpaces - 1)
		l_cDocPart2 = MID(i_cFileName,l_nNumSpaces + 1)
		i_cFileName = l_cDocPart1 + l_cDocPart2
	LOOP
	
	//Add the i_cFileName and mark the document record as having an image attached to it
	
	UPDATE cusfocus.documents
	   SET doc_image_flag = 'Y',
		    doc_filename = :i_cFileName
	 WHERE doc_id = :i_cDocID
	 USING SQLCA;
	 
END IF

RETURN 1


end function

public function long fw_buildfieldlist ();//************************************************************************************************
//
//	Function:	fw_buildfieldlist
//	Purpose:		Add defined configurable fields to the field list for the selected source
//	            type.
//	Returns:		LONG ->	 0 - success
//								-1 - failure
//								
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  04/26/00 C. Jackson    Origianl verison (Adapted from u_search_criteria.fu_displayfields)
//  
//************************************************************************************************

U_DS_DOC_FIELD_LIST	l_dsDocFields
LONG					l_nCount, l_nColIndex, l_nNumConfigFields

// retrieve the list of fields from the database.
l_dsDocFields = CREATE u_ds_doc_field_list
l_dsDocFields.SetTransObject(SQLCA)
l_nNumConfigFields = l_dsDocFields.Retrieve()

// process the list of fields.
IF l_nNumConfigFields > 0 THEN
	FOR l_nCount = 1 to l_nNumConfigFields
		// get the column name associated with this field
		i_sConfigurableField[l_nCount].doc_column_name = l_dsDocFields.GetItemString(l_nCount, &
					"field_definitions_doc_column_name")
		IF IsNull (i_sConfigurableField[l_nCount].doc_column_name) OR &
			(Trim (i_sConfigurableField[l_nCount].doc_column_name) = "") THEN
			i_sConfigurableField[l_nCount].doc_column_name = ""
		END IF
		
		// get the column label associated with this field
		i_sConfigurableField[l_nCount].doc_field_label = l_dsDocFields.GetItemString(l_nCount, &
					"document_fields_doc_field_label")
					
		IF IsNull (i_sConfigurableField[l_nCount].doc_field_label) OR &
			(Trim (i_sConfigurableField[l_nCount].doc_field_label) = "") THEN
			i_sConfigurableField[l_nCount].doc_field_label = ""
		END IF
		
		// get the field width associated with this field
		i_sConfigurableField[l_nCount].doc_field_length = l_dsDocFields.GetItemNumber(l_nCount, &
					"field_definitions_field_length")
		IF IsNull (i_sConfigurableField[l_nCount].doc_field_length) THEN
			i_sConfigurableField[l_nCount].doc_field_length = 50
		END IF
		
		// get the edit mask associated with this field
		i_sConfigurableField[l_nCount].edit_mask = l_dsDocFields.GetItemString(l_nCount, &
					"display_formats_edit_mask")
		IF IsNull (i_sConfigurableField[l_nCount].edit_mask) OR &
			(Trim (i_sConfigurableField[l_nCount].edit_mask) = "") THEN
			i_sConfigurableField[l_nCount].edit_mask = ""
		END IF
		
		// get the display format associated with this field
		i_sConfigurableField[l_nCount].display_format = l_dsDocFields.GetItemString(l_nCount, &
					"display_formats_display_format")
		IF IsNull (i_sConfigurableField[l_nCount].display_format) OR &
			(Trim (i_sConfigurableField[l_nCount].display_format) = "") THEN
			i_sConfigurableField[l_nCount].display_format = '[general]'
		END IF
		
		// get the validation rule associated with this field
		i_sConfigurableField[l_nCount].validation_rule = l_dsDocFields.GetItemString(l_nCount, &
					"display_formats_validation_rule")
		IF IsNull (i_sConfigurableField[l_nCount].validation_rule) OR &
			(Trim (i_sConfigurableField[l_nCount].validation_rule) = "") THEN
			i_sConfigurableField[l_nCount].validation_rule = ''
		END IF
		
		// get the error message associated with this field
		i_sConfigurableField[l_nCount].error_msg = l_dsDocFields.GetItemString(l_nCount, &
					"display_formats_error_msg")
		IF IsNull (i_sConfigurableField[l_nCount].error_msg) OR &
			(Trim (i_sConfigurableField[l_nCount].error_msg) = "") THEN
			i_sConfigurableField[l_nCount].error_msg = ''
		END IF

	NEXT
END IF

// remove the datastore from memory
DESTROY l_dsDocFields

RETURN 0
end function

public function long fw_displayfields ();//************************************************************************************************
//
//	Function:	fu_displayfields
//	Purpose:		Add the user configured fields for the current source type to the
//	            datawindow.
//	Parameters:	CHARACTER	source_type - the source for which to build the field list.
//	Returns:		LONG ->	 0 - success
//								-1 - failure
//								
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  04/26/00 C. Jackson  Origianl verison (Adapted from u_search_criteria.fu_displayfields)
//  10/15/01 C. Jackson  For Sybase issue: if display_format is general, set edit mask
//                       to 'a' (to the lenghth of the defined column)
//  12/03/01 C. Jackson  Correct handling of quotes so that Label with an apostrophe will 
//                       display correctly.
//  
//************************************************************************************************

LONG l_nRecordCount, l_nCounter, l_nIndex, l_nFieldLength
STRING l_cDocTypeID, l_cNewFieldLabel, l_cColName, l_cColFormatID, l_cColFormat, l_cModLabelString
STRING l_cModLabelVisible, l_cModDataVisible, l_cModEditMask, l_cValidationRule, l_cErrorMsg
STRING l_cModDataValidation, l_cFormatName, l_cMsg, l_cModError
LONG l_nDatePos, l_nTimePos

	// Grab the Document Type 
	l_cDocTypeID = dw_docs_edit.GetText()

	// Count the number of records for this DocTypeID
		SELECT count(*) INTO :l_nRecordCount
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
		SELECT edit_mask, validation_rule, error_msg INTO :l_cColFormat, :l_cValidationRule, :l_cErrorMsg
		  FROM cusfocus.display_formats
		 WHERE format_id = :l_cColFormatID
		 USING SQLCA;
		 
		IF TRIM(l_cColFormat) = "" THEN
			SetNull(l_cColFormat)
			FOR l_nIndex = 1 TO l_nFieldLength
				IF l_nIndex = 1 THEN
					l_cColFormat = 'a'
				ELSE
					l_cColFormat = l_cColFormat + 'a'
				END IF
			NEXT
		 
		END IF
		
		 // Determine if this is a date/time format
		 SELECT format_name INTO :l_cFormatName
		   FROM cusfocus.display_formats
		  WHERE format_id = :l_cColFormatID
		    AND format_name LIKE '%date%'
		  USING SQLCA;
		  
	 	IF NOT ISNULL(l_cNewFieldLabel) THEN
			l_cModLabelString = 'documents_doc_config_'+string(l_nCounter)+'_t.text = "'+l_cNewFieldLabel+':"'
			l_cModLabelVisible = "documents_doc_config_"+string(l_nCounter)+"_t.Visible = 1"
			l_cModDataVisible = "documents_doc_config_"+string(l_nCounter)+".Visible = 1"
			l_cModDataValidation = "documents_doc_config_"+string(l_nCounter) + &
									'.Validation="'+l_cValidationRule+'" '
			l_cModError = "documents_doc_config_"+string(l_nCounter) + &
									'.ValidationMsg="'+l_cErrorMsg+'" '
			IF NOT ISNULL(l_cModLabelString) THEN
				dw_docs_edit.Modify(l_cModLabelString)
				
			END IF
			IF NOT ISNULL(l_cModLabelVisible) THEN
				dw_docs_edit.Modify(l_cModLabelVisible)
			END IF
			IF NOT ISNULL(l_cModDataVisible) THEN
				dw_docs_edit.Modify(l_cModDataVisible)
			END IF
			IF NOT ISNULL(l_cModDataValidation) THEN
				dw_docs_edit.Modify(l_cModDataValidation)
			END IF
			IF NOT ISNULL(l_cModError) THEN
				dw_docs_edit.Modify(l_cModError)
			END IF			
			IF NOT ISNULL(l_cColFormat) and l_cColFormat <> "" THEN
				l_cModEditMask = "documents_doc_config_"+string(l_nCounter)+".EditMask.Mask='"+l_cColFormat+"'"
				dw_docs_edit.Modify(l_cModEditMask)
			END IF
		END IF
		
		l_nCounter++
		
	LOOP


RETURN 1
end function

public subroutine fu_clearfields ();//**********************************************************************************************
//
//  Function: fu_clearfields
//  Purpose:  To clear the screen
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  04/06/01 C. Jackson  Original Version
//  05/01/01 C. Jackson  Correct logic to reset the datawindow (SCR 2058)
//
//**********************************************************************************************

dw_docs_edit.DeleteRow(1)

dw_docs_edit.ResetUpdate()

dw_docs_edit.InsertRow(0)

dw_docs_edit.SetItem(1, 'documents_doc_type_id', i_cCurrentDocType)
dw_docs_edit.SetItem(1, 'documents_doc_create_dt', fw_getTimeStamp())
end subroutine

event open;call super::open;//****************************************************************************************
//	 Event:	 open
//	 Purpose: Update the configurable fields based on the document type
//				
//  Date     Developer    Description
//	 -------- ------------ ---------------------------------------------------------------
//	 03/15/00 C. Jackson   Original Version
//	 03/17/00 C. Jackson   Commented out SetItem on "documents_doc_type_id", not needed 
//                        (SCR 387)
//  04/06/00 C. Jackson   Add modify to apply editmask (SCR 498)
//  04/25/00 C. Jackson   Add fw_buildfieldlist() and fw_displayfields() (SCR 561)
//
//****************************************************************************************

LONG 		l_nRtn, l_nRecordCount, l_nCounter
STRING   l_cDocTypeID, l_cNewFieldLabel, l_cColName, l_cColFormatID, l_cColFormat
STRING	l_cModLabelString, l_cModLabelVisible, l_cModDataVisible, l_cModEditMask

dw_docs_edit.SetItem(1,"documents_doc_type_id",w_table_maintenance.uo_document_registration.i_cDocTypeID)

// Reset all configurable columns to not visible
FOR l_nCounter = 1 TO 10
	l_cModLabelVisible = "documents_doc_config_"+string(l_nCounter)+"_t.Visible = 0"
	l_cModDataVisible = "documents_doc_config_"+string(l_nCounter)+".Visible = 0"
	dw_docs_edit.Modify(l_cModLabelVisible)
	dw_docs_edit.Modify(l_cModDataVisible)
NEXT

	fw_buildfieldlist()
	fw_displayfields()

dw_docs_edit.SetFocus()

IF i_cWindowState = 'NEW' THEN
	dw_docs_edit.SetColumn('documents_doc_type_id')
ELSE
	dw_docs_edit.SetColumn('documents_doc_name')
END IF

IF w_table_maintenance.i_bNewDoc THEN
	dw_docs_edit.SetItem(1, 'documents_doc_create_dt', fw_getTimeStamp())
	dw_docs_edit.SetItem(1, 'documents_doc_general_flag','N')
	dw_docs_edit.SetColumn('documents_doc_name')
END IF



end event

event pc_setvariables;//*****************************************************************************************
//   Event:      pc_setvariables
//   Purpose:    Store the parameters passed to this window
//   
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	03/06/00 C. Jackson   Original Version
//*****************************************************************************************/

S_DOCFIELDPROPERTIES	l_sParms

l_sParms = powerobject_parm

i_cDocID = l_sParms.doc_id
i_cWindowState = l_sParms.window_state

w_doc_reg_detail.i_bDocSaved = FALSE


end event

on w_doc_reg_detail.create
int iCurrent
call super::create
this.cb_save=create cb_save
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_docs_edit=create dw_docs_edit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_save
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.dw_docs_edit
end on

on w_doc_reg_detail.destroy
call super::destroy
destroy(this.cb_save)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_docs_edit)
end on

event pc_close;call super::pc_close;//***********************************************************************************************
//
//  Event:   pc_close
//  Purpose: SetItemStatus to not modified if necessary
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/14/01 C. Jackson  Original Version
//
//***********************************************************************************************

dwitemstatus l_status
LONG l_nRow
BOOLEAN l_bexist

l_nRow = dw_docs_edit.GetRow()

IF w_doc_reg_detail.i_bDocSaved THEN
	
	// The document has already been saved, set status to notmodified!
	dw_docs_edit.SetItemStatus(l_nRow,0,Primary!, NotModified!)
	close(w_doc_reg_detail)
	
END IF
	

end event

event pc_closequery;call super::pc_closequery;//*************************************************************************************************
//
//  Event:   pc_closequery
//  Purpose: Close any documents that might be open
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

DO WHILE l_nCounter <= w_table_maintenance.i_nDocCounter
	
	// Get the doc name from the instance array
	IF NOT ISNULL(w_table_maintenance.i_cOpenDocs[l_nCounter]) THEN
		l_cDocName = w_table_maintenance.i_cOpenDocs[l_nCounter]
	END IF

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
					messagebox(gs_AppName,'You must close the Adobe Acrobat File "' + l_cDocName + '" before closing this window.')
				CASE '.DOC'
					messagebox(gs_AppName,'You must close the Word Document "' + l_cDocName + '" before closing this window.')
				CASE '.XLS'
					messagebox(gs_AppName,'You must close the Excel Spreadsheet "' + l_cDocName + '" before closing this window.')
			END CHOOSE
			
			Error.i_FWError = c_Fatal
			EXIT
			
		END IF
			
	END IF
	
l_nCounter++	
LOOP
end event

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To set window options
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  07/06/01 C. Jackson  Original Version
//**********************************************************************************************

fw_SetOptions (c_NoEnablePopup)


end event

type cb_save from u_cb_ok within w_doc_reg_detail
integer x = 2491
integer y = 892
integer width = 320
integer taborder = 30
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save"
end type

event clicked;call super::clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: To save the changes and close the window.
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  01/11/01 C. Jackson  Original Version
//  03/27/01 C. Jackson  SetFocus back to dw_search_criteria on closure
//  06/26/01 C. Jackson  Add fw_getkeyvalue (removed from ue_newdocument in w_table_maintenance
//                       (SCR 2117)
//
//************************************************************************************************

STRING l_cDocTypeID, l_cDocName
LONG l_nReturn, l_nRtn, l_nCount
BOOLEAN l_bOK, l_bBadDocName

l_nCount = 0

i_cDocID = fw_getkeyvalue('documents')

dw_docs_edit.SetItem(1,'documents_doc_id', i_cDocID)

dw_docs_edit.AcceptText()


IF NOT i_bChanges THEN
	fw_SetOptions(c_CloseNoSave)
	l_nReturn = messagebox(gs_AppName,'No changes made, do you wish to close?', Question!, YesNo!)
	
	IF l_nReturn = 1 THEN
		CLOSE(PARENT)
		RETURN 0
	ELSE
		dw_docs_edit.SetFocus()
		dw_docs_edit.SetColumn('documents_doc_name')
		RETURN
	END IF
		
ELSE

	IF i_bImageOK THEN

		l_cDocTypeID = dw_docs_edit.GetItemString(1,'documents_doc_type_id')
		l_cDocName = TRIM(dw_docs_edit.GetItemString(1,'documents_doc_name'))
		
		SELECT COUNT (*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_name = :l_cDocName
		   AND doc_type_id = :l_cDocTypeID
		 USING SQLCA;
		 
		IF l_nCount > 0 THEN
			messagebox(gs_AppName,'Document "'+l_cDocName+'" already exists for this document type.')
			l_bBadDocName = TRUE
			l_bOK = FALSE
			l_nCount = 0
			dw_docs_edit.SetFocus()
			dw_docs_edit.SetColumn('documents_doc_name')
		ELSE
			l_nReturn = dw_docs_edit.fu_Save(dw_docs_edit.c_SaveChanges)
				IF l_nReturn = 0 THEN
					l_bOK = TRUE
				END IF
		END IF

		
		IF l_nReturn = dw_docs_edit.c_Success THEN														
			IF NOT ISNULL(i_cFileName) THEN
				l_nRtn = fw_addimage(i_cFileandPath)
				IF l_nRtn <> 1 THEN
					messagebox(gs_AppName,'Error associating Image With Document', Exclamation!)
				ELSE
					Messagebox(gs_AppName,'File "'+i_cFileName+'" ('+string(i_nFileLength)+' bytes) was '+&
							  'successfully associated with the Document.')
				END IF
				
			END IF
		END IF
		

		w_table_maintenance.uo_document_registration.dw_search_criteria.SetFocus()
		w_table_maintenance.uo_document_registration.dw_search_criteria.SetColumn('doc_name')
		
	ELSE
		

		l_cDocTypeID = dw_docs_edit.GetItemString(1,'documents_doc_type_id')
		l_cDocName = TRIM(dw_docs_edit.GetItemString(1,'documents_doc_name'))
		
		SELECT COUNT (*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_name = :l_cDocName
		   AND doc_type_id = :l_cDocTypeID
		 USING SQLCA;
		 
		IF l_nCount > 0 THEN
			messagebox(gs_AppName,'Document "'+l_cDocName+'" already exists for this document type.')
			l_bBadDocName = TRUE
			l_bOK = FALSE
			l_nCount = 0
			dw_docs_edit.SetFocus()
			dw_docs_edit.SetColumn('documents_doc_name')
			
		ELSE
			l_nReturn = dw_docs_edit.fu_Save(dw_docs_edit.c_SaveChanges)
			IF l_nReturn = 0 THEN
				l_bOK = TRUE
			END IF
		END IF
		
	END IF
	
END IF

IF l_bBadDocName THEN
	dw_docs_edit.SetFocus()
	dw_docs_edit.SetColumn('documents_doc_name')
	
END IF


IF l_bOK  THEN
	// Update document registration screen with new information
	i_cCurrentDocType = dw_docs_edit.GetItemString(1,'documents_doc_type_id')
	w_table_maintenance.uo_document_registration.dw_matched_records.Retrieve()
	fu_clearfields()
	i_bChanges = FALSE
	i_bSaved = TRUE
	dw_docs_edit.SetFocus()
	dw_docs_edit.SetColumn('documents_doc_name')
   
	
END IF


end event

type cb_cancel from commandbutton within w_doc_reg_detail
integer x = 3205
integer y = 892
integer width = 320
integer height = 108
integer taborder = 20
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: to close without saving
//  
//  Date     Developer   Desription
//  -------- ----------- ------------------------------------------------------------------------
//  01/11/01 C. Jackson  Original Version
//  04/10/01 C. Jackson  If there will be no rows to retrieve on parent window, set boolean to
//                       false (SCR 1627)
//
//***********************************************************************************************

LONG l_nCount

fw_SetOptions(c_CloseNoSave)

w_table_maintenance.i_bAddDocCancel = TRUE

CLOSEWITHRETURN(PARENT,w_table_maintenance.uo_document_registration.i_cDocTypeID)


end event

type cb_ok from u_cb_ok within w_doc_reg_detail
integer x = 2848
integer y = 892
integer width = 320
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;call super::clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: To save the changes and close the window.
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  01/11/01 C. Jackson  Original Version
//  03/27/01 C. Jackson  SetFocus back to dw_search_criteria on closure
//  06/26/01 C. Jackson  Add fw_getkeyvalue (removed from ue_newdocument in w_table_maintenance
//                       (SCR 2117)
//
//************************************************************************************************

STRING l_cDocTypeID, l_cDocName
LONG l_nReturn, l_nRtn, l_nCount
BOOLEAN l_bOK, l_bBadDocName

l_nCount = 0

i_cDocID = fw_getkeyvalue('documents')

dw_docs_edit.SetItem(1,'documents_doc_id',i_cDocID)

dw_docs_edit.AcceptText()

IF l_bBadDocName THEN
	dw_docs_edit.SetFocus()
	dw_docs_edit.SetColumn('documents_doc_name')
	RETURN
END IF

IF NOT i_bChanges THEN
	IF NOT i_bSaved THEN
		fw_SetOptions(c_CloseNoSave)
		l_nReturn = messagebox(gs_AppName,'No changes made, do you wish to close?', Question!, YesNo!)
	ELSE
		l_nReturn = 1
	END IF
	
	IF l_nReturn = 1 THEN

		// The document has either already been saved or user doesn't wish to save
		l_cDocTypeID = dw_docs_edit.GetItemString(1,'documents_doc_type_id')
		dw_docs_edit.SetItemStatus(1,0,Primary!, NotModified!)
		CLOSEWITHRETURN(PARENT,l_cDocTypeID)
		RETURN 0
	ELSE
		dw_docs_edit.SetFocus()
		dw_docs_edit.SetColumn('documents_doc_name')
		RETURN
	END IF
		
ELSE

	IF i_bImageOK THEN
		
		l_cDocTypeID = dw_docs_edit.GetItemString(1,'documents_doc_type_id')
		l_cDocName = TRIM(dw_docs_edit.GetItemString(1,'documents_doc_name'))
		
		SELECT COUNT (*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_name = :l_cDocName
		   AND doc_type_id = :l_cDocTypeID
		 USING SQLCA;
		 
		IF l_nCount > 0 THEN

			messagebox(gs_AppName,'Document "'+l_cDocName+'" already exists for this document type.')
			l_bBadDocName = TRUE
			l_bOK = FALSE
			l_nCount = 0
			dw_docs_edit.SetFocus()
			dw_docs_edit.SetColumn('documents_doc_name')
		ELSE
			i_cDocID = fw_getkeyvalue('documents')
			dw_docs_edit.SetItem(1,'documents_doc_id',i_cDocID)
			l_nReturn = dw_docs_edit.fu_Save(dw_docs_edit.c_SaveChanges)
				IF l_nReturn = 0 THEN
					l_bOK = TRUE
				END IF
		END IF

		
		IF l_nReturn = dw_docs_edit.c_Success THEN														
			IF NOT ISNULL(i_cFileName) THEN
				l_nRtn = fw_addimage(i_cFileandPath)
				IF l_nRtn <> 1 THEN
					messagebox(gs_AppName,'Error associating Image With Document', Exclamation!)
				ELSE
					Messagebox(gs_AppName,'File "'+i_cFileName+'" ('+string(i_nFileLength)+' bytes) was '+&
							  'successfully associated with the Document.')
				END IF
				
			END IF
		END IF
		

		w_table_maintenance.uo_document_registration.dw_search_criteria.SetFocus()
		w_table_maintenance.uo_document_registration.dw_search_criteria.SetColumn('doc_name')
		
	ELSE
		
		dw_docs_edit.SetItem(1,'documents_doc_id',i_cDocID)
		l_cDocTypeID = dw_docs_edit.GetItemString(1,'documents_doc_type_id')
		l_cDocName = TRIM(dw_docs_edit.GetItemString(1,'documents_doc_name'))
		
		SELECT COUNT (*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_name = :l_cDocName
		   AND doc_type_id = :l_cDocTypeID
		 USING SQLCA;
		 
		IF l_nCount > 0 THEN
			messagebox(gs_AppName,'Document "'+l_cDocName+'" already exists for this document type.')
			l_bBadDocName = TRUE
			l_bOK = FALSE
			l_nCount = 0
			dw_docs_edit.SetFocus()
			dw_docs_edit.SetColumn('documents_doc_name')
		ELSE
			i_cDocID = fw_getkeyvalue('documents')
			dw_docs_edit.SetItem(1,'documents_doc_id',i_cDocID)
			l_nReturn = dw_docs_edit.fu_Save(dw_docs_edit.c_SaveChanges)
			
			IF l_nReturn = 0 THEN
				l_bOK = TRUE
			END IF
		END IF
		
	END IF
	
	IF l_bOK  THEN
		// Update document registration screen with new information
		l_cDocTypeID = dw_docs_edit.GetItemString(1,'documents_doc_type_id')
		w_table_maintenance.uo_document_registration.dw_doc_reg_type.SetItem(1,'doc_type_id',l_cDocTypeID)
		CLOSEWITHRETURN(PARENT,l_cDocTypeID)

	END IF

	
END IF


end event

type dw_docs_edit from u_dw_std within w_doc_reg_detail
integer x = 5
integer y = 8
integer width = 3570
integer height = 860
integer taborder = 10
string dataobject = "d_doc_reg_edit"
borderstyle borderstyle = styleraised!
end type

event itemchanged;//****************************************************************************************
//
//	 Event:	itemchanged
//	 Purpose: Handle user configurable fields
//				
//	 Date     Developer    Description
//	 -------- ------------ ----------------------------------------------------------------
//	 03/15/00 C. Jackson   Original Version
//  04/06/00 C. Jackson   Add modify for display format for document fields (SCR 498)
//  04/27/00 C. Jackson   Add fw_buildfieldlist() and fw_displayfields (SCR 561)
//  
//****************************************************************************************

LONG 		l_nRtn, l_nRecordCount, l_nCounter, l_nRow, l_nNumConfigFields, l_nCount
STRING   l_cDocTypeID, l_cNewFieldLabel, l_cColName, l_cColFormatID, l_cColFormat, l_cDocName
STRING	l_cModLabelString, l_cModLabelVisible, l_cModDataVisible, l_cModEditMask
S_FIELDPROPERTIES	l_sParms
u_ds_field_list	l_dsFields

i_bChanges = TRUE

// retrieve the list of fields for source_type from the database
l_dsFields = CREATE u_ds_field_list
l_dsFields.SetTransObject(SQLCA)
l_nNumConfigFields = l_dsFields.Retrieve()

CHOOSE CASE dwo.Name
	CASE 'documents_doc_type_id'

	// Reset all configurable columns to not visible
	FOR l_nCounter = 1 TO 10
		l_cModLabelVisible = "documents_doc_config_"+string(l_nCounter)+"_t.Visible = 0"
		l_cModDataVisible = "documents_doc_config_"+string(l_nCounter)+".Visible = 0"
		dw_docs_edit.Modify(l_cModLabelVisible)
		dw_docs_edit.Modify(l_cModDataVisible)
	NEXT
	
	fw_buildfieldlist()
	fw_displayfields()
	
	CASE 'documents_doc_create_dt'
		i_cCreateDate = data
		i_cCreateYear = MID(i_cCreateDate,1,4)
		IF LONG(i_cCreateYear) < 1753 OR LONG(i_cCreateYear) > 2300 THEN
			i_bCreateValid = FALSE
		ELSE
			i_bCreateValid = TRUE
		END IF
		
	CASE 'documents_doc_orig_dt'
		i_cOrigDate = data
		i_cOrigYear = MID(i_cOrigDate,1,4)
		IF LONG(i_cOrigYear) < 1753 OR LONG(i_cOrigYear) > 2300 THEN
			i_bOrigValid = FALSE
		ELSE
			i_bOrigValid = TRUE
		END IF
		
	CASE 'documents_doc_expire_dt'
		i_cExpireDate = data
		i_cExpireYear = MID(i_cExpireDate,1,4)
		IF LONG(i_cExpireYear) < 1753 OR LONG(i_cExpireYear) > 2300 THEN
			i_bExpireValid = FALSE
		ELSE
			i_bExpireValid = TRUE
		END IF
		
END CHOOSE



end event

event pcd_retrieve;call super::pcd_retrieve;//*****************************************************************************************
//  Event:      pcd_retrieve
//  Purpose:    To retrieve the document
//   
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//	 03/07/00 C. Jackson  Original Version
//  04/06/00 C. Jackson  Add modify statemnt for editmask defined in Document Fields (SCR 498)
//  04/27/00 C. Jackson  Add fw_buildfieldlist() and fw_displayfields (SCR 561)
//  05/08/00 C. Jackson  Add call to fw_gettimestamp for the create date/time (SCR 616)
//  01/12/01 C. Jackson  Remove automatic setting of create date/time to today (SCR 1279)
//
//*****************************************************************************************

LONG 		l_nReturn, l_nCounter, l_nRecordCount
STRING	l_cModLabelVisible, l_cModDataVisible, l_cNewFieldLabel, l_cColName, l_cModLabelString
STRING   l_cColFormatID, l_cColFormat, l_cModEditMask
W_TABLE_MAINTENANCE l_wParentWindow
S_DOCFIELDPROPERTIES l_sParms

l_nReturn = Retrieve(i_cdocid)

// Make sure the window is set to allow editing of the new case.
THIS.Enabled = TRUE

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF

CHOOSE CASE l_nReturn
	CASE IS < 0
   	Error.i_FWError = c_Fatal
	CASE 0
  		i_nMaxValue = 0
	CASE ELSE
		i_nMaxValue = GetItemNumber (1, "maxvalue")
		
END CHOOSE

// Reset all to not visible
FOR l_nCounter = 1 TO 10
	l_cModLabelVisible = "documents_doc_config_"+string(l_nCounter)+"_t.Visible = 0"
	l_cModDataVisible = "documents_doc_config_"+string(l_nCounter)+".Visible = 0"
	dw_docs_edit.Modify(l_cModLabelVisible)
	dw_docs_edit.Modify(l_cModDataVisible)
NEXT

	fw_buildfieldlist()
	fw_displayfields()

IF i_cWindowState = 'NEW' THEN
	dw_docs_edit.InsertRow(0)
	dw_docs_edit.SetColumn('documents_doc_type_id')
	
END IF


end event

event pcd_setoptions;//*********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: Initialize dw_docs_edit
//   
//  Revisions:
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/07/00 C. Jackson  Original Version
//  06/04/01 C. Jackson  Add c_NoRetrieveOnOpen
//  07/09/01 C. Jackson  Add c_NoEnablePopup (SCR 1434)
//
//*********************************************************************************************

fu_SetOPtions ( SQLCA, c_NullDW, c_ModifyOK + c_NewOK + c_DeleteOK + c_ModifyOnOpen + &
                c_ModifyOnOpen + c_NoEnablePopup)


end event

event pcd_savebefore;call super::pcd_savebefore;//******************************************************************************************
//
//   Event:   pcd_savebefore
//   Purpose: Get ready to save
//   
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------
//	 03/28/00 C. Jackson    Original Version
//  04/24/00 C. Jackson    Add logic to populate the updated_by and update_timestamp fields
//                         (SCR 563)
//  05/10/00 C. Jackson    Make sure document name isn't null (SCR 630)
//  10/06/00 C. Jackson    Add call to fw_getkeyvalue
//
//******************************************************************************************

STRING l_cDocKey, l_cStatus, l_cDocName, l_cDocTypeID
LONG l_nRow, l_nResults
W_TABLE_MAINTENANCE l_wParentWindow

l_nRow = dw_docs_edit.GetRow()


// check to see if there is already a key for this record
l_cDocKey = dw_docs_edit.GetItemString(l_nRow,'documents_doc_id')
// Make sure document name isn't null
l_cDocName = dw_docs_edit.GetItemString(l_nRow,'documents_doc_name')
IF ISNULL(l_cDocName) THEN
	Messagebox(gs_AppName,'The Document Name is required.  ' + &
		'Please enter a Document Name.')
		Error.i_FWError = c_ValFailed
		SetFocus()
		SetColumn('documents_doc_name')
		
		RETURN
END IF

// Make sure status isn't null
l_cStatus = dw_docs_edit.GetItemString(l_nRow,'documents_doc_status_id')
IF ISNULL(l_cStatus) THEN
		Messagebox(gs_AppName,'The Status is required.  ' + &
				'Please enter a valid status.')
		Error.i_FWError = c_ValFailed		
		SetFocus()
		SetColumn('documents_doc_status_id')
	
		RETURN				
END IF

// populate updated_by and update_timestamp
dw_docs_edit.SetItem(l_nRow, 'documents_updated_by', OBJCA.WIN.fu_GetLogin(SQLCA))
dw_docs_edit.SetItem(l_nRow, 'documents_updated_timestamp', fw_getTimeStamp())


end event

event pcd_saveafter;call super::pcd_saveafter;////*****************************************************************************************
////   Event:      pcd_saveafter
////   Purpose:    Update the list datawindow on u_document_registration
////   
////  Date     Developer    Description
////  ======== ============ =================================================================
////	 03/28/00 C. Jackson   Original Version
////*****************************************************************************************/

//
//STRING				l_cTabLabel, l_cStringParms[]
//BOOLEAN				l_bEnabled, l_bVisible
//WINDOWOBJECT		l_woObjects[]
//U_DOCUMENT_REGISTRATION		l_uContainer
//U_DW_STD				l_dwSource
//
//w_table_maintenance.dw_folder.fu_TabInfo (2, l_cTabLabel, l_bEnabled, l_bVisible, l_woObjects[])
//
//IF upperbound (l_woObjects[]) > 0 THEN
//	
//	l_uContainer = l_woObjects[1]
//	
//
//END IF
end event

event pcd_validatecol;call super::pcd_validatecol;//*****************************************************************************************
//  Event:      pcd_validatecol
//  Purpose:    Perform data validation
//   
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------
//  03/28/00 C. Jackson  Original Version
//  07/14/00 C. Jackson  Add more date validation - the year wasn't getting validated.  (SCR 718)
//
//*****************************************************************************************/

DATE l_dToday, l_dDate
DATETIME l_dCreateDate, l_dOrigDate
LONG l_nRow
INT  l_iYear
STRING l_cStatus, l_cDocType

l_dToday = Today()
l_nRow = GetRow()

CHOOSE CASE col_name
	CASE 'documents_doc_create_dt'
		// Validate date itself
		Error.i_FWError = OBJCA.FIELD.fu_ValidateDate(col_text, "m/d/yyyy", TRUE)
		
		// Validate Year
		IF NOT i_bCreateValid THEN
			messagebox(gs_AppName,string(i_cCreateYear)+' is not a valid year, please re-enter the Create Date.')
			Error.i_FWError = c_ValFailed
			THIS.SetFocus()
			THIS.SetColumn(col_name)
			RETURN
		END IF
		
		// Verify not a future date
		IF date(col_text) > l_dToday THEN
			MessageBox(gs_AppName, "The Create Date must not be a future date.  " + &
					"Please enter a valid Create Date.")
			Error.i_FWError = c_ValFailed
			RETURN
		END IF	

	CASE 'documents_doc_orig_dt'
		// Validate date itself
		Error.i_FWError = OBJCA.FIELD.fu_ValidateDate(col_text, "m/d/yyyy", TRUE)
		
		// Validate Year
		IF NOT i_bOrigValid THEN
			messagebox(gs_AppName,string(i_cOrigYear)+' is not a valid year, please re-enter the Origination Date.')
			Error.i_FWError = c_ValFailed
			THIS.SetFocus()
			THIS.SetColumn(col_name)
			RETURN
		END IF
			
		// Verify not a future date
		IF date(col_text) > l_dToday THEN
			MessageBox(gs_AppName, "The Origination Date must not be a future date.  " + &
					"Please enter a valid Origination Date.")
			Error.i_FWError = c_ValFailed		
		RETURN
		END IF
		
	CASE 'documents_doc_expire_dt'
		// Validate date itself
		Error.i_FWError = OBJCA.FIELD.fu_ValidateDate(col_text, "m/d/yyyy", TRUE)
		
		// Validate Year
		IF NOT i_bExpireValid THEN
			messagebox(gs_AppName,string(i_cExpireYear)+' is not a valid year, please re-enter the Expire Date.')
			Error.i_FWError = c_ValFailed
			THIS.SetFocus()
			THIS.SetColumn(col_name)
			RETURN
		END IF
			
END CHOOSE

// Make sure the user has selected a Document Type
l_cDocType = dw_docs_edit.GetItemString(l_nRow,'documents_doc_type_id')
IF ISNULL(l_cDocType) THEN
	Messagebox(gs_AppName,'The Document Type may not be null.  ' + &
	      'Please enter a valid Document Type.')
	Error.i_FWError = c_ValFailed		
RETURN
END IF

// Verify Create date is not greater than orig. date
l_dCreateDate = dw_docs_edit.GetItemDateTime(l_nRow,'documents_doc_create_dt')
l_dOrigDate = dw_docs_edit.GetItemDateTime(l_nRow,'documents_doc_orig_dt')
IF l_dCreateDate < l_dOrigDate THEN
	Messagebox(gs_AppName,'The Origination Date must not be greater than the Create Date.  ' + &
			 'Please correct the dates.')
	Error.i_FWError = c_ValFailed		 
	RETURN
END IF

end event

event editchanged;call super::editchanged;//************************************************************************************************
//
//  Event:   editchanged
//  Purpose: Set the changes flag to true for validation later
//  
//  Date     Develeper   Description
//  -------- ----------- -------------------------------------------------------------------------
//  03/30/01 C. Jackson  Original Version
//
//************************************************************************************************

i_bChanges = TRUE


end event

event buttonclicked;call super::buttonclicked;//***********************************************************************************************
//
//  Event:   buttonclicked
//  Purpose: To Associate the image to the document record
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/06/01 C. Jackson  Original Version
//  01/24/02 C. Jackosn  Changed the order that the docs will appear in the drop down.  
//***********************************************************************************************

LONG l_nCurrentColumn, l_nReturn, l_nRtn

CHOOSE CASE dwo.name
	CASE 'b_browse_filename'
		l_nCurrentColumn = dw_docs_edit.GetColumn()

		// Initialize l_nReturn to 1
		l_nReturn = 1
		
		// Display window for user to select document image file
		l_nRtn = GetFileOpenName("Select Document Image File", &
				+ i_cFileandPath, i_cFileName, "DOC", &
				+ "Doc Files (*.DOC),*.DOC," &
				+ "Acrobat Files (*.PDF),*.PDF," &
				+ "Excel Files (*.XLS),*.XLS")
				
		IF l_nRtn = 1 THEN
			
			// Set the document flag to checked
			dw_docs_edit.SetItem(1,'doc_image_flag','Y')
			dw_docs_edit.SetItem(1,'doc_filename',i_cFileName)
			i_bImageOK = TRUE
			i_bChanges = TRUE
			
		ELSEIF l_nRtn = -1 THEN
			
			i_bImageOK = FALSE
			i_bChanges = FALSE
			
		ELSE
			
			// user pressed cancel on the GetFileOpenName window
			i_bCancel = TRUE
			
		END IF
		
		dw_docs_edit.SetFocus()
dw_docs_edit.SetColumn('documents_doc_name')
end choose
end event

