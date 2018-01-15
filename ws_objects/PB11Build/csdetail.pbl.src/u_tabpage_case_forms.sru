$PBExportHeader$u_tabpage_case_forms.sru
forward
global type u_tabpage_case_forms from u_tabpg_std
end type
type cb_print from commandbutton within u_tabpage_case_forms
end type
type cb_view from commandbutton within u_tabpage_case_forms
end type
type cb_edit from commandbutton within u_tabpage_case_forms
end type
type st_noforms from statictext within u_tabpage_case_forms
end type
type cb_delete from commandbutton within u_tabpage_case_forms
end type
type cb_add from commandbutton within u_tabpage_case_forms
end type
type dw_case_form_list from u_dw_std within u_tabpage_case_forms
end type
type dw_case_form from datawindow within u_tabpage_case_forms
end type
end forward

global type u_tabpage_case_forms from u_tabpg_std
integer width = 3534
integer height = 784
event ue_openform ( integer a_nrow,  string a_copenmode )
cb_print cb_print
cb_view cb_view
cb_edit cb_edit
st_noforms st_noforms
cb_delete cb_delete
cb_add cb_add
dw_case_form_list dw_case_form_list
dw_case_form dw_case_form
end type
global u_tabpage_case_forms u_tabpage_case_forms

type prototypes
FUNCTION long ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "SHELL32.DLL" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder
U_DW_STD						i_dwCaseDetails
W_CASE_FORMS				i_wOpenForms[ ]
end variables

forward prototypes
public function string fu_getopenerrortext (integer a_nrv)
public subroutine fu_disable ()
end prototypes

event ue_openform;/*****************************************************************************************
   Event:      ue_OpenForm
   Purpose:    Open the form window in view or edit mode.  Checks to see if the form is
					already open.  If so, brings that window to the foreground.
					
	Parameters: Integer - a_nRow
					String - a_cOpenMode - V = View
												  E = Edit
												  A = Add

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/16/2002 K. Claver   Created
*****************************************************************************************/
String l_cFormKey, l_cParm, l_cConfidLevel
Integer l_nOpenIndex, l_nIndex
Boolean l_bFound = FALSE

//Get the upperbound of the window array.
l_nOpenIndex = UpperBound( THIS.i_wOpenForms )

IF a_nRow > 0 THEN
	l_cFormKey = dw_case_form_list.Object.form_key[ a_nRow ]
	
	//See if the form is already open.
	IF l_nOpenIndex > 0 THEN
		FOR l_nIndex = 1 TO l_nOpenIndex
			IF IsValid( THIS.i_wOpenForms[ l_nIndex ] ) THEN
				IF NOT IsNull( THIS.i_wOpenForms[ l_nIndex ].i_cFormKey ) AND &
					THIS.i_wOpenForms[ l_nIndex ].i_cFormKey = l_cFormKey THEN
					//If the form is already open in a mode other than the one passed, let the user know.
					IF THIS.i_wOpenForms[ l_nIndex ].i_bView AND a_cOpenMode = "E" THEN
						MessageBox( gs_AppName, "Form is already open in View mode.  Please close and reopen for edit." )
					ELSEIF NOT THIS.i_wOpenForms[ l_nIndex ].i_bView AND a_cOpenMode = "V" THEN
						MessageBox( gs_AppName, "Form is already open in Edit mode" )
					END IF
					
					//Bring the window to the top and mark as found.
					THIS.i_wOpenForms[ l_nIndex ].BringToTop = TRUE
					l_bFound = TRUE						
				END IF
			END IF
		NEXT
	END IF
END IF

//If not already open, open another window.
IF NOT l_bFound THEN
	l_nOpenIndex++
	
	IF IsNull( i_wParentWindow.i_nRepConfidLevel ) THEN
		l_cConfidLevel = "0"
	ELSE
		l_cConfidLevel = String( i_wParentWindow.i_nRepConfidLevel )
	END IF

	//Set the parm to pass.  If open in Add mode, don't pass the form key.
	IF a_cOpenMode = "A" THEN
		l_cParm = ( a_cOpenMode+"&"+i_wParentWindow.i_cCurrentCase+"&"+i_wParentWindow.i_cCaseType+"&"+i_wParentWindow.i_cSourceType+"&"+&
						l_cConfidLevel )
	ELSE
		l_cParm = ( a_cOpenMode+"&"+i_wParentWindow.i_cCurrentCase+"&"+i_wParentWindow.i_cCaseType+"&"+i_wParentWindow.i_cSourceType+ &
					  "&"+l_cConfidLevel+"&"+l_cFormKey )
	END IF
	
	//Open the window, passing in a string parm
	FWCA.MGR.fu_OpenWindow( THIS.i_wOpenForms[ l_nOpenIndex ], "w_case_forms", -1, l_cParm )
