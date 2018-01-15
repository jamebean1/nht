$PBExportHeader$w_docs_quick_interface.srw
$PBExportComments$Documents Quick Interface
forward
global type w_docs_quick_interface from w_main_std
end type
type dw_docs_generic from u_dw_std within w_docs_quick_interface
end type
type st_2 from statictext within w_docs_quick_interface
end type
type st_1 from statictext within w_docs_quick_interface
end type
type dw_docs_quick_list from u_dw_std within w_docs_quick_interface
end type
end forward

global type w_docs_quick_interface from w_main_std
integer width = 3049
integer height = 1704
string menuname = "m_docs_quick_interface"
event ue_selecttrigger pbm_dwnkey
dw_docs_generic dw_docs_generic
st_2 st_2
st_1 st_1
dw_docs_quick_list dw_docs_quick_list
end type
global w_docs_quick_interface w_docs_quick_interface

type variables
STRING i_cSourceType
STRING i_cCurrentCaseSubject
STRING i_cOpenDocs[]
STRING i_cUserID 

LONG i_nDocCounter

DATE i_dCreateDates[]

BOOLEAN i_bChangeMode
BOOLEAN i_bOutOfOffice


end variables

forward prototypes
public subroutine fw_sort_data ()
public subroutine fw_checkoutofoffice ()
end prototypes

public subroutine fw_sort_data ();//******************************************************************************************
// Function: fw_sort_data
//	Purpose: Sort the datawindow 
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//  01/31/00 C. Jackson  Original Version
//
//******************************************************************************************/

INT				l_nCounter, l_nAnotherCounter, l_nColumnCount
LONG				l_nSortError
S_ColumnSort	l_sSortData
STRING 			l_cTag, l_cSortString

	
// sort dw_docs_quick_list
l_nAnotherCounter = 1
l_sSortData.label_name[l_nAnotherCounter] = dw_docs_quick_list.Describe(&
		"sort_case_number.Tag")
l_sSortData.column_name[l_nAnotherCounter] = 'sort_case_number'

l_nColumnCount = LONG(dw_docs_quick_list.Describe("Datawindow.Column.Count")) 

FOR l_nCounter = 1 to l_nColumnCount

		l_cTag = dw_docs_quick_list.Describe("#" + String(l_nCounter) + ".Tag")

	   IF l_cTag <> '?' THEN
			l_nAnotherCounter ++
			l_sSortData.label_name[l_nAnotherCounter]  = l_cTag
			l_sSortData.column_name[l_nAnotherCounter] = dw_docs_quick_list.Describe(&
				"#" + String(l_nCounter) + ".Name")
		END IF
NEXT

FWCA.MGR.fu_OpenWindow(w_sort_order, 0, l_sSortData)

l_cSortString = Message.StringParm

IF l_cSortString <> '' THEN
	l_nSortError = dw_docs_quick_list.SetSort(l_cSortString)
	l_nSortError = dw_docs_quick_list.Sort()
END IF

	
// sort dw_docs_generic
l_nAnotherCounter = 1
l_sSortData.label_name[l_nAnotherCounter] = dw_docs_generic.Describe(&
		"sort_case_number.Tag")
l_sSortData.column_name[l_nAnotherCounter] = 'sort_case_number'

l_nColumnCount = LONG(dw_docs_generic.Describe("Datawindow.Column.Count")) 

FOR l_nCounter = 1 to l_nColumnCount

		l_cTag = dw_docs_generic.Describe("#" + String(l_nCounter) + ".Tag")

	   IF l_cTag <> '?' THEN
			l_nAnotherCounter ++
			l_sSortData.label_name[l_nAnotherCounter]  = l_cTag
			l_sSortData.column_name[l_nAnotherCounter] = dw_docs_generic.Describe(&
				"#" + String(l_nCounter) + ".Name")
		END IF
NEXT

FWCA.MGR.fu_OpenWindow(w_sort_order, 0, l_sSortData)

l_cSortString = Message.StringParm

