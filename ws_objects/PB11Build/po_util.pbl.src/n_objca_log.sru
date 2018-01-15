$PBExportHeader$n_objca_log.sru
$PBExportComments$Log utilities data store
forward
global type n_objca_log from n_objca_mgr
end type
end forward

type s_loginfo from structure
	string		id
	string		filename
	transaction		transobject
	integer		numcolumns
	string		columntitles[]
	boolean		append
	boolean		systemmsg
end type

global type n_objca_log from n_objca_mgr
string DataObject=""
end type
global n_objca_log n_objca_log

type variables
//----------------------------------------------------------------------------------------
//  Log Instance Variables
//---------------------------------------------------------------------------------------

STRING			i_LogDateFormat
STRING			i_LogTimeFormat

INTEGER		i_NumLogs		= 0
PRIVATE S_LOGINFO	i_Logs[]

end variables

forward prototypes
public function integer fu_logwrite (string log_id, string log_strings[])
public function integer fu_logstart (string log_id)
public function integer fu_logend (string log_id)
public subroutine fu_traceon ()
public subroutine fu_traceoff ()
public subroutine fu_logoptions (string log_id, string file_name, string column_titles[], string options)
public subroutine fu_logoptions (string log_id, transaction trans_object, string column_titles[], string options)
public subroutine fu_logoptions (string log_id, string file_name, transaction trans_object, string column_titles[], string options)
end prototypes

public function integer fu_logwrite (string log_id, string log_strings[]);//******************************************************************
//  PO Module     : n_OBJCA_LOG
//  Function      : fu_LogWrite
//  Description   : Add an entry to specified log.                 
//
//  Parameters    : STRING      Log_ID -
//                     Name of the log.
//                  STRING      Log_Strings[] -
//                     Strings to write to the log.
//
//  Return Value  : INTEGER - 0, log write successful
//                           -1, log write unsuccessful
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_LogNum, l_Idx, l_NumStrings
LONG    l_Row
DATE    l_LogDate
TIME    l_LogTime

//------------------------------------------------------------------
//  Grab the date and time.
//------------------------------------------------------------------

l_LogDate = Today()
l_LogTime = Now()

//------------------------------------------------------------------
//  Make sure that the specified log is defined.
//------------------------------------------------------------------

l_LogNum = 0
FOR l_Idx = 1 TO i_NumLogs
	IF i_Logs[l_Idx].ID = Log_ID THEN
		l_LogNum = l_Idx
		EXIT
	END IF
NEXT

IF l_LogNum = 0 THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  Check to see if this is a PowerClass or PowerObjects system
//  error.
//------------------------------------------------------------------

l_NumStrings = UpperBound(Log_Strings[])
IF l_NumStrings > 0 THEN
   IF Log_Strings[1] = "PowerClass Error" OR &
      Log_Strings[1] = "PowerObjects Error" THEN
	   IF NOT i_Logs[l_LogNum].SystemMsg THEN
		   RETURN -1
	   END IF
   END IF
END IF

//------------------------------------------------------------------
//  If the specified log is not current, then end the current log
//  and start this one.
//------------------------------------------------------------------

IF i_CurrentLog <> Log_ID THEN
	IF i_CurrentLog <> "" THEN
	   IF fu_LogEnd(i_CurrentLog) < 0 THEN
		   RETURN -1
	   END IF
	END IF
	IF fu_LogStart(Log_ID) < 0 THEN
		RETURN -1
	END IF
END IF

//------------------------------------------------------------------
//  Write to the current log.
//------------------------------------------------------------------

l_Row = OBJCA.LOG.InsertRow(0)
SetItem(l_Row, "log_id", i_CurrentLog)
SetItem(l_Row, "log_date", String(l_LogDate, i_LogDateFormat))
SetItem(l_Row, "log_time", String(l_LogTime, i_LogTimeFormat))
		  
FOR l_Idx = 1 TO 10
	IF l_Idx <= l_NumStrings THEN
	   SetItem(l_Row, "log" + String(l_Idx), Log_Strings[l_Idx])
	ELSE
		SetItem(l_Row, "log" + String(l_Idx), " ")
	END IF
NEXT

RETURN 0
end function

public function integer fu_logstart (string log_id);//******************************************************************
//  PO Module     : n_OBJCA_LOG
//  Function      : fu_LogStart
//  Description   : Start the specified log.
//
//  Parameters    : STRING      Log_ID -
//                     Name of the log.
//
//  Return Value  : INTEGER - 0, log started
//                           -1, log start error
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_LogNum, l_Jdx, l_Row
LONG    l_Idx, l_RowCount
STRING  l_LogID
BOOLEAN l_LogFromFile, l_TitlesSet

//------------------------------------------------------------------
//  Make sure that the specified log is defined.
//------------------------------------------------------------------

