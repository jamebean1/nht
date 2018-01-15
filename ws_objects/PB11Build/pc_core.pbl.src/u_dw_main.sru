$PBExportHeader$u_dw_main.sru
$PBExportComments$DataWindow ancestor
forward
global type u_dw_main from datawindow
end type
end forward

global type u_dw_main from datawindow
integer width = 1349
integer height = 636
integer taborder = 1
string dataobject = "d_main"
boolean livescroll = true
event pcd_close pbm_custom56
event pcd_delete pbm_custom57
event pcd_filter pbm_custom58
event pcd_first pbm_custom59
event pcd_last pbm_custom60
event pcd_modify pbm_custom61
event pcd_new pbm_custom62
event pcd_next pbm_custom63
event pcd_previous pbm_custom64
event pcd_print pbm_custom65
event pcd_query pbm_custom66
event pcd_save pbm_custom67
event pcd_saverowsas pbm_custom68
event pcd_search pbm_custom69
event pcd_sort pbm_custom70
event pcd_view pbm_custom72
event po_identify pbm_custom73
event pcd_closequery pbm_custom74
event pcd_retrieve ( datawindow parent_dw,  long num_selected,  long selected_rows[] )
event pcd_validaterow ( boolean in_save,  long row_nbr )
event pcd_validatecol ( boolean in_save,  long row_nbr,  integer col_nbr,  string col_name,  string col_text,  string col_val_msg,  boolean col_req_error )
event pcd_concurrency ( long num_errors,  long num_error_rows,  integer num_error_cols,  integer row_error_code,  dwitemstatus row_status,  integer num_cols,  string col_name[],  boolean col_update[],  integer col_error_code[],  dwitemstatus col_status[],  string col_old_value[],  string col_new_value[],  string col_dw_value[],  ref string user_name,  ref integer row_method,  ref integer row_value,  ref integer val_method,  ref integer col_method[],  ref integer col_value[],  ref string col_special[] )
event pcd_validatebefore ( boolean in_save )
event pcd_validateafter ( boolean in_save )
event pcd_setkey ( transaction transaction_object )
event pcd_commit ( transaction transaction_object )
event pcd_rollback ( transaction transaction_object )
event pcd_update ( transaction transaction_object )
event pcd_setcontrol ( integer control_type )
event pcd_setoptions pbm_custom71
event pcd_setcodetables ( transaction transaction_object )
event pcd_pickedrow ( long num_selected,  long selected_rows[] )
event pcd_escape pbm_dwescape
event pcd_savebefore ( transaction transaction_object )
event pcd_saveafter ( transaction transaction_object )
event pcd_copy pbm_custom55
event pcd_validatedrop ( u_dw_main drag_dw,  long drag_row,  long drop_row )
event type integer pcd_dynsave ( )
end type
global u_dw_main u_dw_main

type variables
//-----------------------------------------------------------------------------------------
//  DataWindow Constants
//-----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName		= "DataWindow"

CONSTANT STRING	c_Default			= "000|"
CONSTANT INTEGER	c_Success		= 0
CONSTANT INTEGER	c_Fatal			= -1
CONSTANT INTEGER	c_NoService		= -2
CONSTANT INTEGER	c_No 			= 0
CONSTANT INTEGER	c_Yes 			= 1
CONSTANT INTEGER	c_Off 			= 0
CONSTANT INTEGER	c_On 			= 1

CONSTANT STRING	c_UOWService 		= "001|"
CONSTANT STRING	c_EDITService 		= "002|"
CONSTANT STRING	c_CCService 		= "003|"
CONSTANT STRING	c_SEEKService 		= "004|"
CONSTANT STRING	c_CTRLService 		= "005|"
CONSTANT STRING	c_CUESService 		= "006|"

CONSTANT STRING	c_ScrollSelf 		= "001|"
CONSTANT STRING	c_ScrollParent 		= "002|"

CONSTANT STRING	c_IsNotInstance 		= "003|"
CONSTANT STRING	c_IsInstance 		= "004|"

CONSTANT STRING	c_RequiredOnSave 	= "005|"
CONSTANT STRING	c_AlwaysCheckRequired 	= "006|"

CONSTANT STRING	c_NoNew 		= "007|"
CONSTANT STRING	c_NewOk 		= "008|"

CONSTANT STRING	c_NoModify 		= "009|"
CONSTANT STRING	c_ModifyOk 		= "010|"

CONSTANT STRING	c_NoDelete 		= "011|"
CONSTANT STRING	c_DeleteOk 		= "012|"

CONSTANT STRING	c_NoQuery 		= "013|"
CONSTANT STRING	c_QueryOk 		= "014|"

CONSTANT STRING	c_SelectOnDoubleClick 	= "015|"
CONSTANT STRING	c_SelectOnClick 		= "016|"
CONSTANT STRING	c_SelectOnRowFocusChange = "017|"

CONSTANT STRING	c_NoDrillDown 		= "018|"
CONSTANT STRING	c_DrillDown 		= "019|"

CONSTANT STRING	c_ParentModeOnSelect 	= "020|"
CONSTANT STRING	c_ViewOnSelect 		= "021|"
CONSTANT STRING	c_ModifyOnSelect 		= "022|"
CONSTANT STRING	c_SameModeOnSelect 	= "158|"

CONSTANT STRING	c_NoMultiSelect 		= "023|"
CONSTANT STRING	c_MultiSelect 		= "024|"

CONSTANT STRING	c_RefreshOnSelect 	= "025|"
CONSTANT STRING	c_NoAutoRefresh 		= "026|"
CONSTANT STRING	c_RefreshOnMultiSelect 	= "027|"

CONSTANT STRING	c_ViewOnOpen 		= "029|"
CONSTANT STRING	c_ModifyOnOpen 		= "030|"
CONSTANT STRING	c_NewOnOpen 		= "031|"

CONSTANT STRING	c_SameModeAfterSave 	= "032|"
CONSTANT STRING	c_ViewAfterSave 		= "033|"

CONSTANT STRING	c_NoEnableModifyOnOpen 	= "034|"
CONSTANT STRING	c_EnableModifyOnOpen 	= "035|"

CONSTANT STRING	c_NoEnableNewOnOpen 	= "036|"
CONSTANT STRING	c_EnableNewOnOpen 	= "037|"

CONSTANT STRING	c_RetrieveOnOpen 		= "038|"
CONSTANT STRING	c_AutoRetrieveOnOpen 	= "039|"
CONSTANT STRING	c_NoRetrieveOnOpen 	= "040|"

CONSTANT STRING	c_RetrieveAll 		= "041|"
CONSTANT STRING	c_RetrieveAsNeeded 	= "156|"

CONSTANT STRING	c_NoShareData 		= "042|"
CONSTANT STRING	c_ShareData 		= "157|"

CONSTANT STRING	c_NoRefreshParent 	= "043|"
CONSTANT STRING	c_RefreshParent 		= "044|"

CONSTANT STRING	c_RefreshParentAuto	= "167|"
CONSTANT STRING	c_RefreshParentReselect 	= "168|"
CONSTANT STRING	c_RefreshParentRetrieve 	= "169|"

CONSTANT STRING	c_NoRefreshChild 		= "045|"
CONSTANT STRING	c_RefreshChild 		= "046|"

CONSTANT STRING	c_IgnoreNewRows 		= "047|"
CONSTANT STRING	c_NoIgnoreNewRows 	= "048|"

CONSTANT STRING	c_NoNewModeOnEmpty 	= "049|"
CONSTANT STRING	c_NewModeOnEmpty 	= "050|"

CONSTANT STRING	c_MultipleNewRows 	= "051|"
CONSTANT STRING	c_OnlyOneNewRow 	= "052|"

CONSTANT STRING	c_DisableCC 		= "053|"
CONSTANT STRING	c_EnableCC 		= "054|"

CONSTANT STRING	c_DisableCCInsert 		= "055|"
CONSTANT STRING	c_EnableCCInsert 		= "056|"

CONSTANT STRING	c_EnablePopup 		= "057|"
CONSTANT STRING	c_NoEnablePopup 		= "058|"

CONSTANT STRING	c_ViewModeBorderUnchanged = "061|"
CONSTANT STRING	c_ViewModeNoBorder 	= "062|"
CONSTANT STRING	c_ViewModeShadowBox 	= "063|"
CONSTANT STRING	c_ViewModeBox		= "064|"
CONSTANT STRING	c_ViewModeResize 	= "065|"
CONSTANT STRING	c_ViewModeUnderline 	= "066|"
CONSTANT STRING	c_ViewModeLowered 	= "067|"
CONSTANT STRING	c_ViewModeRaised 	= "068|"

CONSTANT STRING	c_ViewModeColorUnchanged = "069|"
CONSTANT STRING	c_ViewModeBlack 		= "070|"
CONSTANT STRING	c_ViewModeWhite 		= "071|"
CONSTANT STRING	c_ViewModeGray 		= "072|"
CONSTANT STRING	c_ViewModeLightGray 	= "072|"
CONSTANT STRING	c_ViewModeDarkGray 	= "073|"
CONSTANT STRING	c_ViewModeRed 		= "074|"
CONSTANT STRING	c_ViewModeDarkRed 	= "075|"
CONSTANT STRING	c_ViewModeGreen 		= "076|"
CONSTANT STRING	c_ViewModeDarkGreen 	= "077|"
CONSTANT STRING	c_ViewModeBlue 		= "078|"
CONSTANT STRING	c_ViewModeDarkBlue 	= "079|"
CONSTANT STRING	c_ViewModeMagenta 	= "080|"
CONSTANT STRING	c_ViewModeDarkMagenta 	= "081|"
CONSTANT STRING	c_ViewModeCyan 		= "082|"
CONSTANT STRING	c_ViewModeDarkCyan 	= "083|"
CONSTANT STRING	c_ViewModeYellow 	= "084|"
CONSTANT STRING	c_ViewModeBrown 		= "085|"

CONSTANT STRING	c_InactiveColorUnchanged 	= "086|"
CONSTANT STRING	c_InactiveBlack 		= "087|"
CONSTANT STRING	c_InactiveWhite 		= "088|"
CONSTANT STRING	c_InactiveGray 		= "089|"
CONSTANT STRING	c_InactiveLightGray 	= "089|"
CONSTANT STRING	c_InactiveDarkGray 	= "090|"
CONSTANT STRING	c_InactiveRed 		= "091|"
CONSTANT STRING	c_InactiveDarkRed 	= "092|"
CONSTANT STRING	c_InactiveGreen 		= "093|"
CONSTANT STRING	c_InactiveDarkGreen 	= "094|"
CONSTANT STRING	c_InactiveBlue 		= "095|"
CONSTANT STRING	c_InactiveDarkBlue 	= "096|"
CONSTANT STRING	c_InactiveMagenta 		= "097|"
CONSTANT STRING	c_InactiveDarkMagenta 	= "098|"
CONSTANT STRING	c_InactiveCyan 		= "099|"
CONSTANT STRING	c_InactiveDarkCyan 	= "100|"
CONSTANT STRING	c_InactiveYellow 		= "101|"
CONSTANT STRING	c_InactiveBrown 		= "102|"

CONSTANT STRING	c_InactiveText 		= "103|"
CONSTANT STRING	c_NoInactiveText 		= "104|"

CONSTANT STRING	c_InactiveLine 		= "105|"
CONSTANT STRING	c_NoInactiveLine 		= "106|"

CONSTANT STRING	c_InactiveCol 		= "107|"
CONSTANT STRING	c_NoInactiveCol 		= "108|"

CONSTANT STRING	c_ActiveRowPointer 	= "109|"
CONSTANT STRING	c_NoActiveRowPointer 	= "110|"

CONSTANT STRING	c_InactiveRowPointer 	= "111|"
CONSTANT STRING	c_NoInactiveRowPointer 	= "112|"

CONSTANT STRING	c_CalculateStyle 		= "113|"
CONSTANT STRING	c_FreeFormStyle 		= "114|"
CONSTANT STRING	c_TabularFormStyle 	= "115|"

CONSTANT STRING	c_CalculateHighlight	= "116|"
CONSTANT STRING	c_ShowHighlight	 	= "117|"
CONSTANT STRING	c_HideHighlight	 	= "118|"

CONSTANT STRING	c_MenuButtonActivation 	= "119|"
CONSTANT STRING	c_NoMenuButtonActivation 	= "120|"

CONSTANT STRING	c_NoAutoConfigMenus 	= "121|"
CONSTANT STRING	c_AutoConfigMenus 	= "122|"

CONSTANT STRING	c_ShowEmpty 		= "123|"
CONSTANT STRING	c_NoShowEmpty 		= "124|"

CONSTANT STRING	c_AutoFocus 		= "125|"
CONSTANT STRING	c_NoAutoFocus 		= "126|"

CONSTANT STRING	c_CCErrorRed 		= "127|"
CONSTANT STRING	c_CCErrorBlack 		= "128|"
CONSTANT STRING	c_CCErrorWhite 		= "129|"
CONSTANT STRING	c_CCErrorGray 		= "130|"
CONSTANT STRING	c_CCErrorLightGray 	= "131|"
CONSTANT STRING	c_CCErrorDarkGray 	= "132|"
CONSTANT STRING	c_CCErrorDarkRed 		= "133|"
CONSTANT STRING	c_CCErrorGreen 		= "134|"
CONSTANT STRING	c_CCErrorDarkGreen 	= "135|"
CONSTANT STRING	c_CCErrorBlue 		= "136|"
CONSTANT STRING	c_CCErrorDarkBlue 		= "137|"
CONSTANT STRING	c_CCErrorMagenta 		= "138|"
CONSTANT STRING	c_CCErrorDarkMagenta 	= "139|"
CONSTANT STRING	c_CCErrorCyan 		= "140|"
CONSTANT STRING	c_CCErrorDarkCyan 	= "141|"
CONSTANT STRING	c_CCErrorYellow 		= "142|"
CONSTANT STRING	c_CCErrorBrown 		= "143|"

CONSTANT STRING	c_SameMode		= "144|"
CONSTANT STRING	c_NewMode		= "145|"
CONSTANT STRING	c_ViewMode		= "146|"
CONSTANT STRING	c_ModifyMode		= "147|"

CONSTANT STRING	c_SelectOnScroll		= "148|"

CONSTANT STRING	c_NoBorder 		= "149|"
CONSTANT STRING	c_ShadowBox 		= "150|"
CONSTANT STRING	c_Box			= "151|"
CONSTANT STRING	c_Resize 			= "152|"
CONSTANT STRING	c_Underline 		= "153|"
CONSTANT STRING	c_Lowered		= "154|"
CONSTANT STRING	c_Raised 		= "155|"

CONSTANT STRING	c_DragOK		= "159|"
CONSTANT STRING	c_NoDrag		= "160|"

CONSTANT STRING	c_DropOK		= "161|"
CONSTANT STRING	c_NoDrop		= "162|"

CONSTANT STRING	c_CopyOK		= "163|"
CONSTANT STRING	c_NoCopy		= "164|"

CONSTANT STRING	c_NoDDDWFind		= "165|"
CONSTANT STRING	c_DDDWFind		= "166|"

CONSTANT STRING   c_DeleteSavedOK = "167|"
CONSTANT STRING   c_NoDeleteSaved = "168|"

CONSTANT STRING   c_NOSortClicked = "169|"
CONSTANT STRING   c_SortClickedOK = "170|"

CONSTANT INTEGER	c_PromptChanges		= 1
CONSTANT INTEGER	c_IgnoreChanges		= 2
CONSTANT INTEGER	c_SaveChanges		= 3

CONSTANT INTEGER	c_ReselectRows		= 1
CONSTANT INTEGER	c_NoReselectRows		= 2

CONSTANT INTEGER	c_RefreshChildren		= 1
CONSTANT INTEGER	c_NoRefreshChildren	= 2
CONSTANT INTEGER	c_ResetChildren		= 3
CONSTANT INTEGER	c_AutoRefreshChildren	= 4
CONSTANT INTEGER	c_RefreshOnOpenChildren	= 5

CONSTANT INTEGER	c_CheckAll		= 1
CONSTANT INTEGER	c_CheckChildren		= 2

CONSTANT INTEGER	c_SetFocus		= 1
CONSTANT INTEGER	c_NoSetFocus		= 2

CONSTANT ROWFOCUSIND c_DefaultIndicator		= Hand!
CONSTANT INTEGER	c_DefaultIndicatorX		= -90
CONSTANT INTEGER	c_DefaultIndicatorY		= -15
CONSTANT INTEGER	c_IndicatorFocus		= 1
CONSTANT INTEGER	c_IndicatorNotFocus	= 2
CONSTANT INTEGER	c_IndicatorEmpty		= 3
CONSTANT INTEGER	c_IndicatorQuery		= 4

CONSTANT INTEGER	c_ColorAttribute		= 1
CONSTANT INTEGER	c_BGColorAttribute		= 2
CONSTANT INTEGER	c_BorderAttribute		= 3

CONSTANT INTEGER	c_New			= 1
CONSTANT INTEGER	c_Insert			= 2
CONSTANT INTEGER	c_View			= 3
CONSTANT INTEGER	c_Modify			= 4
CONSTANT INTEGER	c_Delete			= 5
CONSTANT INTEGER	c_First			= 6
CONSTANT INTEGER	c_Previous		= 7
CONSTANT INTEGER	c_Next			= 8
CONSTANT INTEGER	c_Last			= 9
CONSTANT INTEGER	c_Query			= 10
CONSTANT INTEGER	c_Search			= 11
CONSTANT INTEGER	c_Filter			= 12
CONSTANT INTEGER	c_Sort			= 13
CONSTANT INTEGER	c_Save			= 14
CONSTANT INTEGER	c_SaveRowsAs		= 15
CONSTANT INTEGER	c_Print			= 16
CONSTANT INTEGER	c_Close			= 17
CONSTANT INTEGER	c_Copy			= 18

CONSTANT INTEGER	c_ResetQuery		= 19
CONSTANT INTEGER	c_Accept			= 20
CONSTANT INTEGER	c_OK			= 21
CONSTANT INTEGER	c_Cancel			= 22
CONSTANT INTEGER	c_Retrieve		= 23
CONSTANT INTEGER	c_Message		= 24
CONSTANT INTEGER	c_ResetSearch		= 25
CONSTANT INTEGER	c_ResetFilter		= 26

CONSTANT INTEGER	c_AllControls		= 100
CONSTANT INTEGER	c_ModeControls		= 101
CONSTANT INTEGER	c_ScrollControls		= 102
CONSTANT INTEGER	c_SeekControls		= 103
CONSTANT INTEGER	c_ContentControls		= 104

CONSTANT INTEGER	c_CCErrorNone		= 1
CONSTANT INTEGER	c_CCErrorNonOverlap	= 2
CONSTANT INTEGER	c_CCErrorOverlap		= 3
CONSTANT INTEGER	c_CCErrorOverlapMatch	= 4
CONSTANT INTEGER	c_CCErrorNonExistent	= 5
CONSTANT INTEGER	c_CCErrorDeleteModified	= 6
CONSTANT INTEGER	c_CCErrorDeleteNonExistent	= 7
CONSTANT INTEGER	c_CCErrorKeyConflict	= 8

CONSTANT INTEGER	c_CCUseOldDB		= 1
CONSTANT INTEGER	c_CCUseNewDB		= 2
CONSTANT INTEGER	c_CCUseDWValue		= 3
CONSTANT INTEGER	c_CCUseSpecial		= 4

CONSTANT INTEGER	c_CCMethodNone		= 1
CONSTANT INTEGER	c_CCMethodSpecify	= 2

CONSTANT INTEGER	c_CCValidateNone		= 1
CONSTANT INTEGER	c_CCValidateRow		= 2
CONSTANT INTEGER	c_CCValidateAll		= 3

CONSTANT INTEGER	c_ValOK			= 0
CONSTANT INTEGER	c_ValFailed		= 1
CONSTANT INTEGER	c_ValFixed		= 2
CONSTANT INTEGER	c_ValNotProcessed		= -9

CONSTANT INTEGER	c_CopyRows		= 1
CONSTANT INTEGER	c_MoveRows		= 2

//-----------------------------------------------------------------------------------------
//  DataWindow Instance Variables
//-----------------------------------------------------------------------------------------

WINDOW		i_Window
BOOLEAN		i_WindowSheet

USEROBJECT		i_Container

N_DWSRV_MAIN		i_DWSRV_UOW
N_DWSRV_MAIN		i_DWSRV_EDIT
N_DWSRV_MAIN		i_DWSRV_CC
N_DWSRV_MAIN		i_DWSRV_CUES
N_DWSRV_MAIN		i_DWSRV_CTRL
N_DWSRV_MAIN		i_DWSRV_SEEK

TRANSACTION		i_DBCA
U_DW_MAIN		i_ParentDW
DATAWINDOW		c_NullDW
DATAWINDOW		i_ScrollDW

STRING			c_MasterList
STRING			c_MasterEdit
STRING			c_DetailList
STRING			c_DetailEdit

BOOLEAN		i_ScrollParent
BOOLEAN		i_IsInstance
BOOLEAN		i_AlwaysCheckRequired
BOOLEAN		i_AllowNew
BOOLEAN		i_AllowModify
BOOLEAN		i_AllowQuery
BOOLEAN		i_AllowDelete
BOOLEAN     i_AllowDeleteSaved
BOOLEAN		i_AllowSortClicked
BOOLEAN		i_AllowDrillDown
BOOLEAN		i_AllowDrag
BOOLEAN		i_AllowDrop
BOOLEAN		i_AllowCopy
BOOLEAN		i_PLAllowDrillDown
BOOLEAN		i_PLAllowEnable
BOOLEAN		i_PLAllowNew
BOOLEAN		i_MultiSelect
BOOLEAN		i_ViewAfterSave
BOOLEAN		i_EnableNewOnOpen
BOOLEAN		i_EnableModifyOnOpen
BOOLEAN		i_RetrieveOnOpen
BOOLEAN		i_RetrieveAsNeeded
BOOLEAN		i_ShareData
BOOLEAN		i_RefreshParent
BOOLEAN		i_RefreshParentRetrieve
BOOLEAN		i_RefreshChild
BOOLEAN		i_IgnoreNewRows
BOOLEAN		i_NewModeOnEmpty
BOOLEAN		i_OnlyOneNewRow
BOOLEAN		i_EnableCC
BOOLEAN		i_EnableCCInsert
BOOLEAN		i_EnablePopup
BOOLEAN		i_InactiveText
BOOLEAN		i_InactiveLine
BOOLEAN		i_InactiveCol
BOOLEAN		i_ActiveRowPointer
BOOLEAN		i_InactiveRowPointer
BOOLEAN		i_MenuButtonActivation
BOOLEAN		i_AutoConfigMenus
BOOLEAN		i_ShowEmpty
BOOLEAN		i_AutoFocus
BOOLEAN		i_DDDWFind
BOOLEAN     i_ShowZeroSearchRowsPrompt = TRUE   // added 12/11/03 by M. Caruso

STRING			i_SelectMethod
STRING			i_ModeOnSelect
STRING			i_MultiSelectMethod
STRING			i_ModeOnOpen
STRING			i_DDDWFindText

STRING			i_ViewModeBorder
ULONG			i_ViewModeColor
ULONG			i_InactiveColor
STRING			i_PresentationStyle
STRING			i_HighlightMethod
ULONG			i_CCErrorColor

BOOLEAN		i_Initialized		= FALSE
BOOLEAN		i_InProcess		= FALSE
BOOLEAN		i_InOpen			= FALSE
BOOLEAN		i_InRetrieveOnOpen	= TRUE
BOOLEAN		i_InOpenOfShare		= TRUE
BOOLEAN		i_InSwap			= FALSE
BOOLEAN		i_FromConstructor		= FALSE
BOOLEAN		i_FromEvent		= FALSE
BOOLEAN		i_FromPickedRow		= FALSE
BOOLEAN		i_FromClicked		= FALSE
BOOLEAN		i_FromDoubleClicked	= FALSE
BOOLEAN		i_IsCurrent		= FALSE
BOOLEAN		i_IsEmpty			= FALSE
BOOLEAN		i_IsQuery			= FALSE
BOOLEAN		i_IsFilter			= FALSE
BOOLEAN		i_RefreshOnOpen		= TRUE
BOOLEAN		i_IgnoreRFC		= FALSE
BOOLEAN		i_IgnoreVal		= FALSE
STRING			i_CurrentMode
STRING			i_RequestMode
STRING			i_SaveAsDirectory
MENU			i_PopupID
BOOLEAN		i_PopupDestroy		= TRUE
LONG			i_CursorRow
LONG			i_MoveRow
STRING			i_CursorCol
LONG			i_AnchorRow
LONG			i_NumSelected
LONG			i_SelectedRows[]
STRING			i_SQLSelect
STRING			i_Filter
STRING			i_StoredProc
INTEGER		i_SetRedrawCnt

ROWFOCUSIND		i_IndicatorEmpty
PICTURE			i_IndicatorEmptyBitmap
INTEGER		i_IndicatorEmptyX
INTEGER		i_IndicatorEmptyY
ROWFOCUSIND		i_IndicatorQuery
PICTURE			i_IndicatorQueryBitmap
INTEGER		i_IndicatorQueryX
INTEGER		i_IndicatorQueryY
ROWFOCUSIND		i_IndicatorFocus
PICTURE			i_IndicatorFocusBitmap
INTEGER		i_IndicatorFocusX
INTEGER		i_IndicatorFocusY
ROWFOCUSIND		i_IndicatorNotFocus
PICTURE			i_IndicatorNotFocusBitmap
INTEGER		i_IndicatorNotFocusX
INTEGER		i_IndicatorNotFocusY

BOOLEAN		i_GotEmptyColors
STRING			i_EmptyTextColors
STRING			i_NormalTextColors

BOOLEAN		i_GotKeys
INTEGER		i_NumKeys
STRING			i_KeyColumns[]
STRING			i_KeyDBColumns[]
STRING			i_KeyTypes[]

n_cst_dwsrv_resize			inv_Resize

STRING		i_cSortDirection
STRING 		i_cSortColumn
end variables

