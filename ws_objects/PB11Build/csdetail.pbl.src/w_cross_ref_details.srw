$PBExportHeader$w_cross_ref_details.srw
$PBExportComments$Cross Reference Details Window
forward
global type w_cross_ref_details from w_response_std
end type
type p_1 from picture within w_cross_ref_details
end type
type st_3 from statictext within w_cross_ref_details
end type
type st_2 from statictext within w_cross_ref_details
end type
type cb_close from commandbutton within w_cross_ref_details
end type
type dw_demographics from u_dw_std within w_cross_ref_details
end type
type ln_1 from line within w_cross_ref_details
end type
type ln_2 from line within w_cross_ref_details
end type
type st_1 from statictext within w_cross_ref_details
end type
type ln_3 from line within w_cross_ref_details
end type
type ln_4 from line within w_cross_ref_details
end type
end forward

global type w_cross_ref_details from w_response_std
integer width = 3186
integer height = 2068
event ue_selecttrigger pbm_dwnkey
p_1 p_1
st_3 st_3
st_2 st_2
cb_close cb_close
dw_demographics dw_demographics
ln_1 ln_1
ln_2 ln_2
st_1 st_1
ln_3 ln_3
ln_4 ln_4
end type
global w_cross_ref_details w_cross_ref_details

type variables
STRING i_cXRefSourceType
STRING i_cXRefSubjectID
STRING i_cXRefProvType
STRING i_cParent

LONG   i_nXRefProvKey

INT    i_nNumConfigFields

S_FIELDPROPERTIES	i_sConfigurableField[]


end variables

forward prototypes
public subroutine fw_sort_data ()
public subroutine fw_checkoutofoffice ()
public function long fw_buildfieldlist (string source_type)
public function integer fw_display_fields ()
end prototypes

public subroutine fw_sort_data ();
end subroutine

public subroutine fw_checkoutofoffice ();
end subroutine

public function long fw_buildfieldlist (string source_type);//*********************************************************************************************
//
//  Function: fw_buildfieldlist
//  Purpose:  Add defined configurable fields to the field list for the selected source type.
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  01/14/02 C. Jackson  Original Version
//*********************************************************************************************
  
U_DS_FIELD_LIST	l_dsFields
LONG					l_nCount, l_nColIndex

// retrieve the list of fields for source_type from the database.
l_dsFields = CREATE u_ds_field_list
l_dsFields.SetTransObject(SQLCA)
i_nNumConfigFields = l_dsFields.Retrieve(source_type)

