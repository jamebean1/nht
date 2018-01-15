$PBExportHeader$n_win32_api_calls.sru
$PBExportComments$<doc>Contains various PB function calls redirected to win32 api calls.
forward
global type n_win32_api_calls from nonvisualobject
end type
type openfilename from structure within n_win32_api_calls
end type
type memorystatus from structure within n_win32_api_calls
end type
type osversioninfoex from structure within n_win32_api_calls
end type
type systemtime from structure within n_win32_api_calls
end type
type time_zone_information from structure within n_win32_api_calls
end type
end forward

type OpenFileName from structure
	long		lStructSize
	long		hwndOwner
	long		hInstance
	string		lpstrFilter
	string		lpstrCustomFilter
	long		nMaxCustFilter
	long		nFilterIndex
	string		lpstrFile
	long		nMaxFile
	string		lpstrFileTitle
	long		nMaxFileTitle
	string		lpstrInitialDir
	string		lpstrTitle
	long		flags
	integer		nFileOffset
	integer		nFileExtension
	string		lpstrDefExt
	long		lCustData
	long		lpfnHook
	string		lpTemplateName
end type

type MemoryStatus from structure
	long		dwLength
	long		dwMemoryLoad
	long		dwTotalPhys
	long		dwAvailPhys
	long		dwTotalPageFile
	long		dwAvailPageFile
	long		dwTotalVirtual
	long		dwAvailVirtual
end type

type osversioninfoex from structure
	unsignedlong		dwosversioninfosize
	unsignedlong		dwmajorversion
	unsignedlong		dwminorversion
	unsignedlong		dwbuildnumber
	unsignedlong		dwplatformid
	character		szcsdversion[128]
	unsignedlong		wservicepackmajor
	unsignedlong		wservicepackminor
	long		wsuitemask
	character		wproducttype
	character		wreserved
end type

type systemtime from structure
	unsignedinteger		wyear
	unsignedinteger		wmonth
	unsignedinteger		wdayofweek
	unsignedinteger		wday
	unsignedinteger		whour
	unsignedinteger		wminute
	unsignedinteger		wsecond
	unsignedinteger		wmilliseconds
end type

type time_zone_information from structure
	long		bias
	character		standardname[64]
	systemtime		standarddate
	long		standardbias
	character		daylightname[64]
	systemtime		daylightdate
	long		daylightbias
end type

global type n_win32_api_calls from nonvisualobject
end type
global n_win32_api_calls n_win32_api_calls

type prototypes
Function ulong GetCurrentDirectoryA (ulong textlen, ref string dirtext) library "KERNEL32.DLL" alias for "GetCurrentDirectoryA;Ansi"
Function boolean SetCurrentDirectoryA (ref string directoryname ) library "KERNEL32.DLL" alias for "SetCurrentDirectoryA;Ansi"

Function ulong GetTempPathA (REF ulong dwBuffer, REF string lpszTempPath) library "kernel32.dll" alias for "GetTempPathA;Ansi"
Function ulong GetModuleFileNameA ( ulong module_handle, ref string buffer, ulong size_of_buffer ) library "kernel32.dll" alias for "GetModuleFileNameA;Ansi"
Function ulong GetModuleHandleA (string lpModuleName) library "kernel32.dll" alias for "GetModuleHandleA;Ansi"
Function ulong GetCurrentProcessId () library "kernel32.dll"
Function ulong FindWindowA (string lpClassName, string lpWindowName) Library "user32.dll" alias for "FindWindowA;Ansi"

Function long Sleep (long dwMilliseconds) library "kernel32.dll"

