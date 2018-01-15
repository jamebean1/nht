$PBExportHeader$w_filenet_attachment.srw
forward
global type w_filenet_attachment from w_response_std
end type
type dw_filenet_results from u_dw_std within w_filenet_attachment
end type
type cb_attach from commandbutton within w_filenet_attachment
end type
type p_1 from picture within w_filenet_attachment
end type
type st_3 from statictext within w_filenet_attachment
end type
type st_1 from statictext within w_filenet_attachment
end type
type cb_cancel from commandbutton within w_filenet_attachment
end type
type cb_search from commandbutton within w_filenet_attachment
end type
type ln_1 from line within w_filenet_attachment
end type
type ln_2 from line within w_filenet_attachment
end type
type ln_3 from line within w_filenet_attachment
end type
type ln_4 from line within w_filenet_attachment
end type
type dw_filenet_search from u_dw_std within w_filenet_attachment
end type
type st_2 from statictext within w_filenet_attachment
end type
end forward

global type w_filenet_attachment from w_response_std
integer width = 2377
integer height = 1840
string title = "Add/Edit Case Attachment"
dw_filenet_results dw_filenet_results
cb_attach cb_attach
p_1 p_1
st_3 st_3
st_1 st_1
cb_cancel cb_cancel
cb_search cb_search
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
dw_filenet_search dw_filenet_search
st_2 st_2
end type
global w_filenet_attachment w_filenet_attachment

type variables
Long i_nAttachmentKey
DataStore i_dsAttachmentTypes
end variables

on w_filenet_attachment.create
int iCurrent
call super::create
this.dw_filenet_results=create dw_filenet_results
this.cb_attach=create cb_attach
this.p_1=create p_1
this.st_3=create st_3
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_search=create cb_search
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.dw_filenet_search=create dw_filenet_search
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_filenet_results
this.Control[iCurrent+2]=this.cb_attach
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_search
this.Control[iCurrent+8]=this.ln_1
this.Control[iCurrent+9]=this.ln_2
this.Control[iCurrent+10]=this.ln_3
this.Control[iCurrent+11]=this.ln_4
this.Control[iCurrent+12]=this.dw_filenet_search
this.Control[iCurrent+13]=this.st_2
end on

on w_filenet_attachment.destroy
call super::destroy
destroy(this.dw_filenet_results)
destroy(this.cb_attach)
destroy(this.p_1)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_search)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.dw_filenet_search)
destroy(this.st_2)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    Please see PowerClass documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Added code to set the values for the objects if there is text passed
								 to the window.  Essentially putting into edit mode.
	8/17/2004 K. Claver   Added code to create the attachment types datastore
*****************************************************************************************/
i_nAttachmentKey = Long( Message.StringParm )

dw_filenet_search.InsertRow(0)
end event

type dw_filenet_results from u_dw_std within w_filenet_attachment
integer x = 9
integer y = 800
integer width = 2345
integer height = 732
integer taborder = 10
string dataobject = "d_filenet_results"
boolean vscrollbar = true
boolean border = false
end type

event buttonclicked;call super::buttonclicked;///*****************************************************************************************
//   Event:      buttonclicked
//   Purpose:    Please see PB documentation for this event.
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	11/30/2001 K. Claver  Added code to get the file name and path
//	8/17/2004  K. Claver  Added code to build the filter string from the attachment types
//								 defined in table maintenance
//*****************************************************************************************/
//String l_cFilter, l_cFileNamePath, l_cFileName, l_cDesc, l_cExt, l_cActive
//Integer l_nRV, l_nTypeRowCount, l_nTypeIndex, l_nNotActive = 0
//
//IF dwo.Name = "b_browse" THEN
//	l_nTypeRowCount = i_dsAttachmentTypes.RowCount( )
//	
//	IF l_nTypeRowCount > 0 THEN
//		//Build the filter list
//		FOR l_nTypeIndex = 1 TO l_nTypeRowCount
//			l_cDesc = i_dsAttachmentTypes.Object.type_desc[ l_nTypeIndex ]
//			l_cExt = i_dsAttachmentTypes.Object.type_extension[ l_nTypeIndex ]
//			l_cActive = i_dsAttachmentTypes.Object.type_active[ l_nTypeIndex ]
//			
//			IF l_cActive = 'Y' THEN
//				l_cFilter += ( l_cDesc+",*."+l_cExt+"," )
//			ELSE
//				l_nNotActive ++
//			END IF
//		NEXT
//		
//		IF l_nNotActive = l_nTypeRowCount THEN
//			//Default to all(*.*)
//			l_cFilter = "All Files(*.*),*.*"
//		ELSE
//			//Remove the trailing comma
//			l_cFilter = Left( l_cFilter, ( Len( l_cFilter ) - 1 ) ) 
//		END IF
//		
//		/*l_cFilter = "All Files(*.*),*.*,"+ &
//					"MS Word Documents(*.doc),*.doc,"+ &
//					"MS Excel Spreadsheets(*.xls),*.xls,"+ &
//					"MS PowerPoint Presentations(*.ppt),*.ppt,"+ &
//					"Text Files(*.txt),*.txt"*/
//	ELSE
//		//Default to all(*.*)
//		l_cFilter = "All Files(*.*),*.*"
//	END IF
//	
//	//JWhite 7.15.2006 - Added the '2' as an option as the migration from PB7 to PB9, the application was forgetting the last
//	// directory the user picked and always going to the CustomerFocus install directory.
//	l_nRV = GetFileOpenName( "Add Case Attachment", l_cFileNamePath, l_cFileName, "", l_cFilter, '', 2 )
//										
//	IF l_nRV = 1 THEN
//		THIS.Object.attachment_name[ 1 ] = l_cFileNamePath
//	END IF
//END IF
end event

