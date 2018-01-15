$PBExportHeader$u_search_workqueues.sru
forward
global type u_search_workqueues from u_search
end type
type st_slider from u_slider_control_horizontal within u_search_workqueues
end type
type ole_image from olecustomcontrol within u_search_workqueues
end type
type tab_case_preview from uo_tab_case_preview within u_search_workqueues
end type
type tab_case_preview from uo_tab_case_preview within u_search_workqueues
end type
end forward

global type u_search_workqueues from u_search
integer width = 3589
integer height = 1432
event ue_post_constructor ( )
event type string ue_template_restore ( )
event ue_template_save ( )
event ue_get_saved_syntax ( )
event ue_save_syntax ( )
st_slider st_slider
ole_image ole_image
tab_case_preview tab_case_preview
end type
global u_search_workqueues u_search_workqueues

type variables
n_column_sizing_service in_columnsizingservice_detail

long il_conf_level
long	il_work_reportconfigid
long	il_fax_reportconfigid

datastore	ids_savedreport

blob	iblob_syntax
string	is_syntax 
string is_original_fax_syntax
string is_original_work_syntax
boolean ib_enter_key = FALSE
uo_tabpg_workqueues iuo_parent_tabpg

end variables

forward prototypes
public subroutine of_set_conf_level (long al_conf_level)
public subroutine of_display_image ()
public function string of_getopenerrortext (integer a_nrv)
public subroutine of_init_filter ()
public subroutine of_clear_filter ()
public function boolean of_check_locked (string a_ccasenumber)
end prototypes

event ue_post_constructor();uo_titlebar.of_delete_button('Customize...')
uo_titlebar.of_add_button('Restore Original View', 'restore' )

long l_sliderpos
st_slider.of_add_upper_object(dw_report)
st_slider.of_add_lower_object(tab_case_preview)
st_slider.backcolor = gn_globals.in_theme.of_get_barcolor()


n_registry ln_registry
l_sliderpos  			= 						long(	ln_registry.of_get_registry_key('users\' +  gn_globals.is_username + '\' + This.ClassName() + '\slidery'))

If l_sliderpos > 0 And Not IsNull(l_sliderpos) Then
	//st_slider.y = Min(Max(l_sliderpos, st_separator.Y + st_separator.Height + 100), Height - 100)
End If

// 11/27/06 RAP - With proper security, users can save report templates
IF gn_globals.il_view_confidentiality_level > 2 THEN
	uo_titlebar.of_add_button('Save View As Template', 'save template' )
	uo_titlebar.of_add_button('Restore Template View', 'restore template' )
END IF


uo_titlebar.of_add_button('Transfer Case', 'transfer case' )
uo_titlebar.of_add_button('Take Ownership', 'take ownership' )
uo_titlebar.of_add_button('Attach Image', 'attach image' )

//??? RAP for some reason web forms are blowing up on this, not an instance. 
//??? This could be because ActiveX/OCX aren't supported in web forms, duh!
#IF NOT defined PBWEBFORM THEN
// Set license key for OCX
	#IF defined PBDOTNET THEN
//		ole_image.SetLicenceNumber('4690229585779658065352356')
	#ELSE
		ole_image.object.SetLicenceNumber('4690229585779658065352356')
	#END IF
#END IF


end event

event type string ue_template_restore();//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null, ll_reportconfigid, ll_pos
string	ls_null, ls_syntax, ls_parm
blob		lb_syntax

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

// Different reportconfig IDs for FAX and Work queues
IF dw_report.DataObject = 'd_faxlist_detail' THEN
	ll_reportconfigid = il_fax_reportconfigid
ELSE
	ll_reportconfigid = il_work_reportconfigid
END IF

OpenWithParm(w_template_restore, ll_reportconfigid)
ll_blobID = Message.DoubleParm

If Not IsNull(ll_blobid) and ll_blobid > 0 Then
	ln_blob_manipulator = Create n_blob_manipulator
	
	iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobid)
	
	ls_syntax = String(iblob_currentstate)
	
	// Make sure we converted it correctly - RAP 11/4/08
	ll_pos = Pos( ls_syntax, "release" )
	IF ll_pos = 0 THEN
		ls_syntax = string(iblob_currentstate, EncodingANSI!)
	END IF
	
	Destroy ln_blob_manipulator
End If

RETURN ls_syntax

end event

event ue_template_save();//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null, ll_reportconfigid
string	ls_null, ls_syntax
blob		lb_syntax

//----------------------------------------------------------------------------------------------------------------------------------
// 11/27/06 RAP - Do not save the filter with the datawindow syntax
//-----------------------------------------------------------------------------------------------------------------------------------
// Different reportconfig IDs for FAX and Work queues
IF dw_report.DataObject = 'd_faxlist_detail' THEN
	ll_reportconfigid = il_fax_reportconfigid
ELSE
	ll_reportconfigid = il_work_reportconfigid
END IF
dw_report.SetFilter("")
dw_report.Filter()
ls_syntax = dw_report.Describe("DataWindow.Syntax")

ls_syntax = String(ll_reportconfigid) + "/" + ls_syntax
OpenWithParm(w_template_save, ls_syntax)


end event

event ue_get_saved_syntax();//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long	ll_rows, ll_pos
long	ll_blobobjectid
n_blob_manipulator ln_blob_manipulator
blob	lblob_datawindow_syntax
string	l_sMsg, ls_syntax, ls_search_type

ln_blob_manipulator = Create n_blob_manipulator
//----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore, set the dataobject and the transaction
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport = Create datastore
ids_savedreport.DataObject = 'd_data_savedreport_user_reportconfig'
ids_savedreport.SetTransObject(SQLCA)

//----------------------------------------------------------------------------------------------------------------------------------
// Get the rprtcnfgid so that we can look in SavedReport table to see if a previous saved syntax exists
//-----------------------------------------------------------------------------------------------------------------------------------
IF dw_report.DataObject = 'd_faxlist_detail' THEN
	ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, il_fax_reportconfigid)
