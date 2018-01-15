$PBExportHeader$w_summary_popup.srw
forward
global type w_summary_popup from w_response
end type
type cb_retrieve from commandbutton within w_summary_popup
end type
type st_2 from statictext within w_summary_popup
end type
type dw_users from datawindow within w_summary_popup
end type
type st_1 from statictext within w_summary_popup
end type
type dw_appeal_breakdown from datawindow within w_summary_popup
end type
type dw_inbox from datawindow within w_summary_popup
end type
type cb_close from commandbutton within w_summary_popup
end type
type dw_summary from datawindow within w_summary_popup
end type
type dw_oldest_appeal from datawindow within w_summary_popup
end type
type dw_oldest_case from datawindow within w_summary_popup
end type
type dw_appeal_drilldown from datawindow within w_summary_popup
end type
type dw_case_drilldown from datawindow within w_summary_popup
end type
type dw_reminders_breakdown from datawindow within w_summary_popup
end type
type dw_reminders_drilldown from datawindow within w_summary_popup
end type
end forward

global type w_summary_popup from w_response
integer width = 4448
integer height = 2272
string title = "Work Summary Report"
windowanimationstyle openanimation = centeranimation!
windowanimationstyle closeanimation = centeranimation!
cb_retrieve cb_retrieve
st_2 st_2
dw_users dw_users
st_1 st_1
dw_appeal_breakdown dw_appeal_breakdown
dw_inbox dw_inbox
cb_close cb_close
dw_summary dw_summary
dw_oldest_appeal dw_oldest_appeal
dw_oldest_case dw_oldest_case
dw_appeal_drilldown dw_appeal_drilldown
dw_case_drilldown dw_case_drilldown
dw_reminders_breakdown dw_reminders_breakdown
dw_reminders_drilldown dw_reminders_drilldown
end type
global w_summary_popup w_summary_popup

type variables
String i_cSupervisorRole
Boolean i_bSupervisorRole
string is_users[]
string is_current_user
end variables

forward prototypes
public function integer of_retrieve (string as_user)
public function integer of_select_dept (string as_dept)
public function integer of_retrieve_users ()
end prototypes

public function integer of_retrieve (string as_user);dw_summary.Retrieve(as_user, is_current_user)
dw_inbox.Retrieve(as_user, is_current_user)
dw_oldest_case.Retrieve(as_user, is_current_user)
dw_appeal_breakdown.Retrieve(as_user, is_current_user)
dw_oldest_appeal.Retrieve(as_user, is_current_user)
dw_reminders_breakdown.Retrieve(as_user)
return 0
end function

public function integer of_select_dept (string as_dept);String ls_dept
int li_rowcount, li_count

li_rowcount = dw_users.RowCount()

FOR li_count = 1 to li_rowcount
	ls_dept = dw_users.Object.cusfocus_user_dept_dept_desc[li_count]
	IF ls_dept = as_dept THEN
		IF dw_users.IsSelected(li_count) THEN
			dw_users.SelectRow(li_count, FALSE)
		ELSE
			dw_users.SelectRow(li_count, TRUE)
		END IF
	END IF
NEXT

return 0
end function

public function integer of_retrieve_users ();int li_return

li_return = dw_summary.Retrieve(is_users, is_current_user)
dw_inbox.Retrieve(is_users, is_current_user)
dw_oldest_case.Retrieve(is_users, is_current_user)
dw_appeal_breakdown.Retrieve(is_users, is_current_user)
dw_oldest_appeal.Retrieve(is_users, is_current_user)
dw_reminders_breakdown.Retrieve(is_users)
return 0
end function

event open;call super::open;STRING       l_cRoleName[]
INT          l_nNumOfRoles, l_nCounter
LONG         l_nRoleKey[]
STRING ls_enable_summary_user_selection

is_users[1] = gn_globals.is_login
is_current_user = gn_globals.is_login

dw_summary.SetTransObject(SQLCA)
dw_inbox.SetTransObject(SQLCA)
dw_oldest_case.SetTransObject(SQLCA)
dw_appeal_breakdown.SetTransObject(SQLCA)
dw_oldest_appeal.SetTransObject(SQLCA)
dw_reminders_breakdown.SetTransObject(SQLCA)
dw_case_drilldown.SetTransObject(SQLCA)
dw_appeal_drilldown.SetTransObject(SQLCA)
dw_reminders_drilldown.SetTransObject(SQLCA)

SELECT cusfocus.cusfocus_user.summary_user_selection
INTO :ls_enable_summary_user_selection
FROM cusfocus.cusfocus_user
WHERE user_id = :is_users[1]
USING SQLCA;

