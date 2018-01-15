$PBExportHeader$u_forms_maintenance.sru
forward
global type u_forms_maintenance from u_container_std
end type
type cb_tab from commandbutton within u_forms_maintenance
end type
type dw_template_properties from u_dw_std within u_forms_maintenance
end type
type cb_preview from commandbutton within u_forms_maintenance
end type
type cb_delete from commandbutton within u_forms_maintenance
end type
type dw_templates_in_pbl from u_dw_std within u_forms_maintenance
end type
type st_5 from statictext within u_forms_maintenance
end type
type st_4 from statictext within u_forms_maintenance
end type
type cb_refresh from commandbutton within u_forms_maintenance
end type
type st_3 from statictext within u_forms_maintenance
end type
type st_2 from statictext within u_forms_maintenance
end type
type cb_export from commandbutton within u_forms_maintenance
end type
type cb_import from commandbutton within u_forms_maintenance
end type
type sle_template_comments from singlelineedit within u_forms_maintenance
end type
type sle_template_name from singlelineedit within u_forms_maintenance
end type
type sle_template_location from singlelineedit within u_forms_maintenance
end type
type st_1 from statictext within u_forms_maintenance
end type
type cb_map from commandbutton within u_forms_maintenance
end type
type dw_template_list from u_dw_std within u_forms_maintenance
end type
type dw_template_preview from u_dw_std within u_forms_maintenance
end type
end forward

global type u_forms_maintenance from u_container_std
integer width = 3579
integer height = 1592
event ue_previewtemplate ( integer a_nrow )
event ue_import ( )
event ue_delete ( )
event ue_save ( )
cb_tab cb_tab
dw_template_properties dw_template_properties
cb_preview cb_preview
cb_delete cb_delete
dw_templates_in_pbl dw_templates_in_pbl
st_5 st_5
st_4 st_4
cb_refresh cb_refresh
st_3 st_3
st_2 st_2
cb_export cb_export
cb_import cb_import
sle_template_comments sle_template_comments
sle_template_name sle_template_name
sle_template_location sle_template_location
st_1 st_1
cb_map cb_map
dw_template_list dw_template_list
dw_template_preview dw_template_preview
end type
global u_forms_maintenance u_forms_maintenance

type variables
String i_cLibrary, i_cTemplateKey
end variables

forward prototypes
public function string fu_gettemplateloc ()
public subroutine fu_updatedetailsgui ()
end prototypes

event ue_previewtemplate;/*****************************************************************************************
   Event:      ue_PreviewTemplate
   Purpose:    Open the window to preview the template
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Created
*****************************************************************************************/
FWCA.MGR.fu_OpenWindow( w_form_preview, dw_template_preview )
end event

event ue_import;/*****************************************************************************************
   Event:      ue_import
   Purpose:    Import a record from the forms pbl
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Created
	07/01/03 M. Caruso    Added check for External or table-based data source.  Only allows
								 the import if External.
*****************************************************************************************/
Integer l_nRow, l_nIndex, l_nRV, l_nParenPos
String l_cReport, l_cError, l_cDWSyntax, l_cErrMsg, l_cColLength, l_cColType
Blob l_blTemplate
Long l_nDeleteRows[ ], l_nSelectedRow[ ]
Boolean l_bAutoCommit

sle_template_name.SetRedraw( FALSE )
sle_template_comments.SetRedraw( FALSE )

