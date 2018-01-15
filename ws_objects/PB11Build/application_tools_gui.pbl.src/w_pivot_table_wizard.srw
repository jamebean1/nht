$PBExportHeader$w_pivot_table_wizard.srw
forward
global type w_pivot_table_wizard from w_basewindow
end type
type ln_1 from line within w_pivot_table_wizard
end type
type ln_2 from line within w_pivot_table_wizard
end type
type cb_cancel from u_commandbutton within w_pivot_table_wizard
end type
type ln_6 from line within w_pivot_table_wizard
end type
type ln_7 from line within w_pivot_table_wizard
end type
type st_23 from statictext within w_pivot_table_wizard
end type
type p_1 from picture within w_pivot_table_wizard
end type
type st_22 from statictext within w_pivot_table_wizard
end type
type st_25 from statictext within w_pivot_table_wizard
end type
type st_savedfile_folder from statictext within w_pivot_table_wizard
end type
type st_filename from statictext within w_pivot_table_wizard
end type
type cb_apply from u_commandbutton within w_pivot_table_wizard
end type
type cb_ok from u_commandbutton within w_pivot_table_wizard
end type
type st_4 from statictext within w_pivot_table_wizard
end type
type cbx_newwindow from checkbox within w_pivot_table_wizard
end type
type uo_rowcolumn_selection from u_pivot_table_rowsandcolumns within w_pivot_table_wizard
end type
end forward

global type w_pivot_table_wizard from w_basewindow
integer width = 3301
integer height = 1800
string title = "Pivot Wizard"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 79741120
ln_1 ln_1
ln_2 ln_2
cb_cancel cb_cancel
ln_6 ln_6
ln_7 ln_7
st_23 st_23
p_1 p_1
st_22 st_22
st_25 st_25
st_savedfile_folder st_savedfile_folder
st_filename st_filename
cb_apply cb_apply
cb_ok cb_ok
st_4 st_4
cbx_newwindow cbx_newwindow
uo_rowcolumn_selection uo_rowcolumn_selection
end type
global w_pivot_table_wizard w_pivot_table_wizard

type variables
Protected:
n_pivot_table_service in_pivot_table_service 
end variables

forward prototypes
protected function boolean of_validate ()
end prototypes

protected function boolean of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate()
//	Overview:   This will return false if there are any problems with validation
//	Created by:	Blake Doerr
//	History: 	8.3.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_return

ls_return = uo_rowcolumn_selection.of_validate()

If Len(ls_return) > 0 Then
	MessageBox('Error', ls_return)
	Return False
End If

//---------------------------------------------------------------------------------------------------------------------------
// Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

on w_pivot_table_wizard.create
int iCurrent
call super::create
this.ln_1=create ln_1
this.ln_2=create ln_2
this.cb_cancel=create cb_cancel
this.ln_6=create ln_6
this.ln_7=create ln_7
this.st_23=create st_23
this.p_1=create p_1
this.st_22=create st_22
this.st_25=create st_25
this.st_savedfile_folder=create st_savedfile_folder
this.st_filename=create st_filename
this.cb_apply=create cb_apply
this.cb_ok=create cb_ok
this.st_4=create st_4
this.cbx_newwindow=create cbx_newwindow
this.uo_rowcolumn_selection=create uo_rowcolumn_selection
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ln_1
this.Control[iCurrent+2]=this.ln_2
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.ln_6
this.Control[iCurrent+5]=this.ln_7
this.Control[iCurrent+6]=this.st_23
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.st_22
this.Control[iCurrent+9]=this.st_25
this.Control[iCurrent+10]=this.st_savedfile_folder
this.Control[iCurrent+11]=this.st_filename
this.Control[iCurrent+12]=this.cb_apply
this.Control[iCurrent+13]=this.cb_ok
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.cbx_newwindow
this.Control[iCurrent+16]=this.uo_rowcolumn_selection
end on

on w_pivot_table_wizard.destroy
call super::destroy
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.cb_cancel)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.st_23)
destroy(this.p_1)
destroy(this.st_22)
destroy(this.st_25)
destroy(this.st_savedfile_folder)
destroy(this.st_filename)
destroy(this.cb_apply)
destroy(this.cb_ok)
destroy(this.st_4)
destroy(this.cbx_newwindow)
destroy(this.uo_rowcolumn_selection)
end on

event ue_refreshtheme();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   This event will refresh all the objects on the window
// Created by: Blake Doerr
// History:    8.3.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

end event

event open;call super::open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      open
// Overrides:  No
// Overview:   Initialize the wizard
// Created by: Blake Doerr
// History:    12/28/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(Message.PowerObjectParm) Then
	in_pivot_table_service  = Message.PowerObjectParm
	uo_rowcolumn_selection.of_set_pivot_table_service(in_pivot_table_service)
	cbx_newwindow.Enabled = Not in_pivot_table_service.of_will_open_new_window()
	cbx_newwindow.Checked = in_pivot_table_service.of_will_open_new_window()
