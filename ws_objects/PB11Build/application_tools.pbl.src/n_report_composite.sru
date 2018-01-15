$PBExportHeader$n_report_composite.sru
forward
global type n_report_composite from nonvisualobject
end type
end forward

global type n_report_composite from nonvisualobject
end type
global n_report_composite n_report_composite

type variables
	Public n_dao_compositereportconfiguser in_dao_compositereportconfiguser
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// View Types
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public Constant		String	Tiled 		= 'tiled'
	Public Constant		String	Vertical 	= 'vertical'
	Public Constant		String	Horizontal 	= 'horizontal'
	Public Constant		String	Cascaded		= 'cascaded'
	Public Constant		String	Tabbed 		= 'tabbed'
	Public Constant		String	Layered		= 'layered'
	
	Public ProtectedWrite	Boolean	IsInitialized
	Public ProtectedWrite	Boolean	IsCompositeReport

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	Long		RprtCnfgID
	Public ProtectedWrite	Long		CompositeReportID
	Public ProtectedWrite	Long		FolderID
	Public ProtectedWrite	Long		ReportDatabaseID
	Public ProtectedWrite	Long		CriteriaDataObjectBlobObjectID
	Public ProtectedWrite	Long		HelpID
	Public ProtectedWrite	Long		UserID
	Public ProtectedWrite	Long		ReportDefaultID
	Public ProtectedWrite	String	Name
	Public ProtectedWrite	String	Description
	Public ProtectedWrite	String	DisplayObjectIcon

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Document Generation Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	Boolean	TrackStatistics

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Object Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	String	CriteriaUserObject
	Public ProtectedWrite	String	CriteriaDAOObject
	Public ProtectedWrite	String	CriteriaType
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Miscellaneous Reporting Options
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	Boolean	IsDefaultShowCriteria
	Public ProtectedWrite	Boolean	IsAutoRetrieve
	Public ProtectedWrite	Boolean	IsImportedCriteriaDataObject
	Public ProtectedWrite	Boolean	IsBatchMode
	Public ProtectedWrite	Boolean	AllowAddingToDesktops
	Public ProtectedWrite	Boolean	AllowClosing = True
	Public ProtectedWrite	Boolean	AllowRetrieve
	Public ProtectedWrite	Boolean	AllowCriteria

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Service Options
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	Boolean	UseCriteriaDefaultingService
	
	Public ProtectedWrite	Long		ChildReportConfigID[]
	Public ProtectedWrite	String	ChildReportType[]
	Public ProtectedWrite	String	ChildReportParameters[]
	Public ProtectedWrite	Long		ChildReportCmpsteRprtCnfgDtlID[]
	Public ProtectedWrite	Long		ChildReportHeight[]
	Public ProtectedWrite	Boolean	ChildReportIsParentObject[]
	Public ProtectedWrite	Boolean	ChildReportIsRequired[]
	Public ProtectedWrite	Boolean	ChildReportIsExpanded[]
	Public ProtectedWrite	Boolean	ChildReportAllowCriteria[]
	Public ProtectedWrite	n_report ChildReportProperties[]
	Public ProtectedWrite	u_search ChildReportSearchObject[]
	Public ProtectedWrite	String	ViewType
	Public ProtectedWrite	String	ViewName
	Public ProtectedWrite	Boolean	IsDefault
	Public ProtectedWrite	Boolean	CanChangeView
	Public ProtectedWrite	Boolean	CanAddReports
	
	Protected:
		String	OverrideOptionName[]
		String	OverrideOptionValue[]
		String	CustomOptionName[]
		String	CustomOptionValue[]
		Long 		il_default_height 				= 500				// Default height for the tiled search when first added

end variables

forward prototypes
public subroutine of_set_options (string as_options)
public subroutine of_apply_overrides ()
public function string of_get (string as_name)
public subroutine of_reset ()
public function string of_set (long al_index, string as_name, string as_value)
public function string of_set (string as_name, string as_value)
public function long of_add_report (n_report an_report)
public function string of_init (long al_compositereportconfigid, boolean ab_issavedreport)
end prototypes

