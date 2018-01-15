$PBExportHeader$n_file_manipulator.sru
$PBExportComments$API object specific to the WIN32 API for getting and manipulating information about files. GLH
forward
global type n_file_manipulator from n_api_fileservices
end type
type os_filedatetime from structure within n_file_manipulator
end type
type os_systemtime from structure within n_file_manipulator
end type
type os_securityattributes from structure within n_file_manipulator
end type
type os_finddata from structure within n_file_manipulator
end type
type os_fileopeninfo from structure within n_file_manipulator
end type
end forward

type os_filedatetime from structure
	unsignedlong		ul_lowdatetime
	unsignedlong		ul_highdatetime
end type

type os_systemtime from structure
    uint ui_wYear
    uint ui_WMonth
    uint ui_WDayOfWeek
    uint ui_WDay
    uint ui_wHour
    uint ui_wMinute 
    uint ui_wSecond
    uint ui_wMilliseconds
end type

type os_securityattributes from structure
	ulong		ul_Length
	char		ch_description
	boolean	b_inherit
end type

type os_finddata from structure
	unsignedlong		ul_fileattributes
	os_filedatetime		str_creationtime
	os_filedatetime		str_lastaccesstime
	os_filedatetime		str_lastwritetime
	unsignedlong		ul_filesizehigh
	unsignedlong		ul_filesizelow
	unsignedlong		ul_reserved0
	unsignedlong		ul_reserved1
	character		ch_filename[260]
	character		ch_alternatefilename[14]
end type

type os_fileopeninfo from structure
	character		c_length
	character		c_fixed_disk
	uint		ui_dos_error
	uint		ui_na1
	uint		ui_na2
	character		c_pathname[128]
end type

global type n_file_manipulator from n_api_fileservices
string is_separator = "\"
string is_allfiles = "*.*"
end type

type prototypes
// Win 32 calls
Function uint GetDriveTypeA (string drive) library "KERNEL32.DLL" alias for "GetDriveTypeA;Ansi"
Function boolean CreateDirectoryA (ref string directoryname, ref os_securityattributes secattr) library "KERNEL32.DLL" alias for "CreateDirectoryA;Ansi"
Function boolean RemoveDirectoryA (ref string directoryname) library "KERNEL32.DLL" alias for "RemoveDirectoryA;Ansi"
Function ulong GetCurrentDirectoryA (ulong textlen, ref string dirtext) library "KERNEL32.DLL" alias for "GetCurrentDirectoryA;Ansi"
Function boolean SetCurrentDirectoryA (ref string directoryname ) library "KERNEL32.DLL" alias for "SetCurrentDirectoryA;Ansi"
Function ulong GetFileAttributesA (ref string filename) library "KERNEL32.DLL" alias for "GetFileAttributesA;Ansi"
Function boolean SetFileAttributesA (ref string filename, ulong attrib) library "KERNEL32.DLL" alias for "SetFileAttributesA;Ansi"
Function boolean MoveFileA (ref string oldfile, ref string newfile) library "KERNEL32.DLL" alias for "MoveFileA;Ansi"
Function ulong MoveFileExA (string lpExistingFileName, string lpNewFileName, long dwFlags) library "kernel32.dll" alias for "MoveFileExA;Ansi"
Function long FindFirstFileA (ref string filename, ref os_finddata findfiledata) library "KERNEL32.DLL" alias for "FindFirstFileA;Ansi"
Function long FindFirstFileExA (ref string filename, ulong FINDEX_INFO_LEVELS, ref os_finddata findfiledata, ulong FINDEX_SEARCH_OPS, long l_null, long l_zero) library "KERNEL32.DLL" alias for "FindFirstFileExA;Ansi"
Function boolean FindNextFileA (long handle, ref os_finddata findfiledata) library "KERNEL32.DLL" alias for "FindNextFileA;Ansi"
Function boolean FindClose (long handle) library "KERNEL32.DLL"
Function boolean GetDiskFreeSpaceA (string drive, ref long sectpercluster, ref long bytespersect, ref long freeclusters, ref long totalclusters) library "KERNEL32.DLL" alias for "GetDiskFreeSpaceA;Ansi"
Function long GetLastError() library "KERNEL32.DLL"

