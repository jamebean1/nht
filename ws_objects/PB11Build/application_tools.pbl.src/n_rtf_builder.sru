$PBExportHeader$n_rtf_builder.sru
forward
global type n_rtf_builder from nonvisualobject
end type
end forward

global type n_rtf_builder from nonvisualobject
end type
global n_rtf_builder n_rtf_builder

type prototypes

end prototypes

type variables
INTEGER irtf_handle = -1
INTEGER irc
n_rtf_export_datawindow in_rtf_export_datawindow
String is_return = 'File has not bee created.'
end variables

forward prototypes
public function string uf_create_rtf (ref string ps_filename, string ps_vorlage)
public function string uf_close ()
public function string uf_create (ref string ps_filename, boolean pb_meldung, string ps_vorlage)
public function string uf_create (ref string ps_filename, boolean pb_meldung)
public function string uf_newpage ()
public function string uf_open (string ps_filename, boolean pb_meldung)
public function string uf_bitmap (string ps_bmp_name, double pd_x, double pd_y, double pd_breite, double pd_hoehe, integer pi_modus)
public function string uf_setfont (integer pi_font, integer pi_hoehe, integer pi_stil, integer pi_ausrichtung, integer pi_farbe, double pd_offset)
public function string uf_setpage (string pi_format, double pd_lrand, double pd_rrand, double pd_orand, double pd_urand, double pd_kopf, double pd_fuss)
public function string uf_setmargin (double pd_lrand, double pd_rrand, double pd_orand, double pd_urand, double pd_kopfz, double pd_fussz)
public function string uf_setpage (string ps_format)
public function string uf_tabclose ()
public function string uf_tabcreate (integer pi_zeile, integer pi_spalte, double pd_hoehe, double pd_breite)
public function string uf_tabsetborder ()
public function string uf_tabsetborder (integer pi_zeile, integer pi_spalte, integer pi_oben, integer pi_unten, integer pi_links, integer pi_rechts, double pd_b_oben, double pd_b_unten, double pd_b_links, double pd_b_rechts)
public function string uf_tabsetcellwidth (integer pi_spalte, double pd_breite)
public function string uf_tabsetfont (integer pi_zeile, integer pi_spalte, integer pi_font, integer pi_hoehe, integer pi_stil, integer pi_ausrichtung, integer pi_farbe, double pd_offset)
public function string uf_tabsetformat (integer pi_ausrichtung, double pd_lrand, double pd_offset)
public function string uf_tabsetrowheight (integer pi_zeile, integer pd_hoehe)
public function string uf_tabtext (integer pi_zeile, integer pi_spalte, string ps_text)
public function string uf_tabtext (integer pi_zeile, integer pi_spalte, string ps_text, integer pi_stil, integer pi_ausrichtung)
public function string uf_text (string ps_text)
public function string uf_text (string ps_text, integer pi_stil, boolean pb_ende)
public function string uf_textwithposition (string ps_text, double pd_x, double pd_y, integer pi_stil, boolean pb_ende)
public function string uf_tmpclose ()
public function string uf_dwrtf_formular (datawindow adw_data)
public function string uf_dwrtf_tabelle (datawindow adw_data, string ps_header, boolean pb_rahmen)
protected subroutine uf_getfontsize (ref integer pi_fhoehe, ref integer pi_zhoehe)
end prototypes

public function string uf_create_rtf (ref string ps_filename, string ps_vorlage);
RETURN is_return
end function

public function string uf_close ();
RETURN is_return
end function

public function string uf_create (ref string ps_filename, boolean pb_meldung, string ps_vorlage);
RETURN is_return
end function

public function string uf_create (ref string ps_filename, boolean pb_meldung);
RETURN (uf_create(ps_filename,pb_meldung,"") )



end function

public function string uf_newpage ();
RETURN is_return
end function

public function string uf_open (string ps_filename, boolean pb_meldung);RETURN 'File has not been created (Attempt to open in uf_open of u_rtflib_class)'
end function

public function string uf_bitmap (string ps_bmp_name, double pd_x, double pd_y, double pd_breite, double pd_hoehe, integer pi_modus);
RETURN is_return
end function

