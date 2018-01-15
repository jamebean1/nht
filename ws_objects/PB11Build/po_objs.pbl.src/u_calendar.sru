$PBExportHeader$u_calendar.sru
$PBExportComments$Calendar class
forward
global type u_calendar from datawindow
end type
end forward

global type u_calendar from datawindow
int Width=997
int Height=724
int TabOrder=1
string DataObject="d_calendar"
boolean Border=false
boolean LiveScroll=true
event po_daychanged ( integer selectedday )
event po_dayvalidate ( integer clickedday,  integer selectedday )
event po_monthchanged ( integer selectedmonth )
event po_monthvalidate ( integer clickedmonth,  integer selectedmonth )
event po_yearchanged ( integer selectedyear )
event po_yearvalidate ( integer clickedyear,  integer selectedyear )
event po_ddfocus pbm_custom69
event po_ddtabout pbm_dwntabout
event po_ddprocess pbm_custom68
event po_identify pbm_custom67
end type
global u_calendar u_calendar

type variables
//-----------------------------------------------------------------------------------------
//  Calendar Constants
//-----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName		= "Calendar"
CONSTANT INTEGER	c_DefaultHeight		= 0
CONSTANT STRING	c_DefaultVisual		= "000|"
CONSTANT STRING	c_DefaultFont		= ""
CONSTANT INTEGER	c_DefaultSize		= 0
CONSTANT INTEGER	c_DefaultDDWidth		= 0
CONSTANT INTEGER	c_DefaultDDHeight		= 0
CONSTANT STRING	c_DefaultDDFormat		= ""
CONSTANT INTEGER	c_ValOK			= 0
CONSTANT INTEGER	c_ValFailed		= -1

CONSTANT STRING 	c_CalGray		= "001|"
CONSTANT STRING 	c_CalBlack		= "002|"
CONSTANT STRING 	c_CalWhite		= "003|"
CONSTANT STRING	c_CalDarkGray		= "004|"
CONSTANT STRING 	c_CalRed			= "005|"
CONSTANT STRING 	c_CalDarkRed		= "006|"
CONSTANT STRING 	c_CalGreen		= "007|"
CONSTANT STRING 	c_CalDarkGreen		= "008|"
CONSTANT STRING 	c_CalBlue		= "009|"
CONSTANT STRING 	c_CalDarkBlue		= "010|"
CONSTANT STRING	c_CalMagenta		= "011|"
CONSTANT STRING	c_CalDarkMagenta		= "012|"
CONSTANT STRING	c_CalCyan		= "013|"
CONSTANT STRING	c_CalDarkCyan		= "014|"
CONSTANT STRING 	c_CalYellow		= "015|"
CONSTANT STRING	c_CalDarkYellow		= "016|"

CONSTANT STRING 	c_CalWEGray		= "017|"
CONSTANT STRING 	c_CalWEBlack		= "018|"
CONSTANT STRING	c_CalWEWhite		= "019|"
CONSTANT STRING 	c_CalWEDarkGray		= "020|"
CONSTANT STRING 	c_CalWERed		= "021|"
CONSTANT STRING 	c_CalWEDarkRed		= "022|"
CONSTANT STRING 	c_CalWEGreen		= "023|"
CONSTANT STRING	c_CalWEDarkGreen	= "024|"
CONSTANT STRING	c_CalWEBlue		= "025|"
CONSTANT STRING 	c_CalWEDarkBlue		= "026|"
CONSTANT STRING	c_CalWEMagenta		= "027|"
CONSTANT STRING	c_CalWEDarkMagenta	= "028|"
CONSTANT STRING 	c_CalWECyan		= "029|"
CONSTANT STRING 	c_CalWEDarkCyan		= "030|"
CONSTANT STRING 	c_CalWEYellow		= "031|"
CONSTANT STRING 	c_CalWEDarkYellow	= "032|"

CONSTANT STRING 	c_CalSortAsc		= "033|"
CONSTANT STRING 	c_CalSortDesc		= "034|"
CONSTANT STRING	c_CalNoSort		= "035|"

CONSTANT STRING 	c_CalStyle3D		= "036|"
CONSTANT STRING	c_CalStyle2D		= "037|"

CONSTANT STRING 	c_CalHeadingBlack		= "001|"
CONSTANT STRING 	c_CalHeadingWhite		= "002|"
CONSTANT STRING 	c_CalHeadingGray		= "003|"
CONSTANT STRING	c_CalHeadingDarkGray	= "004|"
CONSTANT STRING 	c_CalHeadingRed		= "005|"
CONSTANT STRING 	c_CalHeadingDarkRed	= "006|"
CONSTANT STRING 	c_CalHeadingGreen	= "007|"
CONSTANT STRING 	c_CalHeadingDarkGreen	= "008|"
CONSTANT STRING 	c_CalHeadingBlue		= "009|"
CONSTANT STRING 	c_CalHeadingDarkBlue	= "010|"
CONSTANT STRING 	c_CalHeadingMagenta	= "011|"
CONSTANT STRING 	c_CalHeadingDarkMagenta	= "012|"
CONSTANT STRING	c_CalHeadingCyan		= "013|"
CONSTANT STRING 	c_CalHeadingDarkCyan	= "014|"
CONSTANT STRING 	c_CalHeadingYellow	= "015|"
CONSTANT STRING	c_CalHeadingDarkYellow	= "016|"

CONSTANT STRING 	c_CalHeadingAuto		= "017|"
CONSTANT STRING 	c_CalHeading1		= "018|"
CONSTANT STRING 	c_CalHeading2		= "019|"
CONSTANT STRING 	c_CalHeading3		= "020|"
CONSTANT STRING	c_CalHeadingFull		= "021|"

CONSTANT STRING 	c_CalHeadingBold		= "022|"
CONSTANT STRING 	c_CalHeadingRegular	= "023|"
CONSTANT STRING 	c_CalHeadingItalic		= "024|"
CONSTANT STRING 	c_CalHeadingUnderline	= "025|"

CONSTANT STRING 	c_CalHeadingCenter	= "026|"
CONSTANT STRING	c_CalHeadingLeft		= "027|"
CONSTANT STRING 	c_CalHeadingRight		= "028|"

CONSTANT STRING 	c_CalDayBlack		= "001|"
CONSTANT STRING 	c_CalDayWhite		= "002|"
CONSTANT STRING 	c_CalDayGray		= "003|"
CONSTANT STRING 	c_CalDayDarkGray		= "004|"
CONSTANT STRING 	c_CalDayRed		= "005|"
CONSTANT STRING 	c_CalDayDarkRed		= "006|"
CONSTANT STRING 	c_CalDayGreen		= "007|" 
CONSTANT STRING 	c_CalDayDarkGreen	= "008|"
CONSTANT STRING 	c_CalDayBlue		= "009|"
CONSTANT STRING 	c_CalDayDarkBlue		= "010|"
CONSTANT STRING 	c_CalDayMagenta		= "011|"
CONSTANT STRING 	c_CalDayDarkMagenta	= "012|"
CONSTANT STRING 	c_CalDayCyan		= "013|"
CONSTANT STRING 	c_CalDayDarkCyan		= "014|"
CONSTANT STRING	c_CalDayYellow		= "015|"
CONSTANT STRING 	c_CalDayDarkYellow	= "016|"

CONSTANT STRING 	c_CalWEDayBlack		= "017|"
CONSTANT STRING 	c_CalWEDayWhite		= "018|"
CONSTANT STRING 	c_CalWEDayGray		= "019|"
CONSTANT STRING	c_CalWEDayDarkGray	= "020|"
CONSTANT STRING 	c_CalWEDayRed		= "021|"
CONSTANT STRING	c_CalWEDayDarkRed	= "022|"
CONSTANT STRING 	c_CalWEDayGreen		= "023|"
CONSTANT STRING 	c_CalWEDayDarkGreen	= "024|"
CONSTANT STRING 	c_CalWEDayBlue		= "025|"
CONSTANT STRING 	c_CalWEDayDarkBlue	= "026|"
CONSTANT STRING 	c_CalWEDayMagenta	= "027|"
CONSTANT STRING 	c_CalWEDayDarkMagenta	= "028|"
CONSTANT STRING 	c_CalWEDayCyan		= "029|"
CONSTANT STRING 	c_CalWEDayDarkCyan	= "030|"
CONSTANT STRING 	c_CalWEDayYellow		= "031|"
CONSTANT STRING 	c_CalWEDayDarkYellow	= "032|"

CONSTANT STRING 	c_CalDayRight		= "033|"
CONSTANT STRING 	c_CalDayLeft		= "034|"
CONSTANT STRING 	c_CalDayCenter		= "035|"

CONSTANT STRING 	c_CalDayRegular		= "036|"
CONSTANT STRING 	c_CalDayBold		= "037|"
CONSTANT STRING 	c_CalDayItalic		= "038|"
CONSTANT STRING 	c_CalDayUnderline		= "039|"

CONSTANT STRING 	c_CalWEDayRegular	= "040|"
CONSTANT STRING 	c_CalWEDayBold		= "041|"
CONSTANT STRING	c_CalWEDayItalic		= "042|"
CONSTANT STRING 	c_CalWEDayUnderline	= "043|"

CONSTANT STRING 	c_CalSelectWhite		= "001|"
CONSTANT STRING 	c_CalSelectBlack		= "002|"
CONSTANT STRING	c_CalSelectGray		= "003|"
CONSTANT STRING 	c_CalSelectDarkGray	= "004|"
CONSTANT STRING 	c_CalSelectRed		= "005|"
CONSTANT STRING	c_CalSelectDarkRed	= "006|"
CONSTANT STRING 	c_CalSelectGreen		= "007|"
CONSTANT STRING 	c_CalSelectDarkGreen	= "008|"
CONSTANT STRING 	c_CalSelectBlue		= "009|"
CONSTANT STRING 	c_CalSelectDarkBlue	= "010|"
CONSTANT STRING 	c_CalSelectMagenta	= "011|"
CONSTANT STRING	c_CalSelectDarkMagenta	= "012|"
CONSTANT STRING 	c_CalSelectCyan		= "013|"
CONSTANT STRING 	c_CalSelectDarkCyan	= "014|"
CONSTANT STRING	c_CalSelectYellow		= "015|"
CONSTANT STRING 	c_CalSelectDarkYellow	= "016|"

CONSTANT STRING 	c_CalSelectBGDarkGray	= "017|"
CONSTANT STRING 	c_CalSelectBGBlack	= "018|"
CONSTANT STRING 	c_CalSelectBGWhite	= "019|"
CONSTANT STRING 	c_CalSelectBGGray		= "020|"
CONSTANT STRING	c_CalSelectBGRed		= "021|"
CONSTANT STRING 	c_CalSelectBGDarkRed	= "022|"
CONSTANT STRING 	c_CalSelectBGGreen	= "023|"
CONSTANT STRING	c_CalSelectBGDarkGreen	= "024|"
CONSTANT STRING 	c_CalSelectBGBlue		= "025|"
CONSTANT STRING 	c_CalSelectBGDarkBlue	= "026|"
CONSTANT STRING 	c_CalSelectBGMagenta	= "027|"
CONSTANT STRING 	c_CalSelectBGDarkMagenta	= "028|"
CONSTANT STRING 	c_CalSelectBGCyan	= "029|"
CONSTANT STRING 	c_CalSelectBGDarkCyan	= "030|"
CONSTANT STRING 	c_CalSelectBGYellow	= "031|"
CONSTANT STRING 	c_CalSelectBGDarkYellow	= "032|"

CONSTANT STRING 	c_CalSelectRegular		= "033|"
CONSTANT STRING 	c_CalSelectBold		= "034|"
CONSTANT STRING 	c_CalSelectItalic		= "035|"
CONSTANT STRING 	c_CalSelectUnderline	= "036|"

CONSTANT STRING 	c_CalDisableDarkGray	= "001|"
CONSTANT STRING 	c_CalDisableWhite		= "002|"
CONSTANT STRING 	c_CalDisableBlack		= "003|"
CONSTANT STRING 	c_CalDisableGray		= "004|"
CONSTANT STRING 	c_CalDisableRed		= "005|"
CONSTANT STRING 	c_CalDisableDarkRed	= "006|"
CONSTANT STRING 	c_CalDisableGreen		= "007|"
CONSTANT STRING 	c_CalDisableDarkGreen	= "008|"
CONSTANT STRING	c_CalDisableBlue		= "009|"
CONSTANT STRING 	c_CalDisableDarkBlue	= "010|"
CONSTANT STRING 	c_CalDisableMagenta	= "011|"
CONSTANT STRING 	c_CalDisableDarkMagenta	= "012|"
CONSTANT STRING 	c_CalDisableCyan		= "013|"
CONSTANT STRING 	c_CalDisableDarkCyan	= "014|"
CONSTANT STRING 	c_CalDisableYellow		= "015|"
CONSTANT STRING 	c_CalDisableDarkYellow	= "016|"

CONSTANT STRING 	c_CalDisableBGGray	= "017|"
CONSTANT STRING 	c_CalDisableBGBlack	= "018|"
CONSTANT STRING 	c_CalDisableBGWhite	= "019|"
CONSTANT STRING 	c_CalDisableBGDarkGray	= "020|"
CONSTANT STRING 	c_CalDisableBGRed	= "021|"
CONSTANT STRING 	c_CalDisableBGDarkRed	= "022|"
CONSTANT STRING 	c_CalDisableBGGreen	= "023|"
CONSTANT STRING 	c_CalDisableBGDarkGreen	= "024|"
CONSTANT STRING 	c_CalDisableBGBlue	= "025|"
CONSTANT STRING 	c_CalDisableBGDarkBlue	= "026|"
CONSTANT STRING 	c_CalDisableBGMagenta	= "027|"
CONSTANT STRING 	c_CalDisableBGDarkMagenta	= "028|"
CONSTANT STRING 	c_CalDisableBGCyan	= "029|"
CONSTANT STRING 	c_CalDisableBGDarkCyan	= "030|"
CONSTANT STRING 	c_CalDisableBGYellow	= "031|"
CONSTANT STRING 	c_CalDisableBGDarkYellow	= "032|"

CONSTANT STRING 	c_CalDisableRegular	= "033|"
CONSTANT STRING 	c_CalDisableBold		= "034|"
CONSTANT STRING 	c_CalDisableItalic		= "035|"
CONSTANT STRING 	c_CalDisableUnderline	= "036|"

CONSTANT STRING 	c_CalMonthBlack		= "001|"
CONSTANT STRING 	c_CalMonthWhite		= "002|"
CONSTANT STRING 	c_CalMonthGray		= "003|"
CONSTANT STRING	c_CalMonthDarkGray	= "004|"
CONSTANT STRING 	c_CalMonthRed		= "005|"
CONSTANT STRING	c_CalMonthDarkRed	= "006|"
CONSTANT STRING 	c_CalMonthGreen		= "007|"
CONSTANT STRING	c_CalMonthDarkGreen	= "008|"
CONSTANT STRING 	c_CalMonthBlue		= "009|"
CONSTANT STRING 	c_CalMonthDarkBlue	= "010|"
CONSTANT STRING 	c_CalMonthMagenta	= "011|"
CONSTANT STRING	c_CalMonthDarkMagenta	= "012|"
CONSTANT STRING 	c_CalMonthCyan		= "013|"
CONSTANT STRING 	c_CalMonthDarkCyan	= "014|"
CONSTANT STRING 	c_CalMonthYellow		= "015|"
CONSTANT STRING 	c_CalMonthDarkYellow	= "016|"

CONSTANT STRING 	c_CalMonthBold		= "017|"
CONSTANT STRING 	c_CalMonthRegular		= "018|"
CONSTANT STRING 	c_CalMonthItalic		= "019|"
CONSTANT STRING	c_CalMonthUnderline	= "020|"

CONSTANT STRING	c_CalYearBlack		= "001|"
CONSTANT STRING 	c_CalYearWhite		= "002|"
CONSTANT STRING 	c_CalYearGray		= "003|"
CONSTANT STRING 	c_CalYearDarkGray		= "004|"
CONSTANT STRING 	c_CalYearRed		= "005|"
CONSTANT STRING	c_CalYearDarkRed		= "006|"
CONSTANT STRING 	c_CalYearGreen		= "007|"
CONSTANT STRING 	c_CalYearDarkGreen	= "008|"
CONSTANT STRING 	c_CalYearBlue		= "009|"
CONSTANT STRING 	c_CalYearDarkBlue		= "010|"
CONSTANT STRING 	c_CalYearMagenta		= "011|"
CONSTANT STRING 	c_CalYearDarkMagenta	= "012|"
CONSTANT STRING 	c_CalYearCyan		= "013|"
CONSTANT STRING 	c_CalYearDarkCyan	= "014|"
CONSTANT STRING	c_CalYearYellow		= "015|"
CONSTANT STRING 	c_CalYearDarkYellow	= "016|"

CONSTANT STRING 	c_CalYearBold		= "017|"
CONSTANT STRING 	c_CalYearRegular		= "018|"
CONSTANT STRING 	c_CalYearItalic		= "019|"
CONSTANT STRING 	c_CalYearUnderline		= "020|"

CONSTANT STRING 	c_CalYearShow		= "021|"
CONSTANT STRING 	c_CalYearHide		= "022|"

//-----------------------------------------------------------------------------------------
//  Calendar Instance Variables
//-----------------------------------------------------------------------------------------

