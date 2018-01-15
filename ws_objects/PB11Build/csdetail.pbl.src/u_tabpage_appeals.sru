$PBExportHeader$u_tabpage_appeals.sru
$PBExportComments$Tab page for categorization of cases.
forward
global type u_tabpage_appeals from u_tabpg_std
end type
type st_appealdetails from statictext within u_tabpage_appeals
end type
type dw_detail from u_reference_display_datawindow within u_tabpage_appeals
end type
type st_newappeal from statictext within u_tabpage_appeals
end type
type st_newevent from statictext within u_tabpage_appeals
end type
type ln_1 from line within u_tabpage_appeals
end type
type ln_2 from line within u_tabpage_appeals
end type
type dw_header from u_reference_display_datawindow within u_tabpage_appeals
end type
type st_no_appeal from statictext within u_tabpage_appeals
end type
end forward

global type u_tabpage_appeals from u_tabpg_std
boolean visible = false
integer width = 3534
integer height = 756
string text = "Appeal"
st_appealdetails st_appealdetails
dw_detail dw_detail
st_newappeal st_newappeal
st_newevent st_newevent
ln_1 ln_1
ln_2 ln_2
dw_header dw_header
st_no_appeal st_no_appeal
end type
global u_tabpage_appeals u_tabpage_appeals

type variables
STRING						i_cCaseType

W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder

//-----------------------------------------------------------------------------------------------------------------------------------
// This is the datastore that will hold the AppealDetails for this case
//-----------------------------------------------------------------------------------------------------------------------------------
datastore	ids_appealdetails
datastore	ids_appealdefaults

long		il_appealtype

n_dao_appealheader	in_dao_header
n_dao_appealdetail	in_dao_detail

boolean		ib_locked = FALSE
w_appeal iw_appeal
end variables

forward prototypes
public function integer of_get_appealtypedefaults (integer al_appealtypeid)
public function string of_save_appeal ()
public subroutine of_init ()
public subroutine of_insert_new_event (long al_appealtypeid)
public function string of_new_appeal ()
public subroutine of_show_hide_gui_items (boolean ab_show_details)
public function boolean of_check_appeal_changes ()
public subroutine of_open_appeal ()
public subroutine of_set_locked_gui ()
public subroutine of_retrieve (string as_casenumber)
end prototypes

public function integer of_get_appealtypedefaults (integer al_appealtypeid);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  al_appealtypeid 	- This argument tells you what appeal type you are getting the defauls for
//	Overview:   This function retrieves a datastore that gets the default appeal events, date terms, etc for a specific
//					Appeal Type. It is called when there is no Appeal Detail record for a case.
//	Created by:	Joel White
//	History: 	9/1/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------



long ll_rowcount, i, ll_row, ll_appealeventid, ll_datetermid, ll_return
string ls_reminder, ls_letter
datetime ldt_now
	
ll_rowcount = ids_appealdefaults.Retrieve(al_appealtypeID)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the datastore and set the default steps based on their 
//-----------------------------------------------------------------------------------------------------------------------------------
For i = 1 to ll_rowcount
//	ll_row = dw_appealdetails.InsertRow(i)
	
	ll_appealeventID 		=		ids_appealdefaults.GetItemNumber(i, 'appealeventid')
	ll_datetermID 			= 		ids_appealdefaults.GetItemNumber(i, 'datetermID')
	ls_reminder 			= 		ids_appealdefaults.GetItemString(i, 'reminder')
	ls_letter	 			= 		ids_appealdefaults.GetItemString(i, 'letter')
	ldt_now					= 		gn_globals.in_date_manipulator.of_now()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the default values for each column in this row.
	//-----------------------------------------------------------------------------------------------------------------------------------
//	ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealeventid', ll_appealeventID)
//	ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'datetermid', ll_datetermID)
//	ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealeventstatus', 'A')
//	ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealdetaildate', ldt_now)
//	ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealdetailcreatedby', gn_globals.is_login)
//	ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealdetailreminder', ls_reminder)
//	ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealdetailletter', ls_letter)
Next 
	

