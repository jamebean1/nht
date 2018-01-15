$PBExportHeader$w_category_popup.srw
forward
global type w_category_popup from w_response_std
end type
type cb_ok from commandbutton within w_category_popup
end type
type tv_category from treeview within w_category_popup
end type
end forward

global type w_category_popup from w_response_std
integer width = 1367
integer height = 1216
cb_ok cb_ok
tv_category tv_category
end type
global w_category_popup w_category_popup

type variables
datastore	ids_category
string is_selected_category 
string	is_casetype

datastore 	ids_unfiltered
end variables

forward prototypes
public function string of_retrieve_treeview (string as_casetype)
public function string of_determine_category (string as_categoryid)
end prototypes

public function string of_retrieve_treeview (string as_casetype);datastore	lds_category
treeviewitem tvi1, tvi2
long ll_lev1, ll_lev2, ll_rowcount, ll_row


//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore that will hold all the categories and can be filtered
//-----------------------------------------------------------------------------------------------------------------------------------
ids_category = Create datastore
ids_category.DataObject = 'd_categories_treeview'
ids_category.SetTransObject(SQLCA)
ids_category.Retrieve(as_casetype)
ids_category.SetSort('category_name ASC')
ids_category.Sort()

ids_unfiltered = Create Datastore
ids_unfiltered.DataObject = 'd_categories_treeview'
ids_unfiltered.SetTransObject(SQLCA)
ids_unfiltered.Retrieve(as_casetype)


ids_category.SetFilter('prnt_category_id = ""')
ids_category.Filter()



//-----------------------------------------------------------------------------------------------------------------------------------
// Populate the TreeView with data retrieved from the datastore 
//-----------------------------------------------------------------------------------------------------------------------------------
tvi1.Children = TRUE
FOR ll_row = 1 to ids_category.RowCount()
      tvi1.Label = ids_category.GetItemString(ll_row, 'category_name')
		tvi1.Data  = ids_category.GetItemString(ll_row, 'category_id')
		tvi1.PictureIndex = 1
		tv_category.InsertItemLast(0, tvi1)
NEXT


//-----------------------------------------------------------------------------------------------------------------------------------
// Add a "None" entry into the treeview, so they can pick no category if they want
//-----------------------------------------------------------------------------------------------------------------------------------
tvi1.Label = 'None'
tvi1.Data  = 'None'
tvi1.PictureIndex = 1
tvi1.Children = FALSE
tv_category.InsertItemLast(0, tvi1)


Return ''
end function

public function string of_determine_category (string as_categoryid);String ls_category_list

If Len(ls_category_list) < 2 Then ls_category_list = ls_category_list + '0'

ls_category_list = 'category_lineage like "' + as_categoryid + '%"'

Return ls_category_list
end function

on w_category_popup.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.tv_category=create tv_category
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.tv_category
end on

on w_category_popup.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.tv_category)
end on

event open;call super::open;

of_retrieve_treeview(Message.StringParm)
end event

event close;call super::close;Destroy ids_category
Destroy ids_unfiltered
end event

type cb_ok from commandbutton within w_category_popup
integer x = 891
integer y = 968
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;string ls_handle

ls_handle = is_selected_category

CloseWithReturn(parent, ls_handle)
end event

type tv_category from treeview within w_category_popup
event ue_retrieve ( string as_casetype )
integer x = 37
integer y = 36
integer width = 1253
integer height = 860
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
boolean hideselection = false
boolean trackselect = true
string picturename[] = {"Custom039!","Custom050!"}
integer picturewidth = 16
integer pictureheight = 16
long picturemaskcolor = 16777215
string statepicturename[] = {"Custom039!"}
integer statepicturewidth = 16
integer statepictureheight = 16
long statepicturemaskcolor = 16777215
end type

event itempopulate;//----------------------------------------------------------------------------------------------------------------------------------
//	Overrides:  No
//	Arguments:	
//	Overview:   This item gets called when the treeview begins to populate.
//	Created by: Joel White
//	History:    2/22/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
TreeViewItem tvi1, tvi2
long ll_row, ll_rowcount, ll_return_handle, ll_i, ll_total_rowcount, lhdl_root
string ls_test, ls_lineage, ls_lineage_part
string ls_find_string


//-----------------------------------------------------------------------------------------------------------------------------------
// Use the handle to get the TreeView Item
//-----------------------------------------------------------------------------------------------------------------------------------
lhdl_root = tv_category.FindItem(ParentTreeItem!, handle)
This.GetItem(handle, tvi1)

//-----------------------------------------------------------------------------------------------------------------------------------
// Filter the parent category based on the ID in the original treeview item
//-----------------------------------------------------------------------------------------------------------------------------------
ids_category.SetFilter('prnt_category_id = "' + string(tvi1.Data) + '"')
ids_category.Filter()

//-----------------------------------------------------------------------------------------------------------------------------------
// Grab the rowcounts of the two datastores for looping boundaries
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = ids_category.RowCount()
ll_total_rowcount = ids_unfiltered.RowCount()


//-----------------------------------------------------------------------------------------------------------------------------------
// Use information retrieved from the database to populate the expanded item
//-----------------------------------------------------------------------------------------------------------------------------------
FOR ll_row = 1 to ll_rowcount
      ll_return_handle = This.InsertItemLast(handle, ids_category.GetItemString(ll_row, 'category_name'), 2)
		tvi2.Data = ids_category.GetItemString(ll_row, 'category_id')
		tvi2.Label = ids_category.GetItemString(ll_row, 'category_name')
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Find the child category in the datastore
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_i = ids_unfiltered.Find('category_id = "' + tvi2.Data +'"' , 1, ll_total_rowcount)
		If ll_i > 0 Then 
			ls_lineage = ids_unfiltered.GetItemString(ll_i, 'category_lineage')
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Filter using the category_lineage we got from the find above
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_find_string = '(category_lineage <> "' + ls_lineage + '"' + ' and category_lineage like "' + ls_lineage + '%")'

		ids_unfiltered.SetFilter(ls_find_string)
		ids_unfiltered.Filter()
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Check the rowcount of the unfilitered datastore, if it has rows, then a child item exists
		//-----------------------------------------------------------------------------------------------------------------------------------
		If	ids_unfiltered.RowCount() > 0 Then 
			tvi2.Children = TRUE
			tvi2.PictureIndex = 1
		Else
			tvi2.Children = FALSE
			tvi2.PictureIndex = 1
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the Treeview Item into the treeview with the above properties
		//-----------------------------------------------------------------------------------------------------------------------------------
		tv_category.SetItem(ll_return_handle, tvi2)
		
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Clear the filters before continuing on the loop.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ids_unfiltered.SetFilter('')
		ids_unfiltered.Filter()
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear the filters on the category datastore.
//-----------------------------------------------------------------------------------------------------------------------------------
ids_category.SetFilter('')
ids_category.Filter()
end event

event selectionchanged;treeviewitem tvi_1

tv_category.GetItem(newhandle, tvi_1)
is_selected_category = string(tvi_1.Data)
end event

event itemexpanded;Treeviewitem tvi1

GetItem(handle, tvi1)
tvi1.PictureIndex = 2
SetItem(handle, tvi1)
end event

event itemcollapsed;Treeviewitem tvi1

GetItem(handle, tvi1)
tvi1.PictureIndex = 1
SetItem(handle, tvi1)
end event

event clicked;Treeviewitem tvi1

GetItem(handle, tvi1)
tvi1.PictureIndex = 1
SetItem(handle, tvi1)
end event