event pcd_retrieve;call super::pcd_retrieve;///*****************************************************************************************
//   Event:      pcd_retrieve
//   Purpose:    Please see PowerClass documentation for this event.
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	11/30/2001 K. Claver  Added function call to retrieve the datawindow.
//*****************************************************************************************/
//THIS.Retrieve( PARENT.i_nAttachmentKey )
end event

event pcd_setoptions;call super::pcd_setoptions;///*****************************************************************************************
//   Event:      pcd_setoptions
//   Purpose:    Please see PowerClass documentation for this event.
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	11/30/2001 K. Claver  Added call to fu_setoptions to set the options for the
//								 datawindow.
//*****************************************************************************************/
//THIS.fu_SetOptions( SQLCA, &
//						  THIS.c_NullDW, &
//						  THIS.c_ModifyOK+ &
//						  THIS.c_NewOK+ &
//						  THIS.c_ModifyOnOpen+ &
//						  THIS.c_NoShowEmpty+ &
//						  THIS.c_NoMenuButtonActivation+ &
//						  THIS.c_NoEnablePopup+ &
//						  THIS.c_NoRetrieveOnOpen )
//
////If an attachment key was passed in, edit mode.
//IF PARENT.i_nAttachmentKey <> 0 THEN
//	THIS.fu_Retrieve( dw_case_attachment.c_IgnoreChanges, &
//							dw_case_attachment.c_NoReselectRows )
//	
//	THIS.Object.attachment_name.Edit.DisplayOnly = "Yes"
//	THIS.Object.attachment_name.Background.Color = "80269524"
//	THIS.Object.b_browse.SuppressEventProcessing = "Yes"
//	THIS.SetColumn( "confidentiality_level" )
//ELSE
//	THIS.fu_Insert( 0, 1 )
//END IF
end event

type cb_attach from commandbutton within w_filenet_attachment
integer x = 55
integer y = 1604
integer width = 352
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Attach"
end type

