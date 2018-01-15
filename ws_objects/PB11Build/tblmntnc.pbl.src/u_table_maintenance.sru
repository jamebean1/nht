$PBExportHeader$u_table_maintenance.sru
$PBExportComments$Table Maintenance User Object that allows the user to modify, insert or delete rows in a table.
forward
global type u_table_maintenance from u_container_main
end type
type dw_table_maintenance from u_dw_std within u_table_maintenance
end type
end forward

global type u_table_maintenance from u_container_main
integer width = 3579
integer height = 1592
boolean border = false
long backcolor = 79748288
dw_table_maintenance dw_table_maintenance
end type
global u_table_maintenance u_table_maintenance

type variables
W_TABLE_MAINTENANCE  i_wParentWindow

LONG		i_nMaxValue
LONG		i_nRowFailed
LONG     i_nHoldLength
LONG     i_nHoldOrder

STRING	i_cColumnFailed
STRING	i_cCodeTable


//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 6.14.2005
//-----------------------------------------------------------------------------------------------------------------------------------
boolean	ib_dropdowns_changed

end variables

forward prototypes
public subroutine fu_definecodetable (string a_csourcetype)
public subroutine fu_checkreports (string user_id)
public function integer fu_refinteg ()
public function integer fu_checkdocfields (ref string doc_field_id)
end prototypes

public subroutine fu_definecodetable (string a_csourcetype);/*****************************************************************************************
   Function:   fu_DefineCodeTable
   Purpose:    define the code table for the column_name field of d_tm_field_defs
   Parameters: STRING	a_cSourceType - The source type of the current record
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/27/00  M. Caruso    Created.
*****************************************************************************************/

CHOOSE CASE a_cSourceType
	CASE 'C'
		i_cCodeTable = "consum_generic_1~tconsum_generic_1/consum_generic_2~tconsum_generic_2/" + &
							"consum_generic_3~tconsum_generic_3/consum_generic_4~tconsum_generic_4/" + &
							"consum_generic_5~tconsum_generic_5/consum_generic_6~tconsum_generic_6/" + &
							"consum_generic_7~tconsum_generic_7/consum_generic_8~tconsum_generic_8/" + &
							"consum_generic_9~tconsum_generic_9/consum_generic_10~tconsum_generic_10/" + &
							"consum_generic_11~tconsum_generic_11/consum_generic_12~tconsum_generic_12/" + &
							"consum_generic_13~tconsum_generic_13/consum_generic_14~tconsum_generic_14/" + &
							"consum_generic_15~tconsum_generic_15/consum_generic_16~tconsum_generic_16/" + &
							"consum_generic_17~tconsum_generic_17/consum_generic_18~tconsum_generic_18/" + &
							"consum_generic_19~tconsum_generic_19/consum_generic_20~tconsum_generic_20/" + &
							"consum_generic_21~tconsum_generic_21/consum_generic_22~tconsum_generic_22/" + &
							"consum_generic_23~tconsum_generic_23/consum_generic_24~tconsum_generic_24/" + &
							"consum_generic_25~tconsum_generic_25/consum_generic_26~tconsum_generic_26/" + &
							"consum_generic_27~tconsum_generic_27/consum_generic_28~tconsum_generic_28/" + &
							"consum_generic_29~tconsum_generic_29/consum_generic_30~tconsum_generic_30"
							
	CASE 'E'
		i_cCodeTable = "employ_generic_1~temploy_generic_1/employ_generic_2~temploy_generic_2/" + &
							"employ_generic_3~temploy_generic_3/employ_generic_4~temploy_generic_4/" + &
							"employ_generic_5~temploy_generic_5/employ_generic_6~temploy_generic_6/" + &
							"employ_generic_7~temploy_generic_7/employ_generic_8~temploy_generic_8/" + &
							"employ_generic_9~temploy_generic_9/employ_generic_10~temploy_generic_10/" + &
							"employ_generic_11~temploy_generic_11/employ_generic_12~temploy_generic_12/" + &
							"employ_generic_13~temploy_generic_13/employ_generic_14~temploy_generic_14/" + &
							"employ_generic_15~temploy_generic_15/employ_generic_16~temploy_generic_16/" + &
							"employ_generic_17~temploy_generic_17/employ_generic_18~temploy_generic_18/" + &
							"employ_generic_19~temploy_generic_19/employ_generic_20~temploy_generic_20/" + &
							"employ_generic_21~temploy_generic_21/employ_generic_22~temploy_generic_22/" + &
							"employ_generic_23~temploy_generic_23/employ_generic_24~temploy_generic_24/" + &
							"employ_generic_25~temploy_generic_25/employ_generic_26~temploy_generic_26/" + &
							"employ_generic_27~temploy_generic_27/employ_generic_28~temploy_generic_28/" + &
							"employ_generic_29~temploy_generic_29/employ_generic_30~temploy_generic_30"
							
	CASE 'P'
		i_cCodeTable = "provid_generic_1~tprovid_generic_1/provid_generic_2~tprovid_generic_2/" + &
							"provid_generic_3~tprovid_generic_3/provid_generic_4~tprovid_generic_4/" + &
							"provid_generic_5~tprovid_generic_5/provid_generic_6~tprovid_generic_6/" + &
							"provid_generic_7~tprovid_generic_7/provid_generic_8~tprovid_generic_8/" + &
							"provid_generic_9~tprovid_generic_9/provid_generic_10~tprovid_generic_10/" + &
							"provid_generic_11~tprovid_generic_11/provid_generic_12~tprovid_generic_12/" + &
							"provid_generic_13~tprovid_generic_13/provid_generic_14~tprovid_generic_14/" + &
							"provid_generic_15~tprovid_generic_15/provid_generic_16~tprovid_generic_16/" + &
							"provid_generic_17~tprovid_generic_17/provid_generic_18~tprovid_generic_18/" + &
							"provid_generic_19~tprovid_generic_19/provid_generic_20~tprovid_generic_20/" + &
							"provid_generic_21~tprovid_generic_21/provid_generic_22~tprovid_generic_22/" + &
							"provid_generic_23~tprovid_generic_23/provid_generic_24~tprovid_generic_24/" + &
							"provid_generic_25~tprovid_generic_25/provid_generic_26~tprovid_generic_26/" + &
							"provid_generic_27~tprovid_generic_27/provid_generic_28~tprovid_generic_28/" + &
							"provid_generic_29~tprovid_generic_29/provid_generic_30~tprovid_generic_30"
							
	CASE 'O'
		i_cCodeTable = "other_generic_1~tother_generic_1/other_generic_2~tother_generic_2/" + &
							"other_generic_3~tother_generic_3/other_generic_4~tother_generic_4/" + &
							"other_generic_5~tother_generic_5/other_generic_6~tother_generic_6/" + &
							"other_generic_7~tother_generic_7/other_generic_8~tother_generic_8/" + &
							"other_generic_9~tother_generic_9/other_generic_10~tother_generic_10/" + &
							"other_generic_11~tother_generic_11/other_generic_12~tother_generic_12/" + &
							"other_generic_13~tother_generic_13/other_generic_14~tother_generic_14/" + &
							"other_generic_15~tother_generic_15/other_generic_16~tother_generic_16/" + &
							"other_generic_17~tother_generic_17/other_generic_18~tother_generic_18/" + &
							"other_generic_19~tother_generic_19/other_generic_20~tother_generic_20/" + &
							"other_generic_21~tother_generic_21/other_generic_22~tother_generic_22/" + &
							"other_generic_23~tother_generic_23/other_generic_24~tother_generic_24/" + &
							"other_generic_25~tother_generic_25/other_generic_26~tother_generic_26/" + &
							"other_generic_27~tother_generic_27/other_generic_28~tother_generic_28/" + &
							"other_generic_29~tother_generic_29/other_generic_30~tother_generic_30"
							
END CHOOSE
end subroutine

public subroutine fu_checkreports (string user_id);//***********************************************************************************************
//
//  Function: fu_checkreports
//  Purpose:  check to see if user is report owner, if so set owner to SysAdmin
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  03/19/01 C. Jackson  Original Version
//
//***********************************************************************************************

LONG l_nCount

SELECT COUNT(*) INTO :l_nCount
  FROM cusfocus.reports
 WHERE owner = :user_id
 USING SQLCA;
 
IF l_nCount > 0 THEN
	
	MessageBox(gs_AppName,user_id+' is the owner of at least one report.  Setting owner to CFAdmin.')

//9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin	
	UPDATE cusfocus.reports
	   SET owner = 'cfadmin'
	 WHERE owner = :user_id
	 USING SQLCA;

// 	UPDATE cusfocus.reports
//	   SET owner = 'sysadmin'
//	 WHERE owner = :user_id
//	 USING SQLCA;

	 
END IF


	 
end subroutine

public function integer fu_refinteg ();//*********************************************************************************************
//
//  Function: fu_refinteg
//  Purpose:  To check to see if a row the user wants to delete has related data in another 
//            table.
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/11/00 M. Caruso   Added code to handle the IIM datasources datawindow
//  04/17/00 M. Caruso   Added code to handle the display formats datawindow
//  09/14/00 C. Jackson  Added code for user_dept
//	 11/02/00 M. Caruso   Added code for Appeal Levels and removed code for Contact Types, 
//								 Disciplines and Specialties.
//  11/20/00 C. Jackson  Add code for special_flags
//  12/07/00 C. Jackson  Remove report libraries, add Document validation
//  01/08/01 C. Jackson  Add customer_sat_codes and d_tm_resolution_codes
//  01/12/01 C. Jackson  Corrected column from resolution_code to resolution_code_id for 
//                       d_tm_resolution_codes (SCR 1250)
//  01/12/01 C. Jackson  Corrected column from customer_sat_code to customer_sat_code_id from
//                       d_tm_cus_sat_codes (SCR 1248)
//  03/05/01 C. Jackson  Add transfer codes and resolution codes
//  04/25/01 C. Jackson  Add d_tm_other_close_codes
//  6/22/2001 K. Claver  Commented references to iim_tables for InfoMaker enhancement.
//  11/30/01 C. Jackson  Correct logic for d_tm_doc_fields, was looking at wrong column to 
//                       determine ref integrity (SCR 2505)
//  12/04/01 M. Caruso   Commented d_tm_letter_types section, since that module has been replaced.
//  2/20/2002 K. Claver  Removed check for field defs as it was incorrect and correcting it would
//                       mean writing a query that would be database intensive as it would require
//								 checking if data had been put in the corresponding field in a demographics
//								 table that potentially could contain millions of rows.
//  03/04/02 C. Jackson  Correct case d_tm_relationships to look at contact_person rather than
//                       case_log since this is where relationhip_id now resides.
//  04/04/02 M. Caruso   Removed code to handle d_tm_departments since that module no longer exists.
//  06/30/03 M. Caruso   Added code to prevent the deletion of the confidentiality Level 0 record.
//*********************************************************************************************

STRING l_cKeyValue, l_cCaseType, l_cCodeID, l_cRequired, l_cColumn
INT    l_nKeyValue
LONG 	 l_nRowCount

//-------------------------------------------------------------------
//		
//		Check the Datawindow used so we know what tables to check.  If 
//		there are rows that are dependent upon the to be deleted row, 
//		return a -1, otherwise return a 0.
//
//-------------------------------------------------------------------

CHOOSE CASE dw_table_maintenance.DataObject
		
	CASE 'd_tm_appeal_levels'
	
		l_nKeyValue = dw_table_maintenance.GetItemNumber (dw_table_maintenance.i_CursorRow, &
				'appeal_level')

		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.case_log WHERE 
		case_log_appld = :l_nKeyValue;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are still records' + &
                  ' in the Case Log table that reference this row.')
			RETURN -1
		ELSE
			RETURN 0
		END IF
		
	CASE 'd_tm_customer_types'

		l_cKeyValue = dw_table_maintenance.GetItemSTring(dw_table_maintenance.i_CursorRow, &
			'customer_type')

		SELECT COUNT(*) INTO :l_nRowCOunt FROM cusfocus.other_source WHERE
			customer_type =:l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are still records' + &
				' in the Other Source table that reference this row.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF

	CASE 'd_tm_loyalty_factors'

		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
			'loyalty_factor_id')
	
		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.categories WHERE 
			loyalty_factor_id =:l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are still records' + &
				' in the Categories table that reference this row.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF	

	CASE 'd_tm_optional_groupings'

		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
			'optional_grouping_id')

		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.case_log WHERE
			optional_grouping_id =:l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are still records' + &
				' in the Case Log table that reference this row.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF	

	CASE 'd_tm_relationships'

		l_cKeyValue = dw_table_maintenance.GetItemSTring(dw_table_maintenance.i_CursorRow, &
			 'relationship_id')

		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.contact_person WHERE
			relationship_id =:l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are still records' + &
				' in the Contact Person table that reference it.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF	

	CASE 'd_tm_reminder_types'

		l_cKeyValue = dw_table_maintenance.GetItemSTring(dw_table_maintenance.i_CursorRow, &
			'reminder_type_id')

		SELECT COUNT(*) INTO :l_nRowCOunt FROM cusfocus.reminders WHERE
			reminder_type_id =:l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are still records' + &
				' in the Reminders table that reference this row.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF	
		
	CASE 'd_tm_special_flags'

		l_cKeyValue = dw_table_maintenance.GetItemSTring(dw_table_maintenance.i_CursorRow, &
			'flag_id')

		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.assigned_special_flags WHERE
			flag_id =: l_cKeyValue USING SQLCA;
			
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are sources' + &
				' that have this flag assigned to them.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF		

	CASE 'd_tm_claims_examiners'

		l_cKeyValue = dw_table_maintenance.GetItemSTring(dw_table_maintenance.i_CursorRow, &
			'claims_examiner_id')

		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.financial_compensation WHERE
			claims_examiner_id =: l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are still records' + &
				' in the Financial Compensation table that reference this row.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF		

	CASE 'd_tm_methods'
		
		l_cKeyValue = dw_table_maintenance.GetItemSTring(dw_table_maintenance.i_CursorRow, &
			'method_id')

		SELECT COUNT (*) INTO :l_nRowCount
		  FROM cusfocus.case_notes
		 WHERE method_id = :l_cKeyValue
		 USING SQLCA;
		 
		IF l_nRowCount <> 0 THEN
			Messagebox(gs_AppName, 'You cannot delete this Method since there are Case Notes that ' + &
					'reference it.')
			RETURN -1
			
		ELSE
			RETURN 0
		END IF

	CASE 'd_tm_categories'

		l_cKeyValue = dw_table_maintenance.GetItemSTring(dw_table_maintenance.i_CursorRow, &
			'category_id')
		
		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.case_log WHERE
			category_id =:l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are still records' + &
				' in the Case Log table that reference this row.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF		

	CASE 'd_tm_compensation_types'

		l_cKeyValue = dw_table_maintenance.GetItemSTring(dw_table_maintenance.i_CursorRow, &
			'compensation_type')
		
		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.financial_compensation WHERE
			compensation_type =:l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are still records' + &
					' in the Fincial Compensation table that reference this row.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF		

	CASE 'd_tm_confidentiality_levels'
		l_nKeyValue = dw_table_maintenance.GetItemNumber(dw_table_maintenance.i_CursorRow, &
			'confidentiality_level')
		
		IF l_nKeyValue = 0 THEN
			
			// prevent deletion of the level 0 record.
			MessageBox (gs_appname, 'You cannot delete this Security Level since it is required by the system.')
			RETURN -1
			
		ELSE
		
			SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.case_log WHERE
				confidentiality_level =:l_nKeyValue;
			
			IF l_nRowCount <> 0 THEN
				MessageBox(gs_AppName, 'You cannot delete this Security Level since there are still records' + &
					' in the Case Log table that reference this row.') 	
				RETURN -1
			ELSE
				SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.cusfocus_user WHERE
					confidentiality_level =:l_nKeyValue;
	
				IF l_nRowCount <> 0 THEN
					MessageBox(gs_AppName, 'You cannot delete this Security Level since there are still records' + &
						' in the Cusfocus User table that reference this row.') 	
					RETURN -1
				ELSE
					SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.case_notes WHERE
					note_security_level =:l_nKeyValue;
	
					IF l_nRowCount <> 0 THEN
						MessageBox(gs_AppName, 'You cannot delete this Security Level since there are still records' + &
							' in the Cusfocus User table that reference this row.') 	
						RETURN -1
					ELSE
						SELECT COUNT (*) INTO :l_nRowCount FROM cusfocus.consumer WHERE
						confidentiality_level = :l_nKeyValue;
						
						IF l_nRowCount <> 0 THEN
							MessageBox(gs_AppName, 'You cannot delete this Security Level since there are Consumer ' + &
									'Demographic records that reference it.')
							RETURN -1
						ELSE
							SELECT COUNT (*) INTO :l_nRowCount FROM cusfocus.employer_group WHERE
							confidentiality_level = :l_nKeyValue;
							
							IF l_nRowCount <> 0 THEN
								Messagebox(gs_AppName, 'You cannot delete this Security Level since there are Group ' + &
										'Demographics records that reference it.')
								RETURN -1
							ELSE
								SELECT COUNT (*) INTO :l_nRowCount FROM cusfocus.provider_of_service WHERE
								confidentiality_level = :l_nKeyValue;
								
								IF l_nRowCount <> 0 THEN
									MessageBox(gs_AppName, 'You cannot delete this Security Level since there are ' + &
											'Provider Demographic records that reference it.')
									RETURN -1
								ELSE
									SELECT COUNT (*) INTO :l_nRowCouNT FROM cusfocus.other_source WHERE
									confidentiality_level = :l_nKeyValue;
									
									IF l_nRowCount <> 0 THEN
										MessageBox(gs_AppName, 'You cannot delete this Security Level since there are ' + &
												'Other Source Demogrpahic records that reference it.')
										RETURN -1
									ELSE
										RETURN 0
									END IF
								END IF
							END IF
						END IF								
					END IF
				END IF		
			END IF
		END IF
		
	CASE 'd_tm_cusfocus_users' 
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
			'user_id')

		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.case_log WHERE case_log_case_rep =:l_cKeyValue 
			OR case_log_taken_by =:l_cKeyValue OR updated_by =:l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this user since there are still records' + &
				' in the Case Log table that reference this user.')
			RETURN -1
		ELSE
			SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.reminders WHERE 
				reminder_author =:l_cKeyValue USING SQLCA;

			IF l_nRowCount <> 0 THEN
				MessageBox(gs_AppName, 'You cannot delete this user since there are still records' + &
					' in the Reminders table that reference this row.')
				RETURN -1
			ELSE
				RETURN 0
			END IF
		END IF

	CASE 'd_tm_datasources'			// Added 3/11/00 - MPC

		l_nKeyValue = dw_table_maintenance.GetItemNumber (dw_table_maintenance.i_CursorRow, &
			'iim_source_id')
		
			
		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.iim_tabs
		 WHERE iim_source_id =:l_nKeyValue;
		 
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this row since there are Inquiry ' + &
				'Information tabs defined that reference this data source.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF
			

	CASE 'd_tm_display_formats'			// Added 4/17/00 - MPC
		l_cKeyValue = dw_table_maintenance.GetItemString (dw_table_maintenance.i_CursorRow, &
			'format_id')
			
		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.field_definitions
		 WHERE format_id = :l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this display format because it is being used in the system.') 	
			RETURN -1
		ELSE
			
			SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.document_fields
			 WHERE doc_format_id = :l_cKeyValue USING SQLCA;
			 
			IF l_nRowCount <> 0 THEN
				MessageBox(gs_AppName, 'You cannot delete this display format because it is being used in the system.') 	
				RETURN -1
			ELSE
			END IF
			
		END IF
		
	CASE 'd_tm_user_dept'
	
		l_cKeyValue = dw_table_maintenance.GetItemSTring(dw_table_maintenance.i_CursorRow, &
			'user_dept_id')
		
		SELECT COUNT(*) INTO :l_nRowCount FROM cusfocus.cusfocus_user WHERE
			user_dept_id =:l_cKeyValue USING SQLCA;

		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this department since there are still users' + &
				' assigned to it.') 	
			RETURN -1
		ELSE
			RETURN 0
		END IF		
		
	CASE 'd_tm_doc_fields'
		
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_cursorRow, &
		   'doc_field_id')
		
		l_nRowCount = fu_CheckDocFields(l_cKeyValue)
		
		IF l_nRowCount <> 0 THEN 
			Messagebox(gs_AppName,'You cannot delete this Document Field since there are Documents' + &
			     ' that reference it.')
			 RETURN -1
		END IF
		
		RETURN 0
				
	CASE 'd_tm_cus_sat_codes'
		
		l_cKeyValue = dw_table_maintenance.getItemString(dw_table_maintenance.i_CursorRow, &
		    'customer_sat_code_id')
		
		SELECT COUNT (*) INTO :l_nRowCount
		  FROM cusfocus.case_log
		 WHERE customer_sat_code_id = :l_cKeyValue
		 USING SQLCA;
		 
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName,'You cannot delete this Customer Satisfaction Code since there are ' + &
			    'cases that reference it.')
			RETURN -1
		END IF
		
		l_cCodeID = dw_table_maintenance.GetItemString( dw_table_maintenance.i_CursorRow, "customer_sat_code_id" )
		IF dw_table_maintenance.Find( "customer_sat_code_id <> '"+l_cCodeID+"' AND active = 'Y'", &
												1, dw_table_maintenance.RowCount( ) ) = 0 THEN
			//Check if marked required for close
			SELECT Count( * )
			INTO :l_nRowCount
			FROM cusfocus.case_types
			WHERE cus_sat_code_req = 'Y'
			USING SQLCA;
			
			IF l_nRowCount > 0 THEN
				MessageBox( gs_AppName, "At least one active customer satisfaction code must exist when required for"+ &
								" case closure", StopSign!, OK! )
				RETURN -1
			END IF
		END IF
		
		RETURN 0
		
	CASE 'd_tm_resolution_codes'
		
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
		    'resolution_code_id')
			 
		SELECT COUNT (*) INTO :l_nRowCount
		  FROM cusfocus.case_log
		 WHERE resolution_code_id = :l_cKeyValue
		USING SQLCA;
		
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName,'You cannot delete this Resolution Code since there are ' + &
			    'cases that reference it.')
			RETURN -1
		END IF
		
		l_cCaseType = dw_table_maintenance.GetItemString( dw_table_maintenance.i_CursorRow, "case_type" )
		l_cCodeID = dw_table_maintenance.GetItemString( dw_table_maintenance.i_CursorRow, "resolution_code_id" )
		IF dw_table_maintenance.Find( "case_type = '"+l_cCaseType+"' AND resolution_code_id <> '"+l_cCodeID+"' AND "+ &
												" active = 'Y'", 1, dw_table_maintenance.RowCount( ) ) = 0 THEN
			//Check if marked required for close
			SELECT res_code_req
			INTO :l_cRequired
			FROM cusfocus.case_types
			WHERE case_type = :l_cCaseType
			USING SQLCA;
			
			IF l_cRequired = "Y" THEN
				MessageBox( gs_AppName, "At least one active resolution code must exist for this case type when required for"+ &
								" case closure", StopSign!, OK! )
				RETURN -1
			END IF
		END IF
		
		RETURN 0

	CASE 'd_tm_other_close_codes'
		
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
				'other_close_code_id')
				
		SELECT COUNT (*) INTO :l_nRowCount
		  FROM cusfocus.case_log
		 WHERE other_close_code_id = :l_cKeyVaLUE
		USING SQLCA;
		
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName,'You cannot delete this Close Code since there are ' + &
					'cases that reference it.')
			RETURN -1
		END IF
		
		l_cCaseType = dw_table_maintenance.GetItemString( dw_table_maintenance.i_CursorRow, "case_type" )
		l_cCodeID = dw_table_maintenance.GetItemString( dw_table_maintenance.i_CursorRow, "other_close_code_id" )
		IF dw_table_maintenance.Find( "case_type = '"+l_cCaseType+"' AND other_close_code_id <> '"+l_cCodeID+"' AND "+ &
												" active = 'Y'", 1, dw_table_maintenance.RowCount( ) ) = 0 THEN
			//Check if marked required for close
			SELECT other_close_code_req
			INTO :l_cRequired
			FROM cusfocus.case_types
			WHERE case_type = :l_cCaseType
			USING SQLCA;
			
			IF l_cRequired = "Y" THEN
				MessageBox( gs_AppName, "At least one active other close code must exist for this case type when required for"+ &
								" case closure", StopSign!, OK! )
				RETURN -1
			END IF
		END IF
		
		RETURN 0
	
