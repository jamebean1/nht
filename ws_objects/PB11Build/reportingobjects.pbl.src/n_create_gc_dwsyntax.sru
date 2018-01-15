$PBExportHeader$n_create_gc_dwsyntax.sru
forward
global type n_create_gc_dwsyntax from nonvisualobject
end type
end forward

global type n_create_gc_dwsyntax from nonvisualobject autoinstantiate
end type

forward prototypes
public function string of_create_gc_dwsyntax (string as_tablename)
public subroutine of_create_single_gc (powerobject ds_gc_syntax, string as_attrtype, string as_attrname, long al_columnnumber)
end prototypes

public function string of_create_gc_dwsyntax (string as_tablename);long i_i
string s_select,s_syntax,s_error,s_type,s_columnsyntax,s_columnname,s_columntype
DataStore ds_datastore,ds_gc_syntax
//n_string_functions ln_string

//------------------------------------------------------------------------------
// Get the list of variables we need to create a dw for.
//------------------------------------------------------------------------------
ds_datastore = create datastore
ds_datastore.dataobject = 'd_create_gc_dwsyntax'
ds_datastore.settransobject(sqlca)
ds_datastore.retrieve(as_tablename)

//------------------------------------------------------------------------------
// Loop through and create the select statement.
//------------------------------------------------------------------------------
For i_i = 1 to ds_datastore.rowcount()


	s_columnname = ds_datastore.getitemstring(i_i,'GnrlCnfgQlfr') 
	
	gn_globals.in_string_functions.of_replace_all(s_columnname,' ','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'\','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'/','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,':','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,',','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'=','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'-','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'_','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'.','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'&','')
	gn_globals.in_string_functions.of_replace_all(s_columnname,'%','')
	
	ds_datastore.setitem(i_i,'gnrlcnfgqlfr',s_columnname)
	
	s_columnname = ds_datastore.getitemstring(i_i,'GnrlCnfgQlfr') + 'attribute'
	s_columntype = ds_datastore.getitemstring(i_i,'GnrlCnfgMulti')

	
	Choose Case s_columntype
		CASE 'mm/dd/yyyy','[date]','[date] [time]'
			s_select  = s_select + 'convert(datetime,"01/01/1900") ' +  s_columnname + ','
		CASE else
			
			if pos(s_columntype,'#0') > 0 then 
				s_select  = s_select + s_columnname + '=000000.000000,'
			else	
				s_select  = s_select + s_columnname + '="",'
			end if
			
	End Choose

Next

//------------------------------------------------------------------------------
// Now create a syntax that we can use to display the dataset we have created.
//------------------------------------------------------------------------------
s_select = 'Select ' + s_select + ' GnrlCnfgQlfr , editstyle = "" From GeneralConfiguration'
s_syntax = sqlca.syntaxfromsql(s_select, "", s_error)

ds_gc_syntax = create datastore
ds_gc_syntax.create(s_syntax)


//------------------------------------------------------------------------------
// Since we are going to re-create everything, destroy all of the gui.
//------------------------------------------------------------------------------
s_error = ds_gc_syntax.Modify("DataWindow.Header.Height='0'")
s_error = ds_gc_syntax.Modify("DataWindow.Detail.Height='76'")
s_error = ds_gc_syntax.Modify("destroy GnrlCnfgQlfr")
s_error = ds_gc_syntax.Modify("destroy editstyle")

For i_i = 1 to ds_datastore.rowcount()

	s_syntax = "destroy " +  ds_datastore.getitemstring(i_i,'GnrlCnfgQlfr') + 'attribute'
	s_error = ds_gc_syntax.Modify(s_syntax)

	s_syntax = "destroy " +  ds_datastore.getitemstring(i_i,'GnrlCnfgQlfr') + 'attribute_t'
	s_error = ds_gc_syntax.Modify(s_syntax)
Next

//------------------------------------------------------------------------------
// Now create the GUI Again.
//------------------------------------------------------------------------------
s_syntax = 'text(band=detail alignment="1" text=":" border="0" color="0" x="571" y="8" height="56" width="23"  name=t_1  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
s_error = ds_gc_syntax.Modify("Create " + s_syntax)

s_syntax = 'column(band=detail id=' + string(ds_datastore.rowcount() + 1) + ' alignment="1" tabsequence=32766 border="0" color="0" x="0" y="4" height="52" width="576" format="[general]" protect="0~tif(IsRowNew(),0,1)"  name=gnrlcnfgqlfr edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
s_error = ds_gc_syntax.Modify("Create " + s_syntax)

For i_i = 1 to ds_datastore.rowcount()
	
	of_create_single_gc(ds_gc_syntax,ds_datastore.getitemstring(i_i,'GnrlCnfgMulti'),ds_datastore.getitemstring(i_i,'GnrlCnfgQlfr'),i_i)
	ds_gc_syntax.modify(ds_datastore.getitemstring(i_i,'GnrlCnfgQlfr') + '.visible = "1~tif ( gnrlcnfgqlfr = ~'' +  ds_datastore.getitemstring(i_i,'GnrlCnfgQlfrOrgnl') +  '~' , 1, 0 )"')
	
Next

return ds_gc_syntax.Describe("DataWindow.Syntax")

end function

public subroutine of_create_single_gc (powerobject ds_gc_syntax, string as_attrtype, string as_attrname, long al_columnnumber);string s_syntax,s_error,s_format
n_date_manipulator ln_date_manipulator 
//n_string_functions ln_String

Choose Case as_attrtype
			
	case 'hh:mm'
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=160 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" editmask.required=yes editmask.mask="##:##"  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)
		
	case 'mm/dd/yyyy','[date]'
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=170 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" editmask.required=yes editmask.mask="[date]"  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)
		
	case '[date] [time]'
		s_format  = ln_date_manipulator.of_get_client_datetimeformat ( )
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=170 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" editmask.required=yes editmask.mask="'+ s_format + '"  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)

	case 'X', 'x'
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=90 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" edit.name="Abbreviation" edit.limit=80 edit.case=any edit.autoselect=yes edit.required=yes edit.autohscroll=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)
		
	case 'y/n', 'Y/N'
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" dddw.name=dddw_deal_yes_no dddw.displaycolumn=display dddw.datacolumn=value dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)

	case 'Term.TrmID'
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" dddw.name=dddw_trmabbrvtn dddw.displaycolumn=trmabbrvtn dddw.datacolumn=trmid dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)

	case 'BusinessAssociate.BAID'
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" dddw.name=dddw_banme dddw.displaycolumn=banme dddw.datacolumn=baid dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)

	case 'Product.PrdctID'
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" dddw.name=dddw_prdctabbv_by_prdctordr dddw.displaycolumn=prdctabbv dddw.datacolumn=prdctid dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)
		
	case 'Locale.LcleID'
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" dddw.name=dddw_lclenme dddw.displaycolumn=lclenme dddw.datacolumn=lcleid dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)

	case 'UnitOfMeasure.UOM'
		s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" dddw.name=dddw_uom dddw.displaycolumn=uomdesc dddw.datacolumn=uom dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
		s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)

		

	case else
		

		if pos(as_attrtype,'#0') > 0 then 
			s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="1" tabsequence=110 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" editmask.required=yes editmask.mask="' + as_attrtype + '"  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
			s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)
		end if


		// This section handles dynamic dddw's
		if lower(left(as_attrtype,4)) = 'dddw' then 
			
			string s_array[]
			gn_globals.in_string_functions.of_parse_string(as_attrtype,'.',s_array)
			if upperbound(s_array) = 4 then 
				s_syntax = 'column(band=detail id=' + string (al_columnnumber)  + ' alignment="0" tabsequence=60 border="5" color="0" x="613" y="8" height="52" width="635" format="[general]"  name=' + as_attrname + ' visible="0" dddw.name=' + s_array[2] + ' dddw.displaycolumn=' + s_array[3] + ' dddw.datacolumn=' + s_array[4] + ' dddw.percentwidth=100 dddw.lines=0 dddw.limit=0 dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.required=yes dddw.vscrollbar=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'
				s_error = ds_gc_syntax.dynamic Modify("Create " + s_syntax)				
			end if
			
		end if
end choose		

end subroutine

on n_create_gc_dwsyntax.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_create_gc_dwsyntax.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

