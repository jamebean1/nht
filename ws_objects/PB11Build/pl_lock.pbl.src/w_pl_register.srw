$PBExportHeader$w_pl_register.srw
$PBExportComments$Window used to register objects
forward
global type w_pl_register from window
end type
type dw_1 from datawindow within w_pl_register
end type
type st_2 from statictext within w_pl_register
end type
type cbx_delete from checkbox within w_pl_register
end type
type cb_collapse from commandbutton within w_pl_register
end type
type cb_expand from commandbutton within w_pl_register
end type
type st_1 from statictext within w_pl_register
end type
type cb_clear from commandbutton within w_pl_register
end type
type cb_select from commandbutton within w_pl_register
end type
type cb_print from commandbutton within w_pl_register
end type
type cb_cancel from commandbutton within w_pl_register
end type
type cb_ok from commandbutton within w_pl_register
end type
end forward

global type w_pl_register from window
integer x = 617
integer y = 428
integer width = 1673
integer height = 1132
boolean titlebar = true
string title = "Object Registration"
boolean minbox = true
boolean resizable = true
windowtype windowtype = popup!
long backcolor = 80269524
dw_1 dw_1
st_2 st_2
cbx_delete cbx_delete
cb_collapse cb_collapse
cb_expand cb_expand
st_1 st_1
cb_clear cb_clear
cb_select cb_select
cb_print cb_print
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_pl_register w_pl_register

type prototypes

end prototypes

type variables
CONSTANT INTEGER	c_DynamicUO	= 1
CONSTANT INTEGER	c_PopupMenu	= 2
CONSTANT INTEGER	c_DataWindow	= 3
CONSTANT INTEGER	c_Other		= 4

WINDOW	i_CurrentWindow

INTEGER	i_Width
INTEGER	i_Height

BOOLEAN	i_FromOutsideObject, i_Modified
BOOLEAN	i_DeleteBeforeSave = TRUE
BOOLEAN	i_DoneWithWinControls
LONG		i_CurrentRow
LONG		i_AnchorRow
LONG		i_ScrollPosition

INTEGER	i_NumLevels
INTEGER	i_NumSelected
INTEGER	i_DeleteBit

STRING		i_SelectedNames[]
STRING		i_WindowName
STRING		i_ForeColor, i_BackColor
STRING		i_HighColor, i_TextColor

STRING	i_BoxSyntax = 'create line(band=detail  pen.style="0" ' + &
		        'pen.width="1"  background.mode="1" ' + &
		        'background.color="553648127" '

INTEGER	i_HeightFactor = 18
INTEGER	i_HeightMidFactor = 9
INTEGER	i_HeightAdjFactor = 0
INTEGER 	i_BMPHeight = 16

INTEGER 	i_WidthFactor = 16
INTEGER 	i_WidthMidFactor = 7
INTEGER 	i_WidthAdjFactor = 2
INTEGER 	i_BMPWidth = 16
INTEGER	i_HLIndent = 2
STRING		i_HLColor  =  "16777215"



end variables

forward prototypes
public subroutine fw_hlinit ()
public subroutine fw_hlcontrol (windowobject object_name, string object_parent, integer object_level, ref integer num_controls, ref string controls[], ref string control_parent[], ref string control_desc[], ref integer control_level[], ref integer control_type[], ref string control_bmp[], ref string control_tblcol[])
public subroutine fw_hlmenu (menu menu_id, string menu_name, boolean popup_type, integer level, ref integer num_items, ref string menu_item[], ref string menu_parent[], ref string menu_desc[], ref integer menu_level[], ref integer menu_type[], ref string menu_bmp[], ref string menu_column[])
public function integer fw_getobjtype (string object_name)
public subroutine fw_processdeletebit (integer delete_bit, ref boolean dynamic_uos, ref boolean popup_menus, ref boolean datawindows)
public subroutine fw_hlcollapsebranch (long clickedrow)
public subroutine fw_hlcollapselevel (integer level)
public subroutine fw_hlexpandall ()
public subroutine fw_hlexpandlevel (long clickedrow)
public subroutine fw_hlsetlastingroup (datawindow dwcontrol)
public subroutine fw_hlselectall ()
public subroutine fw_hlclearall ()
end prototypes

public subroutine fw_hlinit ();//******************************************************************
//  PL Module     : w_pl_register
//  Function      : fw_HLInit
//  Description   : Constructs the outliner object with the current
//                  windows list of controls.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
// 10/27/98	 Beth Byers	Don't look for any dynamically instantiated
//								objects.  PB 6 automatically adds them to the
//								control array.
//	02/16/99   NF       Changed arrays to support 10 cascading menu 
//							  items
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

U_REGISTERBUTTON l_Button, l_RegisterButton
WINDOWOBJECT     l_WinControl[], l_DynamicUO[], l_Name
OBJECT           l_Type
DATAWINDOW       l_DW
POWEROBJECT      l_DynamicUOParent, l_MPO[]
MENU             l_Menu

STRING  l_BMPDir, l_XStr, l_WidthStr, l_Comma, l_Paren, l_Parent
STRING  l_Control[], l_ControlParent[], l_ControlDesc[]
STRING  l_Descriptions[], l_ControlBMP[], l_ControlTblCol[]
STRING  l_MenuName, l_DynMenuName[], l_BMPCol, l_LineSyntax
STRING  l_LineColor, l_SyntaxLevel, l_ShowBoxes, l_ShowPlus
STRING  l_WidthFactorStr1, l_WidthFactorStr2, l_BoxAttr, l_PlusAttr
STRING  l_LineAttr, l_BoxSyntax, l_LineMask
//INTEGER l_Limit, l_Idx, l_X[6], l_Width[6], l_NumWinControls
// NF
INTEGER l_Limit, l_Idx, l_X[10], l_Width[10], l_NumWinControls
// NF
INTEGER l_NumDynamicUOs, l_TotalNumControls, l_CurDynamicUO
INTEGER l_NumControls, l_ControlLevel[], l_NumDescriptions
INTEGER l_ControlType[], l_Jdx, l_Level, l_MenuRow, l_MenuLevel
INTEGER l_DynMenuRow[], l_Rows, l_CurrentLevel, l_StartWidth
INTEGER l_BoxSize, l_BoxMidSize, l_PlusSize, l_PlusMidSize
BOOLEAN l_DynamicTabPage, l_CustomControl, l_POFolder, l_Found

SetPointer(HourGlass!)

i_WindowName = i_CurrentWindow.ClassName()
l_BmpDir = SECCA.MGR.i_BMPPath

//------------------------------------------------------------------
//  Find the register button for the current window
//------------------------------------------------------------------

l_Limit = UpperBound(SECCA.MGR.i_RegButton[])
FOR l_Idx = 1 TO l_Limit
	l_Button = SECCA.MGR.i_RegButton[l_Idx]
	IF l_Button.i_Window = i_CurrentWindow THEN
		l_RegisterButton = SECCA.MGR.i_RegButton[l_Idx]
		EXIT
	END IF
NEXT

i_BackColor = dw_1.Describe("obj_desc.background.color")
i_TextColor = dw_1.Describe("obj_desc.color")
i_HighColor = STRING(RGB(0, 0, 128))
i_ForeColor = STRING(RGB(255, 255, 255))

//------------------------------------------------------------------
//  Define the display of the hierarchy datawindow.
//------------------------------------------------------------------

l_X[1] = UnitsToPixels(106, xUnitsToPixels!)
l_Width[1] = UnitsToPixels(dw_1.Width, xUnitsToPixels!) - l_X[1]
l_Xstr = "obj_desc.x = '" + string(l_X[1]) + "~t("
l_Widthstr = "obj_desc.width = '" + string(l_Width[1]) + "~t("
l_Comma = ""
l_Paren = ")"
//FOR l_Idx = 2 TO 6
// NF
FOR l_Idx = 2 TO 10
// NF
   l_X[l_Idx] = l_X[l_idx - 1] + UnitsToPixels(76, xUnitsToPixels!)
   l_Width[l_Idx] = UnitsToPixels(dw_1.Width, xUnitsToPixels!) - l_X[l_Idx]
   l_Xstr = l_Xstr + l_comma + "if(level = " + string(l_Idx) + &
	         ", " + string(l_X[l_Idx])
   l_Widthstr = l_Widthstr + l_comma + "if(level = " + &
	             string(l_Idx) + ", " + string(l_Width[l_Idx])
   l_Paren = l_Paren + ")"
   l_Comma = "," 
NEXT
l_Xstr = l_Xstr + ", " + string(l_X[1]) + l_Paren + "'"
l_Widthstr = l_Widthstr + ", " + string(l_Width[1]) + l_Paren + "'"

