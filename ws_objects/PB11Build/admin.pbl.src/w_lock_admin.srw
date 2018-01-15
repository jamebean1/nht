$PBExportHeader$w_lock_admin.srw
forward
global type w_lock_admin from w_main_std
end type
type dw_lock_parms from u_dw_search within w_lock_admin
end type
type cb_removelocks from commandbutton within w_lock_admin
end type
type ddlb_lock_records from dropdownlistbox within w_lock_admin
end type
type dw_locks from u_dw_std within w_lock_admin
end type
type gb_searchparams from groupbox within w_lock_admin
end type
type gb_searchtype from groupbox within w_lock_admin
end type
end forward

global type w_lock_admin from w_main_std
integer height = 1568
string title = "Locked Records Administration"
string menuname = "m_lock_admin"
boolean maxbox = false
boolean toolbarvisible = true
dw_lock_parms dw_lock_parms
cb_removelocks cb_removelocks
ddlb_lock_records ddlb_lock_records
dw_locks dw_locks
gb_searchparams gb_searchparams
gb_searchtype gb_searchtype
end type
global w_lock_admin w_lock_admin

type variables

end variables

forward prototypes
public subroutine fw_sortdata ()
public subroutine fw_clearsearch ()
end prototypes

public subroutine fw_sortdata ();/****************************************************************************************

	function:	fw_sortdata
	Purpose:		Sort the data in the dw_locks datawindow
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	3/15/2002 K. Claver    Created.
****************************************************************************************/
INT				l_nCounter, l_nAnotherCounter, l_nColumnCount
LONG				l_nSortError
S_ColumnSort	l_sSortData
STRING 			l_cTag, l_cSortString

l_nColumnCount = LONG(dw_locks.Describe("Datawindow.Column.Count")) 

FOR l_nCounter = 1 to l_nColumnCount
	l_cTag = dw_locks.Describe("#" + String(l_nCounter) + ".Tag")

	IF l_cTag <> '?' THEN
		l_nAnotherCounter ++
		l_sSortData.label_name[l_nAnotherCounter]  = l_cTag
		l_sSortData.column_name[l_nAnotherCounter] = dw_locks.Describe(&
			"#" + String(l_nCounter) + ".Name")
	END IF
NEXT

//Datawindow specific computed columns.  Add to this CHOOSE-CASE for other
//  lock types.
CHOOSE CASE Upper( dw_locks.DataObject )
	CASE "D_LOCKED_CASES"
		//Add the computed columns for correct sorting of the case number and rep
		l_nAnotherCounter ++
		l_sSortData.label_name[ l_nAnotherCounter ] = " Case Number"
		l_sSortData.column_name[ l_nAnotherCounter ] = "case_num_numeric"
		
		l_nAnotherCounter ++
		l_sSortData.label_name[ l_nAnotherCounter ] = " Locked By"
		l_sSortData.column_name[ l_nAnotherCounter ] = "cc_locked_by"
END CHOOSE

FWCA.MGR.fu_OpenWindow(w_sort_order, 0, l_sSortData)

l_cSortString = Message.StringParm

IF l_cSortString <> '' THEN
	l_nSortError = dw_locks.SetSort(l_cSortString)
	l_nSortError = dw_locks.Sort()
END IF

end subroutine

public subroutine fw_clearsearch ();/****************************************************************************************

	function:	fw_clearsearch
	Purpose:		Clear the search criteria and results datawindow
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	3/15/2002 K. Claver    Created.
****************************************************************************************/
dw_lock_parms.fu_Reset( )
dw_locks.fu_Reset( dw_locks.c_IgnoreChanges )
end subroutine

on w_lock_admin.create
int iCurrent
call super::create
if this.MenuName = "m_lock_admin" then this.MenuID = create m_lock_admin
this.dw_lock_parms=create dw_lock_parms
this.cb_removelocks=create cb_removelocks
this.ddlb_lock_records=create ddlb_lock_records
this.dw_locks=create dw_locks
this.gb_searchparams=create gb_searchparams
this.gb_searchtype=create gb_searchtype
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lock_parms
this.Control[iCurrent+2]=this.cb_removelocks
this.Control[iCurrent+3]=this.ddlb_lock_records
this.Control[iCurrent+4]=this.dw_locks
this.Control[iCurrent+5]=this.gb_searchparams
this.Control[iCurrent+6]=this.gb_searchtype
end on

