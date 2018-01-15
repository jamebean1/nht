$PBExportHeader$u_search_criteria.sru
$PBExportComments$Search Criteria User Object
forward
global type u_search_criteria from u_container_std
end type
type uo_matched_records from u_matched_records within u_search_criteria
end type
type st_search_type from statictext within u_search_criteria
end type
type ddlb_search_type from dropdownlistbox within u_search_criteria
end type
type dw_search_criteria from u_dw_search within u_search_criteria
end type
type dw_case_detail_report from datawindow within u_search_criteria
end type
type gb_search_criteria from groupbox within u_search_criteria
end type
end forward

global type u_search_criteria from u_container_std
integer width = 3602
integer height = 1592
long backcolor = 79748288
event ue_rowselected pbm_custom01
uo_matched_records uo_matched_records
st_search_type st_search_type
ddlb_search_type ddlb_search_type
dw_search_criteria dw_search_criteria
dw_case_detail_report dw_case_detail_report
gb_search_criteria gb_search_criteria
end type
global u_search_criteria u_search_criteria

type variables
BOOLEAN	i_bCancelSearch
BOOLEAN  i_bInSearch

INTEGER  i_nDisplayCount = 0

STRING	i_cCriteriaColumn[]
STRING	i_cSearchTable[]
STRING	i_cSearchColumn[]
STRING	i_cRealTimeArg[]
STRING   i_cCurrUser

W_CREATE_MAINTAIN_CASE i_wParentWindow

n_blob_manipulator in_blob_manipulator
datastore ids_syntax
datastore ids_results_fields
datastore ids_display_formats

//Create these holders as need to save the datawindow syntax in a state
//  before the search mechanism has changed the select
STRING is_MemberSyntax
STRING is_ProviderSyntax
STRING is_GroupSyntax
STRING is_OtherSyntax
STRING is_CaseSyntax
STRING is_AppealSyntax

string	is_origingal_search_syntax


end variables

forward prototypes
public subroutine fu_resizeline ()
public function integer fu_getrecconfidlevel (string a_ccurrentcasesubject, string a_csourcetype)
public function long fu_displayfields (character source_type)
public subroutine fu_updatesearchresultslabels (string a_csourcetype)
public function integer fu_buildsearchlists (character source_type)
public subroutine fu_buildrealtimeargslist ()
public function string of_add_case_properties (string as_data, string as_type)
public function long of_retrieve ()
public subroutine of_reset_criteria ()
public function string of_add_appeal_properties (string as_data, string as_type)
public function long of_retrieve_appeal ()
end prototypes

public subroutine fu_resizeline ();/*****************************************************************************************
   Function:   fu_resizeline
   Purpose:    resize the footer separator line in the current matched records datawindow.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/27/00 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nWidth, l_nWidthOffset

l_nWidthOffset = i_wParentWindow.Width - i_wParentWindow.i_nBaseWidth
l_nWidth = INTEGER (uo_matched_records.dw_matched_records.Describe ("l_1.X2"))
uo_matched_records.dw_matched_records.Modify ("l_1.X2=" + STRING (l_nWidth + l_nWidthOffset))
end subroutine

public function integer fu_getrecconfidlevel (string a_ccurrentcasesubject, string a_csourcetype);//****************************************************************************************
//
//	  Function:	fu_GetRecConfidLevel
//		Purpose:	To Retrieve the source record confidentiality level
//    
// Parameters: a_cCurrentCaseSubject - The id of the record
//					a_cSourceType - The record type(member, provider, etc)
//    Returns: The confidentiality of the record
//						
//	 Date     Developer    Description
//	 -------- ------------ ----------------------------------------------------------------
//	 3/1/2001 K. Claver    Original version.
//  09/28/01 C. Jackson   Correct select for provider confidentiality_level.  Was looking
//                        at provider_id rather than provider_key.
//**************************************************************************************/
Integer l_nConfidLevel

SetNull( l_nConfidLevel )

CHOOSE CASE a_cSourceType
	CASE i_wParentWindow.i_cSourceProvider
		SELECT cusfocus.provider_of_service.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.provider_of_service
		WHERE cusfocus.provider_of_service.provider_key = CONVERT(int,:a_cCurrentCaseSubject)
		USING SQLCA;
	CASE i_wParentWindow.i_cSourceEmployer
		SELECT cusfocus.employer_group.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.employer_group
		WHERE cusfocus.employer_group.group_id = :a_cCurrentCaseSubject
		USING SQLCA;
	CASE i_wParentWindow.i_cSourceConsumer
		SELECT cusfocus.consumer.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.consumer
		WHERE cusfocus.consumer.consumer_id = :a_cCurrentCaseSubject
		USING SQLCA;
	CASE i_wParentWindow.i_cSourceOther
		SELECT cusfocus.other_source.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.other_source
		WHERE cusfocus.other_source.customer_id = :a_cCurrentCaseSubject
		USING SQLCA;
END CHOOSE	
		
RETURN l_nConfidLevel



end function

public function long fu_displayfields (character source_type);//*********************************************************************************************
//
//  Function:   fu_displayfields
//  Purpose:    Add the user configured fields for the current source type to the
//              datawindow.
//  Parameters: CHARACTER  source_type - the source for which to build the field list.
//  Returns:    LONG ->   0 - success
//                -1 - failure
//                
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  07/19/99 M. Caruso   Adapted code from u_demographics.fu_displayfields
//  08/04/99 M. Caruso   Code now compares i_sconfigurablefield[].editmask = "" instead of IsNull 
//                       to determine the type of field to create
//  08/13/99 M. Caruso   The code now resizes the Detail band of the datawindow based on the 
//                       number of columns being displayed.  Also corrected the code that builds 
//							    the field display information by adding a space after the tabsequence 
//							    parameter
//  08/24/99 M. Caruso   Check if the field has an editmask before assigning validation 
//                       expressions and error messages
//  07/07/00 C. Jackson  Add logic to only apply editmask to Other Source Types (SCR 689)
//  07/10/00 C. Jackson  Correct i_wparentwindow.i_cSourceType to Source_Type
//  06/10/03 M. Caruso   Added code to implement field re-labeling.
//  07/03/03 M. Caruso   Modified to call gf_AllowQuotesInLabels ().
//*********************************************************************************************

CONSTANT	INTEGER	col1labelX = 27
CONSTANT	INTEGER	col2labelX = 1102
CONSTANT	INTEGER	col3labelX = 2176
CONSTANT	INTEGER	col1cellX = 462
CONSTANT	INTEGER	col2cellX = 1536
CONSTANT	INTEGER	col3cellX = 2610
CONSTANT INTEGER	y_offset = 92

LONG		l_nColCount, l_nMaxX, l_nMaxY, l_nX, l_nY, l_nIndex
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nPos, l_nNewColId
INTEGER  l_nTabSeq, l_nNewTabSeq
STRING	l_sColName, l_sModString, l_sMsg, l_cSyntax, l_cObjName, l_cDisplayFormat
STRING	l_cDisplayOnly, l_cNewLine, l_cLabelX, l_cCellX, l_cColIndex, l_cEditMask
STRING   l_cFormatName, l_cLabelName, l_cLabelText