// Win32 calls for file date and time
Function ulong OpenFile (ref string filename, ref os_fileopeninfo of_struct, uint action) LIBRARY "KERNEL32.DLL" alias for "OpenFile;Ansi"
Function boolean CloseHandle (ulong file_hand) LIBRARY "KERNEL32.DLL"
Function boolean GetFileTime(long hFile, ref os_filedatetime  lpCreationTime, ref os_filedatetime  lpLastAccessTime, ref os_filedatetime  lpLastWriteTime  )  library "KERNEL32.DLL" alias for "GetFileTime;Ansi"
Function boolean FileTimeToSystemTime(ref os_filedatetime lpFileTime, ref os_systemtime lpSystemTime) library "KERNEL32.DLL" alias for "FileTimeToSystemTime;Ansi"
Function boolean FileTimeToLocalFileTime(ref os_filedatetime lpFileTime, ref os_filedatetime lpLocalFileTime) library "KERNEL32.DLL" alias for "FileTimeToLocalFileTime;Ansi"
Function boolean SetFileTime(ulong hFile, os_filedatetime  lpCreationTime, os_filedatetime  lpLastAccessTime, os_filedatetime  lpLastWriteTime  )  library "KERNEL32.DLL" alias for "SetFileTime;Ansi"
Function boolean SystemTimeToFileTime(os_systemtime lpSystemTime, ref os_filedatetime lpFileTime) library "KERNEL32.DLL" alias for "SystemTimeToFileTime;Ansi"
Function boolean LocalFileTimeToFileTime(ref os_filedatetime lpLocalFileTime, ref os_filedatetime lpFileTime) library "KERNEL32.DLL" alias for "LocalFileTimeToFileTime;Ansi"
Function ulong SearchPathA(string lpszPath, string lpszFile, string lpszExtension, ulong dwReturnBuffer, REF string lpszReturnBuffer, REF string plpszFilePart) library 'kernel32.dll' alias for "SearchPathA;Ansi"

end prototypes

type variables
// MoveFile Constants
CONSTANT uint MOVEFILE_COPY_ALLOWED = 1
CONSTANT uint MOVEFILE_DELAY_UNTIL_REBOOT = 2
CONSTANT uint MOVEFILE_REPLACE_EXISTING = 4

end variables

forward prototypes
public function string of_getcurrentdirectory ()
public function integer of_changedirectory (string as_newdirectory)
protected function integer of_convertpbdatetimetofile (date ad_filedate, time at_filetime, ref os_filedatetime astr_filetime)
protected function integer of_convertfiledatetimetopb (os_filedatetime astr_filetime, ref date ad_filedate, ref time at_filetime)
public function integer of_createdirectory (string as_directoryname)
public function boolean of_directoryexists (string as_directoryname)
public function integer of_dirlist (string as_filespec, long al_filetype, ref n_api_directory_attributes anv_dirlist[])
public function integer of_filerename (string as_sourcefile, string as_targetfile)
public function string of_getaltfilename (string as_longfilename)
public function integer of_getcreationdatetime (string as_filename, ref date ad_date, ref time at_time)
public function integer of_getdiskspace (character ac_drive, ref long al_totalspace, ref long al_freespace)
public function integer of_getdrivetype (character ac_drive)
public function integer of_getfileattributes (string as_filename, ref boolean ab_readonly, ref boolean ab_hidden, ref boolean ab_system, ref boolean ab_subdirectory, ref boolean ab_archive)
public function double of_getfilesize (string as_filename)
public function integer of_getlastaccessdate (string as_filename, ref date ad_date)
public function integer of_getlastwritedatetime (string as_filename, ref date ad_date, ref time at_time)
public function string of_getlongfilename (string as_altfilename)
public function integer of_removedirectory (string as_directoryname)
public function integer of_setcreationdatetime (string as_filename, date ad_date, time at_time)
public function integer of_setfileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive)
public function integer of_setlastaccessdate (string as_filename, date ad_date)
public function integer of_setlastwritedatetime (string as_filename, date ad_date, time at_time)
public function boolean of_build_file_from_blob (string as_filename, character ac_replace, ref blob ab_data)
public function string of_findfile (string as_filename)
end prototypes

public function string of_getcurrentdirectory ();////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_GetCurrentDirectory
//
//	Purpose:  Get the current working directory.
//
//	Scope:  public
//
//	Arguments:	None
//
//	Returns:		String			the current working directory
//
//	Written by Powersoft Corporation, 1995
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_CurrentDir

ls_CurrentDir = Space (260)

GetCurrentDirectoryA(260, ls_CurrentDir)

Return ls_CurrentDir

end function

public function integer of_changedirectory (string as_newdirectory);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_ChangeDirectory()
//	Arguments:  as_NewDirectory -	The name of the new working directory; an absolute path may be specified or it will	be relative
//											to the current working directory
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Change the current working directory.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer	li_RC

If Trim(as_NewDirectory) = "" Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
//	Call Windows API call to set the current directory.
//-----------------------------------------------------------------------------------------------------------------------------------
If SetCurrentDirectoryA(as_NewDirectory) Then
	li_RC = 1
Else
	li_RC = -1
End If

Return li_RC

end function

