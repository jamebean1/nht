$PBExportHeader$w_inquiry_details.srw
$PBExportComments$Detail view window for the IIM.
forward
global type w_inquiry_details from w_response_std
end type
type ln_2 from line within w_inquiry_details
end type
type p_1 from picture within w_inquiry_details
end type
type st_3 from statictext within w_inquiry_details
end type
type st_1 from statictext within w_inquiry_details
end type
type cb_print from commandbutton within w_inquiry_details
end type
type cb_ok from u_cb_close within w_inquiry_details
end type
type cb_cancel from u_cb_close within w_inquiry_details
end type
type dw_details from u_dw_std within w_inquiry_details
end type
type dw_initial_view from u_dw_std within w_inquiry_details
end type
type st_2 from statictext within w_inquiry_details
end type
type ln_1 from line within w_inquiry_details
end type
type ln_3 from line within w_inquiry_details
end type
type ln_4 from line within w_inquiry_details
end type
end forward

global type w_inquiry_details from w_response_std
integer width = 3625
integer height = 2580
string title = "Detail Information"
long backcolor = 79748288
event ue_copy ( )
ln_2 ln_2
p_1 p_1
st_3 st_3
st_1 st_1
cb_print cb_print
cb_ok cb_ok
cb_cancel cb_cancel
dw_details dw_details
dw_initial_view dw_initial_view
st_2 st_2
ln_1 ln_1
ln_3 ln_3
ln_4 ln_4
end type
global w_inquiry_details w_inquiry_details

type variables
STRING	i_cDWsyntax, i_cConvertToDate
DOUBLE	i_dblStatus
INTEGER	i_nTrArrayIndex
U_IIM		i_uParentIIM
MENU		i_mPopup
end variables

forward prototypes
public function datetime uf_datefromformat (string a_cformatteddate, string a_cformat)
end prototypes

event ue_copy;/*****************************************************************************************
   Event:      ue_copy
   Purpose:    Copy the selected portion of the details datawindow to the clipboard
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/20/2000 K. Claver  Original Version.
*****************************************************************************************/
dw_details.Copy( )
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

//First, check if the return value is zero, empty or null
IF Trim( a_cFormattedDate ) = "" OR Trim( a_cFormattedDate ) = "0" OR &
   IsNull( a_cFormattedDate ) THEN
	RETURN l_dtNull
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
	IF Len( l_cCentury ) = 1 AND ( l_cCentury = "1" OR l_cCentury = "2" ) THEN
		IF l_cCentury = "1" THEN
			l_cDate += "19"+l_cYear+"-"
		ELSEIF l_cCentury = "2" THEN
			l_cDate += "20"+l_cYear+"-"
		END IF
	ELSEIF Len( l_cCentury ) = 2 AND ( l_cCentury = "19" OR l_cCentury = "20" )  THEN
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

on w_inquiry_details.create
int iCurrent
call super::create
this.ln_2=create ln_2
this.p_1=create p_1
this.st_3=create st_3
this.st_1=create st_1
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_details=create dw_details
this.dw_initial_view=create dw_initial_view
this.st_2=create st_2
this.ln_1=create ln_1
this.ln_3=create ln_3
this.ln_4=create ln_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ln_2
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_print
this.Control[iCurrent+6]=this.cb_ok
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.dw_details
this.Control[iCurrent+9]=this.dw_initial_view
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.ln_1
this.Control[iCurrent+12]=this.ln_3
this.Control[iCurrent+13]=this.ln_4
end on

on w_inquiry_details.destroy
call super::destroy
destroy(this.ln_2)
destroy(this.p_1)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_details)
destroy(this.dw_initial_view)
destroy(this.st_2)
destroy(this.ln_1)
destroy(this.ln_3)
destroy(this.ln_4)
end on

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_setvariables
   Purpose:    Store the parameters passed to this window
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/17/00 M. Caruso    Created.
	08/15/00 K. Claver    Added code to parse off the convert to date syntax before create
								 datawindow.
	01/31/03 M. Caruso    Enable or Disable cb_ok based on the current tab in the IIM
								 parent window.
