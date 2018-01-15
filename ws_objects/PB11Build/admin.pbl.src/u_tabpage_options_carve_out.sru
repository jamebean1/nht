$PBExportHeader$u_tabpage_options_carve_out.sru
$PBExportComments$Carve Out Options preferences tab
forward
global type u_tabpage_options_carve_out from u_container_std
end type
type cbx_enabled from checkbox within u_tabpage_options_carve_out
end type
type cbx_mo from checkbox within u_tabpage_options_carve_out
end type
type cbx_me from checkbox within u_tabpage_options_carve_out
end type
type cbx_mp from checkbox within u_tabpage_options_carve_out
end type
type cbx_mm from checkbox within u_tabpage_options_carve_out
end type
type cbx_po from checkbox within u_tabpage_options_carve_out
end type
type cbx_pe from checkbox within u_tabpage_options_carve_out
end type
type cbx_pp from checkbox within u_tabpage_options_carve_out
end type
type cbx_pm from checkbox within u_tabpage_options_carve_out
end type
type cbx_co from checkbox within u_tabpage_options_carve_out
end type
type cbx_ce from checkbox within u_tabpage_options_carve_out
end type
type cbx_cp from checkbox within u_tabpage_options_carve_out
end type
type cbx_cm from checkbox within u_tabpage_options_carve_out
end type
type cbx_io from checkbox within u_tabpage_options_carve_out
end type
type cbx_ie from checkbox within u_tabpage_options_carve_out
end type
type cbx_ip from checkbox within u_tabpage_options_carve_out
end type
type cbx_im from checkbox within u_tabpage_options_carve_out
end type
type st_other from statictext within u_tabpage_options_carve_out
end type
type st_group from statictext within u_tabpage_options_carve_out
end type
type st_provider from statictext within u_tabpage_options_carve_out
end type
type st_member from statictext within u_tabpage_options_carve_out
end type
type st_configcase from statictext within u_tabpage_options_carve_out
end type
type st_proactive from statictext within u_tabpage_options_carve_out
end type
type st_issueconcern from statictext within u_tabpage_options_carve_out
end type
type st_inquiry from statictext within u_tabpage_options_carve_out
end type
type gb_availability from groupbox within u_tabpage_options_carve_out
end type
end forward

global type u_tabpage_options_carve_out from u_container_std
integer width = 1929
integer height = 1560
boolean border = false
string text = "Carve Out"
event ue_initpage ( )
event ue_savepage ( )
cbx_enabled cbx_enabled
cbx_mo cbx_mo
cbx_me cbx_me
cbx_mp cbx_mp
cbx_mm cbx_mm
cbx_po cbx_po
cbx_pe cbx_pe
cbx_pp cbx_pp
cbx_pm cbx_pm
cbx_co cbx_co
cbx_ce cbx_ce
cbx_cp cbx_cp
cbx_cm cbx_cm
cbx_io cbx_io
cbx_ie cbx_ie
cbx_ip cbx_ip
cbx_im cbx_im
st_other st_other
st_group st_group
st_provider st_provider
st_member st_member
st_configcase st_configcase
st_proactive st_proactive
st_issueconcern st_issueconcern
st_inquiry st_inquiry
gb_availability gb_availability
end type
global u_tabpage_options_carve_out u_tabpage_options_carve_out

type variables
BOOLEAN				i_bFirstOpen

STRING				i_cAvailabilityValues[16]

W_SYSTEM_OPTIONS	i_wParentWindow
end variables

forward prototypes
public function boolean fu_inuse (string a_ccasetype, string a_csourcetype)
end prototypes

event ue_initpage;/*****************************************************************************************
   Function:   ue_initpage
   Purpose:    Initialize the interface for this page.
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	03/20/01 M. Caruso    Added Enabled option.
*****************************************************************************************/

LONG			l_nRow, l_nMaxRows, l_nRowCount
INTEGER		l_nIndex
STRING		l_cOption, l_cValue, l_cValue1, l_cValue2, l_cValue3, l_cValue4

