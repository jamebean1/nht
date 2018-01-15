$PBExportHeader$w_appeal.srw
forward
global type w_appeal from w_deal_display_basic
end type
type st_3 from statictext within w_appeal
end type
type dw_module from u_reference_display_datawindow within w_appeal
end type
type cb_2 from u_commandbutton within w_appeal
end type
type dw_appeal_details from u_reference_display_datawindow within w_appeal
end type
type st_appealdetails from statictext within w_appeal
end type
type st_appealprops from statictext within w_appeal
end type
type st_4 from statictext within w_appeal
end type
type st_new_event from statictext within w_appeal
end type
type st_deleteevent from statictext within w_appeal
end type
type dw_history from u_reference_display_datawindow within w_appeal
end type
type st_history from statictext within w_appeal
end type
type ln_5 from line within w_appeal
end type
type ln_6 from line within w_appeal
end type
type ln_7 from line within w_appeal
end type
type ln_8 from line within w_appeal
end type
type ln_9 from line within w_appeal
end type
type ln_10 from line within w_appeal
end type
type dw_appeal_properties from u_reference_display_datawindow within w_appeal
end type
end forward

global type w_appeal from w_deal_display_basic
integer width = 4041
integer height = 2752
string title = ""
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = main!
st_3 st_3
dw_module dw_module
cb_2 cb_2
dw_appeal_details dw_appeal_details
st_appealdetails st_appealdetails
st_appealprops st_appealprops
st_4 st_4
st_new_event st_new_event
st_deleteevent st_deleteevent
dw_history dw_history
st_history st_history
ln_5 ln_5
ln_6 ln_6
ln_7 ln_7
ln_8 ln_8
ln_9 ln_9
ln_10 ln_10
dw_appeal_properties dw_appeal_properties
end type
global w_appeal w_appeal

type variables
n_dao_appealheader 		in_dao
n_dao_appealdetail		in_dao_appealdetail
n_dao_appealproperties 	in_dao_appeal_props
long il_id
long							il_appealdetail_row

INTEGER						i_nNumConfigFields

W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder

S_FIELDPROPERTIES			i_sConfigurableField[]

DataStore 					i_dsFields

long							il_appealtypeID
long							il_appealheaderID
string						is_original_syntax
string						is_original_history_syntax


boolean						ab_show_detail_log
datetime						idt_timer_start_time

//-----------------------------------------------------------------------------------------------------------------------------------

// Does this user have the rights to edit a completed appeal
//-----------------------------------------------------------------------------------------------------------------------------------

string						is_edit_completed
n_calendar_column_service in_calendar_column_service

string						is_appeal_open_outcome


end variables

forward prototypes
public function integer wf_buildfieldlist (long al_appealtypeid)
public subroutine wf_alter_window_title (datetime adt_startdate)
public subroutine wf_readonly (boolean ab_readonly)
public function long wf_display_appeal_props (long al_appealtypeid, long al_appealdetailid)
public subroutine wf_build_defaults (long al_line_of_business_id, long al_appealtype, long al_service_type_id)
public function integer wf_display_property_history ()
public subroutine wf_init (string as_case_number)
public function integer wf_save_changes ()
public function long of_get_default_lob (string as_case)
public function integer wf_check_required ()
end prototypes

public function integer wf_buildfieldlist (long al_appealtypeid);/*****************************************************************************************
	Function:	fu_buildfieldlist
	Purpose:		Add defined configurable fields to the field list for the selected source
	            type.
	Parameters:	None
	Returns:		LONG ->	 0 - success
								-1 - failure
								
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	7/12/99  M. Caruso     Created.
	
	7/15/99  M. Caruso     Removed code to add fields to i_cCriteriaColumn[],
	                       i_cSearchColumn[] and i_cSearchTable[]
	12/8/2000 K. Claver    Adapted to work with the case properties tab
*****************************************************************************************/
LONG					l_nCount, l_nColIndex
S_FIELDPROPERTIES			l_sNullFieldStruct[]

// retrieve the list of fields for source_type and case type from the database.
THIS.i_dsFields = CREATE DataStore
THIS.i_dsFields.DataObject = "d_appeal_prop_field_list"
THIS.i_dsFields.SetTransObject(SQLCA)
i_nNumConfigFields = THIS.i_dsFields.Retrieve(al_appealtypeID)

//Clear out the configurable field structure before adding to
i_sConfigurableField = l_sNullFieldStruct

// process the list of fields.
IF i_nNumConfigFields > 0 THEN
	FOR l_nCount = 1 to i_nNumConfigFields
		// get the column name associated with this field
		i_sConfigurableField[l_nCount].column_name = THIS.i_dsFields.GetItemString(l_nCount, &
					"column_name")
		IF IsNull (i_sConfigurableField[l_nCount].column_name) OR &
			(Trim (i_sConfigurableField[l_nCount].column_name) = "") THEN
			i_sConfigurableField[l_nCount].column_name = ""
		END IF
		
		// get the column label associated with this field
		i_sConfigurableField[l_nCount].field_label = THIS.i_dsFields.GetItemString(l_nCount, &
					"field_label")
		IF IsNull (i_sConfigurableField[l_nCount].field_label) OR &
			(Trim (i_sConfigurableField[l_nCount].field_label) = "") THEN
			i_sConfigurableField[l_nCount].field_label = ""
		END IF
		
		// get the field width associated with this field
		i_sConfigurableField[l_nCount].field_length = THIS.i_dsFields.GetItemNumber(l_nCount, &
					"field_length")
		IF IsNull (i_sConfigurableField[l_nCount].field_length) THEN
			i_sConfigurableField[l_nCount].field_length = 50
		END IF
		
		// get the "locked" parameter associated with this field
		i_sConfigurableField[l_nCount].locked = THIS.i_dsFields.GetItemString(l_nCount, &
					"locked")
		IF IsNull (i_sConfigurableField[l_nCount].locked) OR &
			(Trim (i_sConfigurableField[l_nCount].locked) = "") THEN
			i_sConfigurableField[l_nCount].locked = "N"
		END IF
		
		// get the "visible" parameter associated with this field
		i_sConfigurableField[l_nCount].visible = THIS.i_dsFields.GetItemString(l_nCount, &
					"visible")
		IF IsNull (i_sConfigurableField[l_nCount].visible) OR &
			(Trim (i_sConfigurableField[l_nCount].visible) = "") THEN
			i_sConfigurableField[l_nCount].visible = "N"
		END IF
		
		// get the "required" parameter associated with this field
		i_sConfigurableField[l_nCount].required = THIS.i_dsFields.GetItemString(l_nCount, &
					"required")
		IF IsNull (i_sConfigurableField[l_nCount].required) OR &
			(Trim (i_sConfigurableField[l_nCount].required) = "") THEN
			i_sConfigurableField[l_nCount].required = "N"
		END IF
		
		// get the edit mask associated with this field
		i_sConfigurableField[l_nCount].edit_mask = THIS.i_dsFields.GetItemString(l_nCount, &
					"edit_mask")
		IF IsNull (i_sConfigurableField[l_nCount].edit_mask) OR &
			(Trim (i_sConfigurableField[l_nCount].edit_mask) = "") THEN
			i_sConfigurableField[l_nCount].edit_mask = ""
		END IF
		
		// get the display format associated with this field
		i_sConfigurableField[l_nCount].display_format = THIS.i_dsFields.GetItemString(l_nCount, &
					"display_format")
		IF IsNull (i_sConfigurableField[l_nCount].display_format) OR &
			(Trim (i_sConfigurableField[l_nCount].display_format) = "") THEN
			i_sConfigurableField[l_nCount].display_format = '[general]'
		END IF
		
		// get the display name associated with this field
		i_sConfigurableField[l_nCount].format_name = THIS.i_dsFields.GetItemString(l_nCount, &
					"format_name")
		IF IsNull (i_sConfigurableField[l_nCount].format_name) OR &
			(Trim (i_sConfigurableField[l_nCount].format_name) = "") THEN
			i_sConfigurableField[l_nCount].format_name = '[general]'
		END IF
		
		// get the validation rule associated with this field
		i_sConfigurableField[l_nCount].validation_rule = THIS.i_dsFields.GetItemString(l_nCount, &
					"validation_rule")
		IF IsNull (i_sConfigurableField[l_nCount].validation_rule) OR &
			(Trim (i_sConfigurableField[l_nCount].validation_rule) = "") THEN
			i_sConfigurableField[l_nCount].validation_rule = ''
		END IF
		
		// get the error message associated with this field
		i_sConfigurableField[l_nCount].error_msg = THIS.i_dsFields.GetItemString(l_nCount, &
					"error_msg")
		IF IsNull (i_sConfigurableField[l_nCount].error_msg) OR &
			(Trim (i_sConfigurableField[l_nCount].error_msg) = "") THEN
			i_sConfigurableField[l_nCount].error_msg = ''
		END IF
		
		// get the visible setting associated with this field
		i_sConfigurableField[l_nCount].dropdown = THIS.i_dsFields.GetItemString(l_nCount, &
					"dropdown")
		IF IsNull (i_sConfigurableField[l_nCount].dropdown) OR &
			(Trim (i_sConfigurableField[l_nCount].dropdown) = "") THEN
			i_sConfigurableField[l_nCount].dropdown = ''
		END IF
		
	NEXT
END IF

RETURN 0
end function

public subroutine wf_alter_window_title (datetime adt_startdate);date ldt_now, ldt_start_date
long ll_daysafter

ldt_now = Date(gn_globals.in_date_manipulator.of_now())
ldt_start_date = Date(adt_startdate)

ll_daysafter = DaysAfter(ldt_start_date, ldt_now)

Choose case ll_daysafter
	Case 1
		This.Title = 'Appeal - Open for ' + string(ll_daysafter) + ' day'
	Case Else
		This.Title = 'Appeal - Open for ' + string(ll_daysafter) + ' days'
End Choose

end subroutine

public subroutine wf_readonly (boolean ab_readonly);If ab_readonly = True Then
	in_dao.ib_readonly = TRUE
	in_dao_appealdetail.ib_readonly = TRUE
	in_dao_appeal_props.ib_readonly = TRUE
	
	st_1.Text = 'View Appeal - Read Only'
