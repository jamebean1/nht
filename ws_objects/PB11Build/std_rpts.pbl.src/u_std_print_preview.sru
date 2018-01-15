$PBExportHeader$u_std_print_preview.sru
$PBExportComments$Print preview object
forward
global type u_std_print_preview from u_container_std
end type
type dw_print_preview from datawindow within u_std_print_preview
end type
end forward

global type u_std_print_preview from u_container_std
integer width = 3579
integer height = 1592
boolean border = false
long backcolor = 79748288
event ue_refresh pbm_custom01
event ue_print pbm_custom02
dw_print_preview dw_print_preview
end type
global u_std_print_preview u_std_print_preview

type variables
W_STD_REPORTS		iw_parent

end variables

event ue_refresh;//************************************************************************************************
//
//  Object:  u_std_print_preview
//  Event:   ue_refresh
//  Purpose: Set up the selected report and retrieve based upon which report was selected.  
//           As new reports are created or deleted, adjust the CHOOSE CASE and Retrieve() 
//			    statements accordingly.
//							
//  Date     Developer     Description
//  -------- ------------- -----------------------------------------------------------------
//  01/01/00 M. Caruso     Added a CASE for d_csr_activity_report.  Includes code for
//                         handling date ranges.
//  01/11/00 M. Caruso     Modified the first CASE to send "1/1/yyyy" as the date
//                         parameter instead of the current date.  Also modified second
//                         CASE to handle the new version of "d_tot_contact_act"
//  01/27/00 C. Jackson    Added Group Membership Report Card (d_grp_mem_rpt_card_nested)
//                         and Consumer Profile Report (d_consumer_rpt_nested)
//  02/05/00 C. Jackson    Added Top 'N' Reports, and Call Center Contact Report
//  02/09/00 C. Jackson    Add the Weighted Group Activity Report
//  06/13/00 C. Jackson    Correct logic for Top 'N' Reports.
//  07/11/00 C. Jackson    Removed end_date from the Group Membership Report Card, the Consumer
//                         Profile Report and the Top 'N' Reports (SCR 711)
//  08/10/00 C. Jackson    Re-did all of the logic for the Top N Reports.  They weren't working 
//                         correctly
//  08/17/00 C. Jackson    Add end date for Group Membership Report Card
//  07/06/01 C. Jackson    Comment out unused reports
//  11/06/01 C. Jackson    Correct retrieval of Total Contact Report 
//  
//************************************************************************************************

DATAWINDOWCHILD	ldwc_child
DATE					ld_date, ld_end_date, ld_start_date
LONG					ll_year, ll_usr_key, ll_row_count, ll_id, ll_start_row, ll_counter, ln_Index
LONG					ll_case_count[]
INTEGER				l_nPos, l_nPos1, l_nPos2, l_nPosDiff, l_nConsumerCount
INTEGER 				l_nInquiry, l_nIssue, l_nCompliment, l_nProactive
STRING				ls_return_parm, ls_usr_login, ls_usr_name, ls_GroupId
STRING            ls_start_date, ls_end_date, ls_id, ls_SubjectID[ ], ls_first, ls_second,ls_ConsumerId
STRING				ls_GroupName, lc_casetypes[], lc_sourcetypes[], lc_source_type, ls_NewSubjectID[]
DATASTORE			lds_TopN, lds_Weighted, lds_DataList, lds_TopNCount, lds_TopNSort, lds_TopNRetrieve
S_REPORT_PARMS		ls_ReportParms

dw_print_preview.DataObject = iw_parent.is_current_dataobject
dw_print_preview.Modify("DataWindow.Print.Preview=Yes")
SECCA.MGR.fu_GetUsrInfo(ll_usr_key,ls_usr_login,ls_usr_name)