forward prototypes
public function datawindow fu_getparentdw ()
public function window fu_getwindow ()
public function boolean fu_checkcurrent ()
public function window fu_getparentwindow ()
public function integer fu_adduow (integer number_links, datawindow link_dw[])
public subroutine fu_setkey (string column_name)
public subroutine fu_deactivate ()
public subroutine fu_setindicatorrow ()
public subroutine fu_setindicator (integer indicator_type, rowfocusind indicator, integer x_position, integer y_position)
public subroutine fu_setindicator (integer indicator_type, picture indicator, integer x_position, integer y_position)
public function integer fu_print ()
public function integer fu_sort ()
public function integer fu_saverowsas ()
public subroutine fu_initpopup ()
public function long fu_getselectedrows (ref long selected_rows[])
public function integer fu_setcursorrow (long cursor_row)
public function long fu_getcursorrow ()
public subroutine fu_getkeys ()
public function integer fu_retrieveonopen ()
public function integer fu_reset (integer changes)
public function integer fu_clearselectedrows (integer changes)
public function string fu_getidentity ()
public function integer fu_setattribute (string column_name, integer attribute_type, string attribute_value)
public function integer fu_setattribute (string column_name, integer attribute_type, unsignedlong attribute_value)
public function datawindow fu_getscrolldw ()
public function integer fu_batchattributes (integer batch_state)
public function integer fu_setcontrol (integer control_type, boolean control_state)
public function integer fu_scrollfirst ()
public function integer fu_scrolllast ()
public function integer fu_scrollnext ()
public function integer fu_scrollprevious ()
public subroutine fu_wire (powerobject control_name)
public subroutine fu_unwire (powerobject control_name)
public function integer fu_query ()
public function integer fu_searchreset ()
public function integer fu_queryreset ()
public function integer fu_filterreset ()
public function integer fu_new (long num_rows)
public function integer fu_delete (long num_rows, long delete_rows[], integer changes)
public function integer fu_modify ()
public function integer fu_save (integer changes)
public function integer fu_retrieve (integer changes, integer reselect)
public function integer fu_setselectedrows (long num_selected, long selected_rows[], integer changes, integer refresh)
public function integer fu_search (integer changes, integer reselect)
public function integer fu_filter (integer changes, integer reselect)
public function integer fu_view ()
public function boolean fu_checkchanges ()
public function integer fu_commit ()
public function integer fu_rollback ()
public function integer fu_validate ()
public function integer fu_validatecol (long row_nbr, integer col_nbr)
public function integer fu_validaterow (long row_nbr)
public function integer fu_displayvalerror (string id)
public function integer fu_displayvalerror (string id, string error_message)
public function datawindow fu_getrootdw ()
public subroutine fu_activate (integer focus)
public function integer fu_setoptions (transaction trans_object, datawindow parent_dw, string options)
public function integer fu_destroyservice (string service)
public function integer fu_createservice (string service)
public function integer fu_select (string event_name, long select_row, string select_col, boolean ctrl_key, boolean shift_key)
public function string fu_getmode ()
public function integer fu_swap (string do_name, integer changes, string options)
public function integer fu_setupdate (string table_name, string key_names[], string update_names[])
public function integer fu_insert (long start_row, long num_rows)
public function integer fu_allowcontrol (integer control_type, boolean control_state)
public subroutine fu_setredraw (integer status)
public function integer fu_saveonclose (window close_window)
public function integer fu_open ()
public function integer fu_setpopup (menu menu_name)
public subroutine fu_setsqlselect (string sqlselect_name)
public subroutine fu_setfilter (string filter_name)
public function string fu_getfilter ()
public function string fu_getsqlselect ()
public function boolean fu_checkchangesuow ()
public subroutine fu_resetupdateuow ()
public subroutine fu_resetupdate ()
public function integer fu_wiredrag (string drag_columns[], integer drag_method, datawindow drop_dw)
public function integer fu_wiredrop (string drop_columns[])
public function integer fu_setdragindicator (string single_row, string multiple_rows, string no_drop)
public function integer fu_copy (long num_rows, long copy_rows[], integer changes)
public function integer fu_promptchanges ()
public function integer fu_getsavestatus ()
public function integer fu_validateuow ()
public function string fu_getrequestmode ()
public subroutine fu_setempty ()
public function integer of_setresize (boolean ab_switch)
public subroutine fu_changeoptions (string options)
public function boolean fu_checkoption (string option)
public subroutine fu_calcoptions ()
public subroutine fu_initoptions ()
public subroutine fu_activate ()
end prototypes

event pcd_close;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Close
//  Description   : Closes the DataWindow operations.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//	 
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Destroy the popup menu.
//------------------------------------------------------------------

IF IsValid(i_PopupID) THEN
	IF i_PopupDestroy THEN
		Destroy i_PopupID
	END IF
END IF

//------------------------------------------------------------------
//  Destroy the services for this DataWindow.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CTRL) THEN
	fu_DestroyService(c_CTRLService)
END IF

IF IsValid(i_DWSRV_SEEK) THEN
	fu_DestroyService(c_SEEKService)
END IF

IF IsValid(i_DWSRV_CUES) THEN
	fu_DestroyService(c_CUESService)
END IF

IF IsValid(i_DWSRV_CC) THEN
	fu_DestroyService(c_CCService)
END IF

IF IsValid(i_DWSRV_EDIT) THEN
	fu_DestroyService(c_EDITService)
END IF

//------------------------------------------------------------------
//  If this DataWindow is the root, destroy the unit-of-work
//  service.  If this DataWindow is NOT the root, remove it from the 
//  unit-of-work service.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_UOW) THEN
	IF IsValid(i_ParentDW) <> TRUE THEN
		fu_DestroyService(c_UOWService)
	ELSE
		i_DWSRV_UOW.fu_DeleteUOW(THIS)
	END IF
END IF


end event

event pcd_delete;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Delete
//  Description   : Deletes selected records from the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG   l_NumSelected, l_SelectedRows[]
STRING l_ErrorStrings[]

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Get the selected records from the DataWindow.
//------------------------------------------------------------------

l_NumSelected = fu_GetSelectedRows(l_SelectedRows[])
IF l_NumSelected = 0 THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_Window.ClassName()
   l_ErrorStrings[4] = ClassName()
   l_ErrorStrings[5] = "fu_SetOptions"
	FWCA.MSG.fu_DisplayMessage("ZeroToDelete", &
                          	   5, l_ErrorStrings[])
	Error.i_FWError = c_Fatal
ELSE

	//---------------------------------------------------------------
	//  Indicate we are running the function from an event and call
	//  the function.
	//---------------------------------------------------------------

	i_FromEvent = TRUE
	IF fu_Delete(l_NumSelected, l_SelectedRows[], c_PromptChanges) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
	i_FromEvent = FALSE
END IF
end event

event pcd_filter;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Filter
//  Description   : Filter the DataWindow based on the filter 
//                  object criteria.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_Filter(c_PromptChanges, c_NoReselectRows) <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE

end event

event pcd_first;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_First
//  Description   : Scroll to the first row in the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_ScrollFirst() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE

end event

event pcd_last;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_First
//  Description   : Scroll to the last row in the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_ScrollLast() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE
end event

event pcd_modify;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Modify
//  Description   : Puts the DataWindow into modify mode.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_Modify() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE

end event

event pcd_new;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_New
//  Description   : Adds or inserts a record to the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF wparam = 1 THEN
	IF fu_New(1) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
ELSE
	IF fu_Insert(i_CursorRow, 1) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
END IF
i_FromEvent = FALSE
end event

event pcd_next;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Next
//  Description   : Scroll to the next row in the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_ScrollNext() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE
end event

event pcd_previous;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Previous
//  Description   : Scroll to the previous row in the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_ScrollPrevious() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE
end event

event pcd_print;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Print
//  Description   : Print the contents of the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_Print() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE
end event

event pcd_query;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Query
//  Description   : Put the DataWindow into QUERY mode.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_Query() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE
end event

event pcd_save;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Save
//  Description   : Updates records to the database.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_Save(c_SaveChanges) <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE
end event

event pcd_saverowsas;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_SaveRowsAs
//  Description   : Save the contents of the DataWindow into a file.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_SaveRowsAs() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE
end event

event pcd_search;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Search
//  Description   : Retrieve the DataWindow based on the query
//                  criteria and/or search object criteria.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_Search(c_PromptChanges, c_NoReselectRows) <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE

end event

event pcd_sort;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Sort
//  Description   : Sort the contents of the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_Sort() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE
end event

event pcd_view;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_View
//  Description   : Puts the DataWindow into view mode.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_View() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE

end event

event po_identify;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : po_Identify
//  Description   : Identifies this object as belonging to a 
//                  ServerLogic product.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

end event

event pcd_commit;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Commit
//  Description   : Commit the changes to the database.  This event
//                  is only triggered at the root level.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this is an external DataWindow, bypass this operation.
//------------------------------------------------------------------

IF IsNull(transaction_object) = FALSE THEN
	COMMIT USING transaction_object;
	IF transaction_object.SQLCode <> 0 THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

end event

event pcd_rollback;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Rollback
//  Description   : Rollback the changes made to the database since
//                  the last commit.  This event is only triggered
//                  at the root level.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this an external DataWindow, bypass this event.
//------------------------------------------------------------------

IF IsNull(transaction_object) = FALSE THEN
	ROLLBACK USING transaction_object;
	IF transaction_object.SQLCode <> 0 THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

end event

event pcd_update;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Update
//  Description   : Update the DataWindow rows to the database.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If this is an external DataWindow, bypass this event.
//------------------------------------------------------------------

IF IsNull(transaction_object) = FALSE THEN
	IF Update(FALSE, FALSE) = c_Fatal THEN
   	Error.i_FWError = c_Fatal
	END IF
END IF

end event

event pcd_escape;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Escape
//  Description   : This event executed when the user presses the
//                  ESC key to get the original values back in the
//                  edit field.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
// 10/8/98	Beth Byers	If the window is in query mode, do not call
//								fu_GetItem - you cannot use GetItemXXX in 
//								query mode per Sybase
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(i_DWSRV_EDIT) THEN

//******************************************************************
//  If we are in query mode, do not try to use GetItemXXX, as it 
//  will return an invalid row/column error
//******************************************************************
	IF i_IsQuery THEN RETURN
	
	IF i_DWSRV_EDIT.fu_GetItem(GetRow(), GetColumn(), &
		Primary!, i_DWSRV_EDIT.c_OriginalValues) = &
		i_DWSRV_EDIT.fu_GetItem(GetRow(), GetColumn(), &
		Primary!, i_DWSRV_EDIT.c_CurrentValues) THEN
		i_DWSRV_EDIT.i_HaveModify = FALSE
	END IF
END IF


end event

event pcd_copy;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Copy
//  Description   : Copies the selected records in the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG   l_NumSelected, l_SelectedRows[]
STRING l_ErrorStrings[]

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Get the selected records from the DataWindow.
//------------------------------------------------------------------

l_NumSelected = fu_GetSelectedRows(l_SelectedRows[])
IF l_NumSelected = 0 THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_Window.ClassName()
   l_ErrorStrings[4] = ClassName()
   l_ErrorStrings[5] = "fu_SetOptions"
	FWCA.MSG.fu_DisplayMessage("ZeroToCopy", &
                          	   5, l_ErrorStrings[])
	Error.i_FWError = c_Fatal
ELSE

	//---------------------------------------------------------------
	//  Indicate we are running the function from an event and call
	//  the function.
	//---------------------------------------------------------------

	i_FromEvent = TRUE
	IF fu_Copy(l_NumSelected, l_SelectedRows[], c_PromptChanges) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
	i_FromEvent = FALSE
END IF
end event

event pcd_dynsave;/****************************************************************************************

	Event:	pcd_dynsave
	Purpose:	Created so could dynamically call the save function on the window for
				validation processing.
				
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	12/28/2000 K. Claver   Original Version
****************************************************************************************/
RETURN THIS.fu_save( c_PromptChanges )
end event

public function datawindow fu_getparentdw ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetParentDW
//  Description   : Return the parent DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : DATAWINDOW -
//                     The parent DataWindow.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

DATAWINDOW l_NullDW

SetNull(l_NullDW)

IF IsNull(i_ParentDW) = FALSE THEN
	RETURN i_ParentDW
ELSE
	RETURN l_NullDW
END IF

end function

public function window fu_getwindow ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetWindow
//  Description   : Return the window for this DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : WINDOW -
//                     The window this DataWindow is on.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN i_Window

end function

public function boolean fu_checkcurrent ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_CheckCurrent
//  Description   : Return wether this DataWindow is the current
//                  DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : BOOLEAN -
//                     TRUE  - DataWindow is current.
//                     FALSE - DataWindow is not current.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

RETURN i_IsCurrent
end function

public function window fu_getparentwindow ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetParentWindow
//  Description   : Return the window of the parent DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : WINDOW -
//                     The window of the parent DataWindow.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

WINDOW l_NullWindow

SetNull(l_NullWindow)

IF IsNull(i_ParentDW) = FALSE THEN
	RETURN i_ParentDW.fu_GetWindow()
ELSE
	RETURN l_NullWindow
END IF


end function

public function integer fu_adduow (integer number_links, datawindow link_dw[]);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_AddUOW
//  Description   : Create the unit-of-work service, if necessary,
//                  and then add DataWindows to the service arrays.
//
//  Parameters    : INTEGER Number_Links -
//                     The number of DataWindows to add.
//                  DATAWINDOW Link_DW[] -
//                     The DataWindows to add.
//
//  Return Value  : INTEGER -
//                      0 - create successful.
//                     -1 - create failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Determine if the unit-of-work service needs to be created.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_UOW) THEN
	IF fu_CreateService(c_UOWService) <> c_Success THEN
		RETURN c_Fatal
	END IF
	i_DWSRV_UOW.i_RootDW = THIS
END IF

//------------------------------------------------------------------
//  Add the DataWindows to the unit-of-work service.
//------------------------------------------------------------------

i_DWSRV_UOW.fu_AddUOW(number_links, link_dw[])

RETURN c_Success
end function

public subroutine fu_setkey (string column_name);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_SetKey
//  Description   : Sets the specified column as a key column.
//
//  Parameters    : STRING Column_Name
//                     The name of the column that is to
//                     marked as a key column.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

Modify(column_name + ".Key=Yes")

end subroutine

public subroutine fu_deactivate ();//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_Deactivate
//  Description   : Indicate that this DataWindow is inactive.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

IF NOT i_Initialized THEN
	RETURN
END IF

i_FromClicked = FALSE
i_FromDoubleClicked = FALSE

//------------------------------------------------------------------
//  This DataWindow is no longer the current DataWindow.
//------------------------------------------------------------------

IF i_IsCurrent THEN
	SetNull(FWCA.MGR.i_WindowCurrentDW)
	IF FWCA.MGR.i_WindowCurrent = i_Window THEN
		i_IsCurrent = FALSE
	END IF
END IF

//------------------------------------------------------------------
//  If the inactive color option has been requested then return
//  the color of all text in the DataWindow to its inactive color 
//  to indicate that this DataWindow is inactive.
//------------------------------------------------------------------

IF IsNull(FWCA.MGR.i_WindowCurrentDW) <> FALSE OR &
	FWCA.MGR.i_WindowCurrentDW <> THIS THEN
	IF IsValid(i_DWSRV_CUES) THEN
		IF IsNull(i_InactiveColor) = FALSE THEN
   		i_DWSRV_CUES.fu_SetInactiveMode(c_Yes)
		END IF
	END IF
END IF



end subroutine

public subroutine fu_setindicatorrow ();//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_SetIndicatorRow
//  Description   : Sets up the current row indicator as the
//                  DataWindow changes states.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_HaveFocus

//------------------------------------------------------------------
//  See if the DataWindow has focus.
//------------------------------------------------------------------

l_HaveFocus = (GetFocus() = THIS)

//------------------------------------------------------------------
//  If the DataWindow is empty, then we don't want a row
//  focus indicator.
//------------------------------------------------------------------

IF i_IsEmpty THEN
   IF (l_HaveFocus     AND i_ActiveRowPointer) OR &
      (NOT l_HaveFocus AND i_InactiveRowPointer) THEN
      IF IsNull(i_IndicatorEmptyBitmap) = FALSE THEN
         SetRowFocusIndicator(i_IndicatorEmptyBitmap, &
                              i_IndicatorEmptyX,      &
                              i_IndicatorEmptyY)
      ELSE
         SetRowFocusIndicator(i_IndicatorEmpty,       &
                              i_IndicatorEmptyX,      &
                              i_IndicatorEmptyY)
      END IF
   END IF

//------------------------------------------------------------------
//  Turn the current row indicator off while we are in "QUERY"
//  mode since it does not look very good.
//------------------------------------------------------------------

ELSEIF i_IsQuery THEN
   IF (l_HaveFocus     AND i_ActiveRowPointer) OR &
      (NOT l_HaveFocus AND i_InactiveRowPointer) THEN
      IF IsNull(i_IndicatorQueryBitmap) = FALSE THEN
         SetRowFocusIndicator(i_IndicatorQueryBitmap, &
                              i_IndicatorQueryX,      &
                              i_IndicatorQueryY)
      ELSE
         SetRowFocusIndicator(i_IndicatorQuery,       &
                              i_IndicatorQueryX,      &
                              i_IndicatorQueryY)
      END IF
	END IF

//------------------------------------------------------------------
//  Set the current row indicator.
//------------------------------------------------------------------

ELSE

	IF l_HaveFocus THEN

   	//------------------------------------------------------------
   	//  See if we are to handle the current row indicator when the
   	//  DataWindow has focus.
   	//------------------------------------------------------------

   	IF i_ActiveRowPointer THEN
      	IF IsNull(i_IndicatorFocusBitmap) = FALSE THEN
         	SetRowFocusIndicator(i_IndicatorFocusBitmap, &
                              	i_IndicatorFocusX,      &
                              	i_IndicatorFocusY)
      	ELSE
         	SetRowFocusIndicator(i_IndicatorFocus,       &
                              	i_IndicatorFocusX,      &
                              	i_IndicatorFocusY)
      	END IF
		ELSE
        	SetRowFocusIndicator(Off!,                   &
                              i_IndicatorFocusX,      &
                              i_IndicatorFocusY)
   	END IF
	ELSE

   	//------------------------------------------------------------
   	//  See if we are to handle the current row indicator when the
   	//  DataWindow does not have focus.
   	//------------------------------------------------------------

   	IF i_InActiveRowPointer THEN
      	IF IsNull(i_IndicatorNotFocusBitmap) = FALSE THEN
         	SetRowFocusIndicator(i_IndicatorNotFocusBitmap, &
                              	i_IndicatorNotFocusX,      &
                              	i_IndicatorNotFocusY)
      	ELSE
         	SetRowFocusIndicator(i_IndicatorNotFocus,       &
                              	i_IndicatorNotFocusX,      &
                              	i_IndicatorNotFocusY)
      	END IF
  		ELSE
        	SetRowFocusIndicator(Off!,                   &
                              i_IndicatorFocusX,      &
                              i_IndicatorFocusY)
	 	END IF
	END IF
END IF

end subroutine

public subroutine fu_setindicator (integer indicator_type, rowfocusind indicator, integer x_position, integer y_position);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_SetIndicator
//  Description   : Allows the developer to specify the current
//                  row indicator for different DataWindow states.
//
//  Parameters    : INTEGER     Indicator_Type -
//                     The type of indicator being set.  Values are:
//                        c_IndicatorFocus
//                        c_IndicatorNotFocus
//                        c_IndicatorEmpty
//                        c_IndicatorQuery
//
//                  ROWFOCUSIND Indicator -
//                     Designates which PowerBuilder indicator is 
//                     to be used.
//
//                  INTEGER     X_Position -
//                     The X Position of the indicator.
//
//                  INTEGER     Y_Position -
//                     The Y Position of the indicator.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE indicator_type 
	CASE c_IndicatorFocus
   	i_IndicatorFocus     = indicator
   	i_IndicatorFocusX    = x_position
   	i_IndicatorFocusY    = y_position

	CASE c_IndicatorNotFocus
   	i_IndicatorNotFocus  = indicator
   	i_IndicatorNotFocusX = x_position
   	i_IndicatorNotFocusY = y_position

	CASE c_IndicatorEmpty
   	i_IndicatorEmpty     = indicator
   	i_IndicatorEmptyX    = x_position
   	i_IndicatorEmptyY    = y_position

	CASE c_IndicatorQuery
   	i_IndicatorQuery     = indicator
   	i_IndicatorQueryX    = x_position
   	i_IndicatorQueryY    = y_position

END CHOOSE

fu_SetIndicatorRow()

end subroutine

public subroutine fu_setindicator (integer indicator_type, picture indicator, integer x_position, integer y_position);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_SetIndicator
//  Description   : Allows the developer to specify the current
//                  row indicator for different DataWindow states.
//
//  Parameters    : INTEGER Indicator_Type -
//                     The type of indicator being set.  Values are:
//                        c_IndicatorFocus
//                        c_IndicatorNotFocus
//                        c_IndicatorEmpty
//                        c_IndicatorQuery
//
//                  PICTURE Indicator -
//                     Designates a picture bitmap to be used
//                     as the indicator.
//
//                  INTEGER X_Position -
//                     The X Position of the indicator.
//
//                  INTEGER Y_Position -
//                     The Y Position of the indicator.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE indicator_type 
	CASE c_IndicatorFocus
   	i_IndicatorFocusBitmap     = indicator
   	i_IndicatorFocusX          = x_position
   	i_IndicatorFocusY          = y_position

	CASE c_IndicatorNotFocus
   	i_IndicatorNotFocusBitmap  = indicator
   	i_IndicatorNotFocusX       = x_position
   	i_IndicatorNotFocusY       = y_position

	CASE c_IndicatorEmpty
   	i_IndicatorEmptyBitmap     = indicator
   	i_IndicatorEmptyX          = x_position
   	i_IndicatorEmptyY          = y_position

	CASE c_IndicatorQuery
   	i_IndicatorQueryBitmap     = indicator
   	i_IndicatorQueryX          = x_position
   	i_IndicatorQueryY          = y_position

END CHOOSE

fu_SetIndicatorRow()

end subroutine

public function integer fu_print ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Print
//  Description   : Print the contents of the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - Accept text and print successful.
//                     -1 - Accept text or print failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Make sure that there are actually rows in DataWindow that
//  can be printed.
//------------------------------------------------------------------

IF i_IsEmpty THEN
   RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Indicate to the user that we are processing the print request.
//------------------------------------------------------------------

SetPointer(HourGlass!)
IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Print")
	END IF
END IF

//------------------------------------------------------------------
//  Make sure that there is valid data before we print.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_EDIT) THEN
	IF AcceptText() = 1 THEN
   	IF Print() <> 1 THEN
			Error.i_FWError = c_Fatal
		END IF
	ELSE
   	Error.i_FWError = c_Fatal
	END IF
ELSE
  	IF Print() <> 1 THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  Trigger the pcd_print event for the developer to extend if 
//  this function was not called from this event.
//------------------------------------------------------------------

IF NOT i_FromEvent THEN
	i_InProcess = TRUE
	THIS.TriggerEvent("pcd_Print")
	i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Remove the print prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError

end function

public function integer fu_sort ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Sort
//  Description   : Sorts the contents of the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - sort successful.
//                     -1 - sort failed or cancelled.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return

//------------------------------------------------------------------
//  Make sure the PowerObjects window utility manager is
//  available.
//------------------------------------------------------------------

IF NOT IsValid(OBJCA.WIN) THEN
   RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Indicate to the user that we are processing the sort request.
//------------------------------------------------------------------

SetPointer(HourGlass!)
IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Sort")
	END IF
END IF

//------------------------------------------------------------------
//  Display the sort window.
//------------------------------------------------------------------

l_Return = OBJCA.WIN.fu_Sort(THIS)

//------------------------------------------------------------------
//  If any rows are selected, the rows may have changed with the
//  sort.  Refresh the selected rows array and then scroll to the
//  first selected row or the current cursor row.
//------------------------------------------------------------------

IF l_Return = c_Success THEN
	i_IgnoreRFC = TRUE

	IF i_ShareData THEN
		IF i_ParentDW.i_NumSelected > 0 THEN
			i_ParentDW.i_NumSelected = i_ParentDW.fu_GetSelectedRows(i_ParentDW.i_SelectedRows[])
			i_ParentDW.ScrollToRow(i_ParentDW.i_SelectedRows[1])
			ScrollToRow(i_ParentDW.i_SelectedRows[1])
		ELSE
			i_ParentDW.ScrollToRow(i_ParentDW.i_CursorRow)
			ScrollToRow(i_ParentDW.i_CursorRow)
		END IF
	ELSE
		IF i_NumSelected > 0 THEN
			i_NumSelected = fu_GetSelectedRows(i_SelectedRows[])
			ScrollToRow(i_SelectedRows[1])
		ELSE
			ScrollToRow(i_CursorRow)
		END IF
	END IF
	i_IgnoreRFC = FALSE
END IF
	
//------------------------------------------------------------------
//  Trigger the pcd_sort event for the developer to extend if 
//  this function was not called from this event.
//------------------------------------------------------------------

IF NOT i_FromEvent THEN
	i_InProcess = TRUE
	THIS.TriggerEvent("pcd_Sort")
	i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Remove the sort prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError

end function

public function integer fu_saverowsas ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SaveRowsAs
//  Description   : Saves the contents of the DataWindow in a file.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - Accept text and save successful.
//                     -1 - Accept text or save failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Make sure that there are actually rows in DataWindow that
//  can be printed and we are not in QUERY mode.
//------------------------------------------------------------------

IF i_IsEmpty OR i_IsQuery THEN
   RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Make sure The PowerObjects utility window manager is
//  available.
//------------------------------------------------------------------

IF NOT IsValid(OBJCA.WIN) THEN
   RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Indicate to the user that we are processing the save request.
//------------------------------------------------------------------

SetPointer(HourGlass!)
IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("SaveRowsAs")
	END IF
END IF

//------------------------------------------------------------------
//  Make sure that there is valid data before we save.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_EDIT) THEN
	IF AcceptText() <> 1 THEN
	   Error.i_FWError = c_Fatal
	END IF
END IF

IF Error.i_FWError = c_Success THEN
	IF OBJCA.WIN.fu_FileSaveAs(THIS, i_SaveAsDirectory) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  Trigger the pcd_saverowsas event for the developer to extend if 