END IF
end event

public function string fu_getopenerrortext (integer a_nrv);/*****************************************************************************************
   Function:   fu_GetOpenErrorText
   Purpose:    Function to return the error message associated with the code
					returned from the ShellExecuteA function in the shell32 dll.
					
	Parameters: a_nRV - Integer - The error code.
	Returns:    String - The error message associated with the code.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/4/2001 K. Claver   Created.
*****************************************************************************************/
CHOOSE CASE a_nRV
	CASE 0 
		RETURN "The operating system is out of memory or resources."
	CASE 2 
		RETURN "The specified file was not found"
	CASE 3 
		RETURN "The specified path was not found."
	CASE 5 
		RETURN "The operating system denied access to the specified file."
	CASE 8 
		RETURN "There was not enough memory to complete the operation."
	CASE 10
		RETURN "Wrong Windows version"
	CASE 11
		RETURN "The .EXE file is invalid (non-Win32 .EXE or error in .EXE image)."
	CASE 12
		RETURN "Application was designed for a different operating system."
	CASE 13
		RETURN "Application was designed for MS-DOS 4.0."
	CASE 15
		RETURN "Attempt to load a real-mode program."
	CASE 16
		RETURN "Attempt to load a second instance of an application with non-readonly data segments."
	CASE 19
		RETURN "Attempt to load a compressed application file."
	CASE 20
		RETURN "Dynamic-link library (DLL) file failure."
	CASE 26
		RETURN "A sharing violation occurred."
	CASE 27 
		RETURN "The filename association is incomplete or invalid."
	CASE 28
		RETURN "The DDE transaction could not be completed because the request timed out."
	CASE 29
		RETURN "The DDE transaction failed."
	CASE 30
		RETURN "The DDE transaction could not be completed because other DDE transactions were being processed."
	CASE 31
		RETURN "There is no application associated with the given filename extension."
	CASE 32
		RETURN "The specified dynamic-link library was not found."
	CASE ELSE
		RETURN "Undocumented error code returned"
END CHOOSE
end function

public subroutine fu_disable ();/*****************************************************************************************
   Function:   fu_Disable
   Purpose:    Function to enable/disable the buttons on the tabpage.
					
	Parameters: None
	Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/10/2001 K. Claver  Created.
	4/16/2002  K. Claver  Added code to accomodate for Reassign Case Subject.
*****************************************************************************************/
Integer l_nConfidLevel, l_nRow, l_nCount
String l_cLikeCaseTypes, l_cLikeSourceTypes, l_cTemplateKey

//Enable the add button.  Should only be disabled for closed or voided cases or new cases.
IF Trim( THIS.i_wParentWindow.i_cCurrentCase ) = "" THEN // new case, the insert will fail until the case is saved
	cb_add.Enabled = FALSE
ELSE
	IF THIS.i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = "O" THEN
		//First, check if there are templates defined for this case and source type
		l_cLikeCaseTypes = ( "%"+THIS.i_wParentWindow.i_cCaseType+"%" )
		l_cLikeSourceTypes = ( "%"+THIS.i_wParentWindow.i_cSourceType+"%" )
		
		SELECT Count( * )
		INTO :l_nCount
		FROM cusfocus.form_templates
		WHERE case_types LIKE :l_cLikeCaseTypes AND
				source_types LIKE :l_cLikeSourceTypes AND
				active = 1
		USING SQLCA;
		
		IF SQLCA.SQLCode <> 0 THEN
			MessageBox( gs_AppName, "Error determining form availability for case and source type.~r~nError Returned:~r~n"+ &
							SQLCA.SQLErrText, StopSign!, OK! )
			cb_add.Enabled = FALSE
		ELSE
			IF l_nCount > 0 THEN
				cb_add.Enabled = TRUE
			ELSE
				cb_add.Enabled = FALSE
			END IF
		END IF
	ELSE
		//-----------------------------------------------------------------------------------------------------------------------------------
	
		// JWhite 1/3/06 - Adding a check to enable the button if the user is in the "Edit Closed Case" role in the registry.
		//-----------------------------------------------------------------------------------------------------------------------------------
	
		If i_wParentWindow.i_bSupervisorRole = TRUE Then 
			cb_add.Enabled = TRUE
		Else 
			cb_add.Enabled = FALSE
		End If
		
	END IF