CHOOSE CASE iw_parent.is_current_dataobject

	CASE "d_inq_act_by_category","d_iss_act_by_category","d_group_contact_nested", &
			"d_group_report_card_nested"
		dw_print_preview.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_preview.SetTransObject(SQLCA)
		dw_print_preview.Retrieve(Date ("1/1/" + String (Year (Today ()), "yyyy")),ls_usr_name)

	CASE "d_tot_contact_act"
		THIS.SetRedraw(FALSE)
		dw_print_preview.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_preview.SetTransObject(SQLCA)
		ls_start_date = '1/1/' + String (Year (Today ()))
		ls_end_date = '12/31/' + String (Year (Today ()))
		ld_date = Date (ls_start_date)
		ld_end_date = Date (ls_end_date)
		dw_print_preview.Retrieve(ld_date, ld_end_date)
		THIS.SetRedraw(TRUE)
		
	CASE "d_case_history_detail_stdrpt"		// Case Detail History Report
		Open (w_case_detail_parms)
		ls_ReportParms = message.PowerObjectParm

		IF IsNull (ls_ReportParms.string_parm1) THEN
			iw_parent.uo_folder.fu_SelectTab(1)
			RETURN
		ELSE
			CHOOSE CASE ls_ReportParms.string_parm1
				CASE '0'
					lds_DataList = CREATE DataStore
					lds_DataList.dataobject = 'dddw_case_status_list'
					lds_DataList.SetTransObject (SQLCA)
					lds_DataList.Retrieve ()
					FOR ln_Index = 1 TO lds_DataList.RowCount()
						lc_casetypes[ln_Index] = lds_DataList.GetItemString (ln_Index, 'case_status_id')
					NEXT
					DESTROY lds_DataList
					
				CASE ELSE
					lc_casetypes[1] = ls_ReportParms.string_parm1
			END CHOOSE
			
			CHOOSE CASE ls_ReportParms.string_parm2
				CASE '0'
					lds_DataList = CREATE DataStore
					lds_DataList.dataobject = 'dddw_source_type_list'
					lds_DataList.SetTransObject (SQLCA)
					lds_DataList.Retrieve ()
					FOR ln_Index = 1 TO lds_DataList.RowCount()
						lc_sourcetypes[ln_Index] = lds_DataList.GetItemString (ln_Index, 'source_type')
					NEXT
					DESTROY lds_DataList
					
				CASE ELSE
					lc_sourcetypes[1] = ls_ReportParms.string_parm2
			END CHOOSE
			
			dw_print_preview.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_print_preview.SetTransObject(SQLCA)
			dw_print_preview.Retrieve(lc_casetypes, lc_sourcetypes, ls_ReportParms.date_parm1, &
												ls_ReportParms.date_parm2)
		END IF

	CASE "d_pro_involved_act"
		dw_print_preview.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_preview.SetTransObject(SQLCA)
		dw_print_preview.Retrieve(ls_usr_name)		

	CASE "d_tot_contact"
