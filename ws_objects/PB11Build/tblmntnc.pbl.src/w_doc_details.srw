$PBExportHeader$w_doc_details.srw
$PBExportComments$Transfer Case Response window
forward
global type w_doc_details from w_response_std
end type
type dw_doc_details from u_dw_std within w_doc_details
end type
type cb_ok from commandbutton within w_doc_details
end type
end forward

global type w_doc_details from w_response_std
integer x = 366
integer y = 312
integer width = 3497
integer height = 1236
string title = "Document Details"
long backcolor = 79748288
dw_doc_details dw_doc_details
cb_ok cb_ok
end type
global w_doc_details w_doc_details

type variables
STRING	i_cDocID
STRING	i_cDocName
end variables

forward prototypes
public subroutine fw_createcasereminder ()
end prototypes

public subroutine fw_createcasereminder ();
end subroutine

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To initialize the user object 
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  08/07/00 C. Jackson  Original Version
//  08/15/00 C. Jackson  Add User Configurable Fields
//  12/03/01 C. Jackson  Correct handling of quotes so that Label with an apostrophe will 
//                       display correctly.
//
//**********************************************************************************************
STRING	l_cDocTypeID, l_cNewFieldLabel, l_cColName, l_cModLabelString, l_cModLabelVisible
STRING	l_cModDataVisible, l_cColFormat, l_cModEditMask, l_cColFormatID
LONG		l_nConfigCount, l_nIndex


	dw_doc_details.fu_SetOptions( SQLCA, & 
			dw_doc_details.c_NullDW, & 
			dw_doc_details.c_NoEnablePopup ) 
			
   // Get the Document ID from the Message Object
	i_cDocID = Message.StringParm

	// Get the Doc Type ID and Doc Name
   SELECT doc_name, doc_type_id
	  INTO :i_cDocName, :l_cDocTypeID
	  FROM cusfocus.documents 
	 WHERE doc_id = :i_cDocID 
	 USING SQLCA;
								
   Title = Title + ' - '+ i_cDocName
	
	// Check to see if there are User Configurable fields to display
	
	SELECT count(*) INTO :l_nConfigCount
	  FROM cusfocus.document_fields
	 WHERE doc_type_id = :l_cDocTypeID
	 USING SQLCA;
	 
	IF l_nConfigCount > 0 THEN
		
		FOR l_nIndex = 1 TO l_nConfigCount
		
			// Initialize field label
			SETNULL(l_cNewFieldLabel)
			
			// Get the field label from document_fields table
			SELECT  doc_field_label, doc_column_name, doc_format_id  INTO :l_cNewFieldLabel, :l_cColName, :l_cColFormatID
			  FROM cusfocus.document_fields
			 WHERE doc_type_id = :l_cDocTypeID
				AND doc_field_order = :l_nIndex
			 USING SQLCA;
			 
			SELECT edit_mask INTO :l_cColFormat
			  FROM cusfocus.display_formats
			 WHERE format_id = :l_cColFormatID
			 USING SQLCA;
			 
			 // Show fields as defined
			IF NOT ISNULL(l_cNewFieldLabel) THEN
				l_cModLabelString = 'doc_config_'+string(l_nIndex)+'_t.text = "'+l_cNewFieldLabel+':"'
				l_cModLabelVisible = "doc_config_"+string(l_nIndex)+"_t.Visible=1"
				l_cModDataVisible = "documents_doc_config_"+string(l_nIndex)+".Visible=1"
				l_cModEditMask = "documents_doc_config_"+string(l_nIndex)+".EditMask.Mask='"+l_cColFormat+"'"
				dw_doc_details.Modify(l_cModLabelString)
				dw_doc_details.Modify(l_cModLabelVisible)
				dw_doc_details.Modify(l_cModDataVisible)
				dw_doc_details.Modify(l_cModEditMask)
			END IF
			 
		NEXT
	
END IF


end event

on w_doc_details.create
int iCurrent
call super::create
this.dw_doc_details=create dw_doc_details
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_doc_details
this.Control[iCurrent+2]=this.cb_ok
end on

on w_doc_details.destroy
call super::destroy
destroy(this.dw_doc_details)
destroy(this.cb_ok)
end on

type dw_doc_details from u_dw_std within w_doc_details
integer x = 23
integer y = 32
integer width = 3438
integer height = 924
integer taborder = 20
string dataobject = "d_doc_details"
boolean border = false
boolean livescroll = false
end type

event pcd_retrieve;call super::pcd_retrieve;//*******************************************************************************************
//		
//  Event:   pcd_retrieve
//  Purpose: To retrieve the document details
//  
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------
//  08/07/00 C. Jackson  Original Version
//
//*******************************************************************************************

LONG		l_nReturn
STRING	l_cDocID

l_nReturn = Retrieve(i_cDocID)

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF
end event

type cb_ok from commandbutton within w_doc_details
integer x = 3118
integer y = 996
integer width = 320
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
boolean default = true
end type

event clicked;//**********************************************************************************************
//
//  Event:   Close
//  Purpose: Close the window
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  08/07/00 C. Jackson  Original Version
//
//**********************************************************************************************

	Close(Parent)


end event

