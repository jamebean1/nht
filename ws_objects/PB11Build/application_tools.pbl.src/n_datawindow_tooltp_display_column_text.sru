$PBExportHeader$n_datawindow_tooltp_display_column_text.sru
forward
global type n_datawindow_tooltp_display_column_text from nonvisualobject
end type
end forward

global type n_datawindow_tooltp_display_column_text from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
end type
global n_datawindow_tooltp_display_column_text n_datawindow_tooltp_display_column_text

type variables
//n_ToolTip_bubble 	inv_ToolTip
//integer 		ii_dwID
//string is_ColName
datawindow idw_data
//boolean ib_hassubscribed = False
//n_string_functions in_String
end variables

forward prototypes
public function integer of_init (datawindow adw_data)
public function integer of_mousemove (integer xpos, integer ypos, long row, dwobject dwo)
end prototypes

public function integer of_init (datawindow adw_data);idw_data = adw_data

return 0
end function

public function integer of_mousemove (integer xpos, integer ypos, long row, dwobject dwo);
string s_currentcolumn
string ls_columnid
string ls_text

// RAID 51913 HMD 09/03/2004 Added isvalid check
if not isvalid( idw_data ) then return 0

if row < 1 or row > idw_data.rowcount() or isnull(row) then return 0


if isvalid(w_mdi_frame) then 
	
	s_currentcolumn =  left(idw_data.getobjectatpointer(),pos(idw_data.getobjectatpointer(),'~t') - 1)

	ls_columnid = idw_data.Describe(s_currentcolumn + ".ID")
	If Not IsNumber(ls_columnid) Then Return 0
	
	
	//=----------------------------------------------------------------------------------------------------------------
	// Get the Text and determine if we should show the tooltip.
	//=----------------------------------------------------------------------------------------------------------------
	ls_Text = idw_data.Describe( "Evaluate('LookUpDisplay(#" +  ls_columnid + ") ', " + string(row) + ")")
	
	
	//w_mdi_frame.uo_taskbar.of_show_microhelp(ls_text)

	
end if

	
		


Return 0
end function

on n_datawindow_tooltp_display_column_text.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datawindow_tooltp_display_column_text.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

