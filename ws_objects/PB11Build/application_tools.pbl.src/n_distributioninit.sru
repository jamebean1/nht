$PBExportHeader$n_distributioninit.sru
forward
global type n_distributioninit from nonvisualobject
end type
end forward

global type n_distributioninit from nonvisualobject
end type
global n_distributioninit n_distributioninit

type variables
Public ProtectedWrite String	Expression

Public ProtectedWrite String	DistributionMethod[]
Public ProtectedWrite String	DistributionOptions[]

Public ProtectedWrite Long		DistributionListContactID[]
Public ProtectedWrite String	DistributionListDistributionMethod[]
Public ProtectedWrite String	DistributionListDistributionOptions[]

//Private	n_string_functions in_string_functions
end variables

forward prototypes
public function string of_validate_gui (powerobject ao_datasource, ref long al_row, ref string as_column)
public function string of_init (string as_distributioninit)
public subroutine of_reset ()
public subroutine of_delete_options (string as_distributionmethod)
public function boolean of_distributioninit_exists (powerobject ao_datasource)
public function string of_restore_options (powerobject ao_datasource)
public function string of_get_expression (string as_distributionmethod)
public function string of_get_expression ()
public function string of_get_evaluated_distributioninit (powerobject ao_datasource)
public function string of_save_options (powerobject ao_datasource)
public function string of_evaluate (powerobject ao_datasource)
public function string of_append (string as_distributioninit)
public subroutine of_apply_to_gui (powerobject ao_datasource)
public subroutine of_set_gui (powerobject ao_datasource)
public function string of_set_distributionlists (string as_commadelimiteddistributionlistids)
public function n_distributioninit of_clone ()
end prototypes

public function string of_validate_gui (powerobject ao_datasource, ref long al_row, ref string as_column);////----------------------------------------------------------------------------------------------------------------------------------
////	Function:	of_validate_gui()
////	Overview:   This will validate the data in the gui
////	Created by:	Blake Doerr
////	History: 	9/6/2002 - First Created 
////-----------------------------------------------------------------------------------------------------------------------------------
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// Local Variables
////-----------------------------------------------------------------------------------------------------------------------------------
//Long	ll_index
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// Materialize the data into variables
////-----------------------------------------------------------------------------------------------------------------------------------
//This.of_set_gui(ao_datasource, ao_datasource2)
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// Loop through the sets of conversion data and check for problems
////-----------------------------------------------------------------------------------------------------------------------------------
//For ll_index = 1 To UpperBound(SourceColumn[])
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	// Make sure they select a source column
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	If IsNull(SourceColumn[ll_index]) Or SourceColumn[ll_index] = '' Or SourceColumn[ll_index] = '(none)' Then
//		al_row = ll_index
//		as_column = 'sourcecolumn'
//		Return 'You must select a source column'
//	End If
//
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	// Make sure they select a destination column
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	If IsNull(DestinationColumn[ll_index]) Or DestinationColumn[ll_index] = '' Or DestinationColumn[ll_index] = '(none)' Then
//		al_row = ll_index
//		as_column = 'destinationcolumn'
//		Return 'You must select a destination column'
//	End If
//
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	// Make sure they select a conversion type
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	If IsNull(ConvertType[ll_index]) Or ConvertType[ll_index] = '' Or ConvertType[ll_index] = '(none)' Then
//		al_row = ll_index
//		as_column = 'converttype'
//		Return 'You must select a conversion type'
//	End If
//Next
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// If they want rounding, make sure they have a valid number of decimal places
////-----------------------------------------------------------------------------------------------------------------------------------
//If Not IsNull(UseRounding) And Upper(Trim(UseRounding)) = 'Y' Then
//	If Decimals < 0 Then
//		al_row 		= 1
//		as_column 	= 'userounding'
//		Return 'You must pick a valid number of decimal places for rounding'
//	End If
//End If
//
Return ''
end function

public function string of_init (string as_distributioninit);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init
//	Arguments:  as_uominit - The uominit field
//	Overview:   Materializes the uominit field into variables
//	Created by:	Blake Doerr
//	History: 	9/5/2002 - First Created
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_pos
String	ls_null
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_bag ln_bag

