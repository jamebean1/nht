$PBExportHeader$n_fwca_mgr.sru
$PBExportComments$Application service to handle framework class defaults
forward
global type n_fwca_mgr from datastore
end type
end forward

global type n_fwca_mgr from datastore
string dataobject = "d_fwca_mgr_std"
end type
global n_fwca_mgr n_fwca_mgr

type variables
//-----------------------------------------------------------------------------------------
//  Application Framework Constants
//-----------------------------------------------------------------------------------------

CONSTANT STRING	c_DefaultManagers		= "000|"
CONSTANT STRING	c_MicrohelpManager	= "001|"
CONSTANT STRING	c_MenuManager		= "002|"

CONSTANT INTEGER	c_Fatal			= -1
CONSTANT INTEGER	c_Success		= 0

CONSTANT INTEGER	c_Disabled		= 0
CONSTANT INTEGER	c_Enabled		= 1

CONSTANT ULONG	c_White			= 16777215
CONSTANT ULONG	c_Black			= 0
CONSTANT ULONG	c_Gray			= 12632256
CONSTANT ULONG	c_LightGray		= 12632256
CONSTANT ULONG	c_DarkGray		= 8421504
CONSTANT ULONG	c_Red			= 255
CONSTANT ULONG	c_DarkRed		= 128
CONSTANT ULONG	c_Green			= 65280
CONSTANT ULONG	c_DarkGreen		= 32768
CONSTANT ULONG	c_Blue			= 16711680
CONSTANT ULONG	c_DarkBlue		= 8388608
CONSTANT ULONG	c_Magenta		= 16711935
CONSTANT ULONG	c_DarkMagenta		= 8388736
CONSTANT ULONG	c_Cyan			= 16776960
CONSTANT ULONG	c_DarkCyan		= 8421376
CONSTANT ULONG	c_Yellow			= 65535
CONSTANT ULONG	c_DarkYellow		= 32896
CONSTANT ULONG	c_Brown			= 32896

CONSTANT INTEGER	c_APP_Object		= 1
CONSTANT INTEGER	c_APP_Name		= 2
CONSTANT INTEGER	c_APP_Rev		= 3
CONSTANT INTEGER	c_APP_Bitmap		= 4
CONSTANT INTEGER	c_APP_INIFile		= 5
CONSTANT INTEGER	c_APP_Copyright		= 6

CONSTANT INTEGER	c_HideMenuItems		= 1
CONSTANT INTEGER	c_DisableMenuItems	= 2
//-----------------------------------------------------------------------------------------
//  Application Framework Instance Variables
//-----------------------------------------------------------------------------------------

APPLICATION		i_ApplicationObject
STRING			i_ApplicationName
STRING			i_ApplicationRev
STRING			i_ApplicationBitmap
STRING			i_ApplicationINI
STRING			i_ApplicationCopyright

BOOLEAN		i_MDIValid
WINDOW		i_MDIFrame
MDICLIENT		i_MDIClient
BOOLEAN		i_MDIAutoConfigMenus
BOOLEAN		i_MDIAutoConfigHide 	= TRUE
WINDOW		i_MDIList[]

INTEGER		i_NumWindows
INTEGER		i_CloseToWindow
WINDOW		i_WindowList[]
INTEGER		i_WindowLastX
INTEGER		i_WindowLastY
WINDOW		i_WindowCurrent
DATAWINDOW		i_WindowCurrentDW

BOOLEAN		i_ShowMicrohelp		= TRUE

//-----------------------------------------------------------------------------------------
//  PowerBuilder 5.0 Bug
//  
//  The following variable is used to pass DataWindows
//  to the parent window function fw_SaveOnClose from
//  the child window function fw_FindRootDW.  This is 
//  necessary due to the problem of passing by reference
//  in a dynamically called function.
//-----------------------------------------------------------------------------------------

DATAWINDOW		i_TmpDW[]

//-----------------------------------------------------------------------------------------
//  PowerBuilder 5.0 Bug
//  
//  The following variable is used to pass a DataWindow
//  from the fu_SetControl function in n_dwsrv_ctrl
//  to PowerClass commandbuttons using a dynamic call 
//  to the fu_SetEnabled function.  There seems to be a
//  problem passing a DataWindow in a dynamic function
//  call that causes a SHR GPF when exiting the 
//  application.
//-----------------------------------------------------------------------------------------

