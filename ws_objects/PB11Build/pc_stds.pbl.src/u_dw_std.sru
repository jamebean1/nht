$PBExportHeader$u_dw_std.sru
$PBExportComments$DataWindow standards
forward
global type u_dw_std from u_dw_main
end type
end forward

global type u_dw_std from u_dw_main
end type
global u_dw_std u_dw_std

type variables
// added 12/3/99 - Allows for typematic searching of DDDWs
CONSTANT STRING	c_NoDDDWSearch		= "170|"
CONSTANT STRING	c_DDDWSearch		= "171|"

BOOLEAN	i_DDDWSearch
end variables

forward prototypes
public subroutine fu_changeoptions (string options)
public function integer fu_updaterowstatus ()
end prototypes

public subroutine fu_changeoptions (string options);/****************************************************************************************
	Function      : fu_ChangeOptions
	Description   : Initializes or changes DataWindow options.

	Parameters    : STRING     Options -
                     Specifies options for how this DataWindow
                     is to behave.

	Return Value  : (None)

	Change History:

	Date     Person     Description of Change
	-------- ---------- ------------------------------------------------------------------
	12/3/99  M. Caruso  Replace the ancestor script to check for new properties.
****************************************************************************************/

IF options <> c_Default THEN

	//------------------------------------------------------------------
	//  Process the scroll option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_ScrollSelf) > 0 THEN
		i_ScrollParent = FALSE
	ELSEIF Pos(options, c_ScrollParent) > 0 THEN
		i_ScrollParent = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the instance option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_IsNotInstance) > 0 THEN
		i_IsInstance = FALSE
	ELSEIF Pos(options, c_IsInstance) > 0 THEN
		i_IsInstance = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the required checking option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_RequiredOnSave) > 0 THEN
		i_AlwaysCheckRequired = FALSE
	ELSEIF Pos(options, c_AlwaysCheckRequired) > 0 THEN
		i_AlwaysCheckRequired = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the new record option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoNew) > 0 THEN
		i_AllowNew = FALSE
	ELSEIF Pos(options, c_NewOK) > 0 THEN
		i_AllowNew = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the modify record option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoModify) > 0 THEN
		i_AllowModify = FALSE
	ELSEIF Pos(options, c_ModifyOK) > 0 THEN
		i_AllowModify = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the delete record option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoDelete) > 0 THEN
		i_AllowDelete = FALSE
	ELSEIF Pos(options, c_DeleteOK) > 0 THEN
		i_AllowDelete = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the delete saved record option.
	//------------------------------------------------------------------
	IF Pos(options, c_NoDeleteSaved) > 0 THEN
		i_AllowDeleteSaved = FALSE
	ELSEIF Pos(options, c_DeleteSavedOK) > 0 THEN
		i_AllowDeleteSaved = TRUE
	END IF

	
	//------------------------------------------------------------------
	//  Process the query mode option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoQuery) > 0 THEN
		i_AllowQuery = FALSE
	ELSEIF Pos(options, c_QueryOK) > 0 THEN
		i_AllowQuery = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the record selection method option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_SelectOnDoubleClick) > 0 THEN
		i_SelectMethod = c_SelectOnDoubleClick
	ELSEIF Pos(options, c_SelectOnClick) > 0 THEN
		i_SelectMethod = c_SelectOnClick
	ELSEIF Pos(options, c_SelectOnRowFocusChange) > 0 THEN
		i_SelectMethod = c_SelectOnRowFocusChange
	END IF
	
	//------------------------------------------------------------------
	//  Process the drill down option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoDrillDown) > 0 THEN
		i_AllowDrillDown = FALSE
	ELSEIF Pos(options, c_DrillDown) > 0 THEN
		i_AllowDrillDown = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the mode on select method option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_ParentModeOnSelect) > 0 THEN
		i_ModeOnSelect = c_ParentModeOnSelect
	ELSEIF Pos(options, c_ViewOnSelect) > 0 THEN
		i_ModeOnSelect = c_ViewOnSelect
	ELSEIF Pos(options, c_ModifyOnSelect) > 0 THEN
		i_ModeOnSelect = c_ModifyOnSelect
	ELSEIF Pos(options, c_SameModeOnSelect) > 0 THEN
		i_ModeOnSelect = c_SameModeOnSelect
	END IF
	
	//------------------------------------------------------------------
	//  Process the multi-select option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoMultiSelect) > 0 THEN
		i_MultiSelect = FALSE
	ELSEIF Pos(options, c_MultiSelect) > 0 THEN
		i_MultiSelect = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the mode on select method option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_RefreshOnSelect) > 0 THEN
		i_MultiSelectMethod = c_RefreshOnSelect
	ELSEIF Pos(options, c_NoAutoRefresh) > 0 THEN
		i_MultiSelectMethod = c_NoAutoRefresh
	ELSEIF Pos(options, c_RefreshOnMultiSelect) > 0 THEN
		i_MultiSelectMethod = c_RefreshOnMultiSelect
	END IF
	
	//------------------------------------------------------------------
	//  Process the mode on open method option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_ViewOnOpen) > 0 THEN
		i_ModeOnOpen = c_ViewOnOpen
	ELSEIF Pos(options, c_ModifyOnOpen) > 0 THEN
		i_ModeOnOpen = c_ModifyOnOpen
	ELSEIF Pos(options, c_NewOnOpen) > 0 THEN
		i_ModeOnOpen = c_NewOnOpen
	END IF
	
	//------------------------------------------------------------------
	//  Process the mode after save option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_SameModeAfterSave) > 0 THEN
		i_ViewAfterSave = FALSE
	ELSEIF Pos(options, c_ViewAfterSave) > 0 THEN
		i_ViewAfterSave = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the enable modify option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoEnableModifyOnOpen) > 0 THEN
		i_EnableModifyOnOpen = FALSE
	ELSEIF Pos(options, c_EnableModifyOnOpen) > 0 THEN
		i_EnableModifyOnOpen = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the enable new option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoEnableNewOnOpen) > 0 THEN
		i_EnableNewOnOpen = FALSE
	ELSEIF Pos(options, c_EnableNewOnOpen) > 0 THEN
		i_EnableNewOnOpen = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the retrieve on open option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_RetrieveOnOpen) > 0 OR &
		Pos(options, c_AutoRetrieveOnOpen) > 0 THEN
		i_RetrieveOnOpen = TRUE
	ELSEIF Pos(options, c_NoRetrieveOnOpen) > 0 THEN
		i_RetrieveOnOpen = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the retrieve as needed option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_RetrieveAll) > 0 THEN
		i_RetrieveAsNeeded = FALSE
	ELSEIF Pos(options, c_RetrieveAsNeeded) > 0 THEN
		i_RetrieveAsNeeded = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the share data option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoShareData) > 0 THEN
		i_ShareData = FALSE
	ELSEIF Pos(options, c_ShareData) > 0 THEN
		i_ShareData = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the refresh parent option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoRefreshParent) > 0 THEN
		i_RefreshParent = FALSE
	ELSEIF Pos(options, c_RefreshParent) > 0 THEN
		i_RefreshParent = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the refresh parent method option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_RefreshParentAuto) > 0 THEN
		i_RefreshParentRetrieve = FALSE
	ELSEIF Pos(options, c_RefreshParentReselect) > 0 THEN
		i_RefreshParentRetrieve = FALSE
	ELSEIF Pos(options, c_RefreshParentRetrieve) > 0 THEN
		i_RefreshParentRetrieve = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the refresh child option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoRefreshChild) > 0 THEN
		i_RefreshChild = FALSE
	ELSEIF Pos(options, c_RefreshChild) > 0 THEN
		i_RefreshChild = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the ignore new rows option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_IgnoreNewRows) > 0 THEN
		i_IgnoreNewRows = TRUE
	ELSEIF Pos(options, c_NoIgnoreNewRows) > 0 THEN
		i_IgnoreNewRows = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the new mode on empty option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoNewModeOnEmpty) > 0 THEN
		i_NewModeOnEmpty = FALSE
	ELSEIF Pos(options, c_NewModeOnEmpty) > 0 THEN
		i_NewModeOnEmpty = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the only one new row option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_MultipleNewRows) > 0 THEN
		i_OnlyOneNewRow = FALSE
	ELSEIF Pos(options, c_OnlyOneNewRow) > 0 THEN
		i_OnlyOneNewRow = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the concurrency checking option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_DisableCC) > 0 THEN
		i_EnableCC = FALSE
	ELSEIF Pos(options, c_EnableCC) > 0 THEN
		i_EnableCC = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the concurrency inserting option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_DisableCCInsert) > 0 THEN
		i_EnableCCInsert = FALSE
	ELSEIF Pos(options, c_EnableCCInsert) > 0 THEN
		i_EnableCCInsert = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the popup menu option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_EnablePopup) > 0 THEN
		i_EnablePopup = TRUE
	ELSEIF Pos(options, c_NoEnablePopup) > 0 THEN
		i_EnablePopup = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the view mode border option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_ViewModeBorderUnchanged) > 0 THEN
		i_ViewModeBorder = c_ViewModeBorderUnchanged
	ELSEIF Pos(options, c_ViewModeNoBorder) > 0 THEN
		i_ViewModeBorder = c_ViewModeNoBorder
	ELSEIF Pos(options, c_ViewModeShadowBox) > 0 THEN
		i_ViewModeBorder = c_ViewModeShadowBox
	ELSEIF Pos(options, c_ViewModeBox) > 0 THEN
		i_ViewModeBorder = c_ViewModeBox
	ELSEIF Pos(options, c_ViewModeResize) > 0 THEN
		i_ViewModeBorder = c_ViewModeResize
	ELSEIF Pos(options, c_ViewModeUnderline) > 0 THEN
		i_ViewModeBorder = c_ViewModeUnderline
	ELSEIF Pos(options, c_ViewModeLowered) > 0 THEN
		i_ViewModeBorder = c_ViewModeLowered
	ELSEIF Pos(options, c_ViewModeRaised) > 0 THEN
		i_ViewModeBorder = c_ViewModeRaised
	END IF
	
	//------------------------------------------------------------------
	//  Process the view mode color option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_ViewModeColorUnchanged) > 0 THEN
		SetNull(i_ViewModeColor) 
	ELSEIF Pos(options, c_ViewModeBlack) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_Black       
	ELSEIF Pos(options, c_ViewModeWhite) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_White       
	ELSEIF Pos(options, c_ViewModeGray) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_Gray       
	ELSEIF Pos(options, c_ViewModeDarkGray) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_DarkGray       
	ELSEIF Pos(options, c_ViewModeRed) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_Red       
	ELSEIF Pos(options, c_ViewModeDarkRed) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_DarkRed       
	ELSEIF Pos(options, c_ViewModeGreen) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_Green       
	ELSEIF Pos(options, c_ViewModeDarkGreen) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_DarkGreen      
	ELSEIF Pos(options, c_ViewModeBlue) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_Blue       
	ELSEIF Pos(options, c_ViewModeDarkBlue) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_DarkBlue       
	ELSEIF Pos(options, c_ViewModeMagenta) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_Magenta       
	ELSEIF Pos(options, c_ViewModeDarkMagenta) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_DarkMagenta       
	ELSEIF Pos(options, c_ViewModeCyan) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_Cyan       
	ELSEIF Pos(options, c_ViewModeDarkCyan) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_DarkCyan       
	ELSEIF Pos(options, c_ViewModeYellow) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_Yellow       
	ELSEIF Pos(options, c_ViewModeBrown) > 0 THEN
		i_ViewModeColor = OBJCA.MGR.c_DarkYellow       
	END IF
	
	//------------------------------------------------------------------
	//  Process the inactive color option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_InactiveColorUnchanged) > 0 THEN
		SetNull(i_InactiveColor) 
	ELSEIF Pos(options, c_InactiveBlack) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_Black       
	ELSEIF Pos(options, c_InactiveWhite) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_White       
	ELSEIF Pos(options, c_InactiveGray) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_Gray       
	ELSEIF Pos(options, c_InactiveDarkGray) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_DarkGray       
	ELSEIF Pos(options, c_InactiveRed) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_Red       
	ELSEIF Pos(options, c_InactiveDarkRed) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_DarkRed       
	ELSEIF Pos(options, c_InactiveGreen) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_Green       
	ELSEIF Pos(options, c_InactiveDarkGreen) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_DarkGreen      
	ELSEIF Pos(options, c_InactiveBlue) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_Blue       
	ELSEIF Pos(options, c_InactiveDarkBlue) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_DarkBlue       
	ELSEIF Pos(options, c_InactiveMagenta) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_Magenta       
	ELSEIF Pos(options, c_InactiveDarkMagenta) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_DarkMagenta       
	ELSEIF Pos(options, c_InactiveCyan) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_Cyan       
	ELSEIF Pos(options, c_InactiveDarkCyan) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_DarkCyan       
	ELSEIF Pos(options, c_InactiveYellow) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_Yellow       
	ELSEIF Pos(options, c_InactiveBrown) > 0 THEN
		i_InactiveColor = OBJCA.MGR.c_DarkYellow       
	END IF
	
	//------------------------------------------------------------------
	//  Process the inactive text option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_InactiveText) > 0 THEN
		i_InactiveText = TRUE
	ELSEIF Pos(options, c_NoInactiveText) > 0 THEN
		i_InactiveText = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the inactive line option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_InactiveLine) > 0 THEN
		i_InactiveLine = TRUE
	ELSEIF Pos(options, c_NoInactiveLine) > 0 THEN
		i_InactiveLine = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the inactive column option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_InactiveCol) > 0 THEN
		i_InactiveCol = TRUE
	ELSEIF Pos(options, c_NoInactiveCol) > 0 THEN
		i_InactiveCol = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the focus rectangle display option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_ActiveRowPointer) > 0 THEN
		i_ActiveRowPointer = TRUE
	ELSEIF Pos(options, c_NoActiveRowPointer) > 0 THEN
		i_ActiveRowPointer = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the pointer display option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_InactiveRowPointer) > 0 THEN
		i_InactiveRowPointer = TRUE
	ELSEIF Pos(options, c_NoInactiveRowPointer) > 0 THEN
		i_InactiveRowPointer = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the presentation style option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_CalculateStyle) > 0 THEN
		i_PresentationStyle = c_CalculateStyle
	ELSEIF Pos(options, c_FreeFormStyle) > 0 THEN
		i_PresentationStyle = c_FreeFormStyle
	ELSEIF Pos(options, c_TabularFormStyle) > 0 THEN
		i_PresentationStyle = c_TabularFormStyle
	END IF
	
	//------------------------------------------------------------------
	//  Process the highlight method option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_CalculateHighlight) > 0 THEN
		i_HighlightMethod = c_CalculateHighlight
	ELSEIF Pos(options, c_ShowHighlight) > 0 THEN
		i_HighlightMethod = c_ShowHighlight
	ELSEIF Pos(options, c_HideHighlight) > 0 THEN
		i_HighlightMethod = c_HideHighlight
	END IF
	
	//------------------------------------------------------------------
	//  Process the menu/button activation option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_MenuButtonActivation) > 0 THEN
		i_MenuButtonActivation = TRUE
	ELSEIF Pos(options, c_NoMenuButtonActivation) > 0 THEN
		i_MenuButtonActivation = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the auto configure the menus option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_NoAutoConfigMenus) > 0 THEN
		i_AutoConfigMenus = FALSE
	ELSEIF Pos(options, c_AutoConfigMenus) > 0 THEN
		i_AutoConfigMenus = TRUE
	END IF
	
	//------------------------------------------------------------------
	//  Process the show empty option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_ShowEmpty) > 0 THEN
		i_ShowEmpty = TRUE
	ELSEIF Pos(options, c_NoShowEmpty) > 0 THEN
		i_ShowEmpty = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the auto focus option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_AutoFocus) > 0 THEN
		i_AutoFocus = TRUE
	ELSEIF Pos(options, c_NoAutoFocus) > 0 THEN
		i_AutoFocus = FALSE
	END IF
	
	//------------------------------------------------------------------
	//  Process the concurrency error box color option.
	//------------------------------------------------------------------
	
	IF Pos(options, c_CCErrorBlack) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_Black       
	ELSEIF Pos(options, c_CCErrorWhite) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_White       
	ELSEIF Pos(options, c_CCErrorGray) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_Gray       
	ELSEIF Pos(options, c_CCErrorDarkGray) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_DarkGray       
	ELSEIF Pos(options, c_CCErrorRed) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_Red       
	ELSEIF Pos(options, c_CCErrorDarkRed) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_DarkRed       
	ELSEIF Pos(options, c_CCErrorGreen) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_Green       
	ELSEIF Pos(options, c_CCErrorDarkGreen) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_DarkGreen      
	ELSEIF Pos(options, c_CCErrorBlue) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_Blue       
	ELSEIF Pos(options, c_CCErrorDarkBlue) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_DarkBlue       
	ELSEIF Pos(options, c_CCErrorMagenta) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_Magenta       
	ELSEIF Pos(options, c_CCErrorDarkMagenta) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_DarkMagenta       
	ELSEIF Pos(options, c_CCErrorCyan) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_Cyan       
	ELSEIF Pos(options, c_CCErrorDarkCyan) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_DarkCyan       
	ELSEIF Pos(options, c_CCErrorYellow) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_Yellow       
	ELSEIF Pos(options, c_CCErrorBrown) > 0 THEN
		i_CCErrorColor = OBJCA.MGR.c_DarkYellow       
	END IF

