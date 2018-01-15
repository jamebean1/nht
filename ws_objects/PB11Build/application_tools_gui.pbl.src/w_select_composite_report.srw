$PBExportHeader$w_select_composite_report.srw
forward
global type w_select_composite_report from window
end type
type tv_folder from u_treeview within w_select_composite_report
end type
type cb_cancel from commandbutton within w_select_composite_report
end type
type cb_1 from commandbutton within w_select_composite_report
end type
end forward

global type w_select_composite_report from window
boolean visible = false
integer x = 1074
integer y = 484
integer width = 2039
integer height = 1280
boolean titlebar = true
string title = "Add Report to Composite Report"
windowtype windowtype = response!
long backcolor = 79741120
tv_folder tv_folder
cb_cancel cb_cancel
cb_1 cb_1
end type
global w_select_composite_report w_select_composite_report

type variables
Protected:
	u_dynamic_gui_report_adapter iu_dynamic_gui_adapter
end variables

on w_select_composite_report.create
this.tv_folder=create tv_folder
this.cb_cancel=create cb_cancel
this.cb_1=create cb_1
this.Control[]={this.tv_folder,&
this.cb_cancel,&
this.cb_1}
end on

on w_select_composite_report.destroy
destroy(this.tv_folder)
destroy(this.cb_cancel)
destroy(this.cb_1)
end on