IF i_bFirstOpen THEN
	
	i_bFirstOpen = FALSE
	
	SetRedraw (FALSE)
	
	l_nMaxRows = i_wParentWindow.i_dsOptions.RowCount ()
	FOR l_nRow = 1 TO l_nMaxRows
		
		l_cOption = Upper (i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_name'))
		CHOOSE CASE l_cOption
			CASE 'CARVEOUT ENABLED'
				l_cValue = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')
				IF l_cValue = 'Y' THEN
					cbx_enabled.checked = TRUE
				ELSE
					cbx_enabled.checked = FALSE
				END IF
				
			CASE 'CARVEOUT ISSUE'
				l_cValue2 = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')
				IF IsNull (l_cValue2) THEN
					// set option array as if all were selected by default
					i_cavailabilityvalues[5] = 'C'
					i_cavailabilityvalues[6] = 'P'
					i_cavailabilityvalues[7] = 'E'
					i_cavailabilityvalues[8] = 'O'
					cbx_cm.checked = TRUE
					cbx_cp.checked = TRUE
					cbx_ce.checked = TRUE
					cbx_co.checked = TRUE
				ELSE
					// check the boxes based on the retrieved values
					IF pos (l_cValue2, 'C') > 0 THEN
						i_cavailabilityvalues[5] = 'C'
						cbx_cm.checked = TRUE
					ELSE
						i_cavailabilityvalues[5] = ''
						cbx_cm.checked = FALSE
					END IF
					
					IF pos (l_cValue2, 'P') > 0 THEN
						i_cavailabilityvalues[6] = 'P'
						cbx_cp.checked = TRUE
					ELSE
						i_cavailabilityvalues[6] = ''
						cbx_cp.checked = FALSE
					END IF
					
					IF pos (l_cValue2, 'E') > 0 THEN
						i_cavailabilityvalues[7] = 'E'
						cbx_ce.checked = TRUE
					ELSE
						i_cavailabilityvalues[7] = ''
						cbx_ce.checked = FALSE
					END IF
					
					IF pos (l_cValue2, 'O') > 0 THEN
						i_cavailabilityvalues[8] = 'O'
						cbx_co.checked = TRUE
					ELSE
						i_cavailabilityvalues[8] = ''
						cbx_co.checked = FALSE
					END IF
					
				END IF
				
			CASE 'CARVEOUT INQUIRY'
				l_cValue1 = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')
				IF IsNull (l_cValue1) THEN
					// set option array as if all were selected by default
					i_cavailabilityvalues[1] = 'C'
					i_cavailabilityvalues[2] = 'P'
					i_cavailabilityvalues[3] = 'E'
					i_cavailabilityvalues[4] = 'O'
					cbx_im.checked = TRUE
					cbx_ip.checked = TRUE
					cbx_ie.checked = TRUE
					cbx_io.checked = TRUE
				ELSE
					// check the boxes based on the retrieved values
					IF pos (l_cValue1, 'C') > 0 THEN
						i_cavailabilityvalues[1] = 'C'
						cbx_im.checked = TRUE
					ELSE
						i_cavailabilityvalues[1] = ''
						cbx_im.checked = FALSE
					END IF
					
					IF pos (l_cValue1, 'P') > 0 THEN
						i_cavailabilityvalues[2] = 'P'
						cbx_ip.checked = TRUE
					ELSE
						i_cavailabilityvalues[2] = ''
						cbx_ip.checked = FALSE
					END IF
					
					IF pos (l_cValue1, 'E') > 0 THEN
						i_cavailabilityvalues[3] = 'E'
						cbx_ie.checked = TRUE
					ELSE
						i_cavailabilityvalues[3] = ''
						cbx_ie.checked = FALSE
					END IF
					
					IF pos (l_cValue1, 'O') > 0 THEN
						i_cavailabilityvalues[4] = 'O'
						cbx_io.checked = TRUE
					ELSE
						i_cavailabilityvalues[4] = ''
						cbx_io.checked = FALSE
					END IF
					
				END IF
				
			CASE 'CARVEOUT CONFIGURABLE'
				l_cValue4 = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')
				IF IsNull (l_cValue4) THEN
					// set option array as if all were selected by default
					i_cavailabilityvalues[13] = 'C'
					i_cavailabilityvalues[14] = 'P'
					i_cavailabilityvalues[15] = 'E'
					i_cavailabilityvalues[16] = 'O'
					cbx_mm.checked = TRUE
					cbx_mp.checked = TRUE
					cbx_me.checked = TRUE
					cbx_mo.checked = TRUE
				ELSE
					// check the boxes based on the retrieved values
					IF pos (l_cValue4, 'C') > 0 THEN
						i_cavailabilityvalues[13] = 'C'
						cbx_mm.checked = TRUE
					ELSE
						i_cavailabilityvalues[13] = ''
						cbx_mm.checked = FALSE
					END IF
					
					IF pos (l_cValue4, 'P') > 0 THEN
						i_cavailabilityvalues[14] = 'P'
						cbx_mp.checked = TRUE
					ELSE
						i_cavailabilityvalues[14] = ''
						cbx_mp.checked = FALSE
					END IF
					
					IF pos (l_cValue4, 'E') > 0 THEN
						i_cavailabilityvalues[15] = 'E'
						cbx_me.checked = TRUE
					ELSE
						i_cavailabilityvalues[15] = ''
						cbx_me.checked = FALSE
					END IF
					
					IF pos (l_cValue4, 'O') > 0 THEN
						i_cavailabilityvalues[16] = 'O'
						cbx_mo.checked = TRUE
					ELSE
						i_cavailabilityvalues[16] = ''
						cbx_mo.checked = FALSE
					END IF
					
				END IF
				
			CASE 'CARVEOUT PROACTIVE'
				l_cValue3 = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')
				IF IsNull (l_cValue3) THEN
					// set option array as if all were selected by default
					i_cavailabilityvalues[9] = 'C'
					i_cavailabilityvalues[10] = 'P'
					i_cavailabilityvalues[11] = 'E'
					i_cavailabilityvalues[12] = 'O'
					cbx_pm.checked = TRUE
					cbx_pp.checked = TRUE
					cbx_pe.checked = TRUE
					cbx_po.checked = TRUE
				ELSE
					// check the boxes based on the retrieved values
					IF pos (l_cValue3, 'C') > 0 THEN
						i_cavailabilityvalues[9] = 'C'
						cbx_pm.checked = TRUE
					ELSE
						i_cavailabilityvalues[9] = ''
						cbx_pm.checked = FALSE
					END IF
					
					IF pos (l_cValue3, 'P') > 0 THEN
						i_cavailabilityvalues[10] = 'P'
						cbx_pp.checked = TRUE
					ELSE
						i_cavailabilityvalues[10] = ''
						cbx_pp.checked = FALSE
					END IF
					
					IF pos (l_cValue3, 'E') > 0 THEN
						i_cavailabilityvalues[11] = 'E'
						cbx_pe.checked = TRUE
					ELSE
						i_cavailabilityvalues[11] = ''
						cbx_pe.checked = FALSE
					END IF
					
					IF pos (l_cValue3, 'O') > 0 THEN
						i_cavailabilityvalues[12] = 'O'
						cbx_po.checked = TRUE
					ELSE
						i_cavailabilityvalues[12] = ''
						cbx_po.checked = FALSE
					END IF
					
				END IF
				
		END CHOOSE
				
	NEXT
	
	IF NOT cbx_enabled.checked THEN
		
		// disable and clear the availability interface
		cbx_mo.enabled = FALSE
		cbx_me.enabled = FALSE
		cbx_mp.enabled = FALSE
		cbx_mm.enabled = FALSE
		cbx_po.enabled = FALSE
		cbx_pe.enabled = FALSE
		cbx_pp.enabled = FALSE
		cbx_pm.enabled = FALSE
		cbx_co.enabled = FALSE
		cbx_ce.enabled = FALSE
		cbx_cp.enabled = FALSE
		cbx_cm.enabled = FALSE
		cbx_io.enabled = FALSE
		cbx_ie.enabled = FALSE
		cbx_ip.enabled = FALSE
		cbx_im.enabled = FALSE
		
		cbx_mo.checked = FALSE
		cbx_me.checked = FALSE
		cbx_mp.checked = FALSE
		cbx_mm.checked = FALSE
		cbx_po.checked = FALSE
		cbx_pe.checked = FALSE
		cbx_pp.checked = FALSE
		cbx_pm.checked = FALSE
		cbx_co.checked = FALSE
		cbx_ce.checked = FALSE
		cbx_cp.checked = FALSE
		cbx_cm.checked = FALSE
		cbx_io.checked = FALSE
		cbx_ie.checked = FALSE
		cbx_ip.checked = FALSE
		cbx_im.checked = FALSE
		
		FOR l_nIndex = 1 TO 16
			i_cavailabilityvalues[l_nIndex] = ''
		NEXT
		
	END IF
	
	st_configcase.Text = gs_ConfigCaseType + ':'
	
	SetRedraw (TRUE)
	
END IF
end event

event ue_savepage;/*****************************************************************************************
   Function:   ue_savepage
   Purpose:    Save the options on the interface for this page.
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	01/31/02 M. Caruso    Only process if the other tabs have saved successfully.
*****************************************************************************************/

LONG		l_nRow, l_nNumValue, l_nMaxRows, l_nIndex
STRING	l_cOption, l_cValue1, l_cValue2, l_cValue3, l_cValue4

IF NOT i_wParentWindow.i_bSaveFailed THEN

	l_cValue1 = i_cAvailabilityValues[1] + i_cAvailabilityValues[2] + &
					i_cAvailabilityValues[3] + i_cAvailabilityValues[4]
	l_cValue2 = i_cAvailabilityValues[5] + i_cAvailabilityValues[6] + &
					i_cAvailabilityValues[7] + i_cAvailabilityValues[8]
	l_cValue3 = i_cAvailabilityValues[9] + i_cAvailabilityValues[10] + &
					i_cAvailabilityValues[11] + i_cAvailabilityValues[12]
	l_cValue4 = i_cAvailabilityValues[13] + i_cAvailabilityValues[14] + &
					i_cAvailabilityValues[15] + i_cAvailabilityValues[16]
	
	l_nMaxRows = i_wParentWindow.i_dsOptions.RowCount ()
	FOR l_nRow = 1 TO l_nMaxRows
		
		l_cOption = Upper (i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_name'))
		CHOOSE CASE l_cOption
			CASE 'CARVEOUT ENABLED'
				IF cbx_enabled.checked THEN
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', 'Y')
				ELSE
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', 'N')
				END IF
				
			CASE 'CARVEOUT ISSUE'
				i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue2)
				
			CASE 'CARVEOUT INQUIRY'
				i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue1)
					
			CASE 'CARVEOUT CONFIGURABLE'
				i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue4)
						
			CASE 'CARVEOUT PROACTIVE'
				i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue3)
				
		END CHOOSE
		
	NEXT
	
	i_wParentWindow.i_bSaveFailed = FALSE
	i_wParentWindow.i_bCloseWindow = TRUE
	
