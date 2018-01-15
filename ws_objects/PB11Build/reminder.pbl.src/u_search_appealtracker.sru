$PBExportHeader$u_search_appealtracker.sru
forward
global type u_search_appealtracker from u_search
end type
type st_slider from u_slider_control_horizontal within u_search_appealtracker
end type
type tab_appeal_preview from uo_tab_appeal_preview within u_search_appealtracker
end type
type tab_appeal_preview from uo_tab_appeal_preview within u_search_appealtracker
end type
end forward

global type u_search_appealtracker from u_search
integer width = 3611
integer height = 2492
event ue_post_constructor ( )
event type string ue_template_restore ( )
event ue_template_save ( )
st_slider st_slider
tab_appeal_preview tab_appeal_preview
end type
global u_search_appealtracker u_search_appealtracker

type variables
n_column_sizing_service in_columnsizingservice_detail

long	il_reportconfigid
long 	il_conf_level
datastore	ids_savedreport

blob	iblob_syntax
string	is_syntax, is_original_syntax
W_REMINDERS		i_wParentWindow

end variables

forward prototypes
public subroutine of_set_conf_level (integer as_conf_level)
end prototypes

event ue_post_constructor();long l_sliderpos, ll_value
st_slider.of_add_upper_object(dw_report)
st_slider.of_add_lower_object(tab_appeal_preview)
st_slider.backcolor = gn_globals.in_theme.of_get_barcolor()

ll_value = dw_report.y
ll_value = dw_report.height
ll_value = tab_appeal_preview.y
ll_value = tab_appeal_preview.height

