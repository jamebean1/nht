$PBExportHeader$w_reminders.srw
$PBExportComments$Reminders Window
forward
global type w_reminders from w_main_std
end type
type ole_systray from olecustomcontrol within w_reminders
end type
type tab_workdesk from uo_tab_workdesk within w_reminders
end type
type tab_workdesk from uo_tab_workdesk within w_reminders
end type
end forward

global type w_reminders from w_main_std
integer x = 0
integer y = 0
integer width = 3653
integer height = 1912
string title = "Work Desk for"
string menuname = "m_cusfocus_reminders"
long backcolor = 79748288
event ue_selecttab ( integer a_ntabnum )
event ue_resetrefresh ( )
ole_systray ole_systray
tab_workdesk tab_workdesk
end type
global w_reminders w_reminders

type variables
BOOLEAN i_bEnableCalendar
BOOLEAN i_bChangeMode
BOOLEAN i_bOutOfOffice
BOOLEAN i_bOkRefresh = FALSE

INTEGER	i_nRepConfidLevel

DATE       i_dReminderDates[]

STRING    i_cSaveMessage = 'Would you like to Save the Reminders?'  

STRING    i_cCaseReminder
STRING    i_cReminderID
STRING    i_cSortDataWindow
STRING    i_cViewed
STRING    i_cUserID
STRING    i_cCaseNumber
LONG i_nCurrentTab

STRING	is_timer_refresh_rate

BOOLEAN	i_bSupervisorRole
STRING	i_cSupervisorRole
BOOLEAN ib_enable_systray_icon
end variables

forward prototypes
public subroutine fw_checkoutofoffice ()
public function integer fw_getlasttab ()
public function integer fw_setlasttab ()
public subroutine fw_setokrefresh ()
public subroutine of_show_systray_icon (string as_text)
public subroutine of_hide_systray_icon ()
end prototypes

event ue_selecttab(integer a_ntabnum);//***********************************************************************************************
//
//  Event:   ue_SelectTab
//  Purpose: Post selection of the tab the user was on before they closed the workdesk
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  6/27/2001 K. Claver   Original Version
//  9/20/2002 K. Claver   Added code to trigger the refresh of the focus tab
//***********************************************************************************************  
tab_workdesk.SelectTab( a_nTabNum )

//Trigger the refresh of the tabs
THIS.i_bOkRefresh = TRUE
THIS.tab_workdesk.Event Trigger ue_Refresh( )
//THIS.tab_workdesk.SetFocus()
end event

event ue_resetrefresh();//***********************************************************************************************
//
//  Event:   ue_ResetRefresh
//  Purpose: Reset the refresh variable and timer for the workdesk.
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  6/27/2001 K. Claver   Original Version
//***********************************************************************************************  
THIS.i_bOkRefresh = FALSE
Timer( 0 )
Timer( long(is_timer_refresh_rate) )
end event

public subroutine fw_checkoutofoffice ();//********************************************************************************************
//
//  Function: fw_checkoutofoffice
//  Purpose:  To mark the out of office menu item
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  12/15/00 cjackson    Original Verison
//
//********************************************************************************************

LONG l_nCount

// Get userid
i_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

// If the user is currently mark as out of the office, setting the Check on the menu item
SELECT count(*) INTO :l_nCount
  FROM cusfocus.out_of_office
 WHERE out_user_id = :i_cUserID
 USING SQLCA;
 
// Update the clicked property based on whether not the user if Out of Office 
IF l_nCount > 0 THEN
	m_cusfocus_reminders.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_cusfocus_reminders.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
END IF







end subroutine

public function integer fw_getlasttab ();//**********************************************************************************************
//
//  Function:   fw_GetLastTab
//   Purpose: 	 Get the last tab number the workdesk was on before the user closed the window
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  10/30/2000 K. Claver   Original Version
//  10/17/2001 K. Claver	Enhanced for registry.
//**********************************************************************************************
Integer l_nTabNum
String l_cTabNum