// determine the location of the last predefined column in the datawindow
l_nColCount = LONG (dw_search_criteria.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO l_nColCount
	IF dw_search_criteria.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = dw_search_criteria.Describe ('#' + STRING (l_nIndex) + '.Name')
		l_nX = INTEGER (dw_search_criteria.Describe("#" + STRING(l_nIndex) + '.X'))
		l_nY = INTEGER (dw_search_criteria.Describe("#" + STRING(l_nIndex) + '.Y'))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxX = l_nX
			l_nMaxY = l_nY
			l_nLastCol = l_nIndex
		ELSEIF (l_nY = l_nMaxY) THEN
			IF l_nX > l_nMaxX THEN
				l_nMaxX = l_nX
				l_nLastCol = l_nIndex
			END IF
		END IF
		
		// calculate the highest used Tab Sequence Value
		l_nNewTabSeq = INTEGER (dw_search_criteria.Describe("#" + STRING(l_nIndex) + '.tabsequence'))
		IF l_nTabSeq < l_nNewTabSeq THEN
			l_nTabSeq = l_nNewTabSeq
		END IF
	END IF
NEXT

// determine if last field is in a group box and prep accordingly
l_sMsg = dw_search_criteria.Describe ("DataWindow.Objects")
l_nPos = 0
DO WHILE pos (l_sMsg, "~t", l_nPos + 1) > 0
	l_nIndex = l_nPos + 1
	l_nPos = pos (l_sMsg, "~t", l_nPos + 1)
	l_cObjName = Mid (l_sMsg, l_nIndex, (l_nPos - l_nIndex))
	IF pos (l_cObjName, "gb_") > 0 THEN
		l_nX = INTEGER (dw_search_criteria.Describe (l_cObjName + ".X"))
		l_nY = INTEGER (dw_search_criteria.Describe (l_cObjName + ".Y")) + &
				 INTEGER (dw_search_criteria.Describe (l_cObjName + ".Height"))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxY = l_nY
			l_nMaxX = col1cellX
			l_nLastCol = -1
		END IF
	END IF
LOOP

// determine location of first field to add
IF l_nLastCol = -1 THEN  // if the last field was in a group box
	l_nColNum = 1
ELSE
	l_nX = INTEGER (dw_search_criteria.Describe("#" + STRING(l_nLastCol) + '.X'))
	l_nY = INTEGER (dw_search_criteria.Describe("#" + STRING(l_nLastCol) + '.Y'))
	l_nWidth = INTEGER (dw_search_criteria.Describe("#" + STRING(l_nLastCol) + '.Width'))
	IF (l_nX + l_nWidth) > col3cellX THEN
		l_nColNum = 1
	ELSEIF (l_nX + l_nWidth) > col2cellX THEN
		l_nColNum = 3
	ELSE
		l_nColNum = 2
	END IF
END IF

// add the new fields
FOR l_nIndex = 1 to i_wparentwindow.i_nNumConfigFields
	// handle the field label updating or
	IF i_wparentwindow.i_sConfigurableField[l_nIndex].field_length = 0 THEN
		
		l_cLabelName = i_wparentwindow.i_sConfigurableField[l_nIndex].column_name + "_t"
		IF dw_search_criteria.Describe (l_cLabelName + ".Text") <> "!" THEN
			
			l_cLabelText = gf_AllowQuotesInLabels(i_wparentwindow.i_sConfigurableField[l_nIndex].field_label + ":")
			dw_search_criteria.Modify (l_cLabelName + ".Text='" + l_cLabelText + "'")
			
		END IF
		
	// add the one's marked as searchable!
   ELSEIF i_wparentwindow.i_sConfigurableField[l_nIndex].searchable = 'Y' THEN
		l_nPos = 0
		DO WHILE Pos(i_wparentwindow.i_sConfigurableField[l_nIndex].column_name, '_', l_nPos + 1) > 0
			l_nPos = Pos(i_wparentwindow.i_sConfigurableField[l_nIndex].column_name, '_', l_nPos + 1)
		LOOP
		l_cColIndex = Right(i_wparentwindow.i_sConfigurableField[l_nIndex].column_name, &
								  Len (i_wparentwindow.i_sConfigurableField[l_nIndex].column_name) - l_nPos)
		// determine location of new objects
		CHOOSE CASE l_nColNum
			CASE 1
				l_cLabelX = STRING (col1labelX)
				l_cCellX = STRING (col1cellX)
				IF l_nLastCol = -1 THEN
					l_nMaxY = l_nMaxY + 28    // adjust for group box
					l_nLastCol = 0
				ELSE
					l_nMaxY = l_nMaxY + y_offset
				END IF
				l_nColNum = 2
				
			CASE 2
				l_cLabelX = STRING (col2labelX)
				l_cCellX = STRING (col2cellX)
				l_nColNum = 3
				
			CASE 3
				l_cLabelX = STRING (col3labelX)
				l_cCellX = STRING (col3cellX)
				l_nColNum = 1
				
		END CHOOSE
		
		// add the locate and display the column label
		l_sModString = i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'_t.x="'+l_cLabelX+'" ' + &
							i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'_t.y="'+STRING (l_nMaxY)+'" ' + &
							i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'_t.visible="1" ' + &
							i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'_t.text="'+i_wparentwindow.i_sConfigurableField[l_nIndex].field_label+':"' + &
							i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'_t.font.face="Tahoma" ' + & 
							i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'_t.font.height="-8" ' + &
							i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'_t.font.weight="700" ' 
		dw_search_criteria.Modify(l_sModString)
		
		// prepare to add the new column
		IF l_nTabSeq > 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable
		
		IF i_wparentwindow.i_sConfigurableField[l_nIndex].display_only = 'Y' THEN
			l_cDisplayOnly = 'yes'
		ELSE
			l_cDisplayOnly = 'no'
		END IF
		
		// add the correct type of field to the datawindow
		l_nPos = Pos (l_cSyntax, "htmltable") - 1
		l_cEditMask = i_wparentwindow.i_sConfigurableField[l_nIndex].edit_mask
		l_cDisplayFormat = Upper( i_wparentwindow.i_sConfigurableField[l_nIndex].display_format )		
		l_cFormatName = Upper( i_wparentwindow.i_sConfigurableField[l_nIndex].format_name )		
		IF l_cEditMask = "" OR Pos( l_cDisplayFormat, "GENERAL" ) > 0 OR &
			Pos( l_cFormatName, "GENERAL" ) > 0 OR Source_Type <> 'O' THEN
			// determine the value for edit.limit
			l_sModString = &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.x="'+l_cCellX+'" ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.y="'+STRING (l_nMaxY)+'" ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.edit.displayonly=no ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.edit.limit='+ &
						 STRING (i_wparentwindow.i_sConfigurableField[l_nIndex].field_length)+' ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.tabsequence='+STRING (l_nTabSeq) + ' ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.visible="1"' +&
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.font.face="Tahoma" ' + & 
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.font.height="-8" ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.font.weight="400" ' 
		ELSE
			l_sModString = &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.x="'+l_cCellX+'" ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.y="'+STRING (l_nMaxY)+'" ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.format="'+i_wparentwindow.i_sConfigurableField[l_nIndex].display_format+'" ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.editmask.readonly='+l_cDisplayOnly+' ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.editmask.spin=No ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.editmask.mask="'+i_wparentwindow.i_sConfigurableField[l_nIndex].edit_mask+'" ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.tabsequence='+STRING (l_nTabSeq)+' ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.visible="1"' +&
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.font.face="Tahoma" ' + & 
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.font.height="-8" ' + &
				i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'.font.weight="400" ' 
			
		END IF
		l_sMsg = dw_search_criteria.Modify(l_sModString)
		IF l_sMsg <> "" THEN
			MessageBox (gs_AppName,"Unable to display all of the fields for this search screen.")
		END IF
		// add validation rules and error messages if they exist for this column.
		IF i_wparentwindow.i_sConfigurableField[l_nIndex].edit_mask <> "" THEN
			IF i_wparentwindow.i_sConfigurableField[l_nIndex].validation_rule <> "" THEN
				l_sModString =  i_wparentwindow.i_sConfigurableField[l_nIndex].column_name + &
									'.Validation="'+i_wparentwindow.i_sConfigurableField[l_nIndex].validation_rule+'" '
				l_sMsg = dw_search_criteria.Modify(l_sModString)
				IF l_sMsg <> "" THEN
					MessageBox (gs_AppName,"Unable to define the validation message for the current column.")
				END IF
			END IF
			IF i_wparentwindow.i_sConfigurableField[l_nIndex].error_msg <> "" THEN
				l_sModString = l_sModString + i_wparentwindow.i_sConfigurableField[l_nIndex].column_name + &
									'.ValidationMsg="'+i_wparentwindow.i_sConfigurableField[l_nIndex].error_msg+'" '
				l_sMsg = dw_search_criteria.Modify(l_sModString)
				IF l_sMsg <> "" THEN
					MessageBox (gs_AppName,"Unable to define the validation error message for the current column.")
				END IF
			END IF
		END IF
	END IF
NEXT

IF (l_nMaxY + 64) > (LONG (dw_search_criteria.Object.DataWindow.Detail.Height)) THEN
	dw_search_criteria.Object.DataWindow.Detail.Height = STRING (l_nMaxY + 76)
END IF

RETURN 0
end function

public subroutine fu_updatesearchresultslabels (string a_csourcetype);/*****************************************************************************************
   Function:   fu_UpdateSearchResultsLabels
   Purpose:    Update the labels of the search results datawindow.
   Parameters: STRING a_cSourceType - Determines which fields to rename.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/11/03	M. Caruso    Created.
	07/07/03 M. Caruso    Some of the Case statments for provider, group and other were not
								 filled out correctly, causing those labels to not get updated.
	07/09/03 M. Caruso    Use employ_address_1 to update the Address label for Employer
								 Group search results.
*****************************************************************************************/

INTEGER	l_nIndex, l_nMaxEntries
STRING	l_cNewLabel

l_nMaxEntries = UpperBound (i_wParentWindow.i_sConfigurableField[])

FOR l_nIndex = 1 TO l_nMaxEntries
	
	IF i_wParentWindow.i_sConfigurableField[l_nIndex].field_length = 0 THEN
		
		l_cNewLabel = gf_AllowQuotesInLabels (i_wParentWindow.i_sConfigurableField[l_nIndex].field_label)
		CHOOSE CASE a_cSourceType
			CASE "C"
				// only check for Member Fields
				CHOOSE CASE i_wParentWindow.i_sConfigurableField[l_nIndex].column_name
					CASE 'consumer_id'
						uo_matched_records.dw_matched_records.Modify ("member_id_srt.Text='" + l_cNewLabel + "'")
					CASE 'consumer_full_name'
						uo_matched_records.dw_matched_records.Modify ("consumer_name_srt.Text='" + l_cNewLabel + "'")
					CASE 'consum_address_1'
						uo_matched_records.dw_matched_records.Modify ("member_address_srt.Text='" + l_cNewLabel + "'")
					CASE 'consum_dob'
						uo_matched_records.dw_matched_records.Modify ("consum_dob_srt.Text='" + l_cNewLabel + "'")
					CASE 'confidentiality_level'
						uo_matched_records.dw_matched_records.Modify ("confidentiality_level_srt.Text='" + l_cNewLabel + "'")
				END CHOOSE
				
			CASE "P"
				// only check Provider Fields
				CHOOSE CASE i_wParentWindow.i_sConfigurableField[l_nIndex].column_name
					CASE 'provider_id'
						uo_matched_records.dw_matched_records.Modify ("provider_id_srt.Text='" + l_cNewLabel + "'")
					CASE 'vendor_id'
						uo_matched_records.dw_matched_records.Modify ("vendor_id_srt.Text='" + l_cNewLabel + "'")
					CASE 'provider_type_desc'
						uo_matched_records.dw_matched_records.Modify ("provid_type_desc_srt.Text='" + l_cNewLabel + "'")
					CASE 'provid_name'
						uo_matched_records.dw_matched_records.Modify ("provid_name_srt.Text='" + l_cNewLabel + "'")
					CASE 'provid_name_2'
						uo_matched_records.dw_matched_records.Modify ("provid_name_2_srt.Text='" + l_cNewLabel + "'")
					CASE 'provid_address_1'
						uo_matched_records.dw_matched_records.Modify ("provider_address_srt.Text='" + l_cNewLabel + "'")
					CASE 'provid_specialty_desc'
						uo_matched_records.dw_matched_records.Modify ("provid_specialty_desc_srt.Text='" + l_cNewLabel + "'")
					CASE 'provid_status'
						uo_matched_records.dw_matched_records.Modify ("provid_status_srt.Text='" + l_cNewLabel + "'")
					CASE 'confidentiality_level'
						uo_matched_records.dw_matched_records.Modify ("confidentiality_level_srt.Text='" + l_cNewLabel + "'")
				END CHOOSE
				
			CASE "E"
				// only check Employer Group Fields
				CHOOSE CASE i_wParentWindow.i_sConfigurableField[l_nIndex].column_name
					CASE 'group_id'
						uo_matched_records.dw_matched_records.Modify ("cc_group_id_srt.Text='" + l_cNewLabel + "'")
					CASE 'employ_group_name'
						uo_matched_records.dw_matched_records.Modify ("employ_group_name_srt.Text='" + l_cNewLabel + "'")
					CASE 'employ_address_1'
						uo_matched_records.dw_matched_records.Modify ("address_srt.Text='" + l_cNewLabel + "'")
					CASE 'confidentiality_level'
						uo_matched_records.dw_matched_records.Modify ("confidentiality_level_srt.Text='" + l_cNewLabel + "'")
					/*   ACTIVATE THIS FIELD ONLY IF NEEDED, SINCE THIS IS THE ONLY PLACE IT IS USED
					CASE ''
						dw_matched_records.Modify ("apply_to_members_t.Text='" + l_cNewLabel + "'") */
				END CHOOSE
				
			CASE "O"
				// only check Other Fields
				CHOOSE CASE i_wParentWindow.i_sConfigurableField[l_nIndex].column_name
					CASE 'customer_id'
						uo_matched_records.dw_matched_records.Modify ("numeric_customer_id_srt.Text='" + l_cNewLabel + "'")
					CASE 'other_name'
						uo_matched_records.dw_matched_records.Modify ("other_name_srt.Text='" + l_cNewLabel + "'")
					/*    ACTIVATE THIS FIELD ONLY IF NEEDED, SINCE THIS IS THE ONLY PLACE IT IS USED
					CASE ''
						dw_matched_records.Modify ("alt_name_t.Text='" + l_cNewLabel + "'") */
					CASE 'customer_type'
						uo_matched_records.dw_matched_records.Modify ("cust_type_desc_srt.Text='" + l_cNewLabel + "'")
					CASE 'other_address_1'
						uo_matched_records.dw_matched_records.Modify ("address_srt.Text='" + l_cNewLabel + "'")
					CASE 'confidentiality_level'
						uo_matched_records.dw_matched_records.Modify ("confidentiality_level_srt.Text='" + l_cNewLabel + "'")
				END CHOOSE
				
		END CHOOSE
		
	END IF

NEXT
end subroutine

public function integer fu_buildsearchlists (character source_type);//********************************************************************************************
//
//  Function:   fu_buildsearchlists
//  Purpose:    Add the user configured fields for the current source type to the
//              datawindow.
//  Parameters: CHARACTER  source_type - values (C,E,P,O)
//  Returns:    INTEGER    0 - success
//                
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  07/19/99 M. Caruso   Created.
//  08/04/99 M. Caruso   Added counter for building search-related arrays.
//  
//********************************************************************************************

INTEGER	l_nTotalCols, l_nIndex, l_nColCount
STRING	l_cColName, l_cTableName

// determine the search table name
CHOOSE CASE source_type
	CASE "C"
		l_cTableName = "cusfocus.consumer"
		
	CASE "E"
		l_cTableName = "cusfocus.employer_group"
		
	CASE "P"
		l_cTableName = "cusfocus.provider_of_service"
		
	CASE "O"
		l_cTableName = "cusfocus.other_source"
		
END CHOOSE

// set the values for all visible fields on the search datawindow
l_nTotalCols = INTEGER (dw_search_criteria.Object.Datawindow.Column.Count)
l_nIndex = 0
FOR l_nColCount = 1 to l_nTotalCols
	IF dw_search_criteria.Describe ("#"+STRING(l_nColCount)+".Visible") = "1" THEN
		// determine the column name
		l_cColName = dw_search_criteria.Describe ("#"+STRING(l_nColCount)+".Name")
		l_nIndex++
		i_ccriteriacolumn[l_nIndex] = l_cColName
		i_csearchcolumn[l_nIndex] = l_cColName
		i_csearchtable[l_nIndex] = l_cTableName
	END IF
NEXT

RETURN 0
end function

public subroutine fu_buildrealtimeargslist ();//********************************************************************************************
//
//  Function:   fu_BuildRealTimeArgsList
//  Purpose:    Build the list of arguments to be passed to the datawindow for a Real-Time
//					 data retrieval.
//  Parameters: NONE
//  Returns:    NONE
//                
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  08/19/03 M. Caruso   Created.
//********************************************************************************************

INTEGER	l_nColCount, l_nColNum
STRING	l_cBlankArray[], l_cValue

// initialize the Real-Time Argument list.
i_cRealTimeArg[] = l_cBlankArray[]

// populate the array with entries from the current criteria datawindow.
l_nColCount = INTEGER (dw_search_criteria.Object.Datawindow.Column.Count)
FOR l_nColNum = 1 TO l_nColCount
	
	CHOOSE CASE Upper (dw_search_criteria.Describe ('#' + STRING (l_nColNum) + '.ColType'))
		CASE 'DATE'
			l_cValue = STRING (dw_search_criteria.GetItemDate (1, l_nColNum))
			
		CASE 'DATETIME', 'TIMESTAMP'
			l_cValue = STRING (dw_search_criteria.GetItemDateTime (1, l_nColNum))
			
		CASE 'DECIMAL'
			l_cValue = STRING (dw_search_criteria.GetItemDecimal (1, l_nColNum))
			
		CASE 'INT', 'LONG', 'NUMBER', 'REAL', 'ULONG'
			l_cValue = STRING (dw_search_criteria.GetItemNumber (1, l_nColNum))
			
		CASE 'TIME'
			l_cValue = STRING (dw_search_criteria.GetItemTime (1, l_nColNum))
			
		CASE ELSE
			l_cValue = dw_search_criteria.GetItemString (1, l_nColNum)
			
	END CHOOSE
			
	IF Trim (l_cValue) = '' THEN SetNull (l_cValue)
	i_cRealTimeArg[l_nColNum] = l_cValue
	
NEXT
end subroutine

public function string of_add_case_properties (string as_data, string as_type);//-----------------------------------------------------------------------------------------------------------------------------------
// Variable Declarations
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_casenumber, ls_case_type, ls_case_status_ID, ls_case_log_case_rep, ls_source_type
string ls_master_case_number
datetime	ldt_case_log_opnd_date
long ll_return
s_fieldproperties ls_null[]

datawindowchild ldwc_rep, ldwc_casetype, ldwc_status, ldwc_sourcetype


//-----------------------------------------------------------------------------------------------------------------------------------
// Get the user input values
//-----------------------------------------------------------------------------------------------------------------------------------
ls_casenumber 				= 	dw_search_criteria.GetItemString(1, 'case_number')
ls_case_type 				=	dw_search_criteria.GetItemString(1, 'case_type')
ls_case_status_ID			=	dw_search_criteria.GetItemString(1, 'case_status_ID')
ls_case_log_case_rep		=	dw_search_criteria.GetItemString(1, 'case_log_case_rep')
ls_source_type				=	dw_search_criteria.GetItemString(1, 'source_type')
ls_master_case_number	=	dw_search_criteria.GetItemString(1, 'master_case_number')
ldt_case_log_opnd_date	=	dw_search_criteria.GetItemDateTime(1, 'case_log_opnd_date')

If	as_type = 'case' then 
	ls_case_type = as_data
ElseIf as_type = 'source' then
	ls_source_type = as_data
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the array that holds the fields
//-----------------------------------------------------------------------------------------------------------------------------------
i_wParentWindow.i_sSearchableCaseProps[] = ls_null[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function that will determine the fields to be added
//-----------------------------------------------------------------------------------------------------------------------------------
i_wParentWindow.of_get_caseprops(as_data)

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the new fields to the windpw
//-----------------------------------------------------------------------------------------------------------------------------------
i_wParentWindow.of_add_case_properties()


//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 5.2.2005 	Get the New Case Prop DropDowns and Retrieve Them
//-----------------------------------------------------------------------------------------------------------------------------------
	Datawindowchild ldwc_caseprop
	long	ll_counter, ll_errorcheck

	For	ll_counter = 1 to i_wparentwindow.i_nNumConfigFields
		If lower(i_wparentwindow.i_sSearchableCaseProps[ll_counter].dropdown) = 'y' Then
			ll_errorcheck = dw_search_criteria.GetChild(i_wparentwindow.i_sSearchableCaseProps[ll_counter].column_name, ldwc_caseprop)
			ldwc_caseprop.SetTransObject(SQLCA)
			ll_errorcheck = ldwc_caseprop.Retrieve(i_wparentwindow.is_contacthistory_casetype, ls_source_type, i_wparentwindow.i_sSearchableCaseProps[ll_counter].column_name)
		
			If ll_errorcheck = 0 Then
				ldwc_caseprop.InsertRow(0)
			End If
		End If
	Next
//-----------------------------------------------------------------------------------------------------------------------------------
// End JWhite Added 5.2.2005
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the newly created datawindow is visible and insert a row
//-----------------------------------------------------------------------------------------------------------------------------------
dw_search_criteria.Visible = TRUE
ll_return = dw_search_criteria.InsertRow(0)

//-----------------------------------------------------------------------------------------------------------------------------------
// Swap out the dataobject to use the datawindow with the stored proc & dynamic criteria
//-----------------------------------------------------------------------------------------------------------------------------------
uo_matched_records.dw_matched_records.fu_Swap('d_matched_cases_caseprops', + &
									uo_matched_records.dw_matched_records.c_IgnoreChanges, &
									uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
									uo_matched_records.dw_matched_records.c_SelectOnScroll +&
									uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
									uo_matched_records.dw_matched_records.c_TabularFormStyle + &
									uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
									uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
									uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
									uo_matched_records.dw_matched_records.c_SortClickedOK )

//dw_matched_records.fu_unwire(dw_matched_records)


//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the User input values
//-----------------------------------------------------------------------------------------------------------------------------------
dw_search_criteria.GetChild('case_log_case_rep', ldwc_rep)
ldwc_rep.SetTransObject(SQLCA)
ldwc_rep.Retrieve()

Error.i_FWError = dw_search_criteria.fu_LoadCode("case_type", &
										"cusfocus.case_types", &
										"case_type", &
										"case_type_desc", &
										"active = 'Y'", "")

Error.i_FWError = dw_search_criteria.fu_LoadCode("case_status_id", &
										"cusfocus.case_status", &
										"case_status_id", &
										"case_stat_desc", &
										"active = 'Y'", "")

Error.i_FWError = dw_search_criteria.fu_LoadCode("source_type", &
										"cusfocus.source_types", &
										"source_type", &
										"source_desc", &
										"active = 'Y'", "")

dw_search_criteria.SetItem(ll_return, 'case_number', ls_casenumber)
dw_search_criteria.SetItem(ll_return, 'case_type', ls_case_type)
dw_search_criteria.SetItem(ll_return, 'case_status_ID', ls_case_status_ID)
dw_search_criteria.SetItem(ll_return, 'case_log_case_rep', ls_case_log_case_rep)
dw_search_criteria.SetItem(ll_return, 'source_type', ls_source_type)
dw_search_criteria.SetItem(ll_return, 'master_case_number', ls_master_case_number)
dw_search_criteria.SetItem(ll_return, 'case_log_opnd_date', ldt_case_log_opnd_date)


Return ''
end function

public function long of_retrieve ();string	ls_casenumber, ls_caserep, ls_sourcetype, ls_master_casenumber, ls_casetype
string	ls_casestatus, ls_dynamic1, ls_dynamic2, ls_dynamic3
string	ls_dynamic4, ls_dynamic5, ls_dynamic6, ls_temp, ls_source_name, ls_category
long		ll_return, i
datetime	ldt_case_log_opendate

ls_casenumber				=		dw_search_criteria.GetItemString(1, 'case_number')
ls_caserep					=		dw_search_criteria.GetItemString(1, 'case_log_case_rep')
ls_sourcetype				=		dw_search_criteria.GetItemString(1, 'source_type')
ls_source_name			=		dw_search_criteria.GetItemString(1, 'source_name')
ls_master_casenumber 	= 		dw_search_criteria.GetItemString(1, 'master_case_number')
ls_casetype					=		dw_search_criteria.GetItemString(1, 'case_type')
ldt_case_log_opendate	=		dw_search_criteria.GetItemDateTime(1, 'case_log_opnd_date')
ls_casestatus				=		dw_search_criteria.GetItemString(1, 'case_status_ID')
ls_category				=		dw_search_criteria.GetItemString(1, 'root_category_name')

//-----------------------------------------------------------------------------------------------------------------------------------
// If the values are '' then set them to null so the stored proc. can deal with them.
//-----------------------------------------------------------------------------------------------------------------------------------
If	ls_casenumber 				=		''	OR ls_casenumber = '%%'	Then		SetNull(ls_casenumber)			
If	ls_caserep 					= 		''	OR ls_caserep = '%%'		Then		SetNull(ls_caserep)		
If	ls_sourcetype 				= 		''	OR ls_sourcetype = '%%'		Then		SetNull(ls_sourcetype)		
If	ls_source_name 				= 		''	OR ls_source_name = '%%'		Then		SetNull(ls_source_name)		
If	ls_master_casenumber 	= 		''	OR ls_master_casenumber = '%%'		Then		SetNull(ls_master_casenumber)		
If	ls_casetype 				= 		''	OR ls_casetype = '%%'		Then		SetNull(ls_casetype)		
//If	ldt_case_log_opendate	= 		''		Then		SetNull(ldt_case_log_opendate)		
If	ls_casestatus 				= 		''	OR ls_casestatus = '%%'		Then		SetNull(ls_casestatus)		
If	ls_category 				= 		''	OR ls_category = '%%'		Then		SetNull(ls_category)		


//-----------------------------------------------------------------------------------------------------------------------------------
// Build the dynamic arguments to pass on to the stored proc.
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(i_wParentWindow.i_sSearchableCaseProps[]) > 0 Then
	For i = 1 to UpperBound(i_wParentWindow.i_sSearchableCaseProps[])
		IF i_wParentWindow.i_sSearchableCaseProps[i].edit_mask = '##/##/####' THEN
			ls_temp = String(dw_search_criteria.GetItemDate(1, i_wParentWindow.i_sSearchableCaseProps[i].column_name))
		ELSEIF i_wParentWindow.i_sSearchableCaseProps[i].edit_mask = '##/##/#### ##.##' THEN
			ls_temp = String(dw_search_criteria.GetItemDateTime(1, i_wParentWindow.i_sSearchableCaseProps[i].column_name))
		ELSE
			ls_temp = dw_search_criteria.GetItemString(1, i_wParentWindow.i_sSearchableCaseProps[i].column_name)
		END IF

		If i = 1 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic1	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic1	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 2 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic2	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic2	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 3 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic3	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic3	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 4 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic4	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic4	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 5 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic5	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic5	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 6 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic6	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic6	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		End If
	Next
	
End If


uo_matched_records.dw_matched_records.fu_Swap('d_matched_cases_caseprops', + &
									uo_matched_records.dw_matched_records.c_IgnoreChanges, &
									uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
									uo_matched_records.dw_matched_records.c_SelectOnScroll +&
									uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
									uo_matched_records.dw_matched_records.c_TabularFormStyle + &
									uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
									uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
									uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
									uo_matched_records.dw_matched_records.c_SortClickedOK )

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the Transaction Object and call the retrieve with the arguments.
//-----------------------------------------------------------------------------------------------------------------------------------
uo_matched_records.dw_matched_records.BringToTop = TRUE
uo_matched_records.dw_matched_records.SetTransObject(SQLCA)
ls_temp = uo_matched_records.dw_matched_records.object.datawindow.syntax
ll_return = uo_matched_records.dw_matched_records.Retrieve(ls_casenumber, ls_caserep, ls_sourcetype, ls_source_name, ls_master_casenumber, ls_casetype, string(ldt_case_log_opendate), ls_casestatus, ls_dynamic1, ls_dynamic2, ls_dynamic3, ls_dynamic4, ls_dynamic5, ls_dynamic6, ls_category, 'N')

i_wParentWindow.dw_folder.fu_EnableTab (5)

If ll_return < 0 Then
	Return -1
Else
	Return ll_return
End If
end function

public subroutine of_reset_criteria ();////----------------------------------------------------------------------------------------------------------------------------------
////	Arguments:  None
////	Overview:   Reset the Search Criteria to the default values
////	Created by:	Joel White
////	History: 	2/17/2005 - First Created 
////-----------------------------------------------------------------------------------------------------------------------------------
//
//Datawindowchild l_dwcCaseRep
//long l_nReturn, ll_return
//
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// Restore the Datawindow to the original syntax 
////-----------------------------------------------------------------------------------------------------------------------------------
//ll_return = dw_search_criteria.Create(is_origingal_search_syntax)
////ll_return = uo_search_criteria.dw_search_criteria.InsertRow(0)
//
////ddlb_search_type.SelectItem ("Case",0)
//
////---------------------------------------------------------------------------------------
////		Swap datawindow objects for the search datawindow control
////---------------------------------------------------------------------------------------
//dw_search_criteria.DataObject = 'd_search_case'
//dw_search_criteria.Visible = TRUE
//dw_search_criteria.insertrow(0)
//
//
////--------------------------------------------------------------------------------------
////		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
////		record datawindow is uo_dw_main...
////--------------------------------------------------------------------------------------
//		uo_matched_records.dw_matched_records.fu_Swap('d_matched_cases', uo_matched_records.dw_matched_records.c_IgnoreChanges, &
//									uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
//									uo_matched_records.dw_matched_records.c_SelectOnScroll +&
//									uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
//									uo_matched_records.dw_matched_records.c_TabularFormStyle + &
//									uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
//									uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
//									uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
//									uo_matched_records.dw_matched_records.c_SortClickedOK )
//
//fu_resizeline ()
//
//i_cCriteriaColumn[1] = "case_number"
//i_cCriteriaColumn[2] = "case_log_case_rep"
//i_cCriteriaColumn[3] = "case_type"
//i_cCriteriaColumn[4] = "case_status_id"
//i_cCriteriaColumn[5] = "case_log_opnd_date"
//i_cCriteriaColumn[6] = "source_type"
//i_cCriteriaColumn[7] = "master_case_number"
//
//i_cSearchTable[1] = "cusfocus.case_log"
//i_cSearchTable[2] = "cusfocus.case_log"
//i_cSearchTable[3] = "cusfocus.case_log"
//i_cSearchTable[4] = "cusfocus.case_log"
//i_cSearchTable[5] = "cusfocus.case_log"
//i_cSearchTable[6] = "cusfocus.case_log"
//i_cSearchTable[7] = "cusfocus.case_log"
//
//i_cSearchColumn[1] = "case_number"
//i_cSearchColumn[2] = "case_log_case_rep"
//i_cSearchColumn[3] = "case_type"
//i_cSearchColumn[4] = "case_status_id"
//i_cSearchColumn[5] = "case_log_opnd_date"
//i_cSearchColumn[6] = "source_type"
//i_cSearchColumn[7] = "master_case_number"
//
////------------------------------------------------------------------------------------
////		Wire the Search object to uo_dw_main, load the Case Status and Case Types
////------------------------------------------------------------------------------------
//dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, i_cSearchTable[], i_cSearchColumn[], SQLCA)
//
//Error.i_FWError = dw_search_criteria.fu_LoadCode("case_type", &
//										"cusfocus.case_types", &
//										"case_type", &
//										"case_type_desc", &
//										"active = 'Y'", "")
//
//Error.i_FWError = dw_search_criteria.fu_LoadCode("case_status_id", &
//										"cusfocus.case_status", &
//										"case_status_id", &
//										"case_stat_desc", &
//										"active = 'Y'", "")
//
//Error.i_FWError = dw_search_criteria.fu_LoadCode("source_type", &
//										"cusfocus.source_types", &
//										"source_type", &
//										"source_desc", &
//										"active = 'Y'", "")
//
//l_nReturn = dw_search_criteria.GetChild('case_log_case_rep', l_dwcCaseRep)
//l_dwcCaseRep.SetTransObject(SQLCA)
//l_dwcCaseRep.Retrieve()

Datawindowchild ldwc_appeal_type, ldwc_service_type
long l_nReturn, ll_return


//-----------------------------------------------------------------------------------------------------------------------------------
// Restore the Datawindow to the original syntax 
//-----------------------------------------------------------------------------------------------------------------------------------
//ll_return = dw_search_criteria.Create(is_origingal_search_syntax)
//ll_return = dw_search_criteria.InsertRow(0)

IF dw_search_criteria.dataobject = "d_search_appeal" THEN
	
	dw_search_criteria.GetChild('appealtype', ldwc_Appeal_Type)
	ldwc_Appeal_Type.SetFilter("0 = 1")
	ldwc_Appeal_Type.Filter()

	dw_search_criteria.GetChild('service_type_id', ldwc_Service_Type)
	ldwc_Service_Type.SetFilter("0 = 1")
	ldwc_Service_Type.Filter()
	
	THIS.of_add_appeal_properties('','')
ELSE
	THIS.of_add_case_properties('','')
END IF
end subroutine

public function string of_add_appeal_properties (string as_data, string as_type);//-----------------------------------------------------------------------------------------------------------------------------------
// Variable Declarations
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_case_number, ls_appealcreatedby
long ll_appealheaderid, ll_appealtype, ll_appealheaderstatusid, ll_line_of_business_id, ll_service_type_id, ll_appealeventid, ll_key_word_1, ll_key_word_2
datetime	ldt_createddate, ldt_duedate, ldt_completeddate
long ll_return, ll_appealoutcome
string ls_created_date_type, ls_due_date_type, ls_completed_date_type
s_fieldproperties ls_null[]

datawindowchild ldwc_rep, ldwc_casetype, ldwc_status, ldwc_sourcetype
DATAWINDOWCHILD l_dwcAppealType, l_dwcAppealHeaderStatusID, l_dwcAppealCreatedBy, l_dwcAppealOutcome, l_dwcLOB, l_dwcServiceTypeID, l_dwcKeyword, l_dwcAppealEventID


//-----------------------------------------------------------------------------------------------------------------------------------
// Get the user input values
//-----------------------------------------------------------------------------------------------------------------------------------
ls_case_number = dw_search_criteria.GetItemString(1, 'case_number')
ls_appealcreatedby = dw_search_criteria.GetItemString(1, 'appealcreatedby')
ll_appealheaderid = dw_search_criteria.GetItemNumber(1, 'appealheaderid')
ll_appealtype = dw_search_criteria.GetItemNumber(1, 'appealtype')
ll_appealheaderstatusid = dw_search_criteria.GetItemNumber(1, 'appealheaderstatusid')
ll_appealoutcome = dw_search_criteria.GetItemNumber(1, 'appealoutcome')
ll_line_of_business_id = dw_search_criteria.GetItemNumber(1, 'line_of_business_id')
ll_service_type_id = dw_search_criteria.GetItemNumber(1, 'service_type_id')
ll_key_word_1 = dw_search_criteria.GetItemNumber(1, 'key_word_1')
ll_key_word_2 = dw_search_criteria.GetItemNumber(1, 'key_word_2')
ldt_createddate = dw_search_criteria.GetItemDateTime(1, 'appealcreateddate')
ldt_duedate = dw_search_criteria.GetItemDateTime(1, 'duedate')
ldt_completeddate = dw_search_criteria.GetItemDateTime(1, 'completeddate')
ll_appealeventid = Long(as_data)
ls_created_date_type = dw_search_criteria.GetItemString(1, 'created_date_type')
ls_due_date_type = dw_search_criteria.GetItemString(1, 'due_date_type')
ls_completed_date_type = dw_search_criteria.GetItemString(1, 'completed_date_type')

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the array that holds the fields
//-----------------------------------------------------------------------------------------------------------------------------------
i_wParentWindow.i_sSearchableCaseProps[] = ls_null[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function that will determine the fields to be added
//-----------------------------------------------------------------------------------------------------------------------------------
i_wParentWindow.of_get_appealprops(Long(as_data))

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the new fields to the windpw
//-----------------------------------------------------------------------------------------------------------------------------------
i_wParentWindow.of_add_appeal_properties()



//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 5.2.2005 	Get the New Case Prop DropDowns and Retrieve Them
//-----------------------------------------------------------------------------------------------------------------------------------
	Datawindowchild ldwc_caseprop
	long	ll_counter, ll_errorcheck
	string ls_column, ls_dataobject

	For	ll_counter = 1 to i_wparentwindow.i_nNumConfigFields
		If lower(i_wparentwindow.i_sSearchableCaseProps[ll_counter].dropdown) = 'y' Then
			ll_errorcheck = dw_search_criteria.GetChild(i_wparentwindow.i_sSearchableCaseProps[ll_counter].column_name, ldwc_caseprop)
			ls_column = i_wparentwindow.i_sSearchableCaseProps[ll_counter].column_name
			ls_dataobject = ldwc_caseprop.getsqlselect()
			ldwc_caseprop.SetTransObject(SQLCA)
			ll_errorcheck = ldwc_caseprop.Retrieve(Long(as_data), i_wparentwindow.i_sSearchableCaseProps[ll_counter].column_name)
		
			If ll_errorcheck = 0 Then
				ldwc_caseprop.InsertRow(0)
			End If
		End If
	Next
//-----------------------------------------------------------------------------------------------------------------------------------
// End JWhite Added 5.2.2005
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the newly created datawindow is visible and insert a row
//-----------------------------------------------------------------------------------------------------------------------------------
dw_search_criteria.Visible = TRUE
ll_return = dw_search_criteria.InsertRow(0)

//-----------------------------------------------------------------------------------------------------------------------------------
// Swap out the dataobject to use the datawindow with the stored proc & dynamic criteria
//-----------------------------------------------------------------------------------------------------------------------------------
uo_matched_records.dw_matched_records.fu_Swap('d_matched_appeals_props', + &
									uo_matched_records.dw_matched_records.c_IgnoreChanges, &
									uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
									uo_matched_records.dw_matched_records.c_SelectOnScroll +&
									uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
									uo_matched_records.dw_matched_records.c_TabularFormStyle + &
									uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
									uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
									uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
									uo_matched_records.dw_matched_records.c_SortClickedOK )

//dw_matched_records.fu_unwire(dw_matched_records)


//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the User input values
//-----------------------------------------------------------------------------------------------------------------------------------

		ll_Return = dw_search_criteria.GetChild('appealheaderstatusid', l_dwcAppealHeaderStatusID)
		l_dwcAppealHeaderStatusID.SetTransObject(SQLCA)
		l_dwcAppealHeaderStatusID.Retrieve()

		ll_Return = dw_search_criteria.GetChild('appealcreatedby', l_dwcAppealCreatedBy)
		l_dwcAppealCreatedBy.SetTransObject(SQLCA)
		l_dwcAppealCreatedBy.Retrieve()

		ll_Return = dw_search_criteria.GetChild('appealoutcome', l_dwcAppealOutcome)
		l_dwcAppealOutcome.SetTransObject(SQLCA)
		l_dwcAppealOutcome.Retrieve()

		ll_Return = dw_search_criteria.GetChild('service_type_id', l_dwcServiceTypeID)
		l_dwcServiceTypeID.SetTransObject(SQLCA)
		l_dwcServiceTypeID.Retrieve()
		IF IsNull(ll_service_type_id) THEN
			ll_Return = l_dwcServiceTypeID.SetFilter("0 = 1")
			ll_Return = l_dwcServiceTypeID.Filter()
		END IF

		ll_Return = dw_search_criteria.GetChild('appealtype', l_dwcAppealType)
		l_dwcAppealType.SetTransObject(SQLCA)
		l_dwcAppealType.Retrieve()
		IF IsNull(ll_appealtype) THEN
			ll_Return = l_dwcAppealType.SetFilter("0 = 1")
			ll_Return = l_dwcAppealType.Filter()
		ELSE
			ll_return = l_dwcServiceTypeID.SetFilter("line_of_business_id = " + String(ll_line_of_business_id) + " and appealtypeid = " + String(ll_appealtype))
			ll_Return = l_dwcServiceTypeID.Filter()
		END IF

		ll_Return = dw_search_criteria.GetChild('line_of_business_id', l_dwcLOB)
		l_dwcLOB.SetTransObject(SQLCA)
		l_dwcLOB.Retrieve()
		IF NOT IsNull(ll_line_of_business_id) THEN
			ll_return = l_dwcAppealType.SetFilter("line_of_business_id = " + String(ll_line_of_business_id) )
			ll_Return = l_dwcAppealType.Filter()
		END IF

		ll_Return = dw_search_criteria.GetChild('key_word_1', l_dwcKeyword)
		l_dwcKeyword.SetTransObject(SQLCA)
		l_dwcKeyword.Retrieve()

		ll_Return = dw_search_criteria.GetChild('key_word_2', l_dwcKeyword)
		l_dwcKeyword.SetTransObject(SQLCA)
		l_dwcKeyword.Retrieve()

		ll_Return = dw_search_criteria.GetChild('appealeventid', l_dwcAppealEventID)
		l_dwcAppealEventID.SetTransObject(SQLCA)
		l_dwcAppealEventID.Retrieve()

dw_search_criteria.SetItem(ll_return, 'case_number', ls_case_number)
dw_search_criteria.SetItem(ll_return, 'appealcreatedby', ls_appealcreatedby)
dw_search_criteria.SetItem(ll_return, 'appealheaderid', ll_appealheaderid)
dw_search_criteria.SetItem(ll_return, 'appealtype', ll_appealtype)
dw_search_criteria.SetItem(ll_return, 'appealheaderstatusid', ll_appealheaderstatusid)
dw_search_criteria.SetItem(ll_return, 'appealoutcome', ll_appealoutcome)
dw_search_criteria.SetItem(ll_return, 'line_of_business_id', ll_line_of_business_id)
dw_search_criteria.SetItem(ll_return, 'service_type_id', ll_service_type_id)
dw_search_criteria.SetItem(ll_return, 'key_word_1', ll_key_word_1)
dw_search_criteria.SetItem(ll_return, 'key_word_2', ll_key_word_2)
dw_search_criteria.SetItem(ll_return, 'appealcreateddate', ldt_createddate)
dw_search_criteria.SetItem(ll_return, 'duedate', ldt_duedate)
dw_search_criteria.SetItem(ll_return, 'completeddate', ldt_completeddate)
dw_search_criteria.SetItem(ll_return, 'appealeventid', ll_appealeventid)
dw_search_criteria.SetItem(ll_return, 'created_date_type', ls_created_date_type)
dw_search_criteria.SetItem(ll_return, 'due_date_type', ls_due_date_type)
dw_search_criteria.SetItem(ll_return, 'completed_date_type', ls_completed_date_type)


Return ''
end function

public function long of_retrieve_appeal ();string	ls_casenumber, ls_caserep, ls_sourcetype, ls_master_casenumber, ls_casetype
string	ls_casestatus, ls_dynamic1, ls_dynamic2, ls_dynamic3
string	ls_dynamic4, ls_dynamic5, ls_dynamic6, ls_temp
string ls_created_date_type, ls_due_date_type, ls_completed_date_type
long		ll_return, i, ll_appealoutcome
datetime	ldt_case_log_opendate
string ls_case_number, ls_appealcreatedby, ls_category
long ll_appealheaderid, ll_appealtype, ll_appealheaderstatusid, ll_line_of_business_id, ll_service_type_id, ll_appealeventid, ll_key_word_1, ll_key_word_2
datetime	ldt_createddate, ldt_duedate, ldt_completeddate


//-----------------------------------------------------------------------------------------------------------------------------------
// Get the user input values
//-----------------------------------------------------------------------------------------------------------------------------------
ls_case_number = dw_search_criteria.GetItemString(1, 'case_number')
ls_appealcreatedby = dw_search_criteria.GetItemString(1, 'appealcreatedby')
ll_appealheaderid = dw_search_criteria.GetItemNumber(1, 'appealheaderid')
ll_appealtype = dw_search_criteria.GetItemNumber(1, 'appealtype')
ll_appealheaderstatusid = dw_search_criteria.GetItemNumber(1, 'appealheaderstatusid')
ll_appealoutcome = dw_search_criteria.GetItemNumber(1, 'appealoutcome')
ll_line_of_business_id = dw_search_criteria.GetItemNumber(1, 'line_of_business_id')
ll_service_type_id = dw_search_criteria.GetItemNumber(1, 'service_type_id')
ll_key_word_1 = dw_search_criteria.GetItemNumber(1, 'key_word_1')
ll_key_word_2 = dw_search_criteria.GetItemNumber(1, 'key_word_2')
ldt_createddate = dw_search_criteria.GetItemDateTime(1, 'appealcreateddate')
ldt_duedate = dw_search_criteria.GetItemDateTime(1, 'duedate')
ldt_completeddate = dw_search_criteria.GetItemDateTime(1, 'completeddate')
ll_appealeventid = dw_search_criteria.GetItemNumber(1, 'appealeventid')
ls_created_date_type = dw_search_criteria.GetItemString(1, 'created_date_type')
ls_due_date_type = dw_search_criteria.GetItemString(1, 'due_date_type')
ls_completed_date_type = dw_search_criteria.GetItemString(1, 'completed_date_type')
ls_category = dw_search_criteria.GetItemString(1, 'category')

//-----------------------------------------------------------------------------------------------------------------------------------
// If the values are '' then set them to null so the stored proc. can deal with them.
//-----------------------------------------------------------------------------------------------------------------------------------
If	ls_case_number 				=		'' OR ls_case_number = '%%'		Then		SetNull(ls_case_number)			
If	ls_appealcreatedby 					= 		'' OR ls_appealcreatedby = '%%'		Then		SetNull(ls_appealcreatedby)		
//If	ls_appealoutcome 				= 		'' OR ls_appealoutcome = '%%'		Then		SetNull(ls_appealoutcome)		
If 	ls_created_date_type = '' Then SetNull(ls_created_date_type)
If 	ls_due_date_type = '' Then SetNull(ls_due_date_type)
If 	ls_completed_date_type = '' Then SetNull(ls_completed_date_type)
If	ls_category 				=		'' OR ls_category = '%%'		Then		SetNull(ls_category)			

//-----------------------------------------------------------------------------------------------------------------------------------
// Build the dynamic arguments to pass on to the stored proc.
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(i_wParentWindow.i_sSearchableCaseProps[]) > 0 Then
	For i = 1 to UpperBound(i_wParentWindow.i_sSearchableCaseProps[])
		IF i_wParentWindow.i_sSearchableCaseProps[i].edit_mask = '##/##/####' THEN
			ls_temp = String(dw_search_criteria.GetItemDate(1, i_wParentWindow.i_sSearchableCaseProps[i].column_name))
		ELSEIF i_wParentWindow.i_sSearchableCaseProps[i].edit_mask = '##/##/#### ##.##' THEN
			ls_temp = String(dw_search_criteria.GetItemDateTime(1, i_wParentWindow.i_sSearchableCaseProps[i].column_name))
		ELSE
			ls_temp = dw_search_criteria.GetItemString(1, i_wParentWindow.i_sSearchableCaseProps[i].column_name)
		END IF

		If i = 1 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic1	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic1	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 2 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic2	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic2	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 3 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic3	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic3	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 4 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic4	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic4	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 5 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic5	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic5	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		ElseIf i = 6 Then
			If Right(ls_temp, 1) = '%' Then
				ls_dynamic6	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' like "' +  Left(ls_temp, Len(ls_temp) - 1) + '%"'
			Else
				ls_dynamic6	=	i_wParentWindow.i_sSearchableCaseProps[i].column_name + ' = "' +  ls_temp + '"'
			End If
		End If
	Next
	
End If


uo_matched_records.dw_matched_records.fu_Swap('d_matched_appeals_props', + &
									uo_matched_records.dw_matched_records.c_IgnoreChanges, &
									uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
									uo_matched_records.dw_matched_records.c_SelectOnScroll +&
									uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
									uo_matched_records.dw_matched_records.c_TabularFormStyle + &
									uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
									uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
									uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
									uo_matched_records.dw_matched_records.c_SortClickedOK )

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the Transaction Object and call the retrieve with the arguments.
//-----------------------------------------------------------------------------------------------------------------------------------
uo_matched_records.dw_matched_records.BringToTop = TRUE
uo_matched_records.dw_matched_records.SetTransObject(SQLCA)
ls_temp = uo_matched_records.dw_matched_records.object.datawindow.syntax
ll_return = uo_matched_records.dw_matched_records.Retrieve(ls_case_number, &
	ls_appealcreatedby, &
	ll_appealoutcome, &
	ll_appealheaderid, &
	ll_appealheaderstatusid, &
	ll_line_of_business_id, &
	ll_appealtype, &
	ll_service_type_id, &
	ll_appealeventid, &
	ll_key_word_1, &
	ll_key_word_2, &
	ldt_createddate, &
	ldt_duedate, &
	ldt_completeddate, &
	ls_dynamic1, ls_dynamic2, ls_dynamic3, ls_dynamic4, ls_dynamic5, ls_dynamic6, &
	ls_created_date_type, ls_due_date_type, ls_completed_date_type, ls_category, 'N')

i_wParentWindow.dw_folder.fu_EnableTab (5)

If ll_return < 0 Then
	Return -1
Else
	Return ll_return
End If
end function

event pc_setoptions;
//***********************************************************************************************
// 
//  Event:   pc_setoptions
//  Purpose: To set the options for uo_dw_main, initialize the search arrays, and wire the Search 
//           Datawindow to uo_dw_main and disable the PowerClass object for no rows found via a 
//			  Search.
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  07/08/99 M. Caruso   Modified code to initialize the search window according to the default 
//                       search type.
//  07/12/99 M. Caruso   Added call to fw_buildfieldlist to set up configurable fields for the 
//                       datawindow.
//  07/16/99 M. Caruso   Moved calls to fw_buildfieldlist().
//  07/19/99 M. Caruso   Perform InsertRow after assigning datawindow object.  Call 
//                       fu_buildsearchlists.
//  07/22/99 M. Caruso   Move InsertRow after adding configured fields and the whole window 
//                       displays at one time.  Also, to prevent flicker, the default datawindow 
//							    object has been removed from the control and the control is set to 
//							    INVISIBLE.  Setting the Visible variable after the initialization was the 
//							    only was to prevent a nasty flicker.
//  07/29/99 M. Caruso   Removed call to fw_buildfieldlist for search type CASE
//  07/30/99 M. Caruso   Added c_NoMenuButtonActivation constant to all fu_swap calls to prevent 
//                       the datawindow from altering menu/toolbar settings.
//  08/12/99 M. Caruso   Removed "(All)" option from search criteria drop downs.
//  10/30/00 M. Caruso   Added resize service.
//  11/16/00 M. Caruso   Implemented the new click-sort routine on dw_matched_records.
//  01/13/01 M. Caruso   Initialize i_bInSearch.
//  04/16/01 C. Jackson  Add Source Type to Case Search (SCR 340)
//  7/3/2001 K. Claver   Modified to populate the provider type drop down using a drop
//								 a drop down datawindow.
//  10/17/2001 K. Claver Enhanced for registry.
//  07/07/03 M. Caruso   Added a call to fu_UpdateSearchResultsLabels () for each source type.
//  08/18/03 M. Caruso   Add '_rt' to the datawindow object name if Real-Time demographics is
//								 activated for the source type.
//***********************************************************************************************

STRING	l_sSearchType, l_cDataObject
LONG 		l_nReturn, ll_return
DATAWINDOWCHILD l_dwcCaseRep, l_dwcProviderType
DATAWINDOWCHILD l_dwcAppealType, l_dwcAppealHeaderStatusID, l_dwcAppealCreatedBy, l_dwcAppealOutcome, l_dwcLOB, l_dwcServiceTypeID, l_dwcKeyword, l_dwcAppealEventID

//Get the current user as will need throughout object for various tasks
THIS.i_cCurrUser = OBJCA.WIN.fu_GetLogin( SQLCA )

//Create the blob manipulator to handle the blobs for the user specific result sets
THIS.in_blob_manipulator = Create n_blob_manipulator

//Create the datastore to retrieve the information to retrieve the datawindow blob for the user
THIS.ids_syntax	= Create datastore
THIS.ids_syntax.Dataobject = 'd_data_syntaxstorage'
THIS.ids_syntax.SetTransObject(SQLCA)

//Create the datastore to contain the configurable result set fields
THIS.ids_results_fields = CREATE datastore
THIS.ids_results_fields.DataObject = 'd_tm_field_defs'
THIS.ids_results_fields.SetTransObject( SQLCA )

//Create the datastore to contain the display formats
THIS.ids_display_formats = CREATE datastore
THIS.ids_display_formats.DataObject = "dddw_display_formats"
THIS.ids_display_formats.SetTransObject( SQLCA )

SetPointer( Hourglass! )
uo_matched_records.Visible = FALSE

THIS.ids_syntax.Retrieve( THIS.i_cCurrUser )
THIS.ids_results_fields.Retrieve( )
THIS.ids_display_formats.Retrieve( )

//---------------------------------------------------------------------------------------
//		Initialize the search results datawindow.
//--------------------------------------------------------------------------------------
uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
		uo_matched_records.dw_matched_records.c_NullDW, & 
		uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
		uo_matched_records.dw_matched_records.c_SelectOnScroll +&
 		uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
 		uo_matched_records.dw_matched_records.c_TabularFormStyle + &
 		uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
 		uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
		uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
		uo_matched_records.dw_matched_records.c_SortClickedOK )
		
i_bInSearch = FALSE

IF Upper(gs_seachtype) = "NONE" OR IsNull( gs_SeachType ) OR Trim( gs_SeachType ) = "" THEN
	IF OBJCA.MGR.i_Source = "R" THEN
		RegistrySet( ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info\search type" ), "default", &
						 RegString!, "MEMBER" )
	ELSE
		SetProfileString (OBJCA.MGR.i_ProgINI,"Search Type","default","MEMBER")
	END IF
	gs_seachtype = "MEMBER"
END IF

CHOOSE CASE gs_seachtype
	CASE "MEMBER"
		//------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Member",0)
		
		//------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_consumer'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('C')    // build for (C)onsumer
		fu_displayfields ('C')
		dw_search_criteria.insertrow(0)
		dw_search_criteria.Visible = TRUE
		
		//-------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//-------------------------------------------------------------------------------------
		l_cDataObject = 'd_matched_consumers'
		// use the real-time version if needed.
		IF gs_rt_members = 'Y' THEN l_cDataObject = l_cDataObject + '_rt'
		
		uo_matched_records.dw_matched_records.fu_Swap(l_cDataObject, uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_NoQuery + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )

		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( l_cDataObject )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )

											
		fu_UpdateSearchResultsLabels ('C')
		fu_resizeline ()
		fu_buildsearchlists('C')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main (if not real-time).
		//------------------------------------------------------------------------------------
		
		IF gs_rt_members = 'N' THEN
			dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
					i_cSearchTable[], i_cSearchColumn[], SQLCA)
		END IF
		
	CASE "GROUP"
		//---------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//--------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Group",0)
		
		//---------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_employer'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('E')    // build for (E)mployer Group
		fu_displayfields ('E')
		dw_search_criteria.insertrow(0)   // This actually makes the datawindow visible
		dw_search_criteria.Visible = TRUE
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//-------------------------------------------------------------------------------------
		l_cDataObject = 'd_matched_employers'
		// use the real-time version if needed.
		IF gs_rt_groups = 'Y' THEN l_cDataObject = l_cDataObject + '_rt'
		
		uo_matched_records.dw_matched_records.fu_Swap(l_cDataObject, uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )
											
		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( l_cDataObject )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )
													
		fu_UpdateSearchResultsLabels ('E')
		fu_resizeline ()
		fu_buildsearchlists('E')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main (if not real-time).
		//------------------------------------------------------------------------------------
		IF gs_rt_groups = 'N' THEN
			dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
					i_cSearchTable[], i_cSearchColumn[], SQLCA)
		END IF
		
	CASE "PROVIDER"
		//---------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//--------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Provider",0)
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_provider'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('P')    // build for (P)rovider
		fu_displayfields ('P')
		dw_search_criteria.insertrow(0)   // This actually makes the datawindow visible
		dw_search_criteria.Visible = TRUE
		
		//-------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		l_cDataObject = 'd_matched_providers'
		// use the real-time version if needed.
		IF gs_rt_providers = 'Y' THEN l_cDataObject = l_cDataObject + '_rt'
		
		uo_matched_records.dw_matched_records.fu_Swap(l_cDataObject, uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )
											
		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( l_cDataObject )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )											
											
		fu_UpdateSearchResultsLabels ('P')
		fu_resizeline ()
		fu_buildsearchlists('P')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main (if not real-time) and load the Provider types
		//------------------------------------------------------------------------------------
		IF gs_rt_providers = 'N' THEN
			dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
					i_cSearchTable[], i_cSearchColumn[], SQLCA)
		END IF
		
		dw_search_criteria.GetChild( "provider_type", l_dwcProviderType )
		l_dwcProviderType.SetTransObject( SQLCA )
		l_dwcProviderType.Retrieve( )
		
