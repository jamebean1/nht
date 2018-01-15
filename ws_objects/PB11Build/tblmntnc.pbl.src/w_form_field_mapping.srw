$PBExportHeader$w_form_field_mapping.srw
forward
global type w_form_field_mapping from w_response_std
end type
type cb_cancel from commandbutton within w_form_field_mapping
end type
type cb_ok from commandbutton within w_form_field_mapping
end type
type dw_field_mappings from u_dw_std within w_form_field_mapping
end type
end forward

global type w_form_field_mapping from w_response_std
integer width = 1669
integer height = 1348
string title = "Form Template Field Mappings"
cb_cancel cb_cancel
cb_ok cb_ok
dw_field_mappings dw_field_mappings
end type
global w_form_field_mapping w_form_field_mapping

type variables
u_forms_maintenance i_uoParentObject
end variables

on w_form_field_mapping.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_field_mappings=create dw_field_mappings
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_field_mappings
end on

on w_form_field_mapping.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_field_mappings)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_SetOptions
   Purpose:    Please see PowerClass documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Added code to set the parent object instance variable to the object
								 passed.
*****************************************************************************************/
IF IsValid( Message.PowerObjectParm ) AND NOT IsNull( Message.PowerObjectParm ) THEN
	i_uoParentObject = Message.PowerObjectParm
	cb_ok.Enabled = TRUE
ELSE
	cb_ok.Enabled = FALSE
END IF
end event

type cb_cancel from commandbutton within w_form_field_mapping
integer x = 1225
integer y = 1124
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Added code to close the window.
*****************************************************************************************/
Integer l_nRV, l_nRow

dw_field_mappings.AcceptText( )
l_nRow = dw_field_mappings.GetNextModified( 0, Primary! )

IF l_nRow > 0 THEN
	l_nRV = MessageBox( gs_AppName, "Do you want to save changes before closing the window?", &
		  					  Question!, YesNoCancel! )
	
	IF l_nRV = 1 THEN
		//Save the tab order then close
		cb_ok.Event Trigger clicked( )	
	ELSEIF l_nRV = 2 THEN
		//Just Close
		dw_field_mappings.fu_ResetUpdate( )
		CloseWithReturn( PARENT, "NOCHANGE" )
	END IF
ELSE
	CloseWithReturn( PARENT, "NOCHANGE" )
END IF
end event

type cb_ok from commandbutton within w_form_field_mapping
integer x = 795
integer y = 1124
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Added code to save the changes and close the window.
*****************************************************************************************/
Integer l_nDeleteRows[ ], l_nRow, l_nDeleteCount = 0, l_nRV = 0
String l_cStoreField

//Make sure all changes are committed to the datawindow
dw_field_mappings.AcceptText( )

//Get rid of the rows that do not have a field mapped.
IF dw_field_mappings.RowCount( ) > 0 THEN
	FOR l_nRow = 1 TO dw_field_mappings.RowCount( )
		l_cStoreField = dw_field_mappings.Object.property_field[ l_nRow ]
		
		IF IsNull( l_cStoreField ) OR Trim( l_cStoreField ) = "" THEN
			l_nDeleteCount++
			l_nDeleteRows[ l_nDeleteCount ] = l_nRow
		END IF
	NEXT
	
	IF l_nDeleteCount > 0 THEN
		l_nRV = dw_field_mappings.fu_Delete( l_nDeleteCount, &
														 l_nDeleteRows, &
														 dw_field_mappings.c_IgnoreChanges )														 
	END IF
	
	//Save the datawindow if no errors
	IF l_nRV = 0 THEN
		l_nRV = dw_field_mappings.fu_Save( dw_field_mappings.c_SaveChanges )
		
		IF l_nRV <> 0 THEN
			MessageBox( gs_AppName, "Error saving field mappings", StopSign!, OK! )
		ELSE
			CloseWithReturn( PARENT, "CHANGE" )
		END IF
	ELSE
		MessageBox( gs_AppName, "Error cleaning up fields that were not mapped", StopSign!, OK! )
	END IF
END IF
			
end event

