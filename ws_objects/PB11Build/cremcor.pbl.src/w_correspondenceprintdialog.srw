$PBExportHeader$w_correspondenceprintdialog.srw
$PBExportComments$Print parameter dialog box for correspondence.
forward
global type w_correspondenceprintdialog from w_response_std
end type
type st_copycount_prompt from statictext within w_correspondenceprintdialog
end type
type em_copycount from editmask within w_correspondenceprintdialog
end type
type cb_cancel from u_cb_close within w_correspondenceprintdialog
end type
type cb_ok from u_cb_close within w_correspondenceprintdialog
end type
end forward

global type w_correspondenceprintdialog from w_response_std
integer width = 1312
integer height = 584
string title = "Select number of copies"
st_copycount_prompt st_copycount_prompt
em_copycount em_copycount
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_correspondenceprintdialog w_correspondenceprintdialog

type variables
INTEGER	i_nReturn
end variables

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_close
   Purpose:    Perform this before closing the window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/23/02 M. Caruso    Created.
*****************************************************************************************/

DOUBLE	l_nCopyCount

// inidicate if OK or Cancel was clicked
PCCA.Parm[1] = STRING (i_nReturn)

IF i_nReturn = -1 THEN
	
	// if the user pressed OK, set the copy count parameter
	em_copycount.GetData (l_nCopyCount)
	PCCA.Parm[2] = STRING (l_nCopyCount)
	
END IF
end event

on w_correspondenceprintdialog.create
int iCurrent
call super::create
this.st_copycount_prompt=create st_copycount_prompt
this.em_copycount=create em_copycount
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_copycount_prompt
this.Control[iCurrent+2]=this.em_copycount
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_ok
end on

on w_correspondenceprintdialog.destroy
call super::destroy
destroy(this.st_copycount_prompt)
destroy(this.em_copycount)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_setvariables
   Purpose:    Initialize window variables.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/23/02 M. Caruso    Created.
*****************************************************************************************/

// If the X box is clicked to close the window, this makes the window act as if the cancel
// button was clicked.
i_nReturn = 0
end event

type st_copycount_prompt from statictext within w_correspondenceprintdialog
integer x = 119
integer y = 140
integer width = 512
integer height = 64
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Number of copies:"
boolean focusrectangle = false
end type

type em_copycount from editmask within w_correspondenceprintdialog
integer x = 814
integer y = 128
integer width = 366
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "#"
boolean spin = true
string minmax = "1~~100"
end type

type cb_cancel from u_cb_close within w_correspondenceprintdialog
integer x = 832
integer y = 352
integer width = 411
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process this when the button is clicked.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/23/02 M. Caruso    Created.
*****************************************************************************************/

i_nReturn = 0

CALL super::clicked
end event

type cb_ok from u_cb_close within w_correspondenceprintdialog
integer x = 379
integer y = 352
integer width = 411
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process this when the button is clicked.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/23/02 M. Caruso    Created.
*****************************************************************************************/

i_nReturn = -1

CALL super::clicked
end event