// process the list of fields.
IF i_nNumConfigFields > 0 THEN
	FOR l_nCount = 1 to i_nNumConfigFields
		// get the column name associated with this field
		i_sConfigurableField[l_nCount].column_name = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_column_name")
		IF IsNull (i_sConfigurableField[l_nCount].column_name) OR &
			(Trim (i_sConfigurableField[l_nCount].column_name) = "") THEN
			i_sConfigurableField[l_nCount].column_name = ""
		END IF
		
		// get the column label associated with this field
		i_sConfigurableField[l_nCount].field_label = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_field_label")
		IF IsNull (i_sConfigurableField[l_nCount].field_label) OR &
			(Trim (i_sConfigurableField[l_nCount].field_label) = "") THEN
			i_sConfigurableField[l_nCount].field_label = ""
		END IF
		
		// get the field width associated with this field
		i_sConfigurableField[l_nCount].field_length = l_dsFields.GetItemNumber(l_nCount, &
					"field_definitions_field_length")
		IF IsNull (i_sConfigurableField[l_nCount].field_length) THEN
			i_sConfigurableField[l_nCount].field_length = 50
		END IF
		
		// get the "locked" parameter associated with this field
		i_sConfigurableField[l_nCount].locked = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_locked")
		IF IsNull (i_sConfigurableField[l_nCount].locked) OR &
			(Trim (i_sConfigurableField[l_nCount].locked) = "") THEN
			i_sConfigurableField[l_nCount].locked = "N"
		END IF
		
		// Get the "searchable" parameter associated with this field
		i_sConfigurableField[l_nCount].searchable = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_searchable")
		IF IsNull (i_sConfigurableField[l_nCount].searchable) OR &
			(Trim (i_sConfigurableField[l_nCount].searchable) = "") THEN
			i_sConfigurableField[l_nCount].searchable = "N"
		END IF
		
		// get the "display only" parameter associated with this field
		i_sConfigurableField[l_nCount].display_only = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_display_only")
		IF IsNull (i_sConfigurableField[l_nCount].display_only) OR &
			(Trim (i_sConfigurableField[l_nCount].display_only) = "") THEN
			i_sConfigurableField[l_nCount].display_only = "N"
		END IF
		
		// get the edit mask associated with this field
		i_sConfigurableField[l_nCount].edit_mask = l_dsFields.GetItemString(l_nCount, &
					"display_formats_edit_mask")
		IF IsNull (i_sConfigurableField[l_nCount].edit_mask) OR &
			(Trim (i_sConfigurableField[l_nCount].edit_mask) = "") THEN
			i_sConfigurableField[l_nCount].edit_mask = ""
		END IF
		
		// get the display format associated with this field
		i_sConfigurableField[l_nCount].display_format = l_dsFields.GetItemString(l_nCount, &
					"display_formats_display_format")
		IF IsNull (i_sConfigurableField[l_nCount].display_format) OR &
			(Trim (i_sConfigurableField[l_nCount].display_format) = "") THEN
			i_sConfigurableField[l_nCount].display_format = '[general]'
		END IF
		
		// get the display name associated with this field
		i_sConfigurableField[l_nCount].format_name = l_dsFields.GetItemString(l_nCount, &
					"display_formats_format_name")
		IF IsNull (i_sConfigurableField[l_nCount].format_name) OR &
			(Trim (i_sConfigurableField[l_nCount].format_name) = "") THEN
			i_sConfigurableField[l_nCount].format_name = '[general]'
		END IF
		
		// get the validation rule associated with this field
		i_sConfigurableField[l_nCount].validation_rule = l_dsFields.GetItemString(l_nCount, &
					"display_formats_validation_rule")
		IF IsNull (i_sConfigurableField[l_nCount].validation_rule) OR &
			(Trim (i_sConfigurableField[l_nCount].validation_rule) = "") THEN
			i_sConfigurableField[l_nCount].validation_rule = ''
		END IF
		
		// get the error message associated with this field
		i_sConfigurableField[l_nCount].error_msg = l_dsFields.GetItemString(l_nCount, &
					"display_formats_error_msg")
		IF IsNull (i_sConfigurableField[l_nCount].error_msg) OR &
			(Trim (i_sConfigurableField[l_nCount].error_msg) = "") THEN
			i_sConfigurableField[l_nCount].error_msg = ''
		END IF
		
		// get the visible setting associated with this field
		i_sConfigurableField[l_nCount].visible = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_visible")
		IF IsNull (i_sConfigurableField[l_nCount].visible) OR &
			(Trim (i_sConfigurableField[l_nCount].visible) = "") THEN
			i_sConfigurableField[l_nCount].visible = ''
		END IF

	NEXT
END IF

// remove the datastore from memory
DESTROY l_dsFields

RETURN 0
end function

