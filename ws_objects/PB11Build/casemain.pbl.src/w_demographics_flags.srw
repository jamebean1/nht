$PBExportHeader$w_demographics_flags.srw
$PBExportComments$Window for setting demographics flags
forward
global type w_demographics_flags from w_response
end type
type p_1 from picture within w_demographics_flags
end type
type st_3 from statictext within w_demographics_flags
end type
type mle_flag_description from multilineedit within w_demographics_flags
end type
type st_flag_desc from statictext within w_demographics_flags
end type
type dw_selected_flags from u_dw_std within w_demographics_flags
end type
type cb_remove from commandbutton within w_demographics_flags
end type
type cb_add from commandbutton within w_demographics_flags
end type
type cb_close from commandbutton within w_demographics_flags
end type
type cb_save from commandbutton within w_demographics_flags
end type
type dw_special_flags from u_dw_std within w_demographics_flags
end type
type ln_1 from line within w_demographics_flags
end type
type ln_2 from line within w_demographics_flags
end type
type ln_4 from line within w_demographics_flags
end type
type ln_3 from line within w_demographics_flags
end type
type st_1 from statictext within w_demographics_flags
end type
type st_2 from statictext within w_demographics_flags
end type
end forward

global type w_demographics_flags from w_response
integer width = 3287
integer height = 1760
string title = "Special Demographics Flags"
p_1 p_1
st_3 st_3
mle_flag_description mle_flag_description
st_flag_desc st_flag_desc
dw_selected_flags dw_selected_flags
cb_remove cb_remove
cb_add cb_add
cb_close cb_close
cb_save cb_save
dw_special_flags dw_special_flags
ln_1 ln_1
ln_2 ln_2
ln_4 ln_4
ln_3 ln_3
st_1 st_1
st_2 st_2
end type
global w_demographics_flags w_demographics_flags

type variables

end variables

on w_demographics_flags.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_3=create st_3
this.mle_flag_description=create mle_flag_description
this.st_flag_desc=create st_flag_desc
this.dw_selected_flags=create dw_selected_flags
this.cb_remove=create cb_remove
this.cb_add=create cb_add
this.cb_close=create cb_close
this.cb_save=create cb_save
this.dw_special_flags=create dw_special_flags
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_4=create ln_4
this.ln_3=create ln_3
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.mle_flag_description
this.Control[iCurrent+4]=this.st_flag_desc
this.Control[iCurrent+5]=this.dw_selected_flags
this.Control[iCurrent+6]=this.cb_remove
this.Control[iCurrent+7]=this.cb_add
this.Control[iCurrent+8]=this.cb_close
this.Control[iCurrent+9]=this.cb_save
this.Control[iCurrent+10]=this.dw_special_flags
this.Control[iCurrent+11]=this.ln_1
this.Control[iCurrent+12]=this.ln_2
this.Control[iCurrent+13]=this.ln_4
this.Control[iCurrent+14]=this.ln_3
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.st_2
end on

on w_demographics_flags.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_3)
destroy(this.mle_flag_description)
destroy(this.st_flag_desc)
destroy(this.dw_selected_flags)
destroy(this.cb_remove)
destroy(this.cb_add)
destroy(this.cb_close)
destroy(this.cb_save)
destroy(this.dw_special_flags)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_4)
destroy(this.ln_3)
destroy(this.st_1)
destroy(this.st_2)
end on

event open;call super::open;//**********************************************************************************************
//
//  Event:   open
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  1/3/2001 K. Claver   Added code to set the title and swap the datawindows according to the
//								 source type
//
//**********************************************************************************************

THIS.Title = 'Special Demographics Flags for '+w_create_maintain_case.i_cCaseSubjectName

IF w_create_maintain_case.i_CSourceType = 'E' THEN
	dw_selected_flags.fu_Swap('d_special_flags_groups', &
									  dw_selected_flags.c_IgnoreChanges, &
									  dw_selected_flags.c_DeleteOK+ &
									  dw_selected_flags.c_SelectOnClick+ &
									  dw_selected_flags.c_MultiSelect+ &
									  dw_selected_flags.c_ModifyOK+ &
									  dw_selected_flags.c_ModifyOnOpen+ &
									  dw_selected_flags.c_SortClickedOK+ &
									  dw_selected_flags.c_NoEnablePopup )