IF l_cSortString <> '' THEN
	l_nSortError = dw_docs_generic.SetSort(l_cSortString)
	l_nSortError = dw_docs_generic.Sort()
END IF

	

end subroutine

public subroutine fw_checkoutofoffice ();//********************************************************************************************
//
//  Function: fw_checkoutofoffice
//  Purpose:  To mark the out of office menu item
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  12/15/00 cjackson    Original Verison
//
//********************************************************************************************

LONG l_nCount

// Get userid
i_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

// If the user is currently mark as out of the office, setting the Check on the menu item
SELECT count(*) INTO :l_nCount
  FROM cusfocus.out_of_office
 WHERE out_user_id = :i_cUserID
 USING SQLCA;
 
// Update the clicked property based on whether not the user if Out of Office 
IF l_nCount > 0 THEN
	m_docs_quick_interface.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_docs_quick_interface.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
END IF







end subroutine

on w_docs_quick_interface.create
int iCurrent
call super::create
if this.MenuName = "m_docs_quick_interface" then this.MenuID = create m_docs_quick_interface
this.dw_docs_generic=create dw_docs_generic
this.st_2=create st_2
this.st_1=create st_1
this.dw_docs_quick_list=create dw_docs_quick_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_docs_generic
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_docs_quick_list
end on

on w_docs_quick_interface.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_docs_generic)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_docs_quick_list)
end on

event pc_setoptions;call super::pc_setoptions;//****************************************************************************************
// 
//			Event:	pc_setoptions 	
//			Purpose:	To set uo_dw_main options, set the PowerClass Message object text and 
//						find out the user first and last name.
//						
//  Date     Developer    Description
//  -------- ------------ ----------------------------------------------------------------
//  02/17/00 C. Jackson   Original Version
//  03/24/00 C. Jackson   Remove fu_swap.  No longer needed (SCR 407)
//  12/06/01 C. Jackson   Corrected setting of title.  For providers was looking at 
//                        provider_id rather than provider_key (SCR 2569)
//  12/10301 C. Jackson   Add Other Source Type into the whole mix (SCR 2569)
//
//****************************************************************************************/

STRING l_cFirstName, l_cLastName, l_cUserID, l_cTitle, l_cSourceType, l_cCurrentCaseSubject
STRING l_cEntity

l_cSourceType = w_create_maintain_case.i_cSourceType
l_cCurrentCaseSubject = w_create_maintain_case.i_cCurrentCaseSubject

	CHOOSE CASE l_cSourceType
		CASE 'C'
			l_cTitle = 'Member:  '
			SELECT consum_first_name, consum_last_name
			  INTO :l_cFirstName, :l_cLastName
			  FROM cusfocus.consumer
			 WHERE consumer_id = :l_cCurrentCaseSubject
			 USING SQLCA;
			 
			l_cEntity = l_cLastName + ', ' + l_cFirstName
			
			l_cSourceType = 'E'
		CASE 'P'
			l_cTitle = 'Provider:  '
			SELECT provid_name
			  INTO :l_cEntity
			  FROM cusfocus.provider_of_service
			 WHERE provider_key = convert( int, :l_cCurrentCaseSubject )
			 USING SQLCA;
			 
		CASE 'E'
			l_cTitle = 'Group:  '
			SELECT employ_group_name 
			  INTO :l_cEntity 
			  FROM cusfocus.employer_group 
			 WHERE group_id =:l_cCurrentCaseSubject
			 USING SQLCA;
			 
		CASE 'O'
			l_cTitle = 'Other Source:  '
			SELECT other_name
			  INTO :l_cEntity
			  FROM cusfocus.other_source
			 WHERE customer_id = :l_cCurrentCaseSubject
			 USING SQLCA;
			 

END CHOOSE

		
dw_docs_generic.fu_SetOptions( SQLCA, & 
 		dw_docs_generic.c_NullDW, & 
 		dw_docs_generic.c_NewModeOnEmpty + &
		dw_docs_generic.c_NoActiveRowPointer + &
 		dw_docs_generic.c_NoMenuButtonActivation + &
 		dw_docs_generic.c_SelectOnRowFocusChange + &
		dw_docs_generic.c_SortClickedOK + &
		dw_docs_generic.c_TabularFormStyle + &
		dw_docs_generic.c_ViewOnSelect )
			
