$PBExportHeader$n_datawindow_formatting_service.sru
forward
global type n_datawindow_formatting_service from nonvisualobject
end type
end forward

global type n_datawindow_formatting_service from nonvisualobject
event type string ue_notify ( string as_message,  any aany_argument )
end type
global n_datawindow_formatting_service n_datawindow_formatting_service

type variables
Protected:
	n_datawindow_formatting_service in_datawindow_formatting_service_dynamic_criteria
	PowerObject idw_data
	Boolean	ib_hassubscribed = False
	Boolean	ib_ThisIsDynamicCriteriaBuilder = False
	Boolean	ib_WeAreRestoringAView = False
	Boolean	ib_batchmode = False
	Long		il_dddw_all_data_column	= -100
	String 	is_ddlb_all_data_column = '@'
	Long		il_DynamicCriteriaRowHeight	= 85
	String	is_computedfielderrors[]
	String	is_computedfieldexpression[]
end variables

forward prototypes
public function string of_get_datawindow_syntax (string as_tablename, string as_qualifier)
public function long of_reretrieve ()
public function boolean of_get_isdynamiccriteria ()
public subroutine of_set_isdynamiccriteria (boolean ab_thisisdynamiccriteriabuilder)
public function string of_add_external_column (string as_columnname, string as_dbname, string as_headertext, datastore ads_datasource)
public function boolean of_find_column_to_copy (ref string as_columnname, ref string as_columnheader)
public function string of_move_criteria_column (string as_columnname, boolean ab_movedown)
public function string of_create_column (string as_computed_field_name, string as_computed_field_headername, string as_computed_field_headertext, string as_computed_field_expression, string as_computed_field_datatype)
public function string of_delete_criteria_column (string as_columnname)
public subroutine of_init (powerobject adw_data)
public subroutine of_delete_column (string as_columnname)
public function string of_delete_external_column (string as_columnname)
public function powerobject of_get_datawindow ()
public subroutine of_create_column ()
public subroutine of_recreate_view (n_bag an_bag, boolean ab_firsttime)
public subroutine of_set_source_formatting_service (nonvisualobject an_service)
public function string of_add_criteria_column (string as_columnname, string as_dbname, string as_headertext, datastore ads_datasource, string as_criteria_style)
public function string of_add_external_column (string as_columnname, string as_dbname, string as_headertext, datastore ads_datasource, boolean ab_uomconversion, string as_uominit)
protected function long of_find_position ()
public function string of_add_external_column (string as_columnname, string as_dbname, string as_headertext, datastore ads_datasource, boolean ab_uomconversion, string as_uominit, boolean ab_columnexistsindatawindowtable)
public subroutine of_get_dynamic_criteria (ref string as_criteria_arguments, ref string as_criteria_values)
public subroutine of_init_criteria_datawindow ()
public subroutine of_set_batch_mode (boolean ab_batchmode)
public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, string as_columnname, boolean ab_iscolumn, boolean ab_iscomputedfield)
public function long of_sqlpreview (sqlpreviewfunction request, sqlpreviewtype sqltype, ref string sqlsyntax, dwbuffer buffer, long row)
public function string of_transpose_datawindow_syntax (datastore ads_source, string as_transposeinit)
end prototypes

event type string ue_notify(string as_message, any aany_argument);//----------------------------------------------------------------------------------------------------------------------------------
// Event:        ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//		aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_return
Long ll_return
n_bag ln_bag
NonvisualObject ln_nonvisual_window_opener
Datawindow	ldw_datawindow
Datastore	lds_datastore

Choose Case Lower(Trim(as_message))
	Case 'format', 'format response'
		ln_bag = Create n_bag
		ln_bag.of_set('datasource', idw_data)
		ln_bag.of_set('n_datawindow_formatting_service', This)
		ln_bag.of_set('object', String(aany_argument))
	
		ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
		Choose Case Lower(Trim(as_message))
			Case 'format response'
				ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_formatting_service_response', ln_bag)
			Case Else
				ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_formatting_service', ln_bag)
		End Choose
		Destroy ln_nonvisual_window_opener

	Case 'print dialog'
		ln_bag = Create n_bag
		ln_bag.of_set('datasource', idw_data)
		ln_bag.of_set('n_datawindow_formatting_service', This)
		ln_bag.of_set('object', 'datawindow')
	
		ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
		ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_print_dialog', ln_bag)
		Destroy ln_nonvisual_window_opener

		If IsValid(ln_bag) Then Return '1'

	//----------------------------------------------------------------------------------------------------------------------------------
	// Scrolling Messages
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'nextpage'
		idw_data.Dynamic Modify("DataWindow.Print.Preview=Yes")
		idw_data.Dynamic ScrollNextPage()
	Case 'previouspage'
		idw_data.Dynamic Modify("DataWindow.Print.Preview=Yes")
		idw_data.Dynamic ScrollPriorPage()
	Case 'firstpage'
		idw_data.Dynamic Modify("DataWindow.Print.Preview=Yes")
		If idw_data.Dynamic rowcount() > 0 then
			idw_data.Dynamic scrolltorow(1)
		End IF 
	Case 'lastpage'
		idw_data.Dynamic Modify("DataWindow.Print.Preview=Yes")
		If idw_data.Dynamic rowCount() > 0 Then
			idw_data.Dynamic ScrollToRow(idw_data.Dynamic RowCount())
		End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// Print Preview Messages
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'print preview'
		ls_return = Lower(Trim(idw_data.Dynamic Describe("DataWindow.Print.Preview")))
		
		If ls_return = 'yes' Then
			idw_data.Dynamic Modify("DataWindow.Print.Preview=No")
		Else
			idw_data.Dynamic Modify("DataWindow.Print.Preview=Yes")
		End If
		idw_data.event Dynamic ue_notify('pagenumber',aany_argument)
		
	Case 'zoomin', 'zoomout'
		
		If (Lower(Trim(idw_data.Dynamic Describe("DataWindow.Print.Preview"))) = 'yes') Then
			//-----------------------------------------------------
			// Limit the Zoom from 1 to 1000
			//-----------------------------------------------------
			ll_return = Long(idw_data.Dynamic Describe("DataWindow.Print.Preview.Zoom"))
	
			If Lower(Trim(as_message)) = 'zoomin' Then
				if ll_return > 989 then return ''
				ll_return = ll_return + 10
			Else
				if ll_return < 11 then return ''
				ll_return = ll_return - 10
			End If
			
			idw_data.Dynamic Modify("DataWindow.Print.Preview.Zoom=" + string(ll_return))
		Else
			//-----------------------------------------------------
			// Limit the Zoom from 1 to 1000
			//-----------------------------------------------------
			ll_return = Long(idw_data.Dynamic Describe("DataWindow.Zoom"))
	
			If Lower(Trim(as_message)) = 'zoomin' Then
				if ll_return > 989 then return ''
				ll_return = ll_return + 10
			Else
				if ll_return < 11 then return ''
				ll_return = ll_return - 10
			End If
			
			idw_data.Dynamic Modify("DataWindow.Zoom=" + string(ll_return))
		End If
	Case 'rulers'
		//If Trim(idw_data.DataObject) = '' then return ''

		//-----------------------------------------------------
		// Show or Hide the Rulers
		//-----------------------------------------------------
		ls_return = Lower(Trim(idw_data.Dynamic Describe("DataWindow.Print.Preview.Rulers")))

		if ls_return = 'yes' then
			ls_return = idw_data.Dynamic Modify("DataWindow.Print.Preview.Rulers=No")
		else
			ls_return = idw_data.Dynamic Modify("DataWindow.Print.Preview.Rulers=Yes")
		end if

	//-----------------------------------------------------
	// Rich Text Menu Options
	//-----------------------------------------------------
	Case	'showtoolbar'
		ls_return = Lower(Trim(idw_data.Dynamic Describe("DataWindow.RichText.Toolbar")))

		if ls_return = 'yes' then
			ls_return = idw_data.Dynamic Modify("DataWindow.RichText.Toolbar=No")
		else
			ls_return = idw_data.Dynamic Modify("DataWindow.RichText.Toolbar=Yes")
		end if
	Case	'showheaderfooter'
		idw_data.Dynamic ShowHeadFoot(Lower(Trim(idw_data.Dynamic Describe("Datawindow.RichText.HeaderFooter"))) = 'yes')

	Case	'showtabbar'
		ls_return = Lower(Trim(idw_data.Dynamic Describe("DataWindow.RichText.TabBar")))

		if ls_return = 'yes' then
			ls_return = idw_data.Dynamic Modify("DataWindow.RichText.TabBar=No")
		else
			ls_return = idw_data.Dynamic Modify("DataWindow.RichText.TabBar=Yes")
		end if
		
	Case 'undolastchange'
		idw_data.Dynamic Undo()
		
	Case 'create column'
		This.of_create_column()
	Case 'delete column'
		This.of_delete_column(String(aany_argument))
	
	Case 'add external column'
		//------------------------------------------------------------------------------------
		// Open the window to name the view
		//------------------------------------------------------------------------------------
		ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
		ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_external_column_selection', This)
		Destroy ln_nonvisual_window_opener

	Case 'delete external column'
		If Not ib_ThisIsDynamicCriteriaBuilder Then
			//If gn_globals.in_messagebox.of_messagebox_question ('This will clear all the data from the report in order to remove the external column, is this ok', OKCancel!, 1) = 1 Then
				This.of_delete_external_column(String(aany_argument))
			//End If
		Else
			This.of_delete_criteria_column(String(aany_argument))
		End If
		
	Case 'delete all criteria'
		Choose Case idw_data.TypeOf()
			Case Datawindow!
				ldw_datawindow = idw_data
				ldw_datawindow.DataObject = ldw_datawindow.DataObject
				ldw_datawindow.Event Dynamic ue_refreshtheme()
			Case Datastore!
				lds_datastore = idw_data
				lds_datastore.DataObject = lds_datastore.DataObject
		End Choose				
		
	Case 'move column down'
		This.of_move_criteria_column(String(aany_argument), True)
		
	Case 'move column up'
		This.of_move_criteria_column(String(aany_argument), False)
		
	Case 'recreate view - formatting'
		This.of_recreate_view(Message.PowerObjectParm, True)
	Case 'recreate view - formatting 2'
		This.of_recreate_view(Message.PowerObjectParm, False)
	Case 'dropdowns refreshed'
		///
	Case 'criteria datawindow recreated'
		This.of_init_criteria_datawindow()

End Choose
Return ''

end event

public function string of_get_datawindow_syntax (string as_tablename, string as_qualifier);Long		ll_index
string 	ls_select
String	ls_syntax
String	ls_error
String	ls_columnsyntax
String	ls_columnname[]
String	ls_original_columnname[]
String	ls_columntype[]
String	ls_columndescription[]

Datastore 				lds_datastore
Datastore				ds_gc_syntax
//n_string_functions	ln_string

//------------------------------------------------------------------------------
// Get the list of variables we need to create a dw for.
//------------------------------------------------------------------------------
lds_datastore = create datastore
lds_datastore.dataobject = 'dddw_table_generalconfiguration'
lds_datastore.settransobject(sqlca)
If lds_datastore.retrieve(as_qualifier) <= 0 Then
	Destroy lds_datastore
	Return ''
End If

ls_columnname[]				= lds_datastore.Object.GnrlCnfgQlfr.Primary
ls_columntype[]				= lds_datastore.Object.GnrlCnfgMulti.Primary
ls_original_columnname[]	= lds_datastore.Object.GnrlCnfgQlfr.Primary
ls_columndescription[]		= lds_datastore.Object.GnrlCnfgQlfr.Primary

//------------------------------------------------------------------------------
// Loop through and create the select statement.
//------------------------------------------------------------------------------
For ll_index = 1 to UpperBound(ls_columnname[])
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],' ','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],'\','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],'/','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],':','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],',','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],'=','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],'-','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],'_','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],'.','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],'&','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_index],'%','')

	Choose Case Lower(Trim(ls_columntype[ll_index]))
		Case 'mm/dd/yyyy'
			ls_select  = ls_select + ls_columnname[ll_index] + ' = Convert(SmallDateTime, Null),'
		Case Else
			If Pos(ls_columntype[ll_index], '#') > 0 Then
				ls_select  = ls_select + ls_columnname[ll_index] + ' = Convert(Float, Null),'
			ElseIf Pos(Lower(ls_columntype[ll_index]), 'id') > 0 Or Pos(Lower(ls_columntype[ll_index]), 'uom') > 0 Then
				ls_select  = ls_select + ls_columnname[ll_index] + ' = Convert(Int, Null),'
			Else
				ls_select  = ls_select + ls_columnname[ll_index] + ' = Convert(VarChar(4099), Null),'
			End If
	End Choose
Next

//------------------------------------------------------------------------------
// Now create a syntax that we can use to display the dataset we have created.
//------------------------------------------------------------------------------
ls_select = 'Select ' + Left(ls_select, Len(ls_select) - 1) + ' From GeneralConfiguration Where 1=2'
ls_syntax = SQLCA.syntaxfromsql(ls_select, "", ls_error)

ds_gc_syntax = create datastore
ds_gc_syntax.create(ls_syntax)


//------------------------------------------------------------------------------
// Since we are going to re-create everything, destroy all of the gui.
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Now create the GUI Again.
//------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_columnname[])
	ls_syntax = "destroy " + ls_columnname[ll_index]
	ls_error = ds_gc_syntax.Modify(ls_syntax)

	ls_syntax = "destroy " + ls_columnname[ll_index] + '_t'
	ls_error = ds_gc_syntax.Modify(ls_syntax)

	ls_syntax = 'text(band=detail alignment="1" text="' + ls_original_columnname[ll_index] + '" border="0" color="0" x="571" y="8" height="56" width="250"  name=' + ls_columnname[ll_index] + '_srt font.face="Tahoma" font.height="-8" font.weight="700" font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127")'
	ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)
	
	Choose Case ls_columntype[ll_index]
		case 'hh:mm'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=160 border="5" color="0" x="613" y="8" height="52" width="635" name=' + ls_columnname[ll_index] + ' format="[General]"  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)
			
		case 'mm/dd/yyyy'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=170 border="5" color="0" x="613" y="8" height="52" width="635" name=' + ls_columnname[ll_index] + ' format="[shortdate] [time]"  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)
			
		case '##0.000000'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="1" tabsequence=100 border="5" color="0" x="613" y="8" height="52" width="635" name=' + ls_columnname[ll_index] + ' format="##0.000000"  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)
			
		case 'X'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=90 border="5" color="0" x="613" y="8" height="52" width="635" name=' + ls_columnname[ll_index] + ' font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)
			
		case '########0'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="1" tabsequence=100 border="5" color="0" x="613" y="8" height="52" width="635" name=' + ls_columnname[ll_index] + ' format="########0"  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)
			
		case 'y/n'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + ls_columnname[ll_index] + ' dddw.name=dddw_deal_yes_no dddw.displaycolumn=display dddw.datacolumn=value dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=no dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)

		case 'Term.TrmID'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + ls_columnname[ll_index] + ' dddw.name=dddw_trmabbrvtn dddw.displaycolumn=trmabbrvtn dddw.datacolumn=trmid dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=no dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)
	
		case 'BusinessAssociate.BAID'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + ls_columnname[ll_index] + ' dddw.name=dddw_banme dddw.displaycolumn=banme dddw.datacolumn=baid dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=no dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)

		case 'Product.PrdctID'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + ls_columnname[ll_index] + ' dddw.name=dddw_prdctabbv_by_prdctordr dddw.displaycolumn=prdctabbv dddw.datacolumn=prdctid dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=no dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)
			
		case 'Locale.LcleID'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + ls_columnname[ll_index] + ' dddw.name=dddw_lclenme dddw.displaycolumn=lclenme dddw.datacolumn=lcleid dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=no dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)

		case 'UnitOfMeasure.UOM'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + ls_columnname[ll_index] + ' dddw.name=dddw_uom dddw.displaycolumn=uomdesc dddw.datacolumn=uom dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=no dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)

		case '########0.00'
			ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="1" tabsequence=110 border="5" color="0" x="613" y="8" height="52" width="635" name=' + ls_columnname[ll_index] + ' format="########0.00"  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
			ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)
		case else
			// This section handles dynamic dddw's
			if lower(left(ls_columntype[ll_index],4)) = 'dddw' then 
				string s_array[]
				gn_globals.in_string_functions.of_parse_string(ls_columntype[ll_index],'.',s_array)
				if upperbound(s_array) = 4 then 
					ls_syntax = 'column(band=detail id=' + string (ll_index)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + ls_columnname[ll_index] + ' dddw.name=' + s_array[2] + ' dddw.displaycolumn=' + s_array[3] + ' dddw.datacolumn=' + s_array[4] + ' dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=no dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
					ls_error = ds_gc_syntax.Modify("Create " + ls_syntax)				
				end if
			end if
	end choose		
Next

ls_syntax = ds_gc_syntax.Describe("DataWindow.Syntax")

For ll_index = 1 To UpperBound(ls_columnname[])
	If ls_columnname[ll_index] = ls_original_columnname[ll_index] Then Continue
	gn_globals.in_string_functions.of_replace_all(ls_syntax,'dbname="' + ls_columnname[ll_index] + '"','dbname="' + ls_original_columnname[ll_index] + '"')
Next
	
gn_globals.in_string_functions.of_replace_all(ls_syntax,'dbname="','dbname="GeneralConfiguration.')

