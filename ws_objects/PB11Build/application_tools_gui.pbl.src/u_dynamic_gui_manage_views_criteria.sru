$PBExportHeader$u_dynamic_gui_manage_views_criteria.sru
forward
global type u_dynamic_gui_manage_views_criteria from u_dynamic_gui_manage_views
end type
end forward

global type u_dynamic_gui_manage_views_criteria from u_dynamic_gui_manage_views
string text = "Criteria Views"
long tabbackcolor = 81448892
string picturename = "Module - Reporting Desktop - Criteria View.bmp"
end type
global u_dynamic_gui_manage_views_criteria u_dynamic_gui_manage_views_criteria

on u_dynamic_gui_manage_views_criteria.create
call super::create
end on

on u_dynamic_gui_manage_views_criteria.destroy
call super::destroy
end on

event constructor;call super::constructor;ib_GloballyAvailableIsAnOption	= True
is_bitmap_column						= 'ItemIcon'
is_description_column				= 'Name'
is_username_column					= 'UserID'
is_dataobjectname						= 'd_manage_view_criteria_defaults'
is_argument_to_publish				= 'CriteriaView'
end event

type cbx_default_view from u_dynamic_gui_manage_views`cbx_default_view within u_dynamic_gui_manage_views_criteria
end type

type cbx_globallyavailable from u_dynamic_gui_manage_views`cbx_globallyavailable within u_dynamic_gui_manage_views_criteria
end type

type lv_doctypes from u_dynamic_gui_manage_views`lv_doctypes within u_dynamic_gui_manage_views_criteria
end type

