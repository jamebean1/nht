$PBExportHeader$n_pivot_table_element.sru
$PBExportComments$All Versions
forward
global type n_pivot_table_element from nonvisualobject
end type
end forward

global type n_pivot_table_element from nonvisualobject
end type
global n_pivot_table_element n_pivot_table_element

type variables
Public:
	Long		ColumnID
	Long		WeightedAverageColumnID
	Long		Count
	Long		GraphType
	Long		Width
	Long		PivotTableColumnID
	Long		PivotTableRowID
	String	AggregateFunction
	String	Column
	String	WeightedAverageColumn
	String	ColumnAggregateFunction
	String	ColumnAllAggregateFunction
	String	Datatype
	String	Description
	String	EditStyle
	String	ElementType
	String	Expression
	String	Format
	String	RowAggregateFunction
	String	PivotTableColumnName
	String	PivotTableRowName
	String	SortDirection
	Boolean	ForceSingleColumn
	Boolean	IsComputed
	Boolean	IsGraph
	Boolean	IsLegend
	Boolean	IsExpression
	Boolean	ShowColumnTotals
	Boolean	ShowRowTotals
	Boolean	ShowColumnTotalsMultiple
	Boolean	ExcludeZeroRows
	Boolean	TitleIsOverridden /* Delete */
	Boolean	AllowExpandingGroups
	Boolean	ShowHeader
	Boolean	ShowFooter
	Boolean	ShowBitmap
	Boolean	AlwaysUseGroupBySortingFirst
	Long		BitmapX
	Long		BitmapY
	Long		BitmapWidth
	Long		BitmapHeight
	Long		ZoomPercentage
	String	AdditionalDescription
	String	BitmapFilename
	String	FooterExpression
	String	FooterAggregateLabel
	String	TitleType				/* 'A' - Automatically Generated, 'C' - Custom Title , 'N' - None */
	String	ColumnWidthType		/* 'O' - Original Column, 'C' - Custom Width, 'B' - Best Fit, 'H' - Best Fit Header and Column */
	
	Boolean	ShowPageNumber
	Long		FooterHeight
	Long		HeaderHeight
	Long		FontSize
	String	FontName
	String	FormatType				/* 'O' - Original Column, 'C' - Custom Format */
	
	
	Boolean	GroupResetPageCount
	Boolean	GroupNewPageOnGroupBreak
	Boolean	ShowFirstGroupAsSeparateReport
	String	FillInDateGaps
	String	DateGapType
	Boolean	CreateGroup
	Boolean	SuppressRepeatingValues
	Boolean	ModifyColumnHeaderHeight
	Long		ColumnHeaderHeight
	
	
	
	
	Boolean	ShowRowLabels
	Boolean	ShowColumnLabels
	
	Boolean	OverrideRowAggregateFunction
	Boolean	OverrideColumnAggregateFunction

	String	ReportingDisplayObject
end variables

forward prototypes
public function n_pivot_table_element of_clone ()
public function string of_get (string as_column)
public subroutine of_get_properties (ref string as_properties[], boolean ab_onlyoneswithvalues)
public subroutine of_reset ()
public subroutine of_set (string as_column, string as_value)
end prototypes

public function n_pivot_table_element of_clone ();n_pivot_table_element ln_pivot_table_element

ln_pivot_table_element = Create n_pivot_table_element

ln_pivot_table_element.ColumnID						= This.ColumnID
ln_pivot_table_element.WeightedAverageColumnID	= This.WeightedAverageColumnID
ln_pivot_table_element.Count							= This.Count
ln_pivot_table_element.GraphType						= This.GraphType
ln_pivot_table_element.Width							= This.Width
ln_pivot_table_element.PivotTableColumnID			= This.PivotTableColumnID
ln_pivot_table_element.PivotTableRowID				= This.PivotTableRowID