END IF

//Check if can enable the other buttons.
l_nRow = dw_case_form_list.GetSelectedRow( 0 )
			
IF l_nRow > 0 AND Trim( THIS.i_wParentWindow.i_cCurrentCase ) <> "" AND &
	NOT THIS.i_wParentWindow.i_bCaseLocked THEN
	l_nConfidLevel = dw_case_form_list.Object.confidentiality_level[ l_nRow ] 
	l_cTemplateKey = dw_case_form_list.Object.template_key[ l_nRow ]
	
	//Check if the form is active for the case and source type
	SELECT Count( * )
	INTO :l_nCount
	FROM cusfocus.form_templates
	WHERE case_types LIKE :l_cLikeCaseTypes AND
			source_types LIKE :l_cLikeSourceTypes AND
			template_key = :l_cTemplateKey AND 
			active = 1
	USING SQLCA;
	
	IF l_nConfidLevel > THIS.i_wParentWindow.i_nRepConfidLevel AND NOT IsNull( l_nConfidLevel ) THEN
		cb_view.Enabled = FALSE
		cb_edit.Enabled = FALSE
		cb_delete.Enabled = FALSE
		cb_print.Enabled = FALSE
	ELSE
		//Open and save should be enabled for cases the user has security to view(open or closed)
		cb_view.Enabled = TRUE
		cb_print.Enabled = TRUE
		
		//Enable edit and delete if the case is open and the form is active for the case and
		//  source type
		IF THIS.i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = "O" AND l_nCount > 0 THEN			
			cb_edit.Enabled = TRUE
			cb_delete.Enabled = TRUE
		ELSE
			//-----------------------------------------------------------------------------------------------------------------------------------

			// JWhite 1/3/06 - Adding a check to enable the button if the user is in the "Edit Closed Case" role in the registry.
			//-----------------------------------------------------------------------------------------------------------------------------------

			If i_wParentWindow.i_bSupervisorRole = TRUE Then 
				cb_edit.Enabled = TRUE
				cb_delete.Enabled = TRUE
			Else
				cb_edit.Enabled = FALSE
				cb_delete.Enabled = FALSE
			End If
		END IF
	END IF
ELSE
	IF l_nRow > 0 AND Trim( THIS.i_wParentWindow.i_cCurrentCase ) <> "" AND &
	   THIS.i_wParentWindow.i_bCaseLocked THEN
		l_nConfidLevel = dw_case_form_list.Object.confidentiality_level[ l_nRow ] 
	
		IF l_nConfidLevel <= THIS.i_wParentWindow.i_nRepConfidLevel OR IsNull( l_nConfidLevel ) THEN
			cb_view.Enabled = TRUE
			cb_print.Enabled = TRUE
		ELSE
			cb_view.Enabled = FALSE
			cb_print.Enabled = FALSE
		END IF
	ELSE
		cb_view.Enabled = FALSE
		cb_print.Enabled = FALSE
	END IF
	
	cb_edit.Enabled = FALSE
	cb_delete.Enabled = FALSE
END IF

//IF dw_case_form_list.RowCount( ) = 0 THEN
//	st_noforms.Visible = TRUE
//ELSE
//	st_noforms.Visible = FALSE
//END IF
end subroutine

on u_tabpage_case_forms.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_view=create cb_view
this.cb_edit=create cb_edit
this.st_noforms=create st_noforms
this.cb_delete=create cb_delete
this.cb_add=create cb_add
this.dw_case_form_list=create dw_case_form_list
this.dw_case_form=create dw_case_form
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_view
this.Control[iCurrent+3]=this.cb_edit
this.Control[iCurrent+4]=this.st_noforms
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_add
this.Control[iCurrent+7]=this.dw_case_form_list
this.Control[iCurrent+8]=this.dw_case_form
end on

