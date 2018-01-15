$PBExportHeader$w_word_window.srw
$PBExportComments$The window doesn't close correctly, it thinks it is still open
forward
global type w_word_window from w_main_std
end type
type ole_worddoc from olecontrol within w_word_window
end type
type ole_wordocx_v34 from olecustomcontrol within w_word_window
end type
type ole_wordocx from olecustomcontrol within w_word_window
end type
end forward

global type w_word_window from w_main_std
integer width = 4608
integer height = 2880
boolean maxbox = false
boolean resizable = false
ole_worddoc ole_worddoc
ole_wordocx_v34 ole_wordocx_v34
ole_wordocx ole_wordocx
end type
global w_word_window w_word_window

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
BOOLEAN		i_bDocModified
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
public subroutine of_word_ocx ()
public subroutine of_load_word ()
public subroutine of_page_setup ()
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
ole_worddoc.Hide()
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

// OCX Playtime
THIS.of_word_ocx()
//i_wDocWindow.ole_worddoc.ObjectData = i_sCurrentDocInfo.a_blbDocImage
//li_return = ole_worddoc.Activate (InPlace!)
li_return = ole_worddoc.clear()
li_return = ole_worddoc.Hide()

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

ole_wordocx.object.Save(  )
of_load_word()
//ole_worddoc.objectdata = i_blbDocImage

// print the document, waiting for the job to finish
IF i_uDocMgr.i_bBatchMode THEN
	// if in batch mode, only print one copy of the document
	ole_wordocx.Object.PrintOut(FALSE)
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
		FOR li_count = 1 to l_nNumCopies
			ole_wordocx.Object.PrintOut(FALSE)
		NEXT
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

IF 	 ole_wordocx.Object.IsDirty THEN
	i_bDocModified = true
END IF
	
ole_wordocx.object.Save( )
//ole_wordocx.object.Save( is_write_file_name )
of_load_word()
//ole_wordocx.Object.Open(is_write_file_name)
//lb_return = ole_wordocx.Object.Open(is_write_file_name)

CHOOSE CASE a_cSaveStyle
	CASE c_SaveDoc
		i_bSaveprompt = FALSE
		
	CASE c_PromptSaveDoc
		i_bSaveprompt = TRUE
		
END CHOOSE

i_uDocMgr.uf_SaveCorrespondence (i_bSavePrompt)

i_bSaveprompt = FALSE

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
			ole_wordocx.Object.Open(is_write_file_name)
//			IF lb_return THEN
//				ole_wordocx.Object.ShowToolbars(TRUE)
				//The new version has a different call
				ole_wordocx.Object.Toolbars = TRUE
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

event pc_close;call super::pc_close;BOOLEAN lb_return
Integer li_return

SetNull (i_uDocMgr.i_wDocWindow)
lb_return = ole_wordocx.object.close()
If FileExists( is_write_file_name ) THEN
	FileDelete( is_write_file_name )
END IF

//ole_wordocx.object.ActivationPolicy = 2
//ole_wordocx.object.FrameHookPolicy = 2
ole_wordocx.object.Close()
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
	inv_resize.of_Register (ole_wordocx, "ScaleToRight&Bottom")
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

on w_word_window.create
int iCurrent
call super::create
this.ole_worddoc=create ole_worddoc
this.ole_wordocx_v34=create ole_wordocx_v34
this.ole_wordocx=create ole_wordocx
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_worddoc
this.Control[iCurrent+2]=this.ole_wordocx_v34
this.Control[iCurrent+3]=this.ole_wordocx
end on

on w_word_window.destroy
call super::destroy
destroy(this.ole_worddoc)
destroy(this.ole_wordocx_v34)
destroy(this.ole_wordocx)
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

event resize;ole_wordocx.width = this.width - 20
ole_wordocx.height = this.height - 20
end event