Return 1
end function

public function string of_save_appeal ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function saves the Appeal information on the tab.
//	Created by:	Joel White
//	History: 	9/6/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long 		ll_return, ll_rowcount, ll_mod_count, ll_appealheaderID, i
string 	ls_error, ls_status, s_error
datetime	ldt_now

s_error = in_dao_header.of_save()
If s_error <> '' then 
	//gn_globals.in_messagebox.of_messagebox(s_error, Exclamation!, OK!, 1)
	Return ls_error
end if

ll_appealheaderID = long(in_dao_header.of_getitem(1, 'appealheaderid'))

For i = 1 to in_dao_detail.RowCount()
	in_dao_detail.of_setitem(i, 'appealheaderid', ll_appealheaderID)
Next 

s_error = in_dao_detail.of_save()
If s_error <> '' Then
	//gn_globals.in_messagebox.of_messagebox(s_error, Exclamation!, OK!, 1)
	Return ls_error
End If


Return ''
end function

public subroutine of_init ();datawindowchild ldwc_retrieve
long ll_rowcount

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the selection datawindow and the AppealDetail datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = in_dao_header.RowCount()


//-----------------------------------------------------------------------------------------------------------------------------------
// Check the rowcount of the Appeal Details datawindow. If there are no rows, default the events for this appeal type.
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_rowcount < 1 Then
	of_show_hide_gui_items(FALSE)	
Else
	of_show_hide_gui_items(TRUE)
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the drop downs (not retrieving for some strange reason)
//-----------------------------------------------------------------------------------------------------------------------------------
dw_header.GetChild('appealtype', ldwc_retrieve)
ldwc_retrieve.SetTransObject(SQLCA)
ldwc_retrieve.Retrieve()

dw_header.GetChild('datetermid', ldwc_retrieve)
ldwc_retrieve.SetTransObject(SQLCA)
ldwc_retrieve.Retrieve()

dw_detail.GetChild('appealeventid', ldwc_retrieve)
ldwc_retrieve.SetTransObject(SQLCA)
ldwc_retrieve.Retrieve()

dw_detail.GetChild('datetermid', ldwc_retrieve)
ldwc_retrieve.SetTransObject(SQLCA)
ldwc_retrieve.Retrieve()


end subroutine

public subroutine of_insert_new_event (long al_appealtypeid);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This inserts a new row in the AppealDetail datawindow and preps it for use.
//	Created by:	Joel White
//	History: 	9/6/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		ll_row, ll_appealeventID, ll_datetermID, i, ll_return
string	ls_reminder, ls_letter
datetime	ldt_now


//ll_row = dw_appealdetails.InsertRow(i)

ldt_now		= 	gn_globals.in_date_manipulator.of_now()

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the default values for each column in this row.
//-----------------------------------------------------------------------------------------------------------------------------------
//ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'casenumber', long(i_wParentWindow.i_cSelectedCase))
//ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealeventstatus', 'A')
//ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealtype', al_appealtypeID)
//ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealdetaildate', ldt_now)
//ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealdetailcreatedby', gn_globals.is_login)
//ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealdetailreminder', 'N')
//ll_return 	= 	dw_appealdetails.SetItem(ll_row, 'appealdetailletter', 'N')
end subroutine

public function string of_new_appeal ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This script sets up a new appeal for a case.
//	Created by:	Joel White
//	History: 	9/7/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_appealheaderID

//-----------------------------------------------------------------------------------------------------------------------------------
// Open the window and pass the bag
//-----------------------------------------------------------------------------------------------------------------------------------
OpenWithParm(w_appeal, i_wParentWindow.i_cSelectedCase)


of_retrieve(i_wParentWindow.i_cSelectedCase)

dw_header.Event ue_retrieve()
dw_detail.Event ue_retrieve()

Return ''
end function

