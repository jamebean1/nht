$PBExportHeader$u_document_administration.sru
$PBExportComments$Document Administration
forward
global type u_document_administration from u_container_std
end type
type st_2 from statictext within u_document_administration
end type
type st_1 from statictext within u_document_administration
end type
type dw_outliner_groups from u_outliner_std within u_document_administration
end type
type rb_providers from radiobutton within u_document_administration
end type
type rb_groups from radiobutton within u_document_administration
end type
type cb_remove from commandbutton within u_document_administration
end type
type cb_add from commandbutton within u_document_administration
end type
type dw_outliner_doc_types from u_outliner_std within u_document_administration
end type
end forward

global type u_document_administration from u_container_std
integer width = 3570
integer height = 1592
boolean border = false
long backcolor = 79748288
st_2 st_2
st_1 st_1
dw_outliner_groups dw_outliner_groups
rb_providers rb_providers
rb_groups rb_groups
cb_remove cb_remove
cb_add cb_add
dw_outliner_doc_types dw_outliner_doc_types
end type
global u_document_administration u_document_administration

type variables
STRING	i_cDocID
STRING	i_cDocOwnID[]
STRING	i_cSourceType
STRING	i_cKey[]
STRING   i_cDataString[]
STRING   i_cHoldID[]
STRING	i_cSubjectID[]
STRING	i_cSubjectName[]
STRING   i_cSubjectKey[]

LONG		i_nNumAdd
LONG		i_nNumRemove
LONG		i_nSelectedRow[]

BOOLEAN	i_bDocSelected
BOOLEAN	i_bSourceSelected
BOOLEAN	i_bDocOwnSelected


end variables

forward prototypes
public subroutine fu_updatedeldisplay (integer level)
public subroutine fu_updateadddisplay (integer level)
public subroutine fu_retrievedoc ()
public subroutine fu_getselectedsources ()
public subroutine fu_sourceoutliner (string source_type)
end prototypes

public subroutine fu_updatedeldisplay (integer level);//*******************************************************************************************
//	 Event:     fu_updatedeldisplay
//	 Purpose:   Provide a single function to update the source tree view
//				
//	 Arguments: INTEGER	level - The level the Document is on
//	 Returns:   None
//	
//	 Date     Developer   Description
//	 -------- ----------- --------------------------------------------------------------------
//	 03/11/00 C. Jackson  Original Version
//  03/24/00 C. Jackson  Corrected logic for finding and selecting current row
//  08/07/00 C. Jackson  Correct Collapsing on delete
// 
//*******************************************************************************************


LONG		l_nRow, l_nSetRow
INTEGER	l_nLevels, l_nCounter
STRING	l_cKeys[]

// update data in the Groups outliner
l_nSetRow = dw_outliner_groups.fu_HLFindRow (i_cHoldID[1],1)
dw_outliner_groups.fu_HLClearSelectedRows ()
dw_outliner_groups.fu_HLSetSelectedRow (l_nSetRow)


end subroutine

public subroutine fu_updateadddisplay (integer level);//********************************************************************************************
//	 Event:     fu_updateadddisplay
//	 Purpose:   Provide a single function to update the source tree view
//				
//	 Arguments: INTEGER	level - The level the Document is on
//	 Returns:   None
//	
//	 Date     Developer   Description
//	 -------- ----------- ------------------------------------------------------------------
//	 03/11/00 C. Jackson  Original Version
//  03/24/00 C. Jackson  Correct logic for refresh and setting selected row
//  08/07/00 C. Jackson  Correct expanding and refresh
//  01/13/01 C. Jackson  Add ScrollToRow after all newly added rows have been expanded (SCR 1273)
//  10/18/01 C/ Jackson  Remove fu_HLRefresh, this is only meant for outliners retrieved from
//                       a database, used fu_HLCollapseBranch() and fu_HLExpandLevel() instead
//                       (SCR 1271)
// 
//********************************************************************************************

INTEGER	l_nSearchLevel
LONG		l_nSelectedRow, l_nIndex

// block screen updates until done
dw_outliner_groups.SetRedraw(FALSE)
dw_outliner_groups.Hide()

