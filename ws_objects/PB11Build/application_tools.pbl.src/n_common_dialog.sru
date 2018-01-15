$PBExportHeader$n_common_dialog.sru
$PBExportComments$<doc> This object is used to perform windows dialog operations.
forward
global type n_common_dialog from nonvisualobject
end type
type choosefont from structure within n_common_dialog
end type
type devmode from structure within n_common_dialog
end type
type devnames from structure within n_common_dialog
end type
type logfont from structure within n_common_dialog
end type
type openfilename from structure within n_common_dialog
end type
type printdlg from structure within n_common_dialog
end type
end forward

type choosefont from structure
	long		lstructsize
	long		hwndowner
	long		hdc
	long		lplogfont
	long		ipointsize
	long		flags
	long		rgbcolors
	long		lcustdata
	long		lpfnhook
	long		lptemplatename
	long		hinstance
	long		lpszstyle
	integer		nfonttype
	integer		___missing_alignment__
	long		nsizemin
	long		nsizemax
end type

type devmode from structure
	character		dmdevicename[32]
	integer		dmspecversion
	integer		dmdriverversion
	integer		dmsize
	integer		dmdriverextra
	long		dmfields
	integer		dmorientation
	integer		dmpapersize
	integer		dmpaperlength
	integer		dmpaperwidth
	integer		dmscale
	integer		dmcopies
	integer		dmdefaultsource
	integer		dmprintquality
	integer		dmcolor
	integer		dmduplex
	integer		dmyresolution
	integer		dmttoption
	integer		dmcollate
	character		dmformname[32]
	integer		dmlogpixels
	long		dmbitsperpel
	long		dmpelswidth
	long		dmpelsheight
	long		dmdisplayflags
	long		dmdisplayfrequency
	long		dmicmmethod
	long		dmicmintent
	long		dmmediatype
	long		dmdithertype
	long		dmreserved1
	long		dmreserved2
end type

type devnames from structure
	integer		wdriveroffset
	integer		wdeviceoffset
	integer		woutputoffset
	integer		wdefault
end type

type logfont from structure
	long		lfheight
	long		lfwidth
	long		lfescapement
	long		lforientation
	long		lfweight
	character		lfitalic
	character		lfunderline
	character		lfstrikeout
	character		lfcharset
	character		lfoutprecision
	character		lfclipprecision
	character		lfquality
	character		lfpitchandfamily
	character		lffacename[32]
end type

type openfilename from structure
	long		lstructsize
	long		hwndowner
	long		hinstance
	long		lpstrfilter
	long		lpstrcustomfilter
	long		nmaxcustomfilter
	long		nfilterindex
	long		lpstrfile
	long		nmaxfile
	long		lpstrfiletitle
	long		nmaxfiletitle
	long		lpstrinitialdir
	long		lpstrtitle
	long		flags
	integer		nfileoffset
	integer		nfileextension
	long		lpstrdefext
	long		lcustdata
	long		lpfnhook
	long		lptemplatename
end type

type printdlg from structure
	long		lstructsize
	long		hwndowner
	long		hdevmode
	long		hdevnames
	long		hdc
	long		flags
	integer		nfrompage
	integer		ntopage
	integer		nminpage
	integer		nmaxpage
	integer		ncopies
	long		hinstance
	long		lcustdata
	long		lpfnprinthook
	long		lpfnsetuphook
	long		lpprinttemplatename
	long		lpsetuptemplatename
	long		hprinttemplate
	long		hsetuptemplate
end type

global type n_common_dialog from nonvisualobject
end type
global n_common_dialog n_common_dialog

type prototypes
Private:

// Common Dialog External Functions
Function long GetOpenFileNameA(REF OPENFILENAME OpenFileName) library "comdlg32.dll" alias for "GetOpenFileNameA;Ansi"
Function long GetSaveFileNameA(REF OPENFILENAME SaveFileName) library "comdlg32.dll" alias for "GetSaveFileNameA;Ansi"
Function long PrintDlgA(REF PRINTDLG PrintDlg) library "comdlg32.dll" alias for "PrintDlgA;Ansi"
Function long ChooseFontA(REF CHOOSEFONT ChooseFont) library "comdlg32.dll" alias for "ChooseFontA;Ansi"

// Memory Functions
Function long GetDevMode(REF DEVMODE Destination, long Source, long Size) library "kernel32.dll" Alias For "RtlMoveMemory;Ansi"
Function long GetDevNames(REF DEVNAMES Destination, long Source, long Size) library "kernel32.dll" Alias For "RtlMoveMemory;Ansi"
Function long GetLogFont(REF LOGFONT Destination, long Source, long Size) library "kernel32.dll" Alias For "RtlMoveMemory;Ansi"
Function long PutLogFont(long Destination, REF LOGFONT Source, long Size) library "kernel32.dll" Alias For "RtlMoveMemory;Ansi"

Function long StrCopy(long Destination, REF string Source, long Size) library "kernel32.dll"  Alias for "RtlMoveMemory;Ansi"
Function long LocalAlloc(long Flags, long Bytes) library "kernel32.dll"
Function long LocalFree(long MemHandle) library "kernel32.dll"
Function long CommDlgExtendedError() library "comdlg32.dll"
Function long lstrcpy(long Destination, REF string Source) library "kernel32.dll" alias for "lstrcpy;Ansi"
Function long LocalLock(long Handle) library "kernel32.dll"
Function long LocalUnlock(long Handle) library "kernel32.dll"