public function string uf_setfont (integer pi_font, integer pi_hoehe, integer pi_stil, integer pi_ausrichtung, integer pi_farbe, double pd_offset);
RETURN is_return
end function

public function string uf_setpage (string pi_format, double pd_lrand, double pd_rrand, double pd_orand, double pd_urand, double pd_kopf, double pd_fuss);
RETURN is_return
end function

public function string uf_setmargin (double pd_lrand, double pd_rrand, double pd_orand, double pd_urand, double pd_kopfz, double pd_fussz);RETURN 'Could not set margins in uf_setmargin of u_rtflib_class'
end function

public function string uf_setpage (string ps_format);
RETURN is_return
end function

public function string uf_tabclose ();
RETURN is_return
end function

public function string uf_tabcreate (integer pi_zeile, integer pi_spalte, double pd_hoehe, double pd_breite);
RETURN is_return
end function

public function string uf_tabsetborder ();
RETURN is_return
end function

public function string uf_tabsetborder (integer pi_zeile, integer pi_spalte, integer pi_oben, integer pi_unten, integer pi_links, integer pi_rechts, double pd_b_oben, double pd_b_unten, double pd_b_links, double pd_b_rechts);
RETURN is_return
end function

public function string uf_tabsetcellwidth (integer pi_spalte, double pd_breite);
RETURN is_return
end function

public function string uf_tabsetfont (integer pi_zeile, integer pi_spalte, integer pi_font, integer pi_hoehe, integer pi_stil, integer pi_ausrichtung, integer pi_farbe, double pd_offset);
RETURN is_return
end function

public function string uf_tabsetformat (integer pi_ausrichtung, double pd_lrand, double pd_offset);
RETURN is_return
end function

public function string uf_tabsetrowheight (integer pi_zeile, integer pd_hoehe);
RETURN is_return
end function

public function string uf_tabtext (integer pi_zeile, integer pi_spalte, string ps_text);
RETURN 'uf_tabtext for u_rtflib_class'
end function

public function string uf_tabtext (integer pi_zeile, integer pi_spalte, string ps_text, integer pi_stil, integer pi_ausrichtung);
RETURN is_return
end function

public function string uf_text (string ps_text);
RETURN is_return
end function

public function string uf_text (string ps_text, integer pi_stil, boolean pb_ende);
RETURN is_return

end function

public function string uf_textwithposition (string ps_text, double pd_x, double pd_y, integer pi_stil, boolean pb_ende);
RETURN is_return

end function

public function string uf_tmpclose ();
RETURN is_return
end function

public function string uf_dwrtf_formular (datawindow adw_data);LONG		l_row, ll_index, ll_x, ll_width, l_nextrow, l_aktrow, ll_y_index, l_nextlinie, ll_minimum_x
INTEGER	ll_rowcount, ll_return, ll_fontheight, ll_y, ll_numberofrows, i, ll_alignment, ll_fontweight
STRING	s_obj, s_typ, s_txt, ls_datawindow_objects[], s_name, ls_y_column = 'linie', ls_width_column = 'breite', ls_x_column = 'pos'
DataStore lds_objectproperties

ll_rowcount = 0
ll_return = 4
ll_fontheight = 8
//---------------------------------------------------------------------------------------------------
// This will hold the information required to create the Table for the RTF document
//---------------------------------------------------------------------------------------------------
lds_objectproperties = CREATE Datastore

//---------------------------------------------------------------------------------------------------
// This is the dataobject that stores the information
//---------------------------------------------------------------------------------------------------
lds_objectproperties.DataObject = "d_rtflib_tab"

s_obj = adw_data.Describe("DataWindow.Objects")
//n_string_functions ln_string_functions 
gn_globals.in_string_functions.of_parse_string(s_obj, '~t', ls_datawindow_objects[])

