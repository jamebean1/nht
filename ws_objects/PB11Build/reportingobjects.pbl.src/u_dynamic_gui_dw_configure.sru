$PBExportHeader$u_dynamic_gui_dw_configure.sru
forward
global type u_dynamic_gui_dw_configure from u_dynamic_properties_sheet
end type
type st_down from u_hover_button within u_dynamic_gui_dw_configure
end type
type st_up from u_hover_button within u_dynamic_gui_dw_configure
end type
type dw_edit from u_deal_display_datawindow within u_dynamic_gui_dw_configure
end type
type dw_columnlist from u_deal_display_datawindow within u_dynamic_gui_dw_configure
end type
end forward

global type u_dynamic_gui_dw_configure from u_dynamic_properties_sheet
integer width = 3991
integer height = 1212
boolean border = false
long backcolor = 15780518
string text = "Extended Deal Header"
long tabbackcolor = 12639424
string picturename = "properties!"
long picturemaskcolor = 553648127
st_down st_down
st_up st_up
dw_edit dw_edit
dw_columnlist dw_columnlist
end type
global u_dynamic_gui_dw_configure u_dynamic_gui_dw_configure

type variables
boolean ib_multiselect
datastore ds_datastore
long il_lastrow

string is_currentobject
string is_tablename
end variables

forward prototypes
public function integer of_find_max_y (string as_ignore_column)
public function string of_get_syntax ()
public subroutine of_addattributes (string as_tablename)
public subroutine of_init (string as_dwobject, string as_dwchanges)
end prototypes

public function integer of_find_max_y (string as_ignore_column);long l_max_y,i_i, l_current_y
string s_object

for i_i = 1 to dw_columnlist.rowcount()
	s_object = dw_columnlist.getitemstring(i_i,'objectname')
	
	if as_ignore_column = s_object then  continue
	if dw_edit.Describe(s_object + ".visible") = '0' then continue
	
	l_current_y = long(dw_edit.Describe(s_object + ".Y"))
	
	if l_current_y > l_max_y then 
		l_max_y = l_current_y
	end if
	
	
next


return l_max_y
	
end function

public function string of_get_syntax ();n_dw_configure ln_configure
string s_syntax

ln_configure = create n_dw_configure
s_syntax = ln_configure.of_get_dw_changes(dw_edit,is_tablename)

return s_syntax
end function

public subroutine of_addattributes (string as_tablename);//------------------------------------------------------------------------------
// Get the list of variables we need to create a dw for.
//------------------------------------------------------------------------------
ds_datastore = create datastore
ds_datastore.dataobject = 'd_create_gc_dwsyntax'
ds_datastore.settransobject(sqlca)
ds_datastore.retrieve(as_tablename)

is_tablename  = as_tablename
end subroutine

public subroutine of_init (string as_dwobject, string as_dwchanges);n_dw_configure ln_configure
n_datawindow_tools ln_datawindow_tools
long i_i,l_row,l_taborder
string ls_columnname[],ls_headername[],ls_headertext[],ls_columntype[],s_value,ls_null[]


//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the DW and rebuild column list
//-----------------------------------------------------------------------------------------------------------------------------------
dw_columnlist.reset()


//-----------------------------------------------------------------------------------------------------------------------------------
// IF this is a reset, don't set the dataobjectname
//-----------------------------------------------------------------------------------------------------------------------------------
if as_dwobject <> '' then 
	dw_edit.dataobject = as_dwobject

	ln_configure = create n_dw_configure
	ln_configure.of_apply_dw_changes(dw_edit,as_dwchanges)
	
end if

if dw_edit.rowcount() = 0 then dw_edit.insertrow(0)
dw_edit.SetDetailHeight (1,1,20000 )



//-----------------------------------------------------------------------------------------------------------------------------------
// Get the colummns
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = create n_datawindow_tools
ln_datawindow_tools.of_get_columns(dw_edit,ls_columnname,ls_headername,ls_headertext,ls_columntype)