DATAWINDOW		i_TmpServiceDW

end variables

forward prototypes
public function integer fu_openwindow (ref window window_name, integer menu_position)
public function integer fu_openwindow (ref window window_name, integer menu_position, powerobject window_parm)
public function integer fu_openwindow (ref window window_name, string window_type, integer menu_position)
public function integer fu_openwindow (ref window window_name, string window_type, integer menu_position, powerobject window_parm)
public function integer fu_openwindow (ref window window_name)
public function string fu_getmenubarlabel (string label_name)
public subroutine fu_exitapp ()
public function integer fu_getmenulabels (string label_type, ref string labels[])
public subroutine fu_setapplication (integer info_type, string info_value)
public subroutine fu_setapplication (string app_name, string app_rev, string app_bitmap, string app_inifile, string app_copyright)
public function string fu_getapplication (integer info_type)
public subroutine fu_setmicrohelp (string help_id)
public subroutine fu_setmicrohelp (string help_id, integer num_strings, string string_parms[])
public function integer fu_createmanagers (string managers)
public function integer fu_destroymanagers (string managers)
public function string fu_getdefault (string object_type, string default_type)
public function integer fu_setdefault (string object_type, string default_type, string value)
public function integer fu_openwindow (ref window window_name, string window_type, integer menu_position, string window_parm)
public function integer fu_openwindow (ref window window_name, string window_type, integer menu_position, double window_parm)
public function integer fu_openwindow (ref window window_name, integer menu_position, double window_parm)
public function integer fu_openwindow (ref window window_name, integer menu_position, string window_parm)
public function datawindow fu_getcurrentdw ()
public function integer fu_openwindow (ref window window_name, powerobject window_parm)
public function integer fu_openwindow (ref window window_name, string window_parm)
public subroutine fu_setautoconfigstyle (integer disable_hide_option)
end prototypes

public function integer fu_openwindow (ref window window_name, integer menu_position);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  INTEGER Menu_Position-
//                     Number of the menu item (in the menu
//                     associated with the window) to which
//                     you want to append the name of the
//                     open window.  The ranges of
//                     Menu_Position have the following
//                     meanings:
//                        >  0: Use OpenSheet*() passing
//                              Menu_Position as the menu
//                              position.
//                        =  0: Use Open*().
//                        = -1: Use OpenSheet*() passing
//                              -1 as the menu position.
//                           
//  Return Value  : INTEGER -
//                     0 = OK.
 //                   -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
// 10/22/98  Beth Byers	Check if the window is open on the current 
//								frame before opening it.  Just checking if 
//								the window is open in the application won't
//								necessarily open it on the proper frame.
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN     l_WindowExists
INTEGER     l_Error, l_Idx
POWEROBJECT l_Parm

SetPointer(HourGlass!)
Error.i_FWError = 0

//------------------------------------------------------------------
//  Loop through the array of windows to see if the current window
//  is already open on this frame.
//------------------------------------------------------------------

l_WindowExists = FALSE
FOR l_Idx = 1 TO i_NumWindows
   IF Window_Name = i_WindowList[l_Idx] AND i_MDIFrame =  i_MDIList[l_Idx]THEN
      l_WindowExists = TRUE
      EXIT
	END IF
NEXT