//---------------------------------------------------------------------------------------------------
// Loop through all the objects in the datawindow
//---------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_datawindow_objects[])
	s_typ = Upper(adw_data.Describe(ls_datawindow_objects[ll_index] + ".type") )
	
	//---------------------------------------------------------------------------------------------------
	// If it is a column, computed field, or static text and it is in the detail, and is visible insert the object
	//---------------------------------------------------------------------------------------------------
	If (s_typ = "COLUMN" OR s_typ = "COMPUTE" OR s_typ = "TEXT") AND Upper(adw_data.Describe(ls_datawindow_objects[ll_index]+".Band") ) = "DETAIL" AND adw_data.Describe(ls_datawindow_objects[ll_index]+".visible") = "1" THEN
		l_row = lds_objectproperties.InsertRow(0)
		IF s_typ = "TEXT" THEN	lds_objectproperties.SetItem(l_row, "art", 0)	// Initial = 1
		
		lds_objectproperties.SetItem(l_row,"name",	Upper(adw_data.Describe(ls_datawindow_objects[ll_index]+".Name") ) )
		
		s_txt = Upper(adw_data.Describe(ls_datawindow_objects[ll_index]+".ColType") )
		If Pos(s_txt, '(') > 0 Then s_txt = Left(s_txt, Pos(s_txt, '(') - 1)
		lds_objectproperties.SetItem(l_row,"typ",	s_txt)
		
		lds_objectproperties.SetItem(l_row,ls_width_column, 	Long(adw_data.Describe(ls_datawindow_objects[ll_index]+".Width") ) )
		lds_objectproperties.SetItem(l_row,ls_x_column,	 		Long(adw_data.Describe(ls_datawindow_objects[ll_index]+".x") ) )
		lds_objectproperties.SetItem(l_row,ls_y_column,		Long(adw_data.Describe(ls_datawindow_objects[ll_index]+".y") ) )
	END IF
Next

ll_rowcount = lds_objectproperties.RowCount()
IF ll_rowcount = 0 Then
	is_return = 'There were no objects to create the RTF document in the datawindow in uf_dwrtf_formular of u_rtflib_class'
	RETURN is_return
End If

//---------------------------------------------------------------------------------------------------
// Get the font size
//---------------------------------------------------------------------------------------------------
s_name = lds_objectproperties.GetItemString(1,"name")
ll_fontheight = Integer(lds_objectproperties.Describe(s_name+".Font.Height") )
uf_getfontsize(ll_fontheight, ll_return)

//---------------------------------------------------------------------------------------------------
// Get the minimum x position and sort by y position
//---------------------------------------------------------------------------------------------------
ll_minimum_x = Long(lds_objectproperties.Describe("Evaluate('Min(pos)',0)") )
lds_objectproperties.SetSort("linie,pos")
lds_objectproperties.Sort()

//---------------------------------------------------------------------------------------------------
// Get the Y position
//---------------------------------------------------------------------------------------------------
ll_y_index = lds_objectproperties.GetItemNumber(1,ls_y_column)
lds_objectproperties.SetItem(1,ls_y_column, 1)
ll_y = 1

//---------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------
FOR ll_index = 2 TO ll_rowcount
	IF abs(lds_objectproperties.GetItemNumber(ll_index, ls_y_column) - ll_y_index ) > 300 THEN
		ll_y_index 	= lds_objectproperties.GetItemNumber(ll_index,ls_y_column)
		ll_x 			= lds_objectproperties.GetItemNumber(ll_index,ls_x_column)
		ll_y ++
	END IF

	lds_objectproperties.SetItem(ll_index,ls_y_column, ll_y)
NEXT	

//---------------------------------------------------------------------------------------------------
// Resort the datastore
//---------------------------------------------------------------------------------------------------
lds_objectproperties.Sort()

