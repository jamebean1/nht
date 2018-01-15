$PBExportHeader$n_api_fileservices.sru
$PBExportComments$API level object that lets you check and manipulate information about files. GLH
forward
global type n_api_fileservices from nonvisualobject
end type
type uostr_files from structure within n_api_fileservices
end type
end forward

type uostr_files from structure
	string		s_fromfile
	string		s_tofile
	character		c_replace
end type

global type n_api_fileservices from nonvisualobject autoinstantiate
end type

type variables
Private:
uostr_files iuostr_files[]
Protected:
string	is_Separator
string	is_AllFiles
end variables

forward prototypes
public function string of_assemblepath (string as_drive, string as_dirpath, string as_filename, string as_ext)
public function integer of_changedirectory (string as_newdirectory)
public function integer of_createdirectory (string as_directoryname)
public function integer of_deltree (string as_directoryname)
public function boolean of_directoryexists (string as_directoryname)
public function integer of_dirlist (string as_filespec, long al_filetyp, ref n_api_directory_attributes anv_dirlist[])
public function long of_fileread (string as_filename, ref blob ablb_data)
public function integer of_filerename (string as_sourcefile, string as_targetfile)
public function integer of_filewrite (string as_filename, blob ablb_data)
public function long of_fileread (string as_filename, ref string as_text[])
public function integer of_filewrite (string as_filename, string as_text)
public function integer of_filewrite (string as_filename, blob ablb_data, boolean ab_append)
public function integer of_filewrite (string as_filename, string as_text, boolean ab_append)
public function string of_getaltfilename (string as_longfilename)
public function integer of_getcreationdate (string as_filename, ref date ad_date)
public function integer of_getcreationdatetime (string as_filename, ref date ad_date, ref time at_time)
public function integer of_getcreationtime (string as_filename, ref time at_time)
public function string of_getcurrentdirectory ()
public function integer of_getdiskspace (string as_drive, ref long al_totalspace, ref long al_freespace)
public function integer of_getdrivetype (string as_drive)
public function integer of_getfileattributes (string as_filename, ref boolean ab_readonly, ref boolean ab_hidden, ref boolean ab_system, ref boolean ab_subdirectory, ref boolean ab_archive)
public function double of_getfilesize (string as_filename)
public function integer of_getlastaccessdate (string as_filename, ref date ad_date)
public function integer of_getlastwritedate (string as_filename, ref date ad_date)
public function integer of_getlastwritedatetime (string as_filename, ref date ad_date, ref time at_time)
public function integer of_getlastwritetime (string as_filename, ref time at_time)
public function string of_getlongfilename (string as_altfilename)
public function string of_getseparator ()
public function integer of_getvolumes (ref string as_volumes[])
protected function boolean of_includefile (string as_filename, long al_attribmask, unsignedlong aul_fileattrib)
public function integer of_parsepath (string as_path, ref string as_drive, ref string as_dirpath, ref string as_filename)
public function integer of_parsepath (string as_path, ref string as_drive, ref string as_dirpath, ref string as_filename, ref string as_ext)
public function integer of_removedirectory (string as_directoryname)
public function integer of_setfilearchive (string as_filename, boolean ab_archive)
public function integer of_setfileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive)
public function integer of_setfilehidden (string as_filename, boolean ab_hidden)
public function integer of_setfilereadonly (string as_filename, boolean ab_readonly)
public function integer of_setfilesystem (string as_filename, boolean ab_system)
public function integer of_setcreationdatetime (string as_filename, date ad_filedate, time at_filetime)
public function integer of_setlastaccessdate (string as_filename, date ad_date)
public function integer of_setlastaccessdatetime (string as_filename, date ad_date, time at_time)
public function integer of_setlastwritedatetime (string as_filename, date ad_date, time at_time)
public function integer of_sortdirlist (ref n_api_directory_attributes anv_dirlist[], integer ai_sorttype)
public function integer of_sortdirlist (ref n_api_directory_attributes anv_dirlist[], integer ai_sorttype, boolean ab_ascending)
protected function unsignedlong of_calculatefileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive)
public function boolean of_copy (string as_fromfile, string as_tofile, character ac_replace)
public function boolean of_copy_all ()
public function boolean of_copyall ()
public function string of_assemblepath (string as_drive, string as_dirpath, string as_filename)
end prototypes

public function string of_assemblepath (string as_drive, string as_dirpath, string as_filename, string as_ext);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_AssemblePath()
//	Arguments:  as_Drive - 		The disk drive from the path.
//					as_DirPath - 	The directory path.
//					as_FileName - 	The name of the file.
//					as_Ext - 		The file extension.
//	Returns:		String - 		The fully-qualified directory path.
//	Overview:   Assemble a fully-qualified directory path from its component parts.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer	li_Pos
String	ls_Path

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the Drive and Path.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_Path = Trim(as_Drive) + Trim(as_DirPath)

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the separator is included.
//-----------------------------------------------------------------------------------------------------------------------------------
If Right(ls_Path, 1) <> is_Separator Then
	ls_Path = ls_Path + is_Separator
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the filename.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_Path = ls_Path + Trim(as_FileName)

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the Extension.
//-----------------------------------------------------------------------------------------------------------------------------------
If Trim(as_Ext) <> "" Then
	ls_Path = ls_Path + "." + Trim(as_Ext)
End if

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the assembled path.
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_Path

end function

