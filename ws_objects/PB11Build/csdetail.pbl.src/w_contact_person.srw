$PBExportHeader$w_contact_person.srw
$PBExportComments$Contact Person Response window
forward
global type w_contact_person from w_response_std
end type
type p_1 from picture within w_contact_person
end type
type st_4 from statictext within w_contact_person
end type
type st_3 from statictext within w_contact_person
end type
type st_2 from statictext within w_contact_person
end type
type st_1 from statictext within w_contact_person
end type
type cb_save from commandbutton within w_contact_person
end type
type cb_ok from commandbutton within w_contact_person
end type
type cb_delete from commandbutton within w_contact_person
end type
type cb_new from u_cb_new within w_contact_person
end type
type dw_contact_details from u_dw_std within w_contact_person
end type
type dw_contact_list from u_dw_std within w_contact_person
end type
type ln_1 from line within w_contact_person
end type
type ln_2 from line within w_contact_person
end type
type ln_3 from line within w_contact_person
end type
type ln_4 from line within w_contact_person
end type
type ln_5 from line within w_contact_person
end type
type ln_6 from line within w_contact_person
end type
type st_5 from statictext within w_contact_person
end type
type ln_7 from line within w_contact_person
end type
type ln_8 from line within w_contact_person
end type
end forward

global type w_contact_person from w_response_std
integer x = 256
integer y = 220
integer width = 3383
integer height = 2004
string title = "Contacts"
boolean controlmenu = false
long backcolor = 79748288
p_1 p_1
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
cb_save cb_save
cb_ok cb_ok
cb_delete cb_delete
cb_new cb_new
dw_contact_details dw_contact_details
dw_contact_list dw_contact_list
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
ln_5 ln_5
ln_6 ln_6
st_5 st_5
ln_7 ln_7
ln_8 ln_8
end type
global w_contact_person w_contact_person

type variables
STRING i_cSourceType
STRING i_cCurrentCase
STRING i_cContactPerson
STRING i_cChangeFlag = ""

BOOLEAN i_bPrimaryCleared = FALSE
end variables

forward prototypes
public subroutine fw_populatefields ()
end prototypes

public subroutine fw_populatefields ();
end subroutine

event pc_cancel;/***************************************************************************************

		Event:	clicked
		Purpose:	The user has cancled so return back an empty string and close.

*************************************************************************************/
PCCA.Parm[1] = ''
PCCA.Parm[2] = ''
Close(THIS)
end event

on w_contact_person.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_save=create cb_save
this.cb_ok=create cb_ok
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.dw_contact_details=create dw_contact_details
this.dw_contact_list=create dw_contact_list
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.ln_5=create ln_5
this.ln_6=create ln_6
this.st_5=create st_5
this.ln_7=create ln_7
this.ln_8=create ln_8
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_save
this.Control[iCurrent+7]=this.cb_ok
this.Control[iCurrent+8]=this.cb_delete
this.Control[iCurrent+9]=this.cb_new
this.Control[iCurrent+10]=this.dw_contact_details
this.Control[iCurrent+11]=this.dw_contact_list
this.Control[iCurrent+12]=this.ln_1
this.Control[iCurrent+13]=this.ln_2
this.Control[iCurrent+14]=this.ln_3
this.Control[iCurrent+15]=this.ln_4
this.Control[iCurrent+16]=this.ln_5
this.Control[iCurrent+17]=this.ln_6
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.ln_7
this.Control[iCurrent+20]=this.ln_8
end on

on w_contact_person.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_save)
destroy(this.cb_ok)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.dw_contact_details)
destroy(this.dw_contact_list)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.ln_5)
destroy(this.ln_6)
destroy(this.st_5)
destroy(this.ln_7)
destroy(this.ln_8)
end on

event pc_setoptions;call super::pc_setoptions;//************************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To set options
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  02/15/02 C. Jackson  Original Version
//  4/25/2002 K. Claver  Moved code to set the instance variables and window title here.
//************************************************************************************************

DATAWINDOWCHILD l_dwcRelationship

//Set the case instance variables
THIS.i_cCurrentCase = PCCA.Parm[1] 
THIS.i_cSourceType = PCCA.Parm[2]