// determine the search level based on the source type
CHOOSE CASE i_cSourceType
	CASE 'E'
		l_nSearchLevel = 1
		
	CASE 'P'
		l_nSearchLevel = 2
		
END CHOOSE

// refresh all levels of the tree view
dw_outliner_groups.fu_HLCollapseBranch()
dw_outliner_groups.fu_HLExpandLevel()

// update the screen
dw_outliner_groups.Show()
dw_outliner_groups.SetRedraw(TRUE)


end subroutine

public subroutine fu_retrievedoc ();//************************************************************************************************
//
//  function: fu_RetrieveDoc
//  purpose:  to retrieve the document ownership userobject
//  
//  date     developer   description
//  -------- ----------- -------------------------------------------------------------------------
//  01/13/01 cjackson    original version
//  04/29/02 C. Jackson  Correct outliner logic
//  
//************************************************************************************************


// Set the options for dw_outliner_doc_types level 1
dw_outliner_doc_types.fu_HLRetrieveOptions(1, &
				"open.bmp", &
				"closed.bmp", &
            "cusfocus.document_types.doc_type_id", &
            " ", &
            "doc_type_desc", &
            "doc_type_desc", &
            "cusfocus.document_types", &
            "active='Y'" , &
            dw_outliner_doc_types.c_KeyString)

// Set the options for dw_outliner_doc_types level 2
dw_outliner_doc_types.fu_HLRetrieveOptions(2, &
				"", &
				"", &
            "cusfocus.documents.doc_id", &
            "cusfocus.documents.doc_type_id", &
            "doc_name", &
            "doc_name", &
            "cusfocus.documents", &
				"active = 'Y'", &
            dw_outliner_doc_types.c_KeyString)

dw_outliner_doc_types.fu_HLOptions (dw_outliner_doc_types.c_DrillDownOnClick + &
			dw_outliner_doc_types.c_HideBoxes + dw_outliner_doc_types.c_RetrieveAsNeeded)
			
dw_outliner_doc_types.fu_HLCreate(SQLCA,2)	

// Source checkbox is Employer_Group by default
fu_sourceoutliner('E')

i_cSourceType = 'E'

// Set cb_remove to disabled until a valid source is selected
cb_remove.Enabled = FALSE

// Turn re-draw back on (was set off in po_tabvalidate of w_table_maintenance
THIS.SetReDraw(TRUE)
THIS.Show()


end subroutine