public function integer of_changedirectory (string as_newdirectory);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_changedirectory()
//	Arguments:  as_newdirectory - Directory to change to
//	Returns:		int
//						-1 if function not found in descendent
//	Overview:   Stub function to be implemented in the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_createdirectory (string as_directoryname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_changedirectory()
//	Arguments:  as_directoryname - Directory to create
//	Returns:		int
//						-1 if function not found in descendent
//	Overview:   Stub function to be implemented in the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_deltree (string as_directoryname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_DelTree()
//	Arguments:  as_DirectoryName	The name of the directory to be deleted; an absolute path may be specified or it will	be relative
//					to the current working directory
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Delete a directory and all its files and subdirectories.  This function is recursive.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer				li_RC, li_Entries, li_Cnt
String				ls_Directory, ls_Subdirectory
n_api_directory_attributes	lnv_DirList[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Check if directory exists.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not of_DirectoryExists(as_DirectoryName) Then Return 1

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the separator character to the end of the path if it's not there.
//-----------------------------------------------------------------------------------------------------------------------------------
If Right(as_DirectoryName, 1) <> is_Separator Then
	ls_Directory = as_DirectoryName + is_Separator
Else
	ls_Directory = as_DirectoryName
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get a list of directories to loop through.
//-----------------------------------------------------------------------------------------------------------------------------------
li_Entries = of_DirList(ls_Directory + is_AllFiles, 55, lnv_DirList)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the directories and delete each one.
//-----------------------------------------------------------------------------------------------------------------------------------
For li_Cnt = 1 To li_Entries
	If lnv_DirList[li_Cnt].ib_SubDirectory Then

		//-----------------------------------------------------------------------------------------------------------------------------------			
		// Recursively call this function to erase the subdirectory
		// Skip [..]
		//-----------------------------------------------------------------------------------------------------------------------------------
		If lnv_DirList[li_Cnt].is_FileName <> "[..]" Then

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Remove [] from directory name
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_SubDirectory = Mid(lnv_DirList[li_Cnt].is_FileName, 2, &
				(Len(lnv_DirList[li_Cnt].is_FileName) - 2))

			li_RC = of_DelTree(ls_Directory + ls_SubDirectory)
			If li_RC < 0 Then
				Return li_RC
			End If
		End If

	Else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Delete the file
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not FileDelete(ls_Directory + lnv_DirList[li_Cnt].is_FileName) Then
			Return -1
		End If
	End If
Next

Return this.of_RemoveDirectory(as_DirectoryName)

end function

public function boolean of_directoryexists (string as_directoryname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_directoryexists()
//	Arguments:  as_directoryname - directory to check.
//	Returns:		boolean 
//						True - directory exists
//						False - Directory doesn't exists or function not found in descendent
//	Overview:   Stub function to check if the specified directory exists. Function must be implmented in descendent
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return False

end function

public function integer of_dirlist (string as_filespec, long al_filetyp, ref n_api_directory_attributes anv_dirlist[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_directoryexists()
//	Arguments:  as_filespec - 
//					al_filetyp - 
//					anv_dirlist[] - array of objects which contain the directory attributes for any subdirectories contained in the list.
//	Returns:		integer 
//						-1 function not found in descendent
//	Overview:   Stub function to get a recursive list of directories. This function must be implemented in the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function long of_fileread (string as_filename, ref blob ablb_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_FileRead
//
//	Access:  public
//
//	Arguments:
//	as_FileName				The name of the file to read.
//	ablb_Data					The data from the file, passed by reference.
//
//	Returns:		Long
//					the size of the blob read, returns -1 if an error occurrs.
//
//	Description:	Open, read into a blob, and close a file.  Handles files > 32,765 bytes.
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

Integer		li_FileNo, li_Reads, li_Cnt
Long			ll_FileLen
Blob			lblb_Data

ll_FileLen = FileLength(as_FileName)

li_FileNo = FileOpen(as_FileName, StreamMode!, Read!)
If li_FileNo < 0 Then Return -1

// Determine the number of reads required to read the entire file
If ll_FileLen > 32765 Then
	If Mod(ll_FileLen, 32765) = 0 Then
		li_Reads = ll_FileLen / 32765
	Else
		li_Reads = (ll_FileLen / 32765) + 1
	End if
Else
	li_Reads = 1
End if

// Empty the blob argument
ablb_Data = lblb_Data

// Read the file and build the blob with data from the file
For li_Cnt = 1 to li_Reads
	If FileRead(li_FileNo, lblb_Data) = -1 Then
		Return -1
	Else
		ablb_Data = ablb_Data + lblb_Data
	End if
Next

FileClose(li_FileNo)

Return ll_FileLen

end function

public function integer of_filerename (string as_sourcefile, string as_targetfile);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_filerename()
//	Arguments:  as_sourcefile - Current name of file
//					as_targetfile - Destination name of file.
//	Overview:   Stub function for renaming a file. This function must be implemented in the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_filewrite (string as_filename, blob ablb_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_FileWrite()
//	Arguments:  as_FileName -	The name of the file to write to.
//					ablb_Data 	- 	The data to be written to the file.
//	Returns:		Integer
//						1 if successful, -1 if an error occurrs.
//	Overview:   Open, write from a blob, and close a file.  Handles blobs > 32,765 bytes. This function overloads the real of_FileWrite
//					to allow the Append parameter to be optional (default is True).
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return of_FileWrite(as_FileName, ablb_Data, True)

end function

public function long of_fileread (string as_filename, ref string as_text[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_FileRead()
//	Arguments:  as_FileName - The name of the file to read.
//					as_Text[] - An array of strings to hold the text from the file, passed by reference.
//	Returns:		Long
//						the number of elements in as_Text, returns -1 if an error occurrs.
//	Overview:   Open, read, and close a file. Handles files > 32,765 bytes by reading it into an array of strings.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer		li_FileNo, i
Long			l_FileLen, l_Reads

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check if File Exists
//-----------------------------------------------------------------------------------------------------------------------------------
If Not FileExists(as_filename) Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get the file length
//-----------------------------------------------------------------------------------------------------------------------------------
l_FileLen = FileLength(as_FileName)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Open the file for read access.
//-----------------------------------------------------------------------------------------------------------------------------------
li_FileNo = FileOpen(as_FileName, StreamMode!, Read!)
If li_FileNo < 0 Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the number of reads required to read the entire file
//-----------------------------------------------------------------------------------------------------------------------------------
If l_FileLen > 32765 Then
	l_reads = Ceiling(l_FileLen/32765)
Else
	l_Reads = 1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Read the file into each element of the array
//-----------------------------------------------------------------------------------------------------------------------------------
For i = 1 to l_Reads
	If FileRead(li_FileNo, as_Text[i]) = -1 Then
		Return -1
		Exit
	End if
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Close the file and return
//-----------------------------------------------------------------------------------------------------------------------------------
FileClose(li_FileNo)

Return l_Reads

end function

public function integer of_filewrite (string as_filename, string as_text);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_FileWrite()
//	Arguments:  as_FileName - The name of the file to write to.
//					as_Text 		- The text to be written to the file.
//	Returns:		Integer
//						1 if successful,
//					  -1 if an error occurrs.
//	Overview:   Open, write to, and close a file.  Handles strings > 32,765 bytes. This function overloads the real of_FileWrite to 
//					allow the Append	parameter to be optional (default is True).
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return this.of_FileWrite(as_FileName, as_Text, True)

end function

public function integer of_filewrite (string as_filename, blob ablb_data, boolean ab_append);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_FileWrite()
//	Arguments:  as_FileName -	The name of the file to write to.
//					ablb_Data 	- 	The data to be written to the file.
//					ab_append 	- 	Append (True) or Replace(False)
//	Returns:		Integer
//						1 if successful, -1 if an error occurrs.
//	Overview:   Open, write from a blob, and close a file.  Handles blobs > 32,765 bytes.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer		li_FileNo, li_Writes, li_Cnt
Long		ll_BlobLen, ll_CurrentPos
Blob			lblb_Data
Writemode	lwm_Mode

//-----------------------------------------------------------------------------------------------------------------------------------
//	Determine if file exists before we bother.
//-----------------------------------------------------------------------------------------------------------------------------------	
If Not FileExists(as_FileName) Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
//	Determine whether we should append or replace
//-----------------------------------------------------------------------------------------------------------------------------------/
If ab_Append Then
	lwm_Mode = Append!
Else
	lwm_Mode = Replace!
End if

//-----------------------------------------------------------------------------------------------------------------------------------/
//	Open the file and get a pointer to it. Return if unable to open file.
//-----------------------------------------------------------------------------------------------------------------------------------/
li_FileNo = FileOpen(as_FileName, StreamMode!, Write!, LockReadWrite!, lwm_Mode)
If li_FileNo < 0 Then Return -1

ll_BlobLen = Len(ablb_Data)

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the number of writes required to write the entire blob
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_BlobLen > 32765 Then
	li_writes = Ceiling(ll_BlobLen/32765)
Else
	li_Writes = 1
End if

ll_CurrentPos = 1

//-----------------------------------------------------------------------------------------------------------------------------------
// Write the blob to the file, incrementing the position in the blob each time.
//-----------------------------------------------------------------------------------------------------------------------------------
For li_Cnt = 1 To li_Writes
	lblb_Data = BlobMid(ablb_Data, ll_CurrentPos, 32765)
	ll_CurrentPos += 32765
	If FileWrite(li_FileNo, lblb_Data) = -1 Then
		Return -1
	End if
Next

FileClose(li_FileNo)

Return 1

end function

public function integer of_filewrite (string as_filename, string as_text, boolean ab_append);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_FileWrite()
//	Arguments:  as_FileName - The name of the file to write to.
//					as_Text 		- The text to be written to the file.
//					ab_Append 	- True - append to the end of the file,
//									  False - overwrite the existing file.
//	Returns:		Integer
//						1 if successful, -1 if an error occurrs.
//	Overview:   Open, write to, and close a file.  Handles strings > 32,765 bytes.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return this.of_filewrite(as_filename,blob(as_text),ab_append)
end function

public function string of_getaltfilename (string as_longfilename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getaltfilename()
//	Arguments:  as_longfilename 	- ReasonForArgument
//	Returns:		8.3 version of the filename.
//	Overview:   Determine the 8.3 version of the Long Filename. This function must be implmented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return ""

end function

public function integer of_getcreationdate (string as_filename, ref date ad_date);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_GetCreationDate()
//	Arguments:  as_FileName - 	The name of the file for which you want its date; an absolute path may be specified or it will be
//									  	relative to the current working directory
//					ad_Date 		-	The date the file was created, passed by reference.
//	Returns:		Integer
//						 1 if successful, 
//						-1 if an error occurrs.
//	Overview:   Get the date a file was created.  This is only valid for Win32.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Time		lt_Time

Return this.of_GetCreationDatetime(as_FileName, ad_Date, lt_Time)

end function

public function integer of_getcreationdatetime (string as_filename, ref date ad_date, ref time at_time);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_GetCreationDate()
//	Arguments:  as_FileName - 	The name of the file for which you want its date; an absolute path may be specified or it will be
//									  	relative to the current working directory
//					ad_Date 		-	The date the file was created, passed by reference.
//	Returns:		Integer
//						 1 if successful, 
//						-1 if an error occurrs.
//	Overview:   Get the date a file was created.  This is only valid for Win32 and the function must be implemented in the descendent
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_getcreationtime (string as_filename, ref time at_time);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_GetCreationDate()
//	Arguments:  as_FileName - 	The name of the file for which you want its date; an absolute path may be specified or it will be
//									  	relative to the current working directory
//					at_time 		-	The time the file was created, passed by reference.
//	Returns:		Integer
//						 1 if successful, 
//						-1 if an error occurrs.
//	Overview:   Get the time a file was created.  This is only valid for Win32 and the function must be implemented in the descendent
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Date		ld_Date

Return of_GetCreationDatetime(as_FileName, ld_Date, at_Time)

end function

public function string of_getcurrentdirectory ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getcurrentdirectory()
//	Arguments:  NONE
//	Returns:		String - current directory.
//	Overview:   Get the current directory. This function must be implemented in the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return ""

end function

public function integer of_getdiskspace (string as_drive, ref long al_totalspace, ref long al_freespace);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getdiskspace()
//	Arguments:  as_drive	- Name of the drive
//					al_totalspace - Total space on the drive
//					al_freespace - Free space remaining on the drive.
//	Overview:   Return information about the amount of space on the drive. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_getdrivetype (string as_drive);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getdrivetype()
//	Arguments:  as_drive - Name of drive
//	Returns:		integer - That identifies the type of drive.
//	Overview:   Return the type of drive. This function must be implemented by the descendent.
//	Created by:	Gary Howard

//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_getfileattributes (string as_filename, ref boolean ab_readonly, ref boolean ab_hidden, ref boolean ab_system, ref boolean ab_subdirectory, ref boolean ab_archive);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getfileattributes()
//	Arguments:  as_filename 	- Name of file.
//					ab_readonly 	- Whether the file is read-only.
//					ab_hidden 		- Whether the file is hidden.
//					ab_system 		- Whether the file is a system file.
//					ab_subdirectory - Whether the file is actually  sub-directory.
//					ab_archive 		- Whether the file has its archive bit set
//	Overview:   Return information about the specified filename. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function double of_getfilesize (string as_filename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getfilesize()
//	Arguments:  as_filename - Name of file
//	Returns:		double - The size of the file in bytes.
//	Overview:   Get the size of the file in bytes. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_getlastaccessdate (string as_filename, ref date ad_date);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getlastaccessdate()
//	Arguments:  as_filename - Name of file
//					ad_date 		- Date variable file was last accessed.
//	Overview:   Determine last date the file was accessed on. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_getlastwritedate (string as_filename, ref date ad_date);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_GetLastwriteDate()
//	Arguments:  as_FileName	-	The name of the file for which you want its date; an absolute path may be specified or it will be
//										relative to the current working directory
//					ad_Date 		-	The date the file was last modified, passed by reference.
//	Returns:		Integer
//						 1 if successful, 
//						-1 if an error occurrs.
//	Overview:   Get the date a file was last modified.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Time		lt_Time

Return this.of_GetLastwriteDatetime(as_FileName, ad_Date, lt_Time)

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

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_getlastwritetime (string as_filename, ref time at_time);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getlastwritedatetime()
//	Arguments:  as_FileName	-	The name of the file for which you want its date; an absolute path may be specified or it will be
//										relative to the current working directory
//					at_time		-	The time the file was last modified, passed by reference.
//	Returns:		Integer
//						 1 if successful, 
//						-1 if an error occurrs.
//	Overview:   Get the time a file was last modified. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Date		ld_Date

Return this.of_GetLastwriteDatetime(as_FileName, ld_Date, at_Time)

end function

public function string of_getlongfilename (string as_altfilename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getlongfilename()
//	Arguments:  as_altfilename	-	Name of 8.3 file
//	Overview:   Get the long file name for the 8.3 format file specified. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return ""

end function

public function string of_getseparator ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_GetSeparator()
//	Arguments:	NONE
//	Returns:		String
//					The directory separator character.
//	Overview:	Returns the value of the protected instance constant cis_Separator which is the separator character for directories 
//					in the current operating system.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_Separator

end function

public function integer of_getvolumes (ref string as_volumes[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getvolumes()
//	Arguments:  as_volumes[] 	- Array of volumes passed by reference.
//	Overview:   Get all the volumes associated with this machine. THis function must be imlplemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

protected function boolean of_includefile (string as_filename, long al_attribmask, unsignedlong aul_fileattrib);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IncludeFile()
//	Arguments:  as_FileName 	- 	The name of the file.
//					al_AttribMask 	- 	The bit string that determines which files to include.
//					aul_FileAttrib - 	The attribute bits for the file.
//	Returns:		Boolean
//						True if the file should be included, 
//						False if not.
//	Overview:   Determine whether a file should be included by the of_DirList function. This is based on the attributes of the desired
//					files and the file's attributes.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean				lb_ReadWrite
n_numerical	lnv_Numeric

//-----------------------------------------------------------------------------------------------------------------------------------
// Never include the "[.]" directory entry
//-----------------------------------------------------------------------------------------------------------------------------------
If as_FileName = "." Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// If the mask is > 32768, then read/write files should be excluded
//-----------------------------------------------------------------------------------------------------------------------------------
If al_AttribMask >=32768 Then
	al_AttribMask = al_AttribMask - 32768
	lb_ReadWrite = False
Else
	lb_ReadWrite = True
End if

//-----------------------------------------------------------------------------------------------------------------------------------
// If the type is > 16384, then a list of drives should be included
//-----------------------------------------------------------------------------------------------------------------------------------
If al_AttribMask >= 16384 Then al_AttribMask = al_AttribMask - 16384

//-----------------------------------------------------------------------------------------------------------------------------------
// Include the file if lb_ReadWrite is true and the file is a read-write or
// read-only file (with or without the archive bit set)
// NTFS File Systems set Read/Write Files (FILE_ATTRIBUTE_NORMAL) = 128
//-----------------------------------------------------------------------------------------------------------------------------------
If (lb_ReadWrite And (aul_FileAttrib = 0 Or &
								aul_FileAttrib = 1 Or &
								aul_FileAttrib = 32 Or &
								aul_FileAttrib = 33 Or &
								aul_FileAttrib = 128)) Then Return True

//-----------------------------------------------------------------------------------------------------------------------------------
// Or include it if its attributes match the mask passed in (use bitwise AND).
//-----------------------------------------------------------------------------------------------------------------------------------
Return lnv_Numeric.of_BitwiseAnd(aul_FileAttrib, al_AttribMask) > 0



end function

public function integer of_parsepath (string as_path, ref string as_drive, ref string as_dirpath, ref string as_filename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_ParsePath()
//	Arguments:  as_Path		-	The path to disassemble.
//					as_Drive		-	The disk drive from the path, passed by reference.
//					as_DirPath	-	The directory path, passed by reference.
//					as_FileName	-	The name of the file, passed by reference.
//	Returns:		Integer
//						 1 if it succeeds,
//						-1 if an error occurs.
//	Overview:   Parse a fully-qualified directory path into its component parts. This function overloads the real of_ParsePath to 
//					allow the file	extension to be optional.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_Ext
SetNull (ls_Ext)

Return this.of_ParsePath(as_Path, as_Drive, as_DirPath, as_FileName, ls_Ext)

end function

public function integer of_parsepath (string as_path, ref string as_drive, ref string as_dirpath, ref string as_filename, ref string as_ext);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_ParsePath()
//	Arguments:  as_Path		-	The path to disassemble.
//					as_Drive		-	The disk drive from the path, passed by reference.
//					as_DirPath	-	The directory path, passed by reference.
//					as_FileName	-	The name of the file, passed by reference.
//					as_Ext		-	The file extension, passed by reference.  If null is passed in, the extension will not be parsed out 
//										of the file.
//	Returns:		integer
//						 1 if it succeeds,
//						-1 if an error occurs.
//	Overview:   Parse a fully-qualified directory path into its component parts.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer			li_Pos
String			ls_File
//n_string_functions 	lnv_string

//-----------------------------------------------------------------------------------------------------------------------------------
//	Ensure valid arguments.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_path) or Len(Trim(as_path))=0 Then
	Return -1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the drive
//-----------------------------------------------------------------------------------------------------------------------------------
li_Pos = Pos(as_Path, ":")
If li_Pos = 0 Then
	as_Drive = ""
Else
	If Mid(as_Path, (li_Pos + 1), 1) = is_Separator Then
		li_Pos ++
	End if

	as_Drive = Left(as_Path, li_Pos)
	as_Path = Right(as_Path, (Len(as_Path) - li_Pos))
End if

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the file name and extension
//-----------------------------------------------------------------------------------------------------------------------------------
li_Pos = gn_globals.in_string_functions.of_LastPos(as_Path, is_Separator, 0)
ls_File = Right(as_Path, (Len(as_Path) - li_Pos))
as_Path = Left(as_Path, li_Pos)

If IsNull(as_Ext) Then
	as_FileName = ls_File
	as_Ext = ""
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the extension
	//-----------------------------------------------------------------------------------------------------------------------------------
	li_Pos = gn_globals.in_string_functions.of_LastPos(ls_File, ".")
	If li_Pos > 0 Then
		as_FileName = Left(ls_File, (li_Pos - 1))
		as_Ext = Right(ls_File, (Len(ls_File) - li_Pos))
	Else
		as_FileName = ls_File
		as_Ext = ""
	End if
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Everything left is the directory path
//-----------------------------------------------------------------------------------------------------------------------------------
as_DirPath = as_Path
Return 1
end function

public function integer of_removedirectory (string as_directoryname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_removedirectory()
//	Arguments:  as_directoryname - Name of directory
//	Returns:		-1 - Function not found in descendent.
//	Overview:   Remove specified directory. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------
//	Function not found in descendent
//---------------------------------------------------------------------------------------------
Return -1


end function

public function integer of_setfilearchive (string as_filename, boolean ab_archive);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_SetFileArchive()
//	Arguments:  as_FileName - 	The name of the file whose Archive attributeis to be set.
//					ab_Archive	- 	The value to set the attribute to.
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Set a file's Archive attribute.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean		lb_Null

SetNull(lb_Null)

Return this.of_SetFileAttributes(as_FileName, lb_Null, lb_Null, lb_Null, ab_Archive)

end function

public function integer of_setfileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setfileattributes()
//	Arguments:  as_filename -	Name of file
//					ab_readonly -	Whether the file is read-only.
//					ab_hidden	- 	Whether the file is hidden.
//					ab_system	-	Whether the file is a system file.
//					ab_archive	- 	Whether the file should be marked as an archive file.
//	Overview:   Set file attributes for the specified file. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_setfilehidden (string as_filename, boolean ab_hidden);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_SetFileHidden()
//	Arguments:  as_FileName - 	The name of the file whose Hidden attribute is to be set.
//					ab_Hidden	-	The value to set the attribute to.
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Set a file's Hidden attribute.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean		lb_Null

SetNull(lb_Null)

Return of_SetFileAttributes(as_FileName, lb_Null, ab_Hidden, lb_Null, lb_Null)

end function

public function integer of_setfilereadonly (string as_filename, boolean ab_readonly);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_SetFileReadonly()
//	Arguments:  as_FileName - 	The name of the file whose Read-Only attribute is to be set.
//					ab_ReadOnly	-	The value to set the read-only attribute to.
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Set a file's Read-Only attribute.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean		lb_Null

SetNull(lb_Null)

Return of_SetFileAttributes(as_FileName, ab_ReadOnly, lb_Null, lb_Null, lb_Null)

end function

public function integer of_setfilesystem (string as_filename, boolean ab_system);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_SetFileSystem()
//	Arguments:  as_FileName - 	The name of the file whose Read-Only attribute is to be set.
//					ab_system	-	The value to set the system attribute to.
//	Returns:		Integer
//						 1 if successful,
//						-1 if an error occurrs.
//	Overview:   Set a file's system attribute.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean		lb_Null

SetNull(lb_Null)

Return this.of_SetFileAttributes(as_FileName, lb_Null, lb_Null, ab_System, lb_Null)

end function

public function integer of_setcreationdatetime (string as_filename, date ad_filedate, time at_filetime);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setcreationdatetime()
//	Arguments:  as_filename - Name of file.
//					ad_filedate - Date to set the file creation date from
//					at_filetime - Time to set the file creation time from
//	Overview:   Set the file creation date to the specified date and time. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_setlastaccessdate (string as_filename, date ad_date);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setlastaccessdate()
//	Arguments:  as_filename -	Name of file.
//					ad_filedate -	Date to set the file creation date from
//	Overview:   Set the last-accessed datetime to the specified date and time. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_setlastaccessdatetime (string as_filename, date ad_date, time at_time);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setlastaccessdatetime()
//	Arguments:  as_filename -	Name of file.
//					ad_filedate -	Date to set the file creation date from
//					at_time		-	Time to set the file creation date from
//	Overview:   Set the last-accessed datetime to the specified date and time. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_setlastwritedatetime (string as_filename, date ad_date, time at_time);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setlastwritedatetime()
//	Arguments:  as_filename -	Name of file.
//					ad_filedate -	Date to set the file creation date from
//					at_time		-	Time to set the file creation date from
//	Overview:   Set the last-written datetime to the specified date and time. This function must be implemented by the descendent.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Function not found in descendent
//-----------------------------------------------------------------------------------------------------------------------------------
Return -1

end function

public function integer of_sortdirlist (ref n_api_directory_attributes anv_dirlist[], integer ai_sorttype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_SortDirList()
//	Arguments:  anv_DirList[]	-	The output structure from the of_DirList function.
//					ai_SortType		-	Sort by: 1 - File Name, 
//														2 - File Ext.,
//														3 - File Last Write Date/Time,
//														4 - File Size.
//	Returns:		Integer
//						 1 if it succeeds,
//						-1 if an error occurs.
//	Overview:   Sort the directory list from the of_DirList function.  Sort algorithm used is a bubble sort. This function overloads
//					the real of_SortDirList to allow the last parameter to be optional.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return this.of_SortDirList(anv_DirList, ai_SortType, True)

end function

public function integer of_sortdirlist (ref n_api_directory_attributes anv_dirlist[], integer ai_sorttype, boolean ab_ascending);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_SortDirList()
//	Arguments:  anv_DirList[]	-	The output structure from the of_DirList function.
//					ai_SortType		-	Sort by: 1 - File Name, 
//														2 - File Ext.,
//														3 - File Last Write Date/Time,
//														4 - File Size.
//					ab_Ascending	-	True - sort ascending,
//											False - sort in descending order.
//	Returns:		Integer
//						 1 if it succeeds,
//						-1 if an error occurs.
//	Overview:   Sort the directory list from the of_DirList function.  Sort algorithm used is a bubble sort.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Integer				li_Limit, li_Cnt, li_Pos
Boolean				lb_Done, lb_Swap
String				ls_Entry1, ls_Entry2, ls_Name1, ls_Name2, ls_Ext1, ls_Ext2
n_api_directory_attributes	lnv_DirEntry

//-----------------------------------------------------------------------------------------------------------------------------------
// check arguments.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ai_sorttype) or IsNull(ab_ascending) Then
	Return -1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Loop through and Sort directories.
//-----------------------------------------------------------------------------------------------------------------------------------
li_Limit = UpperBound(anv_DirList) - 1
Do
	lb_Done = True	
	For li_Cnt = 1 to li_Limit
		lb_Swap = False

		If anv_DirList[li_Cnt].ib_Subdirectory Then
			ls_Entry1 = Mid(anv_DirList[li_Cnt].is_FileName, 2, (Len(anv_DirList[li_Cnt].is_FileName) - 2))
		ElseIf anv_DirList[li_Cnt].ib_Drive Then
			ls_Entry1 = Mid(anv_DirList[li_Cnt].is_FileName, 3, 1)
		Else
			ls_Entry1 = anv_DirList[li_Cnt].is_FileName
		End If
		If anv_DirList[li_Cnt + 1].ib_Subdirectory Then
			ls_Entry2 = Mid(anv_DirList[li_Cnt + 1].is_FileName, 2, (Len(anv_DirList[li_Cnt + 1].is_FileName) - 2))
		ElseIf anv_DirList[li_Cnt + 1].ib_Drive Then
			ls_Entry2 = Mid(anv_DirList[li_Cnt + 1].is_FileName, 3, 1)
		Else
			ls_Entry2 = anv_DirList[li_Cnt + 1].is_FileName
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Place subdirectories before files, drives after files and always sort drives in alphabetical order.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If (Not anv_DirList[li_Cnt].ib_Subdirectory And anv_DirList[li_Cnt + 1].ib_Subdirectory) Or &
			(anv_DirList[li_Cnt].ib_Drive And Not anv_DirList[li_Cnt + 1].ib_Drive) Or &
			(anv_DirList[li_Cnt].ib_Drive And anv_DirList[li_Cnt + 1].ib_Drive And ls_Entry1 > ls_Entry2) Then
			lb_Swap = True

		Elseif anv_DirList[li_Cnt].ib_Subdirectory = anv_DirList[li_Cnt + 1].ib_Subdirectory And &
				Not anv_DirList[li_Cnt].ib_Drive And Not anv_DirList[li_Cnt + 1].ib_Drive Then
				
			//-----------------------------------------------------------------------------------------------------------------------------------	
			// Sort based on sort type.
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case ai_SortType
				Case 1	//  Sort by file name
					If (ab_Ascending And ls_Entry1 > ls_Entry2) Or &
						(Not ab_Ascending And ls_Entry1 < ls_Entry2) Then
						lb_Swap = True
					End if

				Case 2	// Sort by file extension
					li_Pos = Pos(ls_Entry1, ".")
					If li_Pos = 0 Or ls_Entry1 = ".." Then
						ls_Name1 = ls_Entry1
						ls_Ext1 = ""
					Else
						ls_Name1 = Left(ls_Entry1, (li_Pos - 1))
						ls_Ext1 = Right(ls_Entry1, (Len(ls_Entry1) - li_Pos))
					End If
					
					li_Pos = Pos(ls_Entry2, ".")
					If li_Pos = 0 Or ls_Entry2 = ".." Then
						ls_Name2 = ls_Entry2
						ls_Ext2 = ""
					Else
						ls_Name2 = Left(ls_Entry2, (li_Pos - 1))
						ls_Ext2 = Right(ls_Entry2, (Len(ls_Entry2) - li_Pos))
					End if
	
					If ab_Ascending And ((ls_Ext1 > ls_Ext2) Or ((ls_Ext1 = ls_Ext2) And (ls_Name1 > ls_Name2))) Or & 
						Not ab_Ascending And ((ls_Ext1 < ls_Ext2) Or ((ls_Ext1 = ls_Ext2) And (ls_Name1 < ls_Name2)))Then
						lb_Swap = True
					End if

				Case 3	// Sort by last write date.
					If ab_Ascending And (((anv_DirList[li_Cnt].id_LastWriteDate > anv_DirList[li_Cnt + 1].id_LastWriteDate) Or &
					   							   ((anv_DirList[li_Cnt].id_LastWriteDate = anv_DirList[li_Cnt + 1].id_LastWriteDate) And &
					   								(anv_DirList[li_Cnt].it_LastWriteTime > anv_DirList[li_Cnt + 1].it_LastWriteTime))) Or &
												   (anv_DirList[li_Cnt].id_LastWriteDate = anv_DirList[li_Cnt + 1].id_LastWriteDate And &
													anv_DirList[li_Cnt].it_LastWriteTime = anv_DirList[li_Cnt + 1].it_LastWriteTime And &
													ls_Entry1 > ls_Entry2)) Or &
					   Not ab_Ascending And (((anv_DirList[li_Cnt].id_LastWriteDate < anv_DirList[li_Cnt + 1].id_LastWriteDate) Or &
					   									((anv_DirList[li_Cnt].id_LastWriteDate = anv_DirList[li_Cnt + 1].id_LastWriteDate) And &
					  									 (anv_DirList[li_Cnt].it_LastWriteTime < anv_DirList[li_Cnt + 1].it_LastWriteTime))) Or &
														(anv_DirList[li_Cnt].id_LastWriteDate = anv_DirList[li_Cnt + 1].id_LastWriteDate And &
														 anv_DirList[li_Cnt].it_LastWriteTime = anv_DirList[li_Cnt + 1].it_LastWriteTime And &
														 ls_Entry1 < ls_Entry2)) Then
						lb_Swap = True
					End if

				Case 4	// Sort by size
					If ab_Ascending And (anv_DirList[li_Cnt].idb_FileSize > anv_DirList[li_Cnt + 1].idb_FileSize Or &
												  (anv_DirList[li_Cnt].idb_FileSize = anv_DirList[li_Cnt + 1].idb_FileSize And &
												   ls_Entry1 > ls_Entry2)) Or &
						Not ab_Ascending And (anv_DirList[li_Cnt].idb_FileSize < anv_DirList[li_Cnt + 1].idb_FileSize Or &
												  		 (anv_DirList[li_Cnt].idb_FileSize = anv_DirList[li_Cnt + 1].idb_FileSize And &
												   		  ls_Entry1 < ls_Entry2)) Then
						lb_Swap = True
					End if
			End Choose
		End If
		
		If lb_Swap Then
			lnv_DirEntry = anv_DirList[li_Cnt]
			anv_DirList[li_Cnt] = anv_DirList[li_Cnt + 1]
			anv_DirList[li_Cnt + 1] = lnv_DirEntry
			lb_Done = False
		End if
	Next
	li_Limit --

Loop Until lb_Done

Return 1
end function

protected function unsignedlong of_calculatefileattributes (string as_filename, boolean ab_readonly, boolean ab_hidden, boolean ab_system, boolean ab_archive);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_calculatefileattributes()
//	Arguments:  as_FileName	-	The file whose attributes you want to set; an absolute path may be specified or it will be relative 
//										to the current working directory.
//					ab_ReadOnly	-	The new value for the Read-Only attribute.
//					ab_Hidden	-	The new value for the Hidden attribute.
//					ab_System	-	The new value for the System attribute.
//					ab_Archive	-	The new value for the Archive attribute.
//	Returns:		Ulong			- The new attribute byte
//	Overview:   Calculate the new attribute byte for a file.  If null is passed for any of the attributes, it will not be changed.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean	lb_ReadOnly, lb_Hidden, lb_System, lb_Subdirectory, lb_Archive
ULong		lul_Attrib

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the current attribute values
//-----------------------------------------------------------------------------------------------------------------------------------
If of_GetFileAttributes(as_FileName, lb_ReadOnly, lb_Hidden, &
		lb_System, lb_Subdirectory, lb_Archive) = -1 Then 
	Return -1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Preserve the Subdirectory attribute
//-----------------------------------------------------------------------------------------------------------------------------------
If lb_Subdirectory Then
	lul_Attrib = 16
Else
	lul_Attrib = 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set Read-Only
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ab_ReadOnly) Then
	If ab_ReadOnly Then lul_Attrib = lul_Attrib + 1
Else
	If lb_ReadOnly Then lul_Attrib = lul_Attrib + 1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set Hidden
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ab_Hidden) Then
	If ab_Hidden Then lul_Attrib = lul_Attrib + 2
Else
	If lb_Hidden Then lul_Attrib = lul_Attrib + 2
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set System
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ab_System) Then
	If ab_System Then lul_Attrib = lul_Attrib + 4
Else
	If lb_System Then lul_Attrib = lul_Attrib + 4
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set Archive
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ab_Archive) Then
	If ab_Archive Then lul_Attrib = lul_Attrib + 32
Else
	If lb_Archive Then lul_Attrib = lul_Attrib + 32
End If

Return lul_Attrib

end function

public function boolean of_copy (string as_fromfile, string as_tofile, character ac_replace);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_copy
//	Arguments:  as_fromfile - from file
//					as_tofile - to file
//					ac_replace - Append or replace.
//	Overview:   This function will copy a file from one destination to another destination and append it if necessary.
//	Created by:	Gary Howard
//	History: 	10/19/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Local variables used in script
//-----------------------------------------------------
int i_ReadFile,i_WriteFile
blob b_temp
long l_flen,l_loop, i, l_totalwritten, l_BytesWritten
Writemode	lwm_Mode

//-----------------------------------------------------
// Ensure source file exists and can be opened
//-----------------------------------------------------
If not FileExists(as_fromfile) Then Return FALSE
i_ReadFile = FileOpen(as_fromfile,StreamMode!,Read!,Shared!)

//-----------------------------------------------------
// Ensure file open created the file successfully
//-----------------------------------------------------
If i_ReadFile = -1 or IsNull(i_ReadFile) Then Return FALSE

//-----------------------------------------------------------------------------------------------------------------------------------
//	Determine whether we should append or replace
//-----------------------------------------------------------------------------------------------------------------------------------/
If ac_replace = "R" Then
	lwm_Mode = Append!
Else
	lwm_Mode = Replace!
End if

//-----------------------------------------------------
// Reference the argument s_filename to define the name 
//	of the file as well as open it.
//-----------------------------------------------------
i_WriteFile = FileOpen(as_tofile,StreamMode!,Write!,Shared!,lwm_Mode)

//-----------------------------------------------------
// Ensure file open created or opened
//	the file successfully.
//-----------------------------------------------------
If i_WriteFile = -1 or IsNull(i_WriteFile) Then Return FALSE

//-----------------------------------------------------
// Determine how many times to call FileWrite because we can only 
// write 32k of data at a time. If len is < 32k we can write once and never
//	enter loop.
//-----------------------------------------------------
l_flen = FileLength(as_fromfile)
If l_flen > 32765 Then
	l_loop = Ceiling(l_flen/32765)
Else
	FileRead(i_ReadFile,b_temp)
	l_BytesWritten = FileWrite(i_WriteFile,b_temp)
	FileClose(i_ReadFile)
	FileClose(i_WriteFile)
	Return l_BytesWritten = l_flen
End If

//-----------------------------------------------------
// Write the file until EOF.
//-----------------------------------------------------
FOR i = 1 to l_loop
	FileRead(i_ReadFile,b_temp)
	l_BytesWritten = FileWrite(i_WriteFile,b_temp)
	l_totalwritten = l_totalwritten + l_BytesWritten
NEXT

//-----------------------------------------------------
//	Close Files and Return sucess or failure based on 
//	whether the number of bytes written matches with
//	the number of total bytes in the source file.
//-----------------------------------------------------
FileClose(i_ReadFile)
FileClose(i_WriteFile)
RETURN l_totalwritten = l_flen
end function

public function boolean of_copy_all ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_copy_all
// Arguments:	NONE
// Overview:	Copy all files in array as specified
// Created by:	Gary Howard
// History:		10/20/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_upperbound,i

l_upperbound = UpperBound(iuostr_files[])

For i = 1 to l_upperbound
	If not this.of_copy(iuostr_files[i].s_fromfile,iuostr_files[i].s_tofile,iuostr_files[i].c_replace) Then RETURN FALSE
Next

RETURN TRUE
end function

public function boolean of_copyall ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_copyall
// Arguments:	NONE
// Overview:	Copy all files in array as specified
// Created by:	Gary Howard
// History:		10/20/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_upperbound,i

l_upperbound = UpperBound(iuostr_files[])

For i = 1 to l_upperbound
	If not this.of_copy(iuostr_files[i].s_fromfile,iuostr_files[i].s_tofile,iuostr_files[i].c_replace) Then RETURN FALSE
Next

RETURN TRUE
end function

public function string of_assemblepath (string as_drive, string as_dirpath, string as_filename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_AssemblePath()
//	Arguments:  as_Drive - 		The disk drive from the path.
//					as_DirPath - 	The directory path.
//					as_FileName - 	The name of the file.
//	Returns:		String -	The fully-qualified directory path.
//	Overview:   Assemble a fully-qualified directory path from its component parts. This function overloads the real of_AssemblePath
//					to allow the file	extension to be optional.
//	Created by:	Gary Howard
//	History: 	7/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return this.of_AssemblePath(as_Drive, as_DirPath, as_FileName, "")
end function

on n_api_fileservices.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_api_fileservices.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

