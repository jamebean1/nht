$PBExportHeader$u_outliner.sru
$PBExportComments$Hierarchical outliner class
forward
global type u_outliner from datawindow
end type
end forward

global type u_outliner from datawindow
integer width = 1307
integer height = 844
integer taborder = 1
boolean vscrollbar = true
event po_collapsed ( long selectedrow,  integer selectedlevel,  integer maxlevels )
event po_expanded ( long selectedrow,  integer selectedlevel,  integer maxlevels )
event po_keydown pbm_dwnkey
event po_pickedrow ( long clickedrow,  integer clickedlevel,  integer maxlevels )
event po_validaterow ( long clickedrow,  integer clickedlevel,  long selectedrow,  integer selectedlevel,  integer maxlevels )
event po_rdoubleclicked pbm_dwnrbuttondblclk
event po_selectedrow ( long selectedrow,  integer selectedlevel,  integer maxlevels )
event po_identify pbm_custom70
end type
global u_outliner u_outliner

type variables
//-----------------------------------------------------------------------------------------
// Outliner Object Constants
//-----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName		= "Outliner"
CONSTANT INTEGER	c_DefaultHeight		= 0
CONSTANT INTEGER	c_DefaultWidth		= 0
CONSTANT STRING	c_DefaultVisual		= "000|"
CONSTANT LONG		c_DefaultControl		= 0
CONSTANT STRING	c_DefaultFont		= ""
CONSTANT INTEGER	c_DefaultSize		= 0
CONSTANT INTEGER	c_DefaultBMPHeight	= 0
CONSTANT INTEGER	c_DefaultBMPWidth	= 0
CONSTANT INTEGER	c_DefaultBMPIndent	= 0
TRANSACTION		c_DefaultTransaction	= SQLCA

CONSTANT STRING	c_HLWhite		= "001|"
CONSTANT STRING	c_HLBlack		= "002|"
CONSTANT STRING	c_HLGray		= "003|"
CONSTANT STRING	c_HLDarkGray		= "004|"
CONSTANT STRING	c_HLRed			= "005|"
CONSTANT STRING	c_HLDarkRed		= "006|"
CONSTANT STRING	c_HLGreen		= "007|"
CONSTANT STRING	c_HLDarkGreen		= "008|"
CONSTANT STRING	c_HLBlue			= "009|"
CONSTANT STRING	c_HLDarkBlue		= "010|"
CONSTANT STRING	c_HLMagenta		= "011|"
CONSTANT STRING	c_HLDarkMagenta		= "012|"
CONSTANT STRING	c_HLCyan		= "013|"
CONSTANT STRING	c_HLDarkCyan		= "014|"
CONSTANT STRING	c_HLYellow		= "015|"
CONSTANT STRING	c_HLDarkYellow		= "016|"

CONSTANT STRING	c_LineBlack		= "017|"
CONSTANT STRING	c_LineWhite		= "018|"
CONSTANT STRING	c_LineGray		= "019|"
CONSTANT STRING	c_LineDarkGray		= "020|"
CONSTANT STRING	c_LineRed		= "021|"
CONSTANT STRING	c_LineDarkRed		= "022|"
CONSTANT STRING	c_LineGreen		= "023|"
CONSTANT STRING	c_LineDarkGreen		= "024|"
CONSTANT STRING	c_LineBlue		= "025|"
CONSTANT STRING	c_LineDarkBlue		= "026|"
CONSTANT STRING	c_LineMagenta		= "027|"
CONSTANT STRING	c_LineDarkMagenta	= "028|"
CONSTANT STRING	c_LineCyan		= "029|"
CONSTANT STRING	c_LineDarkCyan		= "030|"
CONSTANT STRING	c_LineYellow		= "031|"
CONSTANT STRING	c_LineDarkYellow		= "032|"

CONSTANT STRING	c_RowFocusIndicatorGray		= "033|"
CONSTANT STRING	c_RowFocusIndicatorBlack		= "034|"
CONSTANT STRING	c_RowFocusIndicatorWhite		= "035|"
CONSTANT STRING	c_RowFocusIndicatorDarkGray	= "036|"
CONSTANT STRING	c_RowFocusIndicatorRed		= "037|"
CONSTANT STRING	c_RowFocusIndicatorDarkRed	= "038|"
CONSTANT STRING	c_RowFocusIndicatorGreen		= "039|"
CONSTANT STRING	c_RowFocusIndicatorDarkGreen	= "040|"
CONSTANT STRING	c_RowFocusIndicatorBlue		= "041|"
CONSTANT STRING	c_RowFocusIndicatorDarkBlue	= "042|"
CONSTANT STRING	c_RowFocusIndicatorMagenta	= "043|"
CONSTANT STRING	c_RowFocusIndicatorDarkMagenta	= "044|"
CONSTANT STRING	c_RowFocusIndicatorCyan		= "045|"
CONSTANT STRING	c_RowFocusIndicatorDarkCyan	= "046|"
CONSTANT STRING	c_RowFocusIndicatorYellow		= "047|"
CONSTANT STRING	c_RowFocusIndicatorDarkYellow	= "048|"

CONSTANT STRING	c_HighlightDarkBlue	= "049|"
CONSTANT STRING	c_HighlightBlack		= "050|"
CONSTANT STRING	c_HighlightGray		= "051|"
CONSTANT STRING	c_HighlightDarkGray	= "052|"
CONSTANT STRING	c_HighlightRed		= "053|"
CONSTANT STRING	c_HighlightDarkRed	= "054|"
CONSTANT STRING	c_HighlightGreen		= "055|"
CONSTANT STRING	c_HighlightDarkGreen	= "056|"
CONSTANT STRING	c_HighlightBlue		= "057|"
CONSTANT STRING	c_HighlightWhite		= "058|"
CONSTANT STRING	c_HighlightMagenta		= "059|"
CONSTANT STRING	c_HighlightDarkMagenta	= "060|"
CONSTANT STRING	c_HighlightCyan		= "061|"
CONSTANT STRING	c_HighlightDarkCyan	= "062|"
CONSTANT STRING	c_HighlightYellow		= "063|"
CONSTANT STRING	c_HighlightDarkYellow	= "064|"

CONSTANT STRING	c_SelectOnClick		= "065|"
CONSTANT STRING	c_SelectOnDoubleClick	= "066|"
CONSTANT STRING	c_SelectOnRightClick	= "067|"
CONSTANT STRING	c_SelectOnRightDoubleClick	= "068|"

CONSTANT STRING	c_BranchOnDoubleClick	= "069|"
CONSTANT STRING	c_BranchOnClick		= "070|"
CONSTANT STRING	c_BranchOnRightClick	= "071|"
CONSTANT STRING	c_BranchOnRightDoubleClick= "072|"

CONSTANT STRING	c_DrillDownOnDoubleClick	= "073|"
CONSTANT STRING	c_DrillDownOnClick		= "074|"
CONSTANT STRING	c_DrillDownOnRightClick	= "075|"
CONSTANT STRING	c_DrillDownOnRightDoubleClick = "076|"

CONSTANT STRING	c_DrillDownOnLastLevel	= "077|"
CONSTANT STRING	c_DrillDownOnAnyLevel	= "078|"

CONSTANT STRING	c_ShowLines		= "079|"
CONSTANT STRING	c_HideLines		= "080|"

CONSTANT STRING	c_ShowBoxes		= "081|"
CONSTANT STRING	c_HideBoxes		= "082|"

CONSTANT STRING	c_ShowBMP		= "083|"
CONSTANT STRING	c_HideBMP		= "084|"

CONSTANT STRING	c_RetrieveAll		= "085|"
CONSTANT STRING	c_RetrieveAsNeeded	= "086|"

CONSTANT STRING	c_RetainOnCollapse	= "087|"
CONSTANT STRING	c_DeleteOnCollapse	= "088|"

CONSTANT STRING	c_CollapseOnOpen		= "089|"
CONSTANT STRING	c_ExpandOnOpen		= "090|"

CONSTANT STRING	c_ShowRowFocusIndicator	= "091|"
CONSTANT STRING	c_HideRowFocusIndicator	= "092|"

CONSTANT STRING	c_ShowHighlight		= "093|"
CONSTANT STRING	c_HideHighlight		= "094|"

CONSTANT STRING	c_SingleSelect		= "095|"
CONSTANT STRING	c_MultiSelect		= "096|"

CONSTANT STRING	c_AllowDragDrop		= "097|"
CONSTANT STRING	c_NoAllowDragDrop	= "098|"

CONSTANT STRING	c_DragMoveRows		= "099|"
CONSTANT STRING	c_DragCopyRows		= "100|"

CONSTANT STRING	c_DragOnLastLevel		= "101|"
CONSTANT STRING	c_DragOnAnyLevel		= "102|"

CONSTANT STRING	c_TextRegular		= "001|"
CONSTANT STRING	c_TextBold		= "002|"
CONSTANT STRING	c_TextItalic		= "003|"
CONSTANT STRING	c_TextUnderline		= "004|"

CONSTANT STRING	c_TextBlack		= "005|"
CONSTANT STRING	c_TextWhite		= "006|"
CONSTANT STRING	c_TextGray		= "007|"
CONSTANT STRING	c_TextDarkGray		= "008|"
CONSTANT STRING	c_TextRed		= "009|"
CONSTANT STRING	c_TextDarkRed		= "010|"
CONSTANT STRING	c_TextGreen		= "011|"
CONSTANT STRING	c_TextDarkGreen		= "012|"
CONSTANT STRING	c_TextBlue		= "013|"
CONSTANT STRING	c_TextDarkBlue		= "014|"
CONSTANT STRING	c_TextMagenta		= "015|"
CONSTANT STRING	c_TextDarkMagenta	= "016|"
CONSTANT STRING	c_TextCyan		= "017|"
CONSTANT STRING	c_TextDarkCyan		= "018|"
CONSTANT STRING	c_TextYellow		= "019|"
CONSTANT STRING	c_TextDarkYellow		= "020|"

CONSTANT STRING	c_TextHighlightWhite	= "021|"
CONSTANT STRING	c_TextHighlightBlack	= "022|"
CONSTANT STRING	c_TextHighlightGray	= "023|"
CONSTANT STRING	c_TextHighlightDarkGray	= "024|"
CONSTANT STRING	c_TextHighlightRed		= "025|"
CONSTANT STRING	c_TextHighlightDarkRed	= "026|"
CONSTANT STRING	c_TextHighlightGreen	= "027|"
CONSTANT STRING	c_TextHighlightDarkGreen	= "028|"
CONSTANT STRING	c_TextHighlightBlue		= "029|"
CONSTANT STRING	c_TextHighlightDarkBlue	= "030|"
CONSTANT STRING	c_TextHighlightMagenta	= "031|"
CONSTANT STRING	c_TextHighlightDarkMagenta	= "032|"
CONSTANT STRING	c_TextHighlightCyan	= "033|"
CONSTANT STRING	c_TextHighlightDarkCyan	= "034|"
CONSTANT STRING	c_TextHighlightYellow	= "035|"
CONSTANT STRING	c_TextHighlightDarkYellow	= "036|"

CONSTANT STRING	c_KeyNumber		= "001|"
CONSTANT STRING	c_KeyString		= "002|"
CONSTANT STRING	c_KeyDate		= "003|"

CONSTANT STRING	c_SortString		= "004|"
CONSTANT STRING	c_SortNumber		= "005|"
CONSTANT STRING	c_SortDate		= "006|"

CONSTANT STRING	c_BMPFromString		= "007|"
CONSTANT STRING	c_BMPFromColumn		= "008|"

CONSTANT STRING	c_SortAscending		= "009|"
CONSTANT STRING	c_SortDescending		= "010|"

CONSTANT STRING	c_LevelBlack		= "011|"
CONSTANT STRING	c_LevelWhite		= "012|"
CONSTANT STRING	c_LevelGray		= "013|"
CONSTANT STRING	c_LevelDarkGray		= "014|"
CONSTANT STRING	c_LevelRed		= "015|"
CONSTANT STRING	c_LevelDarkRed		= "016|"
CONSTANT STRING	c_LevelGreen		= "017|"
CONSTANT STRING	c_LevelDarkGreen		= "018|"
CONSTANT STRING	c_LevelBlue		= "019|"
CONSTANT STRING	c_LevelDarkBlue		= "020|"
CONSTANT STRING	c_LevelMagenta		= "021|"
CONSTANT STRING	c_LevelDarkMagenta	= "022|"
CONSTANT STRING	c_LevelCyan		= "023|"
CONSTANT STRING	c_LevelDarkCyan		= "024|"
CONSTANT STRING	c_LevelYellow		= "025|"
CONSTANT STRING	c_LevelDarkYellow		= "026|"

CONSTANT ULONG	c_ReselectRows		= 0
CONSTANT ULONG	c_NoReselectRows		= 1

CONSTANT ULONG	c_InsertRowExpanded	= 0
CONSTANT ULONG	c_InsertRowCollapsed	= 1

CONSTANT ULONG	c_AutoKeyDown		= 0
CONSTANT ULONG	c_ExpandLevel		= 1
CONSTANT ULONG	c_ExpandBranch		= 2
CONSTANT ULONG	c_ExpandAll		= 3
CONSTANT ULONG	c_CollapseBranch		= 4
CONSTANT ULONG	c_CollapseAll		= 5

CONSTANT INTEGER	c_Click			= 0
CONSTANT INTEGER	c_DoubleClick		= 1
CONSTANT INTEGER	c_RightClick		= 2
CONSTANT INTEGER	c_RightDoubleClick		= 3

CONSTANT ULONG	c_DeleteRows		= 0
CONSTANT ULONG	c_RetainRows		= 1

//-------------------------------------------------------------------------------
//  Outliner Object Instance Variables
//-------------------------------------------------------------------------------

STRING			i_HLColor			= "16777215"
STRING			i_HLHighColor		= "8388608"
STRING			i_SaveHighColor		= "8388608"
STRING			i_RowFocusIndicatorColor	= "12632256"
STRING			i_SaveRowFocusColor	= "12632256"
STRING			i_LineColor		= "0"

INTEGER		i_HeightFactor		= 20
INTEGER		i_HeightMidFactor		= 9
INTEGER		i_HeightAdjFactor		= 2
INTEGER		i_BMPHeight		= 16

INTEGER		i_WidthFactor		= 20
INTEGER		i_WidthMidFactor		= 8
INTEGER		i_WidthAdjFactor		= 2
INTEGER		i_BMPWidth		= 16
INTEGER		i_HLIndent		= 10

BOOLEAN		i_ShowLines		= TRUE
BOOLEAN		i_ShowBMP		= TRUE
BOOLEAN		i_ShowBoxes		= TRUE
BOOLEAN		i_RetrieveAll		= TRUE
BOOLEAN		i_RetainOnCollapse		= TRUE
BOOLEAN		i_CollapseOnOpen		= TRUE
BOOLEAN		i_ShowRowFocusIndicator	= TRUE
BOOLEAN		i_MultiSelect		= FALSE
BOOLEAN		i_DragOnLastLevel		= TRUE
BOOLEAN		i_DragMoveRows		= TRUE
BOOLEAN		i_DrillOnLastLevel		= TRUE
BOOLEAN		i_AllowDragDrop		= FALSE

INTEGER		i_SelectMethod		= 0
INTEGER		i_BranchMethod		= 1
INTEGER		i_DrillDownMethod		= 1

STRING			i_TextColor		= "0"
STRING			i_TextHighColor		= "16777215"
STRING			i_SaveTextHighColor	= "16777215"
STRING			i_TextFont		= "Arial"
STRING			i_TextFamily		= "2"
STRING			i_TextPitch		= "2"
STRING			i_TextCharSet		= "0"
STRING			i_TextSize		= "-8"
STRING			i_TextStyle		= "font.weight"
STRING			i_TextStyleValue		= "400"

BOOLEAN		i_RetrieveDefined		= FALSE
STRING			i_DataBMPExpand[]
STRING			i_DataBMPCollapse[]
STRING			i_DataKey[]
STRING			i_DataForeignKey[]
STRING			i_DataDesc[]
STRING			i_DataSort[]
STRING			i_DataTable[]
STRING			i_DataWhere[]
STRING			i_InsertFillString[]

BOOLEAN		i_InsertDefined		= FALSE
BOOLEAN		i_InsertSortDefined		= FALSE
BOOLEAN		i_RowsInserted		= FALSE

INTEGER		i_DataLevel[]
BOOLEAN		i_DataBMP[]
STRING			i_DataSortDirection[]
STRING			i_DataSortType[]
STRING			i_DataKeyType[]
STRING			i_DataColor[]
STRING			i_DataSyntax[]
 
TRANSACTION		i_Transaction
LONG			i_ClickedRow
LONG			i_FocusRow
LONG			i_AnchorRow
LONG			i_SelectedRow
INTEGER		i_SelectedLevel
INTEGER		i_ClickedLevel
INTEGER		i_MaxLevels
INTEGER		i_RowError		= 0
BOOLEAN		i_IgnoreRFC
INTEGER		i_LastSelectedLevel

BOOLEAN		i_DragFromOutside		= FALSE
BOOLEAN		i_DragFromInside		= FALSE
INTEGER		i_DropError		= 0
INTEGER		i_DragLevel
STRING			i_DragKey[]
STRING			i_DragDescription[]
STRING			i_DragSort[]
STRING			i_DragBMPClose[]
STRING			i_DragBMPOpen[]
LONG			i_DragRow

//-----------------------------------------------------------------------------------------
//  DataWindow syntax.
//-----------------------------------------------------------------------------------------

STRING	i_DWSyntax = 	'release 9;' + & 
			'datawindow(units=1 ' + &
			'timer_interval=0  ' + & 
			'processing=0 ' + &
			'print.documentname="" ' + &
			'print.orientation = 0 ' + &
			'print.margin.left = 110 ' + &
			'print.margin.right = 110 ' + &
			'print.margin.top = 97 ' + &
			'print.margin.bottom = 97 ' + &
			'print.paper.source = 0 ' + &
			'print.paper.size = 0 ' + &
			'print.prompt=no '

//-----------------------------------------------------------------------------------------
//  Table syntax.
//-----------------------------------------------------------------------------------------

STRING	i_TableSyntax = 	'table(' + &
			'column=(type=number name=level dbname="compute_0001") ' + &
			'column=(type=char(50) name=bmpopen dbname="compute_0002" ) ' + &
			'column=(type=char(50) name=bmpclose dbname="compute_0003" ) ' + &
			'column=(type=number name=expanded dbname="compute_0004") '  + &
			'column=(type=char(99) name=showline dbname="compute_0005") '  + &
			'column=(type=number name=unused dbname="compute_0006") '  + &
			'column=(type=number name=selected dbname="compute_0007") '  + &
			'column=(type=number name=current dbname="compute_0008") '  + &
			'column=(type=number name=updated dbname="compute_0009") '  + &
			'column=(type=char(150) name=stringdesc dbname="compute_0010") ' 

//-----------------------------------------------------------------------------------------
//  Box syntax.
//-----------------------------------------------------------------------------------------

STRING	i_BoxSyntax =	'create line(band=detail  pen.style="0" ' + &
			'pen.width="1"  background.mode="1" ' + &
			'background.color="553648127" '

//-----------------------------------------------------------------------------------------
//  Bitmap syntax.
//-----------------------------------------------------------------------------------------

STRING	i_BMPOpenSyntax=	'create column(band=detail id=2 border="0" ' + &
			'alignment="0" color="0" tabsequence=32766  ' + &
			'name=bmpopen bitmapname=yes format="[general]" ' + &
			'edit.limit=16 edit.case=any edit.autoselect=yes ' + &
			'edit.autohscroll=yes  font.face="Arial" font.height="-10" ' + &
			'font.weight="400" font.family="2" font.pitch="2" ' + &
			'font.charset="0" background.mode="1" '

STRING	i_BMPCloseSyntax=	'create column(band=detail id=3 border="0" ' + &
			'alignment="0" color="0" tabsequence=32766  ' + &
			'name=bmpclose bitmapname=yes format="[general]" ' + &
			'edit.limit=16 edit.case=any edit.autoselect=yes ' + &
			'edit.autohscroll=yes  font.face="Arial" font.height="-10" ' + &
			'font.weight="400" font.family="2" font.pitch="2" ' + &
			'font.charset="0" background.mode="1" '

//-----------------------------------------------------------------------------------------
//  Text syntax.
//-----------------------------------------------------------------------------------------

STRING	i_DescSyntax=	'create column(band=detail id=10 border="0" ' + &
			'alignment="0" tabsequence=0 ' + &
			'name=stringdesc format="[general]" edit.limit=0 edit.case=any ' + &
			'edit.autoselect=yes edit.autohscroll=yes ' + &
			'background.mode="0" '

//-----------------------------------------------------------------------------------------
//  Row focus indicator syntax.
//-----------------------------------------------------------------------------------------

STRING 	i_RectSyntax= 	'create rectangle(band=detail ' + &
			'brush.hatch="6" ' + &
			'background.mode="1" ' 

end variables

forward prototypes
public subroutine fu_hlcollapseall ()
public subroutine fu_hlexpandall ()
public function integer fu_hlretrieve (integer level)
public function integer fu_hlrefresh (integer level, unsignedlong visualword)
public function long fu_hlgetselectedkey (ref string selectedkey[], long index)
public function long fu_hlgetselectedrow (long index)
public subroutine fu_hlselectall ()
private subroutine fu_hlsetlastingroup ()
public function integer fu_hlexpandlevel ()
public subroutine fu_hlcollapsebranch ()
public subroutine fu_hlsizeoptions (integer heightfactor, integer widthfactor, integer bmpheight, integer bmpwidth)
public subroutine fu_hlreset ()
public subroutine fu_hlexpand (integer levels)
public subroutine fu_hlcollapse (integer levels)
public function integer fu_hlinsertrow (integer level, string description, string sort, string key, string parentkey, string bmpopen, string bmpclose, unsignedlong visualword)
public function integer fu_hlgetrowlevel (long row)
public subroutine fu_hlkeydown (unsignedlong controlword)
public subroutine fu_hlsetselectedrow (long row)
public subroutine fu_hlclearselectedrows ()
public subroutine fu_hldeleterow (long row)
public subroutine fu_hlexpandbranch ()
public subroutine fu_hldeleteselectedrows (ref string deletedkeys[])
public subroutine fu_hlinsertsort ()
public function integer fu_hlgetrowkey (long row, ref string key[])
public subroutine fu_hldragbegin (dragobject object_name, string key[], string description[], string sort[], string bmp_open[], string bmp_close[])
public function long fu_hldragend (ref string key[], ref string description[], unsignedlong visualword)
public subroutine fu_hlsetupdatedrow (long row)
public function long fu_hlgetupdatedrow (long index)
public subroutine fu_hlclearupdatedrows ()
public function integer fu_hlcreate (transaction trans_object, integer maxlevels)
public function string fu_hlgetrowdesc (long row)
public function long fu_hlfindrow (string key_value, integer level)
public subroutine fu_hlselectall (integer level)
public function integer fu_hlsetrowdesc (long row, string row_desc)
public subroutine fu_hldragbegin (dragobject object_name, integer level, string key[], string description[], string sort[], string bmp_open[], string bmp_close[])
public function long fu_hldragend (ref integer level, ref string key[], ref string description[], unsignedlong visualword)
public subroutine fu_hlinsertoptions (integer level, string options)
public subroutine fu_hlretrieveoptions (integer level, string column_bmp_expand, string column_bmp_collapse, string column_key, string column_foreign_key, string column_desc, string column_sort, string table, string where_clause, string options)
private subroutine fu_hlsetoptions (string optionstyle, string options)
public subroutine fu_hloptions (string options)
public subroutine fu_hltextoptions (string textfont, integer textsize, string options)
public function string fu_getidentity ()
public subroutine fu_hlrowaction (long row, long key_down, integer action_type)
end prototypes

