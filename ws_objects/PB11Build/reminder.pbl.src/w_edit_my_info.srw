$PBExportHeader$w_edit_my_info.srw
forward
global type w_edit_my_info from w_response
end type
type st_1 from statictext within w_edit_my_info
end type
type p_signature from picture within w_edit_my_info
end type
type dw_1 from datawindow within w_edit_my_info
end type
type cb_okay from commandbutton within w_edit_my_info
end type
type cb_cancel from commandbutton within w_edit_my_info
end type
end forward

global type w_edit_my_info from w_response
integer width = 2482
integer height = 1544
string title = "Edit My Info"
st_1 st_1
p_signature p_signature
dw_1 dw_1
cb_okay cb_okay
cb_cancel cb_cancel
end type
global w_edit_my_info w_edit_my_info

type variables
boolean ibSignatureChanged = false
blob iblbNewSignature
string isNewSignatureFile

end variables

forward prototypes
public function integer of_save_signature ()
public function integer of_read_signature (string as_path, string as_filename)
public function integer of_remove_signature ()
end prototypes

public function integer of_save_signature ();Long ll_blobID

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

ll_blobID = ln_blob_manipulator.of_insert_blob(iblbNewSignature, isNewSignatureFile)

IF ll_blobID > 0 THEN
	dw_1.object.signature_blbobjctid[1] = ll_blobID
END IF

Destroy	ln_blob_manipulator

return 1
end function

public function integer of_read_signature (string as_path, string as_filename);Integer l_nRV, l_nRow, l_nLoop, l_nIndex, l_nConfidLevel, l_nSelectedRow[ ]
String l_cInfo, l_cFileName, l_cFileNamePath, l_cDesc, l_cMessage, l_cConfidLevel, l_cCurrPath
Long l_nFileNum, ll_blobID
Double l_dblFileSize
Blob l_blFilePart, l_blFile
Boolean l_bAutoCommit, l_bAccessDenied = FALSE
n_cst_kernel32 l_uoKernelFuncs
n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

l_cMessage = "Success"
//Get the current directory so can change back after attach a file
//  from another directory.
l_cCurrPath = l_uoKernelFuncs.of_GetCurrentDirectory( )
	
//Get file datetime and size info
l_dblFileSize = l_uoKernelFuncs.of_GetFileSize(as_path )
		
//Open the file for Read
l_nFileNum = FileOpen( as_path, StreamMode!, Read!, LockReadWrite! )

IF l_nFileNum > 0 THEN				
	IF l_dblFileSize <= 32765 THEN
		l_nLoop = 1
	ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
		l_nLoop = ( l_dblFileSize / 32765 )
	ELSE
		l_nLoop = Ceiling( l_dblFileSize / 32765 )
	END IF
	
	FOR l_nIndex = 1 TO l_nLoop
		l_nRV = FileRead( l_nFileNum, l_blFilePart )
		
		IF l_nRV = -1 THEN
			l_cMessage = "Error while reading file"
			EXIT
		ELSE
			l_blFile = ( l_blFile+l_blFilePart )
		END IF							
	NEXT
	
	FileClose( l_nFileNum )
			

ELSE
	l_cMessage = "Unable to open the file"				
END IF						


//Change back to the app directory.  Need to do this so can find the help file and other
//  files without coded paths.
l_uoKernelFuncs.of_ChangeDirectory( l_cCurrPath )
	
IF l_cMessage = "Success" THEN
	iblbNewSignature = l_blFile
	isNewSignatureFile = as_filename
	p_signature.SetPicture(l_blFile)
	p_signature.Show()
	return 1
ELSE
	return -1
END IF
end function

public function integer of_remove_signature ();Long ll_blobID, ll_null
Blob lb_null

SetNull(ll_null)
SetNull(lb_null)

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

ll_blobID = dw_1.object.signature_blbobjctid[1]

IF NOT IsNull(ll_blobID) THEN
	ln_blob_manipulator.of_delete_blob(ll_blobID)
END IF

dw_1.object.signature_blbobjctid[1] = ll_null
p_signature.SetPicture(lb_null)
p_signature.hide( )

Destroy	ln_blob_manipulator

return 1
end function

on w_edit_my_info.create
int iCurrent
call super::create
this.st_1=create st_1
this.p_signature=create p_signature
this.dw_1=create dw_1
this.cb_okay=create cb_okay
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.p_signature
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cb_okay
this.Control[iCurrent+5]=this.cb_cancel
end on

on w_edit_my_info.destroy
call super::destroy
destroy(this.st_1)
destroy(this.p_signature)
destroy(this.dw_1)
destroy(this.cb_okay)
destroy(this.cb_cancel)
end on

event open;call super::open;STRING ls_current_user
LONG ll_rows, ll_signature
BLOB blb_image

ls_current_user = gn_globals.is_login

dw_1.settransobject( SQLCA)
ll_rows = dw_1.retrieve(ls_current_user )

IF ll_rows > 0 THEN
	ll_signature = dw_1.object.signature_blbobjctid[1]
	// if sig is not null, show the image
	IF NOT IsNull(ll_signature) THEN
		SELECT bo.blbobjctdta
		INTO :blb_image
		FROM dbo.blobobject bo
		WHERE bo.blbobjctid = :ll_signature;
		
		p_signature.SetPicture(blb_image)
		p_signature.Show()
	END IF
END IF


end event

type st_1 from statictext within w_edit_my_info
integer x = 192
integer y = 680
integer width = 485
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Signature Preview:"
boolean focusrectangle = false
end type

type p_signature from picture within w_edit_my_info
integer x = 197
integer y = 736
integer width = 1998
integer height = 572
boolean originalsize = true
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_edit_my_info
integer x = 187
integer y = 52
integer width = 2007
integer height = 604
integer taborder = 20
string title = "none"
string dataobject = "d_edit_my_info"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;string ls_filename, ls_path, ls_name
int li_file

ls_name = dwo.name

IF ls_name = "b_signature" THEN
	li_file = GetFileOpenName("Select File", ls_path, ls_filename, ".BMP", "Graphic Files (*.bmp;*.gif;*.jpg;*.jpeg),*.bmp;*.gif;*.jpg;*.jpeg")
	
	IF li_file = 1 THEN
		ibSignatureChanged = true
		of_read_signature(ls_path, ls_filename)
	END IF
ELSE
	ibSignatureChanged = false
	of_remove_signature()
END IF
end event

type cb_okay from commandbutton within w_edit_my_info
integer x = 539
integer y = 1340
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;INTEGER li_return
BLOB ibSignature

IF ibSignatureChanged THEN
	of_save_signature()
END IF

li_return = dw_1.Update()
IF li_return = 1 THEN
	Close(PARENT)
ELSE
	MessageBox(gs_appname, "Unable to update info: " + SQLCA.sqlerrtext);
END IF
end event

type cb_cancel from commandbutton within w_edit_my_info
integer x = 1417
integer y = 1340
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;Close(PARENT)
end event

