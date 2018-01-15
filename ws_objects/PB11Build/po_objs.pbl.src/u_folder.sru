$PBExportHeader$u_folder.sru
$PBExportComments$Tab folder class
forward
global type u_folder from datawindow
end type
type s_tab_array from structure within u_folder
end type
end forward

type s_tab_array from structure
	string		tabname
	boolean		tabdisable
	boolean		tabhide
	integer		tabnumobjects
	windowobject		tabobjects[]
	boolean		tabobjectcentered[]
	boolean		tabobjectsecured[]
end type

global type u_folder from datawindow
integer width = 1211
integer height = 716
integer taborder = 1
string dataobject = "d_folder_tb"
event po_tabclicked ( integer selectedtab,  string selectedtabname )
event po_tabvalidate ( integer clickedtab,  string clickedtabname,  integer selectedtab,  string selectedtabname )
event po_identify pbm_custom73
end type
global u_folder u_folder

type variables
//-----------------------------------------------------------------------------------------
//  Folder Object Constants
//-----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName		= "Folder"
CONSTANT INTEGER	c_DefaultHeight		= 0
CONSTANT STRING	c_DefaultVisual		= "000|"
CONSTANT STRING	c_DefaultFont		= ""
CONSTANT INTEGER	c_DefaultSize		= 0

CONSTANT STRING	c_FolderTabTop		= "001|"
CONSTANT STRING	c_FolderTabBottom		= "002|"
CONSTANT STRING	c_FolderTabLeft		= "003|"
CONSTANT STRING	c_FolderTabRight		= "004|"

CONSTANT STRING	c_Folder3D		= "005|"
CONSTANT STRING	c_Folder2D		= "006|"

CONSTANT STRING	c_FolderGray		= "007|"
CONSTANT STRING	c_FolderBlack		= "008|"
CONSTANT STRING	c_FolderWhite		= "009|"
CONSTANT STRING	c_FolderDarkGray		= "010|"
CONSTANT STRING	c_FolderRed		= "011|"
CONSTANT STRING	c_FolderDarkRed		= "012|"
CONSTANT STRING	c_FolderGreen		= "013|"
CONSTANT STRING	c_FolderDarkGreen		= "014|"
CONSTANT STRING	c_FolderBlue		= "015|"
CONSTANT STRING	c_FolderDarkBlue		= "016|"
CONSTANT STRING	c_FolderMagenta		= "017|"
CONSTANT STRING	c_FolderDarkMagenta	= "018|"
CONSTANT STRING	c_FolderCyan		= "019|"
CONSTANT STRING	c_FolderDarkCyan		= "020|"
CONSTANT STRING	c_FolderYellow		= "021|"
CONSTANT STRING	c_FolderDarkYellow		= "022|"

CONSTANT STRING	c_FolderBorderOn		= "023|"
CONSTANT STRING	c_FolderBorderOff		= "024|"

CONSTANT STRING	c_FolderResizeOn		= "025|"
CONSTANT STRING	c_FolderResizeOff		= "026|"

CONSTANT STRING	c_TextRegular		= "001|"
CONSTANT STRING	c_TextBold		= "002|"
CONSTANT STRING	c_TextItalic		= "003|"
CONSTANT STRING	c_TextUnderline		= "004|"

CONSTANT STRING	c_TextCenter		= "005|"
CONSTANT STRING	c_TextLeft		= "006|"
CONSTANT STRING	c_TextRight		= "007|"

CONSTANT STRING	c_TextBlack		= "008|"
CONSTANT STRING	c_TextWhite		= "009|"
CONSTANT STRING	c_TextGray		= "010|"
CONSTANT STRING	c_TextDarkGray		= "011|"
CONSTANT STRING	c_TextRed		= "012|"
CONSTANT STRING	c_TextDarkRed		= "013|"
CONSTANT STRING	c_TextGreen		= "014|"
CONSTANT STRING	c_TextDarkGreen		= "015|"
CONSTANT STRING	c_TextBlue		= "016|"
CONSTANT STRING	c_TextDarkBlue		= "017|"
CONSTANT STRING	c_TextMagenta		= "018|"
CONSTANT STRING	c_TextDarkMagenta	= "019|"
CONSTANT STRING	c_TextCyan		= "020|"
CONSTANT STRING	c_TextDarkCyan		= "021|"
CONSTANT STRING	c_TextYellow		= "022|"
CONSTANT STRING	c_TextDarkYellow		= "023|"

CONSTANT STRING	c_TextRotationOff		= "024|"
CONSTANT STRING	c_TextRotationOn		= "025|"

CONSTANT STRING	c_TextCurrentBold		= "001|"
CONSTANT STRING	c_TextCurrentRegular	= "002|"
CONSTANT STRING	c_TextCurrentItalic		= "003|"
CONSTANT STRING	c_TextCurrentUnderline	= "004|"

CONSTANT STRING	c_TextCurrentBlack		= "005|"
CONSTANT STRING	c_TextCurrentWhite		= "006|"
CONSTANT STRING	c_TextCurrentGray		= "007|"
CONSTANT STRING	c_TextCurrentDarkGray	= "008|"
CONSTANT STRING	c_TextCurrentRed		= "009|"
CONSTANT STRING	c_TextCurrentDarkRed	= "010|"
CONSTANT STRING	c_TextCurrentGreen	= "011|"
CONSTANT STRING	c_TextCurrentDarkGreen	= "012|"
CONSTANT STRING	c_TextCurrentBlue		= "013|"
CONSTANT STRING	c_TextCurrentDarkBlue	= "014|"
CONSTANT STRING	c_TextCurrentMagenta	= "015|"
CONSTANT STRING	c_TextCurrentDarkMagenta	= "016|"
CONSTANT STRING	c_TextCurrentCyan		= "017|"
CONSTANT STRING	c_TextCurrentDarkCyan	= "018|"
CONSTANT STRING	c_TextCurrentYellow	= "019|"
CONSTANT STRING	c_TextCurrentDarkYellow	= "020|"

CONSTANT STRING	c_TabCurrentGray		= "021|"
CONSTANT STRING	c_TabCurrentBlack		= "022|"
CONSTANT STRING	c_TabCurrentWhite		= "023|"
CONSTANT STRING	c_TabCurrentDarkGray	= "024|"
CONSTANT STRING	c_TabCurrentRed		= "025|"
CONSTANT STRING	c_TabCurrentDarkRed	= "026|"
CONSTANT STRING	c_TabCurrentGreen		= "027|"
CONSTANT STRING	c_TabCurrentDarkGreen	= "028|"
CONSTANT STRING	c_TabCurrentBlue		= "029|"
CONSTANT STRING	c_TabCurrentDarkBlue	= "030|"
CONSTANT STRING	c_TabCurrentMagenta	= "031|"
CONSTANT STRING	c_TabCurrentDarkMagenta	= "032|"
CONSTANT STRING	c_TabCurrentCyan		= "033|"
CONSTANT STRING	c_TabCurrentDarkCyan	= "034|"
CONSTANT STRING	c_TabCurrentYellow	= "035|"
CONSTANT STRING	c_TabCurrentDarkYellow	= "036|"

CONSTANT STRING	c_TabCurrentColorFolder 	= "037|"
CONSTANT STRING	c_TabCurrentColorBorder 	= "038|"
CONSTANT STRING	c_TabCurrentColorTab	= "039|"

CONSTANT STRING	c_TextDisableItalic		= "001|"
CONSTANT STRING	c_TextDisableBold		= "002|"
CONSTANT STRING	c_TextDisableRegular	= "003|"
CONSTANT STRING	c_TextDisableUnderline	= "004|"

CONSTANT STRING	c_TextDisableDarkGray	= "005|"
CONSTANT STRING	c_TextDisableWhite	= "006|"
CONSTANT STRING	c_TextDisableGray		= "007|"
CONSTANT STRING	c_TextDisableBlack		= "008|"
CONSTANT STRING	c_TextDisableRed		= "009|"
CONSTANT STRING	c_TextDisableDarkRed	= "010|"
CONSTANT STRING	c_TextDisableGreen	= "011|"
CONSTANT STRING	c_TextDisableDarkGreen	= "012|"
CONSTANT STRING	c_TextDisableBlue		= "013|"
CONSTANT STRING	c_TextDisableDarkBlue	= "014|"
CONSTANT STRING	c_TextDisableMagenta	= "015|"
CONSTANT STRING	c_TextDisableDarkMagenta	= "016|"
CONSTANT STRING	c_TextDisableCyan		= "017|"
CONSTANT STRING	c_TextDisableDarkCyan	= "018|"
CONSTANT STRING	c_TextDisableYellow	= "019|"
CONSTANT STRING	c_TextDisableDarkYellow	= "020|"

//-----------------------------------------------------------------------------------------
//  Folder Object Instance Variables
//-----------------------------------------------------------------------------------------

STRING			i_TabPos[]
INTEGER		i_TabRows
INTEGER		i_Tabs

INTEGER		i_CurrentTab 		= 0
INTEGER		i_SelectedTab 		= 0
INTEGER		i_ClickedTab		= 0
INTEGER		i_TabError		= 0
STRING			i_SelectedTabName
STRING			i_ClickedTabName
BOOLEAN		i_FolderResize
BOOLEAN		i_PermInvisible

WINDOW		i_SecurityWindow

PRIVATE S_TAB_ARRAY   	i_TabArray[]
end variables

forward prototypes
public subroutine fu_folderresize ()
public subroutine fu_disabletab (integer tab)
public subroutine fu_enabletab (integer tab)
public subroutine fu_hidetab (integer tab)
public subroutine fu_showtab (integer tab)
public subroutine fu_tabkeydown ()
public subroutine fu_folderworkspace (ref integer ws_x, ref integer ws_y, ref integer ws_width, ref integer ws_height)
public function integer fu_centertabobject (dragobject tab_object)
public subroutine fu_foldercreatetb (integer tabs_per_row)
public subroutine fu_foldercreatelr (integer tabs_per_row)
public subroutine fu_assigntab (integer tab, string tab_label, ref windowobject tab_objects[])
public subroutine fu_assigntab (integer tab, string tab_label)
public subroutine fu_assigntab (integer tab, windowobject tab_objects[])
private subroutine fu_buildtab ()
public subroutine fu_disabletabname (string tab_name)
public subroutine fu_enabletabname (string tab_name)
public subroutine fu_foldercreate (integer tabs, integer tabs_per_row)
public subroutine fu_hidetabname (string tab_name)
public function userobject fu_opentab (integer tab, string uo_name)
public function integer fu_selecttab (integer tab)
public function integer fu_selecttabname (string tab_name)
public subroutine fu_showtabname (string tab_name)
public subroutine fu_unassigntabobject (integer tab, ref windowobject tab_object)
public subroutine fu_tabinfo (integer tab, ref string tab_label, ref boolean tab_enabled, ref boolean tab_visible, ref windowobject tab_objects[])
public function string fu_getidentity ()
public subroutine fu_disableall ()
public subroutine fu_enableall ()
private subroutine fu_setoptions (string optionstyle, string options)
public subroutine fu_folderoptions (integer tab_height, string options)
public subroutine fu_tabcurrentoptions (string textfont, integer textsize, string options)
public subroutine fu_tabdisableoptions (string textfont, integer textsize, string options)
public subroutine fu_taboptions (string textfont, integer textsize, string options)
public function userobject fu_opentab (integer tab, string uo_name, powerobject tab_parm)
public function userobject fu_opentab (integer tab, string uo_name, double tab_parm)
public function userobject fu_opentab (integer tab, string uo_name, string tab_parm)
public function integer fu_gettabs ()
public subroutine fu_resettabs (integer tabs)
end prototypes

event po_tabclicked;////******************************************************************
////  PO Module     : u_Folder
////  Event         : po_TabClicked
////  Description   : Provides an opportunity for the developer to
////                  do any processing after a tab is selected.
////
////  Parameters    : INTEGER SelectedTab - 
////                     Number of the tab selected by the user.
////                  STRING  SelectedTabName - 
////                     Name of the tab (without the &) of
////                     the tab selected by the user.
////
////  Return Value  : None.  All tab processing is completed before
////                  this event is triggered.
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
////  Sample code for determining which tab was clicked by the user.
////------------------------------------------------------------------
//
//CHOOSE CASE SelectedTab
//   CASE 1
//      <code>
//   CASE 2
//      <code>
//END CHOOSE
//
////------------------------------------------------------------------
////  Sample code for dynamically creating a user object that contains
////  all the objects for the selected tab.  The variable returned by
////  the fu_OpenTab function should be declared as an instance
////  variable.  The user object will be automatically centered.  If 
////  the user object is already open, then focus will be set.
////------------------------------------------------------------------
//
//CHOOSE CASE SelectedTab
//   CASE 1
//      IF NOT IsValid(<user_object_var1>) THEN
//         <user_object_var1> = fu_OpenTab(SelectedTab, "<user_object1>")
//      ELSE
//         <user_object_var1>.SetFocus()
//      END IF
//   CASE 2
//      IF NOT IsValid(<user_object_var2>) THEN
//         <user_object_var2> = fu_OpenTab(SelectedTab, "<user_object2>")
//      ELSE
//         <user_object_var2>.SetFocus()
//      END IF
//END CHOOSE
end event