//Retrieve the relationships into the detail datawindow
dw_contact_details.GetChild('relationship_id', l_dwcRelationship)
l_dwcRelationship.SetTransObject(SQLCA)
l_dwcRelationship.Retrieve(THIS.i_cSourceType)
dw_contact_details.SetColumn('relationship_id')

//Set the title for the window
THIS.Title = ( Title+" for Case "+THIS.i_cCurrentCase )

end event

type p_1 from picture within w_contact_person
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_4 from statictext within w_contact_person
integer x = 201
integer y = 60
integer width = 1600
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Contact Person"
boolean focusrectangle = false
end type

type st_3 from statictext within w_contact_person
integer width = 3383
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_2 from statictext within w_contact_person
integer x = 46
integer y = 204
integer width = 645
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "Contact Person - Add/Details"
boolean focusrectangle = false
end type

type st_1 from statictext within w_contact_person
integer x = 46
integer y = 980
integer width = 635
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "Contact Person List for Case "
boolean focusrectangle = false
end type

type cb_save from commandbutton within w_contact_person
integer x = 3013
integer y = 400
integer width = 311
integer height = 90
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Please see PB documentation for this event.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  5/13/2002 K. Claver  Save the changes
//***********************************************************************************************
dw_contact_details.fu_Save( dw_contact_details.c_SaveChanges )
end event

type cb_ok from commandbutton within w_contact_person
integer x = 2990
integer y = 1788
integer width = 320
integer height = 90
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To save and close
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/19/02 C. Jackson  Original Version
//	 4/25/2002 K. Claver  Added code to check datawindow status and check the return value for fu_Save
//  5/13/2002 K. Claver  Commented out save error message per request of QA
//  5/20/2002 K. Claver  Moved update to case log to this script.
//***********************************************************************************************
Integer l_nRV, l_nMessageRV
DWItemStatus l_dwisStatus
String l_cPrimary

//Check for status and ask save question here as want to get primary contact id
//  after save for pass back to the contact person function in the create/maintain
//  case window.
IF dw_contact_details.RowCount( ) > 0 THEN
	dw_contact_details.AcceptText( )
	l_dwisStatus = dw_contact_details.GetItemStatus( 1, 0, Primary! )
	IF l_dwisStatus = NewModified! OR l_dwisStatus = DataModified! THEN
		l_nMessageRV = MessageBox( gs_AppName, "Do you want to save changes before closing the window?", Question!, YesNoCancel! )
		
		IF l_nMessageRV = 1 THEN
			//Yes
			l_nRV = dw_contact_details.fu_Save( dw_contact_details.c_SaveChanges )

			IF l_nRV <> 0 THEN
				RETURN
			END IF
		ELSEIF l_nMessageRV = 2 THEN
			//No
			dw_contact_details.fu_ResetUpdate( )
		ELSEIF l_nMessageRV = 3 THEN
			//Cancel
			RETURN
		END IF
	END IF
END IF

IF dw_contact_list.RowCount( ) > 0 THEN
	//Get the current primary contact person id to pass back
	l_nRV = dw_contact_list.Find( "contact_primary_yn = 'Y'", 1, dw_contact_list.RowCount( ) )
	IF l_nRV > 0 THEN
		PARENT.i_cContactPerson = dw_contact_list.Object.contact_person_id[ l_nRV ]
		
		//Get the current contact primary id from case log to see if we need to update
		SELECT contact_person_id
		INTO :l_cPrimary
		FROM cusfocus.case_log
		WHERE case_number = :PARENT.i_cCurrentCase
		USING SQLCA;
		
		IF SQLCA.SQLCode = 0 THEN
			IF l_cPrimary <> PARENT.i_cContactPerson OR IsNull( l_cPrimary ) THEN
				UPDATE cusfocus.case_log
				SET contact_person_id = :PARENT.i_cContactPerson
				WHERE case_number = :PARENT.i_cCurrentCase
				USING SQLCA;
				
				IF SQLCA.SQLCode <> 0 THEN
					MessageBox( gs_AppName, "Error updating primary contact", StopSign!, OK! )
					RETURN
				ELSE
					PARENT.i_cChangeFlag = "CHANGED"
				END IF
			END IF
		ELSE
			MessageBox( gs_AppName, "Error obtaining primary contact", StopSign!, OK! )
			RETURN
		END IF
	END IF
END IF

