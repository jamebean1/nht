$PBExportHeader$u_tabcntrl.sru
forward
global type u_tabcntrl from userobject
end type
type r_back from rectangle within u_tabcntrl
end type
type ln_top_insde from line within u_tabcntrl
end type
type ln_rght_insde from line within u_tabcntrl
end type
type ln_lft_insde from line within u_tabcntrl
end type
type ln_1 from line within u_tabcntrl
end type
type ln_2 from line within u_tabcntrl
end type
type st_tab_txt from statictext within u_tabcntrl
end type
end forward

global type u_tabcntrl from userobject
integer width = 517
integer height = 72
boolean enabled = false
long backcolor = 33554432
long tabtextcolor = 33554432
event ue_taboff pbm_custom01
event ue_tabdsble pbm_custom02
event ue_tabenble pbm_custom03
event ue_tabclckd pbm_custom04
event ue_tabpstclckd pbm_custom05
event ue_refreshtheme ( )
event ue_clicked ( )
event type long ue_get_oncolor ( )
event type long ue_get_offcolor ( )
r_back r_back
ln_top_insde ln_top_insde
ln_rght_insde ln_rght_insde
ln_lft_insde ln_lft_insde
ln_1 ln_1
ln_2 ln_2
st_tab_txt st_tab_txt
end type
global u_tabcntrl u_tabcntrl

type variables
boolean ib_tabon=FALSE, ib_tabenbld=FALSE, ib_sizeabletabs=FALSE
integer ii_prfxlngth=11
graphicobject igo_tab_cntrl_lst[]
graphicobject igo_tab_cntrl_enble_lst[]
graphicobject igo_tab_cntrl_dsble_lst[]

graphicobject controllist[]
end variables

forward prototypes
public function boolean uf_tab_cntrl_focus (graphicobject go_objct)
public subroutine uf_tab_cntrl_status ()
public function boolean uf_tab_cntrl_enbled (boolean b_newstte, graphicobject go_objct)
end prototypes

event ue_taboff;// The constructor event has copius notes

integer			i_eye, i_tabmx
graphicobject	go_objtmp

If ib_tabon=TRUE Then
	// set tab flag
	ib_tabon=FALSE
	// set text style
	st_tab_txt.backcolor =  this.event ue_get_offcolor()
	st_tab_txt.height = 65
	st_tab_txt.textcolor = 16777215

	// show the bottom lines that mimic the 3d border behind this tab object so it appears off
	//	ln_rght_crnr_insde.Visible=FALSE
	// Make all objects in this tab control object's array of objects invisible.
	// Only graphicobject variables will allow ANY control type to be set invisible, so we used "go_objtmp".
	i_tabmx=UpperBound( igo_tab_cntrl_lst )
	For i_eye = 1 to i_tabmx
		go_objtmp=igo_tab_cntrl_lst[i_eye]
		go_objtmp.Visible=FALSE
	Next
End If
end event

on ue_tabdsble;// set text color
this.st_tab_txt.TextColor=8421504	// dark grey
// disable tab
this.Enabled=FALSE

end on

on ue_tabenble;// set text color
this.st_tab_txt.TextColor=0	// black
// enable tab
this.Enabled=TRUE

end on

event ue_refreshtheme;if ib_tabon then 
	st_tab_txt.backcolor = gn_globals.in_theme.of_get_backcolor()
	st_tab_txt.textcolor = 0
	r_back.visible = true
else
	st_tab_txt.backcolor = gn_globals.in_theme.of_get_barcolor()
	r_back.visible = false
	st_tab_txt.textcolor = 16777215
end if

this.backcolor = 8421504
end event

event ue_clicked;st_tab_txt.PostEvent(Clicked!)
end event

event type long ue_get_oncolor();return gn_globals.in_theme.of_get_backcolor()
end event

event type long ue_get_offcolor();return gn_globals.in_theme.of_get_barcolor()
end event

