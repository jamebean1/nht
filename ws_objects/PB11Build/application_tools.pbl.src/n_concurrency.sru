$PBExportHeader$n_concurrency.sru
forward
global type n_concurrency from nonvisualobject
end type
type istr_checkout from structure within n_concurrency
end type
end forward

type istr_checkout from structure
	string		s_tablename
	long		l_checkoutid
	long		l_id
	boolean		b_succeed
	boolean		b_processed
end type

global type n_concurrency from nonvisualobject
end type
global n_concurrency n_concurrency

type variables
Public:



private:
istr_checkout         istr_chckout[]
long l_userid
long il_ChckdOutToID
string is_ChckdOutFrm
string is_ChckdOutDteTme
string is_ChckdOutToNme
long il_ChckoutWndwHndle
string is_message
boolean ib_checkout_flat
boolean ib_single_checkout_called 
string is_checkedout_table[]
long 	 il_checkedout_id[]
string is_checkedout_user[]
end variables

forward prototypes
public function n_concurrency of_copy ()
public function boolean of_checkin_single (string as_tablename, long al_id)
public function string of_get_messagestring ()
public function boolean of_get_failed_items (ref string as_tables[], ref long al_ids[], ref string as_usernames[])
public function boolean of_checkout_multi (long al_userid)
public subroutine of_add_tableid (string as_table_name, long as_key)
public function boolean of_checkout (long al_userid)
public function long of_check_user_already_in (string as_username, string as_appname)
public function boolean of_checkin ()
end prototypes

public function n_concurrency of_copy ();n_concurrency ln_concurrency

ln_concurrency = create n_concurrency

ln_concurrency.istr_chckout = this.istr_chckout
ln_concurrency.l_userid = this.l_userid
ln_concurrency.il_ChckdOutToID = this.il_ChckdOutToID

ln_concurrency.is_ChckdOutFrm = this.is_ChckdOutFrm

ln_concurrency.is_ChckdOutDteTme = this.is_ChckdOutDteTme
ln_concurrency.is_ChckdOutToNme = this.is_ChckdOutToNme
ln_concurrency.il_ChckoutWndwHndle = this.il_ChckoutWndwHndle
ln_concurrency.is_message = this.is_message

return ln_concurrency
end function

public function boolean of_checkin_single (string as_tablename, long al_id);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_checkin
// Arguments:   l_userid 
// Overview:    DocumentScriptFunctionality
// Created by:  Jake Pratt
// History:     1/27/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long i_lc,i_tbles

//----------------------------------------------------------------------------------------------------------------------------------
// Check if there are tables and userids set.
//-----------------------------------------------------------------------------------------------------------------------------------
i_Tbles=upperbound(istr_chckout)
if i_Tbles=0 then
	return true
end if

//----------------------------------------------------------------------------------------------------------------------------------
// Delete any check out records.
//-----------------------------------------------------------------------------------------------------------------------------------
for i_LC=1 to i_Tbles
	if istr_chckout[i_lc].s_tablename = as_tablename and istr_chckout[i_lc].l_id = al_id then 
		
		istr_chckout[i_lc].b_succeed = false
		
		DELETE	Checkout
		Where		ChckOutID=:istr_chckout[i_LC].l_checkoutid;
		
	end if
next

	
return true


end function

public function string of_get_messagestring ();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_getmessagestring
//	Overrides:  No
//	Arguments:	
//	Overview:   Return the message to be displayed by the gui.
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Return is_message


end function

public function boolean of_get_failed_items (ref string as_tables[], ref long al_ids[], ref string as_usernames[]);

as_tables 		= is_checkedout_table
al_ids 			= il_checkedout_id
as_usernames 	= is_checkedout_user 

return true
end function