//------------------------------------------------------------------
//  Retrieve the list of registered objects to be displayed.
//------------------------------------------------------------------

i_NumSelected = SECCA.MGR.fu_GetRegObjects(i_WindowName, &
                                           i_SelectedNames[])

l_WinControl[] = i_CurrentWindow.control[]
l_NumWinControls = UpperBound(l_WinControl)

//l_DynamicUO[] = l_RegisterButton.i_DynamicUO[]
//l_NumDynamicUOs = UpperBound(l_DynamicUO)

//l_TotalNumControls = l_NumWinControls + l_NumDynamicUOs
l_TotalNumControls = l_NumWinControls 
i_DoneWithWinControls = FALSE

l_CurDynamicUO = 0
FOR l_Idx = 1 TO l_TotalNumControls
	l_DynamicTabPage = FALSE
	IF l_Idx > l_NumWinControls THEN
		i_DoneWithWinControls = TRUE
	END IF
	IF i_DoneWithWinControls THEN
		l_CurDynamicUO ++
		l_Type = l_DynamicUO[l_CurDynamicUO].TypeOf()
	ELSE
		l_Type = l_WinControl[l_Idx].TypeOf()
	END IF
	l_CustomControl = FALSE
   IF l_Type <> MDIClient! THEN
		IF i_DoneWithWinControls THEN
			l_Name = l_DynamicUO[l_CurDynamicUO]
		ELSE
	      l_Name   = l_WinControl[l_Idx]
		END IF

		//---------------------------------------------------
		// Don't display the register button
		//---------------------------------------------------
		IF l_Name.ClassName() = l_RegisterButton.ClassName() THEN CONTINUE
		
      l_Parent = l_Name.ClassName()
		l_NumControls = l_NumControls + 1
      l_Control[l_NumControls] = l_Parent
      l_ControlParent[l_NumControls] = ""
      l_ControlDesc[l_NumControls] = l_Parent
      l_ControlLevel[l_NumControls] = 2
		l_NumDescriptions = SECCA.MGR.fu_SetCustomDescriptions(&
		                                 i_CurrentWindow, &
							  						l_Name, &
													l_descriptions[], &
													l_CustomControl)
		IF l_CustomControl THEN
			l_ControlParent[l_NumControls] = l_Parent
			l_ControlType[l_NumControls] = 400
         l_ControlBMP[l_NumControls] = l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[6]
			FOR l_Jdx = 1 TO l_NumDescriptions
      		l_NumControls = l_NumControls + 1
      		l_Control[l_NumControls] = l_Parent + "." + l_descriptions[l_Jdx]
	     		l_ControlParent[l_NumControls] = l_Parent
      		l_ControlDesc[l_NumControls] = l_descriptions[l_Jdx]
      		l_ControlLevel[l_NumControls] = 3
				l_ControlType[l_NumControls] = 401
         	l_ControlBMP[l_NumControls] = l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[6]
				l_ControlTblCol[l_NumControls] = ""
			END FOR
		ELSE
      	FOR l_Jdx = 1 TO SECCA.MGR.i_NumObjects
         	IF l_Type = SECCA.MGR.i_ObjectType[l_Jdx] THEN
					IF i_DoneWithWinControls THEN
            	   l_ControlType[l_NumControls] = l_Jdx + 600
					ELSE
						l_ControlType[l_NumControls] = l_Jdx
					END IF
	            l_ControlBMP[l_NumControls] = l_BmpDir + SECCA.MGR.i_ObjectBMP[l_Jdx]
					l_ControlTblCol[l_NumControls] = ""
            	EXIT
         	END IF
      	NEXT
      	IF l_Type = DataWindow! OR l_Type = UserObject! OR l_Type = Tab! THEN
         	l_ControlParent[l_NumControls] = l_Parent
         	IF l_Type = DataWindow! THEN
            	l_DW = l_Name
					
               //---------------------------------------------------
               //  Determine if the datawindow is a PowerObjects
               //  tab folder.
               //---------------------------------------------------
					
			      l_POFolder = FALSE
			      IF l_DW.TriggerEvent("po_identify") = 1 THEN
				      IF l_DW.Dynamic fu_GetIdentity() = "Folder" THEN
					      l_POFolder = TRUE
				      END IF
			      END IF
					
            	IF NOT l_POFolder THEN
						IF i_DoneWithWinControls THEN
               	   l_ControlType[l_NumControls] = 700
						ELSE
							l_ControlType[l_NumControls] = 100
						END IF
               	l_ControlBMP[l_NumControls] = l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[1]
						l_ControlTblCol[l_NumControls] = ""
            	ELSE
               	l_ControlType[l_NumControls] = 300
               	l_ControlBMP[l_NumControls] = l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[4]
						l_ControlTblCol[l_NumControls] = ""
            	END IF
				ELSEIF l_Type = UserObject! THEN
					IF i_DoneWithWinControls THEN
						l_DynamicUOParent = l_Name.GetParent()
						IF l_DynamicUOParent.TypeOf() = Tab! THEN
							l_Parent = l_DynamicUOParent.ClassName() + "." + l_Parent
							l_ControlParent[l_NumControls] = l_Parent
							l_Control[l_NumControls] = l_DynamicUOParent.ClassName() + "." + l_Control[l_NumControls]
							l_ControlLevel[l_NumControls] = 3
							l_ControlBMP[l_NumControls] = l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[5]
							l_DynamicTabPage = TRUE
						END IF
					END IF
         	END IF
				IF l_DynamicTabPage THEN
					l_Level = 3
				ELSE
         	   l_Level = 2
				END IF
        		fw_HLControl(l_Name, l_Parent, l_Level, l_NumControls, &
                      	 l_Control[], l_ControlParent[], &
                      	 l_ControlDesc[], l_ControlLevel[], &
                      	 l_ControlType[], l_ControlBMP[], &
	                    	 l_ControlTblCol[])
      	END IF
		END IF
   END IF
NEXT

IF i_CurrentWindow.MenuName <> "" THEN
   l_MenuRow   = l_NumControls + 2
   l_Menu      = i_CurrentWindow.MenuID
   l_MenuName  = i_CurrentWindow.MenuName
   l_MenuLevel = 2
   fw_HLMenu(l_Menu, l_MenuName, FALSE, l_MenuLevel, l_NumControls, &
             l_Control[], l_ControlParent[], &
             l_ControlDesc[], l_ControlLevel[], &
             l_ControlType[], l_ControlBMP[], &
             l_ControlTblCol[])

END IF

//------------------------------------------------------------------
// Load any dynamically created popup menus.
//------------------------------------------------------------------

l_Limit = UpperBound(l_RegisterButton.i_PopupMenu[])
FOR l_Idx = 1 TO l_Limit
	l_DynMenuRow[l_Idx]   = l_NumControls + 2
	l_MenuLevel = 2
	l_Found = FALSE
	l_MPO[l_Idx] = l_RegisterButton.i_PopupMenu[l_Idx].GetParent()
	l_DynMenuName[l_Idx] = l_RegisterButton.i_PopupMenu[l_Idx].ClassName()
	DO
		IF IsValid(l_MPO[l_Idx]) THEN
			l_DynMenuName[l_Idx] = l_MPO[l_Idx].ClassName() + "/" + l_DynMenuName[l_Idx]
			l_MPO[l_Idx] = l_MPO[l_Idx].GetParent()
		ELSE
			l_Found = TRUE
		END IF
	LOOP UNTIL l_Found
	fw_HLMenu(l_RegisterButton.i_PopupMenu[l_Idx], &
	          l_DynMenuName[l_Idx], &
				 TRUE, l_MenuLevel, l_NumControls, &
             l_Control[], l_ControlParent[], &
             l_ControlDesc[], l_ControlLevel[], &
             l_ControlType[], l_ControlBMP[], &
             l_ControlTblCol[])
NEXT
	
dw_1.Reset()

FOR l_Idx = 1 TO l_NumControls
   dw_1.InsertRow(l_Idx)
   dw_1.SetItem(l_Idx, "obj_window", i_WindowName)
   dw_1.SetItem(l_Idx, "obj_parent", l_ControlParent[l_Idx])
   dw_1.SetItem(l_Idx, "obj_name", l_Control[l_Idx])
   dw_1.SetItem(l_Idx, "obj_desc", l_ControlDesc[l_Idx])
   dw_1.SetItem(l_Idx, "obj_type", l_ControlType[l_Idx])
   dw_1.SetItem(l_Idx, "level", l_ControlLevel[l_Idx])
   l_BMPCol = "bitmap" + String(l_ControlLevel[l_Idx])
   dw_1.SetItem(l_Idx, l_BMPCol, l_ControlBMP[l_Idx])
   dw_1.SetItem(l_Idx, "obj_tblcol", l_ControlTblCol[l_Idx])
