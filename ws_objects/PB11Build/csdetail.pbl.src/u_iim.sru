$PBExportHeader$u_iim.sru
$PBExportComments$The core functionality of the Inquiry Information Module.
forward
global type u_iim from datastore
end type
end forward

global type u_iim from datastore
end type
global u_iim u_iim

type variables
STRING						i_cSourceType
STRING						i_cCaseSubjectId
STRING 						i_cConvertToDate
STRING						i_cSummarySyntax
STRING						i_cDetailSyntax
U_CASE_DETAILS				i_uParentContainer
W_CREATE_MAINTAIN_CASE	i_wParentWindow
TRANSACTION					i_trObjects[]
BOOLEAN						i_bSourceTypeChange
BOOLEAN						i_bSummaryStoredProc = FALSE
BOOLEAN						i_bDetailStoredProc = FALSE

INTEGER						i_nIIMConfLevel
STRING					is_schema_owner
end variables

forward prototypes
public function string uf_setconvertstring ()
public function string uf_datebyformat (datetime a_dtdatetime, string a_cformat)
public function integer uf_clearcurrenttabs (u_tab_std a_tabfolder)
public function boolean uf_findcolumnindw (u_dw_std a_dwarg, string a_ccolname)
public function string uf_convertvalue (string a_cargtype, any a_avalue)
public function integer uf_refreshsummaryfolder (u_tab_std a_tabfolder)
public function integer uf_initiim (string a_csourcetype, string a_ccasesubjectid, windowobject a_woiimparent)
public function integer uf_buildtabs (u_tab_std a_tabfolder)
public function integer uf_getiimsyntax (integer a_nindex)
public function integer uf_buildsummaryfolder (u_tab_std a_tabfolder, integer a_ntab)
public subroutine uf_builddsnlist ()
public function long uf_loaddata (u_dw_std a_dwview, u_dw_std a_dwsource1, u_dw_std a_dwsource2, integer a_ntrindex, boolean a_brefresh, string a_csummarysyntax, string a_csummaryselect)
end prototypes

public function string uf_setconvertstring ();/*****************************************************************************************
   Function:   uf_SetConvertString
   Purpose:    Return the fields to be converted to datetime to each seperate
					tab.
   Returns:    String containing the fields to be converted to datetime

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/22/2000 K. Claver   Created.
*****************************************************************************************/
RETURN THIS.i_cConvertToDate
end function

public function string uf_datebyformat (datetime a_dtdatetime, string a_cformat);//////////////////////////////////////////////////////////////////////////////
//
//	Function:      uf_DateByFormat
//
//	Access:  		public
//
//	Arguments:
//	a_dtDateTime   Datetime variable containing the start date and time.
// a_cFormat	   String containing the format to format the start date to.
//
//	Returns:  		String containing the formatted date if successful.  Empty
//						string if not successful.
//
//	Description:  	Format the export job start date to the passed format for
//						incremental date functionality
//						 
//								 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	1.0   KMC Initial version
//////////////////////////////////////////////////////////////////////////////
String l_cFormat, l_cCentury, l_cYear, l_cDay, l_cMonth, l_cHour, l_cChar, l_cLastChar = ""
String l_cMinute, l_cSecond, l_cMSecond, l_cRV = "", l_cDate, l_cValidChars = "CYMDHMSFI-:._/\ "
Date l_dDate
Time l_tTime
Integer l_nIndex

//If no format, return as default format
IF Trim( a_cFormat ) = "**" THEN
	RETURN String( a_dtDateTime, "mm/dd/yyyy" )
END IF

l_cDate = String( a_dtDateTime, "yyyy-mm-dd hh:mm:ss.fff" )
l_cFormat = Upper( a_cFormat )
l_dDate = Date( a_dtDateTime )
l_tTime = Time( a_dtDateTime ) 

//Century
IF Pos( l_cFormat, "CCC" ) > 0 THEN
	//Bad century format
	RETURN ""
ELSEIF Pos( l_cFormat, "CC" ) > 0 THEN
	IF Mid( String( Year( l_dDate ) ), 1, 2 ) = "18" THEN
		l_cCentury = "00"
	ELSE
		l_cCentury = "0"+Mid( String( Year( l_dDate ) ), 1, 1 )
	END IF
ELSEIF Pos( l_cFormat, "C" ) > 0 THEN
	IF Mid( String( Year( l_dDate ) ), 1, 2 ) = "18" THEN
		l_cCentury = "0"
	ELSE
		l_cCentury = Mid( String( Year( l_dDate ) ), 1, 1 )
	END IF
END IF

//Year
IF Pos( l_cFormat, "YYYY" ) > 0 THEN
	l_cYear = String( Year( l_dDate ) )
ELSEIF Pos( l_cFormat, "YY" ) > 0 THEN
	l_cYear = Mid( String( Year( l_dDate ) ), 3, 2 )
ELSEIF Pos( l_cFormat, "Y" ) > 0 THEN
	//Bad year format
	RETURN ""
END IF

//Month
IF Pos( l_cFormat, "MM" ) > 0 THEN
	l_cMonth = String( Month( l_dDate ) )
	IF Len( l_cMonth ) = 1 THEN
		l_cMonth = "0"+l_cMonth
	END IF
ELSEIF Pos( l_cFormat, "M" ) > 0 THEN
	//Bad month format
	RETURN ""
END IF

//Day
IF Pos( l_cFormat, "DD" ) > 0 THEN
	l_cDay = String( Day( l_dDate ) )
	IF Len( l_cDay ) = 1 THEN
		l_cDay = "0"+l_cDay
	END IF
ELSEIF Pos( l_cFormat, "D" ) > 0 THEN
	//Bad day format
	RETURN ""
END IF

//Hour
IF Pos( l_cFormat, "HH" ) > 0 THEN
	l_cHour = String( Hour( l_tTime ) )
	IF Len( l_cHour ) = 1 THEN
		l_cHour = "0"+l_cHour
	END IF
ELSEIF Pos( l_cFormat, "H" ) > 0 THEN
	//Bad hour format
	RETURN ""
END IF

//Minute
IF Pos( l_cFormat, "MI" ) > 0 THEN
	l_cMinute = String( Minute( l_tTime ) )
	IF Len( l_cMinute ) = 1 THEN
		l_cMinute = "0"+l_cMinute
	END IF
ELSEIF Pos( l_cFormat, "M" ) > 0 THEN
	//Account for Month having the same first character
	IF Mid( l_cFormat, ( Pos( l_cFormat, "M" ) + 1 ), 1 ) <> "M" AND &
		Mid( l_cFormat, ( Pos( l_cFormat, "M" ) + 1 ), 1 ) <> "I" THEN
		//Bad minute format
		RETURN ""
	END IF
END IF

//Second
IF Pos( l_cFormat, "SS" ) > 0 THEN
	l_cSecond = String( Second( l_tTime ) )
	IF Len( l_cSecond ) = 1 THEN
		l_cSecond = "0"+l_cSecond
	END IF
ELSEIF Pos( l_cFormat, "S" ) > 0 THEN
	//Bad second format
	RETURN ""
END IF
	
//MilliSecond
IF Pos( l_cFormat, "FFF" ) > 0 THEN
	l_cMSecond = Mid( l_cDate, 21, 3 )
ELSEIF Pos( l_cFormat, "F" ) > 0 THEN
	//Bad millisecond format
	RETURN ""
END IF

