$PBExportHeader$n_objca_msg.sru
$PBExportComments$Application service to handle class messages
forward
global type n_objca_msg from datastore
end type
end forward

global type n_objca_msg from datastore
string DataObject="d_objca_msg_std"
end type
global n_objca_msg n_objca_msg

type variables
//----------------------------------------------------------------------------------------
//  Message Constants
//----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_Disabled		= 0
CONSTANT INTEGER	c_Enabled		= 1

CONSTANT INTEGER	c_MSG_ID		= 1
CONSTANT INTEGER	c_MSG_Title		= 2
CONSTANT INTEGER	c_MSG_Text		= 3
CONSTANT INTEGER	c_MSG_Icon		= 4
CONSTANT INTEGER	c_MSG_ButtonSet		= 5
CONSTANT INTEGER	c_MSG_ButtonDefault	= 6
CONSTANT INTEGER	c_MSG_Status		= 7

CONSTANT INTEGER	c_MSG_Information		= 1
CONSTANT INTEGER	c_MSG_Stop		= 2
CONSTANT INTEGER	c_MSG_Exclamation 	= 3
CONSTANT INTEGER	c_MSG_Question		= 4
CONSTANT INTEGER	c_MSG_None		= 5

CONSTANT INTEGER	c_MSG_OK		= 1
CONSTANT INTEGER	c_MSG_OKCancel		= 2
CONSTANT INTEGER	c_MSG_YesNo		= 3
CONSTANT INTEGER	c_MSG_YesNoCancel	= 4
CONSTANT INTEGER	c_MSG_RetryCancel	= 5
CONSTANT INTEGER	c_MSG_AbortRetryIgnore	= 6

//----------------------------------------------------------------------------------------
//  Message Instance Variables
//----------------------------------------------------------------------------------------

BOOLEAN		i_MessageDisplaying

end variables

forward prototypes
public function integer fu_addmessage (string id, string title, string text, integer icon, integer button_set, integer button_default, integer status)
public function integer fu_deletemessage (string id)
public function integer fu_setmessage (string id, integer info_type, string info_value)
public function string fu_getmessage (string id, integer info_type)
public function integer fu_displaymessage (string id, integer num_numbers, real number_parms[], integer num_strings, string string_parms[])
public function integer fu_displaymessage (string id)
public function integer fu_displaymessage (string id, integer num_numbers, real number_parms[])
public function integer fu_displaymessage (string id, integer num_strings, string string_parms[])
end prototypes

public function integer fu_addmessage (string id, string title, string text, integer icon, integer button_set, integer button_default, integer status);//******************************************************************
//  PO Module     : n_OBJCA_MSG
//  Function      : fu_AddMessage
//  Description   : Adds information about a message to the
//                  message datastore.
//
//  Parameters    : STRING ID -
//                     String that identifies the message.
//
//                  STRING Title -
//                     Title for the message box. The string
//                     '<application_name>' will use the name of
//                     the application.
//
//                  STRING Text -
//                     Message text.
//
//                  INTEGER Icon -
//                     The icon to display with the message.  
//                     Choices are:
//                        c_MSG_Information
//                        c_MSG_Stop
//                        c_MSG_Exclamation
//                        c_MSG_Question
//                        c_MSG_None	
//
//                  INTEGER Button_Set -
//                     The button set to display with the message.
//                     choices are:
//                        c_MSG_OK
//                        c_MSG_OKCancel
//                        c_MSG_YesNo
//                        c_MSG_YesNoCancel
//                        c_MSG_RetryCancel
//                        c_MSG_AbortRetryInquire
//
//                  INTEGER Button_Default -
//                     The button number in the button set to use
//                     as the default.
//
//                  INTEGER Status -
//                     Is the message enabled or disabled.
//                     Choices are:
//                        c_Enable
//                        c_Disable
//
//  Return Value  : INTEGER -
//                      0 - The message was added.
//                     -1 - The message already exists.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Rows, l_Idx, l_Return = -1
BOOLEAN l_Found = FALSE

//------------------------------------------------------------------
//  Make sure the message to add is not already there.
//------------------------------------------------------------------

l_Rows  = RowCount()

FOR l_Idx = 1 TO l_Rows
	IF GetItemString(l_Idx, "id") = id THEN
		l_Found = TRUE
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  If it wasn't found, add it.
//------------------------------------------------------------------

IF NOT l_Found THEN
	l_Rows   = l_Rows + 1
	InsertRow(l_Rows)

	SetItem(l_Rows, "id", id)
	SetItem(l_Rows, "title", title)
	SetItem(l_Rows, "text", text)
	SetItem(l_Rows, "icon", icon)
	SetItem(l_Rows, "button_set", button_set)
	SetItem(l_Rows, "button_default", button_default)
	SetItem(l_Rows, "status", status)
	l_Return = 0