type ole_worddoc from olecontrol within w_word_window
boolean visible = false
integer x = 41
integer y = 1108
integer width = 3191
integer height = 652
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
boolean border = false
long backcolor = 67108864
boolean focusrectangle = false
string binarykey = "w_word_window.win"
string displayname = "Correspondence Editor"
omdisplaytype displaytype = displayasactivexdocument!
omlinkupdateoptions linkupdateoptions = linkupdatemanual!
sizemode sizemode = clip!
end type

event saveobject;/*****************************************************************************************
   Event:      SaveObject
   Purpose:    Save the current document in the OLE control.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/21/01 M. Caruso    Created.
*****************************************************************************************/

//IF i_bDocModified AND NOT i_uDocMgr.i_bCaseLocked AND i_bAllowSave THEN
//	fw_SaveDoc (c_PromptSaveDoc)
//END IF
end event

type ole_wordocx_v34 from olecustomcontrol within w_word_window
string tag = "Word viewer"
boolean visible = false
integer x = 233
integer width = 3296
integer height = 1744
integer taborder = 20
boolean enabled = false
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_word_window.win"
integer binaryindex = 1
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

type ole_wordocx from olecustomcontrol within w_word_window
event onfilecommand ( integer item,  ref boolean cancel )
event ondocumentopened ( string file,  oleobject document )
event ondocumentclosed ( )
event onactivationchange ( boolean fgoingactive )
event beforedocumentclosed ( oleobject document,  ref boolean cancel )
event beforedocumentsaved ( oleobject document,  string location,  ref boolean cancel )
event onprintpreviewexit ( )
event onsavecompleted ( oleobject document,  string docname,  string fullfilelocation )
integer width = 4576
integer height = 2784
integer taborder = 30
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_word_window.win"
integer binaryindex = 2
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

event onfilecommand(integer item, ref boolean cancel);IF item = 5 THEN // Print
		i_uDocMgr.uf_PrintDoc (0)
		cancel = true
		return
END IF
end event

event ondocumentclosed();
SetNull (i_uDocMgr.i_wDocWindow)
ole_wordocx.object.close()
If FileExists( is_write_file_name ) THEN
	FileDelete( is_write_file_name )
END IF

// How do we get this to stop running?
//THIS.object.ActivationPolicy = 0
//THIS.object.FrameHookPolicy = 2

end event

event beforedocumentclosed(OleObject document, ref boolean cancel);
//i_uDocMgr.uf_closedocwindow()
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

end event

event beforedocumentsaved(oleobject document, string location, ref boolean cancel);//fw_savedoc(c_savedoc)

IF 	 ole_wordocx.Object.IsDirty THEN
	i_bDocModified = true
END IF
	

end event

event onsavecompleted(OleObject document, string docname, string fullfilelocation);of_load_word()
//ole_wordocx.Object.FileMenu_Open(is_write_file_name)
//lb_return = ole_wordocx.Object.Open(is_write_file_name)

i_uDocMgr.uf_SaveCorrespondence (i_bSavePrompt)

end event

event constructor;THIS.object.ActivationPolicy = 1

// zero, it will resize, but it won't work with Word open
// one will not resize, but it will work with word open, but it stays open after the app closes
THIS.object.FrameHookPolicy = 1

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

