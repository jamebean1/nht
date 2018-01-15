$PBExportHeader$u_dd_calendar.sru
$PBExportComments$Drop-down Calendar class
forward
global type u_dd_calendar from dropdownlistbox
end type
end forward

global type u_dd_calendar from dropdownlistbox
int Width=1001
int Height=88
int TabOrder=1
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean AllowEdit=true
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event po_ddopen pbm_cbndropdown
event po_ddfocus pbm_custom75
event po_ddprocess pbm_custom74
event po_identify pbm_custom73
end type
global u_dd_calendar u_dd_calendar

type variables
//----------------------------------------------------------------------------------------
//  Drop-down Calendar Constants
//----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName	= "DDCalendar"

//----------------------------------------------------------------------------------------
// Drop-down Calendar Instance Variables
//----------------------------------------------------------------------------------------

U_CALENDAR		i_Calendar

INTEGER		i_DDIndex
INTEGER		i_ObjectIndex
DATE			i_CurrentDate
INTEGER		i_SaveY

BOOLEAN		i_DDClosed
BOOLEAN		i_DDSaveIndex

end variables

forward prototypes
public function string fu_getidentity ()
end prototypes

event po_ddopen;//******************************************************************
//  PO Module     : u_DD_Calendar
//  Event         : po_DDOpen
//  Description   : Opens the calendar and displays it using the
//                  drop-down objects attributes for color and fonts.  
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Get the drop-down list box part to hide by setting focus off
//  this object (to the calendar) and then back to this object.
//------------------------------------------------------------------

i_DDSaveIndex = TRUE
THIS.PostEvent("po_DDFocus")

//------------------------------------------------------------------
//  Once the list box is gone, process the calendar action.
//------------------------------------------------------------------

THIS.PostEvent("po_DDProcess")
end event

event po_ddfocus;//******************************************************************
//  PO Module     : u_DD_Calendar
//  Event         : po_DDFocus
//  Description   : Posted event to set focus to the calendar object
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_Calendar.SetFocus()

end event

event po_ddprocess;//******************************************************************
//  PO Module     : u_DD_Calendar
//  Event         : po_DDProcess
//  Description   : Opens the calendar and displays it using the
//                  drop-down objects attributes for color and fonts.  
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_DDD
INTEGER l_Y, l_ParentHeight

SetPointer(HourGlass!)

IF i_Calendar.i_CalendarDDIndex = i_DDIndex AND i_DDClosed THEN
   i_DDClosed = FALSE
   RETURN
ELSE
   i_DDClosed = FALSE
END IF

//------------------------------------------------------------------
//  Determine if the calendar needs to be moved from another
//  location to this object.
//------------------------------------------------------------------

IF i_Calendar.i_ParentObject = "WINDOW" THEN
   l_ParentHeight = i_Calendar.i_Window.WorkSpaceHeight()
ELSE
   l_ParentHeight = i_Calendar.i_UserObject.Height
END IF

