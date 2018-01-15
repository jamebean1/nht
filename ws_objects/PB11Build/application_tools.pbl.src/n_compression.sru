$PBExportHeader$n_compression.sru
forward
global type n_compression from nonvisualobject
end type
end forward

global type n_compression from nonvisualobject
end type
global n_compression n_compression

type prototypes
/* Win32 declarations */

function integer compress  	(ref blob dest, ref long DestLen, ref blob src, long srcLen)	library "zlib.dll"
function integer uncompress	(ref blob dest, ref long DestLen, ref blob src, long srcLen)	library "zlib.dll"

/* Win16 declarations */

function integer compress16  	(ref blob dest, ref long DestLen, ref blob src, long srcLen) alias for compress	library "zlib16.dll"
function integer uncompress16(ref blob dest, ref long DestLen, ref blob src, long srcLen) alias for uncompress	library "zlib16.dll"

end prototypes

type variables
boolean ib_Win32
end variables

forward prototypes
public function integer of_selectfile (ref string as_filename)
public function integer of_compressfile ()
public function integer of_uncompressfile ()
public function integer of_alloc (long al_len, ref blob abl_data)
public function integer of_readfile (string as_filename, ref blob abl_data)
public function integer of_compress (string as_indicator, ref blob abl_data, ref blob abl_res)
public function integer of_uncompress (ref string as_indicator, ref blob abl_data, ref blob abl_res)
public function long of_writefile (string as_filename, ref blob abl_data)
end prototypes

public function integer of_selectfile (ref string as_filename);/*
Function	:	nv_Compression::of_SelectFile
Author	:	Eric-Jan Aling, Cypres Informatisering bv
Date		:	21-09-1998

returns	: 	integer					(1=ok,-1=error)
arg1		: 	string as_FileName 	(FileName of he selected file)

This function selects a filename.

Revision record	
Date		Author		Modification
------	----------	------------------
21-09-98	EALI1			Initial revision
*/


string ls_docname, ls_named
integer li_Value

/* get a filename with the standard dialog box */
li_value = GetFileOpenName("Select File",  &
	+ ls_docname, ls_named )
	
if li_Value <= 0 then return -1

/* return the selected filename */
as_filename = ls_named

return 1
end function

public function integer of_compressfile ();/*
Function	:	nv_Compression::of_compressfile
Author	:	Eric-Jan Aling, Cypres Informatisering bv
Date		:	21-09-1998

returns	: 	integer					(1=ok,-1=error,0=no file selected)

This function selects a file, reads it in, compresses it 
and writes it back.

Revision record	
Date		Author		Modification
------	----------	------------------
21-09-98	EALI1			Initial revision
*/

string ls_filename
blob	lbl_org
blob	lbl_dest

/* select file */
if of_selectfile(ls_filename) > 0 then
	
/* read file */	
	if of_Readfile(ls_Filename,lbl_org) < 0 then return -1

/* compress file */	

	if of_Compress(ls_FileName,lbl_Org,lbl_Dest) < 0 then return -1
	
/* write compressed file */	

	if of_WriteFile( mid(ls_FileName, 1, len(ls_filename) - 3 ) + 'zli',lbl_dest) < 0 then return -1

	return 1
end if
return 0
end function

public function integer of_uncompressfile ();string ls_filename
blob	lbl_org
blob	lbl_dest

/* get filename to uncompress */

if of_selectfile(ls_filename) > 0 then

	/* read filename */
	if of_Readfile(ls_Filename,lbl_org) < 0 then return -1
	
	/* uncompress it */
	if of_unCompress(ls_FileName,lbl_Org,lbl_Dest) < 0 then return -1
	
	/* write it */
	if of_WriteFile(ls_FileName,lbl_dest) < 0 then return -1

	return 1
end if
return 0
end function

public function integer of_alloc (long al_len, ref blob abl_data);/*
Function	:	nv_Compression::of_Alloc
Author	:	Eric-Jan Aling, Cypres Informatisering bv
Date		:	21-09-1998

returns	:	integer				(1=ok, -1=error)
arg1		:	long al_len 		(number of bytes to allocate)
arg2		:	ref blob abl_data (blob to hold the data)

This function allocates the specified amount of memory and 
stores the allocation in a blob variable which is passed
by reference.

Revision record	
Date		Author		Modification
------	----------	------------------
21-09-98	EALI1			Initial revision
*/