IF NOT l_WindowExists THEN

   //---------------------------------------------------------------
   //  Set the Window Open prompt.
   //---------------------------------------------------------------

   IF IsValid(FWCA.MDI) THEN
		IF FWCA.MGR.i_ShowMicrohelp THEN
 		   FWCA.MDI.fu_SetMicroHelp("Open")
		END IF
	END IF

	//---------------------------------------------------------------
	//  Set the MessageObject to null before it is set by any code
	//  further on in this function.
   //---------------------------------------------------------------

	SetNull(Message.PowerObjectParm)
	SetNull(Message.StringParm)
	SetNull(Message.DoubleParm)

   //---------------------------------------------------------------
   //  See if we are opening a sheet.
   //---------------------------------------------------------------

   IF i_MDIValid AND Menu_Position <> 0 THEN

      //------------------------------------------------------------
      //  If Menu_Position is less than 0, then the developer
      //  wanted the window opened as sheet and list the window
      //  under the next-to-last menu item.
      //------------------------------------------------------------

      IF Menu_Position < 0 THEN
         Menu_Position = 0
      END IF

      //------------------------------------------------------------
      //  If this is the first sheet to open, turn redraw off on the
      //  MDI to prevent toolbar flashing.  If other sheets are open
      //  we will assume the toolbar positioning is already set
      //  where it should be.
      //------------------------------------------------------------

   	IF i_NumWindows = i_CloseToWindow THEN
			OBJCA.MGR.i_Parm.Window_Redraw = TRUE
			i_MDIFrame.SetRedraw(FALSE)
      END IF
      
		//------------------------------------------------------------
      //  Open the sheet.
      //------------------------------------------------------------

      OBJCA.MGR.i_Parm.Window_Sheet = TRUE

      IF IsNull(OBJCA.MGR.i_Parm.PowerObject_Parm) = FALSE AND &
         OBJCA.MGR.i_Parm.Window_Type <> "" THEN
         l_Error = OpenSheetWithParm(Window_Name, &
                             OBJCA.MGR.i_Parm.PowerObject_Parm, &
                             OBJCA.MGR.i_Parm.Window_Type, &
                             i_MDIFrame,          &
                             Menu_Position,       &
                             Original!)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.String_Parm) = FALSE AND &
         OBJCA.MGR.i_Parm.Window_Type <> "" THEN
         l_Error = OpenSheetWithParm(Window_Name, &
                             OBJCA.MGR.i_Parm.String_Parm, &
                             OBJCA.MGR.i_Parm.Window_Type, &
                             i_MDIFrame,          &
                             Menu_Position,       &
                             Original!)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.Double_Parm) = FALSE AND &
         OBJCA.MGR.i_Parm.Window_Type <> "" THEN
         l_Error = OpenSheetWithParm(Window_Name, &
                             OBJCA.MGR.i_Parm.Double_Parm, &
                             OBJCA.MGR.i_Parm.Window_Type, &
                             i_MDIFrame,          &
                             Menu_Position,       &
                             Original!)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.PowerObject_Parm) = FALSE THEN
         l_Error = OpenSheetWithParm(Window_Name, &
                             OBJCA.MGR.i_Parm.PowerObject_Parm, &
                             i_MDIFrame,          &
                             Menu_Position,       &
                             Original!)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.String_Parm) = FALSE THEN
         l_Error = OpenSheetWithParm(Window_Name, &
                             OBJCA.MGR.i_Parm.String_Parm, &
                             i_MDIFrame,          &
                             Menu_Position,       &
                             Original!)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.Double_Parm) = FALSE THEN
         l_Error = OpenSheetWithParm(Window_Name, &
                             OBJCA.MGR.i_Parm.Double_Parm, &
                             i_MDIFrame,          &
                             Menu_Position,       &
                             Original!)

      ELSEIF OBJCA.MGR.i_Parm.Window_Type <> "" THEN
         l_Error = OpenSheet(Window_Name,         &
                             OBJCA.MGR.i_Parm.Window_Type, &
                             i_MDIFrame,          &
                             Menu_Position,       &
                             Original!)
      ELSE
         l_Error = OpenSheet(Window_Name,         &
                             i_MDIFrame,          &
                             Menu_Position,       &
                             Original!)
      END IF

		IF l_Error <> 1 THEN
         OBJCA.MGR.i_Parm.Window_Sheet = FALSE
			OBJCA.MGR.i_Parm.Window_Type = ""
			SetNull(OBJCA.MGR.i_Parm.PowerObject_Parm)
			SetNull(OBJCA.MGR.i_Parm.String_Parm)
			SetNull(OBJCA.MGR.i_Parm.Double_Parm)
         RETURN -1
      END IF

   ELSE

      //------------------------------------------------------------
      //  If the menu position is 0 or no MDI frame exists, use an
      //  Open instead of an OpenSheet.
      //------------------------------------------------------------

      OBJCA.MGR.i_Parm.Window_Sheet = FALSE

      IF IsNull(OBJCA.MGR.i_Parm.PowerObject_Parm) = FALSE AND &
         OBJCA.MGR.i_Parm.Window_Type <> "" THEN
         l_Error = OpenWithParm(Window_Name,         &
                                OBJCA.MGR.i_Parm.PowerObject_Parm, &
                                OBJCA.MGR.i_Parm.Window_Type)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.String_Parm) = FALSE AND &
         OBJCA.MGR.i_Parm.Window_Type <> "" THEN
         l_Error = OpenWithParm(Window_Name,         &
                                OBJCA.MGR.i_Parm.String_Parm, &
                                OBJCA.MGR.i_Parm.Window_Type)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.Double_Parm) = FALSE AND &
         OBJCA.MGR.i_Parm.Window_Type <> "" THEN
         l_Error = OpenWithParm(Window_Name,         &
                                OBJCA.MGR.i_Parm.Double_Parm, &
                                OBJCA.MGR.i_Parm.Window_Type)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.PowerObject_Parm) = FALSE THEN
         l_Error = OpenWithParm(Window_Name, OBJCA.MGR.i_Parm.PowerObject_Parm)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.String_Parm) = FALSE THEN
         l_Error = OpenWithParm(Window_Name, OBJCA.MGR.i_Parm.String_Parm)
      ELSEIF IsNull(OBJCA.MGR.i_Parm.Double_Parm) = FALSE THEN
         l_Error = OpenWithParm(Window_Name, OBJCA.MGR.i_Parm.Double_Parm)
      ELSEIF OBJCA.MGR.i_Parm.Window_Type <> "" THEN
         l_Error = Open(Window_Name, OBJCA.MGR.i_Parm.Window_Type)
      ELSE
         l_Error = Open(Window_Name)
      END IF

		IF l_Error <> 1 THEN
         OBJCA.MGR.i_Parm.Window_Sheet = FALSE
			OBJCA.MGR.i_Parm.Window_Type = ""
			SetNull(OBJCA.MGR.i_Parm.PowerObject_Parm)
			SetNull(OBJCA.MGR.i_Parm.String_Parm)
			SetNull(OBJCA.MGR.i_Parm.Double_Parm)
			RETURN -1
      END IF
   END IF

   //---------------------------------------------------------------
   //  Make sure that the "Opening a new window" prompt got
   //  removed.
   //---------------------------------------------------------------

   IF IsValid(FWCA.MDI) THEN
		IF FWCA.MGR.i_ShowMicrohelp THEN
 		   FWCA.MDI.fu_SetMicroHelp("")
		END IF
	END IF

