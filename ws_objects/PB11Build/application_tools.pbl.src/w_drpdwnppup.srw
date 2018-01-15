$PBExportHeader$w_drpdwnppup.srw
$PBExportComments$Base window for drop down pop up objects.  Pass a populated str_drpdwnppup structure when opening this window.
forward
global type w_drpdwnppup from w_basewindow
end type
end forward

global type w_drpdwnppup from w_basewindow
integer width = 699
integer height = 524
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
event ue_check_focus pbm_custom55
event ue_setcapture ( )
end type
global w_drpdwnppup w_drpdwnppup

type variables
str_drpdwnppup_prms istr_prms
boolean ib_focus=TRUE
dragobject     ido_source
boolean ib_vrble_wdth=FALSE
boolean ib_reset_on_mke_vsble=FALSE

graphicobject igo_popup

end variables

forward prototypes
public subroutine wf_set_prms (str_drpdwnppup_prms ast_prms)
public function integer wf_pstn_drpdwnppup_frm_em (editmask aem)
public function integer wf_pstn_drpdwnppup ()
public function integer wf_pstn_drpdwnppup_frm_dw (datawindow adw_control, string as_object_name)
end prototypes

on ue_check_focus;call w_basewindow::ue_check_focus;
if not ib_focus then
//	close(this)
	this.visible=FALSE
end if



end on

event ue_setcapture();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_setcapture
//	Overrides:  No
//	Arguments:	
//	Overview:   Sends the clicked event to the datawindow object on uo_calendar.
//             This is done utilizing the win32 SetCapture function.
//	Created by: Pat Newgent
//	History:    12/31/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long	ll_handle
n_win32_api_calls ln_win32

if not isvalid(igo_popup) then return

ln_win32 = Create n_win32_api_calls

ll_handle = handle(igo_popup)

ln_win32.SetCapture(ll_handle)

Destroy ln_win32
end event

public subroutine wf_set_prms (str_drpdwnppup_prms ast_prms);
istr_prms = ast_prms
end subroutine

public function integer wf_pstn_drpdwnppup_frm_em (editmask aem);integer 		li_framex, li_framey, li_WrkSpceHght, li_psntx, li_psnty,&
				li_wndwhght, li_wndwwdth, li_clcmclckdwdth, li_shft
integer		li_uo_offstx, li_uo_offsty
graphicobject lgo_parent
userobject uo_object

//The editmask may be part of a user object.  If so, include the offset of
//  the userobject when positioning the calendar.
if isvalid( istr_prms.u_prnt) then
	li_uo_offstx = istr_prms.u_prnt.x
	li_uo_offsty = istr_prms.u_prnt.y
		
	//----------------------------------------------------------------------------------------------------------------------------------
	// 9/16/98 - Added by RPN
	// If the edit mask is part of a user object, that user object may be part of another user object. Therefore, loop the chain of
	// user objects until you reach a parent of window.  At each loop, add the x and y coordinates of the userobject to the offset
	// x and y coordinates.
	//-----------------------------------------------------------------------------------------------------------------------------------
	uo_object = istr_prms.u_prnt
	lgo_parent = uo_object.getparent()
	DO WHILE lgo_parent.TypeOf() <> Window!
		uo_object = lgo_parent
		li_uo_offstx = li_uo_offstx + uo_object.x
		li_uo_offsty = li_uo_offsty + uo_object.y
		lgo_parent = lgo_parent.GetParent()
	LOOP

end if


/********************Calculate the X coordinates for this**********************/
li_framex = w_mdi_frame.WorkSpaceX()
li_wndwwdth = this.width

//li_psntx = (istr_open_cal.i_pntrx + li_framex) - (this.width - 25)

li_psntx = istr_prms.w_prnt.workspacex() - li_framex
li_psntx += li_uo_offstx
li_psntx += istr_prms.do_cntrl.x
//li_psntx += istr_prms.do_cntrl.width
//li_psntx -= this.width

If li_psntx < 200 Then 
	li_psntx = (this.width / 2) 
End If

If li_psntx + li_wndwwdth > w_mdi_frame.width Then 
	li_psntx = w_mdi_frame.width - li_wndwwdth
End If

this.x = li_psntx
//w_mdi_frame.setmicrohelp( "frm=" + string( li_framex) + &
//	";win=" + string( istr_open_cal.w_prnt.workspacex()) + &
//	";uo=" + string( li_uo_offstx) + &
//	";em=" + string( istr_open_cal.do_cntrl.x) + &
//	";pstn=" + string( li_psntx))

/*********************************************************************************/


/********************Calculate the Y coordinates for this**********************/
li_framey = w_mdi_frame.WorkSpaceY()
li_WrkSpceHght = w_mdi_frame.WorkSpaceHeight()
li_wndwhght = this.height

