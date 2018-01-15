$PBExportHeader$w_std_rpt_parms.srw
$PBExportComments$Gets start date, end date, and consumer id from the user
forward
global type w_std_rpt_parms from window
end type
type st_4 from statictext within w_std_rpt_parms
end type
type sle_vendor_id from singlelineedit within w_std_rpt_parms
end type
type st_3 from statictext within w_std_rpt_parms
end type
type sle_id from singlelineedit within w_std_rpt_parms
end type
type st_2 from statictext within w_std_rpt_parms
end type
type cb_cancel from commandbutton within w_std_rpt_parms
end type
type cb_ok from commandbutton within w_std_rpt_parms
end type
type st_1 from statictext within w_std_rpt_parms
end type
type em_year from editmask within w_std_rpt_parms
end type
end forward

global type w_std_rpt_parms from window
integer x = 832
integer y = 356
integer width = 1257
integer height = 716
boolean titlebar = true
string title = "Parameter Required"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79748288
st_4 st_4
sle_vendor_id sle_vendor_id
st_3 st_3
sle_id sle_id
st_2 st_2
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
em_year em_year
end type
global w_std_rpt_parms w_std_rpt_parms

type variables
STRING i_cWindowTitle
end variables

on w_std_rpt_parms.create
this.st_4=create st_4
this.sle_vendor_id=create sle_vendor_id
this.st_3=create st_3
this.sle_id=create sle_id
this.st_2=create st_2
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
this.em_year=create em_year
this.Control[]={this.st_4,&
this.sle_vendor_id,&
this.st_3,&
this.sle_id,&
this.st_2,&
this.cb_cancel,&
this.cb_ok,&
this.st_1,&
this.em_year}
end on

on w_std_rpt_parms.destroy
destroy(this.st_4)
destroy(this.sle_vendor_id)
destroy(this.st_3)
destroy(this.sle_id)
destroy(this.st_2)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.em_year)
end on

event open;//*****************************************************************************************
//
//  Event:   Open
//  Purpose: To set the window title
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------
//  10/09/01 C. Jackson  Original Version
//****************************************************************************************

i_cWindowTitle = Message.StringParm
THIS.Title = i_cWindowTitle + ' Parameters'

end event

type st_4 from statictext within w_std_rpt_parms
integer x = 201
integer y = 352
integer width = 325
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
string text = "Vendor ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_vendor_id from singlelineedit within w_std_rpt_parms
integer x = 539
integer y = 344
integer width = 667
integer height = 84
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_std_rpt_parms
integer x = 14
integer y = 152
integer width = 512
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Year to report on:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_id from singlelineedit within w_std_rpt_parms
integer x = 539
integer y = 244
integer width = 667
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_std_rpt_parms
integer x = 206
integer y = 248
integer width = 320
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Provider ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_std_rpt_parms
integer x = 887
integer y = 480
integer width = 279
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: Close Parent window
//  
//  Date     Developer    Description
//  -------- ------------ ------------------------------------------------------------------------
//  04/05/01 C. Jackson   Add setting of cancelled flag
//
//************************************************************************************************

s_report_parms l_sReportParms

setnull(l_sReportParms.date_parm3)
setnull(l_sReportParms.date_parm4)
setnull(l_sReportParms.string_parm1)
setnull(l_sReportParms.string_parm1)

//SetItem.em_year(1,'')

CloseWithReturn(PARENT,l_sReportParms)
end event

type cb_ok from commandbutton within w_std_rpt_parms
integer x = 567
integer y = 480
integer width = 279
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Close the parent window and return the formatted date string
//		
//  Date     Developer     Description
//  -------- ------------- --------------------------------------------------------------------
//  1/10/00  M. Caruso     Update script to handle the ID parameter as well.
//  04/19/00 C. Jackson    Verify that the ending date is not more than 12 months after the 
//                         beginning date (SCR 537)
//  07/11/00 C. Jackson    Removed end_date (SCR 711)
//  04/05/01 C. Jackson    Add end date parameter
//  06/27/01 C. Jackson    Add Vendor Id
//  8/9/2001 K. Claver     Commented out message for no data found as is taken care of in the
//									reports window.
//  06/06/02 C. Jackson    For provider reports, if vendor only search and no results, set to 0
//   
//		
//**********************************************************************************************

