$PBExportHeader$u_bookmark_maintenance.sru
$PBExportComments$Correspondence bookmark maintenance module.
forward
global type u_bookmark_maintenance from u_container_std
end type
type cb_print_doc from commandbutton within u_bookmark_maintenance
end type
type dw_bookmark_details from u_dw_std within u_bookmark_maintenance
end type
type st_bookmark_list from statictext within u_bookmark_maintenance
end type
type tv_bookmarks from treeview within u_bookmark_maintenance
end type
type gb_bookmark_details from groupbox within u_bookmark_maintenance
end type
end forward

global type u_bookmark_maintenance from u_container_std
integer width = 3579
integer height = 1592
boolean border = false
cb_print_doc cb_print_doc
dw_bookmark_details dw_bookmark_details
st_bookmark_list st_bookmark_list
tv_bookmarks tv_bookmarks
gb_bookmark_details gb_bookmark_details
end type
global u_bookmark_maintenance u_bookmark_maintenance

type variables
INTEGER	i_nBookmarkID
end variables

on u_bookmark_maintenance.create
int iCurrent
call super::create
this.cb_print_doc=create cb_print_doc
this.dw_bookmark_details=create dw_bookmark_details
this.st_bookmark_list=create st_bookmark_list
this.tv_bookmarks=create tv_bookmarks
this.gb_bookmark_details=create gb_bookmark_details
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print_doc
this.Control[iCurrent+2]=this.dw_bookmark_details
this.Control[iCurrent+3]=this.st_bookmark_list
this.Control[iCurrent+4]=this.tv_bookmarks
this.Control[iCurrent+5]=this.gb_bookmark_details
end on

on u_bookmark_maintenance.destroy
call super::destroy
destroy(this.cb_print_doc)
destroy(this.dw_bookmark_details)
destroy(this.st_bookmark_list)
destroy(this.tv_bookmarks)
destroy(this.gb_bookmark_details)
end on

type cb_print_doc from commandbutton within u_bookmark_maintenance
integer x = 2139
integer y = 1144
integer width = 910
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print Correspondence Reference"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Print the Correspondence Reference report.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/04/01 M. Caruso    Created.
*****************************************************************************************/

DATASTORE	l_dsReport

// Create the datastore
l_dsReport = CREATE DATASTORE
l_dsReport.DataObject = 'd_correspondence_reference'
l_dsReport.SetTransObject (SQLCA)

// retrieve the report information and print if rows are retrieved
IF l_dsReport.retrieve () > 0 THEN l_dsReport.Print (FALSE)
end event

type dw_bookmark_details from u_dw_std within u_bookmark_maintenance
integer x = 1829
integer y = 196
integer width = 1531
integer height = 568
integer taborder = 20
string dataobject = "d_tm_bookmark_details"
boolean border = false
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Initialize the datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/05/01 M. Caruso    Created.
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_ModifyOK + c_ModifyOnOpen + c_NoRetrieveOnOpen)
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve record(s) into this datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/06/01 M. Caruso    Created.
*****************************************************************************************/

CHOOSE CASE Retrieve (i_nBookmarkID)
	CASE -1
		MessageBox (gs_appname, 'An error occurred while trying to retrieve the bookmark information.')
		
	CASE 0
		// to be coded if needed.
		
	CASE ELSE
		SetColumn ('bookmark_name')
		
END CHOOSE
end event

type st_bookmark_list from statictext within u_bookmark_maintenance
integer x = 142
integer y = 36
integer width = 654
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bookmark List:"
boolean focusrectangle = false
end type

