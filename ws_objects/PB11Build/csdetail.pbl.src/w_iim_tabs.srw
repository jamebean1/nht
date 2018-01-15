$PBExportHeader$w_iim_tabs.srw
$PBExportComments$IIM Tab Window
forward
global type w_iim_tabs from w_main_std
end type
type tab_folder from u_tab_std within w_iim_tabs
end type
type tab_folder from u_tab_std within w_iim_tabs
end type
end forward

global type w_iim_tabs from w_main_std
integer width = 3653
integer height = 1908
string title = "Inquiry Information Module"
string menuname = "m_iim_tabs"
event ue_initiim ( )
event ue_iim_search ( )
event ue_printcurrenttab ( )
tab_folder tab_folder
end type
global w_iim_tabs w_iim_tabs

type variables
u_iim i_uIIM
Boolean i_bConnected
Integer i_nCurrentPage
String i_cWindowState

W_CREATE_MAINTAIN_CASE  i_wParentWindow
end variables

forward prototypes
public subroutine fw_initdemographics ()
public subroutine fw_sortdata ()
public subroutine fw_initwindow ()
end prototypes

event ue_initiim;/*****************************************************************************************
   Function:   ue_InitIIM
   Purpose:    Initialize the IIM tabs
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/7/00   M. Caruso    Created.
	11/1/2000 K. Claver   Moved from the old Inquiry User Object.
	4/16/2001 K. Claver   Changed to build all of the tab object, but only build the datawindow
								 for the first tab.  The rest are built as we switch tabs.
	7/9/2001 K. Claver    Enhanced to simply change the sql syntax when change source id
								 rather than rebuild the datawindow by calling the build folder function
								 when change source type and call the refresh function when change 
								 source id.
	3/5/2002 K. Claver    Changed the call to the uf_BuildSummaryFolder to be posted to ensure
								 the tab folder is fully initialized.
*****************************************************************************************/
Boolean l_bRefresh

IF i_wParentWindow.i_cCurrentCaseSubject <> i_uIIM.i_cCaseSubjectId THEN
	l_bRefresh = TRUE
ELSE
	l_bRefresh = FALSE
END IF

// initialize the IIM for this case
IF i_wParentWindow.i_cSourceType <> i_uIIM.i_cSourceType THEN
	
	CHOOSE CASE i_uIIM.uf_InitIIM (i_wParentWindow.i_cSourceType, &
											 i_wParentWindow.i_cCurrentCaseSubject, i_wParentWindow.i_uoCaseDetails)
		CASE 0
			CHOOSE CASE i_uIIM.Retrieve ()
				CASE IS >= 0
					i_uIIM.uf_BuildDSNList ()	
					IF Upperbound (tab_folder.Control[]) > 0 THEN
						i_uIIM.uf_ClearCurrentTabs (tab_folder)
					END IF
					
					//Build the tabs
					i_uIIM.uf_BuildTabs( tab_folder )
					//Build the datawindow in the first tab and populate it.
					i_uIIM.Function Post uf_BuildSummaryFolder( tab_folder, 1 )
					
				CASE IS < 0
					MessageBox (gs_AppName, "There was an error retrieving tab information.")
					IF Upperbound (tab_folder.Control[]) > 0 THEN
						i_uIIM.uf_ClearCurrentTabs (tab_folder)
					END IF
					
			END CHOOSE
		
		CASE -1
			MessageBox (gs_AppName, "Unable to initialize the Information Module.~r~n" + &
														 "No information tabs will be available.")
			
	END CHOOSE
	
ELSE
	
	IF l_bRefresh THEN
		
		// refresh the tab folders to ensure proper data.
		IF Upperbound (tab_folder.Control[]) > 0 THEN
			i_uIIM.uf_RefreshSummaryFolder (tab_folder)
			
			//Reset the subject ID after the refresh.
			i_uIIM.i_cCaseSubjectID = i_wParentWindow.i_cCurrentCaseSubject
		END IF
		
	END IF
	
END IF
end event

event ue_iim_search;/*****************************************************************************************
   Function:   ue_IIM_Search
   Purpose:    Search on the current IIM 
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/7/00   M. Caruso    Created.
	8/16/2000 K. Claver   Removed describe for summary syntax column and replaced with 
								 instance variable containing the summary syntax
	4/19/2001 K. Claver   Commented out code to open the custom search window as the PB generic
								 search window accomodates for dbname properties without fully qualified
								 column names.
	5/31/2001 K. Claver   Enhanced for use of InfoMaker in IIM.
	7/9/2001  K. Claver   Not a refresh job, so set the variable to specify such to rebuild
								 the datawindow.
*****************************************************************************************/

