$PBExportHeader$w_dw_search.srw
forward
global type w_dw_search from w_response_std
end type
type p_1 from picture within w_dw_search
end type
type st_5 from statictext within w_dw_search
end type
type st_4 from statictext within w_dw_search
end type
type dw_criteria from datawindow within w_dw_search
end type
type st_2 from statictext within w_dw_search
end type
type st_1 from statictext within w_dw_search
end type
type cb_ok from u_cb_ok within w_dw_search
end type
type cb_cancel from u_cb_cancel within w_dw_search
end type
type st_3 from statictext within w_dw_search
end type
type ln_1 from line within w_dw_search
end type
type ln_2 from line within w_dw_search
end type
type ln_3 from line within w_dw_search
end type
type ln_4 from line within w_dw_search
end type
end forward

global type w_dw_search from w_response_std
integer width = 1989
integer height = 1196
string title = "Specify Retrieval Criteria"
p_1 p_1
st_5 st_5
st_4 st_4
dw_criteria dw_criteria
st_2 st_2
st_1 st_1
cb_ok cb_ok
cb_cancel cb_cancel
st_3 st_3
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
end type
global w_dw_search w_dw_search

type variables
String i_cOriginalDWSyntax, i_cNewDWSyntax, i_cColType[ ]
end variables

forward prototypes
public function string fw_datebyformat (datetime a_dtdatetime, string a_cformat)
public function string fw_addowner (string a_cdbname)
end prototypes

public function string fw_datebyformat (datetime a_dtdatetime, string a_cformat);//////////////////////////////////////////////////////////////////////////////
//
//	Function:      fw_DateByFormat
//
//	Access:  		public
//
//	Arguments:
//	a_dtDateTime   Datetime variable containing the start date and time.
// a_cFormat	   String containing the format to format the start date to.
//
//	Returns:  		String containing the formatted date if successful.  Empty
//						string if not successful.
//
//	Description:  	Format the date to the passed format
//						 
//								 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	1.0   KMC Initial version
//////////////////////////////////////////////////////////////////////////////
String l_cFormat, l_cCentury, l_cYear, l_cDay, l_cMonth, l_cHour, l_cChar, l_cLastChar = ""
String l_cMinute, l_cSecond, l_cMSecond, l_cRV = "", l_cDate, l_cValidChars = "CYMDHMSFI-:._/\ "
Date l_dDate
Time l_tTime
Integer l_nIndex

//If no format, return as default format
IF Trim( a_cFormat ) = "**" THEN
	RETURN String( a_dtDateTime, "mm/dd/yyyy" )
END IF

l_cDate = String( a_dtDateTime, "yyyy-mm-dd hh:mm:ss.fff" )
l_cFormat = Upper( a_cFormat )
l_dDate = Date( a_dtDateTime )
l_tTime = Time( a_dtDateTime ) 

//Century
IF Pos( l_cFormat, "CCC" ) > 0 THEN
	//Bad century format
	RETURN ""
ELSEIF Pos( l_cFormat, "CC" ) > 0 THEN
	l_cCentury = "0"+Mid( String( Year( l_dDate ) ), 1, 1 )
ELSEIF Pos( l_cFormat, "C" ) > 0 THEN
	l_cCentury = Mid( String( Year( l_dDate ) ), 1, 1 )
END IF

//Year
IF Pos( l_cFormat, "YYYY" ) > 0 THEN
	l_cYear = String( Year( l_dDate ) )
ELSEIF Pos( l_cFormat, "YY" ) > 0 THEN
	l_cYear = Mid( String( Year( l_dDate ) ), 3, 2 )
ELSEIF Pos( l_cFormat, "Y" ) > 0 THEN
	//Bad year format
	RETURN ""
END IF

//Month
IF Pos( l_cFormat, "MM" ) > 0 THEN
	l_cMonth = String( Month( l_dDate ) )
	IF Len( l_cMonth ) = 1 THEN
		l_cMonth = "0"+l_cMonth
	END IF
ELSEIF Pos( l_cFormat, "M" ) > 0 THEN
	//Bad month format
	RETURN ""
END IF

//Day
IF Pos( l_cFormat, "DD" ) > 0 THEN
	l_cDay = String( Day( l_dDate ) )
	IF Len( l_cDay ) = 1 THEN
		l_cDay = "0"+l_cDay
	END IF
ELSEIF Pos( l_cFormat, "D" ) > 0 THEN
	//Bad day format
	RETURN ""
END IF

//Hour
IF Pos( l_cFormat, "HH" ) > 0 THEN
	l_cHour = String( Hour( l_tTime ) )
	IF Len( l_cHour ) = 1 THEN
		l_cHour = "0"+l_cHour
	END IF
ELSEIF Pos( l_cFormat, "H" ) > 0 THEN
	//Bad hour format
	RETURN ""
END IF