event po_collapsed;////******************************************************************
////  PO Module     : u_Outliner
////  Event         : po_Collapsed
////  Description   : Provides an opportunity for the developer to
////                  do any processing when a branch is collapsed.
////
////  Parameters    : LONG    SelectedRow - 
////                     Row number of the selected record.
////                  INTEGER SelectedLevel - 
////                     Level of the selected record.
////                  INTEGER MaxLevels - 
////                     Maximum levels for outliner.
////
////  Return Value  : (None)
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code for getting all keys that make up the current row.
////------------------------------------------------------------------
//
//INTEGER l_NumKeys
//STRING  l_TmpKey[]
//
//l_NumKeys = fu_HLGetRowKey(SelectedRow, l_TmpKey[])
//
////------------------------------------------------------------------
////  Sample code for getting only the key that pertains to the level
////  at the current row.
////------------------------------------------------------------------
//
//INTEGER l_NumKeys, l_Level
//STRING  l_TmpKey[]
//LONG    l_Key
//
//l_Level   = fu_HLGetRowLevel(SelectedRow)
//l_NumKeys = fu_HLGetRowKey(SelectedRow, l_TmpKey[])
//l_Key     = Long(l_TmpKey[l_Level])
end event

event po_expanded;////******************************************************************
////  PO Module     : u_Outliner
////  Event         : po_Expanded
////  Description   : Provides an opportunity for the developer to
////                  do any processing when a branch is expanded.
////
////  Parameters    : LONG    SelectedRow - 
////                     Row number of the selected record.
////                  INTEGER SelectedLevel - 
////                     Level of the selected record.
////                  INTEGER MaxLevels - 
////                     Maximum levels for outliner.
////
////  Return Value  : (None)
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code for getting all keys that make up the current row.
////------------------------------------------------------------------
//
//INTEGER l_NumKeys
//STRING  l_TmpKey[]
//
//l_NumKeys = fu_HLGetRowKey(SelectedRow, l_TmpKey[])
//
////------------------------------------------------------------------
////  Sample code for getting only the key that pertains to the level
////  at the current row.
////------------------------------------------------------------------
//
//INTEGER l_NumKeys, l_Level
//STRING  l_TmpKey[]
//LONG    l_Key
//
//l_Level   = fu_HLGetRowLevel(SelectedRow)
//l_NumKeys = fu_HLGetRowKey(SelectedRow, l_TmpKey[])
//l_Key     = Long(l_TmpKey[l_Level])
end event

event po_keydown;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : po_KeyDown
//  Description   : Process the keyboard input to expand and 
//                  collapse the outliner.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

THIS.fu_HLKeyDown(c_AutoKeyDown)
end event

event po_pickedrow;////******************************************************************
////  PO Module     : u_Outliner
////  Event         : po_PickedRow
////  Description   : Provides an opportunity for the developer to
////                  do any processing when a record is drilling
////                  down.
////
////  Parameters    : LONG    ClickedRow - 
////                     Row number of the drilled record.
////                  INTEGER ClickedLevel - 
////                     Level of the drilled record.
////                  INTEGER MaxLevels - 
////                     Maximum levels for outliner.
////
////  Return Value  : (None)
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code for getting the selected row.  This sample assumes
////  the key is a sequence number.
////------------------------------------------------------------------
//
//STRING l_TmpKey[]
//LONG   l_DrilledKey
//
//fu_HLGetRowKey(ClickedRow, l_TmpKey[])
//l_DrilledKey = Long(l_TmpKey[MaxLevels])
//
////------------------------------------------------------------------
////  Sample code for getting the multiple selected rows.  This sample
////  assumes the key is a sequence number.
////------------------------------------------------------------------
//
//STRING l_TmpKey[]
//LONG   l_SelectedKey[], l_LastRow, l_Index, l_NumSelected
//
//l_LastRow = RowCount()
//l_Index = 1
//DO
//   l_Index = fu_HLGetSelectedKey(l_TmpKey[], l_Index)
//   IF l_Index > 0 THEN
//      l_NumSelected = l_NumSelected + 1
//      l_Index       = l_Index + 1
//      l_SelectedKey[l_NumSelected] = Long(l_TmpKey[MaxLevels])
//      IF l_Index > l_LastRow THEN
//         l_Index = 0
//      END IF
//   END IF
//LOOP UNTIL l_Index = 0
end event

event po_validaterow;////******************************************************************
////  PO Module     : u_Outliner
////  Event         : po_ValidateRow
////  Description   : Provides an opportunity for the developer to
////                  validate a previously selected row before
////                  moving on with the currently selected row.
////
////  Parameters    : LONG    ClickedRow - 
////                     Row number of the new record.
////                  INTEGER ClickedLevel - 
////                     Level of the new record.
////                  LONG    SelectedRow - 
////                     Row number of the currently selected record.
////                  INTEGER SelectedLevel - 
////                     Level of the currently selected record.
////                  INTEGER MaxLevels - 
////                     Maximum levels for outliner.
////
////  Return Value  : i_RowError -
////                     Indicates if an error has occured in the 
////                     processing of this event.  Return -1
////                     to stop the new row from becoming the 
////                     current row.
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code for checking for changes in an associated 
////  DataWindow.  If update fails, return an error to prevent the
////  next row from being selected.
////------------------------------------------------------------------
//
//IF <datawindow>.ModifiedCount() or <datawindow>.DeletedCount() THEN
//   IF MessageBox("<title>", "Save Changes?", &
//                 Question!, YesNo!, 1) = 1 THEN
//      IF <datawindow>.Update() = -1 THEN
//         <datawindow>.SetFocus()
//         i_RowError = -1
//      END IF
//   END IF
//END IF
end event

event po_rdoubleclicked;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : RButtonDown
//  Description   : Determines a users action.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_ClickedRow, l_KeyDown
STRING l_ClickedObject

IF KeyDown(KeyControl!) THEN
   l_KeyDown = 9
ELSEIF KeyDown(KeyShift!) THEN
	l_KeyDown = 5
ELSE
	l_KeyDown = 0
END IF

l_ClickedObject = GetObjectAtPointer()

IF l_ClickedObject = "" THEN
	RETURN
END IF

l_ClickedRow = Long(MID(l_ClickedObject, Pos(l_ClickedObject, &
                    CHAR(9)) + 1))

THIS.fu_HLRowAction(l_ClickedRow, l_KeyDown, c_RightDoubleClick)

end event

event po_selectedrow;////******************************************************************
////  PO Module     : u_Outliner
////  Event         : po_SelectedRow
////  Description   : Provides an opportunity for the developer to
////                  do any processing when a record is selected.
////
////  Parameters    : LONG    SelectedRow - 
////                     Row number of the selected record.
////                  INTEGER SelectedLevel - 
////                     Level of the selected record.
////                  INTEGER MaxLevels - 
////                     Maximum levels for outliner.
////
////  Return Value  : i_RowError -
////                     Indicates if an error has occured in the 
////                     processing of this event.  Return -1
////                     to stop the processing before a drilldown
////                     action is processed.
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code for getting the selected row.  This sample assumes
////  the key is a sequence number.
////------------------------------------------------------------------
//
//STRING l_TmpKey[]
//LONG   l_SelectedKey
//
//fu_HLGetRowKey(SelectedRow, l_TmpKey[])
//l_SelectedKey = Long(l_TmpKey[MaxLevels])
//
////------------------------------------------------------------------
////  Sample code for getting the multiple selected rows.  This sample
////  assumes the key is a sequence number.
////------------------------------------------------------------------
//
//STRING l_TmpKey[]
//LONG   l_SelectedKey[], l_LastRow, l_Index, l_NumSelected
//
//l_LastRow = RowCount()
//l_Index = 1
//DO
//   l_Index = fu_HLGetSelectedKey(l_TmpKey[], l_Index)
//   IF l_Index > 0 THEN
//      l_NumSelected = l_NumSelected + 1
//      l_Index       = l_Index + 1
//      l_SelectedKey[l_NumSelected] = Long(l_TmpKey[MaxLevels])
//      IF l_Index > l_LastRow THEN
//         l_Index = 0
//      END IF
//   END IF
//LOOP UNTIL l_Index = 0
end event

event po_identify;//******************************************************************
//  PO Module     : u_Outliner
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

public subroutine fu_hlcollapseall ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLCollapseAll
//  Description   : Collapses all levels of the outliner.
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

LONG l_RowCount, l_FromRow, l_FindRow

SetPointer(HourGlass!)
l_RowCount = RowCount()

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//SetRedraw(FALSE)

//------------------------------------------------------------------
//  Initially set the detail height for all of the rows to be 0.
//------------------------------------------------------------------

SetDetailHeight(1, l_RowCount, 0)

//------------------------------------------------------------------
//  Set the collapsed attributes of any first level rows that are 
//  expanded.
//------------------------------------------------------------------

l_FindRow = 0
DO
	l_FromRow = l_FindRow + 1
	l_FindRow = Find("level = 1", l_FromRow, l_RowCount)
	IF l_FindRow > 0 THEN
		SetDetailHeight(l_FindRow, l_FindRow, i_HeightFactor)
		SetItem(l_FindRow, "expanded", 0)
	END IF
LOOP WHILE l_FindRow > 0 AND l_FindRow < l_RowCount

//------------------------------------------------------------------
//  Set the collapsed attributes for all rows except the first level.
//------------------------------------------------------------------

l_FindRow = 0
DO
	l_FromRow = l_FindRow + 1
	l_FindRow = Find("level <> 1 AND expanded = 1", &
                    l_FromRow, l_RowCount)
	IF l_FindRow > 0 THEN
		SetItem(l_FindRow, "expanded", 0)
	END IF
LOOP WHILE l_FindRow > 0 AND l_FindRow < l_RowCount

//------------------------------------------------------------------
//  Reset the current row to be row 1. 
//------------------------------------------------------------------

SetItem(i_FocusRow, "current", 0)
i_FocusRow = 1
SetItem(i_FocusRow, "current", 1)
ScrollToRow(i_FocusRow)

//SetRedraw(TRUE)		
end subroutine

public subroutine fu_hlexpandall ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLExpandAll
//  Description   : Expands all levels of the outliner.
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

LONG l_RowCount, l_FromRow, l_FindRow

SetPointer(HourGlass!)
l_RowCount = RowCount()

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//SetRedraw(FALSE)

//-------------------------------------------------------------------
//  Set the expanded attributes for any row that isn't already 
//  expanded.
//-------------------------------------------------------------------

l_FindRow = 0
DO
	l_FromRow = l_FindRow + 1
	l_FindRow = Find("expanded = 0", l_FromRow, l_RowCount)
	IF l_FindRow > 0 THEN
		SetItem(l_FindRow, "expanded", 1)
	END IF
LOOP WHILE l_FindRow > 0 AND l_FindRow < l_RowCount

//-------------------------------------------------------------------
//  Setting the detail height for all of the rows at once is much
//  faster than just setting for the rows that need it individually.
//-------------------------------------------------------------------

SetDetailHeight(1, l_RowCount, i_HeightFactor)

//SetRedraw(TRUE)		
end subroutine

public function integer fu_hlretrieve (integer level);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLRetrieve
//  Description   : Retrieves data for one or all levels for the
//                  outliner.  
//
//  Parameters    : INTEGER Level - 
//                     0  = retrieve all levels.
//                     >0 = retrieve only that level using the 
//                          parent key.
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

INTEGER l_Idx, l_Error, l_Jdx, l_Start, l_End, l_Pos
STRING  l_SortString, l_SortComma, l_Comma, l_Sort, l_Table, l_Where
STRING  l_Return, l_ExpandBMP, l_CollapseBMP, l_Key, l_And, l_Date
STRING  l_FillString, l_Distinct, l_Branch, l_ErrorStrings[]

//------------------------------------------------------------------
//  If records are being inserted manually or an invalid level is
//  given then return.
//------------------------------------------------------------------

IF i_InsertDefined OR level < 0 OR level > i_MaxLevels THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Set the transaction object for the retrieve.
//------------------------------------------------------------------

l_Error = SetTransObject(i_Transaction)
IF l_Error = -1 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  If the retrieve syntax for a level has not been defined, define
//  it.
//------------------------------------------------------------------

IF NOT i_RetrieveDefined THEN
   l_SortString = ""
   l_SortComma = ""
   FOR l_Idx = 1 TO i_MaxLevels

      //------------------------------------------------------------
      //  Determine if the bitmap is coming from the database or
      //  from a file.
      //------------------------------------------------------------

      IF i_DataBMP[l_Idx] THEN
         l_ExpandBMP   = i_DataBMPExpand[l_Idx]
         l_CollapseBMP = i_DataBMPCollapse[l_Idx]
      ELSE
         l_ExpandBMP   = "'" + i_DataBMPExpand[l_Idx] + "'"
         l_CollapseBMP = "'" + i_DataBMPCollapse[l_Idx] + "'"
      END IF

      //------------------------------------------------------------
      //  Build the sort string for DataWindow sort.
      //------------------------------------------------------------

      IF i_DataSortDirection[l_Idx] = "A" THEN
         l_SortString = l_SortString + l_SortComma + "#" + String(l_Idx + 10) + " A, #" + String(l_Idx + i_MaxLevels + 10) + " A"
         l_FillString = CHAR(8)
         IF l_Idx < i_MaxLevels THEN
            IF i_DataSortDirection[l_Idx + 1] = "D" THEN
               l_FillString = "z"
            END IF
         END IF
      ELSE
         l_SortString = l_SortString + l_SortComma + "#" + String(l_Idx + 10) + " D, #" + String(l_Idx + i_MaxLevels + 10) + " D"
         l_FillString = "z"
         IF l_Idx < i_MaxLevels THEN
            IF i_DataSortDirection[l_Idx + 1] = "A" THEN
               l_FillString = CHAR(8)
            END IF
         END IF
      END IF
      l_SortComma = ", "

      //------------------------------------------------------------
      //  If a key or sort column is of type date a database depend
      //  date constant must be included in the SQL syntax as a
      //  placeholder for upper levels.  If a database listed
      //  below doesn't include syntax for the desired database then
      //  fill it in.    
      //------------------------------------------------------------

      l_Date = OBJCA.DB.fu_GetDatabase(i_Transaction, OBJCA.DB.c_DB_DateString)

      IF l_Date = "" THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = GetParent().ClassName()
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_HLRetrieve"
         OBJCA.MSG.fu_DisplayMessage("DataTypeError", 5, &
			                            l_ErrorStrings[])
         RETURN -1
      END IF

      //------------------------------------------------------------
      //  Build the column portion of the SQL syntax using column
      //  names and constant placeholders of the correct data type.
      //------------------------------------------------------------

      l_Sort = ""
      FOR l_Jdx = 1 TO i_MaxLevels
         IF l_Jdx <= l_Idx THEN
            l_Sort = l_Sort + i_DataSort[l_Jdx] + ", "
         ELSE
            CHOOSE CASE i_DataSortType[l_Jdx]
               CASE "STRING"
                  l_Sort = l_Sort + "'" + Fill(l_FillString, 120) + "', "
               CASE "NUMBER"
                  l_Sort = l_Sort + "-1, "
               CASE "DATE"
                  l_Sort = l_Sort + l_Date + ", "
            END CHOOSE
         END IF
      NEXT

      l_Key = ""
      l_Comma = ""
      FOR l_Jdx = 1 TO i_MaxLevels
         IF l_Jdx <= l_Idx THEN
            l_Key = l_Key + l_Comma + i_DataKey[l_Jdx]
         ELSE
            CHOOSE CASE i_DataKeyType[l_Jdx]
               CASE "STRING"
                  l_Key = l_Key + l_Comma + "'" + Fill(l_FillString, 120) + "'"
               CASE "NUMBER"
                  l_Key = l_Key + l_Comma + "-1"
               CASE "DATE"
                  l_Key = l_Key + l_Comma + l_Date
            END CHOOSE
         END IF
         l_Comma = ", "
      NEXT

      //------------------------------------------------------------
      // Build the TABLE portion of the SQL syntax.
      //------------------------------------------------------------

      l_Table = ""
      l_Comma = ""
      FOR l_Jdx = 1 TO l_Idx
         l_Table = l_Table + l_Comma + i_DataTable[l_Jdx]
         l_Comma = ", "
      NEXT

      //------------------------------------------------------------
      // Build the WHERE portion of the SQL syntax.  Build the table
      // joins for each level.
      //------------------------------------------------------------

      l_Where = ""
      l_And = ""
      IF l_Idx > 1 THEN
         l_Where = " WHERE "
         FOR l_Jdx = 2 TO l_Idx
             l_Where = l_Where + l_And + "(" + &
                       i_DataKey[l_Jdx - 1] + " = " + &
                       i_DataForeignKey[l_Jdx] + ")"
             l_And = " AND "
         NEXT
      END IF

      l_And = ""
      IF l_Where = "" AND TRIM(i_DataWhere[l_Idx]) <> "" THEN
         l_Where = " WHERE "
      ELSEIF l_Idx > 1 THEN
         l_And = " AND "
      END IF

      FOR l_Jdx = 1 TO l_Idx
         IF TRIM(i_DataWhere[l_Jdx]) <> "" THEN
            l_Where = l_Where + l_And + "(" + i_DataWhere[l_Jdx] + ")" 
            l_And = " AND "
         END IF
      NEXT

      //------------------------------------------------------------
      // Check for a DISTINCT or UNIQUE word that might have been
      // attached to the description parameter.
      //------------------------------------------------------------

      l_Distinct = ""
      l_Pos = POS(Upper(i_DataDesc[l_Idx]), "DISTINCT ")
      IF l_POS > 0 THEN
         i_DataDesc[l_Idx] = MID(i_DataDesc[l_Idx], l_Pos + 9)
         l_Distinct = "DISTINCT "
      ELSE
         l_Pos = POS(Upper(i_DataDesc[l_Idx]), "UNIQUE ")
         IF l_POS > 0 THEN
            i_DataDesc[l_Idx] = MID(i_DataDesc[l_Idx], l_Pos + 7)
            l_Distinct = "UNIQUE "
         END IF
      END IF

      //------------------------------------------------------------
      // Build the complete SQL syntax from each piece.
      //------------------------------------------------------------

      IF i_CollapseOnOpen THEN
			l_Branch = "0"
		ELSE
			l_Branch = "1"
		END IF
		
		i_DataSyntax[l_Idx] = "SELECT " + l_Distinct + &
                                String(i_DataLevel[l_Idx]) + ", " + &
                                l_ExpandBMP + ", " + &
                                l_CollapseBMP + ", " + &
										  l_Branch + ", '', 0, " + &
                                "0, 0, 0, " + &
                                i_DataDesc[l_Idx] + ", " + &
                                l_Sort + l_Key + " FROM " + l_Table + &
                                l_Where
   NEXT
   
   //---------------------------------------------------------------
   // Set the sort criteria for the DataWindow.
   //---------------------------------------------------------------
   
   SetSort(l_SortString)
   i_RetrieveDefined = TRUE

END IF

//------------------------------------------------------------------
// Determine how many levels need to be retrieved.
//------------------------------------------------------------------

IF level = 0 THEN
   IF i_RetrieveAll THEN
      l_Start = 1
      l_End   = i_MaxLevels
   ELSE
      l_Start = 1
      l_End   = 1
   END IF
ELSE
   l_Start = level
   l_End   = level
END IF

//------------------------------------------------------------------
// Modify the SQL syntax for the DataWindow and retrieve the level.
//------------------------------------------------------------------

FOR l_Idx = l_Start TO l_End
   l_Return = Modify('datawindow.table.select="' + &
                       i_DataSyntax[l_Idx] + '"')
   IF l_Return <> "" THEN
      RETURN -1
   END IF

   l_Error = Retrieve()

   IF l_Error < 0 THEN
      RETURN -1
   END IF
NEXT

//------------------------------------------------------------------
// Sort the data.
//------------------------------------------------------------------

Sort()

RETURN 0


end function

public function integer fu_hlrefresh (integer level, unsignedlong visualword);//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLRefresh
//  Description   : Refreshes the outliner by re-retrieving and
//                  re-selecting the records.
//
//  Parameters    : INTEGER Level - 
//                     Level at which the refreshing should start.
//                  ULONG   VisualWord - 
//                     Options for reselection of records.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = refresh failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG    l_Idx, l_EndRow, l_StartRow, l_NumKeys, l_Row, l_Index
LONG    l_NumRows, l_Jdx, l_FocusRow
BOOLEAN l_Reselect
INTEGER l_Error, l_NumLevels
STRING  l_SelectedKey[], l_Keys[], l_Quote[], l_Find, l_And

//------------------------------------------------------------------
//  A refresh cannot be done if the retrieve has not been defined.
//------------------------------------------------------------------

IF NOT i_RetrieveDefined THEN
   RETURN -1
END IF

SetPointer(HourGlass!)
SetReDraw(FALSE)

//------------------------------------------------------------------
//  Determine if previously selected records should be re-selected
//  after the refresh.
//------------------------------------------------------------------

IF VisualWord = c_ReselectRows THEN
   l_Reselect = TRUE
ELSE
   l_Reselect = FALSE
END IF

//------------------------------------------------------------------
//  If rows are to be refreshed, save the keys of the selected rows.
//------------------------------------------------------------------

