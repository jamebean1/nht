$PBExportHeader$u_tabpage_case_attachments.sru
forward
global type u_tabpage_case_attachments from u_tabpg_std
end type
type cb_open from commandbutton within u_tabpage_case_attachments
end type
type cb_edit from commandbutton within u_tabpage_case_attachments
end type
type cb_save from commandbutton within u_tabpage_case_attachments
end type
type st_noattachments from statictext within u_tabpage_case_attachments
end type
type cb_delete from commandbutton within u_tabpage_case_attachments
end type
type cb_add from commandbutton within u_tabpage_case_attachments
end type
type dw_attachment_list from u_dw_std within u_tabpage_case_attachments
end type
end forward

global type u_tabpage_case_attachments from u_tabpg_std
integer width = 3534
integer height = 784
event ue_openattachment ( integer a_nrow )
cb_open cb_open
cb_edit cb_edit
cb_save cb_save
st_noattachments st_noattachments
cb_delete cb_delete
cb_add cb_add
dw_attachment_list dw_attachment_list
end type
global u_tabpage_case_attachments u_tabpage_case_attachments

type prototypes
FUNCTION long ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "SHELL32.DLL" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder
U_DW_STD						i_dwCaseDetails
end variables

forward prototypes
public function string fu_getopenerrortext (integer a_nrv)
public subroutine fu_disable ()
end prototypes

event ue_openattachment;/*****************************************************************************************
   Event:      ue_OpenAttachment
   Purpose:    To open a case attachment.
	
	Parameters: a_nRow - Integer - The row in the datawindow that was selected or
											 double-clicked.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Created
*****************************************************************************************/
Long l_nFileNum, l_nAttachmentKey, l_nAttachFileNum
Integer l_nIndex, l_nLoop, l_nWriteRV, l_nRV
Blob l_blFile, l_blFilePart
Double l_dblFileSize
ContextKeyword l_ckTemp
String l_cTemp[ ], l_cFileName, l_cWriteFileName, l_cAttachFileLog
n_cst_kernel32 l_uoKernelFuncs

SetPointer( HourGlass! )

//Get the file name
l_cFileName = dw_attachment_list.Object.attachment_name[ a_nRow ]
l_nAttachmentKey = dw_attachment_list.Object.attachment_key[ a_nRow ]

//Attempt to get the file image
SELECTBLOB attachment_image
INTO :l_blFile
FROM cusfocus.case_attachments
WHERE attachment_key = :l_nAttachmentKey
USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	MessageBox( gs_AppName, "Failed to retrieve the file image from the database.  Error returned:~r~n"+ &
					SQLCA.SQLErrText, StopSign!, OK! )
ELSEIF Trim( l_cFileName ) <> "" THEN
	//Prepare to open the document.
	// Get the Temp Path from Environment Variables to write the file
	// out before attempt to open.
	l_ckTemp = CREATE ContextKeyword
	l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 
	
	//Have the needed info.  Destroy the object.
	DESTROY l_ckTemp
	
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
			l_nRV = ShellExecuteA( 0, "open", l_cFileName, "" , l_cTemp[ 1 ], 1 )
			
			IF l_nRV = 31 THEN
				//No application associated with this file type.  Let the user pick one.
				l_nRV = ShellExecuteA( 0, "open", "rundll32.exe", ( "shell32.dll,OpenAs_RunDLL "+l_cFileName ), l_cTemp[ 1 ], 1 ) 
			END IF
			
			IF l_nRV >= 0 AND l_nRV <= 32 THEN
				MessageBox( gs_AppName, THIS.fu_GetOpenErrorText( l_nRV ) )
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

SetPointer( Arrow! )
end event

public function string fu_getopenerrortext (integer a_nrv);/*****************************************************************************************
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

public subroutine fu_disable ();/*****************************************************************************************
   Function:   fu_Disable
   Purpose:    Function to enable/disable the buttons on the tabpage.
					
	Parameters: None
	Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/10/2001 K. Claver  Created.
*****************************************************************************************/
Integer l_nConfidLevel, l_nRow

//Enable the add button.  Should only be disabled for closed or voided cases or new cases.
IF Trim( THIS.i_wParentWindow.i_cCurrentCase ) = "" THEN // new case, until it is saved, the insert will fail
	cb_add.Enabled = FALSE
