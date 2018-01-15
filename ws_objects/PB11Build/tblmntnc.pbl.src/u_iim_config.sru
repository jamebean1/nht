$PBExportHeader$u_iim_config.sru
$PBExportComments$Container object for the maintenance of the Inquiry Information Module.
forward
global type u_iim_config from u_container_std
end type
type cb_define_detail from commandbutton within u_iim_config
end type
type cb_define_summary from commandbutton within u_iim_config
end type
type st_tabllist_label from statictext within u_iim_config
end type
type dw_tab_list from u_dw_std within u_iim_config
end type
type gb_tab_details from groupbox within u_iim_config
end type
type dw_tab_details from u_dw_std within u_iim_config
end type
end forward

global type u_iim_config from u_container_std
integer width = 3579
integer height = 1592
long backcolor = 79748288
cb_define_detail cb_define_detail
cb_define_summary cb_define_summary
st_tabllist_label st_tabllist_label
dw_tab_list dw_tab_list
gb_tab_details gb_tab_details
dw_tab_details dw_tab_details
end type
global u_iim_config u_iim_config

type variables
LONG			i_nMaxValue
LONG			i_nPrevRow
INTEGER		i_nTrIndex
BOOLEAN		i_bNew
TRANSACTION	i_trObjects[]
S_DWPAINTER_PARMS	i_sParms
end variables

on u_iim_config.create
int iCurrent
call super::create
this.cb_define_detail=create cb_define_detail
this.cb_define_summary=create cb_define_summary
this.st_tabllist_label=create st_tabllist_label
this.dw_tab_list=create dw_tab_list
this.gb_tab_details=create gb_tab_details
this.dw_tab_details=create dw_tab_details
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_define_detail
this.Control[iCurrent+2]=this.cb_define_summary
this.Control[iCurrent+3]=this.st_tabllist_label
this.Control[iCurrent+4]=this.dw_tab_list
this.Control[iCurrent+5]=this.gb_tab_details
this.Control[iCurrent+6]=this.dw_tab_details
end on

on u_iim_config.destroy
call super::destroy
destroy(this.cb_define_detail)
destroy(this.cb_define_summary)
destroy(this.st_tabllist_label)
destroy(this.dw_tab_list)
destroy(this.gb_tab_details)
destroy(this.dw_tab_details)
end on

event pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    Perform the initialization of this container object

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/28/00  M. Caruso    Created.
	3/14/00  M. Caruso	 Updated the error messages to be more user friendly.
*****************************************************************************************/

i_nTrIndex = 0

OBJCA.MSG.fu_AddMessage ("DSN_ERROR","<application_name>", &
								 gs_AppName+" was unable to retrieve information about " + &
								 "the data source.", OBJCA.MSG.c_MSG_None, OBJCA.MSG.c_MSG_OK, &
								 1, OBJCA.MSG.c_Enabled)
OBJCA.MSG.fu_AddMessage ("DSN_NOT_FOUND","<application_name>", &
								 "The selected data source was not found.",OBJCA.MSG.c_MSG_None, &
								 OBJCA.MSG.c_MSG_OK, 1, OBJCA.MSG.c_Enabled)
OBJCA.MSG.fu_AddMessage ("DSN_NOT_CONNECTED","<application_name>", &
								 gs_AppName+" was unable to connect to the data source.  Please~r~n" + &
								 "verify that the data source is valid and that the username and~r~n" + &
								 "password are correct.", OBJCA.MSG.c_MSG_None, OBJCA.MSG.c_MSG_OK, &
								 1, OBJCA.MSG.c_Enabled)
OBJCA.MSG.fu_AddMessage ("IIM_VERIFY_ARGS","<application_name>", &
								 "You must update any retrieval arguments for the defined view(s)~r~n" + &
								 "since the Source Type has been changed.  Otherwise, the views(s)~r~n" + &
								 "will not work properly.", OBJCA.MSG.c_MSG_None, OBJCA.MSG.c_MSG_OK, &
								 1, OBJCA.MSG.c_Enabled)
OBJCA.MSG.fu_AddMessage ("BLOB_ERROR","<application_name>", &
								 gs_AppName+" was unable to save the tab syntax.", &
								 OBJCA.MSG.c_MSG_None, OBJCA.MSG.c_MSG_OK, &
								 1, OBJCA.MSG.c_Enabled)
end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_close
   Purpose:    Perform object cleanup prior to closing

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/28/00  M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nIndex, l_nTrCount

OBJCA.MSG.fu_DeleteMessage ("DSN_ERROR")
OBJCA.MSG.fu_DeleteMessage ("DSN_NOT_FOUND")
OBJCA.MSG.fu_DeleteMessage ("DSN_NOT_CONNECTED")
OBJCA.MSG.fu_DeleteMessage ("IIM_VERIFY_ARGS")

// destroy the transaction object array
l_nTrCount = upperbound (i_trObjects[])
IF l_nTrCount > 0 THEN
	
	FOR l_nIndex = l_nTrCount TO 1 STEP -1
		
		DISCONNECT USING i_trObjects[l_nIndex];
		DESTROY i_trObjects[l_nIndex]
		
	NEXT
	
END IF
end event

type cb_define_detail from commandbutton within u_iim_config
integer x = 2688
integer y = 1304
integer width = 654
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Define Detail View"
end type

