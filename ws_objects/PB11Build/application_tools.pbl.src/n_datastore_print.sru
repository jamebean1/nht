$PBExportHeader$n_datastore_print.sru
forward
global type n_datastore_print from datastore
end type
end forward

global type n_datastore_print from datastore
event type string ue_notify ( string as_message,  any aany_argument )
end type
global n_datastore_print n_datastore_print

type variables
Protected:
	Boolean	ib_showcanceldialog
	Window 	iw_print_dialog
	Boolean	ib_cancel
end variables

forward prototypes
public function long of_print (boolean ab_showcanceldialog)
end prototypes

event type string ue_notify(string as_message, any aany_argument);Choose Case Lower(Trim(as_message))
	Case 'print cancel'
		ib_cancel = True
End Choose

Return ''
end event

public function long of_print (boolean ab_showcanceldialog);Long	ll_return

ib_showcanceldialog = ab_showcanceldialog

ll_return = This.Print()

If ib_cancel Then
	Return -2
Else
	Return ll_return
End If
end function

on n_datastore_print.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datastore_print.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event printstart;String	ls_title

If ib_showcanceldialog Then
	Open(iw_print_dialog, 'w_print_cancel_dialog')

	If IsValid(iw_print_dialog) Then
		If IsNumber(This.Describe("report_title.X")) Then
			ls_title = This.Describe("report_title.Text")
			If ls_title <> '?' And ls_title <> '!' Then
				iw_print_dialog.Dynamic of_settitle(ls_title)
			End If
		End If
		
		iw_print_dialog.Dynamic of_init(This)
		iw_print_dialog.Dynamic of_printstart(pagesmax)
	End If
End If


end event

event printpage;If ib_cancel Then Return 1

If IsValid(iw_print_dialog) Then
	iw_print_dialog.Dynamic of_printpage(pagenumber, copy)
End If

Yield()

Return 0
end event

event printend;If IsValid(iw_print_dialog) Then
	Close(iw_print_dialog)
End If
end event

