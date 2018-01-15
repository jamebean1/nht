$PBExportHeader$w_iim_dw_assoc.srw
forward
global type w_iim_dw_assoc from w_response_std
end type
type cb_deleteview from commandbutton within w_iim_dw_assoc
end type
type cb_delete from commandbutton within w_iim_dw_assoc
end type
type cb_refresh from commandbutton within w_iim_dw_assoc
end type
type cbx_saveheader from checkbox within w_iim_dw_assoc
end type
type cb_export from commandbutton within w_iim_dw_assoc
end type
type cb_apply from commandbutton within w_iim_dw_assoc
end type
type cb_insert from commandbutton within w_iim_dw_assoc
end type
type dw_iim_reports from u_dw_std within w_iim_dw_assoc
end type
type cb_import from commandbutton within w_iim_dw_assoc
end type
type st_6 from statictext within w_iim_dw_assoc
end type
type st_2 from statictext within w_iim_dw_assoc
end type
type sle_comment from singlelineedit within w_iim_dw_assoc
end type
type sle_report from singlelineedit within w_iim_dw_assoc
end type
type cb_cancel from commandbutton within w_iim_dw_assoc
end type
type cb_ok from commandbutton within w_iim_dw_assoc
end type
type st_5 from statictext within w_iim_dw_assoc
end type
type dw_preview from datawindow within w_iim_dw_assoc
end type
type st_4 from statictext within w_iim_dw_assoc
end type
type sle_lib_location from singlelineedit within w_iim_dw_assoc
end type
type st_3 from statictext within w_iim_dw_assoc
end type
type st_1 from statictext within w_iim_dw_assoc
end type
type tab_args_conv from u_tab_args_conv within w_iim_dw_assoc
end type
type tab_args_conv from u_tab_args_conv within w_iim_dw_assoc
end type
end forward

global type w_iim_dw_assoc from w_response_std
integer x = 5
integer y = 368
integer width = 3611
integer height = 1908
string title = "IIM Datawindow Association"
event ue_setheaderinfo ( )
cb_deleteview cb_deleteview
cb_delete cb_delete
cb_refresh cb_refresh
cbx_saveheader cbx_saveheader
cb_export cb_export
cb_apply cb_apply
cb_insert cb_insert
dw_iim_reports dw_iim_reports
cb_import cb_import
st_6 st_6
st_2 st_2
sle_comment sle_comment
sle_report sle_report
cb_cancel cb_cancel
cb_ok cb_ok
st_5 st_5
dw_preview dw_preview
st_4 st_4
sle_lib_location sle_lib_location
st_3 st_3
st_1 st_1
tab_args_conv tab_args_conv
end type
global w_iim_dw_assoc w_iim_dw_assoc

type variables
String i_cLibrary, i_cDWSyntax
String i_cHeaderInfo = "", i_cConvertToDate = ""
Boolean i_bError = FALSE

s_dwpainter_parms  i_sParms
end variables

forward prototypes
public function string fw_getiimloc ()
end prototypes

event ue_setheaderinfo;/*****************************************************************************************
   Event:      ue_SetHeaderInfo
   Purpose:    Get the header information from the datawindow syntax and populate the edit
					fields and instance variable.
   Parameters: None
   Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver    Created.
*****************************************************************************************/
Integer l_nRepNameStart, l_nRepNameEnd, l_nRepCommentStart, l_nRepCommentEnd, l_nRow