IF i_Calendar.X <> X OR i_Calendar.Y <> i_SaveY OR &
   i_Calendar.i_ParentHeight <> l_ParentHeight THEN
   i_Calendar.i_ParentHeight = l_ParentHeight

   IF Y + Height + i_Calendar.i_DDCalHeight[i_DDIndex] - 6 < &
      l_ParentHeight THEN
      l_Y = Y + Height - 6
   ELSEIF Y - i_Calendar.i_DDCalHeight[i_DDIndex] - 6 > 1 THEN
      l_Y = Y - i_Calendar.i_DDCalHeight[i_DDIndex] - 5
   ELSE
      l_Y = Y + Height - 6
   END IF

   i_SaveY = l_Y
	i_Calendar.Move(X, l_Y)

   //---------------------------------------------------------------
   //  Set the attributes for the calendar based on the drop-down
   //  objects attributes.
   //---------------------------------------------------------------

   i_Calendar.SetRedraw(FALSE)
   IF NOT i_Calendar.i_CalStyleSet THEN
      IF BorderStyle = StyleLowered! OR BorderStyle = StyleRaised! THEN
         l_DDD = TRUE
         i_Calendar.SetItem(1, "cal_sty", "3D")
      ELSE
         l_DDD = FALSE
         i_Calendar.SetItem(1, "cal_sty", "2D")
      END IF
   ELSE
      IF BorderStyle = StyleLowered! OR BorderStyle = StyleRaised! THEN
         l_DDD = TRUE
      ELSE
         l_DDD = FALSE
      END IF
   END IF

   IF l_DDD AND BackColor = OBJCA.MGR.c_White THEN
      i_Calendar.SetItem(1, "wd_bg_c", OBJCA.MGR.c_Gray)
      i_Calendar.SetItem(1, "we_bg_c", OBJCA.MGR.c_Gray)
   ELSE
      IF NOT i_Calendar.i_WDBGColorSet THEN
         i_Calendar.SetItem(1, "wd_bg_c", BackColor)
      END IF
      IF NOT i_Calendar.i_WEBGColorSet THEN
         i_Calendar.SetItem(1, "we_bg_c", BackColor)
      END IF
   END IF

   IF NOT i_Calendar.i_WDColorSet THEN
      i_Calendar.SetItem(1, "wd_c", TextColor)
   END IF
   IF NOT i_Calendar.i_WEColorSet THEN
      i_Calendar.SetItem(1, "we_c", TextColor)
   END IF
   IF NOT i_Calendar.i_HeadColorSet THEN
      i_Calendar.SetItem(1, "h_c", TextColor)
   END IF
   IF NOT i_Calendar.i_MonthColorSet THEN
      i_Calendar.SetItem(1, "m_c", TextColor)
   END IF
   IF NOT i_Calendar.i_YearColorSet THEN
      i_Calendar.SetItem(1, "y_c", TextColor)
   END IF

   IF NOT i_Calendar.i_WDSizeSet THEN
      i_Calendar.SetItem(1, "d_size", TextSize * -1)
   END IF
   IF NOT i_Calendar.i_SelSizeSet THEN
      i_Calendar.SetItem(1, "s_size", TextSize * -1)
   END IF
   IF NOT i_Calendar.i_DisSizeSet THEN
      i_Calendar.SetItem(1, "b_size", TextSize * -1)
   END IF
   IF NOT i_Calendar.i_HeadSizeSet THEN
      i_Calendar.SetItem(1, "h_size", TextSize * -1)
      i_Calendar.i_HeadingSize = TextSize * -1
   END IF
   IF NOT i_Calendar.i_MonthSizeSet THEN
      i_Calendar.SetItem(1, "m_size", TextSize * -1)
      i_Calendar.i_MonthSize = TextSize * -1
   END IF
   IF NOT i_Calendar.i_YearSizeSet THEN
      i_Calendar.SetItem(1, "y_size", TextSize * -1)
   END IF

   IF NOT i_Calendar.i_WDFontSet THEN
      i_Calendar.SetItem(1, "d_font", FaceName)
      i_Calendar.SetItem(1, "d_f", FontFamily)
      i_Calendar.SetItem(1, "d_p", FontPitch)
      i_Calendar.SetItem(1, "d_cs", FontCharSet)
   END IF
   IF NOT i_Calendar.i_SelFontSet THEN
      i_Calendar.SetItem(1, "s_font", FaceName)
      i_Calendar.SetItem(1, "s_f", FontFamily)
      i_Calendar.SetItem(1, "s_p", FontPitch)
      i_Calendar.SetItem(1, "s_cs", FontCharSet)
   END IF
   IF NOT i_Calendar.i_DisFontSet THEN
      i_Calendar.SetItem(1, "b_font", FaceName)
      i_Calendar.SetItem(1, "b_f", FontFamily)
      i_Calendar.SetItem(1, "b_p", FontPitch)
      i_Calendar.SetItem(1, "b_cs", FontCharSet)
   END IF
   IF NOT i_Calendar.i_HeadFontSet THEN
      i_Calendar.SetItem(1, "h_font", FaceName)
      i_Calendar.SetItem(1, "h_f", FontFamily)
      i_Calendar.SetItem(1, "h_p", FontPitch)
      i_Calendar.SetItem(1, "h_cs", FontCharSet)
   END IF
   IF NOT i_Calendar.i_MonthFontSet THEN
      i_Calendar.SetItem(1, "m_font", FaceName)
      i_Calendar.SetItem(1, "m_f", FontFamily)
      i_Calendar.SetItem(1, "m_p", FontPitch)
      i_Calendar.SetItem(1, "m_cs", FontCharSet)
   END IF
   IF NOT i_Calendar.i_YearFontSet THEN
      i_Calendar.SetItem(1, "y_font", FaceName)
      i_Calendar.SetItem(1, "y_f", FontFamily)
      i_Calendar.SetItem(1, "y_p", FontPitch)
      i_Calendar.SetItem(1, "y_cs", FontCharSet)
   END IF

   IF i_Calendar.i_DDWidth[i_DDIndex] <> i_Calendar.Width THEN
      i_Calendar.Resize(i_Calendar.i_DDCalWidth[i_DDIndex], &
                        i_Calendar.i_DDCalHeight[i_DDIndex])
   END IF

