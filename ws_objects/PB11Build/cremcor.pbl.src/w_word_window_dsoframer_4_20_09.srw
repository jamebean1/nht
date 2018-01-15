$PBExportHeader$w_word_window_dsoframer_4_20_09.srw
$PBExportComments$The window doesn't close correctly, it thinks it is still open
forward
global type w_word_window_dsoframer_4_20_09 from w_main_std
end type
type ole_wordocx from olecustomcontrol within w_word_window_dsoframer_4_20_09
end type
type rte_1 from richtextedit within w_word_window_dsoframer_4_20_09
end type
end forward

global type w_word_window_dsoframer_4_20_09 from w_main_std
integer width = 3653
integer height = 1984
string menuname = "m_editing"
ole_wordocx ole_wordocx
rte_1 rte_1
end type
global w_word_window_dsoframer_4_20_09 w_word_window_dsoframer_4_20_09

type variables
// MS Word Constants ********************************************************************
// WdGoToItem Constants
CONSTANT	INTEGER	wdGoToBookmark = -1
CONSTANT	INTEGER	wdGoToComment = 6
CONSTANT	INTEGER	wdGoToEndnote = 5
CONSTANT	INTEGER	wdGoToEquation = 10
CONSTANT	INTEGER	wdGoToField = 7
CONSTANT	INTEGER	wdGoToFootnote = 4
CONSTANT	INTEGER	wdGoToGrammaticalError = 14
CONSTANT	INTEGER	wdGoToGraphic = 8
CONSTANT	INTEGER	wdGoToHeading = 11
CONSTANT	INTEGER	wdGoToLine = 3
CONSTANT	INTEGER	wdGoToObject = 9
CONSTANT	INTEGER	wdGoToPage = 1
CONSTANT	INTEGER	wdGoToPercent = 12
CONSTANT	INTEGER	wdGoToProofreadingError = 15
CONSTANT	INTEGER	wdGoToSection = 0
CONSTANT	INTEGER	wdGoToSpellingError = 13
CONSTANT	INTEGER	wdGoToTable = 2

// WdGoToDirection Constants
CONSTANT	INTEGER	wdGoToAbsolute = 1
CONSTANT	INTEGER	wdGoToFirst = 1
CONSTANT	INTEGER	wdGoToLast = -1
CONSTANT	INTEGER	wdGoToNext = 2
CONSTANT	INTEGER	wdGoToPrevious = 3
CONSTANT	INTEGER	wdGoToRelative = 2

// WdWordDialog Constants
CONSTANT	INTEGER	wdDialogFilePrint	= 88

// Home Key Movement Units
CONSTANT	INTEGER	wdLine				= 5
CONSTANT	INTEGER	wdStory				= 6
CONSTANT	INTEGER	wdColumn				= 9
CONSTANT	INTEGER	wdRow					= 10

// Home Key Movement Methods
CONSTANT INTEGER	wdMove				= 0
CONSTANT	INTEGER	wdExtend				= 1

// View Types
CONSTANT	INTEGER	wdNormalView 		= 1
CONSTANT	INTEGER	wdOutlineView 		= 2
CONSTANT	INTEGER	wdPrintView 		= 3
CONSTANT	INTEGER	wdPrintPreview		= 4
CONSTANT	INTEGER	wdMasterView 		= 5
CONSTANT	INTEGER	wdWebView 			= 6

// Zoom Page Fit Options
CONSTANT	INTEGER	wdPageFitNone		= 0
CONSTANT	INTEGER	wdPageFitFullPage	= 1
CONSTANT	INTEGER	wdPageFitBestFit	= 2
CONSTANT	INTEGER	wdPageFitTextFit	= 3

// Special Pane Options
CONSTANT	INTEGER	wdPaneNone									= 0
CONSTANT	INTEGER	wdPanePrimaryHeader						= 1
CONSTANT	INTEGER	wdPaneFirstPageHeader					= 2
CONSTANT	INTEGER	wdPaneEvenPagesHeader					= 3
CONSTANT	INTEGER	wdPanePrimaryFooter						= 4
CONSTANT	INTEGER	wdPaneFirstPageFooter					= 5
CONSTANT	INTEGER	wdPaneEvenPagesFooter					= 6
CONSTANT	INTEGER	wdPaneFootnotes							= 7
CONSTANT	INTEGER	wdPaneEndnotes								= 8
CONSTANT	INTEGER	wdPaneFootnoteContinuationNotice		= 9
CONSTANT	INTEGER	wdPaneFootnoteContinuationSeparator	= 10
CONSTANT	INTEGER	wdPaneFootnoteSeparator					= 11
CONSTANT	INTEGER	wdPaneEndnoteContinuationNotice		= 12
CONSTANT	INTEGER	wdPaneEndnoteContinuationSeparator	= 13
CONSTANT	INTEGER	wdPaneEndnoteSeparator					= 14
CONSTANT	INTEGER	wdPaneComments								= 15
CONSTANT	INTEGER	wdPaneCurrentPageHeader					= 16
CONSTANT	INTEGER	wdCurrentPageFooter						= 17

