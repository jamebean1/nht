$PBExportHeader$w_word_window_old.srw
forward
global type w_word_window_old from w_main_std
end type
type ole_wordocx from olecustomcontrol within w_word_window_old
end type
type ole_worddoc_old from olecontrol within w_word_window_old
end type
end forward

global type w_word_window_old from w_main_std
integer width = 3387
integer height = 1984
string menuname = "m_editing"
ole_wordocx ole_wordocx
ole_worddoc_old ole_worddoc_old
end type
global w_word_window_old w_word_window_old

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

BLOB			i_blbDocImage

U_CORRESPONDENCE_MGR	i_uDocMgr

STRING	is_write_file_name

oleobject ole_worddoc
end variables

forward prototypes
public function integer fw_opendoc (s_doc_info a_sdocinfo)
public subroutine fw_printdoc (integer a_ncopycount)
public subroutine fw_savedoc (integer a_csavestyle)
public subroutine of_word_ocx ()
public subroutine of_load_word ()
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
INTEGER		l_nCountFound
STRING		l_cLetterName, l_cLetterID
DATAWINDOWCHILD	l_dwcField

// Display the hourglass cursor to indicate loading
SetPointer (Hourglass!)

ole_worddoc = CREATE oleobject

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
i_bAllowSave = IsNull (i_uDocMgr.i_sCurrentDocInfo.a_dtSent) AND &
					i_uDocMgr.i_dsDocumentInfo.GetItemString (1, 'corspnd_type') = 'L'
					
		
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite	Added 10.8.2004	Check the allow sent correspondence flag to be edited flag. If it has been set, then
//										    allow the user to edit/save the sent correspondence.
//-----------------------------------------------------------------------------------------------------------------------------------
long	ll_numwindows

ll_numwindows = FWCA.MGR.i_numwindows

If lower(i_uDocMgr.i_sCurrentDocInfo.a_allow_edit_sent) = 'y' Then
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

INTEGER	l_nChoice, l_nAction, l_nNumCopies
DATETIME	l_dtTimestamp, l_dtSent
OLEOBJECT	l_olePrintDlg

ole_wordocx.object.Save( is_write_file_name )
of_load_word()
ole_worddoc.objectdata = i_blbDocImage

// print the document, waiting for the job to finish
IF i_uDocMgr.i_bBatchMode THEN
	// if in batch mode, only print one copy of the document
	ole_worddoc.Object.PrintOut (FALSE)
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
		ole_worddoc.Object.PrintOut (FALSE, FALSE, wdPrintAllDocument, "", "", "", &
											wdPrintDocumentContent, l_nNumCopies, "", wdPrintAllPages, &
											FALSE, TRUE, "", FALSE, 0, 0, 0, 0)
		
		i_bDocPrinted = TRUE
		
		// prompt to send if not already sent
		IF IsNull (i_uDocMgr.i_sCurrentDocInfo.a_dtSent) THEN
			
			IF i_uDocMgr.i_bBatchMode THEN
				i_bDocSent = TRUE
			ELSE
				
				l_nChoice = MessageBox (gs_appname, 'Are you going to send this copy of the correspondence?', Question!, YesNo!)
				IF l_nChoice = 1 THEN
					i_bDocSent = TRUE
				ELSE
					i_bDocSent = FALSE
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
end subroutine

public subroutine fw_savedoc (integer a_csavestyle);/*****************************************************************************************
   Function:   fw_SaveDoc
   Purpose:    Save the current document to the database.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/24/02 M. Caruso    Created.
*****************************************************************************************/

ole_wordocx.object.Save( is_write_file_name )
of_load_word()

CHOOSE CASE a_cSaveStyle
	CASE c_SaveDoc
		i_uDocMgr.uf_SaveCorrespondence (FALSE)
		
	CASE c_PromptSaveDoc
		i_uDocMgr.uf_SaveCorrespondence (TRUE)
		
END CHOOSE
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
l_cFileName = THIS.Title
l_blFile = i_blbDocImage

IF Trim( l_cFileName ) <> "" THEN
	//Prepare to open the document.
	// Get the Temp Path from Environment Variables to write the file
	// out before attempt to open.
	l_ckTemp = CREATE ContextKeyword
	l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 
	
	//Have the needed info.  Destroy the object.
	DESTROY l_ckTemp
	
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

			lb_return = ole_wordocx.Object.Open(is_write_file_name)
//			ole_wordocx.Object.ShowToolbars(FALSE)
//			IF lb_return THEN
//				ole_worddoc.visible = FALSE
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

public subroutine of_load_word ();LONG ll_file_size, ll_filenum, ll_loop, ll_index, ll_rv
Double l_dblFileSize
Blob l_blFilePart, l_blFile
String ls_message