IF OBJCA.MGR.i_Source = "R" THEN
	RegistryGet( ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info\workdesk" ), "last_tab", &
					RegString!, l_cTabNum )
	l_nTabNum = Integer( l_cTabNum )
ELSE
	l_nTabNum = Integer( ProfileString( OBJCA.MGR.i_ProgINI, "Workdesk", "last_tab", "1" ) )
END IF

//----------------------------------------------------------------------------------------------
// Begin Added JWhite 6.7.2006 - Adding code to ensure that we aren't setting the SelectedTab
//											to a disabled tab.
//----------------------------------------------------------------------------------------------
Choose Case	l_nTabNum
	Case	5
		If tab_workdesk.is_using_new_appeals <> 'Y' Then 
			l_nTabNum = 1
		End If
	Case 	6
		If tab_workdesk.is_using_fax <> 'Y' Then 
			l_nTabNum = 1
		End If
End Choose
//----------------------------------------------------------------------------------------------
// End Added JWhite 6.7.2006
//----------------------------------------------------------------------------------------------

RETURN l_nTabNum
end function

public function integer fw_setlasttab ();//**********************************************************************************************
//
//  Function:  fw_SetLastTab
//   Purpose: 	Set the last tab the workdesk was on into the ini file for the next time the
//					workdesk is opened
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  10/30/2000 K. Claver   Original Version
//  10/17/2001 K. Claver	Enhanced for registry.
//**********************************************************************************************
Integer l_nRV

IF OBJCA.MGR.i_Source = "R" THEN
	l_nRV = RegistrySet( ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info\workdesk" ), "last_tab", &
								RegString!, String( tab_workdesk.SelectedTab ) )
ELSE
	l_nRV = SetProfileString( OBJCA.MGR.i_ProgINI, "Workdesk", &
								  "last_tab", String( tab_workdesk.SelectedTab ) )
END IF

RETURN l_nRV

end function

public subroutine fw_setokrefresh ();//**********************************************************************************************
//
//  Function:  fw_SetOKRefresh
//   Purpose: 	Set the instance variable to let the window know that it's ok to refresh
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  3/7/2002 K. Claver     Original Version
//**********************************************************************************************
THIS.i_bOkRefresh = TRUE
end subroutine

public subroutine of_show_systray_icon (string as_text);IF ib_enable_systray_icon THEN
	// If the inbox tab already has an icon on it, then don't show another system tray icon.
	IF tab_workdesk.tabpage_opencases.picturename <> "exclamation_icon.gif"  THEN
			ole_systray.object.SysTrayIcon(as_text)
	END IF
END IF

end subroutine

public subroutine of_hide_systray_icon ();IF ib_enable_systray_icon THEN
	ole_systray.object.HideIcon()
END IF

end subroutine

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions	
//  Purpose: To set uo_dw_main options, set the PowerClass Message object text and find out the 
//           user first and last name.
//						
//  Date     Developer     Description
//  -------- ------------- --------------------------------------------------------------------
//  05/21/99 M. Caruso     Change toolbar initialization from c_ToolbarLeft to c_ToolbarTop
//  04/20/00 C. Jackson    Change Tag from 'Reminders for ' to 'Work Desk for '
//  11/13/2000 K. Claver   Added to the select statement from the user table to populate the
//									confidentiality level instance variable.
//
//**********************************************************************************************
STRING       l_cRoleName[], l_cUserID
INT          l_nNumOfRoles, l_nCounter
LONG         l_nRoleKey[]
STRING l_cFirstName, l_cLastName, ls_enable_systray_icon

Tag = 'Work Desk for '

fw_SetOptions(c_Default + c_ToolbarTop)			// RAE 4/5/99; MPC 5/21/99

FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveMessage)

l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

SELECT user_first_name, 
		 user_last_name, 
		 confidentiality_level,
		 enable_systray_icon
INTO :l_cFirstName, 
     :l_cLastName,
	  :i_nRepConfidLevel,
	  :ls_enable_systray_icon
FROM cusfocus.cusfocus_user 
WHERE user_id =:l_cUserID
USING SQLCA;
			 
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(gs_AppName, "Unable to retrieve your user name from the database.")
END IF

