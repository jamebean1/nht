$PBExportHeader$u_cal.sru
forward
global type u_cal from userobject
end type
type dw_1 from datawindow within u_cal
end type
end forward

global type u_cal from userobject
integer width = 640
integer height = 512
long backcolor = 12632256
long tabtextcolor = 33554432
event ue_date_selected pbm_custom01
event ue_check_focus pbm_custom02
event ue_init pbm_custom03
event ue_close pbm_custom04
event ue_dteslctd pbm_custom05
dw_1 dw_1
end type
global u_cal u_cal

type variables
datawindow    idw
editmask        iem
dragobject     ido
date     id_caldate
boolean   ib_date_chosen=FALSE
Private:
  int       ii_daynum
  string   is_syn
  boolean ib_first=TRUE
  string   is_curcol
  boolean ib_focus=TRUE
  long     il_rw

Protected:
	String	is_dataobject = 'd_clndr'
end variables

forward prototypes
private subroutine uf_display_month (date ad_date)
public subroutine uf_highlight_date ()
public subroutine uf_set_date (date ad_date)
public function integer show ()
end prototypes

event ue_check_focus;if not ib_focus then
// If GetFocus() <> st_first And 	GetFocus() <> st_prior And GetFocus() <> st_next And GetFocus() <> st_last Then
		this.triggerevent( "ue_close")
//	End If
end if
	
end event

on ue_init;
dw_1.setfocus()
end on

on ue_close;
close(parent)
end on

on ue_dteslctd;
this.triggerevent( "ue_close")
end on

private subroutine uf_display_month (date ad_date);date	ld_strt
int	li_week=1, li_end
int	li_i
int	li_null
long	ll_rwcnt
string	ls_dy_strng='1~t2~t3~t4~t5~t6~t7~t8~t9~t10~t11~t12~t13~t14~t15~t16~t17~t18~t19~t20~t21~t22~t23~t24~t25~t26~t27~t28'

setpointer( hourglass!)
setnull(li_null)

ll_rwcnt = dw_1.rowcount()

ld_strt = date( year( ad_date), month(ad_date), 1)
ii_daynum = daynumber( ld_strt)

if ll_rwcnt > 0 then
	il_rw = dw_1.find( "keydte=" + string(ld_strt, "yyyy-mm-dd"), 1, ll_rwcnt)
	if il_rw > 0 then
		dw_1.scrolltorow(il_rw)
	end if
end if

if il_rw <= 0 then
//	il_rw = dw_1.insertrow(0)
//	dw_1.setitem( il_rw, "keydte", ld_strt)

	if month( ad_date) = 12 then
		li_end = 31
	else
		li_end = day( relativedate( date( year(ad_date), month(ad_date) + 1, 1), -1))
	end if

	if li_end > 28 then
		ls_dy_strng = ls_dy_strng + '~t29'
	end if

	if li_end > 29 then
		ls_dy_strng = ls_dy_strng + '~t30'
	end if

	if li_end > 30 then
		ls_dy_strng = ls_dy_strng + '~t31'
	end if

//	for li_i = 1 to (ii_daynum -1)
//		dw_1.setitem( il_rw, "d" + string( li_i), li_null)
//	next
//	
//	for li_i = 1 to li_end
//		dw_1.setitem( il_rw, "d" + string(li_i + ii_daynum - 1), li_i)
//	next
//
//	for li_i = (li_end + ii_daynum) to 42
//		dw_1.setitem( il_rw, "d" + string( li_i), li_null)
//	next

	dw_1.importstring( ls_dy_strng, 1, 1, 1, 31, ii_daynum)
	il_rw = dw_1.rowcount()
	dw_1.setitem( il_rw, "keydte", ld_strt)
	dw_1.scrolltorow( il_rw)

end if

id_caldate = ad_date

uf_highlight_date()

setpointer( arrow!)
end subroutine

