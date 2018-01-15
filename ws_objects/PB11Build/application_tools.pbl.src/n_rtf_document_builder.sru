$PBExportHeader$n_rtf_document_builder.sru
forward
global type n_rtf_document_builder from nonvisualobject
end type
end forward

global type n_rtf_document_builder from nonvisualobject
end type
global n_rtf_document_builder n_rtf_document_builder

type variables
Protected:
String is_document_header[], is_document_detail[], is_document_footer[]
Datawindow idw_source, idw_working
Transaction ixctn_transactionobjectpool[]
String is_transactionerror, is_distribution_init
RichTextEdit irte_control
Long il_reportconfigid, il_uniquecounter = 0
Boolean ib_pagebreak = False
Datastore ids_richtextdocument

//Used for doing page numbering
String is_header_rtf, is_footer_rtf, is_pagenumberstring = '\{PageNumber\}'
Long il_maximum_number_of_pages, il_pagenumber

//Used for margins
Long il_margin_top, il_margin_bottom, il_margin_left, il_margin_right
end variables

forward prototypes
private function boolean of_replace_until (ref string as_string, string as_begin, string as_end, string as_replacestring)
public subroutine of_printpage (long al_pagenumber, long al_copynumber)
private function boolean of_remove_fields (ref string as_rtf_string)
private function string of_replace_margins (ref string as_rtf_string)
public subroutine of_printstart (long al_maximumpages)
public subroutine of_printend (long al_pagesprinted)
public subroutine of_addtodocument (string as_string, band aenum_band)
public subroutine of_insert_document ()
private function string of_copy_datawindow (string as_retrieval_arguments, band aband_destinationband, transaction axctn_transactionobject, boolean ab_requiresrows)
public subroutine of_set_richtexteditor (richtextedit arte_control)
public function string of_build_document ()
public function string of_build_document (string as_retrievalarguments)
public function string of_get_distributioninit ()
public function string of_apply_signatures ()
public function string of_create_bitmap (string as_filename)
public function string of_apply_companylogo ()
public function string of_build_rightangledocument (powerobject adw_data, string as_richtextstring)
public subroutine of_init (datawindow adw_data, datawindow adw_working, long al_reportconfigid)
public subroutine of_apply_margins (powerobject adw_data)
public subroutine of_determine_margins (powerobject adw_data)
public function transaction of_gettransactionobject (long al_reportdatabaseid)
public function string of_build_document (string as_retrievalargument, long al_richtextdocumentid)
public subroutine of_add_pagebreak ()
private function long of_retrieve (powerobject ao_datasource, string as_arguments, transaction axctn_transactionobject)
protected subroutine of_apply_numbering ()
end prototypes

private function boolean of_replace_until (ref string as_string, string as_begin, string as_end, string as_replacestring);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_until()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	8.24.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_position, ll_position2


ll_position 	= Pos(as_string, as_begin)
ll_position2 	= Pos(as_string, as_end, ll_position + 1)

DO WHILE ll_position > 0 And ll_position2 > 0
	as_string = Replace(as_string, ll_position, ll_position2 - ll_position, as_replacestring)

	ll_position 	= Pos(as_string, as_begin, ll_position2)
	ll_position2 	= Pos(as_string, as_end, 	ll_position + 1)
LOOP

//of_replace_until(ref string as_string, string as_begin, string as_end, string as_replacestring)
//
//
//
//ls_filename = 'C:\WINNT\Profiles\bdoerr\Desktop\RTF Builder File.rtf'
//rte_fileopener.SaveDocument(ls_filename, FileTypeRichText!)
//
//n_blob_manipulator ln_blob_manipulator
//ln_blob_manipulator = Create n_blob_manipulator
//lblb_blob = ln_blob_manipulator.of_build_blob_from_file(ls_filename)
//ls_filetext = String(lblb_blob)
//ll_position1 = Pos(ls_filetext, '\paperw')
//ll_postion2 = Pos(ls_filetext, '\margb', ll_position1)
//ll_postion2 = Pos(ls_filetext, '\', ll_postion2 + 1)
//
//ls_filetext = Replace(ls_filetext, ll_position1, ll_postion2 - ll_position1, '\paperw25576\paperh27940\margl1400\margr1400\margt1800\margb1800')
//lblb_blob = Blob(ls_filetext)
//ln_blob_manipulator.of_build_file_from_blob(lblb_blob, ls_filename)
//
//Destroy ln_blob_manipulator
//
//
//
////				'\paperw25576\paperh27940\margl0\margr0\margt0\margb0\'
Return True
end function

public subroutine of_printpage (long al_pagenumber, long al_copynumber);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_printpage()
//	Arguments:  al_pagenumber - the page number we are printing
//					al_copynumber - The copy number we are printing
//	Overview:   This will paste the correct page number text into the document
//	Created by:	Blake Doerr
//	History: 	9.16.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String ls_header_rtf, ls_footer_rtf, ls_page_text
Long ll_position

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the page string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_page_text = 'Page ' + String(al_pagenumber) + ' of ' + String(il_maximum_number_of_pages)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the header RTF is not null, that means there is a page tag in there somewhere
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(is_header_rtf) Then
	ll_position = Pos(Lower(is_header_rtf), Lower(is_pagenumberstring))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we do indeed find the page tag, replace it with the correct page number text
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_position > 0 Then
		ls_header_rtf = Replace(is_header_rtf, ll_position, Len(is_pagenumberstring ), ls_page_text)
		idw_source.SelectTextAll(Header!)
		idw_source.PasteRTF(ls_header_rtf, Header!)
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If the footer RTF is not null, that means there is a page tag in there somewhere
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(is_footer_rtf) Then
	ll_position = Pos(Lower(is_footer_rtf), Lower(is_pagenumberstring))

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we do indeed find the page tag, replace it with the correct page number text
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_position > 0 Then
		ls_footer_rtf = Replace(is_footer_rtf, ll_position, Len(is_pagenumberstring ), ls_page_text)
		idw_source.SelectTextAll(Footer!)
		idw_source.PasteRTF(ls_footer_rtf, Footer!)
	End If
End If
end subroutine

private function boolean of_remove_fields (ref string as_rtf_string);Long ll_startposition, ll_endposition, ll_braceposition, ll_bracecount, ll_length
String ls_fieldtext, ls_return
//n_string_functions ln_string_functions
ll_startposition = Pos(as_rtf_string, '{\field')

DO WHILE ll_startposition > 0
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find where the field tag ends
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_endposition		= Pos(as_rtf_string, '{\fldrslt', ll_startposition)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we have valid positions
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_startposition > 0 And ll_endposition > ll_startposition Then
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Make sure we aren't stripping a fixed width or multiline field
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_fieldtext = Mid(as_rtf_string, ll_startposition, ll_endposition - ll_startposition)
		If Not Pos(ls_fieldtext, '\fldwidth') > 0 And Not Pos(ls_fieldtext, '\fldmuli') > 0 Then
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Replace the field tag with nothing
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_return = Replace(as_rtf_string, ll_startposition, ll_endposition - ll_startposition + Len('{\fldrslt'), '')
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Remove the next two braces.  Ignore the very next one though.  Also ignore ones that have a '\' before them because that means
			//   that it is the text version of a brace not part of a tag
			//-----------------------------------------------------------------------------------------------------------------------------------
			If Len(ls_return) > 0 Then
				ll_bracecount = 0
				ll_braceposition = ll_startposition
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Loop while the brace count is less than or equal to 3
				//-----------------------------------------------------------------------------------------------------------------------------------
				DO WHILE ll_bracecount < 3
					ll_braceposition = Pos(ls_return, '}', ll_braceposition)
					
					If ll_braceposition > 0 Then
						If Mid(ls_return, ll_braceposition - 1, 1) <> '\' Then
							If ll_bracecount > 0 Then
								ls_return = Replace(ls_return, ll_braceposition, 1, '')
								ll_braceposition = ll_braceposition - 1
							End If
							ll_bracecount = ll_bracecount + 1
						End If
					Else
						Exit
					End If
					
					ll_braceposition = ll_braceposition + 1
				LOOP
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Remove the \par from the text of the field.  It will cause ugliness.
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_fieldtext = Mid(ls_return, ll_startposition, ll_braceposition - ll_startposition)
				ll_length = Len(ls_fieldtext)
				gn_globals.in_string_functions.of_replace_all(ls_fieldtext, '\par', '')
				gn_globals.in_string_functions.of_replace_all(ls_fieldtext, '~t', '\tab ')
				If Len(ls_fieldtext) <> ll_length Then
					ls_return = Replace(ls_return, ll_startposition, ll_braceposition - ll_startposition, ls_fieldtext)
				End If
				
			End If
		End If 
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we haven't gotten any errors from the replaces (not an empty string), set the rtf string to the new string
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(ls_return) > 0 Then
		as_rtf_string = ls_return
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the next field
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_startposition 	= Pos(as_rtf_string, '{\field', ll_startposition + 1)
LOOP