Function long RA32GetKey( char TableName[31] ) library "RA32KeyManager.dll" alias for "RA32GetKey;Ansi"
Function Long ShellExecuteA (Long hwnd, string lpOperation, string lpfile, string lpParameters, string lpDirectory, Long nshowcmd) library "SHELL32.DLL" alias for "ShellExecuteA;Ansi"
Function Long FindExecutableA ( String lpFile, String lpDirectory, ref String lpResult) library "SHELL32.DLL" alias for "FindExecutableA;Ansi"
Function Long SetMenuItemBitmaps (Long hMenu, Long nPosition, Long wFlags, Long hBitmapUnchecked, Long hBitmapChecked) library "USER32.DLL"
Function Long GetOpenFileNameA (ref OPENFILENAME pOpenfilename) library "comdlg32.dll" alias for "GetOpenFileNameA;Ansi"
Function Long CommDlgExtendedError () Library "comdlg32.dll"
Function long GetParent ( Long  hWndChild ) library  "user32.dll"
Function Long SetWindowPos  (Long hwnd, Long hWndInsertAfter, Long X, Long Y, Long cx, &
    									Long cy, Long wFlags) Library "user32.dll"


//Functions for determining system settings
Function long GlobalMemoryStatus ( ref MemoryStatus lpMemory) Library "Kernel32.dll" alias for "GlobalMemoryStatus;Ansi"
Function Boolean GetComputerNameA ( ref String lpComputerName, ref Long lpSize) Library "Kernel32.dll" alias for "GetComputerNameA;Ansi"
Function long GetVersionExA ( ref OSVERSIONINFOEX lpVersionInfo) Library "kernel32.dll" alias for "GetVersionExA;Ansi"
Function long GetLastError ( ) library "Kernel32.dll"

//Functions for setting menu bitmaps (BLD)
FUNCTION ulong LoadImageA(ulong hintance, string filename,uint utype,int x,int y,uint fload)  LIBRARY "USER32.DLL" alias for "LoadImageA;Ansi"
FUNCTION boolean SetMenuItemBitmaps(ulong hmenu,uint upos,uint flags,ulong handle_bm1,ulong handle_bm2)  LIBRARY "USER32.DLL"
FUNCTION int GetSystemMetrics(  int nIndex ) LIBRARY "USER32.DLL"
FUNCTION ulong GetMenuItemID(ulong hMenu,uint uItem) LIBRARY "USER32.DLL"
FUNCTION int GetSubMenu(ulong hMenu,int pos) LIBRARY "USER32.DLL"
FUNCTION ulong GetMenu(ulong hWindow) LIBRARY "USER32.DLL"
FUNCTION boolean ModifyMenu(ulong  hMnu, ulong uPosition, ulong uFlags, ulong uIDNewItem, long lpNewI) alias for ModifyMenuA LIBRARY "USER32.DLL"

//Functions for capturing the clicked event (RPN)
FUNCTION ulong SetCapture(ulong ll_handle) LIBRARY "USER32.DLL"
FUNCTION boolean ReleaseCapture() LIBRARY "USER32.DLL"

//Functions for discovering the screen color and size information (NWP 08/27/2002)
FUNCTION ulong GetDC(ulong ll_handle) LIBRARY "USER32.DLL"
FUNCTION ulong ReleaseDC(ulong ll_handle, ulong ll_dc) LIBRARY "USER32.DLL" 
FUNCTION ulong GetDeviceCaps(ulong ll_hdc, ulong ll_index) LIBRARY "gdi32.dll"

//Functions for getting and setting windows properties
function long GetWindowLongA (long hWindow, integer nIndex) Library "user32.dll"
function long SetWindowLongA (long hWindow, integer nIndex, long dwNewLong) library "user32.dll"

//Function for getting an UNC from a drive mapped file path
FUNCTION ulong WNetGetConnectionA ( ref string drv, ref string unc, ref ulong buf ) LIBRARY "mpr.dll" alias for "WNetGetConnectionA;Ansi"

FUNCTION ulong GetTimeZoneInformation(REF TIME_ZONE_INFORMATION tzi) LIBRARY "kernel32.dll" alias for "GetTimeZoneInformation;Ansi" 

end prototypes

type variables
Constant Long SWP_NOMOVE = 2
Constant Long SWP_NOZORDER = 4
Constant Long SWP_SHOWWINDOW = 64

Constant Long HWND_TOP = 0
Constant Long HWND_BOTTOM = 1
Constant Long HWND_TOPMOST = -1
Constant Long HWND_NOTOPMOST = -2

//-----------------------------------------------------------------------------------------------------------------------------------
// Window Style Constants
//-----------------------------------------------------------------------------------------------------------------------------------
Constant long	WS_CAPTION		= 12582912
Constant long	WS_SYSMENU 		= 524288
Constant long	WS_THICKFRAME 	= 262144