n_registry ln_registry
l_sliderpos  			= 						long(	ln_registry.of_get_registry_key('users\' +  gn_globals.is_username + '\' + This.ClassName() + '\slidery'))

If l_sliderpos > 0 And Not IsNull(l_sliderpos) Then
	//st_slider.y = Min(Max(l_sliderpos, st_separator.Y + st_separator.Height + 100), Height - 100)
End If

uo_titlebar.of_delete_button('Customize...')
uo_titlebar.of_add_button('Restore Original View', 'restore')

// 11/27/06 RAP - With proper security, users can save report templates
IF gn_globals.il_view_confidentiality_level > 2 THEN
	uo_titlebar.of_add_button('Save View As Template', 'save template' )
	uo_titlebar.of_add_button('Restore Template View', 'restore template' )
END IF


end event

event type string ue_template_restore();//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null, ll_pos
string	ls_null, ls_syntax, ls_parm
blob		lb_syntax

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator


OpenWithParm(w_template_restore, il_reportconfigid)
ll_blobID = Message.DoubleParm

If Not IsNull(ll_blobid) and ll_blobid > 0 Then
	ln_blob_manipulator = Create n_blob_manipulator
	
	iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobid)
	
	ls_syntax = String(iblob_currentstate)
	
	// Make sure we converted it correctly - RAP 11/4/08
	ll_pos = Pos( ls_syntax, "release" )
	IF ll_pos = 0 THEN
		ls_syntax = string(iblob_currentstate, EncodingANSI!)
	END IF
	
	Destroy ln_blob_manipulator
End If

RETURN ls_syntax

end event

event ue_template_save();//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null
string	ls_null, ls_syntax
blob		lb_syntax

//----------------------------------------------------------------------------------------------------------------------------------
// 11/27/06 RAP - Do not save the filter with the datawindow syntax
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report.SetFilter("")
dw_report.Filter()
ls_syntax = dw_report.Describe("DataWindow.Syntax")

ls_syntax = String(il_reportconfigid) + "/" + ls_syntax
OpenWithParm(w_template_save, ls_syntax)


end event

public subroutine of_set_conf_level (integer as_conf_level);il_conf_level = as_conf_level
end subroutine

on u_search_appealtracker.create
int iCurrent
call super::create
this.st_slider=create st_slider
this.tab_appeal_preview=create tab_appeal_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_slider
this.Control[iCurrent+2]=this.tab_appeal_preview
end on

on u_search_appealtracker.destroy
call super::destroy
destroy(this.st_slider)
destroy(this.tab_appeal_preview)
end on

event ue_retrieve;call super::ue_retrieve;long ll_row, ll_appealheaderid, ll_return
string	ls_null
SetNull(ls_null)

ll_return = dw_report.Retrieve(ls_null, 'N')
ll_row = dw_report.GetRow()

If ll_row > 0 and ll_row <= dw_report.RowCount() Then 
	ll_appealheaderid = dw_report.GetItemNumber(ll_row, 'appealheaderid')
	tab_appeal_preview.tabpage_appeal_preview.dw_appeal_preview.Retrieve(ll_appealheaderid)
	If Not IsNull(il_conf_level) Then
		ll_row = tab_appeal_preview.tabpage_case_preview.dw_case_preview.Retrieve(dw_report.GetItemString(ll_row, 'casenumber'), il_conf_level)
	END IF
End If


end event

event resize;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Resize
// Overrides:  yes!!!!!!!!!!!!!!!!
// Overview:   Resize the controls that were added to u_search
// Created by: JWhite
// History:    7/27/06 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_setredraw(False)

Call Super::resize


st_slider.Visible 			= Not IsValid(iu_overlaying_report)
tab_appeal_preview.Visible  	= Not IsValid(iu_overlaying_report)

If Not IsValid(iu_overlaying_report) Then
	st_slider.Width = Width
	dw_report.Height = st_slider.Y - dw_report.Y
	tab_appeal_preview.Width = dw_report.Width
	tab_appeal_preview.Height = Height - tab_appeal_preview.Y
End If	
This.of_setredraw(True)


end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//					aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by:
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_row
String ls_syntax
Datawindow ldw_data

Choose Case Lower(Trim(as_message))
	Case 'filter' //This is when the datawindow is filtered
		If dw_report.RowCount() = 0 Then
			tab_appeal_preview.tabpage_case_preview.dw_case_preview.Reset()
			tab_appeal_preview.tabpage_appeal_preview.dw_appeal_preview.Reset()
		Else
			ll_row = dw_report.GetRow()
			If ll_row > 0 And ll_row <= dw_report.RowCount() And Not IsNull(ll_row) Then
				dw_report.Event RowFocusChanged(ll_row)
			End If
		End If

	Case 'selectall'
	Case 'button clicked'
		Choose Case string(as_arg)
			Case 'restore'
					dw_report.Create(is_original_syntax)
					dw_report.EVENT TRIGGER ue_refresh_services()
					dw_report.TriggerEvent('ue_retrieve')
					THIS.TriggerEvent('resize')
			Case 'save template'
					THIS.EVENT ue_template_save()
			Case 'restore template'
					ls_syntax = THIS.EVENT ue_template_restore()
					dw_report.Create(ls_syntax)
					dw_report.TriggerEvent('ue_refresh_services')
					dw_report.TriggerEvent('ue_retrieve')
					THIS.TriggerEvent('resize')
			End Choose
	Case Else
		IF ClassName(as_arg) = "dw_report" THEN
			   ll_row = dw_report.GetRow()
	   		dw_report.Event RowFocusChanged(ll_row)
		END IF
End Choose


end event

event ue_refreshtheme;call super::ue_refreshtheme;st_slider.backcolor = gn_globals.in_theme.of_get_barcolor()

end event

event constructor;call super::constructor;This.Post Event ue_post_constructor()	

//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long	ll_rows, ll_pos
long	ll_blobobjectid
n_blob_manipulator ln_blob_manipulator
blob	lblob_datawindow_syntax
string	l_sMsg, ls_syntax

ln_blob_manipulator = Create n_blob_manipulator
//----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore, set the dataobject and the transaction
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport = Create datastore
ids_savedreport.DataObject = 'd_data_savedreport_user_reportconfig'
ids_savedreport.SetTransObject(SQLCA)

//----------------------------------------------------------------------------------------------------------------------------------
// Store the original syntax in case we want to revert to it
//-----------------------------------------------------------------------------------------------------------------------------------
is_original_syntax = dw_report.Object.Datawindow.Syntax


//----------------------------------------------------------------------------------------------------------------------------------
// Get the rprtcnfgid so that we can look in SavedReport table to see if a previous saved syntax exists
//-----------------------------------------------------------------------------------------------------------------------------------
  SELECT cusfocus.reportconfig.rprtcnfgid  
    INTO :il_reportconfigid  
    FROM cusfocus.reportconfig  
   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Appeals'   
           ;

ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, il_reportconfigid)

