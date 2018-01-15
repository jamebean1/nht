$PBExportHeader$n_aggregation_service.sru
forward
global type n_aggregation_service from nonvisualobject
end type
type str_aggregates from structure within n_aggregation_service
end type
end forward

type str_aggregates from structure
	string		s_column
	string		s_expression[]
	string		s_label[]
	string		s_defaultlabel[]
end type

global type n_aggregation_service from nonvisualobject
event ue_notify ( string as_message,  any aany_argument )
end type
global n_aggregation_service n_aggregation_service

type variables
Private:
	str_aggregates	istr_aggregate[]
	
Protected:
	PowerObject idw_data
	Boolean		ib_batchmode = False
	boolean		ib_hassubscribed=FALSE
	boolean		ib_labels=TRUE
	long			il_computes=0
	long			il_labels=0
	long			il_x_offset=0
	long			il_rowheight
	long			il_originalfooterheight
	Long			il_originalfooteroffset
	long			il_originaltrailerheight[]
	Long			il_count
	string		is_aggregateinit
	string		is_computes[]

end variables

forward prototypes
public subroutine of_set_labels ()
public subroutine of_recreate_view (n_bag an_bag)
public function long of_find_column (string as_column)
public subroutine of_remove_aggregate (string as_column)
public function boolean of_get_aggregateinit ()
public subroutine of_update_aggregateinit ()
public subroutine of_init (powerobject adw_data)
public subroutine of_destroy_objects ()
public subroutine of_aggregate ()
public subroutine of_add_aggregate (string as_column, string as_expression, string as_label)
public subroutine of_set_batch_mode (boolean ab_batchmode)
public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield)
end prototypes

event ue_notify(string as_message, any aany_argument);
string	ls_expression, ls_column, ls_label, ls_return, ls_expressionlabel
n_bag 	ln_bag
NonVisualObject	ln_nonvisual_window_opener

choose case lower(as_message)
	Case 'before view saved'
	case 'after view restored'
		This.of_init(idw_data)
		//this.of_aggregate()
	case 'before group by happened'
		this.of_destroy_objects()
	case 'columnresize'
		this.of_aggregate()
	case 'visible columns changed'
		this.of_aggregate()
	case 'group by happened'
		this.of_aggregate()
	case 'remove'
		this.of_remove_aggregate( string(aany_argument))
		this.of_aggregate()
	case 'toggle labels'
		ib_labels = not ib_labels
		This.of_update_aggregateinit()
		this.of_aggregate()
	case 'recreate view - aggregation'
		this.of_recreate_view(Message.PowerObjectParm)
	case else
		ls_column = string(aany_argument)
		
		Choose Case Lower(Trim(as_message))
			Case 'weighted average'
				ls_label = 'Wght Avg:'
				ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
				ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_aggregation_weighted_average_column', idw_data)
				Destroy ln_nonvisual_window_opener
				ls_return = Message.StringParm
				If Lower(Trim(ls_return)) = 'error:' Then Return
				
				ls_expression = 'Sum(' + string(aany_argument) + ' * Abs(' + ls_return + ') For All) / Sum(Abs(' + ls_return + ') For All)'
				
			Case 'custom'
				ls_label = 'Custom:'
		
				ln_bag = Create n_bag
				ln_bag.of_set('datasource', idw_data)
				ln_bag.of_set('title', 'Select the Expression for the Custom Aggregate')
				ln_bag.of_set('expression', string(aany_argument))
				ln_bag.of_set('NameIsRequired', 'yes')
				ln_bag.of_set('ExpressionNameLabel', 'Label for Aggregate:')
				ln_bag.of_set('ExpressionDefaultName', ls_label)
				ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
				ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_custom_expression_builder', ln_bag)
				Destroy ln_nonvisual_window_opener

				If Not IsValid(ln_bag) Then Return
	
				ls_expression 			= String(ln_bag.of_get('datawindowexpression'))
				ls_expressionlabel 	= String(ln_bag.of_get('ExpressionLabel'))
				If Not IsNull(ls_expressionlabel) And Len(Trim(ls_expressionlabel)) > 0 Then
					ls_label = ls_expressionlabel
				End If
	
				If IsValid(ln_bag) Then
					Destroy ln_bag
				End If
		
			Case Else
				Choose Case Lower(Trim(idw_data.Dynamic Describe(ls_column + '.Edit.Style')))
					Case 'dddw', 'ddlb'
						If Lower(Trim(as_message)) <> 'count' Then
							ls_expression = as_message + '(LookupDisplay(' + string(aany_argument) + ') For All)'
						Else
							ls_expression = as_message + '(' + string(aany_argument) + ' For All)'				
						End If
					Case Else
						ls_expression = as_message + '(' + string(aany_argument) + ' For All)'				
				End Choose
				ls_label = as_message + ":"
		End Choose
		
		this.of_add_aggregate(ls_column, ls_expression, ls_label)
		this.of_aggregate()
