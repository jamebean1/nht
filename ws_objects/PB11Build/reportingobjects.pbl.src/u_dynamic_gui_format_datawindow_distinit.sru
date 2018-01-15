$PBExportHeader$u_dynamic_gui_format_datawindow_distinit.sru
forward
global type u_dynamic_gui_format_datawindow_distinit from u_dynamic_gui_format
end type
type st_1 from statictext within u_dynamic_gui_format_datawindow_distinit
end type
type st_2 from statictext within u_dynamic_gui_format_datawindow_distinit
end type
type st_3 from statictext within u_dynamic_gui_format_datawindow_distinit
end type
type st_4 from statictext within u_dynamic_gui_format_datawindow_distinit
end type
type ln_2 from line within u_dynamic_gui_format_datawindow_distinit
end type
type ln_3 from line within u_dynamic_gui_format_datawindow_distinit
end type
type ln_4 from line within u_dynamic_gui_format_datawindow_distinit
end type
type ln_5 from line within u_dynamic_gui_format_datawindow_distinit
end type
end forward

global type u_dynamic_gui_format_datawindow_distinit from u_dynamic_gui_format
integer width = 1870
integer height = 1136
long backcolor = 80263581
string text = "Distribution"
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
ln_5 ln_5
end type
global u_dynamic_gui_format_datawindow_distinit u_dynamic_gui_format_datawindow_distinit

type variables

end variables

forward prototypes
public function boolean of_validate ()
public function string of_apply_property (datawindow adw_property_datawindow, string as_columnname, powerobject ao_apply_datawindow)
public subroutine of_init ()
public subroutine of_apply ()
end prototypes

public function boolean of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate()
//	Overview:   This will apply the gui to the datawindow
//	Created by:	Blake Doerr
//	History: 	9/6/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_row
String	ls_return
String	ls_column

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_distributioninit ln_distributioninit

//-----------------------------------------------------------------------------------------------------------------------------------
// Validate the GUI
//-----------------------------------------------------------------------------------------------------------------------------------
is_errormessage = ''
ln_distributioninit = Create n_distributioninit
ls_return = ln_distributioninit.of_validate_gui(dw_properties, ll_row, ls_column)
Destroy ln_distributioninit

//-----------------------------------------------------------------------------------------------------------------------------------
// If we don't get an error message return
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return = '' Then Return True

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the message so a messagebox can be presented
//-----------------------------------------------------------------------------------------------------------------------------------
is_errormessage = ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine which datawindow to set focus to
//-----------------------------------------------------------------------------------------------------------------------------------
//Choose Case Lower(Trim(ls_column))
//	Case 'decimals', 'userounding', 'uomlabel', 'uomdisplaycolumn', 'uomdisplaytype', 'currencydisplaycolumn', 'currencydisplaytype'
//		dw_other.SetColumn(ls_column)
//		dw_other.Post SetFocus()
//	Case Else
//		dw_properties.SetRow(ll_row)
//		dw_properties.SetColumn(ls_column)
//		dw_properties.ScrollToRow(ll_row)
//		dw_properties.Post SetFocus()
//End Choose
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Return false since we have an error
//-----------------------------------------------------------------------------------------------------------------------------------
Return False

end function

public function string of_apply_property (datawindow adw_property_datawindow, string as_columnname, powerobject ao_apply_datawindow);//Overridden
Return ''
end function

public subroutine of_init ();n_distributioninit ln_distributioninit
Long		ll_reportconfigid
Long		ll_index
Long		ll_index2
String	ls_distributioninit
n_report	ln_report

ll_reportconfigid = Long(idw_data.Event Dynamic ue_get_rprtcnfgid())

If ll_reportconfigid > 0 And Not IsNull(ll_reportconfigid) Then
	dw_properties.SetTransObject(SQLCA)
	dw_properties.Retrieve(ll_reportconfigid)

	ln_report = idw_data.Dynamic of_get_properties()
	
	ln_distributioninit = Create n_distributioninit
	ln_distributioninit.of_init(ln_report.Event ue_getitem(1, 'DistributionInitOverrides'))
	ln_distributioninit.of_apply_to_gui(dw_properties)
	Destroy ln_distributioninit
End If


end subroutine

public subroutine of_apply ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply()
//	Overview:   This will apply the gui to the datawindow
//	Created by:	Blake Doerr
//	History: 	9/6/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_distributioninit 	ln_distributioninit
n_report					ln_report

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the gui to the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ln_distributioninit = Create n_distributioninit
ln_distributioninit.of_set_gui(dw_properties)

ln_report = idw_data.Dynamic of_get_properties()
ln_report.Event ue_setitem(1, 'DistributionInit', ln_distributioninit.of_get_expression())
Destroy ln_distributioninit
end subroutine

on u_dynamic_gui_format_datawindow_distinit.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.ln_5)
end on

on u_dynamic_gui_format_datawindow_distinit.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.ln_5=create ln_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.ln_2
this.Control[iCurrent+6]=this.ln_3
this.Control[iCurrent+7]=this.ln_4
this.Control[iCurrent+8]=this.ln_5
end on

