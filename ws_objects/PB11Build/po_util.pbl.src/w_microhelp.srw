$PBExportHeader$w_microhelp.srw
$PBExportComments$Window to display system information on the MDI microhelp line
forward
global type w_microhelp from Window
end type
type st_res1 from statictext within w_microhelp
end type
type st_res2 from statictext within w_microhelp
end type
type st_res3 from statictext within w_microhelp
end type
type st_time from statictext within w_microhelp
end type
type r_res3 from rectangle within w_microhelp
end type
type r_res2 from rectangle within w_microhelp
end type
type r_res1 from rectangle within w_microhelp
end type
end forward

global type w_microhelp from Window
int X=1797
int Y=1801
int Width=1075
int Height=73
long BackColor=81373358
boolean Border=false
WindowType WindowType=popup!
st_res1 st_res1
st_res2 st_res2
st_res3 st_res3
st_time st_time
r_res3 r_res3
r_res2 r_res2
r_res1 r_res1
end type
global w_microhelp w_microhelp

type prototypes

end prototypes

type variables
INTEGER		i_FrameWidth	
INTEGER		i_FrameHeight

INTEGER		i_NumberResources
STATICTEXT		i_ResourceText[3]
RECTANGLE		i_ResourceRect[3]

INTEGER		i_WindowWidth
INTEGER		i_ClockX

LONG			i_Green
LONG			i_Yellow
LONG			i_Red

WINDOW		i_MDIFrame
INTEGER		i_UpdateSeconds
BOOLEAN		i_ShowResources	= FALSE
BOOLEAN		i_ShowClock	= TRUE

BOOLEAN		i_ResourcesVisible
BOOLEAN		i_ClockVisible
BOOLEAN		i_Visible
end variables

forward prototypes
public subroutine fw_setposition ()
public subroutine fw_updateindicators ()
end prototypes

public subroutine fw_setposition ();//******************************************************************
//  PC Module     : w_MicroHelp
//  Subroutine    : fw_SetPosition
//  Description   : Moves the w_MicroHelp window when the MDI
//                  Frame moves or changes size.  If the 
//                  PowerClass MDI Frame in not being used, this
//                  routine must be called by the developer from
//                  the Resize and pbm_Move events on the MDI Frame.
//                  (Note: the developer will have to define the
//                  pbm_Move event on the MDI Frame because it is
//                  not one of default events defined by
//                  PowerBuilder).
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

INTEGER  l_Idx
INTEGER  l_RightX, l_BottomY, l_XPos, l_YPos, l_Width

//------------------------------------------------------------------
//  Become invisible while we set the position.  We can't use
//  the ".Visible" attribute because when we set it back to TRUE
//  the window becomes activated and grabs focus.
//------------------------------------------------------------------

Move(-20000, -20000)

//------------------------------------------------------------------
//  Assume what the developer requested will be visible.
//------------------------------------------------------------------

i_ResourcesVisible = i_ShowResources
i_ClockVisible     = i_ShowClock

//------------------------------------------------------------------
//  Copy the original size of the window.
//------------------------------------------------------------------

l_Width = i_WindowWidth

//------------------------------------------------------------------
//  See if we are too big for the MDI Frame.  If we are, turn
//  the resource indicator off.
//------------------------------------------------------------------

IF i_MDIFrame.WorkSpaceWidth() < 1.5 * l_Width THEN
   i_ResourcesVisible = FALSE
END IF

//------------------------------------------------------------------
//  If only one of the indicators is shown, cut the window size
//  in half.
//------------------------------------------------------------------

IF i_ResourcesVisible THEN
   IF NOT i_ClockVisible THEN
      l_Width = i_WindowWidth / 2
   END IF
ELSE
   l_Width = i_WindowWidth / 2
END IF

//------------------------------------------------------------------
//  See if we are still too big for the MDI Frame.
//------------------------------------------------------------------

IF (i_MDIFrame.WorkSpaceWidth() < 1.5 * l_Width) THEN
   i_ResourcesVisible = FALSE
   i_ClockVisible     = FALSE
