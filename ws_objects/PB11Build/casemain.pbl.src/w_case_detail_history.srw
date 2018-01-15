$PBExportHeader$w_case_detail_history.srw
$PBExportComments$Window for viewing the case detail history report.
forward
global type w_case_detail_history from w_main_std
end type
type st_3 from statictext within w_case_detail_history
end type
type p_1 from picture within w_case_detail_history
end type
type st_1 from statictext within w_case_detail_history
end type
type cb_print from u_cb_print within w_case_detail_history
end type
type cb_close from u_cb_close within w_case_detail_history
end type
type dw_case_detail_history from u_dw_std within w_case_detail_history
end type
type ln_3 from line within w_case_detail_history
end type
type ln_4 from line within w_case_detail_history
end type
type ln_1 from line within w_case_detail_history
end type
type ln_2 from line within w_case_detail_history
end type
type st_2 from statictext within w_case_detail_history
end type
end forward

global type w_case_detail_history from w_main_std
integer width = 3506
integer height = 2276
string title = ""
boolean toolbarvisible = true
st_3 st_3
p_1 p_1
st_1 st_1
cb_print cb_print
cb_close cb_close
dw_case_detail_history dw_case_detail_history
ln_3 ln_3
ln_4 ln_4
ln_1 ln_1
ln_2 ln_2
st_2 st_2
end type
global w_case_detail_history w_case_detail_history

type variables
BOOLEAN	i_bOutOfOffice

INTEGER	i_nSecurityLevel

STRING	i_cCaseNumber
STRING	i_cUserID

DATASTORE	i_dsFieldLabels
end variables

forward prototypes
public subroutine fw_checkoutofoffice ()
end prototypes

public subroutine fw_checkoutofoffice ();//********************************************************************************************
//
//  Function: fw_checkoutofoffice
//  Purpose:  To mark the out of office menu item
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  12/15/00 cjackson    Original Verison
//
//********************************************************************************************

LONG l_nCount

// Get userid
i_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

// If the user is currently mark as out of the office, setting the Check on the menu item
SELECT count(*) INTO :l_nCount
  FROM cusfocus.out_of_office
 WHERE out_user_id = :i_cUserID
 USING SQLCA;
 
IF ISVALID(m_create_maintain_case) THEN
	
	// Update the clicked property based on whether not the user if Out of Office 
	IF l_nCount > 0 THEN
		m_create_maintain_case.m_file.m_outofoffice.Check()
		i_bOutOfOffice = TRUE
	ELSE
		m_create_maintain_case.m_file.m_outofoffice.UnCheck()
		i_bOutOfOffice = FALSE
	END IF

END IF


end subroutine

on w_case_detail_history.create
int iCurrent
call super::create
this.st_3=create st_3
this.p_1=create p_1
this.st_1=create st_1
this.cb_print=create cb_print
this.cb_close=create cb_close
this.dw_case_detail_history=create dw_case_detail_history
this.ln_3=create ln_3
this.ln_4=create ln_4
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.cb_close
this.Control[iCurrent+6]=this.dw_case_detail_history
this.Control[iCurrent+7]=this.ln_3
this.Control[iCurrent+8]=this.ln_4
this.Control[iCurrent+9]=this.ln_1
this.Control[iCurrent+10]=this.ln_2
this.Control[iCurrent+11]=this.st_2
end on

on w_case_detail_history.destroy
call super::destroy
destroy(this.st_3)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.dw_case_detail_history)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_2)
end on

event pc_setoptions;call super::pc_setoptions;/****************************************************************************************
	Event:	pc_setoptions
	Purpose:	Open the window and initialize it's settings.
	
	Revisions:
	Date     Developer    Description
	======== ============ ================================================================
	09/24/99 M. Caruso    Created.
****************************************************************************************/

STRING l_cSQL, l_cSyntax, l_cError

fw_SetOptions (c_Default + c_ToolbarTop)

fw_CheckOutOfOffice ()
end event

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_setvariables
   Purpose:    initialize variables needed for retrieval.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/08/01 M. Caruso    Created.
	06/19/03 M. Caruso    Added code to initialize the i_dsFieldLabels datastore.
*****************************************************************************************/

i_cCaseNumber = PCCA.Parm[1]
i_nSecurityLevel = INTEGER (PCCA.Parm[2])

i_dsFieldLabels = CREATE DataStore
i_dsFieldLabels.DataObject = 'd_field_labels'
i_dsFieldLabels.SetTransObject(SQLCA)
i_dsFieldLabels.Retrieve()
end event

event pc_close;call super::pc_close;/****************************************************************************************
	Event:	pc_close
	Purpose:	Perform cleanup of objects CREATED on this window.
	
	Revisions:
	Date     Developer    Description
	======== ============ ================================================================
	06/19/33 M. Caruso    Created.
****************************************************************************************/

IF IsValid (i_dsFieldLabels) THEN DESTROY i_dsFieldLabels
end event

event resize;call super::resize;long ll_wrkspce_height, ll_wrkspce_width

ll_wrkspce_height = this.workspaceheight()
ll_wrkspce_width = this.workspacewidth()