public function boolean uf_tab_cntrl_focus (graphicobject go_objct);CheckBox				cb_CheckBox_temp
CommandButton		cb_CommandButton_temp
//unknow object type:	CPlusPlusObject	cb_CPlusPlusObject_temp
DataWindow			cb_DataWindow_temp
//incompatible types:	DataWindowChild	cb_DataWindowChild_temp
DropDownListBox		cb_DropDownListBox_temp
EditMask				cb_EditMask_temp
//incompatible types:	ExtObject	cb_ExtObject_temp
Graph					cb_Graph_temp
GroupBox				cb_GroupBox_temp
ListBox					cb_ListBox_temp
//incompatible types:	Menu	cb_Menu_temp
MultiLineEdit			cb_MultiLineEdit_temp
OleControl				cb_OleControl_temp
//incompatible types:	OleObject	cb_OleObject_temp
OmControl				cb_OmControl_temp
//incompatible types:	OmObject	cb_OmObject_temp
Picture					cb_Picture_temp
PictureButton			cb_PictureButton_temp
RadioButton				cb_RadioButton_temp
SingleLineEdit			cb_SingleLineEdit_temp
StaticText				cb_StaticText_temp
UserObject				cb_UserObject_temp
Boolean					RtnVal

RtnVal=TRUE

Choose Case go_objct.TypeOf()
	Case CheckBox!
		cb_CheckBox_temp=go_objct
		cb_CheckBox_temp.SetFocus()
	Case CommandButton!
		cb_CommandButton_temp=go_objct
		cb_CommandButton_temp.SetFocus()
//	Case CPlusPlusObject!
//		cb_CPlusPlusObject_temp=go_objct
//		cb_CPlusPlusObject_temp.SetFocus()
	Case DataWindow!
		cb_DataWindow_temp=go_objct
		cb_DataWindow_temp.SetFocus()
//	Case DataWindowChild!
//		cb_DataWindowChild_temp=go_objct
//		cb_DataWindowChild_temp.SetFocus()
	Case DropDownListBox!
		cb_DropDownListBox_temp=go_objct
		cb_DropDownListBox_temp.SetFocus()
	Case EditMask!
		cb_EditMask_temp=go_objct
		cb_EditMask_temp.SetFocus()
//	Case ExtObject!
//		cb_ExtObject_temp=go_objct
//		cb_ExtObject_temp.SetFocus()
	Case Graph!
		cb_Graph_temp=go_objct
		cb_Graph_temp.SetFocus()
	Case GroupBox!
		cb_GroupBox_temp=go_objct
		cb_GroupBox_temp.SetFocus()
	Case ListBox!
		cb_ListBox_temp=go_objct
		cb_ListBox_temp.SetFocus()
//	Case Menu!
//		cb_Menu_temp=go_objct
//		cb_Menu_temp.SetFocus()
	Case MultiLineEdit!
		cb_MultiLineEdit_temp=go_objct
		cb_MultiLineEdit_temp.SetFocus()
	Case OleControl!
		cb_OleControl_temp=go_objct
		cb_OleControl_temp.SetFocus()
//	Case OleObject!
//		cb_OleObject_temp=go_objct
//		cb_OleObject_temp.SetFocus()
	Case OmControl!
		cb_OmControl_temp=go_objct
		cb_OmControl_temp.SetFocus()
//	Case OmObject!
//		cb_OmObject_temp=go_objct
//		cb_OmObject_temp.SetFocus()
	Case Picture!
		cb_Picture_temp=go_objct
		cb_Picture_temp.SetFocus()
	Case PictureButton!
		cb_PictureButton_temp=go_objct
		cb_PictureButton_temp.SetFocus()
	Case RadioButton!
		cb_RadioButton_temp=go_objct
		cb_RadioButton_temp.SetFocus()
	Case SingleLineEdit!
		cb_SingleLineEdit_temp=go_objct
		cb_SingleLineEdit_temp.SetFocus()
	Case StaticText!
		cb_StaticText_temp=go_objct
		cb_StaticText_temp.SetFocus()
	Case UserObject!
		cb_UserObject_temp=go_objct
		cb_UserObject_temp.SetFocus()
	Case Else
		RtnVal=FALSE
End Choose
Return(RtnVal)

end function

public subroutine uf_tab_cntrl_status ();str_get_mssge_parms	str_mssge_parms
integer					i_jay, i_tabmx
graphicobject			go_objct_tmp

// Enable all objects in this tab control object's array of objects to enable.
i_tabmx=UpperBound( igo_tab_cntrl_enble_lst )
For i_jay = 1 to i_tabmx
	If IsValid(igo_tab_cntrl_enble_lst[i_jay])=TRUE Then	// allowed to be null, since can't remove from array
		go_objct_tmp=igo_tab_cntrl_enble_lst[i_jay]
		If uf_tab_cntrl_enbled(TRUE,go_objct_tmp)=FALSE Then
		End If
	End If