IF Pos( Upper( Trim( i_cDWSyntax ) ), "RELEASE" ) > 1 THEN
	i_cHeaderInfo = Mid( i_cDWSyntax, 1, ( Pos( Upper( i_cDWSyntax ), "RELEASE" ) - 1 ) )
	
	l_nRepNameStart = Pos( i_cHeaderInfo, "$", Pos( Upper( i_cHeaderInfo ), "PBEXPORTHEADER" ) )
	l_nRepNameEnd = Pos( i_cHeaderInfo, ".", l_nRepNameStart )
	sle_report.Text = Mid( i_cHeaderInfo, ( l_nRepNameStart + 1 ), ( ( l_nRepNameEnd - l_nRepNameStart ) - 1 ) )
	
	l_nRepCommentStart = Pos( i_cHeaderInfo, "$", Pos( Upper( i_cHeaderInfo ), "PBEXPORTCOMMENTS" ) )
	IF l_nRepCommentStart > 0 THEN
		l_nRepCommentEnd = Len( i_cHeaderInfo )
		sle_comment.Text = Mid( i_cHeaderInfo, ( l_nRepCommentStart + 1 ), ( ( l_nRepCommentEnd - l_nRepCommentStart ) - 2 ) )
	END IF
	
	//Remove the header info from the datawindow syntax
	i_cDWSyntax = Mid( i_cDWSyntax, Pos( Upper( i_cDWSyntax ), "RELEASE" ) )
	
	//Try to find the matching report in the list and scroll to it.
	IF dw_iim_reports.RowCount( ) > 0 THEN
		l_nRow = dw_iim_reports.Find( "report_name = '"+Trim( sle_report.Text )+"'", 1, dw_iim_reports.RowCount( ) )
		
		IF l_nRow > 0 THEN
			dw_iim_reports.ScrollToRow( l_nRow )
			dw_iim_reports.SelectRow( 0, FALSE )
			dw_iim_reports.SelectRow( l_nRow, TRUE )			
		END IF
	END IF
	
	cb_import.SetFocus( )
ELSE		
	//No header info.  Need to enable the fields in case the
	//  user wants to save the report out as an object to be
	//  modified in InfoMaker.
	sle_report.DisplayOnly = FALSE
	sle_report.BackColor = RGB( 255, 255, 255 )
	sle_comment.DisplayOnly = FALSE
	sle_comment.BackColor = RGB( 255, 255, 255 )
	sle_report.SetFocus( )
END IF
end event

public function string fw_getiimloc ();//******************************************************************
//  Module    	 : cusfocus
//  Function     : af_GetIIMLoc
//  Parameters   : None
//  Returns      : The path and/or name of the uncompiled pbl
//  Description   : Retrieves the location of the IIM uncompiled PBL
//
//  Date     Developer   Description 
//  -------- ----------- --------------------------------------------
//  5/25/2001 K. Claver  Created
//******************************************************************/
Integer l_nCount
String l_cIIMLoc

SELECT Count( * )
INTO :l_nCount
FROM cusfocus.system_options
WHERE upper( cusfocus.system_options.option_name ) = 'IIM_PBL_LOCATION'
USING SQLCA;

IF l_nCount > 0 THEN
	SELECT cusfocus.system_options.option_value
	INTO :l_cIIMLoc
	FROM cusfocus.system_options
	WHERE upper( cusfocus.system_options.option_name ) = 'IIM_PBL_LOCATION'
	USING SQLCA;
END IF

RETURN l_cIIMLoc
end function

on w_iim_dw_assoc.create
int iCurrent
call super::create
this.cb_deleteview=create cb_deleteview
this.cb_delete=create cb_delete
this.cb_refresh=create cb_refresh
this.cbx_saveheader=create cbx_saveheader
this.cb_export=create cb_export
this.cb_apply=create cb_apply
this.cb_insert=create cb_insert
this.dw_iim_reports=create dw_iim_reports
this.cb_import=create cb_import
this.st_6=create st_6
this.st_2=create st_2
this.sle_comment=create sle_comment
this.sle_report=create sle_report
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_5=create st_5
this.dw_preview=create dw_preview
this.st_4=create st_4
this.sle_lib_location=create sle_lib_location
this.st_3=create st_3
this.st_1=create st_1
this.tab_args_conv=create tab_args_conv
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_deleteview
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.cbx_saveheader
this.Control[iCurrent+5]=this.cb_export
this.Control[iCurrent+6]=this.cb_apply
this.Control[iCurrent+7]=this.cb_insert
this.Control[iCurrent+8]=this.dw_iim_reports
this.Control[iCurrent+9]=this.cb_import
this.Control[iCurrent+10]=this.st_6
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.sle_comment
this.Control[iCurrent+13]=this.sle_report
this.Control[iCurrent+14]=this.cb_cancel
this.Control[iCurrent+15]=this.cb_ok
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.dw_preview
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.sle_lib_location
this.Control[iCurrent+20]=this.st_3
this.Control[iCurrent+21]=this.st_1
this.Control[iCurrent+22]=this.tab_args_conv
end on

