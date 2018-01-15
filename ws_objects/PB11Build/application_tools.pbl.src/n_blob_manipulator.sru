$PBExportHeader$n_blob_manipulator.sru
$PBExportComments$This object allows blob retrieval, insertion, and conversion from a blob to a file, and from a file to a blob.
forward
global type n_blob_manipulator from nonvisualobject
end type
end forward

global type n_blob_manipulator from nonvisualobject
end type
global n_blob_manipulator n_blob_manipulator

type prototypes
//Windows NT Function Calls
function int GetWindowsDirectoryA(ref string as_dir, int nSize) library 'kernel32.dll' alias for "GetWindowsDirectoryA;Ansi"

//Windows 3.1x Function Calls
function int GetWindowsDirectory(ref string as_dir, int nSize) library 'kernel.dll' alias for "GetWindowsDirectory;Ansi"

//Windows 32-bit Function Calls
function long GetTempPathA(long nBufferLength,ref string lpBugger) library 'kernel32.dll' alias for "GetTempPathA;Ansi"

//Windows 3.1x Function Calls
function long GetTempPath(long nBufferLength,ref string lpBugger) library 'kernel.dll' alias for "GetTempPath;Ansi"
end prototypes

type variables
PROTECTED:
 long il_key
String is_blobobject_qualifier
DateTime idt_creationdate
String is_errormessage
end variables

forward prototypes
public function blob of_retrieve_blob (string s_objectname, datetime sdt_creationdate)
public function long of_get_blobid ()
public function long of_insert_blob (blob b_to_be_inserted, string s_qlfr)
public function blob of_retrieve_blob (long al_blbobjctid)
public function long of_delete_blob (string s_objectname, datetime sdt_creationdate)
public function long of_delete_blob (long al_blobid)
public function string of_get_blob_qualifier ()
public function datetime of_get_blob_creation_date ()
public function long of_insert_blob (ref blob b_to_be_inserted, string s_qlfr, boolean ab_compress)
public function string of_get_error_message ()
public function long of_update_blob (ref blob b_to_be_inserted, long l_blobobjectid, boolean ab_compress)
public function boolean of_build_file_from_blob (blob b_source, string s_filename)
public function blob of_retrieve_signature (long al_userid)
public function blob of_build_blob_from_file (string s_filename)
public function string of_determine_filename (string as_filename)
end prototypes

public function blob of_retrieve_blob (string s_objectname, datetime sdt_creationdate);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_retrieve_blob()
// Arguments:   s_objectname		- Blobobject class name that maps to the blbobjctqlfr column
//					 sdt_creationdate - Datetime that maps to the blbobjctcrtndte column
// Overview:    Retrieve Blob object from BlobObject table according to the specified arguments
// Created by:  Joel White
// History:     12/29/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_compression ln_compression
blob b_data, b_uncompressed_blob
String ls_compressiontype, ls_filename

SelectBlob 	blbobjctdta 
INTO			:b_data
From 			blobobject
WHERE	  		blbobjctqlfr = :s_objectname
AND			blbobjctcrtndte = :sdt_creationdate
USING 		SQLCA;


Select		blbobjctqlfr,
				blbobjctcrtndte,
				blbobjctcmprssntpe
INTO			:is_blobobject_qualifier,
				:idt_creationdate,
				:ls_compressiontype
From 			blobobject
WHERE	  		blbobjctqlfr = :s_objectname
AND			blbobjctcrtndte = :sdt_creationdate;

Choose Case Lower(Trim(ls_compressiontype))
	Case 'zli compression'
		ln_compression = Create n_compression
		
		ln_compression.of_uncompress(ls_filename, b_data, b_uncompressed_blob)
		
		b_data = b_uncompressed_blob
		
		Destroy ln_compression
		
	Case 'pkzip compression'
	Case 'none'
		
End Choose

return b_data
end function

public function long of_get_blobid ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_blobid
// Arguments:   none
// Overview:    Returns the key for the blob object just inserted
// Created by:  Joel White
// History:     12/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return il_key
end function