CloseWithReturn( PARENT, PARENT.i_cChangeFlag )
end event

type cb_delete from commandbutton within w_contact_person
integer x = 3013
integer y = 848
integer width = 311
integer height = 90
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To delete the selected record
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/15/02 C. Jackson  Original Version
//  5/16/2002 K. Claver  Changed to remove the primary contact id from the case log table before
//								 delete the primary contact to accomodate for foreign key constraint.
//  02/20/03 C. Jackson  change cb_new.Event Trigger clicked( ) to just 
//                       dw_contact_details.fu_New(1)
//***********************************************************************************************

Integer l_nMessageRV, l_nRV, l_nRowCount
Long l_nRows[], l_nRow
String l_cContactPrimary, l_cUpdateUser, l_cCurrentID
DateTime l_dtUpdateDate

l_dtUpdateDate = PARENT.fw_GetTimeStamp( )
l_cUpdateUser = OBJCA.WIN.fu_GetLogin( SQLCA )

l_nRowCount = dw_contact_list.RowCount( )

IF l_nRowCount > 0 THEN
	//Get contact primary value
	l_cContactPrimary = dw_contact_details.GetItemString( 1, 'contact_primary_yn' )
	
	IF l_nRowCount > 1 THEN
		//Check if the current row is primary
		IF l_cContactPrimary = "Y" THEN
			MessageBox( gs_AppName, "At least one Primary Contact must exist for a case when there is more than"+ &
							" one Contact defined.  Please set another Contact as Primary before deleting this one", &
							StopSign!, OK! )
			RETURN
		END IF
	END IF
	
	l_nMessageRV = MessageBox( gs_AppName, "Are you sure you want to delete this Contact Person?", &
									   Question!, YesNo! )			
	
	IF l_nMessageRV = 1 THEN
		l_nRows[ 1 ] = dw_contact_list.GetSelectedRow( 0 )
		
		l_nRV = dw_contact_list.fu_Delete( 1, &
													  l_nRows, &
													  dw_contact_list.c_IgnoreChanges )
													  
		IF l_nRV = 0 THEN
			l_nRV = dw_contact_list.fu_Save( dw_contact_list.c_SaveChanges )
			
			IF l_nRV < 0 THEN
				MessageBox( gs_AppName, "Error deleting the Contact Person", StopSign!, OK! )
			ELSE
				IF dw_contact_list.RowCount( ) = 0 THEN
					//Set the current contact instance variable to empty
					PARENT.i_cContactPerson = ""
					
//					//Add a new row if deleted the last one
					dw_contact_details.fu_New( 1 )
					dw_contact_details.SetFocus()
					dw_contact_details.SetColumn('relationship_id')
				ELSE
					//Force selection of the newly highlighted row
					l_nRow = dw_contact_list.GetSelectedRow( 0 )
					IF l_nRow > 0 THEN
						dw_contact_list.Event Trigger doubleclicked( 0, 0, l_nRow, dw_contact_list.Object.contact_name )
					END IF
				END IF
			END IF
		ELSE
			MessageBox( gs_AppName, "Error deleting the Contact Person", StopSign!, OK! )
		END IF
	END IF
END IF
end event

type cb_new from u_cb_new within w_contact_person
integer x = 3013
integer y = 276
integer height = 90
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;call super::clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To create a new Contact Person record
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/15/02 C. Jackson  Original Verison
//  4/25/2002 K. Claver  Changed to use the Find function on the list datawindow instead of an 
//								 instance variable set at retrieve.  Also reset the update flags.
//***********************************************************************************************

Integer l_nRowCount

dw_contact_details.fu_New( 1 )
dw_contact_details.SetItem(1,'case_number',PARENT.i_cCurrentCase)

l_nRowCount = dw_contact_list.RowCount( )

//If this this the first contact person, set it a Primary by default
IF l_nRowCount > 0 THEN
	IF dw_contact_list.Find( "contact_primary_yn = 'Y'", 1, l_nRowCount ) = 0 THEN   
		dw_contact_details.SetItem(1,'contact_primary_yn','Y')
	END IF
ELSE
	dw_contact_details.SetItem(1,'contact_primary_yn','Y')
END IF

dw_contact_details.SetFocus()
dw_contact_details.SetColumn('relationship_id')

