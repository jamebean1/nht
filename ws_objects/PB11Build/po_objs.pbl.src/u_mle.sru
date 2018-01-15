$PBExportHeader$u_mle.sru
$PBExportComments$MLE portion of the drop-down MLE class
forward
global type u_mle from multilineedit
end type
end forward

global type u_mle from multilineedit
int Width=494
int Height=360
int TabOrder=1
boolean VScrollBar=true
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event po_ddfocus pbm_custom75
event po_ddprocess pbm_custom74
event po_identify pbm_custom73
end type
global u_mle u_mle

type variables
//-------------------------------------------------------------------------------
//  Drop-down MLE Constants
//-------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName		= "MLE"
CONSTANT INTEGER	c_DefaultDDWidth		= 0
CONSTANT INTEGER	c_DefaultDDHeight		= 0
CONSTANT INTEGER	c_DefaultDDLimit		= 0
CONSTANT STRING	c_DefaultDDFont		= ""
CONSTANT INTEGER	c_DefaultDDSize		= 0
CONSTANT STRING	c_DefaultDDVisual		= "000|"

CONSTANT STRING	c_MLEBorderBox		= "001|"
CONSTANT STRING	c_MLEBorderNone		= "002|"
CONSTANT STRING	c_MLEBorderLowered	= "003|"
CONSTANT STRING	c_MLEBorderRaised	= "004|"
CONSTANT STRING	c_MLEBorderShadowBox	= "005|"

CONSTANT STRING	c_MLEBlack		= "006|"
CONSTANT STRING	c_MLEWhite		= "007|"
CONSTANT STRING	c_MLEGray		= "008|"
CONSTANT STRING	c_MLEDarkGray		= "009|"
CONSTANT STRING	c_MLERed		= "010|"
CONSTANT STRING	c_MLEDarkRed		= "011|"
CONSTANT STRING	c_MLEGreen		= "012|"
CONSTANT STRING	c_MLEDarkGreen		= "013|"
CONSTANT STRING	c_MLEBlue		= "014|"
CONSTANT STRING	c_MLEDarkBlue		= "015|"
CONSTANT STRING	c_MLEMagenta		= "016|"
CONSTANT STRING	c_MLEDarkMagenta	= "017|"
CONSTANT STRING	c_MLECyan		= "018|"
CONSTANT STRING	c_MLEDarkCyan		= "019|"
CONSTANT STRING	c_MLEYellow		= "020|"
CONSTANT STRING	c_MLEDarkYellow		= "021|"

CONSTANT STRING	c_MLEBGWhite		= "022|"
CONSTANT STRING	c_MLEBGBlack		= "023|"
CONSTANT STRING	c_MLEBGGray		= "024|"
CONSTANT STRING	c_MLEBGDarkGray		= "025|"
CONSTANT STRING	c_MLEBGRed		= "026|"
CONSTANT STRING	c_MLEBGDarkRed		= "027|"
CONSTANT STRING	c_MLEBGGreen		= "028|"
CONSTANT STRING	c_MLEBGDarkGreen	= "029|"
CONSTANT STRING	c_MLEBGBlue		= "030|"
CONSTANT STRING	c_MLEBGDarkBlue		= "031|"
CONSTANT STRING	c_MLEBGMagenta		= "032|"
CONSTANT STRING	c_MLEBGDarkMagenta	= "033|"
CONSTANT STRING	c_MLEBGCyan		= "034|"
CONSTANT STRING	c_MLEBGDarkCyan	= "035|"
CONSTANT STRING	c_MLEBGYellow		= "036|"
CONSTANT STRING	c_MLEBGDarkYellow	= "037|"

CONSTANT STRING	c_MLETextRegular		= "038|"
CONSTANT STRING	c_MLETextBold		= "039|"
CONSTANT STRING	c_MLETextItalic		= "040|"
CONSTANT STRING	c_MLETextUnderline	= "041|"

//-------------------------------------------------------------------------------
//  Drop-down MLE Instance Variables.
//-------------------------------------------------------------------------------

BOOLEAN		i_FontSet			= FALSE
BOOLEAN		i_SizeSet			= FALSE
BOOLEAN		i_BGColorSet		= FALSE
BOOLEAN		i_ColorSet		= FALSE
BOOLEAN		i_BorderSet		= FALSE
BOOLEAN		i_StyleSet			= FALSE

STRING			i_MLEDDType
INTEGER		i_MLEDDIndex
STRING			i_MLEDDColumn
INTEGER		i_MLEDDRow

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
INTEGER		i_DDMLEWidth[]
INTEGER		i_DDMLEHeight[]
INTEGER		i_DDTextLimit[]

U_DD_MLE		i_DDObject[]