//Make the formatted date
FOR l_nIndex = 1 TO Len( l_cFormat )
	l_cChar = Trim( Mid( l_cFormat, l_nIndex, 1 ) )
	
	IF Pos( l_cValidChars, l_cChar ) > 0 THEN
		IF l_cChar <> l_cLastChar THEN
			CHOOSE CASE l_cChar
				CASE "C"
					l_cRV += l_cCentury
				CASE "Y"
					l_cRV += l_cYear
				CASE "M"
					//accomodate for similarity between minute and month
					//  format character
					IF Mid( a_cFormat, ( l_nIndex + 1 ), 1 ) <> "I" THEN
						l_cRV += l_cMonth
					ELSEIF Mid( a_cFormat, ( l_nIndex + 1 ), 1 ) = "I" THEN
						l_cRV += l_cMinute						
					END IF
				CASE "D"
					l_cRV += l_cDay
				CASE "H"
					l_cRV += l_cHour
				//Minutes accomodated above with months	
				CASE "S"
					l_cRV += l_cSecond
				CASE "F"
					l_cRV += l_cMSecond
				CASE ELSE
					//Field seperator character(ie. "/",":",".","-","_"," ","\")
					IF l_cChar <> "I" THEN
						l_cRV += l_cChar
					END IF
					CONTINUE
			END CHOOSE
		END IF			
		
		//Make the last char variable equal to the character just processed
		l_cLastChar = l_cChar
	ELSE
		//If not valid format character, return empty string for error
		RETURN ""
	END IF
NEXT	

RETURN l_cRV
end function

public function integer uf_clearcurrenttabs (u_tab_std a_tabfolder);/*****************************************************************************************
   Function:   uf_ClearCurrentTabs
   Purpose:    Initialize the IIM Summary tab folder based on defined tabs
   Parameters: TAB			a_tabFolder - The tab folder to initialize
   Returns:    INTEGER		 0 - Success
									-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/4/00   M. Caruso    Created.
*****************************************************************************************/

INTEGER				l_nTabCount, l_nIndex
U_IIM_TAB_PAGE		l_uPage
						

l_nTabCount = Upperbound (a_tabFolder.Control[])
FOR l_nIndex = l_nTabCount TO 1 STEP - 1
	
	l_uPage = a_tabFolder.Control[l_nIndex]
	l_uPage.i_bManualClose = TRUE
	a_tabFolder.CloseTab (l_uPage)
	
NEXT

RETURN 0
end function

public function boolean uf_findcolumnindw (u_dw_std a_dwarg, string a_ccolname);/*****************************************************************************************
   Function:   uf_FindColumnInDW
   Purpose:    Determine if a column exists in a specified datawindow
   Parameters: U_DW_STD	a_dwArg - The datawindow to search
					STRING	a_cColName - The name of the column to find
					
   Returns:    BOOLEAN	TRUE - the column was found
								FALSE - the column was not found

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/9/00   M. Caruso    Created.
	
	4/17/00  M. Caruso    Return FALSE if the source datawindow is Null.
*****************************************************************************************/

LONG		l_nColCount
INTEGER	l_nIndex, l_nCount
STRING	l_cColName
BOOLEAN	l_bFound = FALSE

IF NOT IsNull (a_dwArg) THEN	
	l_nColCount = LONG (a_dwArg.Object.Datawindow.Column.Count)
	
	FOR l_nIndex = 1 TO l_nColCount			
		// compare a_cColName to the NAME of the datawindow columns
		l_cColName = a_dwArg.Describe ("#" + STRING (l_nIndex) + ".name")
		IF l_cColName = a_cColName THEN 
			l_bFound = TRUE
			EXIT
		END IF		
	NEXT	
END IF
	
RETURN l_bFound

end function

public function string uf_convertvalue (string a_cargtype, any a_avalue);/*****************************************************************************************
   Function:   uf_convertvalue
   Purpose:    Convert a retrieval argument value to the data type of the database column.
   Parameters: STRING	a_cArgType - The data type of the argument value.
					ANY		a_aValue - The value to convert.
   Returns:    STRING - A string representation of the value in the proper format.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/19/00 M. Caruso    Created.
	05/02/00 M. Caruso    Modified function to compare data types.
	6/1/2001 K. Claver    Changed to reflect the datatypes for arguments in the datawindow
								 painter and removed code that would return a null.
*****************************************************************************************/

STRING	l_cValue

// convert the data
CHOOSE CASE a_cArgType
	CASE 'string', 'date', 'time', 'datetime'
		l_cValue = "'" + STRING (a_aValue) + "'"
				
	CASE 'number'
		l_cValue = STRING (a_aValue)
		
END CHOOSE

RETURN l_cValue
end function

public function integer uf_refreshsummaryfolder (u_tab_std a_tabfolder);/*****************************************************************************************
   Function:   uf_RefreshSummaryFolder
   Purpose:    Refresh the IIM Summary tab folder based on defined tabs
   Parameters: TAB			a_tabFolder - The tab folder to initialize
   Returns:    INTEGER		 0 - Success
									-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/4/00   M. Caruso    Created.
	3/1/00   M. Caruso    Restore the same transaction object after calling CREATE
	4/6/00   M. Caruso    Added code to enable/disable query mode on the datawindows.
	5/4/00   M. Caruso    Added the c_NoMenuButtonActivation option to the datawindows
	5/8/00   M. Caruso    Added the c_SelectOnRowFocusChange option to the datawindows
	7/9/2001 K. Claver    Enhanced to simply change the sql syntax when change source id
								 rather than rebuild the datawindow.
*****************************************************************************************/

LONG					l_nRowCount, l_nIndex
INTEGER				l_nTabNum, l_nColCount, l_nColID
STRING				l_cDWSyntax, l_cOptions = "", l_cColumn
BOOLEAN				l_bError = FALSE
U_IIM_TAB_PAGE		l_uPage
U_DW_STD				l_dwCurrent, l_dwInitial
TRANSACTION			l_trObject

l_nTabNum = a_tabFolder.SelectedTab
l_nRowCount = RowCount ()

FOR l_nIndex = 1 TO l_nRowCount

	// re-initialize the tab
	l_uPage = a_tabFolder.Control[l_nIndex]
	
	//Set the refresh instance variable to true as just want to replace the
	//  sql instead of rebuilding the datawindow.
	l_uPage.i_bRefresh = TRUE
	
	IF l_uPage.i_bAlreadyBuilt THEN
		l_dwInitial = l_uPage.dw_initial_view
		l_dwCurrent = l_uPage.dw_summary_view
		
		l_dwInitial.fu_Reset( l_dwInitial.c_IgnoreChanges )		
		l_dwCurrent.fu_Reset( l_dwCurrent.c_IgnoreChanges )		
		
		l_cDWSyntax = i_cSummarySyntax
		
		IF IsNull (l_cDWSyntax) OR l_cDWSyntax = "" THEN				
			l_dwCurrent.DataObject = ""
			l_dwInitial.DataObject = ""
		ELSE
			//Need to turn off criteria.dialog for the datawindows so doesn't prompt
			//  when attempts to re-retrieve for the new source.
			
			IF NOT IsNull( l_uPage.i_cConvertToDate ) AND Trim( l_uPage.i_cConvertToDate ) <> "" THEN
				//Initial View
				l_nColCount = INTEGER (l_dwInitial.Describe ('Datawindow.Column.Count'))
				FOR l_nColID = 1 TO l_nColCount							
					l_dwInitial.Modify ("#" + String( l_nColID ) + ".Criteria.Dialog=No")
				NEXT
			END IF
			
			//Summary View
			l_nColCount = INTEGER (l_dwCurrent.Describe ('Datawindow.Column.Count'))
			FOR l_nColID = 1 TO l_nColCount							
				l_dwCurrent.Modify ("#" + String( l_nColID ) + ".Criteria.Dialog=No")
			NEXT
			
			l_uPage.i_bLoaded = FALSE
		END IF
	END IF		