NEXT
dw_1.InsertRow(1)
dw_1.SetItem(1, "obj_window", i_WindowName)
dw_1.SetItem(1, "obj_parent", "")
dw_1.SetItem(1, "obj_name", "")
dw_1.SetItem(1, "obj_desc", i_WindowName)
dw_1.SetItem(1, "obj_type", 0)
dw_1.SetItem(1, "bitmap1", l_BmpDir + "window.bmp")
dw_1.SetItem(1, "level", 1)

IF i_CurrentWindow.MenuName <> "" THEN
   dw_1.InsertRow(l_MenuRow)
   dw_1.SetItem(l_MenuRow, "obj_window", i_WindowName)
   dw_1.SetItem(l_MenuRow, "obj_parent", l_MenuName)
   dw_1.SetItem(l_MenuRow, "obj_name", l_MenuName)
   dw_1.SetItem(l_MenuRow, "obj_desc", l_MenuName)
   dw_1.SetItem(l_MenuRow, "obj_type", 200)
   dw_1.SetItem(l_MenuRow, "bitmap2", l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[2])
   dw_1.SetItem(l_MenuRow, "level", 2)
END IF

//------------------------------------------------------------------
// Insert any dynamically created popup menus.
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_Limit
   dw_1.InsertRow(l_DynMenuRow[l_Idx])
   dw_1.SetItem(l_DynMenuRow[l_Idx], "obj_window", i_WindowName)
   dw_1.SetItem(l_DynMenuRow[l_Idx], "obj_parent", l_DynMenuName[l_Idx])
   dw_1.SetItem(l_DynMenuRow[l_Idx], "obj_name", l_DynMenuName[l_Idx])
   dw_1.SetItem(l_DynMenuRow[l_Idx], "obj_desc", l_DynMenuName[l_Idx])
   dw_1.SetItem(l_DynMenuRow[l_Idx], "obj_type", 500)
   dw_1.SetItem(l_DynMenuRow[l_Idx], "bitmap2", l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[2])
   dw_1.SetItem(l_DynMenuRow[l_Idx], "level", 2)
NEXT

dw_1.Sort()

i_NumLevels = 0
l_Rows = dw_1.RowCount()
FOR l_Idx = 1 TO l_Rows
      l_CurrentLevel = dw_1.GetItemNumber(l_Idx, "level")
      IF l_CurrentLevel > i_NumLevels THEN
         i_NumLevels = l_CurrentLevel
      END IF
NEXT

fw_HLSetLastInGroup(dw_1)

//------------------------------------------------------------------
//  Build the syntax for the connecting lines at each level.  The
//  syntax for level 1 is slightly different that all other
//  levels.
//------------------------------------------------------------------

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

IF i_NumLevels > 1 THEN
   FOR l_Idx = 2 TO i_NumLevels - 1 
       l_SyntaxLevel = String(l_Idx)
       l_LineSyntax = l_LineSyntax + 'create line(band=detail ' + &
	                  'pen.style="0" pen.width="1" ' + &
	                  'background.mode="1" ' + &
	                  'name=line' + l_SyntaxLevel + 'top ' + &
	                  'visible="1~tif(Integer(Mid(showline, ' + l_SyntaxLevel + ', 1)) = 1, 1, 0)" ' + &
                     'x1="' + String((l_Idx - 1) * i_WidthFactor + l_StartWidth) + '" y1="-1" ' + &
                     'x2="' + String((l_Idx - 1) * i_WidthFactor + l_StartWidth) + '" y2="' + &
                     String(i_HeightMidFactor) + '") '
	    l_LineSyntax = l_LineSyntax + 'create line(band=detail ' + &
	                  'pen.style="0" pen.width="1" ' + &
	                  'background.mode="1" ' + &
	                  'name=line' + l_SyntaxLevel + 'bottom ' + &
	                  'visible="0~tif(Integer(Mid(showline, ' + l_SyntaxLevel + ', 1)) = 1, ' + &
                     'if(Mid(showline [0], ' + l_SyntaxLevel + ', 1) > ' + &
                     'Mid(showline [1], ' + l_SyntaxLevel + ', 1), 0, if(unused = -1, 0, 1)), 0)" ' + &
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

//------------------------------------------------------------------
//  Build the syntax for the boxes.
//------------------------------------------------------------------

l_ShowBoxes = ' visible="1~t if(level = 1, 0, 1)" ' 
l_ShowPlus  = ' visible="1~t if(level = 1, 0, if(level [0] < level [1] and expanded [0] = 0, 1, 0))" '
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

//------------------------------------------------------------------
//  Build list of selected objects
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_Rows
   FOR l_Jdx = 1 TO i_NumSelected
      IF i_SelectedNames[l_Jdx] = dw_1.GetItemString(l_Idx, "obj_name") THEN
         dw_1.SetItem(l_Idx, "selected", "Y")
         EXIT
      END IF
   NEXT
NEXT

//------------------------------------------------------------------
//	 Modify the hierarchy.
//------------------------------------------------------------------

dw_1.Modify(l_Xstr + l_Widthstr + l_LineSyntax + l_BoxSyntax)

cb_expand.TriggerEvent(Clicked!)

end subroutine

public subroutine fw_hlcontrol (windowobject object_name, string object_parent, integer object_level, ref integer num_controls, ref string controls[], ref string control_parent[], ref string control_desc[], ref integer control_level[], ref integer control_type[], ref string control_bmp[], ref string control_tblcol[]);//******************************************************************
//  PL Module     : w_pl_register
//  Function      : fw_HLControl
//  Description   : Store information about a control in arrays that
//                  are used to construct the outliner object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

WINDOWOBJECT l_UOName
OBJECT       l_Type
DATAWINDOW   l_DW
USEROBJECT   l_UserObject
TAB          l_TabControl
STRING       l_DWName, l_DWObjects, l_DWObject, l_TabName, l_BMPDir
STRING       l_DWType, l_UOParent, l_Name, l_TabExpression
BOOLEAN      l_Finished, l_TabFound, l_POFolder
INTEGER      l_TabCnt, l_Idx, l_NumUOControls, l_Jdx, l_UOLevel, l_Pos
INTEGER      l_NumTabControls

l_BmpDir = SECCA.MGR.i_BMPPath
control_tblcol[num_controls] = ""

