$PBExportHeader$w_plaque.srw
$PBExportComments$Window to display during application initialization
forward
global type w_plaque from Window
end type
type p_application_bitmap from picture within w_plaque
end type
type st_application_rev from statictext within w_plaque
end type
type st_application_name from statictext within w_plaque
end type
type cb_plaque from commandbutton within w_plaque
end type
end forward

global type w_plaque from Window
int X=892
int Y=705
int Width=778
int Height=537
long BackColor=12632256
boolean Border=false
WindowType WindowType=popup!
event po_close pbm_custom75
p_application_bitmap p_application_bitmap
st_application_rev st_application_rev
st_application_name st_application_name
cb_plaque cb_plaque
end type
global w_plaque w_plaque

event po_close;//******************************************************************
//  PO Module     : w_Plaque
//  Event         : po_Close
//  Description   : Closes the title plaque window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

Close(THIS)
end event

event open;//******************************************************************
//  PO Module     : w_Plaque
//  Event         : Open
//  Description   : Display the application name and revision in
//                  the title plaque when the application opens.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG     l_NewWidth, l_NewHeight
INTEGER  l_WindowWidth, l_WindowHeight, l_X

//------------------------------------------------------------------
//  Set the Bitmap and resize.
//------------------------------------------------------------------

IF Len(Trim(OBJCA.WIN.i_Parm.Application_Bitmap)) = 0 THEN
   p_Application_Bitmap.Visible = FALSE
   l_NewWidth  = 0
   l_NewHeight = p_Application_Bitmap.Y * -1
ELSE
   p_Application_Bitmap.PictureName  = OBJCA.WIN.i_Parm.Application_BitMap
   p_Application_Bitmap.OriginalSize = TRUE

   l_NewWidth  = p_Application_Bitmap.Width
   l_NewHeight = p_Application_Bitmap.Height
END IF

IF l_NewWidth < st_Application_Name.Width THEN
   l_NewWidth = st_Application_Name.Width
ELSE
   st_Application_Name.Width = l_NewWidth
   st_Application_Rev.Width = l_NewWidth
END IF

//------------------------------------------------------------------
//  Move the static text objects based on the new bitmap size and
//  get the application name and revision from the PCCA structure.
//------------------------------------------------------------------

l_WindowWidth  = (2 * p_Application_Bitmap.Y) + l_NewWidth + 30
l_WindowHeight = (3 * p_Application_Bitmap.Y) + &
                  st_Application_Name.Height  + &
                  st_Application_Rev.Height   + l_NewHeight

p_Application_Bitmap.Move((l_WindowWidth/2) - &
                          (p_Application_Bitmap.Width/2), &
                          p_Application_Bitmap.Y)

IF l_NewWidth <= st_Application_Name.Width THEN
   l_X = st_Application_Name.X + p_Application_Bitmap.Y + 15
ELSE
   l_X = p_Application_Bitmap.X
END IF

st_Application_Name.Move(l_X, &
                         (2 * p_Application_Bitmap.Y) + l_NewHeight)
st_Application_Rev.Move(l_X, &
                        (2 * p_Application_Bitmap.Y) + &
                        st_Application_Name.Height + &
                        l_NewHeight)
    
//------------------------------------------------------------------
//  Set the palque values.
//------------------------------------------------------------------

st_Application_Name.Text = OBJCA.WIN.i_Parm.Application_Name
st_Application_Rev.Text  = OBJCA.WIN.i_Parm.Application_Rev

//------------------------------------------------------------------
//  Based on the new size of the bitmap, resize the window and the
//  command button that lays on top of it.
//------------------------------------------------------------------

Resize(l_WindowWidth, l_WindowHeight)
cb_plaque.Resize(Width, Height)

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

st_Application_Name.TextColor = OBJCA.WIN.i_WindowTextColor
st_Application_Rev.TextColor  = OBJCA.WIN.i_WindowTextColor

//------------------------------------------------------------------
//  Reposition based on the window size.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)

//------------------------------------------------------------------
//  Set this window to be the top-most window.
//------------------------------------------------------------------

SetPosition(TopMost!)

//------------------------------------------------------------------
//  The po_Close event is posted so that the this title plaque
//  window will go away when the application becomes active and
//  being accepting user input.
//------------------------------------------------------------------

PostEvent("po_Close")
end event

on w_plaque.create
this.p_application_bitmap=create p_application_bitmap
this.st_application_rev=create st_application_rev
this.st_application_name=create st_application_name
this.cb_plaque=create cb_plaque
this.Control[]={ this.p_application_bitmap,&
this.st_application_rev,&
this.st_application_name,&
this.cb_plaque}
end on

on w_plaque.destroy
destroy(this.p_application_bitmap)
destroy(this.st_application_rev)
destroy(this.st_application_name)
destroy(this.cb_plaque)
end on

type p_application_bitmap from picture within w_plaque
int X=243
int Y=49
int Width=293
int Height=257
boolean FocusRectangle=false
boolean OriginalSize=true
end type

type st_application_rev from statictext within w_plaque
int X=14
int Y=437
int Width=741
int Height=77
boolean Enabled=false
string Text="<Version>"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=79741120
long BorderColor=33554432
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_application_name from statictext within w_plaque
int X=19
int Y=353
int Width=741
int Height=85
boolean Enabled=false
string Text="<Application>"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_plaque from commandbutton within w_plaque
int Width=778
int Height=537
int TabOrder=10
boolean Enabled=false
int TextSize=-16
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