INTEGER			l_nTabNum, l_nRV, l_nColID, l_nColCount
STRING			l_cDWSyntax, l_cColName
STRING			l_cConvertToDate
U_IIM_TAB_PAGE	l_uPage
U_DW_STD			l_dwView

// get a reference to the current summary view datawindow control
l_nTabNum = tab_folder.selectedtab
l_uPage = tab_folder.control[l_nTabNum]
l_dwView = l_uPage.dw_summary_view

// reset the datawindow syntax back to the value stored in the database
l_cDWSyntax = l_uPage.i_cSummarySyntax

IF Match( l_cDWSyntax, "#CD#" ) THEN
	//Fields to convert to dates exist.  Parse them off the end before
	//  create the datawindow.
	l_cConvertToDate = Upper( Mid( l_cDWSyntax, Pos( l_cDWSyntax, "#CD#" ) ) )
	l_cDWSyntax = Mid( l_cDWSyntax, 1, Pos( l_cDWSyntax, "#CD#" ) - 1 )
	l_dwView = l_uPage.dw_Initial_View
	l_dwView.fu_Reset( l_dwView.c_IgnoreChanges )
END IF

l_nRV = l_dwView.Create (l_cDWSyntax)
IF l_nRV < 1 THEN
	MessageBox( gs_AppName, "Invalid search criteria.  Please re-enter", Stopsign!, Ok! )
ELSE
	l_dwView.SetTransObject (l_dwView.i_DBCA)
	
	//Always set back to the summary view datawindow for the retrieve as the retrieve
	//  code resides in the pcd_retrieve event for the summary view datawindow
	l_dwView = l_uPage.dw_summary_view
	l_dwView.fu_Reset( l_dwView.c_IgnoreChanges )
	
	l_uPage.i_cConvertToDate = l_cConvertToDate
	
	// Set a tab sequence and set them to display only so can
	//	  copy and paste from the fields.
	l_nColCount = Integer( l_dwView.Describe( 'Datawindow.Column.Count' ) )
	FOR l_nColID = 1 TO l_nColCount
		IF l_dwView.Describe( "#"+String( l_nColID )+".Visible" ) = "1" THEN									
			l_dwView.Modify( "#"+String( l_nColID )+".TabSequence='"+String( ( l_nColID * 10 ) )+"'" )
			
			String l_cStyle
			l_cStyle = Upper( l_dwView.Describe( "#"+String( l_nColID )+".Edit.Style" ) )
			
			//Disable the column depending on edit style type
			CHOOSE CASE Upper( l_dwView.Describe( "#"+String( l_nColID )+".Edit.Style" ) )
				CASE "EDIT"
					l_dwView.Modify( "#"+String( l_nColID )+".Edit.DisplayOnly='Yes'" )
				CASE "CHECKBOX", "RADIOBUTTONS", "DDDW", "DDLB", "EDITMASK" 
					l_dwView.Modify( "#"+String( l_nColID )+".Protect='1'" )
			END CHOOSE											
		END IF
	NEXT
	
	//Not a refresh - a re-select.
	l_uPage.i_bRefresh = FALSE
	
	l_dwView.fu_retrieve (l_dwView.c_IgnoreChanges, l_dwView.c_NoReselectRows)
	
	//Turn off the criteria.dialog
	FOR l_nColID = 1 TO l_nColCount
		l_dwView.Modify( "#"+String( l_nColID )+".Criteria.Dialog='No'" )
	NEXT
END IF
end event

event ue_printcurrenttab;/****************************************************************************************

     Event: ue_PrintCurrentTab
   Purpose: Print the datawindow on the current tab
	
 Revisions: Date     Developer     Description
            ======== ============= ======================================================
				5/29/2001 K. Claver    Created.
****************************************************************************************/
U_IIM_TAB_PAGE	l_uPage
ULong l_ulPrintJob
String l_cTabName