end choose

return
end event

public subroutine of_set_labels ();long	ll_column, ll_label

for ll_column = 1 to upperbound( istr_aggregate[])
	for ll_label = 1 to upperbound( istr_aggregate[ll_column].s_defaultlabel[])
		if ib_labels then 
			istr_aggregate[ll_column].s_label[ll_label] = istr_aggregate[ll_column].s_defaultlabel[ll_label]
		else
			istr_aggregate[ll_column].s_label[ll_label] = ''
		end if
	next
next

return
end subroutine

public subroutine of_recreate_view (n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_recreate_view()
// Arguments:   adw_data	The datawindow to process
// Overview:    This will initialize the object
// Created by:   
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
Datastore	lds_OriginalDatawindow
Datastore	lds_ViewDatawindow
Datastore	lds_NewDatawindow

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_OriginalDatawindow
String	ls_ViewDatawindow
String	ls_NewDatawindow

String	ls_aggregateinit

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are any problems
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_bag) Or Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datawindow tools and the three datawindows
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools 		= Create n_datawindow_tools
lds_OriginalDatawindow	= Create Datastore
lds_ViewDatawindow		= Create Datastore
lds_NewDatawindow			= Create Datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the three versions of the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_OriginalDatawindow	= an_bag.of_get('Original Syntax')
ls_ViewDatawindow			= an_bag.of_get('View Syntax')
ls_NewDatawindow			= an_bag.of_get('New Syntax')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the syntaxes are invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_OriginalDatawindow)) = 0 Or Len(Trim(ls_ViewDatawindow)) = 0 Or Len(Trim(ls_NewDatawindow)) = 0 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the syntaxes to the datastores
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_apply_syntax(lds_OriginalDatawindow, ls_OriginalDatawindow)
ln_datawindow_tools.of_apply_syntax(lds_ViewDatawindow, ls_ViewDatawindow)
ln_datawindow_tools.of_apply_syntax(lds_NewDatawindow, ls_NewDatawindow)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if any of the dataobjects are invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lds_OriginalDatawindow.Object) Or Not IsValid(lds_ViewDatawindow.Object) Or Not IsValid(lds_NewDatawindow.Object) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the changes to the datawindow to idw_data
//-----------------------------------------------------------------------------------------------------------------------------------
ls_aggregateinit = ln_datawindow_tools.of_get_expression(lds_NewDatawindow,'aggregateinit')

if isnull(ls_aggregateinit) or ls_aggregateinit = '' or ls_aggregateinit <> '?' or ls_aggregateinit <> '!' then
	ls_aggregateinit = ln_datawindow_tools.of_get_expression(lds_ViewDatawindow,'aggregateinit')
end if

ln_datawindow_tools.of_set_expression(idw_data, 'aggregateinit', ls_aggregateinit)

this.of_get_aggregateinit()
this.of_aggregate()

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
Destroy lds_OriginalDatawindow
Destroy lds_ViewDatawindow
Destroy lds_NewDatawindow
end subroutine

public function long of_find_column (string as_column);
long	ll_i

for ll_i = 1 to upperbound( istr_aggregate[])
	if Lower(Trim(istr_aggregate[ll_i].s_column)) = Lower(Trim(as_column)) then
		return ll_i
	end if
next

return 0
end function

public subroutine of_remove_aggregate (string as_column);
long		ll_column
string	ls_empty[]
str_aggregates	lstr_aggregate_empty[]

If Lower(Trim(as_column)) = 'all of them' Then
	istr_aggregate[] = lstr_aggregate_empty[]
Else
	ll_column = this.of_find_column( as_column)
	
	if ll_column > 0 then
		istr_aggregate[ll_column].s_column = ''
		istr_aggregate[ll_column].s_expression[] = ls_empty[]
		istr_aggregate[ll_column].s_label[] = ls_empty[]
		istr_aggregate[ll_column].s_defaultlabel[] = ls_empty[]
	end if
End If

this.of_update_aggregateinit()

return
end subroutine