//  this function was not called from this event.
//------------------------------------------------------------------

IF NOT i_FromEvent THEN
	i_InProcess = TRUE
	THIS.TriggerEvent("pcd_SaveRowsAs")
	i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Remove the save prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError

end function

public subroutine fu_initpopup ();//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_InitPopup
//  Description   : Initializes the popup menu, if requested.
//
//  Parameters    : (None)  
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

MENU    l_MenuID
BOOLEAN l_Found
INTEGER l_Idx, l_NumItems
STRING  l_EditLabel

//------------------------------------------------------------------
//  If the popup menu is requested but has not been created by the
//  developer using fu_SetPopup, then create it now.
//------------------------------------------------------------------

IF i_EnablePopup THEN
   
	IF NOT IsValid(i_PopupID) THEN

		//------------------------------------------------------------
		//  Determine if a menu is attached to the window that this 
		//  DataWindow is on.  If not, and the window is a sheet, use
		//  the MDI menu.
		//------------------------------------------------------------

		IF i_Window.MenuName <> "" THEN
			l_MenuID = i_Window.MenuID
		ELSE
			IF i_WindowSheet THEN
				IF FWCA.MGR.i_MDIFrame.MenuName <> "" THEN
					l_MenuID = FWCA.MGR.i_MDIFrame.MenuID
				END IF
			END IF
		END IF

		//------------------------------------------------------------
		//  Attempt to locate the Edit menu item.
		//------------------------------------------------------------

		IF IsValid(l_MenuID) THEN
			IF IsValid(FWCA.MENU) THEN
				l_EditLabel = FWCA.MENU.fu_GetMenuBarLabel("Edit")
			ELSE
				l_EditLabel = "&Edit"
			END IF
			l_NumItems = UpperBound(l_MenuID.Item[])
			l_Found = FALSE
			FOR l_Idx = 1 TO l_NumItems
				IF l_MenuID.Item[l_Idx].Text = l_EditLabel THEN
					l_Found = TRUE
					i_PopupID = l_MenuID.Item[l_Idx]
					i_PopupDestroy = FALSE
					EXIT
				END IF
			NEXT
			IF NOT l_Found THEN
				i_PopupID = CREATE Using "m_popup_dw"
				i_PopupID = i_PopupID.Item[1]
			END IF
		ELSE
			i_PopupID = CREATE Using "m_popup_dw"
			i_PopupID = i_PopupID.Item[1]
		END IF
	END IF

ELSE

	IF IsValid(i_PopupID) THEN
		Destroy i_PopupID
	END IF

END IF

end subroutine

public function long fu_getselectedrows (ref long selected_rows[]);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetSelectedRows
//  Description   : Builds an array containing the rows that
//                  are currently selected in the DataWindow.
//
//  Parameters    : LONG Selected_Rows[] -
//                     An array that will be filled with
//                     the row numbers that are selected
//                     in this DataWindow.
//
//  Return Value  : LONG -
//                     The number of rows returned in the
//                     Selected_Rows[] array.  Note that
//                     zero (0) rows is a valid return.
//
//  Change History:
//
//  Date     Person     Problem # / Description of Change
//  -------- ---------- --------------------------------------------
//     
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

LONG  l_NumRows
LONG  l_NextRow

//------------------------------------------------------------------
//  Assume there are no rows selected.
//------------------------------------------------------------------

l_NumRows = 0

//------------------------------------------------------------------
//  See if we are using PowerBuilder SelectRow() function.  If
//  we are, we can ask PowerBuilder for the selected rows.
//------------------------------------------------------------------

IF i_HighlightMethod = c_ShowHighlight THEN

   //---------------------------------------------------------------
   //  Find the first selected row.
   //---------------------------------------------------------------

   l_NextRow = GetSelectedRow(0)

   //---------------------------------------------------------------
   //  As long as we find selected rows, keep looping for other
   //  selected rows.
   //---------------------------------------------------------------

   DO WHILE (l_NextRow > 0)
      l_NumRows                = l_NumRows + 1
      Selected_Rows[l_NumRows] = l_NextRow

      //------------------------------------------------------------
      //  Find the next selected row.
      //------------------------------------------------------------

      l_NextRow = GetSelectedRow(l_NextRow)
   LOOP
ELSE

   //---------------------------------------------------------------
   //  If we are not using PowerBuilder's SelectRow() function,
   //  then there can only be one selected row, which is
   //  the current row.  Free-form style DataWindows
   //  are an example of a DataWindow which does not use
   //  PowerBuilder's SelectRow() function.
   //---------------------------------------------------------------

   IF i_CursorRow > 0 AND RowCount() > 0 AND NOT i_IsEmpty THEN
       l_NumRows                = l_NumRows + 1
       Selected_Rows[l_NumRows] = i_CursorRow
   ELSE
       IF GetRow() > 0 AND RowCount() > 0 AND NOT i_IsEmpty THEN
          l_NumRows                = l_NumRows + 1
          Selected_Rows[l_NumRows] = GetRow()
       END IF
   END IF
END IF

RETURN l_NumRows
end function

public function integer fu_setcursorrow (long cursor_row);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SetCursorRow
//  Description   : Set the cursor row for the DataWindow.
//
//  Parameters    : LONG Cursor_Row -
//                     Cursor row to set.
//
//  Return Value  : INTEGER -
//                      0 - cursor row set.
//                     -1 - cursor row out of range.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  See if the row to set is within range.
//------------------------------------------------------------------

IF cursor_row <= 0 OR cursor_row > RowCount() THEN
	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Set the cursor row.
//------------------------------------------------------------------

i_CursorRow = cursor_row
i_IgnoreRFC = TRUE
ScrollToRow(i_CursorRow)
i_IgnoreRFC = FALSE

//------------------------------------------------------------------
//  If we are moving to or from the first or last rows and the
//  menu/button service is avaliable, then enable/disable the
//  scroll items appropriately.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CTRL) THEN
	IF i_IsCurrent THEN
		i_DWSRV_CTRL.fu_SetControl(c_ScrollControls)
	END IF
END IF

RETURN c_Success
end function

public function long fu_getcursorrow ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetCursorRow
//  Description   : Get the cursor row from the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : LONG -
//                     Returns the cursor row.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

RETURN i_CursorRow
end function

public subroutine fu_getkeys ();//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_GetKeys
//  Description   : Get the key columns for the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_NumColumns, l_Idx
STRING  l_Type

i_NumKeys = 0
l_NumColumns = Integer(Describe("datawindow.column.count"))
FOR l_Idx = 1 TO l_NumColumns
	IF Upper(Describe("#" + String(l_Idx) + ".key")) = "YES" THEN
		l_Type = Upper(Describe("#" + String(l_Idx) + ".coltype"))
		IF Left(l_Type, 4) = "CHAR" THEN
			l_Type = "CHAR"
		END IF
		IF Left(l_Type, 3) = "DEC" THEN
			l_Type = "DEC"
		END IF
		i_NumKeys = i_NumKeys + 1
		i_KeyColumns[i_NumKeys]   = Describe("#" + String(l_Idx) + ".name")
		i_KeyDBColumns[i_NumKeys] = Describe("#" + String(l_Idx) + ".dbname")
		i_KeyTypes[i_NumKeys]     = l_Type
	END IF
NEXT
i_GotKeys = TRUE

end subroutine

public function integer fu_retrieveonopen ();//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_RetrieveOnOpen
//  Description   : Do the initial retrieve on the root-level
//                  DataWindows.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

BOOLEAN l_DoIt

//------------------------------------------------------------------
//  Determine if this is a root-level window.  If it is and the
//  retrieve on open flag is true, then retrieve.
//------------------------------------------------------------------

IF IsNull(i_ParentDW) <> FALSE AND i_Initialized THEN
	IF i_RetrieveOnOpen THEN
		CHOOSE CASE i_ModeOnOpen
			CASE c_NewOnOpen
				IF i_AllowNew THEN
					IF fu_New(1) <> c_Success THEN
						i_InRetrieveOnOpen = FALSE
						RETURN c_Fatal
					END IF
				END IF
			CASE c_ModifyOnOpen
				IF fu_Retrieve(c_IgnoreChanges, c_NoReselectRows) <> c_Success THEN
					i_InRetrieveOnOpen = FALSE
					RETURN c_Fatal
				ELSE
					IF i_AllowModify THEN
						IF fu_Modify() <> c_Success THEN
							i_InRetrieveOnOpen = FALSE
							RETURN c_Fatal
						END IF
					ELSE
						IF fu_View() <> c_Success THEN
							i_InRetrieveOnOpen = FALSE
							RETURN c_Fatal
						END IF
					END IF
				END IF
			CASE ELSE
				IF fu_Retrieve(c_IgnoreChanges, c_NoReselectRows) <> c_Success THEN
					i_InRetrieveOnOpen = FALSE
					RETURN c_Fatal
				ELSE
					IF fu_View() <> c_Success THEN
						i_InRetrieveOnOpen = FALSE
						RETURN c_Fatal
					END IF
				END IF
		END CHOOSE
	ELSE

		//------------------------------------------------------------------
		//  Initialize the DataWindow with an empty row if this is a
		//  free-form DataWindow.  If a tabular DataWindow, make sure it
		//  is in read-only mode.
		//------------------------------------------------------------------

		IF i_ShowEmpty THEN
			fu_SetEmpty()
		ELSE
			//---------------------------------------------------------
			//  If the DW is tabular and c_ModifyOnOpen is coded, then
			//  make sure the mode of the Datawindow is MODIFY, regardless
			//  if there are any rows retrieved.
			//---------------------------------------------------------
			IF i_ModeOnOpen = c_ModifyOnOpen THEN
				fu_Modify()
			ELSE
				fu_View()
			END IF
		END IF
	END IF

	i_InRetrieveOnOpen = FALSE

//------------------------------------------------------------------
//  If we have a parent DataWindow and are on reponse window or were
//  openned outside the pcd_PickedRow event on the parent
//  (e.g. from a button) then the refresh of this DataWindow will
//  not execute.  We must execute it ourselves.
//------------------------------------------------------------------

ELSE

	IF IsNull(i_ParentDW) = FALSE THEN
		l_DoIt = FALSE
		IF i_Window.WindowType = Response! THEN
			l_DoIt = TRUE
		ELSEIF (i_ParentDW.RowCount() > 0 AND NOT i_ParentDW.i_IsEmpty) THEN
			IF	NOT (i_ParentDW.RowCount() = 1 AND i_ParentDW.i_NewModeOnEmpty AND &
				i_ParentDW.GetItemStatus(1, 0, Primary!) = New!) AND &
				NOT i_ParentDW.i_FromPickedRow THEN
					l_DoIt = TRUE
			END IF
		ELSEIF IsValid(i_Container) AND i_ParentDW.RowCount() = 0 AND &
			NOT i_ParentDW.i_FromPickedRow THEN
			l_DoIt = TRUE
		END IF

		IF l_DoIt THEN
			IF RowCount() = 0 OR i_IsEmpty OR i_ShareData THEN
				IF IsValid(i_DWSRV_UOW) THEN
					IF i_ParentDW.i_RequestMode = c_NewMode THEN
						IF IsValid(i_Container) THEN
							IF i_IsInstance THEN
								i_DWSRV_UOW.fu_SetInstance(THIS)
							END IF
							IF IsValid(i_DWSRV_EDIT) THEN
								i_DWSRV_EDIT.fu_New(0, 1)
							END IF
						ELSE
							fu_New(1)
						END IF
					ELSE
						IF IsValid(i_Container) AND i_IsInstance THEN
							i_DWSRV_UOW.fu_SetInstance(THIS)
						END IF
						i_DWSRV_UOW.fu_Refresh(i_ParentDW, c_RefreshOnOpenChildren, c_SameMode)
					END IF
					IF i_Window.WindowType = Response! THEN
						i_ParentDW.fu_SetRedraw(c_On)
					END IF
				END IF
			END IF
		END IF
	END IF

	//------------------------------------------------------------------
	//  Since i_InRetrieveOnOpen is initialized to TRUE, we need to make
	//  sure it is set to false when we leave this function.
	//------------------------------------------------------------------

	i_InRetrieveOnOpen = FALSE

END IF

RETURN c_Success
end function

public function integer fu_reset (integer changes);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Reset
//  Description   : Reset the DataWindow.
//
//  Parameters    : INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//
//  Return Value  : INTEGER -
//                      0 - reset operation successful.
//                     -1 - reset operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If it
//  is then handle the changes.  If not, handle the changes for this
//  DataWindow only.
//------------------------------------------------------------------

IF changes <> c_IgnoreChanges THEN
	IF IsValid(i_DWSRV_UOW) THEN
		IF i_DWSRV_UOW.fu_Save(THIS, changes, c_CheckAll) <> c_Success THEN
   	   RETURN c_Fatal
		END IF
	ELSE
		IF IsValid(i_DWSRV_EDIT) THEN
			IF i_DWSRV_EDIT.fu_Save(changes) <> c_Success THEN
				RETURN c_Fatal
			END IF
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Display the reset prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Reset")
	END IF
END IF

//------------------------------------------------------------------
//  Make sure no DataWindow activity happens during this process.
//------------------------------------------------------------------

i_IgnoreRFC = TRUE
i_IgnoreVal = TRUE
fu_SetRedraw(c_Off)

//------------------------------------------------------------------
//  Reset the DataWindow.
//------------------------------------------------------------------

Reset()

i_CursorRow   = 0
i_CursorCol   = ""
i_AnchorRow   = 0
i_NumSelected = 0

//------------------------------------------------------------------
//  Insert an empty row, if necessary.
//------------------------------------------------------------------

IF i_ShowEmpty THEN
	fu_SetEmpty()
END IF

//------------------------------------------------------------------
//  Restore normal DataWindow activity.
//------------------------------------------------------------------

i_IgnoreRFC = FALSE
i_IgnoreVal = FALSE
fu_SetRedraw(c_On)

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN c_Success
end function

public function integer fu_clearselectedrows (integer changes);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ClearSelectedRows
//  Description   : Clear the selected rows in this DataWindow.
//
//  Parameters    : INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//
//  Return Value  : INTEGER -
//                      0 - clear operation successful.
//                     -1 - clear operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

LONG    l_SelectedRows[]
INTEGER l_Return

//------------------------------------------------------------------
//  Assume we have no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Display the clear prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Clear")
	END IF
END IF

//------------------------------------------------------------------
//  Clear the selected records.
//------------------------------------------------------------------

l_Return = fu_SetSelectedRows(0, l_SelectedRows[], changes, &
							         c_NoRefreshChildren)

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN l_Return
end function

public function string fu_getidentity ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetIdentity
//  Description   : Returns the identity of this object.
//
//  Parameters    : (None)
//
//  Return Value  : STRING -
//                     Identity of this object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

RETURN c_ObjectName
end function

public function integer fu_setattribute (string column_name, integer attribute_type, string attribute_value);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SetAttribute
//  Description   : Set a DataWindow attribute.  If we are in batch
//                  mode then don't apply the attributes yet.
//
//  Parameters    : STRING Column_Name -
//                     Column to set the attribute for.
//                  INTEGER Attribute_Type -
//                     The type of attribute to set.  Values are:
//                        c_ColorAttribute
//                        c_BGColorAttribute
//                        c_BorderAttribute
//                  STRING Attribute_Value -
//                     The value to set the attribute with.
//                     Values for borders are:
//                        c_BorderAttribute :   c_NoBorder
//                                              c_ShadowBox
//                                              c_Box
//                                              c_Resize
//                                              c_Underline
//                                              c_Lowered
//                                              c_Raised
//
//  Return Value  : INTEGER -
//                      0 - attribute set successful.
//                     -2 - no service avaliable.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the visual cues service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_CUES) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the set attribute function in the visual cues service.
//------------------------------------------------------------------

i_DWSRV_CUES.fu_SetAttribute(column_name, attribute_type, &
                              attribute_value)

RETURN c_Success
end function

public function integer fu_setattribute (string column_name, integer attribute_type, unsignedlong attribute_value);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SetAttribute
//  Description   : Set a DataWindow attribute.  If we are in batch
//                  mode then don't apply the attributes yet.
//
//  Parameters    : STRING Column_Name -
//                     Column to set the attribute for.
//                  INTEGER Attribute_Type -
//                     The type of attribute to set.  Values are:
//                        c_ColorAttribute
//                        c_BGColorAttribute
//                        c_BorderAttribute
//                  ULONG   Attribute_Value -
//                     The value to set the attribute with.  Values
//                     are:
//                        c_ColorAttribute  :   FWCA.MGR.c_<color>
//                        c_BGColorAttribute:   FWCA.MGR.c_<color>
//
//  Return Value  : INTEGER -
//                      0 - attribute set successful.
//                     -2 - no service available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the visual cues service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_CUES) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the set attribute function in the visual cues service.
//------------------------------------------------------------------

i_DWSRV_CUES.fu_SetAttribute(column_name, attribute_type, &
                             attribute_value)

RETURN c_Success
end function

public function datawindow fu_getscrolldw ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetScrollDW
//  Description   : Return the scroll DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : DATAWINDOW -
//                     The scroll DataWindow.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF i_ScrollParent THEN
	RETURN i_ParentDW
ELSE
	RETURN THIS
END IF

end function

public function integer fu_batchattributes (integer batch_state);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_BatchAttributes
//  Description   : Apply the attribute changes that were queued
//                  using fu_SetAttribute().
//
//  Parameters    : INTEGER Batch_State -
//                     Turns batch mode on or off.  Values are:
//                        c_On
//                        c_Off
//
//  Return Value  : INTEGER -
//                      0 - attribute set successful.
//                     -2 - no service available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the visual cues service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_CUES) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the batch attribute function in the visual cues service.
//------------------------------------------------------------------

i_DWSRV_CUES.fu_BatchAttributes(batch_state)

RETURN c_Success
end function

public function integer fu_setcontrol (integer control_type, boolean control_state);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SetControl
//  Description   : Sets a menu item and/or buttons enabled status.
//
//  Parameters    : INTEGER Control_Type -
//                     Menu and/or button to control (e.g. c_New).
//                  BOOLEAN Control_State -
//                     Enabled (TRUE) or disabled (FALSE).
//
//  Return Value  : INTEGER -
//                      0 - control state set successful.
//                     -2 - no service available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the menu/button control service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_CTRL) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the set control function in the menu/button service.
//------------------------------------------------------------------

i_DWSRV_CTRL.fu_SetControl(control_type, control_state)

RETURN c_Success
end function

public function integer fu_scrollfirst ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ScrollFirst
//  Description   : Scroll to the first row in the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - scroll operation successful.
//                     -1 - scroll operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

BOOLEAN l_IsShifted, l_IsControl

//------------------------------------------------------------------
//  Display the scroll prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("ScrollFirst")
	END IF
END IF

//------------------------------------------------------------------
//  Assume that we will not have any errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Remember if the control or shift key is depressed.
//------------------------------------------------------------------

l_IsControl = KeyDown(keyControl!)
l_IsShifted = KeyDown(keyShift!)

//------------------------------------------------------------------
//  Scroll to the first row and select it.
//------------------------------------------------------------------

