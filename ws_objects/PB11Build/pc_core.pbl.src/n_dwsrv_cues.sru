$PBExportHeader$n_dwsrv_cues.sru
$PBExportComments$DataWindow service for visual cues handling
forward
global type n_dwsrv_cues from n_dwsrv_main
end type
end forward

global type n_dwsrv_cues from n_dwsrv_main
end type
global n_dwsrv_cues n_dwsrv_cues

type variables
//-----------------------------------------------------------------------------------------
//  Visual Cues Service Constants
//-----------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------
//  Visual Cues Service Instance Variables
//-----------------------------------------------------------------------------------------

BOOLEAN		i_BatchMode		= FALSE
STRING			i_BatchString

STRING			i_ViewMode
STRING			i_NormalMode
STRING			i_InactiveColumnMode
STRING			i_InactiveTextMode
STRING			i_ActiveColumnMode
STRING			i_ActiveTextMode

INTEGER		i_InactiveState
end variables

forward prototypes
public subroutine fu_buildinactivemode (unsignedlong inactive_color, boolean inactive_text, boolean inactive_col, boolean inactive_line)
public subroutine fu_setattribute (string column_name, integer attribute_type, string attribute_value)
public subroutine fu_setattribute (string column_name, integer attribute_type, unsignedlong attribute_value)
public subroutine fu_batchattributes (integer batch_state)
public subroutine fu_setinactivemode (integer inactive_state)
public subroutine fu_setviewmode (integer view_state)
public subroutine fu_buildviewmode (unsignedlong view_color, string view_border)
end prototypes

public subroutine fu_buildinactivemode (unsignedlong inactive_color, boolean inactive_text, boolean inactive_col, boolean inactive_line);//******************************************************************
//  PC Module     : n_DWSRV_CUES
//  Subroutine    : fu_BuildInactiveMode
//  Description   : Build a string that can be given to MODIFY
//                  that changes the DataWindow objects color
//                  when the DataWindow becomes inactive.
//
//  Parameters    : ULONG   Inactive_Color -
//                     Color to use for inactive mode.
//                  BOOLEAN Inactive_Text -
//                     Only inactivate text.
//                  BOOLEAN Inactive_Col -
//                     Only inactivate columns.
//                  BOOLEAN Inactive_Line -
//                     Only inactivate lines, rectangles, etc.
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

STRING  l_Color, l_Objects, l_Object, l_Type, l_Attr
INTEGER l_Pos

//------------------------------------------------------------------
//  Get the string of objects from the DataWindow.
//------------------------------------------------------------------

l_Objects = i_ServiceDW.Describe("datawindow.objects")

//------------------------------------------------------------------
//  Build a string for inactive mode and active mode.
//------------------------------------------------------------------