public function boolean of_get_aggregateinit ();//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
boolean		lb_continue=TRUE
long			ll_equal_pos
long			ll_i, ll_j, ll_empty[], ll_index
string		ls_init[]
string		ls_column, ls_expression, ls_label
string		ls_parms[], ls_name, ls_value
string		ls_temp
String		ls_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions	ln_string
n_bag						ln_bag
n_datawindow_tools	ln_tools
str_aggregates	lstr_empty[]


istr_aggregate[] = lstr_empty[]
il_originaltrailerheight[] = ll_empty[]
is_computes[] = ls_empty[]
il_computes = 0

ln_tools = create n_datawindow_tools
is_aggregateinit = ln_tools.of_get_expression(idw_data,'aggregateinit')
destroy ln_tools

if is_aggregateinit = '' or is_aggregateinit = '?' or is_aggregateinit = '!' Or IsNull(is_aggregateinit) then
	is_aggregateinit = ''
	Return False
End If

ln_bag = create n_bag

if is_aggregateinit > '' then
	gn_globals.in_string_functions.of_parse_string( is_aggregateinit, "||", ls_parms[])

	//if upperbound(ls_parms[]) = 0 then RETURN
	
	for ll_i = 1 to upperbound(ls_parms)
		ls_name = Trim(left(ls_parms[ll_i], pos(ls_parms[ll_i], "=") - 1))
		ls_value = Trim(mid(ls_parms[ll_i], pos(ls_parms[ll_i], "=") + 1, 99999))
		ln_bag.of_set( ls_name, ls_value)
	next
end if

ll_i = 1
lb_continue=TRUE
do while lb_continue
	
	ls_column = Trim(Lower(string(ln_bag.of_get( 'column' + string(ll_i)))))
	
	if not isnull(ls_column) and ls_column > '' then
		ll_j = this.of_find_column( ls_column)
		if ll_j = 0 then ll_j = upperbound(istr_aggregate[]) + 1
		istr_aggregate[ll_j].s_column = ls_column
		istr_aggregate[ll_j].s_expression[upperbound(istr_aggregate[ll_j].s_expression[]) + 1] = string(ln_bag.of_get('expression' + string(ll_i)))
		istr_aggregate[ll_j].s_defaultlabel[upperbound(istr_aggregate[ll_j].s_defaultlabel[]) + 1] = string(ln_bag.of_get('label' + string(ll_i)))
	else
		lb_continue=FALSE
	end if
	ll_i++
loop

For ll_index = 1 To 100
	If Not ln_bag.of_exists('trailerheight' + String(ll_index)) Then Exit
	il_originaltrailerheight[ll_index] = Long(ln_bag.of_get('trailerheight' + String(ll_index)))
Next

If ln_bag.of_exists('originalfooterheight') Then
	il_originalfooterheight = Long(ln_bag.of_get('originalfooterheight'))
End If

If ln_bag.of_exists('computedfields') Then
	ls_parms[] = ls_empty[]
	gn_globals.in_string_functions.of_parse_string(ln_bag.of_get('computedfields'), ",", ls_parms[])
	For ll_index = 1 To UpperBound(ls_parms[])
		is_computes[UpperBound(is_computes[]) + 1] = Trim(ls_parms[ll_index])
	Next
	
	il_computes = UpperBound(is_computes[])
End If

If ln_bag.of_exists('showlabels') Then
	ib_labels = Left(Upper(Trim(ln_bag.of_get('showlabels'))), 1) = 'Y'
Else
	ib_labels = True
End If

destroy ln_bag

return True
end function

public subroutine of_update_aggregateinit ();
long		ll_count, ll_column, ll_expression
long		ll_i
Long		ll_index

string	ls_init
string	ls_temp
string	ls_column
string	ls_expression
string	ls_label

n_datawindow_tools	ln_tools

for ll_column = 1 to upperbound( istr_aggregate[])
	ls_column = istr_aggregate[ll_column].s_column
	if isnull(ls_column) or ls_column = '' then CONTINUE

	for ll_expression = 1 to upperbound( istr_aggregate[ll_column].s_expression[])
		ls_expression = istr_aggregate[ll_column].s_expression[ll_expression]
		if isnull(ls_expression) or ls_expression = '' then CONTINUE
	
		ll_count++
		if ls_init > '' then ls_init = ls_init + '||'
		ls_init = ls_init + 'column' + string(ll_count) + "=" + ls_column
		ls_init = ls_init + '||expression' + string(ll_count) + "=" + ls_expression
		ls_init = ls_init + '||label' + string(ll_count) + "=" + istr_aggregate[ll_column].s_defaultlabel[ll_expression]
	next
next

if ls_init > '' then ls_init = ls_init + '||'
ls_init = ls_init + 'originalfooterheight=' + string( il_originalfooterheight)