DATAWINDOW		i_DDDW[]
STRING			i_DDColumn[]

WINDOW		i_Window
USEROBJECT		i_UserObject
STRING			i_ParentObject
INTEGER		i_ParentHeight
DATAWINDOW		i_CurrentDW
BOOLEAN		i_DDClosed
BOOLEAN		i_DDTabOut

end variables

forward prototypes
public function integer fu_ddopen (datawindow dw_name)
public subroutine fu_ddmlewire (u_dd_mle dd_object, integer text_limit, integer percent_width, integer drop_height)
public subroutine fu_ddmlewiredw (datawindow dd_dw, string dd_column, integer text_limit, integer percent_width, integer drop_height)
public subroutine fu_ddkeydown ()
public subroutine fu_ddeditchanged (datawindow dw_name)
public function double fu_ddfindxpos (string dw_column)
public function string fu_getidentity ()
public subroutine fu_mleoptions (string text_font, integer text_size, string options)
end prototypes

event po_ddfocus;//******************************************************************
//  PO Module     : u_MLE
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

IF i_MLEDDType = "OBJECT" THEN
   i_DDObject[i_DDIndex[i_MLEDDIndex]].SetFocus()
ELSE
   i_DDDW[i_DDIndex[i_MLEDDIndex]].SetFocus()
END IF


end event

event po_ddprocess;//******************************************************************
//  PO Module     : u_MLE
//  Event         : po_DDProcess
//  Description   : Displays the MLE under the column using
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

STRING  l_Column, l_DWColumn, l_TempBackColor
INTEGER l_Index, l_ColumnIndex, l_Idx, l_FieldY, l_FirstRow
BOOLEAN l_Found
INTEGER l_ParentHeight, l_Y, l_OffsetDown, l_OffsetUp, l_NewWidth
INTEGER l_NewHeight
DOUBLE  l_X
LONG    l_Row, l_Pos

SetPointer(HourGlass!)

l_Column   = i_CurrentDW.GetColumnName()
l_Row      = i_CurrentDW.GetRow()
l_DWColumn = i_CurrentDW.ClassName() + "." + l_Column

IF l_Column = i_MLEDDColumn AND l_Row = i_MLEDDRow AND i_DDClosed THEN
   i_DDClosed = FALSE
   RETURN
ELSE
   i_DDClosed = FALSE
END IF

//------------------------------------------------------------------
//  Find the DataWindow column to attach the MLE to.
//------------------------------------------------------------------

l_Found = FALSE
FOR l_Idx = 1 TO i_NumDD
   IF i_DDName[l_Idx] = l_DWColumn THEN
      l_Found = TRUE
      l_Index = l_Idx
      l_ColumnIndex = i_DDIndex[l_Idx]
      EXIT
   END IF
NEXT