IF ls_enable_summary_user_selection = 'Y' THEN
	i_bSupervisorRole = TRUE
ELSE
	i_bSupervisorRole = FALSE
END IF

// If supervisor, allow them to look at data for other users
IF i_bSupervisorRole THEN
	dw_users.SetTransObject(SQLCA)
	dw_users.Retrieve()
	THIS.width = 4440
ELSE
	THIS.width = 3397
END IF
of_retrieve_users()

end event

on w_summary_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.st_2=create st_2
this.dw_users=create dw_users
this.st_1=create st_1
this.dw_appeal_breakdown=create dw_appeal_breakdown
this.dw_inbox=create dw_inbox
this.cb_close=create cb_close
this.dw_summary=create dw_summary
this.dw_oldest_appeal=create dw_oldest_appeal
this.dw_oldest_case=create dw_oldest_case
this.dw_appeal_drilldown=create dw_appeal_drilldown
this.dw_case_drilldown=create dw_case_drilldown
this.dw_reminders_breakdown=create dw_reminders_breakdown
this.dw_reminders_drilldown=create dw_reminders_drilldown
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_users
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_appeal_breakdown
this.Control[iCurrent+6]=this.dw_inbox
this.Control[iCurrent+7]=this.cb_close
this.Control[iCurrent+8]=this.dw_summary
this.Control[iCurrent+9]=this.dw_oldest_appeal
this.Control[iCurrent+10]=this.dw_oldest_case
this.Control[iCurrent+11]=this.dw_appeal_drilldown
this.Control[iCurrent+12]=this.dw_case_drilldown
this.Control[iCurrent+13]=this.dw_reminders_breakdown
this.Control[iCurrent+14]=this.dw_reminders_drilldown
end on

on w_summary_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.st_2)
destroy(this.dw_users)
destroy(this.st_1)
destroy(this.dw_appeal_breakdown)
destroy(this.dw_inbox)
destroy(this.cb_close)
destroy(this.dw_summary)
destroy(this.dw_oldest_appeal)
destroy(this.dw_oldest_case)
destroy(this.dw_appeal_drilldown)
destroy(this.dw_case_drilldown)
destroy(this.dw_reminders_breakdown)
destroy(this.dw_reminders_drilldown)
end on

type cb_retrieve from commandbutton within w_summary_popup
integer x = 3689
integer y = 2088
integer width = 402
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;integer li_row, li_rowcount, li_user_count
string ls_blank[]

is_users = ls_blank
li_rowcount = dw_users.Rowcount()

li_row = dw_users.getselectedrow( 0 )
IF li_row < 1 THEN
	MessageBox(gs_appname, "Please select at least one name.")
	is_users[1] = is_current_user
ELSE
	DO WHILE li_row > 0
		li_user_count++
		is_users[li_user_count] = dw_users.Object.user_id[li_row]
		li_row = dw_users.getselectedrow( li_row )
	LOOP
END IF		
of_retrieve_users()
dw_appeal_breakdown.BringtoTop = TRUE
dw_appeal_breakdown.Visible = TRUE
dw_appeal_drilldown.Visible = FALSE
dw_inbox.BringtoTop = TRUE

end event

type st_2 from statictext within w_summary_popup
integer x = 3424
integer y = 36
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pick a User"
boolean focusrectangle = false
end type

type dw_users from datawindow within w_summary_popup
integer x = 3387
integer y = 124
integer width = 1015
integer height = 1928
integer taborder = 40
string dataobject = "d_users_treeview"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;int li_row, li_rowcount, li_count

//IF li_row > 0 THEN
//	IF IsSelected(li_row) THEN
//		THIS.SelectRow(li_row, FALSE)
//	ELSE
//		THIS.SelectRow(li_row, TRUE)
//	END IF
//END IF
//
end event

event treenodeselecting;string ls_dept

IF grouplevel = 1 THEN
	IF NOT THIS.isexpanded( row, grouplevel) THEN
		THIS.expand( row, grouplevel)
	END IF
	ls_dept = THIS.getitemstring(row, 3)
	post of_select_dept(ls_dept)
ELSE
	IF row > 0 THEN
		IF IsSelected(row) THEN
			THIS.SelectRow(row, FALSE)
		ELSE
			THIS.SelectRow(row, TRUE)
		END IF
	END IF
END IF
	
// Do not let this control the selection of rows
return -1
end event

type st_1 from statictext within w_summary_popup
integer x = 37
integer y = 2092
integer width = 1705
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To DRILL DOWN, click on an item in the graph LEGENDS"
boolean focusrectangle = false
end type