End If
end subroutine

public function long wf_display_appeal_props (long al_appealtypeid, long al_appealdetailid);//*********************************************************************************************
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
//  12/8/2000 K. Claver  Configured to be used on the case properties tab.
//  01/11/01 M. Caruso   Code to reinitialize the datawindow options has been removed.
//  01/18/01 M. Caruso   Added Nil-Is-Null clause to validation rules for edit mask fields.
//*********************************************************************************************

CONSTANT	INTEGER	col1labelX = 27
CONSTANT	INTEGER	col2labelX = 1900
CONSTANT	INTEGER	col3labelX = 2547
//???CONSTANT	INTEGER	col2labelX = 1107
//???CONSTANT	INTEGER	col3labelX = 2247
CONSTANT	INTEGER	col1cellX = 879
CONSTANT	INTEGER	col2cellX = 2772
CONSTANT	INTEGER	col3cellX = 3100
///???CONSTANT	INTEGER	col1cellX = 579
///???CONSTANT	INTEGER	col2cellX = 1659
///???CONSTANT	INTEGER	col3cellX = 2800
CONSTANT INTEGER  rightmargin = 3450
CONSTANT INTEGER	colwidth1 = 500
CONSTANT INTEGER	colwidth2 = 1555
CONSTANT INTEGER	colwidth3 = 2610
CONSTANT STRING	labelwidth = '845'
//???CONSTANT STRING	labelwidth = '545'
CONSTANT STRING	cellheight = '64'
CONSTANT INTEGER	charwidth = 40
CONSTANT INTEGER	y_offset = 92

LONG		l_nColCount, l_nMaxX, l_nMaxY, l_nX, l_nY, l_nIndex, l_nPos, l_nBackColor
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nNewColId, l_nTabSeq
INTEGER  l_nNewTabSeq, l_nNumChars, l_nCellWidth, l_nNextCellWidth, l_nDWIndex
STRING	l_sColName, l_cModString, l_cMsg, l_cSyntax, l_cObjName, l_cMask
STRING	l_cDisplayOnly, l_cNewLine, l_cLabelX, l_cCellX, l_cUpdate, l_cProtect
String   l_cRequired, l_cVisible, l_cLabelWeight, l_cNilIsNullClause

//Revert to the original syntax
dw_appeal_properties.Create (is_original_syntax)

