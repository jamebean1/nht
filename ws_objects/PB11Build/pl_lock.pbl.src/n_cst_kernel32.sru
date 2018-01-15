$PBExportHeader$n_cst_kernel32.sru
forward
global type n_cst_kernel32 from nonvisualobject
end type
type os_filedatetime from structure within n_cst_kernel32
end type
type os_finddata from structure within n_cst_kernel32
end type
type os_systemtime from structure within n_cst_kernel32
end type
type os_securityattributes from structure within n_cst_kernel32
end type
type os_fileopeninfo from structure within n_cst_kernel32
end type
end forward

type os_filedatetime from structure
	unsignedlong		ul_lowdatetime
	unsignedlong		ul_highdatetime
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

type os_systemtime from structure
	unsignedinteger		ui_wyear
	unsignedinteger		ui_wmonth
	unsignedinteger		ui_wdayofweek
	unsignedinteger		ui_wday
	unsignedinteger		ui_whour
	unsignedinteger		ui_wminute
	unsignedinteger		ui_wsecond
	unsignedinteger		ui_wmilliseconds
end type

type os_securityattributes from structure
	unsignedlong		ul_length
	unsignedlong		ul_description
	boolean		b_inherit
end type

type os_fileopeninfo from structure
	character		c_length
	character		c_fixed_disk
	unsignedinteger		ui_dos_error
	unsignedinteger		ui_na1
	unsignedinteger		ui_na2
	character		c_pathname[128]
end type

global type n_cst_kernel32 from nonvisualobject autoinstantiate
end type

type prototypes
// Win 32 calls
Function ulong GetDriveTypeA (string drive) library "KERNEL32.DLL" alias for "GetDriveTypeA;Ansi"
Function boolean CreateDirectoryA (ref string directoryname, ref os_securityattributes secattr) library "KERNEL32.DLL" alias for "CreateDirectoryA;Ansi"
Function boolean RemoveDirectoryA (ref string directoryname) library "KERNEL32.DLL" alias for "RemoveDirectoryA;Ansi"
Function ulong GetCurrentDirectoryA (ulong textlen, ref string dirtext) library "KERNEL32.DLL" alias for "GetCurrentDirectoryA;Ansi"
Function boolean SetCurrentDirectoryA (ref string directoryname ) library "KERNEL32.DLL" alias for "SetCurrentDirectoryA;Ansi"
Function ulong GetFileAttributesA (ref string filename) library "KERNEL32.DLL" alias for "GetFileAttributesA;Ansi"
Function boolean SetFileAttributesA (ref string filename, ulong attrib) library "KERNEL32.DLL" alias for "SetFileAttributesA;Ansi"
Function boolean MoveFileA (ref string oldfile, ref string newfile) library "KERNEL32.DLL" alias for "MoveFileA;Ansi"
Function long FindFirstFileA (ref string filename, ref os_finddata findfiledata) library "KERNEL32.DLL" alias for "FindFirstFileA;Ansi"
Function boolean FindNextFileA (long handle, ref os_finddata findfiledata) library "KERNEL32.DLL" alias for "FindNextFileA;Ansi"
Function boolean FindClose (long handle) library "KERNEL32.DLL"
Function boolean GetDiskFreeSpaceA (string drive, ref long sectpercluster, ref long bytespersect, ref long freeclusters, ref long totalclusters) library "KERNEL32.DLL" alias for "GetDiskFreeSpaceA;Ansi"
Function long GetLastError() library "KERNEL32.DLL"

// Win32 calls for file date and time
Function long OpenFile (ref string filename, ref os_fileopeninfo of_struct, ulong action) LIBRARY "KERNEL32.DLL" alias for "OpenFile;Ansi"
Function boolean CloseHandle (long file_hand) LIBRARY "KERNEL32.DLL"
Function boolean GetFileTime(long hFile, ref os_filedatetime  lpCreationTime, ref os_filedatetime  lpLastAccessTime, ref os_filedatetime  lpLastWriteTime  )  library "KERNEL32.DLL" alias for "GetFileTime;Ansi"
Function boolean FileTimeToSystemTime(ref os_filedatetime lpFileTime, ref os_systemtime lpSystemTime) library "KERNEL32.DLL" alias for "FileTimeToSystemTime;Ansi"
Function boolean FileTimeToLocalFileTime(ref os_filedatetime lpFileTime, ref os_filedatetime lpLocalFileTime) library "KERNEL32.DLL" alias for "FileTimeToLocalFileTime;Ansi"
Function boolean SetFileTime(long hFile, os_filedatetime  lpCreationTime, os_filedatetime  lpLastAccessTime, os_filedatetime  lpLastWriteTime  )  library "KERNEL32.DLL" alias for "SetFileTime;Ansi"
Function boolean SystemTimeToFileTime(os_systemtime lpSystemTime, ref os_filedatetime lpFileTime) library "KERNEL32.DLL" alias for "SystemTimeToFileTime;Ansi"
Function boolean LocalFileTimeToFileTime(ref os_filedatetime lpLocalFileTime, ref os_filedatetime lpFileTime) library "KERNEL32.DLL" alias for "LocalFileTimeToFileTime;Ansi"