IF UpperBound( tab_folder.Control ) > 0 THEN
	// get a reference to the current summary view tab
	l_uPage = tab_folder.Control[ tab_folder.SelectedTab  ]
	l_cTabName = "IIM - "+l_uPage.Text

	l_ulPrintJob = PrintOpen( l_cTabName )	
	PrintDataWindow( l_ulPrintJob, l_uPage.dw_summary_view )
	PrintClose( l_ulPrintJob )
END IF
end event

public subroutine fw_initdemographics ();/*************************************************************************************

			Function:	fw_InitDemographics
			Purpose:		To Initialize the demographics tab if necessary.

*************************************************************************************
  Change History:

  Date     Person     Description of Change
  -------- ---------- ---------------------------------------------------------------
  03/20/01 M. Caruso  Created.
*************************************************************************************/

STRING				l_cDWObject
U_DEMOGRAPHICS		l_uoDemographics

CHOOSE CASE i_wparentwindow.i_cSourceType
	CASE i_wparentwindow.i_cSourceConsumer
		l_cDWObject = 'd_demographics_consumer'
		
	CASE i_wparentwindow.i_cSourceEmployer
		l_cDWObject = 'd_demographics_employer'
		
	CASE i_wparentwindow.i_cSourceProvider
		l_cDWObject = 'd_demographics_provider'
		
	CASE i_wparentwindow.i_cSourceOther
		l_cDWObject = 'd_demographics_other'
		
END CHOOSE

// initialize the demographics screen with the appropriate datawindow object
l_uoDemographics = i_wparentwindow.i_uoDemographics
IF NOT IsValid (l_uoDemographics) THEN
	SetPointer (HOURGLASS!)
	SetRedraw (FALSE)
	i_wparentwindow.OpenUserObject (l_uoDemographics,'u_demographics',	60, 217)
	l_uoDemographics.i_wParentWindow = i_wparentwindow
	l_uoDemographics.BringToTop = TRUE
	l_uoDemographics.Border = FALSE
	i_wparentwindow.i_woTabObjects[1] = l_uoDemographics
	i_wparentwindow.dw_folder.fu_assignTab (2, i_wparentwindow.i_woTabObjects[])

	l_uoDemographics.dw_demographics.fu_SetOptions( SQLCA, & 
		l_uoDemographics.dw_demographics.c_NullDW, & 
		i_wparentwindow.i_ulDemographicsCW + &
		i_wparentwindow.i_ulDemographicsVW + &
		l_uoDemographics.dw_demographics.c_NoMenuButtonActivation ) 

	l_uoDemographics.dw_demographics.SetRedraw (FALSE)
	IF l_uoDemographics.dw_demographics.DataObject <> l_cDWObject THEN
		l_uoDemographics.dw_demographics.fu_Swap(l_cDWObject, &
			l_uoDemographics.dw_demographics.c_IgnoreChanges, &
			i_wparentwindow.i_ulDemographicsCW + &
			i_wparentwindow.i_ulDemographicsVW + &
			l_uoDemographics.dw_demographics.c_NoMenuButtonActivation)
	END IF
	l_uoDemographics.fu_displayfields()
	l_uoDemographics.dw_demographics.SetRedraw (TRUE)

	// RAE  4/5/99				 
	l_uoDemographics.dw_demographics.fu_Retrieve(&
		l_uoDemographics.dw_demographics.c_IgnoreChanges, &
		l_uoDemographics.dw_demographics.c_NoReselectRows)

	SetRedraw(TRUE)
ELSE
	IF l_uoDemographics.dw_demographics.DataObject <> l_cDWObject THEN
		l_uoDemographics.dw_demographics.SetRedraw (FALSE)
		l_uoDemographics.dw_demographics.fu_Swap(l_cDWObject, &
			l_uoDemographics.dw_demographics.c_IgnoreChanges, &
			i_wparentwindow.i_ulDemographicsCW + &
			i_wparentwindow.i_ulDemographicsVW + &
			l_uoDemographics.dw_demographics.c_NoMenuButtonActivation)
		l_uoDemographics.fu_displayfields()
		l_uoDemographics.dw_demographics.SetRedraw (TRUE)
	END IF
	
	// RAE 4/5/99  retrieve
	l_uoDemographics.dw_demographics.fu_Retrieve(&
		l_uoDemographics.dw_demographics.c_IgnoreChanges, &
		l_uoDemographics.dw_demographics.c_ReselectRows)

END IF
end subroutine

