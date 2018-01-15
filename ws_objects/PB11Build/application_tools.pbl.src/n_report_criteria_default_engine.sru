$PBExportHeader$n_report_criteria_default_engine.sru
forward
global type n_report_criteria_default_engine from nonvisualobject
end type
end forward

global type n_report_criteria_default_engine from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
end type
global n_report_criteria_default_engine n_report_criteria_default_engine

type variables
Protected:
	Transaction ixctn_transaction
	long il_userid
	Long	il_reportconfigid
	String	is_custom_criteria_name = ''
	String	is_view_type = 'Criteria'
	Datastore ids_defaults
	Datastore ids_defaults_parsed
	PowerObject igo_last_graphicobject
	n_datawindow_tools in_datawindow_tools
	String	is_ignore_strings[]
	Boolean	ib_TheUserObjectWillRestoreItsOwnDefaults = False
	Boolean	ib_DynamicCriteriaExistsInThisView = False
	Boolean	ib_DoNotSaveToTheDatabase	= False
	Long		il_criteriaviewid
end variables

forward prototypes
public subroutine of_get_views (ref string as_views[], string as_type)
public subroutine of_set_using_custom_default_string (boolean ab_custom)
private function string of_get_object_default (ref powerobject ao_graphicobject)
public subroutine of_get_views (ref string as_views[])
public subroutine of_get_views (ref string as_views[], long al_reportconfigid, long al_userid)
public subroutine of_get_views (ref string as_views[], long al_reportconfigid, long al_userid, string as_type)
public subroutine of_ignore (string as_ignore)
public subroutine of_init (powerobject ago_graphicobject, long al_reportconfigid, long al_userid, string as_view_type)
private subroutine of_parse_arguments (string as_defaults)
private subroutine of_restore_datawindow_defaults (ref powerobject ao_datasource)
public function boolean of_isdynamiccriteria ()
public function string of_restore_dynamic_criteria (powerobject adw_data, long al_dynamiccriteriablbobjctid)
private subroutine of_restore_object_default (ref powerobject ao_graphicobject, string as_default)
public subroutine of_set_save (boolean ab_DoNotSaveToTheDatabase)
private function long of_retrieve (long al_reportdefaultid)
private function long of_retrieve (long al_reportconfigid, long al_userid, string as_custom_criteria_name, string as_type)
public subroutine of_restore_defaults (powerobject ago_object, long al_reportdefaultid)
public subroutine of_restore_defaults (powerobject ago_object, long al_reportconfigid, long al_userid)
public subroutine of_restore_defaults (powerobject ago_object, long al_reportconfigid, long al_userid, string as_custom_criteria_name)
public subroutine of_restore_defaults (powerobject ago_object, long al_reportconfigid, long al_userid, string as_custom_criteria_name, string as_type)
public function long of_get_current_view_id ()
public function long of_get_reportconfigid ()
public function string of_get_viewtype ()
public function long of_get_userid ()
public function long of_save_defaults (powerobject ago_object)
public function long of_save_defaults (powerobject ago_object, long al_reportconfigid)
public function long of_save_defaults (powerobject ago_object, long al_reportconfigid, long al_userid)
public function long of_save_defaults (powerobject ago_object, long al_reportconfigid, long al_userid, string as_custom_criteria_name)
public function long of_save_defaults (powerobject ago_object, long al_reportconfigid, long al_userid, string as_custom_criteria_name, string as_type)
public function string of_save_dynamic_criteria (powerobject adw_data, ref long al_dynamiccriteriablbobjctid)
public subroutine of_apply_defaults (powerobject ago_object)
private function string of_get_defaults (powerobject ago_source, ref long al_dynamiccriteriablbobjctid)
private function string of_get_datawindow_defaults (ref powerobject ao_datasource)
public function string of_export_view (powerobject ago_object, string as_custom_criteria_name, string as_viewtype)
public function string of_import_view (powerobject ago_object, string as_custom_criteria_name, string as_viewtype)
protected subroutine of_apply_defaults (powerobject ago_object, string as_defaults, long al_dynamiccriteriablbobjctid)
protected function string of_get_xml_node (string as_xml_document, string as_node)
public function string of_import_view (powerobject ago_object, string as_custom_criteria_name, string as_viewtype, string as_xml_document)
public function string of_import_view_public (graphicobject ago_object, string as_custom_criteria_name, string as_viewtype)
public subroutine of_get_views (ref string as_views[], ref long al_viewids[], long al_reportconfigid, long al_userid, string as_type)
end prototypes

event ue_notify(string as_message, any as_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    	- The message being triggered
//					aany_argument (Any) 		- The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Joel White
// History:   	7/11/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_RprtDfltID
String	ls_name
String	ls_delete
String	ls_return

//n_string_functions ln_string_functions

Choose Case Lower(Trim(as_message))
   Case 'save view as'
		OpenWithParm(w_criteriadefaultengine_save_view, This)
		ls_return = Message.StringParm
		If ls_return = '' Or IsNull(ls_return) Then Return
		
		//------------------------------------------------------------------------------------
		// Get the name and default
		//------------------------------------------------------------------------------------
		ls_name 			= gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'Name')
		ll_RprtDfltID 	= Long(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'RprtDfltID'))
		ls_delete		= '@@@' + gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'Delete') + '@@@'
		
		//------------------------------------------------------------------------------------
		// Return if the arguments aren't valid
		//------------------------------------------------------------------------------------
		If Len(ls_name) = 0 Or IsNull(ls_name) Then Return
		This.of_save_defaults(igo_last_graphicobject, il_reportconfigid, il_userid, ls_name)
	Case 'import view'
	Case 'restore view'
		If Not IsNull(il_reportconfigid) And Not IsNull(il_userid) And IsValid(igo_last_graphicobject) Then
			This.of_restore_defaults(igo_last_graphicobject, il_reportconfigid, il_userid, String(as_arg))
		End If
   Case Else
End Choose
	
end event

public subroutine of_get_views (ref string as_views[], string as_type);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_views()
//	Arguments:  al_reportconfigid 	- The report
//					al_userid				- The user
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	7/11/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_views(as_views[], il_reportconfigid, il_userid, as_type)

end subroutine

public subroutine of_set_using_custom_default_string (boolean ab_custom);ib_TheUserObjectWillRestoreItsOwnDefaults = ab_custom
end subroutine

private function string of_get_object_default (ref powerobject ao_graphicobject);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_get_object_default()
// Arguments:  	ao_graphicobject - The object to get defaults for
// Overview:    This will save the defaults for all the controls on a criteria object except for datawindows
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
String ls_null
String ls_selecteditems
Long ll_upperbound, ll_index

//----------------------------------------------------------------------------------------------------------------------------------
// You can access the properties of most controls with the text attribute or the checked attribute (radiobuttons and checkboxes)
// The only unusual control is the list box. It is documented below.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ao_graphicobject.TypeOf()
	Case checkbox!
		CheckBox lcb_temp
		lcb_temp = ao_graphicobject
		If lcb_temp.Checked Then
			Return ClassName(ao_graphicobject) + '@@@' + 'Y'
		Else
			Return ClassName(ao_graphicobject) + '@@@' + 'N'
		End If
	Case dropdownlistbox!, dropdownpicturelistbox!
		dropdownlistbox lddlb_temp
		lddlb_temp = ao_graphicobject
		Return ClassName(ao_graphicobject) + '@@@' + lddlb_temp.Text 
	Case listbox!, picturelistbox!
		//----------------------------------------------------------------------------------------------------------------------------------
		// If multiselect is turned on we need to take the comma delimited list of selected rows (1,2,3,5...,n) and select those rows
		//	If multiselect is turned off, we just select the row that is stored in the string.
		//-----------------------------------------------------------------------------------------------------------------------------------
		listbox llb_temp
		llb_temp = ao_graphicobject
		
		If llb_temp.MultiSelect Or llb_temp.ExtendedSelect Then
			ll_upperbound = UpperBound(llb_temp.Item[])
			
			For ll_index = 1 To ll_upperbound
				If llb_temp.State(ll_index) = 1 Then
					ls_selecteditems = ls_selecteditems + String(ll_index) + ','
				End If
			Next
			
			Return ClassName(ao_graphicobject) + '@@@' + Left(ls_selecteditems, Len(ls_selecteditems) - 1)
		Else
			Return ClassName(ao_graphicobject) + '@@@' + String(llb_temp.SelectedIndex())
		End If
	Case multilineedit!, editmask!
		multilineedit lmle_temp
		lmle_temp = ao_graphicobject
		Return ClassName(ao_graphicobject) + '@@@' + lmle_temp.Text
	Case radiobutton!
		RadioButton lrb_temp
		lrb_temp = ao_graphicobject
		If lrb_temp.Checked Then
			Return ClassName(ao_graphicobject) + '@@@' + 'Y'
		Else
			Return ClassName(ao_graphicobject) + '@@@' + 'N'
		End If
	Case singlelineedit!
		singlelineedit lsle_temp
		lsle_temp = ao_graphicobject
		Return ClassName(ao_graphicobject) + '@@@' + lsle_temp.Text
