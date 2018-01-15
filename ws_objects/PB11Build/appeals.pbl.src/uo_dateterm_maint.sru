$PBExportHeader$uo_dateterm_maint.sru
forward
global type uo_dateterm_maint from userobject
end type
type cb_2 from commandbutton within uo_dateterm_maint
end type
type cb_1 from commandbutton within uo_dateterm_maint
end type
type dw_dateterm_details from u_reference_display_datawindow within uo_dateterm_maint
end type
type st_3 from statictext within uo_dateterm_maint
end type
type dw_dateterm_list from u_reference_display_datawindow within uo_dateterm_maint
end type
type st_2 from statictext within uo_dateterm_maint
end type
type st_1 from statictext within uo_dateterm_maint
end type
type dw_selected from u_reference_display_datawindow within uo_dateterm_maint
end type
type dw_available from u_reference_display_datawindow within uo_dateterm_maint
end type
type ln_1 from line within uo_dateterm_maint
end type
type ln_2 from line within uo_dateterm_maint
end type
end forward

global type uo_dateterm_maint from userobject
integer width = 3264
integer height = 1376
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_save ( )
event ue_new ( )
event ue_delete ( )
event ue_refresh ( )
cb_2 cb_2
cb_1 cb_1
dw_dateterm_details dw_dateterm_details
st_3 st_3
dw_dateterm_list dw_dateterm_list
st_2 st_2
st_1 st_1
dw_selected dw_selected
dw_available dw_available
ln_1 ln_1
ln_2 ln_2
end type
global uo_dateterm_maint uo_dateterm_maint

type variables
n_dao_dateterm in_dao_dateterm
n_dao_reference_data in_dao_available
n_dao_reference_data in_dao_selected

long il_datetermid

long il_selected_row, il_selected_row2


long il_row
end variables

event ue_save();Long ll_return


in_dao_dateterm.of_save()
in_dao_selected.of_save()


dw_dateterm_details.event ue_retrieve()
dw_dateterm_list.Retrieve()
end event

event ue_new();long 	ll_return, ll_id, ll_row
string ls_maxid

in_dao_dateterm.of_retrieve(0)
in_dao_dateterm.of_new()

SELECT max(cusfocus.dateterm.datetermid)  
 INTO :ls_maxid  
 FROM cusfocus.dateterm;


ll_id = long(ls_maxid) + 1

in_dao_dateterm.of_setitem(1, 'datetermid', ll_id)
in_dao_dateterm.of_setitem(1, 'holidaysused', 'N')
in_dao_dateterm.of_setitem(1, 'weekendsused', 'N')
in_dao_dateterm.of_setitem(1, 'timeunit', 'H')
in_dao_dateterm.of_setitem(1, 'updated_by', OBJCA.WIN.fu_GetLogin (SQLCA))
in_dao_dateterm.of_setitem(1, 'updated_timestamp', gn_globals.in_date_manipulator.of_now())

ll_return = in_dao_dateterm.Rowcount()

ll_row = dw_dateterm_list.InsertRow(0)
dw_dateterm_list.SetRow(ll_row)

in_dao_available.of_retrieve(ll_id)
in_dao_selected.of_retrieve(ll_id)

dw_dateterm_details.event ue_retrieve()
dw_available.event ue_retrieve()
dw_selected.event ue_retrieve()

dw_dateterm_details.SetRow(1)
dw_dateterm_details.SetColumn('termname')

end event

event ue_delete();long ll_return, ll_optgroupID, ll_count


ll_return = gn_globals.in_messagebox.of_messagebox('Are you sure you want to delete this record?', Question!, YesNoCancel!, 2)

If ll_return = 1 Then
	ll_optgroupID = long(il_datetermid)
	
  SELECT count(*)  
    INTO :ll_count  
    FROM cusfocus.appealdetail  
   WHERE cusfocus.appealdetail.datetermid = :ll_optgroupID   
           ;

	If ll_count > 0 Then
		gn_globals.in_messagebox.of_messagebox('You cannot delete this date term because it has been selected for a case.', information!, OK!, 1)		
	End If			  
			  
  SELECT count(*)  
    INTO :ll_count  
    FROM cusfocus.appealheader  
   WHERE cusfocus.appealheader.datetermid = :ll_optgroupID   
           ;			  
			  

	If ll_count > 0 Then
		gn_globals.in_messagebox.of_messagebox('You cannot delete this date term because it has been selected for a case.', information!, OK!, 1)		
	
	Else
//		in_dao_dateterm.DeleteRow(il_row)
		in_dao_dateterm.of_delete()
	End If
End If

dw_dateterm_list.Retrieve()
If dw_dateterm_list.RowCount() > 0 Then
	dw_dateterm_list.SetRow(1)
End If

dw_dateterm_details.event ue_retrieve()