This.of_reset()
Expression					= as_distributioninit

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse on the @@@ so we can look at the distribution method.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(as_distributioninit, "@@@", DistributionOptions[])

For ll_index = 1 To UpperBound(DistributionOptions[])
	DistributionMethod[ll_index] = gn_globals.in_string_functions.of_find_argument(DistributionOptions[ll_index], '||', 'distributionmethod')
	if pos(lower(DistributionOptions[ll_index]),'distributionmethod') = 1 then
		ll_pos = pos(DistributionOptions[ll_index],'||')
		DistributionOptions[ll_index] = mid(DistributionOptions[ll_index],ll_pos + 2)
	end if
//	in_string_functions.of_replace_argument('distributionmethod', DistributionOptions[ll_index], '||', ls_null)
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public subroutine of_reset ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_reset
//	Overview:   Resets the object
//	Created by:	Blake Doerr
//	History: 	9/5/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the variables on this object
//-----------------------------------------------------------------------------------------------------------------------------------
DistributionMethod[]					= ls_empty[]
DistributionOptions[]				= ls_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Do not reset the distribution list arrays, they need to persist.  The code that relies on this is n_report.of_distribute().
//-----------------------------------------------------------------------------------------------------------------------------------

end subroutine

public subroutine of_delete_options (string as_distributionmethod);Long	ll_index

For ll_index = 1 To UpperBound(DistributionMethod[])
	If Lower(Trim(as_distributionmethod)) = Lower(Trim(DistributionMethod[ll_index])) Then
		DistributionOptions[ll_index]	= ''
	End If
Next
end subroutine