//---------------------------------------------------------------------------------------------------
// Positionen in einer Linie festlegen
//---------------------------------------------------------------------------------------------------
ll_y = -1
FOR i = 1 TO ll_rowcount
	IF lds_objectproperties.GetItemNumber(i,ls_y_column) > ll_y THEN
		ll_y = lds_objectproperties.GetItemNumber(i, ls_y_column)
		ll_x = lds_objectproperties.GetItemNumber(i,ls_x_column)
		IF ll_x > ll_minimum_x THEN
			l_row = lds_objectproperties.InsertRow(0)
			lds_objectproperties.SetItem(l_row,	ls_y_column, 		ll_y)
			lds_objectproperties.SetItem(l_row,	"art",				-1)					// Initial = 1
			lds_objectproperties.SetItem(l_row,	ls_x_column, 		ll_minimum_x)
			lds_objectproperties.SetItem(l_row,	ls_width_column, 	ll_x - ll_minimum_x)
		END IF
	ELSE
		ll_width =  lds_objectproperties.GetItemNumber(i - 1,ls_x_column) + lds_objectproperties.GetItemNumber(i - 1,ls_width_column)
		ll_x	 =  lds_objectproperties.GetItemNumber(i,ls_x_column)
		IF ll_x > ll_width THEN
			l_row = lds_objectproperties.InsertRow(0)
			lds_objectproperties.SetItem(l_row,	ls_y_column, 		ll_y)
			lds_objectproperties.SetItem(l_row,	"art",				-1)					// Initial = 1
			lds_objectproperties.SetItem(l_row,	ls_x_column, 		ll_width)
			lds_objectproperties.SetItem(l_row,	ls_width_column, 	ll_x - ll_width)
		END IF	
	END IF
NEXT	

//---------------------------------------------------------------------------------------------------
// Resort the datastore.  Find the new minimum y.
//---------------------------------------------------------------------------------------------------
lds_objectproperties.Sort()
ll_rowcount = lds_objectproperties.RowCount()
ll_y = lds_objectproperties.GetItemNumber(ll_rowcount,ls_y_column)

//---------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------
ll_rowcount = adw_data.RowCount()
FOR ll_index = 1 TO ll_rowcount
	ll_x = 0
	l_row = 1
	FOR ll_y_index	= 1 TO ll_y
		l_nextrow = lds_objectproperties.Find(ls_y_column + " = " + String(ll_y_index + 1), l_row, ll_rowcount )
		IF l_nextrow > 0 THEN
			ll_numberofrows = INTEGER(l_nextrow - l_row)
		ELSE
			ll_numberofrows = ll_rowcount - l_row + 1
		END IF
		
		l_row = l_nextrow

		is_return = this.uf_TabCreate(1, ll_numberofrows, ll_return, 2)
		IF NOT is_return = '' THEN
			ll_y_index = ll_y + 1
			EXIT
		END IF
			
		this.uf_TabSetFont(0,0,1,ll_fontheight,1,1,1,0.5)
	
		FOR i = 1 TO ll_numberofrows
			ll_x ++
			
			//---------------------------------------------------------------------------------------------------
			// 
			//---------------------------------------------------------------------------------------------------
			this.uf_TabSetCellWidth(i, lds_objectproperties.GetItemNumber(ll_x,ls_width_column)/100 )
			s_name = lds_objectproperties.GetItemString(ll_x,"name")
			ll_alignment = INTeger(adw_data.Describe(s_name+".alignment") ) + 1
			ll_fontweight  = INTeger(adw_data.Describe(s_name+".Font.Weight") )
			IF ll_fontweight > 400 THEN
				ll_fontweight = 2
			ELSE
				ll_fontweight = 1
			END IF

			//---------------------------------------------------------------------------------------------------
			// 
			//---------------------------------------------------------------------------------------------------
			CHOOSE CASE lds_objectproperties.GetItemNumber(ll_x, "art")
				CASE 0
					this.uf_TabText(1, i,	adw_data.Describe(s_name+".text"), ll_fontweight, ll_alignment)
				CASE 1
					this.uf_TabText(1, i,	in_rtf_export_datawindow.of_dwGetColString(adw_data,ll_index, s_name,""), ll_fontweight, ll_alignment)
			END CHOOSE
		NEXT

		//---------------------------------------------------------------------------------------------------
		// 
		//---------------------------------------------------------------------------------------------------
		this.uf_TabClose()
	NEXT
NEXT

//---------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------
RETURN is_return
end function

public function string uf_dwrtf_tabelle (datawindow adw_data, string ps_header, boolean pb_rahmen);LONG		ll_rowcount, l_pivot, l_row, ll_header_height, l_hd
INTEGER	i_col, ll_rowcount_datastore, ll_cellheight, ll_fontheight, ll_width, ll_rowcount_table, ll_alignment, i, k
STRING	s_obj, s_typ, s_header, s_name, s_txt, s_type, ls_width_column = 'breite', ls_columnvalue
DATASTORE	lds_table_information

ll_rowcount = adw_data.RowCount()
ll_rowcount_datastore = 0