SetPointer(HourGlass!)

/* in 32bit mode, we can allocate in one go */

if ib_Win32 then
	
	abl_data = blob(space(al_len))	
	return 1

else
	
/* in 16bit mode, we allocate in chunks of 64K if size is bigger than 60000 bytes */

	if al_len > 60000 then
		blob{65535} lbl_Chunk
		do while true
			abl_data += lbl_Chunk
			if len(abl_data) >= al_len then exit
		loop
		abl_data = blobmid(abl_data,1,al_len)
		return 1
	else
		abl_data = blob(space(al_len))	
		return 1
	end if
	
end if

return 0




end function

public function integer of_readfile (string as_filename, ref blob abl_data);/*
Function	:	nv_Compression::of_ReadFile
Author	:	Eric-Jan Aling, Cypres Informatisering bv
Date		:	21-09-1998

returns	: 	integer					(1=ok,-1=error)
arg1		: 	string as_FileName 	(filename of file to read)
arg2		:	ref blob abl_data		(blob to hold the filedata)

This function reads in a file with given filename. The data is stored
in the blob argument.

Revision record	
Date		Author		Modification
------	----------	------------------
21-09-98	EALI1			Initial revision
*/

SetPointer(HourGlass!)

blob lbl_temp
long ll_file

/* open the file */
ll_file = fileopen(as_filename,streammode!)

if ll_File <= 0 then
	messagebox('Error reading file',as_filename)
	return -1
end if

/* read the whole file */
do while fileread(ll_file,lbl_temp) > 0 
	abl_data += lbl_temp
loop

fileclose(ll_file)

/* return the binair data */
return 1
end function

public function integer of_compress (string as_indicator, ref blob abl_data, ref blob abl_res);/*
Function	:	nv_Compression::of_compress
Author	:	Eric-Jan Aling, Cypres Informatisering bv
Date		:	21-09-1998

returns	: 	integer					(1=ok,-1=error)
arg1		: 	string as_Indicator 	(indicator to indicate the data)
arg2		:	ref blob abl_data		(source data)
arg3		:	ref blob abl_res		(compressed destination data)

This function compresses the blob abl_data and returns the compressed blob with the indicator.

Revision record	
Date		Author		Modification
------	----------	------------------
21-09-98	EALI1			Initial revision
*/


SetPointer(HourGlass!)

/* 32bit variables */

long	ll_OrigLen
blob	lbl_Temp
long	ll_DestLen
long	ll_SrcLen
integer	li_ret
blob	lbl_Src

/* 16bit variables */

blob	lbl_Temp16[]
long	ll_Segments
long	ll_Segment
long	ll_begin
long	ll_DestLen16[]
long	ll_Chunk = 60000

/* in 32bit mode, we can compress in 1 chunk */



if ib_Win32 then
	If Not FileExists("zlib.dll") Then
		abl_res = abl_data
		Return -1
	End If
	ll_OrigLen 	= len(abl_data)
	ll_Srclen	= ll_OrigLen
	ll_DestLen	= ll_SrcLen + (ll_SrcLen*0.01) + 12

	/* Allocate memory for the compress process */
	
	of_alloc(ll_DestLen,lbl_Temp)
	li_Ret 		= compress( lbl_Temp, ll_DestLen, abl_Data, ll_srcLen)
	
	if li_ret <> 0 then 
		messagebox('Error compressing', li_ret)
		return -1
	end if

	/* Allocate memory for the 'prefix'*/
	
	of_Alloc( 256 + 12, abl_res ) 

	/* first 256 bytes store the name */
	blobedit(abl_res,1,as_indicator)
	
	/* second 4 bytes store number of chunks (always 1) */
	blobedit(abl_res,256 + 1,1)
	
	/* third 4 bytes store the original length */
	blobedit(abl_res,256 + 5,ll_OrigLen)
	
	/* fourth 4 bytes store the destination length of chunk 1 */
	blobedit(abl_res,256 + 9,ll_DestLen)
	
	/* the add the compressed data */
	abl_res += blobmid(lbl_Temp,1,ll_DestLen)
	
	return 1

