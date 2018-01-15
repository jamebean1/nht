$PBExportHeader$u_dynamic_conversion_strip.sru
forward
global type u_dynamic_conversion_strip from u_dynamic_gui
end type
type dw_uom_conversion from u_datawindow within u_dynamic_conversion_strip
end type
end forward

global type u_dynamic_conversion_strip from u_dynamic_gui
integer width = 3072
integer height = 88
boolean border = false
long backcolor = 12632256
long tabbackcolor = 12632256
event ue_post_uom pbm_custom02
event type string ue_get_default_string ( )
dw_uom_conversion dw_uom_conversion
end type
global u_dynamic_conversion_strip u_dynamic_conversion_strip

type variables
Protected:
	PowerObject  	ipo[]
	Long				il_currentviewid
	Boolean			ib_DisplayCurrencyConversion	= True
	Boolean			ib_BatchMode						= True
	Boolean			ib_ConstructorHasHappened		= False
	
	Blob		iblob_currentstate
	String	is_dataobjectname						= ''
	Boolean	ib_statestored 						= False
end variables

forward prototypes
protected subroutine of_save_defaults ()
public subroutine of_setitem (string as_column, string as_value)
public function string of_getitem (string as_columnname)
public subroutine of_display_currency_conversion (boolean ab_displaycurrencyconversion)
public subroutine of_post_constructor ()
public function string of_get_data ()
protected subroutine of_restore_defaults ()
protected subroutine of_save_default (string name, string data)
public function string of_save_view (string as_viewname)
public function long of_get_current_view_id ()
public function string of_convert (powerobject apo)
public function string of_convert ()
public subroutine of_set_data (string as_data)
public subroutine of_init (powerobject ao_datasource)
public subroutine of_save_state ()
public subroutine of_restore_state ()
end prototypes

event ue_post_uom;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_post_uom
// Overrides:  No
// Overview:   Stub event for developers to put code that will execute after the user selects a uom to convert to.
// Created by: Lynn Reiners
// History:    12/17/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

end event

event type string ue_get_default_string();Return This.of_get_data()
end event

protected subroutine of_save_defaults ();//n_string_functions ln_string_functions

This.of_save_default('currencyid', String(dw_uom_conversion.GetItemNumber(1, 'currencyid')))
This.of_save_default('showexchangedate', dw_uom_conversion.GetItemString(1, 'showexchangedate'))
This.of_save_default('exchangedate', gn_globals.in_string_functions.of_convert_datetime_to_string(dw_uom_conversion.GetItemDateTime(1, 'exchangedate')))
This.of_save_default('showpricinguomconversion', dw_uom_conversion.GetItemString(1, 'showpricinguomconversion'))
This.of_save_default('pricinguomid', String(dw_uom_conversion.GetItemNumber(1, 'pricinguomid')))
This.of_save_default('uomid', String(dw_uom_conversion.GetItemNumber(1, 'uomid')))
This.of_save_default('period', dw_uom_conversion.GetItemString(1, 'period'))

end subroutine

public subroutine of_setitem (string as_column, string as_value);This.of_set_data(as_column + '=' + as_value)
end subroutine

public function string of_getitem (string as_columnname);String	ls_return
n_datawindow_tools ln_datawindow_tools

ln_datawindow_tools = Create n_datawindow_tools

ls_return = ln_datawindow_tools.of_getitem(dw_uom_conversion, 1, Lower(Trim(as_columnname)))

Destroy ln_datawindow_tools

Return ls_return
end function

public subroutine of_display_currency_conversion (boolean ab_displaycurrencyconversion);ib_DisplayCurrencyConversion = ab_DisplayCurrencyConversion

If ib_DisplayCurrencyConversion Then
	dw_uom_conversion.SetItem(1, 'hidecurrencyconversion', 'N')
Else
	dw_uom_conversion.SetItem(1, 'hidecurrencyconversion', 'Y')
End If
end subroutine

public subroutine of_post_constructor ();Long	ll_index

