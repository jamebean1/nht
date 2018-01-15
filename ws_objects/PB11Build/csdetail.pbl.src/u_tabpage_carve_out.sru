$PBExportHeader$u_tabpage_carve_out.sru
$PBExportComments$Carve Out tab object.
forward
global type u_tabpage_carve_out from u_tabpg_std
end type
type dw_carve_out_reason from datawindow within u_tabpage_carve_out
end type
type cbx_override from checkbox within u_tabpage_carve_out
end type
type em_total_days from editmask within u_tabpage_carve_out
end type
type st_total_days from statictext within u_tabpage_carve_out
end type
type st_reason from statictext within u_tabpage_carve_out
end type
type st_noitemnotice from statictext within u_tabpage_carve_out
end type
type cbx_mtm_exclude from checkbox within u_tabpage_carve_out
end type
type cb_new from commandbutton within u_tabpage_carve_out
end type
type cb_modify from commandbutton within u_tabpage_carve_out
end type
type dw_carve_out_list from u_dw_std within u_tabpage_carve_out
end type
end forward

global type u_tabpage_carve_out from u_tabpg_std
integer width = 3534
integer height = 784
string text = "Carve Out"
dw_carve_out_reason dw_carve_out_reason
cbx_override cbx_override
em_total_days em_total_days
st_total_days st_total_days
st_reason st_reason
st_noitemnotice st_noitemnotice
cbx_mtm_exclude cbx_mtm_exclude
cb_new cb_new
cb_modify cb_modify
dw_carve_out_list dw_carve_out_list
end type
global u_tabpage_carve_out u_tabpage_carve_out

type variables
W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder
U_DW_STD						i_dwCaseDetails

Boolean						i_bModified
Boolean						i_bDisable
end variables

forward prototypes
public subroutine fu_delete ()
public subroutine fu_disable (boolean a_bdisable)
public function string fu_calccarveout ()
public subroutine fu_settabgui ()
end prototypes

public subroutine fu_delete ();/*****************************************************************************************
   Function:   fu_Delete
   Purpose:    Delete a carve out entry
	
	Parameters: None
	Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/30/2001 K. Claver   Created.
*****************************************************************************************/
Long l_nRows[ ]
Integer l_nRV, l_nCount, l_nSelectedRow
String l_cCarveID

IF dw_carve_out_list.RowCount( ) > 0 THEN
	IF dw_carve_out_list.GetSelectedRow( 0 ) > 0 THEN
		l_nRV = MessageBox( gs_AppName, &
								  "Are you sure you want to delete the selected carve out entry?", &
								  Question!, &
								  YesNo! )
								  
		IF l_nRV = 1 THEN	
			l_nRows[ 1 ] = dw_carve_out_list.GetSelectedRow( 0 )
			
			//Get the carve out id to delete the associated reminder
			l_cCarveID = dw_carve_out_list.Object.co_id[ l_nRows[ 1 ] ]
			
			//Check to see if there is an existing reminder
			IF NOT IsNull( l_cCarveID ) THEN
				SELECT Count( * )
				INTO :l_nCount
				FROM cusfocus.reminders
				WHERE cusfocus.reminders.co_id = :l_cCarveID
				USING SQLCA;
			END IF
			
			IF l_nCount > 0 THEN
				DELETE cusfocus.reminders
				WHERE cusfocus.reminders.co_id = :l_cCarveID
				USING SQLCA;
				
				IF SQLCA.SQLCode < 0 THEN
					MessageBox( gs_AppName, "Error deleting associated reminders for the carve out entry", &
									StopSign!, OK! )
									
					Error.i_FWError = dw_carve_out_list.c_Fatal
					RETURN
				END IF
			END IF
			
			l_nRV = dw_carve_out_list.fu_Delete( 1, &
															 l_nRows, &
															 dw_carve_out_list.c_IgnoreChanges )
												  
			IF l_nRV <> 0 THEN
				Error.i_FWError = dw_carve_out_list.c_Fatal
			ELSE
				l_nRV = dw_carve_out_list.fu_Save( dw_carve_out_list.c_SaveChanges )
				
				IF l_nRV <> 0 THEN
					Error.i_FWError = dw_carve_out_list.c_Fatal
				ELSE
					//Recalculate the carve out days and save the case if override isn't checked.
					IF NOT cbx_override.Checked THEN
						em_total_days.Text = THIS.fu_CalcCarveout( )
						em_total_days.Event Trigger ue_Changed( )
						
						i_wParentWindow.i_uoCaseDetails.fu_savecase (dw_carve_out_list.c_savechanges)
						
						IF dw_carve_out_list.RowCount( ) > 0 THEN
							dw_carve_out_reason.Retrieve( dw_carve_out_list.GetItemString( dw_carve_out_list.GetSelectedRow( 0 ), "co_id" ) )
						ELSE
							dw_carve_out_reason.Reset( )
						END IF
					ELSE
						//If no rows left and override is checked, uncheck, disable and clear
						//  override days.
						IF dw_carve_out_list.RowCount( ) = 0 THEN
							cbx_override.Checked = FALSE
							cbx_override.Event Trigger ue_changed( )
							cbx_override.Enabled = FALSE
							em_total_days.Text = ""
							em_total_days.Event Trigger ue_changed( )
							
							i_wParentWindow.i_uoCaseDetails.fu_savecase (dw_carve_out_list.c_savechanges)
							
							IF dw_carve_out_list.RowCount( ) > 0 THEN
								dw_carve_out_reason.Retrieve( dw_carve_out_list.GetItemString( dw_carve_out_list.GetSelectedRow( 0 ), "co_id" ) )
							ELSE
								dw_carve_out_reason.Reset( )
							END IF
						END IF
					END IF
				END IF
			END IF
		END IF
	END IF
