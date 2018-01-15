$PBExportHeader$n_object_data.sru
$PBExportComments$Object that contains the necessary information for the Expression Evaluator to operate on. GLH
forward
global type n_object_data from nonvisualobject
end type
end forward

global type n_object_data from nonvisualobject
end type
global n_object_data n_object_data

type variables
string 				is_objectname[]
boolean				ib_objectisvalid[]
nonvisualobject 	in_object[]
string				is_objectfunction[]
boolean				ib_objecthasfunction[]

n_class_functions in_class_functions

end variables

forward prototypes
public function boolean of_exists (string as_objectname)
public subroutine of_reset ()
public subroutine of_destroy_objects ()
public function boolean of_isvalid (string as_objectname)
public function nonvisualobject of_get (string as_objectname)
public function long of_add (string as_objectname, boolean ab_createobject)
public function boolean of_objecthasfunction (nonvisualobject an_object, string as_function, string as_argumenttype)
end prototypes

public function boolean of_exists (string as_objectname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_exists()
//	Arguments:  as_objectname - object name to check for
//	Overview:   Check to see if the object exists.
//	Created by:	Denton Newham
//	History: 	7/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
long l_upperbound, i

//-----------------------------------------------------------------------------------------------------------------------------------
// Lower the column name and get the upperbound
//-----------------------------------------------------------------------------------------------------------------------------------
as_objectname = lower(Trim(as_objectname))
l_upperbound = UpperBound(is_objectname[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure it exists
//-----------------------------------------------------------------------------------------------------------------------------------
For i = 1 to l_upperbound
	If as_objectname = Lower(is_objectname[i]) Then Return True
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure it exists
//-----------------------------------------------------------------------------------------------------------------------------------
Return False
end function

public subroutine of_reset ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_reset()
//	Arguments:  NONE
//	Overview:   Reset the arrays and expression to null
//	Created by:	Gary Howard
//	History: 	2/5/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
boolean lb_converted[]
string ls_null[]

is_objectname[]				= ls_null[]
ib_objectisvalid[]			= lb_converted[]

This.of_destroy_objects()

end subroutine

public subroutine of_destroy_objects ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_destroy_objects()
//	Arguments:  NONE
//	Overview:   Destroy the objects.
//	Created by:	Denton Newham
//	History: 	09/05/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	l_upperbound, i

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects.
//-----------------------------------------------------------------------------------------------------------------------------------
l_upperbound = UpperBound(in_object[])
For i = 1 to l_upperbound
	If IsValid(in_object[i]) Then Destroy in_object[i]
Next
		
end subroutine

public function boolean of_isvalid (string as_objectname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_isvalid()
//	Arguments:  as_column - column name to check for
//	Overview:   Check datatype and column name to ensure valid values have been entered.
//	Created by:	Gary Howard
//	History: 	2/15/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_upperbound, i
boolean b_isvalidobjectname = FALSE

as_objectname = lower(as_objectname)
l_upperbound = Min(UpperBound(is_objectname[]), UpperBound(in_object[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure it's a valid column.
//-----------------------------------------------------------------------------------------------------------------------------------
For i = 1 to l_upperbound
	If as_objectname = Lower(is_objectname[i]) Then 
		b_isvalidobjectname = ib_objectisvalid[i]
		Exit
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If it's not a valid object then return false.
//-----------------------------------------------------------------------------------------------------------------------------------
Return b_isvalidobjectname



end function

public function nonvisualobject of_get (string as_objectname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_object()
//	Arguments:  as_objectname - column name you want a value for
//	Overview:   This function is intended to keep developer's from having to write the loop to loop through the object to determine if 
//					an object exists. If the object does not exist, a null object will be returned.
//	Created by:	Denton Newham
//	History: 	2/15/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_upperbound, i
nonvisualobject ln_null

SetNull(ln_null)

as_objectname = trim(lower(as_objectname))
l_upperbound = Min(UpperBound(is_objectname[]), UpperBound(in_object[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure it's a valid column.
//-----------------------------------------------------------------------------------------------------------------------------------
For i = 1 to l_upperbound
	If as_objectname = Lower(is_objectname[i]) Then
		Return in_object[i]
		Exit
	End If
Next

Return ln_null
end function

public function long of_add (string as_objectname, boolean ab_createobject);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add()
//	Arguments:  as_objectname - object name you to add.
//	Overview:   Add an object to the array.
//	Created by:	Denton Newham
//	History: 	2/15/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long ll_upperbound
nonvisualobject ln_null

SetNull(ln_null)

ll_upperbound = UpperBound(is_objectname) + 1

is_objectname[ll_upperbound] 		= as_objectname
ib_objectisvalid[ll_upperbound]	= in_class_functions.of_isvalid(as_objectname)


If ib_objectisvalid[ll_upperbound] And ab_createobject Then 
	in_object[ll_upperbound] = Create Using as_objectname
Else
	in_object[ll_upperbound]			= ln_null
End If

Return ll_upperbound
end function

public function boolean of_objecthasfunction (nonvisualobject an_object, string as_function, string as_argumenttype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_objecthasfunction()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	12/26/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_index, ll_upperbound
String	ls_objectfunction, ls_objectclass, ls_functionname, ls_functionarguments

ll_upperbound = Min(UpperBound(is_objectfunction), UpperBound(ib_objecthasfunction))

For ll_index = 1 To ll_upperbound
	ls_objectfunction		= is_objectfunction[ll_index]

	ls_objectclass			= Mid(ls_objectfunction, 1, Pos(ls_objectfunction, '||') - 1)
	ls_objectfunction		= Mid(ls_objectfunction, Pos(ls_objectfunction, '||') + 2)	
	If Lower(Trim(ls_objectclass)) <> Lower(Trim(an_object.ClassName())) Then Continue
	
	ls_functionname		= Mid(ls_objectfunction, 1, Pos(ls_objectfunction, '||') - 1)
	If Lower(Trim(ls_functionname)) <> Lower(Trim(as_function)) Then Continue
	
	ls_functionarguments	= Mid(ls_objectfunction, Pos(ls_objectfunction, '||') + 2)
	If Lower(Trim(ls_functionarguments)) <> Lower(Trim(as_argumenttype)) Then Continue	
	
	Return ib_objecthasfunction[ll_index]

Next

is_objectfunction[ll_upperbound + 1] 	= an_object.ClassName() + '||' + as_function + '||' + as_argumenttype
ib_objecthasfunction[ll_upperbound + 1]= in_class_functions.of_hasfunction(an_object, as_function, as_argumenttype)

Return ib_objecthasfunction[ll_upperbound + 1]
end function

on n_object_data.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_object_data.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Destructor
//	Overrides:  No
//	Arguments:	NONE
//	Overview:   Destroy the objects that have been created to evaluate certain attributes and system variables.
//	Created by: Gary Howard
//	History:    4/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_destroy_objects()


end event