event getfocus;THIS.object.Menubar = true

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
00w_word_window.bin 
2800005200e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd0000000cfffffffe0000000d00000005000000060000000700000008000000090000000a0000000bfffffffe0000001ffffffffe0000000f00000010000000110000001200000013000000140000001500000016fffffffe00000018000000190000001a0000001b0000001c0000001d0000001efffffffefffffffe00000021000000220000002300000024000000250000002600000027fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff000000040002090600000000000000c0460000000000000000000000000000004b39133001c9c200000000030000030000000000004f00010065006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102000affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000140000000000540031006200610065006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000e0000000100000003ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000004000010000000000000430001006d006f004f0070006a006200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000007100000000fffffffe00000002fffffffe0000000400000005fffffffe0000000700000008000000090000000a0000000bfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff02000001000000000000000000000000000000000000000700000000000000010000000700000001ffffffff0000000bffffffff000000000000000d00000000fffe000100000a03ffffffff0002090600000000000000c0460000000000001f7263694d666f736f664f207465636966726f57206f442064656d75630a00746e4d000000726f5753636f446400001000726f57006f442e64656d7563382e746eb239f40000000071000000000000000000000000000000010000000100000005ffffffff000000030000000400000001ffffffff000000020000000000003b88000001e70000002c0009000100160300000000000000000500050000020b0000000000000000000501e7020c00033b880000000000000000000000000000000000000000414e00000001494effff00000003ffff0000000000040000ffff00000020ffff09ec000007c0000000060000000700000018000000000000000000010000000100000005000000010000000100000005000000010000000100000003ffffffff000000030000000400000004ffffffff0000000700000000000009ec000007c0000001420009000100a10300000100000000002a000400000103000000050008020b00000000000000000005004b020c00050060020900000000000000000005ffff0201000a00ff062600000009000f6e6f6349796c6e4f00050000000f028600010012000f009c000000040000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000400002fff1000c00400000000000000000004e00060072006f0061006d0000006c000000024a430018485f00184a610401486d0018487304094874040900000409000000000000000000000000000000000041004400a1fff2010c004400000000000000000044001600660065007500610074006c005000200072006100670061006100720068007000460020006e006f0000007400520000fff30069005200b30000010c00000000000c000000610054006c006200200065006f004e006d0072006c0061001c00000003f61706d63400030a0100d634006c0501000661000003000003f6000b000200280000fff4006b002800c1000001000000000000070000006f004e004c00200073006900000074000000020000000000000000000000011000000300000000ffffffff00000001000020040001ffff00997aa0000000000000000000000001000000000000000000000000000300000100000021c00000ac8d000000000002000300008979000000003000000000000001000000000000200000000000000006000180080100000005000006000000080100000006000006000000080100000007000000030000000400000008000000e50000000000000002000062be0000784c0018144c006e40ff00dd000180000000000000000000013e29480001000100000000000000000000000000000000000010020000000000000100000030000040001001ffff00070000006e0055006e006b0077006f00ff006e00080001ff0000000000000000ff000000000001ffff000000020000ff00ffff00ff000000020000ff00ffff000300000047000000000190160602020005040503870403020020007a0880000000000000ff00000000000001540000006d006900730065004e00200077006500520020006d006f006e00610035000000020190160105050006070102000705020000000000100000000000000000000000800000530000006d0079006f00620000006c0090263300020000010204060b02020202007a87040000002000000880000000000001ff0000000000720041006100690000006c00
250400220088083000d0f0001868000002000000019165800091658066000000660000010000000000000000000100000000000100030004000000011000000000000000000100010001000000000000000000000010f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0070800b400b4051281810000000034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000010f00000032008000000000000000000000000000000000000000000000000004800000000000058fff009000100000fe400003fff000004ff7fffffff7fffffff7fffffff7fffffff7fffffff7fffffbe7fffff00001862320000000000000000000000000000000000000012ffff000000000000000000000000000a0000006f004a006c0065005700200069006800650074004a000a0065006f0020006c006800570074006900000065000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f00020065006c0072005000730065003000300000003000000000000000000000000000000000000000000000000000000000000000000000000000000000010200180000000200000006ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009a00000000004f00020065006c007200500073006500300030000000310000000000000000000000000000000000000000000000000000000000000000000000000000000001020018ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000060000017c00000000006f005700640072006f0044007500630065006d0074006e000000000000000000000000000000000000000000000000000000000000000000000000000000000002001a0000000500000007ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000e0000102e0000000000530005006d00750061006d00790072006e0049006f0066006d007200740061006f00690000006e00000000000000000000000000000000000000000000000001020028ffffffff00000008ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000017000010000000000002090000000000000000000500010102001c000002fb00000000fff500000000000001900000010061540000616d6f680d420000f0284d0aa4b80013a4c177f3302077f30d2477f500044a66012d000000050000012e0000000000060000000f00240a320008003000000004006000006f44004b656d75630005746e012e0000000000010000002a000f06263a4300494e49575c53574f44736e495c6c6c61747b5c726531313039393034303030362d31312d30382d33442d4546433035313033383430394333386f775c7d63696472652e6e6f0000657800000006000f062600310002000000030000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00c1a5ec0409607f12f00000000000bf100000000000000000000600000008016a62000e87e66a62000087e600000000000000000000000000000000001604090000102e0000ed840000ed840000000100000000000000000000000000000000000000000000000000000000000fffff0000000000000000000fffff0000000000000000000fffff00000000000000000000000000000000000000a403a400000000000003a4000003a400000000000003a400000000000003a400000000000003a400000000000003a4000000140000000000000000000003de00000014000004160000000000000416000000000000041600000000000004160000000c000004220000000c000003f200000000000004df000000b60000043a000000000000043a000000000000043a0000
2C00000000043a000000000000043a000000000000043a000000000000043a000000000000043a000000000000045e000000020000046000000000000004600000000000000460000000000000046000000000000004600000000000000460000000240000059500000268000007fd00000052000004840000001500000000000000000000000000000000000003a4000000000000043a00000000000000000000000000000000000000000000043a000000000000043a000000000000043a000000000000043a0000000000000484000000000000000000000000000003a400000000000003a4000000000000043a0000000000000000000000000000043a0000000000000499000000160000043a000000000000043a000000000000043a000000000000043a00000000000003a4000000000000043a00000000000003a4000000000000043a000000000000045e0000000000000000000000000000043a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000043a000000000000045e0000000000000000000000000000043a0000000000000000000000000000043a00000000000003a400000000000003a40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000043a000000000000043a000000000000042e0000000c000051100000f92cd3c0000001c4000000000416000000000000043a000000000000043a0000000000000000000000000000045e00000000000004af00000030000004df000000000000043a000000000000084f000000000000043a000000000000084f000000000000043a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000084f000000000000000000000000000003a4000000000000043a000000240000043a000000000000043a000000000000043a000000000000043a000000000000043a0000000000000000000000000000000000000000000000000000000000000000000000000000043a000000000000043a000000000000043a000000000000048400000000000004840000000000000000000000000000000000000000000000000000000000000000000000000000043a0000000000000000000000000000000000000000000000000000000000000000000000000000043a000000000000043a000000000000043a00000000000004df000000000000043a000000000000043a000000000000043a000000000000043a000000000000000000000000000003f200000000000003f200000000000003f2000000240000041600000000000003f200000000000003f200000000000003f2000000000000041600000000000003b800000014000003cc0000000e000003da00000004000003a400000000000003a400000000000003a400000000000003a400000000000003a400000000000003a4000000000000ffff00000000ffff000200000000010c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
260000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000801000000fc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c68160601006e780000060000000801000000fd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000000060000000801000000fd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040000010101009031002cb01f0168b0202fd0b0213de0b022070890230708902405a0b02505a0b0170000b01802d0900c02d0000002d0000000000000000000000000000000000000000000000000006f00420064006c00490020006100740069006c00000063000000000000000000000000000000000000000000000000000000000000000000000000000000000079004300690072006c006c006300690000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2900000000080076640000000000000000201fff1e000000240000001d0000000700000004000000010000000f00000037000002bc000000000000006000000060fffc00200020001f270000ff000000cc0024002100000800000008f0000003d400000a87000000000000000000000000400001bfdff7000008006c6100000000000001e40000017000000004000000240000000f0000000000000000000002bca30000ff2201020300720041006100690000006c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000720041006100690020006c006f00420064006c00490020006100740069006c000000630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fffe000201050000000000000000000000000000000000000001f29f85e010684ff9000891abd9b3272b0000003000000174000000110000000100000090000000020000009800000003000000a400000004000000b000000005000000c400000006000000d000000007000000dc00000008000000f0000000090000010400000012000001100000000a000001300000000c0000013c0000000d000001480000000e000001540000000f0000015c0000001000000164000000130000016c00000002000004e40000001e00000004000000000000001e00000004000000000000001e0000000c6c656f4a69685720000065740000001e00000004000000000000001e00000004000000000000001e0000000c6d726f4e642e6c610000746f0000001e0000000c6c656f4a69685720000065740000001e00000004000000310000001e000000187263694d666f736f664f207465636966726f57200000006400000040000000000000000000000040bbed880001c4f92c00000040bbed880001c4f92c0000000300000001000000030000000000000003000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400050063006f006d0075006e006500530074006d00750061006d00790072006e0049006f0066006d007200740061006f00690000006e000000000000000000020038ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000002000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fffe000201050000000000000000000000000000000000000001d5cdd502101b2e9c00089793aef92c2b00000030000000f80000000c00000001000000680000000f00000070000000050000008c0000000600000094000000110000009c00000017000000a40000000b000000ac00000010000000b400000013000000bc00000016000000c40000000d000000cc0000000c000000d900000002000004e40000001e000000146c74754f542077616e686365676f6c6f0073656900000003000000010000000300000001000000030000000000000003000b18d80000000b000000000000000b000000000000000b000000000000000b000000000000101e000000010000000100100c000000020000001e0000000600746954000300656c0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
260000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
23ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000004b3da71001c9c20000000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000d400000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff0000000397af4a45448549beab91559ff22bf240000000004b3da71001c9c2004b3da71001c9c200000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000040000006800000000000000010000000200000003fffffffe00000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000fffe0002010597af4a45448549beab91559ff22bf24000000001fb8f0821101b01640008ed8413c72e2b00000030000000a4000000050000010000000030000001010000003800000102000000400000010300000048000000000000005000000003000100000000000300004a840000000300002d1000000003000000000000000500000000000000010001030000000c0074735f00706b636f73706f72000101000000090078655f00746e65740102007800090000655f00006e65747800007974090000015f00000073726576006e6f6900000005000000010000000100000005000000010000000000000004ffffffff0000000100000005000000010001000000004a8400002d1000000000ffff0001c0c000fffeff00c0005025ff0065006c00730061002000650061007700740069006600200072006f0074002000650068006400200063006f006d0075006e006500200074006f0074006f002000650070002e006e000000010000000100000005000000010000000100000003000000000000000100000005000000010000000000000003000000010000000100000005000000010000000000000005000000000000000000000009000000000000000100000005000000010000000100000005000000010000000100000005000000010000000000000003000000010000000100000001000000010000000100000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Dfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000004b3da71001c9c20000000003000000800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000030046018211d59e5e26b8c8b757dd4190000000004b3da71001c9c2004b3da71001c9c200000000000000000000000000007300440046006f006100720065006d007400430043006c006e006f006500740074006e0000007300000000000000000000000000000000000000000000000001020028ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000003000000000fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd501d50100006775000047ef8000001080000005800000088000000d8000000e01010101000000000000000000000000000000a4000000050000010000000030d501d50100006775000047ef8000001080000005800000088000000d8000000e010101010000000000000000000000000000000300002d1000000003000000000000000500000000000000010001030000000c0074735f00706b636f73706f72000101000000090078655f00746e65740102007800090000655f00006e65747800007974090000015f00000073726576006e6f6900000005000000010000000100000005000000010000000000000004ffffffff0000000100000005000000010001000000004a8400002d1000000000ffff0001c0c000fffeff00c0005025ff0065006c00730061002000650061007700740069006600200072006f0074002000650068006400200063006f006d0075
24006e006500200074006f0074006f002000650070002e006e00000001000000010000000500000001000000010000000300000000000000010000000500000001000000000000000300000001000000010000000500000001000000000000000500000000000000000000000900000000000000010000000500000001000000010000000500000001000000010000000500000001000000000000000300000001000000010000000100000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10w_word_window.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
