$PBExportHeader$u_tabpage_case_properties.sru
$PBExportComments$Case Properties and Inquiry Case Properties tab object.
forward
global type u_tabpage_case_properties from u_tabpg_std
end type
type rb_other from radiobutton within u_tabpage_case_properties
end type
type rb_inquiry from radiobutton within u_tabpage_case_properties
end type
type rb_current from radiobutton within u_tabpage_case_properties
end type
type dw_case_properties from u_dw_std within u_tabpage_case_properties
end type
type ln_1 from line within u_tabpage_case_properties
end type
type ln_highlight from line within u_tabpage_case_properties
end type
end forward

global type u_tabpage_case_properties from u_tabpg_std
integer width = 3534
integer height = 784
string text = "Case Properties"
event ue_notify ( string as_message,  any aany_argument )
rb_other rb_other
rb_inquiry rb_inquiry
rb_current rb_current
dw_case_properties dw_case_properties
ln_1 ln_1
ln_highlight ln_highlight
end type
global u_tabpage_case_properties u_tabpage_case_properties

type variables
// Constants
STRING						c_CurrentRB = 'C'
STRING						c_InquiryRB = 'I'
STRING						c_OtherRB = 'O'

// Instance Variables
STRING						i_cSourceType
STRING						i_cSourceTypeInquiry
STRING						i_cCaseType
STRING						i_cCaseTypeOther
STRING						i_cCasePropsOptions
STRING						i_cInqCasePropsOptions
STRING						i_cCurrentView

INTEGER						i_nNumConfigFields

W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder

S_FIELDPROPERTIES			i_sConfigurableField[]

DataStore 					i_dsFields
n_calendar_column_service_props in_calendar_column_service_props
n_datawindow_graphic_service_manager in_datawindow_graphic_service_manager
end variables

forward prototypes
public function integer fu_displayfields ()
public subroutine fu_setviewavailability ()
public function integer fu_buildfieldlist ()
end prototypes

event ue_notify(string as_message, any aany_argument);//-----------------------------------------------------------------------------------------------------------------------------------
// Pass all unknown events to the service manager.  This will allow you to send any event to the service manager to be propogated.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.Event ue_notify(as_message, aany_argument)
End If

end event

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
//  12/8/2000 K. Claver  Configured to be used on the case properties tab.
//  01/11/01 M. Caruso   Code to reinitialize the datawindow options has been removed.
//  01/18/01 M. Caruso   Added Nil-Is-Null clause to validation rules for edit mask fields.
//*********************************************************************************************

CONSTANT	INTEGER	col1labelX = 27
CONSTANT	INTEGER	col2labelX = 1107
CONSTANT	INTEGER	col3labelX = 2247
CONSTANT	INTEGER	col1cellX = 579
CONSTANT	INTEGER	col2cellX = 1659
CONSTANT	INTEGER	col3cellX = 2800
CONSTANT INTEGER  rightmargin = 3450
CONSTANT INTEGER	colwidth1 = 500
CONSTANT INTEGER	colwidth2 = 1555
CONSTANT INTEGER	colwidth3 = 2610
CONSTANT STRING	labelwidth = '545'
CONSTANT STRING	cellheight = '64'
CONSTANT INTEGER	charwidth = 40
CONSTANT INTEGER	y_offset = 92

LONG		l_nColCount, l_nMaxX, l_nMaxY, l_nX, l_nY, l_nIndex, l_nPos, l_nBackColor
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nNewColId, l_nTabSeq
INTEGER  l_nNewTabSeq, l_nNumChars, l_nCellWidth, l_nNextCellWidth, l_nDWIndex
STRING	l_sColName, l_cModString, l_cMsg, l_cSyntax, l_cObjName, l_cMask
STRING	l_cDisplayOnly, l_cNewLine, l_cLabelX, l_cCellX, l_cUpdate, l_cProtect
String   l_cRequired, l_cVisible, l_cLabelWeight, l_cNilIsNullClause, ls_syntax