// Misc Functions
Function long GetWindowsDirectoryA(REF string Buffer, long Size) library "kernel32.dll" alias for "GetWindowsDirectoryA;Ansi"
Function ulong GetCurrentDirectoryA (ulong textlen, ref string dirtext) library "KERNEL32.DLL" alias for "GetCurrentDirectoryA;Ansi"
Function boolean SetCurrentDirectoryA (ref string directoryname ) library "KERNEL32.DLL" alias for "SetCurrentDirectoryA;Ansi"

end prototypes

type variables
// *****************************************************************
// All Dialogs members
// *****************************************************************
PUBLIC long Flags = 0		// Dialog Flags
PUBLIC long hWndParent = 0		// Parent Window

// *****************************************************************
// Open & Save Dialog public members
// *****************************************************************
Public:
string Filter = ""		// description1~tfilter1~tdescription2~tfilter2
integer FilterIndex = 1	// Default filter index
string InitialDir  = "" 		// Default directory
string Title = ""		// Dialog Title
string DefaultFileName = "" //Default FileName

PROTECTEDWRITE string Filename = "" 		// returns selected file
PROTECTEDWRITE string Files[]		// Selected Files
PROTECTEDWRITE string PathName		// Path
PROTECTEDWRITE integer FileCount		// Number of selected files

// Flags constants
CONSTANT long OFN_READONLY			= 1
CONSTANT long OFN_OVERWRITEPROMPT		= 2
CONSTANT long OFN_HIDEREADONLY		= 4
CONSTANT long OFN_NOCHANGEDIR		= 8
CONSTANT long OFN_SHOWHELP			= 16
CONSTANT long OFN_ENABLEHOOK			= 32
CONSTANT long OFN_ENABLETEMPLATE		= 64
CONSTANT long OFN_ENABLETEMPLATEHANDLE	= 128
CONSTANT long OFN_NOVALIDATE			= 256
CONSTANT long OFN_ALLOWMULTISELECT		= 512
CONSTANT long OFN_EXTENSIONDIFFERENT		= 1024
CONSTANT long OFN_PATHMUSTEXIST		= 2048
CONSTANT long OFN_FILEMUSTEXIST		= 4096
CONSTANT long OFN_CREATEPROMPT		= 8192
CONSTANT long OFN_SHAREAWARE			= 16384
CONSTANT long OFN_NOREADONLYRETURN		= 32768
CONSTANT long OFN_NOTESTFILECREATE		= 65536
CONSTANT long OFN_NONETWORKBUTTON		= 131072
CONSTANT long OFN_NOLONGNAMES		= 262144
CONSTANT long OFN_EXPLORER			= 524288
CONSTANT long OFN_NODEREFERENCELINKS	= 1048576
CONSTANT long OFN_LONGNAMES			= 2097152

// *****************************************************************
// Print dialog public members
// *****************************************************************
integer FromPage	= 1
integer ToPage	= 1
integer MinPage 	= 1
integer MaxPage 	= 0
PROTECTEDWRITE integer Copies = 1 

// Flags constants
CONSTANT long PD_ALLPAGES			= 0
CONSTANT long PD_SELECTION 			= 1
CONSTANT long PD_PAGENUMS 			= 2
CONSTANT long PD_NOSELECTION 			= 4
CONSTANT long PD_NOPAGENUMS 			= 8
CONSTANT long PD_COLLATE			= 16
CONSTANT long PD_PRINTTOFILE 			= 32
CONSTANT long PD_PRINTSETUP 			= 64
CONSTANT long PD_NOWARNING 			= 128
CONSTANT long PD_RETURNDC 			= 256
CONSTANT long PD_RETURNIC 			= 512
CONSTANT long PD_RETURNDEFAULT	 	= 1024
CONSTANT long PD_SHOWHELP 			= 2048
CONSTANT long PD_ENABLEPRINTHOOK 		= 4096
CONSTANT long PD_ENABLESETUPHOOK 		= 8192
CONSTANT long PD_ENABLEPRINTTEMPLATE 	= 16384
CONSTANT long PD_ENABLESETUPTEMPLATE	= 32768
CONSTANT long PD_ENABLEPRINTTEMPLATEHANDLE	= 65536
CONSTANT long PD_ENABLESETUPTEMPLATEHANDLE = 131072
CONSTANT long PD_USEDEVMODECOPIES 		= 262144
CONSTANT long PD_USEDEVMODECOPIESANDCOLLATE= 262144
CONSTANT long PD_DISABLEPRINTTOFILE		= 524288 
CONSTANT long PD_HIDEPRINTTOFILE		= 1048576 
CONSTANT long PD_NONETWORKBUTTON 		= 2097152

// *****************************************************************
// Font dialog public members
// *****************************************************************
long RGBColors	= 0
integer FontType	= 0
integer SizeMin	= 0
integer SizeMax	= 0
string FaceName	= ""
long  Height	= 0
long  Weight	= 0
boolean Italic	= False
boolean Underline	= False
boolean StrikeOut	= False