public subroutine fu_getselectedsources ();/*****************************************************************************************
   Function:   fu_GetSelectedSources
   Purpose:    Populate the source arrays
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/06/01 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nSourceLevel, l_nRow, l_nLevel, l_nRowCount, l_nKeyCount, l_nPos
LONG		l_nNumAdd
STRING	l_cRowKeys[], l_cRowDesc

// determine the level of records to consider as sources
CHOOSE CASE i_cSourceType
	CASE 'E'
		l_nSourceLevel = 1
		
	CASE 'P'
		l_nSourceLevel = 2
		
END CHOOSE

// determine the list of selected sources
l_nRow = 1
l_nRowCount = dw_outliner_groups.RowCount ()
DO
	
	// find the next selected row
	l_nRow = dw_outliner_groups.fu_HLGetSelectedRow (l_nRow)
	IF l_nRow > 0 THEN
		
		// check if the current row is a valid source
		l_nLevel = dw_outliner_groups.fu_HLGetRowLevel (l_nRow)
		IF l_nLevel = l_nSourceLevel THEN
			
			// add this row to the selected source list
			l_nKeyCount = dw_outliner_groups.fu_HLGetRowKey (l_nRow, l_cRowKeys[])
			l_nNumAdd = l_nNumAdd + 1
			l_cRowDesc = dw_outliner_groups.fu_HLGetRowDesc(l_nRow)
			l_nPos = Pos (l_cRowDesc, ' - ')
			
			i_cSubjectKey[l_nNumAdd] = l_cRowKeys[l_nKeyCount]
			i_cSubjectName[l_nNumAdd] = TRIM (LEFT (l_cRowDesc, (l_nPos - 1)))
			
		END IF
		
		// Set to check the next row
		IF l_nRow < l_nRowCount THEN
			l_nRow ++
		ELSE
			l_nRow = 0
		END IF
			
	END IF
	
LOOP WHILE l_nRow > 0

i_nNumAdd = l_nNumAdd
end subroutine

public subroutine fu_sourceoutliner (string source_type);//****************************************************************************************
//
// 	Event:	fu_sourcecoutliner
// 	Purpose:	Set Up Retrieve options for the Source Outliner
//	
//	 Date     Developer    Description
//	 -------- ----------- -----------------------------------------------------------------
//	 03/08/00 C. Jackson   Original Version
//  08/02/00 C. Jackson   Add third level (provider type) to source outliner
//  08/02/00 C. Jackson   Add c_RetrieveAsNeeded and c_DeleteOnCollapse in fu_HLOptions
//  06/15/01 C. Jackson   Add provid_name_2 into the Provider outliner
//  07/20/01 C. Jackson   Add convert for building outliner
//  08/06/01 M. Caruso    Clear the list of selected IDs when tree view is reset.  Also
//								  established a common name/ID delimiter of ' - ' and removed
//								  the c_DrillDownOnClick option as it was not needed.
//  05/08/02 C. Jackson   Correct outliner creation (SCR 2820)
//****************************************************************************************

STRING	l_cKey, l_cDesc, l_cTable, l_cSourceType, l_cJoin, l_cProvidName, l_cEmpty[]

// clear the arrays that control the addition/removal of records
i_cSubjectKey[] = l_cEmpty[]
i_cDocOwnID[] = l_cEmpty[]

// set the new source type
l_cSourceType = source_type

// Set the options for dw_outliner_groups level 1 - Provider Type
CHOOSE CASE l_cSourceType
	CASE 'E'  // Employer Group
		// Set the options for dw_outliner_groups level 1
		dw_outliner_groups.fu_HLRetrieveOptions(1, &
				"open.bmp", &
				"closed.bmp", &
            "cusfocus.employer_group.group_id", & 
            " ", &
            "cusfocus.employer_group.employ_group_name + ' - ' + cusfocus.employer_group.group_id ", &
            "cusfocus.employer_group.employ_group_name + ' - ' + cusfocus.employer_group.group_id ", &
            "cusfocus.employer_group", & 
            "" , &
            dw_outliner_groups.c_KeyString)

		// Set the options for dw_outliner_groups level 2
		dw_outliner_groups.fu_HLRetrieveOptions(2, &
				"", &
				"", &
            "cusfocus.document_ownership.doc_ownership_id", & 
            "cusfocus.document_ownership.doc_subject_id", & 
            "cusfocus.documents.doc_name", &
            "cusfocus.documents.doc_name", &
            "cusfocus.document_ownership, cusfocus.documents", & 
            "cusfocus.document_ownership.doc_subject_id=cusfocus.employer_group.group_id AND " + & 
            "cusfocus.document_ownership.doc_source_type = 'E' AND " + & 
				"cusfocus.documents.doc_id = cusfocus.document_ownership.doc_id ", & 
            dw_outliner_groups.c_KeyString )
				
	CASE 'P' // Provider
		// Set the options for dw_outliner_groups level 1
		dw_outliner_groups.fu_HLRetrieveOptions(1, &				
				"open.bmp", &												
				"closed.bmp", &											
            "cusfocus.provider_types.provider_type", & 		
            " ", &														
            "cusfocus.provider_types.provid_type_desc", &		
            "cusfocus.provider_types.provid_type_desc", &		
            "cusfocus.provider_types", & 							
            "cusfocus.provider_types.active = 'Y' " , &		
            dw_outliner_groups.c_KeyString)
		
		// Set the options for dw_outliner_groups level 2
		l_cProvidName = "ISNULL(cusfocus.provider_of_service.provid_name, '') + ', ' + " + &
				          "ISNULL(cusfocus.provider_of_service.provid_name_2, '') + ' - ' + " + &
					       "ISNULL(cusfocus.provider_of_service.provider_id,'') "

		dw_outliner_groups.fu_HLRetrieveOptions(2, &
				"open.bmp", &	
				"closed.bmp", &	
            "convert(varchar(25),cusfocus.provider_of_service.provider_key)", & 
            "cusfocus.provider_of_service.provider_type", & 
            l_cProvidName, & 
            l_cProvidName, & 
            "cusfocus.provider_of_service", &  
            "cusfocus.provider_of_service.provider_type = cusfocus.provider_types.provider_type" , & 
            dw_outliner_groups.c_KeyString)

		// Set the options for dw_outliner_groups level 3
		dw_outliner_groups.fu_HLRetrieveOptions(3, &
				"", &
				"", &
            "cusfocus.document_ownership.doc_ownership_id", & 
            "convert(varchar(25),cusfocus.provider_of_service.provider_key)", & 
            "cusfocus.documents.doc_name", &
            "cusfocus.documents.doc_name", &
            "cusfocus.document_ownership, cusfocus.documents", & 
            "cusfocus.document_ownership.doc_subject_id=convert(varchar(25),cusfocus.provider_of_service.provider_key) AND " + & 
            "cusfocus.document_ownership.doc_source_type = 'P' AND " + & 
 				"cusfocus.documents.doc_id = cusfocus.document_ownership.doc_id ", & 
            dw_outliner_groups.c_KeyString )



END CHOOSE

//dw_outliner_groups.fu_HLOptions (dw_outliner_groups.c_DrillDownOnClick + dw_outliner_groups.c_MultiSelect + &
//	dw_outliner_groups.c_HideBoxes  + dw_outliner_groups.c_DeleteOnCollapse + dw_outliner_groups.c_RetrieveAsNeeded )
dw_outliner_groups.fu_HLOptions (dw_outliner_groups.c_MultiSelect + dw_outliner_groups.c_HideBoxes + &
											dw_outliner_groups.c_DeleteOnCollapse + dw_outliner_groups.c_RetrieveAsNeeded )

CHOOSE CASE l_cSourceType
	CASE 'E'  // Employer Group
		dw_outliner_groups.fu_HLCreate(SQLCA,2)				
	CASE 'P'
		dw_outliner_groups.fu_HLCreate(SQLCA,3)
END CHOOSE




end subroutine

on u_document_administration.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.dw_outliner_groups=create dw_outliner_groups
this.rb_providers=create rb_providers
this.rb_groups=create rb_groups
this.cb_remove=create cb_remove
this.cb_add=create cb_add
this.dw_outliner_doc_types=create dw_outliner_doc_types
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_outliner_groups
this.Control[iCurrent+4]=this.rb_providers
this.Control[iCurrent+5]=this.rb_groups
this.Control[iCurrent+6]=this.cb_remove
this.Control[iCurrent+7]=this.cb_add
this.Control[iCurrent+8]=this.dw_outliner_doc_types
end on

on u_document_administration.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_outliner_groups)
destroy(this.rb_providers)
destroy(this.rb_groups)
destroy(this.cb_remove)
destroy(this.cb_add)
destroy(this.dw_outliner_doc_types)
end on

event pc_setoptions;call super::pc_setoptions;//*******************************************************************************************
//
//	 Event:   pc_setoptions
//	 Purpose: To initialize the user object 
//	
//	 Date     Developer   Description
//	 -------- ----------- -------------------------------------------------------------------
//	 03/08/00 C. Jackson  Original Version
//  08/08/00 C. Jackson  Add c_RetrieveAsNeeded to fu_HLOptions for dw_outliner_doc_types
//  01/13/01 C. Jackosn  Move to po_tabclicked
//
//*******************************************************************************************


//// Set the options for dw_outliner_doc_types level 1
//dw_outliner_doc_types.fu_HLRetrieveOptions(1, &
//				"open.bmp", &
//				"closed.bmp", &
//            "cusfocus.document_types.doc_type_id", &
//            " ", &
//            "doc_type_desc", &
//            "doc_type_desc", &
//            "cusfocus.document_types", &
//            "active='Y'" , &
//            dw_outliner_doc_types.c_KeyString)
//
//// Set the options for dw_outliner_doc_types level 2
//dw_outliner_doc_types.fu_HLRetrieveOptions(2, &
//				"", &
//				"", &
//            "cusfocus.documents.doc_id", &
//            "cusfocus.document_types.doc_type_id", &
//            "doc_name", &
//            "doc_name", &
//            "cusfocus.documents", &
//            "cusfocus.documents.doc_type_id=cusfocus.document_types.doc_type_id", &
//            dw_outliner_doc_types.c_KeyString)
//				
//				
//dw_outliner_doc_types.fu_HLOptions (dw_outliner_doc_types.c_DrillDownOnClick + &
//			dw_outliner_doc_types.c_HideBoxes + dw_outliner_groups.c_RetrieveAsNeeded)
//			
//dw_outliner_doc_types.fu_HLCreate(SQLCA,2)	
//
//// Source checkbox is Employer_Group by default
//fu_sourceoutliner('E')
//i_cSourceType = 'E'
//
//
//// Set cb_remove to disabled until a valid source is selected
//cb_remove.Enabled = FALSE
//
//
end event

type st_2 from statictext within u_document_administration
integer x = 2098
integer width = 274
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
string text = "Source:"
boolean focusrectangle = false
end type

type st_1 from statictext within u_document_administration
integer x = 73
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documents:"
boolean focusrectangle = false
end type

type dw_outliner_groups from u_outliner_std within u_document_administration
integer x = 2126
integer y = 148
integer width = 1399
integer height = 1404
integer taborder = 30
borderstyle borderstyle = stylelowered!
end type

event po_pickedrow;//***********************************************************************************************
//
//  Event:   po_pickedrow
//	 Purpose: get row information
//	 
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//	 03/08/00 C. Jackson  Original Version
//  03/24/00 C. Jackson  Added logic to reset selected row
//  01/12/00 C. Jackson  Changed from i_cDocOwnID[l_nNumRemove] = l_cDeleteKeys[l_nLevel]
//                       to i_cDocOwnID[l_nNumRemove] = l_cDeleteKeys[1] (SCR 1270)
//  08/06/01 M. Caruso   Moved code to the add or remove button clicked events.  Added code to
//								 set status of the command buttons.
//***********************************************************************************************

INTEGER	l_nSourceLevel, l_nDocLevel


CHOOSE CASE i_cSourceType
	CASE 'E'
		l_nSourceLevel = 1
		l_nDocLevel = 2
		
	CASE 'P'
		l_nSourceLevel = 2
		l_nDocLevel = 3
		
END CHOOSE

CHOOSE CASE clickedlevel
	CASE l_nSourceLevel
		cb_Add.Enabled = TRUE
		cb_Remove.Enabled = FALSE
		
	CASE l_nDocLevel
		cb_Add.Enabled = FALSE
		cb_Remove.Enabled = TRUE
		
	CASE ELSE
		cb_Add.Enabled = FALSE
		cb_Remove.Enabled = FALSE
		
END CHOOSE


end event

event po_rdoubleclicked;call super::po_rdoubleclicked;//
// Override and comment out.  We do no want rbuttondown capability
//
end event

event rbuttondown;call super::rbuttondown;//**********************************************************************************************
//
//  Event:   rbuttondown
//  Purpose: To open the Document Details Response window
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  08/07/00 C. Jackson  Original Version
//
//**********************************************************************************************

IF i_bDocOwnSelected THEN
	
	OpenWithParm(w_doc_details,i_cDocID)
	
END IF
end event

type rb_providers from radiobutton within u_document_administration
integer x = 2574
integer y = 64
integer width = 338
integer height = 72
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
string text = "Providers"
borderstyle borderstyle = stylelowered!
end type

event clicked;//****************************************************************************************
//
//		Event: 		clicked
//		Purpose:		To retrieve Providers.
//
//***************************************************************************************/

