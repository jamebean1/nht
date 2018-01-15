$PBExportHeader$w_sort_multi.srw
forward
global type w_sort_multi from window
end type
type st_6 from statictext within w_sort_multi
end type
type ln_2 from line within w_sort_multi
end type
type ln_1 from line within w_sort_multi
end type
type dw_list from datawindow within w_sort_multi
end type
type dw_pick from datawindow within w_sort_multi
end type
type p_1 from picture within w_sort_multi
end type
type st_4 from statictext within w_sort_multi
end type
type st_5 from statictext within w_sort_multi
end type
type ln_6 from line within w_sort_multi
end type
type ln_7 from line within w_sort_multi
end type
type cb_ok2 from commandbutton within w_sort_multi
end type
type cb_cancel2 from commandbutton within w_sort_multi
end type
type cb_apply from commandbutton within w_sort_multi
end type
end forward

global type w_sort_multi from window
integer x = 361
integer y = 736
integer width = 2514
integer height = 1220
boolean titlebar = true
string title = "Sort on Multiple Columns"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
st_6 st_6
ln_2 ln_2
ln_1 ln_1
dw_list dw_list
dw_pick dw_pick
p_1 p_1
st_4 st_4
st_5 st_5
ln_6 ln_6
ln_7 ln_7
cb_ok2 cb_ok2
cb_cancel2 cb_cancel2
cb_apply cb_apply
end type
global w_sort_multi w_sort_multi

type variables
datawindow idw_sort_dw

boolean ib_drag_on = false
datawindow dw_drag_start
integer ii_pick_rw
integer ii_list_rw

n_sort_service invo_message
Boolean ib_change_occurred = False
string is_column_name[],is_column_header_text[],is_column_header[]
end variables

forward prototypes
public function string wf_get_sort ()
public subroutine of_change_occurred ()
public subroutine wf_init (n_sort_service invo_sort)
public subroutine wf_get_old_sort ()
end prototypes

public function string wf_get_sort ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    wf_get_sort()
// Arguements:  none
// Function: 	 Loop through dw_list and build sort string
// Created by 	Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------
string s_sort, s_ascend, s_column, s_bmp
integer i_i

If Not ib_change_occurred Then Return ''

s_sort = ''
//-----------------------------------------------------
// Loop through all the selected columns
//-----------------------------------------------------
for i_i = 1 to dw_list.rowcount()
	s_column = dw_list.getitemstring(i_i,'sortcolumn')
	s_ascend = dw_list.getitemstring(i_i,'s_ascending')
	s_sort = s_sort + ' ' + s_column + ' ' + s_ascend + ','
next

//-----------------------------------------------------
// if none selected don't send anything back
//-----------------------------------------------------
if len(s_sort) > 1 then 
	s_sort = left(s_sort,len(s_sort) - 1)
else
	s_sort = ''
end if

invo_message.of_set_sort(s_sort)

return s_sort
end function

public subroutine of_change_occurred ();ib_change_occurred = True
cb_apply.Enabled = True
end subroutine

public subroutine wf_init (n_sort_service invo_sort);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    wf_init()
// Arguements:  dw_data		Reference to datawindow
// Function: 	 Set the init variables
//					 Loop through the columns and find sortable columns
//					 Create the Arrow
// Created by 	 Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

integer i_num, i_i
string s_import

invo_sort.of_get_multisort_data(is_column_name,is_column_header_text,is_column_header, idw_sort_dw)

//-----------------------------------------------------
// Through the Arrays and create rows in dw
//-----------------------------------------------------
i_num = upperbound(is_column_header)

For i_i = 1 to i_num 

	if is_column_header_text[i_i] = '' then continue

	//-----------------------------------------------------
	// Create an import string and Import it into dw_pick
	//-----------------------------------------------------
	s_import = 	is_column_header_text[i_i] + '~t' + &
					is_column_name[i_i] + '~t' + & 
					'A' + '~t' + &
					is_column_header[i_i] + '~t' + &
					string(i_i)

	dw_pick.importstring(s_import)
	If dw_pick.RowCount() > 0 Then
		dw_pick.SetRow(1)
		dw_pick.Sort()
	End If