END IF
end event

public function boolean fu_inuse (string a_ccasetype, string a_csourcetype);/*****************************************************************************************
   Function:   fu_InUse
   Purpose:    Determine if the Carve Out functionality has already been used.
   Parameters: NONE
   Returns:    BOOLEAN - TRUE:	in use
								 FALSE:	not yet used

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/23/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added check for case type and source type combinations.
*****************************************************************************************/

LONG	l_nCount

IF a_cCaseType = "A" AND a_cSourceType = "A" THEN
	//Check all
	SELECT count (co_id)
	  INTO :l_nCount
	  FROM cusfocus.carve_out_entries
	 USING SQLCA;
ELSE
	//Check the case type and source type combination
	SELECT count (co_id)
	  INTO :l_nCount
	  FROM cusfocus.carve_out_entries
	 WHERE cusfocus.carve_out_entries.case_type = :a_cCaseType AND
	 		 cusfocus.carve_out_entries.source_type = :a_cSourceType
	 USING SQLCA;
END IF

CHOOSE CASE SQLCA.SQLCode
	CASE -1
		MessageBox (gs_appname, 'There was an error checking the Carve Out feature status.')
		RETURN TRUE
		
	CASE 0
		IF l_nCount > 0 THEN
			IF a_cCaseType = "A" AND a_cSourceType = "A" THEN
				MessageBox( gs_AppName, "This option cannot be unchecked while carve out entries exist", StopSign!, OK! ) 
			ELSE
				MessageBox( gs_AppName, "Carve out entries exist on cases with this case and source type combination.~r~n"+ &
								"This option cannot be unchecked while the carve out entries exist", StopSign!, OK! )
			END IF
			
			RETURN TRUE
		ELSE
			RETURN FALSE
		END IF
		
	CASE 100
		RETURN TRUE