// Re-retrieve the outliner datawindow for Providers
fu_sourceoutliner('P')
i_cSourceType = 'P'

end event

type rb_groups from radiobutton within u_document_administration
integer x = 2158
integer y = 64
integer width = 320
integer height = 72
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
string text = "Groups"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//****************************************************************************************
//
//		Event: 		clicked
//		Purpose:		To retrieve Groups.
//
//***************************************************************************************/

// Re-retrieve the outliner datawindow for Groups
fu_sourceoutliner('E')
i_cSourceType = 'E'

end event

type cb_remove from commandbutton within u_document_administration
integer x = 1586
integer y = 584
integer width = 411
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "<<"
end type

event clicked;call super::clicked;//****************************************************************************************
//	 Event:	cb_remove
//	 Purpose:	Remove Documents to the Selected Groups or Providers
//	
//  Date     Developer    Description
//  -------- ----------- --------------------------------------------------------------------
//  03/08/00 C. Jackson   Original Version
//  03/24/00 C. Jackson   Removed refresh
//  11/10/00 C. Jackson   Correct messagebox - was Messagebox(String(SQLCA.SQLDBCode), 
//                        SQLCA.SQLErrText) - too general.  Was displaying '3' in title
//                        bar and no text is some cases.
//  08/06/01 M. Caruso    Cleaned up the code.
//*******************************************************************************************