CASE 'd_tm_reporting_fields'

		RETURN 0
		
	CASE 'd_tm_case_note_types'
		
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
			'note_type')
			
		SELECT COUNT (*) into :l_nRowCount
		  FROM cusfocus.case_notes
		 WHERE note_type = :l_cKeyValue
		 USING SQLCA;
		 
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this Note Type since there are ' + &
					'case notes that reference it.')
			RETURN -1
		ELSE
			RETURN 0
		END IF
		
	CASE 'd_case_transfer_codes'
		
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
			'case_transfer_code')
			
		SELECT COUNT (*) INTO :l_nRowCount
		  FROM cusfocus.case_transfer
		 WHERE case_transfer_code = :l_cKeyValue
		 USING SQLCA;
		 
		IF l_nRowCount > 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this Transfer Code since there are ' + &
					'transfers that reference it.')
					
			RETURN -1
		ELSE
			SELECT COUNT (*) INTO :l_nRowCount
			  FROM cusfocus.case_transfer_history
			 WHERE case_transfer_code = :l_cKeyValue
			 USING SQLCA;
			 
			 IF l_nRowCount <> 0 THEN
				Messagebox(gs_AppName, 'You cannot delete this Transfer Code since there are ' + &
				      'transfers that reference it.')
				RETURN -1
			ELSE
				RETURN 0
			END IF
		END IF
		
	CASE 'd_tm_doc_status'
		
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
		     'doc_status_id')
			  
		SELECT COUNT(*) INTO :l_nRowCount
        FROM cusfocus.documents
		 WHERE doc_status_id = :l_cKeyValue
		 USING SQLCA;
		
		IF l_nRowCount <> 0 THEN
			Messagebox(gs_AppName, 'You cannot delete the Document Status since there are Documents ' + &
			       'that reference it.')
			RETURN -1
		ELSE
			RETURN 0		
			  
		END IF
		
	CASE 'd_tm_doc_types'
		
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
		      'doc_type_id')
				
		SELECT COUNT (*) INTO :l_nRowCount
		  FROM cusfocus.document_fields
		 WHERE doc_type_id = :l_cKeyValue
		 USING SQLCA;
		 
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this Document Type since there are Document fields ' + &
					'that reference it.')
			RETURN -1
			
		ELSE
			
			SELECT COUNT (*) INTO :l_nRowCount
			  FROM cusfocus.documents
			 WHERE doc_type_id = :l_cKeyValue
			 USING SQLCA;
			 
			IF l_nRowCount <> 0 THEN
				MessageBox(gs_AppName, 'You cannot delete this Document Type since there are Documents ' + &
						'that reference it.')
				RETURN -1
				
			ELSE
				RETURN 0
			END IF
		END IF
		
	CASE 'd_tm_provider_types'
		
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
			'provider_type')
			
		SELECT COUNT (*) INTO :l_nRowCount FROM cusfocus.provider_of_service WHERE 
		   provider_type = :l_cKeyValue USING SQLCA;
		
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this provider type since there are Providers that ' + &
					'reference it.')
			RETURN -1
		ELSE
			SELECT COUNT (*) INTO :l_nRowCount FROM cusfocus.case_log WHERE
			   source_provider_type = :l_cKeyValue USING SQLCA;
				
			IF l_nRowCount <> 0 THEN
				MessageBox(gs_AppName, 'You cannot delete this provider type since there are cases that ' + &
						'reference it.')
				RETURN -1
			ELSE
				RETURN 0
			END IF
		END IF
		
	CASE 'd_tm_special_flags'
		
		l_cKeyValue = dw_table_maintenance.GetItemString(dw_table_maintenance.i_CursorRow, &
			'flag_id')
			
		SELECT COUNT (*) INTO :l_nRowCount FROM cusfocus.assigned_special_flags WHERE 
		   flag_id = :l_cKeyValue USING SQLCA;
			
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this special flag since there are records that reference it.')
			RETURN -1
		ELSE
			RETURN 0
		END IF
	Case 'd_tm_dateterm_name'
		l_nKeyValue = dw_table_maintenance.GetItemNumber(dw_table_maintenance.i_CursorRow, 'datetermid')
			
		SELECT COUNT (*) INTO :l_nRowCount FROM cusfocus.appealdetail WHERE 
		   datetermid = :l_nKeyValue USING SQLCA;
		
		If l_nRowCount = 0 Then 
			Select Count(*) Into :l_nRowCount FROM cusfocus.appealheader WHERE datetermid = :l_nKeyValue USING SQLCA;	
		End If	
			
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this date term as there are records that reference it.')
			RETURN -1
		ELSE
			RETURN 0
		END IF
	Case 'd_tm_appeal_event'
		l_nKeyValue = dw_table_maintenance.GetItemNumber(dw_table_maintenance.i_CursorRow, 'appealeventid')
			
		SELECT COUNT (*) INTO :l_nRowCount FROM cusfocus.appealdetail WHERE 
		   datetermid = :l_nKeyValue USING SQLCA;
		
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this appeal event as there are records that reference it.')
			RETURN -1
		ELSE
			RETURN 0
		END IF
	Case 'd_tm_keywords'
		l_nKeyValue = dw_table_maintenance.GetItemNumber(dw_table_maintenance.i_CursorRow, 'keyword_id')
			
		SELECT COUNT (*) INTO :l_nRowCount FROM cusfocus.appealheader WHERE 
		   key_word_1 = :l_nKeyValue  OR
		   key_word_2 = :l_nKeyValue  
			USING SQLCA;
		
		IF l_nRowCount <> 0 THEN
			MessageBox(gs_AppName, 'You cannot delete this key word as there are records that reference it.')
			RETURN -1
		ELSE
			RETURN 0
		END IF
		
END CHOOSE

Return 0


end function

public function integer fu_checkdocfields (ref string doc_field_id);//****************************************************************************************
//
//  Function: fu_CheckDocFields
//  Purpose:  To verify a Document Field is not currently being used before allowing the
//            user to delete it
//	
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------
//  05/08/02 C. Jackson  Original Version
//****************************************************************************************

STRING l_cDocColumn, l_cDocTypeID
LONG l_nCount

SELECT doc_column_name, doc_type_id INTO :l_cDocColumn, :l_cDocTypeID
  FROM cusfocus.document_fields
 WHERE doc_field_id = :doc_field_id
 USING SQLCA;
 
CHOOSE CASE l_cDocColumn
	CASE 'doc_config_1'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_1 IS NOT NULL
		 USING SQLCA;
		
	CASE 'doc_config_2'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_2 IS NOT NULL
		 USING SQLCA;
		
	CASE 'doc_config_3'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_3 IS NOT NULL
		 USING SQLCA;
		
	CASE 'doc_config_4'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_4 IS NOT NULL
		 USING SQLCA;
		
	CASE 'doc_config_5'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_5 IS NOT NULL
		 USING SQLCA;
		
	CASE 'doc_config_6'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_6 IS NOT NULL
		 USING SQLCA;
		
	CASE 'doc_config_7'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_7 IS NOT NULL
		 USING SQLCA;
		
	CASE 'doc_config_8'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_8 IS NOT NULL
		 USING SQLCA;
		
	CASE 'doc_config_9'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_9 IS NOT NULL
		 USING SQLCA;
		
	CASE 'doc_config_10'
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.documents
		 WHERE doc_type_id = :l_cDocTypeID
		   AND doc_config_10 IS NOT NULL
		 USING SQLCA;
		
END CHOOSE

RETURN l_nCount


end function

on u_table_maintenance.create
int iCurrent
call super::create
this.dw_table_maintenance=create dw_table_maintenance
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_table_maintenance
end on

on u_table_maintenance.destroy
call super::destroy
destroy(this.dw_table_maintenance)
end on

event resize;call super::resize;dw_table_maintenance.width = this.width - 73
dw_table_maintenance.height = this.height - 44

end event

type dw_table_maintenance from u_dw_std within u_table_maintenance
event ue_deffielddef ( string a_csourcetype,  integer a_nrow )
event ue_defcpfielddef ( string a_csourcetype,  string a_ccasetype,  integer a_nrow )
event ue_downkey pbm_dwnkey
integer x = 37
integer y = 20
integer width = 3506
integer height = 1548
integer taborder = 10
string dataobject = "d_tm_case_types"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_deffielddef;//*********************************************************************************************
//
//	 Event:   ue_deffielddef
//	 Purpose: To insert default values into the field definitions table
//			
//	 Date     Developer   Description
//	 -------- ----------- ---------------------------------------------------------------------
//	 3/20/2001 K. Claver  Created.
//*********************************************************************************************
String l_cRowSourceType, l_cColName, l_cRowCol
Integer l_nRow, l_nIndex, l_nThisFieldOrd = 0, l_nMaxFieldOrd = 0, l_nMaxColNum = 0, l_nRowColNum = 0

//Unfortunately, this is the only way to default the field order number.  Creating a
//  computed column utilizing the max function doesn't always work because you have
//  to group the rows by source type to ensure the proper max value.  Doing a find with
//  the condition of "field_order = max( field_order )" doesn't work at all even though
//  it doesn't throw an error.
FOR l_nIndex = 1 TO THIS.RowCount( )
	l_cRowSourceType = THIS.Object.source_type[ l_nIndex ]
	IF l_cRowSourceType = a_cSourceType THEN
		//Field Order
		l_nThisFieldOrd = THIS.Object.field_order[ l_nIndex ]
		IF l_nThisFieldOrd > l_nMaxFieldOrd AND NOT IsNull( l_nThisFieldOrd ) THEN
			l_nMaxFieldOrd = l_nThisFieldOrd
		END IF
		
		//Column name
		l_cRowCol = THIS.Object.column_name[ l_nIndex ]
		IF Trim( l_cRowCol ) <> "" AND NOT IsNull( l_cRowCol ) THEN
			CHOOSE CASE l_cRowSourceType
				CASE "C", "E", "P"
					l_nRowColNum = Integer( Mid( l_cRowCol, 16 ) )
				CASE "O"
					l_nRowColNum = Integer( Mid( l_cRowCol, 15 ) )
			END CHOOSE
			
			IF l_nRowColNum > l_nMaxColNum THEN
				l_nMaxColNum = l_nRowColNum
			END IF
		END IF
	END IF
NEXT

//Field Order
//Default to one if the maximum is still 0
l_nMaxFieldOrd ++
THIS.Object.field_order[ a_nRow ] = l_nMaxFieldOrd

//Column Name
//Default to one if the maximum is still 0
l_nMaxColNum ++

IF l_nMaxColNum <= 30 THEN
	CHOOSE CASE a_cSourceType
		CASE "C"
			l_cColName = ( "consum_generic_"+String( l_nMaxColNum ) )
		CASE "E"
			l_cColName = ( "employ_generic_"+String( l_nMaxColNum ) )
		CASE "P"
			l_cColName = ( "provid_generic_"+String( l_nMaxColNum ) )
		CASE "O"
			l_cColName = ( "other_generic_"+String( l_nMaxColNum ) )
	END CHOOSE
	
	THIS.Object.column_name[ a_nRow ] = l_cColName
END IF

end event

event ue_defcpfielddef;//*********************************************************************************************
//
//	 Event:   ue_defcpfielddef
//	 Purpose: To insert default values into the case properties field definitions table
//			
//	 Date     Developer   Description
//	 -------- ----------- ---------------------------------------------------------------------
//	 3/20/2001 K. Claver  Created.
//*********************************************************************************************
String l_cRowSourceType, l_cColName, l_cRowCol, l_cRowCaseType
Integer l_nRow, l_nIndex, l_nThisFieldOrd = 0, l_nMaxFieldOrd = 0, l_nMaxColNum = 0, l_nRowColNum = 0

//Unfortunately, this is the only way to default the field order number.  Creating a
//  computed column utilizing the max function doesn't always work because you have
//  to group the rows by source type to ensure the proper max value.  Doing a find with
//  the condition of "field_order = max( field_order )" doesn't work at all even though
//  it doesn't throw an error.
FOR l_nIndex = 1 TO THIS.RowCount( )
	l_cRowSourceType = THIS.Object.source_type[ l_nIndex ]
	l_cRowCaseType = THIS.Object.case_type[ l_nIndex ]
	IF l_cRowSourceType = a_cSourceType AND l_cRowCaseType = a_cCaseType THEN
		//Field Order
		l_nThisFieldOrd = THIS.Object.field_order[ l_nIndex ]
		IF l_nThisFieldOrd > l_nMaxFieldOrd AND NOT IsNull( l_nThisFieldOrd ) THEN
			l_nMaxFieldOrd = l_nThisFieldOrd
		END IF
		
		//Column name
		l_cRowCol = THIS.Object.column_name[ l_nIndex ]
		IF Trim( l_cRowCol ) <> "" AND NOT IsNull( l_cRowCol ) THEN
			l_nRowColNum = Integer( Mid( l_cRowCol, 14 ) )
			
			IF l_nRowColNum > l_nMaxColNum THEN
				l_nMaxColNum = l_nRowColNum
			END IF
		END IF
	END IF
NEXT

//Field Order
//Default to one if the maximum is still 0
l_nMaxFieldOrd ++
THIS.Object.field_order[ a_nRow ] = l_nMaxFieldOrd

//Column Name
//Default to one if the maximum is still 0
l_nMaxColNum ++

IF l_nMaxColNum <= 30 THEN
	l_cColName = ( "case_generic_"+String( l_nMaxColNum ) )
	THIS.Object.column_name[ a_nRow ] = l_cColName
END IF

end event

event pcd_savebefore;//**************************************************************************************************
//
//		Event:	pcd_savebefore
//		Purpose:	To set who updated the table and when.
//		
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------------
//  03/22/00 C. Jackson  Added validation for Document Fields
//  11/28/00 M. Caruso   Added validation of case note type descriptions.
//  4/26/2001 K. Claver  Added validation to ensure that new users are assigned to a department.  Also
//								 corrected the symbol for the message boxes.
//  01/29/02 C. Jackson  Added validation for Other Close Codes 
//  02/28/2002 K. Claver Corrected spellings for words in message for unique user ids
//  5/30/2002 K. Claver  Removed validation for column name for document fields as it is auto-populated
//								 upon picking a document type.
//  8/18/2004 K. Claver  Added code to validate for attachment types
//**************************************************************************************************/