ELSE
	dw_selected_flags.fu_Swap('d_special_flags_other', &
									  dw_selected_flags.c_IgnoreChanges, &
									  dw_selected_flags.c_DeleteOK+ &
									  dw_selected_flags.c_SelectOnClick+ &
									  dw_selected_flags.c_MultiSelect+ &
									  dw_selected_flags.c_ModifyOK+ &
									  dw_selected_flags.c_ModifyOnOpen+ &
									  dw_selected_flags.c_SortClickedOK+ &
									  dw_selected_flags.c_NoEnablePopup )
END IF
end event

event close;call super::close;//**********************************************************************************************
//
//  Event:   close
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  1/3/2001 K. Claver   Copied code created by CJackson to re-retrieve the special flags datawindow 
//								 on the demographics tab if it is instantiated
//  06/04/01 C. Jackson  If source type is provider, use provider_key rather than provider_id
//
//**********************************************************************************************
String l_cGroupID

// Re-retreive special flags if Demographics tab is open
IF ISVALID(w_create_maintain_case.i_uodemographics) THEN
	IF w_create_maintain_case.i_cSourceType = 'C' THEN
		SELECT group_id INTO :l_cGroupID
		  FROM cusfocus.consumer
		 WHERE consumer_id = :w_create_maintain_case.i_cCurrentCaseSubject
		 USING SQLCA;
		 
		w_create_maintain_case.i_uoDemographics.dw_display_special_flags.&
		  Retrieve(w_create_maintain_case.i_cCurrentCaseSubject, l_cGroupID)
		  
	ELSE
		
		IF w_create_maintain_case.i_cSourceType = 'P' THEN
			w_create_maintain_case.i_uoDemographics.dw_display_special_flags.Retrieve &
			(w_create_maintain_case.i_cProviderKey,w_create_maintain_case.i_cSourceType)
		ELSE
			w_create_maintain_case.i_uoDemographics.dw_display_special_flags.Retrieve &
			(w_create_maintain_case.i_cCurrentCaseSubject,w_create_maintain_case.i_cSourceType)
			
		END IF
		
	END IF
END IF
end event

event resize;call super::resize;st_1.width = this.workspacewidth()
st_2.width = st_1.width
ln_1.endx = st_1.width
ln_2.endx = st_1.width
ln_3.endx = st_1.width
ln_4.endx = st_1.width
end event

type p_1 from picture within w_demographics_flags
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_3 from statictext within w_demographics_flags
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
string text = "Attach a file"
boolean focusrectangle = false
end type

type mle_flag_description from multilineedit within w_demographics_flags
integer x = 14
integer y = 1072
integer width = 773
integer height = 336
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_flag_desc from statictext within w_demographics_flags
integer x = 18
integer y = 992
integer width = 443
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Flag Description"
boolean focusrectangle = false
end type

type dw_selected_flags from u_dw_std within w_demographics_flags
integer x = 1202
integer y = 192
integer width = 2025
integer height = 1216
integer taborder = 20
string dataobject = "d_special_flags_groups"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_setoptions;call super::pcd_setoptions;//**********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: Please see PowerClass documentation for this event
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  1/3/2001 K. Claver   Added call to fu_setoptions to define datawindow behavior
//
//**********************************************************************************************
THIS.fu_SetOptions( SQLCA, & 
						  THIS.c_NullDW, & 
						  THIS.c_DeleteOK+ &
						  THIS.c_SelectOnClick+ &
						  THIS.c_MultiSelect+ &
						  THIS.c_ModifyOK+ &
						  THIS.c_ModifyOnOpen+ &
						  THIS.c_SortClickedOK+ &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_ShowHighlight )
end event

event pcd_retrieve;call super::pcd_retrieve;//***********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: Please see PowerClass documentation for this event.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  1/3/2001 K. Claver  Added code to retrieve the datawindow.
//  06/04/01 C. Jackson If source type is provider, use provider_key rather than provider_id
//
//***********************************************************************************************
LONG l_nReturn

IF w_create_maintain_case.i_cSourceType = 'P' THEN
	l_nReturn = THIS.Retrieve( w_create_maintain_case.i_cProviderKey, &
								   w_create_maintain_case.i_cSourceType)
ELSE
	l_nReturn = THIS.Retrieve( w_create_maintain_case.i_cCurrentCaseSubject, &
									w_create_maintain_case.i_cSourceType)
									
END IF									

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF
end event

event clicked;call super::clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Please see PB documentation for this event.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  1/3/2001 K. Claver  Added code to display the description in the multi line edit
//
//***********************************************************************************************
IF row > 0 THEN
	//Added this little bit of code 'cause PB sucks and the fu_Select function works
	//  intermittently.  I found this out by putting a messagebox in the function just
	//  before the selectrow is called.  With the messagebox is there, the function works
	//  just fine.  Take it out and it selects the rows intermittently if just clicking on them.
	IF NOT THIS.IsSelected( row ) AND NOT KeyDown( KeyControl! ) THEN
		THIS.SelectRow( row, TRUE )
	END IF
	
	mle_flag_description.Text = THIS.Object.special_flags_flag_desc[ row ]
	dw_special_flags.SelectRow( 0, FALSE )