else
	If Not FileExists("zlib16.dll") Then
		abl_res = abl_data
		Return -1
	End If

	/* in 16bit mode, we must compress in chunks of 6000 bytes */
	
	ll_OrigLen 	= len(abl_data)
	
	/* calculate the number of chunks */
	ll_Segments = long(ll_OrigLen/ll_Chunk) + 1
	
	/* for each chunk */
	for ll_SegMent = 1 to ll_SegMents
		
		/* calculate the beginning of the chuck and get the chunk data */
		ll_begin 	= ((ll_SegMent - 1) * ll_Chunk ) + 1
		lbl_Src	 	= blobmid(abl_data,ll_begin,ll_Chunk)
		
		/* get the length of the chunck ( can be less than 60000 bytes if it is the last chunk ) */
		ll_Srclen	= len(lbl_Src)
	
		/* calculate the memory needed for the compression process */	
		ll_DestLen16[ll_Segment]	= ll_SrcLen + (ll_SrcLen*0.01) + 12
		of_alloc(ll_DestLen16[ll_Segment], lbl_Temp16[ll_Segment])
	
		/* compress the chunk */	
		li_Ret 		= compress16 (lbl_Temp16[ll_Segment], ll_DestLen16[ll_Segment], lbl_Src, ll_srcLen)
	
		if li_ret <> 0 then 
			messagebox('Error compressing', li_ret)
			return -1
		end if
	
	next
	
	/* we now have compressed the data in chunks */
	
	/* allocate memory for the 'prefix' */
	
	of_Alloc( 256 + (ll_Segments + 2) * 4, abl_res ) 
	
	/* save the indicator */
	blobedit(abl_res,1,as_Indicator)
	
	/* save the number of chunks */
	blobedit(abl_res,256 + 1,ll_Segments)
	
	/* save the original length */
	blobedit(abl_res,256 + 5,ll_OrigLen)
	
	/* for each chunk, save the compressed size */
	for ll_SegMent = 1 to ll_SegMents 
		blobedit(abl_res,256 + 5 + (ll_segment*4),ll_DestLen16[ll_Segment])
	next
	
	/* safe the data */
	for ll_SegMent = 1 to ll_SegMents 
		abl_res += blobmid(lbl_Temp16[ll_Segment],1,ll_DestLen16[ll_Segment])
	next
	
	/* return the whole */
	return 1

end if
end function

public function integer of_uncompress (ref string as_indicator, ref blob abl_data, ref blob abl_res);/*
Function	:	nv_Compression::of_uncompress
Author	:	Eric-Jan Aling, Cypres Informatisering bv
Date		:	21-09-1998

returns	: 	integer						(1=ok,-1=error)
arg1		: 	ref string as_Indicator (indicator to indicate the data)
arg2		:	ref blob abl_data			(source data)
arg3		:	ref blob abl_res			(compressed destination data)

This function uncompresses the blob abl_data and returns the uncompressed
blob and the indicator through the arguments by reference.

Revision record	
Date		Author		Modification
------	----------	------------------
21-09-98	EALI1			Initial revision
*/


SetPointer(HourGlass!)

/* the function uncompresses the compressed data */

blob 		lbl_result
integer 	li_Ret
blob		lbl_Src
long		ll_SrcLen
long		ll_DestLen
	
/* 16bit variables */

blob		lbl_temp
blob		lbl_data[]
long		ll_begin[]
long		ll_end[]
long		ll_len[]
long		ll_SegMents
long 		ll_SegMent

/* in 32bit mode, we presume we have 1 chunk only  */

