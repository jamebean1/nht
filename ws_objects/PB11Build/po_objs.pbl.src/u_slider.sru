$PBExportHeader$u_slider.sru
$PBExportComments$Slider class
forward
global type u_slider from datawindow
end type
end forward

global type u_slider from datawindow
int Width=599
int Height=120
int TabOrder=1
boolean LiveScroll=true
event po_slidermoving ( decimal position )
event po_slidermoved ( decimal position )
event po_identify pbm_custom75
event po_processmoving pbm_dwnmousemove
event po_processmoved pbm_lbuttonup
end type
global u_slider u_slider

type variables
//-----------------------------------------------------------------------------------------
//  Slider Object Constants
//-----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName		= "Slider"
CONSTANT STRING	c_DefaultIndicator 		= ""
CONSTANT LONG		c_DefaultMajorIncr 		= 0
CONSTANT LONG		c_DefaultMinorIncr 		= 0
CONSTANT STRING	c_DefaultVisual		= "000|"
CONSTANT STRING	c_DefaultFont 		= ""
CONSTANT INTEGER	c_DefaultSize 		= 0

CONSTANT STRING	c_SliderBGGray		= "001|"
CONSTANT STRING	c_SliderBGBlack		= "002|"
CONSTANT STRING	c_SliderBGWhite		= "003|"
CONSTANT STRING	c_SliderBGDarkGray	= "004|"
CONSTANT STRING	c_SliderBGRed		= "005|"
CONSTANT STRING	c_SliderBGDarkRed	= "006|"
CONSTANT STRING	c_SliderBGGreen		= "007|"
CONSTANT STRING	c_SliderBGDarkGreen	= "008|"
CONSTANT STRING	c_SliderBGBlue		= "009|"
CONSTANT STRING	c_SliderBGDarkBlue	= "010|"
CONSTANT STRING	c_SliderBGMagenta		= "011|"
CONSTANT STRING	c_SliderBGDarkMagenta	= "012|"
CONSTANT STRING	c_SliderBGCyan		= "013|"
CONSTANT STRING	c_SliderBGDarkCyan	= "014|"
CONSTANT STRING	c_SliderBGYellow		= "015|"
CONSTANT STRING	c_SliderBGDarkYellow	= "016|"

CONSTANT STRING	c_SliderFrameGray		= "017|"
CONSTANT STRING	c_SliderFrameBlack		= "018|"
CONSTANT STRING	c_SliderFrameWhite		= "019|"
CONSTANT STRING	c_SliderFrameDarkGray	= "020|"
CONSTANT STRING	c_SliderFrameRed		= "021|"
CONSTANT STRING	c_SliderFrameDarkRed	= "022|"
CONSTANT STRING	c_SliderFrameGreen	= "023|"
CONSTANT STRING	c_SliderFrameDarkGreen	= "024|"
CONSTANT STRING	c_SliderFrameBlue		= "025|"
CONSTANT STRING	c_SliderFrameDarkBlue   	= "026|"
CONSTANT STRING	c_SliderFrameMagenta    	= "027|"
CONSTANT STRING	c_SliderFrameDarkMagenta	= "028|"
CONSTANT STRING	c_SliderFrameCyan       	= "029|"
CONSTANT STRING	c_SliderFrameDarkCyan   	= "030|"
CONSTANT STRING	c_SliderFrameYellow	= "031|"
CONSTANT STRING	c_SliderFrameDarkYellow	= "032|"

CONSTANT STRING	c_SliderBarBlack		= "033|"
CONSTANT STRING	c_SliderBarWhite		= "034|"
CONSTANT STRING	c_SliderBarGray		= "035|"
CONSTANT STRING	c_SliderBarDarkGray	= "036|"
CONSTANT STRING	c_SliderBarRed		= "037|"
CONSTANT STRING	c_SliderBarDarkRed	= "038|"
CONSTANT STRING	c_SliderBarGreen		= "039|"
CONSTANT STRING	c_SliderBarDarkGreen	= "040|"
CONSTANT STRING	c_SliderBarBlue		= "041|"
CONSTANT STRING	c_SliderBarDarkBlue	= "042|"
CONSTANT STRING	c_SliderBarMagenta	= "043|"
CONSTANT STRING	c_SliderBarDarkMagenta	= "044|"
CONSTANT STRING	c_SliderBarCyan		= "045|"
CONSTANT STRING	c_SliderBarDarkCyan	= "046|"
CONSTANT STRING	c_SliderBarYellow		= "047|"
CONSTANT STRING	c_SliderBarDarkYellow	= "048|"

CONSTANT STRING	c_SliderCenterLineBlue	= "049|"
CONSTANT STRING	c_SliderCenterLineWhite	= "050|"
CONSTANT STRING	c_SliderCenterLineGray	= "051|"
CONSTANT STRING	c_SliderCenterLineDarkGray	= "052|"
CONSTANT STRING	c_SliderCenterLineRed	= "053|"
CONSTANT STRING	c_SliderCenterLineDarkRed	= "054|"
CONSTANT STRING	c_SliderCenterLineGreen	= "055|"
CONSTANT STRING	c_SliderCenterLineDarkGreen	= "056|"
CONSTANT STRING	c_SliderCenterLineBlack	= "057|"
CONSTANT STRING	c_SliderCenterLineDarkBlue	= "058|"
CONSTANT STRING	c_SliderCenterLineMagenta	= "059|"
CONSTANT STRING	c_SliderCenterLineDarkMagenta = "060|"
CONSTANT STRING	c_SliderCenterLineCyan	= "061|"
CONSTANT STRING	c_SliderCenterLineDarkCyan	= "062|"
CONSTANT STRING	c_SliderCenterLineYellow	= "063|"
CONSTANT STRING	c_SliderCenterLineDarkYellow	= "064|"

CONSTANT STRING	c_SliderFrameNone		= "065|"
CONSTANT STRING	c_SliderFrameShadowBox	= "066|"
CONSTANT STRING	c_SliderFrameBox		= "067|"
CONSTANT STRING	c_SliderFrameLowered	= "068|"
CONSTANT STRING	c_SliderFrameRaised	= "069|"

CONSTANT STRING	c_SliderBorderNone		= "070|"
CONSTANT STRING	c_SliderBorderShadowBox	= "071|"
CONSTANT STRING	c_SliderBorderBox		= "072|"
CONSTANT STRING	c_SliderBorderLowered	= "073|"
CONSTANT STRING	c_SliderBorderRaised	= "074|"

CONSTANT STRING	c_SliderCenterLineShow	= "075|"
CONSTANT STRING	c_SliderCenterLineHide	= "076|"

CONSTANT STRING	c_SliderDirectionHoriz	= "077|"
CONSTANT STRING	c_SliderDirectionVert	= "078|"

CONSTANT STRING	c_SliderIndicatorOut	= "079|"
CONSTANT STRING	c_SliderIndicatorIn		= "080|"

CONSTANT STRING	c_SliderTextGray		= "001|"
CONSTANT STRING	c_SliderTextBlack		= "002|"
CONSTANT STRING	c_SliderTextWhite		= "003|"
CONSTANT STRING	c_SliderTextDarkGray	= "004|"
CONSTANT STRING	c_SliderTextRed		= "005|"
CONSTANT STRING	c_SliderTextDarkRed	= "006|"
CONSTANT STRING	c_SliderTextGreen		= "007|"
CONSTANT STRING	c_SliderTextDarkGreen	= "008|"
CONSTANT STRING	c_SliderTextBlue		= "009|"
CONSTANT STRING	c_SliderTextDarkBlue	= "010|"
CONSTANT STRING	c_SliderTextMagenta	= "011|"
CONSTANT STRING	c_SliderTextDarkMagenta	= "012|"
CONSTANT STRING	c_SliderTextCyan		= "013|"
CONSTANT STRING	c_SliderTextDarkCyan	= "014|"
CONSTANT STRING	c_SliderTextYellow		= "015|"
CONSTANT STRING	c_SliderTextDarkYellow	= "016|"

