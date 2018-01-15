$PBExportHeader$u_dbx_timer.sru
$PBExportComments$This timer is used in sleep mode to maintain an active database connection.
forward
global type u_dbx_timer from timing
end type
end forward

global type u_dbx_timer from timing
end type
global u_dbx_timer u_dbx_timer

event timer;/*****************************************************************************************
   Event:      timer
   Purpose:    Perform a simple query against the database to maintain an active
					connection over a prolonged period of time.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/27/01 M. Caruso    Created.
*****************************************************************************************/

STRING	l_cDummy

SELECT row_id INTO :l_cDummy
  FROM cusfocus.one_row
 USING SQLCA;
end event

on u_dbx_timer.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_dbx_timer.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