event po_tabvalidate;////******************************************************************
////  PO Module     : u_Folder
////  Event         : po_TabValidate
////  Description   : Provides an opportunity for the developer to
////                  do any processing before a tab is selected.
////
////  Parameters    : INTEGER ClickedTab - 
////                     Number of the new tab selected by the user.
////                  STRING  ClickedTabName - 
////                     Name of the tab (without the &) of
////                     the selected tab.
////                  INTEGER SelectedTab - 
////                     Number of the current tab.
////                  STRING  SelectedTabName - 
////                     Name of the tab (without the &) of
////                     the current tab.
////
////  Return Value  : i_TabError -
////                     Indicates if an error has occured in the 
////                     processing of this event.  Set to -1
////                     to stop the new tab from becoming the 
////                     current tab.
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
////  Sample code for validating a DataWindow on the current tab
////  before allowing the new tab to become selected.
////------------------------------------------------------------------
//
//CHOOSE CASE SelectedTab
//   CASE 1
//      IF <datawindow>.AcceptText() = -1 THEN
//         i_TabError = -1
//      END IF
//   CASE 2
//      <code>
//END CHOOSE
end event

event po_identify;//******************************************************************
//  PO Module     : u_Folder
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

public subroutine fu_folderresize ();//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_FolderResize
//  Description   : Responsible for the actual creation of the
//                  folder object.  Called by the fu_FolderCreate
//                  function for initial creation and by the
//                  resize event when the object is resized.  
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

INTEGER l_Width
STRING l_TabSide

l_TabSide = GetItemString(1, "f_side")

IF l_TabSide = "T" OR l_TabSide = "B" THEN
   l_Width = UnitsToPixels(Width, XUnitsToPixels!) - 2
   l_Width = l_Width - Mod(l_Width - &
             ((i_TabRows - 1) * GetItemNumber(1, "t_offset")), &
             GetItemNumber(1, "t_rows"))
   SetItem(1, "f_width", l_Width)
   SetItem(1, "f_height", UnitsToPixels(Height, YUnitsToPixels!) - 2)

   Modify("datawindow.detail.height=" + String(UnitsToPixels(Height, YUnitsToPixels!)))
ELSE
   l_Width = UnitsToPixels(Height, YUnitsToPixels!) - 2
   l_Width = l_Width - Mod(l_Width - &
             ((i_TabRows - 1) * GetItemNumber(1, "t_offset")), &
             GetItemNumber(1, "t_rows"))
   SetItem(1, "f_width", l_Width)
   SetItem(1, "f_height", UnitsToPixels(Width, XUnitsToPixels!) - 2)

   Modify("datawindow.detail.height=" + String(UnitsToPixels(Height, YUnitsToPixels!)))
END IF

IF NOT Visible THEN
   IF NOT i_PermInvisible THEN
      Show()
   END IF
ELSE
   SetReDraw(TRUE)
END IF


end subroutine

public subroutine fu_disabletab (integer tab);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_DisableTab
//  Description   : Disables a tab that had been enabled.  
//
//  Parameters    : INTEGER Tab - 
//                     Tab number.
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

IF Tab = i_SelectedTab THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Set the tab to disable.
//------------------------------------------------------------------

i_TabArray[Tab].TabDisable = TRUE
THIS.fu_BuildTab()

RETURN
end subroutine

public subroutine fu_enabletab (integer tab);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_EnableTab
//  Description   : Enables a tab that had been disabled.  
//
//  Parameters    : INTEGER Tab - 
//                     Tab number.
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

IF Tab = i_SelectedTab THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Set the tab to enable.
//------------------------------------------------------------------

i_TabArray[Tab].TabDisable = FALSE
THIS.fu_BuildTab()

RETURN
end subroutine

public subroutine fu_hidetab (integer tab);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_HideTab
//  Description   : Hides a tab that had been visible.  Can only
//                  hide tabs on folders that have one row of tabs.  
//
//  Parameters    : INTEGER Tab - 
//                     Tab number.
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

STRING  l_HideString

//-------------------------------------------------------------------
//  If the tab is the current tab then return.
//-------------------------------------------------------------------

IF Tab = i_SelectedTab THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Set the tab to invisible.
//------------------------------------------------------------------

l_HideString = GetItemString(1, "t_visible")
IF IsNull(l_HideString) <> FALSE THEN
   l_HideString = ""
END IF

IF Pos(l_HideString, " " + String(tab, "00") + " ") = 0 THEN
   SetItem(1, "t_visible", l_HideString + " " + String(tab, "00") + " ")
   i_TabArray[Tab].TabHide = TRUE
   THIS.fu_BuildTab()
END IF

end subroutine

public subroutine fu_showtab (integer tab);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_ShowTab
//  Description   : Shows a tab that had been previously hidden.  
//
//  Parameters    : INTEGER Tab - 
//                     Tab number.
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

LONG    l_Pos
STRING  l_HideString

//-------------------------------------------------------------------
//  If the tab is the current tab then return.
//-------------------------------------------------------------------

IF Tab = i_SelectedTab THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Set the tab to visible.
//------------------------------------------------------------------

l_HideString = GetItemString(1, "t_visible")
l_Pos = Pos(l_HideString, " " + String(tab, "00") + " ")
IF l_Pos > 0 THEN
   SetItem(1, "t_visible", Replace(l_HideString, l_Pos, 4, " "))
   i_TabArray[Tab].TabHide = FALSE
   THIS.fu_BuildTab()
END IF

RETURN
end subroutine

public subroutine fu_tabkeydown ();//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_TabKeyDown
//  Description   : Processes keyboard input for selecting a tab.  
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

INTEGER l_Idx, l_Pos, l_TabChar, l_Tabs

//------------------------------------------------------------------
//  Cycle through the tabs looking to see if the keyboard input from
//  the user matches any of tabs.  If so, call the fu_SelectTab
//  function to select the tab.
//------------------------------------------------------------------

l_Tabs = GetItemNumber(1, "t_num")
FOR l_Idx = 1 TO l_Tabs
   l_Pos = POS(i_TabArray[l_Idx].TabName, "&")
   IF l_Pos > 0 THEN
      l_TabChar = ASC(UPPER(MID(i_TabArray[l_Idx].TabName, l_Pos + 1, 1)))
      IF KeyDown(l_TabChar) THEN
         THIS.fu_SelectTab(l_Idx)
         EXIT
      END IF
   END IF
NEXT

RETURN


end subroutine

public subroutine fu_folderworkspace (ref integer ws_x, ref integer ws_y, ref integer ws_width, ref integer ws_height);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_FolderWorkSpace
//  Description   : Returns the working area of the folder object.
//                  This may be used by the developer to place
//                  objects on the folder. The values are returned
//                  in PowerBuilder units. 
//
//  Parameters    : INTEGER WS_X - 
//                     Top-left corner of the folder portion of the
//                     object.
//                  INTEGER WS_Y - 
//                     Top-left corner of the folder portion of the
//                     object.
//                  INTEGER WS_WIDTH - 
//                     Width of the folder portion of the object.
//                  INTEGER WS_HEIGHT - 
//                     Height of the folder portion of the object.
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

USEROBJECT l_UserObject
INTEGER    l_X, l_Y
STRING     l_Side

IF Parent.TypeOf() = Window! THEN
   l_X          = X
   l_Y          = Y
ELSE
   l_UserObject = Parent
   l_X          = l_UserObject.X + X
   l_Y          = l_UserObject.Y + Y
END IF

l_Side = GetItemString(1, "f_side")
IF l_Side = "T" OR l_Side = "B" THEN
   WS_X      = l_X + PixelsToUnits(GetItemNumber(1, "f_workx"), XPixelsToUnits!)
   WS_Y      = l_Y + PixelsToUnits(GetItemNumber(1, "f_worky"), YPixelsToUnits!)
   WS_Width  = PixelsToUnits(GetItemNumber(1, "f_workwidth"), XPixelsToUnits!)
   WS_Height = PixelsToUnits(GetItemNumber(1, "f_workheight"), YPixelsToUnits!)
ELSE
   WS_X      = l_X + PixelsToUnits(GetItemNumber(1, "f_worky"), XPixelsToUnits!)
   WS_Y      = l_Y + PixelsToUnits(GetItemNumber(1, "f_workx"), YPixelsToUnits!)
   WS_Width  = PixelsToUnits(GetItemNumber(1, "f_workheight"), XPixelsToUnits!)
   WS_Height = PixelsToUnits(GetItemNumber(1, "f_workwidth"), YPixelsToUnits!)
END IF
end subroutine

public function integer fu_centertabobject (dragobject tab_object);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_CenterTabObject
//  Description   : Centers the given window object on the folder. 
//
//  Parameters    : DRAGOBJECT Tab_Object - 
//                     The object to center.
//
//  Return Value  : INTEGER -
//                     0 = object centered.
//                    -1 = object too large to center.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_FolderX, l_FolderY, l_FolderWidth, l_FolderHeight, l_Jdx
INTEGER l_ObjectWidth, l_ObjectHeight, l_X, l_Y, l_Return, l_Idx
INTEGER l_NumControls
BOOLEAN l_Finished, l_Found
USEROBJECT l_UserObject

l_ObjectWidth  = tab_object.Width
l_ObjectHeight = tab_object.Height

l_X            = X + PixelsToUnits(GetItemNumber(1, "f_workx"), XPixelsToUnits!)
l_Y            = Y + PixelsToUnits(GetItemNumber(1, "f_worky"), YPixelsToUnits!)
l_FolderWidth  = PixelsToUnits(GetItemNumber(1, "f_workwidth"), XPixelsToUnits!)
l_FolderHeight = PixelsToUnits(GetItemNumber(1, "f_workheight"), YPixelsToUnits!)

IF Parent.TypeOf() = Window! THEN
   l_FolderX = l_X
   l_FolderY = l_Y
ELSE
   l_UserObject = Parent
   l_Found = FALSE
   l_NumControls = UpperBound(l_UserObject.Control[])
   FOR l_Idx = 1 TO l_NumControls
      IF l_UserObject.Control[l_Idx] = tab_object THEN
         l_Found = TRUE
         EXIT
      END IF
   NEXT

   IF l_Found THEN
      l_FolderX = l_X
      l_FolderY = l_Y
   ELSE
      l_FolderX = l_UserObject.X + l_X
      l_FolderY = l_UserObject.Y + l_Y
   END IF
END IF

IF l_ObjectWidth > l_FolderWidth THEN
   l_X = l_FolderX
   l_Return = -1
ELSE
   l_X = ((l_FolderWidth - l_ObjectWidth) / 2) + l_FolderX
END IF

IF l_ObjectHeight > l_FolderHeight THEN
   l_Y = l_FolderY
   l_Return = -1
ELSE
   l_Y = ((l_FolderHeight - l_ObjectHeight) / 2) + l_FolderY
END IF

l_Finished = FALSE
FOR l_Idx = 1 TO i_Tabs
   IF i_TabArray[l_Idx].TabNumObjects > 0 THEN
      FOR l_Jdx = 1 TO i_TabArray[l_Idx].TabNumObjects
         IF i_TabArray[l_Idx].TabObjects[l_Jdx] = tab_object THEN
            i_TabArray[l_Idx].TabObjectCentered[l_Jdx] = TRUE
            l_Finished = TRUE
            EXIT
         END IF
      NEXT

      IF l_Finished THEN
         EXIT
      END IF
   END IF
NEXT

tab_object.Move(l_X, l_Y)

tab_object.BringToTop = TRUE

RETURN l_Return
end function

public subroutine fu_foldercreatetb (integer tabs_per_row);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_FolderCreateTB
//  Description   : Creates extra tabs and rows for the folder when
//                  tabs are on the top or bottom.  
//
//  Parameters    : INTEGER Tabs_Per_Row - 
//                     Number of tabs per row.
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

STRING     l_TabN, l_TabS, l_Text, l_Fill, l_ROut, l_TOut, l_TIn
STRING     l_RIn, l_LOut, l_LIn, l_RowN, l_Rect
INTEGER    l_Idx, l_NumRows, l_TotalTabs

//------------------------------------------------------------------
//  Determine if more than 12 tabs are needed.
//------------------------------------------------------------------