CONSTANT STRING	c_SliderTextShow		= "017|"
CONSTANT STRING	c_SliderTextHide		= "018|"

CONSTANT STRING	c_SliderTickGray		= "001|"
CONSTANT STRING	c_SliderTickBlack		= "002|"
CONSTANT STRING	c_SliderTickWhite		= "003|"
CONSTANT STRING	c_SliderTickDarkGray	= "004|"
CONSTANT STRING	c_SliderTickRed		= "005|"
CONSTANT STRING	c_SliderTickDarkRed	= "006|"
CONSTANT STRING	c_SliderTickGreen		= "007|"
CONSTANT STRING	c_SliderTickDarkGreen	= "008|"
CONSTANT STRING	c_SliderTickBlue		= "009|"
CONSTANT STRING	c_SliderTickDarkBlue	= "010|"
CONSTANT STRING	c_SliderTickMagenta	= "011|"
CONSTANT STRING	c_SliderTickDarkMagenta	= "012|"
CONSTANT STRING	c_SliderTickCyan		= "013|"
CONSTANT STRING	c_SliderTickDarkCyan	= "014|"
CONSTANT STRING	c_SliderTickYellow		= "015|"
CONSTANT STRING	c_SliderTickDarkYellow	= "016|"

CONSTANT STRING	c_SliderTickPlacementTopLeft= "017|"
CONSTANT STRING	c_SliderTickPlacementBotRight= "018|"

//-----------------------------------------------------------------------------------------
//  Slider Object Instance Variables
//-----------------------------------------------------------------------------------------

STRING  			i_SliderIndicator 		= "sliderup.bmp" 
STRING			i_SliderBGColor 		= "12632256"
STRING			i_SliderFrameColor 		= "12632256"
STRING			i_SliderBarColor 		= "16776960"
STRING			i_SliderCenterLineColor 	= "0"
STRING			i_SliderIndicatorPosition 	= "Out"

STRING			i_SliderFrameBorder 	= "1"
STRING			i_SliderBorder 		= "6"
STRING			i_SliderDirection 		= "Horiz"
BOOLEAN		i_SliderCenterLine 		= FALSE

DECIMAL			i_SliderMajorIncr 		= 1
DECIMAL			i_SliderMinorIncr 		= 0
STRING			i_SliderTickColor 		= "0"

STRING			i_SliderTextSize 		= "-8"
STRING			i_SliderTextFont 		= "Arial"	
STRING 	 		i_SliderTextColor 		= "0"
BOOLEAN		i_SliderText 		= FALSE

INTEGER		i_SliderPosition 		= 0

INTEGER		i_Height
INTEGER		i_Width
INTEGER		i_StartPoint
INTEGER		i_EndPoint
INTEGER		i_BitmapHeight
INTEGER		i_BitmapWidth
INTEGER		i_BitmapX
INTEGER		i_BitmapY
INTEGER		i_TotalPoint
INTEGER		i_BarWidth
INTEGER		i_BarHeight
INTEGER		i_BarX
INTEGER		i_BarY
BOOLEAN		i_SliderMoving
INTEGER		i_PrevPointerX
INTEGER		i_PrevPointerY
INTEGER		i_PointerOffset

//----------------------------------------------------------------------------------------
//  DataWindow syntax instance variable.
//----------------------------------------------------------------------------------------

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

//-----------------------------------------------------------------------------------------
//  DataWindow table syntax instance variable.
//-----------------------------------------------------------------------------------------

STRING	i_TableSyntax = 'table(column=(type=char(10) ' + &
	+ 'name=Slider ' + &
	+ 'dbname="Slider" ) ) '

//-----------------------------------------------------------------------------------------
//  DataWindow text syntax instance variable.
//-----------------------------------------------------------------------------------------

STRING	i_TextSyntax = 'text(band=detail ' + &
	+ 'alignment="2" text="" ' 

end variables

forward prototypes
public function integer fu_slidercreate (decimal startpoint, decimal endpoint)
public function decimal fu_getslider ()
public function integer fu_setslider (decimal position)
public function string fu_getidentity ()
public subroutine fu_setoptions (string optionstyle, string options)
public function integer fu_slideroptions (string indicator, string options)
public subroutine fu_slidertextoptions (string textfont, integer textsize, string options)
public subroutine fu_slidertickoptions (decimal majorincrement, decimal minorincrement, string options)
end prototypes

event po_slidermoving;//******************************************************************
//  PO Module     : u_Slider
//  Event         : po_SliderMoving
//  Description   : Allows the developer to do any processing while
//                  the slider is moving.
//
//  Parameters    : DECIMAL Position - 
//                     Position of the slider.
//
//  Returns       : None.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************
end event

event po_slidermoved;//******************************************************************
//  PO Module     : u_Slider
//  Event         : po_SliderMoved
//  Description   : Allows the developer to do any processing when
//                  the slider stops moving.
//
//  Parameters    : DECIMAL Position - 
//                     Position of the slider.
//
//  Returns       : None.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************
end event

event po_identify;//******************************************************************
//  PO Module     : u_Slider
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

event po_processmoving;//******************************************************************
//  PO Module     : u_Slider
//  Event         : po_ProcessMoving
//  Description   : Moves the slider indicator as the mouse is
//						  dragged over it and calls an event for the 
//                  developer. 
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER	l_PointerX, l_PointerY
STRING	l_ModifyString, l_Error

//------------------------------------------------------------------
//	Only allow the indicator to be moved if i_SliderMoving has been
// set to TRUE in the clicked event.
//------------------------------------------------------------------

IF i_SliderMoving THEN
	l_PointerX = UnitsToPixels( (PointerX()), xUnitsToPixels! )
	l_PointerY = UnitsToPixels( (PointerY()), yUnitsToPixels! )

	//------------------------------------------------------------
	//	Only allow the indicator to be moved if the mouse cursor
	// is inside the slider object.
	//------------------------------------------------------------

	IF PointerX() >= 0 AND PointerX() <= Width AND &
	   PointerY() >= 0 AND PointerY() <= Height THEN

		//---------------------------------------------------------
		//	Determine the new coordinates for the indicator
		// based upon the direction of the slider and whether the
		// indicator is inside or outside the bar. Check the 
		// boundaries of the slider bar, to make sure that the
		// indicator cannot move outside them.  
		//---------------------------------------------------------

		IF i_SliderDirection = "Horiz" THEN
			IF i_PrevPointerX <> l_PointerX THEN
				i_BitmapX = l_PointerX - i_PointerOffset
				IF i_SliderIndicatorPosition = "Out" THEN
					IF i_BitmapX + ( i_BitmapWidth / 2 ) < i_BarX THEN
						i_BitmapX = i_BarX - ( i_BitMapWidth / 2 )
					ELSEIF i_BitmapX + ( i_BitmapWidth / 2 ) > &
												i_BarX + i_BarWidth THEN
						i_BitmapX = i_BarX + i_BarWidth - &
										( i_BitmapWidth / 2 )
					END IF
				ELSE
					IF i_BitmapX < i_BarX THEN
						i_BitmapX = i_BarX 
					ELSEIF i_BitmapX + ( i_BitmapWidth ) > &
												i_BarX + i_BarWidth THEN
						i_BitmapX = i_BarX + i_BarWidth - &
										( i_BitmapWidth )
					END IF
				END IF
				l_ModifyString = "sliderbmp.x =" + String(i_BitmapX)
				l_Error = Modify( l_ModifyString )
				i_PrevPointerX = l_PointerX
				SetReDraw(TRUE)
			END IF
		ELSE
			IF i_PrevPointerY <> l_PointerY THEN
				i_BitmapY = l_PointerY - i_PointerOffset
				IF i_SliderIndicatorPosition = "Out" THEN
					IF i_BitmapY + i_BitmapHeight / 2 < i_BarY THEN
						i_BitmapY = i_BarY - i_BitmapHeight / 2
					ELSEIF i_BitmapY + i_BitmapHeight / 2 > &
							 i_BarY + i_BarHeight THEN
						i_BitmapY = i_BarY + i_BarHeight - &
										( i_BitmapHeight / 2 )
					END IF
				ELSE
					IF i_BitmapY < i_BarY THEN
						i_BitmapY = i_BarY 
					ELSEIF i_BitmapY + i_BitmapHeight > &
							 i_BarY + i_BarHeight THEN
						i_BitmapY = i_BarY + i_BarHeight - &
										( i_BitmapHeight )
					END IF
				END IF
				l_ModifyString = "sliderbmp.y =" + String(i_BitmapY)
				l_Error = Modify( l_ModifyString )
				i_PrevPointerY = l_PointerY
				SetReDraw(TRUE)
			END IF
		END IF
	END IF
	
	Event po_SliderMoving(fu_GetSlider())