on w_iim_dw_assoc.destroy
call super::destroy
destroy(this.cb_deleteview)
destroy(this.cb_delete)
destroy(this.cb_refresh)
destroy(this.cbx_saveheader)
destroy(this.cb_export)
destroy(this.cb_apply)
destroy(this.cb_insert)
destroy(this.dw_iim_reports)
destroy(this.cb_import)
destroy(this.st_6)
destroy(this.st_2)
destroy(this.sle_comment)
destroy(this.sle_report)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_5)
destroy(this.dw_preview)
destroy(this.st_4)
destroy(this.sle_lib_location)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.tab_args_conv)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_SetOptions
   Purpose:    Please see PowerClass documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Initialize the objects and instance variables.
*****************************************************************************************/
String l_cError

//Get the library path so can retrieve the list of 
//  available reports
THIS.i_cLibrary = THIS.fw_GetIIMLoc( )

IF Trim( THIS.i_cLibrary ) <> "" THEN
	sle_lib_location.Text = THIS.i_cLibrary
	
	IF FileExists( i_cLibrary ) THEN		
		//Trigger the event to populate the report list datawindow
		dw_iim_reports.Event Trigger ue_GetReports( )
		
		cb_export.Enabled = TRUE
		cb_refresh.Enabled = TRUE
	ELSE
		MessageBox( gs_AppName, "Incorrect report library name or library doesn't exist in the application directory" )
		cb_export.Enabled = FALSE
		cb_refresh.Enabled = FALSE
	END IF
ELSE
	cb_export.Enabled = FALSE
	cb_refresh.Enabled = FALSE
END IF

//Set the parms instance variable to the object passed and build
//  the argument list for the arguments datawindow.
IF IsValid( Message.PowerObjectParm ) THEN
	THIS.i_sParms = Message.PowerObjectParm
	
	IF THIS.i_sParms.view_type = "detail" THEN
		cb_deleteview.Visible = TRUE
		THIS.i_cDWSyntax = THIS.i_sParms.detail_syntax
	ELSE
		cb_deleteview.Visible = FALSE
		THIS.i_cDWSyntax = THIS.i_sParms.summary_syntax
	END IF
	
	IF Pos( THIS.i_cDWSyntax, "(G)" ) > 0 OR Pos( THIS.i_cDWSyntax, "(M)" ) > 0 THEN
		THIS.i_cDWSyntax = Mid( THIS.i_cDWSyntax, 4 )
	END IF
	
	IF Match( THIS.i_cDWSyntax, "#CD#" ) THEN
		//Fields to convert to dates exist.  Parse them off the end before
		//  create the datawindow.
		THIS.i_cConvertToDate = Upper( Mid( THIS.i_cDWSyntax, Pos( THIS.i_cDWSyntax, "#CD#" ) ) )
		THIS.i_cDWSyntax = Mid( THIS.i_cDWSyntax, 1, Pos( THIS.i_cDWSyntax, "#CD#" ) - 1 )
	END IF
	
	tab_args_conv.tabpage_args.dw_args.Event Trigger ue_BuildArgList( THIS.i_sParms )
	
	IF Trim( THIS.i_cDWSyntax ) <> "" THEN
		//Set the header info
		THIS.Event Trigger ue_SetHeaderInfo( )		
		
		//Get the arguments for the datawindow
		tab_args_conv.tabpage_args.dw_args.Event Trigger ue_GetArgs( THIS.i_cDWSyntax )
		
		//Create the datawindow
		IF dw_preview.Create( THIS.i_cDWSyntax, l_cError ) > 0 THEN
			dw_preview.InsertRow( 0 )
			
			//Build the list of available fields in the datawindow
			tab_args_conv.tabpage_convert.dw_convert_fields.Event Trigger ue_BuildFieldList( dw_preview )
			
			//Restore the date convertion rows
			tab_args_conv.tabpage_convert.dw_convert_fields.Event Trigger ue_RestoreDateConvert( THIS.i_cConvertToDate )
			
			//Enable the ok button
			cb_ok.Enabled = TRUE
			
			IF THIS.i_sParms.view_type = "detail" THEN
				cb_deleteview.Enabled = TRUE
			END IF
		ELSE
			MessageBox( gs_AppName, "Creation of datawindow failed.~r~n~r~nError: "+l_cError, StopSign!, OK! )
			
			THIS.i_bError = TRUE
			cb_export.Enabled = FALSE
			cb_ok.Enabled = FALSE
			
			IF THIS.i_sParms.view_type = "detail" THEN
				cb_deleteview.Enabled = FALSE
			END IF
		END IF
	END IF