*****************************************************************************************/

S_DETAIL_PARMS	l_sParms

l_sParms = powerobject_parm

i_uParentIIM = l_sParms.uo_iim

IF Match( l_sParms.c_dwsyntax, "#CD#" ) THEN
	//Fields to convert to dates exist.  Parse them off the end before
	//  create the datawindow.
	i_cConvertToDate = Upper( Mid( l_sParms.c_dwsyntax, Pos( l_sParms.c_dwsyntax, "#CD#" ) ) )
	i_cDWSyntax = Mid( l_sParms.c_dwsyntax, 1, Pos( l_sParms.c_dwsyntax, "#CD#" ) - 1 )
ELSE
	i_cDWSyntax = l_sParms.c_dwsyntax
	//Set the Initial View Datawindow invisible if we're not going to use it
	dw_Initial_View.Visible = FALSE
END IF

i_nTrArrayIndex = l_sParms.TrArrayIndex

// Enable the button if the Case tab is selected in the IIM Parent Window.
IF l_sParms.l_nPrntWinTabNum = 5 THEN
	cb_ok.enabled = TRUE
ELSE
	cb_ok.enabled = FALSE
END IF
end event

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    Initialize the window and datawindow

   Revisions:
   Date     Developer    Description
	======== ============ =================================================================
	2/18/00  M. Caruso    Created.
	4/14/00  M. Caruso    Create the popup menu to be used for the datawindow.
*****************************************************************************************/
STRING l_cFirstPart, l_cSecondPart, l_cInitialDWSyntax, l_cField
INTEGER l_nDWCount = 1, l_nDWCounter, l_nTypePos, l_nFieldPos
u_DW_Std	l_dwCurrent

IF Trim( THIS.i_cConvertToDate ) <> "" AND NOT IsNull( THIS.i_cConvertToDate ) THEN
	//Store the initial syntax
	l_cInitialDWSyntax = i_cDWSyntax
	
	//Parse out the PBSELECT part to make the display datawindow
	//  external	
	IF Match( i_cDWSyntax, "retrieve=" ) THEN
		l_cFirstPart = Mid( i_cDWSyntax, 1, ( Pos( i_cDWSyntax, "retrieve=" ) - 1 ) )
		l_cSecondPart = Mid( i_cDWSyntax, ( Pos( i_cDWSyntax, "text(", Pos( i_cDWSyntax, "retrieve=" ) ) - 3 ) )
		i_cDWSyntax = l_cFirstPart+l_cSecondPart
	END IF
	
	//Change the appropriate fields to datetime for display
	l_nTypePos = Pos( i_cDWSyntax, "type=" )
	DO WHILE l_nTypePos > 0
		//Find the table and column name to check if is one to convert to a datetime
		l_nFieldPos = Pos( i_cDWSyntax, '"', l_nTypePos )
		l_cField = Upper( Mid( i_cDWSyntax, ( l_nFieldPos + 1 ), ( ( Pos( i_cDWSyntax, '"', ( l_nFieldPos + 1 ) ) - l_nFieldPos ) - 1 ) ) )
		
		//If find a match, convert to datetime field before create datawindow
		//Add "^" for exact pattern match
		l_cField += "^"
		IF Pos( THIS.i_cConvertToDate, l_cField ) > 0 THEN
			l_cFirstPart = Mid( i_cDWSyntax, 1, ( l_nTypePos + 4 ) )
			l_cSecondPart = Mid( i_cDWSyntax, Pos( i_cDWSyntax, " ", l_nTypePos ) )
			i_cDWSyntax = l_cFirstPart+"datetime"+l_cSecondPart
		END IF
		
		l_nTypePos = Pos( i_cDWSyntax, "type=", ( l_nTypePos + 1 ) )
	LOOP
	
	//Set the datawindow count to 2 as we're processing with two datawindows
	//  for convert to date processing
	l_nDWCount = 2
END IF