END IF
end event

event po_processmoved;//******************************************************************
//  PO Module     : u_Slider
//  Event         : po_ProcessMoved
//  Description   : Sets i_SliderMoving to FALSE when the mouse is
//                  released and calls an event for the developer.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_SliderMoving = FALSE

Event po_SliderMoved(fu_GetSlider())
end event

public function integer fu_slidercreate (decimal startpoint, decimal endpoint);//******************************************************************
//  PO Module     : u_Slider
//  Subroutine    : fu_SliderCreate
//  Description   : Responsible for creating the slider
//						  datawindow object.
//
//  Parameters    : DECIMAL StartPoint - 
//                     The starting major increment value.
//						  DECIMAL EndPoint - 
//                     The ending major increment value.
//
//  Return Value  : INTEGER -
//                     0 - create successful.
//						    -1 - create failed. 
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING 	l_DWSyntax, l_BGSyntax, l_BarSyntax
STRING	l_MajorLineSyntax, l_MinorLineSyntax, l_TextSyntax
STRING 	l_CenterLineSyntax, l_BitmapSyntax
STRING 	l_HeightString, l_TextString

INTEGER 	l_Error, l_Idx, l_Jdx
INTEGER	l_X, l_Y
INTEGER	l_Origin, l_MajorOrigin
INTEGER	l_TotalMajor, l_TotalMinor 
INTEGER	l_MajorLineHeight, l_MajorLineWidth
INTEGER	l_MinorLineHeight, l_MinorLineWidth
INTEGER  l_MajorIncrHeight, l_MajorIncrWidth
INTEGER	l_MajorLineX1, l_MajorLineX2, l_MajorLineY1, l_MajorLineY2
INTEGER	l_MinorLineX1, l_MinorLineX2, l_MinorLineY1, l_MinorLineY2
INTEGER	l_TextHeight, l_TextY, l_TextWidth, l_TextX
INTEGER	l_CenterLineX, l_CenterLineY
INTEGER	l_CenterLineHeight, l_CenterLineWidth

i_StartPoint = StartPoint
i_EndPoint = EndPoint

//------------------------------------------------------------------
//	Build the syntax needed to create the datawindow object
//------------------------------------------------------------------

l_HeightString = "height = " + String(Height)

l_DWSyntax = i_DWSyntax + &
				'color =' + i_SliderBGColor + ')' + &
 				'detail(' + l_heightstring + ' ' + &
				'color= "' + i_SliderBGColor + '" ) '

//------------------------------------------------------------------
//	Adjust the dimensions of the slider to leave room for
// a frame border, depending upon the frame border type.
//------------------------------------------------------------------

l_x = 0
l_y = -1
i_Width = UnitsToPixels( Width, xUnitsToPixels! )
i_Height = UnitsToPixels( Height, yUnitsToPixels! )

CHOOSE CASE i_SliderFrameBorder
CASE "0"
CASE "1"
	l_x = l_x + 1
	l_y = l_y + 1
	i_Width = i_width - 5
	i_height = i_Height - 4
CASE "2"
	l_x = l_x + 1
	l_y = l_y + 1
	i_Width = i_width - 2
	i_height = i_Height - 2
CASE "5"
	l_x = l_x + 2
	l_y = l_y + 2
	i_Width = i_width - 3
	i_height = i_Height - 3
CASE "6"
	l_x = l_x + 1
	l_y = l_y + 1
	i_Width = i_width - 3
	i_height = i_Height - 3
END CHOOSE

//------------------------------------------------------------------
//	Build the syntax needed to create the slider frame, which is a
// datawindow text field.
//------------------------------------------------------------------

l_BGSyntax = i_TextSyntax + &
				'border="' + i_SliderFrameBorder + '" ' + &
				'color="' + i_SliderFrameColor + '" ' + &
				'x="' + String(l_x) + '" ' + &
				'y="' + String(l_y) + '" ' + &
				'height="' + String(i_Height) + '" ' + &
				'width="' + String(i_Width) + '" ' + &
				'name=FrameBG ' + &
				'background.mode="0" ' + &
				'background.color="' + i_SliderFrameColor + '" ) '

//------------------------------------------------------------------
//	Determine the coordinates of the slider bar based on whether
// the indicator is to be placed inside or outside the slider, 
// and the direction of the slider.
//------------------------------------------------------------------

IF i_SliderDirection = "Horiz" THEN
	IF i_SliderIndicatorPosition = "Out" THEN
		i_BarY = i_Height / 6
		i_BarHeight = i_Height - ( i_BarY * 3 )
		i_BarX = i_BarY
		i_BarWidth = i_Width - ( i_BarX * 2 )
	ELSE
		i_BarX = i_Height / 6
		i_BarWidth = i_width - ( i_BarX * 2 ) 
		i_BarY = i_BarX
		i_BarHeight = i_Height - ( i_BarY * 2 )
	END IF
ELSE
	IF i_SliderIndicatorPosition = "Out" THEN
		i_BarY = i_Width / 6
		i_BarHeight = i_Height - ( i_BarY * 2 )
		i_BarX = i_BarY
		i_BarWidth = i_Width - ( i_BarX * 3 )
	ELSE
		i_BarX = i_Width / 6
		i_BarWidth = i_width - ( i_BarX * 2 ) 
		i_BarY = i_BarX
		i_BarHeight = i_Height - ( i_BarY * 2 )
	END IF
END IF

//------------------------------------------------------------------
// Adjust the origin of the slider bar wih respect the origin of the
// slider object. 
//------------------------------------------------------------------

i_BarX = i_BarX + l_x
i_BarY = i_BarY + l_y

//------------------------------------------------------------------
//	Determine the dimensions of the slider indicator if it is to be
// placed outside the slider bar. This calculation needs to be
// performed before adjusting for the slider bar border.
//------------------------------------------------------------------

IF i_SliderDirection = "Horiz" THEN
	IF i_SliderIndicatorPosition = "Out" THEN
		i_BitmapHeight = i_Height - i_BarHeight - i_BarY - 2 
		i_BitmapWidth = i_BitmapHeight
		i_BitmapY = i_BarY + i_BarHeight + 1
	END IF
ELSEIF i_SliderDirection = "Vert" THEN
	IF i_SliderIndicatorPosition = "Out" THEN
		i_BitmapWidth = i_Width - i_BarWidth - i_BarX - 2 
		i_BitmapHeight = i_BitmapWidth
		i_BitmapX = i_BarX + i_BarWidth + 1
	END IF
END IF

//------------------------------------------------------------------
//	Adjust the dimensions of the slider bar to leave room for a 
// border, depending upon the border type.
//------------------------------------------------------------------

CHOOSE CASE i_SliderBorder
CASE "0"
CASE "1"
	i_Barx = i_Barx + 1
	i_Bary = i_Bary + 1
	i_BarWidth = i_Barwidth - 5
	i_Barheight = i_BarHeight - 4
CASE "2"
	i_Barx = i_Barx + 1
	i_Bary = i_Bary + 1
	i_BarWidth = i_Barwidth - 2
	i_Barheight = i_BarHeight - 2