IF i_ScrollDW = i_ParentDW THEN
	IF i_ParentDW.fu_Select(c_SelectOnScroll, 1, &
		"", l_IsControl, l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
ELSE
	IF fu_Select(c_SelectOnScroll, 1, &
		"", l_IsControl, l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  If the focus was on another object (e.g. a scroll button) then 
//  set the focus to this DataWindow.
//------------------------------------------------------------------

IF GetFocus() <> THIS THEN
	i_Window.SetFocus()
	SetFocus()
END IF

//------------------------------------------------------------------
//  If the menu/button activation service has been requested then
//  set the scroll menu/button status based on the DataWindows 
//  capabilities.
//------------------------------------------------------------------

IF Error.i_FWError = c_Success THEN
	IF IsValid(i_DWSRV_CTRL) THEN
		IF i_IsCurrent THEN
	   	i_DWSRV_CTRL.fu_SetControl(c_ScrollControls)
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Trigger the pcd_first event for the developer to extend if 
//  this function was not called from this event.
//------------------------------------------------------------------

IF NOT i_FromEvent THEN
	i_InProcess = TRUE
	THIS.TriggerEvent("pcd_First")
	i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError
end function

public function integer fu_scrolllast ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ScrollLast
//  Description   : Scroll to the last row in the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - scroll operation successful.
//                     -1 - scroll operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

BOOLEAN l_IsShifted, l_IsControl
LONG    l_RowCount

//------------------------------------------------------------------
//  Display the scroll prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("ScrollLast")
	END IF
END IF

//------------------------------------------------------------------
//  Assume that we will not have any errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Remember if the control or shift key is depressed.
//------------------------------------------------------------------

l_IsControl = KeyDown(keyControl!)
l_IsShifted = KeyDown(keyShift!)

//------------------------------------------------------------------
//  Scroll to the last row and select it.
//------------------------------------------------------------------

l_RowCount = i_ScrollDW.RowCount()

IF i_ScrollDW = i_ParentDW THEN
	IF i_ParentDW.fu_Select(c_SelectOnScroll, l_RowCount, &
		"", l_IsControl, l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
ELSE
	IF fu_Select(c_SelectOnScroll, l_RowCount, &
		"", l_IsControl, l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  If the focus was on another object (e.g. a scroll button) then 
//  set the focus to this DataWindow.
//------------------------------------------------------------------

IF GetFocus() <> THIS THEN
	i_Window.SetFocus()
	SetFocus()
END IF

//------------------------------------------------------------------
//  If the menu/button activation service has been requested then
//  set the scroll menu/button status based on the DataWindows 
//  capabilities.
//------------------------------------------------------------------

IF Error.i_FWError = c_Success THEN
	IF IsValid(i_DWSRV_CTRL) THEN
		IF i_IsCurrent THEN
	   	i_DWSRV_CTRL.fu_SetControl(c_ScrollControls)
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Trigger the pcd_last event for the developer to extend if 
//  this function was not called from this event.
//------------------------------------------------------------------

IF NOT i_FromEvent THEN
	i_InProcess = TRUE
	THIS.TriggerEvent("pcd_Last")
	i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError
end function

public function integer fu_scrollnext ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ScrollNext
//  Description   : Scroll to the next row in the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - scroll operation successful.
//                     -1 - scroll operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

BOOLEAN l_IsShifted, l_IsControl
LONG    l_NextRow

//------------------------------------------------------------------
//  Display the scroll prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("ScrollNext")
	END IF
END IF

//------------------------------------------------------------------
//  Assume that we will not have any errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Remember if the control or shift key is depressed.
//------------------------------------------------------------------

l_IsControl = KeyDown(keyControl!)
l_IsShifted = KeyDown(keyShift!)

//------------------------------------------------------------------
//  Scroll to the next row and select it.
//------------------------------------------------------------------

l_NextRow = i_ScrollDW.GetRow() + 1
IF l_NextRow > i_ScrollDW.RowCount() THEN
	l_NextRow = i_ScrollDW.RowCount()
END IF

IF i_ScrollDW = i_ParentDW THEN
	IF i_ParentDW.fu_Select(c_SelectOnScroll, l_NextRow, &
		"", l_IsControl, l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
ELSE
	IF fu_Select(c_SelectOnScroll, l_NextRow, &
		"", l_IsControl, l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  If the focus was on another object (e.g. a scroll button) then 
//  set the focus to this DataWindow.
//------------------------------------------------------------------

IF GetFocus() <> THIS THEN
	i_Window.SetFocus()
	SetFocus()
END IF

//------------------------------------------------------------------
//  If the menu/button activation service has been requested then
//  set the scroll menu/button status based on the DataWindows 
//  capabilities.
//------------------------------------------------------------------

IF Error.i_FWError = c_Success THEN
	IF IsValid(i_DWSRV_CTRL) THEN
   	IF i_IsCurrent THEN
			i_DWSRV_CTRL.fu_SetControl(c_ScrollControls)
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Trigger the pcd_next event for the developer to extend if 
//  this function was not called from this event.
//------------------------------------------------------------------

IF NOT i_FromEvent THEN
	i_InProcess = TRUE
	THIS.TriggerEvent("pcd_Next")
	i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError
end function

public function integer fu_scrollprevious ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ScrollPrevious
//  Description   : Scroll to the previous row in the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - scroll operation successful.
//                     -1 - scroll operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

BOOLEAN l_IsShifted, l_IsControl
LONG    l_PriorRow

//------------------------------------------------------------------
//  Display the scroll prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("ScrollPrev")
	END IF
END IF

//------------------------------------------------------------------
//  Assume that we will not have any errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Remember if the control or shift key is depressed.
//------------------------------------------------------------------

l_IsControl = KeyDown(keyControl!)
l_IsShifted = KeyDown(keyShift!)

//------------------------------------------------------------------
//  Scroll to the previous row and select it.
//------------------------------------------------------------------

l_PriorRow = i_ScrollDW.GetRow() - 1
IF l_PriorRow < 1 THEN
	l_PriorRow = 1
END IF

IF i_ScrollDW = i_ParentDW THEN
	IF i_ParentDW.fu_Select(c_SelectOnScroll, l_PriorRow, &
		"", l_IsControl, l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
ELSE
	IF fu_Select(c_SelectOnScroll, l_PriorRow, &
		"", l_IsControl, l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  If the focus was on another object (e.g. a scroll button) then 
//  set the focus to this DataWindow.
//------------------------------------------------------------------

IF GetFocus() <> THIS THEN
	i_Window.SetFocus()
	SetFocus()
END IF

//------------------------------------------------------------------
//  If the menu/button activation service has been requested then
//  set the scroll menu/button status based on the DataWindows 
//  capabilities.
//------------------------------------------------------------------

IF Error.i_FWError = c_Success THEN
	IF IsValid(i_DWSRV_CTRL) THEN
   	IF i_IsCurrent THEN
			i_DWSRV_CTRL.fu_SetControl(c_ScrollControls)
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Trigger the pcd_previous event for the developer to extend if 
//  this function was not called from this event.
//------------------------------------------------------------------

IF NOT i_FromEvent THEN
	i_InProcess = TRUE
	THIS.TriggerEvent("pcd_Previous")
	i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
   IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError
end function

public subroutine fu_wire (powerobject control_name);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_Wire
//  Description   : Wire a search, filter, find or button object to
//                  this DataWindow.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control name to wire.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Determine what type of object is being wired.
//------------------------------------------------------------------

IF control_name.TypeOf() = CommandButton! THEN

	//---------------------------------------------------------------
	//  Make sure the menu/button control service is there before
	//  wiring.
	//---------------------------------------------------------------

	IF IsValid(i_DWSRV_CTRL) THEN
		i_DWSRV_CTRL.fu_Wire(control_name)
	END IF

ELSE

	//---------------------------------------------------------------
	//  Since the seek service is not started by a DataWindow option,
	//  if it is not there start it now. 
	//---------------------------------------------------------------

	IF NOT IsValid(i_DWSRV_SEEK) THEN
		fu_CreateService(c_SEEKService)
	END IF

	//---------------------------------------------------------------
	//  Wire the search, filter, or find control.
	//---------------------------------------------------------------

	i_DWSRV_SEEK.fu_Wire(control_name)

END IF
end subroutine

public subroutine fu_unwire (powerobject control_name);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_Unwire
//  Description   : Unwire search, filter, find or button object
//                  from this DataWindow.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control name to unwire.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Determine what type of object is being unwired.
//------------------------------------------------------------------

IF control_name.TypeOf() = CommandButton! THEN

	IF IsValid(i_DWSRV_CTRL) THEN
		i_DWSRV_CTRL.fu_Unwire(control_name)
	END IF

ELSE

	IF IsValid(i_DWSRV_SEEK) THEN
		i_DWSRV_SEEK.fu_Unwire(control_name)
	END IF

END IF
end subroutine

public function integer fu_query ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Query
//  Description   : Put the DataWindow into QUERY mode.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - query set operation successful.
//                     -1 - query set operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the query service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_SEEK) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the query function in the query service.
//------------------------------------------------------------------

RETURN i_DWSRV_SEEK.fu_Query(c_On)

end function

public function integer fu_searchreset ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SearchReset
//  Description   : Reset the values in the search objects that are
//                  attached to this DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - search reset operation successful.
//                     -1 - search reset operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the search service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_SEEK) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the search reset function in the search service.
//------------------------------------------------------------------

i_DWSRV_SEEK.fu_SearchReset()

RETURN c_Success

end function

public function integer fu_queryreset ();//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_QueryReset
//  Description   : Reset the values in QUERY mode for this 
//                  DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - query reset operation successful.
//                     -1 - query reset operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the query service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_SEEK) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the query reset function in the query service.
//------------------------------------------------------------------

i_DWSRV_SEEK.fu_QueryReset()

RETURN c_Success
end function

public function integer fu_filterreset ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_FilterReset
//  Description   : Reset the values in the filter objects that are
//                  attached to this DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - filter reset operation successful.
//                     -1 - filter reset operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the filter service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_SEEK) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the filter reset function in the filter service.
//------------------------------------------------------------------

i_DWSRV_SEEK.fu_FilterReset()

RETURN c_Success
end function

public function integer fu_new (long num_rows);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_New
//  Description   : Add records to the DataWindow.
//
//  Parameters    : LONG   Num_Rows -
//                     Number of records to add.
//
//  Return Value  : INTEGER -
//                      0 - new operation successful.
//                     -1 - new operation failed or not available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

RETURN fu_Insert(0, num_rows)

end function

public function integer fu_delete (long num_rows, long delete_rows[], integer changes);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Delete
//  Description   : Deletes records from the DataWindow.
//
//  Parameters    : LONG    Num_Rows -
//                     Number of records to delete.
//                  LONG    Delete_Rows -
//                     Row numbers to delete.
//                  INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//
//  Return Value  : INTEGER -
//                      0 - delete operation successful.
//                     -1 - delete operation failed or not available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the delete record function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_Delete(num_rows, delete_rows[], changes)

end function

public function integer fu_modify ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Modify
//  Description   : Puts the DataWindow into modify mode.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - modify operation successful.
//                     -1 - modify operation failed or not available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_ChildrenBefore, l_ChildrenAfter, l_RefreshMode
BOOLEAN l_FoundInstances, l_DoPickedRow

//------------------------------------------------------------------
//  If the edit service has not been started, check to see if
//  c_EnableModifyOnOpen is set.  If it is, there may be children
//  DataWindows that allow modifications.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_EDIT) THEN

	RETURN i_DWSRV_EDIT.fu_Modify()

ELSE

	IF i_EnableModifyOnOpen THEN

		Error.i_FWError = c_Success
		i_RequestMode = c_ModifyMode

		//------------------------------------------------------------
		//  If at least one record is selected, trigger the 
		//  pcd_PickedRow event to see if we have children
		//  DataWindows that can modify records.
		//------------------------------------------------------------

		IF i_PLAllowDrillDown AND i_NumSelected > 0 AND NOT i_InRetrieveOnOpen THEN

			l_DoPickedRow = TRUE
			IF IsValid(i_DWSRV_UOW) THEN
				IF i_DWSRV_UOW.i_InModeChange THEN
					GOTO Finished
				END IF

				l_ChildrenBefore = i_DWSRV_UOW.fu_GetChildrenCnt(THIS)
				l_FoundInstances = i_DWSRV_UOW.fu_CheckInstance(THIS)
				IF l_FoundInstances THEN
					IF i_DWSRV_UOW.fu_FindInstance(THIS, i_SelectedRows[1]) THEN
						l_DoPickedRow = FALSE
					END IF
				END IF
			END IF

			IF l_DoPickedRow THEN
	
				i_FromPickedRow = TRUE
				THIS.Event pcd_PickedRow(i_NumSelected, i_SelectedRows[])

				//-----------------------------------------------------
				//  If the developer closed the window this
				//  DataWindow is on during the pcd_PickedRow
				//  event then the remaining code is not valid and
				//  should be skipped.  
				//-----------------------------------------------------
	
				IF NOT IsValid(THIS) THEN
					RETURN 0
				END IF

				i_FromPickedRow = FALSE
				IF Error.i_FWError <> c_Success THEN
					Error.i_FWError = c_Fatal
					GOTO Finished
				END IF
			END IF

			//---------------------------------------------------------
			//  Determine if a unit-of-work was created.  If so, 
			//  determine if rows need to be loaded into the children 
			//  and put them into modify mode.
			//---------------------------------------------------------

			IF IsValid(i_DWSRV_UOW) THEN
				l_ChildrenAfter = i_DWSRV_UOW.fu_GetChildrenCnt(THIS)
				IF l_ChildrenBefore <> l_ChildrenAfter THEN
					l_RefreshMode = c_RefreshChildren
				ELSE
					l_RefreshMode = c_AutoRefreshChildren
				END IF
				IF i_DWSRV_UOW.fu_Modify(THIS, l_RefreshMode) <> c_Success THEN
					Error.i_FWError = c_Fatal
				END IF
			END IF
	
			Finished:

			//---------------------------------------------------------
			//  If this function was not called from an event then
			//  trigger the pcd_Modify event for the developer to be
			//  consistent.
			//---------------------------------------------------------

			IF NOT i_FromEvent THEN
				i_InProcess = TRUE
				TriggerEvent("pcd_Modify")
				i_InProcess = FALSE
			END IF
		END IF
	END IF
END IF

RETURN Error.i_FWError
end function

public function integer fu_save (integer changes);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Save
//  Description   : Updates records to the database.
//
//  Parameters    : INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_PromptChanges
//                        c_SaveChanges
//
//  Return Value  : INTEGER -
//                      0 - save operation successful.
//                     -1 - save operation failed or not available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has been started, execute save on the EDIT
//  service.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_EDIT) THEN

	RETURN i_DWSRV_EDIT.fu_Save(changes)

//------------------------------------------------------------------
//  Call the save record function in the UOW service.
//------------------------------------------------------------------

ELSE

	IF IsValid(i_DWSRV_UOW) THEN
		RETURN i_DWSRV_UOW.fu_Save(THIS, changes, c_CheckAll)
	ELSE
		RETURN c_NoService
	END IF

END IF
end function

public function integer fu_retrieve (integer changes, integer reselect);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Retrieve
//  Description   : Retrieve the DataWindow according to the
//                  retrieve options.
//
//  Parameters    : INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//                  INTEGER Reselect -
//                     If records are currently selected, should
//                     they be reselected after the retrieve.
//                     Values are:
//                        c_ReselectRows
//                        c_NoReselectRows
//
//  Return Value  : INTEGER -
//                      0 - retrieve operation successful.
//                     -1 - retrieve operation failed.
//
//  Change History:
//
//  Date     Person     Bug # / Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

LONG    l_NumSelected, l_SelectedRows[], l_ReselectedRow[]
LONG    l_NumReselected, l_RowCount, l_Row
ULONG   l_RefreshMode
INTEGER l_Return, l_Idx, l_Jdx
STRING  l_ReselectRow[], l_And
BOOLEAN l_Reselect, l_RedrawOff, l_NeedRFC, l_InRefreshParent

//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If it
//  is then handle the changes.  If not, handle the changes for this
//  DataWindow only.
//------------------------------------------------------------------

IF changes <> c_IgnoreChanges THEN
	IF IsValid(i_DWSRV_UOW) THEN
		IF i_DWSRV_UOW.fu_Save(THIS, changes, c_CheckAll) <> c_Success THEN
    	  RETURN c_Fatal
		END IF
	ELSE
		IF IsValid(i_DWSRV_EDIT) THEN
			IF i_DWSRV_EDIT.fu_Save(changes) <> c_Success THEN
				RETURN c_Fatal
			END IF
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Assume that we will not have any errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Display the retrieve prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   IF NOT i_IsFilter THEN
		   FWCA.MDI.fu_SetMicroHelp("Retrieve")
	   END IF
	END IF
END IF

//------------------------------------------------------------------
//  If we are to reselect the records after the retrieve then
//  save them first.  Turn RFC off if we are to reselect rows so 
//  that the retrieve process won't select the first row if the 
//  select method is c_SelectOnRowFocusChange.
//------------------------------------------------------------------

IF NOT (i_NumSelected = 0 AND i_CursorRow <= 1) AND &
	reselect = c_ReselectRows THEN

	i_IgnoreRFC = TRUE

	//---------------------------------------------------------------
	//  If we don't know what the keys are yet, get them now.
	//---------------------------------------------------------------

	IF NOT i_GotKeys THEN	
		fu_GetKeys()
	END IF

	//------------------------------------------------------------------
	//  Make sure that the selected row indicators are in sync with the 
	//  data.
	//------------------------------------------------------------------

	i_NumSelected = fu_GetSelectedRows(i_SelectedRows[])

	//---------------------------------------------------------------
	//  Save the reselect string for each selected row.
	//---------------------------------------------------------------

	FOR l_Idx = 1 TO i_NumSelected
		l_Reselect  = TRUE
		l_ReselectRow[l_Idx] = ""
		l_And = ""
		FOR l_Jdx = 1 TO i_NumKeys
			CHOOSE CASE i_KeyTypes[l_Jdx]
				CASE "CHAR"
					l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
						i_KeyColumns[l_Jdx] + " = '" + &
						GetItemString(i_SelectedRows[l_Idx], i_KeyColumns[l_Jdx]) + "'"
				CASE "DATE"
					l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
						i_KeyColumns[l_Jdx] + " = Date('" + &
						String(GetItemDate(i_SelectedRows[l_Idx], i_KeyColumns[l_Jdx])) + "')"
      		CASE "DATETIME"
					l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
						i_KeyColumns[l_Jdx] + " = DateTime('" + &
						String(GetItemDateTime(i_SelectedRows[l_Idx], i_KeyColumns[l_Jdx])) + "')"
				CASE "TIME", "TIMESTAMP"
					l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
						i_KeyColumns[l_Jdx] + " = Time('" + &
						String(GetItemTime(i_SelectedRows[l_Idx], i_KeyColumns[l_Jdx])) + "')"
				CASE "DEC"
					l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
						i_KeyColumns[l_Jdx] + " = " + &
						String(GetItemDecimal(i_SelectedRows[l_Idx], i_KeyColumns[l_Jdx]))
				CASE ELSE
					l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
						i_KeyColumns[l_Jdx] + " = " + &
						String(GetItemNumber(i_SelectedRows[l_Idx], i_KeyColumns[l_Jdx]))
			END CHOOSE
			l_And = " AND "
		NEXT
   NEXT

ELSE
	i_NumSelected = 0
END IF

//------------------------------------------------------------------
//  If an empty row exists, remove it before the retrieve.  If 
//  RetrieveAsNeeded is not used, turn redraw off until after the
//  retrieve to prevent flashing from the discarded row.
//------------------------------------------------------------------

l_RedrawOff = FALSE
IF i_IsEmpty THEN
	l_RedrawOff = TRUE
	fu_SetRedraw(c_Off)
	RowsDiscard(1, 1, Primary!)
	Modify(i_NormalTextColors)
	Modify("datawindow.readonly=no")
	IF i_PLAllowEnable THEN
		IF NOT Enabled THEN
			Enabled = TRUE
		END IF
	END IF
	i_IsEmpty = FALSE
	fu_SetIndicatorRow()
END IF

//------------------------------------------------------------------
//  If concurrency handling is available then reset its variables
//  in preparation for the retrieve.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CC) THEN
	i_DWSRV_CC.fu_ResetCCStatus()
END IF

//------------------------------------------------------------------
//  Retrieve the records.
//------------------------------------------------------------------

IF NOT i_IsFilter THEN

	//---------------------------------------------------------------
	//  If there are already records in this DataWindow and we are
	//  not on row 1 then a RFC will execute after the Retrieve().
	//  If we are on row 1 then RFC will not execute and we have
	//  to do it ourselves so that theactions of the two situations
	//  are consistent.
	//---------------------------------------------------------------

	l_NeedRFC = FALSE
	l_InRefreshParent = FALSE
	IF IsValid(i_DWSRV_UOW) THEN
		IF i_DWSRV_UOW.i_InRefreshParent THEN
			l_InRefreshParent = TRUE
			i_IgnoreRFC = TRUE
		END IF
	END IF

	IF NOT i_InRetrieveOnOpen OR (i_InRetrieveOnOpen AND IsValid(i_Container)) THEN
		IF NOT l_InRefreshParent AND NOT l_Reselect THEN
			l_NeedRFC = TRUE
		END IF
	END IF

	i_CursorRow = 0
	IF IsNull(i_ParentDW) = FALSE THEN
		l_NumSelected = i_ParentDW.fu_GetSelectedRows(l_SelectedRows[])
		IF l_NumSelected > 0 THEN
			THIS.Event pcd_Retrieve(i_ParentDW, l_NumSelected, l_SelectedRows[])
			IF Error.i_FWError = c_Success THEN
				IF l_NeedRFC THEN
					IF RowCount() > 0 THEN
						fu_Select(c_SelectOnRowFocusChange, 1, "", FALSE, FALSE)
					END IF
				END IF
			ELSE
				l_Return = c_Fatal
			END IF
		ELSE
			fu_Reset(c_IgnoreChanges)
		END IF
	ELSE
		THIS.Event pcd_Retrieve(i_ParentDW, l_NumSelected, l_SelectedRows[])
		IF Error.i_FWError = c_Success THEN
			IF l_NeedRFC THEN
				IF RowCount() > 0 THEN
					fu_Select(c_SelectOnRowFocusChange, 1, "", FALSE, FALSE)
				END IF
			END IF
		ELSE
			l_Return = c_Fatal
		END IF
	END IF

	//---------------------------------------------------------------
	//  If the timer is active, mark a time.
	//---------------------------------------------------------------

	IF IsValid(OBJCA.TIMER) THEN
		IF OBJCA.TIMER.i_TimerOn THEN
			OBJCA.TIMER.fu_TimerMark("Retrieve: " + ClassName())
		END IF
	END IF
ELSE
	THIS.Filter()
END IF

//------------------------------------------------------------------
//  If redraw was turn off to prevent flashing, turn it back on.
//------------------------------------------------------------------

IF l_RedrawOff THEN
	fu_SetRedraw(c_On)
END IF

//------------------------------------------------------------------
//  If no rows were returned then determine if a new row should be
//  inserted or an empty row inserted.
//------------------------------------------------------------------

l_RowCount = RowCount()
IF l_RowCount = 0 OR i_IsEmpty THEN
	IF IsValid(i_DWSRV_EDIT) AND NOT i_IsFilter THEN
		IF i_NewModeOnEmpty AND i_AllowNew THEN
			fu_New(1)
		ELSE
			IF i_ShowEmpty AND NOT i_IsEmpty THEN
				fu_SetEmpty()
			END IF
		END IF
	ELSE
		IF i_ShowEmpty AND NOT i_IsEmpty THEN
			fu_SetEmpty()
		END IF
	END IF
	i_NumSelected = 0
	i_CursorRow = 0
ELSE
	i_CursorRow = 1
	i_AnchorRow = 1
	IF IsValid(i_DWSRV_EDIT) THEN
		i_DWSRV_EDIT.i_HaveNew    = FALSE
		i_DWSRV_EDIT.i_HaveModify = FALSE
	END IF
END IF

//------------------------------------------------------------------
//  If there are rows to reselect, do it now.
//------------------------------------------------------------------

IF i_CurrentMode <> c_NewMode AND &
	(l_RowCount > 0 AND NOT i_IsEmpty) AND &
	l_Reselect THEN

	//---------------------------------------------------------------
	//  Display the reselect prompt.
	//---------------------------------------------------------------

	IF IsValid(FWCA.MDI) THEN
		IF FWCA.MGR.i_ShowMicrohelp THEN
		   FWCA.MDI.fu_SetMicroHelp("Reselect")
		END IF
	END IF

	//---------------------------------------------------------------
	//  Find the new rows that correspond to the keys of the 
	//  previously selected rows.
	//---------------------------------------------------------------

	FOR l_Idx = 1 TO i_NumSelected
		l_Row = Find(l_ReselectRow[l_Idx], 1, l_RowCount)
		IF l_Row > 0 THEN
			l_NumReselected = l_NumReselected + 1
			l_ReselectedRow[l_NumReselected] = l_Row
		END IF
	NEXT

	//---------------------------------------------------------------
	//  If the number of previously selected rows don't match then
	//  we need to refresh the children DataWindows, even if we
	//  are being refreshed by a RefreshParent in a save operation.
	//---------------------------------------------------------------

	IF l_NumReselected > 0 THEN
		IF i_NumSelected <> l_NumReselected THEN
			l_RefreshMode = c_RefreshChildren
		ELSE
			l_RefreshMode = c_NoRefreshChildren
		END IF
		fu_SetSelectedRows(l_NumReselected, l_ReselectedRow[], &
			                c_IgnoreChanges, l_RefreshMode)
	ELSE
		IF IsValid(i_DWSRV_UOW) THEN
			i_DWSRV_UOW.fu_Refresh(THIS, c_ResetChildren, c_SameMode)
		END IF
	END IF

	//---------------------------------------------------------------
	//  Reset the cursor and anchor rows.
	//---------------------------------------------------------------

	IF i_CursorRow <= l_RowCount THEN
		ScrollToRow(i_CursorRow)
	ELSE
		i_CursorRow = 1
	END IF

	IF i_AnchorRow = 0 OR i_AnchorRow > l_RowCount THEN
		i_AnchorRow = i_CursorRow
	END IF

ELSEIF NOT l_Reselect AND i_NumSelected = 0 THEN
	IF IsValid(i_DWSRV_UOW) THEN
		IF NOT l_InRefreshParent THEN
			i_DWSRV_UOW.fu_Refresh(THIS, c_ResetChildren, c_SameMode)
		END IF
	END IF
END IF

//---------------------------------------------------------------
//  Turn back on the normal RFC processing.
//---------------------------------------------------------------

i_IgnoreRFC = FALSE

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN l_Return
end function

public function integer fu_setselectedrows (long num_selected, long selected_rows[], integer changes, integer refresh);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SetSelectedRows
//  Description   : Select the given rows in the DataWindow.
//
//  Parameters    : LONG    Num_Selected -
//                     The number of rows to select.
//                  LONG    Selected_Rows[] -
//                     The row numbers to select.
//                  INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//                  INTEGER Refresh -
//                     Should the children DataWindows be refreshed
//                     after the rows are selected.
//                     Values are:
//                        c_RefreshChildren
//                        c_NoRefreshChildren
//
//  Return Value  : INTEGER -
//                      0 - select row operation successful.
//                     -1 - select row operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

LONG    l_Idx, l_RowCount
INTEGER l_Return

//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If it
//  is then handle the changes.  If not, handle the changes for this
//  DataWindow only.
//------------------------------------------------------------------

IF changes <> c_IgnoreChanges THEN
	IF IsValid(i_DWSRV_UOW) THEN
		IF NOT i_DWSRV_UOW.fu_FindShare(THIS) THEN
			IF i_DWSRV_UOW.fu_Save(THIS, changes, c_CheckChildren) <> c_Success THEN
				RETURN c_Fatal
			END IF
		END IF
	ELSE
		IF IsValid(i_DWSRV_EDIT) THEN
			IF i_DWSRV_EDIT.fu_Save(changes) <> c_Success THEN
				RETURN c_Fatal
			END IF
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Display the retrieve prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Select")
	END IF
END IF

//------------------------------------------------------------------
//  Unselect all currently selected records and turn off DataWindow
//  activities.
//------------------------------------------------------------------

i_IgnoreRFC = TRUE
i_IgnoreVal = TRUE
l_Return    = c_Success
SelectRow(0, FALSE)

//------------------------------------------------------------------
//  Set the selected rows.
//------------------------------------------------------------------

i_NumSelected = 0
IF num_selected > 0 AND NOT i_IsEmpty THEN
	l_RowCount = RowCount()
	FOR l_Idx = 1 TO num_selected
		IF selected_rows[l_Idx] > 0 AND &
			selected_rows[l_Idx] <= l_RowCount THEN
			IF i_HighlightMethod = c_ShowHighlight THEN
				SelectRow(selected_rows[l_Idx], TRUE)
			END IF
			i_NumSelected = i_NumSelected + 1
			i_SelectedRows[i_NumSelected] = selected_rows[l_Idx]
		END IF
	NEXT

	i_CursorRow = i_SelectedRows[1]
	i_AnchorRow = i_SelectedRows[1]
	ScrollToRow(i_CursorRow)
END IF
		
//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If it
//  is then determine if the children DataWindows need to be
//  refreshed.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_UOW) THEN
	IF i_NumSelected > 0 THEN
		l_Return = i_DWSRV_UOW.fu_Refresh(THIS, refresh, c_SameMode)
	ELSE
		l_Return = i_DWSRV_UOW.fu_Refresh(THIS, c_ResetChildren, c_SameMode)
	END IF
END IF

//------------------------------------------------------------------
//  Turn back on the normal DataWindow processing.
//------------------------------------------------------------------

i_IgnoreRFC = FALSE
i_IgnoreVal = FALSE

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN l_Return
end function

public function integer fu_search (integer changes, integer reselect);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Search
//  Description   : Retrieve the DataWindow according to the
//                  search criteria.
//
//  Parameters    : INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//                  INTEGER Reselect -
//                     If records are currently selected, should
//                     they be reselected after the search.
//                     Values are:
//                        c_ReselectRows
//                        c_NoReselectRows
//
//  Return Value  : INTEGER -
//                      0 - search operation successful.
//                     -1 - search operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the search service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_SEEK) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the search function in the search service.
//------------------------------------------------------------------

RETURN i_DWSRV_SEEK.fu_Search(changes, reselect)

end function

public function integer fu_filter (integer changes, integer reselect);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Filter
//  Description   : Filter the DataWindow according to the
//                  filter criteria.
//
//  Parameters    : INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//                  INTEGER Reselect -
//                     If records are currently selected, should
//                     they be reselected after the filter.
//                     Values are:
//                        c_ReselectRows
//                        c_NoReselectRows
//
//  Return Value  : INTEGER -
//                      0 - filter operation successful.
//                     -1 - filter operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the filter service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_SEEK) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the filter function in the filter service.
//------------------------------------------------------------------

RETURN i_DWSRV_SEEK.fu_Filter(changes, reselect)

end function

public function integer fu_view ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_View
//  Description   : Puts the DataWindow into view mode or drill down
//                  on the selected records.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - view operation successful.
//                     -1 - view operation failed or not available.
//
//  Change History:
//
//  Date     Person     Description of Change and/or Bug Number
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_ChildrenBefore, l_ChildrenAfter, l_RefreshMode
BOOLEAN l_FoundInstances, l_DoPickedRow

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success
i_RequestMode   = c_ViewMode

//------------------------------------------------------------------
//  Make sure we are not is QUERY mode.
//------------------------------------------------------------------

IF i_IsQuery THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  If the DataWindow is empty, just return.
//------------------------------------------------------------------

IF i_IsEmpty THEN
	Error.i_FWError = c_Success
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Do an AcceptText before changing into VIEW mode.  This is 
//  necessary because when a protect attribute is set for a column
//  it puts the original value from the buffer back into the field,
//  wiping out a possible change.
//------------------------------------------------------------------

IF AcceptText() <> 1 THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Display the view prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("View")
	END IF
END IF

//------------------------------------------------------------------
//  Make sure no DataWindow activity happens during this process.
//------------------------------------------------------------------

fu_SetRedraw(c_Off)
i_IgnoreRFC = TRUE
i_IgnoreVal = TRUE

//------------------------------------------------------------------
//  If the visual cues service is avaliable and the DataWindow is in
//  Modify mode then change the the columns so that they will become 
//  protected.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CUES) THEN
	i_DWSRV_CUES.fu_SetViewMode(c_On)
ELSE
	Modify("datawindow.readonly=yes")
END IF

//------------------------------------------------------------------
//  Set the current mode variable.
//------------------------------------------------------------------

i_CurrentMode = c_ViewMode

//------------------------------------------------------------------
//  Get the selected rows.
//------------------------------------------------------------------

i_NumSelected = fu_GetSelectedRows(i_SelectedRows[])

//------------------------------------------------------------------
//  If menu/button activation is available, set the controls.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CTRL) THEN
	IF i_IsCurrent THEN
		i_DWSRV_CTRL.fu_SetControl(c_ModeControls)
	END IF
END IF

//------------------------------------------------------------------
//  Restore normal DataWindow activity.
//------------------------------------------------------------------

i_IgnoreRFC = FALSE
i_IgnoreVAL = FALSE
fu_SetRedraw(c_On)

//------------------------------------------------------------------
//  If at least one record is selected, trigger the pcd_PickedRow 
//  event to see if we have children DataWindows that can view 
//  records.
//------------------------------------------------------------------

IF i_PLAllowDrillDown AND i_NumSelected > 0 AND NOT i_InRetrieveOnOpen THEN

	l_DoPickedRow = TRUE
	IF IsValid(i_DWSRV_UOW) THEN
		IF i_DWSRV_UOW.i_InModeChange THEN
			GOTO Finished
		END IF

		l_ChildrenBefore = i_DWSRV_UOW.fu_GetChildrenCnt(THIS)
		l_FoundInstances = i_DWSRV_UOW.fu_CheckInstance(THIS)
		IF l_FoundInstances THEN
			IF i_DWSRV_UOW.fu_FindInstance(THIS, i_SelectedRows[1]) THEN
				l_DoPickedRow = FALSE
			END IF
		END IF
	END IF

	IF l_DoPickedRow THEN

		i_FromPickedRow = TRUE
		THIS.Event pcd_PickedRow(i_NumSelected, i_SelectedRows[])

		//------------------------------------------------------------
		//  If the developer closed the window this
		//  DataWindow is on during the pcd_PickedRow
		//  event then the remaining code is not valid and
		//  should be skipped.  
		//------------------------------------------------------------
	
		IF NOT IsValid(THIS) THEN
			RETURN 0
		END IF

		i_FromPickedRow = FALSE
		IF Error.i_FWError <> c_Success THEN
			Error.i_FWError = c_Fatal
			GOTO Finished
		END IF
	END IF

	//---------------------------------------------------------------
	//  Determine if a unit-of-work was created.  If so, determine if
	//  rows need to be loaded into the children and put them into
	//  view mode.
	//---------------------------------------------------------------

	IF IsValid(i_DWSRV_UOW) THEN
		l_ChildrenAfter = i_DWSRV_UOW.fu_GetChildrenCnt(THIS)
		//------------------------------------------------------
		// If the window being opened is an instance window, and
		// it is not the first being opened, then l_RefreshMode
		// must always be set to c_RefreshChildren.
		//------------------------------------------------------
		IF l_FoundInstances THEN
			l_RefreshMode = c_RefreshChildren
		ELSE
			IF l_ChildrenBefore <> l_ChildrenAfter THEN
				l_RefreshMode = c_RefreshChildren
			ELSE
				l_RefreshMode = c_AutoRefreshChildren
			END IF
		END IF	

		IF i_DWSRV_UOW.fu_View(THIS, l_RefreshMode) <> c_Success THEN
			Error.i_FWError = c_Fatal
		END IF
	END IF
END IF

Finished:

//------------------------------------------------------------------
//  Trigger the pcd_View event for the developer.
//------------------------------------------------------------------

IF NOT i_FromEvent THEN
	i_InProcess = TRUE
	TriggerEvent("pcd_View")
	i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError
end function

public function boolean fu_checkchanges ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_CheckChanges
//  Description   : Check this DataWindow for changes.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     TRUE  - there are changes.
//                     FALSE - there are no changes.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN FALSE
END IF

//------------------------------------------------------------------
//  Call the checkchanges function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_CheckChanges()

end function

public function integer fu_commit ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Commit
//  Description   : Commit updates to the database.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - commit operation successful.
//                     -1 - commit operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the commit function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_Commit()

end function

public function integer fu_rollback ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Rollback
//  Description   : Rollback any updates made to the database.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - rollback operation successful.
//                     -1 - rollback operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the rollback function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_Rollback()

end function

public function integer fu_validate ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Validate
//  Description   : Validate the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - validation operation successful.
//                     -1 - validation operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the validate function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_Validate()

end function

public function integer fu_validatecol (long row_nbr, integer col_nbr);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ValidateCol
//  Description   : Trigger the validate column event for the
//                  developer.
//
//  Parameters    : LONG Row_Nbr    -
//                     Row number for the column to validate.
//                  INTEGER Col_Nbr -
//                     Column number for column to validate.
//
//  Return Value  : INTEGER -
//                      0 - validation OK.
//                      1 - validation failed.
//                      2 - validation fixed.
//                     -9 - validation not processed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the validate function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_ValidateCol(row_nbr, col_nbr)

end function

public function integer fu_validaterow (long row_nbr);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ValidateRow
//  Description   : Trigger the row validation event for the 
//                  developer.
//
//  Parameters    : LONG Row_Nbr -
//                     Row to validate.
//
//  Return Value  : INTEGER -
//                      0 - row validation operation successful.
//                     -1 - row validation operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the validate function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_ValidateRow(row_nbr)

end function

public function integer fu_displayvalerror (string id);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_DisplayValError
//  Description   : Handles the display of validation errors.
//                  This form of the function displays the error
//                  message associated with the message id.
//
//  Parameters    : STRING ID -
//                     Message ID associated with the error message.
//
//  Return Value  : INTEGER -
//                     1 or 2 - The button pressed by the user.
//                       -1   - The function was not called from
//                              pcd_ValidateCol or pcd_ValidateRow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the display validate error function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_DisplayValError(id)

end function

public function integer fu_displayvalerror (string id, string error_message);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_DisplayValError
//  Description   : Handles the display of validation errors.
//                  The error message can be specified by the
//                  developer in the Error_Message parameter or
//                  PowerClass will attempt to get the validation
//                  message from the DataWindow.  Failing that,
//                  it will provide a default PowerClass
//                  validation message specific to the error.
//
//  Parameters    : STRING ID -
//                     The message id to determine the message to
//                     display.  If a message is given for
//                     Error_Message then the ID must be 
//                     "ValDevOKError" or "ValDevYesNoError"
//                  STRING Error_Message -
//                     An error message provided by the
//                     developer.
//
//  Return Value  : INTEGER -
//                     1 or 2 - The button pressed by the user.
//                       -1   - The function was not called from
//                              pcd_ValidateCol or pcd_ValidateRow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the display validate error function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_DisplayValError(id, error_message)

end function

public function datawindow fu_getrootdw ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetRootDW
//  Description   : Return the root-level DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : DATAWINDOW -
//                     The root DataWindow.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

DATAWINDOW l_NullDW

SetNull(l_NullDW)

IF IsNull(i_ParentDW) <> FALSE THEN
	RETURN THIS
ELSE
	IF IsValid(i_DWSRV_UOW) THEN
		RETURN i_DWSRV_UOW.i_RootDW
	ELSE
		RETURN i_ParentDW
	END IF
END IF

end function

public subroutine fu_activate (integer focus);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_Activate
//  Description   : Indicate that this DataWindow is active.
//
//  Parameters    : INTEGER Focus -
//                     Should focus be set to the DataWindow when
//                     it becomes current.  Values are:
//                        c_NoSetFocus
//                        c_SetFocus
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

LONG l_Row

IF NOT i_Initialized THEN
	RETURN
END IF

i_FromClicked = FALSE
i_FromDoubleClicked = FALSE

//------------------------------------------------------------------
//  If c_AutoConfigMenus is set, make sure that the menu is 
//  configured for the current DataWindow correctly.  If PowerLock
//  is used, reapply any menu security settings if the menu comes
//  from the MDI frame.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CTRL) THEN
	i_DWSRV_CTRL.fu_AutoConfigMenu()
	IF IsValid(SECCA.MGR) THEN
		IF i_Window.MenuName = "" THEN
			IF FWCA.MGR.i_MDIValid THEN
				SECCA.MGR.DYNAMIC fu_SetSecurity(FWCA.MGR.i_MDIFrame)
			END IF
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  If the DataWindow is already current, then return.
//------------------------------------------------------------------

IF i_IsCurrent THEN
	IF FWCA.MGR.i_WindowCurrentDW = THIS THEN
	   RETURN
	END IF
END IF

//------------------------------------------------------------------
//  If there is already a current DataWindow, tell it that it
//  just lost its status as the current DataWindow.
//------------------------------------------------------------------

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.DYNAMIC fu_Deactivate()
END IF

//------------------------------------------------------------------
//  This DataWindow is now the current DataWindow.
//------------------------------------------------------------------

FWCA.MGR.i_WindowCurrentDW = THIS
i_IsCurrent = TRUE

//------------------------------------------------------------------
//  If this is an Instance DataWindow, then we need to find the
//  record in the parent DataWindow which caused this DataWindow
//  to open.
//------------------------------------------------------------------

IF i_IsInstance THEN

   i_DWSRV_UOW.fu_SetInstance(THIS)
		
	//---------------------------------------------------------------
   //  Using the keys that were saved when this Instance
   //  DataWindow was opened, search for the corresponding row
   //  in the parent DataWindow.
   //---------------------------------------------------------------

   l_Row = i_DWSRV_UOW.fu_GetInstanceRow(THIS)

   //---------------------------------------------------------------
   //  If l_Row is greater than 0, then we found the row in
   //  our parent DataWindow that opened this DataWindow.  Tell
   //  the parent DataWindow to move its cursor to that row, but
   //  not to select it.  If we told the parent DataWindow to
   //  select the row, it would try to check for changes and
   //  re-load the row back into this DataWindow.
   //---------------------------------------------------------------

   IF l_Row >  0 THEN
		i_ParentDW.fu_Select(c_SelectOnScroll, l_Row, &
									"", FALSE, FALSE)
	ELSE
		IF GetItemStatus(i_CursorRow, 0, Primary!) = New! OR &
			GetItemStatus(i_CursorRow, 0, Primary!) = NewModified! THEN
			i_ParentDW.SelectRow(0, FALSE)
			i_ParentDW.i_NumSelected = 0
		END IF
	END IF

END IF

//------------------------------------------------------------------
//  If the inactive color option has been requested then return
//  the color of all text in the DataWindow to its original color 
//  to indicate that this DataWindow is active.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CUES) THEN
	IF IsNull(i_InactiveColor) = FALSE THEN
   	i_DWSRV_CUES.fu_SetInactiveMode(c_No)
	END IF
END IF

//------------------------------------------------------------------
//  Raise the window to the top.
//------------------------------------------------------------------

IF IsValid(i_Window) THEN
	IF focus = c_SetFocus THEN
		IF i_Window.WindowState = Minimized! THEN
			i_Window.WindowState = Normal!
		ELSE
			IF FWCA.MGR.i_WindowCurrent <> i_Window THEN
				i_Window.SetFocus()
			END IF
			IF GetFocus() <> THIS THEN
				THIS.SetFocus()
			END IF
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  If the menu/button activation service has been requested then
//  set the menu/button status based on the DataWindows 
//  capabilities.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CTRL) THEN
   i_DWSRV_CTRL.fu_SetControl(c_AllControls)
END IF
end subroutine

public function integer fu_setoptions (transaction trans_object, datawindow parent_dw, string options);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SetOptions
//  Description   : Sets the DataWindow options.
//
//  Parameters    : TRANSACTION Trans_Object -
//                     Transaction object for the DataWindow.
//                     A NULL transaction object may be passed
//                     for an external DataWindow style.
//                  DATAWINDOW  Parent_DW -
//                     The parent DataWindow for this DataWindow.
//                     A NULL value may be passed to signify this
//                     DataWindow has no parent.
//                  STRING     Options -
//                     Specifies options for how this DataWindow
//                     is to behave.
//
//  Return Value  : INTEGER -
//                      0 - options set successful.
//                     -1 - options set failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//	 10/8/98	Beth Byers	Check if the datawindow is setting itself as
//								its parent
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

INTEGER    l_Error
STRING     l_ErrorStrings[]
DATAWINDOW l_LinkDW[]

//------------------------------------------------------------------
//  Set the transaction object for the DataWindow.
//------------------------------------------------------------------

i_DBCA = trans_object
IF IsNull(trans_object) = FALSE THEN
	l_Error = SetTransObject(i_DBCA)
	IF l_Error <> 1 THEN
  		l_ErrorStrings[1] = "PowerClass Error"
  		l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
  		l_ErrorStrings[3] = i_Window.ClassName()
  		l_ErrorStrings[4] = ClassName()
  		l_ErrorStrings[5] = "fu_SetOptions"
     	FWCA.MSG.fu_DisplayMessage("TransObjectError", &
                           	      5, l_ErrorStrings[])
     	RETURN c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  Determine if a parent DataWindow was given.
//------------------------------------------------------------------

IF IsNull(parent_dw) = FALSE THEN

	//---------------------------------------------------------------
	// See if the developer did a something they shouldn't have done.
	//---------------------------------------------------------------

  	IF i_ParentDW = THIS THEN
  		l_ErrorStrings[1] = "PowerClass Error"
  		l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
  		l_ErrorStrings[3] = i_Window.ClassName()
  		l_ErrorStrings[4] = ClassName()
  		l_ErrorStrings[5] = "fu_SetOptions"
     	FWCA.MSG.fu_DisplayMessage("SameParentError", &
                                	5, l_ErrorStrings[])
     	RETURN c_Fatal
  	END IF

	//---------------------------------------------------------------
	// Datawindow cannot set itself as its parent.
	//---------------------------------------------------------------

  	IF parent_dw = THIS THEN
  		l_ErrorStrings[1] = "PowerClass Error"
  		l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
  		l_ErrorStrings[3] = i_Window.ClassName()
  		l_ErrorStrings[4] = ClassName()
  		l_ErrorStrings[5] = "fu_SetOptions"
     	FWCA.MSG.fu_DisplayMessage("SameParentError", &
                                	5, l_ErrorStrings[])
     	RETURN c_Fatal
  	END IF

  	i_ParentDW = parent_dw
END IF

//------------------------------------------------------------------
//  Determine if we are on a window sheet.
//------------------------------------------------------------------

i_WindowSheet = i_Window.DYNAMIC fw_GetWindowSheet()

//------------------------------------------------------------------
//  Save the original SQL Select statement or Stored Procedure
//  from the DataWindow.
//------------------------------------------------------------------

i_SQLSelect = Describe("datawindow.table.select")
IF i_SQLSelect = "?" OR i_SQLSelect = "!" THEN
	i_SQLSelect = ""
END IF

i_StoredProc = Describe("datawindow.table.procedure")
IF i_StoredProc = "?" OR i_StoredProc = "!" THEN
	i_StoredProc = ""
END IF

//------------------------------------------------------------------
//  Save the original filter statement.
//------------------------------------------------------------------

i_Filter = Describe("datawindow.table.filter")
IF i_Filter = "?" OR i_Filter = "!" THEN
	i_Filter = ""
END IF

//------------------------------------------------------------------
//  Create a popup menu for the DataWindow, if requested.
//------------------------------------------------------------------

fu_InitPopup()

//------------------------------------------------------------------
//  Initialize the row focus indicators.
//------------------------------------------------------------------

SetNull(i_IndicatorFocusBitmap)
SetNull(i_IndicatorNotFocusBitmap)
SetNull(i_IndicatorEmptyBitmap)
SetNull(i_IndicatorQueryBitmap)

i_IndicatorEmpty    = Off!
i_IndicatorQuery    = Off!

//------------------------------------------------------------------
//  Set the DataWindow options.
//------------------------------------------------------------------

fu_ChangeOptions(options)

//------------------------------------------------------------------
//  Initialize the DataWindow with an empty row if this is a
//  free-form DataWindow.
//------------------------------------------------------------------

IF	IsNull(i_ParentDW) = FALSE THEN
	IF i_ParentDW.i_NumSelected = 0 AND NOT i_ShareData AND IsNull(i_Container) THEN
		IF i_ShowEmpty THEN
			fu_SetEmpty()
		END IF
	END IF
END IF

i_Initialized = TRUE

//------------------------------------------------------------------
//  If we were not run during the openning of the window (e.g. on a
//  tab click) then we need to do some additional processing that
//  was skipped during the window open.
//------------------------------------------------------------------

IF NOT i_InOpen THEN

	//---------------------------------------------------------------
	//  If this DataWindow has a parent, add him to the unit-of-work.
	//---------------------------------------------------------------

	IF IsNull(i_ParentDW) = FALSE AND NOT i_InSwap THEN
		l_LinkDW[1] = THIS
		l_LinkDW[2] = fu_GetRootDW()
		IF i_ParentDW.fu_AddUOW(2, l_LinkDW[]) <> c_Success THEN
			Error.i_FWError = c_Fatal
			i_Initialized = FALSE
			RETURN c_Fatal
		END IF
	END IF

	//---------------------------------------------------------------
	//  Determine if the DataWindow should be retieved and the mode
	//  set.
	//---------------------------------------------------------------

	IF fu_RetrieveOnOpen() <> c_Success THEN
		Error.i_FWError = c_Fatal
		i_Initialized = FALSE
		RETURN c_Fatal
	END IF

	//---------------------------------------------------------------
	//  Set the DataWindow to be current.
	//---------------------------------------------------------------

	fu_Activate()

END IF

RETURN c_Success
end function

public function integer fu_destroyservice (string service);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_DestroyService
//  Description   : Destroy a service.
//
//  Parameters    : STRING Service -
//                     Service to be destroyed.
//
//  Return Value  : INTEGER
//                      0 = service destroyed successfully
//                     -1 = service destruction failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Destroy the given service.
//------------------------------------------------------------------

CHOOSE CASE service

	CASE c_UOWService
		Destroy i_DWSRV_UOW

	CASE c_EDITService
		Destroy i_DWSRV_EDIT

	CASE c_CCService
		Destroy i_DWSRV_CC
	
	CASE c_SEEKService
		Destroy i_DWSRV_SEEK
	
	CASE c_CTRLService
		Destroy i_DWSRV_CTRL
	
	CASE c_CUESService
		Destroy i_DWSRV_CUES
		
	CASE ELSE
		RETURN c_Fatal
		
END CHOOSE

RETURN c_Success
end function

public function integer fu_createservice (string service);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_CreateService
//  Description   : Create a service.
//
//  Parameters    : STRING Service -
//                     Service to be created.
//
//  Return Value  : INTEGER
//                      0 = service created successfully
//                     -1 = service creation failed
//
//  Change History:
//
//  Date     Person     Problem # / Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return

l_Return = c_Success

//------------------------------------------------------------------
//  Create the given service.
//------------------------------------------------------------------

CHOOSE CASE service

	CASE c_UOWService
		IF NOT IsValid(i_DWSRV_UOW) THEN
			l_Object = FWCA.MGR.fu_GetDefault("Framework", "Uow")
			IF l_Object <> "" THEN
				i_DWSRV_UOW = Create Using l_Object
				IF NOT IsValid(i_DWSRV_UOW) THEN
					l_Return = c_Fatal
				END IF
			ELSE
				l_Return = c_Fatal
			END IF
		END IF

	CASE c_EDITService
		IF NOT IsValid(i_DWSRV_EDIT) THEN
			l_Object = FWCA.MGR.fu_GetDefault("Framework", "Edit")
			IF l_Object <> "" THEN
				i_DWSRV_EDIT = Create Using l_Object
				IF NOT IsValid(i_DWSRV_EDIT) THEN
					l_Return = c_Fatal
				ELSE
					i_DWSRV_EDIT.i_ServiceDW = THIS
				END IF
			ELSE
				l_Return = c_Fatal
			END IF
		END IF
		IF i_AllowNew OR i_AllowModify OR i_AllowDrop OR i_AllowCopy THEN
			i_DWSRV_EDIT.fu_GetColInfo()
		END IF

	CASE c_CCService
		IF NOT IsValid(i_DWSRV_CC) THEN
			l_Object = FWCA.MGR.fu_GetDefault("Framework", "Concurrency")
			IF l_Object <> "" THEN
				i_DWSRV_CC = Create Using l_Object
				IF NOT IsValid(i_DWSRV_CC) THEN
					l_Return = c_Fatal
				ELSE
					IF NOT i_EnableCC THEN
						fu_DestroyService(c_CCService)
					ELSE
						i_DWSRV_CC.i_ServiceDW = THIS
						i_DWSRV_CC.fu_InitCC()
					END IF
				END IF
			ELSE
				l_Return = c_Fatal
			END IF
		END IF
	
	CASE c_SEEKService
		IF NOT IsValid(i_DWSRV_SEEK) THEN
			l_Object = FWCA.MGR.fu_GetDefault("Framework", "Seek")
			IF l_Object <> "" THEN
				i_DWSRV_SEEK = Create Using l_Object
				IF NOT IsValid(i_DWSRV_SEEK) THEN
					l_Return = c_Fatal
				ELSE
					i_DWSRV_SEEK.i_ServiceDW = THIS
				END IF
			ELSE
				l_Return = c_Fatal
			END IF
		END IF
	
	CASE c_CTRLService
		IF NOT IsValid(i_DWSRV_CTRL) THEN
			l_Object = FWCA.MGR.fu_GetDefault("Framework", "Control")
			IF l_Object <> "" THEN
				i_DWSRV_CTRL = Create Using l_Object
				IF NOT IsValid(i_DWSRV_CTRL) THEN
					l_Return = c_Fatal
				ELSE
					IF NOT IsValid(FWCA.MENU) THEN
						FWCA.MGR.fu_CreateManagers(FWCA.c_MenuManager)
					END IF
					i_DWSRV_CTRL.i_ServiceDW = THIS
					i_DWSRV_CTRL.fu_InitMenu()
					i_DWSRV_CTRL.fu_InitButton()
					IF IsValid(SECCA.MGR) THEN
						i_DWSRV_CTRL.fu_SecureControls()
					END IF
				END IF
			ELSE
				l_Return = c_Fatal
			END IF
		END IF
	
	CASE c_CUESService
		IF NOT IsValid(i_DWSRV_CUES) THEN
			l_Object = FWCA.MGR.fu_GetDefault("Framework", "Cues")
			IF l_Object <> "" THEN
				i_DWSRV_CUES = Create Using l_Object
				IF NOT IsValid(i_DWSRV_CUES) THEN
					l_Return = c_Fatal
				ELSE
					i_DWSRV_CUES.i_ServiceDW = THIS
					IF i_ViewModeBorder <> c_ViewModeBorderUnchanged OR &
						IsNull(i_ViewModeColor) = FALSE THEN
						i_DWSRV_CUES.fu_BuildViewMode(i_ViewModeColor, i_ViewModeBorder)
					END IF

					IF IsNull(i_InactiveColor) = FALSE THEN
						i_DWSRV_CUES.fu_BuildInactiveMode(i_InactiveColor, i_InactiveText, &
			                                 	    i_InactiveCol, i_InactiveLine)
					END IF
				END IF
			ELSE
				l_Return = c_Fatal
			END IF
		END IF

END CHOOSE

RETURN l_Return
end function

public function integer fu_select (string event_name, long select_row, string select_col, boolean ctrl_key, boolean shift_key);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Select
//  Description   : Processes a row/column selection.
//
//  Parameters    : STRING    Event_Name -
//                     The event this function was called from.
//                  LONG      Select_Row -
//                     The row that was requested.
//                  STRING    Select_Col -
//                     The column name that was requested.
//                  BOOLEAN   CTRL_Key -
//                     Was the control key depressed.
//                  BOOLEAN   SHIFT_Key -
//                     Was the shift key depressed.
//
//  Return Value  : INTEGER -
//                      0 - row/column processed.
//                     -1 - row/column process failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

BOOLEAN l_RowChanged, l_ColChanged, l_DoPickedRow, l_SetRedrawOff
BOOLEAN l_HaveInstances, l_SameRow
STRING  l_ColType, l_EventName
INTEGER l_ColNbr, l_Return, l_RefreshMode, l_ChildrenBefore
INTEGER l_ChildrenAfter
LONG    l_Idx, l_BeginRow, l_EndRow, l_RowCount
POWEROBJECT l_Container
DATAWINDOW l_DW

//------------------------------------------------------------------
//  Determine if a valid row was given or if the DataWindow has an
//  empty row or if the DataWindow is in QUERY mode.
//------------------------------------------------------------------

l_SetRedrawOff = FALSE
IF select_row = 0 OR i_IsEmpty OR i_IsQuery THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  If the selection method is c_SelectOnScroll, then emulate the
//  selection method so that a scroll causes a row to be selected.
//  If c_SelectOnRowFocusChange is the selection method and we
//  get a Click or DoubleClick, treat it as a RFC and ignore any
//  RFC that might follow the Click or Doubleclick.
//------------------------------------------------------------------

l_EventName = event_name
IF l_EventName = c_SelectOnScroll THEN
	l_EventName = i_SelectMethod
ELSE
	IF i_SelectMethod = c_SelectOnRowFocusChange THEN
		IF (l_EventName = c_SelectOnClick OR &
			l_EventName = c_SelectOnDoubleClick) AND &
			i_PresentationStyle <> c_FreeFormStyle THEN
			l_EventName = i_SelectMethod
		ELSE
			l_RowCount = RowCount()
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Determine if we have changed the row and/or the column.
//------------------------------------------------------------------

IF select_row = i_CursorRow THEN
	l_SameRow = TRUE
END IF

IF select_row <> i_CursorRow OR &
	(i_HighlightMethod = c_ShowHighlight AND NOT IsSelected(i_CursorRow) AND i_PresentationStyle = c_TabularFormStyle) OR &
	l_EventName = c_SelectOnDoubleClick OR &
	event_name = c_SelectOnDoubleClick OR &
   (IsSelected(select_row) AND ctrl_key) OR &
	(IsSelected(select_row) AND i_MultiSelect) THEN
	l_RowChanged = TRUE
END IF

IF select_col <> i_CursorCol AND select_col <> "" THEN
	l_ColChanged = TRUE
END IF

IF NOT l_RowChanged AND NOT l_ColChanged THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  If the selection method matches the event this function was
//  called from, determine if a new row/column may be selected.
//------------------------------------------------------------------

l_Return = c_Success
l_DoPickedRow = TRUE
i_RequestMode = c_SameMode
IF i_SelectMethod = l_EventName OR &
	l_EventName = c_SelectOnDoubleClick OR &
	event_name = c_SelectOnDoubleClick THEN

	IF IsValid(i_DWSRV_EDIT) AND i_SelectMethod = l_EventName THEN

		//------------------------------------------------------------
		//  Determine if the column is a computed column.
		//------------------------------------------------------------

		l_ColType = Upper(Describe(select_col + ".type"))
		IF l_ColType <> "COMPUTE" THEN
			l_ColNbr = Integer(Describe(select_col + ".id"))
		END IF

		//------------------------------------------------------------
		//  Determine if validation should be done on a column change.
		//------------------------------------------------------------

		IF (l_ColChanged OR l_RowChanged) AND NOT i_IgnoreVal AND &
			i_CurrentMode <> c_ViewMode THEN
			IF AcceptText() <> 1 THEN
				RETURN c_Fatal
			END IF
		END IF

		//------------------------------------------------------------
		//  Determine if validation should be done on a row change.
		//------------------------------------------------------------

		IF l_RowChanged AND select_row <> i_CursorRow AND &
			i_CurrentMode <> c_ViewMode THEN
			IF i_CursorRow > 0 THEN
				IF i_DWSRV_EDIT.fu_ValidateRow(i_CursorRow) <> c_Success THEN
					i_IgnoreRFC = TRUE
					i_IgnoreVal = TRUE
					ScrollToRow(i_CursorRow)
					i_IgnoreRFC = FALSE
					i_IgnoreVal = FALSE
					l_Return = c_Fatal
					GOTO Finished
				END IF
			END IF
		END IF
	END IF
		
	//---------------------------------------------------------------
	//  If the row has changed and this DataWindow is part of a 
	//  unit-of-work and it has children, then check the children for
 	//  changes and save the children if requested.  
	//---------------------------------------------------------------

	IF l_RowChanged AND IsValid(i_DWSRV_UOW) AND &
		i_SelectMethod = l_EventName THEN
		IF NOT i_DWSRV_UOW.fu_CheckInstance(THIS) AND &
			NOT i_DWSRV_UOW.fu_FindShare(THIS) THEN
			l_SetRedrawOff = TRUE
			fu_SetRedraw(c_Off)
			i_IgnoreVal = TRUE
			IF i_DWSRV_UOW.fu_Save(THIS, c_PromptChanges, c_CheckChildren) &
				<> c_Success THEN
				i_IgnoreRFC = TRUE
				i_IgnoreVal = TRUE
				ScrollToRow(i_CursorRow)
				i_IgnoreRFC = FALSE
				i_IgnoreVal = FALSE
				l_Return = c_Fatal
				GOTO Finished
			END IF
			i_IgnoreVal = FALSE
		ELSE
			IF i_DWSRV_UOW.fu_ValidateUOW() <> c_Success THEN
				i_IgnoreRFC = TRUE
				i_IgnoreVal = TRUE
				ScrollToRow(i_CursorRow)
				i_IgnoreRFC = FALSE
				i_IgnoreVal = FALSE
				l_Return = c_Fatal
				GOTO Finished
			END IF
		END IF
	END IF

	//---------------------------------------------------------------
	//  Set the selected row and column.  
	//---------------------------------------------------------------

	i_CursorRow = select_row
	i_CursorCol = select_col

	IF l_RowChanged THEN
		IF i_SelectMethod = l_EventName THEN
			IF i_MultiSelect AND ctrl_key THEN
				IF IsSelected(select_row) THEN
					SelectRow(select_row, FALSE)
					i_AnchorRow = 0
				ELSE
					IF i_HighlightMethod = c_ShowHighlight THEN
						SelectRow(select_row, TRUE)
					END IF
					i_AnchorRow = select_row
				END IF

			ELSEIF i_MultiSelect AND shift_key THEN
				IF i_AnchorRow > 0 THEN
					IF select_row >= i_AnchorRow THEN
						l_BeginRow = i_AnchorRow
						l_EndRow   = select_row
					ELSE
						l_EndRow   = i_AnchorRow
						l_BeginRow = select_row
					END IF

					SelectRow(0, FALSE)

					IF i_HighlightMethod = c_ShowHighlight THEN
						FOR l_Idx = l_BeginRow TO l_EndRow
							SelectRow(l_Idx, TRUE)
						NEXT
					ELSE
						IF select_row >= i_AnchorRow THEN
							i_CursorRow = l_EndRow
						ELSE
							i_CursorRow = l_BeginRow
						END IF
					END IF
				ELSE
					SelectRow(0, FALSE)
					IF i_HighlightMethod = c_ShowHighlight THEN
						SelectRow(select_row, TRUE)
					END IF
				END IF

			ELSE
				IF i_HighlightMethod = c_ShowHighlight THEN
					IF IsSelected(select_row) AND ctrl_key THEN
						SelectRow(select_row, FALSE)
					ELSE
						SelectRow(0, FALSE)
						SelectRow(select_row, TRUE)
					END IF
				END IF
				i_AnchorRow = select_row
			END IF
		END IF

		//------------------------------------------------------------
		//  Update the selected row variables.
		//------------------------------------------------------------
	
		i_NumSelected = fu_GetSelectedRows(i_SelectedRows[])

		//------------------------------------------------------------
		//  Determine if we have a multiple instance situation.  If 
		//  so, any selection method should cause a new instance to
		//  be created.
		//------------------------------------------------------------

		l_HaveInstances = FALSE
		IF IsValid(i_DWSRV_UOW) THEN
			l_ChildrenBefore = i_DWSRV_UOW.fu_GetChildrenCnt(THIS)
			IF i_DWSRV_UOW.fu_CheckInstance(THIS) THEN
				l_HaveInstances = TRUE
				SetNull(l_DW)
				i_DWSRV_UOW.fu_SetInstance(l_DW)
			END IF
		END IF

		//------------------------------------------------------------
		//  Determine if security allows us to drill down.  If OK,
		//  determine if the combination of the selection method and
		//  the drill down method allow us to drill down.  If OK,
  		//  execute pcd_PickedRow.
		//------------------------------------------------------------

		IF i_PLAllowDrillDown THEN
			IF (i_SelectMethod = c_SelectOnClick AND NOT i_AllowDrillDown AND NOT l_HaveInstances) OR &
 				(i_SelectMethod = c_SelectOnRowFocusChange AND NOT i_AllowDrillDown AND NOT l_HaveInstances) OR &
				(l_EventName = c_SelectOnDoubleClick AND (i_PresentationStyle <> c_FreeFormStyle OR &
				(i_PresentationStyle = c_FreeFormStyle AND l_RowCount > 1))) OR &
				(event_name = c_SelectOnDoubleClick AND &
				(i_PresentationStyle <> c_FreeFormStyle OR &
				(i_PresentationStyle = c_FreeFormStyle AND l_RowCount > 1))) THEN

				//------------------------------------------------------
				//  If we are part of a unit-of-work, check to see if
				//  selected row is already opened as an instance.  If
				//  so, don't trigger pcd_PickedRow to open another
				//  instance.
				//------------------------------------------------------

				IF IsValid(i_DWSRV_UOW) THEN
					IF l_HaveInstances THEN
						IF i_DWSRV_UOW.fu_FindInstance(THIS, select_row) THEN
							l_DoPickedRow = FALSE
						END IF
					END IF
				END IF

				IF l_DoPickedRow THEN
					i_FromPickedRow = TRUE
					THIS.Event pcd_PickedRow(i_NumSelected, i_SelectedRows[])
	
					//---------------------------------------------------
					//  If the developer closed the window this
					//  DataWindow is on during the pcd_PickedRow
					//  event then the remaining code is not valid and
					//  should be skipped.  
					//---------------------------------------------------
	
					IF NOT IsValid(THIS) THEN
						RETURN 0
					END IF

					i_FromPickedRow = FALSE
					IF Error.i_FWError <> c_Success THEN
						l_Return = c_Fatal
						GOTO Finished
					END IF
				END IF
			END IF
		END IF
	
	ELSE

		//------------------------------------------------------------
		//  Update the selected row variables.  
		//------------------------------------------------------------
	
		i_NumSelected = fu_GetSelectedRows(i_SelectedRows[])

	END IF

	//---------------------------------------------------------------
	//  If multiselect is on, determine how to refresh the children.  
	//---------------------------------------------------------------
	
	l_RefreshMode = c_RefreshChildren
	IF i_NumSelected > 0 AND i_MultiSelect THEN
		IF i_MultiSelectMethod = c_RefreshOnSelect THEN
			IF i_NumSelected > 1 THEN
				l_RefreshMode = c_ResetChildren
			END IF
		ELSEIF i_MultiSelectMethod = c_NoAutoRefresh THEN
			l_RefreshMode = c_ResetChildren
		END IF
	END IF

	//---------------------------------------------------------------
	//  If the row has changed and this DataWindow is part of a 
	//  unit-of-work, then handle other DataWindows.  
	//---------------------------------------------------------------

	IF l_RowChanged AND IsValid(i_DWSRV_UOW) AND &
		((l_EventName = i_SelectMethod AND NOT l_HaveInstances) OR &
		(l_EventName = c_SelectOnDoubleClick AND (i_PresentationStyle <> c_FreeFormStyle OR &
		(i_PresentationStyle = c_FreeFormStyle AND l_RowCount > 1))) OR &
		(event_name = c_SelectOnDoubleClick AND (i_PresentationStyle <> c_FreeFormStyle OR &
		(i_PresentationStyle = c_FreeFormStyle AND l_RowCount > 1)))) THEN

		//------------------------------------------------------------
		//  If this DataWindow has children, then refresh the children.  
		//------------------------------------------------------------

		IF l_DoPickedRow THEN
			l_ChildrenAfter = i_DWSRV_UOW.fu_GetChildrenCnt(THIS)

			IF l_SameRow AND l_ChildrenBefore <> l_ChildrenAfter THEN
				l_RefreshMode = c_RefreshOnOpenChildren
			END IF

			IF NOT l_SameRow OR &
				l_ChildrenBefore <> l_ChildrenAfter OR &
				l_HaveInstances OR &
				((IsSelected(select_row) OR &
				i_HighlightMethod = c_HideHighlight) AND &
				l_RowChanged) THEN
				IF event_name <> c_SelectOnRowFocusChange THEN
					i_IgnoreRFC = TRUE
					i_IgnoreVal = TRUE
					IF l_ColChanged AND l_ColNbr > 0 THEN
						SetColumn(l_ColNbr)
					END IF
					ScrollToRow(i_CursorRow)
					i_IgnoreRFC = FALSE
					i_IgnoreVal = FALSE
				END IF
				IF i_DWSRV_UOW.fu_Refresh(THIS, l_RefreshMode, &
					c_SameMode) <> c_Success THEN
					i_IgnoreRFC = TRUE
					i_IgnoreVal = TRUE
					ScrollToRow(i_CursorRow)
					i_IgnoreRFC = FALSE
					i_IgnoreVal = FALSE
					l_Return = c_Fatal
					GOTO Finished
				END IF
			END IF
		END IF
	END IF

ELSE

	i_CursorRow = select_row
	i_CursorCol = select_col

END IF

//------------------------------------------------------------------
//  Set the new cursor row/column.
//------------------------------------------------------------------

IF event_name <> c_SelectOnRowFocusChange THEN
	i_IgnoreRFC = TRUE
	i_IgnoreVal = TRUE
	IF l_ColChanged AND l_ColNbr > 0 THEN
		SetColumn(l_ColNbr)
	END IF
	ScrollToRow(i_CursorRow)
	i_IgnoreRFC = FALSE
	i_IgnoreVal = FALSE
END IF

//------------------------------------------------------------------
//  If this DataWindow is a share, scroll its parent to the
//  same row as this DataWindow.  Additional tests must be made just
//  in case (1) a dynamically created container object is being used
//  and (2) is the sharing datawindow on the same window as
//  its parent or on another window.
//------------------------------------------------------------------

l_Container = Parent
IF l_Container.TypeOf() = UserObject! THEN
	IF l_Container.TriggerEvent("po_identify") = 1 THEN
		IF l_Container.DYNAMIC fu_GetIdentity() = "Container" THEN
			i_InOpenOfShare = FALSE
		END IF
	END IF
END IF

IF i_ShareData THEN
	IF i_ParentDW.i_Window = i_Window THEN
		i_InOpenOfShare = FALSE
	END IF
	IF NOT i_InOpenOfShare THEN
		i_IgnoreRFC = TRUE
		i_IgnoreVal = TRUE
		IF l_ColChanged AND l_ColNbr > 0 THEN
			SetColumn(l_ColNbr)
		END IF
		i_ParentDW.ScrollToRow(i_CursorRow)
		i_IgnoreRFC = FALSE
		i_IgnoreVal = FALSE
	ELSE
		i_InOpenOfShare = FALSE
	END IF
END IF

l_Return = c_Success

Finished:

//------------------------------------------------------------------
//  If we are moving to or from the first or last rows using a
//  click or RFC and the menu/button service is avaliable, then 
//  enable/disable the scroll and mode items appropriately.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CTRL) THEN
	IF event_name <> c_SelectOnScroll THEN
		IF FWCA.MGR.i_WindowCurrentDW = THIS THEN
			i_DWSRV_CTRL.fu_SetControl(c_AllControls)
		END IF
	END IF
END IF

IF l_SetRedrawOff AND i_SetRedrawCnt > 0 THEN
	fu_SetRedraw(c_On)
END IF

RETURN l_Return
end function

public function string fu_getmode ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetMode
//  Description   : Return the current mode for this DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : STRING -
//                     The mode this DataWindow is in.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN i_CurrentMode

end function

public function integer fu_swap (string do_name, integer changes, string options);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Swap
//  Description   : Swap the dataobject on this DataWindow.
//
//  Parameters    : STRING  DO_Name -
//                     The name of the DataWindow object.
//                  INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//                  STRING  Options -
//                     Specifies options for how this DataWindow
//                     is to behave.
//
//  Return Value  : INTEGER -
//                      0 - swap operation successful.
//                     -1 - swap operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return

//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If it
//  is then handle the changes.  If not, handle the changes for this
//  DataWindow only.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_UOW) THEN
	IF i_DWSRV_UOW.fu_Save(THIS, changes, c_CheckAll) <> c_Success THEN
      RETURN c_Fatal
	END IF
ELSE
	IF IsValid(i_DWSRV_EDIT) THEN
		IF i_DWSRV_EDIT.fu_Save(changes) <> c_Success THEN
			RETURN c_Fatal
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

l_Return = c_Success

//------------------------------------------------------------------
//  Swap the data object.
//------------------------------------------------------------------

fu_SetRedraw(c_Off)
DataObject = do_name

//------------------------------------------------------------------
//  Reset the initial options and set the new options.
//------------------------------------------------------------------

fu_InitOptions()

i_InSwap = TRUE
IF fu_SetOptions(i_DBCA, i_ParentDW, options) <> c_Success THEN
	l_Return = c_Fatal
END IF
i_InSwap = FALSE

//------------------------------------------------------------------
//  Set redraw back on.
//------------------------------------------------------------------

fu_SetRedraw(c_On)

RETURN l_Return
end function

public function integer fu_setupdate (string table_name, string key_names[], string update_names[]);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SetUpdate
//  Description   : Set the update information prior to doing an
//                  UPDATE call.  This function is typically used
//                  by the developer to do multi-table updates.
//
//  Parameters    : STRING Table_Name -
//                     Name of the table to update.
//                  STRING Key_Names[] -
//                     Array of column names that are key columns.
//                  STRING Update_Names[] -
//                     Array of column names to update.
//
//  Return Value  : INTEGER -
//                      0 - update information set successful.
//                     -1 - update information set failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the update function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_SetUpdate(table_name, key_names[], update_names[])

end function

public function integer fu_insert (long start_row, long num_rows);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Insert
//  Description   : Inserts records to the DataWindow.
//
//  Parameters    : LONG    Start_Row -
//                     Row number to insert rows in front of.
//                  LONG    Num_Rows -
//                     Number of records to add.
//
//  Return Value  : INTEGER -
//                      0 - insert operation successful.
//                     -1 - insert operation failed or not available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_FoundInstances, l_FoundShare
DATAWINDOW l_DW

//------------------------------------------------------------------
//  If this is an instance DataWindow then create the new
//  instance from the parent routine.
//------------------------------------------------------------------

IF i_IsInstance THEN

	IF i_ParentDW.fu_Insert(start_row, num_rows) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF

ELSE

	//---------------------------------------------------------------
	//  If the edit service has not been started, check to see if
	//  c_EnableNewOnOpen is set.  If it is then there may be 
	//  children DataWindows that allow new.
	//---------------------------------------------------------------

	IF IsValid(i_DWSRV_EDIT) THEN

		RETURN i_DWSRV_EDIT.fu_New(start_row, num_rows)

	ELSE
	
		IF i_PLAllowDrillDown AND i_EnableNewOnOpen THEN

			Error.i_FWError = c_Success
			i_RequestMode = c_NewMode

			//---------------------------------------------------------
			//  If only one selected record is possible and a record is 
			//  already selected then clear the selection, saving 
			//  changes if needed.
			//---------------------------------------------------------

			l_FoundInstances = FALSE
			l_FoundShare = FALSE
			IF IsValid(i_DWSRV_UOW) THEN
				l_FoundInstances = i_DWSRV_UOW.fu_CheckInstance(THIS)
				l_FoundShare = i_DWSRV_UOW.fu_FindShare(THIS)
				IF i_DWSRV_UOW.i_InModeChange THEN
					GOTO Finished
				END IF
			END IF

			IF l_FoundInstances THEN
				SelectRow(0, FALSE)
				i_NumSelected = 0
				SetNull(l_DW)
				i_DWSRV_UOW.fu_SetInstance(l_DW)
			ELSE
				IF NOT i_MultiSelect AND i_NumSelected > 0 AND NOT l_FoundShare THEN
					IF fu_ClearSelectedRows(c_PromptChanges) <> c_Success THEN
						Error.i_FWError = c_Fatal
						GOTO Finished
					END IF
				END IF
			END IF
	
			//---------------------------------------------------------
			//  Trigger pcd_PickedRow to see if there are children that 
			//  can add records.
			//---------------------------------------------------------

			i_FromPickedRow = TRUE
			THIS.Event pcd_PickedRow(i_NumSelected, i_SelectedRows[])

			//---------------------------------------------------------
			//  If the developer closed the window this
			//  DataWindow is on during the pcd_PickedRow
			//  event then the remaining code is not valid and
			//  should be skipped.  
			//---------------------------------------------------------
	
			IF NOT IsValid(THIS) THEN
				RETURN 0
			END IF

			i_FromPickedRow = FALSE
			IF Error.i_FWError <> c_Success THEN
				GOTO Finished
			END IF

			//---------------------------------------------------------
			//  Now determine if a unit-of-work was created.  If so, 
			//  execute the new function in the unit-of-work to process
			//  the child DataWindows.
			//---------------------------------------------------------

			IF IsValid(i_DWSRV_UOW) THEN
				IF i_DWSRV_UOW.fu_New(THIS, start_row, num_rows) <> c_Success THEN
      			Error.i_FWError = c_Fatal
				END IF
			END IF
		END IF

		Finished:

		//------------------------------------------------------------------
		//  If this function was not called from an event, trigger the
		//  pcd_New event for the developer to be consistent.
		//------------------------------------------------------------------

		IF NOT i_FromEvent THEN
			i_InProcess = TRUE
			THIS.TriggerEvent("pcd_New")
			i_InProcess = FALSE
		END IF
	END IF
END IF

RETURN Error.i_FWError
end function

public function integer fu_allowcontrol (integer control_type, boolean control_state);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_AllowControl
//  Description   : Indicates whether PowerClass should control the
//                  enabling and disabling of a menu or button item.
//
//  Parameters    : INTEGER Control_Type -
//                     Menu and/or button to control (e.g. c_New).
//                  BOOLEAN Control_State -
//                     PowerClass controlled (TRUE) or not (FALSE).
//
//  Return Value  : INTEGER -
//                      0 - control state set successful.
//                     -2 - no service available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the menu/button control service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_CTRL) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the allow control function in the menu/button service.
//------------------------------------------------------------------

i_DWSRV_CTRL.fu_AllowControl(control_type, control_state)

RETURN c_Success
end function

public subroutine fu_setredraw (integer status);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_SetRedraw
//  Description   : Buffer multiple SetRedraw calls to reduce the
//                  flashing that could occur when executing
//                  multiple processes at once.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

IF status = c_Off THEN
	IF i_SetRedrawCnt = 0 THEN
		SetRedraw(FALSE)
	END IF
	i_SetRedrawCnt = i_SetRedrawCnt + 1
ELSE
	i_SetRedrawCnt = i_SetRedrawCnt - 1
	IF i_SetRedrawCnt = 0 THEN
		SetRedraw(TRUE)
	END IF
END IF
end subroutine

public function integer fu_saveonclose (window close_window);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SaveOnClose
//  Description   : Save the DataWindows prior to closing.
//
//  Parameters    : WINDOW Close_Window -
//                     The window that is closing.
//
//  Return Value  : INTEGER -
//                      0 - save operation successful.
//                     -1 - save operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return

//------------------------------------------------------------------
//  If a unit-of-work is available then let it know that we are in
//  a closing process so the DataWindow can determine if a refresh
//  parent should execute.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_UOW) THEN
	i_DWSRV_UOW.i_InClose = TRUE
	i_DWSRV_UOW.i_CloseWindow = close_window
END IF

//------------------------------------------------------------------
//  Call the save record function.
//------------------------------------------------------------------

l_Return = fu_Save(c_SaveChanges)

IF l_Return = c_NoService THEN
	IF IsValid(i_DWSRV_UOW) THEN
		RETURN i_DWSRV_UOW.fu_Save(THIS, c_SaveChanges, c_CheckAll)
	ELSE
		RETURN l_Return
	END IF
ELSE
	RETURN l_Return
END IF
end function

public function integer fu_open ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Open
//  Description   : Initializes the DataWindow.
//
//  Parameters    : POWEROBJECT Container_Name -
//                     Window or user object the DataWindow resides
//                     on.
//                  BOOLEAN     Window_Sheet -
//                     Is this DataWindow on an MDI sheet.
//
//  Return Value  : INTEGER -
//                      0 - initialization successful.
//                     -1 - initialization failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING      l_ErrorStrings[]

//------------------------------------------------------------------
//  Allow the developer to set the DataWindow options.
//------------------------------------------------------------------

THIS.TriggerEvent("pcd_SetOptions")

IF Error.i_FWError <> c_Success THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_Window.ClassName()
   l_ErrorStrings[4] = ClassName()
   l_ErrorStrings[5] = "pcd_SetOptions"
   FWCA.MSG.fu_DisplayMessage("WindowOpenError", &
                               5, l_ErrorStrings[])
   RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  The pcd_SetCodeTables event is used to load any code tables 
//  located on the DataWindow. This event is coded by the developer.
//------------------------------------------------------------------

THIS.Event pcd_SetCodeTables(i_DBCA)

IF Error.i_FWError <> c_Success THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_Window.ClassName()
   l_ErrorStrings[4] = ClassName()
   l_ErrorStrings[5] = "pcd_SetCodeTables"
 	FWCA.MSG.fu_DisplayMessage("WindowOpenError", &
                              5, l_ErrorStrings[])
 	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Indicate that we are no longer in the open process.
//------------------------------------------------------------------

i_InOpen = FALSE

RETURN c_Success
end function

public function integer fu_setpopup (menu menu_name);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_SetPopup
//  Description   : Specifies a menu to be used as a popup menu.
//
//  Parameters    : MENU Menu_Name -
//                     The POPUP menu that is to be used by the 
//                     DataWindow.  
//
//  Return Value  : INTEGER -
//                      0 = popup created.
//                     -1 = popup creation failed or not found.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = c_Fatal

//------------------------------------------------------------------
//  If the passed POPUP menu is valid, then just remember it.
//------------------------------------------------------------------

IF IsValid(menu_name) THEN
   i_PopupID = menu_name
	l_Return = c_Success
END IF

RETURN l_Return
end function

public subroutine fu_setsqlselect (string sqlselect_name);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_SetSQLSelect
//  Description   : Sets the i_SQLSelect variable.
//
//  Parameters    : STRING SQLSelect_Name
//                     The SQL SELECT statement.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_SQLSelect = sqlselect_name

end subroutine

public subroutine fu_setfilter (string filter_name);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_SetFilter
//  Description   : Sets the i_Filter variable.
//
//  Parameters    : STRING Filter_Name
//                     The Filter statement.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_Filter = filter_name

end subroutine

public function string fu_getfilter ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetFilter
//  Description   : Gets the original filter statement from the
//                  i_Filter variable.
//
//  Parameters    : (None)
//
//  Return Value  : STRING -
//                     Original filter statement.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN i_Filter

end function

public function string fu_getsqlselect ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetSQLSelect
//  Description   : Gets the original SQL statement from the
//                  i_SQLSelect variable.
//
//  Parameters    : (None)
//
//  Return Value  : STRING -
//                     Original SQL statement.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN i_SQLSelect

end function

public function boolean fu_checkchangesuow ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_CheckChangesUOW
//  Description   : Check all the DataWindows in the unit-of-work
//                  for changes.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     TRUE  - there are changes.
//                     FALSE - there are no changes.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the unit-of-work service has not been started, check for
//  changes on this DataWindow only.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_UOW) THEN
	RETURN fu_CheckChanges()
END IF

//------------------------------------------------------------------
//  Call the checkchanges function in the unit-of-work service.
//------------------------------------------------------------------

RETURN i_DWSRV_UOW.fu_CheckChangesUOW()

end function

public subroutine fu_resetupdateuow ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ResetUpdateUOW
//  Description   : Reset the update flags for all the DataWindows
//                  in the unit-of-work.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the unit-of-work service has not been started, then reset
//  updates for this DataWindow only.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_UOW) THEN
	fu_ResetUpdate()
	RETURN
END IF

//------------------------------------------------------------------
//  Call the resetupdate function in the unit-of-work service.
//------------------------------------------------------------------

i_DWSRV_UOW.fu_ResetUpdateUOW()

end subroutine

public subroutine fu_resetupdate ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ResetUpdate
//  Description   : Reset the update flags for this DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Call the resetupdate function in the edit service.
//------------------------------------------------------------------

i_DWSRV_EDIT.fu_ResetUpdate()

end subroutine

public function integer fu_wiredrag (string drag_columns[], integer drag_method, datawindow drop_dw);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_WireDrag
//  Description   : Wire this DataWindow to the drop DataWindow.
//
//  Parameters    : STRING     Drag_Columns -
//                     Columns in this DataWindow to get the
//                     values from.
//                  INTEGER    Drag_Method -
//                     Method to use in the drag operation.  Values
//                     are:
//                         c_CopyRows
//                         c_MoveRows
//                  DATAWINDOW Drop_DW -
//                     DataWindow to drop the records on.
//
//  Return Value  : INTEGER -
//                     0 - wire successful.
//                    -2 - no EDIT service.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the WireDrag function in the edit service.
//------------------------------------------------------------------

i_DWSRV_EDIT.fu_WireDrag(drag_columns[], drag_method, drop_dw)

RETURN c_Success
end function

public function integer fu_wiredrop (string drop_columns[]);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_WireDrop
//  Description   : Set the drop DataWindow columns.
//
//  Parameters    : STRING     Drop_Columns -
//                     Columns in this DataWindow to set the values
//                     into from the drag DataWindow.
//
//  Return Value  : INTEGER -
//                     0 - wire successful.
//                    -2 - no EDIT service.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************


//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the WireDrag function in the edit service.
//------------------------------------------------------------------

i_DWSRV_EDIT.fu_WireDrop(drop_columns[])

RETURN c_Success
end function

public function integer fu_setdragindicator (string single_row, string multiple_rows, string no_drop);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_SetDragIndicator
//  Description   : Set the drag icons for the various drag 
//                  situations.
//
//  Parameters    : STRING Single_Row -
//                     Icon for a single row drag.
//                  STRING Multiple_Rows -
//                     Icon for dragging multiple rows.
//                  STRING No_Drop -
//                     Icon to indicate that dropping is not
//                     allowed on the current control.
//
//  Return Value  : INTEGER -
//                     0 - wire successful.
//                    -2 - no EDIT service.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the SetDragIndicator function in the edit service.
//------------------------------------------------------------------

i_DWSRV_EDIT.fu_SetDragIndicator(single_row, multiple_rows, no_drop)

RETURN c_Success
end function

public function integer fu_copy (long num_rows, long copy_rows[], integer changes);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_Copy
//  Description   : Copies the records in the DataWindow.
//
//  Parameters    : LONG    Num_Rows -
//                     Number of records to copy.
//                  LONG    Copy_Rows -
//                     Row numbers to copy.
//                  INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//
//  Return Value  : INTEGER -
//                      0 - copy operation successful.
//                     -1 - copy operation failed or not available.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the copy record function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_Copy(num_rows, copy_rows[], changes)

end function

public function integer fu_promptchanges ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_PromptChanges
//  Description   : There are changes and we need to find out the 
//                  user's response (save, abort, or cancel).  To do
//                  this, we highlight the DataWindow and then 
//                  display a message box asking for the user's
//  response..
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     The button pressed by the user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service has not been started, return.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_EDIT) THEN
	RETURN c_NoService
END IF

//------------------------------------------------------------------
//  Call the promptchanges function in the edit service.
//------------------------------------------------------------------

RETURN i_DWSRV_EDIT.fu_PromptChanges()

end function

public function integer fu_getsavestatus ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetSaveStatus
//  Description   : Return the button that was selected for the 
//                  save.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     0 - No save prompt was displayed.
//                     1 - save was done.
//                     2 - save was not done.
//                     3 - save was cancelled.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the unit-of-work service has not been started, get the status
//  from this DataWindow.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_UOW) THEN
	RETURN i_DWSRV_EDIT.fu_GetSaveStatus()
END IF

//------------------------------------------------------------------
//  Call the save status function in the unit-of-work service.
//------------------------------------------------------------------

RETURN i_DWSRV_UOW.fu_GetSaveStatus()

end function

public function integer fu_validateuow ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ValidateUOW
//  Description   : Validate all the DataWindows in the unit-of-work
//                  that have changes.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - validation operation successful.
//                     -1 - validation operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the unit-of-work service has not been started, validate
//  changes on this DataWindow only.
//------------------------------------------------------------------

IF NOT IsValid(i_DWSRV_UOW) THEN
	RETURN fu_Validate()
END IF

//------------------------------------------------------------------
//  Call the validate function in the unit-of-work service.
//------------------------------------------------------------------

RETURN i_DWSRV_UOW.fu_ValidateUOW()

end function

public function string fu_getrequestmode ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_GetRequestMode
//  Description   : Return the requested mode for this DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : STRING -
//                     The request mode this DataWindow is in.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN i_RequestMode

end function

public subroutine fu_setempty ();//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_SetEmpty
//  Description   : Display a free-form DataWindow as empty.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Objects, l_Object, l_Type, l_InitialValue, l_Attr
INTEGER l_Pos

//------------------------------------------------------------------
//  Make sure no DataWindow activity happens during this process.
//------------------------------------------------------------------

i_IgnoreRFC = TRUE
i_IgnoreVal = TRUE

//------------------------------------------------------------------
//  Clear the DataWindow by reseting it and inserting a row.
//------------------------------------------------------------------

Reset()
InsertRow(0)
i_IsEmpty = TRUE
fu_SetIndicatorRow()
IF IsValid(i_DWSRV_EDIT) THEN
	i_DWSRV_EDIT.i_HaveNew    = FALSE
	i_DWSRV_EDIT.i_HaveModify = FALSE
END IF

//------------------------------------------------------------------
//  If the visual cues service is avaliable then put the DataWindow
//  colors into "view" mode.
//------------------------------------------------------------------

IF IsValid(i_DWSRV_CUES) THEN
	i_DWSRV_CUES.fu_SetViewMode(c_On)
ELSE
	Modify("datawindow.readonly=yes")
END IF

//------------------------------------------------------------------
//  To prevent any initial values from showing in the columns, 
//  change the column text color to be the same as the background
//  color.  If we don't have the colors, get them now.
//------------------------------------------------------------------

IF NOT i_GotEmptyColors THEN
	i_NormalTextColors = ""
	i_EmptyTextColors = ""
	l_Objects = Describe("datawindow.objects")
	DO
		l_Pos = Pos(l_Objects, "~t")
		IF l_Pos > 0 THEN
			l_Object = MID(l_Objects, 1, l_Pos - 1)
			l_Objects = MID(l_Objects, l_Pos + 1)
		ELSE
			l_Object = l_Objects
			l_Objects = ""
		END IF
		IF Describe(l_Object + ".visible") <> "0" THEN
			l_Type = Upper(Describe(l_Object + ".type"))
			IF l_Type = "COLUMN" OR l_Type = "COMPUTE" THEN
				l_InitialValue = Describe(l_Object + ".initial")
				IF l_InitialValue <> "null" AND l_InitialValue <> "" AND &
					l_InitialValue <> "!" THEN

					l_Attr = Describe(l_Object + ".color")
					IF Pos(l_Attr, '"') = 1 THEN
						l_Attr = MID(l_Attr, 2, Len(l_Attr) - 2)
					END IF

					i_NormalTextColors = i_NormalTextColors + l_Object + &
                                 	".color='" + l_Attr + "'~t"

					l_Attr = Describe(l_Object + ".background.color")
					IF Pos(l_Attr, '"') = 1 THEN
						l_Attr = MID(l_Attr, 2, Len(l_Attr) - 2)
					END IF

					i_EmptyTextColors = i_EmptyTextColors + l_Object + &
                                		".color='" + l_Attr + "'~t"
				END IF
			END IF
		END IF
	LOOP UNTIL l_Objects = ""
	i_GotEmptyColors = TRUE
END IF

IF Len(i_EmptyTextColors) > 0 THEN
	Modify(i_EmptyTextColors)
END IF

//------------------------------------------------------------------
//  Restore normal DataWindow activity.
//------------------------------------------------------------------

i_IgnoreRFC = FALSE
i_IgnoreVal = FALSE

end subroutine

public function integer of_setresize (boolean ab_switch);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_SetResize
//	Arguments:		boolean
//   					true  - Start (create) the service
//   					false - Stop (destroy ) the service
//	Returns:			Integer - 1 if Successful operation, 0 = No action taken and -1 if an error occured
//	Description:	Starts or stops the DW Resize Services. 
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						6.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
// Check arguments
if IsNull(ab_switch) then return -1

if ab_Switch then
	if IsNull(inv_Resize) or not IsValid (inv_Resize) then
		inv_Resize = Create n_cst_dwsrv_resize
		inv_Resize.of_SetRequestor ( this )
		inv_Resize.of_SetOrigSize (this.Width, this.Height)
		return 1
	end if
else 
	if IsValid (inv_Resize) then
		Destroy inv_Resize
		return 1
	end if	
end if

return 0
end function

public subroutine fu_changeoptions (string options);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_ChangeOptions
//  Description   : Initializes or changes DataWindow options.
//
//  Parameters    : STRING     Options -
//                     Specifies options for how this DataWindow
//                     is to behave.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/28/98 Beth Byers	Test for a new refresh parent method option.
//								The user can specify refresh by retrieve, 
//								reselect, or auto (let powerclass decide if
//								reselect is possible)
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

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

public function boolean fu_checkoption (string option);//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_CheckOption
//  Description   : Checks to see if the given option is set.
//
//  Parameters    : STRING     Option -
//                     Option to check.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - option is set.
//                     FALSE - option is not set.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
// 10/28/98  Beth Byers	Added cases for the refresh parent method 
//                      option
// 10/11/2000 K. Claver Added cases for the c_NODeleteSaved and 
//								c_DeleteSavedOK
// 10/12/2000 K. Claver Added cases for the c_NOSortClicked and
//								c_SortClickedOK
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_Return

CHOOSE CASE option
	CASE c_ScrollSelf
		l_Return = (NOT i_ScrollParent)
	CASE c_ScrollParent
		l_Return = i_ScrollParent
   CASE c_IsNotInstance
	   l_Return = (NOT i_IsInstance)
   CASE c_IsInstance
	   l_Return = i_IsInstance
   CASE c_RequiredOnSave
	   l_Return = (NOT i_AlwaysCheckRequired)
   CASE c_AlwaysCheckRequired
	   l_Return = i_AlwaysCheckRequired
   CASE c_NoNew
	   l_Return = (NOT i_AllowNew)
   CASE c_NewOK
	   l_Return = i_AllowNew
   CASE c_NoModify
	   l_Return = (NOT i_AllowModify)
   CASE c_ModifyOK
	   l_Return = i_AllowModify
   CASE c_NoDelete
	   l_Return = (NOT i_AllowDelete)
	CASE c_DeleteOK
	   l_Return = i_AllowDelete
	CASE c_NoDeleteSaved
		l_Return = (NOT i_AllowDeleteSaved)
   CASE c_DeleteSavedOK
		l_Return = i_AllowDeleteSaved
   CASE c_NoQuery
	   l_Return = (NOT i_AllowQuery)
   CASE c_QueryOK
	   l_Return = i_AllowQuery
   CASE c_NoDrag
	   l_Return = (NOT i_AllowDrag)
   CASE c_DragOK
	   l_Return = i_AllowDrag
   CASE c_NoDrop
	   l_Return = (NOT i_AllowDrop)
   CASE c_DropOK
	   l_Return = i_AllowDrop
   CASE c_NoCopy
	   l_Return = (NOT i_AllowCopy)
   CASE c_CopyOK
	   l_Return = i_AllowCopy
   CASE c_SelectOnDoubleClick
	   l_Return = (i_SelectMethod = c_SelectOnDoubleClick)
   CASE c_SelectOnClick
	   l_Return = (i_SelectMethod = c_SelectOnClick)
   CASE c_SelectOnRowFocusChange
	   l_Return = (i_SelectMethod = c_SelectOnRowFocusChange)
   CASE c_NoDrillDown
	   l_Return = (NOT i_AllowDrillDown)
   CASE c_DrillDown
	   l_Return = i_AllowDrillDown
   CASE c_ParentModeOnSelect
	   l_Return = (i_ModeOnSelect = c_ParentModeOnSelect)
   CASE c_ViewOnSelect
	   l_Return = (i_ModeOnSelect = c_ViewOnSelect)
   CASE c_ModifyOnSelect
	   l_Return = (i_ModeOnSelect = c_ModifyOnSelect)
   CASE c_SameModeOnSelect
	   l_Return = (i_ModeOnSelect = c_SameModeOnSelect)
   CASE c_NoMultiSelect
	   l_Return = (NOT i_MultiSelect)
   CASE c_MultiSelect
	   l_Return = i_MultiSelect
   CASE c_RefreshOnSelect
	   l_Return = (i_MultiSelectMethod = c_RefreshOnSelect)
   CASE c_NoAutoRefresh
	   l_Return = (i_MultiSelectMethod = c_NoAutoRefresh)
   CASE c_RefreshOnMultiSelect
	   l_Return = (i_MultiSelectMethod = c_RefreshOnMultiSelect)
   CASE c_ViewOnOpen
	   l_Return = (i_ModeOnOpen = c_ViewOnOpen)
   CASE c_ModifyOnOpen
	   l_Return = (i_ModeOnOpen = c_ModifyOnOpen)
   CASE c_NewOnOpen
	   l_Return = (i_ModeOnOpen = c_NewOnOpen)
   CASE c_SameModeAfterSave
	   l_Return = (NOT i_ViewAfterSave)
   CASE c_ViewAfterSave
	   l_Return = i_ViewAfterSave
   CASE c_NoEnableModifyOnOpen
	   l_Return = (NOT i_EnableModifyOnOpen)
   CASE c_EnableModifyOnOpen
	   l_Return = i_EnableModifyOnOpen
   CASE c_NoEnableNewOnOpen
	   l_Return = (NOT i_EnableNewOnOpen)
   CASE c_EnableNewOnOpen
	   l_Return = i_EnableNewOnOpen
   CASE c_RetrieveOnOpen, c_AutoRetrieveOnOpen
	   l_Return = i_RetrieveOnOpen
   CASE c_NoRetrieveOnOpen
	   l_Return = (NOT i_RetrieveOnOpen)
   CASE c_RetrieveAll
	   l_Return = (NOT i_RetrieveAsNeeded)
   CASE c_RetrieveAsNeeded
	   l_Return = i_RetrieveAsNeeded
   CASE c_NoShareData
	   l_Return = (NOT i_ShareData)
   CASE c_ShareData
	   l_Return = i_ShareData
   CASE c_NoRefreshParent
	   l_Return = (NOT i_RefreshParent)
   CASE c_RefreshParent
	   l_Return = i_RefreshParent
   CASE c_NoRefreshChild
	   l_Return = (NOT i_RefreshChild)
   CASE c_RefreshChild
	   l_Return = i_RefreshChild
   CASE c_IgnoreNewRows
	   l_Return = i_IgnoreNewRows
   CASE c_NoIgnoreNewRows
	   l_Return = (NOT i_IgnoreNewRows)
   CASE c_NoNewModeOnEmpty
	   l_Return = (NOT i_NewModeOnEmpty)
   CASE c_NewModeOnEmpty
	   l_Return = i_NewModeOnEmpty
   CASE c_MultipleNewRows
	   l_Return = (NOT i_OnlyOneNewRow)
   CASE c_OnlyOneNewRow
	   l_Return = i_OnlyOneNewRow
   CASE c_DisableCC
	   l_Return = (NOT i_EnableCC)
   CASE c_EnableCC
	   l_Return = i_EnableCC
   CASE c_DisableCCInsert
	   l_Return = (NOT i_EnableCCInsert)
   CASE c_EnableCCInsert
	   l_Return = i_EnableCCInsert
   CASE c_EnablePopup
	   l_Return = i_EnablePopup
   CASE c_NoEnablePopup
	   l_Return = (NOT i_EnablePopup)
   CASE c_ViewModeBorderUnchanged
	   l_Return = (i_ViewModeBorder = c_ViewModeBorderUnchanged)
   CASE c_ViewModeNoBorder
	   l_Return = (i_ViewModeBorder = c_ViewModeNoBorder)
   CASE c_ViewModeShadowBox
	   l_Return = (i_ViewModeBorder = c_ViewModeShadowBox)
   CASE c_ViewModeBox
	   l_Return = (i_ViewModeBorder = c_ViewModeBox)
   CASE c_ViewModeResize
	   l_Return = (i_ViewModeBorder = c_ViewModeResize)
   CASE c_ViewModeUnderline
	   l_Return = (i_ViewModeBorder = c_ViewModeUnderline)
   CASE c_ViewModeLowered
	   l_Return = (i_ViewModeBorder = c_ViewModeLowered)
   CASE c_ViewModeRaised
	   l_Return = (i_ViewModeBorder = c_ViewModeRaised)
   CASE c_ViewModeColorUnchanged
	   l_Return = (IsNull(i_ViewModeColor) <> FALSE)
   CASE c_ViewModeBlack
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_Black)       
   CASE c_ViewModeWhite
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_White)       
   CASE c_ViewModeGray
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_Gray)       
   CASE c_ViewModeDarkGray
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_DarkGray)       
   CASE c_ViewModeRed
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_Red)       
   CASE c_ViewModeDarkRed
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_DarkRed)       
   CASE c_ViewModeGreen
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_Green)       
   CASE c_ViewModeDarkGreen
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_DarkGreen)      
   CASE c_ViewModeBlue
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_Blue)       
   CASE c_ViewModeDarkBlue
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_DarkBlue)       
   CASE c_ViewModeMagenta
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_Magenta)       
   CASE c_ViewModeDarkMagenta
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_DarkMagenta)       
   CASE c_ViewModeCyan
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_Cyan)       
   CASE c_ViewModeDarkCyan
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_DarkCyan)       
   CASE c_ViewModeYellow
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_Yellow)       
   CASE c_ViewModeBrown
	   l_Return = (i_ViewModeColor = OBJCA.MGR.c_DarkYellow)       
   CASE c_InactiveColorUnchanged
	   l_Return = (IsNull(i_InactiveColor) <> FALSE) 
   CASE c_InactiveBlack
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_Black)       
   CASE c_InactiveWhite
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_White)       
   CASE c_InactiveGray
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_Gray)       
   CASE c_InactiveDarkGray
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_DarkGray)       
   CASE c_InactiveRed
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_Red)       
   CASE c_InactiveDarkRed
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_DarkRed)       
   CASE c_InactiveGreen
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_Green)       
   CASE c_InactiveDarkGreen
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_DarkGreen)      
   CASE c_InactiveBlue
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_Blue)       
   CASE c_InactiveDarkBlue
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_DarkBlue)       
   CASE c_InactiveMagenta
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_Magenta)       
   CASE c_InactiveDarkMagenta
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_DarkMagenta)       
   CASE c_InactiveCyan
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_Cyan)       
   CASE c_InactiveDarkCyan
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_DarkCyan)       
   CASE c_InactiveYellow
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_Yellow)       
   CASE c_InactiveBrown
	   l_Return = (i_InactiveColor = OBJCA.MGR.c_DarkYellow)       
   CASE c_InactiveText
	   l_Return = i_InactiveText
   CASE c_NoInactiveText
	   l_Return = (NOT i_InactiveText)
   CASE c_InactiveLine
	   l_Return = i_InactiveLine
   CASE c_NoInactiveLine
	   l_Return = (NOT i_InactiveLine)
   CASE c_InactiveCol
	   l_Return = i_InactiveCol
   CASE c_NoInactiveCol
	   l_Return = (NOT i_InactiveCol)
   CASE c_ActiveRowPointer
	   l_Return = i_ActiveRowPointer
   CASE c_NoActiveRowPointer
	   l_Return = (NOT i_ActiveRowPointer)
   CASE c_InActiveRowPointer
	   l_Return = i_InActiveRowPointer
   CASE c_NoInActiveRowPointer
	   l_Return = (NOT i_InActiveRowPointer)
   CASE c_FreeFormStyle
	   l_Return = (i_PresentationStyle = c_FreeFormStyle)
   CASE c_TabularFormStyle
	   l_Return = (i_PresentationStyle = c_TabularFormStyle)
   CASE c_ShowHighlight
	   l_Return = (i_HighlightMethod = c_ShowHighlight)
   CASE c_HideHighlight
	   l_Return = (i_HighlightMethod = c_HideHighlight)
   CASE c_MenuButtonActivation
	   l_Return = i_MenuButtonActivation
   CASE c_NoMenuButtonActivation
	   l_Return = (NOT i_MenuButtonActivation)
   CASE c_NoAutoConfigMenus
	   l_Return = (NOT i_AutoConfigMenus)
   CASE c_AutoConfigMenus
	   l_Return = i_AutoConfigMenus
   CASE c_ShowEmpty
	   l_Return = i_ShowEmpty
   CASE c_NoShowEmpty
	   l_Return = (NOT i_ShowEmpty)
   CASE c_AutoFocus
	   l_Return = i_AutoFocus
   CASE c_NoAutoFocus
	   l_Return = (NOT i_AutoFocus)
   CASE c_DDDWFind
	   l_Return = i_DDDWFind
   CASE c_NoDDDWFind
	   l_Return = (NOT i_DDDWFind)
   CASE c_CCErrorBlack
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_Black)       
   CASE c_CCErrorWhite
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_White)       
   CASE c_CCErrorGray
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_Gray)       
   CASE c_CCErrorDarkGray
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_DarkGray)       
   CASE c_CCErrorRed
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_Red)       
   CASE c_CCErrorDarkRed
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_DarkRed)       
   CASE c_CCErrorGreen
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_Green)       
   CASE c_CCErrorDarkGreen
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_DarkGreen)      
   CASE c_CCErrorBlue
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_Blue)       
   CASE c_CCErrorDarkBlue
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_DarkBlue)       
   CASE c_CCErrorMagenta
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_Magenta)       
   CASE c_CCErrorDarkMagenta
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_DarkMagenta)       
   CASE c_CCErrorCyan
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_Cyan)       
   CASE c_CCErrorDarkCyan
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_DarkCyan)      
   CASE c_CCErrorYellow
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_Yellow)       
	CASE c_CCErrorBrown
	   l_Return = (i_CCErrorColor = OBJCA.MGR.c_DarkYellow)      