public function boolean of_checkout_multi (long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_checkout
//	Overrides:  No
//	Arguments:	
//	Overview:   create the checkout records for the items in the checkout array.
//	Created by: Jake Pratt
//	History:    5-23-2003 - First Creation
//-----------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------
boolean b_return
//n_string_functions ln_string_functions
integer i_Tbles, i_LC, i_LgdIn
long l_ChckdOutToID, l_WndwHndle, l_PrntID,l_nullarray[]
string s_ChckdOutFrmWndw, s_ChckdOutToNme, s_CntctFrstNme, s_CntctLstNme,s_nullarray[]
datetime	dt_ChckOutAt
string s_AppNme="CustomerFocus", s_LgnID,s_WndwDscrptn, s_PrntTbleNme, s_LstInChn
long l_Ky, l_ChckoutWndwHndle
string s_BgnTrnsctn="BEGIN TRANSACTION", s_CmmtTrnsctn="COMMIT TRANSACTION"
string s_RllBckTrnsctn="ROLLBACK TRANSACTION"
n_update_tools ln_update_tools



//----------------------------------------------------------------------------------------------------------------------------------
// Check if the user is already logged in.
//-----------------------------------------------------------------------------------------------------------------------------------
DECLARE lSP_Chck_Usr_Alrdy_In PROCEDURE for dbo.SP_Chck_Usr_Alrdy_In
		@vc30_LgnID=:s_LgnID,
		@vc16_AppNme=:s_AppNme,
		@i_UsrID=:l_ChckdOutToID,
		@si_LgdIn=:i_LgdIn OUTPUT
		using SQLCA;


is_checkedout_table 	= s_nullarray
il_checkedout_id		= l_nullarray
is_checkedout_user 	= s_nullarray



//----------------------------------------------------------------------------------------------------------------------------------
// Verify that the user has initalized the structure.
//-----------------------------------------------------------------------------------------------------------------------------------
i_Tbles=upperbound(istr_chckout)
if i_Tbles=0 then
	return true
elseif IsNull(istr_chckout[1].s_tablename) or IsNull(istr_chckout[1].l_id) then
	return true
end if

//-----------------------------------------------------------------------------------------------------------------------------------
//  ChckoutID is now an Identity, and no longer being manages by KeyController
//-----------------------------------------------------------------------------------------------------------------------------------
// Get Enough keys for the entire list.
//ln_update_tools = create n_update_tools
//l_ky = ln_update_tools.of_get_key ('Checkout',i_Tbles)
//destroy ln_update_tools



Execute Immediate :s_BgnTrnsctn Using SQLCA;



for i_LC=1 to i_Tbles
	
	// This logic allows the checkout to be called multiple times and only process newly added tables.
	if istr_chckout[i_lc].b_processed then continue
	istr_chckout[i_lc].b_processed = true
	
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Make sure the parent table is either the first or the one before this one.
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_PrntTbleNme=istr_chckout[i_lc].s_tablename
	l_PrntID=istr_chckout[i_lc].l_id
	istr_chckout[i_LC].b_succeed = True
	
	setnull(l_ChckdOutToID)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Check if this object is already checkout.
	//-----------------------------------------------------------------------------------------------------------------------------------
	SELECT	ChckoutUserID,
				ChckoutWndwNme,
				ChckoutDte,
				ChckoutWndwHndle
	INTO		:l_ChckdOutToID,
				:s_ChckdOutFrmWndw,
				:dt_ChckOutAt,
				:l_ChckOutWndwHndle
	FROM		Checkout (NOLOCK)
	WHERE		ChckoutTbleNme=:istr_chckout[i_LC].s_tablename
	AND		ChckoutHdrID=:istr_chckout[i_LC].l_id
	AND		ChckoutPrntChckoutTbleNme=:s_Prnttblenme
	AND		ChckoutPrntChckoutHdrID=:l_PrntID
	AND		ChckoutFrstInChnChckoutTbleNme=:istr_chckout[i_LC].s_tablename
	AND		ChckoutFrstInChnChckoutHdrID=:istr_chckout[i_LC].l_id
	USING		SQLCA;

	//----------------------------------------------------------------------------------------------------------------------------------
	// If values came back then the object is already checkedout.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if l_ChckdOutToID > 0 then 


		SELECT	CntctFrstNme, CntctLstNme, UserDBMnkr
		INTO		:s_CntctFrstNme,
					:s_CntctLstNme,
					:s_LgnID
		FROM		Users (NOLOCK), Contact (NOLOCK)
		WHERE		UserID=:l_ChckdOutToID
		AND		CntctID=UserCntctID
		USING		SQLCA;

		//----------------------------------------------------------------------------------------------------------------------------------
		// Check if the previous checkoutee is still logged in.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Execute lSP_Chck_Usr_Alrdy_In;
		Fetch lSP_Chck_Usr_Alrdy_In INTO :i_LgdIn;

		If SQLCA.SQLCode = -1 Then
			Return False
		end if
		
		close lSP_Chck_Usr_Alrdy_In;

		//----------------------------------------------------------------------------------------------------------------------------------
		// Set the checked out info into variables so the developer can request a message string.
		//-----------------------------------------------------------------------------------------------------------------------------------
		if i_LgdIn>0 then 
			
			il_ChckdOutToID=l_ChckdOutToID
			is_ChckdOutFrm=s_ChckdOutFrmWndw
			is_ChckdOutDteTme=string(dt_ChckOutAt)			
			is_ChckdOutToNme=trim(s_CntctFrstNme) + " " + trim(s_CntctLstNme)		
			il_ChckoutWndwHndle=l_ChckoutWndwHndle
			
			istr_chckout[i_LC].b_succeed = false
			is_checkedout_table[ upperbound(is_checkedout_table) + 1] 		= istr_chckout[i_LC].s_tablename
			il_checkedout_id[ upperbound(il_checkedout_id) + 1] 			= istr_chckout[i_LC].l_id
			is_checkedout_user[ upperbound(is_checkedout_user) + 1] 		= is_ChckdOutToNme

			is_message = "Sorry, but this item has been checked out to "+ is_ChckdOutToNme + " since " + is_ChckdOutDteTme
			continue
			
		else
			
					
			
		end if
		
	end if



//	istr_chckout[i_LC].l_CheckOutID=l_Ky + (i_lc - 1)
	

	INSERT INTO Checkout
			(
//			ChckoutID,
			ChckoutTbleNme,
			ChckoutHdrID,
			ChckoutUserID,
			ChckoutWndwHndle,
			ChckoutWndwNme,
			ChckoutPrntChckoutTbleNme,
			ChckoutPrntChckoutHdrID,
			ChckoutLstInChn,
			ChckoutFrstInChnChckoutTbleNme,
			ChckoutFrstInChnChckoutHdrID
			)
	VALUES
			(
//			:istr_chckout[i_LC].l_CheckOutID,
			:istr_chckout[i_LC].s_tablename,
			:istr_chckout[i_LC].l_id,
			:al_userid,
			:l_WndwHndle,
			:s_WndwDscrptn,
			:istr_chckout[i_LC].s_tablename,
			:istr_chckout[i_LC].l_id,
			"Y",
			:istr_chckout[i_LC].s_tablename,
			:istr_chckout[i_LC].l_id
			);

	//-----------------------------------------------------------------------------------------------------------------------------------
	// #47472 - 3/15/2004 - Pat Newgent
	// ChckoutID is now an Identity, and no longer being manages by KeyController
	//-----------------------------------------------------------------------------------------------------------------------------------
	Select top 1 @@identity into :l_ky From Checkout (nolock);
	istr_chckout[i_LC].l_CheckOutID=l_Ky
	
next

Execute Immediate :s_CmmtTrnsctn Using SQLCA;
	

ib_checkout_flat = False

if upperbound(is_checkedout_table) > 0 then 
	return false
else
	return true
end if

end function

public subroutine of_add_tableid (string as_table_name, long as_key);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_add_tableid
//	Overrides:  No
//	Arguments:	
//	Overview:   Add a table to the list to be checked out.
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_upperbound 

l_upperbound = upperbound(istr_chckout) 
l_upperbound ++

istr_chckout[l_upperbound].s_tablename = as_table_name
istr_chckout[l_upperbound].l_id = as_key
end subroutine

public function boolean of_checkout (long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_checkout
//	Overrides:  No
//	Arguments:	
//	Overview:   create the checkout records for the items in the checkout array.
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//	25499	KCS	05/31/2002	Date modifications
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
integer i_Tbles, i_LC, i_LgdIn
long l_ChckdOutToID, l_PrntID
string  s_ChckdOutToNme, s_CntctFrstNme, s_CntctLstNme
datetime	dt_ChckOutAt
string s_AppNme="CustomerFocus", s_LgnID, s_PrntTbleNme, s_LstInChn
long l_Ky
string s_BgnTrnsctn="BEGIN TRANSACTION", s_CmmtTrnsctn="COMMIT TRANSACTION"
string s_RllBckTrnsctn="ROLLBACK TRANSACTION"

// keeps checkout from being called multiple times.
if ib_single_checkout_called then return False
ib_single_checkout_called = true



//----------------------------------------------------------------------------------------------------------------------------------
// Verify that the user has initalized the structure.
//-----------------------------------------------------------------------------------------------------------------------------------
i_Tbles=upperbound(istr_chckout)
if i_Tbles=0 then
	return true
elseif IsNull(istr_chckout[1].s_tablename) or IsNull(istr_chckout[1].l_id) then
	return true
end if

for i_LC=1 to i_Tbles
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Make sure the parent table is either the first or the one before this one.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if i_LC=1 then
		s_PrntTbleNme=istr_chckout[1].s_tablename
		l_PrntID=istr_chckout[1].l_id
	else
		s_PrntTbleNme=istr_chckout[i_LC - 1].s_tablename
		l_PrntID=istr_chckout[i_LC - 1].l_id
	end if
	
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Check if this object is already checkout.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if i_LC=i_tbles then
		SELECT	
		DISTINCT	ChckoutUserID,
					ChckoutDte
		INTO		:l_ChckdOutToID,
					:dt_ChckOutAt
		FROM		Checkout (NOLOCK)
		WHERE		ChckoutTbleNme=:istr_chckout[i_LC].s_tablename
		AND		ChckoutHdrID=:istr_chckout[i_LC].l_id
		AND		ChckoutPrntChckoutTbleNme=:s_Prnttblenme
		AND		ChckoutPrntChckoutHdrID=:l_PrntID
		AND		ChckoutFrstInChnChckoutTbleNme=:istr_chckout[1].s_tablename
		AND		ChckoutFrstInChnChckoutHdrID=:istr_chckout[1].l_id
		USING		SQLCA;
	else
		SELECT	ChckoutUserID,
					ChckoutDte
		INTO		:l_ChckdOutToID,
					:dt_ChckOutAt
		FROM		Checkout (NOLOCK)
		WHERE		ChckoutTbleNme=:istr_chckout[i_LC].s_tablename
		AND		ChckoutHdrID=:istr_chckout[i_LC].l_id
		AND		ChckoutPrntChckoutTbleNme=:s_Prnttblenme
		AND		ChckoutPrntChckoutHdrID=:l_PrntID
		AND		ChckoutLstInChn='Y'
		AND		ChckoutFrstInChnChckoutTbleNme=:istr_chckout[1].s_tablename
		AND		ChckoutFrstInChnChckoutHdrID=:istr_chckout[1].l_id
		USING		SQLCA;
	end if

	//----------------------------------------------------------------------------------------------------------------------------------
	// If values came back then the object is already checkedout.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if l_ChckdOutToID > 0 then 

		SELECT	CntctFrstNme, CntctLstNme, UserDBMnkr
		INTO		:s_CntctFrstNme,
					:s_CntctLstNme,
					:s_LgnID
		FROM		Users (NOLOCK), Contact (NOLOCK)
		WHERE		UserID=:l_ChckdOutToID
		AND		CntctID=UserCntctID
		USING		SQLCA;

		//----------------------------------------------------------------------------------------------------------------------------------
		// Check if the previous checkoutee is still logged in.
		//-----------------------------------------------------------------------------------------------------------------------------------
		i_LgdIn = of_checK_user_already_in(s_lgnid,s_AppNme)

		//----------------------------------------------------------------------------------------------------------------------------------
		// Set the checked out info into variables so the developer can request a message string.
		//-----------------------------------------------------------------------------------------------------------------------------------
		if i_LgdIn>0 then 
			
			il_ChckdOutToID=l_ChckdOutToID
			is_ChckdOutDteTme=string(dt_ChckOutAt)			
			is_ChckdOutToNme=trim(s_CntctFrstNme) + " " + trim(s_CntctLstNme)		

			istr_chckout[i_LC].b_succeed = false
			
			is_message = "Sorry, but this item has been checked out to "+ is_ChckdOutToNme + " since " + is_ChckdOutDteTme
			return false
			
		end if
		
	end if

next

//-----------------------------------------------------------------------------------------------------------------------------------
// #47472 - 3/15/2004 - Pat Newgent
// ChckoutID is now an Identity, and no longer being manages by KeyController
//-----------------------------------------------------------------------------------------------------------------------------------
//n_update_tools ln_tools
//ln_tools = create n_update_tools
//l_Ky = ln_tools.of_get_key("Checkout",i_Tbles)
//destroy ln_tools
//if not l_Ky > 0 then return False

Execute Immediate :s_BgnTrnsctn Using SQLCA;

for i_LC=1 to i_Tbles


	//----------------------------------------------------------------------------------------------------------------------------------
	// Since it wasn't checked out, lets check it out.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if i_LC=i_Tbles then
		s_LstInChn='Y'
	else
		s_LstInChn='N'
	end if
	
//	istr_chckout[i_LC].l_CheckOutID=l_Ky

	INSERT INTO Checkout
			(
//			ChckoutID,
			ChckoutTbleNme,
			ChckoutHdrID,
			ChckoutUserID,
			ChckoutWndwHndle,
			ChckoutWndwNme,
			ChckoutPrntChckoutTbleNme,
			ChckoutPrntChckoutHdrID,
			ChckoutLstInChn,
			ChckoutFrstInChnChckoutTbleNme,
			ChckoutFrstInChnChckoutHdrID
			)
	VALUES
			(
//			:l_Ky,
			:istr_chckout[i_LC].s_tablename,
			:istr_chckout[i_LC].l_id,
			:al_userid,
			0,
			"",
			:s_PrntTbleNme,
			:l_PrntID,
			:s_LstInChn,
			:istr_chckout[1].s_tablename,
			:istr_chckout[1].l_id
			);

	//-----------------------------------------------------------------------------------------------------------------------------------
	// #47472 - 3/15/2004 - Pat Newgent
	// ChckoutID is now an Identity, and no longer being manages by KeyController
	//-----------------------------------------------------------------------------------------------------------------------------------
	Select top 1 @@identity into :l_ky From Checkout (nolock);
	istr_chckout[i_LC].l_CheckOutID=l_Ky
	
	istr_chckout[i_LC].b_succeed = true

	l_Ky++
	
Next


Execute Immediate :s_CmmtTrnsctn Using SQLCA;
If SQLCA.SQLCode=-1 Then
	Return False
end if
	
return true

end function

public function long of_check_user_already_in (string as_username, string as_appname);long i_ScrtyDBUsrID , i_DBID ,i_err ,l_count
string s_msg,l_test

// Check to see if the user is logged in and if now, delete his checkout records.
select 	count(*)
Into 	:l_count
from	master..sysprocesses 
where	dbid=DB_ID()
and	loginame = 'sysuser'
and	hostname=:as_username
and	program_name=:as_appname;


if l_count=0 then 
	
	Delete	Checkout
	From Users
	where	ChckOutUserID=UserID
	And	Users.UserDBMnkr like :as_username;

end if

return l_count
end function

public function boolean of_checkin ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_checkin
// Arguments:   l_userid 
// Overview:    DocumentScriptFunctionality
// Created by:  Jake Pratt
// History:     1/27/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long i_lc,i_tbles

ib_single_checkout_called = false


//----------------------------------------------------------------------------------------------------------------------------------
// Check if there are tables and userids set.
//-----------------------------------------------------------------------------------------------------------------------------------
i_Tbles=upperbound(istr_chckout)
if i_Tbles=0 then
	return true
end if

//----------------------------------------------------------------------------------------------------------------------------------
// Delete any check out records.
//-----------------------------------------------------------------------------------------------------------------------------------
for i_LC=1 to i_Tbles
	if istr_chckout[i_LC].b_succeed = true then 
		DELETE	Checkout
		Where		ChckOutID=:istr_chckout[i_LC].l_checkoutid;
	end if
next

If SQLCA.SQLCode=-1 Then
	//gl_dberrcde = SQLCA.SQLDBCode
	//gs_dberrtxt = SQLCA.SQLErrText
	//is_message = gs_dberrtxt
	return true
	
end if
	
return true


end function

on n_concurrency.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_concurrency.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