ln_pivot_table_element.AggregateFunction				= This.AggregateFunction
ln_pivot_table_element.Column								= This.Column
ln_pivot_table_element.WeightedAverageColumn			= This.WeightedAverageColumn
ln_pivot_table_element.ColumnAggregateFunction		= This.ColumnAggregateFunction
ln_pivot_table_element.ColumnAllAggregateFunction	= This.ColumnAllAggregateFunction
ln_pivot_table_element.Datatype							= This.Datatype
ln_pivot_table_element.Description						= This.Description
ln_pivot_table_element.EditStyle							= This.EditStyle
ln_pivot_table_element.ElementType						= This.ElementType
ln_pivot_table_element.Expression						= This.Expression
ln_pivot_table_element.Format								= This.Format
ln_pivot_table_element.RowAggregateFunction			= This.RowAggregateFunction
ln_pivot_table_element.PivotTableColumnName			= This.PivotTableColumnName
ln_pivot_table_element.PivotTableRowName				= This.PivotTableRowName
ln_pivot_table_element.SortDirection					= This.SortDirection

ln_pivot_table_element.ForceSingleColumn			= This.ForceSingleColumn
ln_pivot_table_element.IsComputed					= This.IsComputed
ln_pivot_table_element.IsExpression					= This.IsExpression
ln_pivot_table_element.IsGraph						= This.IsGraph
ln_pivot_table_element.IsLegend						= This.IsLegend
ln_pivot_table_element.ShowColumnTotals			= This.ShowColumnTotals
ln_pivot_table_element.ShowRowTotals				= This.ShowRowTotals
ln_pivot_table_element.ShowColumnTotalsMultiple	= This.ShowColumnTotalsMultiple
ln_pivot_table_element.ExcludeZeroRows				= This.ExcludeZeroRows
ln_pivot_table_element.TitleIsOverridden			= This.TitleIsOverridden
ln_pivot_table_element.AllowExpandingGroups		= This.AllowExpandingGroups

ln_pivot_table_element.ShowHeader					= This.ShowHeader
ln_pivot_table_element.ShowFooter					= This.ShowFooter
ln_pivot_table_element.ShowBitmap					= This.ShowBitmap
ln_pivot_table_element.BitmapX						= This.BitmapX
ln_pivot_table_element.BitmapY						= This.BitmapY
ln_pivot_table_element.BitmapWidth					= This.BitmapWidth
ln_pivot_table_element.BitmapHeight					= This.BitmapHeight
ln_pivot_table_element.ZoomPercentage				= This.ZoomPercentage
ln_pivot_table_element.AdditionalDescription		= This.AdditionalDescription
ln_pivot_table_element.BitmapFilename				= This.BitmapFilename
ln_pivot_table_element.FooterExpression			= This.FooterExpression
ln_pivot_table_element.FooterAggregateLabel		= This.FooterAggregateLabel
ln_pivot_table_element.TitleType						= This.TitleType
ln_pivot_table_element.ColumnWidthType				= This.ColumnWidthType

ln_pivot_table_element.ShowPageNumber				= This.ShowPageNumber
ln_pivot_table_element.FooterHeight					= This.FooterHeight
ln_pivot_table_element.HeaderHeight					= This.HeaderHeight
ln_pivot_table_element.FontSize						= This.FontSize
ln_pivot_table_element.FontName						= This.FontName
ln_pivot_table_element.FormatType					= This.FormatType

ln_pivot_table_element.GroupResetPageCount				= This.GroupResetPageCount
ln_pivot_table_element.GroupNewPageOnGroupBreak			= This.GroupNewPageOnGroupBreak
ln_pivot_table_element.ShowFirstGroupAsSeparateReport	= This.ShowFirstGroupAsSeparateReport

ln_pivot_table_element.FillInDateGaps						= This.FillInDateGaps
ln_pivot_table_element.DateGapType							= This.DateGapType

ln_pivot_table_element.CreateGroup							= This.CreateGroup
ln_pivot_table_element.SuppressRepeatingValues			= This.SuppressRepeatingValues
ln_pivot_table_element.ModifyColumnHeaderHeight			= This.ModifyColumnHeaderHeight
ln_pivot_table_element.ColumnHeaderHeight					= This.ColumnHeaderHeight

ln_pivot_table_element.ShowRowLabels								= This.ShowRowLabels
ln_pivot_table_element.ShowColumnLabels							= This.ShowColumnLabels
ln_pivot_table_element.OverrideColumnAggregateFunction		= This.OverrideColumnAggregateFunction
ln_pivot_table_element.OverrideRowAggregateFunction			= This.OverrideRowAggregateFunction
ln_pivot_table_element.ReportingDisplayObject					= This.ReportingDisplayObject
ln_pivot_table_element.AlwaysUseGroupBySortingFirst			= This.AlwaysUseGroupBySortingFirst