Return True

end function

private function string of_replace_margins (ref string as_rtf_string);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_margins()
//	Arguments:  as_rtf_string - the string to change the margins on
//	Overview:   This will replace the rtf margins with the datawindow margins
//	Created by:	Blake Doerr
//	History: 	10.8.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_start, ll_end
String ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there is nothing to process
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(as_rtf_string)) = 0 Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the left margin syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ll_start = Pos(as_rtf_string, '\margl')

//-----------------------------------------------------------------------------------------------------------------------------------
// If we found it, find where the syntax ends
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_start > 0 Then
	ll_start = ll_start + 6
	ll_end = Pos(as_rtf_string, '\', ll_start)

	If ll_end > 0 And ll_end > ll_start Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Replace the margin with the margin from the target datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_return = Replace(as_rtf_string, ll_start, ll_end - ll_start, String((il_margin_left * 1440) / 1000))
		
		If ls_return > '' Then
			as_rtf_string = ls_return
		End If
	End If
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Find the right margin syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ll_start = Pos(as_rtf_string, '\margr')

//-----------------------------------------------------------------------------------------------------------------------------------
// If we found it, find where the syntax ends
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_start > 0 Then
	ll_start = ll_start + 6
	ll_end = Pos(as_rtf_string, '\', ll_start)

	If ll_end > 0 And ll_end > ll_start Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Replace the margin with the margin from the target datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_return = Replace(as_rtf_string, ll_start, ll_end - ll_start, String((il_margin_right * 1440) / 1000))
		
		If ls_return > '' Then
			as_rtf_string = ls_return
		End If
	End If
End If



//-----------------------------------------------------------------------------------------------------------------------------------
// Find the top margin syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ll_start = Pos(as_rtf_string, '\margt')

//-----------------------------------------------------------------------------------------------------------------------------------
// If we found it, find where the syntax ends
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_start > 0 Then
	ll_start = ll_start + 6
	ll_end = Pos(as_rtf_string, '\', ll_start)

	If ll_end > 0 And ll_end > ll_start Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Replace the margin with the margin from the target datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_return = Replace(as_rtf_string, ll_start, ll_end - ll_start, String((il_margin_top * 1440) / 1000))
		
		If ls_return > '' Then
			as_rtf_string = ls_return
		End If
	End If
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Find the bottom margin syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ll_start = Pos(as_rtf_string, '\margb')

//-----------------------------------------------------------------------------------------------------------------------------------
// If we found it, find where the syntax ends
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_start > 0 Then
	ll_start = ll_start + 6
	ll_end = Pos(as_rtf_string, '\', ll_start)

	If ll_end > 0 And ll_end > ll_start Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Replace the margin with the margin from the target datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_return = Replace(as_rtf_string, ll_start, ll_end - ll_start, String((il_margin_bottom * 1440) / 1000))
		
		If ls_return > '' Then
			as_rtf_string = ls_return
		End If
	End If
End If

//\paperw12240\paperh15840\margl360\margr0\margt360\margb303\deftab720\pard\ql
Return ''
end function

public subroutine of_printstart (long al_maximumpages);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_printstart()
//	Arguments:  al_maximumpages - The number of pages to be printed
//	Overview:   This will check for the page numbering tag and store the rtf of the header and footer for later use
//	Created by:	Blake Doerr
//	History: 	9.16.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

il_maximum_number_of_pages = al_maximumpages
il_pagenumber = 1

if isvalid(idw_source) then
	is_header_rtf = idw_source.CopyRTF(False, Header!)
	is_footer_rtf = idw_source.CopyRTF(False, Footer!)


	If Pos(is_header_rtf, is_pagenumberstring) > 0 Then
	Else
		SetNull(is_header_rtf)
	End If
	
	If Pos(is_footer_rtf, is_pagenumberstring) > 0 Then
	Else
		SetNull(is_footer_rtf)
	End If
end if
end subroutine

public subroutine of_printend (long al_pagesprinted);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_printend()
//	Arguments:  al_pagesprinted - The number of pages printed
//	Overview:   This will restore the original RTF to the header and footer
//	Created by:	Blake Doerr
//	History: 	9.16.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

if isvalid(idw_source) then
	
	If Not IsNull(is_header_rtf) Then
		idw_source.SelectTextAll(Header!)
		idw_source.PasteRTF(is_header_rtf, Header!)
	End If
	
	If Not IsNull(is_footer_rtf) Then
		idw_source.SelectTextAll(Footer!)
		idw_source.PasteRTF(is_footer_rtf, Footer!)
	End If

end if

end subroutine

public subroutine of_addtodocument (string as_string, band aenum_band);Long ll_upperbound

Choose Case aenum_band
	Case Header!
		ll_upperbound = UpperBound(is_document_header)
		If ll_upperbound > 0 Then
			If Len(is_document_header[ll_upperbound]) + Len(as_string) > 0 Then//64000 Then
				is_document_header[ll_upperbound + 1] = as_string
			Else
				is_document_header[ll_upperbound] = is_document_header[ll_upperbound] + as_string
			End If
		Else
			is_document_header[1] = as_string
		End If
	Case Detail!
		ll_upperbound = UpperBound(is_document_detail)
		If ll_upperbound > 0 Then
			If Len(is_document_detail[ll_upperbound]) + Len(as_string) > 0 Then//64000 Then
				is_document_detail[ll_upperbound + 1] = as_string
			Else
				is_document_detail[ll_upperbound] = is_document_detail[ll_upperbound] + as_string
			End If
		Else
			is_document_detail[1] = as_string
		End If
	Case Footer!
		ll_upperbound = UpperBound(is_document_footer)
		If ll_upperbound> 0 Then
			If Len(is_document_footer[ll_upperbound]) + Len(as_string) > 0 Then//64000 Then
				is_document_footer[ll_upperbound + 1] = as_string
			Else
				is_document_footer[ll_upperbound] = is_document_footer[ll_upperbound] + as_string
			End If
		Else
			is_document_footer[1] = as_string
		End If
End Choose


end subroutine

public subroutine of_insert_document ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_insert_document()
//	Overview:   This will insert the document into the datawindow
//	Created by:	Blake Doerr
//	History: 	8.8.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
String ls_empty[]

//of_replace_until(ref string as_string, string as_begin, string as_end, string as_replacestring)
//
//
//
//ls_filename = 'C:\WINNT\Profiles\bdoerr\Desktop\RTF Builder File.rtf'
//rte_fileopener.SaveDocument(ls_filename, FileTypeRichText!)
//
//n_blob_manipulator ln_blob_manipulator
//ln_blob_manipulator = Create n_blob_manipulator
//lblb_blob = ln_blob_manipulator.of_build_blob_from_file(ls_filename)
//ls_filetext = String(lblb_blob)
//ll_position1 = Pos(ls_filetext, '\paperw')
//ll_postion2 = Pos(ls_filetext, '\margb', ll_position1)
//ll_postion2 = Pos(ls_filetext, '\', ll_postion2 + 1)
//
//ls_filetext = Replace(ls_filetext, ll_position1, ll_postion2 - ll_position1, '\paperw25576\paperh27940\margl1400\margr1400\margt1800\margb1800')
//lblb_blob = Blob(ls_filetext)
//ln_blob_manipulator.of_build_file_from_blob(lblb_blob, ls_filename)
//
//Destroy ln_blob_manipulator
//
//
//
////				'\paperw25576\paperh27940\margl0\margr0\margt0\margb0\'


////-------------------------------------------------------------------
//// Insert the information for each destination band
////-------------------------------------------------------------------
//For ll_index = UpperBound(is_document_header) To 1 Step -1
//	of_replace_until(is_document_header[ll_index], '\paperw', '\', '\paperw25576')
//	of_replace_until(is_document_header[ll_index], '\paperh', '\', '\paperh27940')
//	of_replace_until(is_document_header[ll_index], '\margl', '\', '\margl1400')
//	of_replace_until(is_document_header[ll_index], '\margr', '\', '\margr1400')	
//	of_replace_until(is_document_header[ll_index], '\margt', '\', '\margt1800')	
//	of_replace_until(is_document_header[ll_index], '\margb', '\', '\margb1800')		
//Next
//
//For ll_index = UpperBound(is_document_detail) To 1 Step -1
//	of_replace_until(is_document_detail[ll_index], '\paperw', '\', '\paperw25576')
//	of_replace_until(is_document_detail[ll_index], '\paperh', '\', '\paperh27940')
//	of_replace_until(is_document_detail[ll_index], '\margl', '\', '\margl1400')
//	of_replace_until(is_document_detail[ll_index], '\margr', '\', '\margr1400')	
//	of_replace_until(is_document_detail[ll_index], '\margt', '\', '\margt1800')	
//	of_replace_until(is_document_detail[ll_index], '\margb', '\', '\margb1800')		
//Next
//
//For ll_index = UpperBound(is_document_footer) To 1 Step -1
//	of_replace_until(is_document_footer[ll_index], '\paperw', '\', '\paperw25576')
//	of_replace_until(is_document_footer[ll_index], '\paperh', '\', '\paperh27940')
//	of_replace_until(is_document_footer[ll_index], '\margl', '\', '\margl1400')
//	of_replace_until(is_document_footer[ll_index], '\margr', '\', '\margr1400')	
//	of_replace_until(is_document_footer[ll_index], '\margt', '\', '\margt1800')	
//	of_replace_until(is_document_footer[ll_index], '\margb', '\', '\margb1800')		
//Next
//


//-------------------------------------------------------------------
// Insert the information for each destination band
//-------------------------------------------------------------------
For ll_index = UpperBound(is_document_header) To 1 Step -1
	If Len(Trim(is_document_header[ll_index])) > 0 Then
		idw_source.PasteRTF(is_document_header[ll_index], Header!)
	End If
Next

For ll_index = UpperBound(is_document_detail) to 1 Step -1
	If Len(Trim(is_document_detail[ll_index])) > 0 Then
		idw_source.PasteRTF(is_document_detail[ll_index], Detail!)
	End If
Next

For ll_index = UpperBound(is_document_footer) To 1 Step -1
	If Len(Trim(is_document_footer[ll_index])) > 0 Then
		idw_source.PasteRTF(is_document_footer[ll_index], Footer!)
	End If
Next

is_document_header = ls_empty
is_document_detail = ls_empty
is_document_footer = ls_empty

//
//
////----------------------------------------------------------------------------------------------------------------------------------
////	Function:	of_insert_document()
////	Overview:   This will insert the document into the datawindow
////	Created by:	Blake Doerr
////	History: 	8.8.1999 - First Created 
////-----------------------------------------------------------------------------------------------------------------------------------
//
//Long ll_index
//String ls_empty[], ls_text = ''
//
//irte_control.SelectTextAll()
//irte_control.Clear()
//
////-------------------------------------------------------------------
//// Insert the information for each destination band
////-------------------------------------------------------------------
//For ll_index = UpperBound(is_document_header) To 1 Step -1
//	irte_control.PasteRTF(is_document_header[ll_index], Header!)
//Next
//
//For ll_index = UpperBound(is_document_detail) To 1 Step -1
//	ls_text = ls_text + is_document_detail[ll_index]
//Next
//irte_control.PasteRTF(ls_text, Detail!)
//
//For ll_index = UpperBound(is_document_footer) To 1 Step -1
//	irte_control.PasteRTF(is_document_footer[ll_index], Footer!)
//Next
//
//is_document_header = ls_empty
//is_document_detail = ls_empty
//is_document_footer = ls_empty
//
//
//
end subroutine

private function string of_copy_datawindow (string as_retrieval_arguments, band aband_destinationband, transaction axctn_transactionobject, boolean ab_requiresrows);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_copy_datawinodw()
//	Arguments:  as_retrieval_arguments - a comma delimited list of retrieval arguments
//	Overview:   This will retrieve a datawindow based on retrieval arguments and copy the RTF strings out of them
//	Created by:	Blake Doerr
//	History: 	8.10.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String ls_rtf_string
//n_string_functions ln_string_functions
Long ll_rowcount, ll_index, l_return

This.of_apply_margins(idw_working)

//-----------------------------------------------------------------------------------------------------------------------------------
// Check if the dw returned rows. If it returned no rows, we're not copying anything. But if the dw required rows, then we have
//	an error condition. Otheriwse, we just continue on building the document without pasting anything.
//-----------------------------------------------------------------------------------------------------------------------------------
l_return = This.of_retrieve(idw_working, as_retrieval_arguments, axctn_transactionobject)
If l_return <= 0 and ab_requiresrows Then Return "Dataobject " + idw_working.DataObject + " retrieved no rows but was configured to require rows."
If l_return <= 0 Then Return ''

//-------------------------------------------------------------------
// Copy the Header band information
//-------------------------------------------------------------------
il_uniquecounter = il_uniquecounter + 1
ls_rtf_string = idw_working.CopyRTF(False, Header!)
This.of_remove_fields(ls_rtf_string)
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '}}{\fldrslt{', '_' + String(il_uniquecounter) + '}}{\fldrslt{')
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '~r', '')
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '~n', '')
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '~t', '\tab ')
This.of_replace_margins(ls_rtf_string)
This.of_addtodocument(ls_rtf_string, aband_destinationband)