END IF
	



end event

type cb_deleteview from commandbutton within w_iim_dw_assoc
integer x = 3186
integer y = 1272
integer width = 393
integer height = 112
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete &View"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Ask the user if they really want to delete.  If yes, set syntax to a "D" to
					let the calling object know to delete the view and close the window passing
					the syntax back to the calling object.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/26/2000 K. Claver   Created.
*****************************************************************************************/
Integer l_nRV

l_nRV = MessageBox( gs_AppName, "Are you sure you want to delete this view?", Question!, YesNo!, 1 )

//If they answer yes, set the syntax to "D" and close the window returning the syntax.
IF l_nRV = 1 THEN
	PARENT.i_cDWSyntax = "D"

	CloseWithReturn( PARENT, PARENT.i_cDWSyntax )
END IF
	
end event

type cb_delete from commandbutton within w_iim_dw_assoc
integer x = 3186
integer y = 860
integer width = 393
integer height = 112
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Delete the selected row from the datawindow.
*****************************************************************************************/
Integer l_nSelectedRow

l_nSelectedRow = tab_args_conv.tabpage_convert.dw_convert_fields.GetSelectedRow( 0 )

IF l_nSelectedRow > 0 THEN
	tab_args_conv.tabpage_convert.dw_convert_fields.DeleteRow( l_nSelectedRow )

	//Rebuild the convert to date field string
	PARENT.i_cConvertToDate = tab_args_conv.tabpage_convert.fu_GetConvert( )
END IF
end event

type cb_refresh from commandbutton within w_iim_dw_assoc
integer x = 3186
integer y = 404
integer width = 393
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Refresh List"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Refresh the report list datawindow.
*****************************************************************************************/
//Trigger the event to populate the report list datawindow
dw_iim_reports.Event Trigger ue_GetReports( )
end event

type cbx_saveheader from checkbox within w_iim_dw_assoc
integer x = 2624
integer y = 1196
integer width = 544
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Save Header Info"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cb_export from commandbutton within w_iim_dw_assoc
integer x = 3186
integer y = 224
integer width = 393
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Export Report"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Export the current datawindow syntax and create a datawindow object
								 in the IIM_Reports pbl.
*****************************************************************************************/
String l_cReport, l_cComment, l_cErrors
Integer l_nRV, l_nRow

IF Trim( sle_report.Text ) = "" THEN
	MessageBox( gs_AppName, "Please supply a report name.", StopSign!, OK! )
	sle_report.SetFocus( )
ELSE
	//Import the datawindow into the library
	l_cReport = Trim( sle_report.Text )
	l_cComment = Trim( sle_comment.Text )
	
	//Create the i_cHeaderInfo string IF NOT ALREADY POPULATED
	PARENT.i_cHeaderInfo = "$PBExportHeader$"+l_cReport+".srd~r~n"
		
	IF l_cComment <> "" THEN
		PARENT.i_cHeaderInfo += "$PBExportComments$"+l_cComment+"~r~n"			
	END IF
		
	l_nRV = LibraryImport( PARENT.i_cLibrary, l_cReport, ImportDatawindow!, PARENT.i_cDWSyntax, &
								  l_cErrors, l_cComment )
								  
	IF l_nRV < 0 THEN
		PARENT.i_bError = TRUE
		MessageBox( gs_AppName, "Error importing datawindow object.~r~n "+l_cErrors, &
						StopSign!, OK! )
	ELSE
		THIS.Enabled = FALSE
		sle_report.DisplayOnly = TRUE
		sle_report.BackColor = 80269524
		sle_comment.DisplayOnly = TRUE
		sle_comment.BackColor = 80269524
		
		dw_iim_reports.Event Trigger ue_GetReports( )
		
		//Try to find the matching report in the list and scroll to it.
		IF dw_iim_reports.RowCount( ) > 0 THEN
			l_nRow = dw_iim_reports.Find( "report_name = '"+Trim( sle_report.Text )+"'", 1, dw_iim_reports.RowCount( ) )
			
			IF l_nRow > 0 THEN
				dw_iim_reports.ScrollToRow( l_nRow )
				dw_iim_reports.SelectRow( 0, FALSE )
				dw_iim_reports.SelectRow( l_nRow, TRUE )			
			END IF
		END IF
		
		cb_import.SetFocus( )
	END IF