IF l_Reselect THEN
   l_StartRow = 1
   l_EndRow = RowCount()
   l_NumKeys = 0
   l_NumRows = 0
   DO
      l_Row = THIS.fu_HLGetSelectedKey(l_SelectedKey[], l_StartRow)
      IF l_Row > 0 THEN
         l_NumRows = l_NumRows + 1
			l_NumLevels = UpperBound(l_SelectedKey[])
         FOR l_Idx = 1 TO l_NumLevels
            l_NumKeys = l_NumKeys + 1
            l_Keys[l_NumKeys] = l_SelectedKey[l_Idx]
         NEXT
         IF l_Row = l_EndRow THEN
            l_Row = 0
         ELSE
            l_StartRow = l_Row + 1
         END IF
      END IF
   LOOP UNTIL l_Row = 0
END IF

//------------------------------------------------------------------
//  If the level to refresh is 0 (all) or 1 then just discard all
//  the rows in the DataWindow.
//------------------------------------------------------------------

l_EndRow = RowCount()
IF level = 0 OR level = 1 THEN
   level = 0
   RowsDiscard(1, l_EndRow, Primary!)

//------------------------------------------------------------------
//  If the level to refresh is > 1 then discard all rows greater
//  than or equal to the given level.
//------------------------------------------------------------------

ELSE
   FOR l_Idx = l_EndRow TO 1 STEP -1
      IF GetItemNumber(l_Idx, "level") >= level THEN
         RowsDiscard(l_Idx, l_Idx, Primary!)
      END IF
   NEXT
END IF
      
//------------------------------------------------------------------
//  Retrieve each level greater than or equal to the given level.
//------------------------------------------------------------------

i_IgnoreRFC = TRUE
IF level = 0 THEN
   l_Error = THIS.fu_HLRetrieve(0)
ELSE
   FOR l_Idx = level TO i_MaxLevels
      l_Error = THIS.fu_HLRetrieve(l_Idx)
      IF l_Error = -1 THEN
         EXIT
      END IF
   NEXT
END IF

IF l_Error = -1 THEN
   i_IgnoreRFC = FALSE
   RETURN -1
END IF

//------------------------------------------------------------
//  Calculate the last in group rows.
//------------------------------------------------------------

l_EndRow = RowCount()
DO WHILE Find("showline = ''", 1, l_EndRow) > 0
   THIS.fu_HLSetLastInGroup()
LOOP

//---------------------------------------------------------------
//  If all levels were refreshed, expand level 1 to start.
//---------------------------------------------------------------

IF level = 0 THEN
   FOR l_Idx = 1 to l_EndRow
      IF GetItemNumber(l_Idx, "level") = 1 THEN
         SetItem(l_Idx, "expanded", 0)
         SetDetailHeight(l_Idx, l_Idx, i_HeightFactor)
      END IF
   NEXT
END IF

//---------------------------------------------------------------
//  Set the focus row if it exists.
//---------------------------------------------------------------

l_FocusRow = Find("current = 1", 1, l_EndRow)
IF l_FocusRow > 0 THEN
   i_FocusRow = l_FocusRow
ELSE  
   i_FocusRow  = 1
   SetItem(i_FocusRow, "current", 1)
END IF
ScrollToRow(i_FocusRow)

//------------------------------------------------------------------
//  If reselect is on, reselect the previously selected rows.
//------------------------------------------------------------------

IF l_Reselect THEN
   l_StartRow = 1
   FOR l_Idx = 1 TO l_NumLevels
      IF i_DataKeyType[l_Idx] = "STRING" THEN
         l_Quote[l_Idx] = "'"
      ELSE
         l_Quote[l_Idx] = ""
      END IF
   NEXT

   FOR l_Idx = 1 TO l_NumRows
      l_Index = (l_Idx - 1) * l_NumLevels + 1
      l_Find = ""
      l_And = ""
      FOR l_Jdx = 1 TO l_NumLevels
         l_Find = l_Find + l_And + "key" + String(l_Jdx) + " = " + &
                  l_Quote[l_Jdx] + l_Keys[l_Index + l_Jdx - 1] + &
                  l_Quote[l_Jdx]
         l_And = " AND "
      NEXT
      l_Row = Find(l_Find, 1, l_EndRow)
      IF l_Row > 0 THEN
         SetItem(l_Row, "selected", 1)
      END IF
   NEXT
END IF

i_IgnoreRFC = FALSE
SetReDraw(TRUE)

RETURN l_Error
end function

public function long fu_hlgetselectedkey (ref string selectedkey[], long index);//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLGetSelectedKey
//  Description   : Returns the keys for the next selected record.
//                  The return value may be used to initiate the
//                  search for the next selected record.
//
//  Parameters    : STRING SelectedKey[] - 
//                     Array of keys from level one to the
//                     current level for the selected record.
//                  LONG   Index - 
//                     Row number after which to begin the search.
//
//  Return Value  : LONG - 
//                     Row number of the selected record.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG   l_Row, l_EndRow, l_Idx, l_CurrentLevel
STRING l_Column, l_NullString[]

l_EndRow = RowCount()

//-------------------------------------------------------------------
//  Find the first selected row after the given index row.
//-------------------------------------------------------------------

l_Row = Find("selected = 1", index, l_EndRow)

//-------------------------------------------------------------------
//  If a selected row is found, return an array of keys for all
//  levels.  The array is of type string because the key at each
//  level may be of a different data type.
//-------------------------------------------------------------------

SetNull(l_NullString[1])
SelectedKey[] = l_NullString[]

IF l_Row > 0 THEN
   l_CurrentLevel = fu_HLGetRowLevel(l_Row)
   FOR l_Idx = 1 TO l_CurrentLevel
      l_Column = "key" + String(l_Idx)
      CHOOSE CASE i_DataKeyType[l_Idx]
         CASE "STRING"
            SelectedKey[l_Idx] = GetItemString(l_Row, l_Column)
         CASE "NUMBER"
            SelectedKey[l_Idx] = String(GetItemNumber(l_Row, l_Column))
         CASE "DATE"
            SelectedKey[l_Idx] = String(GetItemDate(l_Row, l_Column), "yyyymmdd")
      END CHOOSE
   NEXT
END IF

RETURN l_Row
end function

public function long fu_hlgetselectedrow (long index);//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLGetSelectedRow
//  Description   : Returns the row number of the next selected 
//                  record.  The return value may be used to 
//                  initiate the search for the next selected record.
//
//  Parameters    : LONG Index - 
//                     Row number after which to begin the search.
//
//  Return Value  : LONG - 
//                     Row number of the selected record.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG   l_EndRow

//-------------------------------------------------------------------
//  Return the next selected row after the given index row.
//-------------------------------------------------------------------

l_EndRow = RowCount()

RETURN Find("selected = 1", index, l_EndRow)

end function

public subroutine fu_hlselectall ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLSelectAll
//  Description   : Selects all records at the lowest level in the
//                  outliner.
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

LONG l_EndRow, l_Idx

//------------------------------------------------------------------
//  If the outliner doesn't allow multi-select, do nothing.
//------------------------------------------------------------------

IF NOT i_MultiSelect THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Make sure that no upper level rows are selected.
//------------------------------------------------------------------

fu_HLClearSelectedRows()

//------------------------------------------------------------------
//  Cycle through all the rows at the lowest level and set the
//  row selection attribute on.
//------------------------------------------------------------------

l_EndRow = RowCount()
FOR l_Idx = 1 TO l_EndRow
   IF GetItemNumber(l_Idx, "level") = i_MaxLevels THEN
      SetItem(l_Idx, "selected", 1)
   END IF
NEXT
end subroutine

private subroutine fu_hlsetlastingroup ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLSetLastInGroup
//  Description   : Calculates the records that are last in a group
//                  for the purpose of correctly drawing lines.
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
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

LONG    l_RowCount, l_Idx, l_StartRow, l_EndRow, l_UnusedRow
LONG    l_LastLevelTwo
INTEGER l_CurrentLevel, l_NextLevel
STRING  l_CurrentLine, l_LineString, l_NextLine

l_RowCount  = RowCount()
l_LineString = Fill("0", i_MaxLevels)

//------------------------------------------------------------------
//  Clear the "unused" columns.
//------------------------------------------------------------------

l_UnusedRow = Find("unused = -1", l_RowCount, 1)
IF l_UnusedRow > 0 THEN
   SetItem(l_UnusedRow, "unused", 0)
   IF l_UnusedRow > 1 THEN
      l_UnusedRow = Find("unused = -1", l_UnusedRow - 1, 1)
      IF l_UnusedRow > 0 THEN
         SetItem(l_UnusedRow, "unused", 0)
      END IF
   END IF
END IF

//------------------------------------------------------------------
//  Set the "unused" columns.
//------------------------------------------------------------------

SetItem(l_RowCount, "unused", -1)

l_LastLevelTwo = Find("level = 2", l_RowCount, 2)
IF l_LastLevelTwo > 0 AND l_LastLevelTwo <> l_RowCount THEN
   IF GetItemNumber(l_LastLevelTwo + 1, "level") > 1 THEN
      SetItem(l_LastLevelTwo, "unused", -1)
   END IF
END IF

//------------------------------------------------------------------
//  Determine which lines to show.
//------------------------------------------------------------------

IF Find("showline = ''", l_RowCount, 2) = 0 THEN
	IF Find("IsNull(showline)", l_RowCount, 2) = 0 THEN
		RETURN
	ELSE
		l_StartRow = Find("IsNull(showline)", l_RowCount, 2)
		l_EndRow = find("NOT IsNull(showline)", l_StartRow, 2)
		IF l_EndRow = 0 THEN
			l_EndRow = 2
		END IF
	END IF
ELSE
	l_StartRow = Find("showline = ''", l_Rowcount, 2)
	l_EndRow = Find("showline <> ''", l_StartRow, 2)
	IF l_EndRow = 0 THEN
		l_EndRow = 2
	END IF
END IF

IF l_StartRow <> l_RowCount THEN
   l_NextLine = GetItemString(l_StartRow + 1, "showline")
END IF

FOR l_Idx = l_StartRow TO l_EndRow STEP -1
   l_CurrentLevel = GetItemNumber(l_Idx, "level")
   l_CurrentLine = l_LineString
   IF l_Idx < l_RowCount THEN
      l_NextLevel = GetItemNumber(l_Idx + 1, "level")
      IF l_CurrentLevel = 1 THEN
         l_CurrentLine = l_LineString
      ELSEIF l_CurrentLevel < l_NextLevel THEN
         l_CurrentLine = Replace(l_NextLine, l_CurrentLevel, i_MaxLevels - l_CurrentLevel + 1, Fill("0", i_MaxLevels - l_CurrentLevel + 1))
         l_CurrentLine = Replace(l_CurrentLine, l_CurrentLevel - 1, 1, "1")
      ELSEIF l_CurrentLevel = l_NextLevel THEN
         l_CurrentLine = l_NextLine
      ELSE
         l_CurrentLine = Replace(l_NextLine, l_CurrentLevel - 1, 1, "1")
         IF l_NextLevel = 1 THEN
            l_CurrentLine = Replace(l_CurrentLine, 1, 1, "1")
         END IF
      END IF
   ELSE
      IF l_CurrentLevel > 1 THEN
         l_CurrentLine = Replace(l_CurrentLine, l_CurrentLevel - 1, 1, "1")
      END IF
   END IF
   SetItem(l_Idx, "showline", l_CurrentLine)
   l_NextLine = l_CurrentLine
NEXT   

SetItem(1, "showline", l_LineString)
end subroutine

public function integer fu_hlexpandlevel ();//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLExpandLevel
//  Description   : Expands to the next level.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER - 
//                      0 = OK.
//                     -1 = retrieve as needed failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_RetrieveDone
INTEGER l_CurrentLevel, l_NextLevel
LONG    l_CurrentRow, l_RowCount, l_Error, l_EndRow, l_Idx
LONG    l_NewRowCount, l_FromRow, l_FindRow
STRING  l_Key, l_DataSyntax, l_Return

l_RowCount     = RowCount()
l_CurrentRow   = i_ClickedRow
l_CurrentLevel = GetItemNumber(l_CurrentRow, "Level")

//-------------------------------------------------------------------
//  If the level is the lowest level or were on the last row in the
//  outliner then return. 
//-------------------------------------------------------------------

IF l_CurrentLevel = i_MaxLevels OR &
   (l_CurrentRow = l_RowCount AND i_RetrieveAll) THEN
	SetItem(l_CurrentRow, "expanded", 1)
   RETURN 0
END IF

//-------------------------------------------------------------------
//  If retrieve all is on, set the current rows expand attributes on. 
//-------------------------------------------------------------------

IF i_RetrieveAll THEN
   l_NextLevel = GetItemNumber(l_CurrentRow + 1, "level")
   IF l_NextLevel = l_CurrentLevel THEN
      SetItem(l_CurrentRow, "expanded", 1) 
      RETURN 0
   END IF
   l_RetrieveDone = TRUE

//-------------------------------------------------------------------
//  If retrieve as needed in on, determine if the next level needs 
//  to be retrieved.
//-------------------------------------------------------------------

ELSE
   IF l_CurrentRow <> l_RowCount THEN
      l_NextLevel = GetItemNumber(l_CurrentRow + 1, "level")
      IF l_NextLevel > l_CurrentLevel THEN
         l_RetrieveDone = TRUE
      ELSE
         l_RetrieveDone = FALSE
         l_NextLevel = l_CurrentLevel + 1
      END IF
   ELSE
      l_RetrieveDone = FALSE
      l_NextLevel = l_CurrentLevel + 1
   END IF
END IF

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//SetRedraw(FALSE)

//-------------------------------------------------------------------
//  If data already exists at the next level, find all the rows and 
//  set their expand attributes on.
//-------------------------------------------------------------------

IF i_RetainOnCollapse AND l_RetrieveDone THEN

   //----------------------------------------------------------------
   //  Set the expand attribute on for the current row.
   //----------------------------------------------------------------

   SetItem(l_CurrentRow, "expanded", 1) 

   //----------------------------------------------------------------
   //  Set the expand attribute on for all the rows in the next
   //  level.
   //----------------------------------------------------------------

   l_EndRow = Find("level <= " + String(l_CurrentLevel), &
                l_CurrentRow + 1, l_RowCount)

   IF l_EndRow = 0 THEN
      l_EndRow = l_RowCount
   ELSE
	   l_EndRow = l_EndRow - 1
   END IF

	IF l_CurrentLevel + 1 = i_MaxLevels THEN
		SetDetailHeight(l_CurrentRow + 1, l_EndRow, i_HeightFactor)
	ELSE
		l_FindRow = l_CurrentRow
		DO
			l_FromRow = l_FindRow + 1
			l_FindRow = Find("level = " + String(l_CurrentLevel + 1), &
							  	  l_FromRow, l_EndRow)
			IF l_FindRow > 0 THEN
				SetDetailHeight(l_FindRow, l_FindRow, i_HeightFactor)
			END IF
		LOOP WHILE l_FindRow > 0 AND l_FindRow < l_EndRow
	END IF

   //----------------------------------------------------------------
   //  Set the selected row and level and trigger the expand event
   //  for the developer.
   //----------------------------------------------------------------

   i_SelectedRow = i_ClickedRow
   i_SelectedLevel = l_CurrentLevel
   Event po_Expanded(i_SelectedRow, i_SelectedLevel, i_MaxLevels)

//-------------------------------------------------------------------
//  If data does NOT exist at the next level, attempt to retrieve
//  it from the database.
//-------------------------------------------------------------------

ELSE
   SetPointer(HourGlass!)
   IF i_RetrieveDefined THEN

      //-------------------------------------------------------------
      //  Add syntax for the parent key to the end of the SQL
      //  statement for the current level.
      //-------------------------------------------------------------

      l_DataSyntax = i_DataSyntax[l_NextLevel]
      FOR l_Idx = 1 TO l_CurrentLevel
         CHOOSE CASE i_DataKeyType[l_Idx]
            CASE "STRING"
               l_Key        = GetItemString(l_CurrentRow, "key" + String(l_Idx))
               l_DataSyntax = l_DataSyntax + &
                              " AND " + i_DataKey[l_Idx] + &
                              " = '" + l_Key + "'"
            CASE "NUMBER"
               l_Key        = String(GetItemNumber(l_CurrentRow, "key" + String(l_Idx)))
               l_DataSyntax = l_DataSyntax + &
                              " AND " + i_DataKey[l_Idx] + &
                              " = " + l_Key
         END CHOOSE
      NEXT

      //-------------------------------------------------------------
      //  Change the SQL in the DataWindow.
      //-------------------------------------------------------------

      l_Return = Modify('datawindow.table.select="' + &
                        l_DataSyntax + '"')
      IF l_Return <> "" THEN
         SetReDraw(TRUE)
         RETURN -1
      END IF

      //-------------------------------------------------------------
      //  Retrieve the data and append it to the bottom of the 
      //  DataWindow.
      //-------------------------------------------------------------

      i_IgnoreRFC = TRUE
      l_Error = Retrieve()
      i_IgnoreRFC = FALSE
		l_NewRowCount = RowCount()
      IF l_Error <= 0 OR l_RowCount = l_NewRowCount THEN
         SetReDraw(TRUE)
         RETURN -1
      END IF

      //-------------------------------------------------------------
      //  Set the current rows expand attributes on.
      //-------------------------------------------------------------

      SetItem(l_CurrentRow, "expanded", 1) 

      //-------------------------------------------------------------
      //  Sort the data so that the new data will be positioned
      //  correctly in the outliner.
      //-------------------------------------------------------------

      Sort()
      THIS.fu_HLSetLastInGroup()

      //-------------------------------------------------------------
      //  Find the rows at the next level and change their expand
      //  attributes to on.
      //-------------------------------------------------------------

      l_EndRow = Find("level <= " + String(l_CurrentLevel), &
                      l_CurrentRow + 1, l_NewRowCount)

      IF l_EndRow = 0 THEN
			l_EndRow = l_NewRowCount
		ELSE
	      l_EndRow = l_EndRow - 1
      END IF

      SetDetailHeight(l_CurrentRow + 1, l_EndRow, i_HeightFactor)
   ELSE
      SetItem(l_CurrentRow, "expanded", 1) 
   END IF

   //----------------------------------------------------------------
   //  Set the selected row and level and trigger the expand event
   //  for the developer.
   //----------------------------------------------------------------

   ScrollToRow(l_CurrentRow)

   i_SelectedRow = i_ClickedRow
   i_SelectedLevel = l_CurrentLevel
   Event po_Expanded(i_SelectedRow, i_SelectedLevel, i_MaxLevels)
 
END IF

//SetRedraw(TRUE)

RETURN 0

end function

public subroutine fu_hlcollapsebranch ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLCollapseBranch
//  Description   : Collapses the current branch of the outliner.
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

LONG l_CurrentRow, l_FindRow, l_RowCount, l_EndRow, l_FromRow
INTEGER l_CurrentLevel, l_NextLevel

l_RowCount = RowCount()
l_CurrentRow = i_ClickedRow

//------------------------------------------------------------------
//  If the last row in the outliner is selected then we only need to
//  collapse the current row. 
//------------------------------------------------------------------

IF l_CurrentRow = l_RowCount THEN
	SetItem(l_CurrentRow, "expanded", 0)
	RETURN
END IF

//------------------------------------------------------------------
//  Get the current level and the next level.  If the next level
//  is less than or equal to the current level then we only need to
//  collapse the current row.
//------------------------------------------------------------------

l_CurrentLevel = GetItemNumber(l_CurrentRow, "Level")
l_NextLevel    = GetItemNumber(l_CurrentRow + 1, "level")

IF l_NextLevel <= l_CurrentLevel THEN
	SetItem(l_CurrentRow, "expanded", 0)
	RETURN
END IF

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//SetRedraw(FALSE)

//------------------------------------------------------------------
//  Set the current rows attributes to be collapsed.
//------------------------------------------------------------------

SetItem(l_CurrentRow, "expanded", 0)

//------------------------------------------------------------------
//  Find the last row in the next levels group that needs to be 
//  collapsed. 
//------------------------------------------------------------------

l_EndRow = Find("level <= " + String(l_CurrentLevel), &
                l_CurrentRow + 1, l_RowCount)

IF l_EndRow = 0 THEN
   l_EndRow = l_RowCount
ELSE
	l_EndRow = l_EndRow - 1
END IF

//------------------------------------------------------------------
//  If the data is to be retained on collapse, set the row
//  attributes to be collapsed.  If the data is to be deleted, 
//  discard the rows. 
//------------------------------------------------------------------

IF i_RetainOnCollapse THEN
   SetDetailHeight(l_CurrentRow + 1, l_EndRow, 0)
	l_FindRow = l_CurrentRow
	DO
		l_FromRow = l_FindRow + 1
		l_FindRow = Find("expanded = 1", l_FromRow, l_EndRow)
		IF l_FindRow > 0 THEN
      	SetItem(l_FindRow, "expanded", 0)
		END IF
	LOOP WHILE l_FindRow > 0 AND l_FindRow < l_EndRow
ELSE
   RowsDiscard(l_CurrentRow + 1, l_EndRow, Primary!)
END IF

//------------------------------------------------------------------
//  Set the current row to be the clicked row and trigger the
//  collapsed event for the developer. 
//------------------------------------------------------------------

i_SelectedRow = i_ClickedRow
i_SelectedLevel = l_CurrentLevel
Event po_Collapsed(i_SelectedRow, i_SelectedLevel, i_MaxLevels)

//SetRedraw(TRUE)
end subroutine

public subroutine fu_hlsizeoptions (integer heightfactor, integer widthfactor, integer bmpheight, integer bmpwidth);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLSizeOptions
//  Description   : Establishes the size of the record and bitmap
//                  portion of the outliner object.  All sizes must
//                  be given in pixels.  
//
//  Parameters    : INTEGER HeightFactor - 
//                     Detail height of the DataWindow record.
//                  INTEGER WidthFactor - 
//                     Indent of the bitmap from one level to the 
//                     next.
//                  INTEGER BMPHeight - 
//                     Height of the bitmap.
//                  INTEGER BMPWidth - 
//                     Width of the bitmap.
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

//------------------------------------------------------------------
//  Set the height of the detail band of the DataWindow.
//------------------------------------------------------------------

IF HeightFactor <> c_DefaultHeight THEN
   i_HeightFactor = HeightFactor
   i_HeightMidFactor = Truncate((i_HeightFactor - 1) / 2, 0)
   i_HeightAdjFactor = Round((i_HeightFactor - i_BMPHeight) / 2, 0)
END IF

//------------------------------------------------------------------
//  Set the indent (distance between the center of the bitmaps for
//  any two levels) of the levels.
//------------------------------------------------------------------

