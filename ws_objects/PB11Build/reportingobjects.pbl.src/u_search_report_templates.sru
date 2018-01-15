$PBExportHeader$u_search_report_templates.sru
forward
global type u_search_report_templates from u_search
end type
type st_slider from u_slider_control_horizontal within u_search_report_templates
end type
type dw_report_detail from u_datawindow within u_search_report_templates
end type
type cb_apply from commandbutton within u_search_report_templates
end type
type cbx_default from checkbox within u_search_report_templates
end type
type cbx_last_saved from checkbox within u_search_report_templates
end type
end forward

global type u_search_report_templates from u_search
integer width = 3611
integer height = 2492
event ue_post_constructor ( )
event type string ue_template_restore ( )
event ue_template_save ( )
st_slider st_slider
dw_report_detail dw_report_detail
cb_apply cb_apply
cbx_default cbx_default
cbx_last_saved cbx_last_saved
end type
global u_search_report_templates u_search_report_templates

type variables
n_column_sizing_service in_columnsizingservice_detail

long il_conf_level
long	il_reportconfigid

datastore	ids_savedreport

blob	iblob_syntax
string	is_syntax, is_original_syntax
end variables

forward prototypes
public subroutine of_set_conf_level (long al_conf_level)
public function integer of_apply ()
end prototypes

event ue_post_constructor();uo_titlebar.of_delete_button('Customize...')
uo_titlebar.of_add_button('Restore Original View', 'restore' )

long l_sliderpos
st_slider.of_add_upper_object(dw_report)
st_slider.of_add_lower_object(dw_report_detail)
st_slider.backcolor = gn_globals.in_theme.of_get_barcolor()