//li_psnty = istr_open_cal.i_pntry + li_framey + 80 

li_psnty = istr_prms.w_prnt.workspacey() - li_framey
li_psnty += li_uo_offsty
li_psnty += istr_prms.do_cntrl.y
li_psnty += istr_prms.do_cntrl.height + 5

If li_psnty + li_wndwhght > li_WrkSpceHght Then
	li_psnty = (li_psnty + li_framey) - (this.Height + 80)
End If

this.y = li_psnty 
/*********************************************************************************/

return 1


//integer 		li_framex, li_framey, li_WrkSpceHght, li_psntx, li_psnty,&
//				li_wndwhght, li_wndwwdth, li_clcmclckdwdth, li_shft
////
////
///********************Calculate the X coordinates for w_calendar**********************/
//li_framex = w_mdi_frame.WorkSpaceX()
//li_wndwwdth = this.width
//
////li_psntx = (istr_prms.i_pntrx + li_framex) - (this.width - 25)
////li_psntx = 
////
////If li_psntx < 200 Then 
////	li_psntx = (this.width / 2) 
////End If
////
////this.x = li_psntx
/////*********************************************************************************/
////
////
/////********************Calculate the Y coordinates for w_calendar**********************/
////li_framey = w_mdi_frame.WorkSpaceY()
////li_WrkSpceHght = w_mdi_frame.WorkSpaceHeight()
////li_wndwhght = this.height
////
////li_psnty = istr_prms.i_pntry + li_framey + 80 
////
////If li_psnty + li_wndwhght > li_WrkSpceHght Then
////	li_psnty = (istr_prms.i_pntry + li_framey) - (this.Height + 80)
////End If
////
////this.y = li_psnty 
/////*********************************************************************************/
////
//return 1
end function

public function integer wf_pstn_drpdwnppup ();integer 		li_framex, li_framey, li_WrkSpceHght, li_psntx, li_psnty,&
				li_wndwhght, li_wndwwdth, li_clcmclckdwdth, li_shft
datawindow	ldw
editmask		lem
string		ls_col

this.bringtotop=TRUE
choose case typeof( istr_prms.do_cntrl)
	case datawindow!
		ldw = istr_prms.do_cntrl
		if istr_prms.s_clmn > "" then
			ls_col = istr_prms.s_clmn
		else
			ls_col = ldw.getcolumnname()
		end if
		this.wf_pstn_drpdwnppup_frm_dw( ldw, ls_col)

	case editmask!
		lem = istr_prms.do_cntrl
		this.wf_pstn_drpdwnppup_frm_em( lem)

end choose

return 1
end function

public function integer wf_pstn_drpdwnppup_frm_dw (datawindow adw_control, string as_object_name);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   wf_pstn_drpdwnppup_frm_dw()
// Arguments:   	adw_control		The datawindow control from which to calculate the position for this drop down
//						as_object_name	The name of the object that is used to calculate the width of this dropdown.
// Overview:    This function properly places the drop down just below a column on a datawindow control.
// Created by:  Blake Doerr
// History:     3/3/99
//-----------------------------------------------------------------------------------------------------------------------------------


//Declarations
Long ll_xposition, ll_objecty, ll_yposition, ll_group_header_height, ll_group_footer_height, ll_row, ll_firstrowonpage, ll_headercount = 1, ll_index, ll_findrow
window lw_reference

//-----------------------------------------------------------------------------------------------------------------------------------
// Establish the reference window that will be used for positioning the popup
//-----------------------------------------------------------------------------------------------------------------------------------
if istr_prms.w_prnt.WindowType = Response! then
	lw_reference = istr_prms.w_prnt
	ll_objecty = lw_reference.WorkSpaceY() + 10
Else
	IF IsValid(w_mdi_frame) THEN
		lw_reference = w_mdi_frame
		ll_objecty = w_mdi_frame.Y + 16 + w_mdi_frame.GetActiveSheet().Height - w_mdi_frame.GetActiveSheet().WorkSpaceHeight() + 45
	ELSE
		IF IsValid(w_mdi) THEN
			lw_reference = w_mdi
			ll_objecty = w_mdi.Y + 16 + w_mdi.GetActiveSheet().Height - w_mdi.GetActiveSheet().WorkSpaceHeight() + 45
		END IF
	END IF
end if


//To get the X position you just need to subtract the Datawindow EditMask's X and subtract if from the Datawindow.PointerX
//		This gives you the Delta X from the object to the pointer.  Now you just have to subtract that from w_mdi_frame.PointerX
ll_xposition 	= w_mdi.x + w_mdi.PointerX() - (Long(adw_control.describe("DataWindow.HorizontalScrollPosition")) + adw_control.PointerX() - Long(adw_control.describe(as_object_name + ".X")))
//ll_xposition 	= lw_reference.PointerX() - (Long(adw_control.describe("DataWindow.HorizontalScrollPosition")) + adw_control.PointerX() - Long(adw_control.describe(as_object_name + ".X")))

