$PBExportHeader$uo_tabpg_workqueues.sru
forward
global type uo_tabpg_workqueues from u_tabpg_std
end type
type cb_1 from commandbutton within uo_tabpg_workqueues
end type
type cb_add from commandbutton within uo_tabpg_workqueues
end type
type cb_attach from commandbutton within uo_tabpg_workqueues
end type
type st_select_queue from statictext within uo_tabpg_workqueues
end type
type ddlb_queues from dropdownlistbox within uo_tabpg_workqueues
end type
type gb_1 from groupbox within uo_tabpg_workqueues
end type
type gb_2 from groupbox within uo_tabpg_workqueues
end type
type uo_search_workqueues from u_search_workqueues within uo_tabpg_workqueues
end type
end forward

global type uo_tabpg_workqueues from u_tabpg_std
integer width = 3602
integer height = 1612
string text = "Work Queues"
event ue_refresh ( )
event ue_setmainfocus ( )
event ue_setneedrefresh ( )
event ue_deletefax ( )
event ue_post_constructor ( )
cb_1 cb_1
cb_add cb_add
cb_attach cb_attach
st_select_queue st_select_queue
ddlb_queues ddlb_queues
gb_1 gb_1
gb_2 gb_2
uo_search_workqueues uo_search_workqueues
end type
global uo_tabpg_workqueues uo_tabpg_workqueues

type prototypes
FUNCTION long ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "SHELL32.DLL" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
W_REMINDERS		i_wParentWindow
uo_tab_workdesk  i_tabParentTab
Boolean i_bNeedRefresh = FALSE
DataStore ids_work_queue_list



end variables

forward prototypes
public function integer of_attach (long al_selectedrow, string as_action)
public function string of_write_file (string as_file_name, long al_blob_id)
public function long of_combine_tiffs ()
end prototypes

event ue_refresh();//***********************************************************************************************
//
//  Event:   ue_Refresh
//  Purpose: Refresh the data
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************

IF THIS.i_bNeedRefresh THEN
	THIS.i_tabParentTab.SetRedraw( FALSE )	
	
	ddlb_queues.EVENT ue_retrieve()
	IF uo_search_workqueues.dw_report.GetRow() > 0 THEN
		cb_attach.Enabled = TRUE
	ELSE
		cb_attach.Enabled = FALSE
	END IF

	//Refreshed.  Reset Variable.
	THIS.i_bNeedRefresh = FALSE
	
	THIS.i_tabParentTab.SetRedraw( TRUE )
END IF
end event

event ue_setmainfocus();//***********************************************************************************************
//
//  Event:   ue_SetMainFocus
//  Purpose: Set Focus to the main datawindow
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  9/20/2002 K. Claver   Original Version
//***********************************************************************************************
THIS.uo_search_workqueues.dw_report.SetFocus( )
end event

event ue_setneedrefresh;//***********************************************************************************************
//
//  Event:   ue_SetNeedRefresh
//  Purpose: Set variable to indicate that this tab needs to be refreshed when selected
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  9/20/2002 K. Claver   Original Version
//***********************************************************************************************
THIS.i_bNeedRefresh = TRUE
end event

event ue_deletefax();INTEGER li_return
LONG ll_faxid, ll_row, ll_blob_id
n_blob_manipulator ln_blob_manipulator

// Only allow deletions from the fax queue
IF uo_search_workqueues.dw_report.dataobject <> 'd_faxlist_detail' THEN RETURN

ll_row = uo_search_workqueues.dw_report.GetRow()

ll_faxid = uo_search_workqueues.dw_report.object.fax_queue_detail_id[ll_row]
li_return = MessageBox("Delete Row", "Do you want to delete FAX ID " + String(ll_faxid) + "?", Question!, YesNo!)

IF li_return = 2 THEN RETURN 

ln_blob_manipulator = Create n_blob_manipulator

// Delete the image from blobobject
ll_blob_id = uo_search_workqueues.dw_report.object.blbobjctid[ll_row]
ln_blob_manipulator.of_delete_blob(ll_blob_id)

// Delete the info from the datawindow
uo_search_workqueues.dw_report.DeleteRow(ll_row)
uo_search_workqueues.dw_report.Update()


DESTROY n_blob_manipulator




end event

event ue_post_constructor();LONG ll_rows, ll_row
STRING ls_queue_description

ll_rows = ids_work_queue_list.RowCount()
FOR ll_row = 1 to ll_rows
	ls_queue_description = ids_work_queue_list.object.description[ll_row]
	ddlb_queues.AddItem(ls_queue_description)
NEXT

uo_search_workqueues.il_conf_level = i_wParentWindow.i_nRepConfidLevel

ddlb_queues.SelectItem(1)
//ddlb_queues.POST Event SelectionChanged(1)
end event

public function integer of_attach (long al_selectedrow, string as_action);INTEGER li_return, li_CaseConfidLevel, li_header_id
LONG ll_faxheaderid, ll_row, ll_null, ll_rows, ll_attachment_key, ll_blob_id, ll_selectedrow, ll_selectedrows
String ls_CaseNumber, ls_filter, ls_file_name, ls_desc, ls_return, ls_case_type, ls_attach, ls_description, ls_owner, ls_case_status
STRING ls_from_dept, ls_to_dept, ls_keyval, ls_current_user, ls_error
Datastore lds_attachment_list
BLOB lblb_fax
n_blob_manipulator ln_blob_manipulator
Boolean l_bAutoCommit, lb_multiple_rows
DATETIME ldt_timestamp

