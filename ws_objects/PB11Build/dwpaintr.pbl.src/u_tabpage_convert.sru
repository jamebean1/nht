$PBExportHeader$u_tabpage_convert.sru
forward
global type u_tabpage_convert from u_tabpg_std
end type
type dw_convert_fields from datawindow within u_tabpage_convert
end type
end forward

global type u_tabpage_convert from u_tabpg_std
integer width = 3118
integer height = 436
string text = "Convert To Date"
dw_convert_fields dw_convert_fields
end type
global u_tabpage_convert u_tabpage_convert

forward prototypes
public function string fu_checkformat (string a_cformat)
public function string fu_getconvert ()
end prototypes

public function string fu_checkformat (string a_cformat);//////////////////////////////////////////////////////////////////////////////
//
//	Function:      fu_CheckFormat
//
//	Access:  		public
//
//	Arguments:
// a_cFormat	  	String containing the format to check.
//
//	Returns:  		"" for ok format
//						l_cError for format error
//
//	Description:  	Check the passed format for validity.
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
String l_cFormat, l_cValidChars = "CYMDHMSFI-:._/\ ", l_cError = "ERROR"
Integer l_nIndex

l_cFormat = Upper( a_cFormat )

//Third check for valid characters
FOR l_nIndex = 1 TO Len( l_cFormat )
	IF Pos( l_cValidChars, Mid( l_cFormat, l_nIndex, 1 ) ) > 0 THEN
		CONTINUE
	ELSE
		//Bad format character
		RETURN l_cError
	END IF
NEXT

//Century
IF Pos( l_cFormat, "CCC" ) > 0 THEN
	//Bad century format
	RETURN l_cError
END IF

//Year
IF Pos( l_cFormat, "YYY" ) > 0 OR &
   ( Pos( l_cFormat, "Y" ) > 0 AND &
	Mid( l_cFormat, ( Pos( l_cFormat, "Y" ) + 1 ), 1 ) <> "Y" ) THEN
	//Bad year format
	RETURN l_cError
END IF

//Month and Minute
IF Pos( l_cFormat, "MMM" ) > 0 OR & 
   ( Pos( l_cFormat, "M" ) > 0 AND Mid( l_cFormat, ( Pos( l_cFormat, "M" ) + 1 ), 1 ) <> "M" AND &
	Mid( l_cFormat, ( Pos( l_cFormat, "M" ) + 1 ), 1 ) <> "I" ) THEN
	//Bad month or minute format
	RETURN l_cError
END IF

//Day
IF Pos( l_cFormat, "DDD" ) > 0 OR &
   ( Pos( l_cFormat, "D" ) > 0 AND &
	Mid( l_cFormat, ( Pos( l_cFormat, "D" ) + 1 ), 1 ) <> "D" ) THEN
	//Bad day format
	RETURN l_cError
END IF

//Hour
IF Pos( l_cFormat, "HHH" ) > 0 OR &
   ( Pos( l_cFormat, "H" ) > 0 AND &
	Mid( l_cFormat, ( Pos( l_cFormat, "H" ) + 1 ), 1 ) <> "H" ) THEN
	//Bad hour format
	RETURN l_cError
END IF

//Second
IF Pos( l_cFormat, "SSS" ) > 0 OR &
   ( Pos( l_cFormat, "S" ) > 0 AND &
	Mid( l_cFormat, ( Pos( l_cFormat, "S" ) + 1 ), 1 ) <> "S" ) THEN
	//Bad second format
	RETURN l_cError
END IF
	
//MilliSecond
IF Pos( l_cFormat, "FFFF" ) > 0 OR & 
   ( Pos( l_cFormat, "F" ) > 0 AND & 
	Mid( l_cFormat, ( Pos( l_cFormat, "F" ) + 1 ), 2 ) <> "FF" ) THEN
	//Bad millisecond format
	RETURN l_cError
END IF

RETURN ""

end function

public function string fu_getconvert ();/*****************************************************************************************
   Function:   fu_GetConvert
   Purpose:    build the string that will contain the fields and their formats to be
					converted to dates
   Parameters: NONE
   Returns:    String - The fields and their formats in a string that begins with "##" and
					seperated by "^".

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/8/2000 K. Claver    Created.
*****************************************************************************************/
Integer l_nRows, l_nIndex
String l_cColumn, l_cFormat, l_cRV = "", l_cCheckFormat = "", l_cExcludeRows = ""

dw_convert_fields.AcceptText( )
l_nRows = dw_convert_fields.RowCount( )