public subroutine of_set_options (string as_options);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_options()
//	Arguments:  as_options	- an options list in argument=value format with || separating them
//	Overview:   This will apply a list of options
//	Created by:	Blake Doerr
//	History: 	7/29/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_return
String	ls_Name[]
String	ls_Value[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the reportoptions into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_arguments(as_options, '||', ls_Name[], ls_Value[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Pass each one into the of_set function
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_Name[]), UpperBound(ls_Value[]))
	This.of_set(Trim(ls_Name[ll_index]), Trim(ls_Value[ll_index]))
Next
end subroutine

public subroutine of_apply_overrides ();String	ls_empty[]
Long		ll_index

For ll_index = 1 To Min(UpperBound(OverrideOptionName[]), UpperBound(OverrideOptionValue[]))
	This.of_set(OverrideOptionName[ll_index], OverrideOptionValue[ll_index])
Next

OverrideOptionName[]		= ls_empty[]
OverrideOptionValue[]	= ls_empty[]


end subroutine

public function string of_get (string as_name);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get()
//	Arguments:  as_name - The name of the variable that you want
//	Overview:   This will return any variable on the object
//	Created by:	Blake Doerr
//	History: 	7/29/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// If this object is not yet initialized, we need to return the overridden value first
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsInitialized Then
	For ll_index = 1 To Min(UpperBound(OverrideOptionName[]), UpperBound(OverrideOptionValue[]))
		If Lower(Trim(as_name)) = Lower(Trim(OverrideOptionName[ll_index])) Then Return OverrideOptionValue[ll_index]
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Case for all variables
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_name))
	Case 'compositereportid'
		Return String(CompositeReportID)
	Case 'iscompositereport'
		If IsCompositeReport Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isbatchmode'
		If IsBatchMode Then 
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isimportedcriteriadataobject'
		If IsImportedCriteriaDataObject Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'allowclosing'
		If AllowClosing Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'allowcriteria'
		If AllowCriteria Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'allowretrieve'
		If AllowRetrieve Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'rprtcnfgid'
		Return String(RprtCnfgID)
	Case 'folderid'
		Return String(FolderID)
	Case 'reportdatabaseid'
		Return String(ReportDatabaseID)
	Case 'criteriadataobjectblobobjectid'
		Return String(CriteriaDataObjectBlobObjectID)
	Case 'helpid'
		Return String(HelpID)
	Case 'name'
		Return Name
	Case 'description'
		Return Description
	Case 'criteriadaoobject'
		Return CriteriaDAOObject
	Case 'criteriauserobject'
		Return CriteriaUserObject
	Case 'criteriatype'
		Return CriteriaType
	Case 'displayobjecticon'
		Return DisplayObjectIcon
	Case 'usecriteriadefaultingservice'
		If UseCriteriaDefaultingService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isdefaultshowcriteria'
		If IsDefaultShowCriteria Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isautoretrieve'
		If IsAutoRetrieve Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'userid'
		Return String(UserID)
	Case 'reportdefaultid'
		Return String(ReportDefaultID)
	Case 'trackstatistics'
		If TrackStatistics Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case Else
		For ll_index = 1 To Min(UpperBound(CustomOptionName[]), UpperBound(CustomOptionValue[]))
			If Lower(Trim(as_name)) = Lower(Trim(CustomOptionName[ll_index])) Then Return CustomOptionValue[ll_index]
		Next
		
		ls_return = ls_return + ''
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the return string
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

