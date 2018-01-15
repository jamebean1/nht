$PBExportHeader$u_contact_notes.sru
forward
global type u_contact_notes from u_container_std
end type
type cb_delete from commandbutton within u_contact_notes
end type
type cb_save from commandbutton within u_contact_notes
end type
type cb_edit from commandbutton within u_contact_notes
end type
type cb_new from commandbutton within u_contact_notes
end type
type st_note_list from statictext within u_contact_notes
end type
type dw_contact_note from u_dw_std within u_contact_notes
end type
type dw_contact_note_list from u_dw_std within u_contact_notes
end type
type gb_note from groupbox within u_contact_notes
end type
end forward

global type u_contact_notes from u_container_std
integer width = 3579
integer height = 1600
cb_delete cb_delete
cb_save cb_save
cb_edit cb_edit
cb_new cb_new
st_note_list st_note_list
dw_contact_note dw_contact_note
dw_contact_note_list dw_contact_note_list
gb_note gb_note
end type
global u_contact_notes u_contact_notes

type variables
STRING						i_cKeyValue, i_cNoteID, i_cLastSourceType
INTEGER						i_nRV

W_CREATE_MAINTAIN_CASE	i_wParentWindow
end variables

on u_contact_notes.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_save=create cb_save
this.cb_edit=create cb_edit
this.cb_new=create cb_new
this.st_note_list=create st_note_list
this.dw_contact_note=create dw_contact_note
this.dw_contact_note_list=create dw_contact_note_list
this.gb_note=create gb_note
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_save
this.Control[iCurrent+3]=this.cb_edit
this.Control[iCurrent+4]=this.cb_new
this.Control[iCurrent+5]=this.st_note_list
this.Control[iCurrent+6]=this.dw_contact_note
this.Control[iCurrent+7]=this.dw_contact_note_list
this.Control[iCurrent+8]=this.gb_note
end on

on u_contact_notes.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_save)
destroy(this.cb_edit)
destroy(this.cb_new)
destroy(this.st_note_list)
destroy(this.dw_contact_note)
destroy(this.dw_contact_note_list)
destroy(this.gb_note)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
	Event:	pc_setoptions
	Purpose:	Define the characteristics for the object

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/28/2000 K. Claver    Added code for resize.
	4/13/2001 K. Claver   Fixed the resize code.
******************************************************************************************/
Long l_nNewWidth, l_nNewHeight, l_nWidthOffset, l_nHeightOffset, l_nNewX, l_nNewY

THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	// calculate the resize ratio of the parent window from when it was created.
	IF i_wParentWindow.Width < 3579 THEN
		l_nWidthOffSet = 0
	ELSE
		l_nWidthOffSet = i_wParentWindow.Width - i_wParentWindow.i_nBaseWidth
	END IF
	
	IF i_wParentWindow.Height < 1600 THEN
		l_nHeightOffSet = 0
	ELSE
		l_nHeightOffSet = i_wParentWindow.Height - i_wParentWindow.i_nBaseHeight
	END IF
	
	// initialize the container and register it with the parent window.
	l_nNewHeight = 1600 + l_nHeightOffset 
	l_nNewWidth = 3579 + l_nWidthOffSet
	THIS.Resize( l_nNewWidth, l_nNewHeight )
	
	// initialize the contact note list datawindow.
	inv_resize.of_Register( dw_contact_note_list, inv_resize.SCALERIGHTBOTTOM )
	l_nNewHeight = dw_contact_note_list.Height + l_nHeightOffset
	l_nNewWidth = dw_contact_note_list.Width + l_nWidthOffset
	dw_contact_note_list.Resize( l_nNewWidth, l_nNewHeight )
	
	// initialize the contact note group box.
	inv_resize.of_Register( gb_note, inv_resize.FIXEDBOTTOM_SCALERIGHT )
	l_nNewX = gb_note.X
	l_nNewY = gb_note.Y + l_nHeightOffset
	l_nNewHeight = gb_note.Height
	l_nNewWidth = gb_note.Width + l_nWidthOffset
	gb_note.Resize( l_nNewWidth, l_nNewHeight )
	gb_note.Move( l_nNewX, l_nNewY )
	
	// initialize the contact note datawindow.
	inv_resize.of_Register( dw_contact_note, inv_resize.FIXEDBOTTOM_SCALERIGHT )
	l_nNewX = dw_contact_note.X
	l_nNewY = dw_contact_note.Y + l_nHeightOffset
	l_nNewHeight = dw_contact_note.Height
	l_nNewWidth = dw_contact_note.Width + l_nWidthOffset
	dw_contact_note.Resize( l_nNewWidth, l_nNewHeight )
	dw_contact_note.Move( l_nNewX, l_nNewY )
	dw_contact_note.Object.note_text.Width = String( ( Long( dw_contact_note.Object.note_text.Width ) + l_nWidthOffset ) )
	
	// initialize the buttons.
	inv_resize.of_Register( cb_delete, inv_resize.FIXEDRIGHTBOTTOM )
	l_nNewX = cb_delete.X + l_nWidthOffset
	l_nNewY = cb_delete.Y + l_nHeightOffset
	cb_delete.Move( l_nNewX, l_nNewY )
	
	inv_resize.of_Register( cb_save, inv_resize.FIXEDRIGHTBOTTOM )
	l_nNewX = cb_save.X + l_nWidthOffset
	l_nNewY = cb_save.Y + l_nHeightOffset
	cb_save.Move( l_nNewX, l_nNewY )
	
	inv_resize.of_Register( cb_edit, inv_resize.FIXEDRIGHTBOTTOM )
	l_nNewX = cb_edit.X + l_nWidthOffset
	l_nNewY = cb_edit.Y + l_nHeightOffset
	cb_edit.Move( l_nNewX, l_nNewY )
	
	inv_resize.of_Register( cb_new, inv_resize.FIXEDRIGHTBOTTOM )
	l_nNewX = cb_new.X + l_nWidthOffset
	l_nNewY = cb_new.Y + l_nHeightOffset
	cb_new.Move( l_nNewX, l_nNewY )
	
	//Register this object with the resize service
	i_wParentWindow.inv_resize.of_Register( THIS, inv_resize.SCALERIGHTBOTTOM )
	
	
//	THIS.inv_resize.of_Register( dw_contact_note_list, THIS.inv_resize.SCALERIGHTBOTTOM )
//	THIS.inv_resize.of_Register( dw_contact_note, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
//	THIS.inv_resize.of_Register( gb_note, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
//	THIS.inv_resize.of_Register( cb_delete, THIS.inv_resize.FIXEDRIGHTBOTTOM )
//	THIS.inv_resize.of_Register( cb_save, THIS.inv_resize.FIXEDRIGHTBOTTOM )
//	THIS.inv_resize.of_Register( cb_edit, THIS.inv_resize.FIXEDRIGHTBOTTOM )
//	THIS.inv_resize.of_Register( cb_new, THIS.inv_resize.FIXEDRIGHTBOTTOM )
END IF
end event

type cb_delete from commandbutton within u_contact_notes
integer x = 3122
integer y = 1444
integer width = 320
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

event clicked;/***************************************************************************************
	Event:	clicked
	Purpose:	Please see PB documentation for this event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/29/2000 K. Claver    Added code to ask the user if they would like to delete the
									record.  Delete if yes then select the first row in the notes
									list datawindow.
******************************************************************************************/
Integer l_nRows[ 1 ], l_nRV, l_nOption

//Disable the timer if delete a record.  If the refresh of the
//  list window returns rows, it will be re-activated.  Otherwise, 
//  the timer is not re-activated.
IF IsValid( w_create_maintain_case ) THEN
	Timer( 0, w_create_maintain_case )
END IF