event clicked;/****************************************************************************************
	Event:	clicked
	Purpose:	Open the datawindow painter window
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	1/19/00  M. Caruso     Created.
	3/14/00  M. Caruso     Verify that the datasource was properly initialized before
								  allowing access to the datawindow painter.
	3/29/00  M. Caruso     Automatically save the tab details datawindow if the syntax
								  changes.
	4/5/00   M. Caruso     Added code to support arguments from multiple data sources.
	4/27/00  M. Caruso     Modified the font face and alignment for column labels to Arial
								  9 pt., right aligned.
	8/16/2000 K. Claver	  Added code to retrieve the datawindow syntax from a blob field
	1/16/2001 K. Claver    Added code to ensure a source type is selected before allowing
								  to create a view.
****************************************************************************************/

STRING				l_cDWSyntax, l_cError, l_cUserName, l_cMember, l_cProvider, l_cGroup
STRING				l_cOther
INTEGER				l_nDSNID, l_nIndex, l_nRV
LONG					l_nTabID
BLOB					l_bDetail
DATETIME				l_dtTimeStamp

//Check if the user has chosen a source type
l_cMember = dw_tab_details.Object.tab_available_member[ dw_tab_details.i_CursorRow ]
l_cProvider = dw_tab_details.Object.tab_available_provider[ dw_tab_details.i_CursorRow ]
l_cGroup = dw_tab_details.Object.tab_available_group[ dw_tab_details.i_CursorRow ]
l_cOther = dw_tab_details.Object.tab_available_other[ dw_tab_details.i_CursorRow ]

IF ( IsNull( l_cMember ) OR l_cMember = "N" ) AND &
	( IsNull( l_cProvider ) OR l_cProvider = "N" ) AND &
	( IsNull( l_cGroup ) OR l_cGroup = "N" ) AND &
	( IsNull( l_cOther ) OR l_cOther = "N" ) THEN
	MessageBox( gs_AppName, "Please select a Source Type", StopSign!, Ok! )
	RETURN
END IF

l_nDSNID = dw_tab_details.GetItemNumber (1, "iim_source_id")
	
// Create the DSN if necessary, or assign one that already exists
l_nIndex = f_AddDataSource (l_nDSNID, i_trObjects[], l_cError, TRUE)
CHOOSE CASE l_nIndex
	CASE -3
		// the painter will not be displayed because the user cancelled the DSN connect process.
		RETURN
		
	CASE -2
		OBJCA.MSG.fu_DisplayMessage ("DSN_NOT_FOUND")
		RETURN
	
	CASE -1
		OBJCA.MSG.fu_DisplayMessage ("DSN_ERROR")
		RETURN
		
	CASE 0
		i_sParms.trObject = SQLCA
		
	CASE ELSE
		IF Match (i_trObjects[l_nIndex].DbParm, "VOID") THEN
			// if the DSN was not properly connected, do not open the data view painter.
			RETURN
		ELSE
			i_sParms.trObject = i_trObjects[l_nIndex]
			IF l_nIndex <> i_nTrIndex THEN
				
				IF i_nTrIndex > 0 THEN
					DISCONNECT USING i_trObjects[i_nTrIndex];
				END IF
				i_nTrIndex = l_nIndex
				CONNECT USING i_trObjects[i_nTrIndex];
				IF i_trObjects[i_nTrIndex].SQLCode <> 0 THEN
					
					OBJCA.MSG.fu_DisplayMessage ("DSN_ERROR")
					RETURN
					
				END IF
				
			END IF
			
		END IF
		
END CHOOSE					  
						  
i_sParms.view_type = "detail"

IF i_sParms.detail_syntax = "" OR IsNull( i_sParms.detail_syntax ) THEN
	i_sParms.dwSyntax = ""
	//Set to empty string for string comparison below
	i_sParms.detail_syntax = ""
ELSE
	i_sParms.dwSyntax = i_sParms.detail_syntax
END IF

//Set the source type
i_sParms.a_cMembers = dw_tab_details.GetItemString (1, "tab_available_member")
i_sParms.a_cProviders = dw_tab_details.GetItemString (1, "tab_available_provider")
i_sParms.a_cGroups = dw_tab_details.GetItemString (1, "tab_available_group")
i_sParms.a_cOthers = dw_tab_details.GetItemString (1, "tab_available_other")

// open the datawindow painter
//FWCA.MGR.fu_OpenWindow (w_dw_painter, i_sParms)
FWCA.MGR.fu_OpenWindow (w_iim_dw_assoc, i_sParms)

// save the new syntax if the datawindow painter was not cancelled.
l_cDWSyntax = message.stringparm
IF Trim( l_cDWSyntax ) <> "" AND NOT IsNull( l_cDWSyntax ) THEN
	IF ( Trim( l_cDWSyntax ) <> Trim( i_sParms.summary_syntax ) ) THEN
		// Get the user ID and timestamp
		l_dtTimeStamp = w_table_maintenance.fw_GetTimeStamp()
		l_cUserName = OBJCA.WIN.fu_GetLogin(SQLCA)
	
		// set the required values
		dw_tab_details.SetItem (1, 'updated_by', l_cUserName)
		dw_tab_details.SetItem (1, 'updated_timestamp', l_dtTimeStamp)
	END IF	
	
	l_nRV = dw_tab_details.fu_save (dw_tab_details.c_SaveChanges)
	IF ( Trim( l_cDWSyntax ) <> Trim( i_sParms.detail_syntax ) ) AND &
		( l_nRV = 0 ) THEN
		l_nTabID = dw_tab_details.Object.tab_id[ 1 ]
		
		IF Trim( l_cDWSyntax ) = "D" THEN
			SetNull( l_cDWSyntax )
			SetNull( l_bDetail )
			
			////Begin embedded sql to set the blob field to null and the confidentiality level
			////  to null(USE THE l_cDWSyntax VARIABLE AS IT IS ALREADY NULL)
			UPDATE cusfocus.iim_tabs
			SET tab_detail_image = :l_bDetail,
				 detail_conf_level = :l_cDWSyntax
			WHERE tab_id = :l_nTabID
			USING SQLCA;
			////End embedded sql
			
			//Re-retrieve to display the cleared security level.
			dw_tab_details.fu_Retrieve( dw_tab_details.c_SaveChanges, dw_tab_details.c_NoReselectRows )
		ELSE	
			l_bDetail = Blob( Trim( l_cDWSyntax ) )
			
			////Begin embedded sql to update the detail syntax image
			UPDATEBLOB cusfocus.iim_tabs
			SET tab_detail_image = :l_bDetail
			WHERE tab_id = :l_nTabID
			USING SQLCA;
			////End embedded sql
		END IF		
	
		IF SQLCA.SQLCode < 0 THEN
			//Disable the security dropdown
			dw_tab_details.Object.detail_conf_level.Background.Color = String( RGB( 214, 211, 206 ) )
			dw_tab_details.Object.detail_conf_level.Protect = '1'
			
			OBJCA.MSG.fu_DisplayMessage ("BLOB_ERROR")
			RETURN
		ELSE
			i_sParms.detail_syntax = Trim( l_cDWSyntax )
			
			IF NOT IsNull( l_cDWSyntax ) AND Trim( l_cDWSyntax ) <> "" THEN
				//Enable the security dropdown
				dw_tab_details.Object.detail_conf_level.Background.Color = String( RGB( 255, 255, 255 ) )
				dw_tab_details.Object.detail_conf_level.Protect = '0'
			END IF
		END IF	
	END IF
