$PBExportHeader$u_dd_mle.sru
$PBExportComments$Drop-down MLE class
forward
global type u_dd_mle from dropdownlistbox
end type
end forward

global type u_dd_mle from dropdownlistbox
int Width=1001
int Height=88
int TabOrder=1
boolean Sorted=false
boolean AutoHScroll=true
boolean AllowEdit=true
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event po_ddopen pbm_cbndropdown
event po_ddfocus pbm_custom75
event po_ddeditchange pbm_cbneditchange
event po_ddprocess pbm_custom74
event po_identify pbm_custom73
end type
global u_dd_mle u_dd_mle

type variables
//----------------------------------------------------------------------------------------
//  Drop-down MLE Constants
//----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName	= "DDMLE"

//----------------------------------------------------------------------------------------
// Drop-down MLE Instance Variables
//----------------------------------------------------------------------------------------

U_MLE			i_MLE

INTEGER		i_DDIndex
INTEGER		i_ObjectIndex
INTEGER		i_SaveY

BOOLEAN		i_DDClosed
BOOLEAN		i_DDSaveIndex


end variables

forward prototypes
public function string fu_getidentity ()
end prototypes

event po_ddopen;//******************************************************************
//  PO Module     : u_DD_MLE
//  Event         : po_DDOpen
//  Description   : Opens the MLE and displays it using the
//                  drop-down objects attributes.  
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
//  this object (to the MLE) and then back to this object.
//------------------------------------------------------------------

i_DDSaveIndex = TRUE
THIS.PostEvent("po_DDFocus")

//------------------------------------------------------------------
//  Once the list box is gone, process the MLE action.
//------------------------------------------------------------------

THIS.PostEvent("po_DDProcess")
end event

event po_ddfocus;//******************************************************************
//  PO Module     : u_DD_MLE
//  Event         : po_DDFocus
//  Description   : Posted event to set focus to the MLE object.  
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_MLE.SetFocus()


end event

event po_ddeditchange;//******************************************************************
//  PO Module     : u_DD_MLE
//  Event         : po_DDEditChange
//  Description   : Opens the MLE object after a given number of
//                  characters have been entered by the user.  
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF i_MLE.i_DDTextLimit[i_DDIndex] > 0 THEN
   IF Len(Text) > i_MLE.i_DDTextLimit[i_DDIndex] THEN
      THIS.TriggerEvent("po_DDProcess")
   END IF
END IF
end event

event po_ddprocess;//******************************************************************
//  PO Module     : u_DD_MLE
//  Event         : po_DDProcess
//  Description   : Opens the MLE and displays it using the
//                  drop-down objects attributes.  
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Y, l_OffsetDown, l_OffsetUp, l_ParentHeight

SetPointer(HourGlass!)

IF i_MLE.i_MLEDDIndex = i_DDIndex AND i_DDClosed THEN
   i_DDClosed = FALSE
   RETURN
ELSE
   i_DDClosed = FALSE
END IF

//------------------------------------------------------------------
//  Determine if the MLE is on a window or a user object and get the
//  height for it.
//------------------------------------------------------------------

IF i_MLE.i_ParentObject = "WINDOW" THEN
   l_ParentHeight = i_MLE.i_Window.WorkSpaceHeight()
ELSE
   l_ParentHeight = i_MLE.i_UserObject.Height
END IF

//------------------------------------------------------------------
//  Determine if the MLE needs to be moved to the current drop-down
//  object or if it already there.
//------------------------------------------------------------------

IF i_MLE.X <> X OR i_MLE.Y <> i_SaveY OR &
	i_MLE.i_ParentHeight <> l_ParentHeight THEN
   i_MLE.i_ParentHeight = l_ParentHeight
   IF i_MLE.i_DDWidth[i_DDIndex] <> i_MLE.Width THEN
      i_MLE.Resize(i_MLE.i_DDMLEWidth[i_DDIndex], &
                   i_MLE.i_DDMLEHeight[i_DDIndex])
   END IF

   //---------------------------------------------------------------
   //  Set the attributes of the MLE to match the drop-down object.
   //---------------------------------------------------------------

   i_MLE.BackColor   = BackColor
   i_MLE.TextColor   = TextColor
   i_MLE.BorderStyle = BorderStyle
   i_MLE.FaceName    = FaceName
   i_MLE.FontFamily  = FontFamily
   i_MLE.FontPitch   = FontPitch
   i_MLE.FontCharset = FontCharset
   i_MLE.TextSize    = TextSize

   CHOOSE CASE BorderStyle
      CASE StyleBox!
         l_OffsetDown = 6
         l_OffsetUp   = 0
      CASE StyleLowered!
         l_OffsetDown = -6
         l_OffsetUp   = 6
      CASE StyleRaised!
         l_OffsetDown = -6
         l_OffsetUp   = 6
      CASE StyleShadowBox!
         l_OffsetDown = 0
         l_OffsetUp   = 10
   END CHOOSE

   //---------------------------------------------------------------
   //  Determine if the MLE should be displayed above or below the
   //  drop-down object.
   //---------------------------------------------------------------

   IF Y + Height + i_MLE.i_DDMLEHeight[i_DDIndex] - l_OffsetDown < &
      l_ParentHeight THEN
      l_Y = Y + Height - l_OffsetDown
   ELSEIF Y - i_MLE.i_DDMLEHeight[i_DDIndex] - l_OffsetDown > 1 THEN
      l_Y = Y - i_MLE.i_DDMLEHeight[i_DDIndex] - l_OffsetUp 
   ELSE
      l_Y = Y + Height - l_OffsetDown
   END IF

   i_SaveY = l_Y
	i_MLE.Move(X, l_Y)

END IF

//------------------------------------------------------------------
//  Copy the text from the drop-down object to the MLE and display
//  the MLE object.
//------------------------------------------------------------------

i_MLE.Text = Text
i_MLE.SelectText(Len(Text) + 1, 0)
i_MLE.Visible       = TRUE
i_MLE.TabOrder      = TabOrder - 1
i_MLE.SetFocus()
BringToTop          = TRUE

end event

event po_identify;//******************************************************************
//  PO Module     : u_DD_MLE
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
//  PO Module     : u_DD_MLE
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
//  PO Module     : u_DD_MLE
//  Event         : GetFocus
//  Description   : Sets this object as the current drop-down 
//                  MLE.  
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_MLE.i_MLEDDType   = "OBJECT"
IF i_MLE.i_MLEDDIndex <> i_DDIndex THEN
   IF i_MLE.i_MLEDDIndex > 0 THEN
      i_MLE.i_DDObject[i_MLE.i_DDIndex[i_MLE.i_MLEDDIndex]].i_DDClosed = FALSE
   END IF
END IF
IF NOT i_DDSaveIndex THEN
   i_MLE.i_MLEDDIndex  = i_DDIndex
ELSE
   i_DDSaveIndex = FALSE
END IF
i_MLE.i_MLEDDColumn = ""
end event