CONSTANT ulong TIME_ZONE_ID_UNKNOWN = 0
CONSTANT ulong TIME_ZONE_ID_STANDARD = 1
CONSTANT ulong TIME_ZONE_ID_DAYLIGHT  = 2
CONSTANT ulong TIME_ZONE_ID_INVALID     =  4294967295



end variables

forward prototypes
public subroutine of_alwaysontop (window awin, boolean ab_ontop)
public function string of_get_application_path ()
public function integer of_get_color_depth ()
public function long new_getkey (string as_tablename)
public function string of_get_current_directory ()
public function long of_get_key (string as_tablename)
public function string of_getcomputername ()
public function long of_getramsize ()
public function string of_get_networkpath (string as_path)
public function long of_make_response_window_resizable (window aw_window)
public function boolean of_run_file_with_association (window aw_window, string as_operation, string as_filename, string as_parameters, string as_pathname, long al_windowstate)
public function boolean of_set_current_directory (string as_path)
public function boolean of_set_menuitem_bitmap (menu am_menu, string as_bitmapname)
public function long of_get_timezone_bias ()
end prototypes

public subroutine of_alwaysontop (window awin, boolean ab_ontop);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Make the specified window be Always On Top</Description>
<Arguments>
	<Argument Name="awin">Reference to a window</Argument>
	<Argument Name="ab_ontop">Specify True to make the window always on top, False to return to normal z-order</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Long ll_winhandle, ll_x, ll_y
Long ll_Pixels_Width, ll_Pixels_Height


ll_winhandle = handle(awin)
ll_x = UnitsToPixels( awin.x, XUnitsToPixels! )
ll_y = UnitsToPixels( awin.y, YUnitsToPixels! )
ll_Pixels_Width = UnitsToPixels( awin.Width, XUnitsToPixels! )
ll_Pixels_Height = UnitsToPixels( awin.Height, YUnitsToPixels! )


Choose Case ab_OnTop
	Case True
		 SetWindowPos ( 	ll_winhandle, HWND_TOPMOST, ll_x, &
			 					ll_y, ll_Pixels_Width, ll_Pixels_Height, SWP_SHOWWINDOW )
	Case False
		 SetWindowPos (	ll_winhandle, HWND_NOTOPMOST, ll_x, &
			 					ll_y, ll_Pixels_Width, ll_Pixels_Height, SWP_SHOWWINDOW)
End Choose
				

end subroutine

public function string of_get_application_path ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Get the path to the application.</Description>
<Arguments>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string ls_Path
unsignedlong lul_handle

ls_Path = space(1024)

lul_handle = Handle(GetApplication())
GetModuleFilenameA(lul_handle, ls_Path, 1024)
Return ls_path

end function

public function integer of_get_color_depth ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the system's Color Depth.</Description>
<Arguments>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
ulong lul_handle, lul_devicecontext, lul_colordepth

lul_handle = Handle(this)
lul_devicecontext = GetDC(lul_handle)
lul_colordepth = GetDeviceCaps(lul_devicecontext, 12)

ReleaseDC(lul_handle, lul_handle)
Return lul_colordepth
end function

public function long new_getkey (string as_tablename);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Not Used - Internal Use Only - To generate keys use n_update_tools</Description>
<Arguments>
	<Argument Name="as_tablename">Name of the table to fetch the key for</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Return RA32GetKey(as_tablename)
end function

public function string of_get_current_directory ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the current directory.</Description>
<Arguments>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

String	ls_CurrentDir

ls_CurrentDir = Space (80)

GetCurrentDirectoryA(80, ls_CurrentDir)

Return ls_CurrentDir


end function

public function long of_get_key (string as_tablename);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Not Used. Internal Use Only.  To generate keys use n_update_tools</Description>
<Arguments>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

long l_len, i
character c_tablename[31], c_null
l_len = len(as_tablename)

For i = 1 to l_len
	c_tablename[i] = Mid(as_tablename,i,1)
Next

SetNull(c_null)

c_tablename[i] = c_null

