$PBExportHeader$u_search_contacthistory.sru
forward
global type u_search_contacthistory from u_search
end type
type st_slider from u_slider_control_horizontal within u_search_contacthistory
end type
type dw_report_detail from u_datawindow within u_search_contacthistory
end type
end forward

global type u_search_contacthistory from u_search
integer width = 3611
integer height = 2492
event ue_post_constructor ( )
event type string ue_template_restore ( )
event ue_template_save ( )
st_slider st_slider
dw_report_detail dw_report_detail
end type
global u_search_contacthistory u_search_contacthistory

type variables
n_column_sizing_service in_columnsizingservice_detail

long il_conf_level
long	il_row

BOOLEAN						i_bViewNotes

STRING						i_cKeyValue

w_create_maintain_case	i_wParentWindow

string						is_original_syntax
string						is_results_syntax
string						is_new_criteria_syntax

w_category_popup			iw_category_popup

string	 					is_categoryID
boolean						ib_show_criteria
n_date_manipulator 		in_date_manipulator

boolean						ib_first_open
n_blob_manipulator		in_blob_manipulator
//datastore					ids_syntax

string						is_dynamic_columns[]
boolean						ib_dynamic_columns = FALSE
string						is_ch_casetype
//string						is_retrieved_sourcetype

datastore	ids_savedreport

blob	iblob_syntax
string	is_syntax
long		il_reportconfigid
Boolean 	ib_enter_key = FALSE
end variables

forward prototypes
public subroutine of_set_conf_level (long al_conf_level)
public subroutine of_post_retrieve_process (long al_return)
end prototypes

event ue_post_constructor();long l_sliderpos
st_slider.of_add_upper_object(dw_report)
st_slider.of_add_lower_object(dw_report_detail)
st_slider.backcolor = gn_globals.in_theme.of_get_barcolor()


