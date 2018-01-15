$PBExportHeader$u_tabpage_options_case.sru
$PBExportComments$System Options preferences tab
forward
global type u_tabpage_options_case from u_container_std
end type
type st_4 from statictext within u_tabpage_options_case
end type
type em_incident from editmask within u_tabpage_options_case
end type
type st_3 from statictext within u_tabpage_options_case
end type
type cbx_copyproperties from checkbox within u_tabpage_options_case
end type
type rb_specified from radiobutton within u_tabpage_options_case
end type
type rb_userdefault from radiobutton within u_tabpage_options_case
end type
type st_2 from statictext within u_tabpage_options_case
end type
type sle_config_case_type from singlelineedit within u_tabpage_options_case
end type
type cbx_return from checkbox within u_tabpage_options_case
end type
type p_caselinking from picture within u_tabpage_options_case
end type
type st_1 from statictext within u_tabpage_options_case
end type
type em_maxlinkcase from editmask within u_tabpage_options_case
end type
type cbx_linkwarn_enable from checkbox within u_tabpage_options_case
end type
type p_sleep_mode from picture within u_tabpage_options_case
end type
type st_sleep_prompt from statictext within u_tabpage_options_case
end type
type em_sleep_timer from editmask within u_tabpage_options_case
end type
type cbx_sleep_enable from checkbox within u_tabpage_options_case
end type
type st_method_id from statictext within u_tabpage_options_case
end type
type st_note_type from statictext within u_tabpage_options_case
end type
type ddlb_method_id from dropdownlistbox within u_tabpage_options_case
end type
type ddlb_note_type from dropdownlistbox within u_tabpage_options_case
end type
type st_returnforclose from statictext within u_tabpage_options_case
end type
type p_case_transfer from picture within u_tabpage_options_case
end type
type st_reopen_limit2 from statictext within u_tabpage_options_case
end type
type st_reopen_limit from statictext within u_tabpage_options_case
end type
type p_reopen from picture within u_tabpage_options_case
end type
type gb_1 from groupbox within u_tabpage_options_case
end type
type gb_case_transfer from groupbox within u_tabpage_options_case
end type
type gb_case_notes from groupbox within u_tabpage_options_case
end type
type em_reopen_limit from editmask within u_tabpage_options_case
end type
type gb_sleep_mode from groupbox within u_tabpage_options_case
end type
type gb_case_link_warning from groupbox within u_tabpage_options_case
end type
type gb_config_case_type from groupbox within u_tabpage_options_case
end type
type gb_2 from groupbox within u_tabpage_options_case
end type
type ddlb_confid_levels from dropdownlistbox within u_tabpage_options_case
end type
type gb_3 from groupbox within u_tabpage_options_case
end type
end forward

global type u_tabpage_options_case from u_container_std
integer width = 1893
integer height = 2060
boolean border = false
string text = "Case"
event ue_initpage ( )
event ue_savepage ( )
st_4 st_4
em_incident em_incident
st_3 st_3
cbx_copyproperties cbx_copyproperties
rb_specified rb_specified
rb_userdefault rb_userdefault
st_2 st_2
sle_config_case_type sle_config_case_type
cbx_return cbx_return
p_caselinking p_caselinking
st_1 st_1
em_maxlinkcase em_maxlinkcase
cbx_linkwarn_enable cbx_linkwarn_enable
p_sleep_mode p_sleep_mode
st_sleep_prompt st_sleep_prompt
em_sleep_timer em_sleep_timer
cbx_sleep_enable cbx_sleep_enable
st_method_id st_method_id
st_note_type st_note_type
ddlb_method_id ddlb_method_id
ddlb_note_type ddlb_note_type
st_returnforclose st_returnforclose
p_case_transfer p_case_transfer
st_reopen_limit2 st_reopen_limit2
st_reopen_limit st_reopen_limit
p_reopen p_reopen
gb_1 gb_1
gb_case_transfer gb_case_transfer
gb_case_notes gb_case_notes
em_reopen_limit em_reopen_limit
gb_sleep_mode gb_sleep_mode
gb_case_link_warning gb_case_link_warning
gb_config_case_type gb_config_case_type
gb_2 gb_2
ddlb_confid_levels ddlb_confid_levels
gb_3 gb_3
end type
global u_tabpage_options_case u_tabpage_options_case

type variables
CONSTANT	STRING	i_cOwner	= 'owner'
CONSTANT STRING	i_cAny	= 'any'

BOOLEAN				i_bFirstOpen
BOOLEAN				i_bRemoveReturnForClose = FALSE

S_DDLBITEMS			i_sNoteTypes[]
S_DDLBITEMS			i_sMethods[]
S_DDLBITEMS       i_sConfidLevels[]

W_SYSTEM_OPTIONS	i_wParentWindow