l_TotalTabs = GetItemNumber(1, "t_tnum")
IF l_TotalTabs > 12 THEN
   FOR l_Idx = 13 to l_TotalTabs
      l_TabN = String(l_Idx)
      l_TabS = String(l_Idx, "00")
      l_Rect = "create rectangle(name=tab" + l_TabN + "_rect band=detail pen.style=~"0~" " + &
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, if(mid(t_pos,(" + l_TabN + " - 1) * 8 + 8, 1) = 'Y', d_bcolor, t_bcolor))~" " + & 
               "brush.hatch=~"6~" brush.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, if(mid(t_pos,(" + l_TabN + " - 1) * 8 + 8, 1) = 'Y', d_bcolor, t_bcolor))~" " + & 
               "background.mode=~"2~" background.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, if(mid(t_pos,(" + l_TabN + " - 1) * 8 + 8, 1) = 'Y', d_bcolor, t_bcolor))~" " + &
               "x=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 2~" " + & 
               "y=~"0~tif(f_side = 'T', t_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) + 4, if(ceiling(" + l_TabN + " / t_rows) > 1, t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) + 1, if(t_current = " + l_TabN + ", if(f_border = 'Y' and f_style = '3D', t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) - 2, t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height)), t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) + 1)))~" " + &
               "height=~"0~tif(ceiling(" + l_TabN + " / t_rows) > 1, t_height - 4, if(t_current = " + l_TabN + ", if(f_border = 'Y' and f_style = '3D', t_height - 1, t_height - 3), t_height - 4))~" " + & 
               "width=~"0~tt_width - 2~" ) "
      l_Text = "create text(name=tab" + l_TabN + "_text band=detail text=~" ~tmid(t_label,integer(mid(t_pos, (" + l_TabN + " - 1) * 9 + 4, 3)), integer(mid(t_pos, (" + l_TabN + " - 1) * 9 + 7, 2)) )~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "border=~"0~" alignment=~"2~tt_align~" " + & 
               "background.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_bcolor, t_bcolor))~" " + &
               "color=~"0~tif(t_current = " + l_TabN + ", c_color, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_color, t_color))~" " + & 
               "font.height=~"0~tif(t_current = " + l_TabN + ", c_size * -1, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_size * -1, t_size * -1))~" " + & 
               "font.face=~"Tahoma~tif(t_current = " + l_TabN + ", c_font, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_font, t_font))~" " + & 
               "font.family=~"2~tif(t_current = " + l_TabN + ", c_family, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_family, t_family))~" " + & 
               "font.pitch=~"2~tif(t_current = " + l_TabN + ", c_pitch, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_pitch, t_pitch))~" " + & 
               "font.charset=~"0~tif(t_current = " + l_TabN + ", c_charset, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_charset, t_charset))~" " + &   
               "font.weight=~"0~tif(t_current = " + l_TabN + ", if(c_style='bold', 700, 400), if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', if(d_style='bold', 700, 400), if(t_style='bold', 700, 400)))~" " + & 
               "font.italic=~"0~tif(t_current = " + l_TabN + ", if(c_style='italic', 1, 0), if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', if(d_style='italic', 1, 0), if(t_style='italic', 1, 0)))~" " + & 
               "font.underline=~"0~tif(t_current = " + l_TabN + ", if(c_style='underline', 1, 0), if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', if(d_style='underline', 1, 0), if(t_style='underline', 1, 0)))~" " + & 
               "x=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 3~" " + & 
               "y=~"0~tif(f_side = 'T', t_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) + 4, t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) + 1)~" " + & 
               "height=~"0~tt_height - 4~" " + & 
               "width=~"0~tt_width - 4~" ) "
      l_Fill = "create line(name=tab" + l_TabN + "_fill1 band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, t_bcolor)~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 3~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (2 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 3~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (2 * f_direct)~" ) " + &
               "create line(name=tab" + l_TabN + "_fill2 band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, t_bcolor)~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 2~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (3 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 2~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (3 * f_direct)~" ) "
      l_LOut = "create line(name=tab" + l_TabN + "_left_out band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) * f_direct~" ) " + &
               "create line(name=tab" + l_TabN + "_leftc_out band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 4~" " + & 
               "y2=~"0~tt_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct~" ) "
      l_TOut = "create line(name=tab" + l_TabN + "_top_out band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 4~" " + & 
               "y1=~"0~tt_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 3~" " + & 
               "y2=~"0~tt_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct~" ) "
      l_ROut = "create line(name=tab" + l_TabN + "_rightc_out band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 4~" " + & 
               "y1=~"0~tt_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" ) " + &
               "create line(name=tab" + l_TabN + "_right_out band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) * f_direct~" ) "
      l_LIn  = "create line(name=tab" + l_TabN + "_left_in band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', 16777215, if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 1~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 1~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) * f_direct~" ) " + &
               "create line(name=tab" + l_TabN + "_leftc_in band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', 16777215, if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 1~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 4~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (1 * f_direct)~" ) "
      l_TIn  = "create line(name=tab" + l_TabN + "_top_in band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', if(f_side = 'T', 16777215, f_shade), if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 4~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (1 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 3~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (1 * f_direct)~" ) "
      l_RIn  = "create line(name=tab" + l_TabN + "_rightc_in band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', f_shade, if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 3~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (2 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 1~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" ) " + &
               "create line(name=tab" + l_TabN + "_right_in band=detail background.color=~"12632256~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', f_shade, if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + & 
               "x1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 1~" " + & 
               "y1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + & 
               "x2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 1~" " + & 
               "y2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) * f_direct~" )"

      Modify(l_Rect + l_Text + l_Fill + l_LOut + l_TOut + l_ROut + l_LIn + l_TIn + l_RIn)
   NEXT
END IF

//------------------------------------------------------------------
//  Determine if more than two rows are needed.
//------------------------------------------------------------------

l_NumRows = Ceiling(i_Tabs / tabs_per_row)
IF l_NumRows > 3 THEN
   FOR l_Idx = 4 TO l_NumRows
      l_RowN = String(l_Idx)
      Modify("create line(name=row" + l_RowN + "_right_out band=detail background.color=~"12632256~" " + & 
             "pen.width=~"1~" pen.color=~"0~" " + &
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + & 
             "x1=~"0~tt_rows * t_width + (" + l_RowN + " - 1) * t_offset~" " + & 
             "y1=~"0~tif(f_side = 'T', t_theight - ((" + l_RowN + " - 1) * t_height), t_theight + ((" + l_RowN + " - 1) * t_height))~" " + & 
             "x2=~"0~tt_rows * t_width + (" + l_RowN + " - 1) * t_offset~" " + & 
             "y2=~"0~tif(f_side = 'T', f_height - (" + l_RowN + " - 1) * t_offset, (" + l_RowN + " - 1) * t_offset)~" ) " + &
             "create line(name=row" + l_RowN + "_right_in band=detail background.color=~"12632256~" " + & 
             "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', f_shade, f_color)~" " + & 
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + & 
             "x1=~"0~tt_rows * t_width + (" + l_RowN + " - 1) * t_offset - 1~" " + & 
             "y1=~"0~tif(f_side = 'T', t_theight - ((" + l_RowN + " - 1) * t_height), t_theight + ((" + l_RowN + " - 1) * t_height))~" " + & 
             "x2=~"0~tt_rows * t_width + (" + l_RowN + " - 1) * t_offset - 1~" " + & 
             "y2=~"0~tif(f_side = 'T', f_height - (" + l_RowN + " - 1) * t_offset - 1, (" + l_RowN + " - 1) * t_offset + 1)~" ) " + &
             "create line(name=row" + l_RowN + "_bottom_out band=detail background.color=~"12632256~" " + & 
             "pen.width=~"1~" pen.color=~"0~" " + & 
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + & 
             "x1=~"0~tf_width - ((ceiling(t_num / t_rows) - (" + l_RowN + " - 1)) * t_offset) + 1~" " + & 
             "y1=~"0~tif(f_side = 'T', f_height - (" + l_RowN + " - 1) * t_offset, (" + l_RowN + " -1) * t_offset)~" " + & 
             "x2=~"0~tf_width - (ceiling(t_num / t_rows) - (" + l_RowN + " - 0)) * t_offset~" " + & 
             "y2=~"0~tif(f_side = 'T', f_height - (" + l_RowN + " - 1) * t_offset, (" + l_RowN + " - 1) * t_offset)~" ) " + &
             "create line(name=row" + l_RowN + "_bottom_in band=detail background.color=~"12632256~" " + & 
             "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', if(f_side = 'T', f_shade, 16777215), f_color)~" " + & 
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + & 
             "x1=~"0~tf_width - ((ceiling(t_num / t_rows) - (" + l_RowN + " - 1)) * t_offset) + 1~" " + & 
             "y1=~"0~tif(f_side = 'T', f_height - ((" + l_RowN + " - 1) * t_offset) - 1, ((" + l_RowN + " - 1) * t_offset) + 1)~" " + & 
             "x2=~"0~tf_width - (ceiling(t_num / t_rows) - (" + l_RowN + " - 0)) * t_offset~" " + & 
             "y2=~"0~tif(f_side = 'T', f_height - ((" + l_RowN + " - 1) * t_offset) - 1, ((" + l_RowN + " - 1) * t_offset) + 1)~" ) " + &
             "create line(name=row" + l_RowN + "_top_out band=detail background.color=~"12632256~" " + & 
             "pen.width=~"1~" pen.color=~"0~" " + & 
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'N', 1, 0)~" " + & 
             "x1=~"0~tf_width - ((ceiling(t_num / t_rows) - (" + l_RowN + " - 1)) * t_offset) - 4~" " + & 
             "y1=~"0~tt_theight - ((" + l_RowN + " - 1) * t_height) * f_direct~" " + & 
             "x2=~"0~tf_width - (ceiling(t_num / t_rows) - (" + l_RowN + " - 0)) * t_offset + 1~" " + & 
             "y2=~"0~tt_theight - ((" + l_RowN + " - 1) * t_height) * f_direct~" ) " + &
             "create rectangle(name=row" + l_RowN + "_folder band=detail " + &
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + & 
             "pen.style=~"0~" pen.width=~"1~" " + & 
             "pen.color=~"0~tf_color~" " + & 
             "brush.hatch=~"6~" brush.color=~"0~tf_color~" " + & 
             "background.mode=~"2~" background.color=~"0~tf_color~" " + & 
             "x=~"0~tf_width - ((ceiling(t_num / t_rows) - (" + l_RowN + " - 1)) * t_offset) + 1~" " + & 
             "y=~"0~tif(f_side = 'T', t_theight - (" + l_RowN + " * t_height) + t_height, ((" + l_RowN + " - 1) * t_offset) + 2)~" " + & 
             "height=~"0~tif(f_side = 'T', f_height - t_theight + ((" + l_RowN + " - 1) * t_height) - ((" + l_RowN + " - 1) * t_offset) - 1, t_theight + ((" + l_RowN + " - 1) * t_height) - ((" + l_RowN + " - 1) * t_offset) - 1)~" " + & 
             "width=~"0~tt_offset - 2~" ) ")
   NEXT
END IF

end subroutine

public subroutine fu_foldercreatelr (integer tabs_per_row);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_FolderCreateLR
//  Description   : Creates extra tabs and rows for the folder when
//                  tabs are on the left or right.
//
//  Parameters    : INTEGER Tabs_Per_Row - 
//                     Number of tabs per row.
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

STRING     l_TabN, l_TabS, l_Text, l_Fill, l_ROut, l_TOut, l_TIn
STRING     l_RIn, l_LOut, l_LIn, l_RowN, l_Rect
INTEGER    l_Idx, l_NumRows, l_TotalTabs

//------------------------------------------------------------------
//  Determine if more than 12 tabs are needed.
//------------------------------------------------------------------

l_TotalTabs = GetItemNumber(1, "t_tnum")
IF l_TotalTabs > 12 THEN
   FOR l_Idx = 13 to l_TotalTabs
      l_TabN = String(l_Idx)
      l_TabS = String(l_Idx, "00")
      l_Rect = "create rectangle(name=tab" + l_TabN + "_rect band=detail pen.style=~"0~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + &
               "pen.width=~"1~" pen.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, if(mid(t_pos,(" + l_TabN + " - 1) * 8 + 8, 1) = 'Y', d_bcolor, t_bcolor))~" " + &  
               "brush.hatch=~"6~" brush.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, if(mid(t_pos,(" + l_TabN + " - 1) * 8 + 8, 1) = 'Y', d_bcolor, t_bcolor))~" " + &  
               "background.mode=~"2~" background.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, if(mid(t_pos,(" + l_TabN + " - 1) * 8 + 8, 1) = 'Y', d_bcolor, t_bcolor))~" " + & 
               "y=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 2~" " + &  
               "x=~"0~tif(f_side = 'L', t_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) + 4, if(ceiling(" + l_TabN + " / t_rows) > 1, t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) + 1, if(t_current = " + l_TabN + ", if(f_border = 'Y' and f_style = '3D', t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) - 2, t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height)), t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) + 1)))~" " + &  
               "width=~"0~tif(ceiling(" + l_TabN + " / t_rows) > 1, t_height - 4, if(t_current = " + l_TabN + ", if(f_border = 'Y' and f_style = '3D', t_height - 1, t_height - 3), t_height - 4))~" " + &  
               "height=~"0~tt_width - 2~" ) "
      l_Text = "create text(name=tab" + l_TabN + "_text band=detail text=~" ~tmid(t_label,integer(mid(t_pos, (" + l_TabN + " - 1) * 9 + 4, 3)), integer(mid(t_pos, (" + l_TabN + " - 1) * 9 + 7, 2)) )~" " + & 
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "border=~"0~" alignment=~"2~tt_align~" " + &  
               "background.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_bcolor, t_bcolor))~" " + & 
               "color=~"0~tif(t_current = " + l_TabN + ", c_color, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_color, t_color))~" " + &  
               "font.escapement=~"0~tif(t_rotate = 'N', if(f_side = 'L', 900, 2700), 0)~" " + & 
               "font.height=~"0~tif(t_current = " + l_TabN + ", c_size * -1, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_size * -1, t_size * -1))~" " + &  
               "font.face=~"Tahoma~tif(t_current = " + l_TabN + ", c_font, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_font, t_font))~" " + & 
               "font.family=~"2~tif(t_current = " + l_TabN + ", c_family, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_family, t_family))~" " + &  
               "font.pitch=~"2~tif(t_current = " + l_TabN + ", c_pitch, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_pitch, t_pitch))~" " + &  
               "font.charset=~"0~tif(t_current = " + l_TabN + ", c_charset, if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', d_charset, t_charset))~" " + &   
               "font.weight=~"0~tif(t_current = " + l_TabN + ", if(c_style='bold', 700, 400), if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', if(d_style='bold', 700, 400), if(t_style='bold', 700, 400)))~" " + &  
               "font.italic=~"0~tif(t_current = " + l_TabN + ", if(c_style='italic', 1, 0), if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', if(d_style='italic', 1, 0), if(t_style='italic', 1, 0)))~" " + &  
               "font.underline=~"0~tif(t_current = " + l_TabN + ", if(c_style='underline', 1, 0), if(mid(t_pos,(" + l_TabN + " - 1) * 9 + 9, 1) = 'Y', if(d_style='underline', 1, 0), if(t_style='underline', 1, 0)))~" " + &  
               "y=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + t_yrotate~" " + &  
               "x=~"0~tif(f_side = 'L', t_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) + t_xrotate, t_theight + ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) + t_xrotate)~" " + &  
               "height=~"0~tif(t_rotate = 'N', 1, t_size + 4)~" " + &  
               "width=~"0~tif(t_rotate = 'N', t_width - 2, t_height - 4)~" ) "
      l_Fill = "create line(name=tab" + l_TabN + "_fill1 band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, t_bcolor)~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 3~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (2 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 3~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (2 * f_direct)~" ) " + & 
               "create line(name=tab" + l_TabN + "_fill2 band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~tif(t_current = " + l_TabN + ", c_bcolor, t_bcolor)~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 2~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (3 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 2~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (3 * f_direct)~" ) "
      l_LOut = "create line(name=tab" + l_TabN + "_left_out band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) * f_direct~" ) " + & 
               "create line(name=tab" + l_TabN + "_leftc_out band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 4~" " + &  
               "x2=~"0~tt_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct~" ) "
      l_TOut = "create line(name=tab" + l_TabN + "_top_out band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 4~" " + &  
               "x1=~"0~tt_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 3~" " + &  
               "x2=~"0~tt_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct~" ) "
      l_ROut = "create line(name=tab" + l_TabN + "_rightc_out band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 4~" " + &  
               "x1=~"0~tt_theight - (ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" ) " + & 
               "create line(name=tab" + l_TabN + "_right_out band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) * f_direct~" ) "
      l_LIn  = "create line(name=tab" + l_TabN + "_left_in band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', 16777215, if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 1~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 1~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) * f_direct~" ) " + & 
               "create line(name=tab" + l_TabN + "_leftc_in band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', 16777215, if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 1~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 4~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (1 * f_direct)~" ) "
      l_TIn  = "create line(name=tab" + l_TabN + "_top_in band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', if(f_side = 'L', 16777215, f_shade), if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 0) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset + 4~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (1 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 3~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (1 * f_direct)~" ) "
      l_RIn  = "create line(name=tab" + l_TabN + "_rightc_in band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', f_shade, if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 3~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (2 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 1~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" ) " + & 
               "create line(name=tab" + l_TabN + "_right_in band=detail background.color=~"12632256~" " + &  
               "visible=~"0~tif(t_tnum < " + l_TabN + " or (pos(t_visible,' " + l_TabS + " ') > 0 and (t_num / t_rows) <= 1), 0, 1)~" " + & 
               "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', f_shade, if(t_current = " + l_TabN + ", c_bcolor, t_bcolor))~" " + &  
               "y1=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 1~" " + &  
               "x1=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) * t_height) * f_direct) + (4 * f_direct)~" " + &  
               "y2=~"0~t(mod(" + l_TabN + " - 1,t_rows) + 1) * t_width + (ceiling(" + l_TabN + " / t_rows) - 1) * t_offset - 1~" " + &  
               "x2=~"0~tt_theight - ((ceiling(" + l_TabN + " / t_rows) - 1) * t_height) * f_direct~" ) "

      Modify(l_Rect + l_Text + l_Fill + l_LOut + l_TOut + l_ROut + l_LIn + l_TIn + l_RIn)
   NEXT