END IF

//------------------------------------------------------------------
//  Process the drag rows option.
//------------------------------------------------------------------

IF Pos(options, c_DragOK) > 0 THEN
	i_AllowDrag = TRUE
ELSEIF Pos(options, c_NoDrag) > 0 THEN
	i_AllowDrag = FALSE
END IF

//------------------------------------------------------------------
//  Process the drop rows option.
//------------------------------------------------------------------

IF Pos(options, c_DropOK) > 0 THEN
	i_AllowDrop = TRUE
ELSEIF Pos(options, c_NoDrop) > 0 THEN
	i_AllowDrop = FALSE
END IF

//------------------------------------------------------------------
//  Process the copy rows option.
//------------------------------------------------------------------

IF Pos(options, c_CopyOK) > 0 THEN
	i_AllowCopy = TRUE
ELSEIF Pos(options, c_NoCopy) > 0 THEN
	i_AllowCopy = FALSE
END IF

//------------------------------------------------------------------
//  Process the DDDW find option.
//------------------------------------------------------------------

IF Pos(options, c_DDDWFind) > 0 THEN
	i_DDDWFind = TRUE
ELSEIF Pos(options, c_NoDDDWFind) > 0 THEN
	i_DDDWFind = FALSE
END IF

//------------------------------------------------------------------
//  Process the DDDW search option.
//------------------------------------------------------------------