IF dw_contact_note.RowCount( ) > 0 THEN
	l_nOption = MessageBox( gs_AppName, &
									"Are you sure you want to delete the selected note?", &
									Question!, &
									YesNo! )
									
	IF l_nOption = 1 THEN
		l_nRows[ 1 ] = 1
		
		l_nRV = dw_contact_note.fu_Delete( 1, &
													  l_nRows, &
													  dw_contact_note.c_IgnoreChanges )
													  
		IF l_nRV < 0 THEN
			Error.i_FWError = c_Fatal
		ELSE
			l_nRV = dw_contact_note.fu_Save( dw_contact_note.c_SaveChanges )
	
			IF l_nRV < 0 THEN
				Error.i_FWError = c_Fatal
			ELSE
				IF dw_contact_note_list.RowCount( ) > 0 THEN
					dw_contact_note_list.SelectRow( 0, FALSE )
					dw_contact_note_list.SelectRow( 1, TRUE )
					dw_contact_note_list.ScrollToRow( 1 )
				END IF
				
				dw_contact_note.fu_Retrieve( dw_contact_note.c_IgnoreChanges, &
													  dw_contact_note.c_NoReselectRows )		
													  
				dw_contact_note.Event Trigger ue_viewonly( )
			END IF
		END IF
	END IF
END IF


end event

type cb_save from commandbutton within u_contact_notes
integer x = 3122
integer y = 1304
integer width = 320
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save"
end type

event clicked;/***************************************************************************************
	Event:	clicked
	Purpose:	Please see PB documentation for dw_contact_note event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/29/2000 K. Claver    Call the function to save the changes and scroll to the new row
******************************************************************************************/
Integer l_nRow[ ], l_nRV
String l_cNoteID, l_cNoteText, l_cNotePriority
Boolean l_bReselectDetails = FALSE

dw_contact_note.AcceptText( )

l_nRV = dw_contact_note.fu_Save( dw_contact_note.c_SaveChanges )
	
IF l_nRV < 0 THEN
	Error.i_FWError = c_Fatal
ELSE
	IF dw_contact_note_list.RowCount( ) > 0 THEN
		l_nRow[ 1 ] = dw_contact_note_list.Find( "contact_note_id = '"+i_cNoteID+"'", &
															  1, &
															  dw_contact_note_list.RowCount( ) )
														
		IF l_nRow[ 1 ] = 0 THEN
			l_nRow[ 1 ] = 1
		END IF
		
		dw_contact_note_list.fu_SetSelectedRows( 1, &
															  l_nRow, &
															  dw_contact_note_list.c_IgnoreChanges, &
															  dw_contact_note_list.c_NoRefreshChildren )
		
		IF dw_contact_note.GetItemStatus( 1, 0, Primary! ) = New! THEN
			dw_contact_note.fu_Retrieve( dw_contact_note.c_IgnoreChanges, &
												  dw_contact_note.c_NoReselectRows )
		END IF
		
		dw_contact_note.Event Trigger ue_viewonly( )
		
		cb_new.Enabled = TRUE
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = TRUE
		cb_edit.Enabled = TRUE
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = TRUE
		cb_delete.Enabled = TRUE
		m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = TRUE
		THIS.Enabled = FALSE
		m_create_maintain_case.m_file.m_save.Enabled = FALSE
	END IF
END IF
end event

type cb_edit from commandbutton within u_contact_notes
integer x = 3122
integer y = 1004
integer width = 320
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Edit"
end type

event clicked;/***************************************************************************************
	Event:	clicked
	Purpose:	Please see PB documentation for this event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/29/2000 K. Claver    Added event call to put the datawindow into modify mode
******************************************************************************************/
dw_contact_note.Event Trigger ue_modify( )
end event

type cb_new from commandbutton within u_contact_notes
integer x = 3122
integer y = 864
integer width = 320
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
end type

event clicked;/*****************************************************************************************
	Event:	clicked
	Purpose:	Please see PB documentation for this event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/29/2000 K. Claver    Added function calls to reset the datawindow, put into modify
									mode and add a new row.
******************************************************************************************/
Integer l_nRV

dw_contact_note.AcceptText( )

l_nRV = dw_contact_note.fu_Reset( dw_contact_note.c_PromptChanges )