CHOOSE CASE Object_Name.TypeOf()
   CASE DataWindow!
      l_DW = object_name
      l_DWObjects = l_DW.Describe("datawindow.objects")
		
      //------------------------------------------------------------
      //  Determine if the datawindow is a PowerObjects tab folder.
      //------------------------------------------------------------
		
		l_POFolder = FALSE
		IF l_DW.TriggerEvent("po_identify") = 1 THEN
			IF l_DW.Dynamic fu_GetIdentity() = "Folder" THEN
				l_POFolder = TRUE
			END IF
		END IF
		
      IF NOT l_POFolder THEN
         l_Finished = FALSE
         DO
            IF l_DWObjects <> "" THEN
               IF POS(l_DWObjects, CHAR(9)) > 0 THEN
                  l_DWObject = MID(l_DWObjects, 1, POS(l_DWObjects, CHAR(9)) - 1)
               ELSE
                  l_DWObject = l_DWObjects
               END IF
               IF Left(l_DWObject, 4) <> "obj_" AND l_DWObject <> "" THEN
                  IF l_DW.Describe(l_DWObject + ".visible") <> "0" THEN
                     num_controls = num_controls + 1
                     controls[num_controls] = object_parent + "." + l_DWObject
                     control_parent[num_controls] = object_parent
                     control_desc[num_controls] = l_DWObject
                     control_level[num_controls] = object_level + 1
                     l_DWType = l_DW.Describe(l_DWObject + ".Type")
                     IF l_DWType = "column" THEN
                        control_tblcol[num_controls] = l_DW.Describe(l_DWObject + ".dbname")
							ELSE
								control_tblcol[num_controls] = ""
							END IF
                     FOR l_Idx = 1 TO SECCA.MGR.i_NumDWObjects
                        IF l_DWType = SECCA.MGR.i_ObjectDWType[l_Idx] THEN
									IF i_DoneWithWinControls THEN
                              control_type[num_controls] = 700 + l_Idx
									ELSE
										control_type[num_controls] = 100 + l_Idx
									END IF
                           control_bmp[num_controls] = l_BMPDir + SECCA.MGR.i_ObjectDWBMP[l_Idx]
                           EXIT
                        END IF
                     NEXT
                  END IF
               END IF
               IF POS(l_DWObjects, CHAR(9)) > 0 THEN
                  l_DWObjects = MID(l_DWObjects, POS(l_DWObjects, CHAR(9)) + 1)
               ELSE
                  l_Finished = TRUE
               END IF
            ELSE
               l_Finished = TRUE
            END IF
         LOOP UNTIL l_Finished
      ELSE
         l_Finished = FALSE
         l_TabCnt = 0
         DO
            IF l_DWObjects <> "" THEN
					l_TabFound = FALSE
               l_TabCnt = l_TabCnt + 1
               l_TabName = "tab_text_" + String(l_TabCnt)
               IF POS(l_DWObjects, l_TabName) > 0 THEN
						l_TabFound = TRUE
					ELSE
               	l_TabName = "tab" + String(l_TabCnt) + "_text"
               	IF POS(l_DWObjects, l_TabName) > 0 THEN
							l_TabFound = TRUE
						END IF
					END IF	
					IF l_TabFound THEN
                  l_TabExpression = l_DW.Describe(l_TabName + ".Text")
                  l_DWObject = l_DW.Describe("Evaluate(" + l_TabExpression + ", 1)")
						IF l_DWObject = "!" THEN
							l_DWObject = l_TabExpression
						END IF
						l_Pos = Pos(l_DWObject, "&")
						IF l_Pos > 0 THEN 
                  	l_DWObject = Replace(l_DWObject, l_Pos, 1, "")
						END IF
                  IF Trim(l_DWObject) <> "" THEN
                     num_controls = num_controls + 1
                     controls[num_controls] = object_parent + "." + l_DWObject
                     control_parent[num_controls] = object_parent
                     control_desc[num_controls] = l_DWObject
                     control_level[num_controls] = object_level + 1
                     control_type[num_controls] = 301
                     control_bmp[num_controls] = l_BMPDir + SECCA.MGR.i_ObjectMiscBMP[5]
							control_tblcol[num_controls] = ""

                  ELSE
                     l_Finished = TRUE
                  END IF
               ELSE
                  l_Finished = TRUE
               END IF
            ELSE
               l_Finished = TRUE
            END IF
         LOOP UNTIL l_Finished
      END IF

   CASE UserObject!

      l_UserObject = object_name
      IF l_UserObject.ObjectType = CustomVisual! THEN
         l_NumUOControls = UpperBound(l_UserObject.control[])
         FOR l_Idx = 1 TO l_NumUOControls
            l_Name = ClassName(l_UserObject.control[l_Idx])
            l_Type = l_UserObject.control[l_Idx].TypeOf()
            num_controls = num_controls + 1
            controls[num_controls] = object_parent + "." + l_Name
            control_parent[num_controls] = object_parent + "." + l_Name
            control_desc[num_controls] = l_Name
            control_level[num_controls] = object_level + 1
            FOR l_Jdx = 1 TO SECCA.MGR.i_NumObjects
               IF l_Type = SECCA.MGR.i_ObjectType[l_Jdx] THEN
						IF i_DoneWithWinControls THEN
                     control_type[num_controls] = l_Jdx + 600
						ELSE
							control_type[num_controls] = l_Jdx
						END IF
                  control_bmp[num_controls] = l_BmpDir + SECCA.MGR.i_ObjectBMP[l_Jdx]
						control_tblcol[num_controls] = ""
                  EXIT
               END IF
            NEXT
            IF l_Type = DataWindow! OR l_Type = UserObject! OR l_Type = Tab! THEN
               control_parent[num_controls] = object_parent + "." + l_Name
               IF l_Type = DataWindow! THEN
						IF i_DoneWithWinControls THEN
                     control_type[num_controls] = 700
						ELSE
							control_type[num_controls] = 100
						END IF
                  control_bmp[num_controls] = l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[1]
						control_tblcol[num_controls] = ""

              	END IF
               l_UOName   = l_UserObject.control[l_Idx]
               l_UOParent = object_parent + "." + l_Name
               l_UOLevel  = object_level + 1
               fw_HLControl(l_UOName, l_UOParent, l_UOLevel, num_controls, &
                            controls[], control_parent[], &
                            control_desc[], control_level[], &
                            control_type[], control_bmp[], &
                            control_tblcol[])
            END IF
         NEXT
      END IF
		
	CASE Tab!

      l_TabControl = object_name
      l_NumTabControls = UpperBound(l_TabControl.control[])
      FOR l_Idx = 1 TO l_NumTabControls
         l_Name = l_TabControl.control[l_Idx].ClassName()
			l_Type = l_TabControl.control[l_Idx].TypeOf()
         num_controls = num_controls + 1
         controls[num_controls] = object_parent + "." + l_Name
         control_parent[num_controls] = object_parent + "." + l_Name
         control_desc[num_controls] = l_Name
         control_level[num_controls] = object_level + 1
         FOR l_Jdx = 1 TO SECCA.MGR.i_NumObjects
            IF l_Type = SECCA.MGR.i_ObjectType[l_Jdx] THEN
				   IF i_DoneWithWinControls THEN
                  control_type[num_controls] = l_Jdx + 600
				   ELSE
						control_type[num_controls] = l_Jdx
					END IF
               control_bmp[num_controls] = l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[5]
				   control_tblcol[num_controls] = ""
               EXIT
            END IF
         NEXT
         control_parent[num_controls] = object_parent + "." + l_Name
         l_UOName   = l_TabControl.control[l_Idx]
         l_UOParent = object_parent + "." + l_Name
         l_UOLevel  = object_level + 1
         fw_HLControl(l_UOName, l_UOParent, l_UOLevel, num_controls, &
                      controls[], control_parent[], &
                      control_desc[], control_level[], &
                      control_type[], control_bmp[], &
                      control_tblcol[])
      NEXT

END CHOOSE

RETURN
end subroutine

public subroutine fw_hlmenu (menu menu_id, string menu_name, boolean popup_type, integer level, ref integer num_items, ref string menu_item[], ref string menu_parent[], ref string menu_desc[], ref integer menu_level[], ref integer menu_type[], ref string menu_bmp[], ref string menu_column[]);//******************************************************************
//  PL Module     : w_pl_register
//  Function      : fw_HLMenu
//  Description   : Store information about a menu in arrays that
//                  are used to construct the object hierarchy.
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
STRING  l_MenuName, l_BMPDir
INTEGER l_Idx, l_NumMenuItems, l_MenuLevel, l_CurPos

l_BmpDir = SECCA.MGR.i_BMPPath

l_NumMenuItems = UpperBound(menu_id.item[])
FOR l_Idx = 1 TO l_NumMenuItems
   IF menu_id.item[l_Idx].Visible = TRUE AND &
	   TRIM(menu_id.item[l_Idx].Text) <> "" THEN
      num_items = num_items + 1
      menu_item[num_items] = menu_name + "." + menu_id.item[l_Idx].ClassName()
      menu_parent[num_items] = menu_name + "." + menu_id.item[l_Idx].ClassName()

      IF menu_id.item[l_Idx].Text <> "-" THEN
     	   menu_desc[num_items] = menu_id.item[l_Idx].Text
         l_CurPos = POS(menu_id.item[l_Idx].Text, "&")
		ELSE
			IF l_NumMenuItems < l_Idx + 1 THEN
			   menu_desc[num_items] = "Bottom Separator"
			ELSE
			   menu_desc[num_items] = menu_id.item[l_Idx + 1].Text + " Separator"
			   l_CurPos = Pos(menu_id.item[l_Idx + 1].Text, "&")
			END IF
		END IF

		IF l_CurPos <> 0 THEN
         menu_desc[num_items] = Replace(menu_desc[num_items], l_CurPos, 1, "")
		END IF

	   l_CurPos = POS(menu_id.item[l_Idx].Text, CHAR(9))
		IF l_CurPos <> 0 THEN
      	menu_desc[num_items] = Left(menu_id.item[l_Idx].Text, l_CurPos - 1)
		END IF

		menu_level[num_items] = level + 1
		IF Popup_Type THEN
	      menu_type[num_items] = 501
		ELSE
			menu_type[num_items] = 201
		END IF
      menu_bmp[num_items] = l_BmpDir + SECCA.MGR.i_ObjectMiscBMP[3]
		menu_column[num_items] = ""
      IF UpperBound(menu_id.item[l_Idx].item[]) > 0 THEN
         l_MenuID = menu_id.item[l_Idx]
         l_MenuName = menu_item[num_items]
         l_MenuLevel = menu_level[num_items]
         fw_HLMenu(l_MenuID, l_MenuName, Popup_Type, l_MenuLevel, num_items, &
                   menu_item[], menu_parent[], &
                   menu_desc[], menu_level[], &
                   menu_type[], menu_bmp[], menu_column[])
      END IF
   END IF
NEXT

RETURN
end subroutine