end event

event ue_refresh();datawindowchild ldwc_casestatus

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the datawindow children
//-----------------------------------------------------------------------------------------------------------------------------------
dw_available.GetChild('dateexclusionid', ldwc_casestatus)
ldwc_casestatus.SetTransObject(SQLCA)
ldwc_casestatus.Retrieve()

dw_selected.GetChild('dateexclusionid', ldwc_casestatus)
ldwc_casestatus.SetTransObject(SQLCA)
ldwc_casestatus.Retrieve()


dw_dateterm_details.event ue_retrieve()
dw_available.event ue_retrieve()
dw_selected.event ue_retrieve()

end event

event constructor;long ll_datetermID, ll_row
datawindowchild ldwc_casestatus

in_dao_dateterm 				= 	Create n_dao_dateterm
in_dao_available				=  Create n_dao_reference_data
in_dao_selected				=	Create n_dao_reference_data

in_dao_available.DataObject = 'd_swap_dateexclusion_available'
in_dao_selected.DataObject = 'd_swap_dateexclusion_selected'

in_dao_dateterm.of_settransobject(SQLCA)
in_dao_available.of_settransobject(SQLCA)
in_dao_selected.of_settransobject(SQLCA)

dw_dateterm_list.SetTransObject(SQLCA)
dw_dateterm_list.Retrieve()

If dw_dateterm_list.Rowcount() > 0 Then 
	dw_dateterm_list.Setrow(1)
	ll_datetermID = dw_dateterm_list.GetItemNumber(1, 'datetermid')

	in_dao_dateterm.of_Retrieve(ll_datetermID)
	in_dao_available.of_retrieve(ll_datetermID)
	in_dao_selected.of_retrieve(ll_datetermID)
End If

dw_dateterm_details.of_setdao(in_dao_dateterm)
dw_dateterm_details.event ue_retrieve()

dw_available.of_setdao(in_dao_available)
dw_available.event ue_retrieve()

dw_selected.of_setdao(in_dao_selected)
dw_selected.event ue_retrieve()

//dw_dateterm_list.of_setdao(in_dao_dateterm)
//dw_dateterm_list.event ue_retrieve()

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the datawindow children
//-----------------------------------------------------------------------------------------------------------------------------------
dw_available.GetChild('dateexclusionid', ldwc_casestatus)
ldwc_casestatus.SetTransObject(SQLCA)
ldwc_casestatus.Retrieve()

dw_selected.GetChild('dateexclusionid', ldwc_casestatus)
ldwc_casestatus.SetTransObject(SQLCA)
ldwc_casestatus.Retrieve()




end event

on uo_dateterm_maint.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_dateterm_details=create dw_dateterm_details
this.st_3=create st_3
this.dw_dateterm_list=create dw_dateterm_list
this.st_2=create st_2
this.st_1=create st_1
this.dw_selected=create dw_selected
this.dw_available=create dw_available
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_dateterm_details,&
this.st_3,&
this.dw_dateterm_list,&
this.st_2,&
this.st_1,&
this.dw_selected,&
this.dw_available,&
this.ln_1,&
this.ln_2}
end on

on uo_dateterm_maint.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_dateterm_details)
destroy(this.st_3)
destroy(this.dw_dateterm_list)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_selected)
destroy(this.dw_available)
destroy(this.ln_1)
destroy(this.ln_2)
end on

type cb_2 from commandbutton within uo_dateterm_maint
integer x = 1454
integer y = 1184
integer width = 279
integer height = 72
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;long ll_row, ll_ID, ll_newrow, ll_return

ll_row = dw_selected.getrow()

ll_return = in_dao_available.rowcount()

if ll_row > 0 then
	ll_ID = long(in_dao_selected.of_getitem(ll_row, 'dateexclusionid'))
	
	ll_newrow = in_dao_available.InsertRow(0)

	in_dao_available.of_setitem(ll_newrow, 'dateexclusionid', ll_ID)
	ll_return = in_dao_selected.deleterow(ll_row)

//	in_dao_available.of_retrieve(long(in_dao_dateterm.of_getitem(1,'datetermid')))
	ll_return = in_dao_available.rowcount()

	dw_selected.event ue_retrieve()
	dw_available.event ue_retrieve()
end if
end event

type cb_1 from commandbutton within uo_dateterm_maint
integer x = 1454
integer y = 1024
integer width = 279
integer height = 72
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;string ls_dao, ls_find
long ll_ruleid, ll_row, ll_datetermid, ll_setid, ll_typeid
long ll_rowcount
n_dao ln_dao