type dw_properties from u_dynamic_gui_format`dw_properties within u_dynamic_gui_format_datawindow_distinit
integer x = 78
integer y = 84
integer width = 1673
integer height = 648
string dataobject = "d_format_report_distributioninit_avail"
boolean vscrollbar = true
end type

event dw_properties::clicked;call super::clicked;//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_null
String	ls_new_value
String	ls_gui_object
String	ls_options
String	ls_defaultoptions
String	ls_report_options
String	ls_distributionmethod
String	ls_reportdistributionoptions
String	ls_distributioninit
String	ls_distributioninit_new
String	ls_name[]
String	ls_value[]
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
w_basewindow_distribution_options lw_options
//n_string_functions ln_string_functions
n_bag ln_bag

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the row is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If row <= 0 Or IsNull(row) Or row > This.RowCount() Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the clicked object isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(dwo) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the clicked object isn't a column or computed field
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(dwo.Type)) <> 'compute' And Lower(Trim(dwo.Type)) <> 'text' Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Treat each object differently
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(dwo.Name))
	Case "button_clear"
		This.SetItem(row, "distributioninit", '')
	Case "cf_options"
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the distribution information out of the datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_gui_object 						= this.GetItemString(row,"distributionoptionsgui")
		ls_defaultoptions 				= this.GetItemString(row,"defaultdistributionoptions")
		ls_reportdistributionoptions	= This.GetItemString(row,"ReportDistributionMethodOption")
		ls_options 							= this.GetItemString(row,"distributioninit")
		ls_distributionmethod 			= this.GetItemString(row,"distributionmethod")
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Add the default options
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Len(ls_defaultoptions) > 0 Then
			ls_distributioninit = ls_defaultoptions + '||'
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Add the report level options
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Len(ls_reportdistributionoptions) > 0 Then
			ls_distributioninit = ls_distributioninit + ls_reportdistributionoptions + '||'
		End If

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Add the report level options
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Len(ls_options) > 0 Then
			ls_distributioninit = ls_distributioninit + ls_options + '||'
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Remove the extra delimiter
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_distributioninit = Left(ls_distributioninit, Len(ls_distributioninit) - 2)
		
		ln_bag = Create n_bag
		ln_bag.of_set('DistributionMethod', ls_distributionmethod)
		ln_bag.of_set('GUI', ls_gui_object)
		ln_bag.of_set('Options', ls_distributioninit)
		ln_bag.of_set('Datasource', idw_data.Dynamic of_get_properties())
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Open the window that will allow the user to edit the distribution options
		//-----------------------------------------------------------------------------------------------------------------------------------
		OpenWithParm(lw_options, ln_bag, of_getparentwindow())

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Destroy the container object
		//-----------------------------------------------------------------------------------------------------------------------------------
		Destroy ln_bag

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the return options
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_distributioninit_new = Message.StringParm//ln_bag.of_get('Options')
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Return if we should not apply the new options
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ls_distributioninit_new = ls_distributioninit Or IsNull(ls_distributioninit_new) Or Lower(left(ls_distributioninit_new, 6)) = "cancel" Then Return
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Parse the default options so we can remove them from the string if they haven't changed
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_parse_arguments(ls_defaultoptions, '||', ls_name[], ls_value[])
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Compare the new arguments to the defaults and remove ones that are the same
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index = 1 To UpperBound(ls_name[])
			ls_new_value	= gn_globals.in_string_functions.of_find_argument(ls_distributioninit_new, '||', ls_name[ll_index])
			If Lower(Trim(ls_new_value)) = Lower(Trim(ls_value[ll_index])) Then
				gn_globals.in_string_functions.of_replace_argument(ls_name[ll_index], ls_distributioninit_new, '||', ls_null)
			End If
		Next

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the new distribution init field into the column
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.SetItem(row, "distributioninit", ls_distributioninit_new)
End Choose
end event

type st_1 from statictext within u_dynamic_gui_format_datawindow_distinit
integer x = 14
integer y = 756
integer width = 311
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Explanation"
boolean focusrectangle = false
end type

type st_2 from statictext within u_dynamic_gui_format_datawindow_distinit
integer x = 14
integer y = 8
integer width = 553
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Distribution Methods"
boolean focusrectangle = false
end type

type st_3 from statictext within u_dynamic_gui_format_datawindow_distinit
integer x = 55
integer y = 824
integer width = 1733
integer height = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The above distribution methods are available for this report.  You can specify the distribution options for this report view by clicking on the options hyperlink."
boolean focusrectangle = false
end type

type st_4 from statictext within u_dynamic_gui_format_datawindow_distinit
integer x = 55
integer y = 948
integer width = 1733
integer height = 164
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pressing Restore Defaults will restore whatever defaults were stored at the report document type and report configuration level.  Any options specified in this window will be saved with the report view."
boolean focusrectangle = false
end type

type ln_2 from line within u_dynamic_gui_format_datawindow_distinit
long linecolor = 16777215
integer linethickness = 1
integer beginx = 338
integer beginy = 784
integer endx = 1810
integer endy = 784
end type

type ln_3 from line within u_dynamic_gui_format_datawindow_distinit
long linecolor = 8421504
integer linethickness = 1
integer beginx = 338
integer beginy = 780
integer endx = 1810
integer endy = 780
end type

type ln_4 from line within u_dynamic_gui_format_datawindow_distinit
long linecolor = 16777215
integer linethickness = 1
integer beginx = 389
integer beginy = 36
integer endx = 1824
integer endy = 36
end type

type ln_5 from line within u_dynamic_gui_format_datawindow_distinit
long linecolor = 8421504
integer linethickness = 1
integer beginx = 389
integer beginy = 32
integer endx = 1824
integer endy = 32
end type