public function integer fw_getobjtype (string object_name);//******************************************************************
//  PL Module     : w_pl_register
//  Function      : fw_GetObjType
//  Description   : Determine the object's type.
//
//  Parameters    : STRING Object_Name -
//                     The name of the object.
//
//  Return        : INTEGER - The object's type, -1 if an error 
//                            occurs.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_ObjType, l_Return

//------------------------------------------------------------------
//  Select the object's type from the security database.
//------------------------------------------------------------------

SELECT obj_type INTO :l_ObjType
	FROM pl_obj_reg
	WHERE app_key = :SECCA.MGR.i_AppKey AND
		   obj_window = :i_WindowName AND
		   obj_name = :Object_Name
	USING SECCA.MGR.i_SecTrans;
		
IF SECCA.MGR.i_SecTrans.SQLCode <> 0 THEN
	RETURN -1
END IF
		
CHOOSE CASE l_ObjType
			
   //---------------------------------------------------------------
   //  DataWindow that has not been swapped in.
   //---------------------------------------------------------------
		
   CASE 100 TO 199
		l_Return = c_DataWindow
			
   //---------------------------------------------------------------
   //  Dynamic popup menu that has not been popped.
   //---------------------------------------------------------------
		
	CASE 500 TO 599
		l_Return = c_PopupMenu
			
   //---------------------------------------------------------------
   //  Dynamic user object that has not been created.
   //---------------------------------------------------------------
	
   CASE 600 TO 799
		l_Return = c_DynamicUO
		
   //---------------------------------------------------------------
   //  Static object that has been removed from the window.
   //---------------------------------------------------------------
		
	CASE ELSE
		l_Return = c_Other
END CHOOSE

RETURN l_Return
end function

public subroutine fw_processdeletebit (integer delete_bit, ref boolean dynamic_uos, ref boolean popup_menus, ref boolean datawindows);//******************************************************************
//  PL Module     : w_pl_register
//  Function      : fw_ProcessDeleteBit
//  Description   : Determine which types of objects may be deleted.
//
//  Parameters    : INTEGER Delete_Bit -
//                     The bit value to process.
//                  BOOLEAN REF Dynamic_Uos -
//                     OK to delete dynamic user objects.
//                  BOOLEAN REF Popup_Menus -
//                     OK to delete dynamic popup menus.
//                  BOOLEAN REF Datawindows -
//                     OK to delete datawindows.
//
//  Return        : None.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE Delete_Bit
	CASE 1
		Dynamic_Uos = TRUE
	CASE 2
		Popup_Menus = TRUE
	CASE 3
		Dynamic_Uos = TRUE
		Popup_Menus = TRUE
	CASE 4
      Datawindows = TRUE
	CASE 5
		Dynamic_Uos = TRUE
		Datawindows = TRUE
	CASE 6
		Popup_Menus = TRUE
		Datawindows = TRUE
	CASE 7
		Dynamic_Uos = TRUE
		Popup_Menus = TRUE
		Datawindows = TRUE
END CHOOSE
end subroutine

public subroutine fw_hlcollapsebranch (long clickedrow);//******************************************************************
//  PLModule      : w_pl_register
//  Subroutine    : fw_HLCollapseBranch
//  Description   : Collapses the current branch of the outliner.
//
//  Parameters    : LONG - clickedrow 
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

LONG  l_FindRow, l_RowCount, l_EndRow, l_FromRow
INTEGER l_CurrentLevel, l_NextLevel

l_RowCount = dw_1.RowCount()

//------------------------------------------------------------------
//  If the last row in the outliner is selected then we only need to
//  collapse the current row. 
//------------------------------------------------------------------

IF ClickedRow = l_RowCount THEN
	dw_1.SetItem(ClickedRow, "expanded", 0)
	RETURN
END IF

//------------------------------------------------------------------
//  Get the current level and the next level.  If the next level
//  is less than or equal to the current level then we only need to
//  collapse the current row.
//------------------------------------------------------------------

l_CurrentLevel = dw_1.GetItemNumber(ClickedRow, "Level")
l_NextLevel    = dw_1.GetItemNumber(ClickedRow + 1, "level")

IF l_NextLevel <= l_CurrentLevel THEN
	dw_1.SetItem(ClickedRow, "expanded", 0)
	RETURN
END IF

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//dw_1.SetRedraw(FALSE)

//------------------------------------------------------------------
//  Set the current rows attributes to be collapsed.
//------------------------------------------------------------------

dw_1.SetItem(ClickedRow, "expanded", 0)

//------------------------------------------------------------------
//  Find the last row in the next levels group that needs to be 
//  collapsed. 
//------------------------------------------------------------------

l_EndRow = dw_1.Find("level <= " + String(l_CurrentLevel), &
                     ClickedRow + 1, l_RowCount)

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

dw_1.SetDetailHeight(ClickedRow + 1, l_EndRow, 0)

l_FindRow = ClickedRow
DO
	l_FromRow = l_FindRow + 1
	l_FindRow = dw_1.Find("expanded = 1", l_FromRow, l_EndRow)
	IF l_FindRow > 0 THEN
     	dw_1.SetItem(l_FindRow, "expanded", 0)
	END IF
LOOP WHILE l_FindRow > 0 AND l_FindRow < l_EndRow

//dw_1.SetRedraw(TRUE)
end subroutine

public subroutine fw_hlcollapselevel (integer level);//******************************************************************
//  PL Module     : w_pl_register
//  Subroutine    : fw_HLCollapseLevel
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
l_RowCount = dw_1.RowCount()

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//dw_1.SetRedraw(FALSE)

//------------------------------------------------------------------
//  Cycle through each record and determine if the level is
//  greater than or equal to the given level.
//------------------------------------------------------------------

FOR l_Idx = 1 to l_RowCount
	l_Level = dw_1.GetItemNumber(l_Idx, "level")
	IF l_Level >= Level THEN

      //------------------------------------------------------------
      //  If the level is 1 then collapse it but don't set the
      //  row height to 0.
      //------------------------------------------------------------

      IF l_Level = 1 THEN
		   dw_1.SetItem(l_Idx, "expanded", 0)
		   dw_1.SetDetailHeight(l_Idx, l_Idx, i_HeightFactor)
  	   ELSE
       dw_1.SetItem(l_Idx, "expanded", 0)
		 dw_1.SetDetailHeight(l_Idx, l_Idx, 0)
      END IF
	END IF
NEXT

//dw_1.SetRedraw(TRUE)		
end subroutine

public subroutine fw_hlexpandall ();//******************************************************************
//  PL Module     : w_pl_register
//  Subroutine    : fw_HLExpandAll
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
l_RowCount = dw_1.RowCount()

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//dw_1.SetRedraw(FALSE)

//-------------------------------------------------------------------
//  Set the expanded attributes for any row that isn't already 
//  expanded.
//-------------------------------------------------------------------

l_FindRow = 0
DO
	l_FromRow = l_FindRow + 1
	l_FindRow = dw_1.Find("expanded = 0", l_FromRow, l_RowCount)
	IF l_FindRow > 0 THEN
		dw_1.SetItem(l_FindRow, "expanded", 1)
	END IF
LOOP WHILE l_FindRow > 0 AND l_FindRow < l_RowCount

//-------------------------------------------------------------------
//  Setting the detail height for all of the rows at once is much
//  faster than just setting for the rows that need it individually.
//-------------------------------------------------------------------

dw_1.SetDetailHeight(1, l_RowCount, i_HeightFactor)

//dw_1.SetRedraw(TRUE)		
end subroutine

public subroutine fw_hlexpandlevel (long clickedrow);//******************************************************************
//  PL Module     : w_pl_register
//  Subroutine    : fw_HLExpandLevel
//  Description   : Expands to the next level.
//
//  Parameters    : LONG - ClickedRow
//
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
INTEGER l_Level, l_CurrentLevel, l_NextLevel
LONG    l_RowCount, l_Error, l_EndRow, l_Idx
LONG    l_NewRowCount, l_FromRow, l_FindRow
STRING  l_Key, l_DataSyntax, l_Return

l_RowCount     = dw_1.RowCount()

l_CurrentLevel = dw_1.GetItemNumber(ClickedRow, "Level")

//-------------------------------------------------------------------
//  If the level is the lowest level or were on the last row in the
//  outliner then return. 
//-------------------------------------------------------------------

IF l_CurrentLevel = i_NumLevels OR &
   ClickedRow = l_RowCount THEN
	RETURN
END IF

//-------------------------------------------------------------------
//  PowerBuilder 6.0 Bug
//
//  Setting redraw in conjunction with SetDetailHeight causes the
//  DataWindow to scroll back to the top row.  Will comment this out
//  until this is fixed.
//-------------------------------------------------------------------

