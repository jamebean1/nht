$PBExportHeader$u_dynamic_gui_reference_gui.sru
forward
global type u_dynamic_gui_reference_gui from u_search
end type
type tabgrp1_main from u_tabcntrl within u_dynamic_gui_reference_gui
end type
type tabgrp1_comments from u_tabcntrl within u_dynamic_gui_reference_gui
end type
type tabgrp1_attrs from u_tabcntrl within u_dynamic_gui_reference_gui
end type
type r_tab_background from rectangle within u_dynamic_gui_reference_gui
end type
type uo_attributes from u_dynamic_gui_reference_gui_attributes within u_dynamic_gui_reference_gui
end type
type mle_comment from multilineedit within u_dynamic_gui_reference_gui
end type
end forward

global type u_dynamic_gui_reference_gui from u_search
integer width = 3008
integer height = 3152
event ue_update ( )
event ue_new ( )
event ue_checkout ( )
event ue_delete ( )
event ue_copy ( )
event ue_validation ( long al_row,  string as_type,  string as_column )
event type string ue_getreporttype ( )
tabgrp1_main tabgrp1_main
tabgrp1_comments tabgrp1_comments
tabgrp1_attrs tabgrp1_attrs
r_tab_background r_tab_background
uo_attributes uo_attributes
mle_comment mle_comment
end type
global u_dynamic_gui_reference_gui u_dynamic_gui_reference_gui

type variables
private:

boolean ib_allow_update = true
string is_daoObjectname
long il_value 

protected:
long il_securitylevel

public:
boolean ib_zeroisvalid = false
end variables

forward prototypes
public subroutine of_set_daoobjectname (string as_dao)
end prototypes

event ue_update();string s_message,s_error

if isvalid(in_dao) then 
	
	if in_dao.getitemstatus(1,0,Primary!) = NewModified! then
		s_message = 'ItemAdded'
	else
		s_message = 'ItemUpdated'
	end if 
	
	s_error = in_dao.dynamic of_save()
	
	if s_error <> '' then
		gn_globals.in_messagebox.of_messagebox_validation(s_error)
		return
	end if
	If isvalid(iu_criteria) then
		iu_criteria.event ue_notify(s_message,in_dao.getitemnumber(1,1))
	End If
this.event ue_notify(s_message,in_dao.getitemnumber(1,1))	//ceb 6-3-03
end if

end event

event ue_new();string s_error

if is_daoObjectname <> '' then 			
	// we can always destroy the DAO as we have already checked for changes.	
	if isvalid(in_dao) then 
		
		// Check in the checked out object.
		destroy in_dao
		
	end if
	
	in_dao = Create Using is_daoobjectname
	in_dao.of_Settransobject(sqlca)
	in_dao.dynamic of_new()

	in_dao.of_getmessageobject().of_setclientobject(this)
	this.event ue_display()
	//New
	
	uo_titlebar.of_enable_button ( 'Save', true)
	ib_allow_update = true
	
end if

end event

event ue_delete();string s_message,s_error
n_dao_reference_data ln_dao

if isvalid(in_dao) then 
	if gn_globals.in_messagebox.of_messagebox_question("Are you sure you want to delete",YesNo!,2) = 2 then return
	s_error = in_dao.dynamic of_delete()
	
	if s_error <> '' then
		gn_globals.in_messagebox.of_messagebox_validation(s_error)
		this.event ue_retrieve()
		return
	end if
	
	if isvalid (iu_criteria) then
			iu_criteria.event ue_notify ('ItemDeleted','')
	end if
end if

end event

event ue_copy();string s_message,s_error

if isvalid(in_dao) then 
	uo_titlebar.of_enable_button ( 'Save', true)
	ib_allow_update = true
	s_error = in_dao.dynamic of_copy()
end if

this.event ue_display()
end event

event type string ue_getreporttype();Return 'maintenance window'
end event

public subroutine of_set_daoobjectname (string as_dao);is_daoobjectname = as_dao
end subroutine

on u_dynamic_gui_reference_gui.create
int iCurrent
call super::create
this.tabgrp1_main=create tabgrp1_main
this.tabgrp1_comments=create tabgrp1_comments
this.tabgrp1_attrs=create tabgrp1_attrs
this.r_tab_background=create r_tab_background
this.uo_attributes=create uo_attributes
this.mle_comment=create mle_comment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabgrp1_main
this.Control[iCurrent+2]=this.tabgrp1_comments
this.Control[iCurrent+3]=this.tabgrp1_attrs
this.Control[iCurrent+4]=this.r_tab_background
this.Control[iCurrent+5]=this.uo_attributes
this.Control[iCurrent+6]=this.mle_comment
end on

on u_dynamic_gui_reference_gui.destroy
call super::destroy
destroy(this.tabgrp1_main)
destroy(this.tabgrp1_comments)
destroy(this.tabgrp1_attrs)
destroy(this.r_tab_background)
destroy(this.uo_attributes)
destroy(this.mle_comment)
end on

event ue_post_initialize();call super::ue_post_initialize;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_post_initialize
//	Overrides:  YES
//	Arguments:	
//	Overview:   Send the selection dw name to the criteria object to display
//	Created by: Jake Pratt
//	History:    4/11/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