i_InactiveTextMode = ""
i_InactiveColumnMode = ""
i_ActiveTextMode = ""
i_ActiveColumnMode = ""
l_Color = String(inactive_color)
DO
	l_Pos = Pos(l_Objects, "~t")
	IF l_Pos > 0 THEN
		l_Object = MID(l_Objects, 1, l_Pos - 1)
		l_Objects = MID(l_Objects, l_Pos + 1)
	ELSE
		l_Object = l_Objects
		l_Objects = ""
	END IF

	IF i_ServiceDW.Describe(l_Object + ".visible") <> "0" THEN
		l_Type = Upper(i_ServiceDW.Describe(l_Object + ".type"))

		IF l_Type = "COLUMN" AND inactive_col THEN
			l_Attr = i_ServiceDW.Describe(l_Object + ".color")
			IF Pos(l_Attr, '"') = 1 THEN
				l_Attr = MID(l_Attr, 2, Len(l_Attr) - 2)
			END IF

			i_ActiveColumnMode = i_ActiveColumnMode + l_Object + ".color='" + &
				l_Attr + "'~t"
			i_InactiveColumnMode = i_InactiveColumnMode + l_Object + ".color='" + &
				l_Color + "'~t"
		ELSEIF l_Type = "COMPUTE" AND inactive_col THEN
			l_Attr = i_ServiceDW.Describe(l_Object + ".color")
			IF Pos(l_Attr, '"') = 1 THEN
				l_Attr = MID(l_Attr, 2, Len(l_Attr) - 2)
			END IF

			i_ActiveTextMode = i_ActiveTextMode + l_Object + ".color='" + &
				l_Attr + "'~t"
			i_InactiveTextMode = i_InactiveTextMode + l_Object + ".color='" + &
				l_Color + "'~t"
		ELSEIF l_Type = "TEXT" AND inactive_text THEN
			l_Attr = i_ServiceDW.Describe(l_Object + ".color")
			IF Pos(l_Attr, '"') = 1 THEN
				l_Attr = MID(l_Attr, 2, Len(l_Attr) - 2)
			END IF

			i_ActiveTextMode = i_ActiveTextMode + l_Object + ".color='" + &
				l_Attr + "'~t"
			i_InactiveTextMode = i_InactiveTextMode + l_Object + ".color='" + &
				l_Color + "'~t"		
		ELSEIF (l_Type = "LINE" OR l_Type = "ELLIPSE" OR &
				 l_Type = "RECTANGLE" OR l_Type = "ROUNDRECTANGLE") AND &
 				 inactive_line THEN
			l_Attr = i_ServiceDW.Describe(l_Object + ".pen.color")
			IF Pos(l_Attr, '"') = 1 THEN
				l_Attr = MID(l_Attr, 2, Len(l_Attr) - 2)
			END IF

			i_ActiveTextMode = i_ActiveTextMode + l_Object + ".pen.color='" + &
				l_Attr + "'~t"
			i_InactiveTextMode = i_InactiveTextMode + l_Object + ".pen.color='" + &
				l_Color + "'~t"
		END IF
	END IF

LOOP UNTIL l_Objects = ""
end subroutine

public subroutine fu_setattribute (string column_name, integer attribute_type, string attribute_value);//******************************************************************
//  PC Module     : n_DWSRV_CUES
//  Subroutine    : fu_SetAttribute
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
//                     The value to set the attribute with.  If this
//                     is a border then the values are:
//                        c_NoBorder
//                        c_ShadowBox
//                        c_Box
//                        c_Resize
//                        c_Underline
//                        c_Lowered
//                        c_Raised
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

STRING l_Modify, l_Border
LONG   l_Pos, l_Len

CHOOSE CASE attribute_type

	CASE c_ColorAttribute

		l_Modify = column_name + ".color='" + attribute_value + "'"
		IF i_BatchMode THEN
			i_BatchString = i_BatchString + l_Modify + "~t"
		ELSE
			i_ServiceDW.Modify(l_Modify)
		END IF

		//------------------------------------------------------------
		//  Put the new value in the i_ActiveMode string
		//------------------------------------------------------------

		l_Pos = Pos(i_ActiveColumnMode, column_name + ".color")
		IF l_Pos > 0 THEN
			l_Len = Len(Mid(i_ActiveColumnMode, l_Pos, &
                 Pos(i_ActiveColumnMode, "~t", l_Pos) - l_Pos))
			i_ActiveColumnMode = Replace(i_ActiveColumnMode, l_Pos, l_Len, l_Modify)
		END IF
	
	CASE c_BGColorAttribute

		l_Modify = column_name + ".background.color='" + attribute_value + "'"
		IF i_BatchMode THEN
			i_BatchString = i_BatchString + l_Modify + "~t"
		ELSE
			IF i_ServiceDW.i_CurrentMode <> i_ServiceDW.c_ViewMode THEN
				i_ServiceDW.Modify(l_Modify)
			END IF
		END IF
		
		//------------------------------------------------------------
		//  Put the new value in the i_NormalMode string
		//------------------------------------------------------------

		l_Pos = Pos(i_NormalMode, column_name + ".background.color")
		IF l_Pos > 0 THEN
			l_Len = Len(Mid(i_NormalMode, l_Pos, &
                 Pos(i_NormalMode, "~t", l_Pos) - l_Pos))
			i_NormalMode = Replace(i_NormalMode, l_Pos, l_Len, l_Modify)
		END IF
	
	CASE c_BorderAttribute

		CHOOSE CASE attribute_value
 			CASE i_ServiceDW.c_NoBorder
				l_Border = "0"
 			CASE i_ServiceDW.c_ShadowBox
				l_Border = "1"
 			CASE i_ServiceDW.c_Box
				l_Border = "2"
 			CASE i_ServiceDW.c_Resize
				l_Border = "3"
 			CASE i_ServiceDW.c_Underline
				l_Border = "4"
 			CASE i_ServiceDW.c_Lowered
				l_Border = "5"
 			CASE i_ServiceDW.c_Raised
				l_Border = "6"
		END CHOOSE

		l_Modify = column_name + ".border='" + l_Border + "'"
		IF i_BatchMode THEN
			i_BatchString = i_BatchString + l_Modify + "~t"
		ELSE
			IF i_ServiceDW.i_CurrentMode <> i_ServiceDW.c_ViewMode THEN
				i_ServiceDW.Modify(l_Modify)
			END IF
		END IF

		//------------------------------------------------------------
		//  Put the new value in the i_NormalMode string
		//------------------------------------------------------------

		l_Pos = Pos(i_NormalMode, column_name + ".border")
		IF l_Pos > 0 THEN
			l_Len = Len(Mid(i_NormalMode, l_Pos, &
                 Pos(i_NormalMode, "~t", l_Pos) - l_Pos))
			i_NormalMode = Replace(i_NormalMode, l_Pos, l_Len, l_Modify)
		END IF

