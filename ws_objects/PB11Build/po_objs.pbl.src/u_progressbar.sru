$PBExportHeader$u_progressbar.sru
$PBExportComments$Progress bar class
forward
global type u_progressbar from datawindow
end type
end forward

global type u_progressbar from datawindow
int Width=599
int Height=120
int TabOrder=1
boolean LiveScroll=true
event po_identify pbm_custom75
end type
global u_progressbar u_progressbar

type variables
//-----------------------------------------------------------------------------------------
//  ProgressBar Constants.
//-----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName		= "Progress"
CONSTANT STRING	c_DefaultVisual		= "000|"
CONSTANT STRING	c_DefaultFont 		= ""
CONSTANT INTEGER	c_DefaultSize 		= 0

CONSTANT STRING	c_ProgressBGGray		= "001|"
CONSTANT STRING	c_ProgressBGBlack		= "002|"
CONSTANT STRING	c_ProgressBGWhite	= "003|"
CONSTANT STRING	c_ProgressBGDarkGray	= "004|"
CONSTANT STRING	c_ProgressBGRed		= "005|"
CONSTANT STRING	c_ProgressBGDarkRed	= "006|"
CONSTANT STRING	c_ProgressBGGreen	= "007|"
CONSTANT STRING	c_ProgressBGDarkGreen	= "008|"
CONSTANT STRING	c_ProgressBGBlue		= "009|"
CONSTANT STRING	c_ProgressBGDarkBlue	= "010|"
CONSTANT STRING	c_ProgressBGMagenta	= "011|"
CONSTANT STRING	c_ProgressBGDarkMagenta	= "012|"
CONSTANT STRING	c_ProgressBGCyan		= "013|"
CONSTANT STRING	c_ProgressBGDarkCyan	= "014|"
CONSTANT STRING	c_ProgressBGYellow	= "015|"
CONSTANT STRING	c_ProgressBGDarkYellow	= "016|"

CONSTANT STRING	c_ProgressGray		= "017|"
CONSTANT STRING	c_ProgressBlack		= "018|"
CONSTANT STRING	c_ProgressWhite		= "019|"
CONSTANT STRING	c_ProgressDarkGray	= "020|"
CONSTANT STRING	c_ProgressRed		= "021|"
CONSTANT STRING	c_ProgressDarkRed	= "022|"
CONSTANT STRING	c_ProgressGreen		= "023|"
CONSTANT STRING	c_ProgressDarkGreen	= "024|"
CONSTANT STRING	c_ProgressBlue		= "025|"
CONSTANT STRING	c_ProgressDarkBlue   	= "026|"
CONSTANT STRING	c_ProgressMagenta    	= "027|"
CONSTANT STRING	c_ProgressDarkMagenta	= "028|"
CONSTANT STRING	c_ProgressCyan       	= "029|"
CONSTANT STRING	c_ProgressDarkCyan   	= "030|"
CONSTANT STRING	c_ProgressYellow		= "031|"
CONSTANT STRING	c_ProgressDarkYellow	= "032|"

CONSTANT STRING	c_ProgressTextBlack	= "033|"
CONSTANT STRING	c_ProgressTextWhite	= "034|"
CONSTANT STRING	c_ProgressTextGray	= "035|"
CONSTANT STRING	c_ProgressTextDarkGray	= "036|"
CONSTANT STRING	c_ProgressTextRed		= "037|"
CONSTANT STRING	c_ProgressTextDarkRed	= "038|"
CONSTANT STRING	c_ProgressTextGreen	= "039|"
CONSTANT STRING	c_ProgressTextDarkGreen	= "040|"
CONSTANT STRING	c_ProgressTextBlue		= "041|"
CONSTANT STRING	c_ProgressTextDarkBlue	= "042|"
CONSTANT STRING	c_ProgressTextMagenta	= "043|"
CONSTANT STRING	c_ProgressTextDarkMagenta	= "044|"
CONSTANT STRING	c_ProgressTextCyan	= "045|"
CONSTANT STRING	c_ProgressTextDarkCyan	= "046|"
CONSTANT STRING	c_ProgressTextYellow	= "047|"
CONSTANT STRING	c_ProgressTextDarkYellow	= "048|"