type dw_appeal_breakdown from datawindow within w_summary_popup
integer x = 41
integer y = 812
integer width = 1646
integer height = 1244
integer taborder = 30
string title = "Click on Legend to Drill Down"
string dataobject = "d_appeal_summary_popup_graph"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_datawindow, ls_case, ls_object

int SeriesNum, DataNum
 double Value
 grObjectType ObjectType
 string SeriesName, ValueAsString, CategoryName
 string GraphName

GraphName = "gr_appeal_breakdown"
 
 ls_object = dwo.name
 value = THIS.categorycount( GraphName)

ObjectType = THIS.ObjectAtPointer (GraphName, SeriesNum, DataNum)
CHOOSE CASE ObjectType
	Case TypeSeries!
			SeriesName = &
				 THIS.SeriesName (GraphName, SeriesNum)
			MessageBox("Graph", &
				 "You clicked on the series " + SeriesName)
	Case TypeData!
			Value = THIS.GetData (GraphName, SeriesNum, DataNum)
			ValueAsString = String(Value)
			SeriesName = &
				 THIS.SeriesName (GraphName, SeriesNum)
			MessageBox(Gs_AppName, "To drill down, click on the category in the legend")
	Case TypeCategory!
			CategoryName = THIS.categoryname(GraphName, DataNum)
			ls_datawindow = dw_appeal_breakdown.dataobject
			CHOOSE CASE ls_datawindow
				CASE 'd_appeal_summary_popup_graph'
					IF dw_appeal_drilldown.dataobject <> 'gr_appeal_drilldown' THEN
						dw_appeal_drilldown.dataobject = 'gr_appeal_drilldown'
						dw_appeal_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_appeal_due_today_bd'
					IF dw_appeal_drilldown.dataobject <> 'gr_appeal_due_today_dd' THEN
						dw_appeal_drilldown.dataobject = 'gr_appeal_due_today_dd'
						dw_appeal_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_appeal_due_week_bd'
					IF dw_appeal_drilldown.dataobject <> 'gr_appeal_due_week_dd' THEN
						dw_appeal_drilldown.dataobject = 'gr_appeal_due_week_dd'
						dw_appeal_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_appeal_overdue_bd'
					IF dw_appeal_drilldown.dataobject <> 'gr_appeal_overdue_dd' THEN
						dw_appeal_drilldown.dataobject = 'gr_appeal_overdue_dd'
						dw_appeal_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_appeal_today_bd'
					IF dw_appeal_drilldown.dataobject <> 'gr_appeal_today_dd' THEN
						dw_appeal_drilldown.dataobject = 'gr_appeal_today_dd'
						dw_appeal_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_appeal_yesterday_bd'
					IF dw_appeal_drilldown.dataobject <> 'gr_appeal_yesterday_dd' THEN
						dw_appeal_drilldown.dataobject = 'gr_appeal_yesterday_dd'
						dw_appeal_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_appeal_last_week_bd'
					IF dw_appeal_drilldown.dataobject <> 'gr_appeal_last_week_dd' THEN
						dw_appeal_drilldown.dataobject = 'gr_appeal_last_week_dd'
						dw_appeal_drilldown.SetTransObject(SQLCA)
					END IF
			END CHOOSE
			dw_appeal_drilldown.Retrieve(is_users, CategoryName, is_current_user)
			dw_appeal_drilldown.BringtoTop = TRUE
			dw_appeal_drilldown.Visible = TRUE
END CHOOSE



end event

type dw_inbox from datawindow within w_summary_popup
integer x = 1710
integer y = 812
integer width = 1627
integer height = 1248
integer taborder = 20
string title = "Click on Legend to Drill Down"
string dataobject = "gr_inbox"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_datawindow, ls_case, ls_object

int SeriesNum, DataNum
 double Value
 grObjectType ObjectType
 string SeriesName, ValueAsString, CategoryName
 string GraphName

GraphName = "gr_inbox"
 
 ls_object = dwo.name
 value = THIS.categorycount( GraphName)