ELSE
	ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, il_work_reportconfigid)
END IF

//----------------------------------------------------------------------------------------------------------------------------------
// Check to see if a row exists for 'D'efault syntax. If it does exist, get the blob ID and set the original syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.SetFilter("svdrprttpe = 'D'")
ll_rows = ids_savedreport.Filter()
ll_rows = ids_savedreport.RowCount()
IF ll_rows > 0 THEN
	ll_blobobjectid = ids_savedreport.GetItemNumber(1, 'svdrprtblbobjctid')
	
	If Not IsNull(ll_blobobjectid) and ll_blobobjectid > 0 Then
		iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobobjectid)
		ls_syntax = String(iblob_currentstate)
		// Make sure we converted it correctly - RAP 11/4/08
		ll_pos = Pos( ls_syntax, "release" )
		IF ll_pos = 0 THEN
			ls_syntax = string(iblob_currentstate, EncodingANSI!)
		END IF
		
		dw_report.Create(ls_syntax)
		dw_report.SetTransObject(SQLCA)
	END IF
END IF

//----------------------------------------------------------------------------------------------------------------------------------
// Filter for last 'S'aved syntax.
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.SetFilter("svdrprttpe = 'S'")
ll_rows = ids_savedreport.Filter()
ll_rows = ids_savedreport.RowCount()

//----------------------------------------------------------------------------------------------------------------------------------
// Check to see if a row exists. If it does exist, get the blob ID and recreate the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_rows > 0 Then
	ll_blobobjectid = ids_savedreport.GetItemNumber(1, 'svdrprtblbobjctid')
	
	If Not IsNull(ll_blobobjectid) and ll_blobobjectid > 0 Then
		
		iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobobjectid)
		
		ls_syntax = String(iblob_currentstate)
		
		// Make sure we converted it correctly - RAP 11/4/08
		ll_pos = Pos( ls_syntax, "release" )
		IF ll_pos = 0 THEN
			ls_syntax = string(iblob_currentstate, EncodingANSI!)
		END IF
		
		If dw_report.Create(ls_syntax, l_sMsg) <> 1 THEN
			IF dw_report.DataObject = 'd_faxlist_detail' THEN
				dw_report.Create(is_original_fax_syntax)
			ELSE
				dw_report.Create(is_original_work_syntax)
			END IF
		Else
			dw_report.SetTransObject(SQLCA)
		End If
		
	End If
End If

Destroy ln_blob_manipulator

end event

event ue_save_syntax();//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null, ll_reportconfigid
string	ls_null, ls_syntax
blob		lb_syntax

// If it is being called before everything is instantiated, exit
IF NOT IsValid(ids_savedreport) THEN RETURN

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Ensure these variables are null
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_null)
SetNull(ls_null)

//----------------------------------------------------------------------------------------------------------------------------------
// 11/27/06 RAP - Do not save the filter with the datawindow syntax
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report.SetFilter("")
dw_report.Filter()

//----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the datastore then get the syntax for the datawindow & convert it into a blob object
//-----------------------------------------------------------------------------------------------------------------------------------
// Different reportconfig IDs for FAX and Work queues
IF dw_report.DataObject = 'd_faxlist_detail' THEN
	ll_reportconfigid = il_fax_reportconfigid
ELSE
	ll_reportconfigid = il_work_reportconfigid
END IF

ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, ll_reportconfigid)
lb_syntax = blob(dw_report.Describe("DataWindow.Syntax"))
 
//----------------------------------------------------------------------------------------------------------------------------------
// If we dont' have a row, then insert a new row and set the values. Otherwise update the existing row and blob.
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_savedreport.RowCount() = 0 Then
	ll_new_row = ids_savedreport.InsertRow(0)
	
	ll_blobID = ln_blob_manipulator.of_insert_blob(lb_syntax, dw_report.dataobject)
	
	ids_savedreport.SetItem(ll_new_row, 'svdrprtfldrid', ls_null)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtblbobjctid', ll_blobID)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrprtcnfgid', ll_reportconfigid)
	ids_savedreport.SetItem(ll_new_row, 'svdrprttpe', 'S')
	ids_savedreport.SetItem(ll_new_row, 'svdrprtdstrbtnmthd', ls_null)	
	ids_savedreport.SetItem(ll_new_row, 'svdrprtuserid', gn_globals.il_userid)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnusrID', ll_null)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnlvl', 1)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
