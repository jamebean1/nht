$PBExportHeader$u_contact_history.sru
$PBExportComments$Case history and detail tab container.
forward
global type u_contact_history from u_container_std
end type
type dw_criteria from datawindow within u_contact_history
end type
type uo_search_contact_history from u_search_contacthistory within u_contact_history
end type
type st_case_preview from statictext within u_contact_history
end type
type st_case_list from statictext within u_contact_history
end type
type st_noaccess from statictext within u_contact_history
end type
type st_nonotes from statictext within u_contact_history
end type
end forward

global type u_contact_history from u_container_std
integer width = 3579
integer height = 1600
borderstyle borderstyle = stylelowered!
dw_criteria dw_criteria
uo_search_contact_history uo_search_contact_history
st_case_preview st_case_preview
st_case_list st_case_list
st_noaccess st_noaccess
st_nonotes st_nonotes
end type
global u_contact_history u_contact_history

type variables
BOOLEAN						i_bViewNotes

STRING						i_cKeyValue

w_create_maintain_case	i_wParentWindow

string						is_original_syntax
string						is_results_syntax
string						is_original_criteria_syntax
string						is_new_criteria_syntax

w_category_popup			iw_category_popup

string	 					is_categoryID
boolean						ib_show_criteria
n_date_manipulator 		in_date_manipulator

boolean						ib_first_open
n_blob_manipulator		in_blob_manipulator
//datastore					ids_syntax

string						is_dynamic_columns[]
boolean						ib_dynamic_columns
string						is_ch_casetype
//string						is_retrieved_sourcetype
end variables

forward prototypes
public function boolean fu_checklocked (string a_ccasenumber)
public function string of_retrieve ()
public function string of_pop_calendar (integer a_xpos, integer a_ypos, string as_date)
public function string of_add_results_columns (ref datawindow adw_datawindow)
public function integer of_save_syntax (string as_dataobject, string as_casetype, string as_sourcetype, string as_dynamiccolumn_list, blob ab_syntaxblob)
public function string of_get_syntax (string as_dataobject, string as_casetype, string as_sourcetype)
public subroutine of_post_retrieve_process (integer al_return)
public function string of_delete_syntax (string as_dataobject, string as_casetype, string as_sourcetype)
public function string of_add_case_properties ()
public function string of_hide_columns ()
public subroutine of_build_case_properties ()
public function string of_init ()
public function string of_reset_criteria ()
public function string of_show_hide_criteria ()
public function integer of_retrieve_caseprop_dddws (string as_sourcetype, string as_casetype)
end prototypes

public function boolean fu_checklocked (string a_ccasenumber);/*****************************************************************************************
   Function:   fu_CheckLocked
   Purpose:    Check if the passed case is locked
   Parameters: STRING - a_cCaseNumber - Number of the case to check
   Returns:    BOOLEAN - TRUE - Case locked by someone else
								 FALSE - Case not locked by someone else

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/12/02 K. Claver    Created.
	02/28/02 M. Caruso    Added code to set i_bCaseLocked in i_uoDocMgr if it is valid.
	09/02/2004 K. Claver  Modified locked case message to inform the user that they can
								 add certain things to the case, but they cannot edit.
*****************************************************************************************/
Boolean l_bRV = FALSE
DateTime l_dtLockedDate

IF NOT IsNull( a_cCaseNumber ) AND Trim( a_cCaseNumber ) <> "" THEN	
	
	SELECT locked_by, locked_timestamp
	INTO :THIS.i_wParentWindow.i_cLockedBy, :l_dtLockedDate
	FROM cusfocus.case_locks
	WHERE case_number = :a_cCaseNumber
	USING SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			MessageBox( gs_AppName, "Error determining lock status for the case."+ &
						   " You will not be able to edit this case", StopSign!, OK! )
			THIS.i_wParentWindow.i_cLockedBy	= "Undetermined"		
			THIS.i_wParentWindow.i_bCaseLocked = TRUE				
			l_bRV = TRUE		
		CASE 0
			IF Upper( Trim( THIS.i_wParentWindow.i_cLockedBy ) ) <> Upper( Trim( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) THEN
				MessageBox( gs_AppName, "This case is currently in use by "+THIS.i_wParentWindow.i_cLockedBy+" since "+&
									String( l_dtLockedDate, "mm/dd/yyyy hh:mm:ss" )+".~r~n"+ &
									"You will only be able to add notes, attachments, correspondence, forms, ~r~n"+ &
									"contacts and reminders to this case.  No other edits are allowed", Information!, OK! )
				
				THIS.i_wParentWindow.i_bCaseLocked = TRUE
				l_bRV = TRUE
			ELSE
				THIS.i_wParentWindow.i_bCaseLocked = FALSE
				l_bRV = FALSE
			END IF
		CASE ELSE
			//SQLCA.SQLCode = 100 = No lock record found
			THIS.i_wParentWindow.i_bCaseLocked = FALSE
	END CHOOSE
	
	IF IsValid (i_wParentWindow.i_uoCaseCorrespondence) THEN
		IF IsValid (i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr) THEN
			i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr.i_bCaseLocked = i_wParentWindow.i_bCaseLocked
		END IF
	END IF
	
END IF

RETURN l_bRV
end function

public function string of_retrieve ();////----------------------------------------------------------------------------------------------------------------------------------
////	Arguments:  None
////	Overview:   This function gets the values from the criteria object, sets them to null if no value was entered
////					and retrieves the datawindow.
////	Created by:	Joel White
////	History: 	4/22/2005 - First Created 
////-----------------------------------------------------------------------------------------------------------------------------------
//
//
String	ls_casetype, ls_casenumber, ls_fromdate, ls_todate, ls_casestatus, l_cCaseMasterNum
string 	ls_category_id, ls_caserep, ls_source, ls_subject	
string	ls_dynamic1, ls_dynamic2, ls_dynamic3, ls_dynamic4, ls_dynamic5, ls_dynamic6
long		ll_return, i, ll_upperbound
//

//??? case prop stuff

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the values from the criteria object
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_criteria.RowCount() > 0 Then
	ls_casetype				=		dw_criteria.GetItemString(1, 'casetype')
	ls_casenumber 			= 		dw_criteria.GetItemString(1, 'casenumber') 
	ls_fromdate				=		dw_criteria.GetItemString(1, 'fromdate') 
	ls_todate				=		dw_criteria.GetItemString(1, 'todate')
	ls_casestatus			=		dw_criteria.GetItemString(1, 'casestatus')
	ls_caserep				=		dw_criteria.GetItemString(1, 'caserep')
	ls_category_id			=		is_categoryID
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If the values are '' then set them to null so the stored proc. can deal with them.
//-----------------------------------------------------------------------------------------------------------------------------------
If	ls_casetype 			= 	''	Then		SetNull(ls_casetype)			
If	ls_casenumber 			= 	'' Then		SetNull(ls_casenumber)		
If	ls_fromdate 			= 	'' Then		SetNull(ls_fromdate)			
If	ls_todate 				= 	'' Then		SetNull(ls_todate)				
If	ls_casestatus 			= 	''	Then		SetNull(ls_casestatus)
If	ls_caserep			 	= 	'' Then		SetNull(ls_caserep)	
If	ls_category_id 		= 	'' Then		SetNull(ls_category_id)


ll_upperbound = UpperBound(is_dynamic_columns[])
long ll_testrowcount
string	ls_criteria_syntax, ls_getitemstring
//-----------------------------------------------------------------------------------------------------------------------------------
// Build the dynamic arguments to pass on to the stored proc.
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(is_dynamic_columns[]) > 0 Then
	For i = 1 to UpperBound(is_dynamic_columns[])
		If i = 1 Then
			ls_getitemstring = dw_criteria.GetItemString(1, is_dynamic_columns[i])

			If Not isNull(ls_getitemstring) Then
				ls_dynamic1	=	is_dynamic_columns[i] + ' = "' +  ls_getitemstring + '"'
			Else
				ls_dynamic1 = is_dynamic_columns[i]
			End If
		ElseIf i = 2 Then
			ls_getitemstring = dw_criteria.GetItemString(1, is_dynamic_columns[i])
			
			If Not isNull(ls_getitemstring) Then
				ls_dynamic2	=	is_dynamic_columns[i] + ' = "' +  ls_getitemstring + '"'
			Else
				ls_dynamic2 = is_dynamic_columns[i]
			End If
		ElseIf i = 3 Then
			ls_getitemstring = dw_criteria.GetItemString(1, is_dynamic_columns[i])
			
			If Not isNull(ls_getitemstring) Then
				ls_dynamic3	=	is_dynamic_columns[i] + ' = "' +  ls_getitemstring + '"'
			Else
				ls_dynamic3 = is_dynamic_columns[i]
			End If
		ElseIf i = 4 Then
			ls_getitemstring = dw_criteria.GetItemString(1, is_dynamic_columns[i])
			
			If Not isNull(ls_getitemstring) Then
				ls_dynamic4	=	is_dynamic_columns[i] + ' = "' +  ls_getitemstring + '"'
			Else
				ls_dynamic4 = is_dynamic_columns[i]
			End If			
		ElseIf i = 5 Then
			ls_getitemstring = dw_criteria.GetItemString(1, is_dynamic_columns[i])
			
			If Not isNull(ls_getitemstring) Then
				ls_dynamic5	=	is_dynamic_columns[i] + ' = "' +  ls_getitemstring + '"'
			Else
				ls_dynamic5 = is_dynamic_columns[i]
			End If			
		ElseIf i = 6 Then
			ls_getitemstring = dw_criteria.GetItemString(1, is_dynamic_columns[i])
			
			If Not isNull(ls_getitemstring) Then
				ls_dynamic6	=	is_dynamic_columns[i] + ' = "' +  ls_getitemstring + '"'
			Else
				ls_dynamic6 = is_dynamic_columns[i]
			End If
		End If
	Next
End If

//----------------------------------------------------------------------------------------------------------------------------------
//	Need to prep the dynamic columns for the dynamic stored proc
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ls_dynamic1) Then ls_dynamic1 = ''
If IsNull(ls_dynamic2) Then ls_dynamic2 = ''
If IsNull(ls_dynamic3) Then ls_dynamic3 = ''
If IsNull(ls_dynamic4) Then ls_dynamic4 = ''
If IsNull(ls_dynamic5) Then ls_dynamic5 = ''
If IsNull(ls_dynamic6) Then ls_dynamic6 = ''

