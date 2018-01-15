$PBExportHeader$u_iim_tab_page.sru
$PBExportComments$Tab Page object for use in the IIM.
forward
global type u_iim_tab_page from u_container_std
end type
type dw_initial_view from u_dw_std within u_iim_tab_page
end type
type dw_summary_view from u_dw_std within u_iim_tab_page
end type
type st_nodataprompt from statictext within u_iim_tab_page
end type
type st_searchprompt from statictext within u_iim_tab_page
end type
end forward

global type u_iim_tab_page from u_container_std
integer width = 3525
integer height = 372
boolean border = false
long backcolor = 79748288
event ue_wiredrag ( boolean a_bwiredrag )
event ue_postresize ( )
dw_initial_view dw_initial_view
dw_summary_view dw_summary_view
st_nodataprompt st_nodataprompt
st_searchprompt st_searchprompt
end type
global u_iim_tab_page u_iim_tab_page

type variables
U_IIM		i_uParentIIM			// reference to the IIM of the parent object.
u_tab_std		i_tabParent				// reference to the tab folder this page is part of.
BOOLEAN	i_bLoaded				// TRUE = The datawindow on this page has already been loaded.
BOOLEAN	i_bPreLoad				// TRUE = Load data when tab first selected.
BOOLEAN	i_bManualClose			// TRUE = Run the full container close process without closing the window.
BOOLEAN	i_bBlank					// TRUE = Place holder because no tabs were defined.
BOOLEAN  i_bAlreadyBuilt      // TRUE = The tab has already been built.
BOOLEAN  i_bRefresh = FALSE   // TRUE = Refresh the tab.  Replace the sql select instead of rebuilding the
										//        datawindow.
INTEGER	i_nTrArrayIndex		// The Transaction Object array index for this page.
STRING   i_cConvertToDate     // String containing the fields and their formats to
										//   be converted to datetime values.
STRING 	i_cSummarySyntax     // String containing the summary syntax by tab object
STRING   i_cSummarySQLSelect  // String containing the summmary sql select by tab object

STRING	i_cColor					// Initial background color of the datawindow
end variables

forward prototypes
public function datetime uf_datefromformat (string a_cformatteddate, string a_cformat)
end prototypes

event ue_wiredrag;/****************************************************************************************

	Event:	ue_WireDrag
	Purpose:	Wire or Unwire the drag-drop to the case details case notes datawindow.
	
	Parameters: a_bWireDrag - Boolean - Create or remove the drag drop
	
	Revisions:
	Date      Developer     Description
	========  ============= ==============================================================
	3/15/2001 K. Claver     Created
****************************************************************************************/
String l_cCols[ ]

IF a_bWireDrag THEN
	dw_summary_view.fu_ChangeOptions( dw_summary_view.c_DragOK )
	
	IF dw_summary_view.i_AllowDrag THEN
		IF IsValid( w_create_maintain_case ) THEN
			IF IsValid( w_create_maintain_case.i_uoCaseDetails ) THEN
				dw_summary_view.fu_WireDrag( l_cCols[ ], dw_summary_view.c_CopyRows, w_create_maintain_case.i_uoCaseDetails.dw_case_note_entry )
				
				IF IsValid (dw_summary_view.i_DWSRV_EDIT) THEN	
					dw_summary_view.i_DWSRV_EDIT.fu_SetDragIndicator( "sortdrag.ico", "sortdrag.ico", "editcorrespondence.ico" )
				END IF
			END IF
		END IF
	END IF
ELSE
	dw_summary_view.fu_ChangeOptions( dw_summary_view.c_NoDrag )
END IF
end event

event ue_postresize;/****************************************************************************************

	Event:	ue_PostResize
	Purpose:	Correctly size the datawindow after tile of the window itself.
	
	Revisions:
	Date      Developer     Description
	========  ============= ==============================================================
	4/12/2001 K. Claver     Created
****************************************************************************************/
dw_summary_view.Resize( ( THIS.Width - 15 ), ( THIS.Height - 13 ) )

end event

