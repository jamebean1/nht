$PBExportHeader$n_treeview_manager.sru
$PBExportComments$This is the treeview manager.  It will retrieve data from the database and create the treeview items for you.  It works with u_treeview.
forward
global type n_treeview_manager from nonvisualobject
end type
end forward

global type n_treeview_manager from nonvisualobject
end type
global n_treeview_manager n_treeview_manager

type variables
Protected:
  Treeview itv_control
  String is_dw_SQL, is_expanding_sql
  Datastore ids_folder_list
  Boolean ib_n_level = False, ib_retrieve_on_expand = False, ib_expanding_sql_is_dataobject
  integer ii_root_level_id = 0
  String is_folder_colname = 'folderid'
  String is_itemid_colname = 'itemid'
  String is_itemname_colname = 'itemname'
  String is_itemtype_colname = 'itemtype'
  String is_itemhandle_colname = 'itemhandle'
  String is_icon_colname = 'itemicon'
  String is_foldertype_colname = 'foldertype'
  String is_picture[]
  Long il_currentitem = 1, il_expanded_folders[]
  //Long il_folder_handle[64000]

end variables

forward prototypes
public subroutine of_set_dw_sql (string as_dw_sql)
protected subroutine of_create_datastore (string as_dw_sql, boolean ib_datastore)
public subroutine of_init (treeview atv_control, string as_dw_sql, boolean ab_dataobject)
protected subroutine of_set_treeview (treeview atv_treeview)
public subroutine of_expand_all ()
public subroutine of_refresh ()
public function long of_getfirstitem ()
public function long of_getnextitem ()
public subroutine of_set_expanding_sql (string as_expanding_sql, boolean ab_is_dataobject)
protected function long of_get_picture_index (string as_picture)
public subroutine of_delete_treeviewitem (long handle)
public function datastore of_get_datastore ()
public function any of_get_column_value (string as_colname, long al_itemhandle)
protected subroutine of_retrieve_datastore ()
public function integer of_reset_expanded_folder (long al_folderhandle)
public function integer of_reset_folder_data (long al_folderhandle)
public function boolean of_folder_has_been_expanded (long al_folderid)
public subroutine of_set_column_value (long al_itemhandle, string as_colname, any aa_value)
public subroutine of_build_tree (integer ai_prntid)
protected subroutine of_create_tvi ()
public subroutine of_expand_folder (long al_folderhandle)
end prototypes

public subroutine of_set_dw_sql (string as_dw_sql);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_dw_sql()
// Overview:    This will hold the sql in an instance variable
// Created by:  Blake Doerr
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_dw_sql = as_dw_sql

end subroutine

protected subroutine of_create_datastore (string as_dw_sql, boolean ib_datastore);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_create_datastore()
// Arguments:   as_dw_sql - Represents either the datawindow object, or the syntax to create the datawindow
//					 ib_datastore - Specifies whether as_dw_sql is a datawindow object or sql syntax.
//					 					 True - Datawindow object
//										 False - sql syntax
// Overview:    Creates the datastore ids_folder_list which is used to populate the treeview control.
// Created by:  Pat Newgent
// History:     12/02/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String s_err, s_dw_syntax

//-----------------------------------------------------
// Create an instance of ids_folder_list
//-----------------------------------------------------
ids_folder_list = Create Datastore

//-----------------------------------------------------
// If the as_dw_sql is a dataobject then set
// ids_folder_list dataobject = to as_dw_sql.
// Else, create ids_folder_list from as_dw_sql
//-----------------------------------------------------
if ib_datastore then
	ids_folder_list.Dataobject = as_dw_sql