CASE "5"
	i_Barx = i_Barx + 2
	i_Bary = i_Bary + 2
	i_BarWidth = i_Barwidth - 3
	i_Barheight = i_BarHeight - 3
CASE "6"
	i_Barx = i_Barx + 1
	i_Bary = i_Bary + 1
	i_BarWidth = i_BarWidth - 3
	i_Barheight = i_BarHeight - 3
END CHOOSE

//------------------------------------------------------------------
//	If the indicator is placed inside the slider bar, adjust its
// dimensions based on the inside edge of the slider bar.
//------------------------------------------------------------------

IF i_SliderDirection = "Horiz" THEN
	IF i_SliderIndicatorPosition = "Out" THEN
		i_BitmapX = i_BarX - ( i_BitmapWidth + 1 ) / 2
	ELSE
		i_BitmapY = i_BarY + 1
		i_BitmapHeight = i_BarHeight - 2
		i_BitmapWidth = i_BitmapHeight / 2
		i_BitmapX = i_BarX
		IF i_SliderIndicator = "sliderup.bmp" THEN
			i_SliderIndicator = "sliderth.bmp"
		END IF
	END IF
ELSE
	IF i_SliderIndicatorPosition = "Out" THEN
		i_BitmapY = i_BarY + i_BarHeight - ( i_BitmapHeight + 1 ) / 2
		IF i_SliderIndicator = "sliderup.bmp" THEN
			i_SliderIndicator = "sliderlp.bmp"
		END IF
	ELSE
		i_BitmapX = i_BarX + 1
		i_BitmapWidth = i_BarWidth - 2
		i_BitmapHeight = i_BitmapWidth / 2
		i_BitmapY = i_BarY + i_BarHeight - i_BitmapHeight
		IF i_SliderIndicator = "sliderup.bmp" THEN
			i_SliderIndicator = "sliderth.bmp"
		END IF
	END IF
END IF


//------------------------------------------------------------------
//	Build the syntax needed to create the slider bar, which is a
// datawindow text field.
//------------------------------------------------------------------

l_BarSyntax = i_TextSyntax + &
				'border="' + i_SliderBorder + '" ' + &
				'color="' + i_SliderBarColor + '" ' + &
				'x="' + String(i_BarX) + '" ' + &
				'y="' + String(i_BarY) + '" ' + &
				'height="' + String(i_BarHeight) + '" ' + &
				'width="' + String(i_BarWidth) + '" ' + &
				'name=SliderBar ' + &
				'background.mode="0" ' + &
				'background.color="' + i_SliderBarColor + '" ) '

l_DWSyntax = l_DWSyntax + i_TableSyntax + &
				 l_BGSyntax + l_BarSyntax

//------------------------------------------------------------------
//	Determine the number of major and minor tick marks.
//------------------------------------------------------------------

l_totalmajor = ( endpoint - startpoint ) / i_SliderMajorIncr

IF i_SliderMinorIncr > 0 THEN
	l_totalminor = ( i_SliderMajorIncr / i_SliderMinorIncr )
END IF

//------------------------------------------------------------------
//	Build the syntax for the major and minor tick mark lines.
//------------------------------------------------------------------

IF i_SliderDirection = "Horiz" THEN
	l_MajorLineHeight = i_BarHeight * .6
	l_MajorLineY1 = i_BarY + ( i_BarHeight / 2 ) - &
									 ( l_MajorLineHeight / 2 )
	l_MajorLineY2 = l_MajorLineY1 + l_MajorLineHeight
	l_MajorIncrHeight = l_MajorLineY2 - l_MajorLineY1
	IF i_SliderIndicatorPosition = "Out" THEN
		l_Origin = i_BarX
	ELSE
		l_MajorOrigin = i_BarX + ( i_BitmapWidth / 2 )
		l_Origin = l_MajorOrigin
	END IF
ELSE
	l_MajorLineWidth = i_BarWidth * .6
	l_MajorLineX1 = i_BarX + ( i_BarWidth / 2 ) - &
									 ( l_MajorLineWidth / 2 )
	l_MajorLineX2 = l_MajorLineX1 + l_MajorLineWidth
	l_MajorIncrWidth = l_MajorLineX2 - l_MajorLineX1

	IF i_SliderIndicatorPosition = "Out" THEN
		l_Origin = i_BarY
	ELSE
		l_MajorOrigin = i_BarY + ( i_BitmapHeight / 2 )
		l_Origin = l_MajorOrigin
	END IF
END IF

FOR l_Idx = 1 TO l_TotalMajor
  IF l_Idx < l_TotalMajor THEN
		IF i_SliderDirection = "Horiz" THEN
			IF i_SliderIndicatorPosition = "Out" THEN
				l_MajorLineX1 = i_BarX + ( (i_BarWidth / &
												 l_TotalMajor ) * l_Idx )
			ELSE
				l_MajorLineX1 = l_MajorOrigin + ( ((i_BarWidth - &
									 i_BitmapWidth ) / l_TotalMajor) * l_Idx )
			END IF
			l_MajorLineX2 = l_MajorLineX1
			l_MajorIncrWidth = l_MajorLineX1 - l_Origin
		ELSE
			IF i_SliderIndicatorPosition = "Out" THEN
				l_MajorLineY1 = i_BarY + ( (i_BarHeight / &
													 l_TotalMajor ) * l_Idx )
			ELSE
				l_MajorLineY1 = l_MajorOrigin + ( ((i_BarHeight - &
									 i_BitmapHeight) / l_TotalMajor) * l_Idx )
			END IF
			l_MajorLineY2 = l_MajorLineY1
			l_MajorIncrHeight = l_MajorLineY1 - l_Origin
		END IF

		//--------------------------------------------------------------
		//	If the user has opted to show text on the slider, build
		// the syntax for the text. Otherwise build the syntax to
		// display the major tick marks.
		//--------------------------------------------------------------

		IF i_SliderText THEN
			IF i_SliderDirection = "Horiz" THEN
				l_TextString = STRING( i_SliderMajorIncr * l_Idx)