return ls_syntax

end function

public function long of_reretrieve ();Return idw_data.Dynamic of_reretrieve()
end function

public function boolean of_get_isdynamiccriteria ();Return ib_ThisIsDynamicCriteriaBuilder
end function

public subroutine of_set_isdynamiccriteria (boolean ab_thisisdynamiccriteriabuilder);Datawindow ldw_report
NonVisualObject ln_service
Any lany_return

ib_ThisIsDynamicCriteriaBuilder = ab_ThisIsDynamicCriteriaBuilder

If Not ib_ThisIsDynamicCriteriaBuilder Then Return

lany_return = idw_data.Dynamic Event ue_get_report_datawindow()

If Not IsNull(lany_return) Then ldw_report = lany_return

If Not IsValid(ldw_report) Then Return

ln_service = ldw_report.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')
	
If Not IsValid(ln_service) Then Return

ln_service.Dynamic of_set_source_formatting_service(This)
end subroutine

public function string of_add_external_column (string as_columnname, string as_dbname, string as_headertext, datastore ads_datasource);Return This.of_add_external_column(as_columnname, as_dbname, as_headertext, ads_datasource, False, '')
end function

public function boolean of_find_column_to_copy (ref string as_columnname, ref string as_columnheader);
//----------------------------------------------------------------------------------------------------------------------------------
// Determine the column to mimic
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_columnname
String	ls_columnheader
Long		ll_index
Long		ll_columncount
Long		ll_requirement_level	= 0
n_datawindow_tools ln_datawindow_tools

ln_datawindow_tools = Create n_datawindow_tools

ll_columncount = Long(idw_data.Dynamic Describe("Datawindow.Column.Count"))

Do While 1 = 1
	ll_requirement_level = ll_requirement_level + 1
	If ll_requirement_level >= 3 Then
		Destroy ln_datawindow_tools
		Return False
	End If

	For ll_index = 1 To ll_columncount
		If ll_requirement_level <= 1 Then
			Choose Case Lower(Trim(ln_datawindow_tools.of_get_editstyle(idw_data, ll_index)))
				Case 'dddw', 'ddlb'
				Case Else
					Continue
			End Choose
		End If
		
		If ll_requirement_level <= 2 Then
			If Long(idw_data.Dynamic Describe("#" + String(ll_index) + '.Visible')) <> 1 Then Continue
		End If
		
		ls_columnname = idw_data.Dynamic Describe("#" + String(ll_index) + '.Name')
		If Not IsNumber(idw_data.Dynamic Describe(ls_columnname + '_t.X')) And Not IsNumber(idw_data.Dynamic Describe(ls_columnname + '_srt.X')) Then Continue

		ls_columnheader 	= idw_data.Dynamic Describe(ls_columnname + '_srt.Name')
		If ls_columnheader = '!' Or ls_columnheader = '?' Then
			ls_columnheader 	= idw_data.Dynamic Describe(ls_columnname + '_t.Name')
		End If

		If ls_columnheader = '!' Or ls_columnheader = '?' Then Continue
		as_columnname 		= ls_columnname
		as_columnheader	= ls_columnheader
		Destroy ln_datawindow_tools
		Return True
	Next
Loop



	
Return True
end function

public function string of_move_criteria_column (string as_columnname, boolean ab_movedown);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_index_to_move_down
Long		ll_index_to_move_up
Long		ll_upperbound
String	ls_expression
String	ls_database_names
String	ls_ids
String	ls_columnnames
String	ls_columnname[]
String	ls_id[]
String	ls_empty[]
String	ls_dbname[]
String	ls_styles[]
String	ls_style
String	ls_temp_dbname
String	ls_temp_id
String	ls_temp_columnname
String	ls_temp_style
String	ls_column_to_move_up
String	ls_column_to_move_down
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools 	ln_datawindow_tools
//n_string_functions 	ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure we aren't going outside our boundaries by making this move
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_movedown Then
	If Long(idw_data.Dynamic Describe(as_columnname + '.Y')) + il_DynamicCriteriaRowHeight > Long(idw_data.Dynamic Describe("Datawindow.Detail.Height")) Then Return ''
Else
	If Long(idw_data.Dynamic Describe(as_columnname + '.Y')) < il_DynamicCriteriaRowHeight Then Return ''
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the init column
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the elements of the string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'dbname'))
ls_ids						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'ID'))
ls_columnnames				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Column'))
ls_style						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Style'))

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out each element into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_database_names, ',', ls_dbname[])
gn_globals.in_string_functions.of_parse_string(ls_ids, ',', ls_id[])
gn_globals.in_string_functions.of_parse_string(ls_columnnames, ',', ls_columnname[])
gn_globals.in_string_functions.of_parse_string(ls_style, ',', ls_styles[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the upperbound, make sure it's valid
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = Min(Min(Min(UpperBound(ls_dbname[]), UpperBound(ls_id[])), UpperBound(ls_columnname[])), UpperBound(ls_styles[]))
If ll_upperbound = 0 Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the column to move
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	If Lower(Trim(ls_columnname[ll_index])) = Lower(Trim(as_columnname)) Then
		If ab_movedown Then
			ll_index_to_move_down 	= ll_index
			ll_index_to_move_up 		= ll_index + 1
		Else
			ll_index_to_move_up 		= ll_index
			ll_index_to_move_down 	= ll_index - 1
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are any errors
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_index_to_move_down >= ll_upperbound Or ll_index_to_move_down <= 0 Then Return ''
If ll_index_to_move_up > ll_upperbound Or ll_index_to_move_up <= 1 Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column names into variables before we start moving the variables
//-----------------------------------------------------------------------------------------------------------------------------------
ls_column_to_move_up		= Trim(ls_columnname[ll_index_to_move_up])
ls_column_to_move_down	= Trim(ls_columnname[ll_index_to_move_down])

//-----------------------------------------------------------------------------------------------------------------------------------
// Put one set into temp variables
//-----------------------------------------------------------------------------------------------------------------------------------
ls_temp_dbname			= ls_dbname[ll_index_to_move_down]
ls_temp_id				= ls_id[ll_index_to_move_down]
ls_temp_columnname	= ls_columnname[ll_index_to_move_down]
ls_temp_style			= ls_styles[ll_index_to_move_down]

//-----------------------------------------------------------------------------------------------------------------------------------
// Reassign the down variables
//-----------------------------------------------------------------------------------------------------------------------------------
ls_dbname[ll_index_to_move_down]			= ls_dbname[ll_index_to_move_up]
ls_id[ll_index_to_move_down]				= ls_id[ll_index_to_move_up]
ls_columnname[ll_index_to_move_down]	= ls_columnname[ll_index_to_move_up]
ls_styles[ll_index_to_move_down]			= ls_styles[ll_index_to_move_up]

//-----------------------------------------------------------------------------------------------------------------------------------
// Reassign the up variables
//-----------------------------------------------------------------------------------------------------------------------------------
ls_dbname[ll_index_to_move_up]			= ls_temp_dbname
ls_id[ll_index_to_move_up]					= ls_temp_id
ls_columnname[ll_index_to_move_up]		= ls_temp_columnname
ls_styles[ll_index_to_move_up]			= ls_temp_style

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear out the init components
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= ''
ls_ids						= ''
ls_columnnames				= ''
ls_style						= ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Rebuild the init components
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_dbname[]), UpperBound(ls_id[]))
	ls_database_names = ls_database_names + ls_dbname[ll_index] + ','
	ls_ids				= ls_ids + ls_id[ll_index] + ','
	ls_columnnames		= ls_columnnames + ls_columnname[ll_index] + ','
	ls_style				= ls_style + ls_styles[ll_index] + ','
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Cut the commas off
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names = Left(ls_database_names, Len(ls_database_names) - 1)
ls_ids 				= Left(ls_ids, Len(ls_ids) - 1)
ls_columnnames		= Left(ls_columnnames, Len(ls_columnnames) - 1)
ls_style				= Left(ls_style, Len(ls_style) - 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the expression for the init field
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_set_expression(idw_data, 'AdditionalColumnsInit', 'dbname=' + ls_database_names + '||ID=' + ls_ids + '||Column=' + ls_columnnames + '||Style=' + ls_style)

//-----------------------------------------------------------------------------------------------------------------------------------
// Modify GUI Objects
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic Modify(ls_column_to_move_down + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_down + '.Y')) + il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_down + '_multi' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_down + '_multi' + '.Y')) + il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_down + '_second' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_down + '_second' + '.Y')) + il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_down + '_qualifier' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_down + '_qualifier' + '.Y')) + il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_down + '_applycriteria' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_down + '_applycriteria' + '.Y')) + il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_down + '_srt' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_down + '_srt' + '.Y')) + il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_down + '_prefix' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_down + '_prefix' + '.Y')) + il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_down + '_and' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_down + '_and' + '.Y')) + il_DynamicCriteriaRowHeight) + '~'')

idw_data.Dynamic Modify(ls_column_to_move_up + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_up + '.Y')) - il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_up + '_multi' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_up + '_multi' + '.Y')) - il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_up + '_second' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_up + '_second' + '.Y')) - il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_up + '_qualifier' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_up + '_qualifier' + '.Y')) - il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_up + '_applycriteria' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_up + '_applycriteria' + '.Y')) - il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_up + '_srt' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_up + '_srt' + '.Y')) - il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_up + '_prefix' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_up + '_prefix' + '.Y')) - il_DynamicCriteriaRowHeight) + '~'')
idw_data.Dynamic Modify(ls_column_to_move_up + '_and' + '.Y = ~'' + String(Long(idw_data.Dynamic Describe(ls_column_to_move_up + '_and' + '.Y')) - il_DynamicCriteriaRowHeight) + '~'')

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the Before View Saved message to clean up the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('Before View Saved', '', idw_data)

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the messages necessary to reinitialize the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('After View Restored', '', idw_data)
gn_globals.in_subscription_service.of_message('Visible Columns Changed', '', idw_data)
gn_globals.in_subscription_service.of_message('column added or removed', '', idw_data)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return success
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
Return ''
end function

public function string of_create_column (string as_computed_field_name, string as_computed_field_headername, string as_computed_field_headertext, string as_computed_field_expression, string as_computed_field_datatype);//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_x
String	ls_return
String	ls_modify
String	ls_alignment
String	ls_column_to_copy
String	ls_columnheader_to_copy
String	ls_new_computed_field_expression

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools	ln_datawindow_tools
//n_string_functions	ln_string_functions

//----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
If Not of_find_column_to_copy(ls_column_to_copy, ls_columnheader_to_copy) Then
	MessageBox('Error', 'Could not find column to copy formatting.')
	Return 'Error:  Could not find a column on the report to copy formatting for the new computed field'
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the computed field name
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_return = ln_datawindow_tools.of_set_expression(idw_data, as_computed_field_name, as_computed_field_expression, False)

//----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ln_datawindow_tools.of_IsComputedField(idw_data, as_computed_field_name) Or ls_return <> '' Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// Determine the computed field name
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_data.Dynamic Modify("Destroy " + as_computed_field_name)
	
	Choose Case Left(Lower(Trim(as_computed_field_datatype)), 4)
		Case 'date'
			ls_new_computed_field_expression = 'Date("1/1/1900") /*' + as_computed_field_expression + '*/'
		Case 'char'
			ls_new_computed_field_expression = '"" /*' + as_computed_field_expression + '*/'
		Case Else
			ls_new_computed_field_expression = '0 /*' + as_computed_field_expression + '*/'
	End Choose
	
	ls_return = ln_datawindow_tools.of_set_expression(idw_data, as_computed_field_name, ls_new_computed_field_expression, False)

	If Not ln_datawindow_tools.of_IsComputedField(idw_data, as_computed_field_name) Or ls_return <> '' Then
		idw_data.Dynamic Modify("Destroy " + as_computed_field_name)
		Return 'Error:  Could not create computed field with the Expression = "' + as_computed_field_expression + '" (' + ls_return + ')'
	Else
		is_computedfielderrors[UpperBound(is_computedfielderrors[]) + 1] 	= as_computed_field_name
		is_computedfieldexpression[UpperBound(is_computedfielderrors[])]	= as_computed_field_expression
	End If
End If

Destroy ln_datawindow_tools

If IsNumber(idw_data.Dynamic Describe(as_computed_field_headername + '.X')) Then
	Return ''
End If


//----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(idw_data.Dynamic Describe(as_computed_field_name + '.ColType')))
	Case 'number', 'long', 'real'
		ls_alignment = '1'
	Case Else
		ls_alignment = '0'
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Apply formatting to the computed field
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic Modify(as_computed_field_name + ".Alignment='" + ls_alignment + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Background.Color='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Background.Color") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Background.Mode='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Background.Mode") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Border='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Border") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Color='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Color") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.CharSet='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.CharSet") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.Face='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Face") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.Family='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Family") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.Height='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Height") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.Italic='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Italic") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.Pitch='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Pitch") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.Strikethrough='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Strikethrough") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.Underline='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Underline") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.Weight='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Weight") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Font.Width='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Width") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Height='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Height") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Width='400'")
idw_data.Dynamic Modify(as_computed_field_name + ".Y='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Y") + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Tag='Type=Computed'")

//----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(as_computed_field_headertext, "'", "~~'")
ls_modify = "create text(band=Header color='0' visible = '0' alignment='" + ls_alignment + "' border='0' height.autosize=No  moveable=0 resizeable=0 x='1' y='1' height='1' width='1' text='" + as_computed_field_headertext + "' name=" + as_computed_field_headername + " font.face='Tahoma' font.height='-8' font.weight='400' font.family='0' font.pitch='0' font.charset='0' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='0' background.color='553648127')"
ls_return = idw_data.Dynamic Modify(ls_modify)

//----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return <> '' Then
	Return 'Error:  Could not create text header for custom computed field (' + ls_return + ')'
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Apply formatting to the text field
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic Modify(as_computed_field_headername + ".Alignment='" + ls_alignment + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Background.Color='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Background.Color") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Background.Mode='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Background.Mode") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Border='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Border") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Color='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Color") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.CharSet='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.CharSet") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.Face='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Face") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.Family='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Family") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.Height='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Height") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.Italic='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Italic") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.Pitch='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Pitch") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.Strikethrough='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Strikethrough") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.Underline='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Underline") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.Weight='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Weight") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Font.Width='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Width") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Height='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Height") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Width='" + idw_data.Dynamic Describe(as_computed_field_name + ".Width") + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Y='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Y") + "'")

gn_globals.in_subscription_service.of_message('Before View Saved', idw_data, idw_data)

ll_x = This.of_find_position()
idw_data.Dynamic Modify(as_computed_field_name + ".X='" + String(ll_x) + "'")
idw_data.Dynamic Modify(as_computed_field_name + ".Visible='1'")

idw_data.Dynamic Modify(as_computed_field_headername + ".X='" + String(ll_x) + "'")
idw_data.Dynamic Modify(as_computed_field_headername + ".Visible='1'")

gn_globals.in_subscription_service.of_message('After View Restored', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('Visible Columns Changed', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('column added or removed', idw_data, idw_data)

Return ''
end function

public function string of_delete_criteria_column (string as_columnname);
//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_create_second_column = False
Boolean	lb_create_applycriteria_column = False
Boolean	lb_create_qualifier_column = False
Boolean	lb_found	= False
Long		ll_index
Long		ll_scrollposition
String	ls_criteria_style
String	ls_expression
String	ls_database_names
String	ls_syntax
String	ls_ids
String	ls_return
String	ls_columnnames
String	ls_columnname[]
String	ls_id[]
String	ls_empty[]
String	ls_dbname[]
String	ls_styles[]
String	ls_style

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools 	ln_datawindow_tools
//n_string_functions 	ln_string_functions
n_datawindow_syntax 	ln_datawindow_syntax
Datawindow				ldw_data
//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy GUI Objects
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic Modify("Destroy " + as_columnname)
idw_data.Dynamic Modify("Destroy " + as_columnname + '_multi')
idw_data.Dynamic Modify("Destroy " + as_columnname + '_second')
idw_data.Dynamic Modify("Destroy " + as_columnname + '_qualifier')
idw_data.Dynamic Modify("Destroy " + as_columnname + '_applycriteria')
idw_data.Dynamic Modify("Destroy " + as_columnname + '_srt')
idw_data.Dynamic Modify("Destroy " + as_columnname + '_prefix')
idw_data.Dynamic Modify("Destroy " + as_columnname + '_and')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the init column
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the elements of the string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'dbname'))
ls_ids						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'ID'))
ls_columnnames				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Column'))
ls_style						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Style'))

If idw_data.TypeOf() = Datawindow! Then
	ldw_data = idw_data
	ll_scrollposition 		= Long(ldw_data.Object.Datawindow.VerticalScrollPosition)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out each element into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_database_names, ',', ls_dbname[])
