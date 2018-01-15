$PBExportHeader$n_all_service.sru
forward
global type n_all_service from nonvisualobject
end type
end forward

global type n_all_service from nonvisualobject
end type
global n_all_service n_all_service

forward prototypes
public subroutine of_insert (powerobject adw_data, string as_columns, string as_display, long ai_data)
public subroutine of_insert (powerobject adw_data, string as_columns, string as_display, string as_data)
public subroutine of_insert_all (powerobject adw_data, string as_columns)
public subroutine of_insert_none (powerobject adw_data, string as_columns)
end prototypes

public subroutine of_insert (powerobject adw_data, string as_columns, string as_display, long ai_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_insert()
// Arguments:   adw_data -  Datawindow containing dddw(s) in which to insert row.
//					 as_columns - Comma delimited string of dddw columns in the datawindow 
//					 	for which to insert row.
//					 as_display - Display string for inserted row.
//					 ai_data - Numeric data value for inserted row.
// Overview:    Inserts a row, display string, and data value into given dddw(s) for a datawindow 
// Created by: 
//-----------------------------------------------------------------------------------------------------------------------------------
long		ll_row, ll_index
string ls_columns[], ls_displaycolumnname, ls_datacolumnname
//n_string_functions ln_string
datawindowchild ldwc

gn_globals.in_string_functions.of_parse_string(as_columns, ',', ls_columns)

For ll_index = 1 to upperbound(ls_columns)
	ls_columns[ll_index] = trim(ls_columns[ll_index])
	if ls_columns[ll_index] = '' then continue
	
	ls_displaycolumnname = adw_data.Dynamic Describe(ls_columns[ll_index] + ".DDDW.DisplayColumn")
	if ls_displaycolumnname = '!' then continue 
	if ls_displaycolumnname = '?' then continue 
	
	ls_datacolumnname = adw_data.Dynamic Describe(ls_columns[ll_index] +  ".DDDW.DataColumn")
	if ls_datacolumnname = '!' then continue
	if ls_datacolumnname = '?' then continue
	
	adw_data.Dynamic GetChild(ls_columns[ll_index], ldwc)
	ll_row = ldwc.insertrow(1)
	ldwc.SetItem(ll_row, ls_displaycolumnname, as_display)
	ldwc.SetItem(ll_row, ls_datacolumnname, ai_data)
		
next
			
end subroutine

public subroutine of_insert (powerobject adw_data, string as_columns, string as_display, string as_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_insert()
// Arguments:   adw_data -  Datawindow containing dddw(s) in which to insert row.
//					 as_columns - Comma delimited string of dddw columns in the datawindow 
//					 	for which to insert row.
//					 as_display - Display string for inserted row.
//					 ai_data - Numeric data value for inserted row.
// Overview:    Inserts a row, display string, and data value into given dddw(s) for a datawindow 
// Created by:  
//-----------------------------------------------------------------------------------------------------------------------------------
long		ll_row, ll_index
string ls_columns[], ls_displaycolumnname, ls_datacolumnname
//n_string_functions ln_string
datawindowchild ldwc

gn_globals.in_string_functions.of_parse_string(as_columns, ',', ls_columns)

For ll_index = 1 to upperbound(ls_columns)
	ls_columns[ll_index] = trim(ls_columns[ll_index])
	if ls_columns[ll_index] = '' then continue
	
	ls_displaycolumnname = adw_data.Dynamic Describe(ls_columns[ll_index] + ".DDDW.DisplayColumn")
	if ls_displaycolumnname = '!' then continue 
	if ls_displaycolumnname = '?' then continue 
	
	ls_datacolumnname = adw_data.Dynamic Describe(ls_columns[ll_index] +  ".DDDW.DataColumn")
	if ls_datacolumnname = '!' then continue
	if ls_datacolumnname = '?' then continue
	
	adw_data.Dynamic getchild(ls_columns[ll_index], ldwc)
	ll_row = ldwc.insertrow(1)
	ldwc.SetItem(ll_row, ls_displaycolumnname, as_display)
	ldwc.SetItem(ll_row, ls_datacolumnname, as_data)
	ldwc.SetRow(ll_row)
next
			
end subroutine

public subroutine of_insert_all (powerobject adw_data, string as_columns);
//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_insert_all()
// Arguments:   adw_data -  Datawindow containing dddw(s) in which to insert '(All)' row.
//					 as_columns - Comma delimited string of dddw columns in the datawindow 
//					 	for which to insert '(All)' row.
// Overview:    Inserts (All) row into given dddw(s) for a datawindow.
//					 The corresponding data column is equal to 0.
// Created by:  
//-----------------------------------------------------------------------------------------------------------------------------------
this.of_insert(adw_data, as_columns, '(All)', 0)


end subroutine

public subroutine of_insert_none (powerobject adw_data, string as_columns);
//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_insert_none()
// Arguments:   adw_data -  Datawindow containing dddw(s) in which to insert '(None)' row.
//					 as_columns - Comma delimited string of dddw columns in the datawindow 
//					 	for which to insert '(None)' row.
// Overview:    Inserts (None) row into given dddw(s) for a datawindow.
//					 The corresponding data column is equal to 0.
// Created by:  
//-----------------------------------------------------------------------------------------------------------------------------------
this.of_insert(adw_data, as_columns, '(None)', 0)


			
end subroutine

on n_all_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_all_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

