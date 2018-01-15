$PBExportHeader$n_drpdwnppup_manager.sru
forward
global type n_drpdwnppup_manager from nonvisualobject
end type
type uos_drpdwnppup from structure within n_drpdwnppup_manager
end type
end forward

type uos_drpdwnppup from structure
    dragobject drgobjct
    window prnt
    string clmn
    string drpdwnppup_nme
    w_drpdwnppup drpdwnppup
    boolean glbl
end type

global type n_drpdwnppup_manager from nonvisualobject
end type
global n_drpdwnppup_manager n_drpdwnppup_manager

type variables
Protected:
int ii_max_indx
dragobject  ido_cntrl
window      iw_prnt
string         is_clmn
string         is_drpdwnppupnme
boolean     ib_mke_vsble=TRUE
boolean     ib_drpdwn_is_glbl
int             ii_pntrx, ii_pntry
string         is_objct_at_pntr
long           il_rw
userobject iuo_prnt

Private:
uos_drpdwnppup  iuos_drpdwnppup[]

end variables

forward prototypes
public subroutine hideall ()
public subroutine position_visible ()
protected function boolean uof_clckd_on_arrw (datawindow adw, string as_clmn)
protected function integer uof_get_new_indx ()
protected function boolean uof_put_crsr_in_clmn (datawindow adw, window aw_prnt, string as_clmn)
public function w_drpdwnppup uof_shw_drpdwnppup ()
protected function integer uof_find_drpdwnppup (dragobject ado, window aw_prnt, string as_clmn, string as_drpdwnppupnme, boolean ab_drpdwn_is_unque)
public subroutine uof_set_do_cntrl (dragobject ado)
public subroutine uof_set_clmn (string as_clmn)
public subroutine uof_set_mke_vsble (boolean ab_mke_vsble)
public subroutine uof_set_prnt (window aw_prnt)
public subroutine uof_set_drpdwnppupnme (string as_drpdwnppupnme)
public subroutine uof_set_drpdwn_is_glbl (boolean ab_drpdwn_is_glbl)
public subroutine uof_set_pntrx (integer ai_pntrx)
public subroutine uof_set_pntry (integer ai_pntry)
public subroutine uof_set_objct_at_pntr (string as_objct_at_pntr)
public subroutine uof_set_row (long al_row)
public subroutine uof_set_uo_prnt (userobject auo_prnt)
public function Boolean of_get_global (window aw_prnt, w_drpdwnppup aw_dropdown)
public function w_drpdwnppup open ()
public subroutine close_drpdwnppups (window aw_prnt, boolean ab_glbls)
public function boolean of_isvisible (window aw_prnt, string as_drpdwnppup, string as_column)
end prototypes

public subroutine hideall ();int	li_i

for li_i = 1 to ii_max_indx

	if isvalid( iuos_drpdwnppup[li_i].drpdwnppup) then
		iuos_drpdwnppup[li_i].drpdwnppup.visible=FALSE
	end if

next
end subroutine

public subroutine position_visible ();int	li_i

for li_i = 1 to ii_max_indx

	if isvalid( iuos_drpdwnppup[li_i].drpdwnppup) then
		if iuos_drpdwnppup[li_i].drpdwnppup.visible then
			if isvalid( iuos_drpdwnppup[li_i].prnt) then
				iuos_drpdwnppup[li_i].drpdwnppup.wf_pstn_drpdwnppup()
			end if
		end if
	end if

next
end subroutine

protected function boolean uof_clckd_on_arrw (datawindow adw, string as_clmn);
int	li_arrwx2

if not match( is_objct_at_pntr, "^" + as_clmn) then return false

li_arrwx2 = integer(adw.describe( as_clmn + ".x")) + integer(adw.describe( as_clmn + ".width"))

if ii_pntrx > li_arrwx2 - 80 and ii_pntry < li_arrwx2 then
	return true
else
	return false
end if


end function

protected function integer uof_get_new_indx ();
int	li_i=1
int	li_indx

do while li_i <= ii_max_indx and li_indx = 0

	if not isvalid( iuos_drpdwnppup[li_i].drpdwnppup) then
		li_indx = li_i
	end if

	li_i++

loop

if li_indx = 0 then
	ii_max_indx++
	li_indx = ii_max_indx
end if

return li_indx
end function

protected function boolean uof_put_crsr_in_clmn (datawindow adw, window aw_prnt, string as_clmn);long		ll_rw