IF l_Found THEN

   //---------------------------------------------------------------
   //  Grab the values for sizing and postioning the MLE.
   //---------------------------------------------------------------

   i_DDX[l_Index] = i_CurrentDW.X + &
                    Integer(i_CurrentDW.Describe(l_Column + ".X"))
   i_DDY[l_Index] = i_CurrentDW.Y + &
                    Integer(i_CurrentDW.Describe("datawindow.header.height")) + &
                    Integer(i_CurrentDW.Describe(l_Column + ".Y"))
   i_DDWidth[l_Index]  = Integer(i_CurrentDW.Describe(l_Column + ".Width"))
   i_DDHeight[l_Index] = Integer(i_CurrentDW.Describe(l_Column + ".Height"))
   i_DDDetail[l_Index] = Integer(i_CurrentDW.Describe("datawindow.detail.height"))

   IF i_DDMLEWidth[l_Index] > c_DefaultDDWidth THEN
      l_NewWidth = Int(i_DDWidth[l_Index] * (i_DDMLEWidth[l_Index]/100))
   ELSE
      l_NewWidth = i_DDWidth[l_Index]
   END IF

   IF i_DDMLEHeight[l_Index] > c_DefaultDDHeight THEN
      l_NewHeight = i_DDMLEHeight[l_Index]
   ELSE
      l_NewHeight = Int(l_NewWidth * .72)
   END IF

   //---------------------------------------------------------------
   //  Determine if the MLE is on a window or a user object and get
   //  the height for it.
   //---------------------------------------------------------------

   IF i_ParentObject = "WINDOW" THEN
      l_ParentHeight = i_Window.WorkSpaceHeight()
   ELSE
      l_ParentHeight = i_UserObject.Height
   END IF

   //---------------------------------------------------------------
   //  Determine if the MLE needs to be moved to the current 
   //  DataWindow column or if it already there.
   //---------------------------------------------------------------

   i_ParentHeight = l_ParentHeight

   IF l_NewWidth <> Width THEN
      Resize(l_NewWidth, l_NewHeight)
   END IF

   //---------------------------------------------------------------
   //  Set the attributes of the MLE to match the DataWindow
   //  column.
   //---------------------------------------------------------------

   IF i_MLEDDColumn <> l_Column THEN

		//---------------------------------------------------------------
		// If there is an expression in the BackGround.Color then strip
		// off expression and get the default color.
		//---------------------------------------------------------------

		l_TempBackColor = i_CurrentDW.Describe(l_Column + ".Background.Color")
		l_Pos = POS(l_TempBackColor, "~t")
		IF l_Pos <> 0 THEN
			l_TempBackColor = Left(l_TempBackColor, l_Pos - 1)
			BackColor = LONG(Right(l_TempBackColor, Len(l_TempBackColor) - 1))
		ELSE
			BackColor = LONG(i_CurrentDW.Describe(l_Column + ".Background.Color"))
		END IF

      TextColor   = Long(i_CurrentDW.Describe(l_Column + ".Color"))
      TextSize    = Integer(i_CurrentDW.Describe(l_Column + ".Font.Height"))
      FaceName    = i_CurrentDW.Describe(l_Column + ".Font.Face")
		Weight      = Integer(i_CurrentDW.Describe(l_Column + ".Font.Weight"))

      IF Upper(i_CurrentDW.Describe(l_Column + ".Font.Italic")) = "YES" THEN
			Italic = TRUE
		ELSE
			Italic = FALSE
		END IF

      IF Upper(i_CurrentDW.Describe(l_Column + ".Font.Underline")) = "YES" THEN
			Underline = TRUE
		ELSE
			Underline = FALSE
		END IF

     	CHOOSE CASE Integer(i_CurrentDW.Describe(l_Column + ".Font.Family"))
         CASE 0
            FontFamily = AnyFont!
         CASE 1
            FontFamily = Roman!
         CASE 2
            FontFamily = Swiss!
         CASE 3
            FontFamily = Modern!
         CASE 4
            FontFamily = Decorative!
         CASE 5
            FontFamily = AnyFont!
      END CHOOSE

      CHOOSE CASE Integer(i_CurrentDW.Describe(l_Column + ".Font.Pitch"))
         CASE 0
            FontPitch = Default!
         CASE 1
            FontPitch = Fixed!
         CASE 2
            FontPitch = Variable!
      END CHOOSE

      CHOOSE CASE Integer(i_CurrentDW.Describe(l_Column + ".Font.Charset"))
         CASE 0
            FontCharset = Ansi!
         CASE 1
            FontCharset = DefaultCharset!
         CASE 2
            FontCharset = Symbol!
         CASE 128
            FontCharset = ShiftJIS!
         CASE 255
            FontCharset = Oem!
      END CHOOSE
   END IF

   //---------------------------------------------------------------
   //  Determine if the MLE should be displayed above or below 
   //  the DataWindow column.
   //---------------------------------------------------------------

   CHOOSE CASE Integer(i_CurrentDW.Describe(l_Column + ".Border"))
      CASE 1
         BorderStyle  = StyleShadowBox!
         l_OffsetDown = 6
         l_OffsetUp   = 0
      CASE 5
         BorderStyle = StyleLowered!
         l_OffsetDown = 10
         l_OffsetUp   = 0
      CASE 6
         BorderStyle = StyleRaised!
         l_OffsetDown = 10
         l_OffsetUp   = 0
      CASE ELSE
         BorderStyle = StyleBox!
         l_OffsetDown = 6
         l_OffsetUp   = -6
   END CHOOSE

   l_FirstRow = Integer(i_CurrentDW.Describe("datawindow.firstrowonpage"))
   l_FieldY = i_DDY[l_Index] + ((l_Row - l_FirstRow) * &
              i_DDDetail[l_Index])

   IF l_FieldY + i_DDHeight[l_Index] + &
      l_NewHeight + l_OffsetDown < l_ParentHeight THEN
      l_Y = l_FieldY + i_DDHeight[l_Index] + l_OffsetDown
   ELSEIF l_FieldY - l_NewHeight - l_OffsetUp > 1 THEN
      l_Y = l_FieldY - l_NewHeight - l_OffsetUp 
   ELSE
      l_Y = l_FieldY + i_DDHeight[l_Index] + l_OffsetDown
   END IF

   IF i_CurrentDW.HScrollBar THEN
      l_X = fu_DDFindXPos(l_Column)
   ELSE
      l_X = i_DDX[l_Index]
   END IF

   Move(l_X, l_Y)

   i_MLEDDType   = "COLUMN"
   i_MLEDDIndex  = l_Index
   i_MLEDDColumn = l_Column
   i_MLEDDRow    = l_Row

   //---------------------------------------------------------------
   //  Copy the text from the DataWindow column to the MLE and 
   //  display the MLE object.
   //---------------------------------------------------------------

   Text = i_CurrentDW.GetText()
   SelectText(Len(Text) + 1, 0)
   Visible = TRUE
   TabOrder = i_CurrentDW.TabOrder - 1
   SetFocus()