//		Error.i_FWError = dw_search_criteria.fu_LoadCode("provider_type", &
//												"cusfocus.provider_types", &
//												"provider_type", &
//												"provid_type_desc", &
//												"active='Y'", "")
		
	CASE "OTHER"
		//---------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//--------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Other",0)
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_other'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('O')    // Build for (O)ther
		fu_displayfields ('O')
		dw_search_criteria.insertrow(0)   // This actually makes the datawindow visible
		dw_search_criteria.Visible = TRUE
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		uo_matched_records.dw_matched_records.fu_Swap('d_matched_others', uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )
											
		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( "d_matched_others" )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )											
											
		fu_UpdateSearchResultsLabels ('O')
		fu_resizeline ()
		fu_buildsearchlists('O')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main and Load the customer types
		//------------------------------------------------------------------------------------
		dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
			i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("customer_type", &
												"cusfocus.customer_types", &
												"customer_type", &
												"cust_type_desc", &
												"active='Y'", "")
		
	CASE "CASE"
		//---------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//--------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Case",0)
		
		//---------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//---------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_case'
		dw_search_criteria.Visible = TRUE
		dw_search_criteria.insertrow(0)

		
		is_origingal_search_syntax = dw_search_criteria.Object.DataWindow.Syntax
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		uo_matched_records.dw_matched_records.fu_Swap('d_matched_cases', uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )
											
		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( "d_matched_cases" )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )											
		
		fu_resizeline ()
		
		i_cCriteriaColumn[1] = "case_number"
		i_cCriteriaColumn[2] = "case_log_case_rep"
		i_cCriteriaColumn[3] = "case_type"
		i_cCriteriaColumn[4] = "case_status_id"
		i_cCriteriaColumn[5] = "case_log_opnd_date"
		i_cCriteriaColumn[6] = "source_type"
		i_cCriteriaColumn[7] = "master_case_number"
		
		i_cSearchTable[1] = "cusfocus.case_log"
		i_cSearchTable[2] = "cusfocus.case_log"
		i_cSearchTable[3] = "cusfocus.case_log"
		i_cSearchTable[4] = "cusfocus.case_log"
		i_cSearchTable[5] = "cusfocus.case_log"
		i_cSearchTable[6] = "cusfocus.case_log"
		i_cSearchTable[7] = "cusfocus.case_log"
		
		i_cSearchColumn[1] = "case_number"
		i_cSearchColumn[2] = "case_log_case_rep"
		i_cSearchColumn[3] = "case_type"
		i_cSearchColumn[4] = "case_status_id"
		i_cSearchColumn[5] = "case_log_opnd_date"
		i_cSearchColumn[6] = "source_type"
		i_cSearchColumn[7] = "master_case_number"
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main, load the Case Status and Case Types
		//------------------------------------------------------------------------------------
		dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
			i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("case_type", &
												"cusfocus.case_types", &
												"case_type", &
												"case_type_desc", &
												"active = 'Y'", "")
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("case_status_id", &
												"cusfocus.case_status", &
												"case_status_id", &
												"case_stat_desc", &
												"active = 'Y'", "")
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("source_type", &
												"cusfocus.source_types", &
												"source_type", &
												"source_desc", &
												"active = 'Y'", "")
		
		l_nReturn = dw_search_criteria.GetChild('case_log_case_rep', l_dwcCaseRep)
		l_dwcCaseRep.SetTransObject(SQLCA)
		l_dwcCaseRep.Retrieve()
		
