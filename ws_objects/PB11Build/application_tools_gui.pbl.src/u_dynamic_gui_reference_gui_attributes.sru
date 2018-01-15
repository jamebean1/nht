$PBExportHeader$u_dynamic_gui_reference_gui_attributes.sru
forward
global type u_dynamic_gui_reference_gui_attributes from u_dynamic_gui_swap_object
end type
end forward

global type u_dynamic_gui_reference_gui_attributes from u_dynamic_gui_swap_object
end type
global u_dynamic_gui_reference_gui_attributes u_dynamic_gui_reference_gui_attributes

forward prototypes
public subroutine of_fill_dropdowns ()
public subroutine of_show_attributes ()
end prototypes

public subroutine of_fill_dropdowns ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_fill_dropdowns()
// Arguments:   datawindow to fill
// Overview:    fill all of the drop downs on teh attributes datawindow
// Created by:  Jake Pratt
// History:     12/28/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
datawindowchild dwc_temp

if ib_retrieve_attrs then
	


	//----------------------------------------------------------------------------------------------------------------------------------
	// Suppresss the message boxes on the fields that have drop downs
	//---------------------------------------------------------------------------------------------------------------------------------
	dw_selected.GetChild("gnrlcnfgcntctidbybaid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve(gn_globals.il_baid)
	
	dw_selected.GetChild("gnrlcnfgoffceidbybaid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve(gn_globals.il_baid)
	
	dw_selected.GetChild("gnrlcnfgcntctid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	dw_selected.GetChild("gnrlcnfgprdctid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	dw_selected.GetChild("gnrlcnfgoffceid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	dw_selected.GetChild("gnrlcnfglcleid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	dw_selected.GetChild("gnrlcnfgareaid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	dw_selected.GetChild("gnrlcnfgbaid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	dw_selected.GetChild("gnrlcnfgclntlid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	dw_selected.GetChild("gnrlcnfguom",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	dw_selected.GetChild("gnrlcnfgtrmid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	dw_selected.GetChild("gnrlcnfguserid",dwc_temp)
	dwc_temp.SetTransObject(SQLCA)
	dwc_temp.Retrieve()
	
	
	ib_retrieve_attrs = false

	
end if

end subroutine

public subroutine of_show_attributes ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_show_attributes()
// Arguments:   none
// Overview:    Show the attributes objects.
// Created by:  Jake Pratt
// History:     12/28/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_create_gc_dwsyntax ln_syntax
string s_syntax

s_syntax = ln_syntax.of_create_gc_dwsyntax(is_gctype)

if ib_retrieve_attrs then 
	dw_selected.create(s_syntax)
	dw_selected.settransobject(sqlca)
else
	dw_selected.reset()
end if

datawindowchild dwc_temp
string s_multi
long l_row

dw_selected.setredraw(false)




//----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the comment types and move half of them to the right datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
dw_available.settransobject(sqlca)
dw_available.retrieve(0,0,is_gctype)

//----------------------------------------------------------------------------------------------------------------------------------
// Get the remarks from the header object
//-----------------------------------------------------------------------------------------------------------------------------------
long i_i,i_y
string s_column,s_text

for i_i = 1 to dw_available.rowcount()
	s_column = dw_available.getitemstring(i_i,'gnrlcnfgqlfr') + 'attribute'
	s_text = in_dao.of_getitem(1,s_column)
	s_multi = dw_available.getitemstring(i_i,'gnrlcnfgmulti')

	if s_text <> '' then
			
		l_row = dw_selected.insertrow(0)
		
			


		dw_selected.setitem(l_row,'editstyle',s_multi)
		dw_selected.setitem(l_row,'gnrlcnfgqlfr',dw_available.getitemstring(i_i,'gnrlcnfgqlfr'))
		
		string s_columnname
		//n_string_functions ln_string
		
		s_columnname = dw_available.getitemstring(i_i,'gnrlcnfgqlfr')
		
		gn_globals.in_string_functions.of_replace_all(s_columnname,' ','')
		gn_globals.in_string_functions.of_replace_all(s_columnname,'\','')
		gn_globals.in_string_functions.of_replace_all(s_columnname,'/','')
		gn_globals.in_string_functions.of_replace_all(s_columnname,':','')
		gn_globals.in_string_functions.of_replace_all(s_columnname,',','')
		gn_globals.in_string_functions.of_replace_all(s_columnname,'=','')
		gn_globals.in_string_functions.of_replace_all(s_columnname,'-','')
		gn_globals.in_string_functions.of_replace_all(s_columnname,'_','')
		gn_globals.in_string_functions.of_replace_all(s_columnname,'.','')
		gn_globals.in_string_functions.of_replace_all(s_columnname,'%','')
		
		string ls_type
		ls_type = dw_selected.Describe(s_columnname+".Coltype")
	

		Choose Case lower(left(ls_type,4))
				
			Case 'numb','deci','long'
				dw_selected.setitem(l_row,s_columnname,dec(s_text))
			case 'date'
				//n_string_functions ln_string_functions
				dw_selected.setitem(l_row,s_columnname,gn_globals.in_string_functions.of_convert_string_to_datetime ( s_text))
			Case Else
				dw_selected.setitem(l_row,s_columnname,s_text)
		
		End Choose
		
		dw_selected.setitem(l_row,s_columnname,s_text)
		
		
	end if
next


ib_retrieve_attrs = false

dw_selected.setredraw(true)



end subroutine

on u_dynamic_gui_reference_gui_attributes.create
call super::create
end on

on u_dynamic_gui_reference_gui_attributes.destroy
call super::destroy
end on

event ue_display();call super::ue_display;//if dw_selected.rowcount() = 0 then 
	of_show_attributes()
//end if
end event

event constructor;call super::constructor;ib_multiselect = true
end event

type u_swap_remove from u_dynamic_gui_swap_object`u_swap_remove within u_dynamic_gui_reference_gui_attributes
integer x = 887
integer y = 208
integer taborder = 20
end type

event u_swap_remove::clicked;call super::clicked;long l_row
string s_value

l_row = dw_selected.getselectedrow(0)

for l_row = dw_selected.rowcount() to 1 step -1
	If dw_selected.IsSelected (l_row) then
		s_value = dw_selected.getitemstring(l_row,'gnrlcnfgqlfr')
		in_dao.of_setitem(1,s_value + 'attribute',gn_globals.is_nullstring)
		dw_selected.deleterow(l_row)
	End If
next

end event

type u_swap_add from u_dynamic_gui_swap_object`u_swap_add within u_dynamic_gui_reference_gui_attributes
integer x = 887
integer y = 96
integer taborder = 10
end type

event u_swap_add::clicked;call super::clicked;//9/16/2002 - ERW - ADDED MULTI-SELECT SUPPORT

long l_left_row,l_right_row,l_id
string s_value, s_multi

l_left_row = dw_available.getselectedrow(0)

do while l_left_row > 0 
	s_value = dw_available.getitemstring(l_left_row,'gnrlcnfgqlfr')
	s_multi = dw_available.getitemstring(l_left_row,'gnrlcnfgmulti')
	if dw_selected.find('gnrlcnfgqlfr = "' + s_value + '"',0,dw_selected.rowcount()) = 0 then
		l_right_row = dw_selected.insertrow(0)
		dw_selected.setitem(l_right_row,'gnrlcnfgqlfr',s_value)
	end if
	l_left_row = dw_available.getselectedrow(l_left_row)
loop

if l_right_row > 0 then
	dw_selected.setrow(l_right_row)
	dw_selected.scrolltorow(l_right_row)
	dw_selected.selectrow(0,false)
	dw_selected.selectrow(l_right_row,true)
end if
end event

type dw_selected from u_dynamic_gui_swap_object`dw_selected within u_dynamic_gui_reference_gui_attributes
integer x = 1221
integer height = 1112
integer taborder = 0
string dataobject = "d_dynamic_attributes"
end type

event dw_selected::itemchanged;call super::itemchanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      itemchanged
// Overrides:  No
// Overview:   set value into the dao
// Created by: Jake Pratt
// History:    06.14.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string s_column
s_column = this.getitemstring(row,'gnrlcnfgqlfr') + 'attribute'
parent.in_dao.of_setitem(1,s_column,gettext())




end event

type dw_available from u_dynamic_gui_swap_object`dw_available within u_dynamic_gui_reference_gui_attributes
integer x = 78
integer taborder = 0
string dataobject = "d_dynamic_attributes_select"
end type

