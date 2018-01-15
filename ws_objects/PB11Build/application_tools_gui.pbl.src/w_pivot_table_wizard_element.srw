$PBExportHeader$w_pivot_table_wizard_element.srw
forward
global type w_pivot_table_wizard_element from window
end type
type dw_properties from u_datawindow within w_pivot_table_wizard_element
end type
type cb_cancel from u_commandbutton within w_pivot_table_wizard_element
end type
type cb_ok from u_commandbutton within w_pivot_table_wizard_element
end type
type ln_6 from line within w_pivot_table_wizard_element
end type
type ln_7 from line within w_pivot_table_wizard_element
end type
type st_4 from statictext within w_pivot_table_wizard_element
end type
end forward

global type w_pivot_table_wizard_element from window
integer x = 1001
integer y = 1000
integer width = 1787
integer height = 800
boolean titlebar = true
string title = "Pivot Table Element Properties"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 81448892
dw_properties dw_properties
cb_cancel cb_cancel
cb_ok cb_ok
ln_6 ln_6
ln_7 ln_7
st_4 st_4
end type
global w_pivot_table_wizard_element w_pivot_table_wizard_element

type variables
Protected:
	n_bag in_bag
	u_pivot_table_rowsandcolumns iu_pivot_table_rowsandcolumns
	Datawindow	idw_data
	PowerObject	io_datasource
	Long			il_row
	String		is_suffix
end variables

forward prototypes
public function boolean of_validate ()
public subroutine of_build_expression ()
end prototypes

public function boolean of_validate ();Return True
end function

public subroutine of_build_expression ();//----------------------------------------------------------------------------------------------------------------------------------
// Event       of_build_expression
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Window lw_window
n_bag		ln_bag

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_expression
String	ls_expression_new
String	ls_expression_label_default = ''
String	ls_expression_label_new
String	ls_columnname

//-----------------------------------------------------
// Get the current expression
//-----------------------------------------------------
ls_expression = dw_properties.GetItemString(1, 'databasename')
ls_columnname = dw_properties.GetItemString(1, 'columnname')

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out necessary information from the expression
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(ls_columnname, '] = ') > 0 And Left(ls_columnname, 1) = '[' Then
	ls_expression_label_default = Left(ls_columnname, Pos(ls_columnname, '] = ') - 1)
	ls_expression_label_default = Right(ls_expression_label_default, Len(ls_expression_label_default) - 1)
Else
	ls_expression_label_default	= 'Expression' + String(il_row)
End If

//-----------------------------------------------------
// Create a bag object and set all the information
//-----------------------------------------------------
ln_bag = Create n_bag
ln_bag.of_set('datasource', io_datasource)
ln_bag.of_set('title', 'Select the Expression for the Pivot Table Element')
ln_bag.of_set('expression', ls_expression)
ln_bag.of_set('NameIsRequired', 'yes')
ln_bag.of_set('ExpressionNameLabel', 'Label for Pivot Table Element:')
ln_bag.of_set('ExpressionDefaultName', ls_expression_label_default)

//-----------------------------------------------------
// Open the expression datawindow
//-----------------------------------------------------
OpenWithParm(lw_window, ln_bag, 'w_custom_expression_builder', This)

//-----------------------------------------------------
// Return if the bag was destroyed (cancel)
//-----------------------------------------------------
If Not IsValid(ln_bag) Then Return

//-----------------------------------------------------
// Get the new expression
//-----------------------------------------------------
ls_expression_new = String(ln_bag.of_get('datawindowexpression'))
ls_expression_label_new	= String(ln_bag.of_get('expressionlabel'))

//-----------------------------------------------------------------------------------------------------------------------------------
// If the expression is null return
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_expression_new = '' Or IsNull(ls_expression_new) Then
	Destroy ln_bag
	Return
End If

//-----------------------------------------------------
// If it hasn't changed, return
//-----------------------------------------------------
If ls_expression_new = ls_expression And ls_expression_label_new = ls_expression_label_default Then Return

//-----------------------------------------------------
// Set the column values
//-----------------------------------------------------
dw_properties.SetItem(1, 'columnname', '[' + String(ls_expression_label_new) + '] = ' + String(ln_bag.of_get('expression')))
dw_properties.SetItem(1, 'databasename', ls_expression_new)
dw_properties.SetItem(1, 'datatype', iu_pivot_table_rowsandcolumns.of_get_datatype(dw_properties.GetItemString(1, 'databasename')))
dw_properties.SetItem(1, 'iscomputedfield', 'Y')

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the bag object
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_bag
end subroutine