//		dw_print_preview.GetChild("d_open_cases",ldwc_child)
//		ldwc_child.SetTransObject(SQLCA)
//		ldwc_child.Retrieve(Today())
//		dw_print_preview.GetChild("d_closed_cases",ldwc_child)
//		ldwc_child.SetTransObject(SQLCA)
//		ldwc_child.Retrieve(Today())
//		dw_print_preview.GetChild("d_total_cases",ldwc_child)
//		ldwc_child.SetTransObject(SQLCA)
//		ldwc_child.Retrieve(Today())
		dw_print_preview.SetTransObject(SQLCA)
		dw_print_preview.Retrieve(Today())

	CASE "d_svc_center_act_nested","d_prov_contact_act_nested"
		//------------------------------------------------------
		// This report requires a date argument from the user.
		// Open a response window to get it.
		//------------------------------------------------------
		Open(w_std_rpt_parms)
		ls_return_parm = message.StringParm

		IF ls_return_parm = "" THEN
			iw_parent.uo_folder.fu_SelectTab(1)
			RETURN
		ELSE
			l_nPos = Pos (ls_return_parm, ",")
			ls_start_date = Left (ls_return_parm, l_nPos - 1)
			ls_ID = Mid (ls_return_parm, l_nPos + 1)
		END IF

		ld_date = Date(ls_start_date)

		ll_year = Year(ld_date)
		ll_year = ll_year + 1
		ld_end_date = Date(String(Month(ld_date)) + "/" + String(Day(ld_date)) + "/" + String(ll_year))

		dw_print_preview.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_preview.SetTransObject(SQLCA)
		dw_print_preview.Retrieve(ld_date,ld_end_date,ls_usr_name,ls_id)
		
	CASE "d_csr_activity_report","d_call_cntr_contact_rpt"
		//------------------------------------------------------
		// This report requires a date range from the user.
		// Open a response window to get it.
		//------------------------------------------------------
		Open(w_std_rpt_date_range)
		ls_ReportParms = message.PowerObjectParm

		IF IsNull (ls_ReportParms.date_parm1) THEN
			iw_parent.uo_folder.fu_SelectTab(1)
			RETURN
		END IF

		dw_print_preview.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_preview.SetTransObject(SQLCA)
		dw_print_preview.Retrieve(ls_ReportParms.date_parm1,ls_ReportParms.date_parm2,ls_usr_name)
		
	CASE "d_consumer_rpt_nested"
		Open(w_std_rpt_consumer_parms)
		ls_return_parm = message.StringParm
		
		IF ls_return_parm = "" THEN
			iw_parent.uo_folder.fu_SelectTab(1)
			RETURN
		ELSE
			l_nPos1 = Pos (ls_return_parm, ",")
			ls_start_date = Left (ls_return_parm, l_nPos1 - 1)
			ls_id = Mid (ls_return_parm, l_nPos1 + 1)
			
		END IF

		ld_start_date = Date(ls_start_date)
		
		dw_print_preview.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_preview.SetTransObject(SQLCA)
		dw_print_preview.Retrieve(ld_start_date,ls_usr_name,ls_id)
		
	CASE "d_grp_mem_rpt_card_nested"
		Open(w_std_rpt_group_parms)
		ls_return_parm = message.StringParm
		
		IF ls_return_parm = "" THEN
			iw_parent.uo_folder.fu_SelectTab(1)
			RETURN
		ELSE
			l_nPos1 = Pos (ls_return_parm, ",")
			ls_start_date = Left (ls_return_parm, l_nPos1 - 1)
			ls_id = Mid (ls_return_parm, l_nPos1 + 1)
			
		END IF

		ld_date = Date(ls_start_date)

		ll_year = Year(ld_date)
		ll_year = ll_year + 1
		ld_end_date = Date(String(Month(ld_date)) + "/" + String(Day(ld_date)) + "/" + String(ll_year))
		dw_print_preview.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_preview.SetTransObject(SQLCA)
		dw_print_preview.Retrieve(ld_date,ld_end_date,ls_usr_name,ls_id)

