$PBExportHeader$w_basewindow_distribution_options.srw
$PBExportComments$Delete Me?  May be used on Report Properties.
forward
global type w_basewindow_distribution_options from window
end type
type p_1 from picture within w_basewindow_distribution_options
end type
type st_title from statictext within w_basewindow_distribution_options
end type
type cb_ok from commandbutton within w_basewindow_distribution_options
end type
type cb_cancel from commandbutton within w_basewindow_distribution_options
end type
type st_rectangle from statictext within w_basewindow_distribution_options
end type
type ln_white from line within w_basewindow_distribution_options
end type
type ln_darkgrey from line within w_basewindow_distribution_options
end type
type ln_1 from line within w_basewindow_distribution_options
end type
type ln_2 from line within w_basewindow_distribution_options
end type
type st_toprectangle from statictext within w_basewindow_distribution_options
end type
end forward

global type w_basewindow_distribution_options from window
integer width = 1975
integer height = 1080
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 15780518
p_1 p_1
st_title st_title
cb_ok cb_ok
cb_cancel cb_cancel
st_rectangle st_rectangle
ln_white ln_white
ln_darkgrey ln_darkgrey
ln_1 ln_1
ln_2 ln_2
st_toprectangle st_toprectangle
end type
global w_basewindow_distribution_options w_basewindow_distribution_options

type variables
u_dynamic_gui iu_dynamic_gui
end variables

on w_basewindow_distribution_options.create
this.p_1=create p_1
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_rectangle=create st_rectangle
this.ln_white=create ln_white
this.ln_darkgrey=create ln_darkgrey
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_toprectangle=create st_toprectangle
this.Control[]={this.p_1,&
this.st_title,&
this.cb_ok,&
this.cb_cancel,&
this.st_rectangle,&
this.ln_white,&
this.ln_darkgrey,&
this.ln_1,&
this.ln_2,&
this.st_toprectangle}
end on

on w_basewindow_distribution_options.destroy
destroy(this.p_1)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_rectangle)
destroy(this.ln_white)
destroy(this.ln_darkgrey)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_toprectangle)
end on

event open;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Open
//	Overview:   This Windows displays user objects for report options.
//					Two functions are required for the object to be opened on this window
//
//             Function 1: of_fill(String arg) - This function will be given the current options string.
//             Function 2: of_generate_options() - This function should generate the options
//                                                 containing the "||" delimited string.
//
//             Look at u_report_options_datawindow for example.  It is the GUI for the PowerBuilder
//             Datawindow.
//
//	Created by: Blake Doerr
//	History:    2/24/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_options
String	ls_parsed[]
String	ls_title
String	ls_userobject
String	ls_currentoptions

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
PowerObject	lo_datasource
n_bag ln_bag

//-----------------------------------------------------------------------------------------------------------------------------------
// If the bag object is valid, use it
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(Message.PowerObjectParm) Then
	If ClassName(Message.PowerObjectParm) = 'n_bag' Then
		ln_bag = Message.PowerObjectParm
		ls_title					= String(ln_bag.of_get('DistributionMethod'))
		ls_userobject			= String(ln_bag.of_get('GUI'))
		ls_currentoptions		= String(ln_bag.of_get('Options'))
		lo_datasource			= ln_bag.of_get('Datasource')
	End If
Else
	ls_options = Message.StringParm
	gn_globals.in_string_functions.of_parse_string(ls_options, "@@@", ls_parsed[])
	If UpperBound(ls_parsed[]) >= 3 Then
		ls_title					= ls_parsed[1]
		ls_userobject			= ls_parsed[2]
		ls_currentoptions		= ls_parsed[3]
	Else
		Return
	End If
End If


this.Title = "Distribution Options for " + ls_title
st_title.Text = this.Title

This.OpenUserObject(iu_dynamic_gui, ls_userobject, 10	, st_toprectangle.Height + 28)
iu_dynamic_gui.Dynamic of_fill(ls_currentoptions)
If IsValid(lo_datasource) Then iu_dynamic_gui.of_setdao(lo_datasource)

this.backcolor = gn_globals.in_theme.of_get_backcolor()

ln_darkgrey.BeginY 	= iu_dynamic_gui.y + iu_dynamic_gui.height + 28
ln_darkgrey.EndY 		= ln_darkgrey.BeginY
ln_white.BeginY 		= iu_dynamic_gui.y + iu_dynamic_gui.height + 32
ln_white.EndY 			= ln_white.BeginY

st_rectangle.Y = ln_white.beginy + 5

cb_cancel.X = This.Width - cb_cancel.Width - 50
cb_ok.X 		= cb_cancel.X - cb_ok.Width - 20
cb_cancel.Y	= st_rectangle.Y + 25
cb_ok.Y		= cb_cancel.Y

this.height = this.height - (workspaceheight()  -  (cb_ok.height + cb_ok.y + 35))
This.Width	= iu_dynamic_gui.Width + iu_dynamic_gui.X * 2
cb_cancel.X = This.Width - cb_cancel.Width - 40
cb_ok.X = cb_cancel.X - cb_ok.Width - 20
this.x = w_mdi.x + (w_mdi.width/2) - (this.width/2)
this.y = w_mdi.y + (w_mdi.height/2) - (this.height/2)

st_rectangle.BringToTop = False






end event

type p_1 from picture within w_basewindow_distribution_options
integer x = 55
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Module - SmartSearch - Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_title from statictext within w_basewindow_distribution_options
integer x = 229
integer y = 56
integer width = 1303
integer height = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "{Dynamic Text}"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_basewindow_distribution_options
integer x = 1198
integer y = 892
integer width = 343
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;string s_return

s_return = iu_dynamic_gui.Dynamic of_generate_options()
CloseWithReturn(parent,s_return)

end event

type cb_cancel from commandbutton within w_basewindow_distribution_options
integer x = 1573
integer y = 892
integer width = 343
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;CloseWithReturn(parent,'CANCEL')
end event

type st_rectangle from statictext within w_basewindow_distribution_options
integer y = 872
integer width = 4635
integer height = 168
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

type ln_white from line within w_basewindow_distribution_options
long linecolor = 16777215
integer linethickness = 1
integer beginy = 864
integer endx = 4640
integer endy = 864
end type

type ln_darkgrey from line within w_basewindow_distribution_options
long linecolor = 8421504
integer linethickness = 1
integer beginy = 860
integer endx = 4640
integer endy = 860
end type

type ln_1 from line within w_basewindow_distribution_options
long linecolor = 8421504
integer linethickness = 1
integer beginy = 172
integer endx = 4009
integer endy = 172
end type

type ln_2 from line within w_basewindow_distribution_options
long linecolor = 16777215
integer linethickness = 1
integer beginy = 176
integer endx = 4009
integer endy = 176
end type

type st_toprectangle from statictext within w_basewindow_distribution_options
integer width = 4009
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