// Document Save Options
CONSTANT	INTEGER	wdDoNotSaveChanges			= 0
CONSTANT	INTEGER	wdSaveChanges					= -1
CONSTANT	INTEGER	wdPromptToSaveChanges		= -2

// Document Routing Options
CONSTANT	INTEGER	wdWordDocument					= 0
CONSTANT	INTEGER	wdOriginalDocumentFormat	= 1
CONSTANT	INTEGER	wdPromptUser					= 2

// WdPrintOutRange Constants
CONSTANT INTEGER	wdPrintAllDocument = 0

// WdPrintOutItem Constants
CONSTANT INTEGER	WdPrintDocumentContent = 0

// WdPrintOutPages Constants
CONSTANT INTEGER	WdPrintAllPages = 0

// Object Instance Variables ************************************************************
// constants
CONSTANT	INTEGER	c_SaveDoc = 1
CONSTANT	INTEGER	c_PromptSaveDoc = 2

CONSTANT	STRING	c_SurveyType = 'S'
CONSTANT	STRING	c_LetterType = 'L'
CONSTANT	STRING	c_SourceConsumer = 'C'
CONSTANT	STRING	c_SourceEmployer = 'E'
CONSTANT	STRING	c_SourceProvider = 'P'
CONSTANT	STRING	c_SourceOther = 'O'

// variables
BOOLEAN		i_bDisplayWindow
BOOLEAN		i_bDocModified = false
BOOLEAN		i_bDocPrinted
BOOLEAN		i_bDocSent
BOOLEAN		i_bAllowSave
BOOLEAN		i_bSavePrompt

BLOB			i_blbDocImage

U_CORRESPONDENCE_MGR	i_uDocMgr

STRING	is_write_file_name

//oleobject ole_worddoc
end variables

forward prototypes
public function integer fw_opendoc (s_doc_info a_sdocinfo)
public subroutine fw_printdoc (integer a_ncopycount)
public subroutine fw_savedoc (integer a_csavestyle)
public subroutine of_load_word ()
public subroutine of_page_setup ()
public subroutine of_word_ocx ()
public function integer of_write_file ()
public function integer of_load_rte ()
public subroutine of_save_ocx ()
public subroutine of_load_ocx ()
public function integer of_insert_picture ()
end prototypes

public function integer fw_opendoc (s_doc_info a_sdocinfo);/*****************************************************************************************
   Function:   fw_OpenDoc
   Purpose:    Open a correspondence document in the OLE control
   Parameters: S_DOC_INFO	a_sDocInfo - The information about the current correspondence item
   Returns:    INTEGER	 0 - success
								-1 - failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/15/02 M. Caruso    Created.
	02/04/02 M. Caruso    Set window title.
	02/06/02 M. Caruso    Hide the Save toolbar button.
	04/02/02 M. Caruso    Add functionality to make document Read-Only.
*****************************************************************************************/

LONG			l_nComBarCount, l_nIndex, l_nComBtnCount, l_nStdIndex, l_nDrwIndex, l_nRow
DATETIME		l_dtSent
INTEGER		l_nCountFound, li_return
STRING		l_cLetterName, l_cLetterID, ls_document_type
DATAWINDOWCHILD	l_dwcField

// Display the hourglass cursor to indicate loading
SetPointer (Hourglass!)
//ole_worddoc.Hide()
//ole_worddoc = CREATE oleobject
// store the new document image into the OLE control
//ole_worddoc.ObjectData = a_sDocInfo.a_blbDocImage
i_blbDocImage = a_sDocInfo.a_blbDocImage
// finish prepping the Word interface
//ole_worddoc.Activate (InPlace!)
//
//// set the view to show the full page width
//IF ole_worddoc.Object.ActiveWindow.View.SplitSpecial = wdPaneNone THEN
//	ole_worddoc.Object.ActiveWindow.ActivePane.View.TYPE = wdPrintView
//ELSE
//	ole_worddoc.Object.ActiveWindow.View.TYPE = wdPrintView
//END IF
//ole_worddoc.Object.ActiveWindow.ActivePane.View.Zoom.PageFit = wdPageFitBestFit
//
//// make certain that bookmark markers do not show
//ole_worddoc.Object.ActiveWindow.View.ShowBookmarks = FALSE
//
//// find the drawing and standard toolbar indices
//l_nComBarCount = ole_worddoc.Object.CommandBars.Count
//FOR l_nIndex = 1 TO l_nComBarCount
//	
//	CHOOSE CASE ole_worddoc.Object.Commandbars[l_nIndex].Name
//		CASE "Standard"
//			l_nStdIndex = l_nIndex
//			
//		CASE "Drawing"
//			l_nDrwIndex = l_nIndex
//			
//	END CHOOSE
//	
//	// if both toolbars are found, exit the loop
//	IF l_nStdIndex > 0 AND l_nDrwIndex > 0 THEN EXIT
//	
//NEXT
//
//// hide the drawing toolbar if it is open
//ole_worddoc.Object.CommandBars[l_nDrwIndex].Visible = FALSE
//
//// hide the Print toolbar button
//l_nCountFound = 0
//l_nComBtnCount = ole_worddoc.Object.CommandBars[l_nStdIndex].Controls.Count
//FOR l_nIndex = 1 TO l_nComBtnCount
//	
//	// hide the buttons and exit the loop when both are found
//	CHOOSE CASE ole_worddoc.Object.CommandBars[l_nStdIndex].Controls[l_nIndex].Caption
//		CASE "&Print", "&Save"
//			ole_worddoc.Object.CommandBars[l_nStdIndex].Controls[l_nIndex].Visible = FALSE
//			l_nCountFound++
//			IF l_nCountFound = 2 THEN EXIT
//		
//	END CHOOSE
//	
//NEXT
//
//// return to top of document
//ole_worddoc.Object.Application.selection.HomeKey (wdStory, wdMove)