FOR l_nDWCounter = 1 TO l_nDWCount
	IF l_nDWCounter = 2 THEN
		//Switch the current datawindow to the background datawindow for 
		//  convert to date processing
		l_dwCurrent = dw_Initial_View
		i_cDWSyntax = l_cInitialDWSyntax
	ELSE
		l_dwCurrent = dw_details
	END IF
	
	CHOOSE CASE l_dwCurrent.Create (i_cDWSyntax)
		CASE 1
			dw_details.SetTransObject (SQLCA)
			
		CASE -1
			messagebox (gs_AppName,'The specified view syntax is invalid.  The data cannot be shown.')
		
	END CHOOSE
NEXT 

i_mPopup = CREATE USING "m_iim_detail_popup"

//of_SetResize (TRUE)
//IF IsValid (inv_resize) THEN
//	inv_resize.of_Register (dw_details, "ScaleToRight&Bottom")
//	inv_resize.of_Register (dw_initial_view, "ScaleToRight&Bottom")
//	inv_resize.of_Register (cb_ok, "FixedToRight&Bottom")
//	inv_resize.of_Register (cb_cancel, "FixedToRight&Bottom")
//	inv_resize.of_Register (cb_print, "FixedToBottom")
//	inv_resize.of_Register (ln_3, "FixedToBottom&ScaleToRight")
//	inv_resize.of_Register (ln_4, "FixedToBottom&ScaleToRight")
//	inv_resize.of_Register (st_2, "FixedToBottom&ScaleToRight")
//	inv_resize.of_Register (st_1, "ScaleToRight")
//	inv_resize.of_Register (ln_1, "ScaleToRight")
//	inv_resize.of_Register (ln_2, "ScaleToRight")
//END IF

end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_close
   Purpose:    Perform final processing to close the window

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/14/00  M. Caruso    Destory the menu that was created in i_mPopup
*****************************************************************************************/

IF IsValid (i_mPopup) THEN DESTROY i_mPopup

Message.DoubleParm = i_dblStatus
end event

type ln_2 from line within w_inquiry_details
long linecolor = 16777215
integer linethickness = 4
integer beginy = 188
integer endx = 3570
integer endy = 188
end type

type p_1 from picture within w_inquiry_details
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_3 from statictext within w_inquiry_details
integer x = 201
integer y = 60
integer width = 1499
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Inquiry Details"
boolean focusrectangle = false
end type

type st_1 from statictext within w_inquiry_details
integer width = 3598
integer height = 176
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_inquiry_details
integer x = 101
integer y = 2364
integer width = 411
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;//******************************************************************
//  Event         : Clicked
//  Description   : Please see PowerClass documentation for this event
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//	 4/24/2002 K. Claver Created
//******************************************************************

dw_details.TriggerEvent("pcd_Print")

end event

type cb_ok from u_cb_close within w_inquiry_details
integer x = 2395
integer y = 2364
integer width = 658
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Add Note And Return"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Set the return value for the window

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/24/00  M. Caruso    Created.
*****************************************************************************************/

