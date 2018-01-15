$PBExportHeader$w_close_case.srw
forward
global type w_close_case from w_response_std
end type
type st_3 from statictext within w_close_case
end type
type p_1 from picture within w_close_case
end type
type st_1 from statictext within w_close_case
end type
type cb_ok from u_cb_ok within w_close_case
end type
type cb_cancel from u_cb_cancel within w_close_case
end type
type cbx_printsurvey from checkbox within w_close_case
end type
type dw_close_case from u_dw_std within w_close_case
end type
type ln_1 from line within w_close_case
end type
type ln_2 from line within w_close_case
end type
type ln_3 from line within w_close_case
end type
type ln_4 from line within w_close_case
end type
type st_2 from statictext within w_close_case
end type
end forward

global type w_close_case from w_response_std
integer x = 366
integer y = 312
integer width = 1563
integer height = 1036
string title = "Close Case:  "
st_3 st_3
p_1 p_1
st_1 st_1
cb_ok cb_ok
cb_cancel cb_cancel
cbx_printsurvey cbx_printsurvey
dw_close_case dw_close_case
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
st_2 st_2
end type
global w_close_case w_close_case

type variables
STRING			i_cCaseNumber
S_CLOSE_PARMS	i_sCloseParms			// added 8/18/00, MPC 
end variables

forward prototypes
public function integer fw_validate ()
end prototypes

public function integer fw_validate ();//**********************************************************************************************
//
//  Function: fw_validate
//  Purpose:  Check close codes codes.
//
//  Parameters:  None
//  Returns:     c_Success or c_Fatal
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/20/00 K. Claver   Created.
//  04/23/01 C. Jacskon  Add CloseCode
//
//**********************************************************************************************

Integer l_nRV = c_Success
String l_cCusSatCodeReqd, l_cResCodeReqd, l_cCloseCodReqd

// Get the Customer Satisfaction Code and the Resolution Code
i_scloseparms.sat_code = dw_close_case.GetItemString(1,"customer_sat_code_id")
i_scloseparms.res_code = dw_close_case.GetItemString(1,"resolution_code_id")
i_scloseparms.other_close_code = dw_close_case.GetItemString(1,"other_close_code_id")
i_scloseparms.close_case = TRUE

// Are these fields required?
SELECT cus_sat_code_req, res_code_req, other_close_code_req
  INTO :l_cCusSatCodeReqd, :l_cResCodeReqd, :l_cCloseCodReqd
  FROM cusfocus.case_types
 WHERE case_type = :i_scloseparms.case_type
 USING SQLCA;
 
IF NOT ISNULL(l_cCusSatCodeReqd) THEN
	IF l_cCusSatCodeReqd = 'Y' THEN
		// This field is required, did the user enter a value for Customer Satisfaction Code?
		IF ISNULL(i_scloseparms.sat_code) THEN
			messagebox(gs_AppName,'A Customer Satisfaction Code is required for this Case Type')
				Error.i_FWError = c_Fatal
				dw_close_case.SetFocus()
				dw_close_case.SetColumn('customer_sat_code_id')
				l_nRV = c_Fatal
		END IF
	END IF
END IF


IF NOT ISNULL(l_cResCodeReqd) THEN
	IF l_cResCodeReqd = 'Y' THEN
		// This field is required, did the user enter a value for Resolution Code?
		IF ISNULL(i_scloseparms.res_code) THEN
			messagebox(gs_AppName,'A Resolution Code is required for this Case Type')
				Error.i_FWError = c_Fatal
				dw_close_case.SetFocus()
				dw_close_case.SetColumn('resolution_code_id')
				l_nRV = c_Fatal
			END IF
	END IF
END IF
	
IF NOT ISNULL(l_cCloseCodReqd) THEN
	IF l_cCloseCodReqd = 'Y' THEN
		// This field is required, did the user enter a value for Resolution Code?
		IF ISNULL(i_scloseparms.other_close_code) THEN
			messagebox(gs_AppName,'An Other Close Code is required for this Case Type')
				Error.i_FWError = c_Fatal
				dw_close_case.SetFocus()
				dw_close_case.SetColumn('other_close_code_id')
				l_nRV = c_Fatal
			END IF
	END IF
END IF
	
RETURN l_nRV
end function