public function long of_insert_blob (blob b_to_be_inserted, string s_qlfr);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_insert_blob
// Arguments:  b_to_be_inserted - Blob that will go into the database
//					s_qlfr - Qualifier that describes the general classification of the object (Is is AccoutingReporting,ContractPrinting,etc.)
// Overview:   Insert a blob into the ReportConfig table with the specified qualifier and current datetime stamp.
//					Return the key value inserted from ReportConfig if it is successful. Else return -1					
// Created by: Joel White
// History:    11/17/1997 - First Created 
// DRW 7/1/98 Modified this to simply grab the current date and pass it along with the other args to the new overloading function of_insert_blob()
//-----------------------------------------------------------------------------------------------------------------------------------

Return of_insert_blob(b_to_be_inserted, s_qlfr, False)


end function

public function blob of_retrieve_blob (long al_blbobjctid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_retrieve_blob()
// Arguments:   al_blbobjctid	- Unique blobobject ID
// Overview:    Retrieve Blob object from blobobject table according to the specified key id
// Created by:  Joel White
// History:     12/29/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_compression ln_compression
blob b_data, b_uncompressed_blob, b_nullblob
String ls_compressiontype, ls_filename
SetNull(b_nullblob)

SelectBlob 	blbobjctdta
INTO			:b_data
From 			blobobject
WHERE	  		blbobjctid = :al_blbobjctid;


Select		blbobjctqlfr,
				blbobjctcrtndte,
				blbobjctcmprssntpe
INTO			:is_blobobject_qualifier,
				:idt_creationdate,
				:ls_compressiontype
From 			blobobject
WHERE	  		blbobjctid = :al_blbobjctid;

Choose Case Lower(Trim(ls_compressiontype))
	Case 'zli compression'
		ln_compression = Create n_compression

		If ln_compression.of_uncompress(ls_filename, b_data, b_uncompressed_blob) > 0 Then
			b_data = b_uncompressed_blob
		Else
			is_errormessage = 'Could not decompress binary object.  Missing Compression DLLs'
			Destroy ln_compression
			Return b_nullblob
		End If
			
		Destroy ln_compression
		
	Case 'pkzip compression'
	Case 'none'
		
End Choose

return b_data
end function

public function long of_delete_blob (string s_objectname, datetime sdt_creationdate);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_delete_blob()
// Arguments:   s_objectname	- blobobject class name that maps to the blbobjctqlfr column
//				 sdt_creationdate - Datetime that maps to the blbobjctcrtndte column
// Overview:    Delete Blob object from blobobject table according to the specified arguments. Returns number
//				of deleted rows.
// Created by:  Dave Widger
// History:     07/07/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_rws

Select	 	Count(*)
Into 		:l_rws
From		blobobject
WHERE		blbobjctqlfr = :s_objectname
AND		blbobjctcrtndte < :sdt_creationdate
USING 	SQLCA;

Delete		blobobject
WHERE		blbobjctqlfr = :s_objectname
AND		blbobjctcrtndte < :sdt_creationdate
USING 	SQLCA;

If SQLCA.Sqlcode <> 0 Then l_rws = -1

Return l_rws

end function

public function long of_delete_blob (long al_blobid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_delete_blob()
// Arguments:   al_blobid - The ID of the blob you want to delete
// Overview:    Delete Blob object from blobobject table according to the specified arguments. Returns number
//				of deleted rows.
// Created by:  Dave Widger
// History:     07/07/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_rws

Select	 	Count(*)
Into 		:l_rws
From		blobobject
WHERE		blbobjctid = :al_blobid
USING 	SQLCA;

Delete		blobobject
WHERE		blbobjctid = :al_blobid
USING 	SQLCA;

If SQLCA.Sqlcode <> 0 Then l_rws = -1

Return l_rws

end function

public function string of_get_blob_qualifier ();Return is_blobobject_qualifier
end function

public function datetime of_get_blob_creation_date ();Return idt_creationdate
end function

public function long of_insert_blob (ref blob b_to_be_inserted, string s_qlfr, boolean ab_compress);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_insert_blob
// Arguments:  b_to_be_inserted - Blob that will go into the database
//					s_qlfr - Qualifier that describes the general classification of the object (Is is AccoutingReporting,ContractPrinting,etc.)
//					dt_date - Datetime value to accompany the blob into the database
//					ab_compress - Whether or not to compress it
// Overview:   Insert a blob into the ReportConfig table with the specified qualifier and user-controlled datetime stamp.
//					Return the key value inserted from ReportConfig if it is successful. Else return -1					
// Created by: Blake and Gary
// History:    07/1/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Local variables used in script
//-----------------------------------------------------
datetime ldt_getdate

//-----------------------------------------------------
// Local variables used in script
//-----------------------------------------------------
integer i_fnum, i_loops, i, i_usrid
long 	l_flen
blob b_temp, b_compressed_blob
boolean b_autocommit
String ls_compressiontype
n_compression ln_compression

//--------------------------------------------------------------------------------------------------------------
// Blob columns require initialization before you can actually put meaningful data in them. Therefore, we 
// convert a string into a blob so that we minimize the amount of data sent over the network.
//--------------------------------------------------------------------------------------------------------------
b_temp = blob('Initialization string')

//-----------------------------------------------------
// get key for id column on blobobject table
//-----------------------------------------------------
n_update_tools ln_update_tools
ln_update_tools = create n_update_tools
il_key = ln_update_tools.of_get_key('blobobject')
destroy ln_update_tools

//DECLARE lsp_getkey PROCEDURE FOR sp_getkey  
//         @vc_TbleNme = 'blobobject',   
//         @i_Ky = :il_key OUTPUT;
//
//Execute lsp_getkey;
//
//FETCH lsp_getkey INTO :il_key;
//
//Close	lsp_getkey;

//-----------------------------------------------------
// Check if key value returned successfully
//-----------------------------------------------------
If il_key <= 0 or IsNull(il_key) Then Return -1

//-----------------------------------------------------
// Validate the date arg
//-----------------------------------------------------
//If IsNull(ldt_getdate) or (date(ldt_getdate) < date('1/1/1900'))  or (date(ldt_getdate) > date('12/31/2049')) Then Return -1

//-----------------------------------------------------
// Compress the blob before we insert it
//-----------------------------------------------------
If ab_compress Then
	ln_compression = Create n_compression
	
	
	If ln_compression.of_compress('temp.psr', b_to_be_inserted, b_compressed_blob) > 0 Then
		b_to_be_inserted = b_compressed_blob
		ls_compressiontype = 'ZLI Compression'	
	Else
		ls_compressiontype = 'None'	
	End If
	Destroy ln_compression

Else
	ls_compressiontype = 'None'
End If


//----------------------------------------------------------------------
// Get Current datetime stamp for timestamping when reports were created
//----------------------------------------------------------------------
DECLARE lsp_getdatetime PROCEDURE FOR sp_getdatetime;

Execute lsp_getdatetime;

Fetch lsp_getdatetime into :ldt_getdate;

Close lsp_getdatetime;

//-----------------------------------------------------
// Check if time stamp value returned successfully
//-----------------------------------------------------
If IsNull(ldt_getdate) or string(ldt_getdate) = '1/1/00 00:00:00' Then Return -1

//-----------------------------------------------------
// Insert into the Blob table the initialization string
//-----------------------------------------------------
INSERT	blobobject  
			(blbobjctid,   
          blbobjctqlfr,   
          blbobjctcrtndte,   
          blbobjctdta,
			 blbobjctcmprssntpe)  
VALUES	(:il_key,   
          :s_qlfr,   
          :ldt_getdate,   
          :b_temp,
			 :ls_compressiontype);
			 
//commit using sqlca;

//-----------------------------------------------------
// If that worked then update the blob column with the 
// real data and return the key value. 
//-----------------------------------------------------
If SQLCA.SQLCODE = 0 Then
	UPDATEBLOB  blobobject 
 	SET     		blbobjctdta = :b_to_be_inserted
	WHERE			blbobjctid = :il_key
	USING 		SQLCA;
	
	
	
	
	If SQLCA.SQLCODE = 0 Then
		Return il_key
	Else
		Return -1
	End If 
Else
	Return -1
End If 	

Return il_key

end function

public function string of_get_error_message ();Return is_errormessage
end function

public function long of_update_blob (ref blob b_to_be_inserted, long l_blobobjectid, boolean ab_compress);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_update_blob
// Arguments:  b_to_be_inserted - Blob that will go into the database
//					ab_compress - Whether or not to compress it
// Overview:   Update a blob value with compression if required.
//					Return success (0) or failure (-1) depending on whether we affected rows.				
// Created by: Joel White
// History:    07/1/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

blob b_compressed_blob
n_compression ln_compression

//-----------------------------------------------------
// Compress the blob before we insert it if required
//-----------------------------------------------------
If ab_compress Then
	ln_compression = Create n_compression
	If ln_compression.of_compress('temp.psr', b_to_be_inserted, b_compressed_blob) > 0 Then
		b_to_be_inserted = b_compressed_blob
	End If
	Destroy ln_compression
End If

//-----------------------------------------------------
// Update the blob column
//-----------------------------------------------------
UPDATEBLOB  blobobject 
SET     		blbobjctdta = :b_to_be_inserted
WHERE			blbobjctid = :l_blobobjectid;

If SQLCA.SQLCODE = 0 Then
	If ab_compress Then
		Update		blobobject
		Set			blbobjctcmprssntpe = "ZLI Compression"
		Where			blbobjctid = :l_blobobjectid;
	Else
		Update		blobobject
		Set			blbobjctcmprssntpe = "NONE"
		Where			blbobjctid = :l_blobobjectid;
	End If
End If

If SQLCA.SQLCODE = 0 Then
	Return 0
Else
	Return -1
End If
end function

public function boolean of_build_file_from_blob (blob b_source, string s_filename);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_build_file_from_blob
// Arguments:   b_source - BLOB variable containing data that needs to be written to a file
//					 s_filename - string containing name of file to be created.
// Overview:    Write the blob to the filename specified in the argument
// Created by:  Joel White
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

////-----------------------------------------------------
//// Local variables used in script
////-----------------------------------------------------
//integer l_fnum, l_loops, i,i_userid
//long 	l_flen, l_pos, l_remlen, l_written
//blob b_temp
//datawindowchild ldwc_user
//
//string s_contract_number, s_username
//
////-----------------------------------------------------
//// Determine length of blob to know length of file
////-----------------------------------------------------
//l_flen = len(b_source)
//
////-----------------------------------------------------
//// Ensure we returned valid image data
////-----------------------------------------------------
//If l_flen = 0 or IsNull(b_source) Then
//	Return False
//End If
//
////-----------------------------------------------------
//// Reference the argument s_filename to define the name 
////	of the file as well as open it.
////-----------------------------------------------------
//l_fnum = FileOpen(s_filename,StreamMode!,Write!,Shared!,Replace!)
//
////-----------------------------------------------------
//// Ensure file open created the file successfully
////-----------------------------------------------------
//If l_fnum = -1 or IsNull(l_fnum) Then Return FALSE
//
////-----------------------------------------------------
//// Determine how many times to call FileWrite because we can only 
//// write 32k of data at a time. If len is < 32k we can write once and never
////	enter loop.
////-----------------------------------------------------
//IF l_flen > 32765 THEN 
//	l_loops = Ceiling(l_flen/32765)
//	b_temp = BlobMid ( b_source, 1,32765)
//	l_pos = 1
//ELSE
//	l_loops = 0
//	l_written = FileWrite(l_fnum, b_source)
//END IF
//
////-----------------------------------------------------
//// Write the file
////-----------------------------------------------------
//FOR i = 1 to l_loops
//	
//	//-----------------------------------------------------
//	// Number of bytes written.
//	//-----------------------------------------------------
//	i_userid = FileWrite(l_fnum, b_temp)
//	l_written = i_userid + l_written
//	
//	//-----------------------------------------------------
//	//	Remaining bytes that are not written
//	//-----------------------------------------------------
//	l_remlen = l_flen - l_written
//
//	//-----------------------------------------------------
//	//	Increment position of offset by number of bytes written
//	//-----------------------------------------------------
//	l_pos = l_pos + i_userid
//
//	//-----------------------------------------------------
//	//	Determine if less than 32k of data remains
//	//-----------------------------------------------------
//	If l_remlen > 32765 Then
//		b_temp = BlobMid(b_source, l_pos,32765)
//	Else
//		b_temp = BlobMid(b_source, l_pos,l_remlen)
//	End If 
//NEXT
//
////-----------------------------------------------------
////	Close File
////-----------------------------------------------------
//FileClose(l_fnum)
//
//Return True

//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_build_file_from_blob
// Arguments:   b_source - BLOB variable containing data that needs to be written to a file
//					 s_filename - string containing name of file to be created.
// Overview:    Saves blob to a file
// Created by:  Joel White
// History:     8/14/2002 - First Created 
// Revision:    8/14/2002 - Improved performance for large blobs
//-----------------------------------------------------------------------------------------------------------------------------------

long l_fnum, l_flen, l_loops, l_written, l_write
long l_remlen, l_pos, i, j, l_bytes, l_return
blob b_temp[], b_write

//-----------------------------------------------------
// Ensure we returned valid image data
//-----------------------------------------------------
l_flen = len(b_source)
If l_flen = 0 or IsNull(b_source) Then
	Return False
End If

//-----------------------------------------------------
// Reference the argument s_filename to define the name 
//	of the file as well as open it.
//-----------------------------------------------------
l_fnum = FileOpen(s_filename,StreamMode!,Write!,Shared!,Replace!)

//-----------------------------------------------------
// Ensure file open created the file successfully
//-----------------------------------------------------
If l_fnum = -1 or IsNull(l_fnum) Then Return FALSE

//-----------------------------------------------------
// Determine if the blob length is less than 32K, and if
// so just write the blob to the file
//-----------------------------------------------------
if l_flen <= 32765 then
	l_return = FileWrite (l_fnum, b_source)
	FileClose (l_fnum)
	Return l_return = l_flen
end if	


//-----------------------------------------------------
// Determine the number of blob array elements to split the
// blob into.
//-----------------------------------------------------
l_bytes = 1024000
l_pos = 1			
IF l_flen > l_bytes THEN 
	l_loops = Ceiling(l_flen/l_bytes)
ELSE
	l_loops = 1
END IF

//-----------------------------------------------------
// Parse Big Blob into a blob array
//-----------------------------------------------------
FOR i = 1 to l_loops
	b_temp[i] = BlobMid ( b_source, l_pos, l_bytes)
	l_pos = (l_bytes * i) + 1
NEXT



//-----------------------------------------------------
// Process the blob array, and write to the file in 
// 32K chunks.
//-----------------------------------------------------
l_bytes = 32765
For i = 1 to Upperbound(b_temp)
	l_flen = len(b_temp[i])
	l_pos = 1
	
	//-----------------------------------------------------
	// Determine the number of 32k chunks in each blob element
	//-----------------------------------------------------
	IF l_flen > l_bytes THEN 
		l_loops = Ceiling(l_flen/l_bytes)
	ELSE
		l_loops = 1
	END IF


	//-----------------------------------------------------
	// write the blob element to file
	//-----------------------------------------------------
	For j = 1 to l_loops
		b_write = BlobMid ( b_temp[i], l_pos, l_bytes)
		FileWrite (l_fnum, b_write)
		l_pos = (l_bytes * j) + 1
	Next
	
NExt

//-----------------------------------------------------
// Close the file
//-----------------------------------------------------
FileClose (l_fnum)

Return True

end function

public function blob of_retrieve_signature (long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_retrieve_signature()
// Arguments:	al_userid - Userid for which you want a signature
// Overview:	select the appropriate signature into a blob variable. 
// Created by:	Joel White
// History:		2/10/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Blob lblob_empty
Long ll_blobobjectid

Select	Users.SignatureBlobID
Into		:ll_blobobjectid
From		Users
Where		Users.UserID		= :al_userid;

If Not IsNull(ll_blobobjectid) And ll_blobobjectid > 0 Then
	Return This.of_retrieve_blob(ll_blobobjectid)
End If

Return lblob_empty
end function

public function blob of_build_blob_from_file (string s_filename);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_build_blob_from_file
// Arguments:   s_filename	string that contains the filename of the binary file
// Overview:    Open a file, read it into a blob, and return the blob.
// Created by:  Joel White
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Local variables used in script
//-----------------------------------------------------
blob b_return,b_temp, b_partial[]
long l_loops, l_flen,l_fnum, l_i
long i, ll_array_pointer

//-----------------------------------------------------
// Ensure this is a valid file, determine length of file, and open file.
//-----------------------------------------------------
If FileExists(s_filename) Then
	l_flen = FileLength(s_filename)
	l_fnum = FileOpen(s_filename,StreamMode!,Read!)
Else
	//MessageBox('File Access Error','The file you specified could not be found.')
	SetNull(b_return)
	Return b_return
End If 

//-----------------------------------------------------
// Determine how many times to call FileRead 
//-----------------------------------------------------
IF l_flen > 32765 THEN
	l_loops = Ceiling(l_flen/32765)
ELSE
	l_loops = 1
END IF

//-----------------------------------------------------
// Read the file as many times as it takes
//-----------------------------------------------------
i = 1
ll_array_pointer = 1
FOR l_i = 1 to l_loops
	 FileRead(l_fnum, b_temp)
	//-----------------------------------------------------
	// Read the file into a blob array in 1 MB chunks
	//-----------------------------------------------------
	 if i <= 30 then 
		 b_partial[ll_array_pointer] = b_partial[ll_array_pointer] + b_temp
		 i ++
	else
		 ll_array_pointer++
		 b_partial[ll_array_pointer] = b_partial[ll_array_pointer] + b_temp
		 i = 1
	end if
NEXT

//-----------------------------------------------------
// Build the return blob from the blob array
//-----------------------------------------------------
For i = 1 to UpperBound(b_partial)
	b_return = b_return + b_partial[i]
Next

//-----------------------------------------------------
// Close the file
//-----------------------------------------------------
FileClose(l_fnum)

Return b_return

end function

public function string of_determine_filename (string as_filename);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_determine_file_name
// Arguments:   as_filename - string that will be the file name, minus the path to the file
// Overview:    Find out the directory that has windows in it, so we can save
//					 a temporary file in that directory.
// Created by:  Joel White
// History:     11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
//	Local variables used in script
//-----------------------------------------------------
environment lenv_os
long l_rtn
int  l_size
string s_win_dir

//-----------------------------------------------------
// Get Operating System Environment
// and ensure this operation was successful
//-----------------------------------------------------
l_rtn = GetEnvironment(lenv_os)

IF l_rtn <> 1 THEN RETURN ''

//-----------------------------------------------------
// GetWindowsDirectory requires a size int for some reason
// I'm not sure about filling the string with 128 spaces either.
// But since I'm copying the code from the application open event
// I figure it must work... GLH
//-----------------------------------------------------
l_size = 128
s_win_dir = space(l_size)

//-----------------------------------------------------
// Determine which version of windows were working on
//-----------------------------------------------------
CHOOSE CASE lenv_os.OSType
CASE Windows!
		if lenv_os.OSMajorRevision = 3 then
			l_rtn = GetTempPath(l_size,s_win_dir)
		else
			l_rtn = GetTempPathA(l_size,s_win_dir)
		end if
CASE Else
		l_rtn = GetTempPathA(l_size,s_win_dir)
END CHOOSE

//-----------------------------------------------------
// Now that we have a file path, lets build a string with 
// the actual filename we want to save to
//-----------------------------------------------------
s_win_dir = s_win_dir + as_filename
//Return 'R:\Temp\' + as_filename/**/
Return s_win_dir
end function

on n_blob_manipulator.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_blob_manipulator.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