END IF

RETURN l_Return
end function

public function integer fu_deletemessage (string id);//******************************************************************
//  PO Module     : n_OBJCA_MSG
//  Function      : fu_DeleteMessage
//  Description   : Deletes information about a message from the
//                  message datastore.
//
//  Parameters    : STRING ID -
//                     String to identify the message to delete.
//
//  Return Value  : INTEGER -
//                      0 - The message was deleted.
//                     -1 - The message was not found or deleted.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Rows, l_Idx, l_Return = -1

IF Upper(id) <> "UNDEFINED" THEN
	l_Rows = RowCount()
	FOR l_Idx = 1 TO l_Rows
		IF GetItemString(l_Idx, "id") = id THEN
			DeleteRow(l_Idx)
			l_Return = 0
			EXIT
		END IF
	NEXT
END IF
			
RETURN l_Return
end function

public function integer fu_setmessage (string id, integer info_type, string info_value);//******************************************************************
//  PO Module     : n_OBJCA_MSG
//  Function      : fu_SetMessage
//  Description   : Sets information about the message.
//
//  Parameters    : STRING ID -
//                     String to identify the message to modify.
//
//                  INTEGER Info_Type -
//                     Enumerated value to tell the function
//                     what message information to set.
//
//                  STRING  Info_Value -
//                     The message information to set.
//
//  Return Value  : INTEGER -
//                      0 - The message information was set.
//                     -1 - The message id was not found.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Rows, l_Idx, l_Return = -1

//------------------------------------------------------------------
//  Find the requested message id.
//------------------------------------------------------------------

IF Upper(id) <> "UNDEFINED" THEN
	l_Rows = RowCount()
	FOR l_Idx = 1 TO l_Rows
		IF GetItemString(l_Idx, "id") = id THEN
			CHOOSE CASE info_type
				CASE c_MSG_Id
					SetItem(l_Idx, "id", info_value)
				CASE c_MSG_Title
					SetItem(l_Idx, "title", info_value)
				CASE c_MSG_Text
					SetItem(l_Idx, "text", info_value)
				CASE c_MSG_Icon
					SetItem(l_Idx, "icon", Integer(info_value))
				CASE c_MSG_ButtonSet
					SetItem(l_Idx, "button_set", Integer(info_value))
				CASE c_MSG_ButtonDefault
					SetItem(l_Idx, "button_default", Integer(info_value))
				CASE c_MSG_Status
					SetItem(l_Idx, "status", Integer(info_value))
			END CHOOSE
			l_Return = 0
			EXIT
		END IF
	NEXT
END IF

RETURN l_Return
end function

public function string fu_getmessage (string id, integer info_type);//******************************************************************
//  PO Module     : n_OBJCA_MSG
//  Function      : fu_GetMessage
//  Description   : Returns information about a message.
//
//  Parameters    : STRING  ID -
//                     String to identify the message.
//
//                  INTEGER Info_Type -
//                     Enumerated value to tell the function
//                     what message information to return.
//
//  Return Value  : STRING
//                     The information about the message.  An
//                     unknown message or unkown information about
//                     a message is returned as "".
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Info
INTEGER l_Rows, l_Idx

//------------------------------------------------------------------
//  Find the requested message information.
//------------------------------------------------------------------

IF Upper(id) <> "UNDEFINED" THEN
	l_Rows = RowCount()
	FOR l_Idx = 1 TO l_Rows
		IF GetItemString(l_Idx, "id") = id THEN
			CHOOSE CASE Info_Type
				CASE c_MSG_Id
					l_Info = GetItemString(l_Idx, "id")
				CASE c_MSG_Title
					l_Info = GetItemString(l_Idx, "title")
				CASE c_MSG_Text
					l_Info = GetItemString(l_Idx, "text")
				CASE c_MSG_Icon
					l_Info = String(GetItemNumber(l_Idx, "icon"))
				CASE c_MSG_ButtonSet
					l_Info = String(GetItemNumber(l_Idx, "button_set"))
				CASE c_MSG_ButtonDefault
					l_Info = String(GetItemNumber(l_Idx, "button_default"))
				CASE c_MSG_Status
					l_Info = String(GetItemNumber(l_Idx, "status"))
			END CHOOSE
			EXIT
		END IF
	NEXT
ELSE
	l_Info = ""
END IF

RETURN l_Info
end function

