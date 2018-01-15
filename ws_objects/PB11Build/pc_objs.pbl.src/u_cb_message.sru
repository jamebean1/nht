$PBExportHeader$u_cb_message.sru
$PBExportComments$Command button for display the message window
forward
global type u_cb_message from u_cb_main
end type
end forward

global type u_cb_message from u_cb_main
string Text="Messa&ge"
end type
global u_cb_message u_cb_message

type variables
STRING		i_MessageTitle
STRING		i_MessageColumn
end variables

forward prototypes
public function integer fu_wiredw (datawindow dw_name, string column_name, string title)
end prototypes

public function integer fu_wiredw (datawindow dw_name, string column_name, string title);//******************************************************************
//  PC Module     : u_CB_Message
//  Function      : fu_WireDW
//  Description   : Wires a DataWindow to this object.
//
//  Parameters    : DATAWINDOW DW_Name -
//                     The DataWindow that is to be wired to
//                     this object.
//                  STRING     Column_Name -
//                     Column name in the DataWindow to wire to.
//                  STRING     Title -
//                     Title for the message window.
//
//  Return Value  : INTEGER -
//                      0 = valid DataWindow.
//                     -1 = invalid DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = -1

//------------------------------------------------------------------
//  Make sure that we were passed a valid DataWindow to be wired.
//------------------------------------------------------------------

IF IsValid(dw_name) THEN
   i_ButtonDW       = dw_name
	i_ButtonDW.DYNAMIC fu_Wire(THIS)
	i_MessageColumn  = column_name
	i_MessageTitle   = title
   l_Return         = 0

	IF NOT IsValid(SECCA.MGR) THEN
		Enabled       = TRUE
	END IF
END IF

RETURN l_Return
end function

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Message
//  Event         : Constructor
//  Description   : Sets up the command button.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

i_Event = "Message"
i_Type  = 24

end event

event clicked;//******************************************************************
//  PC Module     : u_CB_Message
//  Event         : Clicked
//  Description   : Opens a window to view or modify a message or 
//                  comment.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_DisplayOnly, l_TextChanged
LONG     l_TextColor,   l_BackColor, l_CurrentRow
STRING   l_Text, l_Attr, l_Expr

//------------------------------------------------------------------
//  Make sure the utility window manager is available.
//------------------------------------------------------------------

IF NOT IsValid(OBJCA.WIN) THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Make sure our DataWindow is valid.
//------------------------------------------------------------------

IF IsNull(i_ButtonDW) = FALSE THEN
ELSE
   RETURN
END IF

i_ButtonDW.DYNAMIC fu_Activate()
l_CurrentRow = i_ButtonDW.DYNAMIC fu_GetCursorRow()

//------------------------------------------------------------------
//  Make sure that we have a valid row.
//------------------------------------------------------------------

IF l_CurrentRow > 0 THEN

   //---------------------------------------------------------------
   //  Get the text to display from the selected DataWindow.
	//---------------------------------------------------------------

	l_Text = i_ButtonDW.GetItemString(l_CurrentRow, &
                                     i_MessageColumn)

	//---------------------------------------------------------------
	//  If the selected DataWindow is in VIEW mode then open the
	//  message window in display-only mode.  Pass the background
	//  color in the fifth parameter.
	//---------------------------------------------------------------

	l_Attr = i_ButtonDW.Describe(i_MessageColumn + ".color")
	IF Pos(l_Attr, '"') = 1 THEN
		l_Expr = Mid(l_Attr, 2, Len(l_Attr) - 2)
		l_Expr = Mid(l_Expr, Pos(l_Expr, "~t") + 1)
		l_Attr = i_ButtonDW.Describe("evaluate('" + l_Expr + "', " + String(l_CurrentRow) + ")")
	END IF

	l_TextColor  = Long(l_Attr)

	l_Attr = i_ButtonDW.Describe(i_MessageColumn + ".background.color")
	IF Pos(l_Attr, '"') = 1 THEN
		l_Expr = Mid(l_Attr, 2, Len(l_Attr) - 2)
		l_Expr = Mid(l_Expr, Pos(l_Expr, "~t") + 1)
		l_Attr = i_ButtonDW.Describe("evaluate('" + l_Expr + "', " + String(l_CurrentRow) + ")")
	END IF

	l_BackColor  = Long(l_Attr)

	IF i_ButtonDW.Describe("datawindow.readonly") = "no" THEN
   	l_DisplayOnly = FALSE
	ELSE
		l_DisplayOnly = TRUE
	END IF

	//---------------------------------------------------------------
	//  Open the message window.
	//---------------------------------------------------------------

	l_TextChanged = OBJCA.WIN.fu_Message(i_MessageTitle, &
                                        l_Text, &
                                        l_DisplayOnly, &
                                        l_BackColor, &
                                        l_TextColor)

	//---------------------------------------------------------------
	//  If the returned text has changed, put the text back into 
	//  the DataWindow.
	//---------------------------------------------------------------

	IF l_TextChanged THEN
   	i_ButtonDW.SetItem(l_CurrentRow, i_MessageColumn, l_Text)
	END IF
END IF

end event

