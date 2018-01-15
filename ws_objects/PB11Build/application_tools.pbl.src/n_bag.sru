$PBExportHeader$n_bag.sru
forward
global type n_bag from nonvisualobject
end type
type os_item from structure within n_bag
end type
end forward

type os_item from structure
	string		s_desc
	any		a_item
end type

shared variables

end variables

global type n_bag from nonvisualobject
end type
global n_bag n_bag

type variables
Protected:
os_item istr[]
int ii_loopmax = 0, ii_max, ii_loop[]


end variables

forward prototypes
public function any of_get (string as_desc)
public function integer of_remove (string as_desc)
public function integer of_loopbegin ()
public function boolean of_loopnext (integer ai_loop, ref string as_desc, ref any aa_item)
public function boolean of_loopnext (integer ai_loop)
public function any of_get (integer ai_loop)
public function string of_getdesc (integer ai_loop)
public function boolean of_exists (string as_desc)
public function integer of_count ()
protected function integer of_find (string as_desc)
protected function integer of_copy (os_item astr[], integer ai_loop[], integer ai_loopmax, integer ai_max)
public function integer of_renamedesc (string as_desc, string as_newdesc)
public function string of_getstring (string as_desc)
public function long of_getlong (string as_desc)
public function integer of_getinteger (string as_desc)
public function boolean of_getboolean (string as_desc)
public function string of_getstring (integer ai_loop)
public function integer of_getinteger (integer ai_loop)
public function double of_getdouble (string as_desc)
public function integer of_set (datastore ads, long al_row, string as_type)
public function n_bag of_copy ()
public function integer of_set (n_bag anv_bag)
public function integer of_set (string as_desc, any aa_item)
public function integer of_set (ref string as_arguments)
public function long of_reset ()
end prototypes

public function any of_get (string as_desc);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

int li

li = of_find(as_desc)

IF li > 0 THEN
	RETURN istr[li].a_item
END IF

any la
setnull(la)
RETURN la

end function

public function integer of_remove (string as_desc);//************************************************************
// Object: n_cst_dstruct
// Method: of_remove
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: integer
//
// Return Codes:
//		 1 - Item was removed
//		-1 - Not Found
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

int li_rc = 3
uint lui

lui = of_find(as_desc)

IF lui > 0 THEN
	SetNull(istr[lui].s_desc)
	RETURN 1
END IF
	
RETURN -1

end function

public function integer of_loopbegin ();ii_loopmax ++
ii_loop[ii_loopmax] = 0

RETURN ii_loopmax

end function

public function boolean of_loopnext (integer ai_loop, ref string as_desc, ref any aa_item);boolean lb

lb = of_loopnext(ai_loop)

IF lb THEN
	as_desc = istr[ii_loop[ai_loop]].s_desc
	aa_item = istr[ii_loop[ai_loop]].a_item
END IF

RETURN lb

end function

public function boolean of_loopnext (integer ai_loop);IF ii_loopmax < ai_loop THEN RETURN FALSE

IF ii_max < ii_loop[ai_loop] OR ii_max = 0 THEN RETURN FALSE

DO
	ii_loop[ai_loop] ++
	IF ii_max < ii_loop[ai_loop] THEN RETURN FALSE
LOOP UNTIL NOT IsNull(istr[ ii_loop[ai_loop] ])

RETURN TRUE

end function

public function any of_get (integer ai_loop);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

IF ii_loopmax < ai_loop THEN
	any la
	SetNULL(la)
	RETURN la
END IF

IF ii_max >= ii_loop[ai_loop] THEN
	RETURN istr[ii_loop[ai_loop]].a_item
END IF

any la2
SetNULL(la2)
RETURN la2

end function

public function string of_getdesc (integer ai_loop);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

IF ii_loopmax < ai_loop THEN
	string ls
	SetNULL(ls)
	RETURN ls
END IF

IF ii_max >= ii_loop[ai_loop] THEN
	RETURN istr[ii_loop[ai_loop]].s_desc
END IF

string ls2
SetNULL(ls2)
RETURN ls2

end function

public function boolean of_exists (string as_desc);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

IF of_find(as_desc) > 0 THEN
	RETURN TRUE
END IF

RETURN FALSE

end function

public function integer of_count ();int li, li_count

IF ii_max = 0 THEN RETURN 0

FOR li = 1 TO ii_max
	IF NOT isnull(istr[li]) THEN
		li_count ++
	END IF
NEXT

RETURN li_count

end function

protected function integer of_find (string as_desc);//************************************************************
// Object: n_cst_dstruct
// Method: of_finddesc
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: n_cst_dstruct
//
// Return Codes:
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

int li

FOR li = 1 TO ii_max
	IF NOT isnull(istr[li]) THEN
		IF trim(upper(as_desc)) = trim(upper(istr[li].s_desc)) THEN
			RETURN li
		END IF
	END IF
NEXT

RETURN 0
end function

protected function integer of_copy (os_item astr[], integer ai_loop[], integer ai_loopmax, integer ai_max);istr = astr
ii_loop = ai_loop
ii_loopmax = ai_loopmax
ii_max = ai_max

RETURN 1

end function

public function integer of_renamedesc (string as_desc, string as_newdesc);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

int li

li = of_find(as_desc)

IF li > 0 THEN
	IF of_Find(as_newdesc) < 1 THEN
		istr[li].s_desc = as_newdesc
		RETURN 1
	ELSE
		RETURN -2
	END IF
END IF

RETURN -1

end function

public function string of_getstring (string as_desc);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

int li