public function datetime uf_datefromformat (string a_cformatteddate, string a_cformat);//////////////////////////////////////////////////////////////////////////////
//
//	Function:      uf_DateFromFormat
//
//	Access:  		public
//
//	Arguments:
//	a_cFormattedDate  String variable containing the passed date(and possibly time)
//							to be converted to an actual date-time format
//							(yyyy-mm-dd hh:mm:ss.fff).
// a_cFormat	   	String containing the format to extract the date from.
//
//	Returns:  		The converted datetime value if successful.
//						Null datetime if error, open date or null passed in
//						
//
//	Description:  	Extract the date according to the passed format.
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
String l_cFormat, l_cCentury, l_cYear, l_cDay, l_cMonth, l_cChar, l_cLastChar = ""
String l_cDate = "", l_cTime, l_cValidChars = "CYMDHMSFI-:._/\ "
String l_cHour = "00", l_cMinute = "00", l_cSecond = "00", l_cMSecond = "000" 
Date l_dDate
Time l_tTime
Integer l_nIndex, l_nMonthPos
DateTime l_dtNull

SetNull( l_dtNull )

//Trim off any white space
a_cFormattedDate = Trim( a_cFormattedDate )

//First, check if the return value is zero, empty or null
IF a_cFormattedDate = "" OR a_cFormattedDate = "0" OR &
   IsNull( a_cFormattedDate ) THEN
	RETURN l_dtNull
END IF

//CSC Specific fix.  Need to accomodate for dates in the 1800s.
IF Upper( a_cFormat ) = "CYYMMDD" AND Len( a_cFormattedDate ) = 6 THEN
	a_cFormattedDate = "0"+a_cFormattedDate
END IF

l_cFormat = Upper( a_cFormat )

//Second do a length check
IF Len( a_cFormattedDate ) <> Len( a_cFormat ) THEN
	//Bad Format
	RETURN l_dtNull
END IF

//Century
IF Pos( l_cFormat, "CC" ) > 0 THEN
	l_cCentury = Mid( a_cFormattedDate, Pos( l_cFormat, "CC" ), 2 )
ELSEIF Pos( l_cFormat, "C" ) > 0 THEN
	l_cCentury = Mid( a_cFormattedDate, Pos( l_cFormat, "C" ), 1 )
END IF

//Year
IF Pos( l_cFormat, "YYYY" ) > 0 THEN
	l_cYear = Mid( a_cFormattedDate, Pos( l_cFormat, "YYYY" ), 4 )
ELSEIF Pos( l_cFormat, "YY" ) > 0 THEN
	l_cYear = Mid( a_cFormattedDate, Pos( l_cFormat, "YY" ), 2 )
END IF

//Month
l_nMonthPos = Pos( l_cFormat, "MM" )
IF l_nMonthPos > 0 THEN
	l_cMonth = Mid( a_cFormattedDate, Pos( l_cFormat, "MM" ), 2 )
END IF

//Day
IF Pos( l_cFormat, "DD" ) > 0 THEN
	l_cDay = Mid( a_cFormattedDate, Pos( l_cFormat, "DD" ), 2 )
END IF

//Hour
IF Pos( l_cFormat, "HH" ) > 0 THEN
	l_cHour = Mid( a_cFormattedDate, Pos( l_cFormat, "HH" ), 2 )
END IF

//Minute
IF Pos( l_cFormat, "MI" ) > 0 THEN
	l_cMinute = Mid( a_cFormattedDate, Pos( l_cFormat, "MI" ), 2 )
END IF

//Second
IF Pos( l_cFormat, "SS" ) > 0 THEN
	l_cSecond = Mid( a_cFormattedDate, Pos( l_cFormat, "SS" ), 2 )
END IF
	
//MilliSecond
IF Pos( l_cFormat, "FFF" ) > 0 THEN
	l_cMSecond = Mid( a_cFormattedDate, Pos( l_cFormat, "FFF" ), 3 )
END IF

//Make the date string
IF Len( l_cYear ) = 4 THEN
	l_cDate += l_cYear+"-"
ELSEIF Len( l_cYear ) = 2 THEN
	IF Len( l_cCentury ) = 1 AND ( l_cCentury = "0" OR l_cCentury = "1" OR l_cCentury = "2" ) THEN
		IF l_cCentury = "0" THEN
			l_cDate += "18"+l_cYear+"-"
		ELSEIF l_cCentury = "1" THEN
			l_cDate += "19"+l_cYear+"-"
		ELSEIF l_cCentury = "2" THEN
			l_cDate += "20"+l_cYear+"-"
		END IF
	ELSEIF Len( l_cCentury ) = 2 AND ( l_cCentury = "18" OR l_cCentury = "19" OR l_cCentury = "20" )  THEN
		l_cDate += l_cCentury+l_cYear+"-"
	ELSEIF l_cCentury = "00" OR l_cCentury = "0" OR l_cCentury = "99" OR l_cCentury = "9" THEN
		//Open Date
		RETURN l_dtNull
	END IF
