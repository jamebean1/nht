$PBExportHeader$n_calendar_column_service.sru
forward
global type n_calendar_column_service from nonvisualobject
end type
end forward

global type n_calendar_column_service from nonvisualobject
event ue_notify ( string as_argument,  any aany_arg )
end type
global n_calendar_column_service n_calendar_column_service

type variables
datawindow idw_data 
boolean ib_month
string is_ignoredcolumns[]
integer ii_ignoredcount=0
string is_calendarobjects[]
boolean ib_hassubscribed = False
end variables

forward prototypes
protected function boolean of_ignore (string as_column)
public subroutine of_destroy_objects ()
public function boolean of_open_calendar (dragobject ado_cntrl, graphicobject ago_prnt)
public subroutine of_reinitialize ()
public subroutine of_clicked ()
public subroutine of_init (datawindow adw_data, string as_exclude)
public subroutine of_init (datawindow adw_data)
end prototypes

event ue_notify(string as_argument, any aany_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   This will respond to the theme change subscription
// Created by: Blake Doerr
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Choose Case Lower(as_argument)
	Case 'after view restored'//, 'visible columns changed'
		This.of_reinitialize()		
	Case	'before view saved', 'before view restored'
		This.of_destroy_objects()
End Choose
end event

protected function boolean of_ignore (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_ignore
//	Overrides:  No
//	Arguments:	
//	Overview:   check if the column being processed is a ignored column or not
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

integer li_LC

for li_LC = 1 to ii_ignoredcount
	if lower(as_column) = lower(is_ignoredcolumns[li_LC]) then
		return true
	end if
next

return false
end function

public subroutine of_destroy_objects ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_destroy_objects()
//	Arguments:  None.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	08/24/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_upperbound

If Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy all calendar objects.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = UpperBound(is_calendarobjects)
For ll_index = 1 To ll_upperbound
	idw_data.Modify('Destroy ' + is_calendarobjects[ll_index])
Next

end subroutine

public function boolean of_open_calendar (dragobject ado_cntrl, graphicobject ago_prnt);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   f_opn_clndr()
// Arguments:   ado_cntrl		The control for which this calendar is going to choose
//									a date
//					ago_prnt
// Overview:    This function opens a drop-down calendar,
// Created by:  
// History:
//				2/27/98	SAC	Modified to change the argument aw_prnt to ago_prnt
//									to handle opening a drop down calendar on a user
//									object.
//-----------------------------------------------------------------------------------------------------------------------------------


datawindow		ldw
string			ls_clmn
graphicobject lgo_parent

window	lw_win
userobject	uo_object


choose case ago_prnt.typeof()
	case window!
		lw_win = ago_prnt
	case userobject!
		uo_object = ago_prnt

		lgo_parent = uo_object.getparent()
		DO WHILE lgo_parent.TypeOf() <> Window!	
			lgo_parent = lgo_parent.GetParent()
		LOOP

		lw_win = lgo_parent
end choose




if ado_cntrl.typeof() = datawindow! then
	ldw = ado_cntrl
	ls_clmn = ldw.getcolumnname()
	gn_globals.gnv_drpdwnppup_mngr.uof_set_pntrx(lw_win.pointerx())
	gn_globals.gnv_drpdwnppup_mngr.uof_set_pntry(lw_win.pointery())


//SAC	gn_globals.gnv_drpdwnppup_mngr.uof_set_objct_at_pntr( ls_clmn + "~t" + string( ldw.getclickedrow()))
	string	s_object
	s_object = ldw.getobjectatpointer()
	gn_globals.gnv_drpdwnppup_mngr.uof_set_objct_at_pntr( ls_clmn + "~t" + mid( s_object, pos(s_object, "~t") + 1, 99999))

end if


gn_globals.gnv_drpdwnppup_mngr.uof_set_do_cntrl( ado_cntrl)
gn_globals.gnv_drpdwnppup_mngr.uof_set_prnt( lw_win)
gn_globals.gnv_drpdwnppup_mngr.uof_set_clmn( ls_clmn)
if ib_month then
	gn_globals.gnv_drpdwnppup_mngr.uof_set_drpdwnppupnme( "w_calendar_month")
else
	gn_globals.gnv_drpdwnppup_mngr.uof_set_drpdwnppupnme( "w_calendar_new")
end if
gn_globals.gnv_drpdwnppup_mngr.uof_set_mke_vsble( TRUE)

//-----------------------------------------------------------------------------------------------------------------------------------
// 12/31/2001 - RPN
// Response windows cannot share the dropdown, this is because the dropdowns parent window
// is established when it is first open.  For Response windows, that parent window needs to
// be the response window itself, and not the frame.
//-----------------------------------------------------------------------------------------------------------------------------------
if lw_win.WindowType = Response! then
	gn_globals.gnv_drpdwnppup_mngr.uof_set_drpdwn_is_glbl( False)
Else
	gn_globals.gnv_drpdwnppup_mngr.uof_set_drpdwn_is_glbl( TRUE)
End if

gn_globals.gnv_drpdwnppup_mngr.uof_set_uo_prnt( uo_object)


gn_globals.gnv_drpdwnppup_mngr.open()

return TRUE


end function

public subroutine of_reinitialize ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_reinitialize()
//	Arguments:  None
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	08/24/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Re-initialize.
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_init(idw_data)

end subroutine

public subroutine of_clicked ();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   trigger the drop down if the user clicked on a calendar button
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string	ls_clckd_objct, ls_objct
string	ls_col
String	ls_editmask



ls_clckd_objct = idw_data .getobjectatpointer()
ls_objct = left( ls_clckd_objct, pos( ls_clckd_objct, "~t") - 1)

if left( ls_objct, 4) = "cal_" then
	ls_col = right(ls_objct, len( ls_objct) - 4)
	if idw_data .setcolumn( ls_col ) = 1 then
		
		if idw_data.setrow(idw_data.getrow()) = 1 then

			/* The following code is necessary to verify that the current row and column
				are correct.  For some unknown reason the above logic may return a 1 for
				setrow and setcolumn even when the current row and column has not changed.
			*/
			ls_editmask = Lower(idw_data.describe(ls_col + ".EditMask.Mask"))
			if pos(ls_editmask, 'd') > 0 Or Pos(ls_editmask, 'y') <= 0 then 
				ib_month = False
			else
				ib_month = True
			end if
//SAC			if idw_data .getcolumnname() = ls_col and idw_data .getrow() = idw_data .getclickedrow() then
			if idw_data.getcolumnname() = ls_col and idw_data.getrow() = long( mid( ls_clckd_objct, pos( ls_clckd_objct, "~t") + 1, 99999)) then
				of_open_calendar (idw_data , idw_data.getparent())
			end if
		end if
	end if
end if

end subroutine

public subroutine of_init (datawindow adw_data, string as_exclude);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_init
//	Overrides:  No
//	Arguments:	
//	Overview:   set the exclude objects and init the object
//	Created by: JDW
//	History:    7-27-2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//n_string_functions ln_string

gn_globals.in_string_functions.of_parse_string ( as_exclude, ',', is_ignoredcolumns)

ii_ignoredcount=upperbound(is_ignoredcolumns)
of_init(adw_data)


end subroutine

public subroutine of_init (datawindow adw_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_init
//	Overrides:  No
//	Arguments:	
//	Overview:   initialize instances and create date buttons on dw.
//	Created by: Joel White
//	History:    12-5-2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//n_string_functions ln_string_functions
idw_data = adw_data
n_datawindow_tools ln_datawindow_tools
//Create date bitmaps

string ls_mod_strng, ls_expression, ls_specialexpressions
Long		li_col_xoffset, li_col_yoffset
Long		li_cols, li_i, ll_x_offset, ll_y_offset
Long		ll_column_x
long		ll_header_x
string	ls_col
string	ls_col_height
string	ls_bmp
string	ls_bmp_create
string	ls_null[]

is_calendarobjects[] = ls_null[]

If Not ib_hassubscribed Then
	ib_hassubscribed = True
	gn_globals.in_subscription_service.of_subscribe(This, 'Before View Saved', idw_data)
	gn_globals.in_subscription_service.of_subscribe(This, 'Before View Restored', idw_data)
	gn_globals.in_subscription_service.of_subscribe(This, 'After View Restored', idw_data)
//	gn_globals.in_subscription_service.of_subscribe(This, 'Visible Columns Changed', idw_data)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Present different calendar icons based on whether or not we are using the web look and feel --BLD
//-----------------------------------------------------------------------------------------------------------------------------------
ll_x_offset = 10
ll_y_offset = 3
ls_bmp=	"create bitmap(band=detail" + &
			" pointer='Arrow!' moveable=0 resizeable=0 x='10000' y='10' height='60' width='69'" + &
			" filename='Module - Object Library - Calendar Button.bmp' invert='0' " + &
			" tag='' visible='1' border='0' "

li_cols = integer( idw_data.describe( "datawindow.column.count"))

for li_i = 1 to li_cols
	ls_col = idw_data.describe( "#" + string( li_i) + ".name")
	
	if upper(left(idw_data.describe( ls_col + ".coltype"),4)) <> "DATE" then Continue
	if this.of_ignore(ls_col) then continue
	if idw_data.describe( ls_col + ".tabsequence") = "0" then Continue
	
	ls_bmp_create = ls_bmp + " name=cal_" + ls_col + ")"
	
	is_calendarobjects[UpperBound(is_calendarobjects) + 1] 	= 'cal_' + ls_col
	
	idw_data.modify( ls_bmp_create)
	li_col_xoffset = integer( idw_data.describe( ls_col + ".x")) + integer( idw_data.describe( ls_col + ".width") ) + ll_x_offset
	li_col_yoffset = integer( idw_data.describe( ls_col + ".y")) + ll_y_offset
	ls_col_height = string(integer(idw_data.describe( ls_col + ".height") ) - 5)
	idw_data.modify( "cal_" + ls_col + ".x='" + string( li_col_xoffset) + "'~tcal_" + ls_col + ".y='" + string( li_col_yoffset) + "'~tcal_" + ls_col + ".height='" + ls_col_height + "'")	

	ll_header_x = Long(idw_data.describe(ls_col + '_srt.x'))
	ll_column_x = Long(idw_data.describe(ls_col + '.x'))
	If IsNull(ll_header_x) Or ll_header_x <= 0 Then ll_header_x = Long(idw_data.describe(ls_col + '_t.x'))
	If Not IsNull(ll_header_x) And ll_header_x > 0 And ll_header_x = ll_column_x Then
		
		ln_datawindow_tools = Create n_datawindow_tools
		
		idw_data.modify(ls_col + '.Tag=~'width = Long(Describe(~"' + ls_col + '_srt.Width~")) - 69 - ' + String(ll_x_offset) + '~'')		
		idw_data.modify('cal_' + ls_col + '.Tag=~'x = ' + 'Long(Describe(~"' + ls_col + '_srt.X~")) + Long(Describe(~"' + ls_col + '_srt.Width~")) - 69~'')		
		
		ls_expression = Lower(ln_datawindow_tools.of_get_expression(idw_data, 'expressioninit'))
		If IsNull(ls_expression) Then 
			ls_expression = 'expressionobjects=cal_' + ls_col + ',' + ls_col
		Else
			ls_specialexpressions = Trim(gn_globals.in_string_functions.of_find_argument(ls_expression, '||', 'expressionobjects'))
			If Pos(ls_specialexpressions, ls_col) = 0 			Then ls_specialexpressions = ls_specialexpressions + ',' + ls_col
			If Pos(ls_specialexpressions, 'cal_' + ls_col) = 0 Then ls_specialexpressions = ls_specialexpressions + ',cal_' + ls_col
			
			gn_globals.in_string_functions.of_replace_argument('expressionobjects', ls_expression, '||', ls_specialexpressions)
		End If
		
		ln_datawindow_tools.of_set_expression(idw_data, 'expressioninit', ls_expression)
		Destroy ln_datawindow_tools

	End If
	
	ls_mod_strng = "cal_" + ls_col + ".protect=" + 	idw_data.describe( ls_col + ".protect")
	idw_data.modify( ls_mod_strng)
	ls_mod_strng = "cal_" + ls_col + ".visible=" + 	idw_data.describe( ls_col + ".visible")
	idw_data.modify( ls_mod_strng)		

next


end subroutine

on n_calendar_column_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_calendar_column_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;This.of_destroy_objects()
end event

