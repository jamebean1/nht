$PBExportHeader$terst.sra
$PBExportComments$Generated Application Object
forward
global type terst from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type terst from application
string appname = "terst"
end type
global terst terst

on terst.create
appname = "terst"
message = create message
sqlca = create transaction
sqlda = create dynamicdescriptionarea
sqlsa = create dynamicstagingarea
error = create error
end on

on terst.destroy
destroy( sqlca )
destroy( sqlda )
destroy( sqlsa )
destroy( error )
destroy( message )
end on