n_registry ln_registry
l_sliderpos  			= 						long(	ln_registry.of_get_registry_key('users\' +  gn_globals.is_username + '\' + This.ClassName() + '\slidery'))

If l_sliderpos > 0 And Not IsNull(l_sliderpos) Then
	//st_slider.y = Min(Max(l_sliderpos, st_separator.Y + st_separator.Height + 100), Height - 100)
End If

// 11/27/06 RAP - With proper security, users can save report templates
//IF gn_globals.il_view_confidentiality_level > 2 THEN
//	uo_titlebar.of_add_button('Save View As Template', 'save template' )
//	uo_titlebar.of_add_button('Restore Template View', 'restore template' )
//END IF

THIS.EVENT POST ue_retrieve()

end event

event type string ue_template_restore();//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null
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

public function integer of_apply ();// This function will replace the template in dw_report 
// with the selected template in dw_report_detail

// Prompt first
// update description
// overwrite the blob
// Any other changes need to be made?
//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_user_row, ll_template_row, ll_blobID, ll_null, ll_user_id, ll_report_config_id, ll_return, ll_new_row
string	ls_null, ls_syntax, ls_user_default_description, ls_user_saved_description, ls_template_description, ls_messagebox, ls_dataobject
blob		lblb_syntax
Datastore lds_saved_reports
Boolean lb_error = FALSE

lds_saved_reports = Create DataStore
lds_saved_reports.DataObject = 'd_data_savedreport_user_reportconfig'
lds_saved_reports.SetTransObject(SQLCA)

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Ensure these variables are null
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_null)
SetNull(ls_null)

ll_user_row = dw_report.GetRow()
ll_template_row = dw_report_detail.GetRow()
ll_blobID = dw_report_detail.object.savedreport_svdrprtblbobjctid[ll_template_row]

IF NOT cbx_default.checked AND NOT cbx_last_saved.checked THEN lb_error = TRUE
IF IsNull(ll_user_row) OR IsNull(ll_template_row) OR IsNull(ll_blobID) THEN lb_error = TRUE
IF Not lb_error THEN
	IF ll_user_row = 0 OR ll_template_row = 0 OR ll_blobID = 0 THEN lb_error = TRUE
	IF Not lb_error THEN
		//----------------------------------------------------------------------------------------------------------------------------------
		// Get info from selected rows in the datwindows
		//----------------------------------------------------------------------------------------------------------------------------------
		ll_user_id = dw_report.object.id[ll_user_row]
		ll_report_config_id = dw_report.object.rprtcnfgid[ll_user_row]
		ls_user_saved_description = dw_report.object.savedreport_svdrprtdscrptn[ll_user_row]
		ls_user_default_description = dw_report.object.savedreport_svdrprtdscrptn_1[ll_user_row]
		ls_template_description = dw_report_detail.object.savedreport_svdrprtdscrptn[ll_template_row]
		ls_dataobject = dw_report_detail.object.reportconfig_rprtcnfgdtaobjct[ll_template_row]

		//----------------------------------------------------------------------------------------------------------------------------------
		// Prompt the user
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_messagebox = ''
		IF ll_blobID = -1 THEN // Delete template
			IF cbx_default.checked THEN
				ls_messagebox = 'Do you want to delete "' + ls_user_default_description + '"'
			END IF
			IF cbx_last_saved.checked THEN
				IF LEN(ls_messagebox) > 0 THEN
					ls_messagebox += ' and "' + ls_user_saved_description + '"'
				ELSE
					ls_messagebox = 'Do you want to delete "' + ls_user_saved_description + '"'
				END IF
			END IF
		ELSE // Replace or Insert
			IF cbx_default.checked THEN
				ls_messagebox = 'Do you want to replace ' + ls_user_default_description + '"'
			END IF
			IF cbx_last_saved.checked THEN
				IF LEN(ls_messagebox) > 0 THEN
					ls_messagebox += ' and "' + ls_user_saved_description + '"'
				ELSE
					ls_messagebox = 'Do you want to replace "' + ls_user_saved_description + '"'
				END IF
			END IF
			ls_messagebox += ' with "' + ls_template_description + '"'
		END IF
		ll_return = MessageBox('Report Template Change', ls_messagebox, Question!, YesNo!)
		IF ll_return = 1 THEN // The user wants to continue with the changes
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Deleting saved report and the associated blob
			//-----------------------------------------------------------------------------------------------------------------------------------
			IF ll_blobID = -1 THEN // Delete template
				//----------------------------------------------------------------------------------------------------------------------------------
				// Retrieve the datastore
				//-----------------------------------------------------------------------------------------------------------------------------------
				ll_rows = lds_saved_reports.Retrieve(ll_user_id, ll_report_config_id)
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Delete default report view
				//-----------------------------------------------------------------------------------------------------------------------------------
				IF cbx_default.checked THEN
					IF ls_user_default_description <> 'N/A' THEN
						lds_saved_reports.SetFilter("svdrprttpe = 'D' and svdrprtdscrptn = '" + ls_user_default_description + "'")
						lds_saved_reports.Filter()
						ll_rows = lds_saved_reports.RowCount()
						IF ll_rows > 0 THEN
							ll_blobID = lds_saved_reports.getitemnumber(1, 'svdrprtblbobjctid')
							ln_blob_manipulator.of_delete_blob(ll_blobID)
							lds_saved_reports.DeleteRow(1)
							//----------------------------------------------------------------------------------------------------------------------------------
							// Save the changes to the database
							//-----------------------------------------------------------------------------------------------------------------------------------
							ll_return = lds_saved_reports.Update()
						END IF
					END IF
				END IF
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Delete last saved report view
				//-----------------------------------------------------------------------------------------------------------------------------------
				IF cbx_last_saved.checked THEN
					IF ls_user_saved_description <> 'N/A' THEN
						lds_saved_reports.SetFilter("")
						lds_saved_reports.Filter()
						lds_saved_reports.SetFilter("svdrprttpe = 'S' and svdrprtdscrptn = '" + ls_user_saved_description + "'")
						lds_saved_reports.Filter()
						ll_rows = lds_saved_reports.RowCount()
						IF ll_rows > 0 THEN
							ll_blobID = lds_saved_reports.getitemnumber(1, 'svdrprtblbobjctid')
							ln_blob_manipulator.of_delete_blob(ll_blobID)
							lds_saved_reports.DeleteRow(1)
							//----------------------------------------------------------------------------------------------------------------------------------
							// Save the changes to the database
							//-----------------------------------------------------------------------------------------------------------------------------------
							ll_return = lds_saved_reports.Update()
						END IF
					END IF
				END IF
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Updating or Inserting
			//-----------------------------------------------------------------------------------------------------------------------------------
			ELSE
				//----------------------------------------------------------------------------------------------------------------------------------
				// Get the blob for the template
				//-----------------------------------------------------------------------------------------------------------------------------------
				lblb_syntax = ln_blob_manipulator.of_retrieve_blob(ll_blobID)
				
				//----------------------------------------------------------------------------------------------------------------------------------
				// Retrieve the datastore
				//-----------------------------------------------------------------------------------------------------------------------------------
				ll_rows = lds_saved_reports.Retrieve(ll_user_id, ll_report_config_id)
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Process default report view
				//-----------------------------------------------------------------------------------------------------------------------------------
				IF cbx_default.checked THEN
					IF ls_user_default_description = 'N/A' THEN
						//----------------------------------------------------------------------------------------------------------------------------------
						// If we don't have a default row, insert a new row and set the values. Otherwise update the existing row and blob.
						//-----------------------------------------------------------------------------------------------------------------------------------
						ll_new_row = lds_saved_reports.InsertRow(0)
						
						ll_blobID = ln_blob_manipulator.of_insert_blob(lblb_syntax, ls_dataobject)
						
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtfldrid', ls_null)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtblbobjctid', ll_blobID)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtdscrptn', ls_template_description)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtrprtcnfgid', ll_report_config_id)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprttpe', 'D')
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtdstrbtnmthd', ls_null)	
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtuserid', ll_user_id)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtrvsnusrid', ll_null)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtrvsnlvl', 1)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
					Else
						lds_saved_reports.SetFilter("svdrprttpe = 'D' and svdrprtdscrptn = '" + ls_user_default_description + "'")
						lds_saved_reports.Filter()
						ll_rows = lds_saved_reports.RowCount()
						IF ll_rows > 0 THEN
							ll_blobID = lds_saved_reports.getitemnumber(1, 'svdrprtblbobjctid')
							ln_blob_manipulator.of_update_blob(lblb_syntax, ll_blobID, FALSE)
							
							lds_saved_reports.SetItem(1, 'svdrprtblbobjctid', ll_blobID)
							lds_saved_reports.SetItem(1, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
							lds_saved_reports.SetItem(1, 'svdrprtdscrptn', ls_template_description)
						END IF
					End If
					//----------------------------------------------------------------------------------------------------------------------------------
					// Save the changes to the database
					//-----------------------------------------------------------------------------------------------------------------------------------
					ll_return = lds_saved_reports.Update()
				END IF		// default checked
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Process last saved report view
				//-----------------------------------------------------------------------------------------------------------------------------------
				IF cbx_last_saved.checked THEN
					IF ls_user_saved_description = 'N/A' THEN
						//----------------------------------------------------------------------------------------------------------------------------------
						// If we don't have a last saved row, insert a new row and set the values. Otherwise update the existing row and blob.
						//-----------------------------------------------------------------------------------------------------------------------------------
						ll_new_row = lds_saved_reports.InsertRow(0)
						
						ll_blobID = ln_blob_manipulator.of_insert_blob(lblb_syntax, ls_dataobject)
						
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtfldrid', ls_null)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtblbobjctid', ll_blobID)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtdscrptn', ls_template_description)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtrprtcnfgid', ll_report_config_id)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprttpe', 'S')
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtdstrbtnmthd', ls_null)	
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtuserid', ll_user_id)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtrvsnusrID', ll_null)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtrvsnlvl', 1)
						lds_saved_reports.SetItem(ll_new_row, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
					Else
						lds_saved_reports.SetFilter("")
						lds_saved_reports.Filter()
						lds_saved_reports.SetFilter("svdrprttpe = 'S' and svdrprtdscrptn = '" + ls_user_saved_description + "'")
						lds_saved_reports.Filter()
						ll_rows = lds_saved_reports.RowCount()
						IF ll_rows > 0 THEN
							ll_blobID = lds_saved_reports.getitemnumber(1, 'svdrprtblbobjctid')
							ln_blob_manipulator.of_update_blob(lblb_syntax, ll_blobID, FALSE)
							
							lds_saved_reports.SetItem(1, 'svdrprtblbobjctid', ll_blobID)
							lds_saved_reports.SetItem(1, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
							lds_saved_reports.SetItem(1, 'svdrprtdscrptn', ls_template_description)
						END IF
					End If
					//----------------------------------------------------------------------------------------------------------------------------------
					// Save the changes to the database
					//-----------------------------------------------------------------------------------------------------------------------------------
					ll_return = lds_saved_reports.Update()
				END IF		// last saved checked
			END IF	// Deleting or updating
			dw_report.Event ue_retrieve() // To show changes in upper DW
			dw_report.ScrollToRow(ll_user_row) // Put them back where they were
		END IF	// User selected "Yes" to messagebox
	END IF
END IF

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy	ln_blob_manipulator
Destroy 	lds_saved_reports
return 0
end function

on u_search_report_templates.create
int iCurrent
call super::create
this.st_slider=create st_slider
this.dw_report_detail=create dw_report_detail
this.cb_apply=create cb_apply
this.cbx_default=create cbx_default
this.cbx_last_saved=create cbx_last_saved
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_slider
this.Control[iCurrent+2]=this.dw_report_detail
this.Control[iCurrent+3]=this.cb_apply
this.Control[iCurrent+4]=this.cbx_default
this.Control[iCurrent+5]=this.cbx_last_saved
end on

on u_search_report_templates.destroy
call super::destroy
destroy(this.st_slider)
destroy(this.dw_report_detail)
destroy(this.cb_apply)
destroy(this.cbx_default)
destroy(this.cbx_last_saved)
end on

event ue_retrieve;call super::ue_retrieve;long ll_row, ll_rows, ll_report_config_id

dw_report.SetTransObject(SQLCA)
ll_rows = dw_report.Retrieve()
ll_row = dw_report.GetRow()

If ll_row > 0 and ll_row <= dw_report.RowCount() Then 
	ll_report_config_id = dw_report.GetItemNumber(ll_row, 'rprtcnfgid')
End If

If Not isnull(il_conf_level) Then
	ll_row = dw_report_detail.Retrieve(ll_report_config_id)
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
dw_report_detail.Visible  	= Not IsValid(iu_overlaying_report)

If Not IsValid(iu_overlaying_report) Then
	st_slider.Width = Width
	dw_report.Height = st_slider.Y - dw_report.Y
	dw_report.Width = Width
	dw_report_detail.Height = Height - dw_report_detail.Y
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
					dw_report.EVENT TRIGGER ue_refresh_services()
					dw_report.TriggerEvent('ue_retrieve')
			Case 'save template'
					THIS.EVENT ue_template_save()
			Case 'restore template'
					ls_syntax = THIS.EVENT ue_template_restore()
					dw_report.Create(ls_syntax)
					dw_report.TriggerEvent('ue_refresh_services')
					dw_report.TriggerEvent('ue_retrieve')
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
long	ll_rows
long	ll_blobobjectid
n_blob_manipulator ln_blob_manipulator
blob	lblob_datawindow_syntax
string	l_sMsg, ls_syntax

//RAP - Do not allow reports views to be saved from this object.
//      For all of the other objects, a supervisor can get into
//      table maintenance and reset the syntax in case a new release
//      conflicts with old templates. However, if this one is in conflict
//      there is no way for the user to fix the problem from the front end.
//ln_blob_manipulator = Create n_blob_manipulator
////----------------------------------------------------------------------------------------------------------------------------------
//// Create the datastore, set the dataobject and the transaction
////-----------------------------------------------------------------------------------------------------------------------------------
//ids_savedreport = Create datastore
//ids_savedreport.DataObject = 'd_data_savedreport_user_reportconfig'
//ids_savedreport.SetTransObject(SQLCA)

//----------------------------------------------------------------------------------------------------------------------------------
// Store the original syntax in case we want to revert to it
//-----------------------------------------------------------------------------------------------------------------------------------
is_original_syntax = dw_report.Object.Datawindow.Syntax


////----------------------------------------------------------------------------------------------------------------------------------
//// Get the rprtcnfgid so that we can look in SavedReport table to see if a previous saved syntax exists
////-----------------------------------------------------------------------------------------------------------------------------------
//  SELECT cusfocus.reportconfig.rprtcnfgid  
//    INTO :il_reportconfigid  
//    FROM cusfocus.reportconfig  
//   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Report Templates'   
//           ;
//
//ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, il_reportconfigid)
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Check to see if a row exists for 'D'efault syntax. If it does exist, get the blob ID and set the original syntax
////-----------------------------------------------------------------------------------------------------------------------------------
//ids_savedreport.SetFilter("svdrprttpe = 'D'")
//ll_rows = ids_savedreport.Filter()
//ll_rows = ids_savedreport.RowCount()
//IF ll_rows > 0 THEN
//	ll_blobobjectid = ids_savedreport.GetItemNumber(1, 'svdrprtblbobjctid')
//	
//	If Not IsNull(ll_blobobjectid) and ll_blobobjectid > 0 Then
//		iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobobjectid)
//		is_original_syntax = String(iblob_currentstate)
//		dw_report.Create(is_original_syntax)
//	END IF
//END IF
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Filter for last 'S'aved syntax.
////-----------------------------------------------------------------------------------------------------------------------------------
//ids_savedreport.SetFilter("svdrprttpe = 'S'")
//ll_rows = ids_savedreport.Filter()
//ll_rows = ids_savedreport.RowCount()
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Check to see if a row exists. If it does exist, get the blob ID and recreate the datawindow
////-----------------------------------------------------------------------------------------------------------------------------------
//If ll_rows > 0 Then
//	ll_blobobjectid = ids_savedreport.GetItemNumber(1, 'svdrprtblbobjctid')
//	
//	If Not IsNull(ll_blobobjectid) and ll_blobobjectid > 0 Then
//		
//		iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobobjectid)
//		
//		ls_syntax = String(iblob_currentstate)
//		
//		If dw_report.Create(ls_syntax, l_sMsg) <> 1 THEN
//			dw_report.Create(is_original_syntax)
//		End If
//		
//	End If
//End If

dw_report.SetTransObject(SQLCA)

//Destroy ln_blob_manipulator

end event

type dw_report from u_search`dw_report within u_search_report_templates
event ue_retrieve ( )
event ue_refresh_services ( )
integer width = 3401
integer height = 832
string dataobject = "d_user_report_templates"
end type

event dw_report::ue_retrieve();LONG l_nRtn

SetPointer( Hourglass! )

l_nRtn = THIS.Retrieve( gn_globals.is_login, DateTime(gn_globals.in_date_manipulator.of_now()) )

IF l_nRtn < 0 THEN
//   Error.i_FWError = SQLCA.SQLErrText
ELSEIF l_nRtn = 0 THEN
//	st_notes.Visible = FALSE
END IF

SetPointer( Arrow! )
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

//  SELECT cusfocus.reportconfig.rprtcnfgid  
//    INTO :il_reportconfigid  
//    FROM cusfocus.reportconfig  
//   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Open Cases'   
//           ;



Properties.of_init(il_reportconfigid)
end event

event dw_report::destructor;call super::destructor;////RAP - Do not allow reports views to be saved from this object.
////      For all of the other objects, a supervisor can get into
////      table maintenance and reset the syntax in case a new release
////      conflicts with old templates. However, if this one is in conflict
////      there is no way for the user to fix the problem from the front end.
////----------------------------------------------------------------------------------------------------------------------------------
//// variable Declaration
////-----------------------------------------------------------------------------------------------------------------------------------
//long ll_rows, ll_new_row, ll_blobID, ll_null
//string	ls_null, ls_syntax
//blob		lb_syntax
//
////n_blob_manipulator ln_blob_manipulator
////ln_blob_manipulator = Create n_blob_manipulator
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Ensure these variables are null
////-----------------------------------------------------------------------------------------------------------------------------------
//SetNull(ll_null)
//SetNull(ls_null)
//
////----------------------------------------------------------------------------------------------------------------------------------
//// 11/27/06 RAP - Do not save the filter with the datawindow syntax
////-----------------------------------------------------------------------------------------------------------------------------------
//dw_report.SetFilter("")
//dw_report.Filter()
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Retrieve the datastore then get the syntax for the datawindow & convert it into a blob object
////-----------------------------------------------------------------------------------------------------------------------------------
//ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, il_reportconfigid)
//lb_syntax = blob(dw_report.Describe("DataWindow.Syntax"))
// 
////----------------------------------------------------------------------------------------------------------------------------------
//// If we dont' have a row, then insert a new row and set the values. Otherwise update the existing row and blob.
////-----------------------------------------------------------------------------------------------------------------------------------
//If ids_savedreport.RowCount() = 0 Then
//	ll_new_row = ids_savedreport.InsertRow(0)
//	
//	ll_blobID = ln_blob_manipulator.of_insert_blob(lb_syntax, dw_report.dataobject)
//	
//	ids_savedreport.SetItem(ll_new_row, 'svdrprtfldrid', ls_null)
//	ids_savedreport.SetItem(ll_new_row, 'svdrprtblbobjctid', ll_blobID)
//	ids_savedreport.SetItem(ll_new_row, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
//	ids_savedreport.SetItem(ll_new_row, 'svdrprtrprtcnfgid', il_reportconfigid)
//	ids_savedreport.SetItem(ll_new_row, 'svdrprttpe', 'S')
//	ids_savedreport.SetItem(ll_new_row, 'svdrprtdstrbtnmthd', ls_null)	
//	ids_savedreport.SetItem(ll_new_row, 'svdrprtuserid', gn_globals.il_userid)
//	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnusrID', ll_null)
//	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnlvl', 1)
//	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
//Else
//	ll_blobID = ids_savedreport.getitemnumber(1, 'svdrprtblbobjctid')
//	ln_blob_manipulator.of_update_blob(lb_syntax, ll_blobID, FALSE)
//	
//	ids_savedreport.SetItem(1, 'svdrprtblbobjctid', ll_blobID)
//	ids_savedreport.SetItem(1, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
//	ids_savedreport.SetItem(1, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
//End If
//
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Save the changes to the database
////-----------------------------------------------------------------------------------------------------------------------------------
//ids_savedreport.Update()
//
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Destroy the objects
////-----------------------------------------------------------------------------------------------------------------------------------
//Destroy	ln_blob_manipulator
//Destroy 	in_datawindow_graphic_service_manager
//Destroy 	ids_savedreport
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;long ll_row

If Not IsNull(il_conf_level) and currentrow > 0 Then
	ll_row = dw_report_detail.Retrieve(this.GetItemNumber(currentrow, 'rprtcnfgid'))
End If


end event

type uo_titlebar from u_search`uo_titlebar within u_search_report_templates
string tag = "Appeal Tracker"
end type

event uo_titlebar::constructor;call super::constructor;This.of_delete_button('criteria')
This.of_delete_button('customize')
This.of_delete_button('retrieve')

end event

type st_separator from u_search`st_separator within u_search_report_templates
end type

type st_slider from u_slider_control_horizontal within u_search_report_templates
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

type dw_report_detail from u_datawindow within u_search_report_templates
integer y = 964
integer width = 2679
integer height = 544
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_user_saved_templates"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean automaticallypresentrightclickmenu = true
end type

event constructor;call super::constructor;Datawindow ldw_this
ldw_this = This
in_columnsizingservice_detail = Create n_column_sizing_service
in_columnsizingservice_detail.of_init(ldw_this)

in_datawindow_graphic_service_manager.of_add_service('n_rowfocus_service')
in_datawindow_graphic_service_manager.of_add_service('n_column_sizing_service')
in_datawindow_graphic_service_manager.of_add_service('n_show_fields')
in_datawindow_graphic_service_manager.of_add_service('n_group_by_service')
//in_datawindow_graphic_service_manager.of_add_service('n_datawindow_formatting_service')
in_datawindow_graphic_service_manager.of_add_service('n_aggregation_service')
in_datawindow_graphic_service_manager.of_add_service('n_sort_service')

in_datawindow_graphic_service_manager.of_Create_services()


end event

event destructor;call super::destructor;Destroy in_columnsizingservice_detail
end event

event doubleclicked;call super::doubleclicked;
//Pass the event to the Column Resizing Service
If IsValid(in_columnsizingservice_detail) Then
	in_columnsizingservice_detail.of_doubleclicked(dwo.Name, This.PointerX())
End If

Parent.of_apply()
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

event ue_pbmmousemove;//----------------------------------------------------------------------------------------------------------------------------------
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

type cb_apply from commandbutton within u_search_report_templates
integer x = 2871
integer y = 1432
integer width = 402
integer height = 80
integer taborder = 21
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Apply"
end type

event clicked;Parent.of_apply()
end event

type cbx_default from checkbox within u_search_report_templates
integer x = 2715
integer y = 1344
integer width = 695
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Set as Default Report View"
boolean checked = true
end type

type cbx_last_saved from checkbox within u_search_report_templates
integer x = 2715
integer y = 1260
integer width = 791
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Set as Last Saved Report View"
end type