Return ln_pivot_table_element

end function

public function string of_get (string as_column);Choose Case Lower(Trim(as_column))
	Case 'columnid'
		Return String(This.ColumnID)
	Case 'weightedaveragecolumnid'
		Return String(This.WeightedAverageColumnID)
	Case 'count'
		Return String(This.Count)
	Case 'graphtype'
		Return String(This.GraphType)
	Case 'width'
		Return String(This.Width)
	case 'bitmapx'
		Return String(this.bitmapx)
	case 'bitmapy'
		Return String(this.bitmapy)
	case 'bitmapwidth'
		Return String(this.bitmapwidth)
	case 'bitmapheight'
		Return String(this.bitmapheight)
	case 'zoompercentage'
		Return String(this.zoompercentage)
	case 'footerheight'
		Return String(this.footerheight)
	case 'headerheight'
		Return String(this.headerheight)
	case 'fontsize'
		Return String(this.fontsize)
	Case 'pivottablecolumnid'
		Return String(This.PivotTableColumnID)
	Case 'pivottablerowid'
		Return String(This.PivotTableRowID)
	Case 'aggregatefunction'
		Return This.AggregateFunction
	Case 'column'
		Return This.Column
	Case 'weightedaveragecolumn'
		Return This.WeightedAverageColumn
	Case 'columnaggregatefunction'
		Return This.ColumnAggregateFunction
	Case 'columnallaggregatefunction'
		Return This.ColumnAllAggregateFunction
	Case 'datatype'
		Return This.Datatype
	Case 'description'
		Return This.Description
	Case 'editstyle'
		Return This.EditStyle
	Case 'elementtype'
		Return This.ElementType
	Case 'expression'
		Return This.Expression
	Case 'format'
		Return This.Format
	Case 'rowaggregatefunction'
		Return This.RowAggregateFunction
	Case 'pivottablecolumnname'
		Return This.PivotTableColumnName
	Case 'pivottablerowname'
		Return This.PivotTableRowName
	Case 'sortdirection'
		Return This.SortDirection
	case 'additionaldescription'
		Return this.additionaldescription
	case 'bitmapfilename'
		Return this.bitmapfilename
	case 'footerexpression'
		Return this.footerexpression
	case 'footeraggregatelabel'
		Return this.footeraggregatelabel
	case 'titletype'
		Return this.titletype
	case 'columnwidthtype'
		Return this.columnwidthtype		
	case 'fontname'
		Return this.FontName
	Case 'formattype'
		Return This.FormatType
	case 'fillindategaps'
		Return this.FillInDateGaps
	Case 'dategaptype'
		Return This.DateGapType
	Case 'forcesinglecolumn'
		If This.ForceSingleColumn Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'iscomputed'
		If This.IsComputed Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'isexpression'
		If This.IsExpression Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'isgraph'
		If This.IsGraph Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'islegend'
		If This.IsLegend Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'showcolumntotals'
		If This.ShowColumnTotals Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'showrowtotals'
		If This.ShowRowTotals Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'showcolumntotalsmultiple'
		If This.ShowColumnTotalsMultiple Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'excludezerorows'
		If This.ExcludeZeroRows Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'titleisoverridden'
		If This.TitleIsOverridden Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'allowexpandinggroups'
		If This.AllowExpandingGroups Then
			Return 'true'
		Else
			Return 'false'
		End If
	case 'showheader'
		If This.showheader Then
			Return 'true'
		Else
			Return 'false'
		End If
	case 'showfooter'
		If This.showfooter Then
			Return 'true'
		Else
			Return 'false'
		End If
	case 'showbitmap'
		If This.showbitmap Then
			Return 'true'
		Else
			Return 'false'
		End If
	case 'showpagenumber'
		If This.ShowPageNumber Then
			Return 'true'
		Else
			Return 'false'
		End If
	case 'groupresetpagecount'
		If This.GroupResetPageCount Then
			Return 'true'
		Else
			Return 'false'
		End If
	case 'groupnewpageongroupbreak'
		If This.GroupNewPageOnGroupBreak Then
			Return 'true'
		Else
			Return 'false'
		End If
	case 'showfirstgroupasseparatereport'
		If This.ShowFirstGroupAsSeparateReport Then
			Return 'true'
		Else
			Return 'false'
		End If
	case 'creategroup'
		If This.CreateGroup Then
			Return 'true'
		Else
			Return 'false'
		End If
	case 'suppressrepeatingvalues'
		If This.SuppressRepeatingValues Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'modifycolumnheaderheight'
		If This.ModifyColumnHeaderHeight Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'columnheaderheight'
		Return String(ColumnHeaderHeight)
	Case 'showrowlabels'
		If ShowRowLabels Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'showcolumnlabels'
		If ShowColumnLabels Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'overridecolumnaggregatefunction'
		If OverrideColumnAggregateFunction Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'overriderowaggregatefunction'
		If OverrideRowAggregateFunction Then
			Return 'true'
		Else
			Return 'false'
		End If
	Case 'reportingdisplayobject'
		Return ReportingDisplayObject
	Case 'alwaysusegroupbysortingfirst'
		If AlwaysUseGroupBySortingFirst Then
			Return 'true'
		Else
			Return 'false'
		End If