public subroutine uf_highlight_date ();string	ls_original=&
	"d1.color='16777215'~t" + &
	"d2.color='16777215'~t" + &
	"d3.color='16777215'~t" + &
	"d4.color='16777215'~t" + &
	"d5.color='16777215'~t" + &
	"d6.color='16777215'~t" + &
	"d7.color='16777215'~t" + &
	"d8.color='16777215'~t" + &
	"d9.color='16777215'~t" + &
	"d10.color='16777215'~t" + &
	"d11.color='16777215'~t" + &
	"d12.color='16777215'~t" + &
	"d13.color='16777215'~t" + &
	"d14.color='16777215'~t" + &
	"d15.color='16777215'~t" + &
	"d16.color='16777215'~t" + &
	"d17.color='16777215'~t" + &
	"d18.color='16777215'~t" + &
	"d19.color='16777215'~t" + &
	"d20.color='16777215'~t" + &
	"d21.color='16777215'~t" + &
	"d22.color='16777215'~t" + &
	"d23.color='16777215'~t" + &
	"d24.color='16777215'~t" + &
	"d25.color='16777215'~t" + &
	"d26.color='16777215'~t" + &
	"d27.color='16777215'~t" + &
	"d28.color='16777215'~t" + &
	"d29.color='16777215'~t" + &
	"d30.color='16777215'~t" + &
	"d31.color='16777215'~t" + &
	"d32.color='16777215'~t" + &
	"d33.color='16777215'~t" + &
	"d34.color='16777215'~t" + &
	"d35.color='16777215'~t" + &
	"d36.color='16777215'~t" + &
	"d37.color='16777215'~t" + &
	"d38.color='16777215'~t" + &
	"d39.color='16777215'~t" + &
	"d40.color='16777215'~t" + &
	"d41.color='16777215'~t" + &
	"d42.color='16777215'~t" + &
	"d1.Font.Weight='400'~t" + &
	"d2.Font.Weight='400'~t" + &
	"d3.Font.Weight='400'~t" + &
	"d4.Font.Weight='400'~t" + &
	"d5.Font.Weight='400'~t" + &
	"d6.Font.Weight='400'~t" + &
	"d7.Font.Weight='400'~t" + &
	"d8.Font.Weight='400'~t" + &
	"d9.Font.Weight='400'~t" + &
	"d10.Font.Weight='400'~t" + &
	"d11.Font.Weight='400'~t" + &
	"d12.Font.Weight='400'~t" + &
	"d13.Font.Weight='400'~t" + &
	"d14.Font.Weight='400'~t" + &
	"d15.Font.Weight='400'~t" + &
	"d16.Font.Weight='400'~t" + &
	"d17.Font.Weight='400'~t" + &
	"d18.Font.Weight='400'~t" + &
	"d19.Font.Weight='400'~t" + &
	"d20.Font.Weight='400'~t" + &
	"d21.Font.Weight='400'~t" + &
	"d22.Font.Weight='400'~t" + &
	"d23.Font.Weight='400'~t" + &
	"d24.Font.Weight='400'~t" + &
	"d25.Font.Weight='400'~t" + &
	"d26.Font.Weight='400'~t" + &
	"d27.Font.Weight='400'~t" + &
	"d28.Font.Weight='400'~t" + &
	"d29.Font.Weight='400'~t" + &
	"d30.Font.Weight='400'~t" + &
	"d31.Font.Weight='400'~t" + &
	"d32.Font.Weight='400'~t" + &
	"d33.Font.Weight='400'~t" + &
	"d34.Font.Weight='400'~t" + &
	"d35.Font.Weight='400'~t" + &
	"d36.Font.Weight='400'~t" + &
	"d37.Font.Weight='400'~t" + &
	"d38.Font.Weight='400'~t" + &
	"d39.Font.Weight='400'~t" + &
	"d40.Font.Weight='400'~t" + &
	"d41.Font.Weight='400'~t" + &
	"d42.Font.Weight='400'"
	
String ls_return	
is_curcol = "d" + string( day( id_caldate) + ii_daynum - 1)
ls_return = dw_1.modify( ls_original + "~t" + is_curcol + ".color='255'" + '~t' + is_curcol + ".Font.Weight='700'")

end subroutine

public subroutine uf_set_date (date ad_date);
//messagebox( "Date", string( ad_date,"mm/dd/yyyy") + "~r~n" + string( id_caldate, "mm/dd/yyyy"))

id_caldate = ad_date

uf_display_month( ad_date)
end subroutine

public function integer show ();
ib_focus = TRUE

this.postevent( "ue_init")

return super::show()


end function

on u_cal.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on u_cal.destroy
destroy(this.dw_1)
end on

event constructor;If ISValid(gn_globals) Then
//	If IsValid(gn_globals.in_theme) Then
//		This.BackColor = gn_globals.in_theme.of_get_barcolor()
//		dw_1.Post Modify("Datawindow.Color = '" + String(gn_globals.in_theme.of_get_barcolor()) + "'")
//	End If
End If
end event

