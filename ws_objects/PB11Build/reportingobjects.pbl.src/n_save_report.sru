$PBExportHeader$n_save_report.sru
$PBExportComments$This object supports saving datwindows to a variety of formats such as Excel, PSR, Adobe, etc. It is used within Reporting and Document Generation.
forward
global type n_save_report from nonvisualobject
end type
type uostr_pdfdocinfo from structure within n_save_report
end type
type uostr_pdfinput from structure within n_save_report
end type
end forward

type uostr_PDFDocInfo from structure
	string		title
	string		author
	string		creationDate
	string		creator
	string		producer
	string		subject
	string		keywords
	string		modDate
end type

type uostr_PDFINPUT from structure
	string		outputfilename
	uostr_pdfdocinfo		docinfo
end type

global type n_save_report from nonvisualobject
end type
global n_save_report n_save_report

type prototypes
//Windows NT Function Calls
function int GetWindowsDirectoryA(ref string as_dir, int nSize) library 'kernel32.dll' alias for "GetWindowsDirectoryA;Ansi"
FUNCTION long SendMessageA( ulong hWnd, ulong uMsg, long wParam, REF string Param ) LIBRARY "user32.dll" alias for "SendMessageA;Ansi"

//Windows 3.1x Function Calls
function int GetWindowsDirectory(ref string as_dir, int nSize) library 'kernel.dll' alias for "GetWindowsDirectory;Ansi"

//Windows 32-bit Function Calls
function long GetTempPathA(long nBufferLength,ref string lpBugger) library 'kernel32.dll' alias for "GetTempPathA;Ansi"

//Windows 3.1x Function Calls
function long GetTempPath(long nBufferLength,ref string lpBugger) library 'kernel.dll' alias for "GetTempPath;Ansi"

//SLEEP
SUBROUTINE Sleep(uint cMilliSeconds) LIBRARY "KERNEL32.dll" 
end prototypes

type variables
Protected:
Long il_reportconfigid, il_saved_report_id, il_RprtDcmntTypID, il_DcmntTypID, il_approvaluserid
String is_report_description, is_reportdatawindowtype = '', is_archive_type, is_filename
Boolean ib_distributed = False
Datetime idt_approvaldate

//-----------------------------------------------------------------------------------------------------------------------------------
// Three ways to save a report
//-----------------------------------------------------------------------------------------------------------------------------------
PowerObject idw_data
Blob		iblob_data
String	is_pathname	= ''
String	is_savingtype
Long 		il_dcmntarchvetypid

Private uostr_PDFDocInfo istr_PDFDocInfo
Private uostr_PDFINPUT  istr_PDFINPUT

Constant Long  HWND_BROADCAST = 65535
Constant  Long WM_SETTINGCHANGE = 26
end variables

forward prototypes
public function string of_get_reporttype ()
public function string of_get_reportname ()
public function string of_savereportindefaultformat (long al_rprtdcmnttypid)
public subroutine of_init (string as_pathname, long al_reportconfigid)
public function boolean of_verify_archive_type (string as_archivetype)
public function string of_delete_savedreport (long al_savedreportid)
public function string of_delete_savedreport (long al_savedreportid, boolean ab_allowuserinput)
private function long of_determine_reportconfigid (string as_fileextension)
public function string of_get_archive_type ()
public function long of_get_archivetype (string as_filetype)
public function powerobject of_get_datasource ()
public function string of_get_extension (string as_rightanglefiletype)
public function string of_get_filename ()
public function long of_get_reportdocumenttype ()
private function saveastype of_get_saveastype (string as_rightanglefiletype)
public subroutine of_init (blob ab_data, long al_reportconfigid)
public subroutine of_init (datastore adw_data, long al_reportconfigid)
public subroutine of_init (datawindow adw_data, long al_reportconfigid)
public subroutine of_init (n_report properties)
public subroutine of_init (powerobject adw_data, long al_reportconfigid)
public function long of_get_saved_report_id ()
public function string of_save_report (string as_arguments, string as_delimiter)
public function string of_save_report (string as_savingtype, string as_rightanglefileformat, boolean ab_includecolumnheaders, string as_description, string as_distributionmethod, string as_filepath, long al_reportfolderid, long al_userid, boolean ab_compression, long al_dcmntarchvtypid)
public function string of_save_report (string as_savingtype, string as_rightanglefileformat, boolean ab_includecolumnheaders, string as_description, string as_distributionmethod, string as_filepath, long al_reportfolderid, long al_userid, boolean ab_compression, long al_dcmntarchvtypid, boolean ab_manuallycreated)
public function string of_delete_linked_document (long al_savedreportid)
public function boolean of_update_savedreport (long al_savedreportid, string as_options, string as_delimiter)
public function string of_replace_saved_report (powerobject adw_data, long al_savedreportid)
public function string of_insert_file_as_savedreport (string as_description, string as_filepath, long al_reportfolderid, long al_userid, boolean ab_compression, string as_savingtype)
public function boolean of_save_as_file (powerobject adw_data, ref string as_filename, string as_filetype, boolean ab_includecolumnheaders)
end prototypes

public function string of_get_reporttype ();Return is_reportdatawindowtype
end function

public function string of_get_reportname ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_reportname()
//	Overview:   This will return the name that the report was saved as
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_report_description
end function