//dw_1.SetRedraw(FALSE)

//-------------------------------------------------------------------
//  Find all the rows and set their expand attributes on.
//-------------------------------------------------------------------

dw_1.SetItem(ClickedRow, "expanded", 1) 


//----------------------------------------------------------------
//  Set the expand attribute on for all the rows in the next
//  level.
//----------------------------------------------------------------

l_EndRow = dw_1.Find("level <= " + String(l_CurrentLevel), &
           ClickedRow + 1, l_RowCount)

IF l_EndRow = 0 THEN
   l_EndRow = l_RowCount
ELSE
   l_EndRow = l_EndRow - 1
END IF

IF l_CurrentLevel + 1 = i_NumLevels THEN
	dw_1.SetDetailHeight(ClickedRow + 1, l_EndRow, i_HeightFactor)
ELSE
	l_FindRow = ClickedRow
	DO
	  l_FromRow = l_FindRow + 1
	  l_FindRow = dw_1.Find("level = " + String(l_CurrentLevel + 1), &
   			  	  l_FromRow, l_EndRow)
	   IF l_FindRow > 0 THEN
			dw_1.SetDetailHeight(l_FindRow, l_FindRow, i_HeightFactor)
		END IF
	LOOP WHILE l_FindRow > 0 AND l_FindRow < l_EndRow
END IF

//dw_1.SetRedraw(TRUE)



end subroutine

public subroutine fw_hlsetlastingroup (datawindow dwcontrol);//******************************************************************
//  PL Module     : u_Outliner
//  Subroutine    : fu_HLSetLastInGroup
//  Description   : Calculates the records that are last in a group
//                  for the purpose of correctly drawing lines.
//
//  Parameters    : DATAWINDOW Dwcontrol -
//                     The datawindow control.
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

LONG    l_RowCount, l_Idx, l_Jdx
INTEGER l_CurrentLevel, l_NextLevel
STRING  l_CurrentLine, l_LineString, l_NextLine
BOOLEAN l_LastLevelTwo

l_RowCount  = dwcontrol.RowCount()
l_LineString = Fill("0", i_NumLevels)
l_LastLevelTwo = FALSE

FOR l_Idx = l_RowCount TO 2 STEP -1
	l_CurrentLevel = DwControl.GetItemNumber(l_Idx, "level")
   l_CurrentLine = l_LineString
   IF l_Idx < l_RowCount THEN
		l_NextLevel = DwControl.GetItemNumber(l_Idx + 1, "level")
      IF l_CurrentLevel = 1 THEN
         l_CurrentLine = l_LineString
      ELSEIF l_CurrentLevel < l_NextLevel THEN
         l_CurrentLine = Replace(l_NextLine, l_CurrentLevel, i_NumLevels - l_CurrentLevel + 1, Fill("0", i_NumLevels - l_CurrentLevel + 1))
         l_CurrentLine = Replace(l_CurrentLine, l_CurrentLevel - 1, 1, "1")
      ELSEIF l_CurrentLevel = l_NextLevel THEN
         l_CurrentLine = l_NextLine
      ELSE
         l_CurrentLine = Replace(l_NextLine, l_CurrentLevel - 1, 1, "1")
         IF l_NextLevel = 1 THEN
            l_CurrentLine = Replace(l_CurrentLine, 1, 1, "1")
         END IF
      END IF
      IF l_CurrentLevel = 2 AND NOT l_LastLevelTwo THEN
         l_LastLevelTwo = TRUE
         IF l_NextLevel > 1 THEN
				DwControl.SetItem(l_Idx, "unused", -1)
         END IF
      END IF 
   ELSE
      IF l_CurrentLevel > 1 THEN
         l_CurrentLine = Replace(l_CurrentLine, l_CurrentLevel - 1, 1, "1")
      END IF
   END IF
	DwControl.SetItem(l_Idx, "showline", l_CurrentLine)
   l_NextLine = l_CurrentLine
NEXT   

DwControl.SetItem(1, "showline", l_LineString)
DwControl.SetItem(l_RowCount, "unused", -1)
end subroutine

public subroutine fw_hlselectall ();//******************************************************************
//  PL Module     : w_pl_register
//  Function      : fw_HLSelectAll
//  Description   : Selects all rows in the outliner.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Rows

//------------------------------------------------------------------
//  If Select All button or menu selected, mark all level 2 rows
//  except menus as selected.
//------------------------------------------------------------------

l_Rows = dw_1.RowCount()
FOR l_Idx = 1 TO l_Rows
   IF dw_1.GetItemNumber(l_Idx, "obj_type") = 200 OR &
      dw_1.GetItemNumber(l_Idx, "obj_type") = 500 OR l_Idx = 1 THEN
      dw_1.SetItem(l_Idx, "selected", "N")
   ELSE
      dw_1.SetItem(l_Idx, "selected", "Y")
   END IF
NEXT

//------------------------------------------------------------------
//  Modify the background color depending upon whether or not the
//  row is selected.
//------------------------------------------------------------------

dw_1.Modify("datawindow.verticalscrollposition=" + &
            String(i_ScrollPosition))
dw_1.Modify("obj_desc.BackGround.Color = '" + i_BackColor + &
            "~t(if(selected =~"Y~", " + i_HighColor + ", " + &
				i_BackColor + "))'")
dw_1.Modify("obj_desc.Color = '" + i_TextColor + &
            "~t(if(selected =~"Y~", " + i_ForeColor + ", " + &
				i_TextColor + "))'")

RETURN

end subroutine

public subroutine fw_hlclearall ();//******************************************************************
//  PL Module     : w_pl_register
//  Function      : fw_HLClearAll
//  Description   : Unselects all rows in the outliner.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Rows

//------------------------------------------------------------------
//  If Clear All button or menu selected, mark all rows as 
//  unselected.
//------------------------------------------------------------------

l_Rows = dw_1.RowCount()
FOR l_Idx = 1 TO l_Rows
   dw_1.SetItem(l_Idx, "selected", "N")
NEXT

//------------------------------------------------------------------
//  Modify the background color depending upon whether or not the
//  row is selected.
//------------------------------------------------------------------

dw_1.Modify("datawindow.verticalscrollposition=" + &
            String(i_ScrollPosition))
dw_1.Modify("obj_desc.BackGround.Color = '" + i_BackColor + &
            "~t(if(selected =~"Y~", " + i_HighColor + ", " + &
				i_BackColor + "))'")
dw_1.Modify("obj_desc.Color = '" + i_TextColor + &
            "~t(if(selected =~"Y~", " + i_ForeColor + ", " + &
				i_TextColor + "))'")

RETURN

end subroutine

event resize;//******************************************************************
//  PL Module     : w_pl_register
//  Event         : Resize
//  Description   : Resize all the controls on the window when the
//                  window is resized.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER         l_NewWidth,       l_NewHeight,  l_Idx, l_NumControls
INTEGER         l_X[6],           l_Width[6]
REAL            l_NewRatioX,      l_NewRatioY
REAL            l_NewScaleX,      l_NewScaleY
DRAGOBJECT      l_WinObj
STRING          l_Comma, l_Paren, l_Widthstr

IF THIS.WindowState = Minimized! THEN RETURN

SetRedraw(FALSE)

l_NewWidth  = WorkSpaceWidth()
l_NewHeight = WorkSpaceHeight()

//------------------------------------------------------------
//  Calculate the ratio of the new size to the original size.
//------------------------------------------------------------

l_NewScaleX = l_NewWidth  / i_Width
l_NewScaleY = l_NewHeight / i_Height

i_Width  = l_NewWidth
i_Height = l_NewHeight

//------------------------------------------------------------
//  Fix the size of the controls
//------------------------------------------------------------

l_NumControls = UpperBound(Control[])
FOR l_Idx = 1 TO l_NumControls
    l_WinObj = Control[l_Idx]
    Move(l_WinObj, l_NewScaleX * l_WinObj.X, &
                   l_NewScaleY * l_WinObj.Y)
    Resize(l_WinObj, l_NewScaleX * l_WinObj.Width, &
                     l_NewScaleY * l_WinObj.Height)
NEXT

l_X[1] = 97
l_Width[1] = dw_1.Width - l_X[1]
l_Widthstr = "obj_desc.width = '" + string(l_Width[1]) + "~t("
l_Comma = ""
l_Paren = ")"
FOR l_Idx = 2 TO 6
   l_X[l_Idx] = l_X[l_idx - 1] + 76
   l_Width[l_Idx] = dw_1.Width - l_X[l_Idx]
   l_Widthstr = l_Widthstr + l_comma + "if(level = " + string(l_Idx) + ", " + string(l_Width[l_Idx])
   l_Paren = l_Paren + ")"
   l_Comma = "," 