on w_pivot_table_wizard_element.create
this.dw_properties=create dw_properties
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.ln_6=create ln_6
this.ln_7=create ln_7
this.st_4=create st_4
this.Control[]={this.dw_properties,&
this.cb_cancel,&
this.cb_ok,&
this.ln_6,&
this.ln_7,&
this.st_4}
end on

on w_pivot_table_wizard_element.destroy
destroy(this.dw_properties)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.st_4)
end on

event open;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Open
//	Overrides:  No
//	Arguments:	
//	Overview:   
//	Created by: Blake Doerr
//	History:    7/23/01 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_index, ll_index2
String	ls_headers[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Close if we didn't get the correct datatype or it is invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(Message.PowerObjectParm) Then Post Close(This)
If Not ClassName(Message.PowerObjectParm) = 'n_bag' Then Post Close(This)

f_center_window(this)

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the bag into an instance variable
//-----------------------------------------------------------------------------------------------------------------------------------
in_bag 					= Message.PowerObjectParm

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the various variables into instance variables
//-----------------------------------------------------------------------------------------------------------------------------------
iu_pivot_table_rowsandcolumns = in_bag.of_get('u_pivot_table_rowsandcolumns')
idw_data								= in_bag.of_get('datawindow')
il_row								= Long(in_bag.of_get('row'))
io_datasource						= in_bag.of_get('datasource')
is_suffix							= String(in_bag.of_get('columnsuffix'))
If IsNull(is_suffix) Then is_suffix = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert a row into the properties datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
dw_properties.InsertRow(0)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns and copy the data
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Long(dw_properties.Describe("Datawindow.Column.Count"))
	For ll_index2 = 1 To Long(idw_data.Describe("Datawindow.Column.Count"))
		If idw_data.Describe('#' + String(ll_index2) + ".Name") = dw_properties.Describe('#' + String(ll_index) + ".Name") + is_suffix Then
			dw_properties.Object.Data[1, ll_index, 1, ll_index] = idw_data.Object.Data[il_row, ll_index2, il_row, ll_index2]
			Exit
		End If
	Next
Next
dw_properties.Post SetRedraw(True)
end event

type dw_properties from u_datawindow within w_pivot_table_wizard_element
integer y = 12
integer width = 1783
integer height = 512
integer taborder = 10
boolean border = false
end type

event buttonclicked;call super::buttonclicked;If IsValid(dwo) Then
	Choose Case Lower(Trim(dwo.Name))
		Case 'button_expression'
			Parent.of_build_expression()
	End Choose
End If

end event

event clicked;call super::clicked;SetRedraw(true)
end event

type cb_cancel from u_commandbutton within w_pivot_table_wizard_element
integer x = 1413
integer y = 584
integer width = 325
integer height = 88
integer taborder = 62
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   Close the parent window returning -1 indicating the user has cancelled the folder selection process.
// Created by: Pat Newgent
// History:    12/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Close(Parent)

end event

type cb_ok from u_commandbutton within w_pivot_table_wizard_element
integer x = 1056
integer y = 584
integer width = 325
integer height = 88
integer taborder = 52
integer weight = 400
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;call super::clicked;//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_index2
String	ls_headers[]
n_datawindow_tools ln_datawindow_tools

SetPointer(HourGlass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that the information is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not Parent.of_validate() Then Return

ln_datawindow_tools = Create n_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through both datawindows and set the information back into the original
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Long(dw_properties.Describe("Datawindow.Column.Count"))
	For ll_index2 = 1 To Long(idw_data.Describe("Datawindow.Column.Count"))
		If idw_data.Describe('#' + String(ll_index2) + ".Name") = dw_properties.Describe('#' + String(ll_index) + ".Name") + is_suffix Then
			If ln_datawindow_tools.of_getitem(idw_data, il_row, idw_data.Describe('#' + String(ll_index2) + ".Name")) <> ln_datawindow_tools.of_getitem(dw_properties, 1, dw_properties.Describe('#' + String(ll_index) + ".Name") + is_suffix) Then
				idw_data.Object.Data[il_row, ll_index2, il_row, ll_index2] = dw_properties.Object.Data[1, ll_index, 1, ll_index]
				iu_pivot_table_rowsandcolumns.of_change_occurred()
				Exit
			End If
		End If
	Next
Next

Destroy ln_datawindow_tools

Close(Parent)
end event

type ln_6 from line within w_pivot_table_wizard_element
long linecolor = 16777215
integer linethickness = 1
integer beginy = 560
integer endx = 32000
integer endy = 560
end type

type ln_7 from line within w_pivot_table_wizard_element
long linecolor = 8421504
integer linethickness = 1
integer beginy = 556
integer endx = 32000
integer endy = 556
end type

type st_4 from statictext within w_pivot_table_wizard_element
integer y = 564
integer width = 32000
integer height = 140
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