if ib_Win32 then
	If Not FileExists("zlib.dll") Then
		abl_res = abl_data
		Return -1
	End If
	/* get the indicator */
	as_indicator	= string(blobmid(abl_data,1,256))
	
	/* get the length of the original */
	ll_DestLen 	= long(blobmid(abl_data,256 + 5,4))
		
	/* allocate memory for the uncompress proces */	
	of_Alloc(ll_DestLen,abl_res)
	lbl_Src 		= blobmid(abl_data,256 + 13)
	ll_Srclen 	= len(lbl_Src)
	
	/* uncompress the comporessed chunk */
	li_Ret 		= uncompress(abl_res,ll_DestLen,lbl_Src,ll_Srclen)
	
	if li_Ret <> 0 then
		messagebox('Error Uncompresssing',li_Ret)
		return -1
	end if
		
	/* return the uncompressed data */		
	return 1

else

	/* in 16bit mode we must determine the chucnk and for each chuck uncompress */
	
	/* get the indicator */
	as_Indicator = string(blobmid(abl_data,1,256))
	
	/* get the number of chunks */
	ll_SegMents = long(blobmid(abl_data,256 + 1,4))
	
	/* for each chunk */
	for ll_SegMent = 1 to ll_SegMents
	
		/* get the size of the chuck */
		ll_len[ll_Segment] = long(blobmid(abl_data,256 + 9 + (ll_Segment - 1) * 4, 4))	

		/* calculate the begin and the end of the chunck in the compressed data */
		if ll_segment > 1 then
			ll_begin[ll_segment] = ll_end[ll_segment - 1] 
		else
			ll_begin[ll_segment] = 256 + 9 + ( ll_segments * 4 ) 
		end if
		ll_end[ll_Segment]		= ll_begin[ll_segment] + ll_len[ll_Segment]
		
	next
		
	/* for each chunk */
	for ll_SegMent = 1 to ll_SegMents
	
		/* segment size is max 64Kb (win3.x limit) */
		ll_DestLen 	= 65535
		
		/* allocate needed memory for uncompress process */
		of_Alloc(ll_DestLen,lbl_temp)
		
		/* get the compressed data */
		lbl_Src 		= blobmid(abl_data,ll_begin[ll_Segment],ll_len[ll_Segment])
		ll_SrcLen 	= len(lbl_Src)
		
		/* uncompress the compressed data */
		li_Ret 		= uncompress16(lbl_temp,ll_DestLen,lbl_Src,ll_SrcLen)
		
		if li_Ret <> 0 then
			messagebox('Error uncompressing',li_Ret)
			return -1
		end if
		
		/* add the uncompressed data to the rest */
		abl_res += blobmid(lbl_temp,1,ll_DestLen)
		
	next
	
	/* return the uncompressed data */
	
	return 1


end if

end function

public function long of_writefile (string as_filename, ref blob abl_data);/*
Function	:	nv_Compression::of_writefile
Author	:	Eric-Jan Aling, Cypres Informatisering bv
Date		:	21-09-1998

returns	: 	integer					(-1=error, >=0 number of bytes written)
arg1		: 	string as_FileName 	(Filename of the file to write)
arg2		:	ref blob abl_data		(source data)

This function writes the contents of the abl_data blob to disk
with the specified filename.

Revision record	
Date		Author		Modification
------	----------	------------------
21-09-98	EALI1			Initial revision
*/

SetPointer(HourGlass!)

long 	ll_file
long 	ll_written
long	ll_tot
long	ll_writ

/* Open or create the file in replace mode */

ll_file = fileopen(as_filename,streammode!,write!,lockwrite!,replace!)


if ll_File <= 0 then
	messagebox('Error writing file',as_filename)
	return -1
end if

/* write the contents to that file */
ll_tot = len(abl_data)
do while true
	
	ll_writ = filewrite(ll_file,blobmid(abl_data,ll_written+1) )
	if ll_writ = 0 then exit
	ll_written += ll_writ
	if ll_Written >= ll_tot then exit

loop

/* don't forget to close the file */
fileclose(ll_file)

/* return the number of bytes written */
return ll_written
end function

on n_compression.create
TriggerEvent( this, "constructor" )
end on

on n_compression.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;environment lenv_Env

GetEnvironment(lenv_Env)

ib_Win32 = not lenv_Env.win16

return 0
end event

