$PBExportHeader$u_search_letter.sru
forward
global type u_search_letter from u_search
end type
type dw_report_detail from u_datawindow within u_search_letter
end type
end forward

global type u_search_letter from u_search
integer width = 3611
integer height = 2492
event ue_post_constructor ( )
event type string ue_template_restore ( )
event ue_template_save ( )
dw_report_detail dw_report_detail
end type
global u_search_letter u_search_letter

type variables
n_column_sizing_service in_columnsizingservice_detail

long il_conf_level
long	il_reportconfigid

datastore	ids_savedreport

blob	iblob_syntax
string	is_syntax, is_original_syntax

w_letter_search iw_myParent

String is_case_type, is_source_type
end variables

forward prototypes
public subroutine of_set_conf_level (long al_conf_level)
end prototypes

event ue_post_constructor();uo_titlebar.of_delete_button('Customize...')
uo_titlebar.of_add_button('Restore Original View', 'restore' )

// 11/27/06 RAP - With proper security, users can save report templates
IF gn_globals.il_view_confidentiality_level > 2 THEN
	uo_titlebar.of_add_button('Save View As Template', 'save template' )
	uo_titlebar.of_add_button('Restore Template View', 'restore template' )
END IF

// 11/21/06 RAP - This will show the filter bar when the window opens
THIS.POST EVENT ue_notify("button clicked","filters")


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

on u_search_letter.create
int iCurrent
call super::create
this.dw_report_detail=create dw_report_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report_detail
end on

on u_search_letter.destroy
call super::destroy
destroy(this.dw_report_detail)
end on

event ue_retrieve;call super::ue_retrieve;long ll_row

ll_row = dw_report.Retrieve(is_case_type, is_source_type)


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

Long ll_row, ll_blob_id
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
					// 11/27/06 RAP - Fix to bug not allowing row selection after a restore
					dw_report.TriggerEvent('ue_refresh_services')
					dw_report.TriggerEvent('ue_retrieve')
			Case 'save template'
					THIS.EVENT ue_template_save()
			Case 'restore template'
					ls_syntax = THIS.EVENT ue_template_restore()
					dw_report.Create(ls_syntax)
					// 11/27/06 RAP - Fix to bug not allowing row selection after a restore
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

event constructor;call super::constructor;This.Post Event ue_post_constructor()	


//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long	ll_rows
long	ll_blobobjectid
n_blob_manipulator ln_blob_manipulator
blob	lblob_datawindow_syntax
string	l_sMsg, ls_syntax

ln_blob_manipulator = Create n_blob_manipulator
// Pass the message along to the parent window before the
// services mess it up
l_sMsg = Message.StringParm
is_case_type = MID(l_sMsg,1,1)
is_source_type = MID(l_sMsg,3,1)

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
   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Letters'   
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
		
		If dw_report.Create(ls_syntax, l_sMsg) <> 1 THEN
			dw_report.Create(is_original_syntax)
		Else
			dw_report.SetTransObject(SQLCA)
		End If
		
	End If
End If

Destroy ln_blob_manipulator
iw_myParent = PARENT


end event

type dw_report from u_search`dw_report within u_search_letter
event ue_retrieve ( )
event ue_checktrans ( string a_ccasenumber )
event ue_selecttrigger pbm_dwnkey
event ue_refresh_services ( )
integer width = 3497
integer height = 1616
string dataobject = "d_letter_search"
end type

event dw_report::ue_retrieve();LONG l_nRtn

SetPointer( Hourglass! )

l_nRtn = THIS.Retrieve(is_case_type, is_source_type )

IF l_nRtn < 0 THEN
//   Error.i_FWError = SQLCA.SQLErrText
ELSEIF l_nRtn = 0 THEN
//	st_notes.Visible = FALSE
END IF

SetPointer( Arrow! )
end event

event dw_report::ue_selecttrigger;///****************************************************************************************
//
//	Event:	ue_selecttrigger
//	Purpose:	Trigger the select function when the user presses the Enter key.
//	
//	Revisions:
//	Date     Developer     Description
//	======== ============= ==============================================================
//	11/20/2006 Rick Post    Created
//****************************************************************************************/
//

// if the user double-clicked on a row, process it.
IF ( key = KeyEnter! ) AND ( THIS.GetRow() > 0 ) THEN
	iw_myParent.DYNAMIC of_select()
END IF
end event

event dw_report::ue_refresh_services();IF IsValid(in_datawindow_graphic_service_manager) THEN

	in_datawindow_graphic_service_manager.of_init(dw_report)
	
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
END IF




end event

event dw_report::constructor;call super::constructor;long	ll_reportconfigid

in_datawindow_graphic_service_manager = Create n_datawindow_graphic_service_manager

THIS.EVENT TRIGGER ue_refresh_services()

this.TriggerEvent('ue_retrieve')

  SELECT cusfocus.reportconfig.rprtcnfgid  
    INTO :il_reportconfigid  
    FROM cusfocus.reportconfig  
   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Letters'   
           ;



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

event dw_report::doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  11/20/2006 Rick Post   Added code to trigger selection when double click on a row
//***********************************************************************************************  

IF THIS.RowCount( ) > 0 THEN
	IF row > 0 THEN
		iw_myParent.DYNAMIC of_select()
	END IF
END IF
end event

event dw_report::ue_dwnkey;//this.triggerevent('ue_selecttrigger')

THIS.Event Trigger ue_selecttrigger( key, keyflags )
end event

type uo_titlebar from u_search`uo_titlebar within u_search_letter
string tag = "Appeal Tracker"
end type

event uo_titlebar::constructor;call super::constructor;This.of_delete_button('criteria')
This.of_delete_button('customize')
This.of_delete_button('retrieve')

end event

type st_separator from u_search`st_separator within u_search_letter
end type

type dw_report_detail from u_datawindow within u_search_letter
boolean visible = false
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