public function string of_savereportindefaultformat (long al_rprtdcmnttypid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_default_file()
//	Arguments:  al_rprtdcmnttypid - long that identifies what reportdocumenttypeid we're working with.
//	Overview:   Lookup the default file type and save a file accordingly, then return the file path.
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
long l_DefaultDcmntArchvTypID
string	s_filetype, s_filepath, s_fileextension, s_now
n_blob_manipulator ln_blob_manipulator
n_date_manipulator ln_date_manipulator
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Lookup default archive type for this report document type.
//-----------------------------------------------------------------------------------------------------------------------------------
Select	DefaultDcmntArchvTypID,
			Qualifier,
			ArchiveFileExtension
Into		:l_DefaultDcmntArchvTypID,
			:s_filetype,
			:s_fileextension
From		ReportDocumentType,
			DocumentArchiveType
Where		RprtDcmntTypID = :al_rprtdcmnttypid
And		ReportDocumentType.DefaultDcmntArchvTypID = DocumentArchiveType.DcmntArchvTypID;

ln_blob_manipulator = Create n_blob_manipulator
s_filepath = ln_blob_manipulator.of_determine_filename("")
Destroy ln_blob_manipulator

//s_now = string(ln_date_manipulator.of_now(),"old date format")
s_now = gn_globals.in_string_functions.of_convert_datetime_to_string(ln_date_manipulator.of_now())	//KCS 25499

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine file name, etc.for temporary file.
//-----------------------------------------------------------------------------------------------------------------------------------
this.of_save_report('save to file',s_filetype,True,'Distribution Temp File ' + s_now,'N',s_filepath,0,0,False,l_DefaultDcmntArchvTypID)
Return this.of_Get_FileName()




end function

public subroutine of_init (string as_pathname, long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  as_pathname - the file path
//					al_reportconfigid - the report configuration id that we are saving
//	Overview:   This will set some instance variables
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

is_savingtype		= 'File'
is_pathname			= as_pathname
il_reportconfigid = al_reportconfigid



end subroutine

public function boolean of_verify_archive_type (string as_archivetype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_verify_archive_type()
//	Arguments:  as_archivetype - string qualifier to check for validity
//	Overview:   Verify that the specified archive type is valid for this object.
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Choose Case Upper(as_archivetype)
	Case 	"CSV","CSV,FALSE","DBASE2","DBASE3","DIF","EXCELDATA","EXCELDATA,FALSE","EXCELREPORT","HTML","HTML,FALSE","LOTUS_WK1","LOTUS_WK1,FALSE","PDF","PSR","RAD","RTF", &
			"SQL","TEXT","TEXT,FALSE","WMF","XML","DTN","DOC"
		Return True
	Case Else 
		Return False
End Choose
end function

public function string of_delete_savedreport (long al_savedreportid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_delete_savedreport()
//	Arguments:  al_savedreportid - the savedreportid
//	Overview:   This will attempt to delete a saved report
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return of_delete_savedreport(al_savedreportid, True)
end function

public function string of_delete_savedreport (long al_savedreportid, boolean ab_allowuserinput);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_delete_savedreport()
//	Arguments:  al_savedreportid - the savedreportid
//	Overview:   This will attempt delete a saved report
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_return, ll_blobid
Boolean 	lb_return
String 	ls_blobtype, ls_filepath
Blob 		lblob_blob
n_blob_manipulator ln_blob_manipulator

ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Pop up a messagebox that asks a question
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_allowuserinput Then
	ll_return = gn_globals.in_messagebox.of_messagebox_question ( 'Are you sure that you want to delete this report', YesNo!, 2)
Else 
	ll_return = 1
End If

If ll_return = 1 Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// Get the Blob ID in case it is a file
	//-----------------------------------------------------------------------------------------------------------------------------------
	Select	svdrprtblbobjctid
	Into		:ll_blobid
	From		cusfocus.savedreport
	Where		svdrprtid		= :al_savedreportid;

	//----------------------------------------------------------------------------------------------------------------------------------
	// If the Saved Report doesn't exist return an error
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case SQLCA.SQLCode
		Case 100
			Destroy ln_blob_manipulator					
			Return 'Error:  Saved report (SvdRprtID = ' + String(al_savedreportid) + ' not found.'
		Case -1
			Destroy ln_blob_manipulator					
			Return 'Error:  Could not find saved report in database'
	End Choose

	Select	blbobjctqlfr
	Into		:ls_blobtype
	From		blobobject
	Where		blbobjctid = :ll_blobid;

	If Lower(Trim(ls_blobtype)) = 'report path' Then
		lblob_blob = ln_blob_manipulator.of_retrieve_blob(ll_blobid)
		ls_filepath = String(lblob_blob)

		
		If ab_allowuserinput Then
			//----------------------------------------------------------------------------------------------------------------------------------
			// Pop up a messagebox that asks whether they want to delete the file or not
			//-----------------------------------------------------------------------------------------------------------------------------------
			ll_return = gn_globals.in_messagebox.of_messagebox_question ( 'This report resides on the file system, would you like to delete the associated file (' + ls_filepath + ')', YesNoCancel!, 3)
	
			Choose Case ll_return
				Case 1
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Check to see if the file exists
					//-----------------------------------------------------------------------------------------------------------------------------------
					If Not FileExists(ls_filepath) Then
						ll_return = gn_globals.in_messagebox.of_messagebox_question ( 'The file (' + ls_filepath + ') does not exist, would you like to continue to delete the report from the desktop', YesNo!, 1)
					Else
						//-----------------------------------------------------------------------------------------------------------------------------------
						// Attempt to delete the file
						//-----------------------------------------------------------------------------------------------------------------------------------
						If Not FileDelete(ls_filepath) Then
							ll_return = gn_globals.in_messagebox.of_messagebox_question ( 'Could not delete file (' + ls_filepath + '), would you like to continue to delete the report from the desktop', YesNo!, 1)
						End If
					End If
					
					If ll_return = 2 Then
						Destroy ln_blob_manipulator							
						Return 'Warning:  Could not delete or find file, user choose not to continue'
					End If
				Case 3
					Destroy ln_blob_manipulator							
					Return 'Warning:  User canceled when asked if they wanted to delete the file'
			End Choose
		Else
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Just delete the file.  We don't care if it fails or not.
			//-----------------------------------------------------------------------------------------------------------------------------------
			lb_return = FileDelete(ls_filepath)
		End If
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Delete the saved report
	//-----------------------------------------------------------------------------------------------------------------------------------
	Delete	cusfocus.savedreport
	Where		svdrprtid		= :al_savedreportid;

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Check the SQLCode to see if there was an error
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case SQLCA.SQLCode
		Case 0
			ll_return = ln_blob_manipulator.of_delete_blob(ll_blobid)
			Destroy ln_blob_manipulator
			Return ''
		Case 100
			Destroy ln_blob_manipulator
			Return 'Error:  Saved report (SvdRprtID = ' + String(al_savedreportid) + ' not found.'
		Case Else
			Destroy ln_blob_manipulator
			Return 'Error:  Could not delete Saved Report (SvdRprtID = ' + String(al_savedreportid) + ':  ' + SQLCA.SQLErrText
	End Choose
Else
	Return 'Warning:  User chose not to delete the report'
End If

end function

private function long of_determine_reportconfigid (string as_fileextension);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_determine_reportconfigid()
//	Arguments:  as_fileextension - string that is the file extension we're looking for.
//	Overview:   We have to have a viewer object (ReportConfigID) configured to be able to view the documents once they're linked.
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

long l_reportconfigid

as_fileextension = Right(as_fileextension,3)

//-----------------------------------------------------------------------------------------------------------------------------------
// Based on the file extension, choose the viewer object for the document.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(Trim(as_fileextension))
	Case "psr"
		Select	ReportConfig.rprtcnfgid
		Into		:l_reportconfigid
		From		cusfocus.reportconfig reportconfig
		Where		reportconfig.rprtcnfgnme = "Universal PSR Viewer"
		And		reportconfig.rprtcnfgfldrid = (Select folder.fldrid From cusfocus.folder folder Where folder.fldrnme = 'Architectural Reports');
	Case 'rad','rtf'
		Select	reportconfig.rprtcnfgid
		Into		:l_reportconfigid
		From		cusfocus.reportconfig reportconfig
		Where		reportconfig.rprtcnfgnme = "Universal RTF Viewer"
		And		reportconfig.rprtcnfgfldrid = (Select folder.fldrid From cusfocus.folder folder Where folder.fldrnme = 'Architectural Reports');
	Case Else
		Select	reportconfig.rprtcnfgid
		Into		:l_reportconfigid
		From		cusfocus.reportconfig reportconfig
		Where		reportconfig.rprtcnfgnme = "Universal Document Viewer"
		And		reportconfig.rprtcnfgfldrid = (Select folder.fldrid From cusfocus.folder folder Where folder.fldrnme = 'Architectural Reports');		
End Choose		

Return l_reportconfigid
end function

public function string of_get_archive_type ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_archive_type()
//	Overview:   Returns the type of archive (save to file, save to file and database, save to file and link to database, save to database)
//	Created by:	Joel White
//	History: 	 
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_archive_type
end function

public function long of_get_archivetype (string as_filetype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_archivetype()
//	Arguments:  as_filetype - 
//	Overview:   Get DcmntArchvTypID from the FileQualifier
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//If isnull(il_dcmntarchvetypid) Then
//	SELECT	documentarchivetype.dcmntarchvtypid
//	INTO 		:il_dcmntarchvetypid
//	FROM 		cusfocus.documentarchivetype  documentarchivetype
//	WHERE 	documentarchivetype.qualifier = :as_filetype;
//End If

Return il_dcmntarchvetypid
end function

public function powerobject of_get_datasource ();Return idw_data
end function

public function string of_get_extension (string as_rightanglefiletype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_extension
// Arguments:   as_rightanglefiletype - The right angle defined report type
// Overview:    Save a datawindow specified in the f(x) arguments as whatever type the user specifies
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Save the file as the appropriate type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case upper(Trim(as_rightanglefiletype))
	Case "EXCELDATA", "EXCELREPORT"
		Return 'xls'
	Case "PSR", "DIF", "HTML", "SQL", "WMF"
		Return Left(Lower(Trim(as_rightanglefiletype)), 3)
	Case "CSV", "TEXT"
		Return 'txt'
	Case "DBASE2", "DBASE3"
		Return 'dbf'
	Case "SYLK"
		Return 'syk'
	Case "LOTUS_WKS"
		Return 'wk3'
	Case "LOTUS_WK1"
		Return 'wk1'
	Case "RAD"
		Return "RAD"
	Case "RTF","RICHTEXTRTF"
		Return 'RTF'
	Case "PDF"
		Return 'pdf'
	Case 'XML'
		Return 'xml'
	Case 'DOC'
		Return 'doc'
End Choose

Return 'txt'
end function

public function string of_get_filename ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_filename()
//	Overview:   This will return the filename that the report was archived as
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_filename
end function

public function long of_get_reportdocumenttype ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_reportdocumenttype()
//	Arguments:  NONE
//	Overview:   Return the report document type.
//	Created by:	Joel White
//	History: 	 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsNull(il_rprtdcmnttypid) Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Quick and dirty, get the reportdocumenttype.
	//-----------------------------------------------------------------------------------------------------------------------------------
	Select	rprtdcmnttypid
	Into		:il_RprtDcmntTypID
	From		cusfocus.reportconfig reportconfig
	Where		rprtcnfgid = :il_reportconfigid;
End If

Return il_rprtdcmnttypid
end function

private function saveastype of_get_saveastype (string as_rightanglefiletype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_saveastype
// Arguments:   as_rightanglefiletype - The right angle standard file type
// Overview:    Return the enumerated file saveas type
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Save the file as the appropriate type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case upper(Trim(as_rightanglefiletype))
	Case "EXCELDATA", "EXCELREPORT"
		Return Excel!
	Case "PSR"
		Return PSReport!
	Case "CSV"
		Return CSV!
	Case "DBASE2"
		Return dBASE2!
	Case "DBASE3"
		Return dBASE3!
	Case "DIF"
		Return DIF!
	Case "HTML"
		Return HTMLTable!
	Case "SQL"
		Return SQLInsert!
	Case "SYLK"
		Return SYLK!
	Case "TEXT"
		Return Text!
	Case "LOTUS_WKS"
		Return WKS!
	Case "LOTUS_WK1"
		Return WK1!
	Case "WMF"
		Return WMF!
	Case Else
		Return Text!
End Choose

end function

public subroutine of_init (blob ab_data, long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  adw_data - the datawindow we are acting on
//					al_reportconfigid - the report configuration id that we are saving
//	Overview:   This will set some instance variables
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

is_savingtype		= 'Blob'
iblob_data			= ab_data
il_reportconfigid = al_reportconfigid


end subroutine

public subroutine of_init (datastore adw_data, long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  adw_data - the datawindow we are acting on
//					al_reportconfigid - the report configuration id that we are saving
//	Overview:   This will set some instance variables
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

is_savingtype		= 'Datawindow'
idw_data 			= adw_data
il_reportconfigid = al_reportconfigid

end subroutine

public subroutine of_init (datawindow adw_data, long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  adw_data - the datawindow we are acting on
//					al_reportconfigid - the report configuration id that we are saving
//	Overview:   This will set some instance variables
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

is_savingtype		= 'Datawindow'
idw_data 			= adw_data
il_reportconfigid = al_reportconfigid

end subroutine

public subroutine of_init (n_report properties);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  adw_data - the datawindow we are acting on
//					al_reportconfigid - the report configuration id that we are saving
//	Overview:   This will set some instance variables
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

n_blob_manipulator ln_blob_manipulator
Blob	lblob_data

If Not IsValid(Properties) Then Return

If Lower(Trim(Properties.ReportDocumentType)) = Lower('PowerBuilder Datawindow') Or (Lower(Trim(Properties.ReportDocumentType)) = Lower('DTN Notification') And Properties.ReportType <> 'S') Then
	this.of_init(Properties.Datasource, Properties.RprtCnfgID)
Else
	ln_blob_manipulator = Create n_blob_manipulator
	lblob_data	= ln_blob_manipulator.of_build_blob_from_file(Properties.DocumentName)
	Destroy ln_blob_manipulator
	This.of_init(lblob_data, Properties.RprtCnfgID)
End If
end subroutine

public subroutine of_init (powerobject adw_data, long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  adw_data - the datawindow we are acting on
//					al_reportconfigid - the report configuration id that we are saving
//	Overview:   This will set some instance variables
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

datawindow ldw_temp
datastore lds_temp
n_blob_manipulator ln_blob_manipulator
Blob	lblob_data
UserObject lu_search

If IsValid(adw_data) Then
	Choose Case adw_data.TypeOf()
		Case Datawindow!
			ldw_temp = adw_data
			this.of_init(ldw_temp,al_reportconfigid)
		Case Datastore!
			lds_temp = adw_data
			this.of_init(lds_temp,al_reportconfigid)
		Case UserObject!
			lu_search = adw_data
			If Lower(Trim(lu_search.Dynamic of_get_properties().of_get('ReportDocumentType'))) = Lower('PowerBuilder Datawindow') Or (Lower(Trim(lu_search.Dynamic of_get_properties().of_get('ReportDocumentType'))) = Lower('DTN Notification') And lu_search.Dynamic of_get_properties().of_get('ReportType') <> 'S') Then
				ldw_temp = lu_search.Dynamic of_get_report_dw()
				this.of_init(ldw_temp, al_reportconfigid)
			Else
				ln_blob_manipulator = Create n_blob_manipulator
				lblob_data	= ln_blob_manipulator.of_build_blob_from_file(lu_search.Dynamic of_get_properties().of_get('DocumentName'))
				Destroy ln_blob_manipulator
				This.of_init(lblob_data, al_reportconfigid)
			End If
	End Choose
End If
end subroutine

public function long of_get_saved_report_id ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_saved_report_id
//	Arguments:  NONE
//	Overview:   Return saved report id
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return il_saved_report_id


end function

public function string of_save_report (string as_arguments, string as_delimiter);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_report()
//	Arguments:  as_arguments - a ? delimited string of arguments
//					as_delimiter - a delimeter for the argument string
//	Overview:   Pull out the arguments and 
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_reportconfigid, ll_reportfolderid, ll_index, ll_userid, l_archvtypid
String ls_savetype, ls_description, ls_filepath, ls_fileformat, as_argument[], as_values[], ls_distributionmethod
Boolean lb_includecolumnheaders = True, lb_compression = False, lb_incompatible_archivetype, b_manuallycreated

//n_string_functions ln_string_functions 

gn_globals.in_string_functions.of_parse_arguments(as_arguments, as_delimiter, as_argument[], as_values[])

SetNull(ll_userid)
SetNull(ll_reportfolderid)
SetNull(l_archvtypid)
b_manuallycreated = FALSE

For ll_index = 1 To UpperBound(as_argument[])
	Choose Case Lower(Trim(as_argument[ll_index]))
		Case 'reportfolderid'
			ll_reportfolderid 			= Long(as_values[ll_index])
		Case 'savetype'
			ls_savetype 					= Trim(as_values[ll_index])
		Case 'description'
			ls_description 				= Trim(as_values[ll_index])
		Case 'path'
			ls_filepath 					= Trim(as_values[ll_index])
		Case 'fileformat'
			ls_fileformat 					= Trim(Upper(as_values[ll_index]))
			If Not this.of_verify_archive_type(ls_fileformat) Then
				lb_incompatible_archivetype = True
			Else
				lb_incompatible_archivetype = False
			End If
		Case 'includeheaders'
			lb_includecolumnheaders 	= Not Trim(Lower(as_values[ll_index])) = 'false'
		Case 'distributionmethod'
			ls_distributionmethod = Trim(as_values[ll_index])
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Parse string back into correct ||-delimited string
			//-----------------------------------------------------------------------------------------------------------------------------------
			gn_globals.in_string_functions.of_replace_all(ls_distributionmethod,"|^^^|","||")
			gn_globals.in_string_functions.of_replace_all(ls_distributionmethod,"^^^","=")		
		Case 'userid'
			If IsNumber(as_values[ll_index]) Then
				ll_userid 					= Long(as_values[ll_index])
			End If
		Case 'compression'
			lb_compression 				= Not Trim(Lower(as_values[ll_index])) = 'false'
		Case 'distributed'
			ib_distributed					= Trim(Lower(as_values[ll_index])) = 'true'
		Case 'archvtypid'
			l_archvtypid					= Long(Trim(as_values[ll_index]))
		Case 'documenttype'
			il_DcmntTypID					= Long(Trim(as_values[ll_index]))
		Case 'approvaluser'
			il_approvaluserid				= Long(Trim(as_values[ll_index]))
		Case 'approvaldate'
			idt_approvaldate				= gn_globals.in_string_functions.of_convert_string_to_datetime(Trim(as_values[ll_index]))
		Case 'manualfilecreation'
			If Upper(Trim(as_values[ll_index])) = "Y" Then
				b_manuallycreated = TRUE
			Else
				b_manuallycreated = FALSE
			End If
	End Choose	
Next

If lb_incompatible_archivetype And Not b_manuallycreated Then
	Return "ERROR: UNSUPPORTED ARCHIVE TYPE"
End If

If isNull(l_archvtypid) Then
		l_archvtypid = this.of_get_archivetype(ls_fileformat)
End If

If b_manuallycreated Then
	Return This.of_save_report(ls_savetype, ls_fileformat, lb_includecolumnheaders, ls_description, ls_distributionmethod, ls_filepath, ll_reportfolderid, ll_userid, lb_compression,l_archvtypid,TRUE)
Else
	Return This.of_save_report(ls_savetype, ls_fileformat, lb_includecolumnheaders, ls_description, ls_distributionmethod, ls_filepath, ll_reportfolderid, ll_userid, lb_compression,l_archvtypid)
End If
end function

public function string of_save_report (string as_savingtype, string as_rightanglefileformat, boolean ab_includecolumnheaders, string as_description, string as_distributionmethod, string as_filepath, long al_reportfolderid, long al_userid, boolean ab_compression, long al_dcmntarchvtypid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_report()
//	Arguments:  adw_data - The datawindow
//	Overview:   This will save a report based on a string of arguments
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean 	lb_deletefilewhenfinished = False, lb_return
String 	ls_blobqualifier, ls_reporttype, ls_distributed, ls_fileextension
Long 		ll_blobid, ll_key
Blob 		lblob_blobobject
DateTime	ldt_revisiondate, ldt_distributeddate
//n_string_functions ln_string_functions

n_date_manipulator ln_date_manipulator 
n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Set the saved report id to null because we are going to generate a new one
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SetNull(il_saved_report_id)

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Set the userid to null if it is zero
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If al_userid = 0 Then SetNull(al_userid)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get current date for time-stamping file as well as seeding the revision date.
//-----------------------------------------------------------------------------------------------------------------------------------
ldt_revisiondate = ln_date_manipulator.of_now()

//-------------------------------------------------------------------
// Build the file path
//-------------------------------------------------------------------
If IsNull(as_filepath) Or Len(Trim(as_filepath)) = 0 Then
	//-----------------------------------------------------
	// Call f(x) to get the proper file name
	// and validate to ensure the f(x) worked 
	//----------------------------------------------------
	as_filepath = ln_blob_manipulator.of_determine_filename("TemporaryBlob" + string(ldt_revisiondate,"mm-dd-yyyy-hh.mm.ss.fff") + ".tmp")
	is_pathname = as_filepath
	If Lower(Trim(as_savingtype)) = 'save to file' or Lower(Trim(as_savingtype)) = 'save to file and link to database' Then
		lb_deletefilewhenfinished = False
	Else
		lb_deletefilewhenfinished = True
	End If
Else
	//--------------------------------------------------------------------------
	// Add the Whack if there isn't one and remove restricted file characters
	//--------------------------------------------------------------------------
	as_filepath = Trim(as_filepath)
	If Right(as_filepath, 1) <> '\' Then
		as_filepath = as_filepath + '\'
	End If
	
	gn_globals.in_string_functions.of_replace_all(as_description,"<","")	
	gn_globals.in_string_functions.of_replace_all(as_description,">","")	
	gn_globals.in_string_functions.of_replace_all(as_description,":","")		
	gn_globals.in_string_functions.of_replace_all(as_description,";","")			
	gn_globals.in_string_functions.of_replace_all(as_description,",","")		
	gn_globals.in_string_functions.of_replace_all(as_description,"?","")			
	gn_globals.in_string_functions.of_replace_all(as_description,"/","")				
	
	as_filepath = as_filepath + as_description
End If

//-------------------------------------------------------------------
// Error:  If we could not generate a pathname
//-------------------------------------------------------------------
If as_filepath = '' or IsNull(as_filepath) Then 
	Destroy ln_blob_manipulator
	Return 'Error:  Could not determine temporary file name to save report to database.'
End If

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Save the datawindow as a file
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Choose Case is_savingtype
	Case 'Datawindow'
		lb_return = This.of_save_as_file(idw_data, as_filepath, as_rightanglefileformat, ab_includecolumnheaders)
	Case 'File'
		lb_return = True
		as_filepath = is_pathname
	Case 'Blob'
		//----------------------------------------------------------------------------------------------------------------------------------
		// Save the file as the appropriate type
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_fileextension = This.of_get_extension(as_rightanglefileformat)
		
		If Right(Trim(as_filepath), 4) <> "." + ls_fileextension And Pos(as_filepath, '.') <= 0 Then
			as_filepath = as_filepath + "." + ls_fileextension
		End If

		lb_return = ln_blob_manipulator.of_build_file_from_blob(iblob_data, as_filepath)
End Choose

//-------------------------------------------------------------------
// Error:  If we could not save to file for some reason
//-------------------------------------------------------------------
If Not lb_return Then
	Destroy ln_blob_manipulator
	Return 'Error:  Could not save report to file.'
End If

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Build the blobobject based on how we are saving
//	1.		Build the blob from the file (embedded)
// 2.		Just store the filepath into the blob (linked)
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
is_archive_type = Lower(Trim(as_savingtype))

Choose Case Lower(Trim(as_savingtype))
	Case 'save to database', 'save to file and database'
		If is_savingtype = 'Blob' Then
			lblob_blobobject = iblob_data
		Else
			lblob_blobobject = ln_blob_manipulator.of_build_blob_from_file(as_filepath)
		End If
		
		ls_blobqualifier = 'Report'
	Case 'save to file and link to database'
		lblob_blobobject = Blob(as_filepath)
		ls_blobqualifier = 'Report Path'
	Case Else
		//-------------------------------------------------------------------
		// We are done.  Return an empty string which means no error.
		//-------------------------------------------------------------------
		Destroy ln_blob_manipulator
		Return ''
End Choose

//-------------------------------------------------------------------
// Error:  If we could not create a valid blob object
//-------------------------------------------------------------------
If IsNull(lblob_blobobject) or len(lblob_blobobject) = 0 Then 
	DESTROY ln_blob_manipulator	
	Return  'Error:  The binary object could not be created.'
End If

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Insert the saved report into the database
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ll_blobid = ln_blob_manipulator.of_insert_blob(lblob_blobobject, ls_blobqualifier, ab_compression)

//-------------------------------------------------------------------
// Error:  If we could not insert the blob into the database
//-------------------------------------------------------------------
If ll_blobid <= 0 Or IsNull(ll_blobid) Then
	Destroy ln_blob_manipulator
	Return 'Error:  Could not save the Binary object to the database.'
End If

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Get a new key for the saved report
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
n_update_tools ln_update
ln_update = Create n_update_tools
ll_key = ln_update.of_get_key('SavedReport')
Destroy ln_update

ls_reporttype = Upper(This.of_get_extension(as_rightanglefileformat))

//-----------------------------------------------------
// Error:  Check to see if any non-nullable columns are null
//-----------------------------------------------------
If IsNull(ll_key) Or IsNull(al_reportfolderid) Or IsNull(ll_blobid) Or IsNull(as_description) Or IsNull(il_reportconfigid) Or IsNull(ls_reporttype) Or IsNull(as_distributionmethod) Then
	Destroy ln_blob_manipulator
	Return 'Error:  One or more required columns for SavedReport is Null.'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if SavedReportDescription fields are too long.
//-----------------------------------------------------------------------------------------------------------------------------------
If len(as_description) > 80 Then
	as_description = Left(as_description,80)
End If

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Set Distribution Method to N (None) if there isn't one defined
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(as_distributionmethod)) = 0 Then as_distributionmethod = 'N'

If ib_distributed Then
	ls_distributed = 'Y'
	ldt_distributeddate = ldt_revisiondate
Else
	ls_distributed = 'N'
	SetNull(ldt_distributeddate)
End If

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Insert a record into the saved report table
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO cusfocus.savedreport  
		( svdrprtid,   
		  svdrprtfldrid,   
		  svdrprtblbObjctid,   
		  svdrprtdscrptn,
		  svdrprtrprtcnfgid,
		  svdrprttpe,
		  svdrprtdstrbtnmthd,
		  svdrprtuserid,
		  svdrprtrvsnusrid,
		  svdrprtrvsnlvl,
		  svdrprtrvsndte,
		  svdrprtdstrbtd,
		  dcmntarchvtypid)
VALUES ( :ll_key,   
		  :al_reportfolderid,   
		  :ll_blobid,   
		  :as_description,
		  :il_reportconfigid,
		  :ls_reporttype,
		  :as_distributionmethod,
		  :al_userid,
		  :gn_globals.il_userid,
		  1,
		  :ldt_revisiondate,
		  :ls_distributed,
		  :al_dcmntarchvtypid)
USING sqlca;

//---------------------------------------------------------------------------------------
// Put the description into a instance variable so we can get it with a function later
//---------------------------------------------------------------------------------------
is_report_description = as_description

//-------------------------------------------------------------------
// Error:  If we could not insert the saved report into the database
//-------------------------------------------------------------------
If SQLCA.SQLCode < 0 Then
	Destroy ln_blob_manipulator
	Return 'Error:  Could not insert saved report to database.  ' + SQLCA.SQLErrText
End If

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Delete the file if we need to
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If lb_deletefilewhenfinished Then
	If FileExists(as_filepath) Then
		FileDelete(as_filepath)
	End If 
End If

//-------------------------------------------------------------------
// We are done.  Return an empty string which means no error.
//-------------------------------------------------------------------
il_saved_report_id = ll_key
Destroy ln_blob_manipulator
Return ''
end function

public function string of_save_report (string as_savingtype, string as_rightanglefileformat, boolean ab_includecolumnheaders, string as_description, string as_distributionmethod, string as_filepath, long al_reportfolderid, long al_userid, boolean ab_compression, long al_dcmntarchvtypid, boolean ab_manuallycreated);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_report()
//	Arguments:  adw_data - The datawindow
//	Overview:   This will save a report based on a string of arguments
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean 	lb_deletefilewhenfinished = False, lb_return
String 	ls_blobqualifier, ls_reporttype, ls_distributed
Long 		ll_blobid, ll_key
Blob 		lblob_blobobject
DateTime	ldt_revisiondate, ldt_distributeddate
n_date_manipulator ln_date_manipulator
//n_string_functions ln_string_functions
n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Set the saved report id to null because we are going to generate a new one
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SetNull(il_saved_report_id)

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Set the userid to null if it is zero
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If al_userid = 0 Then SetNull(al_userid)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get current date for time-stamping file as well as seeding the revision date.
//-----------------------------------------------------------------------------------------------------------------------------------
ldt_revisiondate = ln_date_manipulator.of_now()

//-------------------------------------------------------------------
// Build the file path
//-------------------------------------------------------------------
If Not ab_manuallycreated Then
	If IsNull(as_filepath) Or Len(Trim(as_filepath)) = 0 Then
		//-----------------------------------------------------
		// Call f(x) to get the proper file name
		// and validate to ensure the f(x) worked 
		//----------------------------------------------------
		//as_filepath = ln_blob_manipulator.of_determine_filename("TemporaryBlob" + string(ldt_revisiondate,"old date format" + ".tmp"))
		as_filepath = ln_blob_manipulator.of_determine_filename("TemporaryBlob" + gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_revisiondate) + ".tmp")	//KCS 25499
		
		//as_filepath = Left(as_filepath,Pos(as_filepath,"\"))
		If Lower(Trim(as_savingtype)) = 'save to file' or Lower(Trim(as_savingtype)) = 'save to file and link to database' Then
			lb_deletefilewhenfinished = False
		Else
			lb_deletefilewhenfinished = True
		End If
	Else
		//-------------------------------------------------------------------
		// Add the Whack if there isn't one
		//-------------------------------------------------------------------
		as_filepath = Trim(as_filepath)
		If Right(as_filepath, 1) <> '\' Then
			as_filepath = as_filepath + '\'
		End If
		
		as_filepath = as_filepath + as_description
	End If
End If

//-------------------------------------------------------------------
// Error:  If we could not generate a pathname
//-------------------------------------------------------------------
If as_filepath = '' or IsNull(as_filepath) Then 
	Destroy ln_blob_manipulator
	Return 'Error:  Could not determine temporary file name to save report to database.'
End If

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Save the datawindow as a file
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If Not ab_manuallycreated Then
	Choose Case is_savingtype
		Case 'Datawindow'
			lb_return = This.of_save_as_file(idw_data, as_filepath, as_rightanglefileformat, ab_includecolumnheaders)
		Case 'File'
			lb_return = True
			as_filepath = is_pathname
		Case 'Blob'
			lb_return = ln_blob_manipulator.of_build_file_from_blob(iblob_data, as_filepath)
	End Choose
Else
	lb_return = True
End If

//-------------------------------------------------------------------
// Error:  If we could not save to file for some reason
//-------------------------------------------------------------------
If Not lb_return Then
	Destroy ln_blob_manipulator
	Return 'Error:  Could not save report to file.'
End If

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Build the blobobject based on how we are saving
//	1.		Build the blob from the file (embedded)
// 2.		Just store the filepath into the blob (linked)
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
is_archive_type = Lower(Trim(as_savingtype))

Choose Case Lower(Trim(as_savingtype))
	Case 'save to database', 'save to file and database'
		If is_savingtype = 'Blob' Then
			lblob_blobobject = iblob_data
		Else
			lblob_blobobject = ln_blob_manipulator.of_build_blob_from_file(as_filepath)
		End If
		
		ls_blobqualifier = 'Report'
	Case 'save to file and link to database'
		lblob_blobobject = Blob(as_filepath)
		ls_blobqualifier = 'Report Path'
	Case Else
		//-------------------------------------------------------------------
		// We are done.  Return an empty string which means no error.
		//-------------------------------------------------------------------
		Destroy ln_blob_manipulator
		Return ''
End Choose

//-------------------------------------------------------------------
// Error:  If we could not create a valid blob object
//-------------------------------------------------------------------
If IsNull(lblob_blobobject) or len(lblob_blobobject) = 0 Then 
	DESTROY ln_blob_manipulator	
	Return  'Error:  The binary object could not be created.'
End If

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Insert the saved report into the database
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ll_blobid = ln_blob_manipulator.of_insert_blob(lblob_blobobject, ls_blobqualifier, ab_compression)

//-------------------------------------------------------------------
// Error:  If we could not insert the blob into the database
//-------------------------------------------------------------------
If ll_blobid <= 0 Or IsNull(ll_blobid) Then
	Destroy ln_blob_manipulator
	Return 'Error:  Could not save the Binary object to the database.'
End If

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Get a new key for the saved report
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
n_update_tools ln_update
ln_update = Create n_update_tools
ll_key = ln_update.of_get_key('SavedReport')
Destroy ln_update

ls_reporttype = Upper(This.of_get_extension(as_rightanglefileformat))

//-----------------------------------------------------
// Error:  Check to see if any non-nullable columns are null
//-----------------------------------------------------
If IsNull(ll_key) Or IsNull(al_reportfolderid) Or IsNull(ll_blobid) Or IsNull(as_description) Or IsNull(il_reportconfigid) Or IsNull(ls_reporttype) Or IsNull(as_distributionmethod) Then
	Destroy ln_blob_manipulator
	Return 'Error:  One or more required columns for SavedReport is Null.'
End If	

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Set Distribution Method to N (None) if there isn't one defined
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(as_distributionmethod)) = 0 Then as_distributionmethod = 'N'

ldt_revisiondate = ln_date_manipulator.of_now()

If ib_distributed Then
	ls_distributed = 'Y'
	ldt_distributeddate = ldt_revisiondate
Else
	ls_distributed = 'N'
	SetNull(ldt_distributeddate)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if SavedReportDescription fields are too long.
//-----------------------------------------------------------------------------------------------------------------------------------
If len(as_description) > 80 Then
	as_description = Left(as_description,80)
End If

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Insert a record into the saved report table
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO cusfocus.savedreport  
		( svdrprtid,   
		  svdrprtfldrid,   
		  svdrprtblbObjctid,   
		  svdrprtdscrptn,
		  svdrprtrprtcnfgid,
		  svdrprttpe,
		  svdrprtdstrbtnmthd,
		  svdrprtuserid,
		  svdrprtrvsnusrid,
		  svdrprtrvsnlvl,
		  svdrprtrvsndte,
		  svdrprtdstrbtd,
		  dcmntarchvtypid)
VALUES ( :ll_key,   
		  :al_reportfolderid,   
		  :ll_blobid,   
		  :as_description,
		  :il_reportconfigid,
		  :ls_reporttype,
		  :as_distributionmethod,
		  :al_userid,
		  :gn_globals.il_userid,
		  1,
		  :ldt_revisiondate,
		  :ls_distributed,
		  :al_dcmntarchvtypid)
USING sqlca;

//---------------------------------------------------------------------------------------
// Put the description into a instance variable so we can get it with a function later
//---------------------------------------------------------------------------------------
is_report_description = as_description

//-------------------------------------------------------------------
// Error:  If we could not insert the saved report into the database
//-------------------------------------------------------------------
If SQLCA.SQLCode < 0 Then
	Destroy ln_blob_manipulator
	Return 'Error:  Could not insert saved report to database.  ' + SQLCA.SQLErrText
End If



//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Delete the file if we need to
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If lb_deletefilewhenfinished Then
	If FileExists(as_filepath) Then
		FileDelete(as_filepath)
	End If 
End If

//-------------------------------------------------------------------
// We are done.  Return an empty string which means no error.
//-------------------------------------------------------------------
il_saved_report_id = ll_key
Destroy ln_blob_manipulator
Return ''
end function

public function string of_delete_linked_document (long al_savedreportid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_delete_linked_document()
//	Arguments:  al_savedreportid - the savedreportid
//	Overview:   This will attempt to delete a saved report record linking the an event to a Saved Report
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_return, ll_blobid
Boolean 	lb_return
String 	ls_blobtype, ls_filepath
Blob 		lblob_blob
n_blob_manipulator ln_blob_manipulator

ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Get the Blob ID in case it is a file
//-----------------------------------------------------------------------------------------------------------------------------------
Select	svdrprtblbobjctid
Into		:ll_blobid
From		cusfocus.savedreport
Where		svdrprtid		= :al_savedreportid;

//----------------------------------------------------------------------------------------------------------------------------------
// If the Saved Report doesn't exist return an error
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case SQLCA.SQLCode
	Case 100
		Destroy ln_blob_manipulator					
		Return 'Error:  Saved report (SvdRprtID = ' + String(al_savedreportid) + ' not found.'
	Case -1
		Destroy ln_blob_manipulator					
		Return 'Error:  Could not find saved report in database'
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Delete the saved report
//-----------------------------------------------------------------------------------------------------------------------------------
Delete	cusfocus.savedreport
Where		svdrprtid		= :al_savedreportid;

//-----------------------------------------------------------------------------------------------------------------------------------
// Check the SQLCode to see if there was an error
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case SQLCA.SQLCode
	Case 0
		ll_return = ln_blob_manipulator.of_delete_blob(ll_blobid)
		Destroy ln_blob_manipulator
		Return ''
	Case 100
		Destroy ln_blob_manipulator
		Return 'Error:  Saved report (SvdRprtID = ' + String(al_savedreportid) + ' not found.'
	Case Else
		Destroy ln_blob_manipulator
		Return 'Error:  Could not delete Saved Report (SvdRprtID = ' + String(al_savedreportid) + ':  ' + SQLCA.SQLErrText
End Choose

Return ''
end function

public function boolean of_update_savedreport (long al_savedreportid, string as_options, string as_delimiter);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_update_savedreport()
//	Arguments:  as_options - Delimited string of name-value pairs that contain the columns that should be updated.
//					as_delimiter - string that is the delimiter
//	Overview:   Update the specified fields on SavedReport.
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

long i,l_upperbound,l_blobobjectid
string s_args[], s_values[]
blob blb_data
//n_string_functions ln_string_functions
n_blob_manipulator ln_blob_manipulator 
datastore lds_savedreport

//-----------------------------------------------------------------------------------------------------------------------------------
// Check for required arguments
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(al_savedreportid) or al_savedreportid = 0 Then Return False
If IsNull(as_options) or Len(trim(as_options)) =  0 Then Return False
If IsNull(as_delimiter) or Len(trim(as_delimiter)) =  0 Then as_delimiter = '||'

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve datastore with information about the savedreport.
//-----------------------------------------------------------------------------------------------------------------------------------
lds_savedreport = Create Datastore
lds_savedreport.DataObject = 'd_savedreport_info'
lds_savedreport.SetTransObject(SQLCA)
If lds_savedreport.Retrieve(al_savedreportid) <> 1 Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out the array and set the appropriate items for update.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_arguments(as_options,as_delimiter,s_args[],s_values[])
l_upperbound = Min(UpperBound(s_args[]),UpperBound(s_values[]))
For i = 1 to l_upperbound
	Choose Case lower(trim(s_args[i]))
		Case "description"
			lds_savedreport.SetItem(1,"svdrprtdscrptn",trim(s_values[i]))
		Case "reportfolder"
			If IsNumber(trim(s_values[i])) Then
				lds_savedreport.SetItem(1,"svdrprtfldrid",long(trim(s_values[i])))
			End If
		Case "reportpath"
			l_blobobjectid = lds_savedreport.GetItemNumber(1,"svdrprtblbobjctid")
			If Not IsNull(l_blobobjectid) Then
				blb_data = blob(trim(s_values[i]))
				ln_blob_manipulator = Create n_blob_manipulator
				If ln_blob_manipulator.of_update_blob(blb_data,l_blobobjectid,FALSE) = -1 Then Return False
				If IsValid(ln_blob_manipulator) Then Destroy ln_blob_manipulator
			End If
		Case "blobobjectid"
			If IsNumber(trim(s_values[i])) Then
				lds_savedreport.SetItem(1,"svdrprtblbobjctid",long(trim(s_values[i])))
			End If
	End Choose
Next

Return lds_savedreport.Update() = 1
end function

public function string of_replace_saved_report (powerobject adw_data, long al_savedreportid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_report()
//	Arguments:  adw_data - The datawindow to save
//					al_savedreportid - The saved report ID
//	Overview:   This will archive a report over its previous archive
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_blobobjectid, ll_newblobobjectid, ll_folderid
String ls_savedreporttype, ls_blobobjectqualifier, ls_blobcompressiontype, ls_filename
DateTime ldt_getdate
n_blob_manipulator ln_blob_manipulator
Blob lblob_reportblob 
Boolean lb_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the saved report id is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If al_savedreportid <= 0 Or IsNull(al_savedreportid) Then
	Return 'Did not receive a valid saved report id'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the datawindow is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(adw_data) Then
	Return 'Did not receive a valid report datawindow'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the datawindow has a valid dataobject.  This doesn't make sense.  Superfluous validation.
//-----------------------------------------------------------------------------------------------------------------------------------
//If Not adw_data.Dynamic RowCount() > 0 Then
//	Return 'The report datawindow did not have any rows.'
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the saved report information
//-----------------------------------------------------------------------------------------------------------------------------------
Select	svdrprtblbobjctid,
			svdrprttpe,
			svdrprtfldrid
Into		:ll_blobobjectid,
			:ls_savedreporttype,
			:ll_folderid
From		cusfocus.savedreport savedreport
Where		svdrprtID 		= :al_savedreportid;

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to make sure the user has rights to update the report
//-----------------------------------------------------------------------------------------------------------------------------------
//If Not gn_globals.in_security.of_get_folder_security(ll_folderid, 'report') >= 2 Then
//	Return 'You do not have rights to update reports that are archived to this report folder'
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the blob object information
//-----------------------------------------------------------------------------------------------------------------------------------
Select	blbobjctqlfr,
			blbobjctcmprssntpe
Into		:ls_blobobjectqualifier,
			:ls_blobcompressiontype
From		blobobject
Where		blbobjctid 				= :ll_blobobjectid;

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the blob object id is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_blobobjectid <= 0 Or IsNull(ll_blobobjectid) Or Len(Trim(ls_blobobjectqualifier)) = 0 Or IsNull(ls_blobobjectqualifier) Then
	Return 'The saved report does not have a valid blob object'
End If
			
//-----------------------------------------------------------------------------------------------------------------------------------
// Check the saved report type before saving
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Upper(Trim(ls_savedreporttype))
	Case 'RAD'
		ln_blob_manipulator = Create n_blob_manipulator
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Determine whether the report is stored in the database or on the file system
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case Lower(Trim(ls_blobobjectqualifier))
			Case 'report'
				ls_filename = ln_blob_manipulator.of_determine_filename('temp.rad')
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// If we could not determine the file name, return
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Pos(ls_filename, ':') = 0 Then
					Destroy ln_blob_manipulator
					Return 'Could not determine temporary directory to save file'
				End If
			Case 'report path'
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Retrieve the file name for the report
				//-----------------------------------------------------------------------------------------------------------------------------------
				lblob_reportblob 	= ln_blob_manipulator.of_retrieve_blob(ll_blobobjectid)

				//-----------------------------------------------------------------------------------------------------------------------------------
				// If we could not determine the file name, return
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Not Len(lblob_reportblob) > 0 Then
					Destroy ln_blob_manipulator					
					Return 'Could not find a valid filename for this report that is saved on the filesystem'
				End If
				
				ls_filename 		= String(lblob_reportblob)
				
				lblob_reportblob = ln_blob_manipulator.of_build_blob_from_file(ls_filename)
		End Choose

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Save this datawindow to a file
		//-----------------------------------------------------------------------------------------------------------------------------------
		lb_return = This.of_save_as_file(adw_data, ls_filename, 'RAD', True)		

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Update the report differently based on whether it is on the database or the file system
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case Lower(Trim(ls_blobobjectqualifier))
			Case 'report path'
				//-----------------------------------------------------------------------------------------------------------------------------------
				// If we failed creating the file, attempt to restore the original file
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Not lb_return Then
					ln_blob_manipulator.of_build_file_from_blob(lblob_reportblob, ls_filename)
					Destroy ln_blob_manipulator
					Return 'Could not save binary object to file in order to save the report, recovering previous file'
				End If
				
			Case 'report'
				//-----------------------------------------------------------------------------------------------------------------------------------
				// If we failed creating the file, attempt to restore the original file
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Not lb_return Then
					Destroy ln_blob_manipulator
					Return 'Could not save binary object to file in order to save the report'
				End If				
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Create a blob and insert it into the database
				//-----------------------------------------------------------------------------------------------------------------------------------
				lblob_reportblob = ln_blob_manipulator.of_build_blob_from_file(ls_filename)

				//-----------------------------------------------------------------------------------------------------------------------------------
				// Delete the temporary file (we don't care if this fails)
				//-----------------------------------------------------------------------------------------------------------------------------------
				FileDelete(ls_filename)

				//-----------------------------------------------------------------------------------------------------------------------------------
				// Create a blob and insert it into the database
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Not Len(lblob_reportblob) > 0 Then
					Destroy ln_blob_manipulator					
					Return 'Could not create binary object from file to save the report'
				End If

				//-----------------------------------------------------------------------------------------------------------------------------------
				// Insert the binary object into the database
				//-----------------------------------------------------------------------------------------------------------------------------------
				ll_newblobobjectid = ln_blob_manipulator.of_insert_blob(lblob_reportblob, ls_blobobjectqualifier, Lower(Trim(ls_blobcompressiontype)) <> 'none')
				
				If Not ll_newblobobjectid > 0 Or IsNull(ll_newblobobjectid) Then
					Destroy ln_blob_manipulator
					Return 'Could not insert binary object into database to save report'
				End If
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Update the saved report with the new blobobject id
				//-----------------------------------------------------------------------------------------------------------------------------------
				Update	cusfocus.savedreport
				Set		svdrprtBlbObjctID = :ll_newblobobjectid
				Where		svdrprtID			= :al_savedreportid;

				//-----------------------------------------------------------------------------------------------------------------------------------
				// Update the saved report with the new blobobject id
				//-----------------------------------------------------------------------------------------------------------------------------------
				If SQLCA.SQLCode < 0 Then
					Destroy ln_blob_manipulator
					Return 'Could not update saved report with new binary object ID'
				End If

				//-----------------------------------------------------------------------------------------------------------------------------------
				// Delete the old blob object (we don't care if this fails)
				//-----------------------------------------------------------------------------------------------------------------------------------
				ln_blob_manipulator.of_delete_blob(ll_blobobjectid)
		End Choose

		Destroy ln_blob_manipulator
	Case Else
		Return 'The saved report type ' + ls_savedreporttype + ' is not yet supported for saving over a current report'
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the server datetime for the revision date
//-----------------------------------------------------------------------------------------------------------------------------------
n_date_manipulator ln_date_manipulator
ldt_getdate = ln_date_manipulator.of_now()

//-----------------------------------------------------------------------------------------------------------------------------------
// Update the revision level and the revision date of the saved report and the user
//-----------------------------------------------------------------------------------------------------------------------------------
Update	cusfocus.savedreport
Set		svdrprtrvsnlvl 	= svdrprtRvsnLvl + 1,
			svdrprtrvsndte 	= :ldt_getdate,
			svdrprtrvsnusrid	= :gn_globals.il_userid
Where		svdrprtid		= :al_savedreportid;

//-----------------------------------------------------------------------------------------------------------------------------------
// Update the saved report with the new blobobject id
//-----------------------------------------------------------------------------------------------------------------------------------
If SQLCA.SQLCode < 0 Then
	Return 'Could not update revision level and revision user, the report is saved however'
End If

Return ''
end function

public function string of_insert_file_as_savedreport (string as_description, string as_filepath, long al_reportfolderid, long al_userid, boolean ab_compression, string as_savingtype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_report()
//	Arguments:  adw_data - The datawindow
//	Overview:   This will save a report based on a string of arguments
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean 	lb_deletefilewhenfinished = False, lb_return
String 	ls_blobqualifier, ls_reporttype, ls_distributed, as_distributionmethod
Long 		ll_blobid, ll_key, al_dcmntarchvtypid
Blob 		lblob_blobobject
DateTime	ldt_revisiondate, ldt_distributeddate
n_date_manipulator ln_date_manipulator
//n_string_functions ln_string_functions
n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//-----------------------------------------------------------------------------------------------------------------------------------
// Set initial values for fields that are irrelevant to Saved Reports generated from files.
//-----------------------------------------------------------------------------------------------------------------------------------
as_distributionmethod = "N"
SetNull(al_dcmntarchvtypid)

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Set the saved report id to null because we are going to generate a new one
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SetNull(il_saved_report_id)

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Set the userid to null if it is zero
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If al_userid = 0 Then SetNull(al_userid)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get current date for time-stamping file as well as seeding the revision date.
//-----------------------------------------------------------------------------------------------------------------------------------
ldt_revisiondate = ln_date_manipulator.of_now()

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine report config ID to associate this report with.
//-----------------------------------------------------------------------------------------------------------------------------------
il_reportconfigid = this.of_determine_reportconfigid(as_filepath)

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Build the blobobject based on how we are saving
//	1.		Build the blob from the file (embedded)
// 2.		Just store the filepath into the blob (linked)
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
is_archive_type = Lower(Trim(as_savingtype))

Choose Case Lower(Trim(as_savingtype))
	Case 'save to database', 'save to file and database'
		lblob_blobobject = ln_blob_manipulator.of_build_blob_from_file(as_filepath)
		ls_blobqualifier = 'Report'
		lb_deletefilewhenfinished = False
	Case 'save to file and link to database'
		lblob_blobobject = Blob(as_filepath)
		ls_blobqualifier = 'Report Path'
	Case Else
		//-------------------------------------------------------------------
		// We are done.  Return an empty string which means no error.
		//-------------------------------------------------------------------
		Destroy ln_blob_manipulator
		Return ''
End Choose

//-------------------------------------------------------------------
// Error:  If we could not create a valid blob object
//-------------------------------------------------------------------
If IsNull(lblob_blobobject) or len(lblob_blobobject) = 0 Then 
	DESTROY ln_blob_manipulator	
	Return  'Error:  The binary object could not be created.'
End If

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Insert the saved report into the database
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ll_blobid = ln_blob_manipulator.of_insert_blob(lblob_blobobject, ls_blobqualifier, ab_compression)

//-------------------------------------------------------------------
// Error:  If we could not insert the blob into the database
//-------------------------------------------------------------------
If ll_blobid <= 0 Or IsNull(ll_blobid) Then
	Destroy ln_blob_manipulator
	Return 'Error:  Could not save the Binary object to the database.'
End If

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Get a new key for the saved report
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
n_update_tools ln_update
ln_update = Create n_update_tools
ll_key = ln_update.of_get_key('SavedReport')
Destroy ln_update

ls_reporttype = Right(as_filepath,3)

//-----------------------------------------------------
// Error:  Check to see if any non-nullable columns are null
//-----------------------------------------------------
If IsNull(ll_key) Or IsNull(al_reportfolderid) Or IsNull(ll_blobid) Or IsNull(as_description) Or IsNull(il_reportconfigid) Or IsNull(ls_reporttype) Or IsNull(as_distributionmethod) Then
	Destroy ln_blob_manipulator
	Return 'Error:  One or more required columns for SavedReport is Null.'
End If	

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Set Distribution Method to N (None) if there isn't one defined
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(as_distributionmethod)) = 0 Then as_distributionmethod = 'N'

ldt_revisiondate = ln_date_manipulator.of_now()

If ib_distributed Then
	ls_distributed = 'Y'
	ldt_distributeddate = ldt_revisiondate
Else
	ls_distributed = 'N'
	SetNull(ldt_distributeddate)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if SavedReportDescription fields are too long.
//-----------------------------------------------------------------------------------------------------------------------------------
If len(as_description) > 80 Then
	as_description = Left(as_description,80)
End If

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Insert a record into the saved report table
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO cusfocus.savedreport  
		( svdrprtid,   
		  svdrprtfldrid,   
		  svdrprtblbObjctid,   
		  svdrprtdscrptn,
		  svdrprtrprtcnfgid,
		  svdrprttpe,
		  svdrprtdstrbtnmthd,
		  svdrprtuserid,
		  svdrprtrvsnusrid,
		  svdrprtrvsnlvl,
		  svdrprtrvsndte,
		  svdrprtdstrbtd,
		  dcmntarchvtypid)
VALUES ( :ll_key,   
		  :al_reportfolderid,   
		  :ll_blobid,   
		  :as_description,
		  :il_reportconfigid,
		  :ls_reporttype,
		  :as_distributionmethod,
		  :al_userid,
		  :gn_globals.il_userid,
		  1,
		  :ldt_revisiondate,
		  :ls_distributed,
		  :al_dcmntarchvtypid)
USING sqlca;

//---------------------------------------------------------------------------------------
// Put the description into a instance variable so we can get it with a function later
//---------------------------------------------------------------------------------------
is_report_description = as_description

//-------------------------------------------------------------------
// Error:  If we could not insert the saved report into the database
//-------------------------------------------------------------------
If SQLCA.SQLCode < 0 Then
	Destroy ln_blob_manipulator
	Return 'Error:  Could not insert saved report to database.  ' + SQLCA.SQLErrText
End If

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Delete the file if we need to
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If lb_deletefilewhenfinished Then
	If FileExists(as_filepath) Then
		FileDelete(as_filepath)
	End If 
End If

//-------------------------------------------------------------------
// We are done.  Return an empty string which means no error.
//-------------------------------------------------------------------
il_saved_report_id = ll_key
Destroy ln_blob_manipulator
Return ''
end function

public function boolean of_save_as_file (powerobject adw_data, ref string as_filename, string as_filetype, boolean ab_includecolumnheaders);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_save_as_file
// Arguments:   adw_data - Pointer to datawindow to know which datawindow to do the saveas on
//					 as_filename - the filename to save
//					 as_filetype - the filetype (defined by the listbox on the save report dialog)
//					 ab_includecolumnheaders - Boolean that says whether to save the headers or not (does not affect all file types)
// Overview:    Save a datawindow specified in the f(x) arguments as whatever type the user specifies
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
//	local variables used in script
//-----------------------------------------------------
long ll_return, l_printjob, ll_position
string ls_fileextension,ls_rtf_header,ls_rtf_detail,ls_rtf_footer, ls_return, s_rtffilename, s_ref, s_orientation, s_deviceinfo, s_PDFdirectory
string s_printername, s_old_printer_setup,s_old_printer_port,s_old_printer_driver, s_regkey, s_regvalue, s_regvaluename,s_printer_info, ls_xml_string, ls_dtd_filename, ls_dtd_string
saveastype lenum_saveastype
window lw_rtewindow
RichTextEdit lrte_richtext
powerobject lany_temp
//n_string_functions ln_string_manipulator
n_export_datawindow_wysiwyg ln_export_datawindow_wysiwyg
n_blob_manipulator ln_blob_manipulator
//n_convert_datawindow_to_xml ln_convert_datawindow_to_xml
//n_powerprn32 ln_powerprn32
n_win32_api_calls ln_win32_api_calls
n_registry ln_registry
//n_pdf_generator ln_pdf_generator

//----------------------------------------------------------------------------------------------------------------------------------
// Save the file as the appropriate type
//-----------------------------------------------------------------------------------------------------------------------------------
lenum_saveastype = This.of_get_saveastype(as_filetype)
ls_fileextension = This.of_get_extension(as_filetype)

If IsNumber(adw_data. Dynamic Describe("DataWindow.RichText.BackColor")) And Upper(as_filetype) = 'RTF' Then
	as_filetype = 'RichTextRTF'
End If

//-------------------------------------------------------------------
// Add the extension if there isn't a user defined extension already
// CHANGE: Add a timestamp to the filename to fix the problem of the files
// steping on each other, and also deleting files before they're ready
// to be deleted.  See RAID #31388 - NWP
//-------------------------------------------------------------------
If Right(Trim(as_filename), 4) <> "." + ls_fileextension Then
	as_filename = as_filename + " " + String(DateTime(Today(), Now()), "mm-dd-yyyy-hh-mm-ss")
	as_filename = as_filename + "." + ls_fileextension
End If

Choose Case upper(Trim(as_filetype))
	Case "EXCELREPORT"
		//----------------------------------------------------------------------------------------------------------------------------------
		//	Special Logic for Excel Report which saves display values instead of data values
		//	in a datawindow
		//----------------------------------------------------------------------------------------------------------------------------------
		ln_export_datawindow_wysiwyg = Create n_export_datawindow_wysiwyg
		ln_export_datawindow_wysiwyg.of_init_batch(adw_data, as_filename)
		ll_return = ln_export_datawindow_wysiwyg.of_export()
		Destroy ln_export_datawindow_wysiwyg
	Case "RTF"
//		n_rtf_export_datawindow ln_rtf_export_datawindow
//		ls_return = ln_rtf_export_datawindow.of_dwExport_RTF(idw_data, as_filename, TRUE)
//		If ls_return = '' Then
//			ll_return = 1
//		Else 
//			ll_return = 0
//		End If
	Case 'RICHTEXTRTF'
		//lany_temp = idw_data.Event Dynamic ue_get_richtextedit()
		//If IsValid(lany_temp) Then
		//	lrte_richtext = lany_temp
		//Else
			Open(lw_rtewindow)
			//lw_rtewindow.Visible = FALSE
			lw_rtewindow.OpenUserObject(lrte_richtext,12,17)
			
			If Not IsValid(lrte_richtext) Then 
				close(lw_rtewindow)
				Return FALSE
			End If
		//End If
			
		ls_rtf_header = adw_data.Dynamic CopyRtf(False,Header!)
		ls_rtf_detail = adw_data.Dynamic CopyRtf(False,Detail!)
		ls_rtf_footer = adw_data.Dynamic CopyRtf(False,Footer!)
		
		lrte_richtext.SelectTextAll(Header!)
		lrte_richtext.Clear()
		lrte_richtext.SelectTextAll(Detail!)
		lrte_richtext.Clear()
		lrte_richtext.SelectTextAll(Footer!)
		lrte_richtext.Clear()
		
		If Len(Trim(ls_rtf_header)) > 0 Then
			lrte_richtext.PasteRTF(ls_rtf_header, Header!)
		End If
		
		If Len(Trim(ls_rtf_detail)) > 0 Then
			lrte_richtext.PasteRTF(ls_rtf_detail, Detail!)
		End If
		
		If Len(Trim(ls_rtf_footer)) > 0 Then
			lrte_richtext.PasteRTF(ls_rtf_footer, Footer!)
		End If
		
		ll_return = lrte_richtext.SaveDocument(as_filename, FileTypeRichText!)
		
		close(lw_rtewindow)
		
	Case 'RAD'
		long l_pos
		//----------------------------------------------------------------------------------------------------------------------------------
		//	Save report to the file system
		//----------------------------------------------------------------------------------------------------------------------------------
		If IsNumber(adw_data.Dynamic Describe("DataWindow.RichText.BackColor")) Then
			adw_data.event dynamic ue_notify('pagenumber','')
			ls_rtf_header = adw_data.Dynamic CopyRtf(False,Header!)
			ls_rtf_detail = adw_data.Dynamic CopyRtf(False,Detail!)
			ls_rtf_footer = adw_data.Dynamic CopyRtf(False,Footer!)
			ln_blob_manipulator = CREATE n_blob_manipulator
			ln_blob_manipulator.of_build_file_from_blob(blob(ls_rtf_header + "||" + ls_rtf_detail + "||" + ls_rtf_footer),as_filename)
			Destroy ln_blob_manipulator
			RETURN TRUE
		Else
			Return False
		End If
	Case 'XML'
		//ln_convert_datawindow_to_xml = Create n_convert_datawindow_to_xml
		//ls_xml_string = ln_convert_datawindow_to_xml.of_get_xml(adw_data, as_filename)
		//Destroy ln_convert_datawindow_to_xml
		RETURN FileExists(as_filename)

	Case 'PDF'
	//	ln_pdf_generator = Create n_pdf_generator
	//	ln_pdf_generator.of_create_pdf(adw_data, as_filename)
	//	Destroy ln_pdf_generator
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the print worked and created the pdf file, then we're successful. Otherwise, we're not.
		//-----------------------------------------------------------------------------------------------------------------------------------
		is_filename = as_filename
		Return FileExists(as_filename)
	Case Else
		ll_return = adw_data.Dynamic SaveAs(as_filename, lenum_saveastype, ab_includecolumnheaders)
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Set filename and return appropriately
//-----------------------------------------------------------------------------------------------------------------------------------
is_filename = as_filename
Return ll_return > 0
end function

on n_save_report.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_save_report.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;SetNull(il_rprtdcmnttypid)
SetNull(il_dcmntarchvetypid)
SetNull(il_dcmnttypid)
SetNull(il_approvaluserid)
SetNull(idt_approvaldate)

end event

