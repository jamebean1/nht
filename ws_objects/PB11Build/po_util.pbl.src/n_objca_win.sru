$PBExportHeader$n_objca_win.sru
$PBExportComments$Window utilities data store
forward
global type n_objca_win from n_objca_mgr
end type
end forward

global type n_objca_win from n_objca_mgr
string dataobject = "d_objca_win_std"
end type
global n_objca_win n_objca_win

type variables
//----------------------------------------------------------------------------------------
//  Utility Window Constants
//----------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------
//  Utility Window Instance Variables
//----------------------------------------------------------------------------------------


end variables

forward prototypes
public function integer fu_filecopy (string from_file, string to_file)
public function integer fu_filemove (string from_file, string to_file)
public function integer fu_about (string application_name, string application_rev, string application_copyright, string application_bitmap)
public function integer fu_connect (transaction trans_object, boolean allow_correction)
public function integer fu_fileconfirm (string from_directory, string to_directory, string files[], ref boolean copymove[])
public function integer fu_filecopymove (string from_directory, string to_directory, string files[], string copy_or_move, boolean confirm, boolean display)
public function integer fu_filesaveas (datawindow datawindow, ref string directory)
public function integer fu_login (string login_title, integer grace_logins, boolean attempt_connection, string login_bitmap, ref transaction trans_object)
public function boolean fu_message (string message_title, ref string message_text, boolean display_only, unsignedlong back_color, unsignedlong text_color)
public function integer fu_microhelp (window mdi_frame, integer update_seconds, boolean show_clock, boolean show_resources)
public function integer fu_plaque (string application_name, string application_rev, string application_bitmap)
public function integer fu_syserror (string syserror_title)
public function integer fu_recordconfirm (string labels[], string action, ref boolean confirm[])
public function string fu_getlogin (transaction trans_object)
public function integer fu_setlogin (ref transaction trans_object, string usr_login, string usr_password)
public function integer fu_undelete (datawindow dw_name)
public function integer fu_sort (datawindow dw_name)
public function integer fu_plaque ()
public subroutine fu_microhelpposition ()
public subroutine fu_microhelpclose ()
public function integer fu_filesaveas (datastore datastore, ref string directory)
public function integer fu_about ()
public function integer fu_getconnectinfo (string ini_file, string ini_section, ref transaction trans_object)
public function integer fu_getconnectinfo (string reg_key, ref transaction trans_object)
end prototypes

public function integer fu_filecopy (string from_file, string to_file);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_FileCopy
//  Description   : Copies a file.
//
//  Parameters    : STRING From_File -
//                     File to copy from.
//
//                  STRING To_File -
//                     File to copy to.
//
//  Return Value  : INTEGER
//                      0 = file copy OK
//                     -1 = file copy failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_FileRead, l_FileWrite, l_Return
LONG     l_FileLen,  l_Loops,     l_Idx
BLOB     l_Bytes

//------------------------------------------------------------------
//  Determine the number of bytes for the file.
//------------------------------------------------------------------

l_FileLen = FileLength(From_File)
IF l_FileLen = -1 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Determine the number of loops that have to be performed to
//  read/write the file.
//------------------------------------------------------------------

IF l_FileLen > 32765 THEN
	IF Mod(l_FileLen, 32765) = 0 THEN
      l_Loops = l_FileLen/32765
	ELSE
      l_Loops = (l_FileLen/32765) + 1
	END IF
ELSE
	l_Loops = 1
END IF

//------------------------------------------------------------------
//  Open the file to read from.
//------------------------------------------------------------------

l_FileRead = FileOpen(From_File, StreamMode!, Read!, LockRead!)
IF l_FileRead = -1 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Open the file to write to.
//------------------------------------------------------------------

l_FileWrite = FileOpen(To_File, StreamMode!, Write!, &
                                LockWrite!,  Replace!)
IF l_FileWrite = -1 THEN
   FileClose(l_FileRead)
   RETURN -1
END IF

//------------------------------------------------------------------
//  Copy the contents from one file to the other.
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_Loops
	l_Return = FileRead(l_FileRead, l_Bytes)
	IF l_Return = -1 THEN
      FileClose(l_FileRead)
      FileClose(l_FileWrite)
      RETURN -1
   ELSE
      l_Return = FileWrite(l_FileWrite, l_Bytes)
	   IF l_Return = -1 THEN
         FileClose(l_FileRead)
         FileClose(l_FileWrite)
         RETURN -1
      END IF
   END IF
NEXT

//------------------------------------------------------------------
//  Close the files.
//------------------------------------------------------------------

FileClose(l_FileRead)
FileClose(l_FileWrite)

RETURN 0
end function

