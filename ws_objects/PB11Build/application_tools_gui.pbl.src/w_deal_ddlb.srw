$PBExportHeader$w_deal_ddlb.srw
forward
global type w_deal_ddlb from window
end type
type plb_1 from picturelistbox within w_deal_ddlb
end type
end forward

global type w_deal_ddlb from window
boolean visible = false
integer x = 1189
integer y = 556
integer width = 1714
integer height = 932
windowtype windowtype = child!
long backcolor = 16777215
plb_1 plb_1
end type
global w_deal_ddlb w_deal_ddlb

type variables
u_dynamic_gui iu_details[]

end variables

forward prototypes
public function integer of_add_object (u_dynamic_gui au_dynamic_gui_other)
public function integer of_show ()
public function integer of_reset ()
end prototypes

public function integer of_add_object (u_dynamic_gui au_dynamic_gui_other);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_add_object
// Overrides:  No
// Overview:   add the object to the list.
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long i_i
i_i = upperbound (iu_details)

i_i ++

iu_details[i_i] = au_dynamic_gui_other

plb_1.AddItem (au_dynamic_gui_other.text,plb_1.addpicture(au_dynamic_gui_other.picturename))

return 0
end function

public function integer of_show ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_show
// Overrides:  No
// Overview:   show the dropdown.
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

plb_1.setfocus()
this.visible = true

return 0
end function

public function integer of_reset ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_reset
// Overrides:  No
// Overview:   reset the list
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

integer i_i

plb_1.reset()

return 0
end function

event deactivate;//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	deactivate()
//	Overview:   close the window
//	Created by:	Jake Pratt
//	History: 	8-6-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
close(this)
end event

event activate;//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	activatel()
//	Overview:   select the first item in the list
//	Created by:	Jake Pratt
//	History: 	8-6-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
plb_1.selectitem(0)
end event

on w_deal_ddlb.create
this.plb_1=create plb_1
this.Control[]={this.plb_1}
end on

on w_deal_ddlb.destroy
destroy(this.plb_1)
end on

event resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	resize()
//	Overview:   Size list box to the size of the window.
//	Created by:	Jake Pratt
//	History: 	8-6-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
plb_1.width = this.width - (plb_1.x * 2)
end event

type plb_1 from picturelistbox within w_deal_ddlb
event clicked pbm_bnclicked
integer x = 32
integer y = 16
integer width = 1682
integer height = 896
integer taborder = 1
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean vscrollbar = true
boolean sorted = false
string picturename[] = {"Custom039!"}
long picturemaskcolor = 12632256
end type

event losefocus;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      losefocus
// Overrides:  No
// Overview:   close on the lostfocus to simulate a dropdown.  This assumes that the fucus was set here
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
close(parent)

end event

event selectionchanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      selectionchanged
// Overrides:  No
// Overview:   trigger the of_display on teh object selected in the list.
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long i_i
parent.visible = false
for i_i = 1 to upperbound(iu_details)
	iu_details[i_i].triggerevent('ue_hide')
next
iu_details[ index ].of_display()
//iu_details[index].triggerevent('ue_setfocus')

	

end event