//-------------------------------------------------------------------
// Copy the Detail Band Information
//-------------------------------------------------------------------
ll_rowcount = idw_working.RowCount()

For ll_index = 1 To ll_rowcount
	idw_working.ScrollToRow(ll_index)
	
	il_uniquecounter = il_uniquecounter + 1
	ls_rtf_string = idw_working.CopyRTF(False, Detail!)
	This.of_remove_fields(ls_rtf_string)
	gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '}}{\fldrslt{', '_' + String(il_uniquecounter) + '}}{\fldrslt{')
	gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '~r', '')
	gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '~n', '')
	gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '~t', '\tab ')
	This.of_replace_margins(ls_rtf_string)
	This.of_addtodocument(ls_rtf_string, aband_destinationband)
Next

//-------------------------------------------------------------------
// Copy the Footer Band Information
//-------------------------------------------------------------------
il_uniquecounter = il_uniquecounter + 1
ls_rtf_string = idw_working.CopyRTF(False, Footer!)
This.of_remove_fields(ls_rtf_string)
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '}}{\fldrslt{', '_' + String(il_uniquecounter) + '}}{\fldrslt{')
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '~r', '')
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '~n', '')
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '~t', '\tab ')
This.of_replace_margins(ls_rtf_string)
This.of_addtodocument(ls_rtf_string, aband_destinationband)

Return ''