ObjectType = THIS.ObjectAtPointer (GraphName, SeriesNum, DataNum)
CHOOSE CASE ObjectType
	Case TypeSeries!
			SeriesName = &
				 THIS.SeriesName (GraphName, SeriesNum)
			MessageBox("Graph", &
				 "You clicked on the series " + SeriesName)
	Case TypeData!
			Value = THIS.GetData (GraphName, SeriesNum, DataNum)
			ValueAsString = String(Value)
			SeriesName = &
				 THIS.SeriesName (GraphName, SeriesNum)
			MessageBox(Gs_AppName, "To drill down, click on the category in the legend")
	Case TypeCategory!
			CategoryName = THIS.categoryname(GraphName, DataNum)
			ls_datawindow = dw_inbox.dataobject
			CHOOSE CASE ls_datawindow
				CASE 'gr_inbox'
					IF dw_case_drilldown.dataobject <> 'gr_case_drilldown' THEN
						dw_case_drilldown.dataobject = 'gr_case_drilldown'
						dw_case_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_case_today_bd'
					IF dw_case_drilldown.dataobject <> 'gr_case_today_dd' THEN
						dw_case_drilldown.dataobject = 'gr_case_today_dd'
						dw_case_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_case_yesterday_bd'
					IF dw_case_drilldown.dataobject <> 'gr_case_yesterday_dd' THEN
						dw_case_drilldown.dataobject = 'gr_case_yesterday_dd'
						dw_case_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_case_last_week_bd'
					IF dw_case_drilldown.dataobject <> 'gr_case_last_week_dd' THEN
						dw_case_drilldown.dataobject = 'gr_case_last_week_dd'
						dw_case_drilldown.SetTransObject(SQLCA)
					END IF
			END CHOOSE
			dw_case_drilldown.Retrieve(is_users, CategoryName, is_current_user)
			dw_case_drilldown.BringtoTop = TRUE
			dw_case_drilldown.Visible = TRUE
END CHOOSE



end event

type cb_close from commandbutton within w_summary_popup
integer x = 2400
integer y = 2084
integer width = 402
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;Close(PARENT)
end event

type dw_summary from datawindow within w_summary_popup
integer x = 41
integer y = 36
integer width = 3305
integer height = 744
integer taborder = 10
string title = "none"
string dataobject = "d_summary_popup"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;STRING ls_button