gn_globals.in_string_functions.of_parse_string(ls_ids, ',', ls_id[])
gn_globals.in_string_functions.of_parse_string(ls_columnnames, ',', ls_columnname[])
gn_globals.in_string_functions.of_parse_string(ls_style, ',', ls_styles[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Materialize the syntax and delete columns that are no longer needed
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_syntax = Create n_datawindow_syntax
ln_datawindow_syntax.of_set_datasource(idw_data)
ln_datawindow_syntax.of_delete_column(as_columnname)
ln_datawindow_syntax.of_delete_column(as_columnname + '_multi')
ln_datawindow_syntax.of_delete_column(as_columnname + '_second')
ln_datawindow_syntax.of_delete_column(as_columnname + '_qualifier')
ln_datawindow_syntax.of_delete_column(as_columnname + '_applycriteria')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the new syntax and apply it
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = ln_datawindow_syntax.of_get_syntax()
idw_data.Dynamic Reset()
ln_datawindow_tools.of_apply_syntax(idw_data, ls_syntax)

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear out the init components
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= ''
ls_ids						= ''
ls_columnnames				= ''
ls_style						= ''
lb_found 					= False


//-----------------------------------------------------------------------------------------------------------------------------------
// Rebuild the init components
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_dbname[]), UpperBound(ls_id[]))
	If Lower(Trim(ls_columnname[ll_index])) = Lower(Trim(as_columnname)) Then
		lb_found = True
		Continue
	End If
	
	ls_database_names = ls_database_names + ls_dbname[ll_index] + ','
	ls_ids				= ls_ids + ls_id[ll_index] + ','
	ls_columnnames		= ls_columnnames + ls_columnname[ll_index] + ','
	ls_style				= ls_style + ls_styles[ll_index] + ','
	If lb_found Then
		This.of_move_criteria_column(ls_columnname[ll_index], False)
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Cut the commas off
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names = Left(ls_database_names, Len(ls_database_names) - 1)
ls_ids 				= Left(ls_ids, Len(ls_ids) - 1)
ls_columnnames		= Left(ls_columnnames, Len(ls_columnnames) - 1)
ls_style				= Left(ls_style, Len(ls_style) - 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the expression for the init field
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_set_expression(idw_data, 'AdditionalColumnsInit', 'dbname=' + ls_database_names + '||ID=' + ls_ids + '||Column=' + ls_columnnames + '||Style=' + ls_style)

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy unneeded objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_syntax
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the label for the criteria
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic Modify("Datawindow.Detail.Height=" + String((UpperBound(ls_id[]) - 1) * il_DynamicCriteriaRowHeight + 4 + 75 + 4))

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the Before View Saved message to clean up the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('Before View Saved', idw_data, idw_data)

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the messages necessary to reinitialize the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('After View Restored', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('Visible Columns Changed', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('column added or removed', idw_data, idw_data)

This.of_init_criteria_datawindow()

If idw_data.TypeOf() = Datawindow! Then
	ldw_data = idw_data
	ldw_data.Object.DataWindow.VerticalScrollPosition = String(ll_scrollposition)
	ldw_data.SetRedraw(True)
End If

Return ''
end function

public subroutine of_init (powerobject adw_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  adw_data - The datawindow to format
//	Overview:   This will store a pointer to the datawindow
//	Created by:	Blake Doerr
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

idw_data = adw_data

If Not ib_hassubscribed Then
	ib_hassubscribed = True
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_subscribe(This, 'Recreate View - formatting', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Recreate View - formatting 2', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'dropdowns refreshed', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'criteria datawindow recreated', idw_data)
	End If
End If
end subroutine

public subroutine of_delete_column (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_delete_column()
//	Created by:	Blake Doerr
//	History: 	10/12/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------------------------------
// I'm not sure I have to do this
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('remove a column', as_columnname, idw_data)
gn_globals.in_subscription_service.of_message('Before View Saved', idw_data, idw_data)

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the computed field
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic Modify("Destroy " + as_columnname)
idw_data.Dynamic Modify("Destroy " + as_columnname + "_srt")

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the message so that the delete column is taken care of
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('After View Restored', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('Visible Columns Changed', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('column deleted', as_columnname, idw_data)


end subroutine

public function string of_delete_external_column (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_delete_external_column()
//	Created by:	Blake Doerr
//	History: 	10/12/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_found
Long		ll_id
Long		ll_index
Long		ll_scrollposition
Long		ll_conversion_columnid
String	ls_syntax
String	ls_expression
String	ls_database_names
String	ls_ids
String	ls_columnnames
String	ls_columnname[]
String	ls_id[]
String	ls_dbname[]
String	ls_conversion_columnname

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datawindow				ldw_data
n_datawindow_tools 	ln_datawindow_tools
//n_string_functions 	ln_string_functions
n_datawindow_syntax 	ln_datawindow_syntax
//n_uom_uominit			ln_uom_uominit

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the init column
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the elements of the string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'dbname'))
ls_ids						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'ID'))
ls_columnnames				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Column'))

If idw_data.TypeOf() = Datawindow! Then
	ldw_Data = idw_data
	ll_scrollposition 		= Long(ldw_data.Object.Datawindow.HorizontalScrollPosition)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out each element into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_database_names, ',', ls_dbname[])
gn_globals.in_string_functions.of_parse_string(ls_ids, ',', ls_id[])
gn_globals.in_string_functions.of_parse_string(ls_columnnames, ',', ls_columnname[])

ll_id = Long(idw_data.Dynamic Describe(as_columnname + ".ID"))
lb_found = False

For ll_index = 1 To Min(Min(UpperBound(ls_dbname[]), UpperBound(ls_id[])), UpperBound(ls_columnname[]))
	If Not lb_found Then
		If Long(ls_id[ll_index]) = ll_id Then
			ls_id[ll_index] 				= ''
			ls_dbname[ll_index] 			= ''
			ls_columnname[ll_index] 	= ''
			lb_found							= True
		End If
	Else
		ls_id[ll_index] = String(Long(ls_id[ll_index]) - 1)
	End If
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the Before View Saved message to clean up the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('remove a column', as_columnname, idw_data)
gn_globals.in_subscription_service.of_message('Before View Saved', idw_data, idw_data)

//----------------------------------------------------------------------------------------------------------------------------------
// Modify the column's x and make it visible
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic Modify("Destroy " + as_columnname)
idw_data.Dynamic Modify("Destroy " + as_columnname + "_srt")

//-----------------------------------------------------------------------------------------------------------------------------------
// Materialize the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_syntax = Create n_datawindow_syntax
idw_data.Dynamic Reset()
ln_datawindow_syntax.of_set_datasource(idw_data)

//-----------------------------------------------------------------------------------------------------------------------------------
// Delete the column from the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_syntax.of_delete_column(as_columnname)

If Pos(Lower(Trim(as_columnname)), '_dsplyuomconversion') > 0 Then
	ll_conversion_columnid = Long(idw_data.Dynamic Describe(as_columnname + '.ID'))
	
	If ll_conversion_columnid > 0 And Not IsNull(ll_conversion_columnid) Then
		ll_conversion_columnid = ll_conversion_columnid + 1
		ls_conversion_columnname 	= idw_data.Dynamic Describe('#' + String(ll_conversion_columnid) + '.Name')
		ln_datawindow_syntax.of_delete_column(ls_conversion_columnname)
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Reapply the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = ln_datawindow_syntax.of_get_syntax()
ln_datawindow_tools.of_apply_syntax(idw_data, ls_syntax)

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear out the init components
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= ''
ls_ids						= ''
ls_columnnames				= ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Rebuild the init components
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_dbname[]), UpperBound(ls_id[]))
	If ls_id[ll_index] = '' Then Continue
	
	ls_database_names = ls_database_names + ls_dbname[ll_index] + ','
	ls_ids				= ls_ids + ls_id[ll_index] + ','
	ls_columnnames		= ls_columnnames + ls_columnname[ll_index] + ','
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Cut the commas off
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names = Left(ls_database_names, Len(ls_database_names) - 1)
ls_ids 				= Left(ls_ids, Len(ls_ids) - 1)
ls_columnnames		= Left(ls_columnnames, Len(ls_columnnames) - 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the expression for the init field
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_database_names) + Len(ls_ids) + Len(ls_columnnames) = 0 Then
	idw_data.Dynamic Modify("Destroy AdditionalColumnsInit")
Else
	ln_datawindow_tools.of_set_expression(idw_data, 'AdditionalColumnsInit', 'dbname=' + ls_database_names + '||ID=' + ls_ids + '||Column=' + ls_columnnames)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure to reinitialize the uominit field
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_uom_uominit = Create n_uom_uominit
//ln_uom_uominit.of_init(idw_data)
//ln_uom_uominit.of_clean(idw_data)
//ln_uom_uominit.of_apply(idw_data)
//Destroy ln_uom_uominit

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy unneeded objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the messages necessary to reinitialize the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('After View Restored', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('Visible Columns Changed', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('column deleted', as_columnname, idw_data)

If idw_data.TypeOf() = Datawindow! Then
	ldw_Data = idw_data
	ldw_data.Object.DataWindow.HorizontalScrollPosition = String(ll_scrollposition)
End If

Return ''
end function

public function powerobject of_get_datawindow ();Return idw_data
end function

public subroutine of_create_column ();//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_return
String	ls_modify
String	ls_alignment
String	ls_computed_field_name
String	ls_computed_field_headername
String	ls_computed_field_headertext
String	ls_computed_field_expression

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_bag		ln_bag
NonVisualObject ln_nonvisual_window_opener

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the computed field name
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To 100
	If IsNumber(idw_data.Dynamic Describe('customcomputedfield' + String(ll_index) + '.X')) Then Continue
	If IsNumber(idw_data.Dynamic Describe('customcomputedfield' + String(ll_index) + '_srt.X')) Then Continue
	
	ls_computed_field_name			= 'customcomputedfield' + String(ll_index)
	ls_computed_field_headername	= 'customcomputedfield' + String(ll_index) + '_srt'
	ls_computed_field_headertext	= 'Computed Column ' + String(ll_index)
	ls_computed_field_expression	= ''
	Exit
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Allow the user to define the expression
//-----------------------------------------------------------------------------------------------------------------------------------
ln_bag = Create n_bag
ln_bag.of_set('datasource', idw_data)
ln_bag.of_set('title', 'Select the Expression for the Custom Computed Column')
ln_bag.of_set('expression', '')
ln_bag.of_set('NameIsRequired', 'yes')
ln_bag.of_set('ExpressionNameLabel', 'Label for Computed Column:')
ln_bag.of_set('ExpressionDefaultName', ls_computed_field_headertext)
ln_bag.of_set('ExpressionType', 'CF')
ln_bag.of_set('ExpressionTypeName', 'Report')
ln_bag.of_set('ExpressionSourceID', Long(idw_data.Event Dynamic ue_get_rprtcnfgid()))

ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_custom_expression_builder', ln_bag)
Destroy ln_nonvisual_window_opener


//----------------------------------------------------------------------------------------------------------------------------------
// Return if the canceled out of the dialog
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ln_bag) Then Return

//----------------------------------------------------------------------------------------------------------------------------------
// Get the expression and the label
//-----------------------------------------------------------------------------------------------------------------------------------
ls_computed_field_expression 	= String(ln_bag.of_get('datawindowexpression'))
ls_computed_field_headertext 	= String(ln_bag.of_get('ExpressionLabel'))

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the bag object
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_bag) Then Destroy ln_bag

//----------------------------------------------------------------------------------------------------------------------------------
// Call the function that will actually add the column to the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = This.of_create_column(ls_computed_field_name, ls_computed_field_headername, ls_computed_field_headertext, ls_computed_field_expression, '')

//----------------------------------------------------------------------------------------------------------------------------------
// Show a message if there is an error
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return <> '' Then
	//gn_globals.in_messagebox.of_messagebox_validation(ls_return)
End If
end subroutine

public subroutine of_recreate_view (n_bag an_bag, boolean ab_firsttime);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_recreate_view()
// Arguments:   adw_data	The datawindow to process
// Overview:    This will initialize the object
// Created by:  Blake Doerr
// History:     3/7/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools 	ln_datawindow_tools
//n_string_functions	ln_string_functions
//n_uom_uominit			ln_uom_uominit
Datastore				lds_OriginalDatawindow
Datastore				lds_ViewDatawindow

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_index2
Long		ll_original_datawindow_columncount
Long		ll_view_datawindow_columncount
Long		ll_upperbound
Long		ll_zoom
Long		ll_height
Long		ll_newheight
String	ls_expression
String	ls_return
String	ls_OriginalDatawindow
String	ls_ViewDatawindow
String	ls_original_sortinit
String	ls_view_sortinit
String	ls_computed_field_name
String	ls_computed_field_headername
String	ls_computed_field_headertext
String	ls_computed_field_expression
String	ls_computed_field_datatype
String	ls_database_names
String	ls_columnnames
String	ls_dbname[]
String	ls_columnname[]
String	ls_objects[]
String	ls_objecttype[]
String	ls_property[]
String	ls_modify
String	ls_empty[]
String	ls_syntax

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are any problems
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_bag) Or Not IsValid(idw_data) Then Return


//-----------------------------------------------------------------------------------------------------------------------------------
// If this is not the first time, we just need to reapply broken computed fields
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ab_firsttime Then
	ln_datawindow_tools = Create n_datawindow_tools

	For ll_index = 1 To UpperBound(is_computedfielderrors[])
		ls_return = ln_datawindow_tools.of_set_expression(idw_data, is_computedfielderrors[ll_index], is_computedfieldexpression[ll_index], False)
	Next
	
	Destroy ln_datawindow_tools
	
	If UpperBound(is_computedfielderrors[]) > 0 Then
		ls_syntax = idw_data.Dynamic Describe("Datawindow.Syntax")
		idw_data.Dynamic Create(ls_syntax)
	End If
	
	is_computedfielderrors[] 		= ls_empty[]
	is_computedfieldexpression[]	= ls_empty[]
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create two datastores
//-----------------------------------------------------------------------------------------------------------------------------------
lds_OriginalDatawindow	= Create Datastore
lds_ViewDatawindow		= Create Datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the three versions of the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_OriginalDatawindow	= an_bag.of_get('Original Syntax')
ls_ViewDatawindow			= an_bag.of_get('View Syntax')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the syntaxes are invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_OriginalDatawindow)) = 0 Or Len(Trim(ls_ViewDatawindow)) = 0 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the syntaxes to the datastores
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_apply_syntax(lds_OriginalDatawindow, ls_OriginalDatawindow)
ln_datawindow_tools.of_apply_syntax(lds_ViewDatawindow, ls_ViewDatawindow)

//-----------------------------------------------------------------------------------------------------------------------------------
// See if the number of columns is different in the new view
//-----------------------------------------------------------------------------------------------------------------------------------
ll_original_datawindow_columncount 	= Long(lds_OriginalDatawindow.Describe("Datawindow.Column.Count"))
ll_view_datawindow_columncount 		= Long(lds_ViewDatawindow.Describe("Datawindow.Column.Count"))

//-----------------------------------------------------------------------------------------------------------------------------------
// Set that we are restoring a view
//-----------------------------------------------------------------------------------------------------------------------------------
ib_WeAreRestoringAView = True

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the init column
//-----------------------------------------------------------------------------------------------------------------------------------
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the external columns that need to be deleted if they are already in the original view
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_expression <> '' And Not IsNull(ls_expression) And ls_expression <> '?' And ls_expression <> '!' Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the init column into its pieces
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_database_names 		= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'dbname'))
	ls_columnnames				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Column'))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse out each element into arrays
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_parse_string(ls_database_names, ',', ls_dbname[])
	gn_globals.in_string_functions.of_parse_string(ls_columnnames, ',', ls_columnname[])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the number of valid external columns
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_upperbound = Min(UpperBound(ls_dbname[]), UpperBound(ls_columnname[]))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add each valid external column
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To ll_upperbound
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If it does not add correctly, clear the column out, otherwise correct the column id just in case
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not ib_ThisIsDynamicCriteriaBuilder Then
			This.of_delete_external_column(ls_columnname[ll_index])
		Else
			This.of_delete_criteria_column(ls_columnname[ll_index])
		End If
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the init column
//-----------------------------------------------------------------------------------------------------------------------------------
ls_expression = ln_datawindow_tools.of_get_expression(lds_ViewDatawindow, 'AdditionalColumnsInit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the external columns that need to be added
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_expression <> '' And Not IsNull(ls_expression) And ls_expression <> '?' And ls_expression <> '!' Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the init column into its pieces
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_dbname[]					= ls_empty[]
	ls_columnname[]			= ls_empty[]
	ls_database_names 		= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'dbname'))
	ls_columnnames				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Column'))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse out each element into arrays
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_parse_string(ls_database_names, ',', ls_dbname[])
	gn_globals.in_string_functions.of_parse_string(ls_columnnames, ',', ls_columnname[])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the number of valid external columns
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_upperbound = Min(UpperBound(ls_dbname[]), UpperBound(ls_columnname[]))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add each valid external column
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To ll_upperbound
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If it does not add correctly, clear the column out, otherwise correct the column id just in case
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_add_external_column(ls_columnname[ll_index], ls_dbname[ll_index], lds_ViewDatawindow.Describe(ls_columnname[ll_index] + '_srt.Text'), lds_ViewDatawindow)
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the computed fields that need to be recreated
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(Lower(idw_data.Dynamic Describe("Datawindow.Syntax")), 'customcomputedfield') > 0 Then
	For ll_index = 1 To 100
		If Not IsNumber(idw_data.Dynamic Describe('customcomputedfield' + String(ll_index) + '.X')) Then Continue

		//----------------------------------------------------------------------------------------------------------------------------------
		// Call the function that will actually add the column to the datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_delete_column('customcomputedfield' + String(ll_index))
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the computed fields that need to be recreated
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(Lower(ls_ViewDatawindow), 'customcomputedfield') > 0 Then
	For ll_index = 1 To 100
		If Not IsNumber(lds_ViewDatawindow.Describe('customcomputedfield' + String(ll_index) + '.X')) Then Continue
		If Not IsNumber(lds_ViewDatawindow.Describe('customcomputedfield' + String(ll_index) + '_srt.X')) Then Continue

		ls_computed_field_name			= 'customcomputedfield' + String(ll_index)
		ls_computed_field_headername	= 'customcomputedfield' + String(ll_index) + '_srt'
		ls_computed_field_headertext	= lds_ViewDatawindow.Describe('customcomputedfield' + String(ll_index) + '_srt.Text')
		ls_computed_field_expression	= lds_ViewDatawindow.Describe('customcomputedfield' + String(ll_index) + '.Expression')
		ls_computed_field_datatype		= lds_ViewDatawindow.Describe('customcomputedfield' + String(ll_index) + '.ColType')
		
		If Pos(ls_computed_field_expression, '~r~n') > 0 And Left(ls_computed_field_expression, 1) = '"' And Right(ls_computed_field_expression, 1) = '"' Then
			ls_computed_field_expression = Left(ls_computed_field_expression, Len(ls_computed_field_expression) - 1)
			ls_computed_field_expression = Mid(ls_computed_field_expression, 2)
			gn_globals.in_string_functions.of_replace_all(ls_computed_field_expression, '~~"', '"')
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Call the function that will actually add the column to the datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_return = This.of_create_column(ls_computed_field_name, ls_computed_field_headername, ls_computed_field_headertext, ls_computed_field_expression, ls_computed_field_datatype)
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Show a message if there is an error
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ls_return <> '' Then
			//gn_globals.in_messagebox.of_messagebox_validation(ls_return)
		End If
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure to reinitialize the uominit field
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_uom_uominit = Create n_uom_uominit
//ln_uom_uominit.of_init(lds_ViewDatawindow)
//ln_uom_uominit.of_append(True)
//ln_uom_uominit.of_init(idw_data)
//ln_uom_uominit.of_clean(idw_data)
//ln_uom_uominit.of_apply(idw_data)
//Destroy ln_uom_uominit