IF WidthFactor <> c_DefaultWidth THEN
   i_WidthFactor = WidthFactor
   i_WidthAdjFactor = Round((i_WidthFactor - i_BMPWidth) / 2, 0)
   i_WidthMidFactor = Round(i_WidthFactor / 2 , 0) - i_WidthAdjFactor
END IF

//------------------------------------------------------------------
//  Set the height of the bitmap.
//------------------------------------------------------------------

IF BMPHeight <> c_DefaultBMPHeight THEN
   i_BMPHeight = BMPHeight
   i_HeightAdjFactor = Round((i_HeightFactor - i_BMPHeight) / 2, 0)
END IF

//------------------------------------------------------------------
//  Set the width of the bitmap.
//------------------------------------------------------------------

IF BMPWidth <> c_DefaultBMPWidth THEN
   i_BMPWidth = BMPWidth
   i_WidthAdjFactor = Round((i_WidthFactor - i_BMPWidth) / 2, 0)
   i_WidthMidFactor = Round(i_WidthFactor / 2 , 0) - i_WidthAdjFactor
END IF
 
end subroutine

public subroutine fu_hlreset ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLReset
//  Description   : Resets the outliner.
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

i_IgnoreRFC = TRUE
Reset()
i_IgnoreRFC = FALSE
end subroutine

public subroutine fu_hlexpand (integer levels);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLExpand
//  Description   : Expands all levels from level one to the given
//                  level.
//
//  Parameters    : INTEGER Level - 
//                     Level to expand to.
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

INTEGER l_Idx, l_RowCount, l_Level

SetPointer(HourGlass!)
l_RowCount = RowCount()

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//SetRedraw(FALSE)

//-------------------------------------------------------------------
//  Cycle through each row and determine if the level is less than or
//  equal to the given level. 
//-------------------------------------------------------------------

FOR l_Idx = 1 to l_RowCount
	l_Level = GetItemNumber(l_Idx, "level")

   //----------------------------------------------------------------
   //  If the level is less than or equal to the given level, set
   //  the expand attributes for the row. 
   //----------------------------------------------------------------

   IF l_Level <= Levels THEN
	   SetDetailHeight(l_Idx, l_Idx, i_HeightFactor)
      IF l_Level < Levels THEN
	      SetItem(l_Idx, "expanded", 1)
      ELSE
         SetItem(l_Idx, "expanded", 0)
      END IF

   //----------------------------------------------------------------
   //  If the level is greater than the given level, set
   //  the collapse attributes for the row. 
   //----------------------------------------------------------------

   ELSE
	   SetItem(l_Idx, "expanded", 0)
	   SetDetailHeight(l_Idx, l_Idx, 0)
   END IF
NEXT

//-------------------------------------------------------------------
//  Set the row focus to the first row. 
//-------------------------------------------------------------------

SetItem(i_FocusRow, "current", 0)
i_FocusRow = 1
SetItem(i_FocusRow, "current", 1)
ScrollToRow(i_FocusRow)

//SetRedraw(TRUE)		
end subroutine

public subroutine fu_hlcollapse (integer levels);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLCollapse
//  Description   : Collapses all levels of the outliner from the
//                  given level to the last level.
//
//  Parameters    : INTEGER Level - 
//                     Level at which to start collapsing from.
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

INTEGER l_Level, l_Idx, l_RowCount

SetPointer(HourGlass!)
l_RowCount = RowCount()

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//SetRedraw(FALSE)

//------------------------------------------------------------------
//  Cycle through each record and determine if the level is
//  greater than or equal to the given level.
//------------------------------------------------------------------

FOR l_Idx = l_RowCount to 1 STEP -1
	l_Level = GetItemNumber(l_Idx, "level")
	IF l_Level >= Levels THEN

      //------------------------------------------------------------
      //  If the level is 1 then collapse it but don't set the
      //  row height to 0.
      //------------------------------------------------------------

      IF l_Level = 1 THEN
		   SetItem(l_Idx, "expanded", 0)

      //------------------------------------------------------------
      //  If data is to be retained on collapse then set the row
      //  height to 0 and change the row attributes to collapsed.
      //  If the data is NOT to be retained, discard the row.
      //------------------------------------------------------------

	   ELSE
         IF i_RetainOnCollapse THEN
		      SetItem(l_Idx, "expanded", 0)
		      SetDetailHeight(l_Idx, l_Idx, 0)
         ELSE
            RowsDiscard(l_Idx, l_Idx, Primary!)
         END IF
      END IF
	ELSEIF l_Level + 1 = Levels THEN
		SetItem(l_Idx, "expanded", 0)
	END IF
NEXT

//------------------------------------------------------------------
//  Reset the current row to be row 1. 
//------------------------------------------------------------------

SetItem(i_FocusRow, "current", 0)
i_FocusRow = 1
SetItem(i_FocusRow, "current", 1)
ScrollToRow(i_FocusRow)

//SetRedraw(TRUE)		
end subroutine

public function integer fu_hlinsertrow (integer level, string description, string sort, string key, string parentkey, string bmpopen, string bmpclose, unsignedlong visualword);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLInsertRow
//  Description   : Inserts a row manually.
//
//  Parameters    : INTEGER Level - 
//                     Level in the outliner that the row is insert
//                     into.
//                  STRING  Description - 
//                     Text to display.
//                  STRING  Sort - 
//                     Text to use as a sort key.
//                  STRING  Key - 
//                     Text to use as a key.  The text will be 
//                     converted to the correct data type for
//                     the level.
//                  STRING  ParentKey - 
//                     Text to use as the parent key.  The text 
//                     will be converted to the correct data type 
//                     for the parent level.
//                  STRING  BMPOpen - 
//                     Name of a bitmap file to display for 
//                     expanded levels.
//                  STRING  BMPClose - 
//                     Name of a bitmap file to display for 
//                     collapsed levels.
//                  ULONG   VisualWord - 
//                     Options for manually inserting records.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = insert failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_Expand
STRING  l_Column, l_Key, l_Sort, l_SortString, l_SortComma
LONG    l_Row, l_CurrentRow, l_Idx, l_EndRow, l_NumKeys

//------------------------------------------------------------------
//  If data is being retrieved from the database or an invalid level
//  is given, then return.
//------------------------------------------------------------------

IF i_RetrieveDefined OR level <= 0 OR level > i_MaxLevels THEN
   RETURN -1
END IF

//------------------------------------------------------------------
// Determine if the row should be inserted expanded or collapsed.
//------------------------------------------------------------------

IF VisualWord = c_InsertRowExpanded THEN
   l_Expand = TRUE
ELSE
   l_Expand = FALSE
END IF

//------------------------------------------------------------------
//  Determine if the insert criteria has been defined.  If not, 
//  build the sort criteria.
//------------------------------------------------------------------

IF NOT i_InsertSortDefined THEN
   l_SortString = ""
   l_SortComma = ""
   FOR l_Idx = 1 TO i_MaxLevels
      IF i_DataSortDirection[l_Idx] = "A" THEN
         l_SortString = l_SortString + l_SortComma + "#" + String(l_Idx + 10) + " A, #" + String(l_Idx + i_MaxLevels + 10) + " A"
         i_InsertFillString[l_Idx] = CHAR(8)
         IF l_Idx < i_MaxLevels THEN
            IF i_DataSortDirection[l_Idx + 1] = "D" THEN
               i_InsertFillString[l_Idx] = "z"
            END IF
         END IF
      ELSE
         l_SortString = l_SortString + l_SortComma + "#" + String(l_Idx + 10) + " D, #" + String(l_Idx + i_MaxLevels + 10) + " D"
         i_InsertFillString[l_Idx] = "z"
         IF l_Idx < i_MaxLevels THEN
            IF i_DataSortDirection[l_Idx + 1] = "A" THEN
               i_InsertFillString[l_Idx] = CHAR(8)
            END IF
         END IF
      END IF
      l_SortComma = ", "
   NEXT

   SetSort(l_SortString)
   i_InsertSortDefined = TRUE
END IF

//------------------------------------------------------------------
//  Find the parent row of the new row.
//------------------------------------------------------------------

l_EndRow = RowCount()
IF level > 1 AND l_EndRow > 0 THEN
   l_Column = "key" + String(level - 1)
   CHOOSE CASE i_DataKeyType[level - 1]
      CASE "STRING"
         l_Row = Find(l_Column + " = '" + parentkey + "'", 1, l_EndRow)
      CASE "NUMBER"
         l_Row = Find(l_Column + " = " + parentkey, 1, l_EndRow)
   END CHOOSE
   IF l_Row > 0 THEN
      l_NumKeys = level
   ELSE
      l_NumKeys = 0
   END IF
ELSE
   l_NumKeys = 0
   l_Row = 0
END IF

//------------------------------------------------------------------
//  Insert the new row and set its values.
//------------------------------------------------------------------

i_IgnoreRFC = TRUE
InsertRow(0)
l_CurrentRow = RowCount()

SetItem(l_CurrentRow, "level", level)
SetItem(l_CurrentRow, "bmpopen", bmpopen)
SetItem(l_CurrentRow, "bmpclose", bmpclose)
SetItem(l_CurrentRow, "showline", "")
SetItem(l_CurrentRow, "unused", 0)
SetItem(l_CurrentRow, "selected", 0)
SetItem(l_CurrentRow, "current", 0)
SetItem(l_CurrentRow, "stringdesc", description)
SetItem(l_CurrentRow, "updated", 1)

//------------------------------------------------------------------
//  Set the row to be expanded or collapsed.
//------------------------------------------------------------------

IF l_Expand THEN
   SetItem(l_CurrentRow, "expanded", 1)
   SetDetailHeight(l_CurrentRow, l_CurrentRow, i_HeightFactor)
ELSE
   SetItem(l_CurrentRow, "expanded", 0)
   IF level = 1 THEN
      SetDetailHeight(l_CurrentRow, l_CurrentRow, i_HeightFactor)
   ELSE
      SetDetailHeight(l_CurrentRow, l_CurrentRow, 0)
   END IF
END IF

//------------------------------------------------------------------
//  Fill the remaining key and sort columns with key and sort values
//  from the parent row.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_MaxLevels
   l_Key  = "key" + String(l_Idx)
   l_Sort = "sort" + String(l_Idx)
   IF l_Idx < l_NumKeys THEN
      CHOOSE CASE i_DataKeyType[l_Idx]
         CASE "STRING"
            SetItem(l_CurrentRow, l_Key, GetItemString(l_Row, l_Key))
         CASE "NUMBER"
            SetItem(l_CurrentRow, l_Key, GetItemNumber(l_Row, l_Key))
         CASE "DATE"
            SetItem(l_CurrentRow, l_Key, GetItemDate(l_Row, l_Key))
      END CHOOSE
      CHOOSE CASE i_DataSortType[l_Idx]
         CASE "STRING"
            SetItem(l_CurrentRow, l_Sort, GetItemString(l_Row, l_Sort))
         CASE "NUMBER"
            SetItem(l_CurrentRow, l_Sort, GetItemNumber(l_Row, l_Sort))
         CASE "DATE"
            SetItem(l_CurrentRow, l_Sort, GetItemDate(l_Row, l_Sort))
      END CHOOSE
   ELSEIF l_Idx = level THEN
      CHOOSE CASE i_DataKeyType[l_Idx]
         CASE "STRING"
            SetItem(l_CurrentRow, l_Key, key)
         CASE "NUMBER"
            SetItem(l_CurrentRow, l_Key, Long(key))
         CASE "DATE"
            SetItem(l_CurrentRow, l_Key, Date(key))
      END CHOOSE
      CHOOSE CASE i_DataSortType[l_Idx]
         CASE "STRING"
            SetItem(l_CurrentRow, l_Sort, sort)
         CASE "NUMBER"
            SetItem(l_CurrentRow, l_Sort, Long(sort))
         CASE "DATE"
            SetItem(l_CurrentRow, l_Sort, Date(sort))
      END CHOOSE
   ELSEIF l_Idx > level THEN
      CHOOSE CASE i_DataKeyType[l_Idx]
         CASE "STRING"
            SetItem(l_CurrentRow, l_Key, Fill(i_InsertFillString[l_Idx], 120))
         CASE "NUMBER"
            SetItem(l_CurrentRow, l_Key, -1)
         CASE "DATE"
            SetItem(l_CurrentRow, l_Key, Date("19010101"))
      END CHOOSE
      CHOOSE CASE i_DataSortType[l_Idx]
         CASE "STRING"
            SetItem(l_CurrentRow, l_Sort, Fill(i_InsertFillString[l_Idx], 120))
         CASE "NUMBER"
            SetItem(l_CurrentRow, l_Sort, -1)
         CASE "DATE"
            SetItem(l_CurrentRow, l_Sort, Date("19010101"))
      END CHOOSE
   END IF
NEXT

i_RowsInserted = TRUE
i_IgnoreRFC = FALSE

RETURN 0
end function

public function integer fu_hlgetrowlevel (long row);//******************************************************************
//  PO Module     : u_Outliner
//  FUNCTION      : fu_HLGetRowLevel
//  Description   : Returns the level for a given record.
//
//  Parameters    : LONG Row - 
//                     Row number.
//
//  Return Value  : INTEGER - 
//                     Level number.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Level = 0

//-------------------------------------------------------------------
//  Return the level for the given row.
//-------------------------------------------------------------------

IF row > 0 AND row <= RowCount() THEN
   l_Level = GetItemNumber(row, "level")
END IF

RETURN l_Level
end function

public subroutine fu_hlkeydown (unsignedlong controlword);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLKeyDown
//  Description   : Processes the keyboard input for expanding and
//                  collapsing the outliner.  c_AutoKeyDown will
//                  take processing from the keyboard.  Any other
//                  option is used when the function is run from
//                  a menu item.
//
//  Parameters    : ULONG ControlWord - 
//                     Keyboard action to take.
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

STRING  l_Code

//------------------------------------------------------------------
//  Determine what keyboard input to process.
//------------------------------------------------------------------
  
CHOOSE CASE ControlWord
   CASE c_ExpandLevel
      l_Code = "ExpandLevel"
   CASE c_ExpandBranch
      l_Code = "ExpandBranch"
   CASE c_ExpandAll
      l_Code = "ExpandAll"
   CASE c_CollapseBranch
      l_Code = "CollapseBranch"
   CASE c_CollapseAll
      l_Code = "CollapseAll"
   CASE c_AutoKeyDown
      l_Code = ""
END CHOOSE

//------------------------------------------------------------------
//  Expand all branches.
//------------------------------------------------------------------

IF (KeyDown(keyEqual!) AND KeyDown(keyControl!)) OR l_Code = "ExpandAll" THEN
   THIS.fu_HLExpandAll()

//------------------------------------------------------------------
//  Collapse all branches.
//------------------------------------------------------------------

ELSEIF (KeyDown(keyDash!) AND KeyDown(keyControl!)) OR  l_Code = "CollapseAll" THEN
   THIS.fu_HLCollapseAll()

//------------------------------------------------------------------
//  Expand to the next level.
//------------------------------------------------------------------

ELSEIF KeyDown(keyEqual!) OR KeyDown(keyAdd!) OR l_Code = "ExpandLevel" THEN
   IF i_FocusRow <= 0 THEN
      RETURN
   END IF
	
   i_ClickedRow = i_FocusRow
   THIS.fu_HLExpandLevel()

//------------------------------------------------------------------
//  Expand the next branch.
//------------------------------------------------------------------

ELSEIF KeyDown(key8!) OR KeyDown(keyMultiply!) OR l_Code = "ExpandBranch" THEN
   IF i_FocusRow <= 0 THEN
      RETURN
   END IF

   i_ClickedRow = i_FocusRow
   THIS.fu_HLExpandBranch()

//------------------------------------------------------------------
//  Collapse the branch.
//------------------------------------------------------------------

ELSEIF KeyDown(keyDash!) OR KeyDown(keySubtract!) OR l_Code = "CollapseBranch" THEN
   IF i_FocusRow <= 0 THEN
      RETURN
   END IF

   i_ClickedRow = i_FocusRow
   THIS.fu_HLCollapseBranch()
END IF

end subroutine

public subroutine fu_hlsetselectedrow (long row);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLSetSelectedRow
//  Description   : Select a given record in the outliner.
//
//  Parameters    : LONG Row - 
//                     Row number.
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

LONG l_EndRow, l_Row, l_Index, l_Level

//------------------------------------------------------------------
//  Set the row selection attribute for the given row.
//------------------------------------------------------------------

l_EndRow = RowCount()
IF row > 0 AND row <= l_EndRow THEN
   l_Row = Find("selected = 1", 1, l_EndRow)
   IF l_Row = 0 THEN
      i_AnchorRow = row
   ELSE
      IF NOT i_MultiSelect THEN
         SetItem(l_Row, "selected", 0)
      ELSE
         l_Level = GetItemNumber(l_Row, "level")
         IF l_Level <> GetItemNumber(row, "level") THEN
            l_Index = 1
            DO
               l_Index = fu_HLGetSelectedRow(l_Index)
               IF l_Index > 0 THEN
                  SetItem(l_Index, "selected", 0)
                  l_Index = l_Index + 1
                  IF l_Index > l_EndRow THEN
                     l_Index = 0
                  END IF
               END IF
            LOOP UNTIL l_Index = 0
            i_AnchorRow = row
         END IF
      END IF
   END IF
   i_ClickedRow = row
   i_LastSelectedLevel = GetItemNumber(row, "level")
   SetItem(row, "selected", 1)
	
	i_SelectedRow = i_ClickedRow
	i_SelectedLevel = i_LastSelectedLevel
	
   //---------------------------------------------------------------
   //  Call the po_SelectedRow event for the developer.
   //---------------------------------------------------------------
	
	Event po_SelectedRow(i_SelectedRow, i_SelectedLevel, i_MaxLevels)
END IF

end subroutine

public subroutine fu_hlclearselectedrows ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLClearSelectedRows
//  Description   : Clears (unhighlights) the selected records.
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

LONG   l_BeginRow, l_EndRow, l_Row, l_ClearedRows

l_BeginRow = 1
l_EndRow   = RowCount()
l_ClearedRows = 0

//------------------------------------------------------------------
//  Cycle through all the records and find the selected ones.  Set
//  the selected attribute off.
//------------------------------------------------------------------

DO
   l_Row = Find("selected = 1", l_BeginRow, l_EndRow)
   IF l_Row > 0 THEN
      l_ClearedRows = l_ClearedRows + 1
      SetItem(l_Row, "selected", 0)
   END IF
LOOP UNTIL l_Row = 0

end subroutine

public subroutine fu_hldeleterow (long row);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLDeleteRow
//  Description   : Deletes the given record from the outliner.  It
//                  does NOT remove the record from the database.
//
//  Parameters    : LONG Row - 
//                     Row number to be deleted.
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

LONG    l_StartRow, l_EndRow, l_Row, l_Idx
INTEGER l_Level

l_EndRow = RowCount()

IF row > 0 AND row <= l_EndRow THEN
	SetRedraw(FALSE)

   //---------------------------------------------------------------
   //  Get the level of the given row. 
   //---------------------------------------------------------------

   l_Level = GetItemNumber(row, "level")

   //---------------------------------------------------------------
   //  If the level is not the lowest level then discard all rows
   //  in the branch. 
   //---------------------------------------------------------------

   IF l_Level <> i_MaxLevels THEN
      l_Row = Find("level <= " + String(l_Level), &
                   row + 1, l_EndRow)
      
      IF l_Row > 0 THEN
         IF l_Row <> l_EndRow THEN
            l_Row = l_Row - 1
         END IF

         RowsDiscard(row, l_Row, Primary!)
      ELSE
         RowsDiscard(row, l_EndRow, Primary!)
      END IF

   //---------------------------------------------------------------
   //  If the level is the lowest level, discard this row only. 
   //---------------------------------------------------------------

   ELSE
      RowsDiscard(row, row, Primary!)
   END IF      
      
   //---------------------------------------------------------------
   //  Blank out the "showline" column of the next branch up so that
   //  the last in group attribute will be re-calculated for those
   //  rows.
   //---------------------------------------------------------------
	
   l_StartRow = row - 1
	l_EndRow = Find("level <= " + String(l_Level), l_StartRow, 1)
	IF l_EndRow > 0 THEN
		FOR l_Idx = l_StartRow TO l_EndRow STEP -1
			SetItem(l_Idx, "showline", "")
		NEXT

      THIS.fu_HLSetLastInGroup()
	END IF
	
	SetRedraw(TRUE)
END IF

end subroutine

public subroutine fu_hlexpandbranch ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLExpandBranch
//  Description   : Expands all levels below the current level.
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

INTEGER l_CurrentLevel
LONG    l_CurrentRow, l_RowCount, l_EndRow, l_FromRow, l_FindRow

l_RowCount     = RowCount()
l_CurrentRow   = i_ClickedRow
l_CurrentLevel = GetItemNumber(l_CurrentRow, "Level")

//-------------------------------------------------------------------
//  If the current level is the lowest or we are at the last row in
//  the outliner then return. 
//-------------------------------------------------------------------

IF l_CurrentLevel = i_MaxLevels OR &
   (l_CurrentRow = l_RowCount AND i_RetrieveAll) THEN
   SetItem(l_CurrentRow, "expanded", 1) 
   RETURN
END IF

//-------------------------------------------------------------------
//  Expand the branch. 
//-------------------------------------------------------------------

SetRedraw(FALSE)

//-------------------------------------------------------------------
//  Set the current rows expand attributes on. 
//-------------------------------------------------------------------

SetItem(l_CurrentRow, "expanded", 1) 

//-------------------------------------------------------------------
//  Set the expand attributes for the rows in the branch on. 
//-------------------------------------------------------------------

l_EndRow = Find("level <= " + String(l_CurrentLevel), &
                l_CurrentRow + 1, l_RowCount)

IF l_EndRow = 0 THEN
   l_EndRow = l_RowCount
ELSE
	l_EndRow = l_EndRow - 1
END IF
	
IF l_EndRow <> l_CurrentRow THEN
	SetDetailHeight(l_CurrentRow + 1, l_EndRow, i_HeightFactor)

	l_FindRow = l_CurrentRow
	DO
		l_FromRow = l_FindRow + 1
		l_FindRow = Find("expanded = 0", l_FromRow, l_EndRow)
		IF l_FindRow > 0 THEN
			SetItem(l_FindRow, "expanded", 1)
		END IF
	LOOP WHILE l_FindRow > 0 AND l_FindRow < l_EndRow
END IF

