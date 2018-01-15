$PBExportHeader$u_vscrollbar_dw.sru
forward
global type u_vscrollbar_dw from vscrollbar
end type
end forward

global type u_vscrollbar_dw from vscrollbar
boolean visible = false
integer width = 59
integer height = 208
end type
global u_vscrollbar_dw u_vscrollbar_dw

type variables
Datawindow idw
end variables

forward prototypes
public subroutine of_init (datawindow adw)
public subroutine of_set_max_position ()
end prototypes

public subroutine of_init (datawindow adw);idw = adw
end subroutine

public subroutine of_set_max_position ();long ll_rowsperpage


ll_rowsperpage = long(idw.Object.Datawindow.LastRowOnPage) - long(idw.Object.Datawindow.FirstRowOnPage) + 1

This.MaxPosition = (idw.Rowcount() - ll_rowsperpage )  * long(idw.Object.Datawindow.Detail.Height)

if this.MaxPosition = 0 then 
	this.visible = False
Else
	this.visible = true
end if
end subroutine

on u_vscrollbar_dw.create
end on

on u_vscrollbar_dw.destroy
end on

event moved;Long ll_rowsonpage

if scrollpos = this.MinPosition then
	idw.ScrolltoRow(1)
ElseIF scrollpos = this.MaxPosition then
	idw.ScrolltoRow(idw.Rowcount())
Else
	ll_rowsonpage = Long(idw.Object.Datawindow.LastRowOnPage) - Long(idw.Object.Datawindow.FirstRowOnPage)
	idw.ScrollToRow( (ScrollPos / Long(idw.Object.Datawindow.Detail.Height)) + ll_rowsonpage)
end if


end event

event lineup;if Long(idw.Object.Datawindow.FirstRowOnPage) - 1 >= 1 then 
	idw.ScrolltoRow(Long(idw.Object.Datawindow.FirstRowOnPage) - 1)
End if


end event

event linedown;if Long(idw.Object.Datawindow.LastRowOnPage) + 1 <= idw.Rowcount() then 
	idw.ScrolltoRow(Long(idw.Object.Datawindow.LastRowOnPage) + 1)
End if

end event

event pagedown;idw.ScrollNextPage()
end event

event pageup;idw.ScrollPriorPage()
end event