//-----------------------------------------------------------------------------------------------------------------------------------
// Restore the header height if it has been changed
//-----------------------------------------------------------------------------------------------------------------------------------
ll_height 		= Long(lds_OriginalDatawindow.Describe('Datawindow.Header.Height'))
ll_newheight 	= Long(lds_ViewDatawindow.Describe('Datawindow.Header.Height'))
	
If ll_newheight - ll_height <> 0 Then
	//ln_datawindow_tools.of_modify_header_height(idw_data, ll_newheight)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the type for all the objects and add the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_get_all_object_property(lds_ViewDatawindow, 'Type', ls_objects[], ls_objecttype[], False)
ls_objects[UpperBound(ls_objects[]) + 1] = 'datawindow'
ls_objecttype[UpperBound(ls_objecttype[]) + 1] = 'datawindow'

ll_upperbound = Min(UpperBound(ls_objects[]), UpperBound(ls_objecttype[]))

For ll_index = 1 To ll_upperbound
	Choose Case Lower(Trim(ls_objecttype[ll_index]))
		Case 'column'
			ls_property[1] = 'border'
			ls_property[2] = 'alignment'
			ls_property[3] = 'font.face'
			ls_property[4] = 'font.height'
			ls_property[5] = 'font.strikethrough'
			ls_property[6] = 'font.underline'
			ls_property[7] = 'font.weight'
			ls_property[8] = 'font.italic'
			ls_property[9] = 'color'
			ls_property[10] = 'background.color'
			ls_property[11] = 'protect'
			ls_property[12] = 'format'

		Case 'text'
			ls_property[1] = 'text'
			ls_property[2] = 'border'
			ls_property[3] = 'alignment'
			ls_property[4] = 'font.face'
			ls_property[5] = 'font.height'
			ls_property[6] = 'font.strikethrough'
			ls_property[7] = 'font.underline'
			ls_property[8] = 'font.weight'
			ls_property[9] = 'font.italic'
			ls_property[10] = 'color'
			ls_property[11] = 'background.color'

		Case 'compute'
			ls_property[1] = 'border'
			ls_property[2] = 'alignment'
			ls_property[3] = 'font.face'
			ls_property[4] = 'font.height'
			ls_property[5] = 'font.strikethrough'
			ls_property[6] = 'font.underline'
			ls_property[7] = 'font.weight'
			ls_property[8] = 'font.italic'
			ls_property[9] = 'color'
			ls_property[10] = 'background.color'
			ls_property[11] = 'format'
			
			If Pos(Lower(ls_objects[ll_index]), 'customcomputedfield') <= 0 Then
				ls_property[12] = 'expression'
			ElseIf Lower(Trim(ls_objects[ll_index])) = 'report_footer' And lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.Expression') <> lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.Expression') Then
				ls_property[12] = 'expression'
			End If

		Case 'bitmap'
			ls_property[1] = 'visible'
			ls_property[2] = 'border'
			ls_property[3] = 'filename'
			ls_property[4] = 'width'
			ls_property[5] = 'height'
			
		Case 'datawindow'
			ls_property[1] = 'detail.color'
			ls_property[2] = 'detail.height'
			ls_property[3] = 'print.copies'
			ls_property[4] = 'print.orientation'
			ls_property[5] = 'print.page.range'
			ls_property[6] = 'print.page.rangeinclude'
			ls_property[7] = 'print.paper.size'
			ls_property[8] = 'zoom'
	End Choose

	Choose Case Lower(Trim(ls_objects[ll_index]))
		Case 'report_bitmap'
			If lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.X') <> lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.X') Then
				ls_property[UpperBound(ls_property[]) + 1] = 'x'
			End If
			
			If lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.Y') <> lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.Y') Then
				ls_property[UpperBound(ls_property[]) + 1] = 'y'
			End If
	End Choose

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the headers were made taller, restore these properties
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Right(Lower(ls_objects[ll_index]), Len('_srt')) = '_srt' Then
		Choose Case Lower(Trim(ls_objecttype[ll_index]))
			Case 'column', 'compute', 'text'
				If lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.Height') <> lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.Height') And lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.Y') <> String(Long(lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.Y')) + ll_newheight - ll_height) And Long(lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.Y')) + Long(lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.Height')) = Long(lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.Y')) + Long(lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.Height')) + ll_newheight - ll_height Then
					ls_property[UpperBound(ls_property[]) + 1] = 'height'
					ls_property[UpperBound(ls_property[]) + 1] = 'y'
				End If
		End Choose
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the group headers have changed height, restore this property
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Pos(Lower(ls_objects[ll_index]), 'c_group_header') > 0 Then
		Choose Case Lower(Trim(ls_objecttype[ll_index]))
			Case 'column', 'compute', 'text'
				If lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.Width') <> idw_data.Dynamic Describe(ls_objects[ll_index] + '.Width') Then
					ls_property[UpperBound(ls_property[]) + 1] = 'width'
				End If
		End Choose
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the width or height of the title has changed, restore this
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Lower(Trim(ls_objects[ll_index])) = 'report_title' Or Lower(Trim(ls_objects[ll_index])) = 'report_footer' Then
		If lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.Width') <> lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.Width') Then
			ls_property[UpperBound(ls_property[]) + 1] = 'width'
		End If

		If lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.Height') <> lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.Height') Then
			ls_property[UpperBound(ls_property[]) + 1] = 'height'
		End If
		
		If Lower(Trim(ls_objects[ll_index])) = 'report_title' Then
			If lds_ViewDatawindow.Describe('report_bitmap.Width') <> lds_OriginalDatawindow.Describe('report_bitmap.Width') Or lds_ViewDatawindow.Describe('report_bitmap.Height') <> lds_OriginalDatawindow.Describe('report_bitmap.Height') Then
				ls_property[UpperBound(ls_property[]) + 1] = 'x'
				ls_property[UpperBound(ls_property[]) + 1] = 'y'
			End If
		End If
	End If

	For ll_index2 = 1 To UpperBound(ls_property[])
		If lds_OriginalDatawindow.Describe(ls_objects[ll_index] + '.' + ls_property[ll_index2]) <> lds_ViewDatawindow.Describe(ls_objects[ll_index] + '.' + ls_property[ll_index2]) Then
			ls_return = ln_datawindow_tools.of_copy_property(lds_ViewDatawindow, idw_data, ls_objects[ll_index], ls_property[ll_index2])
		End If
	Next
	
	ls_property[] = ls_empty[]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Restore the zoom if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
ls_expression = ln_datawindow_tools.of_get_expression(lds_ViewDatawindow, "dataobjectstateinit")
If Pos(ls_expression, '=') > 0 Then
	ll_zoom = Long(Mid(ls_expression, Pos(ls_expression, '=') + 1))
	If Not IsNull(ll_zoom) And ll_zoom >= 0 Then
		lds_ViewDatawindow.Modify("Datawindow.Zoom='" + String(ll_zoom) + "'")
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Restore the uomdescription if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If ln_datawindow_tools.of_IsComputedField(lds_ViewDatawindow, "uominitdescription") Then
	ln_datawindow_tools.of_set_expression(idw_data, "uominitdescription", ln_datawindow_tools.of_get_expression(lds_ViewDatawindow, "uominitdescription"))
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
Destroy lds_OriginalDatawindow
Destroy lds_ViewDatawindow

ib_WeAreRestoringAView = False
end subroutine

public subroutine of_set_source_formatting_service (nonvisualobject an_service);in_datawindow_formatting_service_dynamic_criteria = an_service
end subroutine

public function string of_add_criteria_column (string as_columnname, string as_dbname, string as_headertext, datastore ads_datasource, string as_criteria_style);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_create_second_column = False
Boolean	lb_create_applycriteria_column = False
Boolean	lb_create_qualifier_column = False
Long		ll_index
Long		ll_x_position
Long		ll_y_position
Long		ll_scrollposition
Long		ll_width
Long		ll_height = 60
Long		ll_column_number
String	ls_criteria_style
String	ls_editmask
String	ls_text
String	ls_columntype
String	ls_values
String	ls_editstyle
String	ls_original_columnname
String	ls_expression
String	ls_database_names
String	ls_syntax
String	ls_ids
String	ls_return
String	ls_dddw_multi_columnname
String	ls_columnnames
String	ls_columnname[]
String	ls_id[]
String	ls_empty[]
String	ls_attributes
String	ls_attribute[]
String	ls_dbname[]
String	ls_column_to_copy
String	ls_columnheader_to_copy
String	ls_styles[]
String	ls_style
String	ls_style_datatype
String	ls_style_editstyle
String	ls_style_styletype
String	ls_style_options

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools 	ln_datawindow_tools
//n_string_functions 	ln_string_functions
n_datawindow_syntax 	ln_datawindow_syntax
Datawindow				ldw_data

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the init column
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the elements of the string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'dbname'))
ls_ids						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'ID'))
ls_columnnames				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Column'))
ls_style						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Style'))
If idw_data.TypeOf() = Datawindow! Then
	ldw_Data = idw_data
	ll_scrollposition 		= Long(ldw_data.Object.Datawindow.VerticalScrollPosition)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the original column name