public subroutine fw_sortdata ();/**************************************************************************************
	Function:	fw_sortdata
	Purpose:		To get the available fields on that datawindow to be sorted and
						sort them.
	Parameters:	None
	Returns:		None

	Revisions:
	Date     Developer    Description
	======== ============ ==============================================================
	07/31/01 M. Caruso    Created based on function from w_create_maintain_case.
**************************************************************************************/

INTEGER			l_nColumnCount, l_nTabIndex, l_nColumnIndex, l_nFieldIndex
LONG				l_nSortError
STRING			l_cSortString, l_cColumnName, l_cColumnLabel
S_COLUMNSORT	l_sSortData
U_DW_STD			l_dwSortDW
U_IIM_TAB_PAGE	l_tpIIMTab

// determine the datawindow to be sorted
l_nTabIndex = tab_folder.SelectedTab
l_tpIIMTab = tab_folder.Control[l_nTabIndex]
l_dwSortDW = l_tpIIMTab.dw_summary_view

// Get the column names and labels to display to the user.
l_nFieldIndex = 0
l_nColumnCount = LONG(l_dwSortDW.Describe("Datawindow.Column.Count")) 
FOR l_nColumnIndex = 1 to l_nColumnCount

	l_cColumnName = l_dwSortDW.Describe("#" + String(l_nColumnIndex) + ".Name")
	l_cColumnLabel = l_dwSortDW.Describe(l_cColumnName + "_t.Text")
	CHOOSE CASE l_cColumnLabel
		CASE '!', '?'
			// do nothing because the label is invalid.
			
		CASE ELSE
			l_nFieldIndex ++
			l_sSortData.label_name[l_nFieldIndex] = l_cColumnLabel
			l_sSortData.column_name[l_nFieldIndex] = l_cColumnName
			
	END CHOOSE
		
NEXT
	
FWCA.MGR.fu_OpenWindow(w_sort_order, 0, l_sSortData)
l_cSortString = Message.StringParm

IF l_cSortString <> '' THEN
	l_nSortError = l_dwSortDW.SetSort(l_cSortString)
	l_nSortError = l_dwSortDW.Sort()
END IF
end subroutine

public subroutine fw_initwindow ();/*****************************************************************************************
	Function: fw_initwindow
	Purpose: Initialize the IIM tabs
	
 	Revisions:
	Date     Developer       Description
   ======== =============== ==============================================================
	3/21/2001 K. Claver      Created
	08/31/01 M. Caruso       Added code to display a meaningful provider ID value in the
									 window title bar.
	09/06/01 M. Caruso       Corrected to store the provider key in a local variable of
	                         type LONG instead of an INT.
*****************************************************************************************/
Integer	l_nSelectedTab
LONG		l_nProvKey
windowobject l_woObjects[ ]
String l_cTabLabel, l_cSourceTypeDesc, l_cSubjectID, l_cProvID, l_cVendID, l_cWindowState
Boolean l_bEnabled, l_bVisible
u_folder l_fTabFolder

THIS.SetRedraw( FALSE )

IF IsValid( w_create_maintain_case ) THEN
	IF w_create_maintain_case.dw_folder.i_SelectedTab = 5 THEN
		tab_folder.Event Trigger ue_SetDragDrop( TRUE )
		
		m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = TRUE
	ELSE
		m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
	END IF

	i_wParentWindow = w_create_maintain_case
	l_fTabFolder = I_wParentWindow.dw_folder
	
	//Initialize the demographics
	fw_initdemographics ()
	
	//Populate the window objects array if tab 2(demographics) is instantiated
	l_fTabFolder.fu_TabInfo( 2, l_cTabLabel, l_bEnabled, l_bVisible, l_woObjects[ ] )
	
	IF NOT IsValid (i_uIIM) THEN
		i_uIIM = CREATE u_iim
		
		//Set the window options.  Do this after check if the IIM user object is
		//  instantiated as this tells us if the window was previously open.
		THIS.fw_SetOptions( THIS, c_ToolBarTop )
	END IF
	
	IF w_create_maintain_case.i_cSourceType <> i_uIIM.i_cSourceType THEN
		THIS.i_nCurrentPage = 1
	ELSE
		THIS.i_nCurrentPage = tab_folder.SelectedTab
	END IF
	
	THIS.Event Trigger ue_InitIIM( )
	
	IF w_create_maintain_case.dw_folder.i_SelectedTab = 5 THEN
		tab_folder.Event Trigger ue_SetDragDrop( TRUE )
		
		m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = TRUE
	ELSE
		m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
	END IF