n_registry ln_registry
l_sliderpos  			= 						long(	ln_registry.of_get_registry_key('users\' +  gn_globals.is_username + '\' + This.ClassName() + '\slidery'))

If l_sliderpos > 0 And Not IsNull(l_sliderpos) Then
	//st_slider.y = Min(Max(l_sliderpos, st_separator.Y + st_separator.Height + 100), Height - 100)
End If

uo_titlebar.of_delete_button('Customize...')
uo_titlebar.of_add_button('Restore Original View', 'restore' )

// 11/27/06 RAP - With proper security, users can save report templates
IF gn_globals.il_view_confidentiality_level > 2 THEN
	uo_titlebar.of_add_button('Save View As Template', 'save template' )
	uo_titlebar.of_add_button('Restore Template View', 'restore template' )
END IF

uo_titlebar.of_add_button('Show Properties', 'show properties' )
uo_titlebar.of_add_button('Hide Properties', 'hide properties' )
uo_titlebar.of_hide_button('Hide Properties', TRUE )

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

public subroutine of_set_conf_level (long al_conf_level);il_conf_level = al_conf_level
end subroutine

public subroutine of_post_retrieve_process (long al_return);string l_cCaseMasterNum

IF dw_report.RowCount () > 0 THEN
	IF (i_wParentWindow.i_nRepConfidLevel >= i_wParentWindow.i_nCaseConfidLevel) OR (i_wParentWindow.i_cCurrCaseRep = i_wParentWindow.i_cUserID) THEN
		i_wParentWindow.dw_folder.fu_EnableTab(5)
	ELSE
		i_wParentWindow.dw_folder.fu_DisableTab(5)
	END IF
ELSE
	i_wParentWindow.dw_folder.fu_DisableTab(5)
END IF

If al_return = 0 Then
	i_wParentWindow.i_cSelectedCase = ''
	
//	dw_report.fu_retrieve (c_IgnoreChanges, dw_case_history.c_NoRefreshChildren)
	
	i_wParentWindow.dw_folder.fu_DisableTab (5)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Disable the case transfer option
	//-----------------------------------------------------------------------------------------------------------------------------------
	m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled			= FALSE
	m_create_maintain_case.m_file.m_printcasedetailreport.Enabled			= FALSE
	m_create_maintain_case.m_file.m_transfercase.Enabled = FALSE
	
	m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
	m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
Else	
	l_cCaseMasterNum = dw_report.Object.case_log_master_case_number[ 1 ]
	
	IF (i_wParentWindow.i_nRepConfidLevel >= i_wParentWindow.i_nCaseConfidLevel) OR (i_wParentWindow.i_cCurrCaseRep = i_wParentWindow.i_cUserID) THEN
		i_wParentWindow.dw_folder.fu_EnableTab (5)
	END IF
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Enable/Disable depending on status
	//-----------------------------------------------------------------------------------------------------------------------------------
	CHOOSE CASE Upper( dw_report.GetItemString( 1, 'case_stat_desc' ) )
		CASE 'OPEN'
			m_create_maintain_case.m_file.m_transfercase.Enabled = TRUE
			
			IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
				m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
				m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
			ELSE
				m_create_maintain_case.m_edit.m_linkcase.Enabled = i_wParentWindow.i_bLinked
				m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
			END IF
		CASE 'CLOSED'
			m_create_maintain_case.m_file.m_transfercase.Enabled = FALSE
			
			IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
				m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
				m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
			ELSE
				m_create_maintain_case.m_edit.m_linkcase.Enabled = i_wParentWindow.i_bLinked
				m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
			END IF
		CASE ELSE
			IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
				m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
			ELSE
				m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
			END IF
			
			m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
	END CHOOSE
End If

end subroutine

on u_search_contacthistory.create
int iCurrent
call super::create
this.st_slider=create st_slider
this.dw_report_detail=create dw_report_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_slider
this.Control[iCurrent+2]=this.dw_report_detail
end on

on u_search_contacthistory.destroy
call super::destroy
destroy(this.st_slider)
destroy(this.dw_report_detail)
end on

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
dw_report_detail.Visible  	= Not IsValid(iu_overlaying_report)


If Not IsValid(iu_overlaying_report) Then
	st_slider.Width = Width
	dw_report.Height = st_slider.Y - dw_report.Y
	dw_report_detail.Width = dw_report.Width
	dw_report_detail.Height = Height - dw_report_detail.Y - 20
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
			dw_report_detail.Reset()
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
					dw_report.TriggerEvent('ue_refresh_services')
					dw_report.TriggerEvent('pcd_retrieve')
			Case 'save template'
					IF ib_dynamic_columns = FALSE THEN // Don't allow a save if dynamic columns have been added
						THIS.EVENT ue_template_save()
					END IF
			Case 'restore template'
					ls_syntax = THIS.EVENT ue_template_restore()
					dw_report.Create(ls_syntax)
					dw_report.TriggerEvent('ue_refresh_services')
					dw_report.TriggerEvent('pcd_retrieve')
			Case 'show properties', 'hide properties'
					ib_dynamic_columns = TRUE
					PARENT.DYNAMIC of_show_hide_criteria()
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
   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Contact History'   
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

event destructor;call super::destructor;n_registry ln_registry

ln_registry.of_set_registry_key('users\' +  gn_globals.is_username + '\' + This.ClassName() + '\slidery', string(st_slider.y))


end event

type dw_report from u_search`dw_report within u_search_contacthistory
event ue_retrieve ( )
event pcd_retrieve ( )
event ue_selecttrigger pbm_dwnkey
event ue_refresh_services ( )
integer width = 2190
integer height = 832
string dataobject = "d_search_contact_history"
end type

event dw_report::ue_retrieve();LONG l_nRtn

SetPointer( Hourglass! )

//l_nRtn = THIS.Retrieve( gn_globals.is_login, DateTime(gn_globals.in_date_manipulator.of_now()) )

IF l_nRtn < 0 THEN
//   Error.i_FWError = SQLCA.SQLErrText
ELSEIF l_nRtn = 0 THEN
//	st_notes.Visible = FALSE
END IF

SetPointer( Arrow! )
end event

event dw_report::pcd_retrieve();/**************************************************************************************

	Event:	pcd_retrieve
	Purpose:	To retieve case history, enable/disbale tabs and to select the current
				case if there is one.
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	09/29/00 M. Caruso     Created, based on code from dw_case_history on the old
								  demographics screen.
	11/6/2000 K. Claver    Added code to disable the transfer case menu option if no rows
								  are retrieved.
	6/13/2001 K. Claver    Added code to enable/disable the case linking edit menu items.
***************************************************************************************/

LONG		l_nReturn, l_nSelectedRows[], l_nRowCount
STRING	l_cSourceType, l_cCaseMasterNum, l_cSubject
String	ls_casetype, ls_casenumber, ls_fromdate, ls_todate, ls_casestatus
string 	ls_category_id, ls_caserep	
string	ls_dynamic1, ls_dynamic2, ls_dynamic3, ls_dynamic4, ls_dynamic5, ls_dynamic6
//

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite	11.12.2005	Removed the old retrieve call and replaced it with the new retrieve
//								with all the new criteria
//-----------------------------------------------------------------------------------------------------------------------------------
/*
l_nReturn = THIS.Retrieve (i_wparentwindow.i_cCurrentCaseSubject, &
									i_wparentwindow.i_cSourceType)
*/

String ls_null 
SetNull(ls_null)

//l_nReturn = THIS.Retrieve(i_wParentWindow.i_cSourceType, i_wParentWindow.i_cCurrentCaseSubject, ls_null, ls_null, ls_null, ls_null, ls_null, ls_null, ls_null, ls_null, ls_null, ls_null, ls_null, ls_null, i_wParentWindow.is_contacthistory_casetype, 'N' )
dw_report_detail.Reset()
l_cSourceType = i_wParentWindow.i_cSourceType
l_cSubject = i_wParentWindow.i_cCurrentCaseSubject
ls_casetype = i_wParentWindow.is_contacthistory_casetype
l_nreturn = THIS.Retrieve(l_cSourceType, l_cSubject, ls_category_id, ls_fromdate, ls_todate, ls_casenumber, ls_caserep, ls_casestatus, ls_dynamic1, ls_dynamic2, ls_dynamic3, ls_dynamic4, ls_dynamic5, ls_dynamic6, ls_casetype, 'N' )

CHOOSE CASE l_nReturn
	CASE IS < 0
		//Error.i_FWError = c_Fatal
		
		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
		m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE

	CASE ELSE
		of_post_retrieve_process(l_nReturn)
		
END CHOOSE

end event

event dw_report::ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	09/29/00 M. Caruso     Created, based on code from dw_case_history on the old
								  demographics screen.
	01/12/01 M. Caruso     Added call to fu_opencase ().
	01/13/01 M. Caruso     Only call fu_opencase () if the selected case has changed.
	01/14/01 M. Caruso     Reversed last changed.  This condition taken of in fu_OpenCase ().
****************************************************************************************/

LONG		l_nRow
INTEGER	l_nLevel
STRING	l_cCaseRep

l_nRow = GetRow()

IF (key = KeyEnter!) AND (l_nRow > 0) THEN
	
	// switch to the case tab if the user has permission to view the case.
	l_nLevel = GetItemNumber (l_nRow, "confidentiality_level")
	l_cCaseRep = GetItemString (l_nRow, "case_log_case_log_case_rep")
	IF (l_nLevel <= i_wParentWindow.i_nRepConfidLevel) OR &
		(l_cCaseRep = OBJCA.WIN.fu_GetLogin(SQLCA)) THEN
		i_wparentwindow.dw_folder.fu_SelectTab (5)
		i_wParentWindow.i_uoCaseDetails.TRIGGER fu_OpenCase ()
	ELSE
		messagebox (gs_AppName,'You do not have the necessary permissions to edit this case.')
	END IF
	
	ib_enter_key = TRUE
	// abort enter key processing beyond this point
	RETURN 1
	
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

event dw_report::constructor;call super::constructor;long	ll_reportconfigid

in_datawindow_graphic_service_manager = Create n_datawindow_graphic_service_manager

THIS.EVENT TRIGGER ue_refresh_services()

this.TriggerEvent('ue_retrieve')

  SELECT cusfocus.reportconfig.rprtcnfgid  
    INTO :ll_reportconfigid  
    FROM cusfocus.reportconfig  
   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Contact History'   
           ;



Properties.of_init(ll_reportconfigid)


end event

event dw_report::destructor;call super::destructor;//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null
string	ls_null, ls_syntax
blob		lb_syntax

IF ib_dynamic_columns THEN RETURN // Don't save syntax if dynamic columns have been added
n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Ensure these variables are null
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_null)
SetNull(ls_null)

dw_report.SetFilter('')
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
	
	ll_blobID = ln_blob_manipulator.of_insert_blob(lb_syntax, is_dataobjectname)
	
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

event dw_report::rowfocuschanged;call super::rowfocuschanged;/****************************************************************************************

	Event:	pcd_pickedrow
	Purpose:	To find out what the user selected and to set the appropriate variables
				and tabs.
				
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	09/29/00 M. Caruso     Created, based on code from dw_case_history on the old
								  demographics screen.
	10/24/00 M. Caruso     Allow only Open cases can be transferred by enabling the case
								  transfer menu item if appropriate.
	11/22/2000 K. Claver   Added code to disallow case transfer if the current user isn't
								  the owner of the case.
	11/28/00 M. Caruso     Set i_bViewNotes to control viewing of notes in preview pane.
	6/13/2001 K. Claver    Added code to enable/disable the case linking edit menu items.
***************************************************************************************/

STRING	l_cTakenBy, l_cCaseMasterNum

long ll_row

il_row = currentrow

If Not IsNull(Parent.i_wParentWindow.i_nCaseConfidLevel) and currentrow > 0 Then

	Parent.i_wParentWindow.i_bCaseDetailUpdate = TRUE
	Parent.i_wParentWindow.i_cSelectedCase = GetItemString (currentrow, 'case_number')
	Parent.i_wParentWindow.i_cCaseType = GetItemString (currentrow, 'case_type')
	Parent.i_wParentWindow.i_nCaseConfidLevel = GetItemNumber (currentrow, "confidentiality_level")
	Parent.i_wParentWindow.i_cCurrCaseRep = GetItemString ( currentrow, "case_log_case_log_case_rep" )
	l_cTakenBy = GetItemString (currentrow, "case_log_case_log_taken_by")
	
	IF (Parent.i_wParentWindow.i_nCaseConfidLevel <= Parent.i_wParentWindow.i_nRepConfidLevel) OR &
		(Parent.i_wParentWindow.i_cCurrCaseRep = OBJCA.WIN.fu_GetLogin(SQLCA)) THEN
		
		// the user has access to the selected case, so enable the appropriate items
		Parent.i_wParentWindow.dw_folder.fu_EnableTab (5)
		i_bViewNotes = TRUE
		
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled = TRUE
		m_create_maintain_case.m_file.m_printcasedetailreport.Enabled = TRUE
		
	ELSE
		
		// the user does not have access to the selected case, so disable the appropriate items
		Parent.i_wParentWIndow.dw_folder.fu_DisableTab(5)
		i_bViewNotes = FALSE
		
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled = FALSE
		m_create_maintain_case.m_file.m_printcasedetailreport.Enabled = FALSE
		
	END IF
	
	l_cCaseMasterNum = THIS.Object.case_log_master_case_number[ currentrow ]
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite 5.17.2005	Added statement to set the Master Case Numbers to null if they are not linked.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If lower(l_cCaseMasterNum) = 'not linked' Then SetNull(l_cCaseMasterNum)
	
	CHOOSE CASE Upper( GetItemString (currentrow, 'case_stat_desc') )
		CASE 'OPEN'
			//If the current user isn't the case rep, don't allow to transfer
			IF Upper( Parent.i_wParentWindow.i_cCurrCaseRep ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) AND &
				Upper( l_cTakenBy ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN
				m_create_maintain_case.m_file.m_transfercase.Enabled = FALSE
			ELSE
				m_create_maintain_case.m_file.m_transfercase.Enabled = TRUE
			END IF
			
			IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
				m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
				m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
			ELSE
				m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
				m_create_maintain_case.m_edit.m_linkcase.Enabled = i_wParentWindow.i_bLinked
			END IF
			
		CASE 'CLOSED'
			m_create_maintain_case.m_file.m_transfercase.Enabled = FALSE
			
			IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
				m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
				m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
			ELSE
				m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
				m_create_maintain_case.m_edit.m_linkcase.Enabled = i_wParentWindow.i_bLinked
			END IF
			
		CASE ELSE
			m_create_maintain_case.m_file.m_transfercase.Enabled = FALSE
			
			m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
			
			IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
				m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
			ELSE
				m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
			END IF
			
	END CHOOSE

	ll_row = dw_report_detail.Retrieve(string(this.GetItemNumber(currentrow, 'sort_case_number')), il_conf_level)
End If

//INTEGER	l_nCaseConfidLevel
//LONG		l_nRtn
//STRING	l_cCaseNumber
//
//IF (dw_report.RowCount () > 0) AND (i_bViewNotes) THEN
//	
//	// the user has access to see associated case notes
//	l_cCaseNumber = dw_report.GetItemString (currentrow, "case_number")
//	l_nCaseConfidLevel = dw_report.GetItemNumber (dw_report.GetRow (), 'confidentiality_level')
//	l_nRtn = retrieve (l_cCaseNumber, Parent.i_wParentWindow.i_nRepConfidLevel)
//	
//ELSE
//	
//	// the user does not have access to the case notes
////	fu_Reset (c_IgnoreChanges)
//	l_nRtn = -1
//	
//END IF

//CHOOSE CASE l_nRtn
//	CASE -1
//		// display no access message
//		st_noaccess.Visible = TRUE
//		st_nonotes.Visible = FALSE
//		
//	CASE 0
//		// display no notes message
//		st_nonotes.Visible = TRUE
//		st_noaccess.Visible = FALSE
//
//	CASE ELSE
//		// make sure messages are hidden
//		st_noaccess.Visible = FALSE
//		st_nonotes.Visible = FALSE
//		THIS.Function Post fu_Modify ()
//		
//END CHOOSE
end event

event dw_report::ue_dwnkey;//this.triggerevent('ue_selecttrigger')

THIS.Event Trigger ue_selecttrigger( key, keyflags )
end event

event dw_report::doubleclicked;call super::doubleclicked;/*****************************************************************************************
*	Event:	doubleclicked
*	Purpose: Switch to the case tab based on the Type of case in the selected row.
*	
*	Revisions:
*	Date     Developer     Description
*	======== ============= ================================================================
*	09/29/00 M. Caruso     Created, based on code from dw_case_history on the old
*								  demographics screen.
*  01/12/01 M. Caruso     Added call to fu_opencase ().
*  01/13/01 M. Caruso     Only call fu_opencase () if the selected case has changed.
*  01/14/01 M. Caruso     Reversed last changed.  This condition taken of in fu_OpenCase ().
*****************************************************************************************/

STRING	l_sColumnName, l_cviewed
STRING	l_sCaseType, l_cCaseRep
INTEGER	l_nLevel
LONG		l_nCaseNum, l_nReminderNum

IF row > 0 THEN
	IF (dwo.Type = "column") OR (dwo.Type = "compute") THEN
		
		l_nLevel = GetItemNumber (row, "confidentiality_level")
		l_cCaseRep = GetItemString (row, "case_log_case_log_case_rep")
		IF (l_nLevel <= Parent.i_wParentWindow.i_nRepConfidLevel) OR &
			(l_cCaseRep = OBJCA.WIN.fu_GetLogin(SQLCA)) THEN
		
			// if a row was selected, switch to the case tab.
			l_sColumnName = dwo.Name
			l_sCaseType = This.GetItemString (row, "case_type_desc")
			Parent.i_wParentWindow.dw_folder.fu_SelectTab (5)
			Parent.i_wParentWindow.i_uoCaseDetails.POST fu_OpenCase ()
			
		ELSE
			messagebox (gs_AppName,'You do not have the necessary permissions to edit this case.')
		END IF

	END IF
END IF
end event

event dw_report::rowfocuschanging;call super::rowfocuschanging;IF ib_enter_key THEN
	ib_enter_key = FALSE
	RETURN 1
ELSE
	RETURN 0
END IF

end event

event dw_report::rbuttondown;n_menu_dynamic ln_menu_dynamic

If AutomaticallyPresentRightClickMenu Then
	ln_menu_dynamic = Create n_menu_dynamic
	ln_menu_dynamic.of_set_text('Report Options')
End If

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('rbuttondown', xpos, ypos, row, dwo, ln_menu_dynamic)
End If
IF m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE THEN
	ln_menu_dynamic.of_add_item('-','','')
	ln_menu_dynamic.of_add_item('Remove Link','remove link','', THIS)
END IF
IF m_create_maintain_case.m_edit.m_linkcase.Enabled = TRUE THEN
	ln_menu_dynamic.of_add_item('-','','')
	ln_menu_dynamic.of_add_item('Link Case','link case','', THIS)
END IF

If AutomaticallyPresentRightClickMenu Then
	This.Event ue_rbuttondown(xpos, ypos, row, dwo, ln_menu_dynamic)
	This.of_showmenu(ln_menu_dynamic)
End If
end event

event dw_report::ue_notify;call super::ue_notify;Choose Case Lower(Trim(as_message))
	Case 'link case'
		i_wParentWindow.fw_linkcase()
	Case 'remove link'
		i_wParentWindow.fw_removelink()
END CHOOSE
end event

type uo_titlebar from u_search`uo_titlebar within u_search_contacthistory
string tag = "Appeal Tracker"
end type

event uo_titlebar::constructor;call super::constructor;This.of_delete_button('criteria')
This.of_delete_button('customize')
This.of_delete_button('retrieve')

end event

type st_separator from u_search`st_separator within u_search_contacthistory
end type

type st_slider from u_slider_control_horizontal within u_search_contacthistory
integer y = 944
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

type dw_report_detail from u_datawindow within u_search_contacthistory
integer y = 964
integer width = 2194
integer height = 544
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_case_notes_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;Datawindow ldw_this
ldw_this = This
in_columnsizingservice_detail = Create n_column_sizing_service
in_columnsizingservice_detail.of_init(ldw_this)


end event

event destructor;call super::destructor;Destroy in_columnsizingservice_detail
end event

event doubleclicked;call super::doubleclicked;//Pass the event to the Column Resizing Service
If IsValid(in_columnsizingservice_detail) Then
	in_columnsizingservice_detail.of_doubleclicked(dwo.Name, This.PointerX())
End If

end event

event retrievestart;call super::retrievestart;This.SetTransObject(Parent.of_getTransactionObject())
end event

event ue_lbuttondown;call super::ue_lbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_lbuttondown
// Overrides:  No
// Overview:   Redirect this event to the group by service and the column sizing service
// Created by: Blake Doerr
// History:    12/16/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_columnsizingservice_detail) Then
	in_columnsizingservice_detail.of_lbuttondown(This.PointerX())
End If
end event

event ue_lbuttonup;call super::ue_lbuttonup;If IsValid(in_columnsizingservice_detail) Then
	in_columnsizingservice_detail.of_lbuttonup(This.PointerX(), This.PointerY())
End If
end event

event ue_pbmmousemove;call super::ue_pbmmousemove;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_pbmmousemove
// Overrides:  No
// Overview:   This will redirect the event to the groupby service and the column sizing service.  It will also begin a drag if the
//						row is greater than zero
// Created by: Blake Doerr
// History:    03/05/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_columnsizingservice_detail) Then
	in_columnsizingservice_detail.of_mousemove(flags, xpos, ypos)
End If
end event