//-----------------------------------------------------------------------------------------------------------------------------------
ls_original_columnname	= as_columnname

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the editstyle so we can avoid certain attributes
//-----------------------------------------------------------------------------------------------------------------------------------
ls_editstyle = ln_datawindow_tools.of_get_editstyle(ads_datasource, ls_original_columnname)

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out each element into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_database_names, ',', ls_dbname[])
gn_globals.in_string_functions.of_parse_string(ls_ids, ',', ls_id[])
gn_globals.in_string_functions.of_parse_string(ls_columnnames, ',', ls_columnname[])
gn_globals.in_string_functions.of_parse_string(ls_style, ',', ls_styles[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Materialize the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_syntax = Create n_datawindow_syntax
ln_datawindow_syntax.of_set_datasource(idw_data)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the values property for dropdownlistboxes
//-----------------------------------------------------------------------------------------------------------------------------------
ls_values = ads_datasource.Describe(as_columnname + '.Values')

ls_criteria_style		= as_criteria_style
ls_style_datatype		= Left(ls_criteria_style, Pos(ls_criteria_style, '.') - 1)
ls_criteria_style 	= Mid(ls_criteria_style, Pos(ls_criteria_style, '.') + 1)
ls_style_editstyle	= Left(ls_criteria_style, Pos(ls_criteria_style, '.') - 1)
ls_criteria_style 	= Mid(ls_criteria_style, Pos(ls_criteria_style, '.') + 1)

If Pos(ls_criteria_style, '.') > 0 Then
	ls_style_styletype	= Left(ls_criteria_style, Pos(ls_criteria_style, '.') - 1)
	ls_criteria_style 	= Mid(ls_criteria_style, Pos(ls_criteria_style, '.') + 1)
	ls_style_options		= ls_criteria_style
Else
	ls_style_styletype	= ls_criteria_style
	ls_style_options		= ''
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the column to the init string components
//-----------------------------------------------------------------------------------------------------------------------------------
ls_columntype = ads_datasource.Describe(as_columnname + '.ColType')

If Lower(Trim(ls_editstyle)) = 'ddlb' And ls_style_styletype = 'dropdown' Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// The Values Property has all the items of the drop down defined.  Add all as a selection.
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case Lower(Trim(Left(ls_columntype, 4)))
		Case	'numb', 'long', 'real', 'deci', 'floa'
			ls_values = '(All)~t' + String(il_dddw_all_data_column) + '/' + ls_values
		Case Else
			ls_values = '(All)~t' + is_ddlb_all_data_column + '/' + ls_values
	End Choose
End If

Choose Case Lower(Trim(ls_editstyle))
	Case 'dddw'
		If ls_style_styletype <> 'dropdown' Then
			ls_columntype = 'char(4099)'
			//-----------------------------------------------------------------------------------------------------------------------------------
         // JJF RAID #51019  08/17/2004
		   // Since this isn't really a dddw, we need to get rid of dddw in the style.  This will prevent a GetItem on a nonexistent column
         //-----------------------------------------------------------------------------------------------------------------------------------
         ls_editstyle = ''
			gn_globals.in_string_functions.of_replace_all(as_criteria_style, 'dddw', '')
		End If
	Case 'ddlb'
		//ls_columntype = 'char(4099)'
	Case Else
		Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
			Case 'date', 'long', 'deci', 'real', 'numb', 'inte'
			Case Else
				ls_columntype = 'char(4099)'
		End Choose
End Choose

Choose Case Lower(Trim(ls_style_styletype))
	Case 'between', 'notbetween'
		lb_create_second_column = True
	Case 'isnull', 'isnotnull'
		ls_columntype = 'char(1)'
End Choose

ls_id[UpperBound(ls_id[]) + 1] 		= String(ln_datawindow_syntax.of_add_column(ls_columntype, as_columnname, ls_values))
ls_dbname[UpperBound(ls_id[])]		= as_dbname
ls_columnname[UpperBound(ls_id[])] 	= as_columnname
ls_styles[UpperBound(ls_id[])]		= as_criteria_style

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the multi column for multi-select
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(ls_style_editstyle)) = 'dddw' And ls_style_styletype = 'dropdown' And Upper(Trim(ls_style_options)) = 'Y' Then
	ls_dddw_multi_columnname = as_columnname + '_multi'
	ln_datawindow_syntax.of_add_column('char(4099)', ls_dddw_multi_columnname, '')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add second column for between and not between
//-----------------------------------------------------------------------------------------------------------------------------------
If lb_create_second_column Then
	ls_dddw_multi_columnname = as_columnname + '_second'
	ln_datawindow_syntax.of_add_column(ls_columntype, ls_dddw_multi_columnname, ls_values)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the qualifier column for strings
//-----------------------------------------------------------------------------------------------------------------------------------
If Left(Lower(Trim(ls_editstyle)), 2) <> 'dd' And Lower(Trim(Left(ls_style_datatype, 4))) = 'char' Then
	lb_create_qualifier_column = True
End If

If lb_create_qualifier_column Then
	ls_dddw_multi_columnname = as_columnname + '_qualifier'
	ln_datawindow_syntax.of_add_column('char(20)', ls_dddw_multi_columnname, 'Equals~tequals/Begins With~tbeginswith/Does Not Begin With~tnotbeginswith/Ends With~tendswith/Does Not End With~tnotendswith/Contains~tcontains/Does Not Contain~tnotcontains/Is Empty (Null)~tisnull/Is Empty (~~"~~")~tisemptystring/Is Not Empty (Not Null)~tisnotnull/')
End If

Choose Case Lower(Trim(ls_style_styletype))
	Case 'isnull', 'isnotnull'
		lb_create_applycriteria_column = True
	Case 'between', 'lessthan', 'greaterthan', 'equal', 'notequal', 'notbetween', 'beginswith'
		Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
			Case 'long', 'inte', 'ulon', 'char'
			Case Else
				lb_create_applycriteria_column = True
		End Choose
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the qualifier column for strings
//-----------------------------------------------------------------------------------------------------------------------------------
If lb_create_applycriteria_column Then
	ls_dddw_multi_columnname = as_columnname + '_applycriteria'
	ln_datawindow_syntax.of_add_column('char(1)', ls_dddw_multi_columnname, '', 'Y')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the new syntax and apply it
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = ln_datawindow_syntax.of_get_syntax()
idw_data.Dynamic Reset()
ln_datawindow_tools.of_apply_syntax(idw_data, ls_syntax)

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear out the init components
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= ''
ls_ids						= ''
ls_columnnames				= ''
ls_style						= ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Rebuild the init components
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_dbname[]), UpperBound(ls_id[]))
	ls_database_names = ls_database_names + ls_dbname[ll_index] + ','
	ls_ids				= ls_ids + ls_id[ll_index] + ','
	ls_columnnames		= ls_columnnames + ls_columnname[ll_index] + ','
	ls_style				= ls_style + ls_styles[ll_index] + ','
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Cut the commas off
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names = Left(ls_database_names, Len(ls_database_names) - 1)
ls_ids 				= Left(ls_ids, Len(ls_ids) - 1)
ls_columnnames		= Left(ls_columnnames, Len(ls_columnnames) - 1)
ls_style				= Left(ls_style, Len(ls_style) - 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the expression for the init field
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_set_expression(idw_data, 'AdditionalColumnsInit', 'dbname=' + ls_database_names + '||ID=' + ls_ids + '||Column=' + ls_columnnames + '||Style=' + ls_style)

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy unneeded objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_syntax
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the label for the criteria
//-----------------------------------------------------------------------------------------------------------------------------------
ll_x_position 	= Long(idw_data.Dynamic Describe('dummy_srt.X'))
ll_y_position	= (UpperBound(ls_id[]) - 1) * il_DynamicCriteriaRowHeight + 4

ls_return = "create text(band=Detail color='0' visible = '1' alignment='3' border='0' height.autosize=No pointer='Arrow!' moveable=0 resizeable=0 x='" + String(ll_x_position) + "' y='" + String(ll_y_position) + "' height='" + String(ll_height) + "' width='500~tLong(Describe(~"dummy_srt.Width~"))' text='" + as_headertext + ":' name=" + as_columnname + "_srt tag='' font.face='Tahoma' font.weight='700' font.family='0' font.pitch='0' font.charset='1' font.italic='0' font.strikethrough='0' font.underline='0' font.height='-8' background.mode='1' background.color='553648127' tag='" + as_columnname + "')"
ls_return = idw_data.Dynamic Modify(ls_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the columns that represent the criteria
//-----------------------------------------------------------------------------------------------------------------------------------
ll_x_position 	= Long(idw_data.Dynamic Describe('t_selectedvalues.X'))

Choose Case Lower(Trim(ls_style_styletype))
	Case 'between'
		ls_text		= 'Between '
		ll_width 	= 200
	Case 'notbetween'
		ls_text		= 'Not Between '
		ll_width 	= 290
	Case 'greaterthan'
		ls_text		= 'Greater Than Or Equal'
		ll_width 	= 500
	Case 'lessthan'
		ls_text		= 'Less Than Or Equal'
		ll_width 	= 420
	Case 'notequal'
		ls_text		= 'Not Equal To '
		ll_width 	= 295
	Case 'equal'
		ls_text		= 'Equals '
		ll_width 	= -20
	Case 'beginswith'
		ls_text		= 'Begins With'
		ll_width 	= 275
	Case 'isnull'
		ls_text		= 'Is Empty'
		ll_width 	= 200
	Case 'isnotnull'
		ls_text		= 'Is Not Empty'
		ll_width 	= 290
End Choose

ls_return 	= "create text(band=Detail color='0' alignment='3' border='0' height.autosize=No pointer='Arrow!' moveable=0 resizeable=0 x='" + String(ll_x_position) + "' y='" + String(ll_y_position) + "' height='" + String(ll_height) + "' width='" + String(ll_width) + "' text='" + ls_text + "' name=" + as_columnname + "_prefix tag='' font.face='Tahoma' font.weight='400' font.family='0' font.pitch='0' font.charset='1' font.italic='0' font.strikethrough='0' font.underline='0' font.height='-8' background.mode='1' background.color='553648127' tag='" + as_columnname + "')"
ls_return 	= idw_data.Dynamic Modify(ls_return)
ll_x_position 	= ll_x_position + ll_width + 20

If lb_create_qualifier_column Then
	ll_width 	= 600
	ls_return 	= 'create column(band=detail id=' + String(Long(ls_id[UpperBound(ls_id[])]) + 1) + ' alignment="0" tabsequence=10 border="5" color="0" x="' + String(ll_x_position) + '" y="' + String(ll_y_position) + '" height="' + String(ll_height) + '" width="' + String(ll_width) + '" format="[general]"  name=' + as_columnname + '_qualifier ddlb.limit=0 ddlb.allowedit=no ddlb.case=any ddlb.required=yes ddlb.nilisnull=yes ddlb.vscrollbar=yes ddlb.useasborder=yes font.face="Tahoma" font.height="-8" font.weight="400" font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215"  tag="' + as_columnname + '")'
	ls_return 	= idw_data.Dynamic Modify(ls_return)
	ll_x_position 	= ll_x_position + ll_width + 20
End If

Choose Case Lower(Trim(ls_editstyle))
	Case 'ddlb', 'dddw'
		ll_width		= 800
	Case Else
		Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
			Case 'date'
				If Upper(Trim(ls_style_options)) = 'Y' Then
					ll_width		= 600
					ls_editmask = '[date] HH:MM:SS'
				Else
					ll_width		= 310
					ls_editmask = '[date]'
				End If
			Case 'char'
				ll_width		= 1000
				ls_editmask = '[General]'
			Case 'long', 'inte', 'ulon'
				ll_width		= 500
				ls_editmask = '###,###,###,###,###'
			Case Else
				ll_width		= 500
				ls_editmask = '###,###,###,###.##########'
		End Choose
End Choose

If Lower(Trim(ls_style_styletype)) <> 'isnull' And Lower(Trim(ls_style_styletype)) <> 'isnotnull' Then
	ll_column_number = Long(idw_data.Dynamic Describe(as_columnname + '.ID'))
	ls_return 	= "create column(band=Detail id=" + String(ll_column_number) + " tabsequence=10 moveable=0 resizeable=0 pointer='Arrow!' x='" + String(ll_x_position) + "' y='" + String(ll_y_position) + "' alignment='3' height.autosize=No border='5' color='0' height='" + String(ll_height) + "' width='" + String(ll_width) + "' name=" + as_columnname + " tag='' background.mode='0' background.color='16777215' font.face='Tahoma' font.height='-8' font.weight='400' font.family='0' font.pitch='0' font.charset='0' edit.autoselect=Yes edit.autohscroll=Yes  tag='" + as_columnname + "')"
	
	Choose Case Lower(Trim(ls_editstyle))
		Case 'ddlb', 'dddw'
		Case Else
			Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
				Case 'char'
				Case 'date'
					ls_return 	= 'create column(band=detail id=' + String(ll_column_number) + ' alignment="3" tabsequence=10 border="5" color="0" x="'  + String(ll_x_position) +  '" y="'  + String(ll_y_position) + '" height="' + String(ll_height) + '" width="' + String(ll_width) + '" format="[shortdate] [time]"  name=' + as_columnname + ' editmask.mask="' + ls_editmask + '" editmask.focusrectangle=no  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" tag="' + as_columnname + '")'
				Case Else
					ls_return 	= 'create column(band=detail id=' + String(ll_column_number) + ' alignment="3" tabsequence=10 border="5" color="0" x="'  + String(ll_x_position) +  '" y="'  + String(ll_y_position) + '" height="' + String(ll_height) + '" width="' + String(ll_width) + '" format="[General]"  name=' + as_columnname + ' editmask.mask="' + ls_editmask + '" editmask.focusrectangle=no  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" tag="' + as_columnname + '")'
			End Choose
	End Choose
	
	ls_return 	= idw_data.Dynamic Modify(ls_return)
	
	ll_x_position 	= ll_x_position + ll_width + 20
	
	Choose Case Lower(Trim(ls_editstyle))
		Case 'ddlb', 'dddw'
		Case Else
			Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
				Case 'date'
					ll_x_position = ll_x_position + 75
			End Choose
	End Choose
End If

If lb_create_second_column Then
	ls_text		= 'And'
	ls_return 	= "create text(band=Detail color='0' visible = '1' alignment='3' border='0' height.autosize=No pointer='Arrow!' moveable=0 resizeable=0 x='" + String(ll_x_position) + "' y='" + String(ll_y_position) + "' height='" + String(ll_height) + "' width='90' text='" + ls_text + "' name=" + as_columnname + "_and tag='' font.face='Tahoma' font.weight='400' font.family='0' font.pitch='0' font.charset='1' font.italic='0' font.strikethrough='0' font.underline='0' font.height='-8' background.mode='1' background.color='553648127' tag='" + as_columnname + "')"
	ls_return 	= idw_data.Dynamic Modify(ls_return)

	ll_x_position = ll_x_position + 90 + 20
	ll_column_number = Long(idw_data.Dynamic Describe(as_columnname + '_second.ID'))
	ls_return = "create column( id=" + String(ll_column_number) + " tabsequence=10 visible = '1' moveable=0 resizeable=0 pointer='Arrow!' band=Detail  x='" + String(ll_x_position) + "' y='" + String(ll_y_position) + "' alignment='3' height.autosize=No border='5' color='0' height='" + String(ll_height) + "' width='" + String(ll_width) + "' name=" + as_columnname + "_second tag='' background.mode='0' background.color='16777215' font.face='Tahoma' font.height='-8' font.weight='400' font.family='0' font.pitch='0' font.charset='1' font.italic='0' font.strikethrough='0' font.underline='0' edit.validatecode=No edit.focusrectangle=No edit.autoselect=Yes edit.autohscroll=Yes tag='" + as_columnname + "')"
	
	Choose Case Lower(Trim(ls_editstyle))
		Case 'ddlb', 'dddw'
		Case Else
			Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
				Case 'char'
				Case 'date'
					ls_return 	= 'create column(band=detail id=' + String(ll_column_number) + ' alignment="3" tabsequence=10 border="5" color="0" x="'  + String(ll_x_position) +  '" y="'  + String(ll_y_position) + '" height="' + String(ll_height) + '" width="' + String(ll_width) + '" format="[shortdate] [time]"  name=' + as_columnname + '_second editmask.mask="' + ls_editmask + '" editmask.focusrectangle=no  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" tag="' + as_columnname + '")'
				Case Else
					ls_return 	= 'create column(band=detail id=' + String(ll_column_number) + ' alignment="3" tabsequence=10 border="5" color="0" x="'  + String(ll_x_position) +  '" y="'  + String(ll_y_position) + '" height="' + String(ll_height) + '" width="' + String(ll_width) + '" format="[General]"  name=' + as_columnname + '_second editmask.mask="' + ls_editmask + '" editmask.focusrectangle=no  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" tag="' + as_columnname + '")'
			End Choose
	End Choose

	ls_return = idw_data.Dynamic Modify(ls_return)
	
	ll_x_position 	= ll_x_position + ll_width + 20
		
	Choose Case Lower(Trim(ls_editstyle))
		Case 'ddlb', 'dddw'
		Case Else
			Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
				Case 'date'
					ll_x_position = ll_x_position + 75
			End Choose
	End Choose
End If

If lb_create_applycriteria_column Then
	ll_column_number = Long(idw_data.Dynamic Describe(as_columnname + '_applycriteria.ID'))
	
	If ll_column_number > 0 Then
		ll_x_position = ll_x_position + 20
		ls_return 	= 'create column(band=detail id=' + String(ll_column_number) + ' alignment="3" tabsequence=10 border="0" color="0" x="' + String(ll_x_position) + '" y="' + String(ll_y_position) + '" height="' + String(ll_height) + '" width="1000" format="[general]"  name=' + as_columnname + '_applycriteria checkbox.text="Apply This Criteria" checkbox.on="Y" checkbox.off="N" checkbox.scale=no checkbox.threed=yes  font.face="Tahoma" font.height="-8" font.weight="400" font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912" tag="' + as_columnname + '")'
		ls_return 	= idw_data.Dynamic Modify(ls_return)
		
		idw_data.Dynamic Modify(as_columnname + '.Background.color="16777215~tIf(' + as_columnname + '_applycriteria = ~'Y~', 16777215, 553648127)"')
		idw_data.Dynamic Modify(as_columnname + '.Protect="0~tIf(' + as_columnname + '_applycriteria = ~'Y~', 0, 1)"')
		idw_data.Dynamic Modify(as_columnname + '_second' + '.Background.color="16777215~tIf(' + as_columnname + '_applycriteria = ~'Y~', 16777215, 553648127)"')
		idw_data.Dynamic Modify(as_columnname + '_second' + '.Protect="0~tIf(' + as_columnname + '_applycriteria = ~'Y~', 0, 1)"')
		idw_data.Dynamic Modify(as_columnname + '_qualifier' + '.Background.color="16777215~tIf(' + as_columnname + '_applycriteria = ~'Y~', 16777215, 553648127)"')
		idw_data.Dynamic Modify(as_columnname + '_qualifier' + '.Protect="0~tIf(' + as_columnname + '_applycriteria = ~'Y~', 0, 1)"')
	End If
End If

If lb_create_qualifier_column Then
	idw_data.Dynamic Modify(as_columnname + '.Background.color="16777215~tIf(' + as_columnname + '_qualifier = ~'isnull~' Or ' + as_columnname + '_qualifier = ~'isemptystring~' Or ' + as_columnname + '_qualifier = ~'isnotnull~', 553648127, 16777215)"')
	idw_data.Dynamic Modify(as_columnname + '.Protect="0~tIf(' + as_columnname + '_qualifier = ~'isnull~' Or ' + as_columnname + '_qualifier = ~'isemptystring~' Or ' + as_columnname + '_qualifier = ~'isnotnull~', 1, 0)"')
End If

idw_data.Dynamic Modify("Datawindow.Detail.Height=" + String((UpperBound(ls_id[]) - 1) * il_DynamicCriteriaRowHeight + 4 + 75 + 4))

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the attributes of the original column
//-----------------------------------------------------------------------------------------------------------------------------------
ls_attributes = ads_datasource.Describe(ls_original_columnname + '.Attributes')
gn_globals.in_string_functions.of_parse_string(ls_attributes, '~t', ls_attribute[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the attributes to the current column
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_attribute[])
	Choose Case Left(Lower(Trim(ls_attribute[ll_index])), 5)
		Case 'dddw.', 'ddlb.'
		Case Else
			Continue
	End Choose

	Choose Case ls_editstyle
		Case 'ddlb'
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'dddw.' Then Continue
		Case 'dddw'
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'ddlb.' Then Continue
	End Choose

	ls_return = ads_datasource.Describe(ls_original_columnname + '.' + ls_attribute[ll_index])
	If ls_return <> '?' And ls_return <> '!' Then
		idw_data.Dynamic Modify(as_columnname + "." + ls_attribute[ll_index] + "='" + ls_return + "'")
	End If
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Apply formatting to the column for the criteria type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ls_editstyle
	Case 'ddlb'//'checkbox'
		ls_return = idw_data.Dynamic Modify(as_columnname + ".ddlb.allowedit=no")
		ls_return = idw_data.Dynamic Modify(as_columnname + ".ddlb.vscrollbar=yes")
		ls_return = idw_data.Dynamic Modify(as_columnname + ".ddlb.useasborder=yes")
	Case 'dddw'		
		ls_return = idw_data.Dynamic Modify(as_columnname + ".dddw.allowedit=yes")
		ls_return = idw_data.Dynamic Modify(as_columnname + ".dddw.showarrow=yes")
		ls_return = idw_data.Dynamic Modify(as_columnname + ".dddw.useasborder=no")
		ls_return = idw_data.Dynamic Modify(as_columnname + ".dddw.vscrollbar=yes")
		ls_return = idw_data.Dynamic Modify(as_columnname + ".dddw.NilIsNull=yes")
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the Before View Saved message to clean up the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('Before View Saved', '', idw_data)

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the messages necessary to reinitialize the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('After View Restored', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('Visible Columns Changed', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('column added or removed', idw_data, idw_data)

This.of_init_criteria_datawindow()

If idw_data.TypeOf() = Datawindow! Then
	ldw_Data = idw_data
	ldw_data.Object.DataWindow.VerticalScrollPosition = String(ll_scrollposition)
	ldw_data.Dynamic SetRedraw(True)
End If

Return ''

end function

public function string of_add_external_column (string as_columnname, string as_dbname, string as_headertext, datastore ads_datasource, boolean ab_uomconversion, string as_uominit);Return This.of_add_external_column(as_columnname, as_dbname, as_headertext, ads_datasource, ab_uomconversion, as_uominit, False)
end function

protected function long of_find_position ();//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_object[]
String	ls_x[]
String	ls_width[]
Long		ll_upperbound
Long		ll_index
Long		ll_x

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools	ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the x's and widths into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_get_all_object_property(idw_data, '.X', ls_object[], ls_x[], False)
ln_datawindow_tools.of_get_all_object_property(idw_data, '.Width', ls_object[], ls_width[], False)
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the upperbound of the two arrays
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = Min(UpperBound(ls_x[]), UpperBound(ls_width[]))
ll_x = 10

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all stats and find the max
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = ll_upperbound To 1 Step -1
	If Match(Lower(ls_object[ll_index]), 'report_title') Then Continue
	If Match(Lower(ls_object[ll_index]), 'report_footer') Then Continue
	If Match(Lower(ls_object[ll_index]), 'report_bitmap') Then Continue
	If Not IsNumber(ls_x[ll_index]) Or Not IsNumber(ls_width[ll_index]) Then Continue
	ll_x 	= Max(ll_x, Long(ls_x[ll_index]) + Long(ls_width[ll_index]))
Next

Return ll_x + 25
end function

public function string of_add_external_column (string as_columnname, string as_dbname, string as_headertext, datastore ads_datasource, boolean ab_uomconversion, string as_uominit, boolean ab_columnexistsindatawindowtable);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_found_column_to_copy
Long		ll_index
Long		ll_x_position
Long		ll_scrollposition
Long		ll_return
String	ls_columntype
String	ls_values
String	ls_editstyle
String	ls_original_columnname
String	ls_expression
String	ls_database_names
String	ls_syntax
String	ls_ids
String	ls_return
String	ls_columnnames
String	ls_columnname[]
String	ls_id[]
String	ls_empty[]
String	ls_attributes
String	ls_attribute[]
String	ls_dbname[]
String	ls_column_to_copy
String	ls_columnheader_to_copy
String	ls_conversioncolumnname

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools 	ln_datawindow_tools
//n_string_functions 	ln_string_functions
n_datawindow_syntax 	ln_datawindow_syntax
//n_uom_uominit			ln_uom_uominit
Datawindow				ldw_data

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the init column
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the elements of the string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'dbname'))
ls_ids						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'ID'))
ls_columnnames				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Column'))

If idw_Data.TypeOf() = Datawindow! Then
	ldw_data = idw_data
	ll_scrollposition 		= Long(ldw_data.Object.Datawindow.HorizontalScrollPosition)
End If
//-----------------------------------------------------------------------------------------------------------------------------------
// Store the original column name
//-----------------------------------------------------------------------------------------------------------------------------------
ls_original_columnname	= as_columnname

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the editstyle so we can avoid certain attributes
//-----------------------------------------------------------------------------------------------------------------------------------
ls_editstyle = ln_datawindow_tools.of_get_editstyle(ads_datasource, ls_original_columnname)
If ls_editstyle = '?' Or ls_editstyle = '!' Then ls_editstyle = 'edit'

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out each element into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_database_names, ',', ls_dbname[])
gn_globals.in_string_functions.of_parse_string(ls_ids, ',', ls_id[])
gn_globals.in_string_functions.of_parse_string(ls_columnnames, ',', ls_columnname[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Warn the user if the column has already been added
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_WeAreRestoringAView Then
	For ll_index = 1 To UpperBound(ls_dbname[])
		If Lower(Trim(ls_dbname[ll_index])) = Lower(Trim(as_dbname)) Then
			//ll_return = gn_globals.in_messagebox.of_messagebox_question('This column has already been added to this report, are you sure you want to add it again', YesNo!, 2)
			
			If	ll_return <> 1 Then
				Destroy ln_datawindow_tools
				Return 'Error:  Column already exists'
			End If
			
			Exit
		End If
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Materialize the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_syntax = Create n_datawindow_syntax
ln_datawindow_syntax.of_set_datasource(idw_data)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the values property for dropdownlistboxes
//-----------------------------------------------------------------------------------------------------------------------------------
ls_values = ads_datasource.Describe(as_columnname + '.Values')

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the column to the init string components
//-----------------------------------------------------------------------------------------------------------------------------------
ls_columntype = ads_datasource.Describe(as_columnname + '.ColType')

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are doing uomconversion, add dsply to the name
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_uomconversion Then
	as_columnname = as_columnname + '_dsplyuomconversion'
	as_dbname 		= as_dbname + '[UOMConversion]'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are recreating the view, we may need to turn uomconversion on
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ab_uomconversion And Pos(as_columnname, '_dsplyuomconversion') > 0 And Lower(Right(Trim(as_dbname), Len('[UOMConversion]'))) = Lower('[UOMConversion]') Then
	ab_uomconversion = True
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the column to the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_columnexistsindatawindowtable Then
	If Not ln_datawindow_tools.of_iscolumn(idw_data, as_columnname) Then Return ''
	ls_id[UpperBound(ls_id[]) + 1] 		= idw_data.Dynamic Describe(as_columnname + '.ID')
Else
	ls_id[UpperBound(ls_id[]) + 1] 		= String(ln_datawindow_syntax.of_add_column(ls_columntype, as_columnname, ls_values))
End If

ls_dbname[UpperBound(ls_id[])]		= as_dbname
ls_columnname[UpperBound(ls_id[])] 	= as_columnname

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are doing uomconversion, add a second column to be the source
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_uomconversion Then
	ls_conversioncolumnname = as_columnname
	gn_globals.in_string_functions.of_replace_all(ls_conversioncolumnname, '_dsplyuomconversion', '')
	ln_datawindow_syntax.of_add_column(ls_columntype, ls_conversioncolumnname, ls_values)
	gn_globals.in_string_functions.of_replace_all(as_uominit, '{sourcecolumn}', ls_conversioncolumnname)
	gn_globals.in_string_functions.of_replace_all(as_uominit, '{destinationcolumn}', as_columnname)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the new syntax and apply it
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = ln_datawindow_syntax.of_get_syntax()
idw_data.Dynamic Reset()
ln_datawindow_tools.of_apply_syntax(idw_data, ls_syntax)

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the new conversion string
//-----------------------------------------------------------------------------------------------------------------------------------
//If ab_uomconversion Then
//	ln_uom_uominit = Create n_uom_uominit
//	ln_uom_uominit.of_init(as_uominit)
//	ln_uom_uominit.of_append(True)
//	ln_uom_uominit.of_init(idw_data)
//	ln_uom_uominit.of_apply(idw_data)
//	Destroy ln_uom_uominit
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear out the init components
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= ''
ls_ids						= ''
ls_columnnames				= ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Rebuild the init components
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_dbname[]), UpperBound(ls_id[]))
	ls_database_names = ls_database_names + ls_dbname[ll_index] + ','
	ls_ids				= ls_ids + ls_id[ll_index] + ','
	ls_columnnames		= ls_columnnames + ls_columnname[ll_index] + ','
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Cut the commas off
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names = Left(ls_database_names, Len(ls_database_names) - 1)
ls_ids 				= Left(ls_ids, Len(ls_ids) - 1)
ls_columnnames		= Left(ls_columnnames, Len(ls_columnnames) - 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the expression for the init field
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_set_expression(idw_data, 'AdditionalColumnsInit', 'dbname=' + ls_database_names + '||ID=' + ls_ids + '||Column=' + ls_columnnames)

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy unneeded objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_syntax

//----------------------------------------------------------------------------------------------------------------------------------
// Find a column to mimic its format
//-----------------------------------------------------------------------------------------------------------------------------------
lb_found_column_to_copy = This.of_find_column_to_copy(ls_column_to_copy, ls_columnheader_to_copy) 

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the header and the column
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = idw_data.Dynamic Modify("create column( id=" + ls_id[UpperBound(ls_id[])] + " tabsequence=0 visible = '0' moveable=0 resizeable=0 band=Detail  x='91' y='4' alignment='0' height.autosize=No border='0' color='0' height='52' width='500' name=" + as_columnname + " tag='' background.mode='1' background.color='553648127' font.face='Tahoma' font.height='-8' font.weight='400' font.family='0' font.pitch='0' font.charset='1' font.italic='0' font.strikethrough='0' font.underline='0' edit.validatecode=No edit.focusrectangle=No)")

ls_syntax = idw_data.Dynamic Describe("Datawindow.Syntax")

ls_return = "create text(band=Header color='0' visible = '0' alignment='0' border='0' height.autosize=No moveable=0 resizeable=0 x='91' y='132' height='52' width='500' text='" + as_headertext + "' name=" + as_columnname + "_srt tag='' font.face='Tahoma' font.height='-8' font.weight='700' font.family='0' font.pitch='0' font.charset='1' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='1' background.color='553648127')"
ls_return = idw_data.Dynamic Modify(ls_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the attributes of the original column
//-----------------------------------------------------------------------------------------------------------------------------------
If ln_datawindow_tools.of_iscolumn(ads_datasource, ls_original_columnname) Then
	ls_attributes = ads_datasource.Describe(ls_original_columnname + '.Attributes')
	gn_globals.in_string_functions.of_parse_string(ls_attributes, '~t', ls_attribute[])
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the attributes to the current column
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_attribute[])
	Choose Case ls_editstyle
		Case 'edit'
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'ddlb.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'dddw.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'checkbox.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'editmask.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'radiobuttons.' Then Continue
		Case 'ddlb'
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'edit.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'dddw.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'checkbox.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'editmask.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'radiobuttons.' Then Continue
		Case 'dddw'
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'edit.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'ddlb.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'checkbox.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'editmask.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'radiobuttons.' Then Continue
		Case 'checkbox'
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'edit.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'ddlb.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'dddw.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'editmask.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'radiobuttons.' Then Continue
		Case 'editmask'
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'edit.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'ddlb.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'dddw.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'checkbox.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'radiobuttons.' Then Continue
		Case 'radiobuttons'
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'edit.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'ddlb.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 5) = 'dddw.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'checkbox.' Then Continue
			If Left(Lower(Trim(ls_attribute[ll_index])), 9) = 'editmask.' Then Continue
	End Choose

	Choose Case Lower(Trim(ls_attribute[ll_index]))
		Case 'x', 'tabsequence', 'pointer'
			Continue
		Case 'editmask.spin', 'editmask.spinincr', 'editmask.spinrange'
			idw_data.Dynamic Modify(as_columnname + "." + 'editmask.spin' + "=No")
			Continue
	End Choose

	If Not lb_found_column_to_copy Then
		Choose Case Lower(Left(ls_attribute[ll_index], 4))
			Case 'font', 'heig', 'back', 'bord', 'colo'
				Continue
		End Choose
	End If

	ls_return = ads_datasource.Describe(ls_original_columnname + '.' + ls_attribute[ll_index])
	If ls_return <> '?' And ls_return <> '!' Then
		idw_data.Dynamic Modify(as_columnname + "." + ls_attribute[ll_index] + "='" + ls_return + "'")
	End If
	
	Choose Case Lower(Trim(ls_attribute[ll_index]))
		Case 'width'
			idw_data.Dynamic Modify(as_columnname + "_srt." + ls_attribute[ll_index] + "='" + ls_return + "'")
	End Choose
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Apply formatting to the column
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic Modify(as_columnname + ".Tag='Type=External'")