Tag = 'Documents Quick Interface for '

fw_SetOptions(c_Default + c_ToolbarTop)			

Title = Tag + l_cTitle + l_cEntity

fw_CheckOutOfOffice()

// initialize the resize service for this window

of_SetResize (TRUE)

IF IsValid (inv_resize) THEN
	inv_resize.of_SetOrigSize ((Width - 30), (Height - 178))
	inv_resize.of_SetMinSize ((Width - 30), (Height - 178))
	
	inv_resize.of_Register (dw_docs_generic, inv_resize.SCALERIGHTBOTTOM)
	inv_resize.of_Register (dw_docs_quick_list, inv_resize.SCALERIGHT)
	
END IF

end event

event pc_close;call super::pc_close;//******************************************************************************************
//     Event: pc_close
//	Purpose: Perform closing processes
//	
//  Date     Developer   Description
//  -------- ----------  -------------------------------------------------------------------
//  02/28/00 C. Jackson  Original Version
//  05/11/00 C. Jackosn  Decrement the number of windows listed as open for 
//                       w_create_maintain_case (SCR 632)
//  5/23/2002 K. Claver  Added check to see if the create maintain case window is still open
//								 before attempting to execute this code.
//
//******************************************************************************************/

IF IsValid( w_create_maintain_case ) THEN
	// Set i_bDocOpened to False so that a reset won't take place in w_create_maintain_case
	w_create_maintain_case.i_bDocsOpened = FALSE
	
	// remove this window from the list the parent keeps
	w_create_maintain_case.i_NumWindowChildren = w_create_maintain_case.i_NumWindowChildren - 1
END IF
end event

event pc_setvariables;call super::pc_setvariables;//*********************************************************************************************
//
//  Event:			pc_setvariables
//  Description: Initialize variables
//  
//  Date     Developer    Description
//  -------- ------------ ----------------------------------------------------------------------
//  04/04/00 C. Jackson   Original Version
//  
//*********************************************************************************************
  
i_nDocCounter = 1  
end event

event pc_closequery;call super::pc_closequery;//*************************************************************************************************
//
//  Event:        pc_closequery
//  Description:  Close any documents that might be open
//  
//  Date     Developer    Description
//  -------- ------------ -------------------------------------------------------------------------
//  04/04/00 C. Jackson   Original Version
//  11/10/00 C. Jackson   Original Version
//  
//*************************************************************************************************  

LONG l_nCounter, l_nDocNameLength
STRING l_cDocName, l_cDocExt, l_cDocShortName
BOOLEAN l_bDeleted

l_nCounter = 1

DO WHILE l_nCounter < i_nDocCounter
	
	// Get the doc name from the instance array
	l_cDocName = i_cOpenDocs[l_nCounter]

	IF FileExists(l_cDocName) THEN
		
		// Attempt to delete the file
		l_bDeleted = FileDelete(l_cDocName)
		
		// If unsuccessful, since the file does exist, this means the file is open and cannot be deleted
		IF l_bDeleted = FALSE THEN
			
			// Get the file extension to display error message
			l_nDocNameLength = LEN(l_cDocName)
			l_cDocExt = MID(l_cDocName, (l_nDocNameLength - 3))

			l_cDocShortName = MID(l_cDocName,4)

			CHOOSE CASE UPPER(l_cDocExt)
				CASE '.PDF'
					messagebox(gs_AppName,'You must close the Adobe Acrobat File "' + l_cDocShortName + '" before closing the Doc Quick Interface window.')
				CASE '.DOC'
					messagebox(gs_AppName,'You must close the Word Document "' + l_cDocShortName + '" before closing the Doc Quick Interface window.')
				CASE '.XLS'
					messagebox(gs_AppName,'You must close the Excel Spreadsheet "' + l_cDocShortName + '" before closing the Doc Quick Interface window.')
			END CHOOSE			
			Error.i_FWError = c_Fatal
			EXIT
			
		END IF
			
	END IF
	