NEXT

// if all tabs are refreshed, set tab 1 as current and return a status of success.
a_tabFolder.SelectTab (l_nTabNum)
RETURN 0
end function

public function integer uf_initiim (string a_csourcetype, string a_ccasesubjectid, windowobject a_woiimparent);/*****************************************************************************************
   Function:   uf_InitIIM
   Purpose:    Initialize the datawindow object of the u_iim.
   Parameters: STRING	a_cSourceType - The source type of the case being handled.
					STRING	a_cCaseSubjectId - The current case subject.
					
   Returns:    INTEGER	 0 - Success
								-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/4/00   M. Caruso    Created.
	8/17/2000 K. Claver   Removed the summary and detail syntax from the selects as we'll
								 be storing the syntax in blobs.  Also added the tab_id field so
								 can retrieve the syntax blobs.
*****************************************************************************************/

STRING	l_cDWSelect, l_cDWSyntax, l_cErrors, l_cUserID

//Get the iim confidentiality level for the login
l_cUserID = OBJCA.WIN.fu_GetLogin( SQLCA )

SELECT iim_confidentiality_level
INTO :THIS.i_nIIMConfLevel
FROM cusfocus.cusfocus_user
WHERE user_id = :l_cUserID
USING SQLCA;

//Set the instance variables and retrieve the available tabs
i_cSourceType = a_cSourceType
i_cCaseSubjectId = a_cCaseSubjectId
i_uParentContainer = a_woIIMParent
i_wParentWindow = w_create_maintain_case

CHOOSE CASE	i_cSourceType
	CASE "C"
		l_cDWSelect = "SELECT cusfocus.iim_tabs.tab_title, " + &
									"cusfocus.iim_tabs.iim_source_id, " + &
									"cusfocus.iim_tabs.tab_preload, " + &
									"cusfocus.iim_datasources.iim_source_name, " + &
									"cusfocus.iim_tabs.tab_id, " + &
									"isnull(cusfocus.iim_datasources.iim_schema_owner,'DBO') as iim_schema_owner " + &
						  "FROM cusfocus.iim_tabs, cusfocus.iim_datasources " + &
						  "WHERE cusfocus.iim_datasources.iim_source_id = cusfocus.iim_tabs.iim_source_id AND " + &
						  			"cusfocus.iim_tabs.tab_available_member = 'Y' AND " + &
						  			"cusfocus.iim_tabs.tab_active = 'Y' AND " + &
									"( cusfocus.iim_tabs.summary_conf_level <= "+String( THIS.i_nIIMConfLevel )+" OR"+ &
									"  cusfocus.iim_tabs.summary_conf_level is null ) "+ &
						  "ORDER BY cusfocus.iim_tabs.tab_order_member"
		
	CASE "P"
		l_cDWSelect = "SELECT cusfocus.iim_tabs.tab_title, " + &
									"cusfocus.iim_tabs.iim_source_id, " + &
									"cusfocus.iim_tabs.tab_preload, " + &
									"cusfocus.iim_datasources.iim_source_name, " + &
									"cusfocus.iim_tabs.tab_id, " + &
									"isnull(cusfocus.iim_datasources.iim_schema_owner,'DBO') as iim_schema_owner " + &
						  "FROM cusfocus.iim_tabs, cusfocus.iim_datasources " + &
						  "WHERE cusfocus.iim_datasources.iim_source_id = cusfocus.iim_tabs.iim_source_id AND " + &
						  			"cusfocus.iim_tabs.tab_available_provider = 'Y' AND " + &
						  			"cusfocus.iim_tabs.tab_active = 'Y' AND " + &
									"( cusfocus.iim_tabs.summary_conf_level <= "+String( THIS.i_nIIMConfLevel )+" OR"+ &
									"  cusfocus.iim_tabs.summary_conf_level is null ) "+ &
						  "ORDER BY cusfocus.iim_tabs.tab_order_provider"
						  
	CASE "E"
		l_cDWSelect = "SELECT cusfocus.iim_tabs.tab_title, " + &
									"cusfocus.iim_tabs.iim_source_id, " + &
									"cusfocus.iim_tabs.tab_preload, " + &
									"cusfocus.iim_datasources.iim_source_name, " + &
									"cusfocus.iim_tabs.tab_id, " + &
									"isnull(cusfocus.iim_datasources.iim_schema_owner,'DBO') as iim_schema_owner " + &
						  "FROM cusfocus.iim_tabs, cusfocus.iim_datasources " + &
						  "WHERE cusfocus.iim_datasources.iim_source_id = cusfocus.iim_tabs.iim_source_id AND " + &
						  			"cusfocus.iim_tabs.tab_available_group = 'Y' AND " + &
						  			"cusfocus.iim_tabs.tab_active = 'Y' AND " + &
									"( cusfocus.iim_tabs.summary_conf_level <= "+String( THIS.i_nIIMConfLevel )+" OR"+ &
									"  cusfocus.iim_tabs.summary_conf_level is null ) "+ &
						  "ORDER BY cusfocus.iim_tabs.tab_order_group"
		
	CASE "O"
		l_cDWSelect = "SELECT cusfocus.iim_tabs.tab_title, " + &
									"cusfocus.iim_tabs.iim_source_id, " + &
									"cusfocus.iim_tabs.tab_preload, " + &
									"cusfocus.iim_datasources.iim_source_name, " + &
									"cusfocus.iim_tabs.tab_id, " + &
									"isnull(cusfocus.iim_datasources.iim_schema_owner,'DBO') as iim_schema_owner " + &
						  "FROM cusfocus.iim_tabs, cusfocus.iim_datasources " + &
						  "WHERE cusfocus.iim_datasources.iim_source_id = cusfocus.iim_tabs.iim_source_id AND " + &
						  			"cusfocus.iim_tabs.tab_available_other = 'Y' AND " + &
						  			"cusfocus.iim_tabs.tab_active = 'Y' AND " + &
									"( cusfocus.iim_tabs.summary_conf_level <= "+String( THIS.i_nIIMConfLevel )+" OR"+ &
									"  cusfocus.iim_tabs.summary_conf_level is null ) "+ &
						  "ORDER BY cusfocus.iim_tabs.tab_order_group"
		
END CHOOSE

IF Len (l_cDWSelect) > 0 THEN
	// create the datawindow object syntax
	l_cDWSyntax = SQLCA.SyntaxFromSQL (l_cDWSelect, "", l_cErrors)
	IF Len (l_cErrors) > 0 THEN
			
		RETURN -1
	
	END IF
	
	// create the datawindow object in the datastore
	THIS.Create (l_cDWSyntax, l_cErrors)
	IF Len (l_cErrors) > 0 THEN
			
		RETURN -1
			
	ELSE
		
		SetTransObject (SQLCA)
		RETURN 0
	
	END IF
	
ELSE
	
	RETURN -1
	
END IF
end function

public function integer uf_buildtabs (u_tab_std a_tabfolder);/*****************************************************************************************
   Function:   uf_BuildTabs
   Purpose:    Build the IIM tab objects
   Parameters: a_tabfolder - pointer to the tab folder that we are building tab pages
									  for.
   Returns:    1 - success
					-1 - failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/16/2001 K. Claver   Created
*****************************************************************************************/
Integer l_nIndex, l_nRowCount, l_nRV = 1
u_iim_tab_page l_uPage
String l_cPreloadCol, l_cTitleCol

l_cTitleCol = describe ("#1.Name")
l_cPreloadCol = describe ("#3.Name")