on w_lock_admin.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lock_parms)
destroy(this.cb_removelocks)
destroy(this.ddlb_lock_records)
destroy(this.dw_locks)
destroy(this.gb_searchparams)
destroy(this.gb_searchtype)
end on

event open;call super::open;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    Please see PowerClass documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/2002 K. Claver   Added function call to set the options for the window.
*****************************************************************************************/
THIS.fw_SetOptions( THIS.c_NoEnablePopup+THIS.c_AutoPosition+THIS.c_ToolBarTop )

//Select the first record in the drop down list box
ddlb_lock_records.SelectItem( 1 )
//Trigger this event to ensure that any drop down datawindows are populated
ddlb_lock_records.Event Trigger SelectionChanged( 1 )
end event

type dw_lock_parms from u_dw_search within w_lock_admin
event ue_selecttrigger pbm_dwnprocessenter
integer x = 46
integer y = 288
integer width = 1920
integer height = 184
integer taborder = 30
string dataobject = "d_locked_case_parms"
boolean border = false
end type

event ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Trigger the search when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	3/15/2002 K. Claver    Created
****************************************************************************************/
m_lock_admin.m_file.m_search.Event Trigger clicked( )

end event

type cb_removelocks from commandbutton within w_lock_admin
integer x = 1550
integer y = 1256
integer width = 439
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Remove Locks"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/2002 K. Claver   Added function call to remove the locks for the selected records
*****************************************************************************************/
dw_locks.Event Trigger ue_RemoveLocks( )
end event