on u_tabpage_case_forms.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_view)
destroy(this.cb_edit)
destroy(this.st_noforms)
destroy(this.cb_delete)
destroy(this.cb_add)
destroy(this.dw_case_form_list)
destroy(this.dw_case_form)
end on

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Added code set instance variables and register the objects with the
								 resize service.
*****************************************************************************************/
i_wParentWindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder
i_dwCaseDetails = i_tabFolder.tabpage_case_details.dw_case_details

THIS.of_SetResize( TRUE )
IF IsValid( THIS.inv_resize ) THEN
	// resize the attachment list view
	THIS.inv_resize.of_Register( dw_case_form_list, "ScaleToRight&Bottom" )
	
	// reposition buttons
	THIS.inv_resize.of_Register( cb_add, "FixedToRight&Bottom" )
	THIS.inv_resize.of_Register( cb_edit, "FixedToRight&Bottom" )
	THIS.inv_resize.of_Register( cb_delete, "FixedToRight&Bottom" ) 
	THIS.inv_resize.of_Register( cb_view, "FixedToBottom" )
	THIS.inv_resize.of_Register( cb_print, "FixedToBottom" )
END IF
end event

event destructor;call super::destructor;/*****************************************************************************************
   Event:      destructor
   Purpose:    Please see PB documentation for this event.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/5/2001 K. Claver   Added code to attempt to clean up opened attachment files stored
								 in the temp directory.
*****************************************************************************************/
Long l_nFileNum
ContextKeyword l_ckTemp
String l_cAttachFileLog, l_cTemp[ ], l_cDeleteFile
n_cst_kernel32 l_uoKernelFuncs

// Get the Temp Path from Environment Variables to attempt to find the log file.
l_ckTemp = CREATE ContextKeyword
l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 

//Have the needed info.  Destroy the object.
DESTROY l_ckTemp

//If temp Path is not available, use Root drive.
IF NOT l_uoKernelFuncs.of_DirectoryExists( l_cTemp[ 1 ] ) THEN 
	l_cTemp[ 1 ] = 'C:\'
END IF

//Get rid of any potential white space.
l_cTemp[ 1 ] = Trim( l_cTemp[ 1 ] )

//Add the directory to the file name.
IF Mid( l_cTemp[ 1 ], Len( l_cTemp[ 1 ] ), 1 ) = "\" THEN
	l_cAttachFileLog = ( l_cTemp[ 1 ]+"cfattachfile.log" )