// set doc status to not modified
i_bDocModified = FALSE
IF LEFT(i_uDocMgr.i_sCurrentDocInfo.a_cDocID, 9) = "History: " THEN
	i_bAllowSave = FALSE
ELSE
	ls_document_type = i_uDocMgr.i_dsDocumentInfo.GetItemString (1, 'corspnd_type')
	i_bAllowSave = IsNull (i_uDocMgr.i_sCurrentDocInfo.a_dtSent) AND ls_document_type = 'L'
END IF
					
		
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite	Added 10.8.2004	Check the allow sent correspondence flag to be edited flag. If it has been set, then
//										    allow the user to edit/save the sent correspondence.
//-----------------------------------------------------------------------------------------------------------------------------------
long	ll_numwindows

ll_numwindows = FWCA.MGR.i_numwindows

If lower(i_uDocMgr.i_sCurrentDocInfo.a_allow_edit_sent) = 'y' AND ls_document_type = 'L' THEN
	//OpenwithParm(w_edit_sent_crrspndnce, i_uDocMgr.i_sCurrentDocInfo.a_cdocid)
	FWCA.MGR.fu_OpenWindow(w_edit_sent_crrspndnce, i_uDocMgr.i_sCurrentDocInfo.a_cdocid)
	FWCA.MGR.i_numwindows = 2
	If Message.DoubleParm = 1 Then
		i_bAllowSave = TRUE
	Else
		i_bAllowSave = FALSE
	End If
End If
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite	End Added 10.8.2004
//-----------------------------------------------------------------------------------------------------------------------------------



// determine if saving should be enabled
IF i_uDocMgr.i_bCaseLocked THEN
	m_editing.m_file.m_save.Enabled = FALSE
	m_editing.m_file.m_print.Enabled = FALSE
ELSE
	// disable the save menu item
	If	IsValid(m_editing) Then
		IF i_bAllowSave THEN
			m_editing.m_file.m_save.Enabled = TRUE
		ELSE
			m_editing.m_file.m_save.Enabled = FALSE
		END IF
	m_editing.m_file.m_print.Enabled = TRUE
	End If
END IF

// set the window title
Title = "'" + i_uDocMgr.i_sCurrentDocInfo.a_cDocName + "' for case #" + i_uDocMgr.i_sCurrentDocInfo.a_cCaseNumber
IF NOT i_bAllowSave OR i_uDocMgr.i_bCaseLocked THEN
	Title = Title + ' [Read Only]'
END IF

li_return = THIS.of_write_file()
// OCX Playtime
//THIS.of_word_ocx()
//i_wDocWindow.ole_worddoc.ObjectData = i_sCurrentDocInfo.a_blbDocImage
//li_return = ole_worddoc.Activate (InPlace!)
//li_return = ole_worddoc.clear()
//li_return = ole_worddoc.Hide()

RETURN 0
end function

public subroutine fw_printdoc (integer a_ncopycount);/*****************************************************************************************
   Function:   fw_PrintDoc
   Purpose:    Process the printing of the current document
   Parameters: INTEGER	a_nCopyCount - the number of copies to print.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/15/02 M. Caruso    Created.
	04/23/02 M. Caruso    Added code to allow for printing multiple copies of a document if
								 not printing in batch mode.
	05/17/02 M. Caruso    Added a_nCopyCount and only prompt when a_nCopyCount = -1.
	05/20/02 M. Caruso    Corrected setting of the number of copies to print.
	05/23/02 M. Caruso    Corrected batch processing of documents to print then mark as
								 printed and sent.
*****************************************************************************************/

INTEGER	l_nChoice, l_nAction, l_nNumCopies, li_rv, li_count
DATETIME	l_dtTimestamp, l_dtSent
OLEOBJECT	l_olePrintDlg
STRING ls_result, ls_hide_sent_correspondence

rte_1.SaveDocument( is_write_file_name, FileTypeDoc!)

