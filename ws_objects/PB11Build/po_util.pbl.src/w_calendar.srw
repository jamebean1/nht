$PBExportHeader$w_calendar.srw
forward
global type w_calendar from w_response_std
end type
type dw_calendar from u_calendar within w_calendar
end type
end forward

global type w_calendar from w_response_std
integer width = 1019
integer height = 748
boolean titlebar = false
string title = ""
boolean controlmenu = false
dw_calendar dw_calendar
end type
global w_calendar w_calendar

type variables
Integer i_nDay, i_nMonth, i_nYear
end variables

on w_calendar.create
int iCurrent
call super::create
this.dw_calendar=create dw_calendar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_calendar
end on

on w_calendar.destroy
call super::destroy
destroy(this.dw_calendar)
end on

event open;/****************************************************************************************
			Event:	open
		 Purpose:	Please see PB documentation for this event
		 
		 	 Note:  	The parameter passed to the window in the Message Object consists of the
			  			date and the X and Y positions to move the window to, seperated by
						ampersands.
			  
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/5/2000 K. Claver    Create calendar and set the current date or the date passed 
								  into the calendar
**************************************************************************************/
String l_cDate, l_cParm, l_cX, l_cY
Date l_dDate[ ]

//Initialize the calendar object
dw_calendar.fu_CalCreate()

l_cParm = Message.StringParm

//Seperate out the parms
l_cDate = Mid( l_cParm, 1, ( Pos( l_cParm, "&" ) - 1 ) )
l_cParm = Mid( l_cParm, ( Pos( l_cParm, "&" ) + 1 ) )
l_cX = Mid( l_cParm, 1, ( Pos( l_cParm, "&" ) - 1 ) )
l_cY = Mid( l_cParm, ( Pos( l_cParm, "&" ) + 1 ) )

//If no date passed, set to today
IF Trim( l_cDate ) = "" THEN
	l_dDate[ 1 ] = Today( )
ELSE
	l_dDate[ 1 ] = Date( l_cDate )
END IF

//Get the month, day and year
i_nDay = Day( l_dDate[ 1 ] )
i_nMonth = Month( l_dDate[ 1 ] )
i_nYear = Year( l_dDate[ 1 ] )

//Set the date in the calendar
dw_calendar.fu_CalSetDates( l_dDate )
dw_calendar.fu_CalSetMonth( i_nMonth )
dw_calendar.fu_CalSetYear( i_nYear )

//Position the window.
THIS.Move( Integer( l_cX ), Integer( l_cY ) )

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite	10.7.2004	SCR 35	Check to ensure that the calendar is not going to open
//											off the screen. If it is, then move its horizontal position
//-----------------------------------------------------------------------------------------------------------------------------------

If long(l_cX) + this.width > PixelsToUnits(workspacewidth(), XPixelsToUnits!) Then
	this.x = PixelsToUnits(workspacewidth(), XPixelsToUnits!) - this.width - 100
End If
end event

event key;call super::key;/****************************************************************************************
			Event:	key
		 Purpose:	Please see PB documentation for this event
		 
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	03/02/01 M. Caruso     Close the window if the user presses the escape key.
**************************************************************************************/

CHOOSE CASE Key
	CASE KeyEscape!
		Post CloseWithReturn (THIS, '')
		
END CHOOSE
end event

type dw_calendar from u_calendar within w_calendar
integer taborder = 10
end type

event po_daychanged;call super::po_daychanged;/****************************************************************************************
			Event:	po_daychanged
		 Purpose:	Fired every time user clicks on a different day
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/5/2000 K. Claver    Added code to populate an instance variable with the new day
**************************************************************************************/
PARENT.i_nDay = SelectedDay
end event

event po_monthchanged;call super::po_monthchanged;/****************************************************************************************
			Event:	po_monthchanged
		 Purpose:	Fired every time user clicks on a different month
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/5/2000 K. Claver    Added code to populate an instance variable with the new month
**************************************************************************************/
PARENT.i_nMonth = SelectedMonth
end event

event po_yearchanged;call super::po_yearchanged;/****************************************************************************************
			Event:	po_yearchanged
		 Purpose:	Fired every time user clicks on a different year
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/5/2000 K. Claver    Added code to populate an instance variable with the new year
**************************************************************************************/
PARENT.i_nYear = SelectedYear
end event

event clicked;call super::clicked;/****************************************************************************************
			Event:	clicked
		 Purpose:	Please see PB documentation for this event
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/5/2000 K. Claver    Close the window and pass back the selected date
**************************************************************************************/
String l_cNull

SetNull( l_cNull )

IF Mid( dwo.Name, 1, 3 ) = "day" AND i_nDay <> 0 THEN
	IF KeyDown( KeyControl! ) THEN
		CloseWithReturn( PARENT, l_cNull )
	ELSE
		CloseWithReturn( PARENT, ( String( THIS.fu_CalGetMonth( ) )+"/"+String( i_nDay )+"/"+String( THIS.fu_CalGetYear( ) ) ) )
	END IF
END IF
end event