//----------------------------------------------------------------------------------------------------------------------------------
// Check to see if a row exists for 'D'efault syntax. If it does exist, get the blob ID and set the original syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.SetFilter("svdrprttpe = 'D'")
ll_rows = ids_savedreport.Filter()
ll_rows = ids_savedreport.RowCount()
IF ll_rows > 0 THEN
	ll_blobobjectid = ids_savedreport.GetItemNumber(1, 'svdrprtblbobjctid')
	
	If Not IsNull(ll_blobobjectid) and ll_blobobjectid > 0 Then
		iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobobjectid)
		is_original_syntax = String(iblob_currentstate)

		// Make sure we converted it correctly - RAP 11/4/08
		ll_pos = Pos( is_original_syntax, "release" )
		IF ll_pos = 0 THEN
			is_original_syntax = string(iblob_currentstate, EncodingANSI!)
		END IF
		
		dw_report.Create(is_original_syntax)
		dw_report.SetTransObject(SQLCA)
	END IF
END IF

//----------------------------------------------------------------------------------------------------------------------------------
// Filter for last 'S'aved syntax.
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.SetFilter("svdrprttpe = 'S'")
ll_rows = ids_savedreport.Filter()
ll_rows = ids_savedreport.RowCount()

//----------------------------------------------------------------------------------------------------------------------------------
// Check to see if a row exists. If it does exist, get the blob ID and recreate the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_rows > 0 Then
	ll_blobobjectid = ids_savedreport.GetItemNumber(1, 'svdrprtblbobjctid')
	
	If Not IsNull(ll_blobobjectid) and ll_blobobjectid > 0 Then
		
		iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobobjectid)
		
		ls_syntax = String(iblob_currentstate)
		
		// Make sure we converted it correctly - RAP 11/4/08
		ll_pos = Pos( ls_syntax, "release" )
		IF ll_pos = 0 THEN
			ls_syntax = string(iblob_currentstate, EncodingANSI!)
		END IF
		
		If dw_report.Create(ls_syntax, l_sMsg) <> 1 THEN
			dw_report.Create(is_original_syntax)
		Else
			dw_report.SetTransObject(SQLCA)
		End If
		
	End If
End If

Destroy ln_blob_manipulator

end event