INTEGER		i_MonthDays[12]		= {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

LONG			i_CalendarBGColor
STRING			i_CalendarSort		= "A"

INTEGER		i_HeadingSize		= 8
INTEGER		i_MonthSize		= 8
BOOLEAN		i_FontExprLoaded		= FALSE
BOOLEAN		i_HeightExprLoaded	= FALSE
BOOLEAN		i_WeightExprLoaded	= FALSE
BOOLEAN		i_ItalicExprLoaded		= FALSE
BOOLEAN		i_UnderExprLoaded		= FALSE

BOOLEAN		i_CalStyleSet		= FALSE
BOOLEAN		i_WDBGColorSet		= FALSE
BOOLEAN		i_WDColorSet		= FALSE
BOOLEAN		i_WDFontSet		= FALSE
BOOLEAN		i_WDSizeSet		= FALSE
BOOLEAN		i_WEBGColorSet		= FALSE
BOOLEAN		i_WEColorSet		= FALSE
BOOLEAN		i_HeadColorSet		= FALSE
BOOLEAN		i_HeadFontSet		= FALSE
BOOLEAN		i_HeadSizeSet		= FALSE
BOOLEAN		i_MonthColorSet		= FALSE
BOOLEAN		i_MonthFontSet		= FALSE
BOOLEAN		i_MonthSizeSet		= FALSE
BOOLEAN		i_YearColorSet		= FALSE
BOOLEAN		i_YearFontSet		= FALSE
BOOLEAN		i_YearSizeSet		= FALSE
BOOLEAN		i_DisBGColorSet		= FALSE
BOOLEAN		i_DisColorSet		= FALSE
BOOLEAN		i_DisFontSet		= FALSE
BOOLEAN		i_DisSizeSet		= FALSE
BOOLEAN		i_SelBGColorSet		= FALSE
BOOLEAN		i_SelColorSet		= FALSE
BOOLEAN		i_SelFontSet		= FALSE
BOOLEAN		i_SelSizeSet		= FALSE

BOOLEAN		i_CalendarResize		= TRUE

INTEGER		i_CalendarError		= 0

DATE			i_AnchorDate
STRING			i_AnchorDay
INTEGER		i_SelectedDay		= 0
INTEGER		i_ClickedDay		= 0
INTEGER		i_SelectedMonth		= 0
INTEGER		i_ClickedMonth		= 0
INTEGER		i_SelectedYear		= 0
INTEGER		i_ClickedYear		= 0

//-----------------------------------------------------------------------------------------
//  Drop-down Calendar Instance Variables
//-----------------------------------------------------------------------------------------

BOOLEAN		i_CalendarDD		= FALSE

STRING			i_CalendarDDType
INTEGER		i_CalendarDDIndex
STRING			i_CalendarDDColumn
INTEGER		i_CalendarDDRow

INTEGER		i_NumDD
INTEGER		i_NumDDObjects
INTEGER		i_NumDDColumns

STRING			i_DDName[]
STRING			i_DDType[]
INTEGER		i_DDIndex[]
INTEGER		i_DDWidth[]
INTEGER		i_DDHeight[]
INTEGER		i_DDX[]
INTEGER		i_DDY[]
INTEGER		i_DDDetail[]
INTEGER		i_DDCalWidth[]
INTEGER		i_DDCalHeight[]

U_DD_CALENDAR		i_DDObject[]
STRING			i_DDFormat[]

DATAWINDOW		i_DDDW[]
STRING			i_DDColumn[]

WINDOW		i_Window
USEROBJECT		i_UserObject
STRING			i_ParentObject
INTEGER		i_ParentHeight
DATAWINDOW		i_CurrentDW
BOOLEAN		i_DDClosed


end variables

forward prototypes
public function integer fu_calgetyear ()
public function integer fu_calgetmonth ()
public function integer fu_calsetweekday (integer begin_day, integer end_day)
public function integer fu_calsetweekend (integer begin_day, integer end_day)
public function long fu_calgetdates (ref date selected_dates[])
public subroutine fu_calcreate ()
public subroutine fu_calresize ()
public function integer fu_calsetmonth (integer month, integer year)
public function integer fu_calsetyear (integer year)
public subroutine fu_calsetdates (date selected_dates[])
public subroutine fu_calcleardates ()
public subroutine fu_calenabledate (date enable_date)
public subroutine fu_caldisabledate (date disable_date)
public subroutine fu_calsetday (date current_date, string action)
private subroutine fu_calloadfont ()
private subroutine fu_calloadheight ()
private subroutine fu_calloadweight ()
private subroutine fu_calloaditalic ()
private subroutine fu_calloadunder ()
public subroutine fu_ddcalwiredw (datawindow dd_dw, string dd_column, integer percent_width, integer drop_height)
public function integer fu_ddopen (datawindow dw_name)
public subroutine fu_ddcalwire (ref u_dd_calendar dd_object, string dd_format, integer percent_width, integer drop_height)
public subroutine fu_ddkeydown ()
public function double fu_ddfindxpos (string dw_column)
public function string fu_getidentity ()
public function integer fu_calsetmonth (integer month)
protected subroutine fu_calsetoptions (string optionstyle, string options)
public subroutine fu_caldayoptions (string textfont, integer textsize, string options)
public subroutine fu_calheadingoptions (string textfont, integer textsize, string options)
public subroutine fu_caloptions (string options)
protected subroutine fu_calsetnextoptions (string optionstyle, string options)
public subroutine fu_caldisableoptions (string textfont, integer textsize, string options)
public subroutine fu_calmonthoptions (string textfont, integer textsize, string options)
public subroutine fu_calselectoptions (string textfont, integer textsize, string options)
public subroutine fu_calyearoptions (string textfont, integer textsize, string options)
end prototypes

event po_daychanged;////******************************************************************
////  PO Module     : u_Calendar
////  Event         : po_DayChanged
////  Description   : Provides an opportunity for the developer to
////                  do any processing after a date is selected.
////
////  Parameters    : INTEGER SelectedDay - 
////                      Day number.
////
////  Return Value  : None.  All date processing is completed before
////                  this event is triggered.
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code for getting all selected dates.
////------------------------------------------------------------------
//
//DATE l_SelectedDates[]
//
//l_NumDates = fu_CalGetDates(l_SelectedDates[])

end event

event po_dayvalidate;////******************************************************************
////  PO Module     : u_Calendar
////  Event         : po_DayValidate
////  Description   : Provides an opportunity for the developer to
////                  do any processing before a date is selected.
////
////  Parameters    : INTEGER ClickedDay - 
////                     Number of the new date selected by the user.
////                  INTEGER SelectedDay - 
////                     Number of the currently selected date.
////
////  Return Value  : i_CalendarError -
////                     Indicates if an error has occured in the 
////                     processing of this event.  Set to 
////                     c_ValFailed (-1) to stop the new date
////                     from becoming the current date.
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code for validating a DataWindow on the current date
////  before allowing the new date to become selected.
////------------------------------------------------------------------
//
//IF <dw>.AcceptText() = -1 THEN
//   i_CalendarError = c_ValFailed
//END IF
end event

event po_monthchanged;////******************************************************************
////  PO Module     : u_Calendar
////  Event         : po_MonthChanged
////  Description   : Provides an opportunity for the developer to
////                  do any processing after a month is selected.
////
////  Parameters    : INTEGER SelectedMonth - 
////                      Month number.
////
////  Return Value  : None.  All date processing is completed before
////                  this event is triggered.
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************

end event

event po_monthvalidate;////******************************************************************
////  PO Module     : u_Calendar
////  Event         : po_MonthValidate
////  Description   : Provides an opportunity for the developer to
////                  do any processing before a month is selected.
////
////  Parameters    : INTEGER ClickedMonth - 
////                     Number of the new month selected by the user.
////                  INTEGER SelectedMonth - 
////                     Number of the currently selected month.
////
////  Return Value  : i_CalendarError -
////                     Indicates if an error has occured in the 
////                     processing of this event.  Set to 
////                     c_ValFailed (-1) to stop the new month
////                     from becoming the current month.
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code for validating a DataWindow on the current month
////  before allowing the new month to become selected.
////------------------------------------------------------------------
//
//IF <dw>.AcceptText() = -1 THEN
//   i_CalendarError = c_ValFailed
//END IF
end event

event po_yearchanged;////******************************************************************
////  PO Module     : u_Calendar
////  Event         : po_YearChanged
////  Description   : Provides an opportunity for the developer to
////                  do any processing after a year is selected.
////
////  Parameters    : INTEGER SelectedYear - 
////                     Year number.
////
////  Return Value  : None.  All date processing is completed before
////                  this event is triggered.
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************

end event

event po_yearvalidate;////******************************************************************
////  PO Module     : u_Calendar
////  Event         : po_YearValidate
////  Description   : Provides an opportunity for the developer to
////                  do any processing before a year is selected.
////
////  Parameters    : INTEGER ClickedYear - 
////                     Number of the new year selected by the user.
////                  INTEGER SelectedYear - 
////                     Number of the currently selected year.
////
////  Return Value  : i_CalendarError -
////                     Indicates if an error has occured in the 
////                     processing of this event.  Set to 
////                     c_ValFailed (-1) to stop the new year
////                     from becoming the current year.
////
////  Change History: 
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code for validating a DataWindow on the current year
////  before allowing the new year to become selected.
////------------------------------------------------------------------
//
//IF <dw>.AcceptText() = -1 THEN
//   i_CalendarError = c_ValFailed
//END IF
end event

event po_ddfocus;//******************************************************************
//  PO Module     : u_Calendar
//  Event         : po_DDFocus
//  Description   : Set the focus on the drop-down object or 
//                  DataWindow column.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF i_CalendarDD THEN
   IF i_CalendarDDType = "OBJECT" THEN
      i_DDObject[i_DDIndex[i_CalendarDDIndex]].SetFocus()
   ELSE
      i_DDDW[i_DDIndex[i_CalendarDDIndex]].SetFocus()
   END IF
END IF      
end event

event po_ddtabout;//******************************************************************
//  PO Module     : u_Calendar
//  Event         : po_DDTabOut
//  Description   : Indicate that the user is tabbing out of the
//                  drop-down calendar.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

THIS.TriggerEvent(LoseFocus!)
THIS.PostEvent("po_DDFocus")
end event

event po_ddprocess;//******************************************************************
//  PO Module     : u_Calendar
//  Event         : po_DDProcess
//  Description   : Displays the calendar under the column using
//                  the column attributes for font and colors.  
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
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

STRING  l_DWColumn, l_Face, l_ColType, l_Column, l_TempBackColor
INTEGER l_Index, l_ColumnIndex, l_Idx, l_Pitch, l_Family
INTEGER l_CharSet, l_Size, l_Y, l_ParentHeight, l_FieldY
INTEGER l_FirstRow, l_NewWidth, l_NewHeight
LONG    l_BackColor, l_Color, l_Row, l_pos
BOOLEAN l_Found, l_DDD
DOUBLE  l_X
DATE    l_Date

SetPointer(HourGlass!)

l_Column   = i_CurrentDW.GetColumnName()
l_Row      = i_CurrentDW.GetRow()
l_DWColumn = i_CurrentDW.ClassName() + "." + l_Column

IF l_Column = i_CalendarDDColumn AND l_Row = i_CalendarDDRow AND &
   i_DDClosed THEN
   i_DDClosed = FALSE
   RETURN
ELSE
   i_DDClosed = FALSE
END IF

//------------------------------------------------------------------
//  Determine if the current column is a drop-down column.
//------------------------------------------------------------------

l_Found = FALSE
FOR l_Idx = 1 TO i_NumDD
   IF Lower(i_DDName[l_Idx]) = Lower(l_DWColumn) THEN
      l_Found = TRUE
      l_Index = l_Idx
      l_ColumnIndex = i_DDIndex[l_Idx]
      EXIT
   END IF
NEXT

//------------------------------------------------------------------
//  The column is a drop-down.
//------------------------------------------------------------------

IF l_Found THEN

   //---------------------------------------------------------------
   //  Grab the values for sizing and postioning the calendar.
   //---------------------------------------------------------------

   i_DDX[l_Index] = i_CurrentDW.X + &
                    Integer(i_CurrentDW.Describe(l_Column + ".X"))
   i_DDY[l_Index] = i_CurrentDW.Y + &
                    Integer(i_CurrentDW.Describe("datawindow.header.height")) + &
                    Integer(i_CurrentDW.Describe(l_Column + ".Y"))
   i_DDWidth[l_Index]  = Integer(i_CurrentDW.Describe(l_Column + ".Width"))
   i_DDHeight[l_Index] = Integer(i_CurrentDW.Describe(l_Column + ".Height"))
   i_DDDetail[l_Index] = Integer(i_CurrentDW.Describe("datawindow.detail.height"))

   IF i_DDCalWidth[l_Index] > c_DefaultDDWidth THEN
      l_NewWidth = Int(i_DDWidth[l_Index] * (i_DDCalWidth[l_Index]/100))
   ELSE
      l_NewWidth = i_DDWidth[l_Index]
   END IF

   IF i_DDCalHeight[l_Index] > c_DefaultDDHeight THEN
      l_NewHeight = i_DDCalHeight[l_Index]
   ELSE
      l_NewHeight = Int(l_NewWidth * .72)
   END IF

   //---------------------------------------------------------------
   //  Determine if the calendar is already associated with this
   //  column. If not, move the calendar to the column and set the 
   //  date that was in the column, if any.
   //---------------------------------------------------------------

   SetReDraw(FALSE)
   IF i_ParentObject = "WINDOW" THEN
      l_ParentHeight = i_Window.WorkSpaceHeight()
   ELSE
      l_ParentHeight = i_UserObject.Height
   END IF

   i_ParentHeight = l_ParentHeight
   SetItem(1, "sel", "")

   l_FirstRow = Integer(i_CurrentDW.Describe("datawindow.firstrowonpage"))
   l_FieldY = i_DDY[l_Index] + ((l_Row - l_FirstRow) * &
                 i_DDDetail[l_Index])
   IF l_FieldY + i_DDHeight[l_Index] + &
      l_NewHeight + 6 < l_ParentHeight THEN
      l_Y = l_FieldY + i_DDHeight[l_Index] + 6
   ELSEIF l_FieldY - l_NewHeight - 6 > 1 THEN
      l_Y = l_FieldY - l_NewHeight - 6
   ELSE
      l_Y = l_FieldY + i_DDHeight[l_Index] + 6
   END IF
         
   IF i_CurrentDW.HScrollBar THEN
      l_X = fu_DDFindXPos(l_Column)
   ELSE
      l_X = i_DDX[l_Index]
   END IF

   Move(l_X, l_Y)

   //---------------------------------------------------------------
   //  Set the calendar attributes based on the column attributes
   //---------------------------------------------------------------

   IF i_CalendarDDColumn <> l_Column THEN
      IF NOT i_CalStyleSet THEN
         IF Integer(i_CurrentDW.Describe(l_Column + ".Border")) >= 5 THEN
            l_DDD = TRUE
            SetItem(1, "cal_sty", "3D")
         ELSE
            l_DDD = FALSE
            SetItem(1, "cal_sty", "2D")
         END IF
      ELSE
         IF Integer(i_CurrentDW.Describe(l_Column + ".Border")) >= 5 THEN
            l_DDD = TRUE
         ELSE
            l_DDD = FALSE
         END IF         
      END IF

		//-------------------------------------------------------------------
		// Strip off the default value if an expression exists.
		//-------------------------------------------------------------------

		l_TempBackColor = i_CurrentDW.Describe(l_Column + ".Background.Color")
		l_Pos = POS(l_TempBackColor, "~t")

		IF l_Pos <> 0 THEN
			l_TempBackColor = Left(l_TempBackColor, l_Pos - 1)
			l_BackColor = LONG(Right(l_TempBackColor, Len(l_TempBackColor) - 1))
		ELSE
			l_BackColor = LONG(i_CurrentDW.Describe(l_Column + ".Background.Color"))
		END IF

      l_Color = Long(i_CurrentDW.Describe(l_Column + ".Color"))
      IF NOT i_WDColorSet THEN
         SetItem(1, "wd_c", l_Color)
      END IF
      IF NOT i_WEColorSet THEN
         SetItem(1, "we_c", l_Color)
      END IF
      IF NOT i_HeadColorSet THEN
         SetItem(1, "h_c", l_Color)
      END IF
      IF NOT i_MonthColorSet THEN
         SetItem(1, "m_c", l_Color)
      END IF
      IF NOT i_YearColorSet THEN
         SetItem(1, "y_c", l_Color)
      END IF

      l_Size = Integer(i_CurrentDW.Describe(l_Column + ".Font.Height"))
      IF NOT i_WDSizeSet THEN
         SetItem(1, "d_size", l_Size * -1)
      END IF
      IF NOT i_SelSizeSet THEN
         SetItem(1, "s_size", l_Size * -1)
      END IF
      IF NOT i_DisSizeSet THEN
         SetItem(1, "b_size", l_Size * -1)
      END IF
      IF NOT i_HeadSizeSet THEN
         SetItem(1, "h_size", l_Size * -1)
         i_HeadingSize = l_Size * -1
      END IF
      IF NOT i_MonthSizeSet THEN
         SetItem(1, "m_size", l_Size * -1)
         i_MonthSize = l_Size * -1
      END IF
      IF NOT i_YearSizeSet THEN
         SetItem(1, "y_size", l_Size * -1)
      END IF

      l_Face    = i_CurrentDW.Describe(l_Column + ".Font.Face")
      l_Family  = Integer(i_CurrentDW.Describe(l_Column + ".Font.Family"))
      l_Pitch   = Integer(i_CurrentDW.Describe(l_Column + ".Font.Pitch"))
      l_Charset = Integer(i_CurrentDW.Describe(l_Column + ".Font.Charset"))
      IF NOT i_WDFontSet THEN
         SetItem(1, "d_font", l_Face)
         SetItem(1, "d_f", l_Family)
         SetItem(1, "d_p", l_Pitch)
         SetItem(1, "d_cs", l_CharSet)
      END IF
      IF NOT i_SelFontSet THEN
         SetItem(1, "s_font", l_Face)
         SetItem(1, "s_f", l_Family)
         SetItem(1, "s_p", l_Pitch)
         SetItem(1, "s_cs", l_CharSet)
      END IF
      IF NOT i_DisFontSet THEN
         SetItem(1, "b_font", l_Face)
         SetItem(1, "b_f", l_Family)
         SetItem(1, "b_p", l_Pitch)
         SetItem(1, "b_cs", l_CharSet)
      END IF
      IF NOT i_HeadFontSet THEN
         SetItem(1, "h_font", l_Face)
         SetItem(1, "h_f", l_Family)
         SetItem(1, "h_p", l_Pitch)
         SetItem(1, "h_cs", l_CharSet)
      END IF
      IF NOT i_MonthFontSet THEN
         SetItem(1, "m_font", l_Face)
         SetItem(1, "m_f", l_Family)
         SetItem(1, "m_p", l_Pitch)
         SetItem(1, "m_cs", l_CharSet)
      END IF
      IF NOT i_YearFontSet THEN
         SetItem(1, "y_font", l_Face)
         SetItem(1, "y_f", l_Family)
         SetItem(1, "y_p", l_Pitch)
         SetItem(1, "y_cs", l_CharSet)
      END IF
   END IF

   IF l_NewWidth <> Width THEN
      Resize(l_NewWidth, l_NewHeight)
   END IF

   l_ColType   = Upper(i_CurrentDW.Describe(l_Column + ".ColType"))
   IF l_ColType = "DATE" THEN
      l_Date = i_CurrentDW.GetItemDate(l_Row, l_Column)
   ELSEIF l_ColType = "DATETIME" THEN
      l_Date = Date(i_CurrentDW.GetItemDateTime(l_Row, l_Column))
   END IF
   IF IsNull(l_Date) = FALSE THEN
      fu_CalSetMonth(Month(l_Date), Year(l_Date))
      fu_CalSetDay(l_Date, "RESET")
   ELSE
      fu_CalClearDates()
      fu_CalSetMonth(Month(Today()), Year(Today()))
   END IF

   i_CalendarDDType = "COLUMN"
   i_CalendarDDIndex = l_Index
   i_CalendarDDColumn = l_Column
   i_CalendarDDRow = l_Row

   SetRedraw(TRUE)
   Visible  = TRUE
   TabOrder = i_CurrentDW.TabOrder - 1
   SetFocus()
END IF
end event

event po_identify;//******************************************************************
//  PO Module     : u_Calendar
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

public function integer fu_calgetyear ();//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalGetYear
//  Description   : Returns the currently selected year.  
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER - 
//                     Year (yyyy).
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN i_SelectedYear
end function

public function integer fu_calgetmonth ();//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalGetMonth
//  Description   : Returns the currently selected month.  
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER - 
//                     Month (1-12).
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN i_SelectedMonth
end function

public function integer fu_calsetweekday (integer begin_day, integer end_day);//******************************************************************
//  PO Module     : u_Calendar
//  Function      : fu_CalSetWeekDay
//  Description   : Stores the starting and ending weekdays.
//
//  Parameters    : INTEGER - Begin_Day - 
//                     Start day of the week
//						  INTEGER - End_Day   - 
//                     End day for the week
//
//  Return Value  : INTEGER -
//                      0 = valid day.
//                     -1 = invalid day.
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
//  Make sure we have valid day numbers.
//------------------------------------------------------------------

IF begin_day < 1 OR begin_day > 7 THEN
   RETURN -1
END IF

IF end_day < 1 OR end_day > 7 THEN
   RETURN -1
END IF

RETURN 0

end function

public function integer fu_calsetweekend (integer begin_day, integer end_day);//******************************************************************
//  PO Module     : u_Calendar
//  Function      : fu_CalSetWeekEnd
//  Description   : Stores the starting and ending weekends.
//
//  Parameters    : INTEGER - Begin_Day - 
//                     Start day of the weekend
//						  INTEGER - End_Day   - 
//                     End day for the weekend
//
//  Return Value  : INTEGER -
//                      0 = valid day.
//                     -1 = invalid day.
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
//  Make sure we have valid day numbers.
//------------------------------------------------------------------

IF begin_day < 1 OR begin_day > 7 THEN
   RETURN -1
END IF

IF end_day < 1 OR end_day > 7 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Store the day number.
//------------------------------------------------------------------

SetItem(1, "we_day1", begin_day)
SetItem(1, "we_day2", end_day)

RETURN 0

end function

public function long fu_calgetdates (ref date selected_dates[]);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalGetDates
//  Description   : Returns the currently selected dates.  
//
//  Parameters    : DATE Selected_Dates[] - 
//                     Array of selected dates. 
//
//  Return Value  : LONG - 
//                     Number of dates selected
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_Inserted
LONG   l_NumDates, l_Jdx, l_Idx
STRING l_DateStr, l_DateVal
DATE   l_Date

l_NumDates = 0
l_DateStr = GetItemString(1, "sel")
DO
   IF l_DateStr <> "" THEN
      l_DateVal = TRIM(MID(l_DateStr, 1, 9))
      l_Date = Date(Integer(Left(l_DateVal, 4)), &
                    Integer(Mid(l_DateVal, 5, 2)), &
                    Integer(Right(l_DateVal, 2)))
      IF i_CalendarSort = "A" AND l_NumDates > 0 THEN
         l_Inserted = FALSE
         FOR l_Idx = 1 TO l_NumDates
            IF l_Date < selected_dates[l_Idx] THEN
               l_Inserted = TRUE
					IF l_NumDates + 1 <= l_Idx + 1 THEN
                  FOR l_Jdx = l_NumDates + 1 TO l_Idx + 1
                     selected_dates[l_Jdx] = selected_dates[l_Jdx - 1]
                  NEXT
					ELSE
                  FOR l_Jdx = l_NumDates + 1 TO l_Idx + 1 STEP -1
                     selected_dates[l_Jdx] = selected_dates[l_Jdx - 1]
                  NEXT
					END IF
               selected_dates[l_Idx] = l_Date
               EXIT
            END IF
         NEXT
         IF NOT l_Inserted THEN
            selected_dates[l_NumDates + 1] = l_Date
         END IF
      ELSEIF i_CalendarSort = "D" AND l_NumDates > 0 THEN
         l_Inserted = FALSE
         FOR l_Idx = 1 TO l_NumDates
            IF l_Date > selected_dates[l_Idx] THEN
               l_Inserted = TRUE
					IF l_NumDates + 1 <= l_Idx + 1 THEN
                  FOR l_Jdx = l_NumDates + 1 TO l_Idx + 1
                     selected_dates[l_Jdx] = selected_dates[l_Jdx - 1]
                  NEXT
					ELSE
                  FOR l_Jdx = l_NumDates + 1 TO l_Idx + 1 STEP -1
                     selected_dates[l_Jdx] = selected_dates[l_Jdx - 1]
                  NEXT
					END IF
               selected_dates[l_Idx] = l_Date
               EXIT
            END IF
         NEXT
         IF NOT l_Inserted THEN
            selected_dates[l_NumDates + 1] = l_Date
         END IF
      ELSE
         selected_dates[l_NumDates + 1] = l_Date
      END IF 
      l_NumDates = l_NumDates + 1
      IF Len(l_DateStr) > 9 THEN
         l_DateStr = MID(l_DateStr, 10)
      ELSE
         l_DateStr = ""
      END IF
   END IF
LOOP UNTIL l_DateStr = ""

RETURN l_NumDates
end function

public subroutine fu_calcreate ();//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalCreate
//  Description   : Creates the calendar within the control.  
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

DATE l_Date

//------------------------------------------------------------------
//  Initialize the calendar with the current month/year.
//------------------------------------------------------------------

SetReDraw(FALSE)
l_Date = today()
i_SelectedMonth = Month(l_Date)
i_SelectedYear  = Year(l_Date)
SetItem(1, "first_day", DayNumber(Date(i_SelectedYear, &
        i_SelectedMonth, 1)))
IF i_SelectedMonth = 2 AND Mod(i_SelectedYear - 1900, 4) = 0 THEN
   SetItem(1, "last_day", i_MonthDays[i_SelectedMonth] + 1)
ELSE
   SetItem(1, "last_day", i_MonthDays[i_SelectedMonth])
END IF
SetItem(1, "month", String(i_SelectedMonth, '00'))
SetItem(1, "year" , STRING(i_SelectedYear))
SetItem(1, "sel", "")
SetItem(1, "dis", "")
Modify("month.text='" + &
       String(Date(i_SelectedYear, i_SelectedMonth, 1), "mmmm") + &
       "'")

SetNull(i_AnchorDate)
SetNull(i_AnchorDay)
i_SelectedDay = 0
i_ClickedDay  = 0

//------------------------------------------------------------------
//  Call the fu_CalResize function to create the calendar.
//------------------------------------------------------------------

THIS.fu_CalResize()
SetReDraw(TRUE)

end subroutine

public subroutine fu_calresize ();//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalResize
//  Description   : Resize the calendar control.  
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_DwWidth, l_DwHeight, l_ExtraWidth, l_Idx
INTEGER l_CellWidth, l_ExtraHeight, l_CellHeight, l_Day, l_Length
STRING  l_DayName
DATE    l_Date

//-------------------------------------------------------------------
//  Determine the width and height of the control.
//-------------------------------------------------------------------

l_DwWidth     = UnitsToPixels(Width, XUnitsToPixels!)
l_DwHeight    = UnitsToPixels(Height,YUnitsToPixels!)

l_CellWidth   = Int((l_DwWidth - 18) / 7)
l_CellHeight  = Int((l_DwHeight - i_MonthSize - &
                    i_HeadingSize - 41) / 6)

l_ExtraWidth  = MOD((l_DwWidth - 18) , 7)
l_ExtraHeight = MOD((l_DwHeight - i_MonthSize - &
                    i_HeadingSize - 41) , 6)

Modify("datawindow.detail.height=" + String(l_DwHeight))

SetItem(1, "cal_w",  l_DwWidth)
SetItem(1, "cal_h",  l_DwHeight)
SetItem(1, "cell_w", l_CellWidth)
SetItem(1, "cell_h", l_CellHeight)
SetItem(1, "mod_w",  l_ExtraWidth)
SetItem(1, "mod_h",  l_ExtraHeight)

l_Date = Today()
l_Length = GetItemNumber(1, "h_len")
l_Day = 7 - DayNumber(Date(Year(l_Date), Month(l_Date), 1)) + 1
FOR l_Idx = 1 TO 7
   l_DayName = DayName(Date(Year(l_Date), Month(l_Date), l_Day + l_Idx))
   IF l_Length > 0 THEN
      IF l_Length < 4 THEN
         l_DayName = Left(l_DayName, l_Length)
      END IF
   ELSE
      IF l_CellWidth < 17 THEN
         l_DayName = Left(l_DayName, 1)
      ELSE
         IF l_CellWidth < 24 THEN
            l_DayName = Left(l_DayName, 2)
         ELSE
            l_DayName = Left(l_dayName, 3)
         END IF
      END IF
   END IF
   Modify("heading" + String(l_Idx) + ".text='" + l_DayName + "' ")
NEXT

end subroutine

public function integer fu_calsetmonth (integer month, integer year);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalSetMonth
//  Description   : Sets the given month and year as current.  
//
//  Parameters    : INTEGER Month -
//                     Month to set current.
//                  INTEGER Year -
//                     Year to set current.
//
//  Return Value  : INTEGER - 
//                      0 = OK.
//                     -1 = validation failed.
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
//  Validate the month.
//------------------------------------------------------------------

IF month < 1 OR month > 12 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Validate the current month and year before moving to the new
//  month and year.
//------------------------------------------------------------------

i_CalendarError = c_ValOK
i_ClickedMonth  = month
i_ClickedYear   = year

Event po_MonthValidate(i_ClickedMonth, i_SelectedMonth)

IF i_CalendarError = c_ValFailed THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Set the new month and year.
//------------------------------------------------------------------

SetRedraw(FALSE)

i_SelectedMonth = month
i_SelectedYear  = year

SetItem(1, "first_day", DayNumber(Date(i_SelectedYear, &
        i_SelectedMonth, 1)))
IF i_SelectedMonth = 2 AND Mod(i_SelectedYear - 1900, 4) = 0 THEN
   SetItem(1, "last_day", i_MonthDays[i_SelectedMonth] + 1)
ELSE
   SetItem(1, "last_day", i_MonthDays[i_SelectedMonth])
END IF
SetItem(1, "month", String(i_SelectedMonth, '00'))
SetItem(1, "year" , String(i_SelectedYear))
Modify("month.text='" + &
       String(Date(i_SelectedYear, i_SelectedMonth, 1), "mmmm") + &
       "'")

Event po_MonthChanged(i_SelectedMonth)

SetRedraw(TRUE)

RETURN 0
end function

public function integer fu_calsetyear (integer year);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalSetYear
//  Description   : Sets the given year as current.  
//
//  Parameters    : INTEGER Year -
//                     Year to set current.
//
//  Return Value  : INTEGER - 
//                      0 = OK.
//                     -1 = validation failed.
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
//  Validate the year.
//------------------------------------------------------------------

IF year < 1900 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Validate the current year before moving to the new year.
//------------------------------------------------------------------

i_CalendarError = c_ValOK
i_ClickedMonth  = Integer(GetItemString(1, "month"))
i_ClickedYear   = year

Event po_YearValidate(i_ClickedYear, i_SelectedYear)

IF i_CalendarError = c_ValFailed THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Set the new year.
//------------------------------------------------------------------

SetRedraw(FALSE)

i_SelectedYear  = year

SetItem(1, "first_day", DayNumber(Date(i_SelectedYear, &
        i_SelectedMonth, 1)))
IF i_SelectedMonth = 2 AND Mod(i_SelectedYear - 1900, 4) = 0 THEN
   SetItem(1, "last_day", i_MonthDays[i_SelectedMonth] + 1)
ELSE
   SetItem(1, "last_day", i_MonthDays[i_SelectedMonth])
END IF
SetItem(1, "year" , String(i_SelectedYear))

Event po_YearChanged(i_SelectedYear)

SetRedraw(TRUE)

RETURN 0
end function

public subroutine fu_calsetdates (date selected_dates[]);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalSetDates
//  Description   : Sets the given year as current.  
//
//  Parameters    : DATE Selected_Dates[] -
//                     Array of dates to set as selected.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_NumDates, l_Idx
DATE l_Date

THIS.fu_CalClearDates()

//------------------------------------------------------------------
//  Add the new dates.
//------------------------------------------------------------------

l_NumDates = UpperBound(selected_dates[])
FOR l_Idx = 1 TO l_NumDates 
   l_Date = selected_dates[l_Idx]
   THIS.fu_CalSetDay(l_Date, "ADD")
NEXT

end subroutine

public subroutine fu_calcleardates ();//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalClearDates
//  Description   : Clears the selected dates.  
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Remove any dates for this calendar instance
//------------------------------------------------------------------

SetItem(1, "sel", "")
SetReDraw(TRUE)

end subroutine

public subroutine fu_calenabledate (date enable_date);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalEnableDate
//  Description   : Enable a date that was previously disabled.  
//
//  Parameters    : DATE Enable_Date -
//                     Date to enable.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_DateStr
LONG   l_Pos

l_DateStr = " " + String(enable_date, "yyyymmdd")
l_Pos = POS(GetItemString(1, "dis"), l_DateStr)
IF l_Pos > 0 THEN
   SetItem(1, "dis", &
           Replace(GetItemString(1, "dis"), l_Pos, 9, ""))
END IF

end subroutine

public subroutine fu_caldisabledate (date disable_date);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalDisableDate
//  Description   : Disable a date from being selected.  
//
//  Parameters    : DATE Disable_Date -
//                     Date to disable.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Date, l_SelectedDates, l_DisabledDates

//------------------------------------------------------------------
//  Format the date as a string.
//------------------------------------------------------------------

l_Date = String(disable_date, "yyyymmdd")

//------------------------------------------------------------------
//  Check to see if the date is selected.
//------------------------------------------------------------------

l_SelectedDates = GetItemString(1, "sel")
IF Pos(l_SelectedDates, l_Date) > 0 THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Check to see if the date is already disabled.
//------------------------------------------------------------------

l_DisabledDates = GetItemString(1, "dis")
IF Pos(l_DisabledDates, l_Date) > 0 THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Disable the date.
//------------------------------------------------------------------

SetItem(1, "dis", GetItemString(1, "dis") + " " + l_Date)
end subroutine

public subroutine fu_calsetday (date current_date, string action);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalSetDay
//  Description   : Selects or deselects the given day for the 
//                  current month and year on the calendar.  
//
//  Parameters    : DATE Current_Date -
//                     Date to add or delete.
//                  STRING Action -
//                     The action to take with the date.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_DateStr
LONG   l_Pos

CHOOSE CASE action

   CASE "ADD"

      SetItem(1, "sel", GetItemString(1, "sel") + " " + &
              String(current_date, "yyyymmdd"))

   CASE "DELETE"

      l_DateStr = " " + String(current_date, "yyyymmdd")
      l_Pos = POS(GetItemString(1, "sel"), l_DateStr)
      IF l_Pos > 0 THEN
         SetItem(1, "sel", &
                 Replace(GetItemString(1, "sel"), l_Pos, 9, ""))
      END IF

   CASE "RESET"

      SetItem(1, "sel", " " + String(current_date, "yyyymmdd"))

END CHOOSE

end subroutine

private subroutine fu_calloadfont ();Modify( + &
"day11.font.face=~"Arial~tif(POS(sel,year+month+String(1-first_day+1,'00'))>0, s_font, if(POS(dis,year+month+String(1-first_day+1,'00'))>0, b_font, d_font))~" " + &
"day12.font.face=~"Arial~tif(POS(sel,year+month+String(2-first_day+1,'00'))>0, s_font, if(POS(dis,year+month+String(2-first_day+1,'00'))>0, b_font, d_font))~" " + & 
"day13.font.face=~"Arial~tif(POS(sel,year+month+String(3-first_day+1,'00'))>0, s_font, if(POS(dis,year+month+String(3-first_day+1,'00'))>0, b_font, d_font))~" " + & 
"day14.font.face=~"Arial~tif(POS(sel,year+month+String(4-first_day+1,'00'))>0, s_font, if(POS(dis,year+month+String(4-first_day+1,'00'))>0, b_font, d_font))~" " + & 
"day15.font.face=~"Arial~tif(POS(sel,year+month+String(5-first_day+1,'00'))>0, s_font, if(POS(dis,year+month+String(5-first_day+1,'00'))>0, b_font, d_font))~" " + & 
"day16.font.face=~"Arial~tif(POS(sel,year+month+String(6-first_day+1,'00'))>0, s_font, if(POS(dis,year+month+String(6-first_day+1,'00'))>0, b_font, d_font))~" " + & 
"day17.font.face=~"Arial~tif(POS(sel,year+month+String(7-first_day+1,'00'))>0, s_font, if(POS(dis,year+month+String(7-first_day+1,'00'))>0, b_font, d_font))~" " + & 
"day21.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+1,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+1,'00'))>0, b_font, d_font))~" " + & 
"day22.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+2,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+2,'00'))>0, b_font, d_font))~" " + & 
"day23.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+3,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+3,'00'))>0, b_font, d_font))~" " + & 
"day24.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+4,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+4,'00'))>0, b_font, d_font))~" " + & 
"day25.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+5,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+5,'00'))>0, b_font, d_font))~" " + & 
"day26.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+6,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+6,'00'))>0, b_font, d_font))~" " + & 
"day27.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+7,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+7,'00'))>0, b_font, d_font))~" " + & 
"day31.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+8,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+8,'00'))>0, b_font, d_font))~" " + & 
"day32.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+9,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+9,'00'))>0, b_font, d_font))~" " + & 
"day33.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+10,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+10,'00'))>0, b_font, d_font))~" " + & 
"day34.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+11,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+11,'00'))>0, b_font, d_font))~" " + & 
"day35.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+12,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+12,'00'))>0, b_font, d_font))~" " + & 
"day36.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+13,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+13,'00'))>0, b_font, d_font))~" " + & 
"day37.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+14,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+14,'00'))>0, b_font, d_font))~" " + & 
"day41.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+15,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+15,'00'))>0, b_font, d_font))~" " + & 
"day42.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+16,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+16,'00'))>0, b_font, d_font))~" " + & 
"day43.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+17,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+17,'00'))>0, b_font, d_font))~" " + & 
"day44.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+18,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+18,'00'))>0, b_font, d_font))~" " + & 
"day45.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+19,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+19,'00'))>0, b_font, d_font))~" " + & 
"day46.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+20,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+20,'00'))>0, b_font, d_font))~" " + & 
"day47.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+21,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+21,'00'))>0, b_font, d_font))~" " + & 
"day51.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+22,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+22,'00'))>0, b_font, d_font))~" " + & 
"day52.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+23,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+23,'00'))>0, b_font, d_font))~" " + & 
"day53.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+24,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+24,'00'))>0, b_font, d_font))~" " + & 
"day54.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+25,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+25,'00'))>0, b_font, d_font))~" " + & 
"day55.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+26,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+26,'00'))>0, b_font, d_font))~" " + & 
"day56.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+27,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+27,'00'))>0, b_font, d_font))~" " + & 
"day57.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+28,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+28,'00'))>0, b_font, d_font))~" " + & 
"day61.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+29,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+29,'00'))>0, b_font, d_font))~" " + & 
"day62.font.face=~"Arial~tif(POS(sel,year+month+String((7-first_day+1)+30,'00'))>0, s_font, if(POS(dis,year+month+String((7-first_day+1)+30,'00'))>0, b_font, d_font))~" " + & 
"day11.font.family=~"2~tif(POS(sel,year+month+String(1-first_day+1,'00'))>0, s_f, if(POS(dis,year+month+String(1-first_day+1,'00'))>0, b_f, d_f))~" " + &
"day12.font.family=~"2~tif(POS(sel,year+month+String(2-first_day+1,'00'))>0, s_f, if(POS(dis,year+month+String(2-first_day+1,'00'))>0, b_f, d_f))~" " + &
"day13.font.family=~"2~tif(POS(sel,year+month+String(3-first_day+1,'00'))>0, s_f, if(POS(dis,year+month+String(3-first_day+1,'00'))>0, b_f, d_f))~" " + &
"day14.font.family=~"2~tif(POS(sel,year+month+String(4-first_day+1,'00'))>0, s_f, if(POS(dis,year+month+String(4-first_day+1,'00'))>0, b_f, d_f))~" " + &
"day15.font.family=~"2~tif(POS(sel,year+month+String(5-first_day+1,'00'))>0, s_f, if(POS(dis,year+month+String(5-first_day+1,'00'))>0, b_f, d_f))~" " + &
"day16.font.family=~"2~tif(POS(sel,year+month+String(6-first_day+1,'00'))>0, s_f, if(POS(dis,year+month+String(6-first_day+1,'00'))>0, b_f, d_f))~" " + &
"day17.font.family=~"2~tif(POS(sel,year+month+String(7-first_day+1,'00'))>0, s_f, if(POS(dis,year+month+String(7-first_day+1,'00'))>0, b_f, d_f))~" " + &
"day21.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+1,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+1,'00'))>0, b_f, d_f))~" " + & 
"day22.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+2,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+2,'00'))>0, b_f, d_f))~" " + & 
"day23.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+3,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+3,'00'))>0, b_f, d_f))~" " + & 
"day24.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+4,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+4,'00'))>0, b_f, d_f))~" " + & 
"day25.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+5,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+5,'00'))>0, b_f, d_f))~" " + & 
"day26.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+6,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+6,'00'))>0, b_f, d_f))~" " + & 
"day27.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+7,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+7,'00'))>0, b_f, d_f))~" " + & 
"day31.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+8,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+8,'00'))>0, b_f, d_f))~" " + & 
"day32.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+9,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+9,'00'))>0, b_f, d_f))~" " + & 
"day33.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+10,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+10,'00'))>0, b_f, d_f))~" " + & 
"day34.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+11,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+11,'00'))>0, b_f, d_f))~" " + & 
"day35.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+12,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+12,'00'))>0, b_f, d_f))~" " + & 
"day36.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+13,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+13,'00'))>0, b_f, d_f))~" " + & 
"day37.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+14,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+14,'00'))>0, b_f, d_f))~" " + & 
"day41.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+15,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+15,'00'))>0, b_f, d_f))~" " + & 
"day42.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+16,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+16,'00'))>0, b_f, d_f))~" " + & 
"day43.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+17,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+17,'00'))>0, b_f, d_f))~" " + & 
"day44.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+18,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+18,'00'))>0, b_f, d_f))~" " + & 
"day45.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+19,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+19,'00'))>0, b_f, d_f))~" " + & 
"day46.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+20,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+20,'00'))>0, b_f, d_f))~" " + & 
"day47.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+21,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+21,'00'))>0, b_f, d_f))~" " + & 
"day51.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+22,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+22,'00'))>0, b_f, d_f))~" " + & 
"day52.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+23,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+23,'00'))>0, b_f, d_f))~" " + & 
"day53.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+24,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+24,'00'))>0, b_f, d_f))~" " + & 
"day54.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+25,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+25,'00'))>0, b_f, d_f))~" " + & 
"day55.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+26,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+26,'00'))>0, b_f, d_f))~" " + & 
"day56.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+27,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+27,'00'))>0, b_f, d_f))~" " + & 
"day57.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+28,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+28,'00'))>0, b_f, d_f))~" " + & 
"day61.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+29,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+29,'00'))>0, b_f, d_f))~" " + & 
"day62.font.family= ~"2~tif(POS(sel,year+month+String((7-first_day+1)+30,'00'))>0, s_f, if(POS(dis,year+month+String((7-first_day+1)+30,'00'))>0, b_f, d_f))~" " + & 
"day11.font.pitch=~"2~tif(POS(sel,year+month+String(1-first_day+1,'00'))>0, s_p, if(POS(dis,year+month+String(1-first_day+1,'00'))>0, b_p, d_p))~" " + &
"day12.font.pitch=~"2~tif(POS(sel,year+month+String(2-first_day+1,'00'))>0, s_p, if(POS(dis,year+month+String(2-first_day+1,'00'))>0, b_p, d_p))~" " + &
"day13.font.pitch=~"2~tif(POS(sel,year+month+String(3-first_day+1,'00'))>0, s_p, if(POS(dis,year+month+String(3-first_day+1,'00'))>0, b_p, d_p))~" " + &
"day14.font.pitch=~"2~tif(POS(sel,year+month+String(4-first_day+1,'00'))>0, s_p, if(POS(dis,year+month+String(4-first_day+1,'00'))>0, b_p, d_p))~" " + &
"day15.font.pitch=~"2~tif(POS(sel,year+month+String(5-first_day+1,'00'))>0, s_p, if(POS(dis,year+month+String(5-first_day+1,'00'))>0, b_p, d_p))~" " + &
"day16.font.pitch=~"2~tif(POS(sel,year+month+String(6-first_day+1,'00'))>0, s_p, if(POS(dis,year+month+String(6-first_day+1,'00'))>0, b_p, d_p))~" " + &
"day17.font.pitch=~"2~tif(POS(sel,year+month+String(7-first_day+1,'00'))>0, s_p, if(POS(dis,year+month+String(7-first_day+1,'00'))>0, b_p, d_p))~" " + &
"day21.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+1,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+1,'00'))>0, b_p, d_p))~" " + & 
"day22.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+2,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+2,'00'))>0, b_p, d_p))~" " + & 
"day23.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+3,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+3,'00'))>0, b_p, d_p))~" " + & 
"day24.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+4,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+4,'00'))>0, b_p, d_p))~" " + & 
"day25.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+5,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+5,'00'))>0, b_p, d_p))~" " + & 
"day26.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+6,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+6,'00'))>0, b_p, d_p))~" " + & 
"day27.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+7,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+7,'00'))>0, b_p, d_p))~" " + & 
"day31.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+8,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+8,'00'))>0, b_p, d_p))~" " + & 
"day32.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+9,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+9,'00'))>0, b_p, d_p))~" " + & 
"day33.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+10,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+10,'00'))>0, b_p, d_p))~" " + & 
"day34.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+11,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+11,'00'))>0, b_p, d_p))~" " + & 
"day35.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+12,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+12,'00'))>0, b_p, d_p))~" " + & 
"day36.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+13,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+13,'00'))>0, b_p, d_p))~" " + & 
"day37.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+14,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+14,'00'))>0, b_p, d_p))~" " + & 
"day41.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+15,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+15,'00'))>0, b_p, d_p))~" " + & 
"day42.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+16,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+16,'00'))>0, b_p, d_p))~" " + & 
"day43.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+17,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+17,'00'))>0, b_p, d_p))~" " + & 
"day44.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+18,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+18,'00'))>0, b_p, d_p))~" " + & 
"day45.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+19,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+19,'00'))>0, b_p, d_p))~" " + & 
"day46.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+20,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+20,'00'))>0, b_p, d_p))~" " + & 
"day47.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+21,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+21,'00'))>0, b_p, d_p))~" " + & 
"day51.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+22,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+22,'00'))>0, b_p, d_p))~" " + & 
"day52.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+23,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+23,'00'))>0, b_p, d_p))~" " + & 
"day53.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+24,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+24,'00'))>0, b_p, d_p))~" " + & 
"day54.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+25,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+25,'00'))>0, b_p, d_p))~" " + & 
"day55.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+26,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+26,'00'))>0, b_p, d_p))~" " + & 
"day56.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+27,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+27,'00'))>0, b_p, d_p))~" " + & 
"day57.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+28,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+28,'00'))>0, b_p, d_p))~" " + & 
"day61.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+29,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+29,'00'))>0, b_p, d_p))~" " + & 
"day62.font.pitch=~"2~tif(POS(sel,year+month+String((7-first_day+1)+30,'00'))>0, s_p, if(POS(dis,year+month+String((7-first_day+1)+30,'00'))>0, b_p, d_p))~" " + & 
"day11.font.charset=~"0~tif(POS(sel,year+month+String(1-first_day+1,'00'))>0, s_cs, if(POS(dis,year+month+String(1-first_day+1,'00'))>0, b_cs, d_cs))~" " + &
"day12.font.charset=~"0~tif(POS(sel,year+month+String(2-first_day+1,'00'))>0, s_cs, if(POS(dis,year+month+String(2-first_day+1,'00'))>0, b_cs, d_cs))~" " + &
"day13.font.charset=~"0~tif(POS(sel,year+month+String(3-first_day+1,'00'))>0, s_cs, if(POS(dis,year+month+String(3-first_day+1,'00'))>0, b_cs, d_cs))~" " + & 
"day14.font.charset=~"0~tif(POS(sel,year+month+String(4-first_day+1,'00'))>0, s_cs, if(POS(dis,year+month+String(4-first_day+1,'00'))>0, b_cs, d_cs))~" " + & 
"day15.font.charset=~"0~tif(POS(sel,year+month+String(5-first_day+1,'00'))>0, s_cs, if(POS(dis,year+month+String(5-first_day+1,'00'))>0, b_cs, d_cs))~" " + & 
"day16.font.charset=~"0~tif(POS(sel,year+month+String(6-first_day+1,'00'))>0, s_cs, if(POS(dis,year+month+String(6-first_day+1,'00'))>0, b_cs, d_cs))~" " + & 
"day17.font.charset=~"0~tif(POS(sel,year+month+String(7-first_day+1,'00'))>0, s_cs, if(POS(dis,year+month+String(7-first_day+1,'00'))>0, b_cs, d_cs))~" " + & 
"day21.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+1,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+1,'00'))>0, b_cs, d_cs))~" " + &
"day22.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+2,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+2,'00'))>0, b_cs, d_cs))~" " + &
"day23.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+3,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+3,'00'))>0, b_cs, d_cs))~" " + &
"day24.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+4,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+4,'00'))>0, b_cs, d_cs))~" " + &
"day25.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+5,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+5,'00'))>0, b_cs, d_cs))~" " + &
"day26.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+6,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+6,'00'))>0, b_cs, d_cs))~" " + &
"day27.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+7,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+7,'00'))>0, b_cs, d_cs))~" " + &
"day31.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+8,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+8,'00'))>0, b_cs, d_cs))~" " + &
"day32.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+9,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+9,'00'))>0, b_cs, d_cs))~" " + &
"day33.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+10,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+10,'00'))>0, b_cs, d_cs))~" " + &
"day34.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+11,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+11,'00'))>0, b_cs, d_cs))~" " + &
"day35.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+12,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+12,'00'))>0, b_cs, d_cs))~" " + &
"day36.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+13,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+13,'00'))>0, b_cs, d_cs))~" " + &
"day37.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+14,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+14,'00'))>0, b_cs, d_cs))~" " + &
"day41.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+15,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+15,'00'))>0, b_cs, d_cs))~" " + &
"day42.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+16,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+16,'00'))>0, b_cs, d_cs))~" " + &
"day43.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+17,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+17,'00'))>0, b_cs, d_cs))~" " + &
"day44.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+18,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+18,'00'))>0, b_cs, d_cs))~" " + &
"day45.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+19,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+19,'00'))>0, b_cs, d_cs))~" " + &
"day46.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+20,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+20,'00'))>0, b_cs, d_cs))~" " + &
"day47.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+21,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+21,'00'))>0, b_cs, d_cs))~" " + &
"day51.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+22,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+22,'00'))>0, b_cs, d_cs))~" " + &
"day52.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+23,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+23,'00'))>0, b_cs, d_cs))~" " + &
"day53.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+24,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+24,'00'))>0, b_cs, d_cs))~" " + &
"day54.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+25,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+25,'00'))>0, b_cs, d_cs))~" " + &
"day55.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+26,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+26,'00'))>0, b_cs, d_cs))~" " + &
"day56.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+27,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+27,'00'))>0, b_cs, d_cs))~" " + &
"day57.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+28,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+28,'00'))>0, b_cs, d_cs))~" " + &
"day61.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+29,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+29,'00'))>0, b_cs, d_cs))~" " + &
"day62.font.charset=~"0~tif(POS(sel,year+month+String((7-first_day+1)+30,'00'))>0, s_cs, if(POS(dis,year+month+String((7-first_day+1)+30,'00'))>0, b_cs, d_cs))~" ")

end subroutine

private subroutine fu_calloadheight ();Modify( + &
"day11.font.height=~"-8~tif(POS(sel,year+month+String(1-first_day+1,'00'))>0, s_size* -1, if(POS(dis,year+month+String(1-first_day+1,'00'))>0, b_size* -1, d_size* - 1))~" " + & 
"day12.font.height=~"-8~tif(POS(sel,year+month+String(2-first_day+1,'00'))>0, s_size* -1, if(POS(dis,year+month+String(2-first_day+1,'00'))>0, b_size* -1, d_size* - 1))~" " + & 
"day13.font.height=~"-8~tif(POS(sel,year+month+String(3-first_day+1,'00'))>0, s_size* -1, if(POS(dis,year+month+String(3-first_day+1,'00'))>0, b_size* -1, d_size* -1))~" " + &
"day14.font.height=~"-8~tif(POS(sel,year+month+String(4-first_day+1,'00'))>0, s_size* -1, if(POS(dis,year+month+String(4-first_day+1,'00'))>0, b_size* -1, d_size* -1))~" " + &
"day15.font.height=~"-8~tif(POS(sel,year+month+String(5-first_day+1,'00'))>0, s_size* -1, if(POS(dis,year+month+String(5-first_day+1,'00'))>0, b_size* -1, d_size* -1))~" " + &
"day16.font.height=~"-8~tif(POS(sel,year+month+String(6-first_day+1,'00'))>0, s_size* -1, if(POS(dis,year+month+String(6-first_day+1,'00'))>0, b_size* -1, d_size* -1))~" " + &
"day17.font.height=~"-8~tif(POS(sel,year+month+String(7-first_day+1,'00'))>0, s_size* -1, if(POS(dis,year+month+String(7-first_day+1,'00'))>0, b_size* -1, d_size* -1))~" " + &
"day21.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+1,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+1,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day22.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+2,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+2,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day23.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+3,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+3,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day24.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+4,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+4,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day25.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+5,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+5,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day26.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+6,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+6,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day27.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+7,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+7,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day31.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+8,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+8,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day32.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+9,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+9,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day33.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+10,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+10,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day34.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+11,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+11,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day35.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+12,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+12,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day36.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+13,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+13,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day37.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+14,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+14,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day41.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+15,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+15,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day42.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+16,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+16,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day43.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+17,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+17,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day44.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+18,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+18,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day45.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+19,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+19,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day46.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+20,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+20,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day47.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+21,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+21,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day51.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+22,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+22,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day52.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+23,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+23,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day53.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+24,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+24,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day54.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+25,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+25,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day55.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+26,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+26,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day56.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+27,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+27,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day57.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+28,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+28,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day61.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+29,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+29,'00'))>0, b_size* -1, d_size* -1))~" " + & 
"day62.font.height=~"-8~tif(POS(sel,year+month+String((7-first_day+1)+30,'00'))>0, s_size* -1, if(POS(dis,year+month+String((7-first_day+1)+30,'00'))>0, b_size* -1, d_size* -1))~" ")

end subroutine

private subroutine fu_calloadweight ();Modify( + &
"day11.font.weight=~"400~tif(POS(sel,year+month+String(1-first_day+1,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String(1-first_day+1,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=1 OR we_day2=1, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &
"day12.font.weight=~"400~tif(POS(sel,year+month+String(2-first_day+1,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String(2-first_day+1,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=2 OR we_day2=2, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &
"day13.font.weight=~"400~tif(POS(sel,year+month+String(3-first_day+1,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String(3-first_day+1,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=3 OR we_day2=3, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &
"day14.font.weight=~"400~tif(POS(sel,year+month+String(4-first_day+1,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String(4-first_day+1,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=4 OR we_day2=4, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &
"day15.font.weight=~"400~tif(POS(sel,year+month+String(5-first_day+1,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String(5-first_day+1,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=5 OR we_day2=5, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &
"day16.font.weight=~"400~tif(POS(sel,year+month+String(6-first_day+1,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String(6-first_day+1,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=6 OR we_day2=6, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &
"day17.font.weight=~"400~tif(POS(sel,year+month+String(7-first_day+1,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String(7-first_day+1,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=7 OR we_day2=7, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &
"day21.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+1,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+1,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=1 OR we_day2=1, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + & 
"day22.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+2,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+2,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=2 OR we_day2=2, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day23.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+3,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+3,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=3 OR we_day2=3, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day24.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+4,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+4,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=4 OR we_day2=4, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day25.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+5,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+5,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=5 OR we_day2=5, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day26.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+6,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+6,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=6 OR we_day2=6, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day27.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+7,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+7,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=7 OR we_day2=7, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day31.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+8,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+8,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=1 OR we_day2=1, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day32.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+9,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+9,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=2 OR we_day2=2, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day33.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+10,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+10,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=3 OR we_day2=3, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day34.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+11,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+11,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=4 OR we_day2=4, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day35.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+12,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+12,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=5 OR we_day2=5, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day36.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+13,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+13,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=6 OR we_day2=6, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day37.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+14,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+14,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=7 OR we_day2=7, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day41.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+15,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+15,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=1 OR we_day2=1, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day42.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+16,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+16,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=2 OR we_day2=2, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day43.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+17,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+17,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=3 OR we_day2=3, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day44.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+18,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+18,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=4 OR we_day2=4, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day45.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+19,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+19,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=5 OR we_day2=5, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day46.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+20,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+20,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=6 OR we_day2=6, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day47.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+21,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+21,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=7 OR we_day2=7, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day51.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+22,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+22,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=1 OR we_day2=1, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day52.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+23,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+23,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=2 OR we_day2=2, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day53.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+24,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+24,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=3 OR we_day2=3, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day54.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+25,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+25,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=4 OR we_day2=4, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day55.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+26,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+26,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=5 OR we_day2=5, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day56.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+27,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+27,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=6 OR we_day2=6, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day57.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+28,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+28,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=7 OR we_day2=7, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day61.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+29,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+29,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=1 OR we_day2=1, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" " + &  
"day62.font.weight=~"400~tif(POS(sel,year+month+String((7-first_day+1)+30,'00'))>0, if(s_sty='regular', s_styv, 400), if(POS(dis,year+month+String((7-first_day+1)+30,'00'))>0, if(b_sty='regular', b_styv, 400), if(we_day1=2 OR we_day2=2, if(we_sty='regular', we_styv, 400), if(wd_sty='regular', wd_styv, 400))))~" ")
end subroutine

private subroutine fu_calloaditalic ();Modify( + &
"day11.font.italic=~"0~tif(POS(sel,year+month+String(1-first_day+1,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String(1-first_day+1,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &
"day12.font.italic=~"0~tif(POS(sel,year+month+String(2-first_day+1,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String(2-first_day+1,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &
"day13.font.italic=~"0~tif(POS(sel,year+month+String(3-first_day+1,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String(3-first_day+1,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &
"day14.font.italic=~"0~tif(POS(sel,year+month+String(4-first_day+1,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String(4-first_day+1,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &
"day15.font.italic=~"0~tif(POS(sel,year+month+String(5-first_day+1,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String(5-first_day+1,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &
"day16.font.italic=~"0~tif(POS(sel,year+month+String(6-first_day+1,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String(6-first_day+1,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &
"day17.font.italic=~"0~tif(POS(sel,year+month+String(7-first_day+1,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String(7-first_day+1,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &
"day21.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+1,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+1,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + & 
"day22.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+2,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+2,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day23.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+3,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+3,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day24.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+4,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+4,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day25.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+5,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+5,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day26.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+6,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+6,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day27.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+7,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+7,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day31.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+8,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+8,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day32.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+9,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+9,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day33.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+10,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+10,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day34.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+11,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+11,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day35.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+12,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+12,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day36.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+13,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+13,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day37.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+14,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+14,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day41.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+15,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+15,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day42.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+16,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+16,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day43.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+17,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+17,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day44.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+18,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+18,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day45.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+19,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+19,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day46.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+20,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+20,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day47.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+21,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+21,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day51.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+22,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+22,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day52.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+23,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+23,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day53.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+24,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+24,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day54.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+25,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+25,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day55.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+26,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+26,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day56.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+27,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+27,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day57.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+28,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+28,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day61.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+29,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+29,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" " + &  
"day62.font.italic=~"0~tif(POS(sel,year+month+String((7-first_day+1)+30,'00'))>0, if(s_sty='italic', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+30,'00'))>0, if(b_sty='italic', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='italic', we_styv, 0), if(wd_sty='italic', wd_styv, 0))))~" ")

end subroutine

private subroutine fu_calloadunder ();Modify( + &
"day11.font.underline=~"0~tif(POS(sel,year+month+String(1-first_day+1,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String(1-first_day+1,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &
"day12.font.underline=~"0~tif(POS(sel,year+month+String(2-first_day+1,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String(2-first_day+1,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &
"day13.font.underline=~"0~tif(POS(sel,year+month+String(3-first_day+1,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String(3-first_day+1,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &
"day14.font.underline=~"0~tif(POS(sel,year+month+String(4-first_day+1,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String(4-first_day+1,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &
"day15.font.underline=~"0~tif(POS(sel,year+month+String(5-first_day+1,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String(5-first_day+1,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &
"day16.font.underline=~"0~tif(POS(sel,year+month+String(6-first_day+1,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String(6-first_day+1,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &
"day17.font.underline=~"0~tif(POS(sel,year+month+String(7-first_day+1,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String(7-first_day+1,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &
"day21.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+1,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+1,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + & 
"day22.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+2,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+2,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day23.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+3,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+3,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day24.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+4,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+4,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day25.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+5,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+5,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day26.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+6,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+6,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day27.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+7,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+7,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day31.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+8,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+8,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day32.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+9,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+9,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day33.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+10,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+10,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day34.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+11,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+11,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day35.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+12,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+12,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day36.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+13,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+13,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day37.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+14,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+14,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day41.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+15,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+15,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day42.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+16,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+16,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day43.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+17,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+17,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day44.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+18,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+18,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day45.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+19,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+19,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day46.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+20,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+20,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day47.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+21,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+21,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day51.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+22,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+22,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day52.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+23,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+23,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day53.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+24,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+24,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=3 or we_day2=3, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day54.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+25,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+25,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=4 or we_day2=4, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day55.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+26,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+26,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=5 or we_day2=5, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day56.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+27,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+27,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=6 or we_day2=6, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day57.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+28,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+28,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=7 or we_day2=7, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day61.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+29,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+29,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=1 or we_day2=1, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" " + &  
"day62.font.underline=~"0~tif(POS(sel,year+month+String((7-first_day+1)+30,'00'))>0, if(s_sty='underline', s_styv, 0), if(POS(dis,year+month+String((7-first_day+1)+30,'00'))>0, if(b_sty='underline', b_styv, 0), if(we_day1=2 or we_day2=2, if(we_sty='underline', we_styv, 0), if(wd_sty='underline', wd_styv, 0))))~" ")

end subroutine

public subroutine fu_ddcalwiredw (datawindow dd_dw, string dd_column, integer percent_width, integer drop_height);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_DDCalWireDW
//  Description   : Wires a drop-down calendar object to a calendar.
//
//  Parameters    : DATAWINDOW dd_dw       - Name of DataWindow that
//                                           contains a column with
//                                           the drop-down.
//                  STRING   dd_column     - Name of the DataWindow 
//                                           column.
//                  INTEGER  percent_width - percent of the drop
//                                           down's width to set for
//                                           the calendar width. 
//                                           Default is 100.
//                  INTEGER  drop_height   - Calendar height.  
//                                           Default is 72% of the 
//                                           width.          
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_DDNum
BOOLEAN l_Found
STRING  l_DWName

l_DWName = dd_dw.ClassName() + "." + dd_column
l_Found  = FALSE

FOR l_Idx = 1 TO i_NumDD
   IF Lower(i_DDName[l_Idx]) = Lower(l_DWName) THEN
      l_Found = TRUE
      l_DDNum = l_Idx
      EXIT
   END IF
NEXT

IF l_Found THEN
   i_DDWidth[l_DDNum]  = Integer(dd_dw.Describe(dd_column + ".Width"))
   i_DDHeight[l_DDNum] = Integer(dd_dw.Describe(dd_column + ".Height"))
   i_DDX[l_DDNum]      = dd_dw.X + Integer(dd_dw.Describe(dd_column + ".X"))
   i_DDY[l_DDNum] = dd_dw.Y + &
                    Integer(dd_dw.Describe("datawindow.header.height")) + &
                    Integer(dd_dw.Describe(dd_column + ".Y"))
   i_DDDetail[l_DDNum] = Integer(dd_dw.Describe("datawindow.detail.height"))

   i_DDCalWidth[l_DDNum]  = percent_width

   i_DDCalHeight[l_DDNum] = drop_height

   Visible                = FALSE
   TabOrder               = 0
ELSE
   i_NumDD = i_NumDD + 1
   i_DDName[i_NumDD]   = l_DWName
   i_NumDDColumns      = i_NumDDColumns + 1
   i_DDType[i_NumDD]   = "COLUMN"
   i_DDIndex[i_NumDD]  = i_NumDDColumns
   i_DDWidth[i_NumDD]  = Integer(dd_dw.Describe(dd_column + ".Width"))
   i_DDHeight[i_NumDD] = Integer(dd_dw.Describe(dd_column + ".Height"))
   i_DDX[i_NumDD]      = dd_dw.X + Integer(dd_dw.Describe(dd_column + ".X"))
   i_DDY[i_NumDD] = dd_dw.Y + &
                    Integer(dd_dw.Describe("datawindow.header.height")) + &
                    Integer(dd_dw.Describe(dd_column + ".Y"))
   i_DDDetail[i_NumDD]    = Integer(dd_dw.Describe("datawindow.detail.height"))

   i_DDCalWidth[i_NumDD]  = percent_width

   i_DDCalHeight[i_NumDD] = drop_height

   i_DDDW[i_NumDDColumns]     = dd_dw
   i_DDColumn[i_NumDDColumns] = dd_column
   i_CalendarDD               = TRUE
   Visible                    = FALSE
   TabOrder                   = 0
   IF i_NumDD = 1 THEN
      TriggerEvent(Resize!)
   END IF
END IF

end subroutine

public function integer fu_ddopen (datawindow dw_name);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_DDOpen
//  Description   : Post the processing of the drop-down calendar
//                  so the drop-down list box is prevented from
//                  showing.  
//
//  Parameters    : DATAWINDOW DW_Name - 
//                     Name of the DataWindow the column is on.
//
//  Return Value  : INTEGER -
//                     0 = Allow the drop-down open event to 
//                         complete.
//                     1 = Prevent the open event from completing.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Column, l_ClickedObject
INTEGER l_Idx

i_CurrentDW = dw_name
THIS.PostEvent("po_DDProcess")

l_ClickedObject = i_CurrentDW.GetObjectAtPointer()

IF l_ClickedObject = "" THEN
	l_Column = i_CurrentDW.ClassName() + "." + i_CurrentDW.GetColumnName()
ELSE
   l_Column = i_CurrentDW.ClassName() + "." + &
              MID(l_ClickedObject, 1, POS(l_ClickedObject, CHAR(9)) - 1)
END IF

//------------------------------------------------------------------
//  Find the DataWindow column to attach the calendar to.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDD
   IF i_DDName[l_Idx] = l_Column THEN
      RETURN 1
   END IF
NEXT

RETURN 0

end function

public subroutine fu_ddcalwire (ref u_dd_calendar dd_object, string dd_format, integer percent_width, integer drop_height);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_DDCalWire
//  Description   : Wires a drop-down calendar object to a calendar.
//
//  Parameters    : U_DD_CALENDAR dd_object- Name of the drop-down
//                                           object.
//                  STRING   dd_format     - Date format to display
//                                           the returned date in
//                                           the drop-down object.
//                  INTEGER  percent_width - percent of the drop
//                                           down's width to set for
//                                           the calendar width. 
//                                           Default is 100.
//                  INTEGER  drop_height   - Calendar height.  
//                                           Default is 72% of the 
//                                           width.          
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1995.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_DDNum
BOOLEAN l_Found

l_Found = FALSE

FOR l_Idx = 1 TO i_NumDD
   IF Lower(i_DDName[l_Idx]) = Lower(dd_object.ClassName()) THEN
      l_Found = TRUE
      l_DDNum = l_Idx
      EXIT
   END IF
NEXT

IF l_Found THEN
   i_DDWidth[l_DDNum]  = dd_object.Width
   i_DDHeight[l_DDNum] = dd_object.Height
   i_DDX[l_DDNum]      = dd_object.X
   i_DDY[l_DDNum]      = dd_object.Y

   IF percent_width > c_DefaultDDWidth THEN
      i_DDCalWidth[l_DDNum]  = Int(i_DDWidth[l_DDNum] * &
                                   (percent_width/100))
   ELSE
      i_DDCalWidth[l_DDNum]  = i_DDWidth[l_DDNum]
   END IF

   IF drop_height > c_DefaultDDHeight THEN
      i_DDCalHeight[l_DDNum] = drop_height
   ELSE
      i_DDCalHeight[l_DDNum] = Int(i_DDCalWidth[l_DDNum] * .72)
   END IF

   i_DDFormat[i_DDIndex[l_DDNum]] = dd_format
   Visible                        = FALSE
   TabOrder                       = 0
ELSE
   i_NumDD = i_NumDD + 1
   i_DDName[i_NumDD]   = dd_object.ClassName()
   i_NumDDObjects      = i_NumDDObjects + 1
   i_DDType[i_NumDD]   = "OBJECT"
   i_DDIndex[i_NumDD]  = i_NumDDObjects
   i_DDWidth[i_NumDD]  = dd_object.Width
   i_DDHeight[i_NumDD] = dd_object.Height
   i_DDX[i_NumDD]      = dd_object.X
   i_DDY[i_NumDD]      = dd_object.Y
   i_DDDetail[i_NumDD]  = 0

   IF percent_width > c_DefaultDDWidth THEN
      i_DDCalWidth[i_NumDD]  = Int(i_DDWidth[i_NumDD] * &
                                   (percent_width/100))
   ELSE
      i_DDCalWidth[i_NumDD]  = i_DDWidth[i_NumDD]
   END IF

   IF drop_height > c_DefaultDDHeight THEN
      i_DDCalHeight[i_NumDD] = drop_height
   ELSE
      i_DDCalHeight[i_NumDD] = Int(i_DDCalWidth[i_NumDD] * .72)
   END IF

   i_DDObject[i_NumDDObjects] = dd_object
   i_DDFormat[i_NumDDObjects] = dd_format
   dd_object.i_Calendar       = THIS
   dd_object.i_ObjectIndex    = i_NumDDObjects
   dd_object.i_DDIndex        = i_NumDD
   i_CalendarDD               = TRUE
   Visible                    = FALSE
   TabOrder                   = 0
   IF i_NumDD = 1 THEN
      TriggerEvent(Resize!)
   END IF
END IF

end subroutine

public subroutine fu_ddkeydown ();//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_DDKeyDown
//  Description   : Displays the calendar using ALT-DownArrow and
//                  hides the calendar using ALT-UpArrow.  
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF i_CalendarDD THEN
   IF i_CalendarDDType = "OBJECT" THEN
      IF NOT Visible THEN
         IF GetFocus() = i_DDObject[i_DDIndex[i_CalendarDDIndex]] THEN
            IF KeyDown(keyDownArrow!) THEN
               i_DDObject[i_DDIndex[i_CalendarDDIndex]].PostEvent("po_DDProcess")
            END IF
         END IF
      ELSE
         IF GetFocus() = THIS THEN
            IF KeyDown(keyUpArrow!) THEN
               Visible  = FALSE
               TabOrder = 0
               i_DDObject[i_DDIndex[i_CalendarDDIndex]].i_DDClosed = FALSE
               THIS.PostEvent("po_DDFocus")
            END IF
         END IF
      END IF
   ELSE
      IF Visible THEN
         IF KeyDown(keyUpArrow!) THEN
            Visible  = FALSE
            TabOrder = 0
            THIS.PostEvent("po_DDFocus")
         END IF
      END IF
   END IF
END IF

end subroutine

public function double fu_ddfindxpos (string dw_column);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_DDFindXPos
//  Description   : Finds the X position for the given column when
//                  the DataWindow has a horizontal scroll bar.  
//
//  Parameters    : STRING DW_Column - 
//                     Name of the DataWindow column to position 
//                     the calendar under.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Pos
DOUBLE  l_ScrollMax, l_ScrollPos, l_ColumnX, l_VScrollWidth
DOUBLE  l_X, l_MaxScrollWidth, l_VisibleWidth, l_ScrollWidth
DOUBLE  l_Scrolled
STRING  l_Objects, l_Object, l_Type

l_Objects   = i_CurrentDW.Describe("datawindow.objects")
l_ScrollMax = Double(i_CurrentDW.Describe("datawindow.horizontalscrollmaximum"))
l_ScrollPos = Double(i_CurrentDW.Describe("datawindow.horizontalscrollposition"))
l_ColumnX   = Double(i_CurrentDW.Describe(dw_column + ".X"))

IF i_CurrentDW.VScrollBar THEN
   l_VScrollWidth = PixelsToUnits(16, XPixelsToUnits!)
END IF

l_MaxScrollWidth = 0
DO
   l_Pos = Pos(l_Objects, "~t")
   IF l_Pos > 0 THEN
      l_Object = MID(l_Objects, 1, l_Pos - 1)
      l_Objects = MID(l_Objects, l_Pos + 1)
   ELSE
      l_Object = l_Objects
      l_Objects = ""
   END IF
   IF Len(l_Object) > 0 THEN
      l_Type = i_CurrentDW.Describe(l_Object + ".Type")
      IF UPPER(l_Type) <> "LINE" THEN
         l_X = Double(i_CurrentDW.Describe(l_Object + ".X")) + &
               Double(i_CurrentDW.Describe(l_Object + ".Width"))
      ELSE
         l_X = Double(i_CurrentDW.Describe(l_Object + ".X2"))         
      END IF
      IF l_X > l_MaxScrollWidth THEN
         l_MaxScrollWidth = l_X
      END IF
   END IF
LOOP UNTIL l_Objects = ""

l_VisibleWidth = i_CurrentDW.Width - l_VScrollWidth
l_ScrollWidth  = l_MaxScrollWidth - l_VisibleWidth

l_Scrolled = (l_ScrollPos * l_ScrollWidth) / l_ScrollMax

RETURN i_CurrentDW.X + l_ColumnX - l_Scrolled
end function

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_Calendar
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

public function integer fu_calsetmonth (integer month);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalSetMonth
//  Description   : Sets the given month as current.  
//
//  Parameters    : INTEGER Month -
//                     Month to set current.
//
//  Return Value  : INTEGER - 
//                      0 = OK.
//                     -1 = validation failed.
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
//  Validate the month.
//------------------------------------------------------------------

IF month < 1 OR month > 12 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Validate the current month and year before moving to the new
//  month and year.
//------------------------------------------------------------------

i_CalendarError = c_ValOK
i_ClickedMonth  = month

Event po_MonthValidate(i_ClickedMonth, i_SelectedMonth)

IF i_CalendarError = c_ValFailed THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Set the new month and year.
//------------------------------------------------------------------

SetRedraw(FALSE)

i_SelectedMonth = month

SetItem(1, "first_day", DayNumber(Date(i_SelectedYear, &
        i_SelectedMonth, 1)))
IF i_SelectedMonth = 2 AND Mod(i_SelectedYear - 1900, 4) = 0 THEN
   SetItem(1, "last_day", i_MonthDays[i_SelectedMonth] + 1)
ELSE
   SetItem(1, "last_day", i_MonthDays[i_SelectedMonth])
END IF
SetItem(1, "month", String(i_SelectedMonth, '00'))
Modify("month.text='" + &
       String(Date(i_SelectedYear, i_SelectedMonth, 1), "mmmm") + &
       "'")

Event po_MonthChanged(i_SelectedMonth)

SetRedraw(TRUE)

RETURN 0
end function

protected subroutine fu_calsetoptions (string optionstyle, string options);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalSetOptions
//  Description   : Sets visual defaults and options.  This function
//                  is used by all the option functions (i.e.
//                  fu_CalOptions).  It is also called by the
//                  constructor event to set initial defaults.  
//
//  Parameters    : STRING OptionStyle - 
//                     Indicates which function is the calling 
//                     routine.
//                  STRING Options - 
//                     Visual options.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE OptionStyle

   //---------------------------------------------------------------
   //  Set the calendar options and defaults.
   //---------------------------------------------------------------

   CASE "General"
		
      //------------------------------------------------------------
      //  Weekday background color.
      //------------------------------------------------------------
		
		IF Pos(Options, c_CalBlack) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_Black)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_Black)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_Black)
		ELSEIF Pos(Options, c_CalWhite) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_White)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_White)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_White)
		ELSEIF Pos(Options, c_CalGray) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_Gray)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkGray)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkGray)
		ELSEIF Pos(Options, c_CalDarkGray) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_DarkGray)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkGray)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkGray)
		ELSEIF Pos(Options, c_CalRed) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_Red)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkRed)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkRed)
		ELSEIF Pos(Options, c_CalDarkRed) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_DarkRed)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkRed)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkRed)
		ELSEIF Pos(Options, c_CalGreen) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_Green)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkGreen)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkGreen)
		ELSEIF Pos(Options, c_CalDarkGreen) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_DarkGreen)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkGreen)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkGreen)
		ELSEIF Pos(Options, c_CalBlue) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_Blue)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkBlue)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkBlue)
		ELSEIF Pos(Options, c_CalDarkBlue) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_DarkBlue)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkBlue)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkBlue)
		ELSEIF Pos(Options, c_CalMagenta) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_Magenta)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkMagenta)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkMagenta)
		ELSEIF Pos(Options, c_CalDarkMagenta) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_DarkMagenta)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_White)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkMagenta)
		ELSEIF Pos(Options, c_CalCyan) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_Cyan)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkCyan)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkCyan)
		ELSEIF Pos(Options, c_CalDarkCyan) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_DarkCyan)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkCyan)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkCyan)
		ELSEIF Pos(Options, c_CalYellow) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_Yellow)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkYellow)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkYellow)
		ELSEIF Pos(Options, c_CalDarkYellow) > 0 THEN
			i_WDBGColorSet = TRUE
         SetItem(1, "wd_bg_c", OBJCA.MGR.c_DarkYellow)
         SetItem(1, "cal_shade_c", OBJCA.MGR.c_DarkYellow)
         SetItem(1, "cal_save_shade_c", OBJCA.MGR.c_DarkYellow)
		END IF
		
      //------------------------------------------------------------
      //  Weekend background color.
      //------------------------------------------------------------

		IF Pos(Options, c_CalWEBlack) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_Black)
		ELSEIF Pos(Options, c_CalWEWhite) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_White)
		ELSEIF Pos(Options, c_CalWEGray) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_Gray)
		ELSEIF Pos(Options, c_CalWEDarkGray) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_DarkGray)
		ELSEIF Pos(Options, c_CalWERed) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_Red)
		ELSEIF Pos(Options, c_CalWEDarkRed) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_DarkRed)
		ELSEIF Pos(Options, c_CalWEGreen) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_Green)
		ELSEIF Pos(Options, c_CalWEDarkGreen) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_DarkGreen)
		ELSEIF Pos(Options, c_CalWEBlue) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_Blue)
		ELSEIF Pos(Options, c_CalWEDarkBlue) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_DarkBlue)
		ELSEIF Pos(Options, c_CalWEMagenta) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_Magenta)
		ELSEIF Pos(Options, c_CalWEDarkMagenta) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_DarkMagenta)
		ELSEIF Pos(Options, c_CalWECyan) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_Cyan)
		ELSEIF Pos(Options, c_CalWEDarkCyan) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_DarkCyan)
		ELSEIF Pos(Options, c_CalWEYellow) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_Yellow)
		ELSEIF Pos(Options, c_CalWEDarkYellow) > 0 THEN
			i_WEBGColorSet = TRUE
         SetItem(1, "we_bg_c", OBJCA.MGR.c_DarkYellow)
		END IF
  
      //------------------------------------------------------------
      //  Day sort direction.
      //------------------------------------------------------------

      IF Pos(Options, c_CalSortAsc) > 0 THEN
			i_CalendarSort = "A"
		ELSEIF Pos(Options, c_CalSortDesc) > 0 THEN
			i_CalendarSort = "D"
		ELSEIF Pos(Options, c_CalNoSort) > 0 THEN
			i_CalendarSort = "N"
		END IF
  
      //------------------------------------------------------------
      //  Calendar style.
      //------------------------------------------------------------
      
		IF Pos(Options, c_CalStyle3D) > 0 THEN
			i_CalStyleSet = TRUE
         SetItem(1, "cal_sty", "3D")
         SetItem(1, "cal_shade_c", GetItemNumber(1, "cal_save_shade_c"))
         SetItem(1, "cal_solid_c", GetItemNumber(1, "cal_save_solid_c"))
		ELSEIF Pos(Options, c_CalStyle2D) > 0 THEN
			i_CalStyleSet = TRUE
         SetItem(1, "cal_sty", "2D")
         SetItem(1, "cal_shade_c", GetItemNumber(1, "wd_bg_c"))
         SetItem(1, "cal_solid_c", GetItemNumber(1, "wd_bg_c"))
      END IF

   //------------------------------------------------------------------
   //  Set the heading options and defaults.
   //------------------------------------------------------------------

   CASE "Heading"

      //---------------------------------------------------------------
      //  Heading style.
      //---------------------------------------------------------------

      IF Pos(Options, c_CalHeadingAuto) > 0 THEN
         SetItem(1, "h_len", 0)
      ELSEIF Pos(Options, c_CalHeading1) > 0 THEN
         SetItem(1, "h_len", 1)
      ELSEIF Pos(Options, c_CalHeading2) > 0 THEN
         SetItem(1, "h_len", 2)
      ELSEIF Pos(Options, c_CalHeading3) > 0 THEN
         SetItem(1, "h_len", 3)
      ELSEIF Pos(Options, c_CalHeadingFull) > 0 THEN
         SetItem(1, "h_len", 4)
		END IF
		
      //---------------------------------------------------------------
      //  Heading text style.
      //---------------------------------------------------------------

      IF Pos(Options, c_CalHeadingRegular) > 0 THEN
         SetItem(1, "h_sty", "regular")
         SetItem(1, "h_styv", 400) 
      ELSEIF Pos(Options, c_CalHeadingBold) > 0 THEN
         SetItem(1, "h_sty", "bold")
         SetItem(1, "h_styv", 700) 
      ELSEIF Pos(Options, c_CalHeadingItalic) > 0 THEN
         SetItem(1, "h_sty", "italic")
         SetItem(1, "h_styv", 1) 
      ELSEIF Pos(Options, c_CalHeadingUnderline) > 0 THEN
         SetItem(1, "h_sty", "underline")
         SetItem(1, "h_styv", 1) 
      END IF
		
      //---------------------------------------------------------------
      //  Heading text alignment.
      //---------------------------------------------------------------

      IF Pos(Options, c_CalHeadingCenter) > 0 THEN
         SetItem(1, "h_align", 2)
      ELSEIF Pos(Options, c_CalHeadingLeft) > 0 THEN
         SetItem(1, "h_align", 0)
      ELSEIF Pos(Options, c_CalHeadingRight) > 0 THEN
         SetItem(1, "h_align", 1)
      END IF
		
      //---------------------------------------------------------------
      //  Heading text color.
      //---------------------------------------------------------------
 
      IF Pos(Options, c_CalHeadingBlack) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_Black)
		ELSEIF Pos(Options, c_CalHeadingWhite) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_White)
		ELSEIF Pos(Options, c_CalHeadingGray) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_Gray)
		ELSEIF Pos(Options, c_CalHeadingDarkGray) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_DarkGray)
		ELSEIF Pos(Options, c_CalHeadingRed) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_Red)
		ELSEIF Pos(Options, c_CalHeadingDarkRed) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_DarkRed)
		ELSEIF Pos(Options, c_CalHeadingGreen) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_Green)
		ELSEIF Pos(Options, c_CalHeadingDarkGreen) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_DarkGreen)
		ELSEIF Pos(Options, c_CalHeadingBlue) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_Blue)
		ELSEIF Pos(Options, c_CalHeadingDarkBlue) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_DarkBlue)
		ELSEIF Pos(Options, c_CalHeadingMagenta) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_Magenta)
		ELSEIF Pos(Options, c_CalHeadingDarkMagenta) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_DarkMagenta)
		ELSEIF Pos(Options, c_CalHeadingCyan) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_Cyan)
		ELSEIF Pos(Options, c_CalHeadingDarkCyan) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_DarkCyan)
		ELSEIF Pos(Options, c_CalHeadingYellow) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_Yellow)
		ELSEIF Pos(Options, c_CalHeadingDarkYellow) > 0 THEN
         i_HeadColorSet = TRUE
         SetItem(1, "h_c", OBJCA.MGR.c_DarkYellow)
		END IF

   //---------------------------------------------------------------
   //  Set the day options and defaults.
   //---------------------------------------------------------------

   CASE "Day"
		
      //------------------------------------------------------------
      //  Day text alignment.
      //------------------------------------------------------------

      IF Pos(Options, c_CalDayCenter) > 0 THEN
         SetItem(1, "d_align", 2)
      ELSEIF Pos(Options, c_CalDayLeft) > 0 THEN
         SetItem(1, "d_align", 0)
      ELSEIF Pos(Options, c_CalDayRight) > 0 THEN
         SetItem(1, "d_align", 1)
      END IF
		
      //------------------------------------------------------------
      //  Day text style.
      //------------------------------------------------------------

      IF Pos(Options, c_CalDayRegular) > 0 THEN
         SetItem(1, "wd_sty", "regular")
         SetItem(1, "wd_styv", 400) 
      ELSEIF Pos(Options, c_CalDayBold) > 0 THEN
         SetItem(1, "wd_sty", "regular")
         SetItem(1, "wd_styv", 700) 
      ELSEIF Pos(Options, c_CalDayItalic) > 0 THEN
         SetItem(1, "wd_sty", "italic")
         SetItem(1, "wd_styv", 1) 
      ELSEIF Pos(Options, c_CalDayUnderline) > 0 THEN
         SetItem(1, "wd_sty", "underline")
         SetItem(1, "wd_styv", 1) 
      END IF
		
      //------------------------------------------------------------
      //  Day text color.
      //------------------------------------------------------------

      IF Pos(Options, c_CalDayBlack) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_CalDayWhite) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_CalDayGray) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_CalDayDarkGray) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_CalDayRed) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_CalDayDarkRed) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_CalDayGreen) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_CalDayDarkGreen) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_CalDayBlue) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_CalDayDarkBlue) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_CalDayMagenta) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_CalDayDarkMagenta) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_CalDayCyan) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_CalDayDarkCyan) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_CalDayYellow) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_CalDayDarkYellow) > 0 THEN
         i_WDColorSet = TRUE
         SetItem(1, "wd_c", OBJCA.MGR.c_DarkYellow)
		END IF
			
      //------------------------------------------------------------
      //  Weekend day text style.
      //------------------------------------------------------------
 
      IF Pos(Options, c_CalWEDayRegular) > 0 THEN
         SetItem(1, "we_sty", "regular")
         SetItem(1, "we_styv", 400) 
      ELSEIF Pos(Options, c_CalWEDayBold) > 0 THEN
         SetItem(1, "we_sty", "regular")
         SetItem(1, "we_styv", 700) 
      ELSEIF Pos(Options, c_CalWEDayItalic) > 0 THEN
         SetItem(1, "we_sty", "italic")
         SetItem(1, "we_styv", 1) 
      ELSEIF Pos(Options, c_CalWEDayUnderline) > 0 THEN
         SetItem(1, "we_sty", "underline")
         SetItem(1, "we_styv", 1) 
      END IF
		
      //------------------------------------------------------------
      //  Weekend day text color.
      //------------------------------------------------------------

      IF Pos(Options, c_CalWEDayBlack) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_CalWEDayWhite) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_CalWEDayGray) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_CalWEDayDarkGray) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_CalWEDayRed) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_CalWEDayDarkRed) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_CalWEDayGreen) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_CalWEDayDarkGreen) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_CalWEDayBlue) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_CalWEDayDarkBlue) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_CalWEDayMagenta) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_CalWEDayDarkMagenta) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_CalWEDayCyan) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_CalWEDayDarkCyan) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_CalWEDayYellow) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_CalWEDayDarkYellow) > 0 THEN
         i_WEColorSet = TRUE
         SetItem(1, "we_c", OBJCA.MGR.c_DarkYellow)
		END IF