Else
	//-----------------------------------------------------
	// Create the datawindow syntax using as_dw_sql
	//-----------------------------------------------------
	s_dw_syntax = SQLCA.SyntaxFromSQL(as_dw_SQL, '', s_err)

	if s_dw_syntax <> '' then
		//-----------------------------------------------------
		// Create is_folder_list using the datawindow syntax
		// determined above.
		//-----------------------------------------------------
		if ids_folder_list.Create( s_dw_syntax, s_err) = 1 then
			//-----------------------------------------------------
			// If the create statement was successful, set the
			// transaction object, and retrieve the datastore.
			//-----------------------------------------------------
			ids_folder_list.SetTransObject(SQLCA)
			This.of_retrieve_datastore()
//			ids_folder_list.Retrieve()
		End if
	End if 
End if

Return


end subroutine

public subroutine of_init (treeview atv_control, string as_dw_sql, boolean ab_dataobject);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_init
// Arguments:   atv_control - the treeview that this nvo is attached to.
//					 as_dw_sql - either the dataobject or sql syntax to use.
//					 ab_dataobject - True indicates that as_dw_sql is a dataobject
//										  False indicates that as_dw_sql is SQL syntax
// Overview:    Attaches this nvo to the Treeview control and creates the datastore
//					 used to build the treeview control.
//
// Created by:  Pat Newgent
// History:     12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Attach this nvo to the treeview control
//-----------------------------------------------------
this.of_set_treeview(atv_control)

//-----------------------------------------------------
// Create the datastore object used for building the
// treeview control.
//-----------------------------------------------------
This.of_create_datastore(as_dw_SQL, ab_dataobject)

is_picture[] = itv_control.PictureName
end subroutine

protected subroutine of_set_treeview (treeview atv_treeview);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_treeview()
// Arguments:   atv_treeview - the treeview control to which this nvo is attached.
// Overview:    Stores the reference to the treeview control to which this nvo is being attached.
// Created by:  Pat Newgent
// History:     12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

itv_control = atv_treeview
Return
end subroutine

public subroutine of_expand_all ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_expand()
// Arguments:   none
// Overview:    Expands the treeview for the passed in folderid
// Created by:  Pat Newgent
// History:     12/19/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long i, ll_handle

//-----------------------------------------------------
// Filter down to the root levels
//-----------------------------------------------------
ids_folder_list.SetFilter(is_folder_colname + ' = ' + is_itemid_colname)
ids_folder_list.Filter()

//-----------------------------------------------------
// Loop though the temporary datastore and expand
// the treeview control for each folder
//-----------------------------------------------------
For i = 1 to ids_folder_list.Rowcount()
	ll_handle = ids_folder_list.GetItemNumber(i, is_itemhandle_colname)
	itv_control.ExpandAll(ll_handle)
Next

//-----------------------------------------------------
// Unfilter the datastore
//-----------------------------------------------------
ids_folder_list.SetFilter('')
ids_folder_list.Filter()


/*
string s_filter, s_dw_syntax, s_err
Long i, l_handle
datastore ds_parent_tree

//-----------------------------------------------------
// Create a temporary datastore based on ids_folder_list
// to hold root level folders
//-----------------------------------------------------
ds_parent_tree = Create DataStore

s_dw_syntax = ids_folder_list.Object.DataWindow.Syntax
if s_dw_syntax <> '' then
	ds_parent_tree.Create( s_dw_syntax, s_err)
End if
ids_folder_list.RowsCopy ( 1, ids_folder_list.Rowcount(), Primary!, ds_parent_tree, 1, Primary!)

//-----------------------------------------------------
// Filter the temporary datastore to hold only those
// rows that have a folder id = to the root level id
// (ii_root_level_id).
//-----------------------------------------------------
s_filter = is_folder_colname + ' = ' + is_itemid_colname
ds_parent_tree.SetFilter (s_filter)
ds_parent_tree.Filter()

//-----------------------------------------------------
// Loop though the temporary datastore and expand
// the treeview control for each folder
//-----------------------------------------------------
For i = 1 to ds_parent_tree.Rowcount()
	l_handle = ds_parent_tree.GetItemNumber(i, is_itemhandle_colname)
	itv_control.ExpandAll(l_handle)
Next

//-----------------------------------------------------
// Destroy the temporary datastore
//-----------------------------------------------------
Destroy ds_parent_tree
*/
end subroutine