public subroutine of_reset ();	String	ls_empty[]

	IsInitialized 		= False
	IsCompositeReport	= False
	ViewType				= Tabbed
	ViewName				= ''
	IsDefault			= False
	CanChangeView		= True
	CanAddReports		= False

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	SetNull(RprtCnfgID)
	SetNull(FolderID)
	SetNull(ReportDatabaseID)
	SetNull(CriteriaDataObjectBlobObjectID)
	SetNull(HelpID)
	SetNull(ReportDefaultID)

	UserID 												= gn_globals.il_userid
	Name 													= ''
	Description 										= ''
	DisplayObjectIcon 								= ''
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Object Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	CriteriaUserObject 			= ''
	CriteriaType 					= ''
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Miscellaneous Reporting Options
	//-----------------------------------------------------------------------------------------------------------------------------------
	IsDefaultShowCriteria			= False
	IsAutoRetrieve						= False
	IsImportedCriteriaDataObject	= False
	IsBatchMode							= False
	AllowAddingToDesktops			= True
	AllowClosing						= True
	AllowRetrieve						= True
	AllowCriteria						= True
	TrackStatistics					= True
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Service Options/**/These should be deleted because they are custom
	//-----------------------------------------------------------------------------------------------------------------------------------
	UseCriteriaDefaultingService	= True
	
	CustomOptionName[]		= ls_empty[]
	CustomOptionValue[]		= ls_empty[]
	
	If IsInitialized Then
		OverrideOptionName[]		= ls_empty[]
		OverrideOptionValue[]	= ls_empty[]
	End If
end subroutine

public function string of_set (long al_index, string as_name, string as_value);Choose Case Lower(Trim(as_name))
	Case 'childreportparameters'
		ChildReportParameters[al_index]	= as_value
	Case 'childreportisexpanded'
		ChildReportIsExpanded[al_index]	= Upper(Trim(as_value)) = 'Y'
End Choose

Return ''
end function

public function string of_set (string as_name, string as_value);String	ls_return
Long		ll_index

If Not IsInitialized Then
	OverrideOptionName[UpperBound(OverrideOptionName[]) + 1]		= as_name
	OverrideOptionValue[UpperBound(OverrideOptionName[])]			= as_value
	Return ''
End If

Choose Case Lower(Trim(as_name))
	Case 'isbatchmode'
		IsBatchMode	= Upper(Trim(as_value)) = 'Y'
		
		If IsBatchMode Then
			IsDefaultShowCriteria 			= False
			IsAutoRetrieve						= False
			UseCriteriaDefaultingService	= True
		End If

	Case 'isdefaultshowcriteria', 'show criteria'
		IsDefaultShowCriteria	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode And AllowCriteria
	Case 'isautoretrieve', 'autoretrieve'
		IsAutoRetrieve	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode And AllowRetrieve
	Case 'allowaddingtodesktops', 'allow adding to other desktops'
		AllowAddingToDesktops = Upper(Trim(as_value)) = 'Y'
	Case 'allowclosing', 'allow close'
		AllowClosing = Upper(Trim(as_value)) = 'Y'
	Case 'allowretrieve', 'allow retrieve'
		AllowRetrieve = Upper(Trim(as_value)) = 'Y' And Not IsBatchMode
		If Not AllowRetrieve Then IsAutoRetrieve = False
	Case 'allowcriteria', 'allow criteria'
		AllowCriteria = Upper(Trim(as_value)) = 'Y'
		If Not AllowCriteria Then IsDefaultShowCriteria = False

	Case 'usecriteriadefaultingservice', 'default criteria'
		UseCriteriaDefaultingService	= Upper(Trim(as_value)) = 'Y' Or IsBatchMode
	Case 'criteriadaoobject'
		CriteriaDAOObject = Trim(as_value)
	Case 'userid'
		UserID = Long(as_value)
	Case 'reportdefaultid'
		ReportDefaultID = Long(as_value)
	Case 'rprtcnfgid'
		RprtCnfgID		= Long(as_value)
	Case 'reportdatabaseid'
		ReportDatabaseID	= Long(as_value)
	Case 'compositereportid'
		CompositeReportID	= Long(as_value)
	Case 'trackstatistics'
		TrackStatistics	= Upper(Trim(as_value)) = 'Y'
	Case 'viewtype'
		ViewType	= Trim(as_value)
	Case 'viewname'
		ViewName = Trim(as_value)
	Case 'isdefault'
		IsDefault	= Upper(Trim(as_value)) = 'Y'
	Case 'canchangeview'
		CanChangeView	= Upper(Trim(as_value)) = 'Y'
	Case 'canaddreports'
		CanAddReports	= Upper(Trim(as_value)) = 'Y'
	Case Else
		For ll_index = 1 To UpperBound(CustomOptionName[])
			If Lower(Trim(CustomOptionName[ll_index])) = Lower(Trim(as_name)) Then
				CustomOptionValue[ll_index] = as_value
				Return ls_return
			End If
		Next
		
		CustomOptionName[UpperBound(CustomOptionName[]) + 1]	= as_name
		CustomOptionValue[UpperBound(CustomOptionName[])]		= as_value