LONG		l_nCount, l_nRow, l_nKeyCount, l_nLevel
STRING	l_cKeys[]

l_nRow = dw_outliner_groups.fu_HLGetSelectedRow (1)
IF l_nRow > 0 THEN

	// get the parent key of the first selected row
	l_nKeyCount = dw_outliner_groups.fu_HLGetRowKey (l_nRow, l_cKeys[])
	
		i_cHoldID[1] = l_cKeys[l_nKeyCount - 1]
	
		dw_outliner_groups.fu_HLDeleteSelectedRows (i_cDocOwnID[])
		i_nNumRemove = UpperBound (i_cDocOwnID[])
		
		// delete the selected rows from the database
		FOR l_nCount = 1 TO i_nNumRemove
			
			DELETE FROM cusfocus.document_ownership 
			 WHERE doc_ownership_id = :i_cDocOwnID[l_nCount];
			 
			IF SQLCA.SQLCODE <> 0 THEN
				MessageBox(gs_appname, 'Unable to delete all of the selected records. See your system administrator.')
				ROLLBACK;
			ELSE
				COMMIT;
			END IF
			
		NEXT
		
		fu_updatedeldisplay (2)
		
		
		l_nRow = dw_outliner_groups.fu_HLGetSelectedRow (1)
		l_nLevel = dw_outliner_groups.fu_HLGetRowLevel(l_nRow)   
	
		IF l_nLevel = 1 THEN
			this.enabled = FALSE
			cb_Add.Enabled = TRUE
			
		ELSE
			this.enabled = TRUE
		END IF		
		
		// Check to see if we have deleted the last document and need to disable this button
		IF dw_outliner_groups.fu_HLGetRowKey (l_nRow, l_cKeys[]) < 2 THEN
			THIS.Enabled = FALSE
		END IF
		