CONSTANT STRING	c_ProgressMeterBlue	= "049|"
CONSTANT STRING	c_ProgressMeterWhite	= "050|"
CONSTANT STRING	c_ProgressMeterGray	= "051|"
CONSTANT STRING	c_ProgressMeterDarkGray	= "052|"
CONSTANT STRING	c_ProgressMeterRed	= "053|"
CONSTANT STRING	c_ProgressMeterDarkRed	= "054|"
CONSTANT STRING	c_ProgressMeterGreen	= "055|"
CONSTANT STRING	c_ProgressMeterDarkGreen	= "056|"
CONSTANT STRING	c_ProgressMeterBlack	= "057|"
CONSTANT STRING	c_ProgressMeterDarkBlue	= "058|"
CONSTANT STRING	c_ProgressMeterMagenta	= "059|"
CONSTANT STRING	c_ProgressMeterDarkMagenta = "060|"
CONSTANT STRING	c_ProgressMeterCyan	= "061|"
CONSTANT STRING	c_ProgressMeterDarkCyan	= "062|"
CONSTANT STRING	c_ProgressMeterYellow	= "063|"
CONSTANT STRING	c_ProgressMeterDarkYellow	= "064|"

CONSTANT STRING	c_ProgressBorderNone	= "065|"
CONSTANT STRING	c_ProgressBorderShadowBox	= "066|"
CONSTANT STRING	c_ProgressBorderBox	= "067|"
CONSTANT STRING	c_ProgressBorderLowered	= "068|"
CONSTANT STRING	c_ProgressBorderRaised	= "069|"

CONSTANT STRING	c_ProgressDirectionHoriz	= "070|"
CONSTANT STRING	c_ProgressDirectionVert	= "071|"

CONSTANT STRING	c_ProgressPercentShow	= "072|"
CONSTANT STRING	c_ProgressPercentHide	= "073|"

CONSTANT STRING	c_ProgressTextRegular	= "074|"
CONSTANT STRING	c_ProgressTextBold		= "075|"

//-----------------------------------------------------------------------------------------
//  ProgressBar Instance Variables.
//-----------------------------------------------------------------------------------------

STRING			i_ProgressBGColor 		= "12632256"
STRING			i_ProgressColor 		= "12632256"
STRING			i_ProgressMeterColor 	= "16776960"
STRING			i_ProgressTextColor 	= "0"
STRING			i_ProgressBorder 		= "5"
STRING			i_ProgressDirection 		= "Horiz"
STRING			i_ProgressTextFont 		= "Arial"
STRING			i_ProgressTextSize 		= "-8"
STRING			i_ProgressTextStyle		= "400"

INTEGER		i_ProgressFontHeight 	= 9
INTEGER		i_Height
INTEGER		i_Width

BOOLEAN		i_ProgressPercent 		= TRUE
BOOLEAN		i_ProgressCreated 		= FALSE

//-----------------------------------------------------------------------------------------
//  DataWindow syntax instance variable.
//-----------------------------------------------------------------------------------------

STRING	i_DWSyntax = 'release 4; ' + & 
	+ 'datawindow(' + &
	+ 'units=1 ' + &
	+ 'timer_interval=0 ' + &
	+ 'processing=0 ' + &
	+ 'print.documentname="" ' + &
	+ 'print.orientation = 0 ' + &
	+ 'print.margin.left = 24 ' + &
	+ 'print.margin.right = 24 ' + &
	+ 'print.margin.top = 24 ' + &
	+ 'print.margin.bottom = 24 ' + &
	+ 'print.paper.source = 0 ' + &
	+ 'print.paper.size = 0 ' 

//-------------------------------------------------------------------------------
//  Table syntax instance variable.
//-------------------------------------------------------------------------------

STRING	i_TableSyntax = 'table(column=(type=char(10) ' + &
	'name=meterprogressbar ' + &
	'dbname="meterprogressbar" ) ) '

//-------------------------------------------------------------------------------
//  Text syntax instance variable.
//-------------------------------------------------------------------------------

STRING	i_TextSyntax = 'text(band=detail ' + &
	+ 'alignment="2" text="" ' 




end variables

forward prototypes
public function integer fu_progresscreate ()
public function integer fu_setprogress (integer percent)
public function string fu_getidentity ()
public subroutine fu_setoptions (string optionstyle, string options)
public subroutine fu_progressoptions (string textfont, integer textsize, string options)
end prototypes

event po_identify;//******************************************************************
//  PO Module     : u_ProgressBar
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

