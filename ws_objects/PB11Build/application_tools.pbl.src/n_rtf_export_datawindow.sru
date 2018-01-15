$PBExportHeader$n_rtf_export_datawindow.sru
forward
global type n_rtf_export_datawindow from nonvisualobject
end type
end forward

global type n_rtf_export_datawindow from nonvisualobject autoinstantiate
end type

forward prototypes
public function boolean of_dwimport (datawindow adw_data)
public function string of_gettoken (ref string source, string separator)
public function string of_nvl (string ps_text)
private function string of_dwgetvalue (datawindow adw_data, string as_columnname, string as_value)
private function string of_splitfname (string as_filename, integer pi_mode)
public function string of_dwgetcolstring (datawindow adw_data, long al_row, string as_columnname, string as_columntype)
public function string of_dwexport_rtf (datawindow adw_data, string as_filename, boolean ab_return)
end prototypes

public function boolean of_dwimport (datawindow adw_data);//
//	FUNCNAME   : gf_dwImport
//	AUTOR      : HOY/PE-VM
// PRUEFER    : <NKZ/Abt./Datum>
// ANGELEGT   : 29.6.1998                                                   
//	LAST UPDATE: 
// 
//	ZWECK                                                                      
//		allgemeiner Import von Daten in ein Datawindows 
//	BEMERKUNG                                                                                               
//
//	PARAMETER                                                                 
//		ENTRY_READ        
//			pdw_name           
//		ENTRY_WRITE       
//			-              
//		RETURN            
//			BOOLEAN: Erfolg            
//		GLOBAL_LESEND     
//			-                     
//		GLOBAL_SCHREIBEND 
//			-                   
//
string	path_nm,file_nm,ext
integer	rc

	rc = GetFileOpenName("Select a Filename",path_nm,file_nm, &
								"*.PSR", &
							   "PowerSoft Report, *.PSR,"	&
							  +"dBase-File, *.DBF," 			&
							  +"Text-File, *.TXT," 				&			  
							  +"All Types, *.*")
	
	IF (rc <> 1) THEN
		RETURN False
	END IF
	
	SetPointer(Hourglass!)
	
	// -- sind alle Daten geladen ??? --
	
//	gf_SetMicrohelp("IMPORT: Importiere Datei '"+Path_nm+"'...")
	
	ext = UPPER(of_splitfname(path_nm,5))

	CHOOSE CASE ext
		CASE "TXT", "DBF"
			rc=adw_data.ImportFile(Path_nm)
		
			IF (rc <= 0) THEN
				Messagebox("Error","Import File Error "+STRING(rc)+"!")
			ELSE
//				gf_SetMicrohelp("IMPORT: Fertig, "+STRING(rc)+" Zeilen importiert!")	
			END IF
			
		CASE "PSR"
			adw_data.DataObject=Path_nm
			
			
		CASE ELSE
			Messagebox("Import Error",		&
						  "Unsupported file type.")
	END CHOOSE

		
//	gf_SetMicrohelp("")	
	SetPointer(Arrow!)

RETURN (rc > 0)





end function

public function string of_gettoken (ref string source, string separator);// String Function f_GET_TOKEN (ref string Source, string Separator)

// The function Get_Token receive, as arguments, the string from which
// the token is to be stripped off, from the left, and the separator
// character.  If the separator character does not appear in the string,
// it returns the entire string.  Otherwise, it returns the token, not
// including the separator character.  In either case, the source string
// is truncated on the left, by the length of the token and separator
// character, if any.


int 		p
string 	ret

p = Pos(source, separator)	// Get the position of the separator

if p = 0 then					// if no separator, 
	ret = source				// return the whole source string and
	source = ""					// make the original source of zero length
else
	ret = Mid(source, 1, p - 1)	// otherwise, return just the token and
	source = Right(source, Len(source) - p)	// strip it & the separator
end if

return ret
end function

public function string of_nvl (string ps_text);
	IF IsNull(ps_Text) THEN 
		RETURN ""
	ELSE
		RETURN ps_Text
	END IF

RETURN ps_Text
end function

private function string of_dwgetvalue (datawindow adw_data, string as_columnname, string as_value);//
// FUNCNAME   : gf_dwGetValue
// AUTOR      : ZLH / PE - VM
// PRUEFER    : <NKZ/Abt./Datum>
// ANGELEGT   : 21.10.199                                                    
// LAST UPDATE: <Datum>                                                    
// 
// ZWECK                                                                      
//   Liefert zu einem Spaltenwert den zugehörigen Wert aus der Code-Tabelle
// BEMERKUNG                                                                 
//   Ist im Zusammenspiel mit gf_dwGetColString() vorgesehen                              
//
// PARAMETER                                                                 
//   ENTRY_READ        
//				datawindow	pdw_datawin		zugehöriges DataWindow
//				string		ps_column		maßgebende Spalte
//				string		ps_value			maßgebender Spaltenwert
//   ENTRY_WRITE       
//				keine
//   RETURN            
//				string		zugehöriger Wert aus der Code-Tabelle           
//   GLOBAL_LESEND     
//				keine
//   GLOBAL_SCHREIBEND 
//				keine
//