If lb_found_column_to_copy Then
	idw_data.Dynamic Modify(as_columnname + ".Background.Color='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Background.Color") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Background.Mode='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Background.Mode") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Border='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Border") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Color='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Color") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.CharSet='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.CharSet") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.Face='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Face") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.Family='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Family") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.Height='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Height") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.Italic='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Italic") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.Pitch='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Pitch") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.Strikethrough='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Strikethrough") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.Underline='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Underline") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.Weight='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Weight") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Font.Width='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Font.Width") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Height='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Height") + "'")
	idw_data.Dynamic Modify(as_columnname + ".Y='" + idw_data.Dynamic Describe(ls_column_to_copy + ".Y") + "'")

	//----------------------------------------------------------------------------------------------------------------------------------
	// Apply formatting to the text field
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Background.Color='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Background.Color") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Background.Mode='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Background.Mode") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Border='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Border") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Color='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Color") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.CharSet='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.CharSet") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.Face='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Face") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.Family='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Family") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.Height='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Height") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.Italic='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Italic") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.Pitch='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Pitch") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.Strikethrough='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Strikethrough") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.Underline='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Underline") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.Weight='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Weight") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Font.Width='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Font.Width") + "'")
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Height='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Height") + "'")
	If ln_datawindow_tools.of_iscolumn(ads_datasource, ls_original_columnname) Then
		idw_data.Dynamic Modify(as_columnname + '_srt' + ".Alignment='" + ads_datasource.Describe(ls_original_columnname + ".Alignment") + "'")
		idw_data.Dynamic Modify(as_columnname + ".Alignment='" + ads_datasource.Describe(ls_original_columnname + ".Alignment") + "'")
	Else
		Choose Case Lower(Trim(Left(ls_columntype, 4)))
			Case 'numb', 'deci'
				idw_data.Dynamic Modify(as_columnname + '_srt' + ".Alignment='1'")
				idw_data.Dynamic Modify(as_columnname + ".Alignment='1'")
			Case Else
				idw_data.Dynamic Modify(as_columnname + '_srt' + ".Alignment='0'")
				idw_data.Dynamic Modify(as_columnname + ".Alignment='0'")
		End Choose
	End If
	idw_data.Dynamic Modify(as_columnname + '_srt' + ".Y='" + idw_data.Dynamic Describe(ls_columnheader_to_copy + ".Y") + "'")
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the Before View Saved message to clean up the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('Before View Saved', '', idw_data)

//----------------------------------------------------------------------------------------------------------------------------------
// Find the X position for the column
//-----------------------------------------------------------------------------------------------------------------------------------
If lb_found_column_to_copy Then
	ll_x_position = This.of_find_position()
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Modify the column's x and make it visible
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_data.Dynamic Modify(as_columnname + ".X='" + String(ll_x_position) + "'")
	idw_data.Dynamic Modify(as_columnname + "_srt.X='" + String(ll_x_position) + "'")
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Make them visible
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic Modify(as_columnname + ".Visible='1'")
idw_data.Dynamic Modify(as_columnname + "_srt.Visible='1'")

//----------------------------------------------------------------------------------------------------------------------------------
// Publish the messages necessary to reinitialize the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('After View Restored', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('Visible Columns Changed', idw_data, idw_data)
gn_globals.in_subscription_service.of_message('column added or removed', idw_data, idw_data)

If idw_data.Dynamic TypeOf() = Datawindow! Then
	ldw_data = idw_data
	ldw_data.Object.DataWindow.HorizontalScrollPosition = String(ll_scrollposition)
	ldw_data.SetRedraw(True)
End If

Destroy ln_datawindow_tools


Return ''
end function