IF (Pos(options, c_DDDWSearch) > 0) AND (i_DDDWFind = FALSE) THEN
	i_DDDWSearch = TRUE
ELSEIF Pos(options, c_NoDDDWSearch) > 0 THEN
	i_DDDWSearch = FALSE
END IF

//------------------------------------------------------------------
//  Process the sort on clicked option.
//------------------------------------------------------------------

IF Pos(options, c_SortClickedOK) > 0 THEN
	i_AllowSortClicked = TRUE
ELSEIF Pos(options, c_NOSortClicked) > 0 THEN
	i_AllowSortClicked = FALSE
END IF

//------------------------------------------------------------------
//  Calculate DataWindow variables and create services based on the
//  options.
//------------------------------------------------------------------

fu_CalcOptions()
end subroutine

public function integer fu_updaterowstatus ();/*****************************************************************************************
   Function:   fu_UpdateRowStatus
   Purpose:    Ensure that the current row status is correct.
   Parameters: NONE
   Returns:    INTEGER	1 - success
							  -1 - failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/05/02 M. Caruso    Created.
*****************************************************************************************/

BOOLEAN			l_bModified
INTEGER			l_nColCount, l_nIndex
LONG				l_nRow
DWItemStatus	l_dwiStatus

l_bModified = FALSE

l_nRow = THIS.GetRow ()
l_nColCount = INTEGER (THIS.Object.DataWindow.Column.Count)
FOR l_nIndex = 1 TO l_nColCount
	
	l_dwiStatus = THIS.GetItemStatus (l_nRow, l_nIndex, Primary!)
	CHOOSE CASE l_dwiStatus
		CASE NewModified!, DataModified!
			l_bModified = TRUE
			EXIT
			
	END CHOOSE
	
NEXT

IF NOT l_bModified THEN
	RETURN THIS.SetItemStatus (l_nRow, 0, Primary!, NotModified!)
ELSE
	RETURN 1
END IF
end function

event pcd_validaterow;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_ValidateRow
////  Description   : Provides the opportunity for the developer to
////                  write code to cross-validate DataWindow
////                  fields.
////
////  Parameters    : BOOLEAN In_Save -
////            	        Can be used by the developer to prevent
////                     validation checking if this event was not
////                     triggered by the save process.
////                  LONG    Row_Nbr -
////                     The row that is being validated.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  The following sample code illustrates cross-validation
////  between two columns on a row.
////------------------------------------------------------------------
//
////STRING l_BeginZip, l_EndZip, l_ErrMsg
////
////l_BeginZip = GetItemString(row_nbr, "begin_zip")
////l_EndZip   = GetItemString(row_nbr, "end_zip")
////
////IF Integer(l_BeginZip) > Integer(L_EndZip) THEN
////   l_ErrMsg = "The beginning zip code (" + l_BeginZip + &
////               ") must be less than or equal to the ending " + &
////               "zip code (" + l_EndZip + ")."
////   fu_DisplayValError("ValDevOKError", l_ErrMsg)
////   Error.i_FWError = c_Fatal
////END IF
//
end event

event pcd_pickedrow;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_PickedRow
////  Description   : Opens child windows, if necessary.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Open the window or refresh it using the FWCA.MGR.fu_OpenWindow()
////  function.  The parameters for this function are:
////
////     WINDOW  <window_name> -
////        Name of the window to open.
////     INTEGER <menu_bar_number> -
////        Number of the menu item (in the menu associated
////        with the window) to which you want to append the
////        name of the open window.  The item in the menu
////        bar that is typically used is "Window".
////------------------------------------------------------------------
//
////FWCA.MGR.fu_OpenWindow(<window_name>, <menu_bar_number>)
//
////------------------------------------------------------------------
////  To open multiple instances of a window you also use the
////  FWCA.MGR.fu_OpenWindow() function, but for the <window_name> 
////  parameter, pass a variable of the type of window you wish to 
////  open.
////------------------------------------------------------------------
//
////<window_name> l_Window
////
////FWCA.MGR.fu_OpenWindow(l_Window, <menu_bar_number>)
//
end event