public function boolean of_distributioninit_exists (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_can_apply
//	Arguments:  ao_datasource - the datastore or datawindow to extract the uom information from
//	Overview:   If the distributioninit field is done the old way, we need to make sure we don't overwrite
//	Created by:	Blake Doerr
//	History: 	9/5/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_expression

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools	ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the expression from the datasource
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the distribution init field out of the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
If ln_datawindow_tools.of_iscomputedfield(ao_datasource, "distributioninit") Then
	Destroy ln_datawindow_tools
	Return True
ElseIf ln_datawindow_tools.of_iscolumn(ao_datasource,"distributioninit") Then
	Destroy ln_datawindow_tools
	Return True
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the value from the of_init function
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
Return False
end function

public function string of_restore_options (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init
//	Arguments:  ao_datasource - the datastore or datawindow to extract the uom information from
//	Overview:   Materializes the uominit field into variables
//	Created by:	Blake Doerr
//	History: 	9/5/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_expression

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools	ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return 'Error:  Datasource was not valid'

Choose Case ao_datasource.TypeOf()
	Case Datawindow!, Datastore!
	Case Else
		Return 'Error:  Cannot restore options from non datawindow type'
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the expression from the datasource
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the distribution init field out of the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
If ln_datawindow_tools.of_iscomputedfield(ao_datasource, "distributionoptionsinit") Then
	ls_expression = ln_datawindow_tools.of_get_expression(ao_datasource, 'distributionoptionsinit', True)
	ao_datasource.Dynamic Modify("Destroy distributionoptionsinit")
End If

Destroy ln_datawindow_tools

gn_globals.in_string_functions.of_replace_all(ls_expression, '&dq;', '"')
gn_globals.in_string_functions.of_replace_all(ls_expression, '&sq;', "'")

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the value from the of_init function
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_expression
end function

public function string of_get_expression (string as_distributionmethod);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_expression()
//	Created by:	Blake Doerr
//	History: 	9/6/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_distributioninit

//-----------------------------------------------------------------------------------------------------------------------------------
// There's a possibility that the as_distributionmethod arg will be in name=value form. So, check for this also.
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(as_distributionmethod,"@@@") > 0 Then
	ls_distributioninit = Mid(as_distributionmethod,Pos(as_distributionmethod,"@@@") + 3)
	as_distributionmethod = Left(as_distributionmethod,Pos(as_distributionmethod,"@@@") - 1)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// There's a possibility that the as_distributionmethod arg will be in name=value form. So, check for this also.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Pos(as_distributionmethod, "=") > 0 Then
		as_distributionmethod = Mid(as_distributionmethod, Pos(as_distributionmethod, "=") + 1)
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the method to the init information and append to this object so it will override everything else
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(Trim(ls_distributioninit)) > 0 And Not IsNull(ls_distributioninit) And Len(Trim(as_distributionmethod)) > 0 And Not IsNull(as_distributionmethod) Then
		ls_distributioninit = 'distributionmethod=' + as_distributionmethod + '||' + ls_distributioninit
		
		This.of_append(ls_distributioninit)
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// There's a possibility that the as_distributionmethod arg will be in name=value form. So, check for this also.
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(as_distributionmethod, "=") > 0 Then
	as_distributionmethod = Mid(as_distributionmethod, Pos(as_distributionmethod, "=") + 1)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the distribution information for this method
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(DistributionMethod[]), UpperBound(DistributionOptions[]))
	If Lower(Trim(DistributionMethod[ll_index])) = Lower(Trim(as_distributionmethod)) Then Return DistributionOptions[ll_index]
Next

Return ''
end function

public function string of_get_expression ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_expression()
//	Overview:   This will return the new uominit expression
//	Created by:	Blake Doerr
//	History: 	9/6/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_distributioninit

For ll_index = 1 To UpperBound(DistributionOptions[])
	If Left(DistributionOptions[ll_index], 2) = '||' Then DistributionOptions[ll_index] = Mid(DistributionOptions[ll_index], 3)
	
	If Len(DistributionOptions[ll_index]) > 0 Then
		If Not IsNull(DistributionMethod[ll_index]) Then
			ls_distributioninit = ls_distributioninit + 'DistributionMethod=' + Trim(DistributionMethod[ll_index]) + '||' + DistributionOptions[ll_index] + '@@@'
		Else
			ls_distributioninit = ls_distributioninit + DistributionOptions[ll_index] + '@@@'
		End If
	Else
		If Not IsNull(DistributionMethod[ll_index]) Then
			ls_distributioninit = ls_distributioninit + 'DistributionMethod=' + Trim(DistributionMethod[ll_index]) + '@@@'
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove the last column
//-----------------------------------------------------------------------------------------------------------------------------------
ls_distributioninit = Left(ls_distributioninit, Len(ls_distributioninit) - 3)
gn_globals.in_string_functions.of_replace_all(ls_distributioninit, '&dq;', '"')
gn_globals.in_string_functions.of_replace_all(ls_distributioninit, '&sq;', "'")

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the expression
//-----------------------------------------------------------------------------------------------------------------------------------

Expression = ls_distributioninit
Return ls_distributioninit
end function

public function string of_get_evaluated_distributioninit (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_evaluated_distributioninit
//	Arguments:  ao_datasource - the datastore or datawindow to extract the uom information from
//	Overview:   Returns the distributioninit field evaluated based on the data
//	Created by:	Blake Doerr
//	History: 	9/5/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_expression

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools	ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return 'Error:  Datasource was not valid'

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the expression from the datasource
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the distribution init field out of the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
If ln_datawindow_tools.of_iscomputedfield(ao_datasource, "distributioninit") Then
	ls_expression = String(ao_datasource.Dynamic Describe("Evaluate('distributioninit',1)"))
ElseIf ln_datawindow_tools.of_iscolumn(ao_datasource,"distributioninit") Then
	If Long(ao_datasource.Dynamic RowCount()) > 0 Then
		ls_expression = ln_datawindow_tools.of_getitem(ao_datasource, 1, "distributioninit")
	End If
End If

gn_globals.in_string_functions.of_replace_all(ls_expression, '&dq;', '"')
gn_globals.in_string_functions.of_replace_all(ls_expression, '&sq;', "'")

Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the value from the of_init function
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_expression
end function

public function string of_save_options (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init
//	Arguments:  ao_datasource - the datastore or datawindow to extract the uom information from
//	Overview:   Materializes the uominit field into variables
//	Created by:	Blake Doerr
//	History: 	9/5/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_expression
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools	ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return 'Error:  Datasource was not valid'

Choose Case ao_datasource.TypeOf()
	Case Datawindow!, Datastore!
	Case Else
		Return 'Error:  Cannot save options in non datawindow type'
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the expression from the datasource
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = This.of_get_expression()
gn_globals.in_string_functions.of_replace_all(ls_expression, '"', '&dq;')
gn_globals.in_string_functions.of_replace_all(ls_expression, "'", '&sq;')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the distribution init field out of the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = ln_datawindow_tools.of_set_expression(ao_datasource, 'distributionoptionsinit', ls_expression)

Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the value from the of_init function
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

public function string of_evaluate (powerobject ao_datasource);Long		ll_index
Long		i
Long		ll_start
Long		ll_end
String	ls_expression
String	ls_distributionoptions
String	ls_object[]
String	ls_syntax = 'release 9;&
datawindow(units=0 timer_interval=0 color=16777215 processing=0 HTMLDW=no print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 96 print.margin.bottom = 96 print.paper.source = 0 print.paper.size = 0 print.prompt=no print.buttons=no print.preview.buttons=no )&
summary(height=0 color="536870912" )&
footer(height=0 color="536870912" )&
detail(height=0 color="536870912" )&
table(column=(type=char(10) updatewhereclause=yes name=dummy dbname="dummy" )&
 )&
htmltable(border="1" )&
htmlgen(clientevents="1" clientvalidation="1" clientcomputedfields="1" clientformatting="0" clientscriptable="0" generatejavascript="1" )'

PowerObject lo_datasource
DatawindowChild	ldwc_childreport
n_datawindow_tools ln_datawindow_tools
Datastore lds_datastore

If Not Pos(Lower(Expression), '<expression>') > 0 Then Return Expression
If Not IsValid(ao_datasource) Then Return Expression

Choose Case ao_datasource.TypeOf()
	Case Datawindow!, Datastore!
		lo_datasource	= ao_datasource

		If Long(lo_datasource.Dynamic describe("DataWindow.Processing")) = 5 Then
			ln_datawindow_tools = Create n_datawindow_tools
			ln_datawindow_tools.of_get_objects(lo_datasource, 'report', ls_object[], False)
			Destroy ln_datawindow_tools
			
			If UpperBound(ls_object[]) > 0 Then
				lo_datasource.Dynamic GetChild(ls_object[1], ldwc_childreport)
				If IsValid(ldwc_childreport) Then
					lo_datasource = ldwc_childreport
				End If
			End If
		End If
	Case Else
		lds_datastore	= Create Datastore
		lds_datastore.Create(ls_syntax)
		lo_datasource	= lds_datastore
		
End Choose


For ll_index = 1 To UpperBound(DistributionOptions[])
	Do While Pos(Lower(DistributionOptions[ll_index]), '<expression>') > 0 And Pos(Lower(DistributionOptions[ll_index]), '</expression>') > 0
		ll_start 	= Pos(Lower(DistributionOptions[ll_index]), '<expression>')
		ll_end 		= Pos(Lower(DistributionOptions[ll_index]), '</expression>') + Len('</expression>')
		
		ls_expression = Mid(DistributionOptions[ll_index], ll_start, ll_end - ll_start)
		ls_expression = Right(ls_expression, Len(ls_expression) - Len('<expression>'))
		ls_expression = Left(ls_expression, Len(ls_expression) - Len('</expression>'))
		
		gn_globals.in_string_functions.of_replace_all(ls_expression, '&dq;', '"')
		gn_globals.in_string_functions.of_replace_all(ls_expression, '&sq;', "'")
		gn_globals.in_string_functions.of_replace_all(ls_expression, '"', '~~"')
				
		ls_expression = lo_datasource.Dynamic Describe("Evaluate(~"" + ls_expression + "~", 1)")
		
		DistributionOptions[ll_index] = Left(DistributionOptions[ll_index], ll_start - 1) + ls_expression + Mid(DistributionOptions[ll_index], ll_end)
	Loop
Next

If IsValid(lds_datastore) Then Destroy lds_datastore

Return ''
end function

public function string of_append (string as_distributioninit);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_append
//	Arguments:  as_uominit - The uominit field
//	Overview:   Materializes the uominit field into variables
//	Created by:	Blake Doerr
//	History: 	9/5/2002 - First Created
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_found
Long		ll_index
Long		ll_pos
Long		i
Long		ll_upperbound
String	ls_null
String	ls_DistributionMethod[]
String	ls_DistributionOptions[]
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse on the @@@ so we can look at the distribution method.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(as_distributioninit, "@@@", ls_DistributionOptions[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through and determine the distribution methods and remove the argument from the options
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_DistributionOptions[])
	ls_DistributionMethod[ll_index] = gn_globals.in_string_functions.of_find_argument(ls_DistributionOptions[ll_index], '||', 'distributionmethod')
	if pos(lower(ls_DistributionOptions[ll_index]),'distributionmethod') = 1 then
		ll_pos = pos(ls_DistributionOptions[ll_index],'||')
		ls_DistributionOptions[ll_index] = mid(ls_DistributionOptions[ll_index],ll_pos + 2)
	end if
//	in_string_functions.of_replace_argument('distributionmethod', ls_DistributionOptions[ll_index], '||', ls_null)
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the upperbound of the options
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound	= Min(UpperBound(DistributionOptions[]), UpperBound(DistributionMethod[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the current options and append where necessary, or create new ones
//-----------------------------------------------------------------------------------------------------------------------------------
For i = 1 To UpperBound(ls_DistributionOptions[])
	For ll_index = 1 To ll_upperbound
		If Lower(Trim(DistributionMethod[ll_index])) = Lower(Trim(ls_DistributionMethod[i])) Then
			If Len(Trim(DistributionOptions[ll_index])) > 0 And Not IsNull(DistributionOptions[ll_index]) Then
				If Len(Trim(ls_DistributionOptions[i])) > 0 And Not IsNull(ls_DistributionOptions[i]) Then
					DistributionOptions[ll_index] = DistributionOptions[ll_index] + '||' + ls_DistributionOptions[i]
				End If
			Else
				If Len(Trim(ls_DistributionOptions[i])) > 0 And Not IsNull(ls_DistributionOptions[i]) Then
					DistributionOptions[ll_index] = ls_DistributionOptions[i]
				End If
			End If
			lb_found = True
			Exit
		End If
	Next
	
	If Not lb_found Then
		DistributionMethod[UpperBound(DistributionMethod[]) + 1]	= ls_DistributionMethod[i]
		DistributionOptions[UpperBound(DistributionMethod[])]		= ls_DistributionOptions[i]
	Else
		lb_found = False
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Build the expression
//-----------------------------------------------------------------------------------------------------------------------------------
Expression = This.of_get_expression()

//-----------------------------------------------------------------------------------------------------------------------------------
// Return
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public subroutine of_apply_to_gui (powerobject ao_datasource);Long		ll_index
Long		ll_index2
String	ls_distributioninit

For ll_index = 1 To ao_datasource.Dynamic RowCount()
	ao_datasource.Dynamic SetItem(ll_index, 'DistributionInit', '')
	
	For ll_index2 = 1 To UpperBound(DistributionMethod[])
		If Lower(Trim(DistributionMethod[ll_index2])) = Lower(Trim(ao_datasource.Dynamic GetItemString(ll_index, 'DistributionMethod'))) Then
			ls_distributioninit = ao_datasource.Dynamic GetItemString(ll_index, 'DefaultDistributionOptions')
			
			gn_globals.in_string_functions.of_replace_all(ls_distributioninit, '&dq;', '"')
			gn_globals.in_string_functions.of_replace_all(ls_distributioninit, '&sq;', "'")
		
			If Len(Trim(ls_distributioninit)) > 0 Then
				DistributionOptions[ll_index2] = ls_distributioninit + '||' + DistributionOptions[ll_index2]
			End If
			
			ao_datasource.Dynamic SetItem(ll_index, 'DistributionInit', DistributionOptions[ll_index2])
			Exit
		End If
	Next
Next

end subroutine

public subroutine of_set_gui (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_gui()
//	Arguments:  ao_datasource	- The source for the numbered uom arguments
//					ao_datasource2	- The source for the other uom arguments
//	Overview:   This will get the information from the GUI and materialize it
//	Created by:	Blake Doerr
//	History: 	9/6/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_index
String	ls_distributioninit
String	ls_options
String	ls_null
SetNull(ls_null)

This.of_reset()

If Not IsValid(ao_datasource) Then Return

For ll_index = 1 To ao_datasource.Dynamic RowCount()
	//If Upper(Trim(ao_datasource.Dynamic GetItemString(ll_index, 'UseThisOption'))) <> 'Y' Then Continue
	
	ls_distributioninit	= ls_distributioninit + 'DistributionMethod=' + ao_datasource.Dynamic GetItemString(ll_index, 'DistributionMethod')
	ls_options				= ao_datasource.Dynamic GetItemString(ll_index, 'DistributionInit')

	If  Len(Trim(ls_options)) > 0 Then
		gn_globals.in_string_functions.of_replace_argument('distributionmethod', ls_options, '||', ls_null)
		ls_distributioninit = ls_distributioninit + '||' + ls_options
	End If
	
	ls_distributioninit = ls_distributioninit + '@@@'
Next

This.of_init(Left(ls_distributioninit, Len(ls_distributioninit) - 3))
end subroutine

public function string of_set_distributionlists (string as_commadelimiteddistributionlistids);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore lds_datastore
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_empty[]
Long		ll_empty[]
Long	ll_index
Long	ll_index2
String	ls_distributionmethods[]
String	ls_distributionmethodlist

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear out the distribution lists
//-----------------------------------------------------------------------------------------------------------------------------------
DistributionListContactID[]				= ll_empty[]
DistributionListDistributionMethod[]	= ls_empty[]
DistributionListDistributionOptions[]	= ls_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore and retrieve for the distribution list IDs
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore = Create Datastore
lds_datastore.DataObject = 'd_distributioninit_distributionlists'
lds_datastore.SetTransObject(SQLCA)

//-----------------------------------------------------------------------------------------------------------------------------------
// If rows are retrieved, pull them into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
If lds_datastore.Retrieve(as_commadelimiteddistributionlistids) > 0 Then
	DistributionListContactID[]				= lds_datastore.Object.CntctID.Primary
	DistributionListDistributionMethod[]	= lds_datastore.Object.DistributionMethods.Primary
	DistributionListDistributionOptions[]	= lds_datastore.Object.DistributionOptions.Primary
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy lds_datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the contacts and make sure the list of distribution methods is unique
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(DistributionListContactID[])
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Continue if there is only one method anyway
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Pos(DistributionListDistributionMethod[ll_index], ',') <= 0 Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Clear out the working variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_distributionmethods[] 	= ls_empty[]
	ls_distributionmethodlist	= ''
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse the distribution methods into an array
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_parse_string(DistributionListDistributionMethod[ll_index], ',', ls_distributionmethods[])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Rebuild the arrays with only the unique methods
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index2 = 1 To UpperBound(ls_distributionmethods[])
		If Pos(',' + Lower(Trim(ls_distributionmethodlist)) + ',', ',' + Lower(Trim(ls_distributionmethods[ll_index2])) + ',') > 0 Then Continue
		ls_distributionmethodlist = ls_distributionmethodlist + ls_distributionmethods[ll_index2] + ','
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the new list back into the array
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_distributionmethodlist = Left(ls_distributionmethodlist, Len(ls_distributionmethodlist) - 1)
	DistributionListDistributionMethod[ll_index] = ls_distributionmethodlist
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public function n_distributioninit of_clone ();n_distributioninit ln_distributioninit

ln_distributioninit = Create n_distributioninit

ln_distributioninit.of_init(This.Expression)

Return ln_distributioninit

end function

on n_distributioninit.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_distributioninit.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