END IF
end event

type cb_apply from commandbutton within w_iim_dw_assoc
integer x = 3186
integer y = 1076
integer width = 393
integer height = 112
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Apply"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Applies the changes from the tabs and stores into instance variables.
*****************************************************************************************/
String l_cError

//Get the datawindow syntax
PARENT.i_cDWSyntax = tab_args_conv.tabpage_args.fu_ApplyArgs( PARENT.i_cDWSyntax )

//Get the convert to date field string
PARENT.i_cConvertToDate = tab_args_conv.tabpage_convert.fu_GetConvert( )

//Create the datawindow and insert a row so the datawindow shows
IF dw_preview.Create( PARENT.i_cDWSyntax, l_cError ) > 0 THEN
	dw_preview.InsertRow( 0 )
	
	cb_ok.Enabled = TRUE
ELSE	
	MessageBox( gs_AppName, "Creation of datawindow failed.~r~n~r~nError: "+l_cError, StopSign!, OK! )
	
	PARENT.i_bError = TRUE
	cb_export.Enabled = FALSE
	cb_ok.Enabled = FALSE
END IF
end event

type cb_insert from commandbutton within w_iim_dw_assoc
integer x = 3186
integer y = 740
integer width = 393
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Insert"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Insert a row into the convert to date datawindow.
*****************************************************************************************/
tab_args_conv.tabpage_convert.dw_convert_fields.InsertRow( 0 )
end event

type dw_iim_reports from u_dw_std within w_iim_dw_assoc
event ue_getreports ( )
integer x = 1051
integer y = 108
integer width = 2117
integer height = 408
integer taborder = 30
string dataobject = "d_iim_reports"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_getreports;/*****************************************************************************************
   Event:      ue_GetReports
   Purpose:    Get the list of reports from the report pbl
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Created
*****************************************************************************************/
String l_cReportList, l_cReportName, l_cReportMod, l_cReportComment
String l_cModDate, l_cModTime
Long l_nNextLine = 0, l_nEndFirst, l_nEndSecond, l_nEndThird, l_nReportListLen
Integer l_nRow
DateTime l_dtModDateTime

THIS.Reset( )

IF Trim( PARENT.i_cLibrary ) <> "" THEN
	l_cReportList = LibraryDirectory( PARENT.i_cLibrary, DirDatawindow! )
	
	IF Trim( l_cReportList ) <> "" THEN
		l_nReportListLen = Len( l_cReportList )
		
		DO
			l_nEndFirst = Pos( l_cReportList, "~t", ( l_nNextLine + 1 ) )
			l_cReportName = Mid( l_cReportList, ( l_nNextLine + 1 ), ( l_nEndFirst - ( l_nNextLine + 1 ) ) )
			l_nEndSecond = Pos( l_cReportList, "~t", ( l_nEndFirst + 1 ) )
			l_cReportMod = Mid( l_cReportList, ( l_nEndFirst + 1 ), ( ( l_nEndSecond - l_nEndFirst ) - 1 ) )
			l_nNextLine = Pos( l_cReportList, "~n", l_nEndSecond )
			l_nEndThird = l_nNextLine
			IF l_nEndThird = 0 THEN
				l_nEndThird = l_nReportListLen
			END IF
			l_cReportComment = Mid( l_cReportList, ( l_nEndSecond + 1 ), ( ( l_nEndThird - l_nEndSecond ) - 2 ) )	
			
			l_nRow = THIS.InsertRow( 0 )
			
			THIS.Object.report_name[ l_nRow ] = l_cReportName
			THIS.Object.report_comment[ l_nRow ] = l_cReportcomment
			
			l_cModDate = Mid( l_cReportMod, 1, ( Pos( l_cReportMod, " " ) - 1 ) )
			l_cModTime = Mid( l_cReportMod, ( Pos( l_cReportMod, " " ) + 1 ) )
			l_dtModDateTime = DateTime( Date( l_cModDate ), Time( l_cModTime ) )
			
			THIS.Object.report_modified[ l_nRow ] = l_dtModDateTime
		LOOP WHILE l_nNextLine < l_nReportListLen
		
		THIS.Sort( )
		
		THIS.SelectRow( 1, TRUE )
		cb_import.Enabled = TRUE
	ELSE
		cb_import.Enabled = FALSE
	END IF
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Please see PowerClass documentation for this event
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Added code to set the datawindow options.
*****************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						THIS.c_NullDW, &
						THIS.c_SortClickedOK+ &
						THIS.c_NoRetrieveOnOpen+ &
						THIS.c_NoEnablePopup+ &
						THIS.c_NoMenuButtonActivation+ &
						THIS.c_SelectOnClick )
					