ls_button = dwo.name
CHOOSE CASE ls_button
	CASE 'b_inbox'
		THIS.object.b_inbox.text = '*'
		THIS.object.b_oldest_case.text = ' '
		THIS.object.b_remind_today.text = ' '
		THIS.object.b_remind_week.text = ' '
		THIS.object.b_remind_overdue.text = ' '
		THIS.object.b_cases_today.text = ' '
		THIS.object.b_cases_yesterday.text = ' '
		THIS.object.b_cases_week.text = ' '
		IF dw_inbox.dataobject <> 'gr_inbox' THEN
			dw_inbox.dataobject = 'gr_inbox'
			dw_inbox.SetTransObject(SQLCA)
			dw_inbox.Retrieve(is_users, is_current_user)
		END IF
		dw_inbox.visible = True
		dw_case_drilldown.visible = False
		dw_oldest_case.visible = False
		dw_reminders_breakdown.visible = False
		dw_reminders_drilldown.visible = False
	CASE 'b_oldest_case'
		THIS.object.b_inbox.text = ' '
		THIS.object.b_oldest_case.text = '*'
		THIS.object.b_remind_today.text = ' '
		THIS.object.b_remind_week.text = ' '
		THIS.object.b_remind_overdue.text = ' '
		THIS.object.b_cases_today.text = ' '
		THIS.object.b_cases_yesterday.text = ' '
		THIS.object.b_cases_week.text = ' '
		dw_inbox.visible = False
		dw_case_drilldown.visible = False
		dw_oldest_case.visible = True
		dw_reminders_breakdown.visible = False
		dw_reminders_drilldown.visible = False
	CASE 'b_remind_today'
		THIS.object.b_inbox.text = ' '
		THIS.object.b_oldest_case.text = ' '
		THIS.object.b_remind_today.text = '*'
		THIS.object.b_remind_week.text = ' '
		THIS.object.b_remind_overdue.text = ' '
		THIS.object.b_cases_today.text = ' '
		THIS.object.b_cases_yesterday.text = ' '
		THIS.object.b_cases_week.text = ' '
		dw_inbox.visible = False
		dw_case_drilldown.visible = False
		dw_oldest_case.visible = False
		IF dw_reminders_breakdown.dataobject <> 'gr_reminders_today_bd' THEN
			dw_reminders_breakdown.dataobject = 'gr_reminders_today_bd'
			dw_reminders_breakdown.SetTransObject(SQLCA)
			dw_reminders_breakdown.Retrieve(is_users)
		END IF
		dw_reminders_breakdown.visible = True
		dw_reminders_drilldown.visible = False
	CASE 'b_remind_week'
		THIS.object.b_inbox.text = ' '
		THIS.object.b_oldest_case.text = ' '
		THIS.object.b_remind_today.text = ' '
		THIS.object.b_remind_week.text = '*'
		THIS.object.b_remind_overdue.text = ' '
		THIS.object.b_cases_today.text = ' '
		THIS.object.b_cases_yesterday.text = ' '
		THIS.object.b_cases_week.text = ' '
		dw_inbox.visible = False
		dw_case_drilldown.visible = False
		dw_oldest_case.visible = False
		IF dw_reminders_breakdown.dataobject <> 'gr_reminders_week_bd' THEN
			dw_reminders_breakdown.dataobject = 'gr_reminders_week_bd'
			dw_reminders_breakdown.SetTransObject(SQLCA)
			dw_reminders_breakdown.Retrieve(is_users)
		END IF
		dw_reminders_breakdown.visible = True
		dw_reminders_drilldown.visible = False
	CASE 'b_remind_overdue'
		THIS.object.b_inbox.text = ' '
		THIS.object.b_oldest_case.text = ' '
		THIS.object.b_remind_today.text = ' '
		THIS.object.b_remind_week.text = ' '
		THIS.object.b_remind_overdue.text = '*'
		THIS.object.b_cases_today.text = ' '
		THIS.object.b_cases_yesterday.text = ' '
		THIS.object.b_cases_week.text = ' '
		dw_inbox.visible = False
		dw_case_drilldown.visible = False
		dw_oldest_case.visible = False
		IF dw_reminders_breakdown.dataobject <> 'gr_reminders_overdue_bd' THEN
			dw_reminders_breakdown.dataobject = 'gr_reminders_overdue_bd'
			dw_reminders_breakdown.SetTransObject(SQLCA)
			dw_reminders_breakdown.Retrieve(is_users)
		END IF
		dw_reminders_breakdown.visible = True
		dw_reminders_drilldown.visible = False
	CASE 'b_cases_today'
		THIS.object.b_inbox.text = ' '
		THIS.object.b_oldest_case.text = ' '
		THIS.object.b_remind_today.text = ' '
		THIS.object.b_remind_week.text = ' '
		THIS.object.b_remind_overdue.text = ' '
		THIS.object.b_cases_today.text = '*'
		THIS.object.b_cases_yesterday.text = ' '
		THIS.object.b_cases_week.text = ' '
		IF dw_inbox.dataobject <> 'gr_case_today_bd' THEN
			dw_inbox.dataobject = 'gr_case_today_bd'
			dw_inbox.SetTransObject(SQLCA)
			dw_inbox.Retrieve(is_users, is_current_user)
		END IF
		dw_inbox.visible = True
		dw_case_drilldown.visible = False
		dw_oldest_case.visible = False
		dw_reminders_breakdown.visible = False
		dw_reminders_drilldown.visible = False
	CASE 'b_cases_yesterday'
		THIS.object.b_inbox.text = ' '
		THIS.object.b_oldest_case.text = ' '
		THIS.object.b_remind_today.text = ' '
		THIS.object.b_remind_week.text = ' '
		THIS.object.b_remind_overdue.text = ' '
		THIS.object.b_cases_today.text = ' '
		THIS.object.b_cases_yesterday.text = '*'
		THIS.object.b_cases_week.text = ' '
		IF dw_inbox.dataobject <> 'gr_case_yesterday_bd' THEN
			dw_inbox.dataobject = 'gr_case_yesterday_bd'
			dw_inbox.SetTransObject(SQLCA)
			dw_inbox.Retrieve(is_users, is_current_user)
		END IF
		dw_inbox.visible = True
		dw_case_drilldown.visible = False
		dw_oldest_case.visible = False
		dw_reminders_breakdown.visible = False
		dw_reminders_drilldown.visible = False
	CASE 'b_cases_week'
		THIS.object.b_inbox.text = ' '
		THIS.object.b_oldest_case.text = ' '
		THIS.object.b_remind_today.text = ' '
		THIS.object.b_remind_week.text = ' '
		THIS.object.b_remind_overdue.text = ' '
		THIS.object.b_cases_today.text = ' '
		THIS.object.b_cases_yesterday.text = ' '
		THIS.object.b_cases_week.text = '*'
		IF dw_inbox.dataobject <> 'gr_case_last_week_bd' THEN
			dw_inbox.dataobject = 'gr_case_last_week_bd'
			dw_inbox.SetTransObject(SQLCA)
			dw_inbox.Retrieve(is_users, is_current_user)
		END IF
		dw_inbox.visible = True
		dw_case_drilldown.visible = False
		dw_oldest_case.visible = False
		dw_reminders_breakdown.visible = False
		dw_reminders_drilldown.visible = False