for ll_i = 1 to upperbound(il_originaltrailerheight[])
	ls_init = ls_init + '||trailerheight' + string(ll_i) + '=' + string( il_originaltrailerheight[ll_i])
next

If UpperBound(is_computes[]) > 0 Then
	ls_init = ls_init + '||computedfields='
	
	For ll_index = 1 To UpperBound(is_computes[])
		ls_init = ls_init + is_computes[ll_index] + ','
	Next
	
	ls_init = Left(ls_init, Len(ls_init) - 1)
End If

If Not ib_labels Then
	ls_init = ls_init + '||showlabels=N'
End If

ln_tools = create n_datawindow_tools

ls_temp = ln_tools.of_get_expression( idw_data, 'aggregateinit')

if isnull(ls_temp) then
	ls_init = "~'" + ls_init + "~'"
	ln_tools.of_create_initcolumn ( idw_data, 'aggregateinit', ls_init)
else
	ln_tools.of_set_expression( idw_data, 'aggregateinit', ls_init)
end if
is_aggregateinit = ls_init

destroy ln_tools

return 
end subroutine

public subroutine of_init (powerobject adw_data);long		ll_i
string	ls_temp

if not isvalid(adw_data) then return

idw_data = adw_data

if NOT ib_hassubscribed then
	if isvalid( gn_globals) then
		if isvalid( gn_globals.in_subscription_service) then
			gn_globals.in_subscription_service.of_subscribe( this, "aggregate", idw_data)
			gn_globals.in_subscription_service.of_subscribe( this, "before group by happened", idw_data)
			gn_globals.in_subscription_service.of_subscribe( this, "group by happened", idw_data)
			gn_globals.in_subscription_service.of_subscribe( this, "after view restored", idw_data)
			gn_globals.in_subscription_service.of_subscribe( this, 'columnresize', idw_data)
			gn_globals.in_subscription_service.of_subscribe( this, 'visible columns changed', idw_data)
			gn_globals.in_subscription_service.of_subscribe( this, 'recreate view - aggregation', idw_data)
			ib_hassubscribed = TRUE
		end if
	end if
end if

If Not this.of_get_aggregateinit() Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// First, get the heights of the bands that we are about to modify
	//-----------------------------------------------------------------------------------------------------------------------------------
	il_originalfooterheight = long(idw_data.Dynamic Describe( "datawindow.footer.height"))
End If

If IsNumber(idw_data.Dynamic Describe('report_footer.X')) Then
	il_originalfooteroffset = long(idw_data.Dynamic describe( "datawindow.footer.height")) - Long(idw_data.Dynamic Describe('report_footer.Y'))
ElseIf IsNumber(idw_data.Dynamic Describe('report_pagenumber.X')) Then
	il_originalfooteroffset = long(idw_data.Dynamic describe( "datawindow.footer.height")) - Long(idw_data.Dynamic Describe('report_pagenumber.Y'))
Else
	il_originalfooteroffset = 0
End If

ll_i = UpperBound(il_originaltrailerheight[]) + 1

Do
	ls_temp = idw_data.Dynamic describe( "datawindow.trailer." + string(ll_i) + ".height")
	if ls_temp <> '!' and ls_temp <> '?' then
		il_originaltrailerheight[ll_i] = long(ls_temp)
	end if
	
	ll_i++
Loop Until ls_temp = '!' or ls_temp = '?' or ls_temp = '' //***

this.of_update_aggregateinit()

this.of_get_aggregateinit()

this.of_aggregate( )

return
end subroutine

public subroutine of_destroy_objects ();
long				ll_i
string			ls_empty[]
str_aggregates	lstr_empty[]
string			ls_result

if not isvalid(idw_data) then RETURN
Choose Case idw_data.TypeOf()
	Case Datawindow!
		idw_data.Dynamic setredraw(false)
		idw_data.Dynamic Post setredraw(true)
End Choose

this.of_get_aggregateinit()

for ll_i = 1 to upperbound(is_computes[])
	ls_result = idw_data.Dynamic modify( 'destroy ' + is_computes[ll_i])
next

is_computes[] = ls_empty[]

idw_data.Dynamic Modify("Destroy line_footer_total1")
idw_data.Dynamic Modify("Destroy line_footer_total2")

for ll_i = 1 to upperbound( il_originaltrailerheight[])
	If Long(idw_data.Dynamic Describe('datawindow.trailer.' + string( ll_i) + '.height')) = il_originaltrailerheight[ll_i] Then Continue
	
	idw_data.Dynamic modify( 'datawindow.trailer.' + string( ll_i) + '.height="' + string( il_originaltrailerheight[ll_i]) + '"')