ELSE

   //---------------------------------------------------------------
   //  The window is already open.  Make it active.
   //---------------------------------------------------------------
	
   IF Window_Name.WindowState = Minimized! THEN
      Window_Name.WindowState = Normal!
   ELSE
      FWCA.MGR.i_WindowCurrent = Window_Name
		SetFocus(Window_Name)
   END IF

	IF IsNull(OBJCA.MGR.i_Parm.PowerObject_Parm) = FALSE THEN
		l_Parm = OBJCA.MGR.i_Parm.PowerObject_Parm
	END IF

	Window_Name.DYNAMIC Event pc_SetVariables(l_Parm, &
                                             OBJCA.MGR.i_Parm.String_Parm, &
                                             OBJCA.MGR.i_Parm.Double_Parm)

END IF

//------------------------------------------------------------------
//  Return the error code.
//------------------------------------------------------------------

OBJCA.MGR.i_Parm.Window_Sheet = FALSE
OBJCA.MGR.i_Parm.Window_Type = ""
SetNull(OBJCA.MGR.i_Parm.PowerObject_Parm)
SetNull(OBJCA.MGR.i_Parm.String_Parm)
SetNull(OBJCA.MGR.i_Parm.Double_Parm)

//------------------------------------------------------------------
//  If the timer is active, mark a time.
//------------------------------------------------------------------

IF IsValid(OBJCA.TIMER) THEN
	IF OBJCA.TIMER.i_TimerOn THEN
		OBJCA.TIMER.fu_TimerOff("Window Display/Control Drawing")
	END IF
END IF

RETURN 0
end function

public function integer fu_openwindow (ref window window_name, integer menu_position, powerobject window_parm);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window passing a parameter.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  INTEGER Menu_Position-
//                     Number of the menu item (in the menu
//                     associated with the window) to which
//                     you want to append the name of the
//                     open window.  The ranges of
//                     Menu_Position have the following
//                     meanings:
//                        >  0: Use OpenSheet*() passing
//                              Menu_Position as the menu
//                              position.
//                        =  0: Use Open*().
//                        = -1: Use OpenSheet*() passing
//                              -1 as the menu position.
//
//                  POWEROBJECT Window_Parm -
//                        The PowerObject to be passed on the
//                        OpenWithParm() call.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.MGR.i_Parm.PowerObject_Parm = Window_Parm