event open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      open
// Overrides:  No
// Overview:   Get a list of available reports and present them
//	Created by: Blake Doerr
//	History:    1/31/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_canchangeview, lb_canaddreports
Long		ll_pictureindex
Long		ll_reportconfigid[]
Long 		ll_index
String	ls_reporttype[]
String	ls_reportname[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Make the window visible
//-----------------------------------------------------------------------------------------------------------------------------------
This.visible = true
end event

type tv_folder from u_treeview within w_select_composite_report
event type string ue_get_selected_reports ( )
integer x = 32
integer y = 24
integer width = 1966
integer height = 1020
integer taborder = 10
boolean border = true
boolean haslines = false
boolean linesatroot = false
boolean hideselection = false
boolean checkboxes = true
grsorttype sorttype = ascending!
end type

event ue_get_selected_reports;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_get_selected_reports
//	Overrides:  No
//	Arguments:	
//	Overview:   This will get information from all the reports that need to be opened
//	Created by: Blake Doerr
//	History:    8/29/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore lds_datastore
TreeviewItem ltvi_item

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_reportconfigid
Long		ll_CmpsteRprtCnfgDtlID
Long		ll_rprtcnfgpvttbleid
Long		ll_dtaobjctstteidnty
Long 		ll_index
Long		ll_upperbound
Long		ll_orderid
Long		ll_height
Long		ll_handle
Long		ll_return
String	ls_isparentobject
String	ls_iscriteriaallowed
String	ls_isrequired
String	ls_parameters
String	ls_expanded
String	ls_return	= ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the datastore that was retrieved to populate the treeview
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore = in_treeview_manager.of_get_datastore()
If IsNumber(lds_datastore.Describe("SortString.ID")) Then
	lds_datastore.SetSort('SortString A')
	lds_datastore.Sort()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the rows in the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To lds_datastore.RowCount()
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the handle of the row
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_handle = lds_datastore.GetItemNumber(ll_index, 'ItemHandle')

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Continue if the handle is invalid
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsNull(ll_handle) Or ll_handle <= 0 Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the treeview item based on the handle
	//-----------------------------------------------------------------------------------------------------------------------------------
	This.GetItem(ll_handle, ltvi_item)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the treeviewitem is invalid, continue
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not IsValid(ltvi_item) Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Make sure that the box is checked.  The checkbox is actually the state picture and the index = 1 for off and 2 for on
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not ltvi_item.StatePictureIndex = 2 Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the information from the datastore about the report
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_reportconfigid				= lds_datastore.GetItemNumber(ll_index, 'RprtCnfgID')
	ll_RprtCnfgPvtTbleID			= lds_datastore.GetItemNumber(ll_index, 'RprtCnfgPvtTbleID')
	ll_DtaObjctStteIdnty			= lds_datastore.GetItemNumber(ll_index, 'DtaObjctStteIdnty')
	ls_isparentobject				= Upper(Trim(lds_datastore.GetItemString(ll_index, 'IsParentObject')))
	ls_expanded						= 'Y'
	ls_iscriteriaallowed			= Upper(Trim(lds_datastore.GetItemString(ll_index, 'IsCriteriaAllowed')))
	ls_isrequired					= Upper(Trim(lds_datastore.GetItemString(ll_index, 'IsRequired')))
	ls_parameters					= Trim(lds_datastore.GetItemString(ll_index, 'DefaultParameters'))
	ll_height						= 500
	ll_CmpsteRprtCnfgDtlID		= lds_datastore.GetItemNumber(ll_index, 'CmpsteRprtCnfgDtlID')

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Make sure all the values are valid
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsNull(ll_reportconfigid) Or ll_reportconfigid <= 0 Then Continue
	If IsNull(ll_CmpsteRprtCnfgDtlID) Or ll_CmpsteRprtCnfgDtlID <= 0 Then Continue
	If IsNull(ls_isparentobject) Or Trim(ls_isparentobject) = '' Then ls_isparentobject = 'Y'
	If IsNull(ls_iscriteriaallowed) Or Trim(ls_iscriteriaallowed) = '' Then ls_iscriteriaallowed = 'Y'
	If IsNull(ls_isrequired) Or Trim(ls_isrequired) = '' Then ls_isrequired = 'Y'
	If IsNull(ls_parameters) Then ls_parameters = ''

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Build the parameters string for this report
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_return = ls_return + 'RprtCnfgID=' + String(ll_reportconfigid) + '||CmpsteRprtCnfgDtlID=' + String(ll_CmpsteRprtCnfgDtlID) + '||isparent=' + ls_isparentobject + '||allowcriteria=' + ls_iscriteriaallowed + '||isrequired=' + ls_isrequired + '||isexpanded=' + ls_expanded + '||height=' + String(ll_height)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add it to the string if it isn't null
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not IsNull(ll_RprtCnfgPvtTbleID) Then
		ls_return = ls_return + '||RprtCnfgPvtTbleID=' + String(ll_RprtCnfgPvtTbleID)
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add it to the string if it is not null
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not IsNull(ll_DtaObjctStteIdnty) Then
		ls_return = ls_return + '||DtaObjctStteIdnty=' + String(ll_DtaObjctStteIdnty)
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Remove the last comma and add the double-pipe to the end
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_return	= ls_return + '@@@'
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Cut the || off the end of the string
//-----------------------------------------------------------------------------------------------------------------------------------
Return Left(ls_return, Len(ls_return) - 3)
end event

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      constructor
// Overrides:  No
// Overview:   Create the items in the treeview
// Created by: Pat Newgent
// History:    12/15/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the passed in dao is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(Message.PowerObjectParm) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the report manager from the message object
//-----------------------------------------------------------------------------------------------------------------------------------
iu_dynamic_gui_adapter	= Message.PowerObjectParm

Call Super::Constructor

//-----------------------------------------------------
// Call controlling nvo's of_build_tree passing it the
// root level id.  The root level id is used as the starting
// point for the tree. 
//-----------------------------------------------------
in_treeview_manager.of_build_tree(of_get_root_level_id())

in_treeview_manager.of_expand_all ( )
This.SetRedraw(True)
end event

event ue_init();call super::ue_init;string s_sql

//-----------------------------------------------------
// Set the datawindow syntax used to create the treeview
// from.  In this case, the result set from a stored
// procedure is used to create the treeview.
//-----------------------------------------------------
s_sql = 'Exec sp_get_available_composite_reports ' + String(iu_dynamic_gui_adapter.Properties.RprtCnfgId) + ', "Y", ' + string(gn_globals.il_userid)
this.of_set_dw_sql(s_sql, False)

end event

event clicked;call super::clicked;This.Post SetRedraw(True)
end event

event ue_postinit;call super::ue_postinit;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_get_selected_reports
//	Overrides:  No
//	Arguments:	
//	Overview:   This will get information from all the reports that need to be opened
//	Created by: Blake Doerr
//	History:    8/29/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore lds_datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_folderid
Long 		ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the datastore that was retrieved to populate the treeview
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore = in_treeview_manager.of_get_datastore()

If Not IsNumber(lds_datastore.Describe('RprtCnfgFldrID.ID')) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the rows in the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = lds_datastore.RowCount() To 1 Step -1
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the handle of the row
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_folderid = lds_datastore.GetItemNumber(ll_index, 'RprtCnfgFldrID')

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Continue if the handle is invalid
	//-----------------------------------------------------------------------------------------------------------------------------------
//	If Not gn_globals.in_security.of_get_folder_security(ll_folderid, 'Report') > 0 Then lds_datastore.DeleteRow(ll_index)
Next
end event

type cb_cancel from commandbutton within w_select_composite_report
integer x = 1678
integer y = 1084
integer width = 325
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   close and return nothing
//	Created by: Blake Doerr
//	History:    1/31/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Close(Parent)
end event

type cb_1 from commandbutton within w_select_composite_report
integer x = 1330
integer y = 1084
integer width = 325
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   return the templateid for the selected dealtype
//	Created by: Blake Doerr
//	History:    1/31/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_reporttype, ls_reports_to_open, ls_reportstrings[], ls_displayobject
Long 		ll_reportconfigid, ll_index
//n_string_functions ln_string_functions
n_report ln_report

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the properties for the composite report
//-----------------------------------------------------------------------------------------------------------------------------------
ls_reports_to_open = tv_folder.Event ue_get_selected_reports()

gn_globals.in_string_functions.of_parse_string(ls_reports_to_open, '@@@', ls_reportstrings[])

For ll_index = 1 To UpperBound(ls_reportstrings[])
	ll_reportconfigid = Long(gn_globals.in_string_functions.of_find_argument(ls_reportstrings[ll_index], '||', 'RprtCnfgID'))
	ln_report = Create n_report
	ln_report.of_init(ll_reportconfigid)
	ln_report.of_set_options(ls_reportstrings[ll_index])
	iu_dynamic_gui_adapter.of_open_report(ln_report)
Next

If IsValid(iu_dynamic_gui_adapter) And UpperBound(ls_reportstrings[]) > 0 Then
	iu_dynamic_gui_adapter.TriggerEvent('resize')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Close the window
//-----------------------------------------------------------------------------------------------------------------------------------
Close(Parent)
end event