END IF


end event

event po_identify;//******************************************************************
//  PO Module     : u_MLE
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

public function integer fu_ddopen (datawindow dw_name);//******************************************************************
//  PO Module     : u_MLE
//  Subroutine    : fu_DDOpen
//  Description   : Post the processing of the drop-down MLE so the
//                  drop-down list box is prevented from showing.  
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
//  Find the DataWindow column to attach the MLE to.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDD
   IF i_DDName[l_Idx] = l_Column THEN
      RETURN 1
   END IF
NEXT

RETURN 0
end function

public subroutine fu_ddmlewire (u_dd_mle dd_object, integer text_limit, integer percent_width, integer drop_height);//******************************************************************
//  PO Module     : u_MLE
//  Subroutine    : fu_DDMLEWire
//  Description   : Wires a drop-down MLE object to an MLE object.  
//
//  Parameters    : U_DD_MLE DD_Object - 
//                     Name of the drop-down object.
//                  INTEGER  Text_Limit - 
//                     Number of characters entered until the MLE 
//                     drops automatically.
//                  INTEGER  Percent_Width - 
//                     Percent of the drop down's width to set for
//                     the MLE width. Default is 100.
//                  INTEGER  Drop_Height  - 
//                     MLE height.  Default is 72% of the width.          
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

l_Found = FALSE

//------------------------------------------------------------------
//  Determine if a drop-down object has been wired to this MLE
//  before.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDD
   IF i_DDName[l_Idx] = dd_object.ClassName() THEN
      l_Found = TRUE
		l_DDNum = l_Idx
      EXIT
   END IF
NEXT

//------------------------------------------------------------------
//  Store the drop-down objects attributes.
//------------------------------------------------------------------

IF l_Found THEN
   i_DDWidth[l_DDNum]     = dd_object.Width
   i_DDHeight[l_DDNum]    = dd_object.Height
   i_DDX[l_DDNum]         = dd_object.X
   i_DDY[l_DDNum]         = dd_object.Y
   i_DDTextLimit[l_DDNum] = text_limit
	
   //---------------------------------------------------------------
   //  Determine the width to display the MLE.
   //---------------------------------------------------------------

   IF percent_width > c_DefaultDDWidth THEN
      i_DDMLEWidth[l_DDNum]  = Int(i_DDWidth[l_DDNum] * &
                                   (percent_width/100))
   ELSE
      i_DDMLEWidth[l_DDNum]  = i_DDWidth[l_DDNum]
   END IF

   //---------------------------------------------------------------
   //  Determine the height to display the MLE.
   //---------------------------------------------------------------

   IF drop_height > c_DefaultDDHeight THEN
      i_DDMLEHeight[l_DDNum] = drop_height
   ELSE
      i_DDMLEHeight[l_DDNum] = Int(i_DDMLEWidth[l_DDNum] * .72)
   END IF
ELSE
   i_NumDD = i_NumDD + 1
   i_DDName[i_NumDD]      = dd_object.ClassName()
   i_NumDDObjects         = i_NumDDObjects + 1
   i_DDType[i_NumDD]      = "OBJECT"
   i_DDIndex[i_NumDD]     = i_NumDDObjects
   i_DDWidth[i_NumDD]     = dd_object.Width
   i_DDHeight[i_NumDD]    = dd_object.Height
   i_DDX[i_NumDD]         = dd_object.X
   i_DDY[i_NumDD]         = dd_object.Y
   i_DDDetail[i_NumDD]    = 0
   i_DDTextLimit[i_NumDD] = text_limit

   //---------------------------------------------------------------
   //  Determine the width to display the MLE.
   //---------------------------------------------------------------

   IF percent_width > c_DefaultDDWidth THEN
      i_DDMLEWidth[i_NumDD]  = Int(i_DDWidth[i_NumDD] * &
                                   (percent_width/100))
   ELSE
      i_DDMLEWidth[i_NumDD]  = i_DDWidth[i_NumDD]
   END IF

   //---------------------------------------------------------------
   //  Determine the height to display the MLE.
   //---------------------------------------------------------------

   IF drop_height > c_DefaultDDHeight THEN
      i_DDMLEHeight[i_NumDD] = drop_height
   ELSE
      i_DDMLEHeight[i_NumDD] = Int(i_DDMLEWidth[i_NumDD] * .72)
   END IF

   //---------------------------------------------------------------
   //  Communicate information about this object to the drop-down
   //  object.
   //---------------------------------------------------------------

   i_DDObject[i_NumDDObjects] = dd_object
   dd_object.i_MLE            = THIS
   dd_object.i_ObjectIndex    = i_NumDDObjects
   dd_object.i_DDIndex        = i_NumDD