ELSE
	IF THIS.i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = "O" THEN
		cb_add.Enabled = TRUE
	ELSE
		//-----------------------------------------------------------------------------------------------------------------------------------
	
		// JWhite 1/3/06 - Adding a check to enable the button if the user is in the "Edit Closed Case" role in the registry.
		//-----------------------------------------------------------------------------------------------------------------------------------
	
		If i_wParentWindow.i_bSupervisorRole = TRUE Then 
			cb_add.Enabled = TRUE
		Else 
			cb_add.Enabled = FALSE
		End If
	END IF
END IF

//Check if can enable the other buttons.
l_nRow = dw_attachment_list.GetSelectedRow( 0 )
			
IF l_nRow > 0 AND	Trim( THIS.i_wParentWindow.i_cCurrentCase ) <> "" AND NOT THIS.i_wParentWindow.i_bCaseLocked THEN
	l_nConfidLevel = dw_attachment_list.Object.confidentiality_level[ l_nRow ]
	
	IF l_nConfidLevel > i_wParentWindow.i_nRepConfidLevel AND NOT IsNull( l_nConfidLevel ) THEN
		cb_open.Enabled = FALSE
		cb_save.Enabled = FALSE
		cb_edit.Enabled = FALSE
		cb_delete.Enabled = FALSE
	ELSE
		//Open and save should be enabled for cases the user has security to view(open or closed)
		cb_open.Enabled = TRUE
		cb_save.Enabled = TRUE
		
		IF THIS.i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = "O" THEN			
			cb_edit.Enabled = TRUE
			cb_delete.Enabled = TRUE
		ELSE
			//-----------------------------------------------------------------------------------------------------------------------------------

			// JWhite 1/3/06 - Check the role, if they are in the "edit close case" role in the registry then enable the buttons.
			//-----------------------------------------------------------------------------------------------------------------------------------

			If i_wParentWindow.i_bSupervisorRole <> TRUE Then 
				cb_edit.Enabled = FALSE
				cb_delete.Enabled = FALSE
			Else
				cb_edit.Enabled = TRUE
				cb_delete.Enabled = TRUE
			End If
		END IF
	END IF
ELSE
	//Even if locked, should still be able to open attachments.
	IF l_nRow > 0 AND	Trim( THIS.i_wParentWindow.i_cCurrentCase ) <> "" AND &
		THIS.i_wParentWindow.i_bCaseLocked THEN
		l_nConfidLevel = dw_attachment_list.Object.confidentiality_level[ l_nRow ]
	
		IF l_nConfidLevel <= i_wParentWindow.i_nRepConfidLevel OR IsNull( l_nConfidLevel ) THEN
			cb_open.Enabled = TRUE
		ELSE
			cb_open.Enabled = FALSE
		END IF
	ELSE
		cb_open.Enabled = FALSE
	END IF
	
	cb_save.Enabled = FALSE
	cb_edit.Enabled = FALSE
	cb_delete.Enabled = FALSE
END IF
end subroutine

on u_tabpage_case_attachments.create
int iCurrent
call super::create
this.cb_open=create cb_open
this.cb_edit=create cb_edit
this.cb_save=create cb_save
this.st_noattachments=create st_noattachments
this.cb_delete=create cb_delete
this.cb_add=create cb_add
this.dw_attachment_list=create dw_attachment_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_open
this.Control[iCurrent+2]=this.cb_edit
this.Control[iCurrent+3]=this.cb_save
this.Control[iCurrent+4]=this.st_noattachments
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_add
this.Control[iCurrent+7]=this.dw_attachment_list
end on

on u_tabpage_case_attachments.destroy
call super::destroy
destroy(this.cb_open)
destroy(this.cb_edit)
destroy(this.cb_save)
destroy(this.st_noattachments)
destroy(this.cb_delete)
destroy(this.cb_add)
destroy(this.dw_attachment_list)
end on

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Added code set instance variables and register the objects with the
								 resize service.
*****************************************************************************************/
i_wParentWindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder
i_dwCaseDetails = i_tabFolder.tabpage_case_details.dw_case_details