IF dw_templates_in_pbl.RowCount( ) > 0 THEN
	l_nRow = dw_templates_in_pbl.GetSelectedRow( 0 )
	IF l_nRow > 0 THEN
		l_cReport = dw_templates_in_pbl.GetItemString( l_nRow, "template_name" )
		
		IF Trim( l_cReport ) <> "" THEN
			l_cDWSyntax = LibraryExport( THIS.i_cLibrary, l_cReport, ExportDatawindow! )
			
			IF Trim( l_cDWSyntax ) <> "" THEN
				// determine if the datawindow syntax being imported is table-based or external
				IF Pos (l_cDWSyntax, 'retrieve="') = 0 THEN
					// the datasource is External, so continue
					IF dw_template_preview.Create( l_cDWSyntax, l_cError ) > 0 THEN
						//Set the limits if the form creator forgot to set them in InfoMaker
						FOR l_nIndex = 1 TO Integer( dw_template_preview.Object.Datawindow.Column.Count )
							IF dw_template_preview.Describe( "#"+String( l_nIndex )+".Visible" ) = "1" THEN
								l_cColType = dw_template_preview.Describe( "#"+String( l_nIndex )+".ColType" )
								IF Trim( Upper( Left( l_cColType, 4 ) ) ) = "CHAR" THEN
									//Get the column length to set the limit
									l_nParenPos = Pos( l_cColType, "(" )
									IF l_nParenPos > 0 THEN
										l_cColLength = Mid( l_cColType, ( l_nParenPos + 1 ), ( Pos( l_cColType, ")" ) - l_nParenPos - 1 ) )
																
										//Check the column type to determine how to set the limit
										CHOOSE CASE Upper( dw_template_preview.Describe( "#"+String( l_nIndex )+".Edit.Style" ) )
											CASE "EDIT"
												dw_template_preview.Modify( "#"+String( l_nIndex )+".Edit.Limit='"+l_cColLength+"'" )
											CASE "EDITMASK"
												dw_template_preview.Modify( "#"+String( l_nIndex )+".EditMask.Limit='"+l_cColLength+"'" )
											CASE "DDLB"
												dw_template_preview.Modify( "#"+String( l_nIndex )+".DDLB.Limit='"+l_cColLength+"'" )
										END CHOOSE
									END IF
								END IF
							END IF
						NEXT
						
						//Get the new datawindow syntax
						l_cDWSyntax = dw_template_preview.Object.Datawindow.Syntax
							
						//Set the display fields
						sle_template_name.Text = dw_templates_in_pbl.GetItemString( l_nRow, "template_name" )
						sle_template_comments.Text = dw_templates_in_pbl.GetItemString( l_nRow, "template_comment" )
						
						//Insert a new row
						dw_template_properties.fu_New( 1 )
						
						//Set the template key
						THIS.i_cTemplateKey = w_table_maintenance.fw_GetKeyValue( "form_templates" )
						dw_template_properties.Object.template_key[ 1 ] = THIS.i_cTemplateKey
						
						//Set the row info.  Initialize the template to inactive so validates if have selected
						//  case and source type before activating.
						dw_template_properties.Object.force_user_notify[ 1 ] = 0
						dw_template_properties.Object.active[ 1 ] = 0
						dw_template_properties.Object.template_name[ 1 ] = Trim( sle_template_name.Text )
						dw_template_properties.Object.template_description[ 1 ] = Trim( sle_template_comments.Text )
						dw_template_properties.Object.dw_header[ 1 ] = Trim( sle_template_name.Text )
						
						//Comments are not required
						IF Trim( sle_template_comments.Text ) <> "" THEN
							dw_template_properties.Object.dw_comments[ 1 ] = Trim( sle_template_comments.Text )
						END IF
						
						//Set the updated by and timestamp
						dw_template_properties.Object.updated_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
						dw_template_properties.Object.updated_timestamp[ 1 ] = w_table_maintenance.fw_GetTimeStamp( )
						
						//Save the template row
						l_nRV = dw_template_properties.fu_Save( dw_template_properties.c_SaveChanges )
						
						IF l_nRV = 0 THEN
							l_bAutoCommit = SQLCA.AutoCommit
							SQLCA.AutoCommit = TRUE
							
							//Save the datawindow syntax
							l_blTemplate = Blob( l_cDWSyntax )
								
							UPDATEBLOB cusfocus.form_templates
							SET template_image = :l_blTemplate
							WHERE template_key = :THIS.i_cTemplateKey
							USING SQLCA;
							
							IF SQLCA.SQLCode <> 0 THEN
								l_cErrMsg = "Failed to update the template image in the database.~r~nError Returned:~r~n"+ &
												SQLCA.SQLErrText
												
								l_nDeleteRows[ 1 ] = dw_template_list.GetSelectedRow( 0 )
								l_nRV = dw_template_list.fu_Delete( 1, l_nDeleteRows, dw_template_list.c_IgnoreChanges )
								
								IF l_nRV <> 0 THEN
									l_cErrMsg = "Failed to delete the erroneous template row"
								END IF
							ELSE
								//Set the newly inserted row as the selected row and re-set the text fields as the save
								//  of the row via PowerClass causes a re-sort of the list datawindow.
								l_nSelectedRow[ 1 ] = dw_template_list.Find( "template_key = '"+THIS.i_cTemplateKey+"'", 1, dw_template_list.RowCount( ) )
								dw_template_list.fu_SetSelectedRows( 1, l_nSelectedRow, &
																				 dw_template_list.c_IgnoreChanges, &
																				 dw_template_list.c_NoRefreshChildren )
																																							 
								sle_template_name.Text = dw_templates_in_pbl.GetItemString( l_nRow, "template_name" )
								sle_template_comments.Text = dw_templates_in_pbl.GetItemString( l_nRow, "template_comment" )
							END IF
							
							SQLCA.AutoCommit = l_bAutoCommit
						ELSE
							l_cErrMsg = "Failed to save the template properties"
						END IF
					ELSE
						l_cErrMsg = "Creation of template preview failed.~r~n~r~nError: "+l_cError
					END IF
				ELSE
					l_cErrMsg = "This entry is not a valid form template. Import aborted."
				END IF
			ELSE
				l_cErrMsg = "Error retrieving template syntax"
			END IF
			
			IF Trim( l_cErrMsg ) <> "" AND NOT IsNull( l_cErrMsg ) THEN
				MessageBox( gs_AppName, l_cErrMsg, StopSign!, OK! )
				cb_export.Enabled = FALSE
				cb_preview.Enabled = FALSE
				cb_map.Enabled = FALSE
				cb_tab.Enabled = FALSE
			ELSE
				cb_export.Enabled = TRUE
				cb_preview.Enabled = TRUE
				cb_map.Enabled = TRUE
				cb_tab.Enabled = TRUE
			END IF
		END IF
	END IF
END IF

sle_template_name.SetRedraw( TRUE )
sle_template_comments.SetRedraw( TRUE )


end event

event ue_delete;/*****************************************************************************************
   Event:      ue_delete
   Purpose:    Delete the form template
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Created
*****************************************************************************************/
Integer l_nRow, l_nDeleteRow[ ], l_nRV, l_nSelectedRow[ ]
String l_cTemplateKey
Long l_nCount

l_nRow = dw_template_list.GetSelectedRow( 0 )

IF l_nRow > 0 THEN
	l_nRV = MessageBox( gs_AppName, "Are you sure you want to delete the selected form template?", Question!, YesNo! )	
	
	IF l_nRV = 1 THEN
		//Get the template key and check dependent tables first
		l_cTemplateKey = dw_template_list.Object.template_key[ l_nRow ]
		
		//Form properties table
		SELECT Count( * )
		INTO :l_nCount
		FROM cusfocus.case_forms
		WHERE template_key = :l_cTemplateKey
		USING SQLCA;
		
		IF l_nCount > 0 THEN
			MessageBox( gs_AppName, "Unable to delete the form template as there are dependencies"+ &
							" in the database.~r~nRemoving the template would"+ &
							" disable accurate reporting on the saved properties", StopSign!, OK! )
			RETURN
		END IF
		
		//Remove the property mappings first
		SELECT Count( * )
		INTO :l_nCount
		FROM cusfocus.form_property_mappings
		WHERE template_key = :l_cTemplateKey
		USING SQLCA;
		
		IF l_nCount > 0 THEN
			DELETE cusfocus.form_property_mappings
			WHERE template_key = :l_cTemplateKey
			USING SQLCA;
			
			IF SQLCA.SQLCode <> 0 THEN
				MessageBox( gs_AppName, "Unable to delete the form property mappings.  Delete failed.~r~n"+ &
								"Error Returned:~r~n"+SQLCA.SQLErrText, StopSign!, OK! )
				RETURN
			END IF
		END IF
		
		l_nDeleteRow[ 1 ] = l_nRow
		l_nRV = dw_template_list.fu_Delete( 1, l_nDeleteRow, dw_template_list.c_IgnoreChanges )
	
		IF l_nRV = 0 THEN
			l_nRV = dw_template_list.fu_Save( dw_template_list.c_SaveChanges )
			
			IF l_nRV <> 0 THEN
				MessageBox( gs_AppName, "Failed to delete the form template from the database" )
			ELSE
				IF dw_template_list.RowCount( ) = 0 THEN
					cb_delete.Enabled = FALSE
					m_table_maintenance.m_edit.m_delete.Enabled = FALSE
					cb_export.Enabled = FALSE
					cb_preview.Enabled = FALSE
					cb_map.Enabled = FALSE
					cb_tab.Enabled = FALSE
				ELSE
					//Re-set the selected row as the save process may have re-sorted the datawindow
					IF l_nRow > dw_template_list.RowCount( ) THEN
						l_nSelectedRow[ 1 ] = dw_template_list.RowCount( )
					ELSE
						l_nSelectedRow[ 1 ] = l_nRow
					END IF
					
					dw_template_list.fu_SetSelectedRows( 1, l_nSelectedRow, &
																	 dw_template_list.c_IgnoreChanges, &
																	 dw_template_list.c_NoRefreshChildren )
																			 																			 
					sle_template_name.Text = dw_template_list.GetItemString( l_nSelectedRow[ 1 ], "dw_header" )
					sle_template_comments.Text = dw_template_list.GetItemString( l_nSelectedRow[ 1 ], "dw_comments" )
				END IF
			END IF
		ELSE
			MessageBox( gs_AppName, "Failed to delete the form template" )
		END IF
	END IF