CASE "APPEAL"
	
		//------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Appeal",0)

		//---------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//---------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_appeal'
		dw_search_criteria.insertrow(0)
		
		is_origingal_search_syntax = dw_search_criteria.Object.DataWindow.Syntax

		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		
		uo_matched_records.dw_matched_records.fu_Swap('d_matched_appeals_props', uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )
											
		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( 'd_matched_appeals_props' )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )
		
		fu_resizeline ()
		
		i_cCriteriaColumn[1] = "case_number"
		i_cCriteriaColumn[2] = "appealheaderid"
		i_cCriteriaColumn[3] = "appealtype"
		i_cCriteriaColumn[4] = "appealheaderstatusid"
		i_cCriteriaColumn[5] = "appealcreatedby"
		i_cCriteriaColumn[6] = "appealcreateddate"
		i_cCriteriaColumn[7] = "appealoutcome"
		i_cCriteriaColumn[8] = "duedate"
		i_cCriteriaColumn[9] = "completeddate"
		i_cCriteriaColumn[10] = "line_of_business_id"
		i_cCriteriaColumn[11] = "service_type_id"
		i_cCriteriaColumn[12] = "key_word_1"
		i_cCriteriaColumn[13] = "key_word_2"
		i_cCriteriaColumn[14] = "appealeventid"
		
		i_cSearchColumn[1] = "case_number"
		i_cSearchColumn[2] = "appealheaderid"
		i_cSearchColumn[3] = "appealtype"
		i_cSearchColumn[4] = "appealheaderstatusid"
		i_cSearchColumn[5] = "appealcreatedby"
		i_cSearchColumn[6] = "appealcreateddate"
		i_cSearchColumn[7] = "appealoutcome"
		i_cSearchColumn[8] = "duedate"
		i_cSearchColumn[9] = "completeddate"
		i_cSearchColumn[10] = "line_of_business_id"
		i_cSearchColumn[11] = "service_type_id"
		i_cSearchColumn[12] = "key_word_1"
		i_cSearchColumn[13] = "key_word_2"
		i_cSearchColumn[14] = "appealeventid"
		
		i_cSearchTable[1] = "cusfocus.appealheader"
		i_cSearchTable[2] = "cusfocus.appealheader"
		i_cSearchTable[3] = "cusfocus.appealheader"
		i_cSearchTable[4] = "cusfocus.appealheader"
		i_cSearchTable[5] = "cusfocus.appealheader"
		i_cSearchTable[6] = "cusfocus.appealheader"
		i_cSearchTable[7] = "cusfocus.appealheader"
		i_cSearchTable[8] = "cusfocus.appealheader"
		i_cSearchTable[9] = "cusfocus.appealheader"
		i_cSearchTable[10] = "cusfocus.appealheader"
		i_cSearchTable[11] = "cusfocus.appealheader"
		i_cSearchTable[12] = "cusfocus.appealheader"
		i_cSearchTable[13] = "cusfocus.appealheader"
		i_cSearchTable[14] = "cusfocus.appealevent"
		
		m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main, load the Case Status and Case Types
		//------------------------------------------------------------------------------------
		dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
			i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
	
		l_nReturn = dw_search_criteria.GetChild('appealtype', l_dwcAppealType)
		l_dwcAppealType.SetTransObject(SQLCA)
		ll_return = l_dwcAppealType.Retrieve()
		ll_return = l_dwcAppealType.SetFilter("0 = 1")
		ll_return = l_dwcAppealType.Filter()

		l_nReturn = dw_search_criteria.GetChild('appealheaderstatusid', l_dwcAppealHeaderStatusID)
		l_dwcAppealHeaderStatusID.SetTransObject(SQLCA)
		l_dwcAppealHeaderStatusID.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('appealcreatedby', l_dwcAppealCreatedBy)
		l_dwcAppealCreatedBy.SetTransObject(SQLCA)
		l_dwcAppealCreatedBy.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('appealoutcome', l_dwcAppealOutcome)
		l_dwcAppealOutcome.SetTransObject(SQLCA)
		l_dwcAppealOutcome.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('line_of_business_id', l_dwcLOB)
		l_dwcLOB.SetTransObject(SQLCA)
		l_dwcLOB.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('service_type_id', l_dwcServiceTypeID)
		l_dwcServiceTypeID.SetTransObject(SQLCA)
		ll_return = l_dwcServiceTypeID.Retrieve()
		ll_return = l_dwcServiceTypeID.SetFilter("0 = 1")
		ll_return = l_dwcServiceTypeID.Filter()
		
		l_nReturn = dw_search_criteria.GetChild('key_word_1', l_dwcKeyword)
		l_dwcKeyword.SetTransObject(SQLCA)
		l_dwcKeyword.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('key_word_2', l_dwcKeyword)
		l_dwcKeyword.SetTransObject(SQLCA)
		l_dwcKeyword.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('appealeventid', l_dwcAppealEventID)
		l_dwcAppealEventID.SetTransObject(SQLCA)
		l_dwcAppealEventID.Retrieve()