Else
	ll_blobID = ids_savedreport.getitemnumber(1, 'svdrprtblbobjctid')
	ln_blob_manipulator.of_update_blob(lb_syntax, ll_blobID, FALSE)
	
	ids_savedreport.SetItem(1, 'svdrprtblbobjctid', ll_blobID)
	ids_savedreport.SetItem(1, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
	ids_savedreport.SetItem(1, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
End If


//----------------------------------------------------------------------------------------------------------------------------------
// Save the changes to the database
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.Update()


//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy	ln_blob_manipulator

end event

public subroutine of_set_conf_level (long al_conf_level);il_conf_level = al_conf_level
end subroutine

public subroutine of_display_image ();/*****************************************************************************************
   Event:      ue_OpenAttachment
   Purpose:    To open a case attachment.
	
	Parameters: a_nRow - Integer - The row in the datawindow that was selected or
											 double-clicked.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Created
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

SetPointer( HourGlass! )

//Get the file name
l_cFileName = dw_report.object.faxnum[dw_report.GetRow()]
ll_blob_id = dw_report.object.blbobjctid[dw_report.GetRow()]
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
		ELSE
			FileClose( l_nFileNum )
			
			// API call script
			l_nRV = w_reminders.tab_workdesk.tabpage_workqueues.ShellExecuteA( 0, "open", l_cFileName, "" , l_cTemp[ 1 ], 1 )
			
			IF l_nRV = 31 THEN
				//No application associated with this file type.  Let the user pick one.
				l_nRV = w_reminders.tab_workdesk.tabpage_workqueues.ShellExecuteA( 0, "open", "rundll32.exe", ( "shell32.dll,OpenAs_RunDLL "+l_cFileName ), l_cTemp[ 1 ], 1 ) 
			END IF
			
			IF l_nRV >= 0 AND l_nRV <= 32 THEN
				MessageBox( gs_AppName, THIS.of_GetOpenErrorText( l_nRV ) )
			ELSE
				//Log the file being opened to the attachments log file.
				IF Mid( l_cTemp[ 1 ], Len( l_cTemp[ 1 ] ), 1 ) = "\" THEN
					l_cAttachFileLog = ( l_cTemp[ 1 ]+"cfattachfile.log" )
				ELSE
					l_cAttachFileLog = ( l_cTemp[ 1 ]+"\"+"cfattachfile.log" )
				END IF
				
				l_nAttachFileNum = FileOpen( l_cAttachFileLog, LineMode!, Write!, LockWrite!, Append! )
				
				IF l_nAttachFileNum > 0 THEN
					FileWrite( l_nAttachFileNum, l_cWriteFileName )
					
					FileClose( l_nAttachFileNum )
				END IF
			END IF
		END IF
	ELSE
		MessageBox( gs_AppName, "Could not open the file for write", StopSign!, OK! )
	END IF						
ELSE
	MessageBox( gs_AppName, "File name not populated.  Could not open file", StopSign!, OK! )
END IF

Destroy ln_blob_manipulator
SetPointer( Arrow! )


end subroutine

public function string of_getopenerrortext (integer a_nrv);/*****************************************************************************************
   Function:   fu_GetOpenErrorText
   Purpose:    Function to return the error message associated with the code
					returned from the ShellExecuteA function in the shell32 dll.
					
	Parameters: a_nRV - Integer - The error code.
	Returns:    String - The error message associated with the code.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/4/2001 K. Claver   Created.
*****************************************************************************************/
CHOOSE CASE a_nRV
	CASE 0 
		RETURN "The operating system is out of memory or resources."
	CASE 2 
		RETURN "The specified file was not found"
	CASE 3 
		RETURN "The specified path was not found."
	CASE 5 
		RETURN "The operating system denied access to the specified file."
	CASE 8 
		RETURN "There was not enough memory to complete the operation."
	CASE 10
		RETURN "Wrong Windows version"
	CASE 11
		RETURN "The .EXE file is invalid (non-Win32 .EXE or error in .EXE image)."
	CASE 12
		RETURN "Application was designed for a different operating system."
	CASE 13
		RETURN "Application was designed for MS-DOS 4.0."
	CASE 15
		RETURN "Attempt to load a real-mode program."
	CASE 16
		RETURN "Attempt to load a second instance of an application with non-readonly data segments."
	CASE 19
		RETURN "Attempt to load a compressed application file."
	CASE 20
		RETURN "Dynamic-link library (DLL) file failure."
	CASE 26
		RETURN "A sharing violation occurred."
	CASE 27 
		RETURN "The filename association is incomplete or invalid."
	CASE 28
		RETURN "The DDE transaction could not be completed because the request timed out."
	CASE 29
		RETURN "The DDE transaction failed."
	CASE 30
		RETURN "The DDE transaction could not be completed because other DDE transactions were being processed."
	CASE 31
		RETURN "There is no application associated with the given filename extension."
	CASE 32
		RETURN "The specified dynamic-link library was not found."
	CASE ELSE
		RETURN "Undocumented error code returned"
END CHOOSE
end function

public subroutine of_init_filter ();IF IsValid(THIS.iu_filter) THEN
	THIS.iu_filter.of_init(dw_report)
END IF
end subroutine

public subroutine of_clear_filter ();IF IsValid(iu_filter) THEN
	IF iu_filter.visible THEN
		THIS.EVENT ue_filters()
	END IF
END IF
end subroutine

public function boolean of_check_locked (string a_ccasenumber);Boolean l_bRV = FALSE
DateTime l_dtLockedDate
String l_cLockedBy

IF NOT IsNull( a_cCaseNumber ) AND Trim( a_cCaseNumber ) <> "" THEN	
	SELECT locked_by, locked_timestamp
	INTO :l_cLockedBy, :l_dtLockedDate
	FROM cusfocus.case_locks
	WHERE case_number = :a_cCaseNumber
	USING SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			MessageBox( gs_AppName, "Error determining lock status for the case."+ &
						" You will not be able to edit this case", StopSign!, OK! )
			l_bRV = TRUE
		CASE 0
			IF Upper( Trim( l_cLockedBy ) ) <> Upper( Trim( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) THEN
				MessageBox( gs_AppName, "This case is currently in use by "+l_cLockedBy+" since "+&
									String( l_dtLockedDate, "mm/dd/yyyy hh:mm:ss" )+".~r~n"+ &
									"You will not be able to transfer or attach documents to this case.", Information!, OK! )
				
				l_bRV = TRUE
			ELSE
				l_bRV = FALSE
			END IF
		CASE ELSE
			//SQLCA.SQLCode = 100 = No lock record found
	END CHOOSE
END IF

RETURN l_bRV
end function

on u_search_workqueues.create
int iCurrent
call super::create
this.st_slider=create st_slider
this.ole_image=create ole_image
this.tab_case_preview=create tab_case_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_slider
this.Control[iCurrent+2]=this.ole_image
this.Control[iCurrent+3]=this.tab_case_preview
end on

on u_search_workqueues.destroy
call super::destroy
destroy(this.st_slider)
destroy(this.ole_image)
destroy(this.tab_case_preview)
end on

event resize;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Resize
// Overrides:  yes!!!!!!!!!!!!!!!!
// Overview:   Resize the controls that were added to u_search
// Created by: JWhite
// History:    7/27/06 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_setredraw(False)

Call Super::resize

st_slider.Visible 			= Not IsValid(iu_overlaying_report)
//IF dw_report.DataObject <> 'd_faxlist_detail' THEN
//	dw_report_detail.Visible  	= Not IsValid(iu_overlaying_report)
//END IF

If Not IsValid(iu_overlaying_report) Then
	st_slider.Width = Width
	dw_report.Height = st_slider.Y - dw_report.Y
	tab_case_preview.Width = dw_report.Width
	tab_case_preview.Height = Height - tab_case_preview.Y
End If	
This.of_setredraw(True)
end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//					aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by:
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_row
LONG ll_selectedrow
String ls_syntax, ls_case_number
Datawindow ldw_data

Choose Case Lower(Trim(as_message))
	Case 'filter' //This is when the datawindow is filtered
		If dw_report.RowCount() = 0 Then
			tab_case_preview.tabpage_case_preview.dw_case_preview.Reset()
		Else
			ll_row = dw_report.GetRow()
			If ll_row > 0 And ll_row <= dw_report.RowCount() And Not IsNull(ll_row) Then
				dw_report.Event RowFocusChanged(ll_row)
			End If
		End If

	Case 'selectall'
		
	Case 'button clicked'
		Choose Case string(as_arg)
			Case 'restore'
				THIS.EVENT ue_save_syntax()
				IF dw_report.dataobject = 'd_faxlist_detail' THEN
					dw_report.Create(is_original_fax_syntax)
				ELSE
					dw_report.Create(is_original_work_syntax)
				END IF
				dw_report.TriggerEvent('ue_retrieve')
					THIS.TriggerEvent('resize')
			Case 'save template'
				THIS.EVENT ue_template_save()
			Case 'restore template'
				THIS.EVENT ue_save_syntax()
				ls_syntax = THIS.EVENT ue_template_restore()
				dw_report.Create(ls_syntax)
				dw_report.TriggerEvent('ue_retrieve')
					THIS.TriggerEvent('resize')
			Case 'attach image'
				ll_row = dw_report.RowCount()
				ll_selectedrow = dw_report.find("selectedrow = 'y'",1, ll_row)
				IF ll_selectedrow > 0 THEN
					iuo_parent_tabpg.of_attach(ll_selectedrow, 'attach')
				ELSE
					MessageBox(gs_AppName, "Please select an image to attach.", Exclamation!)
					RETURN
				END IF
			Case 'transfer case'
				ll_selectedrow = dw_report.GetRow()
				IF ll_selectedrow < 1 THEN
					MessageBox(gs_AppName, "Please select a case to transfer.", Exclamation!)
					RETURN
				END IF
				ls_Case_Number = dw_report.Object.case_number[ ll_selectedRow ]
				IF of_check_locked(ls_case_number) THEN
					RETURN
				END IF
				iuo_parent_tabpg.of_attach(ll_selectedrow, 'transfer')
			Case 'take ownership'
				ll_selectedrow = dw_report.GetRow()
				IF ll_selectedrow < 1 THEN
					MessageBox(gs_AppName, "Please select a case to take ownership of.", Exclamation!)
					RETURN
				END IF
				ls_Case_Number = dw_report.Object.case_number[ ll_selectedRow ]
				IF of_check_locked(ls_case_number) THEN
					RETURN
				END IF
				iuo_parent_tabpg.of_attach(ll_selectedrow, 'take')
		End Choose
	Case Else
		IF ClassName(as_arg) = "dw_report" THEN
			   ll_row = dw_report.GetRow()
	   		dw_report.Event RowFocusChanged(ll_row)
		END IF
End Choose


end event

event ue_refreshtheme;call super::ue_refreshtheme;st_slider.backcolor = gn_globals.in_theme.of_get_barcolor()

end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Get the rprtcnfgids so that we can look in SavedReport table to see if a previous saved syntax exists
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore ids_temp

  SELECT cusfocus.reportconfig.rprtcnfgid  
    INTO :il_fax_reportconfigid  
    FROM cusfocus.reportconfig  
   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search FAX Queues'
           ;

  SELECT cusfocus.reportconfig.rprtcnfgid  
    INTO :il_work_reportconfigid  
    FROM cusfocus.reportconfig  
   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Work Queues'
           ;

// store the original syntax for each datawindow in case
// we need to restore it later
ids_temp = create datastore
ids_temp.dataobject = 'd_faxlist_detail'
is_original_fax_syntax = ids_temp.Object.Datawindow.Syntax
ids_temp.dataobject = 'd_work_queue_detail'
is_original_work_syntax = ids_temp.Object.Datawindow.Syntax
destroy ids_temp

This.Event ue_get_saved_syntax()	
This.Post Event ue_post_constructor()	



end event

type dw_report from u_search`dw_report within u_search_workqueues
event ue_retrieve ( )
event ue_selecttrigger pbm_dwnkey
event ue_refresh_services ( )
integer width = 2199
integer height = 828
string dataobject = "d_work_queue_detail"
boolean livescroll = false
end type

event dw_report::ue_retrieve();LONG ll_header_id, ll_row, ll_rows
STRING ls_work_queue_type, ls_work_queue_description, ls_test, ls_user_id
DATASTORE lds_work_queue_list

ls_User_ID = OBJCA.WIN.fu_GetLogin(SQLCA)

lds_work_queue_list = CREATE DATASTORE
lds_work_queue_list.dataobject = 'd_work_queue_list'
lds_work_queue_list.SetTransObject(SQLCA)
ll_rows = lds_work_queue_list.Retrieve(ls_user_id)

ls_work_queue_description = iuo_parent_tabpg.ddlb_queues.text
ll_row = lds_work_queue_list.Find("description = '" + ls_work_queue_description + "'",1, ll_rows)
IF ll_row > 0 THEN
	ll_header_id = lds_work_queue_list.object.header_id[ll_row]
	ls_work_queue_type = lds_work_queue_list.object.type[ll_row]

	IF ls_work_queue_type = 'FAX' THEN // Fax / Document queue
		THIS.SetTransObject(SQLCA)
		THIS.EVENT ue_refresh_services()
		tab_case_preview.visible = false
		ole_image.visible = true
		THIS.Retrieve(ll_header_id)
		uo_titlebar.of_hide_button('Transfer Case', True)
		uo_titlebar.of_hide_button('Take Ownership', True)
		uo_titlebar.of_hide_button('Attach Image', False )
	ELSE // General work queue
		THIS.SetTransObject(SQLCA)
		THIS.EVENT ue_refresh_services()
		tab_case_preview.visible = true
		ole_image.visible = false
		THIS.Retrieve(ll_header_id)
		uo_titlebar.of_hide_button('Transfer Case', False)
		uo_titlebar.of_hide_button('Take Ownership', False)
		uo_titlebar.of_hide_button('Attach Image', True )
	END IF
END IF

DESTROY lds_work_queue_list

end event

event dw_report::ue_selecttrigger;W_CREATE_MAINTAIN_CASE	l_wCaseWindow
Long			l_nRow
String      l_cCaseNumber
Integer		li_return

IF THIS.dataobject = 'd_faxlist_detail' THEN
	IF ( key = KeyEnter! ) AND ( THIS.GetRow() > 0 ) THEN
		ib_enter_key = TRUE
		PARENT.of_display_image()
	END IF
ELSE // Bring up the case
	IF ( key = KeyEnter! ) AND ( THIS.GetRow() > 0 ) THEN
		// Get the selected case number
		l_nRow = GetRow( )
		l_cCaseNumber = THIS.Object.case_number[ l_nRow ]
		
		IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
			
			// Open w_create_maintain_case
			FWCA.MGR.fu_OpenWindow( w_create_maintain_case, -1 )
			l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet( )
			
			IF IsValid( l_wCaseWindow ) THEN
				 
				// Make sure the window is on the Search tab
				IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
					li_return = l_wCaseWindow.dw_folder.fu_SelectTab( 1 )
				END IF
				
				IF li_return = -1 THEN
					RETURN -1
				ELSE
					// call ue_casesearch to process the query after the window is fully initialized.
					l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber )
				END IF
				
			END IF
		END IF
	END IF
END IF

end event

event dw_report::ue_refresh_services();IF NOT IsValid(in_datawindow_graphic_service_manager) THEN
	in_datawindow_graphic_service_manager = Create n_datawindow_graphic_service_manager
END IF
in_datawindow_graphic_service_manager.of_init(dw_report)

in_datawindow_graphic_service_manager.of_destroy_service('n_rowfocus_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_column_sizing_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_show_fields')
in_datawindow_graphic_service_manager.of_destroy_service('n_group_by_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_datawindow_formatting_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_aggregation_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_sort_service')

in_datawindow_graphic_service_manager.of_add_service('n_rowfocus_service')
in_datawindow_graphic_service_manager.of_add_service('n_column_sizing_service')
in_datawindow_graphic_service_manager.of_add_service('n_show_fields')
in_datawindow_graphic_service_manager.of_add_service('n_group_by_service')
in_datawindow_graphic_service_manager.of_add_service('n_datawindow_formatting_service')
in_datawindow_graphic_service_manager.of_add_service('n_aggregation_service')
in_datawindow_graphic_service_manager.of_add_service('n_sort_service')

in_datawindow_graphic_service_manager.of_Create_services()


end event

event dw_report::constructor;call super::constructor;long	ll_reportconfigid

THIS.EVENT TRIGGER ue_refresh_services()


//this.TriggerEvent('ue_retrieve')

//  SELECT cusfocus.reportconfig.rprtcnfgid  
//    INTO :il_reportconfigid  
//    FROM cusfocus.reportconfig  
//   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Open Cases'   
//           ;

// Different reportconfig IDs for FAX and Work queues
IF dw_report.DataObject = 'd_faxlist_detail' THEN
	ll_reportconfigid = il_fax_reportconfigid
ELSE
	ll_reportconfigid = il_work_reportconfigid
END IF


Properties.of_init(ll_reportconfigid)
end event

event dw_report::destructor;call super::destructor;//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null, ll_reportconfigid
string	ls_null, ls_syntax
blob		lb_syntax

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Ensure these variables are null
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_null)
SetNull(ls_null)

//----------------------------------------------------------------------------------------------------------------------------------
// 11/27/06 RAP - Do not save the filter with the datawindow syntax
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report.SetFilter("")
dw_report.Filter()

//----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the datastore then get the syntax for the datawindow & convert it into a blob object
//-----------------------------------------------------------------------------------------------------------------------------------
// Different reportconfig IDs for FAX and Work queues
IF dw_report.DataObject = 'd_faxlist_detail' THEN
	ll_reportconfigid = il_fax_reportconfigid
ELSE
	ll_reportconfigid = il_work_reportconfigid
END IF

ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, ll_reportconfigid)
lb_syntax = blob(dw_report.Describe("DataWindow.Syntax"))
 
//----------------------------------------------------------------------------------------------------------------------------------
// If we dont' have a row, then insert a new row and set the values. Otherwise update the existing row and blob.
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_savedreport.RowCount() = 0 Then
	ll_new_row = ids_savedreport.InsertRow(0)
	
	ll_blobID = ln_blob_manipulator.of_insert_blob(lb_syntax, dw_report.dataobject)
	
	ids_savedreport.SetItem(ll_new_row, 'svdrprtfldrid', ls_null)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtblbobjctid', ll_blobID)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrprtcnfgid', ll_reportconfigid)
	ids_savedreport.SetItem(ll_new_row, 'svdrprttpe', 'S')
	ids_savedreport.SetItem(ll_new_row, 'svdrprtdstrbtnmthd', ls_null)	
	ids_savedreport.SetItem(ll_new_row, 'svdrprtuserid', gn_globals.il_userid)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnusrID', ll_null)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnlvl', 1)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
Else
	ll_blobID = ids_savedreport.getitemnumber(1, 'svdrprtblbobjctid')
	ln_blob_manipulator.of_update_blob(lb_syntax, ll_blobID, FALSE)
	
	ids_savedreport.SetItem(1, 'svdrprtblbobjctid', ll_blobID)
	ids_savedreport.SetItem(1, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
	ids_savedreport.SetItem(1, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
End If


//----------------------------------------------------------------------------------------------------------------------------------
// Save the changes to the database
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.Update()


//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy	ln_blob_manipulator
Destroy 	in_datawindow_graphic_service_manager
Destroy 	ids_savedreport
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;LONG ll_header_id, ll_blob_id
STRING ls_case_number, ls_filepath, ls_transfer_id
Long l_nFileNum, l_nAttachmentKey, l_nAttachFileNum
Integer l_nIndex, l_nLoop, l_nWriteRV, l_nRV
Blob l_blFile, l_blFilePart
Double l_dblFileSize
ContextKeyword l_ckTemp
String l_cTemp[ ], l_cFileName, l_cWriteFileName, l_cAttachFileLog
n_cst_kernel32 l_uoKernelFuncs
n_blob_manipulator ln_blob_manipulator

SetPointer(Hourglass!)
IF currentrow > 0 THEN
	IF THIS.DataObject = 'd_work_queue_detail' THEN
		ls_case_number = THIS.object.case_number[currentrow]
		ls_transfer_id = THIS.object.case_transfer_id[currentrow]
		tab_case_preview.tabpage_case_preview.dw_case_preview.Retrieve(ls_case_number, il_conf_level)
		tab_case_preview.tabpage_transfer_notes.dw_transfer_notes.Retrieve(ls_transfer_id)
	ELSE
		ln_blob_manipulator = CREATE n_blob_manipulator
	
		ll_blob_id = dw_report.object.blbobjctid[currentrow]
		l_blFile = ln_blob_manipulator.of_retrieve_blob(ll_blob_id)
		DESTROY ln_blob_manipulator
		
		#IF defined PBDOTNET THEN
			l_cTemp[1] = System.IO.Path.GetTempPath()
		#ELSE
			l_ckTemp = CREATE ContextKeyword
			l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 
			
			//Have the needed info.  Destroy the object.
			DESTROY l_ckTemp
		#END IF
		
		l_cFileName = gn_globals.is_login + "_" + String(ll_blob_id) + "_temp.tif"
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
		
		filedelete(l_cWriteFileName)
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
				FileDelete( l_cWriteFileName )
							
				MessageBox( gs_AppName, "Unable to write to file "+l_cWriteFileName+".", &
								StopSign!, OK! )									
			ELSE
				FileClose( l_nFileNum )
				ole_image.object.Clear()
//				ole_image.object.ClosePicture()
				ole_image.object.Close2Picture()
//				ole_image.object.Refresh()
	
			////	ole_image.dynamic document( l_blFile )
		//		ls_filepath = "C:\Documents and Settings\rpost\My Documents\My Pictures\buffalo_cloud.jpg"
		//		ls_filepath = "C:\Rick Work\54 Work Queues\abcmj9ro4te_001.tif"
				ole_image.object.DisplayFromFile(l_cWriteFileName)
				ole_image.object.SetZoomWidth()
				ole_image.object.EnableMenu(TRUE)
				ole_image.object.ScrollBars(TRUE)
				ole_image.object.SetVScrollBarPosition(1)
				ole_image.object.ClipControls(TRUE)
				ole_image.object.Redraw()
			END IF
		END IF
	END IF	
ELSE
	tab_case_preview.tabpage_case_preview.dw_case_preview.Reset()
	tab_case_preview.tabpage_transfer_notes.dw_transfer_notes.Reset()
END IF

SetPointer(Arrow!)
	
end event

event dw_report::doubleclicked;call super::doubleclicked;
W_CREATE_MAINTAIN_CASE	l_wCaseWindow
Long			l_nRow
String      l_cCaseNumber
INTEGER		li_return

//Pass the event to the Column Resizing Service
If IsValid(in_columnsizingservice_detail) Then
	in_columnsizingservice_detail.of_doubleclicked(dwo.Name, This.PointerX())
End If

IF THIS.dataobject = 'd_faxlist_detail' THEN
	Parent.of_display_image()
ELSE // Open the case
	
	// Get the selected case number
	l_nRow = GetRow( )
	l_cCaseNumber = THIS.Object.case_number[ l_nRow ]
	
	IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
		
		IF of_check_locked(l_cCaseNumber) THEN
			RETURN
		END IF
		li_return = MessageBox(gs_appname, "Do you want to take ownership of case #" + l_cCaseNumber + "?", Question!, YesNoCancel!)
		IF li_return = 3 THEN
			RETURN
		ELSEIF li_return = 1 THEN
			li_return = iuo_parent_tabpg.of_attach(l_nRow, 'take')
			IF li_return = -1 THEN RETURN
		END IF
		// Open w_create_maintain_case
		FWCA.MGR.fu_OpenWindow( w_create_maintain_case, -1 )
		l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet( )
		
		IF IsValid( l_wCaseWindow ) THEN
			 
			// Make sure the window is on the Search tab
			IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
				li_return = l_wCaseWindow.dw_folder.fu_SelectTab( 1 )
			END IF
			
			IF li_return = -1 THEN
				RETURN -1
			ELSE
				// call ue_casesearch to process the query after the window is fully initialized.
				l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber )
			END IF
			
		END IF
	END IF
END IF


end event

event dw_report::ue_dwnkey;call super::ue_dwnkey;THIS.Event Trigger ue_selecttrigger( key, keyflags )
end event

type uo_titlebar from u_search`uo_titlebar within u_search_workqueues
string tag = "Work Queues"
end type

event uo_titlebar::constructor;call super::constructor;This.of_delete_button('criteria')
This.of_delete_button('customize')
This.of_delete_button('retrieve')

end event

type st_separator from u_search`st_separator within u_search_workqueues
end type

type st_slider from u_slider_control_horizontal within u_search_workqueues
boolean visible = false
integer y = 944
integer width = 2194
integer height = 20
long backcolor = 15780518
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   Moves the position of the pane control to the coordinated specified in 
//					in the instance variable ib_automove_up, and then repositions/resizes
//					all objects being controlled by the pane control.
//
// Created by: 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Turn the redraw off for reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(False)

//-----------------------------------------------------
// If the pane controlled has been previously doubleclicked,
// then reset the pane control to its previous position, else
// set the pane control to the position specified by
// ib_doubleclick_up.
// ib_doubleclick_up = True - Expand Up
// ib_doubleclick_up = False - Expand Down
//-----------------------------------------------------
If ib_click Then

	//-----------------------------------------------------
	// Set the Y coordinate for the pane control to the
	// previous position
	//-----------------------------------------------------
	This.Y = of_get_prev_ypos()
	ib_click = False
	
Else

	//-----------------------------------------------------
	// Store the current Y coordinate, and move the pane
	// control up or down based on the variable ib_doubleclick_up.
	// ib_doubleclick_up = True - Expand Up
	// ib_doubleclick_up = False - Expand Down
	//-----------------------------------------------------
	of_set_prev_ypos(This.Y)
	if ib_automove_up then
		This.Y = of_min_Y()
	Else
		This.Y = of_max_Y()
	End IF
	ib_click = True

End If

//-----------------------------------------------------
// Turn redraw back on for the reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(True)
 
end event

type ole_image from olecustomcontrol within u_search_workqueues
event zoomchange ( )
event scroll ( )
event zoomchanged ( )
event pagechange ( )
event displayed ( )
event keypress ( ref integer keyascii )
event keyup ( ref integer keycode,  ref integer shift )
event keydown ( ref integer keycode,  ref integer shift )
event mousemove ( ref integer button,  ref integer shift,  ref real ocx_x,  ref real ocx_y )
event click ( )
event dblclick ( )
event mousedown ( ref integer button,  ref integer shift,  ref real ocx_x,  ref real ocx_y )
event mouseup ( ref integer button,  ref integer shift,  ref real ocx_x,  ref real ocx_y )
event resize ( )
string tag = "GdViewer Control"
integer y = 960
integer width = 2194
integer height = 432
integer taborder = 30
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "u_search_workqueues.udo"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

event dblclick();THIS.object.PrintImage()
end event

event destructor;ole_image.object.Close2Picture()
ole_image.object.Clear()
end event

type tab_case_preview from uo_tab_case_preview within u_search_workqueues
event ue_resize ( )
integer y = 964
integer height = 444
integer taborder = 31
boolean bringtotop = true
end type

event ue_resize();String ls_return

tabpage_case_preview.dw_case_preview.width = THIS.width - 40
tabpage_case_preview.dw_case_preview.height = tabpage_case_preview.height
tabpage_transfer_notes.dw_transfer_notes.width = THIS.width - 40
tabpage_transfer_notes.dw_transfer_notes.height = tabpage_transfer_notes.height
ls_return = tabpage_transfer_notes.dw_transfer_notes.Modify('case_transfer_notes.width="' + String(THIS.Width - 150) + '"')
ole_image.Width = THIS.Width
ole_image.Height = THIS.Height
ole_image.X = THIS.X
ole_image.Y = THIS.Y

end event

event resize;call super::resize;THIS.POST EVENT ue_resize()

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Bu_search_workqueues.bin 
2200000c00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000004db1355001c93ebd00000003000001800000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe000000000000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a0000000200000001000000042de5a9184b8615e334c0d7af58239b55000000004db1355001c93ebd4db1355001c93ebd0000000000000000000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
27ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000b29300000090000800034757f20b000000200065005f00740078006e0065007800740000319c000800034757f20a000000200065005f00740078006e00650079007400000b2a000a00023315602500000024007000610065007000720061006e0061006500630000000100090003be257526ffffff9c00610062006b0063006f0063006f006c00000072000000000054005c006f006f0073006c0042005c006e0069005c006e0053005600680053006c0065005c006c006f0043006d006d0000b29300000090000800034757f20b000000200065005f00740078006e0065007800740000319c000800034757f20a000000200065005f00740078006e00650079007400000b2a000a00023315602500000024007000610065007000720061006e0061006500630000000100090003be257526ffffff9c00610062006b0063006f0063006f006c0000007200000000006100720020006d006900460065006c005c00730079005300610062006500730053005c004c0051004100200079006e006800770072006500200065003000310077005c006e0069003200330043003b005c003a007200500067006f006100720020006d006900460065006c005c00730079005300610062006500730053005c004c0051004100200079006e006800770072006500200065003000310053005c00620079007300610020006500650043004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000300000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Bu_search_workqueues.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