//Reset the update flags as don't want to prompt to save if haven't modified anything
dw_contact_details.SetItemStatus( 1, 0, Primary!, NotModified! )
end event

type dw_contact_details from u_dw_std within w_contact_person
integer x = 55
integer y = 256
integer width = 2857
integer height = 720
integer taborder = 10
string dataobject = "d_contact_person_details"
boolean border = false
end type

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    To retrieve the contact person

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/27/03 M. Caruso    Added code to filter the relationship list based on active codes
								 or the code that is currently set for the contact.
*****************************************************************************************/
LONG 		l_nReturn
STRING				l_cCurrentRelID
DATAWINDOWCHILD	l_dwcList

IF NOT IsNull( PARENT.i_cContactPerson ) AND Trim( PARENT.i_cContactPerson ) <> "" THEN
	l_nReturn = THIS.Retrieve( PARENT.i_cContactPerson )
	
	IF l_nReturn < 0 THEN
		MessageBox( gs_AppName, "Error retrieving contact person details", StopSign!, OK! )
		Error.i_FWError = c_Fatal
	ELSE
		IF NOT w_create_maintain_case.i_bCaseLocked THEN
			THIS.Function Post fu_Modify( )
		END IF
		
		This.GetChild ('relationship_id', l_dwcList)
		IF IsValid (l_dwcList) THEN
			
			l_dwcList.SetTransObject (SQLCA)
			l_cCurrentRelID = THIS.GetItemString (1, 'relationship_id')
			IF Len (l_cCurrentRelID) = 0 OR IsNull (l_cCurrentRelID) THEN
				l_dwcList.SetFilter ("active = 'Y'")
			ELSE
				l_dwcList.SetFilter ("active = 'Y' OR relationship_id = '" + l_cCurrentRelID + "'")
			END IF
			l_dwcList.Filter ()
			
		END IF

	END IF
END IF
end event

event pcd_setkey;call super::pcd_setkey;//**********************************************************************************************
//
//  Event:   pcd_setkey
//  Purpose: To set the key value for the new contact person record.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/06/00 C. Jackson  Add table_name to call to fw_getkeyvalue
//	 4/25/2002 K. Claver  Removed setting of instance variables to just have code that gets the
//								 key and sets the key
//
//**********************************************************************************************

PARENT.i_cContactPerson = PARENT.fw_GetKeyValue('contact_person')

THIS.SetItem( 1, 'contact_person_id', PARENT.i_cContactPerson )


end event

event pcd_setoptions;call super::pcd_setoptions;//*******************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: To set the datawindow characteristics
//		
//  Date
//  -------- ----------- --------------------------------------------------------------------
//  04/25/02 K. Claver   Added constants c_NoShowEmpty and c_NewModeOnEmpty.  Also removed
//							    resize code as this is a response window and can't be resized.
//  02/19/02 C. Jackson  Remove c_NoShowEmpty
//
//*******************************************************************************************


fu_SetOptions( SQLCA, & 
               dw_contact_list, & 
               c_ModifyOK + &
               c_ModifyOnSelect + &
               c_NewOK + &
					c_RefreshParent + &
					c_NewModeOnEmpty + &
					c_NoMenuButtonActivation + & 
					c_NoEnablePopup )               
					
					


end event

event pcd_validaterow;call super::pcd_validaterow;//************************************************************************************************
//
//  Event:   pcd_validaterow
//  Purpose: Please see PowerClass documentation for this event
//
//  4/25/2002 K. Claver  Added code to validate the fields before save.
//
//************************************************************************************************
Long l_nIndex, l_nRV, l_nPosAtSign, l_nPosPeriod1, l_nPosPeriod2, l_nDiff, l_nMessageRV
String l_cPrimary , l_cData, l_cContactID, l_cCurrContactID, l_cLastName, l_cFirstName
String l_cZip, l_cRelationshipID
Boolean l_bPrimaryFound