//Minute
IF Pos( l_cFormat, "MI" ) > 0 THEN
	l_cMinute = String( Minute( l_tTime ) )
	IF Len( l_cMinute ) = 1 THEN
		l_cMinute = "0"+l_cMinute
	END IF
ELSEIF Pos( l_cFormat, "M" ) > 0 THEN
	//Account for Month having the same first character
	IF Mid( l_cFormat, ( Pos( l_cFormat, "M" ) + 1 ), 1 ) <> "M" AND &
		Mid( l_cFormat, ( Pos( l_cFormat, "M" ) + 1 ), 1 ) <> "I" THEN
		//Bad minute format
		RETURN ""
	END IF
END IF

//Second
IF Pos( l_cFormat, "SS" ) > 0 THEN
	l_cSecond = String( Second( l_tTime ) )
	IF Len( l_cSecond ) = 1 THEN
		l_cSecond = "0"+l_cSecond
	END IF
ELSEIF Pos( l_cFormat, "S" ) > 0 THEN
	//Bad second format
	RETURN ""
END IF
	
//MilliSecond
IF Pos( l_cFormat, "FFF" ) > 0 THEN
	l_cMSecond = Mid( l_cDate, 21, 3 )
ELSEIF Pos( l_cFormat, "F" ) > 0 THEN
	//Bad millisecond format
	RETURN ""
END IF

//Make the formatted date
FOR l_nIndex = 1 TO Len( l_cFormat )
	l_cChar = Trim( Mid( l_cFormat, l_nIndex, 1 ) )
	
	IF Pos( l_cValidChars, l_cChar ) > 0 THEN
		IF l_cChar <> l_cLastChar THEN
			CHOOSE CASE l_cChar
				CASE "C"
					l_cRV += l_cCentury
				CASE "Y"
					l_cRV += l_cYear
				CASE "M"
					//accomodate for similarity between minute and month
					//  format character
					IF Mid( a_cFormat, ( l_nIndex + 1 ), 1 ) <> "I" THEN
						l_cRV += l_cMonth
					ELSEIF Mid( a_cFormat, ( l_nIndex + 1 ), 1 ) = "I" THEN
						l_cRV += l_cMinute						
					END IF
				CASE "D"
					l_cRV += l_cDay
				CASE "H"
					l_cRV += l_cHour
				//Minutes accomodated above with months	
				CASE "S"
					l_cRV += l_cSecond
				CASE "F"
					l_cRV += l_cMSecond
				CASE ELSE
					//Field seperator character(ie. "/",":",".","-","_"," ","\")
					IF l_cChar <> "I" THEN
						l_cRV += l_cChar
					END IF
					CONTINUE
			END CHOOSE
		END IF			
		
		//Make the last char variable equal to the character just processed
		l_cLastChar = l_cChar
	ELSE
		//If not valid format character, return empty string for error
		RETURN ""
	END IF
NEXT	

RETURN l_cRV
end function

public function string fw_addowner (string a_cdbname);/****************************************************************************************
	Function:	fw_AddOwner
	 Purpose: 	Add the table owner to the column if it doesn't already exist in the dbname
					property.
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	11/6/2000 K. Claver    Created.
****************************************************************************************/
Integer l_nLastPos = 0, l_nCount = 0, l_nFromPos, l_nEndTable, l_nTablePos
Integer l_nStartPos
String l_cUpperSyntax, l_cTable, l_cChar, l_cOwner
String l_cAlpha = "qwertyuiopasdfghjklzxcvbnm."

//Check for number of "." in the dbname.  If only one, need to add owner.
DO WHILE Pos( a_cDBName, ".", ( l_nLastPos + 1 ) ) > 0
	l_nLastPos = Pos( a_cDBName, ".", ( l_nLastPos + 1 ) )
	l_nCount ++
LOOP

IF l_nCount = 1 THEN
	l_cUpperSyntax = Upper( i_cNewDWSyntax )
	
	//Parse the table name off of the column.
	l_nEndTable = Pos( a_cDBName, "." )
	l_cTable = Upper( Mid( a_cDBName, 1, ( l_nEndTable - 1 ) ) )
	
	IF Match( l_cUpperSyntax, "PBSELECT" ) THEN
		l_nFromPos = Pos( l_cUpperSyntax, "TABLE", Pos( l_cUpperSyntax, "PBSELECT" ) )
	ELSEIF Match( l_cUpperSyntax, "SELECT" ) THEN
		l_nFromPos = Pos( l_cUpperSyntax, "FROM", Pos( l_cUpperSyntax, "SELECT" ) )	
	END IF
	
	l_nTablePos = Pos( l_cUpperSyntax, l_cTable, l_nFromPos )
		
	l_nStartPos = ( l_nTablePos - 1 )
	l_cChar = Mid( l_cUpperSyntax, l_nStartPos, 1 )
	DO WHILE Pos( Upper( l_cAlpha ), l_cChar ) > 0
		l_nStartPos = ( l_nStartPos - 1 )
		l_cChar = Mid( l_cUpperSyntax, l_nStartPos, 1 )
	LOOP
	
	l_cOwner = Mid( l_cUpperSyntax, ( l_nStartPos + 1 ), ( l_nTablePos - l_nStartPos - 1 ) )
	
	//Add the owner to the beginning of the name to be passed back
	a_cDBName = l_cOwner+a_cDBName