//-----------------------------------------------------------------------------------------------------------------------------------
// THis loop builds the labels 
//-----------------------------------------------------------------------------------------------------------------------------------
for i_i = 1 to upperbound(ls_columnname)
	l_row = dw_columnlist.insertrow(0)
	dw_columnlist.setitem(l_row,'objectname',ls_headername[i_i])
	dw_columnlist.setitem(l_row,'objecttext', ls_headertext[i_i])
	
	s_value = dw_edit.describe('DataWindow.Syntax')
	s_value = dw_edit.Describe(ls_headername[i_i] + ".Visible")
	
	choose case s_value
			
		case '1' 
			dw_columnlist.setitem(l_row,'onoroff','Y')
			dw_columnlist.setitem(l_row,'originalonoroff','Y')
		Case '0','"1	0"'
			dw_columnlist.setitem(l_row,'onoroff','N')
			dw_columnlist.setitem(l_row,'originalonoroff','N')
		case else
			dw_columnlist.setitem(l_row,'onoroff','F')
			dw_columnlist.setitem(l_row,'originalonoroff','F')
			dw_edit.Modify(ls_headername[i_i] + ".Visible='1'")
			
	end choose
		
	dw_edit.Modify(ls_headername[i_i] + ".background.mode='0'")
	dw_edit.Modify(ls_headername[i_i] + ".background.color='16777215'")
	dw_edit.Modify(ls_headername[i_i] + ".protect='1'")
	dw_columnlist.setitem(l_row,'textorcolumn','Text')
	
	
next

//-----------------------------------------------------------------------------------------------------------------------------------
// Now build the real columns
//-----------------------------------------------------------------------------------------------------------------------------------
for i_i = 1 to upperbound(ls_columnname)
	l_row = dw_columnlist.insertrow(0)
	dw_columnlist.setitem(l_row,'objectname',ls_columnname[i_i])
	dw_columnlist.setitem(l_row,'objecttext',ls_headertext[i_i] + '(' + ls_columnname[i_i] + ')')
	dw_columnlist.setitem(l_row,'textorcolumn','Column')
	
	l_taborder =  long(dw_edit.Describe(ls_columnname[i_i] + ".TabSequence"))
	dw_columnlist.setitem(l_row,'taborder',l_taborder)
	

	s_value = dw_edit.Describe(ls_columnname[i_i] + ".Visible")
	choose case s_value

		case '1'
			dw_columnlist.setitem(l_row,'onoroff','Y')
			dw_columnlist.setitem(l_row,'originalonoroff','Y')
		case '0','"1	0"'
			dw_columnlist.setitem(l_row,'onoroff','N')
			dw_columnlist.setitem(l_row,'originalonoroff','N')
		case else
			dw_columnlist.setitem(l_row,'onoroff','F')
			dw_columnlist.setitem(l_row,'originalonoroff','F')
			dw_edit.Modify(ls_columnname[i_i]  + ".Visible='1'")
	end choose


	dw_edit.Modify(ls_columnname[i_i] + ".background.mode='0'")
	dw_edit.Modify(ls_headername[i_i] + ".background.color='16777215'")
	dw_edit.Modify(ls_columnname[i_i] + ".protect='1'")
	
next


//-----------------------------------------------------------------------------------------------------------------------------------
// Graphics
//-----------------------------------------------------------------------------------------------------------------------------------
ls_columnname[] =  ls_null
ln_datawindow_tools.of_get_objects ( dw_edit, 'bitmap', ls_columnname[], false )
for i_i = 1 to upperbound(ls_columnname)
	l_row = dw_columnlist.insertrow(0)
	dw_columnlist.setitem(l_row,'objectname',ls_columnname[i_i])
	dw_columnlist.setitem(l_row,'objecttext',ls_columnname[i_i])
	dw_columnlist.setitem(l_row,'textorcolumn','zBitmap')
	
	

	s_value = dw_edit.Describe(ls_columnname[i_i] + ".Visible")
	choose case s_value

		case '1'
			dw_columnlist.setitem(l_row,'onoroff','Y')
			dw_columnlist.setitem(l_row,'originalonoroff','Y')
		case '0','"1	0"'
			dw_columnlist.setitem(l_row,'onoroff','N')
			dw_columnlist.setitem(l_row,'originalonoroff','N')
		case else
			dw_columnlist.setitem(l_row,'onoroff','F')
			dw_columnlist.setitem(l_row,'originalonoroff','F')
			dw_edit.Modify(ls_columnname[i_i]  + ".Visible='1'")
	end choose


	dw_edit.Modify(ls_columnname[i_i] + ".background.mode='0'")
	
next

