$PBExportHeader$w_calendar_new.srw
$PBExportComments$Calendar Window Looks like a pop up calendar.
forward
global type w_calendar_new from w_drpdwnppup
end type
type uo_calendar from u_cal within w_calendar_new
end type
type str_calendar from structure within w_calendar_new
end type
end forward

type str_calendar from structure
	dragobject		do_cntrl
	window		w_prnt
	userobject		u_prnt
end type

global type w_calendar_new from w_drpdwnppup
integer width = 645
event ue_refreshtheme ( )
event ue_notify ( string as_message,  any as_arg )
uo_calendar uo_calendar
end type
global w_calendar_new w_calendar_new

type variables
Private:
	str_calendar  istr_open_cal

Protected:
	boolean ib_dctvte=False
	datetime idt_dttme_rtrn
	string is_tme_frm_em
	date       id_newdate

end variables

forward prototypes
public function string wf_get_dte_edtmsk ()
public subroutine wf_set_prms (str_drpdwnppup_prms ast_prms)
end prototypes

event ue_refreshtheme;call super::ue_refreshtheme;If ISValid(gn_globals) Then
//	If IsValid(gn_globals.in_theme) Then
//		This.BackColor = gn_globals.in_theme.of_get_barcolor()
//		uo_calendar.TriggerEvent('ue_refreshtheme')
//	End If
End If
//ido_source = istr_prms.do_cntrl


end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   This will respond to the theme change subscription
// Created by: Blake Doerr
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Choose Case Lower(as_message)
	Case 'themechange' 
		TriggerEvent('ue_refreshtheme')
End Choose
end event

public function string wf_get_dte_edtmsk ();editmask	lem
date		ld_emdate
datetime	ldt_emdatetime

lem = istr_prms.do_cntrl

choose case lem.maskdatatype

	case datemask!
		lem.getdata( ld_emdate)
	case datetimemask!
		lem.getdata( ldt_emdatetime)
		ld_emdate = date( ldt_emdatetime)
	case else
		ld_emdate = today()

end choose

if ld_emdate = 1900-01-01 then ld_emdate = today()

return string( ld_emdate)


end function

public subroutine wf_set_prms (str_drpdwnppup_prms ast_prms);integer i_return
string  ls_date
string  s_rtrn_dte
date ld_dte
datawindow	ldw
long 	ll_pos

super::wf_set_prms( ast_prms)

ido_source = ast_prms.do_cntrl

choose case ido_source.typeof()
	case datawindow!
		ldw = ido_source
		if upper(ldw.describe( ldw.getcolumnname() + ".coltype")) = "DATETIME" then
			ld_dte = date(ldw.getitemdatetime( ldw.getrow(), ldw.getcolumn()))
			idt_dttme_rtrn = ldw.getitemdatetime( ldw.getrow(), ldw.getcolumn())
			if isnull(ld_dte) or ld_dte = 1900-01-01 then ld_dte = today()
			uo_calendar.uf_set_date(ld_dte)
		elseif upper(ldw.describe( ldw.getcolumnname() + ".coltype")) = "DATE" then
			ld_dte = ldw.getitemdate( ldw.getrow(), ldw.getcolumn())
			if isnull(ld_dte) or ld_dte = 1900-01-01 then ld_dte = today()
			uo_calendar.uf_set_date(ld_dte)
		Else
			Choose case ldw.describe(ldw.getcolumnname() + ".EditMask.Mask")
				Case '##/##/####'
					ls_date = ldw.getitemstring( ldw.getrow(), ldw.getcolumn())
					ls_date = Left(ls_date, 2) + '/' + Mid(ls_date, 3, 2) + '/' + Right(ls_date, 4)
					if isnull(ls_date) or ls_date = '' then ls_date = string(today())
			
					uo_calendar.uf_set_date(date(ls_date))
				Case '##/##/#### ##:##'
					ls_date = ldw.getitemstring( ldw.getrow(), ldw.getcolumn())
					ls_date = Left(ls_date, 2) + '/' + Mid(ls_date, 3, 2) + '/' + Mid(ls_date, 5, 4)//Right(ls_date, 4)
			
					if isnull(ls_date) or ls_date = '' then ls_date = string(today()) + ' ' + string(now())
					
					ll_pos = Pos(ls_date, ' ')
					If ll_pos = 0 Then ll_pos = 11
					uo_calendar.uf_set_date(date(Left(ls_date, ll_pos - 1)))
			End Choose
		end if
			
	case editmask!
			s_rtrn_dte = wf_get_dte_edtmsk()
			uo_calendar.uf_set_date(date(s_rtrn_dte))

end choose
end subroutine

on close;call w_drpdwnppup::close;//string s_msk_type, s_dte_new, s_month, s_day, s_year,s_dte_rtrn
//integer i_pstn
//time t_tmetst
//datawindow	ldw
//editmask		lem
//
//t_tmetst = time(idt_dttme_rtrn)
//If IsNull(t_tmetst) Then t_tmetst = time(string("00:00:00"))
//
//choose case ido_source.typeof()
//	case datawindow!
//		ldw = ido_source
//		If uo_calendar.ib_date_chosen Then
//			ldw.settext( string( uo_calendar.id_caldate, "mm/dd/yyyy"))
//			ldw.accepttext()
//		End If
//	case editmask!
//		lem = ido_source
//		If ib_dctvte = False Then
//			s_msk_type = lem.Mask
//
//			CHOOSE CASE s_msk_type
//				CASE "mm/dd/yyyy hh:mm", "mm/dd/yy hh:mm"
//					lem.text = string(uo_calendar.id_caldate) +" " + is_tme_frm_em
//				CASE "mm/dd/yyyy", "mm/dd/yy"
//					lem.text = string(uo_calendar.id_caldate)
//				CASE "mm/yyyy", "mm/yy"
//					If s_msk_type = "mm/yyyy" Then 
//						lem.text = string(uo_calendar.id_caldate,"mm/yyyy")
//					Else
//						lem.text = string(uo_calendar.id_caldate,"mm/yy")
//					End If
//			END CHOOSE
//		end if
//end choose
//
//
//
end on