//******************************************************************
// New CASE, added 10/28/98 for refresh parent method
//******************************************************************
   CASE c_RefreshParentAuto
	   l_Return = (NOT i_RefreshParentRetrieve)
   CASE c_RefreshParentReselect
	   l_Return = (NOT i_RefreshParentRetrieve)
   CASE c_RefreshParentRetrieve
	   l_Return = i_RefreshParentRetrieve
	CASE c_NOSortClicked
		l_Return = (NOT i_AllowSortClicked)
	CASE c_SortClickedOK
		l_Return = i_AllowSortClicked

END CHOOSE

RETURN l_Return
end function

public subroutine fu_calcoptions ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_CalcOptions
//  Description   : Initializes DataWindow variables and services
//                  based on the options.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Bug Number / Description of Change
//  -------- ---------- --------------------------------------------
// 10/28/98	 Beth Byers Add a restriction for i_RefreshParentRetrieve
//								if i_ParentDW is null
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_Header, l_Footer, l_Summary, l_Trailer
INTEGER l_Detail, l_DetailArea, l_NumSearch, l_NumFilter
STRING  l_Units, l_EmptyString
USEROBJECT l_Objects[]
U_DW_MAIN	l_tempDW

//------------------------------------------------------------------
//  Apply security restrictions to the DataWindow edit operations.
//------------------------------------------------------------------