END IF

//------------------------------------------------------------------
//  Determine if more than two rows are needed.
//------------------------------------------------------------------

l_NumRows = Ceiling(i_Tabs / tabs_per_row)
IF l_NumRows > 3 THEN
   FOR l_Idx = 4 TO l_NumRows
      l_RowN = String(l_Idx)
      Modify("create line(name=row" + l_RowN + "_right_out band=detail background.color=~"12632256~" " + & 
             "pen.width=~"1~" pen.color=~"0~" " + & 
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + &  
             "y1=~"0~tt_rows * t_width + (" + l_RowN + " - 1) * t_offset~" " + &  
             "x1=~"0~tif(f_side = 'L', t_theight - ((" + l_RowN + " - 1) * t_height), t_theight + ((" + l_RowN + " - 1) * t_height))~" " + &  
             "y2=~"0~tt_rows * t_width + (" + l_RowN + " - 1) * t_offset~" " + &  
             "x2=~"0~tif(f_side = 'L', f_height - (" + l_RowN + " - 1) * t_offset, (" + l_RowN + " - 1) * t_offset)~" ) " + & 
             "create line(name=row" + l_RowN + "_right_in band=detail background.color=~"12632256~" " + & 
             "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', f_shade, f_color)~" " + &  
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + &  
             "y1=~"0~tt_rows * t_width + (" + l_RowN + " - 1) * t_offset - 1~" " + &  
             "x1=~"0~tif(f_side = 'L', t_theight - ((" + l_RowN + " - 1) * t_height), t_theight + ((" + l_RowN + " - 1) * t_height))~" " + &  
             "y2=~"0~tt_rows * t_width + (" + l_RowN + " - 1) * t_offset - 1~" " + &  
             "x2=~"0~tif(f_side = 'L', f_height - (" + l_RowN + " - 1) * t_offset - 1, (" + l_RowN + " - 1) * t_offset + 1)~" ) " + & 
             "create line(name=row" + l_RowN + "_bottom_out band=detail background.color=~"12632256~" " + &  
             "pen.width=~"1~" pen.color=~"0~" " + &  
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + &  
             "y1=~"0~tf_width - ((ceiling(t_num / t_rows) - (" + l_RowN + " - 1)) * t_offset) + 1~" " + &  
             "x1=~"0~tif(f_side = 'L', f_height - (" + l_RowN + " - 1) * t_offset, (" + l_RowN + " -1) * t_offset)~" " + &  
             "y2=~"0~tf_width - (ceiling(t_num / t_rows) - (" + l_RowN + " - 0)) * t_offset~" " + &  
             "x2=~"0~tif(f_side = 'L', f_height - (" + l_RowN + " - 1) * t_offset, (" + l_RowN + " - 1) * t_offset)~" ) " + & 
             "create line(name=row" + l_RowN + "_bottom_in band=detail background.color=~"12632256~" " + &  
             "pen.width=~"1~" pen.color=~"0~tif(f_style='3D', if(f_side = 'L', f_shade, 16777215), f_color)~" " + &  
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + &  
             "y1=~"0~tf_width - ((ceiling(t_num / t_rows) - (" + l_RowN + " - 1)) * t_offset) + 1~" " + &  
             "x1=~"0~tif(f_side = 'L', f_height - ((" + l_RowN + " - 1) * t_offset) - 1, ((" + l_RowN + " - 1) * t_offset) + 1)~" " + &  
             "y2=~"0~tf_width - (ceiling(t_num / t_rows) - (" + l_RowN + " - 0)) * t_offset~" " + &  
             "x2=~"0~tif(f_side = 'L', f_height - ((" + l_RowN + " - 1) * t_offset) - 1, ((" + l_RowN + " - 1) * t_offset) + 1)~" ) " + & 
             "create line(name=row" + l_RowN + "_top_out band=detail background.color=~"12632256~" " + &  
             "pen.width=~"1~" pen.color=~"0~" " + &  
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'N', 1, 0)~" " + &  
             "y1=~"0~tf_width - ((ceiling(t_num / t_rows) - (" + l_RowN + " - 1)) * t_offset) - 4~" " + &  
             "x1=~"0~tt_theight - ((" + l_RowN + " - 1) * t_height) * f_direct~" " + &  
             "y2=~"0~tf_width - (ceiling(t_num / t_rows) - (" + l_RowN + " - 0)) * t_offset + 1~" " + &  
             "x2=~"0~tt_theight - ((" + l_RowN + " - 1) * t_height) * f_direct~" ) " + & 
             "create rectangle(name=row" + l_RowN + "_folder band=detail " + & 
             "visible=~"0~tif(ceiling(t_num / t_rows) > (" + l_RowN + " - 1) and f_border = 'Y', 1, 0)~" " + &  
             "pen.style=~"0~" pen.width=~"1~" " + &  
             "pen.color=~"0~tf_color~" " + &  
             "brush.hatch=~"6~" brush.color=~"0~tf_color~" " + &  
             "background.mode=~"2~" background.color=~"0~tf_color~" " + &  
             "y=~"0~tf_width - ((ceiling(t_num / t_rows) - (" + l_RowN + " - 1)) * t_offset) + 1~" " + &  
             "x=~"0~tif(f_side = 'L', t_theight - (" + l_RowN + " * t_height) + t_height, ((" + l_RowN + " - 1) * t_offset) + 2)~" " + &  
             "width=~"0~tif(f_side = 'L', f_height - t_theight + ((" + l_RowN + " - 1) * t_height) - ((" + l_RowN + " - 1) * t_offset) - 1, t_theight + ((" + l_RowN + " - 1) * t_height) - ((" + l_RowN + " - 1) * t_offset) - 1)~" " + &  
             "height=~"0~tt_offset - 2~" ) ")
   NEXT
END IF

end subroutine

public subroutine fu_assigntab (integer tab, string tab_label, ref windowobject tab_objects[]);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_AssignTab
//  Description   : Assigns a label and window objects to a tab.
//
//  Parameters    : INTEGER      Tab - 
//                     Tab number.
//                  STRING       Tab_Label - 
//                     Tab label.
//                  WINDOWOBJECT Tab_Objects[] - 
//                     Array of window objects.
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

INTEGER l_Idx
BOOLEAN l_Visible, l_Enabled, l_DragDrop

//------------------------------------------------------------------
//  Assign the tab label and the window objects to the tab.
//  Hide each of the window objects.  
//------------------------------------------------------------------

i_TabArray[Tab].TabNumObjects = UpperBound(Tab_Objects[])
i_TabArray[Tab].TabName = Tab_Label
FOR l_Idx = 1 TO i_TabArray[Tab].TabNumObjects
   i_TabArray[Tab].TabObjects[l_Idx]        = Tab_Objects[l_Idx]
   i_TabArray[Tab].TabObjectCentered[l_Idx] = FALSE
	i_TabArray[Tab].TabObjectSecured[l_Idx] = FALSE
	IF IsValid(SECCA.MGR) THEN
		SECCA.MGR.DYNAMIC fu_GetObjectSecurity(i_SecurityWindow, &
		                               Tab_Objects[l_Idx], &
		                               l_Visible, &
												 l_Enabled, &
												 l_DragDrop)
		IF NOT l_Visible THEN
			i_TabArray[Tab].TabObjectSecured[l_Idx] = TRUE
		END IF
	END IF
   i_TabArray[Tab].TabHide    = FALSE
   i_TabArray[Tab].TabDisable = FALSE
   IF i_SelectedTab = Tab THEN
      Tab_Objects[l_Idx].Visible = TRUE
   ELSE        
      Tab_Objects[l_Idx].Visible = FALSE
   END IF
NEXT

end subroutine

public subroutine fu_assigntab (integer tab, string tab_label);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_AssignTab
//  Description   : Assigns a label to a tab.  
//
//  Parameters    : INTEGER Tab - 
//                     Tab number.
//                  STRING  Tab_Label - 
//                     Tab label.
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
//  Assign the label to the tab.  
//------------------------------------------------------------------

i_TabArray[Tab].TabName    = Tab_Label
i_TabArray[Tab].TabHide    = FALSE
i_TabArray[Tab].TabDisable = FALSE



end subroutine

public subroutine fu_assigntab (integer tab, windowobject tab_objects[]);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_AssignTab
//  Description   : Assigns window objects to a tab.  
//
//  Parameters    : INTEGER      Tab - 
//                     Tab number.
//                  WINDOWOBJECT Tab_Objects[] - 
//                     Array of window objects.
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

INTEGER l_Idx
BOOLEAN l_Visible, l_Enabled, l_DragDrop

//------------------------------------------------------------------
//  Assign the window objects to the tab. Hide each of the window 
//  objects.
//------------------------------------------------------------------

i_TabArray[Tab].TabNumObjects = UpperBound(Tab_Objects[])
FOR l_Idx = 1 To i_TabArray[Tab].TabNumObjects
   i_TabArray[Tab].TabObjects[l_Idx] = Tab_Objects[l_Idx]
   i_TabArray[Tab].TabObjectCentered[l_Idx] = FALSE
	i_TabArray[Tab].TabObjectSecured[l_Idx] = FALSE
	IF IsValid(SECCA.MGR) THEN
		SECCA.MGR.DYNAMIC fu_GetObjectSecurity(i_SecurityWindow, &
		                                       Tab_Objects[l_Idx], &
		                                       l_Visible, &
												         l_Enabled, &
												         l_DragDrop)
		IF NOT l_Visible THEN
			i_TabArray[Tab].TabObjectSecured[l_Idx] = TRUE
		END IF
	END IF
   IF i_SelectedTab = Tab THEN
      Tab_Objects[l_Idx].Visible = TRUE
   ELSE        
      Tab_Objects[l_Idx].Visible = FALSE
   END IF
NEXT

end subroutine

private subroutine fu_buildtab ();//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_BuildTab
//  Description   : Creates the string for the tab labels.  
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

STRING     l_TabPosRow, l_TabPos, l_TabPosTotal, l_TabLabel, l_Name
STRING     l_TmpPos, l_TmpTabPos[], l_HideString, l_Disable
INTEGER    l_Tab, l_Idx, l_TotalTabs, l_TabsPerRow
INTEGER    l_SelectedTab, l_SelectedRow