RETURN fu_OpenWindow(Window_Name, Menu_Position)

end function

public function integer fu_openwindow (ref window window_name, string window_type, integer menu_position);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window by type.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  STRING Window_Type -
//                     String containing the type of window to
//                     open (e.g. "w_Change").
//
//                  INTEGER Menu_Position-
//                     Number of the menu item (in the menu
//                     associated with the window) to which
//                     you want to append the name of the
//                     open window.  The ranges of
//                     Menu_Position have the following
//                     meanings:
//                        >  0: Use OpenSheet*() passing
//                              Menu_Position as the menu
//                              position.
//                        =  0: Use Open*().
//                        = -1: Use OpenSheet*() passing
//                              -1 as the menu position.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.MGR.i_Parm.Window_Type = Window_Type

RETURN fu_OpenWindow(Window_Name, Menu_Position)

end function

public function integer fu_openwindow (ref window window_name, string window_type, integer menu_position, powerobject window_parm);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window by type and passing
//                  a parameter.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  STRING Window_Type -
//                     String containing the type of window to
//                     open (e.g. "w_Change").
//
//                  INTEGER Menu_Position -
//                     Number of the menu item (in the menu
//                     associated with the window) to which
//                     you want to append the name of the
//                     open window.  The ranges of
//                     Menu_Position have the following
//                     meanings:
//                        >  0: Use OpenSheet*() passing
//                              Menu_Position as the menu
//                              position.
//                        =  0: Use Open*().
//                        = -1: Use OpenSheet*() passing
//                              -1 as the menu position.
//
//                  POWEROBJECT Window_Parm -
//                        The PowerObject to be passed on the
//                        OpenWithParm() call.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.MGR.i_Parm.Window_Type = Window_Type
OBJCA.MGR.i_Parm.PowerObject_Parm = Window_Parm

RETURN fu_OpenWindow(Window_Name, Menu_Position)

end function

public function integer fu_openwindow (ref window window_name);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

RETURN fu_OpenWindow(Window_Name, 0)

end function

public function string fu_getmenubarlabel (string label_name);RETURN ""
end function

public subroutine fu_exitapp ();//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Subroutine    : fu_ExitApp
//  Description   : Closes all the windows and closes the 
//                  application.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/22/98 Beth Byers	Find out how many MDI frames are open and 
//								close all of them, not just the current frame
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumWindows, l_Jdx, l_Upper
window  l_MDIFrames[]
BOOLEAN l_Found

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Check to see if MDI Frames exists.  If so, let them close all
//  the sheets.
//------------------------------------------------------------------

IF i_MDIValid THEN
	
//------------------------------------------------------------------
//  Find out how many MDI Frames exist and put them into an array.  
//------------------------------------------------------------------
	l_MDIFrames[1] = i_MDIFrame
	FOR l_Idx = 1 to i_NumWindows
		l_Found = FALSE
		l_Upper = UpperBound(l_MDIFrames)
		
		FOR l_Jdx = 1 to l_Upper
			IF i_MDIList[l_Idx] = l_MDIFrames[l_Jdx] THEN
				l_Found = TRUE
				EXIT
			END IF
		NEXT
		
		IF l_Found = FALSE THEN
			l_MDIFrames[l_Upper + 1] = i_MDIList[l_Idx]
		END IF
	NEXT

//------------------------------------------------------------------
//  Close all of the MDI Frames .  
//------------------------------------------------------------------
	l_Upper = UpperBound(l_MDIFrames)
	FOR l_Idx = 1 to l_Upper
		Close(l_MDIFrames[l_Idx])
	NEXT

//------------------------------------------------------------------
//  If there is no MDI Frame, cycle through the window list to close
//  them.  The last window closed will do a HALT CLOSE to exit
//  the application.
//------------------------------------------------------------------

ELSE

	l_NumWindows = i_NumWindows
	FOR l_Idx = l_NumWindows TO 1 STEP -1
		Close(i_WindowList[l_Idx])
		IF Error.i_FWError <> c_Success THEN
			i_NumWindows = l_Idx
			EXIT
 		END IF
	NEXT

END IF