type dw_field_mappings from u_dw_std within w_form_field_mapping
event ue_getfieldlist ( )
integer x = 14
integer y = 8
integer width = 1618
integer height = 1100
integer taborder = 10
string dataobject = "d_field_mappings"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_getfieldlist;/*****************************************************************************************
   Event:      ue_GetFieldList
   Purpose:    Get the fields defined in the template and populate the mappings datawindow.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Created
*****************************************************************************************/
Integer l_nIndex, l_nRow, l_nFieldLimit
u_dw_std l_dwTemplate
Boolean l_bAddOK = TRUE
String l_cFieldName

l_dwTemplate = i_uoParentObject.dw_template_preview

FOR l_nIndex = 1 TO Integer( l_dwTemplate.Object.Datawindow.Column.Count )
	IF l_dwTemplate.Describe( "#"+String( l_nIndex )+".Visible" ) = "1" THEN
		//Get the column name and edit limit
		l_cFieldName = Upper( l_dwTemplate.Describe( "#"+String( l_nIndex )+".Name" ) )
		l_nFieldLimit = Integer( l_dwTemplate.Describe( "#"+String( l_nIndex )+".Edit.Limit" ) )
		
		IF THIS.RowCount( ) > 0 THEN
			IF THIS.Find( "Upper(template_field) = '"+l_cFieldName+"'", 1, THIS.RowCount( ) ) > 0 THEN
				l_bAddOK = FALSE
			END IF
		END IF
		
		//Add it to the list if not found
		IF l_bAddOK THEN
			l_nRow = THIS.InsertRow( 0 )
			THIS.Object.template_field[ l_nRow ] = l_cFieldName
			THIS.Object.template_key[ l_nRow ] = i_uoParentObject.i_cTemplateKey
			THIS.Object.form_field_limit[ l_nRow ] = l_nFieldLimit
			THIS.SetItemStatus( l_nRow, 0, Primary!, NotModified! )
		END IF
		
		l_bAddOK = TRUE
	END IF
NEXT
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_Retrieve
   Purpose:    Please see PowerClass documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Added code to retrieve the datawindow for the template key.
*****************************************************************************************/
IF Trim( i_uoParentObject.i_cTemplateKey ) <> "" AND NOT IsNull( i_uoParentObject.i_cTemplateKey ) THEN
	THIS.Retrieve( i_uoParentObject.i_cTemplateKey )
	
	//Clean up orphaned fields and/or add new ones.
	THIS.Event Trigger ue_GetFieldList( )
END IF
end event

event itemchanged;call super::itemchanged;/*****************************************************************************************
   Event:      ItemChanged
   Purpose:    Please see PB documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/8/2002 K. Claver    Added code to check if a field is already mapped.
*****************************************************************************************/
Integer l_nFieldLimit

IF THIS.RowCount( ) > 1 THEN
	IF NOT IsNull( data ) AND Trim( data ) <> "" THEN
		IF THIS.Find( "property_field = '"+data+"'", 1, THIS.RowCount( ) ) > 0 THEN
			MessageBox( gs_AppName, "Property field "+data+" is already mapped.  Please select another field", &
							StopSign!, OK! )
			RETURN 2
		END IF
		
		//Check the field limit and display a warning if the field limit exceeds 50 characters
		//  or is set to unlimited.
		l_nFieldLimit = THIS.Object.form_field_limit[ row ]
		IF l_nFieldLimit > 50 OR l_nFieldLimit = 0 THEN
			MessageBox( gs_AppName, "The limit set for the form field is either greater than 50 or 0(unlimited).~r~n"+ &
							"Data entered into the form field will be truncated to 50 characters when the~r~nform is saved" )
		END IF
	END IF
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/11/2002 K. Claver   Added function call to set the options for the datawindow
*****************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  THIS.c_NullDW, &
						  THIS.c_NewOK+ &
						  THIS.c_ModifyOK+ &
						  THIS.c_DeleteOK+ &
						  THIS.c_ModifyOnOpen+ &
						  THIS.c_SelectOnRowFocusChange+ &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_NoMenuButtonActivation )
end event

event pcd_save;call super::pcd_save;/*****************************************************************************************
   Event:      pcd_Save
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/1/2002 K. Claver    Set the Message.StringParm to show changed to calling object.  
*****************************************************************************************/

//If hits this event, know something has changed
Message.StringParm = "CHANGE"
end event