//-------------------------------------------------------------------
//  Set the selected row and level and trigger the expand event for
//  the developer. 
//-------------------------------------------------------------------

i_SelectedRow = i_ClickedRow
i_SelectedLevel = l_CurrentLevel
Event po_Expanded(i_SelectedRow, i_SelectedLevel, i_MaxLevels)

SetRedraw(TRUE)

end subroutine

public subroutine fu_hldeleteselectedrows (ref string deletedkeys[]);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLDeleteSelectedRows
//  Description   : Deletes the selected rows from the outliner.  It
//                  does NOT remove the record from the database.
//
//  Parameters    : STRING DeletedKeys[] - 
//                     Returns an array of key values for the
//                     deleted records.
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

LONG   l_BeginRow, l_EndRow, l_Row, l_DeletedRows, l_Level, l_Idx
LONG   l_FromRow, l_ToRow
STRING l_keyColumn

l_BeginRow = 1
l_EndRow   = RowCount()
l_DeletedRows = 0

//-------------------------------------------------------------------
//  Find each of the selected rows, save its key, and discard the
//  row.  Return an array of keys that were deleted so the developer
//  may delete the records from the database.
//-------------------------------------------------------------------

SetReDraw(FALSE)

DO
   l_Row = Find("selected = 1", l_BeginRow, l_EndRow)
   IF l_Row > 0 THEN
      l_Level = GetItemNumber(l_Row, "level")
		l_KeyColumn = "key" + String(l_Level)
      l_DeletedRows = l_DeletedRows + 1
      CHOOSE CASE i_DataKeyType[l_Level]
         CASE "STRING"
            DeletedKeys[l_DeletedRows] = GetItemString(l_Row, l_KeyColumn)
         CASE "NUMBER"
            DeletedKeys[l_DeletedRows] = String(GetItemNumber(l_Row, l_KeyColumn))
         CASE "DATE"
            DeletedKeys[l_DeletedRows] = String(GetItemDate(l_Row, l_KeyColumn), "yyyymmdd")
      END CHOOSE
      RowsDiscard(l_Row, l_Row, Primary!)
		l_FromRow = l_Row - 1
      IF l_Row <> l_EndRow THEN
         l_BeginRow = l_Row
         l_Row = Find("level <= " + String(l_Level), &
                      l_BeginRow, l_EndRow)
      
         IF l_Row > 0 THEN
            IF l_Row <> l_EndRow THEN
               l_Row = l_Row - 1
            END IF

            RowsDiscard(l_BeginRow, l_Row, Primary!)
         ELSE
            RowsDiscard(l_BeginRow, l_EndRow, Primary!)
            l_Row = 0
         END IF
      ELSE
         l_Row = 0
      END IF
		IF l_FromRow > 0 THEN
			
         //---------------------------------------------------------
         //  Blank out the "showline" column of the next branch up
         //  so that the last in group attribute will be 
         //  re-calculated for those rows.
         //---------------------------------------------------------
	
	      l_ToRow = Find("level <= " + String(l_Level), l_FromRow, 1)
	      IF l_ToRow > 0 THEN
		      FOR l_Idx = l_FromRow TO l_ToRow STEP -1
			      SetItem(l_Idx, "showline", "")
		      NEXT

            THIS.fu_HLSetLastInGroup()
	      END IF
		END IF
   END IF
LOOP UNTIL l_Row = 0

//-------------------------------------------------------------------
//  Re-calculate the last in group attribute the rows affected.
//-------------------------------------------------------------------

THIS.fu_HLSetLastInGroup()

SetReDraw(TRUE)

end subroutine

public subroutine fu_hlinsertsort ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLInsertSort
//  Description   : Sorts the records after a block of records
//                  have been inserted manually.
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

LONG l_RowCount

l_RowCount = RowCount()

IF i_RetrieveDefined OR l_RowCount = 0 THEN
   RETURN
END IF

i_IgnoreRFC = TRUE

//------------------------------------------------------------------
//  If a block of rows have been inserted manually into the 
//  outliner, re-sort the data and re-calculate the last in group
//  attribute.
//------------------------------------------------------------------

IF i_RowsInserted THEN
   Sort()
	
	DO WHILE Find("showline = ''", 1, l_Rowcount) > 0
      THIS.fu_HLSetLastInGroup()
	LOOP

   IF i_SelectedRow > 0 AND i_SelectedRow <= l_RowCount THEN
      ScrollToRow(i_SelectedRow)
   ELSE
      ScrollToRow(1)
   END IF
   i_RowsInserted = FALSE
END IF

i_IgnoreRFC = FALSE

end subroutine

public function integer fu_hlgetrowkey (long row, ref string key[]);//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLGetRowKey
//  Description   : Returns the key values for all levels upto and
//                  including the current level for a given record.
//
//  Parameters    : LONG   Row - 
//                     Row number.
//                  STRING Key[] - 
//                     Key values for levels from one
//                     to the current level.
//
//  Return Value  : INTEGER - 
//                     Number of values in the Key[] array.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Level, l_Idx, l_NumKeys
STRING  l_Column

//-------------------------------------------------------------------
//  Get the keys for each level above the current row's level.  
//  Return them in a string array since each level may have keys of
//  different data types.
//-------------------------------------------------------------------

l_NumKeys = 0
IF row > 0 AND row <= RowCount() THEN
   l_Level = GetItemNumber(row, "level")
   FOR l_Idx = 1 TO l_Level
      l_NumKeys = l_NumKeys + 1
      l_Column = "key" + String(l_Idx)
      CHOOSE CASE i_DataKeyType[l_Idx]
         CASE "STRING"
            Key[l_Idx] = GetItemString(row, l_Column)
         CASE "NUMBER"
            Key[l_Idx] = String(GetItemNumber(row, l_Column))
         CASE "DATE"
            Key[l_Idx] = String(GetItemDate(row, l_Column), "yyyymmdd")
      END CHOOSE
   NEXT
END IF

RETURN l_NumKeys
end function

public subroutine fu_hldragbegin (dragobject object_name, string key[], string description[], string sort[], string bmp_open[], string bmp_close[]);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLDragBegin
//  Description   : Begins the drag process from an object outside
//                  the outliner and assumes the rows will be
//                  dropped on the bottom level.
//
//  Parameters    : DRAGOBJECT Object_Name - 
//                     Name of the object the drag process begins
//                     from.
//                  STRING     Key[] - 
//                     Array of key values.
//                  STRING     Description[] - 
//                     Array of descriptions.
//                  STRING     Sort[] - 
//                     Array of descriptions used for sorting.
//                  STRING     BMP_Open[] - 
//                     Array of bitmap files for displaying when
//                     the record is expanded.
//                  STRING     BMP_Close[] - 
//                     Array of bitmap files for displaying when
//                     the record is collapsed.
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

//------------------------------------------------------------------
//  Call the full function passing the bottom level.
//------------------------------------------------------------------

fu_HLDragBegin(Object_Name, i_MaxLevels, Key[], Description[], &
               Sort[], BMP_Open[], BMP_Close[])

end subroutine

public function long fu_hldragend (ref string key[], ref string description[], unsignedlong visualword);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLDragEnd
//  Description   : Ends the drag process from the outliner.
//
//  Parameters    : STRING Key[] - 
//                     Array of key values.
//                  STRING Description[] - 
//                     Array of descriptions.
//                  STRING VisualWord - 
//                     Visual options for the control of the
//                     drag and drop process.
//
//  Return Value  : LONG -
//                     Number of selected records from the outliner.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG    l_NumSelected
INTEGER l_Level

//------------------------------------------------------------------
//  Call the full function passing the bottom level.
//------------------------------------------------------------------

l_NumSelected = fu_HLDragEnd(l_Level, Key[], Description[], &
                             VisualWord)

RETURN l_NumSelected
end function

public subroutine fu_hlsetupdatedrow (long row);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLSetUpdatedRow
//  Description   : Set the update flag for a given record in the 
//                  outliner.
//
//  Parameters    : LONG Row - 
//                     Row number.
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

LONG l_EndRow

//------------------------------------------------------------------
//  Set the row update attribute for the given row.
//------------------------------------------------------------------

l_EndRow = RowCount()
IF row > 0 AND row <= l_EndRow THEN
   SetItem(row, "updated", 1)
END IF

end subroutine

public function long fu_hlgetupdatedrow (long index);//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLGetUpdatedRow
//  Description   : Returns the row number of the next updatable 
//                  record.  The return value may be used to 
//                  initiate the search for the next updatable 
//                  record.
//
//  Parameters    : LONG Index - 
//                     Row number after which to begin the search.
//
//  Return Value  : LONG - 
//                     Row number of the updatable record.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG   l_EndRow

//-------------------------------------------------------------------
//  Return the next updatable row after the given index row.
//-------------------------------------------------------------------

l_EndRow = RowCount()

RETURN Find("updated = 1", index, l_EndRow)

end function

public subroutine fu_hlclearupdatedrows ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLClearUpdatedRows
//  Description   : Clears the update flag from the updatable 
//                  records.
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

LONG   l_BeginRow, l_EndRow, l_Row, l_ClearedRows

l_BeginRow = 1
l_EndRow   = RowCount()
l_ClearedRows = 0

//------------------------------------------------------------------
//  Cycle through all the records and find the updatable ones.  Set
//  the update attribute off.
//------------------------------------------------------------------

DO
   l_Row = Find("updated = 1", l_BeginRow, l_EndRow)
   IF l_Row > 0 THEN
      l_ClearedRows = l_ClearedRows + 1
      SetItem(l_Row, "updated", 0)
   END IF
LOOP UNTIL l_Row = 0


end subroutine

public function integer fu_hlcreate (transaction trans_object, integer maxlevels);//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLCreate
//  Description   : Creates the outliner object.
//
//  Parameters    : TRANSACTION Trans_Object - 
//                     Name of the transaction object used for
//                     retrieving each level of data.  Must be given
//                     even if data is manually inserted.
//                  INTEGER     MaxLevels - 
//                     Maximum number of levels the outliner
//                     will have.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = create failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_ShowBoxes, l_ShowPlus, l_DWSyntax, l_LineSyntax, l_BoxAttr
STRING l_PlusAttr, l_LineAttr, l_LineMask, l_BoxSyntax, l_Return
STRING l_ShowOpenBMP, l_ShowCloseBMP, l_BMPSyntax, l_DescSyntax
STRING l_LineColor, l_Level, l_DescColor
STRING l_WidthfactorStr1, l_WidthFactorStr2, l_Type, l_Color
STRING l_RectSyntax, l_DescHighColor, l_WidthDesc, l_WidthRect
STRING l_RowFocusIndicatorColor, l_ComputeSyntax, l_ColumnSyntax
INTEGER l_Idx, l_RowCount
INTEGER l_Error, l_BoxSize, l_BoxMidSize, l_StartWidth
INTEGER l_PlusSize, l_PlusMidSize, l_PixelWidth

//------------------------------------------------------------------
//  Set the maximum levels and the transaction object.
//------------------------------------------------------------------

i_MaxLevels = MaxLevels
i_Transaction = Trans_Object

//------------------------------------------------------------------
//  Build the syntax to hide or show boxes on the outliner.
//------------------------------------------------------------------

IF i_ShowBoxes THEN
   l_ShowBoxes = ' visible="1~t if(level = 1, 0, 1)" ' 
   IF i_RetainOnCollapse THEN
      l_ShowPlus  = ' visible="1~t if(level = 1, 0, if(level [0] < level [1] and expanded = 0, 1, 0))" '
   ELSE
      l_ShowPlus  = ' visible="0" '
   END IF 
ELSE
   l_ShowBoxes = ' visible="0" '
   l_ShowPlus  = ' visible="0" '
END IF

//------------------------------------------------------------------
//  Build the syntax to hide or show lines on the outliner.
//------------------------------------------------------------------

IF i_ShowLines THEN
   l_LineColor = i_LineColor
ELSE
   l_LineColor = i_HLColor
   l_ShowBoxes = ' visible="0" '
   l_ShowPlus  = ' visible="0" '
END IF

//------------------------------------------------------------------
//  Build the syntax to hide or show bitmaps on the outliner.
//------------------------------------------------------------------

IF i_ShowBMP THEN
   l_ShowOpenBMP  = ' visible="0~tif(expanded = 1, 1, 0)" '
	l_ShowCloseBMP = ' visible="1~tif(expanded = 0, 1, 0)" '
ELSE
   l_ShowOpenBMP  = ' visible="0" '
	l_ShowCloseBMP = ' visible="0" '
END IF

//------------------------------------------------------------------
//  Build the DataWindow syntax.
//------------------------------------------------------------------

l_DWSyntax = i_DWSyntax + &
             'color=' + i_HLColor + ') ' + &
             'header(height=0) summary(height=0) ' + &
             'footer(height=0) ' + &
             'detail(height=0 color="' + i_HLColor + '") '

//------------------------------------------------------------------
//  Build the sort column syntax.
//------------------------------------------------------------------

FOR l_Idx = 1 to i_MaxLevels 
   CHOOSE CASE i_DataSortType[l_Idx]
      CASE "STRING"
         l_Type = 'char(120) '
      CASE "NUMBER"
         l_Type = 'number '
      CASE "DATE"
         l_Type = 'date '
   END CHOOSE
	l_ColumnSyntax = l_ColumnSyntax + &
	                 'column=(type=' + l_Type + &
                    'name=sort' + String(l_Idx) + &
 	                 ' dbname="' + i_DataSort[l_Idx] + '") '   
NEXT


//------------------------------------------------------------------
//  Build the key column syntax.
//------------------------------------------------------------------

FOR l_Idx = 1 to i_MaxLevels 
   CHOOSE CASE i_DataKeyType[l_Idx]
      CASE "STRING"
         l_Type = 'char(120) '
      CASE "NUMBER"
         l_Type = 'number '
      CASE "DATE"
         l_Type = 'date '
   END CHOOSE
   l_ColumnSyntax = l_ColumnSyntax + &
	                 'column=(type=' + l_Type + &
                    'name=key' + String(l_Idx) + &
 	                ' dbname="' + i_DataKey[l_Idx] + '") '   
NEXT

//------------------------------------------------------------------
//  Create the outliner.
//------------------------------------------------------------------

l_Error = Create(l_DWSyntax + i_TableSyntax + &
                 l_ColumnSyntax + ")")