ELSE
	l_cAttachFileLog = ( l_cTemp[ 1 ]+"\"+"cfattachfile.log" )
END IF

IF FileExists( l_cAttachFileLog ) THEN
	//Open the file and read each line.
	l_nFileNum = FileOpen( l_cAttachFileLog, LineMode!, Read!, LockRead! )
	
	IF l_nFileNum > 0 THEN
		DO WHILE FileRead( l_nFileNum, l_cDeleteFile ) > 0
			l_cDeleteFile = Trim( l_cDeleteFile )
			
			//Delete the file if it exists.
			IF FileExists( l_cDeleteFile ) THEN
				FileDelete( l_cDeleteFile )
			END IF
		LOOP
		
		FileClose( l_nFileNum )
		
		//Clean up the attachment log file.
		FileDelete( l_cAttachFileLog )
	END IF
END IF
		
end event

type cb_print from commandbutton within u_tabpage_case_forms
integer x = 498
integer y = 672
integer width = 448
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;//**********************************************************************************************
//
//  Event:   Clicked
//  Purpose: Please see PB documentation for this event.
//						
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/04/2002 K. Claver   Added code to set up and print the selected form.
//**********************************************************************************************
ULong l_ulPrintJob
Integer l_nRV, l_nSelectedRow
String l_cFormKey

l_nSelectedRow = dw_case_form_list.GetSelectedRow( 0 )

IF l_nSelectedRow > 0 THEN
	l_cFormKey = dw_case_form_list.Object.form_key[ l_nSelectedRow ]
	
	//Load the form
	l_nRV = dw_case_form.Event Trigger ue_LoadForm( l_cFormKey )
	
	IF l_nRV > 0 THEN
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
	END IF
END IF
end event

type cb_view from commandbutton within u_tabpage_case_forms
integer x = 23
integer y = 672
integer width = 448
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Review"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Added call to event to open the attachment.
*****************************************************************************************/
Integer l_nRow

l_nRow = dw_case_form_list.GetSelectedRow( 0 )

IF l_nRow > 0 THEN
	PARENT.Event Trigger ue_OpenForm( l_nRow, "V" )
END IF
end event

type cb_edit from commandbutton within u_tabpage_case_forms
integer x = 2578
integer y = 672
integer width = 448
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Edit"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Added code to open the case form window to allow the user to
								 edit the description, form or the security.
*****************************************************************************************/
Integer l_nRow

l_nRow = dw_case_form_list.GetSelectedRow( 0 )

IF l_nRow > 0 THEN
	PARENT.Event Trigger ue_OpenForm( l_nRow, "E" )
END IF
end event

type st_noforms from statictext within u_tabpage_case_forms
boolean visible = false
integer x = 37
integer y = 108
integer width = 955
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "There are no forms for this case."
boolean focusrectangle = false
end type

type cb_delete from commandbutton within u_tabpage_case_forms
integer x = 3058
integer y = 672
integer width = 448
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Added code to delete the selected row from the datawindow
*****************************************************************************************/
Integer l_nRow[ ], l_nSelectedRow, l_nRV, l_nMessageRV, l_nConfidLevel, l_nOpenIndex, l_nIndex
String l_cFormKey

l_nSelectedRow = dw_case_form_list.GetSelectedRow( 0 )

IF l_nSelectedRow > 0 THEN
	//Get the upperbound of the open forms window array.
	l_nOpenIndex = UpperBound( PARENT.i_wOpenForms )
	
	l_cFormKey = dw_case_form_list.Object.form_key[ l_nSelectedRow ]
		
	//See if the form is already open.
	IF l_nOpenIndex > 0 THEN
		FOR l_nIndex = 1 TO l_nOpenIndex
			IF IsValid( PARENT.i_wOpenForms[ l_nIndex ] ) THEN
				IF NOT IsNull( PARENT.i_wOpenForms[ l_nIndex ].i_cFormKey ) AND &
					PARENT.i_wOpenForms[ l_nIndex ].i_cFormKey = l_cFormKey THEN
					MessageBox( gs_AppName, "This form cannot be deleted while open in the form window", &
									StopSign!, OK! )
					RETURN
				END IF
			END IF
		NEXT
	END IF
	
	l_nMessageRV = MessageBox( gs_AppName, "Are you sure you want to delete the selected form?",+ &
										Question!, YesNo! )
										
	IF l_nMessageRV = 1 THEN
		l_nRow[ 1 ] = l_nSelectedRow
		
		l_nRV = dw_case_form_list.fu_Delete( 1, &
												  		 l_nRow, &
												  		 dw_case_form_list.c_IgnoreChanges )														  
		
		IF l_nRV = 0 THEN
			l_nRV = dw_case_form_list.fu_Save( dw_case_form_list.c_SaveChanges )
		END IF
		
		IF l_nRV < 0 THEN
			MessageBox( gs_AppName, "Failed to delete the form", StopSign!, OK! )
		END IF
	END IF
END IF

//Enable/Disable the buttons
PARENT.fu_Disable( )
end event

type cb_add from commandbutton within u_tabpage_case_forms
integer x = 2098
integer y = 672
integer width = 448
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Add"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	1/16/2002 K. Claver  Added code to open the form window and attach a form to the current
								 case.
*****************************************************************************************/
PARENT.Event Trigger ue_OpenForm( 0, "A" )	
	

end event

type dw_case_form_list from u_dw_std within u_tabpage_case_forms
event ue_selecttrigger pbm_dwnkey
integer x = 14
integer y = 12
integer width = 3497
integer taborder = 10
string dataobject = "d_case_form_list"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;/*****************************************************************************************
   Event:      ue_SelectTrigger
   Purpose:    Open the attachment if the user presses enter while on the row

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/28/2002 K. Claver   Created
*****************************************************************************************/
Integer l_nRow, l_nConfidLevel

// if the user pressed the enter key while on a row, process it.
IF ( key = KeyEnter! ) AND ( THIS.GetRow( ) > 0 ) THEN
	
	// Get the selected row
	l_nRow = THIS.GetRow( )
	
	IF l_nRow > 0 THEN
		l_nConfidLevel = THIS.Object.confidentiality_level[ l_nRow ]
			
		IF l_nConfidLevel <= i_wParentWindow.i_nRepConfidLevel OR IsNull( l_nConfidLevel ) THEN
			PARENT.Event Trigger ue_OpenForm( l_nRow, "V" )
		END IF
	END IF
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_SetOptions
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Created.
*****************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  THIS.c_NullDW, &
						  THIS.c_NoRetrieveOnOpen+ &
						  THIS.c_SelectOnRowFocusChange+ &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_DeleteOK+ &
						  THIS.c_ModifyOK+ &
						  THIS.c_NoMenuButtonActivation+ &
						  THIS.c_SortClickedOK )
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_Retrieve
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/2001 K. Claver  Added code to retrieve the datawindow.
*****************************************************************************************/
THIS.Retrieve( i_wParentWindow.i_cCurrentCase, i_wParentWindow.i_nRepConfidLevel )

