$PBExportHeader$n_microsoft_word_tools.sru
forward
global type n_microsoft_word_tools from nonvisualobject
end type
type str_columnlist from structure within n_microsoft_word_tools
end type
end forward

type str_columnlist from structure
	powerobject		Datasource
	string		columnname[]
	string		headername[]
	string		headertext[]
	string		columntype[]
end type

global type n_microsoft_word_tools from nonvisualobject
event ue_notify ( string as_message,  any aany_argument )
end type
global n_microsoft_word_tools n_microsoft_word_tools

type variables
Private:
	str_columnlist istr_columnlist[]
	n_OleObject	MicrosoftWordApplication
	String	is_errormessage				= ''
	Boolean	ib_ApplicationIsValid		= False
Public:
	//wdSeekView Type
	constant int wdSeekMainDocument = 0
	constant int wdSeekPrimaryHeader = 1
	constant int wdSeekFirstPageHeader = 2
	constant int wdSeekEvenPagesHeader = 3
	constant int wdSeekPrimaryFooter = 4
	constant int wdSeekFirstPageFooter = 5
	constant int wdSeekEvenPagesFooter = 6
	constant int wdSeekFootnotes = 7
	constant int wdSeekEndnotes = 8
	constant int wdSeekCurrentPageHeader = 9
	constant int wdSeekCurrentPageFooter = 10
	
	
	// WdSaveOptions
	constant int wdDoNotSaveChanges = 0
	constant int wdPromptToSaveChanges = -2
	constant int wdSaveChanges = -1
	
	// WdConstants
	Constant long wdAutoPosition = 0
	Constant long wdFirst = 1
	Constant long wdToggle = 9999998
	Constant long wdUndefined = 9999999
	Constant long wdForward = 1073741823
	Constant long wdBackward = -1073741823
	Constant long wdCreatorCode = 1297307460
	
	// WdLanguageID
	Constant long wdDanish = 1030
	Constant long wdGerman = 1031
	Constant long wdGreek = 1032
	Constant long wdEnglishUS = 1033
	Constant long wdSpanish = 1034
	Constant long wdFinnish = 1035
	Constant long wdFrench = 1036
	Constant long wdBelgianDutch = 2067
	Constant long wdBelgianFrench = 2060
	Constant long wdDutch = 1043
	Constant long wdEnglishUK = 2057
	Constant long wdItalian = 1040
	Constant long wdNoProofing = 1024
	Constant long wdPortuguese = 2070
	Constant long wdSpanishModernSort = 3082
	Constant long wdSwedish = 1053
	
	// WdCountry
	Constant long wdUS = 1
	Constant long wdNetherlands = 31
	Constant long wdFrance = 33
	Constant long wdSpain = 34
	Constant long wdItaly = 39
	Constant long wdUK = 44
	Constant long wdDenmark = 45
	Constant long wdSweden = 46
	Constant long wdGermany = 49
	Constant long wdFinland = 358
	
	// WdDictionaryType
	Constant long wdSpelling = 0
	Constant long wdGrammar = 1
	Constant long wdThesaurus = 2
	Constant long wdHyphenation = 3
	Constant long wdSpellingComplete = 4
	Constant long wdSpellingCustom = 5
	Constant long wdSpellingLegal = 6
	Constant long wdSpellingMedical = 7
	
	// WdDocumentType
	Constant long wdTypeDocument = 0
	Constant long wdTypeTemplate = 1
	
	// WdBuiltInProperty
	Constant long wdPropertyTitle = 1
	Constant long wdPropertySubjec = 2
	Constant long wdPropertyAuthor = 3
	Constant long wdPropertyConstants = 4
	Constant long wdPropertyComments = 5
	Constant long wdPropertyTemplate = 6
	Constant long wdPropertyLastAuthor = 7
	Constant long wdPropertyRevision = 8
	Constant long wdPropertyAppName = 9
	Constant long wdPropertyTimeLastPrinted = 10
	Constant long wdPropertyTimeCreated = 11
	Constant long wdPropertyTimeLastSaved = 12
	Constant long wdPropertyVBATotalEdit = 13
	Constant long wdPropertyPages = 14
	Constant long wdPropertyWords = 15
	Constant long wdPropertyCharacters = 16
	Constant long wdPropertySecurity = 17
	Constant long wdPropertyCategory = 18
	Constant long wdPropertyFormat = 19
	Constant long wdPropertyManager = 20
	Constant long wdPropertyCompany = 21
	Constant long wdPropertyBytes = 22
	Constant long wdPropertyLines = 23
	Constant long wdPropertyParas = 24
	Constant long wdPropertySlides = 25
	Constant long wdPropertyNotes = 26
	Constant long wdPropertyHiddenSlides = 27
	Constant long wdPropertyMMClips = 28
	Constant long wdPropertyHyperlinkBase = 29
	Constant long wdPropertyCharsWSpaces = 30
	
	// WdAlertLevel
	Constant long wdAlertsAll = -1
	Constant long wdAlertsMessageBox = -2
	Constant long wdAlertsNone = 0
	
	// WdArrangeStyle
	Constant long wdIcons = 1
	Constant long wdTiled = 0
	
	// WdBookmarkSortBy
	Constant long wdSortByLocation = 1
	Constant long wdSortByName = 0
	
	// WdBreakType
	Constant long wdSectionBreakNextPage = 2
	Constant long wdSectionBreakContinuous = 3
	Constant long wdSectionBreakEvenPage = 4
	Constant long wdSectionBreakOddPage = 5
	Constant long wdLineBreak = 6
	Constant long wdPageBreak = 7
	Constant long wdColumnBreak = 8
	
	// WdBrowseTarget
	Constant long wdBrowsePage = 1
	Constant long wdBrowseSection = 2
	Constant long wdBrowseComment = 3
	Constant long wdBrowseFootnote = 4
	Constant long wdBrowseEndnote = 5
	Constant long wdBrowseField = 6
	Constant long wdBrowseTable = 7
	Constant long wdBrowseGraphic = 8
	Constant long wdBrowseHeading = 9
	Constant long wdBrowseEdit = 10
	Constant long wdBrowseFind = 11
	Constant long wdBrowseGoTo = 12
	
	// WdCharacterCase
	Constant long wdLowerCase = 0
	Constant long wdUpperCase = 1
	Constant long wdTitleWord = 2
	Constant long wdTitleSentence = 4
	Constant long wdToggleCase = 5
	Constant long wdNextCase = -1
	
	// WdCollapseDirection
	Constant long wdCollapseEnd = 0
	Constant long wdCollapseStart = 1
	
	// WdInternationalIndex
	Constant long wdProductLanguageID = 26
	
	// wdWindowState
	constant int wdWindowStateNormal = 0
	constant int wdWindowStateMaximize = 1
	constant int wdWindowStateMinimize = 2
	
	// wdGoToDirection
	constant int wdGoToAbsolute = 1
	constant int wdGoToFirst = 1
	constant int wdGoToLast = -1
	constant int wdGoToNext = 2
	constant int wdGoToPrevious = 3
	constant int wdGoToRelative = 2
	
	// wdGoToItem
	constant int wdGoToBookmark = -1
	constant int wdGoToSection = 0
	constant int wdGoToPage = 1
	constant int wdGoToTable = 2
	constant int wdGoToLine = 3
	constant int wdGoToFootNote = 4
	constant int wdGoToEndNote = 5
	constant int wdGoToComment = 6
	constant int wdGoToField = 7
	constant int wdGoToGraphic = 8
	constant int wdGoToObject = 9
	constant int wdGoToEquation = 10
	constant int wdGoToHeading = 11
	constant int wdGoToPercent = 12
	constant int wdGoToSpellingError = 13
	constant int wdGoToGrammaticalError = 14
	constant int wdGoToProofReadingError = 15
	
	// wdMovementType
	constant int wdMove = 0
	constant int wdExtend = 1
	
	// wdUnits
	constant int wdCharacter = 1
	constant int wdWord = 2
	constant int wdSentence = 3
	constant int wdLine = 5
	constant int wdStory = 6
	constant int wdColumn = 9
	constant int wdRow = 10
	constant int wdCell = 12
	
	//wdViewType
	constant int wdNormalView = 1
	constant int wdOutlineView = 2
	constant int wdPageView = 3
	constant int wdPrintPreview = 4
	constant int wdMasterView = 5
	constant int wdOnlineView = 6
	