//Win32 Call for workstation ID
Function boolean GetComputerNameA(ref string  lpBuffer, ref ulong nSize) Library "KERNEL32.DLL" alias for "GetComputerNameA;Ansi"

end prototypes

type variables


end variables

forward prototypes
public function integer of_getlastwritedatetime (string as_filename, ref date ad_date, ref time at_time)
public function double of_getfilesize (string as_filename)
public function integer of_getcreationdatetime (string as_filename, ref date ad_date, ref time at_time)
public function boolean of_directoryexists (string as_directoryname)
public function integer of_filerename (string as_sourcefile, string as_targetfile)
public function integer of_removedirectory (string as_directoryname)
public function integer of_setlastwritedatetime (string as_filename, date ad_date, time at_time)
public function boolean of_getbit (long al_decimal, unsignedinteger ai_bit)
public function integer of_convertfiledatetimetopb (os_filedatetime astr_filetime, ref date ad_filedate, ref time at_filetime)
public function integer of_setfileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive)
public function integer of_setcreationdatetime (string as_filename, date ad_date, time at_time)
public function integer of_getfileattributes (string as_filename, ref boolean ab_readonly, ref boolean ab_hidden, ref boolean ab_system, ref boolean ab_subdirectory, ref boolean ab_archive)
public function integer of_convertpbdatetimetofile (date ad_filedate, time at_filetime, ref os_filedatetime astr_filetime)
public function integer of_changedirectory (string as_newdirectory)
public function integer of_createdirectory (string as_directoryname)
public function boolean of_getcomputername (ref string as_computername)
protected function unsignedlong of_calculatefileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive)
public function string of_getcurrentdirectory ()
end prototypes

public function integer of_getlastwritedatetime (string as_filename, ref date ad_date, ref time at_time);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_GetLastWriteDatetime
//	Arguments:		as_FileName			The name of the file for which you want its date
//												and time; an absolute path may be specified or it
//												will be relative to the current working directory
//						ad_Date				The date the file was last modified, passed by reference.
//						at_Time				The time the file was last modified, passed by reference.
//	Returns:			Integer
//						1 if successful, -1 if an error occurrs.
//	Description:	Get the date and time a file was last modified.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   		Initial version
//						5.0.03		Changed long variables to Ulong for NT4.0 compatibility
//						7.0.02 	Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
long			ll_handle
os_finddata	lstr_FindData

// Get the file information
ll_handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_handle <= 0 Then Return -1
FindClose(ll_handle)

// Convert the date and time
Return of_ConvertFileDatetimeToPB(lstr_FindData.str_LastWriteTime, ad_Date, at_Time)
end function

public function double of_getfilesize (string as_filename);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_GetFileSize
//	Arguments:		as_FileName				The name of the file whose size is desired; an
//													absolute path may be specified or it will
//													be relative to the current working directory
//	Returns:			Double
//						The size of the file if successful, -1 if an error occurrs.
//	Description:	Get the size (in bytes) of a file.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   		Initial version
//						5.0.03		Changed long variables to Ulong for NT4.0 compatibility
//						7.0.02 	Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
double ldb_Size
long ll_handle
os_finddata	lstr_FindData

// Get the file
ll_handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_handle <= 0 Then Return -1
FindClose(ll_handle)

// Calculate file size
ldb_Size = (lstr_FindData.ul_FileSizeHigh * (2.0 ^ 32))  + lstr_FindData.ul_FileSizeLow

Return ldb_Size
end function