IF NOT i_FromConstructor THEN
	IF IsValid(SECCA.MGR) THEN
		IF NOT SECCA.MGR.DYNAMIC fu_CheckAdd(i_Window, THIS) THEN
			i_PLAllowNew    = FALSE
			i_AllowNew      = FALSE
		END IF
		
		IF NOT SECCA.MGR.DYNAMIC fu_CheckEnable(i_Window, THIS) THEN
			i_PLAllowEnable = FALSE
			i_AllowModify   = FALSE
			i_AllowNew      = FALSE
			i_AllowDelete   = FALSE
			i_AllowDeleteSaved = FALSE
			i_AllowDrag     = FALSE
			i_AllowDrop     = FALSE
		END IF

		IF NOT SECCA.MGR.DYNAMIC fu_CheckDelete(i_Window, THIS) THEN
			i_AllowDelete        = FALSE
		END IF

		IF NOT SECCA.MGR.DYNAMIC fu_CheckQueryMode(i_Window, THIS) THEN
			i_AllowQuery         = FALSE
		END IF

		IF NOT SECCA.MGR.DYNAMIC fu_CheckDrillDown(i_Window, THIS) THEN
	 		i_PLAllowDrillDown   = FALSE
			i_EnableModifyOnOpen = FALSE
			i_EnableNewOnOpen    = FALSE
		END IF

		IF NOT SECCA.MGR.DYNAMIC fu_CheckDragDrop(i_Window, THIS) THEN
			i_AllowDrag          = FALSE
			i_AllowDrop          = FALSE
		END IF
	END IF

	//---------------------------------------------------------------
	//  Calculate the presentation style and highlighting method of
	//  the DataWindow.
	//---------------------------------------------------------------

	IF i_PresentationStyle = c_CalculateStyle THEN
		l_Units = Describe("datawindow.units")
		l_Detail  = Integer(Describe("datawindow.detail.height"))
		l_Header  = Integer(Describe("datawindow.header.height"))
		l_Footer  = Integer(Describe("datawindow.footer.height"))
		l_Summary = Integer(Describe("datawindow.summary.height"))
		l_Trailer = Integer(Describe("datawindow.trailer.height"))
		IF l_Units = "1" THEN
			l_Detail  = PixelsToUnits(l_Detail, YPixelsToUnits!)
			l_Header  = PixelsToUnits(l_Header, YPixelsToUnits!)
			l_Footer  = PixelsToUnits(l_Footer, YPixelsToUnits!)
			l_Summary = PixelsToUnits(l_Summary, YPixelsToUnits!)
			l_Trailer = PixelsToUnits(l_Trailer, YPixelsToUnits!)
		END IF
		l_DetailArea = Height - (l_Header + l_Footer + l_Summary + l_Trailer)
		IF l_DetailArea >= (2 * l_Detail) THEN
			i_PresentationStyle = c_TabularFormStyle
			i_ShowEmpty = FALSE
		ELSE
			i_PresentationStyle = c_FreeFormStyle
		END IF
	END IF

	IF i_HighlightMethod = c_CalculateHighlight THEN
		IF i_PresentationStyle = c_TabularFormStyle THEN
			i_HighlightMethod = c_ShowHighlight
		ELSE
			i_HighlightMethod = c_HideHighlight
		END IF
	END IF

	//---------------------------------------------------------------
	//  Set the RetrieveAsNeeded attribute.
	//---------------------------------------------------------------

	IF i_RetrieveAsNeeded THEN
		Modify("datawindow.retrieve.asneeded=yes")
	ELSE
		Modify("datawindow.retrieve.asneeded=no")
	END IF

	//---------------------------------------------------------------
	//  Determine which option combinations are invalid and set the
	//  variables appropriately.
	//---------------------------------------------------------------

	i_ScrollDW = THIS
	IF IsNull(i_ParentDW) <> FALSE THEN
		i_RefreshParent 			= FALSE
		i_RefreshParentRetrieve = FALSE
		i_RefreshChild  			= FALSE
		i_ScrollParent  			= FALSE
		i_ShareData     			= FALSE
		i_IsInstance    			= FALSE
	ELSE
		IF i_ScrollParent THEN
	   	i_ScrollDW = i_ParentDW
		END IF
	END IF

	IF i_IsInstance THEN
		i_RefreshChild = FALSE
	END IF

	IF i_SelectMethod = c_SelectOnDoubleClick THEN
		IF i_AllowDrag THEN
			i_SelectMethod = c_SelectOnClick
		ELSE
			i_AllowDrillDown = TRUE
		END IF
	END IF

	IF i_ShareData THEN
		i_SelectMethod = c_SelectOnRowFocusChange
		i_ParentDW.i_SelectMethod = c_SelectOnRowFocusChange
	END IF

	IF IsNull(i_DBCA) <> FALSE THEN
		i_EnableCC = FALSE
	END IF

	IF i_ModeOnOpen = c_NewOnOpen THEN
		i_RetrieveOnOpen = TRUE
	END IF

	//---------------------------------------------------------------
	//  If this a single row DataWindow (i.e. free-form style) or
	//  if the DataWindow is empty, then don't display the row
	//  focus indicator.
	//---------------------------------------------------------------

	IF i_PresentationStyle = c_TabularFormStyle THEN
		i_ShowEmpty          = FALSE
		i_IndicatorFocus     = c_DefaultIndicator
		i_IndicatorFocusX    = c_DefaultIndicatorX
		i_IndicatorFocusY    = c_DefaultIndicatorY
		i_IndicatorNotFocus  = c_DefaultIndicator
		i_IndicatorNotFocusX = c_DefaultIndicatorX
		i_IndicatorNotFocusY = c_DefaultIndicatorY
	ELSE
   	i_IndicatorFocus     = Off!
   	i_IndicatorNotFocus  = Off!
	END IF

	fu_SetIndicatorRow()

	//---------------------------------------------------------------
	//  If the timer is active, mark a time.
	//---------------------------------------------------------------

	IF IsValid(OBJCA.TIMER) THEN
		IF OBJCA.TIMER.i_TimerOn THEN
			OBJCA.TIMER.fu_TimerMark("Set Options: " + ClassName())
		END IF
	END IF

	//---------------------------------------------------------------
	//  Determine which services should be started based on the 
	//  options.
	//---------------------------------------------------------------

	IF i_AllowNew OR i_AllowModify OR i_AllowDelete OR &
		i_AllowDrag OR i_AllowDrop OR i_AllowCopy THEN
		fu_CreateService(c_EDITService)
 
		//------------------------------------------------------------
		//  If the timer is active, mark a time.
		//------------------------------------------------------------

		IF IsValid(OBJCA.TIMER) THEN
			IF OBJCA.TIMER.i_TimerOn THEN
				OBJCA.TIMER.fu_TimerMark("   Edit Service")
			END IF
		END IF
	ELSE
		IF IsValid(i_DWSRV_EDIT) THEN
			fu_DestroyService(c_EDITService)
		END IF
	END IF

	IF i_EnableCC THEN
		IF IsValid(i_DWSRV_EDIT) THEN
			fu_CreateService(c_CCService)
	
			//---------------------------------------------------------
			//  If the timer is active, mark a time.
			//---------------------------------------------------------

			IF IsValid(OBJCA.TIMER) THEN
				IF OBJCA.TIMER.i_TimerOn THEN
					OBJCA.TIMER.fu_TimerMark("   Concurrency Service")
				END IF
			END IF
		END IF
	ELSE
		IF IsValid(i_DWSRV_CC) THEN
			fu_DestroyService(c_CCService)
		END IF
	END IF

	IF i_ViewModeBorder <> c_ViewModeBorderUnchanged OR &
		IsNull(i_ViewModeColor) = FALSE OR &
		IsNull(i_InactiveColor) = FALSE THEN
 		IF NOT IsValid(i_DWSRV_CUES) THEN
			fu_CreateService(c_CUESService)

			//---------------------------------------------------------
			//  If the timer is active, mark a time.
			//---------------------------------------------------------

			IF IsValid(OBJCA.TIMER) THEN
				IF OBJCA.TIMER.i_TimerOn THEN
					OBJCA.TIMER.fu_TimerMark("   Visual Cues Service")
				END IF
			END IF
		ELSE
			IF i_ViewModeBorder <> c_ViewModeBorderUnchanged OR &
				IsNull(i_ViewModeColor) = FALSE THEN
				i_DWSRV_CUES.fu_BuildViewMode(i_ViewModeColor, i_ViewModeBorder)
			END IF

			IF IsNull(i_InactiveColor) = FALSE THEN
				i_DWSRV_CUES.fu_BuildInactiveMode(i_InactiveColor, i_InactiveText, &
		                                 	    i_InactiveCol, i_InactiveLine)
			END IF
		END IF
	ELSE
		IF IsValid(i_DWSRV_CUES) THEN
			fu_DestroyService(c_CUESService)
		END IF
	END IF

	IF i_AllowQuery THEN
 		IF NOT IsValid(i_DWSRV_SEEK) THEN
			fu_CreateService(c_SEEKService)
		
			//---------------------------------------------------------
			//  If the timer is active, mark a time.
			//---------------------------------------------------------

			IF IsValid(OBJCA.TIMER) THEN
				IF OBJCA.TIMER.i_TimerOn THEN
					OBJCA.TIMER.fu_TimerMark("   Search/Filter Service")
				END IF
			END IF
		END IF
	ELSE
		IF IsValid(i_DWSRV_SEEK) THEN
			l_NumSearch = i_DWSRV_SEEK.fu_GetObjects(1, l_Objects[])
			l_NumFilter = i_DWSRV_SEEK.fu_GetObjects(2, l_Objects[])
			IF l_NumSearch = 0 AND l_NumFilter = 0 THEN
				fu_DestroyService(c_SEEKService)
			END IF
		END IF
	END IF

	IF i_MenuButtonActivation THEN
 		IF NOT IsValid(i_DWSRV_CTRL) THEN
			fu_CreateService(c_CTRLService)
		
			//---------------------------------------------------------
			//  If the timer is active, mark a time.
			//---------------------------------------------------------

			IF IsValid(OBJCA.TIMER) THEN
				IF OBJCA.TIMER.i_TimerOn THEN
					OBJCA.TIMER.fu_TimerMark("   Menu/Button Control Service")
				END IF
			END IF
		END IF
	ELSE
		IF IsValid(i_DWSRV_CTRL) THEN
			fu_DestroyService(c_CTRLService)
		END IF
	END IF