STRING	l_cStartDate, l_cEndDate, l_cProviderID, l_cReturn, l_cYear, l_cVendorID
Long     l_nProviderKey
Integer  l_nIndex
s_report_parms l_sReportParms
DataStore l_dsProvKeys

l_cYear = em_year.text
l_sReportParms.date_parm3 = Date( '01/01/'+l_cYear )
l_sReportParms.date_parm4 = Date( '12/31/'+l_cYear )
l_sReportParms.string_parm1 = sle_id.text
l_sReportParms.string_parm2 = sle_vendor_id.text

IF Len( Trim( l_cYear ) ) = 0 OR NOT IsNumber( l_cYear ) OR Integer( l_cYear ) < 1753 THEN
	MessageBox( gs_AppName,"Please enter a valid year before continuing.",Stopsign!, OK! )
	em_year.SetFocus( )
	RETURN
END IF

// Verify Provider and Vendor IDs
IF len (l_sReportParms.string_parm1) = 0 THEN
	// No Provider specified, check for Vendor
	
	IF LEN (l_sReportParms.string_parm2) = 0 THEN
		
		// No Vendor specified, need at least one
		MessageBox(FWCA.MGR.i_ApplicationName,"Please enter a valid Provider or Vendor ID before continuing.",Stopsign!)
		sle_id.SetFocus()
		RETURN
		
	ELSE
		// Vendor only 
		l_dsProvKeys = CREATE DataStore
		l_dsProvKeys.DataObject = "d_provider_keys_vendor"
		l_dsProvKeys.SetTransObject( SQLCA )
		
		l_sReportParms.num_parm1 = l_dsProvKeys.Retrieve( l_sReportParms.string_parm2 )
		IF l_sReportParms.num_parm1 > 0 THEN
			FOR l_nIndex = 1 TO l_sReportParms.num_parm1
				l_sReportParms.long_parm1[ l_nIndex ] = l_dsProvKeys.Object.provider_key[ l_nIndex ]
			NEXT
		ELSE
			l_sReportParms.long_parm1[1] = 0 
		END IF
		
		DESTROY l_dsProvKeys
	END IF
	
ELSE
	
	l_sReportParms.num_parm1 = 1

	// Have provider, do we have both?
	IF LEN (l_sReportParms.string_parm2) = 0 THEN
		// Only Provider
		SELECT provider_key INTO :l_nProviderKey
		  FROM cusfocus.provider_of_service
		 WHERE provider_id = :l_sReportParms.string_parm1
		 USING SQLCA;
		 
		l_sReportParms.long_parm1[l_sReportParms.num_parm1] = l_nProviderKey 
		 
	ELSE
		// Have both
		SELECT provider_key INTO :l_nProviderKey
		  FROM cusfocus.provider_of_service
		  WHERE provider_id = :l_sReportParms.string_parm1
		    AND vendor_id = :l_sReportParms.string_parm2
		  USING SQLCA;
		  
		l_sReportParms.long_parm1[l_sReportParms.num_parm1] = l_nProviderKey 

	END IF
		  	
END IF

//IF sqlca.sqlcode = 100 THEN
//	messagebox(gs_AppName,'No data found for this report')
//	l_cReturn = ''
//end if


CloseWithReturn(PARENT,l_sReportParms)


end event

type st_1 from statictext within w_std_rpt_parms
integer x = 55
integer y = 36
integer width = 1015
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Please enter the following information:"
boolean focusrectangle = false
end type

type em_year from editmask within w_std_rpt_parms
integer x = 539
integer y = 148
integer width = 411
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "####"
string minmax = "~~"
end type

on getfocus;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			em_year
		Event:			getfocus
		Abstract:		Select the text when this edit gets focus
----------------------------------------------------------------------------------------*/

THIS.SelectText(1,Len(THIS.Text))
end on