// Appeal Summary
	CASE 'b_number_appeals'
		THIS.object.b_number_appeals.text = '*'
		THIS.object.b_oldest_appeal.text = ' '
		THIS.object.b_appeals_due_today.text = ' '
		THIS.object.b_appeals_due_week.text = ' '
		THIS.object.b_appeals_overdue.text = ' '
		THIS.object.b_appeals_today.text = ' '
		THIS.object.b_appeals_yesterday.text = ' '
		THIS.object.b_appeals_last_week.text = ' '
		IF dw_appeal_breakdown.dataobject <> 'd_appeal_summary_popup_graph' THEN
			dw_appeal_breakdown.dataobject = 'd_appeal_summary_popup_graph'
			dw_appeal_breakdown.SetTransObject(SQLCA)
			dw_appeal_breakdown.Retrieve(is_users, is_current_user)
		END IF
		dw_appeal_breakdown.visible = True
		dw_appeal_drilldown.visible = False
		dw_oldest_appeal.visible = False
	CASE 'b_oldest_appeal'
		THIS.object.b_number_appeals.text = ' '
		THIS.object.b_oldest_appeal.text = '*'
		THIS.object.b_appeals_due_today.text = ' '
		THIS.object.b_appeals_due_week.text = ' '
		THIS.object.b_appeals_overdue.text = ' '
		THIS.object.b_appeals_today.text = ' '
		THIS.object.b_appeals_yesterday.text = ' '
		THIS.object.b_appeals_last_week.text = ' '
		dw_appeal_breakdown.visible = False
		dw_appeal_drilldown.visible = False
		dw_oldest_appeal.visible = True
	CASE 'b_appeals_due_today'
		THIS.object.b_number_appeals.text = ' '
		THIS.object.b_oldest_appeal.text = ' '
		THIS.object.b_appeals_due_today.text = '*'
		THIS.object.b_appeals_due_week.text = ' '
		THIS.object.b_appeals_overdue.text = ' '
		THIS.object.b_appeals_today.text = ' '
		THIS.object.b_appeals_yesterday.text = ' '
		THIS.object.b_appeals_last_week.text = ' '
		IF dw_appeal_breakdown.dataobject <> 'gr_appeal_due_today_bd' THEN
			dw_appeal_breakdown.dataobject = 'gr_appeal_due_today_bd'
			dw_appeal_breakdown.SetTransObject(SQLCA)
			dw_appeal_breakdown.Retrieve(is_users, is_current_user)
		END IF
		dw_appeal_breakdown.visible = True
		dw_appeal_drilldown.visible = False
		dw_oldest_appeal.visible = False
	CASE 'b_appeals_due_week'
		THIS.object.b_number_appeals.text = ' '
		THIS.object.b_oldest_appeal.text = ' '
		THIS.object.b_appeals_due_today.text = ' '
		THIS.object.b_appeals_due_week.text = '*'
		THIS.object.b_appeals_overdue.text = ' '
		THIS.object.b_appeals_today.text = ' '
		THIS.object.b_appeals_yesterday.text = ' '
		THIS.object.b_appeals_last_week.text = ' '
		IF dw_appeal_breakdown.dataobject <> 'gr_appeal_due_week_bd' THEN
			dw_appeal_breakdown.dataobject = 'gr_appeal_due_week_bd'
			dw_appeal_breakdown.SetTransObject(SQLCA)
			dw_appeal_breakdown.Retrieve(is_users, is_current_user)
		END IF
		dw_appeal_breakdown.visible = True
		dw_appeal_drilldown.visible = False
		dw_oldest_appeal.visible = False
	CASE 'b_appeals_overdue'
		THIS.object.b_number_appeals.text = ' '
		THIS.object.b_oldest_appeal.text = ' '
		THIS.object.b_appeals_due_today.text = ' '
		THIS.object.b_appeals_due_week.text = ' '
		THIS.object.b_appeals_overdue.text = '*'
		THIS.object.b_appeals_today.text = ' '
		THIS.object.b_appeals_yesterday.text = ' '
		THIS.object.b_appeals_last_week.text = ' '
		IF dw_appeal_breakdown.dataobject <> 'gr_appeal_overdue_bd' THEN
			dw_appeal_breakdown.dataobject = 'gr_appeal_overdue_bd'
			dw_appeal_breakdown.SetTransObject(SQLCA)
			dw_appeal_breakdown.Retrieve(is_users, is_current_user)
		END IF
		dw_appeal_breakdown.visible = True
		dw_appeal_drilldown.visible = False
		dw_oldest_appeal.visible = False
	CASE 'b_appeals_today'
		THIS.object.b_number_appeals.text = ' '
		THIS.object.b_oldest_appeal.text = ' '
		THIS.object.b_appeals_due_today.text = ' '
		THIS.object.b_appeals_due_week.text = ' '
		THIS.object.b_appeals_overdue.text = ' '
		THIS.object.b_appeals_today.text = '*'
		THIS.object.b_appeals_yesterday.text = ' '
		THIS.object.b_appeals_last_week.text = ' '
		IF dw_appeal_breakdown.dataobject <> 'gr_appeal_today_bd' THEN
			dw_appeal_breakdown.dataobject = 'gr_appeal_today_bd'
			dw_appeal_breakdown.SetTransObject(SQLCA)
			dw_appeal_breakdown.Retrieve(is_users, is_current_user)
		END IF
		dw_appeal_breakdown.visible = True
		dw_appeal_drilldown.visible = False
		dw_oldest_appeal.visible = False
	CASE 'b_appeals_yesterday'
		THIS.object.b_number_appeals.text = ' '
		THIS.object.b_oldest_appeal.text = ' '
		THIS.object.b_appeals_due_today.text = ' '
		THIS.object.b_appeals_due_week.text = ' '
		THIS.object.b_appeals_overdue.text = ' '
		THIS.object.b_appeals_today.text = ' '
		THIS.object.b_appeals_yesterday.text = '*'
		THIS.object.b_appeals_last_week.text = ' '
		IF dw_appeal_breakdown.dataobject <> 'gr_appeal_yesterday_bd' THEN
			dw_appeal_breakdown.dataobject = 'gr_appeal_yesterday_bd'
			dw_appeal_breakdown.SetTransObject(SQLCA)
			dw_appeal_breakdown.Retrieve(is_users, is_current_user)
		END IF
		dw_appeal_breakdown.visible = True
		dw_appeal_drilldown.visible = False
		dw_oldest_appeal.visible = False
	CASE 'b_appeals_last_week'
		THIS.object.b_number_appeals.text = ' '
		THIS.object.b_oldest_appeal.text = ' '
		THIS.object.b_appeals_due_today.text = ' '
		THIS.object.b_appeals_due_week.text = ' '
		THIS.object.b_appeals_overdue.text = ' '
		THIS.object.b_appeals_today.text = ' '
		THIS.object.b_appeals_yesterday.text = ' '
		THIS.object.b_appeals_last_week.text = '*'
		IF dw_appeal_breakdown.dataobject <> 'gr_appeal_last_week_bd' THEN
			dw_appeal_breakdown.dataobject = 'gr_appeal_last_week_bd'
			dw_appeal_breakdown.SetTransObject(SQLCA)
			dw_appeal_breakdown.Retrieve(is_users, is_current_user)
		END IF
		dw_appeal_breakdown.visible = True
		dw_appeal_drilldown.visible = False
		dw_oldest_appeal.visible = False