Title = Tag + l_cFirstName + ' ' + l_cLastName
						  
fw_CheckOutOfOffice()

//	Get the Role Info from PowerLock and determine if the user has the Supervisor
//	Role which the Name will be stored in the application INI file or the registry.
IF OBJCA.MGR.i_Source = "R" THEN
	RegistryGet( ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info\roles" ), "modifyclosedcase", &
					 RegString!, i_cSupervisorRole )
ELSE
	i_cSupervisorRole = ProfileString(OBJCA.MGR.i_ProgINI, 'Roles', 'modifyclosedcase','')
END IF

IF i_cSupervisorRole <> '' AND NOT IsNull( i_cSupervisorRole ) THEN
 	SECCA.MGR.fu_GetRoleInfo(l_nRoleKey[], l_cRoleName[])
	l_nNumofRoles = UPPERBOUND(l_nRoleKey[])

	FOR l_nCounter = 1 to l_nNumofRoles
		IF l_cRoleName[l_nCounter] = i_cSupervisorRole THEN
			i_bSupervisorRole = TRUE
			EXIT
		END IF
	NEXT
END IF

IF ls_enable_systray_icon = 'Y' THEN
	ib_enable_systray_icon = TRUE
ELSE
	ib_enable_systray_icon = FALSE
END IF
end event

event activate;call super::activate;//********************************************************************************************
//
//  Event:   activate	
//  Purpose: Please see PB documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- -------------------------------------------------------------------
//  6/27/2001 K. Claver    Added code to check the refresh variable and refresh if the window
//									gains focus after the set timer interval.
//********************************************************************************************
int li_return

IF THIS.i_bOkRefresh THEN
	//If the set interval has passed, ok to refresh the window.
	tab_workdesk.Event Trigger ue_Refresh( )
END IF


IF tab_workdesk.tabpage_opencases.picturename = "exclamation_icon.gif" THEN
	li_return = tab_workdesk.tabpage_opencases.uo_search_open_cases.dw_report.find("case_viewed = 'N'", 1, tab_workdesk.tabpage_opencases.uo_search_open_cases.dw_report.rowcount())
	IF li_return < 1 THEN
		tab_workdesk.tabpage_opencases.picturename = ""
		of_hide_systray_icon( )
	END IF
END IF

end event

on w_reminders.create
int iCurrent
call super::create
if this.MenuName = "m_cusfocus_reminders" then this.MenuID = create m_cusfocus_reminders
this.ole_systray=create ole_systray
this.tab_workdesk=create tab_workdesk
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_systray
this.Control[iCurrent+2]=this.tab_workdesk
end on

on w_reminders.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ole_systray)
destroy(this.tab_workdesk)
end on

event open;call super::open;//**********************************************************************************************
//
//  Event:   open	
//  Purpose: Set Item for retrieval
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/27/00 C. Jackson    Original Version
//  04/19/00 C. Jackson    Remove selected row on open (SCR 539)
//  10/20/2000 K. Claver   Just set the timer delay in this event
//  10/24/2000 K. Claver   Initialize the resize service and register the tab object
//
//**********************************************************************************************
string ls_optionvalue

//----------------------------------------------------------------------------------------------
// Begin Added JWhite 6.7.2006 - Adding a configurable refresh rate system option
//----------------------------------------------------------------------------------------------
  SELECT cusfocus.system_options.option_value  
    INTO :is_timer_refresh_rate  
    FROM cusfocus.system_options  
   WHERE cusfocus.system_options.option_name = 'workdesk refresh rate'   ;

If Not IsNull(is_timer_refresh_rate) and (is_timer_refresh_rate <> '') and (Long(is_timer_refresh_rate) > 0) Then
	Timer(long(is_timer_refresh_rate))
Else
	Timer(600)
End If

//----------------------------------------------------------------------------------------------
// End Added JWhite 6.7.2006
//----------------------------------------------------------------------------------------------

THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_SetOrigSize( ( THIS.Width - 30 ), ( THIS.Height - 178 ) )
	THIS.inv_resize.of_SetMinSize( ( THIS.Width - 30 ), ( THIS.Height - 178 ) )
	
	THIS.inv_resize.of_Register( tab_workdesk, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF

//Open the workdesk to the user's last selected tab
THIS.Event Post ue_SelectTab( THIS.fw_GetLastTab( ) )


end event

event timer;call super::timer;//********************************************************************************************
//
//  Event:   timer	
//  Purpose: Call a retrieve based on the amount of time specified in the open event
//						
//  Date     Developer     Description
//  -------- ------------- -------------------------------------------------------------------
//  01/27/99 C. Jackson    Original Version
//  04/27/00 C. Jackson    Set SelectRow to False for all rows on the case list datawindow 
//                         (SCR 587)
//	 10/24/2000 K. Claver   Fire the ue_refresh event on the tab object
//  6/27/2001 K. Claver    Moved the ue_refresh code to the activate event.  This event only
//									triggers to notify the object that it is ok to refresh after 10 minutes.
//
//********************************************************************************************
integer li_return

THIS.i_bOkRefresh = TRUE

// Check to see if there are any unread cases for this user
Select top 1 1
into :li_return
from cusfocus.case_transfer
where case_transfer_type = 'O'
and case_transfer_to = :i_cUserID
and isnull(case_viewed, 'N') <> 'Y'
using sqlca;

IF li_return = 1 THEN
	of_show_systray_icon("There is an unread case in your Inbox")
	tab_workdesk.tabpage_opencases.picturename = "exclamation_icon.gif"
ELSE
	of_hide_systray_icon()
	tab_workdesk.tabpage_opencases.picturename = ""
END IF

end event

event pc_close;call super::pc_close;//**********************************************************************************************
//
//  Event:   pc_close
//  Purpose: Fired after PowerClass determines that it's ok to close the window
//						
//  Date     Developer     Description
//  -------- ------------- --------------------------------------------------------------------
//  10/30/2000 K. Claver   Set the last opened tab into the ini for the next time the workdesk is
//									opened
//**********************************************************************************************
THIS.fw_SetLastTab( )
end event

type ole_systray from olecustomcontrol within w_reminders
boolean visible = false
integer x = 59
integer y = 1600
integer width = 352
integer height = 144
integer taborder = 20
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_reminders.win"
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type tab_workdesk from uo_tab_workdesk within w_reminders
integer width = 3621
integer height = 1728
integer taborder = 20
end type

event resize;call super::resize;long	ll_workspaceheight

ll_workspaceheight = Parent.WorkSpaceHeight()

this.Height = ll_workspaceheight - (2 * this.x)

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
06w_reminders.bin 
2700000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000b336016001c8757a00000003000001400000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000d400000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff00000003cb5c22fb47058106624179bbb5309b6200000000b336016001c8757ab336016001c8757a000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000040000001000000000000000010000000200000003fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000fffe00020105cb5c22fb47058106624179bbb5309b6200000001fb8f0821101b01640008ed8413c72e2b00000030000000a40000000500000100000000300000010100000038000001020000004000000103000000480000000000000050000000030001000000000003000007f500000003000003b900000003000000000000000500000000000000010001030000000c0074735f00706b636f73706f72000101000000090078655f00746e65740102007800090000655f00006e65747800007974090000015f00000073726576006e6f69007200650039005c005c0030006f0054006c006f005c007300690042006e006e0056005c005300530065006800010000000007f5000003b9000000000037006e0049005c00450044003b005c003a00630070005c0039006200750062006c0069003b0064003a0043003b005c003a00430049005c004d0042004f0057004b00520043003b005c003a004200490057004d0052004f005c004b004f0054004c004f003b0053003a00430050005c0039004200750042006c0069003b0064003a00430050005c006f007200720067006d006100460020006c0069007300650053005c0062007900730061005c0065005100530020004c006e004100770079006500680065007200310020005c0030006900770033006e003b0032003a00430050005c006f007200720067006d0061000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
16w_reminders.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