end variables

forward prototypes
public function string of_set_bookmark_text (oleobject aole_bookmarks, long al_index, string as_text)
public function string of_append_document (string as_filename, string as_filename_to_append)
public function string of_askforfile ()
public function string of_bringtofront (oleobject aole_ole)
public function string of_clear_bookmarks (string as_filename)
public function string of_get_bookmark_name (oleobject aole_bookmarks, long al_index)
public function string of_get_bookmark_text (oleobject aole_bookmarks, long al_index)
public function long of_get_bookmarks (ref oleobject aole_bookmarks)
public function long of_get_bookmarks (ref oleobject aole_bookmarks, ref oleobject aole_document)
public function long of_get_tables (ref oleobject aole_tables)
public function string of_insert_subdocument (string as_parent_document, string as_child_document, string as_bookmarkname)
public function boolean of_iserror ()
public function string of_materialize_file (string as_filename)
public function string of_materialize_file (string as_filename, boolean ab_readonly, boolean ab_visible)
public function integer of_print (oleobject aloe_document, boolean ab_backgroundprinting)
public function string of_print_file (string as_document, boolean ab_backgroundprinting)
public function string of_replace_bookmarks (powerobject ao_datasource, long al_row, string as_template_filename, string as_destination_filename)
public function string of_replace_bookmarks (powerobject ao_datasource, string as_template_filename, string as_destination_filename)
end prototypes