END IF

end subroutine

public subroutine fu_initoptions ();//******************************************************************
//  PC Module     : u_DW_Main
//  Function      : fu_InitOptions
//  Description   : Initializes the DataWindow options in the
//                  constructor and fu_Swap().
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
// 10/28/98  Beth Byers	Add i_RefreshParentRetrieve option 
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

STRING l_Defaults

//------------------------------------------------------------------
//  Initialize the options.
//------------------------------------------------------------------

i_ScrollParent         = FALSE
i_IsInstance           = FALSE
i_AlwaysCheckRequired  = FALSE
i_AllowNew             = FALSE
i_AllowModify          = FALSE
i_AllowQuery           = FALSE
i_AllowDelete          = FALSE
i_AllowDeleteSaved	  = TRUE
i_AllowDrillDown       = FALSE
i_AllowDrop            = FALSE
i_AllowDrag            = FALSE
i_AllowCopy            = FALSE
i_PLAllowDrillDown     = TRUE
i_PLAllowEnable        = TRUE
i_PLAllowNew           = TRUE
i_MultiSelect          = FALSE
i_ViewAfterSave        = FALSE
i_EnableNewOnOpen      = FALSE
i_EnableModifyOnOpen   = FALSE
i_RetrieveOnOpen       = TRUE
i_RetrieveAsNeeded     = FALSE
i_ShareData            = FALSE
i_RefreshParent        = FALSE
i_RefreshParentRetrieve= FALSE
i_RefreshChild         = FALSE
i_IgnoreNewRows        = TRUE
i_NewModeOnEmpty       = FALSE
i_OnlyOneNewRow        = FALSE
i_EnableCC             = FALSE
i_EnableCCInsert       = FALSE
i_EnablePopup          = TRUE
i_InactiveText         = TRUE
i_InactiveLine         = TRUE
i_InactiveCol          = TRUE
i_ActiveRowPointer     = TRUE
i_InactiveRowPointer   = TRUE
i_MenuButtonActivation = TRUE
i_AutoConfigMenus      = FALSE
i_ShowEmpty            = TRUE
i_AutoFocus            = TRUE
i_DDDWFind             = FALSE
i_GotKeys              = FALSE
i_AllowSortClicked	  = FALSE