END CHOOSE
end subroutine

public subroutine fu_setattribute (string column_name, integer attribute_type, unsignedlong attribute_value);//******************************************************************
//  PC Module     : n_DWSRV_CUES
//  Subroutine    : fu_SetAttribute
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
//                     The value to set the attribute with.  Values
//                     are:
//                        c_ColorAttribute  :   FWCA.MGR.c_<color>
//                        c_BGColorAttribute:   FWCA.MGR.c_<color>
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

STRING l_Value

CHOOSE CASE attribute_type

	CASE c_ColorAttribute, c_BGColorAttribute, c_BorderAttribute
		
		l_Value = String(attribute_value)

END CHOOSE

fu_SetAttribute(column_name, attribute_type, l_Value)
end subroutine

public subroutine fu_batchattributes (integer batch_state);//******************************************************************
//  PC Module     : n_DWSRV_CUES
//  Subroutine    : fu_BatchAttributes
//  Description   : Apply the attribute changes that were queued
//                  using fu_SetAttribute().
//
//  Parameters    : INTEGER Batch_State -
//                     Turns batch mode on or off.  Values are:
//                        c_On
//                        c_Off
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

IF batch_state = c_On THEN
	i_BatchMode = TRUE
	i_BatchString = ""
ELSEIF batch_state = c_Off THEN
	i_BatchMode = FALSE
	IF i_ServiceDW.i_CurrentMode <> i_ServiceDW.c_ViewMode THEN
		i_ServiceDW.Modify(i_BatchString)
	END IF
END IF
end subroutine

public subroutine fu_setinactivemode (integer inactive_state);//******************************************************************
//  PC Module     : n_DWSRV_CUES
//  Subroutine    : fu_SetInactiveMode
//  Description   : Set the DataWindow to be active or inactive.
//
//  Parameters    : INTEGER Inactive_State -
//                     Used to set the DataWindow inactive (yes)
//                     or active (no).
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

IF i_InactiveState <> inactive_state THEN
	CHOOSE CASE inactive_state
		CASE c_Yes
			i_ServiceDW.Modify(i_InactiveTextMode)
			IF i_ServiceDW.RowCount() > 0 THEN
				i_ServiceDW.Modify(i_InactiveColumnMode)
			END IF
		CASE c_No
			i_ServiceDW.Modify(i_ActiveTextMode)
			IF i_ServiceDW.RowCount() > 0 THEN
				i_ServiceDW.Modify(i_ActiveColumnMode)
			END IF
	END CHOOSE
	i_InactiveState = inactive_state
END IF
end subroutine

public subroutine fu_setviewmode (integer view_state);//******************************************************************
//  PC Module     : n_DWSRV_CUES
//  Subroutine    : fu_SetViewMode
//  Description   : Set the DataWindow to in VIEW mode or normal
//                 mode.
//
//  Parameters    : INTEGER View_State -
//                     Used to set the DataWindow in VIEW (yes)
//                     or normal (no).
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

