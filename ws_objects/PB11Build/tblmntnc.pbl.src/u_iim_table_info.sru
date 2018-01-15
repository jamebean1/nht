$PBExportHeader$u_iim_table_info.sru
$PBExportComments$Table Information Maintenance screen for the IIM-enabled Tables.
forward
global type u_iim_table_info from u_container_std
end type
type dw_detail_info from u_dw_std within u_iim_table_info
end type
type st_table_list from statictext within u_iim_table_info
end type
type dw_tree_view from u_outliner_std within u_iim_table_info
end type
type gb_details from groupbox within u_iim_table_info
end type
end forward

global type u_iim_table_info from u_container_std
integer width = 3579
integer height = 1592
boolean border = false
long backcolor = 79748288
dw_detail_info dw_detail_info
st_table_list st_table_list
dw_tree_view dw_tree_view
gb_details gb_details
end type
global u_iim_table_info u_iim_table_info

type variables
LONG		i_nItemID
end variables

forward prototypes
public subroutine fu_updatedisplay ()
public subroutine fu_addnewtable ()
public subroutine fu_deleteentry ()
public subroutine fu_addnewcolumn ()
end prototypes

public subroutine fu_updatedisplay ();/****************************************************************************************
	Event:		fu_updatedisplay
	Purpose:		Provide a single function to update the tree view whenever a
					change is made to an entry (insert, insert child, delete or edit).
				
	Arguments:	LONG		entry_id - The ID of the new entry
					INTEGER	level - The level of the new entry
	Returns:		NONE
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	8/30/99  M. Caruso     Created.
	3/16/00  M. Caruso     Removed retrieval of details at the end of the script.
****************************************************************************************/

LONG		l_nRow, l_nCursorRow, l_nEntryID
INTEGER	l_nLevels, l_nCounter, l_nRtn, l_nLevel
STRING	l_cKeys[]

dw_tree_view.SetRedraw (FALSE)
dw_tree_view.Hide ()

// first, update the data in the outliner object
dw_tree_view.fu_HLRefresh (0, dw_tree_view.c_NoReselectRows)

// get the item ID and level of the item to select
l_nCursorRow = dw_detail_info.GetRow ()
CHOOSE CASE dw_detail_info.dataobject
	CASE 'd_iim_table_info'
		l_nEntryID = dw_detail_info.GetItemNumber (l_nCursorRow, 'iim_table_id')
		l_nLevel = 1
		
	CASE 'd_iim_column_info'
		l_nEntryID = dw_detail_info.GetItemNumber (l_nCursorRow, 'iim_column_id')
		l_nLevel = 2
		
END CHOOSE

// Expand the branch leading to the specified row.
l_nRow = dw_tree_view.fu_HLFindRow (STRING (l_nEntryID), l_nLevel)
l_nLevels = dw_tree_view.fu_HLGetRowKey (l_nRow, l_cKeys[])

dw_tree_view.fu_HLCollapse (1)

FOR l_nCounter = 1 to l_nLevels
	l_nRow = dw_tree_view.fu_HLFindRow (l_cKeys[l_nCounter], l_nCounter)
	// collapse all subtrees of the current level
	IF l_nCounter > 1 THEN
		dw_tree_view.fu_HLCollapse (l_nCounter+1)
	END IF
	// expand only the appropriate branch
	IF l_nCounter < l_nLevels THEN
		dw_tree_view.i_ClickedRow = l_nRow
		dw_tree_view.fu_HLExpandBranch ()
	ELSE
		dw_tree_view.fu_HLSetSelectedRow (l_nRow)
		dw_tree_view.ScrollToRow (l_nRow)
	END IF
NEXT

dw_tree_view.fu_HLSetSelectedRow (l_nRow)

dw_tree_view.Show ()
dw_tree_view.SetRedraw (TRUE)
end subroutine

public subroutine fu_addnewtable ();/*****************************************************************************************
   Function:   fu_AddNewTable
   Purpose:    Add a new table in dw_tree_view
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/7/00   M. Caruso    Created.
	5/2/00   M. Caruso    Set i_nItemID = 0 to create a new record.
*****************************************************************************************/