END CHOOSE
end function

on u_tabpage_options_carve_out.create
int iCurrent
call super::create
this.cbx_enabled=create cbx_enabled
this.cbx_mo=create cbx_mo
this.cbx_me=create cbx_me
this.cbx_mp=create cbx_mp
this.cbx_mm=create cbx_mm
this.cbx_po=create cbx_po
this.cbx_pe=create cbx_pe
this.cbx_pp=create cbx_pp
this.cbx_pm=create cbx_pm
this.cbx_co=create cbx_co
this.cbx_ce=create cbx_ce
this.cbx_cp=create cbx_cp
this.cbx_cm=create cbx_cm
this.cbx_io=create cbx_io
this.cbx_ie=create cbx_ie
this.cbx_ip=create cbx_ip
this.cbx_im=create cbx_im
this.st_other=create st_other
this.st_group=create st_group
this.st_provider=create st_provider
this.st_member=create st_member
this.st_configcase=create st_configcase
this.st_proactive=create st_proactive
this.st_issueconcern=create st_issueconcern
this.st_inquiry=create st_inquiry
this.gb_availability=create gb_availability
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_enabled
this.Control[iCurrent+2]=this.cbx_mo
this.Control[iCurrent+3]=this.cbx_me
this.Control[iCurrent+4]=this.cbx_mp
this.Control[iCurrent+5]=this.cbx_mm
this.Control[iCurrent+6]=this.cbx_po
this.Control[iCurrent+7]=this.cbx_pe
this.Control[iCurrent+8]=this.cbx_pp
this.Control[iCurrent+9]=this.cbx_pm
this.Control[iCurrent+10]=this.cbx_co
this.Control[iCurrent+11]=this.cbx_ce
this.Control[iCurrent+12]=this.cbx_cp
this.Control[iCurrent+13]=this.cbx_cm
this.Control[iCurrent+14]=this.cbx_io
this.Control[iCurrent+15]=this.cbx_ie
this.Control[iCurrent+16]=this.cbx_ip
this.Control[iCurrent+17]=this.cbx_im
this.Control[iCurrent+18]=this.st_other
this.Control[iCurrent+19]=this.st_group
this.Control[iCurrent+20]=this.st_provider
this.Control[iCurrent+21]=this.st_member
this.Control[iCurrent+22]=this.st_configcase
this.Control[iCurrent+23]=this.st_proactive
this.Control[iCurrent+24]=this.st_issueconcern
this.Control[iCurrent+25]=this.st_inquiry
this.Control[iCurrent+26]=this.gb_availability
end on

