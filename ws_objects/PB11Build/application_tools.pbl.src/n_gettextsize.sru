$PBExportHeader$n_gettextsize.sru
forward
global type n_gettextsize from nonvisualobject
end type
type os_size from structure within n_gettextsize
end type
end forward

type os_size from structure
	long		l_cx
	long		l_cy
end type

global type n_gettextsize from nonvisualobject autoinstantiate
end type

type prototypes
// Get text size
FUNCTION ulong GetDC(ulong hwnd) LIBRARY "user32.dll"
Function uint ReleaseDC(ulong hWnd, ulong hdcr) Library "USER32.DLL"
FUNCTION boolean GetTextExtentPoint32A(ulong hdc, ref string g_text, int num, ref os_size lpsize2) LIBRARY "GDI32.DLL" alias for "GetTextExtentPoint32A;Ansi"
//Function uint SelectObject(uint hdc, uint hWnd) Library "GDI32.DLL"
Function ulong SelectObject(ulong hdc, ulong aul_hWnd) Library "GDI32.DLL"
Function long GetLastError() Library "Kernel32.DLL"
Function uint SetTextCharacterExtra(uint hdc, uint nCharExtra) Library "GDI32.DLL"

end prototypes

type variables
ulong 		iui_hdc
uint 			iui_Handle
StaticText 	ist_statictext
end variables

forward prototypes
public subroutine of_settext (string as_text, ref integer ai_height, ref integer ai_width)
public subroutine of_set_statictext (statictext ast_temp)
public function integer of_gettextsize (statictext lst_temp, string as_text, ref long ai_height, ref long ai_width)
end prototypes

public subroutine of_settext (string as_text, ref integer ai_height, ref integer ai_width);Integer	li_num		
os_size lpsize2

li_num = len(as_text)


GetTextExtentPoint32A(iui_hdc, as_text, li_num, lpsize2)
ai_Height = lpsize2.l_cy
ai_Width = lpsize2.l_cx

end subroutine

public subroutine of_set_statictext (statictext ast_temp);integer li_WM_GETFONT = 49 
uint lui_hFont

If IsValid(ist_statictext) Then
	If ist_statictext = ast_temp Then Return
	ReleaseDC(iui_handle,iui_hdc)
End If

iui_handle = handle(ist_statictext)

iui_hdc = GetDC(iui_handle)

// Get the font in use on the Static Text
lui_hFont = Send(iui_Handle, li_WM_GETFONT, 0, 0)

// Select it into the device context
SelectObject(iui_hdc, lui_hFont)

end subroutine

public function integer of_gettextsize (statictext lst_temp, string as_text, ref long ai_height, ref long ai_width);ulong 	lui_hdc
integer 	li_num
Integer	li_Return
Integer	li_WM_GETFONT = 49 
uint 		lui_hFont
uint		lui_Handle
 
li_num = len(as_text)
os_size lpsize2

lui_handle = handle(lst_temp)

lui_hdc = GetDC(lui_handle)


// Get the font in use on the Static Text
lui_hFont = Send(lui_Handle, li_WM_GETFONT, 0, 0)

// Select it into the device context
SelectObject(lui_hdc, lui_hFont)
GetTextExtentPoint32A(lui_hdc, as_text, li_num, lpsize2)
ReleaseDC(lui_handle,lui_hdc)

ai_Height = lpsize2.l_cy
ai_Width = lpsize2.l_cx

Return li_Return


end function

on n_gettextsize.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_gettextsize.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;ReleaseDC(iui_handle, iui_hdc)
end event