STRING      	l_cOldKey[], l_cNewKey, l_cTest, l_cData, l_cColName, l_cFieldLabel, l_cFormatID
STRING         l_cDocTypeID, l_cSetLimit, l_cActive, l_cAttDesc, l_cAttExt, ls_test
DATETIME    	l_dtTimeStamp
LONG        	l_nRowCount, l_nFieldLength, l_nSelectedRows[], l_nByteLimit
INT         	l_nCounter, l_nOldKeyCounter, l_nAnotherCOunter
DWITEMSTATUS	l_dwisStatus
string 			ls_sourcetype, ls_columnname
LONG				ll_fielddef_ID, ll_sourcetype, ll_data
string			ls_fielddef_ID, ls_casetype

l_nRowCount = RowCount()

ls_test = Dataobject

CHOOSE CASE DataObject
		
	CASE 'd_tm_other_close_codes'
		FOR l_nCounter = 1 TO l_nRowCount
			l_cData = THIS.GetItemString(l_nCounter, 'other_close_code')
			IF IsNull (l_cData) OR TRIM(l_cData) = '' THEN
				MessageBox(gs_AppName, 'You must set a Close Code.',StopSign!, OK!)
				Error.i_FWError = c_Fatal
				l_nSelectedRows[ 1 ] = l_nCounter
				fu_SetSelectedRows (1, l_nSelectedRows, c_IgnoreChanges, c_NoRefreshChildren )
				THIS.SetColumn ('other_close_code')
			END IF
			l_cData = THIS.GetItemString(l_nCounter, 'case_type')
			IF IsNull (l_cData) OR TRIM(l_cData) = '' THEN
				MessageBox(gs_AppName, 'You must select a Case Type.',StopSign!, OK!)
				Error.i_FWError = c_Fatal
				l_nSelectedRows[ 1 ] = l_nCounter
				fu_SetSelectedRows (1, l_nSelectedRows, c_IgnoreChanges, c_NoRefreshChildren )
				THIS.SetColumn ('case_type')
			END IF
		NEXT 
	CASE 'd_tm_cusfocus_users'
		// Make sure the user has entered a UNQUIE user_id for the cusfocus_users table.
		FOR l_nCounter = 1 to l_nRowCount 
			l_dwisStatus = GetItemStatus(l_nCounter, 0, PRIMARY!)
			IF l_dwisStatus = NotModified! THEN
				l_nOldKeyCounter ++
				l_cOldKey[l_nOldKeyCounter] = GetItemString(l_nCounter, 'user_id')
			END IF
			
			//Check to see if the department id is populated
			l_cData = THIS.GetItemString( l_nCounter, "user_dept_id" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				Messagebox( gs_appname, "You must set a department to save a new user.", StopSign!, OK! )
				Error.i_FWError = c_Fatal
				l_nSelectedRows[ 1 ] = l_nCounter
				fu_SetSelectedRows( 1, l_nSelectedRows, c_IgnoreChanges, c_NoRefreshChildren )
				THIS.SetColumn( "user_dept_id" )
				RETURN
			END IF
		NEXT

	CASE 'd_tm_case_note_types'
		AcceptText ()
		FOR l_nCounter = 1 TO l_nRowCount
			l_cData = GetItemString (l_nCounter, 'note_desc')
			IF IsNull (l_cData) OR l_cData = '' THEN
				Messagebox (gs_appname, 'You must enter a type description to save a note type.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				l_nSelectedRows[1] = l_nCounter
				fu_SetSelectedRows (1, l_nSelectedRows[], c_IgnoreChanges, c_NoRefreshChildren)
				SetColumn ('note_desc')
				RETURN
			END IF
		NEXT
	
	CASE 'd_tm_doc_fields'
		FOR l_nCounter = 1 to l_nRowCount 
			l_cFieldLabel = GetItemString(l_nCounter,'doc_field_label')
			l_nFieldLength = GetItemNumber(l_nCounter,'doc_field_length')
			l_cFormatID = GetItemString(l_nCounter,'doc_format_id')
			l_cDoctypeID = GetItemString(l_nCounter,'doc_type_id')

			IF ISNULL(l_cDocTypeID) THEN
				messagebox(gs_AppName,'You must enter a Document Type.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			ELSEIF ISNULL(l_cFieldLabel) THEN
				messagebox(gs_AppName,'You must enter a Field Label.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			ELSEIF ISNULL(l_nFieldLength) THEN
				messagebox(gs_AppName,'You must enter a Field Length.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			ELSEIF ISNULL(l_cFormatID) THEN 
				messagebox(gs_AppName,'You must enter a Format.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			END IF
			
		NEXT
	CASE 'd_tm_attachment_types'
		FOR l_nCounter = 1 TO l_nRowCount
			l_cActive = THIS.Object.type_active[ l_nCounter ]
			l_cAttDesc = THIS.Object.type_desc[ l_nCounter ]
			l_cAttExt = THIS.Object.type_extension[ l_nCounter ]
			
			IF l_cActive = "Y" THEN
				l_cSetLimit = THIS.Object.type_set_limit[ l_nCounter ]
				l_nByteLimit = THIS.Object.type_byte_limit[ l_nCounter ]
				
				IF l_cSetLimit = "Y" AND ( IsNull( l_nByteLimit ) OR l_nByteLimit = 0 ) THEN
					MessageBox( gs_AppName, "You must specify a Byte Limit if Limit Size is checked", StopSign!, OK! )
					Error.i_FWError = c_Fatal
					RETURN
				END IF
			END IF			
			
			IF IsNull( l_cAttDesc ) OR Trim( l_cAttDesc ) = "" THEN
				MessageBox( gs_AppName, "Description is a required field", StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			ELSEIF IsNull( l_cAttExt ) OR Trim( l_cAttExt ) = "" THEN
				MessageBox( gs_AppName, "Extension is a required field", StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			END IF
			
			
		NEXT
		
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 6.15.2005
//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'd_tm_case_prop_field_defs'
		If ib_dropdowns_changed = TRUE Then
			  DELETE FROM cusfocus.syntaxstorage  
			  USING SQLCA;
				ib_dropdowns_changed = FALSE
			
		End If
		
	Case 'd_tm_dateexclusion'
		For l_nCounter = 1 to l_nRowCount
			If isNull(GetItemString(l_nCounter, 'isholiday')) Then SetItem(l_nCounter, 'isholiday', 'N')
		Next
		
	Case 'd_tm_appealtype_event_defaults'
		For l_nCounter = 1 to l_nRowCount
			If isNull(GetItemString(l_nCounter, 'reminder')) Then SetItem(l_nCounter, 'reminder', 'N')
			If isNull(GetItemString(l_nCounter, 'letter')) Then SetItem(l_nCounter, 'letter', 'N')
		Next
		
		
	Case 'd_tm_appealpropertiesvalues'
		FOR l_nCounter = 1 to l_nRowCount
			l_dwisStatus = GetItemStatus(l_nCounter, 0, PRIMARY!)
			IF l_dwisStatus = NewModified! OR l_dwisStatus = DataModified! THEN
				ll_sourcetype 	= 	GetItemNumber(l_nCounter, 'appeal_properties_field_def_source_type')
				ls_columnname 	=	GetItemString(l_nCounter, 'appeal_properties_field_def_column_name')
				
				If IsNull(ll_sourcetype) or IsNull(ls_columnname) Then
					MessageBox( gs_AppName, "You must pick an appeal event and column name before saving.", StopSign!, OK! )
					Error.i_FWError = c_Fatal
					RETURN
				End If
				
				  SELECT Convert(int, cusfocus.appeal_properties_field_def.definition_id)
				 INTO :ll_fielddef_ID  
				 FROM cusfocus.appeal_properties_field_def  
				WHERE ( cusfocus.appeal_properties_field_def.source_type = :ll_sourcetype ) AND  
						( cusfocus.appeal_properties_field_def.column_name = :ls_columnname )   ;
						
			IF IsNull( ll_fielddef_ID ) OR string(ll_fielddef_ID)  = "0"  THEN
				MessageBox( gs_AppName, "An Appeal Property is not setup for this source type and column name combination. Please use Appeal Properties Fields to setup an appeal property for this combination.", StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			End If


				this.SetItem(l_nCounter, 'appealpropertiesvalues_field_definition_id', ll_fielddef_ID)
				
			End If
		Next
		
		
	CASE 'd_tm_case_prop_values'
		FOR l_nCounter = 1 to l_nRowCount
			l_dwisStatus = GetItemStatus(l_nCounter, 0, PRIMARY!)
			IF l_dwisStatus = NewModified! OR l_dwisStatus = DataModified! THEN
				ls_sourcetype 	= 	GetItemString(l_nCounter, 'case_properties_field_def_source_type')
				ls_casetype 	=	GetItemString(l_nCounter, 'case_properties_field_def_case_type')
				ls_columnname 	=	GetItemString(l_nCounter, 'case_properties_field_def_column_name')
				
				If IsNull(ls_sourcetype) Or IsNull(ls_casetype) or IsNull(ls_columnname) Then
					MessageBox( gs_AppName, "You must pick a source type, case type, and column name before saving.", StopSign!, OK! )
					Error.i_FWError = c_Fatal
					RETURN
				End If
				
				  SELECT Convert(int, cusfocus.case_properties_field_def.definition_id)
				 INTO :ll_fielddef_ID  
				 FROM cusfocus.case_properties_field_def  
				WHERE ( cusfocus.case_properties_field_def.source_type = :ls_sourcetype ) AND  
						( cusfocus.case_properties_field_def.case_type = :ls_casetype ) AND  
						( cusfocus.case_properties_field_def.column_name = :ls_columnname )   ;
						
			IF IsNull( ll_fielddef_ID ) OR string(ll_fielddef_ID)  = "0"  THEN
				MessageBox( gs_AppName, "A Case Property is not setup for this source type, case type, column name combination. Please use Case Property Fields to setup a case property for this combination.", StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			End If


				this.SetItem(l_nCounter, 'casepropertiesvalues_field_definition_id', ll_fielddef_ID)
				
			End If
		Next

CASE 'd_tm_eligibility_xref'
		FOR l_nCounter = 1 TO l_nRowCount
			
			l_cData = GetItemString (l_nCounter, 'prog_nbr')
			IF IsNull (l_cData) OR l_cData = '' THEN
				Messagebox (gs_appname, 'You must enter a program number.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				l_nSelectedRows[1] = l_nCounter
				fu_SetSelectedRows (1, l_nSelectedRows[], c_IgnoreChanges, c_NoRefreshChildren)
				SetColumn ('prog_nbr')
				RETURN
			END IF
			
			l_cData = GetItemString (l_nCounter, 'carrier')
			IF IsNull (l_cData) OR l_cData = '' THEN
				Messagebox (gs_appname, 'You must enter a carrier.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				l_nSelectedRows[1] = l_nCounter
				fu_SetSelectedRows (1, l_nSelectedRows[], c_IgnoreChanges, c_NoRefreshChildren)
				SetColumn ('carrier')
				RETURN
			END IF
			
			ll_Data = GetItemNumber (l_nCounter, 'line_of_business_id')
			IF IsNull (ll_Data) OR ll_Data = 0 THEN
				Messagebox (gs_appname, 'You must enter a Line of Business.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				l_nSelectedRows[1] = l_nCounter
				fu_SetSelectedRows (1, l_nSelectedRows[], c_IgnoreChanges, c_NoRefreshChildren)
				SetColumn ('line_of_business_id')
				RETURN
			END IF
			
		NEXT

END CHOOSE

// If the Row is NewModified or DataModified then set the timestamp and updated by.
FOR l_nCounter = 1 to l_nRowCount
	l_dwisStatus = GetItemStatus(l_nCounter, 0, PRIMARY!)
	IF l_dwisStatus = NewModified! OR l_dwisStatus = DataModified! THEN
		IF DataObject = 'd_tm_attachment_types' THEN
			l_dtTimeStamp = i_wParentWindow.fw_GetTimeStamp()
			SetItem(l_nCounter, 'type_updated_by', OBJCA.WIN.fu_GetLogin(SQLCA))
			SetItem(l_nCounter, 'type_updated_date', l_dtTimeStamp)
		ELSE
			l_dtTimeStamp = i_wParentWindow.fw_GetTimeStamp()
			SetItem(l_nCounter, 'updated_by', OBJCA.WIN.fu_GetLogin(SQLCA))
			SetItem(l_nCounter, 'updated_timestamp', l_dtTimeStamp)
		END IF
		
		IF DATAOBJECT = 'd_tm_cusfocus_users' THEN
			IF ISNUll(GetItemSTring(l_nCounter, 'user_last_name')) THEN
				MessageBox(gs_AppName, 'You must enter a User Last Name prior to saving.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			END IF
			IF ISNULL(GetItemString(l_nCounter, 'user_first_name')) THEN
				MessageBox(gs_AppName, 'You must enter a User First Name prior to saving.', StopSign!, OK! )
				Error.i_FWError = c_Fatal
				RETURN
			END IF
			l_cNewKey = GetItemString(l_nCounter, 'user_id')
			FOR l_nAnotherCounter = 1 to l_nOldKeyCounter
				IF l_cNewKey = l_cOldKey[l_nAnotherCounter] THEN
					MessageBox(gs_AppName, 'You cannot have duplicate UserIDs. ' + &
							'Please enter a unique UserID.', StopSign!, OK! )
					Error.i_FWError = c_Fatal
					RETURN
				END IF
			NEXT
		END IF
	END IF
NEXT
end event

event pcd_retrieve;call super::pcd_retrieve;//***************************************************************************************
//
//	
//			Event:	pcd_retrieve
//			Purpose:	Duh!
//			
//			Revisions:
//	Date     Developer    Description
//	======== ============ ===============================================================
//	8/13/99  M. Caruso    Now handles Provider Types table maintenance.
// 10/26/00 M. Caruso    Reset the status of rows with the Maxvalue field so that the
//								 updated by and timestamp fields do not get updated unless the
//								 user actually makes a change.
// 8/17/2004 K. Claver   Excluded the d_tm_attachment_types from the code to get the max
//								 id from the datawindow as uses identity column.
//***************************************************************************************/

LONG					l_nReturn, l_nRow
DATAWINDOWCHILD	l_dwcDefaultSurvey, l_dwcAppealType, l_dwcServiceType

l_nReturn = dw_table_maintenance.Retrieve()

IF l_nReturn < 0 THEN
	Error.i_FWError = c_Fatal
ELSEIF l_nReturn = 0 THEN
	CHOOSE CASE DataObject
		CASE 'd_tm_field_defs'
			SELECT max (convert (numeric, definition_id))
			INTO   :i_nMaxValue
			FROM   cusfocus.field_definitions
			USING  SQLCA;
			
			IF SQLCA.SQLCode <> 0 THEN	i_nMaxValue = 0
			
		CASE ELSE			
			i_nMaxValue = 0
			
	END CHOOSE
ELSE
//-------------------------------------------------------------------
//
//		Get the maximum value in the datawindow if the datawindow is
//		not the Case Type or Provider Types (we are not inserting into
//    the Case Type or Provider Types tables) otherwise insert a
//		dummy record into the Survey DropDown so that the user
//		can assign None.
//
//-------------------------------------------------------------------

	IF (DataObject <> 'd_tm_cusfocus_users') AND (DataObject <> 'd_tm_provider_types') AND &
	   (DataObject <> 'd_case_transfer_codes') AND (DataObject <> 'd_tm_attachment_types') &
		And	(Dataobject <> 'd_tm_optional_groupings') And (Dataobject <> 'd_tm_contacthistory_fields') & 
		And (Dataobject <> 'd_tm_case_prop_values') And (Dataobject <> 'd_tm_appeal_event') & 
		And (Dataobject <> 'd_tm_appeal_prop_field_defs')  And (DataObject <> 'd_tm_appeal_outcome') & 
		And (Dataobject <> 'd_tm_appealpropertiesvalues') And (Dataobject <> 'd_tm_appeal_type') And & 
		(DataObject <> 'd_tm_dateterm_name') And (DataObject <> 'd_tm_dateexclusion') And & 
		(DataObject <>  'd_tm_appealtype_event_defaults') And (DataObject <> 'd_tm_appealstatus') And & 
		(DataObject <> 'd_tm_bcbsvt_setup') And (DataObject <> 'd_tm_line_of_business') and &
		(DataObject <> 'd_tm_service_type') And (DataObject <> 'd_tm_appealtype_event_defaults')  and &
		(DataObject <> 'd_tm_fax_queues') And (DataObject <> 'd_tm_hotkeys') And &
		(DataObject <> 'd_tm_work_queue_security') and (DataObject <> 'd_tm_keywords') and &
		(DataObject <> 'd_tm_table_security')  and (DataObject <> 'd_tm_eligibility_xref') THEN
		CHOOSE CASE DataObject
			CASE 'd_tm_case_types'
				l_nReturn = GetChild('letter_id', l_dwcDefaultSurvey)
				l_dwcDefaultSurvey.InsertRow(1)
				l_dwcDefaultSurvey.SetItem(1, 'letter_name', '(None)')
				
			CASE 'd_tm_field_defs'
				SELECT max (convert (numeric, definition_id))
				INTO   :i_nMaxValue
				FROM   cusfocus.field_definitions
				USING  SQLCA;
				
				IF SQLCA.SQLCode <> 0 THEN	i_nMaxValue = 0	
				
			CASE ELSE
				i_nMaxValue = GetItemNumber(1, 'maxvalue')
				FOR l_nRow = 1 to RowCount ()
					SetItemStatus (l_nRow, 0, Primary!, NotModified!)
				NEXT
		
		END CHOOSE
	END IF
END IF

end event

event pcd_delete;/********************************************************************

		Event:	pcd_delete
		Purpose:	To call the referientail integrity function and if
					everything is ok then delete the row.
					
					
5/28/2002  K. Claver  Added code to short-circuit this event to allow
							 for re-sequencing of the columns before deletion
							 to prevent gaps in the sequence.

********************************************************************/

INT l_nReturn, l_nMessageRV, l_nIndex, l_nColSequence, l_nCurrColSequence
INT l_nRV, l_nNewSequence
String l_cCurrDocType, l_cDocType, l_cNewCol

IF This.RowCount() = 0 THEN Return
//-------------------------------------------------------------------
//
//		Call the fu_refinteg function to check RI.
//
//-------------------------------------------------------------------

l_nReturn = fu_refinteg()

IF l_nReturn = 0 THEN
	//Re-sequence document fields, if necessary.
	IF THIS.DataObject = "d_tm_doc_fields" THEN
		l_nMessageRV = MessageBox( gs_AppName, "There is one record selected for deletion.~r~n~r~n"+ &
											"Do you want to delete this record?", Question!, YesNo!, 2 )
										
		IF l_nMessageRV = 1 THEN
			//Re-sequence and then delete
			l_cCurrDocType = THIS.GetItemString( THIS.i_CursorRow, "doc_type_id" )
			l_nCurrColSequence = Integer( Mid( THIS.GetItemString( THIS.i_CursorRow, "doc_column_name" ), 12 ) )
			FOR l_nIndex = 1 TO THIS.RowCount( )
				IF l_nIndex <> THIS.i_CursorRow THEN
					IF THIS.GetItemString( l_nIndex, "doc_type_id" ) = l_cCurrDocType THEN
						//Get the sequence.  If greater, decrement by one
						l_nColSequence = Integer( Mid( THIS.GetItemString( l_nIndex, "doc_column_name" ), 12 ) )
						IF l_nColSequence > l_nCurrColSequence THEN
							l_nNewSequence = ( l_nColSequence - 1 )
							l_cNewCol = ( "doc_config_"+String( l_nNewSequence ) )
							THIS.SetItem( l_nIndex, "doc_column_name", l_cNewCol )
							THIS.SetItem( l_nIndex, "doc_field_order", l_nNewSequence )
						END IF
					END IF
				END IF
			NEXT
			
			//Just call the PowerBuilder DeleteRow function as there are no child datawindows to clean up
			//  and don't want to pass through this event again.
			l_nRV = THIS.DeleteRow( THIS.i_CursorRow )
			
			IF l_nRV <> 1 THEN
				MessageBox( gs_AppName, "Failed to delete the selected row", StopSign!, OK! )
			END IF
		END IF
		
		//Return to the calling code as don't want to execute the ancestor script
		RETURN
	END IF					

	//------------------------------------------------------------------
	//
	//		IF everything is ok (0) then call the ancestor script to delete
	//		the row.
	//
	//-------------------------------------------------------------------

	call super::pcd_delete
END IF


end event

event pcd_new;call super::pcd_new;//*********************************************************************************************
//
//	 Event:   pcd_new
//	 Purpose: To insert a new record into the specified Table
//			
//	 Date     Developer   Description
//	 -------- ----------- ---------------------------------------------------------------------
//	 07/20/99  M. Caruso  initialize the source_type and column_name columns on d_tm_field_defs
//	 07/22/99  M. Caruso  Remove initialization of column_name on d_tm_field_defs.
//	 08/13/99  M. Caruso  Handles d_tm_provider_types for maintaining provider_types table.
//	 10/20/99  M. Caruso  Altered initialization of new Field Definition records.  Also removed 
//                       line to reset row status to NotModified!
//	 03/15/00  M. Caruso  Sets source name field default value when creating a record in 
//                       d_tm_datasources.
//	 03/27/00  M. Caruso  Code table now saved in instance variable i_cCodeTable and is loaded 
//                       using fu_definecodetable ().
//  05/31/00 C. Jackson  Set active flag to Y as default for Provider Types (SCR 645)
//  06/01/00 C. Jackson  Set format id to General as default for Field Definitions (SCR 647)
//  06/23/00 C. Jackson  Commented out the above, this shouldn't be hard-coded.  
//  06/23/00 C. Jackson  Set active flag to Y to Resolution Codes
//  07/31/00 C. Jackson  Set active flag to Y for Document Types
//  08/17/00 C. Jackson  Moved the setting of the Active flag to Y out of the main Choose Case
//  09/14/00 C. Jackson  Add d_tm_user_dept
//  10/26/00 M. Caruso   Added case for the new Appeal Levels module.
//  11/20/00 C. Jackson  Added special_flags
//  11/28/00 M. Caruso   Added code to set default values for new case note types.
//  3/20/2001 K. Claver  Added event calls to default values for the field definitions and case
//								 properties field definitions.
//  8/17/2004 K. Claver  Added code to set default values for the case attachment types
//*********************************************************************************************


STRING	l_cUpdatedBy, l_cCurrSourceType, l_cCurrCaseType
DATETIME l_dtTimestamp
LONG		l_UniqueSeq, ll_rowcount

//-------------------------------------------------------------------
//		Set the KeyID equal to one more than the instance variable
//-------------------------------------------------------------------

l_UniqueSeq = i_nMaxValue + 1

//-------------------------------------------------------------------
//		Determine which datawindow we are working with and then get the
//		keyvalue from the appropriate means.
//-------------------------------------------------------------------
CHOOSE CASE DataObject
		
	CASE 'd_tm_confidentiality_levels' 

		//		This datawindows expect an numeric key
		SetItem(i_CursorRow,  i_wParentWindow.i_cKeyColumnName, l_UniqueSeq)

	CASE 'd_tm_cusfocus_users'
		SetItem(i_CursorRow, 'out_of_office_bmp', 'person.bmp')
		SetItem(i_CursorRow, 'active', 'Y')

	CASE 'd_tm_field_defs'
		//		Set the key value, the default source_type, column_name, and format type
		SetItem(i_CursorRow, i_wParentWindow.i_cKeyColumnName, STRING(l_UniqueSeq))
		SetItem(i_CursorRow, 'source_type', 'C')

		//		Initialize the code table for column_name
		fu_definecodetable ('C')
							
		SetItem (i_CursorRow, "column_name", "")
		THIS.Modify("column_name.Values='" + i_cCodeTable + "'")
		
		//Set the defaults for the datawindow
		l_cCurrSourceType = THIS.Object.source_type[ i_CursorRow ]
		THIS.Event Trigger ue_deffielddef( l_cCurrSourceType, i_CursorRow )
		
		//Default the format
		THIS.Object.format_id[ i_CursorRow ] = "1"
		
	CASE "d_tm_case_prop_field_defs"
		//Add in the key
		SetItem(i_CursorRow, i_wParentWindow.i_cKeyColumnName, STRING(l_UniqueSeq))
		
		//Default the source type and case type
		THIS.Object.source_type[ i_CursorRow ] = i_wParentWindow.i_cSourceConsumer
		THIS.Object.case_type[ i_CursorRow ] = i_wParentWindow.i_cInquiry
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 6.15.2005
//-----------------------------------------------------------------------------------------------------------------------------------
		This.Object.locked[ i_CursorRow ] = 'N'
		This.Object.required[ i_CursorRow ] = 'N'
		This.Object.visible[ i_CursorRow ] = 'Y'
		
		//Set the defaults for the datawindow
		THIS.Event Trigger ue_defcpfielddef( i_wParentWindow.i_cSourceConsumer, i_wParentWindow.i_cInquiry, i_CursorRow )
		
		//Default the format
		THIS.Object.format_id[ i_CursorRow ] = "1"
		
	CASE "d_tm_datasources"

		SetItem(i_CursorRow, i_wParentWindow.i_cKeyColumnName, l_UniqueSeq)
		SetItem(i_CursorRow, 'iim_source_name', '(New Data Source)')
		SetItem(i_CursorRow, 'iim_source_active', 'Y')
		
	CASE "d_tm_case_note_types"
		SetItem(i_CursorRow, i_wParentWindow.i_cKeyColumnName, STRING(l_UniqueSeq))
		SetItem(i_CursorRow, 'external', 'N')
		SetItem(i_CursorRow, 'active', 'Y')
		
	CASE "d_tm_appeal_levels"
		SetItem(i_CursorRow, i_wParentWindow.i_cKeyColumnName, l_UniqueSeq)
		SetItem(i_CursorRow, 'active', 'Y')
		
	CASE "d_case_transfer_codes"
		SetItem( i_CursorRow, "active", "Y" )	
	
	CASE "d_tm_doc_fields"
		//Add in the key
		SetItem(i_CursorRow, i_wParentWindow.i_cKeyColumnName, STRING(l_UniqueSeq))
		//Default the format
		THIS.Object.doc_format_id[ i_CursorRow ] = "1"
		
	CASE "d_tm_attachment_types"
		SetItem( i_CursorRow, "type_active", "Y" )	
	
	Case 'd_tm_contacthistory_fields'
		Return 1
	
	Case 'd_tm_dateterm_name'
		
	Case 'd_tm_dateexclusion'
		
	Case 'd_tm_appealtype_event_defaults'
		ll_rowcount = this.Rowcount()
		IF ll_rowcount > i_CursorRow THEN
			THIS.Object.line_of_business_id[ i_CursorRow ] = THIS.Object.line_of_business_id[ i_CursorRow + 1 ]
			THIS.Object.appealtypeid_all[ i_CursorRow ] = THIS.Object.appealtypeid_all[ i_CursorRow + 1 ]
			THIS.Object.service_type_id_all[ i_CursorRow ] = THIS.Object.service_type_id_all[ i_CursorRow + 1 ]
			THIS.Object.datetermid[ i_CursorRow ] = THIS.Object.datetermid[ i_CursorRow + 1 ]
		END IF
	
	CASE "d_tm_case_prop_values"
		//SetItem(i_CursorRow, 'active', 'Y')

	CASE "d_tm_appealpropertiesvalues"
		//SetItem(i_CursorRow, 'active', 'Y')
		
	Case "d_tm_appeal_event"
		
	Case "d_tm_appeal_outcome"
		
	Case "d_tm_appeal_type"	
		
	Case "d_tm_appealstatus"
		
	Case "d_tm_bcbsvt_setup"

	Case "d_tm_appeal_prop_field_defs"
	long ll_ID	
	n_update_tools ln_update_tools
	ln_update_tools = create n_update_tools
	ll_ID = ln_update_tools.of_get_key('appeal_prop_field_defs')
	destroy ln_update_tools
		
//		Declare	lsp_getkey	PROCEDURE FOR sp_getkey
//					@vc_TbleNme = 'appeal_prop_field_defs',
//					@i_Ky = :ll_ID OUTPUT;
//	
//		Execute	lsp_getkey;
//	
//		Fetch		lsp_getkey into :ll_ID;
//	
//		Close 	lsp_getkey;
		
		
		l_UniqueSeq = ll_ID
		//Add in the key
		SetItem(i_CursorRow, i_wParentWindow.i_cKeyColumnName, STRING(l_UniqueSeq))
		
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 6.15.2005
//-----------------------------------------------------------------------------------------------------------------------------------
		This.Object.locked[ i_CursorRow ] = 'N'
		This.Object.required[ i_CursorRow ] = 'N'
		This.Object.visible[ i_CursorRow ] = 'Y'
		This.Object.format_ID[ i_CursorRow ] = '1'

	CASE ELSE
		//		Everything else is expecting a varchar(10)
		SetItem(i_CursorRow, i_wParentWindow.i_cKeyColumnName, STRING(l_UniqueSeq))

END CHOOSE

// Set the record Active by default
CHOOSE CASE DataObject
	CASE 'd_tm_resolution_codes', 'd_tm_doc_types', 'd_tm_provider_types', 'd_tm_user_dept', 'd_tm_special_flags', &
		'd_tm_doc_status', 'd_tm_cus_sat_codes', 'd_tm_other_close_codes'
		SetItem(i_CursorRow, 'active', 'Y')
END CHOOSE


//-------------------------------------------------------------------
//			Set the Updated By from user name, get a timestamp for
//			from the standards layer window, and set the status of the 
//			row to New! so the user will not be prompted if they close
//			the window or click on the Table List Tab.
//-------------------------------------------------------------------

CHOOSE CASE DataObject
	CASE "d_tm_attachment_types"
		SetItem(i_CursorRow, 'type_updated_by', OBJCA.WIN.fu_GetLogin(SQLCA))
		l_dtTimeStamp = i_wParentWindow.fw_GetTimeStamp()
		SetItem(i_CursorRow, 'type_updated_date', l_dtTimeStamp)
	CASE ELSE
		SetItem(i_CursorRow, 'updated_by', OBJCA.WIN.fu_GetLogin(SQLCA))
		l_dtTimeStamp = i_wParentWindow.fw_GetTimeStamp()
		SetItem(i_CursorRow, 'updated_timestamp', l_dtTimeStamp)
END CHOOSE

SetItemStatus(i_CursorRow, 0, PRIMARY!, NotModified!) 


end event

event pcd_setoptions;call super::pcd_setoptions;//********************************************************************
//
//			Event:	pcd_setoptions
//			Purpose:	To set the options for the Table Maintenance 
//						Datawindow
//
//  12/6/2000  K. Claver   Added constant c_SortClickedOK for header
//									click sorting
//
//*********************************************************************/

CHOOSE CASE DataObject 
	CASE "d_tm_doc_admin"
		fu_SetOptions( SQLCA, & 
			c_NullDW, & 
			c_SelectOnRowFocusChange + &
			c_NewOK + &
			c_ModifyOK + &
			c_DeleteOK + &
			c_NoEnablePopup + &
			c_ModifyOnSelect + &
			c_NoRetrieveOnOpen + &
			c_TabularFormStyle + &
			c_NoInactiveRowPointer + &
			c_ShowHighlight + &
			c_NoActiveRowPointer + &
			c_SortClickedOK ) 
	
	CASE ELSE		
		fu_SetOptions( SQLCA, & 
			c_NullDW, & 
			c_SelectOnRowFocusChange + &
			c_NewOK + &
			c_ModifyOK + &
			c_DeleteOK + &
			c_NoEnablePopup + &
			c_ModifyOnSelect + &
			c_NoRetrieveOnOpen + &
			c_TabularFormStyle + &
			c_NoInactiveRowPointer + &
			c_ShowHighlight + &
			c_SortClickedOK ) 
	
END CHOOSE
end event

event itemchanged;call super::itemchanged;//*****************************************************************************************
//	 Event:	 itemchanged
//	 Purpose: Valid data for the column_name and field_order columns of the
//	          field_definitions table.
//				
//	 Date     Developer     Description
//	 -------- ------------- -----------------------------------------------------------------
//	 7/20/99  M. Caruso     Created.
//	 7/22/99  M. Caruso     Remove initialization of column_name if source_type changes.
//	 7/23/99  M. Caruso	   Added validation of field_length.
//	 03/22/00 C. Jackson    Added validation for document fields
//	 3/27/00  M. Caruso     Code table now saved in instance variable i_cCodeTable
//  03/29/00 C. Jackson    Added length validation logic for doc_field_length
//  04/05/00 C. Jackson    Correct logic for not allowing duplicate column names in 
//                         document_fields
//  06/23/00 C. Jackson    For resolution codes, convert all values to UPPER before comparison
//                         to make the uniqueness 'constraint' case insensitive (SCR 681)
//  07/05/00 C. Jackson    Add unique constraint on Customer Satisfaction Code (SCR 699)
//  09/14/00 C. Jackson    Add unique constraint on User Department
//  10/05/00 K. Claver     Added code for the Case Transfer Code table
//	 12/21/00 K. Claver     Added code for the Case Properties Field Definitions table
//  03/19/01 C. Jackson    Add code to handle the marking of users inactive (SCR 1489)
//  03/20/01 K. Claver     Added code to default values for the case properties field definitions
//  								and the field definitions tables.
//  04/17/00 C. Jackson    Check to see if a provider type is being used in the case_log
//                         table.  If so, don't let the user change it (SCR 1620)
//  04/23/01 C. Jackson    Add other_close_codes
//  05/01/01 C. Jackson    Add logic to prevent user from marking all Resolution Codes and
//                         Other Close Codes for one case type Inactive if that Code is 
//                         required for the Case Type.  (SCR 2035)
//  8/22/2001 K. Claver    Added code to check for a unique provider type description.  Coded
//									to accomodate for a bug in the drop down datawindow in PB 7.0.2.
//  08/27/01 C. Jackson    Corrected the column name in the SELECT from the above code to select
//                         the xref_provider_type,  is an obsolete column in 4.2
//                         (SCR 1620 and 2373).  
//  11/15/01 M. Caruso     Reversed changes made on 10/17/01.
//  11/28/01 C. Jackson    Add Logic to prevent user from changing a Document Type if the
//                         column already exists for a different document type.
//  11/30/01 C. Jackson    Add validation for Field Length and Field Order to Case
//                         Properties Field Definitions (SCR 2388)
//  12/17/01 C. Jackson    In check for uniqueness, verify that we are not looking at the
//                         same row that we just entered.  (SCR 2595)
//  12/18/01 C. Jackson    For Provider Types, check to see if an error was already presented
//                         to the user, if so, return 1 (SCR 2465)
//  01/29/02 C. Jackson    Prevent user from entering duplicate Other Close Codes (SCR 2685)
//  02/11/02 C. Jackson    Prevent user from changing the Case Type on an Other Close Code
//                         to create a duplicate
//	 2/19/2002 K. Claver    Moved checking for unique transfer codes to the pcd_validaterow event.
//  2/28/2002 K. Claver    Moved checking for unique customer sat codes to the pcd_validaterow event.
//	 6/5/2002 K. Claver     Added code to re-sequence a prior doc types fields to prevent gaps if the user
//									changed to a different doc type.
//*****************************************************************************************

LONG		l_nIndex, l_nRowCount, l_nRow, l_nFormatLength, l_nFieldLength, l_nDocMatches, l_nFieldOrder
LONG     l_nDocOrder, l_nColNameLength, l_nCountOpen, l_nCountRFC, l_nRouteCount, l_nPos, l_nRecordCount
INTEGER	l_nColIndex, l_nColCount, l_nMaxFieldOrd, l_nThisFieldOrd, l_nddlbItem, l_nRV
INTEGER  l_nMaxVal, l_nColNum, l_nCurrColSequence, l_nColSequence, l_nNewSequence
BOOLEAN	l_bContinue, l_bActive
STRING	l_cNew, l_cExisting, l_cColName, l_cFormatID, l_cCurrentColumnName, l_DocType, l_cSourceType
STRING	l_cGetColName, l_cCurrentDocTypeID, l_cGetDocTypeID, l_cGetColumnName, l_cText, l_cCaseType, l_cResCode
STRING 	l_cCodeDesc, l_cCode, l_cCurrentFlagKey, l_cVisible, l_cLocked, l_cRequired, l_cUserID
STRING   l_cCurrSourceType, l_cRowSourceType, l_cRowCaseType, l_cOldProviderType, l_cActive, l_cCaseTypeDesc
STRING   l_cColumnName, l_cDoctypeID, l_cDocTypeDesc, l_cCloseCode, l_cVal, l_cNewCol, ls_searchable, ls_dropdown
DATASTORE	l_dsColumns
DATAWINDOWCHILD ldwc_appeal_type, ldwc_service_type
LONG		ll_return, ll_line_of_business_id
STRING	ls_filter

// only concerned with the field_definitions table
CHOOSE CASE THIS.DataObject
		
	CASE 'd_tm_other_close_codes'
		
		// assume the data value is unique
		l_bContinue = TRUE
	
		CHOOSE CASE dwo.Name
		
			CASE 'other_close_code'
				l_nRow = THIS.GetRow()
				l_nRowCount = THIS.RowCount()
				
				l_cCloseCode = THIS.GetItemString(l_nRow,'other_close_code')
	
				FOR l_nIndex = 1 TO l_nRowCount
					IF UPPER(THIS.GetItemString(l_nIndex,'other_close_code')) = UPPER(data) AND (l_nrow <> l_nIndex) THEN
						// Have a duplicate case type, check to see if it is for the same case type
						IF UPPER(THIS.GetItemString(l_nIndex,'case_type')) = UPPER(THIS.GetItemString(row,'case_type')) THEN
							MessageBox(gs_AppName,'This Other Close Code is already defined for this Case Type.')
							
							THIS.SetItem(l_nRow,'other_close_code',l_cCloseCode)
							l_bContinue = FALSE
							EXIT					
						END IF
						
					END IF
					
				NEXT
			
			CASE 'case_type'
				
				l_nRow = THIS.GetRow()
				l_nRowCount = THIS.RowCount()
				
				l_cCaseType = THIS.GetItemString(l_nRow,'case_type')
				THIS.AcceptText()
	
				FOR l_nIndex = 1 TO l_nRowCount

					IF UPPER(THIS.GetItemString(l_nIndex,'case_type')) = UPPER(data) AND (l_nrow <> l_nIndex) THEN
						// Have a duplicate case type, check to see if it is for the same case type
						IF UPPER(THIS.GetItemString(l_nIndex,'other_close_code')) = UPPER(THIS.GetItemString(row,'other_close_code')) THEN
							
							MessageBox(gs_AppName,'This Other Close Code is already defined for this Case Type.')
							THIS.SetItem(l_nRow,'case_type',l_cCaseType)
							l_bContinue = FALSE
							EXIT					
						END IF
						
					END IF
					
				NEXT

		END CHOOSE
		
		IF l_bContinue THEN
			RETURN 0
		ELSE
			RETURN 1
		END IF

		
	CASE 'd_tm_provider_types'
			
		// assume the data value is unique
		l_bContinue = TRUE

		CHOOSE CASE dwo.Name
		
			CASE 'provider_type'
				
				IF i_nRowFailed <> 0 THEN
					RETURN 1
				END IF
				
				l_nRow = GetRow()
				l_cOldProviderType = GetItemString(l_nRow,'provider_type')
				
				// Provider Type is in Case Log/Cross Reference - it can't be changed
				SELECT COUNT (*) INTO :l_nRecordCount
				  FROM cusfocus.case_log
				 WHERE xref_provider_type = :l_cOldProviderType
				 USING SQLCA;
				 
				IF l_nRecordCount > 0 THEN
					MessageBox(gs_AppName,'Provider type "'+l_cOldProviderType+'" is being cross referenced '+&
					         'in the case log table.  It cannot be changed.')
					THIS.SetItem(l_nRow,'provider_type',l_cOldProviderType)
					THIS.SetItemStatus(l_nRow,'provider_type',Primary!,NotModified!)
					RETURN 1	
				END IF
				
				// Provider Type is in Case Log - it can't be changed
				SELECT COUNT (*) INTO :l_nRecordCount
				  FROM cusfocus.case_log
				 WHERE source_provider_type = :l_cOldProviderType
				 USING SQLCA;
				 
				IF l_nRecordCount > 0 THEN
					MessageBox(gs_AppName,'Provider type "'+l_cOldProviderType+'" is being used in the case log ' + &
								'table.  It cannot be changed.')
					THIS.SetItem(l_nRow,'provider_type',l_cOldProviderType)
					THIS.SetItemStatus(l_nRow,'provider_type',Primary!,NotModified!)
					
					RETURN 1	
				END IF
				
				// Provider Type is in Provider_of_Serviced - it can't be changed
				SELECT COUNT (*) INTO :l_nRecordCount
				  FROM cusfocus.provider_of_service
				 WHERE provider_type = :l_cOldProviderType
				 USING SQLCA;
				 
				IF l_nRecordCount > 0 THEN
					MessageBox(gs_AppName,'Provider type "'+l_cOldProviderType+'" is being used in the '+&
				            'Provider of Service table.  It cannot be changed.')
					THIS.SetItem(l_nRow,'provider_type',l_cOldProviderType)
					THIS.SetItemStatus(l_nRow,'provider_type',Primary!,NotModified!)
					
					RETURN 1	
				END IF

		END CHOOSE
		
		IF l_bContinue THEN
			RETURN 0
		ELSE
			RETURN 1
		END IF
		
	CASE 'd_tm_field_defs'
	
		// assume the data value is unique
		l_bContinue = TRUE
				
		l_nRowCount = THIS.RowCount()
				
		CHOOSE CASE dwo.Name
	//		CASE 'column_name'
	//			// verify that this entry is unique in the table.
	//			FOR l_nIndex = 1 TO l_nRowCount
	//				// If the column names match and the rows are not the same then there's a problem.
	//				IF (data = THIS.GetItemString (l_nIndex, STRING (dwo.name))) AND (row <> l_nIndex) THEN
	//					l_bContinue = FALSE
	//					MessageBox (gs_AppName, "The value for this column must be unique.~r~n" + &
	//					                             "Please correct this value to continue.")
	//					EXIT
	//				END IF
	//			NEXT
				
			CASE 'field_order'
				// verify that this value is unique in this table for the given source.
				l_nColCount = INTEGER (THIS.Object.Datawindow.Column.Count)
				// get the column ID for column_name
				FOR l_nColIndex = 1 to l_nColCount
					l_cColName = THIS.Describe ('#'+STRING (l_nColIndex)+'.Name')
					IF l_cColName = 'source_type' THEN
						EXIT
					END IF
				NEXT
	
				FOR l_nIndex = 1 TO l_nRowCount
					IF data = STRING (THIS.GetItemNumber (l_nIndex, STRING (dwo.name))) THEN
						// gather the table names for the new entry and the row being compared against.
						l_cNew = THIS.GetItemString (row, l_nColIndex)
						l_cExisting = THIS.GetItemString (l_nIndex, l_nColIndex)
						
						// if the table names are the same and the rows are different, there's a problem.
						IF (l_cNew = l_cExisting) AND (row <> l_nIndex) THEN
							l_bContinue = FALSE
							MessageBox (gs_AppName, "The value for this column must be unique for a given~r~n" + &
																  "Source Type. Please correct this value to continue.")
																  
							EXIT
						END IF
					END IF
				NEXT
				
			CASE 'field_length'
				IF (INTEGER (data) < 1) OR (INTEGER (data) > 50) THEN
					MessageBox (gs_AppName, "The field length must be between 1 and 50.")
					l_bContinue = FALSE
				END IF
				
			CASE 'source_type'
				// update the code table for column_name
				fu_definecodetable (data)
				
				SetItem (row, "column_name", "")
				THIS.Modify("column_name.Values='" + i_cCodeTable + "'")
				
				//Set the defaults for the row
				THIS.Event Trigger ue_deffielddef( data, row )
				
			CASE 'searchable'
				//Check if the visible checkbox is checked
				IF data = "Y" THEN
					l_cVal = Trim( THIS.GetItemString( row, "visible" ) )
					IF l_cVal = "N" OR IsNull( l_cVal ) OR l_cVal = "" THEN
						l_nRV = MessageBox( gs_AppName, "This field is not set as visible so will not show on the~r~n"+ &
												  "demographics tab.  Are you sure you want to set it to~r~n"+ &
												  "searchable?", Question!, YesNo! )
						IF l_nRV = 2 THEN
							RETURN 2
						END IF
					END IF
				END IF
				
			CASE 'visible'
				//Check if the searchable checkbox is checked
				IF data = "N" THEN
					l_cVal = Trim( THIS.GetItemString( row, "searchable" ) )
					IF l_cVal = "Y" AND NOT IsNull( l_cVal ) THEN
						l_nRV = MessageBox( gs_AppName, "Setting this field to not visible will remove it from the~r~n"+ &
												  "demographics tab.  However, leaving it as searchable will~r~n"+ &
												  "allow the user to search on it in the search tab.  Are you~r~n"+ &
												  "sure you want to set it to not visible?", Question!, YesNo! )
												  
						IF l_nRV = 2 THEN
							RETURN 2
						END IF
					END IF
				END IF
				
		END CHOOSE
		
		IF l_bContinue THEN
			RETURN 0
		ELSE
			RETURN 1
		END IF
	
	CASE 'd_tm_special_flags'
		// the flag key must be unique
		CHOOSE CASE dwo.Name
			CASE 'flag_key'
		
				// Set Sort Order based on Field title selected
				l_nRow = GetRow()
	
				l_nRowCount = THIS.RowCount()
				
				// loop through the rows in the datawindow to verify that this is a good column name
				FOR l_nIndex = 1 TO l_nRowCount
					
					IF THIS.GetItemString(l_nIndex,'flag_key') = data THEN
						
						// Get the Doc_Type_ID that was just entered
						l_cCurrentFlagKey = THIS.GetItemString(row,'flag_key')
	
							Messagebox(gs_AppName,'The value for this column must be unique for a given~r~n' +&
											'Special Flag Key.  Please correct this value to continue.')
	
							THIS.SetItem(l_nRow,'flag_key',THIS.Object.flag_key)
							RETURN 1
								
							l_bContinue = FALSE
							EXIT
					END IF
					
				NEXT
			
		END CHOOSE

	
	CASE 'd_tm_doc_fields'
		
		// assume the data value is unique
		l_bContinue = TRUE
	
		CHOOSE CASE dwo.Name
			CASE 'doc_type_id'
				l_nRow = THIS.GetRow()
				l_nRowCount = THIS.RowCount()
				l_cColumnName = THIS.GetItemString(l_nRow,'doc_column_name')
				
				l_cDocTypeID = THIS.GetItemString(l_nRow,'doc_type_id')
	
				FOR l_nIndex = 1 TO l_nRowCount
					IF THIS.GetItemString(l_nIndex,'doc_type_id') = data AND (l_nrow <> l_nIndex) THEN
						IF THIS.GetItemString(l_nIndex,'doc_column_name') = l_cColumnName THEN
							
							// Retrieve values for MessageBox
							SELECT doc_type_desc INTO :l_cDocTypeDesc
							  FROM cusfocus.document_types
							 WHERE doc_type_id = :data
							 USING SQLCA;
							 
							// Grab description from ddlb for this Column Name
							l_cColumnName = this.GetItemString(l_nIndex,'doc_column_name')
							l_nddlbItem = LONG(MID(l_cColumnName,12,2))
							l_cColumnName = THIS.GetValue('doc_column_name',l_nddlbItem)
							l_nPos = POS(l_cColumnName,'~t')
							
							l_cColumnName = MID(l_cColumnName,1,l_nPos - 1)
							 
							messagebox(gs_AppName,"'" +l_cColumnName+ "' is already defined for Document Type '"+l_cDocTypeDesc+"'.")
							THIS.SetItem(l_nRow,'doc_type_id',l_cDocTypeID)
							l_bContinue = FALSE
							EXIT					
						END IF					
					END IF			
				NEXT
				
				//Auto set the next field value for the document
				FOR l_nIndex = 1 TO l_nRowCount
					IF THIS.Object.doc_type_id[ l_nIndex ] = data AND l_nIndex <> l_nRow THEN
						l_nColNum = Integer( Mid( THIS.GetItemString( l_nIndex, 'doc_column_name' ), 12, 2 ) )
						IF l_nColNum > l_nMaxVal THEN
							l_nMaxVal = l_nColNum
						END IF
					END IF
				NEXT
				
				IF l_nMaxVal = 0 THEN
					l_nMaxVal = 1
				ELSE
					l_nMaxVal ++
					
					IF l_nMaxVal > 10 THEN
						MessageBox( gs_AppName, "The maximum number of fields available for a document type is 10.~r~n"+ &
										"Please choose a document type with available fields", StopSign!, OK! )
						l_bContinue = FALSE
					END IF
				END IF
				
				IF l_bContinue THEN
					THIS.Object.doc_column_name[ l_nRow ] = ( "doc_config_"+String( l_nMaxVal ) )
					THIS.Object.doc_field_order[ l_nRow ] = l_nMaxVal
					
					//Check that the old doc type is re-sequenced as the new type could have caused a gap
					l_nCurrColSequence = Integer( Mid( THIS.GetItemString( l_nRow, "doc_column_name" ), 12 ) )
					FOR l_nIndex = 1 TO THIS.RowCount( )
						IF l_nIndex <> l_nRow THEN
							IF THIS.GetItemString( l_nIndex, "doc_type_id" ) = l_cDocTypeID THEN
								//Get the sequence.  If greater, decrement by one
								l_nColSequence = Integer( Mid( THIS.GetItemString( l_nIndex, "doc_column_name" ), 12 ) )
								IF l_nColSequence > l_nCurrColSequence THEN
									l_nNewSequence = ( l_nColSequence - 1 )
									l_cNewCol = ( "doc_config_"+String( l_nNewSequence ) )
									THIS.SetItem( l_nIndex, "doc_column_name", l_cNewCol )
									THIS.SetItem( l_nIndex, "doc_field_order", l_nNewSequence )
								END IF
							END IF
						END IF
					NEXT
				END IF
			
			CASE 'doc_column_name'
				
				// Set Sort Order based on Field title selected
				l_nColNameLength = LEN(data)
				IF l_nColNameLength = 13 THEN
					l_nDocOrder = LONG(MID(data,12,2))
				ELSE
					l_nDocOrder = LONG(MID(data,12,1))
				END IF
	
				l_nRow = GetRow()
	
				l_nRowCount = THIS.RowCount()
				
				// loop through the rows in the datawindow to verify that this is a good column name
				FOR l_nIndex = 1 TO l_nRowCount
					
					IF THIS.GetItemString(l_nIndex,'doc_column_name') = data THEN
						
						// Get the Doc_Type_ID that was just entered
						l_cCurrentDocTypeID = THIS.GetItemString(row,'doc_type_id')
	
						IF THIS.GetItemString(l_nIndex,'doc_type_id') = l_cCurrentDocTypeID THEN
							Messagebox(gs_AppName,'The value for this column must be unique for a given~r~n' +&
											'Document Type.  Please correct this value to continue.')
											
						THIS.SetItem(l_nRow,'doc_column_name',THIS.Object.doc_column_name)
						
							l_bContinue = FALSE
							EXIT
						END IF
					END IF				
				NEXT
				
				THIS.SetItem(l_nRow,'doc_field_order',l_nDocOrder)
				
			CASE 'doc_field_length'
				IF (INTEGER (data) < 1) OR (INTEGER (data) > 30) THEN
					MessageBox (gs_AppName, "The field length must be between 1 and 30.")
					RETURN 1
				END IF
				
		
		END CHOOSE
	
		IF l_bContinue THEN
			RETURN 0
		ELSE
			RETURN 1
		END IF
	
	CASE 'd_tm_resolution_codes'
		
		// assume the data value is unique
		l_bContinue = TRUE
	
		CHOOSE CASE dwo.Name
		
			CASE 'resolution_code'
				
				l_nRow = GetRow()
	
				l_nRowCount = THIS.RowCount()
				
				// loop through the rows in the datawindow to verify that this is a valid resolution code
				FOR l_nIndex = 1 TO l_nRowCount
					
					IF UPPER(THIS.GetItemString(l_nIndex,'resolution_code')) = UPPER(data) AND (row <> l_nIndex) THEN
						
						// Get the Case Type that was just entered
						l_cCaseType = UPPER(THIS.GetItemString(row,'case_type'))
	
						IF UPPER(THIS.GetItemString(l_nIndex,'case_type')) = l_cCaseType THEN
							Messagebox(gs_AppName,'The value for this column must be unique for a given~r~n' +&
											'Case Type.  Please correct this value to continue.')
											
						THIS.SetItem(l_nRow,'resolution_code',THIS.Object.resolution_code)
						
							l_bContinue = FALSE
							EXIT
						END IF
					END IF
					
				NEXT
				
			CASE 'active'
				
				l_bActive = FALSE
				
				l_nRow = GetRow()
				
				l_nRowCount = THIS.RowCount()
				
				l_cRowCaseType = GetItemString(l_nRow,'case_type')
				
				SELECT case_type_desc, res_code_req INTO :l_cCaseTypeDesc, :l_cRequired
				  FROM cusfocus.case_types
				 WHERE case_type = :l_cRowCaseType
				 USING SQLCA;
				 
				IF l_cRequired = 'Y' THEN
					
					// Loop through the rows to make sure at least one is marked Active for this case type
					FOR l_nIndex = 1 TO l_nRowCount
						
						IF l_nRow <> l_nIndex THEN
							l_cCaseType = GetItemString(l_nIndex,'case_type')
							
							IF l_cCaseType = l_cRowCaseType THEN
								l_cActive = GetItemString(l_nIndex,'active')
								IF l_cActive = 'Y' THEN
									l_bActive = TRUE
								END IF
							END IF
						END IF
					
					NEXT
					
						IF l_bActive THEN
							RETURN 0
						ELSE
							messagebox(gs_AppName,'This Resolution Code is required for '+l_cCaseTypeDesc+' cases.  ' + &
														  'At least one Resolution Code must be active for this case type.')
							RETURN 1
						END IF
	
					
				END IF
	
				
		END CHOOSE
		
		IF l_bContinue THEN
			RETURN 0
		ELSE
			RETURN 1
		END IF
	
	CASE 'd_tm_other_close_codes'
		
		// assume the data value is unique
		l_bContinue = TRUE
	
		CHOOSE CASE dwo.Name
		
			CASE 'other_close_code'
				
				l_nRow = GetRow()
	
				l_nRowCount = THIS.RowCount()
				
				// loop through the rows in the datawindow to verify that this is a valid other_close code
				FOR l_nIndex = 1 TO l_nRowCount
					
					IF UPPER(THIS.GetItemString(l_nIndex,'other_close_code')) = UPPER(data) AND (row <> l_nIndex) THEN
						
						// Get the Case Type that was just entered
						l_cCaseType = UPPER(THIS.GetItemString(row,'case_type'))
	
						IF UPPER(THIS.GetItemString(l_nIndex,'case_type')) = l_cCaseType THEN
							Messagebox(gs_AppName,'The value for this column must be unique for a given~r~n' +&
											'Case Type.  Please correct this value to continue.')
											
						THIS.SetItem(l_nRow,'other_close_code',THIS.Object.other_close_code)
						
							l_bContinue = FALSE
							EXIT
						END IF
					END IF
					
				NEXT
				
			CASE 'active'
				
				l_bActive = FALSE
				
				l_nRow = GetRow()
				
				l_nRowCount = THIS.RowCount()
				
				l_cRowCaseType = GetItemString(l_nRow,'case_type')
				
				SELECT case_type_desc, other_close_code_req INTO :l_cCaseTypeDesc, :l_cRequired
				  FROM cusfocus.case_types
				 WHERE case_type = :l_cRowCaseType
				 USING SQLCA;
				
				IF l_cRequired = 'Y' THEN
					
					// Loop through the rows to make sure at least one is marked Active for this case type
					FOR l_nIndex = 1 TO l_nRowCount
						
						IF l_nRow <> l_nIndex THEN
							l_cCaseType = GetItemString(l_nIndex,'case_type')
							
							IF l_cCaseType = l_cRowCaseType THEN
								l_cActive = GetItemString(l_nIndex,'active')
								IF l_cActive = 'Y' THEN
									l_bActive = TRUE
								END IF
							END IF
						END IF
					
					NEXT
					
						IF l_bActive THEN
							RETURN 0
						ELSE
							messagebox(gs_AppName,'This Other Close Code is required for '+l_cCaseTypeDesc+' cases.  ' + &
														  'At least one Other Close Code must be active for this case type.')
							RETURN 1
						END IF
	
					
				END IF
				
				
		END CHOOSE
		
		IF l_bContinue THEN
			RETURN 0
		ELSE
			RETURN 1
		END IF
	
//CASE 'd_tm_cus_sat_codes'
//		
//	// assume the data value is going to be unique
//	l_bContinue = TRUE
//
//	CHOOSE CASE dwo.Name
//	
//		CASE 'customer_sat_code'
//			
//			l_nRow = GetRow()
//
//			l_nRowCount = THIS.RowCount()
//			
//			// loop through the rows in the datawindow to verify that this is a valid customer satisfaction code
//			FOR l_nIndex = 1 TO l_nRowCount
//				IF UPPER(THIS.GetItemString(l_nIndex,'customer_sat_code')) = UPPER(data) AND (row <> l_nIndex) THEN
//					
//					Messagebox(gs_AppName,'The value for this column must be unique.~r~n' +&
//										'Please correct this value to continue.')
//										
//					l_bContinue = FALSE
//						EXIT
//				END IF
//				
//			NEXT
//			
//	END CHOOSE
//	
//	IF l_bContinue THEN
//		RETURN 0
//	ELSE
//		RETURN 1
//	END IF
//		

	CASE 'd_tm_user_dept'

		// assume the data value is unique
		l_bContinue = TRUE
	
		CHOOSE CASE dwo.Name
		
			CASE 'dept_desc'
				
				l_nRow = GetRow()
	
				l_nRowCount = THIS.RowCount()
				
				// loop through the rows in the datawindow to verify that this is a valid Department
				FOR l_nIndex = 1 TO l_nRowCount
					
					IF UPPER(THIS.GetItemString(l_nIndex,'dept_desc')) = UPPER(data) AND (row <> l_nIndex) THEN
						Messagebox(gs_AppName,'The value for this column must be unique.~r~n' +&
								'Please correct this value to continue.')
											
						THIS.SetItem(l_nRow,'dept_desc',THIS.Object.dept_desc)
						
							l_bContinue = FALSE
							EXIT
						END IF
					
				NEXT
	
		END CHOOSE
		
		IF l_bContinue THEN
			RETURN 0
		ELSE
			RETURN 1
		END IF
	
	
	CASE "d_tm_case_prop_field_defs"
		CHOOSE CASE dwo.Name 
			CASE "locked" 
				IF data = "Y" THEN
					l_cVisible = THIS.Object.visible[ row ]
					l_cRequired = THIS.Object.required[ row ]
					IF IsNull( l_cVisible ) OR l_cVisible = "N" THEN
						MessageBox( gs_AppName, "Nonvisual fields cannot be locked" )
						RETURN 1
					ELSEIF l_cRequired = "Y" THEN
						MessageBox( gs_AppName, "Required fields cannot be locked" )
						RETURN 1
					END IF
				END IF
			CASE "visible"
				IF IsNull( data ) OR data = "N" THEN
					l_cLocked = THIS.Object.locked[ row ]
					l_cRequired = THIS.Object.required[ row ]
					ls_searchable = This.Object.searchable_contacthistory[ row ]
					ls_dropdown = This.Object.case_properties_field_def_dropdown [ row ]
					IF l_cLocked = "Y" THEN
						MessageBox( gs_AppName, "Locked fields cannot be nonvisual" )
						RETURN 1
					ELSEIF l_cRequired = "Y" THEN
						MessageBox( gs_AppName, "Required fields cannot be nonvisual" )
						RETURN 1
					ELSEIF ls_searchable = "Y" THEN
						MessageBox( gs_AppName, "Searchable fields cannot be nonvisual" )
						RETURN 1
					ELSEIF ls_dropdown = "Y" THEN
						MessageBox( gs_AppName, "Fields with drop downs cannot be nonvisual" )
						RETURN 1
					END IF
				END IF
			Case "searchable_contacthistory"
				IF IsNull( data ) OR data = "Y" THEN
					l_cVisible = THIS.Object.visible[ row ]
					IF l_cVisible = "N" THEN
						MessageBox( gs_AppName, "Searchable fields cannot be nonvisual" )
						RETURN 1
					END IF
				End If
			CASE "required"
				IF data = "Y" THEN
					l_cVisible = THIS.Object.visible[ row ]
					l_cLocked = THIS.Object.locked[ row ]
					IF IsNull( l_cVisible ) OR l_cVisible = "N" THEN
						MessageBox( gs_AppName, "Nonvisual fields cannot be required" )
						RETURN 1
					ELSEIF l_cLocked = "Y" THEN
						MessageBox( gs_AppName, "Locked fields cannot be required" )
						RETURN 1
					END IF
				END IF
			CASE "field_order"
				IF Not IsNumber(data) THEN
					MessageBox( gs_AppName, "Field order must be numeric")
					RETURN 1
				END IF
			CASE "field_length"
				IF Not IsNumber(data) THEN
					MessageBox( gs_AppName, "Field length must be numeric")
					RETURN 1
				END IF
				
				IF Long( data ) > 50 THEN
					MessageBox( gs_AppName, "Field length cannot exceed 50" )
					RETURN 1
				END IF
				
			CASE "source_type"
				l_cRowCaseType = THIS.Object.case_type[ row ]
				THIS.Event Trigger ue_defcpfielddef( data, l_cRowCaseType, row )
				
			CASE "case_type"
				l_cRowSourceType = THIS.Object.source_type[ row ]
				THIS.Event Trigger ue_defcpfielddef( l_cRowSourceType, data, row )
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite	Added 6.14.2005
//
//	Check if the ItemChanging is the drop down checkbox. If so, mark the boolean variable to tell you its changed
//	so you can delete the saved syntax. Also check the values for visible and required to make sure they are logical.
//-----------------------------------------------------------------------------------------------------------------------------------
			CASE "case_properties_field_def_dropdown" 
				ib_dropdowns_changed = TRUE

				IF data = "Y" THEN
					l_nRow = GetRow()

					string ls_formatID
						
					  SELECT cusfocus.display_formats.format_id  
					 INTO :ls_formatID  
					 FROM cusfocus.display_formats  
					WHERE cusfocus.display_formats.format_name = 'Drop Downs'   
							  ;

					If Not IsNull(ls_formatID) And ls_formatID <> '' Then
						this.object.format_id[ l_nRow] = ls_formatID
					End If

					l_cVisible = THIS.Object.visible[ l_nRow  ]
					l_cLocked = THIS.Object.locked[ row ]
					IF IsNull( l_cVisible ) OR l_cVisible = "N" THEN
						MessageBox( gs_AppName, "Drop down fields cannot be non-visible." )
						RETURN 1
					ELSEIF l_cLocked = "Y"  THEN
						MessageBox( gs_AppName, "Drop down fields cannot be locked." )
						RETURN 1
					END IF
				END IF
	
				
		END CHOOSE
	
	CASE 'd_tm_cusfocus_users'
		CHOOSE CASE dwo.Name
			CASE 'active'	
				
				IF data = 'N' THEN
					
					l_nRow = THIS.GetRow()
					l_cUserID = THIS.GetItemString(l_nRow,'user_id')
					
					// SysAdmin cannot be marked inactive
					IF UPPER(l_cUserID) = 'CFADMIN' THEN
//					9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//					IF UPPER(l_cUserID) = 'SYSADMIN' THEN
						MessageBox(gs_AppName,'System Administrator cannot be marked inactive.')
						RETURN 1
						
					ELSE
					
						// Check for open cases
						SELECT COUNT(*) INTO :l_nCountOpen
						FROM cusfocus.case_log
						 WHERE case_log_case_rep = :l_cUserID
							AND case_status_id = 'O'
						 USING SQLCA;
						
						// Check for transferred cases set to Return_For_Close
						SELECT COUNT(l.case_number) INTO :l_nCountRFC
						  FROM cusfocus.case_log l, cusfocus.case_transfer t
						 WHERE t.case_number = l.case_number
							AND t.return_for_close = 1
							AND l.case_log_taken_by = :l_cUserID
						 USING SQLCA;
						 
						 IF l_nCountRFC = 0 THEN
							// Check history for transferred cases set to Return_For_Close
							SELECT COUNT(l.case_number) INTO :l_nCountRFC
							  FROM cusfocus.case_log_history l, cusfocus.case_transfer_history t
							 WHERE t.case_number = l.case_number
								AND t.return_for_close = 1
								AND l.case_log_taken_by = :l_cUserID
							 USING SQLCA;
						END IF
						 
						// Check to see if cases are being routed to this user
						 SELECT count(*) INTO :l_nRouteCount
						   FROM cusfocus.out_of_office
						  WHERE assigned_to_user_id = :l_cUserID
						  USING SQLCA;
						 
						IF l_nCountOpen > 0 THEN
							MessageBox (gs_AppName, "There are open cases for this user, please reassign them " + &
														 "before marking this user inactive.")
							RETURN 1
							
						ELSEIF l_ncountRFC > 0 THEN
							MessageBox (gs_AppName, "This user has open cases set to 'Return For Close' and cannot be " + &
															"set as inactive.")
							RETURN 1
							
						ELSEIF l_nRouteCount > 0 THEN
							MessageBox( gs_AppName, "This user is being routed cases.  Remove Routing through " + &
							                        "Supervisor Portal before marking this user inactive.")
							RETURN 1
							
						ELSE
							
							// Check to see if this user is a report owner, if so, set owner to SysAdmin
							fu_checkreports(l_cUserID)						
							
							RETURN 0
							
						END IF													 
						
					END IF

				END IF
	
		END CHOOSE
//----------------------------------------------------------------------
// RAP - added 11/13/2006
//
// drop-down datawindows are dependent upon previous selection
//----------------------------------------------------------------------
	CASE 'd_tm_service_type'

		CHOOSE CASE dwo.Name
		
			CASE 'line_of_business_id'
				GetChild('appealtypeid', ldwc_Appeal_Type)
				ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + data)
				ll_return = ldwc_appeal_type.Filter()
				
		END CHOOSE

	CASE 'd_tm_appealtype_event_defaults'

		CHOOSE CASE dwo.Name
		
			CASE 'line_of_business_id'
				GetChild('appealtypeid', ldwc_Appeal_Type)
				ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + data)
				ll_return = ldwc_appeal_type.Filter()
				
			CASE 'appealtypeid'
				GetChild('service_type_id', ldwc_Service_Type)
				ll_line_of_business_id = THIS.Object.line_of_business_id[row]
				ls_filter = "line_of_business_id = " + String(ll_line_of_business_id) + " and appealtypeid = " + data
				ll_return = ldwc_service_Type.SetFilter(ls_filter)
				ll_return = ldwc_service_type.Filter()
				
		END CHOOSE

END CHOOSE



end event

event itemfocuschanged;call super::itemfocuschanged;//*********************************************************************************************
//
//  Event:   itemfocuschanged
//  Purpose: Set the list of values for drop down list boxes in the datawindow
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  03/27/00 M. Caruso     Created.	
//  04/12/00 M. Caruso     Update other drop down lists using the fu_refreshdddw function
//  04/27/00 C. Jackson    disable m_new and m_delete for d_tm_case_Types (scr 500)
//  11/30/01 c. Jackson    Grab previously entered field order and length
//
//*********************************************************************************************

STRING	l_cValue, l_cSourceType
LONG		l_nRow, ll_line_of_business_id, ll_appeal_type_id, ll_return
DATAWINDOWCHILD	l_dwcChild, ldwc_appeal_type, ldwc_service_type

CHOOSE CASE dw_table_maintenance.dataobject
		
	CASE 'd_tm_case_prop_field_defs'
		CHOOSE CASE dwo.Name
				CASE 'field_length'
					i_nHoldLength = THIS.GetItemNumber(row,'field_length')
					
				CASE 'field_order'
					i_nHoldOrder = THIS.GetItemNumber(row,'field_order')
			END CHOOSE
			
	CASE 'd_tm_doc_fields'
		CHOOSE CASE dwo.Name
			CASE 'doc_field_length'
				i_nHoldLength = THIS.GetItemNumber(row,'doc_field_length')
		END CHOOSE
		
	CASE 	'd_tm_bcbsvt_setup'
		fu_ChangeOptions(c_NoMenuButtonActivation) 	
		m_table_maintenance.m_edit.m_new.Enabled = FALSE
		m_table_maintenance.m_edit.m_delete.Enabled = FALSE
				
	CASE 'd_tm_case_types'
		fu_ChangeOptions(c_NoMenuButtonActivation) 	
		m_table_maintenance.m_edit.m_new.Enabled = FALSE
		m_table_maintenance.m_edit.m_delete.Enabled = FALSE
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite	Added 6.23.2005
	//-----------------------------------------------------------------------------------------------------------------------------------
	CASE 'd_tm_contacthistory_fields'
		fu_ChangeOptions(c_NoMenuButtonActivation) 	
		m_table_maintenance.m_edit.m_new.Enabled = FALSE
		m_table_maintenance.m_edit.m_delete.Enabled = FALSE	

	CASE 'd_tm_field_defs'
		// refresh the current drop down list field on the datawindow object
		CHOOSE CASE dwo.Name
			CASE 'source_type'
				f_refreshdddw (dw_table_maintenance, row, 'source_type')
				
			CASE 'column_name'
				l_nRow = GetRow ()
				IF i_cCodeTable = "" THEN
					
					l_cSourceType = GetItemString (l_nRow, 'source_type')
					fu_DefineCodeTable (l_cSourceType)
					
				END IF
				l_cValue = GetItemString (l_nRow, 'column_name')
				THIS.Object.column_name.Values = i_cCodeTable
				SetItem (l_nRow, 'column_name', l_cValue)
				
			CASE 'format_id'
				f_refreshdddw (dw_table_maintenance, row, 'format_id')
				
		END CHOOSE

//RAP - added 11/13/2006 to manage DDDWs
	CASE 'd_tm_service_type'

		CHOOSE CASE dwo.Name
		
			CASE 'appealtypeid', 'appealtypeid_all'
				GetChild('appealtypeid', ldwc_Appeal_Type)
				ll_line_of_business_id = THIS.Object.line_of_business_id[row]
				ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id))
				ll_return = ldwc_appeal_type.Filter()
				
		END CHOOSE

	CASE 'd_tm_appealtype_event_defaults'

		CHOOSE CASE dwo.Name
		
			CASE 'appealtypeid', 'appealtypeid_all'
				GetChild('appealtypeid', ldwc_Appeal_Type)
				ll_line_of_business_id = THIS.Object.line_of_business_id[row]
				ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id))
				ll_return = ldwc_appeal_type.Filter()
				
			CASE 'service_type_id', 'service_type_id_all'
				GetChild('service_type_id', ldwc_Service_Type)
				ll_line_of_business_id = THIS.Object.line_of_business_id[row]
				ll_appeal_type_id = THIS.Object.appealtypeid[row]
				ll_return = ldwc_service_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id) + " and appealtypeid = " + String(ll_appeal_type_id))
				ll_return = ldwc_service_type.Filter()
				
		END CHOOSE
		
	CASE 'd_tm_hotkeys'
//		fu_ChangeOptions(c_NoMenuButtonActivation) 	
		m_table_maintenance.m_edit.m_new.Enabled = FALSE
		m_table_maintenance.m_edit.m_delete.Enabled = FALSE
END CHOOSE
end event

event pcd_validatecol;call super::pcd_validatecol;//**********************************************************************************************
//
//  Event:   pcd_validatecol
//  Purpose: Validate the information in the datawindow during the save process
//
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  04/17/00 M. Caruso   Created to validate the format_id column of d_tm_field_defs.
//  08/28/00 C. Jackson  Limit the length of past due reminders and late reminders to 365 days
//  11/15/01 M. Caruso   Reversed changes made on 10/17/01.
//  12/07/01 C. Jackson  Check to see if Provider Type is already defined SCR 2465.
//  12/11/01 C. Jackson  Add AcceptText() 
//  8/19/2004 K. Claver  Check to see if a file extension is already defined for Attachment Types
//**********************************************************************************************

BOOLEAN	l_bFailed
STRING	l_cColName, l_cFileName, l_cActive, l_cSourceType, l_cCaseType, l_cCode, l_cCodeDesc
LONG		l_nIndex, l_nRowCount, ll_source_type

IF in_save THEN
	
	THIS.AcceptText()
	
	CHOOSE CASE dataobject
			
		CASE 'd_tm_provider_types'
			CHOOSE CASE col_name
				CASE 'provider_type'
					l_nRowCount = RowCount()
					// verify that this entry is unique in the table.
					FOR l_nIndex = 1 TO l_nRowCount
						
						// Check for existing Provider Type
						IF (UPPER(col_text) = UPPER(THIS.GetItemString (l_nIndex, col_name))) AND (row_nbr <> l_nIndex) THEN
							MessageBox (gs_AppName, "Provider Type '"+col_text+"' is already used.~r~n" + &
																  "Please use another Provider Type.") 

							l_bFailed = TRUE
							EXIT
						END IF
						
					NEXT
				CASE 'provid_type_desc'
					l_nRowCount = RowCount()
					// verify that this entry is unique in the table.
					FOR l_nIndex = 1 TO l_nRowCount
						
						// Check for existing Provider Type Description
						IF (UPPER(col_text) = UPPER(THIS.GetItemString (l_nIndex, col_name))) AND (row_nbr <> l_nIndex) THEN
							MessageBox (gs_AppName, "Provider Type Description '"+col_text+"' is already used.~r~n" + &
							                        "Please use another Provider Type Description.")
							l_bFailed = TRUE
							EXIT
						END IF
					NEXT
			END CHOOSE
					
		CASE 'd_tm_cusfocus_users'
			CHOOSE CASE col_name
				CASE 'late_reminder', 'past_due_reminder'
					l_nRowCount = RowCount()
					FOR l_nIndex = 1 TO l_nRowCount
						IF GetItemNumber (row_nbr,col_name) > 365 THEN
							messagebox(gs_AppName,'Value must not be greater than 365')
							l_bFailed = TRUE
							EXIT
						END IF
					NEXT
					
			END CHOOSE
			
		CASE 'd_tm_field_defs'
			CHOOSE CASE col_name
				CASE 'format_id'
					IF IsNull (GetItemString (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must specify a display format for this column.")
						l_bFailed = TRUE
					END IF
					
				CASE 'column_name'
					// verify that this entry is unique in the table.
					l_nRowCount = RowCount ()
					FOR l_nIndex = 1 TO l_nRowCount
						
						// If the column names match and the rows are not the same then there's a problem.
						IF (col_text = THIS.GetItemString (l_nIndex, col_name)) AND (row_nbr <> l_nIndex) THEN
							MessageBox (gs_AppName, "The value for this column must be unique.~r~n" + &
																  "Please correct this value to continue.") 

							l_bFailed = TRUE
							EXIT
						END IF
						
					NEXT
		
			END CHOOSE
		
		CASE 'd_tm_case_prop_field_defs'
			CHOOSE CASE col_name
				CASE 'source_type'
					IF IsNull (GetItemString (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must specify a Source Type for this column.")
						l_bFailed = TRUE
					END IF
					
				CASE 'case_type'
					IF IsNull (GetItemString (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must specify a Case Type for this column.")
						l_bFailed = TRUE
					END IF	
					
				CASE 'field_order'
					
					IF IsNull (GetItemNumber (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must specify an Order for this column.")
						l_bFailed = TRUE
					END IF
					
				CASE 'field_length'
					IF GetItemNumber( row_nbr, col_name ) > 50 THEN
						MessageBox( gs_AppName, "Field length cannot exceed 50" )
						l_bFailed = TRUE
					END IF
					
				CASE 'format_id'
					IF IsNull (GetItemString (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must specify a display format for this column.")
						l_bFailed = TRUE
					END IF
				

				Case 'searchable_contacthistory'	
					l_nRowCount = RowCount()
						// verify that this entry is unique in the table.
						FOR l_nIndex = 1 TO l_nRowCount
							long ll_counter = 0
							
							l_cSourceType = THIS.GetItemString( row_nbr, "source_type" )
							l_cCaseType = THIS.GetItemString( row_nbr, "case_type" )
	
							If GetItemString(l_nIndex, 'source_type') = l_cSourceType And GetItemString(l_nIndex, 'case_type') = l_cCaseType Then
								If lower(GetItemString(l_nIndex, 'searchable_contacthistory')) = 'y' Then
									ll_counter = ll_counter + 1
								End If
							End If
						NEXT	
					
					If ll_counter > 6 Then
						MessageBox (gs_AppName, "You can only have a total of 6 searchable case properties for a case type & source type combination.")
						l_bFailed = TRUE
					End If
					
				CASE 'column_name'
					IF IsNull (GetItemString (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must specify a Column Name.")
						l_bFailed = TRUE
					ELSE
						//Get the source type and case type to verify source type+case type+column name
						l_cSourceType = THIS.GetItemString( row_nbr, "source_type" )
						l_cCaseType = THIS.GetItemString( row_nbr, "case_type" )
						
						// verify that this entry is unique in the table.
						l_nRowCount = RowCount ()
						FOR l_nIndex = 1 TO l_nRowCount
							
							// If the column names, source type and case type match and the rows are not
							//   the same then there's a problem.
							IF (col_text = THIS.GetItemString (l_nIndex, col_name)) AND &
							   ( l_cSourceType = THIS.GetItemString( l_nIndex, "source_type" ) ) AND &
								( l_cCaseType = THIS.GetItemString( l_nIndex, "case_type" ) ) AND &
								(row_nbr <> l_nIndex) THEN
								MessageBox (gs_AppName, "The value for this column must be unique per Source Type and Case Type.~r~n" + &
																	  "Please correct this value to continue.") 
	
								l_bFailed = TRUE
								EXIT
							END IF
							
						NEXT
					END IF
		
			END CHOOSE
			
		Case "d_tm_appeal_event"
			
		Case "d_tm_appeal_prop_field_defs"
			Choose Case col_name
				CASE 'column_name'
					IF IsNull (GetItemString (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must specify a Column Name.")
						l_bFailed = TRUE
					ELSE
						//Get the source type and case type to verify source type+case type+column name
						ll_source_type = THIS.GetItemNumber( row_nbr, "source_type" )
						
						// verify that this entry is unique in the table.
						l_nRowCount = RowCount ()
						FOR l_nIndex = 1 TO l_nRowCount
							
							// If the column names, source type and case type match and the rows are not
							//   the same then there's a problem.
							IF (col_text = THIS.GetItemString (l_nIndex, col_name)) AND &
							   ( ll_source_type = THIS.GetItemNumber( l_nIndex, "source_type" ) ) AND &
								(row_nbr <> l_nIndex) THEN
								MessageBox (gs_AppName, "The value for this column must be unique per Appeal Event.~r~n" + &
																	  "Please correct this value to continue.") 
	
								l_bFailed = TRUE
								EXIT
							END IF
							
						NEXT
					END IF
			CASE 'source_type'
					IF IsNull (GetItemNumber (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must select an Appeal Event.")
						l_bFailed = TRUE
					ELSE
						//Get the source type and case type to verify source type+case type+column name
						l_cSourceType = THIS.GetItemString( row_nbr, "column_name" )
						
						// verify that this entry is unique in the table.
						l_nRowCount = RowCount ()
						FOR l_nIndex = 1 TO l_nRowCount
							
							// If the column names, source type and case type match and the rows are not
							//   the same then there's a problem.
							IF (col_text = string(THIS.GetItemNumber (l_nIndex, col_name))) AND &
							   ( l_cSourceType = THIS.GetItemString( l_nIndex, "column_name" ) ) AND &
								(row_nbr <> l_nIndex) THEN
								MessageBox (gs_AppName, "The value for this column must be unique per column.~r~n" + &
																	  "Please correct this value to continue.") 
	
								l_bFailed = TRUE
								EXIT
							END IF
							
						NEXT
					END IF
					
				CASE 'field_order'
					
					IF IsNull (GetItemNumber (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must specify an Order for this column.")
						l_bFailed = TRUE
					END IF
					
				CASE 'field_length'
					IF GetItemNumber( row_nbr, col_name ) > 50 THEN
						MessageBox( gs_AppName, "Field length cannot exceed 50" )
						l_bFailed = TRUE
					END IF
					
				CASE 'format_id'
					IF IsNull (GetItemString (row_nbr, col_name)) THEN
						MessageBox (gs_AppName, "You must specify a display format for this column.")
						l_bFailed = TRUE
					END IF
			End Choose
			
		Case "d_tm_appealtype_event_defaults"
			
		Case "d_tm_appeal_outcome"
			If col_name = "status" Then
				IF IsNull( col_text ) OR Trim( col_text ) = "" THEN
					Messagebox( gs_AppName, "Value required for Appeal Outcome Status.~r~n"+ &
									"Please correct the value to continue.", StopSign!, OK! )
					l_bFailed = TRUE
				END IF
			End If
			
		Case "d_tm_appeal_type" 
			
		Case 'd_tm_dateterm_name'
			
		Case 'd_tm_appealstatus'
			
			
		CASE "d_case_transfer_codes"
			IF col_name = "case_transfer_code" THEN
				IF IsNull( col_text ) OR Trim( col_text ) = "" THEN
					Messagebox( gs_AppName, "Value required for Case Transfer Code.~r~n"+ &
									"Please correct the value to continue.", StopSign!, OK! )
					l_bFailed = TRUE
				END IF
				
				IF NOT l_bFailed THEN
					//Needs to have a valid description
					l_cCodeDesc = THIS.GetItemString( row_nbr, "code_desc" )
					IF IsNull( l_cCodeDesc ) OR Trim( l_cCodeDesc ) = "" THEN
						Messagebox( gs_AppName, "Value required for Code Description.~r~n"+ &
										"Please correct the value to continue.", StopSign!, OK! )
						l_bFailed = TRUE
					END IF
				END IF
			END IF	
			
			IF col_name = "code_desc" THEN
				IF IsNull( col_text ) OR Trim( col_text ) = "" THEN
					Messagebox( gs_AppName, "Value required for Code Description.~r~n"+ &
									"Please correct the value to continue.", StopSign!, OK! )
					l_bFailed = TRUE
				END IF
				
				IF NOT l_bFailed THEN
					//Needs to have a valid code
					l_cCode = THIS.GetItemString( row_nbr, "case_transfer_code" )
					IF IsNull( l_cCode ) OR Trim( l_cCode ) = "" THEN
						Messagebox( gs_AppName, "Value required for Case Transfer Code.~r~n"+ &
										"Please correct the value to continue.", StopSign!, OK! )
						l_bFailed = TRUE
					END IF
				END IF
			END IF
	CASE "d_tm_cus_sat_codes"
			IF col_name = "customer_sat_code" THEN
				IF IsNull( col_text ) OR Trim( col_text ) = "" THEN
					Messagebox( gs_AppName, "Value required for Code.  Please~r~n"+ &
									"correct the value to continue.", StopSign!, OK! )
					l_bFailed = TRUE
				END IF
				
				IF NOT l_bFailed THEN
					//Needs to have a valid description
					l_cCodeDesc = THIS.GetItemString( row_nbr, "customer_sat_desc" )
					IF IsNull( l_cCodeDesc ) OR Trim( l_cCodeDesc ) = "" THEN
						Messagebox( gs_AppName, "Value required for Description.  Please~r~n"+ &
										"correct the value to continue.", StopSign!, OK! )
						l_bFailed = TRUE
					END IF
				END IF
			END IF	
			
			IF col_name = "customer_sat_desc" THEN
				IF IsNull( col_text ) OR Trim( col_text ) = "" THEN
					Messagebox( gs_AppName, "Value required for Description.  Please~r~n"+ &
									"correct the value to continue.", StopSign!, OK! )
					l_bFailed = TRUE
				END IF
				
				IF NOT l_bFailed THEN
					//Needs to have a valid code
					l_cCode = THIS.GetItemString( row_nbr, "customer_sat_code" )
					IF IsNull( l_cCode ) OR Trim( l_cCode ) = "" THEN
						Messagebox( gs_AppName, "Value required for Code.  Please~r~n"+ &
										"correct the value to continue.", StopSign!, OK! )
						l_bFailed = TRUE
					END IF
				END IF
			END IF
			
	CASE 'd_tm_attachment_types'
			CHOOSE CASE col_name
				CASE 'type_extension'
					l_nRowCount = RowCount()
					// verify that this entry is unique in the table.
					FOR l_nIndex = 1 TO l_nRowCount
						
						// Check for existing Provider Type
						IF (UPPER(col_text) = UPPER(THIS.GetItemString (l_nIndex, col_name))) AND (row_nbr <> l_nIndex) THEN
							MessageBox (gs_AppName, "Extension '"+col_text+"' is already used.~r~n" + &
																  "Please specify a different Extension.") 

							l_bFailed = TRUE
							EXIT
						END IF
						
					NEXT
			END CHOOSE
	END CHOOSE
END IF

// handle error conditions
IF l_bFailed THEN
	i_nRowFailed = row_nbr
	i_cColumnFailed = col_name
	Error.i_FWError = c_ValFailed

ELSE
	i_nRowFailed = 0
	i_cColumnFailed = ""
	Error.i_FWError = c_ValOK
END IF


end event

event clicked;call super::clicked;/******************************************************************************************
  Event:   clicked
  Purpose: Sort the datawindow by the column that was clicked.
	
  Date     Developer    Description
  -------- ------------ ------------------------------------------------------------------
  06/12/00 C. Jackson   Original Version.  Added to fix SCR 661
  06/24/00 C. Jackson   Add call to fu_definecodetable if the column_name list dropdown
                        was activated.  (SCR 683)
  12/6/2000 K. Claver   Commented out the sorting code in lieu of the sorting service set
  								in the pcd_setoptions event.
  12/04/01 M. Caruso    Commented the letter_types code because that module has been replaced.
  05/21/02 M. Caruso    Added code to display a message when the active field is clicked
  								on protected rows in the appeal level module.
  06/30/03 M. Caruso    Added code to display a message when the active field is clicked
  								on protected rows in the confidentiality level module.
  07/15/03 M. Caruso    Added code to display a message when the active field is clicked
  								on the default case note type row in the case note types module.
******************************************************************************************/

STRING	l_cSourceType, l_cLetterID, l_cOptionValue
LONG		l_nRow, l_nRows, l_nKeyValue, l_nDefaultNoteType
long ll_current_logo_id, ll_new_logo_id
string ls_name


CHOOSE CASE THIS.DataObject
		
	// perform special processing for the field_defs module.
	CASE 'd_tm_field_defs'
		CHOOSE CASE dwo.Name
			CASE 'column_name'
				// make sure the right drop down displays based on source type
				l_nRow = GetRow()
				l_cSourceType = THIS.GetItemString(l_nRow,'source_type')
				
				fu_definecodetable (l_cSourceType)
		
				SetItem (row, "column_name", "")
				THIS.Modify("column_name.Values='" + i_cCodeTable + "'")
				
		END CHOOSE
		
	CASE 'd_tm_appeal_levels'
		CHOOSE CASE dwo.name
			CASE 'active'
				l_nRow = GetRow ()
				l_nKeyValue = GetItemNumber (l_nRow, 'appeal_level')
				IF l_nKeyValue = 0 OR l_nKeyValue = 1 THEN
					MessageBox (gs_appname, 'This Appeal Level cannot be made inactive.')
				END IF
				
		END CHOOSE
		
	CASE 'd_tm_line_of_business'
		CHOOSE CASE dwo.name
			CASE 'lob_logo_blbobjctid'
				ll_current_logo_id = this.object.lob_logo_blbobjctid[row]
				IF IsNull(ll_current_logo_id) THEN
					ll_current_logo_id = -1
				END IF
				openwithparm(w_edit_lob_logo, ll_current_logo_id)
				ll_new_logo_id = message.doubleparm
				IF ll_new_logo_id > 0 THEN
					this.object.lob_logo_blbobjctid[row] = ll_new_logo_id
				END IF
		END CHOOSE
		
	CASE 'd_tm_confidentiality_levels'
		CHOOSE CASE dwo.name
			CASE 'active'
				l_nRow = GetRow ()
				l_nKeyValue = GetItemNumber (l_nRow, 'confidentiality_level')
				IF l_nKeyValue = 0 THEN
					MessageBox (gs_appname, 'This Confidentiality Level cannot be made inactive.')
				END IF
				
		END CHOOSE
		
	CASE 'd_tm_case_note_types'
		CHOOSE CASE dwo.name
			CASE 'active'
				// get the keyvalue to check
				l_nRow = GetRow ()
				l_nKeyValue = LONG (GetItemString (l_nRow, 'note_type'))
				IF IsNull (l_nKeyValue) THEN
					MessageBox (gs_appname, 'Error determining Case Note Type. Please notify the system administrator.')
					RETURN 1
				END IF
				
				// get the default note ID from system_options
				SELECT option_value INTO :l_cOptionValue
				FROM   cusfocus.system_options
				WHERE  option_name = 'default note type'
				USING  SQLCA;
				
				IF SQLCA.SQLCode = 0 THEN
					
					l_nDefaultNoteType = LONG (l_cOptionValue)
					IF IsNull (l_nDefaultNoteType) THEN l_nDefaultNoteType = 0
					IF l_nKeyValue = l_nDefaultNoteType THEN
						MessageBox (gs_appname, 'This Case Note Type is the default for the system and cannot be made inactive.')
						RETURN 1
					END IF
					
				ELSE
					MessageBox (gs_appname, 'Unable to determine the default Case Note Type so this entry cannot be made inactive.')
					RETURN 1
				END IF
				
				RETURN 0
				
		END CHOOSE
		
	// perform special processing for the letter_types module.
//	CASE 'd_tm_letter_types'
//		CHOOSE CASE dwo.Name
//			CASE 'active'
//				IF GetItemString (row, 'active') = 'Y' THEN
//					
//					l_cLetterID = GetItemString (row, 'letter_id')
//					SELECT COUNT (case_type) INTO :l_nRows
//					  FROM cusfocus.case_types
//					 WHERE letter_id = :l_cLetterID
//					 USING SQLCA;
//					 
//					IF SQLCA.SQLCode = 0 THEN
//						IF l_nRows > 0 THEN
//							// block change of state due to letter_id being in use
//							MessageBox (gs_appname, 'This is the default survey for one or more case types~r~n' + &
//															'so it cannot be set as inactive.')
//							RETURN 1
//						END IF
//						
//					ELSEIF SQLCA.SQLCode = -1 THEN
//						// block change of state due to inability to confirm if letter_id is in use
//						MessageBox (gs_appname, 'Unable to determine if this survey is associated with~r~n' + &
//						                        'a case type so it cannot be set as inactive.')
//						RETURN 1
//						
//					END IF
//					
//				END IF
//				
//		END CHOOSE
				
	
END CHOOSE
end event

event pcd_validaterow;call super::pcd_validaterow;/*****************************************************************************************
   Event:      pcd_validaterow
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/19/2002 K. Claver   Added code to validate uniqueness in the transfer code.
	2/28/2002 K. Claver   Added code to validate uniqueness in the customer sat code.
	2/28/2002 K. Claver   Added boolean instance variable to determine if the error message
								 was already shown as this event fires twice.
	4/8/2002  K. Claver   Added code to check if there are valid Cust Sat Codes, Resolution
								 codes and Other Close Codes before allowing to set as required.
	4/8/2002  K. Claver   Added code to check if Cust Sat Codes, Resolution Codes and Other
								 Close Codes are required before allowing to set all as inactive.
	6/6/2002  K. Claver   Added validation for field defs and relationships
*****************************************************************************************/

String l_cData, l_cCaseType, l_cCaseTypeDesc, ls_work_queue, ls_user_dept
Integer l_nCount, l_nRowCount, l_nIndex, l_nData
DWItemStatus l_dwisStatus
Boolean l_bError = FALSE

l_dwisStatus = THIS.GetItemStatus( row_nbr, 0, Primary! )

IF l_dwisStatus = NewModified! OR l_dwisStatus = DataModified! THEN
	CHOOSE CASE THIS.DataObject
		CASE "d_case_transfer_codes"
			l_cData = Upper( THIS.GetItemString( row_nbr, "case_transfer_code" ) )
			IF Trim( l_cData ) <> "" AND NOT IsNull( l_cData ) THEN
				l_nRowCount = THIS.RowCount( )
				
				// loop through the rows in the datawindow to verify that this is a valid customer satisfaction code
				FOR l_nIndex = 1 TO l_nRowCount
					IF ( Upper( THIS.GetItemString( l_nIndex, "case_transfer_code" ) ) = l_cData ) AND ( l_nIndex <> row_nbr ) THEN
						Messagebox( gs_AppName, "The value for Case Transfer Code must be unique.~r~n"+ &
										"Please correct this value to continue.", StopSign!, OK! )
													
						Error.i_FWError = c_ValFailed
						EXIT
					END IF					
				NEXT
			END IF
		CASE "d_tm_cus_sat_codes"
			l_cData = Upper( THIS.GetItemString( row_nbr, "customer_sat_code" ) )
			IF Trim( l_cData ) <> "" AND NOT IsNull( l_cData ) THEN
				l_nRowCount = THIS.RowCount( )
				
				// loop through the rows in the datawindow to verify that this is a valid customer satisfaction code
				FOR l_nIndex = 1 TO l_nRowCount
					IF ( Upper( THIS.GetItemString( l_nIndex, "customer_sat_code" ) ) = l_cData ) AND ( l_nIndex <> row_nbr ) THEN
						Messagebox( gs_AppName, "The value for Code must be unique.  Please~r~n"+ &
										"correct this value to continue.", StopSign!, OK! )
							
						Error.i_FWError = c_ValFailed
						EXIT
					END IF					
				NEXT
			END IF
			
			IF THIS.RowCount( ) > 0 THEN
				IF THIS.Find( "active = 'Y'", 1, THIS.RowCount( ) ) = 0 THEN
					//Check if required for close
					SELECT Count( * )
					INTO :l_nCount
					FROM cusfocus.case_types
					WHERE cus_sat_code_req = 'Y'
					USING SQLCA;
					
					IF l_nCount > 0 THEN
						MessageBox( gs_AppName, "At least one Customer Satisfaction Code must be active when required for case closure", &
										StopSign!, OK! )
						Error.i_FWError = c_ValFailed
					END IF
				END IF
			END IF
		CASE "d_tm_case_types"
			//Customer Sat Code
			l_cData = THIS.GetItemString( row_nbr, "cus_sat_code_req" )
			IF l_cData = "Y" THEN
				//Check for active customer sat codes
				SELECT Count( * )
				INTO :l_nCount
				FROM cusfocus.customer_sat_codes
				WHERE active = 'Y'
				USING SQLCA;
				
				IF l_nCount = 0 THEN
					MessageBox( gs_AppName, "Active Customer Sat Codes must exist before they can be set as required", &
									StopSign!, OK! )
					Error.i_FWError = c_ValFailed
					RETURN
				END IF
			END IF
			
			l_cData = THIS.GetItemString( row_nbr, "res_code_req" )
			IF l_cData = "Y" THEN
				//Get the case type
				l_cCaseType = THIS.GetItemString( row_nbr, "case_type" )
				

				//Check for active resolution codes
				SELECT Count( * )
				INTO :l_nCount
				FROM cusfocus.resolution_codes
				WHERE active = 'Y' AND
						case_type = :l_cCaseType
				USING SQLCA;
				
				IF l_nCount = 0 THEN
					MessageBox( gs_AppName, "Active Resolution Codes must exist before they can be set as required", &
									StopSign!, OK! )
					Error.i_FWError = c_ValFailed
					RETURN
				END IF
			END IF
			
			l_cData = THIS.GetItemString( row_nbr, "other_close_code_req" )
			IF l_cData = "Y" THEN
				//Get the case type
				l_cCaseType = THIS.GetItemString( row_nbr, "case_type" )
				
				//Check for active other close codes
				SELECT Count( * )
				INTO :l_nCount
				FROM cusfocus.other_close_codes
				WHERE active = 'Y' AND
						case_type = :l_cCaseType
				USING SQLCA;
				
				IF l_nCount = 0 THEN
					MessageBox( gs_AppName, "Active Other Close Codes must exist before they can be set as required", &
									StopSign!, OK! )
					Error.i_FWError = c_ValFailed
				END IF
			END IF
		CASE "d_tm_other_close_codes"
			IF THIS.RowCount( ) > 0 AND in_save THEN
				IF THIS.Find( "active = 'Y' AND case_type = 'I'", 1, THIS.RowCount( ) ) = 0 THEN
					//Check if required for close
					SELECT Count( * )
					INTO :l_nCount
					FROM cusfocus.case_types
					WHERE other_close_code_req = 'Y' AND
							case_type = 'I'
					USING SQLCA;
					
					IF l_nCount > 0 THEN
						l_bError = TRUE
						l_cCaseTypeDesc = "Inquiry"
					END IF
				END IF
				
				IF THIS.Find( "active = 'Y' AND case_type = 'C'", 1, THIS.RowCount( ) ) = 0 THEN
					//Check if required for close
					SELECT Count( * )
					INTO :l_nCount
					FROM cusfocus.case_types
					WHERE other_close_code_req = 'Y' AND
							case_type = 'C'
					USING SQLCA;
					
					IF l_nCount > 0 THEN
						l_bError = TRUE
						l_cCaseTypeDesc = "Issue/Concern"
					END IF
				END IF
					
				IF THIS.Find( "active = 'Y' AND case_type = 'M'", 1, THIS.RowCount( ) ) = 0 THEN
					//Check if required for close
					SELECT Count( * )
					INTO :l_nCount
					FROM cusfocus.case_types
					WHERE other_close_code_req = 'Y' AND
							case_type = 'M'
					USING SQLCA;
					
					IF l_nCount > 0 THEN
						l_bError = TRUE
						l_cCaseTypeDesc = gs_ConfigCasetype
					END IF
				END IF
				
				IF THIS.Find( "active = 'Y' AND case_type = 'P'", 1, THIS.RowCount( ) ) = 0 THEN
					//Check if required for close
					SELECT Count( * )
					INTO :l_nCount
					FROM cusfocus.case_types
					WHERE other_close_code_req = 'Y' AND
							case_type = 'P'
					USING SQLCA;
					
					IF l_nCount > 0 THEN
						l_bError = TRUE
						l_cCaseTypeDesc = "Proactive"
					END IF
				END IF
					
				IF l_bError THEN
					MessageBox( gs_AppName, "At least one Other Close Code must be active for case type "+ &
									l_cCaseTypeDesc+" when required for case closure", StopSign!, OK! )
					Error.i_FWError = c_ValFailed
				END IF			
			END IF
		CASE "d_tm_resolution_codes"
			IF THIS.RowCount( ) > 0 AND in_save THEN
				IF THIS.Find( "active = 'Y' AND case_type = 'I'", 1, THIS.RowCount( ) ) = 0 THEN
					//Check if required for close
					SELECT Count( * )
					INTO :l_nCount
					FROM cusfocus.case_types
					WHERE res_code_req = 'Y' AND
							case_type = 'I'
					USING SQLCA;
					
					IF l_nCount > 0 THEN
						l_bError = TRUE
						l_cCaseTypeDesc = "Inquiry"
					END IF
				END IF
				
				IF THIS.Find( "active = 'Y' AND case_type = 'C'", 1, THIS.RowCount( ) ) = 0 THEN
					//Check if required for close
					SELECT Count( * )
					INTO :l_nCount
					FROM cusfocus.case_types
					WHERE res_code_req = 'Y' AND
							case_type = 'C'
					USING SQLCA;
					
					IF l_nCount > 0 THEN
						l_bError = TRUE
						l_cCaseTypeDesc = "Issue/Concern"
					END IF
				END IF
					
				IF THIS.Find( "active = 'Y' AND case_type = 'M'", 1, THIS.RowCount( ) ) = 0 THEN
					//Check if required for close
					SELECT Count( * )
					INTO :l_nCount
					FROM cusfocus.case_types
					WHERE res_code_req = 'Y' AND
							case_type = 'M'
					USING SQLCA;
					
					IF l_nCount > 0 THEN
						l_bError = TRUE
						l_cCaseTypeDesc = gs_ConfigCaseType
					END IF
				END IF
				
				IF THIS.Find( "active = 'Y' AND case_type = 'P'", 1, THIS.RowCount( ) ) = 0 THEN
					//Check if required for close
					SELECT Count( * )
					INTO :l_nCount
					FROM cusfocus.case_types
					WHERE res_code_req = 'Y' AND
							case_type = 'P'
					USING SQLCA;
					
					IF l_nCount > 0 THEN
						l_bError = TRUE
						l_cCaseTypeDesc = "Proactive"
					END IF
				END IF
					
				IF l_bError THEN
					MessageBox( gs_AppName, "At least one Resolution Code must be active for case type "+ &
									l_cCaseTypeDesc+" when required for case closure", StopSign!, OK! )
					Error.i_FWError = c_ValFailed
				END IF			
			END IF
			
		CASE "d_tm_field_defs"
			l_cData = THIS.GetItemString( row_nbr, "field_label" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "Field Label is a required field", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
			IF NOT l_bError THEN
				l_nData = THIS.GetItemNumber( row_nbr, "field_length" )
				IF IsNull( l_nData ) OR l_nData = 0 THEN
					MessageBox( gs_AppName, "Length is a required field", StopSign!, OK! )
					Error.i_FWError = c_ValFailed
					l_bError = TRUE
				END IF
			END IF
			
			IF NOT l_bError THEN
				l_cData = THIS.GetItemString( row_nbr, "column_name" )
				IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
					MessageBox( gs_AppName, "Column Name is a required field", StopSign!, OK! )
					Error.i_FWError = c_ValFailed
				END IF
			END IF
			
		Case 'd_tm_appeal_prop_field_defs'
			l_cData = string(THIS.GetItemNumber( row_nbr, "field_order" ))
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "Field Order is a required field", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
			l_cData = THIS.GetItemString( row_nbr, "field_label" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "Field Label is a required field", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF

			
			IF NOT l_bError THEN
				l_nData = THIS.GetItemNumber( row_nbr, "field_length" )
				IF IsNull( l_nData ) OR l_nData = 0 THEN
					MessageBox( gs_AppName, "Field Length is a required field", StopSign!, OK! )
					Error.i_FWError = c_ValFailed
					l_bError = TRUE
				END IF
			END IF
			
			IF NOT l_bError THEN
				l_cData = THIS.GetItemString( row_nbr, "column_name" )
				IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
					MessageBox( gs_AppName, "Column Name is a required field", StopSign!, OK! )
					Error.i_FWError = c_ValFailed
				END IF
			END IF

		Case 'd_tm_dateterm_name'
			l_cData = THIS.GetItemString( row_nbr, "termname" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A value is required for the date term name.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
		Case 'd_tm_appeal_outcome'
			l_cData = THIS.GetItemString( row_nbr, "status" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A value is required for the status.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
			l_cData = THIS.GetItemString( row_nbr, "appealoutcome" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A value is required for the Appeal Outcome.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
		Case 'd_tm_appealtype_event_defaults'
			l_cData = string(this.GetItemNumber( row_nbr, 'appealtypeid'))
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A value is required for the Appeal Type.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
			l_cData = string(this.GetItemNumber( row_nbr, 'appealeventid'))
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A value is required for the Appeal Event.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
			l_cData = string(this.GetItemNumber( row_nbr, 'datetermid'))
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A value is required for the Date Term.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
//			l_cData = this.GetItemString( row_nbr, 'reminder')
//			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
//				MessageBox( gs_AppName, "A value is required for the Reminder.", StopSign!, OK! )
//				Error.i_FWError = c_ValFailed
//				l_bError = TRUE
//			END IF
			
		Case 'd_tm_dateexclusion'
			l_cData = THIS.GetItemString( row_nbr, "name" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A name is required.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
			l_cData = string(THIS.GetItemDateTime( row_nbr, "excludeddate" ))
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A date is required.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// JWhite	Added 6.2.2005		Make sure the Case Props Value has a value before allowing the save
		//-----------------------------------------------------------------------------------------------------------------------------------
		CASE "d_tm_case_prop_values"
			l_cData = THIS.GetItemString( row_nbr, "casepropertiesvalues_value" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A value is required for the case property.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF


			l_cData = THIS.GetItemString( row_nbr, "case_properties_field_def_source_type" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A source type is required for the case property.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
			l_cData = THIS.GetItemString( row_nbr, "case_properties_field_def_case_type" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A case type is required for the case property.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
			l_cData = THIS.GetItemString( row_nbr, "case_properties_field_def_column_name" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "Please select a column name.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF

		CASE "d_tm_appealpropertiesvalues"
			l_cData = THIS.GetItemString( row_nbr, "appealpropertiesvalues_value" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "A value is required for the appeal property.", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF

//
//			l_cData = string(THIS.GetItemNumber( row_nbr, "appeal_properties_field_def_source_type" ))
//			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
//				MessageBox( gs_AppName, "An Appeal Event is required for the appeal property.", StopSign!, OK! )
//				Error.i_FWError = c_ValFailed
//				l_bError = TRUE
//			END IF
//			
//			l_cData = THIS.GetItemString( row_nbr, "appeal_properties_field_def_column_name" )
//			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
//				MessageBox( gs_AppName, "Please select a column name.", StopSign!, OK! )
//				Error.i_FWError = c_ValFailed
//				l_bError = TRUE
//			END IF

			
		CASE "d_tm_relationships"
			l_cData = THIS.GetItemString( row_nbr, "relationship_desc" )
			IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
				MessageBox( gs_AppName, "Description is a required field", StopSign!, OK! )
				Error.i_FWError = c_ValFailed
				l_bError = TRUE
			END IF
			
			IF NOT l_bError THEN
				l_cData = THIS.GetItemString( row_nbr, "source_type" )
				IF IsNull( l_cData ) OR Trim( l_cData ) = "" THEN
					MessageBox( gs_AppName, "Source Type is a required field", StopSign!, OK! )
					Error.i_FWError = c_ValFailed
				END IF
			END IF
		CASE "d_tm_work_queue_security"
			THIS.AcceptText()
			ls_work_queue = Upper(THIS.Object.work_queue_id[ row_nbr ])
			ls_user_dept = Upper(THIS.Object.user_dept_id[row_nbr])
			IF Trim( ls_work_queue ) <> "" AND NOT IsNull( ls_work_queue ) AND Trim( ls_user_dept ) <> "" AND NOT IsNull( ls_user_dept ) THEN
				l_nRowCount = THIS.RowCount( )
				
				// loop through the rows in the datawindow to verify that this is a valid customer satisfaction code
				FOR l_nIndex = 1 TO l_nRowCount
					IF ( Upper( THIS.Object.work_queue_id[l_nIndex] ) = ls_work_queue) AND ( Upper( THIS.Object.user_dept_id[l_nIndex] ) = ls_user_dept) AND( l_nIndex <> row_nbr ) THEN
						Messagebox( gs_AppName, "This Department is already authorized for work queue " + ls_work_queue + ".", StopSign!, OK! )
													
						Error.i_FWError = c_ValFailed
						EXIT
					END IF					
				NEXT
			END IF
		CASE "d_tm_keywords"
			l_cData = TRIM(Upper( THIS.GetItemString( row_nbr, "keyword" ) ))
			IF Trim( l_cData ) <> "" AND NOT IsNull( l_cData ) THEN
				l_nRowCount = THIS.RowCount( )
				
				// loop through the rows in the datawindow to verify that this is a valid customer satisfaction code
				FOR l_nIndex = 1 TO l_nRowCount
					IF ( Upper( THIS.GetItemString( l_nIndex, "keyword" ) ) = l_cData ) AND ( l_nIndex <> row_nbr ) THEN
						Messagebox( gs_AppName, "The keyword must be unique.  Please~r~n"+ &
										"correct this value to continue.", StopSign!, OK! )
							
						Error.i_FWError = c_ValFailed
						EXIT
					END IF					
				NEXT
			END IF
	END CHOOSE
END IF
end event

event editchanged;call super::editchanged;//***********************************************************************************************
//
//  Event:   EditChanged
//  Purpose: Present message to user if they are attempting to enter invalid data
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  11/30/01 C. Jackson  Original Version
//***********************************************************************************************

CHOOSE CASE THIS.DataObject
		
	CASE 'd_tm_case_prop_field_defs'
		
		CHOOSE CASE dwo.Name
				
			CASE 'field_order'
				
				IF Not IsNull( data) AND TRIM( data ) <> '' THEN
					IF NOT IsNumber(data) THEN
						messagebox(gs_AppName,'Field Order must be numeric.')
						THIS.SetItem(row,'field_order',i_nHoldOrder)
					END IF
				END IF

			CASE 'field_length'
				
				IF Not IsNull( data) AND TRIM( data ) <> '' THEN
					IF NOT IsNumber(data) THEN
						messagebox(gs_AppName,'Field Length must be numeric.')
						THIS.SetItem(row,'field_length',i_nHoldLength)
					END IF
				END IF
		END CHOOSE
				
	CASE 'd_tm_doc_fields'
		
		CHOOSE CASE dwo.name

			CASE 'doc_field_length'
				
				IF Not IsNull( data) AND TRIM( data ) <> '' THEN
					IF NOT IsNumber(data) THEN
						messagebox(gs_AppName,'Field Length must be numeric.')
						THIS.SetItem(row,'doc_field_length',i_nHoldLength)
					END IF
				END IF
		END CHOOSE

END CHOOSE


end event

event pcd_save;call super::pcd_save;//*********************************************************************************************
//
//  Event:   pcd_save
//  Purpose: to perform additional save functionality
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  02/07/03 C. Jackson  Original Version
//*********************************************************************************************
LONG l_nMaxSecurity

IF Error.i_FWError = c_Success THEN
	
	SELECT max(confidentiality_level) INTO :l_nMaxSecurity
	  FROM cusfocus.confidentiality_levels
	 USING SQLCA;
	 
	UPDATE cusfocus.cusfocus_user
	   SET confidentiality_level = :l_nMaxSecurity,
		    usr_confidentiality_level = :l_nMaxSecurity,
			 rec_confidentiality_level = :l_nMaxSecurity,
			 iim_confidentiality_level = :l_nMaxSecurity
	 WHERE user_id = 'cfadmin'
	 USING SQLCA;

//	9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
// 	UPDATE cusfocus.cusfocus_user
//	   SET confidentiality_level = :l_nMaxSecurity,
//		    usr_confidentiality_level = :l_nMaxSecurity,
//			 rec_confidentiality_level = :l_nMaxSecurity,
//			 iim_confidentiality_level = :l_nMaxSecurity
//	 WHERE user_id = 'cfadmin'
//	 USING SQLCA;
	 
END IF


end event

event rbuttondown;/*****************************************************************************************
   Event:      rbuttondown
   Purpose:    Select the row that was clicked before doing anything else like displaying
					a pop-up menu.  If the user did not click in a valid row, then process as
					normal.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/19/03 M. Caruso	 Created.
*****************************************************************************************/LONG	l_nSelectedRows[], l_nRowCount

IF row > 0 THEN
	
	l_nRowCount = 1
	l_nSelectedRows[l_nRowCount] = row
	fu_SetSelectedRows (l_nRowCount, l_nSelectedRows[], c_IgnoreChanges, c_NoRefreshChildren)
	
END IF

CALL SUPER::rbuttondown
end event

event scrollhorizontal;call super::scrollhorizontal;/*---------------------------------------------------------------
	Event: ScrollHorizontal
	Purpose: Please see PB documentation for this event

	Arguments: Please see PB documentation for this event
	Returns: Please see PB documentation for this event
	
Date        Developer     Mod Description	
-----------------------------------------------------------------
9/29/2004   K. Claver     Added code to toggle the redraw to false
								  and back to true to help eliminate redraw
								  issues with checkboxes.

---------------------------------------------------------------*/
//Toggle the redraw to eliminate the redraw issue with the checkbox(SCR #13)
THIS.SetRedraw( FALSE )
THIS.SetRedraw( TRUE )
end event

event rowfocuschanged;call super::rowfocuschanged;//*********************************************************************************************
//  RAP - added 11/13/2006 to manage DDDWs
//*********************************************************************************************

LONG		ll_line_of_business_id, ll_appeal_type_id, ll_return
DATAWINDOWCHILD	ldwc_appeal_type, ldwc_service_type

IF currentrow > 0 THEN
	CHOOSE CASE dw_table_maintenance.dataobject
			
		CASE 'd_tm_service_type'
	
				GetChild('appealtypeid', ldwc_Appeal_Type)
				ll_line_of_business_id = THIS.Object.line_of_business_id[currentrow]
				IF NOT IsNull(ll_line_of_business_id) THEN
					ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id))
				ELSE
					ll_return = ldwc_Appeal_Type.SetFilter("0 = 1") // Filter out everything
				END IF
				ll_return = ldwc_appeal_type.Filter()
					
		CASE 'd_tm_appealtype_event_defaults'
	
				GetChild('appealtypeid', ldwc_Appeal_Type)
				ll_line_of_business_id = THIS.Object.line_of_business_id[currentrow]
				IF NOT IsNull(ll_line_of_business_id) THEN
					ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id))
				ELSE
					ll_return = ldwc_Appeal_Type.SetFilter("0 = 1") // Filter out everything
				END IF
				ll_return = ldwc_appeal_type.Filter()
				
				GetChild('service_type_id', ldwc_Service_Type)
				ll_appeal_type_id = THIS.Object.appealtypeid[currentrow]
				IF NOT IsNull(ll_appeal_type_id) THEN
					ll_return = ldwc_service_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id) + " and appealtypeid = " + String(ll_appeal_type_id))
				ELSE
					ll_return = ldwc_service_Type.SetFilter("0=1")
				END IF
				ll_return = ldwc_service_type.Filter()
					
	END CHOOSE
END IF
end event