// determine the location of the last predefined column in the datawindow
l_nColCount = LONG (dw_appeal_properties.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO l_nColCount
	IF dw_appeal_properties.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = dw_appeal_properties.Describe ('#' + STRING (l_nIndex) + '.Name')
		l_nX = INTEGER (dw_appeal_properties.Describe("#" + STRING(l_nIndex) + '.X'))
		l_nY = INTEGER (dw_appeal_properties.Describe("#" + STRING(l_nIndex) + '.Y'))
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
		l_nNewTabSeq = INTEGER (dw_appeal_properties.Describe("#" + STRING(l_nIndex) + '.tabsequence'))
		IF l_nTabSeq < l_nNewTabSeq THEN
			l_nTabSeq = l_nNewTabSeq
		END IF
	END IF
NEXT

// determine if last field is in a group box and prep accordingly
l_cMsg = dw_appeal_properties.Describe ("DataWindow.Objects")
l_nPos = 0
DO
	l_nIndex = l_nPos + 1
	l_nPos = pos (l_cMsg, "~t", l_nIndex)
	IF l_nPos > 0 THEN
		l_cObjName = Mid (l_cMsg, l_nIndex, (l_nPos - l_nIndex))
	ELSE
		l_cObjName = Mid (l_cMsg, l_nIndex)
	END IF
	IF pos (l_cObjName, "gb_") > 0 THEN
		l_nX = INTEGER (dw_appeal_properties.Describe (l_cObjName + ".X"))
		l_nY = INTEGER (dw_appeal_properties.Describe (l_cObjName + ".Y")) + &
				 INTEGER (dw_appeal_properties.Describe (l_cObjName + ".Height"))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxY = l_nY
			l_nMaxX = col1cellX
			l_nLastCol = -1
		END IF
	END IF
LOOP WHILE pos (l_cMsg, "~t", l_nIndex) > 0

// determine location of first field to add
IF l_nLastCol = -1 THEN  // if the last field was in a group box
	l_nColNum = 1
ELSE
	l_nX = INTEGER (dw_appeal_properties.Describe("#" + STRING(l_nLastCol) + '.X'))
	l_nY = INTEGER (dw_appeal_properties.Describe("#" + STRING(l_nLastCol) + '.Y'))
	l_nWidth = INTEGER (dw_appeal_properties.Describe("#" + STRING(l_nLastCol) + '.Width'))
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
l_cSyntax = dw_appeal_properties.Describe("DataWindow.Syntax")

// add the new fields
FOR l_nIndex = 1 TO THIS.i_nNumConfigFields
	l_sColName = 'appeal_properties.'+THIS.i_sConfigurableField[l_nIndex].column_name
	
	// determine the width of the field to be displayed and the next field as well
	CHOOSE CASE (THIS.i_sConfigurableField[l_nIndex].field_length * charwidth)
		CASE IS <= colwidth1
			l_nCellWidth = colwidth1
		CASE IS <= colwidth2
			l_nCellWidth = colwidth2
		CASE ELSE
			l_nCellWidth = colwidth3
	END CHOOSE
	
	IF (l_nIndex < THIS.i_nNumConfigFields) THEN
		CHOOSE CASE (THIS.i_sConfigurableField[l_nIndex + 1].field_length * charwidth)
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

	l_cModString = 'column=(type=char(50) update=yes updatewhereclause=yes ' + &
						'name='+THIS.i_sConfigurableField[l_nIndex].column_name+' ' + &
						'dbname="'+l_sColName+'" )' + l_cNewline
		
	uf_StringInsert(l_cSyntax, l_cModString, (l_nPos + 1))
	
	// update the SQL SELECT portion of the datawindow
	l_nPos = Pos (l_cSyntax, 'retrieve="')
	DO WHILE Pos (l_cSyntax, "COLUMN(NAME", l_nPos + 1) > 0
		l_nPos = Pos (l_cSyntax, "COLUMN(NAME", l_nPos + 1)
	LOOP
	l_nPos = Pos (l_cSyntax, ')', l_nPos + 1)
	l_cModString = ' COLUMN(NAME=~~"cusfocus.'+l_sColName+'~~")'
	uf_StringInsert(l_cSyntax, l_cModString, l_nPos)
	
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
	
	//Required?
	IF THIS.i_sConfigurableField[l_nIndex].required = 'Y' THEN
		l_cRequired = 'no' // Required fields will be checked when the appeal is closed, may not know what to enter until then
		l_cLabelWeight = '700'
		
		in_dao_appeal_props.of_set_required(al_appealtypeid, THIS.i_sConfigurableField[l_nIndex].column_name, al_appealdetailid)
	ELSE
		l_cRequired = 'no'
		l_cLabelWeight = '400'
	END IF
	
	// add the new column label
	l_nPos = Pos (l_cSyntax, "htmltable") - 1
	l_cModString = 'text(name='+THIS.i_sConfigurableField[l_nIndex].column_name+'_t band=detail ' + &
						'font.charset="0" font.face="Tahoma" ' + &
						'font.family="2" font.height="-8" font.pitch="2" font.weight="'+l_cLabelWeight+'" ' + &
						'background.mode="1" background.color="536870912" color="0" alignment="0" ' + &
						'border="0" x="'+l_cLabelX+'" y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" ' + &
						'width="'+labelwidth+'" text="'+THIS.i_sConfigurableField[l_nIndex].field_label+':" )' + l_cNewLine
	uf_StringInsert(l_cSyntax, l_cModString, l_nPos)
	
	// prepare to add the new column
	l_nColCount = l_nColCount + 1
	IF l_nTabSeq >= 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable
	
	//Lock it down?
	IF THIS.i_sConfigurableField[l_nIndex].locked = 'Y' THEN
		l_cDisplayOnly = 'yes'
		l_cProtect = '1'
		l_nBackColor = RGB( 192, 192, 192 )
	ELSE
		l_cDisplayOnly = 'no'
		l_cProtect = '0'
		l_nBackColor = RGB( 255, 255, 255 ) 
	END IF
	
	//Visible?
	IF THIS.i_sConfigurableField[l_nIndex].visible = 'Y' THEN
		l_cVisible = '1'
	ELSE
		l_cVisible = '0'
	END IF
	
	// add the correct type of field to the datawindow
	l_nPos = Pos (l_cSyntax, "htmltable") - 1
	
	IF IsNull(THIS.i_sConfigurableField[l_nIndex].edit_mask) OR Trim(THIS.i_sConfigurableField[l_nIndex].edit_mask) = "" THEN
		// determine the value for edit.limit
		l_cModString = &
			'column(name='+THIS.i_sConfigurableField[l_nIndex].column_name+' band=detail ' + &
			'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
			'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
			'border="5" alignment="0" format="[general]" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
			'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
			'edit.codetable=no edit.displayonly='+l_cDisplayOnly+' edit.format="" edit.hscrollbar=no ' + &
			'edit.imemode=0 edit.limit='+STRING (THIS.i_sConfigurableField[l_nIndex].field_length)+' ' + &
			'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
			'edit.required='+l_cRequired+' criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
			'background.mode="0" background.color="'+String( l_nBackColor )+'" font.charset="0" ' + &
			'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
			'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
	ELSE
			l_cModString = &
				'column(name='+THIS.i_sConfigurableField[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
				'border="5" alignment="0" format="'+THIS.i_sConfigurableField[l_nIndex].display_format+'" ' + &
				'protect="'+l_cProtect+'" visible="'+l_cVisible+'" editmask.focusrectangle=no editmask.autoskip=no ' + &
				'editmask.required='+l_cRequired+' editmask.codetable=no editmask.spin=no ' + &
				'editmask.mask="'+THIS.i_sConfigurableField[l_nIndex].edit_mask+'" editmask.imemode=0 ' + &
				'criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="0" background.color="'+String( l_nBackColor )+'" font.charset="0" ' + &
				'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
				'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
	END IF
	
	If lower(this.i_sConfigurableField[l_nIndex].dropdown) = 'y' Then
		string ls_dropdown_width 
		
		Choose Case long(l_nCellWidth)
			Case Is <= 500
				ls_dropdown_width = '250'
			Case Is >= 500
				ls_dropdown_width = '100'
		End Choose
		
		
		
			l_cModString = &
			'column(band=detail id='+STRING (l_nColCount)+' alignment="0" tabsequence='+STRING (l_nTabSeq)+' border="5" color="0" x="'+l_cCellX+'" y="'+STRING (l_nMaxY)+'" ' + & 
			'height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" format="[general]" html.valueishtml="0"  name='+THIS.i_sConfigurableField[l_nIndex].column_name + ' ' + & 
			'visible="'+l_cVisible+'" dddw.name=dddw_appealprops_generic dddw.displaycolumn=appealpropertiesvalues_value ' + & 
			'dddw.datacolumn=appealpropertiesvalues_value dddw.percentwidth=' + ls_dropdown_width + ' dddw.lines=0 dddw.limit=0 ' + & 
			'dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.imemode=0 dddw.vscrollbar=yes ' + & 
			'dddw.autoretrieve=no  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" '+ & 
			'font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" ) ' //+ l_cNewLine
	End If
		
	uf_StringInsert(l_cSyntax, l_cModString, l_nPos)
	
NEXT

// resize the detail band if necessary
IF (l_nMaxY + 64) > LONG (dw_appeal_properties.Object.Datawindow.Detail.Height) THEN

	l_nPos = Pos (l_cSyntax, "detail(height=") + 14
	l_nNumChars = Pos (l_cSyntax, " ", l_nPos) - l_nPos
	l_cSyntax = Replace (l_cSyntax, l_nPos, l_nNumChars, STRING (l_nMaxY + 76))
	
END IF

// re-initialize the datawindow
IF dw_appeal_properties.Create (l_cSyntax, l_cMsg) <> 1 THEN
	MessageBox (gs_AppName, l_cMsg)
	RETURN -1
ELSE
	dw_appeal_properties.SetTransObject(SQLCA)
	
	//	 add any validation rules and error messages that are defined for the columns
	FOR l_nIndex = 1 to THIS.i_nNumConfigFields
		l_sColName = THIS.i_sConfigurableField[l_nIndex].column_name
		l_cMask = dw_appeal_properties.Describe (l_sColName + ".EditMask.Mask")
		IF l_cMask <> "" AND l_cMask <> "?" THEN
			IF THIS.i_sConfigurableField[l_nIndex].validation_rule <> "" THEN
				// Add Nil-is-Null clause if validation rule is not blank
				IF IsNull (THIS.i_sConfigurableField[l_nIndex].validation_rule) OR &
							  THIS.i_sConfigurableField[l_nIndex].validation_rule = '' THEN
					l_cModString =  THIS.i_sConfigurableField[l_nIndex].column_name + &
									'.Validation="' + THIS.i_sConfigurableField[l_nIndex].validation_rule + '" '
				ELSE
					l_cNilIsNullClause = " OR ((Len(Trim(GetText()))=0) AND (Describe('" + &
												THIS.i_sConfigurableField[l_nIndex].column_name + ".Editmask.required')='no')))"
					l_cModString =  THIS.i_sConfigurableField[l_nIndex].column_name + &
										'.Validation="(' + THIS.i_sConfigurableField[l_nIndex].validation_rule + l_cNilIsNullClause + '" '
				END IF
				l_cMsg = dw_appeal_properties.Modify(l_cModString)
				IF l_cMsg <> "" THEN
					MessageBox (gs_AppName,"Unable to define the validation message for the current column.")
				END IF
			END IF
			IF THIS.i_sConfigurableField[l_nIndex].error_msg <> "" THEN
				l_cModString = l_cModString + THIS.i_sConfigurableField[l_nIndex].column_name + &
									'.ValidationMsg="'+THIS.i_sConfigurableField[l_nIndex].field_label+': '+THIS.i_sConfigurableField[l_nIndex].error_msg+'" '
				l_cMsg = dw_appeal_properties.Modify(l_cModString)
				IF l_cMsg <> "" THEN
					MessageBox (gs_AppName,"Unable to define the validation error message for the current column.")
				END IF			
			END IF
		ELSEIF THIS.i_sConfigurableField[l_nIndex].required = 'Y' THEN
			l_cModString = THIS.i_sConfigurableField[l_nIndex].column_name + &
								'.Validation="(Len(Trim(GetText())) > 0)" '+ &
								THIS.i_sConfigurableField[l_nIndex].column_name + &
								'.ValidationMsg="'+THIS.i_sConfigurableField[l_nIndex].field_label+' is a required field for Appeal Properties." '
			l_cMsg = dw_appeal_properties.Modify(l_cModString)
			IF l_cMsg <> "" THEN
				MessageBox (gs_AppName,"Unable to define the validation rule and error message for the current column.")
			END IF
		END IF
	NEXT

	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite Added 7.15.2004 - Trying to fix non-retrieving dddws on case props on the Case
	//-----------------------------------------------------------------------------------------------------------------------------------
	datawindowchild ldwc_caseprop
	datastore lds_caseprop_field_def
	long ll_datastore_rows, ll_counter, ll_find_return, ll_errorcheck, ll_row
	string ls_find_string, ls_null
	
	lds_caseprop_field_def = Create Datastore
	lds_caseprop_field_def.DataObject = 'd_data_appealprop_field_def'
	lds_caseprop_field_def.SetTransObject(SQLCA)
	ll_datastore_rows = lds_caseprop_field_def.Retrieve(al_appealtypeID)
	
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through the dynamic column array and retrieve drop downs for all the necessary columns
	//-----------------------------------------------------------------------------------------------------------------------------------
	For	ll_counter = 1 to UpperBound(i_sConfigurableField)
		ls_find_string = 'column_name = "' + THIS.i_sConfigurableField[ll_counter].column_name + '" AND  dropdown = "Y"'
		ll_find_return = lds_caseprop_field_def.Find(ls_find_string, 1, ll_datastore_rows)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If a row is found, there is a drop down. If no row is found, Insert a Row.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ll_find_return > 0 Then
			ll_errorcheck = dw_appeal_properties.GetChild(THIS.i_sConfigurableField[ll_counter].column_name, ldwc_caseprop)
			ldwc_caseprop.SetTransObject(SQLCA)
			ll_errorcheck = ldwc_caseprop.Retrieve(long(al_appealtypeID), THIS.i_sConfigurableField[ll_counter].column_name)
			
			ll_row = ldwc_caseprop.InsertRow(0)
			ldwc_caseprop.SetItem(ll_row, 'appealpropertiesvalues_value', '(None)')
			ldwc_caseprop.Sort()
			
			If ll_errorcheck = 0 Then
				ldwc_caseprop.InsertRow(0)
			End If
		End If
	Next
	
	
	n_calendar_column_service_props in_calendar_column_service
	in_calendar_column_service = Create n_calendar_column_service_props
	
	in_calendar_column_service.of_init(dw_appeal_properties)
	
	
	
	
	RETURN 0
END IF
end function

public subroutine wf_build_defaults (long al_line_of_business_id, long al_appealtype, long al_service_type_id);long		ll_rowcount, ll_appealeventid, ll_datetermid, ll_appealheaderid, ll_row, ll_appealdetailid, ll_set_row
long 		ll_new_row, ll_rows, i, ll_set_event, ll_header_dateterm  
string	ls_reminder, ls_letter
datetime	ldt_now, ldt_due_date, ldt_reminder_due, ldt_header_duedate
boolean	lb_change_events = FALSE
n_appealdetail_duedate ln_duedate

datastore ids_appealdefaults

ln_duedate = Create n_appealdetail_duedate

If in_dao_appealdetail.RowCount() = 0 Then 

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the datastore, set the dataobject and then retrieve the defaults for this appeal type.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ids_appealdefaults = Create datastore
	ids_appealdefaults.DataObject = 'd_data_appealtypedefaults'
	ids_appealdefaults.SetTransObject(SQLCA)
	
	ll_rowcount = ids_appealdefaults.Retrieve(al_line_of_business_id, al_appealtype, al_service_type_id)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the default date term for the overall appeal and set it into the Appeal Header DAO
	//-----------------------------------------------------------------------------------------------------------------------------------

  SELECT cusfocus.service_type.default_dateterm  
    INTO :ll_header_dateterm  
    FROM cusfocus.service_type  
   WHERE cusfocus.service_type.appealtypeid = :al_appealtype   
	  AND cusfocus.service_type.line_of_business_id = :al_line_of_business_id
	  AND cusfocus.service_type.service_type_id = :al_service_type_id
           ;
			  
	in_dao.of_setitem(1, 'datetermid', ll_header_dateterm)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Call the function to calculate the due date, then set the new value into the DAO
	//-----------------------------------------------------------------------------------------------------------------------------------
	ldt_header_duedate 		= 	ln_duedate.of_get_due_date(ll_header_dateterm, idt_timer_start_time)
	in_dao.of_setitem(1, 	'duedate', 	ldt_header_duedate)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through the datastore and set the default steps based on their 
	//-----------------------------------------------------------------------------------------------------------------------------------
	For i = 1 to ll_rowcount
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the Default Information from the datastore
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_appealeventID 		=		ids_appealdefaults.GetItemNumber(i, 'appealeventid')
		ll_datetermID 			= 		ids_appealdefaults.GetItemNumber(i, 'datetermID')
		ls_reminder 			= 		ids_appealdefaults.GetItemString(i, 'reminder')
		ls_letter	 			= 		ids_appealdefaults.GetItemString(i, 'letter')
		ldt_now					= 		gn_globals.in_date_manipulator.of_now()
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Call the function that sets a new appeald detail record into the DAO
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_row = in_dao_appealdetail.of_new_appealdetail(ll_appealheaderID)
		
		ll_appealdetailID = long(in_dao_appealdetail.of_getitem(ll_row, 'appealdetailid'))

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Build the appeal properties for this Appeal Event
		//-----------------------------------------------------------------------------------------------------------------------------------
		wf_buildfieldlist(ll_appealeventID)
		wf_display_appeal_props(ll_appealeventID,ll_appealdetailID)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Insert a new row into appeal props DAO, then set the values in to it.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_new_row = in_dao_appeal_props.of_new_with_return()
		
		in_dao_appeal_props.of_setitem(ll_new_row, 'source_type', ll_appealeventID)
		in_dao_appeal_props.of_setitem(ll_new_row, 'appealdetailid', ll_appealdetailID)
		in_dao_appeal_props.of_setitem(ll_new_row, 'case_number', in_dao.of_getitem(1, 'case_number'))

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the values into the appeal detail DAO
		//-----------------------------------------------------------------------------------------------------------------------------------
		in_dao_appealdetail.of_setitem(ll_row, 'appealeventid', ll_appealeventID)
		in_dao_appealdetail.of_setitem(ll_row, 'datetermid', ll_datetermID)
		in_dao_appealdetail.of_setitem(ll_row, 'appealdetailreminder', ls_reminder)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the due date and the reminder due dates for the newly defaulted rows
		//-----------------------------------------------------------------------------------------------------------------------------------
		ldt_due_date 		= 	ln_duedate.of_get_due_date(ll_datetermID, idt_timer_start_time)
		in_dao_appealdetail.of_setitem(ll_row, 'appealeventduedate'	, ldt_due_date)
		
		If ls_reminder = 'Y' Then 
			ldt_reminder_due 	= 	ln_duedate.of_get_reminder_due_date(ll_datetermID, ldt_due_date)
			in_dao_appealdetail.of_setitem(ll_row, 'reminderdue'			, ldt_reminder_due)
		End If
	Next

	
	dw_appeal_details.event ue_retrieve()
	dw_appeal_details.ScrolltoRow(1)
	dw_appeal_details.SelectRow(-1, FALSE)
	dw_appeal_details.SelectRow(1, TRUE)
	
	dw_appeal_properties.event ue_retrieve()

End If
end subroutine

public function integer wf_display_property_history ();//--------------------------------------------------------------------------
// This function will add labels to the appeal property history datawindow
//
// 11/22/2006 RAP - Created
//--------------------------------------------------------------------------

CONSTANT	INTEGER	col1labelX = 27
CONSTANT	INTEGER	col2labelX = 1107
CONSTANT	INTEGER	col3labelX = 2247
CONSTANT	INTEGER	col1cellX = 879
CONSTANT	INTEGER	col2cellX = 1959
CONSTANT	INTEGER	col3cellX = 3100
CONSTANT INTEGER  rightmargin = 3450
CONSTANT INTEGER	colwidth1 = 500
CONSTANT INTEGER	colwidth2 = 1555
CONSTANT INTEGER	colwidth3 = 2610
CONSTANT INTEGER	labelwidth = 975
//???CONSTANT INTEGER	labelwidth = 847
CONSTANT STRING	cellheight = '64'
CONSTANT INTEGER	charwidth = 40
CONSTANT INTEGER	y_offset = 92
CONSTANT STRING	labelweight = '700'

LONG		l_nColCount, l_nMaxX, l_nMaxY, l_nX, l_nY, l_nIndex, l_nPos, l_nBackColor, ll_config_index
LONG		ll_casenumber, ll_appealeventID, ll_count
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nNewColId, l_nTabSeq
INTEGER  l_nNewTabSeq, l_nNumChars, l_nCellWidth, l_nNextCellWidth, l_nDWIndex
STRING	l_sColName, l_cModString, l_cMsg, l_cSyntax, l_cObjName, l_cMask
STRING	l_cDisplayOnly, l_cNewLine, l_cLabelX, l_cCellX, l_cUpdate, l_cProtect
String   l_cRequired, l_cVisible, l_cLabelWeight, l_cNilIsNullClause, ls_case_number

//Revert to the original syntax
dw_history.Create (is_original_history_syntax)

// add the new columns to the result set of the datawindow.
l_cSyntax = dw_history.Describe("DataWindow.Syntax")

// determine the location of the last predefined column in the datawindow
//???l_nColCount = LONG (dw_history.Object.Datawindow.Column.Count)
l_nColCount = LONG (dw_appeal_properties.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO l_nColCount
//???	IF dw_history.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
//???		l_sColName = dw_history.Describe ('#' + STRING (l_nIndex) + '.Name')
	IF dw_appeal_properties.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = dw_appeal_properties.Describe ('#' + STRING (l_nIndex) + '.Name')
		IF POS(l_sColName, 'generic') > 0 THEN 

			l_nX = INTEGER (dw_history.Describe("#" + STRING(l_nIndex) + '.X'))
			l_nY = INTEGER (dw_history.Describe("#" + STRING(l_nIndex) + '.Y'))
			l_cLabelX = String(l_nX - labelwidth)

			// find column location in configurable field array
			ll_config_index = 0
			FOR ll_count = 1 to UpperBound(i_sConfigurableField)
				IF THIS.i_sConfigurableField[ll_count].column_name = l_sColName THEN 
					ll_config_index = ll_count
					EXIT
				END IF
			NEXT
			
			// add the new column label
			l_nPos = Pos (l_cSyntax, "htmltable") - 1
			l_cModString = 'text(name='+l_sColName+'_t band=detail ' + &
								'font.charset="0" font.face="Tahoma" ' + &
								'font.family="2" font.height="-8" font.pitch="2" font.weight="'+LabelWeight+'" ' + &
								'background.mode="1" background.color="536870912" color="0" alignment="0" ' + &
								'border="0" x="'+l_cLabelX+'" y="'+STRING (l_nY)+'" height="'+cellheight+'" ' + &
								'width="'+String(labelwidth)+'" text="'+THIS.i_sConfigurableField[ll_config_Index].field_label+':" )' + l_cNewLine
			uf_StringInsert(l_cSyntax, l_cModString, l_nPos)
		
			IF ll_config_index > 0 THEN
				// Is there a display format?
				IF NOT IsNull(THIS.i_sConfigurableField[ll_config_index].display_format) THEN
					IF THIS.i_sConfigurableField[ll_config_index].display_format <> "[general]" THEN
						l_nPos = Pos (l_cSyntax, "column(name=" + THIS.i_sConfigurableField[ll_config_index].column_name)
						IF l_nPos > 0 THEN
							l_nPos = Pos (l_cSyntax, "[general]", l_nPos)
							l_cSyntax = MID(l_cSyntax, 1, l_nPos - 1) + THIS.i_sConfigurableField[ll_config_index].display_format + MID(l_cSyntax, l_nPos + 9)
						END IF
					END IF
				END IF
			END IF
		END IF
	END IF
NEXT


// re-initialize the datawindow
IF dw_history.Create (l_cSyntax, l_cMsg) <> 1 THEN
	MessageBox (gs_AppName, l_cMsg)
	RETURN -1
ELSE
	dw_history.SetTransObject(SQLCA)
	ll_appealeventID 	= 	long(in_dao_appealdetail.of_getitem(dw_appeal_details.GetRow(), 'appealeventid'))
	ls_case_number = dw_module.object.case_number[dw_module.GetRow()]
	dw_history.retrieve(ls_case_number, ll_appealeventID)
END IF
RETURN 0
end function

public subroutine wf_init (string as_case_number);String	ls_id, ls_satus, ls_null, ls_isclose
long		ll_appealstatusid
datetime	ldt_null
boolean 	lb_readonly = FALSE

SetNull(ls_null)
SetNull(ldt_null)
		
ls_id = as_case_number

cb_1.Enabled = TRUE

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the instance variable that tells us 
//-----------------------------------------------------------------------------------------------------------------------------------

  SELECT IsNull(cusfocus.cusfocus_user.edit_appeal, 'N')
    INTO :is_edit_completed  
    FROM cusfocus.cusfocus_user  
   WHERE cusfocus.cusfocus_user.user_id = :gn_globals.is_login   ;
	
If is_edit_completed <> 'Y' AND is_edit_completed <> 'N' Then is_edit_completed = 'N'
If gn_globals.is_login = 'cfadmin' then is_edit_completed = 'Y'
// 9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//If gn_globals.is_login = 'sysadmin' then is_edit_completed = 'Y'



//-----------------------------------------------------------------------------------------------------------------------------------
// Check the Appeal Header Status and decide how the outcome field should be
//-----------------------------------------------------------------------------------------------------------------------------------

ll_appealstatusid = long(in_dao.of_getitem(1, 'appealheaderstatusid'))

		  SELECT cusfocus.appealstatus.isclose  
 			 INTO :ls_isclose  
    		 FROM cusfocus.appealstatus  
   		WHERE cusfocus.appealstatus.id = :ll_appealstatusid   ;

If ls_isclose = 'Y' And is_edit_completed = 'Y' Then
	dw_module.Object.appealoutcome.TabSequence = 100
	dw_module.Object.appealoutcome.background.color = dw_module.Object.appealtype.background.color
//	in_dao.of_setitem(1, 'completeddate', gn_globals.in_date_manipulator.of_now())
Else
	IF is_appeal_open_outcome = 'N' THEN
		dw_module.Object.appealoutcome.TabSequence = 0
		dw_module.Object.appealoutcome.background.color = dw_module.Object.case_number.background.color
	END IF
	IF ls_isclose = 'Y' THEN
		cb_1.Enabled = FALSE
	END IF
//	in_dao.of_setitem(1, 'appealoutcome', ls_null)
//	in_dao.of_setitem(1, 'completeddate', ldt_null)
End If


end subroutine

public function integer wf_save_changes ();long 		ll_return, i, ll_appealheaderID, ll_case_number
string 	s_error

//This shouldn't be here should it? You could have the Header not be modified but the details could be.
if dw_module.ModifiedCount() <= 0 Then Return 1

s_error = in_dao.of_save()
If s_error <> '' then 
	gn_globals.in_messagebox.of_messagebox(s_error, Exclamation!, OK!, 1)
	return 0
end if

ll_appealheaderID = long(in_dao.of_getitem(1, 'appealheaderid'))

//RAP  - For some reason the existing code only worked in debug, I had to add this...pb11 bug?
IF ll_appealheaderID = 0 THEN
	ll_case_number = Long(dw_module.object.case_number[1])
	in_dao.of_retrieve(ll_case_number)
	ll_appealheaderID = long(in_dao.of_getitem(1, 'appealheaderid'))
end if

For i = 1 to in_dao_appealdetail.RowCount()
	in_dao_appealdetail.of_setitem(i, 'appealheaderid', ll_appealheaderID)
Next

s_error = in_dao_appealdetail.of_save()
If s_error <> '' Then
	gn_globals.in_messagebox.of_messagebox(s_error, Exclamation!, OK!, 1)
	return 0
End If

s_error = in_dao_appeal_props.of_save()
If s_error <> '' Then 
	gn_globals.in_messagebox.of_messagebox(s_error, Exclamation!, OK!, 1)
	return 0
End If

RETURN 1

end function

public function long of_get_default_lob (string as_case);LONG ll_return

SetNull(ll_return)

	SELECT TOP 1 x.line_of_business_id
	INTO :ll_return
	FROM cusfocus.case_log cl
	INNER JOIN cusfocus.eligibility_xref x on x.prog_nbr = cl.case_log_generic_1 and x.carrier = cl.case_log_generic_2
	WHERE cl.case_number = :as_case
	USING SQLCA;

RETURN ll_return


end function

public function integer wf_check_required ();LONG	ll_event_rowcount, ll_event_count, ll_field_count, ll_event_id, ll_prop_row, ll_prop_rowcount, ll_appealdetailid
STRING ls_column_name, ls_column_value, ls_field_label, ls_syntax

ll_event_rowcount = dw_appeal_details.RowCount()

FOR ll_event_count = 1 to ll_event_rowcount
	ll_event_id = dw_appeal_details.object.appealeventid[ll_event_count]
	ll_appealdetailid = dw_appeal_details.object.appealdetailid[ll_event_count]
	wf_buildfieldlist(ll_event_id) // get all appeal properties for each event

	// Find the row for the appeal properties for this event
	in_dao_appeal_props.SetFilter('')
	in_dao_appeal_props.Filter()
	ll_prop_rowcount  = in_dao_appeal_props.Rowcount( )
	IF ll_prop_rowcount > 0 THEN
		ll_prop_row = in_dao_appeal_props.Find(' appealdetailid = ' + string(ll_appealdetailid), 1, ll_prop_rowcount)
	ELSE
		ll_prop_row = 0
	END IF
	
	FOR ll_field_count = 1 to i_nNumConfigFields // look for required fields
		IF i_sConfigurableField[ll_field_count].required = "Y" THEN
			ls_column_name = i_sConfigurableField[ll_field_count].column_name
			ls_field_label = i_sConfigurableField[ll_field_count].field_label
			// check for a value for each required field
			If ll_prop_row > 0 Then
				ls_column_value = in_dao_appeal_props.GetItemString(ll_prop_row, ls_column_name)
				IF IsNull(ls_column_value) THEN
					dw_appeal_details.SetRow(ll_event_count)
					dw_appeal_details.ScrollToRow(ll_event_count)
					MessageBox(gs_AppName, "Please enter a value for: " + ls_field_label)
					RETURN -1
				END IF
			End If
		END IF
	NEXT
NEXT
	
RETURN 0
end function

on w_appeal.create
int iCurrent
call super::create
this.st_3=create st_3
this.dw_module=create dw_module
this.cb_2=create cb_2
this.dw_appeal_details=create dw_appeal_details
this.st_appealdetails=create st_appealdetails
this.st_appealprops=create st_appealprops
this.st_4=create st_4
this.st_new_event=create st_new_event
this.st_deleteevent=create st_deleteevent
this.dw_history=create dw_history
this.st_history=create st_history
this.ln_5=create ln_5
this.ln_6=create ln_6
this.ln_7=create ln_7
this.ln_8=create ln_8
this.ln_9=create ln_9
this.ln_10=create ln_10
this.dw_appeal_properties=create dw_appeal_properties
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.dw_module
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.dw_appeal_details
this.Control[iCurrent+5]=this.st_appealdetails
this.Control[iCurrent+6]=this.st_appealprops
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_new_event
this.Control[iCurrent+9]=this.st_deleteevent
this.Control[iCurrent+10]=this.dw_history
this.Control[iCurrent+11]=this.st_history
this.Control[iCurrent+12]=this.ln_5
this.Control[iCurrent+13]=this.ln_6
this.Control[iCurrent+14]=this.ln_7
this.Control[iCurrent+15]=this.ln_8
this.Control[iCurrent+16]=this.ln_9
this.Control[iCurrent+17]=this.ln_10
this.Control[iCurrent+18]=this.dw_appeal_properties
end on

on w_appeal.destroy
call super::destroy
destroy(this.st_3)
destroy(this.dw_module)
destroy(this.cb_2)
destroy(this.dw_appeal_details)
destroy(this.st_appealdetails)
destroy(this.st_appealprops)
destroy(this.st_4)
destroy(this.st_new_event)
destroy(this.st_deleteevent)
destroy(this.dw_history)
destroy(this.st_history)
destroy(this.ln_5)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.ln_8)
destroy(this.ln_9)
destroy(this.ln_10)
destroy(this.dw_appeal_properties)
end on

event open;call super::open;
long 		ll_id, i, ll_appealdetail_row, ll_appealeventID, ll_appealdetailID
long 		ll_key, ll_appealtypeID, ll_return, ll_rows, ll_appealheaderID, ll_appealstatusid
string 	s_return, ls_null, ls_id, ls_status, ls_locked, ls_properties_columns, ls_isclose
datetime	ldt_null
n_bag		ln_bag
string 	ls_using_eligibility

SetNull(ldt_null)
SetNull(ls_null)
ln_bag	= Create n_bag

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the DAO and get the case number from the Message Object
//-----------------------------------------------------------------------------------------------------------------------------------
in_dao 							= 	Create n_dao_appealheader
in_dao_appealdetail			= 	Create n_dao_appealdetail
in_dao_appeal_props		 	= 	Create n_dao_appealproperties

in_dao_appealdetail.of_setparent(in_dao)
in_dao_appeal_props.w_parent = this

i_wParentWindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder

ln_bag		= 		Message.PowerObjectParm
ls_id 		=		string(ln_bag.of_get('casenumber'))
ls_locked	=		string(ln_bag.of_get('islocked'))

// Find out if an appeal has to be closed before an outcome can be entered
SELECT option_value
  INTO :is_appeal_open_outcome
  FROM cusfocus.system_options
 WHERE option_name = 'appeal open outcome'
 USING SQLCA;

CHOOSE CASE SQLCA.SQLCode
	CASE -1
		is_appeal_open_outcome = 'N'
		
	CASE 0
		// all went well
		
	CASE 100
		// set default value for the current option
		is_appeal_open_outcome = 'N'
END CHOOSE

IF is_appeal_open_outcome = 'Y' THEN
	dw_module.Object.appealoutcome.TabSequence = 100
	dw_module.Object.appealoutcome.background.color = dw_module.Object.appealtype.background.color
ELSE
	dw_module.Object.appealoutcome.TabSequence = 0
	dw_module.Object.appealoutcome.background.color = dw_module.Object.case_number.background.color
END IF

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function that sets the instance variables that are needed to insert reminders
//-----------------------------------------------------------------------------------------------------------------------------------
in_dao_appealdetail.of_set_case_information(ls_id)

IF is_appeal_open_outcome = 'N' THEN
	dw_module.of_set_locked_columns('duedate,datetermid,appealtype,appealheaderstatusid,appealoutcome,line_of_business_id,service_type_id,appealcreateddate')
ELSE
	dw_module.of_set_locked_columns('duedate,datetermid,appealtype,appealheaderstatusid,line_of_business_id,service_type_id,appealcreateddate')
END IF
dw_appeal_details.of_set_locked_columns('detailorder, appealeventid,datetermid,appealeventstatus,reminderdue,appealeventduedate,appealdetailreminder')


//-----------------------------------------------------------------------------------------------------------------------------------
// See if a AppealHeader exists for this case. If not, create a new record and seed the appropriate values in.
//-----------------------------------------------------------------------------------------------------------------------------------
If Long(ls_id) > 0 Then
	in_dao.of_retrieve(Long(ls_id))
	
	If in_dao.RowCount() = 1 Then 
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the AppealHeaderID from the parent DAO and then retrieve the detail DAO
		//-----------------------------------------------------------------------------------------------------------------------------------
		il_appealheaderID = long(in_dao.of_getitem(1, 'appealheaderid'))
		in_dao_appealdetail.of_retrieve(il_appealheaderID)
		st_1.Text = 'Edit Appeal'
		
		wf_init(ls_id)

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Check the appeal status. 
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_appealstatusid = long(in_dao.of_getitem(1, 'appealheaderstatusid'))
		
		  SELECT cusfocus.appealstatus.isclose  
 			 INTO :ls_isclose  
    		 FROM cusfocus.appealstatus  
   		WHERE cusfocus.appealstatus.id = :ll_appealstatusid   ;

		
		If ls_isclose = 'Y' and lower(is_edit_completed) <> 'y' Then
			dw_module.of_set_locked_columns('duedate,datetermid,appealtype,appealheaderstatusid,appealoutcome,line_of_business_id,service_type_id,appealcreateddate')
			dw_appeal_details.of_set_locked_columns('detailorder, appealeventid,datetermid,appealeventstatus,reminderdue,appealeventduedate,appealdetailreminder')
			dw_module.of_lock_columns()
			dw_appeal_details.of_lock_columns()
		End If
	Else
		in_dao.of_new()

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the default values into the AppealHeader DAO
		//-----------------------------------------------------------------------------------------------------------------------------------
		in_dao.SetItemStatus(1, 0, Primary!, NewModified!)
		in_dao.of_setitem(1, 'appealcreatedby', gn_globals.is_login)
		in_dao.of_setitem(1, 'appealheaderstatusid', 1)
		in_dao.of_setitem(1, 'case_number', ls_id)
		in_dao.of_setitem(1, 'appealtype', ls_null)
		in_dao.of_setitem(1, 'AppealCreatedDate', gn_globals.in_date_manipulator.of_now())
		st_1.Text = 'Log a New Appeal'

		// See if we are using the Geisinger eligibility xref	
		SELECT option_value
		  INTO :ls_using_eligibility
		  FROM cusfocus.system_options
		 WHERE option_name = 'eligibility_tabenabled'
		 USING SQLCA;
		
		CHOOSE CASE SQLCA.SQLCode
			CASE -1
				ls_using_eligibility = 'N'
				
			CASE 0
				// all went well
				
			CASE 100
				// set default value for the current option
				ls_using_eligibility = 'N'
		END CHOOSE
		
		IF ls_using_eligibility = 'Y' THEN
			ll_key = of_get_default_lob(ls_id)
			in_dao.of_setitem(1, 'line_of_business_id', ll_key)
		END IF
	End If
End If

If ls_locked = 'Y' Then
	wf_readonly(TRUE)
	dw_module.of_lock_columns()
	dw_appeal_details.of_lock_columns()
End If

idt_timer_start_time = in_dao.of_get_caselog_time()
wf_alter_window_title(idt_timer_start_time)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we have at least 1 row in the Detail DAO, then set the row to row 1 and build the Appeal Properties for the event on row 1
//-----------------------------------------------------------------------------------------------------------------------------------
If in_dao_appealdetail.RowCount() > 0 Then 
	ll_appealeventID 	= long(in_dao_appealdetail.of_getitem(1, 'appealeventID'))
	ll_appealdetailID = long(in_dao_appealdetail.of_getitem(1, 'appealdetailid'))

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Build the dynamic fields and display them.
	//-----------------------------------------------------------------------------------------------------------------------------------
	wf_buildfieldlist(ll_appealeventID)
	wf_display_appeal_props(ll_appealeventID,ll_appealdetailID)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Retrieve the case properties DAO & check to see if we have a row in it already. If not, we need to insert a row.
	//-----------------------------------------------------------------------------------------------------------------------------------
	in_dao_appeal_props.of_retrieve(long(in_dao.of_getitem(1, 'case_number')))
	
	If in_dao_appeal_props.RowCount() > 0 Then
		in_dao_appeal_props.SetFilter(' appealdetailid = ' + string(ll_appealdetailID))
		ll_rows = in_dao_appeal_props.Filter()
	End If
	
End If

If ls_locked = 'Y' Then
	ls_properties_columns = in_dao_appeal_props.of_get_all_columns()
	dw_appeal_properties.of_set_locked_columns(ls_properties_columns)
	dw_appeal_properties.of_lock_columns()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the DAOs into their datawindows and then retrieve each one.
//-----------------------------------------------------------------------------------------------------------------------------------
dw_module.of_setdao(in_dao)
dw_module.event ue_retrieve()

dw_appeal_details.of_setdao(in_dao_appealdetail)
dw_appeal_details.event ue_retrieve()
dw_appeal_properties.of_setdao(in_dao_appeal_props)
dw_appeal_properties.event ue_retrieve()


This.x = 0
This.y = 0


end event

event resize;call super::resize;//dw_module.Width = Width - (2 * dw_module.X)
//dw_appeal_details.Width = Width - (2 * dw_appeal_details.X)
//dw_appeal_properties.Width = Width - (2 * dw_appeal_properties.X)

cb_2.X = Width - cb_2.Width - 80
cb_1.X = cb_2.X - cb_1.Width - 42
st_2.Width = this.Workspacewidth()


st_3.Y = Max(Height - st_3.Height - 100, 500)
ln_4.BeginY = st_3.Y - 4
ln_4.EndY	= st_3.Y - 4
ln_3.BeginY = st_3.Y - 8
ln_3.EndY	= st_3.Y - 8

ln_4.EndX	=	This.WorkspaceWidth() 
ln_3.EndX	=	This.WorkspaceWidth()
st_3.Width	=	this.workspacewidth()

cb_2.Y = ln_3.EndY + 36
cb_1.Y = cb_2.Y

//dw_module.Height = st_3.Y - 60 - dw_module.Y
end event

event close;call super::close;destroy 	in_dao
Destroy 	in_dao_appealdetail
Destroy 	in_dao_appeal_props
Destroy	in_calendar_column_service

// Refresh the appeals tab with any changes
i_tabFolder.tabpage_appeals.of_retrieve(i_wParentWindow.i_cSelectedCase)

end event

event closequery;call super::closequery;boolean bIsModified = false
int iReturn

dw_module.accepttext( )
dw_appeal_properties.accepttext( )
dw_appeal_details.accepttext( )
	
IF 		in_dao.modifiedcount() > 0 THEN
	bIsModified = true
END IF
IF		in_dao_appealdetail.modifiedcount() > 0 THEN
	bIsModified = true
END IF
IF 	in_dao_appeal_props.modifiedcount() > 0 THEN
	bIsModified = true
END IF

If bIsModified THEN
	iReturn = MessageBox(gs_AppName, "Do you want to save the changes to this appeal?", Question!, YesNo!)
	IF iReturn = 1 THEN
		RETURN 1
	END IF
END IF
RETURN 0
end event

type p_1 from w_deal_display_basic`p_1 within w_appeal
integer y = 24
string picturename = "Notepad Large Icon (White).bmp"
end type

type st_1 from w_deal_display_basic`st_1 within w_appeal
integer y = 60
integer width = 1691
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
string text = "Create a New Appeal"
end type

type cb_1 from w_deal_display_basic`cb_1 within w_appeal
integer x = 2944
integer y = 2532
integer height = 80
integer taborder = 30
integer weight = 700
fontcharset fontcharset = ansi!
string text = "&OK"
end type

event cb_1::clicked;int li_return

li_return = dw_appeal_properties.AcceptText()
IF li_return = 1 THEN
	li_return = dw_appeal_details.Accepttext( )
	IF li_return = 1 THEN
		li_return = dw_module.accepttext( )
		IF li_return = 1 THEN
			li_return = wf_save_changes()
		END IF
	END IF
END IF

If li_return = 1 Then 
	close(parent)
End If


end event

type st_2 from w_deal_display_basic`st_2 within w_appeal
integer width = 3986
string text = "Log a New Issue"
end type

type ln_1 from w_deal_display_basic`ln_1 within w_appeal
end type

type ln_2 from w_deal_display_basic`ln_2 within w_appeal
end type

type ln_3 from w_deal_display_basic`ln_3 within w_appeal
integer beginy = 2468
integer endy = 2468
end type

type ln_4 from w_deal_display_basic`ln_4 within w_appeal
integer beginy = 2508
integer endy = 2508
end type

type st_3 from statictext within w_appeal
integer y = 2492
integer width = 4005
integer height = 152
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217730
boolean focusrectangle = false
end type

type dw_module from u_reference_display_datawindow within w_appeal
event ue_refresh_duedates ( )
event ue_set_status ( long al_status_id )
integer x = 5
integer y = 248
integer width = 3899
integer height = 352
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_gui_appeal_header"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_refresh_duedates();//long	ll_datetermid, row
//string	ls_messagebox
//datetime	ldt_duedate
//
//
//n_appealdetail_duedate ln_duedate
//
//
//ln_duedate = Create n_appealdetail_duedate
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// Get the date term ID & the time that the appeal clock should start from
////-----------------------------------------------------------------------------------------------------------------------------------
//ll_datetermID 		= 	long(in_dao.of_getitem(row,'datetermid'))
//idt_timer_start_time = in_dao.of_get_caselog_time()
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// Call the function to calculate the due date, then set the new value into the DAO
////-----------------------------------------------------------------------------------------------------------------------------------
//ldt_duedate 		= 	ln_duedate.of_get_due_date(ll_datetermID, idt_timer_start_time)
//in_dao.of_setitem(row, 	'duedate', 	ldt_duedate)
//
//wf_alter_window_title(idt_timer_start_time)
//
//ls_messagebox = 'Would you like to recalculate the due dates for all the existing appeal details?'
//	
//Choose Case gn_globals.in_messagebox.of_messagebox(ls_messagebox, Question!, YesNoCancel!, 2)
//	Case 1
//		in_dao_appealdetail.of_calculate_duedates(idt_timer_start_time)
//End Choose
//
//Destroy ln_duedate

//dw_appeal_details.Event ue_retrieve()
end event

event ue_set_status(long al_status_id);THIS.object.appealheaderstatusid[1] = al_status_id
in_dao.object.appealheaderstatusid[1] = al_status_id
THIS.AcceptText()
end event

event ue_notify;call super::ue_notify;choose case as_message
		
	case 'validation'
		
		setcolumn(string(aany_argument))
		setfocus()
		
	Case 'refresh duedates'
		triggerevent('ue_refresh_duedates')
		
		
end choose

end event

event ue_refreshtheme;call super::ue_refreshtheme;
//dw_module.Object.ID.background.Color = this.object.datawindow.color

end event

event constructor;call super::constructor;this.settransobject(SQLCA)
this.triggerevent('ue_refreshtheme')



//Choose Case gn_globals.in_security.of_get_security('issue description')
//		
//	Case 3
//		dw_module.Object.description.tabsequence = 1000
//		
//	Case 2
//		dw_module.Object.description.tabsequence = 1000
//	case 0
//		dw_module.Object.description.tabsequence = 0
//end choose

end event

event itemchanged;call super::itemchanged;string 	ls_null, ls_isclose, ls_messagebox, ls_column_name, ls_column_name_test, ls_return, ls_value
long		ll_return, ll_datetermID, ll_appealstatusid, ll_line_of_business_id, ll_appeal_type_id, ll_null
integer 	li_return, li_null
datetime	ldt_headertime, ldt_duedate, ldt_now, ldt_null
DATAWINDOWCHILD ldwc_appeal_type, ldwc_service_type

n_appealdetail_duedate ln_duedate

SetNull(ldt_null)  
SetNull(ll_null)  
SetNull(li_null)  

ls_column_name = this.getcolumnname()
ls_column_name_test = dwo.name

Choose Case ls_column_name
	Case 'appealheaderstatusid'
		
		ll_appealstatusid = long(data)
		
		SELECT cusfocus.appealstatus.isclose  
		 INTO :ls_isclose  
		 FROM cusfocus.appealstatus  
		WHERE cusfocus.appealstatus.id = :ll_appealstatusid;

		//-----------------------------------------------------------------------------------------------------------------------------------
		// When the Appeal is marked "Complete" then unlock the Outcome field and make it editable.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ls_isclose = 'Y' Then
			// Have all required fields been entered?
			li_return = wf_check_required()
			IF li_return = -1 THEN
				ll_appealstatusid = in_dao.GetItemNumber(row, "appealheaderstatusid", Primary!, TRUE)
				THIS.EVENT POST ue_set_status(ll_appealstatusid)
				Return 1
			END IF
			
			ls_messagebox = 'Are you sure you want to complete this appeal? Only users that have rights to edit complete appeals will be able to edit this appeal once complete.'
			
			Choose Case gn_globals.in_messagebox.of_messagebox(ls_messagebox, Question!, YesNo!, 2)
				Case 1
					dw_module.Object.appealoutcome.TabSequence = 100
					dw_module.Object.appealoutcome.background.color = dw_module.Object.appealtype.background.color
					in_dao.of_setitem(1, 'completeddate', gn_globals.in_date_manipulator.of_now())
				CASE Else
					ll_appealstatusid = in_dao.GetItemNumber(row, "appealheaderstatusid", Primary!, TRUE)
					THIS.EVENT POST ue_set_status(ll_appealstatusid)
					Return 1
			End Choose
		Else
			IF is_appeal_open_outcome = 'N' THEN
				dw_module.Object.appealoutcome.TabSequence = 0
				dw_module.Object.appealoutcome.background.color = dw_module.Object.case_number.background.color
				in_dao.of_setitem(row, 'appealoutcome', li_null)
			END IF
			in_dao.of_setitem(1, 'completeddate', ldt_null)
		End If		
	Case 'datetermid'
		ln_duedate = Create n_appealdetail_duedate
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the date term ID & the time that the appeal clock should start from
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_datetermID = long(in_dao.of_getitem(row,'datetermid'))
		ldt_headertime		=	idt_timer_start_time
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Call the function to calculate the due date, then set the new value into the DAO
		//-----------------------------------------------------------------------------------------------------------------------------------
		ldt_duedate 		= 	ln_duedate.of_get_due_date(ll_datetermID, ldt_headertime)
		in_dao.of_setitem(row, 	'duedate', 	ldt_duedate)
		
		Destroy ln_duedate
	Case  'appealcreateddate'
		ln_duedate = Create n_appealdetail_duedate
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the date term ID & the time that the appeal clock should start from
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_datetermID 		= 	long(in_dao.of_getitem(row,'datetermid'))
		idt_timer_start_time = in_dao.of_get_caselog_time()
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Call the function to calculate the due date, then set the new value into the DAO
		//-----------------------------------------------------------------------------------------------------------------------------------
		ldt_duedate 		= 	ln_duedate.of_get_due_date(ll_datetermID, idt_timer_start_time)
		in_dao.of_setitem(row, 	'duedate', 	ldt_duedate)
		
		in_dao_appealdetail.of_calculate_duedates(idt_timer_start_time)
		
		wf_alter_window_title(idt_timer_start_time)
		
		Destroy ln_duedate
		
	Case 'service_type_id'
		ll_line_of_business_id = THIS.Object.line_of_business_id[row]
		ll_appeal_type_id = THIS.Object.appealtype[row]
		wf_build_defaults(ll_line_of_business_id, ll_appeal_type_id, long(data))

//		CHOOSE CASE dwo.Name
		
	CASE 'line_of_business_id'
		GetChild('appealtype', ldwc_Appeal_Type)
		ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + data)
		ll_return = ldwc_appeal_type.Filter()
		ll_return = in_dao.SetItem(row, "appealtype", ll_null)
		ll_return = in_dao.SetItem(row, "service_type_id", ll_null)
		
	CASE 'appealtype'
		GetChild('servicetype', ldwc_Service_Type)
		ll_line_of_business_id = THIS.Object.line_of_business_id[row]
		ll_return = ldwc_service_Type.SetFilter("line_of_business_id = " + String(ll_line_of_business_id) + " and appealtypeid = " + data)
		ll_return = ldwc_service_type.Filter()
		ll_return = in_dao.SetItem(row, "service_type_id", ll_null)
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Refresh the GUI
//-----------------------------------------------------------------------------------------------------------------------------------
this.event ue_retrieve()
ll_return = THIS.Object.datetermid[row]
this.SetColumn(ls_column_name)

end event

event clicked;call super::clicked;string ls_null

Choose Case dwo.Type 
	Case 'bitmap' 	
		Choose Case dwo.Name
			Case 'appealcreateddate'
				This.Event Post ue_notify('refresh duedates', ls_null)
	
		End Choose
End Choose

end event

event rowfocuschanged;call super::rowfocuschanged;//	RAP - created 11/13/2006 to manage DDDWs
DATAWINDOWCHILD ldwc_appeal_type, ldwc_service_type
LONG ll_line_of_business_id, ll_appeal_type_id, ll_return
String ls_filter

IF currentrow > 0 THEN
	GetChild('appealtype', ldwc_Appeal_Type)
	ll_line_of_business_id = THIS.Object.line_of_business_id[currentrow]
	ls_filter = "line_of_business_id = " + String(ll_line_of_business_id)
	IF IsNull(ls_filter) THEN ls_filter = "0 = 1" // filter out everything
	ll_return = ldwc_Appeal_Type.SetFilter(ls_filter)
	ll_return = ldwc_appeal_type.Filter()
	
	GetChild('service_type_id', ldwc_Service_Type)
	ll_appeal_type_id = THIS.Object.appealtype[currentrow]
	ls_filter += " and appealtypeid = " + String(ll_appeal_type_id)
	IF IsNull(ls_filter) THEN ls_filter = "0 = 1" // filter out everything
	ll_return = ldwc_service_Type.SetFilter(ls_filter)
	ll_return = ldwc_service_type.Filter()
END IF
end event

type cb_2 from u_commandbutton within w_appeal
integer x = 3401
integer y = 2532
integer height = 80
integer taborder = 40
boolean bringtotop = true
fontcharset fontcharset = ansi!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;call super::clicked;close(parent)
end event

type dw_appeal_details from u_reference_display_datawindow within w_appeal
integer y = 700
integer width = 3977
integer height = 688
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_gui_appeldetail"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;long	ll_appealdetailID, ll_appealeventID, ll_row, ll_rowcount
long ll_null, ll_appealstatusID
string ls_return, ls_isclose
n_bag ln_bag
boolean ib_reretrieve
Integer li_protected, li_return

SetNull(ll_null)

ll_row = row

SetRedraw(FALSE)

Choose Case dwo.Type 
	Case 'bitmap' 	
		Choose Case dwo.Name
			Case 'p_minus', 'p_plus'
				ab_show_detail_log = Not ab_show_detail_log
						
				If  dw_appeal_details.Object.p_plus.Visible = '1' Then
					dw_appeal_details.Object.p_plus.Visible = 0
					dw_appeal_details.Object.p_minus.Visible = 1
					
					dw_appeal_details.Object.DataWindow.Detail.Height = 240
					
				Else
					dw_appeal_details.Object.p_plus.Visible = 1
					dw_appeal_details.Object.p_minus.Visible = 0
					
					dw_appeal_details.Object.DataWindow.Detail.Height = 84
				End IF
				
//				dw_appeal_details.event ue_retrieve()
			Case	'p_note', 'p_nonote'

					ln_bag = Create n_bag

					ll_appealdetailID = long(in_dao_appealdetail.of_getitem(row, 'appealdetailID'))
					
					ln_bag.of_set('appealdetailid', ll_appealdetailID)

					li_protected = integer(THIS.object.datetermid.protect)
		
					If li_protected = 1 And is_edit_completed = 'N' Then ln_bag.of_set('islocked', 'Y')

					If in_dao_appealdetail.ib_readonly = TRUE Then ln_bag.of_set('islocked', 'Y')
					
					// RAP - for a new appeal, need to save first, to create the detail row in the database
					li_return = wf_save_changes()
					IF li_return = 0 THEN RETURN
					
					OpenWithParm(w_appealdetail_note, ln_bag)
					
					ls_return = Message.StringParm
					
					If ls_return = 'Y' Then 
						in_dao_appealdetail.SetItem(row, 'hasnote', 'Y')
					Else 
						in_dao_appealdetail.SetItem(row, 'hasnote', 'N')
					End If
					
					dw_appeal_details.event ue_retrieve()
		End Choose
End Choose

If ll_row > 0 and ll_row <= this.RowCount() Then 
	il_appealdetail_row = ll_row
	SelectRow(-1, FALSE)
	this.ScrollToRow(ll_row)
	SelectRow(ll_row, TRUE)
	dw_appeal_properties.event ue_retrieve()
End If

SetRedraw(TRUE)

end event

event itemchanged;call super::itemchanged;long	ll_datetermID, i, ll_order_array[], ll_count, ll_null, ll_return
long	ll_appealdetailID, ll_appealeventID, ll_row, ll_rowcount, ll_reminderID
string ls_casenumber, ls_data, ls_reminder
datetime	ldt_detailtime, ldt_null, ldt_duedate, ldt_reminder_due

n_appealdetail_duedate ln_duedate
ln_duedate = Create n_appealdetail_duedate

SetNull(ldt_null)
setnull(ll_null)

Setredraw(FALSE)

Choose Case lower(this.getcolumnname())
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the dateterm changes, then we need to recalculate the due date.
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'datetermid'
		ll_datetermID = long(data)
		ldt_detailtime	=	idt_timer_start_time
		
		ldt_duedate 		= 	ln_duedate.of_get_due_date(ll_datetermID, ldt_detailtime)
		in_dao_appealdetail.of_setitem(row, 	'appealeventduedate', 	ldt_duedate)

		ls_reminder = THIS.Object.appealdetailreminder[row]
		If ls_reminder = 'Y' Then
			ldt_duedate = ln_duedate.of_get_reminder_due_date(ll_datetermID, ldt_duedate)
			in_dao_appealdetail.of_setitem(row, 'reminderdue', ldt_duedate)
		END IF
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the appealdetailreminder changes, we need to recalculate the reminder due date.
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'appealdetailreminder'
		If data = 'Y' Then
			ll_datetermID = long(in_dao_appealdetail.of_getitem(row,'datetermID'))
			
			ldt_detailtime	=	in_dao_appealdetail.getitemdatetime(row, 'appealeventduedate')
			
			ldt_duedate = ln_duedate.of_get_reminder_due_date(ll_datetermID, ldt_detailtime)
			
			in_dao_appealdetail.of_setitem(row, 'reminderdue', ldt_duedate)
		Else
			ll_reminderID = long(in_dao_appealdetail.of_getitem(row,'reminderid'))
			
			in_dao_appealdetail.of_delete_reminder(ll_reminderID)
			ll_return = in_dao_appealdetail.SetItem(row, 'reminderdue', ldt_null)
			in_dao_appealdetail.SetItem(row, 'reminderid', ll_null)
		End If
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// When the appealevent changes, we need to refresh the appeal properties
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'appealeventid'
		ll_appealeventID 	= 	long(data)
		ll_appealdetailID	=	long(in_dao_appealdetail.of_getitem(row, 'appealdetailid'))

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Build the dynamic fields and display them
		//-----------------------------------------------------------------------------------------------------------------------------------
		wf_buildfieldlist(ll_appealeventID)
		wf_display_appeal_props(ll_appealeventID,ll_appealdetailID)

		in_dao_appeal_props.of_setitem(1, 'source_type', ll_appealeventID)
		in_dao_appeal_props.of_setitem(1, 'case_number', in_dao.of_getitem(1, 'case_number'))
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Filter to this specific AppealDetailID
		//-----------------------------------------------------------------------------------------------------------------------------------
		in_dao_appeal_props.SetFilter( 'appealdetailid = ' + string(ll_appealdetailID))
		in_dao_appeal_props.Filter()
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Check to see if a row already exists for this event, if it does not then insert a new row so the user can enter data.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_rowcount = in_dao_appeal_props.RowCount()
		
	Case 'appealeventstatus'
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the event is closed, then set the completed date. If it moves from closed to something else, null out the completed date
		//-----------------------------------------------------------------------------------------------------------------------------------
		If data = 'C' Then 	
			in_dao_appealdetail.of_setitem(row, 'completeddate', gn_globals.in_date_manipulator.of_now())
		Else 
			in_dao_appealdetail.of_setitem(row, 'completeddate', ldt_null)
		End If
		
	Case 'detailorder'
		//-----------------------------------------------------------------------------------------------------------------------------------

		// Check the detail order for each existing row. If a row already has that order then prompt the user and return.
		//-----------------------------------------------------------------------------------------------------------------------------------

		For i = 1 to dw_appeal_details.Rowcount()
			If dw_appeal_details.GetItemNumber(i, 'detailorder') = long(data) Then ll_count = 1
		Next
		
		If ll_count = 1 Then
			in_dao_appealdetail.in_message.event ue_notify_client('Validation','detailorder')
			gn_globals.in_messagebox.of_messagebox('Two appeal events have the same event number, please change the event number so that each event has a unique event number.', Exclamation!, OK!, 1)
			dw_appeal_details.event ue_retrieve()
			return 
		End If

		//-----------------------------------------------------------------------------------------------------------------------------------

		// Sort the DAO with the newly changed order and refresh the GUI so the details are in order again.
		//-----------------------------------------------------------------------------------------------------------------------------------

		in_dao_appealdetail.Sort()
		
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Refresh the GUI
//-----------------------------------------------------------------------------------------------------------------------------------
dw_appeal_details.event ue_retrieve()

If row > 0 and row <= this.RowCount() Then 
	il_appealdetail_row = row
	SelectRow(-1, FALSE)
	this.ScrollToRow(row)
	SelectRow(row, TRUE)
	dw_appeal_properties.event ue_retrieve()
End If

Setredraw(TRUE)

Destroy ln_duedate
end event

event rowfocuschanged;call super::rowfocuschanged;long ll_appealdetailid, ll_appealeventid

//-----------------------------------------------------------------------------------------------------------------------------------
// Check for a valid row
//-----------------------------------------------------------------------------------------------------------------------------------
If currentrow > 0 and currentrow <= in_dao_appealdetail.RowCount() Then 
	
	SelectRow(-1, FALSE)
	SelectRow(currentrow, TRUE)

	ll_appealdetailID =	long(in_dao_appealdetail.of_getitem(currentrow, 'appealdetailid'))
	ll_appealeventID 	= 	long(in_dao_appealdetail.of_getitem(currentrow, 'appealeventid'))

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Build the dynamic appeal props and display them
	//-----------------------------------------------------------------------------------------------------------------------------------
	wf_buildfieldlist(ll_appealeventID)
	wf_display_appeal_props(ll_appealeventID,ll_appealdetailID)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Filter on this specific AppealDetailID
	//-----------------------------------------------------------------------------------------------------------------------------------
	in_dao_appeal_props.SetFilter( 'appealdetailid = ' + string(ll_appealdetailID))
	in_dao_appeal_props.Filter()
	
	//------------------------------------------------------
	// Retrieve property history
	//------------------------------------------------------
	wf_display_property_history()
	dw_appeal_properties.event ue_retrieve()
End If
end event

type st_appealdetails from statictext within w_appeal
integer x = 50
integer y = 600
integer width = 375
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Details"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_appealprops from statictext within w_appeal
integer x = 50
integer y = 1380
integer width = 635
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Event Properties"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_appeal
integer x = 50
integer y = 204
integer width = 517
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Information"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_new_event from statictext within w_appeal
integer x = 3145
integer y = 640
integer width = 334
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "New Event..."
boolean focusrectangle = false
end type

event clicked;long		ll_appealheaderID, ll_row, ll_appealprop_row, ll_appealdetailID
int li_return

ll_appealheaderID = long(in_dao.of_getitem(1, 'appealheaderid'))

ll_row = in_dao_appealdetail.of_new_appealdetail(ll_appealheaderID)
ll_appealprop_row = in_dao_appeal_props.of_new_with_return()

ll_appealdetailID = long(in_dao_appealdetail.of_getitem(ll_row, 'appealdetailid'))
in_dao_appeal_props.SetItem(ll_appealprop_row, 'appealdetailid', ll_appealdetailID)

dw_appeal_details.event ue_retrieve()
dw_appeal_details.SetRow(ll_row)
dw_appeal_details.SetColumn('AppealEventID')
end event

type st_deleteevent from statictext within w_appeal
integer x = 3525
integer y = 640
integer width = 402
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Delete Event..."
boolean focusrectangle = false
end type

event clicked;long ll_appealdetail_ID, ll_return

If il_appealdetail_row = 0 Or il_appealdetail_row > dw_appeal_details.RowCount() Then
	//Do nothing as they haven't picked a row or have an invalid row.
Else
	
	
	Choose Case gn_globals.in_messagebox.of_messagebox('Are you sure you want to delete this appeal event?', Question!, YesNoCancel!, 2)
		Case 1
			ll_appealdetail_ID = long(dw_appeal_details.getitemnumber(il_appealdetail_row, 'appealdetailid'))
		
			If Not isnull(ll_appealdetail_ID) Then
				in_dao_appealdetail.of_delete_appealdetail(ll_appealdetail_ID)
				in_dao_appeal_props.of_delete_appealprop(ll_appealdetail_ID)
			Else
				ll_return = dw_appeal_details.DeleteRow(il_appealdetail_row)
			End If
		Case Else
			Return 0
	End Choose
	
	dw_appeal_details.event ue_retrieve()
	dw_appeal_properties.event ue_retrieve()
End If
end event

type dw_history from u_reference_display_datawindow within w_appeal
boolean visible = false
integer x = 32
integer y = 1464
integer width = 3922
integer height = 1020
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_appeal_properties_history"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;is_original_history_syntax = this.Describe("DataWindow.Syntax")
end event

type st_history from statictext within w_appeal
integer x = 3483
integer y = 1408
integer width = 393
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "View History..."
boolean focusrectangle = false
end type

event clicked;IF THIS.Text = "View History..." THEN
	dw_appeal_properties.Visible = FALSE
	dw_history.Visible = TRUE
	dw_history.SetFocus()
	THIS.Text = "View Current..."
ELSE
	dw_appeal_properties.Visible = TRUE
	dw_appeal_properties.SetFocus()
	dw_history.Visible = FALSE
	THIS.Text = "View History..."
END IF
end event

type ln_5 from line within w_appeal
integer linethickness = 4
integer beginx = 462
integer beginy = 632
integer endx = 3899
integer endy = 632
end type

type ln_6 from line within w_appeal
long linecolor = 16777215
integer linethickness = 4
integer beginx = 462
integer beginy = 636
integer endx = 3899
integer endy = 648
end type

type ln_7 from line within w_appeal
integer linethickness = 4
integer beginx = 741
integer beginy = 1404
integer endx = 3899
integer endy = 1404
end type

type ln_8 from line within w_appeal
long linecolor = 16777215
integer linethickness = 4
integer beginx = 741
integer beginy = 1408
integer endx = 3899
integer endy = 1408
end type

type ln_9 from line within w_appeal
integer linethickness = 4
integer beginx = 608
integer beginy = 228
integer endx = 3899
integer endy = 228
end type

type ln_10 from line within w_appeal
long linecolor = 16777215
integer linethickness = 4
integer beginx = 608
integer beginy = 260
integer endx = 3899
integer endy = 260
end type

type dw_appeal_properties from u_reference_display_datawindow within w_appeal
integer x = 32
integer y = 1460
integer width = 3922
integer height = 1032
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_appeal_properties"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;is_original_syntax = this.Describe("DataWindow.Syntax")
end event

event itemchanged;call super::itemchanged;String ls_null

SetNull(ls_null)

If dwo.Type = 'column' Then 
	If data = '(None)' Then
		in_dao_appeal_props.setitem(row, dwo.Name, ls_null)
	End If
End If


end event

event itemerror;int li_return
string ls_name

// the error displayed var is used to stop double error messages from popping up

ls_name = mid(dwo.name,1,14)

IF ls_name = 'appeal_generic' THEN // this will catch validation rules and edit masks
		li_return = 0
ELSE
	li_return = 2
END IF
return li_return
end event

event losefocus;call super::losefocus;string ls_text

// override this event. The accepttext causes the validation rule to throw two message boxes
// RAP 1/21/09 - changed back to extend so that the last appeal property gets accepted if they change events after entering it without enter or tabbing out
ls_text = ''
end event

