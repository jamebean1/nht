$PBExportHeader$u_treeview.sru
$PBExportComments$Base level treeview control
forward
global type u_treeview from treeview
end type
end forward

global type u_treeview from treeview
integer width = 878
integer height = 1024
integer taborder = 1
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean border = false
integer accelerator = 109
boolean linesatroot = true
long statepicturemaskcolor = 553648127
event ue_init ( )
event ue_vscroll pbm_vscroll
event ue_dwnvscroll pbm_dwnvscroll
event ue_postinit ( )
end type
global u_treeview u_treeview

type variables
   n_treeview_manager in_treeview_manager
protected:
  string is_dw_SQL = '', is_expanding_sql
  string is_nv_treeview_control = 'n_treeview_manager'
  boolean ib_dataobject = True, ib_expanding_sql_isdataobject = False
  boolean ib_retrieve_on_expand = False
  integer ii_root_level_id = 0
  long il_current_handle
end variables

forward prototypes
public function string of_get_tv_name ()
public function string of_get_dw_sql ()
public subroutine of_set_dw_sql (string as_dw_sql, boolean ab_dataobject)
public function integer of_get_root_level_id ()
public function boolean of_get_is_dataobject ()
public subroutine of_set_root_level_id (integer ai_root_level)
public subroutine of_set_tv_control (string as_tv_control)
public function long of_get_current_handle ()
public subroutine of_expand_all ()
public subroutine of_refresh ()
public subroutine of_init ()
public subroutine of_delete_treeviewitem (long handle)
public subroutine of_set_expanding_sql (string as_expanding_sql, boolean ab_isdataobject)
end prototypes

event ue_init;call super::ue_init;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_init
// Overrides:  No
// Overview:   Used to set overriding parameters used during the constructor event.
//					Functions:  of_set_dw_sql(string, boolean) - Stores the syntax used by the controlling nvo to
//															to create the dataobject which is used to build
//															the treeview.  The boolean indicates whether or not the
//															the syntax is dataobect or SQL syntax.
//									of_set_tv_control(string) - Stores the name of the controlling nvo if it
//																		 is different than the base.
//									of_set_root_level_id(int) - Set the starting point for the building of the treeviewcontrol
// Created by: Blake Doerr
// History:    12/05/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


end event

public function string of_get_tv_name ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_tv_name
// Arguments:   none
// Overview:    Returns the name of the controlling nvo
// Created by:  Pat Newgent
// History:     12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_nv_treeview_control
end function

public function string of_get_dw_sql ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_dw_sql()
// Arguments:   none
// Overview:    Returns the datawindow syntax 
// Created by:  Pat Newgent
// History:     12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_dw_sql
end function

public subroutine of_set_dw_sql (string as_dw_sql, boolean ab_dataobject);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_dw_sql()
// Arguments:   as_dw_sql - The syntax used to create the datastore which builds the Treeview control
//					 ab_dataobject - Whether syntax provided was a dataobject or SQL syntax
// Overview:    Stores the syntax to be used latter to build the datastore which builds the Treeview control
// Created by:  Pat Newgent
// History:     12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_dw_sql = as_dw_sql
ib_dataobject = ab_dataobject
Return
end subroutine

public function integer of_get_root_level_id ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_root_level_id()
// Arguments:   none
// Overview:    Returns the starting point for building the treeview control
// Created by:  Pat Newgent
// History:     12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ii_root_level_id
end function

public function boolean of_get_is_dataobject ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_is_dataobject()
// Arguments:   none
// Overview:    Returns boolean indicating whether or not is_dw_sql is a dataobject or not
//					 True - Dataobject
//					 False - SQL Syntax
// Created by:  Pat Newgent
// History:     12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ib_dataobject
end function

public subroutine of_set_root_level_id (integer ai_root_level);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_root_level_id
// Arguments:   ai_root_level - The root level parent id for the treeview
// Overview:    Stores the root level parent id for the treeview control.
//					 This is the starting point for the building of the treeview control.
// Created by:  Pat Newgent
// History:     12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ii_root_level_id = ai_root_level
Return
end subroutine

public subroutine of_set_tv_control (string as_tv_control);is_nv_treeview_control = as_tv_control

Return
end subroutine

public function long of_get_current_handle ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_current_handle()
// Arguments:   none
// Overview:    Returns the treeviews current handle
// Created by:  Pat Newgent
// History:     12/19/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return il_current_handle
end function