public function integer fu_filemove (string from_file, string to_file);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_FileMove
//  Description   : Moves a file.
//
//  Parameters    : STRING From_File -
//                     File to move from.
//                  STRING To_File   -
//                     File to move to.
//
//  Return Value  : INTEGER
//                      0 = file move OK
//                     -1 = file move failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_OK
INTEGER  l_Return

//------------------------------------------------------------------
//  Copy the file.
//------------------------------------------------------------------

l_Return = fu_FileCopy(From_File, To_File)
IF l_Return <> 0 THEN
   RETURN l_Return
END IF

//------------------------------------------------------------------
//  Remove the old file.
//------------------------------------------------------------------

l_OK = FileDelete(From_File)
IF NOT l_OK THEN
   RETURN -1
END IF

RETURN 0
end function

public function integer fu_about (string application_name, string application_rev, string application_copyright, string application_bitmap);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_About
//  Description   : Display the ABOUT window.
//
//  Parameters    : STRING  Application_Name      - 
//                     Name of the application.
//                  STRING  Application_Rev       -
//                     Revision of the application.
//                  STRING  Application_Copyright -
//                     Copyright for the application.
//                  STRING  Application_Bitmap    -
//                     Bitmap to display on the ABOUT window.
//
//  Return Value  : INTEGER
//                      0 = window open OK    
//                     -1 = window open failed
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Set the variables into the structure to pass to the window.
//------------------------------------------------------------------

i_Parm.Application_Name      = application_name
i_Parm.Application_Rev       = application_rev
i_Parm.Application_Bitmap    = application_bitmap
i_Parm.Application_Copyright = application_copyright

//------------------------------------------------------------------
//  Open the about window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "About")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return <> -1 THEN
   	l_Return = 0
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public function integer fu_connect (transaction trans_object, boolean allow_correction);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_Connect
//  Description   : Attempts to connect to the database with the
//                  given transaction.  If the connection fails, a
//                  window is displayed with the current transaction
//                  information and the user may correct it.
//
//  Parameters    : TRANSACTION Trans_Object -
//                     The transaction object to be used to make
//                     the database connection.
//                  BOOLEAN     Allow_Correction -
//                     If the connection fails, should a window be
//                     displayed to allow the user to change the
//                     connection parameters.
//
//  Return Value  : INTEGER
//                      0 = The CONNECT was successful.
//                     -1 = Unable to CONNECT.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING   l_ErrorStrings[], l_Object
INTEGER  l_Return
WINDOW   l_Window

//-------------------------------------------------------------------
//  Always make sure that we are disconnected before we try to
//  CONNECT.
//-------------------------------------------------------------------

DISCONNECT USING trans_object;

//-------------------------------------------------------------------
//  Attempt to CONNECT to the database.
//-------------------------------------------------------------------

CONNECT USING trans_object;

//-------------------------------------------------------------------
//  Check for errors during the CONNECT.
//-------------------------------------------------------------------

IF trans_object.SQLCode <> 0 THEN

   //----------------------------------------------------------------
   //  The CONNECT failed.  Put up a MessageBox error.
   //----------------------------------------------------------------

	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_Connect"
   l_ErrorStrings[6] = trans_object.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("DBConnectError", &
                               6, l_ErrorStrings[])

   //----------------------------------------------------------------
   //  Use the connection window to get the correct connection
   //  information.
   //----------------------------------------------------------------

   IF allow_correction THEN

		l_Object = OBJCA.MGR.fu_GetDefault("Objects", "Connect")
		IF l_Object <> "" THEN
      	l_Return = OpenWithParm(l_Window, trans_object, l_Object)
		ELSE
			RETURN -1
		END IF

   END IF

   //----------------------------------------------------------------
   //  The SQLCode tells us whether we were successfully
   //  CONNECTED by w_Connect or not.  
   //----------------------------------------------------------------

   IF trans_object.SQLCode = 0 THEN
      RETURN 0
   ELSE
      RETURN -1
   END IF
END IF

RETURN 0
end function

public function integer fu_fileconfirm (string from_directory, string to_directory, string files[], ref boolean copymove[]);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_FileConfirm
//  Description   : Displays the file confirmation window for each
//                  file to move or copy.
//
//  Parameters    : STRING    From_Directory -
//                     Directory to copy/move files from.
//                  STRING    To_Directory   -
//                     Directory to copy/move files to.
//                  STRING    Files[]        -
//                     Files to copy/move.
//                  BOOLEAN   CopyMove[]
//                     Results from the file/move confirmation.
//
//  Return Value  : INTEGER 
//                      0 = confirmation successful.
//                     -1 = confirmation cancelled
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = 0, l_Idx, l_Jdx, l_NumFiles, l_Answer
STRING  l_FromFile, l_ToFile, l_Object
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the copy/move confirmation variables.
//------------------------------------------------------------------