Next

This.wf_get_old_sort()
end subroutine

public subroutine wf_get_old_sort ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	wf_get_old_sort()
//	Overview:   This will apply the old sort to the selected datawindow
//	Created by:	Blake Doerr
//	History: 	10/26/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_column
String 	ls_column_name[]
String	ls_ascendingdescending[]
Long		ll_index
Long		ll_index2
Long		ll_row

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the sort as arrays from the sort service
//-----------------------------------------------------------------------------------------------------------------------------------
invo_message.of_get_sort(ls_column_name[], ls_ascendingdescending[])

String	ls_headertext[]
String	ls_expression

n_datawindow_tools ln_datawindow_tools
ln_datawindow_tools = Create n_datawindow_tools


For ll_index = 1 To UpperBound(is_column_header_text[])
	ls_headertext[ll_index] = '[' + is_column_header_text[ll_index] + ']'
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the sorts and see if you kind find the rows as available on the left side
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_ascendingdescending[]), UpperBound(ls_column_name[]))
	ll_row = 0
	For ll_index2 = 1 To dw_pick.RowCount()
		ls_column = Lower(Trim(dw_pick.GetItemString(ll_index2, 'sortcolumn')))
		If ls_column = Lower(Trim(ls_column_name[ll_index])) Then
			ll_row = ll_index2
			Exit
		End If
		
		If ls_column = Lower(Trim('lookupdisplay(' + ls_column_name[ll_index] + ')')) Then
			ll_row = ll_index2
			Exit
		End If
	Next
	//ll_row = dw_pick.Find("Lower(sortcolumn) = '" + Lower(ls_column_name[ll_index] + "' Or Lower(sortcolumn) = 'lookupdisplay(" + Lower(ls_column_name[ll_index]) + ")'"), 1, dw_pick.RowCount())
	If IsNull(ll_row) Or ll_row <= 0 Or ll_row > dw_pick.RowCount() Then
		ll_row = dw_list.InsertRow(0)
		dw_list.SetItem(ll_row, 'sortcolumn', ls_column_name[ll_index])
		dw_list.SetItem(ll_row, 'sorttitle', ln_datawindow_tools.of_translate_expression(ls_column_name[ll_index], is_column_name[], ls_headertext[]))
		dw_list.SetItem(ll_row, 's_ascending', 'A')
	Else
		dw_pick.RowsCopy(ll_row, ll_row, Primary!, dw_list, dw_list.RowCount() + 1, Primary!)		
	End If

	If Upper(Trim(ls_ascendingdescending[ll_index])) = 'D' Then
		dw_list.SetItem(dw_list.RowCount(), 's_ascending', 'D')
	End If
Next

Destroy ln_datawindow_tools
end subroutine

event open;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Open
// Overriden:  No
// Function:   Grab Reference to NVO
//				   Initilize the NVO
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Grab the Reference to the NVO
//-----------------------------------------------------
invo_message = Message.PowerObjectParm

//-----------------------------------------------------
// Initilize the NVO
//-----------------------------------------------------
wf_init(invo_message)

//wf_get_old_sort()

f_center_window(this)
//this.backcolor = gn_globals.in_theme.of_get_backcolor()
end event

on w_sort_multi.create
this.st_6=create st_6
this.ln_2=create ln_2
this.ln_1=create ln_1
this.dw_list=create dw_list
this.dw_pick=create dw_pick
this.p_1=create p_1
this.st_4=create st_4
this.st_5=create st_5
this.ln_6=create ln_6
this.ln_7=create ln_7
this.cb_ok2=create cb_ok2
this.cb_cancel2=create cb_cancel2
this.cb_apply=create cb_apply
this.Control[]={this.st_6,&
this.ln_2,&
this.ln_1,&
this.dw_list,&
this.dw_pick,&
this.p_1,&
this.st_4,&
this.st_5,&
this.ln_6,&
this.ln_7,&
this.cb_ok2,&
this.cb_cancel2,&
this.cb_apply}
end on

