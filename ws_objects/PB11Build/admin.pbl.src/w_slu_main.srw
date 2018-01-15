$PBExportHeader$w_slu_main.srw
$PBExportComments$Enter/edit user license information.
forward
global type w_slu_main from w_main_std
end type
type cb_cancel from u_cb_cancel within w_slu_main
end type
type cb_update from u_cb_save within w_slu_main
end type
type gb_new from groupbox within w_slu_main
end type
type gb_current from groupbox within w_slu_main
end type
type dw_new from u_dw_std within w_slu_main
end type
type sle_nmbr_licenses from singlelineedit within w_slu_main
end type
type st_nmbr_licenses from statictext within w_slu_main
end type
type st_license_key from statictext within w_slu_main
end type
type sle_license_key from singlelineedit within w_slu_main
end type
end forward

global type w_slu_main from w_main_std
integer width = 1449
integer height = 1324
string title = "User License Information"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_cancel cb_cancel
cb_update cb_update
gb_new gb_new
gb_current gb_current
dw_new dw_new
sle_nmbr_licenses sle_nmbr_licenses
st_nmbr_licenses st_nmbr_licenses
st_license_key st_license_key
sle_license_key sle_license_key
end type
global w_slu_main w_slu_main

type variables

end variables

on w_slu_main.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.gb_new=create gb_new
this.gb_current=create gb_current
this.dw_new=create dw_new
this.sle_nmbr_licenses=create sle_nmbr_licenses
this.st_nmbr_licenses=create st_nmbr_licenses
this.st_license_key=create st_license_key
this.sle_license_key=create sle_license_key
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.gb_new
this.Control[iCurrent+4]=this.gb_current
this.Control[iCurrent+5]=this.dw_new
this.Control[iCurrent+6]=this.sle_nmbr_licenses
this.Control[iCurrent+7]=this.st_nmbr_licenses
this.Control[iCurrent+8]=this.st_license_key
this.Control[iCurrent+9]=this.sle_license_key
end on

on w_slu_main.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.gb_new)
destroy(this.gb_current)
destroy(this.dw_new)
destroy(this.sle_nmbr_licenses)
destroy(this.st_nmbr_licenses)
destroy(this.st_license_key)
destroy(this.sle_license_key)
end on

type cb_cancel from u_cb_cancel within w_slu_main
integer x = 1042
integer y = 1076
integer width = 320
integer taborder = 30
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
end type

event clicked;call super::clicked;//******************************************************************
//  Event         : Clicked
//  Description   : Close the window when processing is done.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  8/8/00   M. Caruso  Created.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   Close(FWCA.MGR.i_WindowCurrent)
END IF
end event

type cb_update from u_cb_save within w_slu_main
integer x = 686
integer y = 1076
integer width = 320
integer taborder = 20
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;call super::clicked;//******************************************************************
//  Event         : Clicked
//  Description   : Close the window when processing is done.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  8/8/00   M. Caruso  Created.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	IF Error.i_FWError = c_Success THEN Close(FWCA.MGR.i_WindowCurrent)
END IF
end event

type gb_new from groupbox within w_slu_main
integer x = 37
integer y = 556
integer width = 1326
integer height = 476
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "New License Information"
borderstyle borderstyle = stylelowered!
end type

type gb_current from groupbox within w_slu_main
integer x = 37
integer y = 36
integer width = 1326
integer height = 480
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Current License Information"
borderstyle borderstyle = stylelowered!
end type

type dw_new from u_dw_std within w_slu_main
event pcd_cancel ( )
integer x = 78
integer y = 640
integer width = 1262
integer height = 368
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_license_info"
boolean border = false
end type

event pcd_cancel;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : pcd_Cancel
//  Description   : Clears the update status of records in the datawindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_Reset(c_IgnoreChanges) <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    define the functionality of this datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/7/00   M. Caruso    Created.
	8/14/00  M. Caruso    Added New mode availablility.
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_NewOK + c_ModifyOK + c_ModifyOnOpen + c_NoShowEmpty)
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve the license information from the database.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/7/00   M. Caruso    Created.
	8/14/00  M. Caruso    Added code initialize a new record if one is created.
*****************************************************************************************/

LONG	ll_Null

SetRedraw (FALSE)

CHOOSE CASE retrieve ()
	CASE 0
		SetNull (ll_Null)
		fu_New (1)
		SetItem (1, 'security_id', 1)
		SetItem (1, 'nmbr_licenses', ll_Null)
		SetItem (1, 'license_key', ll_Null)
		
	CASE 1
		SetNull (ll_Null)
		sle_nmbr_licenses.text = STRING (GetItemNumber (1, 'nmbr_licenses'))
		sle_license_key.text = STRING (GetItemNumber (1, 'license_key'))
		SetItem (1, 'nmbr_licenses', ll_Null)
		SetItem (1, 'license_key', ll_Null)
		
	CASE ELSE
		MessageBox (gs_AppName, 'An error occurred while retrieving the license information.')
		
END CHOOSE

SetRedraw (TRUE)
end event

event pcd_validaterow;call super::pcd_validaterow;/*****************************************************************************************
   Event:      pcd_validaterow
   Purpose:    Validate new license information.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/11/00  M. Caruso    Created.
*****************************************************************************************/

LONG		ll_nmbr_licenses
DOUBLE	ldb_nmbr_licenses, ldb_license_key, ldb_calculatedkey
DATETIME	ldt_timestamp

IF in_save THEN

	ldb_nmbr_licenses = GetItemNumber (row_nbr, 'nmbr_licenses')
	ldb_license_key = GetItemNumber (row_nbr, 'license_key')
	IF IsNull (ldb_nmbr_licenses) OR IsNull (ldb_license_key) THEN
		MessageBox (gs_AppName, 'You must complete the license information before it can be saved.')
		IF IsNull (ldb_nmbr_licenses) THEN
			SetColumn ('nmbr_licenses')
		ELSE
			SetColumn ('license_key')
		END IF
		Error.i_FWError = c_fatal
	ELSE
		
		ldb_calculatedkey = gnv_licensemgr.uf_LicensesToKey (ldb_nmbr_licenses)
		IF ldb_calculatedkey = ldb_license_key THEN
			
			Error.i_FWError = c_success
			ldt_timestamp = PARENT.fw_GetTimeStamp ()
			SetItem (row_nbr, 'updated_by', OBJCA.WIN.fu_GetLogin(SQLCA))
			SetItem (row_nbr, 'updated_timestamp', ldt_timestamp)
			
		ELSE

			IF ldb_calculatedkey >= 0 THEN
				MessageBox (gs_AppName, 'The specified license key is invalid. Please enter a valid key.')
			ELSE
				MessageBox (gs_AppName, 'CustomerFocus cannot configure so many user licenses.')
			END IF
			Error.i_FWError = c_fatal
			
		END IF
		
	END IF
	
END IF
end event

type sle_nmbr_licenses from singlelineedit within w_slu_main
integer x = 96
integer y = 204
integer width = 343
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_nmbr_licenses from statictext within w_slu_main
integer x = 105
integer y = 132
integer width = 558
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "Number of Licenses:"
boolean focusrectangle = false
end type

type st_license_key from statictext within w_slu_main
integer x = 105
integer y = 312
integer width = 558
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "License Key:"
boolean focusrectangle = false
end type

type sle_license_key from singlelineedit within w_slu_main
integer x = 96
integer y = 384
integer width = 1207
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