l_LogNum = 0
FOR l_Idx = 1 TO i_NumLogs
	IF i_Logs[l_Idx].ID = Log_ID THEN
		l_LogNum = l_Idx
		EXIT
	END IF
NEXT

IF l_LogNum = 0 THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  If another log is current, shut it down.
//------------------------------------------------------------------

IF i_CurrentLog <> Log_ID AND i_CurrentLog <> "" THEN
	IF fu_LogEnd(i_CurrentLog) < 0 THEN
		RETURN -1
	END IF
END IF

//------------------------------------------------------------------
//  Determine if the log is a file or a database table.
//------------------------------------------------------------------

IF i_Logs[l_LogNum].FileName = "" THEN
	l_LogFromFile = FALSE
ELSE
	l_LogFromFile = TRUE
END IF

//------------------------------------------------------------------
//  Initialize the log manager.
//------------------------------------------------------------------

IF l_LogFromFile THEN
	
   //---------------------------------------------------------------
   //  Swap in the external data object.
	//---------------------------------------------------------------
	
	OBJCA.LOG.DataObject = "d_objca_log_file"
	
   //---------------------------------------------------------------
   //  Try to find the file.
	//---------------------------------------------------------------
	
	IF FileExists(i_Logs[l_LogNum].FileName) THEN
		
      //---------------------------------------------------------
      //  If appending to the log, load the file into the log
      //  manager.
      //---------------------------------------------------------
		
		IF i_Logs[l_LogNum].Append THEN
			IF ImportFile(i_Logs[l_LogNum].FileName) <= 0 THEN
				RETURN -1
			END IF
		END IF
	END IF
	
   //---------------------------------------------------------------
   //  Check to see the column titles have been set for this log ID.
   //---------------------------------------------------------------

	l_TitlesSet = FALSE
	l_RowCount = OBJCA.LOG.RowCount()
	FOR l_Idx = 1 TO l_RowCount
		l_LogID = OBJCA.LOG.GetItemString(l_Idx, "log_id")
		IF l_LogID = Log_ID + "|TITLES|" THEN
			
         //---------------------------------------------------------
         //  This log ID already has column titles set, but they 
         //  may have changed so set them again.
         //---------------------------------------------------------
			
			FOR l_Jdx = 1 TO 10
				IF l_Jdx <= i_Logs[l_LogNum].NumColumns THEN
					SetItem(l_Idx, "log" + String(l_Jdx), &
					        i_Logs[l_LogNum].ColumnTitles[l_Jdx])
				ELSE
					SetItem(l_Idx, "log" + String(l_Jdx), " ")
				END IF
			NEXT
			l_TitlesSet = TRUE
			EXIT
		ELSEIF Pos(l_LogID, "|TITLES|") = 0 THEN
			l_TitlesSet = FALSE
			EXIT
		END IF
	NEXT
	
	IF NOT l_TitlesSet THEN
	
      //------------------------------------------------------------
      //  This log ID does not have column titles set, so insert a
      //  row at the beginning and set the information in it.
      //------------------------------------------------------------
			
		l_Row = OBJCA.LOG.InsertRow(1)
		SetItem(l_Row, "log_id", Log_ID + "|TITLES|")
		SetItem(l_Row, "log_date", " ")
		SetItem(l_Row, "log_time", " ")
		FOR l_Idx = 1 TO 10
			IF l_Idx <= i_Logs[l_LogNum].NumColumns THEN
				SetItem(l_Row, "log" + String(l_Idx), &
					     i_Logs[l_LogNum].ColumnTitles[l_Idx])
			ELSE
				SetItem(l_Row, "log" + String(l_Idx), " ")
			END IF
		NEXT
	END IF