event pcd_concurrency;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_Concurrency
////  Description   : Provides an event for the developer
////                  to do error processing when there
////                  is a concurrency error when updating
////                  the database
////
////  Parameters    : INTEGER      Num_Errors -
////                     Number of times a concurrency error has been
////                     encountered during UPDATE().
////
////                  INTEGER      Num_Error_Rows -
////                     Number of rows with concurrency errors.
////
////                  INTEGER      Num_Error_Cols -
////                     Number of columns with concurrency errors.
////
////                  INTEGER      Row_Error_Code -
////                     Identifies the type of concurrency error that
////                     has occurred in the row.  Possible values
////                     are:
////
////                        c_CCErrorNonOverlap -
////                           There are one or more columns which
////                           have been updated in the database, but 
////                           were not modified in this DataWindow.
////                        c_CCErrorOverlap -
////                           There are one or more columns which 
////                           have been updated in this DataWindow 
////                           and in the database.  There also may be
////                           columns which have been updated in the 
////                           database, but not in this DataWindow 
////                           (i.e. c_CCErrorNonOverlap errors).
////                        c_CCErrorNonExistent -
////                           The row has been modified in the 
////                           DataWindow, but the row has been 
////                           deleted from the database by another 
////                           user.
////                        c_CCErrorDeleteModified -
////                           The row has been modified in the 
////                           database by another user, but the row 
////                           has been deleted from the DataWindow.
////                        c_CCErrorKeyConflict -
////                           The row that is being updated contains
////                           keys which are not unique in the 
////                           database.
////
////                  DWITEMSTATUS Row_Status -
////                     The status of the row in the DataWindow.  
////                     This value is the same for all of the 
////                     columns.
////
////                  INTEGER      Num_Cols -
////                     Number of columns in the DataWindow.
////
////                  STRING       Col_Name[] -
////                     The name of columns in the DataWindow.
////
////                  BOOLEAN      Col_Update[] -
////                     Indicates if this column is being updated
////                     to the database.
////
////                  INTEGER      Col_Error_Code[] -
////                     Identifies the type of concurrency error that
////                     has occurred in the column.  Possible values
////                     are:
////
////                        c_CCErrorNone -
////                           No concurrency errors were detected in
////                           this column.
////                        c_CCErrorNonOverlap -
////                           This column has been updated in the
////                           database, but was not modified in this
////                           DataWindow.
////                        c_CCErrorOverlap -
////                           This column has been updated in this
////                           DataWindow and in the database.
////                        c_CCErrorOverlapMatch -
////                           This is basically the same as
////                           c_CCErrorOverlap except that what has
////                           been entered into the column in the
////                           DataWindow matches the new value that
////                           is in the database.
////                        c_CCErrorNonExistent -
////                           This column is in a row that has been
////                           modified in the DataWindow, but the
////                           row has been deleted from the database
////                           by another user.
////                        c_CCErrorDeleteModified -
////                           This column is in a row that has been
////                           modified in the database by another
////                           user, but the row has been deleted from
////                           the DataWindow.
////                        c_CCErrorKeyConflict -
////                           This column is in row that is being
////                           updated but contains keys which are
////                           not unique in the database.
////
////                  DWITEMSTATUS Column_Status[] -
////                     The status of the columns in the DataWindow.
////
////                  STRING       Col_Old_Value[] -
////                     The original value of the column when it
////                     was retrieved from the database.
////
////                  STRING       Col_New_Value[] -
////                     The value of the column as it now exists in
////                     the database.  If the row has been deleted
////                     from the database by another user, this value
////                     will be NULL.
////
////                  STRING       Col_DW_Value[] -
////                     The current value of the column in the
////                     DataWindow.  If the user has not modified
////                     it, it will be the same as Col_Old_Value[]
////                     member.
////
////                  The following values can be set by the developer
////                  to tell PowerClass how to process the 
////                  concurrency error.
////
////                  STRING       User_Name -
////                     If the DataWindow has a column that contains 
////                     the last user who modified the row, the 
////                     developer can tell PowerClass who that user 
////                     was so that the user's name will be displayed
////                     in informational messages.
////
////                  INTEGER      Row_Method -
////                     Set by the developer for row-level 
////                     concurrency errors to tell PowerClass if the
////                     user is to decide how to handle the 
////                     concurrency error.  Possible values are:
////
////                        c_CCMethodNone -
////                           The user does not get an opportunity to
////                           decide how the concurrency error is to 
////                           be handled.
////                        c_CCMethodSpecify -
////                            The user is to decide how the 
////                            concurrency error is to be handled.
////
////                  INTEGER      Row_Value -
////                     Set by the developer for row-level concurrency
////                     errors to tell PowerClass how to handle the
////                     concurrency error.  Note that this is only
////                     applicable if the developer requested that the
////                     user was NOT to decide how to handle the
////                     concurrency error.  Possible values are:
////
////                        c_CCUseOldDB -
////                           For c_CCErrorNonExistent errors:
////                              The original row that was read from 
////                              the database will be reinserted into
////                              the database.
////
////                           For c_CCErrorDeleteModified errors:
////                              The row will be deleted from the
////                              database.
////
////                        c_CCUseNewDB -
////                           For c_CCErrorNonExistent errors:
////                              The row will be removed from the
////                              DataWindow and the row will remain
////                              deleted in the database.
////
////                           For c_CCErrorDeleteModified errors:
////                              The row will be restored from the
////                              database into the DataWindow.  The
////                              row will be left in the database.
////
////                        c_CCUseDWValue -
////                           For c_CCErrorNonExistent errors:
////                              The row in the DataWindow will be
////                              reinserted into the database with
////                              any modifications made by the user.
////
////                           For c_CCErrorDeleteModified errors:
////                              The row will be deleted from the
////                              database.
////
////                        c_CCUseSpecial -
////                           For c_CCErrorNonExistent errors:
////                              Note: This is not generally useful.
////                              The row in the DataWindow will be
////                              reinserted into the database.  
////                              Values for all of the columns must 
////                              be specified by the developer in
////                              Col_Special[].
////
////                           For c_CCErrorDeleteModified errors:
////                              The row will be deleted from the
////                              database.
////
////                  INTEGER      Val_Method -
////                     Set by the developer to tell PowerClass what
////                     level of validation should be performed after
////                     the concurrency error has been fixed.
////                     Possible Values are:
////
////                        c_CCValidateNone -
////                           PowerClass is not to do any validation 
////                           on the row.
////                        c_CCValidateRow -
////                           PowerClass is to validate the row by
////                           triggering pcd_ValidateRow.
////                        c_CCValidateAll -
////                           PowerClass is to validate all of the
////                           columns and the row.
////
////                  INTEGER      Col_Method[] -
////                     Tells PowerClass how to fix column-level
////                     concurrency errors.  Possible values are:
////
////                        c_CCMethodNone -
////                           The user does not get an opportunity
////                           to decide how the concurrency error
////                           for this column is to be handled.
////
////                        c_CCMethodSpecify -
////                           The user is to decide how the
////                           concurrency error for this column
////                           is to be handled.
////
////                  INTEGER      Col_Value[] -
////                     This variable specifies to PowerClass which
////                     value is to be sent to the database.  If the
////                     developer has specified c_CCMethodSpecify for
////                     the Col_Method[], then this variable provides
////                     the default choice for the user.  Possible
////                     values are:
////
////                        c_CCUseOldDB -
////                           The original value from the database is
////                           to be sent to the database (if it is
////                           different from what is already there).
////
////                        c_CCUseNewDB -
////                           The current value in the database
////                           will remain in the database as is
////                           and will be placed into this column
////                           in the DataWindow.
////
////                        c_CCUseDWValue -
////                           The current value in the DataWindow,
////                           as modified by the user, is to be
////                           sent to the database.
////
////                        c_CCUseSpecial -
////                           The value specified by the developer
////                           in the Col_Special[] member is to be 
////                           sent to the database.
////
////                  STRING       Col_Special[] -
////                     This variable is to be used by the developer
////                     to specify what value is to be sent to the
////                     database.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1995-1996.  All Rights Reserved.
////******************************************************************
//
//INTEGER  l_ModifyByCol, l_EmpIDCol, l_Idx
//REAL     l_Increment
//
////------------------------------------------------------------------
////  Check what type of error occurred.
////------------------------------------------------------------------
//
//CHOOSE CASE row_error_code
//
//   //---------------------------------------------------------------
//   //  The row has been modified in the database and by the user.
//   //  This type of error is a column-level concurrency error.
//   //---------------------------------------------------------------
//
//   CASE c_CCErrorNonOverlap, &
//        c_CCErrorOverlap,    &
//        c_CCErrorOverlapMatch
//
//      //------------------------------------------------------------
//      //  Step through all of the columns, looking for the
//      //  concurrency errors.
//      //------------------------------------------------------------
//
//      FOR l_Idx = 1 to num_cols
//
//         //---------------------------------------------------------
//         //  If Col_Error_Code is c_CCErrorNone, then there was not
//			//  a concurrency error on this column.
//         //---------------------------------------------------------
//
//         IF col_error_code[l_Idx] <> c_CCErrorNone THEN
//
//            //------------------------------------------------------
//            //  There was a concurrency error on this column.
//            //  Based on the column that contained the error,
//            //  we'll do different things to handle the error.
//            //------------------------------------------------------
//
//            CHOOSE CASE col_name[l_Idx]
//
//               //---------------------------------------------------
//               //  For the column "salary" we want to keep a
//               //  running total of everything that has been
//               //  added to this column.  To do this, we need
//               //  to find how much the user added since the
//               //  value was retrieved from the database and
//               //  then add that to the current total in the
//               //  database.  User intervention will not be
//               //  required since everything can be calculated.
//               //  Set Col_Special[] for this column to contain
//               //  the new running total and set Col_Value[]
//               //  to tell PowerClass to use it instead of the
//               //  database or DataWindow values.
//               //---------------------------------------------------
//
//               CASE "salary"
//
//                  //------------------------------------------------
//                  //  Calculate how much the user added.
//                  //------------------------------------------------
//
//                  l_Increment =                       &
//                     Real(col_dw_value[l_Idx]) - &
//                     Real(col_old_value[l_Idx])
//
//                  //------------------------------------------------
//                  //  Add the user's increment to the current
//                  //  value in the database.
//                  //------------------------------------------------
//
//                  col_special[l_Idx] =              &
//                     String(Real(col_new_value[l_Idx]) + l_Increment)
//
//                  //------------------------------------------------
//                  //  Tell PowerClass to use the value specified
//                  //  in the Col_Special[] variable.
//                  //------------------------------------------------
//
//                  col_value[l_Idx] = c_CCUseSpecial
//
//               //---------------------------------------------------
//               //  For the column "emp_fname" we always want to
//               //  use the name typed in by the user.
//               //---------------------------------------------------
//
//               CASE "emp_fname"
//
//                  //------------------------------------------------
//                  //  Tell PowerClass to use the value in the
//                  //  DataWindow.
//                  //------------------------------------------------
//
//                  col_value[l_Idx] = c_CCUseDWValue
//
//               //---------------------------------------------------
//               //  For the column "emp_lname" we always want to
//               //  use the name from the database.
//               //---------------------------------------------------
//
//               CASE "emp_lname"
//
//                  //------------------------------------------------
//                  //  Tell PowerClass to use the new value from
//                  //  the database.
//                  //------------------------------------------------
//
//                  col_value[l_Idx] = c_CCUseNewDB
//
//               CASE ELSE
//
//                  //------------------------------------------------
//                  //  For all other columns, let the user decide
//                  //  how to handle the concurrency error.
//                  //------------------------------------------------
//
//                  col_method[l_Idx] = c_CCMethodSpecify
//
//            END CHOOSE
//         END IF
//      NEXT
//
//
//   //---------------------------------------------------------------
//   //  The update failed because there was a key that was
//   //  not unique.  This type of error is a column-level
//   //  concurrency error.
//   //---------------------------------------------------------------
//
//   CASE c_CCErrorKeyConflict
//
//       //-----------------------------------------------------------
//       //  For the sample database, "emp_id" is the key column
//       //  and must be unique.  We'll tell PowerClass to set it
//       //  back to NULL.  For c_CCErrorKeyConflict errors,
//       //  PowerClass will trigger the pcd_SetKey event again.
//       //  The sample code for pcd_SetKey sets keys into all
//       //  columns which are NULL, so this row will get a new
//       //  key.  PowerClass will then trigger pcd_Update to
//       //  attempt to update it to the database again.
//       //-----------------------------------------------------------
//
//       l_EmpIDCol = Integer(Describe("emp_id.id"))
//       SetNull(col_special[l_EmpIDCol])
//       col_value[l_EmpIDCol] = c_CCUseSpecial
//
//   //---------------------------------------------------------------
//   //  The row has been modified by the user, but has been
//   //  deleted from the database by another user.  This type
//   //  of error is a row-level concurrency error.
//   //---------------------------------------------------------------
//
//   CASE c_CCErrorNonExistent
//
//      //------------------------------------------------------------
//      //  Use one of the following to process
//      //  c_CCErrorNonExistent errors:
//      //------------------------------------------------------------
//
//      //------------------------------------------------------------
//      //  a.) Do the following to let the user decide how to
//      //      handle the concurrency error.
//      //------------------------------------------------------------
//
//      row_method = c_CCMethodSpecify
//
//      //------------------------------------------------------------
//      //  b.) Do the following to add the row back into the
//      //      database.
//      //------------------------------------------------------------
//
//      row_value = c_CCUseDWValue
//
//      //------------------------------------------------------------
//      //  c.) Do the following to leave the row deleted from
//      //      the database.
//      //------------------------------------------------------------
//
//      row_value = c_CCUseNewDB
//
//   //---------------------------------------------------------------
//   //  The row has been deleted by the user, but has been
//   //  modifed in the database by another user.  This type
//   //  of error is a row-level concurrency error.
//   //---------------------------------------------------------------
//
//   CASE c_CCErrorDeleteModified
//
//      //------------------------------------------------------------
//      //  Use one of the following to process
//      //  c_CCErrorDeleteModified errors:
//      //------------------------------------------------------------
//
//      //------------------------------------------------------------
//      //  a.) Do the following to let the user decide how to
//      //      handle the concurrency error.
//      //------------------------------------------------------------
//
//      row_method = c_CCMethodSpecify
//
//      //------------------------------------------------------------
//      //  b.) Do the following to delete the row from the
//      //      database.
//      //------------------------------------------------------------
//
//      row_value = c_CCUseDWValue
//
//      //------------------------------------------------------------
//      //  c.) Do the following to leave the row in the database
//      //      and retrieve the modified row into the DataWindow.
//      //------------------------------------------------------------
//
//      row_value = c_CCUseNewDB
//
//   CASE ELSE
//END CHOOSE
end event