IF l_Error = 1 THEN

   //---------------------------------------------------------------
   //  Retrieve the data.
   //---------------------------------------------------------------

   IF NOT i_InsertDefined THEN
      i_IgnoreRFC = TRUE
      l_Error = THIS.fu_HLRetrieve(0)
      IF l_Error = -1 THEN
         RETURN -1
      END IF
  
      //------------------------------------------------------------
      //  Calculate the last in group rows.
      //------------------------------------------------------------

      THIS.fu_HLSetLastInGroup()
   END IF

   //---------------------------------------------------------------
   //  Build the syntax for the connecting lines at each level.  The
   //  syntax for level 1 is slightly different that all other
   //  levels.
   //---------------------------------------------------------------

   l_StartWidth = i_HLIndent + Round(i_BMPWidth / 2, 0)
   l_LineSyntax = 'create line(band=detail ' + &
				      'pen.style="0" pen.width="1" ' + &
				      'background.mode="1" ' + &
				      'name=line1top '+ &
				      'visible="1~tif(Integer(Left(showline, 1)) = 1, 1, 0)" ' + &
                  'pen.color="' + l_LineColor + '" ' + &
                  'x1="' + String(l_StartWidth) + '" y1="-1" ' + &
                  'x2="' + String(l_StartWidth) + '" y2="' + &
                  String(i_HeightMidFactor) + '") '

   l_LineSyntax = l_LineSyntax + 'create line(band=detail ' + &
				      'pen.style="0" pen.width="1" ' + &
				      'background.mode="1" ' + & 
				      'name=line1bottom ' + &
				      'visible="0~tif(Integer(Left(showline, 1)) = 1, ' + &
                  'if(unused = -1, 0, 1), 0)" ' + &
                  'pen.color="' + l_LineColor + '" x1="' + &
                  String(l_StartWidth) + '" y1="' + &
                  String(i_HeightMidFactor) + '~tif(level = 1 ' + &
                  'and level [0] < level [1] and expanded = 1, ' + &
                  String(i_HeightFactor) + ', ' + &
                  String(i_HeightMidFactor) + ') " x2="' + &
		            String(l_StartWidth) + '" y2="' + &
		            String(i_HeightFactor) + '") '

   IF i_MaxLevels > 1 THEN
      FOR l_Idx = 2 TO i_MaxLevels - 1 
         l_Level = String(l_Idx)
         l_LineSyntax = l_LineSyntax + 'create line(band=detail ' + &
	                     'pen.style="0" pen.width="1" ' + &
	                     'background.mode="1" ' + &
	                     'name=line' + l_Level + 'top ' + &
	                     'visible="1~tif(Integer(Mid(showline, ' + l_Level + ', 1)) = 1, 1, 0)" ' + &
								'pen.color="' + l_LineColor + '" ' + &
                        'x1="' + String((l_Idx - 1) * i_WidthFactor + l_StartWidth) + '" y1="-1" ' + &
                        'x2="' + String((l_Idx - 1) * i_WidthFactor + l_StartWidth) + '" y2="' + &
                        String(i_HeightMidFactor) + '") '

	      l_LineSyntax = l_LineSyntax + 'create line(band=detail ' + &
	                     'pen.style="0" pen.width="1" ' + &
	                     'background.mode="1" ' + &
	                     'name=line' + l_Level + 'bottom ' + &
	                     'visible="0~tif(Integer(Mid(showline, ' + l_Level + ', 1)) = 1, ' + &
                        'if(Mid(showline [0], ' + l_Level + ', 1) > ' + &
                        'Mid(showline [1], ' + l_Level + ', 1), 0, if(unused = -1, 0, 1)), 0)" ' + &
                        'pen.color="' + l_LineColor + '" x1="' + &
                        String((l_Idx - 1) * i_WidthFactor + l_StartWidth) + '" y1="' + &
                        String(i_HeightMidFactor) + '~tif(level = 1 ' + &
                        'and level [0] < level [1] and expanded = 1, ' + &
                        String(i_HeightFactor) + ', ' + &
                        String(i_HeightMidFactor) + ') " x2="' + &
		                  String((l_Idx - 1) * i_WidthFactor + l_StartWidth) + '" y2="' + &
		                  String(i_HeightFactor) + '") '
      NEXT
   END IF

   //---------------------------------------------------------------
   //  Build the syntax for the boxes.
   //---------------------------------------------------------------

   l_BoxSize = Min(i_BMPWidth, i_BMPHeight) / 2
   l_BoxMidSize = Round(l_BoxSize / 2, 0)
   l_PlusSize = Round(l_BoxSize * .75, 0)
   l_PlusMidSize = Round(l_PlusSize / 2, 0)

   l_WidthFactorStr1 = String(i_HLIndent) + '~t((((level - 1) * ' + String(i_WidthFactor) + ') + ' + String(l_StartWidth) + ') '
   l_WidthFactorStr2 = String(i_HLIndent) + '~t((((level - 2) * ' + String(i_WidthFactor) + ') + ' + String(l_StartWidth) + ') '
   l_BoxAttr  = 'pen.color="' + l_LineColor + '" ' + l_ShowBoxes
   l_PlusAttr = 'pen.color="' + l_LineColor + '" ' + l_ShowPlus
   l_LineAttr = 'pen.color="' + l_LineColor + '" '
   l_LineMask = 'pen.color="' + i_HLColor   + '" ' + l_ShowBoxes

   l_BoxSyntax = i_BoxSyntax + 'name=bmpline ' + l_LineAttr + &
                 'visible="1~t if(level <> 1, 1, 0)" ' + &
                 'x1="' + l_WidthFactorStr2 + ')" ' + &
	              'y1="' + String(i_HeightMidFactor) + '" ' + &
                 'x2="' + l_WidthFactorStr1 + ' - ' + String(i_WidthMidFactor + 1) + ')" ' + &
                 'y2="' + String(i_HeightMidFactor) + '") '

   l_BoxSyntax = l_BoxSyntax + i_BoxSyntax + l_BoxAttr + &
                 'x1="' + l_WidthFactorStr2 + ' - ' + String(l_BoxMidSize) + ')" ' + &
                 'y1="' + String(i_HeightMidFactor + l_BoxMidSize) + '" ' + &
	              'x2="' + l_WidthFactorStr2 + ' + ' + String(l_BoxMidSize) + ')" ' + &
                 'y2="' + String(i_HeightMidFactor + l_BoxMidSize) + '" ) '

   l_BoxSyntax = l_BoxSyntax + i_BoxSyntax + l_BoxAttr + &
                 'x1="' + l_WidthFactorStr2 + ' - ' + String(l_BoxMidSize) + ')" ' + &
                 'y1="' + String(i_HeightMidFactor - l_BoxMidSize) + '" ' + &
                 'x2="' + l_WidthFactorStr2 + ' + ' + String(l_BoxMidSize + 1) + ')" ' + &
                 'y2="' + String(i_HeightMidFactor - l_BoxMidSize) + '" ) '

   l_BoxSyntax = l_BoxSyntax + i_BoxSyntax + l_BoxAttr + &
                 'x1="' + l_WidthFactorStr2 + ' - ' + String(l_BoxMidSize) + ')" ' + &
                 'y1="' + String(i_HeightMidFactor + l_BoxMidSize) + '" ' + &
                 'x2="' + l_WidthFactorStr2 + ' - ' + String(l_BoxMidSize) + ')" ' + &
                 'y2="' + String(i_HeightMidFactor - l_BoxMidSize) + '") '

   l_BoxSyntax = l_BoxSyntax + i_BoxSyntax + l_BoxAttr + &
                 'x1="' + l_WidthFactorStr2 + ' + ' + String(l_BoxMidSize) + ')" ' + &
                 'y1="' + String(i_HeightMidFactor + l_BoxMidSize) + '" ' + &
                 'x2="' + l_WidthFactorStr2 + ' + ' + String(l_BoxMidSize) + ')" ' + &
                 'y2="' + String(i_HeightMidFactor - l_BoxMidSize) + '") '

   l_BoxSyntax = l_BoxSyntax + i_BoxSyntax + l_LineMask + &
                 'x1="' + l_WidthFactorStr2 + ' - ' + String(l_BoxMidSize - 1) + ')" ' + &
                 'y1="' + String(i_HeightMidFactor) + '" ' + &
                 'x2="' + l_WidthFactorStr2 + ' + ' + String(l_BoxMidSize) + ')" ' + &
                 'y2="' + String(i_HeightMidFactor) + '") ' 

   l_BoxSyntax = l_BoxSyntax + i_BoxSyntax + l_LineMask + &
                 'x1="' + l_WidthFactorStr2 + ')" ' + &
                 'y1="' + String(i_HeightMidFactor - l_BoxMidSize + 1) + '" ' + &
                 'x2="' + l_WidthFactorStr2 + ')" ' + &
                 'y2="' + String(i_HeightMidFactor + l_BoxMidSize) + '" ) ' 

   l_BoxSyntax = l_BoxSyntax + i_BoxSyntax + l_BoxAttr + &
                 'x1="' + l_WidthFactorStr2 + ' - ' + String(l_PlusMidSize - 1) + ')" ' + &
                 'y1="' + String(i_HeightMidFactor) + '" ' + &
                 'x2="' + l_WidthFactorStr2 + ' + ' + String(l_PlusMidSize) + ')" ' + &
                 'y2="' + String(i_HeightMidFactor) + '") ' 

   l_BoxSyntax = l_BoxSyntax + i_BoxSyntax + l_PlusAttr + &
                 'x1="' + l_WidthFactorStr2 + ')" ' + &
                 'y1="' + String(i_HeightMidFactor - l_PlusMidSize + 1) + '" ' + &
                 'x2="' + l_WidthFactorStr2 + ')" ' + &
                 'y2="' + String(i_HeightMidFactor + l_PlusMidSize) + '" ) ' 

   //---------------------------------------------------------------
   //  Build the syntax for displaying the bitmaps.
   //---------------------------------------------------------------

   l_BMPSyntax = i_BMPOpenSyntax + 'background.color="' + &
                 i_HLColor + '" ' + l_ShowOpenBMP + &
                 'height="' + String(i_BmpHeight) + '" ' + &
                 'width="' + String(i_BmpWidth) + '" ' + &
                 'x="' + l_WidthFactorStr1 + ' - ' + String (i_WidthMidFactor) + &
					  ')" ' + 'y="' + String((i_HeightFactor - i_BMPHeight) / 2) + '") '
					  
   l_BMPSyntax = l_BMPSyntax + i_BMPCloseSyntax + 'background.color="' + &
                 i_HLColor + '" ' + l_ShowCloseBMP + &
                 'height="' + String(i_BmpHeight) + '" ' + &
                 'width="' + String(i_BmpWidth) + '" ' + &
                 'x="' + l_WidthFactorStr1 + ' - ' + String (i_WidthMidFactor) + &
					  ')" ' + 'y="' + String((i_HeightFactor - i_BMPHeight) / 2) + '") '

   //---------------------------------------------------------------
   //  Build the syntax for displaying the text.
   //---------------------------------------------------------------

   l_DescHighColor = '0~tif(selected = 1, ' + i_HLHighColor + &
                     ', ' + i_HLColor + ')'

   l_DescColor = i_TextColor + '~tif(selected = 1, ' + i_TextHighColor + ', '
   FOR l_Idx = 1 TO i_MaxLevels
      IF i_DataColor[l_Idx] = "-1" THEN
         l_Color = i_TextColor
      ELSE
         l_Color = i_DataColor[l_Idx]
      END IF
      l_DescColor = l_DescColor + 'if(level = ' + String(l_Idx) + &
                    ', ' + l_Color + ', '
   NEXT
   l_DescColor = l_DescColor + i_TextColor + Fill(')', i_MaxLevels + 1)

   l_DescSyntax = i_DescSyntax + &
                  'font.face="' + i_TextFont + '" ' + &
                  'font.family="' + i_TextFamily + '" ' + &
                  'font.pitch="' + i_TextPitch + '" ' + &
                  'font.charset="' + i_TextCharSet + '" ' + &
                  'font.height="' + i_TextSize + '" ' + &
                  i_TextStyle + '="' + i_TextStyleValue + '" ' + &
                  'color="' + l_DescColor + '" ' + &
                  'background.color="' + l_DescHighColor + '" '

   //---------------------------------------------------------------
   //  Build the syntax for the row focus indicator rectangle.
   //---------------------------------------------------------------

   IF i_ShowRowFocusIndicator THEN
      l_RowFocusIndicatorColor = '0~tif(current = 1, ' + &
                                 i_RowFocusIndicatorColor + &
                                 ', ' + i_HLHighColor + ')'
   ELSE
      l_RowFocusIndicatorColor = '0~tif(selected = 0, ' + &
                                 i_RowFocusIndicatorColor + &
                                 ', ' + i_HLHighColor + ')'
   END IF

   l_RectSyntax = i_RectSyntax + &
                  'name=highlight ' + &
                  'pen.width="1" ' + &
                  'pen.color="' + l_RowFocusIndicatorColor + '" ' + &
                  'brush.color="' + i_HLHighColor + &
                  '~tif(selected = 1, ' + i_HLHighColor + ', ' + &
                  i_HLColor + ')" ' + &
                  'background.color="' + i_HLColor + '" ' + &
				      'pen.style="0" ' + &
                  'visible="0~tif(selected = 1 or current = 1, 1, 0)" '

   //---------------------------------------------------------------
   //  Determine the placement of the text and row focus indicator
   //  rectangle.
   //---------------------------------------------------------------

   l_PixelWidth = UnitsToPixels(Width, XUnitsToPixels!)
   IF i_ShowBMP THEN
      l_WidthDesc = String(i_HLIndent) + '~t((' + String(l_PixelWidth) + ' - 20) - ((((level - 1) * ' + String(i_WidthFactor) + ') + ' + String(l_StartWidth) + ') + ' + String(i_WidthMidFactor - (Integer(i_TextSize) / 2) + 2) + ') '
      l_WidthRect = String(i_HLIndent) + '~t((' + String(l_PixelWidth) + ' - 20) - ((((level - 1) * ' + String(i_WidthFactor) + ') + ' + String(l_StartWidth) + ') + ' + String(i_WidthMidFactor - (Integer(i_TextSize) / 2) - 2) + ') '
      l_DescSyntax = l_DescSyntax + &
                     'height="' + String((i_HeightFactor - 2) - ((i_HeightMidFactor - 1) + ((Integer(i_TextSize) - 2) / 2))) + '" ' + &
                     'width="' + String(l_WidthDesc) + ')" ' + &
                     'x="' + l_WidthFactorStr1 + ' + ' + String(i_WidthMidFactor - (Integer(i_TextSize) / 2)) + ')" ' + &
                     'y="' + String((i_HeightMidFactor - 1) + ((Integer(i_TextSize) - 2) / 2)) + '") '

      l_RectSyntax = l_RectSyntax + &
                     'height="' + String(i_HeightFactor) + '" ' + &
                     'width="' + String(l_WidthRect) + ')" ' + &
                     'x="' + l_WidthFactorStr1 + ' + ' + String(i_WidthMidFactor - (Integer(i_TextSize) / 2) - 2) + ')" ' + &
                     'y="-1") '

   ELSE
      l_WidthFactorStr1 = String(i_HLIndent) + '~t((((level - 1) * ' + String(i_WidthFactor) + ') + ' + String(i_HLIndent) + ') '
      l_WidthDesc = String(i_HLIndent) + '~t((' + String(l_PixelWidth) + ' - 20) - (((level - 1) * ' + String(i_WidthFactor) + ') + ' + String(i_HLIndent + 2) + ') '
      l_WidthRect = String(i_HLIndent) + '~t((' + String(l_PixelWidth) + ' - 20) - (((level - 1) * ' + String(i_WidthFactor) + ') + ' + String(i_HLIndent - 2) + ') '
      l_DescSyntax = l_DescSyntax + &
                     'height="' + String((i_HeightFactor - 2) - ((i_HeightMidFactor - 1) + ((Integer(i_TextSize) - 2) / 2))) + '" ' + &
                     'width="' + String(l_WidthDesc) + ')" ' + &
                     'x="' + l_WidthFactorStr1 + ')" ' + &
                     'y="' + String((i_HeightMidFactor - 1) + ((Integer(i_TextSize) - 2) / 2)) + '") '
      l_RectSyntax = l_RectSyntax + &
                     'height="' + String(i_HeightFactor) + '" ' + &
                     'width="' + String(l_WidthRect) + ')" ' + &
                     'x="' + l_WidthFactorStr1 + ' - 2)" ' + &
                     'y="-1") '
   END IF

   //---------------------------------------------------------------
   //  Build the syntax for a computed column that contains the
   //  row height.
   //---------------------------------------------------------------

   l_ComputeSyntax = 'create compute(band=detail alignment="0" ' + &
                     'expression="rowheight()" border="0" ' + &
                     'color="0" x="0" y="0" height="0" width="0" ' + &
                     'format="[GENERAL]" name=heightline font.face="Arial" ' + &
                     'font.height="-8" font.weight="400" ' + &
                     'font.family="2" font.pitch="2" ' + &
                     'font.charset="0" background.mode="2" ' + &
                     'background.color="0" ) '
 
   //---------------------------------------------------------------
   //  Modify the DataWindow syntax.
   //---------------------------------------------------------------

   l_Return = Modify(l_LineSyntax + l_BoxSyntax + l_BMPSyntax + &
                     l_RectSyntax + l_DescSyntax + l_ComputeSyntax)

   SetReDraw(FALSE)

   //---------------------------------------------------------------
   //  Determine if the rows are to be expanded or collapsed on
   //  creation.
   //---------------------------------------------------------------

   l_RowCount = RowCount()
   IF l_RowCount > 0 THEN
      IF i_CollapseOnOpen THEN
         FOR l_Idx = 1 to l_RowCount
	         IF GetItemNumber(l_Idx, "level") = 1 THEN
		         SetItem(l_Idx, "expanded", 0)
		         SetDetailHeight(l_Idx, l_Idx, i_HeightFactor)
            END IF
         NEXT
		ELSE
			fu_HLExpandAll()
      END IF
      i_IgnoreRFC = FALSE

      //------------------------------------------------------------
      //  Set the current row to be 1.
      //------------------------------------------------------------

      i_FocusRow  = 1
      SetItem(i_FocusRow, "current", 1)
      SetRow(1)
      SetFocus()
   END IF

   SetReDraw(TRUE)

END IF

RETURN 0


end function

public function string fu_hlgetrowdesc (long row);//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLGetRowDesc
//  Description   : Returns the description that is displayed for
//                  the given row.
//
//  Parameters    : LONG   Row - 
//                     Row number.
//
//  Return Value  : STRING - 
//                     Description.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Desc

IF Row > RowCount() OR Row <= 0 THEN
	RETURN ""
END IF

l_Desc = GetItemString(Row, "stringdesc")

RETURN l_Desc
end function

public function long fu_hlfindrow (string key_value, integer level);//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLFindRow
//  Description   : Returns the row number that corresponds to the 
//                  key value and level number.
//
//  Parameters    : STRING  Key_Value - 
//                     The key value of the row to find.
//                  INTEGER Level - 
//                     The level of the row to find.
//
//  Return Value  : LONG - 
//                     Row number.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_FindKey
LONG   l_FindRow

//------------------------------------------------------------------
//  Make sure the level is valid.
//------------------------------------------------------------------

IF Level > i_MaxLevels OR Level <= 0 THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  Format the key value based on the data type.
//------------------------------------------------------------------

CHOOSE CASE i_DataKeyType[Level]
	CASE "STRING"
		l_FindKey = "'" + Key_Value + "'"
	CASE "NUMBER"
		l_FindKey = Key_Value
	CASE "DATE"
		l_FindKey = "Date(~"" + Key_Value + "~")"
END CHOOSE

//------------------------------------------------------------------
//  Find the row.
//------------------------------------------------------------------

l_FindRow = Find("key" + String(Level) + " = " + l_FindKey, 1, &
                 RowCount())
					  
RETURN l_FindRow


end function

public subroutine fu_hlselectall (integer level);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLSelectAll
//  Description   : Selects all records at the lowest level in the
//                  outliner.
//
//  Parameters    : INTEGER Level -
//                     The level for which to select all rows.
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

LONG l_EndRow, l_Idx

//------------------------------------------------------------------
//  If the outliner doesn't allow multi-select, do nothing.
//------------------------------------------------------------------

IF NOT i_MultiSelect THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Make sure that no rows on other levels are selected.
//------------------------------------------------------------------

fu_HLClearSelectedRows()

//------------------------------------------------------------------
//  Cycle through all the rows at the specified level and set the
//  row selection attribute on.
//------------------------------------------------------------------

l_EndRow = RowCount()
FOR l_Idx = 1 TO l_EndRow
   IF GetItemNumber(l_Idx, "level") = Level THEN
      SetItem(l_Idx, "selected", 1)
   END IF
NEXT
end subroutine

public function integer fu_hlsetrowdesc (long row, string row_desc);//******************************************************************
//  PO Module     : u_Outliner
//  Function      : fu_HLSetRowDesc
//  Description   : Sets the description that is displayed for the
//                  given row.
//
//  Parameters    : LONG   Row - 
//                     Row number.
//                  STRING Row_Desc -
//                     Row description.
//
//  Return Value  : INTEGER - 
//                     0, O.K.
//                    -1, error
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return

IF Row > RowCount() OR Row <= 0 THEN
	RETURN -1
END IF

l_Return = SetItem(Row, "stringdesc", Row_Desc)
IF l_Return = 1 THEN
	l_Return = 0
END IF

RETURN l_Return
end function

public subroutine fu_hldragbegin (dragobject object_name, integer level, string key[], string description[], string sort[], string bmp_open[], string bmp_close[]);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLDragBegin
//  Description   : Begins the drag process from an object outside
//                  the outliner.
//
//  Parameters    : DRAGOBJECT Object_Name - 
//                     Name of the object the drag process begins
//                     from.
//                  INTEGER    Level -
//                     Level to add the rows to.
//                  STRING     Key[] - 
//                     Array of key values.
//                  STRING     Description[] - 
//                     Array of descriptions.
//                  STRING     Sort[] - 
//                     Array of descriptions used for sorting.
//                  STRING     BMP_Open[] - 
//                     Array of bitmap files for displaying when
//                     the record is expanded.
//                  STRING     BMP_Close[] - 
//                     Array of bitmap files for displaying when
//                     the record is collapsed.
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

LONG l_Rows

//------------------------------------------------------------------
//  Check to see if the outliner allows drag and drop.
//------------------------------------------------------------------

IF NOT i_AllowDragDrop THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Don't allow a drag to an invalid level.
//------------------------------------------------------------------

IF Level < 1 OR Level > i_MaxLevels THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Depending on the number of rows, set the drag icon for the
//  object.
//------------------------------------------------------------------

l_Rows = UpperBound(key[])
IF l_Rows = 0 THEN
   RETURN
ELSEIF l_Rows = 1 THEN
   object_name.DragIcon = "dragrow.ico"
ELSE
   object_name.DragIcon = "dragrows.ico"
END IF

//------------------------------------------------------------------
//  Store the values needed by the outliner for when the drag
//  process is dropped on the outliner.
//------------------------------------------------------------------

i_DragFromOutside = TRUE
i_DragLevel = Level
i_DragKey[] = key[]
i_DragDescription = description[]
i_DragSort[] = sort[]
i_DragBMPOpen[] = bmp_open[]
i_DragBMPClose[] = bmp_close[]

//------------------------------------------------------------------
//  Start the drag process.
//------------------------------------------------------------------

object_name.Drag(Begin!)

end subroutine

public function long fu_hldragend (ref integer level, ref string key[], ref string description[], unsignedlong visualword);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLDragEnd
//  Description   : Ends the drag process from the outliner.
//
//  Parameters    : INTEGER Level -
//                     Level being dragged from.
//                  STRING  Key[] - 
//                     Array of key values.
//                  STRING  Description[] - 
//                     Array of descriptions.
//                  STRING  VisualWord - 
//                     Visual options for the control of the
//                     drag and drop process.
//
//  Return Value  : LONG -
//                     Number of selected records from the outliner.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG   l_Index, l_LastRow, l_NumSelected
STRING l_TmpKeys[], l_KeyColumn

//------------------------------------------------------------------
//  If the outliner doesn't allow drag mode, do nothing.
//------------------------------------------------------------------

IF NOT i_AllowDragDrop THEN
	RETURN 0
END IF

//------------------------------------------------------------------
//  Return the level being dragged from.
//------------------------------------------------------------------

Level = i_DragLevel

//------------------------------------------------------------------
//  Cycle through the outliner looking for selected records.
//------------------------------------------------------------------

l_NumSelected = 0
l_LastRow     = RowCount()
l_KeyColumn   = "key" + String(i_DragLevel)
DO
   l_Index = THIS.fu_HLGetSelectedRow(l_Index)
   IF l_Index > 0 THEN

      //------------------------------------------------------------
      //  Store the key value and description.
      //------------------------------------------------------------

      l_NumSelected = l_NumSelected + 1
      CHOOSE CASE i_DataKeyType[i_DragLevel]
         CASE "STRING"
            key[l_NumSelected] = GetItemString(l_Index, l_KeyColumn)
         CASE "NUMBER"
            key[l_NumSelected] = STRING(GetItemNumber(l_Index, l_KeyColumn))
         CASE "DATE"
            key[l_NumSelected] = STRING(GetItemDate(l_Index, l_KeyColumn), "yyyymmdd")
      END CHOOSE     
      description[l_NumSelected] = GetItemString(l_Index, "stringdesc")

      l_Index = l_Index + 1
      IF l_Index > l_LastRow THEN
         l_Index = 0
      END IF
   END IF
LOOP UNTIL l_Index = 0

//------------------------------------------------------------------
//  Delete the dragged rows if necessary.
//------------------------------------------------------------------

IF VisualWord = 0 THEN
   THIS.fu_HLDeleteSelectedRows(l_TmpKeys[])
END IF

RETURN l_NumSelected
end function

public subroutine fu_hlinsertoptions (integer level, string options);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLInsertOptions
//  Description   : Sets options for manually inserted rows.
//
//  Parameters    : INTEGER Level - 
//                     Level in the outliner that the options 
//                     apply to.
//                  STRING  Options - 
//                     Options for manually inserting records.
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

//------------------------------------------------------------------
//  Set the default values for the insert options of the given level.
//------------------------------------------------------------------

i_DataLevel[level]         = level
i_DataColor[level]         = "-1"
i_DataSortDirection[level] = "A"
i_DataSortType[level]      = "STRING"
i_DataKeyType[level]       = "NUMBER"
i_InsertDefined            = TRUE
i_InsertSortDefined        = FALSE

i_DataSort[level]          = "sort" + String(level)
i_DataKey[level]           = "key" + String(level)

//------------------------------------------------------------------
//  Indicate the data type of the key value.
//------------------------------------------------------------------

IF Pos(Options, c_KeyString) > 0 THEN
   i_DataKeyType[level] = "STRING"
ELSEIF Pos(Options, c_KeyNumber) > 0 THEN
   i_DataKeyType[level] = "NUMBER"
ELSEIF Pos(Options, c_KeyDate) > 0 THEN
   i_DataKeyType[level] = "DATE"
END IF

//------------------------------------------------------------------
//  Indicate the data type of the sort value.
//------------------------------------------------------------------

IF Pos(Options, c_SortString) > 0 THEN
   i_DataSortType[level] = "STRING"
ELSEIF Pos(Options, c_SortNumber) > 0 THEN
   i_DataSortType[level] = "NUMBER"
ELSEIF Pos(Options, c_SortDate) > 0 THEN
   i_DataSortType[level] = "DATE"
END IF

//------------------------------------------------------------------
//  Indicate the direction of the sort for the data.
//------------------------------------------------------------------

IF Pos(Options, c_SortAscending) > 0 THEN
   i_DataSortDirection[level] = "A"
ELSEIF Pos(Options, c_SortDescending) > 0 THEN
   i_DataSortDirection[level] = "D"
END IF

//------------------------------------------------------------------
//  Indicate the color of the outliner text for the given level.
//------------------------------------------------------------------

IF Pos(Options, c_LevelBlack) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Black)
ELSEIF Pos(Options, c_LevelWhite) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_White)
ELSEIF Pos(Options, c_LevelGray) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Gray)
ELSEIF Pos(Options, c_LevelDarkGray) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkGray)
ELSEIF Pos(Options, c_LevelRed) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Red)
ELSEIF Pos(Options, c_LevelDarkRed) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkRed)
ELSEIF Pos(Options, c_LevelGreen) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Green)
ELSEIF Pos(Options, c_LevelDarkGreen) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkGreen)
ELSEIF Pos(Options, c_LevelBlue) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Blue)
ELSEIF Pos(Options, c_LevelDarkBlue) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkBlue)
ELSEIF Pos(Options, c_LevelMagenta) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Magenta)
ELSEIF Pos(Options, c_LevelDarkMagenta) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkMagenta)
ELSEIF Pos(Options, c_LevelCyan) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Cyan)
ELSEIF Pos(Options, c_LevelDarkCyan) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkCyan)
ELSEIF Pos(Options, c_LevelYellow) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Yellow)
ELSEIF Pos(Options, c_LevelDarkYellow) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkYellow)
END IF
end subroutine

public subroutine fu_hlretrieveoptions (integer level, string column_bmp_expand, string column_bmp_collapse, string column_key, string column_foreign_key, string column_desc, string column_sort, string table, string where_clause, string options);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLRetrieveOptions
//  Description   : Establishes the options for retrieving data.  
//
//  Parameters    : INTEGER Level - 
//                     Level to set the options for.
//                  STRING  BMPExpand - 
//                     Name of the bitmap file or column that 
//                     contains a bitmap name for the
//                     expanded levels.
//                  STRING  BMPCollapse - 
//                     Name of the bitmap file or column that 
//                     contains a bitmap name for the collapsed 
//                     level.
//                  STRING  Key - 
//                     Key column.
//                  STRING  ForeignKey - 
//                     Parent key column.
//                  STRING  Desc - 
//                     Description to display in the outliner.
//                  STRING  Sort - 
//                     Column to use to sort the data.
//                  STRING  Table - 
//                     Table name.
//                  STRING  WhereClause - 
//                     Additional where clause statement.
//                  STRING  Options - 
//                     Retrieve options.
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

//------------------------------------------------------------------
//  Set the default values for the retrieve options.
//------------------------------------------------------------------

i_DataLevel[level]       = level
i_DataBMPExpand[level]   = column_bmp_expand
i_DataBMPCollapse[level] = column_bmp_collapse
i_DataKey[level]         = column_key
i_DataForeignKey[level]  = column_foreign_key
i_DataDesc[level]        = column_desc
i_DataSort[level]        = column_sort
i_DataTable[level]       = table
i_DataWhere[level]       = where_clause
i_DataColor[level]       = "-1"
i_DataSortDirection[level] = "A"
i_DataSortType[level]    = "STRING"
i_DatakeyType[level]     = "NUMBER"
i_DataBMP[level]         = FALSE
i_RetrieveDefined        = FALSE