DATASTORE	      i_dsConfidLevels

end variables

event ue_initpage();//*********************************************************************************************
//
//  Event:   ue_initpage
//  Purpose: Initialize the interface for this page
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  12/08/00 M. Caruso   Created
//  06/07/01 K. Claver   Added case for the case link warning 
//  10/04/02 K. Claver   Added case for blank report
//  01/31/03 C. Jackson  Added case for Case Note Security
//  02/14/03 M. Caruso   Modified case for case note security to pass the current value as an
//								 integer to the query so it will work against Sybase.
//  06/17/03 M. Caruso   Added option LINK_COPY_PROPERTIES.
//*********************************************************************************************

INTEGER		l_nTimer
LONG			l_nRow, l_nMaxRows, l_nIndex, l_nRowCount, l_nConfidLevel, l_nSrchVal
STRING		l_cOption, l_cValue, l_cDSSyntax, l_cDSSQL, l_cErrors, l_cTemp, l_cLinkTemp
STRING      l_cConfidDesc, l_cConfidLevelStrg, l_cData
DATASTORE	l_dsValueList

IF i_bFirstOpen THEN
	
	i_bFirstOpen = FALSE
	
	l_nMaxRows = i_wParentWindow.i_dsOptions.RowCount ()
	FOR l_nRow = 1 TO l_nMaxRows
		
		l_cOption = Upper (i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_name'))
		
		l_cValue = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')

		CHOOSE CASE l_cOption
			CASE 'REOPEN LIMIT'
				// set reopen limit
				IF l_nRow > 0 THEN
					em_reopen_limit.Enabled = TRUE
					em_reopen_limit.Text = l_cValue
				ELSE
					em_reopen_limit.Enabled = FALSE
				END IF
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 6.1.2006 Adding option 
//-----------------------------------------------------------------------------------------------------------------------------------
			CASE 'INCIDENT DATE LIMIT'
				// set reopen limit
				IF l_nRow > 0 THEN
					em_incident.Enabled = TRUE
					em_incident.Text = l_cValue
				ELSE
					em_incident.Enabled = FALSE
				END IF
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite End Added 6.1.2006 Adding option 
//-----------------------------------------------------------------------------------------------------------------------------------
				
			CASE 'RETURN FOR CLOSE'
				// set the Return for Close property
				IF l_nRow > 0 THEN
					CHOOSE CASE l_cValue
						CASE i_cOwner
							cbx_return.checked = TRUE
							
						CASE i_cAny
							cbx_return.checked = FALSE
							
					END CHOOSE
					
				END IF
				
			CASE 'DEFAULT NOTE TYPE'
				l_dsValueList = CREATE DATASTORE
				l_cDSSQL = 'SELECT note_type, note_desc ' + &
							  'FROM cusfocus.case_note_types ' + &
							  'WHERE active = ~'Y~'' + &
							  'ORDER BY note_desc'
				l_cDSSyntax = SQLCA.SyntaxFromSQL (l_cDSSQL, '', l_cErrors)
				IF l_cDSSyntax = '' THEN
					MessageBox (gs_appname, l_cErrors)
				ELSE
					
					l_dsValueList.Create (l_cDSSyntax, l_cErrors)
					IF Len (l_cErrors) = 0 THEN
						
						l_dsValueList.SetTransObject (SQLCA)
						l_nRowCount = l_dsValueList.Retrieve ()
						FOR l_nIndex = 1 TO l_nRowCount
							
							i_sNoteTypes[l_nIndex].item_id = l_dsValueList.GetItemString (l_nIndex, 'note_type')
							i_sNoteTypes[l_nIndex].item_desc = l_dsValueList.GetItemString (l_nIndex, 'note_desc')
							ddlb_note_type.AddItem (i_sNoteTypes[l_nIndex].item_desc)
							IF i_sNoteTypes[l_nIndex].item_id = l_cValue THEN
								ddlb_note_type.Text = i_sNoteTypes[l_nIndex].item_desc
							END IF
							
						NEXT
						
					ELSE
						MessageBox (gs_appname, l_cErrors)
					END IF
					
				END IF
				DESTROY l_dsValueList
				
			CASE 'DEFAULT METHOD ID'
				l_dsValueList = CREATE DATASTORE
				l_cDSSQL = 'SELECT method_id, method_desc FROM cusfocus.methods ORDER BY method_desc'
				l_cDSSyntax = SQLCA.SyntaxFromSQL (l_cDSSQL, '', l_cErrors)
				IF l_cDSSyntax = '' THEN
					MessageBox (gs_appname, l_cErrors)
				ELSE
					
					l_dsValueList.Create (l_cDSSyntax, l_cErrors)
					IF Len (l_cErrors) = 0 THEN
						
						l_dsValueList.SetTransObject (SQLCA)
						l_nRowCount = l_dsValueList.Retrieve ()
						FOR l_nIndex = 1 TO l_nRowCount
							
							i_sMethods[l_nIndex].item_id = l_dsValueList.GetItemString (l_nIndex, 'method_id')
							i_sMethods[l_nIndex].item_desc = l_dsValueList.GetItemString (l_nIndex, 'method_desc')
							ddlb_method_id.AddItem (i_sMethods[l_nIndex].item_desc)
							IF i_sMethods[l_nIndex].item_id = l_cValue THEN
								ddlb_method_id.Text = i_sMethods[l_nIndex].item_desc
							END IF
							
						NEXT
						
					ELSE
						MessageBox (gs_appname, l_cErrors)
					END IF
					
				END IF
				DESTROY l_dsValueList
				
			CASE 'SLEEP ENABLED'
				IF l_cValue = 'Y' THEN
					
					cbx_sleep_enable.checked = TRUE
					em_sleep_timer.Enabled = TRUE
					IF l_cTemp <> '' THEN
						em_sleep_timer.Text = l_cTemp
					END IF
					
				ELSE
					
					cbx_sleep_enable.checked = FALSE
					em_sleep_timer.Enabled = FALSE
					
				END IF
				
			CASE 'SLEEP TIMER'
				l_nTimer = INTEGER (l_cValue) / 60
				
				// validate the database value
				IF l_nTimer < gn_sleepmin THEN
					l_nTimer = gn_sleepmin
				ELSEIF l_nTimer > gn_sleepmax THEN
					l_nTimer = gn_sleepmax
				END IF
				
				// set the value in the interface
				l_cValue = STRING (l_nTimer)
				IF em_sleep_timer.Enabled THEN
					em_sleep_timer.Text = l_cValue
				ELSE
					l_cTemp = l_cValue
				END IF
				
			CASE 'LINK_WARNING_ENABLED'
				IF l_cValue = 'Y' THEN
					
					cbx_linkwarn_enable.checked = TRUE
					em_maxlinkcase.Enabled = TRUE
					IF l_cLinkTemp <> '' THEN
						em_maxlinkcase.Text = l_cLinkTemp
					END IF
					
				ELSE
					
					cbx_linkwarn_enable.checked = FALSE
					em_maxlinkcase.Enabled = FALSE
					
				END IF
				
			CASE 'LINK_WARNING_CASE_COUNT'
				IF em_maxlinkcase.Enabled THEN
					em_maxlinkcase.Text = l_cValue
				ELSE
					l_cLinkTemp = l_cValue
				END IF
				
			CASE "LINK_COPY_PROPERTIES"
				IF l_cValue = 'Y' THEN cbx_copyproperties.checked = TRUE
			
			CASE 'CONFIGURABLE CASE TYPE'
				sle_config_case_type.Text = l_cValue
								
			CASE 'CASE NOTE SECURITY'
				// Get description of currently selected Security level
				
				IF l_cValue <> 'user' THEN
					
					ddlb_confid_levels.Visible = TRUE
					rb_userdefault.Checked = FALSE
					rb_specified.Checked = TRUE
					l_nSrchVal = LONG (l_cValue)

					SELECT confid_desc
					  INTO :l_cData
					  FROM cusfocus.confidentiality_levels
					 WHERE confidentiality_level = :l_nSrchVal
					 USING SQLCA;
					 
					l_dsValueList = CREATE DATASTORE
					l_dsValueList.DataObject = 'dddw_confidentiality_levels'
					l_dsValueList.SetTransObject(SQLCA)
					l_nRowCount = l_dsValueList.Retrieve()
					
					FOR l_nIndex = 1 TO l_nRowCount
						
						l_cConfidDesc = l_dsValueList.GetItemString(l_nIndex,'confid_desc')
						ddlb_confid_levels.InsertItem (l_cConfidDesc,l_nIndex)
	
					NEXT
						
					ddlb_confid_levels.SelectItem(l_cData,0)
					
					DESTROY l_dsValueList
					
				ELSE 
					rb_userdefault.Checked = TRUE
					rb_specified.Checked = FALSE
					ddlb_confid_levels.Visible = FALSE
				END IF
				
		END CHOOSE
				
	NEXT
	
END IF

DESTROY l_dsValueList
end event

event ue_savepage();/*****************************************************************************************
   Function:   ue_savepage
   Purpose:    Save the options on the interface for this page.
   Parameters: NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/08/00 M. Caruso    Created.
	6/7/2001 K. Claver    Added case for the case link warning.
	01/31/02 M. Caruso    Corrected processing of REOPEN_LIMIT to allow 0 days.
	01/31/02 M. Caruso    Only process if the other tabs have saved successfully.
	06/06/03 M. Caruso    Removed Reopen Case upper limit and update error message.
	06/17/03 M. Caruso    Added LINK_COPY_PROPERTIES option.
*****************************************************************************************/

LONG		l_nRow, l_nNumValue, l_nMaxRows, l_nIndex, l_nConfidLevel
STRING	l_cOption, l_cValue, l_cConfidDesc, l_cUserName

IF NOT i_wParentWindow.i_bSaveFailed THEN

	l_nMaxRows = i_wParentWindow.i_dsOptions.RowCount ()
	FOR l_nRow = 1 TO l_nMaxRows
		
		l_cOption = Upper (i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_name'))
		
		CHOOSE CASE l_cOption
			CASE 'REOPEN LIMIT'
				// set reopen limit
				IF em_reopen_limit.Enabled THEN
					
					l_cValue = em_reopen_limit.Text
					l_nNumValue = LONG (l_cValue)
					IF (l_nNumValue < 0) THEN
						
						MessageBox (gs_appname, 'The reopen limit must be 0 or more days. 0 indicates an unlimited reopen period.')
						i_wParentWindow.i_bSaveFailed = TRUE
						i_wParentWindow.i_bCloseWindow = FALSE
						em_reopen_limit.SetFocus ()
						em_reopen_limit.SelectText (1, Len (l_cValue))
						RETURN
						
					ELSE
						
						l_nRow = i_wParentWindow.i_dsOptions.Find ('option_name = "reopen limit"', 1, &
																				 i_wParentWindow.i_dsOptions.RowCount ())
						IF l_nRow > 0 THEN
							i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue)
						ELSE
							
							MessageBox (gs_appname, 'Reopen Limit option not found, so change will not ')
							i_wParentWindow.i_bSaveFailed = TRUE
							i_wParentWindow.i_bCloseWindow = TRUE
							RETURN
							
						END IF
						
					END IF
					
				END IF
				
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 6.1.2006 Adding option 
//-----------------------------------------------------------------------------------------------------------------------------------				
			CASE 'INCIDENT DATE LIMIT'
				// set incident date limit
				IF em_incident.Enabled THEN
					
					l_cValue = em_incident.Text
					l_nNumValue = LONG (l_cValue)
					IF (l_nNumValue < 0) THEN
						
						MessageBox (gs_appname, 'The incident limit must be 0 or more days. 0 indicates an unlimited reopen period.')
						i_wParentWindow.i_bSaveFailed = TRUE
						i_wParentWindow.i_bCloseWindow = FALSE
						em_incident.SetFocus ()
						em_incident.SelectText (1, Len (l_cValue))
						RETURN
						
					ELSE
						
						l_nRow = i_wParentWindow.i_dsOptions.Find ('option_name = "incident date limit"', 1, &
																				 i_wParentWindow.i_dsOptions.RowCount ())
						IF l_nRow > 0 THEN
							i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue)
						ELSE
							
							MessageBox (gs_appname, 'Incident Date Limit option not found, so change will not ')
							i_wParentWindow.i_bSaveFailed = TRUE
							i_wParentWindow.i_bCloseWindow = TRUE
							RETURN
							
						END IF
						
					END IF
					
				END IF				
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 6.1.2006 Adding option 
//-----------------------------------------------------------------------------------------------------------------------------------				
				
			CASE 'RETURN FOR CLOSE'
				// set return for close property
				l_nRow = i_wParentWindow.i_dsOptions.Find ('option_name = "return for close"', 1, &
																				 i_wParentWindow.i_dsOptions.RowCount ())
				IF cbx_return.checked THEN
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', i_cOwner)
				ELSE
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', i_cAny)
					
					IF THIS.i_bRemoveReturnForClose THEN
						UPDATE cusfocus.case_transfer
						SET return_for_close = null
						WHERE return_for_close = 1
						USING SQLCA;
						
						IF SQLCA.SQLCode = -1 THEN
							MessageBox( gs_AppName, "Error deselecting Return for Close on cases marked Return for Close" )
						END IF
					END IF
				END IF
				
			CASE 'DEFAULT NOTE TYPE'
				l_cValue = ddlb_note_type.Text
				FOR l_nIndex = 1 TO UpperBound (i_snotetypes[])
					
					IF l_cValue = i_snotetypes[l_nIndex].item_desc THEN EXIT
					
				NEXT
				i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', i_snotetypes[l_nIndex].item_id)
				
			CASE 'DEFAULT METHOD ID'
				l_cValue = ddlb_method_id.Text
				FOR l_nIndex = 1 TO UpperBound (i_smethods[])
					
					IF l_cValue = i_smethods[l_nIndex].item_desc THEN EXIT
					
				NEXT
				i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', i_smethods[l_nIndex].item_id)
				
			CASE 'SLEEP ENABLED'
				IF cbx_sleep_enable.checked THEN
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', 'Y')
				ELSE
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', 'N')
				END IF
				
			CASE 'SLEEP TIMER'
				IF cbx_sleep_enable.checked THEN
					
					l_cValue = STRING (INTEGER (em_sleep_timer.Text) * 60)
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue)
					
				ELSE
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', '0')
				END IF
				
			CASE 'LINK_WARNING_ENABLED'
				IF cbx_linkwarn_enable.checked THEN
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', 'Y')
				ELSE
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', 'N')
				END IF
				
			CASE 'LINK_WARNING_CASE_COUNT'
				IF cbx_linkwarn_enable.checked THEN
					
					l_cValue = em_maxlinkcase.Text
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue)
					
				ELSE
					i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', '0')
				END IF	
				
			CASE "LINK_COPY_PROPERTIES"
				IF cbx_copyproperties.checked THEN
					l_cValue = 'Y'
				ELSE
					l_cValue = 'N'
				END IF
				i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue)
			
			CASE 'CONFIGURABLE CASE TYPE'
				l_cValue = sle_config_case_type.Text
				i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', trim(l_cValue))
				//update the case_types table
				UPDATE cusfocus.case_types
				   SET case_type_desc = :l_cValue
				 WHERE case_type = 'M'
				 USING SQLCA;
				 
            gs_configcasetype = l_cValue
				 
			CASE 'CASE NOTE SECURITY'
				
				IF rb_userdefault.Checked = TRUE then
					
					l_cValue = 'user'
					
				ELSE
				
					l_cConfidDesc = ddlb_confid_levels.Text
					SELECT convert(varchar(25),confidentiality_level)
					  INTO :l_cValue
					  FROM cusfocus.confidentiality_levels
					 WHERE confid_desc = :l_cConfidDesc
					 USING SQLCA;
					 
				END IF
				 
				i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue)
				
				l_cUserName = OBJCA.WIN.fu_GetLogin(SQLCA)

				
				IF l_cValue = 'user' THEN
					SELECT confidentiality_level INTO :gs_CaseNoteSecurity
					  FROM cusfocus.cusfocus_user
					 WHERE user_id = :l_cUserName
					 USING SQLCA;
					 
				ELSE
					gs_CaseNoteSecurity = l_cValue
				END IF
					 


		END CHOOSE
		
	NEXT
	
	i_wParentWindow.i_bSaveFailed = FALSE
	i_wParentWindow.i_bCloseWindow = TRUE
	
