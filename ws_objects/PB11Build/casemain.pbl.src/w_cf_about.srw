$PBExportHeader$w_cf_about.srw
$PBExportComments$About Response Window for CustomerFocus
forward
global type w_cf_about from w_response
end type
type st_2 from statictext within w_cf_about
end type
type st_connect from statictext within w_cf_about
end type
type st_version_date from statictext within w_cf_about
end type
type st_version_number from statictext within w_cf_about
end type
type p_2 from picture within w_cf_about
end type
type st_1 from statictext within w_cf_about
end type
type cb_1 from commandbutton within w_cf_about
end type
type mle_text from multilineedit within w_cf_about
end type
type ln_2 from line within w_cf_about
end type
type ln_1 from line within w_cf_about
end type
end forward

global type w_cf_about from w_response
integer x = 873
integer y = 484
integer width = 1458
integer height = 1628
string title = "About CustomerFocus"
long backcolor = 16777215
event ue_key pbm_keydown
st_2 st_2
st_connect st_connect
st_version_date st_version_date
st_version_number st_version_number
p_2 p_2
st_1 st_1
cb_1 cb_1
mle_text mle_text
ln_2 ln_2
ln_1 ln_1
end type
global w_cf_about w_cf_about

type variables
boolean 	ib_true
string	is_series = ''
end variables

event ue_key;//-----------------------------------------------------------------------------------------------------------------------------------

// Pay no attention to the man behind the curtain.....
//-----------------------------------------------------------------------------------------------------------------------------------


Choose Case	key
	Case key1!
		is_series = is_series + '1'	
	Case key2!
		is_series = is_series + '2'
	Case key3!
		is_series = is_series + '3'	
	Case key4! 
		is_series = is_series + '4'
	Case key5!
		is_series = is_series + '5'			
	Case key6!
		is_series = is_series + '6'			
	Case key8!
		is_series = is_series + '8'			
End Choose

If is_series = '4815162342' Then
	n_multimedia 	ln_multi 
	ln_multi.of_play_sound('cf.wav')
	p_2.picturename = 'lost.jpg'
End If
end event

event pc_options;call super::pc_options;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_SetOptions
//  Description   : Center the window in the middle of the screen.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1995.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Set the position of the window.
//------------------------------------------------------------------

fw_SetOptions(c_AutoPosition)

end event

on w_cf_about.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_connect=create st_connect
this.st_version_date=create st_version_date
this.st_version_number=create st_version_number
this.p_2=create p_2
this.st_1=create st_1
this.cb_1=create cb_1
this.mle_text=create mle_text
this.ln_2=create ln_2
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_connect
this.Control[iCurrent+3]=this.st_version_date
this.Control[iCurrent+4]=this.st_version_number
this.Control[iCurrent+5]=this.p_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.mle_text
this.Control[iCurrent+9]=this.ln_2
this.Control[iCurrent+10]=this.ln_1
end on

on w_cf_about.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_connect)
destroy(this.st_version_date)
destroy(this.st_version_number)
destroy(this.p_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.mle_text)
destroy(this.ln_2)
destroy(this.ln_1)
end on

event open;call super::open;//*********************************************************************************************
//
//  Event:  Open
//
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  08/11/00 C. Jackson  Add Date String for displaying build date in the Version #. (SCR 739)
//  08/22/00 C. Jackson  Remove " - " from the Version # (SCR 776)
//  5/29/2002 K. Claver  Added connection name information 
//  8/22/2004 K. Claver  Changed references to Quovadx back to Outlaw Technologies.
//
//*********************************************************************************************


String ls_Sec, ls_ClientText = "", ls_DefaultText, ls_datestring
Long ll_Index = 0

st_version_number.Text = "Version: " + gs_AppVersion
ls_datestring = String(ld_BuildDate, "mmddyyyy")
st_version_date.Text = ls_datestring
st_connect.Text = ( "Connection: "+gs_ConnectionName )

//Set the Outlaw Text to use as the default text
ls_DefaultText = "Copyright 1999 Outlaw Technologies Inc.  All rights reserved.  "+ &
			 "Outlaw Technologies, the Outlaw Technologies logo, and CustomerFocus "+ &
			 "are trademarks of Outlaw Technologies which may be registered in some "+ &
			 "jurisdictions.~r~n~r~nMicrosoft is a registered trademark and Windows "+ &
			 "is a trademark of Microsoft Corporation. Oracle is a registered "+ &
			 "trademark of Oracle Corporation. Sybase is a registered trademark of "+ &
			 "Sybase Corporation.~r~n~r~nWarning:  This computer program is "+ &
			 "protected by copyright law and international treaties.  Unauthorized "+ &
			 "reproduction or distribution of this program, or any portion of it, "+ &
			 "may result in severe civil and criminal penalties, and will be "+ &
			 "prosecuted to the maximum extent possible under the law."

//If installing for a client that wants their own graphics and text,
//  switch to the client specific graphics and client specific
//  text
IF Upper( gs_Client ) = "YES" THEN
	p_2.PictureName = "client_logo_c.jpg"
	
	IF FileExists( "client.txt" ) THEN
		DO
			ll_Index ++
			
			ls_Sec = ProfileString( "client.txt", "About Text", "Sec"+String( ll_Index ), "" )
			IF Trim( ls_Sec ) <> "" THEN
				ls_ClientText += ls_Sec+"~r~n~r~n"
			END IF
			
		LOOP UNTIL Trim( ls_Sec ) = ""
		
		IF Trim( ls_ClientText ) <> "" THEN
			//Trim off the remaining newline characters and set the mle text to
			//  the variable
			ls_ClientText = Mid( ls_ClientText, 1, ( Len( ls_ClientText ) - 4 ) )
			
			mle_text.Text = ls_ClientText
		ELSE
			mle_text.Text = ls_DefaultText
		END IF
	ELSE
		mle_text.Text = ls_DefaultText
	END IF	
ELSE
	mle_text.Text = ls_DefaultText
END IF

//If an application name is specified, switch to the 
//  name specified
IF gs_AppName <> "" THEN
	THIS.Title = "About "+gs_AppName
END IF
end event

type st_2 from statictext within w_cf_about
integer y = 1368
integer width = 2350
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217730
boolean focusrectangle = false
end type

type st_connect from statictext within w_cf_about
integer x = 14
integer y = 752
integer width = 1582
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 1090519039
string text = "Connection:{connection name}"
boolean focusrectangle = false
end type

type st_version_date from statictext within w_cf_about
integer x = 338
integer y = 692
integer width = 357
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "{build dt}"
boolean focusrectangle = false
end type

type st_version_number from statictext within w_cf_about
integer x = 14
integer y = 692
integer width = 329
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Version: 3.0"
boolean focusrectangle = false
end type

type p_2 from picture within w_cf_about
integer width = 1458
integer height = 604
boolean bringtotop = true
string picturename = "NewCFLoginScreenLogo.jpg"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cf_about
integer x = 46
integer y = 612
integer width = 1367
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "Healthcare Relationship Management System"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cf_about
integer x = 1083
integer y = 1424
integer width = 320
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;Close(Parent)
end event

type mle_text from multilineedit within w_cf_about
integer x = 18
integer y = 844
integer width = 1408
integer height = 500
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type ln_2 from line within w_cf_about
long linecolor = 8421504
integer linethickness = 4
integer beginx = -5
integer beginy = 1360
integer endx = 2395
integer endy = 1360
end type

type ln_1 from line within w_cf_about
long linecolor = 16777215
integer linethickness = 4
integer beginx = -5
integer beginy = 1364
integer endx = 2395
integer endy = 1364
end type