ib_ConstructorHasHappened = True

For ll_index = 1 To UpperBound(ipo[])
	This.of_init(ipo[ll_index])
Next


end subroutine

public function string of_get_data ();//n_string_functions ln_string_functions
String	ls_default_string

If ib_DisplayCurrencyConversion Then
	If Not IsNull(dw_uom_conversion.GetItemNumber(1, 'currencyid')) Then
		ls_default_string = ls_default_string + 'currencyid=' + String(dw_uom_conversion.GetItemNumber(1, 'currencyid')) + '||'
	Else
		ls_default_string = ls_default_string + 'currencyid=||'
	End If
	
	If Not IsNull(dw_uom_conversion.GetItemString(1, 'showexchangedate')) Then
		ls_default_string = ls_default_string + 'showexchangedate=' + dw_uom_conversion.GetItemString(1, 'showexchangedate') + '||'
	End If
	
	If Not IsNull(dw_uom_conversion.GetItemDateTime(1, 'exchangedate')) Then
		ls_default_string = ls_default_string + 'exchangedate=' + gn_globals.in_string_functions.of_convert_datetime_to_string(dw_uom_conversion.GetItemDateTime(1, 'exchangedate')) + '||'
	End If
End If

If Upper(Trim(dw_uom_conversion.GetItemString(1, 'showpricinguomconversion'))) = 'Y' And Upper(Trim(dw_uom_conversion.GetItemString(1, 'usepriceuomconversion'))) = 'Y' Then
	ls_default_string = ls_default_string + 'showpricinguom=Y||'
Else
	ls_default_string = ls_default_string + 'showpricinguom=N||'
End If

If Not IsNull(dw_uom_conversion.GetItemNumber(1, 'pricinguomid')) Then
	ls_default_string = ls_default_string + 'pricinguom=' + String(dw_uom_conversion.GetItemNumber(1, 'pricinguomid')) + '||'
End If

If Not IsNull(dw_uom_conversion.GetItemNumber(1, 'uomid')) Then
	ls_default_string = ls_default_string + 'uom=' + String(dw_uom_conversion.GetItemNumber(1, 'uomid')) + '||'
End If

If Upper(Trim(dw_uom_conversion.GetItemString(1, 'showperiodconversion'))) = 'Y' And Not IsNull(dw_uom_conversion.GetItemString(1, 'period')) Then
	ls_default_string = ls_default_string + 'uomperiod=' + dw_uom_conversion.GetItemString(1, 'period') + '||'
Else
	ls_default_string = ls_default_string + 'uomperiod=month||'	
End If
ls_default_string = Left(ls_default_string, Len(ls_default_string) - 2)

Return ls_default_string
end function