l_TotalTabs    = GetItemNumber(1, "t_tnum")
l_TabsPerRow   = GetItemNumber(1, "t_rows")
l_TabLabel     = ""
l_TabPosRow    = ""
l_TabPosTotal  = ""
i_TabRows      = 0

//------------------------------------------------------------------
//  Build the tab label string.
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_TotalTabs
   l_Disable = "N"
   IF l_Idx <= i_Tabs THEN
      IF NOT i_TabArray[l_Idx].TabHide THEN
         l_Name = i_TabArray[l_Idx].TabName
      ELSE
         l_Name = " "
      END IF
      IF i_TabArray[l_Idx].TabDisable THEN
         l_Disable = "Y"
      END IF
   ELSE
      l_Name = " "
   END IF

   l_TabPos      = "|" + String(l_Idx, "00") + &
                   String(Len(l_TabLabel) + 1, "000") + &
                   String(Len(l_Name), "00") + l_Disable
   l_TabPosRow   = l_TabPosRow + l_TabPos
   l_TabPosTotal = l_TabPosTotal + l_TabPos
   l_TabLabel    = l_TabLabel + l_Name
   l_Tab         = l_Tab + 1
   IF Mod(l_Tab, l_TabsPerRow) = 0 THEN
      i_TabRows = i_TabRows + 1
      i_TabPos[i_TabRows] = l_TabPosRow
      l_TabPosRow = ""
      l_Tab       = 0
   END IF
NEXT

//------------------------------------------------------------------
//  Shuffle the tab rows in the correct order.
//------------------------------------------------------------------

l_SelectedTab = GetItemNumber(1, "t_select")
IF l_SelectedTab > 0 AND i_TabRows > 1 THEN
   l_SelectedRow = Ceiling(Pos(l_TabPosTotal, &
                   "|" + String(l_SelectedTab, "00")) / Len(i_TabPos[1]))
   IF l_SelectedRow > 1 THEN
      l_TmpPos = ""
      FOR l_Idx = 1 TO i_TabRows
         l_TmpPos = l_TmpPos + i_TabPos[l_SelectedRow]
         l_TmpTabPos[l_Idx] = i_TabPos[l_SelectedRow]
         l_SelectedRow = l_SelectedRow + 1
         IF l_SelectedRow > i_TabRows THEN
            l_SelectedRow = 1
         END IF
      NEXT
      i_TabPos[] = l_TmpTabPos[]
      SetItem(1, "t_pos", l_TmpPos)
   ELSE
      SetItem(1, "t_pos", l_TabPosTotal)
   END IF
ELSE
   SetItem(1, "t_pos", l_TabPosTotal)  
END IF

SetItem(1, "t_label", l_TabLabel)

//------------------------------------------------------------------
//  If there is only one row of tabs, hide any filler tabs.
//------------------------------------------------------------------

IF i_TabRows = 1 AND i_Tabs < l_TabsPerRow THEN
   l_HideString = GetItemString(1, "t_visible")
   IF IsNull(l_HideString) <> FALSE THEN
      l_HideString = ""
   END IF

   FOR l_Idx = i_Tabs + 1 TO l_TabsPerRow
      IF Pos(l_HideString, " " + String(l_Idx, "00") + " ") = 0 THEN
         l_HideString = l_HideString + " " + String(l_Idx, "00") + " "
      END IF
   NEXT

   SetItem(1, "t_visible", l_HideString)
END IF

RETURN
end subroutine

public subroutine fu_disabletabname (string tab_name);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_DisableTabName
//  Description   : Disables a tab that had been enabled.  The tab
//                  is specified by the tab label instead of the
//                  tab number.  
//
//  Parameters    : INTEGER Tab_Name - 
//                     Tab label.
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

INTEGER l_Idx, l_Pos, l_Tabs
STRING  l_TabName

//------------------------------------------------------------------
//  Cycle through the tabs looking for the tab to disable.  Use the
//  tab label after stripping the '&'.  After finding the tab, call
//  the fu_DisableTab function to do the actual disabling.
//------------------------------------------------------------------

l_Tabs = GetItemNumber(1, "t_num")
FOR l_Idx = 1 to l_Tabs
   l_Pos = POS(i_TabArray[l_Idx].TabName, "&")
   IF l_Pos > 0 THEN
      l_TabName = Replace(i_TabArray[l_Idx].TabName, l_Pos, 1, "")
   ELSE
      l_TabName = i_TabArray[l_Idx].TabName
   END IF
	IF Tab_Name = l_TabName THEN
		THIS.fu_DisableTab(l_Idx)
		RETURN
	END IF
NEXT

RETURN
end subroutine

public subroutine fu_enabletabname (string tab_name);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_EnableTabname
//  Description   : Enables a tab that had been disabled.  The tab
//                  is specified by  the tab label instead of the
//                  tab number.  
//
//  Parameters    : INTEGER TabName - 
//                     Tab label.
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

INTEGER l_Idx, l_Pos, l_Tabs
STRING  l_TabName

//------------------------------------------------------------------
//  Cycle through the tabs looking for the tab to enable.  Use the
//  tab label after stripping the '&'.  After finding the tab, call
//  the fu_EnableTab function to do the actual enabling.
//------------------------------------------------------------------

l_Tabs = GetItemNumber(1, "t_num")
FOR l_Idx = 1 to l_Tabs
   l_Pos = POS(i_TabArray[l_Idx].TabName, "&")
   IF l_Pos > 0 THEN
      l_TabName = Replace(i_TabArray[l_Idx].TabName, l_Pos, 1, "")
   ELSE
      l_TabName = i_TabArray[l_Idx].TabName
   END IF
	IF Tab_Name = l_TabName THEN
		THIS.fu_EnableTab(l_Idx)
		RETURN
	END IF
NEXT

RETURN
end subroutine

public subroutine fu_foldercreate (integer tabs, integer tabs_per_row);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_FolderCreate
//  Description   : Creates the folder with the given number of
//                  tabs and tabs per row.  
//
//  Parameters    : INTEGER Tabs - 
//                     Number of tabs.
//                  INTEGER Tabs_Per_Row - 
//                     Number of tabs per row.
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

WINDOW      l_Window
USEROBJECT  l_UserObject
STRING      l_TabSide, l_TabRotate, l_Data, l_Label
INTEGER     l_Idx, l_Pos

//------------------------------------------------------------------
//  Initialize the folder tab settings.
//------------------------------------------------------------------

SetReDraw(FALSE)

i_Tabs = 0
i_CurrentTab = 0
i_SelectedTab = 0
i_SelectedTabName = ""

l_TabSide   = GetItemString(1, "f_side")
l_TabRotate = GetItemString(1, "t_rotate")

//------------------------------------------------------------------
//  Determine if the correct DataWindow object is present.
//------------------------------------------------------------------

i_PermInvisible = FALSE
IF NOT Visible THEN
   i_PermInvisible = TRUE
END IF

IF (l_TabSide = "T" OR l_TabSide = "B") AND &
   DataObject = "d_folder_lr" THEN
   IF Visible THEN
      Hide()
   END IF
   l_Data = Describe("datawindow.data")
   DataObject = "d_folder_tb"
   DeleteRow(1)
   ImportString(l_Data)
ELSEIF (l_TabSide = "L" OR l_TabSide = "R") AND &
   DataObject = "d_folder_tb" THEN
   IF Visible THEN
      Hide()
   END IF
   l_Data = Describe("datawindow.data")
   DataObject = "d_folder_lr"
   DeleteRow(1)
   ImportString(l_Data)
END IF

//------------------------------------------------------------------
//  Set the number of tabs and tabs per row variables.
//------------------------------------------------------------------

i_Tabs = Tabs
SetItem(1, "t_num", i_Tabs)
SetItem(1, "t_rows", Tabs_Per_Row)
SetItem(1, "t_visible", "")

//------------------------------------------------------------------
//  Determine the background color of the parent.
//------------------------------------------------------------------

IF Parent.TypeOf() = Window! THEN
   l_Window          = Parent
   Modify("datawindow.color = '" + String(l_Window.BackColor) + "'")
ELSE
   l_UserObject      = Parent
   Modify("datawindow.color = '" + String(l_UserObject.BackColor) + "'")
END IF

//------------------------------------------------------------------
//  Determine if extra tabs or rows are needed.
//------------------------------------------------------------------

IF l_TabSide = "T" OR l_TabSide = "B" THEN
   THIS.fu_FolderCreateTB(Tabs_Per_Row)
ELSE
   THIS.fu_FolderCreateLR(Tabs_Per_Row)
END IF

//------------------------------------------------------------------
//  Check to see if PowerLock security indicates that any of the
//  tabs should be hidden.  If PowerLock security is not installed
//  then a stub function is run.
//------------------------------------------------------------------

IF IsValid(SECCA.MGR) THEN
 	SECCA.MGR.DYNAMIC fu_SetObjectSecurity(i_SecurityWindow, THIS)
END IF

//------------------------------------------------------------------
//  Set the tab labels.
//
//  PowerBuilder Bug!  If text is rotated the '&' will display as
//  a character and not as an underline.  The workaround is to remove
//  the '&' from the text when text rotation is being used.
//-------------------------------------------------------------------

FOR l_Idx = 1 TO i_Tabs
   IF ((l_TabSide = "L" OR l_TabSide = "R") AND l_TabRotate = 'N') OR &
      ((l_TabSide = "T" OR l_TabSide = "B") AND l_TabRotate = 'Y') THEN
      l_Pos = Pos(i_TabArray[l_Idx].TabName, "&")
      IF l_Pos > 0 THEN 
         i_TabArray[l_Idx].TabName = Replace(i_TabArray[l_Idx].TabName, l_Pos, 1, "")
      END IF
   END IF

   IF Pos(i_TabArray[l_Idx].TabName, "&") > 0 THEN
      l_Label = Replace(i_TabArray[l_Idx].TabName, &
                        Pos(i_TabArray[l_Idx].TabName, "&"), 1, "")
   ELSE
      l_Label = i_TabArray[l_Idx].TabName
   END IF

	IF IsValid(SECCA.MGR) THEN
		SECCA.MGR.DYNAMIC fu_SetObjectSecurity(i_SecurityWindow, THIS, l_Label)
   END IF
NEXT

THIS.fu_BuildTab()

//------------------------------------------------------------------
//  Call the fu_FolderResize function to create the folder.
//------------------------------------------------------------------

THIS.fu_FolderResize()


end subroutine

public subroutine fu_hidetabname (string tab_name);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_HideTabName
//  Description   : Hides a tab that had been visible.  Uses the
//                  label of a tab instaed of the tab number. 
//
//  Parameters    : INTEGER Tab_Name - 
//                     Tab label.
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

INTEGER l_Idx, l_Pos, l_Tabs
STRING  l_TabName

//------------------------------------------------------------------
//  Cycle through the tabs looking for the tab to hide.  Use the
//  tab label after stripping the '&'.  After finding the tab, call
//  the fu_HideTab function to do the actual hiding.
//------------------------------------------------------------------

l_Tabs = GetItemNumber(1, "t_num")
FOR l_Idx = 1 to l_Tabs
   l_Pos = POS(i_TabArray[l_Idx].TabName, "&")
   IF l_Pos > 0 THEN
      l_TabName = Replace(i_TabArray[l_Idx].TabName, l_Pos, 1, "")
   ELSE
      l_TabName = i_TabArray[l_Idx].TabName
   END IF
	IF Tab_Name = l_TabName THEN
		THIS.fu_HideTab(l_Idx)
	END IF
NEXT

RETURN
end subroutine

public function userobject fu_opentab (integer tab, string uo_name);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_OpenTab
//  Description   : Opens a user object for the given tab.  
//
//  Parameters    : INTEGER Tab -
//                     Tab number to attach the user object to.
//                  STRING  UO_Name - 
//                     Name of the user object to open.
//
//  Return Value  : USEROBJECT - 
//                     The user object that was opened.  An error
//                     will return NULL.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

DRAGOBJECT  l_UserObject, l_NullObject, l_Object[]
POWEROBJECT l_Container
WINDOW      l_Window

//------------------------------------------------------------------
//  If an invalid tab is passed, or the tab is disabled or hidden 
//  then return with no processing.
//------------------------------------------------------------------

SetPointer(HourGlass!)
SetNull(l_NullObject)

IF Tab < 0 OR Tab > i_Tabs THEN
   RETURN l_NullObject
ELSE
   IF i_TabArray[Tab].TabDisable OR i_TabArray[Tab].TabHide THEN
	   RETURN l_NullObject
   END IF
END IF

//------------------------------------------------------------------
//  Find the window to open the user object on.
//------------------------------------------------------------------

l_Container = GetParent()
DO 
	IF l_Container.TypeOf() = Window! THEN
		l_Window = l_Container
		l_Window.SetReDraw(FALSE)
      IF l_Window.OpenUserObject(l_UserObject, uo_name, 1, 1) = -1 THEN
         l_Window.SetReDraw(TRUE)
         RETURN l_NullObject
		ELSE
			EXIT
      END IF
	ELSE
		l_Container = l_Container.GetParent()
	END IF
LOOP UNTIL l_Container.TypeOf() = Window!

//------------------------------------------------------------------
//  Assign the user object to the tab.
//------------------------------------------------------------------

l_Object[1] = l_UserObject
THIS.fu_AssignTab(tab, l_Object[])

//------------------------------------------------------------------
//  Center the user object.
//------------------------------------------------------------------

THIS.fu_CenterTabObject(l_UserObject)

//------------------------------------------------------------------
//  Return the name of the user object.
//------------------------------------------------------------------