next

If Long(idw_data.Dynamic Describe('datawindow.footer.height')) <> il_originalfooterheight Then
	idw_data.Dynamic modify( 'datawindow.footer.height="' + string( il_originalfooterheight) + '"')
End If

If IsNumber(idw_data.Dynamic Describe('report_footer.X')) Then
	If Long(idw_data.Dynamic Describe('report_footer.Y')) <> Long(idw_data.Dynamic Describe("datawindow.footer.height")) - il_originalfooteroffset Then
		idw_data.Dynamic Modify('report_footer.Y="' + String(Long(idw_data.Dynamic Describe("datawindow.footer.height")) - il_originalfooteroffset) + '"')
	End If
End If

If IsNumber(idw_data.Dynamic Describe('report_pagenumber.X')) Then
	If Long(idw_data.Dynamic Describe('report_pagenumber.Y')) <> Long(idw_data.Dynamic Describe("datawindow.footer.height")) - il_originalfooteroffset Then
		idw_data.Dynamic Modify('report_pagenumber.Y="' + String(Long(idw_data.Dynamic Describe("datawindow.footer.height")) - il_originalfooteroffset) + '"')
	End If
End If

return

end subroutine

public subroutine of_aggregate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	FunctionName()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   DocumentScriptFunctionality
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
long		ll_i
Long		ll_index
long		ll_baseheight
long		ll_band, ll_expression
long		ll_column
Long		ll_max_number_of_expressions_per_column
long 		ll_ActiveRow
string	ls_height
string	ls_modify
string	ls_format='[general]', ls_column_format
string	ls_x
string	ls_visible
string	as_column, as_expression, as_label
string	ls_width
string	ls_name
string	ls_empty[]
string	ls_expression_with_group_level
string	ls_temp
string 	ls_scrollposition

//n_string_functions 	ln_string_functions
Datawindow				ldw_datawindow

ll_ActiveRow = idw_data.Dynamic GetRow()

Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_datawindow = idw_data
		If IsValid(ldw_datawindow.Object) then
			ls_scrollposition = ldw_datawindow.Object.Datawindow.VerticalScrollPosition
		End If
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Clean up any old objects and reset footer height
//-----------------------------------------------------------------------------------------------------------------------------------
this.of_destroy_objects()

//-----------------------------------------------------------------------------------------------------------------------------------
// First, get the heights of the bands that we are about to modify
//-----------------------------------------------------------------------------------------------------------------------------------
il_rowheight 					= 60//long(idw_data.describe( "datawindow.detail.height"))

this.of_update_aggregateinit()

ll_i = UpperBound(il_originaltrailerheight[]) + 1

Do
	ls_temp = idw_data.Dynamic describe( "datawindow.trailer." + string(ll_i) + ".height")
	if ls_temp <> '!' and ls_temp <> '?' then
		il_originaltrailerheight[ll_i] = long(ls_temp)
	end if
	
	ll_i++
Loop Until ls_temp = '!' or ls_temp = '?' or ls_temp = '' //***

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
this.of_set_labels()

Choose Case idw_Data.TypeOf()
	Case Datawindow!
		idw_data.Dynamic setredraw(FALSE)
		idw_data.Dynamic post setredraw(TRUE)
End Choose