event close;call super::close;/*****************************************************************************************
   Event:      pc_Close
   Purpose:    Pass back the values set in this window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/18/00  M. Caruso    Created.
*****************************************************************************************/

message.PowerObjectParm = i_scloseparms
end event

event pc_setoptions;call super::pc_setoptions;//****************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: set the options for PC dws
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------
//  04/17/00 C. Jackson    Original Version
//  04/18/00 C. Jackson    Add Code to disable to Resolution Code field if there are no
//                         codes defined for the particular case type
//  08/28/00 M. Caruso     Replaced references to parent window instance variables with
//                         local window parameter values.
//  04/23/01 C. CJackson   Add code for populating Other Close Codes
//****************************************************************************************

DATE l_dCloseDate
DATAWINDOWCHILD l_dwcResCodeID, l_dwcOtherCloseCodeID
LONG l_nResCodeIDCount, l_nOtherCloseCodeCount

l_dCloseDate = DATE(Today())

SELECT COUNT(*)
  INTO :l_nResCodeIDCount
  FROM cusfocus.resolution_codes
 WHERE case_type = :i_scloseparms.case_type
   AND UPPER(active) = 'Y'
 USING SQLCA;
 
 IF l_nResCodeIDCount = 0 THEN
	dw_close_case.Modify("resolution_code_id.Edit.DisplayOnly=Yes")
	dw_close_case.Modify ("resolution_code_id.TabSequence=0")
ELSE
	dw_close_case.GetChild('resolution_code_id', l_dwcResCodeID)
	l_dwcResCodeID.SetTransObject(SQLCA)
	l_dwcResCodeID.Retrieve(i_scloseparms.case_type)
END IF

SELECT COUNT(*)
  INTO :l_nOtherCloseCodeCount
  FROM cusfocus.other_close_codes
 WHERE case_type = :i_scloseparms.case_type
   AND UPPER(active) = 'Y'
 USING SQLCA;
 
 IF l_nOtherCloseCodeCount = 0 THEN
	dw_close_case.Modify("other_close_code_id.Edit.DisplayOnly=Yes")
	dw_close_case.Modify ("other_close_code_id.TabSequence=0")
ELSE
	dw_close_case.GetChild('other_close_code_id', l_dwcOtherCloseCodeID)
	l_dwcOtherCloseCodeID.SetTransObject(SQLCA)
	l_dwcOtherCloseCodeID.Retrieve(i_scloseparms.case_type)
END IF

fw_SetOptions(c_CloseNoSave)

dw_close_case.fu_SetOptions( SQLCA, & 
		dw_close_case.c_NullDW, & 
		dw_close_case.c_NewOK + &
		dw_close_case.c_dddwfind + &
		dw_close_case.c_NewOnOpen + &
		dw_close_case.c_NewModeOnEmpty)
		
// Add the Case Number into the Window title
Title = 'Close Case:  ' + w_create_maintain_case.i_cSelectedCase

end event

on w_close_case.create
int iCurrent
call super::create
this.st_3=create st_3
this.p_1=create p_1
this.st_1=create st_1
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.cbx_printsurvey=create cbx_printsurvey
this.dw_close_case=create dw_close_case
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.cbx_printsurvey
this.Control[iCurrent+7]=this.dw_close_case
this.Control[iCurrent+8]=this.ln_1
this.Control[iCurrent+9]=this.ln_2
this.Control[iCurrent+10]=this.ln_3
this.Control[iCurrent+11]=this.ln_4
this.Control[iCurrent+12]=this.st_2
end on

on w_close_case.destroy
call super::destroy
destroy(this.st_3)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.cbx_printsurvey)
destroy(this.dw_close_case)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.st_2)
end on

event show;call super::show;/*****************************************************************************************
   Event:      show
   Purpose:    make final interface adjustments as the window is displayed.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
   7/14/00  M. Caruso    Created.
	8/18/00  M. Caruso    Update the print_survey parameter if the case type does not have
	                      a survey assigned.  Otherwise, set the print survey check box
								 according to the print_survey parameter.
*****************************************************************************************/

STRING	ls_letterid

// get the letter ID for the current case type
SELECT letter_id INTO :ls_letterid FROM cusfocus.case_types WHERE case_type = :i_scloseparms.case_type;


IF (SQLCA.SQLCode <> 0) OR (IsNull (ls_letterid)) OR (ls_letterid = '') THEN
	// disable the print survey check box and update the case record.
	cbx_printsurvey.enabled = FALSE
	i_scloseparms.print_survey = FALSE
