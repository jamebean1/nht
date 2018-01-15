$PBExportHeader$w_record_security.srw
$PBExportComments$Window to set demographic security
forward
global type w_record_security from w_response_std
end type
type dw_record_security from datawindow within w_record_security
end type
type cb_cancel from commandbutton within w_record_security
end type
type cb_ok from commandbutton within w_record_security
end type
end forward

global type w_record_security from w_response_std
integer width = 1289
integer height = 476
string title = "Record Security"
dw_record_security dw_record_security
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_record_security w_record_security

on w_record_security.create
int iCurrent
call super::create
this.dw_record_security=create dw_record_security
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_record_security
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
end on

on w_record_security.destroy
call super::destroy
destroy(this.dw_record_security)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
	Event:		pc_setoptions
	Purpose:		Please see the PowerClass documentation for this event
					
	Revisions:
	Date     Developer     Description
	======== ============= ================================================================
	2/28/2001 K. Claver    Added code to set visible/invisible the apply to members field
								  depending on the source type.  Also added code to populate the
								  datawindow fields with the info retrieved on the demographics tab.
*****************************************************************************************/
DatawindowChild l_dwcConfidLevel
Integer l_nConfidLevel
String l_cApplyMembers

IF IsValid( w_create_maintain_case ) THEN	
	IF w_create_maintain_case.i_cSourceType = "E" THEN
		dw_record_security.Object.apply_to_members_t.Visible = '1'
		dw_record_security.Object.apply_to_members.Visible = '1'
	ELSE
		dw_record_security.Object.apply_to_members_t.Visible = '0'
		dw_record_security.Object.apply_to_members.Visible = '0'
	END IF	
	
	dw_record_security.InsertRow( 0 )
	
	dw_record_security.GetChild( "confidentiality_level", l_dwcConfidLevel )
	l_dwcConfidLevel.SetTransObject( SQLCA )
	l_dwcConfidLevel.Retrieve( )
	
	//Set the current record security into the datawindow
	dw_record_security.Object.confidentiality_level[ 1 ] = w_create_maintain_case.i_uoDemographics.i_nRecordConfidLevel
	dw_record_security.Object.apply_to_members[ 1 ] = w_create_maintain_case.i_uoDemographics.i_cApplyToMembers
	
	dw_record_security.AcceptText( )
END IF

dw_record_security.SetFocus( )
end event

type dw_record_security from datawindow within w_record_security
integer x = 23
integer y = 20
integer width = 1234
integer height = 184
integer taborder = 10
string title = "none"
string dataobject = "d_record_security"
boolean border = false
boolean livescroll = true
end type

type cb_cancel from commandbutton within w_record_security
integer x = 896
integer y = 244
integer width = 347
integer height = 90
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;/*****************************************************************************************
	Event:		clicked
	Purpose:		Please see PB documentation for this event
					
	Revisions:
	Date     Developer     Description
	======== ============= ================================================================
	2/28/2001 K. Claver    Added code to close the parent window.
*****************************************************************************************/
Close( PARENT )
end event

type cb_ok from commandbutton within w_record_security
integer x = 517
integer y = 244
integer width = 347
integer height = 90
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;/*****************************************************************************************
	Event:		clicked
	Purpose:		Please see PB documentation for this event
					
	Revisions:
	Date     Developer     Description
	======== ============= ================================================================
	2/28/2001 K. Claver    Added code to set security level and the value of apply
								  to members depending on the source type.
*****************************************************************************************/
Integer l_nConfidLevel, l_nRV
String l_cApplyMembers

IF IsValid( w_create_maintain_case ) THEN
	dw_record_security.AcceptText( )
	
	l_nConfidLevel = dw_record_security.Object.confidentiality_level[ 1 ]
	
	IF w_create_maintain_case.i_cSourceType = "E" THEN
		l_cApplyMembers = dw_record_security.Object.apply_to_members[ 1 ]
		
		IF Trim( l_cApplyMembers ) = "" THEN
			SetNull( l_cApplyMembers )
		END IF
		
		//Set the apply to members variable
		w_create_maintain_case.i_cApplyToMembers = l_cApplyMembers
	END IF
	
	IF l_nConfidLevel > w_create_maintain_case.i_nRepRecConfidLevel AND OBJCA.WIN.fu_GetLogin( SQLCA ) <> "cfadmin" THEN		
//	   OBJCA.WIN.fu_GetLogin( SQLCA ) <> "sysadmin" THEN
//		JWhite 9.1.2006 SQL2005 mandates change from sysadmin to cfadmin
		l_nRV = MessageBox( gs_AppName, "The new security level for this demographic record will be higher than~r~n"+ &
								  "your current security - you will not be permitted to access this record.~r~n"+ &
								  "Are you sure you want to do this?", Question!, YesNo! )
								  
		IF l_nRV <> 1 THEN					
			Close( PARENT )
			//Need a return as PB attempts to execute the rest of the script.
			RETURN
		END IF
	END IF
	
	//Set the security variable
	w_create_maintain_case.i_nRecordConfidLevel = l_nConfidLevel

	//Set the security on the record
	IF IsValid( w_create_maintain_case.i_uoDemographics ) THEN
		w_create_maintain_case.i_uoDemographics.fu_SetSecurity( )
	END IF
END IF

Close( PARENT )
end event

