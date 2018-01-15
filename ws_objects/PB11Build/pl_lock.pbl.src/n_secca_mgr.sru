$PBExportHeader$n_secca_mgr.sru
$PBExportComments$Application service to handle security
forward
global type n_secca_mgr from datastore
end type
end forward

global type n_secca_mgr from datastore
string dataobject = "d_plmanager"
event pld_retrieve pbm_custom75
end type
global n_secca_mgr n_secca_mgr

type prototypes
FUNCTION UINT wnetgetuser(REF STRING UserName, REF UINT namelen) LIBRARY "USER.EXE" alias for "wnetgetuser;Ansi"
FUNCTION BOOLEAN GetUserNameA(REF STRING UserName, REF UINT namelen) LIBRARY "ADVAPI32.DLL" alias for "GetUserNameA;Ansi"
end prototypes

type variables
STRING		i_ProgName
STRING		i_ProgVersion
STRING		i_ProgBMP
STRING		i_PlaqueDisplay
STRING		i_PlaqueBMP
STRING		i_ProgINI

W_PL_REGISTERBUTTON	i_RegisterWindow

TRANSACTION	i_SecTrans
TRANSACTION	i_AppTrans
TRANSACTION	i_KeyTrans

BOOLEAN	i_RegistrationMode
BOOLEAN	i_UseNetID, i_UseAudit, i_UseLogin, i_UseEncrypt
BOOLEAN	i_KeyTransConnected, i_SecurityConnected
BOOLEAN	i_AppConnected = FALSE
BOOLEAN	i_SameTrans
LONG		i_AppKey
LONG		i_UsrKey
LONG		i_DBKey
LONG		i_RoleKey[], i_DBKeys[]
LONG		i_AudKey
LONG		i_DisableColor
LONG		i_NumConnections

INTEGER	i_Status, i_GraceAttempts
INTEGER	i_PwdDays

STRING		i_AppName, i_AppExe, i_AppObj
STRING		i_UsrName
STRING		i_UsrLogin, i_UsrID
STRING		i_RoleName[]
STRING		i_DBName
STRING		i_BMPPath = ""
STRING		i_FilterWindow

STRING		i_AdmUseLogin
STRING		i_DateFormat
STRING		i_PromptForCopy
STRING		i_PromptForDelete
STRING		i_AdminName

LONG		i_AdmUsrKey
LONG		i_AdmKey

BOOLEAN	i_AdmMaintenance
BOOLEAN	i_AdmCreateUsers
BOOLEAN	i_AdmCreateGroups
BOOLEAN	i_AdmCreateApplications
BOOLEAN	i_AdmCreateConnections
BOOLEAN	i_AdmCreateRoles
BOOLEAN	i_AdmRegisterObjects
BOOLEAN	i_AdmClearAudit

BOOLEAN	i_AdmAssignment
BOOLEAN	i_AdmProfileAssignment
BOOLEAN	i_AdmAssignAppGrp
BOOLEAN	i_AdmAssignAppUsr
BOOLEAN	i_AdmAssignAppDB	
BOOLEAN	i_AdmAssignGrpUsr	
BOOLEAN	i_AdmAssignGrpDB
BOOLEAN	i_AdmAssignUsrDB
BOOLEAN	i_AdmRoleAssignment
BOOLEAN	i_AdmAssignGrpRole
BOOLEAN	i_AdmAssignUsrRole

INTEGER	i_DefaultGrace
LONG		i_DefaultDisableColor
INTEGER	i_DefaultPWDDays
STRING		i_DefaultUseNet
STRING		i_DefaultUseAudit
STRING		i_DefaultUseEncrypt
STRING		i_DefaultUseLogin

INTEGER	i_NumRegButtons
CommandButton	i_RegButton[]
BOOLEAN	i_DebugMode = FALSE 

INTEGER	i_NumObjects = 28
INTEGER	i_NumDWObjects = 10
INTEGER	i_NumMiscObjects = 9

STRING i_ObjectName[28] = {"CheckBox", &
                                           "CommandButton", &
                                           "DropDownListBox", &
                                           "EditMask", &
                                           "Graph", &
                                           "GroupBox", &
                                           "HScrollBar", &
                                           "Line", &
                                           "ListBox", &
                                           "MultiLineEdit", &
                                           "Oval", &
                                           "Picture", &
                                           "PictureButton", &
                                           "RadioButton", &
                                           "Rectangle", &
                                           "RoundRectangle", &
                                           "SingleLineEdit", &
                                           "Text", &
                                           "UserObject", &
                                           "VScrollBar", &
                                           "DropDownPictureListBox", &
                                           "ListView", &
                                           "OLEControl", &
                                           "PictureListBox", &
                                           "RichTextEdit", &
                                           "Tab", &
                                           "TreeView", &
                                           "OLECustomControl"}

OBJECT i_ObjectType[28] = {checkbox!, &
                                          commandbutton!, &
                                          dropdownlistbox!, &
                                          editmask!, &
                                          graph!, &
                                          groupbox!, &
                                          hscrollbar!, &
                                          line!, &
                                          listbox!, &
                                          multilineedit!, &
                                          oval!, &
                                          picture!, &
                                          picturebutton!, &
                                          radiobutton!, &
                                          rectangle!, &
                                          roundrectangle!, &
                                          singlelineedit!, &
                                          statictext!, &
                                          userobject!, &
                                          vscrollbar!, &
                                          dropdownpicturelistbox!, &
                                          listview!, &
                                          olecontrol!, &
                                          picturelistbox!, &
                                          richtextedit!, &
                                          tab!, &
                                          treeview!, &
                                          olecustomcontrol!}

STRING i_ObjectBMP[28]  = {"cbx.bmp", &
                                           "cb.bmp", &
                                           "ddlb.bmp", &
                                           "em.bmp", &
                                           "g.bmp", &
                                           "gb.bmp", &
                                           "hsb.bmp", &
                                           "ln.bmp", &
                                           "lb.bmp", &
                                           "mle.bmp", &
                                           "oval.bmp", &
                                           "p.bmp", &
                                           "pb.bmp", &
                                           "rb.bmp", &
                                           "r.bmp", &
                                           "rr.bmp", &
                                           "sle.bmp", &
                                           "st.bmp", &
                                           "uo.bmp", &
                                           "vsb.bmp", &
                                           "ddplb.bmp", &
                                           "lview.bmp", &
                                           "olectrl.bmp", &
                                           "plb.bmp", &
                                           "rtectrl.bmp", &
                                           "tab.bmp", &
                                           "tview.bmp", &
                                           "olectrl.bmp"}

STRING i_ObjectDWName[10] = {"DataWindow Bitmap", &
                                                "DataWindow Column", &
                                                "DataWindow Computed", &
                                                "DataWindow Graph", &
                                                "DataWindow Line", &
                                                "DataWindow Oval", &
                                                "DataWindow Rectangle", &
                                                "DataWindow RoundRectangle", &
                                                "DataWindow Blob", &
                                                "DataWindow Text"}

STRING i_ObjectDWType[10] = {"bitmap", &
                                               "column", &
                                               "compute", &
                                               "graph", &
                                               "line", &
                                               "ellipse", &
                                               "rectangle", &
                                               "roundrectangle", &
                                               "tableblob", &
                                               "text"}

STRING i_ObjectDWBMP[10] = {"p.bmp", &
                                               "column.bmp", &
                                               "computed.bmp", &
                                               "g.bmp", &
                                               "ln.bmp", &
                                               "oval.bmp", &
                                               "r.bmp", &
                                               "rr.bmp", &
                                               "blob.bmp", &
                                               "st.bmp"}

STRING i_ObjectMiscName[9] = {"DataWindow", &
                                                "Menu", &
                                                "Menu Item", &
                                                "Folder", &
                                                "Folder Tab", &
                                        	"Custom Control", &
			"Custom Control Object", &
			"Popup Menu", &
			"Popup Menu Item"}

STRING i_ObjectMiscType[9] = {"dw", &
                                               	"menu", &
			"menuitem", &
                                               	"folder", &
                                               	"tab", &
			"custom", &
			"customobject", &
			"popupmenu", &
			"popupmenuitem"}

STRING i_ObjectMiscBMP[9] = {"dw.bmp", &
                                              	"menu.bmp", &
                                                "menuitem.bmp", &
                                                "tab.bmp", &
                                                "tab_t.bmp", &
		                "custom.bmp", &
			"custom.bmp", &
			"menu.bmp", &
			"menuitem.bmp"}
end variables

forward prototypes
public function long fu_getkey (string key_name)
public function integer fu_setappkey ()
public function integer fu_rollback ()
public function integer fu_commit ()
public function integer fu_getregobjects (string window_name, ref string selected_names[])
public function integer fu_deleteregobjects (string window_name, string object_name)
public function long fu_getusrkey (string usr_login, ref string usr_name)
public function long fu_getdbdefaultkey (long usr_key)
public function integer fu_beginaudit ()
public function integer fu_getadmdefaults ()
public function integer fu_checkoldpwd (string usr_login, string usr_pwd)
public function integer fu_deleteaudit (long app_key)
public function integer fu_setusrpwd (string usr_login, string usr_pwd)
public function integer fu_disconnect (transaction transaction_object)
public function boolean fu_checkregister ()
public function integer fu_getadmlogin (long adm_key, ref string adm_login, ref string adm_pwd)
public function integer fu_setadminfo (long adm_key, string adm_pwd)
public function integer fu_getnetid (ref string usr_login)
public function integer fu_getgrpinfo (ref long grp_key[], ref string grp_name[])
public subroutine fu_getroleinfo (ref long role_key[], ref string role_name[])
public function integer fu_setusrinfo (long usr_key, string usr_pwd, long db_default)
public function integer fu_checkadminloginonly (string adm_login)
public function boolean fu_getobjbit (string obj_attr, integer obj_bit)
public function integer fu_deleteroleassign (long parent_type, long child_type, long parent_key, long child_key, long app_key)
public function integer fu_insertprofileassign (long parent_type, long child_type, long parent_key, long child_key)
public function integer fu_insertroleassign (long parent_type, long child_type, long parent_key, long child_key, integer app_key)
public function integer fu_checkadminoldpwd (string adm_login, string adm_pwd)
public function integer fu_setregobjects (string object_name, string object_desc, integer object_type, string window_name, string object_tblcol)
public function integer fu_deleteprofilerelates (string profile_type, integer profile_key)
public function integer fu_deleteprofileassign (long parent_type, long child_type, long parent_key, long child_key)
public function integer fu_deleterolerelates (integer role_key)
public function integer fu_checkpwdencrypt ()
public function integer fu_insertadminassign (integer parent_key, integer child_key)
public function integer fu_deleteadminassign (integer parent_key, integer child_key)
public function integer fu_checkadminroles (integer adm_key)
public function integer fu_deleteobjrestrict (integer app_key, integer obj_key)
public function integer fu_setusrstatus (integer status, string usr_login)
public function integer fu_checkadmin (string adm_login, string adm_pwd)
public function integer fu_buildsearch (datawindow searchdw, string searchcriteria)
public function string fu_quotechar (string fix_string, string quote_chr)
public function integer fu_deleteadminrelates (integer adm_key)
public function integer fu_changeusrpwds ()
public function string fu_encryptpwd (string password)
public function string fu_decryptpwd (string password)
public function integer fu_changedbpwds ()
public function integer fu_buildfilter (ref datawindow filterdw, string filtercriteria)
public function integer fu_endaudit ()
public subroutine fu_debug ()
public function integer fu_setplaceholder (string window_name, string object_name)
public function integer fu_securedwobj (datawindow security_dw, string security_object, boolean invisible, boolean disable, boolean expression, string exp_value, string color_value, string exp_orig)
public function string fu_buildobjname (powerobject object_name)
public function boolean fu_checkadd (window security_window, datawindow security_dw)
public function boolean fu_checkdelete (window security_window, datawindow security_dw)
public function boolean fu_checkdragdrop (window security_window, dragobject security_obj)
public function boolean fu_checkdrilldown (window security_window, datawindow security_dw)
public function boolean fu_checkquerymode (window security_window, datawindow security_dw)
public function integer fu_setcustomdescriptions (ref window window_name, ref windowobject control_name, ref string description[], ref boolean customcontrol)
public subroutine fu_getappinfo (ref long app_key, ref string app_name)
public subroutine fu_getdbinfo (ref long db_key, ref string db_name)
public function integer fu_getobjectsecurity (window window_name, powerobject object_name, string dwobject_name, ref boolean obj_visible, ref boolean obj_enable, ref boolean obj_add, ref boolean obj_delete, ref boolean obj_drilldown, ref boolean obj_query, ref boolean obj_dragdrop)
public subroutine fu_getusrinfo (ref long usr_key, ref string usr_login, ref string usr_name)
public function integer fu_login (application application_object, transaction security_transaction, transaction application_transaction, string bitmap_file)
public function integer fu_setobjectsecurity (window security_window, powerobject security_object, string security_dwobject)
public function integer fu_setpopupsecurity (window security_window, ref menu popup_menu, integer popup_x, integer popup_y)
public subroutine fu_setrowsecurity (powerobject security_object)
public function integer fu_setsecurity (powerobject security_object)
public function integer fu_setcolvariables (window security_window, datawindow security_dw, string security_col, string values[])
public function integer fu_setrowvariables (window security_window, datawindow security_dw, string values[])
public function integer fu_login (application application_object, transaction security_transaction, transaction application_transaction)
public function integer fu_setobjectsecurity (window security_window, powerobject security_object)
public function integer fu_getobjectsecurity (window window_name, powerobject object_name, ref boolean obj_visible, ref boolean obj_enable, ref boolean obj_dragdrop)
public function integer fu_getobjectsecurity (window window_name, powerobject object_name, string dwobject_name, ref boolean obj_visible, ref boolean obj_enable)
public function boolean fu_checkenable (window security_window, dragobject security_obj, string security_dwobject)
public function boolean fu_checkenable (window security_window, dragobject security_obj)
public function integer fu_getobjectinfo (window window_name, ref string obj_name[], ref string obj_desc[], ref string obj_type[], ref boolean obj_visible[], ref boolean obj_enable[], ref boolean obj_add[], ref boolean obj_delete[], ref boolean obj_drill[], ref boolean obj_query[], ref boolean obj_drag[])
public function integer fu_refreshsecurity ()
public function integer fu_deletenonregobjects (string window_name, boolean delete_uos, boolean delete_menus, boolean delete_dws)
public function boolean fu_checkenablepc (window security_window, dragobject security_obj, string security_dwobject)
public subroutine fu_setcustomsecurity (readonly window window_name, readonly windowobject control_name, ref string description, ref string restriction)
public function integer fu_insertadminappassign (integer parent_key, integer child_key)
public function integer fu_deleteadminappassign (integer parent_key, integer child_key)
public function long fu_getadmappcount (long adm_key)
public function integer fu_connect (transaction transaction_object)
public function integer fu_checkloginonly (string usr_login)
public function integer fu_checklogin (string usr_login, string usr_pwd, integer login_attempts)
public function integer fu_applyrestrictions (readonly windowobject security_object, boolean invisible, boolean disable, boolean row_criteria, string row_type, string row_clause)
public function integer fu_checkuselogin (string usr_login, integer login_attempts)
public function integer fu_getdbuserinfo (long db_key, ref string db_name, ref string db_info[], string usr_login, string usr_pwd)
end prototypes

event pld_retrieve;//******************************************************************
//  PL Module     : n_secca_mgr
//  Event         : pld_Retrieve
//  Description   : After security data is retrieved from the 
//                  database, combine roles that have restrictions
//                  on the same objects.  Always take the most
//                  restrictive condition.
//
//  Change History:
//
//  Date     Person     Problem # / Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_FoundVisible, l_FoundEnable, l_FoundAdd, l_FoundDelete
BOOLEAN l_FoundDrill, l_FoundOverRide, l_FoundQuery, l_FoundDragDrop
BOOLEAN l_RowFilterFound, l_RowWhereFound, l_ColCriteriaFound
INTEGER l_Idx, l_Rows, l_Bit[], l_NewBit, l_CurrentRow, l_NumToDelete
INTEGER l_NumRoles, l_Jdx, l_Delete[], l_Junk
STRING  l_CurrentWindow, l_CurrentObject, l_Window, l_Object
STRING  l_NewRole, l_Comma, l_RoleName, l_RowType[], l_RowCriteria[]
STRING  l_RowFilter, l_RowWhere, l_ColCriteria

//-----------------------------------------------------------------
//  Retrieve the rows for the current user and application.
//-----------------------------------------------------------------

SetTransObject(i_SecTrans)
l_Rows = Retrieve(i_AppKey, i_UsrKey)

IF l_Rows > 1 THEN
   l_CurrentObject = GetItemString(1, "obj_name")
   l_CurrentWindow = GetItemString(1, "obj_window")
   l_CurrentRow = 1
   l_NumToDelete = 0
	
   //---------------------------------------------------------------
   //  Loop through all of the rows (which are sorted by:
   //  window_name, obj_name, and role_name) and combine the 
   //  restrictions placed on an object across multiple roles.
   //---------------------------------------------------------------
	
   FOR l_Idx = 1 TO l_Rows + 1
		
      //------------------------------------------------------------
      //  If we are done with all of the rows, then make sure that
      //  the last group gets processed by setting l_Window and 
      //  l_Object to empty strings.
      //------------------------------------------------------------
		
      IF l_Idx > l_Rows THEN
         l_Window = ""
         l_Object = ""
      ELSE
         l_Window = GetItemString(l_Idx, "obj_window")
         l_Object = GetItemString(l_Idx, "obj_name")
      END IF
		
      //------------------------------------------------------------
      //  If the the window or object name has changed, then it is
      //  time to combine this group of restrictions.
      //------------------------------------------------------------
		
      IF l_CurrentWindow <> l_Window OR &
         l_CurrentObject <> l_Object THEN
			
         //---------------------------------------------------------
         //  If there is only one role, then there is nothing to
         //  combine.
         //---------------------------------------------------------
			
         IF l_NumRoles > 1 THEN
            l_NewBit           = 0
            l_FoundOverRide    = FALSE
            l_FoundVisible     = FALSE
            l_FoundEnable      = FALSE
            l_FoundAdd         = FALSE
            l_FoundDelete      = FALSE
            l_FoundDrill       = FALSE
				l_FoundQuery       = FALSE
				l_FoundDragDrop    = FALSE
            l_NewRole          = ""
            l_Comma            = ""
				l_RowFilter        = ""
				l_RowFilterFound   = FALSE
				l_RowWhere         = ""
				l_RowWhereFound    = FALSE
				l_ColCriteria      = ""
				l_ColCriteriaFound = FALSE
				
            //------------------------------------------------------
            //  Loop through the roles and combine the bit values
            //  and row and column restrictions for the current
            //  object.
            //------------------------------------------------------
				
            FOR l_Jdx = 1 TO l_NumRoles
               l_NewRole = l_NewRole + l_Comma + i_RoleName[l_Jdx]
               l_Comma = ", "
               IF l_Bit[l_Jdx] = -1 THEN
                  l_NewBit = -1
                  l_FoundOverRide = TRUE
               END IF
					
               //---------------------------------------------------
               //  If we have found an override, then just ignore
               //  any other restrictions on this object.
               //---------------------------------------------------
					
               IF NOT l_FoundOverRide THEN
						
                  //------------------------------------------------
                  //  Check for each bit value.  If we haven't found
                  //  it yet, then add it in.
                  //------------------------------------------------
						
                  IF NOT fu_GetObjBit("VISIBLE", l_Bit[l_Jdx]) THEN
                     IF NOT l_FoundVisible THEN
                        l_NewBit = l_NewBit + 1
                        l_FoundVisible = TRUE
                     END IF
                  END IF
                  IF NOT fu_GetObjBit("ENABLE", l_Bit[l_Jdx]) THEN
                     IF NOT l_FoundEnable THEN
                        l_NewBit = l_NewBit + 2
                        l_FoundEnable = TRUE
                     END IF
                  END IF
                  IF NOT fu_GetObjBit("ADD", l_Bit[l_Jdx]) THEN
                     IF NOT l_FoundAdd THEN
                        l_NewBit = l_NewBit + 4
                        l_FoundAdd = TRUE
                     END IF
                  END IF
                  IF NOT fu_GetObjBit("DELETE", l_Bit[l_Jdx]) THEN
                     IF NOT l_FoundDelete THEN
                        l_NewBit = l_NewBit + 8
                        l_FoundDelete = TRUE
                     END IF
                  END IF
                  IF NOT fu_GetObjBit("DRILLDOWN", l_Bit[l_Jdx]) THEN
                     IF NOT l_FoundDrill THEN
                        l_NewBit = l_NewBit + 16
                        l_FoundDrill = TRUE
                     END IF
                  END IF
                  IF NOT fu_GetObjBit("QUERYMODE", l_Bit[l_Jdx]) THEN
                     IF NOT l_FoundQuery THEN
                        l_NewBit = l_NewBit + 32
                        l_FoundQuery = TRUE
                     END IF
                  END IF
                  IF NOT fu_GetObjBit("DRAGDROP", l_Bit[l_Jdx]) THEN
                     IF NOT l_FoundDrill THEN
                        l_NewBit = l_NewBit + 64
                        l_FoundDragDrop = TRUE
                     END IF
                  END IF
						
                  //------------------------------------------------
                  //  Combine the WHERE, FILTER, or COLUMN criteria.
                  //------------------------------------------------

						IF NOT IsNull(l_RowCriteria[l_Jdx]) AND &
						              l_RowCriteria[l_Jdx] <> "" THEN
							CHOOSE CASE l_RowType[l_Jdx]
							   CASE "F"
								   IF l_RowFilterFound THEN
									   l_RowFilter = l_RowFilter + " AND " + l_RowCriteria[l_Jdx]
								   ELSE
									   l_RowFilter = l_RowCriteria[l_Jdx]
									   l_RowFilterFound = TRUE
								   END IF
							   CASE "W"
								   IF l_RowWhereFound THEN
									   l_RowWhere = l_RowWhere + " AND " + l_RowCriteria[l_Jdx]
								   ELSE
									   l_RowWhere = l_RowCriteria[l_Jdx]
									   l_RowWhereFound = TRUE
								   END IF
								CASE ELSE
									IF l_ColCriteriaFound THEN
										l_ColCriteria = l_ColCriteria + " AND " + l_RowCriteria[l_Jdx]
									ELSE
										l_ColCriteria = l_RowCriteria[l_Jdx]
										l_ColCriteriaFound = TRUE
									END IF
							END CHOOSE
						END IF
               END IF
            NEXT
				
            //------------------------------------------------------
            //  Set the combined bit value and as much of the role
            //  list as possible.
            //------------------------------------------------------
   
            SetItem(l_CurrentRow, "obj_bit", l_NewBit)
            IF Len(l_NewRole) > 40 THEN
               l_NewRole = MID(l_NewRole, 1, 40)
            END IF
            SetItem(l_CurrentRow, "role_name", l_NewRole)
				
            //------------------------------------------------------
            //  If we didn't find an override, then go ahead and set
            //  the combined FILTER, WHERE, or COLUMN criteria, else
            //  make sure that the "row_type" and "row_criteria"
            //  columns get blanked out.
            //------------------------------------------------------

            IF NOT l_FoundOverride THEN
				   IF l_RowFilterFound THEN
					   SetItem(l_CurrentRow, "row_type", "F")
					   SetItem(l_CurrentRow, "row_criteria", l_RowFilter)
				   ELSEIF l_RowWhereFound THEN
					   SetItem(l_CurrentRow, "row_type", "W")
					   SetItem(l_CurrentRow, "row_criteria", l_RowWhere)
					ELSEIF l_ColCriteriaFound THEN
						SetItem(l_CurrentRow, "row_type", "")
						SetItem(l_CurrentRow, "row_criteria", l_ColCriteria)
					END IF
				ELSE
					SetItem(l_CurrentRow, "row_type", "")
					SetItem(l_CurrentRow, "row_criteria", "")
				END IF

         END IF
			
         //---------------------------------------------------------
         //  Initialize variables to process the next group of
         //  restrictions.
         //---------------------------------------------------------
			
         l_NumRoles = 0
         l_CurrentWindow = l_Window
         l_CurrentObject = l_Object
         l_CurrentRow = l_Idx
      END IF
		
      //------------------------------------------------------------
      //  If this isn't the last time through, then build up a list
      //  of roles and restrictions for the current object.
      //------------------------------------------------------------
		
      IF l_Window <> "" THEN
         l_NumRoles = l_NumRoles + 1
         l_Bit[l_NumRoles] = GetItemNumber(l_Idx, "obj_bit")
         i_RoleName[l_NumRoles] = GetItemString(l_Idx, "role_name")
         i_RoleKey[l_NumRoles] = GetItemNumber(l_Idx, "role_key")
			l_RowType[l_NumRoles] = GetItemString(l_Idx, "row_type")
			l_RowCriteria[l_NumRoles] = GetItemString(l_Idx, "row_criteria")
			
         //---------------------------------------------------------
         //  Remember which rows to delete.
         //---------------------------------------------------------
			
         IF l_Idx <> l_CurrentRow THEN
            l_NumToDelete = l_NumToDelete + 1
            l_Delete[l_NumToDelete] = l_Idx
         END IF
      END IF
   NEXT
	
   //---------------------------------------------------------------
   //  Now that the restrictions for each object have been combined
   //  into a single row, delete the extra rows.
   //---------------------------------------------------------------

   FOR l_Idx = l_NumToDelete TO 1 STEP -1
      DeleteRow(l_Delete[l_Idx])
   NEXT
END IF
end event

public function long fu_getkey (string key_name);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetKey
//  Description   : Generate a new key value when a new security
//						  component is added to the security database.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

LONG l_KeyValue
STRING l_MsgStrings[]

//------------------------------------------------------------------
// Retrieve the current highest key value from the security
// database.  	
//------------------------------------------------------------------

CHOOSE CASE key_name
   CASE "adm_key"
      SELECT adm_key INTO :l_KeyValue FROM pl_keys USING i_KeyTrans;
   CASE "app_key"
      SELECT app_key INTO :l_KeyValue FROM pl_keys USING i_KeyTrans;
   CASE "grp_key"
      SELECT grp_key INTO :l_KeyValue FROM pl_keys USING i_KeyTrans;
   CASE "usr_key"
      SELECT usr_key INTO :l_KeyValue FROM pl_keys USING i_KeyTrans;
   CASE "db_key"
      SELECT db_key INTO :l_KeyValue FROM pl_keys USING i_KeyTrans;
   CASE "role_key"
      SELECT role_key INTO :l_KeyValue FROM pl_keys USING i_KeyTrans;
   CASE "obj_key"
      SELECT obj_key INTO :l_KeyValue FROM pl_keys USING i_KeyTrans;
   CASE "aud_key"
      SELECT aud_key INTO :l_KeyValue FROM pl_keys USING i_KeyTrans;