// make sure the right datawindow object is active
IF dw_detail_info.dataobject = 'd_iim_column_info' THEN
	
	CHOOSE CASE dw_detail_info.fu_Save (c_PromptChanges)
		CASE 0
			dw_detail_info.dataobject = 'd_iim_table_info'
			dw_detail_info.SetTransObject (SQLCA)
			
		CASE -1
			RETURN
			
	END CHOOSE
			
END IF

// This will cause a blank row to be created.
i_nItemID = 0
dw_detail_info.fu_retrieve (dw_detail_info.c_promptchanges, dw_detail_info.c_noreselectrows)
end subroutine

public subroutine fu_deleteentry ();/****************************************************************************************
	Event:	fu_DeleteEntry
	Purpose:	Remove the selected entry from the database.  This function will delete an
				entry with children, but only if the user chooses to do so.
				
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	3/8/00   M. Caruso     Created
	5/2/00   M. Caruso     Set i_nItemID to the ID of the newly selected row after
								  deletion or set it to -1 if no rows exist.
****************************************************************************************/

LONG		l_nRow, l_nKey, l_nDeleteRows[]
INTEGER	l_nRtn, l_nNumLevels
STRING	l_cKeys[]

l_nRow = dw_tree_view.fu_HLGetSelectedRow (1)
l_nNumLevels = dw_tree_view.fu_HLGetRowKey (l_nRow, l_cKeys[])
l_nKey = LONG (l_cKeys[l_nNumLevels])

CHOOSE CASE l_nNumLevels
	CASE 1		// delete the table and it's subordinate columns
		l_nRtn = messagebox (gs_AppName, &
								"This process will also delete any columns defined~r~n" + &
								"for this table.  Do you wish to continue?", StopSign!, YesNo!)
		IF l_nRtn = 1 THEN

			// remove the items from the tree view first
			dw_tree_view.fu_HLDeleteRow (l_nRow)
					
			DELETE FROM cusfocus.iim_columns WHERE iim_table_id = :l_nKey USING SQLCA;
			CHOOSE CASE SQLCA.SQLCode
				CASE -1
					messagebox (gs_AppName,"Unable to delete the associated columns. " + &
									"The selected table cannot be deleted.")
					
				CASE 0
					// continue
					COMMIT USING SQLCA;
					DELETE FROM cusfocus.iim_tables WHERE iim_table_id = :l_nKey USING SQLCA;
					CHOOSE CASE SQLCA.SQLCode
						CASE -1
							messagebox (gs_AppName,"Unable to delete the selected table.")
							
						CASE 0
							// continue
							COMMIT USING SQLCA;
							l_nRow = dw_tree_view.GetRow ()
							IF l_nRow > 0 THEN
								dw_tree_view.fu_HLSetSelectedRow (l_nRow)

								// update the detail view with the newly selected record info.
								l_nNumLevels = dw_tree_view.fu_HLGetRowKey (l_nRow, l_cKeys[])
								i_nItemID = LONG (l_cKeys[l_nNumLevels])
							ELSE
								i_nItemID = -1
							END IF
							dw_detail_info.fu_retrieve (dw_detail_info.c_ignorechanges, dw_detail_info.c_noreselectrows)
							
						CASE 100
							messagebox (gs_AppName,"Unable to find the selected table.")
							
					END CHOOSE
					
				CASE 100
					messagebox (gs_AppName,"Unable to find any associated columns.")
					
			END CHOOSE
					
		END IF
		
	CASE 2		// delete the selected column
		// continue
		
		// delete the row from the tree view first
		dw_tree_view.fu_HLDeleteRow (l_nRow)
		
		DELETE FROM cusfocus.iim_columns WHERE iim_column_id = :l_nKey USING SQLCA;
		CHOOSE CASE SQLCA.SQLCode
			CASE -1
				messagebox (gs_AppName,"Unable to delete the selected column.")
				
			CASE 0
				// continue
				COMMIT USING SQLCA;
				l_nRow = dw_tree_view.GetRow ()
				dw_tree_view.fu_HLSetSelectedRow (l_nRow)

				// update the detail view with the newly selected record info.
				l_nNumLevels = dw_tree_view.fu_HLGetRowKey (l_nRow, l_cKeys[])
				IF l_nNumLevels = 1 THEN
					
					dw_detail_info.dataobject = 'd_iim_table_info'
					dw_detail_info.SetTransObject (SQLCA)
					
				END IF
				i_nItemID = LONG (l_ckeys[l_nNumLevels])
				dw_detail_info.fu_retrieve (dw_detail_info.c_ignorechanges, dw_detail_info.c_noreselectrows)
				
			CASE 100
				messagebox (gs_AppName,"Unable to find the selected column.")
				
		END CHOOSE
		
