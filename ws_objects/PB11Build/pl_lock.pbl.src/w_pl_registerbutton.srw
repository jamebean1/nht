$PBExportHeader$w_pl_registerbutton.srw
$PBExportComments$Register button for the MDI frame
forward
global type w_pl_registerbutton from Window
end type
type cb_register from u_registerbutton within w_pl_registerbutton
end type
end forward

global type w_pl_registerbutton from Window
int X=938
int Y=469
int Width=266
int Height=69
long BackColor=12632256
boolean Border=false
boolean ToolBarVisible=true
WindowType WindowType=popup!
cb_register cb_register
end type
global w_pl_registerbutton w_pl_registerbutton

type variables



end variables

event open;//******************************************************************
//  PL Module     : w_PL_RegisterButton
//  Event         : Open
//  Description   : Position this window in the top right corner
//                  of the MDI window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_X, l_Y

IF NOT IsValid(cb_register.i_Window) THEN
	cb_register.i_Window = THIS.ParentWindow()
END IF

l_X = cb_register.i_Window.X + cb_register.i_Window.Width - 270
l_Y = cb_register.i_Window.WorkSpaceY()

Move(l_X, l_Y)

IF NOT SECCA.MGR.i_DebugMode THEN
	Timer(.5)
END IF
end event

event timer;//******************************************************************
//  PL Module     : w_PL_RegisterButton
//  Event         : Timer
//  Description   : Position this window in the top right corner
//                  of the MDI window if it has moved or resized.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1996.  All Rights Reserved.
//******************************************************************

INTEGER l_X, l_Y

IF cb_register.i_Window.WindowState = Minimized! THEN RETURN

l_X = cb_register.i_Window.X + cb_register.i_Window.Width - 270
l_Y = cb_register.i_Window.WorkSpaceY()

IF THIS.X <> l_X OR &
	THIS.Y <> l_Y THEN
	Move(l_X, l_Y)
END IF
end event

on w_pl_registerbutton.create
this.cb_register=create cb_register
this.Control[]={ this.cb_register}
end on

on w_pl_registerbutton.destroy
destroy(this.cb_register)
end on

type cb_register from u_registerbutton within w_pl_registerbutton
int X=1
int Y=1
end type