l_nRowCount = RowCount ()
FOR l_nIndex = 1 TO l_nRowCount	
	l_nRV = a_tabFolder.OpenTab (u_iim_tab_page, l_nIndex)
	
	IF l_nRV = 1 THEN		
		// initialize the tab if it was created properly.
		l_uPage = a_tabFolder.Control[l_nIndex]
		l_uPage.i_tabParent = a_tabFolder
		l_uPage.i_uParentIIM = THIS
		l_uPage.i_bBlank = FALSE
		l_uPage.i_bAlreadyBuilt = FALSE
		
		//register the new tab page with the resize service on the tab object
		IF IsValid( a_TabFolder.inv_resize ) THEN
			a_TabFolder.inv_resize.of_Register( l_uPage, a_TabFolder.inv_resize.SCALERIGHTBOTTOM )
		END IF
		
		IF GetItemString (l_nIndex, l_cPreloadCol) = 'Y' THEN
			l_uPage.i_bPreLoad = TRUE
		ELSE
			l_uPage.i_bPreLoad = FALSE
		END IF
		l_uPage.text = GetItemString (l_nIndex, l_cTitleCol)
	ELSE
		l_nRV = -1
	END IF
NEXT

RETURN l_nRV
end function

public function integer uf_getiimsyntax (integer a_nindex);/*****************************************************************************************
   Function:   uf_GetIIMSyntax
   Purpose:    Get the summary and detail syntax
   Parameters: Integer		a_nIndex - Row currently on in the datastore
   Returns:    INTEGER		 0 - Success
									-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/16/2000 K. Claver   Created.
	11/25/2002 K. Claver  Added code to accomodate for stored procs.
*****************************************************************************************/
Integer l_nRV = 0
Long l_nTabID, ll_pos
Blob l_bSummary, l_bDetail

l_nTabID = THIS.GetItemNumber( a_nIndex, 5 )
is_schema_owner = THIS.Object.iim_schema_owner[a_nIndex]
IF LEN(is_schema_owner) = 0 THEN
	is_schema_owner = "DBO"
END IF

IF NOT IsNull( l_nTabID ) AND l_nTabID <> 0 THEN
	////Begin embedded sql to populate the summary syntax blob
	SELECTBLOB cusfocus.iim_tabs.tab_summary_image
	INTO :l_bSummary
	FROM cusfocus.iim_tabs
	WHERE cusfocus.iim_tabs.tab_id = :l_nTabID
	USING SQLCA;
	////End embedded sql
	
	IF SQLCA.SQLCode < 0 THEN
		l_nRV = -1
	ELSE
		////Begin embedded sql to populate the detail syntax blob
		SELECTBLOB cusfocus.iim_tabs.tab_detail_image
		INTO :l_bDetail
		FROM cusfocus.iim_tabs
		WHERE cusfocus.iim_tabs.tab_id = :l_nTabID AND
				( cusfocus.iim_tabs.detail_conf_level <= :THIS.i_nIIMConfLevel OR
				  cusfocus.iim_tabs.detail_conf_level is null )
		USING SQLCA;
		////End embedded sql
		
		IF SQLCA.SQLCode < 0 THEN
			l_nRV = -1
		ELSE
			i_cSummarySyntax = String( l_bSummary )
			// Make sure we converted it correctly - RAP 11/4/08
			ll_pos = Pos( i_cSummarySyntax, "release" )
			IF ll_pos = 0 THEN
				i_cSummarySyntax = string(l_bSummary, EncodingANSI!)
			END IF
			i_cDetailSyntax = String( l_bDetail )
			// Make sure we converted it correctly - RAP 11/4/08
			ll_pos = Pos( i_cDetailSyntax, "release" )
			IF ll_pos = 0 THEN
				i_cDetailSyntax = string(l_bDetail, EncodingANSI!)
			END IF
			
			//Remove the manual or graphical creation flag before
			//  continuing.
			IF Pos( i_cSummarySyntax, "(M)" ) = 1 OR &
			   Pos( i_cSummarySyntax, "(G)" ) = 1 THEN
				i_cSummarySyntax = Mid( i_cSummarySyntax, 4 )
			END IF
			
			IF Pos( i_cDetailSyntax, "(M)" ) = 1 OR &
			   Pos( i_cDetailSyntax, "(G)" ) = 1 THEN
				i_cDetailSyntax = Mid( i_cDetailSyntax, 4 )
			END IF
			
			//Need to add boolean indicators so can check if the datawindow is based
			//  on a stored proc before executing the uf_loaddata function in the pcd_retrieve
			//  event of the IIM datawindow.
			IF Pos( Upper( i_cSummarySyntax ), "EXECUTE " + is_schema_owner ) > 0 THEN
				THIS.i_bSummaryStoredProc = TRUE
			END IF
			
			IF Pos( Upper( i_cDetailSyntax ), "EXECUTE " + is_schema_owner ) > 0 THEN
				THIS.i_bDetailStoredProc = TRUE
			END IF
			
			//Remove the header info from the syntax
			IF Pos( Upper( i_cSummarySyntax ), "RELEASE" ) > 1 THEN
				i_cSummarySyntax = Mid( i_cSummarySyntax, Pos( Upper( i_cSummarySyntax ), "RELEASE" ) )
			END IF
			
			IF Pos( Upper( i_cDetailSyntax ), "RELEASE" ) > 1 THEN
				i_cDetailSyntax = Mid( i_cDetailSyntax, Pos( Upper( i_cDetailSyntax ), "RELEASE" ) )
			END IF
		END IF
	END IF
END IF
		
RETURN l_nRV
end function

public function integer uf_buildsummaryfolder (u_tab_std a_tabfolder, integer a_ntab);/*****************************************************************************************
   Function:   uf_BuildSummaryFolder
   Purpose:    Initialize the IIM Summary tab folder based on defined tabs
   Parameters: TAB			a_tabFolder - The tab folder to initialize.
				   Tab Number  a_ntab	   - The tab to initialize.
   Returns:    INTEGER		 0 - Success
									-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/4/00   M. Caruso    Created.
	3/1/00   M. Caruso    Set the appropriate transaction object for each tab.
	3/22/00  M. Caruso    Reset l_bfound to FALSE for each tab before trying to find the
								 transaction object in the array.
	4/3/00   M. Caruso    If the transaction object is not in the array, set the array
								 index for the tab to 0.  Also, disable any tabs that do not have
								 a valid view defined.
	4/6/00   M. Caruso    Added code to enable/disable query mode on the datawindows.
	4/10/00  M. Caruso    Added code to turn off the Criteria.Dialog for all columns in the
								 datawindows for the initial load of data.
	5/4/00   M. Caruso    Added the c_NoMenuButtonActivation option to the datawindows.
	5/8/00   M. Caruso    Added the c_SelectOnRowFocusChange option to the datawindows.
	5/9/00   M. Caruso    Removed a RETURN statement from the loop if dw syntax is NULL.
	8/9/2000 K. Claver    Added code to parse the fields to be converted to dates before
							    creating the datawindow.
	8/16/2000 K. Claver   Changed the numbers in the describe function calls as the sql 
								 statements in uf_initiim have changed
	11/14/2000 K. Claver  Added to the modify statement per column to give a tab sequence
								 and set to display only so can copy and paste from the columns
								 without having the ability to modify them.
	3/29/2001 K. Claver   Commented out disconnect from database as re-connecting can be 
								 cumbersome on some DBMS systems.
	4/16/2001 K. Claver   Added argument to initialize the tabs one at a time.
	5/31/2001 K. Claver   Enhanced for use of InfoMaker in IIM.
*****************************************************************************************/