END CHOOSE
end subroutine

public subroutine fu_addnewcolumn ();/*****************************************************************************************
   Function:   fu_AddNewColumn
   Purpose:    Add a new column under the appropriate table in dw_tree_view
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/7/00   M. Caruso    Created.
	5/2/00   M. Caruso    Set i_nItemID = 0 to create a new record.  Swap datawindow before
								 checking row count in tree view.
*****************************************************************************************/

LONG		l_nRow, l_nTableID
STRING	l_cKeys[]

// make sure the right datawindow object is active
IF dw_detail_info.dataobject = 'd_iim_table_info' THEN
	
	CHOOSE CASE dw_detail_info.fu_Save (c_PromptChanges)
		CASE 0
			IF dw_tree_view.RowCount () > 0 THEN
				dw_detail_info.dataobject = 'd_iim_column_info'
				dw_detail_info.SetTransObject (SQLCA)
			END IF
			
		CASE -1
			RETURN
			
	END CHOOSE
	
END IF

// you cannot add a column if no tables are defined
IF dw_tree_view.RowCount () > 0 THEN

	// This will cause a blank row to be created.
	i_nItemID = 0
	dw_detail_info.fu_retrieve (dw_detail_info.c_promptchanges, dw_detail_info.c_noreselectrows)

ELSE
	
	messagebox (gs_AppName,'You must define a table before you can create columns.')
	
END IF
end subroutine

on u_iim_table_info.create
int iCurrent
call super::create
this.dw_detail_info=create dw_detail_info
this.st_table_list=create st_table_list
this.dw_tree_view=create dw_tree_view
this.gb_details=create gb_details
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail_info
this.Control[iCurrent+2]=this.st_table_list
this.Control[iCurrent+3]=this.dw_tree_view
this.Control[iCurrent+4]=this.gb_details
end on

on u_iim_table_info.destroy
call super::destroy
destroy(this.dw_detail_info)
destroy(this.st_table_list)
destroy(this.dw_tree_view)
destroy(this.gb_details)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    Initialize the tree view control

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/6/00   M. Caruso    Created.
*****************************************************************************************/

dw_tree_view.fu_HLOptions (dw_tree_view.c_DrillDownOnClick + dw_tree_view.c_HideBoxes)

dw_tree_view.fu_HLRetrieveOptions (1,"opencab.bmp","closedcab.bmp", &
				"cusfocus.iim_tables.iim_table_id","","cusfocus.iim_tables.iim_table_name", &
				"cusfocus.iim_tables.iim_table_name","cusfocus.iim_tables", &
				"",dw_tree_view.c_defaultvisual)
				
dw_tree_view.fu_HLRetrieveOptions (2,"folder.bmp","folder.bmp", &
				"cusfocus.iim_columns.iim_column_id","cusfocus.iim_columns.iim_table_id", &
				"cusfocus.iim_columns.iim_column_name", "cusfocus.iim_columns.iim_column_id", &
				"cusfocus.iim_columns", "", &
				dw_tree_view.c_defaultvisual)
				
dw_tree_view.fu_HLCreate (SQLCA, 2)
IF dw_tree_view.RowCount () > 0 THEN

	dw_tree_view.fu_HLSetSelectedRow (1)
	
END IF