End Choose

Return ''
end function

public subroutine of_get_properties (ref string as_properties[], boolean ab_onlyoneswithvalues);String as_empty[]
String	ls_bitmapfilename = 'Module - Reporting Desktop - Pivot Table Wizard.bmp'

as_properties[] = as_empty[]

Choose Case Lower(Trim(This.ElementType))
	Case 'properties'
		If Not ab_onlyoneswithvalues Or This.IsGraph 											Then as_properties[UpperBound(as_properties[]) + 1]	= 'IsGraph'
		If Not ab_onlyoneswithvalues Or (Not This.IsLegend and This.IsGraph)				Then as_properties[UpperBound(as_properties[]) + 1]	= 'IsLegend'
		If Not ab_onlyoneswithvalues Or This.GraphType	<> 11 								Then as_properties[UpperBound(as_properties[]) + 1]	= 'GraphType'
		If Not ab_onlyoneswithvalues Or This.ColumnAllAggregateFunction <> 'sum' 		Then as_properties[UpperBound(as_properties[]) + 1]	= 'ColumnAllAggregateFunction'
		If Not ab_onlyoneswithvalues Or This.ExcludeZeroRows 									Then as_properties[UpperBound(as_properties[]) + 1]	= 'ExcludeZeroRows'
		If Not ab_onlyoneswithvalues Or This.AllowExpandingGroups 							Then as_properties[UpperBound(as_properties[]) + 1]	= 'AllowExpandingGroups'
		If Not ab_onlyoneswithvalues Or Not This.ShowHeader									Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowHeader'
		If Not ab_onlyoneswithvalues Or Not This.ShowFooter									Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowFooter'
		If Not ab_onlyoneswithvalues Or Not This.ShowBitmap									Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowBitmap'
		If Not ab_onlyoneswithvalues Or This.ZoomPercentage <> 100							Then as_properties[UpperBound(as_properties[]) + 1]	= 'ZoomPercentage'
		If Not ab_onlyoneswithvalues Or This.AdditionalDescription <> ''					Then as_properties[UpperBound(as_properties[]) + 1]	= 'AdditionalDescription'
		If Not ab_onlyoneswithvalues Or This.FooterExpression <> ''							Then as_properties[UpperBound(as_properties[]) + 1]	= 'FooterExpression'
		If Not ab_onlyoneswithvalues Or This.FooterAggregateLabel <> ''					Then as_properties[UpperBound(as_properties[]) + 1]	= 'FooterAggregateLabel'
		If Not ab_onlyoneswithvalues Or This.TitleType <> 'O'									Then as_properties[UpperBound(as_properties[]) + 1]	= 'TitleType'
		If Not ab_onlyoneswithvalues Or (This.Description <> '' And TitleType = 'C')	Then as_properties[UpperBound(as_properties[]) + 1]	= 'Description'
		If Not ab_onlyoneswithvalues Or (This.BitmapX <> 0  And ShowBitmap)				Then as_properties[UpperBound(as_properties[]) + 1]	= 'BitmapX'
		If Not ab_onlyoneswithvalues Or (This.BitmapY <> 25 And ShowBitmap)				Then as_properties[UpperBound(as_properties[]) + 1]	= 'BitmapY'
		If Not ab_onlyoneswithvalues Or (This.BitmapWidth <> 16 And ShowBitmap)			Then as_properties[UpperBound(as_properties[]) + 1]	= 'BitmapWidth'
		If Not ab_onlyoneswithvalues Or (This.BitmapHeight <> 16 And ShowBitmap)		Then as_properties[UpperBound(as_properties[]) + 1]	= 'BitmapHeight'
		If Not ab_onlyoneswithvalues Or (This.BitmapFilename <> ls_bitmapfilename And ShowBitmap) Then as_properties[UpperBound(as_properties[]) + 1]	= 'BitmapFilename'
		
		If Not ab_onlyoneswithvalues Or Not This.ShowPageNumber								Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowPageNumber'
		If Not ab_onlyoneswithvalues Or This.FooterHeight <> 192								Then as_properties[UpperBound(as_properties[]) + 1]	= 'FooterHeight'
		If Not ab_onlyoneswithvalues Or This.HeaderHeight <> 210								Then as_properties[UpperBound(as_properties[]) + 1]	= 'HeaderHeight'
		If Not ab_onlyoneswithvalues Or This.FontSize <> -8									Then as_properties[UpperBound(as_properties[]) + 1]	= 'FontSize'
		If Not ab_onlyoneswithvalues Or Lower(Trim(This.FontName)) <> 'tahoma'			Then as_properties[UpperBound(as_properties[]) + 1]	= 'FontName'
		If Not ab_onlyoneswithvalues Or This.ShowFirstGroupAsSeparateReport				Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowFirstGroupAsSeparateReport'
		If Not ab_onlyoneswithvalues Or This.ModifyColumnHeaderHeight						Then as_properties[UpperBound(as_properties[]) + 1]	= 'ModifyColumnHeaderHeight'
		If Not ab_onlyoneswithvalues Or This.ModifyColumnHeaderHeight						Then as_properties[UpperBound(as_properties[]) + 1]	= 'ColumnHeaderHeight'
		If Not ab_onlyoneswithvalues Or Not This.ShowRowLabels								Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowRowLabels'
		If Not ab_onlyoneswithvalues Or Not This.ShowColumnLabels							Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowColumnLabels'
		If Not ab_onlyoneswithvalues Or This.ReportingDisplayObject <> 'u_search_pivot_table' Then as_properties[UpperBound(as_properties[]) + 1]	= 'ReportingDisplayObject'
		If Not ab_onlyoneswithvalues Or This.AlwaysUseGroupBySortingFirst					Then as_properties[UpperBound(as_properties[]) + 1]	= 'AlwaysUseGroupBySortingFirst'

	Case 'row', 'column', 'aggregate'
		If Not ab_onlyoneswithvalues Or This.Count <> 0 				Then as_properties[UpperBound(as_properties[]) + 1]	= 'Count'
		If Not ab_onlyoneswithvalues Or This.Width <> 0 				Then as_properties[UpperBound(as_properties[]) + 1]	= 'Width'
		If Not ab_onlyoneswithvalues Or This.Column <> '' 				Then as_properties[UpperBound(as_properties[]) + 1]	= 'Column'
		If Not ab_onlyoneswithvalues Or This.Description <> '' 		Then as_properties[UpperBound(as_properties[]) + 1]	= 'Description'
		If Not ab_onlyoneswithvalues Or This.Expression <> '' 		Then as_properties[UpperBound(as_properties[]) + 1]	= 'Expression'
		If Not ab_onlyoneswithvalues Or This.IsComputed 				Then as_properties[UpperBound(as_properties[]) + 1]	= 'IsComputed'
		If Not ab_onlyoneswithvalues Or This.IsExpression 				Then as_properties[UpperBound(as_properties[]) + 1]	= 'IsExpression'
		If Not ab_onlyoneswithvalues Or This.ColumnWidthType <> 'O' Then as_properties[UpperBound(as_properties[]) + 1]	= 'ColumnWidthType'
		If Not ab_onlyoneswithvalues Or This.FormatType <> 'O'		Then as_properties[UpperBound(as_properties[]) + 1]	= 'FormatType'		
		If Not ab_onlyoneswithvalues Or This.FormatType <> 'O'		Then as_properties[UpperBound(as_properties[]) + 1]	= 'Format'
		