END IF

end subroutine

public subroutine fu_ddmlewiredw (datawindow dd_dw, string dd_column, integer text_limit, integer percent_width, integer drop_height);//******************************************************************
//  PO Module     : u_MLE
//  Subroutine    : fu_DDMLEWireDW
//  Description   : Wires a drop-down MLE column to an MLE object.  
//
//  Parameters    : DATAWINDOW DD_DW - 
//                     Name of DataWindow that contains a column 
//                     with the drop-down.
//                  STRING     DD_Column  - 
//                     Name of the DataWindow column.
//                  INTEGER    Text_Limit - 
//                     Number of characters entered until the MLE 
//                     drops automatically.
//                  INTEGER    Percent_Width - 
//                     Percent of the drop down's width to set for
//                     the MLE width. Default is 100.
//                  INTEGER    Drop_Height - 
//                     MLE height.  Default is 72% of the width.          
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

//------------------------------------------------------------------
//  Determine if this DataWindow column has already been wired.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDD
   IF i_DDName[l_Idx] = l_DWName THEN
      l_Found = TRUE
		l_DDNum = l_Idx
      EXIT
   END IF
NEXT

//------------------------------------------------------------------
//  Store attributes about the DataWindow column.
//------------------------------------------------------------------

IF l_Found THEN
   i_DDWidth[l_DDNum]  = Integer(dd_dw.Describe(dd_column + ".Width"))
   i_DDHeight[l_DDNum] = Integer(dd_dw.Describe(dd_column + ".Height"))
   i_DDX[l_DDNum]      = dd_dw.X + Integer(dd_dw.Describe(dd_column + ".X"))
   i_DDY[l_DDNum]      = dd_dw.Y + &
                         Integer(dd_dw.Describe("datawindow.header.height")) + &
                         Integer(dd_dw.Describe(dd_column + ".Y"))
   i_DDDetail[l_DDNum]    = Integer(dd_dw.Describe("datawindow.detail.height"))
   i_DDTextLimit[l_DDNum] = text_limit
	
   //---------------------------------------------------------------
   //  Save the percent width of the MLE.
   //---------------------------------------------------------------
   
   i_DDMLEWidth[l_DDNum] = percent_width

   //---------------------------------------------------------------
   //  Save the drop height of the MLE.
   //---------------------------------------------------------------

   i_DDMLEHeight[l_DDNum] = drop_height
ELSE
   i_NumDD = i_NumDD + 1
   i_DDName[i_NumDD]   = l_DWName
   i_NumDDColumns      = i_NumDDColumns + 1
   i_DDType[i_NumDD]   = "COLUMN"
   i_DDIndex[i_NumDD]  = i_NumDDColumns
   i_DDWidth[i_NumDD]  = Integer(dd_dw.Describe(dd_column + ".Width"))
   i_DDHeight[i_NumDD] = Integer(dd_dw.Describe(dd_column + ".Height"))
   i_DDX[i_NumDD]      = dd_dw.X + Integer(dd_dw.Describe(dd_column + ".X"))
   i_DDY[i_NumDD]      = dd_dw.Y + &
                         Integer(dd_dw.Describe("datawindow.header.height")) + &
                         Integer(dd_dw.Describe(dd_column + ".Y"))
   i_DDDetail[i_NumDD]    = Integer(dd_dw.Describe("datawindow.detail.height"))
   i_DDTextLimit[i_NumDD] = text_limit

   //---------------------------------------------------------------
   //  Save the percent width of the MLE.
   //---------------------------------------------------------------

   i_DDMLEWidth[i_NumDD] = percent_width

   //---------------------------------------------------------------
   //  Save the drop height of the MLE.
   //---------------------------------------------------------------

   i_DDMLEHeight[i_NumDD] = drop_height

   //---------------------------------------------------------------
   //  Register the DataWindow and column this object will be wired
   //  to.
   //---------------------------------------------------------------

   i_DDDW[i_NumDDColumns]     = dd_dw
   i_DDColumn[i_NumDDColumns] = dd_column
   Visible                    = FALSE
   TabOrder                   = 0
END IF

end subroutine

public subroutine fu_ddkeydown ();//******************************************************************
//  PO Module     : u_MLE
//  Subroutine    : fu_DDKeyDown
//  Description   : Drops or raises the MLE using the ALT-DownArrow
//                  and ALT-UpArrow.  
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
//  Copyright ServerLogic 1994-1995.  All Rights Reserved.
//******************************************************************