public function integer fu_progresscreate ();//******************************************************************
//  PO Module     : u_ProgressBar
//  Subroutine    : fu_ProgressCreate
//  Description   : Responsible for creating the progress bar 
//						  datawindow object.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - create successful.
//						     -1 - create failed. 
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING 	l_DWSyntax, l_BGTextSyntax, l_BarTextSyntax, l_TextSyntax
STRING 	l_HeightString
INTEGER 	l_Error, l_MeterHeight, l_MeterWidth, l_MeterY, l_MeterX
INTEGER	l_TextHeight, l_TextY, l_x, l_y

//------------------------------------------------------------------
// Build the syntax needed to create the datawindow object.
//------------------------------------------------------------------

l_HeightString = "height = " + String(Height)

l_DWSyntax = i_DWSyntax + &
				'color =' + i_ProgressBGColor + ')' + &
 				'detail(' + l_heightstring + ' color= "' + i_ProgressBGColor + '" ) '

//------------------------------------------------------------------
// Adjust the height and width of the progress bar to leave some
// room for a border.
//------------------------------------------------------------------

i_height = Height - 20
i_width =  Width - 24
l_x = 12
l_y = 6

i_Height = UnitsToPixels( i_Height, yUnitsToPixels! )
l_y = UnitsToPixels( l_y, yUnitsToPixels! )
i_Width = UnitsToPixels( i_Width, xUnitsToPixels! )
l_x = UnitsToPixels( l_x, xUnitsToPixels! )

//------------------------------------------------------------------
// Build the syntax needed to create the progress bar, which is
// a datawindow text field. 
//------------------------------------------------------------------

l_BGTextSyntax = i_TextSyntax + &
				'border="' + i_ProgressBorder + '" ' + &
				'color="' + i_ProgressColor + '" ' + &
				'x="' + String(l_x) + '" ' + &
				'y="' + String(l_y) + '" ' + &
				'height="' + String(i_Height) + '" ' + &
				'width="' + String(i_Width) + '" ' + &
				'name=ProgressBG ' + &
				'background.mode="0" ' + &
				'background.color="' + i_ProgressColor + '" ) ' 

//------------------------------------------------------------------
// Build the progress bar meter dimensions based on the direction 
// option.
//------------------------------------------------------------------

IF i_ProgressDirection = "Vert" THEN
	l_MeterHeight = 0
	l_MeterWidth = i_Width
	l_MeterX = l_X
	l_MeterY = i_Height 
ELSE
	l_MeterWidth = 0
	l_MeterHeight = i_Height
	l_MeterX = l_X
	l_MeterY = l_Y
END IF

//------------------------------------------------------------------
// Build the syntax needed to create the progress bar meter, which 
// is a datawindow text field. 
//------------------------------------------------------------------

l_BarTextSyntax = i_TextSyntax + &
				'border="0" ' + &
				'color="' + i_ProgressMeterColor + '" ' + &
				'x="' + String(l_MeterX) + '" ' + &
				'y="' + String(l_MeterY) + '" ' + &
				'height="' + String(l_MeterHeight) + '" ' + &
				'width="' + String(l_MeterWidth) + '" ' + &
				'name=ProgressBar ' + &
				'background.mode="0" ' + &
				'background.color="' + i_ProgressMeterColor + '" ) '  

//------------------------------------------------------------------
// Build the meter bar text dimensions based on the the font size
// specified.
//------------------------------------------------------------------

l_TextHeight = ( i_ProgressFontHeight ) + ( ( i_ProgressFontHeight / 2 ) + 1 )
l_TextY = ( i_height / 2 ) - ( l_TextHeight / 2 )

//------------------------------------------------------------------
// Build the syntax needed to create the progress bar text, which 
// is a datawindow text field. 
//------------------------------------------------------------------

l_TextSyntax = i_TextSyntax + &
					'border="0" ' + &
					'color="' + i_ProgressTextColor + '" ' + &
					'x="' + String(l_x) + '" ' + &
					'y="' + String(l_TextY) + '" ' + &
					'height="' + String(l_TextHeight) + '" ' + &
					'width="' + String(i_Width) + '" ' + &
					'name=ProgressText ' + &
					'font.face="' + i_ProgressTextFont + '" ' + &
					'font.height="' + String(i_ProgressTextSize) + '" ' + &
					'font.weight="' + i_ProgressTextStyle + '" ' + &
					'font.family="2" ' + &
					'font.pitch="2" ' + &
					'font.charset="0" ' + &
					'background.mode="1" ' +  &
					'background.color="16777215" ) '

l_DWSyntax = l_DWSyntax + i_TableSyntax + &
				 l_BGTextSyntax + l_BarTextSyntax + l_TextSyntax