//Get file datetime and size info
ll_File_Size = FileLength( is_write_file_name )
		
			
//Open the file for Read
ll_FileNum = FileOpen( is_write_file_name, StreamMode!, Read!, LockReadWrite! )
	
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
i_uDocMgr.i_sCurrentDocInfo.a_lCharacter_count = ll_File_Size

i_blbDocImage = l_blFile

//ole_worddoc.object.Open( is_write_file_name )
//IF IsValid(ole_worddoc) THEN
//		ole_worddoc.ObjectData = l_blFile
//END IF
//
end subroutine

event pc_close;call super::pc_close;SetNull (i_uDocMgr.i_wDocWindow)

If FileExists( is_write_file_name ) THEN
	FileDelete( is_write_file_name )
END IF

destroy ole_worddoc
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

on w_word_window_old.create
int iCurrent
call super::create
if this.MenuName = "m_editing" then this.MenuID = create m_editing
this.ole_wordocx=create ole_wordocx
this.ole_worddoc_old=create ole_worddoc_old
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_wordocx
this.Control[iCurrent+2]=this.ole_worddoc_old
end on

on w_word_window_old.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ole_wordocx)
destroy(this.ole_worddoc_old)
end on

type ole_wordocx from olecustomcontrol within w_word_window_old
string tag = "Word viewer"
integer x = 32
integer y = 88
integer width = 3227
integer height = 972
integer taborder = 20
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_word_window_old.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

type ole_worddoc_old from olecontrol within w_word_window_old
boolean visible = false
integer x = 27
integer y = 1128
integer width = 3191
integer height = 652
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
boolean border = false
long backcolor = 67108864
boolean focusrectangle = false
string binarykey = "w_word_window_old.win"
integer binaryindex = 1
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

IF i_bDocModified AND NOT i_uDocMgr.i_bCaseLocked AND i_bAllowSave THEN
	fw_SaveDoc (c_PromptSaveDoc)
