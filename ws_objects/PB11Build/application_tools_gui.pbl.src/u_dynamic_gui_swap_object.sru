$PBExportHeader$u_dynamic_gui_swap_object.sru
forward
global type u_dynamic_gui_swap_object from u_dynamic_properties_sheet
end type
type u_swap_remove from u_commandbutton within u_dynamic_gui_swap_object
end type
type u_swap_add from u_commandbutton within u_dynamic_gui_swap_object
end type
type dw_selected from u_deal_display_datawindow within u_dynamic_gui_swap_object
end type
type dw_available from u_deal_display_datawindow within u_dynamic_gui_swap_object
end type
end forward

global type u_dynamic_gui_swap_object from u_dynamic_properties_sheet
integer width = 2839
integer height = 1180
boolean border = false
long backcolor = 15780518
string text = "Extended Deal Header"
long tabbackcolor = 12639424
string picturename = "properties!"
long picturemaskcolor = 553648127
u_swap_remove u_swap_remove
u_swap_add u_swap_add
dw_selected dw_selected
dw_available dw_available
end type
global u_dynamic_gui_swap_object u_dynamic_gui_swap_object

type variables
string is_gctype
w_deal_ddlb iw_details

boolean ib_retrieve_attrs = true

n_swap_service in_swap_service 

boolean ib_dragging 
boolean ib_multiselect

long il_lastrow
end variables

on u_dynamic_gui_swap_object.create
int iCurrent
call super::create
this.u_swap_remove=create u_swap_remove
this.u_swap_add=create u_swap_add
this.dw_selected=create dw_selected
this.dw_available=create dw_available
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.u_swap_remove
this.Control[iCurrent+2]=this.u_swap_add
this.Control[iCurrent+3]=this.dw_selected
this.Control[iCurrent+4]=this.dw_available
end on

on u_dynamic_gui_swap_object.destroy
call super::destroy
destroy(this.u_swap_remove)
destroy(this.u_swap_add)
destroy(this.dw_selected)
destroy(this.dw_available)
end on

event resize;call super::resize;dw_selected.height = this.height - dw_selected.y * 2
dw_selected.width = this.width - dw_selected.x  - dw_available.x

//dw_available.height = this.height - dw_available.y - dw_selected.y
dw_available.Height = dw_selected.Height


end event

type u_swap_remove from u_commandbutton within u_dynamic_gui_swap_object
integer x = 946
integer y = 212
integer width = 288
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "<- &Remove"
end type

event clicked;call super::clicked;//long l_row
//string s_value
//
//l_row = dw_selected.getselectedrow(0)
//
//if l_row > 0 then
//	s_value = dw_selected.getitemstring(l_row,'gnrlcnfgqlfr')
//	in_dao.of_setitem(1,s_value + 'attribute',gn_globals.is_nullstring)
//	dw_selected.deleterow(l_row)
//end if
end event

type u_swap_add from u_commandbutton within u_dynamic_gui_swap_object
integer x = 946
integer y = 100
integer width = 288
integer height = 84
integer taborder = 30
integer weight = 400
string facename = "Tahoma"
string text = "&Add ->"
end type

event clicked;call super::clicked;//long l_row
//string s_value,s_multi
//
//l_row = dw_available.getselectedrow(0)
//
//if l_row > 0 then
//	s_value = dw_available.getitemstring(l_row,'gnrlcnfgqlfr')
//	s_multi = dw_available.getitemstring(l_row,'gnrlcnfgmulti')
//	if dw_selected.find('gnrlcnfgqlfr = "' + s_value + '"',0,dw_selected.rowcount()) = 0 then
//		l_row = dw_selected.insertrow(0)
//		dw_selected.setitem(l_row,'gnrlcnfgqlfr',s_value)
//		dw_selected.setitem(l_row,'gnrlcnfgeditmask',s_multi)
//	end if
//end if
end event

type dw_selected from u_deal_display_datawindow within u_dynamic_gui_swap_object
integer x = 1285
integer y = 40
integer width = 1403
integer height = 1116
integer taborder = 20
string dragicon = "arrowman.ico"
boolean vscrollbar = true
boolean livescroll = false
end type

event ue_refreshtheme;// override
end event

event rowfocuschanged;call super::rowfocuschanged;if not ib_multiselect then
	this.selectrow(0,false)
	this.selectrow(currentrow,true)
end if
end event

event dragdrop;call super::dragdrop;if source = dw_available then
	if u_swap_add.enabled then u_swap_add.triggerevent(clicked!)
end if
end event

event ue_pbmmousemove;call super::ue_pbmmousemove;string s_object
long l_value
if flags = 1  then 
	s_object = getobjectatpointer()
	s_object = left(s_object,pos(s_object,'~t') - 1)
	l_value = long(this.Describe(s_object + ".TabSequence"))
	if not l_value > 0 then 
		this.drag(Begin!)
	end if
end if
end event

event clicked;long l_loop

if row = 0 then return

if ib_multiselect then
	if keydown(KeyControl!) then
		if this.getselectedrow(row - 1) = row then
			this.selectrow(row,false)
		else
			this.selectrow(row,true)
		end if
	elseif keydown(KeyShift!) then
		this.selectrow(0,false)
		if il_lastrow > row then
			for l_loop = row to il_lastrow
				this.selectrow(l_loop,true)
			next
		else
			for l_loop = il_lastrow to row
				this.selectrow(l_loop,true)
			next
		end if
				
	else
		this.selectrow(0,false)
		this.selectrow(row,true)
	end if
		
else
	if row > 0 then 
		this.selectrow(0,false)
		this.selectrow(row,true)
	end if
end if

il_lastrow = row

end event

type dw_available from u_deal_display_datawindow within u_dynamic_gui_swap_object
integer x = 137
integer y = 40
integer width = 750
integer height = 1112
integer taborder = 10
string dragicon = "arrowman.cur"
boolean vscrollbar = true
boolean livescroll = false
end type

event ue_refreshtheme;// override
end event

event rowfocuschanged;call super::rowfocuschanged;if not ib_multiselect then
	this.selectrow(0,false)
	this.selectrow(currentrow,true)
end if

end event

event dragdrop;call super::dragdrop;if source = dw_selected then
	if u_swap_remove.enabled then u_swap_remove.triggerevent(clicked!)
end if
end event

event ue_pbmmousemove;call super::ue_pbmmousemove;if flags = 1  then 
	this.drag(Begin!)
end if
end event

event clicked;long l_loop

if row = 0 then return

if ib_multiselect then
	if keydown(KeyControl!) then
		if this.getselectedrow(row - 1) = row then
			this.selectrow(row,false)
		else
			this.selectrow(row,true)
		end if
	elseif keydown(KeyShift!) then
		this.selectrow(0,false)
		if il_lastrow > row then
			for l_loop = row to il_lastrow
				this.selectrow(l_loop,true)
			next
		else
			for l_loop = il_lastrow to row
				this.selectrow(l_loop,true)
			next
		end if
				
	else
		this.selectrow(0,false)
		this.selectrow(row,true)
	end if
		
else
	if row > 0 then 
		this.selectrow(0,false)
		this.selectrow(row,true)
	end if
end if

il_lastrow = row
end event