//-----------------------------------------------------------------------------------------------------------------------------------
// Finally let them edit the computes
//-----------------------------------------------------------------------------------------------------------------------------------
ls_columnname[] =  ls_null
ln_datawindow_tools.of_get_objects ( dw_edit, 'compute', ls_columnname[], false )
for i_i = 1 to upperbound(ls_columnname)
	l_row = dw_columnlist.insertrow(0)
	dw_columnlist.setitem(l_row,'objectname',ls_columnname[i_i])
	dw_columnlist.setitem(l_row,'objecttext',ls_columnname[i_i])
	dw_columnlist.setitem(l_row,'textorcolumn','zCompute')
	
	

	s_value = dw_edit.Describe(ls_columnname[i_i] + ".Visible")
	choose case s_value

		case '1'
			dw_columnlist.setitem(l_row,'onoroff','Y')
			dw_columnlist.setitem(l_row,'originalonoroff','Y')
		case '0','"1	0"'
			dw_columnlist.setitem(l_row,'onoroff','N')
			dw_columnlist.setitem(l_row,'originalonoroff','N')
		case else
			dw_columnlist.setitem(l_row,'onoroff','F')
			dw_columnlist.setitem(l_row,'originalonoroff','F')
			dw_edit.Modify(ls_columnname[i_i]  + ".Visible='1'")
	end choose


	dw_edit.Modify(ls_columnname[i_i] + ".background.mode='0'")
	
next


//All done
dw_columnlist.sort()
dw_columnlist.event rowfocuschanged(1)


destroy ln_datawindow_tools




//n_license_crypto ln_license_crypto
string s_return

//ln_license_crypto = create n_license_crypto
//s_return  = ln_license_crypto.of_verify_license_for_userandrole(gn_globals.is_username,'PowerUser License')

//if s_return  <> '' then 
	
//	gn_globals.in_messagebox.post of_messagebox_validation(s_return)
//	dw_columnlist.enabled = false
//	dw_edit.enabled = false
//	st_down.enabled = false
//	st_up.enabled = false	
//	
//end if
//destroy ln_license_crypto

end subroutine

on u_dynamic_gui_dw_configure.create
int iCurrent
call super::create
this.st_down=create st_down
this.st_up=create st_up
this.dw_edit=create dw_edit
this.dw_columnlist=create dw_columnlist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_down
this.Control[iCurrent+2]=this.st_up
this.Control[iCurrent+3]=this.dw_edit
this.Control[iCurrent+4]=this.dw_columnlist
end on

on u_dynamic_gui_dw_configure.destroy
call super::destroy
destroy(this.st_down)
destroy(this.st_up)
destroy(this.dw_edit)
destroy(this.dw_columnlist)
end on

event resize;call super::resize;dw_edit.height = this.height - dw_edit.y * 2
dw_columnlist.Height = dw_edit.Height - st_up.height  - 20
dw_edit.width = this.width - dw_edit.x

st_up.y = dw_columnlist.height + 20 + dw_columnlist.y
st_down.y = dw_columnlist.height + 20 + dw_columnlist.y
end event

event constructor;call super::constructor;

this.post triggerevent (resize!)


end event

event ue_refreshtheme();call super::ue_refreshtheme;st_up.backcolor = this.backcolor
st_down.backcolor = this.backcolor
end event

type st_down from u_hover_button within u_dynamic_gui_dw_configure
integer x = 425
integer y = 1088
integer width = 389
long textcolor = 16711680
string text = "Tab Order Down"
end type

event ue_mousemove;// override
end event

event ue_refreshtheme();// override
end event

event clicked;call super::clicked;long l_row,l_this_tab,l_swap_tab
string s_objectname,s_swap_objectname,s_syntax
l_row = dw_columnlist.getselectedrow(0)

if l_row = 0  or l_row = dw_columnlist.rowcount() then return

dw_columnlist.setredraw(false)

l_this_tab = dw_columnlist.getitemnumber(l_row,'taborder')
s_objectname = dw_columnlist.getitemstring(l_row,'objectname')
l_swap_tab = dw_columnlist.getitemnumber(l_row + 1,'taborder')
s_swap_objectname = dw_columnlist.getitemstring(l_row + 1,'objectname')

if l_this_tab = 0 or l_swap_tab = 0 or isnull(l_this_tab) or isnull(l_swap_tab) then
	dw_columnlist.setredraw(true)
	return
end if

dw_columnlist.setitem(l_row,'taborder',l_swap_tab)
dw_columnlist.setitem(l_row + 1,'taborder',l_this_tab)

s_syntax = s_swap_objectname + ".TabSequence=" + string(l_this_tab) 
s_syntax = dw_edit.modify(s_syntax)
s_syntax = s_objectname + ".TabSequence=" + string(l_swap_tab)
s_syntax = dw_edit.modify(s_syntax)

dw_columnlist.sort()
dw_columnlist.setredraw(true)
end event

type st_up from u_hover_button within u_dynamic_gui_dw_configure
integer x = 64
integer y = 1088
integer width = 329
long textcolor = 16711680
string text = "Tab Order Up"
end type