ELSE
	MessageBox( gs_AppName, "Please select a form template to delete", StopSign!, OK! )
END IF


end event

event ue_save;/*****************************************************************************************
   Event:      ue_Save
   Purpose:    Save event for the container object
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/1/2002 K. Claver    Created
*****************************************************************************************/
Integer l_nRV, l_nRow, l_nSelectedRow[ ]
String l_cTemplateName, l_cComment

dw_template_properties.SetFocus( )
l_nRV = dw_template_properties.fu_Save( dw_template_properties.c_SaveChanges )

IF l_nRV = 0 THEN
	l_nRow = dw_template_list.GetSelectedRow( 0 )
	//Make sure the template and comment name are properly selected
	l_cTemplateName = dw_template_list.Object.dw_header[ l_nRow ]
	l_cComment = dw_template_list.Object.dw_comments[ l_nRow ]
	
	sle_template_name.Text = l_cTemplateName
	sle_template_comments.Text = l_cComment
	
	IF dw_templates_in_pbl.RowCount( ) > 0 THEN
		l_nRow = dw_templates_in_pbl.Find( "template_name = '"+l_cTemplateName+"'", 1, dw_templates_in_pbl.RowCount( ) )
		
		IF l_nRow > 0 THEN
			l_nSelectedRow[ 1 ] = l_nRow
			dw_templates_in_pbl.fu_SetSelectedRows( 1, l_nSelectedRow, dw_templates_in_pbl.c_IgnoreChanges, &
																 dw_templates_in_pbl.c_NoRefreshChildren )
		END IF
	END IF
//ELSE
//	MessageBox( gs_AppName, "Failed to save the template properties", StopSign!, OK! )
END IF
end event

public function string fu_gettemplateloc ();//******************************************************************
//  Function     : fu_GetTemplateLoc
//  Parameters   : None
//  Returns      : The path and/or name of the uncompiled pbl
//  Description   : Retrieves the location of the form template PBL
//
//  Date     Developer   Description 
//  -------- ----------- --------------------------------------------
//  1/8/2002 K. Claver  Created
//******************************************************************/
Integer l_nCount
String l_cTemplateLoc

SELECT Count( * )
INTO :l_nCount
FROM cusfocus.system_options
WHERE upper( cusfocus.system_options.option_name ) = 'FORMS_PBL_LOCATION'
USING SQLCA;

IF l_nCount > 0 THEN
	SELECT cusfocus.system_options.option_value
	INTO :l_cTemplateLoc
	FROM cusfocus.system_options
	WHERE upper( cusfocus.system_options.option_name ) = 'FORMS_PBL_LOCATION'
	USING SQLCA;
END IF

RETURN l_cTemplateLoc
end function

public subroutine fu_updatedetailsgui ();/*****************************************************************************************
   Function:   fu_UpdateDetailsGUI
   Purpose:    Make sure that the Forms Template detail datawindow accurately reflects the
					current settings.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/26/03 M. Caruso    Created.
*****************************************************************************************/
STRING	l_cValue

IF dw_template_properties.RowCount() > 0 THEN

	//Get the case type(s)
	l_cValue = dw_template_properties.Object.case_types[ 1 ]
	
	IF Pos( l_cValue, "I" ) > 0 THEN
		dw_template_properties.Object.cc_inquiry[ 1 ] = "I"
	ELSE
		dw_template_properties.Object.cc_inquiry[ 1 ] = "0"
	END IF
	IF Pos( l_cValue, "C" ) > 0 THEN
		dw_template_properties.Object.cc_issueconc[ 1 ] = "C"
	ELSE
		dw_template_properties.Object.cc_issueconc[ 1 ] = "0"
	END IF
	IF Pos( l_cValue, "M" ) > 0 THEN
		dw_template_properties.Object.cc_configurable[ 1 ] = "M"
	ELSE
		dw_template_properties.Object.cc_configurable[ 1 ] = "0"
	END IF
	IF Pos( l_cValue, "P" ) > 0 THEN
		dw_template_properties.Object.cc_proactive[ 1 ] = "P"
	ELSE
		dw_template_properties.Object.cc_proactive[ 1 ] = "0"
	END IF
	
	//Get the source type(s)
	l_cValue = dw_template_properties.Object.source_types[ 1 ] 
	
	IF Pos( l_cValue, "C" ) > 0 THEN
		dw_template_properties.Object.cc_member[ 1 ]= "C"
	ELSE
		dw_template_properties.Object.cc_member[ 1 ] = "0"
	END IF
	IF Pos( l_cValue, "E" ) > 0 THEN
		dw_template_properties.Object.cc_group[ 1 ] = "E"
	ELSE
		dw_template_properties.Object.cc_group[ 1 ] = "0"
	END IF
	IF Pos( l_cValue, "P" ) > 0 THEN
		dw_template_properties.Object.cc_provider[ 1 ] = "P"
	ELSE
		dw_template_properties.Object.cc_provider[ 1 ] = "0"
	END IF
	IF Pos( l_cValue, "O" ) > 0 THEN
		dw_template_properties.Object.cc_other[ 1 ] = "O"
	ELSE
		dw_template_properties.Object.cc_other[ 1 ] = "0"
	END IF
	
	// make the record show up as unchanged.
	dw_template_properties.SetItemStatus( 1, 0, Primary!, NotModified! )
	