LONG					l_nRowCount, l_nIndex, l_nCount, l_nColCount, l_nColID
INTEGER				l_nTrObjCount, l_nDWCount = 1, l_nDWCounter, l_nTypePos, l_nFieldPos
STRING				l_cDWSyntax, l_cSourceName, l_cOptions = ""
STRING				l_cNameCol, l_cConvertToDate, ls_schema_owner
STRING				l_cInitialDWSyntax, l_cFirstPart, l_cSecondPart, l_cField
BOOLEAN				l_bError = FALSE, l_bFound, l_bSetDrag
u_DW_STD				l_dwCurrent
U_IIM_TAB_PAGE		l_uPage

// set the name of the datasource column in the datastore
l_cNameCol = describe ("#4.Name")

l_nRowCount = RowCount ()
IF l_nRowCount > 0 AND a_nTab <= l_nRowCount THEN
	
	// Set a pointer to the tabpage if it was created properly.
	l_uPage = a_tabFolder.Control[a_nTab]
	
	IF IsValid( l_uPage ) THEN
		//Set the refresh instance variable to false as we're rebuilding the
		//  datawindow.
		l_uPage.i_bRefresh = FALSE
		
		IF NOT l_uPage.i_bAlreadyBuilt THEN
	
			IF uf_GetIIMSyntax( a_nTab ) < 0 THEN
				RETURN -1
			END IF
			
			l_cDWSyntax = i_cSummarySyntax
			
			l_dwCurrent = l_uPage.dw_summary_view
			
			// Get the transaction object with which to connect
			l_cSourceName = GetItemString (a_nTab, l_cNameCol)
			l_nTrObjCount = upperbound (i_trObjects[])
			l_bFound = FALSE
			FOR l_nCount = 1 TO l_nTrObjCount
						
				IF Match (i_trObjects[l_nCount].DBParm, l_cSourceName) THEN
									
					l_bFound = TRUE
					EXIT
							
				END IF
						
			NEXT
					
			IF l_bFound THEN
				l_uPage.i_nTrArrayIndex = l_nCount
			ELSE
				l_uPage.i_nTrArrayIndex = 0
			END IF
			
			IF IsNull (l_cDWSyntax) OR l_cDWSyntax = "" THEN
				
				l_dwCurrent.DataObject = ""
				l_uPage.Enabled = FALSE
				m_iim_tabs.m_file.m_search.Enabled = FALSE
				m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
				Modify ("datawindow.Color='80269524'")
				l_uPage.i_bAlreadyBuilt = TRUE
				
			ELSE
				
				IF Match( l_cDWSyntax, "#CD#" ) THEN
					//Fields to convert to dates exist.  Parse them off the end before
					//  create the datawindow.
					i_cConvertToDate = Upper( Mid( l_cDWSyntax, Pos( l_cDWSyntax, "#CD#" ) ) )
					l_uPage.i_cConvertToDate = i_cConvertToDate
					l_cDWSyntax = Mid( l_cDWSyntax, 1, Pos( l_cDWSyntax, "#CD#" ) - 1 )
					l_cInitialDWSyntax = l_cDWSyntax
					
					//Parse out the PBSELECT part to make the display datawindow
					//  external
					IF Match( l_cDWSyntax, "retrieve=" ) THEN
						l_cFirstPart = Mid( l_cDWSyntax, 1, ( Pos( l_cDWSyntax, "retrieve=" ) - 1 ) )
						l_cSecondPart = Mid( l_cDWSyntax, ( Pos( l_cDWSyntax, "text(", Pos( l_cDWSyntax, "retrieve=" ) ) - 3 ) )
						l_cDWSyntax = l_cFirstPart+l_cSecondPart
					END IF
					
					//Change the appropriate fields to datetime for display
					l_nTypePos = Pos( l_cDWSyntax, "type=" )
					DO WHILE l_nTypePos > 0
						//Find the table and column name to check if is one to convert to a datetime
						l_nFieldPos = Pos( l_cDWSyntax, '"', l_nTypePos )
						l_cField = Mid( l_cDWSyntax, ( l_nFieldPos + 1 ), ( ( Pos( l_cDWSyntax, '"', ( l_nFieldPos + 1 ) ) - l_nFieldPos ) - 1 ) )
						
						//If find a match, convert to datetime field before create datawindow
						//Add a "^" to the end for an exact match
						l_cField += "^"
						IF Pos( i_cConvertToDate, Upper( l_cField ) ) > 0 THEN
							l_cFirstPart = Mid( l_cDWSyntax, 1, ( l_nTypePos + 4 ) )
							l_cSecondPart = Mid( l_cDWSyntax, Pos( l_cDWSyntax, " ", l_nTypePos ) )
							l_cDWSyntax = l_cFirstPart+"datetime"+l_cSecondPart
						END IF
						
						l_nTypePos = Pos( l_cDWSyntax, "type=", ( l_nTypePos + 1 ) )
					LOOP
					
					//Set the datawindow count to 2 as we're processing with two datawindows
					//  for convert to date processing
					l_nDWCount = 2
				ELSE
					//Hide the initial view datawindow if not going to use it
					l_uPage.dw_Initial_View.Visible = FALSE
					i_cConvertToDate = ""
					l_uPage.i_cConvertToDate = i_cConvertToDate
				END IF	
				
				FOR l_nDWCounter = 1 TO l_nDWCount
					IF l_nDWCounter = 2 THEN
						//Switch the current datawindow to the background datawindow for 
						//  convert to date processing
						l_dwCurrent = l_uPage.dw_Initial_View
						l_cDWSyntax = l_cInitialDWSyntax
					END IF
					
					IF l_dwCurrent.Create (l_cDWSyntax) = 1 THEN
						// turn off the Criteria.Dialog property from all columns.
						l_nColCount = INTEGER (l_dwCurrent.Describe ('Datawindow.Column.Count'))
						FOR l_nColID = 1 TO l_nColCount							
							l_dwCurrent.Modify ("#" + String( l_nColID ) + ".Criteria.Dialog=No")
							
							IF l_nDWCounter = 1 THEN
								IF l_dwCurrent.Describe( "#"+String( l_nColID )+".Visible" ) = "1" THEN									
									l_dwCurrent.Modify( "#"+String( l_nColID )+".TabSequence='"+String( ( l_nColID * 10 ) )+"'" )
									
									//Disable the column depending on edit style type
									CHOOSE CASE Upper( l_dwCurrent.Describe( "#"+String( l_nColID )+".Edit.Style" ) )
										CASE "EDIT"
											l_dwCurrent.Modify( "#"+String( l_nColID )+".Edit.DisplayOnly='Yes'" )
										CASE "CHECKBOX", "RADIOBUTTONS", "DDDW", "DDLB", "EDITMASK" 
											l_dwCurrent.Modify( "#"+String( l_nColID )+".Protect='1'" )
									END CHOOSE											
								END IF
							END IF
						NEXT
						
						l_dwCurrent.Enabled = TRUE
						
						l_cOptions = l_dwCurrent.c_NoRetrieveOnOpen + &
										 l_dwCurrent.c_NoEnablePopup + &
										 l_dwCurrent.c_NoMenuButtonActivation + &
										 l_dwCurrent.c_SelectOnRowFocusChange + &
										 l_dwCurrent.c_SortClickedOK + &
										 l_dwCurrent.c_ModifyOK + &
										 l_dwCurrent.c_ModifyOnOpen
						
						//Need to set this constant here as the fu_SetOptions function resets
						//  it to 'no'
						IF l_dwCurrent.Object.Datawindow.Retrieve.AsNeeded = 'yes' THEN
							l_cOptions += l_dwCurrent.c_RetrieveAsNeeded
						END IF
						
						IF l_uPage.i_nTrArrayIndex > 0 THEN
							
							IF Match (i_trObjects[l_uPage.i_nTrArrayIndex].DBParm, "VOID") THEN
								l_uPage.Enabled = FALSE
								m_iim_tabs.m_file.m_search.Enabled = FALSE
								m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
								l_uPage.i_bAlreadyBuilt = TRUE
							ELSE
								CONNECT USING i_trObjects[l_uPage.i_nTrArrayIndex];
								l_dwCurrent.fu_SetOptions (i_trObjects[l_uPage.i_nTrArrayIndex], &
												l_dwCurrent.c_NullDW, l_cOptions)
								l_uPage.Enabled = TRUE
								m_iim_tabs.m_file.m_search.Enabled = TRUE
								
								IF IsValid( w_create_maintain_case ) THEN
									IF w_create_maintain_case.dw_folder.i_SelectedTab = 5 THEN
										m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = TRUE
									END IF
								END IF
							END IF
							
						ELSE
							
							l_dwCurrent.fu_SetOptions (SQLCA, l_dwCurrent.c_NullDW, l_cOptions)
							
						END IF
						
						//Set the flag to show the datawindow has already been built
						l_uPage.i_bAlreadyBuilt = TRUE
						
						//If we're on the summary datawindow, store the current syntax and sql
						l_uPage.i_cSummarySyntax = i_cSummarySyntax
						IF l_nDWCount = 1 OR l_nDWCounter = 2 THEN
							//If only one datawindow, getting the SQL select from the summary
							//  view.  Otherwise, get from initial view if counter on 2.
							IF Pos( Upper( i_cSummarySyntax ), "EXECUTE " + is_schema_owner ) > 0 THEN
								l_uPage.i_cSummarySQLSelect = l_dwCurrent.Describe( "Datawindow.Table.Procedure" )
							ELSE
								l_uPage.i_cSummarySQLSelect = l_dwCurrent.Describe( "Datawindow.Table.Select" )
							END IF
						END IF
						
						//Store the background color of the datawindow 
						l_uPage.i_cColor = l_dwCurrent.Object.Datawindow.Color
					ELSE
						
						// if datawindow creation fails, the tab fails.
						l_dwCurrent.DataObject = ""
						l_dwCurrent.Enabled = FALSE
						
						//Store the background color of the datawindow 
						l_uPage.i_cColor = l_dwCurrent.Object.Datawindow.Color
						
						l_dwCurrent.Modify ("datawindow.Color='80269524'")
						l_uPage.i_bAlreadyBuilt = TRUE
						RETURN -1
						
					END IF
					
				NEXT
			END IF
		END IF
	ELSE
		//If the tab wasn't successfully created, return a status of failed
		RETURN -1
	END IF
	
	m_create_maintain_case.m_file.m_search.Enabled = TRUE
	
