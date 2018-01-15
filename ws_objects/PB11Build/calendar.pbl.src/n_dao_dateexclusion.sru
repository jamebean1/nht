$PBExportHeader$n_dao_dateexclusion.sru
forward
global type n_dao_dateexclusion from n_dao_reference_data
end type
end forward

global type n_dao_dateexclusion from n_dao_reference_data
string dataobject = "d_data_dateexclusion"
end type
global n_dao_dateexclusion n_dao_dateexclusion

type variables

end variables

on n_dao_dateexclusion.create
call super::create
end on

on n_dao_dateexclusion.destroy
call super::destroy
end on

event constructor;call super::constructor;//of_add_child('CalendarDetail', 'n_dao_calendar_detail')

end event

