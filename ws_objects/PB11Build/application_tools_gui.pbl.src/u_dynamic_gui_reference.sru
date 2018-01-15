$PBExportHeader$u_dynamic_gui_reference.sru
forward
global type u_dynamic_gui_reference from u_dynamic_gui
end type
type dw_detail from u_display_datawindow_reference within u_dynamic_gui_reference
end type
end forward

global type u_dynamic_gui_reference from u_dynamic_gui
integer width = 3424
integer height = 748
//uo_titlebar uo_titlebar
dw_detail dw_detail
end type
global u_dynamic_gui_reference u_dynamic_gui_reference

type variables
Protected:
	String	is_GUIDataObject
	String	is_EnttyNme
	Long		il_RprtDtbseID
	Boolean 	ib_ThisIsTheFirstTimeTheDAOHasBeenSet = True
end variables

forward prototypes
public subroutine of_determine_best_height ()
end prototypes

public subroutine of_determine_best_height ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_determine_best_height()
//	Overview:   This will determine what the best height for this object should be based on the contents
//						of the datawindow
//	Created by:	Joel White
//	History: 	9/29/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_group_header_height
Long	ll_group_footer_height
Long	ll_headercount = 1
Long	ll_index
Long	ll_findrow
Long	ll_total_height = 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the height of all the bands
//-----------------------------------------------------------------------------------------------------------------------------------
ll_total_height = ll_total_height + Long(dw_detail.Describe("Datawindow.Header.Height"))
ll_total_height = ll_total_height + (Long(dw_detail.Describe("Datawindow.Detail.Height")) * Max(dw_detail.RowCount(), 1))
ll_total_height = ll_total_height + Long(dw_detail.Describe("Datawindow.Summary.Height"))
ll_total_height = ll_total_height + Long(dw_detail.Describe("Datawindow.Footer.Height"))

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the height of the group headers if they exist
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To 4
	ll_group_header_height = Long(dw_detail.Describe("Datawindow.Header."  + String(ll_index) + ".Height"))
	ll_group_footer_height = Long(dw_detail.Describe("Datawindow.Trailer."  + String(ll_index) + ".Height"))

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the group exists, find the number of headers
	//-----------------------------------------------------------------------------------------------------------------------------------
	If (ll_group_header_height > 0 And Not IsNull(ll_group_header_height)) Or (ll_group_footer_height > 0 And Not IsNull(ll_group_footer_height)) Then
		ll_headercount = 1
		ll_findrow = 1
		ll_findrow = dw_detail.FindGroupChange(ll_findrow, ll_index)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Find all group headers that will contribute to the height
		//-----------------------------------------------------------------------------------------------------------------------------------
		DO WHILE ll_findrow > 0
			ll_headercount = ll_headercount + 1
			ll_findrow = dw_detail.FindGroupChange(ll_findrow + 1, ll_index)
		LOOP
																											//There is a 1 PBU per group header fudge factor here	
		ll_total_height = ll_total_height + (ll_group_header_height * ll_headercount)  		- (ll_headercount) * 1
		ll_total_height = ll_total_height + (ll_group_footer_height * (ll_headercount - 1)) 	- (ll_headercount - 1) * 1
	End If
Next

This.Height = ll_total_height + dw_detail.Y
end subroutine

on u_dynamic_gui_reference.create
int iCurrent
call super::create
//this.uo_titlebar=create uo_titlebar
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
//this.Control[iCurrent+1]=this.uo_titlebar
this.Control[iCurrent+2]=this.dw_detail
end on

event ue_setdao;call super::ue_setdao;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_setdao
//	Overrides:  No
//	Arguments:	
//	Overview:   This event is called from the of_setdao() function.  It allows you to retrieve the datawindow from the dao and propagate the dao to other objects.
//	Created by: Joel White
//	History:    9/2/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dao onto the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
dw_detail.of_setdao(in_dao)

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the data from the dao
//-----------------------------------------------------------------------------------------------------------------------------------
dw_detail.Event ue_retrieve()

//-----------------------------------------------------------------------------------------------------------------------------------
// If this is the first time this dao has ben set, let's determine the best size for this object
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_ThisIsTheFirstTimeTheDAOHasBeenSet Then
	ib_ThisIsTheFirstTimeTheDAOHasBeenSet = False
	This.of_determine_best_height()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the text from the dao
//-----------------------------------------------------------------------------------------------------------------------------------
This.Text = in_dao.of_getitem(1, 'title')
//uo_titlebar.of_settitle(This.Text)
end event

event resize;call super::resize;//uo_titlebar.Width = This.Width
dw_detail.Width = Width - (dw_detail.X * 2)
dw_detail.Height = Height - dw_detail.Y
end event

event ue_close;call super::ue_close;
String ls_return

If Not IsValid(in_dao) Then Return 0 