event ue_mousemove;// override
end event

event ue_refreshtheme();// override
end event

event clicked;call super::clicked;long l_row,l_this_tab,l_swap_tab
string s_syntax
string s_objectname,s_swap_objectname

l_row = dw_columnlist.getselectedrow(0)

if l_row <= 1 then return

dw_columnlist.setredraw(false)

l_this_tab = dw_columnlist.getitemnumber(l_row,'taborder')
s_objectname = dw_columnlist.getitemstring(l_row,'objectname')
l_swap_tab = dw_columnlist.getitemnumber(l_row - 1,'taborder')
s_swap_objectname = dw_columnlist.getitemstring(l_row - 1,'objectname')

if l_this_tab = 0 or l_swap_tab = 0 or isnull(l_this_tab) or isnull(l_swap_tab) then 
	dw_columnlist.setredraw(true)
	return
end if

dw_columnlist.setitem(l_row,'taborder',l_swap_tab)
dw_columnlist.setitem(l_row - 1,'taborder',l_this_tab)


s_syntax = s_swap_objectname + ".TabSequence=" + string(l_this_tab) 
s_syntax = dw_edit.modify(s_syntax)
s_syntax = s_objectname + ".TabSequence=" + string(l_swap_tab)
s_syntax = dw_edit.modify(s_syntax)

dw_columnlist.sort()
dw_columnlist.setredraw(true)
end event

type dw_edit from u_deal_display_datawindow within u_dynamic_gui_dw_configure
integer x = 969
integer y = 20
integer width = 2889
integer height = 1116
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event ue_refreshtheme;// override
end event

event clicked;call super::clicked;string s_object
long l_row

s_object = this.getobjectatpointer()
s_object = left(s_object,pos(s_object,'~t') - 1)

if this.describe(s_object + '.background.color') <> '12632256' then 
	
	l_row = dw_columnlist.find("objectname='" + s_object + "'",1,dw_columnlist.rowcount())
	
	dw_columnlist.scrolltorow(l_row)
	dw_columnlist.setrow(l_row)
end if






end event

event ue_dwnkey;long l_current_value

if is_currentobject = '' or isnull(is_currentobject) then return

if keydown(KeyDownArrow!)	then 	
	
		// PD, 2/23/2003. Added to be able to edit the height
	if keydown(keyshift!) then 
		l_current_value = long(this.describe(is_currentobject + ".height"))
		l_current_value = l_current_value + 3
		this.modify(is_currentobject + ".height = '" + string(l_current_value) + "'")
	else
		l_current_value = long(this.describe(is_currentobject + ".y"))
		l_current_value = l_current_value + 3
		this.modify(is_currentobject + ".y = '" + string(l_current_value) + "'")
	End if
end if 		
	
if keydown(KeyUpArrow!)	then 	

	// PD, 2/23/2003. Added to be able to edit the height
	if keydown(keyshift!) then 
		l_current_value = long(this.describe(is_currentobject + ".height"))
		l_current_value = l_current_value - 3
		this.modify(is_currentobject + ".height = '" + string(l_current_value) + "'")
	else
		l_current_value = long(this.describe(is_currentobject + ".y"))
		l_current_value = l_current_value -  3
		if l_current_value < 0 then l_current_value = 0 
		this.modify(is_currentobject + ".y = '" + string(l_current_value) + "'")
	End if
	
end if 		
	
	
if keydown(KeyRightArrow!)	then 	

	if keydown(keyshift!) then 
		l_current_value = long(this.describe(is_currentobject + ".width"))
		l_current_value = l_current_value + 3
		this.modify(is_currentobject + ".width = '" + string(l_current_value) + "'")
	else
		l_current_value = long(this.describe(is_currentobject + ".x"))
		l_current_value = l_current_value + 3
		this.modify(is_currentobject + ".x = '" + string(l_current_value) + "'")
	end if
		
end if 		
	
	
if keydown(KeyLeftArrow!)	then 	

	if keydown(keyshift!) then 
		l_current_value = long(this.describe(is_currentobject + ".width"))
		l_current_value = l_current_value - 3
		if l_current_value < 0 then l_current_value = 0 
		this.modify(is_currentobject + ".width = '" + string(l_current_value) + "'")
	else
		l_current_value = long(this.describe(is_currentobject + ".x"))
		l_current_value = l_current_value - 3
		if l_current_value < 0 then l_current_value = 0 
		this.modify(is_currentobject + ".x = '" + string(l_current_value) + "'")
	end if
end if 		
	
end event