end subroutine

public function integer fu_getmenulabels (string label_type, ref string labels[]);RETURN 0
end function

public subroutine fu_setapplication (integer info_type, string info_value);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Subroutine    : fu_SetApplication
//  Description   : Sets application information.
//
//  Parameters    : INTEGER Info_Type -
//                     The type of application information to set.
//                  STRING Info_Value -
//                     The application information.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE info_type
	CASE c_APP_Name
		FWCA.MGR.i_ApplicationName        = info_value
		OBJCA.MGR.i_ApplicationName       = info_value
	CASE c_APP_Rev
		FWCA.MGR.i_ApplicationRev         = info_value
		OBJCA.MGR.i_ApplicationRev        = info_value
	CASE c_APP_Bitmap
		FWCA.MGR.i_ApplicationBitmap      = info_value
		OBJCA.MGR.i_ApplicationBitmap     = info_value
	CASE c_APP_INIFile
		FWCA.MGR.i_ApplicationINI         = info_value
		OBJCA.MGR.i_ApplicationINI        = info_value
	CASE c_APP_Copyright
		FWCA.MGR.i_ApplicationCopyright   = info_value
		OBJCA.MGR.i_ApplicationCopyright  = info_value
END CHOOSE

end subroutine

public subroutine fu_setapplication (string app_name, string app_rev, string app_bitmap, string app_inifile, string app_copyright);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Subroutine    : fu_SetApplication
//  Description   : Sets application information.
//
//  Parameters    : STRING App_Name -
//                     Application name.
//                  STRING App_Rev -
//                     Application revision.
//                  STRING App_Bitmap -
//                     Application bitmap.
//                  STRING App_INIFile -
//                     Application INI file name.
//                  STRING App_Copyright -
//                     Application copyright message.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

FWCA.MGR.i_ApplicationName      = app_name
FWCA.MGR.i_ApplicationRev       = app_rev
FWCA.MGR.i_ApplicationBitmap    = app_bitmap
FWCA.MGR.i_ApplicationINI       = app_inifile
FWCA.MGR.i_ApplicationCopyright = app_copyright

OBJCA.MGR.i_ApplicationName      = app_name
OBJCA.MGR.i_ApplicationRev       = app_rev
OBJCA.MGR.i_ApplicationBitmap    = app_bitmap
OBJCA.MGR.i_ApplicationINI       = app_inifile
OBJCA.MGR.i_ApplicationCopyright = app_copyright

end subroutine

public function string fu_getapplication (integer info_type);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_GetApplication
//  Description   : Gets application information.
//
//  Parameters    : INTEGER Info_Type -
//                     The type of application information to get.
//
//  Return Value  : STRING -
//                     The value of the information that was 
//                     requested.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE info_type
	CASE c_APP_Name
		RETURN i_ApplicationName
	CASE c_APP_Rev
		RETURN i_ApplicationRev
	CASE c_APP_Bitmap
		RETURN i_ApplicationBitmap
	CASE c_APP_INIFile
		RETURN i_ApplicationINI
	CASE c_APP_Copyright
		RETURN i_ApplicationCopyright
END CHOOSE

end function

public subroutine fu_setmicrohelp (string help_id);
end subroutine

public subroutine fu_setmicrohelp (string help_id, integer num_strings, string string_parms[]);
end subroutine

public function integer fu_createmanagers (string managers);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_CreateManagers
//  Description   : Create utility managers.
//
//  Parameters    : STRING Managers -
//                     Managers to be created.
//
//  Return Value  : INTEGER
//                      0 = manager created successfully
//                     -1 = manager creation failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

N_FWCA_MGR l_Tmp
STRING l_Object

//------------------------------------------------------------------
//  Create the microhelp manager.
//------------------------------------------------------------------

IF Pos(managers, c_MicrohelpManager) > 0 THEN
	IF NOT IsValid(FWCA.MDI) THEN
		l_Object = FWCA.MGR.fu_GetDefault("Framework", "Microhelp")
		IF l_Object <> "" THEN
			l_Tmp = Create Using l_Object
			FWCA.MDI = l_Tmp
			IF NOT IsValid(FWCA.MDI) THEN
				RETURN c_Fatal
			END IF
		ELSE
			RETURN c_Fatal
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Create the menu manager.
//------------------------------------------------------------------

