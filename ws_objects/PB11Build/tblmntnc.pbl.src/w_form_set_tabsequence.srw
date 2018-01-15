$PBExportHeader$w_form_set_tabsequence.srw
forward
global type w_form_set_tabsequence from w_response_std
end type
type cb_cancel from commandbutton within w_form_set_tabsequence
end type
type cb_ok from commandbutton within w_form_set_tabsequence
end type
type dw_field_set_order from u_dw_std within w_form_set_tabsequence
end type
end forward

global type w_form_set_tabsequence from w_response_std
integer width = 1669
integer height = 1348
string title = "Form Template Field Tab Order"
cb_cancel cb_cancel
cb_ok cb_ok
dw_field_set_order dw_field_set_order
end type
global w_form_set_tabsequence w_form_set_tabsequence

type variables
u_forms_maintenance i_uoParentObject
end variables

on w_form_set_tabsequence.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_field_set_order=create dw_field_set_order
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_field_set_order
end on

on w_form_set_tabsequence.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_field_set_order)
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

event closequery;/*****************************************************************************************
   Event:      CloseQuery
   Purpose:    Please see PB documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/1/2002 K. Claver    Overrode foundation class code to prevent from attempting to save
								 the datawindow to the database.  Also added code to query the user
								 if they would like to save the changes made to the datawindow.
*****************************************************************************************/
Integer l_nRow, l_nRV

dw_field_set_order.AcceptText( )
l_nRow = dw_field_set_order.GetNextModified( 0, Primary! )

IF l_nRow > 0 THEN
	l_nRV = MessageBox( gs_AppName, "Do you want to save changes before closing the window?", &
		  					  Question!, YesNoCancel! )
	
	IF l_nRV = 1 THEN
		IF dw_field_set_order.fu_Validate( ) = 0 THEN
			//Call the event to apply the tab sequence changes
			dw_field_set_order.Event Trigger ue_SetTabSequence( )
			Message.StringParm = "CHANGE"
		ELSE
			RETURN 1
		END IF
	ELSEIF l_nRV = 2 THEN
		Message.StringParm = "NOCHANGE"		
	ELSEIF l_nRV = 3 THEN
		//Don't let the window close
		RETURN 1
	END IF
END IF
end event

type cb_cancel from commandbutton within w_form_set_tabsequence
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
	1/31/2002 K. Claver    Added code to close the window.
*****************************************************************************************/
Integer l_nRV, l_nRow

dw_field_set_order.AcceptText( )
l_nRow = dw_field_set_order.GetNextModified( 0, Primary! )

IF l_nRow > 0 THEN
	l_nRV = MessageBox( gs_AppName, "Do you want to save changes before closing the window?", &
		  					  Question!, YesNoCancel! )
	
	IF l_nRV = 1 THEN
		//Save the tab order then close
		cb_ok.Event Trigger clicked( )	
	ELSEIF l_nRV = 2 THEN
		//Just Close
		dw_field_set_order.fu_ResetUpdate( )
		CloseWithReturn( PARENT, "NOCHANGE" )
	END IF
ELSE
	CloseWithReturn( PARENT, "NOCHANGE" )
END IF
end event

type cb_ok from commandbutton within w_form_set_tabsequence
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
Integer l_nModifiedRow

IF dw_field_set_order.fu_Validate( ) = 0 THEN
	l_nModifiedRow = dw_field_set_order.GetNextModified( 0, Primary! )
	dw_field_set_order.fu_ResetUpdate( )
	
	IF l_nModifiedRow > 0 THEN
		//Call the event to apply the tab sequence changes
		dw_field_set_order.Event Trigger ue_SetTabSequence( )
		
		//Close the window
		CloseWithReturn( PARENT, "CHANGE" )
	ELSE
		CloseWithReturn( PARENT, "NOCHANGE" )
	END IF
END IF
end event