l_nCounter++	
LOOP
end event

type dw_docs_generic from u_dw_std within w_docs_quick_interface
integer x = 5
integer y = 824
integer width = 2999
integer height = 676
integer taborder = 10
string title = "none"
string dataobject = "d_docs_generic"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;call super::doubleclicked;//*****************************************************************************************
//
//  Event:	 doubleclicked
//  Purpose: To allow the user to view the document
//				
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//  04/04/00 C. Jackson  Original Version
//	 06/02/00 M. Caruso   Added code to prevent processing unless a row is selected.
//  11/10/00 C. Jackson  Add Excel
//  06/27/01 C. Jackson  Initialize l_cAppPath to null
//  11/28/01 C. Jackson  Change document path from C Drive to the Temp Path from the Environment
//                       Variables.
//
//*****************************************************************************************

STRING l_cDocID, l_cAppPath, l_cFileName, l_cExt
LONG l_nRowCount, l_nFileNameLength, l_nPathLength, l_nFileNum, l_nFileLength, l_nLoops, l_nCounter
LONG l_nBytes, l_nBlobStart, l_nRow
BLOB l_bTotalImage, l_bPartialImage
ContextKeyword lcxk_base
string ls_temp[]
n_cst_kernel32 l_nKernelFuncs

SETNULL(l_cAppPath)


l_nRow = THIS.GetRow()

IF l_nRow > 0 THEN
	
	// Get Filename
	l_cFileName = THIS.GetItemString(l_nRow,'documents_doc_filename')
	
	//RPost 10.19.2006 Adding Link Code
	String 	ls_link
	inet 		linet_base

	ls_link = THIS.GetItemString(l_nRow,'documents_link')
	
	If Len(ls_link) > 0 and Not IsNull(ls_link) Then
		
		IF lower(MID(ls_link,1,5)) = "https" THEN ls_link = MID(ls_link,9)
		IF lower(MID(ls_link,1,4)) = "http" THEN ls_link = MID(ls_link,8)
		
		GetContextService("Internet", linet_base)
		linet_base.HyperlinkToURL(ls_link)

	Else
		IF ISNULL(l_cFileName) THEN
			messagebox(gs_AppName,'There is no image associated with this Document.')
			RETURN
		END IF
		
		// Get DocID
		l_cDocID = THIS.GetItemString(l_nRow,'documents_doc_id')
		
		// Set a wait cursor
		SetPointer(HourGlass!)
		
		// Get Blob, l_bDocImage is the total blob
		SELECTBLOB doc_image
				INTO :l_bTotalImage
				FROM cusfocus.documents
			  WHERE doc_id = :l_cDocID;
			  
		// Determine the filetype based on the file extension
		l_nFileNameLength = LEN(l_cFileName)
		l_cExt = MID(l_cFileName, (l_nFileNameLength - 3))
		
		// Process based on filetype
		CHOOSE CASE UPPER(l_cExt)
			CASE '.PDF'
		
				// Make sure the user has Adobe Acrobat installed and get the path
				RegistryGet( &
					 "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Software\Adobe\Acrobat\Exe","",RegString!, l_cAppPath)
					 
					IF ISNULL(l_cAppPath) THEN
						Messagebox(gs_AppName,'This workstation does not have Acrobat Reader installed.')
					END IF
					
					
			CASE '.DOC'
				// Make sure the user has Microsoft Word installed and get the path
				RegistryGet( &
					 "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Winword.exe","",RegString!, l_cAppPath)
					 
					IF ISNULL(l_cAppPath) THEN
						Messagebox(gs_AppName,'This workstation does not have Microsoft Word installed.')
					END IF
					
			CASE '.XLS'
				// Make sure the user has Microsoft Excel installed and get the path
				RegistryGet( &
					 "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Excel.exe","",RegString!, l_cAppPath)
					 
					IF ISNULL(l_cAppPath) THEN
						Messagebox(gs_AppName,'This workstation does not have Microsoft Excel installed.')
					END IF
					
		END CHOOSE
		
		//Prepare to open the document
		// Get the Temp Path from Environment Variables
		THIS.GetContextService("Keyword", lcxk_base)
		lcxk_base.getContextKeywords("TEMP", ls_temp)
		
		// Temp Path is not available, use Root drive
		If Not l_nKernelFuncs.of_DirectoryExists(ls_temp[1]) Then 
			ls_Temp[1] = 'C:\'
		END IF
	
		l_cFileName = ls_temp[1] + '\' + l_cFileName
		l_nFileNum = FileOpen(l_cFileName,StreamMode!,Write!)
		l_nFileLength = LEN(l_bTotalImage)
		
		// Determine the number of times to call FileWrite
		IF l_nFileLength > 32765 THEN
		
			IF Mod(l_nFileLength, 32765) = 0 THEN
				l_nLoops = l_nFileLength/32765
			ELSE 
				l_nLoops = CEILING(l_nFileLength/32765)
			END IF
			
		ELSE
			l_nLoops = 1
		END IF
		
		l_nBlobStart = 1
		
		FOR l_nCounter = 1 TO l_nLoops
			l_bPartialImage  = BLOBMID(l_bTotalImage,l_nBlobStart,32765)
			l_nBytes = FileWrite(l_nFileNum,l_bPartialImage)
			l_nBlobStart = (l_nBlobStart + 32765)
		NEXT
		
		FileClose(l_nFileNum)
		
		// Get the path to pass to the Run Command
		IF POS(l_cAppPath,'"',1) <> 1 THEN
			l_cAppPath = '"'+l_cAppPath
		END IF
		l_nPathLength = LEN(l_cAppPath)
		IF POS(l_cAppPath,'"',l_nPathLength) <> l_nPathLength THEN
			l_cAppPath = l_cAppPath + '"'
		END IF
		
	//	l_cAppPath = l_cAppPath + l_cFileName
		l_cAppPath = l_cAppPath + ' "'+l_cFileName+'"'
		
		// Keep track of Documents that are open
		i_cOpenDocs[i_nDocCounter] = l_cFileName
		i_nDocCounter = i_nDocCounter + 1
		
		// Run the application to view the document
		RUN(l_cAppPath)
	END IF
	