END CHOOSE
end subroutine

public subroutine fu_caldayoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalDayOptions
//  Description   : Establishes the look-and-feel of the day 
//                  portion of the calendar object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the day portion.
//
//  Return Value  : (None)
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
//  Set the font style of the text for the day.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   i_WDFontSet = TRUE
   SetItem(1, "d_font", TextFont)
   CHOOSE CASE UPPER(TextFont)
      CASE "ARIAL"
         SetItem(1, "d_f", 2)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", 0)
      CASE "COURIER", "COURIER NEW"
         SetItem(1, "d_f", 1)
         SetItem(1, "d_p", 1)
         SetItem(1, "d_cs", 0)
      CASE "MODERN"
         SetItem(1, "d_f", 1)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", -1)
      CASE "MS SANS SERIF"
         SetItem(1, "d_f", 2)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", 0)
      CASE "MS SERIF"
         SetItem(1, "d_f", 1)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", 0)
      CASE "ROMAN"
         SetItem(1, "d_f", 1)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", -1)
      CASE "SCRIPT"
         SetItem(1, "d_f", 4)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", -1)
      CASE "SMALL FONTS"
         SetItem(1, "d_f", 2)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", 0)
      CASE "SYSTEM"
         SetItem(1, "d_f", 2)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", 0)
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         SetItem(1, "d_f", 1)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", 0)
      CASE "MS LINEDRAW"
         SetItem(1, "d_f", 1)
         SetItem(1, "d_p", 1)
         SetItem(1, "d_cs", 2)
      CASE "TERMINAL"
         SetItem(1, "d_f", 1)
         SetItem(1, "d_p", 1)
         SetItem(1, "d_cs", -1)
      CASE "CENTURY SCHOOLBOOK"
         SetItem(1, "d_f", 1)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", 0)
      CASE "CENTURY GOTHIC"
         SetItem(1, "d_f", 2)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", 0)
      CASE ELSE
         SetItem(1, "d_f", 2)
         SetItem(1, "d_p", 2)
         SetItem(1, "d_cs", 0)
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Set the font size of the day.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   i_WDSizeSet = TRUE
   SetItem(1, "d_size", TextSize)