IF l_nRows > 0 THEN
	FOR l_nIndex = 1 TO l_nRows
		IF l_nIndex = 1 THEN
			//Add the seperator characters
			l_cRV += "#CD#"
		END IF
		
		l_cColumn = Trim( dw_convert_fields.Object.left_arg[ l_nIndex ] )
		l_cFormat = Trim( dw_convert_fields.Object.format[ l_nIndex ] )
		
		//If no column or no format, continue to the next
		IF ( l_cColumn = "" OR IsNull( l_cColumn ) ) OR &
			( l_cFormat = "" OR IsNull( l_cFormat ) ) THEN
			l_cExcludeRows += String( l_nIndex )+", "
			CONTINUE
		END IF
		
		//Check for a format error
		l_cCheckFormat = fu_CheckFormat( l_cFormat )
		IF l_cCheckFormat <> "" THEN
			RETURN l_cCheckFormat
		END IF
		
		l_cRV += l_cColumn+"^"+l_cFormat+"^"
	NEXT
END IF

IF Trim( l_cExcludeRows ) <> "" THEN
	//Trim off the trailing comma
	l_cExcludeRows = Mid( l_cExcludeRows, 1, ( Len( l_cExcludeRows ) - 2 ) )
	
   MessageBox( gs_AppName, "Row(s) "+l_cExcludeRows+" on the Convert To Date tab~r~n"+ &
									"will be excluded as they are incomplete." )
END IF

IF l_cRV = "#CD#" THEN
	//If no columns and formats added, return empty string
	l_cRV = ""
ELSE
	//Trim off the trailing ^
	l_cRV = Mid( l_cRV, 1, ( Len( l_cRV ) - 1 ) )
END IF

RETURN l_cRV
end function

on u_tabpage_convert.create
int iCurrent
call super::create
this.dw_convert_fields=create dw_convert_fields
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_convert_fields
end on

on u_tabpage_convert.destroy
call super::destroy
destroy(this.dw_convert_fields)
end on

type dw_convert_fields from datawindow within u_tabpage_convert
event ue_buildfieldlist ( datawindow a_dwpreview )
event ue_restoredateconvert ( string a_cconvertdate )
integer x = 14
integer y = 12
integer width = 3086
integer height = 408
integer taborder = 10
string title = "none"
string dataobject = "d_convert_fields"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_buildfieldlist;/*****************************************************************************************
   Event:      ue_BuildFieldList
   Purpose:    Build a list of available fields from the datawindow
   Parameters: a_dwPreview - reference to the preview datawindow object
   Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver    Created.
*****************************************************************************************/
String l_cFieldList = "", l_cColumn
Integer l_nIndex

THIS.Reset( )

IF IsValid( a_dwPreview ) THEN
	FOR l_nIndex = 1 TO Integer( a_dwPreview.Object.Datawindow.Column.Count )
		l_cColumn = Upper( a_dwPreview.Describe( "#"+String( l_nIndex )+".dbName" ) )
		
		IF l_cFieldList <> "" THEN 
			l_cFieldList += "/"
		END IF
		
		l_cFieldList += ( l_cColumn+"~t"+l_cColumn )
	NEXT
END IF

IF Trim( l_cFieldList ) <> "" THEN
	dw_convert_fields.Object.left_arg.Values = l_cFieldList
END IF
end event

event ue_restoredateconvert;/*****************************************************************************************
   Event:      ue_RestoreDateConvert
   Purpose:    Restore the fields to be converted to dates on the datawindow on tabpage_convert 
   Parameters: None
   Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/7/2000 K. Claver    Created.
*****************************************************************************************/
String l_cConvertTemp, l_cColumnName, l_cFormat
Long l_nFirstPos, l_nSecondPos
Integer l_nRow

//Restore the convert to date fields
IF Trim( a_cConvertDate ) <> "" THEN
	l_cConvertTemp = Mid( a_cConvertDate, 5 )
	
	DO WHILE Trim( l_cConvertTemp ) <> "" 
		l_nFirstPos = Pos( l_cConvertTemp, "^" )
		l_cColumnName = Mid( l_cConvertTemp, 1, ( l_nFirstPos - 1 ) )
		l_nSecondPos = Pos( l_cConvertTemp, "^", ( l_nFirstPos + 1 ) )
		IF l_nSecondPos = 0 THEN
			l_cFormat = Mid( l_cConvertTemp, ( l_nFirstPos + 1 ) ) 
			l_cConvertTemp = ""
		ELSE
			l_cFormat = Mid( l_cConvertTemp, ( l_nFirstPos + 1 ), &
							( ( l_nSecondPos - l_nFirstPos ) - 1 ) )
			l_cConvertTemp = Mid( l_cConvertTemp, ( l_nSecondPos + 1 ) )
		END IF
		
		l_nRow = THIS.InsertRow( 0 )
		THIS.Object.left_arg[ l_nRow ] = Trim( l_cColumnName )
		THIS.Object.format[ l_nRow ] = Trim( l_cFormat )
	LOOP
END IF		
end event

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Select the row if not selected.  Deselect if selected.
*****************************************************************************************/
THIS.SelectRow( 0, FALSE )
THIS.SelectRow( row, ( NOT THIS.IsSelected( row ) ) ) 
end event