public subroutine of_show_hide_gui_items (boolean ab_show_details);If ab_show_details = TRUE Then
	st_no_appeal.Visible 				= 	FALSE
	st_newappeal.Visible					=	TRUE
	st_newappeal.Text						=	'Edit this Appeal...'
	st_newappeal.BringToTop				=	 TRUE
	
	st_appealdetails.Visible			=	FALSE
	dw_header.Visible						=	TRUE
	dw_detail.Visible						=  TRUE
	ln_1.Visible							=	FALSE
	ln_2.Visible							=	FALSE
	
Else
	st_no_appeal.Visible 				= 	TRUE
	st_newappeal.Visible					=	TRUE
	st_newappeal.Text						=	'Create a new Appeal...'
	
	st_newevent.Visible					=	FALSE
	dw_header.Visible						=	FALSE
	dw_detail.Visible						=  FALSE
	st_appealdetails.Visible			=	FALSE
	ln_1.Visible							=	FALSE
	ln_2.Visible							=	FALSE
End If
end subroutine

public function boolean of_check_appeal_changes ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   Checks the appeal tab for changes
//	Created by:	Joel White
//	History: 	9/6/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

boolean	lb_changed

lb_changed = in_dao_header.of_changed()

If lb_changed = True Then Return lb_changed

lb_changed	=	in_dao_detail.of_changed()

long 	i
string	ls_test

For i = 1 to in_dao_detail.RowCount()
	If in_dao_detail.GetItemStatus(i, 0, Primary!) <> NotModified! Then
		ls_test = in_dao_detail.of_getitem(i, 'appealdetailid')
	End If

	If in_dao_detail.GetItemStatus(i, 0, Filter!) <> NotModified! Then
		ls_test = in_dao_detail.of_getitem(i, 'appealdetailid')
	End If 
	
	If in_dao_detail.GetItemStatus(i, 0, Delete!) <> NotModified! Then
		ls_test = in_dao_detail.of_getitem(i, 'appealdetailid')
	End If

Next

If lb_changed = True Then 
	Return lb_changed
Else
	Return FALSE
End If


end function

public subroutine of_open_appeal ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   Creates a bag and sets the two DAOs. Then gets the objects back from the window and sets them
//					into the datawindows again.
//	Created by:	Joel White
//	History: 	9/23/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_status, ls_id
long	ll_count, ll_id
n_bag ln_bag

If Not ib_locked Then 
	ln_bag = Create n_bag
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Open the window and pass the bag
	//-----------------------------------------------------------------------------------------------------------------------------------
	If long(i_wParentWindow.i_cSelectedCase) > 0 Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Check the status of the case. If the case is not open, then do not let them edit the appeal
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_id = string(i_wParentWindow.i_cSelectedCase)
		ll_id	= long(i_wParentWindow.i_cSelectedCase)
		
		SELECT cusfocus.case_log.case_status_id  
		INTO :ls_status  
		FROM cusfocus.case_log  
		WHERE cusfocus.case_log.case_number = :ls_id   
			  ;
			  
		  SELECT cusfocus.appealheader.appealheaderid  
    		INTO :ll_count  
    		FROM cusfocus.appealheader  
   	  WHERE cusfocus.appealheader.case_number = :ls_id   ;
	  
			  
		If ls_status <> 'O' Then
			If ll_count = 0 Then
				gn_globals.in_messagebox.of_messagebox('The case you are trying to create an appeal against is closed. You cannot create an appeal for a closed case.', Exclamation!, OK!, 1)
				Return
			Else
				If i_wParentWindow.i_bSupervisorRole = TRUE Then
					ln_bag.of_set('islocked', 'N')
				Else
					ln_bag.of_set('islocked', 'Y')
				End If
			End If
		End If

		ln_bag.of_set('casenumber', i_wParentWindow.i_cSelectedCase)
	