END IF

end event

event getfocus;call super::getfocus;//************************************************************************************************
//
//  Event:   getfocus
//  Purpose: remove row select
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  02/08/01 C. Jackson  Original Version
//
//************************************************************************************************

dw_docs_generic.SelectRow(0,FALSE)
end event

event rbuttondown;call super::rbuttondown;//**********************************************************************************************
//
//  Event:   rbuttondown
//  Purpose: To open the Document Details Response window
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  08/22/00 C. Jackson  Original Version
//
//**********************************************************************************************

LONG		l_nRow
STRING	l_cDocID

l_nRow = this.GetRow()

IF l_nRow > 0 THEN

	l_cDocID = this.GetItemString(l_nRow,"documents_doc_id")
	
	OpenWithParm(w_doc_details,l_cDocID)
	
END IF


end event

event pcd_retrieve;call super::pcd_retrieve;/**************************************************************************************

			Event:	pcd_retrieve
			Purpose:	To retrieve the data.
						object.

*************************************************************************************/

LONG l_nReturn, l_nSelected[]
STRING l_cSourceType, l_cCurrentCaseSubject, l_cGroupID

l_cSourceType = w_create_maintain_case.i_cSourceType
l_cCurrentCaseSubject = w_create_maintain_case.i_cCurrentCaseSubject

CHOOSE CASE l_cSourceType
	CASE 'C'
		l_cSourceType = 'E'

		// Get GroupID for Member
		SELECT group_id INTO :l_cGroupID
		  FROM cusfocus.consumer
		 WHERE consumer_id = :l_cCurrentCaseSubject;
		 
		//  Get Group ID to Current Case Subject since docs are stored by group and not member
		l_cCurrentCaseSubject = l_cGroupID

