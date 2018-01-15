$PBExportHeader$n_secca_def.sru
$PBExportComments$Application service to handle security class defaults
forward
global type n_secca_def from datastore
end type
end forward

global type n_secca_def from datastore
string DataObject="d_secca_def_std"
end type
global n_secca_def n_secca_def

type variables
S_SECCA_DEF	is_SECCA
end variables

forward prototypes
public function string fu_getdefault (string object_type, string default_type)
public function integer fu_setdefault (string object_type, string default_type, string value)
end prototypes

public function string fu_getdefault (string object_type, string default_type);//******************************************************************
//  PC Module     : n_SECCA_DEF
//  Function      : fu_GetDefault
//  Description   : Gets the default value for an object.
//
//  Parameters    : STRING Object_Type -
//                     Type of object (e.g. security).
//                  STRING Default_Type -
//                     The part of the object the default value
//                     applies to (e.g. message).
//
//  Return Value  : STRING -
//                     Returns default value in a string.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

LONG   l_NumDefaults, l_Row
STRING l_Value

l_NumDefaults = RowCount()

l_Row = Find("object_type = '" + object_type + &
             "' AND default_type = '" + default_type + "'", &
				 1, l_NumDefaults)
IF l_Row > 0 THEN
	l_Value = GetItemString(l_Row, "value")
	IF IsNull(l_Value) <> FALSE THEN
		l_Value = ""
	END IF
ELSE
	l_Value = ""
END IF

RETURN l_Value
end function

public function integer fu_setdefault (string object_type, string default_type, string value);//******************************************************************
//  PC Module     : n_SECCA_DEF
//  Function      : fu_SetDefault
//  Description   : Sets the default value for an object.
//
//  Parameters    : STRING Object_Type -
//                     Type of object (e.g. security).
//                  STRING Default_Type -
//                     The part of the object the default value
//                     applies to (e.g. message).
//                  STRING Value -
//                     The default value to set.
//
//  Return Value  : INTEGER -
//                      0 - Default value set.
//                     -1 - Object, default, or parameter not found.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

LONG l_NumDefaults, l_Row

l_NumDefaults = RowCount()

l_Row = Find("object_type = '" + object_type + &
             "' AND default_type = '" + default_type + "'", &
				 1, l_NumDefaults)
IF l_Row > 0 THEN
	SetItem(l_Row, "value", value)
	RETURN 0
ELSE
	RETURN -1
END IF
end function

on n_secca_def.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on n_secca_def.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