END IF

RETURN a_cDBName
end function

on w_dw_search.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_5=create st_5
this.st_4=create st_4
this.dw_criteria=create dw_criteria
this.st_2=create st_2
this.st_1=create st_1
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_3=create st_3
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.dw_criteria
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_ok
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.ln_1
this.Control[iCurrent+11]=this.ln_2
this.Control[iCurrent+12]=this.ln_3
this.Control[iCurrent+13]=this.ln_4
end on

on w_dw_search.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.dw_criteria)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_3)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
end on

event open;call super::open;/****************************************************************************************
	Event:	open
	Purpose: Initialize syntax instance variables and trigger the event to build the
				criteria datawindow
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	9/13/2000 K. Claver    Created.
****************************************************************************************/
//Set the syntax instance variable to the syntax passed to the window
IF NOT IsNull( Message.StringParm ) AND Trim( Message.StringParm ) <> "" THEN
	i_cNewDWSyntax = Message.StringParm
	
	dw_Criteria.Event Trigger ue_BuildCols( )
END IF
end event

event pc_setoptions;call super::pc_setoptions;/****************************************************************************************
	Event:	pc_SetOptions
	Purpose: Initialize the window
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	9/13/2000 K. Claver    Created.
****************************************************************************************/
fw_SetOptions( c_NoEnablePopup+c_AutoPosition )
end event

type p_1 from picture within w_dw_search
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "C:\WINDOWS\Graphics\reporting.bmp"
boolean focusrectangle = false
end type

type st_5 from statictext within w_dw_search
integer x = 201
integer y = 60
integer width = 1200
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Search"
boolean focusrectangle = false
end type

type st_4 from statictext within w_dw_search
integer width = 2231
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_criteria from datawindow within w_dw_search
event ue_buildcols ( )
event ue_buildwhere ( )
integer x = 297
integer y = 216
integer width = 1623
integer height = 572
integer taborder = 20
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_buildcols;/****************************************************************************************
	Event:	ue_buildcols
	Purpose: Create the datawindow based on the syntax passed to the window
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	9/13/2000 K. Claver    Created.
****************************************************************************************/
Long l_nColPos, l_nCriteriaPos, l_nStart, l_nEnd, l_nColCount = 1, l_nTypePos, l_nNextTypePos
Integer l_nIndex
String l_cColumn, l_cError, l_cCriteriaDWSQL, l_cCriteriaDWSyntax, l_cColDBNameArray[ ]
String l_cDWColText, l_cType
Boolean l_bNotFound