event clicked;///*****************************************************************************************
//   Event:      clicked
//   Purpose:    Please see PB documentation for this event.
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	11/30/2001 K. Claver  Check the file name and path before closing.
//	8/18/2004  K. Claver  Added code to validate the file extension and size if any are 
//								 defined via table maintenance.
//*****************************************************************************************/
//Integer l_nIndex, l_nRV, l_nConfidLevel, l_nMessageRV, l_nAttTypeCount, l_nExtStart
//Integer l_nValidExtFound = 0, l_nAllExt = 0, l_nSetRow, l_nBytesExceeded
//ULong l_nByteLimit
//String l_cFileChar, l_cFileNamePath, l_cFilePath, l_cFileName, l_cInfo, l_cDesc, l_cConfidLevel
//String l_cFileExt, l_cSetLimit
//Double l_dblFileSize
//n_cst_kernel32 l_uoKernelFuncs
//
//dw_case_attachment.AcceptText( )
//
//l_cFileNamePath = dw_case_attachment.Object.attachment_name[ 1 ]
//
////If there is information in the Message.StringParm, the window was opened for editing.
//IF Trim( Message.StringParm ) = "" THEN
//	//Check if file is valid
//	IF NOT FileExists( l_cFileNamePath ) OR IsNull( FileExists( l_cFileNamePath ) ) THEN
//		MessageBox( gs_AppName, "Invalid File name or path", StopSign!, OK! )
//	ELSE
//		//Trim off the file name so can verify directory
//		FOR l_nIndex = Len( l_cFileNamePath ) TO 1 STEP -1
//			l_cFileChar = Mid( l_cFileNamePath, l_nIndex, 1 )
//		
//			IF l_cFileChar = "\" THEN
//				l_cFilePath = Mid( l_cFileNamePath, 1, ( l_nIndex - 1 ) )
//				l_cFileName = Mid( l_cFileNamePath, ( l_nIndex + 1 ) )
//				
//				EXIT
//			END IF
//		NEXT
//		
//		//Check for a valid extension(* TAKES PRECEDENCE)
//		l_nAttTypeCount = i_dsAttachmentTypes.RowCount( )
//		
//		IF l_nAttTypeCount > 0 THEN 
//			l_nAllExt = i_dsAttachmentTypes.Find( "trim(type_extension) = '*' and type_active = 'Y'", 1, l_nAttTypeCount )
//			
//			//Get the extension of the file
//			l_nExtStart = Pos( l_cFileName, "." )
//			
//			IF l_nExtStart > 0 THEN
//				l_cFileExt = Mid( l_cFileName, ( l_nExtStart + 1 ) )
//			END IF
//			
//			IF l_nAllExt = 0 THEN
//				//If has an extension, check if defined
//				IF l_nExtStart > 0 THEN
//					l_nValidExtFound = i_dsAttachmentTypes.Find( "upper(trim(type_extension)) = upper(trim('"+l_cFileExt+"')) and type_active = 'Y'", 1, l_nAttTypeCount ) 
//				END IF
//			ELSE
//				//If found "*" extension, allow any file
//				l_nValidExtFound = 1
//			END IF
//		ELSE
//			//Default to *.* as there are none defined
//			l_nValidExtFound = 1
//		END IF
//		
//		//Check if a byte limit is set(EXTENSION TAKES PRECEDENCE)
//		IF l_nValidExtFound = 1 THEN
//			//Get the size of the file
//			l_dblFileSize = l_uoKernelFuncs.of_GetFileSize( l_cFileNamePath )
//			
//			//If have extension, look for a size set for that extension, otherwise
//			//  look for a size limit on *
//			IF NOT IsNull( l_cFileExt ) AND Trim( l_cFileExt ) <> "" THEN
//				l_nSetRow = i_dsAttachmentTypes.Find( "upper(trim(type_extension)) = upper(trim('"+l_cFileExt+"')) and type_active = 'Y'", 1, l_nAttTypeCount ) 
//				
//				//Even though the file has an extension, it may not be defined.  If so, see if "*" is.
//				IF l_nSetRow < 1 THEN
//					l_nSetRow = l_nAllExt
//				END IF
//			ELSEIF l_nAllExt > 0 THEN
//				l_nSetRow = l_nAllExt
//			END IF
//			
//			IF l_nSetRow > 0 THEN
//				l_cSetLimit = i_dsAttachmentTypes.Object.type_set_limit[ l_nSetRow ]
//				
//				IF l_cSetLimit = "Y" THEN
//					l_nByteLimit = i_dsAttachmentTypes.Object.type_byte_limit[ l_nSetRow ]
//					
//					IF l_nByteLimit < l_dblFileSize THEN
//						l_nBytesExceeded = 1
//					END IF
//				END IF
//			END IF
//		END IF
//		
//		
//		//Check if a valid extension
//		IF l_nValidExtFound < 1  THEN
//			MessageBox( gs_AppName, "File extension is not valid.  Please contact your system~r~n"+ &
//											"administrator if you need to attach files of this type", StopSign!, OK! )
//		ELSE
//			IF l_nBytesExceeded = 1 THEN
//				MessageBox( gs_AppName, "File size is too large.  Please contact your system~r~n"+ &
//											"administrator if you need to attach files of this size", StopSign!, OK! )			
//			ELSE
//				//Check if file name is too long
//				IF Len( Trim( l_cFileName ) ) > 200 THEN
//					MessageBox( gs_AppName, "File name cannot exceed 200 characters", StopSign!, OK! )
//				ELSE	
//					//Check if valid path
//					IF NOT l_uoKernelFuncs.of_DirectoryExists( l_cFilePath ) THEN
//						MessageBox( gs_AppName, "Directory does not exist", StopSign!, OK! )
//					ELSE
//						l_cDesc = dw_case_attachment.Object.attachment_desc[ 1 ]
//						
//						IF Len( Trim( l_cDesc ) ) > 255 THEN
//							MessageBox( gs_AppName, "Description cannot exceed 255 characters", StopSign!, OK! )
//						ELSE	
//							IF l_cDesc = "" OR IsNull( l_cDesc ) THEN
//								l_cDesc = "NULL"
//							END IF
//							
//							l_nConfidLevel = dw_case_attachment.Object.confidentiality_level[ 1 ]
//							
//							IF l_nConfidLevel = 0 OR IsNull( l_nConfidLevel ) THEN
//								l_cConfidLevel = "NULL"
//							ELSE
//								l_cConfidLevel = String( l_nConfidLevel )
//							END IF
//							
//							//Check if the confid level is higher than the rep confid level.  If so, 
//							//  prompt the user before doing this.
//							IF l_nConfidLevel > w_create_maintain_case.i_nRepConfidLevel AND NOT IsNull( l_nConfidLevel ) THEN
//								MessageBox( gs_AppName, "You cannot set the security level of this attachment~r~n"+ &
//												"higher than your own security level", StopSign!, OK! )
//								RETURN
//							END IF
//							
//							//Concatenate the info
//							l_cInfo = ( l_cFileName+"||"+l_cFileNamePath+"||"+l_cDesc+"||"+l_cConfidLevel )
//							
//							//Reset the datawindow so doesn't attempt to save
//							dw_case_attachment.fu_ResetUpdate( )
//							
//							//Close the window and pass back the info.
//							CloseWithReturn( PARENT, l_cInfo )
//						END IF
//					END IF
//				END IF
//			END IF
//		END IF
//	END IF
//ELSE
//	l_cDesc = dw_case_attachment.Object.attachment_desc[ 1 ] 
//	
//	IF Len( Trim( l_cDesc ) ) > 255 THEN
//		MessageBox( gs_AppName, "Description cannot exceed 255 characters", StopSign!, OK! )
//	ELSE
//		//Check if the confid level is higher than the rep confid level.  If so, 
//		//  prompt the user before doing this.
//		l_nConfidLevel = dw_case_attachment.Object.confidentiality_level[ 1 ]
//		IF l_nConfidLevel > w_create_maintain_case.i_nRepConfidLevel AND NOT IsNull( l_nConfidLevel ) THEN
//			MessageBox( gs_AppName, "You cannot set the security level of this attachment~r~n"+ &
//							"higher than your own security level", StopSign!, OK! )
//			RETURN
//		END IF
//		
//		//Set the updated by and time
//		dw_case_attachment.Object.updated_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
//		dw_case_attachment.Object.updated_timestamp[ 1 ] = PARENT.fw_GetTimestamp( )
//		
//		l_nRV = dw_case_attachment.fu_Save( dw_case_attachment.c_IgnoreChanges )
//		
//		IF l_nRV <> 0 THEN
//			MessageBox( gs_AppName, "Unable to save the changes to the attachment", StopSign!, OK! )
//		ELSE
//			Close( PARENT )
//		END IF
//	END IF
//END IF
//		
//	
end event