//Need to wait until the row is reselected
PARENT.Function Post fu_Disable( )
end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/3/2001 K. Claver   Added call to event to open the attachment.
*****************************************************************************************/
Integer l_nConfidLevel

IF row > 0 THEN
	l_nConfidLevel = THIS.Object.confidentiality_level[ row ]
		
	IF l_nConfidLevel <= i_wParentWindow.i_nRepConfidLevel OR IsNull( l_nConfidLevel ) THEN
		PARENT.Event Trigger ue_OpenForm( row, "V" )
	END IF
END IF
end event

event pcd_pickedrow;call super::pcd_pickedrow;/*****************************************************************************************
   Event:      pcd_pickedrow
   Purpose:    Please see PowerClass documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/5/2001 K. Claver   Added function call to the function to enable/disable the controls
								 based on the selected row and/or security.
*****************************************************************************************/
PARENT.fu_Disable( )
end event

type dw_case_form from datawindow within u_tabpage_case_forms
event type integer ue_loadform ( string a_cformkey )
integer x = 1070
integer y = 120
integer width = 411
integer height = 432
integer taborder = 20
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type integer ue_loadform(string a_cformkey);//**********************************************************************************************
//
//  Event: 	  ue_LoadForm
//  Purpose:  Event to load the form from the case
//
//  Parameters: String - a_cFormKey - Form key of the form attached to the case.
//  Returns:    Integer - 1 for Success, -1 for Failure
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  01/24/2002 K. Claver   Created
//**********************************************************************************************
Blob l_blForm
Long l_nDataPos, l_nInsertData
String l_cError, l_cForm, l_cDataElement, l_cFormSyntax, l_cData, l_cVisible, l_cColName
Integer l_nCol, l_nColCount, l_nRV
Date l_dInsertData, l_dDate
DateTime l_dtInsertData
Decimal l_dcInsertData
Real l_rInsertData
Time l_tInsertData, l_tTime
Boolean l_bNull

SetPointer( Hourglass! )
	
//Load the form for review from the saved image
SELECTBLOB form_image
INTO :l_blForm
FROM cusfocus.case_forms
WHERE form_key = :a_cFormKey
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
				
				l_cData = Mid( l_cForm, ( l_nDataPos + 6 ) )
				
				l_nColCount = Integer( THIS.Object.Datawindow.Column.Count )
				IF l_nColCount > 0 THEN
					FOR l_nCol = 1 TO l_nColCount							
						l_cVisible = THIS.Describe( "#"+String( l_nCol )+".Visible")
						IF l_cVisible = "1" THEN
							//Get the data element from the data string
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
									IF Upper( THIS.Describe("#"+String( l_nCol )+".ColType" ) ) = "DATE" THEN
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
				END IF
			END IF
		ELSE
			l_nRV = THIS.Create( l_cForm, l_cError )
			
			IF l_nRV = -1 THEN
				MessageBox( gs_AppName, "Error creating form.~r~nError Returned:~r~n"+l_cError, StopSign!, OK! )
			ELSE
				THIS.InsertRow( 0 )
			END IF
		END IF			
	ELSE
		MessageBox( gs_AppName, "Error retrieving form syntax", StopSign!, OK! )
		l_nRV = -1
	END IF
END IF

SetPointer( Arrow! )

RETURN l_nRV
end event