public function integer fw_display_fields ();//*********************************************************************************************
//  Function: fw_display_fields
//  Purpose:  Add the user configured fields for the current source type to the datawindow.
//
//  Date     Developer     Description
//  -------- ----------- ----------------------------------------------------------------------
//  01/14/02 C. Jackosn  Original Version
//	 06/11/03 M. Caruso   Added code to re-label "fixed" fields.
//  07/07/03 M. Caruso   Modified re-labeling code to call gf_AllowQuotesInLabels ().
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
FOR l_nIndex = 1 TO i_nNumConfigFields
	
	IF i_sConfigurableField[l_nIndex].field_length = 0 THEN
		
		// skip over entries with field_length = 0 because they are for re-labeling only.
		CONTINUE
	
	ELSE
		// build the dbname parameter by combining the table and column names in dot notation.
		CHOOSE CASE i_cXRefSourceType
			CASE 'C'
				l_sColName = 'consumer.'+i_sConfigurableField[l_nIndex].column_name
			CASE 'E'
				l_sColName = 'employer_group.'+i_sConfigurableField[l_nIndex].column_name
			CASE 'P'
				l_sColName = 'provider_of_service.'+i_sConfigurableField[l_nIndex].column_name
			CASE 'O'
				l_sColName = 'other_source.'+i_sConfigurableField[l_nIndex].column_name
		END CHOOSE
		
		// determine the width of the field to be displayed and the next field as well
		CHOOSE CASE (i_sConfigurableField[l_nIndex].field_length * charwidth)
			CASE IS <= colwidth1
				l_nCellWidth = colwidth1
			CASE IS <= colwidth2
				l_nCellWidth = colwidth2
			CASE ELSE
				l_nCellWidth = colwidth3
		END CHOOSE
		
		IF (l_nIndex < i_nNumConfigFields) THEN
			CHOOSE CASE (i_sConfigurableField[l_nIndex + 1].field_length * charwidth)
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
		IF i_cXRefSourceType = 'O' THEN
			l_sModString = 'column=(type=char(50) update=yes updatewhereclause=yes ' + &
								'name='+i_sConfigurableField[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		ELSE 
			l_sModString = 'column=(type=char(50) update=yes updatewhereclause=yes ' + &
								'name='+i_sConfigurableField[l_nIndex].column_name+' ' + &
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
		
		IF i_sConfigurableField[l_nIndex].visible = "Y" THEN
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
			l_sModString = 'text(name='+i_sConfigurableField[l_nIndex].column_name+'_t band=detail ' + &
								'font.charset="0" font.face="Arial" ' + &
								'font.family="2" font.height="-10" font.pitch="2" font.weight="400" ' + &
								'background.mode="1" background.color="536870912" color="0" alignment="1" ' + &
								'border="0" x="'+l_cLabelX+'" y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" ' + &
								'width="'+labelwidth+'" text="'+i_sConfigurableField[l_nIndex].field_label+':" )' + l_cNewLine
			uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
			
		ELSE
			l_cVisible = "0"
		END IF
			
		// prepare to add the new column
		l_nColCount = l_nColCount + 1
		IF l_nTabSeq > 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable
		
		IF i_sConfigurableField[l_nIndex].display_only = 'Y' THEN
			l_cDisplayOnly = 'yes'
		ELSE
			l_cDisplayOnly = 'no'
		END IF	
		
		// add the correct type of field to the datawindow
		l_nPos = Pos (l_cSyntax, "htmltable") - 1
		
		IF IsNull(i_sConfigurableField[l_nIndex].edit_mask) OR i_cXRefSourceType <> 'O' THEN
			// determine the value for edit.limit
			l_sModString = &
				'column(name='+i_sConfigurableField[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
				'border="5" alignment="0" format="[general]" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
				'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
				'edit.codetable=no edit.displayonly=yes edit.hscrollbar=no ' + &
				'edit.imemode=0 edit.limit='+STRING (i_sConfigurableField[l_nIndex].field_length)+' ' + &
				'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
				'edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="0" background.color="16777215" font.charset="0" ' + &
				'font.face="Arial" font.family="2" font.height="-10" font.pitch="2" ' + &
				'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
		ELSE
			l_sModString = &
				'column(name='+i_sConfigurableField[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
				'border="5" alignment="0" format="'+i_sConfigurableField[l_nIndex].display_format+'" ' + &
				'visible="'+l_cVisible+'" editmask.focusrectangle=no editmask.autoskip=no editmask.required=no ' + &
				'editmask.readonly='+l_cDisplayOnly+' editmask.codetable=no editmask.spin=no ' + &
				'editmask.mask="'+i_sConfigurableField[l_nIndex].edit_mask+'" editmask.imemode=0 ' + &
				'criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="0" background.color="16777215" font.charset="0" ' + &
				'font.face="Arial" font.family="2" font.height="-10" font.pitch="2" ' + &
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
	FOR l_nIndex = 1 to i_nNumConfigFields
		IF i_sConfigurableField[l_nIndex].field_length = 0 THEN
		
			// apply the new label if appropriate
			l_cLabelName = i_sConfigurableField[l_nIndex].column_name + "_t"
			IF dw_demographics.Describe (l_cLabelName + ".Text") <> "!" THEN
	
				// update the label in the preview window if the label item exists
				l_cLabelText = gf_AllowQuotesInLabels (i_sConfigurableField[l_nIndex].field_label)
				dw_demographics.Modify (l_cLabelName + ".Text='" + l_cLabelText + ":'")
	
			END IF
			
			// get the parts of the combined label text
			IF Pos (l_cLabelName, '_city_t', 1) > 0 THEN l_cCity = l_cLabelText
			IF Pos (l_cLabelName, '_state_t', 1) > 0 THEN l_cState = l_cLabelText
			IF Pos (l_cLabelName, '_zip_t', 1) > 0 THEN l_cZip = l_cLabelText
			
		ELSEIF i_cXRefSourceType = 'O' THEN
			l_sColName = i_sConfigurableField[l_nIndex].column_name
			IF dw_demographics.Describe (l_sColName + ".EditMask.Mask") <> "" THEN
				IF i_sConfigurableField[l_nIndex].validation_rule <> "" THEN
					l_sModString =  i_sConfigurableField[l_nIndex].column_name + &
										'.Validation="'+i_sConfigurableField[l_nIndex].validation_rule+'" '
					l_sMsg = dw_demographics.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation message for the current column.")
					END IF
				END IF
				IF i_sConfigurableField[l_nIndex].error_msg <> "" THEN
					l_sModString = l_sModString + i_sConfigurableField[l_nIndex].column_name + &
										'.ValidationMsg="'+i_sConfigurableField[l_nIndex].error_msg+'" '
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

on w_cross_ref_details.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_3=create st_3
this.st_2=create st_2
this.cb_close=create cb_close
this.dw_demographics=create dw_demographics
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_1=create st_1
this.ln_3=create ln_3
this.ln_4=create ln_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_close
this.Control[iCurrent+5]=this.dw_demographics
this.Control[iCurrent+6]=this.ln_1
this.Control[iCurrent+7]=this.ln_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.ln_3
this.Control[iCurrent+10]=this.ln_4
end on

on w_cross_ref_details.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_close)
destroy(this.dw_demographics)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_1)
destroy(this.ln_3)
destroy(this.ln_4)
end on

event pc_setoptions;call super::pc_setoptions;//****************************************************************************************
// 
//			Event:	pc_setoptions 	
//			Purpose:	To set uo_dw_main options, set the PowerClass Message object text and 
//						find out the user first and last name.
//						
//  Date     Developer    Description
//  -------- ------------ ----------------------------------------------------------------
//  01/14/02 C. Jackson   Original Version
//  03/06/02 C. Jackson   Correct setting of title
//****************************************************************************************/

STRING l_cName, l_cName2, l_cUserID, l_cTitle, l_cEntity, l_cXRefSubjectID, l_cXRefProviderKey
LONG l_nDWRow
DataWindow l_dwDataWindow

IF i_cParent = 'u_tabpage_case_details' THEN

	l_dwDataWindow = w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
	
	l_nDWRow = l_dwDataWindow.GetRow()
	
	IF i_cXRefSourceType = 'P' THEN
		l_cXRefProviderKey = l_dwDataWindow.GetItemString(l_nDWRow,'case_log_xref_subject_id')
	END IF

	
ELSEIF i_cParent = 'u_xref_search_criteria' THEN
	
	l_dwDataWindow = w_xref_search.uo_search_criteria.dw_matched_records

	l_nDWRow = l_dwDataWindow.GetRow()


END IF

dw_demographics.SetReDraw(FALSE)

CHOOSE CASE i_cXRefSourceType
		
	CASE 'P'
		
		l_cEntity = 'Provider'
		
	fw_buildfieldlist ('P')
	dw_demographics.fu_Swap('d_demographics_provider', &
		dw_demographics.c_IgnoreChanges, &
		dw_demographics.c_ModifyOK + &
		dw_demographics.c_ModifyOnOpen + &
		dw_demographics.c_NoMenuButtonActivation)
		
		// Get Provider Details
		
		SELECT provid_name, provid_name_2, convert(varchar(25),provider_key)
		  INTO :l_cName, :l_cName2, :l_cXRefSubjectId
		  FROM cusfocus.provider_of_service
		 WHERE provider_key = :i_nXRefProvKey
		 USING SQLCA;
		 
		IF NOT ISNULL(l_cName2) OR TRIM(l_cName2) <> '' THEN
			l_cName = l_cName + ', ' + l_cName2
		END IF

	CASE 'C'
		
		fw_buildfieldlist ('C')
		
		dw_demographics.fu_Swap('d_demographics_consumer', &
			dw_demographics.c_IgnoreChanges, &
			dw_demographics.c_ModifyOK + &
			dw_demographics.c_ModifyOnOpen + &
			dw_demographics.c_NoMenuButtonActivation)
			
			l_cEntity = 'Member'
			
			// Get Member Details
			SELECT consum_first_name, consum_last_name
			  INTO :l_cName, :l_cName2
			  FROM cusfocus.consumer
			 WHERE consumer_id = :i_cXRefSubjectID
			 USING SQLCA;
			 
			IF NOT ISNULL(l_cName2) OR TRIM(l_cName2) <> '' THEN
				l_cName = l_cName2 + ', ' + l_cName
			END IF
			
			
	CASE 'E'
		
		fw_buildfieldlist ('E')
		
		dw_demographics.fu_Swap('d_demographics_employer', &
			dw_demographics.c_IgnoreChanges, &
			dw_demographics.c_ModifyOK + &
			dw_demographics.c_ModifyOnOpen + &
			dw_demographics.c_NoMenuButtonActivation)
			
			l_cEntity = 'Group'
			
			// Get Member Details
			SELECT employ_group_name
			  INTO :l_cName
			  FROM cusfocus.employer_group
			 WHERE group_id = :i_cXRefSubjectID
			 USING SQLCA;
			 
	END CHOOSE

fw_display_fields()

dw_demographics.SetReDraw(TRUE)

fw_SetOptions(c_Default + c_ToolbarTop)			

Title = 'Demographic Details for '+l_cEntity+ ' '+l_cName



end event

event pc_setvariables;call super::pc_setvariables;//**********************************************************************************************
//
//  Event:   pc_setvariables
//  Purpose: Get the variables passed in the Message Object
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  01/15/02 C. Jackson  Original Version
//  7/26/2002 K. Claver  Changed to grab the rest of the string for provider type as the type string
//								 may be more than one character.
//**********************************************************************************************

STRING l_cParm
LONG l_nPos

l_cParm = message.StringParm

l_nPos = POS(l_cParm,',')

i_cParent = MID(l_cParm,1,l_nPos - 1 )

l_cParm = MID(l_cParm,l_nPos + 1 )


l_nPos = POS(l_cParm,',')
i_cXRefSourceType = MID(l_cParm,1,1)

l_cParm = MID(l_cParm,l_nPos + 1)

IF i_cXRefSourceType = 'P' THEN

	l_nPos = POS(l_cParm,',')
	i_nXRefProvKey = LONG(MID(l_cParm,1,l_nPos - 1))
	
	i_cXRefProvtype = Trim( Mid( l_cParm, ( l_nPos + 1 ) ) )
	
ELSE
	
	i_cXRefSubjectID = l_cParm
	
END IF



end event

type p_1 from picture within w_cross_ref_details
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cross_ref_details
integer x = 201
integer y = 60
integer width = 1691
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Cross Reference Details"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cross_ref_details
integer width = 3479
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

type cb_close from commandbutton within w_cross_ref_details
integer x = 2715
integer y = 1860
integer width = 320
integer height = 90
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To Close
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  01/14/02 C. Jackson  Original Version
//***********************************************************************************************

CLOSE(parent)
end event

type dw_demographics from u_dw_std within w_cross_ref_details
integer x = 64
integer y = 200
integer width = 3081
integer height = 1592
integer taborder = 10
string title = "none"
string dataobject = "d_demographics_consumer"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event pcd_retrieve;call super::pcd_retrieve;//******************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: Retrieve
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------
//  01/14/02 C. Jackson  Original Version
//******************************************************************************************

LONG l_nReturn 

CHOOSE CASE i_cXRefSourceType
	CASE 'P'
		l_nReturn = Retrieve(i_nXRefProvKey,i_cXRefProvType)
	CASE ELSE
		l_nReturn = Retrieve(i_cXRefSubjectID)
END CHOOSE

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF


end event

event pcd_setoptions;call super::pcd_setoptions;//***********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpse:  To set the datawindow options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  01/14/02 C. Jackson  Original Version
//***********************************************************************************************


fu_SetOptions (SQLCA, c_NullDW, c_SelectOnRowFocusChange + c_NoMenuButtonActivation + &
										  c_ModifyOK + c_SortClickedOK + c_NoEnablePopup)



end event

type ln_1 from line within w_cross_ref_details
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1812
integer endx = 3401
integer endy = 1812
end type

type ln_2 from line within w_cross_ref_details
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1808
integer endx = 3401
integer endy = 1808
end type

type st_1 from statictext within w_cross_ref_details
integer y = 1816
integer width = 3538
integer height = 184
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217747
boolean focusrectangle = false
end type

type ln_3 from line within w_cross_ref_details
long linecolor = 8421504
integer linethickness = 4
integer beginx = 5
integer beginy = 184
integer endx = 3799
integer endy = 184
end type

type ln_4 from line within w_cross_ref_details
long linecolor = 16777215
integer linethickness = 4
integer beginx = 5
integer beginy = 188
integer endx = 3799
integer endy = 188
end type