type tv_bookmarks from treeview within u_bookmark_maintenance
integer x = 142
integer y = 112
integer width = 1307
integer height = 1432
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean hideselection = false
string picturename[] = {"Bookclsd.bmp","Bookopen.bmp","Bookmark.bmp"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    Initialize the tree view

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/06/01 M. Caruso    Created.
*****************************************************************************************/

CONSTANT	STRING	l_cParentSQL = 'SELECT DISTINCT (source_id) FROM cusfocus.lookup_info'
CONSTANT STRING	l_cChildSQL = 'SELECT * FROM cusfocus.lookup_info'

LONG				l_nMaxRows1, l_nMaxRows2, l_nCounter, l_nParentIndex, l_nItemHandle
STRING			l_cDWParentSyntax, l_cDWChildSyntax, error_syntaxfromSQL, error_create
STRING			l_cLabel, l_cSourceID
TREEVIEWITEM	l_tviEntry
DATASTORE		l_dsSources, l_dsBookmarks

DATASTORE		lds_appealevents
DATASTORE		lds_appealprops

SetPointer (Hourglass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore, set the data object and the transaction 
//-----------------------------------------------------------------------------------------------------------------------------------
long	ll_rowcount, ll_newcounter, ll_appealevent_handle, ll_props_rowcount
long ll_appealdetail_handle[]

lds_appealevents = Create datastore
lds_appealevents.DataObject = 'd_tm_appeal_event'
lds_appealevents.SetTransObject(SQLCA)

ll_rowcount = lds_appealevents.Retrieve()

lds_appealprops = Create datastore
lds_appealprops.DataObject = 'd_bookmark_appeal_properties'
lds_appealprops.SetTransObject(SQLCA)

// build top level of the tree view
l_dsSources = CREATE DATASTORE
l_cDWParentSyntax = SQLCA.SyntaxFromSQL(l_cParentSQL, '', error_syntaxfromSQL)

IF Len(error_syntaxfromSQL) > 0 THEN
		// Display errors
		MessageBox (gs_appname, error_syntaxfromSQL)
ELSE
		// Generate parent DataStore
		l_dsSources.Create (l_cDWParentSyntax, error_create)
		IF Len(error_create) > 0 THEN
			MessageBox (gs_appname, error_create)
		ELSE
			l_dsSources.SetTransObject(SQLCA)
			l_dsSources.Retrieve()
		END IF
END IF

IF IsValid (l_dsSources) THEN
	
	l_nMaxRows1 = l_dsSources.RowCount ()
	FOR l_nCounter = 1 TO l_nMaxRows1
		
		l_tviEntry.Label = l_dsSources.GetItemString (l_nCounter, 'source_id')
		l_tviEntry.Data = l_tviEntry.Label
		l_tviEntry.Level = 1
		l_tviEntry.ItemHandle = l_nCounter
		l_tviEntry.PictureIndex = 1
		l_tviEntry.SelectedPictureIndex = 1
		l_tviEntry.Children = FALSE
		
		InsertItemLast (0, l_tviEntry)

	NEXT
	
	//-----------------------------------------------------------------------------------------------------------------------------------

	// Insert a parent record for the Appeal Events. We will then seed in the dynamic appeal 
	//	events and then the properties off each event
	//-----------------------------------------------------------------------------------------------------------------------------------

	l_tviEntry.Label = 'Appeal Events'
	l_tviEntry.Data = l_tviEntry.Label
	l_tviEntry.Level = 1
	l_tviEntry.ItemHandle = l_nCounter + 1
	l_tviEntry.PictureIndex = 1
	l_tviEntry.SelectedPictureIndex = 1
	l_tviEntry.Children = FALSE
		
	ll_appealevent_handle = InsertItemLast (0, l_tviEntry)

	l_nMaxRows1 = l_nMaxRows1 + 1
	
	// populate the child level
	IF l_nMaxRows1 > 0 THEN
		l_dsBookmarks = CREATE DATASTORE
		l_cDWChildSyntax = SQLCA.SyntaxFromSQL(l_cChildSQL, '', error_syntaxfromSQL)
		
		IF Len(error_syntaxfromSQL) > 0 THEN
				// Display errors
				MessageBox (gs_appname, error_syntaxfromSQL)
		ELSE
				// Generate parent DataStore
				l_dsBookmarks.Create (l_cDWChildSyntax, error_create)
				IF Len(error_create) > 0 THEN
					MessageBox (gs_appname, error_create)
				ELSE	
					l_dsBookmarks.SetTransObject(SQLCA)
					l_dsBookmarks.Retrieve()
				END IF
		END IF
		
		IF IsValid (l_dsBookmarks) THEN
			
			l_nMaxRows2 = l_dsBookmarks.RowCount ()
			FOR l_nCounter = 1 TO l_nMaxRows2
				
				l_cLabel = l_dsBookmarks.GetItemString (l_nCounter, 'common_name')
				IF l_cLabel = '' THEN
					l_tviEntry.Label = 'Undefined'
				ELSE
					l_tviEntry.Label = l_cLabel
				END IF
				l_tviEntry.Data = l_dsBookmarks.GetItemNumber (l_nCounter, 'lookup_id')
				l_tviEntry.Level = 2
				l_tviEntry.ItemHandle = l_nCounter + l_nMaxRows1
				l_tviEntry.PictureIndex = 3
				l_tviEntry.SelectedPictureIndex = 3
				l_tviEntry.Children = FALSE
				
				l_cSourceID = l_dsBookmarks.GetItemString (l_nCounter, 'source_id')
				l_nParentIndex = l_dsSources.Find ('source_id = "' + l_cSourceID + '"', 1, l_dsSources.RowCount ())
				
				InsertItemLast (l_nParentIndex, l_tviEntry)
		
			NEXT
			
			ll_newcounter = l_nMaxRows2 + l_nMaxRows1
			
			//-----------------------------------------------------------------------------------------------------------------------------------

			// Populate the Appeal Detail fields from the datastore
			//-----------------------------------------------------------------------------------------------------------------------------------

			FOR l_nCounter = 1 TO ll_rowcount
				
				l_cLabel = lds_appealevents.GetItemString (l_nCounter, 'eventname')
				IF l_cLabel = '' THEN
					l_tviEntry.Label = 'Undefined'
				ELSE
					l_tviEntry.Label = l_cLabel
				END IF
				l_tviEntry.Data = lds_appealevents.GetItemNumber (l_nCounter, 'appealeventid')
				l_tviEntry.Level = 2
				l_tviEntry.ItemHandle =  l_nCounter + ll_newcounter
				l_tviEntry.PictureIndex = 3
				l_tviEntry.SelectedPictureIndex = 3
				l_tviEntry.Children = FALSE
				
				l_nParentIndex = ll_appealevent_handle
				
				ll_appealdetail_handle[l_nCounter] = InsertItemLast (l_nParentIndex, l_tviEntry)
		
			NEXT
			
			ll_newcounter = ll_newcounter + ll_rowcount
			
			//-----------------------------------------------------------------------------------------------------------------------------------

			// Populate the Appeal Detail Properties fields from the datastore
			//-----------------------------------------------------------------------------------------------------------------------------------

			FOR l_nCounter = 1 TO UpperBound(ll_appealdetail_handle)
				
				treeviewitem ltvi_appealdetail
				long ll_handle, i, ll_data
				
				ll_handle = ll_appealdetail_handle[l_nCounter]
				this.GetItem(ll_handle, ltvi_appealdetail)
				
				ll_data = long(ltvi_appealdetail.Data)
				ll_props_rowcount = lds_appealprops.Retrieve(ll_data)
				
				For i = 1 to ll_props_rowcount 
					l_cLabel = lds_appealprops.GetItemString (i, 'field_label')
					IF l_cLabel = '' THEN
						l_tviEntry.Label = 'Undefined'
					ELSE
						l_tviEntry.Label = l_cLabel
					END IF
					l_tviEntry.Data = lds_appealprops.GetItemString (i, 'definition_id')
					l_tviEntry.Level = 3
					l_tviEntry.ItemHandle =  l_nCounter + ll_newcounter
					l_tviEntry.PictureIndex = 3
					l_tviEntry.SelectedPictureIndex = 3
					l_tviEntry.Children = FALSE
					
					l_nParentIndex = ll_handle
					
					ll_appealdetail_handle[l_nCounter] = InsertItemLast (l_nParentIndex, l_tviEntry)
				Next
		
			NEXT
			
			
			l_nItemHandle = FindItem (FirstVisibleTreeItem!, 0)
			post SelectItem (l_nItemHandle)
		
		END IF
		
	END IF
	
END IF

Destroy lds_appealevents
Destroy lds_appealprops
end event

event selectionchanged;/*****************************************************************************************
   Event:      selectionchanged
   Purpose:    Perform this action after the current selection has changed

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/06/01 M. Caruso    Created.
*****************************************************************************************/

TREEVIEWITEM	l_tviEntry, ltvi_parent
string			ls_label, ls_parent_label,ls_bookmark_name, ls_find
long				ll_new_row, ll_parent_handle, ll_return, ll_top_parent, ll_rowcount, ll_find_row
Datastore		lds_appealevents, lds_appealprops

lds_appealevents = Create datastore
lds_appealevents.DataObject = 'd_tm_appeal_event'
lds_appealevents.SetTransObject(SQLCA)

lds_appealprops = Create datastore
lds_appealprops.DataObject = 'd_tm_appeal_prop_field_defs'
lds_appealprops.SetTransObject(SQLCA)

lds_appealevents.Retrieve()
lds_appealprops.Retrieve()

// set the ID of the bookmark to display in the Detail datawindow
IF GetItem (newhandle, l_tviEntry) = 1 THEN
	
	//-----------------------------------------------------------------------------------------------------------------------------------

	// Check the treeview level. 
   //
	// Case 1 - The "standard" bookmarks. 
	//	Case 2 - You have to check to see if the parent level is 'Appeal Events', if so then build the dynamic appeal events section, 
	//				as they don't exist in the lookup_info table as other entries do.
	// Case 3 - These are guaranteed to be the appeal event properties as now other bookmarks have 3 levels
	//-----------------------------------------------------------------------------------------------------------------------------------

	CHOOSE CASE l_tviEntry.Level
		CASE 0
			i_nBookmarkID = 0
			
		Case 1
			i_nBookmarkID = LONG (l_tviEntry.Data)
			ls_label = String(l_tviEntry.Label)
			
			dw_bookmark_details.fu_retrieve (dw_bookmark_details.c_PromptChanges, dw_bookmark_details.c_NoReselectRows)
			
		CASE 2
			ll_parent_handle = FindItem(ParentTreeItem!, newhandle)
			
			this.GetItem(ll_parent_handle, ltvi_parent)
			
			i_nBookmarkID = LONG (l_tviEntry.Data)
			
			ls_parent_label = STring(ltvi_parent.label)
			ls_label = String(l_tviEntry.Label)
			
			If ls_parent_label <> 'Appeal Events' Then 
				dw_bookmark_details.fu_retrieve (dw_bookmark_details.c_PromptChanges, dw_bookmark_details.c_NoReselectRows)
			Else
				dw_bookmark_details.fu_retrieve (dw_bookmark_details.c_ignoreChanges, dw_bookmark_details.c_NoReselectRows)
				ll_new_row = dw_bookmark_details.InsertRow(0)
				ll_return = dw_bookmark_details.SetItem(ll_new_row, 'source_id', 'Appeal Event')
				ll_return = dw_bookmark_details.SetItem(ll_new_row, 'common_name', ls_label)
				
				ls_find = 'appealeventid=' + string(l_tviEntry.Data) 
				ll_find_row = lds_appealevents.Find(ls_find,1, lds_appealevents.RowCount())
				If ll_find_row > 0 Then
					ls_bookmark_name = lds_appealevents.GetItemString(ll_find_row, 'bookmark_name')
					If ls_bookmark_name = '' or IsNull(ls_bookmark_name) Then ls_bookmark_name = 'Not Defined'
				Else
					ls_bookmark_name = 'Not Defined'
				End If
				
				ll_return = dw_bookmark_details.SetItem(ll_new_row, 'bookmark_name', ls_bookmark_name)
				ll_return = dw_bookmark_details.SetItem(ll_new_row, 'locked', 'Y')
				dw_bookmark_details.ScrollToRow(ll_new_row)
				dw_bookmark_details.SetItemStatus(ll_new_row, 0, Primary!, NotModified!)
			End If
			
		Case 3
			//-----------------------------------------------------------------------------------------------------------------------------------

			// Get the item's parent and top level parent's handles
			//-----------------------------------------------------------------------------------------------------------------------------------

			ll_parent_handle = FindItem(ParentTreeItem!, newhandle)
			ll_top_parent = FindItem(ParentTreeItem!, ll_parent_handle)
			
			//-----------------------------------------------------------------------------------------------------------------------------------

			// Get the parent treeview item
			//-----------------------------------------------------------------------------------------------------------------------------------

			this.GetItem(ll_top_parent, ltvi_parent)
			
			i_nBookmarkID = LONG (l_tviEntry.Data)
			
			//-----------------------------------------------------------------------------------------------------------------------------------

			// Get the label and the parent's label
			//-----------------------------------------------------------------------------------------------------------------------------------

			ls_parent_label = STring(ltvi_parent.label)
			ls_label = String(l_tviEntry.Label)
			
			If ls_parent_label <> 'Appeal Events' Then 
				dw_bookmark_details.fu_retrieve (dw_bookmark_details.c_PromptChanges, dw_bookmark_details.c_NoReselectRows)
			Else
				dw_bookmark_details.fu_retrieve (dw_bookmark_details.c_ignoreChanges, dw_bookmark_details.c_NoReselectRows)
				ll_new_row = dw_bookmark_details.InsertRow(0)
				ll_return = dw_bookmark_details.SetItem(ll_new_row, 'source_id', 'Appeal Event')
				ll_return = dw_bookmark_details.SetItem(ll_new_row, 'common_name', ls_label)
				
				ls_find = 'definition_id="' + string(l_tviEntry.Data) + '"'
				ll_find_row = lds_appealprops.Find(ls_find ,1, lds_appealprops.RowCount())
				If ll_find_row > 0 Then
					ls_bookmark_name = lds_appealprops.GetItemString(ll_find_row, 'bookmark_name')
					If ls_bookmark_name = '' or IsNull(ls_bookmark_name) Then ls_bookmark_name = 'Not Defined'
				Else
					ls_bookmark_name = 'Not Defined'
				End If
				
				ll_return = dw_bookmark_details.SetItem(ll_new_row, 'bookmark_name', ls_bookmark_name)
				ll_return = dw_bookmark_details.SetItem(ll_new_row, 'locked', 'Y')
				dw_bookmark_details.ScrollToRow(ll_new_row)
				dw_bookmark_details.SetItemStatus(ll_new_row, 0, Primary!, NotModified!)
			End If
	END CHOOSE
	
ELSE
	MessageBox (gs_appname, 'Unable to determine the ID of the selected bookmark.')
	i_nBookmarkID = 0
END IF

Destroy lds_appealevents
Destroy lds_appealprops
end event

type gb_bookmark_details from groupbox within u_bookmark_maintenance
integer x = 1746
integer y = 44
integer width = 1691
integer height = 808
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bookmark Details"
end type