END IF
end subroutine

public subroutine fu_disable (boolean a_bdisable);/*****************************************************************************************
   Function:   fu_Disable
   Purpose:    Enable/Disable the controls on the tab depending on the status of a case
	
	Parameters: a_bDisable - To determine if should enable or disable the controls.
	Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/30/2001 K. Claver   Created.
*****************************************************************************************/
IF a_bDisable THEN
	//Disable the controls
	i_bDisable = TRUE
	
	em_total_days.Enabled = FALSE
	em_total_days.BackColor = RGB( 192, 192, 192 )
	
	cbx_override.Enabled = FALSE
	cbx_mtm_exclude.Enabled = FALSE
	
	cb_new.Enabled = FALSE
	cb_modify.Enabled = FALSE
	
	m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
ELSE	
	//Enable the controls
	i_bDisable = FALSE
	
	//Only set backcolor to white and enable if the override checkbox is checked.
	IF cbx_override.Checked THEN
		em_total_days.Enabled = TRUE
		em_total_days.BackColor = RGB( 255, 255, 255 )
	END IF
	
	cbx_mtm_exclude.Enabled = TRUE
	
	IF NOT IsNull( i_wParentWindow.i_cCurrentCase ) AND &
	   Trim( i_wParentWindow.i_cCurrentCase ) <> "" THEN
		cb_new.Enabled = TRUE
	END IF
	
	IF dw_carve_out_list.RowCount( ) > 0 THEN
		cb_modify.Enabled = TRUE
		cbx_override.Enabled = TRUE
		m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = TRUE
	END IF
END IF
end subroutine

public function string fu_calccarveout ();/*****************************************************************************************
   Function:   fu_CalcCarveOut
   Purpose:    Calculate the total number of carveout days.  Accuracy of this function relies
					on the sort in the list datawindow being set to start_date ASC, end_date ASC.
	
	Parameters:  None
	Returns:		 String - total number of carveout days.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/27/2001 K. Claver   Created
	8/24/2001 K. Claver   Changed to use datastore for the calculation so can click-sort
								 the main datawindow.
*****************************************************************************************/
Date l_dGreatestEnd, l_dCurrStart, l_dCurrEnd
Integer l_nIndex, l_nGapIndex = 0
Long l_nDays = 0, l_nDayDiff
Boolean l_bOneCalc = FALSE
DataStore l_dsCalcData

l_dsCalcData = CREATE DataStore
l_dsCalcData.DataObject = "d_carve_out_entry_list"