//		OpenWithParm(w_appeal, ln_bag)
		IF IsNull (iw_appeal) OR NOT IsValid(iw_appeal) THEN
			
			// open the window, passing a reference to this Doc Mgr.
			iw_appeal = w_appeal
			OpenWithParm(iw_appeal, ln_bag)
			
		ELSE
			// the window is already open, so bring it to the foreground and reuse it.
			iw_appeal.BringToTop = TRUE
			iw_appeal.WindowState = Normal!
		END IF		
		of_retrieve(i_wParentWindow.i_cSelectedCase)
		
		dw_header.Event ue_retrieve()
		dw_detail.Event ue_retrieve()

	Else
		gn_globals.in_messagebox.of_messagebox('Please save this case before creating an appeal.', Exclamation!, OK!, 1)
	End If
	
	Destroy ln_bag
Else
	gn_globals.in_messagebox.of_messagebox('This case is locked by another user and an appeal cannot be created or edited.', Exclamation!, OK!, 1)
End If
end subroutine

public subroutine of_set_locked_gui ();this.st_newappeal.Visible = FALSE
ib_locked = TRUE

end subroutine

public subroutine of_retrieve (string as_casenumber);long ll_appealheaderID

in_dao_header.of_retrieve(Long(as_casenumber))

If in_dao_header.RowCount() > 0 Then
	ll_appealheaderID = long(in_dao_header.of_getitem(1,'appealheaderid'))
	in_dao_detail.of_retrieve(ll_appealheaderID)
	of_show_hide_gui_items(TRUE)	
Else
	in_dao_detail.of_retrieve(-1)
	of_show_hide_gui_items(FALSE)	
End If

dw_header.of_setdao(in_dao_header)
dw_header.Event ue_retrieve()

dw_detail.of_setdao(in_dao_detail)
dw_detail.Event ue_retrieve()


end subroutine

on u_tabpage_appeals.create
int iCurrent
call super::create
this.st_appealdetails=create st_appealdetails
this.dw_detail=create dw_detail
this.st_newappeal=create st_newappeal
this.st_newevent=create st_newevent
this.ln_1=create ln_1
this.ln_2=create ln_2
this.dw_header=create dw_header
this.st_no_appeal=create st_no_appeal
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_appealdetails
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.st_newappeal
this.Control[iCurrent+4]=this.st_newevent
this.Control[iCurrent+5]=this.ln_1
this.Control[iCurrent+6]=this.ln_2
this.Control[iCurrent+7]=this.dw_header
this.Control[iCurrent+8]=this.st_no_appeal
end on

on u_tabpage_appeals.destroy
call super::destroy
destroy(this.st_appealdetails)
destroy(this.dw_detail)
destroy(this.st_newappeal)
destroy(this.st_newevent)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.dw_header)
destroy(this.st_no_appeal)
end on

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overrides:  No
//	Arguments:	
//	Overview:   This event preps the Appeals tab for user input.
//	Created by: Joel White
//	History:    8/30/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rowcount, ll_row, ll_appealtypeID, ll_appealtype, ll_return, i
long ll_appealeventID, ll_datetermID, ll_appealheaderID
string ls_reminder, ls_letter
datetime	ldt_now


//-----------------------------------------------------------------------------------------------------------------------------------
// Set the parentwindow and tabfolder variables
//-----------------------------------------------------------------------------------------------------------------------------------
i_wParentWindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder

THIS.of_SetResize (TRUE)

in_dao_header = Create n_dao_appealheader
in_dao_detail = Create n_dao_appealdetail

this.of_retrieve(i_wParentWindow.i_cSelectedCase)

SetNull(iw_appeal)

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function that sets up the datawindow for its first use.
//-----------------------------------------------------------------------------------------------------------------------------------
of_init()



end event

event destructor;call super::destructor;//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the Instance datastore for AppealDetails
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ids_appealdetails
Destroy ids_appealdefaults
Destroy in_dao_header
Destroy in_dao_detail
end event

event resize;
dw_detail.Width = this.width - 2 * dw_detail.x
dw_detail.height = this.height - dw_detail.y - 6

end event

type st_appealdetails from statictext within u_tabpage_appeals
boolean visible = false
integer x = 32
integer y = 316
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Details"
boolean focusrectangle = false
end type