END CHOOSE

//------------------------------------------------------------------------------------
//    Complete initialization of variables and available Tabs.
//------------------------------------------------------------------------------------
i_wParentWindow.i_cCurrentCaseSubject = ''
i_wParentWindow.i_cSelectedCase = ''
i_wParentWindow.i_cCaseSubjectName = ''

i_wParentWindow.dw_folder.fu_DisableTab(3)  // remove when this tab is defined.
i_wParentWindow.dw_folder.fu_DisableTab(5)
i_wParentWindow.dw_folder.fu_DisableTab(6)
i_wParentWindow.dw_folder.fu_DisableTab(7)
i_wParentWindow.dw_folder.fu_DisableTab(8)

IF (uo_matched_records.dw_matched_records.RowCount() > 0) THEN
	i_wParentWindow.dw_folder.fu_EnableTab(2)
//	i_wParentWindow.dw_folder.fu_EnableTab(3)
	i_wParentWindow.dw_folder.fu_EnableTab(4)
ELSE
	i_wParentWindow.dw_folder.fu_DisableTab(2)
//	i_wParentWindow.dw_folder.fu_DisableTab(3)
	i_wParentWindow.dw_folder.fu_DisableTab(4)
END IF

i_wParentWindow.Title = i_wParentWindow.Tag

