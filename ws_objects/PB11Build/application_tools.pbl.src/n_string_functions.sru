$PBExportHeader$n_string_functions.sru
forward
global type n_string_functions from nonvisualobject
end type
end forward

global type n_string_functions from nonvisualobject
end type
global n_string_functions n_string_functions

forward prototypes
public subroutine of_parse_string (string s_string, string s_delimiter, ref string s_string_array[])
public function string of_build_argument_string (string as_delimiter, string as_arguments[], string as_values[])
public function long of_countoccurrences (string as_source, string as_target, boolean ab_ignorecase)
public function boolean of_iscomparisonoperator (string as_source)
public function boolean of_isformat (string as_source)
public function boolean of_islower (string as_source)
public function boolean of_isprintable (string as_source)
public function boolean of_ispunctuation (string as_source)
public function boolean of_isupper (string as_source)
public function boolean of_isspace (string as_source)
public function boolean of_iswhitespace (string as_source)
public function long of_lastpos (string as_source, string as_target)
public function long of_lastpos (string as_source, string as_target, long al_start)
public function string of_padleft (string as_source, long al_length)
public function string of_padright (string as_source, long al_length)
public function string of_quote (string as_source)
public function string of_lefttrim (string as_source, boolean ab_remove_spaces, boolean ab_remove_nonprint)
public function string of_removenonprint (string as_source)
public function string of_removewhitespace (string as_source)
public function string of_righttrim (string as_source, boolean ab_remove_spaces, boolean ab_remove_nonprint)
public function string of_trim (string as_source, boolean ab_remove_spaces, boolean ab_remove_nonprint)
public function string of_wordcap (string as_source)
public function boolean of_isarithmeticoperator (string as_source)
public function boolean of_isalpha (string as_source)
public function string of_find_argument (string as_argument, string as_arguments[], string as_values[])
public function string of_find_argument (string as_argumentstring, string as_delimiter, string as_argumenttofind)
public function string of_gettoken (ref string as_source, string as_separator)
public function string of_replace_all (string as_string, string as_replace, string as_replace_with, boolean ab_ignorecase)
public subroutine of_replace_all (ref string as_string, string as_replace, string as_replace_with)
public function boolean of_replace_argument (string as_argument, ref string as_argumentstring, string as_delimiter, string as_value)
public function boolean of_replace_argument (string as_argument, string as_arguments[], ref string as_values[], string as_value)
public subroutine of_parse_arguments (string s_string, ref string s_name_array[], ref string s_value_array[])
public subroutine of_parse_arguments (string as_data, string as_delimiter, ref string as_arguments[], ref string as_values[])
public subroutine of_parse_string (string as_source, string as_delimiter, ref string as_target[], boolean ab_wysiwyg)
public subroutine of_parse_arguments (string as_data, string as_delimiter, ref string as_arguments[], ref string as_values[], boolean ab_wysiwyg)
public function string of_arraytostring (string as_source[], string as_delimiter, boolean ab_include_empty_strings)
public function long of_convert_string_to_character_array (string as_string, ref string as_array[])
public function string of_convert_datetime_to_string (datetime adt_convert)
public function string of_convert_date_to_string (date adt_date)
public function date of_convert_string_to_date (string as_date, string as_format)
public function string of_replace_all (string as_string, string as_replace, string as_replace_with, boolean ab_ignorecase, boolean ab_checkforalphanumerics)
public function string of_convert_multidates_to_string (string as_datestring)
public function long of_countoccurrences (string as_source, string as_target)
public function boolean of_iswellformedemailaddress (string as_emailaddress)
public function string of_convert_multidates_to_string (ref date ad_dates[])
public function boolean of_isalphanum (string as_source)
public function string of_removenonalphanumeric (string as_source)
public function string of_arraytogrammarstring (string as_source[], string as_delimiter, string as_conjunction)
public function datetime of_convert_string_to_datetime (string as_string)
public function datetime of_convert_string_to_datetime (string as_datetime, string as_format)
public function string of_convert_datetime_to_xsdstring (datetime adt_convert)
public function string of_replace_all (string as_string, string as_replace, string as_replace_with, boolean ab_ignorecase, boolean ab_checkforalphanumerics, boolean ab_checkforspecialcharacters)
end prototypes