type dw_detail from u_reference_display_datawindow within u_tabpage_appeals
integer x = 27
integer y = 272
integer width = 3483
integer height = 484
integer taborder = 40
string dataobject = "d_tab_gui_appealdetail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event doubleclicked;call super::doubleclicked;of_open_appeal()
end event

event itemchanged;call super::itemchanged;If dwo.type = 'column' Then
	Choose Case dwo.Name 
		Case 'datetermid'
			datetime	ldt_duedate
			
			n_appealdetail_duedate ln_duedate
			ln_duedate = Create n_appealdetail_duedate
			
			ldt_duedate = ln_duedate.of_get_due_date(long(in_dao_detail.of_getitem(1, 'datetermid')), in_dao_detail.GetItemDateTime(1, 'appealdetaildate'))
			in_dao_detail.of_setitem(1, 'duedate', ldt_duedate)
			
			dw_detail.Event ue_retrieve()
			Destroy ln_duedate
	End Choose 
End If
end event

event ue_notify;call super::ue_notify;string	ls_argument

If lower(as_message) = 'validation' Then
	ls_argument = string(aany_argument)
	this.SetColumn(ls_argument)
	this.SetFocus()
End If
end event

event ue_retrieve;call super::ue_retrieve;//???RAP for some reason .Net was zooming this in to 200%
#IF defined PBDOTNET THEN
	this.object.datawindow.zoom = 100
#END IF

end event

type st_newappeal from statictext within u_tabpage_appeals
integer x = 2853
integer y = 16
integer width = 667
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Create a New Appeal..."
boolean focusrectangle = false
end type

event clicked;of_open_appeal()
end event

type st_newevent from statictext within u_tabpage_appeals
integer x = 3118
integer y = 24
integer width = 384
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "New Event..."
boolean focusrectangle = false
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Overrides:  No
//	Arguments:	
//	Overview:   Calls the function that creates a new row and sets the default values
//	Created by: Joel White
//	History:    9/6/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

of_insert_new_event(il_appealtype)
end event

type ln_1 from line within u_tabpage_appeals
boolean visible = false
integer linethickness = 4
integer beginx = 471
integer beginy = 344
integer endx = 3451
integer endy = 344
end type

type ln_2 from line within u_tabpage_appeals
boolean visible = false
long linecolor = 16777215
integer linethickness = 4
integer beginx = 471
integer beginy = 348
integer endx = 3451
integer endy = 348
end type

type dw_header from u_reference_display_datawindow within u_tabpage_appeals
integer y = 8
integer width = 3529
integer height = 256
integer taborder = 30
string dataobject = "d_tab_gui_appealheader"
boolean border = false
end type

event doubleclicked;call super::doubleclicked;of_open_appeal()
end event

event itemchanged;call super::itemchanged;If dwo.type = 'column' Then
	Choose Case dwo.Name 
		Case 'datetermid'
			datetime	ldt_duedate
			
			n_appealdetail_duedate ln_duedate
			ln_duedate = Create n_appealdetail_duedate
			
			ldt_duedate = ln_duedate.of_get_due_date(long(in_dao_header.of_getitem(1, 'datetermid')), in_dao_header.GetItemDateTime(1, 'appealcreateddate'))
			in_dao_header.of_setitem(1, 'duedate', ldt_duedate)
			
			dw_header.Event ue_retrieve()
			Destroy ln_duedate
	End Choose 
End If
end event

event ue_notify;call super::ue_notify;string	ls_argument

If lower(as_message) = 'validation' Then
	ls_argument = string(aany_argument)
	this.SetColumn(ls_argument)
	this.SetFocus()
End If
end event

event ue_retrieve;call super::ue_retrieve;//???RAP for some reason .Net was zooming this in to 200%
#IF defined PBDOTNET THEN
	this.object.datawindow.zoom = 100
#END IF

end event

type st_no_appeal from statictext within u_tabpage_appeals
integer x = 1243
integer y = 376
integer width = 1015
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "There are no appeals on this case."
boolean focusrectangle = false
end type