END IF

dw_tab_details.SetFocus ()
end event

type cb_define_summary from commandbutton within u_iim_config
integer x = 1600
integer y = 1304
integer width = 654
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Define Summary View"
end type

event clicked;/****************************************************************************************
	Event:	clicked
	Purpose:	Open the datawindow painter window
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	1/19/00  M. Caruso     Created.
	2/28/00  M. Caruso     Added code to define a new transaction object if necessary to
								  create the datawindow syntax in the DW Painter.
	3/14/00  M. Caruso     Verify that the datasource was properly initialized before
								  allowing access to the datawindow painter.
	3/29/00  M. Caruso     Automatically save the tab detail datawindow if the syntax
								  has changed.
	4/5/00   M. Caruso     Added code to support arguments from multiple data sources.
	4/27/00  M. Caruso     Modified the font face and alignment for column labels to Arial
								  9 pt., left aligned.
	8/16/2000 K. Claver	  Added code to retrieve the datawindow syntax from a blob field
	1/16/2001 K. Claver    Added code to check for a source type before allowing to define
								  a view.
****************************************************************************************/

STRING				l_cDWSyntax, l_cError, l_cUserName, l_cMember, l_cProvider
STRING				l_cGroup, l_cOther
INTEGER				l_nDSNID, l_nIndex, l_nRV
LONG 					l_nTabID
BLOB					l_bSummary
DATETIME 			l_dtTimeStamp

//Check if the user has chosen a source type
l_cMember = dw_tab_details.Object.tab_available_member[ dw_tab_details.i_CursorRow ]
l_cProvider = dw_tab_details.Object.tab_available_provider[ dw_tab_details.i_CursorRow ]
l_cGroup = dw_tab_details.Object.tab_available_group[ dw_tab_details.i_CursorRow ]
l_cOther = dw_tab_details.Object.tab_available_other[ dw_tab_details.i_CursorRow ]

IF ( IsNull( l_cMember ) OR l_cMember = "N" ) AND &
	( IsNull( l_cProvider ) OR l_cProvider = "N" ) AND &
	( IsNull( l_cGroup ) OR l_cGroup = "N" ) AND &
	( IsNull( l_cOther ) OR l_cOther = "N" ) THEN
	MessageBox( gs_AppName, "Please select a Source Type", StopSign!, Ok! )
	RETURN
END IF

// build the parameters required for the datawindow painter
//i_sParms.presentation_style = "Style(type=grid) " + &
//			"Text(border=6 font.face='Arial' font.height=-9 font.weight=400 " + &
//				  "background.mode=0 background.color=12632256 alignment=0)"
										  
l_nDSNID = dw_tab_details.GetItemNumber (1, "iim_source_id")
	
// Create the DSN if necessary, or assign one that already exists
l_nIndex = f_AddDataSource (l_nDSNID, i_trObjects[], l_cError, TRUE)
CHOOSE CASE l_nIndex
	CASE -3
		// the painter will not be displayed because the user cancelled the DSN connect process.
		RETURN
		
	CASE -2
		OBJCA.MSG.fu_DisplayMessage ("DSN_NOT_FOUND")
		RETURN
	
	CASE -1
		OBJCA.MSG.fu_DisplayMessage ("DSN_ERROR")
		RETURN
		
	CASE 0
		i_sParms.trObject = SQLCA
		i_nTrIndex = l_nIndex
		
	CASE ELSE
		IF Match (i_trObjects[l_nIndex].DbParm, "VOID") THEN
			// if the DSN was not properly connected, do not open the data view painter.
			RETURN
		ELSE
			i_sParms.trObject = i_trObjects[l_nIndex]
			IF l_nIndex <> i_nTrIndex THEN
				
				IF i_nTrIndex > 0 THEN
					DISCONNECT USING i_trObjects[i_nTrIndex];
				END IF
				i_nTrIndex = l_nIndex
				CONNECT USING i_trObjects[i_nTrIndex];
				IF i_trObjects[i_nTrIndex].SQLCode <> 0 THEN
					
					OBJCA.MSG.fu_DisplayMessage ("DSN_ERROR")
					RETURN
					
				END IF
				
			END IF
			
		END IF
		
END CHOOSE

i_sParms.view_type = "summary"