END IF
end subroutine

on u_forms_maintenance.create
int iCurrent
call super::create
this.cb_tab=create cb_tab
this.dw_template_properties=create dw_template_properties
this.cb_preview=create cb_preview
this.cb_delete=create cb_delete
this.dw_templates_in_pbl=create dw_templates_in_pbl
this.st_5=create st_5
this.st_4=create st_4
this.cb_refresh=create cb_refresh
this.st_3=create st_3
this.st_2=create st_2
this.cb_export=create cb_export
this.cb_import=create cb_import
this.sle_template_comments=create sle_template_comments
this.sle_template_name=create sle_template_name
this.sle_template_location=create sle_template_location
this.st_1=create st_1
this.cb_map=create cb_map
this.dw_template_list=create dw_template_list
this.dw_template_preview=create dw_template_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_tab
this.Control[iCurrent+2]=this.dw_template_properties
this.Control[iCurrent+3]=this.cb_preview
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.dw_templates_in_pbl
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.cb_refresh
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.cb_export
this.Control[iCurrent+12]=this.cb_import
this.Control[iCurrent+13]=this.sle_template_comments
this.Control[iCurrent+14]=this.sle_template_name
this.Control[iCurrent+15]=this.sle_template_location
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.cb_map
this.Control[iCurrent+18]=this.dw_template_list
this.Control[iCurrent+19]=this.dw_template_preview
end on

on u_forms_maintenance.destroy
call super::destroy
destroy(this.cb_tab)
destroy(this.dw_template_properties)
destroy(this.cb_preview)
destroy(this.cb_delete)
destroy(this.dw_templates_in_pbl)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.cb_refresh)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_export)
destroy(this.cb_import)
destroy(this.sle_template_comments)
destroy(this.sle_template_name)
destroy(this.sle_template_location)
destroy(this.st_1)
destroy(this.cb_map)
destroy(this.dw_template_list)
destroy(this.dw_template_preview)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_SetOptions
   Purpose:    Please see PowerClass documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Initialize the objects and instance variables.
*****************************************************************************************/
//Get the library path so can retrieve the list of 
//  available templates
THIS.i_cLibrary = THIS.fu_GetTemplateLoc( )

IF Trim( THIS.i_cLibrary ) <> "" AND NOT IsNull( THIS.i_cLibrary ) THEN
	sle_template_location.Text = THIS.i_cLibrary
	
	IF FileExists( THIS.i_cLibrary ) THEN		
		//Trigger the event to populate the report list datawindow
		dw_templates_in_pbl.Event Trigger ue_GetTemplates( )
		
		cb_export.Enabled = TRUE
		cb_refresh.Enabled = TRUE
	ELSE
		MessageBox( gs_AppName, "Incorrect case form template library name or library doesn't exist" )
		cb_export.Enabled = FALSE
		cb_refresh.Enabled = FALSE
	END IF
ELSE
	MessageBox( gs_AppName, "Case form template library has not been defined in Options" )	
	cb_export.Enabled = FALSE
	cb_refresh.Enabled = FALSE
END IF
end event

type cb_tab from commandbutton within u_forms_maintenance
integer x = 3177
integer y = 1336
integer width = 375
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Tab Order"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Open the window to map the fields in the form template to the 
								 fields in the form_properties table.
*****************************************************************************************/
String l_cDWSyntax, l_cErrMsg
Blob l_blTemplate
Integer l_nRV
Boolean l_bAutoCommit

FWCA.MGR.fu_OpenWindow( w_form_set_tabsequence, PARENT )

IF Trim( Upper( Message.StringParm ) ) = "CHANGE" THEN		
	//Set the updated by and timestamp
	dw_template_properties.Object.updated_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
	dw_template_properties.Object.updated_timestamp[ 1 ] = w_table_maintenance.fw_GetTimeStamp( )
	
	//Save the template row
	PARENT.Event Trigger ue_save( )
	
	l_bAutoCommit = SQLCA.AutoCommit
	SQLCA.AutoCommit = TRUE
	
	//Get the new datawindow syntax
	l_cDWSyntax = dw_template_preview.Object.Datawindow.Syntax
	l_blTemplate = Blob( l_cDWSyntax )
		
	UPDATEBLOB cusfocus.form_templates
	SET template_image = :l_blTemplate
	WHERE template_key = :PARENT.i_cTemplateKey
	USING SQLCA;
	
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox( gs_AppName, "Failed to update the template image in the database.~r~nError Returned:~r~n"+ &
						SQLCA.SQLErrText, StopSign!, OK! )
	END IF
	
	SQLCA.AutoCommit = l_bAutoCommit
END IF
end event

type dw_template_properties from u_dw_std within u_forms_maintenance
integer x = 18
integer y = 836
integer width = 3141
integer height = 744
integer taborder = 0
string dataobject = "d_template_properties"
boolean border = false
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/11/2002 K. Claver   Added function call to set the options for the datawindow
*****************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  dw_template_list, &
						  THIS.c_NewOK+ &
						  THIS.c_ModifyOK+ &
						  THIS.c_ScrollParent+ &
						  THIS.c_RefreshParent+ &
						  THIS.c_RefreshChild+ &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_NoMenuButtonActivation )
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/11/2002 K. Claver   Added code to retrieve the datawindow and initialize the fields.
*****************************************************************************************/
Long l_nRV
String l_cValue, l_cKey

THIS.Object.t_configurable.text = gs_configcasetype

l_cKey = parent_dw.GetItemString( selected_rows[ 1 ], "template_key" )

l_nRV = THIS.Retrieve( l_cKey )

CHOOSE CASE l_nRV
	CASE IS < 0
   	Error.i_FWError = THIS.c_Fatal
	CASE 0
		THIS.fu_View( )
	CASE ELSE
		fu_UpdateDetailsGUI ()