ll_cellheight = 4
ll_fontheight = 8

// Hole Informationen über jedes sichtbare Object im adw_data
lds_table_information = CREATE Datastore
lds_table_information.DataObject = "d_rtflib_tab"
ll_header_height = Long(adw_data.Describe("DataWindow.Header.Height") ) 
s_obj = adw_data.Describe("DataWindow.Objects")
s_name = in_rtf_export_datawindow.of_GetToken(s_obj,"~t")

DO UNTIL Trim(s_name) = ""
	IF adw_data.Describe(s_name+".visible") <> "0" THEN 
		s_type = Upper(adw_data.Describe(s_name+".type") )
		s_txt  = Upper(adw_data.Describe(s_name+".Band") )
	
		CHOOSE CASE Left(Upper(adw_data.Describe(s_name+".Band") ), 6)
			CASE "HEADER"
				IF s_type = "COLUMN" OR s_type = "COMPUTE" OR s_type = "TEXT" THEN
					l_hd = ll_header_height - Long(adw_data.Describe(s_name+".y") ) - Long(adw_data.Describe(s_name+".Height") )
					IF l_hd > 0 AND l_hd < 200 THEN		
						l_row = lds_table_information.InsertRow(0)
						lds_table_information.SetItem(l_row,"art",0)
						lds_table_information.SetItem(l_row,"pos",	Long(adw_data.Describe(s_name+".x") ) )
						IF s_type = "TEXT" THEN
							lds_table_information.SetItem(l_row,"header", adw_data.Describe(s_name+".text") )
						ELSE
							IF adw_data.RowCount() > 0 THEN
								lds_table_information.SetItem(l_row,"header", in_rtf_export_datawindow.of_dwGetColString(adw_data,1,s_name,"" ) )
							END IF
						END IF
					END IF
				END IF
				
			CASE "DETAIL"
				IF s_type = "COLUMN" OR s_type = "COMPUTE" THEN
					l_row = lds_table_information.InsertRow(0)
					lds_table_information.SetItem(l_row,"name",	Upper(adw_data.Describe(s_name+".Name") ) )
					s_txt = Upper(adw_data.Describe(s_name+".ColType") )
					lds_table_information.SetItem(l_row,"typ",	in_rtf_export_datawindow.of_GetToken(s_txt,"(") )
					lds_table_information.SetItem(l_row,ls_width_column,Ceiling(DOUBLE (adw_data.Describe(s_name+".Width") ) / 10 ) )
					lds_table_information.SetItem(l_row,"align", Integer(adw_data.Describe(s_name+".Alignment") ) + 1)
					lds_table_information.SetItem(l_row,"pos",	Long(adw_data.Describe(s_name+".x") ) )
				END IF
		END CHOOSE
	END IF
		
	s_name = in_rtf_export_datawindow.of_GetToken(s_obj,"~t")
LOOP

ll_rowcount_datastore = lds_table_information.RowCount()
IF ll_rowcount_datastore = 0 Then
	is_return = 'There were no objects to create RTF document in uf_dwrtf_tabelle of u_rtflib_class'
	Return is_return
End If

//------------------------------------------------------------------------------------------------------
// Get font information
//------------------------------------------------------------------------------------------------------
s_name = lds_table_information.GetItemString(1,"name")
If IsNull(s_name) Then
	ll_fontheight = 8
Else
	ll_fontheight = INTeger(lds_table_information.Describe(s_name+".Font.Height") )
End If
uf_getfontsize(ll_fontheight, ll_cellheight)

//------------------------------------------------------------------------------------------------------
// Tabellenüberschriften eintragen
//------------------------------------------------------------------------------------------------------
If Trim(ps_header) <> "" THEN
	If Trim(ps_header) = "#" THEN
		lds_table_information.SetSort("pos,art")
		lds_table_information.Sort()
		ll_rowcount_datastore --

		For i = 1 To ll_rowcount_datastore 
			If lds_table_information.GetItemNumber(i,"art") = 0 AND lds_table_information.GetItemNumber(i+1,"art") = 1 AND &
				ABS (lds_table_information.GetItemNumber(i,"pos") - lds_table_information.GetItemNumber(i+1,"pos")) < 200 THEN 
				lds_table_information.SetItem(i+1,"header", in_rtf_export_datawindow.of_nvl(lds_table_information.GetItemString(i,"header") ) )
				i++
			End If
		Next
	Else
		lds_table_information.SetFilter("art=1")
		lds_table_information.Filter()
		ll_rowcount_datastore = lds_table_information.RowCount()
		
		s_txt = ps_header
		l_row = 0
		FOR l_row = 1 TO ll_rowcount_datastore 
			lds_table_information.SetItem(l_row,"header", in_rtf_export_datawindow.of_GetToken(s_txt,"~t") )
		NEXT
	END IF