Next

// Disable all objects in this tab control object's array of objects to disable.
i_tabmx=UpperBound( igo_tab_cntrl_dsble_lst )
For i_jay = 1 to i_tabmx
	If IsValid(igo_tab_cntrl_dsble_lst[i_jay])=TRUE Then	// allowed to be null, since can't remove from array
		go_objct_tmp=igo_tab_cntrl_dsble_lst[i_jay]
		If uf_tab_cntrl_enbled(FALSE,go_objct_tmp)=FALSE Then
		End If
	End If
Next

end subroutine

public function boolean uf_tab_cntrl_enbled (boolean b_newstte, graphicobject go_objct);CheckBox				CheckBox_tmp
CommandButton		CommandButton_tmp
//CPlusPlusObject		CPlusPlusObject_tmp
DataWindow			DataWindow_tmp
DataWindowChild		DataWindowChild_tmp
DropDownListBox		DropDownListBox_tmp
EditMask				EditMask_tmp
ExtObject				ExtObject_tmp
Graph					Graph_tmp
GroupBox				GroupBox_tmp
ListBox					ListBox_tmp
Menu					Menu_tmp
MultiLineEdit			MultiLineEdit_tmp
OleControl				OleControl_tmp
OleObject				OleObject_tmp
OmControl				OmControl_tmp
OmObject				OmObject_tmp
Picture					Picture_tmp
PictureButton			PictureButton_tmp
RadioButton				RadioButton_tmp
SingleLineEdit			SingleLineEdit_tmp
StaticText				StaticText_tmp
UserObject				UserObject_tmp
Boolean					RtnVal=TRUE

Choose Case go_objct.TypeOf()
	Case CheckBox!
		CheckBox_tmp=go_objct
		CheckBox_tmp.Enabled=b_newstte
	Case CommandButton!
		CommandButton_tmp=go_objct
		CommandButton_tmp.Enabled=b_newstte
//	Case CPlusPlusObject!
//		CPlusPlusObject_tmp=go_objct
//		CPlusPlusObject_tmp.Enabled=b_newstte
	Case DataWindow!
		DataWindow_tmp=go_objct
		DataWindow_tmp.Enabled=b_newstte
//	Case DataWindowChild!
//		DataWindowChild_tmp=go_objct
//		DataWindowChild_tmp.Enabled=b_newstte
	Case DropDownListBox!
		DropDownListBox_tmp=go_objct
		DropDownListBox_tmp.Enabled=b_newstte
	Case EditMask!
		EditMask_tmp=go_objct
		EditMask_tmp.Enabled=b_newstte
//	Case ExtObject!
//		ExtObject_tmp=go_objct
//		ExtObject_tmp.Enabled=b_newstte
	Case Graph!
		Graph_tmp=go_objct
		Graph_tmp.Enabled=b_newstte
	Case GroupBox!
		GroupBox_tmp=go_objct
		GroupBox_tmp.Enabled=b_newstte
	Case ListBox!
		ListBox_tmp=go_objct
		ListBox_tmp.Enabled=b_newstte
	Case Menu!
		Menu_tmp=go_objct
		Menu_tmp.Enabled=b_newstte
	Case MultiLineEdit!
		MultiLineEdit_tmp=go_objct
		MultiLineEdit_tmp.Enabled=b_newstte
	Case OleControl!
		OleControl_tmp=go_objct
		OleControl_tmp.Enabled=b_newstte
//	Case OleObject!
//		OleObject_tmp=go_objct
//		OleObject_tmp.Enabled=b_newstte
	Case OmControl!
		OmControl_tmp=go_objct
		OmControl_tmp.Enabled=b_newstte