ELSE
   IF i_Visible THEN
      SetRedraw(FALSE)
   END IF

   //---------------------------------------------------------------
   //  Set the visibility of the Resource Indicators.
   //---------------------------------------------------------------

   FOR l_Idx = 1 TO i_NumberResources
      i_ResourceText[l_Idx].Visible = i_ResourcesVisible
      i_ResourceRect[l_Idx].Visible = i_ResourcesVisible
   NEXT

   //---------------------------------------------------------------
   //  Set the visibility of the Clock.
   //---------------------------------------------------------------

   IF i_ClockVisible THEN
      IF NOT i_ResourcesVisible THEN
         st_Time.X = i_ClockX - i_WindowWidth / 2
      ELSE
         st_Time.X = i_ClockX
      END IF

      IF NOT st_Time.Visible THEN
         st_Time.Visible = i_ClockVisible
      END IF
   ELSE
      IF st_Time.Visible THEN
         st_Time.Visible = i_ClockVisible
      END IF
   END IF

   //---------------------------------------------------------------
   //  fw_UpdateIndicators() will turn redraw back on.
   //---------------------------------------------------------------

   fw_UpdateIndicators()

   //---------------------------------------------------------------
   //  Update the position and size.
   //---------------------------------------------------------------

   l_RightX  = i_MDIFrame.WorkSpaceX() + &
               i_MDIFrame.WorkSpaceWidth()

   l_BottomY = i_MDIFrame.WorkSpaceY() + &
               i_MDIFrame.WorkSpaceHeight()

   l_XPos    = l_RightX  - l_Width - i_FrameWidth - 75
   l_YPos    = l_BottomY - Height  - i_FrameHeight

   Resize(l_Width, Height)
   Move(l_XPos,  l_YPos)
END IF

RETURN
end subroutine

public subroutine fw_updateindicators ();//******************************************************************
//  PO Module     : w_MicroHelp
//  Subroutine    : fw_UpdateIndicators
//  Description   : Updates the indicators on the w_MicroHelp
//                  window.  Typically will not be called by
//                  the developer.
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

UNSIGNEDINT  l_Resources[]
INTEGER      l_Idx

IF i_Visible THEN
   SetRedraw(FALSE)
END IF

//------------------------------------------------------------------
//  If the resources are displayed, update them.
//------------------------------------------------------------------

IF i_ResourcesVisible THEN
   OBJCA.MGR.fu_GetResources(l_Resources[])

   FOR l_Idx = 1 TO i_NumberResources
      CHOOSE CASE l_Resources[l_Idx]
         CASE 0 to 29
            i_ResourceRect[l_Idx].FillColor = i_Red
         CASE 30 to 59
            i_ResourceRect[l_Idx].FillColor = i_Yellow
         CASE ELSE
            i_ResourceRect[l_Idx].FillColor = i_Green
      END CHOOSE
   NEXT
END IF

//------------------------------------------------------------------
//  If the clock is displayed, update the time.
//------------------------------------------------------------------

IF i_ClockVisible THEN
   st_Time.Text = String(Today(), "[ShortDate]") + "  " + &
                  String(Now(),   "[Time]")
END IF

IF i_Visible THEN
   SetRedraw(TRUE)
END IF

RETURN
end subroutine

event timer;//******************************************************************
//  PO Module     : w_MicroHelp
//  Event         : Timer
//  Description   : Updates the w_MicroHelp window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_Visible = TRUE
fw_UpdateIndicators()
end event

event open;//******************************************************************
//  PO Module     : w_MicroHelp
//  Event         : Open
//  Description   : Initializes the w_MicroHelp window.
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
//  Make sure the timer is off.
//------------------------------------------------------------------

Timer(0)

//------------------------------------------------------------------
//  Become "invisible".
//------------------------------------------------------------------

Move(-20000, -20000)

//------------------------------------------------------------------
//  Initialize instance variables.
//------------------------------------------------------------------

OBJCA.WIN.i_MicroHelp = THIS
i_MDIFrame         = OBJCA.WIN.i_Parm.MDI_Frame
i_UpdateSeconds    = OBJCA.WIN.i_Parm.Update_Seconds
i_ShowClock        = OBJCA.WIN.i_Parm.Show_Clock
i_ShowResources    = OBJCA.WIN.i_Parm.Show_Resources

