$PBExportHeader$n_reject_invalids.sru
forward
global type n_reject_invalids from nonvisualobject
end type
end forward

global type n_reject_invalids from nonvisualobject
event ue_autofill ( )
end type
global n_reject_invalids n_reject_invalids

type variables
datawindow idw_data
boolean ib_using_autofill
end variables

forward prototypes
public subroutine of_init (datawindow adw_data)
public function boolean of_itemchanged ()
end prototypes

public subroutine of_init (datawindow adw_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Arguments:   adw_data
// Overview:    initialize the datawindow variable
// Created by:  Jake Pratt
// History:     1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data = adw_data
end subroutine

public function boolean of_itemchanged ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_itemchanged()
// Arguments:   none
// Overview:    reject the value of the autofill if not in the drop down.
// Created by:  Jake Pratt
// History:     1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string s_dta_col, s_dsply_col, s_clr, s_clmn_nme, s_kyval, s_kytpe
long l_dwc_rw, l_dw_rw, l_kyval
dwitemstatus enis_rw_stat
datawindowchild dwc_tmp
boolean b_allw_edt
boolean	b_rqrd=TRUE


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


	s_clr=dwc_tmp.Describe(s_dsply_col+".color")
	if len(s_clr)>3 then
		l_dwc_rw=dwc_tmp.GetRow()
		s_clr=trim(mid(s_clr,4,len(s_clr) - 4))
		s_clr=dwc_tmp.describe("evaluate(~""+s_clr+"~","+string(l_dwc_rw)+")")
	end if
	if s_clr="255" then
		Choose Case s_kytpe
			Case "NUMBER","LONG"
				idw_data.SetItem(l_dw_rw,s_clmn_nme,l_kyval)
			Case "CHAR"	
				idw_data.SetItem(l_dw_rw,s_clmn_nme,s_kyval)
		end choose

//SAC		idw_data.SetActionCode(2)
		return false

	end if

End if
	
return true
end function

on n_reject_invalids.create
TriggerEvent( this, "constructor" )
end on

on n_reject_invalids.destroy
TriggerEvent( this, "destructor" )
end on