// determine the location of the last predefined column in the datawindow
l_nColCount = LONG (dw_case_properties.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO l_nColCount
	IF dw_case_properties.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = dw_case_properties.Describe ('#' + STRING (l_nIndex) + '.Name')
		l_nX = INTEGER (dw_case_properties.Describe("#" + STRING(l_nIndex) + '.X'))
		l_nY = INTEGER (dw_case_properties.Describe("#" + STRING(l_nIndex) + '.Y'))
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
		l_nNewTabSeq = INTEGER (dw_case_properties.Describe("#" + STRING(l_nIndex) + '.tabsequence'))
		IF l_nTabSeq < l_nNewTabSeq THEN
			l_nTabSeq = l_nNewTabSeq
		END IF
	END IF
NEXT

// determine if last field is in a group box and prep accordingly
l_cMsg = dw_case_properties.Describe ("DataWindow.Objects")
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
		l_nX = INTEGER (dw_case_properties.Describe (l_cObjName + ".X"))
		l_nY = INTEGER (dw_case_properties.Describe (l_cObjName + ".Y")) + &
				 INTEGER (dw_case_properties.Describe (l_cObjName + ".Height"))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxY = l_nY
			l_nMaxX = col1cellX
			l_nLastCol = -1
		END IF
	END IF
LOOP WHILE pos (l_cMsg, "~t", l_nIndex) > 0

//DO WHILE pos (l_cMsg, "~t", l_nPos + 1) > 0
//	l_nIndex = l_nPos + 1
//	l_nPos = pos (l_cMsg, "~t", l_nPos + 1)
//	l_cObjName = Mid (l_cMsg, l_nIndex, (l_nPos - l_nIndex))
//	IF pos (l_cObjName, "gb_") > 0 THEN
//		l_nX = INTEGER (dw_case_properties.Describe (l_cObjName + ".X"))
//		l_nY = INTEGER (dw_case_properties.Describe (l_cObjName + ".Y")) + &
//				 INTEGER (dw_case_properties.Describe (l_cObjName + ".Height"))
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
	l_nX = INTEGER (dw_case_properties.Describe("#" + STRING(l_nLastCol) + '.X'))
	l_nY = INTEGER (dw_case_properties.Describe("#" + STRING(l_nLastCol) + '.Y'))
	l_nWidth = INTEGER (dw_case_properties.Describe("#" + STRING(l_nLastCol) + '.Width'))
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
l_cSyntax = dw_case_properties.Describe("DataWindow.Syntax")

// add the new fields
FOR l_nIndex = 1 TO THIS.i_nNumConfigFields
	l_sColName = 'case_properties.'+THIS.i_sConfigurableField[l_nIndex].column_name
	
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

	// For Other Source Types, allow database updates
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
		l_cRequired = 'yes'
		l_cLabelWeight = '700'
	ELSE
		l_cRequired = 'no'
		l_cLabelWeight = '400'
	END IF
	
	// add the new column label
	l_nPos = Pos (l_cSyntax, "htmltable") - 1
	l_cModString = 'text(name='+THIS.i_sConfigurableField[l_nIndex].column_name+'_t band=detail ' + &
						'font.charset="0" font.face="Tahoma" ' + &
						'font.family="2" font.height="-8" font.pitch="2" font.weight="'+l_cLabelWeight+'" ' + &
						'background.mode="1" background.color="536870912" color="0" alignment="1" ' + &
						'border="0" x="'+l_cLabelX+'" y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" ' + &
						'width="'+labelwidth+'" text="'+THIS.i_sConfigurableField[l_nIndex].field_label+':" )' + l_cNewLine
	uf_StringInsert(l_cSyntax, l_cModString, l_nPos)
	
	// prepare to add the new column
	l_nColCount = l_nColCount + 1
	IF l_nTabSeq >= 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable
	
	//Lock it down?
	IF i_cCurrentView = c_CurrentRB THEN
		
		//Decide to enable/disable based on case status.
		IF i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = i_wParentWindow.i_cStatusClosed THEN
			
			IF i_wParentWindow.i_bSupervisorRole AND NOT i_wParentWindow.i_bCaseLocked THEN
				IF THIS.i_sConfigurableField[l_nIndex].locked = 'Y' THEN
					l_cDisplayOnly = 'yes'
					l_cProtect = '1'
					l_nBackColor = RGB( 192, 192, 192 )
				ELSE
					l_cDisplayOnly = 'no'
					l_cProtect = '0'
					l_nBackColor = RGB( 255, 255, 255 ) 
				END IF
			ELSE
				l_cDisplayOnly = 'yes'
				l_cProtect = '1'
				l_nBackColor = RGB( 192, 192, 192 )
			END IF
			
		ELSEIF i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = i_wParentWindow.i_cStatusVoid THEN
			l_cDisplayOnly = 'yes'
			l_cProtect = '1'
			l_nBackColor = RGB( 192, 192, 192 )
		ELSE
			IF NOT i_wParentWindow.i_bCaseLocked THEN
				IF THIS.i_sConfigurableField[l_nIndex].locked = 'Y' THEN
					l_cDisplayOnly = 'yes'
					l_cProtect = '1'
					l_nBackColor = RGB( 192, 192, 192 )
				ELSE
					l_cDisplayOnly = 'no'
					l_cProtect = '0'
					l_nBackColor = RGB( 255, 255, 255 ) 
				END IF
			ELSE
				l_cDisplayOnly = 'yes'
				l_cProtect = '1'
				l_nBackColor = RGB( 192, 192, 192 )
			END IF
		END IF
	ELSE
		l_cDisplayOnly = 'yes'
		l_cProtect = '1'
		l_nBackColor = RGB( 192, 192, 192 )
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
			'border="5" alignment="0" format="[general]" protect="'+l_cProtect+'" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
			'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
			'edit.codetable=no edit.displayonly=no edit.format="" edit.hscrollbar=no ' + &
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
			l_cModString = &
			'column(band=detail id='+STRING (l_nColCount)+' alignment="0" tabsequence='+STRING (l_nTabSeq)+' border="5" color="0" x="'+l_cCellX+'" y="'+STRING (l_nMaxY)+'" ' + & 
			'height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" format="[general]" html.valueishtml="0"  name='+THIS.i_sConfigurableField[l_nIndex].column_name + ' ' + & 
			'protect="'+l_cProtect+'" visible="'+l_cVisible+'" dddw.name=dddw_caseprops_generic dddw.displaycolumn=casepropertiesvalues_value ' + & 
			'dddw.datacolumn=casepropertiesvalues_value dddw.percentwidth=50 dddw.lines=0 dddw.limit=0 ' + & 
			'dddw.allowedit=no dddw.required='+l_cRequired+' dddw.useasborder=yes dddw.case=any dddw.imemode=0 dddw.vscrollbar=yes ' + & 
			'dddw.autoretrieve=no  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" '+ & 
			'font.pitch="2" font.charset="0" background.mode="2" background.color="'+String( l_nBackColor )+'" ) ' //+ l_cNewLine
	End If
		
	uf_StringInsert(l_cSyntax, l_cModString, l_nPos)
	
NEXT

// resize the detail band if necessary
IF (l_nMaxY + 64) > LONG (dw_case_properties.Object.Datawindow.Detail.Height) THEN

	l_nPos = Pos (l_cSyntax, "detail(height=") + 14
	l_nNumChars = Pos (l_cSyntax, " ", l_nPos) - l_nPos
	l_cSyntax = Replace (l_cSyntax, l_nPos, l_nNumChars, STRING (l_nMaxY + 76))
	
END IF

// re-initialize the datawindow
IF dw_case_properties.Create (l_cSyntax, l_cMsg) <> 1 THEN
	MessageBox (gs_AppName, l_cMsg)
	RETURN -1
ELSE
	dw_case_properties.SetTransObject(SQLCA)
	
	in_calendar_column_service_props.of_init(dw_case_properties)

	//	 add any validation rules and error messages that are defined for the columns
	FOR l_nIndex = 1 to THIS.i_nNumConfigFields
		l_sColName = THIS.i_sConfigurableField[l_nIndex].column_name
		l_cMask = dw_case_properties.Describe (l_sColName + ".EditMask.Mask")
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
				l_cMsg = dw_case_properties.Modify(l_cModString)
				IF l_cMsg <> "" THEN
					MessageBox (gs_AppName,"Unable to define the validation message for the current column.")
				END IF
			END IF
			IF THIS.i_sConfigurableField[l_nIndex].error_msg <> "" THEN
				l_cModString = l_cModString + THIS.i_sConfigurableField[l_nIndex].column_name + &
									'.ValidationMsg="'+THIS.i_sConfigurableField[l_nIndex].field_label+': '+THIS.i_sConfigurableField[l_nIndex].error_msg+'" '
				l_cMsg = dw_case_properties.Modify(l_cModString)
				IF l_cMsg <> "" THEN
					MessageBox (gs_AppName,"Unable to define the validation error message for the current column.")
				END IF			
			END IF
		ELSEIF THIS.i_sConfigurableField[l_nIndex].required = 'Y' THEN
			l_cModString = THIS.i_sConfigurableField[l_nIndex].column_name + &
								'.Validation="(Len(Trim(GetText())) > 0)" '+ &
								THIS.i_sConfigurableField[l_nIndex].column_name + &
								'.ValidationMsg="'+THIS.i_sConfigurableField[l_nIndex].field_label+' is a required field for Case Properties." '
			l_cMsg = dw_case_properties.Modify(l_cModString)
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
	long ll_datastore_rows, ll_counter, ll_find_return, ll_errorcheck
	string ls_find_string
	
	lds_caseprop_field_def = Create Datastore
	lds_caseprop_field_def.DataObject = 'd_data_caseprop_field_def'
	lds_caseprop_field_def.SetTransObject(SQLCA)
	ll_datastore_rows = lds_caseprop_field_def.Retrieve(i_cSourceType, i_cCaseType)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through the dynamic column array and retrieve drop downs for all the necessary columns
	//-----------------------------------------------------------------------------------------------------------------------------------
	For	ll_counter = 1 to UpperBound(i_sConfigurableField)
		ls_find_string = 'column_name = "' + i_sConfigurableField[ll_counter].column_name + '" AND  dropdown = "Y"'
		ll_find_return = lds_caseprop_field_def.Find(ls_find_string, 1, ll_datastore_rows)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If a row is found, there is a drop down. If no row is found, Insert a Row.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ll_find_return > 0 Then
			ll_errorcheck = dw_case_properties.GetChild(i_sConfigurableField[ll_counter].column_name, ldwc_caseprop)
			ldwc_caseprop.SetTransObject(SQLCA)
			ll_errorcheck = ldwc_caseprop.Retrieve(i_cCaseType, i_cSourceType, i_sConfigurableField[ll_counter].column_name)
			
			If ll_errorcheck = 0 Then
				ldwc_caseprop.InsertRow(0)
			End If
		End If
	Next
	
	RETURN 0
END IF
end function

public subroutine fu_setviewavailability ();/*****************************************************************************************
	Function:	fu_SetViewAvailability
	Purpose:		Determine which views are active for the current case properties tab.
	Parameters:	NONE
	Returns:		NONE
								
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	04/17/02 M. Caruso     Created.
*****************************************************************************************/

LONG		l_nCount
STRING	l_cCaseType, l_cSourceType

// the Current properties view is always available, so concentrate on the other views.

// Determine if the Inquiry view should be enabled
IF i_wParentWindow.i_cCaseType = i_wParentWindow.i_cInquiry THEN
	// disable if the current case type is Inquiry.
	rb_inquiry.Enabled = FALSE
ELSE
	
	l_cCaseType = i_wParentWindow.i_cInquiry
	l_cSourceType = '%'

	SELECT count(*) INTO :l_nCount
//	SELECT source_type INTO :i_cSourceTypeInquiry
	 FROM cusfocus.case_properties
	WHERE case_number = :i_wParentWindow.i_cCurrentCase
	  AND case_type = :l_cCaseType
	  AND source_type LIKE :l_cSourceType
	USING	SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			// disable just in case, since an error occurred and you really don't know
			rb_inquiry.Enabled = FALSE
			
		CASE 0
			// enable if matching record(s) exist
			IF l_nCount > 0 THEN
				rb_inquiry.Enabled = TRUE
			ELSE
				rb_inquiry.Enabled = FALSE
			END IF
			
		CASE 100
			// disable because no matching records were found
			rb_inquiry.Enabled = FALSE
			
	END CHOOSE
	
END IF

// Determine if the Other view should be enabled
IF i_wParentWindow.i_cSourceType = i_wParentWindow.i_cSourceOther THEN
	// disable if the current case type is Inquiry.
	rb_other.Enabled = FALSE
ELSE
	
	l_cCaseType = '%'
	l_cSourceType = i_wParentWindow.i_cSourceOther
	
//	SELECT count(*), case_type INTO :l_nCount, :i_cCaseTypeOther
	SELECT case_type INTO :i_cCaseTypeOther
	 FROM cusfocus.case_properties
	WHERE case_number = :i_wParentWindow.i_cCurrentCase
	  AND case_type LIKE :l_cCaseType
	  AND source_type = :l_cSourceType
	USING	SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			// disable just in case, since an error occurred and you really don't know
			rb_other.Enabled = FALSE
			
		CASE 0
			// enable if matching record(s) exist
//			IF l_nCount > 0 THEN
				rb_other.Enabled = TRUE
//			ELSE
//				rb_other.Enabled = FALSE
//			END IF
			
		CASE 100
			// disable because no matching records were found
			rb_other.Enabled = FALSE
			
	END CHOOSE
	
END IF
end subroutine

public function integer fu_buildfieldlist ();/*****************************************************************************************
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
THIS.i_dsFields.DataObject = "d_case_prop_field_list"
THIS.i_dsFields.SetTransObject(SQLCA)
i_nNumConfigFields = THIS.i_dsFields.Retrieve(THIS.i_cSourceType, THIS.i_cCaseType)

//Clear out the configurable field structure before adding to
i_sConfigurableField = l_sNullFieldStruct

// process the list of fields.
IF i_nNumConfigFields > 0 THEN
	FOR l_nCount = 1 to i_nNumConfigFields
		// get the column name associated with this field
		i_sConfigurableField[l_nCount].column_name = THIS.i_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_column_name")
		IF IsNull (i_sConfigurableField[l_nCount].column_name) OR &
			(Trim (i_sConfigurableField[l_nCount].column_name) = "") THEN
			i_sConfigurableField[l_nCount].column_name = ""
		END IF
		
		// get the column label associated with this field
		i_sConfigurableField[l_nCount].field_label = THIS.i_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_field_label")
		IF IsNull (i_sConfigurableField[l_nCount].field_label) OR &
			(Trim (i_sConfigurableField[l_nCount].field_label) = "") THEN
			i_sConfigurableField[l_nCount].field_label = ""
		END IF
		
		// get the field width associated with this field
		i_sConfigurableField[l_nCount].field_length = THIS.i_dsFields.GetItemNumber(l_nCount, &
					"case_properties_field_def_field_length")
		IF IsNull (i_sConfigurableField[l_nCount].field_length) THEN
			i_sConfigurableField[l_nCount].field_length = 50
		END IF
		
		// get the "locked" parameter associated with this field
		i_sConfigurableField[l_nCount].locked = THIS.i_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_locked")
		IF IsNull (i_sConfigurableField[l_nCount].locked) OR &
			(Trim (i_sConfigurableField[l_nCount].locked) = "") THEN
			i_sConfigurableField[l_nCount].locked = "N"
		END IF
		
		// get the "visible" parameter associated with this field
		i_sConfigurableField[l_nCount].visible = THIS.i_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_visible")
		IF IsNull (i_sConfigurableField[l_nCount].visible) OR &
			(Trim (i_sConfigurableField[l_nCount].visible) = "") THEN
			i_sConfigurableField[l_nCount].visible = "N"
		END IF
		
		// get the "required" parameter associated with this field
		i_sConfigurableField[l_nCount].required = THIS.i_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_required")
		IF IsNull (i_sConfigurableField[l_nCount].required) OR &
			(Trim (i_sConfigurableField[l_nCount].required) = "") THEN
			i_sConfigurableField[l_nCount].required = "N"
		END IF
		
		// get the edit mask associated with this field
		i_sConfigurableField[l_nCount].edit_mask = THIS.i_dsFields.GetItemString(l_nCount, &
					"display_formats_edit_mask")
		IF IsNull (i_sConfigurableField[l_nCount].edit_mask) OR &
			(Trim (i_sConfigurableField[l_nCount].edit_mask) = "") THEN
			i_sConfigurableField[l_nCount].edit_mask = ""
		END IF
		
		// get the display format associated with this field
		i_sConfigurableField[l_nCount].display_format = THIS.i_dsFields.GetItemString(l_nCount, &
					"display_formats_display_format")
		IF IsNull (i_sConfigurableField[l_nCount].display_format) OR &
			(Trim (i_sConfigurableField[l_nCount].display_format) = "") THEN
			i_sConfigurableField[l_nCount].display_format = '[general]'
		END IF
		
		// get the display name associated with this field
		i_sConfigurableField[l_nCount].format_name = THIS.i_dsFields.GetItemString(l_nCount, &
					"display_formats_format_name")
		IF IsNull (i_sConfigurableField[l_nCount].format_name) OR &
			(Trim (i_sConfigurableField[l_nCount].format_name) = "") THEN
			i_sConfigurableField[l_nCount].format_name = '[general]'
		END IF
		
		// get the validation rule associated with this field
		i_sConfigurableField[l_nCount].validation_rule = THIS.i_dsFields.GetItemString(l_nCount, &
					"display_formats_validation_rule")
		IF IsNull (i_sConfigurableField[l_nCount].validation_rule) OR &
			(Trim (i_sConfigurableField[l_nCount].validation_rule) = "") THEN
			i_sConfigurableField[l_nCount].validation_rule = ''
		END IF
		
		// get the error message associated with this field
		i_sConfigurableField[l_nCount].error_msg = THIS.i_dsFields.GetItemString(l_nCount, &
					"display_formats_error_msg")
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

on u_tabpage_case_properties.create
int iCurrent
call super::create
this.rb_other=create rb_other
this.rb_inquiry=create rb_inquiry
this.rb_current=create rb_current
this.dw_case_properties=create dw_case_properties
this.ln_1=create ln_1
this.ln_highlight=create ln_highlight
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_other
this.Control[iCurrent+2]=this.rb_inquiry
this.Control[iCurrent+3]=this.rb_current
this.Control[iCurrent+4]=this.dw_case_properties
this.Control[iCurrent+5]=this.ln_1
this.Control[iCurrent+6]=this.ln_highlight
end on

on u_tabpage_case_properties.destroy
call super::destroy
destroy(this.rb_other)
destroy(this.rb_inquiry)
destroy(this.rb_current)
destroy(this.dw_case_properties)
destroy(this.ln_1)
destroy(this.ln_highlight)
end on

event constructor;call super::constructor;//**********************************************************************************************
//
//  Event:   constructor
//  Purpose: Please see PB documentation for this event.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  12/11/2000 K. Claver Set instance variables and set up resize service.
//  01/11/01 M. Caruso   Set default option lists for the two uses of the tabpage.
//  4/13/2001 K. Claver  Changed to correctly use the new resize service.
//**********************************************************************************************
i_wParentWindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder

THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	// resize the case properties datawindow
	THIS.inv_resize.of_Register( dw_case_properties, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF

i_cCasePropsOptions =	dw_case_properties.c_NewOK+ &
								dw_case_properties.c_ModifyOK+ &
								dw_case_properties.c_ModifyOnOpen+ &
								dw_case_properties.c_CopyOK+ &
								dw_case_properties.c_NewModeOnEmpty+ &
								dw_case_properties.c_OnlyOneNewRow+ &
								dw_case_properties.c_NoEnablePopup+ &
								dw_case_properties.c_NoRetrieveOnOpen+ &
								dw_case_properties.c_NoMenuButtonActivation+ &
								dw_case_properties.c_HideHighlight
							 
i_cInqCasePropsOptions =	dw_case_properties.c_NoShowEmpty+ &
									dw_case_properties.c_NoEnablePopup+ &
									dw_case_properties.c_NoRetrieveOnOpen+ &
									dw_case_properties.c_NoMenuButtonActivation+ &
									dw_case_properties.c_HideHighlight
									
// set the default radio button
i_cCurrentView = c_CurrentRB
end event

event destructor;call super::destructor;//**********************************************************************************************
//
//  Event:   destructor
//  Purpose: Please see PB documentation for this event.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  12/11/2000 K. Claver Destroy the instance datastore if valid.
//**********************************************************************************************
IF IsValid( THIS.i_dsFields ) THEN
	// remove the datastore from memory
	DESTROY THIS.i_dsFields
END IF

end event

type rb_other from radiobutton within u_tabpage_case_properties
integer x = 1920
integer y = 16
integer width = 901
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Properties from Other Source"
boolean automatic = false
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Perform this functionality when the user clicks this radio button.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/16/02 M. Caruso    Created.
	07/03/03 M. Caruso    RETURN 1 if the save case fails. Also, moved the SetRedraw (FALSE)
								 statement to after the save attempt and update all 3 radio buttons
								 manually because the Automatic property has been turned off.
*****************************************************************************************/

IF i_cCurrentView = c_OtherRB THEN
	// this is already selected, so ignore the click
	RETURN 1
ELSE
	
	// save the case if the current case properties have been modified.
	IF i_cCurrentView = c_CurrentRB THEN
		IF i_wParentWindow.i_uoCaseDetails.fu_SaveCase (i_wParentWindow.i_uoCaseDetails.c_PromptChanges) = i_wParentWindow.i_uoCaseDetails.c_Fatal THEN
			RETURN 1
		END IF
	END IF
	
	SetRedraw (FALSE)
	
	i_cCurrentView = c_OtherRB
	
	// update the status of the radio buttons
	rb_current.Checked = FALSE
	rb_inquiry.Checked = FALSE
	rb_other.Checked = TRUE
	
	// set the current source type and case type values.
	i_cSourceType = i_wParentWindow.i_cSourceOther
	i_cCaseType = i_cCaseTypeOther
	
	// reset the datawindow control.
	i_cCasePropsOptions = dw_case_properties.c_NoShowEmpty + &
								 dw_case_properties.c_NoEnablePopup + &
								 dw_case_properties.c_NoRetrieveOnOpen + &
								 dw_case_properties.c_NoMenuButtonActivation + &
								 dw_case_properties.c_HideHighlight
	dw_case_properties.DataObject = "d_case_properties"
	PARENT.fu_BuildFieldList ()
	PARENT.fu_DisplayFields ()
	dw_case_properties.fu_InitOptions ()
	dw_case_properties.fu_SetOptions (SQLCA, dw_case_properties.c_NullDW, i_cCasePropsOptions)
	
	// retrieve the new data.
	dw_case_properties.fu_retrieve (dw_case_properties.c_IgnoreChanges, dw_case_properties.c_NoReselectRows)
	
	SetRedraw (TRUE)

	// Change it back
	i_cCaseType = i_wParentWindow.i_cCaseType
	
END IF
end event

type rb_inquiry from radiobutton within u_tabpage_case_properties
integer x = 974
integer y = 16
integer width = 901
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Properties from Inquiry Case"
boolean automatic = false
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Perform this functionality when the user clicks this radio button.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/16/02 M. Caruso    Created.
	07/03/03 M. Caruso    RETURN 1 if the save case fails. Also, moved the SetRedraw (FALSE)
								 statement to after the save attempt and update all 3 radio buttons
								 manually because the Automatic property has been turned off.
	09/01/2004 K. Claver  Changed to use the source type instance variable on the main window
								 rather than the local instance variable i_cSourceTypeInquiry as
								 that variable is not set unless fu_SetViewAvailability is called.
*****************************************************************************************/

IF i_cCurrentView = c_InquiryRB THEN
	// this is already selected, so ignore the click
	RETURN 1
ELSE
	
	// save the case if the current case properties have been modified.
	IF i_cCurrentView = c_CurrentRB THEN
		IF i_wParentWindow.i_uoCaseDetails.fu_SaveCase (i_wParentWindow.i_uoCaseDetails.c_PromptChanges) = i_wParentWindow.i_uoCaseDetails.c_Fatal THEN
			RETURN 1
		END IF
	END IF
	
	SetRedraw (FALSE)
	
	i_cCurrentView = c_InquiryRB
	
	// update the status of the radio buttons
	rb_current.Checked = FALSE
	rb_inquiry.Checked = TRUE
	rb_other.Checked = FALSE
	
	// set the current source type and case type values.
	//PARENT.i_cSourceType = i_cSourceTypeInquiry
	PARENT.i_cSourceType = PARENT.i_wParentWindow.i_cSourceType
	PARENT.i_cCaseType = PARENT.i_wParentWindow.i_cInquiry
	
	// reset the datawindow control.
	i_cCasePropsOptions = dw_case_properties.c_NoShowEmpty + &
								 dw_case_properties.c_NoEnablePopup + &
								 dw_case_properties.c_NoRetrieveOnOpen + &
								 dw_case_properties.c_NoMenuButtonActivation + &
								 dw_case_properties.c_HideHighlight
	dw_case_properties.DataObject = "d_case_properties"
	PARENT.fu_BuildFieldList ()
	PARENT.fu_DisplayFields ()
	dw_case_properties.fu_InitOptions ()
	dw_case_properties.fu_SetOptions (SQLCA, dw_case_properties.c_NullDW, i_cCasePropsOptions)
	
	// retrieve the new data.
	dw_case_properties.fu_retrieve (dw_case_properties.c_IgnoreChanges, dw_case_properties.c_NoReselectRows)
	
	SetRedraw (TRUE)

END IF
end event

type rb_current from radiobutton within u_tabpage_case_properties
integer x = 27
integer y = 16
integer width = 901
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Current Case Properties"
boolean checked = true
boolean automatic = false
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Perform this functionality when the user clicks this radio button.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/16/02 M. Caruso    Created.
	07/03/03 M. Caruso    Manually update the status of all 3 radio buttons since the
								 Automatic property has been turned off for them.
*****************************************************************************************/

IF i_cCurrentView = c_CurrentRB THEN
	// this is already selected, so ignore the click
	RETURN 1
ELSE
	
	SetRedraw (FALSE)
	
	i_cCurrentView = c_CurrentRB
	
	// update the status of the radio buttons
	rb_current.Checked = TRUE
	rb_inquiry.Checked = FALSE
	rb_other.Checked = FALSE
	
	// set the current source type and case type values.
	i_cSourceType = i_wParentWindow.i_cSourceType
	i_cCaseType = i_wParentWindow.i_cCaseType
	
	// reset the datawindow control.
	i_cCasePropsOptions = dw_case_properties.c_NewOK+ &
								 dw_case_properties.c_ModifyOK+ &
								 dw_case_properties.c_ModifyOnOpen+ &
								 dw_case_properties.c_CopyOK+ &
								 dw_case_properties.c_NewModeOnEmpty+ &
								 dw_case_properties.c_OnlyOneNewRow+ &
								 dw_case_properties.c_NoEnablePopup+ &
								 dw_case_properties.c_NoRetrieveOnOpen+ &
								 dw_case_properties.c_NoMenuButtonActivation+ &
								 dw_case_properties.c_HideHighlight
	dw_case_properties.DataObject = "d_case_properties"
	PARENT.fu_BuildFieldList ()
	PARENT.fu_DisplayFields ()
	dw_case_properties.fu_InitOptions ()
	dw_case_properties.fu_SetOptions (SQLCA, dw_case_properties.c_NullDW, i_cCasePropsOptions)
	
	// retrieve the new data.
	dw_case_properties.fu_retrieve (dw_case_properties.c_IgnoreChanges, dw_case_properties.c_NoReselectRows)

	SetRedraw (TRUE)
	
END IF
end event

type dw_case_properties from u_dw_std within u_tabpage_case_properties
event ue_disable ( )
event ue_enable ( )
integer x = 9
integer y = 116
integer width = 3511
integer height = 664
integer taborder = 10
string dataobject = "d_case_properties"
boolean vscrollbar = true
boolean border = false
end type

event ue_disable();//*********************************************************************************************
//  Event:   	 ue_disable
//  Purpose:    Disable the appropriate fields in the datawindow
//
//  Parameters: None
//  Returns:    None
//                
//  Date     Developer     Description
//  -------- ----------- ----------------------------------------------------------------------
//  12/12/2000 K. Claver Original Version.
//  04/18/02 M. Caruso   Increased field index range by 1 since the source type field was added.
//*********************************************************************************************
Integer l_nIndex, l_nStructIndex

IF IsValid( PARENT.i_dsFields ) AND Error.i_FWError <> c_Fatal THEN
	IF i_dsFields.RowCount( ) > 0 THEN
		//Disable all fields.  Skip first 5 fields because the are already
		//  locked down.
		FOR l_nIndex = 7 TO ( UpperBound( i_sConfigurableField ) + 6 )
			l_nStructIndex = ( l_nIndex - 6 )
			
//			IF IsNull(PARENT.i_sConfigurableField[l_nStructIndex].edit_mask) OR &
//	   		Trim(PARENT.i_sConfigurableField[l_nStructIndex].edit_mask) = "" THEN
//				//lock the edit field for editing.			
//				THIS.Modify( "#"+String( l_nIndex )+".Edit.DisplayOnly='yes' "+ &
//								 "#"+String( l_nIndex )+".Background.Color='80269524'" )
//			ELSE
				//lock the editmask field to prevent editing
				THIS.Modify( "#"+String( l_nIndex )+".Protect='1' "+ &
								 "#"+String( l_nIndex )+".Background.Color='80269524'" )
//			END IF
		NEXT
	END IF
END IF
end event

event ue_enable();//*********************************************************************************************
//  Event:   	 ue_enable
//  Purpose:    Enable the appropriate fields in the datawindow
//
//  Parameters: None
//  Returns:    None
//                
//  Date     Developer     Description
//  -------- ----------- ----------------------------------------------------------------------
//  12/12/00 K. Claver   Original Version.
//  04/18/02 M. Caruso   Increased field index range by 1 since the source type field was added.
//  05/20/02 M. Caruso   Unprotect edit fields as well when enabling them.
//*********************************************************************************************
Integer l_nIndex, l_nStructIndex

IF IsValid( PARENT.i_dsFields ) THEN
	IF i_dsFields.RowCount( ) > 0 THEN
		//Enable fields.  Check the structure to see if should enable the field.
		//  Skip #5 because the first five fields are already locked down.  
		FOR l_nIndex = 7 TO ( UpperBound( PARENT.i_sConfigurableField ) + 6 )
			//Subtract five from the index as the first element of the structure array will
			//  be the sixth field in the datawindow.
			l_nStructIndex = ( l_nIndex - 6 )
			
			IF IsNull (PARENT.i_sConfigurableField[l_nStructIndex].locked) OR &
				(Trim (PARENT.i_sConfigurableField[l_nStructIndex].locked) = "") OR &
				( Upper( PARENT.i_sConfigurableField[l_nStructIndex].locked ) = "N" ) THEN
//				//Build the modify based on whether is an edit or editmask field
//				IF IsNull(PARENT.i_sConfigurableField[l_nStructIndex].edit_mask) OR &
//	   			Trim(PARENT.i_sConfigurableField[l_nStructIndex].edit_mask) = "" THEN
//					//unlock the edit field for editing.
//					THIS.Modify( "#"+String( l_nIndex )+".Edit.DisplayOnly='no' "+ &
//									 "#"+String( l_nIndex )+".Protect='0' "+ &
//									 "#"+String( l_nIndex )+".Background.Color='"+String( RGB( 255, 255, 255 ) )+"'" )
//				ELSE
					//unlock the editmask field for editing.
					THIS.Modify( "#"+String( l_nIndex )+".Protect='0' "+ &
									 "#"+String( l_nIndex )+".Background.Color='"+String( RGB( 255, 255, 255 ) )+"'" )
//				END IF
			END IF
		NEXT
	END IF
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;//**********************************************************************************************
//  Event:   pcd_Retrieve
//  Purpose: Retrieve the datawindow records.  
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  12/11/2000 K. Claver Set the current case number in the window if the retrieve returns no rows.
//  01/10/01 M. Caruso   Only process remaining code if retrieve returns 1 or more rows.  Also
//								 removed code for initializing the Case Properties tabs.
//  3/12/2002 K. Claver  Added code to check if the case is locked before allowing the datawindow
//								 fields to be enabled.
//  04/17/02 M. Caruso   Removed code to change Visible status of the tab and added an error
//								 message if the Retrieve fails.
//  5/30/2002 K. Claver  Added call to fu_resetupdate in case items ever need to be set immediately
//								 after the retrieve.
//**********************************************************************************************
Integer	l_nRV, l_nCount, l_nIndex
u_dw_std	l_dwCasePropInq
string ls_syntax

//THIS.DataObject = 'd_case_properties'
//PARENT.fu_BuildFieldList( )
//PARENT.fu_DisplayFields( )
//THIS.fu_InitOptions ()
//THIS.fu_SetOptions (SQLCA, c_NullDW, PARENT.i_cCasePropsOptions)
l_nRV = Retrieve( PARENT.i_wParentWindow.i_cCurrentCase, i_cCaseType, i_cSourceType )

ls_syntax = dw_case_properties.object.datawindow.syntax
IF l_nRV > 0 THEN
	THIS.i_isempty = FALSE
	THIS.object.datawindow.readonly="no"
	ls_syntax = dw_case_properties.object.case_generic_1[l_nRV]
END IF


CHOOSE CASE l_nRV
	CASE -1
		// an error occurred
		MessageBox (gs_appname, 'Unable to retrieve case properties.')
		
	CASE 0
		// no matching records were found

	CASE IS > 0
	
		IF i_cCurrentView = c_CurrentRB THEN
			
			//Decide to enable/disable based on case status.
			IF PARENT.i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = PARENT.i_wParentWindow.i_cStatusClosed THEN
				
				IF PARENT.i_wParentWindow.i_bSupervisorRole AND NOT PARENT.i_wParentWindow.i_bCaseLocked THEN
					THIS.Event Trigger ue_enable( )
				ELSE
					THIS.Event Trigger ue_disable( )
				END IF
				
			ELSEIF PARENT.i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = PARENT.i_wParentWindow.i_cStatusVoid THEN
				THIS.Event Trigger ue_disable( )
			ELSE
				IF NOT PARENT.i_wParentWindow.i_bCaseLocked THEN
					THIS.Event Trigger ue_enable( )
				ELSE
					THIS.Event Trigger ue_disable( )
				END IF
			END IF
			
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			// JWhite Added 7.15.2004 - Trying to fix non-retrieving dddws on case props on the Case
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			datawindowchild ldwc_caseprop
//			datastore lds_caseprop_field_def
//			long ll_datastore_rows, ll_counter, ll_find_return, ll_errorcheck
//			string ls_find_string
//			
//			lds_caseprop_field_def = Create Datastore
//			lds_caseprop_field_def.DataObject = 'd_data_caseprop_field_def'
//			lds_caseprop_field_def.SetTransObject(SQLCA)
//			ll_datastore_rows = lds_caseprop_field_def.Retrieve(i_cSourceType, i_cCaseType)
//			
//			ls_syntax = dw_case_properties.object.datawindow.syntax
//				
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			// Loop through the dynamic column array and retrieve drop downs for all the necessary columns
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			For	ll_counter = 1 to UpperBound(i_sConfigurableField)
//				ls_find_string = 'column_name = "' + i_sConfigurableField[ll_counter].column_name + '" AND  dropdown = "Y"'
//				ll_find_return = lds_caseprop_field_def.Find(ls_find_string, 1, ll_datastore_rows)
//				
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				// If a row is found, there is a drop down. If no row is found, Insert a Row.
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				If ll_find_return > 0 Then
//					ll_errorcheck = dw_case_properties.GetChild(i_sConfigurableField[ll_counter].column_name, ldwc_caseprop)
//					ldwc_caseprop.SetTransObject(SQLCA)
//					ll_errorcheck = ldwc_caseprop.Retrieve(i_cCaseType, i_cSourceType, i_sConfigurableField[ll_counter].column_name)
//					
//					If ll_errorcheck = 0 Then
//						ldwc_caseprop.InsertRow(0)
//					End If
//				End If
//			Next
//
		ELSE
			// disable if not showing the current case properties.
			THIS.Event Trigger ue_disable( )
		END IF
	
END CHOOSE

THIS.fu_ResetUpdate( )

end event

event pcd_savebefore;call super::pcd_savebefore;//**********************************************************************************************
//
//  Event:   pcd_savebefore
//  Purpose: Please see PowerClass documentation for this event.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  12/28/2000 K. Claver Added code to set the updated by and updated timestamp before the save
//  12/29/2000 K. Claver Changed to only check if the case has been saved.  If not, save before
//								 save the datawindow so have a case number.
//  01/10/01 M. Caruso   Modified to set the case number field is needed and possible.
//**********************************************************************************************
String l_cCaseNumber

//Check if there is a case number.  If not, need to save the case first.
IF THIS.RowCount( ) > 0 THEN
	
	l_cCaseNumber = GetItemString (1, 'case_number')
	IF IsNull( l_cCaseNumber ) OR Trim( l_cCaseNumber ) = "" THEN
		
		// set the case_number field
		IF Trim (i_wParentWindow.i_cCurrentCase) = '' THEN
			Error.i_FWError = c_Fatal
		ELSE
			SetItem ( 1, "case_number", i_wParentWindow.i_cCurrentCase )
			Error.i_FWError = c_Success
		END IF
		
	ELSE
		Error.i_FWError = c_Success
	END IF
		
	//If no errors, set the updated by and updated timestamp
	IF Error.i_FWError = c_Success THEN
		THIS.SetItem( 1, "updated_by", OBJCA.WIN.fu_GetLogin( SQLCA ) )
		THIS.SetItem( 1, "updated_timestamp", i_wParentWindow.fw_GetTimeStamp( ) )
	END IF
	
END IF
end event

event pcd_new;call super::pcd_new;/*****************************************************************************************
   Event:      pcd_new
   Purpose:    set initial values for records in this datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/10/01 M. Caruso    Created.
	03/14/02 M. Caruso    Added call to setitemstatus ()
*****************************************************************************************/


SetItem (i_CursorRow, 'case_type', i_wParentWindow.i_cCaseType)
SetItem (i_CursorRow, 'source_type', i_wParentWindow.i_cSourceType)
SetItemStatus (i_CursorRow, 0, Primary!, NotModified!)
PARENT.Visible = TRUE
end event

event clicked;call super::clicked;n_menu_dynamic ln_menu_dynamic

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('clicked', xpos, ypos, row, dwo, ln_menu_dynamic)
End If

end event

event constructor;call super::constructor;in_calendar_column_service_props = Create n_calendar_column_service_props
	
If NOT IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager = Create n_datawindow_graphic_service_manager
	in_datawindow_graphic_service_manager.of_init(dw_case_properties)
	in_datawindow_graphic_service_manager.of_add_service("n_calendar_column_service")
	in_datawindow_graphic_service_manager.of_create_services()
End If

end event

event destructor;call super::destructor;destroy in_calendar_column_service_props
end event

event itemerror;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : ItemError
//  Description   : This event is used to disable the display
//                  of the generic PowerBuilder validation error
//                  message.
//
//  Return Value  : INTEGER -
//                     0 - reject value and show error.
//                     1 - reject value and stay.
//                     2 - accept value and move.
//                     3 - reject value and move.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = 2
DWITEMSTATUS l_RowStatus

//------------------------------------------------------------------
//  If the edit service is available, determine whether to display
//  a validate error message.
//------------------------------------------------------------------
IF NOT IsNull(data) THEN
	IF LEN(TRIM(data)) = 0 THEN data = ''
END IF
IF NOT i_IgnoreVal THEN
	IF IsValid(i_DWSRV_EDIT) THEN
		l_Return = i_DWSRV_EDIT.fu_ItemError(row, data)
	END IF
END IF

//------------------------------------------------------------------
//  If the developer extends this event then they should check
//  AncestorReturnValue first to see if they should process their
//  code.  Unless the developer changes the RETURN value in their
//  code, PowerBuilder will use the AncestorReturnValue.
//------------------------------------------------------------------

RETURN l_Return

end event

type ln_1 from line within u_tabpage_case_properties
long linecolor = 8421504
integer linethickness = 1
integer beginx = 23
integer beginy = 96
integer endx = 3493
integer endy = 96
end type

type ln_highlight from line within u_tabpage_case_properties
long linecolor = 16777215
integer linethickness = 1
integer beginx = 23
integer beginy = 100
integer endx = 3493
integer endy = 100
end type