if il_row > 0 then
	ll_typeid = long(in_dao_available.of_getitem (il_row, 'dateexclusionid'))
	ll_datetermid = long(in_dao_dateterm.of_getitem (1, 'datetermid'))
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we didn't find the date exclusion id, add a row to dao, set the id's and 
	// refresh the dw.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_find = 'dateexclusionid=' + String(ll_typeid) + 'and datetermid=' + String(ll_datetermid)
	
	if in_dao_selected.find(ls_find,0,in_dao_selected.rowcount()) = 0 then
		ll_row = in_dao_selected.insertrow (0)
	
		in_dao_selected.of_setitem (ll_row, 'datetermid', ll_datetermid)
		in_dao_selected.of_setitem (ll_row, 'dateexclusionid', ll_typeid)
		in_dao_available.DeleteRow(il_row)
		
		If in_dao_available.RowCount() = 0 Then
			il_row = 0
		End If
		
		dw_available.event ue_retrieve()
		dw_selected.event ue_retrieve()
	End If
end if

end event

type dw_dateterm_details from u_reference_display_datawindow within uo_dateterm_maint
integer x = 9
integer y = 392
integer width = 3227
integer height = 428
integer taborder = 20
string dataobject = "d_gui_dateterms"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;long ll_numberofhours

If dwo.Type = 'column' Then
	Choose Case dwo.Name 
		Case 'timeunit' 
			If lower(data) = 'h' Then
				ll_numberofhours = this.GetItemNumber(1, 'numberhours') * 24
				in_dao_dateterm.of_SetItem(row, 'numberhours', ll_numberofhours)
			ElseIf lower(data) = 'd' Then
				ll_numberofhours = Round((this.GetItemNumber(1, 'numberhours')/24),0)
				in_dao_dateterm.of_SetItem(row, 'numberhours', ll_numberofhours)
			End If
			
		dw_dateterm_details.event ue_retrieve()
	End Choose
End If
end event

event editchanged;call super::editchanged;this.AcceptText()
end event

type st_3 from statictext within uo_dateterm_maint
integer x = 32
integer y = 820
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date Exclusions"
boolean focusrectangle = false
end type

type dw_dateterm_list from u_reference_display_datawindow within uo_dateterm_maint
integer x = 18
integer y = 8
integer width = 3223
integer height = 372
integer taborder = 10
string dataobject = "d_gui_dateterm_list"
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;long ll_return

If in_dao_dateterm.of_changed() Then 
	ll_return = gn_globals.in_messagebox.of_messagebox('The date term details have changed. Do you want to save your changes?', Exclamation!, YesNo!, 1)
	
	Choose Case ll_return 
		Case 1 
				in_dao_dateterm.of_save()
	End Choose
End If

If in_dao_selected.of_changed() Then 
	ll_return = gn_globals.in_messagebox.of_messagebox('The date exlusions have changed, do you want to save your changes?', Exclamation!, YesNo!, 1)
	
	Choose Case ll_return 
		Case 1 
				in_dao_selected.of_save()
	End Choose
End If

end event

event clicked;call super::clicked;If row > 0 and row <= this.RowCount() Then

	il_row = row
	
	il_datetermid = this.GetItemNumber(row, 'datetermid')
	in_dao_dateterm.of_retrieve(il_datetermid)
	
	in_dao_selected.of_retrieve(il_datetermid)
	in_dao_available.of_retrieve(il_datetermid)

	dw_dateterm_details.event ue_retrieve()
	dw_selected.event ue_retrieve()
	dw_available.event ue_retrieve()
	
End If
end event

type st_2 from statictext within uo_dateterm_maint
integer x = 2085
integer y = 900
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selected:"
boolean focusrectangle = false
end type

type st_1 from statictext within uo_dateterm_maint
integer x = 178
integer y = 900
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Available:"
boolean focusrectangle = false
end type

type dw_selected from u_reference_display_datawindow within uo_dateterm_maint
integer x = 2075
integer y = 980
integer width = 1015
integer height = 364
integer taborder = 20
string dataobject = "d_swap_dateexclusion_selected"
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.SetTransObject(SQLCA)
end event

event rowfocuschanged;call super::rowfocuschanged;il_selected_row2 = currentrow
end event

type dw_available from u_reference_display_datawindow within uo_dateterm_maint
integer x = 165
integer y = 980
integer width = 1015
integer height = 364
integer taborder = 10
string dataobject = "d_swap_dateexclusion_available"
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.SetTransObject(SQLCA)

end event

event rowfocuschanged;call super::rowfocuschanged;il_selected_row = currentrow
end event

event clicked;call super::clicked;il_row = row
end event

type ln_1 from line within uo_dateterm_maint
integer linethickness = 4
integer beginx = 521
integer beginy = 848
integer endx = 3200
integer endy = 848
end type

type ln_2 from line within uo_dateterm_maint
long linecolor = 16777215
integer linethickness = 4
integer beginx = 521
integer beginy = 852
integer endx = 3200
integer endy = 852
end type