CHOOSE CASE view_state
	CASE c_Yes
		IF i_ServiceDW.RowCount() > 0 THEN
			i_ServiceDW.Modify(i_ViewMode)
		END IF
		i_ServiceDW.Modify("datawindow.readonly=yes")
	CASE c_No
		IF i_ServiceDW.RowCount() > 0 THEN
			i_ServiceDW.Modify(i_NormalMode)
		END IF
		i_ServiceDW.Modify("datawindow.readonly=no")
END CHOOSE

end subroutine

public subroutine fu_buildviewmode (unsignedlong view_color, string view_border);//******************************************************************
//  PC Module     : n_DWSRV_CUES
//  Subroutine    : fu_BuildViewMode
//  Description   : Build a string that can be given to MODIFY
//                  that changes the background color and/or border
//                  of each column when the DataWindow is put into 
//                  VIEW mode.
//
//  Parameters    : ULONG  View_Color -
//                     Color to use for view mode.
//                  STRING View_Border -
//                     Border to use for view mode.
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

STRING  l_Border, l_Color, l_Name, l_Attr
BOOLEAN l_BorderUsed, l_ColorUsed
INTEGER l_NumColumns, l_Idx

//------------------------------------------------------------------
//  Determine if a color and/or a border is to be used to indicate
//  VIEW mode.
//------------------------------------------------------------------

IF view_border <> i_ServiceDW.c_ViewModeBorderUnchanged THEN
	l_BorderUsed = TRUE
	CHOOSE CASE view_border
 		CASE i_ServiceDW.c_ViewModeNoBorder
			l_Border = "0"
 		CASE i_ServiceDW.c_ViewModeShadowBox
			l_Border = "1"
 		CASE i_ServiceDW.c_ViewModeBox
			l_Border = "2"
 		CASE i_ServiceDW.c_ViewModeResize
			l_Border = "3"
 		CASE i_ServiceDW.c_ViewModeUnderline
			l_Border = "4"
 		CASE i_ServiceDW.c_ViewModeLowered
			l_Border = "5"
 		CASE i_ServiceDW.c_ViewModeRaised
			l_Border = "6"
	END CHOOSE
END IF

IF IsNull(view_color) = FALSE THEN
	l_ColorUsed = TRUE
	l_Color = String(view_color)
END IF

//------------------------------------------------------------------
//  Get the number of columns from the DataWindow.
//------------------------------------------------------------------

l_NumColumns = Integer(i_ServiceDW.Describe("datawindow.column.count"))

//------------------------------------------------------------------
//  Build a string for view mode and normal mode.
//------------------------------------------------------------------

i_ViewMode = ""
i_NormalMode = ""
FOR l_Idx = 1 TO l_NumColumns
	l_Name = i_ServiceDW.Describe("#" + String(l_Idx) + ".name")
	IF i_ServiceDW.Describe(l_Name + ".visible") <> "0" THEN
		IF l_BorderUsed THEN
			l_Attr = i_ServiceDW.Describe(l_Name + ".border")
			IF Pos(l_Attr, '"') = 1 THEN
				l_Attr = MID(l_Attr, 2, Len(l_Attr) - 2)
			END IF

			i_NormalMode = i_NormalMode + l_Name + ".border='" + &
				l_Attr + "'~t"
			i_ViewMode = i_ViewMode + l_Name + ".border='" + &
				l_Border + "'~t"
		END IF
		IF l_ColorUsed THEN
			l_Attr = i_ServiceDW.Describe(l_Name + ".background.color")
			IF Pos(l_Attr, '"') = 1 THEN
				l_Attr = MID(l_Attr, 2, Len(l_Attr) - 2)
			END IF

			i_NormalMode = i_NormalMode + l_Name + ".background.color='" + &
				l_Attr + "'~t"
			i_ViewMode = i_ViewMode + l_Name + ".background.color='" + &
				l_Color + "'~t"
		END IF
	END IF
NEXT
end subroutine

on n_dwsrv_cues.create
TriggerEvent( this, "constructor" )
end on

on n_dwsrv_cues.destroy
TriggerEvent( this, "destructor" )
end on