/*
//-------------------------------------------------------------------
// Copy the Header band information
//-------------------------------------------------------------------
il_uniquecounter = il_uniquecounter + 1
ls_rtf_string = idw_working.CopyRTF(False, Header!)
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '}}{\fldrslt{', '_' + String(il_uniquecounter) + '}}{\fldrslt{')
This.of_addtodocument(ls_rtf_string, aband_destinationband)

//-------------------------------------------------------------------
// Copy the Detail Band Information
//-------------------------------------------------------------------
ll_rowcount = idw_working.RowCount()

For ll_index = 1 To ll_rowcount
	idw_working.ScrollToRow(ll_index)
	
	il_uniquecounter = il_uniquecounter + 1
	ls_rtf_string = idw_working.CopyRTF(False, Detail!)
	gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '}}{\fldrslt{', '_' + String(il_uniquecounter) + '}}{\fldrslt{')
	
	This.of_addtodocument(ls_rtf_string, aband_destinationband)
Next

//-------------------------------------------------------------------
// Copy the Footer Band Information
//-------------------------------------------------------------------
il_uniquecounter = il_uniquecounter + 1
ls_rtf_string = idw_working.CopyRTF(False, Footer!)
gn_globals.in_string_functions.of_replace_all(ls_rtf_string, '}}{\fldrslt{', '_' + String(il_uniquecounter) + '}}{\fldrslt{')

*/


/*
			If idw_working.Find('@@[', True, False, False, False) > 0 Then
				idw_working.Position(ll_fromline, ll_beginning)
				If idw_working.Find(']@@', True, False, False, True) > 0 Then
					idw_working.Position(ll_toline, ll_ending)
					ll_ending = ll_ending + 3
					idw_working.SelectText(ll_fromline, ll_beginning, ll_toline, ll_ending, Detail!)
					idw_working.Copy()
					ls_evaluate = Clipboard()
				End If
			End If	
*/

end function

public subroutine of_set_richtexteditor (richtextedit arte_control);irte_control = arte_control

end subroutine

public function string of_build_document ();////----------------------------------------------------------------------------------------------------------------------------------
////	Function:	of_build_document()
////	Overview:   This will build the RTF document based on the datawindows defined for it
////	Created by:	Blake Doerr
////	History: 	8.8.1999 - First Created 
////-----------------------------------------------------------------------------------------------------------------------------------
//
////Declarations
//Long 						ll_index, 				ll_index2, 	ll_index3, ll_rowcount, ll_rowcount2, ll_columncount
//String 					ls_rtf_string, ls_type, s_requiresrows
//n_string_functions 	ln_string_functions 
//String 					ls_objectname, ls_objecttype, ls_targetband, ls_alignment, ls_PageBreakAfter, ls_ResetPageNumber, ls_GroupByDataObject, ls_group_by_parameter
//Long 						ll_RprtDtbseID
//Band						lband_destinationband
//Transaction				lxctn_transactionobject
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Loop through all the dataobjects and copy the RTF information out of them
////-----------------------------------------------------------------------------------------------------------------------------------
//If Not IsValid(idw_source.Object) Then
//	Return 'There is not a valid datawindow for the report'
//End If
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Set the margins appropriately
////-----------------------------------------------------------------------------------------------------------------------------------
//This.of_determine_margins()
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Loop through all the dataobjects and copy the RTF information out of them
////-----------------------------------------------------------------------------------------------------------------------------------
//ll_rowcount = ids_richtextdocument.RowCount()
//
//
////-------------------------------------------------------------------
//// Loop through all the rich text documents
////-------------------------------------------------------------------
//For ll_index = 1 To ll_rowcount
//	//-------------------------------------------------------------------
//	// Get all the information for this document
//	//-------------------------------------------------------------------
//	ls_objectname 					= Trim(	Lower(	ids_richtextdocument.GetItemString(ll_index, 'ObjectName'			)))
//	ls_objecttype 					= Trim(	Lower(	ids_richtextdocument.GetItemString(ll_index, 'ObjectType'			)))
//	ls_targetband 					= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'TargetBand'			)))
//	ls_alignment 					= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'Alignment'				)))
//	ls_PageBreakAfter				= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'PageBreakAfter'		)))
//	ls_ResetPageNumber			= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'ResetPageNumber'		)))
//	ls_GroupByDataObject 		= Trim(				ids_richtextdocument.GetItemString(ll_index, 'GroupByDataObject'	))
//	ll_RprtDtbseID					= 						ids_richtextdocument.GetItemNumber(ll_index, 'RprtDtbseID'			)
//	s_requiresrows					= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'RequiresRows'			)))
//	//-------------------------------------------------------------------
//	// Case statement to determine the destination band
//	//-------------------------------------------------------------------
//	Choose Case ls_targetband
//		Case 'F'
//			lband_destinationband = Footer!
//		Case 'D'
//			lband_destinationband = Detail!
//		Case 'H'
//			lband_destinationband = Header!
//		Case Else
//			lband_destinationband = Detail!
//	End Choose
//	
//	//-------------------------------------------------------------------
//	// Case statement based on the object type
//	//-------------------------------------------------------------------
//	Choose Case Upper(Trim(ls_objecttype))
//		Case 'B'
//			ls_rtf_string = This.of_create_bitmap(ls_objectname)
//			If Left(Lower(ls_rtf_string), 6) = 'error:' Then
//				Return ls_rtf_string
//			ElseIf Len(Trim(ls_rtf_string)) = 0 Then
//				Return 'Error:  Could not create bitmap rtf document from bitmap file ' + ls_objectname
//			End If
//			
//			This.of_addtodocument(ls_rtf_string, lband_destinationband)
//		Case 'F'
//			//-------------------------------------------------------------------
//			// Insert a richtext file or text file into the document
//			//-------------------------------------------------------------------
//			If FileExists(ls_objectname) Then
//				irte_control.SelectTextAll()
//				irte_control.Clear()
//				irte_control.InsertDocument (ls_objectname, True)
//				ls_rtf_string = irte_control.CopyRTF(False)
//				This.of_addtodocument(ls_rtf_string, lband_destinationband)
//			Else
//				Return 'Error:  The file ' + ls_objectname + ' does not exists.  The document could not be created.'
//			End If
//			
//		Case 'D'
//			//-------------------------------------------------------------------
//			// Insert a datawindow into the document
//			//-------------------------------------------------------------------
//			idw_working.DataObject = ls_objectname
//			lxctn_transactionobject = This.of_gettransactionobject(ll_RprtDtbseID)
//			If IsValid(lxctn_transactionobject) Then
//				idw_working.SetTransObject(lxctn_transactionobject)
//			Else
//				Return is_transactionerror
//			End If
//			
//			
//			//----------------------------------------------------------------------------------------------------------------------------------
//			// If there was a group by, we need to retrieve a datastore based on their sql statement.  We are basically joining the data in this
//			//		dataobject to the sql statement that they give us.  This dataobject will retrieve X number of times where X = the rowcount of 
//			//		the SQL statement they gave us.  Their sql statement also determines the order of the data.
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			If Len(ls_GroupByDataObject) > 0 Then
//				//----------------------------------------------------------------------------------------------------------------------------------
//				// Create the datastore using the defined dataobject
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				If Not IsValid(ids_group_by_datastore) Then
//					ids_group_by_datastore = Create Datastore
//				End If
//				ids_group_by_datastore.DataObject = ls_GroupByDataObject
//				
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				// Check if we're required to return rows and error out accordingly.
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				If This.of_retrieve(ids_group_by_datastore, is_arguments, lxctn_transactionobject) <= 0 and s_requiresrows = "Y" Then 
//					Return "The group-by dataobject " + ids_group_by_datastore.DataObject + " returned no rows but was configured to require rows."
//				End If
//				
//				//----------------------------------------------------------------------------------------------------------------------------------
//				// Determine the size of the matrix
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				ll_rowcount2 		= ids_group_by_datastore.RowCount()
//				ll_columncount 	= Long(ids_group_by_datastore.Describe('Datawindow.Column.Count'))
//
//				//----------------------------------------------------------------------------------------------------------------------------------
//				// Loop through every row in the datastore and retrieve the datawindow
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				For ll_index2 = 1 To ll_rowcount2
//					ls_group_by_parameter = ''
//
//					//----------------------------------------------------------------------------------------------------------------------------------
//					// Loop through every column in the datastore appending it to the retrieval arguments string
//					//-----------------------------------------------------------------------------------------------------------------------------------
//					For ll_index3 = 1 To ll_columncount
//						ls_type = ids_group_by_datastore.Describe('#' + String(ll_index3) + ".Coltype")
//						
//						//----------------------------------------------------------------------------------------------------------------------------------
//						// Process each column based on the column type.
//						//-----------------------------------------------------------------------------------------------------------------------------------
//						Choose Case lower(left(ls_type,4))
//							Case 'numb','long','deci'
//								ls_group_by_parameter = ls_group_by_parameter + String(ids_group_by_datastore.GetItemNumber(ll_index2, ll_index3)) + '||' 
//							Case 'date'
//								ls_group_by_parameter = ls_group_by_parameter + String(ids_group_by_datastore.GetItemDateTime(ll_index2, ll_index3)) + '||' 
//							Case 'char'
//								ls_group_by_parameter = ls_group_by_parameter + String(ids_group_by_datastore.GetItemString(ll_index2, ll_index3)) + '||' 
//							Case Else
//								Return 'Error:  There was an unsupported column type ' + ls_type + ' in the dataobject ' + ls_objectname + ' for richtextdocument grouping'
//						End Choose
//						
//					Next
//					
//					//----------------------------------------------------------------------------------------------------------------------------------
//					// Cut off the last delimiter
//					//-----------------------------------------------------------------------------------------------------------------------------------
//					ls_group_by_parameter = Left(ls_group_by_parameter, Len(ls_group_by_parameter) - 2)
//					
//					//----------------------------------------------------------------------------------------------------------------------------------
//					// Call the function to copy the datastore to the RTF destination
//					//-----------------------------------------------------------------------------------------------------------------------------------
//					This.of_copy_datawindow(is_arguments + '||' + ls_group_by_parameter, lband_destinationband, lxctn_transactionobject, s_requiresrows = "Y")
//				Next
//			Else
//				//----------------------------------------------------------------------------------------------------------------------------------
//				// If there was no group by, just retrieve the datawindow normally
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				This.of_copy_datawindow(is_arguments, lband_destinationband, lxctn_transactionobject, s_requiresrows = "Y")
//
//			End If
//	End Choose
//
//	Long ll_position, ll_index4
//	String ls_string
//
//	
//	If ls_PageBreakAfter = 'Y' Then
//		For ll_index4 = UpperBound(is_document_detail[]) To 1 Step -1
//			If Len(is_document_detail[ll_index4]) > 0 Then
//				ls_string = is_document_detail[ll_index4]
//				Exit
//			End If
//		Next
//
//		If Len(ls_string) > 0 Then
//			ls_string = Reverse(ls_string)
//			ll_position = Pos(ls_string, '}')
//			ll_position = Pos(ls_string, '}', ll_position + 1) + 1
//			If ll_position > 0 Then
//				ls_string = Replace(ls_string, ll_position, 0, '}egap\{')
//				ls_string = Reverse(ls_string)
//				is_document_detail[ll_index4] = ls_string
//			End If
//		End If
//		
////		This.of_addtodocument('{\rtf1\ansi\deff0{\fonttbl{\f0\froman Tms Rmn;}}{\colortbl\red0\green0\blue0;\red0\green0\blue255;\red0\green255\blue255;\red0\green255\blue0;\red255\green0\blue255;\red255\green0\blue0;\red255\green255\blue0;\red255\green255\blue255;\red0\green0\blue127;\red0\green127\blue127;\red0\green127\blue0;\red127\green0\blue127;\red127\green0\blue0;\red127\green127\blue0;\red127\green127\blue127;\red192\green192\blue192}{\info{\creatim\yr1999\mo8\dy26\hr1\min1\sec22}{\version1}{\vern262367}}\paperw12240\paperh15840\margl239\margr0\margt239\margb0\deftab720\pard\ql{\f0\fs20\cf0\up0\dn0\par}\pard\ql{\f0\fs20\cf0\up0\dn0 }{\page}{\par}\pard\ql}', Detail!)
//	End If
//	
//Next
//
//This.of_apply_numbering()
//This.of_insert_document()
//This.of_apply_signatures()
Return ''
//
end function