IF i_MLEDDType = "OBJECT" THEN
   IF NOT Visible THEN
      IF GetFocus() = i_DDObject[i_DDIndex[i_MLEDDIndex]] THEN
         IF KeyDown(keyDownArrow!) THEN
            i_DDObject[i_DDIndex[i_MLEDDIndex]].PostEvent("po_DDProcess")
         END IF
      END IF
   ELSE
      IF GetFocus() = THIS THEN
         IF KeyDown(keyUpArrow!) THEN
            IF i_DDObject[i_DDIndex[i_MLEDDIndex]].Text <> Text THEN
               i_DDObject[i_DDIndex[i_MLEDDIndex]].Text = Text
            END IF
            Visible = FALSE
            TabOrder = 0
            i_DDObject[i_DDIndex[i_MLEDDIndex]].i_DDClosed = FALSE
            PostEvent("po_DDFocus")
         END IF
      END IF
   END IF
ELSE
   IF Visible THEN
      IF KeyDown(keyUpArrow!) THEN
         IF i_CurrentDW.GetText() <> Text THEN
            i_CurrentDW.SetText(Text)
         END IF
         Visible = FALSE
         TabOrder = 0
         PostEvent("po_DDFocus")
      END IF
   END IF      
END IF
   
end subroutine

public subroutine fu_ddeditchanged (datawindow dw_name);//******************************************************************
//  PO Module     : u_MLE
//  Subroutine    : fu_DDEditChanged
//  Description   : Displays the MLE under the column after a given
//                  number of characters have been entered by the
//                  user.  
//
//  Parameters    : DATAWINDOW DW_Name - 
//                     Name of the DataWindow the column is on.
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

STRING  l_Column
INTEGER l_Idx

l_Column = dw_name.ClassName() + "." + dw_name.GetColumnName()
FOR l_Idx = 1 TO i_NumDD
   IF i_DDName[l_Idx] = l_Column THEN
      i_MLEDDIndex = l_Idx
		EXIT
   END IF
NEXT

IF i_MLEDDIndex > 0 THEN
	IF i_DDTextLimit[i_MLEDDIndex] > 0 THEN
   	IF Len(dw_name.GetText()) > i_DDTextLimit[i_MLEDDIndex] THEN
      	i_CurrentDW = dw_name
	      THIS.TriggerEvent("po_DDProcess")
   	END IF
	END IF
END IF
end subroutine

public function double fu_ddfindxpos (string dw_column);//******************************************************************
//  PO Module     : u_MLE
//  Subroutine    : fu_DDFindXPos
//  Description   : Finds the X position for the givent column when
//                  the DataWindow has a horizontal scroll bar.  
//
//  Parameters    : STRING DW_Column - 
//                     Name of the DataWindow column to position 
//                     the MLE under.
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
//  PO Module     : u_MLE
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

public subroutine fu_mleoptions (string text_font, integer text_size, string options);//******************************************************************
//  PO Module     : u_MLE
//  Subroutine    : fu_MLEOptions
//  Description   : Establishes the look-and-feel of the multi-line
//                  edit object.  
//
//  Parameters    : STRING TextFont - 
//                     Font style of the text.
//                  STRING TextSize - 
//                     Text size in points.
//                  STRING Options - 
//                     Visual options for the MLE.
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
//  Set the font style of the text for the MLE.
//------------------------------------------------------------------

IF Text_Font <> c_DefaultDDFont THEN
   i_FontSet = TRUE
	FaceName = Text_Font
   CHOOSE CASE UPPER(Text_Font)
      CASE "ARIAL"
         FontFamily  = Swiss!
         FontPitch   = Variable!
         FontCharset = Ansi!
      CASE "COURIER", "COURIER NEW"
         FontFamily  = Roman!
         FontPitch   = Fixed!
         FontCharset = Ansi!
      CASE "MODERN"
         FontFamily  = Roman!
         FontPitch   = Variable!
         FontCharset = DefaultCharset!
      CASE "MS SANS SERIF"
         FontFamily  = Swiss!
         FontPitch   = Variable!
         FontCharset = Ansi!
      CASE "MS SERIF"
         FontFamily  = Roman!
         FontPitch   = Variable!
         FontCharset = Ansi!
      CASE "ROMAN"
         FontFamily  = Roman!
         FontPitch   = Variable!
         FontCharset = DefaultCharset!
      CASE "SCRIPT"
         FontFamily  = Decorative!
         FontPitch   = Variable!
         FontCharset = DefaultCharset!
      CASE "SMALL FONTS"
         FontFamily  = Swiss!
         FontPitch   = Variable!
         FontCharset = Ansi!
      CASE "SYSTEM"
         FontFamily  = Swiss!
         FontPitch   = Variable!
         FontCharset = Ansi!
      CASE "TIMES NEW ROMAN", "TIMES ROMAN"
         FontFamily  = Roman!
         FontPitch   = Variable!
         FontCharset = Ansi!
      CASE "MS LINEDRAW"
         FontFamily  = Roman!
         FontPitch   = Fixed!
         FontCharset = Symbol!
      CASE "TERMINAL"
         FontFamily  = Roman!
         FontPitch   = Fixed!
         FontCharset = DefaultCharset!
      CASE "CENTURY SCHOOLBOOK"
         FontFamily  = Roman!
         FontPitch   = Variable!
         FontCharset = Ansi!
      CASE "CENTURY GOTHIC"
         FontFamily  = Swiss!
         FontPitch   = Variable!
         FontCharset = Ansi!
      CASE ELSE
         FontFamily  = Swiss!
         FontPitch   = Variable!
         FontCharset = Ansi!
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Set the font size of the MLE.
//------------------------------------------------------------------