type dw_report from u_search`dw_report within u_search_appealtracker
event ue_retrieve ( )
event ue_checktrans ( string a_ccasenumber )
event ue_selecttrigger pbm_dwnkey
event ue_refresh_services ( )
event type boolean ue_check_security ( )
integer width = 2190
integer height = 780
string dataobject = "d_search_appealtracker"
end type

event dw_report::ue_retrieve();//dw_report.Retrieve(gn_globals.is_login, 'N')
string ls_null
long ll_return

SetNull(ls_null)
ll_return = dw_report.Retrieve(ls_null, ls_null)


end event

event dw_report::ue_checktrans(string a_ccasenumber);///****************************************************************************************
//
//	Event:	ue_checktrans
//	Purpose:	Check the transfer status of the case
//	
//	Revisions:
//	Date     Developer     Description
//	======== ============= ==============================================================
//	9/25/2001 K. Claver    Created
//****************************************************************************************/
//Integer l_nTransCount
//String l_cCaseStatus, l_cCurrentCSR, l_cUpdatedBy, l_cTransferFrom
//
////Check if there is a transfer.  Case could have been closed
////  by someone else.
//SELECT Count( * )
//INTO :l_nTransCount
//FROM cusfocus.case_transfer
//WHERE cusfocus.case_transfer.case_number = :a_cCaseNumber AND 
//		cusfocus.case_transfer.case_transfer_type = 'O'
//USING SQLCA;
//
//IF l_nTransCount = 0 THEN
//	//Check if has been re-opened or is still open and the current user 
//	//  is the rep(owner).
//	SELECT cusfocus.case_log.case_status_id, 
//			 cusfocus.case_log.case_log_case_rep, 
//			 cusfocus.case_log.updated_by
//	INTO :l_cCaseStatus,
//		  :l_cCurrentCSR,
//		  :l_cUpdatedBy
//	FROM cusfocus.case_log
//	WHERE cusfocus.case_log.case_number = :a_cCaseNumber
//	USING SQLCA;
//ELSE	
//	//Check to see if the case has already been viewed or is still owned by
//	//  the current user.			
//	SELECT cusfocus.case_transfer.case_transfer_to,
//			 cusfocus.case_transfer.case_transfer_from
//	INTO :l_cCurrentCSR,
//		  :l_cTransferFrom
//	FROM cusfocus.case_transfer
//	WHERE cusfocus.case_transfer.case_number = :a_cCaseNumber AND 
//			cusfocus.case_transfer.case_transfer_type = 'O'
//	USING SQLCA;
//END IF
//
////Display the appropriate message if the current user 
////  is no longer the owner of the case
//IF l_cCaseStatus = "C" THEN
//	MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been closed by "+l_cUpdatedBy+".", &
//					StopSign!, Ok! )
//ELSEIF l_cCaseStatus = "V" THEN
//	MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been voided by "+l_cUpdatedBy+".", &
//					StopSign!, Ok! )
//ELSEIF ( l_nTransCount = 0 ) AND ( NOT IsNull( l_cCurrentCSR ) ) AND &
//		 ( Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) THEN
//	MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been reopened by "+l_cCurrentCSR+".", &
//					StopSign!, Ok! )	 
//ELSEIF Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN			
//	MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been transferred to "+l_cCurrentCSR+" by "+l_cTransferFrom+".", &
//					StopSign!, Ok! )
//END IF			
end event

event dw_report::ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	9/25/2001 K. Claver    Created
	3/4/2002  K. Claver    Modified to use the new version of the case search event
****************************************************************************************/

W_CREATE_MAINTAIN_CASE	l_wCaseWindow
Long			l_nRow
String      l_cCaseNumber
Integer		li_return

// if the user double-clicked on a row, process it.
IF ( key = KeyEnter! ) AND ( THIS.GetRow() > 0 ) THEN
	
	// Get the selected case number
	l_nRow = GetRow( )
	l_cCaseNumber = THIS.Object.casenumber[ l_nRow ]
	
	IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
		//Check the transfer status of the case
		THIS.Event Trigger ue_CheckTrans( l_cCaseNumber )
		IF NOT THIS.Event ue_check_security() THEN
			messagebox (gs_AppName,'You do not have the necessary permissions to edit this case.')
			RETURN
		END IF
		
		// Open w_create_maintain_case
		FWCA.MGR.fu_OpenWindow( w_create_maintain_case, -1 )
		l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet( )
		
		IF IsValid( l_wCaseWindow ) THEN
			 
			// Make sure the window is on the Search tab
			IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
				li_return = l_wCaseWindow.dw_folder.fu_SelectTab( 1 )
			END IF
			
			IF li_return = -1 THEN
				RETURN -1
			ELSE
				// call ue_casesearch to process the query after the window is fully initialized.
				l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber )
			END IF
			
		END IF
	END IF
	RETURN -1
END IF
end event

event dw_report::ue_refresh_services();in_datawindow_graphic_service_manager.of_init(dw_report)

in_datawindow_graphic_service_manager.of_destroy_service('n_rowfocus_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_column_sizing_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_show_fields')
in_datawindow_graphic_service_manager.of_destroy_service('n_group_by_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_datawindow_formatting_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_aggregation_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_sort_service')

in_datawindow_graphic_service_manager.of_add_service('n_rowfocus_service')
in_datawindow_graphic_service_manager.of_add_service('n_column_sizing_service')
in_datawindow_graphic_service_manager.of_add_service('n_show_fields')
in_datawindow_graphic_service_manager.of_add_service('n_group_by_service')
in_datawindow_graphic_service_manager.of_add_service('n_datawindow_formatting_service')
in_datawindow_graphic_service_manager.of_add_service('n_aggregation_service')
in_datawindow_graphic_service_manager.of_add_service('n_sort_service')

in_datawindow_graphic_service_manager.of_Create_services()

end event

event type boolean dw_report::ue_check_security();Long ll_level, ll_row, ll_confid
String ls_case_rep
String ls_case_number
Boolean lb_return

lb_return = False
ll_row = dw_report.GetRow()
ls_case_rep = dw_report.object.case_log_case_rep[ll_row]
ls_case_number = dw_report.object.casenumber[ll_row]
ll_confid = Parent.i_wParentWindow.i_nRepConfidLevel

Select confidentiality_level
Into :ll_level
From cusfocus.case_log
Where case_number = :ls_case_number
Using SQLCA;

IF (ll_Level <= ll_confid) OR &
	(ls_Case_Rep = OBJCA.WIN.fu_GetLogin(SQLCA)) THEN
		lb_return = TRUE		
END IF

RETURN lb_return
end event

event dw_report::constructor;call super::constructor;long	ll_reportconfigid

in_datawindow_graphic_service_manager = Create n_datawindow_graphic_service_manager

THIS.EVENT TRIGGER ue_refresh_services()

this.TriggerEvent('ue_retrieve')

Properties.of_init(il_reportconfigid)
end event

event dw_report::destructor;call super::destructor;//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null
string	ls_null, ls_syntax
blob		lb_syntax

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Ensure these variables are null
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_null)
SetNull(ls_null)

//----------------------------------------------------------------------------------------------------------------------------------
// 11/27/06 RAP - Do not save the filter with the datawindow syntax
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report.SetFilter("")
dw_report.Filter()

//----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the datastore then get the syntax for the datawindow & convert it into a blob object
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, il_reportconfigid)
lb_syntax = blob(dw_report.Describe("DataWindow.Syntax"))
 
//----------------------------------------------------------------------------------------------------------------------------------
// If we dont' have a row, then insert a new row and set the values. Otherwise update the existing row and blob.
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_savedreport.RowCount() = 0 Then
	ll_new_row = ids_savedreport.InsertRow(0)
	
	ll_blobID = ln_blob_manipulator.of_insert_blob(lb_syntax, dw_report.dataobject)
	
	ids_savedreport.SetItem(ll_new_row, 'svdrprtfldrid', ls_null)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtblbobjctid', ll_blobID)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrprtcnfgid', il_reportconfigid)
	ids_savedreport.SetItem(ll_new_row, 'svdrprttpe', 'S')
	ids_savedreport.SetItem(ll_new_row, 'svdrprtdstrbtnmthd', ls_null)	
	ids_savedreport.SetItem(ll_new_row, 'svdrprtuserid', gn_globals.il_userid)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnusrID', ll_null)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnlvl', 1)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
Else
	ll_blobID = ids_savedreport.getitemnumber(1, 'svdrprtblbobjctid')
	ln_blob_manipulator.of_update_blob(lb_syntax, ll_blobID, FALSE)
	
	ids_savedreport.SetItem(1, 'svdrprtblbobjctid', ll_blobID)
	ids_savedreport.SetItem(1, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
	ids_savedreport.SetItem(1, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
End If


//----------------------------------------------------------------------------------------------------------------------------------
// Save the changes to the database
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.Update()


//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy	ln_blob_manipulator
Destroy 	in_datawindow_graphic_service_manager
Destroy 	ids_savedreport
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;
If Not IsNull(il_conf_level) and currentrow > 0 Then
	tab_appeal_preview.tabpage_case_preview.dw_case_preview.Retrieve(this.GetItemString(currentrow, 'casenumber'), il_conf_level)
	tab_appeal_preview.tabpage_appeal_preview.dw_appeal_preview.Retrieve(GetItemNumber(currentrow, 'appealheaderid'))
End If

end event

event dw_report::doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/23/2000 K. Claver   Added code to retrieve the case when double click on a row
//  3/4/2002   K. Claver   Modified to use the new version of the case search event
//***********************************************************************************************  
w_create_maintain_case l_wCaseWindow
String l_cCaseNumber
Integer li_return

IF THIS.RowCount( ) > 0 THEN
	IF row > 0 THEN
		l_cCaseNumber = THIS.GetItemString( row, "casenumber" )
		
		IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
			//Check the transfer status
			THIS.Event Trigger ue_CheckTrans( l_cCaseNumber )
			IF NOT THIS.Event ue_check_security() THEN
				messagebox (gs_AppName,'You do not have the necessary permissions to edit this case.')
				RETURN
			END IF

			// Open w_create_maintain_case
			FWCA.MGR.fu_OpenWindow(w_create_maintain_case, -1)
			l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet()
			
			IF IsValid (l_wCaseWindow) THEN
				
				// Make sure the window is on the Search tab
				IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
					li_return = l_wCaseWindow.dw_folder.fu_SelectTab(1)
				END IF
				
				IF li_return = -1 THEN
					RETURN -1
				ELSE
					// call ue_casesearch to process the query after the window is fully initialized.
					l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber)
				END IF
				
			END IF						
		END IF
	END IF
END IF
end event

event dw_report::ue_dwnkey;call super::ue_dwnkey;THIS.Event Trigger ue_selecttrigger( key, keyflags )
end event

type uo_titlebar from u_search`uo_titlebar within u_search_appealtracker
string tag = "Appeal Tracker"
end type