//											 ( l_TotalMajor - l_idx )) 
				l_TextHeight = ABS(INTEGER( i_SliderTextSize ) )
				l_TextY = i_BarY + ( i_BarHeight / 2 ) - &
									 	( l_TextHeight / 2 ) 
				l_TextWidth = i_BarWidth / l_TotalMajor
				l_TextX = l_MajorLineX1 - l_TextWidth / 2
			ELSE
				l_TextString = STRING ( i_SliderMajorIncr * &
											 ( l_TotalMajor - l_idx )) 
				l_TextHeight = ABS(INTEGER( i_SliderTextSize )) 
				l_TextWidth = i_BarWidth 
				l_TextX = i_BarX 
				l_TextY = ( l_MajorLineY1 - l_TextHeight / 2 )
			END IF

			l_TextSyntax = 'text(band=detail alignment="2" ' + &
					'text="' + l_textstring + '" ' + &
					'border="0" ' + &
					'color="' + i_SliderTextColor + '" ' + &
					'x="' + String(l_TextX) + '" ' + &
					'y="' + String(l_TextY) + '" ' + &
					'height="' + String(l_TextHeight) + '" ' + &
					'width="' + String(l_TextWidth) + '" ' + &
					'name=SliderText ' + &
					'font.face="' + i_SliderTextFont + '" ' + &
					'font.height="' + String(l_TextHeight) + '" ' + &
					'font.weight="400" ' + &
					'font.family="2" ' + &
					'font.pitch="2" ' + &
					'font.charset="0" ' + &
					'background.mode="1" ' + &
					'background.color="255" ) '

	 	l_DWSyntax = l_DWSyntax + l_TextSyntax

	ELSE

		l_MajorLineSyntax = 'line(band=detail ' + &
						'x1="' + String(l_MajorLineX1) + '" ' + &
						'y1="' + String(l_MajorLineY1) + '" ' + &
						'x2="' + String(l_MajorLineX2) + '" ' + &
						'y2="' + String(l_MajorLineY2) + '" ' + &
						'pen.style="0" pen.width="1" pen.color="' + i_SliderTickColor + '" ' + &
						'background.mode="2" ' + &
						'background.color="' + i_SliderTickColor + '" ) '

	 	l_DWSyntax = l_DWSyntax + l_MajorLineSyntax
	END IF

 END IF

 IF i_SliderMinorIncr > 0 THEN

  FOR l_Jdx = 1 TO l_TotalMinor - 1

		IF i_SliderDirection = "Horiz" THEN
			l_MinorLineHeight = i_BarHeight * .4

			l_MinorLineY1 = i_BarY + ( i_BarHeight / 2 ) - &
											 ( l_MinorLineHeight / 2 )
			l_MinorLineY2 = l_MinorLineY1 + l_MinorLineHeight
			l_MinorLineX1 = l_Origin + ( (l_MajorIncrWidth / &
													l_TotalMinor) * l_Jdx )
			l_MinorLineX2 = l_MinorLineX1
			
		ELSE
			l_MinorLineWidth = i_BarWidth * .4

			l_MinorLineX1 = i_BarX + ( i_BarWidth / 2 ) - &
											 ( l_MinorLineWidth / 2 )
			l_MinorLineX2 = l_MinorLineX1 + l_MinorLineWidth
	
			l_MinorLineY1 = l_Origin + ( (l_MajorIncrHeight / &
													l_TotalMinor) * l_Jdx )
			l_MinorLineY2 = l_MinorLineY1
		END IF

		l_MinorLineSyntax = 'line(band=detail ' + &
							'x1="' + String(l_MinorLineX1) + '" ' + &
							'y1="' + String(l_MinorLineY1) + '" ' + &
							'x2="' + String(l_MinorLineX2) + '" ' + &
							'y2="' + String(l_MinorLineY2) + '" ' + &
							'pen.style="0" pen.width="1" pen.color="' + i_SliderTickColor + '" ' + &
							'background.mode="2" ' + &
							'background.color="' + i_SliderTickColor + '" ) '

		l_DWSyntax = l_DWSyntax + l_MinorLineSyntax

	END FOR
 END IF

 IF i_SliderDirection = "Horiz" THEN
	l_Origin = l_MajorLineX1
 ELSE
	l_Origin = l_MajorLineY1
 END IF

END FOR

//------------------------------------------------------------------
//	Build the syntax needed to create the slider center line, which 
// is a rectangle.
//------------------------------------------------------------------

IF i_SliderCenterLine THEN
	IF i_SliderDirection = "Horiz" THEN
		l_CenterLineWidth = i_BarWidth * .93
		l_CenterLineHeight = i_BarHeight / 10
		l_CenterLineX = i_BarX + ((i_Barwidth / 2) - &
										 (l_CenterLineWidth / 2))
		l_CenterLineY = i_BarY + ((i_BarHeight /2) - &
										 (l_CenterLineHeight / 2))
	ELSE
		l_CenterLineHeight = i_BarHeight * .93
		l_CenterLineWidth = i_BarWidth / 10
		l_CenterLineX = i_BarX + ((i_Barwidth / 2) - &
										  (l_CenterLineWidth / 2))
		l_CenterLineY = i_BarY + ((i_BarHeight /2) - &
										  (l_CenterLineHeight / 2))
	END IF
	l_CenterLineSyntax = 'rectangle(band=detail ' + &
						'x="' + String(l_CenterLineX) + '" ' + &
						'y="' + String(l_CenterLineY) + '" ' + &
						'height="' + String(l_CenterLineHeight) + '" ' + &
						'width="' + String(l_CenterLineWidth) + '" ' + &
						'brush.hatch="6" ' + &
						'brush.color="' + i_SliderCenterLineColor + '" ' + &
						'pen.style="0" pen.width="0" ' + &
						'pen.color="' + i_SliderCenterLineColor + '" ' + &
						'background.mode="2" ' + &
						'background.color="' + i_SliderCenterLineColor + '" ) '

	l_DWSyntax = l_DWSyntax + l_CenterLineSyntax

END IF


//------------------------------------------------------------------
//	Build the syntax needed to create the slider indicator.
//------------------------------------------------------------------

l_BitmapSyntax = 'bitmap(band=detail ' + &
					  'filename="' + i_SliderIndicator + '"' + &
					  'x="' + String(i_BitmapX) + '" ' + &
					  'y="' + String(i_BitmapY) + '" ' + &
					  'height="' + String(i_BitmapHeight) + '" ' + &
					  'width="' + String(i_BitmapWidth) + '" ' + &
					  'name=sliderbmp border="0" )'

l_DWSyntax = l_DWSyntax + l_BitmapSyntax

//------------------------------------------------------------------
//	Create the slider.
//------------------------------------------------------------------

l_Error = Create( l_DWSyntax )
InsertRow(0)

RETURN 0


end function

public function decimal fu_getslider ();//******************************************************************
//  PO Module     : u_Slider
//  Subroutine    : fu_GetSlider
//  Description   : Responsible for determining the position of the
//					     slider indicator. 
//
//  Parameters    : (None)	
//
//  Return Value  : DECIMAL - 
//                     The current position of the slider indicator.	
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

DECIMAL	l_Position

IF i_SliderDirection = "Horiz" THEN
	IF i_SliderIndicatorPosition = "Out" THEN
		l_Position = i_BitmapX + i_BitmapWidth / 2 - i_BarX
		l_Position = l_Position / i_BarWidth * &
						 	( i_EndPoint - i_StartPoint ) + i_StartPoint
	ELSE
		l_Position = i_BitmapX - i_BarX
		l_Position = l_Position / (i_BarWidth - i_BitmapWidth) * &
							( i_EndPoint - i_StartPoint ) + i_StartPoint
	END IF
ELSE
	IF i_SliderIndicatorPosition = "Out" THEN
		l_Position = i_BitmapY + i_BitmapHeight / 2 - i_BarY
		l_Position = 1 - l_Position / (i_BarHeight )
		l_Position = l_Position * ( i_EndPoint - i_StartPoint ) + &
							i_StartPoint
	ELSE
		l_Position = i_BitmapY - i_BarY
		l_Position = 1 - l_Position / (i_BarHeight - i_BitmapHeight)
		l_Position = l_Position * ( i_EndPoint - i_StartPoint ) + &
							i_StartPoint
	END IF
END IF

RETURN l_Position






end function

public function integer fu_setslider (decimal position);//******************************************************************
//  PO Module     : u_Slider
//  Subroutine    : fu_SetSlider
//  Description   : Responsible for setting the position of the
//					     slider indicator. 
//
//  Parameters    : DECIMAL Position - 
//                     The new slider position.
//
//  Return Value  : INTEGER -
//                     0 - set position successful.
//						    -1 - set position failed. 
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING	l_Error, l_ModifyString
DECIMAL	l_Position

IF i_SliderDirection = "Horiz" THEN
	l_Position = position - i_StartPoint
	IF i_SliderIndicatorPosition = "Out" THEN
		l_Position = l_Position / (i_EndPoint - i_StartPoint ) * &
							i_BarWidth
		i_BitmapX = i_BarX + l_Position - ( i_BitmapWidth / 2 ) 
	ELSE
		l_Position = l_Position / (i_EndPoint - i_StartPoint ) * &
							(i_BarWidth - i_BitmapWidth)
		i_BitmapX = i_BarX + l_Position 
	END IF
	l_ModifyString = "sliderbmp.x =" + String(i_BitmapX)
	l_Error = Modify(l_ModifyString)
	IF l_Error <> "" THEN
		RETURN -1
	END IF