//------------------------------------------------------------------
// Create the progress bar.
//------------------------------------------------------------------

l_Error = Create(l_DWSyntax)
InsertRow(0)

RETURN l_Error

end function

public function integer fu_setprogress (integer percent);//******************************************************************
//  PO Module     : u_ProgressBar
//  Subroutine    : fu_SetProgress
//  Description   : Responsible for showing the percentage displayed
//					     on the progress bar.
//
//  Parameters    : INTEGER Percent - 
//                     Percentage displayed on the progress bar.
//
//  Return Value  : INTEGER -
//                      0 - create successful.
//						     -1 - create failed. 
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING	l_Text, l_Error, l_ModifyString
INTEGER	l_MeterHeight, l_MeterWidth, l_MeterY
DECIMAL	l_Percent

//------------------------------------------------------------------
//	Convert the percentage to decimal.
//------------------------------------------------------------------

l_Percent = percent / 100

//------------------------------------------------------------------
//	Build the percentage string to display on the progress bar.
//------------------------------------------------------------------

IF i_ProgressPercent THEN
	l_Text = STRING(percent) + "%"
ELSE
	l_Text = ""
END IF

//------------------------------------------------------------------
// Build the progress bar meter dimensions based on the percentage
// and direction options specified. 
//------------------------------------------------------------------

IF i_ProgressDirection = "Vert" THEN
	l_MeterHeight = i_Height * l_Percent
	l_MeterY = i_Height - l_MeterHeight + 1
	l_ModifyString = "ProgressBar.height = " + &
							String(l_MeterHeight) +  &
							"ProgressBar.Y = " + &
							String(l_MeterY) + &
						   "ProgressText.text = " + "'" + l_Text + "'"
	l_Error = Modify(l_ModifyString)
	IF l_Error <> "" THEN
		RETURN -1
	END IF
ELSE
	l_MeterWidth = i_Width * l_Percent
	l_ModifyString = "ProgressBar.width = " + &
						   String(l_MeterWidth) + &
							" ProgressText.text = " + "'" + l_Text + "'"
	l_Error = Modify(l_ModifyString)
	IF l_Error <> "" THEN
		RETURN -1
	END IF
END IF

SetReDraw(TRUE)

RETURN 0 


end function

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_ProgressBar
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

public subroutine fu_setoptions (string optionstyle, string options);//******************************************************************
//  PO Module     : u_ProgressBar
//  Subroutine    : fu_SetOptions
//  Description   : Sets visual defaults and options. It is also 
//						  called by the constructor event to set initial 
//						  defaults.  
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

//------------------------------------------------------------------
// Set the progress bar options and defaults.
//------------------------------------------------------------------