End Choose

Return ls_return
end function

public function long of_add_report (n_report an_report);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_report()
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
Long		ll_upperbound
Long 		ll_null
Long		ll_validreportcount = 0
Long		ll_DtaObjctStteIdnty
Long		ll_RprtCnfgPvtTbleID
Long		ll_reportconfigid
String	ls_parameters
String 	ls_argument[]
String	ls_values[]
String	ls_null
String	ls_reporttype = 'R'
Long		ll_height
Boolean	lb_isparentobject
Boolean	lb_isrequired
Boolean	lb_expanded
Boolean	lb_allowcriteria
Long		ll_CmpsteRprtCnfgDtlID
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
u_search 				lu_search

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the upperbound
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_null)
ll_upperbound = UpperBound(ChildReportConfigID[]) + 1

//-----------------------------------------------------------------------------------------------------------------------------------
// Default all the values so they are not required to be passed in
//-----------------------------------------------------------------------------------------------------------------------------------
If an_report.of_get('Height') <> '' Then
	ll_height			= Long(an_report.of_get('Height'))
Else
	ll_height			= il_default_height
End If

If an_report.of_get('CmpsteRprtCnfgDtlID') <> '' Then
	ll_CmpsteRprtCnfgDtlID			= Long(an_report.of_get('CmpsteRprtCnfgDtlID'))
Else
	SetNull(ll_CmpsteRprtCnfgDtlID)
End If

lb_isparentobject = an_report.of_get('IsParent') <> 'N'
lb_isrequired		= an_report.of_get('IsRequired') = 'Y'
lb_expanded			= an_report.of_get('IsExpanded') <> 'N'
lb_allowcriteria	= an_report.of_get('AllowCriteria') = 'Y'

ll_index = UpperBound(ChildReportConfigID[]) + 1

ChildReportProperties[ll_index]				= an_report
ChildReportSearchObject[ll_index]			= lu_search
ChildReportConfigID[ll_index]					= an_report.RprtCnfgID
ChildReportType[ll_index]						= an_report.ReportType
ChildReportCmpsteRprtCnfgDtlID[ll_index]	= ll_CmpsteRprtCnfgDtlID

If an_report.of_get('DtaObjctStteIdnty') <> '' Then
	ls_parameters = 'DtaObjctStteIdnty=' + an_report.of_get('DtaObjctStteIdnty')
End If
If an_report.of_get('RprtCnfgPvtTbleID') <> '' Then
	If Len(ls_parameters) > 0 Then
		ls_parameters = ls_parameters + '||RprtCnfgPvtTbleID=' + an_report.of_get('RprtCnfgPvtTbleID')
	Else
		ls_parameters = 'RprtCnfgPvtTbleID=' + an_report.of_get('RprtCnfgPvtTbleID')
	End If
End If

ChildReportParameters[ll_index]				= ls_parameters
ChildReportHeight[ll_index]					= ll_height
ChildReportIsParentObject[ll_index]			= lb_isparentobject
ChildReportIsRequired[ll_index]				= lb_isrequired
ChildReportIsExpanded[ll_index]				= lb_expanded
ChildReportAllowCriteria[ll_index]			= lb_allowcriteria

Return ll_index
end function