public function string of_build_document (string as_retrievalarguments);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_document()
//	Overview:   This will build the RTF document based on the datawindows defined for it
//	Created by:	Blake Doerr
//	History: 	8.8.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return
Long		ll_null
SetNull(ll_null)

//----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the dataobjects and copy the RTF information out of them
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_source.Object) Then
	Return 'There is not a valid datawindow for the report'
End If

ls_return = This.of_build_document(as_retrievalarguments, ll_null)
If ls_return > '' Then Return ls_return

This.of_apply_numbering()
This.of_insert_document()
This.of_apply_companylogo()
This.of_apply_signatures()

Return ls_return
end function

public function string of_get_distributioninit ();Return is_distribution_init
end function

public function string of_apply_signatures ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_signatures()
//	Overview:   This will look for the signature tag and replace it with a bitmap
//	Created by:	Blake Doerr
//	History: 	8.31.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
n_blob_manipulator ln_blob_manipulator
Blob lblob_signature
String ls_signature_tag_text, ls_filename, ls_rtf_string, ls_return
Long ll_fromline, ll_fromcharacter, ll_toline, ll_tocharacter, ll_userid, ll_dummy1, ll_dummy2, ll_charactersfound,l_copy_amt

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the tag for a signature bitmap
//-----------------------------------------------------------------------------------------------------------------------------------
ll_charactersfound = idw_source.Find('{Signature UserID=', True, True, False, False) 

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop as long as we keep finding these tags
//-----------------------------------------------------------------------------------------------------------------------------------
Do While ll_charactersfound > 0
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the starting line and character for the tag
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_source.Position(ll_fromline, ll_fromcharacter)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the end of the tag
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_charactersfound = idw_source.Find('}', True, True, False, True)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the end line and character for the tag
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_source.Position(ll_dummy1, ll_dummy2, ll_toline, ll_tocharacter)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Select the entire tag so we can read it and replace it later
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_charactersfound = idw_source.SelectText(ll_fromline, ll_fromcharacter, ll_toline, ll_tocharacter)
	
	If Not ll_charactersfound > 0 Then
		Return 'Error:  Found a signature tag but could not successfully select the text'
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get a copy of the text so we can determine what the InputField (UserID) for the signature is.  Cut the inputfield name out of the junk.
	//-----------------------------------------------------------------------------------------------------------------------------------
	//ls_signature_tag_text = idw_source.SelectedText()
	any la_any
	la_any = Clipboard()
	l_copy_amt = idw_source.Copy()
	ls_signature_tag_text = Clipboard()
	Clipboard(la_any)

	ls_signature_tag_text = Trim(	Mid	(ls_signature_tag_text, Pos(ls_signature_tag_text, '=') + 1, 10000	)	)
	ls_signature_tag_text = Trim(	Left	(ls_signature_tag_text, Len(ls_signature_tag_text) - 1					)	)
//	ls_signature_tag_text = Trim(	Left	(ls_signature_tag_text, Len(ls_signature_tag_text) - 1					)	)
//	ls_signature_tag_text = Trim(	Right	(ls_signature_tag_text, Len(ls_signature_tag_text) - 1					)	)
/*	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get an RTF copy of the data so we can copy it into a rich text control to read the inputfield
	//-----------------------------------------------------------------------------------------------------------------------------------
	irte_control.SelectTextAll()
	irte_control.Clear()
	ls_rtf_string = idw_source.copyrtf(True, Detail!)
	irte_control.PasteRTF(ls_rtf_string, Detail!)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the inputfield data out of the InputField
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_return = irte_control.InputFieldGetData(ls_signature_tag_text)
	ll_userid = Long(ls_return)
	*/
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we have a valid UserID, we can retrieve the signature for this user
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_userid = Long(ls_signature_tag_text)
	If IsNull(ll_userid) Or ll_userid <= 0 Then
		Return 'Error:  Did not find user ID for signature in the inputfield (' + ls_signature_tag_text + ')'			
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the object and retrieve the blob based on the userid
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_blob_manipulator = Create n_blob_manipulator
	lblob_signature = ln_blob_manipulator.of_retrieve_signature(ll_userid)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the blob as a file in the windows temporary directory and Destroy the object
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_filename = ln_blob_manipulator.of_determine_filename('tempsignatureuserid' + String(ll_userid) + '.bmp')
	ln_blob_manipulator.of_build_file_from_blob(lblob_signature, ls_filename)
	
	Destroy ln_blob_manipulator
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the RTF string for creating this bitmap in the document.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_rtf_string = This.of_create_bitmap(ls_filename)
	If Left(Lower(ls_rtf_string), 6) = 'error:' Then
		Return ls_rtf_string
	ElseIf Len(Trim(ls_rtf_string)) = 0 Then
		Return 'Error:  Could not create bitmap rtf document from bitmap file ' + ls_filename
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Replace the tag with the signature bitmap
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_source.PasteRTF(ls_rtf_string, Detail!)
	
	ll_charactersfound = idw_source.Find('{Signature UserID=', True, True, False, False) 
