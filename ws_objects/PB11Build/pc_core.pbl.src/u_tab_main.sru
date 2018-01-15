$PBExportHeader$u_tab_main.sru
$PBExportComments$Base tab object with resize service
forward
global type u_tab_main from tab
end type
end forward

global type u_tab_main from tab
integer width = 1152
integer height = 864
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
event resize pbm_size
end type
global u_tab_main u_tab_main

type variables
//resize service
n_cst_resize	inv_resize

//Save on tab change
Boolean i_bSaveTabChange = FALSE

//constants
CONSTANT INTEGER	c_Fatal			= -1
CONSTANT INTEGER	c_Success		= 0

CONSTANT INTEGER	c_PromptChanges		= 1
CONSTANT INTEGER	c_IgnoreChanges		= 2
CONSTANT INTEGER	c_SaveChanges		= 3
end variables

forward prototypes
public function integer of_setresize (boolean ab_switch)
end prototypes

event resize;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  resize
//
//	Description:
//	Send resize notification to services
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

// Notify the resize service that the object size has changed.
If IsValid (inv_resize) Then
	inv_resize.Event pfc_Resize (sizetype, This.Width, This.Height)
End If
end event

public function integer of_setresize (boolean ab_switch);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_SetResize
//
//	Access:  public
//
//	Arguments:		
//	ab_switch   starts/stops the window resize service
//
//	Returns:  integer
//	 1 = success
//	 0 = no action necessary
//	-1 = error
//
//	Description:
//	Starts or stops the window resize service
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Integer	li_rc

// Check arguments
If IsNull (ab_switch) Then
	Return -1
End If

If ab_Switch Then
	If IsNull(inv_resize) Or Not IsValid (inv_resize) Then
		inv_resize = Create n_cst_resize
		inv_resize.of_SetOrigSize (This.Width, This.Height)
		li_rc = 1
	End If
Else
	If IsValid (inv_resize) Then
		Destroy inv_resize
		li_rc = 1
	End If
End If

Return li_rc

end function

event destructor;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  destructor
//
//	Description:
//	Perform cleanup.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0.04   Initial version
// 6.0		Enhanced to cleanup new services.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

// Destroy instantiated services
of_SetResize(False)
end event

event selectionchanging;/****************************************************************************************

	Event:	selectionchanging
	Purpose:	Please see PB documentation for this event.
				
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	12/22/2000 K. Claver   If a datawindow has a required field or has validation set for
								  the field, trigger the accepttext function to trigger the validation.
****************************************************************************************/
Datawindow l_dwTemp
UserObject l_tpTabPage
Integer l_nTPIndex, l_nRV
Any l_aRV

IF i_bSaveTabChange THEN
	//Loop through datawindows on the tabpage and fire accepttext on it
	IF Error.i_FWError <> c_Fatal THEN
		IF oldindex > 0 THEN
			l_tpTabPage = THIS.Control[ oldindex ]
			
			FOR l_nTPIndex = 1 TO UpperBound( l_tpTabPage.Control )
				IF l_tpTabPage.Control[ l_nTPIndex ].TypeOf( ) = DataWindow! THEN
					l_dwTemp = l_tpTabPage.Control[ l_nTPIndex ]
					l_nRV = l_dwTemp.AcceptText( )
					
					IF l_nRV = -1 THEN
						Error.i_FWError = c_Fatal
						EXIT
					ELSE
						//Try to save the datawindow.  If fails, don't change tabs.
						//  Had to use a dynamic event here because can't assume all
						//  datawindows on the tab pages are inherited from u_dw_std.
						l_aRV = l_dwTemp.Event Dynamic Trigger pcd_dynsave( )
						
						//If the event doesn't exist on the datawindow, will return null.
						IF NOT IsNull( l_aRV ) THEN
							l_nRV = Integer( l_aRV )
						
							IF l_nRV = -1 THEN
								Error.i_FWError = c_Fatal
								EXIT
							END IF
						END IF
					END IF
					
					Error.i_FWError = c_Success
				END IF
			NEXT
		END IF
	END IF
	
	IF Error.i_FWError = c_Fatal THEN
		RETURN 1
	END IF
END IF
end event