public function integer of_getcreationdatetime (string as_filename, ref date ad_date, ref time at_time);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_GetCreationDatetime
//	Arguments:		as_FileName				The name of the file for which you want its date
//													and time; an absolute path may be specified or it
//													will be relative to the current working directory
//						ad_Date					The date the file was created, passed by reference.
//						at_Time					The time the file was created, passed by reference.
//	Returns:			Integer
//						1 if successful, -1 if an error occurrs.
//	Description:	Get the date and time a file was created.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0  	 	Initial version
//						5.0.03		Changed Long variables to Ulong for NT4.0 compatibility
//						7.0.02 	Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
long			ll_handle
os_finddata	lstr_FindData

// Get the file information
ll_handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_handle <= 0 Then Return -1
FindClose(ll_handle)

// Convert the date and time
Return of_ConvertFileDatetimeToPB(lstr_FindData.str_CreationTime, ad_Date, at_Time)
end function

public function boolean of_directoryexists (string as_directoryname);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_DirectoryExists
//	Arguments:		as_DirectoryName		The name of the directory to be checked; an
//													absolute path may be specified or it will
//													be relative to the current working directory
//	Returns:			Boolean
//						True if the directory exists, False if it does not.
//	Description:	Check if the specified directory exists.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
ulong	lul_RC

lul_RC = GetFileAttributesA(as_DirectoryName)

// Check if 5th bit is set, if so this is a directory
If Mod(Integer(lul_RC / 16), 2) > 0 Then 
	Return True
Else
	Return False
End If
end function

public function integer of_filerename (string as_sourcefile, string as_targetfile);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_FileRename
//	Arguments:		as_SourceFile			The file to rename.
//						as_TargetFile			The new file name.
//	Returns:			Integer
//						1 if successful,
//						-1 if an error occurrs.
//	Description:	Rename or move a file or directory.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
If MoveFileA(as_SourceFile, as_TargetFile) Then
	Return 1
Else
	Return -1
End If
end function

public function integer of_removedirectory (string as_directoryname);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_RemoveDirectory
//	Arguments:		as_DirectoryName		The name of the directory to be deleted; an
//													absolute path may be specified or it will
//													be relative to the current working directory
//	Returns:			Integer
//						1 if successful,
//						-1 if an error occurrs.
//	Description:	Deleate a directory.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
If Not of_DirectoryExists(as_DirectoryName) Then Return 1

If RemoveDirectoryA(as_DirectoryName) Then
	Return 1
Else
	Return -1
End If
end function

public function integer of_setlastwritedatetime (string as_filename, date ad_date, time at_time);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_SetLastWriteDatetime
//	Arguments:		as_FileName				The name of the file to be updated.
//						ad_FileDate				The date to be set.
//						at_FileTime				The time to be set.
//	Returns:			Integer
//						1 if successful,
//						-1 if an error occurrs.
//	Description:	Set the Date/Time stamp on a file.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   		Initial version
//						5.0.03		Changed long variables to Ulong for NT4.0 compatibility
//						7.0.02 	Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean lb_Ret
long ll_handle
os_filedatetime lstr_FileTime, lstr_Empty
os_finddata lstr_FindData
os_fileopeninfo lstr_FileInfo

// Get the file information.
// This is required to keep the Last Access date from changing.
// It will be changed by the OpenFile function.
ll_handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_handle <= 0 Then Return -1
FindClose(ll_handle)

// Convert the date and time
If of_ConvertPBDatetimeToFile(ad_Date, at_Time, lstr_FileTime) < 0 Then Return -1

// Set the file structure information
lstr_FileInfo.c_fixed_disk = "~000"
lstr_FileInfo.c_pathname = as_FileName
lstr_FileInfo.c_length = "~142"

// Open the file
ll_handle = OpenFile ( as_filename, lstr_FileInfo, 2 ) 
If ll_handle < 1 Then Return -1
 
lb_Ret = SetFileTime(ll_handle, lstr_Empty, lstr_FindData.str_LastAccessTime, lstr_FileTime)

CloseHandle(ll_handle)

If lb_Ret Then
	Return 1
Else
	Return -1
End If
end function

public function boolean of_getbit (long al_decimal, unsignedinteger ai_bit);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_GetBit
//
//	Access: 			public
//
//	Arguments:
//	al_decimal		Decimal value whose on/off value needs to be determined (e.g. 47).
//	ai_bit			Position bit from right to left on the Decimal value.
//
//	Returns: 		boolean
//						True if the value is On.
//						False if the value is Off.
//						If any argument's value is NULL, function returns NULL.
//
//	Description:   Determines if the nth binary bit of a decimal number is 
//						1 or 0.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
// 5.0.03	Fixed problem when dealing with large numbers (>32k)
//				from "mod int" to "int mod"
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Boolean lb_null