IF as_action = 'attach' THEN
	IF NOT IsValid(i_wParentWindow) THEN RETURN -1
	
	IF IsValid(w_create_maintain_case) THEN
		// determine the datawindow to use as the source for a case number
		CHOOSE CASE w_create_maintain_case.dw_folder.i_CurrentTab
			CASE 1, 2, 3  
				ls_CaseNumber = ""
			CASE 4
				ls_CaseNumber = w_create_maintain_case.i_cSelectedCase
			CASE 5
				ls_CaseNumber = w_create_maintain_case.i_cCurrentCase
			CASE 6
				ll_row = w_create_maintain_case.i_uoCrossReference.dw_cross_reference.GetRow()
				ls_CaseNumber = w_create_maintain_case.i_uoCrossReference.dw_cross_reference.GetItemString(ll_Row,'case_number')
			CASE 7
				ls_CaseNumber = w_create_maintain_case.i_cCurrentCase
			CASE 8
				ls_CaseNumber = w_create_maintain_case.i_cCurrentCase
				
		END CHOOSE
	ELSE
		ls_CaseNumber = ''
	END IF
		
	IF ls_CaseNumber = '' THEN
		MessageBox(gs_AppName, "Please select a case before attempting this operation.", Exclamation!)
		RETURN -1
	END IF

	SELECT case_status_id, confidentiality_level
	INTO :ls_case_status, :li_CaseConfidLevel
	FROM cusfocus.case_log
	WHERE case_number = :ls_CaseNumber
	USING SQLCA;
	
	IF i_wParentWindow.i_nRepConfidLevel < li_CaseConfidLevel THEN
		MessageBox(gs_AppName, "You do not have the proper security level to attach documents to this case.", Exclamation!)
		RETURN -1
	END IF
	
	IF ls_case_status <> 'O' AND NOT i_wParentWindow.i_bSupervisorRole THEN
		MessageBox(gs_AppName, "You can not attach documents to a Closed or Voided case.", Exclamation!)
		RETURN -1
	END IF
		
	// Find out if multiple rows are selected
	ll_rows = uo_search_workqueues.dw_report.RowCount()
	ll_row = uo_search_workqueues.dw_report.find("selectedrow = 'y'",1, ll_rows)
	IF ll_row > 0 THEN
		IF ll_row = ll_rows THEN
			ll_row = 0
		ELSE
			ll_row = uo_search_workqueues.dw_report.find("selectedrow = 'y'",ll_row + 1, ll_rows)
		END IF
		IF ll_row > 0 THEN 
			lb_multiple_rows = TRUE
			OpenWithParm(w_attach, 2)
		ELSE
			lb_multiple_rows = FALSE
			OpenWithParm(w_attach, 1)
		END IF
	END IF
	
	ls_attach = Message.StringParm
	IF LEN(ls_attach) < 2 THEN RETURN -1 // User cancelled operation
	ls_description = MID(ls_attach, 3)
	ls_attach = MID(ls_attach, 1, 1)
	
	IF lb_multiple_rows THEN
		IF ls_attach = 'c' THEN // Multiple files selected, combine into single file and attach