ELSE
		
	messagebox(gs_AppName,'Please select a valid document for deletion')

END IF
end event

type cb_add from commandbutton within u_document_administration
integer x = 1586
integer y = 444
integer width = 411
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = ">>"
end type

event clicked;//****************************************************************************************
//	
//  Event:   cb_add
//	 Purpose: Add Documents to the Selected Groups or Providers
//	
//	 Date     Developer    Description
//	 -------- -----------  ------------------------------------------------------------------
//	 03/08/00 C. Jackson   Original Version
//  03/24/00 C. Jackson   Added logic to not add duplicate documents
//  03/29/00 C. Jackson   Added messagebox if more than 50 records are selected
//  03/29/00 C. Jackson   Correct timestamp on l_dDateTime
//  06/30/00 C. Jackson   Correct the logic for getting the new primary key for the 
//                        document_ownership table to better handle locking.
//  07/31/00 C. Jackson   Add loop to find all the commas and the datastring coming from the 
//                        outliner (SCR 745)
//  08/03/00 C. Jackson   Correct fu_UpdateAddDisplay call to specify level 3
//  10/06/00 C. Jackson   Add call to fw_getkeyvalue for pk_id
//  07/16/01 C. Jackson   Correct for provider_id changes (SCR 2178)
//  08/06/01 M. Caruso    Cleaned up the code.
//*****************************************************************************************

STRING l_cUserID, l_cNewKey, l_cTempID
DATETIME l_dDateTime
LONG l_nReturn, l_nIndex

// verify that a document is selected...
IF IsNull (i_cDocID) OR i_cDocID = '' THEN
	MessageBox (gs_appname, 'You must select a document to assign.')
	RETURN