IF Text_Size <> c_DefaultDDSize THEN
   i_SizeSet = TRUE
	TextSize = Text_Size * -1
END IF

//------------------------------------------------------------------
//  Set the visual options.
//------------------------------------------------------------------

IF Options <> c_DefaultDDVisual THEN
	
   //---------------------------------------------------------------
   //  MLE border style.
   //---------------------------------------------------------------

   Border = TRUE
   IF Pos(Options, c_MLEBorderBox) > 0 THEN
      i_BorderSet = TRUE
      BorderStyle = StyleBox!
   ELSEIF Pos(Options, c_MLEBorderNone) > 0 THEN
		i_BorderSet = TRUE
      Border = FALSE
   ELSEIF Pos(Options, c_MLEBorderLowered) > 0 THEN
		i_BorderSet = TRUE
      BorderStyle = StyleLowered!
   ELSEIF Pos(Options, c_MLEBorderRaised) > 0 THEN
		i_BorderSet = TRUE
      BorderStyle = StyleRaised!
   ELSEIF Pos(Options, c_MLEBorderShadowBox) > 0 THEN
		i_BorderSet = TRUE
      BorderStyle = StyleShadowBox!
   END IF

   //---------------------------------------------------------------
   //  MLE text color.
   //---------------------------------------------------------------

   IF Pos(Options, c_MLEBlack) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_Black
   ELSEIF Pos(Options, c_MLEWhite) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_White
   ELSEIF Pos(Options, c_MLEGray) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_Gray
   ELSEIF Pos(Options, c_MLEDarkGray) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_DarkGray
   ELSEIF Pos(Options, c_MLERed) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_Red
   ELSEIF Pos(Options, c_MLEDarkRed) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_DarkRed
   ELSEIF Pos(Options, c_MLEGreen) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_Green
   ELSEIF Pos(Options, c_MLEDarkGreen) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_DarkGreen
   ELSEIF Pos(Options, c_MLEBlue) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_Blue
   ELSEIF Pos(Options, c_MLEDarkBlue) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_DarkBlue
   ELSEIF Pos(Options, c_MLEMagenta) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_Magenta
   ELSEIF Pos(Options, c_MLEDarkMagenta) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_DarkMagenta
   ELSEIF Pos(Options, c_MLECyan) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_Cyan
   ELSEIF Pos(Options, c_MLEDarkCyan) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_DarkCyan
   ELSEIF Pos(Options, c_MLEYellow) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_Yellow
   ELSEIF Pos(Options, c_MLEDarkYellow) > 0 THEN
		i_ColorSet = TRUE
      TextColor = OBJCA.MGR.c_DarkYellow
   END IF

   //---------------------------------------------------------------
   //  MLE background color.
   //---------------------------------------------------------------

   IF Pos(Options, c_MLEBGBlack) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_Black
   ELSEIF Pos(Options, c_MLEBGWhite) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_White
   ELSEIF Pos(Options, c_MLEBGGray) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_Gray
   ELSEIF Pos(Options, c_MLEBGDarkGray) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_DarkGray
   ELSEIF Pos(Options, c_MLEBGRed) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_Red
   ELSEIF Pos(Options, c_MLEBGDarkRed) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_DarkRed
   ELSEIF Pos(Options, c_MLEBGGreen) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_Green
   ELSEIF Pos(Options, c_MLEBGDarkGreen) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_DarkGreen
   ELSEIF Pos(Options, c_MLEBGBlue) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_Blue
   ELSEIF Pos(Options, c_MLEBGDarkBlue) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_DarkBlue
   ELSEIF Pos(Options, c_MLEBGMagenta) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_Magenta
   ELSEIF Pos(Options, c_MLEBGDarkMagenta) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_DarkMagenta
   ELSEIF Pos(Options, c_MLEBGCyan) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_Cyan
   ELSEIF Pos(Options, c_MLEBGDarkCyan) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_DarkCyan
   ELSEIF Pos(Options, c_MLEBGYellow) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_Yellow
   ELSEIF Pos(Options, c_MLEBGDarkYellow) > 0 THEN
		i_BGColorSet = TRUE
      BackColor = OBJCA.MGR.c_DarkYellow
   END IF

   //---------------------------------------------------------------
   //  MLE text style.
   //---------------------------------------------------------------

   IF Pos(Options, c_MLETextRegular) > 0 THEN
		i_StyleSet = TRUE
      Weight    = 400
		Italic    = FALSE
		Underline = FALSE
   ELSEIF Pos(Options, c_MLETextBold) > 0 THEN
		i_StyleSet = TRUE
      Weight    = 700
		Italic    = FALSE
		Underline = FALSE
   ELSEIF Pos(Options, c_MLETextItalic) > 0 THEN
		i_StyleSet = TRUE
      Weight    = 400
		Italic    = TRUE
		Underline = FALSE
   ELSEIF Pos(Options, c_MLETextUnderline) > 0 THEN
		i_StyleSet = TRUE
      Weight    = 400
		Italic    = FALSE
		Underline = TRUE
   END IF