IF i_sParms.summary_syntax = "" OR IsNull( i_sParms.summary_syntax ) THEN
	i_sParms.dwSyntax = ""
	//Set to empty string for string comparison below
	i_sParms.summary_syntax = ""
ELSE
	i_sParms.dwSyntax = i_sParms.summary_syntax
END IF

//Set the source type
i_sParms.a_cMembers = dw_tab_details.GetItemString (1, "tab_available_member")
i_sParms.a_cProviders = dw_tab_details.GetItemString (1, "tab_available_provider")
i_sParms.a_cGroups = dw_tab_details.GetItemString (1, "tab_available_group")
i_sParms.a_cOthers = dw_tab_details.GetItemString (1, "tab_available_other")

// open the datawindow painter
//FWCA.MGR.fu_OpenWindow (w_dw_painter, i_sParms)
FWCA.MGR.fu_OpenWindow (w_iim_dw_assoc, i_sParms)

// save the new syntax if the datawindow painter was not cancelled.
l_cDWSyntax = message.stringparm
IF l_cDWSyntax <> "" AND NOT IsNull( l_cDWSyntax ) THEN
	IF ( Trim( l_cDWSyntax ) <> Trim( i_sParms.summary_syntax ) ) THEN
		// Get the user ID and timestamp
		l_dtTimeStamp = w_table_maintenance.fw_GetTimeStamp()
		l_cUserName = OBJCA.WIN.fu_GetLogin(SQLCA)
	
		// set the required values
		dw_tab_details.SetItem (1, 'updated_by', l_cUserName)
		dw_tab_details.SetItem (1, 'updated_timestamp', l_dtTimeStamp)
	END IF	

	l_nRV = dw_tab_details.fu_save (dw_tab_details.c_SaveChanges)
	IF ( Trim( l_cDWSyntax ) <> Trim( i_sParms.summary_syntax ) ) AND &
		( l_nRV = 0 ) THEN
		l_nTabID = dw_tab_details.Object.tab_id[ 1 ]
		l_bSummary = Blob( Trim( l_cDWSyntax ) )
		////Begin embedded sql to update the summary syntax image
		UPDATEBLOB cusfocus.iim_tabs
		SET tab_summary_image = :l_bSummary
		WHERE tab_id = :l_nTabID
		USING SQLCA;
		////End embedded sql
	
		IF SQLCA.SQLCode < 0 THEN
			OBJCA.MSG.fu_DisplayMessage ("BLOB_ERROR")
			RETURN
		ELSE
			i_sParms.summary_syntax = Trim( l_cDWSyntax )
		END IF	
	END IF
	
	//Enable the security dropdown
	dw_tab_details.Object.summary_conf_level.Background.Color = String( RGB( 255, 255, 255 ) )
	dw_tab_details.Object.summary_conf_level.Protect = '0'
END IF

dw_tab_details.SetFocus ()
end event

type st_tabllist_label from statictext within u_iim_config
integer x = 73
integer y = 60
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
string text = "Defined Tabs"
boolean focusrectangle = false
end type

type dw_tab_list from u_dw_std within u_iim_config
integer x = 69
integer y = 136
integer width = 1275
integer height = 1404
integer taborder = 10
string dataobject = "d_tm_tab_list"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_setoptions;call super::pcd_setoptions;/****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Initialize dw_tab_list
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	1/18/00  M. Caruso     Created.
****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_MasterList + c_ModifyOnSelect + c_DeleteOK + c_NoEnablePopup)
end event

event pcd_retrieve;call super::pcd_retrieve;/****************************************************************************************
	Event         : pcd_Retrieve
	Description   : Retrieve data from the database for this
                   DataWindow.

	Parameters    : DATAWINDOW Parent_DW -
            	      Parent of this DataWindow.  If this 
                     DataWindow is root-level, this value will
                     be NULL.
                  LONG			Num_Selected -
                     The number of selected records in the
                     parent DataWindow.
                  LONG        Selected_Rows[] -
                     The row numbers of the selected records
                     in the parent DataWindow.

	Return Value  : Error.i_FWError -
                     c_Success - the event completed succesfully.
                     c_Fatal   - the event encountered an error.

	Change History:

	Date     Person     Description of Change
	-------- ---------- -------------------------------------------------------------------
   1/18/00  M. Caruso  Created.
****************************************************************************************/

LONG l_Rtn

l_Rtn = Retrieve()

CHOOSE CASE l_Rtn
	CASE IS < 0
   	Error.i_FWError = c_Fatal
	CASE 0
  		i_nMaxValue = 0
	CASE ELSE
		i_nMaxValue = GetItemNumber (1, "maxvalue")
		
END CHOOSE
end event

event pcd_delete;call super::pcd_delete;/****************************************************************************************
	Event:	pcd_delete
	Purpose:	Update the i_nMaxValue variable as tabs are deleted.
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	1/18/00  M. Caruso     Created.
	8/22/2001 K. Claver    Added code to disable the buttons if there are no more rows.
****************************************************************************************/

IF RowCount () > 0 THEN
	i_nMaxValue = GetItemNumber (1, "maxvalue")
ELSE
	i_nMaxValue = 0
	
	//Disable the buttons
	cb_define_detail.Enabled = FALSE
	cb_define_summary.Enabled = FALSE

END IF

// make sure the deleted row is deleted permanently.
fu_Save (c_SaveChanges)
end event

event pcd_save;call super::pcd_save;/****************************************************************************************
	Event:	pcd_save
	Purpose:	Set i_bNew to FALSE if the record was new.
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	3/9/00   M. Caruso     Created.
****************************************************************************************/