END IF

//Add Month and Day
l_cDate += l_cMonth+"-"+l_cDay

//Check for valid date
IF NOT IsDate( l_cDate ) THEN
	RETURN l_dtNull
ELSE
	l_dDate = Date( l_cDate )
END IF

//Add on hours, minutes, seconds, milliseconds.
IF IsNumber( l_cHour ) THEN
	l_cTime += l_cHour+":"
END IF

IF IsNumber( l_cMinute ) THEN
	l_cTime += l_cMinute+":"
END IF

IF IsNumber( l_cSecond ) THEN
	l_cTime += l_cSecond+"."
END IF

IF IsNumber( l_cMSecond ) THEN
	l_cTime += l_cMSecond
END IF

//Check for valid date
IF NOT IsTime( l_cTime ) THEN
	l_cTime = "00:00:00.000"
ELSE
	l_tTime = Time( l_cTime )
END IF

RETURN DateTime( l_dDate, l_tTime )

end function

on u_iim_tab_page.create
int iCurrent
call super::create
this.dw_initial_view=create dw_initial_view
this.dw_summary_view=create dw_summary_view
this.st_nodataprompt=create st_nodataprompt
this.st_searchprompt=create st_searchprompt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_initial_view
this.Control[iCurrent+2]=this.dw_summary_view
this.Control[iCurrent+3]=this.st_nodataprompt
this.Control[iCurrent+4]=this.st_searchprompt
end on

on u_iim_tab_page.destroy
call super::destroy
destroy(this.dw_initial_view)
destroy(this.dw_summary_view)
destroy(this.st_nodataprompt)
destroy(this.st_searchprompt)
end on

event destructor;call super::destructor;/*****************************************************************************************
   Event:      destructor
   Purpose:    Allow for the deletion of these pages without closing the window.

   Revisions:
   Date     Developer    Description
	======== ============ =================================================================
	3/3/00   M. Caruso    Created.
*****************************************************************************************/

IF i_bManualClose THEN
	
	i_uParentIIM.i_wParentWindow.fw_CloseContainer (THIS)
	
END IF
end event

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    see PB documentation for this event

   Revisions:
   Date     Developer    Description
	======== ============ =================================================================
	9/26/2000 K. Claver   Added the function call to initialize the resize service and 
								 register the datawindows with the service.
