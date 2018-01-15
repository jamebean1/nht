$PBExportHeader$n_reportconfignested_document.sru
forward
global type n_reportconfignested_document from nonvisualobject
end type
end forward

global type n_reportconfignested_document from nonvisualobject
end type
global n_reportconfignested_document n_reportconfignested_document

type variables
Public:
	//-----------------------------------------------------------------------------------------------------------------------------------
	// 
	//-----------------------------------------------------------------------------------------------------------------------------------
	n_microsoft_word_tools in_microsoft_word_tools

	n_reportconfignested_document in_child_reportconfignested_document[]
	
	UserObject iu_search_datasource

	Long		il_blobobjectid
	Long		il_rowid
	Long		il_parentrowid
	String	is_bookmarkname
	String	is_document_path
	String	is_template_path
	Boolean	ib_testing = false
	Boolean	ib_DeleteTemplate = True
	Boolean	ib_MicrsoftWordToolsWasCreatedByThisObject = False
end variables

forward prototypes
public function string of_create_template ()
public subroutine of_set_n_microsoft_word_tools (n_microsoft_word_tools an_microsoft_word_tools)
public subroutine of_clear_bookmarks ()
public function string of_replace_bookmarks ()
end prototypes

public function string of_create_template ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_create_template
// Overview:	create the template as a file
// Created by:	
// History:		
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_return
Long		ll_index
String	ls_file
String	ls_return
Blob		lblob_template

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_blob_manipulator ln_blob_manipulator

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the blob manipulator
//-----------------------------------------------------------------------------------------------------------------------------------
ln_blob_manipulator = Create n_blob_manipulator

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the template file name
//-----------------------------------------------------------------------------------------------------------------------------------
If il_rowid = 0 Or IsNull(il_rowid) Then
	This.is_template_path	= ln_blob_manipulator.of_determine_filename("CustomerFocus Document Template.doc")
Else
	This.is_template_path	= ln_blob_manipulator.of_determine_filename("CustomerFocus Subdocument " + String(il_rowid) + " Template.doc")
End If

This.is_document_path	= This.is_template_path

//-----------------------------------------------------------------------------------------------------------------------------------
// If the file already exists, delete it
//-----------------------------------------------------------------------------------------------------------------------------------
If FileExists(This.is_template_path) Then FileDelete(This.is_template_path)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are testing and the blob object is null, we will allow you to pick a file
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(il_blobobjectid) And ib_testing Then
	ll_return = GetFileOpenName('Select the Master Document File to Process', This.is_template_path, ls_file, '*.doc', 'Word Documents,*.doc' )
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Retrieve the blob from the database
	//-----------------------------------------------------------------------------------------------------------------------------------
	lblob_template	= ln_blob_manipulator.of_retrieve_blob(il_blobobjectid)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// The blob can be a file or a file path, handle it accordingly
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case Lower(Trim(ln_blob_manipulator.of_get_blob_qualifier()))
		Case 'report path'
			This.ib_DeleteTemplate = False
			This.is_template_path = String(lblob_template)
			
			If Not FileExists(This.is_template_path) Then
				ls_return = ls_return + 'Error:  The template document was stored on a file server and did not exist for header row (' + This.is_template_path + ')' + '~r~n'
			End If
			
		Case Else
			If Not ln_blob_manipulator.of_build_file_from_blob(lblob_template, This.is_template_path) Then
				ls_return = ls_return + 'Error:  Could not create template file for row ' + String(il_rowid) + '~r~n'
			End If
	End Choose	
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the blob manipulator
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_blob_manipulator

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the recursive function that will create all the child templates
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_child_reportconfignested_document[])
	ls_return = ls_return + in_child_reportconfignested_document[ll_index].of_create_template()
	If ls_return > '' And Not Right(ls_return, 2) = '~r~n' Then ls_return = ls_return + '~r~n'
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the error message
//-----------------------------------------------------------------------------------------------------------------------------------
Return Left(ls_return, Len(ls_return) - 2)
end function

public subroutine of_set_n_microsoft_word_tools (n_microsoft_word_tools an_microsoft_word_tools);Long	ll_index

If IsValid(in_microsoft_word_tools) Then
	If ib_MicrsoftWordToolsWasCreatedByThisObject Then
		Destroy in_microsoft_word_tools
	End If
End If

in_microsoft_word_tools = an_microsoft_word_tools
ib_MicrsoftWordToolsWasCreatedByThisObject = False

For ll_index = 1 To UpperBound(in_child_reportconfignested_document[])
	If Not IsValid(in_child_reportconfignested_document[ll_index]) Then Continue
	in_child_reportconfignested_document[ll_index].of_set_n_microsoft_word_tools(in_microsoft_word_tools)
Next
end subroutine

public subroutine of_clear_bookmarks ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_clear_bookmarks()
//	Overview:   This will clear the bookmarks for this document
//	Created by:	Blake Doerr
//	History: 	2/4/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the microsoft word tools
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(in_microsoft_word_tools) Then
	in_microsoft_word_tools = Create n_microsoft_word_tools
	ib_MicrsoftWordToolsWasCreatedByThisObject = True
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the microsoft word tools and clear all the bookmarks
//-----------------------------------------------------------------------------------------------------------------------------------
in_microsoft_word_tools.of_clear_bookmarks(is_document_path)