END IF

// get the selected sources to begin processing
fu_GetSelectedSources ()

// verify that at least one source is selected...
IF UpperBound (i_cSubjectKey[]) = 0 THEN
	MessageBox (gs_appname, 'To assign documents, you must select at least one source.')
	RETURN
END IF

// Make the user aware that processing too many at once may take a while
IF i_nNumAdd > 50 THEN
	l_nReturn = messagebox(gs_AppName,'This process may take a while.  ' + &
					'Do you wish to continue?',Question!, YesNo!, 1)
					
	IF l_nReturn = 2 THEN
		RETURN
	END IF
	
END IF

// create the document assignments
FOR l_nIndex = 1 TO i_nNumAdd
	
	// Check if this document assocition already exists
	SELECT doc_ownership_id INTO :l_cTempID
	  FROM cusfocus.document_ownership
	 WHERE doc_id = :i_cDocID
	 	AND doc_subject_id = :i_cSubjectKey[l_nIndex]
		AND doc_source_type = :i_cSourceType;
		
	IF SQLCA.SQLCode = 100 THEN
		
		// only create the new association if it does not exist
		l_cNewKey = w_table_maintenance.fw_getkeyvalue('document_ownership')
		
		INSERT INTO	 cusfocus.document_ownership
		VALUES (:l_cNewKey, :i_cDocID, :i_cSubjectKey[l_nIndex], &
				 :I_cSourceType, :i_cSubjectName[l_nIndex], :l_cUserID, :l_dDateTime)
		 USING SQLCA;
		
		IF SQLCA.SQLCode = 0 THEN
			COMMIT USING SQLCA;
		ELSE
			MessageBox (gs_AppName, "Unable to add document to the specified Source.")
		END IF
		
	END IF
	
NEXT

CHOOSE CASE i_cSourceType
	CASE 'E'
		fu_UpdateAddDisplay (2)
	CASE 'P'
		fu_UpdateAddDisplay (3)
		
END CHOOSE
end event

type dw_outliner_doc_types from u_outliner_std within u_document_administration
integer x = 46
integer y = 84
integer width = 1399
integer height = 1468
integer taborder = 10
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
end type

event po_pickedrow;call super::po_pickedrow;//****************************************************************************************
//	Event:	po_pickedrow
//	Purpose:	
//	
//	Revisions:
//	Date     Developer    Description
//	======== ============ ================================================================
//	03/08/00 C. Jackson   Original Version
// 02/28/02 C. Jackson   Set i_cDocID to null (SCR 2743)
//****************************************************************************************/

STRING	l_cKeys[]
LONG		l_nLevel, l_nRow

IF KeyDown(keyShift!) THEN
	l_nLevel = 1
	l_nRow = 1
END IF

IF KeyDown(keyControl!) THEN
	l_nLevel = 1
	l_nRow = 1
END IF

// If this event was trigger by another function/event then set defaults.
IF IsNull (clickedlevel) THEN
	l_nLevel = 1
	l_nRow = 1
ELSE
	l_nLevel = clickedlevel
	l_nRow = clickedrow
END IF

IF l_nLevel = 1 THEN
	i_bDocSelected = FALSE
	m_table_maintenance.m_file.m_viewdetails.Enabled = FALSE
	SetNull(i_cDocID)
	
ELSEIF l_nLevel = 2 THEN
	
	i_bDocSelected = TRUE
	m_table_maintenance.m_file.m_viewdetails.Enabled = TRUE
	fu_HLGetRowKey(l_nRow, l_cKeys[])
	Message.StringParm = l_cKeys[l_nLevel]
	i_cDocID = l_cKeys[l_nLevel]
	
END IF


end event

event po_rdoubleclicked;call super::po_rdoubleclicked;//
// Override and comment out.  We do no want rbuttondown capability
//
end event

event rbuttondown;call super::rbuttondown;//**********************************************************************************************
//
//  Event:   rbuttondown
//  Purpose: To open the Document Details Response window
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  08/07/00 C. Jackson  Original Version
//
//**********************************************************************************************

IF i_bDocSelected THEN
	
	OpenWithParm(w_doc_details,i_cDocID)
	
END IF
end event