//		li_return = MessageBox(gs_AppName, "Attach as single document?~r~nClick No to attach each page separately.", Question!, YesNoCancel!)
//
//		IF li_return = 3 THEN RETURN -1 // User cancelled operation
//		IF li_return = 1 THEN // Multiple files selected, combine into single file and attach
			SetPointer(Hourglass!)
			ll_blob_id = of_combine_tiffs()

			ln_blob_manipulator = Create n_blob_manipulator
			
			// Get blob from blobobject
			lblb_fax = ln_blob_manipulator.of_retrieve_blob(ll_blob_id)
			
			SetNull(ll_null)
			
			// do attaching process here
			lds_attachment_list = CREATE DATASTORE
			lds_attachment_list.dataobject = 'd_attachment_list'
			lds_attachment_list.SetTransObject(SQLCA)
			
			//Add the info into the datawindow
			ll_Row = lds_attachment_list.InsertRow( 0 )
			
			ls_file_name = uo_search_workqueues.dw_report.object.faxnum[al_selectedrow]
			
			IF ll_Row > 0 THEN
				lds_attachment_list.Object.case_number[ ll_Row ] = ls_CaseNumber
				lds_attachment_list.Object.attachment_name[ ll_Row ] = ls_File_Name
				lds_attachment_list.Object.attachment_desc[ ll_Row ] = ls_Description
				lds_attachment_list.Object.updated_by[ ll_Row ] = OBJCA.WIN.fu_GetLogin( SQLCA )
				lds_attachment_list.Object.updated_timestamp[ ll_Row ] = i_wParentWindow.fw_GetTimeStamp( )
				lds_attachment_list.Object.attachment_size[ ll_Row ] = LEN(lblb_fax)
				lds_attachment_list.Object.attachment_timestamp[ ll_Row ] = i_wParentWindow.fw_GetTimeStamp( )
				lds_attachment_list.Object.attachment_created[ ll_Row ] = i_wParentWindow.fw_GetTimeStamp( )
			
				// Save to database
				ll_row = lds_attachment_list.Update()
			
				// Re-retrieve the datawindow to ensure that the identity column is populated!
				ll_rows = lds_attachment_list.Retrieve( ls_CaseNumber, ll_null )
				
				// Filter to get the row just inserted
				ls_filter = 'attachment_name = "' + ls_File_Name + '" and attachment_desc = "' + ls_Description + '"'
				lds_attachment_list.SetFilter(ls_filter)
				ll_rows = lds_attachment_list.Filter()
				ll_rows = lds_attachment_list.RowCount()
				
				IF ll_rows > 0 THEN
					//Get the key value to update the row in the database.
					ll_Attachment_Key = lds_attachment_list.Object.attachment_key[ ll_Rows ]
			
					//Store the autocommit value as needs to be true for
					//  updating the image.
					l_bAutoCommit = SQLCA.AutoCommit
					SQLCA.AutoCommit = TRUE
					
					UPDATEBLOB cusfocus.case_attachments
					SET attachment_image = :lblb_Fax
					WHERE attachment_key = :ll_Attachment_Key
					USING SQLCA;
					
					IF SQLCA.SQLCode = -1 THEN
						SetPointer(Arrow!)
						MessageBox(gs_AppName, "Error saving image to database.~r~nError returned: "+SQLCA.SQLErrText, Exclamation!)
						//Set the autocommit value back.
						SQLCA.AutoCommit = l_bAutoCommit
						RETURN -1
					END IF
					
					//Set the autocommit value back.
					SQLCA.AutoCommit = l_bAutoCommit
			
					// Refresh the attachments tab
					w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_attachments.dw_attachment_list.Retrieve( ls_CaseNumber, ll_null )
					SetPointer(Arrow!)
					MessageBox(gs_AppName, "The attachment was successful.")
				END IF
			END IF
			
			DESTROY lds_attachment_list
			DESTROY n_blob_manipulator

		ELSE // Multiple files selected, loop and attach each page separately
			SetPointer(Hourglass!)
			
			ln_blob_manipulator = Create n_blob_manipulator
		
			// do attaching process here
			lds_attachment_list = CREATE DATASTORE
			lds_attachment_list.dataobject = 'd_attachment_list'
			lds_attachment_list.SetTransObject(SQLCA)

			SetNull(ll_null)
			ll_selectedrows = uo_search_workqueues.dw_report.RowCount()
			ll_selectedrow = uo_search_workqueues.dw_report.find("selectedrow = 'y'",1, ll_rows)
			DO WHILE ll_selectedrow > 0 
		
				//Add the info into the datawindow
				ll_Row = lds_attachment_list.InsertRow( 0 )
				
				ls_file_name = uo_search_workqueues.dw_report.object.faxnum[ll_selectedrow]

				// Get blob from blobobject
				ll_blob_id = uo_search_workqueues.dw_report.object.blbobjctid[ll_selectedrow]
				lblb_fax = ln_blob_manipulator.of_retrieve_blob(ll_blob_id)
				
				IF ll_Row > 0 THEN
					lds_attachment_list.Object.case_number[ ll_Row ] = ls_CaseNumber
					lds_attachment_list.Object.attachment_name[ ll_Row ] = ls_File_Name
					lds_attachment_list.Object.attachment_desc[ ll_Row ] = ls_Description
					lds_attachment_list.Object.updated_by[ ll_Row ] = OBJCA.WIN.fu_GetLogin( SQLCA )
					lds_attachment_list.Object.updated_timestamp[ ll_Row ] = i_wParentWindow.fw_GetTimeStamp( )
					lds_attachment_list.Object.attachment_size[ ll_Row ] = LEN(lblb_fax)
					lds_attachment_list.Object.attachment_timestamp[ ll_Row ] = i_wParentWindow.fw_GetTimeStamp( )
					lds_attachment_list.Object.attachment_created[ ll_Row ] = i_wParentWindow.fw_GetTimeStamp( )
				
					// Save to database
					ll_row = lds_attachment_list.Update()
				
					// Re-retrieve the datawindow to ensure that the identity column is populated!
					ll_rows = lds_attachment_list.Retrieve( ls_CaseNumber, ll_null )
					
					// Filter to get the row just inserted
					ls_filter = 'attachment_name = "' + ls_File_Name + '" and attachment_desc = "' + ls_Description + '"'
					lds_attachment_list.SetFilter(ls_filter)
					ll_rows = lds_attachment_list.Filter()
					ll_rows = lds_attachment_list.RowCount()
					
					IF ll_rows > 0 THEN
						//Get the key value to update the row in the database.
						ll_Attachment_Key = lds_attachment_list.Object.attachment_key[ ll_Rows ]
				
						//Store the autocommit value as needs to be true for
						//  updating the image.
						l_bAutoCommit = SQLCA.AutoCommit
						SQLCA.AutoCommit = TRUE
						
						UPDATEBLOB cusfocus.case_attachments
						SET attachment_image = :lblb_Fax
						WHERE attachment_key = :ll_Attachment_Key
						USING SQLCA;
						
						IF SQLCA.SQLCode = -1 THEN
							SetPointer(Arrow!)
							MessageBox(gs_AppName, "Error saving image to database.~r~nError returned: "+SQLCA.SQLErrText, Exclamation!)
							//Set the autocommit value back.
							SQLCA.AutoCommit = l_bAutoCommit
							RETURN -1
						END IF
						
						//Set the autocommit value back.
						SQLCA.AutoCommit = l_bAutoCommit
				
					END IF
				END IF
				ll_selectedrow++
				IF ll_selectedrow > ll_selectedrows THEN EXIT
				ll_selectedrow = uo_search_workqueues.dw_report.find("selectedrow = 'y'",ll_selectedrow, ll_selectedrows)
			LOOP

			// Refresh the attachments tab
			w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_attachments.dw_attachment_list.Retrieve( ls_CaseNumber, ll_null )
			SetPointer(Arrow!)
			MessageBox(gs_AppName, "The attachment was successful.")
			
			DESTROY lds_attachment_list
			DESTROY n_blob_manipulator
	   END IF
	ELSE
		// One file selected, attach it
		ln_blob_manipulator = Create n_blob_manipulator
		
		SetNull(ll_null)
		
		SetPointer(Hourglass!)
		// do attaching process here
		lds_attachment_list = CREATE DATASTORE
		lds_attachment_list.dataobject = 'd_attachment_list'
		lds_attachment_list.SetTransObject(SQLCA)
		
		//Add the info into the datawindow
		ll_Row = lds_attachment_list.InsertRow( 0 )
		
		ls_file_name = uo_search_workqueues.dw_report.object.faxnum[al_selectedrow]

		// Get blob from blobobject
		ll_blob_id = uo_search_workqueues.dw_report.object.blbobjctid[al_selectedrow]
		lblb_fax = ln_blob_manipulator.of_retrieve_blob(ll_blob_id)

		IF ll_Row > 0 THEN
			lds_attachment_list.Object.case_number[ ll_Row ] = ls_CaseNumber
			lds_attachment_list.Object.attachment_name[ ll_Row ] = ls_File_Name
			lds_attachment_list.Object.attachment_desc[ ll_Row ] = ls_Description
			lds_attachment_list.Object.updated_by[ ll_Row ] = OBJCA.WIN.fu_GetLogin( SQLCA )
			lds_attachment_list.Object.updated_timestamp[ ll_Row ] = i_wParentWindow.fw_GetTimeStamp( )
			lds_attachment_list.Object.attachment_size[ ll_Row ] = LEN(lblb_fax)
			lds_attachment_list.Object.attachment_timestamp[ ll_Row ] = i_wParentWindow.fw_GetTimeStamp( )
			lds_attachment_list.Object.attachment_created[ ll_Row ] = i_wParentWindow.fw_GetTimeStamp( )
		
			// Save to database
			ll_row = lds_attachment_list.Update()
		
			// Re-retrieve the datawindow to ensure that the identity column is populated!
			ll_rows = lds_attachment_list.Retrieve( ls_CaseNumber, ll_null )
			
			// Filter to get the row just inserted
			ls_filter = 'attachment_name = "' + ls_File_Name + '" and attachment_desc = "' + ls_Description + '"'
			lds_attachment_list.SetFilter(ls_filter)
			ll_rows = lds_attachment_list.Filter()
			ll_rows = lds_attachment_list.RowCount()
			
			IF ll_rows > 0 THEN
				//Get the key value to update the row in the database.
				ll_Attachment_Key = lds_attachment_list.Object.attachment_key[ ll_Rows ]
		
				//Store the autocommit value as needs to be true for
				//  updating the image.
				l_bAutoCommit = SQLCA.AutoCommit
				SQLCA.AutoCommit = TRUE
				
				UPDATEBLOB cusfocus.case_attachments
				SET attachment_image = :lblb_Fax
				WHERE attachment_key = :ll_Attachment_Key
				USING SQLCA;
				
				IF SQLCA.SQLCode = -1 THEN
					SetPointer(Arrow!)
					MessageBox(gs_AppName, "Error saving image to database.~r~nError returned: "+SQLCA.SQLErrText, Exclamation!)
					//Set the autocommit value back.
					SQLCA.AutoCommit = l_bAutoCommit
					RETURN -1
				END IF
				
				//Set the autocommit value back.
				SQLCA.AutoCommit = l_bAutoCommit
		
				// Refresh the attachments tab
				w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_attachments.dw_attachment_list.Retrieve( ls_CaseNumber, ll_null )
				SetPointer(Arrow!)
				MessageBox(gs_AppName, "The attachment was successful.")
			END IF
		END IF

		DESTROY lds_attachment_list
		DESTROY n_blob_manipulator
	END IF
