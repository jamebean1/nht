$PBExportHeader$u_tabpage_options_file_locs.sru
$PBExportComments$Carve Out Options preferences tab
forward
global type u_tabpage_options_file_locs from u_container_std
end type
type cb_browse from commandbutton within u_tabpage_options_file_locs
end type
type sle_custom_location from singlelineedit within u_tabpage_options_file_locs
end type
type sle_forms_location from singlelineedit within u_tabpage_options_file_locs
end type
type sle_iim_location from singlelineedit within u_tabpage_options_file_locs
end type
type gb_iim_location from groupbox within u_tabpage_options_file_locs
end type
type gb_forms_location from groupbox within u_tabpage_options_file_locs
end type
type gb_custom_location from groupbox within u_tabpage_options_file_locs
end type
end forward

global type u_tabpage_options_file_locs from u_container_std
integer width = 1929
integer height = 1560
boolean border = false
string text = "File(PBL) Locations"
event ue_initpage ( )
event ue_savepage ( )
cb_browse cb_browse
sle_custom_location sle_custom_location
sle_forms_location sle_forms_location
sle_iim_location sle_iim_location
gb_iim_location gb_iim_location
gb_forms_location gb_forms_location
gb_custom_location gb_custom_location
end type
global u_tabpage_options_file_locs u_tabpage_options_file_locs

type variables
BOOLEAN				i_bFirstOpen

STRING				i_cAvailabilityValues[16]

W_SYSTEM_OPTIONS	i_wParentWindow

GraphicObject     i_goControl
end variables

event ue_initpage;/*****************************************************************************************
   Function:   ue_initpage
   Purpose:    Initialize the interface for this page.
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver    Created
*****************************************************************************************/

INTEGER		l_nRow, l_nMaxRows
STRING		l_cOption, l_cValue