End Choose

Choose Case Lower(Trim(This.ElementType))
	Case 'row', 'column'
		If Not ab_onlyoneswithvalues Or This.SortDirection <> '' Then as_properties[UpperBound(as_properties[]) + 1]	= 'SortDirection'
		If Not ab_onlyoneswithvalues Or This.FillInDateGaps <> 'N' 											Then as_properties[UpperBound(as_properties[]) + 1]	= 'FillInDateGaps'
		If Not ab_onlyoneswithvalues Or (This.FillInDateGaps = 'Y' And This.DateGapType <> 'M') 	Then as_properties[UpperBound(as_properties[]) + 1]	= 'DateGapType'
	Case 'aggregate', 'properties'
		If Not ab_onlyoneswithvalues Or Not This.ShowRowTotals 							Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowRowTotals'
		If Not ab_onlyoneswithvalues Or Not This.ShowColumnTotals 						Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowColumnTotals'
		If Not ab_onlyoneswithvalues Or Not This.ShowColumnTotalsMultiple 			Then as_properties[UpperBound(as_properties[]) + 1]	= 'ShowColumnTotalsMultiple'
End Choose

Choose Case Lower(Trim(This.ElementType))
	Case 'aggregate'
		If Not ab_onlyoneswithvalues Or This.WeightedAverageColumnID <> 0 			Then as_properties[UpperBound(as_properties[]) + 1]	= 'WeightedAverageColumnID'
		If Not ab_onlyoneswithvalues Or This.AggregateFunction <> 'sum' 				Then as_properties[UpperBound(as_properties[]) + 1]	= 'AggregateFunction'
		If Not ab_onlyoneswithvalues Or This.ForceSingleColumn 							Then as_properties[UpperBound(as_properties[]) + 1]	= 'ForceSingleColumn'
		If Not ab_onlyoneswithvalues Or This.WeightedAverageColumn <> '' 				Then as_properties[UpperBound(as_properties[]) + 1]	= 'WeightedAverageColumn'
		If Not ab_onlyoneswithvalues Or This.PivotTableColumnName <> '' 				Then as_properties[UpperBound(as_properties[]) + 1]	= 'PivotTableColumnName'
		If Not ab_onlyoneswithvalues Or This.PivotTableRowName <> '' 					Then as_properties[UpperBound(as_properties[]) + 1]	= 'PivotTableRowName'
		If Not ab_onlyoneswithvalues Or This.OverrideColumnAggregateFunction			Then as_properties[UpperBound(as_properties[]) + 1]	= 'OverrideColumnAggregateFunction'
		If Not ab_onlyoneswithvalues Or This.OverrideColumnAggregateFunction			Then as_properties[UpperBound(as_properties[]) + 1]	= 'ColumnAggregateFunction'
		If Not ab_onlyoneswithvalues Or This.OverrideRowAggregateFunction				Then as_properties[UpperBound(as_properties[]) + 1]	= 'OverrideRowAggregateFunction'
		If Not ab_onlyoneswithvalues Or This.OverrideRowAggregateFunction				Then as_properties[UpperBound(as_properties[]) + 1]	= 'RowAggregateFunction'

	//as_properties[UpperBound(as_properties[]) + 1]	= 'PivotTableColumnID'
		//as_properties[UpperBound(as_properties[]) + 1]	= 'PivotTableRowID'
	Case 'row'
		If Not ab_onlyoneswithvalues Or This.GroupResetPageCount 				Then as_properties[UpperBound(as_properties[]) + 1]	= 'GroupResetPageCount'
		If Not ab_onlyoneswithvalues Or This.GroupNewPageOnGroupBreak 			Then as_properties[UpperBound(as_properties[]) + 1]	= 'GroupNewPageOnGroupBreak'
		If Not ab_onlyoneswithvalues Or Not This.CreateGroup				 		Then as_properties[UpperBound(as_properties[]) + 1]	= 'CreateGroup'
		If Not ab_onlyoneswithvalues Or This.SuppressRepeatingValues	 		Then as_properties[UpperBound(as_properties[]) + 1]	= 'SuppressRepeatingValues'