public subroutine of_get_dynamic_criteria (ref string as_criteria_arguments, ref string as_criteria_values);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_dynamic_criteria()
//	Overview:	
//	Created by:	Blake Doerr
//	History: 	4/23/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_create_second_column = False
Boolean	lb_create_applycriteria_column = False
Boolean	lb_create_qualifier_column = False
Long		ll_index
Long		ll_x_position
Long		ll_y_position
Long		ll_width
Long		ll_height = 60
Long		ll_column_number
Long		ll_upperbound
DateTime	ldt_fromdate
DateTime	ldt_todate
String	ls_editmask
String	ls_text
String	ls_columntype
String	ls_values
String	ls_editstyle
String	ls_expression
String	ls_database_names
String	ls_ids
String	ls_return
String	ls_columnnames
String	ls_columnname[]
String	ls_dbname[]
String	ls_empty[]
String	ls_id[]
String	ls_styles[]
String	ls_style
String	ls_style_datatype
String	ls_style_editstyle
String	ls_style_styletype
String	ls_style_options
String	ls_criteria_arguments[]
String	ls_criteria_values[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools 	ln_datawindow_tools
//n_string_functions 	ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the init column
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit')
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the elements of the string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 		= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'dbname'))
ls_ids						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'ID'))
ls_columnnames				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Column'))
ls_style						= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'Style'))

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out each element into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_database_names, ',', ls_dbname[])
gn_globals.in_string_functions.of_parse_string(ls_ids, ',', ls_id[])
gn_globals.in_string_functions.of_parse_string(ls_columnnames, ',', ls_columnname[])
gn_globals.in_string_functions.of_parse_string(ls_style, ',', ls_styles[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the upperbound of all the arrays
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = Min(Min(Min(UpperBound(ls_dbname[]), UpperBound(ls_id[])), UpperBound(ls_columnname[])), UpperBound(ls_styles[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each criteria element and build the expression for the sql side
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse out each element of the style
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_style_datatype		= Left(ls_styles[ll_index], Pos(ls_styles[ll_index], '.') - 1)
	ls_styles[ll_index] 	= Mid(ls_styles[ll_index], Pos(ls_styles[ll_index], '.') + 1)
	ls_style_editstyle	= Left(ls_styles[ll_index], Pos(ls_styles[ll_index], '.') - 1)
	ls_styles[ll_index] 	= Mid(ls_styles[ll_index], Pos(ls_styles[ll_index], '.') + 1)
	
	If Pos(ls_styles[ll_index], '.') > 0 Then
		ls_style_styletype	= Left(ls_styles[ll_index], Pos(ls_styles[ll_index], '.') - 1)
		ls_styles[ll_index] 	= Mid(ls_styles[ll_index], Pos(ls_styles[ll_index], '.') + 1)
		ls_style_options		= ls_styles[ll_index]
	Else
		ls_style_styletype	= ls_styles[ll_index]
		ls_style_options		= ''
	End If
	ls_criteria_arguments[ll_index] 	= ls_dbname[ll_index]
	ls_criteria_values[ll_index] 		= ''

	If IsNumber(idw_data.Dynamic Describe(ls_columnname[ll_index]  + '_applycriteria.ID')) Then
		If Upper(Trim(idw_data.Dynamic GetItemString(1, ls_columnname[ll_index] + '_applycriteria'))) <> 'Y' Then Continue
	End If

	Choose Case Lower(Trim(ls_style_editstyle))
		Case 'dddw'
			Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
				Case 'date'
					ls_criteria_values[ll_index] = '= "' + gn_globals.in_string_functions.of_convert_datetime_to_string(idw_data.Dynamic GetItemDateTime(1, ls_columnname[ll_index])) + '"'
				Case 'char'
					If idw_data.Dynamic GetItemString(1, ls_columnname[ll_index]) = is_ddlb_all_data_column Or Long(idw_data.Dynamic GetItemString(1, ls_columnname[ll_index])) = il_dddw_all_data_column Then Continue
					
					If IsNumber(idw_data.Dynamic Describe(ls_columnname[ll_index] + '_multi.ID')) Then   // 31287 Added support for multi-select on character dropdown
						If Len(Trim(idw_data.Dynamic GetItemString(1, ls_columnname[ll_index] + '_multi'))) > 0 Then
							ls_criteria_values[ll_index] = 'In (' + Trim(idw_data.Dynamic GetItemString(1, ls_columnname[ll_index] + '_multi')) + ')'
						End If
					Else
						ls_criteria_values[ll_index] = '= "' + idw_data.Dynamic GetItemString(1, ls_columnname[ll_index]) + '"'
					end if
				Case Else
					If idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index]) = il_dddw_all_data_column Then Continue
					
					If IsNumber(idw_data.Dynamic Describe(ls_columnname[ll_index] + '_multi.ID')) Then
						If Len(Trim(idw_data.Dynamic GetItemString(1, ls_columnname[ll_index] + '_multi'))) > 0 Then
							ls_criteria_values[ll_index] = 'In (' + Trim(idw_data.Dynamic GetItemString(1, ls_columnname[ll_index] + '_multi')) + ')'
						End If
					Else
						ls_criteria_values[ll_index] = '= ' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index]))
					End If
			End Choose
		Case 'ddlb'
			Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
				Case 'date'
					ls_criteria_values[ll_index] = '= "' + gn_globals.in_string_functions.of_convert_datetime_to_string(idw_data.Dynamic GetItemDateTime(1, ls_columnname[ll_index])) + '"'
				Case 'char'
					If idw_data.Dynamic GetItemString(1, ls_columnname[ll_index]) = is_ddlb_all_data_column Then Continue
					
					ls_criteria_values[ll_index] = '= "' + idw_data.Dynamic GetItemString(1, ls_columnname[ll_index]) + '"'
				Case Else
					If idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index]) = il_dddw_all_data_column Then Continue

					ls_criteria_values[ll_index] = '= ' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index]))
			End Choose
		Case Else
			Choose Case Lower(Trim(Left(ls_style_datatype, 4)))
				Case 'date'
					Choose Case Lower(Trim(ls_style_styletype))
						Case 'between', 'notbetween'
							ldt_fromdate		= idw_data.Dynamic GetItemDateTime(1, ls_columnname[ll_index])
							ldt_todate			= idw_data.Dynamic GetItemDateTime(1, ls_columnname[ll_index] + '_second')
							
						Case 'equal', 'notequal', 'greaterthan', 'lessthan'
							ldt_fromdate		= idw_data.Dynamic GetItemDateTime(1, ls_columnname[ll_index])
					End Choose
					
					If Upper(Trim(ls_style_options)) <> 'Y' Then
						ldt_fromdate		= DateTime(Date(ldt_fromdate), Time('00:00'))
						ldt_todate			= DateTime(Date(ldt_todate), Time('23:59'))
					End If
					
					Choose Case Lower(Trim(ls_style_styletype))
						Case 'equal'
							ls_criteria_values[ll_index] = '= "' + gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_fromdate) + '"'
						Case 'notequal'
							ls_criteria_values[ll_index] = '<>"' + gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_fromdate) + '"'
						Case 'between'
							ls_criteria_values[ll_index] = 'Between "' + gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_fromdate) + '" And "' + gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_todate) + '"'
						Case 'notbetween'
							ls_criteria_values[ll_index] = 'Not Between "' + gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_fromdate) + '" And "' + gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_todate) + '"'
						Case 'greaterthan'
							ls_criteria_values[ll_index] = '>= "' + gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_fromdate) + '"'							
						Case 'lessthan'
							ls_criteria_values[ll_index] = '<= "' + gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_fromdate) + '"'							
						Case 'isnull'
							ls_criteria_values[ll_index] = 'Is Null'
						Case 'isnotnull'
							ls_criteria_values[ll_index] = 'Is Not Null'
					End Choose
				Case 'char'
					Choose Case Lower(Trim(idw_data.Dynamic GetItemString(1, ls_columnname[ll_index] + '_qualifier')))
						Case 'isnull', 'isemptystring', 'isnotnull'
						Case Else
							If Len(String(idw_data.Dynamic GetItemString(1, ls_columnname[ll_index]))) = 0 Then Continue
					End Choose
					
					ls_criteria_values[ll_index] = idw_data.Dynamic GetItemString(1, ls_columnname[ll_index])
					gn_globals.in_string_functions.of_replace_all(ls_criteria_values[ll_index], '"', '""')
					gn_globals.in_string_functions.of_replace_all(ls_criteria_values[ll_index], "'", "''")
					
					Choose Case Lower(Trim(idw_data.Dynamic GetItemString(1, ls_columnname[ll_index] + '_qualifier')))
						Case 'beginswith'
							ls_criteria_values[ll_index] = 'Like "' + ls_criteria_values[ll_index] + '%"'
						Case 'notbeginswith'
							ls_criteria_values[ll_index] = 'Not Like "' + ls_criteria_values[ll_index] + '%"'
						Case 'endswith'
							ls_criteria_values[ll_index] = 'Like "%' + ls_criteria_values[ll_index] + '"'
						Case 'notendswith'
							ls_criteria_values[ll_index] = 'Not Like "%' + ls_criteria_values[ll_index] + '"'
						Case 'contains'
							ls_criteria_values[ll_index] = 'Like "%' + ls_criteria_values[ll_index] + '%"'
						Case 'notcontains'
							ls_criteria_values[ll_index] = 'Not Like "%' + ls_criteria_values[ll_index] + '%"'
						Case 'isnull'
							ls_criteria_values[ll_index] = 'Is Null'
						Case 'isemptystring'
							ls_criteria_values[ll_index] = 'Like ""'
						Case 'isnotnull'
							ls_criteria_values[ll_index] = 'Is Not Null'
						Case Else
							ls_criteria_values[ll_index] = 'Like "' + ls_criteria_values[ll_index] + '"'
					End Choose
				Case Else
					Choose Case Lower(Trim(ls_style_styletype))
						Case 'equal', 'equals'
							ls_criteria_values[ll_index] = '= ' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index]))
						Case 'notequal'
							ls_criteria_values[ll_index] = '<> ' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index]))
						Case 'between'
							ls_criteria_values[ll_index] = 'Between "' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index])) + '" And "' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index] + '_second'))
						Case 'notbetween'
							ls_criteria_values[ll_index] = 'Not Between "' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index])) + '" And "' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index] + '_second'))
						Case 'greaterthan'
							ls_criteria_values[ll_index] = '>= ' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index]))
						Case 'lessthan'
							ls_criteria_values[ll_index] = '<= ' + String(idw_data.Dynamic GetItemNumber(1, ls_columnname[ll_index]))
						Case 'isnull'
							ls_criteria_values[ll_index] = 'Is Null'
						Case 'isnotnull'
							ls_criteria_values[ll_index] = 'Is Not Null'
					End Choose
			End Choose
	End Choose
Next

ll_upperbound 				= Min(UpperBound(ls_criteria_values[]), UpperBound(ls_criteria_arguments[]))
as_criteria_arguments	= ''
as_criteria_values		= ''

For ll_index = 1 To ll_upperbound
	If Len(Trim(ls_criteria_arguments[ll_index])) = 0 Or IsNull(ls_criteria_arguments[ll_index]) Or Len(Trim(ls_criteria_values[ll_index])) = 0 Or IsNull(ls_criteria_values[ll_index]) Then Continue
	
	as_criteria_arguments	= as_criteria_arguments + ls_criteria_arguments[ll_index] + ','
	as_criteria_values		= as_criteria_values + ls_criteria_values[ll_index] + '!@#'
Next

as_criteria_arguments = Left(as_criteria_arguments, Len(as_criteria_arguments) - 1)
as_criteria_values = Left(as_criteria_values, Len(as_criteria_values) - 3)
end subroutine

public subroutine of_init_criteria_datawindow ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_refresh()
// Overview:    This will refresh the data in the dropdowndatawindows
// Created by:  Blake Doerr
// History:     04/02/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_index, ll_row
DatawindowChild ldwc_destination
n_datawindow_tools ln_datawindow_tools
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager
n_date_manipulator ln_date_manipulator
NonVisualObject ln_service
String ls_data_column, ls_display_column
String	ls_columnname
String	ls_editstyle
String	ls_coltype
Long	ll_columncount

If Not ib_ThisIsDynamicCriteriaBuilder Then Return

If IsValid(idw_data.Dynamic GetTransObject()) Then
	idw_data.Dynamic SetTransObject(idw_data.Dynamic GetTransObject())
Else
	idw_data.Dynamic SetTransObject(SQLCA)
End If
idw_data.Dynamic Reset()
idw_data.Dynamic InsertRow(0)
ll_columncount = Long(idw_data.Dynamic Describe("Datawindow.Column.Count"))

//Loop through the column looking for datawindows
For ll_index = 1 To ll_columncount
	ls_columnname 	= idw_data.Dynamic Describe("#" + String(ll_index) + ".Name")
	ls_editstyle 	= Lower(Trim(idw_data.Dynamic Describe(ls_columnname + ".Edit.Style")))
	ls_coltype		= Lower(Trim(idw_data.Dynamic Describe(ls_columnname + ".ColType")))
	If Lower(Trim(ls_columnname)) = 'dummy' Then Continue
	
	Choose Case ls_editstyle
		Case 'dddw'
			
			//Insert a row for the (All) selection
			ls_data_column 	= idw_data.Dynamic Describe(ls_columnname + ".DDDW.DataColumn")
			ls_display_column	= idw_data.Dynamic Describe(ls_columnname + ".DDDW.DisplayColumn")
			
			If ls_data_column = 'none' or ls_display_column = 'none' Then Continue

			idw_data.Dynamic GetChild(ls_columnname, ldwc_destination)
	
			If Not IsNumber(ldwc_destination.Describe(ls_data_column + '.ID')) Then Continue
			
			ll_row = ldwc_destination.InsertRow(1)
	
			Choose Case Left(Lower(ldwc_destination.Describe(ls_data_column + ".ColType")), 4)
				Case	'char', 'stri'
					ldwc_destination.SetItem(ll_row, ls_data_column, is_ddlb_all_data_column)
					
					Choose Case Lower(Trim(Left(ls_coltype, 4)))
						Case 'char'
							idw_data.Dynamic SetItem(1, ls_columnname, is_ddlb_all_data_column)
					End Choose
				Case 'date'
				Case Else 
					ldwc_destination.SetItem(ll_row, ls_data_column, il_dddw_all_data_column)
					
					Choose Case Lower(Trim(Left(ls_coltype, 4)))
						Case 'char', 'stri'
							idw_data.Dynamic SetItem(1, ls_columnname, String(il_dddw_all_data_column))
						Case 'date'
						Case Else
							idw_data.Dynamic SetItem(1, ls_columnname, il_dddw_all_data_column)
					End Choose
			End Choose
			
			If IsNumber(idw_data.Dynamic Describe(ls_columnname + '_multi.ID')) Then
				Choose Case Lower(Trim(Left(ls_coltype, 4)))
					Case 'char', 'stri'
						idw_data.Dynamic SetItem(1, ls_columnname + '_multi', is_ddlb_all_data_column)
					Case 'date'
					Case Else
						idw_data.Dynamic SetItem(1, ls_columnname + '_multi', String(il_dddw_all_data_column))
				End Choose
			End If

			If Not IsNumber(ldwc_destination.Describe(ls_display_column + '.ID')) Then Continue
			
			Choose Case Left(Lower(ldwc_destination.Describe(ls_display_column + ".ColType")), 4)
				Case	'char', 'stri'
					ldwc_destination.SetItem(ll_row, ls_display_column, '(All)')
			End Choose
		Case 'ddlb'
			ln_datawindow_tools = Create n_datawindow_tools
			If ln_datawindow_tools.of_getitem(idw_data, 1, ls_columnname) = '' Then
				If Right(ls_columnname, Len('_qualifier')) = '_qualifier' Then
					idw_data.Dynamic SetItem(1, ls_columnname, 'equals')
				Else
					Choose Case Left(Lower(ls_coltype), 4)
						Case	'char', 'stri', 'date'
							idw_data.Dynamic SetItem(1, ls_columnname, is_ddlb_all_data_column)
						Case Else
							idw_data.Dynamic SetItem(1, ls_columnname, il_dddw_all_data_column)
					End Choose
				End If
			End If
			Destroy ln_datawindow_tools
		Case Else
			If Right(Lower(ls_columnname), Len('_multi')) = '_multi' Then Continue

			Choose Case Left(Lower(ls_coltype), 4)
				Case	'char', 'stri'
					If IsNull(idw_data.Dynamic GetItemString(1, ls_columnname)) Then
						idw_data.Dynamic SetItem(1, ls_columnname, '')
					End If
				Case 'date'
					If IsNull(idw_data.Dynamic GetItemDateTime(1, ls_columnname)) Or Date(idw_data.Dynamic GetItemDateTime(1, ls_columnname)) <= Date(1,1,1900) Then
						If Right(ls_columnname, Len('_second')) = '_second' Then
							idw_data.Dynamic SetItem(1, ls_columnname, ln_date_manipulator.of_get_last_of_month(Today()))
						ElseIf Right(ls_columnname, Len('_second')) <> '_second' And IsNumber(idw_data.Dynamic Describe(ls_columnname + '_second.ID')) Then
							idw_data.Dynamic SetItem(1, ls_columnname, ln_date_manipulator.of_get_first_of_month(Today()))
						Else
							idw_data.Dynamic SetItem(1, ls_columnname, Today())
						End If
					End If
			End Choose
	End Choose
Next

ln_datawindow_graphic_service_manager = idw_data.Dynamic of_get_service_manager()
ln_service = ln_datawindow_graphic_service_manager.of_get_service('n_multi_select_dddw_service')
If IsValid(ln_service) Then
	ln_service.Dynamic of_init(idw_data)
	ln_service.Dynamic Event ue_insert_multi_select_item()
End If

idw_data.Event Dynamic ue_refreshtheme()
end subroutine

public subroutine of_set_batch_mode (boolean ab_batchmode);ib_batchmode = ab_batchmode
end subroutine

public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, string as_columnname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu()
//	Arguments:  am_dynamic 				- The dynamic menu to add to
//					as_objectname			- The name of the object that the menu is being presented for
//					ab_iscolumn				- Whether or not the object is a column
//					ab_iscomputedfield	- Whether or not the object is a computed field
//	Overview:   This will allow this service to create its own menu
//	Created by:	Blake Doerr
//	History: 	3/1/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_upperbound
String	ls_tag
String	ls_type

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions	ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that objects are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not IsValid(idw_data) Then Return
If ib_BatchMode Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a spacer since the menu has items already
//-----------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the Object does not have the alignment property
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('-', '', '', This)

Choose Case Lower(Trim(idw_data.Dynamic Describe(as_objectname + '.Type')))
	Case 'text'
		If ib_ThisIsDynamicCriteriaBuilder Then
			an_menu_dynamic.of_add_item('&Format Label...', 'format', as_objectname, This)
		Else
			an_menu_dynamic.of_add_item('&Format Text...', 'format', as_objectname, This)
		End If
		
		If Pos(as_objectname, '_') > 0 Then
			as_objectname = Lower(Trim(Left(as_objectname, Len(as_objectname) - Pos(Reverse(as_objectname), '_'))))
			
			Choose Case Lower(Trim(idw_data.Dynamic Describe(as_objectname + '.Type')))
				Case 'column'
					as_columnname = as_objectname
					ls_tag = idw_data.Dynamic Describe(as_columnname + ".Tag")
					ls_type = Lower(Trim(gn_globals.in_string_functions.of_find_argument(ls_tag, '||', 'Type')))
					
					If Lower(Trim(ls_type)) = 'external' Then
						If ib_ThisIsDynamicCriteriaBuilder Then
							an_menu_dynamic.of_add_item('&Delete Criteria Column...', 'delete external column', as_columnname, This)
						Else
							an_menu_dynamic.of_add_item('&Delete External Column...', 'delete external column', as_columnname, This)
						End If
					End If
					
					If ib_ThisIsDynamicCriteriaBuilder Then
						an_menu_dynamic.of_add_item('&Format Criteria Column...', 'format', as_objectname, This)
					Else
						an_menu_dynamic.of_add_item('&Format Column...', 'format', as_objectname, This)
					End If
				Case 'compute', 'computedfield'
					ls_tag = idw_data.Dynamic Describe(as_objectname + ".Tag")
					ls_type = Lower(Trim(gn_globals.in_string_functions.of_find_argument(ls_tag, '||', 'Type')))
					
					If Lower(Trim(ls_type)) = 'computed' Then
						If ib_ThisIsDynamicCriteriaBuilder Then
						Else
							an_menu_dynamic.of_add_item('&Delete Computed Column', 'delete column', as_objectname, This)
						End If
					End If
					
					If Left(Lower(Trim(as_objectname)), Len('aggregatecompute_')) <> 'aggregatecompute_' Then
						an_menu_dynamic.of_add_item('&Format Computed Column...', 'format', as_objectname, This)
					End If
					
				Case 'bitmap'
					an_menu_dynamic.of_add_item('&Format Picture...', 'format', as_objectname, This)		
			End Choose			
		End If
	Case 'column'
		ls_tag = idw_data.Dynamic Describe(as_columnname + ".Tag")
		ls_type = Lower(Trim(gn_globals.in_string_functions.of_find_argument(ls_tag, '||', 'Type')))
		
		If Lower(Trim(ls_type)) = 'external' Then
			If ib_ThisIsDynamicCriteriaBuilder Then
				an_menu_dynamic.of_add_item('&Delete Criteria Column', 'delete external column', as_columnname, This)
			Else
				an_menu_dynamic.of_add_item('&Delete External Column', 'delete external column', as_columnname, This)
			End If
		End If

		an_menu_dynamic.of_add_item('&Format Column...', 'format', as_columnname, This)

	Case 'compute', 'computedfield'
		ls_tag = idw_data.Dynamic Describe(as_objectname + ".Tag")
		ls_type = Lower(Trim(gn_globals.in_string_functions.of_find_argument(ls_tag, '||', 'Type')))
		
		If Lower(Trim(ls_type)) = 'computed' Then
			If ib_ThisIsDynamicCriteriaBuilder Then
			Else
				an_menu_dynamic.of_add_item('&Delete Computed Column', 'delete column', as_objectname, This)
			End If
		End If
		
		an_menu_dynamic.of_add_item('&Format Computed Column...', 'format', as_objectname, This)	
	Case 'bitmap'
		an_menu_dynamic.of_add_item('&Format Picture...', 'format', as_objectname, This)		