of_load_word()

// print the document, waiting for the job to finish
IF i_uDocMgr.i_bBatchMode THEN
	// if in batch mode, only print one copy of the document
	rte_1.Print(1, "", false, false)
//	ole_wordocx.Object.PrintOut(FALSE)
//??	ole_worddoc.Object.PrintOut (FALSE)
	l_nAction = 1
ELSE
	// otherwise, prompt the user for print critiera
	IF a_nCopyCount = 0 THEN
		FWCA.MGR.fu_OpenWindow (w_correspondenceprintdialog)
		l_nAction = INTEGER (PCCA.Parm[1])
		IF l_nAction = -1 THEN l_nNumCopies = INTEGER (PCCA.Parm[2])
	ELSE
		l_nAction = -1
		l_nNumCopies = a_nCopyCount
	END IF
	
END IF

CHOOSE CASE l_nAction
	CASE -1		// the user pressed OK
		rte_1.Print(l_nNumCopies, "", false, false)

//		FOR li_count = 1 to l_nNumCopies
//			ole_wordocx.Object.PrintOut(FALSE)
//		NEXT
//		ole_worddoc.Object.PrintOut (FALSE, FALSE, wdPrintAllDocument, "", "", "", &
//											wdPrintDocumentContent, l_nNumCopies, "", wdPrintAllPages, &
//											FALSE, TRUE, "", FALSE, 0, 0, 0, 0)
//		
		i_bDocPrinted = TRUE
		
		// prompt to send if not already sent
		IF IsNull (i_uDocMgr.i_sCurrentDocInfo.a_dtSent) THEN
			
			IF i_uDocMgr.i_bBatchMode THEN
				i_bDocSent = TRUE
			ELSE
				
				IF LEFT(i_uDocMgr.i_sCurrentDocInfo.a_cDocID, 9) = "History: " THEN
					i_bDocSent = FALSE
				ELSE
					//------------------------------------------------------------------------------------------------
					// Added RAP 3.25.2009 - Geisinger doesn't want to ever set correspondence as sent
					//------------------------------------------------------------------------------------------------
					  SELECT cusfocus.system_options.option_value  
						 INTO :ls_hide_sent_correspondence
						 FROM cusfocus.system_options  
						WHERE cusfocus.system_options.option_name = 'hide sent correspondence'   ;
					
					IF IsNull(ls_hide_sent_correspondence) THEN
						ls_hide_sent_correspondence = 'N'
					END IF
					IF ls_hide_sent_correspondence = 'Y' THEN
						i_bDocSent = FALSE
					ELSE
						l_nChoice = MessageBox (gs_appname, 'Are you going to send this copy of the correspondence?', Question!, YesNo!)
						IF l_nChoice = 1 THEN
							i_bDocSent = TRUE
						ELSE
							i_bDocSent = FALSE
						END IF
					END IF
				END IF
				
			END IF
			
		END IF
		
	CASE 0
		i_bDocPrinted = FALSE
		i_bDocSent = FALSE
	
	CASE 1
		// batch printed documents get printed and sent automatically.
		i_bDocPrinted = TRUE
		i_bDocSent = TRUE
	
END CHOOSE
//ole_worddoc.ActiveDocument.close

end subroutine

public subroutine fw_savedoc (integer a_csavestyle);/*****************************************************************************************
   Function:   fw_SaveDoc
   Purpose:    Save the current document to the database.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/24/02 M. Caruso    Created.
*****************************************************************************************/
BOOLEAN lb_return
INTEGER li_return

li_return = rte_1.SaveDocument( is_write_file_name, FileTypeDoc!)

of_load_word()

CHOOSE CASE a_cSaveStyle
	CASE c_SaveDoc
		i_bSaveprompt = FALSE
		
	CASE c_PromptSaveDoc
		i_bSaveprompt = TRUE
		
END CHOOSE

i_uDocMgr.uf_SaveCorrespondence (i_bSavePrompt)

i_bSaveprompt = FALSE




end subroutine

public subroutine of_load_word ();LONG ll_filenum, ll_loop, ll_index, ll_rv
Double l_dblFileSize
Blob l_blFilePart, l_blFile
String ls_message

//Get file datetime and size info
l_dblFileSize = FileLength( is_write_file_name )
		
			
//Open the file for Read
ll_FileNum = FileOpen( is_write_file_name, StreamMode!, Read!, Shared! )
	
IF ll_FileNum > 0 THEN				
	IF l_dblFileSize <= 32765 THEN
		ll_Loop = 1
	ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
		ll_Loop = ( l_dblFileSize / 32765 )
	ELSE
		ll_Loop = Ceiling( l_dblFileSize / 32765 )
	END IF
	
	FOR ll_Index = 1 TO ll_Loop
		ll_RV = FileRead( ll_FileNum, l_blFilePart )
		
		IF ll_RV = -1 THEN
			ls_Message = "Error while reading file"
			RETURN
		ELSE
			l_blFile = ( l_blFile+l_blFilePart )
		END IF							
	NEXT
	
	FileClose( ll_FileNum )