End Choose

/*None
as_properties[UpperBound(as_properties[]) + 1]	= 'ColumnID'
as_properties[UpperBound(as_properties[]) + 1]	= 'Datatype'
as_properties[UpperBound(as_properties[]) + 1]	= 'EditStyle'
as_properties[UpperBound(as_properties[]) + 1]	= 'ElementType'
as_properties[UpperBound(as_properties[]) + 1]	= 'Description'
as_properties[UpperBound(as_properties[]) + 1]	= 'TitleIsOverridden'
*/
end subroutine

public subroutine of_reset ();This.ColumnID						= 0
This.WeightedAverageColumnID	= 0
This.Count							= 0
This.GraphType						= 11
This.Width							= 0

This.PivotTableColumnID			= 0
This.PivotTableRowID				= 0

This.AggregateFunction				= 'sum'
This.Column								= ''
This.WeightedAverageColumn			= ''
This.ColumnAggregateFunction		= 'sum'
This.ColumnAllAggregateFunction	= 'sum'
This.Datatype							= ''
This.Description						= ''
This.EditStyle							= ''
This.ElementType						= ''
This.Expression						= ''
This.Format								= '[general]'
This.RowAggregateFunction			= 'sum'
This.PivotTableColumnName			= ''
This.PivotTableRowName				= ''
This.SortDirection					= ''