End Choose

SetNull(ls_null)
Return ls_null
end function

public subroutine of_get_views (ref string as_views[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_views()
//	Arguments:  al_reportconfigid 	- The report
//					al_userid				- The user
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	7/11/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_views(as_views[], is_view_type)

end subroutine

public subroutine of_get_views (ref string as_views[], long al_reportconfigid, long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_views()
//	Arguments:  al_reportconfigid 	- The report
//					al_userid				- The user
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	7/11/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_Get_views(as_views[], al_reportconfigid, al_userid, is_view_type)
end subroutine

public subroutine of_get_views (ref string as_views[], long al_reportconfigid, long al_userid, string as_type);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_views()
//	Arguments:  al_reportconfigid 	- The report
//					al_userid				- The user
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	7/11/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	ll_viewids[]

This.of_get_views(as_views[], ll_viewids[], al_reportconfigid, al_userid, as_type)
end subroutine

public subroutine of_ignore (string as_ignore);is_ignore_strings[UpperBound(is_ignore_strings[]) + 1] = as_ignore
end subroutine

public subroutine of_init (powerobject ago_graphicobject, long al_reportconfigid, long al_userid, string as_view_type);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Overview:    
// Created by:  Joel White
// History:     10/29/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

igo_last_graphicobject 	= ago_graphicobject
il_userid					= al_userid
il_reportconfigid			= al_reportconfigid
is_view_type				= as_view_type
end subroutine

private subroutine of_parse_arguments (string as_defaults);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_parse_arguments()
//	Arguments:  as_defaults 	- The defaults delimited by '||' and '@@@'
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	7/7/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_index
Long		ll_row
String	ls_objectname
String	ls_defaultstring
String	ls_defaults[]

//n_string_functions ln_string_functions

gn_globals.in_string_functions.of_parse_string(as_defaults, '||', ls_defaults[])

ids_defaults_parsed.Reset()

For ll_index = 1 To UpperBound(ls_defaults[])
	ls_objectname 		= Trim(Left(ls_defaults[ll_index], Pos(ls_defaults[ll_index], '@@@') - 1))
	ls_defaultstring	= Mid(ls_defaults[ll_index], Pos(ls_defaults[ll_index], '@@@') + 3, 8000)
	
	If Not IsNull(ls_objectname) And ls_objectname <> '' And Not IsNull(ls_defaultstring) Then
		ll_row = ids_defaults_parsed.InsertRow(0)
		ids_defaults_parsed.SetItem(ll_row, 'objectname', ls_objectname)
		ids_defaults_parsed.SetItem(ll_row, 'defaultstring', ls_defaultstring)
	End If
Next

ids_defaults_parsed.Sort()
end subroutine

private subroutine of_restore_datawindow_defaults (ref powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_restore_datawindow_defaults()
// Arguments:   adw_data - The datawindow that needs defaults restored
//					 ads_defaults	- The datastore that holds the default rows
//					 al_control_index - The index of the datawindow in the control array
// Overview:    This will restore the defaults to the columns of the datawindow
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
DatawindowChild ldwc_dddw, ldwc_empty
//n_string_functions ln_string_functions 
String ls_objectname, ls_columnname, ls_defaultvalue, ls_selected_items[]
String ls_datepart, ls_timepart, ls_datacolumnname
String	ls_columnstoignore
Long ll_index, ll_rowcount, ll_rownumber 
Double ldble_null
SetNull(ldble_null)

//----------------------------------------------------------------------------------------------------------------------------------
// Do not try to default the datawindow if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
If ao_datasource.Dynamic RowCount() < 1 Then Return

//----------------------------------------------------------------------------------------------------------------------------------
// Filter down to just the defaults for this datawindow using the classname
//-----------------------------------------------------------------------------------------------------------------------------------
ls_objectname = ao_datasource.Dynamic ClassName()
ids_defaults_parsed.SetFilter('Left(ObjectName, ' + String(Len(ls_objectname)) + ') = ~'' + ls_objectname + '~'')
ids_defaults_parsed.Filter()

//-----------------------------------------------------------------------------------------------------------------------------------
// If the user did not select anything in the multi-select dw then don't attempt to default it for
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_defaults_parsed.RowCount() = 0 Then Return

If String(ao_datasource.Dynamic Event ue_getobjecttype()) = 'u_dw_multiselect' Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// If this is a multi select datawindow we need to take the comma delimited list of selected rows (1,2,3,5...,n) and select those rows
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_defaultvalue 	= ids_defaults_parsed.GetItemString(1, 'DefaultString')
	gn_globals.in_string_functions.of_parse_string(ls_defaultvalue, ',', ls_selected_items[])		
	ll_rowcount = ao_datasource.Dynamic RowCount()

	ao_datasource.Dynamic SelectRow(0, False)
	
	For ll_index = 1 To UpperBound(ls_selected_items)
		If IsNumber(ls_selected_items[ll_index]) Then
			ll_rownumber = Long(ls_selected_items[ll_index])
			If ll_rowcount >= ll_rownumber And ll_rownumber > 0 And Not IsNull(ll_rownumber) Then
				ao_datasource.Dynamic SelectRow(ll_rownumber, True)
			End If
		End If
	Next
Else	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Loop through the default rows and set them into the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To ids_defaults_parsed.RowCount()
		ls_columnname 		= ids_defaults_parsed.GetItemString(ll_index, 'ObjectName')
		ls_defaultvalue 	= ids_defaults_parsed.GetItemString(ll_index, 'DefaultString')
		ls_columnname 		= Mid(ls_columnname, Len(ls_objectname) + 2, 1000)
		
		If Pos(',' + ls_columnstoignore + ',', ',' + ls_columnname + ',') > 0 Then Continue

		ls_datacolumnname = ao_datasource.Dynamic Describe(ls_columnname +  ".DDDW.DataColumn")
		if ls_datacolumnname <> '!' And ls_datacolumnname <> '?' then
			ao_datasource.Dynamic GetChild(ls_columnname, ldwc_dddw)
		Else
			ldwc_dddw = ldwc_empty
		End If
	
		//----------------------------------------------------------------------------------------------------------------------------------
		// Set the data into the column based on what the column datatype is.  If the column doesn't exist, nothing will happen.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case lower(left(ao_datasource.Dynamic Describe(ls_columnname + '.ColType'),4))
			Case 'numb','long','deci'
				If Trim(ls_defaultvalue) = '' Then
					ao_datasource.Dynamic setitem(1, ls_columnname, ldble_null)
				ElseIf IsNumber(ls_defaultvalue) Then
					//----------------------------------------------------------------------------------------------------------------------------------
					// If it is a dropdown, make sure the row is there before you default
					//-----------------------------------------------------------------------------------------------------------------------------------
					If ls_datacolumnname <> '!' And ls_datacolumnname <> '?' And Not IsNull(il_userid) then
						If IsValid(ldwc_dddw) Then
							If ldwc_dddw.Find(ls_datacolumnname + ' = ' + String(Dec(ls_defaultvalue)), 1, ldwc_dddw.RowCount()) > 0 Then
								ao_datasource.Dynamic setitem(1, ls_columnname, Dec(ls_defaultvalue))	
							Else
								ls_columnstoignore = ls_columnstoignore + ls_columnname + '_multi' + ','
							End If
						End If
					Else
						ao_datasource.Dynamic setitem(1, ls_columnname, Dec(ls_defaultvalue))
					End If
				End If
			Case 'date'
				ls_datepart = Trim(Left(ls_defaultvalue, Pos(ls_defaultvalue, ' ')))
				If Pos(ls_defaultvalue, ' ') > 0 Then
					ls_timepart = Trim(Mid(ls_defaultvalue, Pos(ls_defaultvalue, ' '), 100))
				End If
				
				If IsDate(ls_datepart) Then
					If Len(ls_timepart) > 0 Then
						If IsTime(ls_timepart) Then
							ao_datasource.Dynamic setitem(1, ls_columnname,DateTime(Date(ls_datepart), Time(ls_timepart)))
						Else
							ao_datasource.Dynamic setitem(1, ls_columnname,Date(ls_datepart))
						End IF
					Else
						ao_datasource.Dynamic setitem(1, ls_columnname,Date(ls_datepart))		
					End If
				End If

			Case 'char'
				If ls_datacolumnname <> '!' And ls_datacolumnname <> '?' And Not IsNull(il_userid) then
					//----------------------------------------------------------------------------------------------------------------------------------
					// If it is a dropdown, make sure the row is there before you default
					//-----------------------------------------------------------------------------------------------------------------------------------
					If IsValid(ldwc_dddw) Then
						If ldwc_dddw.Find(ls_datacolumnname + ' = "' + ls_defaultvalue + '"', 1, ldwc_dddw.RowCount()) > 0 Then
							ao_datasource.Dynamic setitem(1, ls_columnname, ls_defaultvalue)
						End If
					End If
				Else
					ao_datasource.Dynamic setitem(1, ls_columnname, ls_defaultvalue)
				End If
		End Choose
	Next
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Reset the filter
//-----------------------------------------------------------------------------------------------------------------------------------
ids_defaults_parsed.SetFilter('')
ids_defaults_parsed.Filter()

end subroutine

public function boolean of_isdynamiccriteria ();Return ib_DynamicCriteriaExistsInThisView
end function

public function string of_restore_dynamic_criteria (powerobject adw_data, long al_dynamiccriteriablbobjctid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_restore_dynamic_criteria()
//	Overview:   This will restore the dynamic criteria GUI into the datawindow
//	Created by:	Joel White
//	History: 	6/14/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------
n_blob_manipulator ln_blob_manipulator
Datastore lds_datastore
n_datawindow_tools ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_error_create
String	ls_return
String	ls_syntax

//----------------------------------------------------------------------------------
// Create the blob manipulator
//----------------------------------------------------------------------------------
ln_blob_manipulator = Create n_blob_manipulator
ls_syntax 	= String(ln_blob_manipulator.of_retrieve_blob(al_DynamicCriteriaBlbObjctID))
Destroy ln_blob_manipulator

//----------------------------------------------------------------------------------
// Return if there's an error
//----------------------------------------------------------------------------------
If Len(ls_syntax) <= 0 Or IsNull(ls_syntax) Then Return 'Error:  The criteria datawindow was not valid'

//----------------------------------------------------------------------------------
// Test to see if the syntax is valid
//----------------------------------------------------------------------------------
lds_datastore = Create Datastore
lds_datastore.Create(ls_syntax, ls_return)
Destroy lds_datastore
	
//----------------------------------------------------------------------------------
// Return if there's an error
//----------------------------------------------------------------------------------
If ls_return <> '' Then Return 'Error:  There was an error trying to recreate the dynamic criteria (' + ls_return + ')'

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message before the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('Before View Restored', '', adw_data)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Use the datawindow tools to apply the new syntax without modifying the attributes of the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_return = ln_datawindow_tools.of_apply_syntax(adw_data, ls_syntax)
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message after the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('criteria datawindow recreated', '', adw_data)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message after the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('After View Restored', '', adw_data)
End If

Return ''
end function

private subroutine of_restore_object_default (ref powerobject ao_graphicobject, string as_default);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_restore_object_default()
// Arguments:  	ao_graphicobject - The object to restore defaults to
//						as_default - A String containing the default value(s)
// Overview:    This will restore the defaults for all the controls on a criteria object except for datawindows
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
String ls_selected_items[]
Long ll_upperbound, ll_index, ll_return
//n_string_functions ln_string_functions

//----------------------------------------------------------------------------------------------------------------------------------
// You can access the properties of most controls with the text attribute or the checked attribute (radiobuttons and checkboxes)
// The only unusual control is the list box. It is documented below.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ao_graphicobject.TypeOf()
	Case checkbox!
		CheckBox lcb_temp
		lcb_temp = ao_graphicobject
		lcb_temp.Checked = (Upper(as_default) = 'Y')
	Case dropdownlistbox!, dropdownpicturelistbox!
		dropdownlistbox lddlb_temp
		lddlb_temp = ao_graphicobject
		lddlb_temp.Text = as_default
	Case listbox!, picturelistbox!
		//----------------------------------------------------------------------------------------------------------------------------------
		// If multiselect is turned on we need to take the comma delimited list of selected rows (1,2,3,5...,n) and select those rows
		//	If multiselect is turned off, we just select the row that is stored in the string.
		//-----------------------------------------------------------------------------------------------------------------------------------
		listbox llb_temp
		llb_temp = ao_graphicobject
		
		If llb_temp.MultiSelect Or llb_temp.ExtendedSelect Then
			gn_globals.in_string_functions.of_parse_string(as_default, ',', ls_selected_items[])		
			ll_upperbound = UpperBound(llb_temp.Item[])
			
			For ll_index = 1 To UpperBound(ls_selected_items)
				If IsNumber(ls_selected_items[ll_index]) Then
					ll_return = llb_temp.SetState(Long(ls_selected_items[ll_index]), True)
				End If
			Next
		Else
			If IsNumber(as_default) Then
				llb_temp.SelectItem(Long(as_default))
			End If
		End If
	Case multilineedit!, editmask!
		multilineedit lmle_temp
		lmle_temp = ao_graphicobject
		lmle_temp.Text = as_default
	Case radiobutton!
		RadioButton lrb_temp
		lrb_temp = ao_graphicobject
		lrb_temp.Checked = (Upper(as_default) = 'Y')
	Case singlelineedit!
		singlelineedit lsle_temp
		lsle_temp = ao_graphicobject
		lsle_temp.Text = as_default
End Choose
end subroutine

public subroutine of_set_save (boolean ab_DoNotSaveToTheDatabase);ib_DoNotSaveToTheDatabase = ab_DoNotSaveToTheDatabase
end subroutine

private function long of_retrieve (long al_reportdefaultid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_retrieve()
// Arguments:   al_reportdefaultid - the reportdefaultid
//					 al_reportconfigid - The reportconfigid
//					 al_userid	- The userid
// Overview:    This will restore the defaults for all the objects in the control array.
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the defaults
//-----------------------------------------------------------------------------------------------------------------------------------
ids_defaults.DataObject = 'd_report_criteria_defaults_by_id'
ids_defaults.SetTransObject(SQLCA)
il_criteriaviewid	= al_reportdefaultid

Return ids_defaults.Retrieve(al_reportdefaultid)

end function

private function long of_retrieve (long al_reportconfigid, long al_userid, string as_custom_criteria_name, string as_type);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_retrieve()
// Arguments:   al_reportdefaultid - the reportdefaultid
//					 al_reportconfigid - The reportconfigid
//					 al_userid	- The userid
// Overview:    This will restore the defaults for all the objects in the control array.
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the defaults
//-----------------------------------------------------------------------------------------------------------------------------------
ids_defaults.DataObject = 'd_report_criteria_defaults'
ids_defaults.SetTransObject(SQLCA)
Return ids_defaults.Retrieve(al_reportconfigid, al_userid, as_custom_criteria_name, as_type)
end function

public subroutine of_restore_defaults (powerobject ago_object, long al_reportdefaultid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_restore_defaults()
// Arguments:   al_reportdefaultid - the reportdefaultid
//					 al_reportconfigid - The reportconfigid
//					 al_userid	- The userid
// Overview:    This will restore the defaults for all the objects in the control array.
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_index, ll_findrow, ll_rowcount
String ls_defaultstring

//----------------------------------------------------------------------------------------------------------------------------------
// Return if the object isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(il_userid)
SetNull(il_reportconfigid)
igo_last_graphicobject = ago_object

If Not IsValid(ago_object) Then Return

//----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the defaults
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = This.of_Retrieve(al_reportdefaultid)

//----------------------------------------------------------------------------------------------------------------------------------
// Return if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_rowcount <= 0 Then Return

is_custom_criteria_name = ids_defaults.GetItemString(1, 'name')

This.of_apply_defaults(ago_object)
end subroutine

public subroutine of_restore_defaults (powerobject ago_object, long al_reportconfigid, long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_restore_defaults()
// Arguments:   al_reportdefaultid - the reportdefaultid
//					 al_reportconfigid - The reportconfigid
//					 al_userid	- The userid
// Overview:    This will restore the defaults for all the objects in the control array.
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//
//Declarations
This.of_restore_defaults(ago_object, al_reportconfigid, al_userid, '')
end subroutine

public subroutine of_restore_defaults (powerobject ago_object, long al_reportconfigid, long al_userid, string as_custom_criteria_name);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_restore_defaults()
// Arguments:   al_reportdefaultid - the reportdefaultid
//					 al_reportconfigid - The reportconfigid
//					 al_userid	- The userid
// Overview:    This will restore the defaults for all the objects in the control array.
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_restore_defaults(ago_object, al_reportconfigid, al_userid, as_custom_criteria_name, is_view_type)
end subroutine

public subroutine of_restore_defaults (powerobject ago_object, long al_reportconfigid, long al_userid, string as_custom_criteria_name, string as_type);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_restore_defaults()
// Arguments:   al_reportdefaultid - the reportdefaultid
//					 al_reportconfigid - The reportconfigid
//					 al_userid	- The userid
// Overview:    This will restore the defaults for all the objects in the control array.
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//
//Declarations
Long ll_index, ll_findrow, ll_rowcount
String ls_defaultstring

//----------------------------------------------------------------------------------------------------------------------------------
// Return if the object isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ago_object) Then Return

il_userid 			= al_userid
il_reportconfigid = al_reportconfigid
igo_last_graphicobject = ago_object


//----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the defaults
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = This.of_Retrieve(al_reportconfigid, al_userid, as_custom_criteria_name, as_type)

//----------------------------------------------------------------------------------------------------------------------------------
// Return if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_rowcount <= 0 Then Return

This.of_apply_defaults(ago_object)
end subroutine

public function long of_get_current_view_id ();Return il_criteriaviewid
end function

public function long of_get_reportconfigid ();Return il_reportconfigid
end function

public function string of_get_viewtype ();Return is_view_type
end function

public function long of_get_userid ();Return il_userid
end function

public function long of_save_defaults (powerobject ago_object);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_save_defaults()
// Arguments:   al_reportconfigid - The Report Configuration ID (unique id for a report in the reporting architecture)
//					 al_userid - The userid for the defaults to apply to (This can be null for user independent batch reporting)
// Overview:    DocumentScriptFunctionality
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_reportconfigid

SetNull(ll_reportconfigid)

Return This.of_save_defaults(ago_object, ll_reportconfigid)
end function

public function long of_save_defaults (powerobject ago_object, long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_save_defaults()
// Arguments:   al_reportconfigid - The Report Configuration ID (unique id for a report in the reporting architecture)
//					 al_userid - The userid for the defaults to apply to (This can be null for user independent batch reporting)
// Overview:    DocumentScriptFunctionality
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_userid

SetNull(ll_userid)

Return This.of_save_defaults(ago_object, al_reportconfigid, ll_userid)
end function

public function long of_save_defaults (powerobject ago_object, long al_reportconfigid, long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_save_defaults()
// Arguments:   al_reportconfigid - The Report Configuration ID (unique id for a report in the reporting architecture)
//					 al_userid - The userid for the defaults to apply to (This can be null for user independent batch reporting)
// Overview:    DocumentScriptFunctionality
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_save_defaults(ago_object, al_reportconfigid, al_userid, '')
end function

public function long of_save_defaults (powerobject ago_object, long al_reportconfigid, long al_userid, string as_custom_criteria_name);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_save_defaults()
// Arguments:   al_reportdefaultid - the reportdefaultid if it has been assigned (can be null)
//					 al_reportconfigid - The Report Configuration ID (unique id for a report in the reporting architecture)
//					 al_userid - The userid for the defaults to apply to (This can be null for user independent batch reporting)
// Overview:    DocumentScriptFunctionality
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_save_defaults(ago_object, al_reportconfigid, al_userid, as_custom_criteria_name, is_view_type)
end function

public function long of_save_defaults (powerobject ago_object, long al_reportconfigid, long al_userid, string as_custom_criteria_name, string as_type);//----------------------------------------------------------------------------------------------------------------------------------

// Function:  of_save_defaults()
// Arguments:   al_reportdefaultid - the reportdefaultid if it has been assigned (can be null)
//					 al_reportconfigid - The Report Configuration ID (unique id for a report in the reporting architecture)
//					 al_userid - The userid for the defaults to apply to (This can be null for user independent batch reporting)
//					 as_type	- The type of settings you are saving
// Overview:    DocumentScriptFunctionality
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
String ls_default_string, ls_old_default_string, ls_old_name
Long ll_index, ll_rowcount, ll_row, ll_null, ll_DynamicCriteriaBlbObjctID, ll_Old_DynamicCriteriaBlbObjctID

SetNull(ll_null)
	
ids_defaults.SetTransObject(SQLCA)

If Not IsNull(al_reportconfigid) Then
	If il_userid <> al_userid Or il_reportconfigid <> al_reportconfigid Or igo_last_graphicobject <> ago_object Or is_custom_criteria_name <> as_custom_criteria_name Or IsNull(il_userid) <> IsNull(al_userid) Or IsNull(il_reportconfigid) <> IsNull(al_reportconfigid) Then
		il_userid 						= al_userid
		il_reportconfigid 			= al_reportconfigid
		igo_last_graphicobject 		= ago_object
		is_custom_criteria_name 	= as_custom_criteria_name
		This.of_retrieve(il_reportconfigid, il_userid, as_custom_criteria_name, as_type)
	End If
Else
	ids_defaults.Reset()
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Get the default string for the user object passed in
//-----------------------------------------------------------------------------------------------------------------------------------
ls_default_string = This.of_get_defaults(ago_object, ll_DynamicCriteriaBlbObjctID)

//----------------------------------------------------------------------------------------------------------------------------------
// Insert the row if there isn't one, initialize the values
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_defaults.RowCount() <=0 Then
	ids_defaults.InsertRow(0)

	ids_defaults.SetItem(1, 'RprtCnfgID', al_reportconfigid)
	ids_defaults.SetItem(1, 'UserID', al_userid)
	ids_defaults.SetItem(1, 'CreatedByUserID', al_userid)
	ids_defaults.SetItem(1, 'Type', as_type)
	ids_defaults.SetItem(1, 'DynamicCriteriaBlbObjctID', ll_DynamicCriteriaBlbObjctID)
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Only set the string if there is a change
//-----------------------------------------------------------------------------------------------------------------------------------
ls_old_default_string 				= ids_defaults.GetItemString(1, 'DefaultString')
ls_old_name 							= ids_defaults.GetItemString(1, 'Name')
ll_Old_DynamicCriteriaBlbObjctID	= ids_defaults.GetItemNumber(1, 'DynamicCriteriaBlbObjctID')

If ll_Old_DynamicCriteriaBlbObjctID <> ll_DynamicCriteriaBlbObjctID Or IsNull(ll_Old_DynamicCriteriaBlbObjctID) <> IsNull(ll_DynamicCriteriaBlbObjctID) Then
	ids_defaults.SetItem(1, 'DynamicCriteriaBlbObjctID', ll_DynamicCriteriaBlbObjctID)
End If

If IsNull(ls_old_default_string) Or ls_old_default_string <> ls_default_string Then
	ids_defaults.SetItem(1, 'DefaultString', ls_default_string)
End If

If IsNull(ls_old_name) Or ls_old_name <> as_custom_criteria_name Then
	ids_defaults.SetItem(1, 'Name', as_custom_criteria_name)
End If

If Not IsNull(ls_old_name) And as_custom_criteria_name <> ls_old_name Then
	ids_defaults.SetItem(1, 'RprtDfltID', ll_null)
	ids_defaults.SetItemStatus(1, 0, Primary!, New!)
	ids_defaults.SetItemStatus(1, 0, Primary!, NewModified!)
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Update the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_DoNotSaveToTheDatabase Then
	ids_defaults.Update()
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Get the report default id for later and return it
//-----------------------------------------------------------------------------------------------------------------------------------
il_criteriaviewid	= ids_defaults.GetItemNumber(1, 'RprtDfltID')
Return il_criteriaviewid
end function

public function string of_save_dynamic_criteria (powerobject adw_data, ref long al_dynamiccriteriablbobjctid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_dynamic_criteria()
//	Overview:   This will save the dynamic criteria GUI datawindow into a blobobject
//	Created by:	Joel White
//	History: 	6/14/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------
n_blob_manipulator ln_blob_manipulator
Datastore lds_datastore
n_datawindow_tools ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return
String	ls_syntax
Long		ll_return
Blob		lblob_temp

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are problems
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(adw_data) Then Return 'Error:  The datawindow is not valid'
//If Not IsValid(adw_data.Object) Then Return 'Error:  The datawindow object is not valid'

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message before the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('Before View Saved', '', adw_data)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is only one column, this means that there is nothing to save
//-----------------------------------------------------------------------------------------------------------------------------------
If Long(adw_data.Dynamic Describe("Datawindow.Column.Count")) = 1 Then
	If al_dynamiccriteriablbobjctid > 0 And Not IsNull(al_dynamiccriteriablbobjctid) Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Delete the blob object from the database
		//-----------------------------------------------------------------------------------------------------------------------------------
		ln_blob_manipulator = Create n_blob_manipulator
		ln_blob_manipulator.of_delete_blob(al_dynamiccriteriablbobjctid)
		Destroy ln_blob_manipulator

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set it to null
		//-----------------------------------------------------------------------------------------------------------------------------------
		SetNull(al_dynamiccriteriablbobjctid)
	End If
	
	Return ''
End If
//------------------------------------------------------------------------------------
// Get the new syntax
//------------------------------------------------------------------------------------
ls_syntax = adw_data.Dynamic Describe("Datawindow.Syntax")

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message after the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('After View Restored', '', adw_data)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the syntax is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_syntax) <= 0 Then Return 'Error:  The datawindow syntax was not valid'

//-----------------------------------------------------------------------------------------------------------------------------------
// Turn the syntax into a blob
//-----------------------------------------------------------------------------------------------------------------------------------
lblob_temp = Blob(ls_syntax)

//----------------------------------------------------------------------------------
// Create the blob manipulator
//----------------------------------------------------------------------------------
ln_blob_manipulator = Create n_blob_manipulator

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the blob into the database
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(al_DynamicCriteriaBlbObjctID) And al_DynamicCriteriaBlbObjctID > 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Try to update if possible
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_return = ln_blob_manipulator.of_update_blob(lblob_temp, al_DynamicCriteriaBlbObjctID, FALSE)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the update doesn't work, insert the blob
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_return < 0 Then
		ll_return = ln_blob_manipulator.of_insert_blob(lblob_temp, 'DynamicCriteria', FALSE)
	End If
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert the blob into the database
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_return = ln_blob_manipulator.of_insert_blob(lblob_temp, 'DynamicCriteria', FALSE)
End If

Destroy ln_blob_manipulator

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there was an error
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_return <= 0 Then Return 'Error:  Could not insert binary object into database (' + SQLCA.SQLErrText + ')'

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the reference variable to the new (or old) blobobject id
//-----------------------------------------------------------------------------------------------------------------------------------
al_DynamicCriteriaBlbObjctID	= ll_return

Return ''
end function

public subroutine of_apply_defaults (powerobject ago_object);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_apply_defaults()
// Overview:    This will restore the defaults for all the objects in the control array.
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_DynamicCriteriaBlbObjctID
String	ls_defaultstring

//----------------------------------------------------------------------------------------------------------------------------------
// Return if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_defaults.RowCount() <= 0 Then Return

//----------------------------------------------------------------------------------------------------------------------------------
// Get the default string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_defaultstring 					= ids_defaults.GetItemString(1, 'DefaultString')
il_criteriaviewid					= ids_defaults.GetItemNumber(1, 'RprtDfltID')
ll_DynamicCriteriaBlbObjctID	= ids_defaults.GetItemNumber(1, 'DynamicCriteriaBlbObjctID')

//----------------------------------------------------------------------------------------------------------------------------------
// Apply the defaults for this object
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_apply_defaults(ago_object, ls_defaultstring, ll_DynamicCriteriaBlbObjctID)
end subroutine

private function string of_get_defaults (powerobject ago_source, ref long al_dynamiccriteriablbobjctid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_defaults()
// Arguments:   ago_source - the object to get defaults from
// Overview:    This will get a default string for every object that exists on the object
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
String 	ls_default_string, ls_total_string = ''
Long 		ll_index
UserObject luo_source
Datawindow ldw_datawindow

SetNull(al_DynamicCriteriaBlbObjctID)

If ib_TheUserObjectWillRestoreItsOwnDefaults Then
	Return String(ago_source.Dynamic Event ue_get_default_string())
End If

//----------------------------------------------------------------------------------------------------------------------------------
//This will loop through the control array saving the defaults for each object
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ago_source.TypeOf()
	Case UserObject!
		luo_source = ago_source
		For ll_index = 1 To UpperBound(luo_source.Control[])
			If Not IsValid(luo_source.Control[ll_index]) Then Continue
		
			//----------------------------------------------------------------------------------------------------------------------------------
			// There are two functions.  One for saving datawindow defaults and another for all other controls
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case luo_source.Control[ll_index].TypeOf() 
				Case DataWindow!, Datastore!, DatawindowChild!
					If luo_source.Control[ll_index].TypeOf() = Datawindow! Then
						ldw_datawindow = luo_source.Control[ll_index]
						If IsValid(ldw_datawindow) Then
							//----------------------------------------------------------------------------------------------------------------------------------
							// If this is the dynamic criteria, save it into the blob object
							//-----------------------------------------------------------------------------------------------------------------------------------
							If ldw_datawindow.DataObject = 'd_custom_criteria_blank' Or ClassName(ldw_datawindow) = 'dw_dynamic_criteria' Then
								If ids_defaults.RowCount() > 0 Then
									al_DynamicCriteriaBlbObjctID = ids_defaults.GetItemNumber(1, 'DynamicCriteriaBlbObjctID')
								Else
									SetNull(al_DynamicCriteriaBlbObjctID)
								End If
								
								This.of_save_dynamic_criteria(ldw_datawindow, al_DynamicCriteriaBlbObjctID)
							End If
						End If
					End If
					
					
					ls_default_string = This.of_get_datawindow_defaults(luo_source.Control[ll_index])
					If IsNull(ls_default_string) Or ls_default_string = '' Then Continue
					
					ls_total_string = ls_total_string + ls_default_string + '||'
				Case Else
					ls_default_string = of_get_object_default(luo_source.Control[ll_index])
					If IsNull(ls_default_string) Then Continue
		
					ls_total_string = ls_total_string + ls_default_string + '||'
			End Choose
		Next
		
		ls_total_string = Left(ls_total_string, Len(ls_total_string) - 2)
	Case Datawindow!, Datastore!
		ls_total_string = This.of_get_datawindow_defaults(ago_source)
End Choose

Return ls_total_string
end function

private function string of_get_datawindow_defaults (ref powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_datawindow_defaults()
// Arguments:   adw_data - The datawindow that needs defaults saved
//					 ads_defaults	- The datastore that holds the default rows
// Overview:    This will restore the defaults to the columns of the datawindow
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Boolean	lb_add_to_string
String ls_objectname, ls_columnname, ls_defaultvalue = '', ls_default_return_string = '', ls_selectrowindicator[]
Long ll_index, ll_index2, ll_row, ll_rowcount

//----------------------------------------------------------------------------------------------------------------------------------
// Do not try to default the datawindow if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
If ao_datasource.Dynamic RowCount() < 1 Then Return ls_default_return_string

//----------------------------------------------------------------------------------------------------------------------------------
// Get the classname of the object
//-----------------------------------------------------------------------------------------------------------------------------------
ls_objectname = ao_datasource.ClassName()
ao_datasource.Dynamic AcceptText()

//----------------------------------------------------------------------------------------------------------------------------------
// If the object is a multi-select datawindow, act differently than external datawindows
//-----------------------------------------------------------------------------------------------------------------------------------
If String(ao_datasource.Event Dynamic ue_getobjecttype()) = 'u_dw_multiselect' Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// If this is a multi select datawindow we need to return a comma delimited list of selected rows (1,2,3,5...,n)
	//-----------------------------------------------------------------------------------------------------------------------------------
	If in_datawindow_tools.of_IsColumn(ao_datasource, 'SelectRowIndicator') Then
		ll_rowcount = ao_datasource.Dynamic RowCount()			
		ll_row = ao_datasource.Dynamic Find('selectrowindicator=~'Y~'', 1, ll_rowcount)
		
		Do While ll_row > 0 And Not IsNull(ll_row) And ll_row < ll_rowcount
			ls_defaultvalue = ls_defaultvalue + String(ll_row) + ','
			ll_row = ao_datasource.Dynamic Find('selectrowindicator=~'Y~'', ll_row + 1, ll_rowcount)
		Loop
	Else	
		ll_row = ao_datasource.Dynamic GetSelectedRow(0)
		
		Do While ll_row > 0
			ls_defaultvalue = ls_defaultvalue + String(ll_row) + ','
			ll_row = ao_datasource.Dynamic GetSelectedRow(ll_row)
		Loop
	End If
	
	ls_default_return_string = ls_objectname + '@@@' + ls_defaultvalue
Else	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Loop through the default rows and set them into the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To Long(ao_datasource.Dynamic Describe("Datawindow.Column.Count"))
		ls_columnname 		= ao_datasource.Dynamic Describe("#" + String(ll_index) + ".Name")
		ls_defaultvalue = in_datawindow_tools.of_getitem(ao_datasource, 1, ls_columnname)
		
		lb_add_to_string = True
		
		For ll_index2 = 1 To UpperBound(is_ignore_strings[])
			If is_ignore_strings[ll_index2] = ls_defaultvalue Then
				lb_add_to_string = False
				Exit
			End If
		Next
		
		If Not lb_add_to_string Then Continue
		
		ls_default_return_string = ls_default_return_string + ls_objectname + '.' + ls_columnname + '@@@' + ls_defaultvalue + '||'
	Next

	//----------------------------------------------------------------------------------------------------------------------------------
	// Cut off the extra '||'
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_default_return_string = Left(ls_default_return_string, Len(ls_default_return_string) - 2)
End If

Return ls_default_return_string
end function

public function string of_export_view (powerobject ago_object, string as_custom_criteria_name, string as_viewtype);//----------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------
Long		ll_DynamicCriteriaBlbObjctID
String	ls_data
String	ls_dynamic_data
String	ls_filedata
String	ls_pathname
String	ls_viewtype

//----------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------
n_blob_manipulator ln_blob_manipulator
n_folderbrowse ln_folderbrowse
//n_string_functions ln_string_functions

//----------------------------------------------------------------------------------
// Find the path for the file
//----------------------------------------------------------------------------------
ln_folderbrowse = CREATE n_folderbrowse
ls_pathname = Trim(ln_folderbrowse.of_browseforfolder(w_mdi_frame, 'Pick the destination file folder for this saved view.'))
Destroy ln_folderbrowse

//----------------------------------------------------------------------------------
// Return if the canceled
//----------------------------------------------------------------------------------
If Len(Trim(ls_pathname)) = 0 Then Return ''

//----------------------------------------------------------------------------------
// Make sure there's a slash
//----------------------------------------------------------------------------------
If Right(ls_pathname, 1) <> '\' Then ls_pathname = ls_pathname + '\'

Choose Case Lower(Trim(as_viewtype))
	Case 'criteria'
		ls_viewtype = 'Criteria'
	Case 'filter'
		ls_viewtype = 'Filter'
	Case 'uom/currency'
		ls_viewtype = 'UOM-Currency'
End Choose

//----------------------------------------------------------------------------------
// Determine the file name
//----------------------------------------------------------------------------------
If Len(as_custom_criteria_name) <= 0 Or IsNull(as_custom_criteria_name) Then
	as_custom_criteria_name = is_custom_criteria_name
	
	If Len(as_custom_criteria_name) <= 0 Or IsNull(as_custom_criteria_name) Then
		as_custom_criteria_name = 'Exported ' + ls_viewtype + ' View'
	End If
End If

//----------------------------------------------------------------------------------
// Replace all invalid characters
//----------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(as_custom_criteria_name, '/', '-')
gn_globals.in_string_functions.of_replace_all(as_custom_criteria_name, '\', '-')
gn_globals.in_string_functions.of_replace_all(as_custom_criteria_name, ':', '-')
gn_globals.in_string_functions.of_replace_all(as_custom_criteria_name, '*', '-')
gn_globals.in_string_functions.of_replace_all(as_custom_criteria_name, '|', '-')
gn_globals.in_string_functions.of_replace_all(as_custom_criteria_name, '>', '-')
gn_globals.in_string_functions.of_replace_all(as_custom_criteria_name, '<', '-')
gn_globals.in_string_functions.of_replace_all(as_custom_criteria_name, '?', '-')

//----------------------------------------------------------------------------------
// Add the file extension
//----------------------------------------------------------------------------------
ls_pathname = ls_pathname + Trim(as_custom_criteria_name) + '.' + ls_viewtype + '.RAIV'

//----------------------------------------------------------------------------------
// Ask if they are overwriting the file
//----------------------------------------------------------------------------------
If FileExists(ls_pathname) Then
	//If gn_globals.in_messagebox.of_messagebox('This file already exists at this location, would you like to overwrite it', YesNoCancel!, 3) <> 1 Then Return ''
End If

//----------------------------------------------------------------------------------
// Get the defaults from the criteria object
//----------------------------------------------------------------------------------
ls_data = This.of_get_defaults(ago_object, ll_DynamicCriteriaBlbObjctID)

//----------------------------------------------------------------------------------
// Create the blob manipulator
//----------------------------------------------------------------------------------
ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------
// If there is dynamic criteria, turn it into a string and delete the row
//----------------------------------------------------------------------------------
If Not IsNull(ll_DynamicCriteriaBlbObjctID) And ll_DynamicCriteriaBlbObjctID > 0 Then
	ls_dynamic_data = String(ln_blob_manipulator.of_retrieve_blob(ll_DynamicCriteriaBlbObjctID))
	ln_blob_manipulator.of_delete_blob(ll_DynamicCriteriaBlbObjctID)
End If

//----------------------------------------------------------------------------------
// Build the XML Document
//----------------------------------------------------------------------------------
ls_filedata = '<' + ls_viewtype + 'Views>~r~n~t<' + ls_viewtype + 'View>~r~n~t~t<' + ls_viewtype + 'ObjectData>~r~n~t~t~t<![ CDATA [' + ls_data + ']]>~r~n~t~t</' + ls_viewtype + 'ObjectData>'

//----------------------------------------------------------------------------------
// Add the dynamic criteria portion
//----------------------------------------------------------------------------------
If Len(Trim(ls_dynamic_data)) > 0 Then
	ls_filedata = ls_filedata + '~r~n~t~t<' + ls_viewtype + 'ObjectDynamicData>~r~n~t~t~t<![ CDATA [' + ls_dynamic_data + ']]>~r~n~t~t</' + ls_viewtype + 'ObjectDynamicData>'
End If

//----------------------------------------------------------------------------------
// Complete the XML document
//----------------------------------------------------------------------------------
ls_filedata = ls_filedata + '~r~n~t</' + ls_viewtype + 'View>~r~n</' + ls_viewtype + 'Views>'

//----------------------------------------------------------------------------------
// Create a file from the blob
//----------------------------------------------------------------------------------
ln_blob_manipulator.of_build_file_from_blob(Blob(ls_filedata), ls_pathname)

//----------------------------------------------------------------------------------
// Destroy the blob manipulator
//----------------------------------------------------------------------------------
Destroy ln_blob_manipulator

Return ''
end function

public function string of_import_view (powerobject ago_object, string as_custom_criteria_name, string as_viewtype);//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_return
Long		ll_BlobObjectID
String	ls_pathname
String	ls_filename 
String	ls_return
String	ls_xml_document
String	ls_objectdata
String	ls_dynamicobjectdata
Blob		lblob_xml_document

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_common_dialog ln_common_dialog
n_blob_manipulator ln_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the type of view
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_viewtype))
	Case 'criteria'
		as_viewtype = 'Criteria'
	Case 'filter'
		as_viewtype = 'Filter'
	Case 'uom/currency'
		as_viewtype = 'UOM-Currency'
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Open a window to let them pick a file
//-----------------------------------------------------------------------------------------------------------------------------------
ln_common_dialog = Create n_common_dialog
ll_return = ln_common_dialog.of_GetFileOpenName('Available ' + as_viewtype + ' View Files', ls_pathname, ls_filename ,'RAIV', "CustomerFocus Files (*.RAIV),*.RAIV")
Destroy ln_common_dialog

//----------------------------------------------------------------------------------------------------------------------------------
// Return if everything is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
if ll_return <= 0 Then Return ''
If len(ls_pathname) <= 0  Then Return ''
If Not FileExists(ls_pathname) Then Return ''

//----------------------------------------------------------------------------------------------------------------------------------
// Build a blob from the file so we can easily parse it
//-----------------------------------------------------------------------------------------------------------------------------------
ln_blob_manipulator = Create n_blob_manipulator 
lblob_xml_document = ln_blob_manipulator.of_build_blob_from_file(ls_pathname)
Destroy ln_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Turn the blob into a string, since it's a text file
//-----------------------------------------------------------------------------------------------------------------------------------
ls_xml_document = String(lblob_xml_document)

Return This.of_import_view(ago_object, as_custom_criteria_name, as_viewtype, ls_xml_document)
end function

protected subroutine of_apply_defaults (powerobject ago_object, string as_defaults, long al_dynamiccriteriablbobjctid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_apply_defaults()
// Overview:    This will restore the defaults for all the objects in the control array.
// Created by:  Joel White
// History:     6/17/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_index
Long	ll_findrow

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
UserObject	luo_object
Datastore	lds_datastore
Datawindow	ldw_datawindow

//----------------------------------------------------------------------------------------------------------------------------------
// Return if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
ib_DynamicCriteriaExistsInThisView	= False

If ib_TheUserObjectWillRestoreItsOwnDefaults Then
	ago_object.Dynamic Event ue_notify('restore defaults', as_defaults)
	Return
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Call event to provide a hook
//-----------------------------------------------------------------------------------------------------------------------------------
ago_object.Dynamic Event ue_notify('before restore default', as_defaults)

//----------------------------------------------------------------------------------------------------------------------------------
// Parse it into the instance datastore
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_parse_arguments(as_defaults)

//----------------------------------------------------------------------------------------------------------------------------------
// Return if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_defaults_parsed.RowCount() <= 0 Then Return

Choose Case ago_object.TypeOf()
	Case UserObject!
		luo_object = ago_object
		//----------------------------------------------------------------------------------------------------------------------------------
		//This will loop through the control array defaulting each object
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index = 1 To UpperBound(luo_object.Control[])
			//----------------------------------------------------------------------------------------------------------------------------------
			// Continue if the object isn't valid
			//-----------------------------------------------------------------------------------------------------------------------------------
			If Not IsValid(luo_object.Control[ll_index]) Then Continue
			
			//----------------------------------------------------------------------------------------------------------------------------------
			// There are two functions.  One for restoring datawindow defaults and another for all other controls
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case luo_object.Control[ll_index].TypeOf()
				Case DataWindow!
					If luo_object.Control[ll_index].TypeOf() = Datawindow! Then
						ldw_datawindow = luo_object.Control[ll_index]
						If IsValid(ldw_datawindow) Then
							If ldw_datawindow.DataObject = 'd_custom_criteria_blank' Or ClassName(ldw_datawindow) = 'dw_dynamic_criteria' Then
								If Not IsNull(al_DynamicCriteriaBlbObjctID) And al_DynamicCriteriaBlbObjctID > 0 Then
									This.of_restore_dynamic_criteria(ldw_datawindow, al_DynamicCriteriaBlbObjctID)
									ib_DynamicCriteriaExistsInThisView = Long(ldw_datawindow.Dynamic Describe("Datawindow.Column.Count")) > 1
								End If
							End If
						End If
					End If
					
					This.of_restore_datawindow_defaults(luo_object.Control[ll_index])
				
				Case Else
					If ids_defaults_parsed.RowCount() > 0 Then
						ll_findrow = ids_defaults_parsed.Find('Lower(ObjectName) = ~'' + Lower(String(luo_object.Control[ll_index].ClassName())) + '~'', 1, ids_defaults_parsed.RowCount())
						If ll_findrow > 0 Then
							of_restore_object_default(luo_object.Control[ll_index], ids_defaults_parsed.GetItemString(ll_findrow, 'DefaultString'))
						End If
					End If
			End Choose
		Next

	Case Datawindow!
		ldw_datawindow	= ago_object
		
		If ldw_datawindow.DataObject = 'd_custom_criteria_blank' Or ClassName(ldw_datawindow) = 'dw_dynamic_criteria' Then
			If Not IsNull(al_DynamicCriteriaBlbObjctID) And al_DynamicCriteriaBlbObjctID > 0 Then
				This.of_restore_dynamic_criteria(ago_object, al_DynamicCriteriaBlbObjctID)
				ib_DynamicCriteriaExistsInThisView = Long(ago_object.Dynamic Describe("Datawindow.Column.Count")) > 1
			End If
		End If

		This.of_restore_datawindow_defaults(ago_object)
	Case Datastore!
		lds_datastore	= ago_object
		
		If lds_datastore.DataObject = 'd_custom_criteria_blank' Or ClassName(lds_datastore) = 'dw_dynamic_criteria' Then
			If Not IsNull(al_DynamicCriteriaBlbObjctID) And al_DynamicCriteriaBlbObjctID > 0 Then
				This.of_restore_dynamic_criteria(ago_object, al_DynamicCriteriaBlbObjctID)
				ib_DynamicCriteriaExistsInThisView = Long(ago_object.Dynamic Describe("Datawindow.Column.Count")) > 1
			End If
		End If

		This.of_restore_datawindow_defaults(ago_object)
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Call event to provide a hook
//-----------------------------------------------------------------------------------------------------------------------------------
ago_object.Dynamic Event ue_notify('after restore default', as_defaults)
end subroutine

protected function string of_get_xml_node (string as_xml_document, string as_node);Long		ll_position
String	ls_nodedata

//----------------------------------------------------------------------------------------------------------------------------------
// Find the object data tag and extract the data
//-----------------------------------------------------------------------------------------------------------------------------------
ll_position = Pos(as_xml_document, '<' + as_node + '>')

If ll_position <= 0 Then Return ''

ls_nodedata = Mid(as_xml_document, ll_position + Len('<' + as_node + '>'))

ll_position = Pos(ls_nodedata, '</' + as_node + '>')

If ll_position <= 0 Then Return ''

ls_nodedata = Left(ls_nodedata, ll_position - 1)

Do While Left(ls_nodedata, 2) = '~r~n' Or Left(ls_nodedata, 1) = '~t'
	If Left(ls_nodedata, 2) = '~r~n' Then
		ls_nodedata = Trim(Mid(ls_nodedata, 3))
	Else
		ls_nodedata = Trim(Mid(ls_nodedata, 2))
	End If
Loop

Do While Right(ls_nodedata, 2) = '~r~n' Or Right(ls_nodedata, 1) = '~t'
	If Right(ls_nodedata, 2) = '~r~n' Then
		ls_nodedata = Trim(Left(ls_nodedata, Len(ls_nodedata) - 2))
	Else
		ls_nodedata = Trim(Left(ls_nodedata, Len(ls_nodedata) - 1))
	End If
Loop

If Left(ls_nodedata, Len('<![')) = '<![' And Pos(Trim(Mid(ls_nodedata, 4)), 'CDATA') = 1 Then
	ls_nodedata = Trim(Mid(ls_nodedata, 4))
	If Right(ls_nodedata, Len(']]>')) = ']]>' Then ls_nodedata = Left(ls_nodedata, Len(ls_nodedata) - 3)
		
	If Left(ls_nodedata, Len('CDATA')) = 'CDATA' Then ls_nodedata = Trim(Mid(ls_nodedata, Len('CDATA') + 1))
	If Left(ls_nodedata, 1) = '[' Then ls_nodedata = Mid(ls_nodedata, 2)
End If

Return ls_nodedata
end function

public function string of_import_view (powerobject ago_object, string as_custom_criteria_name, string as_viewtype, string as_xml_document);//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_BlobObjectID
String	ls_objectdata
String	ls_dynamicobjectdata

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_blob_manipulator ln_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Get the two pieces of information from the document
//-----------------------------------------------------------------------------------------------------------------------------------
ls_objectdata 			= This.of_get_xml_node(as_xml_document, as_viewtype + 'ObjectData')
ls_dynamicobjectdata	= This.of_get_xml_node(as_xml_document, as_viewtype + 'ObjectDynamicData')

//----------------------------------------------------------------------------------------------------------------------------------
// Return if we don't find it
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_objectdata) <= 0 Then Return 'Error:  Could not find the ' + as_viewtype + 'ObjectData tag in the XML document view'

//----------------------------------------------------------------------------------------------------------------------------------
// If there is some dynamic content, we need to create a blob temporarily
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_dynamicobjectdata) > 0 And Not IsNull(ls_dynamicobjectdata) Then
	ln_blob_manipulator = Create n_blob_manipulator 
	ll_BlobObjectID = ln_blob_manipulator.of_insert_blob(Blob(ls_dynamicobjectdata), 'Temp View Blob')
	Destroy ln_blob_manipulator
Else
	SetNull(ll_BlobObjectID)
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Apply the defaults to the object
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_apply_defaults(ago_object, ls_objectdata, ll_BlobObjectID)

//----------------------------------------------------------------------------------------------------------------------------------
// Delete the temporary blob object
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ll_BlobObjectID) And ll_BlobObjectID > 0 Then
	ln_blob_manipulator = Create n_blob_manipulator 
	ln_blob_manipulator.of_delete_blob(ll_BlobObjectID)
	Destroy ln_blob_manipulator
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Return
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public function string of_import_view_public (graphicobject ago_object, string as_custom_criteria_name, string as_viewtype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_import_view_public()
// Overview:    Import a view from the ftp server
// Created by:  Joel White
// History:     11/17/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------
// Local Variables
//------------------------------------------------------------------------------------
String	ls_viewname
String	ls_xml_document
String	ls_return

//------------------------------------------------------------------------------------
// Local Objects
//------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
//w_import_file_from_ftp	lw_import_file_from_ftp
n_bag ln_bag
Any	lany_file
Blob	lblob_file

ln_bag = Create n_bag

Choose Case Lower(Trim(as_viewtype))
	Case 'criteria'
		as_viewtype = 'Criteria'
		ln_bag.of_set('bitmap', 'Module - Reporting Desktop - Criteria View (Global).bmp')
		ln_bag.of_set('window title', 'Download Public Criteria View')
		ln_bag.of_set('path', 'Criteria Views/' + ClassName(ago_object))
//	Case 'filter'
//		as_viewtype = 'Filter'
//		ln_bag.of_set('bitmap', 'Module - Reporting Desktop - Filter View (Global).bmp')
//		ln_bag.of_set('window title', 'Download Public Filter View')
//		ln_bag.of_set('path', 'Criteria Views/' + ClassName(ago_object))
End Choose
		
ln_bag.of_set('window description', 'Select a public view to import.  You will need to save the view after downloading it.')
ln_bag.of_set('button text', 'Import')

//------------------------------------------------------------------------------------
// Open the window to name the view
//------------------------------------------------------------------------------------
//OpenWithParm(w_import_file_from_ftp, ln_bag)

//------------------------------------------------------------------------------------
// Get the message and see if it's valid
//------------------------------------------------------------------------------------
If Len(Trim((Message.StringParm))) > 0 Then
	Destroy ln_bag
	Return Message.StringParm
End If

If Not IsValid(ln_bag) Then Return 'Error:  Nothing came back'

ls_viewname = String(ln_bag.of_get('File Name'))
If ln_bag.of_exists('File Blob') Then
	lany_file	= ln_bag.of_get('File Blob')
	lblob_file	= lany_file
	ls_xml_document	= String(lblob_file)
Else
	Return 'Error:  Nothing came back'
End If

Destroy ln_bag


Return This.of_import_view(ago_object, as_custom_criteria_name, as_viewtype, ls_xml_document)

end function

public subroutine of_get_views (ref string as_views[], ref long al_viewids[], long al_reportconfigid, long al_userid, string as_type);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_views()
//	Arguments:  al_reportconfigid 	- The report
//					al_userid				- The user
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	7/11/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_views[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore lds_named_criteria

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore and retrieve the named criteria defaults
//-----------------------------------------------------------------------------------------------------------------------------------
lds_named_criteria = Create Datastore
lds_named_criteria.DataObject = 'd_report_criteria_defaults_named'
lds_named_criteria.SetTransObject(SQLCA)
lds_named_criteria.Retrieve(al_reportconfigid, al_userid, as_type)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the views
//-----------------------------------------------------------------------------------------------------------------------------------
If lds_named_criteria.RowCount() > 0 Then
	ls_views[] 		= lds_named_criteria.Object.Name.Primary
	al_viewids[]	= lds_named_criteria.Object.RprtDfltID.Primary
End If

as_views[] = ls_views[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy lds_named_criteria
end subroutine

on n_report_criteria_default_engine.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_report_criteria_default_engine.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;SetNull(il_userid)

in_datawindow_tools = Create n_datawindow_tools

ids_defaults = Create Datastore	
ids_defaults.Dataobject = 'd_report_criteria_defaults'
ids_defaults.SetTransObject(SQLCA)

ids_defaults_parsed = Create Datastore
ids_defaults_parsed.DataObject = 'd_report_criteria_defaults_parsed'


end event

event destructor;Destroy ids_defaults
Destroy ids_defaults_parsed
Destroy in_datawindow_tools
end event