END IF

//------------------------------------------------------------------
//  Set the visual options.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_CalSetOptions("Day", Options)
END IF

end subroutine

public subroutine fu_calheadingoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalHeadingOptions
//  Description   : Establishes the look-and-feel of the day heading
//                  portion of the calendar object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the heading.
//
//  Return Value  : (None)
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
//  Set the font style of the text for the heading.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   i_HeadFontSet = TRUE
   SetItem(1, "h_font", TextFont)
   CHOOSE CASE UPPER(TextFont)
      CASE "ARIAL"
         SetItem(1, "h_f", 2)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", 0)
      CASE "COURIER", "COURIER NEW"
         SetItem(1, "h_f", 1)
         SetItem(1, "h_p", 1)
         SetItem(1, "h_cs", 0)
      CASE "MODERN"
         SetItem(1, "h_f", 1)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", -1)
      CASE "MS SANS SERIF"
         SetItem(1, "h_f", 2)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", 0)
      CASE "MS SERIF"
         SetItem(1, "h_f", 1)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", 0)
      CASE "ROMAN"
         SetItem(1, "h_f", 1)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", -1)
      CASE "SCRIPT"
         SetItem(1, "h_f", 4)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", -1)
      CASE "SMALL FONTS"
         SetItem(1, "h_f", 2)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", 0)
      CASE "SYSTEM"
         SetItem(1, "h_f", 2)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", 0)
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         SetItem(1, "h_f", 1)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", 0)
      CASE "MS LINEDRAW"
         SetItem(1, "h_f", 1)
         SetItem(1, "h_p", 1)
         SetItem(1, "h_cs", 2)
      CASE "TERMINAL"
         SetItem(1, "h_f", 1)
         SetItem(1, "h_p", 1)
         SetItem(1, "h_cs", -1)
      CASE "CENTURY SCHOOLBOOK"
         SetItem(1, "h_f", 1)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", 0)
      CASE "CENTURY GOTHIC"
         SetItem(1, "h_f", 2)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", 0)
      CASE ELSE
         SetItem(1, "h_f", 2)
         SetItem(1, "h_p", 2)
         SetItem(1, "h_cs", 0)
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Set the font size of the heading.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   i_HeadSizeSet = TRUE
   SetItem(1, "h_size", TextSize)
   i_HeadingSize = TextSize