i_bNew = FALSE
end event

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Verify that a new tab definition is complete before allowing the row to
					change.  This script executes out of order, before the ancestor script, to
					properly handle data changes in the detail view.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/15/00  M. Caruso    Created.
*****************************************************************************************/

LONG		l_nTabID
STRING	l_cUserName
DATETIME	l_dtTimeStamp

// check if the selected row is about to change
IF row <> i_CursorRow THEN
	
	// if the detail information has unsaved changes, update it
	CHOOSE CASE dw_tab_details.GetItemStatus (dw_tab_details.i_CursorRow, 0, Primary!)
		CASE NewModified!
			// get the ID of the new tab
			SELECT Max (tab_id) INTO :l_nTabID FROM cusfocus.iim_tabs USING SQLCA;
			IF IsNull (l_nTabID) THEN
				l_nTabID = 1
			ELSE
				l_nTabID ++
			END IF
			
			// set the tab ID only if a new ID is assigned
			dw_tab_details.SetItem (dw_tab_details.i_CursorRow, "tab_id", l_nTabID)
			
			// Get the user ID and timestamp
			l_dtTimeStamp = w_table_maintenance.fw_GetTimeStamp()
			l_cUserName = OBJCA.WIN.fu_GetLogin(SQLCA)
			
			// set the required values
			dw_tab_details.SetItem (dw_tab_details.i_CursorRow, 'updated_by', l_cUserName)
			dw_tab_details.SetItem (dw_tab_details.i_CursorRow, 'updated_timestamp', l_dtTimeStamp)
			
		CASE DataModified!
			// Get the user ID and timestamp
			l_dtTimeStamp = w_table_maintenance.fw_GetTimeStamp()
			l_cUserName = OBJCA.WIN.fu_GetLogin(SQLCA)
			
			// set the required values
			dw_tab_details.SetItem (dw_tab_details.i_CursorRow, 'updated_by', l_cUserName)
			dw_tab_details.SetItem (dw_tab_details.i_CursorRow, 'updated_timestamp', l_dtTimeStamp)
			
	END CHOOSE
			
END IF
		
call super::clicked
end event

type gb_tab_details from groupbox within u_iim_config
integer x = 1426
integer y = 64
integer width = 2071
integer height = 1480
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
long textcolor = 33554432
long backcolor = 79741120
string text = "Tab Definition"
end type

type dw_tab_details from u_dw_std within u_iim_config
event ue_dropdown pbm_dwndropdown
integer x = 1573
integer y = 124
integer width = 1801
integer height = 1116
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_tm_tab_details"
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

event pcd_setoptions;call super::pcd_setoptions;/****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Initialize dw_tab_details
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	1/18/00  M. Caruso     Created.
****************************************************************************************/

fu_SetOptions (SQLCA, dw_tab_list, c_DetailEdit + c_NoEnablePopup)
end event

event pcd_retrieve;call super::pcd_retrieve;/****************************************************************************************
	Event         : pcd_Retrieve
	Description   : Retrieve data from the database for this
                   DataWindow.

	Parameters    : DATAWINDOW Parent_DW -
	         	      Parent of this DataWindow.  If this 
                     DataWindow is root-level, this value will
                     be NULL.
                  LONG        Num_Selected -
                     The number of selected records in the
                     parent DataWindow.
                  LONG        Selected_Rows[] -
                     The row numbers of the selected records
                     in the parent DataWindow.

	Return Value  : Error.i_FWError -
                     c_Success - the event completed succesfully.
                     c_Fatal   - the event encountered an error.

	Change History:

	Date     Person     Description of Change
	-------- ---------- ------------------------------------------------------------------
	1/18/00  M. Caruso  Created.
	8/16/2000 K. Claver Added an instance structure of i_sParms and removed from 
							  cb_define_detail.clicked event and cb_define_summary.clicked event.
							  Then moved population of structure variables to this event and 
							  added code to select the syntax blobs out of the database.
****************************************************************************************/

LONG					l_nRtn, l_nSelected, l_nSourceID, l_pos
BLOB 					l_bSummary, l_bDetail
INTEGER 				l_nIterations, l_nIndex
DATAWINDOWCHILD	l_dwcDataSources

This.SetRedraw (FALSE)

l_nSelected = parent_dw.GetItemNumber(selected_rows[1], "tab_id")

l_nRtn = Retrieve(l_nSelected)