//	CASE "d_top_n_consumers","d_top_n_groups","d_top_n_providers"
//		// Get parameters from the user
//		Open(w_std_rpt_n_parms)
//		ls_return_parm = message.StringParm
//		
//		IF ls_return_parm = "" THEN
//			iw_parent.uo_folder.fu_SelectTab(1)
//			RETURN
//		ELSE
//			l_nPos1 = Pos (ls_return_parm, ",")
//			ls_start_date = Left (ls_return_parm, l_nPos1 - 1)
//			ls_id = Mid (ls_return_parm, l_nPos1 + 1)
//			ll_id = LONG(ls_id)
//			
//		END IF
//
//		ld_start_date = Date(ls_start_date)
//		
//		CHOOSE CASE iw_parent.is_current_dataobject
//			CASE 'd_top_n_consumers'
//				lc_source_type = 'C'
//			CASE 'd_top_n_groups'
//				lc_source_type = 'E'
//			CASE 'd_top_n_providers'
//				lc_source_type = 'P'
//		END CHOOSE
//
//		// Pre.  Clean out the case counts table for this user and this report
//		DELETE FROM cusfocus.case_counts
//		 WHERE source_type = :lc_source_type
//		   AND login = :ls_usr_login
//		 USING SQLCA;
//
//		// Create datastore for getting the case subject list
//		lds_TopNCount = CREATE DataStore
//		lds_TopNCount.DataObject = 'd_ds_case_count'
//		lds_TopNCount.SetTransObject (SQLCA)
//		ll_row_count = lds_TopNCount.Retrieve (ld_start_date, lc_source_type)
//		
//		FOR ln_Index = 1 TO ll_row_count
//			ls_SubjectID[ln_Index] = lds_TopNCount.GetItemString ( ln_Index, 'case_subject_id')
//			SELECT Count (*) INTO :ll_case_count[ln_index]
//			  FROM cusfocus.case_log
//			 WHERE case_subject_id = :ls_SubjectID[ln_Index]
//			   AND source_type = :lc_source_type
//			 USING SQLCA;
//			 
//			 INSERT INTO cusfocus.case_counts (source_type, case_subject_id, case_count, login)
//			 VALUES (:lc_source_type, :ls_SubjectID[ln_Index], :ll_case_count[ln_Index], :ls_usr_login)
//			  USING SQLCA;
//			 
//		NEXT
//		
//		DESTROY lds_TopNCount
//		
//		// Create datastore for sorting the case count records
//		lds_TopNSort = CREATE DataStore
//		lds_TopNSort.DataObject = 'd_ds_case_sort'
//		lds_TopNSort.SetTransObject (SQLCA)
//		ll_row_count = lds_TopNSort.Retrieve(lc_source_type,ls_usr_login)
//		
//		FOR ln_Index = 1 to ll_row_count
//			ls_SubjectID[ln_Index] = lds_TopNSort.GetItemString(ln_Index,"case_subject_id")
//			ll_case_count[ln_Index] = lds_TopNSort.GetItemNumber(ln_Index,"case_count")
//			UPDATE cusfocus.case_counts 
//			   SET sort_order = :ln_Index
//			 WHERE case_subject_id = :ls_SubjectID[ln_Index]
//			   AND source_type = :lc_source_type
//				AND login = :ls_usr_login
//			 USING SQLCA;
//
//		NEXT
//		
//		DESTROY lds_TopNSort
//		
//		// Now pull out the required number of records
//		lds_TopNRetrieve = CREATE DataStore
//		lds_TopNRetrieve.DataObject = 'd_ds_case_retrieve'
//		lds_TopNRetrieve.SetTransObject (SQLCA)
//		ll_row_count = lds_TopNRetrieve.Retrieve(lc_source_type, ls_usr_login)
//		
//		IF ll_row_count > 0 THEN
//		
//			FOR ln_Index = 1 TO ll_row_count
//				ls_NewSubjectID[ln_Index] = lds_TopNRetrieve.GetItemString(ln_Index,"case_subject_id")
//				IF ln_Index = ll_id THEN 
//					EXIT
//				END IF
//			NEXT
//			
//			// View the report
//			dw_print_preview.SetTransObject(SQLCA)
//			dw_print_preview.Retrieve(ld_start_date, ls_usr_name, ls_id, ls_NewSubjectID[])
//	
//		END IF
//		
//		DESTROY lds_TopNRetrieve
//
//	
//		// Finish up.  Clean out the case counts table for this user and this report
//		DELETE FROM cusfocus.case_counts
//		 WHERE source_type = :lc_source_type
//		   AND login = :ls_usr_login
//		 USING SQLCA;
//
//	CASE "d_weighted_group_rpt"
//		Open(w_std_rpt_date_range)
//		ls_ReportParms = message.PowerObjectParm
//
//		IF IsNull (ls_ReportParms.date_parm1) THEN
//			iw_parent.uo_folder.fu_SelectTab(1)
//			RETURN
//		END IF
//
//		DELETE cusfocus.weighted_rpt
//  		 WHERE user_id = :ls_usr_login;
//		
//		// Create Datastore for counting the number of consumers for each group
//		SetPointer(Hourglass!)
//		lds_Weighted = CREATE DataStore
//		lds_Weighted.DataObject = 'd_ds_weighted_group_rpt'
//		lds_Weighted.SetTransObject(SQLCA)
//		lds_Weighted.Retrieve(ls_ReportParms.date_parm1, ls_ReportParms.date_parm2)
//
//		ll_row_count = lds_Weighted.RowCount()
//		
//		FOR ll_start_row = 1 TO ll_row_count
//			ls_GroupId = lds_Weighted.GetItemString (ll_start_row,"group_id")
//			ls_GroupName = lds_Weighted.GetItemString (ll_start_row,"employ_group_name")
//
//			SELECT count(*) INTO :l_nConsumerCount FROM cusfocus.consumer 
//			 WHERE group_id = :ls_GroupId
//			   AND consum_enroll_date >= :ls_ReportParms.date_parm1
//				AND consum_enroll_date <= :ls_ReportParms.date_parm1;
//			SELECT count(*) INTO :l_nInquiry FROM cusfocus.case_log 
//			 WHERE case_subject_id = :ls_GroupId
//			  AND case_type = 'I'
//			  AND source_type = 'E'
//			  AND case_log_opnd_date >= :ls_ReportParms.date_parm1
//			  AND case_log_opnd_date <= :ls_ReportParms.date_parm1;
//			SELECT count(*) INTO :l_nIssue FROM cusfocus.case_log
//			 WHERE case_subject_id = :ls_GroupId
//			   AND case_type = 'C'
//				AND source_type = 'E'
//				AND case_log_opnd_date >= :ls_ReportParms.date_parm1
//			  AND case_log_opnd_date <= :ls_ReportParms.date_parm1;
//			SELECT count(*) INTO :l_nCompliment FROM cusfocus.case_log
//			 WHERE case_subject_id = :ls_GroupId
//			   AND case_type = 'M'
//				AND source_type = 'E'
//				AND case_log_opnd_date >= :ls_ReportParms.date_parm1
//			  AND case_log_opnd_date <= :ls_ReportParms.date_parm1;
//			SELECT count(*) INTO :l_nProactive FROM cusfocus.case_log
//			 WHERE case_subject_id = :ls_GroupId
//			   AND case_type IN ('P','O')
//				AND source_type = 'E'
//				AND case_log_opnd_date >= :ls_ReportParms.date_parm1
//			  AND case_log_opnd_date <= :ls_ReportParms.date_parm1;
//
//			INSERT INTO cusfocus.weighted_rpt (group_id, group_name, consumer_count, inquiry_count, 
//							issue_count, compliment_count, proactive_count, user_id)
//			VALUES (:ls_GroupId, :ls_GroupName, :l_nConsumerCount, :l_nInquiry, :l_nIssue, 
//							:l_nCompliment, :l_nProactive, :ls_usr_login);
//			
//		NEXT
//		
//		dw_print_preview.SetTransObject (SQLCA)
//		dw_print_preview.Retrieve (ls_ReportParms.date_parm1, ls_ReportParms.date_parm2, ls_usr_name)
//		
//		DESTROY lds_Weighted
//		
////		DELETE cusfocus.weighted_rpt
////		 WHERE user_id = :ls_usr_login;
		
