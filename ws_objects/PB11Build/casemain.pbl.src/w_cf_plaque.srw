$PBExportHeader$w_cf_plaque.srw
$PBExportComments$CustomerFocus splash screen displayed during application startup.
forward
global type w_cf_plaque from window
end type
type mle_text from multilineedit within w_cf_plaque
end type
type p_1 from picture within w_cf_plaque
end type
type st_application_name from statictext within w_cf_plaque
end type
end forward

global type w_cf_plaque from window
integer x = 891
integer y = 704
integer width = 1458
integer height = 1092
boolean border = false
windowtype windowtype = popup!
long backcolor = 16777215
mle_text mle_text
p_1 p_1
st_application_name st_application_name
end type
global w_cf_plaque w_cf_plaque

event open;//******************************************************************
//  PO Module     : w_Plaque
//  Event         : Open
//  Description   : Display the application information in
//                  the title plaque when the application opens.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  6/2/2000 KMC		   Added code to change bitmaps depending on 
//								application-client setting in the ini file
//  8/22/2004 K. Claver Changed references to Quovadx back to Outlaw
//								Technologies.
//******************************************************************
//  Copyright ServerLogic 1992-1995.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Reposition based on the window size.
//------------------------------------------------------------------
String ls_DefaultText, ls_ClientText = "", ls_FileText

OBJCA.MGR.fu_CenterWindow(THIS)

ls_DefaultText = "Copyright 1999 Outlaw Technologies Inc.  All rights reserved.  "+ &
			 		  "Outlaw Technologies, the Outlaw Technologies logo, and "+ &
			 		  "CustomerFocus are trademarks of Outlaw Technologies which "+ &
			 		  "may be registered in some jurisdictions.  This program is "+ &
			 		  "protected by U.S. and international copyright laws as "+ &
			 		  "described in the Help About box."

//If installing for a client that wants their own graphics,
//  switch to the client specific graphics
IF Upper( gs_Client ) = "YES" THEN
	p_1.PictureName = "client_logo_s.jpg"
	
	IF FileExists( "client.txt" ) THEN
		ls_FileText = ProfileString( "client.txt", "Splash Text", "Text", "" )
		IF Trim( ls_FileText ) <> "" THEN
			mle_text.Text = ls_FileText
		ELSE
			mle_text.Text = ls_DefaultText
		END IF
	ELSE
		mle_text.Text = ls_DefaultText
	END IF
ELSE
	mle_text.Text = ls_DefaultText
END IF

//------------------------------------------------------------------
//  Set this window to be the top-most window.
//------------------------------------------------------------------

SetPosition(TopMost!)

end event

on w_cf_plaque.create
this.mle_text=create mle_text
this.p_1=create p_1
this.st_application_name=create st_application_name
this.Control[]={this.mle_text,&
this.p_1,&
this.st_application_name}
end on

on w_cf_plaque.destroy
destroy(this.mle_text)
destroy(this.p_1)
destroy(this.st_application_name)
end on

type mle_text from multilineedit within w_cf_plaque
integer y = 600
integer width = 1463
integer height = 492
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean displayonly = true
end type

type p_1 from picture within w_cf_plaque
integer width = 1458
integer height = 604
string picturename = "NewCFLoginScreenLogo.jpg"
boolean focusrectangle = false
end type

type st_application_name from statictext within w_cf_plaque
boolean visible = false
integer x = 672
integer y = 812
integer width = 741
integer height = 144
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "<Application>"
alignment alignment = center!
boolean focusrectangle = false
end type