protected function integer of_convertpbdatetimetofile (date ad_filedate, time at_filetime, ref os_filedatetime astr_filetime);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_ConvertPBDatetimeToFile
//
//	Access:  protected
//
//	Arguments:
//	ad_FileDate				The file date in PowerBuilder Date format.
//	at_FileTime				The file time in PowerBuilder Time format.
//	astr_FileTime				The os_filedatetime structure to contain the 
//									system date/time for the file, passed by reference.
//
//	Returns:		Integer
//					1 if successful, -1 if an error occurrs.
//
//	Description:	Convert PowerBuilder Date and Time to the sytem file type.
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
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Powersoft is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

String				ls_Date, ls_Time
os_filedatetime	lstr_LocalTime
os_systemtime	lstr_SystemTime

ls_Date = String(ad_FileDate, "yyyy-mm-dd")
lstr_SystemTime.ui_wyear = Long(Left(ls_Date, 4))
lstr_SystemTime.ui_WMonth = Long(Mid(ls_Date, 6, 2))
lstr_SystemTime.ui_WDay = Long(Right(ls_Date, 2))

ls_Time = String(at_FileTime, "hh:mm:ss:ffffff")
lstr_SystemTime.ui_wHour = Long(Left(ls_Time, 2))
lstr_SystemTime.ui_wMinute = Long(Mid(ls_Time, 4, 2))
lstr_SystemTime.ui_wSecond = Long(Mid(ls_Time, 7, 2))
lstr_SystemTime.ui_wMilliseconds = Long(Right(ls_Time, 6))

If Not SystemTimeToFileTime(lstr_SystemTime, lstr_LocalTime) Then Return -1

If Not LocalFileTimeToFileTime(lstr_LocalTime, astr_FileTime) Then Return -1

Return 1

end function

protected function integer of_convertfiledatetimetopb (os_filedatetime astr_filetime, ref date ad_filedate, ref time at_filetime);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_ConvertFileDatetimeToPB
//
//	Access:  protected
//
//	Arguments:
//	astr_FileTime				The os_filedatetime structure containg the 
//									system date/time for the file.
//	ad_FileDate				The file date in PowerBuilder Date format,
//									passed by reference.
//	at_FileTime				The file time in PowerBuilder Time format,
//									passed by reference.
//
//	Returns:		Integer
//					1 if successful, -1 if an error occurrs.
//
//	Description:	Convert a sytem file type to PowerBuilder Date and Time.
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
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Powersoft is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

String				ls_Date, ls_Time
os_filedatetime	lstr_LocalTime
os_systemtime	lstr_SystemTime

If Not FileTimeToLocalFileTime(astr_FileTime, lstr_LocalTime) Then Return -1

If Not FileTimeToSystemTime(lstr_LocalTime, lstr_SystemTime) Then Return -1

ls_Date = String(lstr_SystemTime.ui_WMonth) + "/" + &
				String(lstr_SystemTime.ui_WDay) + "/" + &
				String(lstr_SystemTime.ui_wyear)
ad_FileDate = Date(ls_Date)

ls_Time = String(lstr_SystemTime.ui_wHour) + ":" + &
				String(lstr_SystemTime.ui_wMinute) + ":" + &
				String(lstr_SystemTime.ui_wSecond) + ":" + &
				String(lstr_SystemTime.ui_wMilliseconds)
at_FileTime = Time(ls_Time)

Return 1

end function