ELSE
	
   //---------------------------------------------------------------
   //  Swap in the SQL select data object.
	//---------------------------------------------------------------
	
	OBJCA.LOG.DataObject = "d_objca_log_db"
	
   //---------------------------------------------------------------
   //  Set the transaction object.
	//---------------------------------------------------------------
	
	IF OBJCA.LOG.SetTransObject(i_Logs[l_LogNum].TransObject) < 0 THEN
		RETURN -1
	END IF
	
   //---------------------------------------------------------------
   //  Clear out the log table, if overwriting.
	//---------------------------------------------------------------
	
	IF NOT i_Logs[l_LogNum].Append THEN
		DELETE FROM po_log USING i_Logs[l_LogNum].TransObject;		
		IF i_Logs[l_LogNum].TransObject.SQLCode < 0 THEN
			RETURN -1
		END IF
		
		COMMIT USING i_Logs[l_LogNum].TransObject;
		IF i_Logs[l_LogNum].TransObject.SQLCode < 0 THEN
			RETURN -1
		END IF
	ELSE
		
      //------------------------------------------------------------
      //  Delete the column titles for this log ID.
      //------------------------------------------------------------
		
      l_LogID = Log_ID + "|TITLES|"
		DELETE FROM po_log 
		   WHERE log_id = :l_LogID 
			USING i_Logs[l_LogNum].TransObject;
		IF i_Logs[l_LogNum].TransObject.SQLCode < 0 THEN
			RETURN -1
		END IF
		
		COMMIT USING i_Logs[l_LogNum].TransObject;
		IF i_Logs[l_LogNum].TransObject.SQLCode < 0 THEN
			RETURN -1
		END IF
	END IF
	
   //---------------------------------------------------------------
   //  Set the column titles.
   //---------------------------------------------------------------
	
   l_Row = OBJCA.LOG.InsertRow(1)
	SetItem(l_Row, "log_id", Log_ID + "|TITLES|")
	SetItem(l_Row, "log_date", " ")
	SetItem(l_Row, "log_time", " ")
	FOR l_Idx = 1 TO 10
		IF l_Idx <= i_Logs[l_LogNum].NumColumns THEN
			SetItem(l_Row, "log" + String(l_Idx), &
					  i_Logs[l_LogNum].ColumnTitles[l_Idx])
		ELSE
			SetItem(l_Row, "log" + String(l_Idx), " ")
		END IF
	NEXT
END IF

//------------------------------------------------------------------
//  Set the current log.
//------------------------------------------------------------------

i_CurrentLog = i_Logs[l_LogNum].ID

RETURN 0
end function

public function integer fu_logend (string log_id);//******************************************************************
//  PO Module     : n_OBJCA_LOG
//  Function      : fu_LogEnd
//  Description   : End the specified log.
//
//  Parameters    : STRING      Log_ID -
//                     Name of the log.
//
//  Return Value  : INTEGER - 0, log ended
//                           -1, log end error
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_LogNum, l_Idx
BOOLEAN l_LogFromFile

//------------------------------------------------------------------
//  Make sure that the specified log is defined.
//------------------------------------------------------------------

l_LogNum = 0
FOR l_Idx = 1 TO i_NumLogs
	IF i_Logs[l_Idx].ID = Log_ID THEN
		l_LogNum = l_Idx
		EXIT
	END IF
NEXT

IF l_LogNum = 0 THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  If this isn't the current log, then there isn't anything to 
//  shut down.
//------------------------------------------------------------------

IF i_CurrentLog <> Log_ID THEN
	RETURN 0
END IF

//------------------------------------------------------------------
//  Determine if the log is a file or database table.
//------------------------------------------------------------------

IF i_Logs[l_LogNum].FileName = "" THEN
	l_LogFromFile = FALSE
ELSE
	l_LogFromFile = TRUE
END IF

//------------------------------------------------------------------
//  Save the data in the log manager to the file or database.
//------------------------------------------------------------------

IF l_LogFromFile THEN
	
   //---------------------------------------------------------------
   //  Since the old log file was deleted when this log was started
   //  up, just save the rows.
   //---------------------------------------------------------------

	IF NOT FileDelete(i_Logs[l_LogNum].FileName) THEN
		RETURN -1
	END IF
	
	IF OBJCA.LOG.SaveAs(i_Logs[l_LogNum].FileName, Text!, FALSE) < 0 THEN
		RETURN -1
	END IF
	
ELSE
	
   //---------------------------------------------------------------
   //  Update the log manager back to the database.
   //---------------------------------------------------------------
	
	IF OBJCA.LOG.Update() < 0 THEN
		RETURN -1
	END IF
	
	COMMIT USING i_Logs[l_LogNum].TransObject;
	IF i_Logs[l_LogNum].TransObject.SQLCode < 0 THEN
		RETURN -1
	END IF

END IF

//------------------------------------------------------------------
//  Reset the current log and the log manager.
//------------------------------------------------------------------

i_CurrentLog = ""
OBJCA.LOG.Reset()

RETURN 0
end function

public subroutine fu_traceon ();
end subroutine

public subroutine fu_traceoff ();
end subroutine

public subroutine fu_logoptions (string log_id, string file_name, string column_titles[], string options);//******************************************************************
//  PO Module     : n_OBJCA_LOG
//  Function      : fu_LogOptions
//  Description   : Calls the full version of the function 
//                  passing in a null transaction object.
//
//  Parameters    : STRING      Log_ID -
//                     Name of the log.
//                  STRING      File_Name -
//                     Name of the log file.
//                  STRING      Column_Titles[] -
//                     Titles to display for the columns in the
//                     configuration painter.
//                  STRING      Options -
//                     Control options for the log.
//
//  Return Value  : None.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

TRANSACTION l_NullTrans

SetNull(l_NullTrans)

fu_LogOptions(Log_ID, File_Name, l_NullTrans, &
              Column_Titles[], Options)
end subroutine