i_Visible          = FALSE
i_ResourcesVisible = FALSE
i_ClockVisible     = FALSE

i_WindowWidth      = Width
Height             = 53
i_ClockX           = st_Time.X

i_Green            = RGB(  0, 255,   0)
i_Yellow           = RGB(255, 255,   0)
i_Red              = RGB(255,   0,   0)

i_ResourceText[1]  = st_res1
i_ResourceText[2]  = st_res2
i_ResourceText[3]  = st_res3

i_ResourceRect[1]  = r_res1
i_ResourceRect[2]  = r_res2
i_ResourceRect[3]  = r_res3

CHOOSE CASE OBJCA.MGR.i_Env.OSType
	CASE Windows!, WindowsNT!
      i_NumberResources = 3
		i_ResourceText[1].Text = "S"
      i_ResourceText[2].Text = "G"
      i_ResourceText[3].Text = "U"

  	CASE ELSE
		i_NumberResources = 0
		
END CHOOSE

OBJCA.MGR.fu_GetFrameSize(i_FrameWidth, i_FrameHeight)

//---------------------------------------------------
//  Only set up the timer if services are required.
//  This functionality is required by the MDI.
//---------------------------------------------------

IF i_ShowResources OR i_ShowClock THEN
   fw_SetPosition()
   Timer(i_UpdateSeconds, THIS)
   PostEvent("Timer")
END IF

end event

event clicked;//******************************************************************
//  PO Module     : w_MicroHelp
//  Event         : Clicked
//  Description   : Flips the indicator being displayed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF i_ShowResources AND NOT i_ShowClock OR &
   NOT i_ShowResources AND i_ShowClock THEN
   i_ShowResources = (NOT i_ShowResources)
   i_ShowClock     = (NOT i_ShowClock)
   fw_SetPosition()
ELSE
   fw_UpdateIndicators()
END IF

i_MDIFrame.SetFocus()
end event

on w_microhelp.create
this.st_res1=create st_res1
this.st_res2=create st_res2
this.st_res3=create st_res3
this.st_time=create st_time
this.r_res3=create r_res3
this.r_res2=create r_res2
this.r_res1=create r_res1
this.Control[]={ this.st_res1,&
this.st_res2,&
this.st_res3,&
this.st_time,&
this.r_res3,&
this.r_res2,&
this.r_res1}
end on

on w_microhelp.destroy
destroy(this.st_res1)
destroy(this.st_res2)
destroy(this.st_res3)
destroy(this.st_time)
destroy(this.r_res3)
destroy(this.r_res2)
destroy(this.r_res1)
end on

type st_res1 from statictext within w_microhelp
int X=371
int Width=42
int Height=53
boolean Visible=false
boolean Enabled=false
string Text="S"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_res2 from statictext within w_microhelp
int X=188
int Width=46
int Height=53
boolean Visible=false
boolean Enabled=false
string Text="G"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_res3 from statictext within w_microhelp
int X=10
int Width=42
int Height=53
boolean Visible=false
boolean Enabled=false
string Text="U"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_time from statictext within w_microhelp
int X=590
int Width=481
int Height=49
boolean Enabled=false
string Text="12/12/12   09:12 pm"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=81373358
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type r_res3 from rectangle within w_microhelp
int X=60
int Y=9
int Width=87
int Height=37
boolean Visible=false
boolean Enabled=false
int LineThickness=5
long LineColor=12632256
long FillColor=65280
end type

type r_res2 from rectangle within w_microhelp
int X=243
int Y=9
int Width=87
int Height=37
boolean Visible=false
boolean Enabled=false
int LineThickness=5
long LineColor=12632256
long FillColor=65280
end type

type r_res1 from rectangle within w_microhelp
int X=421
int Y=9
int Width=87
int Height=37
boolean Visible=false
boolean Enabled=false
int LineThickness=5
long LineColor=12632256
long FillColor=65280
end type