IF dw_carve_out_list.RowCount( ) > 0 THEN
	dw_carve_out_list.RowsCopy( 1, dw_carve_out_list.RowCount( ), Primary!, &
										 l_dsCalcData, 1, Primary! )
	
	l_dsCalcData.Sort( )

	FOR l_nIndex = 1 TO l_dsCalcData.RowCount( )	
		l_dCurrStart = Date( l_dsCalcData.Object.start_date[ l_nIndex ] )
		l_dCurrEnd = Date( l_dsCalcData.Object.end_date[ l_nIndex ] )
		
		IF IsNull( l_dCurrStart ) OR IsNull( l_dCurrEnd ) THEN
			CONTINUE
		ELSE
			//Set flag to let the function know that at least one row was used in the
			//  calculation.
			l_bOneCalc = TRUE
			
			IF l_nIndex = 1 OR l_dCurrStart >= l_dGreatestEnd THEN
				//If the first row or the current start date is greater than the greatest
				//  end date, just add the days
				l_nDayDiff = DaysAfter( l_dCurrStart, l_dCurrEnd )
				
				//The difference between the days has to at least be one
				IF l_nDayDiff = 0 THEN
					l_nDays ++
				ELSE
					l_nDays += l_nDayDiff
				END IF
			ELSE
				//If the current start date is less than the
				//  greatest end date and the current end date is greater
				//  than the greatest end date, add the difference
				//  between the end dates.
				IF l_dCurrEnd >= l_dGreatestEnd THEN
					l_nDayDiff = DaysAfter( l_dGreatestEnd, l_dCurrEnd )
					
					//The difference between the days has to at least be one
					IF l_nDayDiff = 0 THEN
						l_nDays ++
					ELSE
						l_nDays += l_nDayDiff
					END IF
				END IF			
			END IF
		END IF
		
		IF l_dCurrEnd > l_dGreatestEnd THEN
			l_dGreatestEnd = l_dCurrEnd
		END IF
	NEXT
END IF

//If at least one row was used in the calculation, need to set the
//  number of days to one if set to zero to accomodate for one
//  row with a start date and end date of the same date.
IF l_bOneCalc AND l_nDays = 0 THEN
	l_nDays = 1
END IF

//Destroy the datastore we created for the calc.
DESTROY l_dsCalcData

RETURN String( l_nDays )
end function

public subroutine fu_settabgui ();/*****************************************************************************************
   Function:   fu_SetTabGUI
   Purpose:    Set the status of the interface items
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/18/02 M. Caruso    Created.
	04/26/02 M. Caruso    Replaced call to fu_CheckLocked with reference to i_bCaseLocked.
	9/26/2002 K. Claver   Added boolean to enable/disable mtm exclude checkbox if case locked/unlocked.
*****************************************************************************************/

BOOLEAN	l_bCaseLocked, l_bAvailable, l_bAllowNew, l_bAllowModify, l_bRecordsExist
BOOLEAN	l_bAllowExclude
LONG		l_nCount
STRING	l_cCaseStatus, l_cOptionName, l_cSourceTypes

// detemine state variables
l_cCaseStatus = i_wParentWindow.i_uoCaseDetails.i_cCaseStatus
l_bCaseLocked = i_wParentWindow.i_bCaseLocked
l_bRecordsExist = (dw_carve_out_list.RowCount () > 0)
CHOOSE CASE i_wParentWindow.i_cCaseType
	CASE i_wParentWindow.i_cInquiry
		l_cOptionName = 'carveout inquiry'
		
	CASE i_wParentWindow.i_cIssueConcern
		l_cOptionName = 'carveout issue'
		
	CASE i_wParentWindow.i_cConfigCaseType
		l_cOptionName = 'carveout configurable'
		
	CASE i_wParentWindow.i_cProactive
		l_cOptionName = 'carveout proactive'
		
END CHOOSE

l_cSourceTypes = '%' + i_wParentWindow.i_cSourceType + '%'

SELECT Count(*) INTO :l_nCount
  FROM cusfocus.system_options
 WHERE option_name = :l_cOptionName
	AND option_value LIKE :l_cSourceTypes
 USING SQLCA;
	