end event

type cb_import from commandbutton within w_iim_dw_assoc
integer x = 3186
integer y = 104
integer width = 393
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Import Report"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Imports the report from the IIM_Reports pbl.
*****************************************************************************************/
Integer l_nRow, l_nIndex
String l_cReport, l_cError

IF dw_iim_reports.RowCount( ) > 0 THEN
	l_nRow = dw_iim_reports.GetSelectedRow( 0 )
	IF l_nRow > 0 THEN
		l_cReport = dw_iim_reports.GetItemString( l_nRow, "report_name" )
		
		IF Trim( l_cReport ) <> "" THEN
			PARENT.i_cDWSyntax = LibraryExport( PARENT.i_cLibrary, l_cReport, ExportDatawindow! )
			
			IF Trim( PARENT.i_cDWSyntax ) <> "" THEN
				IF dw_preview.Create( PARENT.i_cDWSyntax, l_cError ) > 0 THEN
					//Strip off the tab sequences as they will be added back on datawindow
					// creation.
					FOR l_nIndex = 1 TO Integer( dw_preview.Object.Datawindow.Column.Count )
						IF dw_preview.Describe( "#"+String( l_nIndex )+".Visible" ) = "1" THEN
							dw_preview.Modify( "#"+String( l_nIndex )+".TabSequence='0'" )
						END IF
					NEXT
					
					//Get the new datawindow syntax
					PARENT.i_cDWSyntax = dw_preview.Object.Datawindow.Syntax
						
					tab_args_conv.tabpage_args.dw_args.Event Trigger ue_GetArgs( PARENT.i_cDWSyntax )
					tab_args_conv.tabpage_convert.dw_convert_fields.Event Trigger ue_BuildFieldList( dw_preview )
					
					dw_preview.InsertRow( 0 )
			
					sle_report.Text = dw_iim_reports.GetItemString( l_nRow, "report_name" )
					sle_comment.Text = dw_iim_reports.GetItemString( l_nRow, "report_comment" )
					
					//Set the header info variable
					PARENT.i_cHeaderInfo = "$PBExportHeader$"+Trim( sle_report.Text )+".srd~r~n"
		
					IF Trim( sle_comment.Text ) <> "" THEN
						PARENT.i_cHeaderInfo += "$PBExportComments$"+Trim( sle_comment.Text )+"~r~n"			
					END IF
					
					//Disable the report and comment fields
					sle_report.DisplayOnly = TRUE
					sle_report.BackColor = 80269524
					sle_comment.DisplayOnly = TRUE
					sle_comment.BackColor = 80269524
					
					cb_ok.Enabled = TRUE
					
					IF PARENT.i_sParms.view_type = "detail" THEN
						cb_deleteview.Enabled = TRUE
					END IF
				ELSE
					MessageBox( gs_AppName, "Creation of datawindow failed.~r~n~r~nError: "+l_cError, StopSign!, OK! )
					
					SetNull( PARENT.i_cDWSyntax )
					i_bError = TRUE
					
					cb_export.Enabled = FALSE
					cb_ok.Enabled = FALSE
					
					IF PARENT.i_sParms.view_type = "detail" THEN
						cb_deleteview.Enabled = FALSE
					END IF
				END IF
			ELSE
				PARENT.i_bError = TRUE
				MessageBox( gs_AppName, "Error retrieving datawindow syntax", StopSign!, OK! )
				
				cb_export.Enabled = FALSE
				cb_ok.Enabled = FALSE
				
				IF PARENT.i_sParms.view_type = "detail" THEN
					cb_deleteview.Enabled = FALSE
				END IF
			END IF
		END IF
	END IF
