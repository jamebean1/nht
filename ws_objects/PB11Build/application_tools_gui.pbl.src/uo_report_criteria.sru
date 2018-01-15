$PBExportHeader$uo_report_criteria.sru
$PBExportComments$This is the base Report Criteria object.  It is used by the Reporting Architecture.
forward
global type uo_report_criteria from userobject
end type
type sle_customtitle from singlelineedit within uo_report_criteria
end type
end forward

global type uo_report_criteria from userobject
integer width = 1362
integer height = 336
long backcolor = 80263581
long tabtextcolor = 33554432
event ue_refreshtheme ( )
event ue_notify ( string as_message,  any as_arg )
event ue_showmenu ( )
sle_customtitle sle_customtitle
end type
global uo_report_criteria uo_report_criteria

type variables
datawindow dw_report
string is_dataobject
boolean ib_show_criteria = false
/*JLR-used to enable/disable button */
boolean ib_restore_defaults = false

PROTECTED:
	transaction ixctn_db
	u_search iu_search
	u_dynamic_gui_report_adapter iu_dynamic_gui_report_adapter
	n_report_criteria_default_engine in_report_criteria_default_engine
	Long		il_reportconfigid
	Long		il_userid
	Boolean	ib_AllowDynamicCriteria = False
	Boolean	ib_ShowDynamicCriteria = False
	Boolean	ib_batchmode
end variables

forward prototypes
public subroutine of_proc ()
public subroutine of_restore_defaults ()
public subroutine of_set_db_transaction (transaction axctn_db)
public function transaction of_get_db_transaction ()
public subroutine of_post_default ()
public subroutine of_init (u_search au_search)
public function long of_save_criteria (long al_reportconfigid, long al_userid)
public function long of_save_criteria (long al_reportconfigid)
public function long of_save_criteria (long al_reportconfigid, long al_userid, string as_custom_criteria_name)
public subroutine of_retrieve ()
public function long of_save_criteria ()
public subroutine of_init (datawindow adw_data)
public subroutine of_init (u_dynamic_gui_report_adapter au_dynamic_gui_report_adapter)
public function boolean of_validate ()
public function boolean of_validate_dates ()
public subroutine of_restore_saved_criteria (long al_reportconfigid, long al_userid)
public subroutine of_restore_saved_criteria (long al_reportconfigid, long al_userid, string as_custom_criteria_name)
public subroutine of_restore_saved_criteria (long al_reportdefaultid)
public subroutine of_set_batch_mode (boolean ab_batchmode)
public subroutine of_auto_retrieve ()
public function string of_set_data (string as_data)
public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic)
public subroutine of_save_state ()
public subroutine of_restore_state ()
end prototypes

event ue_refreshtheme;this.backcolor = gn_globals.in_theme.of_get_backcolor()
end event