type ddlb_lock_records from dropdownlistbox within w_lock_admin
integer x = 46
integer y = 76
integer width = 667
integer height = 400
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
string item[] = {"Cases"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;/*****************************************************************************************
   Event:      SelectionChanged
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/2002 K. Claver   Added code to swap the datawindows depending on the choice made
*****************************************************************************************/
DataWindowChild l_dwcUsers

//Swap out the datawindows depending on the lock scheme chosen.  This
//  CHOOSE-CASE should be added to for new locking schemes.
CHOOSE CASE Upper( THIS.Text )
	CASE "CASES"
		//Params window inherited from u_dw_search so can't use fu_swap( )
		dw_lock_parms.DataObject = "d_locked_case_parms"
		dw_lock_parms.InsertRow( 0 )
		
		//Get the users child datawindow and populate
		dw_lock_parms.GetChild( "locked_user_id", l_dwcUsers )
		l_dwcUsers.SetTransObject( SQLCA )
		l_dwcUsers.Retrieve( )
		
		//Swap the retrieval datawindow
		dw_locks.fu_Swap( "d_locked_cases", &
								dw_locks.c_IgnoreChanges, &
								dw_locks.c_DeleteOK+ &
								dw_locks.c_SelectOnRowFocusChange+ &
								dw_locks.c_MultiSelect+ &
								dw_locks.c_NoRetrieveOnOpen+ &
								dw_locks.c_NoEnablePopup+ &
								dw_locks.c_NoMenuButtonActivation )
								
END CHOOSE

dw_lock_parms.SetFocus( )
end event

type dw_locks from u_dw_std within w_lock_admin
event ue_removelocks ( )
event type integer ue_setcriteria ( )
integer x = 14
integer y = 496
integer width = 1984
integer height = 740
integer taborder = 10
string dataobject = "d_locked_cases"
borderstyle borderstyle = stylelowered!
end type

event ue_removelocks;/*****************************************************************************************
   Event:      ue_removelocks
   Purpose:    Event to remove locks for the lock type

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/2002 K. Claver   Created
*****************************************************************************************/
Boolean l_bAutoCommit
Long l_nSelectedRows[ ]
Integer l_nRowCount, l_nRV, l_nMessageRV

IF THIS.RowCount( ) > 0 THEN
	THIS.fu_GetSelectedRows( l_nSelectedRows )
	
	l_nRowCount = UpperBound( l_nSelectedRows )
	IF l_nRowCount > 0 THEN
		l_nMessageRV = MessageBox( gs_AppName, "Are you sure you want to remove the selected locks?~r~n"+ &
											"Users editing these locked records will not be able to~r~n"+ &
											"save their changes if another user acquires a lock on~r~n"+ &
											"the record!", Question!, YesNo! )
		
		IF l_nMessageRV = 1 THEN
			SetPointer( HourGlass! )
			
			l_nRV = THIS.fu_Delete( l_nRowCount, &
											l_nSelectedRows, &
											THIS.c_IgnoreChanges )
												 
			IF l_nRV <> 0 THEN
				MessageBox( gs_AppName, "Error encountered while attempting to delete the selected rows from the datawindow", &
								StopSign!, OK! )
			ELSE
				l_bAutoCommit = SQLCA.AutoCommit
				SQLCA.AutoCommit = FALSE
				
				l_nRV = THIS.fu_Save( THIS.c_SaveChanges )
				
				IF l_nRV <> 0 THEN
					ROLLBACK USING SQLCA;
					
					MessageBox( gs_AppName, "Error encountered while attempting to delete the selected rows from the database", &
									StopSign!, OK! )
									
					THIS.fu_Retrieve( THIS.c_IgnoreChanges, THIS.c_NoReselectRows )
				ELSE
					COMMIT USING SQLCA;
					
					IF THIS.RowCount( ) = 0 THEN
						cb_removelocks.Enabled = FALSE
						m_lock_admin.m_edit.m_deleteselectedcases.Enabled = FALSE
					END IF
				END IF
				
				SQLCA.AutoCommit = l_bAutoCommit
			END IF
			
			SetPointer( Arrow! )
		END IF
	ELSE
		MessageBox( gs_AppName, "There are no records selected to process", StopSign!, OK! )
	END IF
END IF

dw_lock_parms.SetFocus( )

end event

event ue_setcriteria;/*****************************************************************************************
   Event:      ue_setcriteria
   Purpose:    Set the where clause for the datawindow if necessary
	
	Returns:    INTEGER - 0 - Success
								 -1 - Error

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/2002 K. Claver   Created
*****************************************************************************************/
String l_cWhere = " WHERE ", l_cCaseNumber, l_cUserID, l_cSQLSelect
Integer l_nLockedTime

//Ensure the values are accepted into the datawindow
dw_lock_parms.AcceptText( )

//Set the where clause based on the data object.  Used as a result of not using the
//  PowerClass search functionality.  Add to this CHOOSE-CASE if cannot use the PowerClass
//  search functionality for your parameter datawindow.
CHOOSE CASE Upper( THIS.DataObject )
	CASE "D_LOCKED_CASES"
		l_cCaseNumber = Trim( dw_lock_parms.Object.case_number[ 1 ] )
		l_cUserID = Trim( dw_lock_parms.Object.locked_user_id[ 1 ] )
		l_nLockedTime = dw_lock_parms.Object.locked_time[ 1 ]
		
		//Case number
		IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
			IF Pos( l_cCaseNumber, "%" ) > 0 THEN
				l_cWhere += "case_number LIKE '"+l_cCaseNumber+"'"
			ELSE
				l_cWhere += "case_number = '"+l_cCaseNumber+"'"
			END IF
		END IF
		
		//Locked by
		IF NOT IsNull( l_cUserID ) AND Trim( l_cUserID ) <> "" THEN
			IF Trim( l_cWhere ) <> "WHERE" THEN
				l_cWhere += " AND "
			END IF
			
			IF Pos( l_cUserID, "%" ) > 0 THEN
				l_cWhere += "locked_by LIKE '"+l_cUserID+"'"
			ELSE
				l_cWhere += "locked_by = '"+l_cUserID+"'"
			END IF
		END IF
		
		//Locked for more than n minutes
		IF NOT IsNull( l_nLockedTime ) AND l_nLockedTime <> 0 THEN
			IF l_nLockedTime >= 10 THEN
				IF Trim( l_cWhere ) <> "WHERE" THEN
					l_cWhere += " AND "
				END IF
				
				l_cWhere += "( ( datediff( mi, locked_timestamp, getdate( ) ) > "+String( l_nLockedTime )+" ) OR "+ &
								"( datediff( mi, locked_timestamp, getdate( ) ) = "+String( l_nLockedTime )+" AND "+ &
								"  datepart( ss, locked_timestamp ) < datepart( ss, getdate( ) ) ) )"
			ELSE
				MessageBox( gs_AppName, "The lower bound for lock time is 10 minutes.  Please correct to continue", &
								StopSign!, OK! )
				RETURN -1
			END IF
		END IF
		
		//Replace the sql in the datawindow
		IF Trim( l_cWhere ) <> "WHERE" THEN
			l_cSQLSelect = THIS.Object.DataWindow.Table.Select
			IF NOT IsNull( l_cSQLSelect ) AND Trim( l_cSQLSelect ) <> "" THEN
				//If the datawindow already has a where clause, replace "WHERE" with "AND"
				IF Pos( Upper( l_cSQLSelect ), "WHERE" ) > 0 THEN
					l_cWhere = Replace( l_cWhere, Pos( Upper( l_cWhere ), "WHERE" ), 5, "AND" )
				END IF
				
				l_cSQLSelect += l_cWhere
				THIS.Object.DataWindow.Table.Select = l_cSQLSelect
			END IF
		ELSE
			THIS.fu_Reset( THIS.c_IgnoreChanges )
			MessageBox( gs_AppName, "You must specify search criteria to perform a search", StopSign!, OK! )
			RETURN -1
		END IF
END CHOOSE
			
RETURN 0

end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Please see PowerClass documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/2002 K. Claver   Added function call to set the options for the datawindow.
*****************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
							THIS.c_NullDW, &
							THIS.c_DeleteOK+ &
							THIS.c_SelectOnRowFocusChange+ &
							THIS.c_MultiSelect+ &
							THIS.c_NoRetrieveOnOpen+ &
							THIS.c_NoEnablePopup+ &
							THIS.c_NoMenuButtonActivation )
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Please see PowerClass documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/2002 K. Claver   Added code to retrieve this datawindow depending on the dataobject
*****************************************************************************************/
Long l_nRows
String l_cOriginalSelect
Integer l_nRV