type dw_field_set_order from u_dw_std within w_form_set_tabsequence
event ue_getfieldlist ( )
event ue_settabsequence ( )
integer x = 18
integer y = 8
integer width = 1618
integer height = 1100
integer taborder = 10
string dataobject = "d_field_set_order"
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
Integer l_nIndex, l_nTabSequence, l_nColCount, l_nRow
u_dw_std l_dwTemplate
String l_cFieldName

l_dwTemplate = i_uoParentObject.dw_template_preview

l_nColCount = Integer( l_dwTemplate.Object.Datawindow.Column.Count )

IF l_nColCount > 0 THEN
	FOR l_nIndex = 1 TO l_nColCount
		IF l_dwTemplate.Describe( "#"+String( l_nIndex )+".Visible" ) = "1" THEN
			//Get the column name and edit limit
			l_cFieldName = Upper( l_dwTemplate.Describe( "#"+String( l_nIndex )+".Name" ) )
			l_nTabSequence = Integer( l_dwTemplate.Describe( "#"+String( l_nIndex )+".TabSequence" ) )
			
			l_nRow = THIS.InsertRow( 0 )
			THIS.Object.template_field[ l_nRow ] = l_cFieldName
			THIS.Object.field_order[ l_nRow ] = l_nTabSequence
			THIS.SetItemStatus( l_nRow, 0, Primary!, NotModified! )
		END IF
	NEXT
	
	//Sort
	THIS.Sort( )
END IF
end event

event ue_settabsequence;/*****************************************************************************************
   Event:      ue_SetTabSequence
   Purpose:    Set the tab sequences in the form template
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/31/2002 K. Claver   Created
*****************************************************************************************/
Integer l_nIndex, l_nSequence
String l_cColumn, l_cError
u_dw_std l_dwTemplate

l_dwTemplate = i_uoParentObject.dw_template_preview

//Set the new tab sequences
IF THIS.RowCount( ) > 0 THEN
	FOR l_nIndex = 1 TO THIS.RowCount( )
		l_cColumn = THIS.object.template_field[ l_nIndex ]
		l_nSequence = THIS.Object.field_order[ l_nIndex ]
		
		l_cError = l_dwTemplate.Modify( l_cColumn+".TabSequence='"+String( l_nSequence )+"'" )
		
		IF NOT IsNull( l_cError ) AND Trim( l_cError ) <> "" THEN
			MessageBox( gs_AppName, "Failed to set tab sequence.~r~nError Returned:~r~n"+l_cError, StopSign!, OK! )
		END IF
	NEXT
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
						  THIS.c_NoRetrieveOnOpen+ &
						  THIS.c_NewOK+ &
						  THIS.c_ModifyOK+ &
						  THIS.c_ModifyOnOpen+ &
						  THIS.c_SelectOnRowFocusChange+ &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_NoMenuButtonActivation )
						  
//Get the field list and tab sequences
THIS.Event Trigger ue_GetFieldList( )
end event

event pcd_validaterow;call super::pcd_validaterow;/*****************************************************************************************
   Event:      pcd_ValidateRow
   Purpose:    Please see PowerClass documentation for this event.
	
	Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/1/2002 K. Claver    Added code to check if a tab sequence is already used
*****************************************************************************************/
Integer l_nTabSequence
String l_cFieldName

IF THIS.RowCount( ) > 1 THEN
	l_nTabSequence = THIS.Object.field_order[ row_nbr ]
	l_cFieldName = THIS.Object.template_field[ row_nbr ]
	
	IF NOT IsNull( l_nTabSequence ) AND l_nTabSequence <> 0 THEN
		IF THIS.Find( "field_order = "+String( l_nTabSequence )+" AND Trim(template_field) <> '"+l_cFieldName+"'", &
						  1, THIS.RowCount( ) ) > 0 THEN
			MessageBox( gs_AppName, "Tab Sequence "+String( l_nTabSequence )+" is already in use.  Please select another value", &
							StopSign!, OK! )
			Error.i_FWError = c_ValFailed
		END IF
	END IF
END IF
end event