// Flags constants
CONSTANT long CF_SCREENFONTS 			= 1
CONSTANT long CF_PRINTERFONTS 			= 2
CONSTANT long CF_BOTH 				= 3
CONSTANT long CF_SHOWHELP 			= 4
CONSTANT long CF_ENABLEHOOK 			= 8
CONSTANT long CF_ENABLETEMPLATE 		= 16
CONSTANT long CF_ENABLETEMPLATEHANDLE 	= 32
CONSTANT long CF_INITTOLOGFONTSTRUCT 		= 64
CONSTANT long CF_USESTYLE 			= 128
CONSTANT long CF_EFFECTS 			= 256
CONSTANT long CF_APPLY 				= 512
CONSTANT long CF_ANSIONLY 			= 1024
CONSTANT long CF_SCRIPTSONLY 			= CF_ANSIONLY
CONSTANT long CF_NOVECTORFONTS 		= 2048
CONSTANT long CF_NOOEMFONTS 			= 4096
CONSTANT long CF_NOSIMULATIONS 		= 8192
CONSTANT long CF_LIMITSIZE			= 16384
CONSTANT long CF_FIXEDPITCHONLY 		= 32768
CONSTANT long CF_WYSIWYG 			= 65536
CONSTANT long CF_FORCEFONTEXIST 		= 131072
CONSTANT long CF_SCALABLEONLY			= 262144
CONSTANT long CF_TTONLY 			= 524288
CONSTANT long CF_NOFACESEL			= 1048576
CONSTANT long CF_NOSTYLESEL 			= 2097152 
CONSTANT long CF_NOSIZESEL 			= 4194304
CONSTANT long CF_SELECTSCRIPT 			= 8388608
CONSTANT long CF_NOSCRIPTSEL 			= 16777216
CONSTANT long CF_NOVERTFONTS 			= 33554432

// FontType constants
CONSTANT integer BOLD_FONTTYPE 	= 256
CONSTANT integer ITALIC_FONTTYPE 	= 512
CONSTANT integer REGULAR_FONTTYPE 	= 1024
CONSTANT integer SCREEN_FONTTYPE 	= 8192
CONSTANT integer PRINTER_FONTTYPE 	= 16384
CONSTANT integer SIMULATED_FONTTYPE 	= 32768

// Object private constants
Private:
CONSTANT integer LMEM_ZEROINIT = 64 // Alloc constant => Zero allocated memort

// Open Dialog Special Constants
CONSTANT integer MAXFILENAME     = 260
CONSTANT integer MAXPATHNAME   = 260
CONSTANT integer MAXFILES   = 100
end variables

forward prototypes
public function integer of_getdirectory (ref string as_pathname)
private function string of_convert_filter (string as_filter)
public function string of_getcurrentdirectory ()
public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename)
public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename, string as_extension)
public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename, string as_extension, string as_filter)
public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename[])
public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename[], string as_extension)
public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename[], string as_extension, string as_filter)
public function integer of_getfilesavename (string as_dialog_title, ref string as_pathname, ref string as_filename)
public function integer of_getfilesavename (string as_dialog_title, ref string as_pathname, ref string as_filename, string as_extension)
public function integer of_getfilesavename (string as_dialog_title, ref string as_pathname, ref string as_filename, string as_extension, string as_filter)
private function boolean of_open_file ()
public function boolean of_open_print_dialog ()
public function long of_bitor (long values[])
private function boolean of_save_file ()
public function boolean of_select_font ()
public subroutine of_set_printer (string printername, string driver, string port)
public function boolean of_setcurrentdirectory (string as_newdirectory)
end prototypes