End Choose

If ib_ThisIsDynamicCriteriaBuilder Then

	If IsNumber(idw_data.Dynamic Describe(idw_data.Dynamic Describe(as_objectname + '.Tag') + '.ID')) Then
		an_menu_dynamic.of_add_item('-', '', '', This)
		an_menu_dynamic.of_add_item('&Add Criteria Column...', 'add external column', '', This)
		an_menu_dynamic.of_add_item('&Delete Criteria Column', 'delete external column', idw_data.Dynamic Describe(as_objectname + '.Tag'), This)
		an_menu_dynamic.of_add_item('&Delete All Criteria', 'delete all criteria', '', This)
		an_menu_dynamic.of_add_item('-', '', '', This)
		an_menu_dynamic.of_add_item('Move Criteria Column &Up', 'move column up', idw_data.Dynamic Describe(as_objectname + '.Tag'), This)
		an_menu_dynamic.of_add_item('Move Criteria Column &Down', 'move column down', idw_data.Dynamic Describe(as_objectname + '.Tag'), This)
	Else
		//an_menu_dynamic.of_add_item('&Format Dynamic Criteria...', 'format', 'datawindow', This)
		an_menu_dynamic.of_add_item('&Add Criteria Column...', 'add external column', '', This)
		an_menu_dynamic.of_add_item('&Delete All Criteria', 'delete all criteria', '', This)
	End If
Else
	an_menu_dynamic.of_add_item('&Format Report...', 'format', 'datawindow', This)
	an_menu_dynamic.of_add_item('&Add External Column...', 'add external column', '', This)
	an_menu_dynamic.of_add_item('&Create Computed Column...', 'create column', '', This)
End If
end subroutine

public function long of_sqlpreview (sqlpreviewfunction request, sqlpreviewtype sqltype, ref string sqlsyntax, dwbuffer buffer, long row);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_null
Long		ll_reportconfigid
Long		ll_position
String	ls_expression
String	ls_database_names
String	ls_criteria_arguments
String	ls_criteria_values
String	ls_criteria_expression
string 	ls_securityenabled
SetNull(ll_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if this is not a select statement or idw_data is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not sqltype = PreviewSelect! Then Return ll_null
If Not IsValid(idw_data) Then Return ll_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the reportconfig id
//-----------------------------------------------------------------------------------------------------------------------------------
ll_reportconfigid = Long(idw_data.Event Dynamic ue_get_rprtcnfgid())

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the report config id is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ll_reportconfigid) Or ll_reportconfigid <= 0 Then Return ll_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the dynamic criteria
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(in_datawindow_formatting_service_dynamic_criteria) Then
	in_datawindow_formatting_service_dynamic_criteria.of_get_dynamic_criteria(ls_criteria_arguments, ls_criteria_values)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the report config id is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression 				= Trim(ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit'))
ls_criteria_expression 	= Trim(ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalCriteriaInit'))
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get additional criteria that might have been added to the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ls_criteria_expression) And ls_criteria_expression <> '' Then
	gn_globals.in_string_functions.of_replace_all(ls_criteria_expression, "~~'", "'")
	gn_globals.in_string_functions.of_replace_all(ls_criteria_expression, '~~"', '"')
	If Left(ls_criteria_expression, 1) 	= '"' Then ls_criteria_expression = Mid(ls_criteria_expression, 2)
	If Left(ls_criteria_expression, 1) 	= "'" Then ls_criteria_expression = Mid(ls_criteria_expression, 2)
	If Right(ls_criteria_expression, 1) = '"' Then ls_criteria_expression = Mid(ls_criteria_expression, 1, Len(ls_criteria_expression) - 1)
	If Right(ls_criteria_expression, 1) = "'" Then ls_criteria_expression = Mid(ls_criteria_expression, 1, Len(ls_criteria_expression) - 1)
	
	If Len(Trim(ls_criteria_arguments)) > 0 And Len(Trim(ls_criteria_values)) > 0 Then
		ls_criteria_arguments 	= ls_criteria_arguments + ',' + Trim(Left(ls_criteria_expression, Pos(ls_criteria_expression, '||') - 1))
		ls_criteria_values		= ls_criteria_values + '!@#' + Trim(Mid(ls_criteria_expression, Pos(ls_criteria_expression, '||') + 2))
	Else
		ls_criteria_arguments 	= Trim(Left(ls_criteria_expression, Pos(ls_criteria_expression, '||') - 1))
		ls_criteria_values		= Trim(Mid(ls_criteria_expression, Pos(ls_criteria_expression, '||') + 2))
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the database names from the expression, that's all the procedure cares about
//-----------------------------------------------------------------------------------------------------------------------------------
ls_database_names 				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'dbname'))
If IsNull(ls_database_names) Then ls_database_names = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the criteria arguments and values
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_criteria_arguments)) > 0 And Len(Trim(ls_criteria_values)) > 0 Then
	ls_database_names = ls_database_names + '<CriteriaArguments>' + ls_criteria_arguments + '<CriteriaValues>' + ls_criteria_values
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there's nothing to add to the sql
//-----------------------------------------------------------------------------------------------------------------------------------
//ls_securityenabled = gn_globals.in_cache.of_get_value('ReportConfig','ApplyRowLevelSecurity','reportid',ll_reportconfigid)
if isnull(ls_securityenabled) or ls_securityenabled = '' then ls_securityenabled = 'N'
If Len(Trim(ls_database_names)) <= 0 and ls_SecurityEnabled = 'N' Then Return ll_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the arguments to the stored procedure call
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(Lower(sqlsyntax), Lower('@vc_AdditionalColumns')) > 0 Then
	sqlsyntax = Trim(Left(sqlsyntax, Pos(Lower(sqlsyntax), Lower('@vc_AdditionalColumns')) - 1))
	
	If Pos(Lower(sqlsyntax), Lower('@i_RprtCnfgID')) > 0 Then
		sqlsyntax = Trim(Left(sqlsyntax, Pos(Lower(sqlsyntax), Lower('@i_RprtCnfgID')) - 1))
	End If

	If Right(sqlsyntax, 1) = ',' Then
		sqlsyntax = Left(sqlsyntax, Len(sqlsyntax) - 1)
	End If
End If

If Pos(Lower(sqlsyntax), Lower('@vc_AdditionalColumns')) > 0 Then
Else
	If Pos(Lower(sqlsyntax), '@') = 0 Then
		sqlsyntax = sqlsyntax + " @vc_AdditionalColumns='" + ls_database_names + "'"
	Else
		sqlsyntax = sqlsyntax + ", @vc_AdditionalColumns='" + ls_database_names + "'"
	End If	
End If

If Pos(Lower(sqlsyntax), Lower('@i_RprtCnfgID')) > 0 Then
Else
	sqlsyntax = sqlsyntax + ', @i_RprtCnfgID=' + String(ll_reportconfigid)
End If

Return 99
end function

public function string of_transpose_datawindow_syntax (datastore ads_source, string as_transposeinit);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  ads_source 			- the datastore that has your basic query info (from and where clauses)
//					as_transposeinit	- a string containing the init data for the transpose on the dw
//	Overview:   A process to generate a derivation of a datawindow that transposes rows data into column data.
//					Currently we only support transposing one column's row values into columns.  In other words,
//					if your sql contains a select for all rows of Col A, B and C, we can only transpose that
//					dataset into columns for just one column (A, B, or C), but not all columns.
//	Created by:	Jeff Hardcastle
//	History: 	11/04/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string		ls_syntax, ls_from, ls_where, ls_transposedcolumn, ls_newsyntax
string		ls_transposedcolumndddw, ls_transposeddisplaydddw, ls_transposeddisplaycolumn
string		ls_transposeddatacolumn
string		ls_transposedcolumndatatype, ls_transposedcolumndisplay
string		ls_transposeddisplay, ls_error, ls_sql, ls_newselect, ls_newsql, ls_table
string		ls_columnname[], ls_columnnameoriginal[], ls_dddwattributes[]
long			ll_counter, ll_pos

datastore				lds_distinctlist, lds_transposed, lds_displayname
n_datastore_tools		ln_datastore_tools
//n_string_functions 	ln_string
n_datawindow_syntax	ln_dw_syntax


//-----------------------------------------------------------------------------------------------------------------------------------
// Get the initial sql from the datastore.  We'll salvage the from and where clauses, but we'll have to 
// rebuild the select from the transposeinit data.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = ads_source.describe('datawindow.syntax')
ll_pos = pos(ls_syntax, 'TABLE(NAME=~~"') + 13

ls_table = mid(ls_syntax, ll_pos, pos(ls_syntax, '~"', ll_pos) - ll_pos - 1)

// strip of the "dbo." if it is there
if pos(ls_table, 'dbo.') > 0 then
	ls_table = right(ls_table, len(ls_table) - 4)
end if

ls_from = ' from ' + ls_table
if isnull(ls_from) or ls_from = '' then return ''


ls_transposedcolumn = left(as_transposeinit, pos(as_transposeinit, '=') - 1)
ls_transposedcolumndatatype = ads_source.describe(ls_transposedcolumn + '.coltype')
ls_transposedcolumndddw = right(as_transposeinit, len(as_transposeinit) - pos(as_transposeinit, '='))

if ls_transposedcolumndddw <> '' and ls_transposedcolumn <> 'string' then
	gn_globals.in_string_functions.of_parse_string(ls_transposedcolumndddw, '|', ls_dddwattributes[])

	if upperbound(ls_dddwattributes[]) < 3 then
		ls_transposedcolumndddw = ''
	else
		ls_transposeddisplaydddw 	= ls_dddwattributes[1]
		ls_transposeddatacolumn 	= ls_dddwattributes[2]
		ls_transposeddisplaycolumn = ls_dddwattributes[3]
	end if	
else
	ls_transposedcolumndddw=''
end if


//-----------------------------------------------------------------------------------------------------------------------------------
// now create a new datastore that holds the distinct list of row data that we are putting into columns
//-----------------------------------------------------------------------------------------------------------------------------------
ls_sql = 'select distinct ' + ls_transposedcolumn + ' ' + ls_from + ' ' + ls_where

lds_distinctlist = CREATE datastore
ln_datastore_tools = CREATE n_datastore_tools

ln_datastore_tools.of_create_datastore_object(ls_sql, lds_distinctlist )
destroy ln_datastore_tools

if lds_distinctlist.rowcount() <= 0 then
	destroy lds_distinctlist
	return ''
end if

//-----------------------------------------------------------------------------------------------------------------------------------
// now simply loop through our distinct list and get our column names
//-----------------------------------------------------------------------------------------------------------------------------------
for ll_counter = 1 to lds_distinctlist.rowcount()
	choose case lower(left(ls_transposedcolumndatatype, 4))
		case 'char'
			ls_columnname[ll_counter] = lds_distinctlist.getitemstring(ll_counter, ls_transposedcolumn)
		case 'numb', 'long'
			ls_columnname[ll_counter] = string(lds_distinctlist.getitemnumber(ll_counter, ls_transposedcolumn))
		case 'date'
			ls_columnname[ll_counter] = string(lds_distinctlist.getitemdate(ll_counter, ls_transposedcolumn))

	end choose
next


//-----------------------------------------------------------------------------------------------------------------------------------
// Now loop through all the names and replace invalid characters
//-----------------------------------------------------------------------------------------------------------------------------------
ls_columnnameoriginal = ls_columnname

for ll_counter = 1 to UpperBound(ls_columnname[])
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],' ','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],'\','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],'/','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],':','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],',','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],'=','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],'-','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],'_','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],'.','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],'&','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],'%','')
	gn_globals.in_string_functions.of_replace_all(ls_columnname[ll_counter],'+','')
next 


//-----------------------------------------------------------------------------------------------------------------------------------
// now simply loop through our column names and create a new sql statement that will hold all the columns
//-----------------------------------------------------------------------------------------------------------------------------------
ls_newselect = 'select '

for ll_counter = 1 to upperbound(ls_columnname[])
	choose case lower(left(ls_transposedcolumndatatype, 4))
		case 'char'
			ls_newselect = ls_newselect  + ' ' + ls_columnname[ll_counter] + ' = convert(varchar, null), '
		case 'numb', 'long'
			ls_newselect = ls_newselect  + ' ' + ls_columnname[ll_counter] + ' = convert(int, null), '
		case 'date'
			ls_newselect = ls_newselect  + ' ' + ls_columnname[ll_counter] + ' = convert(smalldatetime, null), '
	end choose
	
	
next

// chop off the last space and comma
ls_newselect = left(ls_newselect, len(ls_newselect) - 2)
ls_newsql = ls_newselect + ls_from + ' where 1=2'

if isvalid(lds_distinctlist) then destroy lds_distinctlist


//-----------------------------------------------------------------------------------------------------------------------------------
// Now create a new datastore that will hold our new dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
ls_newsyntax = SQLCA.syntaxfromsql(ls_newsql, '', ls_error)
if ls_error <> '' or ls_newsyntax = '' then return ''

lds_transposed = CREATE datastore
lds_transposed.create(ls_newsyntax)


//-----------------------------------------------------------------------------------------------------------------------------------
// Now destory all the PB created columns and rebuild our syntax using the display object 
// listed in the transposeinit arg
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_counter = 1 To UpperBound(ls_columnname[])
	ls_syntax 	= "destroy " + ls_columnname[ll_counter]
	ls_error 	= lds_transposed.Modify(ls_syntax)
	if ls_error <> '' then return ''
	
	ls_syntax 	= "destroy " + ls_columnname[ll_counter] + '_t'
	ls_error 	= lds_transposed.Modify(ls_syntax)
	if ls_error <> '' then return ''
	
	ls_syntax 	= 'text(band=detail alignment="1" text="' + ls_columnnameoriginal[ll_counter] + '" border="0" color="0" x="571" y="8" height="56" width="250"  name=' + ls_columnname[ll_counter] + '_srt font.face="Tahoma" font.height="-8" font.weight="700" font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127")'
	ls_error 	= lds_transposed.Modify("Create " + ls_syntax)
	if ls_error <> '' then return ''

	if ls_transposedcolumndddw <> '' then
		ls_syntax	= 'column(band=detail id=' + string (ll_counter)  + ' alignment="0" tabsequence=160 border="5" color="0" x="613" y="8" height="52" width="635" name=' + ls_columnname[ll_counter] + ' format="[General]"  dddw.name= ' + ls_transposeddisplaydddw + ' dddw.displaycolumn = ' +  ls_transposeddisplaycolumn + ' dddw_datacolumn = ' + ls_transposeddatacolumn + ' dddw.percentwidty=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=no dddw.case=any dddw.required=yes dddw.vscrollbar=yes font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
	else
		ls_syntax	= 'column(band=detail id=' + string (ll_counter)  + ' alignment="0" tabsequence=160 border="5" color="0" x="613" y="8" height="52" width="635" name=' + ls_columnname[ll_counter] + ' format="[General]"  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
	end if
	
	ls_error 	= lds_transposed.Modify("Create " + ls_syntax)
	if ls_error <> '' then return ''

next

ls_syntax = lds_transposed.Describe("DataWindow.Syntax")

For ll_counter = 1 To UpperBound(ls_columnname[])
	If ls_columnname[ll_counter] = ls_columnnameoriginal[ll_counter] Then Continue
	gn_globals.in_string_functions.of_replace_all(ls_syntax,'dbname="' + ls_columnname[ll_counter] + '"','dbname="' + ls_columnnameoriginal[ll_counter] + '"')
Next

gn_globals.in_string_functions.of_replace_all(ls_syntax,'dbname="','dbname="' + ls_table + '.')

return ls_syntax

end function

on n_datawindow_formatting_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datawindow_formatting_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