If Len(Properties.DataObjectName) > 0 Then
	If IsValid(iu_criteria) then
		iu_criteria.event ue_notify ('SelectionDataWindow', dw_report.dataobject)
	End If
//uo_titlebar.of_rename_button('Criteria', 'Show List')
	uo_titlebar.of_hide_button('Criteria', True)
Else
	uo_titlebar.of_hide_button('Criteria', True)
End If
uo_titlebar.of_hide_button('Retrieve', True)

end event

event ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_filters
//	Overrides:  YES
//	Arguments:	
//	Overview:   Since we are not showing filters on the GUI, send themessage to the criteria object to show its filters.
//	Created by: Jake Pratt
//	History:    4/11/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string
string ls_string[]
long ll_row
string ls_type,ls_column

Choose Case lower(as_message)
		
	Case 'button clicked', 'menucommand'
		
		
		Choose Case Lower(String(as_arg))
			//----------------------------------------------------------------------------------------------------------------------------------
			// Title bar button messages
			//-----------------------------------------------------------------------------------------------------------------------------------
			Case 'save data'
				
				this.event ue_update()

				
			Case 'filters'
				if isvalid (iu_criteria) then
					iu_criteria.event ue_notify ('Toggle Filters','')
				end if
				
			case 'print'
				if isvalid (iu_criteria) then
					iu_criteria.event ue_notify ('Print','')
				end if
				
			Case 'new'
				
				if this.event ue_close() = 1 then return 
				if isvalid (iu_criteria) then
					iu_criteria.event ue_notify ('New','')
				end if
					
				this.event ue_new()

				
			Case 'duplicate'
				
				if this.event ue_close() = 1 then return 				
				this.event ue_copy()
				if isvalid(iu_criteria) then
					iu_criteria.event ue_notify('duplicate','')
				end if 
		
			Case 'delete'
				this.event ue_delete()
				
			case else
					
				call super::ue_notify
		
	end choose
	
	
			
	Case 'retrieve'
		
		il_value = long (as_arg)
		this.event ue_retrieve()

	Case 'validation'
		
		
		gn_globals.in_string_functions.of_parse_string( string(as_arg), '||', ls_string[])

		ll_row = long(ls_string[1])
		ls_type = lower(ls_string[2])
		ls_column = ls_string[3]

		this.event ue_validation(ll_row,ls_type,ls_column)
	
	
	case else
				
		call super::ue_notify
		
		
		
end choose
				


end event

event ue_filters;//Override to prevent local filters from showing.
end event

event resize;call super::resize;long i_i
u_tabcntrl lu_control

if isvalid(iu_criteria) then
	iu_criteria.width = this.width
end if 

For i_i = 1 to upperbound(control)
	if left(control[i_i].classname(),7) = 'tabgrp1' then 
		lu_control = control[i_i]
		lu_control.y = st_separator.y + 30
	end if
next



r_Tab_background.y = tabgrp1_main.y  + tabgrp1_main.height - 3
r_Tab_background.height  = this.height - r_Tab_background.y - 30
r_Tab_background.width  = this.width - (r_Tab_background.x * 2)- 5


mle_comment.y = r_Tab_background.y + 30
mle_comment.resize(r_Tab_background.width - 90,r_Tab_background.height - 60)

uo_attributes.y = r_Tab_background.y + 30
uo_attributes.resize(mle_comment.width,mle_comment.height)
end event

event type long ue_close();call super::ue_close;string s_error,s_message

if not isvalid(in_dao)  or ib_allow_update = false or il_securitylevel <=1 then return 0
if in_dao.dynamic of_changed() then 
	
	choose Case gn_globals.in_messagebox.of_messagebox_question ( 'You have made changes, would you like to save before closing', YesNoCancel!, 1 )
			
		Case 1


			//----------------------------------------------------------------------------------------------------------------------------------
			// Please note that with our intervention changes to the deal are saved automatically when this event is triggered.
			//-----------------------------------------------------------------------------------------------------------------------------------
			if in_dao.getitemstatus(1,0,Primary!) = NewModified! then
				s_message = 'ItemAdded'
			else
				s_message = 'ItemUpdated'
			end if 
			
			s_error = in_dao.dynamic of_save()
			
			if s_error <> '' then
				gn_globals.in_messagebox.of_messagebox_validation(s_error)
				return 1
			end if
			
			If isvalid(iu_criteria) then
				iu_criteria.event ue_notify(s_message,in_dao.getitemnumber(1,1))
			End If
			return 0
			
			
		Case 3
			
			Return 1
			
	End Choose
	
end if

return 0
end event

event destructor;call super::destructor;
if isvalid(in_dao) then destroy in_dao
end event

event ue_retrieve();string s_message


if isvalid(in_dao) then 
	destroy in_dao
end if

if isnull(il_value) or (not ib_zeroisvalid and il_value = 0) then
		triggerevent('ue_new')
		return
end if

if is_daoObjectName = '' then 
	messagebox("Error","You have not filled in the variable called is_daoObjectName.  This stores the name of the DAO object for this module")
	return
