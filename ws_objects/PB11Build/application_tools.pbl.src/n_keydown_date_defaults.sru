$PBExportHeader$n_keydown_date_defaults.sru
forward
global type n_keydown_date_defaults from nonvisualobject
end type
end forward

global type n_keydown_date_defaults from nonvisualobject
end type
global n_keydown_date_defaults n_keydown_date_defaults

type variables
datawindow idw_data
string is_autokey

end variables

forward prototypes
public subroutine of_init (datawindow adw_data)
public subroutine of_dwnkey ()
private subroutine of_autokey ()
end prototypes

public subroutine of_init (datawindow adw_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Arguments:   adw_data
// Overview:    initialize the datawindow variable
// Created by:  Jake Pratt
// History:     1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data = adw_data
end subroutine

public subroutine of_dwnkey ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_autofill()
// Arguments:   none
// Overview:    Call this script in the pbm_dwnkey of a dw to autofill the drop downs.
// Created by:  Jake Pratt
// History:     1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string  ls_column_name

if keydown( keyt!) then

	is_autokey = "T"
	this.function post of_autokey()

elseif keydown( keysubtract!) or keydown(Keydash!)  then

	is_autokey = "-"
	this.function post of_autokey()

elseif keydown( keyadd!) or keydown(KeyEqual!)  then

	is_autokey = "+"
	this.function post of_autokey()
	
elseif keydown( keyp!) then

	is_autokey = 'P'
	this.function post of_autokey()

elseif keydown( keya!) then

	is_autokey = 'A'
	this.function post of_autokey()

end if

end subroutine

private subroutine of_autokey ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_autokey
// Overrides:  No
// Overview:   FInd the text the user typed from the dddw and fill to end of field
// Created by: Jake Pratt
// History:    1/25/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_column,ls_time
string	ls_text
Long		ll_plusorminus

ls_column = idw_data.getcolumnname()

if upper( left(idw_data.describe( ls_column + ".coltype"),4)) = "DATE" then

	choose case is_autokey

		case "T"
			idw_data.settext( string(today()))

		case "-", "+"
			If is_autokey = '-' Then
				ll_plusorminus = -1
			Else
				ll_plusorminus = 1
			End If
			
			ls_text = idw_data.gettext()
			ls_time = right(ls_text,len (ls_text) - pos(ls_text,' '))
			ls_text = Left(ls_text, Pos(ls_text, ' '))
			if isdate(ls_text) then
				idw_data.settext( string(relativedate( date( ls_text), ll_plusorminus)) + ' ' + ls_time)
			else

				idw_data.settext( string(relativedate( today(), ll_plusorminus)))
			end if

	case 'A','P'
			string ls_date_text, ls_time_text
			time	lt_time
			
			ls_text = idw_data.gettext()
			ls_date_text = Left(ls_text, Pos(ls_text, ' '))
			
			ls_time_text = mid( ls_text, Pos(ls_text, ' ') + 1, 99999)
			
			lt_time = time(ls_time_text)

			if lt_time > 12:00:00 and is_autokey = 'P' then Return
			if lt_time < 12:00:00 and is_autokey = 'A' then Return
			
			if is_autokey = 'A' then ll_plusorminus = -1 else ll_plusorminus = 1
			
			idw_data.settext( string( datetime(date(ls_date_text), relativetime( time(ls_time_text), ll_plusorminus * 12 * 60 * 60))))
	end choose

end if


end subroutine

on n_keydown_date_defaults.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_keydown_date_defaults.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

