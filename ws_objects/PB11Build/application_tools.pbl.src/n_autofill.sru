$PBExportHeader$n_autofill.sru
forward
global type n_autofill from nonvisualobject
end type
end forward

global type n_autofill from nonvisualobject
event ue_autofill ( )
end type
global n_autofill n_autofill

type variables
datawindow idw_data
boolean ib_allow_autofill
string is_search, is_previouscontents
end variables

forward prototypes
public function boolean of_itemchanged ()
public subroutine of_init (datawindow adw_data)
public subroutine of_autofill ()
public subroutine of_dwnkey ()
public subroutine of_autofill (string as_text)
end prototypes

public function boolean of_itemchanged ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_itemchanged()
// Arguments:   none
// Overview:    reject the value of the autofill if not in the drop down.
// Created by:  Jake Pratt
// History:     1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string s_dta_col, s_dsply_col, s_clr, s_clmn_nme, s_kyval, s_kytpe, ls_null
long l_dwc_rw, l_dw_rw, l_kyval, ll_null
dwitemstatus enis_rw_stat
datawindowchild dwc_tmp
boolean b_allw_edt
boolean	b_rqrd=TRUE
SetNull(ll_null)
SetNull(ls_null)


l_dw_rw=idw_data.GetRow()
enis_rw_stat=idw_data.GetItemStatus(l_dw_rw,0,PRIMARY!)

s_clmn_nme=idw_data.GetcolumnName()
s_dta_col=idw_data.Describe(s_clmn_nme+".DDDW.DataColumn")
s_dsply_col=idw_data.Describe(s_clmn_nme+".DDDW.DisplayColumn")
b_allw_edt=lower(idw_data.Describe(s_clmn_nme+".DDDW.AllowEdit"))='yes'
b_rqrd=lower(idw_data.Describe(s_clmn_nme+".DDDW.Required"))='yes'

//----------------------------------------------------------------------------------------------------------------------------------
// This if checks if the field is a dddw
//-----------------------------------------------------------------------------------------------------------------------------------
if s_dta_col<>"!" and s_dta_col<>"?" then 
	s_kytpe =idw_data.Describe(s_clmn_nme+".Coltype")
	s_kytpe=upper(s_kytpe)
	If Left(s_kytpe,4) = "CHAR" Then
		s_kytpe = Left(s_kytpe,4)
	End if
	Choose Case s_kytpe
		Case "NUMBER","LONG"  
			l_KyVal=idw_data.GetItemNumber(l_dw_rw,s_clmn_nme)
		Case "CHAR"	
			s_KyVal=idw_data.GetItemString(l_dw_rw,s_clmn_nme)
	end choose
	idw_data.GetChild(s_clmn_nme,dwc_tmp)


	//----------------------------------------------------------------------------------------------------------------------------------
	// IF the selected row is zero then the text is invalid
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_dwc_rw=dwc_tmp.GetRow()
	if dwc_tmp.GetSelectedRow(0)=0 and b_Allw_Edt then
		if b_rqrd or idw_data.gettext() > '' then
			Choose Case s_kytpe
				Case "NUMBER","LONG"
					idw_data.SetItem(l_dw_rw,s_clmn_nme,l_kyval)
				Case "CHAR"	
					idw_data.SetItem(l_dw_rw,s_clmn_nme,s_kyval)
			end choose


//SAC			idw_data.SetActionCode(2)
			return false
		Else
			Choose Case s_kytpe
				Case "NUMBER","LONG"
					idw_data.SetItem(l_dw_rw,s_clmn_nme,ll_null)

				Case "CHAR"	
					idw_data.SetItem(l_dw_rw,s_clmn_nme,ls_null)
			end choose
			idw_data.SetText(ls_null)
		End IF
	End IF
End if
	
return true
end function

