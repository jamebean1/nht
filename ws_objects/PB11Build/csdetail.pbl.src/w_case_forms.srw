$PBExportHeader$w_case_forms.srw
forward
global type w_case_forms from w_main_std
end type
type st_3 from statictext within w_case_forms
end type
type p_1 from picture within w_case_forms
end type
type st_1 from statictext within w_case_forms
end type
type cb_print from commandbutton within w_case_forms
end type
type cb_reset from commandbutton within w_case_forms
end type
type cb_ok from commandbutton within w_case_forms
end type
type cb_cancel from commandbutton within w_case_forms
end type
type ln_1 from line within w_case_forms
end type
type ln_2 from line within w_case_forms
end type
type st_2 from statictext within w_case_forms
end type
type ln_3 from line within w_case_forms
end type
type ln_4 from line within w_case_forms
end type
type dw_case_form_info from u_dw_std within w_case_forms
end type
type dw_case_form from datawindow within w_case_forms
end type
end forward

global type w_case_forms from w_main_std
integer x = 0
integer y = 0
integer width = 3707
integer height = 2196
string title = "Case Form"
string menuname = "m_case_forms"
event ue_postclose ( )
event ue_refreshlist ( )
event ue_settitle ( string a_ctemplatekey )
event type integer ue_saveform ( )
event ue_displayspeccomments ( )
event type integer ue_checkchange ( string a_ctype )
event ue_setlastreviewed ( )
st_3 st_3
p_1 p_1
st_1 st_1
cb_print cb_print
cb_reset cb_reset
cb_ok cb_ok
cb_cancel cb_cancel
ln_1 ln_1
ln_2 ln_2
st_2 st_2
ln_3 ln_3
ln_4 ln_4
dw_case_form_info dw_case_form_info
dw_case_form dw_case_form
end type
global w_case_forms w_case_forms

type variables
String i_cCaseNumber, i_cCaseType, i_cSourceType
String i_cTemplateKey, i_cFormKey, i_cFormData, i_cItemErrMsg
Boolean i_bView = FALSE, i_bEdit = FALSE, i_bNoSavePressed = FALSE, i_bCancel = FALSE
Boolean i_bLastReviewChanged = FALSE, i_bUpdatedChanged = FALSE
Integer i_nConfidLevel, i_nFormConfidLevel
DWItemStatus i_dwisPreUpdateStatus = NotModified!
m_case_forms i_mMenu
end variables

forward prototypes
public function integer fw_saveonclose ()
end prototypes

event ue_postclose;//**********************************************************************************************
//
//  Event:   ue_PostClose
//  Purpose: Allow other processing(refresh of the forms list on the tab) to finish before close 
//				 the window. 
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/17/2002 K. Claver   Created
//**********************************************************************************************
Close( THIS )
end event

event ue_refreshlist;//**********************************************************************************************
//
//  Event:   ue_RefreshList
//  Purpose: Refresh the list of forms for the case
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/17/2002 K. Claver   Created
//**********************************************************************************************
u_dw_std l_dwTemp

IF IsValid( w_create_maintain_case ) THEN
	IF IsValid( w_create_maintain_case.i_uoCaseDetails ) THEN
		IF IsValid( w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_forms ) THEN
			w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_forms.dw_case_form_list.fu_Retrieve( l_dwTemp.c_IgnoreChanges, &
																																				 l_dwTemp.c_ReselectRows )
		END IF
	END IF
END IF
end event

event ue_settitle;//**********************************************************************************************
//
//  Event:   ue_SetTitle
//  Purpose: Set the title of the window
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/17/2002 K. Claver   Created
//**********************************************************************************************
String l_cTemplateName

IF Trim( a_cTemplateKey ) = "" THEN
	THIS.Title = ( "Case Form - "+THIS.i_cCaseNumber+" - Add/Edit" )
ELSE
	SELECT template_name
	INTO :l_cTemplateName
	FROM cusfocus.form_templates
	WHERE template_key = :a_cTemplateKey
	USING SQLCA;
	
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox( gs_AppName, "Error obtaining the form name" )
		l_cTemplateName = "Not Known"
	END IF
	
	THIS.Title = ( "Case Form - "+THIS.i_cCaseNumber+" - "+l_cTemplateName )
	
	IF THIS.i_bView THEN
		THIS.Title += " - View Only"
	ELSE
		THIS.Title += " - Add/Edit"
	END IF
END IF
end event

event ue_saveform;//**********************************************************************************************
//
//  Event:   ue_SaveForm
//  Purpose: Processes the form field mappings and saves the form info and form.
//
//  Returns: Integer - 1 for Success, -1 for Error
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Created
//*********************************************************************************************
Integer l_nRV
DWItemStatus l_dwisFormStatus

//If in edit or view mode, re-set the last reviewed by and date/time values
IF dw_case_form_info.RowCount( ) > 0 THEN	
	//Do the form mapping.  Need to do this before the save of the form info
	//  datawindow as these values are saved in the form info datawindow.
	//  AcceptText for the form is done in this event so don't need to call
	//  it in this event
	l_nRV = dw_case_form.Event Trigger ue_ProcFormFields( )
	
	IF l_nRV = 1 THEN
		//Make sure all changes are accepted into the info datawindow
		dw_case_form_info.AcceptText( )
		
		//Need to insert the row into the database before attempt to add the file
		l_nRV = dw_case_form_info.fu_Save( dw_case_form_info.c_SaveChanges )
		
		IF l_nRV <> 0 THEN
			MessageBox( gs_AppName, "Failed to save the form information to the database", StopSign!, OK! )
			Error.i_FWError = c_Fatal
		ELSE
			//Assume success
			Error.i_FWError = c_Success
			
			l_dwisFormStatus = dw_case_form.GetItemStatus( 1, 0, Primary! )
			IF l_dwisFormStatus = DataModified! OR l_dwisFormStatus = NewModified! THEN
				//Form image hasn't been saved yet.  Probably just changed the form.
				//  Force an update of the info datawindow.  The i_bUpdatedChanged instance
				//  variable will be false if just made changes to the form as the
				//  pcd_savebefore event will not have fired for the info datawindow.
				IF NOT THIS.i_bUpdatedChanged THEN
					dw_case_form_info.Object.updated_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
					dw_case_form_info.Object.updated_timestamp[ 1 ] = THIS.fw_GetTimeStamp( )
					THIS.i_bUpdatedChanged = TRUE
					
					l_nRV = dw_case_form_info.fu_Save( dw_case_form_info.c_SaveChanges )
					
					IF l_nRV = -1 THEN
						MessageBox( gs_AppName, "Failed to save the form to the database", StopSign!, OK! )
						Error.i_FWError = c_Fatal
					ELSE
						Error.i_FWError = c_Success
					END IF
				END IF
			END IF
		END IF
	END IF
ELSE
	l_nRV = -1
END IF

//Reset the i_bUpdatedChanged instance variable if case saved without closing window
THIS.i_bUpdatedChanged = FALSE

RETURN l_nRV
end event

event ue_displayspeccomments;//**********************************************************************************************
//
//  Event:   ue_DisplaySpecComments
//  Purpose: To display special create or review comments attached to the form
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/18/2002 K. Claver   Created
//**********************************************************************************************
String l_cSpecCreateComments, l_cSpecReviewComments

IF THIS.i_bView OR THIS.i_bEdit THEN
	IF dw_case_form_info.RowCount( ) > 0 THEN
		//Display special review comments, if they exist.
		l_cSpecReviewComments = dw_case_form_info.Object.special_review_comments[ 1 ]					
		IF NOT IsNull( l_cSpecReviewComments ) AND Trim( l_cSpecReviewComments ) <> "" THEN
			MessageBox( gs_AppName, "Special Review Comments:~r~n"+l_cSpecReviewComments )
		END IF
	END IF
ELSE
	SELECT special_create_comments
	INTO :l_cSpecCreateComments
	FROM cusfocus.form_templates
	WHERE template_key = :THIS.i_cTemplateKey
	USING SQLCA;
	
	IF NOT IsNull( l_cSpecCreateComments ) AND Trim( l_cSpecCreateComments ) <> "" THEN
		MessageBox( gs_AppName, "Special Create Comments:~r~n"+l_cSpecCreateComments )
	END IF
END IF
end event

event ue_checkchange;//**********************************************************************************************
//
//  Event:   ue_CheckChange
//  Purpose: Check for changes and ask the user if they want to close without saving.
//
//	 Parameters: String - a_cType - Type of message to prompt
//  Returns: Integer - 1 for Success, -1 for Error
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/29/2002 K. Claver   Created
//**********************************************************************************************
DWItemStatus l_dwisStatus
Integer l_nRV = 1, l_nMessageRV

