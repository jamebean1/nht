$PBExportHeader$u_optional_grouping2.sru
forward
global type u_optional_grouping2 from u_container_std
end type
type dw_opt_group_mandatory from datawindow within u_optional_grouping2
end type
type dw_source_type_selection from datawindow within u_optional_grouping2
end type
type dw_optgroup_list from datawindow within u_optional_grouping2
end type
type gb_1 from groupbox within u_optional_grouping2
end type
end forward

global type u_optional_grouping2 from u_container_std
integer width = 3365
integer height = 1372
event ue_save ( )
event ue_new ( )
event ue_delete ( )
dw_opt_group_mandatory dw_opt_group_mandatory
dw_source_type_selection dw_source_type_selection
dw_optgroup_list dw_optgroup_list
gb_1 gb_1
end type
global u_optional_grouping2 u_optional_grouping2

type variables
long il_currentrow
String i_cSortColumn, i_cSortDirection
end variables

forward prototypes
public subroutine of_retrieve ()
end prototypes

event ue_save;Long ll_return

ll_return = dw_optgroup_list.Update()
If ll_return = 1 Then ll_return = dw_opt_group_mandatory.Update()

If ll_return = 1 Then
	COMMIT;
Else
	Rollback;
ENd If
end event

event ue_new();long 	ll_return, ll_key_row
string ls_maxid
Long	ll_ID
DataStore lds_nextkey


ll_return = dw_optgroup_list.InsertRow(0)

If ll_return > 0 Then

	n_update_tools ln_update_tools
	ln_update_tools = create n_update_tools
	ll_id = ln_update_tools.of_get_key('optional_grouping')
	destroy ln_update_tools

	dw_optgroup_list.SetItem(ll_return, 'optional_grouping_id', string(ll_id))
	dw_optgroup_list.SetItem(ll_return, 'optional_grouping_updated_by', OBJCA.WIN.fu_GetLogin (SQLCA))
	dw_optgroup_list.SetItem(ll_return, 'optional_grouping_updated_timestamp', Now())
	dw_optgroup_list.SetItem(ll_return, 'optional_grouping_active', 'Y')
	dw_optgroup_list.ScrollToRow(ll_return)
	dw_optgroup_list.Setcolumn('description')
End IF



end event

event ue_delete;long ll_return, ll_optgroupID, ll_count


ll_return = gn_globals.in_messagebox.of_messagebox('Are you sure you want to delete this record?', Question!, YesNoCancel!, 2)

If ll_return = 1 Then
	ll_optgroupID = long(dw_optgroup_list.GetItemString(il_currentrow, 'optional_grouping_id'))
	
	
	
	  SELECT count(*)  
    INTO :ll_count  
    FROM cusfocus.case_log  
   WHERE cusfocus.case_log.optional_grouping_id = :ll_optgroupID   
           ;

	If ll_count > 0 Then
		gn_globals.in_messagebox.of_messagebox('You cannot delete this optional grouping because it has been selected for a case.', information!, OK!, 1)		
	
	Else
		dw_optgroup_list.DeleteRow(il_currentrow)
		ll_return = dw_optgroup_list.Update()
	End If
End If
end event

public subroutine of_retrieve ();dw_optgroup_list.SetTransObject(SQLCA)
dw_source_type_selection.SetTransObject(SQLCA)
dw_opt_group_mandatory.SetTransObject(SQLCA)


dw_optgroup_list.Retrieve()

dw_source_type_selection.Retrieve()
If dw_source_type_selection.RowCount() > 0 Then
	dw_opt_group_mandatory.Retrieve(dw_source_type_selection.GetItemString(1, 'source_type'))
End If
end subroutine

on u_optional_grouping2.create
int iCurrent
call super::create
this.dw_opt_group_mandatory=create dw_opt_group_mandatory
this.dw_source_type_selection=create dw_source_type_selection
this.dw_optgroup_list=create dw_optgroup_list
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_opt_group_mandatory
this.Control[iCurrent+2]=this.dw_source_type_selection
this.Control[iCurrent+3]=this.dw_optgroup_list
this.Control[iCurrent+4]=this.gb_1
end on

on u_optional_grouping2.destroy
call super::destroy
destroy(this.dw_opt_group_mandatory)
destroy(this.dw_source_type_selection)
destroy(this.dw_optgroup_list)
destroy(this.gb_1)
end on

event pc_closequery;call super::pc_closequery;long	ll_return

If dw_optgroup_list.ModifiedCount() > 0 or dw_opt_group_mandatory.ModifiedCount() > 0 Then
	ll_return = gn_globals.in_messagebox.of_messagebox('Do You Want To Save Changes?', Question!, YesNoCancel!, 1)
End If

If ll_return = 1 Then
	this.TriggerEvent('ue_save')
ElseIf ll_return = 3 Then
	Error.i_FWError = c_fatal
End If

end event

type dw_opt_group_mandatory from datawindow within u_optional_grouping2
integer x = 1797
integer y = 740
integer width = 1403
integer height = 572
integer taborder = 30
string title = "none"
string dataobject = "d_optional_grouping_mandatory"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_source_type_selection from datawindow within u_optional_grouping2
integer x = 82
integer y = 772
integer width = 1609
integer height = 132
integer taborder = 20
string title = "none"
string dataobject = "d_source_type_selection"
boolean border = false
boolean livescroll = true
end type

event itemchanged;If row > 0 and IsValid(dwo) Then
	dw_opt_group_mandatory.Retrieve(data)
End If
end event

type dw_optgroup_list from datawindow within u_optional_grouping2
integer x = 27
integer y = 28
integer width = 3282
integer height = 584
integer taborder = 10
string title = "none"
string dataobject = "d_tm_optional_groupings"
boolean vscrollbar = true
boolean livescroll = true
end type

event rowfocuschanged;il_currentrow = currentrow
end event

event constructor;this.setrow(1)
il_currentrow = 1

end event

event clicked;BOOLEAN  l_IsShifted,  l_IsControl
STRING   l_ColumnName

//Clicked on a column header.  If there are rows and set to sort enabled, sort.
IF IsValid( dwo ) THEN
	IF dwo.Type = "text" THEN
		IF THIS.RowCount( ) > 0 THEN			
			l_ColumnName = dwo.Name
			l_ColumnName = Left( l_ColumnName, Len( l_ColumnName ) - 2 )
			
			IF IsNull( i_cSortColumn ) OR i_cSortColumn <> l_ColumnName THEN
				i_cSortDirection = "A"
			ELSE
				IF IsNull( i_cSortDirection ) OR i_cSortDirection = "D" THEN
					i_cSortDirection = "A"
				ELSE
					i_cSortDirection = "D"
				END IF
			END IF

			THIS.SetSort( l_ColumnName+" "+i_cSortDirection )
			THIS.Sort( )
			
			i_cSortColumn = l_ColumnName
		END IF
	END IF
END IF

end event

type gb_1 from groupbox within u_optional_grouping2
integer x = 27
integer y = 692
integer width = 3227
integer height = 648
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mandatory Optional Grouping"
end type