public subroutine of_init (datawindow adw_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Arguments:   adw_data
// Overview:    initialize the datawindow variable
// Created by:  Jake Pratt
// History:     1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data = adw_data
end subroutine

public subroutine of_autofill ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_autofill
// Overrides:  No
// Overview:   FInd the text the user typed from the dddw and fill to end of field
// Created by: Jake Pratt
// History:    1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int				li_text_length
long				ll_dd_row
long				ll_dd_rowcount
string				ls_col
string				ls_display_col
string				ls_text
string				ls_search
string				ls_new_text
datawindowchild			ldwc_dwc
string			ls_clr


//If not ib_allow_autofill Then RETURN

ls_text = idw_data.gettext()

if ls_text = '' then
	return
end if

ls_col = idw_data.getcolumnname()
ls_display_col = idw_data.describe( ls_col + ".dddw.displaycolumn")

ls_search = "upper(left(" + ls_display_col + &
	", " + string( len( ls_text)) + ")) = upper('" + ls_text + "')"

idw_data.getchild( ls_col, ldwc_dwc)
ll_dd_rowcount = ldwc_dwc.rowcount()
ll_dd_row = ldwc_dwc.find( ls_search, 1, ll_dd_rowcount)

w_mdi_frame.title = ls_text + string(ll_dd_row)
if ll_dd_row > 0 then

	ls_clr=ldwc_dwc.Describe( ls_display_col+".color")
	if len(ls_clr)>3 then
		ls_clr=trim(mid(ls_clr,4,len(ls_clr) - 4))
		ls_clr=ldwc_dwc.describe("Evaluate(~""+ls_clr+"~","+string(ll_dd_row)+")")
	end if
	if ls_clr="255" then
		return
	end if

	li_text_length = len( idw_data.gettext())

	ls_new_text = ldwc_dwc.getitemstring( ll_dd_row, ls_display_col)
//	ls_new_text = "Evaluate('lookupdisplay(" + ls_col + ")',1)"
//	ls_new_text = idw_data.Describe(ls_new_text)
//
//	If pos(ls_new_text,",") > 0 Then
//		string s_text
//		s_text = ClipBoard()
//		ClipBoard(ls_new_text)
//		idw_data.Paste()
//		ClipBoard(s_text)
//	Else
		idw_data.Post Function settext(ls_new_text)
//	End If
		

	ldwc_dwc.setrow( ll_dd_row)
	ldwc_dwc.scrolltorow( ll_dd_row)
	ldwc_dwc.selectrow( ll_dd_row, true)

	idw_data.selecttext( len( ls_new_text) + 1, -1 * (len( ls_new_text) - li_text_length))

end if

end subroutine

public subroutine of_dwnkey ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_autofill()
// Arguments:   none
// Overview:    Call this script in the pbm_dwnkey of a dw to autofill the drop downs.
// Created by:  Jake Pratt
// History:     1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string  ls_column_name

if (not keydown( keyback!) and not keydown( keytab!) and &
	not keydown( keydownarrow!) and &
	not keydown( keycapslock!) and not keydown( keydelete!) and &
	not keydown( keyspacebar!) and not keydown( keyenter!)) then

	ls_column_name = idw_data.getcolumnname()

	if idw_data.describe( ls_column_name + ".edit.style") = "dddw" and &
		idw_data.describe( ls_column_name + ".dddw.allowedit") = "yes" then
		ib_allow_autofill = TRUE
	else
		ib_allow_autofill = FALSE
	end if
else
	ib_allow_autofill = FALSE
end if
	
end subroutine

public subroutine of_autofill (string as_text);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_autofill
// Overrides:  No
// Overview:   FInd the text the user typed from the dddw and fill to end of field
// Created by: Jake Pratt
// History:    1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int				li_text_length
long				ll_dd_row
long				ll_dd_rowcount
string				ls_col
string				ls_display_col
string				ls_text
string				ls_search
string				ls_new_text
datawindowchild			ldwc_dwc
string			ls_clr


If not ib_allow_autofill Then RETURN

ls_text = as_text

if ls_text = '' then
	return
end if

ls_col = idw_data.getcolumnname()
ls_display_col = idw_data.describe( ls_col + ".dddw.displaycolumn")

ls_search = "upper(left(" + ls_display_col + &
	", " + string( len( ls_text)) + ")) = upper('" + ls_text + "')"

idw_data.getchild( ls_col, ldwc_dwc)
ll_dd_rowcount = ldwc_dwc.rowcount()
ll_dd_row = ldwc_dwc.find( ls_search, 1, ll_dd_rowcount)

if ll_dd_row > 0 then

	ls_clr=ldwc_dwc.Describe( ls_display_col+".color")
	if len(ls_clr)>3 then
		ls_clr=trim(mid(ls_clr,4,len(ls_clr) - 4))
		ls_clr=ldwc_dwc.describe("Evaluate(~""+ls_clr+"~","+string(ll_dd_row)+")")
	end if
	if ls_clr="255" then
		return
	end if

	li_text_length = len( as_text)

	ls_new_text = ldwc_dwc.getitemstring( ll_dd_row, ls_display_col)
	idw_data.settext(ls_new_text)
	
	ldwc_dwc.setrow( ll_dd_row)
	ldwc_dwc.scrolltorow( ll_dd_row)
	ldwc_dwc.selectrow( ll_dd_row, true)

	idw_data.selecttext( len( ls_new_text) + 1, -1 * (len( ls_new_text) - li_text_length))

end if

end subroutine

on n_autofill.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_autofill.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