END IF

THIS.i_NumDatawindows = 0

//Initialize the resize service if it doesn't already exist
THIS.of_SetResize( TRUE )
	
//Register the tab object and button with the service
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( tab_folder, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF

//Set the window title
CHOOSE CASE i_wParentWindow.i_cSourceType
	CASE 'C'
		l_cSourceTypeDesc = 'Member'
		l_cSubjectID = i_wParentWindow.i_cCurrentCaseSubject
		
	CASE 'E'
		l_cSourceTypeDesc = 'Group'
		l_cSubjectID = i_wParentWindow.i_cCurrentCaseSubject
		
	CASE 'P'
		l_cSourceTypeDesc = 'Provider'
		
		// get the provider ID and vendor ID for the current case subject
		l_nProvKey = LONG (i_wParentWindow.i_cCurrentCaseSubject)
		SELECT provider_id, vendor_id INTO :l_cProvID, :l_cVendID
		  FROM cusfocus.provider_of_service
		 WHERE provider_key = :l_nProvKey
		 USING SQLCA;
		 
		// determine the ID value to display.
		IF SQLCA.SQLCode = 0 THEN
			IF ISNULL(l_cProvID) THEN
				IF ISNULL(l_cVendID) THEN
					l_cSubjectID = '(No ID)'
				ELSE
					l_cSubjectID = l_cVendID
				END IF
			ELSE
				IF ISNULL(l_cVendID) THEN
					l_cSubjectID = l_cProvID
				ELSE
					l_cSubjectID = l_cProvID + '-' + l_cVendID
				END IF
			END IF
		ELSE
			l_cSubjectID = '(ID not found)'
		END IF
		
	CASE 'O'
		l_cSourceTypeDesc = 'Other'
		l_cSubjectID = i_wParentWindow.i_cCurrentCaseSubject
			
END CHOOSE

THIS.Title = 'Inquiry Information Module - ' + l_cSourceTypeDesc + ' - ' + l_cSubjectID + ' - ' + &
				  i_wParentWindow.i_cCaseSubjectName
				  
//Check the current window state and set back to what it was when the window was
//  activated if different
CHOOSE CASE THIS.WindowState
	CASE Maximized!
		l_cWindowState = "Maximized"
	CASE Minimized!
		l_cWindowState = "Minimized"
	CASE Normal!
		l_cWindowState = "Normal"
END CHOOSE
	
IF l_cWindowState <> THIS.i_cWindowState THEN
	CHOOSE CASE THIS.i_cWindowState
		CASE "Maximized"
			THIS.WindowState = Maximized!
		CASE "Minimized"
			THIS.WindowState = Minimized!
		CASE ELSE
			THIS.WindowState = Normal!
	END CHOOSE
END IF

THIS.SetRedraw( TRUE )
	
end subroutine

on w_iim_tabs.create
int iCurrent
call super::create
if this.MenuName = "m_iim_tabs" then this.MenuID = create m_iim_tabs
this.tab_folder=create tab_folder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_folder
end on

on w_iim_tabs.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_folder)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
     Event: pc_SetOptions
	Purpose: Set the options for the window
	
 Revisions: Date     Developer       Description
            ======== =============== ===================================================
				9/26/2000 K. Claver      Created.
				03/20/01 M. Caruso       Initialize demographics by calling fw_initdemogrpahics
												 instead of changing tabs.
				3/22/2001 K. Claver      Moved to the fw_initwindow function.
*****************************************************************************************/
THIS.fw_initwindow( )