END CHOOSE

l_nReturn = Retrieve(l_cCurrentCaseSubject,l_cSourceType)

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF

end event

event pcd_setoptions;call super::pcd_setoptions;//***********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpse:  To set the datawindow options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  08/22/00 C. Jackson  Original Version
//  07/06/01 C. Jackson  Add c_NoEnablePopup
//  
//***********************************************************************************************


fu_SetOptions (SQLCA, c_NullDW, c_SelectOnRowFocusChange + c_NoMenuButtonActivation + &
										  c_ModifyOK + c_SortClickedOK + c_NoEnablePopup)



end event

event clicked;call super::clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: To de-select the Quick list documents
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  05/24/01 C. Jackson  Original Version
//  
//**********************************************************************************************

LONG l_nSelectedRows[], l_nRowCount
STRING ls_link
inet linet_base

l_nSelectedRows[1] = 0


l_nRowCount = dw_docs_quick_list.RowCount()

IF l_nRowCount > 0 THEN
	
	dw_docs_quick_list.fu_SetSelectedRows(0,l_nSelectedRows[],c_IgnoreChanges,c_NoRefreshChildren)
	
	
	IF dwo.type = "column" THEN
		m_docs_quick_interface.m_file.m_viewdetails.Enabled = TRUE

		//RPost 10.19.2006 Adding the ability to open a link with a single click if they 
		// 						click on the new document link field
		Choose Case dwo.Name
			Case 'documents_link'
				
			ls_link = THIS.GetItemString(row,'documents_link')
			
			If Len(ls_link) > 0 and Not IsNull(ls_link) Then
				IF lower(MID(ls_link,1,5)) = "https" THEN ls_link = MID(ls_link,9)
				IF lower(MID(ls_link,1,4)) = "http" THEN ls_link = MID(ls_link,8)
				
				GetContextService("Internet", linet_base)
				linet_base.HyperlinkToURL(ls_link)
	
			End If		
		End Choose
	END IF
	
END IF
end event

type st_2 from statictext within w_docs_quick_interface
integer y = 760
integer width = 558
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "General Documents:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_docs_quick_interface
integer y = 4
integer width = 649
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Associated Documents:"
boolean focusrectangle = false
end type

type dw_docs_quick_list from u_dw_std within w_docs_quick_interface
integer x = 5
integer y = 72
integer width = 2999
integer height = 688
integer taborder = 10
string title = "none"
string dataobject = "d_docs_quick_list"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;call super::doubleclicked;//*****************************************************************************************
//
//  Event:	 doubleclicked
//  Purpose: To allow the user to view the document
//				
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//  04/04/00 C. Jackson  Original Version
//	 06/02/00 M. Caruso   Added code to prevent processing unless a row is selected.
//  11/10/00 C. Jackson  Add Excel
//  06/27/01 C. Jackson  Initialize l_cAppPath to null
//  11/28/01 C. Jackson  Change document path from C Drive to the Temp Path from the Environment
//                       Variables.
//
//*****************************************************************************************

STRING l_cDocID, l_cAppPath, l_cFileName, l_cExt
LONG l_nRowCount, l_nFileNameLength, l_nPathLength, l_nFileNum, l_nFileLength, l_nLoops, l_nCounter
LONG l_nBytes, l_nBlobStart, l_nRow
BLOB l_bTotalImage, l_bPartialImage
ContextKeyword lcxk_base
string ls_temp[]
n_cst_kernel32 l_nKernelFuncs

SETNULL(l_cAppPath)