//------------------------------------------------------------------
//  Indicate the data type of the key column.
//------------------------------------------------------------------

IF Pos(Options, c_KeyString) > 0 THEN
   i_DataKeyType[level] = "STRING"
ELSEIF Pos(Options, c_KeyNumber) > 0 THEN
   i_DataKeyType[level] = "NUMBER"
ELSEIF Pos(Options, c_KeyDate) > 0 THEN
   i_DataKeyType[level] = "DATE"
END IF

//------------------------------------------------------------------
//  Indicate the data type of the sort column.
//------------------------------------------------------------------

IF Pos(Options, c_SortString) > 0 THEN
   i_DataSortType[level] = "STRING"
ELSEIF Pos(Options, c_SortNumber) > 0 THEN
   i_DataSortType[level] = "NUMBER"
ELSEIF Pos(Options, c_SortDate) > 0 THEN
   i_DataSortType[level] = "DATE"
END IF

//------------------------------------------------------------------
//  Indicate the location of the bitmap, from the database or a file.
//------------------------------------------------------------------

IF Pos(Options, c_BMPFromColumn) > 0 THEN
   i_DataBMP[level] = TRUE
ELSEIF Pos(Options, c_BMPFromString) > 0 THEN
   i_DataBMP[level] = FALSE
END IF

//------------------------------------------------------------------
//  Indicate the direction of the sort.
//------------------------------------------------------------------

IF Pos(Options, c_SortAscending) > 0 THEN
   i_DataSortDirection[level] = "A"
ELSEIF Pos(Options, c_SortDescending) > 0 THEN
   i_DataSortDirection[level] = "D"
END IF

//------------------------------------------------------------------
//  Indicate the color of the text for the given level.
//------------------------------------------------------------------

IF Pos(Options, c_LevelBlack) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Black)
ELSEIF Pos(Options, c_LevelWhite) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_White)
ELSEIF Pos(Options, c_LevelGray) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Gray)
ELSEIF Pos(Options, c_LevelDarkGray) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkGray)
ELSEIF Pos(Options, c_LevelRed) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Red)
ELSEIF Pos(Options, c_LevelDarkRed) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkRed)
ELSEIF Pos(Options, c_LevelGreen) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Green)
ELSEIF Pos(Options, c_LevelDarkGreen) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkGreen)
ELSEIF Pos(Options, c_LevelBlue) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Blue)
ELSEIF Pos(Options, c_LevelDarkBlue) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkBlue)
ELSEIF Pos(Options, c_LevelMagenta) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Magenta)
ELSEIF Pos(Options, c_LevelDarkMagenta) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkMagenta)
ELSEIF Pos(Options, c_LevelCyan) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Cyan)
ELSEIF Pos(Options, c_LevelDarkCyan) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkCyan)
ELSEIF Pos(Options, c_LevelYellow) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_Yellow)
ELSEIF Pos(Options, c_LevelDarkYellow) > 0 THEN
   i_DataColor[level] = String(OBJCA.MGR.c_DarkYellow)
END IF
end subroutine

private subroutine fu_hlsetoptions (string optionstyle, string options);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_SetOptions
//  Description   : Sets visual defaults and options.  This function
//                  is used by all the option functions (i.e.
//                  fu_HLOptions).  It is also called by the
//                  constructor event to set initial defaults.  
//
//  Parameters    : STRING OptionStyle - 
//                     Indicates which function is the calling 
//                     routine.
//                  STRING Options - 
//                     Visual options.
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

CHOOSE CASE OptionStyle

   //---------------------------------------------------------------
   //  Set the outliner options and defaults.
   //---------------------------------------------------------------

   CASE "General"

      //------------------------------------------------------------
      //  Outliner background color.
      //------------------------------------------------------------

      IF Pos(Options, c_HLBlack) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_HLWhite) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_HLGray) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_HLDarkGray) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_HLRed) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_HLDarkRed) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_HLGreen) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_HLDarkGreen) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_HLBlue) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_HLDarkBlue) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_HLMagenta) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_HLDarkMagenta) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_HLCyan) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_HLDarkCyan) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_HLYellow) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_HLDarkYellow) > 0 THEN
         i_HLColor = String(OBJCA.MGR.c_DarkYellow)
      END IF

      //------------------------------------------------------------
      //  Show lines.
      //------------------------------------------------------------

      IF Pos(Options, c_ShowLines) > 0 THEN
         i_ShowLines = TRUE
      ELSEIF Pos(Options, c_HideLines) > 0 THEN
         i_ShowLines = FALSE
      END IF

      //------------------------------------------------------------
      //  Show boxes.
      //------------------------------------------------------------

      IF Pos(Options, c_ShowBoxes) > 0 THEN
         i_ShowBoxes = TRUE
      ELSEIF Pos(Options, c_HideBoxes) > 0 THEN
         i_ShowBoxes = FALSE
      END IF

      //------------------------------------------------------------
      //  Show bitmaps.
      //------------------------------------------------------------

      IF Pos(Options, c_ShowBMP) > 0 THEN
         i_ShowBMP = TRUE
      ELSEIF Pos(Options, c_HideBMP) > 0 THEN
         i_ShowBMP = FALSE
      END IF

      //------------------------------------------------------------
      //  Outliner line color.
      //------------------------------------------------------------

      IF Pos(Options, c_LineBlack) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_LineWhite) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_LineGray) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_LineDarkGray) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_LineRed) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_LineDarkRed) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_LineGreen) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_LineDarkGreen) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_LineBlue) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_LineDarkBlue) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_LineMagenta) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_LineDarkMagenta) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_LineCyan) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_LineDarkCyan) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_LineYellow) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_LineDarkYellow) > 0 THEN
         i_LineColor = String(OBJCA.MGR.c_DarkYellow)
      END IF

      //------------------------------------------------------------
      //  Retrieve all or retrieve as needed.
      //------------------------------------------------------------

      IF Pos(Options, c_RetrieveAll) > 0 THEN
         i_RetrieveAll = TRUE
      ELSEIF Pos(Options, c_RetrieveAsNeeded) > 0 THEN
         i_RetrieveAll = FALSE
      END IF

      //------------------------------------------------------------
      //  Retain or delete rows on collapse.
      //------------------------------------------------------------

      IF Pos(Options, c_RetainOnCollapse) > 0 THEN
         i_RetainOnCollapse = TRUE
      ELSEIF Pos(Options, c_DeleteOnCollapse) > 0 THEN
         i_RetainOnCollapse = FALSE
      END IF

      //------------------------------------------------------------
      //  Expand all on open.
      //------------------------------------------------------------

      IF Pos(Options, c_ExpandOnOpen) > 0 THEN
         i_CollapseOnOpen = FALSE
      ELSEIF Pos(Options, c_CollapseOnOpen) > 0 THEN
         i_CollapseOnOpen = TRUE
      END IF

      //------------------------------------------------------------
      //  Selected row highlight color.
      //------------------------------------------------------------

      IF Pos(Options, c_HighlightBlack) > 0 THEN
         i_HLHighColor = String(OBJCA.MGR.c_Black)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightWhite) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_White)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightGray) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_Gray)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightDarkGray) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_DarkGray)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightRed) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_Red)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightDarkRed) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_DarkRed)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightGreen) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_Green)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightDarkGreen) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_DarkGreen)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightBlue) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_Blue)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightDarkBlue) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_DarkBlue)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightMagenta) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_Magenta)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightDarkMagenta) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_DarkMagenta)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightCyan) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_Cyan)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightDarkCyan) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_DarkCyan)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightYellow) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_Yellow)
			i_SaveHighColor = i_HLHighColor
      ELSEIF Pos(Options, c_HighlightDarkYellow) > 0 THEN
         i_HLHighColor= String(OBJCA.MGR.c_DarkYellow)
			i_SaveHighColor = i_HLHighColor
      END IF

      //------------------------------------------------------------
      //  Highlight selected rows.
      //------------------------------------------------------------

      IF Pos(Options, c_ShowHighlight) > 0 THEN
         IF i_HLHighColor = i_HLColor THEN
				i_HLHighColor = i_SaveHighColor
			END IF
         IF i_TextHighColor = i_TextColor THEN
				i_TextHighColor = i_SaveTextHighColor
			END IF
      ELSEIF Pos(Options, c_HideHighlight) > 0 THEN
         i_HLHighColor = i_HLColor
         i_TextHighColor = i_TextColor
      END IF

      //------------------------------------------------------------
      //  Row focus indicator rectangle color.
      //------------------------------------------------------------

      IF Pos(Options, c_RowFocusIndicatorBlack) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_Black)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorWhite) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_White)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorGray) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_Gray)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorDarkGray) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_DarkGray)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorRed) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_Red)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorDarkRed) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_DarkRed)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorGreen) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_Green)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorDarkGreen) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_DarkGreen)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorBlue) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_Blue)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorDarkBlue) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_DarkBlue)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorMagenta) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_Magenta)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorDarkMagenta) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_DarkMagenta)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorCyan) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_Cyan)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorDarkCyan) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_DarkCyan)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorYellow) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_Yellow)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      ELSEIF Pos(Options, c_RowFocusIndicatorDarkYellow) > 0 THEN
         i_RowFocusIndicatorColor = String(OBJCA.MGR.c_DarkYellow)
			i_SaveRowFocusColor = i_RowFocusIndicatorColor
      END IF

      //------------------------------------------------------------
      //  Show row focus indicator.
      //------------------------------------------------------------

      IF Pos(Options, c_ShowRowFocusIndicator) > 0 THEN
         i_ShowRowFocusIndicator = TRUE
         IF i_RowFocusIndicatorColor = i_HLColor THEN
            i_RowFocusIndicatorColor = i_SaveRowFocusColor
         END IF
      ELSEIF Pos(Options, c_HideRowFocusIndicator) > 0 THEN
         i_ShowRowFocusIndicator = FALSE
         i_RowFocusIndicatorColor = i_HLColor
      END IF

      //------------------------------------------------------------
      //  Row selection method.
      //------------------------------------------------------------

      IF Pos(Options, c_SelectOnDoubleClick) > 0 THEN
         i_SelectMethod = c_DoubleClick
      ELSEIF Pos(Options, c_SelectOnClick) > 0 THEN
         i_SelectMethod = c_Click
      ELSEIF Pos(Options, c_SelectOnRightClick) > 0 THEN
         i_SelectMethod = c_RightClick
      ELSEIF Pos(Options, c_SelectOnRightDoubleClick) > 0 THEN
         i_SelectMethod = c_RightDoubleClick
      END IF

      //------------------------------------------------------------
      //  Branching method (expanding/collapsing branches).
      //------------------------------------------------------------

      IF Pos(Options, c_BranchOnDoubleClick) > 0 THEN
         i_BranchMethod = c_DoubleClick
      ELSEIF Pos(Options, c_BranchOnClick) > 0 THEN
         i_BranchMethod = c_Click
      ELSEIF Pos(Options, c_BranchOnRightClick) > 0 THEN
         i_BranchMethod = c_RightClick
      ELSEIF Pos(Options, c_BranchOnRightDoubleClick) > 0 THEN
         i_BranchMethod = c_RightDoubleClick
      END IF

      //------------------------------------------------------------
      //  Drill down method.
      //------------------------------------------------------------

      IF Pos(Options, c_DrillDownOnDoubleClick) > 0 THEN
         i_DrillDownMethod = c_DoubleClick
      ELSEIF Pos(Options, c_DrillDownOnClick) > 0 THEN
         i_DrillDownMethod = c_Click
      ELSEIF Pos(Options, c_DrillDownOnRightClick) > 0 THEN
         i_DrillDownMethod = c_RightClick
      ELSEIF Pos(Options, c_DrillDownOnRightDoubleClick) > 0 THEN
         i_DrillDownMethod = c_RightDoubleClick
      END IF

      //------------------------------------------------------------
      //  Drill down on last or any level.
      //------------------------------------------------------------

      IF Pos(Options, c_DrillDownOnLastLevel) > 0 THEN
         i_DrillOnLastLevel = TRUE
      ELSEIF Pos(Options, c_DrillDownOnAnyLevel) > 0 THEN
         i_DrillOnLastLevel = FALSE
      END IF

      //------------------------------------------------------------
      //  Multi-select.
      //------------------------------------------------------------

      IF Pos(Options, c_SingleSelect) > 0 THEN
         i_MultiSelect = FALSE
      ELSEIF Pos(Options, c_MultiSelect) > 0 THEN
         i_MultiSelect = TRUE
      END IF
		
      //------------------------------------------------------------
      //  Allow drag and drop.
      //------------------------------------------------------------
		
      IF Pos(Options, c_AllowDragDrop) > 0 THEN
         i_AllowDragDrop = TRUE
      ELSEIF Pos(Options, c_NoAllowDragDrop) > 0 THEN
         i_AllowDragDrop = FALSE
      END IF
		
      //------------------------------------------------------------
      //  Move or copy dragged rows within the outliner.
      //------------------------------------------------------------

      IF Pos(Options, c_DragMoveRows) > 0 THEN
         i_DragMoveRows = TRUE
      ELSEIF Pos(Options, c_DragCopyRows) > 0 THEN
         i_DragMoveRows = FALSE
      END IF

      //------------------------------------------------------------
      //  Drag and drop on last or any level.
      //------------------------------------------------------------

      IF Pos(Options, c_DragOnLastLevel) > 0 THEN
         i_DragOnLastLevel = TRUE
      ELSEIF Pos(Options, c_DragOnAnyLevel) > 0 THEN
         i_DragOnLastLevel = FALSE
      END IF

   //---------------------------------------------------------------
   //  Set the outliner text options and defaults.
   //---------------------------------------------------------------

   CASE "Text"

      //------------------------------------------------------------
      //  Outliner text style.
      //------------------------------------------------------------

      IF Pos(Options, c_TextRegular) > 0 THEN
         i_TextStyle = "font.weight"
         i_TextStyleValue = "400" 
      ELSEIF Pos(Options, c_TextBold) > 0 THEN
         i_TextStyle = "font.weight"
         i_TextStyleValue = "700" 
      ELSEIF Pos(Options, c_TextItalic) > 0 THEN
         i_TextStyle = "font.italic"
         i_TextStyleValue = "1"
      ELSEIF Pos(Options, c_TextUnderline) > 0 THEN
         i_TextStyle = "font.underline"
         i_TextStyleValue = "1"
      END IF

      //------------------------------------------------------------
      //  Outliner text color.
      //------------------------------------------------------------

      IF Pos(Options, c_TextBlack) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_TextWhite) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_TextGray) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_TextDarkGray) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_TextRed) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_TextDarkRed) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_TextGreen) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_TextDarkGreen) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_TextBlue) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_TextDarkBlue) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_TextMagenta) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_TextDarkMagenta) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_TextCyan) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_TextDarkCyan) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_TextYellow) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_TextDarkYellow) > 0 THEN
         i_TextColor = String(OBJCA.MGR.c_DarkYellow)
      END IF

      //------------------------------------------------------------
      //  Outliner selected text color.
      //------------------------------------------------------------

      IF i_HLHighColor = i_HLColor THEN
         i_TextHighColor = i_TextColor
      ELSE
         IF Pos(Options, c_TextHighlightBlack) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_Black)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightWhite) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_White)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightGray) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_Gray)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightDarkGray) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_DarkGray)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightRed) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_Red)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightDarkRed) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_DarkRed)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightGreen) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_Green)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightDarkGreen) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_DarkGreen)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightBlue) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_Blue)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightDarkBlue) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_DarkBlue)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightMagenta) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_Magenta)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightDarkMagenta) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_DarkMagenta)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightCyan) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_Cyan)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightDarkCyan) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_DarkCyan)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightYellow) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_Yellow)
				i_SaveTextHighColor = i_TextHighColor
         ELSEIF Pos(Options, c_TextHighlightDarkYellow) > 0 THEN
            i_TextHighColor = String(OBJCA.MGR.c_DarkYellow)
				i_SaveTextHighColor = i_TextHighColor
         END IF
      END IF

END CHOOSE
end subroutine

public subroutine fu_hloptions (string options);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLOptions
//  Description   : Sets options for the outliner object.
//
//  Parameters    : STRING Options - 
//                     Visual options for the outliner portion of 
//                     the object.
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
 
IF Options <> c_DefaultVisual THEN
   THIS.fu_HLSetOptions("General", Options)
END IF
end subroutine

public subroutine fu_hltextoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLTextOptions
//  Description   : Establishes the look-and-feel of the text
//                  portion of the outliner object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the text portion.
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

//------------------------------------------------------------------
//  Set the font style of the text for the outliner.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   i_TextFont = TextFont
   CHOOSE CASE UPPER(i_TextFont)
      CASE "ARIAL"
         i_TextFamily  = "2"
         i_TextPitch   = "2"
         i_TextCharSet = "0"
      CASE "COURIER", "COURIER NEW"
         i_TextFamily  = "1"
         i_TextPitch   = "1"
         i_TextCharSet = "0"
      CASE "MODERN"
         i_TextFamily  = "1"
         i_TextPitch   = "2"
         i_TextCharSet = "-1"
      CASE "MS SANS SERIF"
         i_TextFamily  = "2"
         i_TextPitch   = "2"
         i_TextCharSet = "0"
      CASE "MS SERIF"
         i_TextFamily  = "1"
         i_TextPitch   = "2"
         i_TextCharSet = "0"
      CASE "ROMAN"
         i_TextFamily  = "1"
         i_TextPitch   = "2"
         i_TextCharSet = "-1"
      CASE "SCRIPT"
         i_TextFamily  = "4"
         i_TextPitch   = "2"
         i_TextCharSet = "-1"
      CASE "SMALL FONTS"
         i_TextFamily  = "2"
         i_TextPitch   = "2"
         i_TextCharSet = "0"
      CASE "SYSTEM"
         i_TextFamily  = "2"
         i_TextPitch   = "2"
         i_TextCharSet = "0"
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         i_TextFamily  = "1"
         i_TextPitch   = "2"
         i_TextCharSet = "0"
      CASE "MS LINEDRAW"
         i_TextFamily  = "1"
         i_TextPitch   = "1"
         i_TextCharSet = "2"
      CASE "TERMINAL"
         i_TextFamily  = "1"
         i_TextPitch   = "1"
         i_TextCharSet = "-1"
      CASE "CENTURY SCHOOLBOOK"
         i_TextFamily  = "1"
         i_TextPitch   = "2"
         i_TextCharSet = "0"
      CASE "CENTURY GOTHIC"
         i_TextFamily  = "2"
         i_TextPitch   = "2"
         i_TextCharSet = "0"
      CASE ELSE
         i_TextFamily  = "2"
         i_TextPitch   = "2"
         i_TextCharSet = "0"
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Set the font size of the text for the outliner.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   i_TextSize = String(TextSize * -1)
END IF

//------------------------------------------------------------------
//  Set the visual options for the text portion of the outliner.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_HLSetOptions("Text", Options)
END IF

end subroutine

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_GetIdentity
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

public subroutine fu_hlrowaction (long row, long key_down, integer action_type);//******************************************************************
//  PO Module     : u_Outliner
//  Subroutine    : fu_HLRowAction
//  Description   : Determines what action to take on a record.
//
//  Parameters    : LONG Row - 
//                     Row number.
//                  LONG Key_Down - 
//                     Key action for multiple selection.
//                  INTEGER Action_Type -
//                     The event we are comming from.
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

LONG l_BeginRow, l_EndRow, l_PreviousRow, l_SelectedRow
LONG l_ClickedRow, l_KeyDown, l_FindRow, l_PreviousLevel

//------------------------------------------------------------------
//  Get the clicked row and see if the user held the CTRL or SHIFT
//  key down.
//------------------------------------------------------------------

l_ClickedRow = row
l_KeyDown    = key_down

IF l_ClickedRow <= 0 THEN
   RETURN
END IF

THIS.SetRedraw (FALSE)

//------------------------------------------------------------------
//  Save the clicked row and determine the level of the row.
//------------------------------------------------------------------

i_DragRow     = 0
l_PreviousRow = i_ClickedRow
l_PreviousLevel = fu_HLGetRowLevel(l_PreviousRow)
i_ClickedRow  = l_ClickedRow
i_ClickedLevel= GetItemNumber(i_ClickedRow, "level")

//------------------------------------------------------------------
//  Determine if branching is to be done.
//------------------------------------------------------------------

IF i_BranchMethod = action_type THEN
   IF GetItemNumber(i_ClickedRow, "expanded") = 1 THEN
      THIS.fu_HLCollapseBranch()
   ELSE
      THIS.fu_HLExpandLevel()
   END IF
END IF
         
//------------------------------------------------------------------
//  Determine if this record may be selected.
//------------------------------------------------------------------