l_NumFiles = UpperBound(files[])
FOR l_Idx = 1 TO l_NumFiles
   copymove[l_Idx] = TRUE
NEXT

i_PARM.Multiple = FALSE
IF l_NumFiles > 1 THEN
   i_PARM.Multiple = TRUE
END IF

IF Right(from_directory, 1) <> i_DirDelim THEN
   from_directory = from_directory + i_DirDelim
END IF
IF Right(to_directory, 1) <> i_DirDelim THEN
   to_directory = to_directory + i_DirDelim
END IF

//------------------------------------------------------------------
//  Determine if the file to copy or move exists in the TO
//  directory.  If it does, open the file confirmation response 
//  window.
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_NumFiles
   l_FromFile = UPPER(from_directory + files[l_Idx])
   l_ToFile   = UPPER(to_directory + files[l_Idx])
   IF FileExists(l_FromFile) THEN
      IF FileExists(l_ToFile) THEN
         i_PARM.Replace_File = l_ToFile + "~r~n" + &
                               String(FileLength(l_ToFile)) + &
                               " bytes"
         i_PARM.With_File    = l_FromFile   + "?~r~n" + &
                               String(FileLength(l_FromFile)) + &
                               " bytes"
         i_PARM.Answer       = 0

			l_Object = OBJCA.MGR.fu_GetDefault("Objects", "FileConfirm")
			IF l_Object <> "" THEN
         	l_Return = Open(l_Window, l_Object)
			ELSE
				l_Return = -1
			END IF

         IF l_Return <> -1 THEN
            l_Answer = i_PARM.Answer
   
            //------------------------------------------------------
            //  Determine the response from the confirmation window.
            //------------------------------------------------------

            CHOOSE CASE l_Answer
               CASE 2
                  FOR l_Jdx = 1 TO l_NumFiles
                     copymove[l_Jdx] = TRUE
                  NEXT
                  EXIT
               CASE 3
                  copymove[l_Idx] = FALSE
               CASE 4
                  FOR l_Jdx = 1 TO l_NumFiles
                     copymove[l_Jdx] = FALSE
                  NEXT
                  l_Return = -1
                  EXIT              
            END  CHOOSE
         ELSE
            FOR l_Jdx = 1 TO l_NumFiles
               copymove[l_Jdx] = FALSE
            NEXT
            EXIT
         END IF
      END IF
   ELSE
      copymove[l_Idx] = FALSE
   END IF
NEXT

//------------------------------------------------------------------
//  Return the copy/move array indicating which files will be
//  copied or moved.
//------------------------------------------------------------------

RETURN l_Return
end function

public function integer fu_filecopymove (string from_directory, string to_directory, string files[], string copy_or_move, boolean confirm, boolean display);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_FileCopyMove
//  Description   : Copies or moves files.
//
//  Parameters    : 
//
//  Return Value  : INTEGER -  0 = copy/move successful.
//                            -1 = copy/move cancelled or error
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = 0, l_Idx, l_NumFiles, l_NumFilesToCopyMove
STRING  l_Files[], l_Object
BOOLEAN l_CopyMove[]
WINDOW  l_Window

//------------------------------------------------------------------
//  Check for existing files and ask the user for confirmation.
//------------------------------------------------------------------

l_NumFiles = UpperBound(files[])

FOR l_Idx = 1 TO l_NumFiles
   l_CopyMove[l_Idx] = TRUE
   l_Files[l_Idx]    = files[l_Idx]
NEXT

IF Right(from_directory, 1) <> i_DirDelim THEN
   from_directory = from_directory + i_DirDelim
END IF
IF Right(to_directory, 1) <> i_DirDelim THEN
   to_directory = to_directory + i_DirDelim
END IF

IF confirm THEN
   l_Return = fu_FileConfirm(from_directory, to_directory, &
                             files[], l_CopyMove[])

   IF l_Return <> -1 THEN
      l_NumFilesToCopyMove = 0
      FOR l_Idx = 1 TO l_NumFiles
         IF l_CopyMove[l_Idx] THEN
            l_NumFilesToCopyMove = l_NumFilesToCopyMove + 1
            l_Files[l_NumFilesToCopyMove] = files[l_Idx]
         END IF
      NEXT
   ELSE
      RETURN l_Return
   END IF
ELSE
   l_NumFilesToCopyMove = l_NumFiles
END IF

