$PBExportHeader$n_pivot_table_view_service.sru
forward
global type n_pivot_table_view_service from nonvisualobject
end type
end forward

global type n_pivot_table_view_service from nonvisualobject
end type
global n_pivot_table_view_service n_pivot_table_view_service

type variables
Protected:
	Long il_userid
	Long il_reportconfigid
	n_pivot_table_element		in_pivot_table_row[]
	n_pivot_table_element		in_pivot_table_column[]
	n_pivot_table_element		in_pivot_table_aggregate[]
	n_pivot_table_element		in_pivot_table_properties
end variables

forward prototypes
public function long of_get_userid ()
public subroutine of_set_reportconfigid (long al_reportconfigid)
public subroutine of_set_userid (long al_userid)
public subroutine of_reset ()
public function long of_get_reportconfigid ()
public subroutine of_set_state_xml_old (string as_xml_document)
public function string of_isvaliddocument (string as_xmldocument)
public function string of_get_xml (ref n_pivot_table_element an_pivot_table_row[], ref n_pivot_table_element an_pivot_table_column[], ref n_pivot_table_element an_pivot_table_aggregate[], ref n_pivot_table_element an_pivot_table_properties)
public subroutine of_set_state_xml (string as_xml_document)
public subroutine of_get_view (long al_reportconfigpivottableview, ref n_pivot_table_element an_pivot_table_row[], ref n_pivot_table_element an_pivot_table_column[], ref n_pivot_table_element an_pivot_table_aggregate[], ref n_pivot_table_element an_pivot_table_properties, ref long al_reportviewid)
public subroutine of_get_elements (ref n_pivot_table_element an_pivot_table_row[], ref n_pivot_table_element an_pivot_table_column[], ref n_pivot_table_element an_pivot_table_aggregate[], ref n_pivot_table_element an_pivot_table_properties)
public function long of_new_view (long al_reportconfigid, long al_userid, string as_description, string as_xmldocument, boolean ab_isglobalview, long al_dataobjectstateidnty, boolean ab_allownavigation)
public subroutine of_get_views (ref long al_reportconfigpivottableid[], ref string as_description[])
end prototypes

public function long of_get_userid ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_userid()
//	Overview:   This will return the user id
//	Created by:	Blake Doerr
//	History: 	2/7/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return il_userid
end function

