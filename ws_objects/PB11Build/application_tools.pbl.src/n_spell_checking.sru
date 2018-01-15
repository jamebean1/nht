$PBExportHeader$n_spell_checking.sru
forward
global type n_spell_checking from nonvisualobject
end type
end forward

global type n_spell_checking from nonvisualobject
end type
global n_spell_checking n_spell_checking

type prototypes
// WinterTree Spell Checker Calls
FUNCTION long SSCE_CheckBlockDlg(Ulong handle, ref string as_string, long al_length, long al_size, int ai_show_context) LIBRARY "SSCE5532.DLL" alias for "SSCE_CheckBlockDlg;Ansi"
FUNCTION int SSCE_SetKey(long al_key) LIBRARY "SSCE5532.DLL"
FUNCTION int SSCE_SetIniFile(string as_file) LIBRARY "SSCE5532.DLL" alias for "SSCE_SetIniFile;Ansi"
FUNCTION int SSCE_OpenSession() LIBRARY "SSCE5532.DLL"
FUNCTION int SSCE_CloseSession(int ai_sid) LIBRARY "SSCE5532.DLL"
FUNCTION int SSCE_SetMainLexPath(string as_file) LIBRARY "SSCE5532.DLL" alias for "SSCE_SetMainLexPath;Ansi"
FUNCTION int SSCE_SetUserLexPath(string as_file) LIBRARY "SSCE5532.DLL" alias for "SSCE_SetUserLexPath;Ansi"
FUNCTION int SSCE_SetMainLexFiles(string as_file) LIBRARY "SSCE5532.DLL" alias for "SSCE_SetMainLexFiles;Ansi"
FUNCTION int SSCE_SetUserLexFiles(string as_file) LIBRARY "SSCE5532.DLL" alias for "SSCE_SetUserLexFiles;Ansi"
FUNCTION int SSCE_SetHelpFile(string as_file) LIBRARY "SSCE5532.DLL" alias for "SSCE_SetHelpFile;Ansi"


end prototypes
on n_spell_checking.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_spell_checking.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