END CHOOSE

//-----------------------------------------------------------------
// If a select error occurs the function will return a '-1'.  The code
// on the returning (pcd_setkey) would then assign '-1' to the user,
// group, etc.  A check on the other end (pcd_setkey) should also be
// made.
//-----------------------------------------------------------------

IF i_KeyTrans.SQLCODE <> 0 THEN
	l_MsgStrings[1] = i_KeyTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("KeySelect", 1, l_MsgStrings[])  
   RETURN -1
END IF

//-----------------------------------------------------------------
// Generate a new key.
//----------------------------------------------------------------- 


l_KeyValue = l_KeyValue + 1

CHOOSE CASE key_name
   CASE "adm_key"
      UPDATE pl_keys SET adm_key = :l_KeyValue USING i_KeyTrans;
   CASE "app_key"
      UPDATE pl_keys SET app_key = :l_KeyValue USING i_KeyTrans;
   CASE "grp_key"
      UPDATE pl_keys SET grp_key = :l_KeyValue USING i_KeyTrans;
   CASE "usr_key"
      UPDATE pl_keys SET usr_key = :l_KeyValue USING i_KeyTrans;
   CASE "db_key"
      UPDATE pl_keys SET db_key = :l_KeyValue USING i_KeyTrans;
   CASE "role_key"
      UPDATE pl_keys SET role_key = :l_KeyValue USING i_KeyTrans;
   CASE "obj_key"
      UPDATE pl_keys SET obj_key = :l_KeyValue USING i_KeyTrans;
   CASE "aud_key"
      UPDATE pl_keys SET aud_key = :l_KeyValue USING i_KeyTrans;
END CHOOSE

//-----------------------------------------------------------------
// If the update was unsuccessful we shouldn't return the new key.
// The next time we need a key we would have duplicates.  It should
// return '-1'.
//-----------------------------------------------------------------

IF i_KeyTrans.SQLCODE <> 0 THEN
	l_MsgStrings[1] = i_KeyTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("KeyUpdate", 1, l_MsgStrings[]) 
	Return -1
ELSE
   COMMIT USING i_KeyTrans;
   IF i_KeyTrans.SQLCODE <> 0 THEN
	   l_MsgStrings[1] = i_KeyTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("CommitError", 1, l_MsgStrings[]) 
      RETURN -1
   END IF
END IF

RETURN l_KeyValue
end function

public function integer fu_setappkey ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetAppKey
//  Description   : Get application profile information for the
//					     current executable.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_KeyValue
STRING l_UseNetID, l_UseAudit, l_UseLogin, l_MsgStrings[]

SELECT app_key, app_name, app_status, app_grace, app_color, app_pwd_days,
   app_use_netid, app_use_audit, app_use_login 
   INTO :i_AppKey, :i_AppName, :i_Status, :i_GraceAttempts, :i_DisableColor, :i_PwdDays,
   :l_UseNetID, :l_UseAudit, :l_UseLogin
   FROM pl_app 
   WHERE app_obj = :i_AppObj USING i_SecTrans;
	
i_AppName  = Trim(i_AppName)
l_UseNetID = Trim(l_UseNetID)
l_UseAudit = Trim(l_UseAudit)
l_UseLogin = Trim(l_UseLogin)

IF i_SecTrans.SQLCode = 100 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("AppNotFound", 1, l_MsgStrings[])
   RETURN -1