END IF
end event

on u_tabpage_options_case.create
int iCurrent
call super::create
this.st_4=create st_4
this.em_incident=create em_incident
this.st_3=create st_3
this.cbx_copyproperties=create cbx_copyproperties
this.rb_specified=create rb_specified
this.rb_userdefault=create rb_userdefault
this.st_2=create st_2
this.sle_config_case_type=create sle_config_case_type
this.cbx_return=create cbx_return
this.p_caselinking=create p_caselinking
this.st_1=create st_1
this.em_maxlinkcase=create em_maxlinkcase
this.cbx_linkwarn_enable=create cbx_linkwarn_enable
this.p_sleep_mode=create p_sleep_mode
this.st_sleep_prompt=create st_sleep_prompt
this.em_sleep_timer=create em_sleep_timer
this.cbx_sleep_enable=create cbx_sleep_enable
this.st_method_id=create st_method_id
this.st_note_type=create st_note_type
this.ddlb_method_id=create ddlb_method_id
this.ddlb_note_type=create ddlb_note_type
this.st_returnforclose=create st_returnforclose
this.p_case_transfer=create p_case_transfer
this.st_reopen_limit2=create st_reopen_limit2
this.st_reopen_limit=create st_reopen_limit
this.p_reopen=create p_reopen
this.gb_1=create gb_1
this.gb_case_transfer=create gb_case_transfer
this.gb_case_notes=create gb_case_notes
this.em_reopen_limit=create em_reopen_limit
this.gb_sleep_mode=create gb_sleep_mode
this.gb_case_link_warning=create gb_case_link_warning
this.gb_config_case_type=create gb_config_case_type
this.gb_2=create gb_2
this.ddlb_confid_levels=create ddlb_confid_levels
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.em_incident
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.cbx_copyproperties
this.Control[iCurrent+5]=this.rb_specified
this.Control[iCurrent+6]=this.rb_userdefault
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_config_case_type
this.Control[iCurrent+9]=this.cbx_return
this.Control[iCurrent+10]=this.p_caselinking
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.em_maxlinkcase
this.Control[iCurrent+13]=this.cbx_linkwarn_enable
this.Control[iCurrent+14]=this.p_sleep_mode
this.Control[iCurrent+15]=this.st_sleep_prompt
this.Control[iCurrent+16]=this.em_sleep_timer
this.Control[iCurrent+17]=this.cbx_sleep_enable
this.Control[iCurrent+18]=this.st_method_id
this.Control[iCurrent+19]=this.st_note_type
this.Control[iCurrent+20]=this.ddlb_method_id
this.Control[iCurrent+21]=this.ddlb_note_type
this.Control[iCurrent+22]=this.st_returnforclose
this.Control[iCurrent+23]=this.p_case_transfer
this.Control[iCurrent+24]=this.st_reopen_limit2
this.Control[iCurrent+25]=this.st_reopen_limit
this.Control[iCurrent+26]=this.p_reopen
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_case_transfer
this.Control[iCurrent+29]=this.gb_case_notes
this.Control[iCurrent+30]=this.em_reopen_limit
this.Control[iCurrent+31]=this.gb_sleep_mode
this.Control[iCurrent+32]=this.gb_case_link_warning
this.Control[iCurrent+33]=this.gb_config_case_type
this.Control[iCurrent+34]=this.gb_2
this.Control[iCurrent+35]=this.ddlb_confid_levels
this.Control[iCurrent+36]=this.gb_3
end on