on u_tabpage_options_carve_out.destroy
call super::destroy
destroy(this.cbx_enabled)
destroy(this.cbx_mo)
destroy(this.cbx_me)
destroy(this.cbx_mp)
destroy(this.cbx_mm)
destroy(this.cbx_po)
destroy(this.cbx_pe)
destroy(this.cbx_pp)
destroy(this.cbx_pm)
destroy(this.cbx_co)
destroy(this.cbx_ce)
destroy(this.cbx_cp)
destroy(this.cbx_cm)
destroy(this.cbx_io)
destroy(this.cbx_ie)
destroy(this.cbx_ip)
destroy(this.cbx_im)
destroy(this.st_other)
destroy(this.st_group)
destroy(this.st_provider)
destroy(this.st_member)
destroy(this.st_configcase)
destroy(this.st_proactive)
destroy(this.st_issueconcern)
destroy(this.st_inquiry)
destroy(this.gb_availability)
end on

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_setvariables
   Purpose:    initialize instance variables for this page.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/08/00 M. Caruso    Created.
*****************************************************************************************/

i_bFirstOpen = TRUE

i_wParentWindow = w_system_options
end event

type cbx_enabled from checkbox within u_tabpage_options_carve_out
integer x = 55
integer y = 36
integer width = 709
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enable Carve Out:"
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Check if the current state can be changed.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/20/01 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nIndex

IF checked THEN
	
	// enable the interface for specifying availability
	cbx_mo.enabled = TRUE
	cbx_me.enabled = TRUE
	cbx_mp.enabled = TRUE
	cbx_mm.enabled = TRUE
	cbx_po.enabled = TRUE
	cbx_pe.enabled = TRUE
	cbx_pp.enabled = TRUE
	cbx_pm.enabled = TRUE
	cbx_co.enabled = TRUE
	cbx_ce.enabled = TRUE
	cbx_cp.enabled = TRUE
	cbx_cm.enabled = TRUE
	cbx_io.enabled = TRUE
	cbx_ie.enabled = TRUE
	cbx_ip.enabled = TRUE
	cbx_im.enabled = TRUE
	