l_Window.SetReDraw(TRUE)

RETURN l_UserObject
end function

public function integer fu_selecttab (integer tab);//******************************************************************
//  PO Module     : u_Folder
//  Function      : fu_SelectTab
//  Description   : Sets the given tab to be the current tab.  
//
//  Parameters    : INTEGER Tab - 
//                     Tab number
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                    -1 = selection failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Pos, l_SelectedRow
STRING  l_TmpPos, l_TabPos[]

//------------------------------------------------------------------
//  If the same tab is selected, an invalid tab is passed, or the
//  tab is disabled or hidden then return with no processing.
//------------------------------------------------------------------

IF tab = i_SelectedTab OR tab < 0 OR tab > i_Tabs THEN
   RETURN -1
ELSE
   IF tab > 0 THEN
		IF i_TabArray[tab].TabDisable OR i_TabArray[tab].TabHide THEN
	   	RETURN -1
   	END IF
	END IF
END IF

//------------------------------------------------------------------
//  Validate the current tab before moving to the new selected tab.
//------------------------------------------------------------------

IF i_SelectedTab > 0 THEN
   i_ClickedTab = tab
   IF tab > 0 THEN
		l_Pos = POS(i_TabArray[tab].TabName, "&")
   	IF l_Pos > 0 THEN
     	 	i_ClickedTabName = Replace(i_TabArray[tab].TabName, &
                                 l_Pos, 1, "")
  		ELSE
      	i_ClickedTabName = i_TabArray[tab].TabName
   	END IF
	ELSE
		i_ClickedTabName = ""
	END IF
	
	i_TabError = 0
	
	Event po_TabValidate(i_ClickedTab, i_ClickedTabName, &
	                     i_SelectedTab, i_SelectedTabName)

   IF i_TabError = -1 THEN
      RETURN -1
   END IF
END IF
 
//------------------------------------------------------------------
//  If a current tab exists, make the objects associated with the
//  tab invisible.
//------------------------------------------------------------------

SetReDraw(FALSE)

IF i_CurrentTab > 0 THEN
   FOR l_Idx = 1 TO i_TabArray[i_SelectedTab].TabNumObjects
      i_TabArray[i_SelectedTab].TabObjects[l_Idx].Visible = FALSE
   NEXT
END IF

//------------------------------------------------------------------
//  Check if a new tab was selected.  This function might have been
//  called just to turn off the current tab.
//------------------------------------------------------------------

IF tab > 0 THEN
   i_SelectedTab     = tab
   l_Pos = POS(i_TabArray[tab].TabName, "&")
   IF l_Pos > 0 THEN
      i_SelectedTabName = Replace(i_TabArray[tab].TabName, &
                                  l_Pos, 1, "")
   ELSE
      i_SelectedTabName = i_TabArray[tab].TabName
   END IF

   IF i_TabRows > 1 THEN
      l_SelectedRow = Ceiling(Pos(GetItemString(1, "t_pos"), &
                      "|" + String(tab, "00")) / Len(i_TabPos[1]))
      IF l_SelectedRow > 1 THEN
         l_TmpPos = ""
         FOR l_Idx = 1 TO i_TabRows
            l_TmpPos = l_TmpPos + i_TabPos[l_SelectedRow]
            l_TabPos[l_Idx] = i_TabPos[l_SelectedRow]
            l_SelectedRow = l_SelectedRow + 1
            IF l_SelectedRow > i_TabRows THEN
               l_SelectedRow = 1
            END IF
         NEXT
         i_TabPos[] = l_TabPos[]
         SetItem(1, "t_pos", l_TmpPos)
      END IF
   END IF

   //---------------------------------------------------------------
   //  Turn the objects assigned to the current tab visible.
   //---------------------------------------------------------------

   FOR l_Idx = 1 to i_TabArray[i_SelectedTab].TabNumObjects
		IF NOT i_TabArray[i_SelectedTab].TabObjectSecured[l_Idx] THEN
         i_TabArray[i_SelectedTab].TabObjects[l_Idx].Visible = TRUE
		END IF
   NEXT

   i_CurrentTab = tab
ELSE
   i_CurrentTab = 0
   i_SelectedTab = 0
   i_SelectedTabName = ""
END IF

SetItem(1, "t_select", tab)

SetReDraw(TRUE)

//------------------------------------------------------------------
//  Trigger an event to allow the developer to do processing after
//  a new current tab is selected.
//------------------------------------------------------------------

Event po_TabClicked(i_SelectedTab, i_SelectedTabName)

RETURN 0
end function

public function integer fu_selecttabname (string tab_name);//******************************************************************
//  PO Module     : u_Folder
//  Function      : fu_SelectTabName
//  Description   : Uses the tab label to set the given tab to be 
//                  the current tab. 
//
//  Parameters    : INTEGER Tab_Name - 
//                     Tab label.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = selection failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Pos, l_Tabs
STRING  l_TabName

//------------------------------------------------------------------
//  Cycle through the tabs looking for the tab to select.  Use the
//  tab label after stripping the '&'.  After finding the tab, call
//  the fu_SelectTab function to do the actual selecting.
//------------------------------------------------------------------

l_Tabs = GetItemNumber(1, "t_num")
FOR l_Idx = 1 to l_Tabs
   l_Pos = POS(i_TabArray[l_Idx].TabName, "&")
   IF l_Pos > 0 THEN
      l_TabName = Replace(i_TabArray[l_Idx].TabName, l_Pos, 1, "")
   ELSE
      l_TabName = i_TabArray[l_Idx].TabName
   END IF
	IF Tab_Name = l_TabName THEN
		IF THIS.fu_SelectTab(l_Idx) = -1 THEN
		   RETURN -1
      ELSE
         RETURN 0
      END IF
	END IF
NEXT

RETURN -1
end function

public subroutine fu_showtabname (string tab_name);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_ShowTabName
//  Description   : Uses the tab label to show a tab that had been 
//                  previously hidden.  
//
//  Parameters    : INTEGER Tab_Name - 
//                     Tab label.
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

INTEGER l_Idx, l_Pos, l_Tabs
STRING  l_TabName

//------------------------------------------------------------------
//  Cycle through the tabs looking for the tab to show.  Use the
//  tab label after stripping the '&'.  After finding the tab, call
//  the fu_ShowTab function to do the actual showing.
//------------------------------------------------------------------

l_Tabs = GetItemNumber(1, "t_num")
FOR l_Idx = 1 to l_Tabs
   l_Pos = POS(i_TabArray[l_Idx].TabName, "&")
   IF l_Pos > 0 THEN
      l_TabName = Replace(i_TabArray[l_Idx].TabName, l_Pos, 1, "")
   ELSE
      l_TabName = i_TabArray[l_Idx].TabName
   END IF
	IF Tab_Name = l_TabName THEN
		THIS.fu_ShowTab(l_Idx)
	END IF
NEXT

end subroutine

public subroutine fu_unassigntabobject (integer tab, ref windowobject tab_object);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_UnassignTabObject
//  Description   : Remove an assignment of a window object from
//                  the given tab.  
//
//  Parameters    : INTEGER      Tab - 
//                     Tab number.
//                  WINDOWOBJECT Tab_Object - 
//                     Object to unassign. 
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

INTEGER l_Idx, l_Jdx

l_Jdx = 0
FOR l_Idx = 1 TO i_TabArray[Tab].TabNumObjects
   IF i_TabArray[Tab].TabObjects[l_Idx] <> Tab_Object THEN
      l_Jdx = l_Jdx + 1
      i_TabArray[Tab].TabObjects[l_Jdx] = &
         i_TabArray[Tab].TabObjects[l_Idx]
      i_TabArray[Tab].TabObjectCentered[l_Jdx] = &
         i_TabArray[Tab].TabObjectCentered[l_Idx]
   END IF
NEXT
i_TabArray[Tab].TabNumObjects = l_Jdx

end subroutine

public subroutine fu_tabinfo (integer tab, ref string tab_label, ref boolean tab_enabled, ref boolean tab_visible, ref windowobject tab_objects[]);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_TabInfo
//  Description   : Returns information about the given tab.  
//
//  Parameters    : INTEGER      Tab - 
//                     Tab number.
//                  STRING       Tab_Label - 
//                     Tab label.
//                  BOOLEAN      Tab_Enabled - 
//                     Is tab enabled?
//                  BOOLEAN      Tab_Visible - 
//                     Is tab visible?
//                  WINDOWOBJECT Tab_Objects[] - 
//                     Array of window objects.
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

INTEGER l_Pos

IF tab <= 0 OR tab > GetItemNumber(1, "t_num") THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Return the name of the tab label.
//------------------------------------------------------------------

tab_label = i_TabArray[tab].TabName

//------------------------------------------------------------------
//  Strip off the '&'.
//------------------------------------------------------------------

l_Pos = Pos(tab_label, "&")
IF l_Pos > 0 THEN
	tab_label = Replace(tab_label, l_Pos, 1, "")
END IF

//------------------------------------------------------------------
//  Return the status of the tab.
//------------------------------------------------------------------

IF i_TabArray[tab].TabDisable THEN
   tab_enabled = FALSE
ELSE
   tab_enabled = TRUE
END IF

IF i_TabArray[tab].TabHide THEN
   tab_visible = FALSE
ELSE
   tab_visible = TRUE
END IF

//------------------------------------------------------------------
//  Return an array of window objects assigned to the tab.
//------------------------------------------------------------------

tab_objects[] = i_TabArray[tab].TabObjects[]

RETURN
end subroutine

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_Folder
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

public subroutine fu_disableall ();//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_DisableAll
//  Description   : Disables all tabs.  
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

INTEGER l_Idx, l_Tabs

l_Tabs = GetItemNumber(1, "t_num")

FOR l_Idx = 1 to l_Tabs
	THIS.fu_DisableTab(l_Idx)
NEXT

RETURN
end subroutine

public subroutine fu_enableall ();//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_EnableAll
//  Description   : Enables all tabs.  
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

INTEGER l_Idx, l_Tabs

l_Tabs = GetItemNumber(1, "t_num")

FOR l_Idx = 1 to l_Tabs
	THIS.fu_EnableTab(l_Idx)
NEXT

RETURN
end subroutine