IF in_save THEN
	//Check Contact E-mail
	l_cData = THIS.Object.contact_email[ row_nbr ]
	IF NOT IsNull( l_cData ) AND Trim( l_cData ) <> "" THEN
		l_nPosAtSign = POS(l_cData,'@')
		l_nPosPeriod1 = POS(l_cData,'.')
		l_nPosPeriod2 = POS(l_cData,'.',l_nPosAtSign)
		l_nDiff = l_nPosPeriod2 - l_nPosAtSign
	
		IF l_nPosAtSign <= 1 OR l_nPosPeriod2 <= 0 OR l_nPosPeriod1 = 1 OR l_nDiff < 2 THEN
			messagebox(gs_AppName,'Please enter a valid e-mail address.')
			dw_contact_details.SetFocus()
			dw_contact_details.SetColumn('contact_email')
			Error.i_FWError = c_ValFailed
			RETURN
		END IF
	END IF
	
	//Contact Primary
	l_cData = THIS.Object.contact_primary_yn[ row_nbr ]
	l_cContactID = THIS.Object.contact_person_id[ row_nbr ]
	IF NOT IsNull( l_cData ) AND Trim( l_cData ) <> "" THEN
		IF l_cData = "Y" THEN
			// Check to see if there is another primary contact
			FOR l_nIndex = 1 TO dw_contact_list.RowCount( )
				//Skip this contact if already saved once
				IF NOT IsNull( l_cContactID ) AND Trim( l_cContactID ) <> "" THEN
					l_cCurrContactID = dw_contact_list.Object.contact_person_id[ l_nIndex ]
					IF l_cCurrContactID = l_cContactID THEN
						CONTINUE
					END IF
				END IF
				
				l_cPrimary = dw_contact_list.GetItemString(l_nIndex,'contact_primary_yn')
	
				IF l_cPrimary = 'Y' THEN
					l_bPrimaryFound = TRUE
					EXIT
				END IF			
			NEXT
			
			IF l_bPrimaryFound THEN
				l_nMessageRV = MessageBox( gs_AppName, "There cannot be more than one primary for a case.  Do you wish"+ &
													" to make this contact the primary", Question!, YesNo! )
													
				IF l_nMessageRV = 1 THEN
					FOR l_nIndex = 1 TO dw_contact_list.RowCount( )
						IF NOT IsNull( l_cContactID ) AND Trim( l_cContactID ) <> "" THEN
							l_cCurrContactID = dw_contact_list.Object.contact_person_id[ l_nIndex ]
							IF l_cCurrContactID = l_cContactID THEN
								CONTINUE
							END IF
						END IF
						
						l_cPrimary = dw_contact_list.GetItemString(l_nIndex,'contact_primary_yn')
	
						IF l_cPrimary = 'Y' THEN
							dw_contact_list.Object.contact_primary_yn[ l_nIndex ] = "N"
							
							l_nRV = dw_contact_list.fu_Save( dw_contact_list.c_SaveChanges )
							
							IF l_nRV < 0 THEN
								MessageBox( gs_AppName, "Error removing the current Primary", StopSign!, OK! )
								Error.i_FWError = c_ValFailed
							END IF
							
							EXIT
						END IF
					NEXT
				ELSE
					Error.i_FWError = c_ValFailed
				END IF
			END IF			
		ELSE
			l_bPrimaryFound = TRUE
			
			//Check for at least one primary if set this record to 'N'
			IF NOT IsNull( l_cContactID ) AND Trim( l_cContactID ) <> "" THEN
				IF dw_contact_list.Find( "contact_primary_yn = 'Y' AND contact_person_id <> '"+l_cContactID+"'", &
												 1, dw_contact_list.RowCount( ) ) = 0 THEN
					l_bPrimaryFound = FALSE
				END IF
			ELSEIF dw_contact_list.Find( "contact_primary_yn = 'Y'", 1, dw_contact_list.RowCount( ) ) = 0 THEN 	
				l_bPrimaryFound = FALSE
			END IF			
			
			IF NOT l_bPrimaryFound THEN
				messagebox(gs_AppName,'A Primary Contact is required.  Please create or select another one before removing this one.')
				Error.i_FWError = c_ValFailed
			END IF
		END IF
	END IF
	
	//Name and Address fields
	l_cLastName = THIS.Object.contact_last_name[ row_nbr ]
	l_cFirstName = THIS.Object.contact_first_name[ row_nbr ]
	l_cZip = THIS.Object.contact_zip[ row_nbr ]
	l_cRelationshipID = THIS.Object.relationship_id[ row_nbr ]
	
	IF IsNull( l_cLastName ) OR Trim( l_cLastName ) = "" THEN
		MessageBox( gs_AppName, "Value required for Contact Last Name", StopSign!, OK! )
		dw_contact_details.SetFocus()
		dw_contact_details.SetColumn('contact_last_name')
		Error.i_FWError = c_ValFailed
	ELSEIF IsNull( l_cFirstName ) OR Trim( l_cFirstName ) = "" THEN
		MessageBox( gs_AppName, "Value required for Contact First Name", StopSign!, OK! )
		dw_contact_details.SetFocus()
		dw_contact_details.SetColumn('contact_first_name')
		Error.i_FWError = c_ValFailed
	ELSEIF NOT IsNull( l_cZip ) AND Trim( l_cZip ) <> "" THEN
		IF ( LEN(TRIM(l_cZip)) <> 5 AND LEN(TRIM(l_cZip)) <> 9 ) THEN
			Messagebox( gs_AppName, 'Please enter either a 5 or 9 digit Zip Code.', StopSign!, OK! )
			dw_contact_details.SetFocus()
			dw_contact_details.SetColumn('contact_zip')
			Error.i_FWError = c_ValFailed
		END IF
	ELSEIF IsNull( l_cRelationshipID ) OR Trim( l_cRelationshipID ) = "" THEN	
		MessageBox( gs_AppName, "Please enter a Relationship for this Contact Person.", StopSign!, OK! )
		dw_contact_details.SetFocus()
		dw_contact_details.SetColumn('relationship_id')
		Error.i_FWError = c_ValFailed
	END IF