THIS.of_SetResize( TRUE )
IF IsValid( THIS.inv_resize ) THEN
	// resize the attachment list view
	THIS.inv_resize.of_Register( dw_attachment_list, "ScaleToRight&Bottom" )
	
	// reposition buttons
	THIS.inv_resize.of_Register( cb_add, "FixedToRight&Bottom" )
	THIS.inv_resize.of_Register( cb_edit, "FixedToRight&Bottom" )
	THIS.inv_resize.of_Register( cb_delete, "FixedToRight&Bottom" ) 
	THIS.inv_resize.of_Register( cb_open, "FixedToBottom" )
	THIS.inv_resize.of_Register( cb_save, "FixedToBottom" )
END IF
end event

event destructor;call super::destructor;/*****************************************************************************************
   Event:      destructor
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/5/2001 K. Claver   Added code to attempt to clean up opened attachment files stored
								 in the temp directory.
*****************************************************************************************/
Long l_nFileNum
ContextKeyword l_ckTemp
String l_cAttachFileLog, l_cTemp[ ], l_cDeleteFile
n_cst_kernel32 l_uoKernelFuncs

// Get the Temp Path from Environment Variables to attempt to find the log file.
l_ckTemp = CREATE ContextKeyword
l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 

//Have the needed info.  Destroy the object.
DESTROY l_ckTemp

//If temp Path is not available, use Root drive.
IF NOT l_uoKernelFuncs.of_DirectoryExists( l_cTemp[ 1 ] ) THEN 
	l_cTemp[ 1 ] = 'C:\'
END IF

//Get rid of any potential white space.
l_cTemp[ 1 ] = Trim( l_cTemp[ 1 ] )

//Add the directory to the file name.
IF Mid( l_cTemp[ 1 ], Len( l_cTemp[ 1 ] ), 1 ) = "\" THEN
	l_cAttachFileLog = ( l_cTemp[ 1 ]+"cfattachfile.log" )