//	Case OmObject!
//		OmObject_tmp=go_objct
//		OmObject_tmp.Enabled=b_newstte
	Case Picture!
		Picture_tmp=go_objct
		Picture_tmp.Enabled=b_newstte
	Case PictureButton!
		PictureButton_tmp=go_objct
		PictureButton_tmp.Enabled=b_newstte
	Case RadioButton!
		RadioButton_tmp=go_objct
		RadioButton_tmp.Enabled=b_newstte
	Case SingleLineEdit!
		SingleLineEdit_tmp=go_objct
		SingleLineEdit_tmp.Enabled=b_newstte
	Case StaticText!
		StaticText_tmp=go_objct
		StaticText_tmp.Enabled=b_newstte
	Case UserObject!
		UserObject_tmp=go_objct
		UserObject_tmp.Enabled=b_newstte
	Case Else
		RtnVal=FALSE
End Choose
Return(RtnVal)

end function

event constructor;//Tab Control Object Usage
//
//Place the u_tabcntrl control on your window.  
//Tabs reside on the top edge of the group box aligned to the left.
//
//Name the object according to its functional datawindow, ie. tabgrp1_data for dw_data, etc.  
//The prefix “tabgrp1_” is used because the underlying object is a datawindow and it's a tab control.  
//Each tab object in a group MUST have the same characters as its prefix!!!  
//An instance variable, "ii_prfxlngth", specifies the length to match, and can be 
//	different values for different groups, or higher level groups.  See the possiblities?  
//The default length is eight, but can be overridden in the constructor event.
//
//In the constructor event of the freshly named object, you must identify three things: 
//	1) the objects this tab control is associated with by loading its private control array, for example, 
//		tabgrp1_data.igo_tab_cntrl_lst[1]=dw_data, 
//	    and the first element will receive focus when its tab is clicked; 
//	2) the text associated with the tab, tabgrp1_data.st_tab_txt.Text="Main"; 
//	3) the parent window of the tab, tabgrp1_data.iw_actvesht=parent; 
//
//In the constructor event of the freshly named object, you may identify/override three things: 
//	1) the default length of the name of the group prefix, for example, 
//		ii_prfxlngth=8	// Len("tabgrp1_"); 
//	2) the objects you want enabled when this tab is active by loading its private enable list, 
//		tabgrp1_data. igo_tab_cntrl_enble_lst[1]=cb_update; 
//	3) the objects you want disabled when this tab is active by loading its private disable list, 
//		tabgrp1_data.igo_tab_cntrl_dsble_lst[1]=cb_delete; 
//
//The fake clicked event, "ue_tabclckd", is for actions you want processed when the object is clicked.  
//Currently, those actions are processed before the ancestor's st_tab_txt click event.  
//The fake clicked event, "ue_tabpstclckd", is for actions you want processed when the object is clicked.  
//Currently, those actions are processed after the ancestor's st_tab_txt click event.  
//
//The default condition of the tab object if off disabled.
//So, in the open event of the window, you must tell the tab control objects which is to be the initial tab: 
//	tabgrp1_data.st_tab_txt.PostEvent(Clicked!).

//1/29/2003 - ERW
//ib_sizeabletabs: If this variable is set to true you will be able to resize the tabs at design time

window w_temp
userobject u_temp
ii_prfxlngth=8	// Len("tabgrp1_")
choose case  parent.typeof()


case  window! 
	w_temp  = parent
	controllist = w_temp.control

case UserObject!
	
	u_temp  = parent
	controllist = u_temp.control
End Choose

If (ib_sizeabletabs) Then
	st_tab_txt.width = this.width - 10
	ln_1.EndX = this.width
	ln_2.EndX = this.width
End If

this.triggerevent('ue_refreshtheme')
end event

on u_tabcntrl.create
this.r_back=create r_back
this.ln_top_insde=create ln_top_insde
this.ln_rght_insde=create ln_rght_insde
this.ln_lft_insde=create ln_lft_insde
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_tab_txt=create st_tab_txt
this.Control[]={this.r_back,&
this.ln_top_insde,&
this.ln_rght_insde,&
this.ln_lft_insde,&
this.ln_1,&
this.ln_2,&
this.st_tab_txt}
end on

on u_tabcntrl.destroy
destroy(this.r_back)
destroy(this.ln_top_insde)
destroy(this.ln_rght_insde)
destroy(this.ln_lft_insde)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_tab_txt)
end on

type r_back from rectangle within u_tabcntrl
long linecolor = 12632256
linestyle linestyle = transparent!
integer linethickness = 5
long fillcolor = 8421504
integer width = 558
integer height = 216
end type