ELSE
	IF i_SliderIndicatorPosition = "Out" THEN
		l_Position = (1 - (( position - i_StartPoint ) / &
							(i_EndPoint - i_StartPoint ))) * (i_BarHeight)
		i_BitmapY = i_BarY + l_Position - ( i_BitmapHeight ) / 2 
	ELSE
		i_BitmapY = (1 - (( position - i_StartPoint ) / &
							(i_EndPoint - i_StartPoint ))) * &
							(i_BarHeight - i_BitmapHeight)
		i_BitmapY = i_BarY + i_BitmapY
	END IF
	l_ModifyString = "sliderbmp.y =" + String(i_BitmapY)
	l_Error = Modify(l_ModifyString)
	IF l_Error <> "" THEN
		RETURN -1
	END IF
END IF

SetReDraw(TRUE)

RETURN 0 





end function

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_Slider
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
//  PO Module     : u_Slider
//  Subroutine    : fu_SetOptions
//  Description   : Sets visual defaults and options.  This function
//                  is used by all the option functions (i.e.
//                  fu_SliderOptions).  It is also called by the
//                  Constructor event to set initial defaults.  
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
		
//------------------------------------------------------------------
//  Set slider options and defaults.
//------------------------------------------------------------------

CASE "General"

   //---------------------------------------------------------------
   //  Slider background color.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderBGGray) > 0 THEN
		i_SliderBGColor = String(OBJCA.MGR.c_Gray)       
	ELSEIF Pos(Options, c_SliderBGBlack) > 0 THEN  
		i_SliderBGColor = String(OBJCA.MGR.c_Black)       
	ELSEIF Pos(Options, c_SliderBGWhite) > 0 THEN   
		i_SliderBGColor = String(OBJCA.MGR.c_White)       
	ELSEIF Pos(Options, c_SliderBGDarkGray) > 0 THEN    
		i_SliderBGColor = String(OBJCA.MGR.c_DarkGray)       
	ELSEIF Pos(Options, c_SliderBGRed) > 0 THEN         
		i_SliderBGColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_SliderBGDarkRed) > 0 THEN     
		i_SliderBGColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_SliderBGGreen) > 0 THEN       
		i_SliderBGColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_SliderBGDarkGreen) > 0 THEN   
		i_SliderBGColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_SliderBGBlue) > 0 THEN        
		i_SliderBGColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_SliderBGDarkBlue) > 0 THEN    
		i_SliderBGColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_SliderBGMagenta) > 0 THEN    
		i_SliderBGColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_SliderBGDarkMagenta) > 0 THEN 
		i_SliderBGColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_SliderBGCyan) > 0 THEN        
		i_SliderBGColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_SliderBGDarkCyan) > 0 THEN    
		i_SliderBGColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_SliderBGYellow) > 0 THEN      
		i_SliderBGColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_SliderBGDarkYellow) > 0 THEN  
		i_SliderBGColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF

   //---------------------------------------------------------------
   //  Slider frame color.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderFrameGray) > 0 THEN
		i_SliderFrameColor = String(OBJCA.MGR.c_Gray)       
	ELSEIF Pos(Options, c_SliderFrameBlack) > 0 THEN  
		i_SliderFrameColor = String(OBJCA.MGR.c_Black)       
	ELSEIF Pos(Options, c_SliderFrameWhite) > 0 THEN   
		i_SliderFrameColor = String(OBJCA.MGR.c_White)       
	ELSEIF Pos(Options, c_SliderFrameDarkGray) > 0 THEN    
		i_SliderFrameColor = String(OBJCA.MGR.c_DarkGray)       
	ELSEIF Pos(Options, c_SliderFrameRed) > 0 THEN         
		i_SliderFrameColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_SliderFrameDarkRed) > 0 THEN     
		i_SliderFrameColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_SliderFrameGreen) > 0 THEN       
		i_SliderFrameColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_SliderFrameDarkGreen) > 0 THEN   
		i_SliderFrameColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_SliderFrameBlue) > 0 THEN        
		i_SliderFrameColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_SliderFrameDarkBlue) > 0 THEN    
		i_SliderFrameColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_SliderFrameMagenta) > 0 THEN     
		i_SliderFrameColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_SliderFrameDarkMagenta) > 0 THEN 
		i_SliderFrameColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_SliderFrameCyan) > 0 THEN        
		i_SliderFrameColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_SliderFrameDarkCyan) > 0 THEN    
		i_SliderFrameColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_SliderFrameYellow) > 0 THEN      
		i_SliderFrameColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_SliderFrameDarkYellow) > 0 THEN 
		i_SliderFrameColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF

   //---------------------------------------------------------------
   //  Slider bar color.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderBarGray) > 0 THEN
		i_SliderBarColor = String(OBJCA.MGR.c_Gray)       
	ELSEIF Pos(Options, c_SliderBarBlack) > 0 THEN  
		i_SliderBarColor = String(OBJCA.MGR.c_Black)       
	ELSEIF Pos(Options, c_SliderBarWhite) > 0 THEN   
		i_SliderBarColor = String(OBJCA.MGR.c_White)       
	ELSEIF Pos(Options, c_SliderBarDarkGray) > 0 THEN    
		i_SliderBarColor = String(OBJCA.MGR.c_DarkGray)       
	ELSEIF Pos(Options, c_SliderBarRed) > 0 THEN         
		i_SliderBarColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_SliderBarDarkRed) > 0 THEN     
		i_SliderBarColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_SliderBarGreen) > 0 THEN       
		i_SliderBarColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_SliderBarDarkGreen) > 0 THEN   
		i_SliderBarColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_SliderBarBlue) > 0 THEN        
		i_SliderBarColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_SliderBarDarkBlue) > 0 THEN    
		i_SliderBarColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_SliderBarMagenta) > 0 THEN     
		i_SliderBarColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_SliderBarDarkMagenta) > 0 THEN 
		i_SliderBarColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_SliderBarCyan) > 0 THEN        
		i_SliderBarColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_SliderBarDarkCyan) > 0 THEN    
		i_SliderBarColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_SliderBarYellow) > 0 THEN      
		i_SliderBarColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_SliderBarDarkYellow) > 0 THEN  
		i_SliderBarColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF

   //---------------------------------------------------------------
   //  Slider center line color.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderCenterLineGray) > 0 THEN
		i_SliderCenterLineColor = String(OBJCA.MGR.c_Gray)       
	ELSEIF Pos(Options, c_SliderCenterLineBlack) > 0 THEN  
		i_SliderCenterLineColor = String(OBJCA.MGR.c_Black)       
	ELSEIF Pos(Options, c_SliderCenterLineWhite) > 0 THEN   
		i_SliderCenterLineColor = String(OBJCA.MGR.c_White)       
	ELSEIF Pos(Options, c_SliderCenterLineDarkGray) > 0 THEN    
		i_SliderCenterLineColor = String(OBJCA.MGR.c_DarkGray)       
	ELSEIF Pos(Options, c_SliderCenterLineRed) > 0 THEN         
		i_SliderCenterLineColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_SliderCenterLineDarkRed) > 0 THEN     
		i_SliderCenterLineColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_SliderCenterLineGreen) > 0 THEN       
		i_SliderCenterLineColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_SliderCenterLineDarkGreen) > 0 THEN   
		i_SliderCenterLineColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_SliderCenterLineBlue) > 0 THEN        
		i_SliderCenterLineColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_SliderCenterLineDarkBlue) > 0 THEN    
		i_SliderCenterLineColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_SliderCenterLineMagenta) > 0 THEN     
		i_SliderCenterLineColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_SliderCenterLineDarkMagenta) > 0 THEN 
		i_SliderCenterLineColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_SliderCenterLineCyan) > 0 THEN        
		i_SliderCenterLineColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_SliderCenterLineDarkCyan) > 0 THEN   
		i_SliderCenterLineColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_SliderCenterLineYellow) > 0 THEN      
		i_SliderCenterLineColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_SliderCenterLineDarkYellow) > 0 THEN  
		i_SliderCenterLineColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF

   //---------------------------------------------------------------
   //  Slider frame border.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderFrameNone) > 0 THEN
		i_SliderFrameBorder = "0"
	ELSEIF Pos(Options, c_SliderFrameShadowBox) > 0 THEN
		i_SliderFrameBorder = "1"
	ELSEIF Pos(Options, c_SliderFrameBox) > 0 THEN
		i_SliderFrameBorder = "2"
	ELSEIF Pos(Options, c_SliderFrameLowered) > 0 THEN
		i_SliderFrameBorder = "5"
	ELSEIF Pos(Options, c_SliderFrameRaised) > 0 THEN
		i_SliderFrameBorder = "6"
	END IF

   //---------------------------------------------------------------
   //  Slider border.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderBorderNone) > 0 THEN
		i_SliderBorder = "0" 
	ELSEIF Pos(Options, c_SliderBorderShadowBox) > 0 THEN        
		i_SliderBorder = "1"      
	ELSEIF Pos(Options, c_SliderBorderBox) > 0 THEN
		i_SliderBorder = "2"      
	ELSEIF Pos(Options, c_SliderBorderLowered) > 0 THEN
		i_SliderBorder = "5"     
	ELSEIF Pos(Options, c_SliderBorderRaised) > 0 THEN   
		i_SliderBorder = "6"       
	END IF

   //---------------------------------------------------------------
   //  Show slider center line.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderCenterLineShow) > 0 THEN
		i_SliderCenterLine = TRUE    
	ELSEIF Pos(Options, c_SliderCenterLineHide) > 0 THEN
		i_SliderCenterLine = FALSE 
	END IF

   //---------------------------------------------------------------
   //  Slider direction.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderDirectionHoriz) > 0 THEN
		i_SliderDirection = "Horiz"      
	ELSEIF Pos(Options, c_SliderDirectionVert) > 0 THEN
		i_SliderDirection = "Vert"      
	END IF

   //---------------------------------------------------------------
   //  Slider bitmap inside or outside.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderIndicatorOut) > 0 THEN
		i_SliderIndicatorPosition = "Out"      
	ELSEIF Pos(Options, c_SliderIndicatorIn) > 0 THEN
		i_SliderIndicatorPosition = "In"      
	END IF
	
