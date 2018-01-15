$PBExportHeader$n_rtf_builder_32bit.sru
forward
global type n_rtf_builder_32bit from n_rtf_builder
end type
end forward

global type n_rtf_builder_32bit from n_rtf_builder
end type
global n_rtf_builder_32bit n_rtf_builder_32bit

type prototypes
FUNCTION INT iRTF_ToolsVersion(BOOLEAN bShowDLL, BOOLEAN bShowDLLErr) LIBRARY "rtflib32.dll" 

FUNCTION INT  iRTF_CreateInstance() LIBRARY "rtflib32.dll" 
SUBROUTINE    RTF_DestroyInstance(INT RTF_Hnd) LIBRARY "rtflib32.dll" 

FUNCTION INT  iRTF_Create(INT RTF_Hnd, STRING sRTFName, INT iModus) LIBRARY "rtflib32.dll" alias for "iRTF_Create;Ansi" 
FUNCTION INT  iRTF_Open (INT RTF_Hnd, STRING sRTFName, INT iModus) LIBRARY "rtflib32.dll" alias for "iRTF_Open;Ansi" 
FUNCTION INT  iRTF_Close(INT RTF_Hnd) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_TmpClose(INT RTF_Hnd) LIBRARY "rtflib32.dll"

FUNCTION INT  iRTF_SetFont (INT RTF_Hnd, INT iFont, INT iFontgr, UINT nFontStil, INT iFArt, INT iColor, DOUBLE dOffset) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_SetPage(INT RTF_Hnd, INT iSeite, DOUBLE dLRand, DOUBLE dRRand,DOUBLE dORand, DOUBLE dURand,DOUBLE dKopfZ,DOUBLE dFussZ) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_SetMargin(INT RTF_Hnd, DOUBLE dLRand, DOUBLE dRRand,DOUBLE dORand,DOUBLE dURand,DOUBLE dKopfZ,DOUBLE dFussZ) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_NewPage (INT RTF_Hnd) LIBRARY "rtflib32.dll"

FUNCTION INT  iRTF_Text (INT RTF_Hnd, STRING sText, UINT nStil, INT iModus) LIBRARY "rtflib32.dll" alias for "iRTF_Text;Ansi"
FUNCTION INT  iRTF_TextWithPosition (INT RTF_Hnd, STRING sText, DOUBLE dX, DOUBLE dY, UINT nStil, INT iModus) LIBRARY "rtflib32.dll" alias for "iRTF_TextWithPosition;Ansi"

FUNCTION INT  iRTF_TabCreate (INT RTF_Hnd, INT iZeile, INT iSpalte,DOUBLE dZHoehe, DOUBLE dSBreite) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_TabSetCellWidth (INT RTF_Hnd, INT iZeile, DOUBLE dZHoehe) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_TabSetRowHeight (INT RTF_Hnd, INT Spalte, DOUBLE dSBreite) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_TabSetBorder (INT RTF_Hnd, INT iZeile, INT iSpalte, INT iOben, INT iUnten, INT iLinks, INT iRechts,DOUBLE OBreite, DOUBLE dUBreite, DOUBLE dLBreite, DOUBLE dRBreite) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_TabSetFont(INT RTF_Hnd, INT iZeile, INT iSpalte,INT iFont, INT iHoehe, INT iStil, INT iArt,INT iFarbe, DOUBLE Offset) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_TabSetFormat(INT RTF_Hnd, INT iAusrichtung, DOUBLE dLRand, DOUBLE dTextLinksOffset, DOUBLE dTextRechtsOffset) LIBRARY "rtflib32.dll"
FUNCTION INT  iRTF_TabSave (INT RTF_Hnd, STRING sFileName) LIBRARY "rtflib32.dll" alias for "iRTF_TabSave;Ansi"
FUNCTION INT  iRTF_TabText(INT RTF_Hnd, INT iZeile, INT iSpalte, STRING sText, INT iAusrichtung , UINT nStil) LIBRARY "rtflib32.dll" alias for "iRTF_TabText;Ansi"
FUNCTION INT  iRTF_TabClose (INT RTF_Hnd) LIBRARY "rtflib32.dll"

FUNCTION INT  iRTF_Bitmap(INT RTF_Hnd, STRING sBMPName, DOUBLE dX, DOUBLE dY,  DOUBLE dB, DOUBLE dH, INT iMode) LIBRARY "rtflib32.dll" alias for "iRTF_Bitmap;Ansi"

end prototypes