event ue_notify(string as_message, any aany_argument);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    	- The message being triggered
//					aany_argument (Any) 		- The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   	6/10/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Choose Case Lower(Trim(as_message))
   Case 'external exception'
		is_errormessage = String(aany_argument)
   Case Else
End Choose

end event

public function string of_set_bookmark_text (oleobject aole_bookmarks, long al_index, string as_text);aole_bookmarks.Item[al_index].Range.Text = as_text
Return ''
end function

public function string of_append_document (string as_filename, string as_filename_to_append);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_append_document()
//	Overview:   This will insert one file at the beginning of another
//	Created by:	Blake Doerr
//	History: 	2/4/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 		ls_return
Integer		li_index
If Not ib_ApplicationIsValid Then Return 'Error:  The Microsoft Word Application Object is not valid'

//-----------------------------------------------------------------------------------------------------------------------------------
// Materialize the file
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = This.of_materialize_file(as_filename)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there's an error
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return <> '' Then Return ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert the file, save and close
//-----------------------------------------------------------------------------------------------------------------------------------
li_index = MicrosoftWordApplication.Documents.Count
MicrosoftWordApplication.Documents[li_index].Range[0,0].InsertFile(as_filename_to_append)
MicrosoftWordApplication.Documents[li_index].SaveAs(as_filename)
MicrosoftWordApplication.Documents[li_index].Close(0)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public function string of_askforfile ();Long		ll_return
String	ls_path
String	ls_file

ll_return = GetFileOpenName('Select the File to Process', ls_path, ls_file, '*.doc', 'Word Documents,*.doc' )
If ll_return = 1 Then
	Return ls_path
Else
	Return 'Error:'
End If
end function

public function string of_bringtofront (oleobject aole_ole);If Not ib_ApplicationIsValid Then Return 'Error:  The Microsoft Word Application Object is not valid'

MicrosoftWordApplication.Application.ScreenUpdating = False
MicrosoftWordApplication.Application.Visible = TRUE
MicrosoftWordApplication.application.activate()
//MicrosoftWordApplication.Application.Visible = False
Return ''
end function