on u_tabpage_options_case.destroy
call super::destroy
destroy(this.st_4)
destroy(this.em_incident)
destroy(this.st_3)
destroy(this.cbx_copyproperties)
destroy(this.rb_specified)
destroy(this.rb_userdefault)
destroy(this.st_2)
destroy(this.sle_config_case_type)
destroy(this.cbx_return)
destroy(this.p_caselinking)
destroy(this.st_1)
destroy(this.em_maxlinkcase)
destroy(this.cbx_linkwarn_enable)
destroy(this.p_sleep_mode)
destroy(this.st_sleep_prompt)
destroy(this.em_sleep_timer)
destroy(this.cbx_sleep_enable)
destroy(this.st_method_id)
destroy(this.st_note_type)
destroy(this.ddlb_method_id)
destroy(this.ddlb_note_type)
destroy(this.st_returnforclose)
destroy(this.p_case_transfer)
destroy(this.st_reopen_limit2)
destroy(this.st_reopen_limit)
destroy(this.p_reopen)
destroy(this.gb_1)
destroy(this.gb_case_transfer)
destroy(this.gb_case_notes)
destroy(this.em_reopen_limit)
destroy(this.gb_sleep_mode)
destroy(this.gb_case_link_warning)
destroy(this.gb_config_case_type)
destroy(this.gb_2)
destroy(this.ddlb_confid_levels)
destroy(this.gb_3)
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