event pcd_retrieve;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_Retrieve
////  Description   : Retrieve data from the database for this
////                  DataWindow.
////
////  Parameters    : DATAWINDOW Parent_DW -
////            	        Parent of this DataWindow.  If this 
////                     DataWindow is root-level, this value will
////                     be NULL.
////                  LONG       Num_Selected -
////                     The number of selected records in the
////                     parent DataWindow.
////                  LONG       Selected_Rows[] -
////                     The row numbers of the selected records
////                     in the parent DataWindow.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  If this DataWindow does not have a parent DataWindow, then
////  the following sample code may be all that you need.
////------------------------------------------------------------------
//
////LONG l_Rtn
////
////l_Rtn = Retrieve()
////
////IF l_Rtn < 0 THEN
////   Error.i_FWError = c_Fatal
////END IF
//
////------------------------------------------------------------------
////  If this DataWindow has a parent DataWindow, this example gets
////  the selected record from the parent when only one record can
////  be selected.
////------------------------------------------------------------------
//
////LONG l_Rtn, l_Selected
////
////l_Selected = parent_dw.GetItemNumber(selected_rows[1], "<column>")
////
////l_Rtn = Retrieve(l_Selected)
////
////IF l_Rtn < 0 THEN
////   Error.i_FWError = c_Fatal
////END IF
//
////------------------------------------------------------------------
////  If the parent does allow multi-selects, then the following
////  code can be used for the retrieve.
////------------------------------------------------------------------
//
////LONG l_Rtn, l_Idx, l_Selected[]
////
////FOR l_Idx = 1 TO num_selected
////   l_Selected[l_Idx] = parent_dw.GetItemNumber(selected_rows[l_Idx], &
////                                               "<column>")
////NEXT
////
////l_Rtn = Retrieve(l_Selected[])
////
////IF l_Rtn < 0 THEN
////   Error.i_FWError = c_Fatal
////END IF
//
end event