END IF
end subroutine

event constructor;//******************************************************************
//  PO Module     : u_MLE
//  Event         : Constructor
//  Description   : Initilaizes the MLE object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING     l_Defaults, l_DefaultFont, l_DefaultSize

//------------------------------------------------------------------
//  Make sure the tab order is 0 and the object is hidden.
//------------------------------------------------------------------

TabOrder = 0
Visible  = FALSE

//------------------------------------------------------------------
//  Determine the parent.
//------------------------------------------------------------------

IF Parent.TypeOf() = Window! THEN
   i_Window       = Parent
   i_ParentObject = "WINDOW"
ELSE
   i_UserObject   = Parent
   i_ParentObject = "USEROBJECT"
END IF

//------------------------------------------------------------------
//  Set the defaults.
//------------------------------------------------------------------

l_Defaults = OBJCA.MGR.fu_GetDefault("MLE", "General")
l_DefaultFont = OBJCA.MGR.fu_GetDefault("MLE", "DDTextFont")
l_DefaultSize = OBJCA.MGR.fu_GetDefault("MLE", "DDTextSize")
THIS.fu_MLEOptions(l_DefaultFont, Integer(l_DefaultSize), l_Defaults)
end event

event losefocus;//******************************************************************
//  PO Module     : u_MLE
//  Event         : LoseFocus
//  Description   : When the MLE loses focus, set the text into
//                  the drop-down object or DataWindow column.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF Visible AND i_MLEDDType = "OBJECT" THEN

   IF i_DDObject[i_DDIndex[i_MLEDDIndex]].Text <> Text THEN
      i_DDObject[i_DDIndex[i_MLEDDIndex]].Text = Text
   END IF
   Visible = FALSE
   TabOrder = 0
   IF GetFocus() = i_DDObject[i_DDIndex[i_MLEDDIndex]] AND NOT i_DDTabOut THEN
      i_DDObject[i_DDIndex[i_MLEDDIndex]].i_DDClosed = TRUE
   ELSE
      i_DDTabOut = FALSE
   END IF

ELSEIF Visible AND i_MLEDDType = "COLUMN" THEN
	
   IF i_DDTabOut THEN
      i_CurrentDW.SetColumn(i_MLEDDColumn)
   END IF

   IF i_CurrentDW.GetText() <> Text THEN
      i_CurrentDW.SetText(Text)
   END IF
   Visible = FALSE
   TabOrder = 0
   IF NOT i_DDTabOut THEN
      i_DDClosed = TRUE
   ELSE
      i_DDTabOut = FALSE
   END IF
   IF GetFocus() = i_DDDW[i_DDIndex[i_MLEDDIndex]] THEN
      i_DDDW[i_DDIndex[i_MLEDDIndex]].SetColumn(i_MLEDDColumn)
      THIS.PostEvent("po_DDFocus")
   END IF

END IF

end event

event getfocus;//******************************************************************
//  PO Module     : u_MLE
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

IF i_MLEDDType = "OBJECT" THEN
   IF NOT Visible THEN
      i_DDObject[i_DDIndex[i_MLEDDIndex]].SetFocus()
   END IF
END IF
end event

event other;//******************************************************************
//  PO Module     : u_MLE
//  Event         : Other
//  Description   : Monitors for the control and tab keys.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF NOT KeyDown(keyControl!) AND KeyDown(keyTab!) THEN
   i_DDTabOut = TRUE
END IF
end event