public function integer of_getdirectory (ref string as_pathname);/*<Documentation>----------------------------------------------------------------------------------------------------
<Name>of_GetDirectory</Name>
<Description>This function will display a dialog to allow the user to select a folder.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_pathname">The pathname passed by reference</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
//('Select a directory', ls_fullpath, ls_file, 'Directories|*.txt','Directories Only,*.~~') = 1 then
string	ls_filter
string	ls_dialog_title = 'Select a directory'
long		ll_pos

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the filter to windows standard
//-----------------------------------------------------------------------------------------------------------------------------------
ls_filter = 'Directories Only,*.~~'
ls_filter = of_convert_filter(ls_filter)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the file type filter
//-----------------------------------------------------------------------------------------------------------------------------------
Filter = ls_filter

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the options for the dialog
//-----------------------------------------------------------------------------------------------------------------------------------
Flags = This.of_bitor({OFN_HIDEREADONLY, OFN_NOVALIDATE, OFN_EXPLORER})

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the initial directory if there is one
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(as_pathname) Then
	InitialDir  = as_pathname
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dialog title
//-----------------------------------------------------------------------------------------------------------------------------------
Title = ls_dialog_title + Space(255 - Len(ls_dialog_title))

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the default file name
//-----------------------------------------------------------------------------------------------------------------------------------
DefaultFileName = 'Select a Directory'

//-----------------------------------------------------------------------------------------------------------------------------------
// If the open is successful, set the reference variables and return a 1 for success
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_open_file() Then
	as_pathname = PathName
	if Right(as_pathname, 1) <> '\' then as_pathname = as_pathname + '\'
	Return 1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// These two instance variables are set this way when the user clicks cancel
//-----------------------------------------------------------------------------------------------------------------------------------
If as_pathname  = "" And FileCount = 0 Then
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Otherwise there must have been an error
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1
end function

private function string of_convert_filter (string as_filter);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will convert the filter string from the PowerBuilder Standard to the Windows Standard</Description>
<Arguments>
	<Argument Name="as_filter">Powerbuiler filter string</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>9.8.1999</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_filter[], ls_new_filter[]
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the filter string to the windows standard {
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
If Len(Trim(as_filter)) > 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through combining the extensions with the descriptions while reversing the order
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_parse_string(as_filter, ',', ls_filter[])
	For ll_index = 1 To UpperBound(ls_filter[])
		If Mod(ll_index, 2) = 1 And UpperBound(ls_filter[]) > ll_index Then
			ls_new_filter[(ll_index / 2) + 1] = ls_filter[ll_index]  + '~t' + ls_filter[ll_index + 1]
		End If
	Next

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Build the filter string by adding them together
	//-----------------------------------------------------------------------------------------------------------------------------------
	as_filter = ''
	For ll_index = 1 To UpperBound(ls_new_filter[])
		as_filter = ls_new_filter[ll_index] + '~t' + as_filter
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Cut off the extra tab character
	//-----------------------------------------------------------------------------------------------------------------------------------
	as_filter = Left(as_filter, Len(as_filter) - 1)

	
End If

Return as_filter
end function

public function string of_getcurrentdirectory ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Return Windows 32 current directory</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>9.8.1999</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

String	ls_CurrentDir

ls_CurrentDir = Space (80)

GetCurrentDirectoryA(80, ls_CurrentDir)

Return ls_CurrentDir


end function

public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_dialog_title">Title to Display on Dialog</Argument>
	<Argument Name="as_pathname">The pathname passed by reference</Argument>
	<Argument Name="as_filename">The FileName passed by reference</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the overloaded function adding the current filter as the filter
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_GetFileOpenName(as_dialog_title, as_pathname, as_filename, '', Filter)

end function

public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename, string as_extension);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_dialog_title">Title to Display on Dialog</Argument>
	<Argument Name="as_pathname">The pathname passed by reference</Argument>
	<Argument Name="as_filename">The FileName passed by reference</Argument>
	<Argument Name="as_extension">Extention to look for.  Example *.doc</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the overloaded function adding the current filter as the filter
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_GetFileOpenName(as_dialog_title, as_pathname, as_filename, as_extension, Filter)

end function

public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename, string as_extension, string as_filter);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_dialog_title">Title to Display on Dialog</Argument>
	<Argument Name="as_pathname">The pathname passed by reference</Argument>
	<Argument Name="as_filename">The FileName passed by reference</Argument>
	<Argument Name="as_extension">Extention to look for.  Example *.doc</Argument>
	<Argument Name="as_filter">Filter string to limit the files listed.</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the filter to windows standard
//-----------------------------------------------------------------------------------------------------------------------------------
as_filter = of_convert_filter(as_filter)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the options for the dialog
//-----------------------------------------------------------------------------------------------------------------------------------
If Flags = 0 then Flags = This.of_bitor({OFN_HIDEREADONLY, Flags})

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the initial directory if there is one
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(as_pathname) Then
	InitialDir  = as_pathname
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dialog title
//-----------------------------------------------------------------------------------------------------------------------------------
Title = as_dialog_title + Space(255 - Len(as_dialog_title))

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the file type filter
//-----------------------------------------------------------------------------------------------------------------------------------
Filter = as_filter

//-----------------------------------------------------------------------------------------------------------------------------------
// If the open is successful, set the reference variables and return a 1 for success
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_open_file() Then
	as_pathname = PathName
	If Right(Trim(as_pathname), 1) <> '\' Then
		as_pathname = Trim(as_pathname) + '\'
	End If
	as_filename = Filename	
	as_pathname = as_pathname + as_filename
	Return 1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// These two instance variables are set this way when the user clicks cancel
//-----------------------------------------------------------------------------------------------------------------------------------
If FileName  = "" And FileCount = 0 Then
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Otherwise there must have been an error
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1
end function

public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_dialog_title">Title to Display on Dialog</Argument>
	<Argument Name="as_pathname">The pathname passed by reference</Argument>
	<Argument Name="as_filename">The FileName passed by reference</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the overloaded function adding the current filter as the filter
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_GetFileOpenName(as_dialog_title, as_pathname, as_filename, '', Filter)

end function

public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename[], string as_extension);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_dialog_title">Title to display on dialog.</Argument>
	<Argument Name="as_pathname">The pathname passed by reference.</Argument>
	<Argument Name="as_filename">The FileName passed by reference.</Argument>
	<Argument Name="as_extention">The extention to search for.</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the overloaded function adding the current filter as the filter
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_GetFileOpenName(as_dialog_title, as_pathname, as_filename, as_extension, Filter)

end function

public function integer of_getfileopenname (string as_dialog_title, ref string as_pathname, ref string as_filename[], string as_extension, string as_filter);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_dialog_title">Title to display on dialog.</Argument>
	<Argument Name="as_pathname">The pathname passed by reference.</Argument>
	<Argument Name="as_filename">The FileName passed by reference.</Argument>
	<Argument Name="as_extention">The extention to search for.</Argument>
	<Argument Name="as_filter">String to use to filter the list of files.</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the filter to windows standard
//-----------------------------------------------------------------------------------------------------------------------------------
as_filter = of_convert_filter(as_filter)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the options for the dialog
//-----------------------------------------------------------------------------------------------------------------------------------
If Flags = 0 then Flags = This.of_bitor({OFN_HIDEREADONLY, OFN_ALLOWMULTISELECT, OFN_EXPLORER})

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the initial directory if there is one
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(as_pathname) Then
	InitialDir  = as_pathname
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dialog title
//-----------------------------------------------------------------------------------------------------------------------------------
Title = as_dialog_title + Space(255 - Len(as_dialog_title))

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the file type filter
//-----------------------------------------------------------------------------------------------------------------------------------
Filter = as_filter

//-----------------------------------------------------------------------------------------------------------------------------------
// If the open is successful, set the reference variables and return a 1 for success
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_open_file() Then
	as_pathname = PathName
	If Right(Trim(as_pathname), 1) <> '\' Then
		as_pathname = Trim(as_pathname) + '\'
	End If
	as_filename = Files[]
	Return 1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// These two instance variables are set this way when the user clicks cancel
//-----------------------------------------------------------------------------------------------------------------------------------
If FileName  = "" And FileCount = 0 Then
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Otherwise there must have been an error
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1
end function

public function integer of_getfilesavename (string as_dialog_title, ref string as_pathname, ref string as_filename);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_dialog_title">Title to display on dialog.</Argument>
	<Argument Name="as_pathname">The pathname passed by reference.</Argument>
	<Argument Name="as_filename">The FileName passed by reference.</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the overloaded function adding the current filter as the filter
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_GetFileSaveName(as_dialog_title, as_pathname, as_filename, '', Filter)

end function

public function integer of_getfilesavename (string as_dialog_title, ref string as_pathname, ref string as_filename, string as_extension);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_dialog_title">Title to display on dialog.</Argument>
	<Argument Name="as_pathname">The pathname passed by reference.</Argument>
	<Argument Name="as_filename">The FileName passed by reference.</Argument>
	<Argument Name="as_extention">The extention to search for.</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the overloaded function adding the current filter as the filter
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_GetFileSaveName(as_dialog_title, as_pathname, as_filename, as_extension, Filter)

end function

public function integer of_getfilesavename (string as_dialog_title, ref string as_pathname, ref string as_filename, string as_extension, string as_filter);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
	<Argument Name="as_dialog_title">Title to display on dialog.</Argument>
	<Argument Name="as_pathname">The pathname passed by reference.</Argument>
	<Argument Name="as_filename">The FileName passed by reference.</Argument>
	<Argument Name="as_extention">The extention to search for.</Argument>
	<Argument Name="as_filter">String to use to filter the list of files.</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the filter to windows standard
//-----------------------------------------------------------------------------------------------------------------------------------
as_filter = of_convert_filter(as_filter)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the options for the dialog
//-----------------------------------------------------------------------------------------------------------------------------------
If Flags = 0 then Flags = This.of_bitor({OFN_HIDEREADONLY, OFN_OVERWRITEPROMPT})

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the initial directory if there is one
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(as_pathname) Then
	InitialDir  = as_pathname
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dialog title
//-----------------------------------------------------------------------------------------------------------------------------------
Title = as_dialog_title + Space(255 - Len(as_dialog_title))

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the file type filter
//-----------------------------------------------------------------------------------------------------------------------------------
Filter = as_filter

//-----------------------------------------------------------------------------------------------------------------------------------
// If the save is successful, set the reference variables and return a 1 for success
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_save_file() Then
	as_pathname = PathName
	If Right(Trim(as_pathname), 1) <> '\' Then
		as_pathname = Trim(as_pathname) + '\'
	End If
	as_filename = Filename	

	If Len(Trim(as_extension)) > 0 And Not IsNull(as_extension) Then
		If Pos(as_filename, '.') = 0 Then
			as_filename = as_filename + '.' + as_extension
		End If
	End If
	
	as_pathname = as_pathname + as_filename	

	Return 1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// These two instance variables are set this way when the user clicks cancel
//-----------------------------------------------------------------------------------------------------------------------------------
If FileName  = "" Then
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Otherwise there must have been an error
//-----------------------------------------------------------------------------------------------------------------------------------
as_pathname = PathName
as_filename = Filename
Return -1
end function

private function boolean of_open_file ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the File Open Dialog.  If it suceeds, it returns a 0, if it fails it returns a -1</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
/*
This function displays the open dialog box available in the COMDLG32 library..

Members available:

string Filter			=> This member allows to specify a list of tab separated filters;
integer FilterIndex	=> Default filter index
string InitialDir		=> Default directory (for the dialog box)
string Title			=> Dialog title
long Flags				=> Dialog Flags
string Filename 		=> returns selected file
string Files[]			=> Array with the list of selected files
string PathName		=> Path of the files
integer FileCount		=> Number of selected files
*/