IF l_nRV = 0 THEN
	dw_contact_note.fu_New( 1 )
	dw_contact_note.Event Trigger ue_modify( )
END IF

dw_contact_note.SetFocus( )
end event

type st_note_list from statictext within u_contact_notes
integer x = 23
integer y = 4
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Note List:"
boolean focusrectangle = false
end type

type dw_contact_note from u_dw_std within u_contact_notes
event ue_modify ( )
event ue_viewonly ( )
event keydown pbm_dwnkey
integer x = 73
integer y = 748
integer width = 3035
integer height = 816
integer taborder = 20
string dataobject = "d_contact_note"
boolean border = false
end type

event ue_modify;/*****************************************************************************************
	Event:	ue_modify
	Purpose:	Enable modification of the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/30/2000 K. Claver    Original version.
******************************************************************************************/
THIS.Object.Datawindow.ReadOnly = 'No'
THIS.Object.note_priority.Protect = '0'
THIS.Object.note_text.Edit.DisplayOnly = 'No'
THIS.Object.note_priority.Background.Color = String( RGB( 255, 255, 255 ) )
THIS.Object.note_text.BackGround.Color = String( RGB( 255, 255, 255 ) )
THIS.SetColumn( 1 )
THIS.SetFocus( )
cb_edit.Enabled = FALSE
m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = FALSE
cb_delete.Enabled = FALSE
m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
cb_save.Enabled = TRUE
m_create_maintain_case.m_file.m_save.Enabled = TRUE
end event

event ue_viewonly;/*****************************************************************************************
	Event:	ue_viewonly
	Purpose:	Disable modification of the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/30/2000 K. Claver    Original version.
******************************************************************************************/
THIS.Object.Datawindow.ReadOnly = 'No'
THIS.Object.note_priority.Protect = '1'
THIS.Object.note_text.Edit.DisplayOnly = 'Yes'
THIS.Object.note_priority.Background.Color = '80269524'
THIS.Object.note_text.BackGround.Color = '80269524'
end event

event keydown;/*****************************************************************************************
   Event:      KeyDown
   Purpose:    Allow processing for hot keys.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
   01/26/07  RAP         Created.
*****************************************************************************************/
String ls_hotkey_text

CHOOSE CASE Key
		
	CASE KeyF1!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F1'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F1'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF2!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F2'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F2'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF3!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F3'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F3'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF4!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F4'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F4'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF5!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F5'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F5'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF6!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F6'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F6'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF7!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F7'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F7'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF8!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F8'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F8'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF9!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F9'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F9'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF10!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F10'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F10'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF11!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F11'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F11'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
	CASE KeyF12!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F12'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F12'
			USING SQLCA;
			THIS.object.note_text[THIS.GetRow()] = ls_hotkey_text
		END IF
END CHOOSE
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Define the characteristics for the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/28/2000 K. Claver    Original version.
******************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  dw_contact_note_list, & 
						  c_NoMenuButtonActivation+ &
						  c_NoEnablePopup+ &
						  c_DeleteOK+ &
						  c_NewOK+ &
						  c_NewModeOnEmpty+ &
						  c_ModifyOK+ &
						  c_ModifyOnOpen+ &
						  c_RefreshParent )
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "note_text", THIS.inv_resize.SCALERIGHT )
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
	Event:	pcd_retrieve
	Purpose:	Retrieve rows into the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/28/2000 K. Claver    Original version.
******************************************************************************************/
LONG l_nRtn 
STRING l_cSelected

SetPointer( Hourglass! )

l_cSelected = Parent_DW.GetItemString( selected_rows[ 1 ], "contact_note_id")

l_nRtn = THIS.Retrieve( l_cSelected )

IF l_nRtn < 0 THEN
   Error.i_FWError = c_Fatal
ELSEIF l_nRtn = 0 THEN
	THIS.fu_New( 1 )
	THIS.Event Post ue_modify( )
ELSE
	THIS.Event Post ue_viewonly( )
END IF

SetPointer( Arrow! )
end event