END IF

//------------------------------------------------------------------
//  Set the visual options.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_CalSetOptions("Heading", Options)
END IF

end subroutine

public subroutine fu_caloptions (string options);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalOptions
//  Description   : Establishes the look-and-feel of the calendar
//                  portion of the calendar object.  
//
//  Parameters    : STRING Options - 
//                     Visual options for the calendar.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF Options <> c_DefaultVisual THEN
   fu_CalSetOptions("General", Options)
END IF

end subroutine

protected subroutine fu_calsetnextoptions (string optionstyle, string options);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalSetNextOptions
//  Description   : Sets visual defaults and options.  This function
//                  is used by all the option functions (i.e.
//                  fu_CalOptions).  It is also called by the
//                  constructor event to set initial defaults.  
//
//  Parameters    : STRING OptionStyle - 
//                     Indicates which function is the calling 
//                     routine.
//                  STRING Options - 
//                     Visual options.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE OptionStyle

   //---------------------------------------------------------------
   //  Set the selected day options and defaults.
   //---------------------------------------------------------------

   CASE "Select"
		
      //------------------------------------------------------------
      //  Selected day text style.
      //------------------------------------------------------------
 
      IF Pos(Options, c_CalSelectRegular) > 0 THEN
         SetItem(1, "s_sty", "regular")
         SetItem(1, "s_styv", 400) 
      ELSEIF Pos(Options, c_CalSelectBold) > 0 THEN
         SetItem(1, "s_sty", "regular")
         SetItem(1, "s_styv", 700) 
         IF NOT i_WeightExprLoaded THEN
            THIS.fu_CalLoadWeight()
            i_WeightExprLoaded = TRUE
         END IF
      ELSEIF Pos(Options, c_CalSelectItalic) > 0 THEN
         SetItem(1, "s_sty", "italic")
         SetItem(1, "s_styv", 1) 
         IF NOT i_ItalicExprLoaded THEN
            THIS.fu_CalLoadItalic()
            i_ItalicExprLoaded = TRUE
         END IF
      ELSEIF Pos(Options, c_CalSelectUnderline) > 0 THEN
         SetItem(1, "s_sty", "underline")
         SetItem(1, "s_styv", 1) 
         IF NOT i_UnderExprLoaded THEN
            THIS.fu_CalLoadUnder()
            i_UnderExprLoaded = TRUE
         END IF
      END IF
		
      //------------------------------------------------------------
      //  Selected day text color.
      //------------------------------------------------------------
 
      IF Pos(Options, c_CalSelectBlack) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_CalSelectWhite) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_CalSelectGray) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_CalSelectDarkGray) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_CalSelectRed) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_CalSelectDarkRed) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_CalSelectGreen) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_CalSelectDarkGreen) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_CalSelectBlue) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_CalSelectDarkBlue) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_CalSelectMagenta) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_CalSelectDarkMagenta) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_CalSelectCyan) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_CalSelectDarkCyan) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_CalSelectYellow) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_CalSelectDarkYellow) > 0 THEN
         i_SelColorSet = TRUE
         SetItem(1, "s_c", OBJCA.MGR.c_DarkYellow)
		END IF
		
      //------------------------------------------------------------
      //  Selected day background color.
      //------------------------------------------------------------
 
      IF Pos(Options, c_CalSelectBGBlack) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_CalSelectBGWhite) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_CalSelectBGGray) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_CalSelectBGDarkGray) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_CalSelectBGRed) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_CalSelectBGDarkRed) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_CalSelectBGGreen) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_CalSelectBGDarkGreen) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_CalSelectBGBlue) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_CalSelectBGDarkBlue) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_CalSelectBGMagenta) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_CalSelectBGDarkMagenta) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_CalSelectBGCyan) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_CalSelectBGDarkCyan) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_CalSelectBGYellow) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_CalSelectBGDarkYellow) > 0 THEN
         i_SelBGColorSet = TRUE
         SetItem(1, "s_bg_c", OBJCA.MGR.c_DarkYellow)
		END IF

   //------------------------------------------------------------------
   //  Set the disabled day options and defaults.
   //------------------------------------------------------------------

   CASE "Disable"
		
      //------------------------------------------------------------
      //  Disabled day text style.
      //------------------------------------------------------------
 
      IF Pos(Options, c_CalDisableRegular) > 0 THEN
         SetItem(1, "b_sty", "regular")
         SetItem(1, "b_styv", 400) 
      ELSEIF Pos(Options, c_CalDisableBold) > 0 THEN
         SetItem(1, "b_sty", "regular")
         SetItem(1, "b_styv", 700) 
         IF NOT i_WeightExprLoaded THEN
            THIS.fu_CalLoadWeight()
            i_WeightExprLoaded = TRUE
         END IF
      ELSEIF Pos(Options, c_CalDisableItalic) > 0 THEN
         SetItem(1, "b_sty", "italic")
         SetItem(1, "b_styv", 1) 
         IF NOT i_ItalicExprLoaded THEN
            THIS.fu_CalLoadItalic()
            i_ItalicExprLoaded = TRUE
         END IF
      ELSEIF Pos(Options, c_CalDisableUnderline) > 0 THEN
         SetItem(1, "b_sty", "underline")
         SetItem(1, "b_styv", 1) 
         IF NOT i_UnderExprLoaded THEN
            THIS.fu_CalLoadUnder()
            i_UnderExprLoaded = TRUE
         END IF
      END IF
		
      //------------------------------------------------------------
      //  Disabled day text color.
      //------------------------------------------------------------
 
      IF Pos(Options, c_CalDisableBlack) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_CalDisableWhite) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_CalDisableGray) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_CalDisableDarkGray) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_CalDisableRed) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_CalDisableDarkRed) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_CalDisableGreen) > 0 THEN
			i_DisColorSet = TRUE
			SetItem(1, "b_c", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_CalDisableDarkGreen) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_CalDisableBlue) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_CalDisableDarkBlue) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_CalDisableMagenta) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_CalDisableDarkMagenta) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_CalDisableCyan) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_CalDisableDarkCyan) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_CalDisableYellow) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_CalDisableDarkYellow) > 0 THEN
         i_DisColorSet = TRUE
         SetItem(1, "b_c", OBJCA.MGR.c_DarkYellow)
		END IF
		
      //------------------------------------------------------------
      //  Disabled day background color.
      //------------------------------------------------------------
 
      IF Pos(Options, c_CalDisableBGBlack) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_CalDisableBGWhite) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_CalDisableBGGray) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_CalDisableBGDarkGray) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_CalDisableBGRed) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_CalDisableBGDarkRed) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_CalDisableBGGreen) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_CalDisableBGDarkGreen) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_CalDisableBGBlue) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_CalDisableBGDarkBlue) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_CalDisableBGMagenta) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_CalDisableBGDarkMagenta) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_CalDisableBGCyan) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_CalDisableBGDarkCyan) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_CalDisableBGYellow) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_CalDisableBGDarkYellow) > 0 THEN
         i_DisBGColorSet = TRUE
         SetItem(1, "b_bg_c", OBJCA.MGR.c_DarkYellow)
		END IF

   //---------------------------------------------------------------
   //  Set the month options and defaults.
   //---------------------------------------------------------------

   CASE "Month"
		
      //------------------------------------------------------------
      //  Month text style.
      //------------------------------------------------------------

      IF Pos(Options, c_CalMonthRegular) > 0 THEN
         SetItem(1, "m_sty", "regular")
         SetItem(1, "m_styv", 400) 
      ELSEIF Pos(Options, c_CalMonthBold) > 0 THEN
         SetItem(1, "m_sty", "regular")
         SetItem(1, "m_styv", 700) 
      ELSEIF Pos(Options, c_CalMonthItalic) > 0 THEN
         SetItem(1, "m_sty", "italic")
         SetItem(1, "m_styv", 1) 
      ELSEIF Pos(Options, c_CalMonthUnderline) > 0 THEN
         SetItem(1, "m_sty", "underline")
         SetItem(1, "m_styv", 1) 
      END IF
		
      //------------------------------------------------------------
      //  Month text color.
      //------------------------------------------------------------
 
      IF Pos(Options, c_CalMonthBlack) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_CalMonthWhite) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_CalMonthGray) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_CalMonthDarkGray) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_CalMonthRed) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_CalMonthDarkRed) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_CalMonthGreen) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_CalMonthDarkGreen) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_CalMonthBlue) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_CalMonthDarkBlue) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_CalMonthMagenta) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_CalMonthDarkMagenta) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_CalMonthCyan) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_CalMonthDarkCyan) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_CalMonthYellow) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_CalMonthDarkYellow) > 0 THEN
         i_MonthColorSet = TRUE
         SetItem(1, "m_c", OBJCA.MGR.c_DarkYellow)
		END IF

   //------------------------------------------------------------------
   //  Set the year options and defaults.
   //------------------------------------------------------------------

   CASE "Year"
		
      //------------------------------------------------------------
      //  Year visible.
      //------------------------------------------------------------
		
      IF Pos(Options, c_CalYearShow) > 0 THEN
         SetItem(1, "y_show", 1)
      ELSEIF Pos(Options, c_CalYearHide) > 0 THEN
         SetItem(1, "y_show", 0)
      END IF
		
      //------------------------------------------------------------
      //  Year text style.
      //------------------------------------------------------------

      IF Pos(Options, c_CalYearRegular) > 0 THEN
         SetItem(1, "y_sty", "regular")
         SetItem(1, "y_styv", 400) 
      ELSEIF Pos(Options, c_CalYearBold) > 0 THEN
         SetItem(1, "y_sty", "regular")
         SetItem(1, "y_styv", 700) 
      ELSEIF Pos(Options, c_CalYearItalic) > 0 THEN
         SetItem(1, "y_sty", "italic")
         SetItem(1, "y_styv", 1) 
      ELSEIF Pos(Options, c_CalYearUnderline) > 0 THEN
         SetItem(1, "y_sty", "underline")
         SetItem(1, "y_styv", 1) 
      END IF
		
      //------------------------------------------------------------
      //  Year text color.
      //------------------------------------------------------------
 
      IF Pos(Options, c_CalYearBlack) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_Black)
      ELSEIF Pos(Options, c_CalYearWhite) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_White)
      ELSEIF Pos(Options, c_CalYearGray) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_Gray)
      ELSEIF Pos(Options, c_CalYearDarkGray) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_DarkGray)
      ELSEIF Pos(Options, c_CalYearRed) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_Red)
      ELSEIF Pos(Options, c_CalYearDarkRed) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_DarkRed)
      ELSEIF Pos(Options, c_CalYearGreen) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_Green)
      ELSEIF Pos(Options, c_CalYearDarkGreen) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_DarkGreen)
      ELSEIF Pos(Options, c_CalYearBlue) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_Blue)
      ELSEIF Pos(Options, c_CalYearDarkBlue) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_DarkBlue)
      ELSEIF Pos(Options, c_CalYearMagenta) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_Magenta)
      ELSEIF Pos(Options, c_CalYearDarkMagenta) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_DarkMagenta)
      ELSEIF Pos(Options, c_CalYearCyan) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_Cyan)
      ELSEIF Pos(Options, c_CalYearDarkCyan) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_DarkCyan)
      ELSEIF Pos(Options, c_CalYearYellow) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_Yellow)
      ELSEIF Pos(Options, c_CalYearDarkYellow) > 0 THEN
         i_YearColorSet = TRUE
         SetItem(1, "y_c", OBJCA.MGR.c_DarkYellow)
		END IF