type dw_columnlist from u_deal_display_datawindow within u_dynamic_gui_dw_configure
integer x = 46
integer y = 20
integer width = 896
integer height = 1052
integer taborder = 10
string dataobject = "d_datawindow_configure_columnlist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event ue_refreshtheme;// override
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 or currentrow > this.rowcount() then return 

if not ib_multiselect then
	this.selectrow(0,false)
	this.selectrow(currentrow,true)
end if

if is_currentobject <> '' then 
	dw_edit.Modify(is_currentobject + ".Moveable='0'")
	dw_edit.Modify(is_currentobject + ".Background.Color='16777215'")
end if

is_currentobject = this.getitemstring(currentrow,'objectname')

dw_edit.SetPosition(is_currentobject, "detail", TRUE)
dw_edit.Modify(is_currentobject + ".Moveable='1'")
dw_edit.Modify(is_currentobject + ".Background.Color=12632256")



end event

event itemchanged;call super::itemchanged;long l_max_y
string s_object

if row = 0 then return 

if this.getcolumnname() = 'onoroff' then 
	
	s_object = this.getitemstring(row,'objectname')
	
	l_max_y = of_find_max_y(s_object)
	
	if gettext() = 'Y' then 
		dw_edit.Modify(s_object + ".Visible='1'")
		if this.getitemstring(row,'originalonoroff') = 'N' then 
			dw_edit.Modify(s_object + ".x='1'")
			dw_edit.Modify(s_object + ".y='" + string(l_max_y + 100) + "'")
		end if
	else
		dw_edit.Modify(s_object + ".Visible='0'")
	end if

end if

end event

event rbuttondown;call super::rbuttondown;m_dynamic lm_menu,lm_attrs
menu lm_cascade_menu,lm_menu_temp
string s_columnname
long i_i,ll_upperbound
//n_string_functions ln_string

if not isvalid(ds_datastore) then return 

lm_menu = create m_dynamic
lm_menu.of_set_object ( this)


lm_menu_temp = lm_menu.of_add_item (lm_menu, 'Edit Text', 'edit', 'edit' )
if this.getitemstring(this.getselectedrow(0),'textorcolumn') <> 'Text' then 
	lm_menu_temp.enabled = false
end if


lm_attrs = Create m_dynamic
lm_attrs.of_set_object(This)
lm_attrs.of_add_item('-','','')
lm_cascade_menu = lm_attrs.of_add_item('Add External Attribute', '', '')
	
ll_upperbound = UpperBound(lm_menu.item)
lm_menu.item[ll_upperbound + 1] = lm_attrs.item[1]
lm_menu.item[ll_upperbound + 2] = lm_attrs.item[2]


for i_i = 1 to ds_datastore.rowcount()
	
	s_columnname = ds_datastore.getitemstring(i_i,'GnrlCnfgQlfr') 
	
	gn_globals.in_string_functions.of_replace_all(s_columnname,' ','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'\','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'/','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,':','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,',','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'=','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'-','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'_','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'.','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'&','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'%','')
	
	lm_menu.of_add_item (lm_cascade_menu, 'Add ' + s_columnname + ' Attribute', s_columnname, '' )
	
next



lm_menu.popmenu(of_getparentwindow().pointerx(),of_getparentwindow().pointery())
lm_menu.of_destroy()

destroy lm_menu
end event

event ue_notify(string as_message, any aany_argument);call super::ue_notify;n_dw_configure ln_configure
string s_syntax,s_value
long l_taborder,i_i


if lower(as_message)  = 'edit' then 
	
	if this.getitemstring(this.getselectedrow(0),'textorcolumn') = 'Text' then 
		s_value = this.getitemstring(this.getselectedrow(0),'objecttext')
		
		openwithparm(w_text_edit_basic,s_value,of_getparentwindow())
		s_value = message.stringparm
		if s_value <> '' then 
			dw_edit.Modify(this.getitemstring(this.getselectedrow(0),'objectname') + ".text='" + s_value + "'")
			this.setitem(this.getselectedrow(0),'objecttext',s_value)
		end if
	end if
	
else
		
	ln_configure = create n_dw_configure
	ln_configure.of_add_attributecolumn(dw_edit,is_tablename,as_message)
	destroy ln_configure
	
	for i_i  = 1 to this.rowcount()
		if this.getitemnumber(i_i,'taborder') > l_taborder then 
			l_taborder = this.getitemnumber(i_i,'taborder')
		end if
	next
	
	s_syntax = as_message + "attribute.TabSequence=" + string(l_taborder + 10)
	s_syntax = dw_edit.modify(s_syntax)
	
	of_init('','')

end if

end event