IF i_SelectMethod = action_type THEN

   i_SelectedRow   = i_ClickedRow
   i_SelectedLevel = i_ClickedLevel

   //---------------------------------------------------------------
   //  If drag and drop is allowed, put the outliner in dragdrop
   //  mode.
   //---------------------------------------------------------------

   IF i_AllowDragDrop THEN
      IF i_DragOnLastLevel AND i_ClickedLevel <> i_MaxLevels THEN
      ELSE
         DragIcon    = "dragrows.ico"
         i_DragRow   = i_ClickedRow
			i_DragLevel = i_ClickedLevel
         Drag(Begin!)
      END IF
   END IF

   //---------------------------------------------------------------
   //  Outliner allows multiple record selection and the CTRL key 
   //  was pressed.
   //---------------------------------------------------------------

   IF l_KeyDown = 9 AND i_MultiSelect AND &
      i_LastSelectedLevel = i_ClickedLevel THEN 

      IF GetItemNumber(i_ClickedRow, "selected") = 1 THEN
         SetItem(i_ClickedRow, "selected", 0)
         i_AnchorRow = 0
      ELSE
         SetItem(i_ClickedRow, "selected", 1)
         i_AnchorRow = i_ClickedRow
      END IF

   //---------------------------------------------------------------
   //  Outliner allows multiple record selection and the SHIFT key 
   //  was pressed.
   //---------------------------------------------------------------

   ELSEIF l_KeyDown = 5 AND i_MultiSelect AND &
      i_LastSelectedLevel = i_ClickedLevel THEN

      IF i_AnchorRow = 0 THEN
         i_AnchorRow = i_ClickedRow  
      END IF

      IF i_ClickedRow >= i_AnchorRow THEN
         l_BeginRow = i_AnchorRow
         l_EndRow = i_ClickedRow
      ELSE
         l_EndRow = i_AnchorRow
         l_BeginRow = i_ClickedRow
      END IF
		
      l_FindRow = l_BeginRow - 1
      DO
	      l_BeginRow = l_FindRow + 1
	      l_FindRow = Find("level = " + String(i_ClickedLevel), &
			                 l_BeginRow, l_EndRow)
	      IF l_FindRow > 0 THEN
				IF GetItemNumber(l_FindRow, "heightline") > 0 THEN
		         SetItem(l_FindRow, "selected", 1)
				END IF
	      END IF
      LOOP WHILE l_FindRow > 0 AND l_FindRow < l_EndRow

   //---------------------------------------------------------------
   //  A single record was selected.
   //---------------------------------------------------------------

   ELSE

      IF i_ClickedRow <> l_PreviousRow OR &
         GetItemNumber(i_ClickedRow, "selected") = 0 THEN

         i_LastSelectedLevel = i_ClickedLevel
         l_BeginRow = 1
         l_EndRow = RowCount()
         DO
            l_SelectedRow = Find("selected = 1", &
                                 l_BeginRow, l_EndRow)
            IF l_SelectedRow > 0 THEN
               SetItem(l_SelectedRow, "selected", 0)
               l_BeginRow = l_BeginRow + 1
            END IF
         LOOP UNTIL l_SelectedRow <= 0

         i_AnchorRow = i_ClickedRow
         SetItem(i_ClickedRow, "selected", 1)
      ELSE
         IF l_KeyDown = 9 AND NOT i_MultiSelect THEN
            i_AnchorRow = 0
            SetItem(i_ClickedRow, "selected", 0)
            i_SelectedRow = 0
            i_SelectedLevel = 0
         END IF
      END IF
   END IF

   //---------------------------------------------------------------
   //  Trigger the po_SelectedRow event to allow the developer to
   //  code something.
   //---------------------------------------------------------------
	
	i_RowError = 0
	
	Event po_SelectedRow(i_SelectedRow, i_SelectedLevel, i_MaxLevels)

   IF i_RowError = -1 THEN
		THIS.SetRedraw (TRUE)
      RETURN
   END IF

END IF

//------------------------------------------------------------------
//  Determine if a drill down must be done.
//------------------------------------------------------------------

IF i_DrillDownMethod = action_type THEN

   IF i_DrillOnLastLevel THEN
      IF i_ClickedLevel <> i_MaxLevels THEN
			THIS.SetRedraw (TRUE)
         RETURN
      END IF
   END IF

   //---------------------------------------------------------------
   //  Allow the developer to validate the currently selected row.
   //---------------------------------------------------------------
	
	i_RowError = 0
	
	Event po_ValidateRow(i_ClickedRow, i_ClickedLevel, &
	                     l_PreviousRow, l_PreviousLevel, &
								i_MaxLevels)

   IF i_RowError = -1 THEN
		THIS.SetRedraw (TRUE)
      RETURN
   END IF

   //---------------------------------------------------------------
   //  Trigger the po_PickedRow event to allow the developer to
   //  code something.
   //---------------------------------------------------------------

   Event po_PickedRow(i_ClickedRow, i_ClickedLevel, i_MaxLevels)

END IF

THIS.SetRedraw (TRUE)
end subroutine

event clicked;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : Clicked
//  Description   : Determines a users action.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  03/10/00 M. Caruso  Only process this event if a row was
//								actually clicked.
//  03/15/02 M. Caruso  Disable screen refresh until after the row
//								action is processed.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_ClickedRow, l_KeyDown

// only process this event if a row was clicked
IF dwo.Type <> 'datawindow' THEN			// M. Caruso   3/10/00

	IF KeyDown(KeyControl!) THEN
		l_KeyDown = 9
	ELSEIF KeyDown(KeyShift!) THEN
		l_KeyDown = 5
	ELSE
		l_KeyDown = 0
	END IF
	
	l_ClickedRow = row
	
	IF l_ClickedRow <= 0 THEN
		RETURN
	END IF
	
	THIS.SetRedraw (FALSE)
	THIS.fu_HLRowAction(l_ClickedRow, l_KeyDown, c_Click)
	THIS.SetRedraw (TRUE)

END IF
end event

event rowfocuschanged;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : RowFocusChanged
//  Description   : Move the row focus indicator rectangle to the
//                  current record.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_FocusRow, l_CurrentRow

//------------------------------------------------------------------
//  If this event is executed when not needed then return.
//------------------------------------------------------------------

IF NOT i_IgnoreRFC THEN
   SetItem(i_FocusRow, "current", 0)
   l_CurrentRow = GetRow()
   IF l_CurrentRow > 0 THEN

      //------------------------------------------------------------
      //  Set the row focus indicator rectangle.
      //------------------------------------------------------------

      IF GetItemNumber(l_CurrentRow, "heightline") = 0 THEN
         IF i_FocusRow < l_CurrentRow THEN
            l_FocusRow = Find("heightline > 0", &
                              l_CurrentRow, RowCount())
            IF l_FocusRow > i_FocusRow THEN
               i_FocusRow = l_FocusRow
            END IF
         ELSE
            l_FocusRow = Find("heightline > 0", l_CurrentRow, 1)
            IF l_FocusRow < i_FocusRow THEN
               i_FocusRow = l_FocusRow
            END IF
         END IF
      ELSE
         i_FocusRow = l_CurrentRow
      END IF
      SetItem(i_FocusRow, "current", 1)
      i_IgnoreRFC = TRUE
      ScrollToRow(i_FocusRow)
      i_IgnoreRFC = FALSE
   END IF
END IF
end event

event doubleclicked;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : DoubleClicked
//  Description   : Determines a users action.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  04/21/00 M. Caruso  Only process this event if a row was
//								actually clicked.
//  03/15/02 M. Caruso  Disable screen refresh until after the row
//								action is processed.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_ClickedRow, l_KeyDown

// only process this event if a row was clicked
IF dwo.Type <> 'datawindow' THEN			// M. Caruso   3/10/00

	IF KeyDown(KeyControl!) THEN
		l_KeyDown = 9
	ELSEIF KeyDown(KeyShift!) THEN
		l_KeyDown = 5
	ELSE
		l_KeyDown = 0
	END IF
	
	l_ClickedRow = row
	
	IF l_ClickedRow <= 0 THEN
		RETURN
	END IF
	
	THIS.SetRedraw (FALSE)
	THIS.fu_HLRowAction(l_ClickedRow, l_KeyDown, c_DoubleClick)
	THIS.SetRedraw (TRUE)

END IF
end event

event dragdrop;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : DragDrop
//  Description   : Processes records that are dropped into the 
//                  outliner.  These records may come from within
//                  the outliner or from outside.
//
//  Return        : INTEGER i_DropError - 
//                      0 = OK.
//                     -1 = The drop process was not completed
//                          successfully.
//  
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_DropPointer, l_Keys[]
LONG   l_LastRow, l_Index, l_DropRow, l_Rows, l_Idx, l_Jdx
LONG   l_EndRow, l_CurrentRow
INTEGER l_Numkeys, l_Level, l_Height, l_Return, l_Expand

//------------------------------------------------------------------
//  Get the row the user dropped the records on.
//------------------------------------------------------------------

i_DropError = 0
l_DropPointer = GetBandAtPointer()
l_DropRow = LONG(MID(l_DropPointer, POS(l_DropPointer, "~t") + 1))
l_LastRow = RowCount()

//------------------------------------------------------------------
//  If the records were dropped on the same row or an invalid row
//  was determined then return.
//------------------------------------------------------------------

IF i_DragRow = l_DropRow OR &
   (l_DropRow <= 0 OR l_DropRow > l_LastRow) THEN
   i_DragFromOutside = FALSE
   i_DragFromInside = FALSE
   i_DropError = -1
   RETURN
END IF

//------------------------------------------------------------------
//  Only allow dragdrop within the outliner to occur at the lowest
//  level.
//------------------------------------------------------------------

IF i_DragFromInside AND i_DragLevel <> i_MaxLevels THEN
	i_DragFromOutside = FALSE
	i_DragFromInside = FALSE
	i_DropError = -1
	RETURN
END IF

//------------------------------------------------------------------
//  Get the level of the drop row.
//------------------------------------------------------------------

l_Level   = THIS.fu_HLGetRowLevel(l_DropRow)

//------------------------------------------------------------------
//  If the drop row is more than one level above the drag level,
//  then we don't know where to drop them, so return.
//------------------------------------------------------------------

IF l_Level < i_DragLevel - 1 THEN
   i_DragFromOutside = FALSE
   i_DragFromInside = FALSE
   i_DropError = -1
   RETURN
END IF

//------------------------------------------------------------------
//  Since we may not have been dropped right on the correct level,
//  find the "real" drop row.
//------------------------------------------------------------------

IF l_Level <> i_DragLevel - 1 THEN
	IF i_DragLevel = 1 THEN
		l_Level = 1
	ELSE
		l_Level = i_DragLevel - 1
	END IF
   l_DropRow = Find("level = " + String(l_Level), &
                    l_DropRow, 1)
	IF l_DropRow <= 0 THEN
		i_DragFromOutside = FALSE
		i_DragFromInside = FALSE
		i_DropError = -1
		RETURN
	END IF
END IF

//------------------------------------------------------------------
//  Get the key structure of the "real" drop row.
//------------------------------------------------------------------

l_NumKeys = THIS.fu_HLGetRowKey(l_DropRow, l_Keys[])

//------------------------------------------------------------------
//  Determine if the drop row is expanded or collapsed.
//------------------------------------------------------------------

SetPointer(HourGlass!)
SetReDraw(FALSE)

SetItem(i_FocusRow, "current", 0)
IF GetItemNumber(l_DropRow, "expanded") = 1 THEN
	l_Height = i_HeightFactor
ELSE
	l_Height = 0
END IF

//------------------------------------------------------------------
//  If the drag source is from outside the outliner.
//------------------------------------------------------------------

IF i_DragFromOutside THEN
  
   //---------------------------------------------------------------
   //  Clear the previously selected rows and insert a new record
   //  for each record dragged.
   //---------------------------------------------------------------

   THIS.fu_HLClearSelectedRows()
   l_Rows = UpperBound(i_DragKey[])
   FOR l_Idx = 1 TO l_Rows
      i_IgnoreRFC = TRUE
      InsertRow(0)
      l_CurrentRow = RowCount()

      //------------------------------------------------------------
      //  Set the record values.
      //------------------------------------------------------------

      SetItem(l_CurrentRow, "level", i_DragLevel)
      SetItem(l_CurrentRow, "bmpopen", i_DragBMPOpen[l_Idx])
      SetItem(l_CurrentRow, "bmpclose", i_DragBMPClose[l_Idx])
      SetItem(l_CurrentRow, "showline", "")
      SetItem(l_CurrentRow, "unused", 0)
      SetItem(l_CurrentRow, "selected", 1)
      SetItem(l_CurrentRow, "current", 0)
      SetItem(l_CurrentRow, "stringdesc", i_DragDescription[l_Idx])
      SetItem(l_CurrentRow, "expanded", 0)
      SetItem(l_CurrentRow, "updated", 1)
	   SetDetailHeight(l_CurrentRow, l_CurrentRow, l_Height)

      //------------------------------------------------------------
      //  Set the key and sort values for each parent.
      //------------------------------------------------------------

      FOR l_Jdx = 1 TO l_Level
         CHOOSE CASE i_DataKeyType[l_Jdx]
            CASE "STRING"
               SetItem(l_CurrentRow, l_Jdx + i_MaxLevels + 10, l_Keys[l_Jdx])
            CASE "NUMBER"
               SetItem(l_CurrentRow, l_Jdx + i_MaxLevels + 10, Long(l_Keys[l_Jdx]))
            CASE "DATE"
               SetItem(l_CurrentRow, l_Jdx + i_MaxLevels + 10, Date(l_Keys[l_Jdx]))
         END CHOOSE
         CHOOSE CASE i_DataSortType[l_Jdx]
            CASE "STRING"
               SetItem(l_CurrentRow, l_Jdx + 10, GetItemString(l_DropRow, l_Jdx + 10))
            CASE "NUMBER"
               SetItem(l_CurrentRow, l_Jdx + 10, GetItemNumber(l_DropRow, l_Jdx + 10))
            CASE "DATE"
               SetItem(l_CurrentRow, l_Jdx + 10, GetItemDate(l_DropRow, l_Jdx + 10))
         END CHOOSE
      NEXT

      //------------------------------------------------------------
      //  Set the key and sort values for the lowest level.
      //------------------------------------------------------------

      CHOOSE CASE i_DataKeyType[i_DragLevel]
         CASE "STRING"
            SetItem(l_CurrentRow, i_DragLevel + i_MaxLevels + 10, i_DragKey[l_Idx])
         CASE "NUMBER"
            SetItem(l_CurrentRow, i_DragLevel + i_MaxLevels + 10, Long(i_DragKey[l_Idx]))
         CASE "DATE"
            SetItem(l_CurrentRow, i_DragLevel + i_MaxLevels + 10, Date(i_DragKey[l_Idx]))
      END CHOOSE
      CHOOSE CASE i_DataSortType[i_DragLevel]
         CASE "STRING"
            SetItem(l_CurrentRow, i_DragLevel + 10, i_DragSort[l_Idx])
         CASE "NUMBER"
            SetItem(l_CurrentRow, i_DragLevel + 10, Long(i_DragSort[l_Idx]))
         CASE "DATE"
            SetItem(l_CurrentRow, i_DragLevel + 10, Date(i_DragSort[l_Idx]))
      END CHOOSE
   NEXT

   i_DragFromOutside = FALSE
          
//------------------------------------------------------------------
//  If the drag source is from inside the outliner.
//------------------------------------------------------------------

ELSEIF i_DragFromInside THEN

   DO
      l_Index = THIS.fu_HLGetSelectedRow(l_Index)
      IF l_Index > 0 THEN
			
         //---------------------------------------------------------
         //  Determine if the row is expanded or not.
         //---------------------------------------------------------
			
			l_Expand = 0
			IF l_Height <> 0 THEN
				l_Expand = GetItemNumber(l_Index, "expanded")
			END IF

         //---------------------------------------------------------
         //  Move or copy the row.
         //---------------------------------------------------------

         IF i_DragMoveRows THEN
				
            //------------------------------------------------------
            //  Set the attributes for the moved row.
            //------------------------------------------------------

            SetItem(l_Index, "expanded", l_Expand)
            SetItem(l_Index, "updated", 1)
			   SetItem(l_Index, "showline", "")
	         SetDetailHeight(l_Index, l_Index, l_Height)
			
            //------------------------------------------------------
            //  Change the sort and key values (up to max levels)
            //  for the row based on the key and sort structure of
            //  its new parent.
            //------------------------------------------------------
				
            FOR l_Idx = 1 TO l_Level
               CHOOSE CASE i_DataKeyType[l_Idx]
                  CASE "STRING"
                     SetItem(l_Index, l_Idx + i_MaxLevels + 10, &
							        l_Keys[l_Idx])
                  CASE "NUMBER"
                     SetItem(l_Index, l_Idx + i_MaxLevels + 10, &
							        Long(l_Keys[l_Idx]))
                  CASE "DATE"
                     SetItem(l_Index, l_Idx + i_MaxLevels + 10, &
							        Date(l_Keys[l_Idx]))
               END CHOOSE
               CHOOSE CASE i_DataSortType[l_Idx]
                  CASE "STRING"
                     SetItem(l_Index, l_Idx + 10, &
							        GetItemString(l_DropRow, l_Idx + 10))
                  CASE "NUMBER"
                     SetItem(l_Index, l_Idx + 10, &
							        GetItemNumber(l_DropRow, l_Idx + 10))
                  CASE "DATE"
                     SetItem(l_Index, l_Idx + 10, &
							        GetItemDate(l_DropRow, l_Idx + 10))
               END CHOOSE
            NEXT			
			ELSE
				
            //------------------------------------------------------
            //  Make a copy of the row.
            //------------------------------------------------------
				
            l_LastRow = l_LastRow + 1
            l_Return = RowsCopy(l_DropRow, l_DropRow, Primary!, THIS, &
                                l_LastRow, Primary!)
										  
            //------------------------------------------------------
            //  Set the attributes for the copied row.
            //------------------------------------------------------
				
            SetItem(l_LastRow, "selected", 0)
            SetItem(l_LastRow, "expanded", l_Expand)
            SetItem(l_LastRow, "updated", 1)
            SetItem(l_LastRow, "showline", "")
				SetItem(l_LastRow, "level", i_DragLevel)
  	         SetDetailHeight(l_LastRow, l_LastRow, l_Height)
				  
            //------------------------------------------------------
            //  Change the last key and sort value of the copied
            //  row.
            //------------------------------------------------------
				
            CHOOSE CASE i_DataKeyType[i_MaxLevels]
               CASE "STRING"
                  SetItem(l_LastRow, i_DragLevel + i_MaxLevels + 10, &
						        GetItemString(l_Index, i_DragLevel + i_MaxLevels + 10))
               CASE "NUMBER"
                  SetItem(l_LastRow, i_DragLevel + i_MaxLevels + 10, &
	                       GetItemNumber(l_Index, i_DragLevel + i_MaxLevels + 10))
               CASE "DATE"
                  SetItem(l_LastRow, i_DragLevel + i_MaxLevels + 10, &
						        GetItemDate(l_Index, i_DragLevel + i_MaxLevels + 10))
            END CHOOSE
            CHOOSE CASE i_DataSortType[i_MaxLevels]
               CASE "STRING"
                  SetItem(l_LastRow, i_DragLevel + 10, GetItemString(l_Index, i_DragLevel + 10))
               CASE "NUMBER"
                  SetItem(l_LastRow, i_DragLevel + 10, GetItemNumber(l_Index, i_DragLevel + 10))
               CASE "DATE"
                  SetItem(l_LastRow, i_DragLevel + 10, GetItemDate(l_Index, i_DragLevel + 10))
            END CHOOSE
				
	         //--------------------------------------------------------
	         //  Set the description for the copied row.
	         //--------------------------------------------------------
				
				SetItem(l_LastRow, "stringdesc", GetItemString(l_Index, "stringdesc"))
         END IF
			
         //---------------------------------------------------------
         //  Continue until there are no more rows to check.
         //---------------------------------------------------------
          
         l_Index = l_Index + 1
         IF l_Index > l_LastRow THEN
            l_Index = 0
         END IF
      END IF
   LOOP UNTIL l_Index = 0

   i_DragFromInside = FALSE

END IF

i_IgnoreRFC = TRUE

//------------------------------------------------------------------
//  Re-sort and compute last in group.
//------------------------------------------------------------------

Sort()

l_EndRow = RowCount()
DO WHILE Find("showline = ''", 1, l_EndRow) > 0
   THIS.fu_HLSetLastInGroup()
LOOP

//------------------------------------------------------------------
//  Determine which row to scroll to.
//------------------------------------------------------------------

//IF l_Height > 0 THEN
//   l_Index = THIS.fu_HLGetSelectedRow(1)
//   ScrollToRow(l_Index)
//   i_FocusRow = l_Index
//   i_ClickedRow = 0
//   i_SelectedRow = l_Index
//ELSE
i_FocusRow = fu_HLFindRow(l_Keys[l_Level], l_Level)
ScrollToRow(i_FocusRow)
//i_FocusRow = l_DropRow
i_ClickedRow = 0
i_SelectedRow = l_DropRow
//END IF
SetItem(i_FocusRow, "current", 1)

i_IgnoreRFC = FALSE

SetReDraw(TRUE)
end event

event constructor;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : Constructor
//  Description   : Initializes the default outliner options.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Defaults, l_DefaultFont, l_DefaultSize, l_HeightFactor
STRING l_WidthFactor, l_BMPHeight, l_BMPWidth

//------------------------------------------------------------------
//  Set the default values for the outliner.
//------------------------------------------------------------------

l_Defaults = OBJCA.MGR.fu_GetDefault("Outliner", "General")
THIS.fu_HLOptions(l_Defaults)

//------------------------------------------------------------------
//  Set the default text values for the outliner.
//------------------------------------------------------------------

l_Defaults    = OBJCA.MGR.fu_GetDefault("Outliner", "Text")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Outliner", "TextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Outliner", "TextSize")
THIS.fu_HLTextOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

//------------------------------------------------------------------
//  Set the default size values for the outliner.
//------------------------------------------------------------------

l_HeightFactor = OBJCA.MGR.fu_GetDefault("Outliner", "HeightFactor")
l_WidthFactor  = OBJCA.MGR.fu_GetDefault("Outliner", "WidthFactor")
l_BMPHeight    = OBJCA.MGR.fu_GetDefault("Outliner", "BMPHeight")
l_BMPWidth     = OBJCA.MGR.fu_GetDefault("Outliner", "BMPWidth")
THIS.fu_HLSizeOptions(Integer(l_HeightFactor), &
                      Integer(l_WidthFactor), &
							 Integer(l_BMPHeight), &
							 Integer(l_BMPWidth))
end event

event rbuttondown;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : RButtonDown
//  Description   : Determines a users action.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_ClickedRow, l_KeyDown
STRING l_ClickedObject

IF KeyDown(KeyControl!) THEN
	l_KeyDown = 9
ELSEIF KeyDown(KeyShift!) THEN
	l_KeyDown = 5
ELSE
	l_KeyDown = 0
END IF

l_ClickedObject = GetObjectAtPointer()

IF l_ClickedObject = "" THEN
	RETURN
END IF

l_ClickedRow = Long(MID(l_ClickedObject, Pos(l_ClickedObject, &
                    CHAR(9)) + 1))

THIS.fu_HLRowAction(l_ClickedRow, l_KeyDown, c_RightClick)

SetRow(l_ClickedRow)

end event

event retrievestart;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : RetrieveStart
//  Description   : Cause each retrieve of a level to append the
//                  data to the DataWindow.
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
//  If the developer extends this event then they should check
//  AncestorReturnValue first to see if they should process their
//  code.  Unless the developer changes the RETURN value in their
//  code, PowerBuilder will use the AncestorReturnValue.
//------------------------------------------------------------------

RETURN 2
end event

event dragwithin;//******************************************************************
//  PO Module     : u_Outliner
//  Event         : DragWithin
//  Description   : Determines if records have been dragged from
//                  an outside object.  If not, the drag must have
//                  started from within the outliner.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF NOT i_DragFromOutside THEN
   i_DragFromInside = TRUE
END IF
end event

on u_outliner.create
end on

on u_outliner.destroy
end on