This.ForceSingleColumn			= False
This.IsComputed					= False
This.IsExpression					= False
This.IsGraph						= False
This.IsLegend						= True
This.TitleIsOverridden			= False
This.ShowColumnTotals			= True
This.ShowRowTotals				= True
This.ShowColumnTotalsMultiple	= True
This.ExcludeZeroRows				= False
This.AllowExpandingGroups		= False

	
This.ShowHeader				= True
This.ShowFooter				= True
This.ShowBitmap				= True
This.BitmapX					= 0
This.BitmapY					= 25
This.BitmapWidth				= 16
This.BitmapHeight				= 16
This.ZoomPercentage			= 100
This.AdditionalDescription	= ''
This.BitmapFilename			= 'Module - Reporting Desktop - Pivot Table Wizard.bmp'
This.FooterExpression		= ''
This.FooterAggregateLabel	= ''
This.TitleType					= 'O' /* 'O' - Automatically Generated, 'C' - Custom Title */
This.ColumnWidthType			= 'O'	/* 'O' - Original Column, 'C' - Custom Width, 'B' - Best Fit, 'H' - Best Fit Header and Column */

This.ShowPageNumber			= True
This.FooterHeight				= 192
This.HeaderHeight				= 210
This.FontSize					= -8
This.FontName					= 'Tahoma'
This.FormatType				= 'O'

This.GroupResetPageCount				= False
This.GroupNewPageOnGroupBreak			= False
This.ShowFirstGroupAsSeparateReport	= False

This.FillInDateGaps						= 'N'
This.DateGapType							= 'M'

This.CreateGroup							= True
This.SuppressRepeatingValues			= False
This.ModifyColumnHeaderHeight			= False
This.ColumnHeaderHeight					= 55

This.ShowRowLabels								= True
This.ShowColumnLabels							= True
This.OverrideColumnAggregateFunction		= False
This.OverrideRowAggregateFunction			= False
This.ReportingDisplayObject					= 'u_search_pivot_table'
This.AlwaysUseGroupBySortingFirst			= False
end subroutine

