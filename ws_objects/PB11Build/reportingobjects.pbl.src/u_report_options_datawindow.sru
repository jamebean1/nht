$PBExportHeader$u_report_options_datawindow.sru
forward
global type u_report_options_datawindow from userobject
end type
type dw_stuff from datawindow within u_report_options_datawindow
end type
end forward

global type u_report_options_datawindow from userobject
integer width = 2491
integer height = 1156
long backcolor = 16777215
long tabtextcolor = 33554432
long tabbackcolor = 1073741824
long picturemaskcolor = 536870912
event ue_refreshtheme ( )
dw_stuff dw_stuff
end type
global u_report_options_datawindow u_report_options_datawindow

forward prototypes
public function string of_generate_options ()
public function boolean of_fill (string as_data)
end prototypes

event ue_refreshtheme;dw_stuff.Modify("Datawindow.Color='" + String(gn_globals.in_theme.of_get_backcolor()) + "'")
This.BackColor = gn_globals.in_theme.of_get_backcolor()
end event

public function string of_generate_options ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	uf_fill
//	Arguments:  as_data - This is the current report options string from the database so we can check the right stuff!
//	Overview:   This function will check the boxes etc when it's loaded.
//	Created by:	Troy Daley
//	History: 	6/14/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String 	ls_return = '', ls_columnname, ls_value
Long 		ll_upperbound, i

ll_upperbound = Long(dw_stuff.Describe("Datawindow.Column.Count"))

For i = 1 to ll_upperbound
	ls_columnname 	= dw_stuff.Describe("#" + String(i) + '.DBName')
	ls_value			= dw_stuff.GetItemString(1, i)

	If IsNull(ls_columnname) Or Trim(ls_columnname) = '' Then Continue
	If IsNull(ls_value) Or Trim(ls_value) = '' Then Continue
	
	Choose Case Lower(Trim(ls_columnname))
		Case 'uomconversion'
			ls_columnname = 'UOM Conversion'
		Case 'currencyconversion'
			ls_columnname = 'Currency Conversion'
	End Choose

	ls_return = ls_return + ls_columnname + '=' + ls_value + '||'
Next

Return Left(ls_return, Len(ls_return) - 2)
end function

public function boolean of_fill (string as_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	uf_fill
//	Arguments:  as_data - This is the current report options string from the database so we can check the right stuff!
//	Overview:   This function will check the boxes etc when it's loaded.
//	Created by:	Troy Daley
//	History: 	6/14/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//n_string_functions ln_string_functions
string s_value[], s_option[]
long l_upperbound, i

gn_globals.in_string_functions.of_parse_arguments(as_data, "||", s_option[], s_value[])

l_upperbound = Min(UpperBound(s_option[]), UpperBound(s_value[]))

dw_stuff.Reset()
dw_stuff.InsertRow(0)

For i = 1 to l_upperbound
	Choose Case Lower(Trim(s_option[i]))
		Case 'uom conversion'
			s_option[i] = 'uomconversion'
		Case 'currency conversion'
			s_option[i] = 'currencyconversion'
	End Choose
	
	If IsNumber(dw_stuff.Describe(s_option[i] + '.ID')) Then
		dw_stuff.SetItem(1, s_option[i], Trim(s_value[i]))
	End If
Next

Return True
end function

on u_report_options_datawindow.create
this.dw_stuff=create dw_stuff
this.Control[]={this.dw_stuff}
end on

on u_report_options_datawindow.destroy
destroy(this.dw_stuff)
end on

type dw_stuff from datawindow within u_report_options_datawindow
integer width = 2496
integer height = 1160
integer taborder = 10
string title = "none"
string dataobject = "d_report_options_powerbuilderdatawindow"
boolean border = false
boolean livescroll = true
end type