type dw_1 from datawindow within u_cal
event keydown pbm_dwnkey
integer width = 686
integer height = 588
integer taborder = 20
string dataobject = "d_clndr"
boolean border = false
boolean livescroll = true
end type

event keydown;  
if keydown(keyuparrow!) then
	id_caldate = relativedate( id_caldate, -7)
	uf_display_month( id_caldate)
	return 1
elseif keydown(keydownarrow!) then
	id_caldate = relativedate( id_caldate, 7)
	uf_display_month( id_caldate)
	return 1
elseif keydown(keyrightarrow!) then
	id_caldate = relativedate( id_caldate, 1)
	uf_display_month( id_caldate)
	return 1
elseif keydown(keyleftarrow!) then
	id_caldate = relativedate( id_caldate, -1)
	uf_display_month( id_caldate)
	return 1
end if


end event

on doubleclicked;//
//datawindow	ldw
//editmask		lem
//
//parent.hide()
//
//choose case typeof( ido)
//	case datawindow!
//		ldw = ido
//		ldw.settext( string( id_caldate, "mm/dd/yyyy"))
//		ldw.accepttext()
//		ldw.setfocus()
//	case editmask!
//		lem = ido
//		lem.text = string( id_caldate, "mm/dd/yyyy")
//end choose
//

this.triggerevent( clicked!)
end on

event clicked;int		li_col
int		li_day
string	ls_objct

ls_objct = this.getobjectatpointer()
ls_objct = left( ls_objct, pos( ls_objct, "~t") - 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// 12/31/2001 - RPN
// if the object that was just clicked wasn't this object, then close the popup
//-----------------------------------------------------------------------------------------------------------------------------------
if isnull(ls_objct) or ls_objct = '' then 
	Parent.TriggerEvent('ue_close')
	Return
End IF

If ls_objct > "" Then
	//-------------------------------------------------------
	// This IF clause was added to determine if the first
	// letter of the object being clicked begins with 'd', 
	// if not, then an object other the a date column was
	// clicked. 
	// The Isnull(dwo) was added to prevent a GPF whenever
	// the clicked event was triggered from the doubleclicked
	// event.  In this instance, dwo is null.
	// RPN - GPF occurred after 5.0 conversion.
	//-------------------------------------------------------

	IF Left(ls_objct,1) = 'd' and not Isnull(dwo) then
		li_col = Integer(dwo.ID)
		if li_col > 0 then
			li_day = this.getitemnumber( il_rw, li_col)
			if not isnull( li_day) then
				id_caldate = date( year( id_caldate), month( id_caldate), li_day)
				uf_highlight_date()
				ib_date_chosen = TRUE
				parent.triggerevent( "ue_dteslctd")
			end if
		end if
	else
		if ls_objct = 'keydte' then 
			id_caldate = this.getitemdate(il_rw,'keydte')
			uf_highlight_date()
			ib_date_chosen = TRUE
			parent.triggerevent( "ue_dteslctd")
		end if
	End IF
	
End If
          
end event

on losefocus;
ib_focus=FALSE
parent.postevent( "ue_check_focus")
end on

on getfocus;
ib_focus=TRUE
end on

event buttonclicked;If Not IsValid(dwo) Then Return

Choose Case Lower(Trim(dwo.Name))
	Case 'b_first'
		id_caldate = date( year( id_caldate) - 1, month(id_caldate), 1)
	Case 'b_prior'
		if month(id_caldate) = 1 then
			id_caldate = date( year( id_caldate) - 1, 12, 1)
		else
			id_caldate = date( year( id_caldate), month( id_caldate) - 1, 1)
		end if
	Case 'b_next'
		if month(id_caldate) = 12 then
			id_caldate = date( year( id_caldate) + 1, 1, 1)
		else
			id_caldate = date( year( id_caldate), month( id_caldate) + 1, 1)
		end if
	Case 'b_last'
		id_caldate = date( year( id_caldate) + 1, month(id_caldate), 1)
	Case 'b_today'
		id_caldate = Today()
		ib_date_chosen = TRUE
		parent.PostEvent("ue_dteslctd")
	Case 'b_currentmonth'
		id_caldate = date( year( Today()), Month(Today()), 1)
		ib_date_chosen = TRUE
		parent.PostEvent("ue_dteslctd")
End Choose

uf_display_month( id_caldate)
dw_1.setfocus()

end event

event constructor;This.DataObject = is_dataobject 
This.SetFocus()
end event