//Integer l_nSelectedTab
//windowobject l_woObjects[ ]
//String l_cTabLabel
//Boolean l_bEnabled, l_bVisible
//u_folder l_fTabFolder
//
//IF IsValid( w_create_maintain_case ) THEN
//	i_wParentWindow = w_create_maintain_case
//	l_fTabFolder = I_wParentWindow.dw_folder
//	
//	//Initialize the demographics
//	fw_initdemographics ()
//	
//	//Populate the window objects array if tab 2(demographics) is instantiated
//	l_fTabFolder.fu_TabInfo( 2, l_cTabLabel, l_bEnabled, l_bVisible, l_woObjects[ ] )
//	
//	//If the demographics tab isn't instantiated, the upperbound of the array will
//	//  be zero.  Switch to the demographics tab to instantiate it, then retrieve initialize IIM
////	IF UpperBound( l_woObjects ) = 0 THEN
////		l_nSelectedTab = l_fTabFolder.i_SelectedTab
////		
////		l_fTabFolder.SetRedraw( FALSE )
////		l_fTabFolder.fu_SelectTab( 2 )
////		l_fTabFolder.fu_EnableTab( l_nSelectedTab )
////		l_fTabFolder.fu_SelectTab( l_nSelectedTab )
////		l_fTabFolder.SetRedraw( TRUE )
////	END IF
//	
//	IF NOT IsValid (i_uIIM) THEN
//		i_uIIM = CREATE u_iim
//	END IF
//	
//	IF w_create_maintain_case.i_cSourceType <> i_uIIM.i_cSourceType THEN
//		THIS.i_nCurrentPage = 1
//	ELSE
//		THIS.i_nCurrentPage = tab_folder.SelectedTab
//	END IF
//	
//	THIS.Event Trigger ue_InitIIM( )
//END IF
//
////Set the window options
//THIS.fw_SetOptions( THIS, c_ToolBarTop )
//
////Initialize the resize service
//THIS.of_SetResize( TRUE )
//
////Register the tab object and button with the service
//IF IsValid( THIS.inv_resize ) THEN
//	THIS.inv_resize.of_Register( tab_folder, THIS.inv_resize.SCALERIGHTBOTTOM )
//END IF
end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_close
   Purpose:    Clean up custom objects created for this container.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/26/2000 K. Claver   Created.
	3/19/2001 K. Claver   Added code to disable the sort button for create maintain case
								 as closing this window sometimes enables the button.
*****************************************************************************************/

INTEGER	l_nIndex, l_ntrCount

// clean up any defined transaction objects
l_ntrCount = upperbound (i_uIIM.i_trObjects[])
IF l_ntrCount > 0 THEN
	
	FOR l_nIndex = l_ntrCount TO 1 STEP -1
		
		DISCONNECT USING i_uIIM.i_trObjects[l_nIndex];
		DESTROY i_uIIM.i_trObjects[l_nIndex]
		
	NEXT
	
END IF

// clean up the IIM object
IF IsValid (i_uIIM) THEN
	DESTROY i_uIIM
END IF

//Disable the sort button for create maintain case
IF IsValid( w_create_maintain_case ) THEN
	IF w_create_maintain_case.dw_folder.i_SelectedTab = 5 THEN
		m_create_maintain_case.m_edit.m_sort.Enabled = FALSE
	END IF
END IF
end event

event open;call super::open;/*****************************************************************************************
   Event:      open
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/2001 K. Claver   Added code to wire the drag and drop if this window is opened when
								 on the case tab.
	3/16/2001 K. Claver   Added code to enable/disable the add note menu item depending on
								 what tab we are on in create maintain case.
	3/22/2001 K. Claver   Moved script to fw_initwindow function.
								 
*****************************************************************************************/
//IF IsValid( w_create_maintain_case ) THEN
//	IF w_create_maintain_case.dw_folder.i_SelectedTab = 5 THEN
//		tab_folder.Event Trigger ue_SetDragDrop( TRUE )
//		
//		m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = TRUE
//	ELSE
//		m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
//	END IF
//END IF
end event

event activate;call super::activate;/*****************************************************************************************
   Event:      activate
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/12/2001 K. Claver   Added code to only re-initialize the tabs when switch back to the
								 IIM tab window and the source has changed.
									 
*****************************************************************************************/
//Store the window state prior to calling the fu_InitWindow function as activating the window
//  by clicking on the title bar maximizes the window.  Need to be able to restore to its
//  prior state at the end of the fu_InitWindow function.
CHOOSE CASE THIS.WindowState
	CASE Maximized!
		THIS.i_cWindowState = "Maximized"
	CASE Minimized!
		THIS.i_cWindowState = "Minimized"
	CASE Normal!
		THIS.i_cWindowState = "Normal"
END CHOOSE

IF IsValid( THIS.i_wParentWindow ) THEN
	IF THIS.i_wParentWindow.i_cSourceType <> THIS.i_uIIM.i_cSourceType OR &
		THIS.i_wParentWindow.i_cCurrentCaseSubject <> THIS.i_uIIM.i_cCaseSubjectID THEN
		THIS.fw_InitWindow( )
	END IF