Return RA32GetKey(c_tablename[])
end function

public function string of_getcomputername ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Gets the name of this computer</Description>
<Arguments>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string ls_ComputerName
long	ll_size=255

ls_ComputerName = Space(ll_size)
GetComputerNameA( ls_ComputerName, ll_size)

Return ls_ComputerName
end function

public function long of_getramsize ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the amount of physical RAM in KB installed on computer</Description>
<Arguments>
</Arguments>
<CreatedBy>Pat Newgent</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

MemoryStatus lMem

long lRet

lRet =  GlobalMemoryStatus(lMem)

Return lMem.dwTotalPhys/1024
end function

public function string of_get_networkpath (string as_path);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Translate a drive letter path into a UNC path for use on a network.</Description>
<Arguments>
	<Argument Name="as_path">Driver Letter based file location/directory</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string    ls_tmp, ls_unc
Ulong     ll_rc, ll_size

ls_tmp = upper(left(as_path,2))
IF right(ls_tmp,1) <> ":" THEN RETURN as_path

ll_size = 255
ls_unc = Space(ll_size)

ll_rc = WNetGetConnectionA (ls_tmp, ls_unc, ll_size)
IF  ll_rc = 2250 THEN
    // prbably local drive
    RETURN as_path
END IF

IF ll_rc <> 0 THEN
    MessageBox("UNC Error","Error " + string(ll_rc) + " retrieving UNC for " + ls_tmp)
    RETURN as_path
END IF

// Concat and return full path
IF len(as_path) > 2 THEN
   ls_unc = ls_unc + mid(as_path,3)
END IF

RETURN ls_unc

 


end function

public function long of_make_response_window_resizable (window aw_window);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Make a response window resizable.</Description>
<Arguments>
	<Argument Name="aw_window">The window to make resizable</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long			ll_return
long			ll_Styles
boolean		lb_Control

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure control menu is false, because it causes problems
//-----------------------------------------------------------------------------------------------------------------------------------
If aw_window.ControlMenu Then aw_window.ControlMenu = False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the window style to make sure it's a repsponse
//-----------------------------------------------------------------------------------------------------------------------------------
n_Numerical	ln_Numerical

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the window style to make sure it's a repsponse
//-----------------------------------------------------------------------------------------------------------------------------------
ll_styles = GetWindowLongA(handle(aw_window), -16)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we get a zero, because that's an error
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_styles = 0 Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the style for resizeable
//-----------------------------------------------------------------------------------------------------------------------------------
ln_Numerical = Create n_Numerical
ll_styles = ln_Numerical.of_BitWiseOr(ll_styles, WS_CAPTION)
ll_styles = ln_Numerical.of_BitWiseOr(ll_styles, WS_SYSMENU)
ll_styles = ln_Numerical.of_BitWiseOr(ll_styles, WS_THICKFRAME)
Destroy ln_Numerical

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the result
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = SetWindowLongA(handle(aw_window), -16, ll_styles)
Return ll_return

end function

public function boolean of_run_file_with_association (window aw_window, string as_operation, string as_filename, string as_parameters, string as_pathname, long al_windowstate);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Execute a file.   This function launches a file and it's default program.</Description>
<Arguments>
	<Argument Name="aw_window">The parent window for the program </Argument>
	<Argument Name="as_operation">'Open' or 'Print'</Argument>
	<Argument Name="as_filename">Filename to execute</Argument>
	<Argument Name="as_parameters">Command Line Parameters</Argument>
	<Argument Name="as_pathname">Path to the filename</Argument>
	<Argument Name="as_windowstate">Window State to Execute File </Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//Function Long ShellExecuteA (Long hwnd, string lpOperation, string lpfile, string lpParameters, string lpDirectory, Long nshowcmd) library "SHELL32.DLL"

Long ll_handle, ll_return
String ls_pathname, ls_result


If Not FileExists(as_filename) Then Return False 