// set error messages
OBJCA.MSG.fu_AddMessage ("iim2_not_found","<application_name>", &
				"The details for the selected %1s were not found.", &
				OBJCA.MSG.c_MSG_None, OBJCA.MSG.c_MSG_OK, 1, OBJCA.MSG.c_Enabled)
				
OBJCA.MSG.fu_AddMessage ("iim_table_add_failed","<application_name>", &
				"Unable to add a new table:~r~n%1s", OBJCA.MSG.c_MSG_None, &
				OBJCA.MSG.c_MSG_OK, 1, OBJCA.MSG.c_Enabled)
				
OBJCA.MSG.fu_AddMessage ("iim_column_add_failed","<application_name>", &
				"Unable to add a new column:~r~n%1s", OBJCA.MSG.c_MSG_None, &
				OBJCA.MSG.c_MSG_OK, 1, OBJCA.MSG.c_Enabled)
end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_close
   Purpose:    Remove the error messages defined for this container

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/6/00   M. Caruso    Created.
*****************************************************************************************/

OBJCA.MSG.fu_DeleteMessage ("iim2_not_found")
OBJCA.MSG.fu_DeleteMessage ("iim_table_add_failed")
OBJCA.MSG.fu_DeleteMessage ("iim_column_add_failed")
end event

type dw_detail_info from u_dw_std within u_iim_table_info
event ue_dropdown pbm_dwndropdown
integer x = 1701
integer y = 156
integer width = 1673
integer height = 1020
integer taborder = 20
string dataobject = "d_iim_table_info"
boolean border = false
end type

event ue_dropdown;/*****************************************************************************************
   Event:      ue_dropdown
   Purpose:    Refresh the dropdown datawindow when the list drops down.
   Parameters: NONE
   Returns:    LONG - ???

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/13/00  M. Caruso    Created.
*****************************************************************************************/

f_refreshdddw (THIS, GetRow (), GetColumnName ())
end event

event pcd_retrieve;call super::pcd_retrieve;/****************************************************************************************
	Event         : pcd_Retrieve
	Description   : Retrieve data from the database for this DataWindow.

	Parameters    : DATAWINDOW Parent_DW -
            	      Parent of this DataWindow.  If this 
                     DataWindow is root-level, this value will
                     be NULL.
	                LONG       Num_Selected -
                     The number of selected records in the
                     parent DataWindow.
                   LONG       Selected_Rows[] -
                     The row numbers of the selected records
                     in the parent DataWindow.

	Return Value  : Error.i_FWError -
                     c_Success - the event completed succesfully.
                     c_Fatal   - the event encountered an error.

	Change History:

	Date     Person     Description of Change
	-------- ---------- --------------------------------------------
	8/26/99  M. Caruso  Created.
	3/16/00  M. Caruso  Use instance variable i_nItemID as retrieval arg.
	5/2/00   M. Caruso  Only create a new record if the New button was
							  pressed (i_nItemID = 0).
****************************************************************************************/

LONG 		l_nRtn, l_nItemID, l_nRow, l_nTableID
INTEGER	l_nLevel
STRING	l_cKeys[]

l_nRtn = Retrieve (i_nItemID)

CHOOSE CASE l_nRtn
	CASE IS < 0
   	Error.i_FWError = c_Fatal
		
	CASE 0
		Error.i_FWError = c_Success
		IF i_nItemID = 0 THEN
		
			fu_New (1)
			CHOOSE CASE dataobject
				CASE "d_iim_table_info"
					SetItem (1, 'iim_table_name', '(New Table)')
					SetItem (1, 'iim_table_active', 'Y')
					SetColumn ('iim_table_name')
					
				CASE "d_iim_column_info"
					SetItem (1, 'iim_column_name', '(New Column)')
					SetItem (1, 'iim_column_active', 'Y')
					
					// get the ID of the parent table
					l_nRow = dw_tree_view.fu_HLGetSelectedRow (1)
					dw_tree_view.fu_HLGetRowKey (l_nRow, l_cKeys[])
					l_nTableID = LONG (l_cKeys[1])
					dw_detail_info.SetItem (1, 'iim_table_id', l_nTableID)
					SetColumn ('iim_column_name')
	
			END CHOOSE
			
		END IF
		SetFocus ()
		
	CASE IS > 0
		Error.i_FWError = c_Success
		