event pcd_setkey;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_SetKey
////  Description   : Provide the opportunity for the developer
////                  to set record keys for new rows in the
////                  DataWindow.  This event will only be
////                  triggered if new records have been added
////                  in this DataWindow.
////
////  Parameters    : TRANSACTION Transaction_Object -
////            	        Transaction object for this DataWindow.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code to get a unique number for a key column before
////  the DataWindow is updated to the database.  The initial value
////  for the key column was set to NULL.  This allows the program
////  to determine which rows had values for the keys and which
////  didn't.
////------------------------------------------------------------------
//
////LONG l_UniqueSeq, l_Idx, l_RowCount, l_KeyValue
////
////SELECT Max(<keycolumn>) INTO :l_UniqueSeq FROM <table>;
////IF IsNull(l_UniqueSeq) THEN
////   l_UniqueSeq = 0
////END IF
////
////l_RowCount = RowCount()
////FOR l_Idx = 1 TO l_RowCount
////   l_KeyValue = GetItemNumber(l_Idx, "<keycolumn>")
////   IF l_KeyValue = 0 OR IsNull(l_KeyValue) THEN
////      l_UniqueSeq = l_UniqueSeq + 1
////      SetItem(l_Idx, "<keycolumn>", l_UniqueSeq)
////   END IF
////NEXT
//
////------------------------------------------------------------------
////  Basically the same code as the previous sample, except that
////  it does not set keys for empty New! rows.
////------------------------------------------------------------------
//
////LONG          l_UniqueSeq, l_Idx, l_RowCount, l_KeyValue
////DWITEMSTATUS  l_ItemStatus
////
////SELECT Max(<keycolumn>) INTO :l_UniqueSeq FROM <table>;
////IF IsNull(l_UniqueSeq) THEN
////   l_UniqueSeq = 0
////END IF
////
////l_RowCount = RowCount()
////FOR l_Idx = 1 TO l_RowCount
////   l_KeyValue = GetItemNumber(l_Idx, "<keycolumn>")
////   IF l_KeyValue = 0 OR IsNull(l_KeyValue) THEN
////      l_ItemStatus = GetItemStatus(l_Idx, 0, Primary!)
////      IF l_ItemStatus <> New! THEN
////         l_UniqueSeq = l_UniqueSeq + 1
////         SetItem(l_Idx, "<keycolumn>", l_UniqueSeq)
////      END IF
////   END IF
////NEXT
//
end event

event pcd_update;call super::pcd_update;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_Update
////  Description   : Update the DataWindow rows to the database.
////
////  Parameters    : TRANSACTION Transaction_Object -
////            	        Transaction object for this DataWindow.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
//STRING 			l_cCommand
//INT    			l_nReturn
//TRANSACTION		l_txnSave
//
//CHOOSE CASE transaction_object.DBMS
//
//	CASE 'SYB','SYC'
//
//		l_cCommand = 'BEGIN TRANSACTION'
//		EXECUTE IMMEDIATE :l_cCommand USING transaction_object;
//
//		IF transaction_object.SQLCode <> 0 THEN
//			MessageBox('No go', 'Begin SQLCode = ' + STRING(transaction_object.SQLCode))
//			Error.i_FWError = c_Fatal
//		END IF
//
//		l_nReturn = Update(FALSE, FALSE)
//
//		IF l_nReturn = 1 THEN
//			l_cCommand = 'COMMIT TRANSACTION'
//			EXECUTE IMMEDIATE :l_cCommand USING transaction_object;
//	
//			IF transaction_object.SQLCODE <> 0 THEN
//				MessageBox('Oopps', 'COMMIT SQLCode = ' + STRING(transaction_object.SQLCODE))
//				Error.i_FWError = c_Fatal
//			END IF
//		ELSE
//			l_txnSave = CREATE TRANSACTION
//			l_txnSave = SQLCA
//	
//			l_cCommand = 'ROLLBACK TRANSACTION'
//			EXECUTE IMMEDIATE :l_cCommand USING transaction_object;
//	
//			IF transaction_object.SQLCODE <> 0 THEN
//				MessageBox('Uh-uh', 'ROLLBACK SQLCode = ' + STRING(transaction_object.SQLCODE))
//				Error.i_FWError = c_Fatal
//			END IF
//
//			MessageBox('oops No Update', 'Update failed SQLCOde = ' + STRING (l_txnSave.SQLCODE))
//			DESTROY l_txnSave
//		END IF 
//
//	CASE 'ODBC'
//
//		IF IsNull(transaction_object) THEN
//   		GOTO Finished
//		END IF
//
//		//----------
//		//  Use the PowerBuilder UPDATE() function to update the rows to
//		//  the database.
//		//----------
//
//		l_nReturn = Update(FALSE, FALSE)
//
//		//----------
//		//  Check for errors that occurred during the UPDATE().
//		//----------
//
//		IF l_nReturn <> 1 THEN
//		   Error.i_FWError = c_Fatal
//			GOTO Finished
//		END IF
//
//		Finished:
//
//END CHOOSE
//
//	
end event

event pcd_validateafter;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_ValidateAfter
////  Description   : Provide the opportunity for the developer
////                  to do things after validiation has been run
////                  on this DataWindow. 
////
////  Parameters    : BOOLEAN In_Save -
////            	        Can be used by the developer to prevent
////                     validation checking if this event was not
////                     triggered by the save process.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
end event