public subroutine of_refresh ();//---------------------------------------------------------------------------------------------------------------------------------
// Function:  of_refresh()
// Overview:    This will refresh the treeview
// Created by:  Blake Doerr
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long i, l_handle, ll_empty[]
//Delete every item in the tree
For i = 1 to ids_folder_list.Rowcount()
	l_handle = ids_folder_list.GetItemNumber(i,"ItemHandle")
	itv_control.DeleteItem(l_handle)
Next

//This will retrieve the datastore again and build the tree
This.of_retrieve_datastore()
This.of_build_tree(ii_root_level_id)

//-----------------------------------------------------------------------------------------------------------------------------------
// Empty out the list of folders that have been expanded
//-----------------------------------------------------------------------------------------------------------------------------------
il_expanded_folders[] = ll_empty[]

Return
end subroutine

public function long of_getfirstitem ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_getfirstitem()
// Overview:    This will return the first treeview item
// Created by:  Blake Doerr
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_rowcount, ll_null, ll_handle

SetNull(ll_null)

//Get the first item and set the instance counter to 1 so getnextitem can increment it
ll_rowcount = ids_folder_list.RowCount()

If ll_rowcount > 0 Then
	ll_handle = ids_folder_list.GetItemNumber(1, is_itemhandle_colname)
	il_currentitem = 1
	Return ll_handle 
Else
	Return ll_null
End If
	
end function

public function long of_getnextitem ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_getnextitem()
// Overview:    This will return the next treeview item
// Created by:  Blake Doerr
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_rowcount, ll_null, ll_handle

SetNull(ll_null)

//This will return the next item in the datastore
ll_rowcount = ids_folder_list.RowCount()

If ll_rowcount > il_currentitem Then
	il_currentitem = 	il_currentitem + 1
	ll_handle = ids_folder_list.GetItemNumber(il_currentitem, is_itemhandle_colname)
	Return ll_handle 
Else
	Return ll_null
End If
	
end function

public subroutine of_set_expanding_sql (string as_expanding_sql, boolean ab_is_dataobject);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_expanding_sql()
//	Arguments:  as_expanding_sql - The sql that gets executed when you expand a folder
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	9.10.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_retrieve_on_expand = True
is_expanding_sql = as_expanding_sql
ib_expanding_sql_is_dataobject = ab_is_dataobject
end subroutine

protected function long of_get_picture_index (string as_picture);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_picture_index()
// Arguments:   as_picture - The icon name to display for a particular treeviewitem
// Overview:    Search through the PictureName array of the treeview control, to determine the
//					 index number of the picture name passed to this function.  If the picture does
//					 not exist, add it to the array and return the new array index.
// Created by:  Pat Newgent
// History:     12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index, l_ndx

//-----------------------------------------------------
// Loop through the picture array to determine the 
// index number corresponding to the picture name
//-----------------------------------------------------
For ll_index = 1 To Upperbound(is_picture)
	If Lower(Trim(is_picture[ll_index])) = Lower(Trim(as_picture)) Then Return ll_index
Next

//-----------------------------------------------------
// If the picture was not found above, so add it.
//-----------------------------------------------------
l_ndx = itv_control.AddPicture(as_picture)
If l_ndx <= 0 Or IsNull(l_ndx) Then Return 1

//-----------------------------------------------------
// Add it to the array
//-----------------------------------------------------
is_picture[l_ndx] = as_picture

Return l_ndx

end function

public subroutine of_delete_treeviewitem (long handle);Long 	ll_row

ll_row = ids_folder_list.Find('ItemHandle = ' + String(ll_row), 1, ids_folder_list.RowCount())

If ll_row > 0 And Not IsNull(ll_row) Then
	ids_folder_list.DeleteRow(ll_row)
End If
end subroutine