END CHOOSE
	
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    initialize the detail datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/6/00   M. Caruso    Created.
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_NewOK + c_ModifyOK + c_ModifyOnOpen + &
		c_NoMenuButtonActivation + c_NoRetrieveOnOpen + c_NoEnablePopup)
end event

event itemchanged;call super::itemchanged;/*****************************************************************************************
   Event:      itemchanged
   Purpose:    Update dw_dsn_info if the column selected is iim_source_id and the
					datawindow is showing table information.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/6/00   M. Caruso    Created.
	4/19/00  M. Caruso    Removed call to f_refreshdddw because it was interfering with
								 the normal keyboard operation of the dropdown datawindow.
*****************************************************************************************/

CHOOSE CASE dwo.Name
	CASE "iim_source_id", "iim_table_active", "iim_column_active"
		AcceptText ()

END CHOOSE
end event

event itemfocuschanged;call super::itemfocuschanged;/*****************************************************************************************
   Event:      itemfocuschanged
   Purpose:    Update the list of datasources when the appropriate column is selected.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/28/00   M. Caruso    Created.
*****************************************************************************************/

LONG					l_nDSNID
DWItemStatus		l_eStatus
DATAWINDOWCHILD	l_dwcDSNList

CHOOSE CASE dwo.name
	CASE 'iim_source_id'
		f_refreshdddw (THIS, row, 'iim_source_id')
		
END CHOOSE
end event

event pcd_new;/*****************************************************************************************
   Event:      pcd_new
   Purpose:    Override the ancestor script and perform a new insert method

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/28/00  M. Caruso    Created.
*****************************************************************************************/

IF Error.i_FWError = c_Success THEN
	
	CHOOSE CASE wparam
		CASE 1
			fu_addnewtable ()
				
		CASE 2
			fu_addnewcolumn ()
					
	END CHOOSE
	
END IF
end event

event pcd_savebefore;call super::pcd_savebefore;/*****************************************************************************************
   Event:      pcd_savebefore
   Purpose:    Validate the current detail information before allowing a save.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/28/00  M. Caruso    Created.
*****************************************************************************************/

LONG		l_nRow, l_nEntryID
STRING	l_cUserID
DATETIME	l_dtTimeStamp

IF i_CursorRow > 0 THEN
	
	CHOOSE CASE dataobject
		CASE 'd_iim_table_info'		// set values for table entry
			IF IsNull (dw_detail_info.GetItemNumber (1, "iim_source_id")) THEN
		
				messagebox (gs_AppName, &
								'You must specify a data source before this table can be saved.')
				dw_detail_info.SetColumn ('iim_source_id')
				dw_detail_info.SetFocus ()
				Error.i_FWError = c_Fatal
				
			ELSE
				
				l_nEntryID = GetItemNumber (i_CursorRow, 'iim_table_id')
				IF IsNull (l_nEntryID) THEN
					
					SELECT Max (iim_table_id) INTO :l_nEntryID FROM cusfocus.iim_tables USING SQLCA;
					IF IsNull (l_nEntryID) THEN
						l_nEntryID = 1
					ELSE
						l_nEntryID ++
					END IF
					SetItem (i_CursorRow, 'iim_table_id', l_nEntryID)
					
				END IF
				
				l_cUserID = OBJCA.WIN.fu_GetLogin (SQLCA)
				l_dtTimeStamp = w_table_maintenance.fw_GetTimeStamp ()
				dw_detail_info.SetItem (i_CursorRow, 'updated_by', l_cUserID)
				dw_detail_info.SetItem (i_CursorRow, 'updated_timestamp', l_dtTimeStamp)
				Error.i_FWError = c_Success
				
			END IF
			
		CASE 'd_iim_column_info'	// set values for column entry
			IF IsNull (dw_detail_info.GetItemString (1, "iim_column_type")) THEN
		
				messagebox (gs_AppName, &
								'You must specify a data type for this column before it can be saved.')
				dw_detail_info.SetColumn ('iim_column_type')
				dw_detail_info.SetFocus ()
				Error.i_FWError = c_Fatal
				
			ELSE
		
				l_nEntryID = GetItemNumber (i_CursorRow, 'iim_column_id')
				IF IsNull (l_nEntryID) THEN
					
					SELECT Max (iim_column_id) INTO :l_nEntryID FROM cusfocus.iim_columns USING SQLCA;
					IF IsNull (l_nEntryID) THEN
						l_nEntryID = 1
					ELSE
						l_nEntryID ++
					END IF
					SetItem (i_CursorRow, 'iim_column_id', l_nEntryID)
					
				END IF
				
				l_cUserID = OBJCA.WIN.fu_GetLogin (SQLCA)
				l_dtTimeStamp = w_table_maintenance.fw_GetTimeStamp ()
				dw_detail_info.SetItem (i_CursorRow, 'updated_by', l_cUserID)
				dw_detail_info.SetItem (i_CursorRow, 'updated_timestamp', l_dtTimeStamp)
				Error.i_FWError = c_Success
				
			END IF
			
	END CHOOSE
	