end if

in_dao = create using is_daoObjectName
in_dao.of_Settransobject(sqlca)
in_dao.of_getmessageobject().of_setclientobject(this)

s_message = in_dao.dynamic of_retrieve(il_value) 

if s_message <> '' then 
	gn_globals.in_messagebox.of_messagebox_validation(s_message)
	uo_titlebar.of_enable_button ( 'Save', false)
	uo_titlebar.of_enable_button ( 'Delete', false)
	ib_allow_update = false
else
	uo_titlebar.of_enable_button ( 'Save', true)
	uo_titlebar.of_enable_button ( 'Delete', true)
	ib_allow_update = true
end if



this.event ue_display()


end event

event ue_refreshtheme;call super::ue_refreshtheme;r_tab_background.fillcolor = gn_globals.in_theme.of_get_backcolor()
this.backcolor = gn_globals.in_theme.of_get_backcolor()
end event

event ue_display;call super::ue_display;mle_comment.text = in_dao.of_getitem(1,'Comment')
uo_attributes.of_setdao(in_dao)
uo_attributes.is_gctype = in_dao.dynamic of_get_qualifier()
uo_attributes.of_show_attributes()
end event

type dw_report from u_search`dw_report within u_dynamic_gui_reference_gui
boolean visible = false
integer y = 2824
integer width = 2226
end type

type uo_titlebar from u_search`uo_titlebar within u_dynamic_gui_reference_gui
end type

event uo_titlebar::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  Yes
// Overview:   Add the standard buttons to the title bar
// Created by: Blake Doerr
// History:    12/16/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


st_title.Text = ''
#IF  defined PBDOTNET THEN
	THIS.EVENT resize(0, width, height)
#ELSE
	TriggerEvent('Resize')
#END IF
TriggerEvent('ue_refreshtheme')

il_title_indention = This.X

io_parent = Parent

//il_securitylevel = gn_globals.in_security.of_get_security(parent.classname())
//Choose Case il_securitylevel
		
//	case 3

		This.of_add_button('Save', 'save data')
		This.of_add_button('Filters', 'filters')
		This.of_add_button('Delete', 'Delete')
		This.of_add_button('Duplicate', 'Duplicate')
		This.of_add_button('New', 'new')

//	case 2

//		This.of_add_button('Save', 'save data')
//		This.of_add_button('Filters', 'filters')
//		This.of_add_button('Duplicate', 'Duplicate')
//		This.of_add_button('New', 'new')
//		
//	case else
//		
//		This.of_add_button('Filters', 'filters')
//		
//		
//end choose
//


end event

type st_separator from u_search`st_separator within u_dynamic_gui_reference_gui
boolean visible = false
integer height = 4
end type

type tabgrp1_main from u_tabcntrl within u_dynamic_gui_reference_gui
integer x = 32
integer y = 100
integer width = 530
integer height = 68
integer taborder = 11
boolean bringtotop = true
boolean enabled = true
end type

on tabgrp1_main.destroy
call u_tabcntrl::destroy
end on

event constructor;call super::constructor;this.st_tab_txt.Text="Main"
this.st_tab_txt.PostEvent(Clicked!)
end event

type tabgrp1_comments from u_tabcntrl within u_dynamic_gui_reference_gui
integer x = 576
integer y = 100
integer width = 530
integer height = 68
integer taborder = 21
boolean bringtotop = true
boolean enabled = true
end type

on tabgrp1_comments.destroy
call u_tabcntrl::destroy
end on

event constructor;call super::constructor;this.st_tab_txt.Text="Comments"
this.igo_tab_cntrl_lst[1]=mle_comment

end event

type tabgrp1_attrs from u_tabcntrl within u_dynamic_gui_reference_gui
integer x = 1120
integer y = 100
integer width = 530
integer height = 68
integer taborder = 31
boolean bringtotop = true
boolean enabled = true
end type

event constructor;call super::constructor;this.st_tab_txt.Text="Attributes"
this.igo_tab_cntrl_lst[1]=uo_attributes

end event

on tabgrp1_attrs.destroy
call u_tabcntrl::destroy
end on

event ue_tabpstclckd;call super::ue_tabpstclckd;uo_attributes.of_fill_dropdowns()
end event

type r_tab_background from rectangle within u_dynamic_gui_reference_gui
long linecolor = 8421504
integer linethickness = 1
long fillcolor = 12632256
integer x = 32
integer y = 168
integer width = 2363
integer height = 2280
end type

type uo_attributes from u_dynamic_gui_reference_gui_attributes within u_dynamic_gui_reference_gui
boolean visible = false
integer x = 73
integer y = 208
integer taborder = 31
end type

on uo_attributes.destroy
call u_dynamic_gui_reference_gui_attributes::destroy
end on

type mle_comment from multilineedit within u_dynamic_gui_reference_gui
event ue_keydown pbm_keydown
boolean visible = false
integer x = 78
integer y = 220
integer width = 411
integer height = 324
integer taborder = 21
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 4096
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;This.postevent(modified!)
end event

event modified;in_dao.of_setitem(1,'Comment',this.text)
end event