protected subroutine of_restore_defaults ();//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_value
Long		ll_null
SetNull(ll_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
DatawindowChild ldwc_child
//n_string_functions ln_string_functions
n_registry ln_registry

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the UOM ID
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = ln_registry.of_get_user_value('Default\UOM', '2')
If Long(ls_value) > 0 Then
	dw_uom_conversion.GetChild('uomid', ldwc_child)
	If IsValid(ldwc_child) Then
		If ldwc_child.Find('UOM = ' + ls_value, 1, ldwc_child.RowCount()) > 0 Then
			dw_uom_conversion.SetItem(1, 'uomid', Long(ls_value))
		End If
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the period
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = ln_registry.of_get_user_value('Default\Period', 'month')
dw_uom_conversion.SetItem(1, 'period', ls_value)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the currency
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = ln_registry.of_get_user_value('Default\CurrencyID')

If Long(ls_value) > 0 Then
	dw_uom_conversion.GetChild('currencyid', ldwc_child)
	If IsValid(ldwc_child) Then
		If ldwc_child.Find('CrrncyID = ' + ls_value, 1, ldwc_child.RowCount()) > 0 Then
			dw_uom_conversion.SetItem(1, 'CurrencyID', Long(ls_value))
		End If
	End If
ElseIf Trim(ls_value) = '' Then
	dw_uom_conversion.SetItem(1, 'CurrencyID', ll_null)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the show exchange date flag
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = ln_registry.of_get_user_value('Default\ShowExchangeDate', 'N')
dw_uom_conversion.SetItem(1, 'ShowExchangeDate', ls_value)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the exchange date
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = ln_registry.of_get_user_value('Default\ExchangeDate', String(Today()))
dw_uom_conversion.SetItem(1, 'ExchangeDate', gn_globals.in_string_functions.of_Convert_String_To_DateTime(ls_value))

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the ShowPricingUOM flag
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = ln_registry.of_get_user_value('Default\ShowPricingUOMConversion', 'N')
dw_uom_conversion.SetItem(1, 'ShowPricingUOMConversion', ls_value)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the pricing UOM
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = ln_registry.of_get_user_value('Default\PricingUOMID', '3')
If Long(ls_value) > 0 Then
	dw_uom_conversion.GetChild('PricingUOMID', ldwc_child)
	If IsValid(ldwc_child) Then
		If ldwc_child.Find('UOM = ' + ls_value, 1, ldwc_child.RowCount()) > 0 Then
			dw_uom_conversion.SetItem(1, 'PricingUOMID', Long(ls_value))
		End If
	End If
End If
end subroutine

protected subroutine of_save_default (string name, string data);n_registry ln_registry

Choose Case Lower(Trim(name))
	Case 'uomid'
		ln_registry.of_set_user_value('Default\UOM', data)
	Case 'period'
		ln_registry.of_set_user_value('Default\Period', data)
	Case 'currencyid'
		If IsNull(data) Then data = ''
		ln_registry.of_set_user_value('Default\CurrencyID', data)
	Case 'showexchangedate'
		ln_registry.of_set_user_value('Default\ShowExchangeDate', data)
	Case 'exchangedate'
		ln_registry.of_set_user_value('Default\ExchangeDate', data)
	Case 'showpricinguomconversion'
		ln_registry.of_set_user_value('Default\ShowPricingUOMConversion', data)
	Case 'pricinguomid'
		ln_registry.of_set_user_value('Default\PricingUOMID', data)
End Choose

end subroutine

public function string of_save_view (string as_viewname);n_report_criteria_default_engine ln_report_criteria_default_engine
ln_report_criteria_default_engine = Create n_report_criteria_default_engine
ln_report_criteria_default_engine.of_set_using_custom_default_string(True)
ln_report_criteria_default_engine.of_init(This, 0, gn_globals.il_userid, 'UOM/Currency')
ln_report_criteria_default_engine.of_save_defaults(This, 0, gn_globals.il_userid, as_viewname)
il_currentviewid = ln_report_criteria_default_engine.of_get_current_view_id()
Destroy ln_report_criteria_default_engine

Return String(il_currentviewid)
end function

public function long of_get_current_view_id ();Return il_currentviewid
end function

public function string of_convert (powerobject apo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_convert
//	Arguments:  None
//	Overview:   Tells all of the visible conversion objects to convert their registered objects using their current
//					settings
//	Created by:	Scott Creed
//	History: 	7.20.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String				ls_errormessage
NonVisualObject	ln_service

ln_service = apo.Dynamic of_get_service('n_datawindow_conversion_service')
If IsValid(ln_service) Then
	ln_service.Dynamic of_set(This.of_get_data())
	ln_service.Dynamic of_convert()
	ls_errormessage = ln_service.Dynamic of_get_errormessage()
	
	If ls_errormessage > '' And Not ib_BatchMode Then
		gn_globals.in_messagebox.of_messagebox('The following problem was reported by the unit of measure converter for at least one conversion:~r~n~r~n' + ls_errormessage, exclamation!, ok!, 1)
	End If
End If

Return ''
end function

public function string of_convert ();Any 	lany_temp
Long	ll_index
lany_temp = ''

For ll_index = 1 To UpperBound(ipo[])
	If Not IsValid(ipo[ll_index]) Then Continue
	
	This.of_convert(ipo[ll_index])
Next

This.TriggerEvent('ue_post_uom')

If IsValid(io_parent) Then 
	io_parent.Dynamic Event ue_notify('UnitOfMeasure Changed', '')
	io_parent.Dynamic Event ue_notify('Currency Changed', '')
End If

Return ''
end function

public subroutine of_set_data (string as_data);//n_string_functions ln_string_functions
String	ls_value[]
String	ls_argument[]
Long		ll_null
Long		ll_index
SetNull(ll_null)

gn_globals.in_string_functions.of_parse_arguments(as_data, '||', ls_argument[], ls_value[])

For ll_index = 1 To UpperBound(ls_argument[])
	Choose Case Lower(Trim(ls_argument[ll_index]))
		Case 'currencyid'
			If Trim(ls_value[ll_index]) = '' Then
				dw_uom_conversion.SetItem(1, 'currencyid', ll_null)
			Else
				dw_uom_conversion.SetItem(1, 'currencyid', Long(ls_value[ll_index]))
			End If
		Case 'showexchangedate'
			dw_uom_conversion.SetItem(1, 'showexchangedate', ls_value[ll_index])
		Case 'exchangedate'
			dw_uom_conversion.SetItem(1, 'exchangedate', gn_globals.in_string_functions.of_convert_string_to_datetime(ls_value[ll_index]))
		Case 'showpricinguom'
			dw_uom_conversion.SetItem(1, 'showpricinguomconversion', ls_value[ll_index])
		Case 'pricinguom'
			dw_uom_conversion.SetItem(1, 'pricinguomid', Long(ls_value[ll_index]))
		Case 'uom', 'uomid'
			dw_uom_conversion.SetItem(1, 'uomid', Long(ls_value[ll_index]))
		Case 'uomperiod'
			dw_uom_conversion.SetItem(1, 'period', ls_value[ll_index])
		Case 'usepricinguom'
			dw_uom_conversion.SetItem(1, 'usepriceuomconversion', ls_value[ll_index])
		Case 'usecurrencyconversion'
			dw_uom_conversion.SetItem(1, 'usecurrencyconversion', ls_value[ll_index])
	End Choose
Next

If Pos(Lower(as_data), 'showexchangedate') = 0 And Pos(as_data, '||') > 0 Then
	dw_uom_conversion.SetItem(1, 'showexchangedate', 'N')
End If
end subroutine

public subroutine of_init (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	11/19/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_upperbound
Long		ll_rowcount

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
NonVisualObject ln_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the upperbound
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound  = UpperBound(ipo[]) + 1

//-----------------------------------------------------------------------------------------------------------------------------------
// See if the object has already been initialized
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ipo[])
	If Not IsValid(ipo[ll_index]) Then Continue
	If ipo[ll_index] = ao_datasource Then ll_upperbound = ll_index
Next

If Not ib_ConstructorHasHappened Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the conversion service and determine if there are price and currency conversion columns
//-----------------------------------------------------------------------------------------------------------------------------------
ln_service = ao_datasource.Dynamic of_get_service('n_datawindow_conversion_service')
If Not IsValid(ln_service) Then
	If IsNumber(ao_datasource.Dynamic Describe('uominit.X')) Then
		ao_datasource.Dynamic of_add_service('n_datawindow_conversion_service')
		ao_datasource.Dynamic of_create_services()
		ln_service = ao_datasource.Dynamic of_get_service('n_datawindow_conversion_service')
	End If
End If

If Not IsValid(ln_service) Then Return

ib_batchmode = ln_service.Dynamic of_get_batchmode()

//-----------------------------------------------------------------------------------------------------------------------------------
// Subscribe if this is the first time this object has been initialized
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_upperbound > UpperBound(ipo[]) Then
	gn_globals.in_subscription_service.of_subscribe(This, 'After View Restored', ao_datasource)
	gn_globals.in_subscription_service.of_subscribe(This, 'Get UOM/Currency View', ao_datasource)
	gn_globals.in_subscription_service.of_subscribe(This, 'apply uom/currency view', ao_datasource)
End If

ipo[ll_upperbound]  = ao_datasource

//-----------------------------------------------------------------------------------------------------------------------------------
// Change settings on the strip if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = dw_uom_conversion.RowCount()
If ln_service.Dynamic of_AllowCurrencySelection() And Upper(Trim(dw_uom_conversion.GetItemString(1, 'usecurrencyconversion'))) = 'N' Then dw_uom_conversion.SetItem(1, 'usecurrencyconversion', 'Y')
//If ln_service.Dynamic of_AreThereCurrencyColumns() And Upper(Trim(dw_uom_conversion.GetItemString(1, 'showexchangedate'))) = 'N' Then dw_uom_conversion.SetItem(1, 'showexchangedate', 'Y')
If ln_service.Dynamic of_AreTherePriceColumns() And Upper(Trim(dw_uom_conversion.GetItemString(1, 'usepriceuomconversion'))) = 'N' Then dw_uom_conversion.SetItem(1, 'usepriceuomconversion', 'Y')
If ln_service.Dynamic of_aretherequantityconversioncolumns() And Upper(Trim(dw_uom_conversion.GetItemString(1, 'useuomconversion'))) = 'N' Then dw_uom_conversion.SetItem(1, 'useuomconversion', 'Y')
If ln_service.Dynamic of_aretherequantityconversioncolumns() And Upper(Trim(dw_uom_conversion.GetItemString(1, 'showuomconversion'))) = 'N' Then dw_uom_conversion.SetItem(1, 'showuomconversion', 'Y')
If ln_service.Dynamic of_aretherestartdatecolumns() And Upper(Trim(dw_uom_conversion.GetItemString(1, 'showperiodconversion'))) = 'N' Then dw_uom_conversion.SetItem(1, 'showperiodconversion', 'Y')

ln_service.Dynamic of_set(This.of_get_data())

end subroutine

public subroutine of_save_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   This will save the state as a blob object in memory to save objects
//	Created by:	Blake Doerr
//	History: 	12/15/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_syntax

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the state is already stored
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_statestored Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Empty datawindow syntax, may be needed later
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = 'release 9;&
datawindow(units=0 timer_interval=0 color=1073741824 processing=0)&
summary(height=0 color="536870912" )&
footer(height=0 color="536870912" )&
detail(height=0 color="536870912" )&
table(column=(type=char(10) updatewhereclause=yes name=test dbname="test" )&
 )'

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the full state into the blob object
//-----------------------------------------------------------------------------------------------------------------------------------
dw_uom_conversion.GetFullState(iblob_currentstate)

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
is_dataobjectname = dw_uom_conversion.DataObject

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dataobject to empty string in order to clear the objects
//-----------------------------------------------------------------------------------------------------------------------------------
dw_uom_conversion.DataObject = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Set that the state is stored
//-----------------------------------------------------------------------------------------------------------------------------------
ib_statestored = True
end subroutine

public subroutine of_restore_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   This will restored the datawindow state from the blob object variable
//	Created by:	Blake Doerr
//	History: 	12/15/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// If the state is not stored, return
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_statestored Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// If the dataobject name is valid, set the dataobject to preserve the variable on the control
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(is_dataobjectname) > 0 Then dw_uom_conversion.DataObject = is_dataobjectname

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the full state of the dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(iblob_currentstate) > 0 Then
	dw_uom_conversion.SetFullState(iblob_currentstate)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the transaction object
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(dw_uom_conversion.GetTransObject()) Then
	dw_uom_conversion.SetTransObject(dw_uom_conversion.GetTransObject())
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the current state blob object to null to save memory
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(iblob_currentstate)

//-----------------------------------------------------------------------------------------------------------------------------------
// Turn off the state stored boolean
//-----------------------------------------------------------------------------------------------------------------------------------
ib_statestored = False
end subroutine

on u_dynamic_conversion_strip.create
int iCurrent
call super::create
this.dw_uom_conversion=create dw_uom_conversion
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_uom_conversion
end on

on u_dynamic_conversion_strip.destroy
call super::destroy
destroy(this.dw_uom_conversion)
end on

event constructor;This.Event ue_refreshtheme()
end event

event ue_refreshtheme();call super::ue_refreshtheme;If IsValid(gn_globals.in_theme) Then
	This.BackColor = gn_globals.in_theme.of_get_barcolor()
	dw_uom_conversion.Modify("Datawindow.Color = '" + String(gn_globals.in_theme.of_get_barcolor()) +  "'")
End If
end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   Pass this message right along to the parent if it is valid
// Created by: Blake Doerr
// History:    6/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_return
n_bag 	ln_bag
w_reportconfig_manage_views lw_reportconfig_manage_views
n_report_criteria_default_engine ln_report_criteria_default_engine
PowerObject	lpo_argument
		
Choose Case Lower(Trim(as_message))
	Case 'restore view'
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ln_report_criteria_default_engine.of_set_using_custom_default_string(True)
		ln_report_criteria_default_engine.of_init(This, 0, gn_globals.il_userid, 'UOM/Currency')
		ln_report_criteria_default_engine.Event ue_notify('restore view', as_arg)
		il_currentviewid = ln_report_criteria_default_engine.of_get_current_view_id()
		Destroy ln_report_criteria_default_engine
		This.of_convert()
		This.of_save_defaults()
		
	Case 'apply view', 'apply uom/currency view'
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ln_report_criteria_default_engine.of_set_using_custom_default_string(True)
		ln_report_criteria_default_engine.of_init(This, 0, gn_globals.il_userid, 'UOM/Currency')
		ln_report_criteria_default_engine.of_restore_defaults(This, Long(as_arg))
		il_currentviewid = ln_report_criteria_default_engine.of_get_current_view_id()
		Destroy ln_report_criteria_default_engine

		This.of_convert()
		This.of_save_defaults()
		
	Case 'save view as'
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ln_report_criteria_default_engine.of_set_using_custom_default_string(True)
		ln_report_criteria_default_engine.of_init(This, 0, gn_globals.il_userid, 'UOM/Currency')
		ln_report_criteria_default_engine.Event ue_notify('save view as', as_arg)
		il_currentviewid = ln_report_criteria_default_engine.of_get_current_view_id()
		Destroy ln_report_criteria_default_engine
		
	Case 'get uom/currency view'
		If Not IsValid(Message.PowerObjectParm) Then Return
		If Not Lower(Trim(ClassName(Message.PowerObjectParm))) = 'n_bag' Then Return
		
		ln_bag = Message.PowerObjectParm

		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ln_report_criteria_default_engine.of_set_using_custom_default_string(True)
		ln_report_criteria_default_engine.of_init(This, 0, gn_globals.il_userid, 'UOM/Currency')
		ll_return = ln_report_criteria_default_engine.of_save_defaults(This)
		Destroy ln_report_criteria_default_engine

		If Not IsNull(ll_return) And ll_return > 0 Then
			ln_bag.of_set('UOM/Currency View ID', ll_return)
		End If
		
	Case 'manage uom/currency views'
		ln_bag = Create n_bag
		ln_bag.of_set('RprtCnfgID', 0)
		ln_bag.of_set('type', 'uom/currency')
			
		OpenWithParm(lw_reportconfig_manage_views, ln_bag, 'w_reportconfig_manage_views', w_mdi)
		
	Case 'restore defaults'
		This.of_set_data(String(as_arg))
		This.of_convert()
		
		This.of_save_defaults()		
	Case 'after view restored'
		If Lower(Trim(ClassName(as_arg))) <> 'string' And Not IsNull(as_arg) Then
			lpo_argument = as_arg
			This.of_init(lpo_argument)
			This.of_convert(lpo_argument)
		End If
	Case Else
		If IsValid(io_parent) Then
			io_parent.Event Dynamic ue_notify(as_message, as_arg)
		End If
End Choose
end event

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Resize
//	Overrides:  No
//	Arguments:	
//	Overview:   Repositions the objects in this strip when this object is resized
//	Created by: Scott Creed
//	History:    7.19.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

dw_uom_conversion.X = This.Width - dw_uom_conversion.Width

end event

event rbuttondown;call super::rbuttondown;Window lw_window
m_dynamic lm_dynamic_menu

String	ls_views[]
Long		ll_index

n_report_criteria_default_engine ln_report_criteria_default_engine


lm_dynamic_menu = Create m_dynamic
lm_dynamic_menu.of_set_object(This)

lm_dynamic_menu.of_add_item('&Save UOM/Currency View As...', 'save view as', '')
lm_dynamic_menu.of_add_item('&Manage UOM/Currency Views...', 'manage uom/currency views', '')

ln_report_criteria_default_engine = Create n_report_criteria_default_engine
ln_report_criteria_default_engine.of_get_views(ls_views[], 0, gn_globals.il_userid, 'UOM/Currency')
Destroy ln_report_criteria_default_engine

If UpperBound(ls_views[]) > 0 Then
	lm_dynamic_menu.of_add_item('-', '', '')
	
	For ll_index = 1 To UpperBound(ls_views[])
		lm_dynamic_menu.of_add_item(ls_views[ll_index], 'restore view', ls_views[ll_index])
	Next
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Promote the datawindow to Get the parent window of the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
lw_window = This.of_getparentwindow()

//----------------------------------------------------------------------------------------------------------------------------------
// Pop the menu differently based on the window type
//-----------------------------------------------------------------------------------------------------------------------------------
if lw_window.windowtype = Response! Or lw_window.windowtype = Popup! Or Not isvalid(w_mdi.getactivesheet()) Or (w_mdi.getactivesheet() <> lw_window) then
	lm_dynamic_menu.popmenu(lw_window.pointerx(), lw_window.pointery())
else
	lm_dynamic_menu.popmenu(w_mdi.pointerx(), w_mdi.pointery())
end if

end event

event destructor;call super::destructor;This.of_save_defaults()
end event

type dw_uom_conversion from u_datawindow within u_dynamic_conversion_strip
integer y = 4
integer width = 2999
integer height = 88
integer taborder = 31
string dataobject = "d_gui_uomconversion"
boolean border = false
end type

event rbuttondown;call super::rbuttondown;Parent.TriggerEvent('rbuttondown')
end event

event itemchanged;call super::itemchanged;if AncestorReturnValue <> 0 Then Return AncestorReturnValue
Parent.of_save_default(dwo.name, data)
Parent.Post of_convert()
end event

event constructor;call super::constructor;//If gb_runningasaservice Then
//	This.DataObject = 'd_gui_uomconversion_web'
//End If

This.SetTransObject(SQLCA)
This.of_add_service('n_dropdowndatawindow_caching_service')
This.of_add_service('n_dropdowndatawindow_caching_service')
This.of_add_service('n_calendar_column_service')
This.of_add_service('n_autofill')
This.of_create_services()
This.InsertRow(0)
Parent.of_restore_defaults()
Parent.of_post_constructor()
end event

event clicked;call super::clicked;If IsValid(dwo) Then
	Choose Case Lower(Trim(dwo.Name))
		Case 't_period'
			If Upper(Trim(This.GetItemString(1, 'showperiodconversion'))) = 'Y' And Upper(Trim(This.GetItemString(1, 'useuomconversion'))) = 'Y' Then
				If Lower(Trim(This.GetItemString(1, 'period'))) = 'month' Then
					This.SetItem(1, 'period', 'day')
					Parent.of_save_default('period', 'day')
				Else
					This.SetItem(1, 'period', 'month')
					Parent.of_save_default('period', 'month')
				End If
				
				Parent.of_Convert()
			End If
			
	End Choose
End If
end event