//Check parameters
If IsNull(al_decimal) or IsNull(ai_bit) then
	SetNull(lb_null)
	Return lb_null
End If

//Assumption ai_bit is the nth bit counting right to left with
//the leftmost bit being bit one.
//al_decimal is a binary number as a base 10 long.
If Int(Mod(al_decimal / (2 ^(ai_bit - 1)), 2)) > 0 Then
	Return True
End If

Return False

end function

public function integer of_convertfiledatetimetopb (os_filedatetime astr_filetime, ref date ad_filedate, ref time at_filetime);//////////////////////////////////////////////////////////////////////////////
//	Protected Function:  of_ConvertFileDatetimeToPB
//	Arguments:		astr_FileTime		The os_filedatetime structure containing the system date/time for the file.
//						ad_FileDate			The file date in PowerBuilder Date format	passed by reference.
//						at_FileTime			The file time in PowerBuilder Time format	passed by reference.
//	Returns:			Integer
//						1 if successful, -1 if an error occurrs.
//	Description:	Convert a sytem file type to PowerBuilder Date and Time.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//						5.0.03	Fixed - function would fail under some international date formats
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
string				ls_Time
os_filedatetime	lstr_LocalTime
os_systemtime		lstr_SystemTime

If Not FileTimeToLocalFileTime(astr_FileTime, lstr_LocalTime) Then Return -1

If Not FileTimeToSystemTime(lstr_LocalTime, lstr_SystemTime) Then Return -1

// works with all date formats
ad_FileDate = Date(lstr_SystemTime.ui_wyear, lstr_SystemTime.ui_WMonth, lstr_SystemTime.ui_WDay)

ls_Time = String(lstr_SystemTime.ui_wHour) + ":" + &
			 String(lstr_SystemTime.ui_wMinute) + ":" + &
			 String(lstr_SystemTime.ui_wSecond) + ":" + &
			 String(lstr_SystemTime.ui_wMilliseconds)
at_FileTime = Time(ls_Time)

Return 1
end function

public function integer of_setfileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_SetFileAttributes
//	Arguments:		as_FileName				The file whose attributes you want to set; an
//													absolute path may be specified or it will
//													be relative to the current working directory.
//						ab_ReadOnly				The new value for the Read-Only attribute.
//						ab_Hidden				The new value for the Hidden attribute.
//						ab_System				The new value for the System attribute.
//						ab_Archive				The new value for the Archive attribute.
//	Returns:			Integer
//						1 if successful,
//						-1 if an error occurrs.
//	Description:	Set the attributes of a file.  If null is passed for any of the attributes,
//						it will not be changed.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
ulong		lul_Attrib

// Calculate the new attribute byte for the file
lul_Attrib = of_CalculateFileAttributes(as_FileName, ab_ReadOnly, ab_Hidden, ab_System, ab_Archive)
If lul_Attrib = -1 Then Return -1

If SetFileAttributesA(as_FileName, lul_Attrib) Then
	Return 1
Else
	Return 0
End If
end function

public function integer of_setcreationdatetime (string as_filename, date ad_date, time at_time);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_SetCreationDatetime
//	Arguments:		as_FileName				The name of the file to be updated.
//						ad_FileDate				The date to be set.
//						at_FileTime				The time to be set.
//	Returns:			Integer
//						1 if successful,
//						-1 if an error occurrs.
//	Description:	Set the Creation Date/Time stamp on a file.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   		Initial version
//						5.0.03		Changed long variables to Ulong for NT4.0 compatibility
//						7.0.02 	Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean lb_Ret
long ll_handle
os_filedatetime lstr_FileTime, lstr_Empty
os_finddata lstr_FindData
os_fileopeninfo lstr_FileInfo

// Get the file information.
// This is required to keep the Last Access date from changing.
// It will be changed by the OpenFile function.
ll_handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_handle <= 0 Then Return -1
FindClose(ll_handle)

// Convert the date and time
If of_ConvertPBDatetimeToFile(ad_Date, at_Time, lstr_FileTime) < 0 Then Return -1

// Set the file structure information
lstr_FileInfo.c_fixed_disk = "~000"
lstr_FileInfo.c_pathname = as_FileName
lstr_FileInfo.c_length = "~142"

// Open the file
ll_handle = OpenFile ( as_filename, lstr_FileInfo, 2 ) 
If ll_handle < 1 Then Return -1
 
