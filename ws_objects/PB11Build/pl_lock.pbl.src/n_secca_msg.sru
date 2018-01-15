$PBExportHeader$n_secca_msg.sru
$PBExportComments$Application service to handle security messages
forward
global type n_secca_msg from datastore
end type
end forward

global type n_secca_msg from datastore
string DataObject="d_secca_msg_std"
end type
global n_secca_msg n_secca_msg

type variables
//----------------------------------------------------------------------------------------
//  Message Constants
//----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_Disabled	= 0
CONSTANT INTEGER	c_Enabled 	= 1

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

BOOLEAN	i_MessageDisplaying

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
public function string fu_formatstring (string format_string, integer num_numbers, real number_parms[], integer num_strings, string string_parms[])
end prototypes

public function integer fu_addmessage (string id, string title, string text, integer icon, integer button_set, integer button_default, integer status);//******************************************************************
//  PO Module     : n_secca_msg
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
//  PO Module     : n_secca_msg
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
//  PO Module     : n_secca_msg
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
//  PO Module     : n_secca_msg
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
//  PO Module     : n_secca_msg
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
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Answer, l_MessageCnt, l_Row, l_Icon, l_ButtonSet
INTEGER  l_ButtonDefault, l_Status, l_StartPos, l_Pos
STRING   l_Text, l_Title, l_Before, l_Char, l_After
ICON     l_IconType
BUTTON   l_ButtonType

//------------------------------------------------------------------
//  See if we have a valid message ID.
//------------------------------------------------------------------

l_MessageCnt = RowCount()
l_Row = Find("id = '" + id + "'", 1, l_MessageCnt)
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

l_Pos = Pos(l_Title, "<application_name>", 1)
IF l_Pos > 0 THEN
   l_Title = Replace(l_Title, l_Pos, 18, SECCA.MGR.i_ProgName)
ELSE

   //---------------------------------------------------------------
   //  Do the formatting of the title.
   //---------------------------------------------------------------

   l_Title = fu_FormatString(l_Title, num_numbers, number_parms[], &
                             num_strings, string_parms[])
END IF

//------------------------------------------------------------------
//  Do the formatting of the message text.
//------------------------------------------------------------------