for ll_column = 1 to upperbound( istr_aggregate[])
	as_column = istr_aggregate[ll_column].s_column
	
	if isnull(as_column) or as_column = '' then CONTINUE

	ls_visible = idw_data.Dynamic Describe( as_column + ".visible")
	if isnumber( ls_visible) and long(ls_visible) = 0 Then
		CONTINUE
	ElseIf Pos(ls_visible, '~t0//') > 0 Then
		Continue
	End If
	
	ls_column_format = idw_data.Dynamic describe( as_column + ".format")
	ls_x = idw_data.Dynamic describe( as_column + ".x")
	ls_width = idw_data.Dynamic describe( as_column + ".width")

	for ll_expression = 1 to upperbound( istr_aggregate[ll_column].s_expression[])
		ll_max_number_of_expressions_per_column = Max(ll_max_number_of_expressions_per_column, ll_expression)
		as_expression = istr_aggregate[ll_column].s_expression[ll_expression]

		if isnull(as_expression) or as_expression = '' then CONTINUE
		
		as_label = istr_aggregate[ll_column].s_label[ll_expression]

		ll_band = 1
		ls_height = idw_data.Dynamic describe( "datawindow.trailer." + string(ll_band) + ".height")

		do while (ls_height <> '!' and ls_height <> '?')
			ll_baseheight = il_originaltrailerheight[ll_band]
			il_count++
			ls_name = 'aggregatecompute_' + string(il_count)
			is_computes[UpperBound(is_computes[]) + 1] = ls_name
			
			if left(lower(as_expression),5) = 'count' then ls_format = '#,##0' else ls_format = ls_column_format
			

			ls_expression_with_group_level = as_expression
			gn_globals.in_string_functions.of_replace_all(ls_expression_with_group_level, '"', '~~"')
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// This Pos function is a cheesy way to see if it's weighted average.
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_expression_with_group_level = gn_globals.in_string_functions.of_replace_all(ls_expression_with_group_level, 'For All', 'For Group ' + String(ll_band), True)

			ls_modify = 'create compute(band=trailer.' + string(ll_band) + ' color="0" alignment="1" border="0"  x="' + ls_x + '" y="' + string(ll_baseheight + (ll_expression - 1) * il_rowheight) + '" height="53" width="' + ls_width + '"' + &
					' format="' + ls_format + '" name=' + ls_name + ' expression="' + ls_expression_with_group_level + '" visible="1" font.face="Tahoma" font.height="-8" font.weight="400" font.family="2" font.pitch="2"' + &
					' font.charset="0" background.mode="1" )'
			
		
			il_count++
			ls_name = 'aggregatecompute_' + string(il_count)
			is_computes[UpperBound(is_computes[]) + 1] = ls_name

			ls_modify = ls_modify + '~t' + 'create compute(band=trailer.' + string(ll_band) + ' color="0" alignment="0" border="0"  x="' + ls_x + '" y="' + string(ll_baseheight + (ll_expression - 1) * il_rowheight) + '" height="53" width="' + ls_width + '"' + &
					' format="[general]" name=' + ls_name + ' expression="~'' + as_label + '~'" visible="1" font.face="Tahoma" font.height="-8" font.weight="700" font.family="2" font.pitch="2"' + &
					' font.charset="0" background.mode="1" )'

			idw_data.Dynamic Modify(ls_modify)
		
			ll_band++
			
			ls_height = idw_data.Dynamic describe( "datawindow.trailer." + string(ll_band) + ".height")
			
		loop

		ll_baseheight = il_originalfooterheight - il_originalfooteroffset
		If ll_baseheight > 12 Then
			ll_baseheight = ll_baseheight - 12
		End If
		
		il_count++
		ls_name = 'aggregatecompute_' + string(il_count)
		is_computes[UpperBound(is_computes[]) + 1] = ls_name

		if left(lower(as_expression),5) = 'count' then ls_format = '#,##0' else ls_format = ls_column_format

		ls_expression_with_group_level = as_expression
		gn_globals.in_string_functions.of_replace_all(ls_expression_with_group_level, '"', '~~"')
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// 
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_modify = 'create compute(band=footer color="0" alignment="1" border="0"  x="' + ls_x + '" y="' + string(ll_baseheight + (ll_expression - 1) * il_rowheight) + '" height="53" width="' + ls_width + '"' + &
			' format="' + ls_format + '" name=' + ls_name + ' expression="' + ls_expression_with_group_level + '" visible="1" font.face="Tahoma" font.height="-8" font.weight="400" font.family="2" font.pitch="2"' + &
			' font.charset="0" background.mode="1" )'
		
		il_count++
		ls_name = 'aggregatecompute_' + string(il_count)
		is_computes[UpperBound(is_computes[]) + 1] = ls_name
		
		ls_modify = ls_modify + '~t' + 'create compute(band=footer color="0" alignment="0" border="0"  x="' + ls_x + '" y="' + string(ll_baseheight + (ll_expression - 1) * il_rowheight) + '" height="53" width="' + ls_width + '"' + &
				' format="[general]" name=' + ls_name + ' expression="~'' + as_label + '~'" visible="1" font.face="Tahoma" font.height="-8" font.weight="700" font.family="2" font.pitch="2"' + &
				' font.charset="0" background.mode="1" )'

		idw_data.Dynamic Modify(ls_modify)
	next
next

