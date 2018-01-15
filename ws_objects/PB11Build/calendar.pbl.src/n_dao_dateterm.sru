$PBExportHeader$n_dao_dateterm.sru
forward
global type n_dao_dateterm from n_dao_reference_data
end type
end forward

global type n_dao_dateterm from n_dao_reference_data
string dataobject = "d_data_dateterm"
end type
global n_dao_dateterm n_dao_dateterm

on n_dao_dateterm.create
call super::create
end on

on n_dao_dateterm.destroy
call super::destroy
end on

event constructor;call super::constructor;n_transaction_pool ln_transaction_pool
transaction lt_transobject


ln_transaction_pool = Create n_transaction_pool

this.dataobject = 'd_data_dateterm'
is_qualifier = 'DateTerm'

this.of_SetTransobject(SQLCA)


end event

