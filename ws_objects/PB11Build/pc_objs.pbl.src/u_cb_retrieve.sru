$PBExportHeader$u_cb_retrieve.sru
$PBExportComments$Command button for retieving records
forward
global type u_cb_retrieve from u_cb_main
end type
end forward

global type u_cb_retrieve from u_cb_main
string Text="&Retrieve"
end type
global u_cb_retrieve u_cb_retrieve

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Retrieve
//  Event         : Constructor
//  Description   : Sets up the command button.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

i_Event = "Retrieve"
i_Type  = 23

end event

event clicked;//******************************************************************
//  PC Module     : u_CB_Retrieve
//  Event         : Clicked
//  Description   : Trigger an event on the window or, if wired to
//                  a specific DataWindow, trigger on DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Event

//------------------------------------------------------------------
//  Run the retrieve function on the DataWindow if the button has 
//  been directly wired.
//------------------------------------------------------------------

IF IsNull(i_ButtonDW) = FALSE THEN
   IF IsValid(i_ButtonDW) THEN
   	i_ButtonDW.DYNAMIC fu_Retrieve(1, 2)
	END IF

//------------------------------------------------------------------
//  If not directly wired, see if there is a current DataWindow and
//  trigger the event there.
//------------------------------------------------------------------

ELSEIF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.DYNAMIC fu_Retrieve(1, 2)

//------------------------------------------------------------------
//  If no DataWindow is current, then just trigger the event on the
//  window.
//------------------------------------------------------------------

ELSEIF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   l_Event = "pc_" + i_Event
   FWCA.MGR.i_WindowCurrent.TriggerEvent(l_Event)

END IF
end event

