$PBExportHeader$u_registerbutton.sru
$PBExportComments$User object used to initiate object registration from an application
forward
global type u_registerbutton from commandbutton
end type
end forward

global type u_registerbutton from commandbutton
int Width=270
int Height=72
int TabOrder=1
string Text=" Register"
int TextSize=-7
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_registerbutton u_registerbutton

type variables
WINDOW		i_Window
USEROBJECT		i_DynamicUO[]
MENU			i_PopupMenu[]
BOOLEAN		i_NewDynamic = FALSE

W_PL_REGISTER		i_RegisterWindow
end variables

event clicked;//******************************************************************
//  PL Module     : u_RegisterButton
//  Event         : Clicked
//  Description   : Open the object registration window or, if open,
//                  shift focus to it and display a list of controls
//                  on the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Object

IF IsValid(i_RegisterWindow) THEN
   IF i_Window.WindowType = Response! THEN
     	IF i_RegisterWindow.i_Modified THEN
        	IF SECCA.MSG.fu_DisplayMessage("ObjRegSave") = 1 THEN
           	i_RegisterWindow.i_FromOutsideObject = TRUE
           	i_RegisterWindow.cb_ok.TriggerEvent(Clicked!)
        	END IF
     	END IF
		Close(i_RegisterWindow)
		OpenWithParm(i_RegisterWindow, i_Window)
	ELSE
		IF i_Window <> i_RegisterWindow.i_CurrentWindow OR i_NewDynamic THEN
      	IF i_RegisterWindow.i_Modified THEN
         	IF SECCA.MSG.fu_DisplayMessage("ObjRegSave") = 1 THEN
            	i_RegisterWindow.i_FromOutsideObject = TRUE
            	i_RegisterWindow.cb_ok.TriggerEvent(Clicked!)
         	ELSE
            	i_RegisterWindow.i_Modified = FALSE
            	i_RegisterWindow.i_FromOutsideObject = FALSE
         	END IF
      	END IF
      	i_RegisterWindow.SetReDraw(FALSE)
      	i_RegisterWindow.i_CurrentWindow = i_Window
      	i_RegisterWindow.fw_HLInit()
			i_NewDynamic = FALSE
      	i_RegisterWindow.SetReDraw(TRUE)
   	END IF
		i_RegisterWindow.dw_1.SetReDraw(TRUE)
   	i_RegisterWindow.visible = TRUE
	END IF
ELSE
   l_Object = SECCA.DEF.fu_GetDefault("Security", "Register")
	IF l_Object <> "" THEN
		OpenWithParm(i_RegisterWindow, i_Window, l_Object)
	END IF
END IF
end event

event constructor;//******************************************************************
//  PL Module     : u_RegisterButton
//  Event         : Constructor
//  Description   : Save this button in the array of all buttons
//                  and make sure that it sits on top of all the 
//                  other controls.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SECCA.MGR.i_NumRegButtons ++
SECCA.MGR.i_RegButton[SECCA.MGR.i_NumRegButtons] = THIS
BringToTop = TRUE
end event

event destructor;//******************************************************************
//  PL Module     : u_RegisterButton
//  Event         : Destructor
//  Description   : Remove this button from the array of all buttons.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************
INTEGER l_Idx, l_Jdx

IF IsValid(i_RegisterWindow) THEN
	i_RegisterWindow.Hide()
END IF

l_Jdx = 0
FOR l_Idx = 1 TO SECCA.MGR.i_NumRegButtons
	IF SECCA.MGR.i_RegButton[l_Idx] <> THIS THEN
		l_Jdx ++
		SECCA.MGR.i_RegButton[l_Jdx] = SECCA.MGR.i_RegButton[l_Idx]
	END IF
NEXT
SECCA.MGR.i_NumRegButtons = l_Jdx
end event