END IF
end event

type tab_folder from u_tab_std within w_iim_tabs
event ue_setdragdrop ( boolean a_bwiredrag )
integer x = 9
integer width = 3598
integer height = 1720
integer taborder = 10
integer textsize = -8
string facename = "Tahoma"
boolean fixedwidth = true
boolean raggedright = false
boolean boldselectedtext = true
alignment alignment = center!
end type

event ue_setdragdrop;/*****************************************************************************************
   Event:      ue_SetDragDrop
   Purpose:    Set the drag drop for the tabsheet datawindow
   Parameters: Boolean - a_bWireDrag - Wire or remove the drag drop functionality
	
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/2001 K. Claver   Created.
	
*****************************************************************************************/
Integer l_nIndex
u_iim_tab_page u_tpTabPage

FOR l_nIndex = 1 TO UpperBound( THIS.Control )
	IF TypeOf( THIS.Control[ l_nIndex ] ) = UserObject! THEN
		u_tpTabPage = THIS.Control[ l_nIndex ]
		
		IF IsValid( u_tpTabPage ) THEN
			IF u_tpTabPage.Enabled THEN
				u_tpTabPage.Event Trigger Dynamic ue_WireDrag( a_bWireDrag )
			END IF
		END IF
	END IF
NEXT
end event

event selectionchanging;/*****************************************************************************************
   Event:      selectionchanging
   Purpose:    Load the data for the new tab if not already done.
   Parameters: INTEGER	oldindex - The index of the currently selected tab
					INTEGER	newindex - The index of the tab that is about to be selected
   Returns:    LONG		0 - allow the selection to change
								1 - prevent the selection from changing

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/8/00   M. Caruso    Created.
	3/17/00  M. Caruso    Added the i_bConnected status flag to prevent loading of data
								 for tab pages with bad DSNs (no UID or PWD).
	3/20/00  M. Caruso    Added more detailed condition statements to determine if the
								 selected tab is connected to a database and disable a tab that
								 does not properly connected.
	4/3/00   M. Caruso    Modified code to acknowledge if the selected transaction object
								 is already connected.
	4/26/00  M. Caruso    Takes i_bPreload proeprty of the selected tab page into account
								 when determining whether or not to load data.
	6/12/00  M. Caruso    Make the Search prompt on the new tab visible if it has not been
								 loaded and the tab is not to be pre-loaded.
	6/13/00  M. Caruso    Set focus to a tab's datawindow when the tab is selected.
	7/14/00  M. Caruso    Hide the Search and No Data prompts if the tab was intentionally
								 left blank.
	8/16/2000 K. Claver	 Commented out disconnect when switching tabs as disconnecting
								 will break the retrieve as needed functionality.
	07/31/01 M. Caruso    Added code to enable the sort menu item as needed.
	3/5/2002 K. Claver    Added call to Yield function.  Explanation below.
*****************************************************************************************/
U_IIM_TAB_PAGE		l_uOldPage, l_uNewPage
U_DW_STD				l_dwDisplay
STRING				l_cCols[], l_cStyle