*****************************************************************************************/
//Initialize the resize service
THIS.of_SetResize( TRUE )

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( dw_initial_view, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( dw_summary_view, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF
end event

event resize;call super::resize;/****************************************************************************************

	Event:	Resize
	Purpose:	Please see PB documentation for this event.
	
	Revisions:
	Date      Developer     Description
	========  ============= ==============================================================
	4/12/2001 K. Claver     Added call to the post resize event as the resize service
									doesn't correctly accomodate for tiling then maximizing the
									windows.
****************************************************************************************/
THIS.Event Post ue_postresize( )
end event

type dw_initial_view from u_dw_std within u_iim_tab_page
integer x = 9
integer y = 8
integer width = 3493
integer height = 352
integer taborder = 10
string dataobject = ""
end type

type dw_summary_view from u_dw_std within u_iim_tab_page
event ue_selecttrigger pbm_dwnkey
event ue_loadsummarydw ( long a_nfirstrow,  long a_nnumrows )
integer x = 5
integer y = 8
integer width = 3511
integer height = 360
integer taborder = 10
string dragicon = "SortDrag.ico"
boolean bringtotop = true
string dataobject = ""
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Open the Detail view by triggering the doubleclicked event when the user
			   presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	5/8/00   M. Caruso     Created, based on the doubleclicked event script.
	8/16/2000 K. Claver    Removed describe for summary syntax column and replaced with 
								  instance variable containing the summary syntax
****************************************************************************************/

INTEGER				l_nTabNum
LONG					l_nRow		
DOUBLE				l_dblRtn
STRING				l_cLabel
BOOLEAN				l_bEnabled, l_bVisible
S_DETAIL_PARMS		l_sParms

l_nRow = GetRow()
IF (key = KeyEnter!) AND (l_nRow > 0) THEN
	// if the case is not closed, or if the user has supervisor rights allow editing.
	IF IsValid( i_uParentIIM.i_wParentWindow ) THEN
		l_nTabNum = i_tabparent.SelectedTab
		l_sParms.uo_iim = i_uParentIIM
		i_uParentIIM.uf_GetIIMSyntax( l_nTabNum )
		l_sParms.c_dwsyntax = i_uParentIIM.i_cDetailSyntax
		l_sParms.TrArrayIndex = i_nTrArrayIndex
		
		// only open the detail view if a detail view is defined.
		IF NOT (IsNull (l_sParms.c_dwsyntax)) AND (l_sParms.c_dwsyntax <> "") THEN
			FWCA.MGR.fu_OpenWindow (w_inquiry_details, l_sParms)
		END IF
		
		// If the user selected OK, record the viewed record in the Case Remarks field.
		l_dblRtn = Message.DoubleParm
		IF l_dblRtn = 1 AND i_uParentIIM.i_wParentWindow.dw_folder.i_SelectedTab = 5 THEN
			
			//User may have created a new case or the case details user object hadn't been instantiated
			//  when the IIM window was opened.  Set now.
			IF NOT IsValid( i_uParentIIM.i_uParentContainer ) AND IsValid( i_uParentIIM.i_wParentWindow.i_uoCaseDetails ) THEN
				i_uParentIIM.i_uParentContainer = i_uParentIIM.i_wParentWindow.i_uoCaseDetails
			END IF
			
			IF IsValid( i_uParentIIM.i_uParentContainer ) THEN
				i_uParentIIM.i_uParentContainer.fu_AddCustomerStmt (THIS)
			END IF
			
			Message.DoubleParm = 0			
		END IF
		
		SetPointer( Arrow! )
	END IF
	
	RETURN 1
END IF
end event

event ue_loadsummarydw;/****************************************************************************************

	Event:	ue_LoadSummaryDW
	Purpose:	Load the summary datawindow with the fields that needed to be converted to 
				dates and the other fields
	
	Revisions:
	Date      Developer     Description
	========  ============= ==============================================================
	8/11/2000 K. Claver     Created
****************************************************************************************/
Integer l_nColNum, l_nColCount, l_nColPos, l_nSepPos, l_nNextSepPos, l_nInsertRow
Long l_nRow, l_nData, l_nRV, l_nSetRV
String l_cColType, l_cDescribe, l_cRV, l_cFormat, l_cData, l_cModify, l_cErrorData
String l_cErrorCol
DateTime l_dtData
Date l_dData

l_nColCount = Integer( dw_Initial_View.Object.Datawindow.Column.Count )

FOR l_nRow = a_nFirstRow TO a_nNumRows
	l_nInsertRow = THIS.InsertRow( 0 )
	
	IF l_nInsertRow = -1 THEN
		MessageBox( gs_AppName, "Error inserting row "+String( l_nRow )+" into view datawindow", StopSign!, OK! )
		EXIT
	ELSEIF l_nInsertRow <> l_nRow THEN
		MessageBox( gs_AppName, "Row inserted does not match row counter.~r~nInserted Row: "+String( l_nInsertRow )+ &
						"~r~nRow Counter: "+String( l_nRow ), StopSign!, OK! )
		EXIT
	END IF
	
	FOR l_nColNum = 1 TO l_nColCount
		//Check to see if this is a column to convert
		l_cDescribe = "#"+String( l_nColNum )+".dbName"
		l_cRV = Upper( dw_Initial_View.Describe( l_cDescribe ) )
		//Add a "^" on the end for an exact match
		l_cRV += "^"
		l_nColPos = Pos( PARENT.i_cConvertToDate, l_cRV )
		
		//Check the column type before extracting the data
		l_cDescribe = "#"+String( l_nColNum )+".ColType"
		l_cRV = Upper( dw_Initial_View.Describe( l_cDescribe ) )
		IF Pos( l_cRV, "DECIMAL" ) > 0 THEN
			l_nData = dw_Initial_View.GetItemDecimal( l_nRow, l_nColNum )
			IF l_nColPos > 0 THEN
				l_cData = String( l_nData )
			ELSE
				l_nSetRV = THIS.SetItem( l_nRow, l_nColNum, l_nData )
				
				IF l_nSetRV = -1 THEN
					l_cErrorData = String( l_nData )
					l_cErrorCol = THIS.Describe( "#"+String( l_nColNum )+".Name" )
				END IF
			END IF
		ELSEIF l_cRV = "INT" OR l_cRV = "LONG" OR &
				 l_cRV = "NUMBER" OR l_cRV = "REAL" OR &
				 l_cRV = "ULONG" THEN
			l_nData = dw_Initial_View.GetItemNumber( l_nRow, l_nColNum )
			IF l_nColPos > 0 THEN
				l_cData = String( l_nData )
			ELSE
				l_nSetRV = THIS.SetItem( l_nRow, l_nColNum, l_nData )
				
				IF l_nSetRV = -1 THEN
					l_cErrorData = String( l_nData )
					l_cErrorCol = THIS.Describe( "#"+String( l_nColNum )+".Name" )
				END IF
			END IF
		ELSEIF Pos( l_cRV, "CHAR" ) > 0 THEN
			l_cData = dw_Initial_View.GetItemString( l_nRow, l_nColNum )
			IF l_nColPos <= 0 THEN
				l_nSetRV = THIS.SetItem( l_nRow, l_nColNum, l_cData )
				
				IF l_nSetRV = -1 THEN
					l_cErrorData = l_cData
					l_cErrorCol = THIS.Describe( "#"+String( l_nColNum )+".Name" )
				END IF
			END IF
		ELSEIF Pos( l_cRV, "DATETIME" ) > 0 THEN
			l_dtData = dw_Initial_View.GetItemDateTime( l_nRow, l_nColNum )
			IF l_nColPos <= 0 THEN
				l_nSetRV = THIS.SetItem( l_nRow, l_nColNum, l_dtData )
				
				IF l_nSetRV = -1 THEN
					l_cErrorData = String( l_dtData )
					l_cErrorCol = THIS.Describe( "#"+String( l_nColNum )+".Name" )
				END IF
			END IF
		ELSEIF Pos( l_cRV, "DATE" ) > 0 THEN
			l_dData = dw_Initial_View.GetItemDate( l_nRow, l_nColNum )
			IF l_nColPos <= 0 THEN
				l_nSetRV = THIS.SetItem( l_nRow, l_nColNum, l_dData )
				
				IF l_nSetRV = -1 THEN
					l_cErrorData = String( l_dData )
					l_cErrorCol = THIS.Describe( "#"+String( l_nColNum )+".Name" )
				END IF
			END IF
		END IF
		
	   //Error
		IF l_nSetRV = -1 THEN
			MessageBox( gs_AppName, "Error inserting data into view.~r~nError Data: "+l_cErrorData+"~r~n"+ &
							"Error Column: "+l_cErrorCol+"~r~nError Row: "+String( l_nRow ) )
			
			l_nSetRV = 1
			CONTINUE
		END IF
		
		IF l_nColPos > 0 THEN
			//Get the format, convert and add to the summary datawindow
			l_nSepPos = Pos( PARENT.i_cConvertToDate, "^", l_nColPos )
			l_nNextSepPos = Pos( PARENT.i_cConvertToDate, "^", ( l_nSepPos + 1 ) )
			IF l_nNextSepPos <= 0 THEN
				l_nNextSepPos = Len( PARENT.i_cConvertToDate ) + 1
			END IF
			
			l_cFormat = Mid( PARENT.i_cConvertToDate, ( l_nSepPos + 1 ), &
			            ( ( l_nNextSepPos - l_nSepPos ) - 1 ) )
			              
			l_dtData = PARENT.uf_DateFromFormat( l_cData, l_cFormat )
			l_nRV = THIS.SetItem( l_nRow, l_nColNum, l_dtData )
			
			IF l_nRV = -1 THEN
				l_cErrorCol = THIS.Describe( "#"+String( l_nColNum )+".Name" )
				
				MessageBox( gs_AppName, "Error inserting formatted data into view.~r~nData Before Formatting: "+ &
								l_cData+"~r~nData After Formatting: "+String( l_dtData )+"~r~n"+ &
								"Format: "+l_cFormat+"~r~nError Column: "+l_cErrorCol+"~r~nError Row: "+ &
								String( l_nRow ) )
				
				l_nRV = 1
				CONTINUE
			END IF
			
			//Set the alignment for the new datetime columns to left
			IF l_nRow = 1 THEN
				l_cModify = "#"+String( l_nColNum )+".Alignment='0'"
				THIS.Modify( l_cModify )
			END IF				
		END IF
	NEXT
	THIS.SetItemStatus( l_nRow, 0, Primary!, NotModified! )
NEXT
	
end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
   Event:      doubleclicked
   Purpose:    Open the detail view window based on the selected row
   Parameters: INTEGER	xpos - The distance of the pointer from the left side of the
										DataWindow's workspace. The distance is given in pixels.
					INTEGER	ypos - The distance of the pointer from the top of the
										DataWindow's workspace. The distance is given in pixels.
					LONG		row - The number of the row the user double-clicked. If the user
										didn't double-click on a row, the value of the row argument
										is 0. For example, row is 0 when the user double-clicks
										outside the data area, in text or spaces between rows, or
										in the header, summary, or footer area.
					DWOBJECT	dwo - A reference to the object within the DataWindow the user
										double-clicked.
   Returns:    LONG		0 -	Continue processing.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/08/00 M. Caruso    Created.
	03/02/00 M. Caruso    Modified to only work on open cases ot if the user has
								 Supervisor rights in the application.
	08/16/00 K. Claver    Removed describe for summary syntax column and replaced with 
								 instance variable containing the summary syntax
	01/31/03 M. Caruso	 Added code to pass the parent window tab number to the detail
								 window and notify the user as to the success or failure of
								 creating a case note.
*****************************************************************************************/

INTEGER						l_nTabNum
DOUBLE						l_dblRtn
STRING						l_cLabel
BOOLEAN						l_bEnabled, l_bVisible
WINDOWOBJECT				l_woObjects[]
S_DETAIL_PARMS				l_sParms

// if the case is not closed, or if the user has supervisor rights allow editing.
IF IsValid( i_uParentIIM.i_wParentWindow ) THEN
	// process if a row was selected.
	IF row > 0 OR Upper( dwo.Type ) = "GRAPH" THEN
		l_nTabNum = i_tabparent.SelectedTab
		l_sParms.uo_iim = i_uParentIIM
		i_uParentIIM.uf_GetIIMSyntax( l_nTabNum )
		l_sParms.c_dwsyntax = i_uParentIIM.i_cDetailSyntax
		l_sParms.TrArrayIndex = i_nTrArrayIndex
		l_sParms.l_nPrntWinTabNum = i_uParentIIM.i_wParentWindow.dw_folder.i_SelectedTab
		
		// only open the detail view if a detail view is defined.
		IF NOT (IsNull (l_sParms.c_dwsyntax)) AND (l_sParms.c_dwsyntax <> "") THEN
			FWCA.MGR.fu_OpenWindow (w_inquiry_details, l_sParms)
		END IF
		
		// If the user selected OK, record the viewed record in the Case Remarks field.
		l_dblRtn = Message.DoubleParm
		IF l_dblRtn = 1 AND i_uParentIIM.i_wParentWindow.dw_folder.i_SelectedTab = 5 THEN
			
			//User may have created a new case or the case details user object hadn't been instantiated
			//  when the IIM window was opened.  Set now.
			IF NOT IsValid( i_uParentIIM.i_uParentContainer ) AND IsValid( i_uParentIIM.i_wParentWindow.i_uoCaseDetails ) THEN
				i_uParentIIM.i_uParentContainer = i_uParentIIM.i_wParentWindow.i_uoCaseDetails
			END IF
			
			IF IsValid( i_uParentIIM.i_uParentContainer ) THEN
				IF i_uParentIIM.i_uParentContainer.fu_AddCustomerStmt (THIS) < 1 THEN
					MessageBox( gs_AppName, "Unable to add the case note to the note field" )
				ELSE
					MessageBox( gs_AppName, "Case Note successfully added" )
				END IF
			END IF
			
			Message.DoubleParm = 0
			
		END IF
		
		SetPointer( Arrow! )
		
	END IF
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve the data for this datawindow
   Parameters: DATAWINDOW Parent_DW - Parent of this DataWindow.  If this DataWindow is
													root-level, this value will be NULL.
               LONG       Num_Selected - The number of selected records in the parent
													DataWindow.
               LONG       Selected_Rows[] - The row numbers of the selected records in the
													parent DataWindow.

	Returns:		Error.i_FWError -
                     c_Success - the event completed succesfully.
                     c_Fatal   - the event encountered an error.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/9/00   M. Caruso    Created.
	
	4/25/00  M. Caruso    Removed code to initialize the demographics screen because
								 this functionality has been moved to u_case_detail_inquiry.
								 
	6/12/00  M. Caruso    Added code to hide the Search prompt when a retrieval is done.
	                      Also enable the "no data" prompt as necessary.  Also, set
								 i_bLoaded to TRUE if uf_loaddata is called.
	8/10/2000 K. Claver	 Added code to switch to the initial view datawindow for retrieval
								 if the summary view is set as an external datawindow for 
								 convert to date processing
	11/14/2000 K. Claver  Changed the initial population of the summary datawindow from 10
								 to 20 for iim datawindows that have date conversion and retrieve
								 as needed set up.  Needed to add more initial rows to accomodate
								 for the tabs being put on a seperate window at 800x600.
	5/31/2001 K. Claver   Enhanced for use of InfoMaker in IIM.
*****************************************************************************************/

STRING				l_cTabLabel, l_cStringParms[], l_cSQLSelect
BOOLEAN				l_bEnabled, l_bVisible
INTEGER				l_nDWHeight, l_nDataSpace, l_nRows
INTEGER				l_nRV, l_nHeaderHeight, l_nDetailHeight, l_nFooterHeight, l_nSummaryHeight
WINDOWOBJECT		l_woObjects[]
U_DEMOGRAPHICS		l_uContainer
U_DW_STD				l_dwSource1, l_dwSource2

//Always make sure the Initial View datawindow is the same height
//  as the Summary View datawindow for retrieve as needed on the
//  Initial View Datawindow
dw_Initial_View.Height = THIS.Height

// only process this if the current page is not intentionaly blank.
IF NOT i_bblank THEN

	// get reference to the demographics screen for argument data
	IF IsValid( i_uparentiim.i_wParentWindow ) THEN
		i_uparentiim.i_wParentWindow.dw_folder.fu_TabInfo (2, l_cTabLabel, l_bEnabled, l_bVisible, l_woObjects[])
	END IF
	
	IF upperbound (l_woObjects[]) > 0 THEN
		
		l_uContainer = l_woObjects[1]
		l_dwSource1 = l_uContainer.dw_demographics
		SetNull (l_dwSource2)
		
		st_searchprompt.visible = FALSE
		
		// ensure that the datawindow is still assigned a valid transaction object
		l_cSQLSelect = GetSQLSelect ()
		IF Match( l_cSQLSelect, "PBSELECT" ) OR Match( Upper( l_cSQLSelect ), "SELECT" ) OR &
		   ( Pos( Upper( PARENT.i_cSummarySyntax ), "EXECUTE " + i_uParentIIM.is_schema_owner ) > 0 AND &
			( IsNull( PARENT.i_cConvertToDate) OR Trim( PARENT.i_cConvertToDate ) = "" ) ) THEN
			IF Match (l_cSQLSelect, "PBSELECT") THEN
				IF UpperBound( i_uParentIIM.i_trObjects ) > 0 AND i_ntrarrayindex > 0 THEN
					SetTransObject (i_uParentIIM.i_trObjects[i_ntrarrayindex])
				ELSE
					SetTransObject( SQLCA )
				END IF
			END IF
			
			l_nRV = i_uparentiim.uf_LoadData (THIS, l_dwSource1, l_dwSource2, i_ntrarrayindex, PARENT.i_bRefresh, &
														 PARENT.i_cSummarySyntax, PARENT.i_cSummarySQLSelect)
		ELSE
			//Get the sql select from the initial view datawindow and set the transaction object
			l_cSQLSelect = dw_Initial_View.GetSQLSelect( )
			IF Match (l_cSQLSelect, "PBSELECT") THEN
				IF UpperBound( i_uParentIIM.i_trObjects ) > 0 AND i_ntrarrayindex > 0 THEN
					dw_Initial_View.SetTransObject (i_uParentIIM.i_trObjects[i_ntrarrayindex])
				ELSE
					dw_Initial_View.SetTransObject( SQLCA )
				END IF
			END IF
			
			i_uparentiim.i_cConvertToDate = PARENT.i_cConvertToDate
			
			l_nRV = i_uparentiim.uf_LoadData (dw_initial_view, l_dwSource1, l_dwSource2, i_ntrarrayindex, PARENT.i_bRefresh, &
														 PARENT.i_cSummarySyntax, PARENT.i_cSummarySQLSelect)			
		END IF
		
		CHOOSE CASE l_nRV
			CASE IS < 0
				IF RowCount () = 0 THEN
					MessageBox (gs_AppName, "The system was unable to retrieve records from the database.")
					Modify ("datawindow.Color='80269524'")
					st_nodataprompt.visible = TRUE
					m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
				ELSE
					st_nodataprompt.visible = FALSE
					
					IF w_create_maintain_case.dw_folder.i_SelectedTab = 5 THEN
						m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = TRUE
					END IF
				END IF
								
			CASE 0
				Modify ("datawindow.Color='80269524'")
				st_nodataprompt.visible = TRUE
				m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			CASE IS > 0
				Modify ("datawindow.Color='"+PARENT.i_cColor+"'")
				st_nodataprompt.visible = FALSE
				st_searchprompt.visible = FALSE
				
				IF w_create_maintain_case.dw_folder.i_SelectedTab = 5 THEN
					m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = TRUE
				END IF
				
				IF Trim( PARENT.i_cConvertToDate ) <> "" THEN
					//Load the first 20 rows from the initial view datawindow into the
					//  summary view datawindow if the datawindow is set to retrieve
					//  as needed.  Otherwise, load all.
					IF dw_Initial_View.RowCount( ) > 0 THEN
						//Load all rows
						THIS.Event Trigger ue_LoadSummaryDW( 1, dw_Initial_View.RowCount( ) )
					END IF
				END IF
				
		END CHOOSE
		
		//Call the sort and groupcalc functions in case there is a sort order
		//  or groups defined.
		THIS.Sort( )
		THIS.GroupCalc( )
		
		i_bLoaded = TRUE
		
	END IF
	
END IF
end event

event getfocus;call super::getfocus;/*****************************************************************************************
   Event:      getfocus
   Purpose:    enable the Sort menu item when the datawindow loses focus

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	6/13/00  M. Caruso    Created.
*****************************************************************************************/
IF IsValid( w_create_maintain_case ) THEN
	m_create_maintain_case.m_edit.m_sort.enabled = TRUE
END IF
end event

event losefocus;call super::losefocus;/*****************************************************************************************
   Event:      losefocus
   Purpose:    disable the Sort menu item when the datawindow loses focus

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	6/13/00  M. Caruso    Created.
*****************************************************************************************/
IF IsValid( w_create_maintain_case ) THEN
	m_create_maintain_case.m_edit.m_sort.enabled = FALSE
END IF
end event

event scrollvertical;call super::scrollvertical;/****************************************************************************************

	Event:	ScrollVertical
	Purpose:	See PB Documentation for this event
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/9/2000 K. Claver     Added code to keep the initial view datawindow in sync with
								  the summary view datawindow for the retrieve as needed
								  functionality.
****************************************************************************************/
//Synchronize the two datawindows if there is data in the initial view
IF dw_Initial_View.RowCount( ) > 0 THEN
	dw_Initial_View.Object.DataWindow.VerticalScrollPosition = scrollpos
	IF dw_Initial_View.Object.Datawindow.Retrieve.AsNeeded = "yes" THEN
		dw_Initial_View.ScrollToRow( ( dw_Initial_View.RowCount( ) + 1 ) )
		THIS.Event Trigger ue_LoadSummaryDW( ( THIS.RowCount( ) + 1 ), dw_Initial_View.RowCount( ) )
	END IF
END IF
end event

event resize;call super::resize;/****************************************************************************************

	Event:	Resize
	Purpose:	See PB Documentation for this event
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/9/2000 K. Claver     Added code to ensure the initial view datawindow stays hidden
								  behind the summary view datawindow if the summary view datawindow
								  is resized.
	11/14/2000 K. Claver   Added code to syncronize the datawindows if date conversion is
								  set up along with retrieve as needed while resizing the window
	10/1/2001 K. Claver    Added code to check if the summary has caught up with the initial
								  load before allowing to load more.  Happens generally on the initial
								  load.
	5/22/2002 K. Claver    Changed to use describe for the Retrieve as needed property to
								  avoid a null object ref.
****************************************************************************************/
Integer l_nInitialNext, l_nSummaryNext

//Always ensure the initial view datawindow is hidden behind the
//  summary view datawindow
dw_Initial_View.Resize( newwidth, newheight )

//Simulate the retrieve as needed while resize
IF PARENT.i_cConvertToDate <> "" THEN
	IF Upper( dw_Initial_View.Describe( "Datawindow.Retrieve.AsNeeded" ) ) = "YES" THEN
		l_nSummaryNext = ( THIS.RowCount( ) + 1 )
		l_nInitialNext = ( dw_Initial_View.RowCount( ) + 1 )
		IF l_nSummaryNext = l_nInitialNext THEN
			dw_Initial_View.ScrollToRow( l_nInitialNext )
			THIS.Event Trigger ue_LoadSummaryDW( l_nSummaryNext, dw_Initial_View.RowCount( ) )
		END IF
	END IF
END IF
end event

type st_nodataprompt from statictext within u_iim_tab_page
boolean visible = false
integer x = 1317
integer y = 164
integer width = 1019
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 80269524
string text = "No data is available."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_searchprompt from statictext within u_iim_tab_page
boolean visible = false
integer x = 1179
integer y = 164
integer width = 1294
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 80269524
string text = "Click the Search button to retrieve data."
alignment alignment = center!
boolean focusrectangle = false
end type