IF Pos(managers, c_MenuManager) > 0 THEN
	IF NOT IsValid(FWCA.MENU) THEN
		l_Object = FWCA.MGR.fu_GetDefault("Framework", "Menu")
		IF l_Object <> "" THEN
			l_Tmp = Create Using l_Object
			FWCA.MENU = l_Tmp
			IF NOT IsValid(FWCA.MENU) THEN
				RETURN c_Fatal
			END IF
		ELSE
			RETURN c_Fatal
		END IF
	END IF
END IF

RETURN c_Success
end function

public function integer fu_destroymanagers (string managers);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_DestroyManagers
//  Description   : Destroy utility managers.
//
//  Parameters    : STRING Managers -
//                     Managers to be destroyed.
//
//  Return Value  : INTEGER
//                      0 = manager destroyed successfully
//                     -1 = manager destruction failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Check to see if the menu manager was requested.
//------------------------------------------------------------------

IF Pos(managers, c_MenuManager) > 0 THEN
	IF IsValid(FWCA.MENU) THEN
		Destroy(FWCA.MENU)
	END IF
END IF

//------------------------------------------------------------------
//  Check to see if the microhelp manager was requested.
//------------------------------------------------------------------

IF Pos(managers, c_MicrohelpManager) > 0 THEN
	IF IsValid(FWCA.MDI) THEN
		Destroy(FWCA.MDI)
	END IF
END IF
	
RETURN c_Success
end function

public function string fu_getdefault (string object_type, string default_type);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_GetDefault
//  Description   : Gets the default value for an object.
//
//  Parameters    : STRING Object_Type -
//                     Type of object (e.g. calendar).
//                  STRING Default_Type -
//                     The part of the object the default value
//                     applies to (e.g. text).
//
//  Return Value  : STRING -
//                     Returns default value in a string.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG   l_NumDefaults, l_Row
STRING l_Value

l_NumDefaults = RowCount()

l_Row = Find("object_type = '" + object_type + &
             "' AND default_type = '" + default_type + "'", &
				 1, l_NumDefaults)
IF l_Row > 0 THEN
	l_Value = GetItemString(l_Row, "value")
	IF IsNull(l_Value) <> FALSE THEN
		l_Value = ""
	END IF
ELSE
	l_Value = ""
END IF

RETURN l_Value
end function

public function integer fu_setdefault (string object_type, string default_type, string value);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_SetDefault
//  Description   : Sets the default value for an object.
//
//  Parameters    : STRING Object_Type -
//                     Type of object (e.g. calendar).
//                  STRING Default_Type -
//                     The part of the object the default value
//                     applies to (e.g. text).
//                  STRING Value -
//                     The default value to set.
//
//  Return Value  : INTEGER -
//                      0 - Default value set.
//                     -1 - Object, default, or parameter not found.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_NumDefaults, l_Row

l_NumDefaults = RowCount()

l_Row = Find("object_type = '" + object_type + &
             "' AND default_type = '" + default_type + "'", &
				 1, l_NumDefaults)
IF l_Row > 0 THEN
	SetItem(l_Row, "value", value)
	RETURN 0
ELSE
	RETURN -1
END IF
end function

public function integer fu_openwindow (ref window window_name, string window_type, integer menu_position, string window_parm);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window by type and passing
//                  a parameter.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  STRING Window_Type -
//                     String containing the type of window to
//                     open (e.g. "w_Change").
//
//                  INTEGER Menu_Position -
//                     Number of the menu item (in the menu
//                     associated with the window) to which
//                     you want to append the name of the
//                     open window.  The ranges of
//                     Menu_Position have the following
//                     meanings:
//                        >  0: Use OpenSheet*() passing
//                              Menu_Position as the menu
//                              position.
//                        =  0: Use Open*().
//                        = -1: Use OpenSheet*() passing
//                              -1 as the menu position.
//
//                  STRING Window_Parm -
//                        The string to be passed on the
//                        OpenWithParm() call.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.MGR.i_Parm.Window_Type = Window_Type
OBJCA.MGR.i_Parm.String_Parm = Window_Parm

RETURN fu_OpenWindow(Window_Name, Menu_Position)

end function