event uo_titlebar::constructor;call super::constructor;This.of_delete_button('criteria')
This.of_delete_button('customize')
This.of_delete_button('retrieve')

end event

type st_separator from u_search`st_separator within u_search_appealtracker
end type

type st_slider from u_slider_control_horizontal within u_search_appealtracker
integer y = 888
integer height = 20
boolean bringtotop = true
long backcolor = 15780518
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   Moves the position of the pane control to the coordinated specified in 
//					in the instance variable ib_automove_up, and then repositions/resizes
//					all objects being controlled by the pane control.
//
// Created by: 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Turn the redraw off for reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(False)

//-----------------------------------------------------
// If the pane controlled has been previously doubleclicked,
// then reset the pane control to its previous position, else
// set the pane control to the position specified by
// ib_doubleclick_up.
// ib_doubleclick_up = True - Expand Up
// ib_doubleclick_up = False - Expand Down
//-----------------------------------------------------
If ib_click Then

	//-----------------------------------------------------
	// Set the Y coordinate for the pane control to the
	// previous position
	//-----------------------------------------------------
	This.Y = of_get_prev_ypos()
	ib_click = False
	
Else

	//-----------------------------------------------------
	// Store the current Y coordinate, and move the pane
	// control up or down based on the variable ib_doubleclick_up.
	// ib_doubleclick_up = True - Expand Up
	// ib_doubleclick_up = False - Expand Down
	//-----------------------------------------------------
	of_set_prev_ypos(This.Y)
	if ib_automove_up then
		This.Y = of_min_Y()
	Else
		This.Y = of_max_Y()
	End IF
	ib_click = True

End If

//-----------------------------------------------------
// Turn redraw back on for the reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(True)
 
end event

type tab_appeal_preview from uo_tab_appeal_preview within u_search_appealtracker
event ue_resize ( )
integer x = 9
integer y = 912
integer taborder = 21
boolean bringtotop = true
end type

event ue_resize();String ls_return

tabpage_case_preview.dw_case_preview.width = THIS.width - 40
tabpage_case_preview.dw_case_preview.height = tabpage_case_preview.height
tabpage_appeal_preview.dw_appeal_preview.width = THIS.width - 40
tabpage_appeal_preview.dw_appeal_preview.height = tabpage_appeal_preview.height

end event

event resize;call super::resize;THIS.POST EVENT ue_resize()
end event