CHOOSE CASE SQLCA.SQLCode
	CASE -1
		// report the error and set all options to FALSE
		MessageBox (gs_appname, 'Unable to determine carve out availability so the interface is not enabled.')
		l_bAvailable = FALSE

	CASE 0
		IF l_nCount = 0 THEN
			l_bAvailable = FALSE
		ELSE
			l_bAvailable = TRUE
		END IF
		
	CASE 100
		l_bAvailable = FALSE
		
END CHOOSE

// set the button status
IF l_bCaseLocked OR l_cCaseStatus <> 'O' OR TRIM (i_wParentWindow.i_cCurrentCase) = "" THEN

	// disable the buttons
	l_bAllowNew = FALSE
	l_bAllowModify = FALSE
	l_bAllowExclude = FALSE

	em_total_days.Enabled = FALSE
	em_total_days.BackColor = RGB( 192, 192, 192 )
	
	cbx_override.Enabled = FALSE
	cbx_mtm_exclude.Enabled = FALSE

ELSE
	
	// determine how the individual buttons should be set
	IF l_bAvailable THEN
		l_bAllowNew = TRUE
	ELSE
		l_bAllowNew = FALSE
	END IF
	
	IF l_bRecordsExist THEN
		l_bAllowModify = TRUE
	ELSE
		l_bAllowModify = FALSE
	END IF
	
	l_bAllowExclude = TRUE
	
END IF

// set the buttons based on the setting from above.
cb_New.Enabled = l_bAllowNew
cb_Modify.Enabled = l_bAllowModify
cbx_mtm_exclude.Enabled = l_bAllowExclude
end subroutine

on u_tabpage_carve_out.create
int iCurrent
call super::create
this.dw_carve_out_reason=create dw_carve_out_reason
this.cbx_override=create cbx_override
this.em_total_days=create em_total_days
this.st_total_days=create st_total_days
this.st_reason=create st_reason
this.st_noitemnotice=create st_noitemnotice
this.cbx_mtm_exclude=create cbx_mtm_exclude
this.cb_new=create cb_new
this.cb_modify=create cb_modify
this.dw_carve_out_list=create dw_carve_out_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_carve_out_reason
this.Control[iCurrent+2]=this.cbx_override
this.Control[iCurrent+3]=this.em_total_days
this.Control[iCurrent+4]=this.st_total_days
this.Control[iCurrent+5]=this.st_reason
this.Control[iCurrent+6]=this.st_noitemnotice
this.Control[iCurrent+7]=this.cbx_mtm_exclude
this.Control[iCurrent+8]=this.cb_new
this.Control[iCurrent+9]=this.cb_modify
this.Control[iCurrent+10]=this.dw_carve_out_list
end on

on u_tabpage_carve_out.destroy
call super::destroy
destroy(this.dw_carve_out_reason)
destroy(this.cbx_override)
destroy(this.em_total_days)
destroy(this.st_total_days)
destroy(this.st_reason)
destroy(this.st_noitemnotice)
destroy(this.cbx_mtm_exclude)
destroy(this.cb_new)
destroy(this.cb_modify)
destroy(this.dw_carve_out_list)
end on

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    set values for instance variables

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/26/01 M. Caruso    Created.
	03/23/01 M. Caruso    Added new interface items for total days and carve out reason.
	3/27/2001 K. Claver   Added code to set the pointer variable for the case details datawindow
	4/13/2001 K. Claver   Changed to correctly use the new resize service.
*****************************************************************************************/


i_wParentWindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder
i_dwCaseDetails = i_tabFolder.tabpage_case_details.dw_case_details