private subroutine fu_setoptions (string optionstyle, string options);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_SetOptions
//  Description   : Sets visual defaults and options.  This function
//                  is used by all the option functions (i.e.
//                  fu_FolderOptions).  It is also called by the
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
   //  Set the folder options and defaults.
   //---------------------------------------------------------------

   CASE "General"

      //------------------------------------------------------------
      //  Folder tab location.
      //------------------------------------------------------------
  
      IF Pos(Options, c_FolderTabTop) > 0 THEN
         SetItem(1, "f_side", "T")
      ELSEIF Pos(Options, c_FolderTabBottom) > 0 THEN
         SetItem(1, "f_side", "B")
      ELSEIF Pos(Options, c_FolderTabLeft) > 0 THEN
         SetItem(1, "f_side", "L")
      ELSEIF Pos(Options, c_FolderTabRight) > 0 THEN
         SetItem(1, "f_side", "R")
      END IF

      //------------------------------------------------------------
      //  Folder color.
      //------------------------------------------------------------

      IF Pos(Options, c_FolderBlack) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_Black)
         SetItem(1, "f_shade", OBJCA.MGR.c_Black)
		ELSEIF Pos(Options, c_FolderWhite) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_White)
         SetItem(1, "f_shade", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_FolderGray) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_Gray)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_FolderDarkGray) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_DarkGray)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_FolderRed) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_Red)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_FolderDarkRed) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_DarkRed)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_FolderGreen) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_Green)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_FolderDarkGreen) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_DarkGreen)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_FolderBlue) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_Blue)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_FolderDarkBlue) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_DarkBlue)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_FolderMagenta) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_Magenta)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_FolderDarkMagenta) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_DarkMagenta)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_FolderCyan) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_Cyan)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_FolderDarkCyan) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_DarkCyan)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_FolderYellow) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_Yellow)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkYellow)
      ELSEIF Pos(Options, c_FolderDarkYellow) > 0 THEN
         SetItem(1, "f_color", OBJCA.MGR.c_DarkYellow)
         SetItem(1, "f_shade", OBJCA.MGR.c_DarkYellow)
      END IF
      SetItem(1, "t_bcolor", GetItemNumber(1, "f_color"))

      //------------------------------------------------------------
      //  Folder style.
      //------------------------------------------------------------

      IF Pos(Options, c_Folder3D) > 0 THEN
         SetItem(1, "f_style", "3D")
      ELSEIF Pos(Options, c_Folder2D) > 0 THEN
         SetItem(1, "f_style", "2D")
      END IF

      //------------------------------------------------------------
      //  Folder border.
      //------------------------------------------------------------

      IF Pos(Options, c_FolderBorderOn) > 0 THEN
         SetItem(1, "f_border", "Y")
      ELSEIF Pos(Options, c_FolderBorderOff) > 0 THEN
         SetItem(1, "f_border", "N")
      END IF

      //------------------------------------------------------------
      //  Folder resize.
      //------------------------------------------------------------

      IF Pos(Options, c_FolderResizeOn) > 0 THEN
         SetItem(1, "f_resize", "Y")
      ELSEIF Pos(Options, c_FolderResizeOff) > 0 THEN
         SetItem(1, "f_resize", "N")
      END IF

   //------------------------------------------------------------------
   //  Set the tab options and defaults.
   //------------------------------------------------------------------

   CASE "Tab"
		
      //------------------------------------------------------------
      //  Tab text style.
      //------------------------------------------------------------

      IF Pos(Options, c_TextRegular) > 0 THEN
         SetItem(1, "t_style", "regular")
      ELSEIF Pos(Options, c_TextBold) > 0 THEN
         SetItem(1, "t_style", "bold")
      ELSEIF Pos(Options, c_TextItalic) > 0 THEN
         SetItem(1, "t_style", "italic")
      ELSEIF Pos(Options, c_TextUnderline) > 0 THEN
         SetItem(1, "t_style", "underline")
      END IF
		
      //------------------------------------------------------------
      //  Tab text alignment.
      //------------------------------------------------------------

      IF Pos(Options, c_TextCenter) > 0 THEN
         SetItem(1, "t_align", 2)
      ELSEIF Pos(Options, c_TextLeft) > 0 THEN
         SetItem(1, "t_align", 0)
      ELSEIF Pos(Options, c_TextRight) > 0 THEN
         SetItem(1, "t_align", 1)
      END IF
		
      //------------------------------------------------------------
      //  Tab text color.
      //------------------------------------------------------------

      IF Pos(Options, c_TextBlack) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_TextWhite) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_TextGray) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_TextDarkGray) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_TextRed) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_TextDarkRed) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_TextGreen) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_TextDarkGreen) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_TextBlue) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_TextDarkBlue) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_TextMagenta) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_TextDarkMagenta) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_TextCyan) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_TextDarkCyan) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_TextYellow) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_TextDarkYellow) > 0 THEN
         SetItem(1, "t_color", OBJCA.MGR.c_DarkYellow)
      END IF
		
      //------------------------------------------------------------
      //  Tab text rotation.
      //------------------------------------------------------------

      IF Pos(Options, c_TextRotationOn) > 0 THEN
         SetItem(1, "t_rotate", "Y")
      ELSEIF Pos(Options, c_TextRotationOff) > 0 THEN
         SetItem(1, "t_rotate", "N")
      END IF

   //------------------------------------------------------------------
   //  Set the current tab options and defaults.
   //------------------------------------------------------------------

   CASE "Current"
		
      //------------------------------------------------------------
      //  Current tab text style.
      //------------------------------------------------------------

      IF Pos(Options, c_TextCurrentRegular) > 0 THEN
         SetItem(1, "c_style", "regular")
      ELSEIF Pos(Options, c_TextCurrentBold) > 0 THEN
         SetItem(1, "c_style", "bold")
      ELSEIF Pos(Options, c_TextCurrentItalic) > 0 THEN
         SetItem(1, "c_style", "italic")
      ELSEIF Pos(Options, c_TextCurrentUnderline) > 0 THEN
         SetItem(1, "c_style", "underline")
      END IF
		
      //------------------------------------------------------------
      //  Current tab text color.
      //------------------------------------------------------------

      IF Pos(Options, c_TextCurrentBlack) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_TextCurrentWhite) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_TextCurrentGray) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_TextCurrentDarkGray) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_TextCurrentRed) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_TextCurrentDarkRed) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_TextCurrentGreen) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_TextCurrentDarkGreen) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_TextCurrentBlue) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_TextCurrentDarkBlue) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_TextCurrentMagenta) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_TextCurrentDarkMagenta) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_TextCurrentCyan) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_TextCurrentDarkCyan) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_TextCurrentYellow) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_TextCurrentDarkYellow) > 0 THEN
         SetItem(1, "c_color", OBJCA.MGR.c_DarkYellow)
      END IF
		
      //------------------------------------------------------------
      //  Current tab color.
      //------------------------------------------------------------

      IF Pos(Options, c_TabCurrentBlack) > 0 THEN
         SetItem(1, "c_bcolor", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_TabCurrentWhite) > 0 THEN
         SetItem(1, "c_bcolor", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_TabCurrentGray) > 0 THEN
         SetItem(1, "c_bcolor", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_TabCurrentDarkGray) > 0 THEN
         SetItem(1, "c_bcolor", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_TabCurrentRed) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_TabCurrentDarkRed) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_TabCurrentGreen) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_TabCurrentDarkGreen) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_TabCurrentBlue) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_TabCurrentDarkBlue) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_TabCurrentMagenta) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_TabCurrentDarkMagenta) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_TabCurrentCyan) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_TabCurrentDarkCyan) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_TabCurrentYellow) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_TabCurrentDarkYellow) > 0 THEN 
         SetItem(1, "c_bcolor", OBJCA.MGR.c_DarkYellow)
      END IF
		
      //------------------------------------------------------------
      //  Current tab color area.
      //------------------------------------------------------------

      IF Pos(Options, c_TabCurrentColorFolder) > 0 THEN
         SetItem(1, "c_colorarea", "FOLDER")
      ELSEIF Pos(Options, c_TabCurrentColorBorder) > 0 THEN
         SetItem(1, "c_colorarea", "BORDER")
      ELSEIF Pos(Options, c_TabCurrentColorTab) > 0 THEN
         SetItem(1, "c_colorarea", "TAB")
      END IF

   //------------------------------------------------------------------
   //  Set the disable tab options and defaults.
   //------------------------------------------------------------------

   CASE "Disable"
		
      //------------------------------------------------------------
      //  Disabled tab text style.
      //------------------------------------------------------------

      IF Pos(Options, c_TextDisableRegular) > 0 THEN
         SetItem(1, "d_style", "regular")
      ELSEIF Pos(Options, c_TextDisableBold) > 0 THEN
         SetItem(1, "d_style", "bold")
      ELSEIF Pos(Options, c_TextDisableItalic) > 0 THEN
         SetItem(1, "d_style", "italic")
      ELSEIF Pos(Options, c_TextDisableUnderline) > 0 THEN
         SetItem(1, "d_style", "underline")
      END IF
		
      //------------------------------------------------------------
      //  Disabled tab text color.
      //------------------------------------------------------------

      IF Pos(Options, c_TextDisableBlack) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_TextDisableWhite) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_TextDisableGray) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_TextDisableDarkGray) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_TextDisableRed) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_TextDisableDarkRed) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_TextDisableGreen) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_TextDisableDarkGreen) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_TextDisableBlue) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_TextDisableDarkBlue) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_TextDisableMagenta) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_TextDisableDarkMagenta) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_TextDisableCyan) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_TextDisableDarkCyan) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_TextDisableYellow) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_TextDisableDarkYellow) > 0 THEN
         SetItem(1, "d_color", OBJCA.MGR.c_DarkYellow)
      END IF

END CHOOSE



end subroutine

public subroutine fu_folderoptions (integer tab_height, string options);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_FolderOptions
//  Description   : Establishes the look-and-feel of the folder
//                  portion of the tab folder object.  
//
//  Parameters    : INTEGER Tab_Height - 
//                     Height of the tab in pixels.
//                  STRING Options - 
//                     Visual options for the folder portion.
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
//  Set the height of the tabs.
//------------------------------------------------------------------

IF Tab_Height <> c_DefaultHeight THEN
   SetItem(1, "t_height", Tab_Height)
END IF

//------------------------------------------------------------------
//  Set the visual options for the folder portion of the object.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   fu_SetOptions("General", Options)
END IF

end subroutine

public subroutine fu_tabcurrentoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_TabCurrentOptions
//  Description   : Establishes the look-and-feel of the current tab
//                  portion of the tab folder object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the current tab portion.
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
//  Set the font style of the text for the current tab.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   SetItem(1, "c_font", TextFont)
   CHOOSE CASE UPPER(TextFont)
      CASE "ARIAL"
         SetItem(1, "c_family", 2)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", 0)
      CASE "COURIER", "COURIER NEW"
         SetItem(1, "c_family", 1)
         SetItem(1, "c_pitch", 1)
         SetItem(1, "c_charset", 0)
      CASE "MODERN"
         SetItem(1, "c_family", 1)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", -1)
      CASE "MS SANS SERIF"
         SetItem(1, "c_family", 2)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", 0)
      CASE "MS SERIF"
         SetItem(1, "c_family", 1)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", 0)
      CASE "ROMAN"
         SetItem(1, "c_family", 1)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", -1)
      CASE "SCRIPT"
         SetItem(1, "c_family", 4)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", -1)
      CASE "SMALL FONTS"
         SetItem(1, "c_family", 2)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", 0)
      CASE "SYSTEM"
         SetItem(1, "c_family", 2)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", 0)
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         SetItem(1, "c_family", 1)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", 0)
      CASE "MS LINEDRAW"
         SetItem(1, "c_family", 1)
         SetItem(1, "c_pitch", 1)
         SetItem(1, "c_charset", 2)
      CASE "TERMINAL"
         SetItem(1, "c_family", 1)
         SetItem(1, "c_pitch", 1)
         SetItem(1, "c_charset", -1)
      CASE "CENTURY SCHOOLBOOK"
         SetItem(1, "c_family", 1)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", 0)
      CASE "CENTURY GOTHIC"
         SetItem(1, "c_family", 2)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", 0)
      CASE ELSE
         SetItem(1, "c_family", 2)
         SetItem(1, "c_pitch", 2)
         SetItem(1, "c_charset", 0)
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Set the font size of the heading.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   SetItem(1, "c_size", TextSize)
END IF

//------------------------------------------------------------------
//  Set the visual options for the current tab portion of the object.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_SetOptions("Current", Options)
END IF
end subroutine

public subroutine fu_tabdisableoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_TabDisableOptions
//  Description   : Establishes the look-and-feel of the disabled
//                  tab portion of the tab folder object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the disabled tab portion.
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
//  Set the font style of the text for the disabled tabs.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   SetItem(1, "d_font", TextFont)
   CHOOSE CASE UPPER(TextFont)
      CASE "ARIAL"
         SetItem(1, "d_family", 2)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", 0)
      CASE "COURIER", "COURIER NEW"
         SetItem(1, "d_family", 1)
         SetItem(1, "d_pitch", 1)
         SetItem(1, "d_charset", 0)
      CASE "MODERN"
         SetItem(1, "d_family", 1)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", -1)
      CASE "MS SANS SERIF"
         SetItem(1, "d_family", 2)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", 0)
      CASE "MS SERIF"
         SetItem(1, "d_family", 1)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", 0)
      CASE "ROMAN"
         SetItem(1, "d_family", 1)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", -1)
      CASE "SCRIPT"
         SetItem(1, "d_family", 4)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", -1)
      CASE "SMALL FONTS"
         SetItem(1, "d_family", 2)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", 0)
      CASE "SYSTEM"
         SetItem(1, "d_family", 2)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", 0)
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         SetItem(1, "d_family", 1)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", 0)
      CASE "MS LINEDRAW"
         SetItem(1, "d_family", 1)
         SetItem(1, "d_pitch", 1)
         SetItem(1, "d_charset", 2)
      CASE "TERMINAL"
         SetItem(1, "d_family", 1)
         SetItem(1, "d_pitch", 1)
         SetItem(1, "d_charset", -1)
      CASE "CENTURY SCHOOLBOOK"
         SetItem(1, "d_family", 1)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", 0)
      CASE "CENTURY GOTHIC"
         SetItem(1, "d_family", 2)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", 0)
      CASE ELSE
         SetItem(1, "d_family", 2)
         SetItem(1, "d_pitch", 2)
         SetItem(1, "d_charset", 0)
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Set the font size of the heading.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   SetItem(1, "d_size", TextSize)
END IF

//------------------------------------------------------------------
//  Set the visual options for the disable tab portion of the object.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_SetOptions("Disable", Options)
END IF

end subroutine

public subroutine fu_taboptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_TabOptions
//  Description   : Establishes the look-and-feel of the tabs
//                  portion of the tab folder object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the tabs portion.
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
//  Set the font style of the text for the tabs.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   SetItem(1, "t_font", TextFont)
   CHOOSE CASE UPPER(TextFont)
      CASE "ARIAL"
         SetItem(1, "t_family", 2)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", 0)
      CASE "COURIER", "COURIER NEW"
         SetItem(1, "t_family", 1)
         SetItem(1, "t_pitch", 1)
         SetItem(1, "t_charset", 0)
      CASE "MODERN"
         SetItem(1, "t_family", 1)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", -1)
      CASE "MS SANS SERIF"
         SetItem(1, "t_family", 2)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", 0)
      CASE "MS SERIF"
         SetItem(1, "t_family", 1)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", 0)
      CASE "ROMAN"
         SetItem(1, "t_family", 1)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", -1)
      CASE "SCRIPT"
         SetItem(1, "t_family", 4)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", -1)
      CASE "SMALL FONTS"
         SetItem(1, "t_family", 2)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", 0)
      CASE "SYSTEM"
         SetItem(1, "t_family", 2)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", 0)
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         SetItem(1, "t_family", 1)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", 0)
      CASE "MS LINEDRAW"
         SetItem(1, "t_family", 1)
         SetItem(1, "t_pitch", 1)
         SetItem(1, "t_charset", 2)
      CASE "TERMINAL"
         SetItem(1, "t_family", 1)
         SetItem(1, "t_pitch", 1)
         SetItem(1, "t_charset", -1)
      CASE "CENTURY SCHOOLBOOK"
         SetItem(1, "t_family", 1)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", 0)
      CASE "CENTURY GOTHIC"
         SetItem(1, "t_family", 2)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", 0)
      CASE ELSE
         SetItem(1, "t_family", 2)
         SetItem(1, "t_pitch", 2)
         SetItem(1, "t_charset", 0)
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Set the font size of the heading.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   SetItem(1, "t_size", TextSize)
END IF

//------------------------------------------------------------------
//  Set the visual options for the tab portion of the object.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_SetOptions("Tab", Options)
END IF

