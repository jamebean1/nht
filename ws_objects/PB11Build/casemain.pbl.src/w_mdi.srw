$PBExportHeader$w_mdi.srw
$PBExportComments$CustomerFocus MDI Frame
forward
global type w_mdi from w_mdi_frame_std
end type
end forward

global type w_mdi from w_mdi_frame_std
integer width = 2930
integer height = 2000
string menuname = "m_mdi"
boolean toolbarvisible = true
end type
global w_mdi w_mdi

type variables
BOOLEAN	i_bSleeping

U_DBX_TIMER	i_uoTimer
end variables

forward prototypes
public subroutine fw_openworkarea ()
public subroutine fw_initializesleeptimer ()
public function integer fw_sleep ()
public function integer fw_wakeup ()
end prototypes

public subroutine fw_openworkarea ();//************************************************************************************
//
//  Function: fw_OpenWorkArea
//  Purpose:  to open the work area window 
//
//  Date     Developer     Description
//  -------- ------------- -----------------------------------------------------------
//  04/21/00 C. Jackson    Original Version
//
//************************************************************************************

FWCA.MGR.fu_openwindow(w_reminders,-1)


end subroutine

public subroutine fw_initializesleeptimer ();/*****************************************************************************************
   Function:   fw_InitializeSleepTimer
   Purpose:    Initialize the sleep timer for the application
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	05/25/01 M. Caruso    Created.
*****************************************************************************************/

STRING	l_cValue, l_cTempVal

l_cTempVal = 'sleep timer'

SELECT option_value
  INTO :l_cValue
  FROM cusfocus.system_options
 WHERE option_name = :l_cTempVal
 USING SQLCA;
 
CHOOSE CASE SQLCA.SQLCode
	CASE -1, 100
		MessageBox (gs_appname, 'Unable to determine Sleep Mode timer setting ' + &
										'so the timer will be disabled.')
		Idle (0)
		
	CASE 0
		gn_sleeptime = INTEGER (l_cValue)
		
		IF gn_sleeptime > 0 THEN
			
			// validate the value from the database
			IF gn_sleeptime < gn_sleepmin THEN
				gn_sleeptime = gn_sleepmin
			ELSEIF gn_sleeptime > gn_sleepmax THEN
				gn_sleeptime = gn_sleepmax
			END IF
			// start the timer.
			Idle (gn_sleeptime)
			
		END IF
		
END CHOOSE

end subroutine

public function integer fw_sleep ();/*****************************************************************************************
   Function:   fw_Sleep
   Purpose:    Place the application into sleep mode.
   Parameters: NONE
   Returns:    INTEGER	 0 - Success
								-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	05/25/01 M. Caruso    Created.
	07/30/01 M. Caruso    Commented out.
*****************************************************************************************/

//// Step 1: Try to remove the license record from active_logins
//IF gnv_LicenseMgr.uf_DeleteUserLogin () = 0 THEN
//	
//	// Step 2: Minimize the window
//	WindowState = Minimized!
//	// Step 3: Update i_bSleeping
//	i_bSleeping = TRUE
//	
//	// Step 4: disable the timer if it is running.
//	IF gn_sleeptime > 0 THEN Idle (0)
//	
//	// create the DB Maintenance Timer to maintain a valid database connection.
//	i_uoTimer = CREATE u_dbx_timer
//	i_uoTimer.Start (300)
//
	RETURN 0
//	
//ELSE
//	
//	RETURN -1
//	
//END IF
end function

public function integer fw_wakeup ();/*****************************************************************************************
   Function:   fw_WakeUp
   Purpose:    Bring the application out of sleep mode.
   Parameters: NONE
   Returns:    INTEGER	 0 - Success
								-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	05/25/01 M. Caruso    Created.
	07/30/01 M. Caruso    Commented out.
*****************************************************************************************/

//IF gnv_LicenseMgr.uf_AddUserLogin () = 0 THEN
//	
//	// restart the timer only if neccessary.
//	IF gn_sleeptime > 0 THEN Idle (gn_sleeptime)
//	i_bSleeping = FALSE
//	
//	// cancel the db connection timer and remove it from memory.
//	i_uoTimer.Stop ()
//	DESTROY i_uoTimer
//	
	RETURN 0
//	
//ELSE
//	RETURN -1
//END IF
end function

on w_mdi.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mdi" then this.MenuID = create m_mdi
end on

on w_mdi.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    Initialize the window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/27/01 M. Caruso    Removed the c_ShowClock option.
*****************************************************************************************/

fw_SetOptions (c_Default + c_ToolBarTop + c_ToolBarShowTips)
end event

event open;call super::open;//***********************************************************************************************
//
//  Event:   open
//  Purpose: to open the Work Desk open application opening
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  04/21/00 C. Jackson    Original Version
//  05/29/01 M. Caruso     Added call to fw_initializesleeptimer ().
//  07/30/01 M. Caruso     Commented call to fw_initializesleeptimer ().
//***********************************************************************************************

i_bSleeping = FALSE
//post fw_InitializeSleepTimer ()
post fw_OpenWorkArea ()

end event

event activate;call super::activate;/*****************************************************************************************
   Event:      activate
   Purpose:    Define functionality for when this window is activated.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	05/29/01 M. Caruso    Created.
*****************************************************************************************/

IF i_bSleeping THEN
	
	RETURN fw_WakeUp ()
	
END IF
end event

