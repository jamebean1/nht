$PBExportHeader$u_dynamic_gui.sru
forward
global type u_dynamic_gui from userobject
end type
end forward

shared variables

end variables

global type u_dynamic_gui from userobject
integer width = 2533
integer height = 1516
boolean border = true
long backcolor = 16777215
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
event resize pbm_size
event ue_getdata ( )
event ue_setdao ( )
event ue_display ( )
event ue_mouseover pbm_mousemove
event ue_refreshtheme ( )
event ue_notify ( string as_message,  any as_arg )
event type long ue_close ( )
event ue_showmenu ( )
event type long ue_gethelpid ( )
end type
global u_dynamic_gui u_dynamic_gui

type prototypes
function long SetParent ( Long  hWndChild , long hWndNewParent) library  "user32.dll"
end prototypes

type variables
long il_xpos,il_ypos
graphicobject io_parent
dragobject iu_deal[]
n_dao in_dao

boolean ib_deleted = true



end variables

forward prototypes
public function window of_getparentwindow ()
public subroutine of_display ()
public function dragobject of_openuserobject (string s_objectname, integer l_x, integer l_y)
public subroutine of_setdao (n_dao an_dao)
public subroutine of_hide ()
public subroutine of_closeuserobject (dragobject au_object)
end prototypes

event ue_mouseover;
//If not gb_runningasaservice Then
//	//----------------------------------------------------------------------------------------------------------------------------------
//	//  Send a message to clear any highlighted hover buttons
//	//-----------------------------------------------------------------------------------------------------------------------------------
////	gn_globals.in_theme.of_clear_hoverhighlight()
//End If
end event

event ue_refreshtheme();
//If not gb_runningasaservice Then
	long ll_array,ll_count
	
//	this.backcolor = gn_globals.in_theme.of_get_backcolor()
	
	ll_array=UpperBound(control)
	for ll_count = 1 to ll_array
			if isvalid(control[ll_count]) then
				control[ll_count].triggerevent('ue_refreshtheme')
			end if
	next
	
	
	ll_array=UpperBound(iu_deal)
	for ll_count = 1 to ll_array
		
		if isvalid(iu_deal[ll_count]) then
			iu_deal[ll_count].triggerevent('ue_refreshtheme')
		end if
		
	next
//End If
end event

event ue_close;return 0
end event

event type long ue_gethelpid();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_gethelpid
//	Overrides:  No
//	Arguments:	
//	Overview:   Stub function to return help id for objects inherited from u_dynamic_gui
//	Created by: Gary Howard
//	History:    2002-06-26 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_null

SetNull(l_null)

Return l_null
end event

public function window of_getparentwindow ();graphicobject	lgo_parent
window iw_return
lgo_parent = this.getparent()


//----------------------------------------------------------------------------------------------------------------------------------
// Find the ultimate parent window and return it.
//-----------------------------------------------------------------------------------------------------------------------------------
DO WHILE lgo_parent.TypeOf() <> Window!	
	lgo_parent = lgo_parent.GetParent()
LOOP

iw_return = lgo_parent
Return iw_return
end function

public subroutine of_display ();graphicobject lgo_graphic
u_dynamic_gui	lgo_parent


//----------------------------------------------------------------------------------------------------------------------------------
// Bring this object to the top and bring any objects that this object sits on top of to the dop two.
//-----------------------------------------------------------------------------------------------------------------------------------
this.bringtotop = true
this.visible = true

lgo_graphic = this.io_parent

DO WHILE lgo_graphic.TypeOf() <> Window!	
	lgo_parent = lgo_graphic
	lgo_parent.bringtotop = true
	lgo_parent.visible = true
	lgo_graphic = lgo_parent.io_parent
LOOP

//----------------------------------------------------------------------------------------------------------------------------------
// This is a place for the developer to place his or her display logic.
//-----------------------------------------------------------------------------------------------------------------------------------
this.triggerevent('ue_display')
end subroutine