event pcd_validatebefore;call super::pcd_validatebefore;/***************************************************************************************
	Event:	pcd_ValidateBefore
	Purpose:	Please see PowerClass documentation for this event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/29/2000 K. Claver    Added code to populate the necessary fields before save
******************************************************************************************/
String l_cNotePriority, l_cNoteText

IF THIS.RowCount( ) > 0 THEN
	THIS.AcceptText( )
	
	l_cNotePriority = THIS.Object.note_priority[ 1 ]
	l_cNoteText = THIS.Object.note_text[ 1 ]
	
	IF IsNull( l_cNotePriority ) OR Trim( l_cNotePriority ) = "" THEN
		MessageBox( gs_AppName, "Please specify a note priority", Exclamation!, Ok! )
		Error.i_FWError = c_ValFailed
		i_wParentWindow.dw_folder.i_TabError = -1
		THIS.SetFocus( )
		THIS.SetColumn( 1 )
	ELSEIF IsNull( l_cNoteText ) OR Trim( l_cNoteText ) = "" THEN
		MessageBox( gs_AppName, "Please add a note", Exclamation!, Ok! )
		Error.i_FWError = c_ValFailed
		i_wParentWindow.dw_folder.i_TabError = -1
		THIS.SetFocus( )
		THIS.SetColumn( 2 )
	ELSE
		i_wParentWindow.dw_folder.i_TabError = 0
		
		CHOOSE CASE THIS.GetItemStatus( 1, 0, Primary! )
			CASE DataModified!
				i_cNoteID = THIS.Object.contact_note_id[ 1 ]
				THIS.Object.last_modified_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
				THIS.Object.last_modified_timestamp[ 1 ] = i_wParentWindow.fw_GetTimeStamp( )
			CASE NewModified!			
				i_cNoteID = i_wParentWindow.fw_GetKeyValue( "contact_notes" )
				
				THIS.Object.contact_note_id[ 1 ] = i_cNoteID
				THIS.Object.entered_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
				THIS.Object.entered_timestamp[ 1 ] = i_wParentWindow.fw_GetTimeStamp( )
				THIS.Object.last_viewed_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
				THIS.Object.last_viewed_timestamp[ 1 ] = i_wParentWindow.fw_GetTimeStamp( )
				
				CHOOSE CASE i_wParentWindow.i_cSourceType
					CASE i_wParentWindow.i_cSourceProvider
						THIS.Object.provider_key[ 1 ] = i_wParentWindow.i_nProviderKey
					CASE i_wParentWindow.i_cSourceEmployer
						THIS.Object.group_id[ 1 ] = i_cKeyValue
					CASE i_wParentWindow.i_cSourceConsumer
						THIS.Object.consumer_id[ 1 ] = i_cKeyValue
					CASE i_wParentWindow.i_cSourceOther
						THIS.Object.customer_id[ 1 ] = i_cKeyValue
				END CHOOSE
		END CHOOSE
	END IF
END IF
end event

event editchanged;call super::editchanged;long ll_length

ll_length = Len(data)

If ll_length > 3099 Then
	gn_globals.in_messagebox.of_messagebox('You have entered a note that is larger than the allowed maximum number of characters. You can save the note, but you may experience problems when viewing the note.', Information!, OK!, 1)
End If
end event

type dw_contact_note_list from u_dw_std within u_contact_notes
event ue_save ( integer a_nrow )
integer x = 23
integer y = 80
integer width = 3534
integer height = 612
integer taborder = 10
string dataobject = "d_contact_note_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_save;/*****************************************************************************************
	Event:	ue_save
	Purpose:	Save changes to the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/30/2000 K. Claver    Added code to modify the last viewed info and update.
******************************************************************************************/
Integer l_nRV

//Disable the timer once this event has occured
IF IsValid( w_create_maintain_case ) THEN
	Timer( 0, w_create_maintain_case )
END IF

THIS.Object.last_viewed_by[ a_nRow ] = OBJCA.WIN.fu_GetLogin( SQLCA )
THIS.Object.last_viewed_timestamp[ a_nRow ] = i_wParentWindow.fw_GetTimeStamp( )