on w_sort_multi.destroy
destroy(this.st_6)
destroy(this.ln_2)
destroy(this.ln_1)
destroy(this.dw_list)
destroy(this.dw_pick)
destroy(this.p_1)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.cb_ok2)
destroy(this.cb_cancel2)
destroy(this.cb_apply)
end on

type st_6 from statictext within w_sort_multi
integer y = 984
integer width = 2889
integer height = 252
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 81517531
long backcolor = 81517531
boolean enabled = false
boolean focusrectangle = false
end type

type ln_2 from line within w_sort_multi
long linecolor = 8421504
integer linethickness = 5
integer beginy = 172
integer endx = 4000
integer endy = 172
end type

type ln_1 from line within w_sort_multi
long linecolor = 16777215
integer linethickness = 5
integer beginy = 176
integer endx = 4000
integer endy = 176
end type

type dw_list from datawindow within w_sort_multi
integer x = 910
integer y = 196
integer width = 1559
integer height = 760
integer taborder = 20
string dragicon = "DROPITEM.ICO"
string dataobject = "d_sort_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dragdrop;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DragDrop
// Overriden:  No
// Function:   Move the row from pick
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_row

//-----------------------------------------------------
// If Drag didn't start here then move the row back
//-----------------------------------------------------
if dw_drag_start <> this then
	If row > 0 And Not IsNull(row) and row <= This.RowCount() Then
		ll_row = row
	Else
		ll_row = This.RowCount() + 1
	End If
	
	dw_pick.RowsCopy ( ii_pick_rw, ii_pick_rw, primary!, this, ll_row, Primary!)
	dw_list.drag(end!)
	Parent.of_change_occurred()
end if

end event

on rowfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event       RowFocusChanged
// Overriden:  No
// Function:   Select the Row
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------



long l_rw
l_rw = This.GetRow()
//-----------------------------------------------------
// Select the row
//-----------------------------------------------------
if l_rw > 0 then
	This.SelectRow(0, FALSE)
	This.SelectRow(l_rw, TRUE)
end if

end on

on constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Constructor
// Overriden:  No
// Function:   Set RowfocusIndicator
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

this.setrowfocusindicator(FocusRect!)
end on

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Clicked
// Overriden:  No
// Function:   Set the row
//					Start the Drag
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Set the Row
//-----------------------------------------------------
ii_list_rw = row
this.setrow(ii_list_rw)

If row > 0 And Not IsNull(row) And IsValid(dwo) Then
Else
	Return
End If

Choose Case Lower(Trim(dwo.name))
	Case 'button_expression'
	Case Else
		this.drag(begin!)
		dw_drag_start = this
End Choose

end event

event itemchanged;Parent.of_change_occurred()
end event

event buttonclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Clicked
// Overriden:  No
// Function:   Set the row
//					Start the Drag
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------
Window lw_window
n_bag		ln_bag
String	ls_expression

If row <= 0 Or IsNull(row) Then Return		

Choose Case Lower(Trim(dwo.name))
	Case 'button_expression'
		ls_expression = This.GetItemString(row, 'sortcolumn')
		
		ln_bag = Create n_bag
		ln_bag.of_set('datasource', idw_sort_dw)
		ln_bag.of_set('title', 'Select the Expression for the Sort')
		ln_bag.of_set('expression', ls_expression)
		ln_bag.of_set('NameIsRequired', 'no')
		ln_bag.of_set('NameIsNotAllowed', 'yes')
		ln_bag.of_set('ExpressionNameLabel', 'Label for Sort:')
		ln_bag.of_set('ExpressionDefaultName', '')
		OpenWithParm(lw_window, ln_bag, 'w_custom_expression_builder', w_mdi)
		
		If Not IsValid(ln_bag) Then Return

		Parent.of_change_occurred()
		
		This.SetItem(row, 'sorttitle', String(ln_bag.of_get('expression')))
		This.SetItem(row, 'sortcolumn', String(ln_bag.of_get('datawindowexpression')))