public function integer of_createdirectory (string as_directoryname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_createdirectory()
//	Arguments:  as_directoryname - Directory to create
//	Returns:		int
//						 1 if it succeeds,
//						-1 if it failes
//	Overview:   Create the specified directory.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

os_securityattributes	lstr_Security

lstr_Security.ul_Length = 7
lstr_Security.ch_description = "~000"	//use default security
lstr_Security.b_Inherit = False
If CreateDirectoryA(as_DirectoryName, lstr_Security) Then
	Return 1
Else
	Return -1
End If

end function

public function boolean of_directoryexists (string as_directoryname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_directoryexists()
//	Arguments:  as_directoryname - directory to check.
//	Returns:		boolean 
//						True - directory exists
//						False - Directory doesn't exists or function not found in descendent
//	Overview:   Check if the specified directory exists.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ULong	lul_RC

lul_RC = GetFileAttributesA(as_DirectoryName)

//-----------------------------------------------------------------------------------------------------------------------------------
// Check if 5th bit is set, if so this is a directory
//-----------------------------------------------------------------------------------------------------------------------------------
If Mod(Integer(lul_RC / 16), 2) > 0 Then 
	Return True
Else
	Return False
End If

end function

public function integer of_dirlist (string as_filespec, long al_filetype, ref n_api_directory_attributes anv_dirlist[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_DirList()
//	Arguments:  as_filespec - 	The file spec. to list (including wildcards); an absolute path may be specified or it will	be relative
//										to the current working directory
//					al_filetyp -	anv_dirlist[] - array of objects which contain the directory attributes for any subdirectories
//										contained in the list.
//	Returns:		Integer
//						The number of elements in anv_DirList if successful,
//						-1 if an error occurrs.
//	Overview:   List the contents of a directory (Name, Date, Time, and Size).
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer					li_Cnt, li_Entries
Long						ll_Handle
String					ls_Time, ls_Date
Char						lc_Drive
Boolean					lb_Found
Time						lt_Time
os_finddata			lstr_FindData
n_api_directory_attributes			lnv_Empty[]
n_numerical		lnv_Numeric

//-----------------------------------------------------------------------------------------------------------------------------------
// Empty the result array
//-----------------------------------------------------------------------------------------------------------------------------------
anv_DirList = lnv_Empty

//-----------------------------------------------------------------------------------------------------------------------------------
// List the entries in the directory
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_FileSpec, lstr_FindData)
If ll_Handle <= 0 Then Return -1
Do
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine if this file should be included.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If of_IncludeFile(String(lstr_FindData.ch_filename), al_FileType, lstr_FindData.ul_FileAttributes) Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Add it to the array
		//-----------------------------------------------------------------------------------------------------------------------------------
		li_Entries ++
		anv_DirList[li_Entries].is_FileName = lstr_FindData.ch_filename
		anv_DirList[li_Entries].is_AltFileName = lstr_FindData.ch_alternatefilename
		If Trim(anv_DirList[li_Entries].is_AltFileName) = "" Then
			anv_DirList[li_Entries].is_AltFileName = anv_DirList[li_Entries].is_FileName
		End If
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set date and time
		//-----------------------------------------------------------------------------------------------------------------------------------
		of_ConvertFileDatetimeToPB(lstr_FindData.str_CreationTime, anv_DirList[li_Entries].id_CreationDate, &
													anv_DirList[li_Entries].it_CreationTime)
		of_ConvertFileDatetimeToPB(lstr_FindData.str_LastAccessTime, anv_DirList[li_Entries].id_LastAccessDate, lt_Time)
		of_ConvertFileDatetimeToPB(lstr_FindData.str_LastWriteTime, anv_DirList[li_Entries].id_LastWriteDate, &
													anv_DirList[li_Entries].it_LastWriteTime)
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Calculate file size
		//-----------------------------------------------------------------------------------------------------------------------------------
		anv_DirList[li_Entries].idb_FileSize = (lstr_FindData.ul_FileSizeHigh * (2.0 ^ 32))  + lstr_FindData.ul_FileSizeLow
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set file attributes
		//-----------------------------------------------------------------------------------------------------------------------------------
		anv_DirList[li_Entries].ib_ReadOnly = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 1)
		anv_DirList[li_Entries].ib_Hidden = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 2)
		anv_DirList[li_Entries].ib_System = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 3)
		anv_DirList[li_Entries].ib_SubDirectory = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 5)
		anv_DirList[li_Entries].ib_Archive = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 6)
		anv_DirList[li_Entries].ib_Drive = False
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Put brackets around subdirectories
		//-----------------------------------------------------------------------------------------------------------------------------------
		If anv_DirList[li_Entries].ib_SubDirectory Then
			anv_DirList[li_Entries].is_FileName = "[" + anv_DirList[li_Entries].is_FileName + "]"
			anv_DirList[li_Entries].is_AltFileName = "[" + anv_DirList[li_Entries].is_AltFileName + "]"
		End If
	End If
	
	lb_Found = FindNextFileA(ll_Handle, lstr_FindData)
Loop Until Not lb_Found
FindClose(ll_Handle)

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the drives if desired.
// If the type is > 32768 this was to prevent read-write files from being included.
//-----------------------------------------------------------------------------------------------------------------------------------
If al_FileType >=32768 Then al_FileType = al_FileType - 32768

//-----------------------------------------------------------------------------------------------------------------------------------
// If the type is > 16384, then a list of drives should be included
//-----------------------------------------------------------------------------------------------------------------------------------
If al_FileType >= 16384 Then
	For li_Cnt = 0 To 25
		lc_Drive = Char(li_Cnt + 97)
		If of_GetDriveType(lc_Drive) > 1 Then
			li_Entries ++
			anv_DirList[li_Entries].is_FileName = "[-" + lc_Drive + "-]"
			anv_DirList[li_Entries].is_AltFileName = anv_DirList[li_Entries].is_FileName
			anv_DirList[li_Entries].ib_ReadOnly = False
			anv_DirList[li_Entries].ib_Hidden = False
			anv_DirList[li_Entries].ib_System = False
			anv_DirList[li_Entries].ib_SubDirectory = False
			anv_DirList[li_Entries].ib_Archive = False
			anv_DirList[li_Entries].ib_Drive = True
		End if
	Next
End if

Return li_Entries
end function

