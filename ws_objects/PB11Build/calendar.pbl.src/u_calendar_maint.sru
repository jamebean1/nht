$PBExportHeader$u_calendar_maint.sru
forward
global type u_calendar_maint from userobject
end type
type dw_selected from datawindow within u_calendar_maint
end type
type dw_available from datawindow within u_calendar_maint
end type
type cb_select from commandbutton within u_calendar_maint
end type
type cb_unselect from commandbutton within u_calendar_maint
end type
type cb_save from commandbutton within u_calendar_maint
end type
type st_dateexclusions from statictext within u_calendar_maint
end type
type dw_dateterm_list from datawindow within u_calendar_maint
end type
type dw_dateterms from datawindow within u_calendar_maint
end type
type st_termdivider from statictext within u_calendar_maint
end type
type ln_1 from line within u_calendar_maint
end type
type ln_2 from line within u_calendar_maint
end type
type ln_3 from line within u_calendar_maint
end type
type ln_4 from line within u_calendar_maint
end type
end forward

global type u_calendar_maint from userobject
integer width = 2816
integer height = 2448
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_selected dw_selected
dw_available dw_available
cb_select cb_select
cb_unselect cb_unselect
cb_save cb_save
st_dateexclusions st_dateexclusions
dw_dateterm_list dw_dateterm_list
dw_dateterms dw_dateterms
st_termdivider st_termdivider
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
end type
global u_calendar_maint u_calendar_maint

type variables
n_dao 	in_dao_dateexclusion
n_dao_dateterm			in_dao_dateterm

int						is_selected_row
end variables

on u_calendar_maint.create
this.dw_selected=create dw_selected
this.dw_available=create dw_available
this.cb_select=create cb_select
this.cb_unselect=create cb_unselect
this.cb_save=create cb_save
this.st_dateexclusions=create st_dateexclusions
this.dw_dateterm_list=create dw_dateterm_list
this.dw_dateterms=create dw_dateterms
this.st_termdivider=create st_termdivider
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.Control[]={this.dw_selected,&
this.dw_available,&
this.cb_select,&
this.cb_unselect,&
this.cb_save,&
this.st_dateexclusions,&
this.dw_dateterm_list,&
this.dw_dateterms,&
this.st_termdivider,&
this.ln_1,&
this.ln_2,&
this.ln_3,&
this.ln_4}
end on

on u_calendar_maint.destroy
destroy(this.dw_selected)
destroy(this.dw_available)
destroy(this.cb_select)
destroy(this.cb_unselect)
destroy(this.cb_save)
destroy(this.st_dateexclusions)
destroy(this.dw_dateterm_list)
destroy(this.dw_dateterms)
destroy(this.st_termdivider)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overrides:  No
//	Arguments:	
//	Overview:   Constructor script sets the transaction object and Retrieves the data for the several
//					datawindows that are on the user object.
//	Created by: Joel White
//	History:    6/27/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Long ll_rowcount, ll_datetermID

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the two DAOs that will be used for data retrieval and storage
//-----------------------------------------------------------------------------------------------------------------------------------
in_dao_dateexclusion = Create n_dao 
in_dao_dateterm		= Create n_dao_dateterm


//-----------------------------------------------------------------------------------------------------------------------------------
// Set the transaction objects on the two DAOs and the datawindows
//-----------------------------------------------------------------------------------------------------------------------------------
in_dao_dateexclusion.SetTransObject(SQLCA)
in_dao_dateterm.SetTransObject(SQLCA)
dw_available.SetTransObject(SQLCA)
dw_selected.SetTransObject(SQLCA)
dw_dateterm_list.SetTransObject(SQLCA)
dw_dateterms.SetTransObject(SQLCA)

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the two datawindows
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = dw_dateterm_list.Retrieve()