type ln_top_insde from line within u_tabcntrl
boolean visible = false
long linecolor = 16777215
integer linethickness = 5
integer beginx = 14
integer beginy = 8
integer endx = 311
integer endy = 8
end type

type ln_rght_insde from line within u_tabcntrl
boolean visible = false
long linecolor = 8421504
integer linethickness = 5
integer beginx = 315
integer beginy = 12
integer endx = 315
integer endy = 84
end type

type ln_lft_insde from line within u_tabcntrl
boolean visible = false
long linecolor = 16777215
integer linethickness = 5
integer beginx = 9
integer beginy = 12
integer endx = 9
integer endy = 88
end type

type ln_1 from line within u_tabcntrl
long linecolor = 8421504
integer linethickness = 5
integer beginy = 88
integer endx = 663
integer endy = 88
end type

type ln_2 from line within u_tabcntrl
long linecolor = 16777215
integer linethickness = 5
integer beginy = 68
integer endx = 699
integer endy = 68
end type

type st_tab_txt from statictext within u_tabcntrl
integer x = 5
integer y = 4
integer width = 521
integer height = 64
integer taborder = 1
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12632256
string text = "tab"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;// The constructor event has copius notes

str_get_mssge_parms	str_mssge_parms
integer					i_eye, i_mx
u_tabcntrl				u_tabcntrl_tmp
graphicobject			go_objct_tmp
boolean					b_frstpss=TRUE

If ib_tabon=FALSE Then

	// process any actions the specified in the fake pre-clicked event of the object
	parent.TriggerEvent("ue_tabclckd")
	// set tab flag on and bring control to top just in case
	
	ib_tabon=TRUE
	//parent.SetPosition(ToTop!)
	this.backcolor = parent.event ue_get_oncolor()
	this.textcolor = 0
	this.height = 90
	this.bringtotop  = true

	
	// Search through window control list to find other tab control objects by their classname.
	// This tab control object's underlying control is a picture.
	// All related tab control objects will have the same classname prefix (for grouping).
	// Send a "Tab Off" event to the other tab control objects in this name group, but not to this tab control object.
	i_mx=UpperBound( controllist )
	For i_eye = 1 to i_mx
		If Left(controllist[i_eye].ClassName(),ii_prfxlngth)=Left(parent.ClassName(),ii_prfxlngth) Then	// is this a tab object in my named group?
			If controllist[i_eye].ClassName()<>parent.ClassName() Then			// is this not me?
				u_tabcntrl_tmp=controllist[i_eye]
				If u_tabcntrl_tmp.ib_tabon=TRUE Then
					u_tabcntrl_tmp.TriggerEvent("ue_taboff")
				End If
			End If
		End If
	Next

// Make all objects in this tab control object's array of objects visible.
// Only graphicobject variables will allow ANY control type to be set visible, so we used "go_objct_tmp".
// First object in list gets focus.
	i_mx=UpperBound( igo_tab_cntrl_lst )
	For i_eye = 1 to i_mx
		If IsValid(igo_tab_cntrl_lst[i_eye])=TRUE Then	// allowed to be null for programmatic changes, since elements can't be removed from array after the constructor event
			go_objct_tmp=igo_tab_cntrl_lst[i_eye]
			go_objct_tmp.Visible=TRUE
			If b_frstpss=TRUE Then
				b_frstpss=FALSE
				If uf_tab_cntrl_focus(go_objct_tmp)=FALSE Then
					
				End If
			End If
		End If
	Next

// Enable all objects in this tab control object's array of objects to enable.
// Disable all objects in this tab control object's array of objects to disable.
	uf_tab_cntrl_status()
// process any actions the specified in the fake post-clicked event of the object
	parent.TriggerEvent("ue_tabpstclckd")

Else
// First object in list gets focus.
	i_mx=UpperBound( igo_tab_cntrl_lst )
	For i_eye = 1 to i_mx
		If IsValid(igo_tab_cntrl_lst[i_eye])=TRUE Then	// allowed to be null for programmatic changes, since elements can't be removed from array after the constructor event
			go_objct_tmp=igo_tab_cntrl_lst[i_eye]
			If b_frstpss=TRUE Then
				b_frstpss=FALSE
				i_eye = i_mx
				If uf_tab_cntrl_focus(go_objct_tmp)=FALSE Then

				End If
			End If
		End If
	Next
End If

end event