public function integer of_filerename (string as_sourcefile, string as_targetfile);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_filerename()
//	Arguments:  as_sourcefile - Current name of file
//					as_targetfile - Destination name of file.
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Rename or move a file or directory.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer	li_RC

//-----------------------------------------------------------------------------------------------------------------------------------
//	Call WIN API call to move the file to the new destination.
//-----------------------------------------------------------------------------------------------------------------------------------
If MoveFileA(as_SourceFile, as_TargetFile) Then
	li_RC = 1
Else
	li_RC = -1
End If

Return li_RC

end function

public function string of_getaltfilename (string as_longfilename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getaltfilename()
//	Arguments:  as_longfilename - The long file name for which the alternate (short)file name is desired; an absolute path may be 
//											specified or it will be relative to the current working directory.
//	Returns:		String -
//						8.3 version of the filename.
//						'' if an error occurrs.
//	Overview:   Determine the 8.3 version of the Long Filename.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long						ll_Handle
String					ls_LongFileName
os_finddata	lstr_FindData

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the long file name
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_LongFileName, lstr_FindData)
If ll_Handle <= 0 Then Return ""
FindClose(ll_Handle)

Return lstr_FindData.ch_alternatefilename

end function

public function integer of_getcreationdatetime (string as_filename, ref date ad_date, ref time at_time);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getcreationdatetime()
//	Arguments:  as_FileName - 	The name of the file for which you want its date; an absolute path may be specified or it will be
//									  	relative to the current working directory
//					ad_Date 		-	The date the file was created, passed by reference.
//					at_Time		-	The time the file was created, passed by reference.
//	Returns:		Integer
//						 1 if successful, 
//						-1 if an error occurrs.
//	Overview:   Get the date a file was created.  This is only valid for Win32 and the function must be implemented in the descendent
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long						ll_Handle
String					ls_Time, ls_Date
os_finddata	lstr_FindData

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the file information
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_Handle <= 0 Then Return -1
FindClose(ll_Handle)

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the date and time
//-----------------------------------------------------------------------------------------------------------------------------------
Return of_ConvertFileDatetimeToPB(lstr_FindData.str_CreationTime, ad_Date, at_Time)

end function

public function integer of_getdiskspace (character ac_drive, ref long al_totalspace, ref long al_freespace);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getdiskspace()
//	Arguments:  as_drive			- Name of the drive
//					al_totalspace 	- Total space on the drive
//					al_freespace 	- Free space remaining on the drive.
//	Returns:		Integer
//						 1 if successful, 
//						-1 if an error occurrs.
//	Overview:   Return information about the amount of space on the drive.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_SectPerCluster, ll_BytesPerSect, ll_FreeClusters, ll_TotalClusters, ll_ClusterBytes

//-----------------------------------------------------------------------------------------------------------------------------------
//	Call WINAPI to get the free space on a drive.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not GetDiskFreeSpaceA(Upper(ac_Drive) + ":\", ll_SectPerCluster, ll_BytesPerSect, &
									ll_FreeClusters, ll_TotalClusters) Then Return -1

ll_ClusterBytes = ll_SectPerCluster * ll_BytesPerSect
al_TotalSpace = ll_ClusterBytes * ll_TotalClusters
al_FreeSpace = ll_ClusterBytes * ll_FreeClusters

Return 1

end function

public function integer of_getdrivetype (character ac_drive);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_GetDriveType()
//	Arguments:  ac_drive - Name of drive by the letter - i.e. C:
//	Returns:		Integer - The type of the drive:
//						2 - floppy drive,
//						3 - hard drive,
//						4 - network drive,
//						5 - cdrom drive,
//						6 - ramdisk,
//						any other value is the result of an error.
//	Overview:   Return the type of drive. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Cal WINAPI call to get the drive type
//-----------------------------------------------------------------------------------------------------------------------------------
Return GetDriveTypeA(Upper(ac_Drive) + ":\")

end function

public function integer of_getfileattributes (string as_filename, ref boolean ab_readonly, ref boolean ab_hidden, ref boolean ab_system, ref boolean ab_subdirectory, ref boolean ab_archive);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getfileattributes()
//	Arguments:  as_filename 	- Name of file.
//					ab_readonly 	- Whether the file is read-only.
//					ab_hidden 		- Whether the file is hidden.
//					ab_system 		- Whether the file is a system file.
//					ab_subdirectory - Whether the file is actually  sub-directory.
//					ab_archive 		- Whether the file has its archive bit set
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Return information about the specified filename
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long						ll_Handle
os_finddata	lstr_FindData
n_numerical		lnv_Numeric

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the file
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_Handle <= 0 Then Return -1
FindClose(ll_Handle)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set file attributes
//-----------------------------------------------------------------------------------------------------------------------------------
ab_ReadOnly = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 1)
ab_Hidden = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 2)
ab_System = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 3)
ab_SubDirectory = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 5)
ab_Archive = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 6)