END CHOOSE		
cb_close.SetFocus()

end event

event doubleclicked;w_create_maintain_case l_wCaseWindow
INTEGER li_return
string ls_datawindow, ls_case, ls_object


ls_object = THIS.GetObjectAtPointer()
ls_datawindow = dwo.name

CHOOSE CASE ls_datawindow
	CASE 'dw_oldest_case'
		ls_case = THIS.object.dw_oldest_case.object.case_number[1]
	CASE 'dw_oldest_appeal'
		ls_case = THIS.object.dw_oldest_appeal.object.case_number[1]
END CHOOSE
		
IF NOT IsNull( ls_Case ) AND Trim( ls_Case ) <> "" THEN
	// Open w_create_maintain_case
	FWCA.MGR.fu_OpenWindow(w_create_maintain_case, -1)
	l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet()
	
	IF IsValid (l_wCaseWindow) THEN
		
		// Make sure the window is on the Search tab
		IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
			li_return = l_wCaseWindow.dw_folder.fu_SelectTab(1)
		END IF
		
		IF li_return = -1 THEN
			RETURN -1
		ELSE
			// call ue_casesearch to process the query after the window is fully initialized.
			l_wCaseWindow.dw_folder.Event Post ue_casesearch( ls_Case)
		END IF
		// Close this window
		Close(Parent)
	END IF						
END IF
end event

type dw_oldest_appeal from datawindow within w_summary_popup
integer x = 41
integer y = 812
integer width = 1641
integer height = 1244
integer taborder = 30
string title = "Oldest Appeal"
string dataobject = "d_oldest_appeal"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_oldest_case from datawindow within w_summary_popup
integer x = 1710
integer y = 812
integer width = 1627
integer height = 1248
integer taborder = 30
string title = "Oldest Case"
string dataobject = "d_oldest_case"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_datawindow, ls_case, ls_object

int SeriesNum, DataNum
 double Value
 grObjectType ObjectType
 string SeriesName, ValueAsString, CategoryName
 string GraphName
 GraphName = "gr_inbox"
 
 ls_object = dwo.name
 value = THIS.categorycount( GraphName)

