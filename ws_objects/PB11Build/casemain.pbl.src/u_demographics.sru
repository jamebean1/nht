$PBExportHeader$u_demographics.sru
$PBExportComments$Demographics User Object
forward
global type u_demographics from u_container_std
end type
type dw_display_special_flags from u_dw_std within u_demographics
end type
type dw_demographics from u_dw_std within u_demographics
end type
type gb_specialflags from groupbox within u_demographics
end type
end forward

shared variables

end variables

global type u_demographics from u_container_std
integer width = 3579
integer height = 1600
boolean border = false
long backcolor = 79748288
dw_display_special_flags dw_display_special_flags
dw_demographics dw_demographics
gb_specialflags gb_specialflags
end type
global u_demographics u_demographics

type variables
STRING						i_cKeyValue
STRING						i_cApplyToMembers

INTEGER						i_nRecordConfidLevel

W_CREATE_MAINTAIN_CASE	i_wParentWindow





end variables

forward prototypes
public function integer fu_displayfields ()
public subroutine fu_setsecurity ()
end prototypes

public function integer fu_displayfields ();//*********************************************************************************************
//  Function:   fu_displayfields
//  Purpose:    Add the user configured fields for the current source type to the
//              datawindow.
//  Parameters: None
//  Returns:    LONG ->  0-success   1-failure
//                
//  Date     Developer     Description
//  -------- ----------- ----------------------------------------------------------------------
//  7/12/99  M. Caruso   Wrote the code to determine the last predefined field.
//  7/13/99  M. Caruso   Wrote the code to actually display new fields and labels.
//  7/16/99  M. Caruso   Corrected the code that updates the SQL select statement. Also removed 
//                       fu_retrieve call since this function will always be followed by a 
//                       retrieve.
//  8/13/99  M. Caruso   The Detail band of the datawindows is now resized by the code.
//  8/24/99  M. Caruso   Check if the field has an editmask before assigning validation
//                       expressions and error messages.
//  10/20/99 M. Caruso   Reworked entire script to handle variable width fields.
//  11/22/99 M. Caruso   Changed the field color to white and background mode to opaque.
//  07/07/00 C. Jackson  Add logic to only apply editmask to Other Source Types (SCR 689)
//  07/07/00 C. Jackson  Allow database updates on configurable fields only for Other Source 
//                       Types (SCR 706)
//  12/19/00 M. Caruso   Modified constants to properly balance the columns.
//  5/3/2001 K. Claver   Enhanced to add invisible fields so can use as arguments for IIM tabs.
//  06/10/03 M. Caruso   Added code to implement field re-labeling.
//  07/01/03 M. Caruso   Added code to update the city_state_zip_t combined label.
//  07/07/03 M. Caruso   Modified to call gf_AllowQuotesInLabels ().
//*********************************************************************************************

CONSTANT	INTEGER	col1labelX = 27
CONSTANT	INTEGER	col2labelX = 1010
CONSTANT	INTEGER	col3labelX = 1993
CONSTANT	INTEGER	col1cellX = 554
CONSTANT	INTEGER	col2cellX = 1537
CONSTANT	INTEGER	col3cellX = 2520
CONSTANT INTEGER  rightmargin = 3164
CONSTANT INTEGER	colwidth1 = 429
CONSTANT INTEGER	colwidth2 = 1412
CONSTANT INTEGER	colwidth3 = 2395
CONSTANT STRING	labelwidth = '500'
CONSTANT STRING	cellheight = '64'
CONSTANT INTEGER	charwidth = 40
CONSTANT INTEGER	y_offset = 92

LONG		l_nColCount, l_nMaxX, l_nMaxY, l_nX, l_nY, l_nIndex, l_nPos
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nNewColId, l_nTabSeq
INTEGER  l_nNewTabSeq, l_nNumChars, l_nCellWidth, l_nNextCellWidth
STRING	l_sColName, l_sModString, l_sMsg, l_cSyntax, l_cObjName, l_cVisible
STRING	l_cDisplayOnly, l_cNewLine, l_cLabelX, l_cCellX, l_cUpdate
STRING	l_cLabelName, l_cLabelText, l_cCity, l_cState, l_cZip

