$PBExportHeader$u_tabpage_args.sru
forward
global type u_tabpage_args from u_tabpg_std
end type
type dw_args from datawindow within u_tabpage_args
end type
end forward

global type u_tabpage_args from u_tabpg_std
integer width = 3136
string text = "Retrieval Arguments"
dw_args dw_args
end type
global u_tabpage_args u_tabpage_args

forward prototypes
public function string fu_applyargs (string a_cdwsyntax)
end prototypes

public function string fu_applyargs (string a_cdwsyntax);/*****************************************************************************************
   Function:   fu_ApplyArgs
   Purpose:    Replace the current arguments in the datawindow with the system defined
					associated arguments.
   Parameters: a_cDWSyntax - String containing the datawindow syntax
   Returns:    The modified datawindow syntax.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver    Created.
*****************************************************************************************/
Integer l_nRowCount, l_nIndex
String l_cReplaceArg, l_cNewArg
Long l_nArgStringStart, l_nArgStringEnd, l_nArgPos

l_nRowCount = dw_args.RowCount( )

IF l_nRowCount > 0 THEN
	l_nArgStringStart = Pos( Upper( a_cDWSyntax ), "ARGUMENTS=((" )
	l_nArgStringEnd = Pos( a_cDWSyntax, "))", l_nArgStringStart )
	
	FOR l_nIndex = 1 TO l_nRowCount
		l_cReplaceArg = Trim( dw_args.GetItemString( l_nIndex, "report_arg" ) )
		l_cNewArg = Trim( Mid( dw_args.GetItemString( l_nIndex, "assoc_arg" ), 2 ) )
		
		IF l_cNewArg <> "" THEN
			l_nArgPos = Pos( a_cDWSyntax, l_cReplaceArg )
			DO WHILE l_nArgPos > 0
				//Only replace if the field is prefixed by a colon or if the string
				//  is contained in the arguments portion of the syntax
				IF ( Mid( a_cDWSyntax, ( l_nArgPos - 1 ), 1 ) = ":" ) OR &
					( Mid( a_cDWSyntax, ( l_nARgPos - 13 ), 13 ) = "ARG(NAME = ~~~"" ) OR &
					( l_nArgPos > l_nArgStringStart AND l_nArgPos < l_nArgStringEnd ) THEN
					a_cDWSyntax = Replace( a_cDWSyntax, l_nArgPos, Len( l_cReplaceArg ), l_cNewArg )
				END IF
				
				l_nArgPos = Pos( a_cDWSyntax, l_cReplaceArg, ( l_nArgPos + 1 ) )
				
				//Need to update the start and end positions of the argument string as
				//  the replacement argument may be longer than the initial argument 
				//  causing the start and end positions to move out.
				l_nArgStringStart = Pos( Upper( a_cDWSyntax ), "ARGUMENTS=((" )
				l_nArgStringEnd = Pos( a_cDWSyntax, "))", l_nArgStringStart )
			LOOP
		END IF
	NEXT
	
	//Reset and re-load with the new arguments
	dw_args.Reset( )
	dw_args.Event Trigger ue_GetArgs( a_cDWSyntax )
END IF

RETURN a_cDWSyntax
end function

on u_tabpage_args.create
int iCurrent
call super::create
this.dw_args=create dw_args
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_args
end on

on u_tabpage_args.destroy
call super::destroy
destroy(this.dw_args)
end on

type dw_args from datawindow within u_tabpage_args
event ue_buildarglist ( s_dwpainter_parms a_sparms )
event ue_getargs ( string a_cdwsyntax )
integer x = 14
integer y = 12
integer width = 3099
integer height = 408
integer taborder = 10
string title = "none"
string dataobject = "d_args"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_buildarglist;///*****************************************************************************************
//   Function:   ue_buildarglist
//   Purpose:    Add all of the fields in the source datawindow to the argument dropdown
//					list box.
//   Parameters: a_sParms - Parms passed to the datawindow painter 
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	  3/23/00  M. Caruso    Created.
//	  5/23/2001 K. Claver   Adapted for use in the new Infomaker datawindow association window.
//	  06/12/03 M. Caruso    Added code to display the updated field labels for the fixed fields
//									and eliminated three copies of the same code for gathering those
//									values by making one copy generic for all source types. This was
//									done by setting dataobject and source type variables and referencing
//									them in the arg list code.
//   06/16/03 M. Caruso    Added statement to create l_dsSummaryView and moved DESTROY statements
//									outside of the IF statement to ensure the variables ALWAYS get
//									removed from memory.
//*****************************************************************************************/

LONG			l_nRow
INTEGER		l_nLoop, l_nIndex, l_nColCount, l_nRowCount
STRING		l_cColName, l_cCodeTable, l_cLabel, l_cSQLSelect, l_cDWSyntax, l_cError
STRING      l_cSummarySyntax, l_cArgList, l_cDataObject, l_cSourceType
DATASTORE	l_dsAvailableCols, l_dsConfigurableFields, l_dsSummaryView

l_cSummarySyntax = a_sParms.summary_syntax

// create the datastore objects to be used
l_dsAvailableCols = CREATE datastore
l_dsConfigurableFields = CREATE datastore
l_dsSummaryView = CREATE datastore

IF a_sParms.a_cMembers = 'Y' THEN
	l_cDataObject = 'd_demographics_consumer'
	l_cSourceType = 'C'
ELSEIF a_sParms.a_cProviders = 'Y' THEN
	l_cDataObject = 'd_demographics_provider'
	l_cSourceType = 'P'
ELSEIF a_sParms.a_cGroups = 'Y' THEN
	l_cDataObject = 'd_demographics_employer'
	l_cSourceType = 'E'
ELSEIF a_sParms.a_cOthers = 'Y' THEN
	l_cDataObject = 'd_demographics_other'
	l_cSourceType = 'O'
ELSE
	l_cDataObject = ''
	l_cSourceType = ''
END IF

IF l_cDataObject <> '' THEN
	
	// determine which fields are available
	l_dsAvailableCols.DataObject = l_cDataObject
	l_dsAvailableCols.SetTransObject (SQLCA)
	
	// create the lookup datasource for configurable fields and field label info
	l_cSQLSelect = 'SELECT cusfocus.field_definitions.column_name, ' + &
								 'cusfocus.field_definitions.field_order, ' + &
								 'cusfocus.field_definitions.field_label ' + &
						'FROM cusfocus.field_definitions ' + &
						'WHERE cusfocus.field_definitions.source_type = ~'' + l_cSourceType + '~''
	l_cDWSyntax = SQLCA.SyntaxFromSQL (l_cSQLSelect, '', l_cError)
	l_dsConfigurableFields.Create (l_cDWSyntax, l_cError)
	l_dsConfigurableFields.SetTransObject (SQLCA)
	l_nRowCount = l_dsConfigurableFields.Retrieve ()
	
	l_nColCount = INTEGER (l_dsAvailableCols.describe ('datawindow.column.count'))
	FOR l_nIndex = 1 TO l_nColCount
		
		l_cColName = l_dsAvailableCols.describe ('#' + STRING (l_nIndex) + '.Name')
			
		l_nRow = l_dsConfigurableFields.Find ("column_name = '" + l_cColName + "' and field_order = 0", 1, l_nRowCount)
		CHOOSE CASE l_nRow
			CASE IS > 0
				l_cLabel = l_dsConfigurableFields.GetItemString (l_nRow, 'field_label')
				
			CASE 0
				l_cLabel = l_cColName
				f_StringReplaceAll( l_cLabel, "_", " " )
				l_cLabel = f_WordCap( l_cLabel )
			
		END CHOOSE
			
		IF l_cArgList <> "" THEN l_cArgList += '/'
		l_cArgList += (l_cLabel + '~t:' + l_cColName)
			
	NEXT
	
	// add configurable fields for members
	FOR l_nIndex = 1 TO l_nRowCount
			
		IF l_dsConfigurableFields.GetItemNumber (l_nIndex,'field_order') > 0 THEN
			
			// only process for configurable fields (not re-labeled fields)
			l_cColName = l_dsConfigurableFields.GetItemString (l_nIndex,'column_name')
			l_cLabel = l_dsConfigurableFields.GetItemString (l_nIndex,'field_label')
			IF Right (l_cLabel, 1) = ':' THEN l_cLabel = Left (l_cLabel, len (l_cLabel) - 1)
			IF l_cArgList <> "" THEN l_cArgList += '/'
			l_cArgList += (l_cLabel + '~t:' + l_cColName)
			
		END IF
			
	NEXT
	
	IF a_sParms.view_type = "detail" THEN
		
		// add fields from the associated summary view
		IF (l_cSummarySyntax <> "") AND NOT IsNull (l_cSummarySyntax) THEN
			//If the manual or graphical flag exists, remove before continue
			IF ( Match( l_cSummarySyntax, "(M)" ) AND Pos( l_cSummarySyntax, "(M)" ) = 1 ) OR &
				( Match( l_cSummarySyntax, "(G)" ) AND Pos( l_cSummarySyntax, "(G)" ) = 1 ) THEN
				l_cSummarySyntax = Mid( l_cSummarySyntax, 4 )
			END IF
			
			//Remove the header info from the datawindow syntax
			IF Pos( Upper( l_cSummarySyntax ), "RELEASE" ) > 1 THEN 
				l_cSummarySyntax = Mid( l_cSummarySyntax, Pos( Upper( l_cSummarySyntax ), "RELEASE" ) )
			END IF
			
			//If there are fields to be converted to dates in the summary setup, parse off before 
			//  process the rest
			IF Match( l_cSummarySyntax, "#CD#" ) THEN
				l_cSummarySyntax = Mid( l_cSummarySyntax, 1, ( Pos( l_cSummarySyntax, "#CD#" ) - 1 ) )
			END IF	
			
			IF l_dsSummaryView.Create (l_cSummarySyntax) = 1 THEN
				
				l_dsSummaryView.SetTransObject (SQLCA)
				l_nColCount = INTEGER (l_dsSummaryView.describe ('datawindow.column.count'))
				FOR l_nIndex = 1 TO l_nColCount
					
					l_cColName = l_dsSummaryView.describe ('#' + STRING (l_nIndex) + '.Name')
					IF Upper (l_dsSummaryView.describe (l_cColName + '.Visible')) = '1' THEN
						
						l_cLabel = l_dsSummaryView.describe (l_cColName + '_t.Text')
						IF Right (l_cLabel, 1) = ':' THEN l_cLabel = Left (l_cLabel, len (l_cLabel) - 1)
						
					ELSE
						
						l_cLabel = l_cColName
						f_StringReplaceAll( l_cLabel, "_", " " )
						l_cLabel = f_WordCap( l_cLabel )
						
					END IF
					
					l_cLabel += ' - Summary View'
					IF l_cArgList <> "" THEN l_cArgList += '/'
					l_cArgList += (l_cLabel + '~t:' + l_cColName + '_summary')
					
				NEXT
				
			END IF
			
		END IF
		
	END IF
	
	IF Trim( l_cArgList ) <> "" THEN
		//Check for quotes(single or double) in the string as they will not allow setting the drop down values.
		//  Will throw a non-descript error "Error accessing external object property values...".  Also remove
		//  return character with new line.
		
		//Double Quotes
		IF Pos( l_cArgList, '"' ) > 0 THEN
			//Remove all double quotes
			f_StringReplaceAll( l_cArgList, '"', '' )
		END IF
		
		//Single Quotes
		IF Pos( l_cArgList, "'" ) > 0 THEN
			//Remove all single quotes
			f_StringReplaceAll( l_cArgList, "'", "" )
		END IF
		
		//Return Character with new line
		IF Pos( l_cArgList, "~r~n" ) > 0 THEN
			//Remove all return characters with new line
			f_StringReplaceAll( l_cArgList, "~r~n", " " )
		END IF
		
		THIS.Object.assoc_arg.Values = l_cArgList
	END IF
	
END IF

// perform garbage collection on datastores
DESTROY l_dsAvailableCols
DESTROY l_dsConfigurableFields
DESTROY l_dsSummaryView
	
end event

event ue_getargs;/*****************************************************************************************
   Event:      ue_GetArgs
   Purpose:    Get a list of arguments from the datawindow
   Parameters: a_dwSyntax - the datawindow syntax
   Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	5/25/2001 K. Claver    Created.
*****************************************************************************************/
String l_cArgString, l_cArg, l_cType
Long l_nArgStringStart, l_nArgStringEnd
Integer l_nNextArgPos, l_nSepPos = 1, l_nRow, l_nEndPos

THIS.Reset( )

//Add a space before the word arguments so doesn't pick up the nested arguments.
l_nArgStringStart = Pos( a_cDWSyntax, " arguments=((" )

IF l_nArgStringStart > 0 THEN
	l_nArgStringEnd = Pos( a_cDWSyntax, "))", l_nArgStringStart )
	
	l_cArgString = Mid( a_cDWSyntax, l_nArgStringStart, ( ( l_nArgStringEnd - l_nArgStringStart ) + 2 ) )
	
	l_nNextArgPos = Pos( l_cArgString, "~"" )
	DO		
		l_nSepPos = Pos( l_cArgString, ",", l_nNextArgPos )
		l_nEndPos = Pos( l_cArgString, ")", l_nSepPos )
		l_cArg = Trim( Mid( l_cArgString, ( l_nNextArgPos + 1 ), ( ( l_nSepPos - l_nNextArgPos ) - 2 ) ) )
		l_cType = Trim( Mid( l_cArgString, ( l_nSepPos + 1 ), ( ( l_nEndPos - l_nSepPos ) - 1 ) ) )
		l_nRow = THIS.InsertRow( 0 )
		THIS.Object.report_arg[ l_nRow ] = l_cArg
		THIS.Object.arg_type[ l_nRow ] = l_cType
	   
		l_nNextArgPos = Pos( l_cArgString, "~"", l_nSepPos )
	LOOP WHILE l_nNextArgPos > 0
END IF


end event