IF l_NumFilesToCopyMove > 0 THEN
   i_PARM.from_directory = from_directory
   i_PARM.to_directory   = to_directory
   i_PARM.files[]        = l_Files[]
   i_PARM.display        = display
   IF UPPER(copy_or_move) = "COPY" THEN
      i_PARM.copy_file = TRUE
   ELSE
      i_PARM.copy_file = FALSE
   END IF
   i_PARM.Answer = 0

	l_Object = OBJCA.MGR.fu_GetDefault("Objects", "FileCopyMove")
	IF l_Object <> "" THEN
   	l_Return = Open(l_Window, l_Object)
	ELSE
		l_Return = -1
	END IF

   IF l_Return <> -1 THEN
      l_Return = i_PARM.Answer
   END IF
ELSE
   l_Return = 0
END IF

RETURN l_Return
end function

public function integer fu_filesaveas (datawindow datawindow, ref string directory);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_FileSaveAs
//  Description   : Save the contents of a DataWindow into a
//                  specific file format.
//
//  Parameters    : DATAWINDOW DataWindow -
//                     DataWindow to save contents of.
//                  STRING     Directory  -
//                     Current working directory after the user
//                     selects the file to save to.
//
//  Return Value  : INTEGER
//                      0 = DataWindow contents saved
//                     -1 = DataWindow save failed
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the file save as variables.
//------------------------------------------------------------------

i_PARM.DW_Name           = datawindow
i_PARM.Current_Directory = directory
i_PARM.Answer            = -1

//------------------------------------------------------------------
//  Open the save rows as response window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "FileSaveAs")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return <> -1 THEN
   	IF i_PARM.Answer = 0 THEN
      	directory = i_PARM.Current_Directory
      	l_Return = 0
   	ELSE
      	l_Return = -1
   	END IF
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public function integer fu_login (string login_title, integer grace_logins, boolean attempt_connection, string login_bitmap, ref transaction trans_object);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_Login
//  Description   : Displays the login window to allow the user to
//                  enter a login and password.
//
//  Parameters    : STRING      Login_Title        - 
//                     Name of the title for the login window.
//                  INTEGER     Grace_Logins       -
//                     Number of attempts the user has to enter a 
//                     valid login and password.
//                  BOOLEAN     Attempt_Connection -
//                     Should the login window attempt to make a
//                     connection to the database.
//                  STRING      Login_Bitmap       -
//                     File name of the bitmap to display on the
//                     login window.  
//                  TRANSACTION Trans_Object       - 
//                     Name of the transaction object to load the
//                     user login and password into.
//
//  Return Value  : INTEGER  
//                      1 = Login not attempted.
//                      0 = Login successful.
//                     -1 = Login error.
//                     -2 = Login failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the login window variables.
//------------------------------------------------------------------

i_PARM.Login_Title        = login_title
i_PARM.Grace_Logins       = grace_logins
i_PARM.Attempt_Connection = attempt_connection
i_PARM.Login_Bitmap       = login_bitmap
i_PARM.Trans_Object       = trans_object
i_PARM.Answer             = 0

//------------------------------------------------------------------
//  Open the login response window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "Login")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return <> -1 THEN
   	l_Return = i_PARM.Answer
   	trans_object = i_PARM.Trans_Object
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public function boolean fu_message (string message_title, ref string message_text, boolean display_only, unsignedlong back_color, unsignedlong text_color);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_Message
//  Description   : Modify or View a message or comment.
//
//  Parameters    : STRING  Message_Title - 
//                     Title on the message window.
//                  STRING  Message_Text  - 
//                     Message to view or modify.
//                  BOOLEAN Display_Only  - 
//                     If TRUE, view message only.  Else, allow
//                     modification.
//
//  Return Value  : BOOLEAN
//                     TRUE  = message changed
//                     FALSE = no change
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  If a title is not given, set the title 'Message'.
//------------------------------------------------------------------

IF IsNull(Message_Title) <> FALSE OR Len(Trim(Message_Title)) = 0 THEN
   i_Parm.Message_Title = "Message"
ELSE
   i_Parm.Message_Title = Message_Title
END IF

//------------------------------------------------------------------
//  Set the text and the modify flag.
//------------------------------------------------------------------

i_Parm.Message_Text = Message_Text
i_Parm.Display_Only = Display_Only
i_Parm.Back_Color   = Back_Color
i_Parm.Text_Color   = Text_Color

//------------------------------------------------------------------
//  Open the message window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "MessageDisplay")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return = -1 THEN
   	RETURN FALSE
	END IF
ELSE
	RETURN FALSE
END IF

//------------------------------------------------------------------
//  If the text has been changed, the changed text will be returned 
//  by this function.
//------------------------------------------------------------------