m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled = FALSE
m_create_maintain_case.m_file.m_printcasedetailreport.Enabled = FALSE

dw_search_criteria.SetFocus()

OBJCA.MSG.fu_SetMessage("ZeroSearchRows", OBJCA.MSG.c_MSG_Status, "0")

// initialize resize service for this container object
of_SetResize (TRUE)
IF IsValid (inv_resize) THEN
	inv_resize.of_Register (dw_search_criteria, "ScaleToRight")
	inv_resize.of_Register (uo_matched_records, "ScaleToRight&Bottom")
	inv_resize.of_Register (gb_search_criteria, "ScaleToRight")
END IF

uo_matched_records.Visible = TRUE
SetPointer( Arrow! )
end event

on u_search_criteria.create
int iCurrent
call super::create
this.uo_matched_records=create uo_matched_records
this.st_search_type=create st_search_type
this.ddlb_search_type=create ddlb_search_type
this.dw_search_criteria=create dw_search_criteria
this.dw_case_detail_report=create dw_case_detail_report
this.gb_search_criteria=create gb_search_criteria
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_matched_records
this.Control[iCurrent+2]=this.st_search_type
this.Control[iCurrent+3]=this.ddlb_search_type
this.Control[iCurrent+4]=this.dw_search_criteria
this.Control[iCurrent+5]=this.dw_case_detail_report
this.Control[iCurrent+6]=this.gb_search_criteria
end on

on u_search_criteria.destroy
call super::destroy
destroy(this.uo_matched_records)
destroy(this.st_search_type)
destroy(this.ddlb_search_type)
destroy(this.dw_search_criteria)
destroy(this.dw_case_detail_report)
destroy(this.gb_search_criteria)
end on

event pc_close;call super::pc_close;//*********************************************************************************************
//
//  Event:   pc_close
//  Purpose: To provide opportunity to do processing before the window closes
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/21/2005 K. Claver Added code to destroy the blob manipulator object
//  10/22/2005 K. Claver Added code to save the datawindow syntax datastore
//*********************************************************************************************

//Save the datawindow syntax
THIS.ids_syntax.Update()

//Destroy the blob manipulator nvo if is still instantiated
IF IsValid( THIS.in_blob_manipulator ) THEN
	DESTROY THIS.in_blob_manipulator
END IF

//Destroy the result set configurable fields datastore
IF IsValid( THIS.ids_results_fields ) THEN
	DESTROY THIS.ids_results_fields
END IF

//Destroy the display formats datastore
IF IsValid( THIS.ids_display_formats ) THEN
	DESTROY THIS.ids_display_formats
END IF

//Destroy the syntax datastore
IF IsValid( THIS.ids_syntax ) THEN
	DESTROY THIS.ids_syntax
END IF
end event

type uo_matched_records from u_matched_records within u_search_criteria
event destroy ( )
integer x = 14
integer y = 932
integer width = 3557
integer height = 616
integer taborder = 40
end type

on uo_matched_records.destroy
call u_matched_records::destroy
end on

event constructor;call super::constructor;// Tie objects together
THIS.of_set_parent(PARENT)
THIS.dw_matched_records.i_window = PARENT.i_wParentWindow
end event

type st_search_type from statictext within u_search_criteria
integer x = 50
integer y = 48
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "Search Type:"
boolean focusrectangle = false
end type

type ddlb_search_type from dropdownlistbox within u_search_criteria
integer x = 512
integer y = 32
integer width = 818
integer height = 440
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"Member","Group","Provider","Other","Case","Appeal"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;//*****************************************************************************************
//
//  Event:   selectionchanged
//  Purpose: Update the search screen to reflect the type of search to be conducted.
//	
//  Date     Developer    Description
//  -------- ------------ -----------------------------------------------------------------
//  07/07/99 M. Caruso    Created.
//  07/16/99 M. Caruso    Added calls to fw_buildfieldlist().
//  07/19/99 M. Caruso    Perform InsertRow after assigning datawindow object.  Call
//                        fu_buildsearchlists.
//  07/22/99 M. Caruso	  InsertRow moved to after fields are added to allow full display
//	                       at one time.
//  07/29/99 M. Caruso    Remove call to fw_buildfieldlist if search type = CASE
//  08/12/99 M. Caruso    Removed "(All)" option from search criteria drop downs.
//  04/05/00 C. Jackson   Disable m_closecase menu item for all search types except Case. 
//                        (SCR 493).
//  04/25/00 C. Jackson   moved all m_closecase.Enabled statements to just after fu_swap
//                        (SCR 493)
//  05/08/00 C. Jackson   Disable m_closecase menu item for Case search also (SCR 493).
//  12/07/00 M. Caruso    Added c_NoMenuButtonActivation option to the fu_Swap calls for
//								  uo_matched_records.dw_matched_records.
//	 04/11/01 K. Claver    Added code to disable the case tab if change search type.
//  04/16/01 C. Jackson   Add Source Type to Case Search (SCR 340)
//  7/3/2001 K. Claver    Modified to load Provider Type drop down with a drop down datawindow.
//  06/11/03 M. Caruso    Added a call to fu_UpdateSearchResultsLabels () for each source type.
//  08/18/03 M. Caruso    Add '_rt' to the datawindow object name if Real-Time demographics is
//								  activated for the source type.
//  12/04/03 M. Caruso    Corrected code to set _rt version of group results datawindow
//								  based on gs_rt_groups instead of gs_rt_providers.
//  12/11/03 M. Caruso    Corrected code to Wire search criteria of group results datawindow
//								  based on gs_rt_groups instead of gs_rt_providers.
//*****************************************************************************************