type st_4 from statictext within u_tabpage_options_case
integer x = 1211
integer y = 1896
integer width = 617
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "days from current date."
boolean focusrectangle = false
end type

type em_incident from editmask within u_tabpage_options_case
integer x = 978
integer y = 1880
integer width = 219
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####0"
string minmax = "0~~"
end type

type st_3 from statictext within u_tabpage_options_case
integer x = 55
integer y = 1892
integer width = 914
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incident date cannot be more than"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_copyproperties from checkbox within u_tabpage_options_case
integer x = 453
integer y = 1404
integer width = 1335
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Copy Case Properties when linking New cases."
end type

type rb_specified from radiobutton within u_tabpage_options_case
integer x = 114
integer y = 1116
integer width = 1079
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Specify Case and Note Security Level"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Rebuild the confidentiality level datastore
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  01/31/03 C. Jackson  Original Version
//***********************************************************************************************

STRING l_cValue, l_cConfidDesc, l_cData
DATASTORE l_dsValueList
LONG l_nRowCount, l_n_index, l_nIndex

ddlb_confid_levels.Visible = TRUE

SELECT option_value
  INTO :l_cData
  FROM cusfocus.system_options
 WHERE option_name = 'case note security'
 USING SQLCA;

l_dsValueList = CREATE DATASTORE
l_dsValueList.DataObject = 'dddw_confidentiality_levels'
l_dsValueList.SetTransObject(SQLCA)
l_nRowCount = l_dsValueList.Retrieve()

