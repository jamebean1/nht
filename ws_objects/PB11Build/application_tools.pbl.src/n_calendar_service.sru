$PBExportHeader$n_calendar_service.sru
$PBExportComments$!!!Try not to use this object, it is auto-instantiate and I'm trying to phase it out.  Use n_calendar_column_service instead - BLD
forward
global type n_calendar_service from nonvisualobject
end type
end forward

global type n_calendar_service from nonvisualobject autoinstantiate
end type

type variables
datawindow idw_data 
boolean ib_month
string is_ignoredcolumns[]
integer ii_ignoredcount=0

end variables

forward prototypes
public subroutine of_init (datawindow adw_data, string as_exclude)
protected function boolean of_ignore (string as_column)
public function boolean of_is_modifiable (string as_column)
public function boolean of_open_calendar (dragobject ado_cntrl, graphicobject ago_prnt)
public subroutine of_clicked ()
public subroutine of_init (datawindow adw_data)
end prototypes

public subroutine of_init (datawindow adw_data, string as_exclude);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_init
//	Overrides:  No
//	Arguments:	
//	Overview:   set the exclude objects and init the object
//	Created by: Joel White
//	History:    7-30-2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//n_string_functions ln_string

gn_globals.in_string_functions.of_parse_string ( as_exclude, ',', is_ignoredcolumns)

ii_ignoredcount=upperbound(is_ignoredcolumns)
of_init(adw_data)


end subroutine

protected function boolean of_ignore (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_ignore
//	Overrides:  No
//	Arguments:	
//	Overview:   check if the column being processed is a ignored column or not
//	Created by: Joel White
//	History:    7-25-2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

integer li_LC

for li_LC = 1 to ii_ignoredcount
	if lower(as_column) = lower(is_ignoredcolumns[li_LC]) then
		return true
	end if
next

return false
end function

public function boolean of_is_modifiable (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_is_modifiable()
//	Arguments:  as_column 	- The column to check to see if it is modifiable
//	Overview:   This function verifies that the column is modifiable before displaying the calendar object
//	Created by:	Joel White
//	History: 	08.27.2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string	ls_describe

if NOT isvalid( idw_data) then return FALSE

ls_describe = this.idw_data.describe( as_column + '.visible~t' + as_column + '.protect~t' + as_column + '.tabsequence')

//-----------------------------------------------------------------------------------------------------------------------------------
// If visible is not 1 or protect is not 0, the column is not modifiable
//-----------------------------------------------------------------------------------------------------------------------------------
if left(ls_describe,3) <> '1~n0' then RETURN FALSE

//-----------------------------------------------------------------------------------------------------------------------------------
// If the tabsequence is 0 then the column is not modifiable
//-----------------------------------------------------------------------------------------------------------------------------------
if right(ls_describe,2) = '~n0' then RETURN FALSE

return TRUE
end function

public function boolean of_open_calendar (dragobject ado_cntrl, graphicobject ago_prnt);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   f_opn_clndr()
// Arguments:   ado_cntrl		The control for which this calendar is going to choose
//									a date
//					ago_prnt
// Overview:    This function opens a drop-down calendar,
// Created by:  
// History:
//				11/27/05	JDW	Modified to change the argument aw_prnt to ago_prnt
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
// 12/22/2005 - JDW
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

public subroutine of_clicked ();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   trigger the drop down if the user clicked on a calendar button
//	Created by: Joel White
//	History:    12-6-2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string	ls_clckd_objct, ls_objct
string	ls_col



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
			if pos(lower(idw_data.describe(ls_col + ".EditMask.Mask")),'mmm') > 0 then 
				ib_month = true
			else
				ib_month = false
			end if
//SAC			if idw_data .getcolumnname() = ls_col and idw_data .getrow() = idw_data .getclickedrow() then
			if idw_data.getcolumnname() = ls_col and idw_data.getrow() = long( mid( ls_clckd_objct, pos( ls_clckd_objct, "~t") + 1, 99999)) then
				of_open_calendar (idw_data , idw_data.getparent())
			end if
		end if
	end if
end if

end subroutine

public subroutine of_init (datawindow adw_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_init
//	Overrides:  No
//	Arguments:	
//	Overview:   initialize instances and create date buttons on dw.
//	Created by: Joel White
//	History:    7-27-2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


idw_data = adw_data
//Create date bitmaps

string ls_mod_strng
int	li_col_xoffset, li_col_yoffset
int	li_cols, li_i, ll_x_offset, ll_y_offset
string	ls_col
string	ls_col_height
string	ls_bmp
	
string	ls_bmp_create

//-----------------------------------------------------------------------------------------------------------------------------------
// Present different calendar icons based on whether or not we are using the web look and feel --BLD
//-----------------------------------------------------------------------------------------------------------------------------------
ll_x_offset = 10
ll_y_offset = 3
ls_bmp=	"create bitmap(band=detail" + &
			" pointer='Arrow!' moveable=0 resizeable=0 x='10' y='10' height='60' width='69'" + &
			" filename='Module - Object Library - Calendar Button.bmp' invert='0' " + &
			" tag='' visible='0' border='0' "

li_cols = integer( idw_data.describe( "datawindow.column.count"))

for li_i = 1 to li_cols
	ls_col = idw_data.describe( "#" + string( li_i) + ".name")
	if this.of_ignore(ls_col) then continue
	if NOT this.of_is_modifiable(ls_col) then continue
//	if idw_data.describe( ls_col + ".visible") = "1" then
		if upper(left(idw_data.describe( ls_col + ".coltype"),4)) = "DATE" then
			ls_bmp_create = ls_bmp + " name=cal_" + ls_col + ")"
			idw_data.modify( ls_bmp_create)
			li_col_xoffset = integer( idw_data.describe( ls_col + ".x")) + integer( idw_data.describe( ls_col + ".width") ) + ll_x_offset
			li_col_yoffset = integer( idw_data.describe( ls_col + ".y")) + ll_y_offset
			ls_col_height = string(integer(idw_data.describe( ls_col + ".height") ) - 5)
			idw_data.modify( "cal_" + ls_col + ".x='" + string( li_col_xoffset) + "'~tcal_" + ls_col + ".y='" + string( li_col_yoffset) + "'~tcal_" + ls_col + ".height='" + ls_col_height + "'")
			ls_mod_strng = "cal_" + ls_col + ".visible='1~tif( integer(describe(~"evaluate( ~~'~" + mid(describe( ~"" + ls_col + ".protect~") , pos( describe( ~"" + ls_col + ".protect~") , ~"~t~") + 1, len( describe( ~"" + ls_col + ".protect~") ) - pos( describe( ~"" + ls_col + ".protect~") , ~"~t~") - 1) + ~"~~' , ~" + string(getrow())+~")~"))=1,0,1)'"
			idw_data.modify( ls_mod_strng)
		end if												
//	end if
next


end subroutine

on n_calendar_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_calendar_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