public function string of_clear_bookmarks (string as_filename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_clear_bookmarks()
//	Overview:   This will create a file with the bookmarks replaced with no data
//	Created by:	Blake Doerr
//	History: 	2/3/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
OleObject 	lole_Bookmarks

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 		ls_return
Long 			ll_Bookmarks, ll_I
Integer		li_index

SetPointer(HourGlass!)

If Not ib_ApplicationIsValid Then Return 'Error:  The Microsoft Word Application Object is not valid'

//-----------------------------------------------------------------------------------------------------------------------------------
// Materialize the file into the ole object
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = This.of_materialize_file(as_filename)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return <> '' Then Return ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the number of bookmarks from the document
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Bookmarks = This.of_get_bookmarks(lole_Bookmarks)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the bookmarks (backwards) and replace the bookmarks with the data from the report
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_I = ll_Bookmarks To 1 Step -1
	lole_Bookmarks.Item[ll_I].Range.Text = ''
NEXT

//-----------------------------------------------------------------------------------------------------------------------------------
// Save the resulting document into the right filename and close the document
//-----------------------------------------------------------------------------------------------------------------------------------
li_index = MicrosoftWordApplication.Documents.Count
MicrosoftWordApplication.Documents[li_index].Save()
MicrosoftWordApplication.Documents[li_index].Close(0)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public function string of_get_bookmark_name (oleobject aole_bookmarks, long al_index);Return aole_bookmarks.Item[al_index].Name
end function

public function string of_get_bookmark_text (oleobject aole_bookmarks, long al_index);Return aole_bookmarks.Item[al_index].Range.Text

end function

public function long of_get_bookmarks (ref oleobject aole_bookmarks);OleObject lole_document
Integer li_index
li_index = MicrosoftWordApplication.Documents.Count
lole_document = MicrosoftWordApplication.Application.Documents[li_index]
Return This.of_get_bookmarks(aole_bookmarks, lole_document)
end function

public function long of_get_bookmarks (ref oleobject aole_bookmarks, ref oleobject aole_document);aole_bookmarks = aole_document.Bookmarks
Return aole_bookmarks.Count
end function

public function long of_get_tables (ref oleobject aole_tables);integer li_index
li_index = MicrosoftWordApplication.Documents.Count
aole_tables = MicrosoftWordApplication.Application.Documents[li_index].Tables
Return aole_tables.Count
end function

public function string of_insert_subdocument (string as_parent_document, string as_child_document, string as_bookmarkname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_bookmarks()
//	Overview:   This will create a file with the bookmarks replaced with data from a report
//	Created by:	Blake Doerr
//	History: 	2/3/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
OleObject 	lole_OLE_Container
OleObject 	lole_Bookmarks
Integer li_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 		ls_return, ls_Name, ls_BookName, ls_BookData
Long 			ll_RC, ll_Bookmarks, ll_I
Long			ll_columnid
Long			ll_row
String	ls_columnname[]
String	ls_headername[]
String	ls_headertext[]
String	ls_columntype[]
String	ls_empty[]

SetPointer(HourGlass!)

If Not ib_ApplicationIsValid Then Return 'Error:  The Microsoft Word Application Object is not valid'

If Not FileExists(as_child_document) Then Return 'Error:  Subdocument did not exist (' + as_child_document + ')'

//-----------------------------------------------------------------------------------------------------------------------------------
// Materialize the file into the ole object
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = This.of_materialize_file(as_parent_document)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return <> '' Then Return ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the number of bookmarks from the document
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Bookmarks = This.of_get_bookmarks(lole_Bookmarks)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the bookmarks (backwards) and replace the bookmarks with the data from the report
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_I = ll_Bookmarks To 1 Step -1
	ls_BookName = This.of_get_bookmark_name(lole_Bookmarks, ll_I)
	If Lower(Trim(as_bookmarkname)) <> Lower(Trim(ls_BookName)) Then Continue

	lole_Bookmarks.Item[ll_I].Range.InsertFile(as_child_document)
NEXT

//-----------------------------------------------------------------------------------------------------------------------------------
// Save the resulting document into the right filename and close the document
//-----------------------------------------------------------------------------------------------------------------------------------
li_index = MicrosoftWordApplication.Documents.Count
MicrosoftWordApplication.Documents[li_index].SaveAs(as_parent_document)
MicrosoftWordApplication.Documents[li_index].Close(0)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

public function boolean of_iserror ();Return Len(is_errormessage) > 0
end function

public function string of_materialize_file (string as_filename);Return This.of_materialize_file(as_filename, False, False)
end function

public function string of_materialize_file (string as_filename, boolean ab_readonly, boolean ab_visible);If Not FileExists(as_filename) Then Return 'Error:  File does not exists (' + as_filename + ')'

MicrosoftWordApplication.Documents.Open(as_filename, False, ab_readonly, False, "", "", False, "", "",0)

Return ''
end function

public function integer of_print (oleobject aloe_document, boolean ab_backgroundprinting);aloe_document.PrintOut(ab_backgroundprinting,False,0,"","","",0,1)

Return 1
end function

public function string of_print_file (string as_document, boolean ab_backgroundprinting);String	ls_return
Integer li_index

If Not ib_ApplicationIsValid Then Return 'Error:  The Microsoft Word Application Object is not valid'

ls_return = This.of_materialize_file(as_document, True, False)

If ls_return <> '' Then Return ls_return

If MicrosoftWordApplication.Documents.Count > 0 Then
	li_index = MicrosoftWordApplication.Documents.Count
	This.of_print(MicrosoftWordApplication.Documents[li_index], ab_backgroundprinting)
End If
	

//lole_word.PrintOut(ab_backgroundprinting, False, 0, "", "", "", 0, 1)
If IsValid(MicrosoftWordApplication) Then 
	li_index = MicrosoftWordApplication.Documents.Count
	MicrosoftWordApplication.Documents[li_index].Close(0)
END IF

Return ''
end function

public function string of_replace_bookmarks (powerobject ao_datasource, long al_row, string as_template_filename, string as_destination_filename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_bookmarks()
//	Overview:   This will create a file with the bookmarks replaced with data from a report
//	Created by:	Blake Doerr
//	History: 	2/3/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
//n_string_functions ln_string_functions
n_blob_manipulator ln_blob_manipulator
OleObject	lole_document
OleObject 	lole_OLE_Container
OleObject 	lole_Bookmarks
OleObject	lole_PictureObject
Integer li_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_IsSignature
Blob		lblob_signaturefile
Blob		lblob_objectdata
Long 		ll_RC, ll_Bookmarks, ll_I
Long		ll_columnid
Long		ll_row
Long		ll_index
String 	ls_return
String	ls_Name
String	ls_BookName
String	ls_BookData
String	ls_filename
String	ls_columnname[]
String	ls_headername[]
String	ls_headertext[]
String	ls_columntype[]
String	ls_empty[]
//
//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Replacing Bookmarks on Row ' + String(al_row), 'Document Generation')
//End If
//
SetPointer(HourGlass!)

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Materialize File')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Materialize the file into the ole object
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = This.of_materialize_file(as_template_filename)

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Materialize File')
//End If
//

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return <> '' Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Replacing Bookmarks on Row ' + String(al_row))
//	End If
	
	Return ls_return
End If

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Getting Columns')
//End If
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the columns available from the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools

For ll_index = 1 To UpperBound(istr_columnlist[])
	If ao_datasource = istr_columnlist[ll_index].DataSource Then
		ls_columnname[]	= istr_columnlist[ll_index].columnname[]
		ls_headername[]	= istr_columnlist[ll_index].headername[]
		ls_headertext[]	= istr_columnlist[ll_index].headertext[]
		ls_columntype[]	= istr_columnlist[ll_index].columntype[]
		Exit
	End If
Next

If ll_index > UpperBound(istr_columnlist[]) Then
	ln_datawindow_tools.of_get_columns_all(ao_datasource, ls_columnname[], ls_headername[], ls_headertext[], ls_columntype[])
	istr_columnlist[ll_index].Datasource = ao_datasource
	istr_columnlist[ll_index].columnname[]	= ls_columnname[]
	istr_columnlist[ll_index].headername[]	= ls_headername[]
	istr_columnlist[ll_index].headertext[]	= ls_headertext[]
	istr_columnlist[ll_index].columntype[]	= ls_columntype[]
End If

For ll_index = 1 To UpperBound(ls_headertext[])
	ls_headertext[ll_index] = Lower(Trim(gn_globals.in_string_functions.of_removenonalphanumeric(ls_headertext[ll_index])))
Next

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Getting Columns')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the number of bookmarks from the document
//-----------------------------------------------------------------------------------------------------------------------------------
//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Getting Bookmarks')
//End If

ll_Bookmarks = This.of_get_bookmarks(lole_Bookmarks)

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Getting Bookmarks')
//End If
//
//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Bookmark Replacement Loop')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the bookmarks (backwards) and replace the bookmarks with the data from the report
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_I = ll_Bookmarks To 1 Step -1
	ll_columnid = 0
	ls_BookName = Lower(Trim(This.of_get_bookmark_name(lole_Bookmarks, ll_I)))
	lb_IsSignature = Lower(Right(ls_BookName, Len('SignatureBlobObjectID'))) = Lower('SignatureBlobObjectID')
	If lb_IsSignature Then ls_BookName = Left(ls_BookName, Len(ls_BookName) - Len('SignatureBlobObjectID'))

	For ll_index = 1 To UpperBound(ls_headertext[])
		If ls_headertext[ll_index] = ls_BookName Then
			ll_columnid = ll_index
			Exit
		End If
	Next

	If Not ll_columnid > 0 Then
		If IsNumber(Right(ls_BookName, 1)) Then
			ls_BookName = Left(ls_BookName, Len(ls_BookName) - 1)
			lb_IsSignature = Lower(Right(ls_BookName, Len('SignatureBlobObjectID'))) = Lower('SignatureBlobObjectID')
			If lb_IsSignature Then ls_BookName = Left(ls_BookName, Len(ls_BookName) - Len('SignatureBlobObjectID'))
			
			For ll_index = 1 To UpperBound(ls_headertext[])
				If ls_headertext[ll_index] = ls_BookName Then
					ll_columnid = ll_index
					Exit
				End If
			Next
		End If
	End If

	If Not ll_columnid > 0 Then
		If IsNumber(Right(ls_BookName, 1)) Then
			ls_BookName = Left(ls_BookName, Len(ls_BookName) - 1)
			
			lb_IsSignature = Lower(Right(ls_BookName, Len('SignatureBlobObjectID'))) = Lower('SignatureBlobObjectID')
			If lb_IsSignature Then ls_BookName = Left(ls_BookName, Len(ls_BookName) - Len('SignatureBlobObjectID'))

			For ll_index = 1 To UpperBound(ls_headertext[])
				If ls_headertext[ll_index] = ls_BookName Then
					ll_columnid = ll_index
					Exit
				End If
			Next
		End If
	End If

	If ll_columnid > 0 Then
		If lb_IsSignature Then
			ln_blob_manipulator = Create n_blob_manipulator
			lblob_signaturefile = ln_blob_manipulator.of_retrieve_signature(Long(ln_datawindow_tools.of_getitem(ao_datasource, al_row, ls_columnname[ll_columnid])))
			If Len(lblob_signaturefile) > 0 Then
				ls_filename = ln_blob_manipulator.of_determine_filename('Signature.bmp')
				ln_blob_manipulator.of_build_file_from_blob(lblob_signaturefile, ls_filename)
				If FileExists(ls_filename) Then
					li_index = MicrosoftWordApplication.Documents.Count
					lole_PictureObject = MicrosoftWordApplication.Documents[li_index].Range[0,0].InlineShapes.AddPicture(ls_filename, False, True)
					lole_PictureObject.Range.Cut()
					lole_Bookmarks.Item[ll_I].Range.Paste()//InlineShapes.AddPicture(ls_filename, False, True)
					FileDelete(ls_filename)
				End If
			End If
			Destroy ln_blob_manipulator
		Else
			ls_BookData = ln_datawindow_tools.of_get_lookupdisplay(ao_datasource, al_row, ls_columnname[ll_columnid])
			lole_Bookmarks.Item[ll_I].Range.Text = ls_BookData
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datawindow tools
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Bookmark Replacement Loop')
//End If
//
//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('File Saving')
//End If
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Delete the file if it already exists
//-----------------------------------------------------------------------------------------------------------------------------------
If FileExists(as_destination_filename) Then FileDelete(as_destination_filename)

If FileExists(as_destination_filename) Then
	ls_return = 'Error:  File "' + as_destination_filename + '" is locked and cannot be overwritten'
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Save the resulting document into the right filename and close the document
	//-----------------------------------------------------------------------------------------------------------------------------------
//	ln_blob_manipulator = Create n_blob_manipulator
//	lole_document = MicrosoftWordApplication.Documents[MicrosoftWordApplication.Documents.Count]
//	lblob_objectdata = lole_document.ObjectData
//	ln_blob_manipulator.of_build_file_from_blob(lblob_objectdata, as_destination_filename)
//	Destroy ln_blob_manipulator
	li_index = MicrosoftWordApplication.Documents.Count
	MicrosoftWordApplication.Documents[li_index].SaveAs(as_destination_filename)
End If

li_index = MicrosoftWordApplication.Documents.Count
MicrosoftWordApplication.Documents[li_index].Close(0)

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('File Saving')
//End If
//
//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Replacing Bookmarks on Row ' + String(al_row))
//End If
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Return Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

public function string of_replace_bookmarks (powerobject ao_datasource, string as_template_filename, string as_destination_filename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_bookmarks()
//	Overview:   This will create a file with the bookmarks replaced with data from a report
//	Created by:	Blake Doerr
//	History: 	2/3/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
//n_string_functions ln_string_functions
n_blob_manipulator ln_blob_manipulator
OleObject	lole_document
OleObject lole_Bookmarks
OleObject	lole_PictureObject
OleObject	lole_templatedocument
OleObject	lole_finaldocument
Integer		li_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_IsSignature
Blob		lblob_signaturefile
Blob		lblob_objectdata
Long 		ll_RC, ll_Bookmarks, ll_I
Long		ll_columnid
Long		ll_row
Long		ll_index
Long		ll_rowcount
String 	ls_return
String	ls_Name
String	ls_BookName
String	ls_BookData
String	ls_filename
String	ls_columnname[]
String	ls_headername[]
String	ls_headertext[]
String	ls_columntype[]
String	ls_empty[]

SetPointer(HourGlass!)

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Getting Columns')
//End If
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the columns available from the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools

For ll_index = 1 To UpperBound(istr_columnlist[])
	If ao_datasource = istr_columnlist[ll_index].DataSource Then
		ls_columnname[]	= istr_columnlist[ll_index].columnname[]
		ls_headername[]	= istr_columnlist[ll_index].headername[]
		ls_headertext[]	= istr_columnlist[ll_index].headertext[]
		ls_columntype[]	= istr_columnlist[ll_index].columntype[]
		Exit
	End If
Next

If ll_index > UpperBound(istr_columnlist[]) Then
	ln_datawindow_tools.of_get_columns_all(ao_datasource, ls_columnname[], ls_headername[], ls_headertext[], ls_columntype[])
	istr_columnlist[ll_index].Datasource = ao_datasource
	istr_columnlist[ll_index].columnname[]	= ls_columnname[]
	istr_columnlist[ll_index].headername[]	= ls_headername[]
	istr_columnlist[ll_index].headertext[]	= ls_headertext[]
	istr_columnlist[ll_index].columntype[]	= ls_columntype[]
End If

For ll_index = 1 To UpperBound(ls_headertext[])
	ls_headertext[ll_index] = Lower(Trim(gn_globals.in_string_functions.of_removenonalphanumeric(ls_headertext[ll_index])))
Next

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Getting Columns')
//End If
//
//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Materialize File')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Materialize the file into the ole object
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = This.of_materialize_file(as_template_filename)

li_index = MicrosoftWordApplication.Documents.Count
lole_templatedocument 	= MicrosoftWordApplication.Documents[li_index]
lole_finaldocument 		= MicrosoftWordApplication.Documents.Add()

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Materialize File')
//End If
//

ll_rowcount = ao_datasource.Dynamic RowCount()

For ll_row = ll_rowcount To 1 Step -1
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Replacing Bookmarks on Row ' + String(ll_row), 'Document Generation')
//	End If
	
	lole_templatedocument.Range.Copy()
	lole_finaldocument.Range[0, 0].Paste()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the number of bookmarks from the document
	//-----------------------------------------------------------------------------------------------------------------------------------
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Getting Bookmarks')
//	End If
	
	ll_Bookmarks = This.of_get_bookmarks(lole_Bookmarks, lole_finaldocument)
	
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Getting Bookmarks')
//	End If
//	
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Bookmark Replacement Loop')
//	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through the bookmarks (backwards) and replace the bookmarks with the data from the report
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_I = ll_Bookmarks To 1 Step -1
		ll_columnid = 0
		ls_BookName = Lower(Trim(This.of_get_bookmark_name(lole_Bookmarks, ll_I)))
		lb_IsSignature = Lower(Right(ls_BookName, Len('SignatureBlobObjectID'))) = Lower('SignatureBlobObjectID')
		If lb_IsSignature Then ls_BookName = Left(ls_BookName, Len(ls_BookName) - Len('SignatureBlobObjectID'))
	
		For ll_index = 1 To UpperBound(ls_headertext[])
			If ls_headertext[ll_index] = ls_BookName Then
				ll_columnid = ll_index
				Exit
			End If
		Next
	
		If Not ll_columnid > 0 Then
			If IsNumber(Right(ls_BookName, 1)) Then
				ls_BookName = Left(ls_BookName, Len(ls_BookName) - 1)
				lb_IsSignature = Lower(Right(ls_BookName, Len('SignatureBlobObjectID'))) = Lower('SignatureBlobObjectID')
				If lb_IsSignature Then ls_BookName = Left(ls_BookName, Len(ls_BookName) - Len('SignatureBlobObjectID'))
				
				For ll_index = 1 To UpperBound(ls_headertext[])
					If ls_headertext[ll_index] = ls_BookName Then
						ll_columnid = ll_index
						Exit
					End If
				Next
			End If
		End If
	
		If Not ll_columnid > 0 Then
			If IsNumber(Right(ls_BookName, 1)) Then
				ls_BookName = Left(ls_BookName, Len(ls_BookName) - 1)
				
				lb_IsSignature = Lower(Right(ls_BookName, Len('SignatureBlobObjectID'))) = Lower('SignatureBlobObjectID')
				If lb_IsSignature Then ls_BookName = Left(ls_BookName, Len(ls_BookName) - Len('SignatureBlobObjectID'))
	
				For ll_index = 1 To UpperBound(ls_headertext[])
					If ls_headertext[ll_index] = ls_BookName Then
						ll_columnid = ll_index
						Exit
					End If
				Next
			End If
		End If
	
		If ll_columnid > 0 Then
			If lb_IsSignature Then
				ln_blob_manipulator = Create n_blob_manipulator
				lblob_signaturefile = ln_blob_manipulator.of_retrieve_signature(Long(ln_datawindow_tools.of_getitem(ao_datasource, ll_row, ls_columnname[ll_columnid])))
				If Len(lblob_signaturefile) > 0 Then
					ls_filename = ln_blob_manipulator.of_determine_filename('Signature.bmp')
					ln_blob_manipulator.of_build_file_from_blob(lblob_signaturefile, ls_filename)
					If FileExists(ls_filename) Then
						lole_PictureObject = lole_finaldocument.Range[0,0].InlineShapes.AddPicture(ls_filename, False, True)
						lole_PictureObject.Range.Cut()
						lole_Bookmarks.Item[ll_I].Range.Paste()//InlineShapes.AddPicture(ls_filename, False, True)
						FileDelete(ls_filename)
					End If
				End If
				Destroy ln_blob_manipulator
			Else
				ls_BookData = ln_datawindow_tools.of_get_lookupdisplay(ao_datasource, ll_row, ls_columnname[ll_columnid])
				lole_Bookmarks.Item[ll_I].Range.Text = ls_BookData
			End If
		End If
	Next
	
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Bookmark Replacement Loop')
//	End If
//	
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Replacing Bookmarks on Row ' + String(ll_row))
//	End If
Next

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('File Saving')
//End If
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datawindow tools
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools


//-----------------------------------------------------------------------------------------------------------------------------------
// Delete the file if it already exists
//-----------------------------------------------------------------------------------------------------------------------------------
If FileExists(as_destination_filename) Then FileDelete(as_destination_filename)

If FileExists(as_destination_filename) Then
	ls_return = 'Error:  File "' + as_destination_filename + '" is locked and cannot be overwritten'
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Save the resulting document into the right filename and close the document
	//-----------------------------------------------------------------------------------------------------------------------------------
//	ln_blob_manipulator = Create n_blob_manipulator
//	lole_document = MicrosoftWordApplication.Documents[MicrosoftWordApplication.Documents.Count]
//	lblob_objectdata = lole_document.ObjectData
//	ln_blob_manipulator.of_build_file_from_blob(lblob_objectdata, as_destination_filename)
//	Destroy ln_blob_manipulator
	lole_finaldocument.SaveAs(as_destination_filename)
End If

lole_templatedocument.Close(0)
lole_finaldocument.Close(0)

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('File Saving')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

on n_microsoft_word_tools.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_microsoft_word_tools.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;Long	ll_rc
MicrosoftWordApplication = Create n_OleObject
MicrosoftWordApplication.of_set_messageobject(This)
ll_rc = MicrosoftWordApplication.ConnectToNewObject( 'word.application.8' )

Choose Case ll_rc
	Case -1
		is_errormessage =  "Invalid call: the argument is the Object property of a control"
	Case -2
		is_errormessage =  "Class name not found"
	Case -3
		is_errormessage =  "Object could not be created"
	Case -4
		is_errormessage =  "Could not connect to object"
	Case -5
		is_errormessage =  "Can't connect to the currently active object"
	Case -6
		is_errormessage =  "Filename is not valid"
	Case -7
		is_errormessage = "File not found or file couldn't be opened"
	Case -8
		is_errormessage = "Load from file not supported by server"
	Case -9
		is_errormessage = "Other error"
	Case Else
		If IsValid(MicrosoftWordApplication) Then
			//MicrosoftWordApplication.CommandBars.ActiveMenuBar.Controls[1].SetFocus()
			MicrosoftWordApplication.Application.ScreenUpdating=False
			MicrosoftWordApplication.Visible = False
			is_errormessage	= ''
			ib_ApplicationIsValid	= True
//and set the Application.Left property to -1000 so it does not show.

		End If
End choose

/*
//ActiveWindow.View.ShowBookmarks = False
//ActiveWindow.View.ShowBookmarks = True

Select, All (Entire Document):
Selection.WholeStory

Paste:
Selection.Paste

Insert Page Break:
Selection.InsertBreak Type:=wdPageBreak

Insert Paragraph Symbol:
Selection.TypeText Text:=Chr$(182)

Indent, Set Left Indent:
Selection.ParagraphFormat.LeftIndent = InchesToPoints(3.75)

Indent, Set Right Indent:
Selection.ParagraphFormat.RightIndent = InchesToPoints(1)

Document, Unprotect Document:
If ActiveDocument.ProtectionType := wdNoProtection Then
   ActiveDocument.Unprotect Password:="readonly"
End If

Document, Protect Document:
ActiveDocument.Protect Password:="[password]", _
   NoReset:=False, Type:=wdAllowOnlyFormFields

Document, Save Document:
ActiveDocument.Save

Document, SaveAs
ActiveDocument.SaveAs ("C:\Temp\MyFile.doc")

Document, SaveAs (with all the junk):
ActiveDocument.SaveAs FileName:="C:\Temp\MyFile.doc", 
   FileFormat:=wdFormatDocument, LockComments:=False, _
   Password:="", AddToRecentFiles:=True, WritePassword:="", _
   ReadOnlyRecommended:=False, EmbedTrueTypeFonts:=False, _
   SaveNativePictureFormat:=False, SaveFormsData:=False, _
   SaveAsAOCELetter:=False

Document, Go to Start of Document:
Selection.HomeKey Unit:=wdStory

Document, Go to End of Document:
Selection.EndKey Unit:=wdStory

Copy Entire Document:
Selection.HomeKey Unit:=wdStory
Selection.Extend

Copy:
Selection.Copy

Bookmark, Select a Bookmark:
(This method works when using bookmarks in Headers/Footers)
ActiveDocument.Bookmarks("BookmarkName").Select

*/
end event

event destructor;If IsValid(MicrosoftWordApplication) Then
	If ib_ApplicationIsValid Then
		MicrosoftWordApplication.Quit()
		MicrosoftWordApplication.DisconnectObject()
	End If
	Destroy MicrosoftWordApplication
End If
end event