END IF

// Get the length of the file to see if changes have occurred
i_uDocMgr.i_sCurrentDocInfo.a_lCharacter_count = l_dblFileSize

i_blbDocImage = l_blFile

//ole_worddoc.DisConnectObject()
//ll_rv = ole_worddoc.ConnectToNewObject("word.application")
//ole_worddoc.Documents.open(is_write_file_name)
//ole_worddoc.object.Open( is_write_file_name )
//IF IsValid(ole_worddoc) THEN
//		ole_worddoc.ObjectData = l_blFile
//END IF
//
end subroutine

public subroutine of_page_setup ();// To see all of the enumeration values, see:
//
// 		http://www.officeocx.com/Dialog-Type.htm
//
// Written 01/05/2009 - RAP

ole_wordocx.Object.ShowWordStandardDialog(178)

end subroutine

public subroutine of_word_ocx ();/*****************************************************************************************
   Event:      ue_OpenAttachment
   Purpose:    To open a case attachment.
	
	Parameters: a_nRow - Integer - The row in the datawindow that was selected or
											 double-clicked.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Created
*****************************************************************************************/
Long l_nFileNum, l_nAttachmentKey, l_nAttachFileNum, ll_blob_id
Integer l_nIndex, l_nLoop, l_nWriteRV, l_nRV
Blob l_blFile, l_blFilePart
Double l_dblFileSize
ContextKeyword l_ckTemp
String l_cTemp[ ], l_cFileName, l_cAttachFileLog
n_cst_kernel32 l_uoKernelFuncs
Boolean lb_return

SetPointer( HourGlass! )


//Get the file name
IF LEFT(i_uDocMgr.i_sCurrentDocInfo.a_cDocID, 9) = "History: " THEN
	l_cFileName = i_uDocMgr.i_sCurrentDocInfo.a_cCaseNumber + '_' + MID(i_uDocMgr.i_sCurrentDocInfo.a_cDocID, 10) + '.doc'
ELSE
	l_cFileName = i_uDocMgr.i_sCurrentDocInfo.a_cCaseNumber + '_' + i_uDocMgr.i_sCurrentDocInfo.a_cDocID + '.doc'
END IF
//l_cFileName = THIS.Title
l_blFile = i_blbDocImage