l_Text = fu_FormatString(l_Text, num_numbers, number_parms[], &
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
//  PO Module     : n_secca_msg
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
//  PO Module     : n_secca_msg
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
//  PO Module     : n_secca_msg
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

public function string fu_formatstring (string format_string, integer num_numbers, real number_parms[], integer num_strings, string string_parms[]);//******************************************************************
//  PO Module     : n_POManager
//  Function      : fu_FormatString
//  Description   : Substitues values into a string.  Number
//                  substitutions are made when "%<pos>d" is
//                  found and string substitutions are made
//                  when "%<pos>s" is found.  If there are not
//                  enough parameters (e.g. %2d was specified,
//                  but no numbers were passed), the format
//                  string and all spaces following it  will
//                  be deleted from the output. An example
//                  string passed as Format_String would be:
//                     "Str #2: %2s; Str #1: %1s, Num: %1d"
//
//  Parameters    : STRING  Format_String -
//                     The format string which specifies
//                     the substitutions are to be done.
//
//                  INTEGER Num_Numbers -
//                     The number of real parameters to
//                     be substituted into the Format_String.
//
//                  REAL    Number_Parms[] -
//                     An array containing the REAL
//                     parameters to be substituted into
//                     the Format_String.
//
//                  INTEGER Num_Strings -
//                     The number of string parameters to
//                     be substituted into the Format_String.
//
//                  STRING  String_Parms[] -
//                     An array containing the string
//                     parameters to be substituted into
//                     the Format_String.
//
//  Return Value  : STRING -
//                     The string produced by the formatting.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING   c_FormatChar = "%"

BOOLEAN  l_Quoted,    l_DoSub,     l_KillFormat
INTEGER  l_Length,    l_FormatPos, l_ParmNum, l_EndPos, l_Idx
INTEGER  l_Zero,      l_Nine,      l_TmpAsc
STRING   l_FormatStr, l_SubStr,    l_Num,     l_TmpChar

//------------------------------------------------------------------
//  See if there are any formatting characters in Format_String.
//  If there are not, then we can just return Format_String.
//------------------------------------------------------------------

l_FormatPos = Pos(Format_String, c_FormatChar)
IF l_FormatPos = 0 THEN
   l_FormatStr = Format_String
   RETURN l_FormatStr
END IF

//------------------------------------------------------------------
//  Find every format character in Format_String and determine
//  its type and substitution number and then substitute it.
//------------------------------------------------------------------

l_FormatStr = Format_String
l_Length    = Len(l_FormatStr)
l_Zero      = Asc("0")
l_Nine      = Asc("9")

DO WHILE l_FormatPos > 0

   //---------------------------------------------------------------
   //  We found a character that may begin a format.  See if it
   //  is quoted.
   //---------------------------------------------------------------

   l_Quoted = FALSE
   IF l_FormatPos > 1 THEN
      l_Idx     = l_FormatPos - 1
      l_TmpChar = Mid(l_FormatStr, l_Idx, 1)

      DO WHILE l_TmpChar = "~~"
         l_Quoted = (NOT l_Quoted)
         l_Idx    = l_Idx - 1
         IF l_Idx > 0 THEN
            l_TmpChar = Mid(l_FormatStr, l_Idx, 1)
         ELSE
            l_TmpChar = ""
         END IF
      LOOP
   END IF

   //---------------------------------------------------------------
   //  If the character has not already been quoted, then figure
   //  its position parameter.
   //---------------------------------------------------------------

   IF NOT l_Quoted THEN
      IF l_FormatPos < l_Length THEN
         l_Num     = "0"

         l_EndPos  = l_FormatPos + 1
         l_TmpChar = Mid(l_FormatStr, l_EndPos, 1)
         l_TmpAsc  = Asc(l_TmpChar)

         DO WHILE l_TmpAsc >= l_Zero AND l_TmpAsc <= l_Nine
            l_Num    = l_Num    + l_TmpChar
            l_EndPos = l_EndPos + 1
            IF l_EndPos <= l_Length THEN
               l_TmpChar = Mid(l_FormatStr, l_EndPos, 1)
               l_TmpAsc  = Asc(l_TmpChar)
            ELSE
               l_TmpChar = ""
               l_TmpAsc  = 0
            END IF
         LOOP

         //---------------------------------------------------------
         //  If not parameter position was specified, assume 1.
         //---------------------------------------------------------

         l_ParmNum = Integer(l_Num)

         IF l_ParmNum < 1 THEN
            l_ParmNum = 1
         END IF

         //---------------------------------------------------------
         //  See if we have a string substitution.
         //---------------------------------------------------------

         l_DoSub      = FALSE
         l_KillFormat = FALSE

         IF l_TmpChar = "s" THEN

            //------------------------------------------------------
            //  Is it a valid parameter number?
            //------------------------------------------------------

            l_DoSub = (l_ParmNum <= Num_Strings)
            IF l_DoSub THEN
               l_SubStr = String_Parms[l_ParmNum]
            ELSE
               l_KillFormat = TRUE
            END IF
         ELSE

            //------------------------------------------------------
            //  See if we have a number substitution.
            //------------------------------------------------------

            IF l_TmpChar = "d" THEN

               //---------------------------------------------------
               //  Is it a valid parameter number?
               //---------------------------------------------------

               l_DoSub = (l_ParmNum <= Num_Numbers)

               IF l_DoSub THEN
                  l_SubStr = String(Number_Parms[l_ParmNum])
               ELSE
                  l_KillFormat = TRUE
               END IF
            END IF
         END IF

         //---------------------------------------------------------
         //  Nothing to substitute - kill the format.
         //---------------------------------------------------------

         IF l_KillFormat THEN
            l_DoSub = TRUE

            IF l_EndPos < l_Length THEN
               l_EndPos  = l_EndPos + 1
               l_TmpChar = Mid(l_FormatStr, l_EndPos, 1)

               DO WHILE l_TmpChar = " "
                  l_EndPos = l_EndPos + 1
                  IF l_EndPos <= l_Length THEN
                     l_TmpChar = Mid(l_FormatStr, l_EndPos, 1)
                  ELSE
                     l_TmpChar = ""
                  END IF
               LOOP

               l_EndPos = l_EndPos - 1
            END IF

            l_SubStr = ""
         END IF

         IF l_DoSub THEN
            l_FormatStr = Replace(l_FormatStr,                &
                                  l_FormatPos,                &
                                  l_EndPos - l_FormatPos + 1, &
                                  l_SubStr)
            l_Length    = Len(l_FormatStr)
            l_FormatPos = l_FormatPos + Len(l_SubStr) - 1
         END IF
      END IF
   END IF

   //---------------------------------------------------------------
   //  Find the next format character.
   //---------------------------------------------------------------

   l_FormatPos = Pos(l_FormatStr, c_FormatChar, l_FormatPos + 1)
LOOP

RETURN l_FormatStr
end function

on n_secca_msg.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on n_secca_msg.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