END IF
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Ew_word_window_old.bin 
2900000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000f85a5ec001c7600a00000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000d400000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff0000000397af4a45448549beab91559ff22bf24000000000f85a5ec001c7600af85a5ec001c7600a000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000040000006800000000000000010000000200000003fffffffe00000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000fffe0002010597af4a45448549beab91559ff22bf24000000001fb8f0821101b01640008ed8413c72e2b00000030000000a40000000500000100000000300000010100000038000001020000004000000103000000480000000000000050000000030001000000000003000048f8000000030000191d00000003000000000000000500000000000000010001030000000c0074735f00706b636f73706f72000101000000090078655f00746e65740102007800090000655f00006e65747800007974090000015f00000073726576006e6f69000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000048f80000191d00000000ffff0001c0c000fffeff00c0005725ff0069006100200074006f0066002000720070006f006e0065006e00690020006700680074002000650066006f0069006600650063006400200063006f006d0075006e00650021007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013f000300100106000000000000ffff00005200e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd0000000cfffffffe0000000d00000005000000060000000700000008000000090000000a0000000bfffffffe0000001ffffffffe0000000f00000010000000110000001200000013000000140000001500000016fffffffe00000018000000190000001a0000001b0000001c0000001d0000001efffffffefffffffe00000021000000220000002300000024000000250000002600000027fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff000000040002090600000000000000c046000000000000000000000000000000f85a5ec001c7600a000000030000030000000000004f00010065006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102000affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000140000000000540031006200610065006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000e0000000100000003ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000004000010000000000000430001006d006f004f0070006a0062
2F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000007100000000fffffffe00000002fffffffe0000000400000005fffffffe0000000700000008000000090000000a0000000bfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0200000100000000000000000000000000000000f22bf24000000001fb8f0821101b01640008ed8413c72e2b00000030000000a4000000050000010000000030fffe000100000a03ffffffff0002090600000000000000c0460000000000001f7263694d666f736f664f207465636966726f57206f442064656d75630a00746e4d000000726f5753636f446400001000726f57006f442e64656d7563382e746eb239f4000000007100000000000000000102000000090000655f00006e657478ffffffff000000030000000400000001ffffffff000000020000000000003b88000001e70000002c0009000100160300000000000000000500050000020b0000000000000000000501e7020c00033b880000000000000000000000000000000000000000414e00000001494effff00000003ffff0000000000040000ffff00000020ffff09ec000007c0000000060000000700000018000000630000006d0075006e006500210074000000000000000000000000000000000000000000000000ffffffff000000030000000400000004ffffffff0000000700000000000009ec000007c0000001420009000100a10300000100000000002a000400000103000000050008020b00000000000000000005004b020c00050060020900000000000000000005ffff0201000a00ff062600000009000f6e6f6349796c6e4f00050000000f028600010012000f009c000000040000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000400002fff1000c00400000000000000000004e00060072006f0061006d0000006c000000024a430018485f00184a610401486d0018487304094874040900000409000000000000000000000000000000000041004400a1fff2010c004400000000000000000044001600660065007500610074006c005000200072006100670061006100720068007000460020006e006f0000007400520000fff30069005200b30000010c00000000000c000000610054006c006200200065006f004e006d0072006c0061001c00000003f61706d63400
21030a0100d634006c0501000661000003000003f6000b000200280000fff4006b002800c1000001000000000000070000006f004e004c00200073006900000074000000020000000000000000000000011000000300000000ffffffff00000001000020040001ffff00997aa0000000000000000000000001000000000000000000000000000300000100000021c00000ac8d000000000002000300008979000000003000000000000001000000000000200000000000000006000180080100000005000006000000080100000006000006000000080100000007000000030000000400000008000000e50000000000000002000062be0000784c0018144c006e40ff00dd000180000000000000000000013e29480001000100000000000000000000000000000000000010020000000000000100000030000040001001ffff00070000006e0055006e006b0077006f00ff006e00080001ff0000000000000000ff000000000001ffff000000020000ff00ffff00ff000000020000ff00ffff000300000047000000000190160602020005040503870403020020007a0880000000000000ff00000000000001540000006d006900730065004e00200077006500520020006d006f006e00610035000000020190160105050006070102000705020000000000100000000000000000000000800000530000006d0079006f00620000006c0090263300020000010204060b02020202007a87040000002000000880000000000001ff0000000000720041006100690000006c000400220088083000d0f0001868000002000000019165800091658066000000660000010000000000000000000100000000000100030004000000011000000000000000000100010001000000000000000000000010f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0070800b400b4051281810000000034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000010f00000032008000000000000000000000000000000000000000000000000004800000000000058fff009000100000fe400003fff000004ff7fffffff7fffffff7fffffff7fffffff7fffffff7fffffbe7fffff00001862320000000000000000000000000000000000000012ffff000000000000000000000000000a0000006f004a006c0065005700200069006800650074004a000a0065006f0020006c0068005700740069000000650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f00020065006c0072005000730065003000300000003000000000000000000000000000000000000000000000000000000000000000000000000000000000010200180000000200000006ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009a00000000004f00020065006c007200500073006500300030000000310000000000000000000000000000000000000000000000000000000000000000000000000000000001020018ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000060000017c00000000006f005700640072006f0044007500630065006d0074006e000000000000000000000000000000000000000000000000000000000000000000000000000000000002001a0000000500000007ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000e0000102e0000000000530005006d00750061006d00790072006e0049006f0066006d007200740061006f00690000006e00000000000000000000000000000000000000000000000001020028ffffffff00000008ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000017000010000000000002090000000000000000000500010102001c000002fb00000000fff500000000000001900000010061540000616d6f680d420000f0284d0aa4b80013a4c177f3302077f30d2477f500044a66012d000000050000012e0000000000060000000f00240a320008003000000004006000006f44004b656d75630005746e012e0000000000010000002a000f06263a4300494e49575c53574f44736e495c6c6c61747b5c726531313039393034303030362d31312d30382d33442d4546433035313033383430394333386f775c7d63696472652e6e6f0000657800000006000f06260031000200000003000000000000000000000000
290000000000000000000000001131b4a011315000000000001131b50011315030000000001131b470113150a000000000113150701131511000000000113150e0113151800000000011315150001c442000000000001c43f0001c448800000000001c4458001c44f000000000001c44c0001bb05800000000001c4558001bb08800000000001c4528001bb0f800000000001bb0c8001bb16000000000001bb130001bb1c800000000001bb198001a20c800000000001f6fb0001f701000000000001f6fe0001f707800000000001f7048001f70e800000000001f70b8001eb77000000000001f7120002144b000000000001f71500021455800000000002145280021458800000000002144f800c1a5ec0409607f12f00000000000bf100000000000000000000600000008016a62000e87e66a62000087e600000000000000000000000000000000001604090000102e0000ed840000ed840000000100000000000000000000000000000000000000000000000000000000000fffff0000000000000000000fffff0000000000000000000fffff00000000000000000000000000000000000000a403a400000000000003a4000003a400000000000003a400000000000003a400000000000003a400000000000003a4000000140000000000000000000003de00000014000004160000000000000416000000000000041600000000000004160000000c000004220000000c000003f200000000000004df000000b60000043a000000000000043a000000000000043a000000000000043a000000000000043a000000000000043a000000000000043a000000000000043a000000000000045e000000020000046000000000000004600000000000000460000000000000046000000000000004600000000000000460000000240000059500000268000007fd00000052000004840000001500000000000000000000000000000000000003a4000000000000043a00000000000000000000000000000000000000000000043a000000000000043a000000000000043a000000000000043a0000000000000484000000000000000000000000000003a400000000000003a4000000000000043a0000000000000000000000000000043a0000000000000499000000160000043a000000000000043a000000000000043a000000000000043a00000000000003a4000000000000043a00000000000003a4000000000000043a000000000000045e0000000000000000000000000000043a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000043a000000000000045e0000000000000000000000000000043a0000000000000000000000000000043a00000000000003a400000000000003a40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000043a000000000000043a000000000000042e0000000c000051100000f92cd3c0000001c4000000000416000000000000043a000000000000043a0000000000000000000000000000045e00000000000004af00000030000004df000000000000043a000000000000084f000000000000043a000000000000084f000000000000043a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000084f000000000000000000000000000003a4000000000000043a000000240000043a000000000000043a000000000000043a000000000000043a000000000000043a0000000000000000000000000000000000000000000000000000000000000000000000000000043a000000000000043a000000000000043a000000000000048400000000000004840000000000000000000000000000000000000000000000000000000000000000000000000000043a0000000000000000000000000000000000000000000000000000000000000000000000000000043a000000000000043a000000000000043a00000000000004df000000000000043a000000000000043a000000000000043a000000000000043a000000000000000000000000000003f200000000000003f200000000000003f2000000240000041600000000000003f200000000000003f200000000000003f2000000000000041600000000000003b800000014000003cc0000000e000003da00000004000003a400000000000003a400000000000003a400000000000003a400000000000003a400000000000003a4000000000000ffff00000000ffff000200000000010c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000801000000fc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c68160601006e780000060000000801000000fd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000000000060000000801000000fd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
280000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040000010101009031002cb01f0168b0202fd0b0213de0b022070890230708902405a0b02505a0b0170000b01802d0900c02d0002402d00000000000248160002481f000000000002481c000248220000000000024813000204db8000000000024825800204e8000000000002482880021ec9000000000002482b80024831800000000002482e800232a18000000000022ecd8001c43b8000000000022ed080022ed68000000000022ed380022ee10000000000022ede00022ee40000000000022edb00022eeb8000000000022ee880022ef30000000000022ef000022efb0000000000022ef8000231f98000000000022eff0002320100000000000231fe0001f3ce80000000000232058002044980000000000232088001e466800000000002320b80024a1e000000000002320e8001e3a780000000000232118002321780000000000232148002321f000000000002321c000232268000000000023223800227ed800000000002322b0001e404800000000002322e00023818000000000001c84b00017d68800000000001c84e0001eacb000000000001c8510001e146000000000001c8540001c85a000000000001c8570001c861000000000001c85e0001cb35800000000001c8658001c86b800000000001c8688001c873800000000001c8708001c87a000000000001c8770001f00f800000000001c87e8001f017000000000001f01400000fffe000201050000000000000000000000000000000000000001f29f85e010684ff9000891abd9b3272b0000003000000174000000110000000100000090000000020000009800000003000000a400000004000000b000000005000000c400000006000000d000000007000000dc00000008000000f0000000090000010400000012000001100000000a000001300000000c0000013c0000000d000001480000000e000001540000000f0000015c0000001000000164000000130000016c00000002000004e40000001e00000004000000000000001e00000004000000000000001e0000000c6c656f4a69685720000065740000001e00000004000000000000001e00000004000000000000001e0000000c6d726f4e642e6c610000746f0000001e0000000c6c656f4a69685720000065740000001e00000004000000310000001e000000187263694d666f736f664f207465636966726f57200000006400000040000000000000000000000040bbed880001c4f92c00000040bbed880001c4f92c00000003000000010000000300000000000000030000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400050063006f006d0075006e006500530074006d00750061006d00790072006e0049006f0066006d007200740061006f00690000006e000000000000000000020038ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000002000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fffe000201050000000000000000000000000000000000000001d5cdd502101b2e9c00089793aef92c2b00000030000000f80000000c00000001000000680000000f00000070000000050000008c0000000600000094000000110000009c00000017000000a40000000b000000ac00000010000000b400000013000000bc00000016000000c40000000d000000cc0000000c000000d900000002000004e40000001e000000146c74754f542077616e686365676f6c6f0073656900000003000000010000000300000001000000030000000000000003000b18d80000000b000000000000000b000000000000000b000000000000000b000000000000101e000000010000000100100c000000020000001e0000000600746954000300656c01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Ew_word_window_old.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