public subroutine of_parse_string (string s_string, string s_delimiter, ref string s_string_array[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_parse_string()
// Arguments:	s_string - string to parse
//					s_delimiter - delimter characters to parse on.
//					s_string_array[] - reference string array to fill in with the parsed values.
// Overview:	Parse the string into an array based on the specIfied delimiter
// Created by:	Joel White
// History:		12/12/04 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long l_pos_delimiter,l_Loop, l_pos_start=1
string s_key,s_key_remaining,s_currentkey

//-------------------------------------------------------------------
// Find the delimiter string
//-------------------------------------------------------------------
If len(trim(s_string)) = 0 or IsNull(s_string) Then Return

l_pos_delimiter = pos(s_string,s_delimiter)

If l_pos_delimiter = 0 Then 
	s_string_array[1] = s_string
	Return
End If

//-------------------------------------------------------------------
// Parse from left to right and put the values into the array.
//-------------------------------------------------------------------
s_key = left(s_string,l_pos_delimiter -1)
s_key_remaining = right(s_string,len(s_string) - l_pos_delimiter - len(s_delimiter) + 1 )

Do While l_pos_delimiter > 0 

	//-------------------------------------------------------------------
	// If the key starts with a quote (either single or double), make sure
	//	it Ends in a quote of the same kind.  If not, we have found a
	// delimiter inside a quoted string.  Therefore, reassemble the string
	// and look for the next delimiter.
	//-------------------------------------------------------------------
	
	If (left( s_key, 1) = "'" and right( s_key, 1) <> "'") OR &
		(left( s_key, 1) = '"' and right( s_key, 1) <> '"') then
		s_key_remaining = s_key + s_delimiter + s_key_remaining
		l_pos_start = l_pos_delimiter + 1
	else
		If len(s_key) > 2 AND &
			(left(s_key,1) = "'" and right( s_key, 1) = "'") OR &
			(left(s_key,1) = '"' and right( s_key, 1) = '"') then
			s_key = mid( s_key, 2, len(s_key) - 2)
		End If
		l_Loop ++
		s_string_array[l_Loop]	= s_key
		l_pos_start = 1
	End If
	
	l_pos_delimiter = pos(s_key_remaining,s_delimiter, l_pos_start)

	If l_pos_delimiter = 0 then
		s_key = s_key_remaining
		If len(s_key) > 2 AND &
			(left(s_key,1) = "'" and right( s_key, 1) = "'") OR &
			(left(s_key,1) = '"' and right( s_key, 1) = '"') then
			s_key = mid( s_key, 2, len(s_key) - 2)
		End If
		l_Loop ++
		s_string_array[l_Loop] = s_key
	End If

	
	s_key = left(s_key_remaining,l_pos_delimiter -1)
	s_key_remaining = right(s_key_remaining,len(s_key_remaining) - l_pos_delimiter - len(s_delimiter) + 1)
Loop

If upperbound(s_string_array) = 0 then
	s_string_array[1] = s_string
End If



end subroutine

public function string of_build_argument_string (string as_delimiter, string as_arguments[], string as_values[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_argument_string()
//	Arguments:  as_delimiter - The delimiter
//					as_arguments[] - the array of arguments
//					as_values[] - the array of values
//	Overview:   Build a X delimited string from the arrays passed in.  The form is argument=value{delimiter}argument=value
//	Created by:	Joel White
//	History: 	1/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long l_upperbound, l_index
String ls_build_string = ''

l_upperbound = Min(UpperBound(as_arguments), UpperBound(as_values))
For l_index = 1 To l_upperbound
	If Not IsNull(as_arguments[l_index]) And Not IsNull(as_values[l_index]) Then
		ls_build_string = ls_build_string + as_arguments[l_index] + '=' + as_values[l_index] + as_delimiter
	End If
Next

ls_build_string = Left(ls_build_string, Len(ls_build_string) - Len(as_delimiter))

Return ls_build_string
end function

public function long of_countoccurrences (string as_source, string as_target, boolean ab_ignorecase);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_countoccurrences()
//	Arguments:  as_source - The string in which to search
//					as_target - The string to search for
//					ab_IgnoreCase - boolean stating to ignore case sensitivity.
//	Overview:   Count the number of occurrences of a specIfied string within another. 
//	Created by:	Joel White
//	History: 	1/12/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long	l_Count, l_Pos, l_Len

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure parameters are valid.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or IsNull(as_target) or IsNull(ab_ignorecase) Then
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Should function ignore case?
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_ignorecase Then
	as_source = Lower(as_source)
	as_target = Lower(as_target)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Loop through string incrementing count every time we find an ocurrence of the target string.
//-----------------------------------------------------------------------------------------------------------------------------------
l_Len = Len(as_Target)
l_Count = 0
l_Pos = Pos(as_source, as_Target)

Do While l_Pos > 0
	l_Count ++
	l_Pos = Pos(as_source, as_Target, (l_Pos + l_Len))
Loop

Return l_Count

end function

public function boolean of_iscomparisonoperator (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_iscomparisonoperator()
//	Arguments:  as_source - The source string.
//	Returns:  	Boolean
//					True If the string only contains Comparison Operator
//					characters.
//					If as_source is NULL, the function Returns NULL.
//	Overview:   Determines whether a string contains only Comparison
//					Operator characters.
//	Created by:	Joel White
//	History: 	1/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		l_count=0
long		l_length
char		c_char[]
integer	i_ascii

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure parameters have valid values.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get the length
//-----------------------------------------------------------------------------------------------------------------------------------
l_length = Len (as_source)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for at least one character
//-----------------------------------------------------------------------------------------------------------------------------------
If l_length=0 Then
	Return False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Move string into array of chars
//-----------------------------------------------------------------------------------------------------------------------------------
c_char[] = as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//	Perform Loop around all characters
//	Quit Loop If Non Operator character is found
//-----------------------------------------------------------------------------------------------------------------------------------
Do While l_count<l_length
	l_count ++
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Get ASC code of character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	i_ascii = Asc (c_char[l_count])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Character is an Comparison Operator.
	//	Continue with the next character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If i_ascii=60 or			/* < less than */	 & 
		i_ascii=61 or			/* = equal */		 & 
		i_ascii=62 Then		/* > greater than */
	Else
		Return False
		Exit
	End If
Loop
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Entire string is made of Comparison Operators.
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public function boolean of_isformat (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsFormat()
//	Arguments:  as_source - The source string.
//	Returns:  	Boolean
//					True If the string only contains Formatting characters.
//					If as_source is NULL, the function Returns NULL.
//	Overview:   Determines whether a string contains only Formatting
//					characters.  Format characters for this function
//					are all printable characters that are not AlphaNumeric.
//	Created by:	Joel White
//	History: 	1/10/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		l_count=0
long		l_length
char		c_char[]
integer	i_ascii

//-----------------------------------------------------------------------------------------------------------------------------------
//	Ensure parameters have valid values.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get the length
//-----------------------------------------------------------------------------------------------------------------------------------
l_length = Len (as_source)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for at least one character
//-----------------------------------------------------------------------------------------------------------------------------------
If l_length=0 Then
	Return False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Move string into array of chars
//-----------------------------------------------------------------------------------------------------------------------------------
c_char = as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//	Perform Loop around all characters
//	Quit Loop If Non Operator character is found
//-----------------------------------------------------------------------------------------------------------------------------------
Do While l_count<l_length
	l_count ++
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Get ASC code of character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	i_ascii = Asc (c_char[l_count])

	//-----------------------------------------------------------------------------------------------------------------------------------
	//Character is a Format.
	//Continue with the next character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If (i_ascii>=33 and i_ascii<=47) or &
		(i_ascii>=58 and i_ascii<=64) or &
		(i_ascii>=91 and i_ascii<=96) or &
		(i_ascii>=123 and i_ascii<=126) Then
	Else
		Return False
		Exit
	End If
Loop
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Entire string is made of Format characters.
//-----------------------------------------------------------------------------------------------------------------------------------
Return True

end function

public function boolean of_islower (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsLower()
//	Arguments:  as_source		The source string.
//	Returns:		Boolean
//					True If the string only contains lowercase characters. 
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Determines whether a string contains only lowercase characters.
//	Created by:	Joel White
//	History: 	1/20/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure parameters have valid values
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	If the lowercase is the same as the current, then it's all lowercase
//-----------------------------------------------------------------------------------------------------------------------------------
If as_source = Lower(as_source) Then
	Return True
Else
	Return False
End If
end function

public function boolean of_isprintable (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsPrintable()
//	Arguments:  as_source		The source string.
//	Returns: 	Boolean
//					True If the string only contains Printable characters.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Determines whether a string is composed entirely of Printable characters.
//	Created by:	Joel White
//	History: 	1/11/2000% - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		l_count=0
long		l_length
char		c_char[]
integer	i_ascii

//-----------------------------------------------------------------------------------------------------------------------------------
//	Ensure parameters have valid values.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get the length
//-----------------------------------------------------------------------------------------------------------------------------------
l_length = Len (as_source)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for at least one character
//-----------------------------------------------------------------------------------------------------------------------------------
If l_length=0 Then
	Return False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Move string into array of chars
//-----------------------------------------------------------------------------------------------------------------------------------
c_char[] = as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//	Perform Loop around all characters
//	Quit Loop If NonPrintable character is found
//-----------------------------------------------------------------------------------------------------------------------------------
Do While l_count < l_length
	l_count ++
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//Get ASC code of character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	i_ascii = Asc (c_char[l_count])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// 'space'=32, '~'=126
	//-----------------------------------------------------------------------------------------------------------------------------------
	If i_ascii<32 or i_ascii>126 then
		/* Not a printable character */
		Return False
	End If
Loop

//-----------------------------------------------------------------------------------------------------------------------------------
// Entire string is of printable characters.
//-----------------------------------------------------------------------------------------------------------------------------------
Return True

end function

public function boolean of_ispunctuation (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsPunctuation()
//	Arguments:  as_source		The source string.
//	Returns:		Boolean
//					True If the string only contains punctuation characters.
//					If as_source is NULL, the function Returns NULL.
//	Overview:   Determines whether a string contains only punctuation	characters.
//	Created by:	Joel White
//	History: 	1/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		l_count=0, l_length
char		c_char[]
integer	i_ascii

//-----------------------------------------------------------------------------------------------------------------------------------
//Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//Get the length
//-----------------------------------------------------------------------------------------------------------------------------------
l_length = Len (as_source)

//-----------------------------------------------------------------------------------------------------------------------------------
//Check for at least one character
//-----------------------------------------------------------------------------------------------------------------------------------
If l_length=0 Then
	Return False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//Move string into array of chars
//-----------------------------------------------------------------------------------------------------------------------------------
c_char[] = as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//Perform Loop around all characters
//Quit Loop If Non Punctuation character is found
//-----------------------------------------------------------------------------------------------------------------------------------
do While l_count < l_length
	l_count ++
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//Get ASC code of character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	i_ascii = Asc (c_char[l_count])
	
	If i_ascii=33 or			/* '!' */		 & 
		i_ascii=34 or			/* '"' */		 & 
		i_ascii=39 or			/* ''' */		 & 
		i_ascii=44 or			/* ',' */		 & 
		i_ascii=46 or			/* '.' */		 & 
		i_ascii=58 or			/* ':' */		 & 
		i_ascii=59 or			/* ';' */		 & 	
		i_ascii=63 Then 		/* '?' */
		//-----------------------------------------------------------------------------------------------------------------------------------
		//Character is a punctuation.
		//Continue with the next character.
		//-----------------------------------------------------------------------------------------------------------------------------------
	Else
		Return False
	End If
Loop

//-----------------------------------------------------------------------------------------------------------------------------------
// Entire string is punctuation.
//-----------------------------------------------------------------------------------------------------------------------------------
Return True

end function

public function boolean of_isupper (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsUpper()
//	Arguments:  as_source - The source string.
//	Returns:  	Boolean
//					True If the string only contains uppercase characters. 
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Determines whether a string contains only uppercase characters.
//	Created by:	Joel White
//	History: 	1/10/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Ensure parameters have valid values.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return whether upper-case of the string equals the current string.
//-----------------------------------------------------------------------------------------------------------------------------------
Return as_source = Upper(as_source)
end function

public function boolean of_isspace (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsSpace()
//	Arguments:  as_source		The source string.
//	Returns:		Boolean
//					True If the string only contains space characters. 
//					False If the string is empty or If it contains other
//					non-space characters.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Determines whether a string contains only space characters.
//	Created by:	Joel WHite
//	History: 	1/9/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Ensure parameters have valid values.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	String has zero length.
//-----------------------------------------------------------------------------------------------------------------------------------
If len(as_source) = 0 Then
	Return False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Entire string is made of spaces.
//-----------------------------------------------------------------------------------------------------------------------------------
Return Trim(as_source) = ''


end function

public function boolean of_iswhitespace (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsWhiteSpace()
//	Arguments:  as_source		The source string.
//	Returns:		Boolean
//					True If the string only contains White Space characters. 
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Determines whether a string contains only White Space
//					characters. White Space characters include Newline, Tab,
//					Vertical tab, Carriage Return, Formfeed, and Backspace.
//	Created by:	Joel White
//	History: 	1/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long 		l_count=0, l_length
char		c_char[]
integer	i_ascii

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get the length
//-----------------------------------------------------------------------------------------------------------------------------------
l_length = Len (as_source)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for at least one character
//-----------------------------------------------------------------------------------------------------------------------------------//-----------------------------------------------------------------------------------------------------------------------------------
If l_length=0 Then
	Return False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Move string into array of chars
//-----------------------------------------------------------------------------------------------------------------------------------
c_char[] = as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//	Perform Loop around all characters
//	Quit Loop If Non WhiteSpace character is found
//-----------------------------------------------------------------------------------------------------------------------------------
do While l_count<l_length
	l_count ++
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Get ASC code of character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	i_ascii = Asc (c_char[l_count])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Character is a WhiteSpace.
	//	Continue with the next character.
	//-----------------------------------------------------------------------------------------------------------------------------------	
	If i_ascii=8	or			/* BackSpae */		 		& 
		i_ascii=9 	or			/* Tab */		 			& 
		i_ascii=10 or			/* NewLine */				& 
		i_ascii=11 or			/* Vertical Tab */		& 
		i_ascii=12 or			/* Form Feed */			& 
		i_ascii=13 or			/* Carriage Return */	&
		i_ascii=32 Then		/* Space */		
	Else
		/* Character is Not a White Space. */
		Return False
	End If
Loop

//-----------------------------------------------------------------------------------------------------------------------------------
// Entire string is White Space.
//-----------------------------------------------------------------------------------------------------------------------------------
Return True

end function

public function long of_lastpos (string as_source, string as_target);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_LastPos()
//	Arguments:  as_Source - The string being searched.
//					as_Target - The string being searched for.
//	Returns:		long	
//					The position of as_Target.
//					If as_Target is not found, function Returns a 0.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Search backwards through a string to find the last occurrence of another string
//	Created by:	Joel White
//	History: 	1/7/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Set the starting position and perform the search
//-----------------------------------------------------------------------------------------------------------------------------------
Return this.of_LastPos(as_source, as_target, Len(as_Source))

end function

public function long of_lastpos (string as_source, string as_target, long al_start);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_LastPos()
//	Arguments:  as_Source - The string being searched.
//					as_Target- The being searched for.
//					al_start - The starting position, 0 means start at the End.
//	Returns:		Long	
//					The position of as_Target.
//					If as_Target is not found, function Returns a 0.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Search backwards through a string to find the last occurrence of another string.
//	Created by:	Joel White
//	History: 	1/3/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	l_len, l_Pos

//-----------------------------------------------------------------------------------------------------------------------------------
// Reverse the string and the position so we're looking at it backward.
//-----------------------------------------------------------------------------------------------------------------------------------
as_source = Reverse(as_source)
as_target = Reverse(as_target)
l_len = Len(as_source)
al_start = (l_len - al_start) + 1


//-----------------------------------------------------------------------------------------------------------------------------------
//	Ensure parameters are valid.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or IsNull(as_target) or IsNull(al_start) Then
	SetNull(l_len)
	Return l_len
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for an empty string
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(as_Source) = 0 Then
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Check for the starting position, 0 means start at the End.
//-----------------------------------------------------------------------------------------------------------------------------------
If al_start=0 Then  
	al_start=Len(as_Source)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	If string was found, readjust the length by taking the position from the End minus the length of the string and subtracting 1.
//-----------------------------------------------------------------------------------------------------------------------------------
l_pos = Pos(as_Source,as_target,al_start)
If l_pos > 0 Then
	l_pos = l_pos + len(as_target)
	l_pos = (l_len - l_pos) + 2
	Return l_pos
Else
	Return 0
End If

end function

public function string of_padleft (string as_source, long al_length);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_PadLeft()
//	Arguments:  as_Source - The string being searched.
//					al_length - The desired length of the string.
//	Returns:		String
//					A string of length al_length wich contains as_source with
//					spaces added to its left.
//					If any argument's value is NULL, function Returns NULL.
//					If al_length is less or equal to length of as_source, the 
//					function Returns the original as_source.
//	Overview:   Pad the original string with spaces on its left to make it the desired length.
//	Created by:	Joel White
//	History: 	1/3/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		l_cnt
string	ls_Return

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for Null Parameters.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or IsNull(al_length) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for the lengths
//-----------------------------------------------------------------------------------------------------------------------------------
If al_length <= Len(as_Source) Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Return the original string
	//-----------------------------------------------------------------------------------------------------------------------------------
	Return as_source
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Create the left padded string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_Return = space(al_length - Len(as_Source)) + as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//	Return the left padded string
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_Return


end function

public function string of_padright (string as_source, long al_length);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_PadRight()
//	Arguments:  as_Source - The string being searched.
//					al_length - The desired length of the string.
//	Returns:  	String
//					A string of length al_length wich contains as_source with
//					spaces added to its right.
//					If any argument's value is NULL, function Returns NULL.
//					If al_length is less or equal to length of as_source, the 
//					function Returns the original as_source.
//	Overview:   Pad the original string with spaces on its right to make it the desired length.
//	Created by:	Joel White
//	History: 	1/4/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		l_cnt
string	ls_Return

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for Null Parameters.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or IsNull(al_length) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for the lengths
//-----------------------------------------------------------------------------------------------------------------------------------
If al_length <= Len(as_Source) Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Return the original string
	//-----------------------------------------------------------------------------------------------------------------------------------
	Return as_source
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Create the right padded string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_Return = as_source + space(al_length - Len(as_Source))

//-----------------------------------------------------------------------------------------------------------------------------------
//	Return the right padded string
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_Return
end function

public function string of_quote (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_Quote()
//	Arguments:  as_source		The source string.
//	Returns:  	String
//					The original string enclosed in quotations.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Enclose the original string in double quotes.
//	Created by:	Joel White
//	History: 	12/14/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	Return as_source
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Enclosed original string in quotations.
//-----------------------------------------------------------------------------------------------------------------------------------
Return '"' + as_source + '"'

end function

public function string of_lefttrim (string as_source, boolean ab_remove_spaces, boolean ab_remove_nonprint);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_LeftTrim()
//	Arguments:  as_source - Thee string to be trimmed.
//					ab_remove_spaces - A boolean stating If spaces should be removed.
//					ab_remove_nonprint - A boolean stating If nonprint characters should be removed.
//	Returns:  	string
//					as_source with all desired characters removed from the left End of the string.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:	Removes desired characters from the left End of a string.
//					The options depEnding on the parameters are:
//					Remove spaces from the beginning of a string.
//					Remove nonprintable characters from the beginning of a string.
//					Remove spaces and nonprintable characters from the beginning of a string.
//	Created by:	Joel White
//	History: 	12/21/2004 - 
//___________________________________________________________________________________

char		c_char
boolean	lb_char
boolean	lb_printable_char

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure parameters have valid values.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or IsNull(ab_remove_spaces) or IsNull(ab_remove_nonprint) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

If ab_remove_spaces and ab_remove_nonprint Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Remove spaces and nonprintable characters from the beginning of a string.
	//-----------------------------------------------------------------------------------------------------------------------------------
	do While Len(as_source) > 0 and not lb_char
		c_char = as_source
		If this.of_IsPrintable(c_char) and Not this.of_IsSpace(c_char) then
			lb_char = true
		else
			as_source = Mid(as_source,2)
		End If
	Loop
	Return as_source
ElseIf ab_remove_nonprint Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Remove nonprintable characters from the beginning of a string.
	//-----------------------------------------------------------------------------------------------------------------------------------
	do While Len(as_source) > 0 and not lb_printable_char
		c_char = as_source
		If this.of_IsPrintable(c_char) then
			lb_printable_char = true
		else
			as_source = Mid (as_source, 2)
		End If
	Loop
	Return as_source
ElseIf ab_remove_spaces Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	//Remove spaces from the beginning of a string.
	//-----------------------------------------------------------------------------------------------------------------------------------
	Return LeftTrim(as_source)
End If

Return as_source


end function

public function string of_removenonprint (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_RemoveNonPrint()
//	Arguments:  as_source - The string from which all nonprint characters are to be removed.
//	Returns:  	string
//					as_source with all desired characters removed.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Removes all nonprint characters.
//	Created by:	Joel White
//	History: 	1/16/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

char		c_char
boolean	lb_printable_char
long		l_pos = 1
long		l_Loop
string	ls_source
long		l_source_len

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

ls_source = as_source
l_source_len = Len(ls_source)

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove nonprintable characters 
//-----------------------------------------------------------------------------------------------------------------------------------
FOR l_Loop = 1 TO l_source_len
	c_char = Mid(ls_source, l_pos, 1)
	If this.of_IsPrintable(c_char) then
		l_pos ++	
	else
		ls_source = Replace(ls_source, l_pos, 1, "")
	End If 
NEXT

Return ls_source

end function

public function string of_removewhitespace (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_RemoveWhiteSpace()
//	Arguments:  as_source - The string from which all WhiteSpace characters are to be removed.
//	Returns:  	string
//					as_source with all desired characters removed.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Removes all WhiteSpace characters.
//	Created by:	Joel White
//	History: 	12/20/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

char		c_char
boolean	lb_printable_char
long		l_pos = 1
long		l_Loop
string	ls_source
long		l_source_len

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

ls_source = as_source
l_source_len = Len(ls_source)

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove WhiteSpace characters 
//-----------------------------------------------------------------------------------------------------------------------------------
FOR l_Loop = 1 TO l_source_len
	c_char = Mid(ls_source, l_pos, 1)
	If Not of_IsWhiteSpace(c_char) then
		l_pos ++	
	else
		ls_source = Replace(ls_source, l_pos, 1, "")
	End If 
NEXT

Return ls_source

end function

public function string of_righttrim (string as_source, boolean ab_remove_spaces, boolean ab_remove_nonprint);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_RightTrim()
//	Arguments:  as_source - The string to be trimmed.
//					ab_remove_spaces - A boolean stating If spaces should be removed.
//					ab_remove_nonprint - A boolean stating If nonprint characters should be removed.
//	Overview:   Removes desired characters from the right End of a string.
//					The options depEnding on the parameters are:
//						Remove spaces from the End of a string.
//						Remove nonprintable characters from the End of a string.
//						Remove spaces and nonprintable characters from the End 
//						of a string.
//	Returns:  	string - as_source with all desired characters removed from the right End of the string.
//					If any argument's value is NULL, function Returns NULL.
//	Created by:	Joel White
//	History: 	1/05/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

boolean	lb_char
char		c_char
boolean	lb_printable_char

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or IsNull(ab_remove_spaces) or IsNull(ab_remove_nonprint) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove spaces and nonprintable characters from the End of a string.
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_remove_spaces and ab_remove_nonprint Then
	do While Len (as_source) > 0 and not lb_char
		c_char = Right (as_source, 1)
		If of_IsPrintable(c_char) and Not of_IsSpace(c_char) then
			lb_char = true
		else
			as_source = Left (as_source, Len (as_source) - 1)
		End If
	Loop
	Return as_source
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Remove nonprintable characters from the End of a string.
//-----------------------------------------------------------------------------------------------------------------------------------	
ElseIf ab_remove_nonprint Then
	do While Len (as_source) > 0 and not lb_printable_char
		c_char = Right (as_source, 1)
		If of_IsPrintable(c_char) then
			lb_printable_char = true
		else
			as_source = Left (as_source, Len (as_source) - 1)
		End If
	Loop
	Return as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//Remove spaces from the End of a string.
//-----------------------------------------------------------------------------------------------------------------------------------
ElseIf ab_remove_spaces Then
	Return RightTrim(as_source)
End If

Return as_source
end function

public function string of_trim (string as_source, boolean ab_remove_spaces, boolean ab_remove_nonprint);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_Trim()
//	Arguments:  as_source - The string to be trimmed.
//					ab_remove_spaces - A boolean stating If spaces should be removed.
//					ab_remove_nonprint - A boolean stating If nonprint characters should be removed.
//	Returns:  	string - as_source with all desired characters removed from the left and right End of the string.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Removes desired characters from the left and right End of a string.
//					The options depEnding on the parameters are:
//						Remove spaces from the beginning and End of a string.
//						Remove nonprintable characters from the beginning and End of a string.
//						Remove spaces and nonprintable characters from the beginning and End of a string.
//	Created by:	Joel White
//	History: 	1/12/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or IsNull(ab_remove_spaces) or IsNull(ab_remove_nonprint) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove spaces and nonprintable characters from the beginning and End 
// of a string.
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_remove_spaces and ab_remove_nonprint Then
	as_source = this.of_LeftTrim (as_source, ab_remove_spaces, ab_remove_nonprint)
	as_source = this.of_RightTrim(as_source, ab_remove_spaces, ab_remove_nonprint)

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove nonprintable characters from the beginning and End
// of a string.
//-----------------------------------------------------------------------------------------------------------------------------------
ElseIf ab_remove_nonprint Then
	as_source = this.of_LeftTrim (as_source, ab_remove_spaces, ab_remove_nonprint)
	as_source = this.of_RightTrim(as_source, ab_remove_spaces, ab_remove_nonprint)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Remove spaces from the beginning and End of a string.
//-----------------------------------------------------------------------------------------------------------------------------------
ElseIf ab_remove_spaces Then
	as_source = Trim(as_source)
End If

Return as_source
end function

public function string of_wordcap (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_WordCap()
//	Arguments:  as_source - The source string.
//	Overview:   Sets the first letter of each word in a string to a capital letter and all other letters to lowercase (for example, 
//					ROBERT E. LEE would be Robert E. Lee).
//	Returns:  	String
//					Returns string with the first letter of each word set to	uppercase and the remaining letters lowercase If it succeeds
//					and NULL If an error occurs.
//					If any argument's value is NULL, function Returns NULL.
//	Created by:	Joel White
//	History: 	1/7/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

integer	i_pos
boolean	lb_capnext
string 	ls_ret
long		l_stringlength
char		c_char,	c_string[]

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get and check length
//-----------------------------------------------------------------------------------------------------------------------------------
l_stringlength = Len(as_source)
If l_stringlength = 0 Then
	Return as_source
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Convert all characters to lowercase and put it into Character Array
//-----------------------------------------------------------------------------------------------------------------------------------
c_string = Lower(as_source)

//-----------------------------------------------------------------------------------------------------------------------------------
//	The first character should be capitalized
//-----------------------------------------------------------------------------------------------------------------------------------
lb_capnext = TRUE

//-----------------------------------------------------------------------------------------------------------------------------------
//	Loop through the entire string
//-----------------------------------------------------------------------------------------------------------------------------------
For i_pos = 1 to l_stringlength
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Get one character at a time
	//-----------------------------------------------------------------------------------------------------------------------------------
	c_char = c_string[i_pos]
	
	If Not of_IsAlpha(c_char) Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		//	The next character should be capitalized
		//-----------------------------------------------------------------------------------------------------------------------------------
		lb_capnext = True
	ElseIf lb_capnext Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		//	Capitalize this Alphabetic character
		//-----------------------------------------------------------------------------------------------------------------------------------
		c_string[i_pos] = Upper(c_char)
		//-----------------------------------------------------------------------------------------------------------------------------------
		//	The next character should not be capitalized
		//-----------------------------------------------------------------------------------------------------------------------------------
		lb_capnext = False
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
//	Copy the Character array back to a string variable
//-----------------------------------------------------------------------------------------------------------------------------------
ls_ret = c_string

//-----------------------------------------------------------------------------------------------------------------------------------
//	Return the capitalized string
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_ret
end function

public function boolean of_isarithmeticoperator (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_isarithmeticoperator()
//	Arguments:  as_source - The source string.
//	Returns:  	Boolean
//					True If the string only contains Arithmetic Operator
//					characters.
//					If as_source is NULL, the function Returns NULL.
//	Overview:   Determines whether a string contains only Arithmetic
//					Operator characters.
//	Created by:	Joel White
//	History: 	1/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		l_count=0
long		l_length
char		c_char[]
integer	i_ascii

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get the length
//-----------------------------------------------------------------------------------------------------------------------------------
l_length = Len (as_source)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for at least one character
//-----------------------------------------------------------------------------------------------------------------------------------
If l_length=0 Then
	Return False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Move string into array of chars
//-----------------------------------------------------------------------------------------------------------------------------------
c_char = as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//	Perform Loop around all characters
//	Quit Loop If Non Operator character is found
//-----------------------------------------------------------------------------------------------------------------------------------
Do While l_count<l_length
	l_count ++
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Get ASC code of character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	i_ascii = Asc (c_char[l_count])

	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Character is an operator.
	//	Continue with the next character.
	//-----------------------------------------------------------------------------------------------------------------------------------		
	If i_ascii=40 or			/* ( left parenthesis */	 & 
		i_ascii=41 or			/* ) right parenthesis */	 & 
		i_ascii=43 or			/* + addition */				 & 
		i_ascii=45 or			/* - subtraction */			 & 
		i_ascii=42 or			/* * multiplication */		 & 
		i_ascii=47 or			/* / division */				 & 
		i_ascii=94 Then		/* ^ power */
	Else
		Return False
	End If
Loop
	
//-----------------------------------------------------------------------------------------------------------------------------------	
// Entire string is made of arithmetic operators.
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public function boolean of_isalpha (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsAlpha()
//	Arguments:  as_source - The source string.
//	Overview:   Determines whether a string contains only alphabetic
//					characters.
//	Returns:  	Boolean
//					True If the string only contains alphabetic characters. 
//					If any argument's value is NULL, function Returns NULL.
//	Created by:	Joel White
//	History: 	1/12/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		l_count=0, l_length
char		c_char[]
integer	i_ascii

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure parameters have valid values.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get the length
//-----------------------------------------------------------------------------------------------------------------------------------
l_length = Len (as_source)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for at least one character
//-----------------------------------------------------------------------------------------------------------------------------------
If l_length=0 Then
	Return True
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Move string into array of chars
//-----------------------------------------------------------------------------------------------------------------------------------
c_char = as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//	Perform Loop around all characters
//	Quit Loop If Non Alpha character is found
//-----------------------------------------------------------------------------------------------------------------------------------
Do While l_count<l_length
	l_count ++
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Get ASC code of character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	i_ascii = Asc (c_char[l_count])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// 'A'=65, 'Z'=90, 'a'=97, 'z'=122
	//-----------------------------------------------------------------------------------------------------------------------------------
	If i_ascii<65 or (i_ascii>90 and i_ascii<97) or i_ascii>122 then
		/* Character is Not an Alpha */
		Return False
		Exit
	End If
Loop
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Entire string is alpha.
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public function string of_find_argument (string as_argument, string as_arguments[], string as_values[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_find_argument()
//	Arguments:  as_argument 		- the argument you are looking for
//					as_arguments[] 	- an array of arguments
//					as_values[]			- an array of values
//	Overview:   Find the value that matches an argument that is passed in
//	Created by:	Joel White
//	History: 	1.13.2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long l_index, l_upperbound
String ls_null
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the safe upperbound for the arrays
//-----------------------------------------------------------------------------------------------------------------------------------
l_upperbound = Min(UpperBound(as_arguments[]), UpperBound(as_values[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// If we find the argument, Return the value
//-----------------------------------------------------------------------------------------------------------------------------------
For l_index = 1 To l_upperbound
	If Lower(Trim(as_argument)) = Lower(Trim(as_arguments[l_index])) Then Return as_values[l_index]	
Next	
	
//-----------------------------------------------------------------------------------------------------------------------------------
// If we find nothing Return Null
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_null
end function

public function string of_find_argument (string as_argumentstring, string as_delimiter, string as_argumenttofind);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_find_argument()
//	Arguments:  as_argumentstring 		- the ? delimited string of arguments in the form argument=value{delimiter}argument=value
//					as_delimiter				- the delimiter
//					as_argumenttofind			- The name of the argument to find
//	Overview:   Find the value that matches an argument that is passed in
//	Created by:	Joel White
//	History: 	1.13.2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long l_index, l_upperbound
String ls_null, ls_arguments[], ls_values[]
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the string into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_parse_arguments(as_argumentstring, as_delimiter, ls_arguments[], ls_values[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the safe upperbound for the arrays
//-----------------------------------------------------------------------------------------------------------------------------------
l_upperbound = Min(UpperBound(ls_arguments[]), UpperBound(ls_values[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// If we find the argument, Return the value
//-----------------------------------------------------------------------------------------------------------------------------------
For l_index = 1 To l_upperbound
	If Lower(Trim(as_argumenttofind)) = Lower(Trim(ls_arguments[l_index])) Then Return ls_values[l_index]	
Next	
	
//-----------------------------------------------------------------------------------------------------------------------------------
// If we find nothing Return Null
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_null
end function

public function string of_gettoken (ref string as_source, string as_separator);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_GetToken()
//	Arguments:	as_source - The source string passed by reference
//					as_separator - Separator character in the source string which will be 
//					used to determine the length of characters to strip from
//					the left End of the source string.
//	Returns:		string
//					The token stripped off of the source string.
//					If the separator character does not appear in the string, 
//					the entire source string is Returned.
//					Otherwise, it Returns the token stripped off of the left end of the source string (not including the separator character)
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   This function strips a source string (from the left) up 
//					to the occurrence of a specIfied separator character.
//	Created by:	Joel White
//	History: 	1/13/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long 		l_pos
string 	s_ret, s_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure parameters have valid values
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or IsNull(as_separator) Then

	SetNull(s_null)
	Return s_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get the position of the separator
//-----------------------------------------------------------------------------------------------------------------------------------
l_pos = Pos(as_source, as_separator)	

//-----------------------------------------------------------------------------------------------------------------------------------
// If no separator, the token to be stripped is the entire source string
//-----------------------------------------------------------------------------------------------------------------------------------
If l_pos = 0 then
	s_ret = as_source
	as_source = ""	
Else
	s_ret = Left(as_source,l_pos)
End If

Return s_ret
end function

public function string of_replace_all (string as_string, string as_replace, string as_replace_with, boolean ab_ignorecase);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_all()
//	Arguments:  as_string - The string from which all specfied characters are to be removed.
//					as_replace - The string we're looking to replace.
//					as_replace_with - The string we're going to replace with.
//					ab_ignorecase - boolean that tells us whether to ignore case.
//	Overview:   Removes all specIfied characters and replaces them with others. If it ignores case, then it does the code here.
//					Otherwise, it calls the default of_replace_all
//	Created by:	Joel White
//	History: 	1/15/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_start_pos, l_diff_len, l_num_replaces
Long l_len_replace
string s_copy, s_upper_as_replace

//-----------------------------------------------------------------------------------------------------------------------------------
//	Empty string will cause an infinite loop so just return.
//-----------------------------------------------------------------------------------------------------------------------------------
If as_replace = '' Or IsNull(as_string) Or IsNull(as_string) Then Return as_string

//-----------------------------------------------------------------------------------------------------------------------------------
// If they want the replace all to be case-sensitive, then we'll just use the default of_replace_all
//-----------------------------------------------------------------------------------------------------------------------------------
If not ab_ignorecase Then 
	this.of_replace_all(as_string,as_replace,as_replace_with)
	Return as_string
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Find out the difference in size between the replace and replace with strings.
//-----------------------------------------------------------------------------------------------------------------------------------
l_diff_len = len(as_replace_with) - len(as_replace)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Create a copy of the string that is an uppercase version of the original. Also, uppercase the original as_replace.
//-----------------------------------------------------------------------------------------------------------------------------------
s_copy = Upper(as_string)
s_upper_as_replace = Upper(as_replace)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set start position for search by finding the first substring to be replaced
//-----------------------------------------------------------------------------------------------------------------------------------
l_start_pos=pos(s_copy,s_upper_as_replace,1)

//-----------------------------------------------------------------------------------------------------------------------------------
// 8/17/2004 - Pat Newgent
// Pre-Determine the length of as_replace (Sybase Suggestion)
//-----------------------------------------------------------------------------------------------------------------------------------
l_len_replace=len(as_replace) 

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through string to find all occurrences of substring and replace them
//-----------------------------------------------------------------------------------------------------------------------------------
Do Until l_start_pos = 0
	//-----------------------------------------------------------------------------------------------------------------------------------
	// 8/17/2004 - Pat Newgent
	// Removed imbeded functions as arguments as Sybase Suggestion to prevent crashing
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	as_string = replace(as_string, l_start_pos + (l_diff_len* l_num_replaces), len(as_replace), as_replace_with)
	//	l_start_pos=pos(s_copy,s_upper_as_replace, l_start_pos + len(as_replace))
	as_string = replace(as_string, l_start_pos + (l_diff_len* l_num_replaces), l_len_replace, as_replace_with)
	l_start_pos=pos(s_copy,s_upper_as_replace, l_start_pos + l_len_replace)
	l_num_replaces++
Loop

Return as_string
end function

public subroutine of_replace_all (ref string as_string, string as_replace, string as_replace_with);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_all()
//	Arguments:  as_string - The string from which all specfied characters are to be removed.
//					as_replace - The string we're looking to replace.
//					as_replace_with - The string we're going to replace with.
//	Overview:   Removes all specIfied characters and replaces them with others.
//	Created by:	Joel White
//	History: 	1/17/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_start_pos, l_len_replace, l_len_replace_with

If as_replace = '' Or IsNull(as_replace) Or IsNull(as_string) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Set start position for search by finding the first substring to be replaced
//-----------------------------------------------------------------------------------------------------------------------------------
l_start_pos=pos(as_string,as_replace,1)

//-----------------------------------------------------------------------------------------------------------------------------------
// 8/18/2004 - Pat Newgent
// Pre-determine the length of the strings, so as not to have functions as embeded arguments.  Sybase says this causes memory leaks.
//-----------------------------------------------------------------------------------------------------------------------------------
l_len_replace=len(as_replace) 
l_len_replace_with=len(as_replace_with) 

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through string to find all occurrences of substring and replace them
//-----------------------------------------------------------------------------------------------------------------------------------
Do Until l_start_pos = 0
	as_string=replace(as_string, l_start_pos, l_len_replace, as_replace_with)
	l_start_pos=pos(as_string, as_replace, l_start_pos + l_len_replace_with)
Loop
end subroutine

public function boolean of_replace_argument (string as_argument, ref string as_argumentstring, string as_delimiter, string as_value);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_argument()
//	Arguments:  as_argument 			- the argument you are looking for
//					as_argumentstring[] 	- a string of argument=value separated by a delimiter
//					as_delimiter			- the delimiter for the string
//					as_value					- This will replace the value in a argument/value array
//	Overview:   Find the value that matches an argument that is passed in and replace it
//	Created by:	Joel White
//	History: 	1.17.2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long l_index, l_upperbound
String ls_arguments[], ls_values[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse arguments into two arrays of name and values.
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_parse_arguments(as_argumentstring, as_delimiter, ls_arguments[], ls_values[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the safe upperbound for the arrays
//-----------------------------------------------------------------------------------------------------------------------------------
l_upperbound = Min(UpperBound(ls_arguments[]), UpperBound(ls_values[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// If we find the argument, Return the value
//-----------------------------------------------------------------------------------------------------------------------------------
For l_index = 1 To l_upperbound
	If Lower(Trim(as_argument)) = Lower(Trim(ls_arguments[l_index])) Then
		ls_values[l_index] = as_value
		as_argumentstring = This.of_build_argument_string(as_delimiter, ls_arguments[], ls_values[])
		Return True
	End If
Next	
	
//-----------------------------------------------------------------------------------------------------------------------------------
// If we find nothing Return Null
//-----------------------------------------------------------------------------------------------------------------------------------
Return False
end function

public function boolean of_replace_argument (string as_argument, string as_arguments[], ref string as_values[], string as_value);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_argument()
//	Arguments:  as_argument 		- the argument you are looking for
//					as_arguments[] 	- an array of arguments
//					as_values[]			- an array of values
//					as_value				- This will replace the value in a argument/value array
//	Overview:   Find the value that matches an argument that is passed in
//	Created by:	Joel White
//	History: 	1.16.2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long l_index, l_upperbound

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the safe upperbound for the arrays
//-----------------------------------------------------------------------------------------------------------------------------------
l_upperbound = Min(UpperBound(as_arguments[]), UpperBound(as_values[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// If we find the argument, Return the value
//-----------------------------------------------------------------------------------------------------------------------------------
For l_index = 1 To l_upperbound
	If Lower(Trim(as_argument)) = Lower(Trim(as_arguments[l_index])) Then
		as_values[l_index] = as_value
		Return True
	End If
Next	
	
//-----------------------------------------------------------------------------------------------------------------------------------
// If we find nothing Return Null
//-----------------------------------------------------------------------------------------------------------------------------------
Return False
end function

public subroutine of_parse_arguments (string s_string, ref string s_name_array[], ref string s_value_array[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_parse_arguments()
// Arguments:   String to parse, delimiter, array of argument names (reference), array of values (reference).
// Overview:    Parses a string of the form: name=value,name=value,...
// Created by:  Joel White
// History:     1/10/2005
//-----------------------------------------------------------------------------------------------------------------------------------

If pos( s_string, "||") > 0 then
	this.of_parse_arguments(s_string,"||",s_name_array[],s_value_array[])
else
	this.of_parse_arguments(s_string,",",s_name_array[],s_value_array[])
End If


end subroutine

public subroutine of_parse_arguments (string as_data, string as_delimiter, ref string as_arguments[], ref string as_values[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_parse_arguments()
// Arguments:	as_data - string to parse
//					as_delimiter - delimiter separating name/value pairs
//					as_arguments[] - reference array of strings that will contain all the argument names
//					as_values[][] - reference array of strings that will contain all the values
// Overview:	Parses a string of the form: name=value[delimiter]name=value[delimiter] etc... based on the specIfied delimiter into two arrays.
//					One contains the argument names, the other contains the argument values.
// Created by:	Joel White
// History:		01/6/2005
//-----------------------------------------------------------------------------------------------------------------------------------
long l_upperbound, i
string s_namevalue[], s_namevalueinstance[], s_reset[], s_null

SetNull(s_null)

//-------------------------------------------------------------------
// Parse string into array of name/value pairs.
//-------------------------------------------------------------------
this.of_parse_string(as_data,as_delimiter,s_namevalue[])
l_upperbound = UpperBound(s_namevalue[])

//-------------------------------------------------------------------
// Parse each name/value pair into the appropriate array. The first
//	element should be the argument name. The second element should
//	be the value.
//-------------------------------------------------------------------
For i = 1 to l_upperbound

	s_namevalueinstance[] = s_reset[]
	
	//--------------------------------------------------------------------------------------------------------------------------------
	//	Check UpperBound. If it's 2 then it's a normal instance of name=value. If 1, then it's name=, so Return null.
	//--------------------------------------------------------------------------------------------------------------------------------
	this.of_parse_string(s_namevalue[i],"=",s_namevalueinstance[])
	If UpperBound(s_namevalueinstance[]) = 2 Then
		as_arguments[i] = s_namevalueinstance[1]
		as_values[i] = s_namevalueinstance[2]
	ElseIf UpperBound(s_namevalueinstance[]) = 1 Then
		as_arguments[i] = s_namevalueinstance[1]
		as_values[i] = s_null
	Else
		Return
	End If
	
Next



end subroutine

public subroutine of_parse_string (string as_source, string as_delimiter, ref string as_target[], boolean ab_wysiwyg);long l_beginpos, l_endpos, l_len, i, l_stringlength

//-----------------------------------------------------------------------------------------------------------------------------------
// Verify source string is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or Len(Trim(as_source)) = 0 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine Length of delimiter, starting positions of delimter for looping.
//-----------------------------------------------------------------------------------------------------------------------------------
i = 1
l_len = Len(as_delimiter)
l_stringlength = Len(as_source)
l_beginpos = 1

//-----------------------------------------------------------------------------------------------------------------------------------
// Find out if delimeter ends the string. If so, chop it off.
//-----------------------------------------------------------------------------------------------------------------------------------
If Right(as_source,l_len) = as_delimiter Then
	as_source = Left(as_source,l_stringlength - l_len)
End If

l_endpos = Pos(as_source,as_delimiter,1)

//-----------------------------------------------------------------------------------------------------------------------------------
// If no instance of delimiter is found, then parsed string is same as source string.
//-----------------------------------------------------------------------------------------------------------------------------------
If l_endpos = 0 Then 
	as_target[1] = as_source
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through taking each chunk and adding it to the array.
//-----------------------------------------------------------------------------------------------------------------------------------
Do While l_endpos > 0 And l_endpos <> l_stringlength
	as_target[i] = Mid(as_source,l_beginpos,l_endpos - l_beginpos)
	l_beginpos = l_endpos + l_len
	l_endpos = Pos(as_source,as_delimiter,l_beginpos)
	i++
Loop

//Get the last piece into the array
as_target[i] = Mid(as_source,l_beginpos,l_stringlength)

	


end subroutine

public subroutine of_parse_arguments (string as_data, string as_delimiter, ref string as_arguments[], ref string as_values[], boolean ab_wysiwyg);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_parse_arguments()
// Arguments:	as_data - string to parse
//					as_delimiter - delimiter separating name/value pairs
//					as_arguments[] - reference array of strings that will contain all the argument names
//					as_values[][] - reference array of strings that will contain all the values
// Overview:	Parses a string of the form: name=value[delimiter]name=value[delimiter] etc... based on the specIfied delimiter into two arrays.
//					One contains the argument names, the other contains the argument values.
// Created by:	Joel White
// History:		01/5/2005
//-----------------------------------------------------------------------------------------------------------------------------------
long l_upperbound, i, l_posequal
string s_namevalue[], s_namevalueinstance[], s_reset[], s_null

SetNull(s_null)

//-------------------------------------------------------------------
// Parse string into array of name/value pairs.
//-------------------------------------------------------------------
If ab_wysiwyg Then
	this.of_parse_string(as_data,as_delimiter,s_namevalue[],True)
Else
	this.of_parse_string(as_data,as_delimiter,s_namevalue[])
End If
l_upperbound = UpperBound(s_namevalue[])

//-------------------------------------------------------------------
// Parse each name/value pair into the appropriate array. The first
//	element should be the argument name. The second element should
//	be the value.
//-------------------------------------------------------------------
For i = 1 to l_upperbound

	s_namevalueinstance[] = s_reset[]
	
	//--------------------------------------------------------------------------------------------------------------------------------
	//	Check UpperBound. If it's 2 then it's a normal instance of name=value. If 1, then it's name=, so Return null.
	//--------------------------------------------------------------------------------------------------------------------------------
	If ab_wysiwyg Then
		l_posequal = Pos(s_namevalue[i],"=")
		If l_posequal > 0 Then
			as_arguments[i] = Trim(Left(s_namevalue[i],l_posequal - 1))
			as_values[i] = Mid(s_namevalue[i],(l_posequal + 1),(len(s_namevalue[i]) - l_posequal))
		End If
	ElseIf UpperBound(s_namevalueinstance[]) = 1 Then
		as_arguments[i] = s_namevalueinstance[1]
		as_values[i] = s_null
	Else
		Return
	End If
	
Next



end subroutine

public function string of_arraytostring (string as_source[], string as_delimiter, boolean ab_include_empty_strings);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_arraytostring()
//	Arguments:  as_source[] - Source array of strings to be parsed together
//					as_delimiter - Delimiter character to separate each element in the array of strings
//					ab_include_empty_strings - boolean to specIfy whether empty strings should be parsed into the final string.
//	Return:		long  1 for a successful transfer.
//							-1 If a problem was found.
//	Overview:   Create a single string from an array of strings separated by the specIfied delimeter.
//	Created by:	Joel White
//	History: 	1/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long i, l_upperbound
string s_Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the array size
//-----------------------------------------------------------------------------------------------------------------------------------
l_upperbound = UpperBound(as_source[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure delimiter was passed in and that the array has something in it.
//-----------------------------------------------------------------------------------------------------------------------------------
as_delimiter = Trim(as_delimiter)
If IsNull(as_delimiter) Or as_delimiter = '' Or l_upperbound <= 0 Then
	Return	''
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Loop through the array and concatenate the string together. If the ab_include_empty_strings is TRUE, then we'll concatenate empty
//	strings into the overall array. Otherwise, we will not include them.
//-----------------------------------------------------------------------------------------------------------------------------------
For i = 1 to l_upperbound
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Do not include any entries that are null because they will reset the string.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsNull(as_source[i]) Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Don't include an empty string unless they've specIfied to do so.
	//-----------------------------------------------------------------------------------------------------------------------------------	
	If ab_include_empty_strings Then
		s_Return = s_Return + as_delimiter + as_source[i]
	Else
		If as_source[i] <> '' Then
			s_Return = s_Return + as_delimiter + as_source[i]
		End If
	End If
Next

Return s_Return

end function

public function long of_convert_string_to_character_array (string as_string, ref string as_array[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_convert_string_to_character_array()
//	Arguments:  as_string - A string to convert to an array
//					as_array[] - An array by reference to Return the Value
//	Overview:   Convert a string to an array of characters
//	Created by:	Joel White
//	History: 	1.13.21005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String ls_array[]
Long l_length, l_index


as_array[] = ls_array[]

l_length = Len(as_string)

If IsNull(as_string) Or l_length = 0 Then Return 0

For l_index = 1 To l_length
	as_array[l_index] = Mid(as_string, l_index, 1)
Next

Return UpperBound(as_array[])
end function

public function string of_convert_datetime_to_string (datetime adt_convert);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_convert_datetime_to_string
//	Arguments:  adt_convert - datetime variable you want converted to a string
//	Overview:   Convert a datetime variable to a standard format for use in RAMQ
//	Created by:	Joel White
//	History: 	1/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Return String(adt_convert,'mm-dd-yyyy hh:mm:ss')
Return String(adt_convert,'yyyy-mm-dd hh:mm:ss')
end function

public function string of_convert_date_to_string (date adt_date);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_convert_date_to_string
//	Arguments:  adt_date - date variable that you want converted to a string.
//	Overview:   Convert a date to the RightAngle default date string format.
//	Created by:	Joel White
//	History: 	1/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Return String(adt_date,'mm-dd-yyyy')
Return String(adt_date,'yyyy-mm-dd')


end function

public function date of_convert_string_to_date (string as_date, string as_format);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_convert_string_to_date
//	Arguments:  as_date - string that should contain a date
//					as_format - format string specIfying month, day, and year setup.
//	Overview:   This function allows us to convert a variety of string formats to a date datatype based on a specIfied format string.
//					If a format string is not passed in, then we will assume the default Right-Angle date format of mm-dd-yyyy.
//	Created by:	Joel White
//	History: 	1/13/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_posm,l_posd,l_posy
datetime dt_datetime
date dt_date
string s_date

//----------------------------------------------------------------------------------
//	Determine If format arg was passed in.
//----------------------------------------------------------------------------------
If IsNull(as_format) Then
	If Not IsDate(as_date) Then
		as_format = 'mdy'
	Else
		Return Date(as_format)
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// First give PB's native Date conversion a go to see If it can translate the string into a date. If it can translate the string into
//	a valid date, then we're almost done. We just need to confirm that the input = output by converting the date variable back to the
//	same string format. If the results are equal, then we have succeeded without using the Date SP. Otherwise, we have to get (even more)
//	kludgy...
//-----------------------------------------------------------------------------------------------------------------------------------
If IsDate(as_date) Then
	dt_date = Date(as_date)
	s_date = trim(String(dt_date,lower(as_format)))
	If s_date = as_date Then
		Return dt_date
	End If
End If

l_posm = Pos(lower(as_format),"m")
l_posd = Pos(lower(as_format),"d")
l_posy = Pos(lower(as_format),"y")

//-----------------------------------------------------------------------------------------------------------------------------------
// If "m" is the last part of the format, then determine what comes first, the 'd' or the 'y'
//-----------------------------------------------------------------------------------------------------------------------------------
If l_posm > Max(l_posd,l_posy) Then
	If Max(l_posd,l_posy) = l_posy Then
		as_format = "dym"
	Else
		as_format = "ydm"
	End If
//-----------------------------------------------------------------------------------------------------------------------------------
// If "d" is the last part of the format, then determine what comes first, the 'm' or the 'y'
//-----------------------------------------------------------------------------------------------------------------------------------
ElseIf l_posd > Max(l_posm,l_posy) Then
	If Max(l_posm,l_posy) = l_posy Then
		as_format = "myd"
	Else
		as_format = "ymd"
	End If
//-----------------------------------------------------------------------------------------------------------------------------------
// If "y" is the last part of the format, then determine what comes first, the 'd' or the 'm'
//-----------------------------------------------------------------------------------------------------------------------------------
ElseIf l_posy > Max(l_posd,l_posm) Then
	If Max(l_posd,l_posm) = l_posm Then
		as_format = "dmy"
	Else
		as_format = "mdy"
	End If
End If

//-------------------------------------------------------------------
// Execute a procedure which will convert a string to a datetime
//	We'll only take the date portion and Return that value.
//-------------------------------------------------------------------
DECLARE lSP_ConvertStringToDatetime Procedure for SP_ConvertStringToDatetime
@c3_dateformat = :as_format,
@vc50_datetime = :as_date;
Execute lSP_ConvertStringToDatetime;
FETCH lSP_ConvertStringToDatetime INTO :dt_datetime ;
CLOSE lSP_ConvertStringToDatetime;

Return Date(dt_datetime)

/////////////// BEGIN OLD CODE ////////////////
//If Not IsValid(ids_order) Then
//	ids_order = CREATE Datastore
//	ids_order.DataObject = "d_extrnl_datepart_order"	
//Else
//	ids_order.Reset()
//End If
////----------------------------------------------------------------------------------		
////	Find "m" for month
////----------------------------------------------------------------------------------				
//l_pos_datepart = Pos(as_format,"m")
//If l_pos_datepart = 0 Then
//	Destroy ids_order
//	Return Date(dt_date)
//End If
//ids_order.InsertRow(0)
//ids_order.SetItem(1,"date_part","m")
//ids_order.SetItem(1,"position",l_pos_datepart)
////----------------------------------------------------------------------------------		
////	Find "d" for day
////----------------------------------------------------------------------------------				
//l_pos_datepart = Pos(as_format,"d")
//If l_pos_datepart = 0 Then
//	Destroy ids_order
//	Return Date(dt_date)
//End If
//ids_order.InsertRow(0)
//ids_order.SetItem(2,"date_part","d")
//ids_order.SetItem(2,"position",l_pos_datepart)
////----------------------------------------------------------------------------------		
////	Find "y" for year
////----------------------------------------------------------------------------------				
//l_pos_datepart = Pos(as_format,"y")
//If l_pos_datepart = 0 Then
//	Destroy ids_order
//	Return Date(dt_date)
//End If
//ids_order.InsertRow(0)
//ids_order.SetItem(3,"date_part","y")
//ids_order.SetItem(3,"position",l_pos_datepart)
////----------------------------------------------------------------------------------		
////	Sort by position and then Loop through the rows to create the SQL-Server
////	dateformat string
////----------------------------------------------------------------------------------		
//ids_order.SetSort("position A")
//ids_order.Sort()
//
//as_format = ''
//For i = 1 to 3
//	as_format = as_format + ids_order.GetItemString(i,"date_part")
//Next
//End If
//
/////////////// End OLD CODE ////////////////
end function

public function string of_replace_all (string as_string, string as_replace, string as_replace_with, boolean ab_ignorecase, boolean ab_checkforalphanumerics);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_all()
//	Arguments:  as_string - The string from which all specfied characters are to be removed.
//					as_replace - The string we're looking to replace.
//					as_replace_with - The string we're going to replace with.
//					ab_ignorecase - boolean that tells us whether to ignore case.
//					ab_checkforalphanumerics - boolean that tells us whether to check for alpha-numerics.
//	Overview:   Removes all specIfied characters and replaces them with others. If it ignores case, then it does the code here.
//					Otherwise, it calls the default of_replace_all
//	Created by:	Joel White
//	History: 	1/18/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_start_pos, l_diff_len, l_num_replaces
integer l_left_character, l_right_character
string s_copy, s_upper_as_replace
boolean lb_skip_instance = False

//-----------------------------------------------------------------------------------------------------------------------------------
//	Empty string will cause an infinite loop so just return.
//-----------------------------------------------------------------------------------------------------------------------------------
If as_replace = '' Or IsNull(as_replace) Or IsNull(as_string) Then Return as_string

//-----------------------------------------------------------------------------------------------------------------------------------
// If they want the replace all to not check for alpha-numerices, then we'll just use the default of_replace_all
//-----------------------------------------------------------------------------------------------------------------------------------
If not ab_checkforalphanumerics Then 
	Return this.of_replace_all(as_string,as_replace,as_replace_with, ab_ignorecase)
End If

If ab_ignorecase Then
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find out the difference in size between the replace and replace with strings.
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_diff_len = len(as_replace_with) - len(as_replace)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Create a copy of the string that is an uppercase version of the original. Also, uppercase the original as_replace.
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_copy = Upper(as_string)
	s_upper_as_replace = Upper(as_replace)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set start position for search by finding the first substring to be replaced
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_start_pos=pos(s_copy,s_upper_as_replace,1)

Else
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set start position for search by finding the first substring to be replaced
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_start_pos=pos(as_string,as_replace,1)

End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through string to find all occurrences of substring and replace them
//-----------------------------------------------------------------------------------------------------------------------------------
Do Until l_start_pos = 0
	
	lb_skip_instance = False

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the left character's ascii value.
	//-----------------------------------------------------------------------------------------------------------------------------------	
	If l_start_pos <> 1 Then
		If ab_ignorecase Then
			l_left_character = Asc(Mid(s_copy, l_start_pos - 1, 1))
		Else
			l_left_character = Asc(Mid(as_string, l_start_pos - 1, 1))
		End If
	Else
		l_left_character = 0
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine if the character is AlphaNumeric: '0'= 48, '9'=57, 'A'=65, 'Z'=90, 'a'=97, 'z'=122,  " = 34, ' = 39
	//-----------------------------------------------------------------------------------------------------------------------------------
	If (l_left_character >= 48  And l_left_character <= 57) Or (l_left_character >= 65 and l_left_character <= 90) Or &
		(l_left_character  = 34) Or (l_left_character  = 39) Or (l_left_character >= 97 And l_left_character <= 122) Then
		lb_skip_instance = True		
	End If	
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the right character's ascii value.
	//-----------------------------------------------------------------------------------------------------------------------------------	
	If ab_ignorecase Then
		l_right_character = Asc(Mid(s_copy, l_start_pos + len(as_replace), 1))
	Else
		l_right_character = Asc(Mid(as_string, l_start_pos + len(as_replace), 1))
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine if the character is AlphaNumeric: '0'= 48, '9'=57, 'A'=65, 'Z'=90, 'a'=97, 'z'=122
	//-----------------------------------------------------------------------------------------------------------------------------------
	If (l_right_character >= 48  And l_right_character <= 57) Or (l_right_character >= 65 and l_right_character <= 90) Or &
		(l_right_character >= 97 And l_right_character <= 122) And Not lb_skip_instance Then
		lb_skip_instance = True	
	End If	
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Replace the instance in the string if necessary.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not lb_skip_instance Then
		If ab_ignorecase Then
			as_string = replace(as_string, l_start_pos + (l_diff_len* l_num_replaces), len(as_replace), as_replace_with)
			l_num_replaces++ 
		Else
			as_string=replace(as_string, l_start_pos, len(as_replace), as_replace_with)
		End If
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the next possible instance.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ab_ignorecase Then
		l_start_pos=pos(s_copy,s_upper_as_replace, l_start_pos + len(as_replace))		
	Else
		l_start_pos=pos(as_string, as_replace, l_start_pos + len(as_replace_with))
	End If
			
Loop

Return as_string
end function

public function string of_convert_multidates_to_string (string as_datestring);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_multidates_to_string()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   This function takes a CHRONOLOGICALLY ORDERED, UNIQUE comma delimited string of dates in the format
//					2002-01-01, 2002-01-02, 2002-01-03, 2002-01-06 and converts it to
//					a string that look like the following:
//					2002-01-01...2002-01-03, 2002-01-06
//	Created by:	Joel White
//	History: 	1/12/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
date 		ld_datearray[]
string	ls_datestring, ls_datearray[], ls_errormessage
long		i

ls_datestring = as_datestring
ls_errormessage = 'Error: Invalid date string passed'

If IsNull(ls_datestring) or Trim(ls_datestring) = '' then return ls_errormessage

//------------------------------------------------------------------
// Split the text string into substrings based on ,'s 
//-------------------------------------------------------------------
this.of_parse_string(ls_datestring,',',ls_datearray)

//-------------------------------------------------------------------
// Make sure the array got values
//--------------------------------------------------------------------
if upperbound(ls_datearray) <= 0 or IsNull(ls_datearray) then return ls_errormessage


for i = 1 to upperbound(ls_datearray)
	
	//--------------------------------------------------------------------
	// Make sure the strings are the correct length.... this stops
	// 2002 as being read as Jan 1, 2002, etc....
	//---------------------------------------------------------------------
	if len(trim(ls_datearray[i])) <> 10 then  return ls_errormessage
	
	//--------------------------------------------------------------------
	// Make sure there are no spaces within the string
	// For example: 12/ 6/02 is read as 2002-12-06 by n_string_functions
	//---------------------------------------------------------------------
	if pos(trim(ls_datearray[i]),' ') <> 0 then return ls_errormessage
	
next	

//---------------------------------------------------------------------
// Begin checking the validity of each range 
//---------------------------------------------------------------------
for i = 1 to upperbound(ls_datearray)

		ld_datearray[i] = this.of_convert_string_to_date(trim(ls_datearray[i]),'ymd')
		if ld_datearray[i] = 1900-01-01  then return ls_errormessage
next	
	
//------------------------------------------------------------------------
// If there are no values in the array then exit
//-------------------------------------------------------------------------
if upperbound(ld_datearray) = 0 then return ls_errormessage

//-------------------------------------------------------------------------
// Return the value from the function that converts an array of dates
// to a string
//-------------------------------------------------------------------------
return this.of_convert_multidates_to_string(ld_datearray)
end function

public function long of_countoccurrences (string as_source, string as_target);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_countoccurrences()
//	Arguments:  as_source - The string in which to search
//					as_target - The string to search for
//	Overview:   Count the number of occurrences of a specIfied string within another. This function actually calls another 
//					of_countoccurrences which actually does the work.
//	Created by:	Joel White - via PFC conversion of n_cst_string
//	History: 	1/10/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	l_Count

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure arguments are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) or IsNull(as_target) Then
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Default is to ignore case.
//-----------------------------------------------------------------------------------------------------------------------------------
l_Count = of_CountOccurrences (as_source, as_target, True)

Return l_Count

end function

public function boolean of_iswellformedemailaddress (string as_emailaddress);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_iswellformedemailaddress()
//	Arguments:  as_emailaddress: The string to test
//	Overview:   Tests a string to determine if it is a well formed e-mail address.  Note that this doesn't have
//             have anything to do with an e-mail address being valid.  If the string is well formed and therefore
//             *could* represent a vaild e-mail address, return true.  Otherwise, return false.
//	Created by:	Joel White
//	History: 	12/07/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string ls_temp
long x, y, i

ls_temp = Trim(as_emailaddress)

// A well formed e-mail address is at least 6 characters. i.e. x@x.xx
If Len(ls_temp) < 6 Then
	Return False
End If

// A well formed e-mail address includes one and only one '@'.
x = this.of_countoccurrences(ls_temp, '@', True)
If Not x = 1 Then
	Return False
End If

// A well formed e-mail address has a "." after the "@"
x = Pos(ls_temp, '@')
y = Pos(ls_temp, '.', x)
If y = 0 Then
	Return False
Else
	// A well formed e-mail address must have at least one character between "@" and "."
	If Not y - x > 1 Then
		Return False
	End If
End If

// A well formed e-mail address never containes two "." characters in a row after the "@"
Do While y > 0
	x = Pos(ls_temp, '.', y + 1)
	If x - y = 1 Then
		Return False
	End If
	y = x
Loop

// A well formed e-mail address has a least a two character domain name
If Pos(Reverse(ls_temp), '.') < 3 Then
	Return False
End If

// With the exception of the "@," a well formed e-mail address only includes characters and numbers
For i = 1 To Len(ls_temp)
	Choose Case Mid(ls_temp, i, 1)
		Case '(', ')', ':', ',', '/', '~'', '~~', '`', '!', '#', '$', '%', '^', &
			  '&', '*', '+', '=', '[', ']', '{', '}', '|', '\', '?', ' ', '<', '>', Char(34) 
			Return False
	End Choose
Next

Return True



end function

public function string of_convert_multidates_to_string (ref date ad_dates[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_multidates_to_string()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   This function takes a CHRONOLOGICALLY ORDERED, UNIQUE array of dates in the format
//					and converts it to a string that look like the following:
//					2002-01-01...2002-01-03, 2002-01-06
//	Created by:	Joel White
//	History: 	1/15/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

date 		ld_datearray[], ld_prevdate, ld_newdate
string 	ls_errormessage, ls_convertedstring
long		ll_prevrow, i

//-------------------------------------------------------
// Initalize some variables
//--------------------------------------------------------
ld_datearray = ad_dates
ls_errormessage = 'Error: Invalid date array passed'

//------------------------------------------------------------------------
// If there are no values in the array then exit
//-------------------------------------------------------------------------
if IsNull(ld_datearray) or upperbound(ld_datearray) <= 0 then return ls_errormessage

//------------------------------------------------------------------------
// Make sure there are no nulls within the array
//------------------------------------------------------------------------
for i = 1 to upperbound(ld_datearray)
	if IsNull(ld_datearray[i]) then return ls_errormessage
next	
	
//--------------------------------------------------------------------------
// Initialize some variables
//--------------------------------------------------------------------------
ll_prevrow = 1
ld_prevdate	=	ld_datearray[1]
ls_convertedstring = String(ld_prevdate,'yyyy-mm-dd')

//-------------------------------------------------------------------------
// If the rowcount is only 1, do not go into the For loop
//-------------------------------------------------------------------------
if upperbound(ld_datearray) = 1 then 
	return ls_convertedstring
end if	

//---------------------------------------------------------------------------
// Create the rest of the text field through a for loop. 
//	-- Three variables are necessary for this loop
//		1) A variable that has the new row's date
//		2) A variable that has the previous row's date
//    3) A variable that has the last time the text changed
//
// 	New text is added in two cases. 
// 	1) We are on the last date in the datastore
// 	2) The new date and the previous date are more than one day apart
//------------------------------------------------------------------------------

for i = 2 to upperbound(ld_datearray) 
	
	ld_newdate = ld_datearray[i]
	
	//------------------------------------------------------------------------
	// One requirement is that the array must be sorted first for this to work
	//-------------------------------------------------------------------------
	if ld_newdate <= ld_prevdate then return ls_errormessage
	
	if daysafter(ld_prevdate,ld_newdate) <> 1 or i = upperbound(ld_datearray)  then
		
		//--------------------------------------------------------------------
		// Anytime that the new row and previous row are only one row apart
		// and the days are more than 1 apart, just use a comma to separate
		// the dates
		//----------------------------------------------------------------------
		if i - ll_prevrow = 1 and daysafter(ld_prevdate,ld_newdate) <> 1 then
			ls_convertedstring = 	ls_convertedstring + ',' + String(ld_newdate,'yyyy-mm-dd')
		
		//--------------------------------------------------------------------
		// Anytime that the new and previous row are more than one row apart
		// and we are on the last row, then we just need a ... separating them
		//--------------------------------------------------------------------
		elseif i = upperbound(ld_datearray)  and daysafter(ld_prevdate,ld_newdate) = 1 then
			ls_convertedstring= ls_convertedstring + ' to ' + String(ld_newdate,'yyyy-mm-dd')
		
		//---------------------------------------------------------------------
		// Otherwise, we must be more than one row apart and not on the last row.
		// In that case we have a ... separating the prior dates 
		// and a , separing the new date
		//----------------------------------------------------------------------
		else
			ls_convertedstring = ls_convertedstring + ' to ' + String(ld_prevdate,'yyyy-mm-dd') + &
										',' + String(ld_newdate,'yyyy-mm-dd')						
		end if
		
		//-------------------------------------------------------------
		// If new text was added, the previous row become the current row
		//--------------------------------------------------------------
		ll_prevrow = i
	end if

	//------------------------------------------------------------------------
	// Through each iteration of the loop, the previous date will be the prior
	// row's date
	//------------------------------------------------------------------------
	ld_prevdate = ld_newdate
next

return ls_convertedstring
end function

public function boolean of_isalphanum (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_isalphanum()
//	Arguments:  as_source - The source string.
//	Overview:   Determines whether a string contains only alphabetic and
//					numeric characters. This means no punctuation characters.
//	Returns:  	Boolean
//					True If the string only contains alphabetic and Numeric
//					characters. 
//					If any argument's value is NULL, function Returns NULL.
//	Created by:	Joel White
//	History: 	1/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_count=0, l_length
char c_char[]
integer	i_ascii

//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure parameters have valid values
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	boolean lb_null
	SetNull(lb_null)
	Return lb_null
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Get the length
//-----------------------------------------------------------------------------------------------------------------------------------
l_length = Len (as_source)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check for at least one character
//-----------------------------------------------------------------------------------------------------------------------------------
If l_length = 0 Then
	Return True
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Move string into array of chars
//-----------------------------------------------------------------------------------------------------------------------------------
c_char[] = as_source

//-----------------------------------------------------------------------------------------------------------------------------------
//	Perform Loop around all characters.
//	Quit Loop If Non Alphanemeric character is found.
//-----------------------------------------------------------------------------------------------------------------------------------
Do While l_count < l_length
	l_count ++
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Get ASC code of character.
	//-----------------------------------------------------------------------------------------------------------------------------------
	i_ascii = Asc (c_char[l_count])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// '0'= 48, '9'=57, 'A'=65, 'Z'=90, 'a'=97, 'z'=122
	//-----------------------------------------------------------------------------------------------------------------------------------
	If i_ascii < 48 or (i_ascii > 57 and i_ascii < 65) or &
		(i_ascii > 90 and i_ascii < 97) or i_ascii > 122 then
		/* Character is Not an AlphaNumeric */
		Return False
	End If
Loop
	
//-----------------------------------------------------------------------------------------------------------------------------------	
// Entire string is AlphaNumeric.
//-----------------------------------------------------------------------------------------------------------------------------------
Return True

end function

public function string of_removenonalphanumeric (string as_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_RemoveNonAlphaNumberic()
//	Arguments:  as_source - The string from which all nonprint characters are to be removed.
//	Returns:  	string
//					as_source with all desired characters removed.
//					If any argument's value is NULL, function Returns NULL.
//	Overview:   Removes all nonprint characters.
//	Created by:	Joel White
//	History: 	1/14/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

char		c_char
boolean	lb_printable_char
long		l_pos = 1
long		l_Loop
string	ls_source
long		l_source_len

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check parameters
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_source) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

ls_source = as_source
l_source_len = Len(ls_source)

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove nonprintable characters 
//-----------------------------------------------------------------------------------------------------------------------------------
FOR l_Loop = 1 TO l_source_len
	c_char = Mid(ls_source, l_pos, 1)
	If this.of_IsAlphaNum(c_char) then
		l_pos ++	
	else
		ls_source = Replace(ls_source, l_pos, 1, "")
	End If 
NEXT

Return ls_source
end function

public function string of_arraytogrammarstring (string as_source[], string as_delimiter, string as_conjunction);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_arraytogrammarstring()
//	Arguments:  as_source[] - Source array of strings to be parsed together. 
//					as_delimiter - Delimiter character to separate each element in the array of strings.
//										A space is added after each delimiter for grammatical purposes.
//										Spaces included in the delimiter argument itself are trimmed.
//					as_conjunction - Conjunction to use when array contains two or more elements.
//										  Spaces included in the conjunction argument itself are trimmed.
//	Overview:   Create a single string containing a gramatically correct list of the elements
//					in the array.
//					Results (using "," and "and"): 
//								Array with 1 element returns "Element1"
//								Array with 2 elements returns "Element1 and Element2"
//								Array with 3 to n elements returns "Element1, Element2, ..., and ElementN"
//	Created by:	Joel White
//	History: 	01/10/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_list
long ll_j, ll_i

SetNull(ls_list)

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure have delimiter and that array has something in it
//-----------------------------------------------------------------------------------------------------------------------------------

as_delimiter = Trim(as_delimiter)
If IsNull(as_delimiter) or as_delimiter = '' Or UpperBound(as_source) <= 0 Then
	Return ls_list
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set null conjunction or any null array arguments to ''
//-----------------------------------------------------------------------------------------------------------------------------------
as_conjunction = Trim(as_conjunction)
if isnull(as_conjunction) then as_conjunction = ''
For ll_i = 1 to upperbound(as_source)
	If isnull(as_source[ll_i]) then as_source[ll_i] = ''
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return grammar string
//-----------------------------------------------------------------------------------------------------------------------------------

If UpperBound(as_source) = 1 Then Return as_source[1]

choose case upperbound(as_source)
	case 2
		ls_list = as_source[1] + " " + as_conjunction + " " + as_source[2]
	case is > 2 
		ls_list = as_source[1]
		for ll_j = 2 to (upperbound(as_source) - 1)
			ls_list = ls_list + as_delimiter + " " + as_source[ll_j]
		next
		ls_list = ls_list + as_delimiter + " " + as_conjunction + " " + as_source[ll_j]
end choose

return ls_list

end function

public function datetime of_convert_string_to_datetime (string as_string);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	FunctionName()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   Convert string to a basic datetime
//	Created by:	Joel White
//	History: 	01/13/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
date	d_date
time	t_time
datetime	dt_Return
long	l_space_pos

//-----------------------------------------------------------------------------------------------------------------------------------
// 9/10/2003 - ERW - xsd:datetime has format CCYY-MM-DDThh:mm:ss.  Replace T with space
//-----------------------------------------------------------------------------------------------------------------------------------
of_replace_all(as_string, "T", " ")

l_space_pos = pos(as_string, " ")

If l_space_pos = 0 then
	dt_Return = datetime( date( as_string), 00:00:00)
	Return dt_Return
End If

d_date = date( left( as_string, l_space_pos - 1))
t_time = time( mid( as_string, l_space_pos + 1, 99999))

dt_Return = datetime( d_date, t_time)

Return dt_Return
end function

public function datetime of_convert_string_to_datetime (string as_datetime, string as_format);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_convert_string_to_datetime
//	Arguments:  as_datetime - string to convert to datetime
//	Overview:   as_format - format that string was saved in.
//	Overview:	Reporting/Document Generation need to have datetime variables passed around as strings in a known format.
//					This function will put the dateteime variable into a string with the known format.
//	Created by:	Joel White
//	History: 	1/12/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long l_len,l_pos_colon, l_start
string s_time
datetime dt_date
date dt_test
time t_time

//-----------------------------------------------------------------------------------------------------------------------------------
// Try to establish a default format If none was provided.
//-----------------------------------------------------------------------------------------------------------------------------------
If as_format = '' or IsNull(as_format) Then
	If Pos(as_datetime,":") > 0 Then
//		as_format = 'mm-dd-yyyy hh:mm:ss'
		as_format = 'yyyy-mm-dd hh:mm:ss'
	Else
//		as_format = 'mm-dd-yyyy'
		as_format = 'yyyy-mm-dd'
	End If
End If

//-------------------------------------------------------------------
// Determine length of string for later reference
//-------------------------------------------------------------------
l_len = Len(as_datetime)

//-------------------------------------------------------------------
//	Determine If there is a time component in the format string.
//-------------------------------------------------------------------
If Pos(as_format,":") > 0 or Pos(as_datetime,":") > 0 Then

	//-------------------------------------------------------------------
	// Find the first colon in the string that should indicate the 
	//	beginning of the minute component of the datetime.
	//-------------------------------------------------------------------
	l_pos_colon = Pos(as_datetime,":")
	
	If l_pos_colon > 0 Then
		l_start = l_pos_colon - 1
	
		//----------------------------------------------------------------------------------
		// Find first space before the colon. This should indicate the beginning of the 
		//	time component of the datetime.
		//----------------------------------------------------------------------------------
		Do While Mid(as_datetime,l_start,1) <> ' ' and l_start >= 0
			l_start = l_start - 1
		Loop
		
		//----------------------------------------------------------------------------------
		//	Check If the string contains a valid time variable
		//----------------------------------------------------------------------------------
		s_time = Right(as_datetime,(l_len - l_start))
		If IsTime(s_time) Then
			t_time = Time(s_time)
		Else
			Return dt_date
		End If
		
		//----------------------------------------------------------------------------------
		//	Chop off time piece, leaving only the date.
		//----------------------------------------------------------------------------------
		as_datetime = Mid(as_datetime,1,(l_start - 1))
		dt_date = DateTime(this.of_convert_string_to_date(as_datetime,left(as_format,l_start)),t_time)
			
	End If	
Else
	t_time = Time("00:00:00")
	dt_date = DateTime(this.of_convert_string_to_date(as_datetime,as_format),t_time)
End If

Return dt_date
end function

public function string of_convert_datetime_to_xsdstring (datetime adt_convert);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_convert_datetime_to_xsdstring
//	Arguments:  adt_convert - datetime variable you want converted to a string
//	Overview:   Convert a datetime variable to a schema xsd:datetime format
//	Created by:	JOel White
//	History: 	1-10-2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return String(adt_convert,'yyyy-mm-ddThh:mm:ss')
end function

public function string of_replace_all (string as_string, string as_replace, string as_replace_with, boolean ab_ignorecase, boolean ab_checkforalphanumerics, boolean ab_checkforspecialcharacters);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_all()
//	Arguments:  as_string - The string from which all specfied characters are to be removed.
//					as_replace - The string we're looking to replace.
//					as_replace_with - The string we're going to replace with.
//					ab_ignorecase - boolean that tells us whether to ignore case.
//					ab_checkforalphanumerics - boolean that tells us whether to check for alpha-numerics.
//	Overview:   Removes all specIfied characters and replaces them with others. If it ignores case, then it does the code here.
//					Otherwise, it calls the default of_replace_all
//	Created by:	Joel White
//	History: 	12/18/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_start_pos, l_diff_len, l_num_replaces
integer l_left_character, l_right_character
string s_copy, s_upper_as_replace
boolean lb_skip_instance = False

//-----------------------------------------------------------------------------------------------------------------------------------
//	Empty string will cause an infinite loop so just return.
//-----------------------------------------------------------------------------------------------------------------------------------
If as_replace = '' Or IsNull(as_replace) Or IsNull(as_string) Then Return as_string

//-----------------------------------------------------------------------------------------------------------------------------------
// If they want the replace all to not check for alpha-numerices, then we'll just use the default of_replace_all
//-----------------------------------------------------------------------------------------------------------------------------------
If not ab_checkforspecialcharacters Then 
	Return this.of_replace_all(as_string,as_replace,as_replace_with, ab_ignorecase, ab_checkforalphanumerics)
End If

If ab_ignorecase Then
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find out the difference in size between the replace and replace with strings.
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_diff_len = len(as_replace_with) - len(as_replace)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Create a copy of the string that is an uppercase version of the original. Also, uppercase the original as_replace.
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_copy = Upper(as_string)
	s_upper_as_replace = Upper(as_replace)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set start position for search by finding the first substring to be replaced
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_start_pos=pos(s_copy,s_upper_as_replace,1)

Else
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set start position for search by finding the first substring to be replaced
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_start_pos=pos(as_string,as_replace,1)

End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through string to find all occurrences of substring and replace them
//-----------------------------------------------------------------------------------------------------------------------------------
Do Until l_start_pos = 0
	
	lb_skip_instance = False

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the left character's ascii value.
	//-----------------------------------------------------------------------------------------------------------------------------------	
	If l_start_pos <> 1 Then
		If ab_ignorecase Then
			l_left_character = Asc(Mid(s_copy, l_start_pos - 1, 1))
		Else
			l_left_character = Asc(Mid(as_string, l_start_pos - 1, 1))
		End If
	Else
		l_left_character = 0
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine if the character is AlphaNumeric: '0'= 48, '9'=57, 'A'=65, 'Z'=90, 'a'=97, 'z'=122,  " = 34, ' = 39 '_' = 95
	//-----------------------------------------------------------------------------------------------------------------------------------
	If (l_left_character >= 48  And l_left_character <= 57) Or (l_left_character >= 65 and l_left_character <= 90) Or &
		(l_left_character  = 34) Or (l_left_character  = 39) Or (l_left_character >= 97 And l_left_character <= 122) Or & 
		(l_left_character  = 95) Then
		lb_skip_instance = True		
	End If	
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the right character's ascii value.
	//-----------------------------------------------------------------------------------------------------------------------------------	
	If ab_ignorecase Then
		l_right_character = Asc(Mid(s_copy, l_start_pos + len(as_replace), 1))
	Else
		l_right_character = Asc(Mid(as_string, l_start_pos + len(as_replace), 1))
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine if the character is AlphaNumeric: '0'= 48, '9'=57, 'A'=65, 'Z'=90, 'a'=97, 'z'=122
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ((l_right_character >= 48  And l_right_character <= 57) Or (l_right_character >= 65 and l_right_character <= 90) Or &
		(l_right_character >= 97 And l_right_character <= 122) Or (l_right_character  = 95)) And Not lb_skip_instance Then
		lb_skip_instance = True	
	End If	
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Replace the instance in the string if necessary.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not lb_skip_instance Then
		If ab_ignorecase Then
			as_string = replace(as_string, l_start_pos + (l_diff_len* l_num_replaces), len(as_replace), as_replace_with)
			l_num_replaces++ 
		Else
			as_string=replace(as_string, l_start_pos, len(as_replace), as_replace_with)
		End If
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the next possible instance.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ab_ignorecase Then
		l_start_pos=pos(s_copy,s_upper_as_replace, l_start_pos + len(as_replace))		
	Else
		l_start_pos=pos(as_string, as_replace, l_start_pos + len(as_replace_with))
	End If
			
Loop

Return as_string
end function

on n_string_functions.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_string_functions.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