IF Trim( l_cFileName ) <> "" THEN
	//Prepare to open the document.
	// Get the Temp Path from Environment Variables to write the file
	// out before attempt to open.
	#IF defined PBDOTNET THEN
		l_cTemp[1] = System.IO.Path.GetTempPath()
	#ELSE
		l_ckTemp = CREATE ContextKeyword
		l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 
		//Have the needed info.  Destroy the object.
		DESTROY l_ckTemp
	#END IF
	
	//If temp Path is not available, use Root drive.
	IF NOT l_uoKernelFuncs.of_DirectoryExists( l_cTemp[ 1 ] ) THEN 
		l_cTemp[ 1 ] = 'C:\'
	END IF
	
	//Get rid of any potential white space.
	l_cTemp[ 1 ] = Trim( l_cTemp[ 1 ] )
	
	//Add the directory to the file name.
	IF Mid( l_cTemp[ 1 ], Len( l_cTemp[ 1 ] ), 1 ) = "\" THEN
		is_write_file_name = ( l_cTemp[ 1 ]+l_cFileName )
	ELSE
		is_write_file_name = ( l_cTemp[ 1 ]+"\"+l_cFileName )
	END IF
	
	IF FileExists( is_write_file_name ) THEN
		lb_return = FileDelete ( is_write_file_name )
	END IF
	
	//Write the file out.
	l_nFileNum = FileOpen( is_write_file_name, StreamMode!, Write!, LockReadWrite!, Replace! )
		
	IF l_nFileNum > 0 THEN
		//Find out how many reads to make on the image
		l_dblFileSize = Len( l_blFile )
		
		IF l_dblFileSize <= 32765 THEN
			l_nLoop = 1
		ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
			l_nLoop = ( l_dblFileSize / 32765 )
		ELSE
			l_nLoop = Ceiling( l_dblFileSize / 32765 )
		END IF
		
		//Write the file.
		IF l_nLoop = 1 THEN
			l_nWriteRV = FileWrite( l_nFileNum, l_blFile )
		ELSE
			l_blFilePart = BlobMid( l_blFile, 1, 32765 )
			FOR l_nIndex = 1 TO l_nLoop				
				l_nWriteRV = FileWrite( l_nFileNum, l_blFilePart )
				
				IF l_nWriteRV = -1 THEN					
					EXIT
				ELSE
					l_blFilePart = BlobMid( l_blFile, ( ( 32765 * l_nIndex ) + 1 ), 32765 )
				END IF							
			NEXT
		END IF
		
		IF l_nWriteRV = -1 THEN
			FileClose( l_nFileNum )
			FileDelete( l_cFileName )
						
			MessageBox( gs_AppName, "Unable to write to file "+is_write_file_name+".", &
							StopSign!, OK! )									
		ELSE
			FileClose( l_nFileNum )
//			ole_worddoc.ConnectToNewObject("word.application")
//			ole_worddoc.Documents.open(is_write_file_name)
			l_nRV = rte_1.Insertdocument( is_write_file_name, true, FileTypeDoc!)
			string sFieldName, sData
			sFieldName = rte_1.InputFieldLocate( First!, "MemberDOB" )
			sData = rte_1.inputfieldcurrentname( )
			l_nRV = rte_1.Find("AppealDate", true, true, true, false )
			if l_nRV > 0 THEN
				rte_1.Replacetext( "My Inserted Text")
			END IF
			l_nRV = rte_1.Find("LOBLogo", true, true, true, false )
			if l_nRV > 0 THEN
				rte_1.Replacetext( "My Inserted Logo")
			END IF
			sData = rte_1.inputfieldcurrentname( )
			sFieldName = rte_1.InputFieldLocate( Prior! )
			sData = rte_1.inputfieldcurrentname( )
			sFieldName = rte_1.InputFieldLocate( Prior! )
			sData = rte_1.inputfieldcurrentname( )
			sFieldName = rte_1.InputFieldLocate( Prior! )
			sData = rte_1.inputfieldcurrentname( )

			ole_wordocx.Object.Open(is_write_file_name)
//			IF lb_return THEN
//				ole_wordocx.Object.ShowToolbars(TRUE)
				//The new version has a different call
//				ole_wordocx.Object.Toolbars = TRUE
//			ELSE
//				MessageBox( gs_AppName, "Could not open the correspondence for editing", StopSign!, OK! )
//			END IF
			// Get the length of the file to see if changes have occurred
			i_uDocMgr.i_sCurrentDocInfo.a_lCharacter_count = l_dblFileSize
		END IF
	ELSE
		MessageBox( gs_AppName, "Could not open the file for write", StopSign!, OK! )
	END IF						
ELSE
	MessageBox( gs_AppName, "File name not populated.  Could not open file", StopSign!, OK! )
END IF

SetPointer( Arrow! )


end subroutine

public function integer of_write_file ();Long l_nFileNum, l_nAttachmentKey, l_nAttachFileNum, ll_blob_id
Integer l_nIndex, l_nLoop, l_nWriteRV, l_nRV
Blob l_blFile, l_blFilePart
Double l_dblFileSize
ContextKeyword l_ckTemp
String l_cTemp[ ], l_cFileName, l_cAttachFileLog
n_cst_kernel32 l_uoKernelFuncs
Boolean lb_return

SetPointer( HourGlass! )


//Get the file name
IF LEFT(i_uDocMgr.i_sCurrentDocInfo.a_cDocID, 9) = "History: " THEN
	l_cFileName = i_uDocMgr.i_sCurrentDocInfo.a_cCaseNumber + '_' + MID(i_uDocMgr.i_sCurrentDocInfo.a_cDocID, 10) + '.doc'
ELSE
	l_cFileName = i_uDocMgr.i_sCurrentDocInfo.a_cCaseNumber + '_' + i_uDocMgr.i_sCurrentDocInfo.a_cDocID + '.doc'
END IF
//l_cFileName = THIS.Title
l_blFile = i_blbDocImage

IF Trim( l_cFileName ) <> "" THEN
	//Prepare to open the document.
	// Get the Temp Path from Environment Variables to write the file
	// out before attempt to open.
	#IF defined PBDOTNET THEN
		l_cTemp[1] = System.IO.Path.GetTempPath()
	#ELSE
		l_ckTemp = CREATE ContextKeyword
		l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 
		//Have the needed info.  Destroy the object.
		DESTROY l_ckTemp
	#END IF
	
	//If temp Path is not available, use Root drive.
	IF NOT l_uoKernelFuncs.of_DirectoryExists( l_cTemp[ 1 ] ) THEN 
		l_cTemp[ 1 ] = 'C:\'
	END IF
	
	//Get rid of any potential white space.
	l_cTemp[ 1 ] = Trim( l_cTemp[ 1 ] )
	
	//Add the directory to the file name.
	IF Mid( l_cTemp[ 1 ], Len( l_cTemp[ 1 ] ), 1 ) = "\" THEN
		is_write_file_name = ( l_cTemp[ 1 ]+l_cFileName )
	ELSE
		is_write_file_name = ( l_cTemp[ 1 ]+"\"+l_cFileName )
	END IF
	
	IF FileExists( is_write_file_name ) THEN
		lb_return = FileDelete ( is_write_file_name )
	END IF
	
	//Write the file out.
	l_nFileNum = FileOpen( is_write_file_name, StreamMode!, Write!, LockReadWrite!, Replace! )
		
	IF l_nFileNum > 0 THEN
		//Find out how many reads to make on the image
		l_dblFileSize = Len( l_blFile )
		
		IF l_dblFileSize <= 32765 THEN
			l_nLoop = 1
		ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
			l_nLoop = ( l_dblFileSize / 32765 )
		ELSE
			l_nLoop = Ceiling( l_dblFileSize / 32765 )
		END IF
		
		//Write the file.
		IF l_nLoop = 1 THEN
			l_nWriteRV = FileWrite( l_nFileNum, l_blFile )
		ELSE
			l_blFilePart = BlobMid( l_blFile, 1, 32765 )
			FOR l_nIndex = 1 TO l_nLoop				
				l_nWriteRV = FileWrite( l_nFileNum, l_blFilePart )
				
				IF l_nWriteRV = -1 THEN					
					EXIT
				ELSE
					l_blFilePart = BlobMid( l_blFile, ( ( 32765 * l_nIndex ) + 1 ), 32765 )
				END IF							
			NEXT
		END IF
		
		IF l_nWriteRV = -1 THEN
			FileClose( l_nFileNum )
			FileDelete( l_cFileName )
						
			MessageBox( gs_AppName, "Unable to write to file "+is_write_file_name+".", &
							StopSign!, OK! )									
			RETURN -1				
		ELSE
			FileClose( l_nFileNum )
			i_uDocMgr.i_sCurrentDocInfo.a_lCharacter_count = l_dblFileSize
		END IF
	ELSE
		MessageBox( gs_AppName, "Could not open the file for write", StopSign!, OK! )
		RETURN -2
	END IF						
ELSE
	MessageBox( gs_AppName, "File name not populated.  Could not open file", StopSign!, OK! )
	RETURN -3
END IF

SetPointer( Arrow! )
RETURN 0

end function

public function integer of_load_rte ();integer li_return
boolean lb_modified

lb_modified = i_bDocModified

li_return = rte_1.Insertdocument( is_write_file_name, true, FileTypeDoc!)

i_bDocModified = lb_modified
IF i_bDocModified = false THEN
	rte_1.Modified = false
END IF

RETURN li_return

end function

public subroutine of_save_ocx ();i_bDocModified = true
	
ole_wordocx.object.Save( )
ole_wordocx.object.Close( )

end subroutine

public subroutine of_load_ocx ();ole_wordocx.Object.Open(is_write_file_name)

end subroutine

public function integer of_insert_picture ();STRING sFileName, sFilePath
INTEGER li_return

li_return = GetFileOpenName("Select File", sFilePath, sFileName)
IF li_return = 1 THEN
	li_return = rte_1.InsertPicture(sFilePath)
END IF

RETURN li_return
end function

event pc_close;call super::pc_close;BOOLEAN lb_return
Integer li_return

SetNull (i_uDocMgr.i_wDocWindow)
//lb_return = ole_wordocx.object.close()
If FileExists( is_write_file_name ) THEN
	FileDelete( is_write_file_name )
END IF

//ole_wordocx.object.ActivationPolicy = 2
//ole_wordocx.object.FrameHookPolicy = 2
//destroy ole_wordocx

CLOSE(THIS)
end event

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_SetOptions
   Purpose:    Initialize the specified document for editing.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/19/01 M. Caruso    Created.
*****************************************************************************************/

INTEGER		l_nWidth, l_nHeight, l_nWinWidth, l_nWinHeight
STRING		l_cLetterName
ENVIRONMENT	l_eSystem

// Indicate processing
SetPointer (HourGlass!)

// Get screen resolution and center window on the screen
GetEnvironment (l_eSystem)
l_nWidth = l_eSystem.ScreenWidth
l_nHeight = l_eSystem.ScreenHeight

l_nWinWidth = Round (THIS.Width/4.3, 0)
l_nWinHeight = Round (THIS.Height/4.3, 0)

THIS.X = Round (l_nWidth - l_nWinWidth / 2, 0)
THIS.Y = Round (l_nHeight - l_nWinHeight / 2, 0)

// set the window visibility 
This.Visible = i_uDocMgr.i_bDisplayWindow

//ole_worddoc.visible = FALSE

of_SetResize (TRUE)
IF IsValid (inv_resize) THEN
	
	//Register this control with the resize service
	inv_resize.of_Register (rte_1, "ScaleToRight&Bottom")
END IF

//ole_wordocx.object.EnableFileCommand(0, false)
//ole_wordocx.object.EnableFileCommand(1, false)
//ole_wordocx.object.EnableFileCommand(2, false)
//ole_wordocx.object.EnableFileCommand(4, false)
//ole_wordocx.object.Menubar = false
//ole_wordocx.object.Titlebar = false
//
i_bSaveprompt = FALSE



end event

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_SetVariables
   Purpose:    Initialize the instance variables for this window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/09/02 M. Caruso    Created.
*****************************************************************************************/

i_uDocMgr = powerobject_parm
end event

on w_word_window_dsoframer_4_20_09.create
int iCurrent
call super::create
if this.MenuName = "m_editing" then this.MenuID = create m_editing
this.ole_wordocx=create ole_wordocx
this.rte_1=create rte_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_wordocx
this.Control[iCurrent+2]=this.rte_1
end on

on w_word_window_dsoframer_4_20_09.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ole_wordocx)
destroy(this.rte_1)
end on

event closequery;//i_uDocMgr.uf_closedocwindow()
	IF NOT i_uDocMgr.i_bCaseLocked THEN
		IF i_bAllowSave THEN
			// if the document has been modified, begin the save process
			IF i_uDocMgr.of_modified() THEN
				i_bDocModified = TRUE
				fw_SaveDoc (c_promptsavedoc)
			ELSEIF i_bDocModified THEN
				fw_SaveDoc (c_savedoc)
			END IF
		END IF
	END IF
//
end event

event pc_closequery;string ls_something

ls_something = "Nothing"

end event

type ole_wordocx from olecustomcontrol within w_word_window_dsoframer_4_20_09
event onfilecommand ( integer item,  ref boolean cancel )
event ondocumentopened ( string file,  oleobject document )
event ondocumentclosed ( )
event onactivationchange ( boolean fgoingactive )
event beforedocumentclosed ( oleobject document,  ref boolean cancel )
event beforedocumentsaved ( oleobject document,  string location,  ref boolean cancel )
event onprintpreviewexit ( )
event onsavecompleted ( oleobject document,  string docname,  string fullfilelocation )
integer x = 18
integer y = 928
integer width = 1609
integer height = 848
integer taborder = 30
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_word_window_dsoframer_4_20_09.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

event constructor;THIS.object.ActivationPolicy = 1

// zero, it will resize, but it won't work with Word open
// one will not resize, but it will work with word open, but it stays open after the app closes
THIS.object.FrameHookPolicy = 0

THIS.object.Menubar = true
THIS.object.Titlebar = false

THIS.object.EnableFileCommand(0, false)
THIS.object.EnableFileCommand(1, false)
THIS.object.EnableFileCommand(2, true)
THIS.object.EnableFileCommand(3, true)
THIS.object.EnableFileCommand(4, false)
THIS.object.EnableFileCommand(5, true)
THIS.object.EnableFileCommand(6, true)
THIS.object.EnableFileCommand(7, false)
THIS.object.EnableFileCommand(8, false)

end event

type rte_1 from richtextedit within w_word_window_dsoframer_4_20_09
integer width = 3611
integer height = 1796
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean init_hscrollbar = true
boolean init_vscrollbar = true
boolean init_inputfieldsvisible = true
boolean init_inputfieldnamesvisible = true
boolean init_rulerbar = true
boolean init_tabbar = true
boolean init_toolbar = true
borderstyle borderstyle = stylelowered!
boolean resizable = true
end type

event modified;i_bDocModified = true
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Ew_word_window_dsoframer_4_20_09.bin 
2C00000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff000000010000000000000000000000000000000000000000000000000000000027ef3c6001c9c1d300000003000000800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000030046018211d59e5e26b8c8b757dd41900000000027ef3c6001c9c1d327ef3c6001c9c1d3000000000000000000000000007300440046006f006100720065006d007400430043006c006e006f006500740074006e0000007300000000000000000000000000000000000000000000000001020028ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000003000000000fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Affffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd501d50100002461000015e98000001080000005800000088000000d8000000e01010101000000000000000000000000606121e840db0365d101eba30e48ac41d501d50100002461000015e98000001080000005800000088000000d8000000e010101010000000000000000000000005dc8fcd0cff27827e4becc75c30dd62455a9e851174eb50c8534bea039f9d1b13b037c43fe91049f1348774020acb789b4dbd4c578c389bf60ea9c4cafe381202df219395a66a98a77e65cbcc4e26b0ec55a52528c6aa278ec6a6b6228a488920b690a06ce570e2af3bb06c91cc4b3679791e69e4c35ad6abf3b5d81187018d25150495230a015d6cda145bc81556abfac2a3034000000ffb3426cbe4155bd1424691bd6be67ef0da8041361b251769fc1af7d542cb927e33535f8c5f8ed5326f4f131793b49a900e538e054d9289d062f4230f01d0600c126ecd9da6c3c7e7b6f1ebb3b7ae491548711ce7fd9907eabfff164d1c00b20bf8ddffb9f734f2b557a2d89c13f9ae853a1d8ee2b0067e1a4d0af33e1a3051ffe66f321c5371b7c5caae8cd2b7a296461c2b284390af5b749eaf7a799ad0b1fbbfcee0bc73d2228b29e7fcd7e56da98a878cb7f65a91cbb5d05e848769efa48d901ceb6b1f9f953aa0c68ffac234ecbb949e704d461d8fbece50f5f220e10d6e2fb1f5516c1d1d6ca4a08644ec120449f22865c1ace32e5bd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Ew_word_window_dsoframer_4_20_09.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