STRING	l_sSearchType, l_cDataObject
LONG 		l_nReturn
DATAWINDOWCHILD l_dwcCaseRep, l_dwcProviderType
DATAWINDOWCHILD l_dwcAppealType, l_dwcAppealHeaderStatusID, l_dwcAppealCreatedBy, l_dwcAppealOutcome, l_dwcLOB, l_dwcServiceTypeID, l_dwcKeyword, l_dwcAppealEventID
S_FIELDPROPERTIES ls_empty_properties[]

SetPointer( Hourglass! )
uo_matched_records.Visible = FALSE

//Save the results datawindow syntax before attempt to change the results datawindow
uo_matched_records.dw_matched_records.Event Trigger ue_saveDatawindow( )

// get the name of the search type selected.
gs_seachtype = Upper(Text(index))

//Reset the validation error display counter
PARENT.i_nDisplayCount = 0


CHOOSE CASE gs_seachtype
	CASE "MEMBER"
		//---------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_consumer'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('C')    // build for (C)onsumer
		fu_displayfields ('C')
		dw_search_criteria.insertrow(0)
		
		//-------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//-------------------------------------------------------------------------------------
		l_cDataObject = 'd_matched_consumers'
		// use the real-time version if needed.
		IF gs_rt_members = 'Y' THEN l_cDataObject = l_cDataObject + '_rt'
		
		uo_matched_records.dw_matched_records.fu_Swap(l_cDataObject, uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )

		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( l_cDataObject )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )
		
		fu_UpdateSearchResultsLabels ('C')
		
		fu_resizeline ()
      m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE											
		
		fu_buildsearchlists('C')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main (if not real-time).
		//------------------------------------------------------------------------------------
		IF gs_rt_members = 'N' THEN
			dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
					i_cSearchTable[], i_cSearchColumn[], SQLCA)
		END IF
			
		//------------------------------------------------------------------------------------
		//		Swap the dw_docs_quick_list datawindow on the Documents window if processing a 
		//		consumer and if the window is opened.
		//------------------------------------------------------------------------------------

		IF w_create_maintain_case.i_bDocsOpened THEN
		w_docs_quick_interface.dw_docs_quick_list.fu_Swap('d_docs_consumer_quick_list', w_docs_quick_interface.dw_docs_quick_list.c_IgnoreChanges, &
           w_docs_quick_interface.dw_docs_quick_list.c_NoRetrieveOnOpen + &
           w_docs_quick_interface.dw_docs_quick_list.c_TabularFormStyle + &
           w_docs_quick_interface.dw_docs_quick_list.c_NoActiveRowPointer + &
           w_docs_quick_interface.dw_docs_quick_list.c_NoInactiveRowPointer + &
           w_docs_quick_interface.dw_docs_quick_list.c_NoMenuButtonActivation )
			  
		m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE			  
			  
		END IF
		
	CASE "GROUP"
		//---------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_employer'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('E')    // build for (C)onsumer
		fu_displayfields ('E')
		dw_search_criteria.insertrow(0)
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//-------------------------------------------------------------------------------------
		l_cDataObject = 'd_matched_employers'
		// use the real-time version if needed.
		IF gs_rt_groups = 'Y' THEN l_cDataObject = l_cDataObject + '_rt'
		
		uo_matched_records.dw_matched_records.fu_Swap(l_cDataObject, uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )

		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( l_cDataObject )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )
		
		fu_UpdateSearchResultsLabels ('E')
		
		fu_resizeline ()
		m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE
		
		fu_buildsearchlists('E')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main (if not real-time).
		//------------------------------------------------------------------------------------
		IF gs_rt_groups = 'N' THEN
			dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
					i_cSearchTable[], i_cSearchColumn[], SQLCA)
		END IF
			
	CASE "PROVIDER"
		//--------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_provider'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('P')    // build for (C)onsumer
		fu_displayfields ('P')
		dw_search_criteria.insertrow(0)
		
		//-------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		l_cDataObject = 'd_matched_providers'
		// use the real-time version if needed.
		IF gs_rt_providers = 'Y' THEN l_cDataObject = l_cDataObject + '_rt'
		
		uo_matched_records.dw_matched_records.fu_Swap(l_cDataObject, uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )

		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( l_cDataObject )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )
											
		fu_UpdateSearchResultsLabels ('P')
		
		fu_resizeline ()
		m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE
		
		fu_buildsearchlists('P')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main (if not real-time) and load the Provider types
		//------------------------------------------------------------------------------------
		IF gs_rt_providers = 'N' THEN
			dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
					i_cSearchTable[], i_cSearchColumn[], SQLCA)
		END IF
			
		dw_search_criteria.GetChild( "provider_type", l_dwcProviderType )
		l_dwcProviderType.SetTransObject( SQLCA )
		l_dwcProviderType.Retrieve( )
		
//		Error.i_FWError = dw_search_criteria.fu_LoadCode("provider_type", &
//												"cusfocus.provider_types", &
//												"provider_type", &
//												"provid_type_desc", &
//												"active='Y'", "")
		
	CASE "OTHER"
		//--------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_other'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('O')    // build for (C)onsumer
		fu_displayfields ('O')
		dw_search_criteria.insertrow(0)
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		
		uo_matched_records.dw_matched_records.fu_Swap('d_matched_others', uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )

		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( "d_matched_others" )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )
											
		fu_UpdateSearchResultsLabels ('O')
		
		fu_resizeline ()
		m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE									
		
		fu_buildsearchlists('O')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main and Load the customer types
		//------------------------------------------------------------------------------------
		dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
			i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("customer_type", &
												"cusfocus.customer_types", &
												"customer_type", &
												"cust_type_desc", &
												"active='Y'", "")
												
	CASE "CASE"
		//---------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//---------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_case'
		dw_search_criteria.insertrow(0)
		
		is_origingal_search_syntax = dw_search_criteria.Object.DataWindow.Syntax

		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		
		uo_matched_records.dw_matched_records.fu_Swap('d_matched_cases', uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )
											
		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( 'd_matched_cases' )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )
		
		fu_resizeline ()
		
		i_cCriteriaColumn[1] = "case_number"
		i_cCriteriaColumn[2] = "case_log_case_rep"
		i_cCriteriaColumn[3] = "case_type"
		i_cCriteriaColumn[4] = "case_status_id"
		i_cCriteriaColumn[5] = "case_log_opnd_date"
		i_cCriteriaColumn[6] = "source_type"
		i_cCriteriaColumn[7] = "master_case_number"
		
		i_cSearchTable[1] = "cusfocus.case_log"
		i_cSearchTable[2] = "cusfocus.case_log"
		i_cSearchTable[3] = "cusfocus.case_log"
		i_cSearchTable[4] = "cusfocus.case_log"
		i_cSearchTable[5] = "cusfocus.case_log"
		i_cSearchTable[6] = "cusfocus.case_log"
		i_cSearchTable[7] = "cusfocus.case_log"
		
		i_cSearchColumn[1] = "case_number"
		i_cSearchColumn[2] = "case_log_case_rep"
		i_cSearchColumn[3] = "case_type"
		i_cSearchColumn[4] = "case_status_id"
		i_cSearchColumn[5] = "case_log_opnd_date"
		i_cSearchColumn[6] = "source_type"
		i_cSearchColumn[7] = "master_case_number"
		
		m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main, load the Case Status and Case Types
		//------------------------------------------------------------------------------------
		dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
			i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("case_type", &
												"cusfocus.case_types", &
												"case_type", &
												"case_type_desc", &
												"active = 'Y'", "")
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("case_status_id", &
												"cusfocus.case_status", &
												"case_status_id", &
												"case_stat_desc", &
												"active = 'Y'", "")
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("source_type", &
												"cusfocus.source_types", &
												"source_type", &
												"source_desc", &
												"active = 'Y'", "")
		
		l_nReturn = dw_search_criteria.GetChild('case_log_case_rep', l_dwcCaseRep)
		l_dwcCaseRep.SetTransObject(SQLCA)
		l_dwcCaseRep.Retrieve()

CASE "APPEAL"
		//---------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//---------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_appeal'
		dw_search_criteria.insertrow(0)
		
		is_origingal_search_syntax = dw_search_criteria.Object.DataWindow.Syntax

		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		
		uo_matched_records.dw_matched_records.fu_Swap('d_matched_appeals_props', uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_SelectOnScroll +&
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK )
											
		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( 'd_matched_appeals_props' )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_SelectOnScroll +&
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK )
		
		fu_resizeline ()
		
		i_cCriteriaColumn[1] = "case_number"
		i_cCriteriaColumn[2] = "appealheaderid"
		i_cCriteriaColumn[3] = "appealtype"
		i_cCriteriaColumn[4] = "appealheaderstatusid"
		i_cCriteriaColumn[5] = "appealcreatedby"
		i_cCriteriaColumn[6] = "appealcreateddate"
		i_cCriteriaColumn[7] = "appealoutcome"
		i_cCriteriaColumn[8] = "duedate"
		i_cCriteriaColumn[9] = "completeddate"
		i_cCriteriaColumn[10] = "line_of_business_id"
		i_cCriteriaColumn[11] = "service_type_id"
		i_cCriteriaColumn[12] = "key_word_1"
		i_cCriteriaColumn[13] = "key_word_2"
		i_cCriteriaColumn[14] = "appealeventid"
		
		i_cSearchColumn[1] = "case_number"
		i_cSearchColumn[2] = "appealheaderid"
		i_cSearchColumn[3] = "appealtype"
		i_cSearchColumn[4] = "appealheaderstatusid"
		i_cSearchColumn[5] = "appealcreatedby"
		i_cSearchColumn[6] = "appealcreateddate"
		i_cSearchColumn[7] = "appealoutcome"
		i_cSearchColumn[8] = "duedate"
		i_cSearchColumn[9] = "completeddate"
		i_cSearchColumn[10] = "line_of_business_id"
		i_cSearchColumn[11] = "service_type_id"
		i_cSearchColumn[12] = "key_word_1"
		i_cSearchColumn[13] = "key_word_2"
		i_cSearchColumn[14] = "appealeventid"
		
		i_cSearchTable[1] = "cusfocus.appealheader"
		i_cSearchTable[2] = "cusfocus.appealheader"
		i_cSearchTable[3] = "cusfocus.appealheader"
		i_cSearchTable[4] = "cusfocus.appealheader"
		i_cSearchTable[5] = "cusfocus.appealheader"
		i_cSearchTable[6] = "cusfocus.appealheader"
		i_cSearchTable[7] = "cusfocus.appealheader"
		i_cSearchTable[8] = "cusfocus.appealheader"
		i_cSearchTable[9] = "cusfocus.appealheader"
		i_cSearchTable[10] = "cusfocus.appealheader"
		i_cSearchTable[11] = "cusfocus.appealheader"
		i_cSearchTable[12] = "cusfocus.appealheader"
		i_cSearchTable[13] = "cusfocus.appealheader"
		i_cSearchTable[14] = "cusfocus.appealevent"
		
		m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main, load the Case Status and Case Types
		//------------------------------------------------------------------------------------
		dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
			i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
	
		l_nReturn = dw_search_criteria.GetChild('appealtype', l_dwcAppealType)
		l_dwcAppealType.SetTransObject(SQLCA)
		l_dwcAppealType.Retrieve()
		l_nreturn = l_dwcAppealType.SetFilter("0 = 1")
		l_nreturn = l_dwcAppealType.Filter()

		l_nReturn = dw_search_criteria.GetChild('appealheaderstatusid', l_dwcAppealHeaderStatusID)
		l_dwcAppealHeaderStatusID.SetTransObject(SQLCA)
		l_dwcAppealHeaderStatusID.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('appealcreatedby', l_dwcAppealCreatedBy)
		l_dwcAppealCreatedBy.SetTransObject(SQLCA)
		l_dwcAppealCreatedBy.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('appealoutcome', l_dwcAppealOutcome)
		l_dwcAppealOutcome.SetTransObject(SQLCA)
		l_dwcAppealOutcome.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('line_of_business_id', l_dwcLOB)
		l_dwcLOB.SetTransObject(SQLCA)
		l_dwcLOB.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('service_type_id', l_dwcServiceTypeID)
		l_dwcServiceTypeID.SetTransObject(SQLCA)
		l_dwcServiceTypeID.Retrieve()
		l_nreturn = l_dwcServiceTypeID.SetFilter("0 = 1")
		l_nreturn = l_dwcServiceTypeID.Filter()

		l_nReturn = dw_search_criteria.GetChild('key_word_1', l_dwcKeyword)
		l_dwcKeyword.SetTransObject(SQLCA)
		l_dwcKeyword.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('key_word_2', l_dwcKeyword)
		l_dwcKeyword.SetTransObject(SQLCA)
		l_dwcKeyword.Retrieve()

		l_nReturn = dw_search_criteria.GetChild('appealeventid', l_dwcAppealEventID)
		l_dwcAppealEventID.SetTransObject(SQLCA)
		l_dwcAppealEventID.Retrieve()

END CHOOSE