END IF
end event

event pcd_new;call super::pcd_new;/*****************************************************************************************
   Event:      pcd_new
   Purpose:    Processing related to the creation of a new record.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/27/03 M. Caruso    Created. Added code to filter the relationship list based on
								 active codes or the code that is currently set for the contact.
*****************************************************************************************/

STRING				l_cCurrentRelID
DATAWINDOWCHILD	l_dwcList

This.GetChild ('relationship_id', l_dwcList)
IF IsValid (l_dwcList) THEN
	
	l_dwcList.SetTransObject (SQLCA)
	l_cCurrentRelID = THIS.GetItemString (1, 'relationship_id')
	IF Len (l_cCurrentRelID) = 0 OR IsNull (l_cCurrentRelID) THEN
		l_dwcList.SetFilter ("active = 'Y'")
	ELSE
		l_dwcList.SetFilter ("active = 'Y' OR relationship_id = '" + l_cCurrentRelID + "'")
	END IF
	l_dwcList.Filter ()
	
END IF
end event

type dw_contact_list from u_dw_std within w_contact_person
integer x = 73
integer y = 1048
integer width = 3227
integer height = 604
integer taborder = 50
string dataobject = "d_contact_person_list"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_pickedrow;call super::pcd_pickedrow;//***********************************************************************************************
//
//		Event:	pcd_pickedrow
//		Purpose:	To get the contact person that was selected.
//
//***********************************************************************************************

IF UpperBound( selected_rows ) > 0 THEN
	IF selected_rows[ 1 ] > 0 THEN
		PARENT.i_cContactPerson = THIS.GetItemSTring( selected_rows[ 1 ], 'contact_person_id' )
	END IF
END IF	

end event

event pcd_retrieve;call super::pcd_retrieve;//***********************************************************************************************
//
//		Event:	pcd_retrieve
//		Purpose:	To retrieve and to select the first row into the detail.
//
//***********************************************************************************************

Long l_nRV

l_nRV = THIS.Retrieve( PARENT.i_cCurrentCase ) 

IF l_nRV < 0 THEN
	MessageBox( gs_AppName, "Error retrieving contact list for case", StopSign!, OK! )
	
	cb_save.Enabled = FALSE
	cb_new.Enabled = FALSE
	cb_delete.Enabled = FALSE
	
 	Error.i_FWError = c_Fatal
ELSEIF l_nRV > 0 THEN
	IF NOT w_create_maintain_case.i_bCaseLocked THEN
		cb_save.Enabled = TRUE
		cb_new.Enabled = TRUE
		cb_delete.Enabled = TRUE
	ELSE
		cb_save.Enabled = FALSE
		cb_new.Enabled = FALSE
		cb_delete.Enabled = FALSE
	END IF
	
	PARENT.i_cContactPerson = THIS.GetItemSTring( 1, 'contact_person_id' )