END IF

//------------------------------------------------------------------
//  Set the calendar date to the date, if any, in this object.
//------------------------------------------------------------------

IF AllowEdit THEN
   IF IsDate(Text) THEN
      i_CurrentDate = Date(Text)
      i_Calendar.fu_CalSetMonth(Month(i_CurrentDate), Year(i_CurrentDate))
      i_Calendar.fu_CalSetDay(i_CurrentDate, "RESET")
   ELSE
      i_Calendar.fu_CalClearDates()
      i_Calendar.fu_CalSetMonth(Month(Today()), Year(Today()))
      SetNull(i_CurrentDate)
   END IF
ELSE
   IF Text <> "" THEN
      i_Calendar.fu_CalSetMonth(Month(i_CurrentDate), Year(i_CurrentDate))
      i_Calendar.fu_CalSetDay(i_CurrentDate, "RESET")
   ELSE
      i_Calendar.fu_CalClearDates()
      i_Calendar.fu_CalSetMonth(Month(Today()), Year(Today()))
      SetNull(i_CurrentDate)
   END IF
END IF

i_Calendar.SetRedraw(TRUE)
i_Calendar.Visible = TRUE
i_Calendar.TabOrder= TabOrder - 1
BringToTop         = TRUE
i_Calendar.SetFocus()

end event

event po_identify;//******************************************************************
//  PO Module     : u_DD_Calendar
//  Event         : po_Identify
//  Description   : Identifies this object as belonging to a 
//                  ServerLogic product.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

end event

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_DD_Calendar
//  Subroutine    : fu_GetIdentity
//  Description   : Returns the identity of this object.
//
//  Parameters    : (None)
//
//  Return Value  : STRING -
//                     Identity of this object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

RETURN c_ObjectName
end function

event getfocus;//******************************************************************
//  PO Module     : u_DD_Calendar
//  Event         : GetFocus
//  Description   : Sets this object as the current drop-down 
//                  calendar.  
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_Calendar.i_CalendarDDType = "OBJECT"
IF i_Calendar.i_CalendarDDIndex <> i_DDIndex THEN
   IF i_Calendar.i_CalendarDDIndex > 0 THEN
      i_Calendar.i_DDObject[i_Calendar.i_DDIndex[i_Calendar.i_CalendarDDIndex]].i_DDClosed = FALSE
   END IF
END IF
IF NOT i_DDSaveIndex THEN
   i_Calendar.i_CalendarDDIndex = i_DDIndex
ELSE
   i_DDSaveIndex = FALSE
END IF
i_Calendar.i_CalendarDDColumn = ""
end event