public subroutine of_set (string as_column, string as_value);Choose Case Lower(Trim(as_column))
	Case 'columnid'
		This.ColumnID						= Long(as_value)
	Case 'weightedaveragecolumnid'
		This.WeightedAverageColumnID 	= Long(as_value)
	Case 'count'
		This.Count							= Long(as_value)
	Case 'graphtype'
		This.GraphType						= Long(as_value)
	Case 'width'
		This.Width							= Long(as_value)
	Case 'pivottablecolumnid'
		This.PivotTableColumnID			= Long(as_value)
	Case 'pivottablerowid'
		This.PivotTableRowID				= Long(as_value)
	case 'bitmapx'
		this.bitmapx						= Long(as_value)
	case 'bitmapy'
		this.bitmapy						= Long(as_value)
	case 'bitmapwidth'
		this.bitmapwidth					= Long(as_value)
	case 'bitmapheight'
		this.bitmapheight					= Long(as_value)
	case 'zoompercentage'
		this.zoompercentage				= Long(as_value)
	Case 'footerheight'
		this.FooterHeight					= Long(as_value)
	Case 'headerheight'
		this.HeaderHeight					= Long(as_value)
	Case 'fontsize'
		this.FontSize						= Long(as_value)

	Case 'aggregatefunction'
		This.AggregateFunction				= as_value
	Case 'column'
		This.Column								= as_value
	Case 'weightedaveragecolumn'
		This.WeightedAverageColumn			= as_value
	Case 'columnaggregatefunction'
		This.ColumnAggregateFunction		= as_value
	Case 'columnallaggregatefunction'
		This.ColumnAllAggregateFunction	= as_value
	Case 'datatype'
		This.Datatype							= as_value
	Case 'description'
		This.Description						= as_value
	Case 'editstyle'
		This.EditStyle							= as_value
	Case 'elementtype'
		This.ElementType						= as_value
	Case 'expression'
		This.Expression						= as_value
	Case 'format'
		This.Format								= as_value
	Case 'rowaggregatefunction'
		This.RowAggregateFunction			= as_value
	Case 'pivottablecolumnname'
		This.PivotTableColumnName			= as_value
	Case 'pivottablerowname'
		This.PivotTableRowName				= as_value
	Case 'sortdirection'
		This.SortDirection					= as_value
	case 'additionaldescription'
		this.additionaldescription			= as_value
	case 'bitmapfilename'
		this.bitmapfilename					= as_value
	case 'footerexpression'
		this.footerexpression				= as_value
	case 'footeraggregatelabel'
		this.footeraggregatelabel			= as_value
	case 'titletype'
		this.titletype							= as_value
	case 'columnwidthtype'
		this.columnwidthtype					= as_value
	Case 'fontname'
		this.FontName							= as_value
	Case 'formattype'
		this.FormatType						= as_value
	Case 'fillindategaps'
		this.FillInDateGaps					= as_value
	Case 'dategaptype'
		this.DateGapType						= as_value
	Case 'forcesinglecolumn'
		This.ForceSingleColumn			= (as_value = 'true')
	Case 'iscomputed'
		This.IsComputed					= (as_value = 'true')
	Case 'isexpression'
		This.IsExpression					= (as_value = 'true')
	Case 'isgraph'
		This.IsGraph						= (as_value = 'true')
	Case 'islegend'
		This.IsLegend						= (as_value = 'true')
	Case 'showcolumntotals'
		This.ShowColumnTotals			= (as_value = 'true')
	Case 'showrowtotals'
		This.ShowRowTotals				= (as_value = 'true')		
	Case 'showcolumntotalsmultiple'
		This.ShowColumnTotalsMultiple	= (as_value = 'true')		
	Case 'excludezerorows'
		This.ExcludeZeroRows				= (as_value = 'true')		
	Case 'titleisoverridden'
		This.TitleIsOverridden			= (as_value = 'true')
	Case 'allowexpandinggroups'
		This.AllowExpandingGroups		= (as_value = 'true')
	case 'showheader'
		this.showheader					= (as_value = 'true')
	case 'showfooter'
		this.showfooter					= (as_value = 'true')
	case 'showbitmap'
		this.showbitmap					= (as_value = 'true')
	Case 'showpagenumber'
		this.ShowPageNumber				= (as_value = 'true')
	Case 'groupresetpagecount'
		this.GroupResetPageCount		= (as_value = 'true')
	Case 'groupnewpageongroupbreak'
		this.GroupNewPageOnGroupBreak	= (as_value = 'true')
	Case 'showfirstgroupasseparatereport'
		this.ShowFirstGroupAsSeparateReport	= (as_value = 'true')
	Case 'creategroup'
		this.CreateGroup							= (as_value = 'true')
	Case 'suppressrepeatingvalues'
		this.SuppressRepeatingValues			= (as_value = 'true')
	Case 'modifycolumnheaderheight'
		this.ModifyColumnHeaderHeight			= (as_value = 'true')
	Case 'columnheaderheight'
		This.ColumnHeaderHeight					= Long(as_value)
	Case 'showrowlabels'
		this.ShowRowLabels			= (as_value = 'true')
	Case 'showcolumnlabels'
		this.ShowColumnLabels			= (as_value = 'true')
	Case 'overridecolumnaggregatefunction'
		this.OverrideColumnAggregateFunction			= (as_value = 'true')
	Case 'overriderowaggregatefunction'
		this.OverrideRowAggregateFunction			= (as_value = 'true')
	Case 'reportingdisplayobject'
		This.ReportingDisplayObject			= Lower(Trim(as_value))
	Case 'alwaysusegroupbysortingfirst'
		This.AlwaysUseGroupBySortingFirst = (as_value = 'true')
End Choose
end subroutine

on n_pivot_table_element.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_pivot_table_element.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;This.of_reset()
end event