END IF
end event

event pcd_savebefore;//**********************************************************************************************
//
//  Event:   pcd_savebefore
//  Purpose: Please see PowerClass documentation for this event
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  1/3/2001 K. Claver   Added code to fill in the required values before save
//  06/04/01 C. Jackson  If this is a provider, use the providerkey rather than provider_id
//
//**********************************************************************************************
String l_cUser, l_cFlagID
DateTime l_dtCurrentDate
DWItemStatus l_dwisStatus
Integer l_nIndex

l_cUser = OBJCA.WIN.fu_GetLogin( SQLCA )

IF IsValid( w_create_maintain_case ) THEN 
	l_dtCurrentDate = w_create_maintain_case.fw_GetTimeStamp( )
ELSE
	l_dtCurrentDate = DateTime( Today( ), Now( ) )
END IF

IF THIS.RowCount( ) > 0 THEN
	FOR l_nIndex = 1 TO THIS.RowCount( )
		l_dwisStatus = THIS.GetItemStatus( l_nIndex, 0, Primary! )
		IF l_dwisStatus = New! OR l_dwisStatus = DataModified! OR &
			l_dwisStatus = NewModified! THEN
			IF l_dwisStatus = New! OR l_dwisStatus = NewModified! THEN
				
				THIS.Object.assigned_special_flags_assigned_flag_id[ l_nIndex ] = w_create_maintain_case.fw_getkeyvalue('assigned_special_flags')
				
				l_cFlagID = THIS.Object.special_flags_flag_id[ l_nIndex ]
				
				THIS.Object.flag_id[ l_nIndex ] = l_cFlagID
				
				IF w_create_maintain_case.i_cSourceType = 'P' THEN
					THIS.Object.assigned_special_flags_source_id[ l_nIndex ] = w_create_maintain_case.i_cProviderKey
				ELSE
					THIS.Object.assigned_special_flags_source_id[ l_nIndex ] = w_create_maintain_case.i_cCurrentCaseSubject
				END IF
				
				THIS.Object.assigned_special_flags_source_type[ l_nIndex ] = w_create_maintain_case.i_cSourceType
			END IF
			
			THIS.Object.assigned_special_flags_updated_by[ l_nIndex ] = l_cUser
			THIS.Object.assigned_special_flags_updated_timestamp[ l_nIndex ] = l_dtCurrentDate
		END IF
	NEXT
END IF
		
end event

type cb_remove from commandbutton within w_demographics_flags
integer x = 837
integer y = 572
integer width = 320
integer height = 108
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "<<"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  1/3/2001 K. Claver   Added code to move rows between datawindows
//
//**********************************************************************************************
Integer l_nIndex, l_nSelected
Long l_nSelectedRows[ ]

IF dw_selected_flags.RowCount( ) > 0 THEN
	dw_special_flags.SetRedraw( FALSE )
	dw_selected_flags.SetRedraw( FALSE )
	
	dw_selected_flags.fu_GetSelectedRows( l_nSelectedRows )
	FOR l_nIndex = UpperBound( l_nSelectedRows ) TO 1 STEP -1
		l_nSelected = l_nSelectedRows[ l_nIndex ]
		
		dw_selected_flags.RowsCopy( l_nSelected, l_nSelected, Primary!, &
											 dw_special_flags, 1, Primary! )
											 
		dw_selected_flags.RowsMove( l_nSelected, l_nSelected, Primary!, &
											 dw_selected_flags, 1, Delete! )
	NEXT
	
	dw_special_flags.SelectRow( 0, FALSE )
	dw_selected_flags.SelectRow( 0, FALSE )
	mle_flag_description.Text = ""
	
	dw_special_flags.Sort( )
	
	dw_special_flags.SetRedraw( TRUE )
	dw_selected_flags.SetRedraw( TRUE )
END IF
end event

type cb_add from commandbutton within w_demographics_flags
integer x = 837
integer y = 432
integer width = 320
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">>"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  1/3/2001 K. Claver   Added code to move rows between datawindows
//
//**********************************************************************************************
Integer l_nIndex, l_nSelected
Long l_nSelectedRows[ ]