IF i_bFirstOpen THEN	
	i_bFirstOpen = FALSE
	
	l_nMaxRows = i_wParentWindow.i_dsOptions.RowCount ()
	FOR l_nRow = 1 TO l_nMaxRows		
		l_cOption = Upper (i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_name'))
		
		IF l_cOption = 'IIM_PBL_LOCATION' THEN
			l_cValue = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')
			sle_iim_location.Text = l_cValue
		ELSEIF l_cOption = 'FORMS_PBL_LOCATION' THEN
			l_cValue = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')
			sle_forms_location.Text = l_cValue
		ELSEIF l_cOption = 'CUSTOM_PBL_LOCATION' THEN
			l_cValue = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')
			sle_custom_location.Text = l_cValue
		END IF
	NEXT
END IF
end event

event ue_savepage;/*****************************************************************************************
   Function:   ue_savepage
   Purpose:    Save the options on the interface for this page.
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Created.
	01/31/02 M. Caruso    Only process if the other tabs have saved successfully.
*****************************************************************************************/
Integer l_nRow, l_nMaxRows
String l_cValue, l_cOption


IF NOT i_wParentWindow.i_bSaveFailed THEN

	l_nMaxRows = i_wParentWindow.i_dsOptions.RowCount( )
	FOR l_nRow = 1 TO l_nMaxRows	
		l_cOption = Upper( i_wParentWindow.i_dsOptions.GetItemString( l_nRow, 'option_name' ) )
		
		IF l_cOption = 'IIM_PBL_LOCATION' THEN
			l_cValue = Trim( sle_iim_location.Text )
			i_wParentWindow.i_dsOptions.SetItem( l_nRow, 'option_value', l_cValue )
		ELSEIF l_cOption = 'FORMS_PBL_LOCATION' THEN
			l_cValue = Trim( sle_forms_location.Text )
			i_wParentWindow.i_dsOptions.SetItem( l_nRow, 'option_value', l_cValue )
		ELSEIF l_cOption = 'CUSTOM_PBL_LOCATION' THEN
			l_cValue = Trim( sle_custom_location.Text )
			i_wParentWindow.i_dsOptions.SetItem( l_nRow, 'option_value', l_cValue )
		END IF
	NEXT
			
	i_wParentWindow.i_bSaveFailed = FALSE
	i_wParentWindow.i_bCloseWindow = TRUE
	
END IF
end event

on u_tabpage_options_file_locs.create
int iCurrent
call super::create
this.cb_browse=create cb_browse
this.sle_custom_location=create sle_custom_location
this.sle_forms_location=create sle_forms_location
this.sle_iim_location=create sle_iim_location
this.gb_iim_location=create gb_iim_location
this.gb_forms_location=create gb_forms_location
this.gb_custom_location=create gb_custom_location
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_browse
this.Control[iCurrent+2]=this.sle_custom_location
this.Control[iCurrent+3]=this.sle_forms_location
this.Control[iCurrent+4]=this.sle_iim_location
this.Control[iCurrent+5]=this.gb_iim_location
this.Control[iCurrent+6]=this.gb_forms_location
this.Control[iCurrent+7]=this.gb_custom_location
end on

on u_tabpage_options_file_locs.destroy
call super::destroy
destroy(this.cb_browse)
destroy(this.sle_custom_location)
destroy(this.sle_forms_location)
destroy(this.sle_iim_location)
destroy(this.gb_iim_location)
destroy(this.gb_forms_location)
destroy(this.gb_custom_location)
end on

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_setvariables
   Purpose:    initialize instance variables for this page.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/08/00 M. Caruso    Created.
*****************************************************************************************/

i_bFirstOpen = TRUE

i_wParentWindow = w_system_options
end event

type cb_browse from commandbutton within u_tabpage_options_file_locs
integer x = 1454
integer y = 1424
integer width = 411
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Browse"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/12/2001 K. Claver  Added code to allow the user to browse and populate the single line
								 edit control that has focus.
*****************************************************************************************/
SingleLineEdit l_sleLocation
String l_cFileName, l_cFileNamePath, l_cCurrPath, l_cTitleAdd
Integer l_nRV
n_cst_kernel32 l_uoKernelFuncs

IF IsValid( i_goControl ) THEN
	IF TypeOf( i_goControl ) = SingleLineEdit! THEN
		l_cCurrPath = l_uoKernelFuncs.of_GetCurrentDirectory( )
		
		//Set the local control variable to the control that had focus
		l_sleLocation = i_goControl
		
		//Create a more valid title for the file selection dialog
		CHOOSE CASE Upper( l_sleLocation.ClassName( ) )
			CASE "SLE_CUSTOM_LOCATION"
				l_cTitleAdd = " - Custom Reports File"
			CASE "SLE_FORMS_LOCATION"
				l_cTitleAdd = " - Case Form Templates File"
			CASE "SLE_IIM_LOCATION"
				l_cTitleAdd = " - IIM Tab File"
			CASE ELSE
				l_cTitleAdd = ""
		END CHOOSE
	
		//Open the file selection dialog
		l_nRV = GetFileOpenName( ( "Choose File"+l_cTitleAdd ), &
										 l_cFileNamePath, &
										 l_cFileName, &
										 "pbl", &
										 "Report Libraries (*.pbl),*.pbl,"+ &
										 "All Files (*.*),*.*" )
		
		//If the user chose OK, then set the path in the edit that had focus.
		IF l_nRV = 1 THEN
			l_sleLocation.SetFocus( )
			l_sleLocation.Text = l_cFileNamePath
		END IF	
		
		l_uoKernelFuncs.of_ChangeDirectory( l_cCurrPath )
	END IF
ELSE
	MessageBox( gs_AppName, "Please select a location field to browse for" )
END IF
end event

type sle_custom_location from singlelineedit within u_tabpage_options_file_locs
boolean visible = false
integer x = 78
integer y = 628
integer width = 1742
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 150
borderstyle borderstyle = stylelowered!
end type

event getfocus;/*****************************************************************************************
   Event:      getfocus
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/12/2001 K. Claver  Added code to keep track of the last single line edit that had focus.
*****************************************************************************************/
PARENT.i_goControl = THIS
end event

type sle_forms_location from singlelineedit within u_tabpage_options_file_locs
integer x = 78
integer y = 372
integer width = 1742
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 150
borderstyle borderstyle = stylelowered!
end type

event getfocus;/*****************************************************************************************
   Event:      getfocus
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/12/2001 K. Claver  Added code to keep track of the last single line edit that had focus.
*****************************************************************************************/
PARENT.i_goControl = THIS
end event

type sle_iim_location from singlelineedit within u_tabpage_options_file_locs
integer x = 78
integer y = 116
integer width = 1742
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 150
borderstyle borderstyle = stylelowered!
end type

event getfocus;/*****************************************************************************************
   Event:      getfocus
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/12/2001 K. Claver  Added code to keep track of the last single line edit that had focus.
*****************************************************************************************/
PARENT.i_goControl = THIS
end event

type gb_iim_location from groupbox within u_tabpage_options_file_locs
integer x = 32
integer y = 32
integer width = 1833
integer height = 220
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "IIM Tabs"
borderstyle borderstyle = stylelowered!
end type

type gb_forms_location from groupbox within u_tabpage_options_file_locs
integer x = 32
integer y = 288
integer width = 1833
integer height = 220
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Form Templates"
borderstyle borderstyle = stylelowered!
end type

type gb_custom_location from groupbox within u_tabpage_options_file_locs
boolean visible = false
integer x = 32
integer y = 544
integer width = 1833
integer height = 220
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Custom Reports"
borderstyle borderstyle = stylelowered!
end type