type p_1 from picture within w_filenet_attachment
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_3 from statictext within w_filenet_attachment
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
string text = "Attach a FileNet Image"
boolean focusrectangle = false
end type

type st_1 from statictext within w_filenet_attachment
integer width = 2354
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

type cb_cancel from commandbutton within w_filenet_attachment
integer x = 1970
integer y = 1604
integer width = 352
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Added code to close the window and return the cancel code.
*****************************************************************************************/
CloseWithReturn( PARENT, "CNCL" )
end event

type cb_search from commandbutton within w_filenet_attachment
integer x = 462
integer y = 1604
integer width = 352
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Search"
end type

event clicked;		MessageBox( gs_AppName, "FileNet is not configured for this installation", StopSign!, OK! )

end event

type ln_1 from line within w_filenet_attachment
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1560
integer endx = 2400
integer endy = 1560
end type

type ln_2 from line within w_filenet_attachment
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1556
integer endx = 2400
integer endy = 1556
end type

type ln_3 from line within w_filenet_attachment
long linecolor = 16777215
integer linethickness = 4
integer beginy = 172
integer endx = 2400
integer endy = 172
end type

type ln_4 from line within w_filenet_attachment
long linecolor = 8421504
integer linethickness = 4
integer beginy = 168
integer endx = 2400
integer endy = 168
end type

type dw_filenet_search from u_dw_std within w_filenet_attachment
integer x = 9
integer y = 192
integer width = 1851
integer height = 552
integer taborder = 10
string dataobject = "d_filenet_search"
boolean border = false
end type