END IF

//------------------------------------------------------------------------------------------------------
// Tabellenwerte in RTF übernehmen
//------------------------------------------------------------------------------------------------------
lds_table_information.SetFilter("art=1")
lds_table_information.Filter()
lds_table_information.SetSort("pos")
lds_table_information.Sort()
ll_rowcount_datastore = lds_table_information.RowCount()
IF ll_rowcount_datastore = 0 THEN 
	is_return = 'There were no rows in the datawindow (2) in uf_dwrtf_tabelle of u_rtflib_class'
	Return is_return
End IF
ll_width = lds_table_information.GetItemNumber(1,ls_width_column)

IF Trim(ps_header) <> "" THEN
	this.uf_Text("")
	is_return = this.uf_TabCreate(1, ll_rowcount_datastore,ll_cellheight, ll_width)
	IF NOT is_return = '' THEN 
		RETURN is_return
	End IF

	this.uf_TabSetFont(0,0,1,ll_fontheight,1,1,1,1)
	IF pb_rahmen THEN	this.uf_TabSetBorder(0,0,1,1,1,1,0.1,0.1,0.1,0.1)

	FOR i = 1 TO ll_rowcount_datastore
		uf_TabSetCellWidth(i,lds_table_information.GetItemNumber(i,ls_width_column))
		uf_TabText(1,i,in_rtf_export_datawindow.of_nvl(lds_table_information.GetItemString(i,"header") ),2,lds_table_information.GetItemNumber(i,"align"))
	NEXT
	
	is_return = this.uf_TabClose()
	If Not is_return = '' Then
		Return is_return
	End IF
END IF

//------------------------------------------------------------------------------------------------------
// Tabellenwerte in RTF eINTragen
//------------------------------------------------------------------------------------------------------
l_pivot = -10

DO WHILE is_return = '' AND ll_rowcount > 0
 IF ll_rowcount < 10 THEN
		ll_rowcount_table = ll_rowcount
	ELSE
		ll_rowcount_table = 10
	END IF
	l_pivot = l_pivot + 10
	
	is_return = this.uf_TabCreate(ll_rowcount_table, ll_rowcount_datastore,ll_cellheight,ll_width)
	IF NOT is_return = '' THEN
		CONTINUE
	END IF
	
	this.uf_TabSetFont(0,0,1,ll_fontheight,1,1,1,0.5)

	IF pb_rahmen THEN	this.uf_TabSetBorder(0,0,1,1,1,1,0.1,0.1,0.1,0.1)

	FOR i = 1 TO ll_rowcount_datastore 
		this.uf_TabSetCellWidth(i, lds_table_information.GetItemNumber(i, ls_width_column) )
		s_name			= lds_table_information.GetItemString(i,"name")
		ll_alignment	= lds_table_information.GetItemNumber(i,"align")
		s_typ				= lds_table_information.GetItemString(i,"typ")
		
		FOR k = 1 TO ll_rowcount_table
			l_row = l_pivot + k
			ls_columnvalue = in_rtf_export_datawindow.of_dwGetColString(adw_data,l_row,s_name,s_typ)
			uf_TabText(k, i, ls_columnvalue, 1, ll_alignment)
		NEXT
	NEXT
	
	is_return = this.uf_TabClose()

	ll_rowcount = ll_rowcount - 10

LOOP	

DESTROY lds_table_information

RETURN is_return
end function

protected subroutine uf_getfontsize (ref integer pi_fhoehe, ref integer pi_zhoehe);
end subroutine

on n_rtf_builder.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_rtf_builder.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