forward prototypes
private subroutine uf_getfontsize (ref INTeger pi_fhoehe, ref INTeger pi_zhoehe)
public function string uf_bitmap (string ps_bmp_name, double pd_x, double pd_y, double pd_breite, double pd_hoehe, integer pi_modus)
public function string uf_close ()
public function string uf_create (ref string ps_filename, boolean pb_meldung, string ps_vorlage)
public function string uf_create_rtf (ref string ps_filename, string ps_vorlage)
public function string uf_newpage ()
public function string uf_open (string ps_filename, boolean pb_meldung)
public function string uf_setfont (integer pi_font, integer pi_hoehe, integer pi_stil, integer pi_ausrichtung, integer pi_farbe, double pd_offset)
public function string uf_setmargin (double pd_lrand, double pd_rrand, double pd_orand, double pd_urand, double pd_kopfz, double pd_fussz)
public function string uf_setpage (string pi_format, double pd_lrand, double pd_rrand, double pd_orand, double pd_urand, double pd_kopf, double pd_fuss)
public function string uf_setpage (string ps_format)
public function string uf_tabclose ()
public function string uf_tabcreate (integer pi_zeile, integer pi_spalte, double pd_hoehe, double pd_breite)
public function string uf_tabsetborder ()
public function string uf_tabsetborder (integer pi_zeile, integer pi_spalte, integer pi_oben, integer pi_unten, integer pi_links, integer pi_rechts, double pd_b_oben, double pd_b_unten, double pd_b_links, double pd_b_rechts)
public function string uf_tabsetcellwidth (integer pi_spalte, double pd_breite)
public function string uf_tabsetfont (integer pi_zeile, integer pi_spalte, integer pi_font, integer pi_hoehe, integer pi_stil, integer pi_ausrichtung, integer pi_farbe, double pd_offset)
public function string uf_tabsetformat (integer pi_ausrichtung, double pd_lrand, double pd_offset)
public function string uf_tabsetrowheight (integer pi_zeile, integer pd_hoehe)
public function string uf_text (string ps_text, integer pi_stil, boolean pb_ende)
public function string uf_tabtext (integer pi_zeile, integer pi_spalte, string ps_text)
public function string uf_tabtext (integer pi_zeile, integer pi_spalte, string ps_text, integer pi_stil, integer pi_ausrichtung)
public function string uf_text (string ps_text)
public function string uf_textwithposition (string ps_text, double pd_x, double pd_y, integer pi_stil, boolean pb_ende)
public function string uf_tmpclose ()
end prototypes

private subroutine uf_getfontsize (ref INTeger pi_fhoehe, ref INTeger pi_zhoehe);IF pi_fhoehe < 0 THEN
	pi_fhoehe = pi_fhoehe * -1
ELSE
	pi_fhoehe = 8
END IF

pi_zhoehe = CEILING(DOUBLE(pi_fhoehe) / 2.3 )

end subroutine

public function string uf_bitmap (string ps_bmp_name, double pd_x, double pd_y, double pd_breite, double pd_hoehe, integer pi_modus);
irc = this.iRTF_Bitmap(irtf_handle,ps_bmp_name,pd_x,pd_y,pd_breite,pd_hoehe,pi_modus)
If irc < 0 Then
	Return 'Could not create RTF Bitmap object in uf_bitmap of u_rtflib32'
Else
	Return ''
End If

end function

public function string uf_close ();
irc = this.iRTF_Close(irtf_handle)

If irc < 0 Then
	Return 'Could not close file in uf_close of u_rtflib32'
Else
	Return ''
End If

end function

public function string uf_create (ref string ps_filename, boolean pb_meldung, string ps_vorlage);STRING	s_fname

IF irtf_handle < 0 THEN
	irtf_handle = this.iRTF_CreateInstance()
	IF irtf_handle < 0 THEN	
		RETURN 'Could not create instance of RTF file in uf_create of u_rtflib32'
	End If
END IF

irc = GetFileSaveName("WinWord-Export", ps_filename, s_fname, "RTF","RTF Files (*.RTF), *.RTF")

IF irc = 1 THEN
//BLD commented out because we are already doing this
//	IF gf_AskFileExist(ps_filename) > 1 THEN irc = -1		// Existiert Datei bereits

	IF Trim(ps_vorlage) <> "" THEN								// mit Vorlage
	
	//	gf_NI()
		irc= -1
	
//		irc = gf_FileCopy(ps_vorlage, ps_filename, False)
//		IF irc >= 0 THEN
//			irc = this.iRTF_Open(irtf_handle,ps_filename,0)
//		END IF
	ELSE																	// ohne Vorlage
		irc = this.iRTF_Create(irtf_handle,ps_filename,0)
	END IF	
ELSE
	irc = -1
END IF