//		//Get the case type(s)
//		l_cValue = THIS.Object.case_types[ 1 ]
//		
//		IF Pos( l_cValue, "I" ) > 0 THEN
//			THIS.Object.cc_inquiry[ 1 ] = "I"
//		END IF
//		
//		IF Pos( l_cValue, "C" ) > 0 THEN
//			THIS.Object.cc_issueconc[ 1 ] = "C"
//		END IF
//		
//		IF Pos( l_cValue, "M" ) > 0 THEN
//			THIS.Object.cc_configurable[ 1 ] = "M"
//		END IF
//		
//		IF Pos( l_cValue, "P" ) > 0 THEN
//			THIS.Object.cc_proactive[ 1 ] = "P"
//		END IF
//		
//		//Get the source type(s)
//		l_cValue = THIS.Object.source_types[ 1 ] 
//		
//		IF Pos( l_cValue, "C" ) > 0 THEN
//			THIS.Object.cc_member[ 1 ]= "C"
//		END IF
//		
//		IF Pos( l_cValue, "E" ) > 0 THEN
//			THIS.Object.cc_group[ 1 ] = "E"
//		END IF
//		
//		IF Pos( l_cValue, "P" ) > 0 THEN
//			THIS.Object.cc_provider[ 1 ] = "P"
//		END IF
//		
//		IF Pos( l_cValue, "O" ) > 0 THEN
//			THIS.Object.cc_other[ 1 ] = "O"
//		END IF
//		
//		// make the record show up as unchanged.
//		THIS.SetItemStatus( 1, 0, Primary!, NotModified! )		 
END CHOOSE
end event

event pcd_validaterow;/*****************************************************************************************
   Event:      pcd_validaterow
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/11/2002 K. Claver   Added code to translate the case and source types and set the
								 updated by info.
	2/1/2002  K. Claver   Added RETURN after each validation message so doesn't show multiple.
*****************************************************************************************/
String l_cCaseTypes = "", l_cSourceTypes = "", l_cTypeVal, l_cTemplateName, l_cTemplateKey
String l_cFindString = ""
String l_cCaseTypeCols[ 4 ] = { "cc_inquiry", "cc_issueconc", "cc_configurable", "cc_proactive" }
String l_cSourceTypeCols[ 4 ] = { "cc_member", "cc_group", "cc_provider", "cc_other" }
Integer l_nIndex, l_nRow = 0, l_nActive

IF in_save THEN
	IF THIS.GetItemStatus( row_nbr, 0, Primary! ) = DataModified! THEN
		//Get active/inactive for the row
		l_nActive = THIS.Object.active[ row_nbr ]		
		
		//Get case types
		FOR l_nIndex = 1 TO 4
			l_cTypeVal = THIS.GetItemString( row_nbr, l_cCaseTypeCols[ l_nIndex ] )
			
			IF NOT IsNull( l_cTypeVal ) AND Trim( l_cTypeVal ) <> "0" AND Trim( l_cTypeVal ) <> "" THEN
				l_cCaseTypes += l_cTypeVal
			END IF
		NEXT
		
		IF Trim( l_cCaseTypes ) = "" THEN
			SetNull( l_cCaseTypes )
		END IF
		
		//Check that there is a case type assigned for active templates
		IF IsNull( l_cCaseTypes ) AND NOT IsNull( l_nActive ) AND l_nActive = 1 THEN
			MessageBox( gs_AppName, "Please select one or more case types to associate this form with", StopSign!, OK! )
			Error.i_FWError = THIS.c_ValFailed
			RETURN
		ELSE
			THIS.Object.case_types[ row_nbr ] = l_cCaseTypes
				
			//Get source types if no prior errors
			FOR l_nIndex = 1 TO 4
				l_cTypeVal = THIS.GetItemString( row_nbr, l_cSourceTypeCols[ l_nIndex ] )
				
				IF NOT IsNull( l_cTypeVal ) AND Trim( l_cTypeVal ) <> "0" AND Trim( l_cTypeVal ) <> "" THEN
					l_cSourceTypes += l_cTypeVal
				END IF
			NEXT
			
			IF Trim( l_cSourceTypes ) = "" THEN
				SetNull( l_cSourceTypes )
			END IF
			
			IF IsNull( l_cSourceTypes ) AND NOT IsNull( l_nActive ) AND l_nActive = 1 THEN
				MessageBox( gs_AppName, "Please select one or more source types to associate this form with", StopSign!, OK! )
				Error.i_FWError = THIS.c_ValFailed
				RETURN
			ELSE
				THIS.Object.source_types[ row_nbr ] = l_cSourceTypes
						
				//Set the updated by and timestamp if no prior errors
				IF Error.i_FWError <> THIS.c_ValFailed THEN
					THIS.Object.updated_by[ row_nbr ] = OBJCA.WIN.fu_GetLogin( SQLCA )
					THIS.Object.updated_timestamp[ row_nbr ] = w_table_maintenance.fw_GetTimeStamp( )
				END IF
			END IF
		END IF
		
		//Check the template name
		l_cTemplateName = THIS.Object.template_name[ 1 ]
		IF IsNull( l_cTemplateName ) OR Trim( l_cTemplateName ) = "" THEN
			MessageBox( gs_AppName, "Please enter a descriptive template name", StopSign!, OK! )
			Error.i_FWError = THIS.c_ValFailed
			RETURN
		ELSE
			//Only check the name if the template is active
			IF NOT IsNull( l_nActive ) AND l_nActive = 1 THEN
				//See if the template name has already been used
				IF dw_template_list.RowCount( ) > 0 THEN
					l_cTemplateKey = Trim( THIS.Object.template_key[ row_nbr ] )
					
					IF NOT IsNull( l_cTemplateKey ) AND l_cTemplateKey <> "" THEN
						l_cFindString = "Upper(template_name) = '"+Upper( l_cTemplateName )+"' AND Trim(template_key) <> '"+l_cTemplateKey+"' AND active = 1"
					ELSE
						l_cFindString = "Upper(template_name) = '"+Upper( l_cTemplateName )+"' AND active = 1"
					END IF
					
					IF Trim( l_cFindString ) <> "" THEN
						l_nRow = dw_template_list.Find( l_cFindString, 1, dw_template_list.RowCount( ) )
					
						IF l_nRow > 0 THEN
							MessageBox( gs_AppName, "Template name already in use.  Please enter a unique template name", StopSign!, OK! )
							Error.i_FWError = THIS.c_ValFailed
							RETURN
						END IF
					END IF
				END IF
			END IF
		END IF
	END IF