lb_Ret = SetFileTime(ll_handle, lstr_FileTime, lstr_FindData.str_LastAccessTime, lstr_Empty)

CloseHandle(ll_handle)

If lb_Ret Then
	Return 1
Else
	Return -1
End If
end function

public function integer of_getfileattributes (string as_filename, ref boolean ab_readonly, ref boolean ab_hidden, ref boolean ab_system, ref boolean ab_subdirectory, ref boolean ab_archive);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_GetFileAttributes
//	Arguments:		as_FileName				The file for which you want the attributes; an
//													absolute path may be specified or it will
//													be relative to the current working directory.
//						ab_ReadOnly				The Read-Only attribute, passed by reference.
//						ab_Hidden				The Hidden attribute, passed by reference.
//						ab_System				The System attribute, passed by reference.
//						ab_Subdirectory		The Subdirectory attribute, passed by reference.
//						ab_Archive				The Archive attribute, passed by reference.
//	Returns:			Integer
//						1 if successful, -1 if an error occurrs.
//	Description:	Get the attributes for a file.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   		Initial version
//						5.0.03		Changed long variables to Ulong for NT4.0 compatibility
//						7.0.02 	Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
long						ll_handle
os_finddata		lstr_FindData

// Find the file
ll_handle = FindFirstFileA(as_FileName, lstr_FindData)
If ll_handle <= 0 Then Return -1
FindClose(ll_handle)

// Set file attributes
ab_ReadOnly = of_getbit(lstr_FindData.ul_FileAttributes, 1)
ab_Hidden = of_getbit(lstr_FindData.ul_FileAttributes, 2)
ab_System = of_getbit(lstr_FindData.ul_FileAttributes, 3)
ab_SubDirectory = of_getbit(lstr_FindData.ul_FileAttributes, 5)
ab_Archive = of_getbit(lstr_FindData.ul_FileAttributes, 6)

Return 1
end function

public function integer of_convertpbdatetimetofile (date ad_filedate, time at_filetime, ref os_filedatetime astr_filetime);//////////////////////////////////////////////////////////////////////////////
//	Protected Function:  of_ConvertPBDatetimeToFile
//	Arguments:		ad_FileDate			The file date in PowerBuilder Date format.
//						at_FileTime			The file time in PowerBuilder Time format.
//						astr_FileTime		The os_filedatetime structure to contain the
//												system date/time for the file, passed by reference.
//	Returns:			Integer
//						1 if successful, -1 if an error occurrs.
//	Description:	Convert PowerBuilder Date and Time to the sytem file type.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//						5.0.03	Fix problem with century not being on the year passed in
//						6.0.01	Fix millisecond overflow.  Change size of string to 3 digits from 6 
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
string				ls_Time
unsignedinteger	lui_year, lui_test
os_filedatetime	lstr_LocalTime
os_systemtime	lstr_SystemTime

// fix problem when year without century passed in
lui_year = Integer(String(ad_FileDate,'yyyy'))
lui_test = Year(ad_filedate)
if lui_year < 50 then
	lui_year = lui_year + 2000
elseif lui_year < 100 then
	lui_year = lui_year + 1900
end if 

// make sure year with century is passed in
lstr_SystemTime.ui_wyear = lui_year
lstr_SystemTime.ui_WMonth = month(ad_FileDate)
lstr_SystemTime.ui_WDay = day(ad_FileDate)

ls_Time = String(at_FileTime, "hh:mm:ss:fff")
lstr_SystemTime.ui_wHour = Long(Left(ls_Time, 2))
lstr_SystemTime.ui_wMinute = Long(Mid(ls_Time, 4, 2))
lstr_SystemTime.ui_wSecond = Long(Mid(ls_Time, 7, 2))
lstr_SystemTime.ui_wMilliseconds = Long(Right(ls_Time, 3))

If Not SystemTimeToFileTime(lstr_SystemTime, lstr_LocalTime) Then Return -1

If Not LocalFileTimeToFileTime(lstr_LocalTime, astr_FileTime) Then Return -1

Return 1
end function

public function integer of_changedirectory (string as_newdirectory);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_ChangeDirectory
//	Arguments:		as_NewDirectory			The name of the new working directory; an
//														absolute path may be specified or it will
//														be relative to the current working directory
//	Returns:			Integer
//						1 if successful,
//						-1 if an error occurrs.
//	Description:	Change the current working directory.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
If Trim(as_NewDirectory) = "" Then Return -1