END IF
end event

event pcd_saveafter;call super::pcd_saveafter;/*****************************************************************************************
   Event:      pcd_saveafter
   Purpose:    Update the tree view after saving data

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/29/00  M. Caruso    Created.
*****************************************************************************************/

fu_UpdateDisplay ()
end event

type st_table_list from statictext within u_iim_table_info
integer x = 174
integer y = 64
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Table List"
boolean focusrectangle = false
end type

type dw_tree_view from u_outliner_std within u_iim_table_info
integer x = 165
integer y = 136
integer width = 1262
integer height = 1404
integer taborder = 10
borderstyle borderstyle = stylelowered!
end type

event po_pickedrow;call super::po_pickedrow;/****************************************************************************************
	Event:	po_pickedrow
	Purpose:	Retrieve the details of the selected row into the detail datawindow.
	
	Revisions:
	Date     Developer    Description
	======== ============ ================================================================
	2/15/00  M. Caruso    Created.
	3/16/00  M. Caruso    Set the new Entry ID in instance variable i_nItemID.  And if
	                      this event was triggered manually, set the row and level
								 manually.
****************************************************************************************/

STRING	l_cKeys[]
LONG		l_nLevel, l_nRow

// only process if row exist in the tree view
IF RowCount () > 0 THEN
	
	// If this event was trigger by another function/event then set defaults.
	IF IsNull (clickedlevel) THEN
		l_nRow = fu_HLGetSelectedRow (1)
		l_nLevel = fu_HLGetRowLevel (l_nRow)
	ELSE
		l_nLevel = clickedlevel
		l_nRow = clickedrow
	END IF
	
	// initialize the detail datawindow based on the type of item selected
	CHOOSE CASE l_nLevel
		CASE 1
			IF dw_detail_info.dataobject = "d_iim_column_info" THEN
				dw_detail_info.fu_save (dw_detail_info.c_PromptChanges)
				dw_detail_info.dataobject = "d_iim_table_info"
				dw_detail_info.SetTransObject (SQLCA)
			END IF
			
		CASE 2
			IF dw_detail_info.dataobject = "d_iim_table_info" THEN
				dw_detail_info.fu_save (dw_detail_info.c_PromptChanges)
				dw_detail_info.dataobject = "d_iim_column_info"
				dw_detail_info.SetTransObject (SQLCA)
			END IF
			
	END CHOOSE
	
	// Get the key of the Picked Row and view it's details
	fu_HLSetSelectedRow (l_nRow)
	fu_HLGetRowKey(l_nRow, l_cKeys[])
	i_nItemID = LONG (l_cKeys[l_nLevel])
	dw_detail_info.fu_retrieve(c_PromptChanges, c_NoReselectRows)
	
END IF
end event

type gb_details from groupbox within u_iim_table_info
integer x = 1641
integer y = 64
integer width = 1783
integer height = 1148
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detail Information"
borderstyle borderstyle = stylelowered!
end type