END IF
end event

event itemchanged;call super::itemchanged;/*****************************************************************************************
   Event:      Itemchanged
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/28/2002 K. Claver   Added code to check if there are currently case forms with the case
								 type or source type set.
*****************************************************************************************/
Integer l_nCount, li_return
String l_cType, l_cTemplateKey, l_cTypeString
Boolean l_bDem

l_cTemplateKey = THIS.Object.template_key[ row ]

CHOOSE CASE Upper( dwo.Name )
	CASE "CC_INQUIRY"
		l_cType = "inquiry"
		l_bDem = FALSE
		l_cTypeString = "I"
	CASE "CC_CONFIGURABLE"
		l_cType = gs_configcasetype
		l_bDem = FALSE
		l_cTypeString = "M"
	CASE "CC_ISSUECONC"
		l_cType = "issue/concern"
		l_bDem = FALSE
		l_cTypeString = "C"
	CASE "CC_PROACTIVE"
		l_cType = "proactive"
		l_bDem = FALSE
		l_cTypeString = "P"
	CASE "CC_MEMBER"
		l_cType = "member"
		l_bDem = TRUE
		l_cTypeString = "C"
	CASE "CC_PROVIDER"
		l_cType = "provider"
		l_bDem = TRUE
		l_cTypeString = "P"
	CASE "CC_GROUP"
		l_cType = "employer group"
		l_bDem = TRUE
		l_cTypeString = "E"
	CASE "CC_OTHER"
		l_cType = "other type"
		l_bDem = TRUE
		l_cTypeString = "O"
	CASE "ACTIVE"
		IF IsNull( data ) OR data = "0" THEN
			SELECT Count( * )
			INTO :l_nCount
			FROM cusfocus.case_forms
			WHERE template_key = :l_cTemplateKey
			USING SQLCA;
			
			IF l_nCount > 0 THEN
				li_return = MessageBox( gs_AppName, "There are case forms created using this template.~r~n"+ &
								"Are you sure you want to set it to inactive?", Question!, YesNo! )
				IF li_return = 2 THEN
					RETURN 2
				END IF
			END IF
		END IF
END CHOOSE

IF NOT IsNull( data ) THEN
	IF Trim( data ) = "0" THEN
		IF l_bDem THEN
			SELECT Count( * )
			INTO :l_nCount
			FROM cusfocus.case_log cl, cusfocus.case_forms cf
			WHERE	cf.template_key = :l_cTemplateKey AND
					cl.source_type = :l_cTypeString AND
					cf.case_number = cl.case_number
			USING SQLCA;
		ELSE
			SELECT Count( * )
			INTO :l_nCount
			FROM cusfocus.case_log cl, cusfocus.case_forms cf
			WHERE	cf.template_key = :l_cTemplateKey AND
					cl.case_type = :l_cTypeString AND
					cf.case_number = cl.case_number
			USING SQLCA;
		END IF
		
		IF l_nCount > 0 THEN
			MessageBox( gs_AppName, "There are "+l_cType+" cases with forms created using this template.~r~n"+ &
							"This type cannot be deselected", StopSign!, OK! )
			RETURN 2
		END IF
	END IF
END IF
end event

type cb_preview from commandbutton within u_forms_maintenance
integer x = 3177
integer y = 720
integer width = 375
integer height = 112
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Preview"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Call the event to preview the form template.
*****************************************************************************************/
Integer l_nRow

l_nRow = dw_template_list.GetSelectedRow( 0 )

IF l_nRow > 0 THEN
	PARENT.Event Trigger ue_PreviewTemplate( l_nRow )
ELSE
	MessageBox( gs_AppName, "Please select a template to preview", StopSign!, OK! )
END IF
end event

type cb_delete from commandbutton within u_forms_maintenance
integer x = 3177
integer y = 508
integer width = 375
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Delete the row from the form_templates table.
*****************************************************************************************/
PARENT.Event Trigger ue_delete( )
end event

type dw_templates_in_pbl from u_dw_std within u_forms_maintenance
event ue_gettemplates ( )
integer x = 1431
integer y = 76
integer width = 1719
integer height = 360
integer taborder = 10
string dataobject = "d_templates_in_pbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_gettemplates;/*****************************************************************************************
   Event:      ue_GetTemplates
   Purpose:    Get the list of form templates from the forms pbl
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Created
*****************************************************************************************/
String l_cTemplateList, l_cTemplateName, l_cTemplateMod, l_cTemplateComment
String l_cModDate, l_cModTime
Long l_nNextLine = 0, l_nEndFirst, l_nEndSecond, l_nEndThird, l_nTemplateListLen
Integer l_nRow
DateTime l_dtModDateTime

THIS.Reset( )