l_nRow = THIS.GetRow()
IF l_nRow > 0 THEN
	
	// Get Filename
	l_cFileName = THIS.GetItemString(l_nRow,'documents_doc_filename')
	
	//RPost 10.19.2006 Adding Link Code
	String 	ls_link
	inet 		linet_base

	ls_link = THIS.GetItemString(l_nRow,'documents_link')
	
	If Len(ls_link) > 0 and Not IsNull(ls_link) Then
		
		IF lower(MID(ls_link,1,5)) = "https" THEN ls_link = MID(ls_link,9)
		IF lower(MID(ls_link,1,4)) = "http" THEN ls_link = MID(ls_link,8)
		
		GetContextService("Internet", linet_base)
		linet_base.HyperlinkToURL(ls_link)

	Else
		IF ISNULL(l_cFileName) THEN
			messagebox(gs_AppName,'There is no image associated with this Document.')
			RETURN
		END IF
		
		// Get DocID
		l_cDocID = THIS.GetItemString(l_nRow,'documents_doc_id')
		
		// Set a wait cursor
		SetPointer(HourGlass!)
		
		// Get Blob, l_bDocImage is the total blob
		SELECTBLOB doc_image
				INTO :l_bTotalImage
				FROM cusfocus.documents
			  WHERE doc_id = :l_cDocID;
			  
		// Determine the filetype based on the file extension
		l_nFileNameLength = LEN(l_cFileName)
		l_cExt = MID(l_cFileName, (l_nFileNameLength - 3))
		
		// Process based on filetype
		CHOOSE CASE UPPER(l_cExt)
			CASE '.PDF'
		
				// Make sure the user has Adobe Acrobat installed and get the path
				RegistryGet( &
					 "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Software\Adobe\Acrobat\Exe","",RegString!, l_cAppPath)
					 
					IF ISNULL(l_cAppPath) THEN
						Messagebox(gs_AppName,'This workstation does not have Acrobat Reader installed.')
					END IF
					
					
			CASE '.DOC'
				// Make sure the user has Microsoft Word installed and get the path
				RegistryGet( &
					 "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Winword.exe","",RegString!, l_cAppPath)
					 
					IF ISNULL(l_cAppPath) THEN
						Messagebox(gs_AppName,'This workstation does not have Microsoft Word installed.')
					END IF
					
			CASE '.XLS'
				// Make sure the user has Microsoft Excel installed and get the path
				RegistryGet( &
					 "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Excel.exe","",RegString!, l_cAppPath)
					 
					IF ISNULL(l_cAppPath) THEN
						Messagebox(gs_AppName,'This workstation does not have Microsoft Excel installed.')
					END IF
					
		END CHOOSE
		
		//Prepare to open the document
		// Get the Temp Path from Environment Variables
		THIS.GetContextService("Keyword", lcxk_base)
		lcxk_base.getContextKeywords("TEMP", ls_temp)
		
		// Temp Path is not available, use Root drive
		If Not l_nKernelFuncs.of_DirectoryExists(ls_temp[1]) Then 
			ls_Temp[1] = 'C:\'
		END IF
	
		l_cFileName = ls_temp[1] + '\' + l_cFileName	
		l_nFileNum = FileOpen(l_cFileName,StreamMode!,Write!)
		l_nFileLength = LEN(l_bTotalImage)
		
		// Determine the number of times to call FileWrite
		IF l_nFileLength > 32765 THEN
		
			IF Mod(l_nFileLength, 32765) = 0 THEN
				l_nLoops = l_nFileLength/32765
			ELSE 
				l_nLoops = CEILING(l_nFileLength/32765)
			END IF
			
		ELSE
			l_nLoops = 1
		END IF
		
		l_nBlobStart = 1
		
		FOR l_nCounter = 1 TO l_nLoops
			l_bPartialImage  = BLOBMID(l_bTotalImage,l_nBlobStart,32765)
			l_nBytes = FileWrite(l_nFileNum,l_bPartialImage)
			l_nBlobStart = (l_nBlobStart + 32765)
		NEXT
		
		FileClose(l_nFileNum)
		
		// Get the path to pass to the Run Command
		IF POS(l_cAppPath,'"',1) <> 1 THEN
			l_cAppPath = '"'+l_cAppPath
		END IF
		l_nPathLength = LEN(l_cAppPath)
		IF POS(l_cAppPath,'"',l_nPathLength) <> l_nPathLength THEN
			l_cAppPath = l_cAppPath + '"'
		END IF
		
		l_cAppPath = l_cAppPath + l_cFileName
		
		// Keep track of Documents that are open
		i_cOpenDocs[i_nDocCounter] = l_cFileName
		i_nDocCounter = i_nDocCounter + 1
		
		// Run the application to view the document
		RUN(l_cAppPath)
	END IF	