//------------------------------------------------------------------------------------
//    Complete initialization of variables and available Tabs.
//------------------------------------------------------------------------------------
i_wParentWindow.i_cCurrentCaseSubject = ''
SetNull( i_wParentWindow.i_cProviderKey )
SetNull( i_wParentWindow.i_nProviderKey )
i_wParentWindow.i_cSelectedCase = ''
i_wParentWindow.i_cCaseSubjectName = ''

i_wParentWindow.dw_folder.fu_DisableTab(3)      // remove when this tab is defined.
i_wParentWindow.dw_folder.fu_DisableTab(5)
i_wParentWindow.dw_folder.fu_DisableTab(6)
i_wParentWindow.dw_folder.fu_DisableTab(7)
i_wParentWindow.dw_folder.fu_DisableTab(8)

IF (uo_matched_records.dw_matched_records.RowCount() > 0) THEN
	i_wParentWindow.dw_folder.fu_EnableTab(2)
//	i_wParentWindow.dw_folder.fu_EnableTab(3)
	i_wParentWindow.dw_folder.fu_EnableTab(4)
ELSE
	i_wParentWindow.dw_folder.fu_DisableTab(2)
//	i_wParentWindow.dw_folder.fu_DisableTab(3)
	i_wParentWindow.dw_folder.fu_DisableTab(4)
END IF
i_wParentWindow.Title = i_wParentWindow.Tag

dw_search_criteria.SetFocus()

// Reset the documents window if it is opened
if w_create_maintain_case.i_bDocsOpened THEN
	w_docs_quick_interface.dw_docs_quick_list.Reset()
	w_docs_quick_interface.Title = 'Documents Quick Interface'
END IF

uo_matched_records.Visible = TRUE
SetPointer( Arrow! )

// Need to reset the searchable case props since appeal and case both use it
i_wParentWindow.i_sSearchableCaseProps = ls_empty_properties

RETURN 0
end event

type dw_search_criteria from u_dw_search within u_search_criteria
event ue_searchtrigger pbm_dwnkey
integer x = 32
integer y = 224
integer width = 3515
integer height = 660
integer taborder = 10
string dataobject = ""
boolean vscrollbar = true
boolean border = false
end type

event ue_searchtrigger;/****************************************************************************************

	Event:	ue_searchtrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	6/22/99  M. Caruso     Created.
	01/13/01 M. Caruso     Add check of i_bInSearch.
	01/15/01 M. Caruso     If ESC pressed during a search, cancel the search.
****************************************************************************************/

IF i_bInSearch THEN
	
	IF key = KeyEscape! THEN
		IF IsValid( PARENT.i_wParentWindow ) THEN
			IF Pos( Upper( PARENT.i_wParentWindow.Title ), "CREATE" ) > 0 THEN
				m_create_maintain_case.m_file.m_cancelsearch.TriggerEvent (clicked!)
			ELSE
				IF IsValid( w_cross_ref ) THEN
					w_cross_ref.Event Trigger ue_searchCancel( )
				END IF
			END IF
		END IF
	END IF

ELSE
	
	IF (key = KeyEnter!) THEN
		IF IsValid( PARENT.i_wParentWindow ) THEN
			IF Pos( Upper( PARENT.i_wParentWindow.Title ), "CREATE" ) > 0 THEN
				uo_matched_records.dw_matched_records.fu_activate() // Force this datawindow to be active
				m_create_maintain_case.m_file.m_search.TriggerEvent (clicked!)
			ELSE
				IF IsValid( w_cross_ref ) THEN
					w_cross_ref.Event Trigger ue_search( )
				END IF
			END IF
		END IF
	END IF
	
END IF
end event

event itemchanged;call super::itemchanged;//***********************************************************************************************
//
//  Event:   itemchanged
//  Purpose: Set the new flag on consumer id for use in Display Special Flags
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/23/00 C. Jackson  Original Version
//
//***********************************************************************************************

STRING l_cColumnName, ls_casetype, ls_sourcetype
long ll_return, ll_null, ll_line_of_business_id, ll_appeal_type_id
DATAWINDOWCHILD ldwc_appeal_type, ldwc_service_type

SetNull(ll_null)
l_cColumnName = THIS.GetColumnName () 

CHOOSE CASE l_cColumnName
	CASE 'consumer_id', 'group_id' , 'provider_id'
		w_create_maintain_case.i_bNew = TRUE
	Case 'case_type'
		//-----------------------------------------------------------------------------------------------------------------------------------
		//	JWhite	Added 6.22.2005
		//
		// When the Case Type Changes we need to disable the tabs to keep from getting into a tab with the wrong
		//	source type.
		//-----------------------------------------------------------------------------------------------------------------------------------
		i_wParentWindow.dw_folder.fu_DisableTab(2)
		i_wParentWindow.dw_folder.fu_DisableTab(3)
		i_wParentWindow.dw_folder.fu_DisableTab(4)
		i_wParentWindow.dw_folder.fu_DisableTab (5)
		
		If lower(gs_seachtype) = 'case' and not isNull(data) Then
			ls_casetype = data
			ls_sourcetype = this.GetItemString(1, 'source_type')
			
			If IsNull(ls_casetype) or IsNull(ls_sourcetype) Then
				//Do nothing as either the source type or case type isn't filled out. Need
				//both to retrieve the case properties fields
			Else
				i_wParentWindow.is_contacthistory_casetype = data
				of_add_case_properties(ls_sourcetype, 'source')
				this.setitem(1, 'case_type', data)
			End If
		End If
	Case 'source_type'
		//-----------------------------------------------------------------------------------------------------------------------------------
		//	JWhite	Added 6.22.2005
		//
		// When the Source Type Changes we need to disable the tabs to keep from getting into a tab with the wrong
		//	source type.
		//-----------------------------------------------------------------------------------------------------------------------------------
		i_wParentWindow.dw_folder.fu_DisableTab(2)
		i_wParentWindow.dw_folder.fu_DisableTab(3)
		i_wParentWindow.dw_folder.fu_DisableTab(4)
		i_wParentWindow.dw_folder.fu_DisableTab (5)
		
		If lower(gs_seachtype) = 'case' and not isNull(data) Then

			If IsNull(ls_casetype) or IsNull(ls_sourcetype) Then
				//Do nothing as either the source type or case type isn't filled out. Need
				//both to retrieve the case properties fields
			Else
				i_wParentWindow.is_contacthistory_casetype = this.GetItemString(1, 'case_type')
				of_add_case_properties(data, 'source')
			End If
		End If
	Case 'appealeventid'
		If lower(gs_seachtype) = 'appeal' and not isNull(data) Then
			of_add_appeal_properties(data, 'appeal')
		End If

	CASE 'line_of_business_id'
		GetChild('appealtype', ldwc_Appeal_Type)
		IF IsNull(row) THEN // Called from fu_buildsearch, not because the item actually changed
//			ll_line_of_business_id = THIS.Object.line_of_business_id[1]
//			ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id))
//			ll_return = ldwc_appeal_type.Filter()
		ELSE
			ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + data)
			ll_return = ldwc_appeal_type.Filter()
			ll_return = THIS.SetItem(row, "appealtype", ll_null)
			ll_return = THIS.SetItem(row, "service_type_id", ll_null)
		END IF
		
	CASE 'appealtype'
		GetChild('service_type_id', ldwc_Service_Type)
		ll_line_of_business_id = THIS.Object.line_of_business_id[1]
		ll_appeal_type_id = THIS.Object.appealtype[1]
		IF IsNull(row) THEN // Called from fu_buildsearch, not because the item actually changed
//			ll_return = ldwc_service_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id) + " and appealtypeid = " + String(ll_appeal_type_id))
		ELSE
			ll_return = ldwc_service_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id) + " and appealtypeid = " + data)
			ll_return = THIS.SetItem(row, "service_type_id", ll_null)
		END IF
		ll_return = ldwc_service_type.Filter()
END CHOOSE
end event

event po_validate;call super::po_validate;/****************************************************************************************
	Event:	po_Validate
	Purpose:	Please see PowerClass documentation for this event.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	7/25/2001 K. Claver    Added code to check the year on the opened date.  Had to add an
								  instance variable to ensure the error message only showed once
								  as this event is fired twice during the search process.  Didn't
								  have time to fully research.
	03/05/02 M. Caruso     Rewrote this code to better process date and string field
	                       validation.
****************************************************************************************/

STRING	l_cValue
DATETIME	l_dtValue

SetNull (l_dtValue)

CHOOSE CASE SearchColumn
	CASE 'case_log_opnd_date'
		IF NOT IsNull (SearchValue) AND SearchValue <> '' THEN
			
			l_cValue = SearchValue
			// validate the date
			i_SearchError = OBJCA.FIELD.fu_ValidateDate (l_cValue, 'mm/dd/yyyy', FALSE)
			IF i_SearchError = c_ValFailed THEN
				
				// prompt the user and NULL the field if validation failed
				MessageBox (gs_appname, 'The Date Opened field contains an invalid date.')
				SetItem (SearchRow, SearchColumn, l_dtValue)
				
			ELSE
				
				// verify the date is in a valid range
				IF YEAR (DATE (l_cValue)) < 1753 THEN
					
					// prompt the user and NULL the field if validation failed
					MessageBox( gs_AppName, 'Dates with years below 1753 are invalid.~r~n' + &
													'Please enter a different date to search on.')
					SetItem (SearchRow, SearchColumn, l_dtValue)
					i_SearchError = c_ValFailed
					
				ELSE
					
					// see if formatting was applied to the initial value
					IF l_cValue <> SearchValue THEN
						
						// update the value in the field if the format changed
						l_dtValue = DATETIME (DATE (l_cValue), TIME (l_cValue))
						SetItem (SearchRow, SearchColumn, l_dtValue)
						i_SearchError = c_ValFixed
						
					END IF
			
				END IF
				
			END IF
			
		END IF
		
	CASE 'consum_dob'
		IF NOT IsNull (SearchValue) AND SearchValue <> '' THEN
			
			l_cValue = SearchValue
			// validate the date
			i_SearchError = OBJCA.FIELD.fu_ValidateDate (l_cValue, 'mm/dd/yyyy', FALSE)
			IF i_SearchError = c_ValFailed THEN
				
				// prompt the user and NULL the field if validation failed
				MessageBox (gs_appname, 'The Date of Birth field contains an invalid date.')
				SetItem (SearchRow, SearchColumn, l_dtValue)
				
			ELSE
				
				// verify the date is in a valid range
				IF YEAR (DATE (l_cValue)) < 1753 THEN
					
					// prompt the user and NULL the field if validation failed
					MessageBox( gs_AppName, 'Dates with years below 1753 are invalid.~r~n' + &
													'Please enter a different date to search on.')
					SetItem (SearchRow, SearchColumn, l_dtValue)
					i_SearchError = c_ValFailed
					
				ELSE
					
					// see if formatting was applied to the initial value
					IF l_cValue <> SearchValue THEN
						
						// update the value in the field if the format changed
						l_dtValue = DATETIME (DATE (l_cValue), TIME (l_cValue))
						SetItem (SearchRow, SearchColumn, l_dtValue)
						i_SearchError = c_ValFixed
						
					END IF
			
				END IF
				
			END IF
			
		END IF
		
	CASE ELSE
		IF SearchValue = '' THEN
			
			// set the field value to NULL to ensure it is ignored 
			SetNull (l_cValue)
			SetItem (SearchRow, SearchColumn, l_cValue)
			i_SearchError = c_ValFixed
			
		ELSE
			i_SearchError = c_ValOK
		END IF
		
END CHOOSE


//CHOOSE CASE searchcolumn
//	CASE "case_log_opnd_date"
//		IF Year( Date( searchvalue ) ) < 1753 THEN
//			IF PARENT.i_nDisplayCount = 0 THEN
//				MessageBox( gs_AppName, "Dates with years below 1753 are invalid.~r~nPlease enter a different date to search on", StopSign!, OK! )
//				//Increment display counter to show already displayed error message
//				PARENT.i_nDisplayCount++
//			ELSE
//				//Reset the display counter after second pass
//				PARENT.i_nDisplayCount = 0
//			END IF
//			i_SearchError = c_ValFailed
//		END IF
//		
//	CASE "consum_dob"
//		IF Year( Date( searchvalue ) ) < 1753 THEN
//			IF PARENT.i_nDisplayCount = 0 THEN
//				MessageBox( gs_AppName, "Dates with years below 1753 are invalid.~r~nPlease enter a different date to search on", StopSign!, OK! )
//				//Increment display counter to show already displayed error message
//				PARENT.i_nDisplayCount++
//			ELSE
//				//Reset the display counter after second pass
//				PARENT.i_nDisplayCount = 0
//			END IF
//			i_SearchError = c_ValFailed
//		END IF
//END CHOOSE
end event

event constructor;call super::constructor

end event

type dw_case_detail_report from datawindow within u_search_criteria
boolean visible = false
integer x = 5
integer width = 3301
integer height = 1704
integer taborder = 20
string dataobject = "d_case_detail_history_report"
boolean livescroll = true
end type

event constructor;/****************************************************************************************
	Event:	constructor
	Purpose:	Set properties of the datawindow.
	
	Revisions:
	Date     Developer    Description
	======== ============ ================================================================
	01/13/01 M. Caruso    Set the application name in the header of the report.
****************************************************************************************/

Object.appname_t.Text = gs_appname
end event

type gb_search_criteria from groupbox within u_search_criteria
integer x = 9
integer y = 160
integer width = 3561
integer height = 740
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 79741120
string text = "Search Criteria"
end type