For ll_index = 1 To UpperBound(il_originaltrailerheight[])
	if long(idw_data.Dynamic describe('datawindow.trailer.' + string(ll_index) + '.height')) < il_originaltrailerheight[ll_index] + (il_rowheight * ll_max_number_of_expressions_per_column) then
		idw_data.Dynamic modify('datawindow.trailer.' + string(ll_index) + '.height="' + string( il_originaltrailerheight[ll_index] + (il_rowheight * ll_max_number_of_expressions_per_column) + 36) + '"')
		idw_data.Dynamic modify('line_footer' + string(ll_index * 2) + '.Y1="' + string(il_originaltrailerheight[ll_index] + (ll_max_number_of_expressions_per_column - 1) * il_rowheight + 53) + '"')
		idw_data.Dynamic modify('line_footer' + string(ll_index * 2) + '.Y2="' + string(il_originaltrailerheight[ll_index] + (ll_max_number_of_expressions_per_column - 1) * il_rowheight + 53) + '"')
	end if
Next

If IsNumber(idw_data.Dynamic Describe("line_footer.X1")) And ll_max_number_of_expressions_per_column > 0 Then
	idw_data.Dynamic Modify('Create line(band=Footer x1="' + idw_data.Dynamic Describe("line_footer.X1") + '" y1="0" x2="' + idw_data.Dynamic Describe("line_footer.X2") + '" y2="0"  name=line_footer_total1 pen.style="0" pen.width="5" pen.color="12632256"  background.mode="2" background.color="12632256" )')
	idw_data.Dynamic Modify('Create line(band=Footer x1="' + idw_data.Dynamic Describe("line_footer.X1") + '" y1="0" x2="' + idw_data.Dynamic Describe("line_footer.X2") + '" y2="0"  name=line_footer_total2 pen.style="0" pen.width="5" pen.color="12632256"  background.mode="2" background.color="12632256" )')
	idw_data.Dynamic modify('line_footer_total1.Y1="' + string(il_originalfooterheight - il_originalfooteroffset + (ll_max_number_of_expressions_per_column - 1) * il_rowheight + 53) + '"')
	idw_data.Dynamic modify('line_footer_total1.Y2="' + string(il_originalfooterheight - il_originalfooteroffset + (ll_max_number_of_expressions_per_column - 1) * il_rowheight + 53) + '"')
	idw_data.Dynamic modify('line_footer_total2.Y1="' + string(il_originalfooterheight - il_originalfooteroffset + (ll_max_number_of_expressions_per_column - 1) * il_rowheight + 53 + 8) + '"')
	idw_data.Dynamic modify('line_footer_total2.Y2="' + string(il_originalfooterheight - il_originalfooteroffset + (ll_max_number_of_expressions_per_column - 1) * il_rowheight + 53 + 8) + '"')
End If

if long(idw_data.Dynamic describe('datawindow.footer.height')) < il_originalfooterheight + (il_rowheight * ll_max_number_of_expressions_per_column) then
	idw_data.Dynamic modify('datawindow.footer.height="' + string( il_originalfooterheight + (il_rowheight * ll_max_number_of_expressions_per_column)) + '"')
end if

If IsNumber(idw_data.Dynamic Describe('report_footer.X')) Then
	If Long(idw_data.Dynamic Describe('report_footer.Y')) <> Long(idw_data.Dynamic Describe("datawindow.footer.height")) - il_originalfooteroffset Then
		idw_data.Dynamic Modify('report_footer.Y="' + String(Long(idw_data.Dynamic Describe("datawindow.footer.height")) - il_originalfooteroffset) + '"')
	End If
End If

If IsNumber(idw_data.Dynamic Describe('report_pagenumber.X')) Then
	If Long(idw_data.Dynamic Describe('report_pagenumber.Y')) <> Long(idw_data.Dynamic Describe("datawindow.footer.height")) - il_originalfooteroffset Then
		idw_data.Dynamic Modify('report_pagenumber.Y="' + String(Long(idw_data.Dynamic Describe("datawindow.footer.height")) - il_originalfooteroffset) + '"')
	End If
End If

If ll_ActiveRow > 0 then			//JGV if no row is active, the SetRow bombs
	idw_data.Dynamic SetRow(ll_ActiveRow)															//KCS 19580 05/07/2001 Added
end if

Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_datawindow = idw_data
		If IsValid(ldw_datawindow.Object) and ls_scrollposition <> "0" then					//JGV if no row is active, the ScrollPos bombs
			ldw_datawindow.Object.DataWindow.VerticalScrollPosition = ls_scrollposition	//KCS 19580 05/07/2001 Added
		End If
End Choose

this.of_update_aggregateinit()

end subroutine

public subroutine of_add_aggregate (string as_column, string as_expression, string as_label);
long		ll_column

ll_column = this.of_find_column( as_column)

if ll_column = 0 then ll_column = upperbound( istr_aggregate[]) + 1