public function string of_init (long al_compositereportconfigid, boolean ab_issavedreport);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  al_reportconfigid	- The reportconfig id or the saved report id depending on the second variable
//					ab_issavedreport	- Whether or not the report is a saved report
//	Overview:   This will initialize all the variables on this object
//	Created by:	Blake Doerr
//	History: 	7/29/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_reportconfigid
String	ls_reporttype		= 'R'
String	ls_displayobject
Long 		ll_index
Long		ll_height
Long		ll_CmpsteRprtCnfgDtlID
String	ls_isparentobject
String	ls_iscriteriaallowed
String	ls_isrequired
String	ls_parameters
String	ls_expanded
Boolean	lb_return
Long		ll_row
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_report ln_report
Datastore	lds_report_information
n_class_functions ln_class_functions

If This.IsInitialized Then Return ''

For ll_index = 1 To UpperBound(ChildReportSearchObject[])
	If IsValid(ChildReportSearchObject[ll_index]) Then
		al_compositereportconfigid = ChildReportConfigID[ll_index]
		ab_issavedreport = Upper(Trim(ChildReportType[ll_index])) = 'S'
		Exit
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the second argument to the retrieval procedure
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_IsSavedReport Then
	lds_report_information = Create Datastore
	lds_report_information.DataObject = 'd_reportconfig_information_cache'
	lds_report_information.SetTransObject(SQLCA)

	lds_report_information.Retrieve(al_compositereportconfigid, 'S')
	ll_row = 1
Else
	lds_report_information = gn_globals.in_cache.of_get_cache_reference('ReportConfig')

	If IsValid(lds_report_information) Then
		ll_row = lds_report_information.Find('ReportID = ' + String(al_compositereportconfigid) + ' And ReportType <> "S"', 1, lds_report_information.RowCount())
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If we didn't get the right number of rows back or got an error, return an error
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lds_report_information) then
	If ab_IsSavedReport Then Destroy lds_report_information
	Return 'Error:  Could not retrieve report information for report ' + String(al_compositereportconfigid)
end if

If ll_row <= 0 Or IsNull(ll_row) Or lds_report_information.RowCount() = 0 Then
	If ab_IsSavedReport Then Destroy lds_report_information
	Return 'Error:  Could not retrieve report information for report ' + String(al_compositereportconfigid)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all variables from the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
IsCompositeReport									= Upper(Trim(lds_report_information.GetItemString(ll_row, 'IsComposite'))) = 'Y'
RprtCnfgID											= lds_report_information.GetItemNumber(ll_row, 'reportid')
FolderID												= lds_report_information.GetItemNumber(ll_row, 'folderid')
Name													= lds_report_information.GetItemString(ll_row, 'name')
Description											= lds_report_information.GetItemString(ll_row, 'description')
DisplayObjectIcon									= lds_report_information.GetItemString(ll_row, 'reporticon')
IsAutoRetrieve										= Upper(Trim(lds_report_information.GetItemString(ll_row, 'autoretrieve'))) = 'Y'
IsDefaultShowCriteria 							= Upper(Trim(lds_report_information.GetItemString(ll_row, 'showcriteria'))) = 'Y'
ReportDatabaseID									= lds_report_information.GetItemNumber(ll_row, 'reportdbid')
IsImportedCriteriaDataObject					= Upper(Trim(lds_report_information.GetItemString(ll_row, 'criteriatype'))) = "I"
CriteriaDataObjectBlobObjectID				= lds_report_information.GetItemNumber(ll_row, 'criteriablobobjectid')
HelpID												= lds_report_information.GetItemNumber(ll_row, 'helpid')

If IsCompositeReport Then
	CriteriaUserObject							= lds_report_information.GetItemString(ll_row, 'criteriaobject')
Else
	CriteriaUserObject							= ''
End If

If IsImportedCriteriaDataObject Then
	CriteriaUserObject = 'uo_report_criteria_ud'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set that we are initialized because the next line calls an of_set()
//-----------------------------------------------------------------------------------------------------------------------------------
IsInitialized							= True

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the return string
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_IsSavedReport Then Destroy lds_report_information