NEXT
l_Widthstr = l_Widthstr + ", " + string(l_Width[1]) + l_Paren + "'"

dw_1.Modify(l_Widthstr)
dw_1.Modify("obj_desc.BackGround.Color = '" + i_BackColor + "~t(if(selected =~"Y~", " + i_HighColor + ", " + i_BackColor + "))'")
dw_1.Modify("obj_desc.Color = '" + i_TextColor + "~t(if(selected =~"Y~", " + i_ForeColor + ", " + i_TextColor + "))'")

SetRedraw(TRUE)

end event

event open;//******************************************************************
//  PL Module     : w_pl_register
//  Event         : Open
//  Description   : Initialize the list of window controls.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

ENVIRONMENT l_Env
INTEGER l_ScreenWidth, l_ScreenHeight

i_CurrentWindow = Message.PowerObjectParm

//------------------------------------------------------------------
//  Center the window on the screen.
//------------------------------------------------------------------

GetEnvironment(l_Env)

l_ScreenWidth = PixelsToUnits(l_Env.ScreenWidth, xPixelsToUnits!)
l_ScreenHeight = PixelsToUnits(l_Env.ScreenHeight, yPixelsToUnits!)

Move((l_ScreenWidth - Width ) / 2, (l_ScreenHeight - Height) / 2)

//------------------------------------------------------------------
//  Initialize the window.
//------------------------------------------------------------------

i_Width = WorkSpaceWidth()
i_Height = WorkSpaceHeight()
Title = SECCA.MGR.i_ProgName + " " + Title

fw_HLInit()
end event

on w_pl_register.create
this.dw_1=create dw_1
this.st_2=create st_2
this.cbx_delete=create cbx_delete
this.cb_collapse=create cb_collapse
this.cb_expand=create cb_expand
this.st_1=create st_1
this.cb_clear=create cb_clear
this.cb_select=create cb_select
this.cb_print=create cb_print
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.dw_1,&
this.st_2,&
this.cbx_delete,&
this.cb_collapse,&
this.cb_expand,&
this.st_1,&
this.cb_clear,&
this.cb_select,&
this.cb_print,&
this.cb_cancel,&
this.cb_ok}
end on

on w_pl_register.destroy
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.cbx_delete)
destroy(this.cb_collapse)
destroy(this.cb_expand)
destroy(this.st_1)
destroy(this.cb_clear)
destroy(this.cb_select)
destroy(this.cb_print)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type dw_1 from datawindow within w_pl_register
integer x = 50
integer y = 100
integer width = 1134
integer height = 812
integer taborder = 10
string dataobject = "d_register"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_register
//  Event         : dw_1.clicked
//  Description   : A row has been selected in the outliner object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************


LONG l_Idx, l_BeginRow, l_EndRow, l_PreviousRow, l_Type
LONG l_ClickedRow
BOOLEAN l_KeyCtrlDown, l_KeyShftDown

l_KeyCtrlDown = KeyDown(KeyControl!)
l_KeyShftDown = KeyDown(KeyShift!)
l_ClickedRow = Row

IF l_ClickedRow <= 0 THEN
   RETURN
END IF

l_Type = GetItemNumber(dw_1, l_ClickedRow, "obj_type")

//-------------------------------------------------------------------
//  If object type is window, menu or popup menu, it cannot be selected.
//-------------------------------------------------------------------

IF l_Type = 0 OR l_Type = 200 OR l_Type = 500 THEN
   RETURN
END IF

//-------------------------------------------------------------------
//  CTRL key.  If the current record is selected, deselect it.
//-------------------------------------------------------------------

IF l_KeyCtrlDown THEN 

   l_PreviousRow = i_CurrentRow
   i_CurrentRow = l_ClickedRow

	IF GetItemString(dw_1, i_CurrentRow, "selected") = "Y" THEN
      SetItem(dw_1, i_CurrentRow, "selected", "N")
      i_AnchorRow = 0
   ELSE
      SetItem(dw_1, i_CurrentRow, "selected", "Y")
      i_AnchorRow = i_CurrentRow
   END IF

   i_Modified = TRUE
   dw_1.Modify("obj_desc.BackGround.Color = '" + i_BackColor + &
	            "~t(if(selected =~"Y~", " + i_HighColor + ", " + &
					i_BackColor + "))'")
   dw_1.Modify("obj_desc.Color = '" + i_TextColor + &
	            "~t(if(selected =~"Y~", " + i_ForeColor + ", " + &
					i_TextColor + "))'")

//-------------------------------------------------------------------
//  SHIFT key.  If record is already selected, then select all
//	 records between that record and the current record.
//-------------------------------------------------------------------

ELSEIF l_KeyShftDown THEN

   l_PreviousRow = i_CurrentRow
   i_CurrentRow = l_ClickedRow

   IF i_AnchorRow = 0 THEN
      i_AnchorRow = i_CurrentRow  
   END IF

   IF i_CurrentRow >= i_AnchorRow THEN
      l_BeginRow = i_AnchorRow
      l_EndRow = i_CurrentRow
   ELSE
      l_EndRow = i_AnchorRow
      l_BeginRow = i_CurrentRow
   END IF

   FOR l_Idx = l_BeginRow TO l_EndRow
      IF l_Type <> 0 AND l_Type <> 200 AND l_Type <> 500 THEN
         SetItem(dw_1, l_Idx, "selected", "Y")
      END IF 
   NEXT

   i_Modified = TRUE
   dw_1.Modify("obj_desc.BackGround.Color = '" + i_BackColor + &
	            "~t(if(selected =~"Y~", " + i_HighColor + ", " + &
					i_BackColor + "))'")
   dw_1.Modify("obj_desc.Color = '" + i_TextColor + &
	            "~t(if(selected =~"Y~", " + i_ForeColor + ", " + &
					i_TextColor + "))'")
END IF
end event

event doubleclicked;//******************************************************************
//  PL Module     : w_pl_register
//  Event         : dw_1.DoubleClicked
//  Description   : Expand or collapse level in hierarchy.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//-----------------------------------------------------------------
//  Determine whether to expand or collapse.
//-----------------------------------------------------------------

SetPointer(HourGlass!)

IF Row <= 0 THEN
   RETURN
END IF

IF THIS.GetItemNumber(Row, "expanded") = 1 THEN
   fw_HLCollapseBranch(Row)
ELSE
   fw_HLExpandLevel(Row)
END IF

SetPointer(Arrow!)

end event

type st_2 from statictext within w_pl_register
integer x = 160
integer y = 940
integer width = 695
integer height = 52
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 80269524
boolean enabled = false
string text = "Delete Registered Objects"
boolean focusrectangle = false
end type

type cbx_delete from checkbox within w_pl_register
integer x = 64
integer y = 940
integer width = 82
integer height = 64
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
end type

type cb_collapse from commandbutton within w_pl_register
integer x = 1248
integer y = 204
integer width = 334
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Co&llapse All"
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_register.cb_Collapse
//  Event         : Clicked
//  Description   : Collapse all records in the outliner.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SetPointer(HourGlass!)
dw_1.SetReDraw(FALSE)

fw_HLCollapseBranch(1)

dw_1.ScrollToRow(1)
dw_1.SetReDraw(TRUE)
SetPointer(Arrow!)
end event

type cb_expand from commandbutton within w_pl_register
integer x = 1248
integer y = 100
integer width = 334
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Expand All"
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_register.cb_Expand
//  Event         : Clicked
//  Description   : Expand to all records in the outliner.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SetPointer(HourGlass!)
dw_1.SetReDraw(FALSE)

fw_HLExpandAll()

dw_1.ScrollToRow(1)
dw_1.SetReDraw(TRUE)
SetPointer(Arrow!)
end event

type st_1 from statictext within w_pl_register
integer x = 137
integer y = 20
integer width = 946
integer height = 68
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean enabled = false
string text = "Use CTRL + Click to select objects"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_clear from commandbutton within w_pl_register
integer x = 1248
integer y = 464
integer width = 334
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Clear &All"
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_register.cb_Clear
//  Event         : Clicked
//  Description   : Clear all selected records in the outliner.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SetPointer(HourGlass!)
dw_1.SetReDraw(FALSE)

fw_HLClearAll()
i_Modified = TRUE

dw_1.SetReDraw(TRUE)
SetPointer(Arrow!)
end event

type cb_select from commandbutton within w_pl_register
integer x = 1248
integer y = 356
integer width = 334
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Select All"
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_register.cb_Select
//  Event         : Clicked
//  Description   : Select all records in the outliner.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SetPointer(HourGlass!)
dw_1.SetReDraw(FALSE)

fw_HLSelectAll()
i_Modified = TRUE