//Use the update function here as fu_Save triggers a refresh of the datawindow
l_nRV = THIS.Update( )

IF l_nRV < 0 THEN
	Error.i_FWError = c_Fatal
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Define the characteristics for the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	11/28/2000 K. Claver    Original version.
******************************************************************************************/
THIS.fu_SetKey( "contact_note_id" )

THIS.fu_SetOptions( SQLCA, &
						  c_NullDW, & 
						  c_SelectOnRowFocusChange+ &
						  c_SortClickedOK+ &
						  c_NoMenuButtonActivation+ &
						  c_NoEnablePopup+ &
						  c_ViewOnSelect+ &
						  c_ModifyOK )
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "l_1", THIS.inv_resize.SCALERIGHT )
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/***************************************************************************************

			Event:	pcd_retrieve
			Purpose:	To retrieve the Case Notes data on the Source Type and Source
						Type ID
			
11/29/2000  K. Claver  Original Version.

**************************************************************************************/
String l_cUserID, l_cLastViewed
LONG l_nReturn

i_cKeyValue = i_wParentWindow.i_cCurrentCaseSubject
l_cUserID = OBJCA.WIN.fu_GetLogin( SQLCA )

//Retrieve based on Source Type and ID for the Source Type
CHOOSE CASE i_wParentWindow.i_cSourceType
	CASE i_wParentWindow.i_cSourceProvider
		l_nReturn = THIS.Retrieve( LONG(i_cKeyValue), "NA", "NA", "NA", l_cUserID )
	CASE i_wParentWindow.i_cSourceEmployer
		l_nReturn = THIS.Retrieve( 0, i_cKeyValue, "NA", "NA", l_cUserID )
	CASE i_wParentWindow.i_cSourceConsumer
		l_nReturn = THIS.Retrieve( 0, "NA", i_cKeyValue, "NA", l_cUserID )
	CASE i_wParentWindow.i_cSourceOther
		l_nReturn = THIS.Retrieve( 0, "NA", "NA", i_cKeyValue, l_cUserID )
END CHOOSE

IF l_nReturn < 0 THEN 
 	Error.i_FWError = c_Fatal
ELSEIF l_nReturn = 0 THEN
	cb_new.Event Post clicked( )
	cb_edit.Enabled = FALSE
	m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = FALSE
	cb_delete.Enabled = FALSE
	m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
	cb_save.Enabled = FALSE
	m_create_maintain_case.m_file.m_save.Enabled = FALSE
ELSE
	//Enable the timer to update the viewed by info and save showing
	//  that the current user viewed the first record.
	IF IsValid( w_create_maintain_case ) THEN
		//Check if the current user is different than the one that last
		//  viewed the note before activating the timer.
		l_cLastViewed = THIS.Object.last_viewed_by[ 1 ]
		IF Upper( l_cLastViewed ) <> Upper( l_cUserID ) THEN
			Timer( 3, w_create_maintain_case )
		END IF
	END IF
	
	cb_edit.Enabled = TRUE
	m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = TRUE
	cb_delete.Enabled = TRUE
	m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = TRUE
	cb_save.Enabled = FALSE
	m_create_maintain_case.m_file.m_save.Enabled = FALSE
END IF



end event

event clicked;call super::clicked;/*****************************************************************************************
	Event:	clicked
	Purpose:	Please see PB documentation for this event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	12/1/2000 K. Claver     Trigger the save event on the datawindow to show the note as
									viewed by the current user.
******************************************************************************************/
IF THIS.RowCount( ) > 0 AND row > 0 THEN
	THIS.Event Trigger ue_save( row )
	
	cb_edit.Enabled = TRUE
	m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = TRUE
	cb_delete.Enabled = TRUE
	m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = TRUE
	cb_save.Enabled = FALSE
	m_create_maintain_case.m_file.m_save.Enabled = FALSE
END IF
end event

type gb_note from groupbox within u_contact_notes
integer x = 23
integer y = 696
integer width = 3534
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
string text = "Note:"
end type

