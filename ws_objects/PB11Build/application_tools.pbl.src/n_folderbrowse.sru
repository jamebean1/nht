$PBExportHeader$n_folderbrowse.sru
$PBExportComments$Object that allows you to browse for a folder without having to pick an actual file name. It uses the windows standard folder browser as well. GLH
forward
global type n_folderbrowse from nonvisualobject
end type
end forward

type shitemid from structure
	unsignedint		cb
	character		abid
end type

type itemidlist from structure
	shitemid		mkid
end type

type browseinfo from structure
	unsignedlong		howner
	unsignedlong		pidlroot
	string		pszdisplayname
	string		lpsztitle
	unsignedint		ulflags
	unsignedlong		lpfn
	long		lparam
	integer		iimage
end type

global type n_folderbrowse from nonvisualobject
end type
global n_folderbrowse n_folderbrowse

type prototypes
Protected:
Function unsignedlong SHGetPathFromIDListA( unsignedlong pidl, ref string pszPath) Library 'shell32' alias for "SHGetPathFromIDListA;Ansi"
Function unsignedlong SHBrowseForFolderA( browseinfo lpbrowseinfo ) Library 'shell32' alias for "SHBrowseForFolderA;Ansi"
Subroutine CoTaskMemFree(ulong idlist) Library 'ole32'
end prototypes

type variables
Protected:
unsignedLong BIF_RETURNONLYFSDIRS =  1
end variables

forward prototypes
public function string of_browseforfolder (window awi_parent, string as_caption)
public function string of_browseforfolder (window awi_parent, string as_caption)
end prototypes

public function string of_browseforfolder (window awi_parent, string as_caption);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_browseforfolder
//	Arguments:  awi_parent - Parent window
//					as_caption - title to display in the browse for folder dialog title bar
//	Overview:   Invokes the windows API folder chooser dialog to allow users to select a folder and returns the path that they selected.
//					I believe that the folder chooser will only allow them to select folders for which they have full security because
//					of the flag setting of bif_ReturnOnlyFSDirs.
//	Created by:	Gary Howard
//	History: 	8/12/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
browseinfo lstr_bi
itemidlist lstr_idl
unsignedlong ll_pidl
unsignedlong ll_r
Integer li_pos
String ls_Path
unsignedlong ll_Null

SetNull( ll_Null )

//-----------------------------------------------------------------------------------------------------------------------------------
// Initialize structure with necessary values.
//-----------------------------------------------------------------------------------------------------------------------------------
lstr_bi.hOwner = Handle( awi_Parent )
lstr_bi.pidlRoot = 0
lstr_bi.lpszTitle = as_caption
lstr_bi.ulFlags = bif_ReturnOnlyFSDirs
lstr_bi.pszDisplayName = Space( 255 )
lstr_bi.lpfn = ll_Null

//-----------------------------------------------------------------------------------------------------------------------------------
// Pop the folder chooser dialog
//-----------------------------------------------------------------------------------------------------------------------------------
ll_pidl = SHBrowseForFolderA( lstr_bi )

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the path the user selected
//-----------------------------------------------------------------------------------------------------------------------------------
ls_Path = Space( 255 )
ll_R = SHGetPathFromIDListA( ll_pidl, ls_Path )

//-----------------------------------------------------------------------------------------------------------------------------------
// Free up Memory associated with the dialog
//-----------------------------------------------------------------------------------------------------------------------------------
CoTaskMemFree( ll_pidl )

RETURN ls_Path
end function

on n_folderbrowse.create
TriggerEvent( this, "constructor" )
end on

on n_folderbrowse.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;
/********************************************************************
	nca_FolderBrowse: Display a folder selection dialog. <EXCLUDE>

	<OBJECT>	Access the win32 API and open the Browse For Folder
				Dialog. Then return the name of the folder selected.
				</OBJECT>

	<USAGE>	nca_browseforfolder lnca_BFF
	
				ls_Folder = lnca_BFF.BrowseForFolder( parent, 'Pick folder' )
				</USAGE>

	<AUTHOR>	<A HREF="mailto:khowe@pbdr.com">Ken Howe</A>

	  Date	Ref	Author			Comments
	07/16/98	1		Ken Howe			First Version
	08/24/98	1.1	Matthew Royle	Changed to work with PB5.0
	06/03/99 1.2	Ken Howe			Added CoTaskMemFree, based on a
											Discussion on the PB News group and
											also this ise used in many VB examples.
********************************************************************/
// This is a code example:
/*
nva_folderbrowse lnca_bff
String ls_A

ls_A = lnca_BFF.BrowseForFolder( parent, 'pick your folder' )
MessageBox( 'You Picked', ls_A )
*/

end event