IF Trim( PARENT.i_cLibrary ) <> "" AND NOT IsNull( PARENT.i_cLibrary ) THEN
	l_cTemplateList = LibraryDirectory( PARENT.i_cLibrary, DirDatawindow! )
	
	IF Trim( l_cTemplateList ) <> "" THEN
		l_nTemplateListLen = Len( l_cTemplateList )
		
		DO
			l_nEndFirst = Pos( l_cTemplateList, "~t", ( l_nNextLine + 1 ) )
			l_cTemplateName = Mid( l_cTemplateList, ( l_nNextLine + 1 ), ( l_nEndFirst - ( l_nNextLine + 1 ) ) )
			l_nEndSecond = Pos( l_cTemplateList, "~t", ( l_nEndFirst + 1 ) )
			l_cTemplateMod = Mid( l_cTemplateList, ( l_nEndFirst + 1 ), ( ( l_nEndSecond - l_nEndFirst ) - 1 ) )
			l_nNextLine = Pos( l_cTemplateList, "~n", l_nEndSecond )
			l_nEndThird = l_nNextLine
			IF l_nEndThird = 0 THEN
				l_nEndThird = l_nTemplateListLen
			END IF
			l_cTemplateComment = Mid( l_cTemplateList, ( l_nEndSecond + 1 ), ( ( l_nEndThird - l_nEndSecond ) - 2 ) )	
			
			l_nRow = THIS.InsertRow( 0 )
			
			THIS.Object.template_name[ l_nRow ] = l_cTemplateName
			THIS.Object.template_comment[ l_nRow ] = l_cTemplatecomment
			
			l_cModDate = Mid( l_cTemplateMod, 1, ( Pos( l_cTemplateMod, " " ) - 1 ) )
			l_cModTime = Mid( l_cTemplateMod, ( Pos( l_cTemplateMod, " " ) + 1 ) )
			l_dtModDateTime = DateTime( Date( l_cModDate ), Time( l_cModTime ) )
			
			THIS.Object.template_modified[ l_nRow ] = l_dtModDateTime
		LOOP WHILE l_nNextLine < l_nTemplateListLen
		
		THIS.Sort( )
		
		THIS.SelectRow( 1, TRUE )
		cb_import.Enabled = TRUE
		m_table_maintenance.m_edit.m_new.Enabled = TRUE
	ELSE
		cb_import.Enabled = FALSE
		m_table_maintenance.m_edit.m_new.Enabled = FALSE
	END IF
ELSE
	cb_import.Enabled = FALSE
	m_table_maintenance.m_edit.m_new.Enabled = FALSE
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Please see PowerClass documentation for this event
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver   Added code to set the datawindow options.
*****************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						THIS.c_NullDW, &
						THIS.c_SortClickedOK+ &
						THIS.c_NoRetrieveOnOpen+ &
						THIS.c_NoEnablePopup+ &
						THIS.c_NoMenuButtonActivation+ &
						THIS.c_SelectOnClick )
end event

type st_5 from statictext within u_forms_maintenance
integer x = 18
integer y = 436
integer width = 709
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Imported Form Templates:"
boolean focusrectangle = false
end type

type st_4 from statictext within u_forms_maintenance
integer x = 1435
integer y = 8
integer width = 1147
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Form Templates in InfoMaker Library(PBL):"
boolean focusrectangle = false
end type

type cb_refresh from commandbutton within u_forms_maintenance
integer x = 3177
integer y = 320
integer width = 375
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Refresh List"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Refresh the templates list datawindow.
*****************************************************************************************/
dw_templates_in_pbl.Event Trigger ue_GetTemplates( )
end event

type st_3 from statictext within u_forms_maintenance
integer x = 18
integer y = 288
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "InfoMaker Comment:"
boolean focusrectangle = false
end type

type st_2 from statictext within u_forms_maintenance
integer x = 18
integer y = 144
integer width = 914
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Current InfoMaker Form Template:"
boolean focusrectangle = false
end type

type cb_export from commandbutton within u_forms_maintenance
integer x = 3177
integer y = 152
integer width = 375
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Export"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Export the current datawindow syntax and create a datawindow object
								 in the form templates pbl.
	07/01/03 M. Caruso    Removed code to disable this button after Exporting a template.
*****************************************************************************************/
String l_cTemplate, l_cComment, l_cErrors, l_cDWSyntax, l_cTemplateList
Integer l_nRV, l_nRow

IF Trim( sle_template_name.Text ) = "" THEN
	MessageBox( gs_AppName, "Please select a form template", StopSign!, OK! )
	dw_template_list.SetFocus( )
ELSE
	//Import the datawindow into the library
	l_cTemplate = Trim( sle_template_name.Text )
	l_cComment = Trim( sle_template_comments.Text )
	
	//Check if the library is defined
	IF Trim( PARENT.i_cLibrary ) <> "" AND NOT IsNull( PARENT.i_cLibrary ) THEN
		l_cTemplateList = LibraryDirectory( PARENT.i_cLibrary, DirDatawindow! )
	
		//Check if the object already exists
		IF Trim( l_cTemplateList ) <> "" THEN
			IF Pos( Upper( l_cTemplateList ), Upper( l_cTemplate ) ) > 0 THEN
				l_nRV = MessageBox( gs_AppName, "Overwrite existing form template named "+l_cTemplate+"?", &
										  Question!, YesNo! )
			ELSE
				l_nRV = 1
			END IF
		ELSE
			l_nRV = 1
		END IF
		
		//Import into the library
		IF l_nRV = 1 THEN
			l_cDWSyntax = dw_template_preview.Object.Datawindow.Syntax
			
			l_nRV = LibraryImport( PARENT.i_cLibrary, l_cTemplate, ImportDatawindow!, l_cDWSyntax, &
										  l_cErrors, l_cComment )
										  
			IF l_nRV < 0 THEN
				MessageBox( gs_AppName, "Error importing form template object into form template pbl.~r~n "+l_cErrors, &
								StopSign!, OK! )
			ELSE
				dw_templates_in_pbl.Event Trigger ue_GetTemplates( )
				
				//Try to find the matching report in the list and scroll to it.
				IF dw_templates_in_pbl.RowCount( ) > 0 THEN
					l_nRow = dw_templates_in_pbl.Find( "template_name = '"+Trim( sle_template_name.Text )+"'", 1, dw_templates_in_pbl.RowCount( ) )
					
					IF l_nRow > 0 THEN
						dw_templates_in_pbl.ScrollToRow( l_nRow )
						dw_templates_in_pbl.SelectRow( 0, FALSE )
						dw_templates_in_pbl.SelectRow( l_nRow, TRUE )			
					END IF
				END IF
				
				cb_import.SetFocus( )
			END IF
		END IF
	ELSE
		MessageBox( gs_AppName, "Form template library not defined in system options", StopSign!, OK! )
	END IF
END IF
end event

type cb_import from commandbutton within u_forms_maintenance
integer x = 3177
integer y = 36
integer width = 375
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Import"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Imports the template from the form templates pbl.
*****************************************************************************************/
PARENT.Event Trigger ue_import( )
end event