THIS.of_SetResize (TRUE)
IF IsValid (THIS.inv_resize) THEN
	// resize the carve out list view
	THIS.inv_resize.of_Register (dw_carve_out_list, "ScaleToRight&Bottom")
	// resize the carve out reason view
	THIS.inv_resize.of_Register (dw_carve_out_reason, "FixedToBottom&ScaleToRight")
	THIS.inv_resize.of_Register (st_reason, "FixedToBottom")
	// resize the Total Days interface
	THIS.inv_resize.of_Register (st_total_days, "FixedToBottom")
	// resize the override check box
	THIS.inv_resize.of_Register (cbx_override, "FixedToBottom")
	// resize the mtm exclude check box
	THIS.inv_resize.of_Register (cbx_mtm_exclude, "FixedToBottom")
	// resize the "New Entry" command button
	THIS.inv_resize.of_Register (cb_new, "FixedToRight&Bottom")
	// resize the "Modify Entry" command button
	THIS.inv_resize.of_Register (cb_modify, "FixedToRight&Bottom")
	//resize the total days edit mask
	THIS.inv_resize.of_Register( em_total_days, "FixedToBottom" )	
END IF
end event

type dw_carve_out_reason from datawindow within u_tabpage_carve_out
integer x = 14
integer y = 480
integer width = 3497
integer height = 160
integer taborder = 20
string title = "none"
string dataobject = "d_carve_out_reason"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;THIS.SetTransObject( SQLCA )
end event

type cbx_override from checkbox within u_tabpage_carve_out
event ue_changed ( )
integer x = 631
integer y = 680
integer width = 311
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Override:"
boolean lefttext = true
end type

event ue_changed;/*****************************************************************************************
   Event:      ue_changed
   Purpose:    Change the value of this field in the case details datawindow each time
					it changes.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/27/2001 K. Claver   Created
*****************************************************************************************/
IF THIS.Checked THEN
	em_total_days.Enabled = TRUE
	em_total_days.BackColor = RGB( 255, 255, 255 )
	
	i_dwCaseDetails.SetItem( i_dwCaseDetails.i_CursorRow, "case_log_carve_days_override", "Y" )
ELSE
	em_total_days.Enabled = FALSE
	em_total_days.BackColor = RGB( 192, 192, 192 )
	
	i_dwCaseDetails.SetItem( i_dwCaseDetails.i_CursorRow, "case_log_carve_days_override", "N" )
END IF
end event

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/27/2001 K. Claver   Added code to enable/disable the total days edit field.
*****************************************************************************************/
IF THIS.Checked THEN
	em_total_days.Enabled = TRUE
	em_total_days.BackColor = RGB( 255, 255, 255 )
	
	i_dwCaseDetails.SetItem( i_dwCaseDetails.i_CursorRow, "case_log_carve_days_override", "Y" )
ELSE
	em_total_days.Enabled = FALSE
	em_total_days.BackColor = RGB( 192, 192, 192 )
	
	i_dwCaseDetails.SetItem( i_dwCaseDetails.i_CursorRow, "case_log_carve_days_override", "N" )
	
	em_total_days.Text = PARENT.fu_CalcCarveOut( )
	em_total_days.Event Trigger ue_changed( )
END IF
end event

type em_total_days from editmask within u_tabpage_carve_out
event ue_changed pbm_enchange
integer x = 343
integer y = 672
integer width = 256
integer height = 84
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "######"
end type

event ue_changed;/*****************************************************************************************
   Event:      ue_changed
   Purpose:    Change the value of this field in the case details datawindow each time
					it changes.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/27/2001 K. Claver   Created
*****************************************************************************************/
i_dwCaseDetails.SetItem( i_dwCaseDetails.i_CursorRow, "case_log_carve_out_days", Long( THIS.Text ) )
end event

type st_total_days from statictext within u_tabpage_carve_out
integer x = 18
integer y = 684
integer width = 325
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total Days:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_reason from statictext within u_tabpage_carve_out
integer x = 18
integer y = 416
integer width = 594
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reason for Carve Out:"
boolean focusrectangle = false
end type

type st_noitemnotice from statictext within u_tabpage_carve_out
boolean visible = false
integer x = 37
integer y = 104
integer width = 1312
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "There are no carve out entries for this case."
boolean focusrectangle = false
end type

type cbx_mtm_exclude from checkbox within u_tabpage_carve_out
integer x = 1266
integer y = 688
integer width = 1102
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Exclude this case from MTM reporting:"
boolean lefttext = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Perform this functionality when the item is clicked.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/19/01 M. Caruso    Created.
	3/27/2001 K. Claver   Removed the local case details datawindow variable.