istr_aggregate[ll_column].s_column = as_column
istr_aggregate[ll_column].s_expression[upperbound(istr_aggregate[ll_column].s_expression[]) + 1] = as_expression
istr_aggregate[ll_column].s_defaultlabel[upperbound(istr_aggregate[ll_column].s_defaultlabel[]) + 1] = as_label

this.of_update_aggregateinit()

return

end subroutine

public subroutine of_set_batch_mode (boolean ab_batchmode);ib_batchmode = ab_batchmode
end subroutine

public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu()
//	Arguments:  am_dynamic 				- The dynamic menu to add to
//					as_objectname			- The name of the object that the menu is being presented for
//					ab_iscolumn				- Whether or not the object is a column
//					ab_iscomputedfield	- Whether or not the object is a computed field
//	Overview:   This will allow this service to create its own menu
//	Created by:
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_index
Long	ll_upperbound

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_menu_dynamic		lm_cascaded_aggregation_menu

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that objects are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not IsValid(idw_data) Then Return
If Not ab_iscolumn And Not ab_iscomputedfield Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a spacer since the menu has items already
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('-', '', '', This)

//----------------------------------------------------------------------------------------------------------------------------------
// Add the cascade menu item and get a pointer to it
//-----------------------------------------------------------------------------------------------------------------------------------
lm_cascaded_aggregation_menu = an_menu_dynamic.of_add_item('A&ggregate This Column', '', '', This)

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the three aggregation menu items to the cascaded menu that we created
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_BatchMode Then
	Choose Case Lower(Trim(idw_data.Dynamic Describe(as_objectname + '.Edit.Style')))
		Case 'dddw', 'ddlb'
		Case Else
			Choose Case Lower(Left(idw_data.Dynamic Describe(as_objectname + '.ColType'), 4))
				Case 'date', 'time', 'char', 'stri'
				Case Else
					lm_cascaded_aggregation_menu.of_add_item('&Sum', 						'Sum', 					as_objectname, This)
					lm_cascaded_aggregation_menu.of_add_item('&Average', 					'Avg', 					as_objectname, This)
					//lm_cascaded_aggregation_menu.of_add_item('&Weighted Average', 		'Weighted Average', 	as_objectname, This)
					lm_cascaded_aggregation_menu.of_add_item('S&tandard Deviation', 	'StDev', 				as_objectname, This)
					lm_cascaded_aggregation_menu.of_add_item('&Variance', 				'Var', 					as_objectname, This)
					lm_cascaded_aggregation_menu.of_add_item('-', 							'-', 						'', 				This)					
			End Choose
	End Choose
Else	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we're in batch mode, we don't know what the column is yet
	//-----------------------------------------------------------------------------------------------------------------------------------
	lm_cascaded_aggregation_menu.of_add_item('&Sum', 						'Sum', 					as_objectname, This)
	lm_cascaded_aggregation_menu.of_add_item('&Average', 					'Avg', 					as_objectname, This)
	lm_cascaded_aggregation_menu.of_add_item('S&tandard Deviation', 	'StDev', 				as_objectname, This)
	lm_cascaded_aggregation_menu.of_add_item('&Variance', 				'Var', 					as_objectname, This)
	lm_cascaded_aggregation_menu.of_add_item('-', 							'-', 						'', 				This)					
End If	

lm_cascaded_aggregation_menu.of_add_item('&Count', 										'Count', 			as_objectname, This)
lm_cascaded_aggregation_menu.of_add_item('&Minimum', 										'Min', 				as_objectname, This)
lm_cascaded_aggregation_menu.of_add_item('Ma&ximum', 										'Max', 				as_objectname, This)
lm_cascaded_aggregation_menu.of_add_item('-', 												'-', 					'', 				This)
If Not ib_BatchMode Then lm_cascaded_aggregation_menu.of_add_item('Create Custom Aggregate...', 				'custom', 			as_objectname, This)
lm_cascaded_aggregation_menu.of_add_item('-', 												'-', 					'', 				This)
lm_cascaded_aggregation_menu.of_add_item('Toggle &Labels', 								'toggle labels', 	as_objectname, This)
lm_cascaded_aggregation_menu.of_add_item('-', 												'-', 					'', 				This)
lm_cascaded_aggregation_menu.of_add_item('&Remove Aggregate(s) on This Column', 	'remove', 			as_objectname, This)
lm_cascaded_aggregation_menu.of_add_item('&Remove All Aggregate(s) on Report', 	'remove', 			'all of them', This)
end subroutine

on n_aggregation_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_aggregation_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