//------------------------------------------------------------------
//  Set slider tick options and defaults.
//------------------------------------------------------------------

CASE "Tick"

   //---------------------------------------------------------------
   //  Slider tick color.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderTickGray) > 0 THEN
		i_SliderTickColor = String(OBJCA.MGR.c_Gray)       
	ELSEIF Pos(Options, c_SliderTickBlack) > 0 THEN 
		i_SliderTickColor = String(OBJCA.MGR.c_Black)       
	ELSEIF Pos(Options, c_SliderTickWhite) > 0 THEN   
		i_SliderTickColor = String(OBJCA.MGR.c_White)       
	ELSEIF Pos(Options, c_SliderTickDarkGray) > 0 THEN    
		i_SliderTickColor = String(OBJCA.MGR.c_DarkGray)       
	ELSEIF Pos(Options, c_SliderTickRed) > 0 THEN         
		i_SliderTickColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_SliderTickDarkRed) > 0 THEN     
		i_SliderTickColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_SliderTickGreen) > 0 THEN       
		i_SliderTickColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_SliderTickDarkGreen) > 0 THEN   
		i_SliderTickColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_SliderTickBlue) > 0 THEN        
		i_SliderTickColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_SliderTickDarkBlue) > 0 THEN    
		i_SliderTickColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_SliderTickMagenta) > 0 THEN     
		i_SliderTickColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_SliderTickDarkMagenta) > 0 THEN 
		i_SliderTickColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_SliderTickCyan) > 0 THEN        
		i_SliderTickColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_SliderTickDarkCyan) > 0 THEN    
		i_SliderTickColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_SliderTickYellow) > 0 THEN      
		i_SliderTickColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_SliderTickDarkYellow) > 0 THEN  
		i_SliderTickColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF
	
//------------------------------------------------------------------
//  Set slider text options and defaults.
//------------------------------------------------------------------

CASE "Text"

   //---------------------------------------------------------------
   //  Slider text color.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderTextGray) > 0 THEN
		i_SliderTextColor = String(OBJCA.MGR.c_Gray)
	ELSEIF Pos(Options, c_SliderTextBlack) > 0 THEN
		i_SliderTextColor = String(OBJCA.MGR.c_Black)
	ELSEIF Pos(Options, c_SliderTextWhite) > 0 THEN
		i_SliderTextColor = String(OBJCA.MGR.c_White)
	ELSEIF Pos(Options, c_SliderTextDarkGray) > 0 THEN
		i_SliderTextColor = String(OBJCA.MGR.c_DarkGray)
	ELSEIF Pos(Options, c_SliderTextRed) > 0 THEN
		i_SliderTextColor = String(OBJCA.MGR.c_Red)       
	ELSEIF Pos(Options, c_SliderTextDarkRed) > 0 THEN
		i_SliderTextColor = String(OBJCA.MGR.c_DarkRed)       
	ELSEIF Pos(Options, c_SliderTextGreen) > 0 THEN       
		i_SliderTextColor = String(OBJCA.MGR.c_Green)       
	ELSEIF Pos(Options, c_SliderTextDarkGreen) > 0 THEN   
		i_SliderTextColor = String(OBJCA.MGR.c_DarkGreen)       
	ELSEIF Pos(Options, c_SliderTextBlue) > 0 THEN        
		i_SliderTextColor = String(OBJCA.MGR.c_Blue)       
	ELSEIF Pos(Options, c_SliderTextDarkBlue) > 0 THEN    
		i_SliderTextColor = String(OBJCA.MGR.c_DarkBlue)       
	ELSEIF Pos(Options, c_SliderTextMagenta) > 0 THEN     
		i_SliderTextColor = String(OBJCA.MGR.c_Magenta)       
	ELSEIF Pos(Options, c_SliderTextDarkMagenta) > 0 THEN 
		i_SliderTextColor = String(OBJCA.MGR.c_DarkMagenta)       
	ELSEIF Pos(Options, c_SliderTextCyan) > 0 THEN        
		i_SliderTextColor = String(OBJCA.MGR.c_Cyan)       
	ELSEIF Pos(Options, c_SliderTextDarkCyan) > 0 THEN    
		i_SliderTextColor = String(OBJCA.MGR.c_DarkCyan)       
	ELSEIF Pos(Options, c_SliderTextYellow) > 0 THEN      
		i_SliderTextColor = String(OBJCA.MGR.c_Yellow)       
	ELSEIF Pos(Options, c_SliderTextDarkYellow) > 0 THEN  
		i_SliderTextColor = String(OBJCA.MGR.c_DarkYellow)       
	END IF

   //---------------------------------------------------------------
   //  Show slider text.
   //---------------------------------------------------------------

	IF Pos(Options, c_SliderTextShow) > 0 THEN
		i_SliderText = TRUE    
	ELSEIF Pos(Options, c_SliderTextHide) > 0 THEN
	   i_SliderText = FALSE 
	END IF

END CHOOSE

end subroutine

public function integer fu_slideroptions (string indicator, string options);//******************************************************************
//  PO Module     : u_Slider
//  Subroutine    : fu_SliderOptions
//  Description   : Establishes the look-and-feel of the slider
//                  object.  
//
//  Parameters    : STRING Indicator - 
//                     Bitmap to be used for the slider.
//						  STRING Options - 
//                     Visual options for the slider.
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
//  Set the bitmap name for the slider. 
//------------------------------------------------------------------

IF Indicator <> c_DefaultIndicator THEN
   i_SliderIndicator = Indicator
END IF

//------------------------------------------------------------------
//  Set the slider visual options. 
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   fu_SetOptions("General", Options)
END IF

RETURN 0
end function