public subroutine fu_logoptions (string log_id, transaction trans_object, string column_titles[], string options);//******************************************************************
//  PO Module     : n_OBJCA_LOG
//  Function      : fu_LogOptions
//  Description   : Calls the full version of the function passing
//                  in an empty file name.
//
//  Parameters    : STRING      Log_ID -
//                     Name of the log.
//                  TRANSACTION Trans_Object -
//                     The transaction object.
//                  STRING      Column_Titles[] -
//                     Titles to display for the columns in the
//                     configuration painter.
//                  STRING      Options -
//                     Control options for the log.
//
//  Return Value  : None.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

fu_LogOptions(Log_ID, "", Trans_Object, Column_Titles[], Options)
end subroutine

public subroutine fu_logoptions (string log_id, string file_name, transaction trans_object, string column_titles[], string options);//******************************************************************
//  PO Module     : n_OBJCA_LOG
//  Function      : fu_LogOptions
//  Description   : Set the options for the log.
//
//  Parameters    : STRING      Log_ID -
//                     Name of the log.
//                  STRING      File_Name -
//                     Name of the log file.
//                  TRANSACTION Trans_Object -
//                     The transaction object.
//                  STRING      Column_Titles[] -
//                     Titles to display for the columns in the
//                     configuration painter.
//                  STRING      Options -
//                     Control options for the log.
//
//  Return Value  : None.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_LogNum, l_Idx
STRING  l_Defaults

//------------------------------------------------------------------
//  Check to see if this log has already been loaded.
//------------------------------------------------------------------

l_LogNum = 0
FOR l_Idx = 1 TO i_NumLogs
	IF i_Logs[l_Idx].ID = Log_ID THEN
		l_LogNum = l_Idx
		EXIT
	END IF
NEXT

IF l_LogNum = 0 THEN
	i_NumLogs++
	l_LogNum = i_NumLogs
END IF

//------------------------------------------------------------------
//  Set the log options.
//------------------------------------------------------------------

i_Logs[l_LogNum].ID          = Log_ID
i_Logs[l_LogNum].FileName    = File_Name
i_Logs[l_LogNum].TransObject = Trans_Object
i_Logs[l_LogNum].NumColumns  = UpperBound(Column_Titles[])

//------------------------------------------------------------------
//  Load the column titles.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_Logs[l_LogNum].NumColumns
   i_Logs[l_LogNum].ColumnTitles[l_Idx] = Column_Titles[l_Idx]
NEXT

//------------------------------------------------------------------
//  Grab the general defaults.
//------------------------------------------------------------------

l_Defaults = OBJCA.MGR.fu_GetDefault("LogManager", "General")

//------------------------------------------------------------------
//  Append to the log.
//------------------------------------------------------------------

IF Pos(Options, c_LogAppend) > 0 THEN
	i_Logs[l_LogNum].Append = TRUE
ELSEIF Pos(Options, c_LogOverwrite) > 0 THEN
	i_Logs[l_LogNum].Append = FALSE
ELSEIF l_LogNum = i_NumLogs THEN
	IF Pos(l_Defaults, c_LogAppend) > 0 THEN
	   i_Logs[l_LogNum].Append = TRUE
	ELSEIF Pos(l_Defaults, c_LogOverwrite) > 0 THEN
		i_Logs[l_LogNum].Append = FALSE
	ELSE
		i_Logs[l_LogNum].Append = TRUE
	END IF
END IF

//------------------------------------------------------------------
//  Log system error messages.
//------------------------------------------------------------------

IF Pos(Options, c_LogSystemMsg) > 0 THEN
	i_Logs[l_LogNum].SystemMsg = TRUE
ELSEIF Pos(Options, c_NoLogSystemMsg) > 0 THEN
	i_Logs[l_LogNum].SystemMsg = FALSE
ELSEIF l_LogNum = i_NumLogs THEN
	IF Pos(l_Defaults, c_LogSystemMsg) > 0 THEN
	   i_Logs[l_LogNum].SystemMsg = TRUE
	ELSEIF Pos(l_Defaults, c_NoLogSystemMsg) > 0 THEN
		i_Logs[l_LogNum].SystemMsg = FALSE
	ELSE
		i_Logs[l_LogNum].SystemMsg = FALSE
	END IF
END IF
end subroutine

on n_objca_log.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on n_objca_log.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

event constructor;call super::constructor;//******************************************************************
//  PO Module     : n_OBJCA_LOG
//  Event         : Constructor
//  Description   : Initializes default values for the log manager.
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
//  Set the default date format.
//------------------------------------------------------------------

i_LogDateFormat = OBJCA.MGR.fu_GetDefault("Global", "DateFormat")

//------------------------------------------------------------------
//  Set the default time format.
//------------------------------------------------------------------

i_LogTimeFormat = OBJCA.MGR.fu_GetDefault("Global", "TimeFormat")


end event