CHOOSE CASE OptionStyle

   CASE "General"

   //---------------------------------------------------------------
   // Progress bar background color.
   //---------------------------------------------------------------

	IF Pos(Options, c_ProgressBGGray) > 0 THEN
		i_ProgressBGColor = String(OBJCA.MGR.c_Gray)       
	ELSEIF Pos(Options, c_ProgressBGBlack) > 0 THEN  
		i_ProgressBGColor = String(OBJCA.MGR.c_Black)       
	ELSEIF Pos(Options, c_ProgressBGWhite) > 0 THEN   
		i_ProgressBGColor = String(OBJCA.MGR.c_White)       
	ELSEIF Pos(Options, c_ProgressBGDarkGray) > 0 THEN    
		i_ProgressBGColor = String(OBJCA.MGR.c_DarkGray)       
	ELSEIF Pos(Options, c_ProgressBGRed) > 0 THEN         
		i_ProgressBGColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_ProgressBGDarkRed) > 0 THEN     
		i_ProgressBGColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_ProgressBGGreen) > 0 THEN       
		i_ProgressBGColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_ProgressBGDarkGreen) > 0 THEN   
		i_ProgressBGColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_ProgressBGBlue) > 0 THEN       
		i_ProgressBGColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_ProgressBGDarkBlue) > 0 THEN    
		i_ProgressBGColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_ProgressBGMagenta) > 0 THEN     
		i_ProgressBGColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_ProgressBGDarkMagenta) > 0 THEN 
		i_ProgressBGColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_ProgressBGCyan) > 0 THEN        
		i_ProgressBGColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_ProgressBGDarkCyan) > 0 THEN    
		i_ProgressBGColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_ProgressBGYellow) > 0 THEN      
		i_ProgressBGColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_ProgressBGDarkYellow) > 0 THEN  
		i_ProgressBGColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF

   //---------------------------------------------------------------
   // Progress bar meter color.
   //---------------------------------------------------------------

	IF Pos(Options, c_ProgressMeterGray) > 0 THEN
		i_ProgressMeterColor = String(OBJCA.MGR.c_Gray)       
	ELSEIF Pos(Options, c_ProgressMeterBlack) > 0 THEN  
		i_ProgressMeterColor = String(OBJCA.MGR.c_Black)       
	ELSEIF Pos(Options, c_ProgressMeterWhite) > 0 THEN   
		i_ProgressMeterColor = String(OBJCA.MGR.c_White)       
	ELSEIF Pos(Options, c_ProgressMeterDarkGray) > 0 THEN    
		i_ProgressMeterColor = String(OBJCA.MGR.c_DarkGray)       
	ELSEIF Pos(Options, c_ProgressMeterRed) > 0 THEN         
		i_ProgressMeterColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_ProgressMeterDarkRed) > 0 THEN     
		i_ProgressMeterColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_ProgressMeterGreen) > 0 THEN       
		i_ProgressMeterColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_ProgressMeterDarkGreen) > 0 THEN   
		i_ProgressMeterColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_ProgressMeterBlue) > 0 THEN        
		i_ProgressMeterColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_ProgressMeterDarkBlue) > 0 THEN    
		i_ProgressMeterColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_ProgressMeterMagenta) > 0 THEN     
		i_ProgressMeterColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_ProgressMeterDarkMagenta) > 0 THEN 
		i_ProgressMeterColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_ProgressMeterCyan) > 0 THEN        
		i_ProgressMeterColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_ProgressMeterDarkCyan) > 0 THEN    
		i_ProgressMeterColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_ProgressMeterYellow) > 0 THEN      
		i_ProgressMeterColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_ProgressMeterDarkYellow) > 0 THEN  
		i_ProgressMeterColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF

   //---------------------------------------------------------------
   // Progress bar text color.
   //---------------------------------------------------------------

	IF Pos(Options, c_ProgressTextGray) > 0 THEN
		i_ProgressTextColor = String(OBJCA.MGR.c_Gray)       
	ELSEIF Pos(Options, c_ProgressTextBlack) > 0 THEN  
		i_ProgressTextColor = String(OBJCA.MGR.c_Black)       
	ELSEIF Pos(Options, c_ProgressTextWhite) > 0 THEN   
		i_ProgressTextColor = String(OBJCA.MGR.c_White)       
	ELSEIF Pos(Options, c_ProgressTextDarkGray) > 0 THEN    
		i_ProgressTextColor = String(OBJCA.MGR.c_DarkGray)       
	ELSEIF Pos(Options, c_ProgressTextRed) > 0 THEN         
		i_ProgressTextColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_ProgressTextDarkRed) > 0 THEN     
		i_ProgressTextColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_ProgressTextGreen) > 0 THEN       
		i_ProgressTextColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_ProgressTextDarkGreen) > 0 THEN   
		i_ProgressTextColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_ProgressTextBlue) > 0 THEN        
		i_ProgressTextColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_ProgressTextDarkBlue) > 0 THEN    
		i_ProgressTextColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_ProgressTextMagenta) > 0 THEN     
		i_ProgressTextColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_ProgressTextDarkMagenta) > 0 THEN 
		i_ProgressTextColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_ProgressTextCyan) > 0 THEN        
		i_ProgressTextColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_ProgressTextDarkCyan) > 0 THEN    
		i_ProgressTextColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_ProgressTextYellow) > 0 THEN      
		i_ProgressTextColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_ProgressTextDarkYellow) > 0 THEN  
		i_ProgressTextColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF

   //---------------------------------------------------------------
   // Progress bar color.
   //---------------------------------------------------------------

	IF Pos(Options, c_ProgressGray) > 0 THEN
		i_ProgressColor = String(OBJCA.MGR.c_Gray)       
	ELSEIF Pos(Options, c_ProgressBlack) > 0 THEN  
		i_ProgressColor = String(OBJCA.MGR.c_Black)       
	ELSEIF Pos(Options, c_ProgressWhite) > 0 THEN   
		i_ProgressColor = String(OBJCA.MGR.c_White)       
	ELSEIF Pos(Options, c_ProgressDarkGray) > 0 THEN    
		i_ProgressColor = String(OBJCA.MGR.c_DarkGray)       
	ELSEIF Pos(Options, c_ProgressRed) > 0 THEN         
		i_ProgressColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_ProgressDarkRed) > 0 THEN     
		i_ProgressColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_ProgressGreen) > 0 THEN       
		i_ProgressColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_ProgressDarkGreen) > 0 THEN   
		i_ProgressColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_ProgressBlue) > 0 THEN        
		i_ProgressColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_ProgressDarkBlue) > 0 THEN    
		i_ProgressColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_ProgressMagenta) > 0 THEN     
		i_ProgressColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_ProgressDarkMagenta) > 0 THEN 
		i_ProgressColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_ProgressCyan) > 0 THEN        
		i_ProgressColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_ProgressDarkCyan) > 0 THEN    
		i_ProgressColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_ProgressYellow) > 0 THEN     
		i_ProgressColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_ProgressDarkYellow) > 0 THEN 
		i_ProgressColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF

   //---------------------------------------------------------------
   // Progress bar border style.
   //---------------------------------------------------------------

	IF Pos(Options, c_ProgressBorderNone) > 0 THEN
		i_ProgressBorder = "0" 
	ELSEIF Pos(Options, c_ProgressBorderShadowBox) > 0 THEN        
		i_ProgressBorder = "1"      
	ELSEIF Pos(Options, c_ProgressBorderBox) > 0 THEN
		i_ProgressBorder = "2"      
	ELSEIF Pos(Options, c_ProgressBorderLowered) > 0 THEN
		i_ProgressBorder = "5"     
	ELSEIF Pos(Options, c_ProgressBorderRaised) > 0 THEN   
		i_ProgressBorder = "6"       
	END IF

   //---------------------------------------------------------------
   // Progress bar direction.
   //---------------------------------------------------------------

	IF Pos(Options, c_ProgressDirectionHoriz) > 0 THEN
		i_ProgressDirection = "Horiz"      
	ELSEIF Pos(Options, c_ProgressDirectionVert) > 0 THEN
		i_ProgressDirection = "Vert"      
	END IF

   //---------------------------------------------------------------
   // Show percentage text.
   //---------------------------------------------------------------

	IF Pos(Options, c_ProgressPercentShow) > 0 THEN
		i_ProgressPercent = TRUE      
	ELSEIF Pos(Options, c_ProgressPercentHide) > 0 THEN
      i_ProgressPercent = FALSE    
	END IF

   //---------------------------------------------------------------
   // Progress bar text style.
   //---------------------------------------------------------------

	IF Pos(Options, c_ProgressTextRegular) > 0 THEN
		i_ProgressTextStyle = "400"      
	ELSEIF Pos(Options, c_ProgressTextBold) > 0 THEN
		i_ProgressTextStyle = "700"      
	END IF