FOR l_nIndex = 1 TO l_nRowCount
	
	l_cConfidDesc = l_dsValueList.GetItemString(l_nIndex,'confid_desc')
	ddlb_confid_levels.InsertItem (l_cConfidDesc,l_nIndex)

NEXT
	
	IF l_cData <> 'user' THEN
		ddlb_confid_levels.SelectItem(l_cData,0)
	ELSE
		ddlb_confid_levels.SelectItem(1)
	END IF

DESTROY l_dsValueList

end event

type rb_userdefault from radiobutton within u_tabpage_options_case
integer x = 114
integer y = 1036
integer width = 1312
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Set Case and Note Security to User~'s Security"
boolean checked = true
end type

event clicked;ddlb_confid_levels.Visible = FALSE
end event

type st_2 from statictext within u_tabpage_options_case
integer x = 142
integer y = 1632
integer width = 489
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Type Name:"
boolean focusrectangle = false
end type

type sle_config_case_type from singlelineedit within u_tabpage_options_case
integer x = 631
integer y = 1620
integer width = 1175
integer height = 88
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

event losefocus;//*********************************************************************************************
//
//  Event:   losefocus
//  Purpose: Validate the data in this control before allowing focus to change
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  01/27/02 C. Jackson  Original Verison
//
//*********************************************************************************************