IF IsNull(Message_Text) <> FALSE THEN
   IF IsNull(i_Parm.Message_Text) <> FALSE THEN
      RETURN FALSE
   ELSE
      Message_Text = i_Parm.Message_Text
      RETURN TRUE
   END IF
ELSE
   IF i_Parm.Message_Text <> Message_Text THEN
      Message_Text = i_Parm.Message_Text
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END IF

end function

public function integer fu_microhelp (window mdi_frame, integer update_seconds, boolean show_clock, boolean show_resources);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_MicroHelp
//  Description   : Display the microhelp window.
//
//  Parameters    : WINDOW   MDI_Frame      -
//                     The MDI window to display the microhelp
//                     window on.
//                  INTEGER  Update_Seconds -
//                     The frequency for which the microhelp
//                     display attributes are updated.
//
//  Return Value  : INTEGER
//                      0 = window open OK
//                     -1 = window open failed
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Make sure that there is a MicroHelp line to display on.  If so
//  initialize the microhelp variables.
//------------------------------------------------------------------

IF MDI_Frame.WindowType = MDIHelp! THEN
   i_Parm.MDI_Frame      = mdi_frame
   i_Parm.Update_Seconds = update_seconds
   i_Parm.Show_Clock     = show_clock
   i_Parm.Show_Resources = show_resources

   //---------------------------------------------------------------
   //  Open the microhelp window.
   //---------------------------------------------------------------

	l_Object = OBJCA.MGR.fu_GetDefault("Objects", "Microhelp")
	IF l_Object <> "" THEN
		l_Return = Open(l_Window, l_Object)
//   	l_Return = Open(w_microhelp)
   	IF l_Return <> -1 THEN
      	l_Return = 0
   	END IF
	ELSE
		l_Return = -1
	END IF
ELSE
   l_Return = -1
END IF

RETURN l_Return
end function

public function integer fu_plaque (string application_name, string application_rev, string application_bitmap);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_Plaque
//  Description   : Display the PLAQUE window.
//
//  Parameters    : STRING  Application_Name   -
//                     Name of the application.
//                  STRING  Application_Rev    -
//                     Revision for the application.
//                  STRING  Application_Bitmap -
//                     Bitmap to display on the plaque window.
//
//  Return Value  : INTEGER
//                     0 = window open OK
//                    -1 = window open failed
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the plaque window variables.
//------------------------------------------------------------------

i_Parm.Application_Name   = application_name
i_Parm.Application_Rev    = application_rev
i_Parm.Application_Bitmap = application_bitmap

//------------------------------------------------------------------
//  Open the plaque response window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "Plaque")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return <> -1 THEN
  	 	l_Return = 0
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public function integer fu_syserror (string syserror_title);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_SysError
//  Description   : Displays and logs system errors.
//
//  Parameters    : STRING   SysError_Title -
//                     Title for the system error window.
//
//  Return Value  : INTEGER
//                     -1 = window opened failed
//                      1 = continue application
//                      2 = halt application
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the system error window variables.
//------------------------------------------------------------------

i_Parm.Title = syserror_title

//------------------------------------------------------------------
//  Open the system error response window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "SystemError")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return <> -1 THEN
   	IF i_Parm.Answer = 2 THEN
      	HALT CLOSE
   	END IF
   	l_Return = 0
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public function integer fu_recordconfirm (string labels[], string action, ref boolean confirm[]);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_RecordConfirm
//  Description   : Displays the record confirmation window for each
//                  record to move, copy, or delete.
//
//  Parameters    : STRING    Labels[]  -
//                     Labels associated with the records to move or
//                     copy.
//                  STRING    Action    -
//                     The action to perform the confirmation on.
//                     Must be "COPY", "MOVE", or "DELETE"
//                  BOOLEAN   Confirm[] -
//                     Results from the confirmation.
//
//  Return Value  : INTEGER 
//                      0 = confirmation successful.
//                     -1 = confirmation cancelled
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return = 0, l_Idx, l_NumRecords, l_Answer, l_Jdx
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the copy/move confirmation variables.
//------------------------------------------------------------------

l_NumRecords = UpperBound(labels[])
FOR l_Idx = 1 TO l_NumRecords
   confirm[l_Idx] = TRUE
NEXT

i_Parm.Multiple = FALSE
IF l_NumRecords > 1 THEN
   i_Parm.Multiple = TRUE
END IF