END CHOOSE

end subroutine

public subroutine fu_progressoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_ProgressBar
//  Subroutine    : fu_ProgressOptions
//  Description   : Establishes the look-and-feel of the progress
//                  bar object.  
//
//  Parameters    : STRING  TextFont - 
//                     Text font to be used for the progress bar 
//                     text.
//                  INTEGER TextSize - 
//                     Height of the progress bar text in pixels.
//						  STRING  Options - 
//                     Visual options for the progress bar.
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
//  Set the font type of the progress bar text if it is different 
//  than the default.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   i_ProgressTextFont = TextFont
END IF

//------------------------------------------------------------------
//  Set the font size of the progress bar text.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   i_ProgressTextSize   = STRING(TextSize * -1)
   i_ProgressFontHeight = TextSize
END IF


IF Options <> c_DefaultVisual THEN
   fu_SetOptions("General", Options)
END IF

end subroutine

event constructor;//******************************************************************
//  PO Module     : u_ProgressBar
//  Event         : Constructor
//  Description   : Initializes the progress bar options. 
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Defaults, l_DefaultFont, l_DefaultSize

//------------------------------------------------------------------
// Make sure the border of the progress bar control is turned off.
//------------------------------------------------------------------

Border = FALSE

//------------------------------------------------------------------
// Initialize the progress bar options
//------------------------------------------------------------------

l_Defaults = OBJCA.MGR.fu_GetDefault("Progress", "General")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Progress", "TextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("Progress", "TextSize")
fu_ProgressOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)

end event