CHOOSE CASE l_nRtn
	CASE IS < 0
   	Error.i_FWError = c_Fatal
		This.SetRedraw (TRUE)
		
	CASE IS > 0
		// filter the datasource list to include active datasources and the one that is selected (active or not)
		THIS.GetChild ('iim_source_id', l_dwcDataSources)
		l_nSourceID = THIS.GetItemNumber (1, 'iim_source_id')
		l_dwcDataSources.SetFilter ("iim_source_active = 'Y' OR iim_source_id = " + STRING (l_nSourceID))
		l_dwcDataSources.Filter ()
		
		This.SetRedraw (TRUE)
		
		// enable the order fields for the source types this tab is defined for
		IF GetItemString (1, "tab_available_member") = "Y" THEN
			THIS.Modify ("tab_order_member.Edit.DisplayOnly=no")
		ELSE
			THIS.Modify ("tab_order_member.Edit.DisplayOnly=yes")
		END IF
		
		IF GetItemString (1, "tab_available_provider") = "Y" THEN
			THIS.Modify ("tab_order_provider.Edit.DisplayOnly=no")
		ELSE
			THIS.Modify ("tab_order_provider.Edit.DisplayOnly=yes")
		END IF
		
		IF GetItemString (1, "tab_available_group") = "Y" THEN
			THIS.Modify ("tab_order_group.Edit.DisplayOnly=no")
		ELSE
			THIS.Modify ("tab_order_group.Edit.DisplayOnly=yes")
		END IF
		
		i_bNew = FALSE
		
		//Populate the structure
		i_sParms.a_cMembers = dw_tab_details.GetItemString (1, "tab_available_member")
		i_sParms.a_cProviders = dw_tab_details.GetItemString (1, "tab_available_provider")
		i_sParms.a_cGroups = dw_tab_details.GetItemString (1, "tab_available_group")
		i_sParms.a_cOthers = dw_tab_details.GetItemString (1, "tab_available_other")

		////Begin embedded sql to retrieve the summary syntax blob
		SELECTBLOB cusfocus.iim_tabs.tab_summary_image
		INTO :l_bSummary
		FROM cusfocus.iim_tabs
		WHERE cusfocus.iim_tabs.tab_id = :l_nSelected
		USING SQLCA;
		////End embedded sql
		
		IF SQLCA.SQLCode < 0 THEN
			Error.i_FWError = c_Fatal
		ELSE
			i_sParms.summary_syntax = ""
			IF NOT IsNull( l_bSummary ) AND Len( l_bSummary ) > 0 THEN
				i_sParms.summary_syntax = Trim( String( l_bSummary ) )

				// Make sure we converted it correctly - RAP 11/4/08
				l_Pos = Pos( i_sParms.summary_syntax, "release" )
				IF l_Pos = 0 THEN
					i_sParms.summary_syntax = string(l_bSummary, EncodingANSI!)
				END IF
			
			END IF
			
			////Begin embedded sql to retrieve the detail syntax blob
			SELECTBLOB cusfocus.iim_tabs.tab_detail_image
			INTO :l_bDetail
			FROM cusfocus.iim_tabs
			WHERE cusfocus.iim_tabs.tab_id = :l_nSelected
			USING SQLCA;
			////End embedded sql
			
			IF SQLCA.SQLCode < 0 THEN
				Error.i_FWError = c_Fatal
			ELSE
				i_sParms.detail_syntax = ""
				IF NOT IsNull( l_bDetail ) AND Len( l_bDetail ) > 0 THEN
					i_sParms.detail_syntax = Trim( String( l_bDetail ) )
					// Make sure we converted it correctly - RAP 11/4/08
					l_Pos = Pos( i_sParms.detail_syntax, "release" )
					IF l_Pos = 0 THEN
						i_sParms.detail_syntax = string(l_bDetail, EncodingANSI!)
					END IF
				END IF
			END IF
		END IF
		
		//Enable the define summary and detail buttons
		cb_define_detail.Enabled = TRUE
		cb_define_summary.Enabled = TRUE
		
		//Enable/disable the security level drop downs depending on whether syntax is retrieved
		IF IsNull( i_sParms.summary_syntax ) OR Trim( i_sParms.summary_syntax ) = "" THEN
			//Disable summary security dropdown
			THIS.Object.summary_conf_level.Background.Color = String( RGB( 214, 211, 206 ) )
			THIS.Object.summary_conf_level.Protect = '1'
		ELSE
			//Enable
			THIS.Object.summary_conf_level.Background.Color = String( RGB( 255, 255, 255 ) )
			THIS.Object.summary_conf_level.Protect = '0'
		END IF
		
		IF IsNull( i_sParms.detail_syntax ) OR Trim( i_sParms.detail_syntax ) = "" THEN
			//Disable detail security dropdown
			THIS.Object.detail_conf_level.Background.Color = String( RGB( 214, 211, 206 ) )
			THIS.Object.detail_conf_level.Protect = '1'
		ELSE
			//Enable
			THIS.Object.detail_conf_level.Background.Color = String( RGB( 255, 255, 255 ) )
			THIS.Object.detail_conf_level.Protect = '0'
		END IF
		
	CASE ELSE
		This.SetRedraw (TRUE)
END CHOOSE
end event

event pcd_new;call super::pcd_new;/****************************************************************************************
	Event:	pcd_new
	Purpose:	Set default values for new records
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	1/18/00  M. Caruso     Created.
	8/16/2000 K. Claver    Added code to clear out the summary and detail syntax structure
								  variables
	5/12/2002 K. Claver    Added code to disable the security dropdowns
****************************************************************************************/
Integer l_nSourceID
Datawindowchild l_dwcDataSources

THIS.GetChild( 'iim_source_id', l_dwcDataSources )

l_dwcDataSources.SetFilter ("iim_source_active = 'Y'")
l_dwcDataSources.Filter ()

IF l_dwcDataSources.RowCount( ) > 0 THEN
	l_nSourceID = l_dwcDataSources.GetItemNumber( 1, "iim_source_id" )
ELSE
	SetNull( l_nSourceID )
END IF

SetItem (i_CursorRow, "tab_title", "New Tab")
SetItem (i_CursorRow, "tab_active", "Y")
SetItem (i_CursorRow, "tab_preload", "Y")
SetItem (i_CursorRow, "iim_source_id", l_nSourceID)

//clear out the summary and detail syntax structure vars
SetNull( i_sParms.summary_syntax )
SetNull( i_sParms.detail_syntax )

i_nPrevRow = dw_tab_list.i_CursorRow
i_bNew = TRUE

//Enable the define summary and detail buttons
cb_define_detail.Enabled = TRUE
cb_define_summary.Enabled = TRUE

//Disable the security dropdowns.  Will be re-enabled if tabs are defined.
THIS.Object.summary_conf_level.Background.Color = String( RGB( 214, 211, 206 ) )
THIS.Object.summary_conf_level.Protect = '1'
THIS.Object.detail_conf_level.Background.Color = String( RGB( 214, 211, 206 ) )
THIS.Object.detail_conf_level.Protect = '1'
end event