type sle_template_comments from singlelineedit within u_forms_maintenance
integer x = 18
integer y = 352
integer width = 1390
integer height = 80
integer taborder = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_template_name from singlelineedit within u_forms_maintenance
integer x = 18
integer y = 208
integer width = 1390
integer height = 80
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_template_location from singlelineedit within u_forms_maintenance
integer x = 18
integer y = 64
integer width = 1390
integer height = 80
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within u_forms_maintenance
integer x = 18
integer width = 635
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "InfoMaker Library(PBL):"
boolean focusrectangle = false
end type

type cb_map from commandbutton within u_forms_maintenance
integer x = 3177
integer y = 1452
integer width = 375
integer height = 112
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Map Fields"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Open the window to map the fields in the form template to the 
								 fields in the form_properties table.
*****************************************************************************************/
Integer l_nRV

FWCA.MGR.fu_OpenWindow( w_form_field_mapping, PARENT )

IF Trim( Upper( Message.StringParm ) ) = "CHANGE" THEN
	//Set the updated by and timestamp
	dw_template_properties.Object.updated_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
	dw_template_properties.Object.updated_timestamp[ 1 ] = w_table_maintenance.fw_GetTimeStamp( )
	
	//Save the template row
	PARENT.Event Trigger ue_save( )
END IF
end event

type dw_template_list from u_dw_std within u_forms_maintenance
integer x = 18
integer y = 504
integer width = 3136
integer height = 332
integer taborder = 20
string dataobject = "d_template_list"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_pickedrow;call super::pcd_pickedrow;/*****************************************************************************************
   Event:      pcd_PickedRow
   Purpose:    Please see PowerClass documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Added code to set the template key instance variable and preview
								 the template.
*****************************************************************************************/
Integer l_nRow, l_nRV, l_nSelectedRow[ ], l_nDataPos
String l_cDWSyntax, l_cKey, l_cTemplateName
Blob l_blTemp

IF selected_rows[ 1 ] > 0 THEN
	l_nRow = selected_rows[ 1 ]
	
	//Set the template name and comments
	sle_template_name.Text = THIS.Object.dw_header[ l_nRow ]
	sle_template_comments.Text = THIS.Object.dw_comments[ l_nRow ]
	
	//Make sure the key is populated before attempting to retrieve image
	l_cKey = THIS.Object.template_key[ l_nRow ]
	
	IF NOT IsNull( l_cKey ) AND Trim( l_cKey ) <> "" THEN
		PARENT.i_cTemplateKey = l_cKey
		
		SELECTBLOB template_image
		INTO :l_blTemp
		FROM cusfocus.form_templates
		WHERE template_key = :PARENT.i_cTemplateKey
		USING SQLCA;
		
		IF SQLCA.SQLCode <> 0 THEN
			MessageBox( gs_AppName, "Error retrieving form template from the database", StopSign!, OK! )
		ELSE
			l_cDWSyntax = String( l_blTemp )

			// Make sure we converted it correctly - RAP 11/4/08
			l_nDataPos = Pos( l_cDWSyntax, "release" )
			IF l_nDataPos = 0 THEN
				l_cDWSyntax = string(l_blTemp, EncodingANSI!)
			END IF
			
			l_nRV = dw_template_preview.Create( l_cDWSyntax )
			
			IF l_nRV <> 1 THEN
				MessageBox( gs_AppName, "Error creating the template", StopSign!, OK! )
				cb_preview.Enabled = FALSE
				cb_map.Enabled = FALSE
				cb_tab.Enabled = FALSE
			ELSE
				cb_preview.Enabled = TRUE
				cb_map.Enabled = TRUE
				cb_tab.Enabled = TRUE
				
				IF dw_templates_in_pbl.RowCount( ) > 0 THEN
					l_cTemplateName = sle_template_name.Text
					l_nRow = dw_templates_in_pbl.Find( "template_name = '"+l_cTemplateName+"'", 1, dw_templates_in_pbl.RowCount( ) )
					
					IF l_nRow > 0 THEN
						l_nSelectedRow[ 1 ] = l_nRow
						dw_templates_in_pbl.fu_SetSelectedRows( 1, l_nSelectedRow, dw_templates_in_pbl.c_IgnoreChanges, &
																			 dw_templates_in_pbl.c_NoRefreshChildren )
					END IF
				END IF	
			END IF
		END IF
	END IF
END IF
			
	
end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
   Event:      DoubleClicked
   Purpose:    Please see PB documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Added code to call the event to preview the template
*****************************************************************************************/
PARENT.Event Trigger ue_PreviewTemplate( row )
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Please see PowerClass documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/11/2002 K. Claver   Added function call to set the options for the datawindow.
*****************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  THIS.c_NullDW, &
						  THIS.c_NewOK+ &
						  THIS.c_DeleteOK+ &
						  THIS.c_SelectOnRowFocusChange+ &
						  THIS.c_ModifyOnSelect+ &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_SortClickedOK+ &
						  THIS.c_NoMenuButtonActivation )
						  


end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/11/2002 K. Claver   Added code to retrieve the datawindow
*****************************************************************************************/
Long l_nRV

l_nRV = THIS.Retrieve( )

CHOOSE CASE l_nRV
	CASE IS < 0
   	Error.i_FWError = THIS.c_Fatal	
	CASE 0
		cb_delete.Enabled = FALSE
		m_table_maintenance.m_edit.m_delete.Enabled = FALSE
		cb_export.Enabled = FALSE
	CASE ELSE
		//Set the template name and comments
		sle_template_name.Text = THIS.Object.dw_header[ 1 ]
		sle_template_comments.Text = THIS.Object.dw_comments[ 1 ]
		
		cb_delete.Enabled = TRUE
		m_table_maintenance.m_edit.m_delete.Enabled = TRUE
		
		IF Trim( PARENT.i_cLibrary ) <> "" AND NOT IsNull( PARENT.i_cLibrary ) THEN
			cb_export.Enabled = TRUE
		ELSE
			cb_export.Enabled = FALSE
		END IF
END CHOOSE
end event

type dw_template_preview from u_dw_std within u_forms_maintenance
integer x = 18
integer y = 1112
integer width = 2171
integer height = 428
integer taborder = 30
string dataobject = ""
boolean border = false
end type

event itemchanged;call super::itemchanged;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/11/2002 K. Claver   Added function call to set the options for the datawindow
*****************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  THIS.c_NullDW, &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_NoMenuButtonActivation )
end event