uo_search_contact_history.dw_report_detail.Reset()
uo_search_contact_history.of_set_conf_level(i_wParentWindow.i_nRepConfidLevel)
ls_source = i_wParentWindow.i_cSourceType
ls_subject =i_wParentWindow.i_cCurrentCaseSubject
ls_casetype = i_wParentWindow.is_contacthistory_casetype

//??? RAP .Net blows up here - added next line
IF IsNull(ls_caseType) THEN ls_caseType = ''

ll_return = uo_search_contact_history.dw_report.Retrieve(ls_Source, ls_Subject, ls_category_id, ls_fromdate, ls_todate, ls_casenumber, ls_caserep, ls_casestatus, ls_dynamic1, ls_dynamic2, ls_dynamic3, ls_dynamic4, ls_dynamic5, ls_dynamic6, ls_casetype, 'N' )

//-----------------------------------------------------------------------------------------------------------------------------------
// Check the return, if the retrieve failed then grab the error.
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_return < 0 Then
	Return SQLCA.SQLErrText
Else
	uo_search_contact_history.of_post_retrieve_process(ll_return)
End If

Return ''


end function

public function string of_pop_calendar (integer a_xpos, integer a_ypos, string as_date);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  a_xpos 	- Gives the x cordinate from the clicked event
//					a_ypos	- Gives the y cordinate from the clicked event
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	4/13/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_date_manipulator ln_date_manipulator

String l_cParm, l_cX, l_cY, l_cValue, l_cInitialDate

ln_date_manipulator = Create n_date_manipulator

l_cX = string(a_xpos)
l_cY = string(a_ypos)

l_cInitialDate = as_date

IF l_cInitialDate = "" OR IsNull( l_cInitialDate ) OR Year( Date( l_cInitialDate ) ) < 1753 OR &
   l_cInitialDate = "00/00/0000" THEN
	l_cInitialDate = String( ln_date_manipulator.of_today() )
END IF	

l_cParm = ( l_cInitialDate+"&"+l_cX+"&"+l_cY )

FWCA.MGR.fu_OpenWindow( w_calendar, l_cParm )

// Get the date passed back
l_cValue = Message.StringParm

// If it's a date, update the field.
IF IsDate( l_cValue ) THEN
	as_date = l_cValue
ELSE
	as_date = ""
END IF

Destroy ln_date_manipulator

Return as_date

end function

public function string of_add_results_columns (ref datawindow adw_datawindow);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  adw_datawindow - This is a reference to the results datawindow.
//	Overview:   This function takes a datawindow by reference, adds the text headers and columns to the datawindow
//					and recreates the datawindow with the same dynamic columns that were added to the criteria object.
//	Created by:	Joel White
//	History: 	4/13/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


CONSTANT	INTEGER	col1labelX = 04		//These move the added labels left/right
CONSTANT	INTEGER	col2labelX = 1000 
CONSTANT	INTEGER	col3labelX = 2050

CONSTANT	INTEGER	col1cellX = 435		//These move the added columns left/right
CONSTANT	INTEGER	col2cellX = 1450
CONSTANT	INTEGER	col3cellX = 2487

CONSTANT INTEGER  rightmargin = 5500

CONSTANT INTEGER	colwidth1 = 450
CONSTANT INTEGER	colwidth2 = 450
CONSTANT INTEGER	colwidth3 = 450

CONSTANT STRING	labelwidth = '425'
CONSTANT STRING	cellheight = '64'
CONSTANT INTEGER	charwidth = 40
CONSTANT INTEGER	y_offset = 92


LONG		l_nColCount, l_nMaxX, l_nMaxY, l_nX, l_nY, l_nIndex, l_nPos, ll_x_cord, ll_largest_x
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nNewColId, l_nTabSeq
INTEGER  l_nNewTabSeq, l_nNumChars, l_nCellWidth, l_nNextCellWidth
STRING	l_sColName, l_sModString, l_sMsg, l_cSyntax, l_cObjName, l_cVisible
STRING	l_cDisplayOnly, l_cNewLine, l_cLabelX, l_cCellX, l_cUpdate
STRING	l_cLabelName, l_cLabelText, l_cCity, l_cState, l_cZip, ls_result_syntax
long 		ll_new_id 
datawindow	ldw_search_results

//n_datawindow_syntax	ln_datawindow_syntax
//ln_datawindow_syntax	=	Create n_datawindow_syntax


//Recreate the datawindow to make sure the columns don't just keep getting added on
adw_datawindow.Create(is_results_syntax)