ELSEIF as_action = 'transfer' THEN
	li_CaseConfidLevel = uo_search_workqueues.dw_report.GetItemNumber(al_selectedrow, "confidentiality_level")
	ls_CaseNumber = uo_search_workqueues.dw_report.Object.case_number[ al_selectedrow ]
	ls_Case_type = uo_search_workqueues.dw_report.Object.case_log_case_type[ al_selectedrow ]
	ls_owner = uo_search_workqueues.dw_report.Object.case_log_case_rep[ al_selectedrow ]
	
	PCCA.Parm[1] = ls_CaseNumber
	PCCA.Parm[2] = ls_Case_Type
	PCCA.Parm[3] = STRING (li_CaseConfidLevel)
	PCCA.Parm[4] = ls_owner
	PCCA.Parm[5] = STRING (li_CaseConfidLevel)

	FWCA.MGR.fu_OpenWindow (w_transfer_case, 0)

	ls_return = PCCA.Parm[1]

	IF Upper( Trim( ls_return ) ) = "SUCCESS" THEN
		//Set to refresh the workdesk if open
		IF IsValid( w_reminders ) THEN
			w_reminders.fw_SetOkRefresh( )
		END IF
		// Refresh the datawindows
		ddlb_queues.EVENT ue_retrieve()
	ELSE
		RETURN -1
	END IF
ELSE // Take ownership
	li_CaseConfidLevel = uo_search_workqueues.dw_report.GetItemNumber(al_selectedrow, "confidentiality_level")

	IF i_wParentWindow.i_nRepConfidLevel < li_CaseConfidLevel THEN
		MessageBox(gs_AppName, "You do not have the proper security level to take ownership of this case.", Exclamation!)
		RETURN -1
	END IF

	//Get the current user and timestamp
	ls_Current_User = OBJCA.WIN.fu_GetLogin( SQLCA )
	ldt_timestamp = fu_GetTimeStamp( )
	ls_CaseNumber = uo_search_workqueues.dw_report.Object.case_number[ al_selectedrow ]
	ls_owner = uo_search_workqueues.dw_report.Object.case_log_case_rep[ al_selectedrow ]
	ls_keyval = fu_GetKeyValue("case_transfer")

	//Delete all of the prior owner rows for this case if a new one is defined.  This
	//  ensures that if there are multiple owner rows, they will all be deleted before
	//  the new one is inserted.
	DELETE cusfocus.case_transfer
	WHERE cusfocus.case_transfer.case_number = :ls_CaseNumber AND
			cusfocus.case_transfer.case_transfer_type = 'O'
	USING SQLCA;
	
	ls_error = SQLCA.sqlerrtext
	IF SQLCA.SQLCode <> 0 THEN
		ROLLBACK USING SQLCA;
		MessageBox( gs_AppName, 'Transfer unsuccessful for Case # '+ls_CaseNumber+'. '+ls_error , StopSign!, OK! )
		RETURN -1
	END IF		
	
	//Get to and from departments
	SELECT user_dept_id
	INTO :ls_from_dept
	FROM cusfocus.cusfocus_user
	WHERE user_id = :ls_owner
	USING SQLCA;
	
	SELECT user_dept_id
	INTO :ls_to_dept
	FROM cusfocus.cusfocus_user
	WHERE user_id = :ls_Current_User
	USING SQLCA;
	
	//Insert row for case_transfer
	INSERT INTO cusfocus.case_transfer
           (case_transfer_id,
           case_number,
           case_transfer_to,
           case_transfer_from,
           case_transfer_date,
           case_transfer_type,
           transfer_to_dept,
           transfer_from_dept)
     VALUES
        (
		  :ls_keyval,
		  :ls_casenumber,
		  :ls_Current_User,
		  :ls_owner,
		  :ldt_timestamp,
		  'O',
		  :ls_to_dept,
		  :ls_from_dept
		)	
	USING SQLCA;
	
	ls_error = SQLCA.sqlerrtext
	IF SQLCA.SQLCode <> 0 THEN
		ROLLBACK USING SQLCA;
		MessageBox( gs_AppName, 'Transfer unsuccessful for Case # '+ls_CaseNumber+'. '+ls_error, StopSign!, OK! )
		RETURN -1
	END IF		
	
	//Update the case log case rep to the new owner
	UPDATE cusfocus.case_log
	SET case_log_case_rep = :ls_Current_User,
		 updated_by = :ls_Current_User,
		 updated_timestamp = :ldt_timestamp
	WHERE case_number = :ls_CaseNumber
	USING SQLCA;
	
	ls_error = SQLCA.sqlerrtext
	IF SQLCA.SQLCode <> 0 THEN
		ROLLBACK USING SQLCA;
		MessageBox( gs_AppName, 'Transfer unsuccessful for Case # '+ls_CaseNumber+'. '+ls_error , StopSign!, OK! )
		RETURN -1
	ELSE
		COMMIT USING SQLCA;
		MessageBox (gs_AppName, 'Transfer successful for Case # '+ls_CaseNumber+'.')
	END IF
	
	//Set to refresh the workdesk if open
	IF IsValid( w_reminders ) THEN
		w_reminders.fw_SetOkRefresh( )
	END IF
	// Refresh the datawindows
	ddlb_queues.EVENT ue_retrieve()
END IF

RETURN 0




end function

public function string of_write_file (string as_file_name, long al_blob_id);/*****************************************************************************************
   Event:      of_write_file
   Purpose:    This function will take a filename and a blob id as input.
	            It will write the blob out to the file and return the
					full path of the file.

   Revisions:
   Date       Developer    Description
   ========   ============ =================================================================
	12/18/2006 R. Post      Created
*****************************************************************************************/
Long l_nFileNum, l_nAttachmentKey, l_nAttachFileNum, ll_blob_id
Integer l_nIndex, l_nLoop, l_nWriteRV, l_nRV
Blob l_blFile, l_blFilePart
Double l_dblFileSize
ContextKeyword l_ckTemp
String l_cTemp[ ], l_cFileName, l_cWriteFileName, l_cAttachFileLog
n_cst_kernel32 l_uoKernelFuncs
n_blob_manipulator ln_blob_manipulator

ln_blob_manipulator = CREATE n_blob_manipulator

