$PBExportHeader$u_criteria_searchdeals.sru
$PBExportComments$This is the criteria for the search deals canvas
forward
global type u_criteria_searchdeals from u_criteria_search
end type
type cbx_1 from checkbox within u_criteria_searchdeals
end type
type r_bullet1 from rectangle within u_criteria_searchdeals
end type
type r_bullet2 from rectangle within u_criteria_searchdeals
end type
type r_bullet3 from rectangle within u_criteria_searchdeals
end type
type r_bullet4 from rectangle within u_criteria_searchdeals
end type
end forward

global type u_criteria_searchdeals from u_criteria_search
integer height = 540
cbx_1 cbx_1
r_bullet1 r_bullet1
r_bullet2 r_bullet2
r_bullet3 r_bullet3
r_bullet4 r_bullet4
end type
global u_criteria_searchdeals u_criteria_searchdeals

type variables

end variables

forward prototypes
public subroutine of_proc ()
public function boolean of_validate ()
public subroutine of_retrieve ()
public subroutine of_restore_defaults ()
end prototypes

public subroutine of_proc ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_proc
// Arguments:   
// Overview:    This will insert a row into the external datawindow
// Created by:  Blake Doerr
// History:     12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
n_all_service ln_all_service

DatawindowChild ldwc_child
Long ll_row

//----------------------------------------------------------------------------------------------------------------------------------
// Default to the first and last of month
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report_criteria.InsertRow(0)

//----------------------------------------------------------------------------------------------------------------------------------
// Insert All option into dddws and set those items to All, when in scheduling workbench alias product and locale will be reretrieved without the [All] option
//-----------------------------------------------------------------------------------------------------------------------------------
ln_all_service = create n_all_service
ln_all_service.of_insert_all(dw_report_criteria, 'al_dealtype, al_user, al_productid, al_location, al_externalbaid,al_internalbaid,al_dlhdrtmplteid')
Destroy ln_all_service

This.of_restore_defaults()
end subroutine

public function boolean of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:   of_validate
//	Arguments:  
//	Overview:   
//	Created by:	
//	History: 	03/27/2002 - EDreyer 25764, 25759 Added call to of_validate_dates()
//-----------------------------------------------------------------------------------------------------------------------------------

datetime ldt_fromdate, ldt_todate
n_messagebox ln_messagebox

if of_validate_dates() = false then
	return false
end if

ldt_fromdate 	= dw_report_criteria.GetItemDateTime(1, 'adt_fromdate')
ldt_todate 		= DateTime(Date(dw_report_criteria.GetItemDateTime(1, 'adt_todate')), Time('23:59'))


if IsNull(ldt_fromdate) or IsNull(ldt_todate) then
	ln_messagebox.of_messagebox_validation('Invalid date range.  Please enter correct date range')
	return false
end if

if ldt_fromdate > ldt_todate then
	ln_messagebox.of_messagebox_validation('The to date must be greater or equal to the from date.  Please correct one of these values')
	return false
end if 

Return True
end function

public subroutine of_retrieve ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_retrieve()
// Arguments:   
// Overview:    This will retrieve the datawindow based on the parameters selefted
// Created by:  Blake Doerr
// History:     12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//Declarations
Long	ll_dealtype, ll_userid, ll_productid, ll_localeid, ll_externalbaid,ll_dlhdrtmplteid,ll_sourceid,ll_internalbaid
datetime	ldt_fromdate, ldt_todate , ldt_createdate_from, ldt_createdate_to
String	ls_status, ls_contract, ls_contract_qualifier
dw_report_criteria.AcceptText()
//Get all the information from the datawindow
ldt_fromdate 	= dw_report_criteria.GetItemDateTime(1, 'adt_fromdate')
ldt_createdate_from = dw_report_criteria.getitemdatetime(1, 'adt_createdate_from')
ldt_createdate_to = dw_report_criteria.getitemdatetime(1, 'adt_createdate_to')
ldt_todate 		= DateTime(Date(dw_report_criteria.GetItemDateTime(1, 'adt_todate')), Time('23:59'))

ll_dealtype 		= dw_report_criteria.GetItemNumber(1, 'al_dealtype')
ll_userid			= dw_report_criteria.GetItemNumber(1, 'al_user')
ll_productid 		= dw_report_criteria.GetItemNumber(1, 'al_productid')
ll_localeid 		= dw_report_criteria.GetItemNumber(1, 'al_location')
ll_externalbaid 	= dw_report_criteria.GetItemNumber(1, 'al_externalbaid')
ll_internalbaid 	= dw_report_criteria.GetItemNumber(1, 'al_internalbaid')
ll_dlhdrtmplteid  = dw_report_criteria.GetItemNumber(1, 'al_dlhdrtmplteid')
ll_sourceid		 	= dw_report_criteria.GetItemNumber(1, 'al_sourceid')
ls_status			= dw_report_criteria.GetItemString(1, 'as_status')