ELSE
	
	IF fu_InUse ("A", "A") THEN
		checked = TRUE
	ELSE
	
		// disable and clear the availability interface
		cbx_mo.enabled = FALSE
		cbx_me.enabled = FALSE
		cbx_mp.enabled = FALSE
		cbx_mm.enabled = FALSE
		cbx_po.enabled = FALSE
		cbx_pe.enabled = FALSE
		cbx_pp.enabled = FALSE
		cbx_pm.enabled = FALSE
		cbx_co.enabled = FALSE
		cbx_ce.enabled = FALSE
		cbx_cp.enabled = FALSE
		cbx_cm.enabled = FALSE
		cbx_io.enabled = FALSE
		cbx_ie.enabled = FALSE
		cbx_ip.enabled = FALSE
		cbx_im.enabled = FALSE
		
		cbx_mo.checked = FALSE
		cbx_me.checked = FALSE
		cbx_mp.checked = FALSE
		cbx_mm.checked = FALSE
		cbx_po.checked = FALSE
		cbx_pe.checked = FALSE
		cbx_pp.checked = FALSE
		cbx_pm.checked = FALSE
		cbx_co.checked = FALSE
		cbx_ce.checked = FALSE
		cbx_cp.checked = FALSE
		cbx_cm.checked = FALSE
		cbx_io.checked = FALSE
		cbx_ie.checked = FALSE
		cbx_ip.checked = FALSE
		cbx_im.checked = FALSE
		
		FOR l_nIndex = 1 TO 16
			i_cavailabilityvalues[l_nIndex] = ''
		NEXT
		
	END IF
	
END IF
end event

type cbx_mo from checkbox within u_tabpage_options_carve_out
integer x = 1655
integer y = 600
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[16] = 'O'
ELSE
	IF PARENT.fu_InUse( "M", "O" ) THEN
		THIS.Checked = TRUE
	ELSE
		i_cavailabilityvalues[16] = ''
	END IF
END IF
end event

type cbx_me from checkbox within u_tabpage_options_carve_out
integer x = 1335
integer y = 600
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[15] = 'E'
ELSE
	IF PARENT.fu_InUse( "M", "E" ) THEN
		THIS.Checked = TRUE
	ELSE
		i_cavailabilityvalues[15] = ''
	END IF
END IF
end event

type cbx_mp from checkbox within u_tabpage_options_carve_out
integer x = 1015
integer y = 600
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[14] = 'P'
ELSE
	IF PARENT.fu_InUse( "M", "P" ) THEN
		THIS.Checked = TRUE
	ELSE
		i_cavailabilityvalues[14] = ''
	END IF
END IF
end event

type cbx_mm from checkbox within u_tabpage_options_carve_out
integer x = 695
integer y = 600
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[13] = 'C'
ELSE
	IF PARENT.fu_InUse( "M", "C" ) THEN
		THIS.Checked = TRUE
	ELSE
		i_cavailabilityvalues[13] = ''
	END IF
END IF
end event

type cbx_po from checkbox within u_tabpage_options_carve_out
integer x = 1655
integer y = 524
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[12] = 'O'
ELSE
	IF PARENT.fu_InUse( "P", "O" ) THEN
		THIS.Checked = TRUE
	ELSE
		i_cavailabilityvalues[12] = ''
	END IF
END IF
end event

type cbx_pe from checkbox within u_tabpage_options_carve_out
integer x = 1335
integer y = 524
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[11] = 'E'
ELSE
	IF PARENT.fu_InUse( "P", "E" ) THEN
		THIS.Checked = TRUE
	ELSE
		i_cavailabilityvalues[11] = ''
	END IF
END IF
end event

type cbx_pp from checkbox within u_tabpage_options_carve_out
integer x = 1015
integer y = 524
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[10] = 'P'
ELSE
	IF PARENT.fu_InUse( "P", "P" ) THEN
		THIS.Checked = TRUE
	ELSE
		i_cavailabilityvalues[10] = ''
	END IF
END IF
end event

type cbx_pm from checkbox within u_tabpage_options_carve_out
integer x = 695
integer y = 524
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[9] = 'C'
ELSE
	IF PARENT.fu_InUse( "P", "C" ) THEN
		THIS.Checked = TRUE
	ELSE	
		i_cavailabilityvalues[9] = ''
	END IF