event itemchanged;call super::itemchanged;/****************************************************************************************
	Event:	itemchanged
	Purpose:	Manage the order fields based on the status of the availablity fields
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	1/18/00  M. Caruso     Created.
	
	3/24/00  M. Caruso     Added code to make the source availability check boxes
								  exclusive since a tab can only be defined for one source type.
								  
	4/17/00  M. Caruso     Prompt the user to update retrieval args if the Source Type
								  changes after views are defined for a tab.
								  
	4/19/00  M. Caruso     Removed call to f_refreshdddw because it interfered with the
								  normal keyboard operation of the dropdown datawindow.
****************************************************************************************/

STRING	l_cColName, l_cOrderCol, l_cValue, l_cSummary, l_cDetail
LONG		l_nMaxOrder
BOOLEAN	l_bContinue, l_bPrompt

l_cColName = dwo.name
CHOOSE CASE l_cColName
	CASE "tab_available_member"
		l_cOrderCol = "tab_order_member"
		l_bContinue = TRUE
		SELECT Max (tab_order_member)
		  INTO :l_nMaxOrder
		  FROM cusfocus.iim_tabs
		 USING SQLCA;
		l_bPrompt = TRUE
		
	CASE "tab_available_provider"
		l_cOrderCol = "tab_order_provider"
		l_bContinue = TRUE
		SELECT Max (tab_order_provider)
		  INTO :l_nMaxOrder
		  FROM cusfocus.iim_tabs
		 USING SQLCA;
		l_bPrompt = TRUE
	   
	CASE "tab_available_group"
		l_cOrderCol = "tab_order_group"
		l_bContinue = TRUE
		SELECT Max (tab_order_group)
		  INTO :l_nMaxOrder
		  FROM cusfocus.iim_tabs
		 USING SQLCA;
		l_bPrompt = TRUE
		
	CASE "tab_available_other"
		l_cOrderCol = "tab_order_other"
		l_bContinue = TRUE
		SELECT Max (tab_order_other)
		  INTO :l_nMaxOrder
		  FROM cusfocus.iim_tabs
		 USING SQLCA;
		l_bPrompt = TRUE
	   
	CASE "tab_order_member", "tab_order_provider", "tab_order_group", "tab_order_other"
		l_bContinue = FALSE
		l_bPrompt = FALSE
		fu_Validate ()
		
	CASE "iim_source_id"
		AcceptText ()
		l_bContinue = FALSE
		l_bPrompt = FALSE
		
	CASE ELSE
		l_bContinue = FALSE
		l_bPrompt = FALSE
		
END CHOOSE

IF l_bPrompt THEN
	l_cSummary = i_sParms.summary_syntax
	l_cDetail = i_sParms.detail_syntax
	IF (NOT IsNull (l_cSummary)) OR (NOT IsNull (l_cDetail)) THEN
		OBJCA.MSG.fu_DisplayMessage ("IIM_VERIFY_ARGS")
	END IF
END IF

IF l_bContinue THEN
// assign the next available order number for the column
	IF IsNull (l_nMaxOrder) THEN l_nMaxOrder = 0
	CHOOSE CASE SQLCA.SQLCode
		CASE IS < 0
			MessageBox ("Error", "dw_tab_details.itemchanged event~r~n" + SQLCA.SQLErrText)
			
		CASE 0
			l_cValue = GetItemString (i_CursorRow, l_cColName)
			IF l_cValue = "Y" THEN
				SetNull (l_nMaxOrder)
				SetItem (i_CursorRow, l_cOrderCol, l_nMaxOrder)
				Modify (l_cOrderCol + ".Edit.DisplayOnly = yes")
				
			ELSE
				SetItem (i_CursorRow, l_cOrderCol, l_nMaxOrder + 1)
				Modify (l_cOrderCol + ".Edit.DisplayOnly = no")
				
				// only one can be selected at a time, so clear the other availability fields
				SetNull (l_nMaxOrder)
				IF 'tab_order_member' <> l_cOrderCol THEN
					SetItem (i_CursorRow, 'tab_available_member', 'N')
					SetItem (i_CursorRow, 'tab_order_member', l_nMaxOrder)
					Modify ('tab_order_member.Edit.DisplayOnly = yes')
				END IF
				IF 'tab_order_provider' <> l_cOrderCol THEN
					SetItem (i_CursorRow, 'tab_available_provider', 'N')
					SetItem (i_CursorRow, 'tab_order_provider', l_nMaxOrder)
					Modify ('tab_order_provider.Edit.DisplayOnly = yes')
				END IF
				IF 'tab_order_group' <> l_cOrderCol THEN
					SetItem (i_CursorRow, 'tab_available_group', 'N')
					SetItem (i_CursorRow, 'tab_order_group', l_nMaxOrder)
					Modify ('tab_order_group.Edit.DisplayOnly = yes')
				END IF
				IF 'tab_order_other' <> l_cOrderCol THEN
					SetItem (i_CursorRow, 'tab_available_other', 'N')
					SetItem (i_CursorRow, 'tab_order_other', l_nMaxOrder)
					Modify ('tab_order_other.Edit.DisplayOnly = yes')
				END IF
			END IF
			
		CASE ELSE
			MessageBox ("Error", SQLCA.SQLErrText)
			
	END CHOOSE
	
END IF
end event

