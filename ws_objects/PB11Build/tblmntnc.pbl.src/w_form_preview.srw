$PBExportHeader$w_form_preview.srw
forward
global type w_form_preview from w_response_std
end type
type dw_preview from u_dw_std within w_form_preview
end type
type cb_close from commandbutton within w_form_preview
end type
end forward

global type w_form_preview from w_response_std
integer width = 3653
integer height = 1908
string title = "Form Template Preview"
dw_preview dw_preview
cb_close cb_close
end type
global w_form_preview w_form_preview

on w_form_preview.create
int iCurrent
call super::create
this.dw_preview=create dw_preview
this.cb_close=create cb_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_preview
this.Control[iCurrent+2]=this.cb_close
end on

on w_form_preview.destroy
call super::destroy
destroy(this.dw_preview)
destroy(this.cb_close)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_SetOptions
   Purpose:    Please see PowerClass documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/10/2002 K. Claver    Added code to set the preview datawindow to the one passed in.
*****************************************************************************************/
u_dw_std l_dwTemp
String l_cSyntax

IF IsValid( Message.PowerObjectParm ) AND NOT IsNull( Message.PowerObjectParm ) THEN
	IF Message.PowerObjectParm.TypeOf( ) = Datawindow! THEN		
		l_dwTemp = Message.PowerObjectParm
		l_cSyntax = l_dwTemp.Object.Datawindow.Syntax
		dw_preview.Create( l_cSyntax )
		dw_preview.InsertRow( 0 )
	END IF
END IF
end event

type dw_preview from u_dw_std within w_form_preview
integer x = 5
integer y = 4
integer width = 3616
integer height = 1668
integer taborder = 10
string dataobject = ""
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

type cb_close from commandbutton within w_form_preview
integer x = 3209
integer y = 1688
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;//**********************************************************************************************
//
//  Event:   Clicked
//  Purpose: Please see PB documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/07/2002 K. Claver   Close the window
//**********************************************************************************************
Close( PARENT )
end event