public subroutine fu_slidertextoptions (string textfont, integer textsize, string options);//******************************************************************
//  PO Module     : u_Slider
//  Subroutine    : fu_SliderTextOptions
//  Description   : Establishes the look-and-feel of the slider
//                  text.  
//
//  Parameters    : STRING  TextFont - 
//                     Text font to be used for the slider text.
//                  INTEGER TextSize - 
//                     Height of the slider text in pixels.
//						  STRING  Options - 
//                     Visual options for the slider.
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
//  Set the font type of the slider text.
//------------------------------------------------------------------

IF TextFont <> c_DefaultFont THEN
   i_SliderTextFont = TextFont
END IF

//------------------------------------------------------------------
//  Set the font size of the slider text.
//------------------------------------------------------------------

IF TextSize <> c_DefaultSize THEN
   i_SliderTextSize = STRING(TextSize * -1)
END IF

//------------------------------------------------------------------
//  Set the slider text options.
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   fu_SetOptions("Text", Options)
END IF

end subroutine

public subroutine fu_slidertickoptions (decimal majorincrement, decimal minorincrement, string options);//******************************************************************
//  PO Module     : u_Slider
//  Subroutine    : fu_SliderTickOptions
//  Description   : Establishes the tick positions and color
//						  of the slider object.
//
//  Parameters    : DECIMAL MajorIncrement -
//                     The major increment size in pixels.
//                  DECIMAL MinorIncrement - 
//                     The minor increment size in pixels.
//						  STRING  Options - 
//                     Visual options for the slider tick marks.
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
//  Set the increment values. 
//------------------------------------------------------------------

IF MinorIncrement <> c_DefaultMinorIncr THEN
   i_SliderMinorIncr = MinorIncrement
END IF

IF MajorIncrement <> c_DefaultMajorIncr THEN
   i_SliderMajorIncr = MajorIncrement
END IF

//------------------------------------------------------------------
//  Set the slider tick options. 
//------------------------------------------------------------------

IF Options <> c_DefaultVisual THEN
   fu_SetOptions("Tick", Options)
END IF

end subroutine

event clicked;//******************************************************************
//  PO Module     : u_Slider
//  Event         : Clicked
//  Description   : Controls actions when the user holds down
//						  the left mouse button while inside the
//						  slider object.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING	l_ClickedObject, l_ModifyString, l_Error
INTEGER	l_PointerX, l_PointerY

//------------------------------------------------------------------
// Determine the object on which the mouse pointer is currently 
// positioned.
//------------------------------------------------------------------

l_ClickedObject = GetObjectAtPointer()
l_ClickedObject = Left(l_ClickedObject, POS(l_ClickedObject, "~t") - 1)

IF l_ClickedObject = "sliderbmp" THEN

	//--------------------------------------------------------------
	// If the mouse is currently postioned on the slider indicator,
	// determine the distance it has moved from its previous
	// position.
	//--------------------------------------------------------------

	IF i_SliderDirection = "Horiz" THEN
		i_PrevPointerX = UnitsToPixels( ABS(PointerX()), xUnitsToPixels! )
		i_PointerOffset = i_PrevPointerX - i_BitmapX
	ELSE
		i_PrevPointerY = UnitsToPixels( ABS(PointerY()), yUnitsToPixels! )
		i_PointerOffset = i_PrevPointerY - i_BitmapY
	END IF	
	i_SliderMoving = TRUE
ELSE

	//--------------------------------------------------------------
	// If the mouse is currently postioned inside the slider bar,
	// change the indicator coordinates to the new position.
	//--------------------------------------------------------------

	l_PointerX = UnitsToPixels( ABS(PointerX()), xUnitsToPixels! )
	l_PointerY = UnitsToPixels( ABS(PointerY()), yUnitsToPixels! )

	//--------------------------------------------------------------
	// Check to make sure that the mouse pointer is within the 
	// bounds of the slider bar, before adjusting the coordinates.
	//--------------------------------------------------------------

	IF l_PointerX >= i_BarX AND l_PointerX <= i_BarX + i_BarWidth AND &
	   l_PointerY >= i_BarY AND l_PointerY <= i_BarY + i_BarHeight THEN
		IF i_SliderDirection = "Horiz" THEN
			i_BitmapX = l_PointerX - ( i_BitmapWidth / 2 )
			IF i_SliderIndicatorPosition = "Out" THEN
				IF i_BitmapX + ( i_BitmapWidth / 2 ) < i_BarX THEN
					i_BitmapX = i_BarX - ( i_BitMapWidth / 2 )
				ELSEIF i_BitmapX + ( i_BitmapWidth / 2 ) > i_BarX + i_BarWidth THEN
					i_BitmapX = i_BarX + i_BarWidth - ( i_BitmapWidth / 2 )
				END IF
			ELSE
				IF i_BitmapX < i_BarX THEN
					i_BitmapX = i_BarX 
				ELSEIF i_BitmapX + i_BitmapWidth > i_BarX + i_BarWidth THEN
					i_BitmapX = i_BarX + i_BarWidth - ( i_BitmapWidth )
				END IF
			END IF
			l_ModifyString = "sliderbmp.x =" + String(i_BitmapX)
		ELSE
			i_BitmapY = l_PointerY - ( i_BitmapHeight / 2 )
			IF i_SliderIndicatorPosition = "Out" THEN
				IF i_BitmapY + i_BitmapHeight / 2 < i_BarY THEN
					i_BitmapY = i_BarY - i_BitmapHeight / 2
				ELSEIF i_BitmapY + i_BitmapHeight / 2 > i_BarY + i_BarHeight THEN
					i_BitmapY = i_BarY + i_BarHeight - ( i_BitmapHeight / 2 )
				END IF
			ELSE
				IF i_BitmapY < i_BarY THEN
					i_BitmapY = i_BarY 
				ELSEIF i_BitmapY + i_BitmapHeight > i_BarY + i_BarHeight THEN
					i_BitmapY = i_BarY + i_BarHeight - ( i_BitmapHeight )
				END IF
			END IF	
			l_ModifyString = "sliderbmp.y =" + String(i_BitmapY)
		END IF

		//------------------------------------------------------------
		//  Modify the slider datawindow object to display the 
		//	 indicator at the new position.
		//------------------------------------------------------------

		l_Error = Modify(l_ModifyString)
		SetReDraw(TRUE)
	END IF
END IF

end event

event constructor;//******************************************************************
//  PO Module     : u_Slider
//  Event         : Constructor
//  Description   : Initializes the default slider options. 
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Default, l_DefaultFont, l_DefaultSize, l_DefaultIndicator
STRING l_MajorTick, l_MinorTick

//------------------------------------------------------------------
//  Make sure that the border of the slider control is turned off.
//------------------------------------------------------------------

Border = FALSE

//------------------------------------------------------------------
//  Initialize the slider options.
//------------------------------------------------------------------

l_Default = OBJCA.MGR.fu_GetDefault("Slider", "General")
l_DefaultIndicator = OBJCA.MGR.fu_GetDefault("Slider", "Indicator")
fu_SliderOptions(l_DefaultIndicator, l_Default)

//------------------------------------------------------------------
//  Initialize the slider tick options.
//------------------------------------------------------------------

l_Default = OBJCA.MGR.fu_GetDefault("Slider", "Tick")
l_MajorTick = OBJCA.MGR.fu_GetDefault("Slider", "TickMajor")
l_MinorTick = OBJCA.MGR.fu_GetDefault("Slider", "TickMinor")
fu_SliderTickOptions(Dec(l_MajorTick), Dec(l_MinorTick), l_Default)

//------------------------------------------------------------------
//  Initialize the slider text options.
//------------------------------------------------------------------

l_Default = OBJCA.MGR.fu_GetDefault("Slider", "Text")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Slider", "TextFont")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("Slider", "TextSize")
fu_SliderTextOptions(l_DefaultFont, Integer(l_DefaultSize), l_Default)



end event