event ue_notify(string as_message, any as_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:        ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//		aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   8.23.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

w_reportconfig_manage_views lw_reportconfig_manage_views
n_class_functions ln_class_functions
//n_string_functions ln_string_functions
Window	lw_window
n_bag ln_bag
Datawindow	ldw_datawindow
Long		ll_index
String	ls_describe
String	ls_return
String	ls_expression

Choose Case Lower(Trim(as_message))
   Case 'menucommand'
		Choose Case Lower(Trim(as_arg))
			Case 'resetcriteria'
				sle_customtitle.Text = ''
				This.of_restore_Defaults()
				This.Event ue_notify('restore defaults', '')
			Case 'manage criteria views'
				ln_bag = Create n_bag
				ln_bag.of_set('RprtCnfgID', il_reportconfigid)
				ln_bag.of_set('type', 'criteria')
				
				OpenWithParm(lw_reportconfig_manage_views, ln_bag, 'w_reportconfig_manage_views', w_mdi)
			Case 'export criteria'
				If Not IsValid(in_report_criteria_default_engine) Then
					in_report_criteria_default_engine = Create n_report_criteria_default_engine
				End If
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Return the report default id for this saved criteria
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_return = in_report_criteria_default_engine.of_export_view(This, '', 'criteria')
				
				If Not ib_batchmode And Len(ls_return) > 0 Then gn_globals.in_messagebox.of_messagebox_validation(ls_return)
			Case 'import criteria'
				If Not IsValid(in_report_criteria_default_engine) Then
					in_report_criteria_default_engine = Create n_report_criteria_default_engine
				End If
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Return the report default id for this saved criteria
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_return = in_report_criteria_default_engine.of_import_view(This, '', 'criteria')
				If Not ib_batchmode And Len(ls_return) > 0 Then gn_globals.in_messagebox.of_messagebox_validation(ls_return)
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Make sure to show the dynamic criteria
				//-----------------------------------------------------------------------------------------------------------------------------------
				If in_report_criteria_default_engine.of_isdynamiccriteria() Then
					If ib_AllowDynamicCriteria And Not ib_ShowDynamicCriteria Then
						ib_ShowDynamicCriteria = True
						This.TriggerEvent('resize')
						This.TriggerEvent('ue_resize')
					End If
				End If
			Case 'import criteria public'
				If Not IsValid(in_report_criteria_default_engine) Then
					in_report_criteria_default_engine = Create n_report_criteria_default_engine
				End If
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Return the report default id for this saved criteria
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_return = in_report_criteria_default_engine.of_import_view_public(This, '', 'criteria')
				If Not ib_batchmode And Len(ls_return) > 0 Then gn_globals.in_messagebox.of_messagebox_validation(ls_return)
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Make sure to show the dynamic criteria
				//-----------------------------------------------------------------------------------------------------------------------------------
				If in_report_criteria_default_engine.of_isdynamiccriteria() Then
					If ib_AllowDynamicCriteria And Not ib_ShowDynamicCriteria Then
						ib_ShowDynamicCriteria = True
						This.TriggerEvent('resize')
						This.TriggerEvent('ue_resize')
					End If
				End If
			Case 'createcustomtitle'
				For ll_index = 1 To UpperBound(This.Control[])
					If Not IsValid(This.Control[ll_index]) Then Continue
					If This.Control[ll_index].TypeOf() <> Datawindow! Then Continue
					ldw_datawindow = This.Control[ll_index]
					If ldw_datawindow.DataObject = 'd_custom_criteria_blank' Then Continue
					Exit
				Next
				
				If Not IsValid(ldw_datawindow) Then Return
				
				//----------------------------------------------------------------------------------------------------------------------------------
				// Allow the user to define the expression
				//-----------------------------------------------------------------------------------------------------------------------------------
				ln_bag = Create n_bag
				ln_bag.of_set('datasource', ldw_datawindow)
				ln_bag.of_set('title', 'Select the Expression for the Custom Report Title')
				ln_bag.of_set('expression', Mid(sle_customtitle.Text, 2, Max(0, Len(sle_customtitle.Text) - 2)))
				ln_bag.of_set('NameIsAllowed', 'no')
				ln_bag.of_set('columnprefix', 'LookupDisplay(')
				ln_bag.of_set('columnsuffix', ')')
				OpenWithParm(lw_window, ln_bag, 'w_custom_expression_builder', w_mdi)
				
				//----------------------------------------------------------------------------------------------------------------------------------
				// Return if the canceled out of the dialog
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Not IsValid(ln_bag) Then Return
				
				//----------------------------------------------------------------------------------------------------------------------------------
				// 
				//-----------------------------------------------------------------------------------------------------------------------------------
				sle_customtitle.Text 	= '"' + Trim(String(ln_bag.of_get('datawindowexpression'))) + '"'
				If sle_customtitle.Text = '""' Then
					sle_customtitle.Text = ''
				End If
				
				Destroy ln_bag
		End Choose
	Case 'before retrieve'
		If Len(Trim(sle_customtitle.Text)) > 2 Then
			For ll_index = 1 To UpperBound(This.Control[])
				If Not IsValid(This.Control[ll_index]) Then Continue
				If This.Control[ll_index].TypeOf() <> Datawindow! Then Continue
				ldw_datawindow = This.Control[ll_index]
				If ldw_datawindow.DataObject = 'd_custom_criteria_blank' Then Continue
				Exit
			Next
			
			If Not IsValid(ldw_datawindow) Then Return
						
			If ln_class_functions.of_IsAncestor(ldw_datawindow, 'u_datawindow') Then
				ldw_datawindow.Dynamic of_SuppressErrorEvent(True)
			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Replace all double quotes with ~" in the expression
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_expression = Mid(sle_customtitle.Text, 2, Max(0, Len(sle_customtitle.Text) - 2))
			
			gn_globals.in_string_functions.of_replace_all(ls_expression,'"','~~"')
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Evaluate the expression.
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_describe = "Evaluate(~"" + ls_expression + "~",1)"
			ls_return = ldw_datawindow.Describe(ls_describe)

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Replace all double quotes with ~" in the expression
			//-----------------------------------------------------------------------------------------------------------------------------------
			gn_globals.in_string_functions.of_replace_all(ls_return,'"','~~"')

			If ls_return <> '!' And ls_return <> '?' And Len(Trim(ls_return)) > 0 Then
				ls_return = dw_report.Modify('report_title.Text="' + ls_return + '"')
			End If
		End If
	Case 'after retrieve'
   Case Else
End Choose

end event

event ue_showmenu();Window lw_window
GraphicObject lgo_parent
m_dynamic lm_dynamic_menu
n_menu_dynamic ln_menu_dynamic

ln_menu_dynamic = Create n_menu_dynamic
ln_menu_dynamic.of_set_target_name('uo_report_criteria')
ln_menu_dynamic.of_set_target(This)

This.of_build_menu(ln_menu_dynamic)

lm_dynamic_menu = Create m_dynamic
lm_dynamic_menu.of_set_menuobject(ln_menu_dynamic)

//----------------------------------------------------------------------------------------------------------------------------------
// display the already created menu object.
//-----------------------------------------------------------------------------------------------------------------------------------
lgo_parent = this.getparent()

//----------------------------------------------------------------------------------------------------------------------------------
// Find the ultimate parent window and return it.
//-----------------------------------------------------------------------------------------------------------------------------------
DO WHILE lgo_parent.TypeOf() <> Window!	
	lgo_parent = lgo_parent.GetParent()
LOOP

lw_window = lgo_parent

//----------------------------------------------------------------------------------------------------------------------------------
// Pop the menu differently based on the window type
//-----------------------------------------------------------------------------------------------------------------------------------
if lw_window.windowtype = Response! Or lw_window.windowtype = Popup! Or Not isvalid(w_mdi.getactivesheet()) Or (w_mdi.getactivesheet() <> lw_window) then
	lm_dynamic_menu.popmenu(lw_window.pointerx(), lw_window.pointery())
else
	lm_dynamic_menu.popmenu(w_mdi.pointerx(), w_mdi.pointery())
end if
end event

public subroutine of_proc ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_proc()
// Arguments:   none
// Overview:    Stub function for Procedures
// Created by:  Jake Pratt
// History:     01/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

end subroutine

public subroutine of_restore_defaults ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_restore_defaults()
// Arguments:   
// Overview:    stub function to restore original defaults on criteria uo
//					 Overload this function and put your code here to restore defaults and to initialize the defaults
// Created by:  Lynn Reiners
// History:     07/30/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

end subroutine

public subroutine of_set_db_transaction (transaction axctn_db);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_set_db_transaction
// Arguments:	axctn_db - pointer to transaction
// Overview:	initialize transaction for reporting objects
// Created by:	Gary Howard
// History:		12/4/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ixctn_db = axctn_db
end subroutine

public function transaction of_get_db_transaction ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_get_db_transaction
// Arguments:	NONE
// Overview:	Return pointer to reporting transaction
// Created by:	Gary Howard
// History:		12/4/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ixctn_db
end function

public subroutine of_post_default ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_post_default()
//	Overview:   This function is called after the defaults have been applied to the criteria
//	Created by:	Blake Doerr
//	History: 	8.23.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Overload this function to add code after defaulting occurs
//-----------------------------------------------------------------------------------------------------------------------------------

end subroutine

public subroutine of_init (u_search au_search);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_init()
// Arguments:   au_search - Reference to the search object
// Overview:    Set a pointer to the search object with which this object is associated.
// Created by:  Gary Howard
// History:     01/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

iu_search = au_search


end subroutine

public function long of_save_criteria (long al_reportconfigid, long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_criteria()
//	Arguments:  al_reportconfigid 	- The report configuration id
//					al_userid				- The user id for the report
//	Overview:   This will save the criteria for this report and user id (This is the normal case)
//	Created by:	Blake Doerr
//	History: 	7/7/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the report default id for this saved criteria
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_save_criteria(al_reportconfigid, al_userid, '')
end function

public function long of_save_criteria (long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_criteria()
//	Arguments:  al_reportconfigid 	- The report configuration id
//	Overview:   This will save the criteria for this report without a user id (Used for things like ad hoc batch reporting)
//	Created by:	Blake Doerr
//	History: 	7/7/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_userid

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the user to null
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_userid)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the report default id for this saved criteria
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_save_criteria(al_reportconfigid, ll_userid)
end function

public function long of_save_criteria (long al_reportconfigid, long al_userid, string as_custom_criteria_name);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_criteria()
//	Arguments:  al_reportconfigid 	- The report configuration id
//					al_userid				- The user id for the report
//	Overview:   This will save the criteria for this report and user id (This is the normal case)
//	Created by:	Blake Doerr
//	History: 	7/7/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If Not IsValid(in_report_criteria_default_engine) Then
	in_report_criteria_default_engine = Create n_report_criteria_default_engine
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the report default id for this saved criteria
//-----------------------------------------------------------------------------------------------------------------------------------
Return in_report_criteria_default_engine.of_save_defaults(This, al_reportconfigid, al_userid, as_custom_criteria_name)
end function

public subroutine of_retrieve ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_retrieve()
// Arguments:   none
// Overview:    retrieve the report
// Created by:  Jake Pratt
// History:     01/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

dw_report.retrieve()

end subroutine

public function long of_save_criteria ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_criteria()
//	Arguments:  al_reportconfigid 	- The report configuration id
//	Overview:   This will save the criteria for this report without a user id (Used for things like ad hoc batch reporting)
//	Created by:	Blake Doerr
//	History: 	7/7/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_reportconfigid

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the user to null
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_reportconfigid)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the report default id for this saved criteria
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_save_criteria(ll_reportconfigid)
end function

public subroutine of_init (datawindow adw_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_init()
// Arguments:   dw_data - Reference to the reporting datawindow
// Overview:    DocumentScriptFunctionality
// Created by:  Jake Pratt
// History:     01/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


dw_report 	= adw_data


end subroutine

public subroutine of_init (u_dynamic_gui_report_adapter au_dynamic_gui_report_adapter);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_init()
// Arguments:   au_composite_report - Reference to the composite report object
// Overview:    Set a pointer to the search object with which this object is associated.
// Created by:  Gary Howard
// History:     01/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

iu_dynamic_gui_report_adapter = au_dynamic_gui_report_adapter


end subroutine

public function boolean of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_validate()
// Arguments:   
// Overview:    Stub function to validate that everything was entered correctly
//					 before retrieving
// Created by:  Lynn Reiners
// History:     05/09/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return True
end function

public function boolean of_validate_dates ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate_dates
//	Arguments:  none
//	Overview:   Validates that all dates in the criteria datawindow are between 1/1/1980 and 12/31/2076
//	Created by:	edreyer
//	History: 	03/26/2002 - First Created RAID 25759, 25764
//-----------------------------------------------------------------------------------------------------------------------------------


string ls_datatype
long ll_loop
datetime ldt_date
long i
long ll_controlindex
DataWindow ldw_datawindow

For ll_controlindex = 1 To UpperBound(This.Control[])
	If Not IsValid(This.Control[ll_controlindex]) Then Continue
	If This.Control[ll_controlindex].TypeOf() <> Datawindow! Then Continue
		ldw_datawindow = This.Control[ll_controlindex]

      if ldw_datawindow.rowcount() < 1 then
			Continue
		end if
		
      i = long(ldw_datawindow.describe("DataWindow.Column.Count"))

      for ll_loop = 1 to i
          ls_datatype = left(lower(ldw_datawindow.describe("#"+ string(ll_loop) +".coltype")),4)
          if ls_datatype = 'date' then

              ldt_date = ldw_datawindow.getitemdatetime(1, ll_loop)

              if date(ldt_date) > 2076-12-31 or date(ldt_date) < 1980-01-01  then 
                  ldw_datawindow.setcolumn(ll_loop)
                  ldw_datawindow.setfocus()				
                  gn_globals.in_messagebox.of_messagebox_validation('This date must be in the range ' + string(1980-01-01)  + ' to ' + string(2076-12-31))
                  return false
              end if

          end if
     	
      NEXT

Next


return true
end function

public subroutine of_restore_saved_criteria (long al_reportconfigid, long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_restore_saved_criteria()
//	Arguments:  al_reportdefaultid 	- The report default id
//	Overview:   This will restore a criteria using a specific report default id
//	Created by:	Blake Doerr
//	History: 	7/7/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_restore_saved_criteria(al_reportconfigid, al_userid, '')
end subroutine

public subroutine of_restore_saved_criteria (long al_reportconfigid, long al_userid, string as_custom_criteria_name);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_restore_saved_criteria()
//	Arguments:  al_reportconfigid 			- The report config id
//					al_userid						- The user id
//					as_custom_criteria_name		- The custom name for the criteria
//	Overview:   This will restore a criteria using a specific report default id
//	Created by:	Blake Doerr
//	History: 	7/7/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the object if it isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(in_report_criteria_default_engine) Then
	in_report_criteria_default_engine = Create n_report_criteria_default_engine
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Store these instance variables
//-----------------------------------------------------------------------------------------------------------------------------------
il_reportconfigid = al_reportconfigid
il_userid			= al_userid

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the report default id for this saved criteria
//-----------------------------------------------------------------------------------------------------------------------------------
in_report_criteria_default_engine.of_restore_defaults(This, al_reportconfigid, al_userid, as_custom_criteria_name)

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure to show the dynamic criteria
//-----------------------------------------------------------------------------------------------------------------------------------
If in_report_criteria_default_engine.of_isdynamiccriteria() Then
	If ib_AllowDynamicCriteria And Not ib_ShowDynamicCriteria Then
		ib_ShowDynamicCriteria = True
		This.TriggerEvent('resize')
		This.TriggerEvent('ue_resize')
	End If
End If
end subroutine

public subroutine of_restore_saved_criteria (long al_reportdefaultid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_restore_saved_criteria()
//	Arguments:  al_reportdefaultid 	- The report default id
//	Overview:   This will restore a criteria using a specific report default id
//	Created by:	Blake Doerr
//	History: 	7/7/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If Not IsValid(in_report_criteria_default_engine) Then
	in_report_criteria_default_engine = Create n_report_criteria_default_engine
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the report default id for this saved criteria
//-----------------------------------------------------------------------------------------------------------------------------------
in_report_criteria_default_engine.of_restore_defaults(This, al_reportdefaultid)

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure to show the dynamic criteria
//-----------------------------------------------------------------------------------------------------------------------------------
If in_report_criteria_default_engine.of_isdynamiccriteria() Then
	If ib_AllowDynamicCriteria And Not ib_ShowDynamicCriteria Then
		ib_ShowDynamicCriteria = True
		THIS.TriggerEvent('resize')
	End If
End If
end subroutine

public subroutine of_set_batch_mode (boolean ab_batchmode);ib_batchmode = ab_batchmode
end subroutine

public subroutine of_auto_retrieve ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_retrieve()
// Arguments:   none
// Overview:    retrieve the report
// Created by:  Jake Pratt
// History:     01/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If This.of_validate() Then
	This.of_retrieve()
End If

end subroutine

public function string of_set_data (string as_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_data	- The || delimited string of data for the filter
//	Overview:   This will set the data into the filter as a string, this is initially for web reporting
//	Created by:	Blake Doerr
//	History: 	10/6/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_column
Long		ll_columncount
Double	ldble_null
String	ls_columnname[]
String	ls_values[]
String	ls_datepart
String	ls_null
String	ls_timepart
String	ls_column_name[]
SetNull(ldble_null)
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions	ln_string_functions
Datawindow				ldw_datawindow
Datawindow				ldw_nullobject

For ll_index = 1 To UpperBound(Control[])
	If Not IsValid(Control[ll_index]) Then Continue
	If Not Control[ll_index].TypeOf() = Datawindow! Then Continue
	
	ldw_datawindow = Control[ll_index]
	If ldw_datawindow.DataObject = 'd_custom_criteria_blank' Then
		ldw_datawindow = ldw_nullobject
		Continue
	End If
Next

If Not IsValid(ldw_datawindow) Then Return 'Error:  Could not find a valid datawindow on the criteria object in order to set the data'

ll_columncount = Long(ldw_datawindow.Describe("Datawindow.Column.Count"))

For ll_index = 1 To ll_columncount
	ls_column_name[ll_index] = ldw_datawindow.Describe("#" + String(ll_index) + ".Name")
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the arguments into a column/value string
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_arguments(as_data, '||', ls_columnname[], ls_values[])

For ll_index = 1 To Min(UpperBound(ls_columnname[]), UpperBound(ls_values[]))
	//gn_globals.in_string_functions.of_replace_all(ls_values[ll_index], '&eq;', '=')
	gn_globals.in_string_functions.of_replace_all(ls_values[ll_index], '&eq;', '=')
	
	For ll_column = 1 To UpperBound(ls_column_name[])
		If Right(ls_columnname[ll_index], 2) = '_0' Then ls_columnname[ll_index] = Left(ls_columnname[ll_index], Len(ls_columnname[ll_index]) - 2)
		If Lower(Trim(ls_columnname[ll_index])) <> Lower(Trim(ls_column_name[ll_column])) Then Continue
			
		//----------------------------------------------------------------------------------------------------------------------------------
		// Set the data into the column based on what the column datatype is.  If the column doesn't exist, nothing will happen.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case Lower(Left(ldw_datawindow.Describe(ls_columnname[ll_index] + '.ColType'), 4))
			Case 'numb', 'long', 'deci'
				If Trim(ls_values[ll_index]) = '' Then
					ldw_datawindow.SetItem(1, ls_columnname[ll_index], ldble_null)
					If IsNumber(ldw_datawindow.Describe(ls_columnname[ll_index] + '_multi.ID')) Then ldw_datawindow.SetItem(1, ls_columnname[ll_index] + '_multi', ls_null)
				ElseIf IsNumber(ls_values[ll_index]) Then
					ldw_datawindow.SetItem(1, ls_columnname[ll_index], Dec(ls_values[ll_index]))
					If IsNumber(ldw_datawindow.Describe(ls_columnname[ll_index] + '_multi.ID')) And Pos(Lower(as_data), ls_columnname[ll_index] + '_multi') = 0 Then ldw_datawindow.SetItem(1, ls_columnname[ll_index] + '_multi', ls_values[ll_index])
				End If
			Case 'date'
				ls_datepart = Trim(Left(ls_values[ll_index], Pos(ls_values[ll_index], ' ')))
				If Pos(ls_values[ll_index], ' ') > 0 Then
					ls_timepart = Trim(Mid(ls_values[ll_index], Pos(ls_values[ll_index], ' '), 100))
				End If
				
				If IsDate(ls_datepart) Then
					If Len(ls_timepart) > 0 Then
						If IsTime(ls_timepart) Then
							ldw_datawindow.SetItem(1, ls_columnname[ll_index], DateTime(Date(ls_datepart), Time(ls_timepart)))
						Else
							ldw_datawindow.SetItem(1, ls_columnname[ll_index], Date(ls_datepart))
						End If
					Else
						ldw_datawindow.SetItem(1, ls_columnname[ll_index], Date(ls_datepart))		
					End If
				End If

				If IsNumber(ldw_datawindow.Describe(ls_columnname[ll_index] + '_multi.ID')) And Pos(Lower(as_data), ls_columnname[ll_index] + '_multi') = 0 Then ldw_datawindow.SetItem(1, ls_columnname[ll_index] + '_multi', ls_values[ll_index])

			Case 'char'
				ldw_datawindow.SetItem(1, ls_columnname[ll_index], ls_values[ll_index])
				If IsNumber(ldw_datawindow.Describe(ls_columnname[ll_index] + '_multi.ID')) And Pos(Lower(as_data), ls_columnname[ll_index] + '_multi') = 0 Then ldw_datawindow.SetItem(1, ls_columnname[ll_index] + '_multi', ls_values[ll_index])
		End Choose
	Next
Next

Return ''
end function

public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will build the menu for the criteria object, extend this function to add menu items</Description>
<Arguments>
	<Argument Name="an_menu_dynamic">The nonvisual dynamic menu object</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

String	ls_views[]
Long	ll_index

//----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('&Reset Criteria', 'menucommand', 'resetcriteria')
If Not ib_batchmode Then an_menu_dynamic.of_add_item('&Create Custom Report Title', 'menucommand', 'createcustomtitle')
If ib_AllowDynamicCriteria And Not ib_batchmode Then
	an_menu_dynamic.of_add_item('-', '', '')
	an_menu_dynamic.of_add_item('&Show Custom Report Criteria', 'menucommand', 'createcustomcriteria').Checked = ib_ShowDynamicCriteria
End If


If IsValid(in_report_criteria_default_engine) And Not IsNull(il_reportconfigid) And Not IsNull(il_userid) Then
	in_report_criteria_default_engine.of_init(This, il_reportconfigid, il_userid, 'Criteria')
	in_report_criteria_default_engine.of_get_views(ls_views[], il_reportconfigid, il_userid)
	If Not ib_batchmode Then an_menu_dynamic.of_add_item('&Save View As...', 'save view as', '', in_report_criteria_default_engine)	

	If UpperBound(ls_views[]) > 0 Then
		an_menu_dynamic.of_add_item('-', '', '')
		
		For ll_index = 1 To UpperBound(ls_views[])
			an_menu_dynamic.of_add_item(ls_views[ll_index], 'restore view', ls_views[ll_index], in_report_criteria_default_engine)
		Next
	End If
End If

If Not ib_batchmode Then an_menu_dynamic.of_add_item('-', '', '')
If Not ib_batchmode Then an_menu_dynamic.of_add_item('&Export Criteria View To File..', 'menucommand', 'export criteria')	
If Not ib_batchmode Then an_menu_dynamic.of_add_item('&Import Criteria View From File...', 'menucommand', 'import criteria')	

If Not ib_batchmode Then an_menu_dynamic.of_add_item('-', '', '')
If Not ib_batchmode Then an_menu_dynamic.of_add_item('&Manage Criteria Views', 'menucommand', 'manage criteria views')	
end subroutine

public subroutine of_save_state ();
end subroutine

public subroutine of_restore_state ();
end subroutine

event constructor;/*<Abstract>----------------------------------------------------------------------------------------------------
This is the base object for all report criteria objects that will be built.  This is basically an empty canvas for you
to create the GUI that will be presented to the user.  We recommend that you use datawindows to present the GUI rather than
the other PowerBuilder controls because datawindows will more easily take advantage of the object library.  In fact, you
should probably be using u_criteria_search because it will have a datawindow with the most common services already loaded for you.
There are a few functions that are provided for you to extend and add your own code.
</Abstract>----------------------------------------------------------------------------------------------------*/


//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   Instructions for Use
// Created by: Jake Pratt
// History:    01/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------
// The following functions are available
// 	
//		of_proc()				- Code your setup procedures
//									  here.
//		of_validate				- Validate that criteria was entered correctly
//									  before retrieving.
//		of_retrieve()			- If you need to use criteria
//									  you should code your data collection		
//									  and retrieval here.
//		of_auto_retrieve()	- You should code a retreive here using the
//									  the defaults.
//-----------------------------------------------------------

This.Event ue_refreshtheme()
end event

on uo_report_criteria.create
this.sle_customtitle=create sle_customtitle
this.Control[]={this.sle_customtitle}
end on

on uo_report_criteria.destroy
destroy(this.sle_customtitle)
end on

event rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      rbuttondown
//	Overrides:  No
//	Arguments:	
//	Overview:   Redirect this to the ue_showmenu event
//	Created by: Blake Doerr
//	History:    8.23.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.Event ue_showmenu()
end event

event destructor;If IsValid(in_report_criteria_default_engine) Then Destroy in_report_criteria_default_engine
end event

type sle_customtitle from singlelineedit within uo_report_criteria
boolean visible = false
integer x = 50
integer y = 28
integer width = 763
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