//Get the file name
l_cFileName = as_file_name
ll_blob_id = al_blob_id
l_blFile = ln_blob_manipulator.of_retrieve_blob(ll_blob_id)

IF Trim( l_cFileName ) <> "" THEN
	//Prepare to open the document.
	// Get the Temp Path from Environment Variables to write the file
	// out before attempt to open.
	#IF defined PBDOTNET THEN
		l_cTemp[1] = System.IO.Path.GetTempPath()
	#ELSE
		l_ckTemp = CREATE ContextKeyword
		l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 
		
		//Have the needed info.  Destroy the object.
		DESTROY l_ckTemp
	#END IF
	
	//If temp Path is not available, use Root drive.
	IF NOT l_uoKernelFuncs.of_DirectoryExists( l_cTemp[ 1 ] ) THEN 
		l_cTemp[ 1 ] = 'C:\'
	END IF
	
	//Get rid of any potential white space.
	l_cTemp[ 1 ] = Trim( l_cTemp[ 1 ] )
	
	//Add the directory to the file name.
	IF Mid( l_cTemp[ 1 ], Len( l_cTemp[ 1 ] ), 1 ) = "\" THEN
		l_cWriteFileName = ( l_cTemp[ 1 ]+l_cFileName )
	ELSE
		l_cWriteFileName = ( l_cTemp[ 1 ]+"\"+l_cFileName )
	END IF
	
	//Write the file out.
	l_nFileNum = FileOpen( l_cWriteFileName, StreamMode!, Write!, LockReadWrite!, Replace! )
		
	IF l_nFileNum > 0 THEN
		//Find out how many reads to make on the image
		l_dblFileSize = Len( l_blFile )
		
		IF l_dblFileSize <= 32765 THEN
			l_nLoop = 1
		ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
			l_nLoop = ( l_dblFileSize / 32765 )
		ELSE
			l_nLoop = Ceiling( l_dblFileSize / 32765 )
		END IF
		
		//Write the file.
		IF l_nLoop = 1 THEN
			l_nWriteRV = FileWrite( l_nFileNum, l_blFile )
		ELSE
			l_blFilePart = BlobMid( l_blFile, 1, 32765 )
			FOR l_nIndex = 1 TO l_nLoop				
				l_nWriteRV = FileWrite( l_nFileNum, l_blFilePart )
				
				IF l_nWriteRV = -1 THEN					
					EXIT
				ELSE
					l_blFilePart = BlobMid( l_blFile, ( ( 32765 * l_nIndex ) + 1 ), 32765 )
				END IF							
			NEXT
		END IF
		
		IF l_nWriteRV = -1 THEN
			FileClose( l_nFileNum )
			FileDelete( l_cFileName )
						
			MessageBox( gs_AppName, "Unable to write to file "+l_cWriteFileName+".", &
							StopSign!, OK! )									
			RETURN ''
		ELSE
			FileClose( l_nFileNum )
			
		END IF
	ELSE
		MessageBox( gs_AppName, "Could not open the file for write", StopSign!, OK! )
	END IF						
ELSE
	MessageBox( gs_AppName, "File name not populated.  Could not open file", StopSign!, OK! )
END IF

Destroy ln_blob_manipulator
//SetPointer( Arrow! )

RETURN l_cWriteFileName
end function

public function long of_combine_tiffs ();/*****************************************************************************************
   Event:      of_combine_tiffs
   Purpose:    This function will loop through the datawindow looking for
	            the selected rows. It will combine them all into a single
					multi-page tiff file, load that into blobobject, and return
					the blob ID.

               This uses a TIFF API from http://www.remotesensing.org/libtiff/
					Instructions for the API call I am using is located at:
					http://remotesensing.org/libtiff/man/tiffcp.1.html
					
   Revisions:
   Date       Developer    Description
   ========   ============ =================================================================
	12/18/2006 R. Post      Created
*****************************************************************************************/
Integer l_nRV, l_nRow, l_nLoop, l_nIndex, l_nConfidLevel, l_nSelectedRow[ ]
String l_cInfo, l_cFileName, l_cFileNamePath, l_cDesc, l_cMessage, l_cConfidLevel, l_cCurrPath
String l_cCurrCaseNum, l_cCurrCaseMasterNum, ls_temp
Long l_nAttachmentKey, l_nFileNum, ll_blobID
Double l_dblFileSize
Blob l_blFilePart, l_blFile
n_cst_kernel32 l_uoKernelFuncs
Date l_dDate
Time l_tTime
DateTime l_dtCreationDate, l_dtLastWriteDate
n_blob_manipulator ln_blob_manipulator
STRING ls_api_call, ls_written_file_name, ls_directory, ls_file_combined, ls_null
STRING ls_file_names[]
LONG ll_row, ll_rows, ll_file_count, ll_return, ll_pos

ln_blob_manipulator = Create n_blob_manipulator
SetNull(ls_null)

// loop through datawindow and get the blob IDs for the selected rows
ll_rows = uo_search_workqueues.dw_report.RowCount()
ll_row = uo_search_workqueues.dw_report.find("selectedrow = 'y'",1, ll_rows)
DO WHILE ll_row > 0 
	ll_blobID = uo_search_workqueues.dw_report.object.blbobjctid[ll_row]
	ls_written_file_name = of_write_file(String(ll_blobID) + ".tiff", ll_blobID)
	ll_file_count++
	ls_file_names[ll_file_count] = ls_written_file_name
	ls_api_call += '"' + ls_written_file_name + '" '
	IF ll_file_count = 1 THEN
		ll_pos = POS(ls_written_file_name, String(ll_blobID))
		ls_directory = MID(ls_written_file_name, 1, ll_pos - 1)
	END IF
	ll_row++
	IF ll_row > ll_rows THEN EXIT
	ll_row = uo_search_workqueues.dw_report.find("selectedrow = 'y'",ll_row, ll_rows)
LOOP

// once they are all written, call api to combine them
ls_file_combined = ls_directory + OBJCA.WIN.fu_GetLogin( SQLCA ) + ".tiff"
FileDelete(ls_file_combined)
ls_api_call += '"' + ls_file_combined + '" '
ll_file_count++
ls_file_names[ll_file_count] = ls_file_combined
ll_return = ShellExecuteA( 0, ls_null, 'tiffcp', ' -c lzw ' + ls_api_call, ls_null, 0 )
Sleep(2) // Give the file system time to adjust to the API call

//	Read in combined tiff file
l_dblFileSize = l_uoKernelFuncs.of_GetFileSize( ls_file_combined )
		
l_nFileNum = FileOpen( ls_file_combined, StreamMode!, Read!, LockReadWrite! )
	
IF l_nFileNum > 0 THEN				
	IF l_dblFileSize <= 32765 THEN
		l_nLoop = 1
	ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
		l_nLoop = ( l_dblFileSize / 32765 )
	ELSE
		l_nLoop = Ceiling( l_dblFileSize / 32765 )
	END IF
	
	FOR l_nIndex = 1 TO l_nLoop
		l_nRV = FileRead( l_nFileNum, l_blFilePart )
		
		IF l_nRV = -1 THEN
			l_cMessage = "Error while reading file"
			EXIT
		ELSE
			l_blFile = ( l_blFile+l_blFilePart )
		END IF							
	NEXT

	FileClose( l_nFileNum )

	// store blob into the database
	ll_blobID = ln_blob_manipulator.of_insert_blob(l_blFile, ls_file_combined)
END IF
// delete all of the work files
ll_rows = Upperbound(ls_file_names)
FOR ll_row = 1 to ll_rows
	FileDelete(ls_file_names[ll_row])
NEXT

Destroy	ln_blob_manipulator

// return the blob id of the combined fax
RETURN ll_blobID

end function

on uo_tabpg_workqueues.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_add=create cb_add
this.cb_attach=create cb_attach
this.st_select_queue=create st_select_queue
this.ddlb_queues=create ddlb_queues
this.gb_1=create gb_1
this.gb_2=create gb_2
this.uo_search_workqueues=create uo_search_workqueues
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_add
this.Control[iCurrent+3]=this.cb_attach
this.Control[iCurrent+4]=this.st_select_queue
this.Control[iCurrent+5]=this.ddlb_queues
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.uo_search_workqueues
end on

on uo_tabpg_workqueues.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_add)
destroy(this.cb_attach)
destroy(this.st_select_queue)
destroy(this.ddlb_queues)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.uo_search_workqueues)
end on