END IF

end event

event pcd_retrieve;call super::pcd_retrieve;/**************************************************************************************

			Event:	pcd_retrieve
			Purpose:	To retrieve the data.
						object.

*************************************************************************************/

LONG l_nReturn, l_nSelected[]
STRING l_cSourceType, l_cCurrentCaseSubject, l_cGroupID

l_cSourceType = w_create_maintain_case.i_cSourceType
l_cCurrentCaseSubject = w_create_maintain_case.i_cCurrentCaseSubject

CHOOSE CASE l_cSourceType
	CASE 'C'
		l_cSourceType = 'E'

		// Get GroupID for Member
		SELECT group_id INTO :l_cGroupID
		  FROM cusfocus.consumer
		 WHERE consumer_id = :l_cCurrentCaseSubject;
		 
		//  Get Group ID to Current Case Subject since docs are stored by group and not member
		l_cCurrentCaseSubject = l_cGroupID

END CHOOSE

l_nReturn = Retrieve(l_cCurrentCaseSubject,l_cSourceType)

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF

end event

event rbuttondown;call super::rbuttondown;//**********************************************************************************************
//
//  Event:   rbuttondown
//  Purpose: To open the Document Details Response window
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  08/22/00 C. Jackson  Original Version
//
//**********************************************************************************************

LONG		l_nRow
STRING	l_cDocID

l_nRow = this.GetRow()

IF l_nRow > 0 THEN

	l_cDocID = this.GetItemString(l_nRow,"documents_doc_id")
	
	OpenWithParm(w_doc_details,l_cDocID)
	
END IF


end event

event pcd_setoptions;call super::pcd_setoptions;//***********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpse:  To set the datawindow options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  08/22/00 C. Jackson  Original Version
//  07/06/01 C. Jackson  Add c_NoEnablePopup
//  
//***********************************************************************************************


fu_SetOptions (SQLCA, c_NullDW, c_SelectOnRowFocusChange + c_NoMenuButtonActivation + &
										  c_ModifyOK + c_SortClickedOK + c_NoEnablePopup)



end event

event getfocus;call super::getfocus;//************************************************************************************************
//
//  Event:   getfocus
//  Purpose: remove row select
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  02/08/01 C. Jackson  Original Version
//
//************************************************************************************************

dw_docs_generic.SelectRow(0,FALSE)
end event

event clicked;call super::clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: To de-select the generic documents
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  05/24/01 C. Jackson  Original Version
//  
//**********************************************************************************************

LONG l_nSelectedRows[], l_nRowCount
inet linet_base
String ls_link

l_nSelectedRows[1] = 0

l_nRowCount = dw_docs_generic.RowCount()

IF l_nRowCount > 0 THEN
	dw_docs_generic.fu_SetSelectedRows(0,l_nSelectedRows[],c_IgnoreChanges,c_NoRefreshChildren)
	
	IF dwo.type = "column" THEN
		m_docs_quick_interface.m_file.m_viewdetails.Enabled = TRUE
		
		//RPost 10.19.2006 Adding the ability to open a link with a single click if they 
		// 						click on the new document link field
		Choose Case dwo.Name
			Case 'documents_link'
				
			ls_link = THIS.GetItemString(row,'documents_link')
			
			If Len(ls_link) > 0 and Not IsNull(ls_link) Then
				IF lower(MID(ls_link,1,5)) = "https" THEN ls_link = MID(ls_link,9)
				IF lower(MID(ls_link,1,4)) = "http" THEN ls_link = MID(ls_link,8)
				
				GetContextService("Internet", linet_base)
				linet_base.HyperlinkToURL(ls_link)
	
			End If		
		End Choose
	END IF

END IF

end event