IF Upper(action) <> "COPY" AND Upper(action) <> "MOVE" AND &
   Upper(action) <> "DELETE" THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Confirm the copy/move of each record.
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_NumRecords
   i_Parm.Label  = labels[l_Idx]
   i_Parm.Action = action
   i_Parm.Answer = 0

	l_Object = OBJCA.MGR.fu_GetDefault("Objects", "RecordConfirm")
	IF l_Object <> "" THEN
   	l_Return = Open(l_Window, l_Object)
		IF l_Return = 1 THEN
			l_Return = 0
		END IF
	ELSE
		l_Return = -1
	END IF

   IF l_Return <> -1 THEN
      l_Answer = i_Parm.Answer
   
      //------------------------------------------------------------
      //  Determine the response from the confirmation window.
      //------------------------------------------------------------

      CHOOSE CASE l_Answer
         CASE 2
            FOR l_Jdx = l_Idx TO l_NumRecords
               confirm[l_Jdx] = TRUE
            NEXT
            EXIT
         CASE 3
            confirm[l_Idx] = FALSE
         CASE 4
            FOR l_Jdx = 1 TO l_NumRecords
               confirm[l_Jdx] = FALSE
            NEXT
            l_Return = -1
            EXIT              
      END  CHOOSE
   ELSE
      FOR l_Jdx = 1 TO l_NumRecords
         confirm[l_Jdx] = FALSE
      NEXT
      EXIT
   END IF
NEXT

//------------------------------------------------------------------
//  Return the copy/move/delete array indicating which records will
//  be copied, moved or deleted.
//------------------------------------------------------------------

RETURN l_Return
end function

public function string fu_getlogin (transaction trans_object);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_GetLogin
//  Description   : Gets the user/logon ID from the transaction
//                  object depending on the type of database being
//                  used.
//
//  Parameters    : TRANSACTION Trans_Object -
//                     Transaction object.
//
//  Return Value  : STRING
//                     User/logon name.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_LoginType

l_LoginType = OBJCA.DB.fu_GetDatabase(trans_object, &
                                      OBJCA.DB.c_DB_LoginType)

IF l_LoginType = "LOGID" THEN
	RETURN trans_object.LogID
ELSEIF l_LoginType = "USERID" THEN
	RETURN trans_object.UserID
ELSE
	RETURN ""
END IF


end function

public function integer fu_setlogin (ref transaction trans_object, string usr_login, string usr_password);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_SetLogin
//  Description   : Sets the user/logon ID and password into the 
//                  transaction object depending on the type of 
//                  database being used.
//
//  Parameters    : TRANSACTION Trans_Object -
//                     Transaction object.
//                  STRING      Usr_Login    -
//                     User/Logon name.
//                  STRING      Usr_Password -
//                     Log/DB password name.
//
//  Return Value  : INTEGER
//                      0 = database found
//                     -1 = database not found
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_DBParm, l_String, l_Char, l_InterfaceType, l_LoginType
INTEGER l_StartPos, l_EndPos, l_Idx, l_Return = 0

l_InterfaceType = OBJCA.DB.fu_GetDatabase(trans_object, &
                                          OBJCA.DB.c_DB_InterfaceType)
l_LoginType     = OBJCA.DB.fu_GetDatabase(trans_object, &
                                          OBJCA.DB.c_DB_LoginType)

IF l_LoginType = "LOGID" THEN
	trans_object.LogID   = Trim(usr_login)
	trans_object.LogPass = Trim(usr_password)
ELSEIF l_LoginType = "USERID" THEN
	trans_object.UserID  = Trim(usr_login)
	trans_object.DBPass  = Trim(usr_password)

	IF l_InterfaceType = "ODBC" THEN
      l_DBParm = trans_object.DBParm
      FOR l_Idx = 1 TO 2
         IF l_Idx = 1 THEN
            l_String = "UID="
         ELSE
            l_String = "PWD="
         END IF

         l_StartPos = POS(UPPER(l_DBParm), l_String)
         IF l_StartPos > 0 THEN
            l_StartPos = l_StartPos + 4
            l_EndPos = l_StartPos
            DO
               l_EndPos = l_EndPos + 1
               l_Char = MID(l_DBParm, l_EndPos, 1)
            LOOP UNTIL l_Char = ";" OR l_Char = "'" OR l_EndPos = Len(l_DBParm)

            IF l_Char <> ";" AND l_Char <> "'" THEN
               l_EndPos = Len(l_DBParm) + 1
            END IF

            IF l_Idx = 1 THEN
               l_DBParm = REPLACE(l_DBParm, l_StartPos, l_EndPos - l_StartPos, trans_object.UserID)
            ELSE
               l_DBParm = REPLACE(l_DBParm, l_StartPos, l_EndPos - l_StartPos, trans_object.DBPass)
            END IF
         END IF
      NEXT
      trans_object.DBParm = l_DBParm
   END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public function integer fu_undelete (datawindow dw_name);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_Undelete