Loop			
			
Return ''
end function

public function string of_create_bitmap (string as_filename);String ls_rtf_string
If FileExists(as_filename) Then
	//-------------------------------------------------------------------
	// Insert a bitmap object into the document
	//-------------------------------------------------------------------
	irte_control.SelectTextAll()
	irte_control.Clear()
	irte_control.InsertPicture(as_filename)
	//*******alignment
	ls_rtf_string = irte_control.CopyRTF(False)
	return ls_rtf_string
Else
	Return 'Error:  The file ' + as_filename + ' does not exists.  The document could not be created.'
End If

end function

public function string of_apply_companylogo ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_companylogo()
//	Overview:   This will look for the company logo tag and replace it with a bitmap;
//					uses code stolen from of_apply_signatures
//	Created by:	Kevin McDonald
//	History: 	10/29/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
n_blob_manipulator ln_blob_manipulator
Blob lblob_signature
String ls_alignmenttext, ls_filename, ls_rtf_string, ls_return,s_logofile
Long ll_fromline, ll_fromcharacter, ll_toline, ll_tocharacter, ll_userid, ll_dummy1, ll_dummy2, ll_charactersfound,l_copy_amt
string s_alignment
//-----------------------------------------------------------------------------------------------------------------------------------
// Find the tag for a signature bitmap
//-----------------------------------------------------------------------------------------------------------------------------------
ll_charactersfound = idw_source.Find('{companylogo', True, True, False, False) 

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop as long as we keep finding these tags
//-----------------------------------------------------------------------------------------------------------------------------------
Do While ll_charactersfound > 0
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the starting line and character for the tag
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_source.Position(ll_fromline, ll_fromcharacter)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the end of the tag
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_charactersfound = idw_source.Find('}', True, True, False, True)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the end line and character for the tag
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_source.Position(ll_dummy1, ll_dummy2, ll_toline, ll_tocharacter)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Select the entire tag so we can read it and replace it later
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_charactersfound = idw_source.SelectText(ll_fromline, ll_fromcharacter, ll_toline, ll_tocharacter)
	
	If Not ll_charactersfound > 0 Then
		Return 'Error:  Found a logo tag but could not successfully select the text'
	End If

	select rgstrydtavle 
	into :s_logofile
	from registry 
	where rgstrykynme = 'CompanyLogo';
	
	If IsNull(s_logofile) Or len(s_logofile) <= 0 Then
		idw_source.replacetext(' ')
		Return 'Error: Template is attempting to use a company logo file when there is not one selected on the Contracts Control Panel.'			
	End If
	
	any la_any
	la_any = Clipboard()
	l_copy_amt = idw_source.Copy()
	ls_alignmenttext = Clipboard()
	Clipboard(la_any)

	s_alignment = mid(ls_alignmenttext,13,len(ls_alignmenttext) - 13)


	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the RTF string for creating this bitmap in the document.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_rtf_string = This.of_create_bitmap(s_logofile)
	If Left(Lower(ls_rtf_string), 6) = 'error:' Then
		If FileExists('blankbitmap.bmp') Then
			irte_control.SelectTextAll()
			irte_control.Clear()
			irte_control.InsertPicture('blankbitmap.bmp')
			
			ls_rtf_string = irte_control.CopyRTF(False)
			
		End If
	ElseIf Len(Trim(ls_rtf_string)) = 0 Then
		If FileExists('blank.bmp') Then
			irte_control.SelectTextAll()
			irte_control.Clear()
			irte_control.InsertPicture('blankbitmap.bmp')
			
			ls_rtf_string = irte_control.CopyRTF(False)
			
		End If
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Replace the tag with the signature bitmap
	//-----------------------------------------------------------------------------------------------------------------------------------
	//n_string_functions ln_string_functions

	Choose Case s_alignment
		case 'right'
			gn_globals.in_string_functions.of_replace_all(ls_rtf_string,'pard\ql','pard\qr')
		case 'center'
			gn_globals.in_string_functions.of_replace_all(ls_rtf_string,'pard\ql','pard\qc')
		case else
			// leave it alone
	end choose
	
	idw_source.PasteRTF(ls_rtf_string)
	
	ll_charactersfound = idw_source.Find('{companylogo}', True, True, False, False) 
Loop			
			
Return ''
end function

public function string of_build_rightangledocument (powerobject adw_data, string as_richtextstring);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_rightangledocument()
//	Arguments:  adw_data - The datawindow to insert the document into
//					as_richtextstring - a string in the format HeaderRTF||DetailRTF||FooterRTF
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	9.9.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String  ls_richtextdatawindow[]

//----------------------------------------------------------------------------------------------------------------------------------
// Parse the string into an array
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
gn_globals.in_string_functions.of_parse_string(as_richtextstring, '||', ls_richtextdatawindow[])

//----------------------------------------------------------------------------------------------------------------------------------
// Insert the Header
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(ls_richtextdatawindow[]) > 0 Then
	If Len(Trim(ls_richtextdatawindow[1])) > 0 Then
		adw_data.Dynamic PasteRTF(ls_richtextdatawindow[1], Header!)
	End If
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Insert the Detail
//-----------------------------------------------------------------------------------------------------------------------------------		
If UpperBound(ls_richtextdatawindow[]) > 1 Then
	If Len(Trim(ls_richtextdatawindow[2])) > 0 Then
		adw_data.Dynamic PasteRTF(ls_richtextdatawindow[2], Detail!)
	End If
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Insert the Footer
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(ls_richtextdatawindow[]) > 2 Then
	If Len(Trim(ls_richtextdatawindow[3])) > 0 Then
		adw_data.Dynamic PasteRTF(ls_richtextdatawindow[3], Footer!)
	End If
End If

Return ''
end function

public subroutine of_init (datawindow adw_data, datawindow adw_working, long al_reportconfigid);idw_source = adw_data
idw_working = adw_working
il_reportconfigid = al_reportconfigid


If Not IsValid(ids_richtextdocument) Then
	ids_richtextdocument = Create Datastore
End If

ids_richtextdocument.Dataobject = 'd_reportconfigrichtextdocument'
ids_richtextdocument.SetTransObject(SQLCA)
ids_richtextdocument.Retrieve(al_reportconfigid)

//----------------------------------------------------------------------------------------------------------------------------------
// Set the margins appropriately
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(idw_source.Object) Then This.of_determine_margins(idw_source)
end subroutine