Else
	Post Close(This)
End If

f_center_window(this)
This.Event ue_refreshtheme()


end event

type ln_1 from line within w_pivot_table_wizard
long linecolor = 8421504
integer linethickness = 5
integer beginy = 172
integer endx = 3899
integer endy = 172
end type

type ln_2 from line within w_pivot_table_wizard
long linecolor = 16777215
integer linethickness = 5
integer beginy = 176
integer endx = 3899
integer endy = 176
end type

type cb_cancel from u_commandbutton within w_pivot_table_wizard
integer x = 2921
integer y = 1560
integer width = 325
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   Close the parent window returning -1 indicating the user has cancelled
// Created by: Blake Doerr
// History:    12/28/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

CloseWithReturn(Parent, -1)
end event

type ln_6 from line within w_pivot_table_wizard
long linecolor = 16777215
integer linethickness = 5
integer beginx = 5
integer beginy = 1540
integer endx = 4005
integer endy = 1540
end type

type ln_7 from line within w_pivot_table_wizard
long linecolor = 8421504
integer linethickness = 5
integer beginx = 5
integer beginy = 1536
integer endx = 4005
integer endy = 1536
end type

type st_23 from statictext within w_pivot_table_wizard
integer x = 238
integer y = 40
integer width = 1632
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Construct your Pivot by dragging columns from the list"
boolean focusrectangle = false
end type

type p_1 from picture within w_pivot_table_wizard
integer x = 55
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "module - reporting desktop - large icon (white).bmp"
boolean focusrectangle = false
end type

type st_22 from statictext within w_pivot_table_wizard
integer width = 3995
integer height = 172
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

type st_25 from statictext within w_pivot_table_wizard
integer x = 242
integer y = 92
integer width = 1243
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "of ones available on the right to the diagram on the left."
boolean focusrectangle = false
end type

type st_savedfile_folder from statictext within w_pivot_table_wizard
boolean visible = false
integer x = 59
integer y = 632
integer width = 402
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Saved File Folder:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_filename from statictext within w_pivot_table_wizard
boolean visible = false
integer x = 160
integer y = 732
integer width = 302
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "File Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_apply from u_commandbutton within w_pivot_table_wizard
integer x = 2208
integer y = 1560
integer width = 325
integer height = 88
integer taborder = 10
integer weight = 400
string facename = "Tahoma"
string text = "&Apply"
boolean default = true
end type

event clicked;call super::clicked;if Parent.of_validate() then	
	If cbx_newwindow.Checked Then uo_rowcolumn_selection.of_open_in_new_window()
	in_pivot_table_service = uo_rowcolumn_selection.of_apply()
	cbx_newwindow.Checked = False
	This.Enabled = False
	cbx_newwindow.Enabled = Not in_pivot_table_service.of_will_open_new_window()
	cbx_newwindow.Checked = in_pivot_table_service.of_will_open_new_window()
End If
end event

event constructor;call super::constructor;This.Enabled = False
end event

type cb_ok from u_commandbutton within w_pivot_table_wizard
integer x = 2565
integer y = 1560
integer width = 325
integer height = 88
integer taborder = 30
integer weight = 400
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   If wf_validate_context() is successful, close the window returning the selected report folder id
// Created by: Pat Newgent
// History:    12/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string s_return

if Not Parent.of_validate() then	Return

Parent.X = -10000
If cbx_newwindow.Checked Then
	uo_rowcolumn_selection.of_open_in_new_window()
End If

If cbx_newwindow.Checked Or uo_rowcolumn_selection.of_is_modified() Then
	uo_rowcolumn_selection.of_apply()
End If

CloseWithReturn(Parent, 1)

end event

type st_4 from statictext within w_pivot_table_wizard
integer y = 1544
integer width = 3442
integer height = 160
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 81517531
long backcolor = 81517531
boolean enabled = false
boolean focusrectangle = false
end type

type cbx_newwindow from checkbox within w_pivot_table_wizard
integer x = 41
integer y = 1568
integer width = 535
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79416533
string text = "Open as New Report"
boolean lefttext = true
end type

event clicked;cb_apply.Enabled = uo_rowcolumn_selection.of_is_modified() Or This.Checked
end event

type uo_rowcolumn_selection from u_pivot_table_rowsandcolumns within w_pivot_table_wizard
event destroy ( )
integer y = 180
integer height = 1352
integer taborder = 20
boolean border = false
end type

on uo_rowcolumn_selection.destroy
call u_pivot_table_rowsandcolumns::destroy
end on

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:        ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//		aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   1/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Choose Case Lower(Trim(as_message))
   Case 'change occurred'
		cb_apply.Enabled = True
   Case Else
End Choose
end event