END IF

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("AppNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF

IF l_UseNetID = "Y" THEN
   i_UseNetID = TRUE
ELSE
   i_UseNetID = FALSE
END IF

IF l_UseAudit = "Y" THEN
   i_UseAudit = TRUE
ELSE
   i_UseAudit = FALSE
END IF   

IF l_UseLogin = "Y" THEN
   i_UseLogin = TRUE
ELSE
   i_UseLogin = FALSE
END IF   

RETURN 0
end function

public function integer fu_rollback ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_RollBack
//  Description   : Rollback database changes.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

ROLLBACK USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("RollbackError", 1, l_MsgStrings[])   
   RETURN -1
END IF

RETURN 0
end function

public function integer fu_commit ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_Commit
//  Description   : Commit changes to the security database.
//
//  Return        :  0 = commit successful
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

COMMIT USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("CommitError", 1, l_MsgStrings[])
   RETURN -1
END IF

RETURN 0
end function

public function integer fu_getregobjects (string window_name, ref string selected_names[]);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetRegObjects
//  Description   : Retrieve registered objects for a particular
//						  window.
//
//  Return        :  0 = login successful
//                  -1 = login failed
//                  -2 = login failed.  Attempt again.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_NumSelected
STRING  l_ObjectName, l_MsgStrings[]

DECLARE l_regobj CURSOR FOR
   SELECT obj_name FROM pl_obj_reg WHERE app_key = :i_AppKey AND
      obj_window = :window_name AND obj_type > 0 
      USING i_SecTrans;

OPEN l_regobj;
IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("ObjRegListNoRetrieve", 1, l_MsgStrings[])
   CLOSE l_regobj;
   RETURN -1
END IF

l_NumSelected = 0
DO
   FETCH l_regobj INTO :l_ObjectName;
   IF i_SecTrans.SQLCode = 0 THEN
      l_NumSelected = l_NumSelected + 1
      Selected_Names[l_NumSelected] = Trim(l_ObjectName)
   ELSE
      IF i_SecTrans.SQLCode <> 100 THEN
	      l_MsgStrings[1] = i_SecTrans.SQLErrText
         SECCA.MSG.fu_DisplayMessage("ObjRegListNoRetrieve", 1, l_MsgStrings[])

         CLOSE l_regobj;
         RETURN -1
      END IF
   END IF
LOOP UNTIL i_SecTrans.SQLCode <> 0

CLOSE l_regobj;
IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("ObjRegListNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF

RETURN l_NumSelected
end function

public function integer fu_deleteregobjects (string window_name, string object_name);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteRegObjects
//  Description   : Delete registered objects and associated
//                  restrictions.
//
//  Return        :  0 = deletion successful
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_ObjectKey
STRING l_MsgStrings[]

SELECT obj_key INTO :l_ObjectKey FROM pl_obj_reg
   WHERE app_key = :i_AppKey AND
   obj_window = :window_name AND obj_name = :object_name
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("ObjRegDelete", 1, l_MsgStrings[])
   RETURN -1
END IF

DELETE FROM pl_obj_attr WHERE app_key = :i_AppKey AND
   obj_key = :l_ObjectKey USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("ObjRegDelete", 1, l_MsgStrings[])
   RETURN -1
END IF

DELETE FROM pl_obj_reg WHERE app_key = :i_AppKey AND
   obj_window = :window_name AND obj_name = :object_name
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("ObjRegDelete", 1, l_MsgStrings[])
   RETURN -1
END IF

RETURN 0
end function

public function long fu_getusrkey (string usr_login, ref string usr_name);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetUsrKey
//  Description   : Get user profile information based on login.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_FirstName, l_LastName
LONG   l_UsrKey

SELECT usr_key, usr_fname, usr_lname 
   INTO :l_UsrKey, :l_FirstName, :l_LastName
   FROM pl_usr
   WHERE usr_login = :usr_login USING i_SecTrans;

usr_name = Trim(l_FirstName) + " " + Trim(l_LastName)

IF i_SecTrans.SQLCode <> 0 THEN
   RETURN -1
END IF

RETURN l_UsrKey
end function

public function long fu_getdbdefaultkey (long usr_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetDBDefaultKey
//  Description   : Get the user's default database connection.
//
//  Return        :  0 = default database key found
//                  -1 = security database connection failed or
//                       or no default key found
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_DBKey

SELECT usr_db_default INTO :l_DBKey FROM pl_usr
   WHERE usr_key = :usr_key USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 OR l_DBKey = 0 THEN
   RETURN -1
END IF

RETURN l_DBKey
end function

public function integer fu_beginaudit ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_BeginAudit
//  Description   : If audit of user login's are used, update the
//                  login time.
//
//  Return        :  0 = audit record updated
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_BeginTime, l_MsgStrings[]

//------------------------------------------------------------
//  Create a transaction object for generating unique keys, if
//	 One does not already exist.
//------------------------------------------------------------

IF NOT i_KeyTransConnected THEN
	i_KeyTrans            = CREATE Transaction
	i_KeyTrans.DBMS       = i_SecTrans.DBMS
	i_KeyTrans.Database   = i_SecTrans.Database
	i_KeyTrans.UserId     = i_SecTrans.UserId
	i_KeyTrans.DBPass     = i_SecTrans.DBPass
	i_KeyTrans.LogId      = i_SecTrans.LogId
	i_KeyTrans.LogPass    = i_SecTrans.LogPass
	i_KeyTrans.ServerName = i_SecTrans.ServerName
	i_KeyTrans.DBParm     = i_SecTrans.DBParm

	//-----------------------------------------------------------
	//  Connect to the security database with the key generation
	//  transaction object.  Abort initialization if connection 
	//  fails.
	//-----------------------------------------------------------

	IF fu_connect(i_KeyTrans) = -1 THEN
 		 RETURN -1
	END IF
	i_KeyTransConnected = TRUE
END IF

i_AudKey = fu_GetKey("aud_key")
IF i_AudKey <> -1 THEN
   l_BeginTime = String(Today(), "yyyy-mm-dd") + " " + String(Now(), "hh:mm")
   INSERT INTO pl_aud VALUES (:i_AudKey, :i_AppKey, :i_UsrKey,
      :l_BeginTime, '') USING i_SecTrans;

   IF i_SecTrans.SQLCode <> 0 THEN
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("AuditInsert", 1, l_MsgStrings[])
      RETURN -1
   END IF
END IF

//------------------------------------------------------------
//  Only disconnect if the KEY transaction is not needed to
//	 register objects.
//------------------------------------------------------------

IF NOT i_RegistrationMode THEN
   fu_disconnect(i_KeyTrans)
	i_KeyTransConnected = FALSE
END IF
   
RETURN 0
end function

public function integer fu_getadmdefaults ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetAdmDefaults
//  Description   : Get the administrator's default options from
//                  the preferences table.
//
//  Return        :  0 = preferences found
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

SELECT pref_app_grace, pref_app_color, pref_app_pwd_days, 
	 pref_app_use_netid, pref_app_use_audit, pref_prompt_copy, 
	 pref_prompt_delete, pref_use_encrypt, pref_app_use_login,
	 pref_date_format
   INTO :i_DefaultGrace, :i_DefaultDisableColor, :i_DefaultPWDDays,
        :i_DefaultUseNet, :i_DefaultUseAudit, :i_PromptForCopy, 
		  :i_PromptForDelete, :i_DefaultUseEncrypt, :i_DefaultUseLogin,
		  :i_DateFormat
   FROM pl_pref 
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("PrefNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF

i_DefaultUseNet     = Trim(i_DefaultUseNet)
i_DefaultUseAudit   = Trim(i_DefaultUseAudit)
i_DefaultUseEncrypt = Trim(i_DefaultUseEncrypt)
i_DefaultUseLogin   = Trim(i_DefaultUseLogin)
i_PromptForCopy     = Trim(i_PromptForCopy)
i_PromptForDelete   = Trim(i_PromptForDelete)
i_DateFormat        = Trim(i_DateFormat)

RETURN 0
end function

public function integer fu_checkoldpwd (string usr_login, string usr_pwd);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckOldPWD
//  Description   : Validates the old password when a user is
//                  attempting to change to a new password.
//
//  Return        :  0 = old password correct
//                  -1 = old password entered incorrectly
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Pwd, l_Password, l_DBInfo[], l_DBName

//------------------------------------------------------------------
//  If the user login and password are being used to login to the
//	 database, connect to the database to verify that the old 
//  password is correct.
//------------------------------------------------------------------

IF i_UseLogin THEN
	IF i_DBKey > 0 THEN
      fu_GetDBUserInfo(i_DBKey, l_DBName, l_DBInfo[], &
										 	usr_login, usr_pwd)

      i_AppTrans.DBMS       = l_DBInfo[1]
      i_AppTrans.Database   = l_DBInfo[2]
      i_AppTrans.ServerName = l_DBInfo[3]
     	i_AppTrans.UserId     = l_DBInfo[4]
     	i_AppTrans.DBPass	  = l_DBInfo[5]
     	i_AppTrans.LogId		  = l_DBInfo[6]
		i_AppTrans.LogPass	  = l_DBInfo[7]
	   i_AppTrans.DBParm     = l_DBInfo[8]
      i_AppTrans.Lock       = l_DBInfo[9]
      IF l_DBInfo[10] = "0" THEN
         i_AppTrans.AutoCommit = FALSE
      ELSE
         i_AppTrans.AutoCommit = TRUE
      END IF
           	
      IF fu_connect(i_AppTrans) <> 0 THEN
         SECCA.MSG.fu_DisplayMessage("PwdOldIncorrect")
   		RETURN -1
		ELSE
   		fu_disconnect(i_AppTrans)
			RETURN 0
		END IF
	END IF
ELSE
	IF i_UseEncrypt THEN
		l_Password = fu_EncryptPWD(usr_pwd)
	ELSE
		l_Password = usr_pwd
	END IF

	SELECT usr_pwd INTO :l_Pwd
   	FROM pl_usr WHERE usr_login = :usr_login AND usr_pwd = :l_Password
   	USING i_SecTrans;

	IF i_SecTrans.SQLCode <> 0 THEN
      SECCA.MSG.fu_DisplayMessage("PwdOldIncorrect")
   	RETURN -1
	END IF
END IF

RETURN 0
end function

public function integer fu_deleteaudit (long app_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteAudit
//  Description   : Delete all audit records for an application.
//
//  Return        :  0 = audit deletion successful
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

DELETE FROM pl_aud WHERE app_key = :app_key USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("AuditDelete", 1, l_MsgStrings[])
   RETURN -1
END IF

RETURN 0
end function

public function integer fu_setusrpwd (string usr_login, string usr_pwd);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetUsrPwd
//  Description   : Encrypt user's password before update it
//					     in the security database.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Password, l_MsgStrings[]

IF usr_pwd <> "" THEN
	IF i_UseEncrypt THEN
   	l_Password = fu_EncryptPWD(usr_pwd)
	ELSE
		l_Password = usr_pwd
	END IF
   UPDATE pl_usr SET usr_pwd = :l_Password WHERE usr_login = :usr_login
      USING i_SecTrans;
END IF

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("PwdNewUpdate", 1, l_MsgStrings[])
   RETURN -1
END IF

fu_commit()

RETURN 0
end function

public function integer fu_disconnect (transaction transaction_object);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_Disconnect
//  Description   : Disconnect from the database using the given
//                  transaction object.
//
//  Return        :  0 = disconnect successful
//                  -1 = security database connection failed or
//                       disconnection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

DISCONNECT USING transaction_object;

IF transaction_object.SQLCode <> 0 THEN
   IF transaction_object = i_SecTrans THEN
	   l_MsgStrings[1] = transaction_object.SQLErrText
      SECCA.MSG.fu_DisplayMessage("DisconnectSecurity", 1, l_MsgStrings[])   
      RETURN -1
   ELSE
		l_MsgStrings[1] = transaction_object.DBMS
	   l_MsgStrings[2] = transaction_object.SQLErrText
      SECCA.MSG.fu_DisplayMessage("DisconnectApp", 2, l_MsgStrings[])  
      RETURN -1
   END IF
END IF

RETURN 0
end function

public function boolean fu_checkregister ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckRegister
//  Description   : Check to see if an application allows 
//                  registration mode.
//
//  Return        : TRUE  = allows registration
//                  FALSE = registration not allowed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Registration

SELECT app_show_reg INTO :l_Registration FROM pl_app
   WHERE app_key = :i_AppKey
   USING i_SecTrans;
	
l_Registration = Trim(l_Registration)

IF l_Registration = "Y" THEN
   RETURN TRUE
ELSE
   RETURN FALSE
END IF

end function

public function integer fu_getadmlogin (long adm_key, ref string adm_login, ref string adm_pwd);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetAdmLogin
//  Description   : Return the administrator's login name and 
//                  password using the given admin key.
//
//  Return        :  0 = admin information found
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_DecryptPWD, l_MsgStrings[]

SELECT adm_login, adm_pwd INTO :adm_login, :l_DecryptPWD
   FROM pl_admin 
   WHERE adm_key = :adm_key
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("LoginAdmNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF

adm_login    = Trim(adm_login)
l_DecryptPWD = Trim(l_DecryptPWD)

adm_pwd = fu_DecryptPWD(l_DecryptPWD)

RETURN 0
end function

public function integer fu_setadminfo (long adm_key, string adm_pwd);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetAdminInfo
//  Description   : Encrypt administrator password before 
//						  updating it in the security database.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Password, l_MsgStrings[]

IF adm_pwd <> "" THEN
	l_Password = fu_EncryptPWD(adm_pwd)
	UPDATE pl_admin SET adm_pwd = :l_Password WHERE adm_key = :adm_key
   USING i_SecTrans;
END IF

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("PwdNewUpdate", 1, l_MsgStrings[])
   RETURN -1
END IF

fu_Commit()

RETURN 0
end function

public function integer fu_getnetid (ref string usr_login);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetNetID
//  Description   : Get Novell user id.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

UNSIGNEDINTEGER l_Rtn, l_Len = 128
BOOLEAN			 l_RtnNT	
STRING          l_UsrName, l_MsgStrings[]

l_UsrName = Space(l_Len)

ENVIRONMENT l_Env
GetEnvironment (l_Env)

CHOOSE CASE l_Env.OSType
  	CASE Windows!
		IF l_Env.OSMajorRevision = 3 THEN
			l_Rtn = wNetGetUser(l_UsrName, l_Len)
			IF l_Rtn <> 0 THEN
	      	l_MsgStrings[1] = i_SecTrans.SQLErrText
         	SECCA.MSG.fu_DisplayMessage("NetNoRetrieve", 1, l_MsgStrings[])
   			RETURN -1
			END IF
		ELSE
     		l_RtnNT = GetUserNameA(l_UsrName, l_Len)
			IF l_RtnNT <> TRUE THEN
	      	l_MsgStrings[1] = i_SecTrans.SQLErrText
         	SECCA.MSG.fu_DisplayMessage("NetNoRetrieve", 1, l_MsgStrings[])
   			RETURN -1
			END IF
		END IF
   CASE WindowsNT!
     	l_RtnNT = GetUserNameA(l_UsrName, l_Len)
		IF l_RtnNT <> TRUE THEN
	      l_MsgStrings[1] = i_SecTrans.SQLErrText
         SECCA.MSG.fu_DisplayMessage("NetNoRetrieve", 1, l_MsgStrings[])
   		RETURN -1
		END IF
END CHOOSE

usr_login = Lower(l_UsrName)

RETURN 0
end function

public function integer fu_getgrpinfo (ref long grp_key[], ref string grp_name[]);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetGrpInfo
//  Description   : Get array of groups profile information.
//
//  Return        :  number of groups
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_NumSelected
LONG    l_GrpKey
STRING  l_GrpName, l_MsgStrings[]

IF NOT i_SecurityConnected THEN
	IF fu_Connect(i_SecTrans) = -1 THEN
   	RETURN -1
	END IF
END IF

DECLARE l_grp CURSOR FOR
   SELECT grp_key, grp_name FROM pl_grp WHERE grp_key IN
      (SELECT grp_key FROM pl_grp_usr WHERE usr_key = :i_UsrKey)
      USING i_SecTrans;

OPEN l_grp;
IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("GroupListNoRetrieve", 1, l_MsgStrings[])
   CLOSE l_grp;
   RETURN -1
END IF

l_NumSelected = 0
DO
   FETCH l_grp INTO :l_GrpKey, :l_GrpName;
   IF i_SecTrans.SQLCode = 0 THEN
      l_NumSelected = l_NumSelected + 1
      grp_key[l_NumSelected] = l_GrpKey
      grp_name[l_NumSelected] = Trim(l_GrpName)
   ELSE
      IF i_SecTrans.SQLCode <> 100 THEN
	      l_MsgStrings[1] = i_SecTrans.SQLErrText
         SECCA.MSG.fu_DisplayMessage("GroupListNoRetrieve", 1, l_MsgStrings[])

         CLOSE l_grp;
         RETURN -1
      END IF
   END IF
LOOP UNTIL i_SecTrans.SQLCode <> 0

CLOSE l_grp;
IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("GroupListNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF

IF NOT i_SecurityConnected THEN
	IF fu_Disconnect(i_SecTrans) = -1 THEN
   	RETURN -1
	END IF
END IF

RETURN l_NumSelected
end function

public subroutine fu_getroleinfo (ref long role_key[], ref string role_name[]);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetRoleInfo
//  Description   : Retrieves all roles for the current user.
//
//  Parameters    : REF LONG   Role_Key[]  - Array of role keys.
//                  REF STRING Role_Name[] - Array of role names.
//
//  Return Value  : INTEGER - Number of roles.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

role_name[] = i_RoleName[]
role_key[] = i_RoleKey[]


end subroutine

public function integer fu_setusrinfo (long usr_key, string usr_pwd, long db_default);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetUsrInfo
//  Description   : Update new password for a user in the security
//				        database.
//
//  Return        :  0 = login successful
//                  -1 = login failed
//                  -2 = login failed.  Attempt again.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Password, l_MsgStrings[]

//------------------------------------------------------------------
// Encrypt the password before updating the user table in the
// security database.
//------------------------------------------------------------------

IF usr_pwd <> "" THEN
	IF i_UseEncrypt THEN
   	l_Password = fu_EncryptPWD(usr_pwd)
	ELSE
		l_Password = usr_pwd
	END IF
   UPDATE pl_usr SET usr_pwd = :l_Password WHERE usr_key = :usr_key
      USING i_SecTrans;
END IF

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("PwdNewUpdate", 1, l_MsgStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  Update the default database connection column if specified.
//------------------------------------------------------------------

IF db_default >= 0 THEN
   UPDATE pl_usr SET usr_db_default = :db_default WHERE usr_key = :usr_key
      USING i_SecTrans;
END IF

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DBUpdate", 1, l_MsgStrings[])
   RETURN -1
END IF

fu_Commit()

RETURN 0
end function

public function integer fu_checkadminloginonly (string adm_login);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckAdminLoginOnly
//  Description   : Validate the login for the administrator.
//
//  Return        :  0 = login only successful
//                  -1 = login only failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SELECT adm_key
   INTO :i_AdmKey
   FROM pl_admin WHERE adm_login = :adm_login
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
   SECCA.MSG.fu_DisplayMessage("LoginAdmEnter")
   RETURN -1
END IF

RETURN 0
end function

public function boolean fu_getobjbit (string obj_attr, integer obj_bit);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetObjBit
//  Description   : Return the bit value.
//
//  Parameters    :  STRING  obj_attr - 
//                       Attribute we are testing the bit value for
//                   INTEGER obj_bit - 
//                       Bit value to test
//
//  Return        :  BOOLEAN - FALSE to perform the following if
//                      the attribute is:
//                         Visible   - TRUE = Control visible.
//                         Enable    - TRUE = Control enabled.
//                         Add       - TRUE = Allow new records.
//                         Delete    - TRUE = Allow records to be deleted.
//                         DrillDown - TRUE = Allow user to drill down
//                                              to another control.
//                         Query     - TRUE = Allow Query mode.
//                         DragDrop  - TRUE = Allow DragDrop.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/6/98	B. Byers		Fixed a case range typo when checking for DELETE.  
//								The value was 120 to 27 - changed it to 120 to 127
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF obj_bit > 0 THEN
   CHOOSE CASE obj_bit
      CASE 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, &
			 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, &
			 61, 63, 65, 67, 69, 71, 73, 75, 77, 79, 81, 83, 85, 87, 89, &
			 91, 93, 95, 97, 99, 101, 103, 105, 107, 109, 111, 113, 115, &
			 117, 119, 121, 123, 125, 127
         IF obj_attr = "VISIBLE" THEN
            RETURN FALSE
         END IF
   END CHOOSE
   CHOOSE CASE obj_bit
      CASE 2, 3, 6, 7, 10, 11, 14, 15, 18, 19, 22, 23, 26, 27, 30, 31, &
			 34, 35, 38, 39, 42, 43, 46, 47, 50, 51, 54, 55, 58, 59, 62, &
			 63, 66, 67, 70, 71, 74, 75, 78, 79, 82, 83, 86, 87, 90, 91, &
			 94, 95, 98, 99, 102, 103, 106, 107, 110, 111, 114, 115, 118, &
			 119, 122, 123, 126, 127
         IF obj_attr = "ENABLE" THEN
            RETURN FALSE
         END IF
   END CHOOSE
   CHOOSE CASE obj_bit
      CASE 4, 5, 6, 7, 12, 13, 14, 15, 20, 21, 22, 23, 28, 29, 30, 31, &
			 36, 37, 38, 39, 44, 45, 46, 47, 52, 53, 54, 55, 60, 61, 62, 63, &
			 68, 69, 70, 71, 76, 77, 78, 79, 84, 85, 86, 87, 92, 93, 94, 95, &
			 100, 101, 102, 103, 108, 109, 110, 111, 116, 117, 118, 119, 124, &
			 125, 126, 127
         IF obj_attr = "ADD" THEN
            RETURN FALSE
         END IF
   END CHOOSE
   CHOOSE CASE obj_bit
      CASE 8 TO 15, 24 TO 31, 40 TO 47, 56 TO 63, &
			 72 TO 79, 88 TO 95, 104 TO 111, 120 TO 127
         IF obj_attr = "DELETE" THEN
            RETURN FALSE
         END IF
   END CHOOSE
   CHOOSE CASE obj_bit
      CASE 16 TO 31, 48 TO 63, 80 TO 95, 112 TO 127
         IF obj_attr = "DRILLDOWN" THEN
            RETURN FALSE
         END IF
   END CHOOSE
   CHOOSE CASE obj_bit
      CASE 32 TO 63, 96 TO 127
         IF obj_attr = "QUERYMODE" THEN
            RETURN FALSE
         END IF
   END CHOOSE
   CHOOSE CASE obj_bit
      CASE 64 TO 127
         IF obj_attr = "DRAGDROP" THEN
            RETURN FALSE
         END IF
   END CHOOSE
END IF

RETURN TRUE
end function

public function integer fu_deleteroleassign (long parent_type, long child_type, long parent_key, long child_key, long app_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteRoleAssign
//  Description   : Delete role assignments.
//
//  Return        :  0 = deletion successful
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

CHOOSE CASE parent_type
	CASE 1
		CHOOSE CASE child_type
		   CASE 2
			   DELETE FROM pl_grp_role WHERE grp_key = :Parent_Key AND role_key = :Child_Key AND app_key = :App_Key USING i_SecTrans;
		END CHOOSE
	CASE 2
		CHOOSE CASE child_type
		   CASE 2
			   DELETE FROM pl_usr_role WHERE usr_key = :Parent_Key AND role_key = :Child_Key AND app_key = :App_Key USING i_SecTrans;
		END CHOOSE
END CHOOSE

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DeleteError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function integer fu_insertprofileassign (long parent_type, long child_type, long parent_key, long child_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_InsertProfileAssign
//  Description   : Add a new profile assignment to the security
//				        database.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

CHOOSE CASE parent_type
	CASE 1
		CHOOSE CASE child_type
			CASE 2
				INSERT INTO pl_app_grp( app_key, grp_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
			CASE 3
				INSERT INTO pl_app_usr( app_key, usr_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
			CASE 4 
				INSERT INTO pl_app_db( app_key, db_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
		END CHOOSE
	CASE 2
		CHOOSE CASE child_type
			CASE 2
				INSERT INTO pl_app_grp( grp_key, app_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
			CASE 3
				INSERT INTO pl_grp_usr( grp_key, usr_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
			CASE 4 
				INSERT INTO pl_grp_db( grp_key, db_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
		END CHOOSE
	CASE 3
		CHOOSE CASE child_type
			CASE 2
				INSERT INTO pl_app_usr( usr_key, app_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
			CASE 3
				INSERT INTO pl_grp_usr( usr_key, grp_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
			CASE 4
				INSERT INTO pl_usr_db( usr_key, db_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
		END CHOOSE
   CASE 4
		CHOOSE CASE child_type
			CASE 2
				INSERT INTO pl_app_db( db_key, app_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
			CASE 3
				INSERT INTO pl_grp_db( db_key, grp_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
			CASE 4
				INSERT INTO pl_usr_db( db_key, usr_key ) VALUES (:parent_key, :child_key ) USING i_SecTrans;
		END CHOOSE
END CHOOSE

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("InsertError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function integer fu_insertroleassign (long parent_type, long child_type, long parent_key, long child_key, integer app_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_InsertRoleAssign
//  Description   : Add a role assignment to the security database.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

CHOOSE CASE parent_type
   CASE 1
		CHOOSE CASE child_type
		CASE 2
			INSERT INTO pl_grp_role( grp_key, role_key, app_key ) VALUES (:parent_key, :child_key, :App_key ) USING i_SecTrans;
		END CHOOSE
	CASE 2
		CHOOSE CASE child_type
		CASE 2
			INSERT INTO pl_usr_role( usr_key, role_key, app_key ) VALUES (:parent_key, :child_key, :App_key ) USING i_SecTrans;
		END CHOOSE

END CHOOSE

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("InsertError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function integer fu_checkadminoldpwd (string adm_login, string adm_pwd);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckAdminOldPWD
//  Description   : Validates the old password when an administrator
//                  is attempting to change to a new password.
//
//  Return        :  0 = old password correct
//                  -1 = old password entered incorrectly
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Pwd, l_Password

l_Password = fu_EncryptPWD(adm_pwd)

SELECT adm_pwd INTO :l_Pwd
   FROM pl_admin WHERE adm_login = :adm_login AND adm_pwd = :l_Password
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
   SECCA.MSG.fu_DisplayMessage("PwdOldIncorrect")
   RETURN -1
END IF

RETURN 0
end function

public function integer fu_setregobjects (string object_name, string object_desc, integer object_type, string window_name, string object_tblcol);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetRegObjects
//  Description   : Add a registered object to the object 
//						  registration table in the security database.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_ObjectKey
STRING l_MsgStrings[]

SELECT obj_key INTO :l_ObjectKey FROM pl_obj_reg WHERE app_key = :i_AppKey AND
   obj_name = :object_name AND obj_type = :object_type AND
   obj_window = :window_name
   USING i_SecTrans;

IF i_SecTrans.SQLCode = 100 THEN
   l_ObjectKey = fu_GetKey("obj_key")

   INSERT INTO pl_obj_reg VALUES (:i_AppKey, :l_ObjectKey, :window_name,
      :object_name, :object_desc, :object_type, :object_tblcol) 
      USING i_SecTrans;

   IF i_SecTrans.SQLCode <> 0 THEN
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("ObjRegInsert", 1, l_MsgStrings[])

      RETURN -1
   END IF
ELSEIF i_SecTrans.SQLCode = -1 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("ObjRegCheck", 1, l_MsgStrings[])
   RETURN -1
END IF

RETURN 0
end function

public function integer fu_deleteprofilerelates (string profile_type, integer profile_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteProfileRelates
//  Description   : Delete profile assignments from the security
//						  database whenever a profile is deleted.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

CHOOSE CASE profile_type

	CASE "app"
		DELETE FROM pl_app_grp WHERE app_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_app_usr WHERE app_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_app_db WHERE app_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_role WHERE app_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_obj_reg WHERE app_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_obj_attr WHERE app_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_grp_role WHERE app_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_usr_role WHERE app_key = :Profile_Key USING i_SecTrans;

	CASE "grp"
		DELETE FROM pl_app_grp WHERE grp_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_grp_usr WHERE grp_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_grp_db WHERE grp_key = :Profile_Key USING i_SecTrans;

	CASE "usr"
		DELETE FROM pl_app_usr WHERE usr_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_grp_usr WHERE usr_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_usr_db WHERE usr_key = :Profile_Key USING i_SecTrans;

	CASE "db"
		DELETE FROM pl_app_db WHERE db_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_grp_db WHERE db_key = :Profile_Key USING i_SecTrans;
		DELETE FROM pl_usr_db WHERE db_key = :Profile_Key USING i_SecTrans;

END CHOOSE

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DeleteError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function integer fu_deleteprofileassign (long parent_type, long child_type, long parent_key, long child_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteProfileAssign
//  Description   : Delete profile assignments.
//
//  Return        :  0 = delete successful
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

CHOOSE CASE parent_type
	CASE 1
		CHOOSE CASE child_type
		   CASE 2
			   DELETE FROM pl_app_grp WHERE app_key = :parent_key AND grp_key = :child_key USING i_SecTrans;
		   CASE 3
			   DELETE FROM pl_app_usr WHERE app_key = :parent_key AND usr_key = :child_key USING i_SecTrans;
		   CASE 4 
			   DELETE FROM pl_app_db WHERE app_key = :parent_key AND db_key = :child_key USING i_SecTrans;
		END CHOOSE
	CASE 2
		CHOOSE CASE child_type
		   CASE 2
			   DELETE FROM pl_app_grp WHERE grp_key = :parent_key AND app_key = :child_key USING i_SecTrans;
		   CASE 3
			   DELETE FROM pl_grp_usr WHERE grp_key = :parent_key AND usr_key = :child_key USING i_SecTrans;
		   CASE 4 
			   DELETE FROM pl_grp_db WHERE grp_key = :parent_key AND db_key = :child_key USING i_SecTrans;
		END CHOOSE
	CASE 3
		CHOOSE CASE child_type
		   CASE 2
			   DELETE FROM pl_app_usr WHERE usr_key = :Parent_Key AND app_key = :Child_Key USING i_SecTrans;
		   CASE 3
			   DELETE FROM pl_grp_usr WHERE usr_key = :Parent_Key AND grp_key = :Child_Key USING i_SecTrans;
		   CASE 4 
			   DELETE FROM pl_usr_db WHERE usr_key = :Parent_Key AND db_key = :Child_Key USING i_SecTrans;
		   END CHOOSE
	CASE 4
		CHOOSE CASE child_type
		   CASE 2
			   DELETE FROM pl_app_db WHERE db_key = :Parent_Key AND app_key = :Child_Key USING i_SecTrans;
		   CASE 3
			   DELETE FROM pl_grp_db WHERE db_key = :Parent_Key AND grp_key = :Child_Key USING i_SecTrans;
		   CASE 4
			   DELETE FROM pl_usr_db WHERE db_key = :Parent_Key AND usr_key = :Child_Key USING i_SecTrans;
		END CHOOSE

END CHOOSE

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DeleteError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function integer fu_deleterolerelates (integer role_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteRolesRelates
//  Description   : Delete role assignments from the security
//						  database whenever a role is deleted.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

DELETE FROM pl_grp_role WHERE role_key = :Role_Key USING i_SecTrans;
DELETE FROM pl_usr_role WHERE role_key = :Role_Key USING i_SecTrans;
DELETE FROM pl_obj_attr WHERE role_key = :Role_Key USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DeleteError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function integer fu_checkpwdencrypt ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckPwdEncrypt
//  Description   : Get the password encryption option from
//                  the preferences table.
//
//  Return        :  0 = preferences found
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

SELECT pref_use_encrypt
   INTO :i_DefaultUseEncrypt
   FROM pl_pref 
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("PrefNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF

i_DefaultUseEncrypt = Trim(i_DefaultUseEncrypt)

IF i_DefaultUseEncrypt = 'Y' THEN
	i_UseEncrypt = TRUE
ELSE
	i_UseEncrypt = FALSE
END IF

RETURN 0
end function

public function integer fu_insertadminassign (integer parent_key, integer child_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_InsertAdminAssign
//  Description   : Add an admin assignment to the security database.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

INSERT INTO pl_admin_admrole( adm_key, admrole_key ) VALUES (:parent_key, :child_key) USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("InsertError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function integer fu_deleteadminassign (integer parent_key, integer child_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteAdminAssign
//  Description   : Delete an administrator assignment from the 
//						  security database.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

DELETE FROM pl_admin_admrole WHERE adm_key = :parent_key AND admrole_key = :child_key USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DeleteError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function integer fu_checkadminroles (integer adm_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckAdminRoles
//  Description   : Retrieve a list of roles for an administrator.
//
//  Return        :  0 = old password correct
//                  -1 = old password entered incorrectly
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING	l_admrole_name, l_MsgStrings[]

SELECT pl_admrole.admrole_name INTO :l_admrole_name		 
        FROM pl_admin, pl_admin_admrole, pl_admrole 		 
        WHERE (pl_admin.adm_key = pl_admin_admrole.adm_key ) and
				(pl_admrole.admrole_key = pl_admin_admrole.admrole_key) and
				( pl_admin.adm_key = :adm_key ) using i_SecTrans;


IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("RolesAdmNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF
end function

public function integer fu_deleteobjrestrict (integer app_key, integer obj_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteObjRestrict
//  Description   : Delete object restrictions from the security
//						  database whenever an object is deleted.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

DELETE FROM pl_obj_attr WHERE obj_key = :Obj_Key AND app_key = :App_Key USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DeleteError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF

end function

public function integer fu_setusrstatus (integer status, string usr_login);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetUsrStatus
//  Description   : Update user's status in the security database.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_UsrKey
STRING l_MsgStrings[]

SELECT usr_key INTO :l_UsrKey FROM pl_usr WHERE usr_login = :usr_login
   USING i_SecTrans;

IF i_SecTrans.SQLCode = 0 THEN
   UPDATE pl_usr SET usr_status = :status WHERE usr_key = :l_UsrKey
      USING i_SecTrans;

   IF i_SecTrans.SQLCode <> 0 THEN
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("UserStatusUpdate", 1, l_MsgStrings[])
      RETURN -1
   ELSE
      fu_Commit()
   END IF
END IF

RETURN 0
end function

public function integer fu_checkadmin (string adm_login, string adm_pwd);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckAdmin
//  Description   : Validate the login and password for the
//                  administrator.
//
//  Return        :  0 = login successful
//                  -1 = login failed
//                  -2 = login failed.  Attempt again.
//				        -3 = Expired admin
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

STRING  	l_MsgStrings[], l_Password, l_Expire, l_Today, l_Year
STRING   l_Month, l_Day
INTEGER	l_Status
DATE     l_Date

IF SECCA.MGR.i_AdmUseLogin = "Y" AND i_SecTrans.UserID = adm_login THEN
	SELECT adm_key, adm_name, adm_prompt_copy, adm_prompt_delete, &
			 adm_status, adm_grace, adm_expire_date
	  INTO :i_AdmKey, :i_AdminName, :i_PromptForCopy, &
			 :i_PromptForDelete, :l_Status, :i_GraceAttempts, :l_Expire 	
     FROM pl_admin WHERE adm_login = :adm_login
    USING i_SecTrans;
ELSE
	l_Password = fu_EncryptPWD(adm_pwd)
	SELECT adm_key, adm_name, adm_prompt_copy, adm_prompt_delete, &
		 	 adm_status, adm_grace, adm_expire_date
     INTO :i_AdmKey, :i_AdminName, :i_PromptForCopy, &
		    :i_PromptForDelete, :l_Status, :i_GraceAttempts, :l_Expire 	
     FROM pl_admin WHERE adm_login = :adm_login AND adm_pwd = :l_Password
    USING i_SecTrans;
END IF

IF i_SecTrans.SQLCode <> 0 THEN
   IF i_SecTrans.SQLCode = 100 THEN
      SECCA.MSG.fu_DisplayMessage("LoginAdmInvalid")
      RETURN -2
   ELSE
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("AdmNoRetrieve", 1, l_MsgStrings[])
      RETURN -1
   END IF
END IF

i_AdminName       = Trim(i_AdminName)
i_PromptForCopy   = Trim(i_PromptForCopy)
i_PromptForDelete = Trim(i_PromptForDelete)
l_Expire          = Trim(l_Expire)

IF l_Status = 0 THEN
   SECCA.MSG.fu_DisplayMessage("LoginInactive")
  	RETURN -2
END IF

IF l_Expire <> "" THEN
	l_Date = Today()
	
	l_Year = String(Year(l_Date))
	
	l_Month = String(Month(l_Date))
	IF Len(l_Month) = 1 THEN
		l_Month = "0" + l_Month
	END IF
	
	l_Day = String(Day(l_Date))
	IF Len(l_Day) = 1 THEN
		l_Day = "0" + l_Day
	END IF
	
	l_Today = l_Year + l_Month + l_Day
	IF Long(l_Expire) < Long(l_Today) THEN

		//----------------------------------------------
		// If the password has expired, set the status
		// to two and display the message.
		//----------------------------------------------

		UPDATE	"pl_admin"
		SET		"adm_status" = 2
		WHERE		("pl_admin"."adm_login" = :adm_login) AND
					("pl_admin"."adm_pwd" = :l_Password)
		USING		i_SecTrans ;
      SECCA.MSG.fu_DisplayMessage("LoginExpired")

     	RETURN -3
  	END IF
END IF

//---------------------------------------------------
// Although the expiration date has expired they may
// have back dated their computer so do this check
// before we leaving.
//---------------------------------------------------
IF l_Status = 2 THEN
	SECCA.MSG.fu_DisplayMessage("LoginExpired")
	Return -3
END IF

RETURN 0

end function

public function integer fu_buildsearch (datawindow searchdw, string searchcriteria);//******************************************************************
//  PO Module     : n_secca_mgr
//  Function      : fu_BuildSearch
//  Description   : Extends the WHERE clause of a SQL Select 
//                  to restrict row retrieval.
//
//  Parameters    : DATAWINDOW SearchDW -
//                     The DataWindow which to apply the filter.
//						  STRING -	 SearchCriteria -
//							  The search criteria to be added to the 
//							  WHERE clause of the DataWindow. 	
//
//  Return Value  : 0 = build OK   -1 = validation error
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_GroupByPos, l_OrderByPos
STRING   l_GroupBy, l_OrderBy, l_Return, l_Concat, l_NewSelect
STRING   l_MsgStrings[]

l_NewSelect = SearchDW.Describe("datawindow.table.select")

//------------------------------------------------------------------
//  If the SQL statement for this DataWindow does not currently
//  have a WHERE clause, then we need to add one.  If it already
//  does have a WHERE clause, we will just concatenate additional
//  criteria to it.
//------------------------------------------------------------------

IF Pos(Upper(l_NewSelect), "PBSELECT") > 0 THEN
	RETURN 0
END IF

IF Pos(Upper(l_NewSelect), "WHERE") = 0 THEN
   l_Concat = " WHERE "
ELSE
   l_Concat = " AND "
END IF

//------------------------------------------------------------------
//  See if we have an "GROUP BY" clause and remove it from the
//  select statement for the time being.
//------------------------------------------------------------------

l_GroupBy    = ""
l_GroupByPos = Pos(Upper(l_NewSelect), "GROUP BY")
IF l_GroupByPos > 0 THEN
   l_GroupBy   = " " + Mid(l_NewSelect, l_GroupByPos)
   l_NewSelect = Mid(l_NewSelect, 1, l_GroupByPos - 1)
ELSE

   //---------------------------------------------------------------
   //  See if we have an "ORDER BY" clause and remove it from the
   //  select statement for the time being.
   //---------------------------------------------------------------

   l_OrderBy    = ""
   l_OrderByPos = Pos(Upper(l_NewSelect), "ORDER BY")
   IF l_OrderByPos > 0 THEN
      l_OrderBy   = " " + Mid(l_NewSelect, l_OrderByPos)
      l_NewSelect = Mid(l_NewSelect, 1, l_OrderByPos - 1)
   END IF
END IF

//------------------------------------------------------------------
//  Add the snippet of SQL generated by the this object to our new 
//  SQL statement.
//------------------------------------------------------------------

l_NewSelect = l_NewSelect + l_Concat + "(" + SearchCriteria + ")"


//------------------------------------------------------------------
//  Stuff the parameter with the completed SQL statement.
//------------------------------------------------------------------

l_NewSelect = "datawindow.table.select='" + &
              fu_QuoteChar(l_NewSelect, "'") + &
              fu_QuoteChar(l_GroupBy, "'")   + &
              fu_QuoteChar(l_OrderBy, "'")   + "'"
l_Return = SearchDW.Modify(l_NewSelect)

IF l_Return = "" THEN
	RETURN 0
ELSE
	l_MsgStrings[1] = SearchDW.ClassName()
	l_MsgStrings[2] = l_NewSelect
   SECCA.MSG.fu_DisplayMessage("DWModifyWhere", 2, l_MsgStrings[])  
   RETURN -1
END IF
end function

public function string fu_quotechar (string fix_string, string quote_chr);//******************************************************************
//  PO Module     : n_secca_mgr
//  Function      : fu_QuoteChar
//  Description   : Adds the PowerBuilder escape character ("~")
//                  to prevent PowerBuilder from doing special
//                  interpetion of the character specifed by
//                  Quote_Chr.
//
//  Parameters    : STRING Fix_String -
//                     The string that needs to be quoted.
//
//                  STRING Quote_Chr
//                     The character to be quoted.
//
//  Return Value  : STRING -
//                     The result of the quoting operation.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_Quoted
INTEGER  l_QuotePos,   l_StartPos, l_Idx
STRING   l_QuotedChar, l_FixedStr, l_TmpChar

//------------------------------------------------------------------
//  See if there are any characters to be quoted in Fix_String.
//  If there are not, then we can just return Fix_String.
//------------------------------------------------------------------

l_QuotePos = Pos(Fix_String, Quote_Chr)
IF l_QuotePos = 0 THEN
   l_FixedStr = Fix_String
   GOTO Finished
END IF

//------------------------------------------------------------------
//  For every character to be quoted in Fix_String, we need to
//  precede it with the PowerBuilder quote character (~), if it
//  has not already been quoted.
//------------------------------------------------------------------

l_FixedStr   = ""
l_StartPos   = 1
l_QuotedChar = "~~" + Quote_Chr

DO WHILE l_QuotePos > 0

   //---------------------------------------------------------------
   //  We found a character that needs to be quoted.  Make sure
   //  that it is not already quoted.
   //---------------------------------------------------------------

   l_Quoted = FALSE
   IF l_QuotePos > 1 THEN
      l_Idx     = l_QuotePos - 1
      l_TmpChar = Mid(Fix_String, l_Idx, 1)

      DO WHILE l_TmpChar = "~~"
         l_Quoted = (NOT l_Quoted)
         l_Idx    = l_Idx - 1
         IF l_Idx > 0 THEN
            l_TmpChar = Mid(Fix_String, l_Idx, 1)
         ELSE
            l_TmpChar = ""
         END IF
      LOOP
   END IF

   //---------------------------------------------------------------
   //  If the character has not already been quoted, then add
   //  the string and the quoted character.
   //---------------------------------------------------------------

   IF NOT l_Quoted THEN
      l_FixedStr = l_FixedStr +                   &
                   Mid(Fix_String, l_StartPos,    &
                       l_QuotePos - l_StartPos) + &
                   l_QuotedChar
      l_StartPos = l_QuotePos + 1
   END IF

   //---------------------------------------------------------------
   //  Find the next character to be quoted.
   //---------------------------------------------------------------

   l_QuotePos = Pos(Fix_String, Quote_Chr, l_QuotePos + 1)
LOOP

//------------------------------------------------------------------
//  Add what remains of the string after the last quoted character.
//------------------------------------------------------------------

l_FixedStr = l_FixedStr + Mid(Fix_String, l_StartPos)

Finished:

RETURN l_FixedStr
end function

public function integer fu_deleteadminrelates (integer adm_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteAdminRelates
//  Description   : Delete administrator assignments from the 
//						  security database whenever a profile is deleted.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  09/02/98 J. Peiffer Added delete of optional pl_admin_app rows
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

DELETE FROM pl_admin_admrole WHERE adm_key = :adm_Key USING i_SecTrans;
IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DeleteError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF

//
// Delete any existing Admin Application assignment rows
//
DELETE FROM pl_admin_app WHERE adm_key = :adm_Key USING i_SecTrans;
IF i_SecTrans.SQLCode <> 0 THEN
	//
	// Some DBMS' will return 100 on a DELETE not found condition
	//
	IF i_SecTrans.SQLCode = 100 THEN
		RETURN 0
	END IF
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DeleteError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF

end function

public function integer fu_changeusrpwds ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_ChangeUsrPwds
//  Description   : Encrypt or decrypt all user passwords whenever
//						  the preference option is changed.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER	l_Idx, l_NumRows	
LONG    	l_UsrKey[]
STRING  	l_UsrPwd[], l_MsgStrings[]

DECLARE l_usr CURSOR FOR
   SELECT usr_key, usr_pwd FROM pl_usr USING i_SecTrans;

OPEN l_usr;
IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("UserListNoRetrieve", 1, l_MsgStrings[])
   CLOSE l_usr;
   RETURN -1
END IF

DO UNTIL i_SecTrans.SQLCode <> 0
	l_Idx++
   FETCH l_usr INTO :l_UsrKey[l_Idx], :l_UsrPwd[l_Idx];
   IF i_SecTrans.SQLCode = 0 THEN
		IF i_DefaultUseEncrypt = 'Y' THEN
			l_UsrPwd[l_Idx] = fu_EncryptPwd(Trim(l_UsrPwd[l_Idx]))
		ELSE
			l_UsrPwd[l_Idx] = fu_DecryptPwd(Trim(l_UsrPwd[l_Idx]))
		END IF

   ELSE
      IF i_SecTrans.SQLCode <> 100 THEN
	      l_MsgStrings[1] = i_SecTrans.SQLErrText
         SECCA.MSG.fu_DisplayMessage("UserListNoRetrieve", 1, l_MsgStrings[])

         CLOSE l_usr;
         RETURN -1
      END IF
   END IF
LOOP 

l_NumRows = l_Idx - 1

FOR l_Idx = 1 to l_NumRows
  	UPDATE pl_usr SET usr_pwd = :l_UsrPwd[l_Idx] WHERE usr_key = :l_usrkey[l_Idx]
     	USING i_SecTrans;

	IF i_SecTrans.SQLCode <> 0 THEN
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("PwdNewUpdate", 1, l_MsgStrings[])
  		RETURN -1
	END IF
END FOR

CLOSE l_usr;
IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("UserListNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF

RETURN 0
end function

public function string fu_encryptpwd (string password);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_EncryptPWD
//  Description   : Encrypt the given password.
//
//  Return        :  STRING - Encrypted string
//
//  Change History:
//
//  Date     Person       Description of Change
//  -------- ------------ --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING    l_TempString, l_Work, l_EncryptPass, l_DecryptString, l_EncryptString
INTEGER   l_Length, l_Position, l_Multiplier, l_Offset, l_Count

l_TempString = Lower (password)


//-------------------------------------------------------------------
//	"powerlock" is the default password for logging in to the
// security administration program and "changeme" is the default for
// application users, so they do not need to be encrypted. 
//-------------------------------------------------------------------

IF l_TempString <> "powerlock" AND l_TempString <> "changeme" THEN
	
   l_DecryptString = ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ" + &
                     "[\]^_`abcdefghijklmnopqrstuvwxyz{|}~~"
	l_EncryptString = "~~{[}u;Ce83KX%:VIm!|gs]_aL-QEOpx<UlzZjBq6#1($\" + '"' + &
                     "FS5H0'cM&>Po.NGA*Jr)Y Dv/t9kd?^fni,hR2Wy=`+4T@7wb"

   l_Length = Len (password)

   IF 1 <= l_Length AND l_Length <= 3 THEN
      l_Multiplier = 1
   ELSEIF 4 <= l_Length AND l_Length <= 6 THEN
      l_Multiplier = 2
   ELSEIF 7 <= l_Length AND l_Length <= 9 THEN
      l_Multiplier = 3
   ELSE
      l_Multiplier = 4
   END IF

   l_EncryptPass = ""

   FOR l_Count = 1 TO l_Length
      l_Offset = l_Count * l_Multiplier
      l_Work = Mid (password, l_Count, 1)
      l_Position = Pos (l_DecryptString, l_Work)
      l_Position = l_Position + l_Offset
      l_Position = Mod (l_Position, 95)
      l_Position++
      l_Work = Mid (l_EncryptString, l_Position, 1)
      l_EncryptPass = l_EncryptPass + l_Work
      IF 1 <= l_Multiplier AND l_Multiplier <= 3 THEN
         l_Multiplier++
      ELSE
         l_Multiplier = 1
      END IF
   NEXT

ELSE

   RETURN l_TempString

END IF

RETURN l_EncryptPass
end function

public function string fu_decryptpwd (string password);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DecryptPWD
//  Description   : Decrypt the given password.
//
//  Return        :  STRING - Decrypted string
//
//  Change History:
//
//  Date     Person       Description of Change
//  -------- ------------ --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING    l_TempString, l_Work, l_DecryptPass, l_DecryptString, l_EncryptString
INTEGER   l_Length, l_Position, l_Multiplier, l_Offset, l_Count

l_TempString = Lower (password)

//-------------------------------------------------------------------
//	"powerlock" is the default password for logging in to the
// security administration program and "changeme" is the default for
// application users, so they do not need to be decrypted. 
//-------------------------------------------------------------------

IF l_TempString <> "powerlock" AND l_TempString <> "changeme" THEN
	
   l_DecryptString = ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ" + &
                     "[\]^_`abcdefghijklmnopqrstuvwxyz{|}~~"
	l_EncryptString = "~~{[}u;Ce83KX%:VIm!|gs]_aL-QEOpx<UlzZjBq6#1($\" + '"' + &
                     "FS5H0'cM&>Po.NGA*Jr)Y Dv/t9kd?^fni,hR2Wy=`+4T@7wb"

   l_Length = Len (password)

   IF 1 <= l_Length AND l_Length <= 3 THEN
      l_Multiplier = 1
   ELSEIF 4 <= l_Length AND l_Length <= 6 THEN
      l_Multiplier = 2
   ELSEIF 7 <= l_Length AND l_Length <= 9 THEN
      l_Multiplier = 3
   ELSE
      l_Multiplier = 4
   END IF

   l_DecryptPass = ""

   FOR l_Count = 1 TO l_Length
      l_Offset = l_Count * l_Multiplier
      l_Work = Mid (password, l_Count, 1)
      l_Position = Pos (l_EncryptString, l_Work)
      l_Position = l_Position - l_Offset
      l_Position --
      DO WHILE l_Position <= 0
         l_Position = 95 + l_Position
      LOOP
      l_Work = Mid (l_DecryptString, l_Position, 1)
      l_DecryptPass = l_DecryptPass + l_Work
      IF 1 <= l_Multiplier AND l_Multiplier <= 3 THEN
         l_Multiplier++
      ELSE
         l_Multiplier = 1
      END IF
   NEXT

ELSE

   RETURN l_TempString

END IF

RETURN l_DecryptPass
end function

public function integer fu_changedbpwds ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_ChangeDBPwds
//  Description   : Encrypt or decrypt all db passwords whenever
//						  the preference option is changed.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumRows
LONG    l_DBKey[]
STRING  l_DBPwd[], l_LogPwd[], l_MsgStrings[]

DECLARE l_db CURSOR FOR
   SELECT db_key, db_dbpass, db_logpass FROM pl_db USING i_SecTrans;

OPEN l_db;
IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DBListNoRetrieve", 1, l_MsgStrings[])
   CLOSE l_db;
   RETURN -1
END IF

DO UNTIL i_SecTrans.SQLCode <> 0
	l_Idx++
   FETCH l_db INTO :l_DBKey[l_Idx], :l_DBPwd[l_Idx], :l_LogPwd[l_Idx];
   IF i_SecTrans.SQLCode = 0 THEN
		IF i_DefaultUseEncrypt = 'Y' THEN
			l_DBPwd[l_Idx] = fu_EncryptPwd(Trim(l_DBPwd[l_Idx]))
			l_LogPwd[l_Idx] = fu_EncryptPwd(Trim(l_LogPwd[l_Idx]))
		ELSE
			l_DBPwd[l_Idx] = fu_DecryptPwd(Trim(l_DBPwd[l_Idx]))
			l_LogPwd[l_Idx] = fu_DecryptPwd(Trim(l_LogPwd[l_Idx]))
		END IF

   ELSE
      IF i_SecTrans.SQLCode <> 100 THEN
	      l_MsgStrings[1] = i_SecTrans.SQLErrText
         SECCA.MSG.fu_DisplayMessage("DBListNoRetrieve", 1, l_MsgStrings[])

         CLOSE l_db;
         RETURN -1
      END IF
   END IF
LOOP 

l_NumRows = l_Idx - 1

FOR l_Idx = 1 TO l_NumRows
	UPDATE pl_db SET db_dbpass = :l_dbPwd[l_Idx], &
		db_logpass = :l_LogPwd[l_Idx] &
		WHERE db_key = :l_dbkey[l_Idx] USING i_SecTrans;

	IF i_SecTrans.SQLCode <> 0 THEN
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("PwdNewUpdate", 1, l_MsgStrings[])
		RETURN -1
	END IF
END FOR

CLOSE l_db;
IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DBListNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF

RETURN 0
end function

public function integer fu_buildfilter (ref datawindow filterdw, string filtercriteria);//******************************************************************
//  PO Module     : n_secca_mgr
//  Function      : fu_BuildFilter
//  Description   : Extends the filter clause of a DataWindow
//                  to restrict row retrieval.
//
//  Parameters    : DATAWINDOW FilterDW -
//                     The DataWindow which to apply the filter.
//						  STRING -	 FilterCriteria -
//							  The filter to be applied to the datawindow. 		
//
//  Return Value  : 0 = build OK   -1 = validation error
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_GroupByPos, l_OrderByPos
STRING   l_GroupBy, l_OrderBy, l_Return, l_Concat, l_NewFilter
STRING   l_MsgStrings[]

l_NewFilter = FilterDW.Describe("datawindow.table.filter")
IF l_NewFilter = "?" THEN
   l_NewFilter = ""
END IF

l_Concat = ""
IF l_NewFilter <> "" THEN
   l_Concat = " AND "
END IF

//------------------------------------------------------------------
//  Add the snippet generated by the this object to our new 
//  filter statement.
//------------------------------------------------------------------

l_NewFilter = l_NewFilter + l_Concat + "(" + FilterCriteria + ")"

//------------------------------------------------------------------
//  Stuff the parameter with the completed filter statement.
//------------------------------------------------------------------

l_NewFilter = 'datawindow.table.filter="' + l_NewFilter + '"'
l_Return = FilterDW.Modify(l_NewFilter)

IF l_Return = "" THEN
	RETURN 0
ELSE
	l_MsgStrings[1] = FilterDW.ClassName()
	l_MsgStrings[2] = l_NewFilter
   SECCA.MSG.fu_DisplayMessage("DWModifyFilter", 2, l_MsgStrings[])   
   RETURN -1
END IF
end function

public function integer fu_endaudit ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_EndAudit
//  Description   : If login auditing is on, update the time when
//                  the user logs off.
//
//  Return        :  0 = audit update successful
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_EndTime, l_MsgStrings[]
INTEGER	l_Return

IF NOT i_SecurityConnected THEN
	IF fu_connect(i_SecTrans) = -1 THEN
   	l_Return = -1
	END IF
	i_SecurityConnected = TRUE
END IF

l_EndTime = String(Today(), "yyyy-mm-dd") + " " + String(Now(), "hh:mm")
UPDATE pl_aud SET aud_end_time = :l_EndTime WHERE aud_key = :i_AudKey
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
   RETURN -1
END IF

IF fu_disconnect(i_SecTrans) = -1 THEN
	RETURN -1	
END IF

i_SecurityConnected = FALSE






   
RETURN 0
end function

public subroutine fu_debug ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_Debug
//  Description   : Prevent the register button's timer from being
//                  being turned on under registration mode.
//
//  Return        : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_DebugMode = TRUE
end subroutine

public function integer fu_setplaceholder (string window_name, string object_name);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetPlaceHolder
//  Description   : Check to see if the object has been registered.
//                  If it has been, make sure that its object type
//                  is negative.
//
//  Parameters    : STRING Window_Name - 
//                            The name of the window.
//                  STRING Object_Name -
//                            The name of the object.
//
//  Return        :   0 = object is now a place holder
//                  100 = object not found
//                   -1 = error
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1996.  All Rights Reserved.
//******************************************************************

LONG l_ObjectKey, l_ObjectType
STRING l_MsgStrings[]

SELECT obj_key, obj_type INTO :l_ObjectKey, :l_ObjectType 
   FROM pl_obj_reg WHERE app_key = :i_AppKey AND
   obj_window = :window_name AND obj_name = :object_name
   USING i_SecTrans;

CHOOSE CASE i_SecTrans.SQLCode
   CASE 100

      //------------------------------------------------------------
      //  The object has not been registered.
      //------------------------------------------------------------
		
      RETURN 100
   CASE 0
		
      //------------------------------------------------------------
      //  Change the object type to negative.
      //------------------------------------------------------------
		
		IF l_ObjectType > 0 THEN
		   l_ObjectType = l_ObjectType * -1
		
		   UPDATE pl_obj_reg SET obj_type = :l_ObjectType 
		      WHERE obj_key = :l_ObjectKey
		      USING i_SecTrans;
			
		   IF i_SecTrans.SQLCode <> 0 THEN
	         l_MsgStrings[1] = i_SecTrans.SQLErrText
            SECCA.MSG.fu_DisplayMessage("ObjRegChange", 1, l_MsgStrings[])
		      RETURN -1
         END IF
		END IF
		RETURN 0
   CASE ELSE
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("ObjRegChange", 1, l_MsgStrings[])
      RETURN -1
END CHOOSE
end function

public function integer fu_securedwobj (datawindow security_dw, string security_object, boolean invisible, boolean disable, boolean expression, string exp_value, string color_value, string exp_orig);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SecureDWObj
//  Description   : Apply the restrictions to the given datawinodow
//                  object.
//
//  Parameters    : DATAWINDOW Security_Dw -
//                     The datawindow control.
//                  STRING Security_Obj - 
//                     The datawindow object to secure.
//						  BOOLEAN Invisible -
//							  Make the object invisible.
//                  BOOLEAN Disable -
//                     Disable the object.
//                  BOOLEAN Expression -
//                     Use the expression.
//                  STRING Exp_Value -
//                     The expression to use.
//                  STRING Color_Value -
//                     The original background color.
//                  STRING Exp_Orig -
//                     The original visible or protect expression.
//
//  Return        :  0 = restrictions successfully applied
//                  -1 = an error occured
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Return, l_ObjectType, l_If, l_Visible, l_Protect, l_Color

//------------------------------------------------------------------
//  Determine the type of the datawindow object.
//------------------------------------------------------------------

l_ObjectType = Security_DW.Describe(Security_Object + ".Type")
												
//------------------------------------------------------------------
//  Prepare to build up an "IF" expression.
//------------------------------------------------------------------

IF Expression THEN
	l_If = "if("
	l_Visible = ", 0, " + Exp_Orig + ")"
	l_Protect = ", 1, " + Exp_Orig + ")"	
	l_Color = ", " + String(i_DisableColor) + ", " + Color_Value + ")"
END IF

//------------------------------------------------------------------
//  Apply the appropriate restriction.
//------------------------------------------------------------------

IF Invisible THEN
	IF Expression THEN
		l_Return = Security_Dw.Modify(Security_Object + &
		                              ".visible=~"1~t" + &
									         l_If + Exp_Value + l_Visible + &
												"~"")
	ELSE
		IF l_ObjectType <> "text" AND l_ObjectType <> "compute" THEN
         l_Return = Security_Dw.Modify(Security_Object + &
			                              ".protect=1 " + &
                                       Security_Object + &
													".visible=0")
		ELSE
         l_Return = Security_Dw.Modify(Security_Object + &
			                              ".visible=0")
		END IF
	END IF
ELSE
	IF l_ObjectType <> "text" AND l_ObjectType <> "compute" THEN
		IF Expression THEN
			l_Return = Security_Dw.Modify(Security_Object + &
			                              ".protect=~"0~t" + &
										         l_If + Exp_Value + l_Protect + &
													"~"")
		ELSE
         l_Return = Security_Dw.Modify(Security_Object + &
			                              ".protect=1")
		END IF
	END IF
   IF i_DisableColor >= 0 THEN
		IF Expression THEN
         l_Return = Security_Dw.Modify(Security_Object + &
		                                 ".background.color=~"0~t" + &
									            l_If + Exp_Value + l_Color + "~"")
		ELSE
         l_Return = Security_Dw.Modify(Security_Object + &
		                                 ".background.color=" + &
								               String(i_DisableColor))
		END IF
   END IF
END IF

IF l_Return <> "!" THEN
   RETURN 0
ELSE
	RETURN -1
END IF
end function

public function string fu_buildobjname (powerobject object_name);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_BuildObjName
//  Description   : Builds up the fully qualified object name of the
//                  given object.
//
//  Parameters    : POWEROBJECT Object_Name-
//                     The object to build the name from. 		
//
//  Return Value  : STRING - the object name.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1996.  All Rights Reserved.
//******************************************************************

POWEROBJECT l_PO
STRING l_ObjectName, l_Period
BOOLEAN l_Done

l_PO = Object_Name
l_Done = FALSE
l_ObjectName = ""
l_Period = ""
DO WHILE NOT l_Done
	l_ObjectName = l_PO.ClassName() + l_Period + l_ObjectName
	l_PO = l_PO.GetParent()
	l_Period = "."
	IF NOT IsValid(l_PO) THEN
		l_Done = TRUE
	ELSEIF l_PO.TypeOf() = Window! THEN
		l_Done = TRUE
	END IF
LOOP

RETURN l_ObjectName
end function

public function boolean fu_checkadd (window security_window, datawindow security_dw);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckAdd
//  Description   : Indicates whether the user can add new rows into
//                  the specified DataWindow.
//
//  Parameters    : WINDOW     Security_Window - 
//                     the current window.
//                  DATAWINDOW Security_DW     - 
//                     the current DataWindow.
//
//  Return Value  : BOOLEAN - Indicates if this DataWindow has
//                            add (insert) capability for this user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN    l_Add
STRING     l_WindowName, l_DWName
LONG       l_Row, l_ObjectBit

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN TRUE
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_DWName = fu_BuildObjName(Security_DW)

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_DWName + "'", 1, RowCount())
IF l_Row > 0 THEN
	l_ObjectBit = GetItemNumber(l_Row, "obj_bit")
	l_Add = fu_GetObjBit("ADD", l_ObjectBit)
ELSE
	l_Add = TRUE
END IF

RETURN l_Add
end function

public function boolean fu_checkdelete (window security_window, datawindow security_dw);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckDelete
//  Description   : Indicates whether the user can delete rows from
//                  the specified DataWindow.
//
//  Parameters    : WINDOW     Security_Window - Current window.
//                  DATAWINDOW Security_DW     - Current DataWindow.
//
//  Return Value  : BOOLEAN - Indicates if this DataWindow has
//                            delete capability for this user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN    l_Delete
STRING     l_WindowName, l_DWName
LONG       l_Row, l_ObjectBit

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN TRUE
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_DWName = fu_BuildObjName(Security_DW)

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_DWName + "'", 1, RowCount())
IF l_Row > 0 THEN
	l_ObjectBit = GetItemNumber(l_Row, "obj_bit")
	l_Delete = fu_GetObjBit("DELETE", l_ObjectBit)
ELSE
	l_Delete = TRUE
END IF

RETURN l_Delete
end function

public function boolean fu_checkdragdrop (window security_window, dragobject security_obj);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckDragDrop
//  Description   : Indicates whether the user can perform drag &
//                  drop operations on the specified control.
//
//  Parameters    : WINDOW     Security_Window - Current window.
//                  DRAGOBJECT Security_Obj    - Current control.
//
//  Return Value  : BOOLEAN - Indicates if this control has
//                            drag drop capability for this user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN    l_DragDrop
STRING     l_WindowName, l_ObjName
LONG       l_Row, l_ObjectBit

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN TRUE
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_ObjName = fu_BuildObjName(Security_Obj)

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_ObjName + "'", 1, RowCount())
IF l_Row > 0 THEN
	l_ObjectBit = GetItemNumber(l_Row, "obj_bit")
	l_DragDrop = fu_GetObjBit("DRAGDROP", l_ObjectBit)
ELSE
	l_DragDrop = TRUE
END IF

RETURN l_DragDrop
end function

public function boolean fu_checkdrilldown (window security_window, datawindow security_dw);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckDrillDown
//  Description   : Indicates whether the user can drill down to
//                  another object by selecting a record from
//                  the specified DataWindow.
//
//  Parameters    : WINDOW     Security_Window - Current window.
//                  DATAWINDOW Security_DW     - Current DataWindow.
//
//  Return Value  : BOOLEAN - Indicates if this DataWindow has
//                            drill down capability for this user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN    l_DrillDown
STRING     l_WindowName, l_DWName
LONG       l_Row, l_ObjectBit

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN TRUE
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_DWName = fu_BuildObjName(Security_DW)

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_DWName + "'", 1, RowCount())
IF l_Row > 0 THEN
	l_ObjectBit = GetItemNumber(l_Row, "obj_bit")
	l_DrillDown = fu_GetObjBit("DRILLDOWN", l_ObjectBit)
ELSE
	l_DrillDown = TRUE
END IF

RETURN l_DrillDown  
end function

public function boolean fu_checkquerymode (window security_window, datawindow security_dw);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckQueryMode
//  Description   : Indicates whether the user can use the
//                  the specified DataWindow in query mode.
//
//  Parameters    : WINDOW     Security_Window - Current window.
//                  DATAWINDOW Security_DW     - Current DataWindow.
//
//  Return Value  : BOOLEAN - Indicates if this DataWindow has
//                            query mode capability for this user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN    l_QueryMode
STRING     l_WindowName, l_DWName
LONG       l_Row, l_ObjectBit

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN TRUE
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_DWName = fu_BuildObjName(Security_DW)

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_DWName + "'", 1, RowCount())
IF l_Row > 0 THEN
	l_ObjectBit = GetItemNumber(l_Row, "obj_bit")
	l_QueryMode = fu_GetObjBit("QUERYMODE", l_ObjectBit)
ELSE
	l_QueryMode = TRUE
END IF

RETURN l_QueryMode
end function

public function integer fu_setcustomdescriptions (ref window window_name, ref windowobject control_name, ref string description[], ref boolean customcontrol);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetCustomDescriptions
//  Description   : This is a user coded function that is 
//						  called by the security registration window to 
//						  determine if the current window control is a 
//						  custom control that needs to be secured. 
//                  If it is, the indicator CustomControl must be 
//						  set to TRUE.
//						  If the control contains any objects within it
//						  that need to be secured, a list of descriptions
//						  that will be used to register them in the
//						  security database must be passed back.
//
//  Parameters    : REF WINDOW       Window_Name   - 
//                     Window name.
//                  REF WINDOWOBJECT Control_name  - 
//                     the current control.
//                  REF STRING   	 Description[] - 
//                     Array of control descriptions.
//						  REF BOOLEAN	    CustomControl - 
//                     indicates whether or not the 
//                     control is a custom control.	
//						  	
//  Return Value  : INTEGER - Number of descriptions in the array.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//******************************************************************
//***NOTE: THIS FUNCTION IS CALLED INTERNALLY BY POWERLOCK AND******
//*********SHOULD NOT BE CALLED BY THE DEVELOPER!*******************
//******************************************************************

//******************************************************************
// The following pseudo code illustrates how a custom control can be 
// registered in the PowerLock security database.
//******************************************************************
//INTEGER             l_NumODesc
//U_CUSTOMCONTROL_1   l_YourCustomControl1
//U_CUSTOMCONTROL_2   l_YourCustomControl2
//			.							.
//			.							.
//			.							.
//U_CUSTOMCONTROL_N   l_YourCustomControlN
//
///*Since this function is called for every object on the window you
//  will need to make sure that the Control_Name parameter is an object
//  of your custom control's type.  An easy way to do this is to use 
//  the tag value of the object.*/
//
//CHOOSE CASE Upper(Control_Name.Tag)
//	CASE "U_CUSTOMCONTROL_1"
//		CustomControl = TRUE
//
//		/*Copy the Control_Name parameter into a local variable of the
//		  appropriate type so that you may reference its attributes and
//		  methods.*/
//
//		l_YourCustomControl1 = Control_Name
//
//		/*Fill in the Description[] parameter with descriptions of the
//		  objects within the custom control that you wish to secure. 
//      These descriptions will be stored by PowerLock and you will 
//      refer to them in fu_SetCustomSecurity() in order to secure 
//      the objects within your custom control.*/
//
//		Description[1] = l_YourCustomControl1.fu_GetObjectDesc(1)
//		Description[2] = l_YourCustomControl1.fu_GetObjectDesc(2)
//				.
//				.
//				.
//		Description[n] = l_YourCustomControl1.fu_GetObjectDesc(n)		
//	CASE "U_CUSTOMCONTROL_2"
//				.
//				.
//				.
//	CASE "U_CUSTOMCONTROL_N" 
//END CHOOSE
//
///*Return the number of descriptions.*/
//
//l_NumODesc = UpperBound(Description[])
//RETURN l_NumODesc
//******************************************************************

RETURN 0
end function

public subroutine fu_getappinfo (ref long app_key, ref string app_name);//******************************************************************
//  PL Module     : n_secca_mgr
//  Subroutine    : fu_GetAppInfo
//  Description   : Retrieves security information about the current
//                  application.
//
//  Parameters    : REF LONG   App_Key  - application key.
//                  REF STRING App_Name - application description.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

app_key  = i_AppKey
app_name = i_AppName
end subroutine

public subroutine fu_getdbinfo (ref long db_key, ref string db_name);//******************************************************************
//  PL Module     : n_secca_mgr
//  Subroutine    : fu_GetDBInfo
//  Description   : Retrieves security information about the current
//                  database connection.
//
//  Parameters    : REF LONG   DB_Key  - Database connection key.
//                  REF STRING DB_Name - Database connection 
//                                       description.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

db_key  = i_DBKey
db_name = i_DBName
end subroutine

public function integer fu_getobjectsecurity (window window_name, powerobject object_name, string dwobject_name, ref boolean obj_visible, ref boolean obj_enable, ref boolean obj_add, ref boolean obj_delete, ref boolean obj_drilldown, ref boolean obj_query, ref boolean obj_dragdrop);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetObjectSecurity
//  Description   : Retrieves security information for a given 
//                  object on a window.
//
//  Parameters    : WINDOW      Window_Name  - Window Name.
//                  POWEROBJECT Object_Name  - Control Name.
//                  STRING      DWObject_Name- DW Object Name.
//                  REF BOOLEAN Obj_Visible  - TRUE = Hide control.
//                  REF BOOLEAN Obj_Enable   - TRUE = Disable
//                                             control.
//                  REF BOOLEAN Obj_Add      - TRUE = Allow new
//                                             records.
//                  REF BOOLEAN Obj_Delete   - TRUE = Allow records
//                                             to be deleted.
//                  REF BOOLEAN Obj_DrillDown- TRUE = Allow user to
//                                             drill down to another
//                                             control.
//                  REF BOOLEAN Obj_Query    - TRUE = Allow user to
//                                             use query mode.
//                  REF BOOLEAN Obj_DragDrop - TRUE = Allow user to
//                                             drag & drop on the
//                                             control.
//
//  Return Value  : INTEGER -  -1 = Object not secured
//                              0 = Object secured
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_WindowName, l_ObjName
INTEGER l_Row, l_ObjectBit

//------------------------------------------------------------------
//  Assume that there is no security.
//------------------------------------------------------------------

obj_visible   = TRUE
obj_enable    = TRUE
obj_add       = TRUE
obj_delete    = TRUE
obj_drilldown = TRUE
obj_query     = TRUE
obj_dragdrop  = TRUE

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN 0
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Window_Name.ClassName()
l_ObjName = fu_BuildObjName(Object_Name)
IF DWObject_Name <> "" THEN
	l_ObjName = l_ObjName + "." + DWObject_Name
END IF

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_ObjName + "'", 1, RowCount())
												 
//------------------------------------------------------------------
//  Check the restrictions if the object is found.
//------------------------------------------------------------------

IF l_Row > 0 THEN
	l_ObjectBit = GetItemNumber(l_Row, "obj_bit")
   IF l_ObjectBit > 0 THEN
      obj_visible   = fu_GetObjBit("VISIBLE", l_ObjectBit)
      obj_enable    = fu_GetObjBit("ENABLE", l_ObjectBit)
      obj_add       = fu_GetObjBit("ADD", l_ObjectBit)
      obj_delete    = fu_GetObjBit("DELETE", l_ObjectBit)
      obj_drilldown = fu_GetObjBit("DRILLDOWN", l_ObjectBit)
      obj_query     = fu_GetObjBit("QUERYMODE", l_ObjectBit)
      obj_dragdrop  = fu_GetObjBit("DRAGDROP", l_ObjectBit)
   END IF
   RETURN 0
ELSE
	RETURN -1
END IF
end function

public subroutine fu_getusrinfo (ref long usr_key, ref string usr_login, ref string usr_name);//******************************************************************
//  PL Module     : n_secca_mgr
//  Subroutine    : fu_GetUsrInfo
//  Description   : Retrieves security information for the current
//                  user.
//
//  Parameters    : REF LONG   Usr_Key   - User key.
//                  REF STRING Usr_Login - User's login name.
//                  REF STRING Usr_Name  - User's name.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

usr_key   = i_UsrKey
usr_login = i_UsrLogin
usr_name  = i_UsrName
end subroutine

public function integer fu_login (application application_object, transaction security_transaction, transaction application_transaction, string bitmap_file);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_Login
//  Description   : Initializes security, sets up the
//                  security transaction, key generation 
//                  transaction, and application transaction
//                  objects.  Displays the login window if the
//                  network login is not used.
//
//  Parameters    : APPLICATION Application_Object   - Name of the 
//                              transaction object used for the 
//                              application.  If the object is 
//                              filled with connection information
//                              then the connection information
//                              from the security database is
//                              bypassed.
//                  TRANSACTION Security_Transaction  - Name of the
//                              transaction object used for the
//                              security database.  The developer
//                              MUST fill this object with 
//                              connection information.
//                  TRANSACTION Application_Transaction  - Name of
//                              the transaction object used for
//                              application database.  The developer
//                              may or may not fill this object with 
//                              connection information.
//                  STRING      Bitmap_File           - Name of a
//                              bitmap file that will be used to
//                              display a bitmap on the login 
//                              window.
//
//  Return Value  : INTEGER - -1 = Login failed.
//                             0 = Login successful.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING   l_RegistrationMode, l_Object
INTEGER	l_Attempts = 1
WINDOW   l_Window

//------------------------------------------------------------------
//  Check to see if the transaction objects are the same.
//------------------------------------------------------------------

IF security_transaction = application_transaction THEN
	i_SameTrans = TRUE
ELSE
	i_SameTrans = FALSE
END IF

//------------------------------------------------------------------
//  Store the security and application transaction object.
//------------------------------------------------------------------

i_SecTrans = security_transaction
i_AppTrans = application_transaction

//------------------------------------------------------------------
//  Connect to the security database.  Abort initialization if
//  connection fails.
//------------------------------------------------------------------

IF fu_connect(i_SecTrans) = -1 THEN
   RETURN -1
END IF
i_SecurityConnected = TRUE

//------------------------------------------------------------------
//  Store application information in instance variables in the
//  security manager.
//------------------------------------------------------------------

i_AppObj = application_object.ClassName()
IF fu_SetAppKey() = -1 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Change the program name to match the application name.
//------------------------------------------------------------------

i_ProgName = i_AppName

//------------------------------------------------------------------
//  Open the login window.
//------------------------------------------------------------------

fu_CheckPwdEncrypt()

IF i_UseNetID THEN
	IF i_UseLogin THEN
		DO
			l_Object = SECCA.DEF.fu_GetDefault("Security", "Password")
			IF l_Object <> "" THEN
				Open(l_Window, l_Object)
			ELSE
				Message.DoubleParm = -1
			END IF
			IF Message.DoubleParm = -1 THEN
				EXIT
			END IF
			l_Object = SECCA.DEF.fu_GetDefault("Security", "Connection")
			IF l_Object <> "" THEN
				OpenWithParm(l_Window, l_Attempts, l_Object)
			ELSE
				Message.DoubleParm = -1
				EXIT
			END IF
			l_Attempts++
		LOOP WHILE (Message.DoubleParm = -2)
	ELSE
		l_Object = SECCA.DEF.fu_GetDefault("Security", "Connection")
		IF l_Object <> "" THEN
			Open(l_Window, l_Object)
		ELSE
			Message.DoubleParm = -1
		END IF
	END IF
ELSE
	l_Object = SECCA.DEF.fu_GetDefault("Security", "Login")
	IF l_Object <> "" THEN
		OpenWithParm(l_Window, bitmap_file, l_Object)
	ELSE
		Message.DoubleParm = -1
	END IF
END IF

//------------------------------------------------------------------
//  Return the results of the user's login.
//------------------------------------------------------------------

RETURN Message.DoubleParm
end function

public function integer fu_setobjectsecurity (window security_window, powerobject security_object, string security_dwobject);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetObjectSecurity
//  Description   : Retrieves and applies security to the object. 
//
//  Parameters    : WINDOW Security_Window - 
//                     Window that the object is on.
//                  POWEROBJECT Security_Object - 
//                     Object to be secured.
//                  STRING Security_DWObject -
//                     Name of the datawindow object to be secured.
//
//  Return Value  : INTEGER 0 = if successful
//                         -1 = if error occurs
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1996.  All Rights Reserved.
//******************************************************************

DATAWINDOW l_DW
MENU       l_Menu
STRING  l_ObjName, l_WindowName, l_RowType, l_RowClause, l_Criteria
STRING  l_DWExp, l_DWColor, l_CustomRestriction
BOOLEAN l_Invisible, l_Disable, l_RowCriteria, l_Expression
BOOLEAN l_IgnoreObject, l_POFolder
LONG    l_Row
INTEGER l_Return, l_ObjectBit, l_ObjectType, l_Type, l_Pos

//------------------------------------------------------------------
//  No need to secure the object if in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN 0
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_ObjName = fu_BuildObjName(Security_Object)
IF Security_DWObject <> "" THEN
	l_ObjName = l_ObjName + "." + Security_DWObject
END IF

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_ObjName + "'", 1, RowCount())
IF l_Row = 0 THEN
	l_Return = -1
	GOTO FINISH
END IF

//------------------------------------------------------------------
//  Grab the bit value and object type.
//------------------------------------------------------------------

l_ObjectBit  = GetItemNumber(l_Row, "obj_bit")
l_ObjectType = GetItemNumber(l_Row, "obj_type")
IF l_ObjectType >= 600 AND l_ObjectType < 800 THEN
	l_ObjectType = l_ObjectType - 600
END IF

//------------------------------------------------------------------
//  Check to see if the object has 'Visible' or 'Enable' restrictions.
//------------------------------------------------------------------

l_Invisible = FALSE
l_Disable = FALSE
IF NOT fu_GetObjBit("VISIBLE", l_ObjectBit) THEN
   l_Invisible = TRUE
END IF
IF NOT fu_GetObjBit("ENABLE", l_ObjectBit) THEN
   l_Disable = TRUE
END IF

l_RowCriteria = FALSE
CHOOSE CASE l_ObjectType
   CASE 100 TO 199
		
      //------------------------------------------------------------
      //  Secure the DataWindow.
      //------------------------------------------------------------
		
		l_DW = Security_Object
		
      //------------------------------------------------------------
      //  Grab any row or column criteria.
      //------------------------------------------------------------
	
	   l_RowClause = GetItemString(l_Row, "row_criteria")
															  
      //------------------------------------------------------------
      //  Check to see if the object is a datawindow control or a
      //  datawindow object.
      //------------------------------------------------------------
		
		IF Security_DWObject = "" THEN
			l_RowType = GetItemString(l_Row, "row_type")
			IF NOT IsNull(l_RowType) AND l_RowType <> "" THEN
				l_RowCriteria = TRUE
			END IF
			
         //---------------------------------------------------------
         //  Secure the object.
         //---------------------------------------------------------
	
	      l_Return = fu_ApplyRestrictions(l_DW, l_Invisible, &
													  l_Disable, l_RowCriteria, &
													  l_RowType, l_RowClause)			
		ELSE
         l_Expression = FALSE
			l_IgnoreObject = FALSE
			IF NOT IsNull(l_RowClause) AND l_RowClause <> "" THEN
				l_Expression = TRUE
				IF Pos(l_RowClause, ":<", 1) > 0 THEN
				   l_IgnoreObject = TRUE
				END IF
			END IF
			
			IF l_Expression AND NOT l_IgnoreObject THEN
				
            //------------------------------------------------------
            //  Find the original expressions of the datawindow 
            //  object.
            //------------------------------------------------------

            l_Criteria = Trim(GetItemString(l_Row, "orig_criteria"))
            IF l_Criteria = "" OR IsNull(l_Criteria) THEN
	
               //---------------------------------------------------
               //  Grab either the visible or protect attribute.
               //---------------------------------------------------
	
	            IF l_Invisible THEN
	               l_DWExp = l_DW.Describe(Security_DWObject + &
						                        ".visible")
	               l_Pos = Pos(l_DWExp, "~t", 1)
	               IF l_Pos > 0 THEN
		               l_DWExp = Right(l_DWExp, Len(l_DWExp) - l_Pos)
		               l_DWExp = Left(l_DWExp, Len(l_DWExp) - 1)
	               END IF
	            ELSE
	               l_DWExp = l_DW.Describe(Security_DWObject + &
						                        ".protect")
	               l_Pos = Pos(l_DWExp, "~t", 1)
	               IF l_Pos > 0 THEN
		               l_DWExp = Right(l_DWExp, Len(l_DWExp) - l_Pos)
		               l_DWExp = Left(l_DWExp, Len(l_DWExp) - 1)
	               END IF
	            END IF
	
               //---------------------------------------------------
               //  Grab the background color.
               //---------------------------------------------------
	
	            l_DWColor = l_DW.Describe(Security_DWObject + &
		                                   ".background.color")
	            l_Pos = Pos(l_DWColor, "~t", 1)
	            IF l_Pos > 0 THEN
		            l_DWColor = Right(l_DWColor, Len(l_DWColor) - l_Pos)
		            l_DWColor = Left(l_DWColor, Len(l_DWColor) - 1)
	            END IF
	
               //---------------------------------------------------
               //  Save the values in the security datawindow.
               //---------------------------------------------------
	
	            SetItem(l_Row, "orig_criteria", l_DWExp + "||" + &
							  l_DWColor)
            ELSE
	
               //---------------------------------------------------
               //  Parse out the original color and either protect
               //  or visible attribute.
               //---------------------------------------------------
	
               l_Pos = Pos(l_Criteria, "||", 1)
	            l_DWExp = Left(l_Criteria, l_Pos - 1)
	            l_DWColor = Right(l_Criteria, Len(l_Criteria) - &
					                  (l_Pos + 1))
            END IF
			END IF
				
         //---------------------------------------------------------
         //  Secure the datawindow object.
         //---------------------------------------------------------
				
		   IF NOT l_IgnoreObject THEN
				l_Return = fu_SecureDWObj(l_DW, Security_DWObject, &
												  l_Invisible, l_Disable, &
												  l_Expression, l_Criteria, &
												  l_DWColor, l_DWExp)
			END IF
		END IF
   CASE 201 TO 299
		
      //------------------------------------------------------------
      //  Secure the menu item.
      //------------------------------------------------------------
		
		l_Menu = Security_Object
		
		IF l_Invisible THEN
			l_Menu.ToolbarItemVisible = FALSE
			l_Menu.Visible = FALSE
		END IF
		
		IF l_Disable THEN
			l_Menu.Enabled = FALSE
		END IF
		
	CASE 300 TO 399
		
      //------------------------------------------------------------
      //  Secure the PowerObjects tab folder.
      //------------------------------------------------------------
		
	   l_DW = Security_Object
		
      //------------------------------------------------------------
      //  Check to see if the object is the tab folder or an 
      //  individual tab and secure it.
      //------------------------------------------------------------
		
		IF Security_DWObject = "" THEN
         l_Return = fu_ApplyRestrictions(l_DW, l_Invisible, &
			                                l_Disable, l_RowCriteria, &
													  l_RowType, l_RowClause)
		ELSE
			IF l_Invisible THEN
				l_DW.Dynamic fu_HideTabName(Security_DWObject)
			END IF
			IF l_Disable THEN
				l_DW.Dynamic fu_DisableTabName(Security_DWObject)
			END IF
		END IF
		
	CASE 401
		
      //------------------------------------------------------------
      //  Secure the custom control.
      //------------------------------------------------------------
		
		IF l_Invisible THEN
			IF l_Disable THEN
				l_CustomRestriction = "BOTH"
			ELSE
				l_CustomRestriction = "INVISIBLE"
			END IF
		ELSE
			IF l_Disable THEN
			   l_CustomRestriction = "DISABLED"
			END IF
		END IF

		fu_SetCustomSecurity(Security_Window, &
		                     Security_Object, &
									Security_DWObject, &
									l_CustomRestriction)
		
	CASE ELSE
		
      //------------------------------------------------------------
      //  Secure the control.
      //------------------------------------------------------------
		
	   l_Return = fu_ApplyRestrictions(Security_Object, l_Invisible, &
											     l_Disable, l_RowCriteria, &
											     l_RowType, l_RowClause)
END CHOOSE

FINISH:

RETURN l_Return
end function

public function integer fu_setpopupsecurity (window security_window, ref menu popup_menu, integer popup_x, integer popup_y);//******************************************************************
//  PL Module     : n_secca_mgr
//  Subroutine    : fu_SetPopupSecurity
//  Description   : Retrieves and applies hide and disable security 
//                  for dynamically created popup menus on a window.
//
//  Parameters    : WINDOW Security_Window - 
//                     Window that the menu will to popped on.
//                  MENU Ref Popup_Menu - 
//                     The menu to be popped.
//                  INTEGER Popup_X -
//                     The X coordinate where the menu should be popped.
//                     this should be relative to the window or MDI
//                     frame window as applicable.
//                  INTEGER Popup_Y -
//                     The Y coordinate where the menu should be popped.
//                     this should be relative to the window or MDI
//                     frame window as applicable.
//
//  Return Value  : INTEGER 0 = if successful
//                         -1 = if an error occurs
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

MENU             l_MenuID
U_REGISTERBUTTON l_RegisterButton, l_Button

BOOLEAN l_Invisible, l_Disable, l_Found
STRING  l_WindowName, l_ObjectName, l_MenuName, l_RowType
INTEGER l_ObjectType, l_ObjectBit, l_Pos
INTEGER l_X, l_Y, l_Limit
LONG    l_Idx, l_Jdx, l_NumMenuItems, l_Rows

IF Popup_Menu.TypeOf() <> Menu! THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  If the application is in registration mode, display a Register
//  button in the upper right corner of the window.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
		
   //---------------------------------------------------------------
   // Look for the register button for this window.
   //---------------------------------------------------------------
		
	FOR l_Idx = 1 TO i_NumRegButtons
		l_Button = i_RegButton[l_Idx]
		IF l_Button.i_Window = security_window THEN
			l_RegisterButton = i_RegButton[l_Idx]
			EXIT
		END IF
	NEXT
	
   //---------------------------------------------------------------
   //  Since a new dynamic popup menu has been created, the
   //  registration window needs to be told to refresh itself.
   //---------------------------------------------------------------
	
	l_RegisterButton.i_NewDynamic = TRUE	
	
   //---------------------------------------------------------------
   //  Look for the menu in the register button for this window.
   //---------------------------------------------------------------
	
	l_Found = FALSE
	l_Limit = UpperBound(l_RegisterButton.i_PopupMenu[])
	FOR l_Idx = 1 TO l_Limit
		IF l_RegisterButton.i_PopupMenu[l_Idx].ClassName() = &
			Popup_Menu.ClassName() THEN
			l_Found = TRUE
		END IF
	NEXT
	IF NOT l_Found THEN
		
      //------------------------------------------------------------
      //  Since this menu hasn't yet been identified as an object to
      //  register for this window, we need to save the reference.
      //------------------------------------------------------------
		
		l_RegisterButton.i_PopupMenu[l_Limit + 1] = Popup_Menu
		
	END IF
	
ELSE

   //---------------------------------------------------------------
   //  Grab the window name.
   //---------------------------------------------------------------

   l_WindowName = security_window.ClassName()
	
   //---------------------------------------------------------------
   //  Filter the security datawindow if necessary.
   //---------------------------------------------------------------

   IF l_WindowName <> i_FilterWindow THEN
	   SetFilter("obj_window = '" + l_WindowName + "'")
	   Filter()
	   i_FilterWindow = l_WindowName
   END IF
	
   //---------------------------------------------------------------
   //  Check for controls with hide and disable restrictions.
   //---------------------------------------------------------------

	l_Rows = RowCount()
   FOR l_Idx = 1 TO l_Rows
      l_ObjectName  = GetItemString(l_Idx, "obj_name")
      l_ObjectType  = GetItemNumber(l_Idx, "obj_type")
      l_ObjectBit   = GetItemNumber(l_Idx, "obj_bit")
 
      //------------------------------------------------------------
      //  Determine if the window control is hidden or disabled.
      //------------------------------------------------------------

      l_Invisible = FALSE
      l_Disable = FALSE
      IF NOT fu_GetObjBit("VISIBLE", l_ObjectBit) THEN
         l_Invisible = TRUE
      END IF
      IF NOT fu_GetObjBit("ENABLE", l_ObjectBit) THEN
         l_Disable = TRUE
      END IF
			
      //------------------------------------------------------------
      //  Apply the restriction depending on control type.
      //------------------------------------------------------------

      IF l_Invisible OR l_Disable THEN
           
         //---------------------------------------------------------
         //  Popup Menu items.
         //---------------------------------------------------------
           
         IF l_ObjectType >= 500 AND l_ObjectType < 600 THEN

            //------------------------------------------------------
            //  Cycle through each level of menus.  Split the 
            //  parent menu items from the final menu item level.
            //------------------------------------------------------

            l_MenuID = Popup_Menu
            l_ObjectName = MID(l_ObjectName, POS(l_ObjectName, ".") + 1)
            DO
               l_Pos = POS(l_ObjectName, ".")
               IF l_Pos > 0 THEN
                  l_MenuName = MID(l_ObjectName, 1, l_Pos - 1)
                  l_ObjectName = MID(l_ObjectName, l_Pos + 1)
                  l_NumMenuItems = UpperBound(l_MenuID.item[])
                  FOR l_Jdx = 1 TO l_NumMenuItems
                     IF l_MenuID.item[l_Jdx].ClassName() = l_MenuName THEN
                        l_MenuID = l_MenuID.item[l_Jdx]
                        EXIT
                     END IF
                  NEXT
               END IF
            LOOP UNTIL l_Pos = 0

            //------------------------------------------------------
            //  Hide/disable the menu items.
            //------------------------------------------------------

            l_NumMenuItems = UpperBound(l_MenuID.item[])
            FOR l_Jdx = 1 TO l_NumMenuItems
               IF l_MenuID.item[l_Jdx].ClassName() = l_ObjectName THEN
                  IF l_Invisible THEN
                     l_MenuID.item[l_Jdx].ToolbarItemVisible = FALSE
                     l_MenuID.item[l_Jdx].Visible = FALSE                     
				      ELSE
                     l_MenuID.item[l_Jdx].Enabled = FALSE
                  END IF
                  EXIT
               END IF
            NEXT

         END IF
      END IF
   NEXT
END IF

IF Popup_Menu.PopMenu(Popup_X, Popup_Y) = 1 THEN
	RETURN 0
ELSE
	RETURN -1
END IF
end function

public subroutine fu_setrowsecurity (powerobject security_object);//******************************************************************
//  PL Module     : n_secca_mgr
//  Subroutine    : fu_SetRowSecurity
//  Description   : Retrieves and applies data row security 
//                  for datawindows. 
//
//  Parameters    : POWEROBJECT Security_Object - 
//                     Object to search for datawindows on.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

WINDOWOBJECT	l_ControlName[]		
DATAWINDOW     l_DataWindow
WINDOW         l_Window
USEROBJECT     l_UserObject, l_UO
POWEROBJECT    l_PO
TAB            l_Tab
BOOLEAN l_Found, l_SecuringUO
STRING  l_WindowName, l_ObjectName, l_RowType, l_RowClause, l_UOName
STRING  l_TmpObject
INTEGER l_ObjectType, l_Pos, l_StartPos, l_EndPos, l_NumObjects 
LONG    l_Idx, l_Jdx, l_Rows

//------------------------------------------------------------------
//  If in registration mode, there is no reason to apply security.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
	RETURN
END IF

//------------------------------------------------------------------
//  Find the window whose objects are being secured.
//------------------------------------------------------------------

IF Security_Object.TypeOf() = Window! THEN
	l_Window = Security_Object
	l_SecuringUO = FALSE
ELSEIF Security_Object.TypeOf() = UserObject! THEN
	l_SecuringUO = TRUE
	l_UO = Security_Object
   l_UOName = l_UO.ClassName() + "."
	
   //---------------------------------------------------------------
   //  Determine if this the object to secure is a dynamic tab page.
   //---------------------------------------------------------------
	
	l_PO = Security_Object.GetParent()
	
	IF l_PO.TypeOf() = Tab! THEN
		l_UOName = l_PO.ClassName() + "." + l_UOName
	END IF
	
   //---------------------------------------------------------------
   //  Find the window whose objects are being secured.
   //---------------------------------------------------------------
	
	l_Found = FALSE	
	DO
		IF l_PO.TypeOf() = Window! THEN
			l_Found = TRUE
			l_Window = l_PO
		ELSE
			l_PO = l_PO.GetParent()
		END IF
	LOOP UNTIL l_Found
END IF

l_WindowName = l_Window.ClassName()

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Look for datawindows to secure.
//------------------------------------------------------------------

l_Rows = RowCount()
FOR l_Idx = 1 TO l_Rows
   l_ObjectType = GetItemNumber(l_Idx, "obj_type")
   IF (l_SecuringUO AND l_ObjectType = 700) OR &
	   (NOT l_SecuringUO AND l_ObjectType = 100) THEN
      l_RowType = GetItemString(l_Idx, "row_type")
		IF NOT IsNull(l_RowType) AND l_RowType <> "" THEN
			l_RowClause = GetItemString(l_Idx, "row_criteria")
			IF NOT IsNull(l_RowClause) AND l_RowClause <> "" THEN
			   IF Pos(l_RowClause, ":<", 1) = 0 THEN					
					l_ObjectName = GetItemString(l_Idx, "obj_name")
					l_Pos = Pos(l_ObjectName, l_UOName, 1)
					IF NOT l_SecuringUO OR &
					   (l_SecuringUO AND l_Pos = 1) THEN
						
                  //------------------------------------------------
                  //  If securing a user object, trim the object
                  //  name.
                  //------------------------------------------------
						
						IF l_SecuringUO THEN
							l_ObjectName = Right(l_ObjectName, &
							                     Len(l_ObjectName) - &
														Len(l_UOName))
						END IF
					
                  //------------------------------------------------
                  //  Find the object.
                  //------------------------------------------------
						
                  l_TmpObject = l_ObjectName
				      IF l_SecuringUO THEN
					      l_ControlName[] = l_UO.control[]
				      ELSE
                     l_ControlName[] = l_Window.control[]
				      END IF
                  l_NumObjects = UpperBound(l_ControlName[])
                  l_StartPos = 1
				      l_Found = FALSE
                  DO
                     l_EndPos = POS(l_ObjectName, ".", l_StartPos)
                     IF l_EndPos > 0 THEN
                        l_TmpObject = MID(l_ObjectName, l_StartPos, &
								                  l_EndPos - l_StartPos)
                        l_StartPos = l_EndPos + 1
							ELSE
								l_TmpObject = MID(l_ObjectName, l_StartPos, &
								                  (Len(l_ObjectName) + 1) - &
														l_StartPos)
							END IF
                     FOR l_Jdx = 1 TO l_NumObjects
                        IF l_ControlName[l_Jdx].ClassName() = l_TmpObject THEN
                           IF l_ControlName[l_Jdx].TypeOf() = UserObject! THEN
                              l_UserObject = l_ControlName[l_Jdx]
                              l_ControlName[] = l_UserObject.control[]
						         ELSEIF l_ControlName[l_Jdx].TypeOf() = Tab! THEN
								      l_Tab = l_ControlName[l_Jdx]
									   l_ControlName[] = l_Tab.control[]
								   ELSEIF l_ControlName[l_Jdx].TypeOf() = DataWindow! THEN
									   l_DataWindow = l_ControlName[l_Jdx]
										l_Found = TRUE
                           END IF
								   l_NumObjects = UpperBound(l_ControlName[])
                           EXIT
                        END IF
                     NEXT
                  LOOP UNTIL l_EndPos = 0
					
                  //------------------------------------------------
                  //  If the datawindow was found, add to the WHERE
                  //  or FILTER criteria.
                  //------------------------------------------------
					
					   IF l_Found THEN
					      IF l_RowType = 'W' THEN
						      fu_BuildSearch(l_DataWindow, l_RowClause)
					      ELSE
						      fu_BuildFilter(l_DataWindow, l_RowClause)
					      END IF
					   END IF
					END IF
				END IF
			END IF
		END IF
	END IF
NEXT

end subroutine

public function integer fu_setsecurity (powerobject security_object);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetSecurity
//  Description   : Retrieves and applies security to controls
//                  on the object.
//
//  Parameters    : POWEROBJECT Security_Object - 
//                     Window or object in which to apply security.
//
//  Return Value  : INTEGER 0 = if successful
//                         -1 = if an error occurs
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

WINDOWOBJECT           l_ControlName[]
MENU                   l_MenuID
DATAWINDOW             l_DW, l_Security_DW
USEROBJECT             l_UserObject
TAB                    l_TabControl
U_REGISTERBUTTON       l_RegisterButton, l_Button
POWEROBJECT            l_PO
WINDOW                 l_Security_Window
USEROBJECT             l_Security_UserObject

BOOLEAN l_Invisible, l_Disable, l_RowCriteria, l_MultiRoles, l_Found
BOOLEAN l_SecuringDynamicUO, l_IgnoreObject, l_DynamicTabPage
BOOLEAN l_SecuringDW, l_Expression, l_IgnoreDWObj
STRING  l_WindowName, l_ObjectName, l_DWName, l_DWObject, l_Return
STRING  l_MenuName, l_ParentObject, l_String, l_TmpObject, l_RowType 
STRING  l_RowClause, l_RowRoles, l_CustomDescription, l_CustomRestriction 
STRING  l_DynamicUOName, l_TabObjName, l_SecurityDWName, l_ColExpression
STRING  l_DWColor, l_DWExp, l_Criteria, l_Object
INTEGER l_ObjectType, l_ObjectBit, l_StartPos, l_EndPos, l_Pos
INTEGER l_X, l_Y, l_Limit, l_Len, l_Error
LONG    l_ObjectColor, l_Idx, l_Jdx, l_NumObjects, l_NumMenuItems
LONG    l_Rows

IF Security_Object.TypeOf() = Window! THEN
	l_Security_Window = Security_Object
	l_SecuringDynamicUO = FALSE
	l_DynamicTabPage = FALSE
	l_SecuringDW = FALSE
ELSE
	
   //---------------------------------------------------------------
   //  Find the window whose objects are being secured.
   //---------------------------------------------------------------

   IF Security_Object.TypeOf() = UserObject! THEN
	   l_SecuringDynamicUO = TRUE
	   l_Security_UserObject = Security_Object
		l_DynamicUOName = l_Security_UserObject.ClassName()
	ELSE
		l_SecuringDW = TRUE
		l_Security_DW = Security_Object
		l_SecurityDWName = l_Security_DW.ClassName()
	END IF
	
   //---------------------------------------------------------------
   //  Determine if this the object to secure is a dynamic tab page.
   //---------------------------------------------------------------
	
	l_PO = Security_Object.GetParent()
	
	IF l_PO.TypeOf() = Tab! THEN
		l_DynamicTabPage = TRUE
		l_TabObjName = l_PO.ClassName()
	ELSE
		l_DynamicTabPage = FALSE
	END IF
	
   //---------------------------------------------------------------
   //  Find the window whose objects are being secured.
   //---------------------------------------------------------------
	
	l_Found = FALSE
	
	DO
		IF l_PO.TypeOf() = Window! THEN
			l_Found = TRUE
			l_Security_Window = l_PO
		ELSE
			
         //---------------------------------------------------------
         //  If securing a datawindow, build up the fully qualified
         //  object name.
         //---------------------------------------------------------
			
			IF l_SecuringDW THEN
				l_SecurityDWName = l_PO.ClassName() + "." + l_SecurityDWName
			END IF
			l_PO = l_PO.GetParent()
		END IF
	LOOP UNTIL l_Found
END IF

l_WindowName = l_Security_Window.ClassName()

//------------------------------------------------------------------
//  If the application is in registration mode, display a Register
//  button in the upper right corner of the window.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   IF l_Security_Window.WindowType = MDI! OR &
      l_Security_Window.WindowType = MDIHelp! THEN
      IF NOT IsValid(i_RegisterWindow) THEN
        	l_Object = SECCA.DEF.fu_GetDefault("Security", "RegisterButtonMDI")
			IF l_Object <> "" THEN
				Open(i_RegisterWindow, l_Object, l_Security_Window)
			ELSE
				RETURN -1
			END IF
      END IF
		l_RegisterButton = i_RegisterWindow.cb_register
		l_RegisterButton.i_Window = l_Security_Window
   ELSE
		
      //------------------------------------------------------------
      //	Look for the register button for this window.
      //------------------------------------------------------------
	
		l_Found = FALSE
		FOR l_Idx = 1 TO i_NumRegButtons
			l_Button = i_RegButton[l_Idx]
			IF l_Button.i_Window = l_Security_Window THEN
				l_RegisterButton = i_RegButton[l_Idx]
				l_Found = TRUE
				EXIT
			END IF
		NEXT
		IF NOT l_Found THEN
			
         //---------------------------------------------------------
         //  Create the register button.
         //---------------------------------------------------------
			
	      l_X = l_Security_Window.WorkSpaceWidth() - 270
	      l_Y = 1
        	l_Object = SECCA.DEF.fu_GetDefault("Security", "RegisterButtonWin")
	      IF l_Object <> "" THEN
				l_Security_Window.OpenUserObject(l_RegisterButton, &
			                                    l_Object, &
														   l_X, &
														   l_Y)
			ELSE
				RETURN -1
			END IF
			l_RegisterButton.i_Window = l_Security_Window
		END IF
   END IF
	IF Security_Object.TypeOf() <> Window! THEN
		
		IF l_Found THEN
			l_RegisterButton.i_NewDynamic = TRUE
		END IF
		
		IF Security_Object.TypeOf() <> Datawindow! THEN
		
         //---------------------------------------------------------
         //  Look for the object in the register button for this 
         //  window.
         //---------------------------------------------------------
		
		   l_Found = FALSE
		   l_Limit = UpperBound(l_RegisterButton.i_DynamicUO[])
		   FOR l_Idx = 1 TO l_Limit
			   IF l_RegisterButton.i_DynamicUO[l_Idx] = l_Security_UserObject THEN
				   l_Found = TRUE
			   END IF
		   NEXT
		   IF NOT l_Found THEN
			
            //------------------------------------------------------
            //	Since this object hasn't yet been identified as an
            // object to register for this window, save the reference
            // to it.
            //------------------------------------------------------
			
			   l_RegisterButton.i_DynamicUO[l_Limit + 1] = l_Security_UserObject
		   END IF
	   END IF
	END IF
	
   //---------------------------------------------------------------
   //  Filter the security datawindow if necessary.
   //---------------------------------------------------------------

   IF l_WindowName <> i_FilterWindow THEN
	   SetFilter("obj_window = '" + l_WindowName + "'")
	   Filter()
	   i_FilterWindow = l_WindowName
   END IF

//------------------------------------------------------------------
//  Check for controls with hide and disable restrictions.
//------------------------------------------------------------------

ELSE
	
   //---------------------------------------------------------------
   //  Filter the security datawindow if necessary.
   //---------------------------------------------------------------

   IF l_WindowName <> i_FilterWindow THEN
	   SetFilter("obj_window = '" + l_WindowName + "'")
	   Filter()
	   i_FilterWindow = l_WindowName
   END IF
	
	l_Rows = RowCount()
   FOR l_Idx = 1 TO l_Rows
		l_IgnoreObject = FALSE
      l_ObjectType  = GetItemNumber(l_Idx, "obj_type")
      l_ObjectBit   = GetItemNumber(l_Idx, "obj_bit")
 
      //------------------------------------------------------------
      //  Determine if the window control is hidden or disabled.
      //------------------------------------------------------------

      l_Invisible = FALSE
      l_Disable = FALSE
      IF NOT fu_GetObjBit("VISIBLE", l_ObjectBit) THEN
         l_Invisible = TRUE
      END IF
      IF NOT fu_GetObjBit("ENABLE", l_ObjectBit) THEN
         l_Disable = TRUE
      END IF

		l_RowType = GetItemString(l_Idx, "row_type")
		IF NOT IsNull(l_RowType) AND NOT l_RowType = "" THEN
			l_RowClause = GetItemString(l_Idx, "row_criteria")
			l_RowCriteria = TRUE
		ELSE
			l_RowCriteria = FALSE
	   END IF
		
		l_ObjectName  = GetItemString(l_Idx, "obj_name")
		
      //------------------------------------------------------------
      //  If securing a dynamic user object, then strip off the 
      //  first level (or first two levels for a tab page) of the 
      //  object name and ignore the other objects on the window.
      //------------------------------------------------------------
		
		IF l_SecuringDynamicUO THEN
			IF l_DynamicTabPage THEN
				l_Len = Len(l_TabObjName)
				l_ObjectName = Replace(l_ObjectName, &
				                       1, &
											  l_Len + 1, &
											  "")
			END IF
         l_Pos = Pos(l_ObjectName, l_DynamicUOName)
			IF l_Pos > 0 THEN
				IF l_ObjectName <> l_DynamicUOName THEN
				   l_Len = Len(l_DynamicUOName)
				   l_ObjectName = Replace(l_ObjectName, &
											     1, &
											     l_Len + 1, &
											     "")
				ELSE
					l_Error = fu_ApplyRestrictions(l_Security_UserObject, &
													       l_Invisible, &
													       l_Disable, &
													       l_RowCriteria, &
													       l_RowType, &
													       l_RowClause)
					IF l_Error < 0 THEN
						RETURN l_Error
					END IF
					l_IgnoreObject = TRUE
				END IF
			ELSE
				l_IgnoreObject = TRUE
			END IF
		ELSEIF l_SecuringDW THEN
			
         //---------------------------------------------------------
         //  If securing a datawindow, then ignore any object that 
         //  doesn't start with the fully qualified datawindow name.
         //---------------------------------------------------------
		
	      l_Pos = Pos(l_ObjectName, l_SecurityDWName)
			IF l_Pos <> 1 THEN
				l_IgnoreObject = TRUE
			END IF
		END IF
			
      //------------------------------------------------------------
      //  Apply the restriction depending on control type.
      //------------------------------------------------------------

      IF (l_Invisible OR l_Disable OR l_RowCriteria) AND NOT l_IgnoreObject THEN
			
         //---------------------------------------------------------
         //  Adjust the object type for dynamic objects.
         //---------------------------------------------------------
			
			IF l_ObjectType >= 600 AND l_ObjectType < 800 THEN
				l_ObjectType = l_ObjectType - 600
			END IF
           
         //---------------------------------------------------------
         //  All controls except menus.
         //---------------------------------------------------------

         IF l_ObjectType < 200 OR l_ObjectType >= 300 THEN

            //------------------------------------------------------
            //  Cycle through each level of the control name. 
            //  Determine the control's parent.
            //------------------------------------------------------

            l_TmpObject = l_ObjectName
				IF l_SecuringDynamicUO THEN
					IF l_Security_UserObject.TypeOf() = UserObject! THEN
					   l_ControlName[] = l_Security_UserObject.control[]
					END IF
				ELSE
               l_ControlName[] = l_Security_Window.control[]
				END IF
            l_NumObjects = UpperBound(l_ControlName[])
            l_StartPos = 1
				l_Found = TRUE
            DO
               l_EndPos = POS(l_ObjectName, ".", l_StartPos)
               IF l_EndPos > 0 THEN
                  l_TmpObject = MID(l_ObjectName, l_StartPos, l_EndPos - l_StartPos)
                  l_ParentObject = l_TmpObject
                  l_StartPos = l_EndPos + 1
						l_Found = FALSE
                  FOR l_Jdx = 1 TO l_NumObjects
                     IF l_ControlName[l_Jdx].ClassName() = l_TmpObject THEN
								IF l_ObjectType <> 401 THEN
                           IF l_ControlName[l_Jdx].TypeOf() = UserObject! THEN
                              l_UserObject = l_ControlName[l_Jdx]
                              l_ControlName[] = l_UserObject.control[]
								   ELSEIF l_ControlName[l_Jdx].TypeOf() = Tab! THEN
									   l_TabControl = l_ControlName[l_Jdx]
									   l_ControlName[] = l_TabControl.control[]
                           END IF
								END IF
								l_NumObjects = UpperBound(l_ControlName[])
								l_Found = TRUE
                        EXIT
                     END IF
                  NEXT
               ELSE
                  //----------------------------------------------
                  //  If a DataWindow, keep the name of the
                  //  DataWindow control and object in the DW.
                  //----------------------------------------------

                  l_TmpObject = MID(l_ObjectName, l_StartPos)
                  IF (l_ObjectType > 100 AND l_ObjectType <= 199) OR &
                     (l_ObjectType > 300 AND l_ObjectType <= 399) THEN
                     l_DWName = l_ParentObject
                     l_DWObject = l_TmpObject
                  END IF
               END IF
            LOOP UNTIL l_EndPos = 0 OR l_ObjectType = 401
                        
            //------------------------------------------------------
            //  Hide/disable the control.
            //------------------------------------------------------

            IF l_Found THEN
               CHOOSE CASE l_ObjectType
							
                  //------------------------------------------------
                  //  All window controls.
                  //------------------------------------------------
                  
                  CASE 1 TO 100, 300, 400
                     FOR l_Jdx = 1 TO l_NumObjects
                        IF l_ControlName[l_Jdx].ClassName() = l_TmpObject THEN
									l_Error = fu_ApplyRestrictions(&
									             l_ControlName[l_Jdx], &
									             l_Invisible, &
												    l_Disable, &
													 l_RowCriteria, &
												    l_RowType, &
													 l_RowClause)
									IF l_Error < 0 THEN
										RETURN l_Error
									END IF
                        END IF
                     NEXT

                  //------------------------------------------------
                  //  DataWindow controls.
                  //------------------------------------------------
                  
                  CASE 101 TO 199
							
                     FOR l_Jdx = 1 TO l_NumObjects
                        IF l_ControlName[l_Jdx].ClassName() = l_DWName THEN
                           l_DW = l_ControlName[l_Jdx]
									
                           //---------------------------------------
                           //  Only apply the restrictions if the 
                           //  dataobject is valid.
                           //---------------------------------------
									
									IF IsValid(l_DW.Object) THEN

                              //------------------------------------
                              //  Determine if there is an expression
                              //  to apply.
                              //------------------------------------
										
										l_ColExpression = GetItemString(&
										                     l_Idx, &
																	"row_criteria")
										l_Expression = FALSE
										l_IgnoreDWObj = FALSE
										IF l_ColExpression <> "" THEN
											l_Expression = TRUE
											IF Pos(l_ColExpression, ":<", 1) > 0 THEN
												l_IgnoreDWObj = TRUE
											END IF
										END IF
										
                              //------------------------------------
                              //  Secure the datawindow object.
                              //------------------------------------
										
										IF NOT l_IgnoreDWObj THEN
											
                                 //---------------------------------
                                 //  Find the original expressions of
                                 //  the datawindow object.
                                 //---------------------------------

                                 l_Criteria = Trim(GetItemString(&
											                  l_Idx, &
	                                                "orig_criteria"))
                                 IF l_Criteria = "" THEN
	
                                    //------------------------------
                                    //  Grab either the visible or 
                                    //  protect attribute.
                                    //------------------------------
	
	                                 IF l_Invisible THEN
	                                    l_DWExp = l_DW.Describe(&
													             l_DWObject + &
		                                              ".visible")
	                                    l_Pos = Pos(l_DWExp, "~t", 1)
	                                    IF l_Pos > 0 THEN
		                                    l_DWExp = Right(l_DWExp, &
														             Len(l_DWExp) - l_Pos)
		                                    l_DWExp = Left(l_DWExp, &
														             Len(l_DWExp) - 1)
	                                    END IF
	                                 ELSE
	                                    l_DWExp = l_DW.Describe(&
													             l_DWObject + &
		                                              ".protect")
	                                    l_Pos = Pos(l_DWExp, "~t", 1)
	                                    IF l_Pos > 0 THEN
		                                    l_DWExp = Right(l_DWExp, &
														             Len(l_DWExp) - l_Pos)
		                                    l_DWExp = Left(l_DWExp, &
														             Len(l_DWExp) - 1)
	                                    END IF
	                                 END IF
	
                                    //------------------------------
                                    //  Grab the background color.
                                    //------------------------------
	
	                                 l_DWColor = l_DW.Describe(&
												               l_DWObject + &
		                                             ".background.color")
	                                 l_Pos = Pos(l_DWColor, "~t", 1)
	                                 IF l_Pos > 0 THEN
		                                 l_DWColor = Right(l_DWColor, &
													               Len(l_DWColor) - l_Pos)
		                                 l_DWColor = Left(l_DWColor, &
													               Len(l_DWColor) - 1)
	                                 END IF
	
                                    //------------------------------
                                    //  Save the values in the 
                                    //  security datawindow.
                                    //------------------------------
	
	                                 SetItem(l_Idx, "orig_criteria", &
										              l_DWExp + "||" + l_DWColor)
                                 ELSE
	
                                    //------------------------------
                                    //  Parse out the original color 
                                    //  and either protect or visible
                                    //  attribute.
                                    //------------------------------
												
                                    l_Pos = Pos(l_Criteria, "||", 1)
	                                 l_DWExp = Left(l_Criteria, l_Pos - 1)
	                                 l_DWColor = Right(l_Criteria, &
												                  Len(l_Criteria) &
																		- (l_Pos + 1))
                                 END IF
										   fu_SecureDWObj(l_DW, l_DWObject, &
																l_Invisible, &
																l_Disable, &
																l_Expression, &
																l_ColExpression, &
																l_DWColor, l_DWExp)
										END IF
								   END IF
                           EXIT
                        END IF
                     NEXT

                  //------------------------------------------------
                  //  PowerObject folder control.
                  //------------------------------------------------

                  CASE 301 TO 399
							
//------------------------------------------------------------------
//  The PowerObjects tab folder will secure itself during the create
//  process by calling fu_SetObjectSecurity() for each of its tabs.
//------------------------------------------------------------------
//
//                     FOR l_Jdx = 1 TO l_NumObjects
//                        IF l_ControlName[l_Jdx].ClassName() = l_DWName THEN
//                           l_DW = l_ControlName[l_Jdx]
//                           IF l_Invisible THEN
//									   IF l_Disable THEN
//	                              l_DW.Dynamic fu_HideTabName(l_DWObject)
//											l_DW.Dynamic fu_DisableTabName(l_DWObject)
//								      ELSE
//	                              l_DW.Dynamic fu_HideTabName(l_DWObject)
//								      END IF
//                           ELSE
//                              l_DW.Dynamic fu_DisableTabName(l_DWObject)
//                           END IF
//                           EXIT
//                        END IF
//                     NEXT
//------------------------------------------------------------------
						  				   		
                  //------------------------------------------------
                  //  Custom control.
                  //------------------------------------------------

					   CASE 401
						   IF l_Invisible THEN
							   IF l_Disable THEN
								   l_CustomRestriction = "BOTH"
							   ELSE
								   l_CustomRestriction = "INVISIBLE"
							   END IF
						   ELSE
							   IF l_Disable THEN
								   l_CustomRestriction = "DISABLED"
							   END IF
						   END IF
         		      l_CustomDescription  = GetItemString(l_Idx, "obj_desc")

					      fu_SetCustomSecurity(l_Security_Window, &
												   l_ControlName[l_Jdx], &	
												   l_CustomDescription, &
												   l_CustomRestriction)
						
               END CHOOSE
			   END IF

         //---------------------------------------------------------
         //  Menu items.
         //---------------------------------------------------------
           
         ELSE

            //------------------------------------------------------
            //  Cycle through each level of menus.  Split the 
            //  parent menu items from the final menu item level.
            //------------------------------------------------------

            l_MenuID = l_Security_Window.MenuID
            l_ObjectName = MID(l_ObjectName, POS(l_ObjectName, ".") + 1)
            l_StartPos = 1
            DO
               l_Pos = POS(l_ObjectName, ".")
               IF l_Pos > 0 THEN
                  l_MenuName = MID(l_ObjectName, 1, l_Pos - 1)
                  l_ObjectName = MID(l_ObjectName, l_Pos + 1)
                  l_NumMenuItems = UpperBound(l_MenuID.item[])
                  FOR l_Jdx = 1 TO l_NumMenuItems
                     IF l_MenuID.item[l_Jdx].ClassName() = l_MenuName THEN
                        l_MenuID = l_MenuID.item[l_Jdx]
                        EXIT
                     END IF
                  NEXT
               END IF
            LOOP UNTIL l_Pos = 0

            //------------------------------------------------------
            //  Hide/disable the menu items.
            //------------------------------------------------------

            l_NumMenuItems = UpperBound(l_MenuID.item[])
            FOR l_Jdx = 1 TO l_NumMenuItems
               IF l_MenuID.item[l_Jdx].ClassName() = l_ObjectName THEN
                  IF l_Invisible THEN
                     l_MenuID.item[l_Jdx].ToolbarItemVisible = FALSE
                     l_MenuID.item[l_Jdx].Visible = FALSE                     
					   ELSE
                     l_MenuID.item[l_Jdx].Enabled = FALSE
                  END IF
                  EXIT
               END IF
            NEXT

         END IF
      END IF
   NEXT
END IF

RETURN 0
end function

public function integer fu_setcolvariables (window security_window, datawindow security_dw, string security_col, string values[]);//******************************************************************
//  PL Module     : n_secca_mgr
//  Subroutine    : fu_SetColVariables
//  Description   : Inserts variable values into either the
//                  visible or protect expression of the datawindow.
//
//  Parameters    : WINDOW Security_Window - Window name.
//                  DATAWINDOW Security_DW - Datawindow name.
//                  STRING Security_Col - Column name.
//                  STRING Values[] - Array of values to insert.
//
//  Return Value  : INTEGER  0, success
//                          -1, error
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_BeginVarPos, l_EndVarPos, l_NumValues, l_VarLen, l_Row
INTEGER  l_Idx, l_ObjectBit, l_Pos, l_Error
STRING   l_Return, l_Statement, l_PLCrit, l_DWName, l_DWColor
STRING   l_DWExp, l_Criteria, l_WindowName
BOOLEAN  l_Found, l_Invisible, l_Disable

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN 0
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_DWName = fu_BuildObjName(Security_DW) + "." + Security_Col

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_DWName + "'", 1, RowCount())
IF l_Row <= 0 THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  Grab the PowerLock row criteria from the security datawindow.
//------------------------------------------------------------------

l_PLCrit = GetItemString(l_Row, "row_criteria")
IF l_PLCrit = "" THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  Determine which attribute the row criteria is to be applied to.
//------------------------------------------------------------------

l_ObjectBit = GetItemNumber(l_Row, "obj_bit")

l_Invisible = FALSE
l_Disable = FALSE
IF NOT fu_GetObjBit("VISIBLE", l_ObjectBit) THEN
   l_Invisible = TRUE
END IF
IF NOT fu_GetObjBit("ENABLE", l_ObjectBit) THEN
   l_Disable = TRUE
END IF

//------------------------------------------------------------------
//  Parse the statement replacing any PowerLock host variables with
//  the values specified in the array.
//------------------------------------------------------------------

l_NumValues = UpperBound(Values[])
l_BeginVarPos = 1
l_Idx = 0
DO
	l_Found = FALSE
	l_Idx ++
	l_BeginVarPos = Pos(l_PLCrit, ":<", l_BeginVarPos)
	IF l_BeginVarPos > 0 THEN
		l_Found = TRUE
		l_EndVarPos = Pos(l_PLCrit, ">", l_BeginVarPos)
		IF l_EndVarPos > 0 THEN
			l_EndVarPos ++
			l_VarLen = l_EndVarPos - l_BeginVarPos
			l_PLCrit = Replace(l_PLCrit, l_BeginVarPos, l_VarLen, Values[l_Idx])
		END IF
	END IF
LOOP WHILE l_Found AND l_Idx < l_NumValues

//------------------------------------------------------------------
//  Find the original expressions of the datawindow object.
//------------------------------------------------------------------

l_Criteria = Trim(GetItemString(l_Row, "orig_criteria"))
IF l_Criteria = "" THEN
	
   //---------------------------------------------------------------
   //  Grab either the visible or protect attribute.
   //---------------------------------------------------------------
	
	IF l_Invisible THEN
	   l_DWExp = Security_DW.Describe(Security_Col + ".visible")
	   l_Pos = Pos(l_DWExp, "~t", 1)
	   IF l_Pos > 0 THEN
		   l_DWExp = Right(l_DWExp, Len(l_DWExp) - l_Pos)
		   l_DWExp = Left(l_DWExp, Len(l_DWExp) - 1)
	   END IF
	ELSE
	   l_DWExp = Security_DW.Describe(Security_Col + ".protect")
	   l_Pos = Pos(l_DWExp, "~t", 1)
	   IF l_Pos > 0 THEN
		   l_DWExp = Right(l_DWExp, Len(l_DWExp) - l_Pos)
		   l_DWExp = Left(l_DWExp, Len(l_DWExp) - 1)
	   END IF
	END IF
	
   //---------------------------------------------------------------
   //  Grab the background color.
   //---------------------------------------------------------------
	
	l_DWColor = Security_DW.Describe(Security_Col + ".background.color")
	l_Pos = Pos(l_DWColor, "~t", 1)
	IF l_Pos > 0 THEN
		l_DWColor = Right(l_DWColor, Len(l_DWColor) - l_Pos)
		l_DWColor = Left(l_DWColor, Len(l_DWColor) - 1)
	END IF
	
   //---------------------------------------------------------------
   //  Save the values in the security datawindow.
   //---------------------------------------------------------------
	
	SetItem(l_Row, "orig_criteria", l_DWExp + "||" + l_DWColor)
ELSE
	
   //---------------------------------------------------------------
   //  Parse out the original color and either protect or visible
   //  attribute.
   //---------------------------------------------------------------
	
   l_Pos = Pos(l_Criteria, "||", 1)
	l_DWExp = Left(l_Criteria, l_Pos - 1)
	l_DWColor = Right(l_Criteria, Len(l_Criteria) - (l_Pos + 1))
END IF

//------------------------------------------------------------------
//  Stuff the expression into the appropriate attribute.
//------------------------------------------------------------------

l_Error = fu_SecureDWObj(Security_DW, Security_Col, l_Invisible, &
                         l_Disable, TRUE, l_PLCrit, l_DWColor, l_DWExp)

RETURN l_Error
end function

public function integer fu_setrowvariables (window security_window, datawindow security_dw, string values[]);//******************************************************************
//  PL Module     : n_secca_mgr
//  Subroutine    : fu_SetRowVariables
//  Description   : Inserts variable values into the where clause
//                  of the datawindow.
//
//  Parameters    : WINDOW Security_Window - Window name.
//                  DATAWINDOW Security_DW - Datawindow name.
//                  STRING Values[] - Array of values to insert.
//
//  Return Value  : INTEGER  0, success
//                          -1, error
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_GroupByPos, l_OrderByPos, l_BeginPos, l_EndPos, l_Idx
INTEGER  l_BeginVarPos, l_EndVarPos, l_NumValues, l_VarLen, l_Row
INTEGER  l_Len, l_Error
STRING   l_Return, l_Statement, l_PLCrit, l_DWName, l_Original 
STRING   l_Criteria, l_RowType, l_WindowName, l_NewSelect, l_NewFilter
BOOLEAN  l_Found

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN 0
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_DWName = fu_BuildObjName(Security_DW)

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_DWName + "'", 1, RowCount())
IF l_Row <= 0 THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  Grab the PowerLock row criteria from the security datawindow.
//------------------------------------------------------------------

l_PLCrit = GetItemString(l_Row, "row_criteria")
IF l_PLCrit = "" THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  Determine whether the row criteria is to be applied as a "WHERE"
//  clause or as a filter and then grab the appropriate statement.
//------------------------------------------------------------------

l_RowType = GetItemString(l_Row, "row_type")
IF l_RowType = "W" THEN
	l_Statement = Security_DW.Describe("datawindow.table.select")
	
   //---------------------------------------------------------------
   //  Make sure the transaction object has been set.
   //---------------------------------------------------------------
	
	IF Pos(Upper(l_Statement), "PBSELECT") > 0 THEN
		RETURN -1
	END IF
ELSEIF l_RowType = "F" THEN
	l_Statement = Security_DW.Describe("datawindow.table.filter")
	IF l_Statement = "?" THEN
		l_Statement = ""
	END IF
ELSE
	RETURN -1
END IF

//------------------------------------------------------------------
//  Grab the original criteria from the security datawindow.
//------------------------------------------------------------------

l_Original = Trim(GetItemString(l_Row, "orig_criteria"))

//------------------------------------------------------------------
//  Parse out the current criteria.
//------------------------------------------------------------------
	
IF l_RowType = "W" THEN
		
   //------------------------------------------------------------
   //  Just grab the "WHERE" clause.
   //------------------------------------------------------------
		
	l_BeginPos = Pos(Upper(l_Statement), "WHERE", 1)
	IF l_BeginPos > 0 THEN
		l_OrderByPos = Pos(Upper(l_Statement), "ORDER BY", l_BeginPos)
		IF l_OrderByPos > 0 THEN
         l_EndPos = l_OrderByPos - 1
		ELSE
			l_GroupByPos = Pos(Upper(l_Statement), "GROUP BY", &
									 l_BeginPos)
			IF l_GroupByPos > 0 THEN
            l_EndPos = l_GroupByPos - 1
			ELSE
            l_EndPos = Len(l_Statement) + 1
			END IF
		END IF
		l_Len = l_EndPos - l_BeginPos
		l_Criteria = Mid(l_Statement, l_BeginPos, l_Len)
	ELSE
		l_Criteria = ""
	END IF
ELSE
	l_BeginPos = 1
	l_Len = Len(l_Statement)
	l_Criteria = l_Statement
END IF
	
IF l_Original = "" THEN
	
   //---------------------------------------------------------------
   //  Save the criteria in the security datawindow.
   //---------------------------------------------------------------
	
	IF l_Criteria = "" THEN
		SetItem(l_Row, "orig_criteria", "NOTHING")
	ELSE
		SetItem(l_Row, "orig_criteria", l_Criteria)
	END IF
ELSE
	
   //---------------------------------------------------------------
   //  Reset either the select or filter statement to original.
   //---------------------------------------------------------------
	
	IF l_Original = "NOTHING" THEN
	   l_Statement = Replace(l_Statement, l_BeginPos, l_Len, "")
	ELSE
	   l_Statement = Replace(l_Statement, l_BeginPos, l_Len, l_Original)
	END IF
	IF l_RowType = "W" THEN
		l_Return = Security_DW.Modify("datawindow.table.select= ~"" + &
		                              l_Statement + "~"")
	ELSE
		l_Return = Security_DW.Modify("datawindow.table.filter= ~"" + &
		                              l_Statement + "~"")
	END IF
END IF

//------------------------------------------------------------------
//  Parse the statement replacing any PowerLock host variables with
//  the values specified in the array.
//------------------------------------------------------------------

l_NumValues = UpperBound(Values[])
l_BeginVarPos = 1
l_Idx = 0
DO
	l_Found = FALSE
	l_Idx ++
	l_BeginVarPos = Pos(l_PLCrit, ":<", l_BeginVarPos)
	IF l_BeginVarPos > 0 THEN
		l_Found = TRUE
		l_EndVarPos = Pos(l_PLCrit, ">", l_BeginVarPos)
		IF l_EndVarPos > 0 THEN
			l_EndVarPos ++
			l_VarLen = l_EndVarPos - l_BeginVarPos
			l_PLCrit = Replace(l_PLCrit, l_BeginVarPos, l_VarLen, Values[l_Idx])
		END IF
	END IF
LOOP WHILE l_Found AND l_Idx < l_NumValues

//------------------------------------------------------------------
//  Build up the search or filter using the new criteria.
//------------------------------------------------------------------

IF l_RowType = "W" THEN
	l_Error = fu_BuildSearch(Security_Dw, l_PLCrit)
	
   //---------------------------------------------------------------
   //  If this is a PowerClass datawindow, pass it the updated SQL

   //  statement.
   //---------------------------------------------------------------
   
	IF l_Error <> -1 THEN
		IF Security_Dw.TriggerEvent("po_identify") = 1 THEN
			IF Security_Dw.DYNAMIC fu_GetIdentity() = "DataWindow" THEN
				l_NewSelect = Security_Dw.Describe("datawindow.table.select")
				IF l_NewSelect = "?" OR l_NewSelect = "!" THEN
					l_NewSelect = ""
				END IF
		      Security_Dw.DYNAMIC fu_SetSQLSelect(l_NewSelect)
			END IF
		END IF
	END IF
ELSE
	l_Error = fu_BuildFilter(Security_Dw, l_PLCrit)
	
   //---------------------------------------------------------------
   //  If this is a PowerClass datawindow, pass it the updated
   //  filter clause.
   //---------------------------------------------------------------
   
	IF l_Error <> -1 THEN
		IF Security_Dw.TriggerEvent("po_identify") = 1 THEN
			IF Security_Dw.DYNAMIC fu_GetIdentity() = "DataWindow" THEN
				l_NewFilter = Security_Dw.Describe("datawindow.table.filter")
				IF l_NewFilter = "?" OR l_NewSelect = "!" THEN
					l_NewFilter = ""
				END IF
		      Security_Dw.DYNAMIC fu_SetFilter(l_NewFilter)
			END IF
		END IF
	END IF
END IF

RETURN l_Error
end function

public function integer fu_login (application application_object, transaction security_transaction, transaction application_transaction);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_Login
//  Description   : Calls the full version of fu_Login passing
//                  an empty string for the bitmap file.
//
//  Parameters    : APPLICATION Application_Object   - Name of the 
//                              transaction object used for the 
//                              application.  If the object is 
//                              filled with connection information
//                              then the connection information
//                              from the security database is
//                              bypassed.
//                  TRANSACTION Security_Transaction  - Name of the
//                              transaction object used for the
//                              security database.  The developer
//                              MUST fill this object with 
//                              connection information.
//                  TRANSACTION Application_Transaction  - Name of
//                              the transaction object used for
//                              application database.  The developer
//                              may or may not fill this object with 
//                              connection information.
//
//  Return Value  : INTEGER - -1 = Login failed.
//                             0 = Login successful.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return

//------------------------------------------------------------------
//  Since a bitmap file was not passed, just pass an empty string.
//------------------------------------------------------------------

l_Return = fu_Login(application_object, security_transaction, &
                    application_transaction, "")

RETURN l_Return
end function

public function integer fu_setobjectsecurity (window security_window, powerobject security_object);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetObjectSecurity
//  Description   : Calls the full fu_SetObjectSecurity() function
//                  passing an empty string for the DWObject.
//
//  Parameters    : WINDOW Security_Window - 
//                     Window that the object is on.
//                  POWEROBJECT Security_Object - 
//                     Object to be secured.
//
//  Return Value  : INTEGER 0 = if successful
//                         -1 = if error occurs
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return

l_Return = fu_SetObjectSecurity(Security_Window, Security_Object, "")

RETURN l_Return
end function

public function integer fu_getobjectsecurity (window window_name, powerobject object_name, ref boolean obj_visible, ref boolean obj_enable, ref boolean obj_dragdrop);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetObjectSecurity
//  Description   : Retrieves security information for a given 
//                  object on a window (not a datawindow or a
//                  datawindow object).
//
//  Parameters    : WINDOW      Window_Name  - Window Name.
//                  POWEROBJECT Object_Name  - Control Name.
//                  REF BOOLEAN Obj_Visible  - TRUE = Hide control.
//                  REF BOOLEAN Obj_Enable   - TRUE = Disable
//                                             control.
//                  REF BOOLEAN Obj_DragDrop - TRUE = Allow user to
//                                             drag & drop on the
//                                             control.
//
//  Return Value  : INTEGER -  -1 = Object not secured
//                              0 = Object secured
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return
BOOLEAN l_Add, l_Delete, l_Drill, l_Query

l_Return = fu_GetObjectSecurity(Window_Name, Object_Name, "", &
                                Obj_Visible, Obj_Enable, l_Add, &
										  l_Delete, l_Drill, l_Query, Obj_DragDrop)
										  
RETURN l_Return
end function

public function integer fu_getobjectsecurity (window window_name, powerobject object_name, string dwobject_name, ref boolean obj_visible, ref boolean obj_enable);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetObjectSecurity
//  Description   : Retrieves security information for a given 
//                  object on a datawindow.
//
//  Parameters    : WINDOW      Window_Name  - Window Name.
//                  POWEROBJECT Object_Name  - Control Name.
//                  STRING      DWObject_Name- DW Object Name.
//                  REF BOOLEAN Obj_Visible  - TRUE = Hide control.
//                  REF BOOLEAN Obj_Enable   - TRUE = Disable
//                                             control.
//
//  Return Value  : INTEGER -  -1 = Object not secured
//                              0 = Object secured
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return
BOOLEAN l_Add, l_Delete, l_Drill, l_Query, l_DragDrop

l_Return = fu_GetObjectSecurity(Window_Name, Object_Name, DWObject_Name, &
                                Obj_Visible, Obj_Enable, l_Add, &
										  l_Delete, l_Drill, l_Query, l_DragDrop)
										  
RETURN l_Return
end function

public function boolean fu_checkenable (window security_window, dragobject security_obj, string security_dwobject);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckEnable
//  Description   : Indicates whether the specified control is
//						  enabled.	
//
//  Parameters    : WINDOW     Security_Window - Current window.
//                  DRAGOBJECT Security_Obj - Current control.
//                  STRING     Security_DWObject - Name of the 
//                             datawindow object.
//
//  Return Value  : BOOLEAN - Indicates if this control is
//						            enabled for this user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN    l_Enable
STRING     l_WindowName, l_ObjName
LONG       l_Row, l_ObjectBit

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN TRUE
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_ObjName = fu_BuildObjName(Security_Obj)
IF Security_DWObject <> "" THEN
	l_ObjName = l_ObjName + "." + Security_DWObject
END IF

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_ObjName + "'", 1, RowCount())
IF l_Row > 0 THEN
	l_ObjectBit = GetItemNumber(l_Row, "obj_bit")
	l_Enable = fu_GetObjBit("ENABLE", l_ObjectBit)
ELSE
	l_Enable = TRUE
END IF

RETURN l_Enable
end function

public function boolean fu_checkenable (window security_window, dragobject security_obj);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckEnable
//  Description   : Calls the full function passing an empty string
//                  for the DWObject.
//
//  Parameters    : WINDOW     Security_Window - Current window.
//                  DRAGOBJECT Security_Obj - Current control.
//
//  Return Value  : BOOLEAN - Indicates if this control is
//						  enabled for this user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_Return

l_Return = fu_CheckEnable(Security_Window, Security_Obj, "")

RETURN l_Return
end function

public function integer fu_getobjectinfo (window window_name, ref string obj_name[], ref string obj_desc[], ref string obj_type[], ref boolean obj_visible[], ref boolean obj_enable[], ref boolean obj_add[], ref boolean obj_delete[], ref boolean obj_drill[], ref boolean obj_query[], ref boolean obj_drag[]);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetObjectInfo
//  Description   : Retrieves security information for controls on a
//                  window.
//
//  Parameters    : WINDOW      Window_Name   - Window name.
//                  REF STRING  Obj_Name[]    - Array of control
//                                              names.
//                  REF STRING  Obj_Desc[]    - Array of control
//                                              descriptions.
//                  REF STRING  Obj_Type[]    - Array of control
//                                              types (i.e. Line).
//                  REF BOOLEAN Obj_Visible[] - Array indicating if
//                                              a control is to be 
//                                              hidden. 
//                  REF BOOLEAN Obj_Enable[]  - Array indicating if
//                                              a control is to be
//                                              disabled.
//                  REF BOOLEAN Obj_Add[]     - Array indicating if
//                                              records may be added
//                                              to a DataWindow.
//                  REF BOOLEAN Obj_Delete[]  - Array indicating if
//                                              records may be
//                                              deleted from a 
//                                              DataWindow.
//                  REF BOOLEAN Obj_Drill[]   - Array indicating if
//                                              a record may be
//                                              selected for drilling
//                                              down to another
//                                              to a DataWindow.
//                  REF BOOLEAN Obj_Query[]   - Array indicating if
//                                              a DataWindow may be
//                                              used in query mode.
//                  REF BOOLEAN Obj_Drag[]    - Array indicating if
//                                              a control may be
//                                              used in drag/drop
//                                              operations.
//
//  Return Value  : INTEGER - Number of objects in the array.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_WindowName
INTEGER l_Rows, l_NumObjects, l_Idx, l_ObjectType, l_ObjBit

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN 0
END IF

//------------------------------------------------------------------
//  Grab the window names.
//------------------------------------------------------------------

l_WindowName = Window_Name.ClassName()

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Cycle through the security data looking for restrictions
//  on any of the controls on the window.
//------------------------------------------------------------------

l_Rows = RowCount()
l_NumObjects = 0
FOR l_Idx = 1 TO l_Rows
   l_NumObjects = l_NumObjects + 1
   obj_name[l_NumObjects] = GetItemString(l_Idx, "obj_name")
   obj_desc[l_NumObjects] = GetItemString(l_Idx, "obj_desc")

   //---------------------------------------------------------------
   //  Get the string equivalent for the control type.
   //---------------------------------------------------------------

   l_ObjectType = GetItemNumber(l_Idx, "obj_type")
		
   //---------------------------------------------------------------
   //  Adjust the object type if it is dynamic.
   //---------------------------------------------------------------
		
   IF l_ObjectType >= 600 AND l_ObjectType < 800 THEN
		l_ObjectType = l_ObjectType - 600
	END IF
		
   IF l_ObjectType <= i_NumObjects THEN
      obj_type[l_NumObjects] = i_ObjectName[l_ObjectType]
   ELSEIF l_ObjectType = 100 THEN
      obj_type[l_NumObjects] = i_ObjectMiscName[1]
   ELSEIF l_ObjectType > 100 AND l_ObjectType < 200 THEN
      obj_type[l_NumObjects] =  i_ObjectDWName[l_ObjectType - 100]
   ELSEIF l_ObjectType = 200 THEN
      obj_type[l_NumObjects] = i_ObjectMiscName[2]
   ELSEIF l_ObjectType > 200 AND l_ObjectType < 300 THEN
      obj_type[l_NumObjects] = i_ObjectMiscName[3]
   ELSEIF l_ObjectType = 300 THEN
      obj_type[l_NumObjects] = i_ObjectMiscName[4]
   ELSEIF l_ObjectType > 300 AND l_ObjectType < 400 THEN
      obj_type[l_NumObjects] = i_ObjectMiscName[5]
   ELSEIF l_ObjectType = 500 THEN
      obj_type[l_NumObjects] = i_ObjectMiscName[2]
   ELSEIF l_ObjectType > 500 AND l_ObjectType < 600 THEN
      obj_type[l_NumObjects] = i_ObjectMiscName[3]
   END IF

   l_ObjBit = GetItemNumber(l_Idx, "obj_bit")
   IF l_ObjBit <= 0 THEN
      obj_visible[l_NumObjects] = TRUE
      obj_enable[l_NumObjects]  = TRUE
      obj_add[l_NumObjects]     = TRUE
      obj_delete[l_NumObjects]  = TRUE
      obj_drill[l_NumObjects]   = TRUE
      obj_query[l_NumObjects]   = TRUE
      obj_drag[l_NumObjects]    = TRUE
   ELSE
      obj_visible[l_NumObjects] = fu_GetObjBit("VISIBLE", l_ObjBit)
      obj_enable[l_NumObjects]  = fu_GetObjBit("ENABLE", l_ObjBit)
      obj_add[l_NumObjects]     = fu_GetObjBit("ADD", l_ObjBit)
      obj_delete[l_NumObjects]  = fu_GetObjBit("DELETE", l_ObjBit)
      obj_drill[l_NumObjects]   = fu_GetObjBit("DRILLDOWN", l_ObjBit)
      obj_query[l_NumObjects]   = fu_GetObjBit("QUERYMODE", l_ObjBit)
      obj_drag[l_NumObjects]    = fu_GetObjBit("DRAGDROP", l_ObjBit)
   END IF
NEXT

RETURN l_NumObjects
end function

public function integer fu_refreshsecurity ();//******************************************************************
//  PL Module     : n_secca_mgr
//  Subroutine    : fu_RefreshSecurity
//  Description   : Refreshes the security datawindow with data from
//                  the security database.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -  0, OK
//                            -1, Error
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return

IF NOT i_RegistrationMode AND NOT i_SameTrans THEN
	l_Return = fu_Connect(i_SecTrans)
	IF l_Return < 0 THEN
		RETURN -1
	END IF
END IF

TriggerEvent("pld_retrieve")

IF NOT i_RegistrationMode AND NOT i_SameTrans THEN
	l_Return = fu_Disconnect(i_SecTrans)
	IF l_Return < 0 THEN
		RETURN -1
	END IF
END IF

RETURN 0
end function

public function integer fu_deletenonregobjects (string window_name, boolean delete_uos, boolean delete_menus, boolean delete_dws);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteNonRegObjects
//  Description   : Delete all non-registered objects for the given
//                  window. Non-registered objects are saved when
//                  lower level objects are registered.  The upper
//                  level non-registered objects are needed to 
//                  reconstruct the outliner list.
//
//  Return        :  0 = non-registered object deletion successful
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

DELETE FROM pl_obj_reg WHERE app_key = :i_AppKey AND
   obj_window = :window_name AND ((obj_type < 0 AND obj_type > -100) OR (obj_type < -199 AND obj_type > -500))
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("ObjNonRegDelete", 1, l_MsgStrings[])
   RETURN -1
END IF

IF Delete_UOs THEN
	DELETE FROM pl_obj_reg WHERE app_key = :i_AppKey AND
      obj_window = :window_name AND obj_type < -599
      USING i_SecTrans;

   IF i_SecTrans.SQLCode <> 0 THEN
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("ObjNonRegDelete", 1, l_MsgStrings[])
      RETURN -1
   END IF
END IF

IF Delete_Menus THEN
	DELETE FROM pl_obj_reg WHERE app_key = :i_AppKey AND
      obj_window = :window_name AND obj_type < -499 AND obj_type > -600
      USING i_SecTrans;

   IF i_SecTrans.SQLCode <> 0 THEN
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("ObjNonRegDelete", 1, l_MsgStrings[])
      RETURN -1
   END IF
END IF

IF Delete_DWs THEN
	DELETE FROM pl_obj_reg WHERE app_key = :i_AppKey AND
      obj_window = :window_name AND obj_type < -99 AND obj_type > -200
      USING i_SecTrans;

   IF i_SecTrans.SQLCode <> 0 THEN
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("ObjNonRegDelete", 1, l_MsgStrings[])
      RETURN -1
   END IF
END IF

RETURN 0
end function

public function boolean fu_checkenablepc (window security_window, dragobject security_obj, string security_dwobject);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckEnablePC
//  Description   : Indicates whether the specified control is
//						  enabled.	
//
//  Parameters    : WINDOW     Security_Window - Current window.
//                  DRAGOBJECT Security_Obj - Current control.
//                  STRING     Security_DWObject - Name of the 
//                             datawindow object.
//
//  Return Value  : BOOLEAN - Indicates if this control is
//						            enabled for this user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN    l_Enable
STRING     l_WindowName, l_ObjName
LONG       l_Row, l_ObjectBit

//------------------------------------------------------------------
//  No need to check if the application is run in registration mode.
//------------------------------------------------------------------

IF i_RegistrationMode THEN
   RETURN TRUE
END IF

//------------------------------------------------------------------
//  Grab the window and object names.
//------------------------------------------------------------------

l_WindowName = Security_Window.ClassName()
l_ObjName = fu_BuildObjName(Security_Obj)
IF Security_DWObject <> "" THEN
	l_ObjName = l_ObjName + "." + Security_DWObject
END IF

//------------------------------------------------------------------
//  Filter the security datawindow if necessary.
//------------------------------------------------------------------

IF l_WindowName <> i_FilterWindow THEN
	SetFilter("obj_window = '" + l_WindowName + "'")
	Filter()
	i_FilterWindow = l_WindowName
END IF

//------------------------------------------------------------------
//  Find the object in the security datawindow.
//------------------------------------------------------------------

l_Row = Find("obj_name = '" + l_ObjName + "'", 1, RowCount())
IF l_Row > 0 THEN
	l_ObjectBit = GetItemNumber(l_Row, "obj_bit")
	l_Enable = fu_GetObjBit("ENABLE", l_ObjectBit)
ELSE
	l_Enable = TRUE
END IF

RETURN l_Enable
end function

public subroutine fu_setcustomsecurity (readonly window window_name, readonly windowobject control_name, ref string description, ref string restriction);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_SetCustomSecurity
//  Description   : This is a user coded function that is 
//						  called by the security function fu_SetSecurity
//						  to apply restrictions to  objects within a 
//						  custom control.	
//
//  Parameters    : RO  WINDOW	Window_Name - the current window.
//                  RO  WINDOWOBJECT Control_Name 
//                                           - the current control.
//						  REF STRING   Description	- object description
//															  defined to the 
//															  security database
//															  by the function
//															  fu_SetCustomDescriptions.
//						  REF STRING   Restriction - the restriction to be
//															  applied to the current
//															  object. Value is either
//															  "INVISIBLE", "DISABLED",
//															  or "BOTH".
//						  	
//  Return Value  : None.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//******************************************************************
//***NOTE: THIS FUNCTION IS CALLED INTERNALLY BY POWERLOCK AND******
//*********SHOULD NOT BE CALLED BY THE DEVELOPER!*******************
//******************************************************************

//******************************************************************
// The following pseudo code illustrates how a custom control can be 
// secured using PowerLock.
//******************************************************************
//U_CUSTOMCONTROL_1   l_YourCustomControl1
//U_CUSTOMCONTROL_2   l_YourCustomControl2
//			.							.
//			.							.
//			.							.
//U_CUSTOMCONTROL_N   l_YourCustomControlN
//
///*Since this function could potentially be called for different
//  types of custom controls you will need to make sure that the 
//  Control_Name parameter is an object of the appropriate custom
//  control's type.  An easy way to do this is to use the tag value
//  of the object.*/
//
//CHOOSE CASE Upper(Control_Name.Tag)
//	CASE "U_CUSTOMCONTROL_1"
//		/*Copy the Control parameter into a local variable of the
//		  appropriate type so that you may reference its attributes and
//		  methods.*/
//
//		l_YourCustomControl1 = Control_Name
//
//    /*Based on the value of the Restriction parameter, secure the
//      object within your custom control that is identified by the 
//      Description parameter.*/
//
// 	CHOOSE CASE Restriction
//			CASE "INVISIBLE"
//				l_YourCustomControl1.fu_HideObject(Description)
//			CASE "DISABLED"
//				l_YourCustomControl1.fu_DisableObject(Description)
//			CASE "BOTH"
//				l_YourCustomControl1.fu_HideObject(Description)
//				l_YourCustomControl1.fu_DisableObject(Description)
//		END CHOOSE 
//	CASE "U_CUSTOMCONTROL_2"
//				.
//				.
//				.
//	CASE "U_CUSTOMCONTROL_N" 
//END CHOOSE
//******************************************************************
end subroutine

public function integer fu_insertadminappassign (integer parent_key, integer child_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_InsertAdminAppAssign
//  Description   : Add an admin application assignment to the security database.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1998.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

INSERT INTO pl_admin_app( adm_key, app_key ) VALUES (:parent_key, :child_key) USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("InsertError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function integer fu_deleteadminappassign (integer parent_key, integer child_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_DeleteAdminAppAssign
//  Description   : Delete an administrator application assignment from the 
//						  security database.
//
//  Return        :  0 = successful
//                  -1 = failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]

DELETE FROM pl_admin_app WHERE adm_key = :parent_key AND app_key = :child_key USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DeleteError", 1, l_MsgStrings[])
   RETURN -1
ELSE
	RETURN 0
END IF


end function

public function long fu_getadmappcount (long adm_key);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetAdmAppCount
//  Description   : Return the number of applications that the
//                  administrator's explicitly associated with.
//
//  Return        :  0 = admin not found
//                  -1 = action failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1998.  All Rights Reserved.
//******************************************************************

LONG 		l_AppCount
STRING	l_MsgStrings[]

SELECT COUNT(*) INTO :l_AppCount
   FROM pl_admin_app 
   WHERE adm_key = :adm_key
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("AdmNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
END IF

RETURN l_AppCount
end function

public function integer fu_connect (transaction transaction_object);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_Connect
//  Description   : Make a database connection using the given
//                  transaction object.
//
//  Return        :  0 = connection successful
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_MsgStrings[]
String ls_dbparm
Long ll_pos

// For the SNC driver, the database is specified in the dbparms
// If it isn't already in there, add it
//IF IsNull(transaction_object.DBParm) THEN
//	ls_dbparm = ""
//ELSE
//	ls_dbparm = transaction_object.DBParm
//END IF
//ll_pos = POS(ls_dbparm, "Database=")
//IF ll_pos = 0 THEN
//	IF LEN(ls_dbparm) > 0 THEN
//			transaction_object.DBParm = "~"Database='plock',ProviderString='" + transaction_object.DBParm + " '~" "
//		ELSE
			transaction_object.DBParm = " Database='" + transaction_object.database + "'"
//		END IF
//END IF

CONNECT USING transaction_object;

IF transaction_object.SQLCode <> 0 THEN
   IF transaction_object = i_SecTrans THEN
	   l_MsgStrings[1] = transaction_object.SQLErrText
      SECCA.MSG.fu_DisplayMessage("ConnectSecurity", 1, l_MsgStrings[])   
      RETURN -1
   ELSE
      IF transaction_object.DBMS = "" THEN
	      l_MsgStrings[1] = transaction_object.SQLErrText
         SECCA.MSG.fu_DisplayMessage("ConnectNoDBInfo", 1, l_MsgStrings[])   
      ELSE
			IF i_UseLogin THEN
				CHOOSE CASE transaction_object.SQLDBCode
					CASE -103  // Watcom
						RETURN -2
					CASE 6, 4002, 18456  // SQLServer - Sybase(system 11+), MS
						RETURN -2
					CASE 1017  // Oracle
						RETURN -2
					CASE  999  // Sybase - Versions before system 11
						RETURN -2 
				END CHOOSE
			END IF
	      l_MsgStrings[1] = transaction_object.DBMS
			l_MsgStrings[2] = transaction_object.SQLErrText
         SECCA.MSG.fu_DisplayMessage("ConnectApp", 2, l_MsgStrings[])   
			RETURN -1
      END IF
   END IF
END IF

RETURN 0
end function

public function integer fu_checkloginonly (string usr_login);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckLoginOnly
//  Description   : Validate login name only. Used instead of
//                  fu_CheckLogin when using the network ID to
//                  log in.
//
//  Return        :  0 = login successful
//                   1 = login successful, need new password
//                  -1 = login failed
//                  -2 = login is no longer active or has expired
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  01/29/03 M. Caruso  Added code to make login ID check case
//								sensitive.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING 	l_UsrLogin, l_MsgStrings[], l_Expire, l_Today, l_LastPwd
LONG   	l_AdmKey
INTEGER	l_Status
STRING 	l_SQLString, l_Year, l_Month, l_Day, l_Pwd
DATE     l_Date

SELECT usr_pwd, usr_status, usr_expire_date, usr_pwd_date, usr_key, usr_login 
   INTO :l_Pwd, :l_Status, :l_Expire, :l_LastPwd, :i_UsrKey, :l_UsrLogin
   FROM pl_usr WHERE usr_login = :usr_login 
   USING i_SecTrans;
	
l_Expire  = Trim(l_Expire)
l_LastPwd = Trim(l_LastPwd)

IF i_SecTrans.SQLCode <> 0 THEN
	IF i_SecTrans.SQLCode = 100 THEN
		IF i_UseNetID THEN
			l_MsgStrings[1] = Usr_Login
			SECCA.MSG.fu_DisplayMessage("LoginOnlyNoAccess", 1, l_MsgStrings[])
		ELSE
			SECCA.MSG.fu_DisplayMessage("LoginInvalid")
		END IF
		RETURN -1
	ELSE
		l_MsgStrings[1] = i_SecTrans.SQLErrText
		SECCA.MSG.fu_DisplayMessage("UserNoRetrieve", 1, l_MsgStrings[])
		RETURN -1
	END IF
ELSE
	// perform case sensitivity checking, assuming the database is case-insensitive
	IF usr_login <> l_UsrLogin THEN
		SECCA.MSG.fu_DisplayMessage("LoginInvalid")
		RETURN -1
	END IF
END IF

SELECT app_key INTO :l_AdmKey FROM pl_app 
   WHERE app_key IN (SELECT app_key FROM pl_app_grp where grp_key IN
   		(SELECT grp_key from pl_grp_usr where usr_key IN 
         (SELECT usr_key FROM pl_usr WHERE usr_login = :usr_login ))
         AND app_key = :i_AppKey) using i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
   IF i_SecTrans.SQLCode = 100 THEN
 
	SELECT app_key INTO :l_AdmKey FROM pl_app 
   	WHERE app_key IN (SELECT app_key FROM pl_app_usr WHERE app_key = :i_AppKey
         AND usr_key IN 
         (SELECT usr_key FROM pl_usr WHERE usr_login = :usr_login )
			AND app_key = :i_AppKey) USING i_SecTrans;

	IF i_SecTrans.SQLCode <> 0 THEN
   	IF i_UseNetID THEN
	      l_MsgStrings[1] = Usr_Login
         SECCA.MSG.fu_DisplayMessage("LoginOnlyNoAccess", 1, l_MsgStrings[])
   	ELSE
         SECCA.MSG.fu_DisplayMessage("LoginEnter")
   	END IF
   	RETURN -1
	 END IF
  ELSE
  	  IF i_UseNetID THEN
	     l_MsgStrings[1] = Usr_Login
        SECCA.MSG.fu_DisplayMessage("LoginOnlyNoAccess", 1, l_MsgStrings[])
     ELSE
        SECCA.MSG.fu_DisplayMessage("LoginEnter")
  	  END IF
     RETURN -1
  END IF
END IF

IF l_Status = 0 THEN
   SECCA.MSG.fu_DisplayMessage("LoginInactive")
  	RETURN -2
END IF

IF l_Expire <> "" THEN
	l_Date = Today()
	
	l_Year = String(Year(l_Date))
	
	l_Month = String(Month(l_Date))
	IF Len(l_Month) = 1 THEN
		l_Month = "0" + l_Month
	END IF
	
	l_Day = String(Day(l_Date))
	IF Len(l_Day) = 1 THEN
		l_Day = "0" + l_Day
	END IF
	
	l_Today = l_Year + l_Month + l_Day
	IF Long(l_Expire) < Long(l_Today) THEN
      SECCA.MSG.fu_DisplayMessage("LoginExpired")
     	RETURN -2
  	END IF
END IF

IF Lower(l_Pwd) = "changeme" AND NOT i_UseNetID AND NOT i_UseLogin THEN
	RETURN 1
ELSE
	RETURN 0
END IF
end function

public function integer fu_checklogin (string usr_login, string usr_pwd, integer login_attempts);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckLogin
//  Description   : Validate the user's login and password.
//
//  Return        :  0 = login successful
//                  -1 = login failed
//                  -2 = login failed.  Grace logins exceeded.
//                  -3 = login failed.  Password has expired.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  01/29/03 M. Caruso  Added case sensitivity checking code.
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_Status, l_Return
LONG    l_AdmKey, l_UsrKey
STRING  l_LastPwd, l_Expire, l_MsgStrings[], l_EncryptPWD, l_Password
STRING  l_SQLString, l_Today, l_Year, l_Month, l_Day, l_RelDate
STRING  l_UsrLogin, l_UsrPwd
DATE    l_Date

IF i_UseEncrypt THEN
	l_Password = fu_EncryptPWD(usr_pwd)
ELSE
	l_Password = usr_pwd
END IF

SELECT usr_status, usr_expire_date, usr_pwd_date, usr_key, usr_login, usr_pwd 
   INTO :l_Status, :l_Expire, :l_LastPwd, :i_UsrKey, :l_UsrLogin, :l_UsrPwd
   FROM pl_usr WHERE usr_login = :usr_login AND usr_pwd = :l_Password
   USING i_SecTrans;
	
l_Expire  = Trim(l_Expire)
l_LastPwd = Trim(l_LastPwd)

IF i_SecTrans.SQLCode <> 0 THEN
	IF i_SecTrans.SQLCode = 100 THEN
		IF i_GraceAttempts = login_attempts THEN
			SECCA.MSG.fu_DisplayMessage("LoginExceeded")
			fu_SetUsrStatus(0, usr_login)
			RETURN -2
		ELSE
			SECCA.MSG.fu_DisplayMessage("LoginInvalid")
			login_attempts++
			RETURN -1
		END IF
	ELSE
		l_MsgStrings[1] = i_SecTrans.SQLErrText
		SECCA.MSG.fu_DisplayMessage("UserNoRetrieve", 1, l_MsgStrings[])
		RETURN -1
	END IF
ELSE
	// perform case sensitivity checking, assuming the database is case-insensitive
	IF (usr_login <> l_UsrLogin) OR (l_Password <> l_UsrPwd) THEN
		SECCA.MSG.fu_DisplayMessage("LoginInvalid")
		login_attempts++
		RETURN -1
	END IF
END IF

//------------------------------------------------------------------
//  Make sure the user can have access to the application.
//------------------------------------------------------------------

SELECT app_key INTO :l_AdmKey FROM pl_app 
   WHERE app_key IN (SELECT app_key FROM pl_app_grp where grp_key IN
   		(SELECT grp_key from pl_grp_usr where usr_key IN 
         (SELECT usr_key FROM pl_usr WHERE usr_login = :usr_login 
         AND usr_pwd = :l_Password))
         AND app_key = :i_AppKey) using i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
   IF i_SecTrans.SQLCode = 100 THEN
 
	SELECT app_key INTO :l_AdmKey FROM pl_app 
   	WHERE app_key IN (SELECT app_key FROM pl_app_usr WHERE app_key = :i_AppKey
         AND usr_key IN 
         (SELECT usr_key FROM pl_usr WHERE usr_login = :usr_login
         AND usr_pwd = :l_Password)
			AND app_key = :i_AppKey) USING i_SecTrans;

	IF i_SecTrans.SQLCode <> 0 THEN
   	IF i_SecTrans.SQLCode = 100 THEN

      	IF i_GraceAttempts = login_attempts THEN
            SECCA.MSG.fu_DisplayMessage("LoginExceeded")
         	fu_SetUsrStatus(0, usr_login)
         	RETURN -2
      	ELSE
            SECCA.MSG.fu_DisplayMessage("LoginNoAccess")
         	login_attempts++
				RETURN -1
      	END IF
   	ELSE
	      l_MsgStrings[1] = i_SecTrans.SQLErrText
         SECCA.MSG.fu_DisplayMessage("UserNoRetrieve", 1, l_MsgStrings[])
      	RETURN -1
   	END IF
	END IF
  END IF
END IF

IF l_Status = 0 THEN
   SECCA.MSG.fu_DisplayMessage("LoginInactive")
  	RETURN -2
END IF

IF l_Expire <> "" THEN
	l_Date = Today()
	
	l_Year = String(Year(l_Date))
	
	l_Month = String(Month(l_Date))
	IF Len(l_Month) = 1 THEN
		l_Month = "0" + l_Month
	END IF
	
	l_Day = String(Day(l_Date))
	IF Len(l_Day) = 1 THEN
		l_Day = "0" + l_Day
	END IF
	
	l_Today = l_Year + l_Month + l_Day
	IF Long(l_Expire) < Long(l_Today) THEN
      SECCA.MSG.fu_DisplayMessage("LoginExpired")
		UPDATE "pl_usr"
		SET "usr_status" = 2
		WHERE ("pl_usr"."usr_login" = :usr_login) AND
				("pl_usr"."usr_pwd" = :l_Password)
		USING i_SecTrans ;
		IF i_SecTrans.SQLCode <> 0 THEN
			l_MsgStrings[1] = i_SecTrans.SQLErrText
			SECCA.MSG.fu_DisplayMessage("UserStatusUpdate", 1, l_MsgStrings[])
			RETURN -1
		END IF
     	RETURN -2
  	END IF
END IF

IF l_Status = 2 THEN
	SECCA.MSG.fu_DisplayMessage("LoginExpired")
	RETURN -2
END IF

IF l_LastPwd <> "" THEN
	l_Date = RelativeDate(Today(), i_PwdDays * -1)
	
	l_Year = String(Year(l_Date))
	
	l_Month = String(Month(l_Date))
	IF Len(l_Month) = 1 THEN
		l_Month = "0" + l_Month
	END IF
	
	l_Day = String(Day(l_Date))
	IF Len(l_Day) = 1 THEN
		l_Day = "0" + l_Day
	END IF
	
	l_RelDate = l_Year + l_Month + l_Day
  	IF Long(l_RelDate) > Long(l_LastPwd) THEN
      SECCA.MSG.fu_DisplayMessage("LoginPwdExpired")
     	RETURN -3
  	END IF
END IF 
  
RETURN 0
end function

public function integer fu_applyrestrictions (readonly windowobject security_object, boolean invisible, boolean disable, boolean row_criteria, string row_type, string row_clause);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_ApplyRestrictions
//  Description   : Apply the restrictions to the given object.
//
//  Parameters    : WINDOWOBJECT Security_Object -
//                     The object to be secured.
//						  BOOLEAN Invisible -
//							  Make the object invisible.
//                  BOOLEAN Disable -
//                     Disable the object.
//                  BOOLEAN Row_Criteria -
//                     Apply the row criteria.
//                  STRING Row_Type -
//                     Where clause or filter criteria.
//                  STRING Row_Clause -
//                     The row criteria to apply.
//
//  Return        :  0 = restrictions successfully applied
//                  -1 = an error occured
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

CHECKBOX               l_CheckBox
COMMANDBUTTON          l_CommandButton
DATAWINDOW             l_DataWindow
DROPDOWNLISTBOX        l_DropDownListBox
DROPDOWNPICTURELISTBOX l_DropDownPictureListBox
EDITMASK               l_EditMask
GRAPH                  l_Graph
GROUPBOX               l_GroupBox
LISTBOX                l_ListBox
LISTVIEW               l_ListView
MULTILINEEDIT          l_MultiLineEdit
OLECONTROL             l_OLEControl
OLECUSTOMCONTROL       l_OLECustomControl
PICTURE                l_Picture
PICTUREBUTTON          l_PictureButton
PICTURELISTBOX         l_PictureListBox
RADIOBUTTON            l_RadioButton
RICHTEXTEDIT           l_RichTextEdit
SINGLELINEEDIT         l_SingleLineEdit
STATICTEXT             l_StaticText
TAB                    l_TabControl
TREEVIEW               l_TreeView
USEROBJECT             l_UserObject
BOOLEAN l_POFolder
INTEGER l_Idx, l_Cnt
STRING l_Tab, l_TabStr, l_ColStr, l_Return

IF Invisible THEN
   Security_Object.Visible = FALSE
END IF

IF Disable THEN
   CHOOSE CASE Security_Object.TypeOf()
      CASE CheckBox!
         l_CheckBox = Security_Object
         l_CheckBox.Enabled = FALSE
      CASE CommandButton!
         l_CommandButton = Security_Object
         l_CommandButton.Enabled = FALSE
      CASE DataWindow!
         l_DataWindow = Security_Object
			
         //---------------------------------------------------------
         //  If the DataWindow is a Powerobjects tab folder, tell it
         //  to disable all of its tabs.
         //---------------------------------------------------------
			
			l_POFolder = FALSE
			IF l_DataWindow.TriggerEvent("po_identify") = 1 THEN
				IF l_DataWindow.Dynamic fu_GetIdentity() = "Folder" THEN
					l_POFolder = TRUE
				END IF
			END IF
			
			IF l_POFolder THEN
            l_DataWindow.Dynamic fu_DisableAll()
			ELSE
				
            //------------------------------------------------------
            //  Disable the DataWindow by setting the tab order to 0
            //  and column background color to the disable color.
            //------------------------------------------------------
				
            l_Cnt = Integer(l_DataWindow.Describe("datawindow.column.count"))
            l_Tab = ""
            l_TabStr = ""
            l_ColStr = ""												
            FOR l_Idx = 1 TO l_Cnt
			      IF l_DataWindow.Describe("#" + String(l_Idx) + ".visible") <> "0" THEN	
                  l_ColStr = l_ColStr + l_Tab + "#" + String(l_Idx) + ".background.color=" + String(i_DisableColor)
                  l_Tab = "~t"
					END IF
            NEXT
            l_Return = l_DataWindow.Modify("Datawindow.ReadOnly=Yes")
            IF i_DisableColor >= 0 THEN
               l_Return = l_DataWindow.Modify(l_ColStr)
            END IF
			END IF
      CASE DropDownListBox!
         l_DropDownListBox = Security_Object
         l_DropDownListBox.Enabled = FALSE
      CASE DropDownPictureListBox!
         l_DropDownPictureListBox = Security_Object
         l_DropDownPictureListBox.Enabled = FALSE
      CASE EditMask!
         l_EditMask = Security_Object
         l_EditMask.DisplayOnly = TRUE
      CASE Graph!
         l_Graph = Security_Object
         l_Graph.Enabled = FALSE
      CASE GroupBox!
         l_GroupBox = Security_Object
         l_GroupBox.Enabled = FALSE
      CASE ListBox!
         l_ListBox = Security_Object
         l_ListBox.Enabled = FALSE
      CASE ListView!
         l_ListView = Security_Object
         l_ListView.Enabled = FALSE
      CASE MultiLineEdit!
         l_MultiLineEdit = Security_Object
         l_MultiLineEdit.DisplayOnly = TRUE
      CASE OLEControl!
         l_OLEControl = Security_Object
         l_OLEControl.Enabled = FALSE
      CASE OLECustomControl!
         l_OLECustomControl = Security_Object
         l_OLECustomControl.Enabled = FALSE
      CASE Picture!
         l_Picture = Security_Object
         l_Picture.Enabled = FALSE
		CASE PictureButton!
         l_PictureButton = Security_Object
         l_PictureButton.Enabled = FALSE
      CASE PictureListBox!
         l_PictureListBox = Security_Object
         l_PictureListBox.Enabled = FALSE
      CASE RadioButton!
         l_RadioButton = Security_Object
         l_RadioButton.Enabled = FALSE
      CASE RichTextEdit!
         l_RichTextEdit = Security_Object
         l_RichTextEdit.DisplayOnly = TRUE
      CASE SingleLineEdit!
         l_SingleLineEdit = Security_Object
         l_SingleLineEdit.DisplayOnly = TRUE
      CASE StaticText!
         l_StaticText = Security_Object
         l_StaticText.Enabled = FALSE
      CASE Tab!
         l_TabControl = Security_Object
         l_TabControl.Enabled = FALSE
      CASE TreeView!
         l_TreeView = Security_Object
         l_TreeView.Enabled = FALSE
      CASE UserObject!
         l_UserObject = Security_Object
         l_UserObject.Enabled = FALSE
   END CHOOSE
END IF

IF Row_Criteria THEN
 	CHOOSE CASE Security_Object.TypeOf()
		CASE DataWindow!
         l_DataWindow = Security_Object
			
         //---------------------------------------------------------
         //  Check to see if the object is a PowerObjects tab folder.
         //---------------------------------------------------------
			
			l_POFolder = FALSE
			IF l_DataWindow.TriggerEvent("po_identify") = 1 THEN
				IF l_DataWindow.Dynamic fu_GetIdentity() = "Folder" THEN
					l_POFolder = TRUE
				END IF
			END IF
			
         IF NOT l_POFolder THEN
				
            //------------------------------------------------------
            //  Only apply the row restrictions if the dataobject is 
            //  valid and there are no PowerLock host variables.
            //------------------------------------------------------
			
			   IF IsValid(l_DataWindow.Object) THEN
				   IF Pos(Row_Clause, ":<", 1) = 0 THEN
			         IF Row_Type = 'W' THEN
				         IF fu_BuildSearch(l_DataWindow, &
							                  Row_Clause) <> 0 THEN
					         RETURN -1
				         END IF
			         ELSE
				         IF fu_BuildFilter(l_DataWindow, &
							                  Row_Clause) <> 0 THEN
					         RETURN -1
				         END IF
			         END IF
				   END IF
			   END IF
			END IF
   END CHOOSE
END IF

RETURN 0
end function

public function integer fu_checkuselogin (string usr_login, integer login_attempts);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_CheckUseLogin
//  Description   : Validate login name only. Used instead of
//                  fu_CheckLogin when using the user login to
//						  log in to the database.	
//
//  Return        :  0 = login successful
//                  -1 = login failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  01/29/03 M. Caruso  Added case sensitivity checking code.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING 	l_MsgStrings[], l_LastPwd, l_Expire, l_Today, l_Year, l_Month
STRING   l_Day, l_RelDate, l_UsrLogin
LONG   	l_AdmKey
INTEGER 	l_Status
DATE 		l_Date

SELECT usr_status, usr_expire_date, usr_pwd_date, usr_key, usr_login
   INTO :l_Status, :l_Expire, :l_LastPwd, :i_UsrKey, :l_UsrLogin
   FROM pl_usr WHERE usr_login = :usr_login 
   USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
   IF i_SecTrans.SQLCode = 100 THEN
     	IF i_GraceAttempts = login_attempts THEN
         SECCA.MSG.fu_DisplayMessage("LoginExceeded")
        	fu_SetUsrStatus(0, usr_login)
       	RETURN -2
     	ELSE
         SECCA.MSG.fu_DisplayMessage("LoginInvalid")
			login_attempts++
         RETURN -1
		END IF
   ELSE
	   l_MsgStrings[1] = i_SecTrans.SQLErrText
      SECCA.MSG.fu_DisplayMessage("UserNoRetrieve", 1, l_MsgStrings[])
      RETURN -1
   END IF
ELSE
	// perform case sensitivity checking, assuming the database is case-insensitive
	IF usr_login <> l_UsrLogin THEN
		SECCA.MSG.fu_DisplayMessage("LoginInvalid")
		login_attempts++
		RETURN -1
	END IF
END IF

l_Expire  = Trim(l_Expire)
l_LastPwd = Trim(l_LastPwd)


SELECT app_key INTO :l_AdmKey FROM pl_app 
   WHERE app_key IN (SELECT app_key FROM pl_app_grp where grp_key IN
   		(SELECT grp_key from pl_grp_usr where usr_key IN 
         (SELECT usr_key FROM pl_usr WHERE usr_login = :usr_login ))
         AND app_key = :i_AppKey) using i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
   IF i_SecTrans.SQLCode = 100 THEN
 
	SELECT app_key INTO :l_AdmKey FROM pl_app 
   	WHERE app_key IN (SELECT app_key FROM pl_app_usr WHERE app_key = :i_AppKey
         AND usr_key IN 
         (SELECT usr_key FROM pl_usr WHERE usr_login = :usr_login )
			AND app_key = :i_AppKey) USING i_SecTrans;

	IF i_SecTrans.SQLCode <> 0 THEN
      SECCA.MSG.fu_DisplayMessage("LoginEnter")
	  	RETURN -1
	 END IF
  ELSE
     SECCA.MSG.fu_DisplayMessage("LoginEnter")
  	  RETURN -1
  END IF
END IF

IF l_Status = 0 THEN
   SECCA.MSG.fu_DisplayMessage("LoginInactive")
  	RETURN -2
END IF

IF l_Expire <> "" THEN
	l_Date = Today()
	
	l_Year = String(Year(l_Date))
	
	l_Month = String(Month(l_Date))
	IF Len(l_Month) = 1 THEN
		l_Month = "0" + l_Month
	END IF
	
	l_Day = String(Day(l_Date))
	IF Len(l_Day) = 1 THEN
		l_Day = "0" + l_Day
	END IF
	
	l_Today = l_Year + l_Month + l_Day
	IF Long(l_Expire) < Long(l_Today) THEN
      SECCA.MSG.fu_DisplayMessage("LoginExpired")
		UPDATE "pl_usr"
		SET "usr_status" = 2
		WHERE ("pl_usr"."usr_login" = :usr_login) AND
				("pl_usr"."usr_key" = :i_UsrKey)
		USING i_SecTrans ;

		IF i_SecTrans.SQLCode <> 0 THEN
			l_MsgStrings[1] = i_SecTrans.SQLErrText
			SECCA.MSG.fu_DisplayMessage("UserStatusUpdate", 1, l_MsgStrings[])
			RETURN -1
		END IF
     	RETURN -2
  	END IF
END IF


IF l_Status = 2 THEN
	SECCA.MSG.fu_DisplayMessage("LoginExpired")
	RETURN -2
END IF

IF l_LastPwd <> "" THEN
	l_Date = RelativeDate(Today(), i_PwdDays * -1)
	
	l_Year = String(Year(l_Date))
	
	l_Month = String(Month(l_Date))
	IF Len(l_Month) = 1 THEN
		l_Month = "0" + l_Month
	END IF
	
	l_Day = String(Day(l_Date))
	IF Len(l_Day) = 1 THEN
		l_Day = "0" + l_Day
	END IF
	
	l_RelDate = l_Year + l_Month + l_Day
  	IF Long(l_RelDate) > Long(l_LastPwd) THEN
      SECCA.MSG.fu_DisplayMessage("LoginPwdExpired")
     	RETURN -3
  	END IF
END IF  
  
RETURN 0
end function

public function integer fu_getdbuserinfo (long db_key, ref string db_name, ref string db_info[], string usr_login, string usr_pwd);//******************************************************************
//  PL Module     : n_secca_mgr
//  Function      : fu_GetDBUserInfo
//  Description   : Get the users current database connection 
//                  information.
//
//  Return        :  0 = database connection info found
//                  -1 = security database connection failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  02/14/03 M. Caruso  Made the usr_login and usr_pwd values
//								case-sensitive when i_uselogin is TRUE.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Name, l_DBMS, l_Database, l_Server, l_UserID, l_DBPass
STRING l_LogID, l_LogPass, l_DBParm, l_Lock, l_Commit, l_MsgStrings[]

SELECT db_name, db_dbms, db_database, db_server, db_userid,
   db_dbpass, db_logid, db_logpass, db_dbparm, db_lock, db_commit 
   INTO :l_Name, :l_DBMS, :l_Database, :l_Server, :l_UserID,
   :l_DBPass, :l_LogID, :l_LogPass, :l_DBParm, :l_Lock, :l_Commit
   FROM pl_db
   WHERE db_key = :db_key USING i_SecTrans;

IF i_SecTrans.SQLCode <> 0 THEN
	l_MsgStrings[1] = i_SecTrans.SQLErrText
   SECCA.MSG.fu_DisplayMessage("DBNoRetrieve", 1, l_MsgStrings[])
   RETURN -1
ELSE
   db_Name     = Trim(l_Name)
   db_Info[1]  = Trim(l_DBMS)
   db_Info[2]  = Trim(l_Database)
   db_Info[3]  = Trim(l_Server)
	IF i_uselogin THEN
		usr_login = Trim(usr_login)
		usr_pwd = Trim(usr_pwd)
		db_Info[4]  = Trim(usr_login)
   	db_Info[5]  = Trim(usr_pwd)
   	db_Info[6]  = Trim(usr_login)
   	db_Info[7]  = Trim(usr_pwd)
	ELSE
   	db_Info[4]  = Trim(l_UserID)
		IF i_UseEncrypt THEN
			l_DBPass = fu_DecryptPWD(Trim(l_DBPass))
		END IF
   	db_Info[5]  = Trim(l_DBPass)
   	db_Info[6]  = Trim(l_LogID)
		IF i_UseEncrypt THEN
			l_LogPass = fu_DecryptPWD(Trim(l_LogPass))
		END IF
  		db_Info[7]  = Trim(l_LogPass)
	END IF
   IF Upper(db_Info[1]) = "ODBC" THEN
		IF Pos(Upper(l_DBParm), "CONNECTSTRING") = 0 THEN
         IF IsNull(db_Info[4]) OR IsNull(db_Info[5]) THEN
       	   db_Info[8] = "ConnectString='DSN=" + Trim(l_DBParm) + "',StripParmNames='Yes',ConnectOption='SQL_DRIVER_CONNECT,SQL_DRIVER_NOPROMPT'"
         ELSE
       	   db_Info[8] = "ConnectString='DSN=" + Trim(l_DBParm) + &
                    	";UID=" + db_Info[4] + ";PWD=" + &
                    	db_Info[5] + "',StripParmNames='Yes',ConnectOption='SQL_DRIVER_CONNECT,SQL_DRIVER_NOPROMPT'"
         END IF
		ELSE
   		db_Info[8] = Trim(l_DBParm)
		END IF
	ELSE
   	db_Info[8] = Trim(l_DBParm) 
   END IF
   db_Info[9]  = Trim(l_Lock)
   db_Info[10] = Trim(l_Commit)
END IF

RETURN 0
end function

on n_secca_mgr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_secca_mgr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//******************************************************************
//  PL Module     : n_secca_mgr
//  Event         : Destructor
//  Description   : Shut down the security manager.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Limit

//------------------------------------------------------------------
//  Remove any instances of the register button.
//------------------------------------------------------------------

l_Limit = UpperBound(i_RegButton[])
FOR l_Idx = 1 TO l_Limit
	IF IsValid(i_RegButton[l_Idx]) THEN
		DESTROY i_RegButton[l_Idx]
	END IF
NEXT

//------------------------------------------------------------------
//  End the audit if necessary.
//------------------------------------------------------------------

IF i_UseAudit THEN
   fu_EndAudit()
END IF

//------------------------------------------------------------------
//  Disconnect the key generation, security, and application
//  transactions.
//------------------------------------------------------------------

IF i_KeyTransConnected THEN
 	fu_disconnect(i_KeyTrans)
	i_KeyTransConnected = FALSE
END IF	
IF i_SecurityConnected THEN
	fu_disconnect(i_SecTrans)
	i_SecurityConnected = FALSE
END IF
	
//------------------------------------------------------------------
//  If the same transaction object was used for security and the
//  application, it has already been disconnected.
//------------------------------------------------------------------
	
IF NOT i_SameTrans AND i_AppConnected THEN
	fu_disconnect(i_AppTrans)
END IF

//------------------------------------------------------------------
//  Destroy the key transaction object if necessary.
//------------------------------------------------------------------

IF IsValid(i_KeyTrans) THEN 
	DESTROY i_KeyTrans
END IF
end event