ELSE
	
	// if no tabs are defined, create a blank tab by default.
	IF a_tabFolder.OpenTab (u_iim_tab_page, 0) = 1 THEN
			
		// initialize the tab if it was created properly.
		l_uPage = a_tabFolder.Control[1]
		l_uPage.i_tabParent = a_tabFolder
		l_uPage.i_uParentIIM = THIS
		l_uPage.i_bBlank = TRUE
		l_uPage.text = "No information available."
		l_uPage.i_nTrArrayIndex = 0
		l_uPage.i_bLoaded = FALSE
		l_uPage.i_bAlreadyBuilt = TRUE
		l_uPage.dw_summary_view.DataObject = ""
		
		//register the new tab page with the resize service on the tab object
		IF IsValid( a_TabFolder.inv_resize ) THEN
			a_TabFolder.inv_resize.of_Register( l_uPage, a_TabFolder.inv_resize.SCALERIGHTBOTTOM )
		END IF		
		
	ELSE
			
		// if a tab cannot be created, return a status of failed.
		RETURN -1
		
	END IF
	
	m_create_maintain_case.m_file.m_search.Enabled = FALSE
	
END IF

// if all tabs are created correctly, set tab 1 as current and return a status of success.
IF w_iim_tabs.i_nCurrentPage > 0 THEN
	a_tabFolder.SelectTab( w_iim_tabs.i_nCurrentPage )
ELSE
	a_tabFolder.SelectTab (1)
END IF

RETURN 0
end function

public subroutine uf_builddsnlist ();/*****************************************************************************************
   Function:   uf_BuildDSNList
   Purpose:    Build an array of transaction objects.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/1/00   M. Caruso    Created.
	3/23/00  M. Caruso    Modified code to determine, at run time, the name of the
								 iim_source_id column in the datastore.
	4/3/00   M. Caruso    Added code to prevent adding the system datasource to the array.
*****************************************************************************************/

LONG		l_nRowCount, l_nIndex, l_nRtn
INTEGER	l_nColCount, l_nTrCount
STRING	l_cErrors, l_cErrorMsgs[], l_cColName, l_cDSNCol

// get the name of the source ID column.
l_cColName = Describe ('#2.Name')
l_cDSNCol = Describe ('#4.Name')

// add new datasources to the array
l_nRowCount = RowCount ()
FOR l_nIndex = 1 TO l_nRowCount
	
	// If the current datasource is not the system datasource, add it to the array
	l_nRtn = f_AddDataSource (GetItemNumber (l_nIndex, l_cColName), i_trObjects[], l_cErrors, FALSE)
	CHOOSE CASE l_nRtn
		CASE -1
			l_cErrorMsgs[1] = l_cErrors
			OBJCA.MSG.fu_DisplayMessage ("DSN_ERROR",1,l_cErrorMsgs[])
			
		CASE -2
			l_cErrorMsgs[1] = l_cErrors
			OBJCA.MSG.fu_DisplayMessage ("DSN_NOT_CONNECTED",1,l_cErrorMsgs[])
			
	END CHOOSE
	
NEXT
end subroutine

public function long uf_loaddata (u_dw_std a_dwview, u_dw_std a_dwsource1, u_dw_std a_dwsource2, integer a_ntrindex, boolean a_brefresh, string a_csummarysyntax, string a_csummaryselect);/*****************************************************************************************
   Function:   uf_LoadData
   Purpose:    Load the data for a specific datawindow.
   Parameters: U_DW_STD		a_dwView -
										The datawindow to be loaded
					U_DW_STD		a_dwSource -
										the source of data to pass as arguments
					INTEGER		a_nTrIndex -
										the index of the transaction object for a_dwView
										in i_trObjects[]
					BOOLEAN     a_bRefresh - whether to refresh or rebuild the datawindow
					STRING		a_cSummarySyntax - the original summary syntax with arguments
					STRING		a_cSummarySelect - the original select with arguments
   Returns:    INTEGER		 0+ - the number of rows retrieved
									-1 - there was an error retrieving the rows from the database
									-2 - datawindow column not found
									-3 - datawindow syntax not defined

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/7/00   M. Caruso    Created.
	3/1/00   M. Caruso    Restore current trnasaction object after CREATE.
	3/12/00  M. Caruso    Moved setting of transaction object outside the IF statement for
								 argument processing.
	4/14/00  M. Caruso    Only perform the retrieval if the tab is enabled.
	4/27/00  M. Caruso    Remove trailing asterix from argument name to accomodate the use
								 of arguments from a summary view datawindow.
	5/8/00   M. Caruso    Added column type verification before retrieving argument values.
	06/23/00 C. Jackson   Added return 0 if the retrieval argument value is null
	8/15/2000 K. Claver   Moved SetTransObject for the datawindow outside the IF statement
								 for arguments to ensure the proper transaction object is assigned
								 regardless of the existence of arguments.
	5/3/2001 K. Claver    Added code to start searching for the arguments at the beginning
								 of the SQL if wasn't able to find the argument after the last found
								 argument.
	6/1/2001 K. Claver    Applied IIM Infomaker enhancements.
	7/9/2001 K. Claver    Enhanced to simply change the sql syntax when change source id
								 rather than rebuild the datawindow.
	5/23/2002 K. Claver   Enhanced/fixed to allow null values in the demographics fields
	11/25/2002 K. Claver  Added code to accomodate for stored procs.
*****************************************************************************************/

