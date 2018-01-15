$PBExportHeader$n_fwca_menu.sru
$PBExportComments$Application service to handle standard menu item configuration
forward
global type n_fwca_menu from n_fwca_mgr
end type
end forward

global type n_fwca_menu from n_fwca_mgr
string DataObject="d_fwca_menu_std"
end type
global n_fwca_menu n_fwca_menu

type variables

end variables

forward prototypes
public function string fu_getmenubarlabel (string label_name)
public function integer fu_getmenulabels (string label_type, ref string labels[])
end prototypes

public function string fu_getmenubarlabel (string label_name);//******************************************************************
//  PC Module     : n_FWCA_MENU
//  Function      : fu_GetMenuBarLabel
//  Description   : Get the label associated with a menu bar item.
//
//  Parameters    : STRING Label_Name -
//                    Menu bar id to use to find the label.
//
//  Return Value  : STRING -
//                     Menu bar label.  If the label is not found
//                     then return "".
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE label_name
	CASE "File"
		RETURN GetItemString(1, "label")
	CASE "Edit"
		RETURN GetItemString(2, "label")
	CASE ELSE
		RETURN ""
END CHOOSE
end function

public function integer fu_getmenulabels (string label_type, ref string labels[]);//******************************************************************
//  PC Module     : n_FWCA_MENU
//  Function      : fu_GetMenuLabels
//  Description   : Get the labels associated with a menu bar item
//                  or configuration.
//
//  Parameters    : STRING Label_Type -
//                     The type of labels to return.
//                  STRING Labels[] -
//                     Menu bar labels.
//
//  Return Value  : INTEGER -
//                     Number of labels returned.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_NumItems, l_NumLabels, l_Idx
STRING  l_LabelType, l_Label, l_ID

l_NumItems  = RowCount()
l_LabelType = Upper(label_type)
l_NumLabels = 0

CHOOSE CASE l_LabelType

	CASE "FILE", "EDIT"

		FOR l_Idx = 1 TO l_NumItems
			IF Upper(GetItemString(l_Idx, "location")) = l_LabelType THEN
				l_NumLabels = l_NumLabels + 1
				Labels[l_NumLabels] = GetItemString(l_Idx, "label")
			END IF
		NEXT

	CASE "MDI CONFIG"
	
		FOR l_Idx = 1 TO l_NumItems
			IF Upper(GetItemString(l_Idx, "location")) = "FILE" THEN
				l_Label = GetItemString(l_Idx, "label")
				l_ID = GetItemString(l_Idx, "id")
				CHOOSE CASE l_ID
					CASE "Close"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "File Sep"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "Cancel"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "Accept"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "SaveSep"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "Save"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "SaveRowsAs"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "PrintSep"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "Print"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
				END CHOOSE
			END IF
		NEXT

	CASE "DW CONFIG"
	
		FOR l_Idx = 1 TO l_NumItems
			IF Upper(GetItemString(l_Idx, "location")) = "FILE" THEN
				l_Label = GetItemString(l_Idx, "label")
				l_ID = GetItemString(l_Idx, "id")
				CHOOSE CASE l_ID
					CASE "Close"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "SaveSep"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "Save"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "SaveRowsAs"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "PrintSep"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
					CASE "Print"
						l_NumLabels = l_NumLabels + 1
						Labels[l_NumLabels] = l_Label
				END CHOOSE
			END IF
		NEXT

	CASE "DW ACTIVATE"
	
		FOR l_Idx = 1 TO l_NumItems
			l_Label = GetItemString(l_Idx, "label")
			l_ID = GetItemString(l_Idx, "id")
			CHOOSE CASE l_ID
				CASE "New"
					Labels[1] = l_Label
				CASE "Insert"
					Labels[2] = l_Label
				CASE "View"
					Labels[3] = l_Label
				CASE "Modify"
					Labels[4] = l_Label
				CASE "Delete"
					Labels[5] = l_Label
				CASE "First"
					Labels[6] = l_Label
				CASE "Previous"
					Labels[7] = l_Label
				CASE "Next"
					Labels[8] = l_Label
				CASE "Last"
					Labels[9] = l_Label
				CASE "Query"
					Labels[10] = l_Label
				CASE "Search"
					Labels[11] = l_Label
				CASE "Filter"
					Labels[12] = l_Label
				CASE "Sort"
					Labels[13] = l_Label
				CASE "Save"
					Labels[14] = l_Label
				CASE "SaveRowsAs"
					Labels[15] = l_Label
				CASE "Print"
					Labels[16] = l_Label
				CASE "Close"
					Labels[17] = l_Label
				CASE "Copy"
					Labels[18] = l_Label
			END CHOOSE
		NEXT
		l_NumLabels = UpperBound(Labels[])
		
END CHOOSE

RETURN l_NumLabels
end function

on n_fwca_menu.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on n_fwca_menu.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