//-----------------------------------------------------------------------------------------------------------------------------------
// If it's a composite, retrieve the children reports
//-----------------------------------------------------------------------------------------------------------------------------------
If IsCompositeReport Then
	If Not IsValid(in_dao_compositereportconfiguser) Then
		in_dao_compositereportconfiguser = Create n_dao_compositereportconfiguser
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Retrieve the composite report dao's
	//-----------------------------------------------------------------------------------------------------------------------------------
	in_dao_compositereportconfiguser.of_SetTransObject(SQLCA)
	in_dao_compositereportconfiguser.of_retrieve(RprtCnfgID, UserID)
	If in_dao_compositereportconfiguser.RowCount() <= 0 Then Return ''
	
	This.of_set('CompositeReportID', String(in_dao_compositereportconfiguser.GetItemNumber(1, 'cmpsterprtcnfgid')))
	This.of_set('ViewType', 		in_dao_compositereportconfiguser.GetItemString(1, 'CurrentViewType'))
	This.of_set('ViewName', 		in_dao_compositereportconfiguser.GetItemString(1, 'ViewName'))
	This.of_set('IsDefault', 		in_dao_compositereportconfiguser.GetItemString(1, 'IsDefault'))
	This.of_set('CanChangeView', 	in_dao_compositereportconfiguser.GetItemString(1, 'canchangeview'))
	This.of_set('CanAddReports', 	in_dao_compositereportconfiguser.GetItemString(1, 'canchangereports'))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Return if there aren't any rows
	//-----------------------------------------------------------------------------------------------------------------------------------
	If in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.RowCount() = 0 Then Return ''
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through all the rows and get the data necessary
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.RowCount()
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Make sure the report is either required or is supposed to be open
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_reportconfigid		= in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.GetItemNumber(ll_index, 'RprtCnfgID')
		ls_displayobject		= in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.GetItemString(ll_index, 'RprtCnfgDsplyObjct')
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Make sure the report is either required or is supposed to be open
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_isparentobject			= Upper(Trim(in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.GetItemString(ll_index, 'IsParentObject')))
		ls_iscriteriaallowed		= Upper(Trim(in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.GetItemString(ll_index, 'IsCriteriaAllowed')))
		ls_isrequired				= Upper(Trim(in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.GetItemString(ll_index, 'IsRequired')))
		ls_expanded					= Upper(Trim(in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.GetItemString(ll_index, 'Expanded')))
		ll_CmpsteRprtCnfgDtlID	= in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.GetItemNumber(ll_index, 'CmpsteRprtCnfgDtlID')
		ls_parameters				= Trim(in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.GetItemString(ll_index, 'Parameters'))
		ll_height					= in_dao_compositereportconfiguser.in_dao_compositereportconfigdetailuser.GetItemNumber(ll_index, 'Height')
	
	
		If IsNull(ls_isparentobject) Or Trim(ls_isparentobject) = '' Then ls_isparentobject = 'Y'
		If IsNull(ls_iscriteriaallowed) Or Trim(ls_iscriteriaallowed) = '' Then ls_iscriteriaallowed = 'Y'
		If IsNull(ls_isrequired) Or Trim(ls_isrequired) = '' Then ls_isrequired = 'Y'
		If IsNull(ls_expanded) Or Trim(ls_expanded) = '' Then ls_expanded = 'Y'
		If IsNull(ll_height) Or ll_height = 0 Then ll_height = 500
		If IsNull(ls_parameters) Then ls_parameters = ''
		If Len(ls_parameters) > 0 And Right(Trim(ls_parameters), 2) <> '||' Then ls_parameters = ls_parameters + '||'
		ls_parameters = ls_parameters + 'cmpsterprtcnfgdtlid=' + String(ll_CmpsteRprtCnfgDtlID) + '||height=' + String(ll_height) + '||isparent=' + ls_isparentobject + '||isrequired=' + ls_isrequired + '||isexpanded=' + ls_expanded + '||allowcriteria=' + ls_iscriteriaallowed
		ln_report = Create n_report
		ln_report.of_set_options(ls_parameters)
		ln_report.of_init(ll_reportconfigid, Upper(Trim(ls_reporttype)) = 'S')
		This.of_add_report(ln_report)
	Next	
End If

Return ls_return
end function

on n_report_composite.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_report_composite.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;This.of_reset()
end event

event destructor;Destroy in_dao_compositereportconfiguser
end event