// Set this to 1 to indicate that the OK button was pressed.
IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   
	i_dblStatus = 1
	Close (FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type cb_cancel from u_cb_close within w_inquiry_details
integer x = 3081
integer y = 2364
integer width = 411
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Return"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Set the return value for the window

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/24/00  M. Caruso    Created.
*****************************************************************************************/

// Set this to 0 to indicate that the Cancel button was pressed.
IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   
	i_dblStatus = 0
	Close (FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type dw_details from u_dw_std within w_inquiry_details
event ue_loaddetaildw ( long a_nfirstrow,  long a_nnumrows )
integer x = 23
integer y = 204
integer width = 3570
integer height = 2104
integer taborder = 10
boolean bringtotop = true
string dataobject = ""
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_loaddetaildw;/****************************************************************************************

	Event:	ue_LoadDetailDW
	Purpose:	Load the detail datawindow with the fields that needed to be converted to 
				dates and the other fields
	
	Revisions:
	Date      Developer     Description
	========  ============= ==============================================================
	8/11/2000 K. Claver     Created
****************************************************************************************/
Integer l_nColNum, l_nColCount, l_nColPos, l_nSepPos, l_nNextSepPos
Long l_nRow, l_nData
String l_cColType, l_cDescribe, l_cRV, l_cFormat, l_cData, l_cModify
DateTime l_dtData

l_nColCount = Integer( dw_Initial_View.Object.Datawindow.Column.Count )

FOR l_nRow = a_nFirstRow TO a_nNumRows
	THIS.InsertRow( 0 )
	FOR l_nColNum = 1 TO l_nColCount
		//Check to see if this is a column to convert
		l_cDescribe = "#"+String( l_nColNum )+".dbName"
		l_cRV = Upper( dw_Initial_View.Describe( l_cDescribe ) )
		//Add "^" to the end for exact pattern match
		l_cRV += "^"
		l_nColPos = Pos( Upper( PARENT.i_cConvertToDate ), l_cRV )
		
		//Check the column type before extracting the data
		l_cDescribe = "#"+String( l_nColNum )+".ColType"
		l_cRV = Upper( dw_Initial_View.Describe( l_cDescribe ) )
		IF Pos( l_cRV, "DECIMAL" ) > 0 THEN
			l_nData = dw_Initial_View.GetItemDecimal( l_nRow, l_nColNum )
			IF l_nColPos > 0 THEN
				l_cData = String( l_nData )
			ELSE
				THIS.SetItem( l_nRow, l_nColNum, l_nData )
			END IF
		ELSEIF l_cRV = "INT" OR l_cRV = "LONG" OR &
				 l_cRV = "NUMBER" OR l_cRV = "REAL" OR &
				 l_cRV = "ULONG" THEN
			l_nData = dw_Initial_View.GetItemNumber( l_nRow, l_nColNum )
			IF l_nColPos > 0 THEN
				l_cData = String( l_nData )
			ELSE
				THIS.SetItem( l_nRow, l_nColNum, l_nData )
			END IF
		ELSEIF Pos( l_cRV, "CHAR" ) > 0 THEN
			l_cData = dw_Initial_View.GetItemString( l_nRow, l_nColNum )
			IF l_nColPos <= 0 THEN
				THIS.SetItem( l_nRow, l_nColNum, l_cData )
			END IF
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
			THIS.SetItem( l_nRow, l_nColNum, l_dtData )
			
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

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    intialize the datawindow
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/17/00  M. Caruso    Created.
	4/14/00  M. Caruso    Set the popup menu for the datawindow
	12/20/2000 K. Claver  Added options to the datawindow so could enable copy and paste
								 functionality
*****************************************************************************************/

fu_SetOptions( SQLCA, &
					c_NullDW, &
					c_ModifyOK+ &
					c_CopyOK+ &
					c_ModifyOnOpen+ &
					c_ModifyOnSelect+ &
					c_HideHighlight+ &
					c_NoMenuButtonActivation )
					
fu_SetPopUp (i_mPopup.item[1])
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
	
	4/5/00   M. Caruso    Added code to allow access to information on the related Summary
								 View as a source for retrieval arguments.
								 
	5/10/00  M. Caruso    Automatically close the detail window if no records are
								 retrieved or if an error occurs.
	12/20/2000 K. Claver  Added code to set the fields to display only so can copy and paste
								 from the fields
*****************************************************************************************/

STRING				l_cTabLabel, l_cStringParms[], l_cMessage, l_cModify, l_cRV, l_cNull
BOOLEAN				l_bEnabled, l_bVisible, l_bContinue = FALSE, l_bClose
LONG					l_nRV
Integer				l_nColNum
TAB					l_tFolder
WINDOWOBJECT		l_woObjects[]
U_DEMOGRAPHICS		l_uDemographics
U_IIM_TAB_PAGE		l_uPage
U_DW_STD				l_dwSource1, l_dwSource2

SetNull( l_cNull )

// get reference to the demographics screen for argument data
IF IsValid( w_create_maintain_case ) THEN
	w_create_maintain_case.dw_folder.fu_TabInfo (2, l_cTabLabel, l_bEnabled, l_bVisible, l_woObjects[])
	IF upperbound (l_woObjects[]) > 0 THEN
		
		l_uDemographics = l_woObjects[1]
		l_dwSource1 = l_uDemographics.dw_demographics
		l_bContinue = TRUE
		
	END IF
	
	// get reference to the summary view for argument data
	IF IsValid( w_iim_tabs ) THEN
		
		l_tFolder = w_iim_tabs.tab_folder
		l_uPage = l_tFolder.control[l_tFolder.SelectedTab]
		l_dwSource2 = l_uPage.dw_summary_view
		l_bContinue = TRUE
		
	END IF
END IF

IF l_bContinue THEN

	// load the data
	IF Trim( PARENT.i_cConvertToDate ) <> "" AND NOT IsNull( PARENT.i_cConvertToDate ) THEN
		i_uparentiim.i_cConvertToDate = PARENT.i_cConvertToDate
		l_nRV = i_uparentiim.uf_LoadData (dw_Initial_View, l_dwSource1, l_dwSource2, i_ntrarrayindex, FALSE, l_cNull, l_cNull)
	ELSE
		l_nRV = i_uparentiim.uf_LoadData (THIS, l_dwSource1, l_dwSource2, i_ntrarrayindex, FALSE, l_cNull, l_cNull)
	END IF
	
	CHOOSE CASE l_nRV
		CASE 0
			l_cMessage = "There were no records found."
			l_bClose = TRUE
			
		CASE IS < 0
			l_cMessage = "The system was unable to retrieve records from the database."
			l_bClose = TRUE
			
		CASE ELSE
			l_bClose = FALSE
			
			FOR l_nColNum = 1 TO Integer( THIS.Object.Datawindow.Column.Count )
				l_cModify = "#"+String( l_nColNum )+".Protect='0' "+ &
								"#"+String( l_nColNum )+".Edit.DisplayOnly='Yes' "+ &
								"#"+String( l_nColNum )+".TabSequence='"+String( ( l_nColNum * 10 ) )+"'"
			
				l_cRV = THIS.Modify( l_cModify )
			NEXT
								
			//Load the detail datawindow with the converted data if the 
			//  conversion syntax exists
			IF PARENT.i_cConvertToDate <> "" AND NOT IsNull( PARENT.i_cConvertToDate ) THEN
				IF dw_Initial_View.RowCount( ) > 0 THEN
					//Load all rows
					THIS.Event Trigger ue_LoadDetailDW( 1, dw_Initial_View.RowCount( ) )
				END IF
			END IF
			
	END CHOOSE
	
	IF l_bClose THEN
		
		POST MessageBox (gs_AppName, l_cMessage)
		cb_cancel.PostEvent ('clicked')
		
	END IF
	
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
		THIS.Event Trigger ue_LoadDetailDW( ( THIS.RowCount( ) + 1 ), dw_Initial_View.RowCount( ) )
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
****************************************************************************************/
//Always ensure the initial view datawindow is hidden behind the
//  summary view datawindow
dw_Initial_View.Resize( newwidth, newheight )
end event

type dw_initial_view from u_dw_std within w_inquiry_details
integer x = 23
integer y = 204
integer width = 3570
integer height = 2104
integer taborder = 20
string dataobject = ""
end type

type st_2 from statictext within w_inquiry_details
integer y = 2316
integer width = 3598
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217747
boolean focusrectangle = false
end type

type ln_1 from line within w_inquiry_details
long linecolor = 8421504
integer linethickness = 4
integer beginy = 184
integer endx = 3570
integer endy = 184
end type

type ln_3 from line within w_inquiry_details
long linecolor = 8421504
integer linethickness = 4
integer beginy = 2308
integer endx = 3575
integer endy = 2308
end type

type ln_4 from line within w_inquiry_details
long linecolor = 16777215
integer linethickness = 4
integer beginy = 2312
integer endx = 3575
integer endy = 2312
end type