IF dw_case_form.RowCount( ) > 0 AND dw_case_form_info.RowCount( ) > 0 THEN
	//Make sure the data is accepted into the datawindow
	l_nRV = dw_case_form.Event Trigger ue_CheckFields( FALSE )
	IF l_nRV = -1 THEN
		//Simulate normal progression to the error message
		IF a_cType = "CLOSE" THEN
			l_nMessageRV = MessageBox( gs_AppName, "Do you want to save changes before closing the window?", &
												Question!, YesNoCancel! )
		ELSE
			l_nMessageRV = MessageBox( gs_AppName, "Do you want to save changes before adding a new form?", &
												Question!, YesNo! )				
		END IF
		
		IF l_nMessageRV = 1 THEN
			MessageBox( gs_AppName, THIS.i_cItemErrMsg, StopSign!, OK! )
			Error.i_FWError = c_Fatal
		ELSEIF l_nMessageRV = 2 THEN
			//Allow the window to close without saving
			Error.i_FWError = c_Success
			dw_case_form.ResetUpdate( )
			dw_case_form_info.fu_ResetUpdate( )
			l_nRV = 1
		ELSEIF l_nMessageRV = 3 THEN
			//Prevent the window from closing
			Error.i_FWError = c_Fatal
		END IF
	ELSE
		dw_case_form_info.AcceptText( )
	
		//Get the status of the form datawindow in case need to save later
		l_dwisStatus = dw_case_form.GetItemStatus( 1, 0, Primary! )		
		
		//Check for info changes.  If there are, the user will be prompted using the
		//  PowerClass message.  If no changes, need to check the form datawindow.
		IF THIS.i_dwisPreUpdateStatus = NotModified! THEN
			IF l_dwisStatus = NewModified! OR l_dwisStatus = DataModified! OR &
				( l_dwisStatus = New! AND IsNull( THIS.i_cFormData ) AND NOT THIS.i_bView ) THEN
				
				IF a_cType = "CLOSE" THEN
					l_nMessageRV = MessageBox( gs_AppName, "Do you want to save changes before closing the window?", &
														Question!, YesNoCancel! )
				ELSE
					l_nMessageRV = MessageBox( gs_AppName, "Do you want to save changes before adding a new form?", &
														Question!, YesNo! )				
				END IF
				
				IF l_nMessageRV = 1 THEN
					//If change, need to revert back to prior template key before save
					IF a_cType = "CHANGE" THEN
						dw_case_form_info.Object.template_key[ 1 ] = THIS.i_cTemplateKey
						
						//Saved once, reviewed
						IF NOT IsNull( dw_case_form_info.Object.form_key[ 1 ] ) THEN
							dw_case_form_info.Object.last_reviewed_by[ 1 ] = OBJCA.WIN.fu_GetLogin( SQLCA )
							dw_case_form_info.Object.last_reviewed_timestamp[ 1 ] = THIS.fw_GetTimeStamp( )
							
							//Let the window know that the last reviewed info was set so doesn't try to set
							//  in pc_close event
							THIS.i_bLastReviewChanged = TRUE
						END IF
					END IF
					
					l_nRV = THIS.Event Trigger ue_SaveForm( )
					
					IF l_nRV = -1 THEN
						//Prevent the window from closing
						Error.i_FWError = c_Fatal
					ELSE
						//Allow the window to close if save successful
						Error.i_FWError = c_Success
					END IF
				ELSEIF l_nMessageRV = 2 THEN
					//Allow the window to close without saving
					Error.i_FWError = c_Success
					dw_case_form.ResetUpdate( )
					dw_case_form_info.fu_ResetUpdate( )
				ELSEIF l_nMessageRV = 3 THEN
					//Prevent the window from closing
					Error.i_FWError = c_Fatal
					l_nRV = -1
				END IF
			END IF
		END IF
	END IF
END IF

//Reset the form datawindow to ensure that if somehow the datawindow
//  is created with update properties, PB doesn't prompt for save.
IF l_nRV <> -1 THEN
	//Reset the pre-update status variable
	THIS.i_dwisPreUpdateStatus = NotModified!
	//Reset the form update status(CYA Programming)
	dw_case_form.ResetUpdate( )
END IF

RETURN l_nRV
end event

event ue_setlastreviewed;//**********************************************************************************************
//
//  Event:   ue_SetLastReviewed
//  Purpose: To set the last reviewed by and timestamp
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/17/2002 K. Claver   Created.
//**********************************************************************************************
String l_cUser
DateTime l_dtTimeStamp

IF NOT IsNull( THIS.i_cFormKey ) AND Trim( THIS.i_cFormKey ) <> "" THEN
	//Get the login and current timestamp
	l_cUser = OBJCA.WIN.fu_GetLogin( SQLCA )
	l_dtTimeStamp = THIS.fw_GetTimeStamp( )
	
	//Set the last reviewed and date/time via an update statement as may not want
	//  to save the datawindow.
	UPDATE cusfocus.case_forms
	SET last_reviewed_by = :l_cUser,
		 last_reviewed_timestamp = :l_dtTimeStamp
	WHERE form_key = :THIS.i_cFormKey
	USING SQLCA;
	
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox( gs_AppName, "Error saving Last Reviewed information.~r~nError Returned:~r~n"+SQLCA.SQLErrText, &
						StopSign!, OK! )
		Error.i_FWError = c_Fatal
	ELSE
		Error.i_FWError = c_Success
	END IF
END IF
end event

public function integer fw_saveonclose ();//******************************************************************
//  PC Module     : w_Main
//  Subroutine    : fw_SaveOnClose
//  Description   : Handle any changes based on the save-on-close
//                  option.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  2/5/2002 K. Claver  Overridden so can capture response to save on
//								close question.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Answer, l_NumRootDW, l_NumTmpDW, l_Jdx, l_Kdx
BOOLEAN l_Changes, l_Found
STRING  l_PromptStrings[]
DATAWINDOW l_RootDW[], l_TmpDW[]
WINDOW l_this

//------------------------------------------------------------------
//  If the save-on-close option is set to c_CloseNoSave then just
//  ignore any changes that might exist.
//------------------------------------------------------------------

IF i_SaveOnClose = c_CloseNoSave THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  Determine if there are any changes on any of the DataWindows in
//  this window.
//------------------------------------------------------------------

l_Changes = fw_CheckChanges()

//------------------------------------------------------------------
//  Determine if there are any changes on any of the DataWindows in
//  any of the child windows.
//------------------------------------------------------------------

IF NOT l_Changes THEN
	IF i_NumWindowChildren > 0 THEN
		FOR l_Idx = 1 TO i_NumWindowChildren
			l_Changes = i_WindowChildren[l_Idx].DYNAMIC fw_CheckChanges()
  			IF l_Changes THEN
				EXIT
			END IF
		NEXT
	END IF
END IF

//------------------------------------------------------------------
//  If there are changes found, determine if we should prompt for 
//  saving changes or just save.
//------------------------------------------------------------------

IF l_Changes OR IsNull(l_Changes) <> FALSE THEN
	l_Answer = 1
	IF i_SaveOnClose = c_ClosePromptUser THEN
		l_PromptStrings[1] = "PowerClass Prompt"
		l_PromptStrings[2] = FWCA.MGR.i_ApplicationName
		l_PromptStrings[3] = ClassName()
		l_PromptStrings[4] = ""
		l_PromptStrings[5] = "fw_SaveOnClose"

		l_Answer = FWCA.MSG.fu_DisplayMessage("ChangesOnClose", &
		                                      5, l_PromptStrings[])
	END IF

	CHOOSE CASE l_Answer
		CASE 2  // No
			THIS.i_bNoSavePressed = TRUE
			
			IF i_NumWindowChildren > 0 THEN
				FOR l_Idx = 1 TO i_NumWindowChildren
					i_WindowChildren[l_Idx].DYNAMIC fw_SetNoSaveOnClose()
				NEXT
			END IF
			RETURN c_Success

		CASE 3  // Cancel
			RETURN c_Fatal
	END CHOOSE

ELSE
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  Determine how many root-level DataWindows that are on this 
//  window.
//------------------------------------------------------------------

l_NumRootDW = fw_FindRootDW()
FOR l_Idx = 1 TO l_NumRootDW
	l_RootDW[l_Idx] = FWCA.MGR.i_TmpDW[l_Idx]
NEXT

//------------------------------------------------------------------
//  Determine how many root-level DataWindows that are on the child
//  windows.  After each call to a child window, make sure the root
//  DataWindows are not already in l_RootDW[].
//------------------------------------------------------------------

IF i_NumWindowChildren > 0 THEN
	FOR l_Idx = 1 TO i_NumWindowChildren

      //------------------------------------------------------------
      //  PowerBuilder 5.0 Bug
		//  
		//  This function is being called statically because of a 
      //  PowerBuilder bug that causes problems when you call a
      //  function dynamically that returns a reference variable
		//  and/or an array.  If this problem is ever fixed this 
		//  function can become dynamic and l_TmpDW[] may be used
		//  as a parameter.
      //
      //  Powersoft Issue Number: ?
      //  Reported by           : Bill Carson
      //  Report Date           : 6/30/96
      //------------------------------------------------------------