IF NOT IsNull( i_cNewDWSyntax ) AND Trim( i_cNewDWSyntax ) <> "" THEN
	l_nCriteriaPos = Pos( Lower( i_cNewDWSyntax ), "criteria.dialog=yes" )
	DO WHILE l_nCriteriaPos > 0
		//First, remove the criteria.dialog entry
		i_cNewDWSyntax = Replace( i_cNewDWSyntax, l_nCriteriaPos, 20, "" ) 
		
		//Next, get the column name to display in the datawindow
		l_nColPos = Pos( i_cNewDWSyntax, "name", l_nCriteriaPos )
		l_nStart = Pos( i_cNewDWSyntax, "=", l_nColPos )
		l_nEnd = Pos( i_cNewDWSyntax, " ", ( l_nStart + 1 ) )
		
		l_cColumn = Mid( i_cNewDWSyntax, ( l_nStart + 1 ), ( ( l_nEnd - l_nStart ) - 1 ) )
		
		//Now get the column dbname attribute to be set in the new
		//  criteria datawindow for later use
		l_nColPos = Pos( i_cNewDWSyntax, "dbname", l_nCriteriaPos )
		l_nStart = Pos( i_cNewDWSyntax, "~"", l_nColPos )
		l_nEnd = Pos( i_cNewDWSyntax, "~"", ( l_nStart + 1 ) )
		
		l_cColDBNameArray[ l_nColCount ] = Mid( i_cNewDWSyntax, ( l_nStart + 1 ), ( ( l_nEnd - l_nStart ) - 1 ) )
		
		IF l_nColCount = 1 THEN
			//Modify the one existing column
			l_cCriteriaDWSQL = "SELECT SPACE(255) AS '"+l_cColumn+"',"
		ELSE
			l_cCriteriaDWSQL += " SPACE(255) AS '"+l_cColumn+"',"
		END IF

		l_nColCount ++
		l_nCriteriaPos = Pos( Lower( i_cNewDWSyntax ), "criteria.dialog=yes", l_nColPos )
	LOOP
	
	//Now get the column type attribute to be used when converting the search string
	//  to valid format for the select or pbselect
	FOR l_nIndex = 1 TO UpperBound( l_cColDBNameArray )
		l_nStart = 1
		l_bNotFound = TRUE
		DO WHILE l_bNotFound
			l_nTypePos = Pos( i_cNewDWSyntax, "type=", l_nStart )
			l_nStart = ( l_nTypePos + 5 )
			l_nEnd = Pos( i_cNewDWSyntax, " ", l_nTypePos )
			l_cType = Mid( i_cNewDWSyntax, l_nStart, ( l_nEnd - l_nStart ) )
			
			//if the column type has parens, remove
			IF Pos( l_cType, "(" ) > 0 THEN
				l_cType = Mid( l_cType, 1, ( Pos( l_cType, "(" ) - 1 ) )
			END IF
			
			//Find the position of the column
			l_nColPos = Pos( i_cNewDWSyntax, "dbname=~""+l_cColDBNameArray[ l_nIndex ]+"~"", l_nTypePos )
			
			//Find the next type position
			l_nNextTypePos = Pos( i_cNewDWSyntax, "type=", ( l_nTypePos + 1 ) )
			
			IF ( l_nTypePos < l_nColPos AND l_nNextTypePos > l_nColPos ) OR &
			   ( l_nNextTypePos = 0 ) THEN
				//last type or between types...should be the one
				i_cColType[ l_nIndex ] = l_cType
				l_bNotFound = FALSE
			END IF				
		LOOP
	NEXT
	
	//Set Original to New so don't get the built in datawindow retrieval criteria
	//  box if hit cancel
	i_cOriginalDWSyntax = i_cNewDWSyntax
	
	//Trim off the trailing comma
	l_cCriteriaDWSQL = ( Mid( l_cCriteriaDWSQL, 1, ( Len( l_cCriteriaDWSQL ) - 1 ) ) ) + " FROM cusfocus.key_generator"
	
	//Create the datawindow syntax
	l_cCriteriaDWSyntax = SQLCA.SyntaxFromSQL( l_cCriteriaDWSQL, "style(type=grid)", l_cError )
	
	IF NOT IsNull( l_cError ) AND Trim( l_cError ) <> "" THEN
		MessageBox( "Datawindow Syntax Creation Error", l_cError )				
	ELSE
		//Create the datawindow object
		THIS.Create( l_cCriteriaDWSyntax, l_cError )
		
		IF NOT IsNull( l_cError ) AND Trim( l_cError ) <> "" THEN
			MessageBox( "Datawindow Syntax Creation Error", l_cError )
		ELSE
			//Change width of the columns, background color, add a tab sequence, set
			//  empty string as null, set the dbname to be used when creating
			//  the new where clause, set as not moveable and not resizeable
			FOR l_nIndex = 1 TO ( l_nColCount - 1 )
				//Have to set the background mode to zero before change background color
				l_cColumn = THIS.Describe( "#"+String( l_nIndex )+".Name" )
				
				l_cError = THIS.Modify( l_cColumn+".Width='677' "+ &
								 l_cColumn+".Background.Mode='0' "+ &
								 l_cColumn+".Background.Color='"+String( RGB( 255,255,255 ) )+"' "+ &
								 l_cColumn+".TabSequence='"+String( l_nIndex * 10 )+"' "+ &
								 l_cColumn+".Edit.NilIsNull=Yes "+ &
								 l_cColumn+".dbName='"+l_cColDBNameArray[ l_nIndex ]+"'" )
								
				//Set the text	to lower case
				l_cDWColText = THIS.Describe( l_cColumn+"_t.Text" )
				THIS.Modify( l_cColumn+"_t.Text='"+Lower( l_cDWColText )+"'" )
			NEXT
			
			//Set the background color of the datawindow to grey
			THIS.Object.DataWindow.Color = RGB( 192, 192, 192 )
			
			//Add some rows
			FOR l_nIndex = 1 TO 25
				THIS.InsertRow( 0 )
			NEXT
			
			//Set the column and the focus
			THIS.SetColumn( 1 )			
			THIS.SetFocus( )
		END IF
	END IF	
END IF

end event

event ue_buildwhere;/****************************************************************************************
	Event:	ue_buildwhere
	Purpose: Build the new datawindow syntax based on what was entered into the criteria
				datawindow.
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	9/13/2000 K. Claver    Created.
****************************************************************************************/
String l_cArg1, l_cOp, l_cArg2, l_cLogic, l_cSQLWhereList = "", l_cPBWhereList = ""
String l_cDBName, l_cCond, l_cSelect, l_cConvertDate, l_cFormat, l_cDatePart, l_cTimePart
String l_cCondPart, l_cCondSep
Integer l_nRIndex, l_nCIndex, l_nColCount, l_nOpPos, l_nOpLen, l_nSelectLen, l_nCondStart
Integer l_nSQLLogicPos, l_nPBLogicPos, l_nSepPos, l_nNextSepPos, l_nCondPartLen, l_nCondSepPos
Long l_nColPos, l_nLastColPos, l_nJoinPos, l_nLastJoinPos, l_nWherePos, l_nLastWherePos
Long l_nParenPos, l_nNextSecPos, l_nSelectPos, l_nTextPos, l_nStartPos, l_nEndPos
DateTime l_dtDateTime

//Get just the select or pbselect
l_nStartPos = Pos( i_cNewDWSyntax, "retrieve=~"" )
l_nEndPos = Pos( i_cNewDWSyntax, "text(", l_nStartPos )
l_cSelect = Mid( i_cNewDWSyntax, l_nStartPos, ( (l_nEndPos - l_nStartPos ) - 1 ) )
l_nSelectLen = Len( l_cSelect )

//Get the date conversion fields if they exist
l_cConvertDate = Mid( i_cNewDWSyntax, Pos( i_cNewDWSyntax, "#CD#" ) )

//Accept the data entered
THIS.AcceptText( )

// Add Where Conditions
l_nColCount = Integer( THIS.Object.Datawindow.Column.Count )

FOR l_nCIndex = 1 TO l_nColCount
	l_cDBName = THIS.Describe( "#"+String( l_nCIndex )+".dbName" )
	
	//Check for owner and add on if doesn't exist
	l_cDBName = fw_AddOwner( l_cDBName )
	
	FOR l_nRIndex = 1 TO 25
		l_cCond = Trim( THIS.GetItemString( l_nRIndex, l_nCIndex ) )
		
		IF NOT IsNull( l_cCond ) AND Trim( l_cCond ) <> "" THEN
			IF Match( l_cCond, "%" ) AND NOT Match( Upper( l_cCond ), "LIKE" ) THEN
				l_cOp = "LIKE"
				l_nOpPos = 0
			ELSE
				IF Match( l_cCond, "<>" ) THEN
					l_cOp = "<>"
					l_nOpPos = Pos( l_cCond, "<>" )
					l_nOpLen = 2
				ELSEIF Match( l_cCond, "<=" ) THEN
					l_cOp = "<="
					l_nOpPos = Pos( l_cCond, "<=" )
					l_nOpLen = 2
				ELSEIF Match( l_cCond, "<" ) THEN
					l_cOp = "<"
					l_nOpPos = Pos( l_cCond, "<" )
					l_nOpLen = 1
				ELSEIF Match( l_cCond, ">=" ) THEN
					l_cOp = ">="
					l_nOpPos = Pos( l_cCond, ">=" )
					l_nOpLen = 2
				ELSEIF Match( l_cCond, ">" ) THEN
					l_cOp = ">"
					l_nOpPos = Pos( l_cCond, ">" )
					l_nOpLen = 1
				ELSEIF Match( l_cCond, "=" ) THEN
					l_cOp = "="
					l_nOpPos = Pos( l_cCond, "=" )
					l_nOpLen = 1
				ELSEIF Match( Upper( l_cCond ), "NOT IN" ) THEN
					l_cOp = "NOT IN"
					l_nOpPos = Pos( Upper( l_cCond ), "NOT IN" )
					l_nOpLen = 6
				ELSEIF Match( Upper( l_cCond ), "IN" ) THEN
					l_cOp = "IN"
					l_nOpPos = Pos( Upper( l_cCond ), "IN" )
					l_nOpLen = 2
				ELSEIF Match( Upper( l_cCond ), "NOT LIKE" ) THEN
					l_cOp = "NOT LIKE"
					l_nOpPos = Pos( Upper( l_cCond ), "NOT LIKE" )
					l_nOpLen = 8
				ELSEIF Match( Upper( l_cCond ), "LIKE" ) THEN
					l_cOp = "LIKE"
					l_nOpPos = Pos( Upper( l_cCond ), "LIKE" )
					l_nOpLen = 4
				ELSEIF Match( Upper( l_cCond ), "NOT BETWEEN" ) THEN
					l_cOp = "NOT BETWEEN"
					l_nOpPos = Pos( Upper( l_cCond ), "NOT BETWEEN" )
					l_nOpLen = 11
				ELSEIF Match( Upper( l_cCond ), "BETWEEN" ) THEN
					l_cOp = "BETWEEN"
					l_nOpPos = Pos( Upper( l_cCond ), "BETWEEN" )
					l_nOpLen = 7
				ELSEIF Match( Upper( l_cCond ), "IS NOT" ) THEN
					l_cOp = "IS NOT"
					l_nOpPos = Pos( Upper( l_cCond ), "IS NOT" )
					l_nOpLen = 6
				ELSEIF Match( Upper( l_cCond ), "IS" ) THEN
					l_cOp = "IS"
					l_nOpPos = Pos( Upper( l_cCond ), "IS" )
					l_nOpLen = 2
				ELSE
					l_cOp = "="
					l_nOpPos = 0
				END IF
			END IF			
						
			//Remove the operator from the condition
			IF l_nOpPos > 0 THEN
				l_cCond = Trim( Mid( l_cCond, ( l_nOpPos + l_nOpLen ) ) )
			END IF
			
			//Don't attempt date conversions if the operator is "IS", "IS NOT", "LIKE" or "NOT LIKE"
			IF ( l_cOp <> "IS" AND l_cOp <> "IS NOT" ) AND &
			   ( l_cOp <> "LIKE" AND l_cOp <> "NOT LIKE" ) THEN
				//Convert to a date valid for the datasource if need be
				IF NOT IsNull( l_cConvertDate ) AND Trim( l_cConvertDate ) <> "" THEN
					l_nColPos = Pos( Upper( l_cConvertDate ), ( Upper( l_cDBName )+"^" ) )
					IF l_nColPos > 0 THEN
						l_nSepPos = Pos( l_cConvertDate, "^", l_nColPos )
						l_nNextSepPos = Pos( l_cConvertDate, "^", ( l_nSepPos + 1 ) )
						IF l_nNextSepPos > 0 THEN
							l_cFormat = Mid( l_cConvertDate, ( l_nSepPos + 1 ), ( ( l_nNextSepPos - l_nSepPos ) - 1 ) )
						ELSE
							l_cFormat = Mid( l_cConvertDate, ( l_nSepPos + 1 ) )
						END IF
						
						//Initialize variables before convert values
						l_nCondStart = 1
						l_nCondSepPos = 0
						
						//Determine seperator based on operator
						IF l_cOp = "IN" OR l_cOp = "NOT IN" THEN
							l_cCondSep = ","
						ELSE
							l_cCondSep = "AND"
						END IF
						
						//Loop through and convert values
						DO
							//Accomodate for an opening paren if necessary
							IF Pos( l_cCond, "(", l_nCondStart ) > 0 THEN
								l_nCondStart = 2
								IF Mid( l_cCond, l_nCondStart, 1 ) = " " THEN
									DO 
										l_nCondStart ++
									LOOP UNTIL Mid( l_cCond, l_nCondStart, 1 ) <> " "
								END IF
							END IF
														
							//Find the next(or first) seperator position
							l_nCondSepPos = Pos( Upper( l_cCond ), l_cCondSep, ( l_nCondSepPos + 1 ) )
							
							IF l_nCondSepPos > 0 THEN
								l_cCondPart = Trim( Mid( l_cCond, l_nCondStart, ( l_nCondSepPos - l_nCondStart ) ) )
							ELSE
								l_cCondPart = Trim( Mid( l_cCond, l_nCondStart ) )
							END IF
							
							//Get the length of the Condition part for replace later.  Do before
							//  trim off any white space
							l_nCondPartLen = Len( l_cCondPart )
							
							//Take off an end paren if need be
							IF Mid( l_cCondPart, Len( l_cCondPart ), 1 ) = ")" THEN
								l_cCondPart = Trim( Mid( l_cCondPart, 1, ( Len( l_cCondPart ) - 1 ) ) )
								l_nCondPartLen --
							END IF
						
							//Check if surrounded by quotes.  If so, strip off.
							IF Mid( l_cCondPart, 1, 1 ) = "'" THEN
								l_cCondPart = Mid( l_cCondPart, 2, ( Len( l_cCondPart ) - 2 ) )
							END IF
							
							//Split into date and time sections(if time section exists) and convert to
							//  a datetime value
							IF Pos( l_cCondPart, " " ) > 0 THEN
								l_cDatePart = Trim( Mid( l_cCondPart, 1, ( Pos( l_cCondPart, " " ) - 1 ) ) )
								l_cTimePart = Trim( Mid( l_cCondPart, ( Pos( l_cCondPart, " " ) + 1 ) ) )
								l_dtDateTime = DateTime( Date( l_cDatePart ), Time( l_cTimePart ) )
							ELSE
								l_dtDateTime = DateTime( Date( l_cCondPart ), Time( "00:00:00.000" ) )
							END IF
							
							//Convert to formatted date
							l_cCondPart = fw_DateByFormat( l_dtDateTime, l_cFormat )
							
							//If it's a character column, add single quotes before using
							IF i_cColType[ l_nCIndex ] = "char" THEN
								l_cCondPart = "'"+l_cCondPart+"'"
							END IF
							
							//Replace the part we converted with the converted value
							l_cCond = Replace( l_cCond, l_nCondStart, l_nCondPartLen, l_cCondPart )
							
							//Get the next start position
							l_nCondStart = ( Pos( Upper( l_cCond ), l_cCondSep, l_nCondStart ) + Len( l_cCondSep ) )
							IF Mid( l_cCond, l_nCondStart, 1 ) = " " THEN
								DO 
									l_nCondStart ++
								LOOP UNTIL Mid( l_cCond, l_nCondStart, 1 ) <> " "
							END IF
						LOOP UNTIL l_nCondSepPos = 0
					END IF
				END IF
			END IF
					
			//If it's a character column, add single quotes before using
			IF i_cColType[ l_nCIndex ] = "char" AND Mid( l_cCond, 1, 1 ) <> "'" THEN
				l_cCond = "'"+l_cCond+"'"
			END IF
					
			//Add to the where clauses
			IF Match( Upper( l_cSelect ), "WHERE" ) OR Match( l_cSQLWhereList, "WHERE" ) THEN
				l_cSQLWhereList += "("+l_cDBName+" "+l_cOp+" "+l_cCond+") "
			ELSE
				l_cSQLWhereList += " WHERE ("+l_cDBName+" "+l_cOp+" "+l_cCond+") "
			END IF
			
			//Always add "WHERE" if PBSELECT
			l_cPBWhereList += " WHERE( EXP1=~~~""+l_cDBName+"~~~" OP=~~~""+l_cOp+ &
									 "~~~" EXP2=~~~""+l_cCond+"~~~" "
			
			//Add an "OR" logical operator when switching to a new row
			l_nSQLLogicPos = Len( l_cSQLWhereList )
			l_cSQLWhereList += "OR "
			l_nPBLogicPos = Len( l_cPBWhereList )
			l_cPBWhereList += " LOGIC=~~~"OR~~~" ) ~r~n"
		END IF
	NEXT
	
	//Trim off the trailing logic
	IF l_nSQLLogicPos > 0 AND l_nPBLogicPos > 0 THEN
		l_cSQLWhereList = Mid( l_cSQLWhereList, 1, l_nSQLLogicPos )
		l_cPBWhereList = Mid( l_cPBWhereList, 1, l_nPBLogicPos )
	
		//Add an "AND" logical operator when switching to a new column
		l_nSQLLogicPos = Len( l_cSQLWhereList )
		l_cSQLWhereList += "AND "
		l_nPBLogicPos = Len( l_cPBWhereList )
		l_cPBWhereList += " LOGIC=~~~"AND~~~" ) ~r~n"
	END IF
NEXT

IF Trim( l_cSQLWhereList ) <> "" AND Trim( l_cPBWhereList ) <> "" THEN
	//Trim off the trailing logic
	IF l_nSQLLogicPos > 0 AND l_nPBLogicPos > 0 THEN
		l_cSQLWhereList = Mid( l_cSQLWhereList, 1, l_nSQLLogicPos )
		l_cPBWhereList = ( Mid( l_cPBWhereList, 1, l_nPBLogicPos )+" ) ~r~n" )
	END IF
	
	IF Match( l_cSelect, "~"PBSELECT" ) THEN
		//PBSELECT
		//Find the last where if it exists
		l_nWherePos = Pos( l_cSelect, "WHERE" )
		IF l_nWherePos > 0 THEN
			DO WHILE l_nWherePos > 0
				l_nLastWherePos = l_nWherePos
				l_nWherePos = Pos( l_cSelect, "WHERE", ( l_nWherePos + 1 ) )
			LOOP
			
			//Find the close paren after the last where
			l_nParenPos = Pos( l_cSelect, ")", l_nLastWherePos )
			
			//Replace the close paren with logic and the added where clause(s)
			l_cPBWhereList = " LOGIC=~~~"AND~~~" ) ~r~n"+l_cPBWhereList
			l_cSelect = Replace( l_cSelect, l_nParenPos, 1, l_cPBWhereList )
		ELSE
			//No other where.  Look for last join
			l_nJoinPos = Pos( l_cSelect, "JOIN" )
			IF l_nJoinPos > 0 THEN
				DO WHILE l_nJoinPos > 0
					l_nLastJoinPos = l_nJoinPos
					l_nJoinPos = Pos( l_cSelect, "JOIN", ( l_nJoinPos + 1 ) )
				LOOP
				
				//Find the close paren after the last join
				l_nParenPos = Pos( l_cSelect, ")", l_nLastJoinPos )
				
				//Replace the close paren with logic and the added where clause(s)
				l_cPBWhereList = ") ~r~n"+l_cPBWhereList
				l_cSelect = Replace( l_cSelect, l_nParenPos, 1, l_cPBWhereList )
			ELSE
				//No joins. Look for last column
				l_nColPos = Pos( l_cSelect, "COLUMN" )
				IF l_nColPos > 0 THEN
					DO WHILE l_nColPos > 0
						l_nLastColPos = l_nColPos
						l_nColPos = Pos( l_cSelect, "COLUMN", ( l_nColPos + 1 ) )
					LOOP
					
					//Find the close paren after the last column
					l_nParenPos = Pos( l_cSelect, ")", l_nLastColPos )
					
					//Replace the close paren with logic and the added where conditions(s)
					l_cPBWhereList = ") ~r~n"+l_cPBWhereList
					l_cSelect = Replace( l_cSelect, l_nParenPos, 1, l_cPBWhereList )
				END IF
			END IF
		END IF
		
		//Finally, replace the prior pbselect with the new one
		i_cNewDWSyntax = Replace( i_cNewDWSyntax, l_nStartPos, l_nSelectLen, l_cSelect )
	ELSE
		//SELECT
		//Loop through and accomodate for multiples if using unions
		l_nSelectPos = Pos( Upper( l_cSelect ), "SELECT" )
		DO WHILE l_nSelectPos > 0
			l_nWherePos = Pos( Upper( l_cSelect ), "WHERE", l_nSelectPos )
			
			//Check if there is an "ORDER BY" or "GROUP BY"
			IF Pos( Upper( l_cSelect ), "ORDER BY", l_nSelectPos ) > 0 THEN
				l_nNextSecPos = Pos( Upper( l_cSelect ), "ORDER BY", l_nSelectPos )
			ELSEIF Pos( Upper( l_cSelect ), "GROUP BY", l_nSelectPos ) > 0 THEN
				l_nNextSecPos = Pos( Upper( l_cSelect ), "GROUP BY", l_nSelectPos )
			ELSEIF Pos( Upper( l_cSelect ), "SELECT", ( l_nSelectPos + 1 ) ) > 0 THEN
				l_nNextSecPos = Pos( Upper( l_cSelect ), "SELECT", ( l_nSelectPos + 1 ) )
			ELSE
				l_nNextSecPos = Pos( l_cSelect, "~"", l_nSelectPos )
				//If the character before the quote isn't a space, need to put
				//  one there.
				IF Mid( l_cSelect, ( l_nNextSecPos - 1 ), 1 ) <> " " THEN
					l_cSelect = Replace( l_cSelect, l_nNextSecPos, 1, " ~"" )
					l_nNextSecPos ++
				END IF
			END IF
			
			IF l_nWherePos > 0 THEN 
				l_cSQLWhereList = " AND ~r~n"+l_cSQLWhereList
			END IF
			
			//Replace the character before the next section position with the 
			//  addition where clause
			l_cSelect = Replace( l_cSelect, ( l_nNextSecPos - 1 ), 1, l_cSQLWhereList )
			
			//Next select
			l_nSelectPos = Pos( Upper( l_cSelect ), "SELECT", ( l_nSelectPos + 1 ) )
		LOOP
		
		//Finally, replace the prior select with the new one
		i_cNewDWSyntax = Replace( i_cNewDWSyntax, l_nStartPos, l_nSelectLen, l_cSelect )
	END IF
END IF
end event

type st_2 from statictext within w_dw_search
integer x = 18
integer y = 456
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Criteria:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_dw_search
integer x = 18
integer y = 220
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Column:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_ok from u_cb_ok within w_dw_search
integer x = 1161
integer y = 984
integer width = 320
integer height = 90
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean default = true
end type

event clicked;/****************************************************************************************
	Event:	clicked
	Purpose: Please see PB documentation for this event
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	11/6/2000 K. Claver    Added code to trigger the event to build the where clause, add
								  it to the datawindow syntax and return the syntax.
****************************************************************************************/
dw_Criteria.Event Trigger ue_BuildWhere( )

CloseWithReturn( PARENT, i_cNewDWSyntax )
end event

type cb_cancel from u_cb_cancel within w_dw_search
integer x = 1518
integer y = 984
integer width = 320
integer height = 90
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;/****************************************************************************************
	Event:	close
	Purpose: Please see PB documentation for this event
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	11/6/2000 K. Claver    Close the window and return the original syntax without changes
****************************************************************************************/
CloseWithReturn( PARENT, i_cOriginalDWSyntax )
end event

type st_3 from statictext within w_dw_search
integer y = 936
integer width = 2231
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217747
alignment alignment = right!
boolean focusrectangle = false
end type

type ln_1 from line within w_dw_search
long linecolor = 8421504
integer linethickness = 4
integer beginy = 184
integer endx = 2469
integer endy = 184
end type

type ln_2 from line within w_dw_search
long linecolor = 16777215
integer linethickness = 4
integer beginy = 188
integer endx = 2469
integer endy = 188
end type

type ln_3 from line within w_dw_search
long linecolor = 8421504
integer linethickness = 4
integer beginy = 928
integer endx = 2469
integer endy = 928
end type

type ln_4 from line within w_dw_search
long linecolor = 16777215
integer linethickness = 4
integer beginy = 932
integer endx = 2469
integer endy = 932
end type