li = of_find(as_desc)

IF li > 0 THEN
	RETURN string(istr[li].a_item)
END IF

string ls
setnull(ls)
RETURN ls

end function

public function long of_getlong (string as_desc);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

int li

li = of_find(as_desc)

IF li > 0 THEN
	RETURN long(istr[li].a_item)
END IF

long ll
setnull(ll)
RETURN ll

end function

public function integer of_getinteger (string as_desc);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

int li

li = of_find(as_desc)

IF li > 0 THEN
	RETURN integer(istr[li].a_item)
END IF

setnull(li)
RETURN li

end function

public function boolean of_getboolean (string as_desc);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

int li
integer li_data

li = of_find(as_desc)

IF li > 0 THEN
	li_data= (istr[li].a_item)
	if li_data>0 then 
		return true
	else
		return false
	end if
END IF

boolean lb
setnull(lb)
RETURN lb
end function

public function string of_getstring (integer ai_loop);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

IF ii_loopmax < ai_loop THEN
	string ls
	SetNULL(ls)
	RETURN ls
END IF

IF ii_max >= ii_loop[ai_loop] THEN
	RETURN String(istr[ii_loop[ai_loop]].a_item)
END IF

any ls2
SetNULL(ls2)
RETURN ls2

end function

public function integer of_getinteger (integer ai_loop);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

IF ii_loopmax < ai_loop THEN
	integer li
	SetNULL(li)
	RETURN li
END IF

IF ii_max >= ii_loop[ai_loop] THEN
	RETURN Integer(istr[ii_loop[ai_loop]].a_item)
END IF

any li2
SetNULL(li2)
RETURN li2

end function

public function double of_getdouble (string as_desc);//************************************************************
// Object: n_cst_dstruct
// Method: of_get
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: any
//
// Return Codes:
//				ia_item if as_desc is found.
//				NULL if as_desc is not found.
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//
//************************************************************

int li

li = of_find(as_desc)

IF li > 0 THEN
	RETURN double(istr[li].a_item)
END IF

double ldble
setnull(ldble)
RETURN ldble
end function

public function integer of_set (datastore ads, long al_row, string as_type);//************************************************************
// Object: n_cst_dstruct
// Method: of_add
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: integer
//
// Return Codes:
//		-1 - Invalid Arguments
//		 1 - Set Columns
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//************************************************************

IF al_row > ads.RowCount() or al_row < 1 THEN
	RETURN -1
END IF

CHOOSE CASE lower(as_type)
	CASE "dbname" 
		as_type = "dbName"
		
	CASE "name" 
		as_type = "Name"

	CASE ELSE
		RETURN -1
END CHOOSE

integer li

FOR li = integer(ads.Object.DataWindow.Column.Count) TO 1 STEP -1
	of_Set(ads.Describe("#" + string(li) + "." + as_type ),ads.object.Data[ al_row, li ] )
NEXT

RETURN 1

end function

public function n_bag of_copy ();n_bag lnv_new

lnv_new = CREATE n_bag

lnv_new.of_copy(istr,ii_loop,ii_loopmax,ii_max)

RETURN lnv_new

end function

public function integer of_set (n_bag anv_bag);//************************************************************
// Object: n_cst_dstruct
// Method: of_add
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: integer
//
// Return Codes:
//		 3 - Added Item
//		 2 - Set Existing Item (different data type)
//		 1 - Set Existing Item (same data type)
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//04/24/97 CWB    Changed new links to be added to front of list 
//						instead of end. (Faster performance)
//************************************************************

IF NOT IsValid(anv_bag) OR IsNull(anv_bag) THEN
	RETURN 0
END IF

int li_loop

li_loop = anv_bag.of_LoopBegin()
DO WHILE anv_bag.of_LoopNext(li_loop)
	of_Set(anv_bag.of_GetDesc(li_loop),anv_bag.of_Get(li_loop))
LOOP

RETURN 1
end function

public function integer of_set (string as_desc, any aa_item);//************************************************************
// Object: n_cst_dstruct
// Method: of_add
// Author: Joel White
// Date  : 4/3/97
//
// Arg   :
// Return: integer
//
// Return Codes:
//		 3 - Added Item
//		 2 - Set Existing Item (different data type)
//		 1 - Set Existing Item (same data type)
//
// Desc  :
//
//************************************************************
// Modifications:
// Date   Author  Comments
//------------------------------------------------------------
//04/24/97 CWB    Changed new links to be added to front of list 
//						instead of end. (Faster performance)
//************************************************************

int li_rc = 3
os_item lstr
int li

lstr.s_desc = as_desc
lstr.a_item = aa_item
li = of_find(as_desc)

IF li = 0 THEN
	ii_max ++
	li = ii_max
END IF

istr[li] = lstr

RETURN li_rc

end function

public function integer of_set (ref string as_arguments);string ls_columns[], ls_values[]
long ll_columns, ll_values, ll_LC

if isnull(as_arguments) then return -1

//n_string_functions ln_string

gn_globals.in_string_functions.of_parse_arguments(as_arguments,ls_columns, ls_values)

ll_columns = upperbound(ls_columns)
ll_values = upperbound(ls_values)

if ll_columns = 0 or ll_values = 0 then return -1
if ll_columns<>ll_values then return -1

for ll_LC = 1 to ll_columns
	this.of_set(ls_columns[ll_LC],ls_values[ll_LC])
next




return 1
end function

public function long of_reset ();
os_item	lstr_null[]

istr = lstr_null

ii_max = 0

return 1
end function

on n_bag.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_bag.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//
end event