st_1.width = ll_wrkspce_width
st_2.width = st_1.width
ln_1.endx = st_1.width
ln_2.endx = st_1.width
ln_3.endx = st_1.width
ln_4.endx = st_1.width

dw_case_detail_history.width = ll_wrkspce_width - (2 * dw_case_detail_history.x)
dw_case_detail_history.height = ll_wrkspce_height - (2 * dw_case_detail_history.y) - 10

st_2.y = ll_wrkspce_height - st_2.height
ln_1.beginy = st_2.y - 4
ln_1.endy = st_2.y - 4

ln_2.beginy = ln_1.beginy - 4
ln_2.endy = ln_1.beginy - 4

cb_print.y = st_2.y + 44
cb_close.y = st_2.y + 44
cb_close.x = ll_wrkspce_width - 526
cb_print.x = ll_wrkspce_width - 526 - 453
end event

type st_3 from statictext within w_case_detail_history
integer x = 201
integer y = 60
integer width = 1691
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Case Detail History"
boolean focusrectangle = false
end type

type p_1 from picture within w_case_detail_history
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_1 from statictext within w_case_detail_history
integer width = 3863
integer height = 168
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type cb_print from u_cb_print within w_case_detail_history
integer x = 2491
integer y = 2032
integer width = 411
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

type cb_close from u_cb_close within w_case_detail_history
integer x = 2944
integer y = 2032
integer width = 411
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean default = true
end type

type dw_case_detail_history from u_dw_std within w_case_detail_history
integer y = 188
integer width = 3438
integer height = 1776
integer taborder = 10
string dataobject = "d_case_detail_history_report"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;/****************************************************************************************
  PC Module     : u_DW_Std
  Event         : pcd_Retrieve
  Description   : Retrieve data from the database for this
                  DataWindow.

  Parameters    : DATAWINDOW Parent_DW -
            	        Parent of this DataWindow.  If this 
                     DataWindow is root-level, this value will
                     be NULL.
                  LONG       Num_Selected -
                     The number of selected records in the
                     parent DataWindow.
                  LONG       Selected_Rows[] -
                     The row numbers of the selected records
                     in the parent DataWindow.

  Return Value  : Error.i_FWError -
                     c_Success - the event completed succesfully.
                     c_Fatal   - the event encountered an error.

  Change History:

  Date     Person     Description of Change
  -------- ---------- -------------------------------------------------------------------
  9/24/99  M. Caruso  Created.
****************************************************************************************/

LONG	l_nRtn

l_nRtn = Retrieve (PARENT.i_cCaseNumber, PARENT.i_nSecurityLevel)

IF l_nRtn < 0 THEN
   Error.i_FWError = c_Fatal
ELSE
	Error.i_FWError = c_Success
	
	// update the window title to include the current case number
	Parent.Title = Parent.Title + " - Case #" + i_cCaseNumber
END IF




end event

event pcd_setoptions;call super::pcd_setoptions;/****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Set the default behavior of the datawindow.
	
	Revisions:
	Date     Developer    Description
	======== ============ ================================================================
	9/24/99  M. Caruso    Created.
	01/08/01 M. Caruso    Added c_NoEnablePopup to property list.  Zoom datawindow to 90%.
	01/13/01 M. Caruso    Set the application name in the header of the report.
****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_NoEnablePopup)

Object.appname_t.Text = gs_appname

Object.Datawindow.Zoom = 90
end event

event pcd_print;//***************************************************************************************
//  Event         : pcd_Print
//  Description   : Print the contents of the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- -----------------------------------------------------------------
//  01/08/01 M. Caruso  Created based on ancestor script which is overridden.  Sets zoom
//								to 100% before printing, then back to the original setting after.
//***************************************************************************************

INTEGER	l_nOrigZoom

//------------------------------------------------------------------
//  If this event is being processed by the function for the
//  developer to extend then just return.
//------------------------------------------------------------------

IF i_InProcess THEN
	RETURN
END IF

SetRedraw (FALSE)
l_nOrigZoom = INTEGER (Object.Datawindow.Zoom)
Object.Datawindow.Zoom = 100

//------------------------------------------------------------------
//  Indicate we are running the function from an event and call the
//  function.
//------------------------------------------------------------------

i_FromEvent = TRUE
IF fu_Print() <> c_Success THEN
	Error.i_FWError = c_Fatal
END IF
i_FromEvent = FALSE

Object.Datawindow.Zoom = l_nOrigZoom
SetRedraw (TRUE)
end event

type ln_3 from line within w_case_detail_history
long linecolor = 16777215
integer linethickness = 4
integer beginy = 172
integer endx = 3909
integer endy = 172
end type

type ln_4 from line within w_case_detail_history
long linecolor = 8421504
integer linethickness = 4
integer beginy = 168
integer endx = 3909
integer endy = 168
end type

type ln_1 from line within w_case_detail_history
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1984
integer endx = 4000
integer endy = 1984
end type

type ln_2 from line within w_case_detail_history
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1980
integer endx = 4101
integer endy = 1980
end type

type st_2 from statictext within w_case_detail_history
integer x = 5
integer y = 1988
integer width = 3840
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217730
boolean focusrectangle = false
end type