STRING	s_val, s_rval, s_disp, s_wert

s_rval = ""
s_val = adw_data.DESCRIBE(as_columnname+".Values")

DO
	s_wert = of_GetToken(s_val,"/")
	s_disp = of_GetToken(s_wert,"~t")
	IF (as_value = s_wert) THEN
		s_rval = s_disp
		EXIT
	END IF
LOOP UNTIL Trim(s_val) = ""

RETURN s_rval
end function

private function string of_splitfname (string as_filename, integer pi_mode);// Beschreibung:
//	Zerlegt einen Filenamen in Einzelbestandteile
//
// Parameter:
//	ps_fname		Filename
//	pi_mode		Modus: 1= Laufwerk, 2= Pfad, 3= Filename, 4= Filename ohne Ext., 5=Extension
//
// Rückgabewerte:
//	String
//

string	sign,ret_string
integer	i,s_len

	ret_string = ""

	IF pi_mode = 1 THEN									// Laufwerk
		i = POS(as_filename,":",1)
		IF i > 0 THEN
			ret_string = MID(as_filename,1,i - 1)
		END IF
		RETURN ret_string
	END IF

	s_len = LEN(as_filename)
	FOR i = s_len TO 1 STEP -1
		sign = MID(as_filename,i,1) 
		IF sign = "\" OR sign = "/" OR sign = ":" THEN
			IF pi_mode = 2 THEN							// Pfad
				ret_string = MID(as_filename,1,i - 1)
				EXIT
			ELSE										// Filename
				ret_string = MID(as_filename,i+1,s_len - i )
				EXIT
			END IF
		END IF
	NEXT

	IF pi_mode > 2 AND i = 0 THEN							// Filename, wenn kein Pfad existiert
		ret_string = as_filename
	END IF
	
	IF pi_mode > 3 THEN
		s_len = LEN(ret_string)
		i = POS(ret_string,".",1)
		IF i > 0 THEN
			IF pi_mode = 4 THEN								// Filename ohne Extension
				ret_string = MID(ret_string,1,i - 1)
			ELSE											// Extension
				ret_string = MID(ret_string,i+1,s_len - i)
			END IF
		END IF
	END IF				

RETURN ret_string
	
	
end function

public function string of_dwgetcolstring (datawindow adw_data, long al_row, string as_columnname, string as_columntype);//
// FUNCNAME   : of_dwgetcolstring
// AUTOR      : ZLH / PE - VM
// PRUEFER    : <NKZ/Abt./Datum>
// ANGELEGT   : 21.10.199                                                    
// LAST UPDATE: <Datum>                                                    
// 
// ZWECK                                                                      
//		Liefert das Item eines DataWindow Feldes unabhängig vom Typ als String zurück.
//		Code-Tabellen und Format-Anweisungen im DataWindow werden berücksichtigt.
// BEMERKUNG                                                                 
//   Ruft mit gf_dwGetValue() auf                              
//
// PARAMETER                                                                 
//   ENTRY_READ        
//				datawindow	adw_data			Datawindow to get value from 
//				long			al_row			Row to get data from
//				string		as_columnname	The column name
//				string		as_columntype	The column type
//   RETURN            
//				string		zugehöriger Feldwert           
//
STRING s_str, s_typ, s_format

	IF al_row <= 0 THEN Return ""
	
	IF Trim(as_columntype) = "" THEN
		s_str = Upper(adw_data.Describe(as_columnname+".ColType") )
	ELSE
		s_str = as_columntype
	END IF
	
	s_format = TRIM(adw_data.Describe(as_columnname+".Format"))
	IF s_format = "!" OR s_format = "?" THEN
		s_format = ""
	END IF
	
	IF Trim(s_typ) = "!" THEN	RETURN ""
	s_typ = of_GetToken(s_str,"(")
	
	CHOOSE CASE s_typ
		CASE "NUMBER", "LONG"
			IF (s_format <> "") THEN			
				s_str = String(adw_data.GetItemNumber(al_row, as_columnname), s_format )
			ELSE
				s_str = String(adw_data.GetItemNumber(al_row, as_columnname) )
			END IF
			
		CASE "DECIMAL"	
			IF (s_format <> "") THEN	
				s_str = String(adw_data.GetItemDecimal(al_row, as_columnname), s_format )
			ELSE
				s_str = String(adw_data.GetItemDecimal(al_row, as_columnname) )
			END IF
			
		CASE "DATETIME"
			IF (s_format <> "") THEN
				s_str = String(adw_data.GetItemDateTime(al_row, as_columnname), s_format)
			ELSE	
				s_str = String(adw_data.GetItemDateTime(al_row, as_columnname))
			END IF	
			
		CASE "CHAR"	
			IF (s_format <> "") THEN
				s_str = STRING(adw_data.GetItemString(al_row, as_columnname), s_format)
			ELSE	
				s_str = adw_data.GetItemString(al_row, as_columnname)
			END IF	
			
		CASE "DATE"
			IF (s_format <> "") THEN
				s_str = String(adw_data.GetItemDate(al_row, as_columnname), s_format)
			ELSE
				s_str = String(adw_data.GetItemDate(al_row, as_columnname))
			END IF	
			
		CASE "TIME"
			IF (s_format <> "") THEN
				s_str = String(adw_data.GetItemTime(al_row, as_columnname), s_format)
			ELSE
				s_str = String(adw_data.GetItemTime(al_row, as_columnname))
			END IF
			
		CASE ELSE
			s_str = ""
	END CHOOSE
	
	
	IF Len(adw_data.Describe(as_columnname+".Values") ) > 1 THEN
		s_str = of_dwGetValue(adw_data, as_columnname, s_str)
	END IF