public function integer fu_displaymessage (string id, integer num_numbers, real number_parms[], integer num_strings, string string_parms[]);//******************************************************************
//  PO Module     : n_OBJCA_MSG
//  Function      : fu_DisplayMessage
//  Description   : Formats and displays the message specified
//                  by the id in a MessageBox() call.
//
//  Parameters    : STRING ID -
//                     The ID of the message to be formatted
//                     and displayed.
//
//                  INTEGER Num_Numbers -
//                     The number of REAL parameters to be
//                     substituted into the string.
//
//                  REAL Number_Parms[] -
//                     An array containing the REAL parameters to 
//                     be substituted into the string.
//
//                  INTEGER Num_Strings -
//                     The number of string parameters to be
//                     substituted into the string.
//
//                  STRING String_Parms[] -
//                     An array containing the string parameters to
//                     be substituted into the string.
//
//  Return Value  : INTEGER -
//                     The result returned by the call to
//                     MessageBox() call.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/8/98	Beth Byers	Use the UPPER function with the FIND function 
//  							in case the user passed in a lower case or 
//								mixed case id
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Answer, l_MessageCnt, l_Row, l_Icon, l_ButtonSet
INTEGER  l_ButtonDefault, l_Status, l_StartPos
STRING   l_Text, l_Title, l_Before, l_Char, l_After, l_ErrorStrings[]
ICON     l_IconType
BUTTON   l_ButtonType

//------------------------------------------------------------------
//  See if we have a valid message ID.
//------------------------------------------------------------------

l_MessageCnt = RowCount()
l_Row = Find("UPPER(id) = '" + Upper(id) + "'", 1, l_MessageCnt)
IF l_Row > 0 THEN
	
   //---------------------------------------------------------------
   //  Get the parameters using the message ID.
   //---------------------------------------------------------------

   l_Title         = GetItemString(l_Row, "title")
   l_Text          = GetItemString(l_Row, "text")
   l_Icon          = GetItemNumber(l_Row, "icon")
	l_ButtonSet     = GetItemNumber(l_Row, "button_set")
   l_ButtonDefault = GetItemNumber(l_Row, "button_default")
   l_Status        = GetItemNumber(l_Row, "status")

ELSE

   //---------------------------------------------------------------
   //  Invalid message ID.
   //---------------------------------------------------------------

   l_Row = Find("id = 'Undefined'", 1, l_MessageCnt)
   l_Title         = GetItemString(l_Row, "title")
   l_Text          = GetItemString(l_Row, "text")
   l_Icon          = GetItemNumber(l_Row, "icon")
	l_ButtonSet     = GetItemNumber(l_Row, "button_set")
   l_ButtonDefault = GetItemNumber(l_Row, "button_default")
   l_Status        = GetItemNumber(l_Row, "status")
END IF

//------------------------------------------------------------------
//  If the title uses the application name, then set it.
//------------------------------------------------------------------

IF l_Title = "<application_name>" THEN
   l_Title = OBJCA.MGR.i_ApplicationName
ELSE

   //---------------------------------------------------------------
   //  Do the formatting of the title.
   //---------------------------------------------------------------

   l_Title = OBJCA.MGR.fu_FormatString(l_Title, num_numbers, number_parms[], &
                                       num_strings, string_parms[])
END IF

//------------------------------------------------------------------
//  Do the formatting of the message text.
//------------------------------------------------------------------

l_Text = OBJCA.MGR.fu_FormatString(l_Text, num_numbers, number_parms[], &
                                   num_strings, string_parms[])
											  
//------------------------------------------------------------------
//  Physically replace escaped characters with themselves.
//------------------------------------------------------------------

l_StartPos = 1
DO
	l_StartPos = Pos(l_Text, "~~", l_StartPos)
	IF l_StartPos > 0 THEN
		l_Before = Mid(l_Text, 1, l_StartPos - 1)
		l_Char   = Mid(l_Text, l_StartPos, 2)
		l_After  = Mid(l_Text, l_StartPos + 2, Len(l_Text) - (l_StartPos + 1))
		CHOOSE CASE l_Char
			CASE "~~n"
				l_Char = "~n"
			CASE "~~t"
				l_Char = "~t"
			CASE "~~v"
				l_Char = "~v"
			CASE "~~r"
				l_Char = "~r"
			CASE "~~f"
				l_Char = "~f"
			CASE "~~b"
				l_Char = "~b"
			CASE '~~"'
				l_Char = '~"'
			CASE "~~'"
				l_Char = "~'"
			CASE ELSE
				l_Char = ""
		END CHOOSE
		IF l_Char <> "" THEN
			l_Text = l_Before + l_Char + l_After
		   l_StartPos++
		ELSE
			l_StartPos = l_StartPos + 2
		END IF
	END IF
LOOP WHILE l_StartPos > 0