ELSE
	l_cAttachFileLog = ( l_cTemp[ 1 ]+"\"+"cfattachfile.log" )
END IF

IF FileExists( l_cAttachFileLog ) THEN
	//Open the file and read each line.
	l_nFileNum = FileOpen( l_cAttachFileLog, LineMode!, Read!, LockRead! )
	
	IF l_nFileNum > 0 THEN
		DO WHILE FileRead( l_nFileNum, l_cDeleteFile ) > 0
			l_cDeleteFile = Trim( l_cDeleteFile )
			
			//Delete the file if it exists.
			IF FileExists( l_cDeleteFile ) THEN
				FileDelete( l_cDeleteFile )
			END IF
		LOOP
		
		FileClose( l_nFileNum )
		
		//Clean up the attachment log file.
		FileDelete( l_cAttachFileLog )
	END IF
END IF
		
end event

type cb_open from commandbutton within u_tabpage_case_attachments
integer x = 23
integer y = 672
integer width = 448
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Open"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Added call to event to open the attachment.
*****************************************************************************************/
Integer l_nRow

l_nRow = dw_attachment_list.GetSelectedRow( 0 )

IF l_nRow > 0 THEN
	PARENT.Event Trigger ue_OpenAttachment( l_nRow )
END IF
end event

type cb_edit from commandbutton within u_tabpage_case_attachments
integer x = 2578
integer y = 672
integer width = 448
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Edit"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Added code to open the case attachment window to allow the user to
								 edit the description or the security.
*****************************************************************************************/
Integer l_nRow, l_nRV, l_nConfidLevel
Long l_nAttachmentKey
String l_cDesc

l_nRow = dw_attachment_list.GetSelectedRow( 0 )

IF l_nRow > 0 THEN
	l_nAttachmentKey = dw_attachment_list.Object.attachment_key[ l_nRow ]
	
	//Open the window.  Passing in as a string as the fu_openwindow doesn't
	//  correctly pass a double value.
	FWCA.MGR.fu_OpenWindow( w_case_attachment, String( l_nAttachmentKey ) )
	
	dw_attachment_list.SetRedraw( FALSE )
	
	l_cDesc = Trim( Message.StringParm )
	
	IF l_cDesc <> "CNCL" THEN
		//Re-retrieve the list datawindow as the add/edit window updated something
		l_nRV = dw_attachment_list.fu_Retrieve( dw_attachment_list.c_IgnoreChanges, &
												 			 dw_attachment_list.c_ReselectRows )	  
															  
		IF l_nRV <> 0 THEN
			MessageBox( gs_AppName, "Unable to re-retrieve the list datawindow with changes", StopSign!, OK! )
		END IF
	END IF
	
	dw_attachment_list.SetRedraw( TRUE )
END IF

//Enable/Disable the controls
PARENT.fu_Disable( )
end event

type cb_save from commandbutton within u_tabpage_case_attachments
integer x = 503
integer y = 672
integer width = 448
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Added code to open the save dialog and save the file out of the
								 database.
*****************************************************************************************/
Integer l_nRow, l_nRV, l_nMessageRV, l_nLoop, l_nWriteRV, l_nIndex
Long l_nAttachmentKey, l_nFileNum
String l_cFileName, l_cReturnFileName, l_cCurrPath
Blob l_blFile, l_blFilePart
Double l_dblFileSize
DateTime l_dtDateTime
n_cst_kernel32 l_uoKernelFuncs

//Get the current directory so can change back after attach a file
//  from another directory.
l_cCurrPath = l_uoKernelFuncs.of_GetCurrentDirectory( )

l_nRow = dw_attachment_list.GetSelectedRow( 0 )

IF l_nRow > 0 THEN
	l_cFileName = dw_attachment_list.Object.attachment_name[ l_nRow ]
	
	l_nRV = GetFileSaveName( "Save File As", l_cFileName, l_cReturnFileName )
	
	//Return file name and path are passed back by reference into the l_cFileName var.
	IF l_nRV = 1 AND Trim( l_cFileName ) <> "" THEN
		IF FileExists( l_cFileName ) THEN
			l_nMessageRV = MessageBox( gs_AppName, "File already exists. Overwrite file?", Question!, YesNo! )
				
			IF l_nMessageRV = 2 THEN
				RETURN
			END IF
		END IF
				
		l_nAttachmentKey = dw_attachment_list.Object.attachment_key[ l_nRow ]
		
		SetPointer( HourGlass! )
		
		SELECTBLOB attachment_image
		INTO :l_blFile
		FROM cusfocus.case_attachments
		WHERE attachment_key = :l_nAttachmentKey
		USING SQLCA;
		
		IF SQLCA.SQLCode <> 0 THEN
			MessageBox( gs_AppName, "Failed to retrieve the file image from the database.  Error returned:~r~n"+ &
							SQLCA.SQLErrText, StopSign!, OK! )
		ELSE
			l_nFileNum = FileOpen( l_cFileName, StreamMode!, Write!, LockWrite!, Replace! )
			
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
								
					MessageBox( gs_AppName, "Unable to write to file "+l_cFileName+".", &
									StopSign!, OK! )									
				ELSE
					FileClose( l_nFileNum )
					
					//All is good.  Set the creation date and the last modified date.
					l_dtDateTime = dw_attachment_list.Object.attachment_created[ l_nRow ]
					l_uoKernelFuncs.of_SetCreationDateTime( l_cFileName, Date( l_dtDateTime ), Time( l_dtDateTime ) )
					l_dtDateTime = dw_attachment_list.Object.attachment_timestamp[ l_nRow ]
					l_uoKernelFuncs.of_SetLastWriteDateTime( l_cFileName, Date( l_dtDateTime ), Time( l_dtDateTime ) )					
				END IF
			END IF						
		END IF
		
		SetPointer( Arrow! )
	END IF	
END IF

//Change back to the app directory.  Need to do this so can find the help file and other
//  files without coded paths.
l_uoKernelFuncs.of_ChangeDirectory( l_cCurrPath )
end event

type st_noattachments from statictext within u_tabpage_case_attachments
boolean visible = false
integer x = 37
integer y = 108
integer width = 1147
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "There are no attachments for this case."
boolean focusrectangle = false
end type

type cb_delete from commandbutton within u_tabpage_case_attachments
integer x = 3058
integer y = 672
integer width = 448
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Added code to delete the selected row from the datawindow
*****************************************************************************************/
Integer l_nRow[ ], l_nSelectedRow, l_nRV, l_nMessageRV, l_nConfidLevel

l_nSelectedRow = dw_attachment_list.GetSelectedRow( 0 )

IF l_nSelectedRow > 0 THEN
	l_nMessageRV = MessageBox( gs_AppName, "Are you sure you want to delete the selected attachment?",+ &
										Question!, YesNo! )
										
	IF l_nMessageRV = 1 THEN
		l_nRow[ 1 ] = l_nSelectedRow
		
		l_nRV = dw_attachment_list.fu_Delete( 1, &
														  l_nRow, &
														  dw_attachment_list.c_IgnoreChanges )														  
		
		IF l_nRV = 0 THEN
			l_nRV = dw_attachment_list.fu_Save( dw_attachment_list.c_IgnoreChanges )
		END IF
		
		IF l_nRV < 0 THEN
			MessageBox( gs_AppName, "Failed to delete the attachment", StopSign!, OK! )
		END IF
	END IF
END IF

//Enable/Disable the buttons
PARENT.fu_Disable( )
end event

type cb_add from commandbutton within u_tabpage_case_attachments
integer x = 2098
integer y = 672
integer width = 448
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Add"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Added code to open the attachment window and import the file into
								 the database.
	12/19/2002 K. Claver  Added code to generate a new case number if the case doesn't already
								 have one.
*****************************************************************************************/
Integer l_nRV, l_nRow, l_nLoop, l_nIndex, l_nConfidLevel, l_nSelectedRow[ ]
String l_cInfo, l_cFileName, l_cFileNamePath, l_cDesc, l_cMessage, l_cConfidLevel, l_cCurrPath
String l_cCurrCaseNum, l_cCurrCaseMasterNum
Long l_nAttachmentKey, l_nFileNum
Double l_dblFileSize
Blob l_blFilePart, l_blFile
Boolean l_bAutoCommit, l_bAccessDenied = FALSE
n_cst_kernel32 l_uoKernelFuncs
Date l_dDate
Time l_tTime
DateTime l_dtCreationDate, l_dtLastWriteDate, ldt_timestamp
String ls_find_string
Long ll_pos

//??? RAP, trying to figure out if the case has been saved yet.
ls_find_string =  i_wParentWindow.i_cCurrentCase
ls_find_string = i_wParentWindow.i_cSelectedCase
//Get the current directory so can change back after attach a file
//  from another directory.
l_cCurrPath = l_uoKernelFuncs.of_GetCurrentDirectory( )

//Open the window
FWCA.MGR.fu_OpenWindow( w_case_attachment )

dw_attachment_list.SetRedraw( FALSE )

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
	
	// Remove quotes from the file name
	ll_pos = POS(l_cFileName, "'")
	DO WHILE ll_pos > 0
		l_cFileName = MID(l_cFileName, 1, ll_pos -1) + MID(l_cFileName, ll_pos + 1)
		ll_pos = POS(l_cFileName, "'")
	LOOP
	
	IF l_cDesc = "NULL" THEN
		SetNull( l_cDesc )
	END IF
	
	IF l_cConfidLevel = "NULL" THEN
		SetNull( l_nConfidLevel )
	ELSE
		l_nConfidLevel = Long( l_cConfidLevel )
	END IF
	
	SetPointer( HourGlass! )
	
	//Add the info into the datawindow
	l_nRow = dw_attachment_list.InsertRow( 0 )
	
	IF l_nRow > 0 THEN
		st_noattachments.Visible = FALSE						
		
		dw_attachment_list.Object.case_number[ l_nRow ] = i_wParentWindow.i_cCurrentCase
		dw_attachment_list.Object.attachment_name[ l_nRow ] = l_cFileName
		dw_attachment_list.Object.attachment_desc[ l_nRow ] = l_cDesc
		dw_attachment_list.Object.confidentiality_level[ l_nRow ] = l_nConfidLevel
		dw_attachment_list.Object.updated_by[ l_nRow ] = OBJCA.WIN.fu_GetLogin( SQLCA )
		dw_attachment_list.Object.updated_timestamp[ l_nRow ] = i_wParentWindow.fw_GetTimeStamp( )
		ldt_timestamp = dw_attachment_list.Object.updated_timestamp[ l_nRow ]
		
		//Get file datetime and size info
		l_dblFileSize = l_uoKernelFuncs.of_GetFileSize( l_cFileNamePath )
		l_uoKernelFuncs.of_GetCreationDateTime( l_cFileNamePath, l_dDate, l_tTime )
		l_dtCreationDate = DateTime( l_dDate, l_tTime )
		l_uoKernelFuncs.of_GetLastWriteDateTime( l_cFileNamePath, l_dDate, l_tTime )
		l_dtLastWriteDate = DateTime( l_dDate, l_tTime )
		
		//Set the info into the datawindow
		dw_attachment_list.Object.attachment_size[ l_nRow ] = l_dblFileSize
		dw_attachment_list.Object.attachment_timestamp[ l_nRow ] = l_dtLastWriteDate
		dw_attachment_list.Object.attachment_created[ l_nRow ] = l_dtCreationDate
		
		//Select the new row
		l_nSelectedRow[ 1 ] = l_nRow
		dw_attachment_list.fu_SetSelectedRows( 1, &
															l_nSelectedRow, &
															dw_attachment_list.c_IgnoreChanges, &
															dw_attachment_list.c_NoRefreshChildren )
		
		//Need to insert the row into the database before attempt to add the file
		l_nRV = dw_attachment_list.fu_Save( dw_attachment_list.c_IgnoreChanges )
		
		IF l_nRV = 0 THEN
			//Update the updated by and timestamp for the case
			IF PARENT.i_dwCaseDetails.RowCount( ) > 0 THEN
				//Modify the case updated by and timestamp and save the datawindow
				PARENT.i_dwCaseDetails.Object.case_log_updated_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
				PARENT.i_dwCaseDetails.Object.case_log_updated_timestamp[ 1 ] = i_wParentWindow.fw_GetTimeStamp( )
				
				//Check that there is a case number defined.  If not, get one.
				l_cCurrCaseNum = PARENT.i_dwCaseDetails.Object.case_log_case_number[ 1 ]
				IF ( IsNull( l_cCurrCaseNum ) OR Trim( l_cCurrCaseNum ) = "" ) AND &
					IsNull( PARENT.i_wParentWindow.i_uoCaseDetails.i_cNewCaseNum ) THEN
					PARENT.i_wParentWindow.i_uoCaseDetails.i_cNewCaseNum = PARENT.i_wParentWindow.fw_GetKeyValue( 'case_log' )
				END IF
				
				l_cCurrCaseMasterNum = PARENT.i_dwCaseDetails.Object.case_log_master_case_number[ 1 ]
				IF PARENT.i_wParentWindow.i_bLinked AND &
					IsNull( PARENT.i_wParentWindow.i_uoCaseDetails.i_cNewMasterCaseNum ) AND &
					( IsNull( l_cCurrCaseMasterNum ) OR Trim( l_cCurrCaseMasterNum ) = "" ) THEN
					PARENT.i_wParentWindow.i_uoCaseDetails.i_cNewMasterCaseNum = PARENT.i_wParentWindow.fw_GetKeyValue( 'case_log_master_num' )
				END IF
				
				l_nRV = i_dwCaseDetails.fu_Save( i_dwCaseDetails.c_SaveChanges )
				
				IF l_nRV <> 0 THEN
					MessageBox( gs_AppName, "Error saving updated by and date/time for the case" )
				END IF
			END IF
			
			//Re-retrieve the datawindow to ensure that the identity column is populated!
			dw_attachment_list.fu_Retrieve( dw_attachment_list.c_IgnoreChanges, dw_attachment_list.c_ReselectRows )
			
			//Get the key value to update the row in the database.  Depends on PowerClass to
			//  reselect the new row - ugh.
			//It doesn't work, find and select the right row
			ls_find_string = "attachment_name = '" + l_cFileName + "' and String(updated_timestamp) = '" + String( ldt_timestamp) + "'"
			l_nRow = dw_attachment_list.Find(ls_find_string, 0, dw_attachment_list.RowCount())
			IF l_nRow > 0 THEN
				dw_attachment_list.selectrow( l_nRow, TRUE)
				dw_attachment_list.scrolltorow( l_nRow )
			END IF

//			l_nRow = dw_attachment_list.GetSelectedRow( 0 )
			l_nAttachmentKey = dw_attachment_list.Object.attachment_key[ l_nRow ]
			
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
				
				//Store the autocommit value as needs to be true for
				//  updating the image.
				l_bAutoCommit = SQLCA.AutoCommit
				SQLCA.AutoCommit = TRUE
				
				UPDATEBLOB cusfocus.case_attachments
				SET attachment_image = :l_blFile
				WHERE attachment_key = :l_nAttachmentKey
				USING SQLCA;
				
				IF SQLCA.SQLCode = -1 THEN
					l_cMessage = "Error saving file image to database.~r~nError returned: "+SQLCA.SQLErrText
				END IF
				
				//Set the autocommit value back.
				SQLCA.AutoCommit = l_bAutoCommit
			ELSE
				l_cMessage = "Unable to open the file to attach to the case"				
			END IF						
		ELSE
			l_cMessage = "Failed to update the database with the attachment information"
		END IF
	ELSE
		l_cMessage = "Failed to insert the attachment row"
	END IF
END IF

IF NOT IsNull( l_cMessage ) AND Trim( l_cMessage ) <> "" THEN
	MessageBox( gs_AppName, l_cMessage, StopSign!, OK! )
	
	//Find the row just inserted.  Could have changed position as a result of the
	//  user sorting the datawindow before attempting to attach a new file.
	IF l_nAttachmentKey > 0 AND dw_attachment_list.RowCount( ) > 0 THEN
		l_nRow = dw_attachment_list.Find( "attachment_key = "+String( l_nAttachmentKey ), 1, dw_attachment_list.RowCount( ) )
		IF l_nRow > 0 THEN
			dw_attachment_list.DeleteRow( l_nRow )
			dw_attachment_list.fu_Save( dw_attachment_list.c_IgnoreChanges )
		END IF
	END IF
END IF

SetPointer( Arrow! )

//Change back to the app directory.  Need to do this so can find the help file and other
//  files without coded paths.
l_uoKernelFuncs.of_ChangeDirectory( l_cCurrPath )

//Enable/Disable the controls
PARENT.fu_Disable( )

dw_attachment_list.SetRedraw( TRUE )
	
	

end event

type dw_attachment_list from u_dw_std within u_tabpage_case_attachments
event ue_selecttrigger pbm_dwnkey
integer x = 14
integer y = 12
integer width = 3497
integer taborder = 10
string dataobject = "d_attachment_list"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;/*****************************************************************************************
   Event:      ue_SelectTrigger
   Purpose:    Open the attachment if the user presses enter while on the row

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/28/2002 K. Claver   Created
*****************************************************************************************/
Integer l_nRow, l_nConfidLevel

// if the user pressed the enter key while on a row, process it.
IF ( key = KeyEnter! ) AND ( THIS.GetRow( ) > 0 ) THEN
	
	// Get the selected row
	l_nRow = THIS.GetRow( )
	
	IF l_nRow > 0 THEN
		l_nConfidLevel = THIS.Object.confidentiality_level[ l_nRow ]
			
		IF l_nConfidLevel <= i_wParentWindow.i_nRepConfidLevel OR IsNull( l_nConfidLevel ) THEN
			PARENT.Event Trigger ue_OpenAttachment( l_nRow )
		END IF
	END IF
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_SetOptions
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Created.
*****************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  THIS.c_NullDW, &
						  THIS.c_NoRetrieveOnOpen+ &
						  THIS.c_SelectOnRowFocusChange+ &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_DeleteOK+ &
						  THIS.c_ModifyOK+ &
						  THIS.c_NoMenuButtonActivation+ &
						  THIS.c_SortClickedOK )
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_Retrieve
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Added code to retrieve the datawindow.
*****************************************************************************************/
IF THIS.Retrieve( i_wParentWindow.i_cCurrentCase, i_wParentWindow.i_nRepConfidLevel ) > 0 THEN
//	st_noattachments.Visible = FALSE
	cb_delete.Enabled = TRUE
	cb_save.Enabled = TRUE
	cb_edit.Enabled = TRUE
	cb_open.Enabled = TRUE
ELSE
//	st_noattachments.Visible = TRUE
	cb_delete.Enabled = FALSE	
	cb_save.Enabled = FALSE
	cb_edit.Enabled = FALSE
	cb_open.Enabled = FALSE
END IF
end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Added call to event to open the attachment.
*****************************************************************************************/
Integer l_nConfidLevel

IF row > 0 THEN
	l_nConfidLevel = THIS.Object.confidentiality_level[ row ]
		
	IF l_nConfidLevel <= i_wParentWindow.i_nRepConfidLevel OR IsNull( l_nConfidLevel ) THEN
		PARENT.Event Trigger ue_OpenAttachment( row )
	END IF
END IF
end event

event pcd_pickedrow;call super::pcd_pickedrow;/*****************************************************************************************
   Event:      pcd_pickedrow
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/5/2001 K. Claver   Added function call to the function to enable/disable the controls
								 based on the selected row and/or security.
*****************************************************************************************/
PARENT.fu_Disable( )
end event