//-----------------------------------------------------------------------------------------------------------------------------------
// If you have a row in the DateTermList datawindow, then retrieve the terms details
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_rowcount > 0 Then
	ll_datetermID = dw_dateterm_list.GetItemNumber(1, 'datetermid')
	in_dao_dateterm.of_retrieve(ll_datetermID)
	dw_dateterms.Retrieve(ll_datetermID)
	dw_available.Retrieve(ll_datetermID)
	dw_selected.Retrieve(ll_datetermID)
End If


end event

type dw_selected from datawindow within u_calendar_maint
integer x = 1586
integer y = 1536
integer width = 1175
integer height = 740
integer taborder = 40
string title = "none"
string dataobject = "d_swap_dateexclusion_selected"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_available from datawindow within u_calendar_maint
integer x = 37
integer y = 1536
integer width = 1152
integer height = 740
integer taborder = 30
string title = "none"
string dataobject = "d_swap_dateexclusion_available"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;is_selected_row = row
end event

type cb_select from commandbutton within u_calendar_maint
integer x = 1257
integer y = 1772
integer width = 256
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">>"
end type

event clicked;dw_available.RowsMove(is_selected_row, is_selected_row, Primary!, dw_selected, 1, Primary!)

end event

type cb_unselect from commandbutton within u_calendar_maint
integer x = 1257
integer y = 1900
integer width = 256
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "<<"
end type

event clicked;dw_selected.RowsMove(dw_selected.GetRow(), dw_selected.GetRow(), Primary!, dw_available, 1, Primary!)
end event

type cb_save from commandbutton within u_calendar_maint
integer x = 2290
integer y = 2312
integer width = 402
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
end type

event clicked;long ll_rowcount

dw_dateterms.Update()


end event

type st_dateexclusions from statictext within u_calendar_maint
integer x = 37
integer y = 28
integer width = 325
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date Rules"
boolean focusrectangle = false
end type

type dw_dateterm_list from datawindow within u_calendar_maint
integer x = 46
integer y = 96
integer width = 2738
integer height = 584
integer taborder = 10
string title = "none"
string dataobject = "d_gui_dateterm_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;long	ll_ID

ll_ID = this.GetItemNumber(currentrow, 'datetermid')

in_dao_dateterm.of_retrieve(ll_ID)
dw_dateterms.Retrieve(ll_ID)
dw_available.Retrieve(ll_ID)
dw_selected.Retrieve(ll_ID)
end event

type dw_dateterms from datawindow within u_calendar_maint
integer x = 41
integer y = 712
integer width = 2747
integer height = 708
integer taborder = 20
string title = "none"
string dataobject = "d_gui_dateterms"
boolean border = false
boolean livescroll = true
end type

event itemchanged;long ll_numberofhours

If dwo.Type = 'column' Then
	If dwo.Name = 'timeunit' Then
		If lower(data) = 'h' Then
			ll_numberofhours = this.GetItemNumber(1, 'numberhours') * 24
			this.SetItem(1, 'numberhours', ll_numberofhours)
		ElseIf lower(data) = 'd' Then
			ll_numberofhours = Round((this.GetItemNumber(1, 'numberhours')/24),0)
			this.SetItem(1, 'numberhours', ll_numberofhours)
		End If
	End If
End If
end event

type st_termdivider from statictext within u_calendar_maint
integer x = 27
integer y = 1448
integer width = 430
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date Exceptions"
boolean focusrectangle = false
end type

type ln_1 from line within u_calendar_maint
integer linethickness = 4
integer beginx = 384
integer beginy = 1476
integer endx = 2784
integer endy = 1476
end type

type ln_2 from line within u_calendar_maint
long linecolor = 16777215
integer linethickness = 4
integer beginx = 384
integer beginy = 1480
integer endx = 2784
integer endy = 1480
end type

type ln_3 from line within u_calendar_maint
integer linethickness = 4
integer beginx = 370
integer beginy = 64
integer endx = 2779
integer endy = 64
end type

type ln_4 from line within u_calendar_maint
long linecolor = 16777215
integer linethickness = 4
integer beginx = 370
integer beginy = 68
integer endx = 2770
integer endy = 68
end type