// determine the location of the last predefined column in the datawindow
l_nColCount = LONG (dw_demographics.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO l_nColCount
	IF dw_demographics.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = dw_demographics.Describe ('#' + STRING (l_nIndex) + '.Name')
		l_nX = INTEGER (dw_demographics.Describe("#" + STRING(l_nIndex) + '.X'))
		l_nY = INTEGER (dw_demographics.Describe("#" + STRING(l_nIndex) + '.Y'))
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
		l_nNewTabSeq = INTEGER (dw_demographics.Describe("#" + STRING(l_nIndex) + '.tabsequence'))
		IF l_nTabSeq < l_nNewTabSeq THEN
			l_nTabSeq = l_nNewTabSeq
		END IF
	END IF
NEXT

// determine if last field is in a group box and prep accordingly
l_sMsg = dw_demographics.Describe ("DataWindow.Objects")
l_nPos = 0
DO
	l_nIndex = l_nPos + 1
	l_nPos = pos (l_sMsg, "~t", l_nIndex)
	IF l_nPos > 0 THEN
		l_cObjName = Mid (l_sMsg, l_nIndex, (l_nPos - l_nIndex))
	ELSE
		l_cObjName = Mid (l_sMsg, l_nIndex)
	END IF
	IF pos (l_cObjName, "gb_") > 0 THEN
		l_nX = INTEGER (dw_demographics.Describe (l_cObjName + ".X"))
		l_nY = INTEGER (dw_demographics.Describe (l_cObjName + ".Y")) + &
				 INTEGER (dw_demographics.Describe (l_cObjName + ".Height"))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxY = l_nY
			l_nMaxX = col1cellX
			l_nLastCol = -1
		END IF
	END IF
LOOP WHILE pos (l_sMsg, "~t", l_nIndex) > 0

//DO WHILE pos (l_sMsg, "~t", l_nPos + 1) > 0
//	l_nIndex = l_nPos + 1
//	l_nPos = pos (l_sMsg, "~t", l_nPos + 1)
//	l_cObjName = Mid (l_sMsg, l_nIndex, (l_nPos - l_nIndex))
//	IF pos (l_cObjName, "gb_") > 0 THEN
//		l_nX = INTEGER (dw_demographics.Describe (l_cObjName + ".X"))
//		l_nY = INTEGER (dw_demographics.Describe (l_cObjName + ".Y")) + &
//				 INTEGER (dw_demographics.Describe (l_cObjName + ".Height"))
//		IF (l_nY > l_nMaxY) THEN
//			l_nMaxY = l_nY
//			l_nMaxX = col1cellX
//			l_nLastCol = -1
//		END IF
//	END IF
//LOOP

// determine location of first field to add
IF l_nLastCol = -1 THEN  // if the last field was in a group box
	l_nColNum = 1
ELSE
	l_nX = INTEGER (dw_demographics.Describe("#" + STRING(l_nLastCol) + '.X'))
	l_nY = INTEGER (dw_demographics.Describe("#" + STRING(l_nLastCol) + '.Y'))
	l_nWidth = INTEGER (dw_demographics.Describe("#" + STRING(l_nLastCol) + '.Width'))
	CHOOSE CASE (l_nX + l_nWidth)
		CASE IS > (col3labelX - 27)
			l_nColNum = 1
		CASE IS > (col2labelX - 27)
			l_nColNum = 3
		CASE ELSE
			l_nColNum = 2
	END CHOOSE
END IF

// add the new columns to the result set of the datawindow.
l_cSyntax = dw_demographics.Describe("DataWindow.Syntax")

// add the new fields
FOR l_nIndex = 1 TO i_wparentwindow.i_nNumConfigFields
	
	IF i_wparentwindow.i_sConfigurableField[l_nIndex].field_length = 0 THEN
		
		// skip over entries with field_length = 0 because they are for re-labeling only.
		CONTINUE
	
	ELSE
		// build the dbname parameter by combining the table and column names in dot notation.
		CHOOSE CASE i_wparentwindow.i_cSourceType
			CASE 'C'
				l_sColName = 'consumer.'+i_wparentwindow.i_sConfigurableField[l_nIndex].column_name
			CASE 'E'
				l_sColName = 'employer_group.'+i_wparentwindow.i_sConfigurableField[l_nIndex].column_name
			CASE 'P'
				l_sColName = 'provider_of_service.'+i_wparentwindow.i_sConfigurableField[l_nIndex].column_name
			CASE 'O'
				l_sColName = 'other_source.'+i_wparentwindow.i_sConfigurableField[l_nIndex].column_name
		END CHOOSE
		
		// determine the width of the field to be displayed and the next field as well
		CHOOSE CASE (i_wparentwindow.i_sConfigurableField[l_nIndex].field_length * charwidth)
			CASE IS <= colwidth1
				l_nCellWidth = colwidth1
			CASE IS <= colwidth2
				l_nCellWidth = colwidth2
			CASE ELSE
				l_nCellWidth = colwidth3
		END CHOOSE
		
		IF (l_nIndex < i_wparentwindow.i_nNumConfigFields) THEN
			CHOOSE CASE (i_wparentwindow.i_sConfigurableField[l_nIndex + 1].field_length * charwidth)
				CASE IS <= colwidth1
					l_nNextCellWidth = colwidth1
				CASE IS <= colwidth2
					l_nNextCellWidth = colwidth2
				CASE ELSE
					l_nNextCellWidth = colwidth3
			END CHOOSE
		ELSE
			l_nNextCellWidth = 0
		END IF
		
		// build the column definition and insert it into the syntax of the datawindow
		l_nPos = Pos (l_cSyntax, "~r~ntable(")
		DO WHILE Pos (l_cSyntax, "column=(", l_nPos + 1) > 0
			l_nPos = Pos (l_cSyntax, "column=(", l_nPos + 1)
		LOOP
		l_nPos = Pos (l_cSyntax, "~r~n", l_nPos + 1)
		l_cNewLine = "~r~n"
	
		// For Other Source Types, allow database updates
		IF i_wparentwindow.i_cSourceType = 'O' THEN
			l_sModString = 'column=(type=char(50) update=yes updatewhereclause=yes ' + &
								'name='+i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		ELSE 
			l_sModString = 'column=(type=char(50) update=yes updatewhereclause=yes ' + &
								'name='+i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		END IF
		
		uf_StringInsert(l_cSyntax, l_sModString, (l_nPos + 1))
		
		// update the SQL SELECT portion of the datawindow
		l_nPos = Pos (l_cSyntax, 'retrieve="')
		DO WHILE Pos (l_cSyntax, "COLUMN(NAME", l_nPos + 1) > 0
			l_nPos = Pos (l_cSyntax, "COLUMN(NAME", l_nPos + 1)
		LOOP
		l_nPos = Pos (l_cSyntax, ')', l_nPos + 1)
		l_sModString = ' COLUMN(NAME=~~"cusfocus.'+l_sColName+'~~")'
		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
		
		IF i_wparentwindow.i_sConfigurableField[l_nIndex].visible = "Y" THEN
			//Set the visible variable
			l_cVisible = "1"
			
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
					
					// determine which column is next
					CHOOSE CASE (col1cellX + l_nCellWidth)
						CASE IS <= (col2labelX - 27)
							IF (col2cellX + l_nNextCellWidth) <= rightmargin THEN
								l_nColNum = 2
							ELSE
								l_nColNum = 1
							END IF
							
						CASE IS <= (col3labelX - 27)
							IF (col3cellX + l_nNextCellWidth) <= rightmargin THEN
								l_nColNum = 3
							ELSE
								l_nColNum = 1
							END IF
							
						CASE ELSE
							l_nColNum = 1
							
					END CHOOSE
					
				CASE 2	// column 2 of 3-column display
					l_cLabelX = STRING (col2labelX)
					l_cCellX = STRING (col2cellX)
					
					// If col 2 overlaps col 3, set next column to be col 1
					CHOOSE CASE (col2cellX + l_nCellWidth)
						CASE IS <= (col3labelX - 27)
							IF (col3cellX + l_nNextCellWidth) <= rightmargin THEN
								l_nColNum = 3
							ELSE
								l_nColNum = 1
							END IF
							
						CASE ELSE
							l_nColNum = 1
							
					END CHOOSE
					
				CASE 3
					l_cLabelX = STRING (col3labelX)
					l_cCellX = STRING (col3cellX)
					l_nColNum = 1
					
			END CHOOSE
			
			// add the new column label
			l_nPos = Pos (l_cSyntax, "htmltable") - 1
			l_sModString = 'text(name='+i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+'_t band=detail ' + &
								'font.charset="0" font.face="Tahoma" ' + &
								'font.family="2" font.height="-8" font.pitch="2" font.weight="700" ' + &
								'background.mode="1" background.color="536870912" color="0" alignment="1" ' + &
								'border="0" x="'+l_cLabelX+'" y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" ' + &
								'width="'+labelwidth+'" text="'+i_wparentwindow.i_sConfigurableField[l_nIndex].field_label+':" )' + l_cNewLine
			uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
			
		ELSE
			l_cVisible = "0"
		END IF
			
		// prepare to add the new column
		l_nColCount = l_nColCount + 1
		IF l_nTabSeq > 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable
		
		IF i_wparentwindow.i_sConfigurableField[l_nIndex].display_only = 'Y' THEN
			l_cDisplayOnly = 'yes'
		ELSE
			l_cDisplayOnly = 'no'
		END IF	
		
		// add the correct type of field to the datawindow
		l_nPos = Pos (l_cSyntax, "htmltable") - 1
		
		IF IsNull(i_wparentwindow.i_sConfigurableField[l_nIndex].edit_mask) OR i_wparentwindow.i_cSourceType <> 'O' THEN
			// determine the value for edit.limit
			l_sModString = &
				'column(name='+i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
				'border="5" alignment="0" format="[general]" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
				'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
				'edit.codetable=no edit.displayonly=yes edit.hscrollbar=no ' + &
				'edit.imemode=0 edit.limit='+STRING (i_wparentwindow.i_sConfigurableField[l_nIndex].field_length)+' ' + &
				'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
				'edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="0" background.color="16777215" font.charset="0" ' + &
				'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
				'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
		ELSE
			l_sModString = &
				'column(name='+i_wparentwindow.i_sConfigurableField[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
				'border="5" alignment="0" format="'+i_wparentwindow.i_sConfigurableField[l_nIndex].display_format+'" ' + &
				'visible="'+l_cVisible+'" editmask.focusrectangle=no editmask.autoskip=no editmask.required=no ' + &
				'editmask.readonly='+l_cDisplayOnly+' editmask.codetable=no editmask.spin=no ' + &
				'editmask.mask="'+i_wparentwindow.i_sConfigurableField[l_nIndex].edit_mask+'" editmask.imemode=0 ' + &
				'criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="0" background.color="16777215" font.charset="0" ' + &
				'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
				'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
		END IF
		
		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
		
	END IF
	
NEXT

// resize the detail band if necessary
IF (l_nMaxY + 64) > LONG (dw_demographics.Object.Datawindow.Detail.Height) THEN

	l_nPos = Pos (l_cSyntax, "detail(height=") + 14
	l_nNumChars = Pos (l_cSyntax, " ", l_nPos) - l_nPos
	l_cSyntax = Replace (l_cSyntax, l_nPos, l_nNumChars, STRING (l_nMaxY + 76))
	
END IF

// re-initialize the datawindow
IF dw_demographics.Create (l_cSyntax, l_sMsg) <> 1 THEN
	MessageBox (gs_AppName, l_sMsg)
	RETURN -1
ELSE
	dw_demographics.SetTransObject(SQLCA)

	// add any validation rules and error messages that are defined for the columns and re-label fields as needed.
	FOR l_nIndex = 1 to i_wparentwindow.i_nNumConfigFields
		IF i_wparentwindow.i_sConfigurableField[l_nIndex].field_length = 0 THEN
		
			// apply the new label if appropriate
			l_cLabelName = i_wparentwindow.i_sConfigurableField[l_nIndex].column_name + "_t"
			IF dw_demographics.Describe (l_cLabelName + ".Text") <> "!" THEN
	
				// update the label in the preview window if the label item exists
				l_cLabelText = gf_AllowQuotesInLabels (i_wparentwindow.i_sConfigurableField[l_nIndex].field_label)
				dw_demographics.Modify (l_cLabelName + ".Text='" + l_cLabelText + ":'")
	
			END IF
			
			// get the parts of the combined label text
			IF Pos (l_cLabelName, '_city_t', 1) > 0 THEN l_cCity = l_cLabelText
			IF Pos (l_cLabelName, '_state_t', 1) > 0 THEN l_cState = l_cLabelText
			IF Pos (l_cLabelName, '_zip_t', 1) > 0 THEN l_cZip = l_cLabelText
			
		ELSEIF i_wparentwindow.i_cSourceType = 'O' THEN
			
			// apply other changes as needed
			l_sColName = i_wparentwindow.i_sConfigurableField[l_nIndex].column_name
			IF dw_demographics.Describe (l_sColName + ".EditMask.Mask") <> "" THEN
				IF i_wparentwindow.i_sConfigurableField[l_nIndex].validation_rule <> "" THEN
					l_sModString =  i_wparentwindow.i_sConfigurableField[l_nIndex].column_name + &
										'.Validation="'+i_wparentwindow.i_sConfigurableField[l_nIndex].validation_rule+'" '
					l_sMsg = dw_demographics.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation message for the current column.")
					END IF
				END IF
				IF i_wparentwindow.i_sConfigurableField[l_nIndex].error_msg <> "" THEN
					l_sModString = l_sModString + i_wparentwindow.i_sConfigurableField[l_nIndex].column_name + &
										'.ValidationMsg="'+i_wparentwindow.i_sConfigurableField[l_nIndex].error_msg+'" '
					l_sMsg = dw_demographics.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation error message for the current column.")
					END IF
				END IF
			END IF
		END IF
		
	NEXT
	
	// update the combined City, State, Zip label if it exists
	IF dw_demographics.Describe ("city_state_zip_t.Text") <> "!" THEN
		dw_demographics.Modify ("city_state_zip_t.Text='" + l_cCity + ', ' + l_cState + ', ' + l_cZip + ":'")
	END IF
	
	RETURN 0
END IF
end function

public subroutine fu_setsecurity ();//*********************************************************************************************
//
//  Function: fu_SetSecurity
//  Purpose:  Function to set the confidentiality level for the demographics record
//
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  02/28/01 K. Claver   Original Version.
//  07/20/01 C. Jackson  Correct retrieval of provider_key (SCR 2196)
//  10/2/2001 K. Claver  Added code to check the cursor row instance variable for the search
//								 datawindow before attempting to update the demographic security field.
//								 Also needed to add code to check that the search and demographic datawindows
//								 are sync'd for source type.
//	 08/27/03 M. Caruso   Added check for real-time demographics data objects when setting the
//								 confidentiality level.
//*********************************************************************************************
DWItemStatus l_dwisStatus
u_dw_std l_dwMatchedRecords
LONG l_nProviderKey

//Check if the value has changed.  Must check if the object's instance variables are null
//  as PB7 sees null variables as equal to not-null variables.
IF THIS.i_nRecordConfidLevel <> i_wParentWindow.i_nRecordConfidLevel OR &
	THIS.i_cApplyToMembers <> i_wParentWindow.i_cApplyToMembers OR &
	( IsNull( THIS.i_nRecordConfidLevel ) AND NOT IsNull( i_wParentWindow.i_nRecordConfidLevel ) ) OR & 
	( IsNull( THIS.i_cApplyToMembers ) AND NOT IsNull( i_wParentWindow.i_cApplyToMembers ) ) OR &
	( IsNull( i_wParentWindow.i_nRecordConfidLevel ) AND NOT IsNull( THIS.i_nRecordConfidLevel ) ) OR & 
	( IsNull( i_wParentWindow.i_cApplyToMembers ) AND NOT IsNull( THIS.i_cApplyToMembers ) ) THEN

	SetPointer( Hourglass! )

	CHOOSE CASE i_wParentWindow.i_cSourceType
		CASE i_wParentWindow.i_cSourceProvider
			IF dw_demographics.DataObject <> "d_demographics_other" THEN
				l_nProviderKey = LONG(i_wParentWindow.i_cCurrentCaseSubject)
				UPDATE cusfocus.provider_of_service
				SET cusfocus.provider_of_service.confidentiality_level = :i_wParentWindow.i_nRecordConfidLevel
				WHERE cusfocus.provider_of_service.provider_key = :l_nProviderKey
				USING SQLCA;
			END IF
			
		CASE i_wParentWindow.i_cSourceConsumer
			IF dw_demographics.DataObject <> "d_demographics_other" THEN
				UPDATE cusfocus.consumer
				SET cusfocus.consumer.confidentiality_level = :i_wParentWindow.i_nRecordConfidLevel
				WHERE cusfocus.consumer.consumer_id = :i_wParentWindow.i_cCurrentCaseSubject
				USING SQLCA;
			END IF
			
		CASE i_wParentWindow.i_cSourceEmployer
			IF dw_demographics.DataObject <> "d_demographics_other" THEN
				UPDATE cusfocus.employer_group
				SET cusfocus.employer_group.confidentiality_level = :i_wParentWindow.i_nRecordConfidLevel,
					 cusfocus.employer_group.apply_to_members = :i_wParentWindow.i_cApplyToMembers
				WHERE cusfocus.employer_group.group_id = :i_wParentWindow.i_cCurrentCaseSubject
				USING SQLCA;
						
				IF SQLCA.SQLCode <> 0 THEN
					MessageBox( gs_AppName, "Unable to set demographic security" )
					Error.i_FWError = c_Fatal
					RETURN
				END IF
				
				//Update consumer records with the same group id
				IF i_wParentWindow.i_cApplyToMembers = "Y" THEN
					UPDATE cusfocus.consumer
					SET cusfocus.consumer.confidentiality_level = :i_wParentWindow.i_nRecordConfidLevel
					WHERE cusfocus.consumer.group_id = :i_wParentWindow.i_cCurrentCaseSubject
					USING SQLCA;
				END IF
			END IF
		CASE i_wParentWindow.i_cSourceOther
			UPDATE cusfocus.other_source
			SET cusfocus.other_source.confidentiality_level = :i_wParentWindow.i_nRecordConfidLevel
			WHERE cusfocus.other_source.customer_id = :i_wParentWindow.i_cCurrentCaseSubject
			USING SQLCA;		
	END CHOOSE
	
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox( gs_AppName, "Unable to set demographic security" )
		Error.i_FWError = c_Fatal
	ELSE
		//Reset this object's instance variables
		THIS.i_nRecordConfidLevel = i_wParentWindow.i_nRecordConfidLevel
		THIS.i_cApplyToMembers = i_wParentWindow.i_cApplyToMembers
		
		//Check the status on the datawindow
		l_dwisStatus = dw_demographics.GetItemStatus( 1, 0, Primary! )
		//Now set the security.  If the record wasn't previously modified, set the
		//  security level field to notmodified.
		dw_demographics.Object.confidentiality_level[ 1 ] = THIS.i_nRecordConfidLevel
				
		IF l_dwisStatus = NotModified! THEN
			dw_demographics.SetItemStatus( 1, "confidentiality_level", Primary!, NotModified! )
		END IF
		
		//Set the display fields on the search tab
		IF IsValid( i_wParentWindow.uo_search_criteria ) THEN
			l_dwMatchedRecords = i_wParentWindow.uo_search_criteria.uo_matched_records.dw_matched_records
			
			//Set the apply to members for display
			IF l_dwMatchedRecords.DataObject = "d_matched_employers" AND &
				l_dwMatchedRecords.i_CursorRow > 0 AND &
				dw_demographics.DataObject <> "d_demographics_other" THEN
				l_dwMatchedRecords.Object.apply_to_members_display[ l_dwMatchedRecords.i_CursorRow ] = THIS.i_cApplyToMembers
			END IF	
			
			//For all others, set the confidentiality level for display
			IF ( l_dwMatchedRecords.DataObject = "d_matched_others" AND &
				  dw_demographics.DataObject = "d_demographics_other" ) OR &
				( ((l_dwMatchedRecords.DataObject = "d_matched_providers") OR &
					(l_dwMatchedRecords.DataObject = "d_matched_providers_rt")) AND &
				  dw_demographics.DataObject = "d_demographics_provider" ) OR & 
				( ((l_dwMatchedRecords.DataObject = "d_matched_consumers") OR &
					(l_dwMatchedRecords.DataObject = "d_matched_consumers_rt")) AND &
				  dw_demographics.DataObject = "d_demographics_consumer" ) OR &
				( ((l_dwMatchedRecords.DataObject = "d_matched_employers") OR &
					(l_dwMatchedRecords.DataObject = "d_matched_employers_rt")) AND &
				  dw_demographics.DataObject = "d_demographics_employer" ) THEN
				//Check if the row pointer is greater than zero for new other source.
				IF l_dwMatchedRecords.i_CursorRow > 0 THEN
					l_dwMatchedRecords.Object.confidentiality_level[ l_dwMatchedRecords.i_CursorRow ] = THIS.i_nRecordConfidLevel
				END IF
			END IF
		END IF	
	END IF
	
	SetPointer( Arrow! )
END IF
end subroutine

event pc_setoptions;call super::pc_setoptions;/****************************************************************************************
	Event: 	pc_setoptions
	Purpose:	To place on vertical scroll bar on the Case History DataWindow
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	9/21/00  M. Caruso     Commented line enabling VScrollBar for dw_case_history.
	10/30/00 M. Caruso     Removed old line and added resize code.
	01/02/01 M. Caruso     Reworked resize code to function properly.
	4/13/2001 K. Claver   Fixed the resize code.
****************************************************************************************/

INTEGER	l_nNewHeight, l_nHeightOffset, l_nWidthOffSet, l_nNewWidth

of_setresize (TRUE)
IF IsValid (inv_resize) THEN
	// calculate the resize ratio of the parent window from when it was created.
	IF i_wParentWindow.Width < 3579 THEN
		l_nWidthOffSet = 0
	ELSE
		l_nWidthOffSet = i_wParentWindow.Width - i_wParentWindow.i_nBaseWidth
	END IF
	
	IF i_wParentWindow.Height < 1600 THEN
		l_nHeightOffSet = 0
	ELSE
		l_nHeightOffSet = i_wParentWindow.Height - i_wParentWindow.i_nBaseHeight
	END IF
	
	// adjust the height of this container in case the window has been resized.
	l_nNewHeight = 1600 + l_nHeightOffset
	l_nNewWidth = 3579 + l_nWidthOffSet
	Resize (l_nNewWidth, l_nNewHeight)
	
	// adjust the position of this datawindow in case the window has been resized.
	inv_resize.of_Register (dw_demographics, "ScaleToBottom")
	l_nNewHeight = dw_demographics.Height + l_nHeightOffset
	dw_demographics.Resize (dw_demographics.Width, l_nNewHeight)
	
	//Register this object with the resize service
	i_wParentWindow.inv_resize.of_Register (THIS, "ScaleToRight&Bottom")
	
END IF
end event

on u_demographics.create
int iCurrent
call super::create
this.dw_display_special_flags=create dw_display_special_flags
this.dw_demographics=create dw_demographics
this.gb_specialflags=create gb_specialflags
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_display_special_flags
this.Control[iCurrent+2]=this.dw_demographics
this.Control[iCurrent+3]=this.gb_specialflags
end on

on u_demographics.destroy
call super::destroy
destroy(this.dw_display_special_flags)
destroy(this.dw_demographics)
destroy(this.gb_specialflags)
end on

type dw_display_special_flags from u_dw_std within u_demographics
event mousemove pbm_dwnmousemove
integer x = 3081
integer y = 76
integer width = 466
integer height = 376
integer taborder = 0
string dataobject = "d_display_special_flags"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event mousemove;STRING l_cData
LONG l_nRow

IF dwo.Type = "column" THEN
	l_cData = THIS.GetItemString(row,'special_flags_flag_desc')
	w_create_maintain_case.SetMicroHelp(l_cData)
ELSE
	w_create_maintain_case.SetMicroHelp('Ready')
END IF


end event

event pcd_setoptions;call super::pcd_setoptions;//***********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: to set options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  11/20/00 C. Jackson  Original Version
//
//***********************************************************************************************

THIS.fu_SetOptions( SQLCA, & 
						  THIS.c_NullDW, & 
						  THIS.c_NoMenuButtonActivation)
end event

event doubleclicked;//*******************************************************************************************
//
//  Event:   clicked
//  Purpose: to override ancestor code
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------
//  11/12/01 C. Jackson  Original Version
//
//*******************************************************************************************
end event

type dw_demographics from u_dw_std within u_demographics
event ue_setfocus pbm_custom01
integer y = 8
integer width = 3058
integer height = 1564
integer taborder = 10
string dataobject = "d_demographics_consumer"
boolean vscrollbar = true
boolean border = false
end type

event ue_setfocus;call super::ue_setfocus;SetFocus()
end event

event pcd_validatecol;call super::pcd_validatecol;/***************************************************************************************

	
			Event:	pcd_validatecol	
			Purpose:	To validate the phone numbers and zip codes.

**************************************************************************************/

CHOOSE CASE col_name

//------------------------------------------------------------------------------------
//
//		Check the fields with Phone Numbers
//
//------------------------------------------------------------------------------------

	CASE 'other_home_phone', 'other_alt_phone'
	   IF LEN(TRIM(col_text)) <> 7 AND LEN(TRIM(col_text)) <> 0 THEN
			MessageBox(gs_AppName, 'Please enter a valid phone number')
			Error.i_FWError = c_ValFailed
			PostEvent("ue_setfocus")
			RETURN
		END IF

//-----------------------------------------------------------------------------------
//
//		Check the fields with zip codes
//
//-----------------------------------------------------------------------------------

	CASE 'other_zip'
		IF LEN(TRIM(col_text)) <> 5 AND LEN(TRIM(col_text)) <> 9 AND &
				LEN(TRIM(col_text))<> 0 THEN
			Messagebox(gs_AppName, 'Please enter either a 5 or 9 digit Zip Code.')
			Error.i_FWError = c_ValFailed
			PostEvent("ue_setfocus")
			RETURN
		END IF

END CHOOSE

end event

event pcd_validaterow;call super::pcd_validaterow;IF in_save THEN
	IF THIS.DataObject = "d_demographics_other" THEN
 		THIS.SetItem(row_nbr,"other_zip",Trim(THIS.GetItemString(row_nbr,"other_zip")))
	END IF
END IF
end event

event pcd_savebefore;/****************************************************************************************

		Event:	pcd_savebefore
		Purpose: To validate that the Phone Numbers, Zip Codes are valid.  Also check to see
					if the user enetered a Customer Type
					
		Revisions:
		Date     Developer     Description
		======== ============= ============================================================
		6/17/99	M. Caruso     Set the i_CursorRow variable.  Ensures a valid row reference
		                       for processing this event script.

****************************************************************************************/
STRING l_cLastName, l_cFirstName, l_sDatawindowObject

l_sDatawindowObject = This.dataobject

i_CursorRow = GetRow()
IF ISNull(GetItemSTring(i_CursorRow, 'customer_type')) THEN
	MessageBox(gs_AppName, 'You must enter a Customer Type prior to saving a' + &
			' Case Subject.')
	Error.i_FWError = c_Fatal
	SetFocus()
	SetColumn('customer_type')
	RETURN
END IF
IF IsNull(GetItemString(i_CursorRow, 'other_name')) THEN
	IF IsNull(GetItemString(i_CursorRow, 'other_last_name')) AND IsNull(GetItemString(&
		i_CursorRow, 'other_first_name')) THEN
	
		MessageBox(gs_AppName, 'You must either enter a Name OR a Last Name and First Name' + &
			' to save a Case Subject.')
		Error.i_FWError = c_Fatal
		SetFocus()
		SEtColumn('other_name')
		RETURN
	ELSEIF IsNull(GetItemString(i_CursorRow, 'other_last_name')) THEN
		MessageBox(gs_AppName, 'You must enter a Last Name' + &
			' to save a Case Subject.')
		Error.i_FWError = c_Fatal
		SetFocus()
		SEtColumn('other_last_name')
		RETURN	
	ELSEIF IsNull(GetItemString(i_CursorRow, 'other_first_name')) THEN
		MessageBox(gs_AppName, 'You must enter a First Name' + &
			' to save a Case Subject.')
		Error.i_FWError = c_Fatal
		SetFocus()
		SEtColumn('other_first_name')
		RETURN		
	ELSE
		l_cLastName = GetItemSTring(i_CursorRow, 'other_last_name')
		l_cFirstName = GetItemString(i_CursorRow, 'other_first_name')

		SetItem(i_CursorRow, 'other_name', l_cLastName + ', ' + l_cFirstName)		
	END IF		
	
END IF

end event

event pcd_saveafter;/**************************************************************************************

		Event:	pcd_saveafter
		Purpose:	Get the New Case Subject and change the window title
		
4/6/2001 K. Claver   Added code to re-enable the case creation buttons after a successful
							save of an Other source type.

*************************************************************************************/


i_wParentWindow.i_cCaseSubjectName = GetItemSTring(i_CursorRow, 'other_name') 
i_wParentWindow.Title = i_wParentWindow.Tag + ' ' + i_wParentWindow.i_cCaseSubjectName
i_wParentWindow.i_bSearchCriteriaUpdate = TRUE

//Re-enable the menu items to create cases
m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled = TRUE
m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled = TRUE
m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled = TRUE
m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled = TRUE


end event

event pcd_setkey;call super::pcd_setkey;/***************************************************************************************

			Event:	pcd_setkey
			Purpose:	To get a key value for an Other Source Type

***************************************************************************************/

IF DataObject = 'd_demographics_other' THEN
	i_cKeyValue = i_wParentWindow.fw_GetKeyValue('other_source')
	SetItem(i_CursorRow,'customer_id', i_cKeyValue)
	i_wParentWindow.i_bNewCaseSubject = TRUE
	i_wParentWindow.i_cCurrentCaseSubject = i_cKeyValue
END IF 
end event

event pcd_retrieve;call super::pcd_retrieve;//********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: To retrieve the Demographics data on the Case Subject
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  07/13/01 C. Jackson  Add code to handle vendor cases
//  12/01/03 M. Caruso   Removed provider type retrieval argument from Retrieve statement for
// 							 provider searches.
//********************************************************************************************


LONG l_nReturn, l_nKeyValue

i_cKeyValue = i_wParentWindow.i_cCurrentCaseSubject
	
	//---------------------------------------------------------------------------------------
	//
	//		Determine if the SOurce Type is Provider of Service.  If so, then pass the Provider
	//		ID and the Provider Type as retrieval arguments, otherwise just pass an Source ID
	//		as the retrieval argument.
	//
	//---------------------------------------------------------------------------------------
	IF i_wParentWindow.i_cSourceType <> i_wParentWindow.i_cSourceProvider THEN
		l_nReturn = THIS.Retrieve(i_cKeyValue)
	ELSE
		l_nKeyValue = LONG(i_cKeyValue)
		l_nReturn = Retrieve(l_nKeyValue)
	END IF
	
	IF l_nReturn < 0 THEN 
		Error.i_FWError = c_Fatal
	ELSE
		IF THIS.RowCount( ) > 0 THEN
			//Populate the security variables for the parent object for comparison
			//  when changing security level.
			CHOOSE CASE i_wParentWindow.i_cSourceType
				CASE i_wParentWindow.i_cSourceProvider, i_wParentWindow.i_cSourceOther, i_wParentWindow.i_cSourceConsumer
					PARENT.i_nRecordConfidLevel = THIS.Object.confidentiality_level[ 1 ]
					SetNull( PARENT.i_cApplyToMembers )
				CASE i_wParentWindow.i_cSourceEmployer
					PARENT.i_nRecordConfidLevel = THIS.Object.confidentiality_level[ 1 ]
					PARENT.i_cApplyToMembers = THIS.Object.apply_to_members[ 1 ]
			END CHOOSE
		ELSE
			SetNull( PARENT.i_nRecordConfidLevel )
			SetNull( PARENT.i_cApplyToMembers )
		END IF
	END IF
	
	

end event

event pcd_new;call super::pcd_new;/***************************************************************************************

		Event:	pcd_new
		Purpose:	To set the ParentWindow Instance variable.

4/11/2001  K. Claver   Added code to disable the new case buttons until after a successful
							  save of this datawindow.

***************************************************************************************/
i_wParentWIndow.i_bNewCaseSubject = TRUE

//Disable the new case type menu items
m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled = FALSE
m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled = FALSE
m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled = FALSE
m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled = FALSE
end event

type gb_specialflags from groupbox within u_demographics
integer x = 3067
integer y = 8
integer width = 494
integer height = 464
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Special Flags"
end type