ll_row 				= adw_control.getrow()
ll_firstrowonpage = Long(adw_control.describe("datawindow.firstrowonpage"))

//Y is exactly the same it is just a little more involved to find the Datawindow EditMask's Y.
ll_objecty 		= ll_objecty + Long(adw_control.describe(as_object_name + ".Y")) + Long(adw_control.describe(as_object_name + ".Height"))
ll_objecty  	= ll_objecty  + Long(adw_control.Describe("datawindow.header.Height"))												//There is a 1 PBU per row fudge factor here
//ll_objecty  	= ll_objecty  + (Long(adw_control.Describe("Datawindow.Detail.Height")) * (ll_row - ll_firstrowonpage) - (ll_row - ll_firstrowonpage) * 1)

// Jake Added to handle Datawindows that have collapsed details in primary buffer
long i_i,li_height
string s_evaluate
if ll_firstrowonpage <> ll_row then 
	for i_i = ll_firstrowonpage to (ll_row - 1)
		s_evaluate = adw_control.describe("evaluate('rowheight()'," + string(i_i) + ")")
		li_height = Integer(s_evaluate) + 5
		ll_objecty  	= ll_objecty  + li_height
	next
else
	ll_objecty  	= ll_objecty  + 5
end if

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the height of the group headers if they exist
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To 4
	ll_group_header_height = Long(adw_control.Describe("Datawindow.Header."  + String(ll_index) + ".Height"))
	ll_group_footer_height = Long(adw_control.Describe("Datawindow.Trailer."  + String(ll_index) + ".Height"))

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the group exists, find the number of headers
	//-----------------------------------------------------------------------------------------------------------------------------------
	If (ll_group_header_height > 0 And Not IsNull(ll_group_header_height)) Or (ll_group_footer_height > 0 And Not IsNull(ll_group_footer_height)) Then
		ll_headercount = 1
		ll_findrow = ll_firstrowonpage + 1
		ll_findrow = adw_control.FindGroupChange(ll_findrow, ll_index)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Find all group headers that will contribute to the height
		//-----------------------------------------------------------------------------------------------------------------------------------
		DO WHILE ll_findrow > 0 And ll_findrow <= ll_row
			ll_headercount = ll_headercount + 1
			ll_findrow = adw_control.FindGroupChange(ll_findrow + 1, ll_index)
		LOOP
																											//There is a 1 PBU per group header fudge factor here	
		ll_objecty = ll_objecty + (ll_group_header_height * ll_headercount)  		- (ll_headercount) * 1
		ll_objecty = ll_objecty + (ll_group_footer_height * (ll_headercount - 1)) 	- (ll_headercount - 1) * 1
	End If
Next


//-----------------------------------------------------------------------------------------------------------------------------------
// Calculate the actual y position
//-----------------------------------------------------------------------------------------------------------------------------------
//ll_yposition = w_mdi_frame.PointerY() - (adw_control.PointerY() - ll_objecty)
ll_yposition = lw_reference.PointerY() - (adw_control.PointerY() - ll_objecty) 

//-----------------------------------------------------------------------------------------------------------------------------------
// Adjust the y to be above the column if we are too close to the bottom of the frame
//-----------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------
// Modified positioning to account for response window.
//-----------------------------------------------------------------------------------------------------------------------------------
//If ll_yposition + This.height > w_mdi_frame.WorkSpaceHeight() Then
//	ll_yposition = ll_yposition - This.Height - Long(adw_control.describe( as_object_name + ".height")) - 4	
//End If
If ll_yposition + This.height > w_mdi.WorkSpaceHeight() then 
	ll_yposition = ll_yposition - This.Height - Long(adw_control.describe( as_object_name + ".height")) - 4	
End If

If adw_control.Border = True And adw_control.BorderStyle = StyleRaised! Then
	ll_yposition = ll_yposition + 5
	ll_xposition = ll_xposition + 5
End If

If adw_control.RowCount() = 1 And adw_control.VScrollBar And Long(adw_control.describe("DataWindow.VerticalScrollPosition")) > 0 Then
	ll_yposition = ll_yposition - Long(adw_control.describe("DataWindow.VerticalScrollPosition"))
End If

This.Y = ll_yposition
This.X = ll_xposition + 13

return 1
end function

event open;str_drpdwnppup_prms lstr_prms

lstr_prms = Message.PowerObjectParm

this.wf_set_prms( lstr_prms)

this.wf_pstn_drpdwnppup()
end event

on w_drpdwnppup.create
call super::create
end on

on w_drpdwnppup.destroy
call super::destroy
end on