//if match(is_objct_at_pntr, "^" + as_clmn) or match( is_objct_at_pntr, "^cal_" + as_clmn) then
	ll_rw = long( right( is_objct_at_pntr, len( is_objct_at_pntr) - pos( is_objct_at_pntr, "~t")))
	if ll_rw > 0 then
		adw.setrow( ll_rw)
		if adw.getrow() = ll_rw then
			adw.setcolumn( as_clmn)
			if adw.getcolumnname() = as_clmn then
				return TRUE
			end if
		end if
	end if
//end if

return FALSE
end function

public function w_drpdwnppup uof_shw_drpdwnppup ();
return w_drpdwnppup
end function

protected function integer uof_find_drpdwnppup (dragobject ado, window aw_prnt, string as_clmn, string as_drpdwnppupnme, boolean ab_drpdwn_is_unque);
int	li_i = 1
int	li_indx

do while li_i <= ii_max_indx and li_indx = 0

	if ab_drpdwn_is_unque then
		if iuos_drpdwnppup[li_i].drpdwnppup_nme = as_drpdwnppupnme and &
			isvalid( iuos_drpdwnppup[li_i].drpdwnppup) then
			li_indx = li_i
		end if
	else
		if iuos_drpdwnppup[li_i].drgobjct = ado and &
			iuos_drpdwnppup[li_i].prnt = aw_prnt and &
			iuos_drpdwnppup[li_i].clmn = as_clmn and &
			iuos_drpdwnppup[li_i].drpdwnppup_nme = as_drpdwnppupnme and &
			isvalid( iuos_drpdwnppup[li_i].drpdwnppup) then

			li_indx = li_i
		end if
	end if

	li_i++

loop

//w_frame.setmicrohelp( "found " + string( li_indx))

return li_indx
end function

public subroutine uof_set_do_cntrl (dragobject ado);ido_cntrl = ado
end subroutine

public subroutine uof_set_clmn (string as_clmn);
is_clmn = as_clmn
end subroutine

public subroutine uof_set_mke_vsble (boolean ab_mke_vsble);ib_mke_vsble = ab_mke_vsble
end subroutine

public subroutine uof_set_prnt (window aw_prnt);iw_prnt = aw_prnt
end subroutine

public subroutine uof_set_drpdwnppupnme (string as_drpdwnppupnme);is_drpdwnppupnme = as_drpdwnppupnme
end subroutine

public subroutine uof_set_drpdwn_is_glbl (boolean ab_drpdwn_is_glbl);ib_drpdwn_is_glbl = ab_drpdwn_is_glbl
end subroutine

public subroutine uof_set_pntrx (integer ai_pntrx);ii_pntrx = ai_pntrx
end subroutine

public subroutine uof_set_pntry (integer ai_pntry);ii_pntry = ai_pntry
end subroutine

public subroutine uof_set_objct_at_pntr (string as_objct_at_pntr);is_objct_at_pntr = as_objct_at_pntr
end subroutine

public subroutine uof_set_row (long al_row);il_rw = al_row
end subroutine

public subroutine uof_set_uo_prnt (userobject auo_prnt);iuo_prnt = auo_prnt
end subroutine

public function Boolean of_get_global (window aw_prnt, w_drpdwnppup aw_dropdown);Long i
Boolean lb_return
For i = 1 to upperbound(iuos_drpdwnppup)
	if iuos_drpdwnppup[i].prnt = aw_prnt and iuos_drpdwnppup[i].drpdwnppup = aw_dropdown then
		Return iuos_drpdwnppup[i].glbl
	end if
Next

Return False
end function

public function w_drpdwnppup open ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:   open()
// Arguments:   none
// Overview:    This function opens the drop down window.
// Created by:  Joel White
// History:     12/6/05 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

str_drpdwnppup_prms	lstr_prms
int	li_i
w_drpdwnppup	lw_win
datawindow	ldw
editmask		lem
boolean		lb_mke_vsble
string		ls_rtrn
boolean		lb_first_open=FALSE

hideall()

choose case typeof(ido_cntrl)
	case datawindow!
		ldw = ido_cntrl
	case editmask!
		lem = ido_cntrl
end choose

li_i = uof_find_drpdwnppup( ido_cntrl, iw_prnt, is_clmn, is_drpdwnppupnme, ib_drpdwn_is_glbl)
if  li_i > 0 then
	lw_win = iuos_drpdwnppup[li_i].drpdwnppup
	if ib_drpdwn_is_glbl then
		lstr_prms.do_cntrl = ido_cntrl
		lstr_prms.w_prnt = iw_prnt
		lstr_prms.s_clmn = is_clmn
		lstr_prms.u_prnt = iuo_prnt
		lw_win.wf_set_prms( lstr_prms)
	end if
	lw_win.wf_pstn_drpdwnppup()