//Retrieve the datawindow based on the dataobject.  This CHOOSE-CASE should be added
//  to for different lock types if not using PowerClass search functionality.
CHOOSE CASE Upper( THIS.DataObject )
	CASE "D_LOCKED_CASES"
		//Get the original select to set back to after the search
		l_cOriginalSelect = THIS.Object.DataWindow.Table.Select
		
		l_nRV = THIS.Event Trigger ue_SetCriteria( )
		
		IF l_nRV <> -1 THEN
			l_nRows = THIS.Retrieve( )
			
			IF l_nRows = 0 THEN
				cb_removelocks.Enabled = FALSE
				m_lock_admin.m_edit.m_deleteselectedcases.Enabled = FALSE
				MessageBox( gs_AppName, "There are no records that meet your search criteria" )
			ELSE
				cb_removelocks.Enabled = TRUE
				m_lock_admin.m_edit.m_deleteselectedcases.Enabled = TRUE
			END IF
		ELSE
			cb_removelocks.Enabled = FALSE
			m_lock_admin.m_edit.m_deleteselectedcases.Enabled = FALSE
		END IF
		
		//Set the select back to the original
		THIS.Object.DataWindow.Table.Select = l_cOriginalSelect
END CHOOSE
		
end event

type gb_searchparams from groupbox within w_lock_admin
integer x = 14
integer y = 220
integer width = 1984
integer height = 264
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Parameters"
borderstyle borderstyle = stylelowered!
end type

type gb_searchtype from groupbox within w_lock_admin
integer x = 14
integer y = 8
integer width = 731
integer height = 196
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search For Locked"
borderstyle borderstyle = stylelowered!
end type