END IF
end event

type st_6 from statictext within w_iim_dw_assoc
integer x = 37
integer y = 360
integer width = 302
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Comment:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_iim_dw_assoc
integer x = 32
integer y = 200
integer width = 416
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Current Report:"
boolean focusrectangle = false
end type

type sle_comment from singlelineedit within w_iim_dw_assoc
integer x = 37
integer y = 428
integer width = 974
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_report from singlelineedit within w_iim_dw_assoc
integer x = 37
integer y = 268
integer width = 974
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_iim_dw_assoc
integer x = 3186
integer y = 1684
integer width = 393
integer height = 112
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Clears the datawindow syntax variable and closes the window.
*****************************************************************************************/
SetNull( PARENT.i_cDWSyntax )
CloseWithReturn( PARENT, PARENT.i_cDWSyntax )
end event

type cb_ok from commandbutton within w_iim_dw_assoc
integer x = 3186
integer y = 1564
integer width = 393
integer height = 112
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;/*****************************************************************************************
   Event:      Clicked
   Purpose:    Please see PB documentation for this event.
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Returns the modified datawindow syntax and closes the window.
*****************************************************************************************/
String l_cReport, l_cComment

IF NOT PARENT.i_bError THEN
	//Add the header info back if it doesn't already exist and the option to save
	//  header info is checked.
	IF Pos( Upper( PARENT.i_cDWSyntax ), "RELEASE" ) = 1 AND cbx_saveheader.Checked THEN
		IF Trim( sle_report.Text ) = "" THEN
			MessageBox( gs_AppName, "Please supply a report name.", StopSign!, OK! )
			sle_report.SetFocus( )
			RETURN
		ELSE
			l_cReport = Trim( sle_report.Text )
			l_cComment = Trim( sle_comment.Text )
			
			PARENT.i_cHeaderInfo = "$PBExportHeader$"+l_cReport+".srd~r~n"
				
			IF l_cComment <> "" THEN
				PARENT.i_cHeaderInfo += "$PBExportComments$"+l_cComment+"~r~n"			
			END IF
			
			PARENT.i_cDWSyntax = ( PARENT.i_cHeaderInfo+PARENT.i_cDWSyntax+PARENT.i_cConvertToDate )
		END IF
	ELSE
		PARENT.i_cDWSyntax = ( PARENT.i_cDWSyntax+PARENT.i_cConvertToDate )
	END IF
ELSE
	SetNull( PARENT.i_cDWSyntax )
END IF

CloseWithReturn( PARENT, PARENT.i_cDWSyntax )
end event

type st_5 from statictext within w_iim_dw_assoc
integer x = 18
integer y = 1196
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Preview"
boolean focusrectangle = false
end type

type dw_preview from datawindow within w_iim_dw_assoc
integer x = 18
integer y = 1272
integer width = 3145
integer height = 520
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_iim_dw_assoc
integer x = 1047
integer y = 36
integer width = 585
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Step 1: Select Report"
boolean focusrectangle = false
end type

type sle_lib_location from singlelineedit within w_iim_dw_assoc
integer x = 37
integer y = 112
integer width = 974
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_iim_dw_assoc
integer x = 37
integer y = 40
integer width = 238
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Library:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_iim_dw_assoc
integer x = 27
integer y = 552
integer width = 2126
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Step 2: Associate Retrieval Arguments and Convert To Date Fields(if necessary)"
boolean focusrectangle = false
end type

type tab_args_conv from u_tab_args_conv within w_iim_dw_assoc
integer x = 14
integer y = 636
integer width = 3154
integer taborder = 40
end type

event selectionchanged;call super::selectionchanged;/*****************************************************************************************
   Event:      SelectionChanged
   Purpose:    Please see PB documentation for this event
   
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver   Enable/disable the insert button depending on what tab is chosen.
*****************************************************************************************/
IF newindex = 2 THEN
	cb_insert.Enabled = TRUE
	IF tab_args_conv.tabpage_convert.dw_convert_fields.RowCount( ) > 0 THEN
		cb_delete.Enabled = TRUE
	END IF
ELSE
	cb_insert.Enabled = FALSE
	cb_delete.Enabled = FALSE
END IF
end event