end subroutine

public function userobject fu_opentab (integer tab, string uo_name, powerobject tab_parm);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_OpenTab
//  Description   : Opens a user object for the given tab.  
//
//  Parameters    : INTEGER     Tab -
//                     Tab number to attach the user object to.
//                  STRING      UO_Name - 
//                     Name of the user object to open.
//                  POWEROBJECT Tab_Parm -
//                     Parameter to pass when openning the user
//                     object.
//
//  Return Value  : USEROBJECT - 
//                     The user object that was opened.  An error
//                     will return NULL.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

DRAGOBJECT  l_UserObject, l_NullObject, l_Object[]
POWEROBJECT l_Container
WINDOW      l_Window

//------------------------------------------------------------------
//  If an invalid tab is passed, or the tab is disabled or hidden 
//  then return with no processing.
//------------------------------------------------------------------

SetPointer(HourGlass!)
SetNull(l_NullObject)

IF Tab < 0 OR Tab > i_Tabs THEN
   RETURN l_NullObject
ELSE
   IF i_TabArray[Tab].TabDisable OR i_TabArray[Tab].TabHide THEN
	   RETURN l_NullObject
   END IF
END IF

//------------------------------------------------------------------
//  Find the window to open the user object on.
//------------------------------------------------------------------

l_Container = GetParent()
DO 
	IF l_Container.TypeOf() = Window! THEN
		l_Window = l_Container
		l_Window.SetReDraw(FALSE)
      IF l_Window.OpenUserObjectWithParm(l_UserObject, tab_parm, &
		                                   uo_name, 1, 1) = -1 THEN
         l_Window.SetReDraw(TRUE)
         RETURN l_NullObject
		ELSE
			EXIT
      END IF
	ELSE
		l_Container = l_Container.GetParent()
	END IF
LOOP UNTIL l_Container.TypeOf() = Window!

//------------------------------------------------------------------
//  Assign the user object to the tab.
//------------------------------------------------------------------

l_Object[1] = l_UserObject
THIS.fu_AssignTab(tab, l_Object[])

//------------------------------------------------------------------
//  Center the user object.
//------------------------------------------------------------------

THIS.fu_CenterTabObject(l_UserObject)

//------------------------------------------------------------------
//  Return the name of the user object.
//------------------------------------------------------------------

l_Window.SetReDraw(TRUE)

RETURN l_UserObject
end function

public function userobject fu_opentab (integer tab, string uo_name, double tab_parm);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_OpenTab
//  Description   : Opens a user object for the given tab.  
//
//  Parameters    : INTEGER Tab -
//                     Tab number to attach the user object to.
//                  STRING  UO_Name - 
//                     Name of the user object to open.
//                  DOUBLE  Tab_Parm -
//                     Parameter to pass when openning the user
//                     object.
//
//  Return Value  : USEROBJECT - 
//                     The user object that was opened.  An error
//                     will return NULL.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

DRAGOBJECT  l_UserObject, l_NullObject, l_Object[]
POWEROBJECT l_Container
WINDOW      l_Window

//------------------------------------------------------------------
//  If an invalid tab is passed, or the tab is disabled or hidden 
//  then return with no processing.
//------------------------------------------------------------------

SetPointer(HourGlass!)
SetNull(l_NullObject)

IF Tab < 0 OR Tab > i_Tabs THEN
   RETURN l_NullObject
ELSE
   IF i_TabArray[Tab].TabDisable OR i_TabArray[Tab].TabHide THEN
	   RETURN l_NullObject
   END IF
END IF

//------------------------------------------------------------------
//  Find the window to open the user object on.
//------------------------------------------------------------------

l_Container = GetParent()
DO 
	IF l_Container.TypeOf() = Window! THEN
		l_Window = l_Container
		l_Window.SetReDraw(FALSE)
      IF l_Window.OpenUserObjectWithParm(l_UserObject, tab_parm, &
		                                   uo_name, 1, 1) = -1 THEN
         l_Window.SetReDraw(TRUE)
         RETURN l_NullObject
		ELSE
			EXIT
      END IF
	ELSE
		l_Container = l_Container.GetParent()
	END IF
LOOP UNTIL l_Container.TypeOf() = Window!

//------------------------------------------------------------------
//  Assign the user object to the tab.
//------------------------------------------------------------------

l_Object[1] = l_UserObject
THIS.fu_AssignTab(tab, l_Object[])

//------------------------------------------------------------------
//  Center the user object.
//------------------------------------------------------------------

THIS.fu_CenterTabObject(l_UserObject)

//------------------------------------------------------------------
//  Return the name of the user object.
//------------------------------------------------------------------

l_Window.SetReDraw(TRUE)

RETURN l_UserObject
end function

public function userobject fu_opentab (integer tab, string uo_name, string tab_parm);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_OpenTab
//  Description   : Opens a user object for the given tab.  
//
//  Parameters    : INTEGER Tab -
//                     Tab number to attach the user object to.
//                  STRING  UO_Name - 
//                     Name of the user object to open.
//                  STRING  Tab_Parm -
//                     Parameter to pass when openning the user
//                     object.
//
//  Return Value  : USEROBJECT - 
//                     The user object that was opened.  An error
//                     will return NULL.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

DRAGOBJECT  l_UserObject, l_NullObject, l_Object[]
POWEROBJECT l_Container
WINDOW      l_Window

//------------------------------------------------------------------
//  If an invalid tab is passed, or the tab is disabled or hidden 
//  then return with no processing.
//------------------------------------------------------------------

SetPointer(HourGlass!)
SetNull(l_NullObject)

IF Tab < 0 OR Tab > i_Tabs THEN
   RETURN l_NullObject
ELSE
   IF i_TabArray[Tab].TabDisable OR i_TabArray[Tab].TabHide THEN
	   RETURN l_NullObject
   END IF
END IF

//------------------------------------------------------------------
//  Find the window to open the user object on.
//------------------------------------------------------------------

l_Container = GetParent()
DO 
	IF l_Container.TypeOf() = Window! THEN
		l_Window = l_Container
		l_Window.SetReDraw(FALSE)
      IF l_Window.OpenUserObjectWithParm(l_UserObject, tab_parm, &
		                                   uo_name, 1, 1) = -1 THEN
         l_Window.SetReDraw(TRUE)
         RETURN l_NullObject
		ELSE
			EXIT
      END IF
	ELSE
		l_Container = l_Container.GetParent()
	END IF
LOOP UNTIL l_Container.TypeOf() = Window!

//------------------------------------------------------------------
//  Assign the user object to the tab.
//------------------------------------------------------------------

l_Object[1] = l_UserObject
THIS.fu_AssignTab(tab, l_Object[])

//------------------------------------------------------------------
//  Center the user object.
//------------------------------------------------------------------

THIS.fu_CenterTabObject(l_UserObject)

//------------------------------------------------------------------
//  Return the name of the user object.
//------------------------------------------------------------------

l_Window.SetReDraw(TRUE)

RETURN l_UserObject
end function

public function integer fu_gettabs ();//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_GetTabs
//  Description   : Returns the number of tabs in the folder.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     Number of tabs.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1998.  All Rights Reserved.
//******************************************************************

RETURN i_Tabs
end function

public subroutine fu_resettabs (integer tabs);//******************************************************************
//  PO Module     : u_Folder
//  Subroutine    : fu_ResetTabs
//  Description   : Reset the hide and disable attributes for the
//                  given number of tabs.  
//
//  Parameters    : INTEGER Tabs - 
//                     Number of tabs to reset.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1998.  All Rights Reserved.
//******************************************************************

INTEGER l_Tabs, l_Idx

l_Tabs = tabs
IF UpperBound(i_TabArray[]) < tabs THEN
	l_Tabs = UpperBound(i_TabArray[])
END IF

FOR l_Idx = 1 TO l_Tabs
   i_TabArray[l_Idx].TabHide    = FALSE
   i_TabArray[l_Idx].TabDisable = FALSE
NEXT

RETURN
end subroutine

event constructor;//******************************************************************
//  PO Module     : u_Folder
//  Event         : Constructor
//  Description   : Initializes the default folder options and 
//                  determines if any of the tabs are initially
//                  created invisible.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

POWEROBJECT l_Container
STRING      l_Defaults, l_DefaultFont, l_DefaultSize, l_DefaultHeight

//------------------------------------------------------------------
//  Make sure the border of the folder control is turned off and
//  the tab order is 0.
//------------------------------------------------------------------

i_FolderResize = FALSE
Border         = FALSE
TabOrder       = 0
i_FolderResize = TRUE

//------------------------------------------------------------------
//  If PowerLock security is being used, find the security window.
//------------------------------------------------------------------

IF IsValid(SECCA.MGR) THEN
	l_Container = GetParent()
	DO 
		IF l_Container.TypeOf() = Window! THEN
			i_SecurityWindow = l_Container
		ELSE
			l_Container = l_Container.GetParent()
			IF l_Container.TypeOf() = Window! THEN
				i_SecurityWindow = l_Container
			END IF
		END IF
	LOOP UNTIL l_Container.TypeOf() = Window!
END IF

SetReDraw(FALSE)

//------------------------------------------------------------------
//  Initialize the folder options.
//------------------------------------------------------------------

l_Defaults = OBJCA.MGR.fu_GetDefault("Folder", "General")
l_DefaultHeight = OBJCA.MGR.fu_GetDefault("Folder", "TabHeight")
THIS.fu_FolderOptions(Integer(l_DefaultHeight), l_Defaults)

//------------------------------------------------------------------
//  Initialize the tab options.
//------------------------------------------------------------------

l_Defaults = OBJCA.MGR.fu_GetDefault("Folder", "Tab")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Folder", "TabTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Folder", "TabTextSize")
THIS.fu_TabOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

//------------------------------------------------------------------
//  Initialize the current tab options.
//------------------------------------------------------------------

l_Defaults = OBJCA.MGR.fu_GetDefault("Folder", "Current")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Folder", "CurrentTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Folder", "CurrentTextSize")
THIS.fu_TabCurrentOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

//------------------------------------------------------------------
//  Initialize the disabled tab options.
//------------------------------------------------------------------

l_Defaults = OBJCA.MGR.fu_GetDefault("Folder", "Disable")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Folder", "DisableTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Folder", "DisableTextSize")
THIS.fu_TabDisableOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)


end event

event clicked;//******************************************************************
//  PO Module     : u_Folder
//  Event         : Clicked
//  Description   : Determines if a tab has been clicked.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_ClickedTab, l_ClickedPos
STRING  l_ClickedObject

//------------------------------------------------------------------
//  Get the object in the DataWindow that was clicked on.  
//------------------------------------------------------------------

l_ClickedObject = GetObjectAtPointer()

IF l_ClickedObject = "" THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Determine if a tab was clicked on.  
//------------------------------------------------------------------

l_ClickedObject = MID(l_ClickedObject, 1, &
                      POS(l_ClickedObject, CHAR(9)) - 1)

IF Left(l_ClickedObject, 3) <> "tab" THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Get the tab number and use it to select the tab.  
//------------------------------------------------------------------

i_ClickedTab = 0
l_ClickedPos = Integer(Mid(l_ClickedObject, 4, &
                       Pos(l_ClickedObject, "_") - 4))
l_ClickedTab = Integer(Mid(GetItemString(1, "t_pos"), &
                       (l_ClickedPos - 1) * 9 + 2, 2))

THIS.fu_SelectTab(l_ClickedTab)

end event

event resize;//******************************************************************
//  PO Module     : u_Folder
//  Event         : Resize
//  Description   : Resize the folder control.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_FolderX, l_FolderY, l_FolderWidth, l_FolderHeight
INTEGER    l_ObjectWidth, l_ObjectHeight, l_X, l_Y, l_Idx, l_Jdx
DRAGOBJECT l_Object

//------------------------------------------------------------------
//  If the resize option is on, resize the folder object when 
//  the control has been resized by its parent.
//------------------------------------------------------------------

IF GetItemString(1, "f_resize") = "Y" AND i_FolderResize THEN
   THIS.fu_FolderResize()

   THIS.fu_FolderWorkSpace(l_FolderX, l_FolderY, &
                           l_FolderWidth, l_FolderHeight)

   //---------------------------------------------------------------
   //  If any of the objects have been centered before, re-center
   //  them after the resize.
   //---------------------------------------------------------------

   FOR l_Idx = 1 TO i_Tabs
      IF i_TabArray[l_Idx].TabNumObjects > 0 THEN
         FOR l_Jdx = 1 TO i_TabArray[l_Idx].TabNumObjects
            IF i_TabArray[l_Idx].TabObjectCentered[l_Jdx] THEN
               l_Object = i_TabArray[l_Idx].TabObjects[l_Jdx]
					IF IsValid(l_Object) THEN
	               l_ObjectWidth  = l_Object.Width
   	            l_ObjectHeight = l_Object.Height

      	         IF l_ObjectWidth > l_FolderWidth THEN
         	         l_X = l_FolderX
            	   ELSE
               	   l_X = ((l_FolderWidth - l_ObjectWidth) / 2) + l_FolderX
	               END IF

	               IF l_ObjectHeight > l_FolderHeight THEN
   	               l_Y = l_FolderY
      	         ELSE
         	         l_Y = ((l_FolderHeight - l_ObjectHeight) / 2) + l_FolderY
            	   END IF

               	l_Object.Move(l_X, l_Y)
					END IF
            END IF
         NEXT
      END IF
   NEXT
END IF
end event

on u_folder.create
end on

on u_folder.destroy
end on