else
	lb_first_open = true
	lstr_prms.do_cntrl = ido_cntrl
	lstr_prms.w_prnt = iw_prnt
	lstr_prms.s_clmn = is_clmn
	lstr_prms.u_prnt = iuo_prnt
	li_i = uof_get_new_indx()

//-----------------------------------------------------------------------------------------------------------------------------------
// Removed Reference to the frame, this enables the popup to appear on top of a response window.
//	if openwithparm( iuos_drpdwnppup[li_i].drpdwnppup, lstr_prms, is_drpdwnppupnme, w_frame) > 0 then
//-----------------------------------------------------------------------------------------------------------------------------------
if openwithparm( iuos_drpdwnppup[li_i].drpdwnppup, lstr_prms, is_drpdwnppupnme) > 0 then		
		lw_win = iuos_drpdwnppup[li_i].drpdwnppup
		iuos_drpdwnppup[li_i].drgobjct = ido_cntrl
		iuos_drpdwnppup[li_i].prnt = iw_prnt
		iuos_drpdwnppup[li_i].clmn = is_clmn
		iuos_drpdwnppup[li_i].drpdwnppup_nme = is_drpdwnppupnme
		iuos_drpdwnppup[li_i].glbl = ib_drpdwn_is_glbl
	end if
end if

lb_mke_vsble = ib_mke_vsble

//Even if they want to make the popup visible, don't allow it unless
//  the cursor can be moved to the column and the user clicked on the arrow (or
//  the column was not a dddw).
if ib_mke_vsble then
	if isvalid( ldw) then
//		ls_rtrn = ldw.describe( is_clmn + ".dddw.datacolumn")
//		if (not (ls_rtrn = "?" or ls_rtrn = "!") and & 
//			not uof_clckd_on_arrw( ldw, is_clmn)) then
//		if ls_rtrn = "?" or ls_rtrn = "!" then
//			lb_mke_vsble = FALSE
//		end if
		if not uof_put_crsr_in_clmn( ldw, iw_prnt, is_clmn) then
			lb_mke_vsble = FALSE
		end if
	end if
end if

if lb_mke_vsble and lw_win.ib_reset_on_mke_vsble and not lb_first_open then
	lw_win.triggerevent("ue_retrieve")
end if

lw_win.visible = lb_mke_vsble
if lw_win.visible then
	lw_win.setfocus()
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Call the ue_setcapture event of the popup.  This ensures that all clicked
	// events are directed to the popup.
	//-----------------------------------------------------------------------------------------------------------------------------------
	lw_win.TriggerEvent("ue_setcapture")
else
	ido_cntrl.setfocus()
end if

ib_mke_vsble = TRUE

return lw_win

end function

public subroutine close_drpdwnppups (window aw_prnt, boolean ab_glbls);
int	li_i

for li_i = 1 to ii_max_indx

	if iuos_drpdwnppup[li_i].prnt = aw_prnt and &
		isvalid( iuos_drpdwnppup[li_i].drpdwnppup) then
		if ab_glbls or not iuos_drpdwnppup[li_i].glbl then
			close( iuos_drpdwnppup[li_i].drpdwnppup)
		else
			hide( iuos_drpdwnppup[li_i].drpdwnppup)
		end if
	end if

next

end subroutine

public function boolean of_isvisible (window aw_prnt, string as_drpdwnppup, string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsVisible()
//	Arguments:  aw_prnt        - Parent window associated with DropDown window object 
//	            as_drpdwnppup  - String containing the name of DropDown window object 
//             as_column      - String containing the name of the column linked to 
//                              the DropDown window object
//	Overview:   Returns whether or not the DropDown Window Object is already visible
//	Created by:	Pat Newgent
//	History: 	2/6/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

int	li_i

for li_i = 1 to ii_max_indx

	if iuos_drpdwnppup[li_i].prnt = aw_prnt and &
		iuos_drpdwnppup[li_i].drpdwnppup_nme = as_drpdwnppup and &
		iuos_drpdwnppup[li_i].clmn = as_column then
		If IsValid(iuos_drpdwnppup[li_i].drpdwnppup) Then
			If iuos_drpdwnppup[li_i].drpdwnppup.Visible then Return True
		End If
	end if

next

return False
end function

on n_drpdwnppup_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_drpdwnppup_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