dw_1.SetReDraw(TRUE)
SetPointer(Arrow!)
end event

type cb_print from commandbutton within w_pl_register
integer x = 1248
integer y = 612
integer width = 334
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Print"
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_register.cb_Print
//  Event         : Clicked
//  Description   : Print the contents of the outliner.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

dw_1.Print()
end event

type cb_cancel from commandbutton within w_pl_register
integer x = 1248
integer y = 832
integer width = 334
integer height = 84
integer taborder = 80
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_register.cb_Cancel
//  Event         : Clicked
//  Description   : Cancel the record operations and hide the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

Parent.Visible = FALSE
cbx_delete.Checked = FALSE

i_Modified = FALSE
i_FromOutsideObject = FALSE

IF IsValid(i_CurrentWindow) THEN
  	i_CurrentWindow.SetFocus()
END IF

end event

type cb_ok from commandbutton within w_pl_register
integer x = 1248
integer y = 724
integer width = 334
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&OK"
boolean default = true
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_register.cb_OK
//  Event         : Clicked
//  Description   : Save the selected objects to the security
//                  database and hide the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

STRING l_Selected, l_ObjectName, l_ObjectParent, l_Object
STRING l_WindowName, l_ParentName, l_ObjectDesc, l_ObjectTblCol
INTEGER l_Rows, l_Return, l_Idx, l_ObjectType, l_Jdx, l_Used[]
INTEGER l_StartPos, l_EndPos, l_RowNbr
BOOLEAN l_Found, l_DeleteUOs, l_DeleteMenus
BOOLEAN l_DeleteDWs, l_DeleteOK
WINDOW  l_Window

SetPointer(HourGlass!)

//------------------------------------------------------------------
//  If the delete registered objects checkbox has been checked, open
//  up a window to allow the user to tell us what types of objects
//  should be cleaned up.
//------------------------------------------------------------------

IF cbx_delete.Checked THEN
   l_Object = SECCA.DEF.fu_GetDefault("Security", "Delete")
	IF l_Object <> "" THEN
		Open(l_Window, l_Object)
	ELSE
		RETURN
	END IF
	i_DeleteBit = Message.DoubleParm

	IF i_DeleteBit < 0 THEN
		RETURN
	ELSE
		l_DeleteUOs = FALSE
		l_DeleteMenus = FALSE
		l_DeleteDWs = FALSE
      fw_ProcessDeleteBit(i_DeleteBit, &
								  l_DeleteUOs, &
								  l_DeleteMenus, &
								  l_DeleteDWs)
	END IF
END IF

dw_1.SetReDraw(FALSE)

//------------------------------------------------------------------
//  Only save objects in the security database that are currently
//  registered.
//------------------------------------------------------------------

l_Return = SECCA.MGR.fu_DeleteNonRegObjects(i_WindowName, &
                                            l_DeleteUOs, &
														  l_DeleteMenus, &
														  l_DeleteDWs)
IF l_Return = -1 THEN
   RETURN
END IF

FOR l_Idx = 1 TO i_NumSelected
   l_Used[l_Idx] = 0
NEXT

l_Rows = dw_1.RowCount()
FOR l_Idx = 1 TO l_Rows
   IF dw_1.GetItemString(l_Idx, "selected") = "Y" THEN
      l_ObjectName   = dw_1.GetItemString(l_Idx, "obj_name")
      l_Found = FALSE
      FOR l_Jdx = 1 TO i_NumSelected
         IF i_SelectedNames[l_Jdx] = l_ObjectName THEN
            l_Used[l_Jdx] = 1
            l_Found = TRUE
            EXIT
         END IF
      NEXT
		l_ObjectTblCol = ""
      IF NOT l_Found THEN
         l_ObjectType   = dw_1.GetItemNumber(l_Idx, "obj_type")
         l_ObjectDesc   = dw_1.GetItemString(l_Idx, "obj_desc")
         l_ObjectTblCol = dw_1.GetItemString(l_Idx, "obj_tblcol")

         l_Return = SECCA.MGR.fu_SetRegObjects(l_ObjectName, &
                                               l_ObjectDesc, &
                                               l_ObjectType, &
                                               i_WindowName, &
                                               l_ObjectTblCol)
         IF l_Return = -1 THEN
            EXIT
         END IF
      END IF

      IF Pos(l_ObjectName, ".") > 0 THEN
         l_StartPos = 1
         DO
            l_EndPos = POS(l_ObjectName, ".", l_StartPos)
            IF l_EndPos > 0 THEN
               l_ObjectParent = MID(l_ObjectName, 1, l_EndPos - 1)
               l_RowNbr = dw_1.Find("obj_name = '" + l_ObjectParent + "'", 1, l_Idx)
					IF l_RowNbr > 0 THEN
	               IF dw_1.GetItemString(l_RowNbr, "selected") = "N" THEN
							l_Return = SECCA.MGR.fu_SetPlaceHolder(i_WindowName, &
							                                       l_ObjectParent)
							IF l_Return = 100 THEN
	                     l_ObjectType   = dw_1.GetItemNumber(l_RowNbr, "obj_type") * -1
	                     l_ObjectDesc   = dw_1.GetItemString(l_RowNbr, "obj_desc")
	                     l_ObjectTblCol = dw_1.GetItemString(l_RowNbr, "obj_tblcol")
	                     l_Return = SECCA.MGR.fu_SetRegObjects(l_ObjectParent, &
	                                                           l_ObjectDesc, &
	                                                           l_ObjectType, &
	                                                           i_WindowName, &
	                                                           l_ObjectTblCol)
							END IF
                     FOR l_Jdx = 1 TO i_NumSelected
                        IF i_SelectedNames[l_Jdx] = l_ObjectParent THEN
                           l_Used[l_Jdx] = 1
                        EXIT
                        END IF
                     NEXT
	                  IF l_Return = -1 THEN
	                     EXIT
	                  END IF
						END IF
               END IF
               l_StartPos = l_EndPos + 1
            END IF
         LOOP UNTIL l_EndPos = 0
      END IF             
   END IF
NEXT

//------------------------------------------------------------------
//  Clean up any objects that are no longer registered.
//------------------------------------------------------------------

IF l_Return = 0 THEN
   FOR l_Idx = 1 TO i_NumSelected
      IF l_Used[l_Idx] = 0 THEN
			l_DeleteOK = FALSE
		   l_RowNbr = dw_1.Find("obj_name = '" + &
					               i_SelectedNames[l_Idx] + "'", &
										1, &
										l_Rows)
			IF l_RowNbr > 0 THEN
				
            //------------------------------------------------------
            //  OK to delete objects that are listed, but are no
            //  longer selected.
            //------------------------------------------------------
				
				l_DeleteOK = TRUE
         ELSE
				
            //------------------------------------------------------
            //  Only OK to delete objects that are not listed if the
            //  user told us to.
            //------------------------------------------------------
				
				l_Return = fw_GetObjType(i_SelectedNames[l_Idx])
				CHOOSE CASE l_Return
					CASE c_DynamicUO
						l_DeleteOK = l_DeleteUOs AND cbx_delete.Checked
					CASE c_PopupMenu
						l_DeleteOK = l_DeleteMenus AND cbx_delete.Checked
					CASE c_DataWindow
						l_DeleteOK = l_DeleteDWs AND cbx_delete.Checked
					CASE c_Other
							
                  //------------------------------------------------ 
                  //  OK to delete static objects that have been
                  //  removed from the window.
                  //------------------------------------------------
							
						l_DeleteOK = TRUE
					CASE -1
						EXIT
				END CHOOSE
         END IF
         IF l_DeleteOK THEN
         	l_Return = SECCA.MGR.fu_DeleteRegObjects(i_WindowName, &
                                    i_SelectedNames[l_Idx])
				IF l_Return = -1 THEN
					EXIT
				END IF
			END IF
      END IF
   NEXT

   IF l_Return = -1 THEN
      SECCA.MGR.fu_Rollback()
   ELSE
      SECCA.MGR.fu_Commit()
   END IF
END IF

IF i_Modified THEN

   //---------------------------------------------------------------
   // Reset the count and array of selected objects.
   //---------------------------------------------------------------
	
   i_NumSelected = SECCA.MGR.fu_GetRegObjects(i_WindowName, &
                                              i_SelectedNames[])
END IF

IF NOT i_FromOutsideObject THEN
  	Parent.Visible     = FALSE
	cbx_delete.Checked = FALSE
END IF
	
i_Modified          = FALSE
i_FromOutsideObject = FALSE

IF IsValid(i_CurrentWindow) THEN
  	i_CurrentWindow.SetFocus()
END IF

dw_1.SetReDraw(TRUE)
SetPointer(Arrow!)

end event