If IsNull(as_pathname) Or Len(Trim(as_pathname)) = 0 Then
	ls_pathname = Reverse(as_filename)
	ls_pathname = Reverse(Mid(ls_pathname, Pos(ls_pathname, '\'), 999999))
	as_pathname = ls_pathname
End If

If Len(Trim(as_parameters)) = 0 Then
	SetNull(as_parameters)
End If

ll_handle = Handle(aw_window)

as_operation = Upper(Trim(as_operation))



//Function Long ShellExecuteA (Long hwnd, string lpOperation, string lpfile, string lpParameters, string lpDirectory, Long nshowcmd) library "SHELL32.DLL"
//Function Long FindExecutableA ( String lpFile, String lpDirectory, ref String lpResult) library "SHELL32.DLL"

//ll_return = FindExecutableA(as_filename, '', ls_result)

//Run(ls_result + ' ' + as_filename)


Choose Case as_operation
	Case 'OPEN', 'PRINT'
		ll_return = ShellExecuteA(ll_handle, as_operation, as_filename, as_parameters, as_pathname, 1)
		Return  ll_return > 32
	Case Else
		Return False
End Choose

Return True
end function

public function boolean of_set_current_directory (string as_path);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Changes the current directory to the one specified in as_path.</Description>
<Arguments>
	<Argument Name="as_path">Path to the new Current Directory</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/


Return SetCurrentDirectoryA(as_path)

end function

public function boolean of_set_menuitem_bitmap (menu am_menu, string as_bitmapname);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Sets a bitmap to the menu specified</Description>
<Arguments>
	<Argument Name="an_menu">Menu Reference to set the bitmap onto.</Argument>
	<Argument Name="as_bitmapname">Filename of the bitmap to set onto the menu. </Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/3/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Long		ll_MainHandle
long		ll_SubMenuHandle
integer	li_MenuItemID
long		ll_X
long		ll_Y
long		ll_BitmapHandleA
long		ll_BitmapHandleB

// Win32 contants
Integer IMAGE_BITMAP	   = 0
Integer LR_LOADFROMFILE = 16
Integer SM_CXMENUCHECK  = 71
Integer SM_CYMENUCHECK	= 72
Integer MF_BITMAP			= 4
Integer MF_BYCOMMAND		= 0
Integer MF_BYPOSITION	= 1024

// Get a handle to the menu 
ll_MainHandle = Handle(am_menu)
li_MenuItemID = GetMenuItemID(ll_MainHandle,0)

//Load the bitmap
ll_BitmapHandleA = LoadImageA(0,as_bitmapname,0,0,0,LR_LOADFROMFILE)
ll_BitmapHandleB = LoadImageA(0,as_bitmapname,0,0,0,LR_LOADFROMFILE)

ModifyMenu(ll_SubMenuHandle,li_MenuItemID,MF_BITMAP,li_MenuItemId,ll_BitmapHandleA)

// Get sizes for the pictures, use winapi for the bitmaps sizes
ll_x = GetSystemMetrics(SM_CXMENUCHECK) 
ll_y = GetSystemMetrics(SM_CYMENUCHECK) 

// Load the images using the dimensions for the checked state
ll_BitmapHandleA = LoadImageA(0,as_bitmapname,  IMAGE_BITMAP	,ll_x,ll_y,LR_LOADFROMFILE)
ll_BitmapHandleB = LoadImageA(0,as_bitmapname,  IMAGE_BITMAP	,ll_x,ll_y,LR_LOADFROMFILE)

SetMenuItemBitmaps(ll_MainHandle,0,MF_BYPOSITION,ll_BitmapHandleA,ll_BitmapHandleB)

Return False
end function

public function long of_get_timezone_bias ();time_zone_information	ll_tzi
ULong                   lul_rc

lul_rc = GetTimeZoneInformation(ll_tzi)

CHOOSE CASE lul_rc
   CASE TIME_ZONE_ID_DAYLIGHT
			Return ll_tzi.bias + ll_tzi.daylightbias
   CASE TIME_ZONE_ID_STANDARD
			Return ll_tzi.bias
	CASE ELSE
		Return 0
END CHOOSE

return 0
end function

on n_win32_api_calls.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_win32_api_calls.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*<Abstract>----------------------------------------------------------------------------------------------------
This object contains many Win32 API functions for use in development.
</Abstract>----------------------------------------------------------------------------------------------------*/



end event