end subroutine

public function string of_replace_bookmarks ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_bookmarks()
//	Overview:   This will replace all the bookmarks and recurse through the children
//	Created by:	Blake Doerr
//	History: 	2/4/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_row
Long		ll_rowcount
String	ls_documentpath
String	ls_final_document_path
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the microsoft word tools
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(in_microsoft_word_tools) Then
	in_microsoft_word_tools = Create n_microsoft_word_tools
	ib_MicrsoftWordToolsWasCreatedByThisObject = True
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the rowcount of the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = iu_search_datasource.Dynamic of_get_report_dw().RowCount()

If UpperBound(in_child_reportconfignested_document[]) = 0 Then
	is_document_path = Left(is_template_path, Len(is_template_path) - Len('Template.doc')) + 'Row ' + String(ll_row) + ' (' + String(DateTime(Today(), Now()), "mm-dd-yyyy-hh-mm-ss") + ').doc'	
	ls_return = in_microsoft_word_tools.of_replace_bookmarks(iu_search_datasource.Dynamic of_get_report_dw(), is_template_path, is_document_path)
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through all the rows in the datawindow and replace the bookmarks
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_row = 1 To ll_rowcount
//		If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//			gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Replacing Bookmarks on Row ' + String(ll_row))
//		End If
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the row, so all children will retrieve
		//-----------------------------------------------------------------------------------------------------------------------------------
		iu_search_datasource.Dynamic of_get_report_dw().SetRow(ll_row)
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Replace all bookmarks for this row
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ll_row = iu_search_datasource.Dynamic of_Get_report_dw().RowCount() Then
			ls_documentpath	= Left(is_document_path, Len(is_document_path) - Len('Template.doc')) + 'Row ' + String(ll_row) + ' (' + String(DateTime(Today(), Now()), "mm-dd-yyyy-hh-mm-ss") + ').doc'	
		Else
			ls_documentpath	= Left(is_document_path, Len(is_document_path) - Len('Template.doc')) + 'Row ' + String(ll_row) + '.doc'		
		End If
		ls_return = in_microsoft_word_tools.of_replace_bookmarks(iu_search_datasource.Dynamic of_get_report_dw(), ll_row, is_template_path, ls_documentpath)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop through all the children and replace the bookmarks
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index = 1 To UpperBound(in_child_reportconfignested_document[])
//			If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//				gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Replacing Child Bookmarks')
//			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Replace all bookmarks
			//-----------------------------------------------------------------------------------------------------------------------------------
			in_child_reportconfignested_document[ll_index].of_replace_bookmarks()
	
//			If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//				gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Replacing Child Bookmarks')
//			End If
	
	//		If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
	//			gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Clearing Child Bookmarks')
	//		End If
	//
	//		//-----------------------------------------------------------------------------------------------------------------------------------
	//		// Clear all bookmarks that didn't get replaced
	//		//-----------------------------------------------------------------------------------------------------------------------------------
	//		in_child_reportconfignested_document[ll_index].of_clear_bookmarks()
	//		
	//		If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
	//			gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Clearing Child Bookmarks')
	//		End If
			
//			If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//				gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Inserting Subdocuments')
//			End If
	
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Insert sub document into current document
			//-----------------------------------------------------------------------------------------------------------------------------------
			in_microsoft_word_tools.of_insert_subdocument(ls_documentpath, in_child_reportconfignested_document[ll_index].is_document_path, in_child_reportconfignested_document[ll_index].is_bookmarkname)
	
//			If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//				gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Inserting Subdocuments')
//			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Delete the child document's file
			//-----------------------------------------------------------------------------------------------------------------------------------
			FileDelete(in_child_reportconfignested_document[ll_index].is_document_path)
		Next
	
//		If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//			gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Replacing Bookmarks on Row ' + String(ll_row))
//		End If
	Next

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Append all the documents together and delete the unneeded file
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_final_document_path	= ls_documentpath
	
	For ll_row = ll_rowcount - 1 To 1 Step -1
		ls_documentpath	= Left(is_document_path, Len(is_document_path) - Len('Template.doc')) + 'Row ' + String(ll_row) + '.doc'
		in_microsoft_word_tools.of_append_document(ls_final_document_path, ls_documentpath)
		FileDelete(ls_documentpath)
	Next
	
	is_document_path = ls_final_document_path
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Return success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

on n_reportconfignested_document.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_reportconfignested_document.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;Long	ll_index

If FileExists(is_template_path) And Not ib_testing And ib_DeleteTemplate Then FileDelete(is_template_path)
//If FileExists(is_document_path) Then FileDelete(is_document_path)

For ll_index = 1 To UpperBound(in_child_reportconfignested_document[])
	Destroy in_child_reportconfignested_document[ll_index]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the microsoft word tools
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(in_microsoft_word_tools) And ib_MicrsoftWordToolsWasCreatedByThisObject Then Destroy in_microsoft_word_tools
end event