OPENFILENAME OpenFileName
string ls_Token, Empty[]
integer li_TabPos, li_Start

OpenFileName.lStructSize	= 76
OpenFileName.hWndOwner		= hWndParent
OpenFileName.hInstance		= 0
OpenFileName.lpstrFilter	= LocalAlloc(LMEM_ZEROINIT,Len(Filter) + 2) // 2 nulls to signal end
If OpenFileName.lpstrFilter = 0 Then
	MessageBox("Error","Cannot alloc requested memory!",StopSign!,Ok!)
	Return(False)
End If

// Tab separator to Null separator 
li_Start  = 1
li_TabPos = Pos(Filter,"~t",1)
Do While li_TabPos > 0
	ls_Token = Mid(Filter,li_Start,li_TabPos - li_Start)
	StrCopy(OpenFileName.lpstrFilter + (li_Start - 1),ls_Token,Len(ls_Token))
	li_Start		= li_TabPos + 1
	li_TabPos	= Pos(Filter,"~t",li_TabPos + 1)
Loop
ls_Token	= Mid(Filter,li_Start)
StrCopy(OpenFileName.lpstrFilter + (li_Start - 1),ls_Token,Len(ls_Token))

OpenFileName.lpstrCustomFilter	= 0
OpenFileName.nMaxCustomFilter		= 0
OpenFileName.nFilterIndex 			= FilterIndex