IF IsNull(this.text) or TRIM (THIS.text) = '' THEN
	
	MessageBox (gs_appname, 'Configurable Case Type is required.')
	SetFocus ()
	RETURN 1
	
ELSE
	IF len(this.text) > 10 THEN
		MessageBox ( gs_appname, 'Configurable Case Type can only be 10 characters in length.')
		SetFocus()
		RETURN 1
	END IF
	
END IF


end event

type cbx_return from checkbox within u_tabpage_options_case
integer x = 402
integer y = 512
integer width = 773
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enable Return for Close"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
   2/26/2002 K. Claver   To check if there are cases marked return for close before allowing
								 this option to be deselected.
*****************************************************************************************/
Integer l_nCount, l_nRV

IF THIS.Checked = FALSE THEN
	SELECT Count( * )
	INTO :l_nCount
	FROM cusfocus.case_transfer
	WHERE return_for_close = 1 
	USING SQLCA;
	
	IF SQLCA.SQLCode = -1 THEN
		MessageBox( gs_AppName, "Error determining if cases are marked Return for Close" )
	ELSE
		IF l_nCount > 0 THEN
			l_nRV = MessageBox( gs_AppName, "There are cases that are marked Return for Close.  Deselecting~r~n"+ &
									  "this option will deselect Return for Close on these cases.~r~n"+ &
									  "Continue?", Question!, YesNo! )
									  
			IF l_nRV = 1 THEN
				PARENT.i_bRemoveReturnForClose = TRUE
			ELSE
				THIS.Checked = TRUE
				PARENT.i_bRemoveReturnForClose = FALSE
			END IF
		END IF
	END IF
END IF
end event

type p_caselinking from picture within u_tabpage_options_case
integer x = 96
integer y = 1308
integer width = 165
integer height = 144
string picturename = "CaseLink.bmp"
boolean focusrectangle = false
end type

type st_1 from statictext within u_tabpage_options_case
integer x = 1408
integer y = 1316
integer width = 366
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "linked cases."
boolean focusrectangle = false
end type

type em_maxlinkcase from editmask within u_tabpage_options_case
integer x = 1120
integer y = 1304
integer width = 265
integer height = 88
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
double increment = 1
string minmax = "1~~100"
end type

event losefocus;/*****************************************************************************************
   Event:      LoseFocus
   Purpose:    Validate the data in this control before allowing focus to change.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	05/25/01 M. Caruso    Created.
	6/8/2001 K. Claver    Modified for use with the Case Link warning.
*****************************************************************************************/

INTEGER	l_nValue, l_nMin, l_nMax, l_nEnd1, l_nStart2

l_nValue = INTEGER (this.text)
l_nEnd1 = Pos (MinMax, '~~', 1) - 1
l_nStart2 = l_nEnd1 + 2
l_nMin = INTEGER (Left (MinMax, l_nEnd1))
l_nMax = INTEGER (Mid (MinMax, l_nStart2, 3))

IF l_nValue >= l_nMin AND l_nValue <= l_nMax THEN
	
	RETURN 0
	
ELSE
	
	MessageBox (gs_appname, 'The case link count must be between ' + &
									STRING (l_nMin) + ' and ' + &
									STRING (l_nMax) + ' cases.')
	SetFocus ()
	RETURN 1
	
END IF

end event

type cbx_linkwarn_enable from checkbox within u_tabpage_options_case
integer x = 453
integer y = 1312
integer width = 631
integer height = 80
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Display warning after"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
   6/7/2001  K. Claver   Added code to default the number of cases linked value.
*****************************************************************************************/

IF THIS.Checked THEN	
	em_maxlinkcase.Enabled = TRUE
	em_maxlinkcase.Text = '5'	
ELSE	
	em_maxlinkcase.Enabled = FALSE
	em_maxlinkcase.Text = ''	
END IF
end event

type p_sleep_mode from picture within u_tabpage_options_case
boolean visible = false
integer x = 78
integer y = 1336
integer width = 183
integer height = 160
boolean originalsize = true
string picturename = "sleepoptions.bmp"
boolean focusrectangle = false
end type

type st_sleep_prompt from statictext within u_tabpage_options_case
boolean visible = false
integer x = 1522
integer y = 1380
integer width = 242
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "minutes."
boolean focusrectangle = false
end type