ObjectType = THIS.ObjectAtPointer (GraphName, SeriesNum, DataNum)
CHOOSE CASE ObjectType
	Case TypeSeries!
			SeriesName = &
				 THIS.SeriesName (GraphName, SeriesNum)
			MessageBox("Graph", &
				 "You clicked on the series " + SeriesName)
	Case TypeData!
			Value = THIS.GetData (GraphName, SeriesNum, DataNum)
			ValueAsString = String(Value)
			CategoryName = THIS.categoryname(GraphName, SeriesNum)
			SeriesName = &
				 THIS.SeriesName (GraphName, SeriesNum)
			MessageBox("Graph", &
				 THIS.SeriesName (GraphName, SeriesNum) + " value is " + ValueAsString)
	Case TypeCategory!
			CategoryName = THIS.categoryname(GraphName, DataNum)
			MessageBox("Graph", &
				 "The category is  " + CategoryName)
END CHOOSE


end event

type dw_appeal_drilldown from datawindow within w_summary_popup
integer x = 41
integer y = 812
integer width = 1646
integer height = 1244
integer taborder = 40
string title = "Click on Graph to Drill Back Up"
string dataobject = "gr_appeal_drilldown"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_appeal_breakdown.BringtoTop = TRUE
dw_appeal_breakdown.Visible = TRUE
dw_appeal_drilldown.Visible = FALSE

end event

type dw_case_drilldown from datawindow within w_summary_popup
integer x = 1710
integer y = 816
integer width = 1627
integer height = 1236
integer taborder = 20
string title = "Click on Graph to Drill Back Up"
string dataobject = "gr_case_drilldown"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_inbox.BringtoTop = TRUE
dw_inbox.Visible = TRUE
dw_case_drilldown.Visible = FALSE

end event

type dw_reminders_breakdown from datawindow within w_summary_popup
integer x = 1710
integer y = 812
integer width = 1627
integer height = 1248
integer taborder = 40
string title = "Click on Legend to Drill Down"
string dataobject = "gr_reminders_today_bd"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_datawindow, ls_case, ls_object

int SeriesNum, DataNum
 double Value
 grObjectType ObjectType
 string SeriesName, ValueAsString, CategoryName
 string GraphName

GraphName = "gr_reminders"
 
 ls_object = dwo.name
 value = THIS.categorycount( GraphName)

ObjectType = THIS.ObjectAtPointer (GraphName, SeriesNum, DataNum)
CHOOSE CASE ObjectType
	Case TypeSeries!
			SeriesName = &
				 THIS.SeriesName (GraphName, SeriesNum)
			MessageBox("Graph", &
				 "You clicked on the series " + SeriesName)
	Case TypeData!
			Value = THIS.GetData (GraphName, SeriesNum, DataNum)
			ValueAsString = String(Value)
			SeriesName = &
				 THIS.SeriesName (GraphName, SeriesNum)
			MessageBox(Gs_AppName, "To drill down, click on the category in the legend")
	Case TypeCategory!
			CategoryName = THIS.categoryname(GraphName, DataNum)
			ls_datawindow = dw_reminders_breakdown.dataobject
			CHOOSE CASE ls_datawindow
				CASE 'gr_reminders_today_bd'
					IF dw_reminders_drilldown.dataobject <> 'gr_reminders_today_dd' THEN
						dw_reminders_drilldown.dataobject = 'gr_reminders_today_dd'
						dw_reminders_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_reminders_week_bd'
					IF dw_reminders_drilldown.dataobject <> 'gr_reminders_week_dd' THEN
						dw_reminders_drilldown.dataobject = 'gr_reminders_week_dd'
						dw_reminders_drilldown.SetTransObject(SQLCA)
					END IF
				CASE 'gr_reminders_overdue_bd'
					IF dw_reminders_drilldown.dataobject <> 'gr_reminders_overdue_dd' THEN
						dw_reminders_drilldown.dataobject = 'gr_reminders_overdue_dd'
						dw_reminders_drilldown.SetTransObject(SQLCA)
					END IF
			END CHOOSE
			dw_reminders_drilldown.Retrieve(is_users, CategoryName)
			dw_reminders_drilldown.BringtoTop = TRUE
			dw_reminders_drilldown.Visible = TRUE
END CHOOSE



end event

type dw_reminders_drilldown from datawindow within w_summary_popup
integer x = 1710
integer y = 812
integer width = 1627
integer height = 1248
integer taborder = 40
string title = "Click on Graph to Drill Back Up"
string dataobject = "gr_reminders_today_dd"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_reminders_breakdown.BringtoTop = TRUE
dw_reminders_breakdown.Visible = TRUE
dw_reminders_drilldown.Visible = FALSE

end event