public function dragobject of_openuserobject (string s_objectname, integer l_x, integer l_y);//----------------------------------------------------------------------------------------------------------------------------------
// Open a user object on the surface of this object.
//-----------------------------------------------------------------------------------------------------------------------------------
dragobject iu_object
window lw_window 
u_dynamic_gui iu_gui
long l_upperbound 


//----------------------------------------------------------------------------------------------------------------------------------
// Call the PB function to open the object
//-----------------------------------------------------------------------------------------------------------------------------------
lw_window = of_getparentwindow(this)
lw_window.OpenUserObject(iu_object,s_objectname,-30000,-30000)

//----------------------------------------------------------------------------------------------------------------------------------
// Call an API Call to place opened object on this one
//-----------------------------------------------------------------------------------------------------------------------------------
SetParent(handle(iu_object),handle(this))


//----------------------------------------------------------------------------------------------------------------------------------
// Position the object 
//-----------------------------------------------------------------------------------------------------------------------------------
iu_object.x = l_x
iu_object.y = l_y



//----------------------------------------------------------------------------------------------------------------------------------
// These variables must be saved to correctly close the child objects.
//-----------------------------------------------------------------------------------------------------------------------------------
if iu_object.typeof() = userobject! then
	choose case left(iu_object.classname(),5)
		case 'u_dyn', 'u_sea'
			iu_gui = iu_object
			iu_gui.io_parent = this
	end choose
end if
l_upperbound = upperbound(iu_deal)
l_upperbound++
iu_deal[l_upperbound] = iu_object



return iu_object
end function

public subroutine of_setdao (n_dao an_dao);//----------------------------------------------------------------------------------------------------------------------------------
// Save a reference to the dao and trigger the event in case the developer has his own code.
//-----------------------------------------------------------------------------------------------------------------------------------
in_dao = an_dao
this.triggerevent ('ue_setdao')





end subroutine

public subroutine of_hide ();long i_i
u_dynamic_gui	lgo_parent


//----------------------------------------------------------------------------------------------------------------------------------
// Bring this object to the top and bring any objects that this object sits on top of to the dop two.
//-----------------------------------------------------------------------------------------------------------------------------------
this.visible = false

for i_i = 1 to upperbound(iu_deal)
	if isvalid(iu_deal[i_i]) then
		if left(iu_deal[i_i].classname(),5) = 'u_dyn' then
			iu_deal[i_i].dynamic of_hide()
		end if
	end if
next



for i_i = 1 to upperbound(control)
	if isvalid(control[i_i]) then
		if left(control[i_i].classname(),5) = 'u_dyn' then
			control[i_i].dynamic of_hide()
		end if
	end if
next

end subroutine

public subroutine of_closeuserobject (dragobject au_object);window lw_window 


//----------------------------------------------------------------------------------------------------------------------------------
// Get a reference to the ultimate parent window/
//-----------------------------------------------------------------------------------------------------------------------------------
lw_window = of_getparentwindow(this)

if isvalid(au_object) then
	au_object.move(-30000,-30000)
end if

//----------------------------------------------------------------------------------------------------------------------------------
// This is an API Call to reset the window back to the original window parent
// With out this PB Will Crash Big Time.
//-----------------------------------------------------------------------------------------------------------------------------------
SetParent(handle(au_object),handle(lw_window))


//----------------------------------------------------------------------------------------------------------------------------------
// Call PB's close function.
//-----------------------------------------------------------------------------------------------------------------------------------
lw_window.CloseUserObject(au_object)


end subroutine

on u_dynamic_gui.create
end on

on u_dynamic_gui.destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Set the parent window for use later in closing the objects.
//-----------------------------------------------------------------------------------------------------------------------------------
io_parent = this.getparent()

//----------------------------------------------------------------------------------------------------------------------------------
// Trigger a theme refresh so the colors will be pretty.
//-----------------------------------------------------------------------------------------------------------------------------------
//If not gb_runningasaservice Then
	this.triggerevent('ue_refreshtheme')
//End If


end event

event destructor;long i_i

For i_i = 1 to upperbound(iu_deal)
	if isvalid(iu_deal[i_i]) then
 		this.of_closeuserobject(iu_deal[i_i])
	end if
Next
end event

event rbuttondown;//of_menushow()
end event