IF dw_special_flags.RowCount( ) > 0 THEN
	dw_special_flags.SetRedraw( FALSE )
	dw_selected_flags.SetRedraw( FALSE )
	
	dw_special_flags.fu_GetSelectedRows( l_nSelectedRows )
	FOR l_nIndex = UpperBound( l_nSelectedRows ) TO 1 STEP -1
		l_nSelected = l_nSelectedRows[ l_nIndex ]
		
		dw_special_flags.RowsMove( l_nSelected, l_nSelected, Primary!, &
											dw_selected_flags, 1, &
											Primary! )												  
	NEXT
	
	dw_special_flags.SelectRow( 0, FALSE )
	dw_selected_flags.SelectRow( 0, FALSE )
	mle_flag_description.Text = ""
	
	dw_selected_flags.Sort( )
	
	dw_special_flags.SetRedraw( TRUE )
	dw_selected_flags.SetRedraw( TRUE )
END IF
end event

type cb_close from commandbutton within w_demographics_flags
integer x = 2871
integer y = 1544
integer width = 320
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: To close window
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  12/21/00 C. Jackson  Original Version
//
//************************************************************************************************

CLOSE(PARENT)


end event

type cb_save from commandbutton within w_demographics_flags
integer x = 2510
integer y = 1544
integer width = 320
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  1/3/2001 K. Claver   Added code to save the changes to the assigned special flags
//
//***********************************************************************************************
Integer l_nReturn, l_nRowCount, l_nIndex

IF w_create_maintain_case.i_cSourceType = 'P' THEN
	l_nRowCount = dw_selected_flags.RowCount()
	FOR l_nIndex = 1 TO l_nRowCount
		dw_selected_flags.SetItem(l_nIndex,'assigned_special_flags_source_id',w_create_maintain_case.i_cProviderKey)
	NEXT
END IF
l_nReturn = dw_selected_flags.fu_Save( dw_selected_flags.c_SaveChanges )

IF l_nReturn = 0 THEN
	Close( PARENT )
END IF
end event

type dw_special_flags from u_dw_std within w_demographics_flags
integer x = 14
integer y = 192
integer width = 773
integer height = 788
integer taborder = 10
string dataobject = "d_special_flags"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;//***********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: To retrieve the Special Flags available for assigning
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  11/21/00 C. Jackson  Original Version
//
//***********************************************************************************************

LONG l_nReturn
Integer l_nRow

IF w_create_maintain_case.i_cSourceType = 'P' THEN
	l_nReturn = THIS.Retrieve( w_create_maintain_case.i_cProviderKey, &
									w_create_maintain_case.i_cSourceType)
ELSE
	l_nReturn = THIS.Retrieve( w_create_maintain_case.i_cCurrentCaseSubject, &
									w_create_maintain_case.i_cSourceType)
END IF

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
ELSE
	l_nRow = dw_special_flags.GetSelectedRow( 0 )
	IF l_nRow > 0 THEN
		mle_flag_description.Text = THIS.Object.special_flags_flag_desc[ l_nRow ]
	END IF
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;//**********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: Event to set options for the datawindow
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  11/21/00 C. Jackson  Original Version
//	 1/3/2001 K. Claver   Changed to not allow saving on this datawindow.
//
//**********************************************************************************************
fu_SetOptions( SQLCA, &
					c_NullDW, &
					c_NoEnablePopup+ &
					c_SelectOnClick+ &
					c_MultiSelect+ &
					c_ShowHighlight+ &
					c_NoMenuButtonActivation+ &
					c_SortClickedOK )
end event

event clicked;call super::clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Please see PB documentation for this event.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  1/3/2001 K. Claver  Added code to display the description in the multi line edit
//
//***********************************************************************************************
IF row > 0 THEN
	mle_flag_description.Text = THIS.Object.special_flags_flag_desc[ row ]
	dw_selected_flags.SelectRow( 0, FALSE )
END IF
end event

type ln_1 from line within w_demographics_flags
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1492
integer endx = 4101
integer endy = 1492
end type

type ln_2 from line within w_demographics_flags
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1488
integer endx = 4101
integer endy = 1488
end type

type ln_4 from line within w_demographics_flags
long linecolor = 8421504
integer linethickness = 4
integer beginy = 168
integer endx = 3602
integer endy = 168
end type

type ln_3 from line within w_demographics_flags
long linecolor = 16777215
integer linethickness = 4
integer beginy = 172
integer endx = 3602
integer endy = 172
end type

type st_1 from statictext within w_demographics_flags
integer width = 3557
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

type st_2 from statictext within w_demographics_flags
integer x = 5
integer y = 1496
integer width = 3593
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