event pcd_validatecol;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_ValidateCol
////  Description   : Provides the opportunity for the developer
////                  to write code to validate DataWindow fields.
////
////  Parameters    : BOOLEAN In_Save -
////            	        Can be used by the developer to prevent
////                     validation checking if this event was not
////                     triggered by the save process.
////                  LONG    Row_Nbr -
////                     The row that is being validated.
////                  INTEGER Col_Nbr -
////                     The column that is being validated.
////                  STRING  Col_Name -
////                     The name of the column being validated.
////                  STRING  Col_Text -
////                     The input the user has made.
////                  STRING  Col_Val_Msg -
////                     The validation error message provided by
////                     PowerBuilder's extended column definition.
////                  BOOLEAN Col_Req_Error -
////                     This column is a required field and the user
////                     has not entered anything.
////
////  Return Value  : Error.i_FWError -
////                     c_ValOk     - Data was validated successfully.
////                     c_ValFailed - Data failed validation.
////                     c_ValFixed  - Data failed validation, but was
////                                   fixed and updated using SetItem.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  The result of the validation should be returned by the
////  developer in Error.i_FWError.  The return value of PowerClass
////  validation routines can be used to directly set Error.i_FWError.
////  If the developer codes the validation testing, then the
////  developer should set Error.i_FWError to one of the following
////  validation return codes:
////
////     c_ValOk (0)    : The validation test passed and the
////                      data is to be accepted.
////     c_ValFailed (1): The validation test failed and the
////                      data is to be rejected.  Do not allow
////                      the user to move off of this field.
////     c_ValFixed  (2): The validation test failed.  However,
////                      the data was able to be modified by
////                      developer to pass the validation test.
////                      If a developer returns this code, they
////                      are responsible for doing a SetItem()
////                      to place the fixed value into the
////                      column.  Note that if the PowerObjects
////                      validation functions, 
////                      OBJCA.FIELD.fu_Validate* are used, they will
////                      do the SetItem(), if necessary.
////
////------------------------------------------------------------------
//
////CHOOSE CASE col_name
////
////   CASE "<column1>"
////
////      Error.i_FWError = OBJCA.FIELD.fu_ValidateInt(col_text, "##,##0", TRUE)
////
////   CASE "<column2>"
////
////      Error.i_FWError = OBJCA.FIELD.fu_ValidateInt(col_text, "##,##0.00", TRUE)
////      IF Error.i_FWError <> c_ValFailed THEN
////         IF Integer(col_text) < 0 THEN
////            fu_DisplayValError("ValDevOKError", "<error message>")
////            Error.i_FWError = c_ValFailed
////         END IF
////      END IF
////
////   CASE "<column3>"
////
////      IF Upper(Left(col_text, 1)) = "Y"  THEN
////         SetItem(row_nbr, col_nbr, "Yes")
////         Error.i_FWError = c_ValFixed
////      ELSE
////         IF Upper(Left(col_text, 1)) = "N"  THEN
////            SetItem(row_nbr, col_nbr, "No")
////            Error.i_FWError = c_ValFixed
////         ELSE
////            fu_DisplayValError("ValDevOKError", &
////                "Valid responses are 'Y' and 'N'")
////            Error.i_FWError = c_ValFailed
////         END IF
////      END IF
////
////   CASE "<column4>"
////
////      IF col_req_error THEN
////         IF fu_DisplayValError("ValDevYesNoError", &
////                "Do you want a default value of 'Active'?") = 1 THEN
////            SetItem(row_nbr, col_nbr, "Active")
////            Error.i_FWError = c_ValFixed
////         ELSE
////            Error.i_FWError = c_ValFailed
////         END IF
////      END IF
////
////   CASE "<column5>"  // Generate a default value for a CheckBox
////      IF col_req_error THEN
////         SetItem(row_nbr, col_nbr, "N")
////         Error.i_FWError = c_ValFixed
////      END IF
////
////END CHOOSE
//
end event

event pcd_closequery;call super::pcd_closequery;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_CloseQuery
////  Description   : Provide the opportunity for the developer
////                  to do things to the DataWindow before a window 
////                  is allowed to close.  Setting Error.i_FWError 
////                  to c_Fatal will prevent the window from closing.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
end event

event pcd_close;call super::pcd_close;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_Close
////  Description   : Provide the opportunity for the developer
////                  to do things to the DataWindow when the window
////                  is closing. 
////
////  Return Value  : (None)
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
end event

event pcd_setcodetables;call super::pcd_setcodetables;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_SetCodeTables
////  Description   : Provide the opportunity for the developer
////                  to load code tables for columns on the 
////                  DataWindow. 
////
////  Parameters    : TRANSACTION Transaction_Object -
////            	        Transaction object for this DataWindow.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Use the PowerObjects field manager function, 
////  OBJCA.FIELD.fu_LoadCode(), to load the code tables for each 
////  column in the DataWindow.  Parameters for this function are:
////
////     DATAWINDOW  DW_Name -
////        Name of this DataWindow.
////     STRING      DW_Column -
////        Column name with the code table to load.
////     TRANSACTION Transaction_Object -
////        Transaction object.
////     STRING      Table_Name -
////        Table from where the column with the code values resides.
////     STRING      Column_Code -
////        Column name with the code values.
////     STRING      Column_Desc -
////        Column name with the code descriptions.
////     STRING      Where_Clause -
////        WHERE clause statement to restrict the code values.
////     STRING      All_Keyword -
////        Keyword to denote select all values (e.g. "(All)")
////
////------------------------------------------------------------------
//
////Error.i_FWError = OBJCA.FIELD.fu_LoadCode(THIS, &
////                                          "<dw_column>", &
////                                          transaction_object, &
////                                          "<table_name>",  &
////                                          "<column_code>", &
////                                          "<column_desc>", &
////                                          "<where_clause>", &
////                                          "<all_keyword>")
////IF Error.i_FWError <> c_Success THEN
////   RETURN
////END IF
//
end event

event pcd_setcontrol;call super::pcd_setcontrol;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_SetControl
////  Description   : Provide the opportunity for the developer
////                  to control the enable/disable or hide/show
////                  attributes of menu and buttons that are not
////                  controlled by PowerClass.  The 'control_type'
////                  argument indicates which PowerClass menues and
////                  buttons were manipulated.
////
////  Parameters    : INTEGER Control_Type -
////            	        Type of control manipulation that PowerClass
////                     executed.  Possible values are:
////                        c_AllControls
////                        c_ModeControls
////                        c_ScrollControls
////                        c_SeekControls
////                        c_ContentControls
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
end event

