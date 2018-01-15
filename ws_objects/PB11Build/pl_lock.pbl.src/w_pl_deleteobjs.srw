$PBExportHeader$w_pl_deleteobjs.srw
$PBExportComments$Delete registered objects window
forward
global type w_pl_deleteobjs from window
end type
type cbx_datawindows from checkbox within w_pl_deleteobjs
end type
type cbx_popupmenus from checkbox within w_pl_deleteobjs
end type
type cbx_userobjects from checkbox within w_pl_deleteobjs
end type
type cb_cancel from commandbutton within w_pl_deleteobjs
end type
type cb_ok from commandbutton within w_pl_deleteobjs
end type
end forward

global type w_pl_deleteobjs from window
integer x = 672
integer y = 268
integer width = 1006
integer height = 628
boolean titlebar = true
string title = "Select Types to Delete"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 80269524
toolbaralignment toolbaralignment = alignatleft!
cbx_datawindows cbx_datawindows
cbx_popupmenus cbx_popupmenus
cbx_userobjects cbx_userobjects
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_pl_deleteobjs w_pl_deleteobjs

type variables
INTEGER	i_DeleteBit = -1
end variables

on w_pl_deleteobjs.create
this.cbx_datawindows=create cbx_datawindows
this.cbx_popupmenus=create cbx_popupmenus
this.cbx_userobjects=create cbx_userobjects
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.cbx_datawindows,&
this.cbx_popupmenus,&
this.cbx_userobjects,&
this.cb_cancel,&
this.cb_ok}
end on

on w_pl_deleteobjs.destroy
destroy(this.cbx_datawindows)
destroy(this.cbx_popupmenus)
destroy(this.cbx_userobjects)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event open;//******************************************************************
//  PL Module     : w_PL_DeleteObjs
//  Event         : Open
//  Description   : Center the window on the screen.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

ENVIRONMENT l_Env
INTEGER l_ScreenWidth, l_ScreenHeight

//------------------------------------------------------------------
//  Center the window on the screen.
//------------------------------------------------------------------

GetEnvironment(l_Env)

l_ScreenWidth = PixelsToUnits(l_Env.ScreenWidth, xPixelsToUnits!)
l_ScreenHeight = PixelsToUnits(l_Env.ScreenHeight, yPixelsToUnits!)

Move((l_ScreenWidth - Width ) / 2, (l_ScreenHeight - Height) / 2)
end event

type cbx_datawindows from checkbox within w_pl_deleteobjs
integer x = 64
integer y = 248
integer width = 882
integer height = 76
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 80269524
string text = "DataWindows (Static and Dynamic)"
end type

type cbx_popupmenus from checkbox within w_pl_deleteobjs
integer x = 64
integer y = 156
integer width = 782
integer height = 76
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 80269524
string text = "Dynamic Popup Menus"
end type

type cbx_userobjects from checkbox within w_pl_deleteobjs
integer x = 64
integer y = 64
integer width = 782
integer height = 76
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 80269524
string text = "Dynamic User Objects"
end type

type cb_cancel from commandbutton within w_pl_deleteobjs
integer x = 585
integer y = 372
integer width = 247
integer height = 108
integer taborder = 10
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancel"
boolean default = true
end type

event clicked;//******************************************************************
//  PL Module     : w_Delete_Reg_Objs.cb_Cancel
//  Event         : Clicked
//  Description   : No changes will be made to the registered
//                  objects.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CloseWithReturn(PARENT, -1)
end event

type cb_ok from commandbutton within w_pl_deleteobjs
integer x = 142
integer y = 372
integer width = 247
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "OK"
end type

event clicked;//******************************************************************
//  PL Module     : w_PL_DeleteObjs.cb_OK
//  Event         : Clicked
//  Description   : Determine which types of objects are to be
//                  deleted from the security database if they are
//                  not currently selected in the registration
//                  window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = 0
BOOLEAN l_SomethingChecked = FALSE

//------------------------------------------------------------------
//  Dynamically created user objects.
//------------------------------------------------------------------

IF cbx_userobjects.Checked THEN
	l_SomethingChecked = TRUE
	l_Return = l_Return + 1
END IF

//------------------------------------------------------------------
//  Dynamically created popup menus.
//------------------------------------------------------------------

IF cbx_popupmenus.Checked THEN
	l_SomethingChecked = TRUE
	l_Return = l_Return + 2
END IF

//------------------------------------------------------------------
//  Datawindows.
//------------------------------------------------------------------

IF cbx_datawindows.Checked THEN
	l_SomethingChecked = TRUE
	l_Return = l_Return + 4
END IF

IF NOT l_SomethingChecked THEN
	l_Return = -1
END IF

i_DeleteBit = l_Return
CloseWithReturn(PARENT, i_DeleteBit)


end event