BOOLEAN		l_bContinue = TRUE, l_bLoop, l_bSummary, l_bFound, l_bTypeError = FALSE, l_bNull = FALSE
BOOLEAN     l_bEqualFound, l_bAutoCommit
STRING		l_cDWSyntax, l_cSQLSelect, l_cArgName, l_cArgType, l_cArgColumn, l_cArgColType
STRING		l_cTableName, l_cColName, l_cColType, l_cArgList, l_cChar, l_cValue, l_cFormat
STRING 		l_cRV
INTEGER		l_nStart, l_nEnd, l_nArgStart, l_nArgEnd, l_nColStart = 0, l_nColEnd, l_nStartPos
INTEGER		l_nSepStart, l_nSepEnd, l_nCount, l_nSpaces, l_nDColStart, l_nDFormatEnd, l_nDiff
INTEGER		l_nRV
LONG			l_nPos, l_nTableID, l_nRow
ANY			l_aValue
U_DW_STD		l_dwSource

// if the tab is enabled, perform the retrieval
IF a_dwView.Enabled THEN
	//Need to set the transaction object autocommit property to true.  
	// NOTE:  THE AUTOCOMMIT PROPERTY FOR THE TRANSACTION ARRAY(i_trObjects) IS
	//			 SET TO TRUE IN THE f_AddDatasource FUNCTION.
	
	l_bAutoCommit = SQLCA.AutoCommit
	SQLCA.AutoCommit = TRUE	
	
	// make sure the transaction object is set properly
	//KMC.  Moved outside IF statement for arguments to ensure
	//  the correct transaction object is assigned regardless
	//  of the existence of arguments.
	IF a_nTrIndex > 0 THEN
		a_dwview.SetTransObject (i_trObjects[a_nTrIndex])
	ELSE
		a_dwview.SetTransObject (SQLCA)
	END IF
	
	IF NOT a_bRefresh THEN
		l_cDWSyntax = a_dwview.describe ("datawindow.syntax")
		
		//Test if a select or a procedure so can set the variable to
		//  modify args.
		IF Pos( Upper( l_cDWSyntax ), "EXECUTE " + is_schema_owner ) > 0 THEN
			l_cSQLSelect = a_dwView.Object.DataWindow.Table.Procedure
		ELSE
			l_cSQLSelect = a_dwview.GetSQLSelect ()
		END IF
	ELSE
		//Set to the tab specific syntax and select.  For refresh rather than
		//  rebuild functionality.
		l_cDWSyntax = a_cSummarySyntax
		l_cSQLSelect = a_cSummarySelect
	END IF
	
	IF Match (l_cDWSyntax, "arguments=((") THEN
		
		// gather argument information
		l_nStart = Pos (l_cDWSyntax, "arguments=((")
		l_nEnd = Pos (l_cDWSyntax, "))", l_nStart) - l_nStart + 2
		l_cArgList = Mid (l_cDWSyntax, l_nStart, l_nEnd)
		
		// process arguments if they exist
		l_nArgStart = 0
		l_nArgEnd = 0
		DO
			
			l_nArgStart = Pos (l_cArgList, "(~"", l_nArgStart + 1)
			IF l_nArgStart > 0 THEN
				
				// get the argument information
				l_nCount ++
				l_nArgStart += 2
				l_nArgEnd = Pos (l_cArgList, "~"", l_nArgStart) - l_nArgStart
				l_cArgName = Mid (l_cArgList, l_nArgStart, l_nArgEnd)
				IF Right (l_cArgName, 8) = '_summary' THEN
					l_cArgColumn = Left (l_cArgName, Len (l_cArgName) - 8)
					l_bSummary = TRUE
				ELSE
					l_cArgColumn = l_cArgName
					l_bSummary = FALSE
				END IF
				
				l_nArgStart += (l_nArgEnd + 3)
				l_nArgEnd = Pos (l_cArgList, ")", l_nArgStart) - l_nArgStart
				l_cArgType = Mid (l_cArgList, l_nArgStart, l_nArgEnd)
				
				// get the column name and type
				l_nColStart = Pos (l_cSQLSelect, ':' + l_cArgName, (l_nColStart + 1 )) -1
				IF l_nColStart = -1 THEN
					//See if we're past the next argument
					l_nColStart = Pos (l_cSQLSelect, ':' + l_cArgName, 1) -1
				END IF
				l_bLoop = TRUE
				l_nSpaces = 0
				l_nColEnd = -1
				DO WHILE l_bLoop
					l_cChar = Mid (l_cSQLSelect, l_nColStart, 1)
					IF l_cChar = ' ' THEN	l_nSpaces ++
					CHOOSE CASE l_nSpaces
						CASE 0, 1
							l_nColStart --
							
						CASE 2
							IF l_cChar = '(' THEN
								l_bLoop = FALSE
								l_nColStart ++
							ELSE
								l_nColEnd ++
								l_nColStart --
							END IF
							
						CASE 3
							l_bLoop = FALSE
							l_nColStart ++
							
					END CHOOSE
						
				LOOP
				
				// Separate table name and column name
				l_cColName = Trim( Mid (l_cSQLSelect, l_nColStart, l_nColEnd) )
				// If there is a quote at the end, trim off before continue
				IF Match( l_cColName, '"' ) THEN
					l_cColName = Mid( l_cColName, 1, ( Len( l_cColName ) - 1 ) )
				END IF
				
				l_nPos = Pos( l_cColName, '"' )
				l_nSepStart = Pos( l_cColName, "." )
				IF Pos( l_cColName, ".", ( l_nSepStart + 1 ) ) > 0 THEN
					//Move to the new seperator						  
					l_nSepStart = Pos( l_cColName, ".", ( l_nSepStart + 1 ) )
					//Owner exists before table name
					l_cColName = Mid( l_cColName, ( l_nSepStart + 1 ), ( Len( l_cColName ) - l_nSepStart ) )
				ELSE
					l_cColName = Mid( l_cColName, ( l_nSepStart + 1 ), ( Len( l_cColName ) - l_nSepStart ) )
				END IF
				
				//If there is a close paren at the end, trim off before continue.
				IF Pos( l_cColName, ")" ) > 0 THEN
					l_cColName = Trim( Mid( l_cColName, 1, ( Pos( l_cColName, ")" ) - 1 ) ) )
				END IF
								
				// get the argument value
				IF l_bSummary THEN
			
					// get the value of the current argument
					IF uf_FindColumnInDW (a_dwSource2, l_cArgColumn) THEN
					
						l_dwSource = a_dwSource2
						l_bFound = TRUE
					
					ELSE
					
						l_bFound = FALSE
					
					END IF
	
				ELSE
	
					IF uf_FindColumnInDW (a_dwSource1, l_cArgColumn) THEN
						
						l_dwSource = a_dwSource1
						l_bFound = TRUE
						
					ELSE
						
						l_bFound = FALSE
						
					END IF
	
				END IF
					
				IF l_bFound THEN
					
					l_cArgColType = UPPER (l_dwSource.describe (l_cArgColumn + '.ColType'))
					l_nRow = l_dwSource.GetRow( )
					CHOOSE CASE l_cArgType
						CASE "number"
							//Just get first three characters to ensure trim off precision, if exists.
							CHOOSE CASE Left( l_cArgColType, 3 )
								//Integer, long, number, real, ulong. 	
								CASE "INT","LON","NUM","REA","ULO"
									l_aValue = l_dwSource.GetItemNumber (l_nRow, l_cArgColumn)
								//Decimal
							   CASE "DEC"
									l_aValue = l_dwSource.GetItemDecimal (l_nRow, l_cArgColumn)
								
								CASE ELSE
									l_bTypeError = TRUE
									
							END CHOOSE
																
						CASE "string"
							//Just get first four characters to ensure trim off precision
							CHOOSE CASE Left( l_cArgColType, 4 )
								CASE "CHAR"
									l_aValue = l_dwSource.GetItemString (l_nRow, l_cArgColumn)
									
								CASE ELSE
									l_bTypeError = TRUE
									
							END CHOOSE
													  
						CASE "date"
							CHOOSE CASE l_cArgColType
								CASE "DATE"
									l_aValue = l_dwSource.GetItemDate (l_nRow, l_cArgColumn)
									
								CASE ELSE
									l_bTypeError = TRUE
									
							END CHOOSE
																
						CASE "time"
							CHOOSE CASE l_cArgColType
								CASE "TIME"
									l_aValue = l_dwSource.GetItemTime (l_nRow, l_cArgColumn)
									
								CASE ELSE
									l_bTypeError = TRUE
									
							END CHOOSE
																
						CASE "datetime"
							CHOOSE CASE l_cArgColType
								CASE "DATETIME"
									l_aValue = l_dwSource.GetItemDateTime (l_nRow, l_cArgColumn)
									
								CASE ELSE
									l_bTypeError = TRUE
									
							END CHOOSE
																
					END CHOOSE
					
					// If the retrieval argument is null, then return (SCR 676)
					IF ISNULL(l_aValue) THEN
						l_bNull = TRUE
					ELSE
						l_bNull = FALSE
					END IF
					
					// If the column data type is wrong, report the error and abort the load process.
					IF l_bTypeError THEN
						
						messagebox (gs_AppName, "The column '" + l_cArgColumn + "' in this view has been defined with the~r~n" + &
															  "incorrect data type.  Please correct this error before using this view again.")
						SQLCA.AutoCommit = l_bAutoCommit
						RETURN 0
						
					END IF
					
				ELSE
					
					messagebox (gs_AppName, "One of the columns defined in the view was not found.~r~n" + &
														  "Please verify that the view definition is correct.")
					SQLCA.AutoCommit = l_bAutoCommit
					RETURN 0
					
				END IF
				
				//Check to see if the column is one that will be converted to a
				//  datetime value
				//Add a "^" to the end for an exact match
				IF NOT l_bNull THEN
					l_cColName += "^"
					l_nDColStart = Pos( i_cConvertToDate, Upper( l_cColName ) )
					IF l_nDColStart > 0 THEN
						l_nDFormatEnd = Pos( i_cConvertToDate, "^", ( Pos( i_cConvertToDate, "^", l_nDColStart ) + 1 ) )
						IF l_nDFormatEnd = 0 THEN
							//Take the rest
							l_cFormat = Mid( i_cConvertToDate, ( Pos( i_cConvertToDate, "^", l_nDColStart ) + 1 ) )
						ELSE
							//Take just the format part
							l_cFormat = Mid( i_cConvertToDate, ( Pos( i_cConvertToDate, "^", l_nDColStart ) + 1 ), &
												( l_nDFormatEnd - ( Pos( i_cConvertToDate, "^", l_nDColStart ) + 1 ) ) )
						END IF
						
						l_aValue = THIS.uf_DateByFormat( l_aValue, l_cFormat )
					END IF
				
				
					// convert argument value to column data type
					l_cValue = uf_ConvertValue (l_cArgType, l_aValue)
				
					// replace argument in l_CSQLSelect with converted value
					l_cSQLSelect = Replace (l_cSQLSelect, Pos (l_cSQLSelect, ":" + l_cArgName), &
											Len (l_cArgName) + 1, l_cValue)
				ELSE
					// replace argument in l_cSQLSelect with "is null".  First, back up until find "="
					l_nStartPos = Pos (l_cSQLSelect, ":" + l_cArgName)
					l_bEqualFound = FALSE
					DO WHILE NOT l_bEqualFound
						l_nStartPos --
						IF Mid( l_cSQLSelect, l_nStartPos, 1 ) = "=" THEN
							l_bEqualFound = TRUE
						END IF
					LOOP
					
					//Get the difference between the normal start position and the position of the "="
					l_nDiff = ( Pos( l_cSQLSelect, ":" + l_cArgName ) - l_nStartPos )
					
					//Replace with "is null"
					l_cSQLSelect = Replace( l_cSQLSelect, l_nStartPos, ( Len( l_cArgName ) + 1 + l_nDiff ), "is null" )					
				END IF
									
				//If there are other arguments with the same name, loop until find all
				IF Pos (l_cSQLSelect, ':' + l_cArgName, (l_nColStart + 1 )) > 0 THEN
					l_nArgStart -= ( Len( l_cArgName ) + 6 )
				END IF
				
			ELSE
				l_bContinue = FALSE
			END IF
			
		LOOP WHILE l_bContinue
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// JWhite Added 8.23.2005
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_replace_all(l_cSQLSelect, "'", "~~'")

		string ls_modstring
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// End Added JWhite 8.23.2005
		//-----------------------------------------------------------------------------------------------------------------------------------

		
		
		// update SQLSelect OR Procedure in datawindow
		IF Pos( Upper( l_cDWSyntax ), "EXECUTE " + is_schema_owner ) > 0 THEN
			ls_modstring = "DataWindow.Table.Procedure=~'" + l_cSQLSelect + "~'"
			l_cRV = a_dwView.Modify(ls_modstring)
		ELSE
			ls_modstring = "DataWindow.Table.Select=~'" + l_cSQLSelect + "~'"
			l_cRV = a_dwView.Modify(ls_modstring)
		END IF
		
		IF Trim( l_cRV ) <> "" THEN
			MessageBox( gs_AppName, "Unable to modify the select to include the retrieval value(s)", StopSign!, OK! )
			SQLCA.AutoCommit = l_bAutoCommit
			RETURN 0
		END IF
		
		//If refresh, do not re-create the datawindow
		IF NOT a_bRefresh THEN
			// remove the "arguments" clause from the syntax
			l_cDWSyntax = a_dwview.describe ("datawindow.syntax")
			l_nStart = Pos (l_cDWSyntax, "arguments=((")
			l_nEnd = Pos (l_cDWSyntax, "))", l_nStart) + 2
			l_cDWSyntax = Left (l_cDWSyntax, l_nStart - 2) + Mid (l_cDWSyntax, l_nEnd)
			IF a_dwview.Create (l_cDWSyntax) = -1 THEN
				messagebox (gs_AppName, 'The application was unable to create the current view.')
				SQLCA.AutoCommit = l_bAutoCommit
				RETURN 0
			END IF
		END IF
		
	END IF
	
	// make sure the transaction object is set properly
	//KMC.  Moved outside IF statement for arguments to ensure
	//  the correct transaction object is assigned regardless
	//  of the existence of arguments.
	IF a_nTrIndex > 0 THEN
		a_dwview.SetTransObject (i_trObjects[a_nTrIndex])
	ELSE
		a_dwview.SetTransObject (SQLCA)
	END IF
	
	// retrieve the datawindow
	l_nRV = a_dwview.retrieve ()
	
	SQLCA.AutoCommit = l_bAutoCommit
	
	RETURN l_nRV
END IF
end function

on u_iim.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_iim.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