ELSE	
	// check this box if specified on the case screen.
	IF i_scloseparms.print_survey THEN cbx_printsurvey.checked = TRUE
END IF
		
	
	
end event

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_SetVariables
   Purpose:    Gather parameters sent to the window

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/18/00 M. Caruso    Created.
*****************************************************************************************/

i_scloseparms = powerobject_parm
end event

event pc_closequery;/*****************************************************************************************
   Event:      pc_CloseQuery
   Purpose:    Please see PowerClass documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/20/2001 K. Claver   Added code to check the satisfaction and resolution codes before
								 allow to close.
*****************************************************************************************/
Integer l_nRV = c_Success

IF i_scloseparms.close_case THEN
	//Check the satisfaction and resolution codes before allow to close
	l_nRV = THIS.fw_Validate( )
END IF

RETURN l_nRV
end event

type st_3 from statictext within w_close_case
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
string text = "Close a Case"
boolean focusrectangle = false
end type

type p_1 from picture within w_close_case
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_1 from statictext within w_close_case
integer width = 2354
integer height = 168
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

type cb_ok from u_cb_ok within w_close_case
integer x = 837
integer y = 812
integer width = 320
integer height = 90
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean default = true
end type

event clicked;//***************************************************************************************
//
//  Event:   clicked
//  Purpose: save changes
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------
//  04/17/00 C. Jackson    Original Version
//  08/18/00 M. Caruso     Updated to set return values in instance variable i_scloseparms.
//  3/20/2001 K. Claver    Moved the code to check the satisfaction and resolution codes to
//									the fw_Validate function.
//****************************************************************************************

Integer l_nRV

// Determine if we need to print the survey
IF cbx_printsurvey.Checked = TRUE THEN
	i_scloseparms.print_survey = TRUE
ELSE
	i_scloseparms.print_survey = FALSE
END IF

// Check the Customer Satisfaction Code and the Resolution Code
l_nRV = PARENT.fw_Validate( )

//Don't close if validation fails
IF l_nRV = c_Success THEN
	Close (Parent)
END IF


end event

type cb_cancel from u_cb_cancel within w_close_case
integer x = 1193
integer y = 812
integer width = 320
integer height = 90
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;call super::clicked;//****************************************************************************************
//
//  Event:   clicked
//  Purpose: User has canceled out of this window.  
//
//  Date     Developer     Description
//  -------- ------------- --------------------------------------------------------------
//  04/17/00 C. Jackson    Original Version
//  08/18/00 M. Caruso     Updated to set return values in instance variable i_scloseparms.
//****************************************************************************************
  
i_scloseparms.close_case = FALSE

Close(Parent)


end event

type cbx_printsurvey from checkbox within w_close_case
integer x = 1074
integer y = 668
integer width = 434
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 80269524
string text = "Print Survey:"
boolean lefttext = true
end type

type dw_close_case from u_dw_std within w_close_case
integer y = 188
integer width = 1536
integer height = 464
integer taborder = 10
string dataobject = "d_close_case"
boolean border = false
end type

event pcd_new;call super::pcd_new;//************************************************************************************************
//
//  Event:   pcd_new
//  Purpose: set the closed date/time
//  
//  Date     Developer     Description
//  -------- ------------- -----------------------------------------------------------------------
//  04/18/00 C. Jackson    Original Version
//  
//************************************************************************************************  

dw_close_case.SetItem(1, 'case_log_clsd_date', w_create_maintain_case.fw_gettimestamp())



end event

type ln_1 from line within w_close_case
long linecolor = 16777215
integer linethickness = 4
integer beginy = 768
integer endx = 2400
integer endy = 768
end type

type ln_2 from line within w_close_case
long linecolor = 8421504
integer linethickness = 4
integer beginy = 764
integer endx = 2400
integer endy = 764
end type

type ln_3 from line within w_close_case
long linecolor = 16777215
integer linethickness = 4
integer beginy = 172
integer endx = 2400
integer endy = 172
end type

type ln_4 from line within w_close_case
long linecolor = 8421504
integer linethickness = 4
integer beginy = 168
integer endx = 2400
integer endy = 168
end type

type st_2 from statictext within w_close_case
integer x = 5
integer y = 772
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