type em_sleep_timer from editmask within u_tabpage_options_case
boolean visible = false
integer x = 1230
integer y = 1368
integer width = 265
integer height = 88
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
double increment = 1
string minmax = "1~~180"
end type

event losefocus;/*****************************************************************************************
   Event:      LoseFocus
   Purpose:    Validate the data in this control before allowing focus to change.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	05/25/01 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nValue

l_nValue = INTEGER (this.text)

IF l_nValue >= gn_sleepmin AND l_nValue <= gn_sleepmax THEN
	
	RETURN 0
	
ELSE
	
	MessageBox (gs_appname, 'The sleep timer must be between ' + &
									STRING (gn_sleepmin) + ' and ' + &
									STRING (gn_sleepmax) + ' minutes.')
	SetFocus ()
	RETURN 1
	
END IF

end event

event constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    initialize the object

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/27/01 M. Caruso    Created.
*****************************************************************************************/

This.MinMax = (STRING (gn_sleepmin) + " ~~ " + STRING (gn_sleepmax))
end event

type cbx_sleep_enable from checkbox within u_tabpage_options_case
boolean visible = false
integer x = 503
integer y = 1372
integer width = 736
integer height = 80
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Enter Sleep mode after"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Perform this functionality when the object is clicked.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
   5/24/01  M. Caruso    Created.
*****************************************************************************************/

IF checked THEN
	
	em_sleep_timer.Enabled = TRUE
	em_sleep_timer.text = '30'
	
ELSE
	
	em_sleep_timer.Enabled = FALSE
	em_sleep_timer.text = ''
	
END IF
end event

type st_method_id from statictext within u_tabpage_options_case
integer x = 187
integer y = 812
integer width = 654
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Default Contact Method:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_note_type from statictext within u_tabpage_options_case
integer x = 338
integer y = 700
integer width = 503
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Default Note Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_method_id from dropdownlistbox within u_tabpage_options_case
integer x = 873
integer y = 796
integer width = 933
integer height = 400
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_note_type from dropdownlistbox within u_tabpage_options_case
integer x = 873
integer y = 684
integer width = 933
integer height = 400
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_returnforclose from statictext within u_tabpage_options_case
integer x = 347
integer y = 360
integer width = 1481
integer height = 140
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "**Cases marked Return for Close may ONLY be closed     by the original case owner:"
boolean focusrectangle = false
end type

type p_case_transfer from picture within u_tabpage_options_case
integer x = 78
integer y = 392
integer width = 183
integer height = 160
boolean originalsize = true
string picturename = "transferoptions.bmp"
boolean focusrectangle = false
end type

type st_reopen_limit2 from statictext within u_tabpage_options_case
integer x = 1650
integer y = 136
integer width = 165
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "days."
boolean focusrectangle = false
end type

type st_reopen_limit from statictext within u_tabpage_options_case
integer x = 475
integer y = 136
integer width = 882
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cases cannot be reopened after"
alignment alignment = right!
boolean focusrectangle = false
end type

type p_reopen from picture within u_tabpage_options_case
integer x = 78
integer y = 108
integer width = 174
integer height = 136
string picturename = "Reopen.bmp"
boolean focusrectangle = false
end type

type gb_1 from groupbox within u_tabpage_options_case
integer x = 41
integer y = 1788
integer width = 1801
integer height = 236
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incident Date"
end type

type gb_case_transfer from groupbox within u_tabpage_options_case
integer x = 46
integer y = 288
integer width = 1801
integer height = 316
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Transfer"
end type

type gb_case_notes from groupbox within u_tabpage_options_case
integer x = 46
integer y = 620
integer width = 1801
integer height = 308
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Notes"
end type

type em_reopen_limit from editmask within u_tabpage_options_case
integer x = 1376
integer y = 120
integer width = 247
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####0"
string minmax = "0~~"
end type

type gb_sleep_mode from groupbox within u_tabpage_options_case
boolean visible = false
integer x = 46
integer y = 1276
integer width = 1801
integer height = 236
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sleep Mode"
end type

type gb_case_link_warning from groupbox within u_tabpage_options_case
integer x = 46
integer y = 1236
integer width = 1801
integer height = 268
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Linking"
end type

type gb_config_case_type from groupbox within u_tabpage_options_case
integer x = 46
integer y = 1528
integer width = 1801
integer height = 236
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Configurable Case Type"
end type

type gb_2 from groupbox within u_tabpage_options_case
integer x = 46
integer y = 952
integer width = 1801
integer height = 260
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Default Case and Case Note Security"
end type

type ddlb_confid_levels from dropdownlistbox within u_tabpage_options_case
boolean visible = false
integer x = 1221
integer y = 1108
integer width = 585
integer height = 400
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within u_tabpage_options_case
integer x = 46
integer y = 32
integer width = 1801
integer height = 236
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reopen Cases"
end type