public subroutine of_apply_margins (powerobject adw_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_margins()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   Apply the container margins to the datawindow passed in
//	Created by:	Blake Doerr
//	History: 	10/12/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If Not IsNull(il_margin_top) And Not IsNull(il_margin_bottom) And Not IsNull(il_margin_left) And Not IsNull(il_margin_right) Then
	adw_data.Dynamic Modify("Datawindow.Print.Margin.Top='" + String(il_margin_top) + "'")
	adw_data.Dynamic Modify("Datawindow.Print.Margin.Bottom='" + String(il_margin_bottom) + "'")
	adw_data.Dynamic Modify("Datawindow.Print.Margin.Left='" + String(il_margin_left) + "'")
	adw_data.Dynamic Modify("Datawindow.Print.Margin.Right='" + String(il_margin_right) + "'")
End If
end subroutine

public subroutine of_determine_margins (powerobject adw_data);il_margin_top 		= Long(adw_data.Dynamic Describe("Datawindow.Print.Margin.Top"))
il_margin_bottom 	= Long(adw_data.Dynamic Describe("Datawindow.Print.Margin.Bottom"))
il_margin_left 	= Long(adw_data.Dynamic Describe("Datawindow.Print.Margin.Left"))
il_margin_right 	= Long(adw_data.Dynamic Describe("Datawindow.Print.Margin.Right"))
end subroutine

public function transaction of_gettransactionobject (long al_reportdatabaseid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_gettransactionobject()
//	Arguments:  al_reportdatabaseid - The report database id
//	Overview:   This will return the correct transaction object to use
//	Created by:	Blake Doerr
//	History: 	8.31.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(gn_globals.of_get_object('n_transaction_pool')) Then
	Return gn_globals.of_get_object('n_transaction_pool').Dynamic of_gettransactionobject(al_reportdatabaseid)
Else
	Return SQLCA
End If


end function

public function string of_build_document (string as_retrievalargument, long al_richtextdocumentid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_document()
//	Overview:   This will build the RTF document based on the datawindows defined for it
//	Created by:	Blake Doerr
//	History: 	8.8.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 						ll_index, ll_index2, 	ll_index3, ll_rowcount, ll_rowcount2, ll_columncount
String 					ls_rtf_string, ls_type, s_requiresrows
String 					ls_objectname, ls_objecttype, ls_targetband, ls_alignment, ls_PageBreakAfter, ls_ResetPageNumber, ls_GroupByDataObject, ls_group_by_parameter
Long 						ll_RprtDtbseID, ll_RchtxtDcmntID, ll_ParentRchTxtDcmntID
Band						lband_destinationband

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore				lds_group_by_datastore
Transaction				lxctn_transactionobject
//n_string_functions 	ln_string_functions 

//----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the dataobjects and copy the RTF information out of them
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = ids_richtextdocument.RowCount()

//-------------------------------------------------------------------
// Loop through all the rich text documents
//-------------------------------------------------------------------
For ll_index = 1 To ll_rowcount
	//-------------------------------------------------------------------
	// Get all the information for this document
	//-------------------------------------------------------------------
	ls_objectname 					= Trim(	Lower(	ids_richtextdocument.GetItemString(ll_index, 'ObjectName'			)))
	ls_objecttype 					= Trim(	Lower(	ids_richtextdocument.GetItemString(ll_index, 'ObjectType'			)))
	ls_targetband 					= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'TargetBand'			)))
	ls_alignment 					= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'Alignment'				)))
	ls_PageBreakAfter				= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'PageBreakAfter'		)))
	ls_ResetPageNumber			= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'ResetPageNumber'		)))
	ls_GroupByDataObject 		= Trim(				ids_richtextdocument.GetItemString(ll_index, 'GroupByDataObject'	))
	ll_RprtDtbseID					= 						ids_richtextdocument.GetItemNumber(ll_index, 'RprtDtbseID'			)
	s_requiresrows					= Trim(	Upper(	ids_richtextdocument.GetItemString(ll_index, 'RequiresRows'			)))
 	ll_RchtxtDcmntID				= 						ids_richtextdocument.GetItemNumber(ll_index, 'RchtxtDcmntID'			)
	ll_ParentRchTxtDcmntID		= 						ids_richtextdocument.GetItemNumber(ll_index, 'ParentRchTxtDcmntID'	)
	
	//-------------------------------------------------------------------
	// If we are retrieving children documents, make sure that they are
	//   under the parent that we're retrieving.
	//-------------------------------------------------------------------
	If Not IsNull(al_richtextdocumentid) Then
		If IsNull(ll_ParentRchTxtDcmntID) Then Continue
		If ll_ParentRchTxtDcmntID <> al_richtextdocumentid Or ll_ParentRchTxtDcmntID = ll_RchtxtDcmntID Then Continue
	End If
	
	//-------------------------------------------------------------------
	// Case statement to determine the destination band
	//-------------------------------------------------------------------
	Choose Case ls_targetband
		Case 'F'
			lband_destinationband = Footer!
		Case 'D'
			lband_destinationband = Detail!
		Case 'H'
			lband_destinationband = Header!
		Case Else
			lband_destinationband = Detail!
	End Choose
	
	//-------------------------------------------------------------------
	// Case statement based on the object type
	//-------------------------------------------------------------------
	Choose Case Upper(Trim(ls_objecttype))
		Case 'B'
			ls_rtf_string = This.of_create_bitmap(ls_objectname)
			If Left(Lower(ls_rtf_string), 6) = 'error:' Then
				Return ls_rtf_string
			ElseIf Len(Trim(ls_rtf_string)) = 0 Then
				Return 'Error:  Could not create bitmap rtf document from bitmap file ' + ls_objectname
			End If
			
			This.of_addtodocument(ls_rtf_string, lband_destinationband)
		Case 'F'
			//-------------------------------------------------------------------
			// Insert a richtext file or text file into the document
			//-------------------------------------------------------------------
			If FileExists(ls_objectname) Then
				irte_control.SelectTextAll()
				irte_control.Clear()
				irte_control.InsertDocument (ls_objectname, True)
				ls_rtf_string = irte_control.CopyRTF(False)
				This.of_addtodocument(ls_rtf_string, lband_destinationband)
			Else
				Return 'Error:  The file ' + ls_objectname + ' does not exists.  The document could not be created.'
			End If
			
		Case 'D'
			If IsValid(gn_globals.of_get_object('n_transaction_pool')) Then
				lxctn_transactionobject = gn_globals.of_get_object('n_transaction_pool').Dynamic of_gettransactionobject(ll_RprtDtbseID)
			Else
				lxctn_transactionobject = SQLCA
			End If

			If IsValid(lxctn_transactionobject) Then
			Else
				Return is_transactionerror
			End If

			//----------------------------------------------------------------------------------------------------------------------------------
			// If there was a group by, we need to retrieve a datastore based on their sql statement.  We are basically joining the data in this
			//		dataobject to the sql statement that they give us.  This dataobject will retrieve X number of times where X = the rowcount of 
			//		the SQL statement they gave us.  Their sql statement also determines the order of the data.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If Len(ls_GroupByDataObject) > 0 Then
				//----------------------------------------------------------------------------------------------------------------------------------
				// Create the datastore using the defined dataobject
				//-----------------------------------------------------------------------------------------------------------------------------------
				lds_group_by_datastore = Create Datastore
				lds_group_by_datastore.DataObject = ls_GroupByDataObject
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Check if we're required to return rows and error out accordingly.
				//-----------------------------------------------------------------------------------------------------------------------------------
				If This.of_retrieve(lds_group_by_datastore, as_retrievalargument, lxctn_transactionobject) <= 0 and s_requiresrows = "Y" Then
					Return "The group-by dataobject " + lds_group_by_datastore.DataObject + " returned no rows but was configured to require rows."
				End If
				
				//----------------------------------------------------------------------------------------------------------------------------------
				// Determine the size of the matrix
				//-----------------------------------------------------------------------------------------------------------------------------------
				ll_rowcount2 		= lds_group_by_datastore.RowCount()
				ll_columncount 	= Long(lds_group_by_datastore.Describe('Datawindow.Column.Count'))

				//----------------------------------------------------------------------------------------------------------------------------------
				// Loop through every row in the datastore and retrieve the datawindow
				//-----------------------------------------------------------------------------------------------------------------------------------
				For ll_index2 = 1 To ll_rowcount2
					ls_group_by_parameter = ''

					//-------------------------------------------------------------------
					// Insert a datawindow into the document
					//-------------------------------------------------------------------
					idw_working.DataObject = ls_objectname
					idw_working.SetTransObject(lxctn_transactionobject)

					//----------------------------------------------------------------------------------------------------------------------------------
					// Loop through every column in the datastore appending it to the retrieval arguments string
					//-----------------------------------------------------------------------------------------------------------------------------------
					For ll_index3 = 1 To ll_columncount
						ls_type = lds_group_by_datastore.Describe('#' + String(ll_index3) + ".Coltype")
						
						//----------------------------------------------------------------------------------------------------------------------------------
						// Process each column based on the column type.
						//-----------------------------------------------------------------------------------------------------------------------------------
						Choose Case lower(left(ls_type,4))
							Case 'numb','long','deci'
								ls_group_by_parameter = ls_group_by_parameter + String(lds_group_by_datastore.GetItemNumber(ll_index2, ll_index3)) + '||' 
							Case 'date'
								ls_group_by_parameter = ls_group_by_parameter + String(lds_group_by_datastore.GetItemDateTime(ll_index2, ll_index3)) + '||' 
							Case 'char'
								ls_group_by_parameter = ls_group_by_parameter + String(lds_group_by_datastore.GetItemString(ll_index2, ll_index3)) + '||' 
							Case Else
								Return 'Error:  There was an unsupported column type ' + ls_type + ' in the dataobject ' + ls_objectname + ' for richtextdocument grouping'
						End Choose
						
					Next
					
					//----------------------------------------------------------------------------------------------------------------------------------
					// Cut off the last delimiter
					//-----------------------------------------------------------------------------------------------------------------------------------
					ls_group_by_parameter = Left(ls_group_by_parameter, Len(ls_group_by_parameter) - 2)
					
					//----------------------------------------------------------------------------------------------------------------------------------
					// Call the function to copy the datastore to the RTF destination
					//-----------------------------------------------------------------------------------------------------------------------------------
					This.of_copy_datawindow(as_retrievalargument + '||' + ls_group_by_parameter, lband_destinationband, lxctn_transactionobject, s_requiresrows = "Y")
					This.of_build_document(as_retrievalargument + '||' + ls_group_by_parameter, ll_RchtxtDcmntID)
				Next
				
				Destroy lds_group_by_datastore
			Else
				//-------------------------------------------------------------------
				// Insert a datawindow into the document
				//-------------------------------------------------------------------
				idw_working.DataObject = ls_objectname
				idw_working.SetTransObject(lxctn_transactionobject)

				//----------------------------------------------------------------------------------------------------------------------------------
				// If there was no group by, just retrieve the datawindow normally
				//-----------------------------------------------------------------------------------------------------------------------------------
				This.of_copy_datawindow(as_retrievalargument, lband_destinationband, lxctn_transactionobject, s_requiresrows = "Y")
				This.of_build_document(as_retrievalargument, ll_RchtxtDcmntID)				

			End If
	End Choose

	Long ll_position, ll_index4
	String ls_string

	
	If ls_PageBreakAfter = 'Y' Then
		For ll_index4 = UpperBound(is_document_detail[]) To 1 Step -1
			If Len(is_document_detail[ll_index4]) > 0 Then
				ls_string = is_document_detail[ll_index4]
				Exit
			End If
		Next

		If Len(ls_string) > 0 Then
			ls_string = Reverse(ls_string)
			ll_position = Pos(ls_string, '}')
			ll_position = Pos(ls_string, '}', ll_position + 1) + 1
			If ll_position > 0 Then
				ls_string = Replace(ls_string, ll_position, 0, '}egap\{')
				ls_string = Reverse(ls_string)
				is_document_detail[ll_index4] = ls_string
			End If
		End If
	End If
