$PBExportHeader$w_expressionfavorite_maintenance.srw
forward
global type w_expressionfavorite_maintenance from w_deal_display_basic
end type
type st_3 from statictext within w_expressionfavorite_maintenance
end type
type dw_template from u_reference_display_datawindow within w_expressionfavorite_maintenance
end type
type cb_cancel from u_commandbutton within w_expressionfavorite_maintenance
end type
end forward

global type w_expressionfavorite_maintenance from w_deal_display_basic
integer width = 1920
integer height = 1152
string title = "Save Expression"
st_3 st_3
dw_template dw_template
cb_cancel cb_cancel
end type
global w_expressionfavorite_maintenance w_expressionfavorite_maintenance

type variables
n_dao in_dao
boolean ib_browse_open
end variables

on w_expressionfavorite_maintenance.create
int iCurrent
call super::create
this.st_3=create st_3
this.dw_template=create dw_template
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.dw_template
this.Control[iCurrent+3]=this.cb_cancel
end on

on w_expressionfavorite_maintenance.destroy
call super::destroy
destroy(this.st_3)
destroy(this.dw_template)
destroy(this.cb_cancel)
end on

event open;call super::open;in_dao = Message.PowerObjectParm
dw_template.of_setdao(in_dao)

dw_template.event ue_retrieve()

f_center_window(this)

end event

type p_1 from w_deal_display_basic`p_1 within w_expressionfavorite_maintenance
integer y = 24
string picturename = "Module - SmartSearch - Large Icon (White).bmp"
end type

type st_1 from w_deal_display_basic`st_1 within w_expressionfavorite_maintenance
integer y = 60
integer width = 1691
string text = "Save the expression information"
end type

type cb_1 from w_deal_display_basic`cb_1 within w_expressionfavorite_maintenance
integer x = 1129
integer y = 944
integer width = 352
integer taborder = 50
boolean default = true
end type

event cb_1::clicked;string s_error

s_error = in_dao.of_save()
If s_error <> '' then 
	gn_Globals.in_messagebox.of_messagebox_validation(s_error)
else
	close(parent)
end if

end event

type st_2 from w_deal_display_basic`st_2 within w_expressionfavorite_maintenance
integer width = 3442
end type

type ln_1 from w_deal_display_basic`ln_1 within w_expressionfavorite_maintenance
integer endx = 4210
end type

type ln_2 from w_deal_display_basic`ln_2 within w_expressionfavorite_maintenance
integer endx = 4210
end type

type ln_3 from w_deal_display_basic`ln_3 within w_expressionfavorite_maintenance
integer beginy = 916
integer endx = 4302
integer endy = 916
end type

type ln_4 from w_deal_display_basic`ln_4 within w_expressionfavorite_maintenance
integer beginy = 912
integer endx = 4206
integer endy = 912
end type

type st_3 from statictext within w_expressionfavorite_maintenance
integer y = 920
integer width = 3547
integer height = 168
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_template from u_reference_display_datawindow within w_expressionfavorite_maintenance
integer y = 196
integer width = 2505
integer height = 716
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_gui_expressionfavorite"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_notify;call super::ue_notify;//n_string_functions ln_string_functions
string s_string_array[]

choose case as_message		
	case 'validation'
		gn_globals.in_string_functions.of_parse_string ( string(aany_argument), '||', s_string_array[] )
		dw_template.setfocus()
		dw_template.setrow(long(s_string_array[1]))
		dw_template.setcolumn(s_string_array[3])
	
end choose

end event

event ue_retrieve;call super::ue_retrieve;String ls_expressiontypename

ls_expressiontypename = in_dao.of_getitem(1, 'ExpressionTypeName')
If Len(Trim(ls_expressiontypename)) > 0 Then
	This.Modify('saveforsourceid.CheckBox.Text="Save Expression for All ' + ls_expressiontypename + 's"')
	This.Modify('t_saveexpression.Text="Save Expression for All ' + ls_expressiontypename + 's"')
End If
end event

type cb_cancel from u_commandbutton within w_expressionfavorite_maintenance
integer x = 1499
integer y = 944
integer width = 352
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;close(parent)
end event