event constructor;call super::constructor;//***********************************************************************************************
//
//  Event:   Constructor
//  Purpose: please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/24/2000 K. Claver   Added code to activate the resize service and register the objects
//  10/26/2000 M. Caruso   Added code to set the parent window reference
//***********************************************************************************************
String ls_user_id

THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( gb_1, THIS.inv_resize.SCALERIGHTBOTTOM )
//	THIS.inv_resize.of_Register( dw_opencases, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( gb_2, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )

	THIS.inv_resize.of_Register( cb_attach, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( uo_search_workqueues, THIS.inv_resize.SCALERIGHTBOTTOM )
//	THIS.inv_resize.of_Register( dw_preview, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
////	THIS.inv_resize.of_Register( st_notes, THIS.inv_resize.FIXEDBOTTOM )
END IF

ls_User_ID = OBJCA.WIN.fu_GetLogin(SQLCA)

ids_work_queue_list = CREATE DataStore
ids_work_queue_list.DataObject = 'd_work_queue_list'
ids_work_queue_list.SetTransObject(SQLCA)
ids_work_queue_list.Retrieve(ls_user_id)

i_wParentWindow = W_REMINDERS

THIS.EVENT POST ue_post_constructor()
end event

event destructor;call super::destructor;DESTROY ids_work_queue_list
end event

type cb_1 from commandbutton within uo_tabpg_workqueues
boolean visible = false
integer x = 2226
integer y = 20
integer width = 512
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Load Rick~'s Test Data"
end type

event clicked;Integer l_nRV, l_nRow, l_nLoop, l_nIndex, l_nConfidLevel, l_nSelectedRow[ ]
String l_cInfo, l_cFileName, l_cFileNamePath, l_cDesc, l_cMessage, l_cConfidLevel, l_cCurrPath
String l_cCurrCaseNum, l_cCurrCaseMasterNum, ls_temp
Long l_nAttachmentKey, l_nFileNum, ll_blobID
Double l_dblFileSize
Blob l_blFilePart, l_blFile
Boolean l_bAutoCommit, l_bAccessDenied = FALSE
n_cst_kernel32 l_uoKernelFuncs
Date l_dDate
Time l_tTime
DateTime l_dtCreationDate, l_dtLastWriteDate
n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator
STRING ls_file1, ls_file2, ls_file3, ls_file4, ls_null

SetNull(ls_null)
//Get the current directory so can change back after attach a file
//  from another directory.
l_cCurrPath = l_uoKernelFuncs.of_GetCurrentDirectory( )

//Open the window
FWCA.MGR.fu_OpenWindow( w_case_attachment )

//Get the return values
l_cInfo = Trim( Message.StringParm )
IF l_cInfo <> "CNCL" AND l_cInfo <> "" THEN
	//Get the file name and path
	l_cFileName = Mid( l_cInfo, 1, ( Pos( l_cInfo, "||" ) - 1 ) )
	l_cInfo = Mid( l_cInfo, ( Pos( l_cInfo, "||" ) + 2 ) )
	l_cFileNamePath = Mid( l_cInfo, 1, ( Pos( l_cInfo, "||" ) - 1 ) )
	l_cInfo = Mid( l_cInfo, ( Pos( l_cInfo, "||" ) + 2 ) )
	l_cDesc = Mid( l_cInfo, 1, ( Pos( l_cInfo, "||" ) - 1 ) )
	//Get the security level
	l_cConfidLevel = Mid( l_cInfo, ( Pos( l_cInfo, "||" ) + 2 ) )
	
	IF l_cDesc = "NULL" THEN
		SetNull( l_cDesc )
	END IF
	
	IF l_cConfidLevel = "NULL" THEN
		SetNull( l_nConfidLevel )
	ELSE
		l_nConfidLevel = Long( l_cConfidLevel )
	END IF
	
	ls_file1 = l_cFilenamePath
	l_nRV = LEN(l_cFileNamePath)
	ls_file2 = MID(l_cFileNamePath, 1, l_nRV - 5) + '2.tif'
	ls_file3 = MID(l_cFileNamePath, 1, l_nRV - 5) + '3.tif'
	ls_file4 = MID(l_cFileNamePath, 1, l_nRV - 7) + '123.tif'
	l_cFileName = Mid( l_cFileName, 1, LEN(l_cFileName) - 7) + '123.tif'

//	// Create output file
//	l_nRV = FileOpen(ls_file4, LineMode!, Write!)
//	FileClose( l_nRV )
	FileDelete(ls_file4)
	
	l_nRV = ShellExecuteA( 0, ls_null, 'tiffcp', ' -c lzw "' + ls_file1 + &
		'" "' + ls_file2 + '" "' + ls_file3 + '" "' + ls_file4 + '"', ls_null, 1 )
	l_cFileNamePath = ls_file4
	
	//Get file datetime and size info
	l_dblFileSize = l_uoKernelFuncs.of_GetFileSize( l_cFileNamePath )
	l_uoKernelFuncs.of_GetCreationDateTime( l_cFileNamePath, l_dDate, l_tTime )
	l_dtCreationDate = DateTime( l_dDate, l_tTime )
	l_uoKernelFuncs.of_GetLastWriteDateTime( l_cFileNamePath, l_dDate, l_tTime )
	l_dtLastWriteDate = DateTime( l_dDate, l_tTime )
		
			
	//Open the file for Read
	l_nFileNum = FileOpen( l_cFileNamePath, StreamMode!, Read!, LockReadWrite! )
	
	IF l_nFileNum > 0 THEN				
		IF l_dblFileSize <= 32765 THEN
			l_nLoop = 1
		ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
			l_nLoop = ( l_dblFileSize / 32765 )
		ELSE
			l_nLoop = Ceiling( l_dblFileSize / 32765 )
		END IF
		
		FOR l_nIndex = 1 TO l_nLoop
			l_nRV = FileRead( l_nFileNum, l_blFilePart )
			
			IF l_nRV = -1 THEN
				l_cMessage = "Error while reading file"
				EXIT
			ELSE
				l_blFile = ( l_blFile+l_blFilePart )
			END IF							
		NEXT

		FileClose( l_nFileNum )

		ll_blobID = ln_blob_manipulator.of_insert_blob(l_blFile, l_cFileName)
		
		IF ll_blobID > 0 THEN
			INSERT INTO cusfocus.faxheader (
				blbobjctid,
				fax_owner,
				fax_source_number,
				faxdidnum,
				fax_created_datetime)
			VALUES (
				:ll_blobID,
				'cfadmin',
				:l_cDesc,
				:l_cFileName,
				:l_dtCreationDate)
			USING SQLCA;
		END IF

	ELSE
		l_cMessage = "Unable to open the file to attach to the case"				
	END IF						
END IF


//Change back to the app directory.  Need to do this so can find the help file and other
//  files without coded paths.
l_uoKernelFuncs.of_ChangeDirectory( l_cCurrPath )
	
Destroy	ln_blob_manipulator

end event

type cb_add from commandbutton within uo_tabpg_workqueues
boolean visible = false
integer x = 1655
integer y = 24
integer width = 448
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Load Test Data"
end type

event clicked;Integer l_nRV, l_nRow, l_nLoop, l_nIndex, l_nConfidLevel, l_nSelectedRow[ ]
String l_cInfo, l_cFileName, l_cFileNamePath, l_cDesc, l_cMessage, l_cConfidLevel, l_cCurrPath
String l_cCurrCaseNum, l_cCurrCaseMasterNum
Long l_nAttachmentKey, l_nFileNum, ll_blobID
Double l_dblFileSize
Blob l_blFilePart, l_blFile
Boolean l_bAutoCommit, l_bAccessDenied = FALSE
n_cst_kernel32 l_uoKernelFuncs
Date l_dDate
Time l_tTime
DateTime l_dtCreationDate, l_dtLastWriteDate
n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//Get the current directory so can change back after attach a file
//  from another directory.
l_cCurrPath = l_uoKernelFuncs.of_GetCurrentDirectory( )

//Open the window
FWCA.MGR.fu_OpenWindow( w_case_attachment )

//Get the return values
l_cInfo = Trim( Message.StringParm )
IF l_cInfo <> "CNCL" AND l_cInfo <> "" THEN
	//Get the file name and path
	l_cFileName = Mid( l_cInfo, 1, ( Pos( l_cInfo, "||" ) - 1 ) )
	l_cInfo = Mid( l_cInfo, ( Pos( l_cInfo, "||" ) + 2 ) )
	l_cFileNamePath = Mid( l_cInfo, 1, ( Pos( l_cInfo, "||" ) - 1 ) )
	l_cInfo = Mid( l_cInfo, ( Pos( l_cInfo, "||" ) + 2 ) )
	l_cDesc = Mid( l_cInfo, 1, ( Pos( l_cInfo, "||" ) - 1 ) )
	//Get the security level
	l_cConfidLevel = Mid( l_cInfo, ( Pos( l_cInfo, "||" ) + 2 ) )
	
	IF l_cDesc = "NULL" THEN
		SetNull( l_cDesc )
	END IF
	
	IF l_cConfidLevel = "NULL" THEN
		SetNull( l_nConfidLevel )
	ELSE
		l_nConfidLevel = Long( l_cConfidLevel )
	END IF
	
	
	//Get file datetime and size info
	l_dblFileSize = l_uoKernelFuncs.of_GetFileSize( l_cFileNamePath )
	l_uoKernelFuncs.of_GetCreationDateTime( l_cFileNamePath, l_dDate, l_tTime )
	l_dtCreationDate = DateTime( l_dDate, l_tTime )
	l_uoKernelFuncs.of_GetLastWriteDateTime( l_cFileNamePath, l_dDate, l_tTime )
	l_dtLastWriteDate = DateTime( l_dDate, l_tTime )
		
			
	//Open the file for Read
	l_nFileNum = FileOpen( l_cFileNamePath, StreamMode!, Read!, LockReadWrite! )
	
	IF l_nFileNum > 0 THEN				
		IF l_dblFileSize <= 32765 THEN
			l_nLoop = 1
		ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
			l_nLoop = ( l_dblFileSize / 32765 )
		ELSE
			l_nLoop = Ceiling( l_dblFileSize / 32765 )
		END IF
		
		FOR l_nIndex = 1 TO l_nLoop
			l_nRV = FileRead( l_nFileNum, l_blFilePart )
			
			IF l_nRV = -1 THEN
				l_cMessage = "Error while reading file"
				EXIT
			ELSE
				l_blFile = ( l_blFile+l_blFilePart )
			END IF							
		NEXT
		
		FileClose( l_nFileNum )
				
		ll_blobID = ln_blob_manipulator.of_insert_blob(l_blFile, l_cFileName)
		
		IF ll_blobID > 0 THEN
			INSERT INTO cusfocus.fax_queue_detail (
				fax_queue_header_id,
				blbobjctid,
				fax_owner,
				fax_description,
				faxnum,
				fax_created_datetime)
			VALUES (
				1,
				:ll_blobID,
				'cfadmin',
				:l_cDesc,
				:l_cFileName,
				:l_dtCreationDate)
			USING SQLCA;
		END IF

	ELSE
		l_cMessage = "Unable to open the file to attach to the case"				
	END IF						
END IF


//Change back to the app directory.  Need to do this so can find the help file and other
//  files without coded paths.
l_uoKernelFuncs.of_ChangeDirectory( l_cCurrPath )
	
Destroy	ln_blob_manipulator

end event

type cb_attach from commandbutton within uo_tabpg_workqueues
boolean visible = false
integer x = 2848
integer y = 20
integer width = 402
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Attach"
end type

event clicked;//LONG ll_selectedrow
//
//ll_selectedrow = uo_search_workqueues.dw_report_detail.GetRow()
//
//IF ll_selectedrow < 1 THEN
//	MessageBox(gs_AppName, "Please select a row to " + THIS.Text + ".", Exclamation!)
//	RETURN
//END IF
//
//PARENT.of_attach(ll_selectedrow)
end event

type st_select_queue from statictext within uo_tabpg_workqueues
integer x = 110
integer y = 28
integer width = 384
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Queue:"
boolean focusrectangle = false
end type

type ddlb_queues from dropdownlistbox within uo_tabpg_workqueues
event ue_retrieve ( )
integer x = 503
integer y = 16
integer width = 1120
integer height = 400
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_retrieve();LONG ll_header_id, ll_row, ll_rows, ll_fax_queue_detail_id, ll_rowcount, ll_currentrow
STRING ls_work_queue_type, ls_work_queue_description, ls_test, ls_case_number

ll_rows = ids_work_queue_list.RowCount()
ls_work_queue_description = THIS.text
ll_row = ids_work_queue_list.Find("description = '" + ls_work_queue_description + "'",1, ll_rows)
IF ll_row > 0 THEN
	// Clear current filter
	uo_search_workqueues.of_clear_filter()
	
	ll_header_id = ids_work_queue_list.object.header_id[ll_row]
	ls_work_queue_type = ids_work_queue_list.object.type[ll_row]

	IF ls_work_queue_type = 'FAX' THEN // Fax / Document queue
		// Get the current row so that if can be reselected after refresh
		ll_fax_queue_detail_id = 0
		IF uo_search_workqueues.dw_report.dataobject = 'd_faxlist_detail' THEN
			IF uo_search_workqueues.dw_report.Rowcount() > 0 THEN
				ll_currentrow = uo_search_workqueues.dw_report.GetRow()
				IF ll_currentrow > 0 THEN
					ll_fax_queue_detail_id = uo_search_workqueues.dw_report.object.fax_queue_detail_id[ll_currentrow]
				END IF
			END IF
		END IF
		uo_search_workqueues.EVENT ue_save_syntax()
		uo_search_workqueues.dw_report.dataobject = 'd_faxlist_detail'
		uo_search_workqueues.EVENT ue_get_saved_syntax()
		uo_search_workqueues.dw_report.SetTransObject(SQLCA)
		uo_search_workqueues.dw_report.EVENT ue_refresh_services()
		uo_search_workqueues.tab_case_preview.visible = false
		uo_search_workqueues.ole_image.visible = true
		ll_rowcount = uo_search_workqueues.dw_report.Retrieve(ll_header_id)
	//	iuo_parent_tabpg.cb_attach.text = "Attach"
		uo_search_workqueues.uo_titlebar.of_hide_button('Transfer Case', True)
		uo_search_workqueues.uo_titlebar.of_hide_button('Take Ownership', True)
		uo_search_workqueues.uo_titlebar.of_hide_button('Attach Image', False )
		m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
		IF ll_fax_queue_detail_id <> 0 AND ll_rowcount > 1 THEN
			ll_currentrow = uo_search_workqueues.dw_report.find("fax_queue_detail_id = " + String(ll_fax_queue_detail_id), 1, ll_rowcount)
			IF ll_currentrow > 0 THEN
				uo_search_workqueues.dw_report.ScrolltoRow(ll_currentrow)
				uo_search_workqueues.dw_report.Setrow(ll_currentrow)
			END IF
		END IF
	ELSE // General work queue
		// Get the current row so that if can be reselected after refresh
		ls_case_number = ''
		IF uo_search_workqueues.dw_report.dataobject = 'd_work_queue_detail' THEN
			IF uo_search_workqueues.dw_report.Rowcount() > 0 THEN
				ll_currentrow = uo_search_workqueues.dw_report.GetRow()
				IF ll_currentrow > 0 THEN
					ls_case_number = uo_search_workqueues.dw_report.object.case_number[ll_currentrow]
				END IF
			END IF
		END IF
		uo_search_workqueues.EVENT ue_save_syntax()
		uo_search_workqueues.dw_report.dataobject = 'd_work_queue_detail'
		uo_search_workqueues.EVENT ue_get_saved_syntax()
		uo_search_workqueues.dw_report.SetTransObject(SQLCA)
		uo_search_workqueues.dw_report.EVENT ue_refresh_services()
		uo_search_workqueues.tab_case_preview.visible = true
		uo_search_workqueues.ole_image.visible = false
		ll_rowcount = uo_search_workqueues.dw_report.Retrieve(ll_header_id)
	//	iuo_parent_tabpg.cb_attach.text = "Transfer"
		uo_search_workqueues.uo_titlebar.of_hide_button('Transfer Case', False)
		uo_search_workqueues.uo_titlebar.of_hide_button('Take Ownership', False)
		uo_search_workqueues.uo_titlebar.of_hide_button('Attach Image', True )
		m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
		IF ls_case_number <> '' AND ll_rowcount > 1 THEN
			ll_currentrow = uo_search_workqueues.dw_report.find("case_number = '" + ls_case_number + "'", 1, ll_rowcount)
			IF ll_currentrow > 0 THEN
				uo_search_workqueues.dw_report.ScrolltoRow(ll_currentrow)
				uo_search_workqueues.dw_report.Setrow(ll_currentrow)
			END IF
		END IF
	END IF
END IF

// Force a refresh of the filter bar
uo_search_workqueues.of_init_filter()


end event

event selectionchanged;THIS.EVENT ue_retrieve()
end event

type gb_1 from groupbox within uo_tabpg_workqueues
boolean visible = false
integer x = 14
integer y = 4
integer width = 3557
integer height = 1032
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Open Cases"
end type

type gb_2 from groupbox within uo_tabpg_workqueues
boolean visible = false
integer x = 14
integer y = 1036
integer width = 3557
integer height = 556
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Preview"
end type

type uo_search_workqueues from u_search_workqueues within uo_tabpg_workqueues
integer x = 18
integer y = 124
integer height = 1436
integer taborder = 30
boolean bringtotop = true
end type

on uo_search_workqueues.destroy
call u_search_workqueues::destroy
end on

event constructor;call super::constructor;THIS.iuo_parent_tabpg = PARENT
end event