public function datastore of_get_datastore ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_datastore()
// Overview:    This returns a pointer to the datastore
// Created by:  Blake Doerr
// History:     6/23/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Return ids_folder_list
end function

public function any of_get_column_value (string as_colname, long al_itemhandle);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_column_value()
// Arguments:   as_colname - the name of the column you want the value for
// Overview:    al_itemhandle - the handle of the treeview item that you want information for
// Created by:  Blake Doerr
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
string s_find, s_coltype, s_colval
long l_row
any  a_colval

//Find the row that contains the handle passed in
s_find = 'itemhandle = ' + string(al_itemhandle)
l_row = ids_folder_list.Find(s_find,ids_folder_list.Rowcount(),1)

//Check the column type.  We will do different getitems based on column type
If IsNumber(ids_folder_list.Describe(as_colname + ".ID")) And l_row > 0 And l_row <= ids_folder_list.RowCount() Then
	s_coltype = Trim(lower(ids_folder_list.Describe(as_colname + ".ColType")))
	
	Choose Case s_coltype
		Case 'datetime'
			a_colval = ids_folder_list.GetItemDateTime(l_row, as_colname)
			
		Case 'number', 'long'
			a_colval = ids_folder_list.GetItemNumber(l_row, as_colname)

		Case 'date'
			a_colval = ids_folder_list.GetItemDate(l_row, as_colname)
					
		Case 'time'
			a_colval = ids_folder_list.GetItemTime(l_row, as_colname)
			
		Case Else
			Choose Case Left(s_coltype,4)
				Case 'char'
					a_colval = ids_folder_list.GetItemString(l_row, as_colname)
					
				Case 'deci'
					a_colval = ids_folder_list.GetItemDecimal(l_row, as_colname)
					
			End Choose
	End Choose
Else
	SetNull(a_colval)
End If

//Return an any. The developer will know what datatype to convert it to.
Return a_colval
end function

protected subroutine of_retrieve_datastore ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_retrieve_datastore()
// Arguments:   none
// Overview:    Retrieves the datastore object after it has been created.  The retrieve was broken out into it's own
//					 function to allow it to be overloaded in ancestor objects for datastores that require arguments.
// Created by:  Pat Newgent
// History:     12/21/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ids_folder_list.Retrieve()
Return
end subroutine

public function integer of_reset_expanded_folder (long al_folderhandle);
long i_i,l_itemid
For i_i = 1 to upperbound(il_expanded_folders)
	if il_expanded_folders[i_i] = al_folderhandle then 
		il_expanded_folders[i_i] = 0
	end if
next 


return 0
end function

public function integer of_reset_folder_data (long al_folderhandle);
long l_itemid
string s_find

l_itemid = Long(of_get_column_value('ItemID', al_folderhandle))

s_find = is_folder_colname + ' = ' + string(l_itemid) + ' and ' + is_folder_colname + ' <> ' + is_itemid_colname
ids_folder_list.setfilter(s_find)
ids_folder_list.filter()
ids_folder_list.rowsdiscard(1,ids_folder_list.rowcount(),primary!)
ids_folder_list.setfilter('1=1')
ids_folder_list.filter()



Return 0
end function