//		l_NumTmpDW = i_WindowChildren[l_Idx].DYNAMIC fw_FindRootDW(l_TmpDW[])

		l_NumTmpDW = i_WindowChildren[l_Idx].DYNAMIC fw_FindRootDW()
	
		FOR l_Jdx = 1 TO l_NumTmpDW
			l_TmpDW[l_Jdx] = FWCA.MGR.i_TmpDW[l_Jdx]
			l_Found = FALSE
			FOR l_Kdx = 1 TO l_NumRootDW
				IF l_TmpDW[l_Jdx] = l_RootDW[l_Kdx] THEN
					l_Found = TRUE
					EXIT
				END IF
			NEXT
			IF NOT l_Found THEN
				l_NumRootDW = l_NumRootDW + 1
				l_RootDW[l_NumRootDW] = l_TmpDW[l_Jdx]
			END IF
		NEXT
	NEXT
END IF

//------------------------------------------------------------------
//  For each root-level DataWindow, save the changes.  Use the 
//  fu_SaveOnClose function so that we can indicate that the
//  window is closing.  This will prevent any unnecessary refreshing
//  of parent DataWindows.
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_NumRootDW
	l_this = THIS
	IF l_RootDW[l_Idx].DYNAMIC fu_SaveOnClose(l_this) = c_Fatal THEN
		RETURN c_Fatal
	END IF
NEXT

RETURN c_Success
end function

on w_case_forms.create
int iCurrent
call super::create
if this.MenuName = "m_case_forms" then this.MenuID = create m_case_forms
this.st_3=create st_3
this.p_1=create p_1
this.st_1=create st_1
this.cb_print=create cb_print
this.cb_reset=create cb_reset
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_2=create st_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.dw_case_form_info=create dw_case_form_info
this.dw_case_form=create dw_case_form
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.cb_reset
this.Control[iCurrent+6]=this.cb_ok
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.ln_1
this.Control[iCurrent+9]=this.ln_2
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.ln_3
this.Control[iCurrent+12]=this.ln_4
this.Control[iCurrent+13]=this.dw_case_form_info
this.Control[iCurrent+14]=this.dw_case_form
end on

on w_case_forms.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.cb_print)
destroy(this.cb_reset)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.dw_case_form_info)
destroy(this.dw_case_form)
end on

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_SetOptions
//  Purpose: Please see PowerClass documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/03/2002 K. Claver   Added resize code.
//**********************************************************************************************
String l_cParms

THIS.fw_SetOptions( THIS.c_Default+THIS.c_ToolbarTop ) 	

THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_SetOrigSize( ( THIS.Width - 30 ), ( THIS.Height - 178 ) )
	THIS.inv_resize.of_SetMinSize( ( THIS.Width - 30 ), ( THIS.Height - 178 ) )
	
	THIS.inv_resize.of_Register( dw_case_form, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( cb_reset, THIS.inv_resize.FIXEDBOTTOM )	
	THIS.inv_resize.of_Register( cb_print, THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( cb_ok, THIS.inv_resize.FIXEDRIGHTBOTTOM )
	THIS.inv_resize.of_Register( cb_cancel, THIS.inv_resize.FIXEDRIGHTBOTTOM )
END IF

l_cParms = Trim( Message.StringParm )

//Parse out the view mode, case number, case type, source type and form key
IF Mid( l_cParms, 1, ( Pos( l_cParms, "&" ) - 1 ) ) = "V" THEN
	THIS.i_bView = TRUE
ELSEIF Mid( l_cParms, 1, ( Pos( l_cParms, "&" ) - 1 ) ) = "E" THEN
	THIS.i_bEdit = TRUE
END IF

l_cParms = Mid( l_cParms, ( Pos( l_cParms, "&" ) + 1 ) )
THIS.i_cCaseNumber = Mid( l_cParms, 1, ( Pos( l_cParms, "&" ) - 1 ) )
l_cParms = Mid( l_cParms, ( Pos( l_cParms, "&" ) + 1 ) )
THIS.i_cCaseType = Mid( l_cParms, 1, ( Pos( l_cParms, "&" ) - 1 ) )
l_cParms = Mid( l_cParms, ( Pos( l_cParms, "&" ) + 1 ) )
THIS.i_cSourceType = Mid( l_cParms, 1, ( Pos( l_cParms, "&" ) - 1 ) )
l_cParms = Mid( l_cParms, ( Pos( l_cParms, "&" ) + 1 ) )

//Determine if a form key was passed
IF Pos( l_cParms, "&" ) > 0 THEN
	THIS.i_nConfidLevel = Integer( Mid( l_cParms, 1, ( Pos( l_cParms, "&" ) - 1 ) ) )
	THIS.i_cFormKey = Mid( l_cParms, ( Pos( l_cParms, "&" ) + 1 ) )
ELSE
	THIS.i_nConfidLevel = Integer( l_cParms )
END IF

//Set the title
THIS.Event Trigger ue_SetTitle( "" )

//Initialize the form confid level to null
SetNull( THIS.i_nFormConfidLevel )

i_mMenu = m_case_forms
end event

event pc_close;call super::pc_close;//**********************************************************************************************
//
//  Event:   pc_Close
//  Purpose: Please see PowerClass documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/07/2002 K. Claver   Call the events to update the last reviewed info and refresh the 
//								   parent list.
//**********************************************************************************************
IF ( THIS.i_bEdit OR THIS.i_bView ) AND NOT THIS.i_bLastReviewChanged THEN
	//Fire the event to update the last reviewed info
	THIS.Event Trigger ue_SetLastReviewed( )
END IF

THIS.Event Trigger ue_RefreshList( )
		
		
end event

event pc_closequery;call super::pc_closequery;//**********************************************************************************************
//
//  Event:   pc_CloseQuery
//  Purpose: Please see PowerClass documentation for this event
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/29/2002 K. Claver   Call the ask on close event in case just made changes to the form.
//**********************************************************************************************
IF NOT THIS.i_bNoSavePressed AND NOT THIS.i_bCancel THEN
	THIS.Event Trigger ue_CheckChange( "CLOSE" )
END IF

THIS.i_bCancel = FALSE
end event

event resize;call super::resize;st_2.width = this.workspacewidth()
st_1.width = st_2.width

st_2.y = this.workspaceheight() - st_2.height

ln_3.beginy = st_2.y - 8
ln_4.beginy = st_2.y - 4
ln_3.endy = ln_3.beginy
ln_4.endy = ln_4.beginy

ln_3.endx = st_2.width
ln_4.endx = st_2.width
ln_1.endx = st_2.width
ln_2.endx = st_2.width

cb_reset.y 	= st_2.y + 48
cb_print.y 	= cb_reset.y
cb_ok.y 		= cb_reset.y
cb_cancel.y	= cb_reset.y
end event

type st_3 from statictext within w_case_forms
integer x = 201
integer y = 60
integer width = 1499
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Case Forms"
boolean focusrectangle = false
end type

type p_1 from picture within w_case_forms
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_1 from statictext within w_case_forms
integer width = 4178
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_case_forms
integer x = 430
integer y = 1880
integer width = 357
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print"
end type

event clicked;//**********************************************************************************************
//
//  Event:   Clicked
//  Purpose: Please see PB documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Added code to print the form.
//**********************************************************************************************
ULong l_ulPrintJob
Integer l_nRV

l_ulPrintJob = PrintOpen( )

IF l_ulPrintJob > 0 THEN
	l_nRV = PrintDatawindow( l_ulPrintJob, dw_case_form )
	
	IF l_nRV < 0 THEN
		MessageBox( gs_AppName, "Error printing form", StopSign!, OK! )
	END IF
	
	PrintClose( l_ulPrintJob )
ELSE
	MessageBox( gs_AppName, "Unable to open a print job to print the form", StopSign!, OK! )
END IF
end event

type cb_reset from commandbutton within w_case_forms
integer x = 46
integer y = 1880
integer width = 357
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Reset"
end type

event clicked;//**********************************************************************************************
//
//  Event:   Clicked
//  Purpose: Please see PB documentation for dw_case_form event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Added code to reset the form.  Do dw_case_form field by field rather than using
//									the reset function as want the datawindow to show as DataModified! or
//								   NewModified!
//**********************************************************************************************
String l_cNull, l_cVisible
Integer l_nNull, l_nColCount, l_nCol, l_nRV
Decimal l_dcNull
Date l_dNull
Time l_tNull

l_nRV = MessageBox( gs_AppName, "Are you sure you want to reset the form?", Question!, YesNo! )

IF l_nRV = 1 THEN
	//Initialize the null variables to null
	SetNull( l_nNull )
	SetNull( l_cNull )
	SetNull( l_dNull )
	SetNull( l_dcNull )
	SetNull( l_tNull )
	
	IF dw_case_form.RowCount( ) > 0 THEN
		SetPointer( HourGlass! )
		
		dw_case_form.SetRedraw( FALSE )
		
		//Set all of the fields to null
		l_nColCount = Integer( dw_case_form.Object.Datawindow.Column.Count )
		IF l_nColCount > 0 THEN
			FOR l_nCol = 1 TO l_nColCount
				l_cVisible = dw_case_form.Describe( "#"+String( l_nCol )+".Visible")
				IF l_cVisible = "1" THEN
					//Need to check the first four characters of the column type as CHAR and DECIMAL both
					//  incorporate a precision property(ie. char(10)).  If a column has simply been cleared, 
					//  set its value back to null to check for required fields.
					CHOOSE CASE Trim( Upper( Left( dw_case_form.Describe( "#"+String( l_nCol )+".ColType" ), 4 ) ) )
						CASE "CHAR"
							dw_case_form.SetItem( 1, l_nCol, l_cNull )
						CASE "DATE"
							//Date or Datetime
							dw_case_form.SetItem( 1, l_nCol, l_dNull )
						CASE "DECI"
							dw_case_form.SetItem( 1, l_nCol, l_dcNull )
						CASE "INT","LONG","NUMB","REAL","ULON"
							//All numbers but decimal
							dw_case_form.SetItem( 1, l_nCol, l_nNull )
						CASE "TIME"
							// use for time and timestamp
							dw_case_form.SetItem( 1, l_nCol, l_tNull )
					END CHOOSE
				END IF
			NEXT
		END IF
		
		dw_case_form.SetRedraw( TRUE )
		
		SetPointer( Arrow! )	
	END IF
	
	SetNull( PARENT.i_cFormData )
END IF
end event

type cb_ok from commandbutton within w_case_forms
integer x = 2894
integer y = 1880
integer width = 357
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&OK"
end type

event clicked;//**********************************************************************************************
//
//  Event:   Clicked
//  Purpose: Please see PB documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Added code to call the save event and refresh the list on the tab before
//									calling the event to close the window.
//*********************************************************************************************
Integer l_nRV

l_nRV = PARENT.Event Trigger ue_SaveForm( )

IF l_nRV >= 0 THEN
	PARENT.i_bCancel = FALSE
	PARENT.Event Trigger ue_RefreshList( )
	PARENT.Event Post ue_PostClose( )
END IF



end event

type cb_cancel from commandbutton within w_case_forms
integer x = 3273
integer y = 1880
integer width = 357
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;//**********************************************************************************************
//
//  Event:   Clicked
//  Purpose: Please see PB documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Added code to cancel the form edit prompting the user if 
//									changes were made.  Also closes the window.
//**********************************************************************************************
Integer l_nRV

l_nRV = PARENT.Event Trigger ue_CheckChange( "CLOSE" )

IF l_nRV <> -1 THEN
	PARENT.i_bCancel = TRUE
	PARENT.Event Trigger ue_RefreshList( )
	PARENT.Event Post ue_PostClose( )
END IF
end event

type ln_1 from line within w_case_forms
long linecolor = 8421504
integer linethickness = 4
integer beginy = 188
integer endx = 3799
integer endy = 188
end type

type ln_2 from line within w_case_forms
long linecolor = 16777215
integer linethickness = 4
integer beginy = 192
integer endx = 3799
integer endy = 192
end type

type st_2 from statictext within w_case_forms
integer y = 1832
integer width = 4178
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217747
boolean focusrectangle = false
end type

type ln_3 from line within w_case_forms
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1828
integer endx = 3803
integer endy = 1828
end type

type ln_4 from line within w_case_forms
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1824
integer endx = 3803
integer endy = 1824
end type

type dw_case_form_info from u_dw_std within w_case_forms
event ue_disable ( boolean a_bdisable )
event ue_setcaseupdateinfo ( )
integer x = 23
integer y = 220
integer width = 3611
integer height = 420
integer taborder = 20
string dataobject = "d_case_form_info"
boolean border = false
end type

event ue_disable;//**********************************************************************************************
//
//  Event:   ue_Disable
//  Purpose: To enable/disable the form info fields
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/17/2002 K. Claver   Created as a result of fu_View not working.
//**********************************************************************************************
IF a_bDisable THEN
	THIS.Object.template_key.Background.Mode = "1"
	THIS.Object.template_key.Protect = "1"
	THIS.Object.confidentiality_level.Background.Mode = "1"
	THIS.Object.confidentiality_level.Protect = "1"
	THIS.Object.form_notes.Background.Color = "80269524"
	THIS.Object.form_notes.Edit.DisplayOnly = "Yes"
ELSE
	THIS.Object.template_key.Background.Mode = "0"
	THIS.Object.template_key.Protect = "0"
	THIS.Object.confidentiality_level.Background.Mode = "0"
	THIS.Object.confidentiality_level.Protect = "0"
	THIS.Object.form_notes.Background.Color = String( RGB( 255, 255, 255 ) )
	THIS.Object.form_notes.Edit.DisplayOnly = "No"
END IF
	
end event

event ue_setcaseupdateinfo;//**********************************************************************************************
//
//  Event:   ue_SetCaseUpdateInfo
//  Purpose: To update the updated_by and timestamp for the case upon addition of a new form.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  2/14/2002 K. Claver   	Created.
//  12/19/2002 K. Claver   Added code to create a new case number if one isn't defined.
//**********************************************************************************************
Integer l_nRV
u_dw_std l_dwCaseDetails
String l_cUpdatedBy, l_cCurrCaseNum, l_cCurrCaseMasterNum
DateTime l_dtUpdatedDate

l_cUpdatedBy = OBJCA.WIN.fu_GetLogin( SQLCA )
l_dtUpdatedDate = PARENT.fw_GetTimeStamp( )

IF IsValid( w_create_maintain_case ) THEN
	IF IsValid( w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details ) THEN
		l_dwCaseDetails = w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
		
		IF l_dwCaseDetails.RowCount( ) > 0 THEN
			l_dwCaseDetails.Object.case_log_updated_by[ 1 ] = l_cUpdatedBy
			l_dwCaseDetails.Object.case_log_updated_timestamp[ 1 ] = l_dtUpdatedDate
			
			//Check that there is a case number defined.  If not, get one.
			l_cCurrCaseNum = l_dwCaseDetails.Object.case_log_case_number[ 1 ]
			IF ( IsNull( l_cCurrCaseNum ) OR Trim( l_cCurrCaseNum ) = "" ) AND &
				IsNull( w_create_maintain_case.i_uoCaseDetails.i_cNewCaseNum ) THEN
				w_create_maintain_case.i_uoCaseDetails.i_cNewCaseNum = w_create_maintain_case.fw_GetKeyValue( 'case_log' )
			END IF
			
			l_cCurrCaseMasterNum = l_dwCaseDetails.Object.case_log_master_case_number[ 1 ]
			IF w_create_maintain_case.i_bLinked AND &
				IsNull( w_create_maintain_case.i_uoCaseDetails.i_cNewMasterCaseNum ) AND &
				( IsNull( l_cCurrCaseMasterNum ) OR Trim( l_cCurrCaseMasterNum ) = "" ) THEN
				w_create_maintain_case.i_uoCaseDetails.i_cNewMasterCaseNum = w_create_maintain_case.fw_GetKeyValue( 'case_log_master_num' )
			END IF
			
			l_nRV = l_dwCaseDetails.fu_Save( l_dwCaseDetails.c_SaveChanges )
			
			IF l_nRV = -1 THEN
				MessageBox( gs_AppName, "Error saving updated by and date/time for the case" )
			END IF
		END IF
	ELSE
		UPDATE cusfocus.case_log
		SET updated_by = :l_cUpdatedBy,
			 updated_timestamp = :l_dtUpdatedDate
		WHERE case_number = :PARENT.i_cCaseNumber
		USING SQLCA;
		
		IF SQLCA.SQLCode <> 0 THEN
			MessageBox( gs_AppName, "Error saving updated by and date/time for the case" )
		END IF
	END IF
ELSE
	UPDATE cusfocus.case_log
	SET updated_by = :l_cUpdatedBy,
		 updated_timestamp = :l_dtUpdatedDate
	WHERE case_number = :PARENT.i_cCaseNumber
	USING SQLCA;
	
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox( gs_AppName, "Error saving updated by and date/time for the case" )
	END IF
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;//**********************************************************************************************
//
//  Event:   pcd_SetOptions
//  Purpose: Please see PowerClass documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Added code to set the datawindow options.
//**********************************************************************************************
THIS.fu_SetOptions( SQLCA, &
						  THIS.c_NullDW, &
						  THIS.c_NewOK+ &
						  THIS.c_NewModeOnEmpty+ &
						  THIS.c_ModifyOK+ &
						  THIS.c_ModifyOnOpen+ &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_HideHighlight+ &
						  THIS.c_NoMenuButtonActivation+ &
						  THIS.c_NoShowEmpty+ &
						  THIS.c_OnlyOneNewRow )
						  
//Initially disable the confidentiality level field
THIS.Object.confidentiality_level.Background.Mode = "1"
THIS.Object.confidentiality_level.Protect = "1"
						  
						  
						  
end event

event pcd_retrieve;call super::pcd_retrieve;//**********************************************************************************************
//
//  Event:   pcd_Retrieve
//  Purpose: Please see PowerClass documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Added code to retrieve the drop down datawindow.
//**********************************************************************************************
DatawindowChild l_dwcFormList, l_dwcSecurity
Integer l_nRows

THIS.GetChild( "template_key", l_dwcFormList )
THIS.GetChild( "confidentiality_level", l_dwcSecurity )

l_dwcFormList.SetTransObject( SQLCA )
l_dwcSecurity.SetTransObject( SQLCA )

//Retrieve the security levels
l_dwcSecurity.Retrieve( )
	
//Use the case and source type of the current case to get the list of forms
l_nRows = l_dwcFormList.Retrieve( PARENT.i_cCaseType, &
											 PARENT.i_cSourceType, &
											 PARENT.i_cFormKey )
									
IF l_nRows = 0 THEN
	MessageBox( gs_AppName, "No forms have been defined for this case type and source type combination", StopSign!, OK! )
	Error.i_FWError = c_Fatal
ELSEIF l_nRows = -1 THEN
	MessageBox( gs_AppName, "Error retrieving the list of available forms", StopSign!, OK! )
	Error.i_FWError = c_Fatal
ELSE
	//Retrieve the main datawindow
	IF NOT IsNull( PARENT.i_cFormKey ) AND Trim( PARENT.i_cFormKey ) <> "" THEN
		l_nRows = THIS.Retrieve( PARENT.i_cFormKey )
		
		IF l_nRows = -1 THEN
			MessageBox( gs_AppName, "Error retrieving the form information", StopSign!, OK! )
			Error.i_FWError = c_Fatal
		ELSE
			//Set the template key instance variable
			IF l_nRows > 0 THEN
				PARENT.i_cTemplateKey = THIS.Object.template_key[ 1 ]
				
				//Load the associated form
				dw_case_form.Event Trigger ue_LoadForm( )
				
				IF PARENT.i_bView THEN
					THIS.Event Trigger ue_Disable( TRUE )						
				ELSE
					THIS.Event Trigger ue_Disable( FALSE )
				END IF
				
				//Set the title
				PARENT.Event Trigger ue_SetTitle( PARENT.i_cTemplateKey )
				
				//Get the confidentiality leve
				PARENT.i_nFormConfidLevel = THIS.Object.confidentiality_level[ 1 ]
			END IF
		END IF
	ELSE
		SetNull( PARENT.i_nFormConfidLevel )
	END IF
END IF
end event

event itemchanged;call super::itemchanged;//**********************************************************************************************
//
//  Event:   ItemChanged
//  Purpose: Please see PB documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Added code to check if the current form has been changed and query the
//									user if they would like to save before switching to a new form.  Also
//									sets the template key instance variable.
//**********************************************************************************************
Integer l_nRV, l_nRow
DatawindowChild l_dwcTempltList

CHOOSE CASE Upper( dwo.Name )
	CASE "TEMPLATE_KEY"
		IF Trim( data ) <> "" AND NOT IsNull( data ) THEN
			IF data <> PARENT.i_cTemplateKey OR &
				IsNull( PARENT.i_cTemplateKey ) THEN
				//Prompt for change, if any.
				l_nRV = PARENT.Event Trigger ue_CheckChange( "CHANGE" )
				
				IF l_nRV <> -1 THEN
					//Reset the rest of the datawindow
					PARENT.i_cTemplateKey = data
					SetNull( PARENT.i_cFormKey )
					THIS.fu_Reset( THIS.c_IgnoreChanges )
					THIS.Object.template_key[ 1 ] = PARENT.i_cTemplateKey
					
					//Get a handle to the child datawindow so can populate the description
					THIS.GetChild( "template_key", l_dwcTempltList )
					THIS.Object.template_description[ 1 ] = l_dwcTempltList.GetItemString( l_dwcTempltList.GetRow( ), "template_description" )
					
					//Re-retrieve the drop down datawindow to filter out any forms that might have been
					//  retrieved as a result of case type change
					l_dwcTempltList.Retrieve( PARENT.i_cCaseType, &
													  PARENT.i_cSourceType, &
													  PARENT.i_cFormKey )
													  
					l_nRow = l_dwcTempltList.Find( "template_key = '"+PARENT.i_cTemplateKey+"'", 1, l_dwcTempltList.RowCount( ) )
					IF l_nRow > 0 THEN
						l_dwcTempltList.ScrollToRow( l_nRow )
						l_dwcTempltList.SelectRow( 0, FALSE )
						l_dwcTempltList.SelectRow( l_nRow, TRUE )
					END IF
					
					//Load the new form
					dw_case_form.Event Trigger ue_LoadForm( )
					
					//Set the title
					PARENT.Event Trigger ue_SetTitle( PARENT.i_cTemplateKey )
					
					//Take out of edit mode
					PARENT.i_bEdit = FALSE
				ELSE
					//Set the template key back so visibly shows as not changed.  Otherwise, will
					//  show the template the user tried to pick
					THIS.Object.template_key[ 1 ] = PARENT.i_cTemplateKey
					RETURN 2
				END IF
				
				//Force a redraw of this datawindow
				THIS.SetRedraw( FALSE )
				THIS.SetRedraw( TRUE )
			END IF
		END IF
	CASE "CONFIDENTIALITY_LEVEL"
		IF Trim( data ) <> "" AND NOT IsNull( data ) THEN
			IF PARENT.i_nConfidLevel < Integer( data ) THEN
				MessageBox( gs_AppName, "You cannot set the security level of this form higher than your own.", &
								StopSign!, OK! )
				THIS.Object.confidentiality_level[ 1 ] = PARENT.i_nFormConfidLevel
				RETURN 2				
			END IF
		END IF
END CHOOSE

end event

event pcd_savebefore;call super::pcd_savebefore;//**********************************************************************************************
//
//  Event:   pcd_SaveBefore
//  Purpose: Please see PowerClass documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/30/2002 K. Claver   Store the datawindow status prior to update so know if should prompt
//									for the form datawindow in the ue_AskOnClose event.  Also set some
//									values prior to save.
//**********************************************************************************************
String l_cUser
DateTime l_dtTimeStamp

PARENT.i_dwisPreUpdateStatus = THIS.GetItemStatus( 1, 0, Primary! )

l_cUser = OBJCA.WIN.fu_GetLogin( SQLCA )
l_dtTimeStamp = PARENT.fw_GetTimeStamp( )

//Set the created by and timestamp if in add mode
IF NOT PARENT.i_bEdit AND NOT PARENT.i_bView THEN
	THIS.Object.created_by[ 1 ] = l_cUser
	THIS.Object.created_timestamp[ 1 ] = l_dtTimeStamp
	PARENT.i_cFormKey = PARENT.fw_GetKeyValue( "case_forms" )
	THIS.Object.form_key[ 1 ] = PARENT.i_cFormKey
	THIS.Object.case_number[ 1 ] = PARENT.i_cCaseNumber
END IF

IF NOT PARENT.i_bUpdatedChanged THEN
	//Set the updated by and timestamp
	THIS.Object.updated_by[ 1 ] = l_cUser
	THIS.Object.updated_timestamp[ 1 ] = l_dtTimeStamp
	PARENT.i_bUpdatedChanged = TRUE
END IF
end event

event pcd_validaterow;call super::pcd_validaterow;//**********************************************************************************************
//
//  Event:   pcd_ValidateRow
//  Purpose: Please see PowerClass documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/17/2002 K. Claver   Added code to check the form fields before allowing to save.
//**********************************************************************************************
Integer l_nRV
String l_cTemplateKey

l_cTemplateKey = THIS.Object.template_key[ 1 ]

IF IsNull( l_cTemplateKey ) OR Trim( l_cTemplateKey ) = "" THEN
	MessageBox( gs_AppName, "Please select a form to attach to the case", StopSign!, OK! )
	Error.i_FWError = c_ValFailed
ELSE
	l_nRV = dw_case_form.Event Trigger ue_ProcFormFields( )
	
	IF l_nRV = -1 THEN
		Error.i_FWError = c_ValFailed
	ELSE
		Error.i_FWError = c_Success
	END IF
END IF
end event

event pcd_saveafter;call super::pcd_saveafter;//**********************************************************************************************
//
//  Event:   pcd_SaveAfter
//  Purpose: Please see PowerClass documentation for this event
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/17/2002 K. Claver   Save the form after successful save of the datawindow
//**********************************************************************************************
Integer l_nRV

l_nRV = dw_case_form.Event Trigger ue_SaveFormImage( )
			
IF l_nRV = -1 THEN
	MessageBox( gs_AppName, "Error saving form image to database.~r~nError returned: "+SQLCA.SQLErrText, &
					StopSign!, OK! )
ELSEIF PARENT.i_dwisPreUpdateStatus = NewModified! THEN
	THIS.Event Trigger ue_SetCaseUpdateInfo( )
END IF
end event

type dw_case_form from datawindow within w_case_forms
event ue_loadform ( )
event type integer ue_saveformimage ( )
event type integer ue_procformfields ( )
event type integer ue_checkfields ( boolean a_bshowmessage )
event ue_keypressed pbm_dwnkey
event ue_postshowerror ( )
integer x = 32
integer y = 640
integer width = 3598
integer height = 1164
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_loadform();//**********************************************************************************************
//
//  Event: 	  ue_LoadForm
//  Purpose:  Event to load the form either from the case or from the templates table
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Created
//**********************************************************************************************
Integer l_nRV = 1, l_nIndex, l_nColCount, l_nCol
Blob l_blForm
String l_cForm, l_cError, l_cFormSyntax, l_cData, l_cVisible, l_cDataElement, l_cColName
Long l_nDataPos, l_nInsertData
Date l_dInsertData, l_dDate
DateTime l_dtInsertData
Time l_tInsertData, l_tTime
Boolean l_bNull
Decimal l_dcInsertData
Real l_rInsertData

THIS.SetRedraw( FALSE )

IF Trim( PARENT.i_cFormKey ) = "" OR IsNull( PARENT.i_cFormKey ) THEN
	//Get the template from the template table
	SELECTBLOB template_image
	INTO :l_blForm
	FROM cusfocus.form_templates
	WHERE template_key = :PARENT.i_cTemplateKey
	USING SQLCA;
	
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox( gs_AppName, "Unable to retrieve form from database.~r~nError Returned:~r~n"+SQLCA.SQLErrText, &
						StopSign!, OK! )
		l_nRV = -1
	ELSE	
		//Convert the blob to a string and create the datawindow
		l_cForm = String( l_blForm )	

		// Make sure we converted it correctly - RAP 11/4/08
		l_nDataPos = Pos( l_cForm, "release" )
		IF l_nDataPos = 0 THEN
			l_cForm = string(l_blForm, EncodingANSI!)
		END IF
		
		l_nRV = THIS.Create( l_cForm, l_cError )
		
		IF l_nRV = -1 THEN
			MessageBox( gs_AppName, "Unable to create form.~r~nError Returned:~r~n"+l_cError, StopSign!, OK! )
		ELSE
			THIS.InsertRow( 0 )
			//No data.  Ensure the instance variable reflects this
			SetNull( PARENT.i_cFormData )
		END IF
	END IF
ELSE
	SetPointer( Hourglass! )
	
	//Load the form for review from the saved image
	SELECTBLOB form_image
	INTO :l_blForm
	FROM cusfocus.case_forms
	WHERE form_key = :PARENT.i_cFormKey
	USING SQLCA;
	
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox( gs_AppName, "Unable to retrieve form from database.~r~nError Returned:~r~n"+SQLCA.SQLErrText, &
						StopSign!, OK! )
		l_nRV = -1
	ELSE	
		//Convert the blob to a string and parse out the data, if there is any
		l_cForm = String( l_blForm )
		
		// Make sure we converted it correctly - RAP 11/4/08
		l_nDataPos = Pos( l_cForm, "release" )
		IF l_nDataPos = 0 THEN
			l_cForm = string(l_blForm, EncodingANSI!)
		END IF
		
		IF NOT IsNull( l_cForm ) AND Trim( l_cForm ) <> "" THEN 
			l_nDataPos = Pos( l_cForm, "^DATA^" )
			IF l_nDataPos > 0 THEN
				//Get just the form syntax and create
				l_cFormSyntax = Mid( l_cForm, 1, ( l_nDataPos - 1 ) )
				
				l_nRV = THIS.Create( l_cFormSyntax, l_cError )
				
				IF l_nRV = -1 THEN
					MessageBox( gs_AppName, "Error creating form.~r~nError Returned:~r~n"+l_cError, StopSign!, OK! )
				ELSE
					//Parse out the data and fill out the form
					THIS.InsertRow( 0 )
					
					PARENT.i_cFormData = Mid( l_cForm, ( l_nDataPos + 6 ) )
					l_cData = PARENT.i_cFormData
					
					l_nColCount = Integer( THIS.Object.Datawindow.Column.Count )
					IF l_nColCount > 0 THEN
						FOR l_nCol = 1 TO l_nColCount							
							l_cVisible = THIS.Describe( "#"+String( l_nCol )+".Visible")
							IF l_cVisible = "1" THEN
								//Disable form entry if in view mode
								IF PARENT.i_bView THEN
									THIS.Modify( "#"+String( l_nCol )+".Protect='1'" )
								ELSE
									THIS.Modify( "#"+String( l_nCol )+".Protect='0'" )
								END IF
								
								IF NOT IsNull( l_cData ) AND Trim( l_cData ) <> "" THEN
									IF Pos( l_cData, "||" ) = 0 THEN
										//Last data element
										l_cDataElement = Trim( l_cData )
									ELSE
										//Get the data element from the data string and remove the element
										//  just retrieved.
										l_cDataElement = Mid( l_cData, 1, ( Pos( l_cData, "||" ) - 1 ) )
										l_cData = Mid( l_cData, ( Pos( l_cData, "||" ) + 2 ) )
									END IF
								END IF
								
								//Need to check the first four characters of the column type as CHAR and DECIMAL both
								//  incorporate a precision property(ie. char(10)).
								IF Upper( l_cDataElement ) = "NULL" THEN
									l_bNull = TRUE
								ELSE
									l_bNull = FALSE
								END IF
								
								CHOOSE CASE Trim( Upper( Left( THIS.Describe( "#"+String( l_nCol )+".ColType" ), 4 ) ) )
									CASE "CHAR"
										IF l_bNull THEN
											SetNull( l_cDataElement )
										ELSE
											l_nRV = THIS.SetItem( 1, l_nCol, l_cDataElement )
										END IF
									CASE "DATE"
										//Date and datetime
										IF Trim( Upper( THIS.Describe("#"+String( l_nCol )+".ColType" ) ) ) = "DATE" THEN
											IF l_bNull THEN
												SetNull( l_dInsertData )
											ELSE
												l_dInsertData = Date( l_cDataElement )
											END IF
											
											l_nRV = THIS.SetItem( 1, l_nCol, l_dInsertData )
										ELSE
											IF l_bNull THEN
												SetNull( l_dtInsertData )
											ELSE
												l_dDate = Date( l_cDataElement )
												l_tTime = Time( l_cDataElement )
												l_dtInsertData = DateTime( l_dDate, l_tTime )
											END IF
											
											l_nRV = THIS.SetItem( 1, l_nCol, l_dtInsertData )
										END IF							
									CASE "DECI"
										IF l_bNull THEN
											SetNull( l_dcInsertData )
										ELSE
											l_dcInsertData = Dec( l_cDataElement )
										END IF
										
										l_nRV = THIS.SetItem( 1, l_nCol, l_dcInsertData )
									CASE "REAL"
										IF l_bNull THEN
											SetNull( l_rInsertData )
										ELSE
											l_rInsertData = Real( l_cDataElement )
										END IF										
												
										l_nRV = THIS.SetItem( 1, l_nCol, l_rInsertData )		
									CASE "INT","LONG","NUMB","ULON"
										//All numbers but decimal and real
										IF l_bNull THEN
											SetNull( l_nInsertData )
										ELSE
											l_nInsertData = Long( l_cDataElement )
										END IF
										
										l_nRV = THIS.SetItem( 1, l_nCol, l_nInsertData )
									CASE "TIME"
										// use for time and timestamp
										IF l_bNull THEN
											SetNull( l_tInsertData )
										ELSE
											l_tInsertData = Time( l_cDataElement )
										END IF
										
										l_nRV = THIS.SetItem( 1, l_nCol, l_tInsertData )
								END CHOOSE
								
								//Error on setitem
								IF l_nRV = -1 THEN
									l_cColName = Upper( THIS.Describe( "#"+String( l_nCol )+".Name") )
									MessageBox( gs_AppName, "Error restoring value "+l_cDataElement+" into column "+l_cColName )
									//Non-fatal error.  Still want to attempt to populate the rest of the form.
									l_nRV = 1
								END IF
							END IF
						NEXT
						
						//Just loaded the form.  Set the status to NotModified!
						THIS.SetItemStatus( 1, 0, Primary!, NotModified! )
					END IF
				END IF
			ELSE
				l_nRV = THIS.Create( l_cForm, l_cError )
				
				IF l_nRV = -1 THEN
					MessageBox( gs_AppName, "Error creating form.~r~nError Returned:~r~n"+l_cError, StopSign!, OK! )
				ELSE
					THIS.InsertRow( 0 )
					
					//Disable the form if in view mode
					l_nColCount = Integer( THIS.Object.Datawindow.Column.Count )
					IF l_nColCount > 0 THEN
						FOR l_nCol = 1 TO l_nColCount							
							l_cVisible = THIS.Describe( "#"+String( l_nCol )+".Visible")
							IF l_cVisible = "1" THEN
								//Disable form entry if in view mode
								IF PARENT.i_bView THEN
									THIS.Modify( "#"+String( l_nCol )+".Protect='1'" )
								ELSE
									THIS.Modify( "#"+String( l_nCol )+".Protect='0'" )
								END IF
							END IF
						NEXT
					END IF
					
					//Just loaded the form.  Set the status to NotModified!
					THIS.SetItemStatus( 1, 0, Primary!, NotModified! )
				END IF
			END IF			
		ELSE
			MessageBox( gs_AppName, "Error retrieving form syntax", StopSign!, OK! )
			l_nRV = -1
		END IF
	END IF
	
	SetPointer( Arrow! )
END IF

THIS.SetRedraw( TRUE )

THIS.SetFocus( )

IF l_nRV = -1 THEN
	cb_reset.Enabled = FALSE
	cb_print.Enabled = FALSE
	cb_ok.Enabled = FALSE
	i_mMenu.m_file.m_savereminder.Enabled = FALSE
	i_mMenu.m_file.m_print.Enabled = FALSE
	dw_case_form_info.Object.form_notes.Background.Color = "80269524"
	dw_case_form_info.Object.form_notes.Edit.DisplayOnly = "Yes"
	dw_case_form_info.Object.confidentiality_level.Background.Mode = "1"
	dw_case_form_info.Object.confidentiality_level.Protect = "1"
ELSE
	cb_print.Enabled = TRUE
	cb_ok.Enabled = TRUE
	i_mMenu.m_file.m_print.Enabled = TRUE
	
	IF PARENT.i_bView THEN
		cb_reset.Enabled = FALSE
		cb_cancel.Enabled = FALSE
		i_mMenu.m_file.m_savereminder.Enabled = FALSE
	ELSE
		cb_reset.Enabled = TRUE
		cb_cancel.Enabled = TRUE
		i_mMenu.m_file.m_savereminder.Enabled = TRUE
		dw_case_form_info.Object.form_notes.Background.Color = String( RGB( 255, 255, 255 ) )
		dw_case_form_info.Object.form_notes.Edit.DisplayOnly = "No"		
		dw_case_form_info.Object.confidentiality_level.Background.Mode = "0"
		dw_case_form_info.Object.confidentiality_level.Protect = "0"
	END IF
	
	//Post the event to display the special comments
	PARENT.Event Post ue_DisplaySpecComments( )
END IF
end event

event ue_saveformimage;//**********************************************************************************************
//
//  Event:    ue_SaveFormImage
//  Purpose:  Event to save the form
//
//  Returns: Integer - 1 for Success, -1 for Failure
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Created
//**********************************************************************************************
String l_cForm
Integer l_nRV = 1, l_nColCount
Boolean l_bAutoCommit
Blob l_blForm

//Save the form if it was successfully created
l_nColCount = Integer( THIS.Object.Datawindow.Column.Count )
IF l_nColCount > 0 THEN
	//If actually have data, get the form syntax and save the data with it.  Otherwise
	//  just save the form.
	l_cForm = THIS.Object.Datawindow.Syntax
	IF NOT IsNull( PARENT.i_cFormData ) AND Trim( PARENT.i_cFormData ) <> "" THEN
		l_cForm += ( "^DATA^"+PARENT.i_cFormData )
	END IF
	
	//Convert the string to a blob for storage
	l_blForm = Blob( l_cForm )
			
	//Store the autocommit value as needs to be true for
	//  updating the image.
	l_bAutoCommit = SQLCA.AutoCommit
	SQLCA.AutoCommit = TRUE
	
	UPDATEBLOB cusfocus.case_forms
	SET form_image = :l_blForm
	WHERE form_key = :PARENT.i_cFormKey
	USING SQLCA;
	
	IF SQLCA.SQLCode = -1 THEN
		l_nRV = -1
	END IF
	
	//Set the autocommit value back.
	SQLCA.AutoCommit = l_bAutoCommit
	
	//Reset the update status of this form
	IF l_nRV <> -1 THEN
		THIS.ResetUpdate( )
	END IF
END IF

RETURN l_nRV
end event

event ue_procformfields;//**********************************************************************************************
//
//  Event:    ue_ProcFormFields
//  Purpose:  Event to process mapped form fields and create the data string
//
//  Returns: Integer - 1 for Success, -1 for Error
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Created
//**********************************************************************************************
DataStore l_dsMappings
Integer l_nColCount, l_nCol, l_nMappings, l_nMapRow, l_nRV = 1, l_nNull, l_nIndex = 0
String l_cColName, l_cVisible, l_cNewText, l_cDataString = ""
String l_cNull, l_cFieldVal[ ], l_cGenField[ ], l_cGeneric
Boolean l_bData = FALSE
Decimal l_dcNull
Date l_dNull
Time l_tNull

//Initialize the null variables to null
SetNull( l_nNull )
SetNull( l_cNull )
SetNull( l_dNull )
SetNull( l_dcNull )
SetNull( l_tNull )

SetPointer( Hourglass! )

IF NOT IsNull( PARENT.i_cTemplateKey ) AND Trim( PARENT.i_cTemplateKey ) <> "" THEN 
	//Make sure all data is accepted into the datawindow
	l_nRV = THIS.Event Trigger ue_CheckFields( TRUE )
	
	IF l_nRV = 1 THEN
		//Retrieve the field mappings for the form template
		l_dsMappings = CREATE DataStore
		l_dsMappings.DataObject = "d_field_mappings"
		l_dsMappings.SetTransObject( SQLCA )
		l_nMappings = l_dsMappings.Retrieve( PARENT.i_cTemplateKey )
		
		//Build the data string
		l_nColCount = Integer( THIS.Object.Datawindow.Column.Count )
		IF l_nColCount > 0 THEN
			FOR l_nCol = 1 TO l_nColCount
				l_cVisible = THIS.Describe( "#"+String( l_nCol )+".Visible")
				IF l_cVisible = "1" THEN
					//Populate the column name to save the mapped columns
					l_cColName = Upper( THIS.Describe( "#"+String( l_nCol )+".Name") )
					
					//Need to check the first four characters of the column type as CHAR and DECIMAL both
					//  incorporate a precision property(ie. char(10)).  If a column has simply been cleared, 
					//  set its value back to null to check for required fields.
					CHOOSE CASE Trim( Upper( Left( THIS.Describe( "#"+String( l_nCol )+".ColType" ), 4 ) ) )
						CASE "CHAR"
							l_cNewText = THIS.GetItemString( 1, l_nCol )
							
							IF Trim( l_cNewText ) = "" THEN
								SetNull( l_cNewText )
								THIS.SetItem( 1, l_nCol, l_cNull )
							END IF
						CASE "DATE"
							//Date and datetime
							IF Upper( THIS.Describe("#"+String( l_nCol )+".ColType" ) ) = "DATE" THEN
								l_cNewText = String( THIS.GetItemDate( 1, l_nCol ) )
							ELSE
								l_cNewText = String( THIS.GetItemDateTime( 1, l_nCol ) )
							END IF
							
							IF Trim( l_cNewText ) = "" THEN
								SetNull( l_cNewText )
								THIS.SetItem( 1, l_nCol, l_dNull )
							END IF
						CASE "DECI"
							l_cNewText = String( THIS.GetItemDecimal( 1, l_nCol ) )
							
							IF Trim( l_cNewText ) = "" THEN
								SetNull( l_cNewText )
								THIS.SetItem( 1, l_nCol, l_dcNull )
							END IF
						CASE "INT","LONG","NUMB","REAL","ULON"
							//All numbers but decimal
							l_cNewText = String( THIS.GetItemNumber( 1, l_nCol ) )
							
							IF Trim( l_cNewText ) = "" THEN
								SetNull( l_cNewText )
								THIS.SetItem( 1, l_nCol, l_nNull )
							END IF
						CASE "TIME"
							// use for time and timestamp
							l_cNewText = String( THIS.GetItemTime( 1, l_nCol ) )
							
							IF Trim( l_cNewText ) = "" THEN
								SetNull( l_cNewText )
								THIS.SetItem( 1, l_nCol, l_tNull )
							END IF
					END CHOOSE
					
					//See if this field is mapped and set the info into the arrays for processing after
					//  passes validation.
					IF l_nMappings > 0 THEN
						l_nMapRow = l_dsMappings.Find( "template_field = '"+l_cColName+"'", 1, l_nMappings )
						IF l_nMapRow > 0 THEN
							l_cGeneric = l_dsMappings.Object.property_field[ l_nMapRow ]
							
							//Check if greater than 50 characters and truncate if necessary
							IF Len( Trim( l_cNewText ) ) > 50 THEN
								l_cNewText = Mid( Trim( l_cNewText ), 1, 50 )
							END IF
							
							l_nIndex++
							l_cGenField[ l_nIndex ] = l_cGeneric
							l_cFieldVal[ l_nIndex ] = l_cNewText
						END IF
					END IF
					
					IF IsNull( l_cNewText ) OR Trim( l_cNewText ) = "" THEN
						l_cNewText = "NULL"
					ELSE			
						l_bData = TRUE
					END IF
					
					IF Trim( l_cDataString ) = "" THEN
						l_cDataString += l_cNewText
					ELSE
						l_cDataString += ( "||"+l_cNewText )
					END IF
				END IF
			NEXT
		END IF
		
		//Perform an AcceptText to check for required fields again.  Necessary as fields may
		//  have been set back to null during the processing to build the data string.
		IF l_bData THEN
			PARENT.i_cFormData = l_cDataString
			
			//Apply the mapped fields, if they exist
			IF UpperBound( l_cGenField ) > 0 THEN
				FOR l_nIndex = 1 TO UpperBound( l_cGenField )
					dw_case_form_info.SetItem( 1, l_cGenField[ l_nIndex ], l_cFieldVal[ l_nIndex ] )
				NEXT
			END IF
		ELSE
			SetNull( PARENT.i_cFormData )
		END IF
			
		DESTROY l_dsMappings
	END IF
END IF

SetPointer( Arrow! )

RETURN l_nRV
end event

event ue_checkfields;//**********************************************************************************************
//
//  Event: 	  ue_CheckRequired
//  Purpose:  Event to check the required fields in the datawindow on save as the ItemError
//				  event does not fire reliably.  Also validates the data in the editmask fields.
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/30/2002 K. Claver   Created
//**********************************************************************************************
Integer l_nRV = 1, l_nColCount, l_nCol
String l_cVisible, l_cData, l_cRequired, l_cColName, l_cMessage, l_cDate, l_cTime
Blob l_blDateTime

l_nColCount = Integer( THIS.Object.Datawindow.Column.Count )
IF l_nColCount > 0 THEN
	THIS.SetFocus( )
	
	l_nRV = THIS.AcceptText( )
	
	IF l_nRV = -1 THEN
		//Should have an error message to display.
		IF NOT IsNull( PARENT.i_cItemErrMsg ) AND Trim( PARENT.i_cItemErrMsg ) <> "" THEN
			IF a_bShowMessage THEN
				MessageBox( gs_AppName, PARENT.i_cItemErrMsg, StopSign!, OK! )
			END IF
		END IF
	END IF
	
	//If no prior error message, or the AcceptText failed with no error, let fall
	//  through and check required fields.
	IF l_nRV <> -1 OR ( l_nRV = -1 AND ( IsNull( PARENT.i_cItemErrMsg ) OR &
	   Trim( PARENT.i_cItemErrMsg ) = "" ) ) THEN
		FOR l_nCol = 1 TO l_nColCount
			l_cVisible = THIS.Describe( "#"+String( l_nCol )+".Visible")
			IF l_cVisible = "1" THEN
				//Check the column type to determine how to check if required.
				CHOOSE CASE Upper( THIS.Describe( "#"+String( l_nCol )+".Edit.Style" ) )
					CASE "EDIT"
						l_cRequired = Upper( THIS.Describe( "#"+String( l_nCol )+".Edit.Required" ) )
					CASE "EDITMASK"
						l_cRequired = Upper( THIS.Describe( "#"+String( l_nCol )+".EditMask.Required" ) )
					CASE "DDLB"
						l_cRequired = Upper( THIS.Describe( "#"+String( l_nCol )+".DDLB.Required" ) )
				END CHOOSE
				
				//Populate the column name to save the mapped columns
				l_cColName = THIS.Describe( "#"+String( l_nCol )+".Name")
				
				//Need to check the first four characters of the column type as CHAR and DECIMAL both
				//  incorporate a precision property(ie. char(10)).  If a column has simply been cleared, 
				//  set its value back to null to check for required fields.
				CHOOSE CASE Trim( Upper( Left( THIS.Describe( "#"+String( l_nCol )+".ColType" ), 4 ) ) )
					CASE "CHAR"
						l_cData = THIS.GetItemString( 1, l_nCol )
					CASE "DATE"
						//Date and datetime
						IF Upper( THIS.Describe( "#"+String( l_nCol )+".ColType" ) ) = "DATE" THEN
							l_cData = String( THIS.GetItemDate( 1, l_nCol ) )
						ELSE
							l_cData = String( THIS.GetItemDateTime( 1, l_nCol ) )
						END IF
					CASE "DECI"
						l_cData = String( THIS.GetItemDecimal( 1, l_nCol ) )
					CASE "INT","LONG","NUMB","REAL","ULON"
						//All numbers but decimal
						l_cData = String( THIS.GetItemNumber( 1, l_nCol ) )
					CASE "TIME"
						// use for time and timestamp
						l_cData = String( THIS.GetItemTime( 1, l_nCol ) )
				END CHOOSE
				
				IF ( IsNull( l_cData ) OR Trim( l_cData ) = "" ) AND &
					l_cRequired = "YES" THEN
					f_StringReplaceAll( l_cColName, "_", " " )
					l_cColName = f_WordCap( l_cColName )
					
					IF a_bShowMessage THEN
						MessageBox( gs_AppName, "Value required for field "+l_cColName, StopSign!, OK! )
					ELSE
						PARENT.i_cItemErrMsg = ( "Value required for field "+l_cColName )
					END IF
					
					THIS.SetFocus( )
					
					l_nRV = -1
					EXIT
				ELSE
					//Check validity of data on edit fields
					IF Left( Upper( THIS.Describe( "#"+String( l_nCol )+".Edit.Style" ) ), 4 ) = "EDIT" THEN
						//Mainly concerned about dates, datetimes and times.  Don't want them to enter
						//  an incomplete date.
						CHOOSE CASE Upper( Trim( THIS.Describe( "#"+String( l_nCol )+".ColType" ) ) )
							CASE "DATE"
								IF NOT IsDate( l_cData ) THEN
									l_cMessage = "Invalid date entered for field "
								END IF
							CASE "DATETIME"
								//Convert the data to a blob first 'cause for some odd reason, there's
								//  no PowerScript function that extracts just the date or the time from
								//  a string.
								l_blDateTime = Blob( l_cData )
								l_cDate = String( Date( l_blDateTime ) )
								l_cTime = String( Time( l_blDateTime ) )
								IF NOT IsDate( l_cDate ) THEN
									l_cMessage = "Invalid date entered for field "
								END IF
								
								IF NOT IsTime( l_cTime ) THEN
									l_cMessage = "Invalid time entered for field "
								END IF						
							CASE "TIME"
								IF NOT IsTime( l_cData ) THEN
									l_cMessage = "Invalid time entered for field "
								END IF
						END CHOOSE
						
						IF NOT IsNull( l_cMessage ) AND Trim( l_cMessage ) <> "" THEN
							f_StringReplaceAll( l_cColName, "_", " " )
							l_cColName = f_WordCap( l_cColName )
							
							l_cMessage += l_cColName
							
							IF a_bShowMessage THEN
								MessageBox( gs_AppName, l_cMessage, StopSign!, OK! )
							ELSE
								PARENT.i_cItemErrMsg = l_cMessage
							END IF
							
							THIS.SetFocus( )
							
							l_nRV = -1
							EXIT
						END IF
					END IF				
				END IF
			END IF
		NEXT
	END IF
END IF

RETURN l_nRV
end event

event ue_keypressed;//**********************************************************************************************
//
//  Event: 	  ue_KeyPressed
//  Purpose:  Event to fire the event to display the error message generated by a field not passing
//				  validation
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/30/2002 K. Claver   Created
//**********************************************************************************************
IF key = KeyTab! OR key = KeyEnter! THEN
	SetNull( PARENT.i_cItemErrMsg )
	THIS.Event Post ue_PostShowError( )
END IF
end event

event ue_postshowerror;IF NOT IsNull( PARENT.i_cItemErrMsg ) AND Trim( PARENT.i_cItemErrMsg ) <> "" THEN
	MessageBox( gs_AppName, PARENT.i_cItemErrMsg, StopSign!, OK! )
END IF
end event

event itemerror;//**********************************************************************************************
//
//  Event: 	  ItemError
//  Purpose:  Please see PB documentation for this event.
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/29/2002 K. Claver   Set to return 1 so doesn't display validation messages.  Validation is
//									done in ue_checkfields event as this event does not reliably fire for
//									required fields.
//**********************************************************************************************
String l_cMessage, l_cDate, l_cTime, l_cColName
Blob l_blDateTime

IF Left( Upper( THIS.Describe( dwo.Name+".Edit.Style" ) ), 4 ) = "EDIT" THEN
	//Mainly concerned about dates, datetimes and times.  Don't want them to enter
	//  an incomplete date.
	CHOOSE CASE Upper( Trim( THIS.Describe( dwo.Name+".ColType" ) ) )
		CASE "DATE"
			IF NOT IsDate( data ) THEN
				l_cMessage = "Invalid date entered for field "
			END IF
		CASE "DATETIME"
			//Convert the data to a blob first 'cause for some odd reason, there's
			//  no PowerScript function that extracts just the date or the time from
			//  a string.
			l_blDateTime = Blob( data )
			l_cDate = String( Date( l_blDateTime ) )
			l_cTime = String( Time( l_blDateTime ) )
			IF NOT IsDate( l_cDate ) THEN
				l_cMessage = "Invalid date entered for field "
			END IF
			
			IF NOT IsTime( l_cTime ) THEN
				l_cMessage = "Invalid time entered for field "
			END IF						
		CASE "TIME"
			IF NOT IsTime( data ) THEN
				l_cMessage = "Invalid time entered for field "
			END IF
	END CHOOSE
	
	IF NOT IsNull( l_cMessage ) AND Trim( l_cMessage ) <> "" THEN
		l_cColName = dwo.Name
		f_StringReplaceAll( l_cColName, "_", " " )
		l_cColName = f_WordCap( l_cColName )
		
		l_cMessage += l_cColName
		PARENT.i_cItemErrMsg = l_cMessage
		THIS.SetFocus( )
	END IF
ELSE
	l_cColName = dwo.Name
	f_StringReplaceAll( l_cColName, "_", " " )
	l_cColName = f_WordCap( l_cColName )
	
	//Allow for user defined validation messages
	l_cMessage = dwo.ValidationMsg
	
	IF NOT IsNull( l_cMessage ) AND Trim( l_cMessage ) <> "" THEN
		PARENT.i_cItemErrMsg = l_cMessage
	ELSE
		PARENT.i_cItemErrMsg = ( l_cColName+" did not pass validation" )
	END IF
	
	THIS.SetFocus( )
END IF

RETURN 1
end event