// -- ersetzt durch direkte Einträge in der CASE-Struktur 25.11.97 HOY ---
//	s_format = pdw_datawin.Describe(ps_name+".Format")
//	IF Len(s_format) > 1 THEN
//		s_str = String(s_str, s_format)
//	END IF
	
	IF IsNull (s_str) THEN s_str = ""

RETURN s_str
end function

public function string of_dwexport_rtf (datawindow adw_data, string as_filename, boolean ab_return);
Long	ll_method=1
n_rtf_builder		ln_rtf_builder
STRING				ls_string, ls_return = ''
ln_rtf_builder = Create n_rtf_builder_32bit

ls_return = ln_rtf_builder.uf_CREATE_RTF(as_filename,"")
IF NOT ls_return = '' THEN
	ls_return = 'Could not create RTF file ' + as_filename
ELSE	
	IF (ab_return) THEN
		ls_string="#"
	ELSE
		ls_string=""
	END IF

	//---------------------------------------------------------------------------------
	// Determine the type of presentation style
	//---------------------------------------------------------------------------------	
	CHOOSE CASE INTEGER(adw_data.Object.DataWindow.Processing)
		CASE 0, 2		// Freeform, Group, Tabular, Label=2
			ll_method = 2//1
		CASE 1, 4		// Grid, Crosstabe
			ll_method = 2
		CASE 3, 5		// Graph, Composite
			ll_method = 0
		CASE ELSE
			ll_method=0
	END CHOOSE
	
	//---------------------------------------------------------------------------------
	// Export the datawindow based on the type (freeform, or tabular)
	//---------------------------------------------------------------------------------	
	CHOOSE CASE ll_method
		CASE 1		// Freeform
			//---------------------------------------------------------------------------------
			// Create the RTF File from the datawindow
			//---------------------------------------------------------------------------------	
			ls_return = ln_rtf_builder.uf_dwRTF_Formular(adw_data)
			IF NOT ls_return = '' THEN			
				ls_return = 'Could not create RTF file for Freeform/Group/Tabular/Label datawindow'
				ln_rtf_builder.uf_CLOSE()
			ELSE
				ls_return = ln_rtf_builder.uf_CLOSE()
				IF NOT ls_return = '' THEN
					ls_return = 'Could not close RTF file for Freeform/Group/Tabular/Label datawindow'
				END IF
			END IF				

		CASE 2		// Tabular
			//---------------------------------------------------------------------------------
			// Create the RTF File from the datawindow
			//---------------------------------------------------------------------------------	
			ls_return = ln_rtf_builder.uf_dwRTF_Tabelle(adw_data, ls_string, TRUE)
			IF NOT ls_return = '' THEN	
				ls_return = 'Could not create RTF file for Grid/Crosstab datawindow'
				ln_rtf_builder.uf_CLOSE()
			ELSE
				ls_return = ln_rtf_builder.uf_CLOSE()
				IF NOT ls_return = '' THEN
					ls_return = 'Could not close RTF file for Grid/Crosstab datawindow'
				END IF
			END IF				
		CASE ELSE
			//---------------------------------------------------------------------------------
			// Unsupported presentation styles
			//---------------------------------------------------------------------------------	
			ls_return = 'Conversion to RTF does not currently support this presentation style'
	END CHOOSE

	
END IF

//---------------------------------------------------------------------------------
// Destroy the RTF object
//---------------------------------------------------------------------------------	
DESTROY(ln_rtf_builder)

//---------------------------------------------------------------------------------
// Return the string.  If it is an empty string, there wasn't an error
//---------------------------------------------------------------------------------	
RETURN ls_return
end function

on n_rtf_export_datawindow.create
TriggerEvent( this, "constructor" )
end on

on n_rtf_export_datawindow.destroy
TriggerEvent( this, "destructor" )
end on