IF irc = 1 THEN
	this.iRTF_ToolsVersion(False, pb_meldung)
END IF

If irc < 0 Then
	Return 'Could not create instance of file (2) in uf_create of u_rtflib32'
Else
	Return ''
End If

end function

public function string uf_create_rtf (ref string ps_filename, string ps_vorlage);// RTF_Create ohne GetFileOpen()
// HOY 2.12.1996
// Wenn eine <Vorlage> angegeben wird, wird diese kopiert
// und dann geöffnet.

STRING	s_fname

// -- DLL-Instanz --
IF (irtf_handle < 0) THEN
	irtf_handle = this.iRTF_CreateInstance()
	IF (irtf_handle < 0) THEN
		is_return = 'Could not create RTF file instance in uf_create_rtf of u_rtflib32'
		Return is_return
	End If
END IF

// -- Create-RTF --	
IF (TRIM(ps_vorlage) <> "") THEN							// mit Vorlage
	//gf_NI()
	is_return = 'Could not create file (ps_vorlage <> "") in uf_create_rtf of rtflib32'

//	irc = gf_FileCopy(ps_vorlage, ps_filename, False)
//	IF (irc >= 0) THEN
//		irc = this.iRTF_Open(irtf_handle,ps_filename,0)
//	END IF
ELSE																// ohne Vorlage
	irc = this.iRTF_Create(irtf_handle,ps_filename,0)
END IF	
	


RETURN ''
end function

public function string uf_newpage ();
irc = this.iRTF_NewPage(irtf_handle)

if irc < 0 Then
	Return 'Could not create new page in RTF file in uf_newpage of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_open (string ps_filename, boolean pb_meldung);// --- bestehende RTF-Datei öffnen ---
STRING	s_fname

	IF (irtf_handle < 0) THEN
		irtf_handle = this.iRTF_CreateInstance()
		if irtf_handle < 0 Then
			Return 'Could not create instance of file in uf_open of u_rtflib32'
		Else
			Return ''
		End If
	End IF
	
	irc = this.iRTF_Open(irtf_handle,ps_filename,0)
	
	IF (irc = 1) THEN
		this.iRTF_ToolsVersion(False, pb_meldung)
	END IF

if irc < 0 Then
	Return 'Could not create instance of file (2) in uf_open of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_setfont (integer pi_font, integer pi_hoehe, integer pi_stil, integer pi_ausrichtung, integer pi_farbe, double pd_offset);
irc = this.iRTF_SetFont(irtf_handle,pi_font,pi_hoehe,pi_stil,pi_ausrichtung,pi_farbe,pd_offset)

if irc < 0 Then
	Return 'Could not set font in uf_setfont of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_setmargin (double pd_lrand, double pd_rrand, double pd_orand, double pd_urand, double pd_kopfz, double pd_fussz);irc = iRTF_SetMargin(irtf_handle, pd_LRand,pd_RRand,pd_ORand,pd_URand, pd_KopfZ,pd_FussZ)

if irc < 0 Then
	Return 'Could not set margins in uf_setmargin of u_rtflib32'
Else
	Return ''
End If

end function

public function string uf_setpage (string pi_format, double pd_lrand, double pd_rrand, double pd_orand, double pd_urand, double pd_kopf, double pd_fuss);
CHOOSE CASE Upper(pi_format)
	CASE "Q"
		irc = this.iRTF_SetPage(irtf_handle,1,pd_lrand,pd_rrand,pd_orand,pd_urand,pd_kopf,pd_fuss)

	CASE "H"
		irc = this.iRTF_SetPage(irtf_handle,0,pd_lrand,pd_rrand,pd_orand,pd_urand,pd_kopf,pd_fuss)
		
	CASE ELSE
		irc = this.iRTF_SetPage(irtf_handle,-1,pd_lrand,pd_rrand,pd_orand,pd_urand,pd_kopf,pd_fuss)
END CHOOSE


if irc < 0 Then
	Return 'Could not set page in uf_setpage of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_setpage (string ps_format);CHOOSE CASE Upper(ps_format)
	CASE "Q"
		irc = this.iRTF_SetPage(irtf_handle,1,10,10,15,10,1,1)
	CASE "H"
		irc = this.iRTF_SetPage(irtf_handle,0,15,10,10,10,1,1)
	CASE ELSE
		irc = -1
END CHOOSE

if irc < 0 Then
	Return 'Could not set page in uf_setpage of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_tabclose ();

irc = this.iRTF_TabClose(irtf_handle)

if irc < 0 Then
	Return 'Could not close table in uf_tabclose of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_tabcreate (integer pi_zeile, integer pi_spalte, double pd_hoehe, double pd_breite);