END CHOOSE
end subroutine

public subroutine fu_caldisableoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalDisableOptions
//  Description   : Establishes the look-and-feel of the disabled
//                  day portion of the calendar object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the disabled days.
//
//  Return Value  : (None)
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
//  Set the font style of the text for the disabled day.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   i_DisFontSet = TRUE
   SetItem(1, "b_font", TextFont)
   CHOOSE CASE UPPER(TextFont)
      CASE "ARIAL"
         SetItem(1, "b_f", 2)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", 0)
      CASE "COURIER", "COURIER NEW"
         SetItem(1, "b_f", 1)
         SetItem(1, "b_p", 1)
         SetItem(1, "b_cs", 0)
      CASE "MODERN"
         SetItem(1, "b_f", 1)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", -1)
      CASE "MS SANS SERIF"
         SetItem(1, "b_f", 2)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", 0)
      CASE "MS SERIF"
         SetItem(1, "b_f", 1)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", 0)
      CASE "ROMAN"
         SetItem(1, "b_f", 1)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", -1)
      CASE "SCRIPT"
         SetItem(1, "b_f", 4)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", -1)
      CASE "SMALL FONTS"
         SetItem(1, "b_f", 2)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", 0)
      CASE "SYSTEM"
         SetItem(1, "b_f", 2)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", 0)
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         SetItem(1, "b_f", 1)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", 0)
      CASE "MS LINEDRAW"
         SetItem(1, "b_f", 1)
         SetItem(1, "b_p", 1)
         SetItem(1, "b_cs", 2)
      CASE "TERMINAL"
         SetItem(1, "b_f", 1)
         SetItem(1, "b_p", 1)
         SetItem(1, "b_cs", -1)
      CASE "CENTURY SCHOOLBOOK"
         SetItem(1, "b_f", 1)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", 0)
      CASE "CENTURY GOTHIC"
         SetItem(1, "b_f", 2)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", 0)
      CASE ELSE
         SetItem(1, "b_f", 2)
         SetItem(1, "b_p", 2)
         SetItem(1, "b_cs", 0)
   END CHOOSE

   //---------------------------------------------------------------
   //  Set the disable expressions for the font.
   //---------------------------------------------------------------

   IF NOT i_FontExprLoaded THEN
      THIS.fu_CalLoadFont()
      i_FontExprLoaded = TRUE
   END IF
