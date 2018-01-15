$PBExportHeader$w_view_transfer_history.srw
forward
global type w_view_transfer_history from w_response_std
end type
type p_1 from picture within w_view_transfer_history
end type
type st_3 from statictext within w_view_transfer_history
end type
type st_2 from statictext within w_view_transfer_history
end type
type st_nohistory from statictext within w_view_transfer_history
end type
type cb_close from commandbutton within w_view_transfer_history
end type
type dw_view_transfer_history from u_dw_std within w_view_transfer_history
end type
type ln_1 from line within w_view_transfer_history
end type
type ln_2 from line within w_view_transfer_history
end type
type st_1 from statictext within w_view_transfer_history
end type
type ln_3 from line within w_view_transfer_history
end type
type ln_4 from line within w_view_transfer_history
end type
end forward

global type w_view_transfer_history from w_response_std
integer width = 3063
integer height = 1160
string title = "Case Transfer History:"
p_1 p_1
st_3 st_3
st_2 st_2
st_nohistory st_nohistory
cb_close cb_close
dw_view_transfer_history dw_view_transfer_history
ln_1 ln_1
ln_2 ln_2
st_1 st_1
ln_3 ln_3
ln_4 ln_4
end type
global w_view_transfer_history w_view_transfer_history

type variables
String i_cCaseNumber
end variables

on w_view_transfer_history.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_3=create st_3
this.st_2=create st_2
this.st_nohistory=create st_nohistory
this.cb_close=create cb_close
this.dw_view_transfer_history=create dw_view_transfer_history
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_1=create st_1
this.ln_3=create ln_3
this.ln_4=create ln_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_nohistory
this.Control[iCurrent+5]=this.cb_close
this.Control[iCurrent+6]=this.dw_view_transfer_history
this.Control[iCurrent+7]=this.ln_1
this.Control[iCurrent+8]=this.ln_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.ln_3
this.Control[iCurrent+11]=this.ln_4
end on

on w_view_transfer_history.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_nohistory)
destroy(this.cb_close)
destroy(this.dw_view_transfer_history)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_1)
destroy(this.ln_3)
destroy(this.ln_4)
end on

event pc_setoptions;call super::pc_setoptions;/****************************************************************************************

			Event:	pc_setoptions
		 Purpose:	Please see PowerClass documentation for this event.
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	6/19/2001 K. Claver    Set the case number instance variable and set the value into 
								  the title bar.
	
***************************************************************************************/
IF Trim( Message.StringParm ) <> "" THEN
	THIS.i_cCaseNumber = Trim( Message.StringParm )
	
	THIS.Title += ( " Case Number - "+THIS.i_cCaseNumber )
END IF
end event

type p_1 from picture within w_view_transfer_history
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_3 from statictext within w_view_transfer_history
integer x = 201
integer y = 60
integer width = 1691
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Case Transfer History"
boolean focusrectangle = false
end type

type st_2 from statictext within w_view_transfer_history
integer width = 3500
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_nohistory from statictext within w_view_transfer_history
integer x = 46
integer y = 220
integer width = 1225
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "There is no transfer/copy history for this case."
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_view_transfer_history
integer x = 2560
integer y = 944
integer width = 402
integer height = 90
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
boolean default = true
end type

event clicked;/****************************************************************************************

			Event:	clicked
		 Purpose:	Please see PB documentation for this event.
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	6/19/2001 K. Claver    Close the parent.
	
***************************************************************************************/
Close( PARENT )
end event

type dw_view_transfer_history from u_dw_std within w_view_transfer_history
integer x = 37
integer y = 208
integer width = 2994
integer height = 660
integer taborder = 10
string dataobject = "d_view_transfer_history"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;/****************************************************************************************

			Event:	pcd_retrieve
		 Purpose:	Please see PowerClass documentation for this event.
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	6/19/2001 K. Claver    Retrieve the history into the datawindow.
	
***************************************************************************************/
Integer l_nRV

IF NOT IsNull( i_cCaseNumber ) AND Trim( i_cCaseNumber ) <> "" THEN
	l_nRV = THIS.Retrieve( i_cCaseNumber )
	
	IF l_nRV < 0 THEN
		ERROR.i_FWError = c_Fatal
	ELSEIF l_nRV = 0 THEN
		THIS.fu_Reset( c_IgnoreChanges )
		st_nohistory.Visible = TRUE
	ELSE
		st_nohistory.Visible = FALSE
	END IF
END IF

//Set the focus to the button so the fields in the datawindow aren't highlighted.
cb_close.Function Post SetFocus( )
end event

event pcd_setoptions;call super::pcd_setoptions;/****************************************************************************************

			Event:	pcd_setoptions
		 Purpose:	Please see PowerClass documentation for this event.
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	6/19/2001 K. Claver    Set the options for the history datawindow
	
***************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  c_NullDW, &
						  c_CopyOK+ &
						  c_SelectOnClick+ &
						  c_ModifyOK+ &
						  c_ModifyOnOpen+ &
						  c_NoMenuButtonActivation+ &
						  c_NoEnablePopup+ &
						  c_SortClickedOK+ &
						  c_NoShowEmpty )
						  
						  
						  
end event

type ln_1 from line within w_view_transfer_history
long linecolor = 8421504
integer linethickness = 4
integer beginy = 892
integer endx = 3502
integer endy = 892
end type

type ln_2 from line within w_view_transfer_history
long linecolor = 16777215
integer linethickness = 4
integer beginy = 896
integer endx = 3502
integer endy = 896
end type

type st_1 from statictext within w_view_transfer_history
integer y = 900
integer width = 3500
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217747
boolean focusrectangle = false
end type

type ln_3 from line within w_view_transfer_history
long linecolor = 8421504
integer linethickness = 4
integer beginy = 185
integer endx = 3502
integer endy = 185
end type

type ln_4 from line within w_view_transfer_history
long linecolor = 16777215
integer linethickness = 4
integer beginy = 188
integer endx = 3502
integer endy = 188
end type