If ll_dealtype			= 0	Then SetNull(ll_dealtype		)
If ll_userid			= 0	Then SetNull(ll_userid			)
If ll_productid 		= 0	Then SetNull(ll_productid		)
If ll_localeid			= 0 	Then SetNull(ll_localeid		)
If ll_externalbaid	= 0 	Then SetNull(ll_externalbaid	)
If ll_internalbaid	= 0 	Then SetNull(ll_internalbaid  )
If ll_dlhdrtmplteid	= 0 	Then SetNull(ll_dlhdrtmplteid	)
If ll_sourceid			= 0 	Then SetNull(ll_sourceid		)
If ls_status			= '0' Then SetNull(ls_status			)

ls_contract 				= trim(dw_report_criteria.getitemstring(1, 'as_contract_number'))
ls_contract_qualifier 	= dw_report_criteria.GetItemString (1, 'as_contract_qualifier')
If Len(Trim(ls_contract)) 	= 0			Then 
	SetNull(ls_contract)
Else
	Choose Case Lower(ls_contract_qualifier)
		Case	'beginswith'
			ls_contract = ls_contract + '%'
		Case	'endswith'
			ls_contract = '%' + ls_contract
		Case	'contains'
			ls_contract = '%' + ls_contract + '%'
	End Choose
End If


//Retrieve the datawindow.
dw_report.SetTransObject(SQLCA)
dw_report.Retrieve('N', ll_internalbaid,ll_dealtype, ldt_fromdate, ldt_todate, ll_userid, ll_productid, ll_localeid, ls_status, ll_externalbaid, ls_contract,ll_dlhdrtmplteid,ll_sourceid,ldt_createdate_from,ldt_createdate_to)

		
end subroutine

public subroutine of_restore_defaults ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_restore_defaults
// Arguments:   
// Overview:    This will restore Defaults
// Created by:  Blake Doerr
// History:     12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
datetime ldt_null
setnull(ldt_null)

n_date_manipulator ln_date_manipulator
dw_report_criteria.SetItem(1, 'adt_fromdate', ln_date_manipulator.of_get_first_of_month(Today()))
dw_report_criteria.SetItem(1, 'adt_todate', 	ln_date_manipulator.of_get_last_of_month(Today()))
dw_report_criteria.SetItem(1, 'adt_createdate_from', ldt_null)
dw_report_criteria.SetItem(1, 'adt_createdate_to',ldt_null)
dw_report_criteria.SetItem(1, 'al_dealtype', 				0)
dw_report_criteria.SetItem(1, 'al_user', 						0)
dw_report_criteria.SetItem(1, 'al_productid', 				0)
dw_report_criteria.SetItem(1, 'al_location', 				0)
dw_report_criteria.SetItem(1, 'al_externalbaid', 			0)
dw_report_criteria.SetItem(1, 'al_internalbaid', 			0)
dw_report_criteria.SetItem(1, 'as_status', 					'0')
dw_report_criteria.setitem(1, "as_contract_qualifier", 	'equals') 
dw_report_criteria.setitem(1, "as_contract_number", 		'')
dw_report_criteria.SetItem(1, 'al_dlhdrtmplteid', 				0)

end subroutine

on u_criteria_searchdeals.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.r_bullet1=create r_bullet1
this.r_bullet2=create r_bullet2
this.r_bullet3=create r_bullet3
this.r_bullet4=create r_bullet4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.r_bullet1
this.Control[iCurrent+3]=this.r_bullet2
this.Control[iCurrent+4]=this.r_bullet3
this.Control[iCurrent+5]=this.r_bullet4
end on

on u_criteria_searchdeals.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.r_bullet1)
destroy(this.r_bullet2)
destroy(this.r_bullet3)
destroy(this.r_bullet4)
end on

type sle_customtitle from u_criteria_search`sle_customtitle within u_criteria_searchdeals
integer taborder = 20
end type

type dw_dynamic_criteria from u_criteria_search`dw_dynamic_criteria within u_criteria_searchdeals
end type

type st_criteria_dynamic from u_criteria_search`st_criteria_dynamic within u_criteria_searchdeals
end type

type st_criteria_basic from u_criteria_search`st_criteria_basic within u_criteria_searchdeals
end type

type st_tab_filler from u_criteria_search`st_tab_filler within u_criteria_searchdeals
end type

type dw_report_criteria from u_criteria_search`dw_report_criteria within u_criteria_searchdeals
integer width = 3278
integer height = 504
integer taborder = 10
string dataobject = "d_criteria_search_contract"
end type

type cbx_1 from checkbox within u_criteria_searchdeals
boolean visible = false
integer x = 1737
integer y = 292
integer width = 498
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Recurse Locations: "
boolean lefttext = true
end type

type r_bullet1 from rectangle within u_criteria_searchdeals
boolean visible = false
long linecolor = 16777215
integer linethickness = 5
integer x = 14
integer y = 32
integer width = 46
integer height = 20
end type

type r_bullet2 from rectangle within u_criteria_searchdeals
boolean visible = false
long linecolor = 16777215
integer linethickness = 5
integer x = 14
integer y = 120
integer width = 46
integer height = 20
end type

type r_bullet3 from rectangle within u_criteria_searchdeals
boolean visible = false
long linecolor = 16777215
integer linethickness = 5
integer x = 14
integer y = 208
integer width = 46
integer height = 20
end type

type r_bullet4 from rectangle within u_criteria_searchdeals
boolean visible = false
long linecolor = 16777215
integer linethickness = 5
integer x = 14
integer y = 296
integer width = 46
integer height = 20
end type