//		ls_expressionlabel 	= String(ln_bag.of_get('ExpressionLabel'))
//		If Not IsNull(ls_expressionlabel) And Len(Trim(ls_expressionlabel)) > 0 Then
//			ls_label = ls_expressionlabel
//		End If

		If IsValid(ln_bag) Then
			Destroy ln_bag
		End If
End Choose

end event

type dw_pick from datawindow within w_sort_multi
integer x = 23
integer y = 196
integer width = 864
integer height = 760
integer taborder = 10
string dragicon = "DRAGITEM.ICO"
string dataobject = "d_sort_pick"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

on constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Constructor
// Overriden:  No
// Function:   Set RowfocusIndicator
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

this.setrowfocusindicator(FocusRect!)
end on

on rowfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event       RowFocusChanged
// Overriden:  No
// Function:   Select the Row
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_rw
l_rw = This.GetRow()
//-----------------------------------------------------
// Select the Row
//-----------------------------------------------------
if l_rw > 0 then
	This.SelectRow(0, FALSE)
	This.SelectRow(l_rw, TRUE)
end if

end on

event dragdrop;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DragDrop
// Overriden:  No
// Function:   Move the row from dw_list to here
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Make sure the drag started somewhere else and move
// the row.
//-----------------------------------------------------
if dw_drag_start <> this then 
	dw_list.DeleteRow(ii_list_rw)
	//dw_list.RowsMove ( ii_list_rw, ii_list_rw, primary!, this, this.rowcount() + 1, Primary!)
	dw_pick.drag(end!)
	//this.sort()
	Parent.of_change_occurred()
end if

end event

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Clicked
// Overriden:  No
// Function:   Set the row
//					Start the Drag
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Get the Picked Row
// Set the Row
// Turn on the Drag
//-----------------------------------------------------
/*** BEGIN REPLACED BTW, 04/28/1997 for PB5.0 Fix
ii_pick_rw = this.getclickedrow()
END REPLACED BTW, 04/28/1997 ***/

// BEGIN CORRECTED BTW, 04/28/1997 For PB5.0 Fix
ii_pick_rw = row
// END CORRECTED BTW, 04/28/1997 

this.setrow(ii_pick_rw)
this.drag(begin!)

//-----------------------------------------------------
// This is where the Drag Started
//-----------------------------------------------------
dw_drag_start = this

end event

type p_1 from picture within w_sort_multi
integer x = 27
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "module - smartsearch - large icon (white).bmp"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sort_multi
integer x = 215
integer y = 64
integer width = 2231
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "You may select multiple columns to sort.  The ~"...~" buttons will allow you to create an expression."
boolean focusrectangle = false
end type

type st_5 from statictext within w_sort_multi
integer width = 2505
integer height = 172
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

type ln_6 from line within w_sort_multi
long linecolor = 8421504
integer linethickness = 5
integer beginy = 976
integer endx = 4000
integer endy = 976
end type

type ln_7 from line within w_sort_multi
long linecolor = 16777215
integer linethickness = 5
integer beginy = 980
integer endx = 4000
integer endy = 980
end type

type cb_ok2 from commandbutton within w_sort_multi
integer x = 1778
integer y = 1016
integer width = 325
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Clicked
// Overriden:  No
// Function:   Close With Return
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// This wf_get_sort actually sorts the dw
//-----------------------------------------------------
//****by lyndal>>  
//invo_message.of_reset()
//****
wf_get_sort()

//-----------------------------------------------------
// Close with 1 = True
//-----------------------------------------------------
ClosewithReturn(Parent,1)



end event

type cb_cancel2 from commandbutton within w_sort_multi
integer x = 2126
integer y = 1016
integer width = 325
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Clicked
// Overriden:  No
// Function:   Return Empty String
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Close with 0 = False
//-----------------------------------------------------
ClosewithREturn(Parent,0)
end event

type cb_apply from commandbutton within w_sort_multi
integer x = 1431
integer y = 1016
integer width = 325
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Apply"
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Clicked
// Overriden:  No
// Function:   Close With Return
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// This wf_get_sort actually sorts the dw
//-----------------------------------------------------
//****by lyndal>>  
//invo_message.of_reset()
//****
wf_get_sort()
This.Enabled = False
end event