OpenFileName.lpstrFile				= LocalAlloc(LMEM_ZEROINIT,MAXFILENAME * MAXFILES)
if DefaultFileName <> "" then StrCopy(OpenFileName.lpstrFile, DefaultFileName, len(DefaultFileName))

OpenFileName.nMaxFile				= MAXFILENAME * MAXFILES
OpenFileName.lpstrFileTitle		= LocalAlloc(0,MAXFILENAME)
OpenFileName.nMaxFileTitle			= MAXFILENAME
OpenFileName.lpstrInitialDir		= LocalAlloc(0,MAXPATHNAME)
StrCopy(OpenFileName.lpstrInitialDir,InitialDir,Len(InitialDir))
OpenFileName.lpstrTitle				= LocalAlloc(0,255)
StrCopy(OpenFileName.lpstrTitle,Title,Len(Title))
OpenFileName.Flags					= Flags
OpenFileName.nFileOffSet			= 0
OpenFileName.nFileExtension		= 0
OpenFileName.lpstrDefExt			= 0
OpenFileName.lCustData				= 0
OpenFileName.lpfnHook				= 0
OpenFileName.lpTemplateName		= 0

Files = Empty // Reset array
FileCount = 0

If GetOpenFileNameA(OpenFileName) = 1 Then // Pressed OK button
	PathName = Left(String(OpenFileName.lpstrFile,"address"),OpenFileName.nFileOffSet - 1)
	li_Start = 0
	Do
		ls_Token = String(OpenFileName.lpstrFile + OpenFileName.nFileOffSet + li_Start,"address")
		If ls_Token <> "" Then
			FileCount++
			Files[FileCount] = ls_Token
		End If
		li_Start += Len(ls_Token) + 1
	Loop Until ls_Token = ""
	FileName = Files[1]
Else
	FileName  = ""
	FileCount = 0
End If

LocalFree(OpenFileName.lpstrFilter)
LocalFree(OpenFileName.lpstrFile)
LocalFree(OpenFileName.lpstrFileTitle)
LocalFree(OpenFileName.lpstrTitle)
LocalFree(OpenFileName.lpstrInitialDir)

Return(FileCount > 0)
end function

public function boolean of_open_print_dialog ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the PrintDialog.  It then sets the printer settings. If it suceeds, it returns True, if it fails it returns False</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
/*

Shows the print dialog box... 

Members:

integer FromPage	// Print from page
integer ToPage		// Print to page
integer MinPage	// Min page (smaller page)
integer MaxPage	// Max page (higher page)
PROTECTEDWRITE integer Copies = 1 // Nº of copies to print...

*/

PRINTDLG PrintDlg
DEVMODE DevMode
DEVNAMES DevNames
long pDevNames, pDevMode

PrintDlg.lStructSize 	= 66
PrintDlg.hWndOwner		= hWndParent
PrintDlg.hDevMode			= 0
PrintDlg.hDevNames		= 0
PrintDlg.hDC				= 0
PrintDlg.Flags				= Flags
PrintDlg.nFromPage		= FromPage
PrintDlg.nToPage			= ToPage
PrintDlg.nMinPage			= MinPage
PrintDlg.nMaxPage			= MaxPage
PrintDlg.nCopies			= 0
PrintDlg.hInstance		= 0
PrintDlg.lCustData		= 0
PrintDlg.lpfnPrintHook	= 0
PrintDlg.lpfnSetupHook	= 0
PrintDlg.lpPrintTemplateName = 0
PrintDlg.lpSetupTemplateName = 0
PrintDlg.hPrintTemplate	= 0
PrintDlg.hSetupTemplate = 0