on w_calendar_new.create
int iCurrent
call super::create
this.uo_calendar=create uo_calendar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_calendar
end on

on w_calendar_new.destroy
call super::destroy
destroy(this.uo_calendar)
end on

event open;call super::open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Open
// Overrides:  No
// Overview:   This will subscribe to the theme change subscription
// Created by: Blake Doerr
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_subscribe(This,'ThemeChange')
End If

igo_popup = uo_calendar.dw_1
end event

type uo_calendar from u_cal within w_calendar_new
integer width = 663
integer height = 528
integer taborder = 1
end type

event ue_dteslctd;string s_msk_type, s_dte_new, s_month, s_day, s_year,s_dte_rtrn
integer i_pstn
time t_tmetst
datawindow	ldw
editmask		lem

t_tmetst = time(idt_dttme_rtrn)
If IsNull(t_tmetst) Then t_tmetst = time(string("00:00:00"))

choose case ido_source.typeof()
	case datawindow!
		ldw = ido_source
		If uo_calendar.ib_date_chosen Then
			
			s_msk_type = ldw.describe(ldw.getcolumnname() + ".EditMask.Mask")

			if s_msk_type = '[date]' or s_msk_type = 'mm/yyyy' then
				ldw.settext( string( uo_calendar.id_caldate)) 
				ldw.accepttext()
			else
				if s_msk_type = '!' or s_msk_type = '[date][time]' or s_msk_type = '[date] hh:mm:ss' then
					ldw.settext( string( datetime(uo_calendar.id_caldate,t_tmetst)))
					ldw.accepttext()
				elseif s_msk_type = 'mm/dd/yyyy hh:mm AM/PM' Then
					ldw.settext( string( datetime(uo_calendar.id_caldate,t_tmetst), s_msk_type))
					ldw.accepttext()
				Else
					long ll_return, ll_pos, ll_pos2
					string	ls_value
					string	ls_month_part, ls_day_part, ls_year_part
					
					ls_value = string( uo_calendar.id_caldate)

					ll_pos = Pos(ls_value, '/')
					ll_pos2 = Pos(ls_value, '/', ll_pos + 1)

					ls_month_part = Left(ls_value, ll_pos - 1)
					ls_day_part = Mid(ls_value, ll_pos + 1, 2)
					ls_year_part = Right(ls_value, 4)
					
					If Right(ls_day_part, 1) = '/' Then ls_day_part = Left(ls_day_part, Len(ls_day_part) - 1)
					
					If Len(ls_month_part) < 2 Then ls_month_part = '0' + ls_month_part
					If Len(ls_day_part) < 2 Then ls_day_part = '0' + ls_day_part
					
					ls_value = ls_month_part + ls_day_part + ls_year_part
					
					If s_msk_type = '##/##/#### ##:##' Then ls_value = ls_value + '0000'
					
					ll_return = ldw.settext(ls_value)
					//ldw.settext( string( datetime(uo_calendar.id_caldate,t_tmetst), s_msk_type))
					ldw.accepttext()
				end if
			end if
			
		End If
	case editmask!
		lem = ido_source
		If ib_dctvte = False Then
			s_msk_type = lem.Mask

			CHOOSE CASE s_msk_type
				CASE "mm/dd/yyyy hh:mm", "mm/dd/yy hh:mm"
					lem.text = string(uo_calendar.id_caldate) +" " + is_tme_frm_em
				CASE "mm/dd/yyyy", "mm/dd/yy"
					lem.text = string(uo_calendar.id_caldate)
				CASE "mm/yyyy", "mm/yy"
					If s_msk_type = "mm/yyyy" Then 
						lem.text = string(uo_calendar.id_caldate,"mm/yyyy")
					Else
						lem.text = string(uo_calendar.id_caldate,"mm/yy")
					End If
				CASE "mmm, yyyy"
					lem.text = string(uo_calendar.id_caldate,"mmm, yyyy")
			END CHOOSE
		end if
end choose

call super::ue_dteslctd
end event

event ue_close;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_close
//	Overrides:  No
//	Arguments:	
//	Overview:   Release the capture of the clicked event that was established
//             in the ue_SetCapture event.
//					Hide or Close the window based on the globals setting
//	Created by: Pat Newgent
//	History:    12/31/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_win32_api_calls ln_win32

//-----------------------------------------------------------------------------------------------------------------------------------
// Release the capture of the clicked event
//-----------------------------------------------------------------------------------------------------------------------------------
ln_win32 = Create n_win32_api_calls
ln_win32.ReleaseCapture()
Destroy ln_win32

//-----------------------------------------------------------------------------------------------------------------------------------
// Set focus to the object that is called the popup.
//-----------------------------------------------------------------------------------------------------------------------------------
If isvalid(istr_prms.do_cntrl) then
	istr_prms.do_cntrl.SetFocus()
	Choose Case istr_prms.do_cntrl.TypeOf()
		Case Datawindow!
			istr_prms.do_cntrl.Dynamic SetColumn(istr_prms.s_clmn)
	End Choose
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Hide or close this window based on the global setting established 
// when the window was first opened.
//-----------------------------------------------------------------------------------------------------------------------------------
if gn_globals.gnv_drpdwnppup_mngr.of_get_global(istr_prms.w_prnt, Parent) then
	parent.visible=FALSE
Else
	Close(Parent)
End IF

end event

on uo_calendar.destroy
call u_cal::destroy
end on