ELSE
	cb_delete.Enabled = FALSE
	
	IF NOT w_create_maintain_case.i_bCaseLocked THEN
		cb_new.Event Post clicked( )
	END IF
END IF


end event

event pcd_setoptions;call super::pcd_setoptions;//**********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: To set options for this datawindow
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  02/14/02 C. Jackson  Original Version
//  4/25/2002 K. Claver  Removed unnecessary constants
//
//**********************************************************************************************


THIS.fu_SetOptions( SQLCA, &
                    c_NullDW, &
						  c_DeleteOK + &
						  c_NewOK + &
						  c_SelectOnRowFocusChange + &
                    c_NoMenuButtonActivation + &
                    c_SortClickedOK + &
                    c_NoEnablePopup )



end event

event pcd_savebefore;call super::pcd_savebefore;//**********************************************************************************************
//
//  Event:   pcd_savebefore
//  Purpose: Please see PowerClass documentation for this event.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  5/20/2002 K. Claver  Added code to clear the primary contact id from the case_log
//								 table before deleting the current row if the current row is the
//								 primary contact in the case_log table.
//
//**********************************************************************************************
String l_cContactID, l_cPrimary

//Check if the row being deleted is the current primary in the case_log table.
//  If so, clear the contact_person_id field before delete this row and save
//  the new primary(if there is one).
IF THIS.DeletedCount( ) > 0 THEN
	l_cContactID = THIS.GetItemString( 1, "contact_person_id", Delete!, FALSE )
	IF NOT IsNull( l_cContactID ) AND Trim( l_cContactID ) <> "" THEN
		SELECT contact_person_id
		INTO :l_cPrimary
		FROM cusfocus.case_log
		WHERE case_number = :PARENT.i_cCurrentCase
		USING SQLCA;
		
		IF NOT IsNull( l_cPrimary ) AND Trim( l_cPrimary ) <> "" THEN
			IF l_cContactID = l_cPrimary THEN
				UPDATE cusfocus.case_log
				SET contact_person_id = null
				WHERE case_number = :PARENT.i_cCurrentCase
				USING SQLCA;
				
				IF SQLCA.SQLCode < 0 THEN
					MessageBox( gs_AppName, "Error clearing primary contact prior to deleting the contact.~r~nError returned:~r~n"+ &
									SQLCA.SQLErrText, StopSign!, OK! )
					Error.i_FWError = c_Fatal
				ELSE
					PARENT.i_cChangeFlag = "CHANGED"
				END IF
			END IF
		END IF
	END IF
END IF
end event

type ln_1 from line within w_contact_person
long linecolor = 8421504
integer linethickness = 4
integer beginx = 681
integer beginy = 1008
integer endx = 3337
integer endy = 1008
end type

type ln_2 from line within w_contact_person
long linecolor = 16777215
integer linethickness = 4
integer beginx = 681
integer beginy = 1012
integer endx = 3337
integer endy = 1012
end type

type ln_3 from line within w_contact_person
long linecolor = 8421504
integer linethickness = 4
integer beginx = 681
integer beginy = 232
integer endx = 3337
integer endy = 232
end type

type ln_4 from line within w_contact_person
long linecolor = 16777215
integer linethickness = 4
integer beginx = 681
integer beginy = 236
integer endx = 3337
integer endy = 236
end type

type ln_5 from line within w_contact_person
long linecolor = 8421504
integer linethickness = 4
integer beginx = -5
integer beginy = 184
integer endx = 3337
integer endy = 184
end type

type ln_6 from line within w_contact_person
long linecolor = 16777215
integer linethickness = 4
integer beginx = -5
integer beginy = 188
integer endx = 3337
integer endy = 188
end type

type st_5 from statictext within w_contact_person
integer y = 1744
integer width = 3397
integer height = 184
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 134217747
boolean focusrectangle = false
end type

type ln_7 from line within w_contact_person
long linecolor = 8421504
integer linethickness = 4
integer beginx = -5
integer beginy = 1736
integer endx = 3579
integer endy = 1736
end type

type ln_8 from line within w_contact_person
long linecolor = 16777215
integer linethickness = 4
integer beginx = -5
integer beginy = 1740
integer endx = 3579
integer endy = 1740
end type