END IF

//------------------------------------------------------------------
//  Set the font size of the disabled day.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   i_DisSizeSet = TRUE
   SetItem(1, "b_size", TextSize)
   IF NOT i_HeightExprLoaded THEN
      THIS.fu_CalLoadHeight()
      i_HeightExprLoaded = TRUE
   END IF
END IF

//------------------------------------------------------------------
//  Set the visual options.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_CalSetNextOptions("Disable", Options)
END IF

end subroutine

public subroutine fu_calmonthoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalMonthOptions
//  Description   : Establishes the look-and-feel of the month
//                  portion of the calendar object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the month.
//
//  Return Value  : (None)
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
//  Set the font style of the text for the month.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   i_MonthFontSet = TRUE
   SetItem(1, "m_font", TextFont)
   CHOOSE CASE UPPER(TextFont)
      CASE "ARIAL"
         SetItem(1, "m_f", 2)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", 0)
      CASE "COURIER", "COURIER NEW"
         SetItem(1, "m_f", 1)
         SetItem(1, "m_p", 1)
         SetItem(1, "m_cs", 0)
      CASE "MODERN"
         SetItem(1, "m_f", 1)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", -1)
      CASE "MS SANS SERIF"
         SetItem(1, "m_f", 2)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", 0)
      CASE "MS SERIF"
         SetItem(1, "m_f", 1)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", 0)
      CASE "ROMAN"
         SetItem(1, "m_f", 1)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", -1)
      CASE "SCRIPT"
         SetItem(1, "m_f", 4)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", -1)
      CASE "SMALL FONTS"
         SetItem(1, "m_f", 2)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", 0)
      CASE "SYSTEM"
         SetItem(1, "m_f", 2)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", 0)
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         SetItem(1, "m_f", 1)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", 0)
      CASE "MS LINEDRAW"
         SetItem(1, "m_f", 1)
         SetItem(1, "m_p", 1)
         SetItem(1, "m_cs", 2)
      CASE "TERMINAL"
         SetItem(1, "m_f", 1)
         SetItem(1, "m_p", 1)
         SetItem(1, "m_cs", -1)
      CASE "CENTURY SCHOOLBOOK"
         SetItem(1, "m_f", 1)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", 0)
      CASE "CENTURY GOTHIC"
         SetItem(1, "m_f", 2)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", 0)
      CASE ELSE
         SetItem(1, "m_f", 2)
         SetItem(1, "m_p", 2)
         SetItem(1, "m_cs", 0)
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Set the font size of the month.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   i_MonthSizeSet = TRUE
   SetItem(1, "m_size", TextSize)
   i_MonthSize = TextSize