If in_dao.Dynamic Function of_get_security() <= 1 Then Return 0

If in_dao.Dynamic Event ue_ismodified() Then
	
	Choose Case gn_globals.in_messagebox.of_messagebox ( 'This data has been modified.  Do you wish to save changes', Question!, YesNoCancel!, 3 )
		Case	1
			ls_return = in_dao.Dynamic Event ue_save(True)
			If Lower(Trim(ls_return)) = 'cancel' Then Return 1
				
			If ls_return <> '' Then
				//----------------------------------------------------------------------------------------------------------------------------------
				// Pop up a messagebox for validation
				//-----------------------------------------------------------------------------------------------------------------------------------
				gn_globals.in_messagebox.of_messagebox( 'This data has been modified.  Do you wish to save changes', Question!, YesNoCancel!, 3 )
				Return 1
			End If
			
		Case	3
			
			Return 1
	End Choose
End If

Return 0

end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    	- The message being triggered
//					aany_argument (Any) 		- The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Joel White
// History:   	10/25/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_bag ln_bag
Transaction lxctn_transaction
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Case statement for all messages
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_message))
	Case 'set parameters'
		ln_bag = as_arg
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the DAODataObject if it has been provided
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not IsNull(ln_bag.of_get('GUIDataObject')) Then
			is_GUIDataObject = ln_bag.of_get('GUIDataObject')
		
			//-----------------------------------------------------------------------------------------------------------------------------------
			// If the report database id is valid, get the transaction from the pool
			//-----------------------------------------------------------------------------------------------------------------------------------
			If is_GUIDataObject > '' And Not IsNull(is_GUIDataObject) And Lower(Trim(dw_detail.DataObject)) <> Lower(Trim(is_GUIDataObject)) Then
				dw_detail.DataObject = is_GUIDataObject
				This.Event ue_refreshtheme()
			End If
		End If

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the ReportDatabase ID so we can go against any database
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not IsNull(ln_bag.of_get('RprtDtbseID')) Then
			il_RprtDtbseID = Long(ln_bag.of_get('RprtDtbseID'))
		
			//-----------------------------------------------------------------------------------------------------------------------------------
			// If the report database id is valid, get the transaction from the pool
			//-----------------------------------------------------------------------------------------------------------------------------------
			If il_RprtDtbseID > 0 And Not IsNull(il_RprtDtbseID) Then
				lxctn_transaction	= SQLCA
			End If
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If we couldn't get a valid transaction, use SQLCA
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not IsValid(lxctn_transaction) Then lxctn_transaction = SQLCA

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the transaction object
		//-----------------------------------------------------------------------------------------------------------------------------------
		dw_detail.SetTransObject(lxctn_transaction)

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the entity.  If it's valid, get the security level for that entity
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not IsNull(ln_bag.of_get('Entity')) Then 
			is_EnttyNme = String(ln_bag.of_get('Entity'))
		End If

		ls_return = dw_detail.Describe("defaultwidth.X")
		If IsNumber(ls_return) Then
			This.Width = Long(ls_return)
		End If

		If Upper(Trim(String(ln_bag.of_get('HideToolbar')))) = 'Y' Then
			//uo_titlebar.Visible = False
			//dw_detail.Y = dw_detail.Y - uo_titlebar.Y - uo_titlebar.Height
		End If

	Case	'button clicked', 'buttonclicked', 'menucommand', 'menu command'
		Choose Case Lower(Trim(String(as_arg)))
			Case 'save detail'
				If Not IsValid(in_dao) Then Return

				ls_return = in_dao.Dynamic Event ue_save(True)
						
				If ls_return <> '' And Lower(Trim(ls_return)) <> 'cancel' Then
					//----------------------------------------------------------------------------------------------------------------------------------
					// Pop up a messagebox for validation
					//-----------------------------------------------------------------------------------------------------------------------------------
					gn_globals.in_messagebox.of_messagebox ('This data has been modified.  Do you wish to save changes', Question!, YesNoCancel!, 3 )
					Return 
				End If
		
			Case	'close'
				io_parent.Dynamic Event ue_notify('close object', This)		

		End Choose
End Choose
end event

event ue_refreshtheme;call super::ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   This event will refresh all the objects on the window
// Created by: Joel White
// History:    9/4/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// This will set the background color
//-----------------------------------------------------------------------------------------------------------------------------------
//This.Backcolor = gn_globals.in_theme.of_get_backcolor()
end event

event constructor;call super::constructor;//This.of_add_button('Save', 'Save Detail', Parent)
//This.of_add_button('x', 'Close', Parent)
end event

type dw_detail from u_display_datawindow_reference within u_dynamic_gui_reference
integer y = 68
integer width = 3415
integer height = 636
integer taborder = 10
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;This.SetRedraw(true)
end event