event pcd_validatecol;call super::pcd_validatecol;/****************************************************************************************
	Event         : pcd_ValidateCol
	Description   : Provides the opportunity for the developer
                   to write code to validate DataWindow fields.

	Parameters    : BOOLEAN In_Save -
            	        Can be used by the developer to prevent
                     validation checking if this event was not
                     triggered by the save process.
                   LONG    Row_Nbr -
                     The row that is being validated.
                   INTEGER Col_Nbr -
                     The column that is being validated.
                   STRING  Col_Name -
                     The name of the column being validated.
                   STRING  Col_Text -
                     The input the user has made.
                   STRING  Col_Val_Msg -
                     The validation error message provided by
                     PowerBuilder's extended column definition.
                   BOOLEAN Col_Req_Error -
                     This column is a required field and the user
                     has not entered anything.

	Return Value  : Error.i_FWError -
                     c_ValOk     - Data was validated successfully.
                     c_ValFailed - Data failed validation.
                     c_ValFixed  - Data failed validation, but was
                                   fixed and updated using SetItem.

	Change History:

	Date     Person     Description of Change
	-------- ---------- ------------------------------------------------------------------
	1/18/00  M. Caruso  Created.
****************************************************************************************/

LONG		l_nIndex, l_nTotalRows, l_nCounter, l_nTabID
BOOLEAN	l_bPassed

CHOOSE CASE col_name

   CASE "tab_order_member", "tab_order_provider", "tab_order_group", "tab_order_other"
		l_nIndex = GetItemNumber (Row_Nbr, Col_Name)
		// skip if NULL
		IF NOT IsNull (l_nIndex) THEN
			
			// Verify that the value entered is unique for the source type
			l_bPassed = TRUE
			l_nTotalRows = dw_tab_list.RowCount ()
			FOR l_nCounter = 1 to l_nTotalRows
			
				l_nTabID = GetItemNumber (Row_Nbr, "tab_id")
				IF dw_tab_list.GetItemNumber (l_nCounter, Col_Name) = l_nIndex THEN
					
					IF dw_tab_list.GetItemNumber (l_nCounter, "tab_id") <> l_nTabID THEN
						MessageBox (gs_AppName,"The order value must be unique for a given Source Type.")
						l_bPassed = FALSE
						EXIT
					END IF
					
				END IF
				
			NEXT
			IF l_bPassed THEN
				Error.i_FWError = c_ValOK
			ELSE
				SetColumn (Col_Nbr)
				Error.i_FWError = c_ValFailed
			END IF
			
		END IF
		
END CHOOSE
end event

event pcd_delete;call super::pcd_delete;/****************************************************************************************
	Event:	pcd_delete
	Purpose:	Update the i_nMaxValue variable as tabs are deleted.
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	1/18/00  M. Caruso     Created.
****************************************************************************************/

LONG	l_nSelectedRows[]

// reselect the previously selected row if the item being deleted was new.
IF i_bNew THEN
	
	l_nSelectedRows[1] = i_nPrevRow
	dw_tab_list.fu_SetSelectedRows (1, l_nSelectedRows[], dw_tab_list.c_ignorechanges, &
					dw_tab_list.c_RefreshChildren)
	
END IF
end event

event pcd_validatebefore;call super::pcd_validatebefore;/*****************************************************************************************
   Event:      pcd_validatebefore
   Purpose:    Verify that the current record has a valid ID and that the updated_? fields
					are set before saving.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/23/00  M. Caruso    Created.
	5/2/00   M. Caruso    Only process the code if rows exist (i_CursorRor > 0).
	1/16/2001 K. Claver   Added code to ensure a source type is selected before allowing
								 to save.
*****************************************************************************************/

LONG		l_nTabID, ll_source_id
STRING	l_cUserName, l_cMember, l_cProvider, l_cGroup, l_cOther
DATETIME	l_dtTimeStamp

IF i_CursorRow > 0 THEN
	ll_source_id = THIS.Object.iim_source_id[ i_CursorRow ]
	IF IsNull(ll_source_id) THEN
		MessageBox( gs_AppName, "Please select a Data Source", StopSign!, Ok! )
		
		Error.i_FWError = c_Fatal
		RETURN
	END IF
	//Check if the user has chosen a source type
	l_cMember = THIS.Object.tab_available_member[ i_CursorRow ]
	l_cProvider = THIS.Object.tab_available_provider[ i_CursorRow ]
	l_cGroup = THIS.Object.tab_available_group[ i_CursorRow ]
	l_cOther = THIS.Object.tab_available_other[ i_CursorRow ]
	
	IF ( IsNull( l_cMember ) OR l_cMember = "N" ) AND &
		( IsNull( l_cProvider ) OR l_cProvider = "N" ) AND &
		( IsNull( l_cGroup ) OR l_cGroup = "N" ) AND &
		( IsNull( l_cOther ) OR l_cOther = "N" ) THEN
		MessageBox( gs_AppName, "Please select a Source Type", StopSign!, Ok! )
		
		Error.i_FWError = c_Fatal
		RETURN
	ELSE
		Error.i_FWError = c_Success
	END IF
	
	// set the Tab ID if necessary
	l_nTabID = GetItemNumber (i_CursorRow, "tab_id")
	IF IsNull (l_nTabID) THEN
		
		// get the ID of the new tab
		SELECT Max (tab_id) INTO :l_nTabID FROM cusfocus.iim_tabs USING SQLCA;
		IF IsNull (l_nTabID) THEN
			l_nTabID = 1
		ELSE
			l_nTabID ++
		END IF
		
		// set the tab ID only if a new ID is assigned
		SetItem (i_CursorRow, "tab_id", l_nTabID)
		
	END IF
	
	// Get the user ID and timestamp
	l_dtTimeStamp = w_table_maintenance.fw_GetTimeStamp()
	l_cUserName = OBJCA.WIN.fu_GetLogin(SQLCA)
	
	// set the required values
	SetItem (i_CursorRow, 'updated_by', l_cUserName)
	SetItem (i_CursorRow, 'updated_timestamp', l_dtTimeStamp)

END IF
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