Return 1

end function

public function double of_getfilesize (string as_filename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getfilesize()
//	Arguments:  as_filename - Name of file
//	Returns:		double - The size of the file in bytes.
//						-1 if an error occurrs.
//	Overview:   Get the size of the file in bytes. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Double					ldb_Size
Long						ll_Handle
os_finddata	lstr_FindData

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the file
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_Handle <= 0 Then Return -1
FindClose(ll_Handle)

//-----------------------------------------------------------------------------------------------------------------------------------
// Calculate file size
//-----------------------------------------------------------------------------------------------------------------------------------
ldb_Size = (lstr_FindData.ul_FileSizeHigh * (2.0 ^ 32))  + lstr_FindData.ul_FileSizeLow

Return ldb_Size

end function

public function integer of_getlastaccessdate (string as_filename, ref date ad_date);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getlastaccessdate()
//	Arguments:  as_filename - Name of file
//					ad_date 		- Date variable file was last accessed.
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Determine last date the file was accessed on. 
//						Note:  This function only returns the Date because Last Access Time is not stored by the operating system.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long						ll_Handle
String					ls_Time, ls_Date
Time						lt_Time
os_finddata			lstr_FindData

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the file information
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_Handle <= 0 Then Return -1
FindClose(ll_Handle)

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the date and time
//-----------------------------------------------------------------------------------------------------------------------------------
Return of_ConvertFileDatetimeToPB(lstr_FindData.str_LastAccessTime, ad_Date, lt_Time)

end function

public function integer of_getlastwritedatetime (string as_filename, ref date ad_date, ref time at_time);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getlastwritedatetime()
//	Arguments:  as_FileName	-	The name of the file for which you want its date; an absolute path may be specified or it will be
//										relative to the current working directory
//					ad_Date 		-	The date the file was last modified, passed by reference.
//					at_time		-	The time the file was last modified, passed by reference.
//	Returns:		Integer
//						 1 if successful, 
//						-1 if an error occurrs.
//	Overview:   Get the date a file was last modified. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long						ll_Handle
String					ls_Time, ls_Date
os_finddata	lstr_FindData

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the file information
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_Handle <= 0 Then Return -1
FindClose(ll_Handle)

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the date and time
//-----------------------------------------------------------------------------------------------------------------------------------
Return of_ConvertFileDatetimeToPB(lstr_FindData.str_LastWriteTime, ad_Date, at_Time)

end function

public function string of_getlongfilename (string as_altfilename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getlongfilename()
//	Arguments:  as_altfilename	-	Name of 8.3 file an absolute path may be specified or it will be relative to the current working 
//											directory.
//	Returns:		String -	The long file name (without the path), returns an empty string if an error occurrs.
//	Overview:   Get the long file name for the 8.3 format file specified. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long						ll_Handle
String					ls_AltFileName
os_finddata	lstr_FindData

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the alternate file
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_AltFileName, lstr_FindData)
If ll_Handle <= 0 Then Return ""
FindClose(ll_Handle)

Return lstr_FindData.ch_filename

end function

public function integer of_removedirectory (string as_directoryname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_removedirectory()
//	Arguments:  as_directoryname - Name of directory
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Remove specified directory. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer	li_RC

//-----------------------------------------------------------------------------------------------------------------------------------
//	Determine if directory exists.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not of_DirectoryExists(as_DirectoryName) Then Return 1

//-----------------------------------------------------------------------------------------------------------------------------------
//	Call WINAPI to remove the directory.
//-----------------------------------------------------------------------------------------------------------------------------------
If RemoveDirectoryA(as_DirectoryName) Then
	li_RC = 1
Else
	li_RC = -1
End If

Return li_RC

end function

public function integer of_setcreationdatetime (string as_filename, date ad_date, time at_time);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setcreationdatetime()
//	Arguments:  as_filename - Name of file.
//					ad_filedate - Date to set the file creation date from
//					at_filetime - Time to set the file creation time from
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Set the file creation date to the specified date and time.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean						lb_Ret
Long							ll_Error, ll_Handle
os_filedatetime			lstr_FileTime, lstr_Empty
os_finddata				lstr_FindData
os_fileopeninfo			lstr_FileInfo

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the file information.
// This is required to keep the Last Access date from changing.
// It will be changed by the OpenFile function.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_Handle <= 0 Then Return -1
FindClose(ll_Handle)

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the date and time
//-----------------------------------------------------------------------------------------------------------------------------------
If this.of_ConvertPBDatetimeToFile(ad_Date, at_Time, lstr_FileTime) < 0 Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the file structure information
//-----------------------------------------------------------------------------------------------------------------------------------
lstr_FileInfo.c_fixed_disk = "~000"
lstr_FileInfo.c_pathname = as_FileName
lstr_FileInfo.c_length = "~142"

//-----------------------------------------------------------------------------------------------------------------------------------
// Open the file
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = OpenFile ( as_filename, lstr_FileInfo, 2 ) 
If ll_Handle < 1 Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the file creation date and time.
//-----------------------------------------------------------------------------------------------------------------------------------
lb_Ret = SetFileTime(ll_Handle, lstr_FileTime, lstr_FindData.str_LastAccessTime, lstr_Empty)

//-----------------------------------------------------------------------------------------------------------------------------------
// Close the file.
//-----------------------------------------------------------------------------------------------------------------------------------
CloseHandle(ll_Handle)

If lb_Ret Then
	Return 1
Else
	Return -1
End If
end function

public function integer of_setfileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setfileattributes()
//	Arguments:  as_filename -	Name of file
//					ab_readonly -	Whether the file is read-only.
//					ab_hidden	- 	Whether the file is hidden.
//					ab_system	-	Whether the file is a system file.
//					ab_archive	- 	Whether the file should be marked as an archive file.
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Set file attributes for the specified file. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer		li_RC
ULong		lul_Attrib

//-----------------------------------------------------------------------------------------------------------------------------------
// Calculate the new attribute byte for the file
//-----------------------------------------------------------------------------------------------------------------------------------
lul_Attrib = of_CalculateFileAttributes(as_FileName, ab_ReadOnly, ab_Hidden, ab_System, ab_Archive)
If lul_Attrib = -1 Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the new attribute byte for the file
//-----------------------------------------------------------------------------------------------------------------------------------
If SetFileAttributesA(as_FileName, lul_Attrib) Then
	li_RC = 1
Else
	li_RC = 0
End If

Return li_RC

end function

public function integer of_setlastaccessdate (string as_filename, date ad_date);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setlastaccessdate()
//	Arguments:  as_filename -	Name of file.
//					ad_filedate -	Date to set the file creation date from
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Set the last-accessed datetime to the specified date and time. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean						lb_Ret
Long							ll_Error, ll_Handle
Time							lt_Time
os_filedatetime			lstr_FileTime, lstr_Empty
os_fileopeninfo			lstr_FileInfo

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the date and time
//-----------------------------------------------------------------------------------------------------------------------------------
If of_ConvertPBDatetimeToFile(ad_Date, lt_Time, lstr_FileTime) < 0 Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the file structure information
//-----------------------------------------------------------------------------------------------------------------------------------
lstr_FileInfo.c_fixed_disk = "~000"
lstr_FileInfo.c_pathname = as_FileName
lstr_FileInfo.c_length = "~142"

//-----------------------------------------------------------------------------------------------------------------------------------
// Open the file
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = OpenFile ( as_filename, lstr_FileInfo, 2 ) 
If ll_Handle < 1 Then Return -1
 
//-----------------------------------------------------------------------------------------------------------------------------------
//	Set the file accessed Date
//-----------------------------------------------------------------------------------------------------------------------------------
lb_Ret = SetFileTime(ll_Handle, lstr_Empty, lstr_FileTime, lstr_Empty)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Close the file.
//-----------------------------------------------------------------------------------------------------------------------------------
CloseHandle(ll_Handle)

If lb_Ret Then
	Return 1
Else
	Return -1
End If

end function

public function integer of_setlastwritedatetime (string as_filename, date ad_date, time at_time);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setlastwritedatetime()
//	Arguments:  as_filename -	Name of file.
//					ad_filedate -	Date to set the file creation date from
//					at_time		-	Time to set the file creation date from
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Set the last-written datetime to the specified date and time.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean						lb_Ret
Long							ll_Error, ll_Handle
os_filedatetime			lstr_FileTime, lstr_Empty
os_finddata				lstr_FindData
os_fileopeninfo			lstr_FileInfo

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the file information.
// This is required to keep the Last Access date from changing.
// It will be changed by the OpenFile function.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_Handle <= 0 Then Return -1
FindClose(ll_Handle)

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the date and time
//-----------------------------------------------------------------------------------------------------------------------------------
If of_ConvertPBDatetimeToFile(ad_Date, at_Time, lstr_FileTime) < 0 Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the file structure information
//-----------------------------------------------------------------------------------------------------------------------------------
lstr_FileInfo.c_fixed_disk = "~000"
lstr_FileInfo.c_pathname = as_FileName
lstr_FileInfo.c_length = "~142"

//-----------------------------------------------------------------------------------------------------------------------------------
// Open the file
//-----------------------------------------------------------------------------------------------------------------------------------
ll_Handle = OpenFile ( as_filename, lstr_FileInfo, 2 ) 
If ll_Handle < 1 Then Return -1
 
lb_Ret = SetFileTime(ll_Handle, lstr_Empty, lstr_FindData.str_LastAccessTime, lstr_FileTime)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Close the file.
//-----------------------------------------------------------------------------------------------------------------------------------/
CloseHandle(ll_Handle)

If lb_Ret Then
	Return 1
Else
	Return -1
End If

end function

public function boolean of_build_file_from_blob (string as_filename, character ac_replace, ref blob ab_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_build_file_from_blob
// Arguments:	as_filename - filename to create or append to
//					ac_replace - indicator on whether to replace the file or append it.
//					b_data - blob to write file from
// Overview:	Build file from blob
// Created by: Gary Howard
// History:    10/20/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Local variables used in script
//-----------------------------------------------------
integer i_fnum, i_loops, i,i_userid
long 	l_flen, l_pos, l_remlen, l_written
blob b_temp

//-----------------------------------------------------
// Determine length of blob to know length of file
//-----------------------------------------------------
l_flen = len(ab_data)

//-----------------------------------------------------
// Ensure we returned valid image data
//-----------------------------------------------------
If l_flen = 0 or IsNull(ab_data) Then
	Return False
End If

//-----------------------------------------------------
// Reference the argument s_filename to define the name 
//	of the file as well as open it.
//-----------------------------------------------------
If ac_replace = "R" Then
	i_fnum = FileOpen(as_filename,StreamMode!,Write!,Shared!,Replace!)
Else
	i_fnum = FileOpen(as_filename,StreamMode!,Write!,Shared!,Append!)
//	If i_fnum = -1 or IsNull(i_fnum) Then Return FALSE
//	FileWrite(i_fnum,ab_data)
//	FileClose(i_fnum)
//	RETURN TRUE
End If

//-----------------------------------------------------
// Ensure file open created the file successfully
//-----------------------------------------------------
If i_fnum = -1 or IsNull(i_fnum) Then Return FALSE

//-----------------------------------------------------
// Determine how many times to call FileWrite because we can only 
// write 32k of data at a time. If len is < 32k we can write once and never
//	enter loop.
//-----------------------------------------------------
IF l_flen > 32765 THEN 
	i_loops = Ceiling(l_flen/32765)
	b_temp = BlobMid ( ab_data, 1,32765)
	l_pos = 1
ELSE
	i_loops = 0
	l_written = FileWrite(i_fnum, ab_data)
END IF

//-----------------------------------------------------
// Write the file
//-----------------------------------------------------
FOR i = 1 to i_loops
	
	//-----------------------------------------------------
	// Number of bytes written.
	//-----------------------------------------------------
	i_userid = FileWrite(i_fnum, b_temp)
	l_written = i_userid + l_written
	
	//-----------------------------------------------------
	//	Remaining bytes that are not written
	//-----------------------------------------------------
	l_remlen = l_flen - l_written

	//-----------------------------------------------------
	//	Increment position of offset by number of bytes written
	//-----------------------------------------------------
	l_pos = l_pos + i_userid

	//-----------------------------------------------------
	//	Determine if less than 32k of data remains
	//-----------------------------------------------------
	If l_remlen > 32765 Then
		b_temp = BlobMid(ab_data, l_pos,32765)
	Else
		b_temp = BlobMid(ab_data, l_pos,l_remlen)
	End If 
NEXT

//-----------------------------------------------------
//	Close File
//-----------------------------------------------------
FileClose(i_fnum)

Return True





end function

public function string of_findfile (string as_filename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getlongfilename()
//	Arguments:  as_altfilename	-	Name of 8.3 file an absolute path may be specified or it will be relative to the current working 
//											directory.
//	Returns:		String -	The long file name (without the path), returns an empty string if an error occurrs.
//	Overview:   Get the long file name for the 8.3 format file specified. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//lpszPath is the path to search -pass NULL to use the standard Windows search
//path (app directory, current directory, Windows System, Windows, PATH
//directories)
//lpszFile is the name of the file you are looking for
//lpszExtension is the file extension - leave NULL if it's included in the
//file name
//dwReturnBuffer is the length of the string which will receive the path
//details
//lpszReturnBuffer is the string into which the path will be written
//plpszFilePart  receives the file name

string  ls_name, ls_null, s_path
constant long ll_size = 1000

SetNull(ls_null)
s_path = SPACE(ll_size)

// The first null value means use normal search path.
// The second null value means the file extension is included in the pathname.
if SearchPathA(ls_null, as_filename, ls_null, ll_size, s_path, ls_name) > 0 then
    return s_path    // Note ls_path includes the file name
else
    return ""
end if

Return ''
end function

on n_file_manipulator.create
call super::create
end on

on n_file_manipulator.destroy
call super::destroy
end on

event constructor;call n_api_fileservices::constructor;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  Constructor
//
//	Description:	Set the instance variables for the directory separator
//						and wildcard for all files for this OS.
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
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Powersoft is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

is_Separator = "\"
is_AllFiles = "*.*"

end event

