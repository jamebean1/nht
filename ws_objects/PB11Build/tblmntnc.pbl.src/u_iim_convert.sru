$PBExportHeader$u_iim_convert.sru
forward
global type u_iim_convert from u_container_std
end type
type st_status from statictext within u_iim_convert
end type
type mle_convert_info from multilineedit within u_iim_convert
end type
type cb_begin from commandbutton within u_iim_convert
end type
end forward

global type u_iim_convert from u_container_std
integer width = 3479
integer height = 1612
event ue_convert ( )
st_status st_status
mle_convert_info mle_convert_info
cb_begin cb_begin
end type
global u_iim_convert u_iim_convert

event ue_convert;/*****************************************************************************************
   Event:      ue_convert
   Purpose:    Convert text versions of iim_tabs to blobs

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/18/2000  K. Claver  Created.
*****************************************************************************************/
Boolean l_bError = FALSE, l_bRetrieveError = FALSE
String l_cTabTitle, l_cSummarySyntax, l_cDetailSyntax, l_cMessage
String l_cSQLSyntax, l_cDWSyntax, l_cSyntaxError
Blob l_bSummarySyntax, l_bDetailSyntax
DataStore l_dsTabs
Integer l_nRows, l_nIndex, l_nTabID

SetPointer( Hourglass! )

mle_Convert_Info.Text = ""

//Create the datastore SQL syntax
l_cSQLSyntax = "SELECT cusfocus.iim_tabs.tab_id, "+ &
			 				 "cusfocus.iim_tabs.tab_title "+ & 
					"FROM cusfocus.iim_tabs "
					
//Create the datastore syntax					
l_cDWSyntax = SQLCA.SyntaxFromSQL( l_cSQLSyntax, "", l_cSyntaxError )

IF l_cSyntaxError = "" THEN
	//Create the datastore with the syntax
	l_dsTabs = CREATE DataStore
	l_dsTabs.Create( l_cDWSyntax )
	l_dsTabs.SetTransObject( SQLCA )
	l_nRows = l_dsTabs.Retrieve( )
	
	IF l_nRows = 0 THEN
		l_cMessage = "Error retrieving tab information or no rows to retrieve~r~n~r~n"
		mle_Convert_Info.Text += l_cMessage
		l_bError = TRUE
	END IF
ELSE
	l_bError = TRUE
END IF

FOR l_nIndex = 1 TO l_nRows
	l_nTabID = l_dsTabs.GetItemNumber( l_nIndex, 1 )
	l_cTabTitle = l_dsTabs.GetItemString( l_nIndex, 2 )
	
	//Begin embedded sql to get the summary and detail syntax
	SELECT cusfocus.iim_tabs.tab_summary_syntax,
			 cusfocus.iim_tabs.tab_detail_syntax
	INTO :l_cSummarySyntax, :l_cDetailSyntax
	FROM cusfocus.iim_tabs
	WHERE cusfocus.iim_tabs.tab_id = :l_nTabID
	USING SQLCA;	
	
	IF SQLCA.SQLCode < 0 THEN
		l_cMessage = "Error retrieving tab syntax information~r~n~r~n"
		mle_Convert_Info.Text += l_cMessage
		l_bRetrieveError = TRUE
	ELSE
		l_bSummarySyntax = Blob( Trim( l_cSummarySyntax ) )
		l_bDetailSyntax = Blob( Trim( l_cDetailSyntax ) )
		
		IF NOT IsNull( l_bSummarySyntax ) THEN
			//Update the summary blob
			UPDATEBLOB cusfocus.iim_tabs
			SET cusfocus.iim_tabs.tab_summary_image = :l_bSummarySyntax
			WHERE cusfocus.iim_tabs.tab_id = :l_nTabID
			USING SQLCA;
			
			IF SQLCA.SQLCode < 0 THEN
				l_cMessage = "Update of table with summary syntax blob failed for Tab ID: "+ &
								 String( l_nTabID )+", Tab Title: "+l_cTabTitle+".~r~n"+&
								 "Detail syntax will not be converted~r~n~r~n"
				mle_Convert_Info.Text += l_cMessage
				l_bError = TRUE
				
				//No Summary, no detail
				CONTINUE
			ELSE
				l_cMessage = "Summary syntax conversion SUCCESSFUL for Tab ID: "+ &
								 String( l_nTabID )+", Tab Title: "+l_cTabTitle+"~r~n~r~n"
				mle_Convert_Info.Text += l_cMessage
			END IF
		END IF
		
		IF NOT IsNull( l_bDetailSyntax ) THEN
			//Update the detail blob
			UPDATEBLOB cusfocus.iim_tabs
			SET cusfocus.iim_tabs.tab_detail_image = :l_bDetailSyntax
			WHERE cusfocus.iim_tabs.tab_id = :l_nTabID
			USING SQLCA;
			
			IF SQLCA.SQLCode < 0 THEN
				l_cMessage = "Update of table with detail syntax blob failed for Tab ID: "+ &
								 String( l_nTabID )+", Tab Title: "+l_cTabTitle+"~r~n~r~n"
				mle_Convert_Info.Text += l_cMessage
				l_bError = TRUE
			ELSE
				l_cMessage = "Detail syntax conversion SUCCESSFUL for Tab ID: "+ &
								 String( l_nTabID )+", Tab Title: "+l_cTabTitle+"~r~n~r~n"
				mle_Convert_Info.Text += l_cMessage
			END IF
		END IF
	END IF	
NEXT

IF ( NOT l_bError ) AND ( NOT l_bRetrieveError ) THEN
	//Disable the conversion button
	cb_Begin.Enabled = FALSE
	
	//Update the active setting for the conversion table maintenance item to 'N'
	//  so it won't show on the list.
	UPDATE cusfocus.user_maintainable_tables
	SET cusfocus.user_maintainable_tables.active = 'N'
	WHERE cusfocus.user_maintainable_tables.db_table_name = 'iim_conv'
	USING SQLCA;
	
	IF SQLCA.SQLCode < 0 THEN
		l_cMessage = "Error setting IIM Tab Text to Blob Conversion Table Maintenance item to inactive"
		mle_Convert_Info.Text += l_cMessage
	END IF
END IF

IF IsValid( l_dsTabs ) THEN DESTROY l_dsTabs

SetPointer( Arrow! )
end event

on u_iim_convert.create
int iCurrent
call super::create
this.st_status=create st_status
this.mle_convert_info=create mle_convert_info
this.cb_begin=create cb_begin
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_status
this.Control[iCurrent+2]=this.mle_convert_info
this.Control[iCurrent+3]=this.cb_begin
end on

on u_iim_convert.destroy
call super::destroy
destroy(this.st_status)
destroy(this.mle_convert_info)
destroy(this.cb_begin)
end on

type st_status from statictext within u_iim_convert
integer x = 832
integer y = 52
integer width = 690
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Conversion Information"
boolean focusrectangle = false
end type

type mle_convert_info from multilineedit within u_iim_convert
integer x = 827
integer y = 124
integer width = 2487
integer height = 1412
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_begin from commandbutton within u_iim_convert
integer x = 155
integer y = 128
integer width = 503
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Begin Conversion"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Trigger the conversion script on the parent userobject

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/18/2000  K. Claver  Created.
*****************************************************************************************/
PARENT.Event Trigger ue_convert( )
end event