//  Description   : Allows the user to undelete records from the
//                  given DataWindow.
//
//  Parameters    : DATAWINDOW DW_Name -
//                     DataWindow to undelete records from.
//
//  Return Value  : INTEGER
//                      0 = undelete operation OK.
//                     -1 = undelete failed or window open failed.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the undelete window variables.
//------------------------------------------------------------------

i_Parm.DW_Name = dw_name

//------------------------------------------------------------------
//  Open the undelete response window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "Undelete")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return <> -1 THEN
   	l_Return = 0
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public function integer fu_sort (datawindow dw_name);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_Sort
//  Description   : Allows the user to sort records for the
//                  given DataWindow.
//
//  Parameters    : DATAWINDOW DW_Name -
//                     DataWindow to sort records for.
//
//  Return Value  : INTEGER
//                      0 = sort operation OK.
//                     -1 = sort cancelled or window open failed.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the sort window variables.
//------------------------------------------------------------------

i_Parm.DW_Name = dw_name

//------------------------------------------------------------------
//  Open the sort response window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "Sort")
IF l_Object <> "" THEN
	Open(l_Window, l_Object)
ELSE
	RETURN -1
END IF

IF Message.DoubleParm = 0 THEN
   RETURN 0
ELSE
	RETURN -1
END IF
end function

public function integer fu_plaque ();//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_Plaque
//  Description   : Display the PLAQUE window.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER
//                     0 = window open OK
//                    -1 = window open failed
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the plaque window variables.
//------------------------------------------------------------------

i_Parm.Application_Name   = OBJCA.MGR.i_ApplicationName
i_Parm.Application_Rev    = OBJCA.MGR.i_ApplicationRev
i_Parm.Application_Bitmap = OBJCA.MGR.i_ApplicationBitmap

//------------------------------------------------------------------
//  Open the plaque response window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "Plaque")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return <> -1 THEN
   	l_Return = 0
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public subroutine fu_microhelpposition ();//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_MicroHelpPosition
//  Description   : Re-position the microhelp window when the MDI
//                  window is resized or moved.
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
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(i_MicroHelp) THEN
	i_MicroHelp.DYNAMIC fw_SetPosition()
END IF
end subroutine

public subroutine fu_microhelpclose ();//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_MicroHelpClose
//  Description   : Close the microhelp window.
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
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(i_MicroHelp) THEN
	Close(i_MicroHelp)
END IF
end subroutine

public function integer fu_filesaveas (datastore datastore, ref string directory);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_FileSaveAs
//  Description   : Save the contents of a DataStore into a
//                  specific file format.
//
//  Parameters    : DATASTORE DataStore -
//                     DataStore to save contents of.
//                  STRING     Directory  -
//                     Current working directory after the user
//                     selects the file to save to.
//
//  Return Value  : INTEGER
//                      0 = DataStore contents saved
//                     -1 = DataStore save failed
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Initialize the file save as variables.
//------------------------------------------------------------------

i_PARM.DS_Name 			 = datastore
i_PARM.Current_Directory = directory
i_PARM.Answer            = -1

//------------------------------------------------------------------
//  Open the save rows as response window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "FileSaveAs")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return <> -1 THEN
   	IF i_PARM.Answer = 0 THEN
      	directory = i_PARM.Current_Directory
      	l_Return = 0
   	ELSE
      	l_Return = -1
   	END IF
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public function integer fu_about ();//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_About
//  Description   : Display the ABOUT window.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER
//                      0 = window open OK    
//                     -1 = window open failed
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Set the variables into the structure to pass to the window.
//------------------------------------------------------------------

i_Parm.Application_Name      = OBJCA.MGR.i_ApplicationName
i_Parm.Application_Rev       = OBJCA.MGR.i_ApplicationRev
i_Parm.Application_Bitmap    = OBJCA.MGR.i_ApplicationBitmap
i_Parm.Application_Copyright = OBJCA.MGR.i_ApplicationCopyright

//------------------------------------------------------------------
//  Open the about window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "About")
IF l_Object <> "" THEN
	l_Return = Open(l_Window, l_Object)
	IF l_Return <> -1 THEN
   	l_Return = 0
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public function integer fu_getconnectinfo (string ini_file, string ini_section, ref transaction trans_object);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_GetConnectInfo
//  Description   : Loads the given transaction object with connect
//                  information stored in an INI file.
//
//  Parameters    : STRING      INI_File     - 
//                     Name of an INI file.
//                  STRING      INI_Section  - 
//                     Name of section within the INI file.
//                  TRANSACTION Trans_Object - 
//                     Transaction object.
//
//  Return Value  : INTEGER
//                     0 = Connection information loaded
//                    -1 = INI file not found
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/11/2001 K. Claver Added code to accomodate for the autocommit
//								 property of the trans object.
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING l_ErrorStrings[]