If PrintDlgA(PrintDlg) = 1 Then

	pDevMode = LocalLock(PrintDlg.hDevMode)
	GetDevMode(DevMode,pDevMode,148) // Lock dynamic memory handle
	LocalUnlock(pDevMode) // Unlock dynamic memory handle

	pDevNames = LocalLock(PrintDlg.hDevNames)
	GetDevNames(DevNames,pDevNames,8) // Lock dynamic memory handle
	LocalUnlock(pDevNames) // Unlock dynamic memory handle

	FromPage	= PrintDlg.nFromPage
	ToPage	= PrintDlg.nToPage
	MinPage 	= PrintDlg.nMinPage
	MaxPage 	= PrintDlg.nMaxPage
	Copies	= PrintDlg.nCopies
	
	If Copies = 1 Then // Copies are provided by devmode..
		Copies = DevMode.dmCopies
	End If

	This.of_Set_Printer(String(pDevNames + DevNames.wDeviceOffset,"address"), &
				  String(pDevNames + DevNames.wDriverOffset,"address"), &
				  String(pDevNames + DevNames.wOutPutOffset,"address"))

	Return(True)

End If	
	
Return(False)

end function

public function long of_bitor (long values[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This function performs a bitwise or operation on two long variables.  </Description>
<Arguments>
	<Argument Name="values[]">Array of Long variables - Ignores any after the first two in the array.</Argument>
	<Argument Name="Argument1">Description</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

// Performs a bitwise or between 2 =>long<= values...
integer li_Bit, li_Size, li_Number = 2
long ll_RetValue, ll_ValueA, ll_ValueB

li_Size	= UpperBound(Values)
If li_Size < 2 Then 
	MessageBox("Error","This function needs 2 values!",StopSign!,Ok!)
	Return(-1)
End If

ll_RetValue = 0 
ll_ValueA = Values[1]

Do 
	ll_ValueB = Values[li_Number]

	For li_Bit = 0 To 31
		If Mod(Long(ll_ValueA /  2^li_Bit), 2) > 0 Or Mod(Long(ll_ValueB /  2^li_Bit), 2) > 0 Then
			If Not Mod(Long(ll_RetValue /  2^li_Bit), 2) > 0 then
				ll_RetValue += 2^li_Bit
			End If
		End If
	Next

	ll_ValueA = ll_RetValue
	li_Number++
Loop Until li_Number > li_Size

Return(ll_RetValue)
end function

private function boolean of_save_file ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the Save File Dialog.  If it suceeds, it returns True, if it fails it returns False</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

/*
This function displays the save dialog box available in the COMDLG32 library..

Members available:

string Filter			=> This member allows to specify a list of tab separated filters;
integer FilterIndex	=> Default filter index (returns the selected filter)
string InitialDir		=> Default directory (for the dialog box)
string Title			=> Dialog title
long Flags				=> Dialog Flags
string Filename 		=> returns selected file
string Files[]			=> Array with the list of selected files
string PathName		=> Path of the files
integer FileCount		=> Number of selected files
*/

OPENFILENAME SaveFileName
string ls_Token, Filters[]
integer li_TabPos, li_Start

SaveFileName.lStructSize	= 76
SaveFileName.hWndOwner		= hWndParent
SaveFileName.hInstance		= 0
SaveFileName.lpstrFilter	= LocalAlloc(LMEM_ZEROINIT,Len(Filter) + 2) // 2 nulls to signal end
If SaveFileName.lpstrFilter = 0 Then
	MessageBox("Error","Cannot alloc requested memory!",StopSign!,Ok!)
	Return(False)
End If

// Tab separator to Null separator 
li_Start  = 1
li_TabPos = Pos(Filter,"~t",1)
Do While li_TabPos > 0
	ls_Token = Mid(Filter,li_Start,li_TabPos - li_Start)
	StrCopy(SaveFileName.lpstrFilter + (li_Start - 1),ls_Token,Len(ls_Token))
	li_Start		= li_TabPos + 1
	li_TabPos	= Pos(Filter,"~t",li_TabPos + 1)
	Filters[UpperBound(Filters) + 1] = Mid(ls_Token,2)
Loop
ls_Token	= Mid(Filter,li_Start)
StrCopy(SaveFileName.lpstrFilter + (li_Start - 1),ls_Token,Len(ls_Token))

SaveFileName.lpstrCustomFilter	= 0
SaveFileName.nMaxCustomFilter		= 0
SaveFileName.nFilterIndex 			= FilterIndex
SaveFileName.lpstrFile				= LocalAlloc(LMEM_ZEROINIT,MAXFILENAME) 
SaveFileName.nMaxFile				= MAXFILENAME
SaveFileName.lpstrFileTitle		= LocalAlloc(0,MAXFILENAME)
SaveFileName.nMaxFileTitle			= MAXFILENAME
SaveFileName.lpstrInitialDir		= LocalAlloc(0,MAXPATHNAME)
StrCopy(SaveFileName.lpstrInitialDir,InitialDir,Len(InitialDir))
SaveFileName.lpstrTitle				= LocalAlloc(0,255)
StrCopy(SaveFileName.lpstrTitle,Title,Len(Title))
SaveFileName.Flags					= Flags
SaveFileName.nFileOffSet			= 0
SaveFileName.nFileExtension		= 0
SaveFileName.lpstrDefExt			= 0
SaveFileName.lCustData				= 0
SaveFileName.lpfnHook				= 0
SaveFileName.lpTemplateName		= 0

If GetSaveFileNameA(SaveFileName) = 1 Then // Pressed OK button
	PathName = Left(String(SaveFileName.lpstrFile,"address"),SaveFileName.nFileOffSet - 1)
	FileName = String(SaveFileName.lpstrFile + SaveFileName.nFileOffSet,"address")
	If SaveFileName.nFileExtension = Len(PathName) + Len(FileName) + 1 Then
		FileName += Filters[2 * SaveFileName.nFilterIndex]
	End If
Else
	FileName  = ""
End If

LocalFree(SaveFileName.lpstrFilter)
LocalFree(SaveFileName.lpstrFile)
LocalFree(SaveFileName.lpstrFileTitle)
LocalFree(SaveFileName.lpstrTitle)
LocalFree(SaveFileName.lpstrInitialDir)

Return(FileName <> "")
end function

public function boolean of_select_font ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Display the standard Font Dialog Box. </Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
/*
This function displays the font dialog box available in the COMDLG32 library..

Members:

integer FontType
integer SizeMin
integer SizeMax
string FaceName
long  Height
long  Weight
boolean Italic
boolean Underline
boolean StrikeOut

*/
CHOOSEFONT ChooseFont
LOGFONT	LogFont
boolean lb_Result
If Flags = 0 Then Flags = of_BitOr({CF_FORCEFONTEXIST,CF_BOTH,CF_EFFECTS,CF_INITTOLOGFONTSTRUCT})

LogFont.lfFaceName	= FaceName
LogFont.lfHeight		= Height
LogFont.lfWeight		= Weight
If Italic Then LogFont.lfItalic = Char(255) Else LogFont.lfItalic = Char(0)
If Underline Then LogFont.lfUnderline = Char(1) Else LogFont.lfUnderline = Char(0)
If StrikeOut Then LogFont.lfStrikeOut = Char(1) Else LogFont.lfStrikeOut = Char(0)

ChooseFont.lStructSize	= 60
ChooseFont.hWndOwner		= hWndParent
ChooseFont.hDC				= 0
ChooseFont.lpLogFont		= LocalAlloc(0,60)
PutLogFont(ChooseFont.lpLogFont,LogFont,60)
ChooseFont.iPointSize	= 0
ChooseFont.Flags			= Flags
ChooseFont.RGBColors		= RGBColors
ChooseFont.lCustData		= 0
ChooseFont.lpfnHook		= 0
ChooseFont.lpTemplateName	= 0
ChooseFont.hInstance 	= 0
ChooseFont.lpszStyle 	= 0
ChooseFont.nFontType 	= FontType
ChooseFont.nSizeMin 		= SizeMin
ChooseFont.nSizeMax 		= SizeMax

If ChooseFontA(ChooseFont) = 1 Then
	GetLogFont(LogFont,ChooseFont.lpLogFont,60)

	FontType	= ChooseFont.nFontType
	FaceName	= LogFont.lfFaceName
	Height	= LogFont.lfHeight
	Weight	= LogFont.lfWeight
	Italic	= (Asc(LogFont.lfItalic) 	 = 255)
	Underline= (Asc(LogFont.lfUnderline) = 1)
	StrikeOut= (Asc(LogFont.lfStrikeOut) = 1)

	lb_Result = True
Else
	FontType	= 0
	FaceName	= ""
	Height	= 0
	Weight	= 0
	Italic	= False
	Underline= False
	StrikeOut= False
	lb_Result = False
End If

LocalFree(ChooseFont.lpLogFont)

Return(lb_Result)

end function

public subroutine of_set_printer (string printername, string driver, string port);/*<Documentation>----------------------------------------------------------------------------------------------------
<Name>of_GetFileOpenName</Name>
<Description>Set's the Printer based on settings returned from the Print Dialog.</Description>
<Arguments>
	<Argument Name="printername">Name of the printer</Argument>
	<Argument Name="driver">Name of the driver used for the specified printer.</Argument>
	<Argument Name="port">Name of the port to use with the specified printer</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/


// PrinterName => Name of the new printer
// Driver => Driver of the new printer
// Port => Port of the new printer

Environment Env
string ls_WinDir

GetEnvironment(Env)

Choose Case Env.OSType
	Case Windows!
		RegistrySet("HKEY_LOCAL_MACHINE\Config\0001\System\CurrentControlSet\Control\Print\Printers", "Default", PrinterName)
		ls_WinDir = Space(260)
		GetWindowsDirectoryA(ls_WinDir,260) // GetWindows directory
		SetProfileString(ls_WinDir + "\WIN.INI","Windows","Device",PrinterName + "," + Driver + "," + Port)
	Case WindowsNT!
		RegistrySet("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows","Device", PrinterName)
End Choose
end subroutine

public function boolean of_setcurrentdirectory (string as_newdirectory);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Changes the current directory to the path specified.</Description>
<Arguments>
	<Argument Name="as_newdirectory">The directory path you want to set.</Argument>
	<Argument Name="as_pathname">The pathname passed by reference.</Argument>
	<Argument Name="as_filename">The FileName passed by reference.</Argument>
	<Argument Name="as_extention">The extention to search for.</Argument>
	<Argument Name="as_filter">String to use to filter the list of files.</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Return SetCurrentDirectoryA(as_newdirectory)

end function

on n_common_dialog.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_common_dialog.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*<Abstract>----------------------------------------------------------------------------------------------------
This object contains functions which allow the developer to display Windows Common Dialogs for selecting directories 
and files.
</Abstract>----------------------------------------------------------------------------------------------------*/



end event

