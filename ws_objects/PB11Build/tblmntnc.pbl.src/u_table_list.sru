$PBExportHeader$u_table_list.sru
$PBExportComments$Tables Lists User Object lists all the tables that the user may modify and a descritpion.
forward
global type u_table_list from u_container_main
end type
type dw_table_list from u_dw_std within u_table_list
end type
type st_1 from statictext within u_table_list
end type
type dw_table_description from u_dw_std within u_table_list
end type
end forward

global type u_table_list from u_container_main
integer width = 3579
integer height = 1592
long backcolor = 79748288
dw_table_list dw_table_list
st_1 st_1
dw_table_description dw_table_description
end type
global u_table_list u_table_list

on u_table_list.create
int iCurrent
call super::create
this.dw_table_list=create dw_table_list
this.st_1=create st_1
this.dw_table_description=create dw_table_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_table_list
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_table_description
end on

on u_table_list.destroy
call super::destroy
destroy(this.dw_table_list)
destroy(this.st_1)
destroy(this.dw_table_description)
end on

event resize;call super::resize;dw_table_list.height = this.height - 188
end event

type dw_table_list from u_dw_std within u_table_list
event cf_swap_dw pbm_custom01
event ue_selecttrigger pbm_dwnkey
integer x = 178
integer y = 116
integer width = 1266
integer height = 1404
integer taborder = 10
string dataobject = "d_table_list"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/25/99  M. Caruso     Created.

****************************************************************************************/

IF (key = KeyEnter!) AND (GetRow() > 0) THEN
	w_table_maintenance.dw_folder.fu_SelectTab (2)
	RETURN -1
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/***************************************************************************************

		Event:   pcd_retrieve
		Purpose:	To retrieve data into the Table List datawindow
		
	*************************************************************************************
	8/18/2000 K. Claver  Added code to check if the conversion from text to blob for
								the IIM tab syntax has taken place.  The code can be removed
								after all clients have converted to the 3.01 version.
	7/26/2001 K. Claver  Commented out conversion code as we are well past 3.01 and the code
							   actually causes problems in Sybase.
***************************************************************************************/

LONG l_nReturn, l_nRows

//**********************************************************
////Begin embedded sql to check if there are rows at all
//SELECT Count( * )
//INTO :l_nRows
//FROM cusfocus.iim_tabs
//USING SQLCA;
//
//IF l_nRows > 0 THEN
//	////Begin embedded sql to check if the iim tab conversion
//	////  has taken place yet
//	SELECT Count( * )
//	INTO :l_nRows
//	FROM cusfocus.iim_tabs
//	WHERE cusfocus.iim_tabs.tab_summary_image IS NOT NULL
//	USING SQLCA;
//	////End embedded sql
//	
//	//Check the SQLCode property
//	IF SQLCA.SQLCode < 0 THEN
//		MessageBox( gs_AppName, "Error accessing column cusfocus.iim_tabs.tab_summary_image.~r~n"+ &
//						"Please check that the upgrade scripts for version 3.01 of~r~n"+ &
//						gs_AppName+" have been run." )
//	ELSEIF l_nRows = 0 THEN 
//		////Begin embedded sql to set the active property of 
//		////  the iim conversion table maintenance entry to "Y"
//		UPDATE cusfocus.user_maintainable_tables
//		SET cusfocus.user_maintainable_tables.active = 'Y'
//		WHERE cusfocus.user_maintainable_tables.db_table_name = 'iim_conv'
//		USING SQLCA;
//		////End embedded sql
//		
//		IF SQLCA.SQLCode < 0 THEN
//			MessageBox( gs_AppName, "Error updating the active property of the IIM Conversion~r~n"+ &
//							"Table Maintenance entry.  Please check that the upgrade~r~n"+ &
//							"scripts for version 3.01 of "+gs_AppName+" have been run." )
//		END IF
//	END IF
//END IF
//************************************************

l_nReturn = Retrieve(OBJCA.WIN.fu_GetLogin (SQLCA))

IF l_nReturn < 0 THEN
	Error.i_FWError = c_Fatal
END IF

THIS.SetFocus()

end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
	Event:	doubleclicked
	Purpose:	Allow the user to switch to the Table Maintenance screen.
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	7/20/99  M. Caruso     Created.
*****************************************************************************************/

IF dwo.Type = "column" THEN
	w_table_maintenance.dw_folder.fu_SelectTab(2)
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    initialize the datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/03/01 M. Caruso    Created.
*****************************************************************************************/

fu_setoptions (SQLCA, c_NullDW, c_SelectOnRowFocusChange + &
										  c_ShowHighlight + &
										  c_NoInactiveRowPointer + &
										  c_NoActiveRowPointer + &
										  c_NoMenuButtonActivation)
end event

type st_1 from statictext within u_table_list
integer x = 192
integer y = 52
integer width = 421
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Tables:"
boolean focusrectangle = false
end type

type dw_table_description from u_dw_std within u_table_list
integer x = 1723
integer y = 44
integer width = 1719
integer taborder = 0
string dataobject = "d_tm_table_description"
boolean border = false
end type

event pcd_retrieve;call super::pcd_retrieve;/**************************************************************************************

			Event:	pcd_retrieve
			Purpose:	To retrieve data into the Table Description 
						DataWindow


****************************************************************************************/

LONG l_nReturn
STRING l_cTableID

//--------------------------------------------------------------------
//
//		Get the Table ID from the Parent datawindow and use it for a 
//		Retrieval argument for the Table Description datawindow.
//
//--------------------------------------------------------------------

l_cTableID = Parent_DW.GetItemSTring(Selected_Rows[1], &
														'user_main_table_id')

l_nReturn = THIS.Retrieve(l_cTableID)

IF l_nReturn < 0 THEN
	Error.i_FWError = c_Fatal
END IF




end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    initialize the datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/03/01 M. Caruso    Created.
*****************************************************************************************/

fu_setoptions (SQLCA, dw_table_list, c_NoMenuButtonActivation)
end event