//------------------------------------------------------------------
//  Check for the existence of the INI file.
//------------------------------------------------------------------

IF NOT FileExists(ini_file) THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_GetConnectInfo"
   l_ErrorStrings[6] = ini_file
   OBJCA.MSG.fu_DisplayMessage("INIMissingError", &
                               6, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  Load the transaction object with the values from the INI file.
//------------------------------------------------------------------

trans_object.DBMS       = ProfileString(ini_file, &
                                        ini_section, "DBMS", "")
trans_object.Database   = ProfileString(ini_file, &
                                        ini_section, "DataBase", "")
trans_object.UserId     = ProfileString(ini_file, &
                                        ini_section, "UserId", "")
trans_object.DBPass     = ProfileString(ini_file, &
                                        ini_section, "DBPass", "")
trans_object.LogId      = ProfileString(ini_file, &
                                        ini_section, "LogId", "")
trans_object.LogPass    = ProfileString(ini_file, &
                                        ini_section, "LogPass", "")
trans_object.ServerName = ProfileString(ini_file, &
                                        ini_section, "ServerName", "")
trans_object.DBParm     = ProfileString(ini_file, &
                                        ini_section, "DBParm", "")
													 
IF Upper( ProfileString(ini_file, ini_section, "AutoCommit", "") ) = "TRUE" THEN
	trans_object.AutoCommit = TRUE
ELSE
	trans_object.AutoCommit = FALSE
END IF

RETURN 0
end function

public function integer fu_getconnectinfo (string reg_key, ref transaction trans_object);//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Function      : fu_GetConnectInfo
//  Description   : Loads the given transaction object with connect
//                  information stored in the registry.
//
//  Parameters    : STRING      Reg_Key      - 
//                     Name of fully qualified registry key.
//                  TRANSACTION Trans_Object - 
//                     Transaction object.
//
//  Return Value  : INTEGER
//                     0 = Connection information loaded
//                    -1 = Registry key not found
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_ErrorStrings[], l_ValueNames[], l_AutoCommit
INTEGER l_Error, l_NumValues, l_Idx

//------------------------------------------------------------------
//  Grab a list of value names for the registry key.
//------------------------------------------------------------------

l_Error = RegistryValues(reg_key, l_ValueNames[])
IF l_Error = -1 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_GetConnectInfo"
	l_ErrorStrings[6] = reg_key
	OBJCA.MSG.fu_DisplayMessage("RegKeyMissingError", &
	                            6, l_ErrorStrings[])
	RETURN -1
END IF

//------------------------------------------------------------------
//  Load the transaction object with the values corresponding to the
//  value names that were retrieved for the registry key.
//------------------------------------------------------------------

l_NumValues = UpperBound(l_ValueNames[])
FOR l_Idx = 1 TO l_NumValues
   CHOOSE CASE Upper(l_ValueNames[l_Idx])
		CASE "DBMS"
         RegistryGet(reg_key, "DBMS", trans_object.DBMS)
		CASE "DATABASE"
         RegistryGet(reg_key, "DATABASE", trans_object.Database)
		CASE "USERID"
         RegistryGet(reg_key, "USERID", trans_object.UserId)
		CASE "DBPASS"
         RegistryGet(reg_key, "DBPASS", trans_object.DBPass)
		CASE "LOGID"
         RegistryGet(reg_key, "LOGID", trans_object.LogId)
		CASE "LOGPASS"
         RegistryGet(reg_key, "LOGPASS", trans_object.LogPass)
		CASE "SERVERNAME"
         RegistryGet(reg_key, "SERVERNAME", trans_object.ServerName)
		CASE "DBPARM"
         RegistryGet(reg_key, "DBPARM", trans_object.DBParm)
		CASE "AUTOCOMMIT"
			RegistryGet(reg_key, "AUTOCOMMIT", l_AutoCommit)
			IF Upper( l_AutoCommit ) = "TRUE" THEN
				trans_object.AutoCommit = TRUE
			ELSE
				trans_object.AutoCommit = FALSE
			END IF
	END CHOOSE
NEXT

RETURN 0
end function

on n_objca_win.create
call super::create
end on

on n_objca_win.destroy
call super::destroy
end on

event constructor;call super::constructor;//******************************************************************
//  PO Module     : n_OBJCA_WIN
//  Event         : Constructor
//  Description   : Initializes the utility window manager.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

i_WindowTextFont  = GetItemString(1, "text_font")
i_WindowTextSize  = GetItemNumber(1, "text_size") * -1
i_WindowTextColor = GetItemNumber(1, "text_color")
i_WindowColor     = GetItemNumber(1, "background_color")
end event