// determine the location of the last predefined column in the datawindow
l_nColCount = LONG (adw_datawindow.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO l_nColCount
	IF adw_datawindow.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = adw_datawindow.Describe ('#' + STRING (l_nIndex) + '.Name')
		l_nX = INTEGER (adw_datawindow.Describe("#" + STRING(l_nIndex) + '.X'))
		l_nY = INTEGER (adw_datawindow.Describe("#" + STRING(l_nIndex) + '.Y'))
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
		l_nNewTabSeq = INTEGER (adw_datawindow.Describe("#" + STRING(l_nIndex) + '.tabsequence'))
		IF l_nTabSeq < l_nNewTabSeq THEN
			l_nTabSeq = l_nNewTabSeq
		END IF
	END IF
NEXT

// determine if last field is in a group box and prep accordingly
l_sMsg = adw_datawindow.Describe ("DataWindow.Objects")
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
		l_nX = INTEGER (adw_datawindow.Describe (l_cObjName + ".X"))
		l_nY = INTEGER (adw_datawindow.Describe (l_cObjName + ".Y")) + &
				 INTEGER (adw_datawindow.Describe (l_cObjName + ".Height"))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxY = l_nY
			l_nMaxX = col1cellX
			l_nLastCol = -1
		END IF
	END IF
LOOP WHILE pos (l_sMsg, "~t", l_nIndex) > 0

// determine location of first field to add
IF l_nLastCol = -1 THEN  // if the last field was in a group box
	l_nColNum = 1
ELSE
//	l_nX = INTEGER (adw_datawindow.Describe("#" + STRING(l_nLastCol) + '.X'))
//	l_nY = INTEGER (adw_datawindow.Describe("#" + STRING(l_nLastCol) + '.Y'))
//	l_nWidth = INTEGER (adw_datawindow.Describe("#" + STRING(l_nLastCol) + '.Width'))
//	CHOOSE CASE (l_nX + l_nWidth)
//		CASE IS > (col3labelX - 27)
//			l_nColNum = 1
//		CASE IS > (col2labelX - 27)
//			l_nColNum = 3
//		CASE ELSE
//			l_nColNum = 2
//	END CHOOSE
l_nX = INTEGER (adw_datawindow.Describe("#" + STRING(l_nLastCol) + '.X')) + INTEGER (adw_datawindow.Describe("#" + STRING(l_nLastCol) + '.Width'))
l_nY = INTEGER (adw_datawindow.Describe("#" + STRING(l_nLastCol) + '.Y'))

ll_largest_x = l_nX

END IF

// add the new columns to the result set of the datawindow.
l_cSyntax = adw_datawindow.Describe("DataWindow.Syntax")

// add the new fields
FOR l_nIndex = 1 TO i_wparentwindow.i_nNumConfigFields
	
	IF i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length = 0 THEN
		
		// skip over entries with field_length = 0 because they are for re-labeling only.
		CONTINUE
	
	ELSE
		// build the dbname parameter by combining the table and column names in dot notation.
		CHOOSE CASE i_wparentwindow.i_cSourceType
			CASE 'C'
				l_sColName = i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
			CASE 'E'
				l_sColName = i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
			CASE 'P'
				l_sColName = i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
			CASE 'O'
				l_sColName = i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
		END CHOOSE
		
		// determine the width of the field to be displayed and the next field as well
		CHOOSE CASE (i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length * charwidth)
			CASE IS <= colwidth1
				l_nCellWidth = colwidth1
			CASE IS <= colwidth2
				l_nCellWidth = colwidth2
			CASE ELSE
				l_nCellWidth = colwidth3
		END CHOOSE
		
		IF (l_nIndex < i_wparentwindow.i_nNumConfigFields) THEN
			CHOOSE CASE (i_wparentwindow.i_sContactHistoryField[l_nIndex + 1].field_length * charwidth)
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
		
		l_nPos = Pos(l_cSyntax, "text(")
		l_nPos = l_nPos - 6
	
		// For Other Source Types, allow database updates
		IF i_wparentwindow.i_cSourceType = 'O' THEN
			l_sModString = 'column=(type=char(50) update=yes updatewhereclause=yes ' + &
								'name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		ELSE 
			l_sModString = 'column=(type=char(50) update=yes updatewhereclause=yes ' + &
								'name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		END IF
		
		uf_StringInsert(l_cSyntax, l_sModString, (l_nPos + 1))

		IF i_wparentwindow.i_sContactHistoryField[l_nIndex].visible = "Y" THEN
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
			
			l_cLabelX = string(ll_largest_x + (colwidth1 * l_nIndex) + 1)
			l_cCellX = l_cLabelX
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Adjust the length of the color rectangle as you add columns
			//-----------------------------------------------------------------------------------------------------------------------------------
//			dw_case_history.Object.background_color.width = long(l_cCellX) + 25
			
			// add the new column label
			l_nPos = Pos (l_cSyntax, "htmltable") - 1
			l_sModString = 'text(name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+'_t band=header ' + &
								'font.charset="0" font.face="Tahoma" ' + &
								'font.family="2" font.height="-8" font.pitch="2" font.weight="700" ' + &
								'background.mode="1" background.color="536870912" color="33554432" alignment="2" ' + &
								'border="0" x="'+l_cLabelX+'" y="132" height="64" ' + &
								'width="411" text="'+i_wparentwindow.i_sContactHistoryField[l_nIndex].field_label+'" )' + l_cNewLine
			uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
			
		ELSE
			l_cVisible = "0"
		END IF
			
		// prepare to add the new column
		l_nColCount = l_nColCount + 1
		IF l_nTabSeq > 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable

/*		
		IF i_wparentwindow.i_sContactHistoryField[l_nIndex].display_only = 'Y' THEN
			l_cDisplayOnly = 'yes'
		ELSE
			l_cDisplayOnly = 'no'
		END IF	
*/		
		// add the correct type of field to the datawindow
		l_nPos = Pos (l_cSyntax, "htmltable") - 1
		
		IF IsNull(i_wparentwindow.i_sContactHistoryField[l_nIndex].edit_mask) OR i_wparentwindow.i_cSourceType <> 'O' THEN
			// determine the value for edit.limit
			l_sModString = &
				'column(name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="76" width="'+STRING (l_nCellWidth)+'" color="33554432" ' + &
				'border="0" alignment="0" format="[general]" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
				'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
				'edit.codetable=no edit.displayonly=no edit.hscrollbar=no ' + &
				'edit.imemode=0 edit.limit='+STRING (i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length)+' ' + &
				'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
				'edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="1" background.color="536870912" font.charset="0" ' + &
				'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
				'font.weight="400" tabsequence=0 )' + l_cNewLine
		ELSE
			l_sModString = &
				'column(name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="76" width="'+STRING (l_nCellWidth)+'" color="33554432" ' + &
				'border="0" alignment="0" format="[general]" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
				'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
				'edit.codetable=no edit.displayonly=no edit.hscrollbar=no ' + &
				'edit.imemode=0 edit.limit='+STRING (i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length)+' ' + &
				'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
				'edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="1" background.color="536870912" font.charset="0" ' + &
				'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
				'font.weight="400" tabsequence=0 )' + l_cNewLine
				
		END IF
		
		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
		
	END IF
	
NEXT

// resize the detail band if necessary
IF (l_nMaxY + 64) > LONG (adw_datawindow.Object.Datawindow.Detail.Height) THEN

	l_nPos = Pos (l_cSyntax, "detail(height=") + 14
	l_nNumChars = Pos (l_cSyntax, " ", l_nPos) - l_nPos
	l_cSyntax = Replace (l_cSyntax, l_nPos, l_nNumChars, STRING (l_nMaxY + 76))
	
END IF

// re-initialize the datawindow
IF adw_datawindow.Create (l_cSyntax, l_sMsg) <> 1 THEN
	MessageBox (gs_AppName, l_sMsg)
	RETURN 'error'

ELSE
	adw_datawindow.SetTransObject(SQLCA)
	

	// add any validation rules and error messages that are defined for the columns and re-label fields as needed.
	FOR l_nIndex = 1 to i_wparentwindow.i_nNumConfigFields
		IF i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length = 0 THEN
		
			// apply the new label if appropriate
			l_cLabelName = i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name + "_t"
			IF adw_datawindow.Describe (l_cLabelName + ".Text") <> "!" THEN
	
				// update the label in the preview window if the label item exists
				l_cLabelText = gf_AllowQuotesInLabels (i_wparentwindow.i_sContactHistoryField[l_nIndex].field_label)
				adw_datawindow.Modify (l_cLabelName + ".Text='" + l_cLabelText + ":'")
	
			END IF
			
			// get the parts of the combined label text
			IF Pos (l_cLabelName, '_city_t', 1) > 0 THEN l_cCity = l_cLabelText
			IF Pos (l_cLabelName, '_state_t', 1) > 0 THEN l_cState = l_cLabelText
			IF Pos (l_cLabelName, '_zip_t', 1) > 0 THEN l_cZip = l_cLabelText
			
		ELSEIF i_wparentwindow.i_cSourceType = 'O' THEN
			
			// apply other changes as needed
			l_sColName = i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
			IF adw_datawindow.Describe (l_sColName + ".EditMask.Mask") <> "" THEN
				IF i_wparentwindow.i_sContactHistoryField[l_nIndex].validation_rule <> "" THEN
					l_sModString =  i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name + &
										'.Validation="'+i_wparentwindow.i_sContactHistoryField[l_nIndex].validation_rule+'" '
					l_sMsg = adw_datawindow.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation message for the current column.")
					END IF
				END IF
				IF i_wparentwindow.i_sContactHistoryField[l_nIndex].error_msg <> "" THEN
					l_sModString = l_sModString + i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name + &
										'.ValidationMsg="'+i_wparentwindow.i_sContactHistoryField[l_nIndex].error_msg+'" '
					l_sMsg = adw_datawindow.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation error message for the current column.")
					END IF
				END IF
			END IF
		END IF
		
	NEXT
	
	// update the combined City, State, Zip label if it exists
	IF adw_datawindow.Describe ("city_state_zip_t.Text") <> "!" THEN
		adw_datawindow.Modify ("city_state_zip_t.Text='" + l_cCity + ', ' + l_cState + ', ' + l_cZip + ":'")
	END IF
	
	RETURN ''
END IF

Return ''
end function

public function integer of_save_syntax (string as_dataobject, string as_casetype, string as_sourcetype, string as_dynamiccolumn_list, blob ab_syntaxblob);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_dataobject 	- This is the datawindow that you are saving the syntax for
//					as_casetype		-	This is the CaseType the syntax is for
//					as_sourcetype	-	This is the SourceType that the syntax is for
//	Overview:   This function takes datawindow syntax and either inserts or updates it into the SyntaxStorage
//					object, which will then update the database with the new syntax.
//	Created by:	Joel White
//	History: 	6/23/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


String	ls_filter_string
long		ll_rowcount, ll_blob_ID, ll_new_row, ll_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Don't save syntax if it doesn't have a SourceType and a CaseType
//-----------------------------------------------------------------------------------------------------------------------------------
If	IsNull(as_casetype) Or as_casetype = '' Or as_sourcetype = '' Or IsNull(as_sourcetype) Then
	Return 0
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the filter string and filter the rows of the datastore to see if you already have a record for this combination
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_filter_string =  'qualifier = "' + as_dataobject + '" and  casetype = "' + as_casetype + '" and  sourcetype = "' +  as_sourcetype + '"'
	
	gn_globals.ids_syntax.SetFilter(ls_filter_string)
	gn_globals.ids_syntax.Filter()
			
	ll_rowcount = gn_globals.ids_syntax.RowCount()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If a row was found, then update the row, otherwise Insert a new row.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_rowcount > 0 Then
		ll_blob_ID = gn_globals.ids_syntax.GetItemNumber(ll_rowcount, 'blbobjctid')
		in_blob_manipulator.of_update_blob(ab_syntaxblob, ll_blob_ID, FALSE)
		
		gn_globals.ids_syntax.SetItem(ll_rowcount, 'qualifier', as_dataobject)
		gn_globals.ids_syntax.SetItem(ll_rowcount, 'login', gn_globals.is_login)
		gn_globals.ids_syntax.SetItem(ll_rowcount, 'BlbObjctID', ll_blob_ID)
		gn_globals.ids_syntax.SetItem(ll_rowcount, 'casetype', as_casetype)
		gn_globals.ids_syntax.SetItem(ll_rowcount, 'sourcetype', as_sourcetype)
		ll_return = gn_globals.ids_syntax.SetItem(ll_rowcount, 'dynamiccolumns', as_dynamiccolumn_list)
	Else
		ll_blob_ID = in_blob_manipulator.of_insert_blob(ab_syntaxblob, as_dataobject, FALSE)
		
		ll_new_row = gn_globals.ids_syntax.InsertRow(0)
		gn_globals.ids_syntax.SetItem(ll_new_row, 'qualifier', as_dataobject)
		gn_globals.ids_syntax.SetItem(ll_new_row, 'login', gn_globals.is_login)
		gn_globals.ids_syntax.SetItem(ll_new_row, 'BlbObjctID', ll_blob_ID)
		gn_globals.ids_syntax.SetItem(ll_new_row, 'casetype', as_casetype)
		gn_globals.ids_syntax.SetItem(ll_new_row, 'sourcetype', as_sourcetype)
		ll_return = gn_globals.ids_syntax.SetItem(ll_new_row, 'dynamiccolumns', as_dynamiccolumn_list)
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reset the filters just in case as this instance datastore will have state throughout the application
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.ids_syntax.SetFilter('')
	gn_globals.ids_syntax.Filter()
	
	Return 1
End If
end function

public function string of_get_syntax (string as_dataobject, string as_casetype, string as_sourcetype);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_dataobject 	- 	This is the name of the datawindow that the syntax is for
//					as_casetype		-	This is the case type that the syntax was generated from
//					as_sourcetype	-	This is the source type that the syntax was generated from
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	6/23/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_filter_string, ls_column_list, ls_syntax
long		ll_rowcount, ll_blob_ID, ll_new_row, ll_pos
blob		lb_syntax_blob
string	ls_null[]
s_fieldproperties ls_null_fieldprops[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the filter string and filter the datastore for the datawindow, casetype and sourcetype to see if a row already exists
//-----------------------------------------------------------------------------------------------------------------------------------
ls_filter_string =  'qualifier = "' + as_dataobject + '" and  casetype = "' + as_casetype + '" and  sourcetype = "' +  as_sourcetype + '"'

gn_globals.ids_syntax.SetFilter(ls_filter_string)
gn_globals.ids_syntax.Filter()
		
ll_rowcount = gn_globals.ids_syntax.RowCount()

If ll_rowcount > 0 Then
	ll_blob_ID 					= 	gn_globals.ids_syntax.GetItemNumber(ll_rowcount, 'blbobjctid')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse the list of dynamic columns the user had
	//-----------------------------------------------------------------------------------------------------------------------------------
	If as_dataobject = 'd_search_contact_history' Then
		is_dynamic_columns[] 							= 	ls_null[]
		i_wParentWindow.i_sContactHistoryField[]	= 	ls_null_fieldprops[]
		
		ls_column_list			=	gn_globals.ids_syntax.GetItemString(ll_rowcount, 'dynamiccolumns')
		gn_globals.in_string_functions.of_parse_string(ls_column_list, ',', is_dynamic_columns[])
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Retrieve the blob that contains the DW syntax and convert it into a string variable
	//-----------------------------------------------------------------------------------------------------------------------------------
	lb_syntax_blob = 	in_blob_manipulator.of_retrieve_blob(ll_blob_ID)
	ls_syntax		=	string(lb_syntax_blob)

	// Make sure we converted it correctly - RAP 11/4/08
	ll_pos = Pos( ls_syntax, "release" )
	IF ll_pos = 0 THEN
		ls_syntax = string(lb_syntax_blob, EncodingANSI!)
	END IF
	
Else
	ls_syntax = 'none'
End If
	
gn_globals.ids_syntax.SetFilter('')
gn_globals.ids_syntax.Filter()	
	
Return ls_syntax
end function

public subroutine of_post_retrieve_process (integer al_return);string l_cCaseMasterNum

If al_return = 0 Then
	i_wParentWindow.i_cSelectedCase = ''
	
	//dw_case_preview.fu_retrieve (c_IgnoreChanges, dw_case_history.c_NoRefreshChildren)
	uo_search_contact_history.dw_report_detail.Retrieve(string(0), i_wParentWindow.i_nRepConfidLevel)
	
	i_wParentWindow.dw_folder.fu_DisableTab (5)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Disable the case transfer option
	//-----------------------------------------------------------------------------------------------------------------------------------
	m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled			= FALSE
	m_create_maintain_case.m_file.m_printcasedetailreport.Enabled			= FALSE
	m_create_maintain_case.m_file.m_transfercase.Enabled = FALSE
	
	m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
	m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
Else	
	l_cCaseMasterNum = uo_search_contact_history.dw_report.Object.case_log_master_case_number[ 1 ]
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Enable/Disable depending on status
	//-----------------------------------------------------------------------------------------------------------------------------------
	CHOOSE CASE Upper( uo_search_contact_history.dw_report.GetItemString( 1, 'case_stat_desc' ) )
		CASE 'OPEN'
			m_create_maintain_case.m_file.m_transfercase.Enabled = TRUE
			
			IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
				m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
				m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
			ELSE
				m_create_maintain_case.m_edit.m_linkcase.Enabled = i_wParentWindow.i_bLinked
				m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
			END IF
		CASE 'CLOSED'
			m_create_maintain_case.m_file.m_transfercase.Enabled = FALSE
			
			IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
				m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
				m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
			ELSE
				m_create_maintain_case.m_edit.m_linkcase.Enabled = i_wParentWindow.i_bLinked
				m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
			END IF
		CASE ELSE
			IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
				m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
			ELSE
				m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
			END IF
			
			m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
	END CHOOSE
End If

//CHOOSE CASE al_return
//	CASE IS < 0
//		Error.i_FWError = c_Fatal
//		
//		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
//		m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
//
//	CASE 0
//		// set values accordingly
//		i_wParentWindow.i_cSelectedCase = ''
//		
//		// clear the preview pane
//		dw_case_preview.fu_retrieve (c_IgnoreChanges, dw_case_history.c_NoRefreshChildren)
//	
//		i_wParentWindow.dw_folder.fu_DisableTab (5)
//		
//		//Disable the case transfer option
//		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled			= FALSE
//		m_create_maintain_case.m_file.m_printcasedetailreport.Enabled			= FALSE
//		m_create_maintain_case.m_file.m_transfercase.Enabled = FALSE
//		
//		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
//		m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
//		
//	CASE ELSE
//		
//		l_cCaseMasterNum = dw_case_history.Object.case_log_master_case_number[ 1 ]
//		
//		//Enable/Disable depending on status
//		CHOOSE CASE Upper( dw_case_history.GetItemString( 1, 'case_stat_desc' ) )
//			CASE 'OPEN'
//				m_create_maintain_case.m_file.m_transfercase.Enabled = TRUE
//				
//				IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
//					m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
//					m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
//				ELSE
//					m_create_maintain_case.m_edit.m_linkcase.Enabled = i_wParentWindow.i_bLinked
//					m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
//				END IF
//			CASE 'CLOSED'
//				m_create_maintain_case.m_file.m_transfercase.Enabled = FALSE
//				
//				IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
//					m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
//					m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
//				ELSE
//					m_create_maintain_case.m_edit.m_linkcase.Enabled = i_wParentWindow.i_bLinked
//					m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
//				END IF
//			CASE ELSE
//				IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
//					m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
//				ELSE
//					m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
//				END IF
//				
//				m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
//		END CHOOSE
//		
//END CHOOSE
//


end subroutine

public function string of_delete_syntax (string as_dataobject, string as_casetype, string as_sourcetype);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_dataobject 	- 	This is the name of the datawindow that the syntax is for
//					as_casetype		-	This is the case type that the syntax was generated from
//					as_sourcetype	-	This is the source type that the syntax was generated from
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	6/23/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_filter_string, ls_column_list, ls_syntax
long		ll_rowcount, ll_blob_ID, ll_new_row
blob		lb_syntax_blob
string	ls_null[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the filter string and filter the datastore for the datawindow, casetype and sourcetype to see if a row already exists
//-----------------------------------------------------------------------------------------------------------------------------------
ls_filter_string =  'qualifier = "' + as_dataobject + '" and  casetype = "' + as_casetype + '" and  sourcetype = "' +  as_sourcetype + '"'

gn_globals.ids_syntax.SetFilter(ls_filter_string)
gn_globals.ids_syntax.Filter()
		
ll_rowcount = gn_globals.ids_syntax.RowCount()

If ll_rowcount > 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Delete the blob that contains the DW syntax
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_blob_ID 					= 	gn_globals.ids_syntax.GetItemNumber(ll_rowcount, 'blbobjctid')
	in_blob_manipulator.of_delete_blob(ll_blob_ID)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Delete the SyntaxStorage object row
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.ids_syntax.DeleteRow(ll_rowcount)
End If
	
gn_globals.ids_syntax.SetFilter('')
gn_globals.ids_syntax.Filter()	
	
Return ls_syntax
end function

public function string of_add_case_properties ();CONSTANT	INTEGER	col1labelX = 04		//These move the added labels left/right
CONSTANT	INTEGER	col2labelX = 1000 
CONSTANT	INTEGER	col3labelX = 2050

CONSTANT	INTEGER	col1cellX = 435		//These move the added columns left/right
CONSTANT	INTEGER	col2cellX = 1450
CONSTANT	INTEGER	col3cellX = 2487

CONSTANT INTEGER  rightmargin = 5500

CONSTANT INTEGER	colwidth1 = 407
CONSTANT INTEGER	colwidth2 = 407
CONSTANT INTEGER	colwidth3 = 407

CONSTANT STRING	labelwidth = '425'
CONSTANT STRING	cellheight = '64'
CONSTANT INTEGER	charwidth = 40
CONSTANT INTEGER	y_offset = 92


LONG		l_nColCount, l_nMaxX, l_nMaxY, l_nX, l_nY, l_nIndex, l_nPos, ll_x_cord
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nNewColId, l_nTabSeq
INTEGER  l_nNewTabSeq, l_nNumChars, l_nCellWidth, l_nNextCellWidth
STRING	l_sColName, l_sModString, l_sMsg, l_cSyntax, l_cObjName, l_cVisible
STRING	l_cDisplayOnly, l_cNewLine, l_cLabelX, l_cCellX, l_cUpdate
STRING	l_cLabelName, l_cLabelText, l_cCity, l_cState, l_cZip, ls_result_syntax
long 		ll_new_id 
datawindow	ldw_search_results

//n_datawindow_syntax	ln_datawindow_syntax
//ln_datawindow_syntax	=	Create n_datawindow_syntax


//Recreate the datawindow to make sure the columns don't just keep getting added on
dw_criteria.Create(is_original_criteria_syntax)

// determine the location of the last predefined column in the datawindow
l_nColCount = LONG (dw_criteria.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO l_nColCount
	IF dw_criteria.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = dw_criteria.Describe ('#' + STRING (l_nIndex) + '.Name')
		l_nX = INTEGER (dw_criteria.Describe("#" + STRING(l_nIndex) + '.X'))
		l_nY = INTEGER (dw_criteria.Describe("#" + STRING(l_nIndex) + '.Y'))
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
		l_nNewTabSeq = INTEGER (dw_criteria.Describe("#" + STRING(l_nIndex) + '.tabsequence'))
		IF l_nTabSeq < l_nNewTabSeq THEN
			l_nTabSeq = l_nNewTabSeq
		END IF
	END IF
NEXT

// determine if last field is in a group box and prep accordingly
l_sMsg = dw_criteria.Describe ("DataWindow.Objects")
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
		l_nX = INTEGER (dw_criteria.Describe (l_cObjName + ".X"))
		l_nY = INTEGER (dw_criteria.Describe (l_cObjName + ".Y")) + &
				 INTEGER (dw_criteria.Describe (l_cObjName + ".Height"))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxY = l_nY
			l_nMaxX = col1cellX
			l_nLastCol = -1
		END IF
	END IF
LOOP WHILE pos (l_sMsg, "~t", l_nIndex) > 0

// determine location of first field to add
IF l_nLastCol = -1 THEN  // if the last field was in a group box
	l_nColNum = 1
ELSE
	l_nX = INTEGER (dw_criteria.Describe("#" + STRING(l_nLastCol) + '.X'))
	l_nY = INTEGER (dw_criteria.Describe("#" + STRING(l_nLastCol) + '.Y'))
	l_nWidth = INTEGER (dw_criteria.Describe("#" + STRING(l_nLastCol) + '.Width'))
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
l_cSyntax = dw_criteria.Describe("DataWindow.Syntax")


// add the new fields
FOR l_nIndex = 1 TO i_wparentwindow.i_nNumConfigFields
	
	IF i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length = 0 THEN
		
		// skip over entries with field_length = 0 because they are for re-labeling only.
		CONTINUE
	
	ELSE
		// build the dbname parameter by combining the table and column names in dot notation.
		CHOOSE CASE i_wparentwindow.i_cSourceType
			CASE 'C'
				l_sColName = 'consumer.'+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
			CASE 'E'
				l_sColName = 'employer_group.'+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
			CASE 'P'
				l_sColName = 'provider_of_service.'+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
			CASE 'O'
				l_sColName = 'other_source.'+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
		END CHOOSE
		
		// determine the width of the field to be displayed and the next field as well
		CHOOSE CASE (i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length * charwidth)
			CASE IS <= colwidth1
				l_nCellWidth = colwidth1
			CASE IS <= colwidth2
				l_nCellWidth = colwidth2
			CASE ELSE
				l_nCellWidth = colwidth3
		END CHOOSE
		
		IF (l_nIndex < i_wparentwindow.i_nNumConfigFields) THEN
			CHOOSE CASE (i_wparentwindow.i_sContactHistoryField[l_nIndex + 1].field_length * charwidth)
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
//		l_nPos = Pos (l_cSyntax, "~r~ntable(")
//		DO WHILE Pos (l_cSyntax, "column=(", l_nPos + 1) > 0
//			l_nPos = Pos (l_cSyntax, "column=(", l_nPos + 1)
//		LOOP
//		l_nPos = Pos (l_cSyntax, "~r~n", l_nPos + 1)
//		l_cNewLine = "~r~n"
		
		l_nPos = Pos(l_cSyntax, "text(")
		l_nPos = l_nPos - 6
	
		// For Other Source Types, allow database updates
		IF i_wparentwindow.i_cSourceType = 'O' THEN
			l_sModString = 'column=(type=char(50) update=yes updatewhereclause=yes ' + &
								'name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		ELSE 
			l_sModString = 'column=(type=char(50) update=yes updatewhereclause=yes ' + &
								'name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		END IF
		
		uf_StringInsert(l_cSyntax, l_sModString, (l_nPos + 1))


///*	JWhite Removed 12.20.2004
//		// update the SQL SELECT portion of the datawindow
//		l_nPos = Pos (l_cSyntax, 'retrieve="')
//		DO WHILE Pos (l_cSyntax, "COLUMN(NAME", l_nPos + 1) > 0
//			l_nPos = Pos (l_cSyntax, "COLUMN(NAME", l_nPos + 1)
//		LOOP
//		l_nPos = Pos (l_cSyntax, ')', l_nPos + 1)
//		l_sModString = ' COLUMN(NAME=~~"cusfocus.'+l_sColName+'~~")'
//		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
//*/	
	
		IF i_wparentwindow.i_sContactHistoryField[l_nIndex].visible = "Y" THEN
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
			l_sModString = 'text(name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+'_t band=detail ' + &
								'font.charset="0" font.face="Tahoma" ' + &
								'font.family="2" font.height="-8" font.pitch="2" font.weight="700" ' + &
								'background.mode="1" background.color="536870912" color="33554432" alignment="1" ' + &
								'border="0" x="'+l_cLabelX+'" y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" ' + &
								'width="'+labelwidth+'" text="'+i_wparentwindow.i_sContactHistoryField[l_nIndex].field_label+' " )' + l_cNewLine
			uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
			
		ELSE
			l_cVisible = "0"
		END IF
			
		// prepare to add the new column
		l_nColCount = l_nColCount + 1
		IF l_nTabSeq > 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable

///*		
//		IF i_wparentwindow.i_sContactHistoryField[l_nIndex].display_only = 'Y' THEN
//			l_cDisplayOnly = 'yes'
//		ELSE
//			l_cDisplayOnly = 'no'
//		END IF	
//*/		
		// add the correct type of field to the datawindow
		l_nPos = Pos (l_cSyntax, "htmltable") - 1
		
		IF IsNull(i_wparentwindow.i_sContactHistoryField[l_nIndex].edit_mask) OR i_wparentwindow.i_cSourceType <> 'O' THEN
			// determine the value for edit.limit
			l_sModString = &
				'column(name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
				'border="5" alignment="0" format="[general]" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
				'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
				'edit.codetable=no edit.displayonly=no edit.hscrollbar=no ' + &
				'edit.imemode=0 edit.limit='+STRING (i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length)+' ' + &
				'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
				'edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="0" background.color="16777215" font.charset="0" ' + &
				'font.face="Arial" font.family="2" font.height="-10" font.pitch="2" ' + &
				'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
		ELSE
			l_sModString = &
				'column(name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
				'border="5" alignment="0" format="'+i_wparentwindow.i_sContactHistoryField[l_nIndex].display_format+'" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
				'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
				'edit.codetable=no edit.displayonly=no edit.hscrollbar=no ' + &
				'edit.imemode=0 edit.limit='+STRING (i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length)+' ' + &
				'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
				'edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="0" background.color="16777215" font.charset="0" ' + &
				'font.face="Arial" font.family="2" font.height="-10" font.pitch="2" ' + &
				'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
			
//				'column(name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' band=detail ' + &
//				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
//				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
//				'border="5" alignment="0" format="'+i_wparentwindow.i_sContactHistoryField[l_nIndex].display_format+'" ' + &
//				'visible="'+l_cVisible+'" editmask.focusrectangle=no editmask.autoskip=no editmask.required=no ' + &
//				'editmask.readonly='+l_cDisplayOnly+' editmask.codetable=no editmask.spin=no ' + &
//				'editmask.mask="'+i_wparentwindow.i_sContactHistoryField[l_nIndex].edit_mask+'" editmask.imemode=0 ' + &
//				'criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
//				'background.mode="0" background.color="16777215" font.charset="0" ' + &
//				'font.face="Arial" font.family="2" font.height="-10" font.pitch="2" ' + &
//				'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
		END IF
		
			If lower(i_wparentwindow.i_sContactHistoryField[l_nIndex].dropdown) = 'y' Then
				l_sModString = &		
				'column(band=detail id='+STRING (l_nColCount)+' alignment="0" tabsequence='+STRING (l_nTabSeq)+' border="5" ' + & 
				'color="0" x="'+l_cCellX+'"  y="'+STRING (l_nMaxY)+'" height="64" width="'+STRING (l_nCellWidth)+'" format="[general]" html.valueishtml="0"  ' + & 
				'name='+i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name+' visible="'+l_cVisible+'" dddw.name=dddw_caseprops_generic dddw.displaycolumn=casepropertiesvalues_value ' + &
				'dddw.datacolumn=casepropertiesvalues_value dddw.percentwidth=0 dddw.lines=0 dddw.limit=0 dddw.allowedit=no ' + & 
				'dddw.useasborder=yes dddw.case=any dddw.nilisnull=yes dddw.imemode=0 dddw.vscrollbar=yes  ' + & 
				'font.face="Arial" font.height="-10" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" ' + & 
				'background.mode="2" background.color="16777215" )' + l_cNewLine
			End If
		
		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
		
	END IF
	
NEXT

// resize the detail band if necessary
IF (l_nMaxY + 64) > LONG (dw_criteria.Object.Datawindow.Detail.Height) THEN

	l_nPos = Pos (l_cSyntax, "detail(height=") + 14
	l_nNumChars = Pos (l_cSyntax, " ", l_nPos) - l_nPos
	l_cSyntax = Replace (l_cSyntax, l_nPos, l_nNumChars, STRING (l_nMaxY + 76))
	
END IF

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 3.29.2005
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	call the function that will add the dynamic columns to the result set datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
//???RAP .Net didn't like this, so I am passing a local dw instead
#IF defined PBDOTNET THEN
	u_datawindow_report ldw_parm
	string ls_syntax, ls_err
	Integer li_return
	ldw_parm = create u_datawindow_report
	ls_syntax = uo_search_contact_history.dw_report.object.datawindow.syntax
	li_return = ldw_parm.create(ls_syntax, ls_err)
	of_add_results_columns(ldw_parm)
	ls_syntax = ldw_parm.object.datawindow.syntax
	li_return = uo_search_contact_history.dw_report.create(ls_syntax, ls_err)
	uo_search_contact_history.dw_report.SetTransObject(SQLCA)
	destroy ldw_parm
#ELSE
	of_add_results_columns(uo_search_contact_history.dw_report)
#END IF

is_new_criteria_syntax = l_cSyntax
//-----------------------------------------------------------------------------------------------------------------------------------
// End JWhite Added 3.29.2005
//-----------------------------------------------------------------------------------------------------------------------------------

// re-initialize the datawindow
IF dw_criteria.Create (l_cSyntax, l_sMsg) <> 1 THEN
	MessageBox (gs_AppName, l_sMsg)
	RETURN 'error'
ELSE
	dw_criteria.SetTransObject(SQLCA)
	
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 5.2.2005 	Get the New Case Prop DropDowns and Retrieve Them
//-----------------------------------------------------------------------------------------------------------------------------------
//	Datawindowchild ldwc_caseprop
//	long	ll_counter, ll_errorcheck
//
//	For	ll_counter = 1 to i_wparentwindow.i_nNumConfigFields
//		If lower(i_wparentwindow.i_sContactHistoryField[ll_counter].dropdown) = 'y' Then
//			ll_errorcheck = dw_criteria.GetChild(i_wparentwindow.i_sContactHistoryField[ll_counter].column_name, ldwc_caseprop)
//			ldwc_caseprop.SetTransObject(SQLCA)
//			ll_errorcheck = ldwc_caseprop.Retrieve(idc_casetype, i_wparentwindow.i_cSourceType, i_wparentwindow.i_sContactHistoryField[ll_counter].column_name)
//		End If
//	Next
//-----------------------------------------------------------------------------------------------------------------------------------
// End JWhite Added 5.2.2005
//-----------------------------------------------------------------------------------------------------------------------------------

	

	// add any validation rules and error messages that are defined for the columns and re-label fields as needed.
	FOR l_nIndex = 1 to i_wparentwindow.i_nNumConfigFields
		IF i_wparentwindow.i_sContactHistoryField[l_nIndex].field_length = 0 THEN
		
			// apply the new label if appropriate
			l_cLabelName = i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name + "_t"
			IF dw_criteria.Describe (l_cLabelName + ".Text") <> "!" THEN
	
				// update the label in the preview window if the label item exists
				l_cLabelText = gf_AllowQuotesInLabels (i_wparentwindow.i_sContactHistoryField[l_nIndex].field_label)
				dw_criteria.Modify (l_cLabelName + ".Text='" + l_cLabelText + ":'")
	
			END IF
			
			// get the parts of the combined label text
			IF Pos (l_cLabelName, '_city_t', 1) > 0 THEN l_cCity = l_cLabelText
			IF Pos (l_cLabelName, '_state_t', 1) > 0 THEN l_cState = l_cLabelText
			IF Pos (l_cLabelName, '_zip_t', 1) > 0 THEN l_cZip = l_cLabelText
			
		ELSEIF i_wparentwindow.i_cSourceType = 'O' THEN
			
			// apply other changes as needed
			l_sColName = i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name
			IF dw_criteria.Describe (l_sColName + ".EditMask.Mask") <> "" THEN
				IF i_wparentwindow.i_sContactHistoryField[l_nIndex].validation_rule <> "" THEN
					l_sModString =  i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name + &
										'.Validation="'+i_wparentwindow.i_sContactHistoryField[l_nIndex].validation_rule+'" '
					l_sMsg = dw_criteria.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation message for the current column.")
					END IF
				END IF
				IF i_wparentwindow.i_sContactHistoryField[l_nIndex].error_msg <> "" THEN
					l_sModString = l_sModString + i_wparentwindow.i_sContactHistoryField[l_nIndex].column_name + &
										'.ValidationMsg="'+i_wparentwindow.i_sContactHistoryField[l_nIndex].error_msg+'" '
					l_sMsg = dw_criteria.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation error message for the current column.")
					END IF
				END IF
			END IF
		END IF
		
	NEXT
	
	// update the combined City, State, Zip label if it exists
	IF dw_criteria.Describe ("city_state_zip_t.Text") <> "!" THEN
		dw_criteria.Modify ("city_state_zip_t.Text='" + l_cCity + ', ' + l_cState + ', ' + l_cZip + ":'")
	END IF
	
	RETURN ''
END IF

//Destroy ln_datawindow_syntax
Return ''
end function

public function string of_hide_columns ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function sets the headers and columns to be visible or hidden depending on the values
//					stored in the database. The values come from the Contact History Fields section in Table
//					Maintenance.
//	Created by:	Joel White
//	History: 	4/22/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datastore	lds_columns
long			ll_rowcount, ll_counter
string		ls_columnname, ls_visible, ls_modify_string, ls_return


//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore, set the data object and the transaction 
//-----------------------------------------------------------------------------------------------------------------------------------
lds_columns = Create datastore
lds_columns.DataObject = 'd_data_contacthistoryfields'
lds_columns.SetTransObject(SQLCA)

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the Datastore
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = lds_columns.Retrieve()


//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the rows of the datastore and check the Visible value
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_counter = 1 to ll_rowcount
	ls_visible = lds_columns.GetItemString(ll_counter, 'Visible')
	ls_columnname = lds_columns.GetItemString(ll_counter, 'columnname')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the visible setting is 'N', then set the column & the related header object to be invisible
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ls_visible = 'N' Then
		ls_modify_string = ls_columnname + '.Visible = 0'
		ls_return = uo_search_contact_history.dw_report.Modify(ls_modify_string)
		
		ls_modify_string = ls_columnname + '_t' + '.Visible = 0'
		ls_return = uo_search_contact_history.dw_report.Modify(ls_modify_string)
	Else
		ls_modify_string = ls_columnname + '.Visible = 1'
		ls_return = uo_search_contact_history.dw_report.Modify(ls_modify_string)
		
		ls_modify_string = ls_columnname + '_t' + '.Visible = 1'
		ls_return = uo_search_contact_history.dw_report.Modify(ls_modify_string)
		
	End If
Next

Destroy lds_columns

Return ''
end function

public subroutine of_build_case_properties ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function is the managing function for building the dynamic case properties.
//					It grabs the user's input values, finds the fields that should be added for this case type,
//					then calls the function that alters the datawindow syntax and recreates the datawindow.
//					Finally, after the new datawindow is created the user's values are set back into the criteria object
//	Created by:	Joel White
//	History: 	4/13/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long ll_row, i
string	ls_category_id, ls_fromdate, ls_todate, ls_casenumber, ls_casestatus, ls_caserep, ls_nullarray[]
S_FIELDPROPERTIES			ls_null_fieldprops[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the user values that they had input before destroying and recreating the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_criteria.RowCount() = 1 Then
	ls_category_id 		= 	dw_criteria.GetItemString(1, 'category_id')
	ls_fromdate 			= 	dw_criteria.GetItemString(1, 'fromdate')
	ls_todate				=	dw_criteria.GetItemString(1, 'todate')
	ls_casenumber 			=	dw_criteria.GetItemString(1, 'casenumber')
	ls_casestatus			=	dw_criteria.GetItemString(1, 'casestatus')
	ls_caserep				=	dw_criteria.GetItemString(1, 'caserep')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure there is a case type and source type
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(i_wParentWindow.is_contacthistory_casetype) And Not IsNull(i_wParentWindow.i_cSourceType) Then
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reset the dynamic column array
	//-----------------------------------------------------------------------------------------------------------------------------------
	is_dynamic_columns[] = ls_nullarray[]
	i_wParentWindow.i_sContactHistoryField[] = ls_null_fieldprops[]
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Call the function that will build the structure with the searchable fields
	//-----------------------------------------------------------------------------------------------------------------------------------
	i_wParentWindow.of_build_contacthistory_fields(i_wParentWindow.i_cSourceType)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Call the function that will add the case properties to the search criteria datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	of_add_case_properties()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the is_dynamic_columns array up for use
	//-----------------------------------------------------------------------------------------------------------------------------------
	For i = 1 To UpperBound(i_wParentWindow.i_sContactHistoryField[])
		is_dynamic_columns[i] = i_wParentWindow.i_sContactHistoryField[i].column_name
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite Added 5.2.2005 	Get the New Case Prop DropDowns and Retrieve Them
	//-----------------------------------------------------------------------------------------------------------------------------------
	Datawindowchild ldwc_caseprop
	long	ll_counter, ll_errorcheck

	For	ll_counter = 1 to i_wparentwindow.i_nNumConfigFields
		If lower(i_wparentwindow.i_sContactHistoryField[ll_counter].dropdown) = 'y' Then
			ll_errorcheck = dw_criteria.GetChild(i_wparentwindow.i_sContactHistoryField[ll_counter].column_name, ldwc_caseprop)
			ldwc_caseprop.SetTransObject(SQLCA)
			ll_errorcheck = ldwc_caseprop.Retrieve(i_wparentwindow.is_contacthistory_casetype, i_wparentwindow.i_cSourceType, i_wparentwindow.i_sContactHistoryField[ll_counter].column_name)
		
			If ll_errorcheck = 0 Then
				ldwc_caseprop.InsertRow(0)
			End If
		End If
	Next
	//-----------------------------------------------------------------------------------------------------------------------------------
	// End JWhite Added 5.2.2005
	//-----------------------------------------------------------------------------------------------------------------------------------

	of_hide_columns()	
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert a new row and set the user's data back into the datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_row = dw_criteria.InsertRow(0)
	
	dw_criteria.SetItem(ll_row, 'category_id', ls_category_id)
	dw_criteria.SetItem(ll_row, 'fromdate', ls_fromdate)
	dw_criteria.setitem(ll_row, 'todate', ls_todate)
	dw_criteria.SetItem(ll_row, 'casenumber', ls_casenumber)
	dw_criteria.SetItem(ll_row, 'casestatus', ls_casestatus)
	dw_criteria.SetItem(ll_row, 'caserep', ls_caserep)
	dw_criteria.SetItem(ll_row, 'casetype', i_wParentWindow.is_contacthistory_casetype)
	
End If

end subroutine

public function string of_init ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function preps the criteria object for use
//	Created by:	Joel White
//	History: 	4/13/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datawindowchild ldwc_casestatus, ldwc_caserep, ldwc_casetype

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the datawindow children
//-----------------------------------------------------------------------------------------------------------------------------------
dw_criteria.GetChild('casetype', ldwc_casetype)
ldwc_casetype.SetTransObject(SQLCA)
ldwc_casetype.Retrieve()

dw_criteria.GetChild('casestatus', ldwc_casestatus)
ldwc_casestatus.SetTransObject(SQLCA)
ldwc_casestatus.Retrieve()

dw_criteria.GetChild('caserep', ldwc_caserep)
ldwc_caserep.SetTransObject(SQLCA)
ldwc_caserep.Retrieve()




Return ''
end function

public function string of_reset_criteria ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function resets the criteria object to its original state, to clear both user
//					values and any dynamic columns that have been added.
//	Created by:	Joel White
//	History: 	4/13/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long ll_return
s_fieldproperties ls_null[]
string	ls_first, ls_last, ls_nulldate, ls_nullarray[]
string ls_nullstring, ls_error

//-----------------------------------------------------------------------------------------------------------------------------------
// Recreate the criteria and results datawindows with their original syntax
//-----------------------------------------------------------------------------------------------------------------------------------
dw_criteria.Create(is_original_criteria_syntax)
ll_return = uo_search_contact_history.dw_report.Create(is_results_syntax, ls_error)

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert a new row
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = dw_criteria.InsertRow(0)

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear the values of the fields
//-----------------------------------------------------------------------------------------------------------------------------------
dw_criteria.SetItem(ll_return , 'category_id', '')
dw_criteria.SetItem(ll_return , 'casenumber', '')
dw_criteria.SetItem(ll_return , 'caserep', '')
dw_criteria.SetItem(ll_return , 'casestatus', '')
is_categoryID = ''
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Check the show_criteria flag and set the dates appropriately
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_show_criteria = FALSE Then 
	ib_first_open = TRUE
End If

dw_criteria.SetItem(1, 'fromdate', ls_nulldate)
dw_criteria.SetItem(1, 'todate', ls_nulldate)

//-----------------------------------------------------------------------------------------------------------------------------------
// Delete the row (if any) that holds the syntax for this datawindow, case_type and source_type
//-----------------------------------------------------------------------------------------------------------------------------------
of_delete_syntax('d_criteria_contacthistory', i_wParentWindow.is_contacthistory_casetype, i_wParentWindow.i_cSourceType)
of_delete_syntax('d_search_contact_history', i_wParentWindow.is_contacthistory_casetype, i_wParentWindow.i_cSourceType)

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the Dynamic Fields array
//-----------------------------------------------------------------------------------------------------------------------------------
i_wParentWindow.i_sContactHistoryField[] = ls_null[]
is_dynamic_columns[] = ls_nullarray[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the Case Type
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ls_nullstring)
i_wParentWindow.is_contacthistory_casetype = ls_nullstring

//-----------------------------------------------------------------------------------------------------------------------------------
// Call of_init function which gets the datawindow children prepped and ready
//-----------------------------------------------------------------------------------------------------------------------------------
of_init()

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function which will re-retrieve the data
//-----------------------------------------------------------------------------------------------------------------------------------
of_retrieve()

//-----------------------------------------------------------------------------------------------------------------------------------
// Hide the columns that shouldn't be shown
//-----------------------------------------------------------------------------------------------------------------------------------
of_hide_columns()

// Reset the filter
uo_search_contact_history.dw_report.SetFilter('')
uo_search_contact_history.dw_report.Filter()

Return ''
end function

public function string of_show_hide_criteria ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function determines if the criteria object should be shown and where the window
//					components should be positioned.
//	Created by:	Joel White
//	History: 	4/13/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_first, ls_last
unsignedlong usl_zero = 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Change the Show_criteria flag
//-----------------------------------------------------------------------------------------------------------------------------------
ib_show_criteria = Not ib_show_criteria
dw_criteria.EVENT ue_init()

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the Criteria should be shown and adjust the components accordingly
//-----------------------------------------------------------------------------------------------------------------------------------
If	ib_show_criteria	Then
	dw_criteria.BringtoTop 					= 		TRUE
	dw_criteria.Visible 						= 		TRUE
//???	st_showcriteria.Text						=		'Hide Criteria...'
	uo_search_contact_history.uo_titlebar.of_hide_button('Show Properties', TRUE)
	uo_search_contact_history.uo_titlebar.of_hide_button('Hide Properties', FALSE)
	dw_criteria.y								=		64
	dw_criteria.x								=		1
	dw_criteria.Height 						= 		350
	st_case_list.y 							= 		dw_criteria.y + dw_criteria.height + 2
	uo_search_contact_history.y							=		st_case_list.y + st_case_list.height
	uo_search_contact_history.resize(uo_search_contact_history.width, uo_search_contact_history.Height - uo_search_contact_history.y)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Setup the From and To Dates when the criteria opens
	//-----------------------------------------------------------------------------------------------------------------------------------
	//ls_first = String(in_date_manipulator.of_get_first_of_month(in_date_manipulator.of_now()), 'mm/dd/yyyy')
	//ls_last 	= String(in_date_manipulator.of_get_last_of_month(in_date_manipulator.of_now()), 'mm/dd/yyyy')

//	If	ib_first_open Then	
//		dw_criteria.SetItem(1, 'fromdate', ls_first)
//		dw_criteria.SetItem(1, 'todate', ls_last)
//	End IF
	
	ib_first_open = FALSE
Else
	of_reset_criteria()
	dw_criteria.Visible 						= 		FALSE
//???	st_showcriteria.Text						=		'Show Criteria...'
	uo_search_contact_history.uo_titlebar.of_hide_button('Show Properties', FALSE)
	uo_search_contact_history.uo_titlebar.of_hide_button('Hide Properties', TRUE)
	st_case_list.y 							= 		20
	uo_search_contact_history.y			=		0
	uo_search_contact_history.resize(uo_search_contact_history.width, this.height)
End If

ib_dynamic_columns = TRUE

Return ''
end function

public function integer of_retrieve_caseprop_dddws (string as_sourcetype, string as_casetype);datastore 			lds_caseprop_field_def	
long					ll_datastore_rows, ll_counter, ll_find_return, ll_errorcheck
string				ls_find_string
DataWindowChild	ldwc_caseprop

//-----------------------------------------------------------------------------------------------------------------------------------
// Initialize the datastore and retrieve it 
//-----------------------------------------------------------------------------------------------------------------------------------
lds_caseprop_field_def = Create Datastore
lds_caseprop_field_def.DataObject = 'd_data_caseprop_field_def'
lds_caseprop_field_def.SetTransObject(SQLCA)
ll_datastore_rows = lds_caseprop_field_def.Retrieve(as_SourceType, as_CaseType)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the dynamic column array and retrieve drop downs for all the necessary columns
//-----------------------------------------------------------------------------------------------------------------------------------
For	ll_counter = 1 to UpperBound(is_dynamic_columns)
	ls_find_string = 'column_name = "' + is_dynamic_columns[ll_counter] + '" AND  dropdown = "Y"'
	ll_find_return = lds_caseprop_field_def.Find(ls_find_string, 1, ll_datastore_rows)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If a row is found, there is a drop down. If no row is found, Insert a Row.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_find_return > 0 Then
		ll_errorcheck = dw_criteria.GetChild(is_dynamic_columns[ll_counter], ldwc_caseprop)
		ldwc_caseprop.SetTransObject(SQLCA)
		ll_errorcheck = ldwc_caseprop.Retrieve(as_CaseType, as_SourceType, is_dynamic_columns[ll_counter])
		
		If ll_errorcheck = 0 Then
			ldwc_caseprop.InsertRow(0)
		End If
	End If
Next

Return 1
end function

on u_contact_history.create
int iCurrent
call super::create
this.dw_criteria=create dw_criteria
this.uo_search_contact_history=create uo_search_contact_history
this.st_case_preview=create st_case_preview
this.st_case_list=create st_case_list
this.st_noaccess=create st_noaccess
this.st_nonotes=create st_nonotes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criteria
this.Control[iCurrent+2]=this.uo_search_contact_history
this.Control[iCurrent+3]=this.st_case_preview
this.Control[iCurrent+4]=this.st_case_list
this.Control[iCurrent+5]=this.st_noaccess
this.Control[iCurrent+6]=this.st_nonotes
end on

on u_contact_history.destroy
call super::destroy
destroy(this.dw_criteria)
destroy(this.uo_search_contact_history)
destroy(this.st_case_preview)
destroy(this.st_case_list)
destroy(this.st_noaccess)
destroy(this.st_nonotes)
end on

event resize;//RAP st_showcriteria.x = this.width - 50 - st_showcriteria.width
//RAP st_nonotes.y = dw_case_preview.y + 200
//RAP st_noaccess.y = dw_case_preview.y + 200


//uo_search_contact_history.height = this.height - (2 * uo_search_contact_history.y)
//uo_search_contact_history.width = this.width - (2 * uo_search_contact_history.x )
uo_search_contact_history.Resize(this.width - (2 * uo_search_contact_history.x ), this.height - uo_search_contact_history.y)

end event

event constructor;call super::constructor;//THIS.of_SetResize( TRUE )
//
//IF IsValid( THIS.inv_resize ) THEN
//	THIS.inv_resize.of_Register( u_contact_history, THIS.inv_resize.SCALERIGHTBOTTOM )
//END IF

end event

event pc_setoptions;call super::pc_setoptions;//*********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To initialize options of this contain object, like resizing
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/30/00 M. Caruso   Created
//  04/13/01 K. Claver   Fixed the resize code.
//  05/24/01 C. Jackson  Correct resize of st_nonotes (SCR 2083)
//  
//*********************************************************************************************


INTEGER	l_nNewWidth, l_nNewHeight
DECIMAL	l_nWidthOffset, l_nHeightOffset

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
	
	// adjust the position of this text item in case the window has been resized.
	inv_resize.of_Register (st_case_preview, "FixedToBottom")
	st_case_preview.Y = st_case_preview.Y + l_nHeightOffset
	
	//Register this object with the resize service
	i_wParentWindow.inv_resize.of_Register (THIS, "ScaleToRight&Bottom")
	
	//Register st_nonotes object with the resize service
	i_wParentWindow.inv_resize.of_Register (st_nonotes, "FixedToBottom")
	

is_original_criteria_syntax = dw_criteria.Object.DataWindow.Syntax
is_results_syntax = uo_search_contact_history.dw_report.Object.DataWindow.Syntax

END IF

end event

event destructor;call super::destructor;dw_criteria.PostEvent('ue_destructor')
end event

type dw_criteria from datawindow within u_contact_history
event ue_searchtrigger pbm_dwnkey
event ue_destructor ( )
event ue_init ( )
boolean visible = false
integer x = 41
integer y = 372
integer width = 3470
integer height = 408
integer taborder = 21
string title = "none"
string dataobject = "d_criteria_contacthistory"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_searchtrigger;//-----------------------------------------------------------------------------------------------------------------------------------
// Fire the retrieve if the user hits the enter key
//-----------------------------------------------------------------------------------------------------------------------------------
if key = keyenter! then
	of_retrieve()
end if


end event

event ue_destructor();Destroy	in_date_manipulator
Destroy  in_blob_manipulator
end event

event ue_init();Long	 	ll_row, ll_return
String	ls_syntax, l_sMsg, ls_null 
blob	 	lb_syntax_blob

SetNull(ls_null)

//ib_show_criteria = FALSE

ls_syntax = of_get_syntax(dw_criteria.DataObject, i_wParentWindow.i_cCaseType, i_wParentWindow.i_cSourceType)

If ls_syntax <> 'none' Then
	If Not IsNull(ls_syntax) And ls_syntax <> '' Then
		IF this.Create (ls_Syntax, l_sMsg) <> 1 Then
			this.Create(is_original_criteria_syntax)
			this.SetTransObject(SQLCA)
			this.InsertRow(0)
		Else
			this.SetTransObject(SQLCA)
			
			of_retrieve_caseprop_dddws(i_wParentWindow.i_cSourceType, i_wParentWindow.i_cCaseType)
	
			ll_row = this.InsertRow(0)
			ll_return = this.SetItem(ll_row, 'casetype', i_wParentWindow.i_cCaseType)
		End If
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the initialization function that will get the DDDW Children
//-----------------------------------------------------------------------------------------------------------------------------------
of_init()

of_retrieve()

//???dw_case_history.SetReDraw(TRUE)

end event

event clicked;string ls_category_name, ls_category_id, ls_returned_date, ls_lineage
long ll_return


if dwo.name = 'category_id' Then
	If IsNull(i_wParentWindow.is_contacthistory_casetype) Or  i_wParentWindow.is_contacthistory_casetype = '' Then
		gn_globals.in_messagebox.of_messagebox('Please select a case type', Information!, OK!, 1)
	Else
		openwithparm(iw_category_popup, i_wParentWindow.is_contacthistory_casetype)
		
		  SELECT cusfocus.categories.category_name,
		  			cusfocus.categories.category_lineage
			 INTO :ls_category_name,
			 		:ls_lineage
			 FROM cusfocus.categories  
			WHERE cusfocus.categories.category_id = :Message.StringParm  
					  ;
					  
		is_categoryID 	= 	 ls_lineage
		ll_return 		= 	dw_criteria.SetItem(1, 'category_id', ls_category_name)

	End If
ElseIf dwo.name = 'calender_t'	Then
	ls_returned_date = of_pop_calendar(xpos, ypos, dw_criteria.GetItemString(1, 'fromdate'))
	dw_criteria.SetItem(1, 'fromdate', ls_returned_date)
ElseIf dwo.name = 'calendar2_t'  Then	
	ls_returned_date = of_pop_calendar(xpos, ypos, dw_criteria.GetItemString(1, 'todate'))
	dw_criteria.SetItem(1, 'todate', ls_returned_date)
End If
end event

event destructor;////-----------------------------------------------------------------------------------------------------------------------------------
//// Added JDW 4.12.2005 
////
//// Code to store the user's datawindow syntax so we can remember their preferences
////-----------------------------------------------------------------------------------------------------------------------------------
//string 	ls_syntax, ls_null
//blob	 	lb_blob_to_insert
//
//ls_syntax 			= 		this.Object.DataWindow.Syntax
//lb_blob_to_insert	=		blob(ls_syntax)
//
//SetNull(ls_null)
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// Call the function that will save the syntax off for the DataObject, Case Type and Source Type
////-----------------------------------------------------------------------------------------------------------------------------------
//of_save_syntax(this.DataObject, i_wParentWindow.is_contacthistory_casetype, i_wParentWindow.i_cSourceType, ls_null, lb_blob_to_insert)
//
end event

event editchanged;this.AcceptText()
end event

event itemchanged;string 	ls_nullarray[], ls_null, ls_column_list
string 	ls_filter_string, l_sMsg
long		ll_rowcount, i, ll_return, ll_row
string	ls_syntax_results, ls_syntax_criteria, ls_syntax
blob		lb_syntax_blob
boolean	lb_error = FALSE, lb_successful = FALSE
datawindowchild ldwc_casetype
s_fieldproperties ls_null_fieldprops[]

//-----------------------------------------------------------------------------------------------------------------------------------
// If the changed column is CaseType then set the instance variable that holds casetype and call the function
//	to build the dynamic case properties
//-----------------------------------------------------------------------------------------------------------------------------------
If dwo.Type = 'column' Then
	If dwo.Name = 'casetype' Then
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Before clearing the variables, store the syntax of the datawindow to the SyntaxStorage Datawindow in case
		// the user had made changes to the order, etc.
		//-----------------------------------------------------------------------------------------------------------------------------------
//		ls_syntax = dw_criteria.Object.DataWindow.Syntax
//		lb_syntax_blob = blob(ls_syntax)
//		of_save_syntax(dw_criteria.Dataobject, i_wParentWindow.is_contacthistory_casetype, i_wParentWindow.i_cSourceType, ls_null, lb_syntax_blob)
		
		ls_syntax = uo_search_contact_history.dw_report.Object.DataWindow.Syntax
		lb_syntax_blob = blob(ls_syntax)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the dynamic columns and build a comma delimited list
		//-----------------------------------------------------------------------------------------------------------------------------------
		For i = 1 to UpperBound(is_dynamic_columns)
			ls_column_list = ls_column_list + is_dynamic_columns[i] + ','
		Next
		
		ls_column_list = Left(ls_column_list, Len(ls_column_list) - 1)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Store the syntax for the dw_case_history datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
//		ls_syntax = uo_search_contact_history.dw_report.Object.DataWindow.Syntax
//		lb_syntax_blob = blob(ls_syntax)
//		of_save_syntax(uo_search_contact_history.dw_report.Dataobject, i_wParentWindow.is_contacthistory_casetype, i_wParentWindow.i_cSourceType, ls_column_list, lb_syntax_blob)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the new case type and reset the dynamic column array
		//-----------------------------------------------------------------------------------------------------------------------------------
		i_wParentWindow.is_contacthistory_casetype = data
		is_dynamic_columns[] = ls_nullarray[]
		i_wParentWindow.i_sContactHistoryField[] = ls_null_fieldprops[]

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Check to see if there is existing syntax for the new SourceType/CaseType combination
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_syntax_results 	= 	of_get_syntax(uo_search_contact_history.dw_report.DataObject, data, i_wParentWindow.i_cSourceType)
		ls_syntax_criteria 	= 	of_get_syntax(dw_criteria.DataObject, data, i_wParentWindow.i_cSourceType)

		//-----------------------------------------------------------------------------------------------------------------------------------
		// If there was existing Syntax, try and recreate the Results Datawindow
		// Mark the boolean variables to let us know if it has recreated successfully or not
		//-----------------------------------------------------------------------------------------------------------------------------------
		If	ls_syntax_results <> 'none' and ls_syntax_criteria <> 'none' Then
			If ls_syntax_results <> '' And Not IsNull(ls_syntax_results) Then
				IF uo_search_contact_history.dw_report.Create (ls_syntax_results, l_sMsg) <> 1 Then
					uo_search_contact_history.dw_report.Create(is_results_syntax)
					uo_search_contact_history.dw_report.SetTransObject(SQLCA)
					uo_search_contact_history.dw_report.InsertRow(0)
					lb_error = TRUE
				Else
					uo_search_contact_history.dw_report.SetTransObject(SQLCA)
					lb_successful = TRUE
					
				End If
			End If
			
			If ls_syntax_criteria <> '' And Not IsNull(ls_syntax_criteria) And lb_error <> TRUE Then
				IF dw_criteria.Create (ls_syntax_criteria, l_sMsg) <> 1 Then
					dw_criteria.Create(is_original_criteria_syntax)
					dw_criteria.SetTransObject(SQLCA)
					dw_criteria.InsertRow(0)
					lb_error = TRUE
				Else
					dw_criteria.SetTransObject(SQLCA)
					lb_successful = TRUE
					
					of_retrieve_caseprop_dddws(i_wParentWindow.i_cSourceType, data)
					
					ll_row = dw_criteria.InsertRow(0)
					ll_return = dw_criteria.SetItem(ll_row, 'casetype', data)
				End If
			End If
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If no syntax was found or it wasn't created successfully, then create it normally.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If lb_successful <> TRUE Then 
			is_dynamic_columns[] = ls_nullarray[]
			of_build_case_properties()
			
			For i = 1 To UpperBound(i_wParentWindow.i_sContactHistoryField[])
				is_dynamic_columns[i] = i_wParentWindow.i_sContactHistoryField[i].column_name
			Next 
		End If		

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Call the function that will show/hide the columns based on the Table Maintenance entries
		//-----------------------------------------------------------------------------------------------------------------------------------
		of_hide_columns()

		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Clear the case preview after you rebuild the datawindows, to keep it from displaying the
		//	last case in the preview pane even though there are no rows in the search.
		//-----------------------------------------------------------------------------------------------------------------------------------
//???		dw_case_preview.fu_retrieve (c_IgnoreChanges, dw_case_history.c_NoRefreshChildren)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Reset the category when the Case Type is changed.
		//-----------------------------------------------------------------------------------------------------------------------------------
		is_categoryID = '' 	
		dw_criteria.SetItem(1, 'category_id', '')
		

	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the retrieve Function.
//-----------------------------------------------------------------------------------------------------------------------------------
THIS.AcceptText()
of_retrieve()

end event

type uo_search_contact_history from u_search_contacthistory within u_contact_history
integer x = 5
integer height = 1556
integer taborder = 30
end type

on uo_search_contact_history.destroy
call u_search_contacthistory::destroy
end on

event constructor;call super::constructor;this.i_wParentWindow = i_Window
end event

type st_case_preview from statictext within u_contact_history
boolean visible = false
integer x = 27
integer y = 972
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Preview:"
boolean focusrectangle = false
end type

type st_case_list from statictext within u_contact_history
boolean visible = false
integer x = 23
integer y = 4
integer width = 741
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case List:"
boolean focusrectangle = false
end type

type st_noaccess from statictext within u_contact_history
boolean visible = false
integer x = 1234
integer y = 1252
integer width = 1111
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Access denied to the details of this case."
boolean focusrectangle = false
end type

type st_nonotes from statictext within u_contact_history
boolean visible = false
integer x = 1353
integer y = 1252
integer width = 869
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "There are no notes for this case."
boolean focusrectangle = false
end type