END CHOOSE

IF dw_print_preview.RowCount() = 0 THEN
	MessageBox (gs_AppName,"No data found for this report.")
	iw_parent.uo_folder.fu_SelectTab(1)
	RETURN
ELSE
	dw_print_preview.SetFocus()
END IF


end event

event ue_print;call super::ue_print;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			u_std_print_preview
		Event:			ue_print
		Abstract:		Print the datawindow
----------------------------------------------------------------------------------------*/

dw_print_preview.Print()
end event

event pc_setoptions;call super::pc_setoptions;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0
		Developer:		Bill Jeanes

		Object:			u_std_print_preview
		Event:			pc_setwindow
		Abstract:		Trigger the ue_refresh event
----------------------------------------------------------------------------------------*/

THIS.TriggerEvent("ue_refresh")
end event

event pc_setvariables;call super::pc_setvariables;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			u_std_print_preview
		Event:			pc_setvariables
		Abstract:		Set up the parent window variable
----------------------------------------------------------------------------------------*/

iw_parent = PARENT

end event

on u_std_print_preview.create
int iCurrent
call super::create
this.dw_print_preview=create dw_print_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_print_preview
end on

on u_std_print_preview.destroy
call super::destroy
destroy(this.dw_print_preview)
end on

type dw_print_preview from datawindow within u_std_print_preview
integer x = 32
integer y = 36
integer width = 3520
integer height = 1528
integer taborder = 1
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			dw_print_preview
		Event:			dberror
		Abstract:		Handle any errors that occur
----------------------------------------------------------------------------------------*/
LONG	ll_error_nbr

ll_error_nbr = sqldbcode

IF ll_error_nbr <> 0 THEN 
	MessageBox(FWCA.MGR.i_ApplicationName,"An error has occurred processing this report.~r~n~r~n" + &
					"Error Number:~t" + String(ll_error_nbr) + "~r~n" + &
					"Error Message:~t" + sqlerrtext + "~r~n~r~n" + &
					"Please contact your System Administrator.",StopSign!)
	RETURN 1
END IF
end event