*****************************************************************************************/
IF checked THEN
	i_dwCaseDetails.SetItem (i_dwCaseDetails.i_CursorRow, 'case_log_mtm_exclude', 'Y')
ELSE
	i_dwCaseDetails.SetItem (i_dwCaseDetails.i_CursorRow, 'case_log_mtm_exclude', 'N')
END IF
end event

type cb_new from commandbutton within u_tabpage_carve_out
integer x = 2578
integer y = 672
integer width = 448
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New Entry"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    trigger the "new carve out entry" functionality.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/26/01 M. Caruso    Created.
	03/08/01 M. Caruso    Added code to refresh the list if changes were made.
	03/19/01 M. Caruso    Trigger saving of case details if changes were made.
	4/2/2001 K. Claver    Added case type to the PCCA.Parm array.
	4/17/2001 K. Claver   Added source type to the PCCA.Parm array.
*****************************************************************************************/

U_DW_STD	l_dwCaseDetails

PCCA.Parm[1] = ''
PCCA.Parm[2] = i_wParentWindow.i_cCurrentCase
PCCA.Parm[3] = i_wParentWindow.i_cCaseType
PCCA.Parm[4] = i_wParentWindow.i_cSourceType
FWCA.MGR.fu_OpenWindow (w_carve_out)

// if changes were made to carve out entry data, do the following...
IF PCCA.Parm[1] = '1' THEN
	
	// update the carve out list.
	dw_carve_out_list.fu_retrieve (dw_carve_out_list.c_ignorechanges, dw_carve_out_list.c_noreselectrows)
	
	// update the case detail datawindow because the case has changed.
	l_dwCaseDetails = i_tabfolder.tabpage_case_details.dw_case_details
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'updated_by', OBJCA.WIN.fu_GetLogin (SQLCA))
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_updated_timestamp', i_wParentWindow.fw_GetTimestamp ())
	
	//If the override isn't checked, recalc the carve out days.
	IF NOT cbx_override.Checked THEN
		em_total_days.Text = PARENT.fu_CalcCarveOut( )
		em_total_days.Event Trigger ue_Changed( )
	END IF
	
	i_wParentWindow.i_uoCaseDetails.fu_savecase (l_dwCaseDetails.c_savechanges)
	
END IF
end event

type cb_modify from commandbutton within u_tabpage_carve_out
integer x = 3058
integer y = 672
integer width = 448
integer height = 88
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Modify Entry"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    trigger the "modify carve out entry" functionality.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/26/01 M. Caruso    Created.
	03/08/01 M. Caruso    Added code to refresh the list if changes were made.
	03/19/01 M. Caruso    Trigger saving of case details if changes were made.
	3/30/2001 K. Claver   Fixed to only open the window if there are rows in the list datawindow.
	4/2/2001 K. Claver    Added case type to PCCA.Parm array.
	4/17/2001 K. Claver   Added source type to the PCCA.Parm array.
*****************************************************************************************/

LONG		l_nRow
U_DW_STD	l_dwCaseDetails

l_nRow = dw_carve_out_list.GetRow ()

IF l_nRow > 0 THEN

	PCCA.Parm[1] = dw_carve_out_list.GetItemString (l_nRow, 'co_id')
	PCCA.Parm[2] = i_wParentWindow.i_cCurrentCase
	PCCA.Parm[3] = i_wParentWindow.i_cCaseType
	PCCA.Parm[4] = i_wParentWindow.i_cSourceType
	FWCA.MGR.fu_OpenWindow (w_carve_out)
	
	// if changes were made to carve out entry data, do the following...
	IF PCCA.Parm[1] = '1' THEN
		
		// update the carve out list.
		dw_carve_out_list.fu_retrieve (dw_carve_out_list.c_ignorechanges, dw_carve_out_list.c_noreselectrows)
		
		// update the case detail datawindow because the case has changed.
		l_dwCaseDetails = i_tabfolder.tabpage_case_details.dw_case_details
		l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'updated_by', OBJCA.WIN.fu_GetLogin (SQLCA))
		l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_updated_timestamp', i_wParentWindow.fw_GetTimestamp ())
		
		//If the override isn't checked, recalc the carve out days.
		IF NOT cbx_override.Checked THEN
			em_total_days.Text = PARENT.fu_CalcCarveOut( )
			em_total_days.Event Trigger ue_Changed( )
		END IF
		
		i_wParentWindow.i_uoCaseDetails.fu_savecase (l_dwCaseDetails.c_savechanges)
		
	END IF	