i_SelectMethod         = c_SelectOnDoubleClick
i_ModeOnSelect         = c_ParentModeOnSelect
i_MultiSelectMethod    = c_RefreshOnSelect
i_ModeOnOpen           = c_ViewOnOpen
i_ViewModeBorder       = c_ViewModeBorderUnchanged
i_PresentationStyle    = c_CalculateStyle
i_HighlightMethod      = c_CalculateHighlight
i_CCErrorColor         = FWCA.MGR.c_Red

SetNull(i_ViewModeColor)
SetNull(i_InactiveColor)

//------------------------------------------------------------------
//  Set the default values for the DataWindow.
//------------------------------------------------------------------

i_FromConstructor = TRUE
l_Defaults = FWCA.MGR.fu_GetDefault("DataWindow", "General")
fu_ChangeOptions(l_Defaults)
i_FromConstructor = FALSE

end subroutine

public subroutine fu_activate ();//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_Activate
//  Description   : Indicate that this DataWindow is active.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

fu_Activate(c_SetFocus)
end subroutine

event constructor;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : Constructor
//  Description   : Initializes DataWindow variables.
//
//  Change History:
//
//  Date     Person     Bug # / Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

POWEROBJECT l_Container

//------------------------------------------------------------------
//  If the DataWindow is on a user object, determine its window.
//------------------------------------------------------------------

l_Container = Parent
SetNull(i_Container)
SetNull(i_DBCA)
SetNull(i_ParentDW)
SetNull(c_NullDW)

DO 
	IF l_Container.TypeOf() = Window! THEN
		EXIT
	ELSE
		IF l_Container.TypeOf() = UserObject! THEN
			IF l_Container.TriggerEvent("po_identify") = 1 THEN
				IF l_Container.DYNAMIC fu_GetIdentity() = "Container" THEN
					i_Container = l_Container
				END IF
			END IF
		END IF
		l_Container = l_Container.GetParent()
	END IF
LOOP UNTIL l_Container.TypeOf() = Window!

i_Window = l_Container

//------------------------------------------------------------------
//  Initialize some DataWindow variables.
//------------------------------------------------------------------

i_InOpen            = TRUE
i_CurrentMode       = c_ViewMode

c_MasterList = c_EnableNewOnOpen        + &
               c_EnableModifyOnOpen     + &
               c_DeleteOk               + &
               c_SelectOnRowFocusChange + &
               c_DrillDown

c_MasterEdit = c_NewOk                  + &
               c_ModifyOk               + &
               c_SelectOnRowFocusChange + &
               c_DrillDown              + &
               c_ScrollParent           + &
               c_RefreshParent

c_DetailList = c_EnableNewOnOpen        + &
               c_EnableModifyOnOpen     + &
               c_DeleteOk               + &
               c_ModifyOnSelect         + &
               c_SelectOnClick          + &
               c_DrillDown              + &
               c_RefreshParent          + &
               c_RefreshChild

c_DetailEdit = c_NewOk                  + &
               c_ModifyOk               + &
               c_SelectOnRowFocusChange + &
               c_DrillDown              + &
               c_ScrollParent           + &
               c_RefreshParent          + &
               c_RefreshChild

fu_InitOptions()
end event

event getfocus;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : GetFocus
//  Description   : Set the DataWindow to be current.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF i_Initialized THEN

	//---------------------------------------------------------------
	//  Make this DataWindow the current DataWindow.
	//---------------------------------------------------------------

	fu_Activate(c_NoSetFocus)

	//---------------------------------------------------------------
	//  Now that this DataWindow has focus, set the current row
	//  indicator.
	//---------------------------------------------------------------

	fu_SetIndicatorRow()

END IF


end event

event losefocus;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : LoseFocus
//  Description   : Sets the row focus indicator when the 
//                  DataWindow loses focus.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF i_Initialized THEN
	
	//---------------------------------------------------------------
	//  Set the row focus indicator.
	//---------------------------------------------------------------
	
	fu_SetIndicatorRow()

END IF

end event

event clicked;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : Clicked
//  Description   : Process the row/column selection.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/12/2000 K. Claver Added code to sort the datawindow when
//						       click on a column header
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_IsShifted,  l_IsControl
STRING   l_ColumnName

//------------------------------------------------------------------
//  Assume that we will not have any errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Remember if the control or shift key is depressed.
//------------------------------------------------------------------

l_IsControl = KeyDown(keyControl!)
l_IsShifted = KeyDown(keyShift!)

//------------------------------------------------------------------
//  If this is not the current DataWindow then handle it
//  here.  All we have to do is make sure that the GetFocus event
//  is run on this DataWindow.
//------------------------------------------------------------------

IF NOT i_IsCurrent THEN
   THIS.TriggerEvent(GetFocus!)
END IF

//------------------------------------------------------------------
//  Make sure that the user clicked on a valid row.  For example,
//  if they click on the border or scroll bar, the clicked row
//  would be invalid (i.e. 0).
//------------------------------------------------------------------

IF row > 0 THEN

   //---------------------------------------------------------------
   //  Get the new column that has been clicked.
   //---------------------------------------------------------------

   l_ColumnName = dwo.name
	IF Lower(l_ColumnName) = "datawindow" THEN
		l_ColumnName = ""
	END IF
	
   //---------------------------------------------------------------
   //  Process the row/column.
   //---------------------------------------------------------------

	i_MoveRow     = i_CursorRow
	i_FromClicked = TRUE

   IF fu_Select(c_SelectOnClick, row, l_ColumnName, l_IsControl, &
                l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
		RETURN 1
	ELSE
		IF i_AllowDrag THEN
			i_DWSRV_EDIT.fu_Drag()
		END IF
   END IF
ELSE
	//Clicked on a column header.  If there are rows and set to sort enabled, sort.
	IF IsValid( dwo ) THEN
		IF dwo.Type = "text" THEN
			IF i_AllowSortClicked AND THIS.RowCount( ) > 0 THEN			
				l_ColumnName = dwo.Name
				l_ColumnName = Left( l_ColumnName, Len( l_ColumnName ) - 2 )
				
				IF IsNull( i_cSortColumn ) OR i_cSortColumn <> l_ColumnName THEN
					i_cSortDirection = "A"
				ELSE
					IF IsNull( i_cSortDirection ) OR i_cSortDirection = "D" THEN
						i_cSortDirection = "A"
					ELSE
						i_cSortDirection = "D"
					END IF
				END IF
	
				THIS.SetSort( l_ColumnName+" "+i_cSortDirection )
				THIS.Sort( )
				
				i_cSortColumn = l_ColumnName
			END IF
		END IF
	END IF
		
END IF

end event

event doubleclicked;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : DoubleClicked
//  Description   : Process the row/column selection.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_IsShifted,  l_IsControl
STRING   l_ColumnName

//------------------------------------------------------------------
//  If an error happened in the Clicked! event then don't process
//  this event.
//------------------------------------------------------------------

IF Error.i_FWError <> c_Success THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Remember if the control or shift key is depressed.
//------------------------------------------------------------------

l_IsControl = KeyDown(keyControl!)
l_IsShifted = KeyDown(keyShift!)

//------------------------------------------------------------------
//  Make sure that the user clicked on a valid row.  For example,
//  if they click on the border or scroll bar, the clicked row
//  would be invalid (i.e. 0).
//------------------------------------------------------------------

IF row > 0 THEN

   //---------------------------------------------------------------
   //  Get the new column that has been clicked.
   //---------------------------------------------------------------

   l_ColumnName = dwo.name
	IF Lower(l_ColumnName) = "datawindow" THEN
		l_ColumnName = ""
	END IF

   //---------------------------------------------------------------
   //  Process the row/column.
   //---------------------------------------------------------------

	IF i_MoveRow > 0 THEN
		i_CursorRow = i_MoveRow
		i_MoveRow = 0
	END IF

	i_FromDoubleClicked = TRUE

	IF fu_Select(c_SelectOnDoubleClick, row, l_ColumnName, l_IsControl, &
      l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

end event

event rowfocuschanged;//******************************************************************
//  PC Module     : uo_DW_Main
//  Event         : RowFocusChanged
//  Description   : Process the row/column selection.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_IsShifted,  l_IsControl

//------------------------------------------------------------------
//  If we are already processing an RFC or an RFC is executed
//  unnecessarily then do not process this event.
//------------------------------------------------------------------

IF i_IgnoreRFC THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Assume that we will not have any errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Remember if the control or shift key is depressed.
//------------------------------------------------------------------

l_IsControl = KeyDown(keyControl!)
l_IsShifted = KeyDown(keyShift!)

//------------------------------------------------------------------
//  If this event is the result of the Clicked or DoubleClicked
//  event, then ignore any futher processing because it will have
//  been handled by the fu_Select call from those events.
//------------------------------------------------------------------

IF (NOT i_FromClicked AND NOT i_FromDoubleClicked) OR &
	KeyDown(keyUpArrow!) OR KeyDown(keyDownArrow!) OR &
	KeyDown(keyEnter!) OR KeyDown(keyTab!) THEN
	IF fu_Select(c_SelectOnRowFocusChange, currentrow, i_CursorCol, &
  		          l_IsControl, l_IsShifted) <> c_Success THEN
		Error.i_FWError = c_Fatal
	END IF
END IF

i_FromClicked       = FALSE
i_FromDoubleClicked = FALSE

end event

event itemerror;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : ItemError
//  Description   : This event is used to disable the display
//                  of the generic PowerBuilder validation error
//                  message.
//
//  Return Value  : INTEGER -
//                     0 - reject value and show error.
//                     1 - reject value and stay.
//                     2 - accept value and move.
//                     3 - reject value and move.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = 2
DWITEMSTATUS l_RowStatus

//------------------------------------------------------------------
//  If the edit service is available, determine whether to display
//  a validate error message.
//------------------------------------------------------------------

IF NOT i_IgnoreVal THEN
	IF IsValid(i_DWSRV_EDIT) THEN
		l_Return = i_DWSRV_EDIT.fu_ItemError(row, data)
	END IF
END IF

//------------------------------------------------------------------
//  If the developer extends this event then they should check
//  AncestorReturnValue first to see if they should process their
//  code.  Unless the developer changes the RETURN value in their
//  code, PowerBuilder will use the AncestorReturnValue.
//------------------------------------------------------------------

RETURN l_Return

end event

event rbuttondown;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : RButtonDown
//  Description   : Display POPUP menu for the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the POPUP menu was requested, put it up if it exists.
//------------------------------------------------------------------

IF i_EnablePopup THEN

 	//---------------------------------------------------------------
	//  Display the popup menu.
	//---------------------------------------------------------------

	IF IsValid(i_PopupID) THEN
		IF FWCA.MGR.i_WindowCurrent <> i_Window THEN
			i_Window.SetFocus()
		END IF

		IF FWCA.MGR.i_MDIValid AND i_WindowSheet THEN
			IF IsValid(SECCA.MGR) THEN
				SECCA.MGR.DYNAMIC fu_SetPopupSecurity(i_Window, i_PopupID, &
										FWCA.MGR.i_MDIFrame.PointerX(), &
										FWCA.MGR.i_MDIFrame.PointerY())
			ELSE
				i_PopupID.PopMenu(FWCA.MGR.i_MDIFrame.PointerX(), &
                           FWCA.MGR.i_MDIFrame.PointerY())
			END IF
		ELSE
			IF IsValid(SECCA.MGR) THEN
				SECCA.MGR.DYNAMIC fu_SetPopupSecurity(i_Window, i_PopupID, &
										PointerX(), PointerY())
			ELSE
				i_PopupID.PopMenu(PointerX(), PointerY())
			END IF
		END IF
   END IF

END IF

end event

event dberror;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : DBError
//  Description   : Save the database error message and
//                  database specific error code for concurrency
//                  error handling.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = 0

IF IsValid(i_DWSRV_CC) THEN
	l_Return = i_DWSRV_CC.fu_CheckCCStatus(sqldbcode, sqlerrtext)
ELSEIF IsValid(i_DWSRV_EDIT) THEN
	i_DWSRV_EDIT.i_CCErrorCode    = sqldbcode
	i_DWSRV_EDIT.i_CCErrorMessage = sqlerrtext
END IF

//------------------------------------------------------------------
//  If the developer extends this event then they should check
//  AncestorReturnValue first to see if they should process their
//  code.  Unless the developer changes the RETURN value in their
//  code, PowerBuilder will use the AncestorReturnValue.
//------------------------------------------------------------------

RETURN l_Return
end event

event sqlpreview;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : SQLPreview
//  Description   : Saves the row number and buffer for the row
//                  currently being updated if concurrency error
//                  handling is on.  For two phase updates, sends
//                  only the rows that are appropriate for the
//                  phase.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = 0

IF request = PreviewFunctionUpdate! THEN
	IF IsValid(i_DWSRV_CC) THEN
		i_DWSRV_CC.fu_UpdateCCStatus(row, buffer)
	END IF
END IF

//------------------------------------------------------------------
//  If the developer extends this event then they should check
//  AncestorReturnValue first to see if they should process their
//  code.  Unless the developer changes the RETURN value in their
//  code, PowerBuilder will use the AncestorReturnValue.
//------------------------------------------------------------------

RETURN l_Return
end event

event updatestart;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : UpdateStart
//  Description   : Initializes concurrency error handling 
//                  variables and keeps track of the number of
//                  times UPDATE is called for multiple table
//                  updates.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(i_DWSRV_CC) THEN
	i_DWSRV_CC.fu_InitCCStatus()
ELSEIF IsValid(i_DWSRV_EDIT) THEN
	i_DWSRV_EDIT.i_CCWhichUpdate = i_DWSRV_EDIT.i_CCWhichUpdate + 1
END IF
end event

event itemchanged;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : ItemChanged
//  Description   : This event is used to trigger validation
//                  checking when a field has changed.
//
//  Return Value  : INTEGER -
//                     0 - validation OK.
//                     1 - validation failed.
//                     2 - validation fixed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = 0

//------------------------------------------------------------------
//  If the edit service is available, validate the item.
//------------------------------------------------------------------

IF NOT i_IgnoreVal THEN
	IF IsValid(i_DWSRV_EDIT) THEN
		l_Return = i_DWSRV_EDIT.fu_ItemChanged(row, data)
	END IF
END IF

//------------------------------------------------------------------
//  If the developer extends this event then they should check
//  AncestorReturnValue first to see if they should process their
//  code.  Unless the developer changes the RETURN value in their
//  code, PowerBuilder will use the AncestorReturnValue.
//------------------------------------------------------------------

RETURN l_Return
end event

event itemfocuschanged;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : ItemFocusChanged
//  Description   : This event is used to indicate when a focus
//                  changes between items in a DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the edit service is available, then clear the validation
//  flag to indicate that validation needs to be run.
//------------------------------------------------------------------

IF NOT i_IgnoreVal THEN
   i_CursorCol = GetColumnName()
	IF IsValid(i_DWSRV_EDIT) THEN
		i_DWSRV_EDIT.fu_ItemFocusChanged()
	END IF
END IF

end event

event editchanged;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : EditChanged
//  Description   : This event is used to indicate that the input
//                  needs to be validated.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(i_DWSRV_EDIT) THEN
	IF NOT i_IsQuery THEN
		i_DWSRV_EDIT.i_ItemValidated = FALSE
		i_DWSRV_EDIT.i_HaveModify    = TRUE
	END IF
	
	IF i_DDDWFind AND data <> "" THEN
		IF Upper(dwo.dddw.allowedit) = 'YES' THEN
			i_DWSRV_EDIT.fu_DDDWFind(row, dwo, data)
		END IF
	END IF
END IF
end event

event dragdrop;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : DragDrop
//  Description   : Process the drop action for the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF i_AllowDrop THEN
	Error.i_FWError = i_DWSRV_EDIT.fu_Drop(source, row)
END IF
end event

event dragwithin;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : DragWithin
//  Description   : If the drag DataWindow is scrolling, stop the
//                  scroll.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF i_AllowDrag OR i_AllowDrop THEN
	Error.i_FWError = i_DWSRV_EDIT.fu_DragWithin(source, row)
END IF
end event

on u_dw_main.create
end on

on u_dw_main.destroy
end on

event resize;//////////////////////////////////////////////////////////////////////////////
//	Event:			resize
//	Description:	Send resize notification to services
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						6.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
If IsValid (inv_Resize) then inv_Resize.Event pfc_Resize (sizetype, This.Width, This.Height)
end event

event destructor;//******************************************************************
//  PC Module     : w_Root
//  Event         : Destructor
//  Description   : See PB documentation for this event
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//	 9/22/2000 K. Claver Added code to destroy the resize service if
//								it exists
//******************************************************************

//----------------------------------------------------------------
//  Destroy the resize service
//----------------------------------------------------------------
THIS.of_SetResize(False)
end event