public function integer fu_openwindow (ref window window_name, string window_type, integer menu_position, double window_parm);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window by type and passing
//                  a parameter.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  STRING Window_Type -
//                     String containing the type of window to
//                     open (e.g. "w_Change").
//
//                  INTEGER Menu_Position -
//                     Number of the menu item (in the menu
//                     associated with the window) to which
//                     you want to append the name of the
//                     open window.  The ranges of
//                     Menu_Position have the following
//                     meanings:
//                        >  0: Use OpenSheet*() passing
//                              Menu_Position as the menu
//                              position.
//                        =  0: Use Open*().
//                        = -1: Use OpenSheet*() passing
//                              -1 as the menu position.
//
//                  DOUBLE Window_Parm -
//                        The numeric to be passed on the
//                        OpenWithParm() call.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.MGR.i_Parm.Window_Type = Window_Type
OBJCA.MGR.i_Parm.Double_Parm = Window_Parm

RETURN fu_OpenWindow(Window_Name, Menu_Position)

end function

public function integer fu_openwindow (ref window window_name, integer menu_position, double window_parm);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window passing a parameter.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  INTEGER Menu_Position-
//                     Number of the menu item (in the menu
//                     associated with the window) to which
//                     you want to append the name of the
//                     open window.  The ranges of
//                     Menu_Position have the following
//                     meanings:
//                        >  0: Use OpenSheet*() passing
//                              Menu_Position as the menu
//                              position.
//                        =  0: Use Open*().
//                        = -1: Use OpenSheet*() passing
//                              -1 as the menu position.
//
//                  DOUBLE Window_Parm -
//                        The numeric to be passed on the
//                        OpenWithParm() call.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.MGR.i_Parm.Double_Parm = Window_Parm

RETURN fu_OpenWindow(Window_Name, Menu_Position)

end function

public function integer fu_openwindow (ref window window_name, integer menu_position, string window_parm);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window passing a parameter.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  INTEGER Menu_Position-
//                     Number of the menu item (in the menu
//                     associated with the window) to which
//                     you want to append the name of the
//                     open window.  The ranges of
//                     Menu_Position have the following
//                     meanings:
//                        >  0: Use OpenSheet*() passing
//                              Menu_Position as the menu
//                              position.
//                        =  0: Use Open*().
//                        = -1: Use OpenSheet*() passing
//                              -1 as the menu position.
//
//                  STRING Window_Parm -
//                        The string to be passed on the
//                        OpenWithParm() call.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.MGR.i_Parm.String_Parm = Window_Parm

RETURN fu_OpenWindow(Window_Name, Menu_Position)

end function

public function datawindow fu_getcurrentdw ();//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_GetCurrentDW
//  Description   : Gets the current datawindow
//
//  Parameters    : none
//
//  Return Value  : DATAWINDOW -
//                     Returns the current datawindow.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN i_WindowCurrentDW
end function

public function integer fu_openwindow (ref window window_name, powerobject window_parm);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window passing a parameter.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  POWEROBJECT Window_Parm -
//                        The PowerObject to be passed on the
//                        OpenWithParm() call.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.MGR.i_Parm.PowerObject_Parm = Window_Parm

RETURN fu_OpenWindow(Window_Name, 0)

end function

public function integer fu_openwindow (ref window window_name, string window_parm);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Function      : fu_OpenWindow
//  Description   : Open or refresh a window passing a parameter.
//
//  Parameters    : WINDOW Window_Name -
//                    Name of the window to open or refresh.
//
//                  STRING Window_Parm -
//                        The string to be passed on the
//                        OpenWithParm() call.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = window open failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.MGR.i_Parm.String_Parm = Window_Parm

RETURN fu_OpenWindow(Window_Name, 0)

end function

public subroutine fu_setautoconfigstyle (integer disable_hide_option);//******************************************************************
//  PC Module     : n_FWCA_MGR
//  Subroutine    : fu_SetAutoConfigStyle
//  Description   : Set the instance variable i_MDIAautoConfigHide
//                  to TRUE or FALSE depending on the argument being
//                  passed.
//
//                  Only two arguments may be passed to this function:
//                  c_HideMenuItems or c_DisableMenuItems
//
//  Parameters    : INTEGER   -  Disable_Hide_Option
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

IF Disable_Hide_Option = 1 THEN
	i_MDIAutoConfigHide = TRUE
ELSE
	i_MDIAutoConfigHide = FALSE
END IF
end subroutine

on n_fwca_mgr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_fwca_mgr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

