$PBExportHeader$w_about.srw
$PBExportComments$Window to display information about an application
forward
global type w_about from Window
end type
type st_application_copyright from statictext within w_about
end type
type p_application_bitmap from picture within w_about
end type
type st_application_rev from statictext within w_about
end type
type st_application_name from statictext within w_about
end type
type cb_ok from commandbutton within w_about
end type
type ln_about from line within w_about
end type
end forward

global type w_about from Window
int X=668
int Y=521
int Width=1262
int Height=761
boolean TitleBar=true
string Title="About"
long BackColor=12632256
boolean ControlMenu=true
boolean ToolBarVisible=true
WindowType WindowType=response!
event po_position pbm_custom75
st_application_copyright st_application_copyright
p_application_bitmap p_application_bitmap
st_application_rev st_application_rev
st_application_name st_application_name
cb_ok cb_ok
ln_about ln_about
end type
global w_about w_about

type variables

end variables

event open;//******************************************************************
//  PO Module     : w_About
//  Event         : Open
//  Description   : Display the application name and revision in
//                  the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG    l_WindowWidth, l_WindowHeight, l_NewWidth, l_NewHeight
LONG    l_HeightAdj

//------------------------------------------------------------------
//  Set the bitmap and resize.
//------------------------------------------------------------------

IF Len(Trim(OBJCA.WIN.i_Parm.Application_Bitmap)) = 0 THEN
   p_Application_Bitmap.PictureName  = "pb.bmp"
   p_Application_Bitmap.OriginalSize = TRUE
ELSE
   p_Application_Bitmap.PictureName  = OBJCA.WIN.i_Parm.Application_Bitmap
   p_Application_Bitmap.OriginalSize = TRUE
END IF

l_NewWidth  = p_Application_Bitmap.Width
l_NewHeight = p_Application_Bitmap.Height
IF l_NewHeight < 257 THEN
   l_NewHeight = 257
   l_HeightAdj = 0
ELSE
   l_HeightAdj = (l_NewHeight - 257) / 2
END IF

//------------------------------------------------------------------
//  Move the static text objects based on the new bitmap size and
//  set the application name and revision.
//------------------------------------------------------------------

l_WindowWidth = (3 * p_Application_Bitmap.X) + l_NewWidth + &
                st_Application_Name.Width + 20
l_WindowHeight = (5 * p_Application_Bitmap.Y) + l_NewHeight + &
                 st_Application_Copyright.height + cb_ok.height + 120

st_Application_Name.Move((2 * p_Application_Bitmap.X) + l_NewWidth, &
                         st_Application_Name.Y + l_HeightAdj)

st_Application_Rev.Move((2 * p_Application_Bitmap.X) + l_NewWidth, &
                        st_Application_Rev.Y + l_HeightAdj)

st_Application_Copyright.Width = l_WindowWidth
st_Application_Copyright.Move(st_Application_Copyright.X, &
                              (2 * p_Application_Bitmap.Y) + &
                              l_NewHeight)

ln_About.BeginX = 1
ln_About.EndX   = l_WindowWidth
ln_About.BeginY = (3 * p_Application_Bitmap.Y) + l_NewHeight + &
                  st_Application_Copyright.Height
ln_About.EndY = ln_About.BeginY

cb_Ok.Move((l_WindowWidth/2) - (cb_Ok.Width/2), &
           (4 * p_Application_Bitmap.Y) + l_NewHeight + &
           st_Application_Copyright.Height)

//------------------------------------------------------------------
//  Set the about window values.
//------------------------------------------------------------------

Title                          = Title + " " + &
                                 OBJCA.WIN.i_Parm.Application_Name
st_Application_Name.Text       = OBJCA.WIN.i_Parm.Application_Name
st_Application_Rev.Text        = OBJCA.WIN.i_Parm.Application_Rev
st_Application_Copyright.Text  = OBJCA.WIN.i_Parm.Application_Copyright

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

BackColor                     = OBJCA.WIN.i_WindowColor

IF OBJCA.WIN.i_WindowColor <> OBJCA.WIN.c_Gray THEN
   p_Application_Bitmap.BorderStyle = StyleShadowBox!
END IF

st_Application_Name.BackColor = OBJCA.WIN.i_WindowColor
st_Application_Name.TextColor = OBJCA.WIN.i_WindowTextColor
st_Application_Rev.BackColor  = OBJCA.WIN.i_WindowColor
st_Application_Rev.TextColor  = OBJCA.WIN.i_WindowTextColor
st_Application_Copyright.BackColor = OBJCA.WIN.i_WindowColor
st_Application_Copyright.TextColor = OBJCA.WIN.i_WindowTextColor

cb_Ok.FaceName                = OBJCA.WIN.i_WindowTextFont
cb_Ok.TextSize                = OBJCA.WIN.i_WindowTextSize

//------------------------------------------------------------------
//  Based on the new size of the bitmap, resize the window and the
//  border rectangles.
//------------------------------------------------------------------

Resize(l_WindowWidth, l_WindowHeight)

//------------------------------------------------------------------
//  Reposition based on the window size.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)
end event

on w_about.create
this.st_application_copyright=create st_application_copyright
this.p_application_bitmap=create p_application_bitmap
this.st_application_rev=create st_application_rev
this.st_application_name=create st_application_name
this.cb_ok=create cb_ok
this.ln_about=create ln_about
this.Control[]={ this.st_application_copyright,&
this.p_application_bitmap,&
this.st_application_rev,&
this.st_application_name,&
this.cb_ok,&
this.ln_about}
end on

on w_about.destroy
destroy(this.st_application_copyright)
destroy(this.p_application_bitmap)
destroy(this.st_application_rev)
destroy(this.st_application_name)
destroy(this.cb_ok)
destroy(this.ln_about)
end on

type st_application_copyright from statictext within w_about
int Y=361
int Width=1253
int Height=69
boolean Enabled=false
string Text="<Copyright>"
Alignment Alignment=Center!
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type p_application_bitmap from picture within w_about
int X=60
int Y=57
int Width=293
int Height=257
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
boolean FocusRectangle=false
boolean OriginalSize=true
end type

type st_application_rev from statictext within w_about
int X=417
int Y=233
int Width=741
int Height=77
boolean Enabled=false
string Text="<Version>"
Alignment Alignment=Center!
long BackColor=12632256
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_application_name from statictext within w_about
int X=407
int Y=57
int Width=741
int Height=145
boolean Enabled=false
string Text="<Application>"
Alignment Alignment=Center!
long BackColor=12632256
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_ok from commandbutton within w_about
int X=444
int Y=517
int Width=330
int Height=93
int TabOrder=1
string Text=" OK"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//**********************************************************************
//  PO Module     : w_About.cb_OK
//  Event         : Clicked
//  Description   : Close the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- ----------------------------------------------
//
//**********************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//**********************************************************************

Close(PARENT)
end event

type ln_about from line within w_about
boolean Enabled=false
int BeginX=5
int BeginY=473
int EndX=1253
int EndY=473
int LineThickness=9
end type