event pcd_setoptions;call super::pcd_setoptions;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_SetOptions
////  Description   : Provide the opportunity for the developer
////                  to set options for the DataWindow and wire
////                  other controls to it. 
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Use the fu_SetOptions() function to set the behavior for this
////  DataWindow.  The parameters for this function are:
////
////     TRANSACTION Transaction_Object -
////        The transaction object to be used with this
////        DataWindow.  Typically, this will be SQLCA.
////     DATAWINDOW  Parent_DW -
////        The parent DataWindow for this DataWindow.  If
////        there is not a parent, specify c_NullDW.
////     STRING      Options -
////        The options requested for this DataWindow.
////
////------------------------------------------------------------------
//
////fu_SetOptions(<transaction_object>, <parent_dw>, <options>)
//
////------------------------------------------------------------------
////  Use the fu_WireDW function in the search/filter objects
////  to wire a control to a column in this DataWindow.  The 
////  parameters for this function are:
////
////     DATAWINDOW  DW_Name -
////        The DataWindow that is to be wired to the object.
////     STRING      Table_Name -
////        The table in the database that the object should build 
////        the WHERE clause for.
////     STRING      Column_Name -
////        The column in the database that the object should build 
////        the WHERE clause for.
////     TRANSACTION Transaction_Object - 
////        Transaction object associated with this DataWindow.
////
////------------------------------------------------------------------
//
////<ddlb>.fu_WireDW(THIS, "<table_name>", "<column_name>", <transaction_object>)
////<dddw>.fu_WireDW(THIS, "<table_name>", "<column_name>", <transaction_object>)
////<lb>.fu_WireDW(THIS, "<table_name>", "<column_name>", <transaction_object>)
////<em>.fu_WireDW(THIS, "<table_name>", "<column_name>", <transaction_object>)
//
////------------------------------------------------------------------
////  Use the fu_WireDW function in the search/filter DataWindow
////  to wire columns in the search/filter DataWindow to columns in 
////  this DataWindow.  The parameters for this function are:
////
////     STRING     Search_Name[] -
////        The columns in the search/filter DataWindow that are to
////        be wired to columns in this DataWindow.
////     DATAWINDOW DW_Name -
////        The DataWindow that is to be wired to the search/filter
////        DataWindow.
////     STRING      Table_Name[] -
////        The table in the database that the object should build 
////        the WHERE clause for.
////     STRING      Column_Name[] -
////        The column in the database that the object should build 
////        the WHERE clause for.
////     TRANSACTION Transaction_Object - 
////        Transaction object associated with this DataWindow.
////
////------------------------------------------------------------------
//
////<search_dw>.fu_WireDW("<search_name[]>", THIS, "<table_name[]>", &
////                      "<column_name[]>", <transaction_object>)
//
////------------------------------------------------------------------
////  Use the fu_WireDW function in the find object to wire to a
////  column in this DataWindow.  The parameters for this function 
////  are:
////
////     DATAWINDOW DW_Name -
////        The DataWindow that is to be wired to the find object.
////     STRING     Column_Name -
////        The column in the DataWindow that the find object should 
////        be wired to.
////
////------------------------------------------------------------------
//
////<find_dw>.fu_WireDW(THIS, "<column_name>")
//
////------------------------------------------------------------------
////  Use the fu_WireDW function in the message button, u_cb_message,
////  to wire to a column in this DataWindow.  The parameters for this
////  function are:
////
////     DATAWINDOW DW_Name -
////        The DataWindow that is to be wired to the message
////        command button.
////     STRING     Column_Name -
////        Column name in the DataWindow to wire to.
////     STRING     Title -
////        Title for the message window.
////
////------------------------------------------------------------------
//
////<message_cb>.fu_WireDW(THIS, "<column_name>", "<title>")
//
////------------------------------------------------------------------
////  If a popup menu other than the default (m_popup_dw) needs to
////  be used, then use the fu_SetPopup() function to give the
////  popup menu.  The parameters for this function are:
////
////     MENU Menu_Name -
////        The name of the popup menu.
////------------------------------------------------------------------
//
//fu_SetPopup(m_client.Item[1])
//
end event

event pcd_validatebefore;call super::pcd_validatebefore;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_ValidateBefore
////  Description   : Provide the opportunity for the developer
////                  to do things before validiation has been run
////                  on this DataWindow. 
////
////  Parameters    : BOOLEAN In_Save -
////            	        Can be used by the developer to prevent
////                     validation checking if this event was not
////                     triggered by the save process.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
end event

event pcd_commit;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_Commit
////  Description   : Commits the DataWindow rows to the database.
////
////  Parameters    : TRANSACTION Transaction_Object -
////            	        Transaction object for this DataWindow.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
//CHOOSE CASE transaction_object.DBMS
//	
//	CASE 'SYB','SYC'
//
//	CASE 'ODBC'
//
//		IF IsNull(transaction_object) THEN
//   		RETURN
//		END IF
//
//		//----------
//		//  Commit the updates made to the database.
//		//----------
//
//		COMMIT USING transaction_object;
//
//		//----------
//		//  Check for errors that occurred during the COMMIT.
//		//----------
//
//		IF transaction_object.SQLCode <> 0 THEN
//			Error.i_FWError = c_Fatal
//		END IF
//
//END CHOOSE
end event

event pcd_rollback;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_Rollback
////  Description   : Rollbacks the DataWindow rows to the database.
////
////  Parameters    : TRANSACTION Transaction_Object -
////            	        Transaction object for this DataWindow.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
//CHOOSE CASE transaction_object.DBMS
//
//	CASE 'SYB','SYC'
//
//	CASE 'ODBC'
//
//		IF IsNull(transaction_object) THEN
//   		RETURN
//		END IF
//
//		//----------
//		//  Rollback the changes made to the database since the last
//		//  COMMIT.
//		//----------
//
//		ROLLBACK USING transaction_object;
//
//		//----------
//		//  Check for errors that occurred during the ROLLBACK.
//		//----------
//
//		IF transaction_object.SQLCode <> 0 THEN
//  			 PCCA.Error = c_Fatal
//		END IF
//
//END CHOOSE
end event

event pcd_validatedrop;call super::pcd_validatedrop;////******************************************************************
////  PC Module     : u_DW_Std
////  Event         : pcd_ValidateDrop
////  Description   : Provides the opportunity for the developer to
////                  write code to validate a row that is dragged and
////                  dropped in the DataWindow before it is inserted.
////
////  Parameters    : U_DW_MAIN Drag_DW -
////            	        The DataWindow that initiated the drag 
////                     operation.
////                  LONG      Drag_Row -
////                     The row that is being dragged.
////                  LONG      Drop_Row -
////                     The row number where the dragged row will be 
////                     dropped.  This row may not exist if it is
////                     being dropped after the last row.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  The following sample code illustrates if a row is being dropped
////  in the correct place.
////------------------------------------------------------------------
//
//INTEGER l_CurrentLevel, l_DragLevel
//STRING  l_ErrMsg
//
//l_CurrentLevel = GetItemNumber(drop_row - 1, "level")
//l_DragLevel    = drag_dw.GetItemNumber(drag_row, "level")
//
//IF l_CurrentLevel <> l_DragLevel THEN
//   l_ErrMsg = "The row has not been dropped on the correct level."
//   fu_DisplayValError("ValDevOKError", l_ErrMsg)
//   Error.i_FWError = c_Fatal
//END IF
//
end event

on u_dw_std.create
end on

on u_dw_std.destroy
end on

event editchanged;//******************************************************************
//  PC Module     : u_DW_Stds
//  Event         : EditChanged
//  Description   : This event is used to indicate that the input
//                  needs to be validated.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  12/3/99  M. Caruso  Created, based on ancestor function
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(i_DWSRV_EDIT) THEN
	IF NOT i_IsQuery THEN
		i_DWSRV_EDIT.i_ItemValidated = FALSE
		i_DWSRV_EDIT.i_HaveModify    = TRUE
	END IF
	
	IF i_DDDWFind THEN
		IF data <> "" THEN
			IF Upper(dwo.dddw.allowedit) = 'YES' THEN
				i_DWSRV_EDIT.fu_DDDWFind(row, dwo, data)
			END IF
		END IF
	ELSE
		IF i_DDDWSearch AND data <> "" THEN
			IF Upper(dwo.dddw.allowedit) = 'YES' THEN
				i_DWSRV_EDIT.fu_DDDWSearch(row, dwo, data)
			END IF
		END IF
	END IF
END IF
end event