Next

Return ''

end function

public subroutine of_add_pagebreak ();This.of_addtodocument('{\Page}', Detail!)
end subroutine

private function long of_retrieve (powerobject ao_datasource, string as_arguments, transaction axctn_transactionobject);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve()
// Arguments:	as_arguments - an argument string in the form of (argument=value, argument=value)
//	Overview:   This will retrieve the report based on an argument string
//	Created by:	Blake Doerr
//	History: 	8.2.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_return
String ls_distribution_init
n_datawindow_tools ln_datawindow_tools
n_distributioninit ln_distributioninit

If IsValid(axctn_transactionobject) Then
	ao_datasource.Dynamic SetTransObject(axctn_transactionobject)
Else
	ao_datasource.Dynamic SetTransObject(SQLCA)
End If

//-------------------------------------------------------------------
// Retrieve the datawindow based on a string of arguments delimited by || which is the standard for reporting
//-------------------------------------------------------------------
ln_datawindow_tools  = Create n_datawindow_tools
ll_return = Long(ln_datawindow_tools.of_retrieve(ao_datasource, as_arguments, '||'))
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the distribution init field out of the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
ln_distributioninit = Create n_distributioninit

ls_distribution_init = ln_distributioninit.of_get_evaluated_distributioninit(ao_datasource)
if not isnull(ls_distribution_init) and len(ls_distribution_init) > 0 then
	is_distribution_init = ls_distribution_init
end if

//is_distribution_init	= ln_distributioninit.of_get_expression()

Destroy ln_distributioninit

Return ll_return
end function

protected subroutine of_apply_numbering ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_numbering()
//	Overview:   This will insert the document into the datawindow
//	Created by:	Blake Doerr
//	History: 	8.8.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index, ll_arabic_number = 1, ll_position

String	ls_capitalletter				, 	ls_capitalletterqualifier[]
String	ls_lowercaseletter[]				, 	ls_lowercaseletterqualifier[]
String	ls_roman_numeral_uppercase[]	
String	ls_roman_numeral_lowercase[]	,	ls_romannumeralqualifier[]

//-------------------------------------------------------------------
// Capital Lettering
//-------------------------------------------------------------------


//-------------------------------------------------------------------
// Insert the information for each destination band
//-------------------------------------------------------------------
ls_capitalletter = 'A'

For ll_index = 1 To UpperBound(is_document_header)
	ll_position = Pos(Lower(is_document_header[ll_index]), '\{capitalletter\}')
	DO WHILE ll_position > 0
		is_document_header[ll_index] = Replace(is_document_header[ll_index], ll_position, Len('\{capitalletter\}'), ls_capitalletter)
		
		ls_capitalletter = Char(Asc(ls_capitalletter) + 1)
		
		ll_position = Pos(Lower(is_document_header[ll_index]), '\{capitalletter\}', ll_position + 1)
	LOOP
Next

For ll_index = 1 To UpperBound(is_document_detail)
	ll_position = Pos(Lower(is_document_detail[ll_index]), '\{capitalletter\}')
	DO WHILE ll_position > 0
		is_document_detail[ll_index] = Replace(is_document_detail[ll_index], ll_position, Len('\{capitalletter\}'), ls_capitalletter)
		
		ls_capitalletter = Char(Asc(ls_capitalletter) + 1)
		
		ll_position = Pos(Lower(is_document_detail[ll_index]), '\{capitalletter\}', ll_position + 1)
	LOOP
Next

For ll_index = 1 To UpperBound(is_document_footer)
	ll_position = Pos(Lower(is_document_footer[ll_index]), '\{capitalletter\}')
	DO WHILE ll_position > 0
		is_document_footer[ll_index] = Replace(is_document_footer[ll_index], ll_position, Len('\{capitalletter\}'), ls_capitalletter)
		
		ls_capitalletter = Char(Asc(ls_capitalletter) + 1)
		
		ll_position = Pos(Lower(is_document_footer[ll_index]), '\{capitalletter\}', ll_position + 1)
	LOOP
Next


end subroutine

on n_rtf_document_builder.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_rtf_document_builder.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;Long ll_index
Destroy ids_richtextdocument

For ll_index = 1 To UpperBound(ixctn_transactionobjectpool)
	If IsValid(ixctn_transactionobjectpool[ll_index]) Then
		If ixctn_transactionobjectpool[ll_index] <> SQLCA Then
			If DBHandle(ixctn_transactionobjectpool[ll_index]) > 0 Then
				Disconnect Using ixctn_transactionobjectpool[ll_index];
			End If
			
			Destroy ixctn_transactionobjectpool[ll_index]
		End If
	End If
Next
end event

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   This will set some variables to null
//	Created by: Blake Doerr
//	History:    10/12/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

SetNull(il_margin_bottom)
SetNull(il_margin_left)
SetNull(il_margin_right)
SetNull(il_margin_top)
end event