END IF

//------------------------------------------------------------------
//  Set the visual options.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_CalSetNextOptions("Month", Options)
END IF

end subroutine

public subroutine fu_calselectoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalSelectOptions
//  Description   : Establishes the look-and-feel of the selected
//                  day portion of the calendar object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the selected days.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SetReDraw(FALSE)

//------------------------------------------------------------------
//  Set the font style of the text for the selected day.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   i_SelFontSet = TRUE
   SetItem(1, "s_font", TextFont)
   CHOOSE CASE UPPER(TextFont)
      CASE "ARIAL"
         SetItem(1, "s_f", 2)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", 0)
      CASE "COURIER", "COURIER NEW"
         SetItem(1, "s_f", 1)
         SetItem(1, "s_p", 1)
         SetItem(1, "s_cs", 0)
      CASE "MODERN"
         SetItem(1, "s_f", 1)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", -1)
      CASE "MS SANS SERIF"
         SetItem(1, "s_f", 2)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", 0)
      CASE "MS SERIF"
         SetItem(1, "s_f", 1)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", 0)
      CASE "ROMAN"
         SetItem(1, "s_f", 1)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", -1)
      CASE "SCRIPT"
         SetItem(1, "s_f", 4)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", -1)
      CASE "SMALL FONTS"
         SetItem(1, "s_f", 2)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", 0)
      CASE "SYSTEM"
         SetItem(1, "s_f", 2)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", 0)
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         SetItem(1, "s_f", 1)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", 0)
      CASE "MS LINEDRAW"
         SetItem(1, "s_f", 1)
         SetItem(1, "s_p", 1)
         SetItem(1, "s_cs", 2)
      CASE "TERMINAL"
         SetItem(1, "s_f", 1)
         SetItem(1, "s_p", 1)
         SetItem(1, "s_cs", -1)
      CASE "CENTURY SCHOOLBOOK"
         SetItem(1, "s_f", 1)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", 0)
      CASE "CENTURY GOTHIC"
         SetItem(1, "s_f", 2)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", 0)
      CASE ELSE
         SetItem(1, "s_f", 2)
         SetItem(1, "s_p", 2)
         SetItem(1, "s_cs", 0)
   END CHOOSE
   IF NOT i_FontExprLoaded THEN
      fu_CalLoadFont()
      i_FontExprLoaded = TRUE
   END IF
END IF

//------------------------------------------------------------------
//  Set the font size of the selected day.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   i_SelSizeSet = TRUE
   SetItem(1, "s_size", TextSize)
   IF NOT i_HeightExprLoaded THEN
      THIS.fu_CalLoadHeight()
      i_HeightExprLoaded = TRUE
   END IF
END IF

//------------------------------------------------------------------
//  Set the visual options.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_CalSetNextOptions("Select", Options)
END IF

end subroutine

public subroutine fu_calyearoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Calendar
//  Subroutine    : fu_CalYearOptions
//  Description   : Establishes the look-and-feel of the year
//                  portion of the calendar object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the year.
//
//  Return Value  : (None)
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
//  Set the font style of the text for the year.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   i_YearFontSet = TRUE
   SetItem(1, "y_font", TextFont)
   CHOOSE CASE UPPER(TextFont)
      CASE "ARIAL"
         SetItem(1, "y_f", 2)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", 0)
      CASE "COURIER", "COURIER NEW"
         SetItem(1, "y_f", 1)
         SetItem(1, "y_p", 1)
         SetItem(1, "y_cs", 0)
      CASE "MODERN"
         SetItem(1, "y_f", 1)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", -1)
      CASE "MS SANS SERIF"
         SetItem(1, "y_f", 2)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", 0)
      CASE "MS SERIF"
         SetItem(1, "y_f", 1)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", 0)
      CASE "ROMAN"
         SetItem(1, "y_f", 1)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", -1)
      CASE "SCRIPT"
         SetItem(1, "y_f", 4)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", -1)
      CASE "SMALL FONTS"
         SetItem(1, "y_f", 2)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", 0)
      CASE "SYSTEM"
         SetItem(1, "y_f", 2)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", 0)
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         SetItem(1, "y_f", 1)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", 0)
      CASE "MS LINEDRAW"
         SetItem(1, "y_f", 1)
         SetItem(1, "y_p", 1)
         SetItem(1, "y_cs", 2)
      CASE "TERMINAL"
         SetItem(1, "y_f", 1)
         SetItem(1, "y_p", 1)
         SetItem(1, "y_cs", -1)
      CASE "CENTURY SCHOOLBOOK"
         SetItem(1, "y_f", 1)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", 0)
      CASE "CENTURY GOTHIC"
         SetItem(1, "y_f", 2)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", 0)
      CASE ELSE
         SetItem(1, "y_f", 2)
         SetItem(1, "y_p", 2)
         SetItem(1, "y_cs", 0)
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Set the font size of the year.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   i_YearSizeSet = TRUE
   SetItem(1, "y_size", TextSize)
   i_MonthSizeSet = TRUE
   SetItem(1, "m_size", TextSize)
   i_MonthSize = TextSize
END IF

//------------------------------------------------------------------
//  Set the visual options.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   THIS.fu_CalSetNextOptions("Year", Options)
END IF

end subroutine

event clicked;//******************************************************************
//  PO Module     : u_Calendar
//  Event         : Clicked
//  Description   : Determines if a month, year or day was selected.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumDates, l_Row, l_Col, l_Day
INTEGER l_FirstDay, l_LastDay
STRING  l_ClickedObject, l_String, l_DateStr, l_DisableStr
DATE    l_Date, l_Nulldate, l_BeginDate, l_EndDate
BOOLEAN l_ControlKeyDown, l_ShiftKeyDown

l_ClickedObject = GetObjectAtPointer()

IF l_ClickedObject = "" THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Determine if the control or shift keys are being held down.
//------------------------------------------------------------------

l_ControlKeyDown = KeyDown(KeyControl!)
l_ShiftKeyDown   = KeyDown(KeyShift!)

//------------------------------------------------------------------
//  Using the position of the mouse pointer, determine what was
//  selected.
//------------------------------------------------------------------

l_ClickedObject = MID(l_ClickedObject, 1, POS(l_ClickedObject, CHAR(9)) - 1)

CHOOSE CASE l_ClickedObject
   CASE "m_up"

      i_ClickedMonth = Integer(GetItemString(1, "month")) + 1
      i_ClickedYear  = Integer(GetItemString(1, "year"))

      IF i_ClickedMonth > 12 THEN
         i_ClickedYear = i_ClickedYear + 1
         i_ClickedMonth = 1
      END IF

      fu_CalSetMonth(i_ClickedMonth, i_ClickedYear)

   CASE "m_dn"

      i_ClickedMonth = Integer(GetItemString(1, "month")) - 1
      i_ClickedYear  = Integer(GetItemString(1, "year"))

      IF i_ClickedMonth < 1 THEN
         i_ClickedYear = i_ClickedYear - 1
         i_ClickedMonth = 12
      END IF

      fu_CalSetMonth(i_ClickedMonth, i_ClickedYear)

   CASE "y_up"

      i_ClickedYear  = Integer(GetItemString(1, "year")) + 1

      fu_CalSetYear(i_ClickedYear)

   CASE "y_dn"

      i_ClickedYear  = Integer(GetItemString(1, "year")) - 1

      fu_CalSetYear(i_ClickedYear)

   CASE ELSE

      IF Left(l_ClickedObject, 3) = "day" THEN
         l_Row = Integer(MID(l_ClickedObject, 4, 1))
         l_Col = Integer(MID(l_ClickedObject, 5, 1))
         l_FirstDay = GetItemNumber(1, "first_day")
         l_LastDay = GetItemNumber(1, "last_day")
         l_Day = ((l_Row - 1) * 7) + l_Col - l_FirstDay + 1

         IF l_Day > 0 AND l_Day <= l_LastDay THEN
            IF POS(GetItemString(1, "dis"), &
                   String(i_SelectedYear) + &
                   String(i_SelectedMonth,'00') + &
                   String(l_Day,'00')) > 0 THEN
               RETURN
            END IF        

            i_CalendarError = c_ValOK
            i_ClickedDay  = l_Day
				
				Event po_DayValidate(i_ClickedDay, i_SelectedDay)

            IF i_CalendarError = c_ValFailed THEN
               RETURN
            END IF

            l_Date = Date(i_SelectedYear, i_SelectedMonth, &
                          l_Day)
            SetNull(l_NullDate)

            IF l_ControlKeyDown AND NOT i_CalendarDD THEN 

               IF POS(GetItemString(1, "sel"), &
                      String(i_SelectedYear) + &
                      String(i_SelectedMonth,'00') + &
                      String(l_Day,'00')) > 0 THEN
                  i_AnchorDate = l_NullDate
                  i_AnchorDay = ""
                  fu_CalSetDay(l_Date, "DELETE")
               ELSE
                  i_AnchorDate = l_Date
                  i_AnchorDay  = l_ClickedObject
                  fu_CalSetDay(l_Date, "ADD")
               END IF

            ELSEIF l_ShiftKeyDown AND NOT i_CalendarDD THEN

               IF IsNull(i_AnchorDate) <> FALSE THEN
                  i_AnchorDate = l_Date
                  i_AnchorDay = l_ClickedObject
               END IF

               IF l_Date >= i_AnchorDate THEN
                  l_BeginDate = i_AnchorDate
                  l_EndDate   = l_Date
               ELSE
                  l_EndDate   = i_AnchorDate
                  l_BeginDate = l_Date
               END IF

               l_NumDates = DaysAfter(l_BeginDate, l_EndDate) + 1
               l_DateStr = GetItemString(1, "sel")
               l_DisableStr = GetItemString(1, "dis")
               FOR l_Idx = 1 TO l_NumDates
                  l_String = String(RelativeDate(l_BeginDate, &
                             l_Idx - 1), "yyyymmdd")
                  IF POS(l_DateStr, l_String) = 0 AND &
                     POS(l_DisableStr, l_String) = 0 THEN
                     l_DateStr = l_DateStr + " " + l_String
                  END IF
               NEXT
               SetItem(1, "sel", l_DateStr)

            ELSE

               i_AnchorDate = l_Date
               i_AnchorDay  = l_ClickedObject
               THIS.fu_CalSetDay(l_Date, "RESET")

            END IF

            i_SelectedDay = i_ClickedDay
            IF NOT i_CalendarDD THEN
               SetReDraw(TRUE)
            END IF
            Event po_DayChanged(i_SelectedDay)

            IF i_CalendarDD THEN
               IF i_CalendarDDType = "OBJECT" THEN
                  IF i_DDObject[i_DDIndex[i_CalendarDDIndex]].AllowEdit THEN
                     i_DDObject[i_DDIndex[i_CalendarDDIndex]].Text = &
                        String(l_Date, &
                        i_DDFormat[i_DDIndex[i_CalendarDDIndex]])
                  ELSE
                     i_DDObject[i_DDIndex[i_CalendarDDIndex]].Reset()
                     i_DDObject[i_DDIndex[i_CalendarDDIndex]].AddItem(String(l_Date, &
                        i_DDFormat[i_DDIndex[i_CalendarDDIndex]]))
                     i_DDObject[i_DDIndex[i_CalendarDDIndex]].SelectItem(1)
                  END IF
                  i_DDObject[i_DDIndex[i_CalendarDDIndex]].i_CurrentDate = &
                      l_Date
                  Visible  = FALSE
                  TabOrder = 0
                  THIS.PostEvent("po_DDFocus")
               ELSE
                  i_CurrentDW.SetItem(i_CalendarDDRow, &
                                      i_CalendarDDColumn, &
                                      l_Date)
                  Visible  = FALSE
                  TabOrder = 0
                  THIS.PostEvent("po_DDFocus")
               END IF
            END IF

         END IF
      END IF

END CHOOSE
end event

event constructor;//******************************************************************
//  PO Module     : u_Calendar
//  Event         : Constructor
//  Description   : Initializes the default calendar options.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Defaults, l_DefaultFont, l_DefaultSize

//------------------------------------------------------------------
//  Make sure the border of the calendar control is turned off.
//------------------------------------------------------------------

i_CalendarResize = FALSE
Border           = FALSE
TabOrder         = 0
i_CalendarResize = TRUE

//------------------------------------------------------------------
//  Determine the background color of the parent.
//------------------------------------------------------------------

IF Parent.TypeOf() = Window! THEN
   i_Window          = Parent
   i_CalendarBGColor = i_Window.BackColor
   i_ParentObject    = "WINDOW"
ELSE
   i_UserObject      = Parent
   i_CalendarBGColor = i_UserObject.BackColor
   i_ParentObject    = "USEROBJECT"
END IF

//------------------------------------------------------------------
//  Initialize the calendar defaults.
//------------------------------------------------------------------

l_Defaults = OBJCA.MGR.fu_GetDefault("Calendar", "General")
THIS.fu_CalSetOptions("General", l_Defaults)

//------------------------------------------------------------------
//  Initialize the calendar heading defaults.
//------------------------------------------------------------------

l_Defaults    = OBJCA.MGR.fu_GetDefault("Calendar", "Heading")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Calendar", "HeadingTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Calendar", "HeadingTextSize")
THIS.fu_CalHeadingOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

//------------------------------------------------------------------
//  Initialize the calendar day defaults.
//------------------------------------------------------------------

l_Defaults    = OBJCA.MGR.fu_GetDefault("Calendar", "Day")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Calendar", "DayTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Calendar", "DayTextSize")
THIS.fu_CalDayOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

//------------------------------------------------------------------
//  Initialize the calendar select defaults.
//------------------------------------------------------------------

l_Defaults    = OBJCA.MGR.fu_GetDefault("Calendar", "Select")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Calendar", "SelectTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Calendar", "SelectTextSize")
THIS.fu_CalSelectOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

//------------------------------------------------------------------
//  Initialize the calendar disable defaults.
//------------------------------------------------------------------

l_Defaults    = OBJCA.MGR.fu_GetDefault("Calendar", "Disable")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Calendar", "DisableTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Calendar", "DisableTextSize")
THIS.fu_CalDisableOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

//------------------------------------------------------------------
//  Initialize the calendar month defaults.
//------------------------------------------------------------------

l_Defaults    = OBJCA.MGR.fu_GetDefault("Calendar", "Month")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Calendar", "MonthTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Calendar", "MonthTextSize")
THIS.fu_CalMonthOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

//------------------------------------------------------------------
//  Initialize the calendar year defaults.
//------------------------------------------------------------------

l_Defaults    = OBJCA.MGR.fu_GetDefault("Calendar", "Year")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Calendar", "YearTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Calendar", "YearTextSize")
THIS.fu_CalYearOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

end event

event losefocus;//******************************************************************
//  PO Module     : u_Calendar
//  Event         : LoseFocus
//  Description   : When the calendar loses focus, set the selected
//                  date into the drop-down object or DataWindow
//                  column.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF i_CalendarDD THEN

   IF Visible AND i_CalendarDDType = "OBJECT" THEN

      Visible  = FALSE
      TabOrder = 0
      IF GetFocus() = i_DDObject[i_DDIndex[i_CalendarDDIndex]] THEN
         i_DDObject[i_DDIndex[i_CalendarDDIndex]].i_DDClosed = TRUE
      END IF

   ELSEIF Visible AND i_CalendarDDType = "COLUMN" THEN

      TabOrder = 0
      Visible  = FALSE
      i_DDClosed = TRUE

   END IF

END IF


end event

event getfocus;//******************************************************************
//  PO Module     : u_Calendar
//  Event         : GetFocus
//  Description   : Post a focus back to the drop-down object to
//                  force the drop-down to complete.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF i_CalendarDD THEN
   IF i_CalendarDDType = "OBJECT" THEN
      IF NOT Visible THEN
         i_DDObject[i_DDIndex[i_CalendarDDIndex]].SetFocus()
      END IF
   END IF
END IF
end event

event resize;//******************************************************************
//  PO Module     : u_Calendar
//  Event         : Resize
//  Description   : Resize the calendar control.
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
//  If the resize option is on, re-create the calendar object when 
//  the control has been resized by its parent.
//------------------------------------------------------------------

IF i_CalendarResize THEN
   THIS.fu_CalResize()
END IF
end event