If SetCurrentDirectoryA(as_NewDirectory) Then
	Return 1
Else
	Return -1
End If
end function

public function integer of_createdirectory (string as_directoryname);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_CreateDirectory
//	Arguments:		as_DirectoryName		The name of the directory to be created; an
//													absolute path may be specified or it will
//													be relative to the current working directory
//	Returns:			Integer
//						1 if successful,
//						-1 if an error occurrs.
//	Description:	Create a new directory.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//						5.0.03	Set ch_description to null and changed structure datatype from char to string
//									to fix NT 4.0 directory creation inconsistency
//
//   9/20/2001  K. Claver  Changed data type of description variable for the structure
//									to unsigned long.
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
os_securityattributes	lstr_Security

lstr_Security.ul_Length = 17
SetNull(lstr_Security.ul_description)	//use default security
lstr_Security.b_Inherit = False

If CreateDirectoryA(as_DirectoryName, lstr_Security) Then
	Return 1
Else
	Return -1
End If
end function

public function boolean of_getcomputername (ref string as_computername);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_GetComputerName
//
//	Access: 			public
//
//	Arguments:
//	as_computername	Reference string to hold computer name
//	
//	Returns: 		boolean
//						True if was able to get the workstation id.
//						False if wasn't able to get the workstation id.
//
//	Description:   Retrieves the workstation ID using the kernel32.dll.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	9/28/2001  K. Claver  Created
//
//////////////////////////////////////////////////////////////////////////////
ULong lul_len = 255

RETURN GetComputerNameA( as_ComputerName, lul_len )
end function

protected function unsignedlong of_calculatefileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive);//////////////////////////////////////////////////////////////////////////////
//	Protected Function:  of_CalculateFileAttributes
//	Arguments:		as_FileName				The file whose attributes you want to set; an
//													absolute path may be specified or it will
//													be relative to the current working directory.
//						ab_ReadOnly				The new value for the Read-Only attribute.
//						ab_Hidden				The new value for the Hidden attribute.
//						ab_System				The new value for the System attribute.
//						ab_Archive				The new value for the Archive attribute.
//	Returns:			Unsigned Long - The new attribute byte
//	Description:	Calculate the new attribute byte for a file.  If null is passed 
//						for any of the attributes, it will not be changed.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean	lb_ReadOnly, lb_Hidden, lb_System, lb_Subdirectory, lb_Archive
ulong		lul_Attrib

// Get the current attribute values
If of_GetFileAttributes(as_FileName, lb_ReadOnly, lb_Hidden, &
		lb_System, lb_Subdirectory, lb_Archive) = -1 Then 
	Return -1
End If

// Preserve the Subdirectory attribute
If lb_Subdirectory Then
	lul_Attrib = 16
Else
	lul_Attrib = 0
End If

// Set Read-Only
If Not IsNull(ab_ReadOnly) Then
	If ab_ReadOnly Then lul_Attrib = lul_Attrib + 1
Else
	If lb_ReadOnly Then lul_Attrib = lul_Attrib + 1
End If

// Set Hidden
If Not IsNull(ab_Hidden) Then
	If ab_Hidden Then lul_Attrib = lul_Attrib + 2
Else
	If lb_Hidden Then lul_Attrib = lul_Attrib + 2
End If

// Set System
If Not IsNull(ab_System) Then
	If ab_System Then lul_Attrib = lul_Attrib + 4
Else
	If lb_System Then lul_Attrib = lul_Attrib + 4
End If

// Set Archive
If Not IsNull(ab_Archive) Then
	If ab_Archive Then lul_Attrib = lul_Attrib + 32
Else
	If lb_Archive Then lul_Attrib = lul_Attrib + 32
End If

Return lul_Attrib
end function

public function string of_getcurrentdirectory ();//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_GetCurrentDirectory
//	Arguments: 		None
//	Returns:  		string 		The current working directory, "" if error			
//	Description:  	Return the current working directory
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//						5.0.03	Changed Uint variables to Ulong for NT4.0 compatibility
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
ulong		lul_size = 260 	// MAX_PATH
ulong		lul_Rc
string	ls_CurrentDir

ls_CurrentDir = Space (lul_size)

lul_rc = GetCurrentDirectoryA(lul_size, ls_CurrentDir)

if lul_rc > 0 THEN
	return ls_CurrentDir
else
	return ""
end if
end function

on n_cst_kernel32.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_kernel32.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