public subroutine of_expand_all ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_expand_all
// Arguments:   none
// Overview:    Redirect the expand all request to the controlling nvo.
// Created by:  Pat Newgent
// History:     12/19/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

in_treeview_manager.of_expand_all()
Return
end subroutine

public subroutine of_refresh ();This.SetRedraw(False)
in_treeview_manager.of_refresh()
This.SetRedraw(True)

end subroutine

public subroutine of_init ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_init()
// Overrides:  No
// Overview:   Calls ue_init to established implementation specific parameters
// Created by: Blake Doerr
// History:    12/05/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Initialize the controlling nvo
//-----------------------------------------------------
If IsValid(in_treeview_manager) Then Destroy in_treeview_manager

//-----------------------------------------------------
// Trigger the event 'ue_init', this is where the developer
// will specify:
//			The datawindow object used to build the tree.
//			The root level id if different than zero.
//			A controlling nvo if different than the base.
//-----------------------------------------------------
This.SetRedraw(False)
long tvi_hdl = 0

DO UNTIL This.FindItem(RootTreeItem!, 0) = -1
	This.DeleteItem(tvi_hdl)
LOOP

This.Event ue_init()

//-----------------------------------------------------
// Initialize the controlling nvo
//-----------------------------------------------------
in_treeview_manager = Create Using of_get_tv_name()

//-----------------------------------------------------
// Attach the controlling nvo.
//-----------------------------------------------------
in_treeview_manager.of_init(this, of_get_dw_sql(), of_get_is_dataobject())

If ib_retrieve_on_expand Then
	in_treeview_manager.of_set_expanding_sql(is_expanding_sql, ib_expanding_sql_isdataobject)
End If

This.Event ue_postinit()
This.SetRedraw(True)
//-----------------------------------------------------
// Place the following line in constructor event
// of the instance of treeview control.  This
// allows certain attributes of n_treeview_control
// to be overridden before the treeview is built.
//-----------------------------------------------------
//inv_treeview_control.of_build_tree(of_get_root_level_id())
end subroutine

public subroutine of_delete_treeviewitem (long handle);This.DeleteItem(handle)

If Not IsValid(in_treeview_manager) Then Return

in_treeview_manager.of_delete_treeviewitem(Handle)
end subroutine

public subroutine of_set_expanding_sql (string as_expanding_sql, boolean ab_isdataobject);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_expanding_sql()
//	Arguments:  as_expanding_sql - the sql for the expanding data
//					ab_isdataobject - Whether or not the sql represents a dataobject
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	9.10.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_expanding_sql = as_expanding_sql
ib_expanding_sql_isdataobject = ab_isdataobject
ib_retrieve_on_expand = True

If IsValid(in_treeview_manager) Then in_treeview_manager.of_set_expanding_sql(as_expanding_sql, ab_isdataobject)
end subroutine

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      constructor
// Overrides:  No
// Overview:   Calls ue_init to established implementation specific parameters
//					Initilizes the controlling nvo
//					Builds the TreeView
// Created by: Blake Doerr
// History:    12/05/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Initialize the treeview
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_init()
end event

event selectionchanged;call super::selectionchanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      selectionchanged
// Overrides:  No
// Overview:   store the handle for the new treeviewitem
// Created by: Pat Newgent
// History:    12/19/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

il_current_handle = newhandle

end event

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Itemchanged
// Overrides:  No
// Overview:   If the user doubleclicks in empty space the doubleclick still fires with the handle of the 
//					treeview item at that vertical position.  However, the treeview selectionchanged event does not
// 				fire.  Therefore, we select the item here to prevent the selected treeview item not being the 
//					current treeview item.
//             
// Created by: Blake Doerr
// History:    01/31/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If Handle > 0 then This.SelectItem(handle)

end event

event destructor;call super::destructor;Destroy in_treeview_manager
end event

event itemexpanding;call super::itemexpanding;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ItemExpanding
//	Overrides:  No
//	Arguments:	
//	Overview:   This will retrieve the children for a treeview item
//	Created by: Blake Doerr
//	History:    9.10.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If ib_retrieve_on_expand Then
	in_treeview_manager.of_expand_folder(handle)
End If
end event

on u_treeview.create
end on

on u_treeview.destroy
end on