END IF

end event

type dw_carve_out_list from u_dw_std within u_tabpage_carve_out
event ue_selecttrigger pbm_dwnkey
integer x = 14
integer y = 12
integer width = 3497
integer height = 388
integer taborder = 10
string dataobject = "d_carve_out_entry_list"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;/*****************************************************************************************
   Event:      ue_selecttrigger
   Purpose:    Open the entry for editing by pressing the ENTER key

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/09/01 M. Caruso    Created.
	05/01/02 M. Caruso    Enable functionality only if the Modify button is Enabled.
*****************************************************************************************/

IF key = KeyEnter! AND THIS.RowCount( ) > 0 THEN
	
	IF cb_modify.Enabled THEN
		cb_modify.TriggerEvent ('clicked')
	END IF
	RETURN -1
	
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve records from the database

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/26/01 M. Caruso    Created.
	4/9/2001 K. Claver    Added code to retrieve the carve out reason datawindow.  Not using
								 a PowerClass datawindow control as couldn't get the control to
								 enable no matter what options I set.
*****************************************************************************************/
String l_cCarveOutID

IF retrieve (i_wParentWindow.i_cCurrentCase) > 0 THEN
	l_cCarveOutID = THIS.GetItemString (1, 'co_id')
	CHOOSE CASE dw_carve_out_reason.retrieve (l_cCarveOutID)
		CASE IS < 0
			MessageBox (gs_appname, 'An error occurred while retrieving the carve out reason.')
			
		CASE 0
			MessageBox (gs_appname, 'No reason was found for this carve out entry.')
			
		CASE ELSE			
		
	END CHOOSE
	
//	st_noitemnotice.visible = FALSE
	cb_modify.enabled = TRUE
	cbx_override.Enabled = TRUE
ELSE
	dw_carve_out_reason.Reset( )
	
//	st_noitemnotice.visible = TRUE
	cb_modify.enabled = FALSE	
	cbx_override.Enabled = FALSE
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Initialize this datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/27/01 M. Caruso    Created.
*****************************************************************************************/

fu_SetOptions (SQLCA, &
					c_NullDW, &
					c_MasterList+ &
					c_NoRetrieveOnOpen + &
					c_NoShowEmpty + &
					c_NoEnablePopup + &
					c_DeleteOK + &
					c_NoMenuButtonActivation + &
					c_SortClickedOK )
end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
   Event:      doubleclicked
   Purpose:    Open the entry for editing

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/09/01 M. Caruso    Created.
	03/23/01 M. Caruso    Only process if the case is open.
	03/30/01 K. Claver    Added condition to allow the modify window to be opened if click
								 on a computed field.  Needed for double-click on computed created
								 by and closed by fields.
	05/01/02 M. Caruso    Enable functionality only if the Modify button is Enabled.
*****************************************************************************************/

IF ( dwo.Type = 'column' OR dwo.Type = 'compute' ) AND NOT i_bDisable THEN
	
	IF cb_modify.Enabled THEN
		cb_modify.TriggerEvent ('clicked')
	END IF
	
END IF
end event

event clicked;call super::clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/9/2001 K. Claver    Added code to retrieve the carve out reason datawindow.  Not using
								 a PowerClass datawindow control as couldn't get the control to
								 enable no matter what options I set.
*****************************************************************************************/
String l_cCarveOutID

IF row > 0 THEN
	l_cCarveOutID = THIS.GetItemString (row, 'co_id')
	CHOOSE CASE dw_carve_out_reason.retrieve (l_cCarveOutID)
		CASE IS < 0
			MessageBox (gs_appname, 'An error occurred while retrieving the carve out reason.')
			
		CASE 0
			MessageBox (gs_appname, 'No reason was found for this carve out entry.')
			
		CASE ELSE
			
		
	END CHOOSE
END IF
end event