event buttonclicked;call super::buttonclicked;///*****************************************************************************************
//   Event:      buttonclicked
//   Purpose:    Please see PB documentation for this event.
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	11/30/2001 K. Claver  Added code to get the file name and path
//	8/17/2004  K. Claver  Added code to build the filter string from the attachment types
//								 defined in table maintenance
//*****************************************************************************************/
//String l_cFilter, l_cFileNamePath, l_cFileName, l_cDesc, l_cExt, l_cActive
//Integer l_nRV, l_nTypeRowCount, l_nTypeIndex, l_nNotActive = 0
//
//IF dwo.Name = "b_browse" THEN
//	l_nTypeRowCount = i_dsAttachmentTypes.RowCount( )
//	
//	IF l_nTypeRowCount > 0 THEN
//		//Build the filter list
//		FOR l_nTypeIndex = 1 TO l_nTypeRowCount
//			l_cDesc = i_dsAttachmentTypes.Object.type_desc[ l_nTypeIndex ]
//			l_cExt = i_dsAttachmentTypes.Object.type_extension[ l_nTypeIndex ]
//			l_cActive = i_dsAttachmentTypes.Object.type_active[ l_nTypeIndex ]
//			
//			IF l_cActive = 'Y' THEN
//				l_cFilter += ( l_cDesc+",*."+l_cExt+"," )
//			ELSE
//				l_nNotActive ++
//			END IF
//		NEXT
//		
//		IF l_nNotActive = l_nTypeRowCount THEN
//			//Default to all(*.*)
//			l_cFilter = "All Files(*.*),*.*"
//		ELSE
//			//Remove the trailing comma
//			l_cFilter = Left( l_cFilter, ( Len( l_cFilter ) - 1 ) ) 
//		END IF
//		
//		/*l_cFilter = "All Files(*.*),*.*,"+ &
//					"MS Word Documents(*.doc),*.doc,"+ &
//					"MS Excel Spreadsheets(*.xls),*.xls,"+ &
//					"MS PowerPoint Presentations(*.ppt),*.ppt,"+ &
//					"Text Files(*.txt),*.txt"*/
//	ELSE
//		//Default to all(*.*)
//		l_cFilter = "All Files(*.*),*.*"
//	END IF
//	
//	//JWhite 7.15.2006 - Added the '2' as an option as the migration from PB7 to PB9, the application was forgetting the last
//	// directory the user picked and always going to the CustomerFocus install directory.
//	l_nRV = GetFileOpenName( "Add Case Attachment", l_cFileNamePath, l_cFileName, "", l_cFilter, '', 2 )
//										
//	IF l_nRV = 1 THEN
//		THIS.Object.attachment_name[ 1 ] = l_cFileNamePath
//	END IF
//END IF
end event

event pcd_setoptions;call super::pcd_setoptions;///*****************************************************************************************
//   Event:      pcd_setoptions
//   Purpose:    Please see PowerClass documentation for this event.
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	11/30/2001 K. Claver  Added call to fu_setoptions to set the options for the
//								 datawindow.
//*****************************************************************************************/
//THIS.fu_SetOptions( SQLCA, &
//						  THIS.c_NullDW, &
//						  THIS.c_ModifyOK+ &
//						  THIS.c_NewOK+ &
//						  THIS.c_ModifyOnOpen+ &
//						  THIS.c_NoShowEmpty+ &
//						  THIS.c_NoMenuButtonActivation+ &
//						  THIS.c_NoEnablePopup+ &
//						  THIS.c_NoRetrieveOnOpen )
//
////If an attachment key was passed in, edit mode.
//IF PARENT.i_nAttachmentKey <> 0 THEN
//	THIS.fu_Retrieve( dw_case_attachment.c_IgnoreChanges, &
//							dw_case_attachment.c_NoReselectRows )
//	
//	THIS.Object.attachment_name.Edit.DisplayOnly = "Yes"
//	THIS.Object.attachment_name.Background.Color = "80269524"
//	THIS.Object.b_browse.SuppressEventProcessing = "Yes"
//	THIS.SetColumn( "confidentiality_level" )
//ELSE
//	THIS.fu_Insert( 0, 1 )
//END IF
end event

event pcd_retrieve;call super::pcd_retrieve;///*****************************************************************************************
//   Event:      pcd_retrieve
//   Purpose:    Please see PowerClass documentation for this event.
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	11/30/2001 K. Claver  Added function call to retrieve the datawindow.
//*****************************************************************************************/
//THIS.Retrieve( PARENT.i_nAttachmentKey )
end event

type st_2 from statictext within w_filenet_attachment
integer x = 5
integer y = 1564
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

