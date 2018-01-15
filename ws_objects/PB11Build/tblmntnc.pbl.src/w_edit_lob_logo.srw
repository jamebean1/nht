$PBExportHeader$w_edit_lob_logo.srw
forward
global type w_edit_lob_logo from w_response
end type
type cb_1 from commandbutton within w_edit_lob_logo
end type
type st_1 from statictext within w_edit_lob_logo
end type
type p_logo from picture within w_edit_lob_logo
end type
type cb_okay from commandbutton within w_edit_lob_logo
end type
type cb_cancel from commandbutton within w_edit_lob_logo
end type
end forward

global type w_edit_lob_logo from w_response
integer width = 2482
integer height = 1568
string title = "Edit Line of Business Logo"
cb_1 cb_1
st_1 st_1
p_logo p_logo
cb_okay cb_okay
cb_cancel cb_cancel
end type
global w_edit_lob_logo w_edit_lob_logo

type variables
boolean ibLogoChanged = false
blob iblbNewLogo
string isNewLogoFile

end variables

forward prototypes
public function integer of_read_logo (string as_path, string as_filename)
public function long of_save_logo ()
end prototypes

public function integer of_read_logo (string as_path, string as_filename);Integer l_nRV, l_nRow, l_nLoop, l_nIndex, l_nConfidLevel, l_nSelectedRow[ ]
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
	iblbNewLogo = l_blFile
	isNewLogoFile = as_filename
	p_logo.SetPicture(l_blFile)
	return 1
ELSE
	return -1
END IF
end function

public function long of_save_logo ();Long ll_blobID

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

ll_blobID = ln_blob_manipulator.of_insert_blob(iblbNewLogo, isNewLogoFile)

Destroy	ln_blob_manipulator

return ll_blobID
end function

on w_edit_lob_logo.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_1=create st_1
this.p_logo=create p_logo
this.cb_okay=create cb_okay
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.p_logo
this.Control[iCurrent+4]=this.cb_okay
this.Control[iCurrent+5]=this.cb_cancel
end on

on w_edit_lob_logo.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.p_logo)
destroy(this.cb_okay)
destroy(this.cb_cancel)
end on

event open;call super::open;LONG ll_logo_id, ll_lob_id
BLOB blb_image

ll_lob_id = message.doubleparm

IF ll_lob_id > 0 THEN
	
	SELECT bo.blbobjctdta
	INTO :blb_image
	FROM dbo.blobobject bo
	WHERE bo.blbobjctid = :ll_lob_id;
			
	p_logo.SetPicture(blb_image)

END IF
end event

type cb_1 from commandbutton within w_edit_lob_logo
integer x = 2043
integer y = 152
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Browse..."
end type

event clicked;string ls_filename, ls_path
int li_file
li_file = GetFileOpenName("Select File", ls_path, ls_filename, ".BMP", "Graphic Files (*.bmp;*.gif;*.jpg;*.jpeg),*.bmp;*.gif;*.jpg;*.jpeg")

IF li_file = 1 THEN
	ibLogoChanged = true
	of_read_logo(ls_path, ls_filename)
END IF

end event

type st_1 from statictext within w_edit_lob_logo
integer x = 37
integer y = 212
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
string text = "Logo Preview:"
boolean focusrectangle = false
end type

type p_logo from picture within w_edit_lob_logo
integer x = 41
integer y = 268
integer width = 2341
integer height = 572
boolean originalsize = true
boolean focusrectangle = false
end type

type cb_okay from commandbutton within w_edit_lob_logo
integer x = 539
integer y = 32
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
BLOB ibLogo
LONG ll_return

ll_return = -1

IF ibLogoChanged THEN
	ll_return = of_save_logo()
END IF

CloseWithReturn(PARENT,ll_return)

end event

type cb_cancel from commandbutton within w_edit_lob_logo
integer x = 1417
integer y = 32
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

event clicked;CloseWithReturn(PARENT, -1)
end event