irc = this.iRTF_TabCreate(irtf_handle,pi_zeile,pi_spalte,pd_hoehe,pd_breite)

if irc < 0 Then
	Return 'Could not create table in uf_tabcreate of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_tabsetborder ();

irc = this.iRTF_TabSetBorder(irtf_handle,0,0,1,1,1,1,0.1,0.1,0.1,0.1)

if irc < 0 Then
	Return 'Could not set border for table in uf_tabsetborder of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_tabsetborder (integer pi_zeile, integer pi_spalte, integer pi_oben, integer pi_unten, integer pi_links, integer pi_rechts, double pd_b_oben, double pd_b_unten, double pd_b_links, double pd_b_rechts);

irc = this.iRTF_TabSetBorder(irtf_handle,pi_zeile,pi_spalte,pi_oben,pi_unten,pi_links,pi_rechts,pd_b_oben,pd_b_unten,pd_b_links,pd_b_rechts)

if irc < 0 Then
	Return 'Could not set border for table in uf_tabsetborder of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_tabsetcellwidth (integer pi_spalte, double pd_breite);

irc = this.iRTF_TabSetCellWidth(irtf_handle, pi_spalte, pd_breite)

if irc < 0 Then
	Return 'Could not set cell width in uf_tabsetcellwidth of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_tabsetfont (integer pi_zeile, integer pi_spalte, integer pi_font, integer pi_hoehe, integer pi_stil, integer pi_ausrichtung, integer pi_farbe, double pd_offset);

irc = this.iRTF_TabSetFont(irtf_handle,pi_zeile,pi_spalte,pi_font,pi_hoehe,pi_stil,pi_ausrichtung,pi_farbe,pd_offset)

if irc < 0 Then
	Return 'Could not set table font in uf_tabsetcellwidth of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_tabsetformat (integer pi_ausrichtung, double pd_lrand, double pd_offset);

irc = this.iRTF_TabSetFormat(irtf_handle, pi_ausrichtung,pd_lrand,pd_offset,pd_offset)

if irc < 0 Then
	Return 'Could not set table format in uf_tabsetformat of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_tabsetrowheight (integer pi_zeile, integer pd_hoehe);

irc = this.iRTF_TabSetRowHeight(irtf_handle,pi_zeile,pd_hoehe)

if irc < 0 Then
	Return 'Could not set row height in uf_tabsetrowheight of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_text (string ps_text, integer pi_stil, boolean pb_ende);

IF pb_ende THEN
	irc = this.iRTF_Text(irtf_handle, ps_text, pi_stil, 1)
ELSE
	irc = this.iRTF_Text(irtf_handle, ps_text, pi_stil, 0)
END IF

if irc < 0 Then
	Return 'Could not insert table text in uf_text of u_rtflib32'
Else
	Return ''
End If

end function

public function string uf_tabtext (integer pi_zeile, integer pi_spalte, string ps_text);Return uf_tabtext(pi_zeile,pi_spalte,ps_text,0,1)

end function

public function string uf_tabtext (integer pi_zeile, integer pi_spalte, string ps_text, integer pi_stil, integer pi_ausrichtung);

irc = this.iRTF_TabText(irtf_handle,pi_zeile,pi_spalte,ps_text,pi_stil,pi_ausrichtung)

if irc < 0 Then
	Return 'Could not set table text in uf_tabtext of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_text (string ps_text);

irc = this.iRTF_Text(irtf_handle,ps_text,0,0)

if irc < 0 Then
	Return 'Could not set text in uf_text of u_rtflib32'
Else
	Return ''
End If
end function

public function string uf_textwithposition (string ps_text, double pd_x, double pd_y, integer pi_stil, boolean pb_ende);

IF pb_ende THEN
	irc = this.iRTF_TextWithPosition(irtf_handle, ps_text, pd_x, pd_y, pi_stil, 1)
ELSE
	irc = this.iRTF_TextWithPosition(irtf_handle, ps_text, pd_x, pd_y, pi_stil, 0)
END IF

if irc < 0 Then
	Return 'Could not set text with position in uf_textwithposition of u_rtflib32'
Else
	Return ''
End If

end function

public function string uf_tmpclose ();

irc = iRTF_TmpClose(irtf_handle)

if irc < 0 Then
	Return 'Could not tmpclose in uf_tmpclose of u_rtflib32'
Else
	Return ''
End If
end function

on n_rtf_builder_32bit.create
TriggerEvent( this, "constructor" )
end on

on n_rtf_builder_32bit.destroy
TriggerEvent( this, "destructor" )
end on

event destructor;this.RTF_DestroyInstance (irtf_handle)
end event