// only process if there are tabs defined
IF Upperbound (Control[]) > 0 THEN
	
	//Yield to ensure that the first tab datawindow is fully initialized before check
	//  if already built.  Necessary as the build summary folder function is posted
	//  in the ue_initiim event.
	Yield( )
	
	l_uNewPage = Control[newindex]
	
	//Build the summary datawindow if not already built
	IF NOT l_uNewPage.i_bAlreadyBuilt THEN
		l_uNewPage.i_uParentIIM.uf_BuildSummaryFolder( THIS, newindex )
	END IF
	
	// process the tab if it is not intentionally blank.
	IF NOT l_uNewPage.i_bBlank THEN
		
		IF oldindex > 0 THEN
			
			l_uOldPage = Control[oldindex]
			
			// Connect to the new transaction object if has changed and is not connected.
			IF l_uOldPage.i_nTrArrayIndex <> l_uNewPage.i_nTrArrayIndex THEN
				
				CHOOSE CASE l_uNewPage.i_nTrArrayIndex
					CASE IS > 0
						// If the selected trans object is not valid, do not connect.
						IF Match (i_uiim.i_trObjects[l_uNewPage.i_nTrArrayIndex].DBParm, "VOID") THEN
							i_bConnected = FALSE
						
						ELSE
							
							IF i_uiim.i_trObjects[l_uNewPage.i_nTrArrayIndex].SQLReturnData = "" THEN
	
								// if the selected trans object is not connected, try to connect.
								CONNECT USING i_uiim.i_trObjects[l_uNewPage.i_nTrArrayIndex];
								IF i_uiim.i_trObjects[l_uNewPage.i_nTrArrayIndex].SQLCode = 0 THEN
									i_bConnected = TRUE
								ELSE
									i_bConnected = FALSE
								END IF
							
							ELSE
							
								// the selected trans object is already connected, so use it.
								i_bConnected = TRUE
								
							END IF
							
						END IF
						
					CASE 0
						i_bConnected = TRUE
						
				END CHOOSE
			
			END IF
			
		ELSE
			
			CHOOSE CASE l_uNewPage.i_nTrArrayIndex
				CASE IS > 0
					IF Match (i_uiim.i_trObjects[l_uNewPage.i_nTrArrayIndex].DBParm, "VOID") THEN
						// If the selected trans object is not valid, do not connect.
						i_bConnected = FALSE
						
					ELSE
						
						IF i_uiim.i_trObjects[l_uNewPage.i_nTrArrayIndex].SQLReturnData = "" THEN
	
							// if the selected trans object is not connected, try to connect.
							CONNECT USING i_uiim.i_trObjects[l_uNewPage.i_nTrArrayIndex];
							IF i_uiim.i_trObjects[l_uNewPage.i_nTrArrayIndex].SQLCode = 0 THEN
								i_bConnected = TRUE
							ELSE
								i_bConnected = FALSE
							END IF
							
						ELSE
							// the selected trans object is already connected, so use it.
							i_bConnected = TRUE
							
						END IF
						
					END IF
					
				CASE 0
					i_bConnected = TRUE
					
			END CHOOSE
			
		END IF
		
		// only process if the datawindow has not already been loaded
		l_dwDisplay = l_uNewPage.dw_summary_view
		IF (NOT l_uNewPage.i_bLoaded) THEN
			
			IF l_uNewPage.i_bPreLoad THEN
			
				IF i_bConnected THEN
					IF l_dwDisplay.fu_Retrieve (l_dwDisplay.c_IgnoreChanges, l_dwDisplay.c_NoReselectRows) = 0 THEN
						l_uNewPage.i_bLoaded = TRUE
					END IF
				ELSE
					IF l_uNewPage.Enabled THEN
						messagebox (gs_AppName,'There is no data available for this tab page because~r~n' + &
															 'the database was not accessible. Please verify that~r~n' + &
															 'the username and password are correct.')
						l_uNewPage.Enabled = FALSE
					END IF
				END IF
				
			ELSE
				
				l_dwDisplay.Modify ("datawindow.Color='80269524'")
				l_uNewPage.st_searchprompt.visible = TRUE
				
			END IF
												
		END IF
		
		l_dwDisplay.SetFocus ()
		
	ELSE
		
		// hide the prompts on the tab...
		l_uNewPage.st_searchprompt.visible = FALSE
		l_uNewPage.st_nodataprompt.visible = FALSE
		
	END IF
	
	// Enable/disable "add notes" and "sort" as needed.
	l_dwDisplay = l_uNewPage.dw_summary_view
	IF IsValid( w_create_maintain_case ) THEN
		IF l_dwDisplay.RowCount( ) > 0 THEN
			IF w_create_maintain_case.dw_folder.i_SelectedTab = 5 THEN
				m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = TRUE
			ELSE
				m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			END IF
			m_iim_tabs.m_edit.m_sort.Enabled = TRUE
		ELSE
			m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			m_iim_tabs.m_edit.m_sort.Enabled = FALSE
		END IF
	ELSE
		m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
		m_iim_tabs.m_edit.m_sort.Enabled = FALSE
	END IF
	
ELSE
	// disable IIM related menu items/toolbar buttons if no tabs are defined.
	m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
	m_iim_tabs.m_edit.m_sort.Enabled = FALSE
END IF

RETURN 0
end event

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    See PB documentation for this event

   Revisions:
   Date     Developer    Description
	======== ============ =================================================================
	9/26/2000 K. Claver   Modified to initialize the resize service on the tab object.
*****************************************************************************************/
//Initialize the resize service
THIS.of_SetResize( TRUE )
end event