//------------------------------------------------------------------
//  Set the icon.
//------------------------------------------------------------------

CHOOSE CASE l_Icon
	CASE c_MSG_Information
		l_IconType = Information!
	CASE c_MSG_Stop
		l_IconType = StopSign!
	CASE c_MSG_Exclamation
		l_IconType = Exclamation!
	CASE c_MSG_Question
		l_IconType = Question!
	CASE c_MSG_None
		l_IconType = None!
END CHOOSE

//------------------------------------------------------------------
//  Set the button set.
//------------------------------------------------------------------

CHOOSE CASE l_ButtonSet
	CASE c_MSG_OK
		l_ButtonType = Ok!
	CASE c_MSG_OKCancel
		l_ButtonType = OkCancel!
	CASE c_MSG_YesNo
		l_ButtonType = YesNo!
	CASE c_MSG_YesNoCancel
		l_ButtonType = YesNoCancel!
	CASE c_MSG_RetryCancel
		l_ButtonType = RetryCancel!
	CASE c_MSG_AbortRetryIgnore
		l_ButtonType = AbortRetryIgnore!
END CHOOSE

//------------------------------------------------------------------
//  If message logging is on, then log the message.
//------------------------------------------------------------------

IF IsValid(OBJCA.LOG) THEN
	IF OBJCA.LOG.i_CurrentLog <> "" AND num_strings > 0 THEN
		IF string_parms[1] = "PowerObjects Error" THEN
			l_ErrorStrings[1] = string_parms[1]
			l_ErrorStrings[2] = string_parms[2]
			l_ErrorStrings[3] = string_parms[3]
			l_ErrorStrings[4] = string_parms[4]
			l_ErrorStrings[5] = string_parms[5]
			l_ErrorStrings[6] = l_Text
			OBJCA.LOG.fu_LogWrite(OBJCA.LOG.i_CurrentLog, &
			                      l_ErrorStrings[])
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  If the message is enabled, then do the MessageBox() call.
//------------------------------------------------------------------

IF l_Status = c_Enabled THEN
   i_MessageDisplaying = TRUE
	l_Answer = MessageBox(l_Title, l_Text, l_IconType, &
                         l_ButtonType, l_ButtonDefault)
	i_MessageDisplaying = FALSE
ELSE
   l_Answer = l_ButtonDefault
END IF

RETURN l_Answer

end function

public function integer fu_displaymessage (string id);//******************************************************************
//  PO Module     : n_OBJCA_MSG
//  Function      : fu_DisplayMessage
//  Description   : Displays the message specified
//                  by the id in a MessageBox() call.
//
//  Parameters    : STRING ID -
//                     The ID of the message to be displayed.
//
//  Return Value  : INTEGER -
//                     The result returned by the call to
//                     MessageBox() call.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

REAL   l_Numbers[]
STRING l_Strings[]

RETURN fu_DisplayMessage(id, 0, l_Numbers[], 0, l_Strings[])

end function

public function integer fu_displaymessage (string id, integer num_numbers, real number_parms[]);//******************************************************************
//  PO Module     : n_OBJCA_MSG
//  Function      : fu_DisplayMessage
//  Description   : Formats and displays the message specified
//                  by the id in a MessageBox() call.
//
//  Parameters    : STRING ID -
//                     The ID of the message to be formatted
//                     and displayed.
//
//                  INTEGER Num_Numbers -
//                     The number of REAL parameters to be
//                     substituted into the string.
//
//                  REAL Number_Parms[] -
//                     An array containing the REAL parameters to 
//                     be substituted into the string.
//
//  Return Value  : INTEGER -
//                     The result returned by the call to
//                     MessageBox() call.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Strings[]

RETURN fu_DisplayMessage(id, num_numbers, number_parms[], &
                         0, l_Strings[])
								 

end function

public function integer fu_displaymessage (string id, integer num_strings, string string_parms[]);//******************************************************************
//  PO Module     : n_OBJCA_MSG
//  Function      : fu_DisplayMessage
//  Description   : Formats and displays the message specified
//                  by the id in a MessageBox() call.
//
//  Parameters    : STRING ID -
//                     The ID of the message to be formatted
//                     and displayed.
//
//                  INTEGER Num_Strings -
//                     The number of string parameters to be
//                     substituted into the string.
//
//                  STRING String_Parms[] -
//                     An array containing the string parameters to
//                     be substituted into the string.
//
//  Return Value  : INTEGER -
//                     The result returned by the call to
//                     MessageBox() call.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

REAL l_Numbers[]

RETURN fu_DisplayMessage(id, 0, l_Numbers[], num_strings, &
                         string_parms[])
								 

end function

on n_objca_msg.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on n_objca_msg.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