public subroutine of_set_reportconfigid (long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_reportconfigid()
//	Arguments:  al_reportconfigid - the report id
//	Overview:   This will store the user id
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

il_reportconfigid = al_reportconfigid
end subroutine

public subroutine of_set_userid (long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_userid()
//	Arguments:  al_userid - The userid
//	Overview:   This will store the user id
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

il_userid = al_userid
end subroutine

public subroutine of_reset ();Long ll_index
n_pivot_table_element ln_pivot_table_element[]


For ll_index = 1 To UpperBound(in_pivot_table_row[])
	If IsValid(in_pivot_table_row[ll_index]) Then Destroy in_pivot_table_row[ll_index]
Next
For ll_index = 1 To UpperBound(in_pivot_table_column[])
	If IsValid(in_pivot_table_column[ll_index]) Then Destroy in_pivot_table_column[ll_index]
Next
For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	If IsValid(in_pivot_table_aggregate[ll_index]) Then Destroy in_pivot_table_aggregate[ll_index]
Next

If IsValid(in_pivot_table_properties) Then Destroy in_pivot_table_properties

in_pivot_table_row[]				= ln_pivot_table_element[]
in_pivot_table_column[]			= ln_pivot_table_element[]
in_pivot_table_aggregate[]		= ln_pivot_table_element[]
end subroutine

public function long of_get_reportconfigid ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_reportconfigid()
//	Overview:   This will return the user id
//	Created by:	Blake Doerr
//	History: 	2/7/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return il_reportconfigid
end function

public subroutine of_set_state_xml_old (string as_xml_document);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_state_xml()
//	Arguments:  as_xml_document - the xml document that contains the state of the pivot table view
//	Overview:   Loop through all the rows of the XML document, and get out the appropriate values in each row.
//	Created by:	Blake Doerr
//	History: 	2/4/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index
Boolean	lb_is_aggregate_pivoted[], lb_WeAreGraphingInsteadOfPivoting
String ls_aggregate_string, ls_row[], ls_column[], ls_aggregate[], ls_aggregatefunction[], ls_sum_aggregates_together, ls_additional_information
n_xml_basic ln_xml_document, ln_xml_subdocument
n_pivot_table_element ln_pivot_table_element
//-----------------------------------------------------------------------------------------------------------------------------------
// Create the xml parser and load the document
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_document = Create n_xml_basic
ln_xml_document.loadxml(as_xml_document)

//-----------------------------------------------------------------------------------------------------------------------------------
// Select all row nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("Row")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each row, and get the values out of the row(node) for each corresponding row
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ll_index = 1

		Do While	Len(ln_xml_subdocument.in_xml[ll_index].Text) > 0 And Not IsNull(ln_xml_subdocument.in_xml[ll_index].Text)
			ls_row[ll_index] = ln_xml_subdocument.in_xml[ll_index].Text
			ll_index++
			If ll_index > UpperBound(ln_xml_subdocument.in_xml[]) Then Exit
		Loop
	End If
End If

Destroy ln_xml_subdocument


//-----------------------------------------------------------------------------------------------------------------------------------
// Select all row nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("Column")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each column, and get the values out of the column(node) for each corresponding column
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ll_index = 1

		Do While	Len(ln_xml_subdocument.in_xml[ll_index].Text) > 0 And Not IsNull(ln_xml_subdocument.in_xml[ll_index].Text)
			ls_column[ll_index] = ln_xml_subdocument.in_xml[ll_index].Text
			ll_index++
			If ll_index > UpperBound(ln_xml_subdocument.in_xml[]) Then Exit
		Loop
	End If
End If

Destroy ln_xml_subdocument



//-----------------------------------------------------------------------------------------------------------------------------------
// Select all aggregate nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("Aggregate")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each column, and get the values out of the aggregate(node) for each corresponding aggregate
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ll_index = 1

		Do While	Len(ln_xml_subdocument.in_xml[ll_index].Text) > 0 And Not IsNull(ln_xml_subdocument.in_xml[ll_index].Text)
			ls_aggregate_string = ln_xml_subdocument.in_xml[ll_index].Text
			ls_aggregate[ll_index] 					= Left(ls_aggregate_string, Pos(ls_aggregate_string, '||') - 1)
			ls_aggregate_string						= Right(ls_aggregate_string, Len(ls_aggregate_string) - Pos(ls_aggregate_string, '||') - 1)
			ls_aggregatefunction[ll_index] 		= Left(ls_aggregate_string, Pos(ls_aggregate_string, '||') - 1)
			ls_aggregate_string						= Right(ls_aggregate_string, Len(ls_aggregate_string) - Pos(ls_aggregate_string, '||') - 1)
			lb_is_aggregate_pivoted[ll_index]	= Lower(Trim(Left(ls_aggregate_string, Pos(ls_aggregate_string, '||') - 1))) <> 'no'
			ls_aggregate_string						= Right(ls_aggregate_string, Len(ls_aggregate_string) - Pos(ls_aggregate_string, '||') - 1)
			ls_sum_aggregates_together				= Lower(Trim(ls_aggregate_string))
			ll_index++
			If ll_index > UpperBound(ln_xml_subdocument.in_xml[]) Then Exit
		Loop
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Select all aggregate nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("PivotOrGraph")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each column, and get the values out of the aggregate(node) for each corresponding aggregate
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ls_aggregate_string = ln_xml_subdocument.in_xml[1].Text
		lb_WeAreGraphingInsteadOfPivoting	= Lower(Trim(ls_aggregate_string)) = 'graph'
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Select all aggregate nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("AdditionalInformation")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each column, and get the values out of the aggregate(node) for each corresponding aggregate
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ls_additional_information = ln_xml_subdocument.in_xml[1].Text
	End If
End If

Destroy ln_xml_subdocument
Destroy ln_xml_document


For ll_index = 1 To UpperBound(ls_row[])
	ln_pivot_table_element = Create n_pivot_table_element
	ln_pivot_table_element.ElementType	= 'Row'
	ln_pivot_table_element.Column			= ls_row[ll_index]
	in_pivot_table_row[UpperBound(in_pivot_table_row[]) + 1] = ln_pivot_table_element
Next

For ll_index = 1 To UpperBound(ls_column[])
	ln_pivot_table_element = Create n_pivot_table_element
	ln_pivot_table_element.ElementType	= 'Column'
	ln_pivot_table_element.Column			= ls_column[ll_index]
	in_pivot_table_column[UpperBound(in_pivot_table_column[]) + 1] = ln_pivot_table_element
Next

For ll_index = 1 To UpperBound(ls_aggregate[])
	ln_pivot_table_element = Create n_pivot_table_element
	ln_pivot_table_element.ElementType			= 'Aggregate'
	ln_pivot_table_element.Column					= ls_aggregate[ll_index]
	ln_pivot_table_element.AggregateFunction	= ls_aggregatefunction[ll_index]
	ln_pivot_table_element.ForceSingleColumn	= Not lb_is_aggregate_pivoted[ll_index]
	in_pivot_table_aggregate[UpperBound(in_pivot_table_aggregate[]) + 1] = ln_pivot_table_element
Next

If Not IsValid(in_pivot_table_properties) Then in_pivot_table_properties = Create n_pivot_table_element

ln_pivot_table_element	= in_pivot_table_properties
ln_pivot_table_element.ElementType						= 'Properties'
ln_pivot_table_element.ShowRowTotals					= True
ln_pivot_table_element.ShowColumnTotalsMultiple		= True
ln_pivot_table_element.ColumnAllAggregateFunction	= ls_sum_aggregates_together
ln_pivot_table_element.ShowColumnTotalsMultiple		= ls_sum_aggregates_together <> 'none' And Len(Trim(ls_sum_aggregates_together)) > 0
ln_pivot_table_element.IsGraph							= lb_WeAreGraphingInsteadOfPivoting

/*
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_state_xml()
//	Arguments:  as_xml_document - the xml document that contains the state of the pivot table view
//	Overview:   Loop through all the rows of the XML document, and get out the appropriate values in each row.
//	Created by:	Blake Doerr
//	History: 	2/4/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index, ll_index2
String ls_aggregate_string
String	ls_properties[]
n_xml_basic ln_xml_document, ln_xml_subdocument, ln_xml_element
n_pivot_table_element ln_pivot_table_element

This.of_reset()

/*
	n_pivot_table_element		in_pivot_table_row[]
	n_pivot_table_element		in_pivot_table_column[]
	n_pivot_table_element		in_pivot_table_aggregate[]
	n_pivot_table_element		in_pivot_table_properties
*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the xml parser and load the document
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_document = Create n_xml_basic
ln_xml_document.loadxml(as_xml_document)

//-----------------------------------------------------------------------------------------------------------------------------------
// Select all row nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("Row")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each row, and get the values out of the row(node) for each corresponding row
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ll_index = 1

		Do While	Len(ln_xml_subdocument.in_xml[ll_index].Text) > 0 And Not IsNull(ln_xml_subdocument.in_xml[ll_index].Text)
			ln_pivot_table_element = Create n_pivot_table_element
			ln_pivot_table_element.ElementType	= 'Row'
			ln_pivot_table_element.of_get_properties(ls_properties[])
			in_pivot_table_row[UpperBound(in_pivot_table_row[]) + 1] = ln_pivot_table_element
				
			For ll_index2 = 1 To UpperBound(ls_properties[])
				ln_xml_element = ln_xml_subdocument.in_xml[ll_index].SelectSingleNode(ls_properties[ll_index2])
				
				If IsValid(ln_xml_element) Then 
					If Len(ln_xml_element.Text) > 0 Then ln_pivot_table_element.of_set(ls_properties[ll_index2], ln_xml_element.Text)
					Destroy ln_xml_element
		
End If
			Next
			
			ll_index++
			If ll_index > UpperBound(ln_xml_subdocument.in_xml[]) Then Exit
		Loop
	End If
End If

Destroy ln_xml_subdocument


//-----------------------------------------------------------------------------------------------------------------------------------
// Select all row nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("NewColumn")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each column, and get the values out of the column(node) for each corresponding column
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ll_index = 1

		Do While	Len(ln_xml_subdocument.in_xml[ll_index].Text) > 0 And Not IsNull(ln_xml_subdocument.in_xml[ll_index].Text)
			ln_pivot_table_element = Create n_pivot_table_element
			ln_pivot_table_element.ElementType	= 'Column'
			ln_pivot_table_element.of_get_properties(ls_properties[])
			in_pivot_table_column[UpperBound(in_pivot_table_column[]) + 1] = ln_pivot_table_element
			
			For ll_index2 = 1 To UpperBound(ls_properties[])
				ln_xml_element = ln_xml_subdocument.in_xml[ll_index].SelectSingleNode(ls_properties[ll_index2])
				
				If IsValid(ln_xml_element) Then 
					If Len(ln_xml_element.Text) > 0 Then ln_pivot_table_element.of_set(ls_properties[ll_index2], ln_xml_element.Text)
					Destroy ln_xml_element
				End If
			Next

			ll_index++
			If ll_index > UpperBound(ln_xml_subdocument.in_xml[]) Then Exit
		Loop
	End If
End If

Destroy ln_xml_subdocument



//-----------------------------------------------------------------------------------------------------------------------------------
// Select all aggregate nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("Aggregate")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each column, and get the values out of the aggregate(node) for each corresponding aggregate
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ll_index = 1

		Do While	Len(ln_xml_subdocument.in_xml[ll_index].Text) > 0 And Not IsNull(ln_xml_subdocument.in_xml[ll_index].Text)
			ls_aggregate_string = ln_xml_subdocument.in_xml[ll_index].Text
			
			ln_pivot_table_element = Create n_pivot_table_element
			ln_pivot_table_element.ElementType	= 'Aggregate'
			ln_pivot_table_element.of_get_properties(ls_properties[])
			in_pivot_table_aggregate[UpperBound(in_pivot_table_aggregate[]) + 1] = ln_pivot_table_element

			For ll_index2 = 1 To UpperBound(ls_properties[])
				ln_xml_element = ln_xml_subdocument.in_xml[ll_index].SelectSingleNode(ls_properties[ll_index2])
				
				If IsValid(ln_xml_element) Then 
					If Len(ln_xml_element.Text) > 0 Then ln_pivot_table_element.of_set(ls_properties[ll_index2], ln_xml_element.Text)
					Destroy ln_xml_element
				End If
			Next
			
			ll_index++
			If ll_index > UpperBound(ln_xml_subdocument.in_xml[]) Then Exit
		Loop
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Select all aggregate nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectSingleNode("Properties")

If Not IsValid(in_pivot_table_properties) Then in_pivot_table_properties = Create n_pivot_table_element

ln_pivot_table_element	= in_pivot_table_properties
ln_pivot_table_element.ElementType	= 'properties'
ln_pivot_table_element.of_get_properties(ls_properties[])

If UpperBound(ln_xml_subdocument.in_xml[]) = 1 Then
	For ll_index = 1 To UpperBound(ls_properties[])
		ln_xml_element = ln_xml_subdocument.in_xml[1].SelectSingleNode(ls_properties[ll_index])
		
		If IsValid(ln_xml_element) Then 
			If Len(ln_xml_element.Text) > 0 Then ln_pivot_table_element.of_set(ls_properties[ll_index], ln_xml_element.Text)
			Destroy ln_xml_element
		End If
	Next
End If

Destroy ln_xml_subdocument
Destroy ln_xml_document
*/
end subroutine

public function string of_isvaliddocument (string as_xmldocument);If Len(as_xmldocument) > 7000 Then
	Return 'Error:  The view syntax is ' + String(Len(as_xmldocument)) + ' bytes, which is larger than the maximum of 7000 bytes.  Try to get rid of spaces or shorten expressions in order to save the pivot table view'
End If

Return ''
end function

public function string of_get_xml (ref n_pivot_table_element an_pivot_table_row[], ref n_pivot_table_element an_pivot_table_column[], ref n_pivot_table_element an_pivot_table_aggregate[], ref n_pivot_table_element an_pivot_table_properties);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_parameters()
//					as_row[] 					- the rows
//					as_column[] 				- The columns
//					as_aggregate[] 			- the aggregates
//					as_aggregatefunction[] 	- the aggregate functions
//					as_title 					- the title
//					ab_is_aggregate_pivoted[] - Whether or not the aggregate is pivoted
//					ab_sum_aggregates_together	- Whether or not to sum the aggregates together
//	Overview:   This will get the view information from the database
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_index2
String	ls_xml_document = ''
String	ls_properties[]
String	ls_property

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_pivot_table_element ln_pivot_table_element[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Add all the element objects to one array so they can be processed as a collection
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(an_pivot_table_row[])
	ln_pivot_table_element[UpperBound(ln_pivot_table_element[]) + 1] = an_pivot_table_row[ll_index]
Next

For ll_index = 1 To UpperBound(an_pivot_table_column[])
	ln_pivot_table_element[UpperBound(ln_pivot_table_element[]) + 1] = an_pivot_table_column[ll_index]
Next

For ll_index = 1 To UpperBound(an_pivot_table_aggregate[])
	ln_pivot_table_element[UpperBound(ln_pivot_table_element[]) + 1] = an_pivot_table_aggregate[ll_index]
Next

ln_pivot_table_element[UpperBound(ln_pivot_table_element[]) + 1] = an_pivot_table_properties

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the UserID and the ReportConfigID
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(il_reportconfigid) Then 	ls_xml_document = ls_xml_document + '<ReportConfig.RprtCnfgID>' + String(il_reportconfigid) + '</ReportConfig.RprtCnfgID>~r~n'
If Not IsNull(il_userid) Then 			ls_xml_document = ls_xml_document + '<UserID>' + String(il_userid) + '</UserID>~r~n'

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through every element object and get every property
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ln_pivot_table_element[])
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the element object isn't valid, continue
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not IsValid(ln_pivot_table_element[ll_index]) Then Continue

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the ElementType As the root node for the element
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Lower(Trim(ln_pivot_table_element[ll_index].ElementType)) = 'column' Then
		ls_xml_document = ls_xml_document + '<NewColumn>~r~n'
	Else
		ls_xml_document = ls_xml_document + '<' + ln_pivot_table_element[ll_index].ElementType + '>~r~n'
	End If

	ln_pivot_table_element[ll_index].of_get_properties(ls_properties[], True)

	For ll_index2 = 1 To UpperBound(ls_properties[])
		ls_property	= ln_pivot_table_element[ll_index].of_get(ls_properties[ll_index2])
		
		If Len(Trim(ls_property)) <= 0 Or IsNull(ls_property) Then Continue
		
		ls_xml_document = ls_xml_document + '<' + ls_properties[ll_index2] + '>' + ls_property + '</' + ls_properties[ll_index2] + '>~r~n'
	Next

	If Lower(Trim(ln_pivot_table_element[ll_index].ElementType)) = 'column' Then
		ls_xml_document = ls_xml_document + '</NewColumn>~r~n'
	Else
		ls_xml_document = ls_xml_document + '</' + ln_pivot_table_element[ll_index].ElementType + '>~r~n'
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the Document
//-----------------------------------------------------------------------------------------------------------------------------------
Return '<PivotTable>~r~n' + ls_xml_document + '~r~n</PivotTable>'
end function

public subroutine of_set_state_xml (string as_xml_document);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_state_xml()
//	Arguments:  as_xml_document - the xml document that contains the state of the pivot table view
//	Overview:   Loop through all the rows of the XML document, and get out the appropriate values in each row.
//	Created by:	Blake Doerr
//	History: 	2/4/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index, ll_index2
String ls_aggregate_string
String	ls_properties[]
n_xml_basic ln_xml_document, ln_xml_subdocument, ln_xml_element
n_pivot_table_element ln_pivot_table_element
//n_string_functions ln_string_functions
This.of_reset()

gn_globals.in_string_functions.of_replace_all(as_xml_document, '<properties>', '<Properties>')
gn_globals.in_string_functions.of_replace_all(as_xml_document, '</properties>', '</Properties>')

/*
	n_pivot_table_element		in_pivot_table_row[]
	n_pivot_table_element		in_pivot_table_column[]
	n_pivot_table_element		in_pivot_table_aggregate[]
	n_pivot_table_element		in_pivot_table_properties
*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the xml parser and load the document
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_document = Create n_xml_basic
ln_xml_document.loadxml(as_xml_document)

//-----------------------------------------------------------------------------------------------------------------------------------
// Select all row nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("Row")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each row, and get the values out of the row(node) for each corresponding row
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ll_index = 1

		Do While	Len(ln_xml_subdocument.in_xml[ll_index].Text) > 0 And Not IsNull(ln_xml_subdocument.in_xml[ll_index].Text)
			ln_pivot_table_element = Create n_pivot_table_element
			ln_pivot_table_element.ElementType	= 'Row'
			ln_pivot_table_element.of_get_properties(ls_properties[], False)
			in_pivot_table_row[UpperBound(in_pivot_table_row[]) + 1] = ln_pivot_table_element
				
			For ll_index2 = 1 To UpperBound(ls_properties[])
				ln_xml_element = ln_xml_subdocument.in_xml[ll_index].SelectSingleNode(ls_properties[ll_index2])
				
				If IsValid(ln_xml_element) Then 
					If Len(ln_xml_element.Text) > 0 Then ln_pivot_table_element.of_set(ls_properties[ll_index2], ln_xml_element.Text)
					Destroy ln_xml_element
				End If
			Next
			
			ll_index++
			If ll_index > UpperBound(ln_xml_subdocument.in_xml[]) Then Exit
		Loop
	End If
End If

Destroy ln_xml_subdocument


//-----------------------------------------------------------------------------------------------------------------------------------
// Select all row nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("NewColumn")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each column, and get the values out of the column(node) for each corresponding column
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ll_index = 1

		Do While	Len(ln_xml_subdocument.in_xml[ll_index].Text) > 0 And Not IsNull(ln_xml_subdocument.in_xml[ll_index].Text)
			ln_pivot_table_element = Create n_pivot_table_element
			ln_pivot_table_element.ElementType	= 'Column'
			ln_pivot_table_element.of_get_properties(ls_properties[], False)
			in_pivot_table_column[UpperBound(in_pivot_table_column[]) + 1] = ln_pivot_table_element
			
			For ll_index2 = 1 To UpperBound(ls_properties[])
				ln_xml_element = ln_xml_subdocument.in_xml[ll_index].SelectSingleNode(ls_properties[ll_index2])
				
				If IsValid(ln_xml_element) Then 
					If Len(ln_xml_element.Text) > 0 Then ln_pivot_table_element.of_set(ls_properties[ll_index2], ln_xml_element.Text)
					Destroy ln_xml_element
				End If
			Next

			ll_index++
			If ll_index > UpperBound(ln_xml_subdocument.in_xml[]) Then Exit
		Loop
	End If
End If

Destroy ln_xml_subdocument



//-----------------------------------------------------------------------------------------------------------------------------------
// Select all aggregate nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectNodes("Aggregate")

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each column, and get the values out of the aggregate(node) for each corresponding aggregate
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_xml_subdocument) Then
	If UpperBound(ln_xml_subdocument.in_xml[]) > 0 Then
		ll_index = 1

		Do While	Len(ln_xml_subdocument.in_xml[ll_index].Text) > 0 And Not IsNull(ln_xml_subdocument.in_xml[ll_index].Text)
			ls_aggregate_string = ln_xml_subdocument.in_xml[ll_index].Text
			
			ln_pivot_table_element = Create n_pivot_table_element
			ln_pivot_table_element.ElementType	= 'Aggregate'
			ln_pivot_table_element.of_get_properties(ls_properties[], False)
			in_pivot_table_aggregate[UpperBound(in_pivot_table_aggregate[]) + 1] = ln_pivot_table_element

			For ll_index2 = 1 To UpperBound(ls_properties[])
				ln_xml_element = ln_xml_subdocument.in_xml[ll_index].SelectSingleNode(ls_properties[ll_index2])
				
				If IsValid(ln_xml_element) Then 
					If Len(ln_xml_element.Text) > 0 Then ln_pivot_table_element.of_set(ls_properties[ll_index2], ln_xml_element.Text)
					Destroy ln_xml_element
				End If
			Next
			
			ll_index++
			If ll_index > UpperBound(ln_xml_subdocument.in_xml[]) Then Exit
		Loop
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Select all aggregate nodes into a subdocument
//-----------------------------------------------------------------------------------------------------------------------------------
ln_xml_subdocument = ln_xml_document.SelectSingleNode("Properties")

If Not IsValid(in_pivot_table_properties) Then in_pivot_table_properties = Create n_pivot_table_element

ln_pivot_table_element	= in_pivot_table_properties
ln_pivot_table_element.ElementType	= 'Properties'
ln_pivot_table_element.of_get_properties(ls_properties[], False)

If UpperBound(ln_xml_subdocument.in_xml[]) = 1 Then
	For ll_index = 1 To UpperBound(ls_properties[])
		ln_xml_element = ln_xml_subdocument.in_xml[1].SelectSingleNode(ls_properties[ll_index])
		
		If IsValid(ln_xml_element) Then 
			If Len(ln_xml_element.Text) > 0 Then ln_pivot_table_element.of_set(ls_properties[ll_index], ln_xml_element.Text)
			Destroy ln_xml_element
		End If
	Next
End If

Destroy ln_xml_subdocument
Destroy ln_xml_document
end subroutine

public subroutine of_get_view (long al_reportconfigpivottableview, ref n_pivot_table_element an_pivot_table_row[], ref n_pivot_table_element an_pivot_table_column[], ref n_pivot_table_element an_pivot_table_aggregate[], ref n_pivot_table_element an_pivot_table_properties, ref long al_reportviewid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_view()
//					al_reportconfigpivottableview - the id of the view
//					as_row[] 					- the rows
//					as_column[] 				- The columns
//					as_aggregate[] 			- the aggregates
//					as_aggregatefunction[] 	- the aggregate functions
//					as_title 					- the title
//					as_sum_aggregates_together	- Whether or not we sum the aggregates together
//					ab_wearegraphing				- Whether or not we are graphing
//	Overview:   This will get the view information from the database
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean		lb_DatastoreIsReference = True
String 		ls_description
String		ls_xml_document
Datastore 	lds_pivot_table_view
Long			ll_row

lds_pivot_table_view = gn_globals.in_cache.of_get_cache_reference('PivotTableView')
If Not IsValid(lds_pivot_table_view) Then Return

ll_row = lds_pivot_table_view.Find('RprtCnfgPvtTbleID = ' + String(al_reportconfigpivottableview), 1, lds_pivot_table_view.RowCount())

If ll_row <= 0 Then
	lb_DatastoreIsReference = False
	lds_pivot_table_view = Create Datastore
	lds_pivot_table_view.DataObject = 'd_pivot_table_view_cache'
	lds_pivot_table_view.SetTransObject(SQLCA)
	If lds_pivot_table_view.Retrieve(al_reportconfigpivottableview, 0, 0) <> 1 Then
		Destroy lds_pivot_table_view
		Return
	End If
	ll_row = 1
End If
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the view
//-----------------------------------------------------------------------------------------------------------------------------------
ls_description 	= lds_pivot_table_view.GetItemString(ll_row, 'Description')
ls_xml_document 	= lds_pivot_table_view.GetItemString(ll_row, 'XMLDocument')
al_reportviewid	= lds_pivot_table_view.GetItemNumber(ll_row, 'DtaObjctStteIdnty')

If Not lb_DatastoreIsReference Then Destroy lds_pivot_table_view

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the xml document onto this object
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(ls_xml_document, '<Columns>') > 0 And Pos(ls_xml_document, '</Columns>') > 0 Then
	This.of_set_state_xml_old(ls_xml_document)
Else
	This.of_set_state_xml(ls_xml_document)
End If

If in_pivot_table_properties.TitleType = 'O' Then
	in_pivot_table_properties.Description = ls_description
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the objects into the argument parameters
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_elements(an_pivot_table_row[], an_pivot_table_column[], an_pivot_table_aggregate[], an_pivot_table_properties)
end subroutine

public subroutine of_get_elements (ref n_pivot_table_element an_pivot_table_row[], ref n_pivot_table_element an_pivot_table_column[], ref n_pivot_table_element an_pivot_table_aggregate[], ref n_pivot_table_element an_pivot_table_properties);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_view()
//					al_reportconfigpivottableview - the id of the view
//					as_row[] 					- the rows
//					as_column[] 				- The columns
//					as_aggregate[] 			- the aggregates
//					as_aggregatefunction[] 	- the aggregate functions
//					as_title 					- the title
//					as_sum_aggregates_together	- Whether or not we sum the aggregates together
//					ab_wearegraphing				- Whether or not we are graphing
//	Overview:   This will get the view information from the database
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the objects into the argument parameters
//-----------------------------------------------------------------------------------------------------------------------------------
an_pivot_table_row[]			= in_pivot_table_row[]
an_pivot_table_column[]		= in_pivot_table_column[]
an_pivot_table_aggregate[]	= in_pivot_table_aggregate[]
an_pivot_table_properties	= in_pivot_table_properties
end subroutine

public function long of_new_view (long al_reportconfigid, long al_userid, string as_description, string as_xmldocument, boolean ab_isglobalview, long al_dataobjectstateidnty, boolean ab_allownavigation);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_new_view()
//	Arguments:  al_reportconfigid - the report id
//					al_userid - the user id
//					as_description - the description
//					ab_isdefault - Whether or not this becomes the default for this report
//					as_useredited - Whether or not the user edited the description (and maybe other things)
//					as_xmldocument	- The xml document that defines the view
//	Overview:   This will either insert or update a view of a pivot table
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_count, ll_key, ll_userid
String	ls_allownavigation
n_update_tools ln_update_tools

If Not ab_IsGlobalView Then
	ll_userid = al_userid
Else
	SetNull(ll_userid)
End If

If ab_allownavigation Then
	ls_allownavigation = 'Y'
Else
	ls_allownavigation = 'N'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// See if the view already exists
//-----------------------------------------------------------------------------------------------------------------------------------
Select	Count(*)
Into		:ll_count
From		ReportConfigPivotTable
Where		RprtCnfgID				= :al_reportconfigid
And		(UserID					= :al_userid
Or			UserID					Is Null)
And		Description				= :as_description;


//-----------------------------------------------------------------------------------------------------------------------------------
// If we already have one that is similar, just update it
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_count > 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the one we want to update
	//-----------------------------------------------------------------------------------------------------------------------------------
	Select	Min(RprtCnfgPvtTbleID)
	Into		:ll_key
	From		ReportConfigPivotTable
	Where		RprtCnfgID				= :al_reportconfigid
	And		(UserID					= :al_userid
	Or			UserID					Is Null)
	And		Description				= :as_description;
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get a new key
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_update_tools = Create n_update_tools
	ll_key = ln_update_tools.of_Get_key('ReportConfigPivotTable')
	Destroy ln_update_tools
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we don't have a valid key
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ll_key > 0 And Not IsNull(ll_key) Then Return 0


If ll_count > 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Update the existing row with all the information
	//-----------------------------------------------------------------------------------------------------------------------------------
	Update	ReportConfigPivotTable
	Set		Description				= :as_description,
				XMLDocument				= :as_xmldocument,
				CreatedByUserID		= :al_userid,
				UserID					= :ll_userid,
				DtaObjctStteIdnty		= :al_dataobjectstateidnty,
				IsNavigationDestination	= :ls_allownavigation
	Where		RprtCnfgPvtTbleID		= :ll_key;
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert the record
	//-----------------------------------------------------------------------------------------------------------------------------------
	Insert	ReportConfigPivotTable
		(
		RprtCnfgPvtTbleID,
		RprtCnfgID,
		UserID,
		Description,
		IsDefault,
		UserEdited,
		XMLDocument,
		CreatedByUserID,
		DtaObjctStteIdnty,
		IsNavigationDestination
		)
		Values
		(
		:ll_key,
		:al_reportconfigid,
		:ll_userid,
		:as_description,
		'N',
		'N',
		:as_xmldocument,
		:al_userid,
		:al_dataobjectstateidnty,
		:ls_allownavigation
		);
End If

If IsValid(gn_globals) Then
	If IsValid(gn_globals.in_cache) Then
		gn_globals.in_cache.of_refresh_cache('PivotTableView')
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the key for future reference
//-----------------------------------------------------------------------------------------------------------------------------------
Return ll_key
end function

public subroutine of_get_views (ref long al_reportconfigpivottableid[], ref string as_description[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_views()
//	Arguments:  al_reportconfigpivottableid[] = the pivot table id's
//					as_description[] - The descriptions for the menu
//	Overview:   This will get the views for the report and user
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Datastore 	lds_datastore
Long			ll_index
Long			ll_rowcount
Long			ll_return

lds_datastore = gn_globals.in_cache.of_get_cache_reference('PivotTableView')
If Not IsValid(lds_datastore) Then Return

ll_rowcount = lds_datastore.RowCount()

ll_return = lds_datastore.SetFilter('RprtCnfgID = ' + String(il_reportconfigid))
ll_return = lds_datastore.Filter()

ll_rowcount = lds_datastore.RowCount()

For ll_index = 1 To lds_datastore.RowCount()
	al_reportconfigpivottableid[ll_index] 	= lds_datastore.GetItemNumber(ll_index, 'RprtCnfgPvtTbleID')
	as_description[ll_index] 					= lds_datastore.GetItemString(ll_index, 'Description')
Next

lds_datastore.SetFilter('')
lds_datastore.Filter()

end subroutine

on n_pivot_table_view_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_pivot_table_view_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Default the user id
//	Created by: Blake Doerr
//	History:    2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

il_userid = gn_globals.il_userid
end event