END IF
end event

type cbx_co from checkbox within u_tabpage_options_carve_out
integer x = 1655
integer y = 448
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[8] = 'O'
ELSE
	IF PARENT.fu_InUse( "C", "O" ) THEN
		THIS.Checked = TRUE
	ELSE	
		i_cavailabilityvalues[8] = ''
	END IF
END IF
end event

type cbx_ce from checkbox within u_tabpage_options_carve_out
integer x = 1335
integer y = 448
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[7] = 'E'
ELSE
	IF PARENT.fu_InUse( "C", "E" ) THEN
		THIS.Checked = TRUE
	ELSE	
		i_cavailabilityvalues[7] = ''
	END IF
END IF
end event

type cbx_cp from checkbox within u_tabpage_options_carve_out
integer x = 1015
integer y = 448
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[6] = 'P'
ELSE
	IF PARENT.fu_InUse( "C", "P" ) THEN
		THIS.Checked = TRUE
	ELSE	
		i_cavailabilityvalues[6] = ''
	END IF
END IF
end event

type cbx_cm from checkbox within u_tabpage_options_carve_out
integer x = 695
integer y = 448
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[5] = 'C'
ELSE
	IF PARENT.fu_InUse( "C", "C" ) THEN
		THIS.Checked = TRUE
	ELSE	
		i_cavailabilityvalues[5] = ''
	END IF
END IF
end event

type cbx_io from checkbox within u_tabpage_options_carve_out
integer x = 1655
integer y = 372
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[4] = 'O'
ELSE
	IF PARENT.fu_InUse( "I", "O" ) THEN
		THIS.Checked = TRUE
	ELSE	
		i_cavailabilityvalues[4] = ''
	END IF
END IF
end event

type cbx_ie from checkbox within u_tabpage_options_carve_out
integer x = 1335
integer y = 372
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[3] = 'E'
ELSE
	IF PARENT.fu_InUse( "I", "E" ) THEN
		THIS.Checked = TRUE
	ELSE	
		i_cavailabilityvalues[3] = ''
	END IF
END IF
end event

type cbx_ip from checkbox within u_tabpage_options_carve_out
integer x = 1015
integer y = 372
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[2] = 'P'
ELSE
	IF PARENT.fu_InUse( "I", "P" ) THEN
		THIS.Checked = TRUE
	ELSE	
		i_cavailabilityvalues[2] = ''
	END IF
END IF
end event

type cbx_im from checkbox within u_tabpage_options_carve_out
integer x = 695
integer y = 372
integer width = 69
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Function:   clicked
   Purpose:    Set the option value associated with this check box
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/09/01 M. Caruso    Created.
	4/17/2001 K. Claver   Added code to check if the case type+source type combo is in use.
*****************************************************************************************/

IF checked THEN
	i_cavailabilityvalues[1] = 'C'
ELSE
	IF PARENT.fu_InUse( "I", "C" ) THEN
		THIS.Checked = TRUE
	ELSE		
		i_cavailabilityvalues[1] = ''
	END IF
END IF
end event

type st_other from statictext within u_tabpage_options_carve_out
integer x = 1550
integer y = 292
integer width = 274
integer height = 56
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "Others"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_group from statictext within u_tabpage_options_carve_out
integer x = 1230
integer y = 228
integer width = 274
integer height = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "Employer Groups"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_provider from statictext within u_tabpage_options_carve_out
integer x = 910
integer y = 228
integer width = 274
integer height = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "Providers of Service"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_member from statictext within u_tabpage_options_carve_out
integer x = 590
integer y = 292
integer width = 274
integer height = 56
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "Members"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_configcase from statictext within u_tabpage_options_carve_out
integer x = 82
integer y = 600
integer width = 421
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_proactive from statictext within u_tabpage_options_carve_out
integer x = 82
integer y = 524
integer width = 421
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proactive:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_issueconcern from statictext within u_tabpage_options_carve_out
integer x = 82
integer y = 448
integer width = 421
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Issue/Concern:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_inquiry from statictext within u_tabpage_options_carve_out
integer x = 82
integer y = 372
integer width = 421
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inquiry:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_availability from groupbox within u_tabpage_options_carve_out
integer x = 46
integer y = 164
integer width = 1801
integer height = 580
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "Availability by Case Type"
borderstyle borderstyle = stylelowered!
end type