public function boolean of_folder_has_been_expanded (long al_folderid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_folder_has_been_expanded()
//	Arguments:  al_folderid - This is the folder to be expanded
//	Overview:   This will return whether or not the folder has been expanded
//	Created by:	Blake Doerr
//	History: 	9.10.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index

For ll_index = 1 To UpperBound(il_expanded_folders[])
	If il_expanded_folders[ll_index] = al_folderid Then Return True
Next

Return False


end function

public subroutine of_set_column_value (long al_itemhandle, string as_colname, any aa_value);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_column_value()
// Arguments:   as_colname - the name of the column you want the value for
// Overview:    al_itemhandle - the handle of the treeview item that you want information for
// Created by:  Blake Doerr
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
string s_find, s_coltype, s_colval
long l_row
any  a_colval

//Find the row that contains the handle passed in
s_find = 'itemhandle = ' + string(al_itemhandle)
l_row = ids_folder_list.Find(s_find,ids_folder_list.Rowcount(),1)

//Check the column type.  We will do different getitems based on column type
If IsNumber(ids_folder_list.Describe(as_colname + ".ID")) And l_row > 0 And l_row <= ids_folder_list.RowCount() Then
	s_coltype = Trim(lower(ids_folder_list.Describe(as_colname + ".ColType")))
	
	Choose Case s_coltype
		Case 'datetime'
			ids_folder_list.setitem(l_row, as_colname,aa_value)
			
		Case 'number', 'long'
			ids_folder_list.setitem(l_row, as_colname,long(aa_value))

		Case 'date'
			ids_folder_list.setitem(l_row, as_colname,aa_value)
					
		Case 'time'
			ids_folder_list.setitem(l_row, as_colname,aa_value)
			
		Case Else
			Choose Case Left(s_coltype,4)
				Case 'char'
					ids_folder_list.setitem(l_row, as_colname,string(aa_value))
					
				Case 'deci'
					ids_folder_list.setitem(l_row, as_colname,dec(aa_value))
					
			End Choose
	End Choose
end if

//Return an any. The developer will know what datatype to convert it to.
//Return a_colval
end subroutine

public subroutine of_build_tree (integer ai_prntid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_build_tree
// Arguments:   The Parent ID representing the root level of the tree (no longer applicable)
// Overview:    Responsible for building the treeview
// Created by:  Pat Newgent
// History:     12/02/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string s_filter, s_name, s_dw_syntax, s_err, s_type, s_picture, s_sort
string s_item_name, s_item_type, s_item_picture
long i, i_PrntID, i_ItemID
long l_handle, l_row, l_rtrn
grSortType	lenum_grSortType

SetPointer(HourGlass!)

//-----------------------------------------------------
// If the main datastore has not been properly created
// then return.
//-----------------------------------------------------
If Not Isvalid(ids_folder_list.Object) then Return
If ids_folder_list.RowCount() + ids_folder_list.FilteredCount() = 0 Then Return

//-----------------------------------------------------
// Store the root level id
//-----------------------------------------------------
ii_root_level_id = ai_prntid
lenum_grSortType = itv_control.SortType
itv_control.SortType = Unsorted!

/*
//-----------------------------------------------------
// Filter the main datastore to hold only ROOT
// level Folders
//-----------------------------------------------------
s_filter = (is_itemtype_colname + ' = ~'F~' and ' + is_folder_colname + ' = ' + is_itemid_colname)
ids_folder_list.SetFilter(s_filter)
ids_folder_list.Filter()

//-----------------------------------------------------
// Create treeviewitems for the root level folders
//-----------------------------------------------------
this.of_create_tvi()

//-----------------------------------------------------
// Filter the main datastore to hold only Non-ROOT
// level Folders
//-----------------------------------------------------
s_filter = (is_itemtype_colname + ' = ~'F~'')
ids_folder_list.SetFilter(s_filter)
ids_folder_list.Filter()

//-----------------------------------------------------
// Create treeviewitems for the remaining folders
//-----------------------------------------------------
this.of_create_tvi()

//-----------------------------------------------------
// Filter main datastore to hold everthing but folders
//-----------------------------------------------------
s_filter = ''
ids_folder_list.SetFilter(s_filter)
ids_folder_list.Filter()
*/
//-----------------------------------------------------
// Create treeviewitems for all non-folder items
//-----------------------------------------------------
this.of_create_tvi()

itv_control.SortType = lenum_grSortType
end subroutine

protected subroutine of_create_tvi ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_create_tvi
// Arguments:   al_folder_handle[] - Stores references to folders handles
// Overview:    Builds the treeviewitems using the rows that currently filtered
//					 in ids_folder_list
// Created by:  Pat Newgent
// History:     04/05/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long i, i_PrntID, i_ItemID, ll_row, ll_folderhandle
String s_name, s_type, s_picture
long l_handle, ll_return
TreeViewItem ltvi_temp


//-----------------------------------------------------
// Loop through each row in ids_folder_list, creating
// a treeviewitem for each.
//-----------------------------------------------------
For i = 1 to ids_folder_list.RowCount()

	//-----------------------------------------------------
	// Determine information contained in current row.
	// This information will be used as follows:
	//     ItemID - Used to update ids_folder_list with the
	//					 handle of the corresponding TreeViewItem
	//		 Name - Used as the descriptive name in the TreeViewControl
	//		 ItemType - Used to update ids_folder_list with the
	//						handle of the corresponding TreeViewItem
	//		 Picture - Icon to associate with TreeViewItem
	//-----------------------------------------------------
	l_handle				= ids_folder_list.GetItemNumber(i, is_itemhandle_colname)

	If l_handle > 0 And Not IsNull(l_handle) Then
		Continue
	Else
		l_handle				= 0
	End If

	i_PrntID 			= ids_folder_list.GetItemNumber(i, is_folder_colname)
	i_ItemID 			= ids_folder_list.GetItemNumber(i, is_itemid_colname)
	s_name 				= ids_folder_list.GetItemString(i, is_itemname_colname)
	s_type 				= ids_folder_list.GetItemString(i, is_itemtype_colname)
	s_picture 			= ids_folder_list.GetItemString(i, is_icon_colname)
	
	ll_folderhandle	= 0

	
	//-----------------------------------------------------
	// Insert the treeviewitem.  If the current itemid =
	// the prntid then the item is a root level folder.
	// Insert root level folders using a parent handle of 0.
	//-----------------------------------------------------
	if i_PrntID = i_ItemID and s_type = 'F' then
		l_handle = itv_control.InsertItemLast(0, s_name, this.of_get_picture_index(s_picture))
	Else
		//-----------------------------------------------------
		// If the current row's Parent folder has not yet been
		// created then set l_handle to 0, else create a 
		// treeviewitem for the current row.
		//-----------------------------------------------------
		ll_row = ids_folder_list.Find(is_itemid_colname + ' = ' + String(i_PrntID), 1, ids_folder_list.RowCount())

		If ll_row > 0 And Not IsNull(ll_row) Then
			ll_folderhandle = ids_folder_list.GetItemNumber(ll_row, is_itemhandle_colname)
		End If

		If ll_folderhandle/*il_folder_handle[i_PrntID]*/ <> 0 then
			l_handle = itv_control.InsertItemLast(ll_folderhandle/*il_folder_//handle[i_PrntID]*/, s_name, this.of_get_picture_index(s_picture))
		Else
			l_handle = 0
		End IF
	End If		

	If ib_retrieve_on_expand Then
		If l_handle > 0 And Not IsNull(l_handle) Then
			itv_control.GetItem(l_handle, ltvi_temp)
			If IsValid(ltvi_temp) Then
				ltvi_temp.Children = True
				itv_control.SetItem(l_handle, ltvi_temp)
			End If
		End If
	End If

	//-----------------------------------------------------
	// If l_handle is set to 0, then a treeviewitem was
	// not created above, as a result of the parent folder
	// having not been created.  In which, case copy the 
	// current record to the end of the datastore
	//-----------------------------------------------------
	If l_handle <> 0 then
		//-----------------------------------------------------
		// If the current item is a folder, then store a 
		// reference to it's handle in al_folder_handle
		//-----------------------------------------------------
		//If s_type = 'F' then il_folder//_handle[i_ItemID] = l_handle
		
		//-----------------------------------------------------
		// Store the treeviewitem handle returned above.
		//-----------------------------------------------------	
		ll_return = ids_folder_list.SetItem(i, is_itemhandle_colname, l_handle)
		
	Else
		If ll_row > 0 And Not IsNull(ll_row) Then
			ids_folder_list.RowsMove(i, i, Primary!, ids_folder_list, ids_folder_list.Rowcount() + 1, Primary!)
			i = i - 1
		End If
	End IF
	
Next

end subroutine

public subroutine of_expand_folder (long al_folderhandle);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_expand_folder
// Arguments:   al_folder_handle[64000] -  The array of handles so far
//					 al_folderid - 
//					 atvi_treeviewitem - 
// Overview:    Builds the treeviewitems using the rows that currently filtered
// Created by:  Blake Doerr
// History:     04/05/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long i, i_PrntID, i_ItemID, ll_folderhandle, ll_row
String s_name, s_type, s_picture, s_dw_syntax, s_err, ls_itemgroup, ls_expanding_sql, ls_find_string, ls_sort
long l_handle, ll_folderid
grSortType	lenum_grSortType

//-----------------------------------------------------
// Return if the argument is not valid
//-----------------------------------------------------
If IsNull(al_folderhandle) Or al_folderhandle = 0 Then Return
SetPointer(HourGlass!)

//-----------------------------------------------------
// Get the folderid
//-----------------------------------------------------
ll_folderid = Long(This.of_get_column_value('ItemID', al_folderhandle))
If Upper(String(This.of_get_column_value('ItemType', al_folderhandle))) <> 'F' Then Return

//-----------------------------------------------------
// If we aren't retrieving on expansion, return
//-----------------------------------------------------
If Not ib_retrieve_on_expand Then Return

//-----------------------------------------------------
// If this has already been expanded, return
//-----------------------------------------------------
If This.of_folder_has_been_expanded(al_folderhandle) Then Return

//-----------------------------------------------------
// Store that this folder has been expanded already
//-----------------------------------------------------
il_expanded_folders[UpperBound(il_expanded_folders) + 1] = al_folderhandle

ls_itemgroup 	= String(This.of_get_column_value('ItemGroup', al_folderhandle))

//-----------------------------------------------------
// Create a datastore to copy to the parent datastore
//-----------------------------------------------------
Datastore lds_datastore
lds_datastore = Create Datastore

If ib_expanding_sql_is_dataobject Then
	lds_datastore.DataObject = is_expanding_sql
Else
	//-----------------------------------------------------
	// Create the datawindow syntax using is_expanding_sql
	//-----------------------------------------------------
	ls_expanding_sql = is_expanding_sql + String(ll_folderid)
	If Len(ls_itemgroup) > 0 Then
		ls_expanding_sql	= ls_expanding_sql + ",'" + ls_itemgroup + "'"
	End If
	s_dw_syntax = SQLCA.SyntaxFromSQL(ls_expanding_sql, '', s_err)
	if s_dw_syntax = '' then 
		Destroy lds_datastore
		Return 
	End IF

	//-----------------------------------------------------
	// Create is_folder_list using the datawindow syntax
	// determined above.
	//-----------------------------------------------------
	if lds_datastore.Create( s_dw_syntax, s_err) <> 1 then
		Destroy lds_datastore
		Return
	End If
End If

//-----------------------------------------------------
// set the transaction object, and retrieve the datastore.
//-----------------------------------------------------
lds_datastore.SetTransObject(SQLCA)
If ib_expanding_sql_is_dataobject Then
	lds_datastore.Retrieve(ll_folderid)
Else
	lds_datastore.Retrieve()
End If

lenum_grSortType = itv_control.SortType
itv_control.SortType	= Unsorted!

ls_sort = 'If(' + is_folder_colname + ' = ' + String(ll_folderid) + ', 1, 2)'

If IsNumber(lds_datastore.Describe("SortColumn.ID")) Then
	ls_sort = ls_sort + ', SortColumn'
Else
	ls_sort = ls_sort  + ', ' + is_itemname_colname
End If

lds_datastore.SetSort(ls_sort)
lds_datastore.Sort()

//-----------------------------------------------------
// Loop through each row in ids_folder_list, creating
// a treeviewitem for each.
//-----------------------------------------------------
For i = 1 to lds_datastore.RowCount()

	//-----------------------------------------------------
	// Determine information contained in current row.
	// This information will be used as follows:
	//     ItemID - Used to update ids_folder_list with the
	//					 handle of the corresponding TreeViewItem
	//		 Name - Used as the descriptive name in the TreeViewControl
	//		 ItemType - Used to update ids_folder_list with the
	//						handle of the corresponding TreeViewItem
	//		 Picture - Icon to associate with TreeViewItem
	//-----------------------------------------------------
	i_PrntID 	= lds_datastore.GetItemNumber(i, is_folder_colname)
	i_ItemID 	= lds_datastore.GetItemNumber(i, is_itemid_colname)
	s_name 		= lds_datastore.GetItemString(i, is_itemname_colname)
	s_type 		= lds_datastore.GetItemString(i, is_itemtype_colname)
	s_picture 	= lds_datastore.GetItemString(i, is_icon_colname)
	ls_find_string	= is_itemid_colname + ' = ' + String(i_PrntID)
	
	If IsNumber(lds_datastore.Describe("ItemGroup.ID")) Then
		ls_itemgroup 	= lds_datastore.GetItemString(i, 'ItemGroup')
		ls_find_string	= ls_find_string + ' And ItemGroup = "' + ls_itemgroup + '"'
	End If

	//-----------------------------------------------------
	// If the current row's Parent folder has not yet been
	// created then set l_handle to 0, else create a 
	// treeviewitem for the current row.
	//-----------------------------------------------------

		
	If ll_folderid <> i_PrntID Then
		ll_row = lds_datastore.Find(ls_find_string, 1, lds_datastore.RowCount())
		If ll_row > 0 And Not IsNull(ll_row) Then
			ll_folderhandle = lds_datastore.GetItemNumber(ll_row, is_itemhandle_colname)
		Else
			ll_folderhandle = 0
		End If
		//ll_folderhandle = il_folder_//handle[i_PrntID]
	Else
		ll_folderhandle = al_folderhandle
	End If
		
	If ll_folderhandle <> 0 then
		l_handle = itv_control.InsertItemLast(ll_folderhandle, s_name, this.of_get_picture_index(s_picture))
		If Upper(Trim(s_type)) = 'F' Then 
//			il_folder_handle[i_ItemID] = l_handle
		
			treeviewitem ltvi_temp
			itv_control.GetItem(l_handle, ltvi_temp)
			If IsValid(ltvi_temp) Then
				ltvi_temp.Children = True
				itv_control.SetItem(l_handle, ltvi_temp)
			End If
		end if
	Else
		l_handle = 0
	End IF

	//-----------------------------------------------------
	// Store the treeviewitem handle returned above.
	//-----------------------------------------------------
	lds_datastore.SetItem(i, is_itemhandle_colname, l_handle)
Next

long l_firstchild
if lds_datastore.rowcount() = 0 then
	itv_control.GetItem(al_folderhandle, ltvi_temp)
	If IsValid(ltvi_temp) Then
		l_firstchild = itv_control.FindItem(ChildTreeitem!, al_folderhandle)
		if l_firstchild = -1 then ltvi_temp.Children = False
		itv_control.SetItem(al_folderhandle, ltvi_temp)
	End If
end if

itv_control.SortType = lenum_grSortType

//-----------------------------------------------------
// Filter out the failures
//-----------------------------------------------------	
lds_datastore.SetFilter("ItemHandle > 0")
lds_datastore.Filter()

//-----------------------------------------------------
// Copy these rows into the parent datastore
//-----------------------------------------------------	
lds_datastore.RowsCopy(1, lds_datastore.RowCount(), Primary!, ids_folder_list, 32000, Primary!)

Destroy lds_datastore
end subroutine

on n_treeview_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_treeview_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      destructor
// Overrides:  No
// Overview:   Destroy the instance created of ids_folder_list
// Created by: Pat Newgent
// History:    12/05/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If isvalid(ids_folder_list) then Destroy ids_folder_list

end event

