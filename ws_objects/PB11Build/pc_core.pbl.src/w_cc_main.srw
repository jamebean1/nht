$PBExportHeader$w_cc_main.srw
$PBExportComments$Window ancestor for concurrency error handling
forward
global type w_cc_main from w_response_std
end type
type p_exclamation from picture within w_cc_main
end type
type p_information from picture within w_cc_main
end type
type p_question from picture within w_cc_main
end type
type p_stopsign from picture within w_cc_main
end type
type st_errortype from statictext within w_cc_main
end type
type gb_errortype from groupbox within w_cc_main
end type
type cb_first from commandbutton within w_cc_main
end type
type cb_prev from commandbutton within w_cc_main
end type
type cb_next from commandbutton within w_cc_main
end type
type cb_last from commandbutton within w_cc_main
end type
type gb_movement from groupbox within w_cc_main
end type
type rb_saveolddb from radiobutton within w_cc_main
end type
type rb_savenewdb from radiobutton within w_cc_main
end type
type rb_saveentered from radiobutton within w_cc_main
end type
type rb_savespecial from radiobutton within w_cc_main
end type
type gb_proccode from groupbox within w_cc_main
end type
type cb_yes from commandbutton within w_cc_main
end type
type cb_no from commandbutton within w_cc_main
end type
type cb_cancel_cl from commandbutton within w_cc_main
end type
type dw_1 from u_dw_main within w_cc_main
end type
type cb_ok from commandbutton within w_cc_main
end type
type cb_help from commandbutton within w_cc_main
end type
type cb_cancel_rl from commandbutton within w_cc_main
end type
end forward

global type w_cc_main from w_response_std
int Width=2181
int Height=1712
boolean TitleBar=true
string Title=""
boolean ControlMenu=false
p_exclamation p_exclamation
p_information p_information
p_question p_question
p_stopsign p_stopsign
st_errortype st_errortype
gb_errortype gb_errortype
cb_first cb_first
cb_prev cb_prev
cb_next cb_next
cb_last cb_last
gb_movement gb_movement
rb_saveolddb rb_saveolddb
rb_savenewdb rb_savenewdb
rb_saveentered rb_saveentered
rb_savespecial rb_savespecial
gb_proccode gb_proccode
cb_yes cb_yes
cb_no cb_no
cb_cancel_cl cb_cancel_cl
dw_1 dw_1
cb_ok cb_ok
cb_help cb_help
cb_cancel_rl cb_cancel_rl
end type
global w_cc_main w_cc_main

type variables
//-----------------------------------------------------------------------------------------
//  Concurrency Checking Constants
//-----------------------------------------------------------------------------------------

REAL			c_CCBlinkTime 	= 0.5

//-----------------------------------------------------------------------------------------
//  Concurrency Checking Instance Variables
//-----------------------------------------------------------------------------------------

BOOLEAN		i_Abort     	= FALSE

U_DW_MAIN		i_CCDW
N_DWSRV_CC		i_CCService
LONG			i_CCError 		= 0
INTEGER		i_CCList[]
STRING			i_CCRectVis
STRING			i_CCRectInvis

INTEGER		i_NumCCList

BOOLEAN		i_OkToClose 	= FALSE

BOOLEAN		i_RectOn 	= FALSE
INTEGER		i_RowHeight
BOOLEAN		i_RowLevelError
STRING			i_ProtectMode

PICTURE			i_Icons[]

//----------------------------------------------------------------------------------------
//  Bitmap Constants.
//----------------------------------------------------------------------------------------

UNSIGNEDLONG	c_ExclamationBitmap 	= 1
UNSIGNEDLONG	c_InformationBitmap 	= 2
UNSIGNEDLONG	c_QuestionBitmap 		= 3
UNSIGNEDLONG	c_StopSignBitmap 		= 4

UNSIGNEDLONG   c_ExclamationBMPData[] = { &
   0052317506, &
   0000000000, &
   0007733248, &
   0002621440, &
   0002228224, &
   0002228224, &
   0000065536, &
   0000000004, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   2147483776, &
   2147483648, &
   0008388736, &
   0008388608, &
   2155872384, &
   2155872256, &
   3233808512, &
   0000000192, &
   4278190335, &
   4278190080, &
   0016711935, &
   0016711680, &
   4294902015, &
   4294901760, &
   2290614527, &
   2290649224, &
   2290649224, &
   2290649224, &
   0931694728, &
   2290627379, &
   2290649224, &
   0000000128, &
   2290649096, &
   4287137928, &
   2290679807, &
   0008947848, &
   3149642507, &
   2290614448, &
   4287137928, &
   2290679807, &
   3137374344, &
   3137387451, &
   2281749435, &
   4287137928, &
   2290679807, &
   3149627528, &
   0000000187, &
   0146521019, &
   4287137928, &
   2290679807, &
   3149597576, &
   0000000187, &
   2965093307, &
   4287137928, &
   2290679807, &
   3149642624, &
   0000000176, &
   3149642507, &
   4287137800, &
   2290679807, &
   3149642507, &
   0000000176, &
   3149642507, &
   4287137968, &
   2156462079, &
   3149642683, &
   0000000187, &
   3149642683, &
   4287105211, &
   2156462079, &
   3149642683, &
   0000000187, &
   3149642683, &
   4287105211, &
   0193527807, &
   3149642683, &
   3137387451, &
   3149642683, &
   4287148219, &
   0193527807, &
   3149642683, &
   3149642683, &
   3149642683, &
   4287148219, &
   0193527807, &
   3149642683, &
   0000000176, &
   3149642507, &
   4287148219, &
   3145793535, &
   3149642683, &
   0000000176, &
   3149642507, &
   4278762427, &
   3145793535, &
   3149642683, &
   0000000176, &
   3149642507, &
   4010326971, &
   3145789167, &
   3149642683, &
   0000000176, &
   3149642507, &
   1275640763, &
   3145745484, &
   3149642683, &
   0000000176, &
   3149642507, &
   1074314171, &
   3145751360, &
   3149642683, &
   0000000176, &
   3149642507, &
   0084458427, &
   3145728000, &
   3149642683, &
   0000000176, &
   3149642507, &
   0000572347, &
   3145766912, &
   3149642683, &
   0000000176, &
   3149642507, &
   0352893883, &
   3145765201, &
   3149642683, &
   0000000176, &
   3149642507, &
   4245207995, &
   0193525079, &
   3149642683, &
   0000000176, &
   3149642507, &
   1569239227, &
   0193525239, &
   3149642683, &
   0000000176, &
   3149642507, &
   2005446843, &
   0193525079, &
   3149642683, &
   0000000176, &
   3149642507, &
   3616059579, &
   2156459511, &
   3149642683, &
   0000000176, &
   3149642507, &
   1569196219, &
   2156459351, &
   3149642683, &
   0000000176, &
   3149642507, &
   2290616507, &
   2290614408, &
   3149642507, &
   0000000176, &
   3149642507, &
   2324203696, &
   2290649497, &
   3149642624, &
   0000000176, &
   3149642507, &
   1149798408, &
   2290631884, &
   3149597576, &
   0000000176, &
   2965093131, &
   0327714952, &
   2290625057, &
   3149627528, &
   0000000176, &
   0146520843, &
   0294160520, &
   2290614289, &
   3137374344, &
   3149642683, &
   2281749435, &
   2290649224, &
   2290614348, &
   0008947848, &
   3149642507, &
   2290614448, &
   2324203656, &
   2290651267, &
   2290649224, &
   0000000128, &
   2290649096, &
   3431499912, &
   2290614510, &
   2290649224, &
   2290649224, &
   2290649224, &
   0008947848, &
   2290614272 }

UNSIGNEDLONG    c_InformationBMPData[] = { &
   0052317506, &
   0000000000, &
   0007733248, &
   0002621440, &
   0002228224, &
   0002228224, &
   0000065536, &
   0000000004, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   2147483776, &
   2147483648, &
   0008388736, &
   0008388608, &
   2155872384, &
   2155872256, &
   3233808512, &
   0000000192, &
   4278190335, &
   4278190080, &
   0016711935, &
   0016711680, &
   4294902015, &
   4294901760, &
   2290614527, &
   2290649224, &
   2290649224, &
   2290649224, &
   0931694728, &
   2290627379, &
   2290649224, &
   0000000128, &
   2290649096, &
   4287137928, &
   2290679807, &
   0008947848, &
   1145324548, &
   2290614336, &
   4287137928, &
   2290679807, &
   1140885640, &
   1145324612, &
   2281718852, &
   4287137928, &
   2290679807, &
   1145340040, &
   1145324612, &
   0138691652, &
   4287137928, &
   2290679807, &
   1145308296, &
   4294967295, &
   1078263807, &
   4287137928, &
   2290679807, &
   1145324672, &
   4294967295, &
   1145372671, &
   4287137800, &
   2290679807, &
   1145324548, &
   4294967295, &
   1145372671, &
   4287137856, &
   2156462079, &
   1145324612, &
   4294922052, &
   1145324788, &
   4287105092, &
   2156462079, &
   1145324612, &
   4294922052, &
   1145324788, &
   4287105092, &
   0076087295, &
   1145324612, &
   4294922052, &
   1145324788, &
   4287119428, &
   0076087295, &
   1145324612, &
   4294922052, &
   1145324788, &
   4287119428, &
   0076087295, &
   1145324612, &
   4294922052, &
   1145324788, &
   4287119428, &
   1149304831, &
   1145324612, &
   4294922052, &
   1145324788, &
   4278731844, &
   1149304831, &
   1145324612, &
   4294922052, &
   1145324788, &
   4278731844, &
   1149300463, &
   1145324612, &
   4294922052, &
   1145324788, &
   4278731844, &
   1149256780, &
   1145324612, &
   4294922052, &
   1145324788, &
   4278731844, &
   1149257796, &
   1145324612, &
   4294922052, &
   1145324788, &
   4278731844, &
   1149239296, &
   1145324612, &
   4294922052, &
   1145324788, &
   4278731844, &
   1149274112, &
   1145324612, &
   4294922052, &
   1145324788, &
   2634564676, &
   1149276497, &
   1145324612, &
   4294967295, &
   1145324788, &
   4245177412, &
   0076084567, &
   1145324612, &
   4294967295, &
   1145324788, &
   1569210436, &
   0076084727, &
   1145324612, &
   1145324612, &
   1145324612, &
   2005418052, &
   0076084567, &
   1145324612, &
   1145324612, &
   1145324612, &
   3616030788, &
   2156459511, &
   1145324612, &
   4110372676, &
   1145324612, &
   1569196100, &
   2156459351, &
   1145324612, &
   4294967108, &
   1145324612, &
   2290616388, &
   2290614408, &
   1145324548, &
   4294967119, &
   1145324788, &
   2324203584, &
   2290649497, &
   1145324672, &
   4294967119, &
   1145324788, &
   1149798408, &
   2290631884, &
   1145308296, &
   4294967119, &
   1078215924, &
   0327714952, &
   2290625073, &
   1145340040, &
   4294967108, &
   0138691652, &
   0294160520, &
   2290614289, &
   1140885640, &
   4110372676, &
   2281718852, &
   2290649224, &
   2290614348, &
   0008947848, &
   1145324548, &
   2290614336, &
   2324203656, &
   2290651267, &
   2290649224, &
   0000000128, &
   2290649096, &
   3431499912, &
   2290614510, &
   2290649224, &
   2290649224, &
   2290649224, &
   0008947848, &
   2290614272 }

UNSIGNEDLONG    c_QuestionBMPData[] = { &
   0052317506, &
   0000000000, &
   0007733248, &
   0002621440, &
   0002228224, &
   0002228224, &
   0000065536, &
   0000000004, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   2147483776, &
   2147483648, &
   0008388736, &
   0008388608, &
   2155872384, &
   2155872256, &
   3233808512, &
   0000000192, &
   4278190335, &
   4278190080, &
   0016711935, &
   0016711680, &
   4294902015, &
   4294901760, &
   2290614527, &
   2290649224, &
   2290649224, &
   2290649224, &
   0931694728, &
   2290627379, &
   2290649224, &
   0000000128, &
   2290649096, &
   4287137928, &
   2290679807, &
   0008947848, &
   0572662274, &
   2290614304, &
   4287137928, &
   2290679807, &
   0570460296, &
   0587145762, &
   2281710114, &
   4287137928, &
   2290679807, &
   0572686472, &
   4294967074, &
   0136454690, &
   4287137928, &
   2290679807, &
   0572654216, &
   4294967074, &
   0539107874, &
   4287137928, &
   2290679807, &
   0572662400, &
   4294967087, &
   0572662514, &
   4287137800, &
   2290679807, &
   0572662274, &
   4294967087, &
   0572662514, &
   4287137824, &
   2156462079, &
   0572662306, &
   4294967074, &
   0572662306, &
   4287105058, &
   2156462079, &
   0572662306, &
   4294967074, &
   0572662306, &
   4287105058, &
   0042532863, &
   0572662306, &
   0587145762, &
   0572662306, &
   4287111202, &
   0042532863, &
   0572662306, &
   0572662306, &
   0572662306, &
   4287111202, &
   0042532863, &
   0572662306, &
   4294967074, &
   0572662306, &
   4287111202, &
   0578879487, &
   0572662306, &
   4294967074, &
   0572662306, &
   1426596386, &
   0578835797, &
   0572662306, &
   4294967074, &
   0572662306, &
   1997021730, &
   0578844279, &
   0572662306, &
   4294913826, &
   0572662514, &
   1426596386, &
   0578831445, &
   0572662306, &
   4294913826, &
   0572662514, &
   1997021730, &
   0578822754, &
   0572662306, &
   4294910498, &
   0572662527, &
   1409819170, &
   0578831428, &
   0572662306, &
   4294910498, &
   0572662527, &
   0570958370, &
   0578822690, &
   0572662306, &
   4281279010, &
   0572715775, &
   0487072290, &
   0578818513, &
   0572662306, &
   4281279010, &
   0572715775, &
   4245168674, &
   0042530135, &
   4280427042, &
   4280483839, &
   0572719103, &
   1569202210, &
   0042530295, &
   4280427042, &
   4280483839, &
   0572719103, &
   2005409826, &
   0042530135, &
   4280427042, &
   4280483839, &
   0572719103, &
   3616022562, &
   2156459511, &
   4280427042, &
   4294967295, &
   0572719103, &
   1569196066, &
   2156459351, &
   4280427042, &
   4294967295, &
   0572719103, &
   2290616354, &
   2290614408, &
   0790766082, &
   4294967295, &
   0572715775, &
   2324203552, &
   2290649497, &
   0790766208, &
   4294967295, &
   0572715775, &
   0008947720, &
   2290614400, &
   0572654216, &
   4294967295, &
   0539108095, &
   0461932680, &
   2290625073, &
   0572686472, &
   4294967074, &
   0136454690, &
   0294160520, &
   2290614321, &
   0570460296, &
   0572662306, &
   2281710114, &
   2290649224, &
   2290614348, &
   0008947848, &
   0572662274, &
   2290614304, &
   2324203656, &
   2290651267, &
   2290649224, &
   0000000128, &
   2290649096, &
   3431499912, &
   2290614510, &
   2290649224, &
   2290649224, &
   2290649224, &
   0008947848, &
   2290614272 }

UNSIGNEDLONG    c_StopSignBMPData[] = { &
   0052317506, &
   0000000000, &
   0007733248, &
   0002621440, &
   0002228224, &
   0002228224, &
   0000065536, &
   0000000004, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   0000000000, &
   2147483776, &
   2147483648, &
   0008388736, &
   0008388608, &
   2155872384, &
   2155872256, &
   3233808512, &
   0000000192, &
   4278190335, &
   4278190080, &
   0016711935, &
   0016711680, &
   4294902015, &
   4294901760, &
   2290614527, &
   2290649224, &
   2290649224, &
   2290649224, &
   4220029064, &
   2290662331, &
   2290649224, &
   2290649224, &
   2290649224, &
   4253583496, &
   2290671069, &
   0294160520, &
   0286331153, &
   2290618641, &
   4220029064, &
   2290662331, &
   0293701768, &
   0286331153, &
   2283278609, &
   4253583496, &
   2290671069, &
   0286361736, &
   0286331153, &
   2282819857, &
   4220029064, &
   2290662331, &
   0286359944, &
   0286331153, &
   0403771665, &
   4253583496, &
   2290671069, &
   0286331272, &
   0286331153, &
   0286331153, &
   0008947848, &
   2290614272, &
   0286331265, &
   0286331153, &
   0286331153, &
   0008947736, &
   2290614272, &
   0286331153, &
   0286331153, &
   0286331153, &
   0008947729, &
   2173173760, &
   0286331153, &
   0286331153, &
   0286331153, &
   0008919057, &
   0294125568, &
   0286331153, &
   0286331153, &
   0286331153, &
   0008917265, &
   0294125568, &
   0301928721, &
   0521269521, &
   0301011441, &
   0008917265, &
   0294125568, &
   4044431121, &
   4044484881, &
   0301011231, &
   0092803345, &
   0294146055, &
   4044431121, &
   4044484881, &
   0301011231, &
   1166545169, &
   0294144587, &
   4044431121, &
   4044484881, &
   0301011231, &
   0143134993, &
   0294125636, &
   4044427537, &
   4044484881, &
   0301011231, &
   0008917265, &
   0294129732, &
   4044427537, &
   4044484881, &
   0301011231, &
   0076026129, &
   0294142632, &
   0301928721, &
   4044484881, &
   4060025119, &
   0008917265, &
   0294125568, &
   0286334737, &
   4044484881, &
   0535892255, &
   0008917265, &
   0294125568, &
   0286334737, &
   4044484881, &
   0535892255, &
   0008917265, &
   0294125568, &
   4044431121, &
   4044484881, &
   0535892255, &
   0008917265, &
   0294125568, &
   4044431121, &
   4044484881, &
   0535892255, &
   0008917265, &
   0294125568, &
   0301928721, &
   0535953407, &
   4060025329, &
   0008917265, &
   0294125568, &
   0286331153, &
   0286331153, &
   0286331153, &
   0008917265, &
   2173173760, &
   0286331153, &
   0286331153, &
   0286331153, &
   0008919057, &
   2290614272, &
   0286331153, &
   0286331153, &
   0286331153, &
   0008947729, &
   2290614272, &
   0286331265, &
   0286331153, &
   0286331153, &
   0008947736, &
   2290614272, &
   0286331272, &
   0286331153, &
   0286331153, &
   0008947848, &
   2290614272, &
   0286359944, &
   0286331153, &
   0403771665, &
   0008947848, &
   2290614272, &
   0286361736, &
   0286331153, &
   2282819857, &
   0008947848, &
   2290614272, &
   0293701768, &
   0286331153, &
   2283278609, &
   0008947848, &
   2290614272, &
   0294160520, &
   0286331153, &
   2290618641, &
   0008947848, &
   2290614272, &
   2290649224, &
   2290649224, &
   2290649224, &
   0008947848, &
   2290614272, &
   2290649224, &
   2290649224, &
   2290649224, &
   0008947848, &
   2290614272 }
end variables

forward prototypes
public subroutine fu_setrectsize (integer col_nbr)
public subroutine fu_getbitmap (long bitmap, ref blob bitmap_blob, ref long bitmap_width, ref long bitmap_height)
public subroutine fu_setitem (long row_nbr, integer col_nbr, string value)
public subroutine fu_displaymessage (integer id)
public subroutine fu_showerror (long col_nbr)
end prototypes

public subroutine fu_setrectsize (integer col_nbr);//******************************************************************
//  PC Module     : w_CC_Main
//  Subroutine    : fu_SetRectSize
//  Description   : Displays the rectangle around the current 
//                  column.
//
//  Parameters    : INTEGER  Col_Nbr -
//                     Column number.
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

BOOLEAN  l_First
INTEGER  l_X1, l_Y1, l_X2, l_Y2, l_X, l_Y, l_Pixels, l_Idx
INTEGER  l_Width, l_Height, l_Min, l_Max, l_New
STRING   l_Modify, l_Result, l_SX1, l_SY1, l_SX2, l_SY2
STRING   l_Col

IF c_CCBlinkTime > 0 THEN
   Timer(0, THIS)
END IF

IF col_nbr < 1 OR col_nbr > i_CCDW.i_DWSRV_EDIT.i_NumColumns THEN
   l_First = TRUE
   FOR l_Idx = 1 TO i_CCDW.i_DWSRV_EDIT.i_NumColumns
      l_Col = "#" + String(l_Idx)
		IF Upper(i_CCDW.Describe(l_Col + ".visible")) = "YES" THEN
         l_X      = Integer(dw_1.Describe(l_Col + ".x"))
         l_Y      = Integer(dw_1.Describe(l_Col + ".y"))
         l_Width  = Integer(dw_1.Describe(l_Col + ".width"))
         l_Height = Integer(dw_1.Describe(l_Col + ".height"))

         IF l_First THEN
            l_First = FALSE
            l_X1    = l_X
            l_Y1    = l_Y
            l_X2    = l_X + l_Width
            l_Y2    = l_Y + l_Height
         ELSE
            IF l_X1 > l_X THEN
               l_X1 = l_X
            END IF
            IF l_X2 < l_X + l_Width THEN
               l_X2 = l_X + l_Width
            END IF

            IF l_Y1 > l_Y THEN
               l_Y1 = l_Y
            END IF
            IF l_Y2 < l_Y + l_Height THEN
               l_Y2 = l_Y + l_Height
            END IF
         END IF
      END IF
   NEXT
   l_X      = l_X1
   l_Y      = l_Y1
   l_Width  = l_X2 - l_X1
   l_Height = l_Y2 - l_Y1
ELSE
   l_Col    = "#" + String(col_nbr)
   l_X      = Integer(dw_1.Describe(l_Col + ".x"))
   l_Y      = Integer(dw_1.Describe(l_Col + ".y"))
   l_Width  = Integer(dw_1.Describe(l_Col + ".width"))
   l_Height = Integer(dw_1.Describe(l_Col + ".height"))
END IF

l_Result = dw_1.Modify(i_CCRectInvis)

l_Pixels = 1
l_SX1    = String(l_X - PixelsToUnits &
                          (l_Pixels, XPixelsToUnits!))
l_SX2    = String(l_X + l_Width + PixelsToUnits &
                                    (l_Pixels, XPixelsToUnits!))
l_SY1    = String(l_Y - PixelsToUnits &
                          (l_Pixels, YPixelsToUnits!))
l_SY2    = String(l_Y + l_Height + PixelsToUnits &
                                      (l_Pixels, YPixelsToUnits!))

l_Modify = "CC_Line_1.X1="  + l_SX1 + &
           " CC_Line_1.Y1=" + l_SY1 + &
           " CC_Line_1.X2=" + l_SX2 + &
           " CC_Line_1.Y2=" + l_SY1
l_Result = dw_1.Modify(l_Modify)

l_Modify = "CC_Line_2.X1="  + l_SX2 + &
           " CC_Line_2.Y1=" + l_SY1 + &
           " CC_Line_2.X2=" + l_SX2 + &
           " CC_Line_2.Y2=" + l_SY2
l_Result = dw_1.Modify(l_Modify)

l_Modify = "CC_Line_3.X1="  + l_SX2 + &
           " CC_Line_3.Y1=" + l_SY2 + &
           " CC_Line_3.X2=" + l_SX1 + &
           " CC_Line_3.Y2=" + l_SY2
l_Result = dw_1.Modify(l_Modify)

l_Modify = "CC_Line_4.X1="  + l_SX1 + &
           " CC_Line_4.Y1=" + l_SY2 + &
           " CC_Line_4.X2=" + l_SX1 + &
           " CC_Line_4.Y2=" + l_SY1
l_Result = dw_1.Modify(l_Modify)

i_RectOn = TRUE
l_Result = dw_1.Modify(i_CCRectVis)

IF col_nbr >= 1 AND col_nbr <= i_CCDW.i_DWSRV_EDIT.i_NumColumns THEN
   l_Min  = Integer(dw_1.Describe("DataWindow.HorizontalScrollPosition"))
   l_Max  = l_Min + dw_1.Width
   l_New  = l_Min
   l_X1   = Integer(l_SX1)
   l_X2   = Integer(l_SX2)

   IF l_X1 + l_X2 > 2 * l_Max OR &
      l_X1 + l_X2 < 2 * l_Min THEN
      IF l_X1 < 10 THEN
         l_New = 0
      ELSE
         l_New = l_X1 - 10
      END IF

      l_Modify = "DataWindow.HorizontalScrollPosition=" + &
                 String(l_New)
      l_Result = dw_1.Modify(l_Modify)
   END IF

   l_Min = Integer(dw_1.Describe("DataWindow.VerticalScrollPosition"))
   l_Max = l_Min + i_RowHeight
   l_New = l_Min
   l_Y1  = Integer(l_SY1)
   l_Y2  = Integer(l_SY2)

   IF l_Y1 + l_Y2 > 2 * l_Max OR &
      l_Y1 + l_Y2 < 2 * l_Min THEN
      IF l_Y1 < 10 THEN
         l_New = 0
      ELSE
         l_New = l_Y1 - 10
      END IF

      l_Modify = "DataWindow.VerticalScrollPosition=" + &
                 String(l_New)
      l_Result = dw_1.Modify(l_Modify)
   END IF

END IF

IF c_CCBlinkTime > 0 THEN
   Timer(c_CCBlinkTime, THIS)
END IF

end subroutine

public subroutine fu_getbitmap (long bitmap, ref blob bitmap_blob, ref long bitmap_width, ref long bitmap_height);//******************************************************************
//  PC Module     : w_CC_Main
//  Subroutine    : fu_GetBitmap
//  Description   : Return the bitmap in a blob for the icons.
//
//  Parameters    : LONG Bitmap -
//                     Bitmap number.
//                  BLOB Bitmap_Blob -
//                     Bitmap contents.
//                  LONG Bitmap_Width -
//                     Width of the bitmap.
//                  LONG Bitmap_Height -
//                     Height of the bitmap.
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

INTEGER l_Size, l_Idx
ULONG   l_Bitmap[]

CHOOSE CASE bitmap
   CASE c_ExclamationBitmap
      l_Bitmap[] = c_ExclamationBMPData[]
      bitmap_width     = 35
      bitmap_height    = 34
   CASE c_InformationBitmap
      l_Bitmap[] = c_InformationBMPData[]
      bitmap_width     = 35
      bitmap_height    = 34
   CASE c_QuestionBitmap
      l_Bitmap[] = c_QuestionBMPData[]
      bitmap_width     = 35
      bitmap_height    = 34
   CASE c_StopSignBitmap
      l_Bitmap[] = c_StopSignBMPData[]
      bitmap_width     = 35
      bitmap_height    = 34
END CHOOSE

l_Size      = UpperBound(l_Bitmap[])
bitmap_blob = Blob(Fill(" ", 4 * l_Size))
FOR l_Idx  = 1 TO l_Size
   BlobEdit(bitmap_blob, 4 * (l_Idx - 1) + 1, l_Bitmap[l_Idx])
NEXT

end subroutine

public subroutine fu_setitem (long row_nbr, integer col_nbr, string value);//******************************************************************
//  PC Module     : w_CC_Main
//  Subroutine    : fu_SetItem
//  Description   : Sets a column value for a row in the DataWindow 
//                  based on the data type of the column.
//
//  Parameters    : LONG    Row_Nbr -
//                     The row that is to be updated.
//                  INTEGER Col_Nbr -
//                     The column to be updated.
//                  STRING  Value -
//                     The value to be updated.
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

INTEGER  l_Space
STRING   l_Type, l_Date, l_Time

//------------------------------------------------------------------
//  Determine the type of column.
//------------------------------------------------------------------

l_Type = Upper(dw_1.Describe("#" + String(col_nbr) + ".coltype"))
IF Left(l_Type, 4) = "CHAR" THEN
	l_Type = "CHAR"
END IF
IF Left(l_Type, 3) = "DEC" THEN
	l_Type = "DEC"
END IF

//------------------------------------------------------------------
//  Set the new value into the column.
//------------------------------------------------------------------

CHOOSE CASE l_Type

	CASE "DATE"

      dw_1.SetItem(row_nbr, col_nbr, Date(value))

	CASE "DATETIME"
 
      l_Space = Pos(value, " ")
  		IF l_Space > 0 THEN
     		l_Date = Mid(value, 1, l_Space - 1)
     		l_Time = Mid(value, l_Space + 1)
     		dw_1.SetItem(row_nbr, col_nbr, &
           	DateTime(Date(l_Date), Time(l_Time)))
  		ELSE
     		dw_1.SetItem(row_nbr, col_nbr, DateTime(Date(value)))
  		END IF

	CASE "DEC"

      dw_1.SetItem(row_nbr, col_nbr, Dec(value))

	CASE "NUMBER", "LONG", "ULONG", "REAL"

      dw_1.SetItem(row_nbr, col_nbr, Real(value))

	CASE "TIME", "TIMESTAMP"

      dw_1.SetItem(row_nbr, col_nbr, Time(value))

	CASE "BLOB"

 
	CASE ELSE

      dw_1.SetItem(row_nbr, col_nbr, value)

END CHOOSE

end subroutine

public subroutine fu_displaymessage (integer id);//******************************************************************
//  PC Module     : w_CC_Main
//  Subroutine    : fu_DisplayMessage
//  Description   : Display the concurrency error message.
//
//  Parameters    : STRING ID -
//                     Message id.
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

STRING   l_Text, l_ID
INTEGER  l_Icon, l_Idx
PICTURE  l_Picture

//-----------------------------------------------------------------
//  Set the message id.
//-----------------------------------------------------------------

CHOOSE CASE id
   CASE i_CCService.c_CCErrorNone
      l_ID = "CCNoError"
   CASE i_CCService.c_CCErrorNonOverlap
      IF IsNull(i_CCService.i_CCUser) <> FALSE THEN
         l_ID = "CCNonOverlapV"
      ELSE
         l_ID = "CCNonOverlapVUser"
      END IF
   CASE i_CCService.c_CCErrorOverlap, i_CCService.c_CCErrorOverlapMatch
      IF IsNull(i_CCService.i_CCUser) <> FALSE THEN
         l_ID = "CCOverlapV"
      ELSE
         l_ID = "CCOverlapVUser"
      END IF
   CASE i_CCService.c_CCErrorNonExistent
      IF i_CCDW.i_EnableCCInsert THEN
         IF IsNull(i_CCService.i_CCUser) <> FALSE THEN
            l_ID = "CCNonExist"
         ELSE
            l_ID = "CCNonExistUser"
         END IF
      ELSE
         IF IsNull(i_CCService.i_CCUser) <> FALSE THEN
            l_ID = "CCNonExistDrop"
         ELSE
            l_ID = "CCNonExistUserDrop"
         END IF
      END IF
   CASE i_CCService.c_CCErrorDeleteModified
      IF IsNull(i_CCService.i_CCUser) <> FALSE THEN
         l_ID = "CCDeleteModified"
      ELSE
         l_ID = "CCDeleteModifiedUser"
      END IF
   CASE i_CCService.c_CCErrorKeyConflict
      l_ID = "CCKeyConflictValue"
END CHOOSE

//-----------------------------------------------------------------
//  Display the message on the window.
//-----------------------------------------------------------------

l_Text = FWCA.MSG.fu_GetMessage(l_ID, FWCA.MSG.c_MSG_Text)
l_Icon = Integer(FWCA.MSG.fu_GetMessage(l_ID, FWCA.MSG.c_MSG_Icon))

IF IsNull(i_CCService.i_CCUser) = FALSE THEN
   l_Text = Replace(l_Text, Pos(l_Text, "%6s"), 3, i_CCService.i_CCUser)
END IF

st_ErrorType.Text = l_Text

//-----------------------------------------------------------------
//  Display the correct picture.
//-----------------------------------------------------------------

CHOOSE CASE l_Icon
   CASE FWCA.MSG.c_MSG_Information
      l_Picture = p_Information
   CASE FWCA.MSG.c_MSG_Stop
      l_Picture = p_StopSign
   CASE FWCA.MSG.c_MSG_Exclamation
      l_Picture = p_Exclamation
   CASE FWCA.MSG.c_MSG_Question
      l_Picture = p_Question
	CASE ELSE
		SetNull(l_Picture)
END CHOOSE

FOR l_Idx = 1 TO UpperBound(i_Icons[])
   IF IsNull(l_Picture) <> FALSE THEN
      IF i_Icons[l_Idx].Visible THEN
         i_Icons[l_Idx].Visible = FALSE
      END IF
   ELSE
      IF i_Icons[l_Idx] = l_Picture THEN
         IF NOT i_Icons[l_Idx].Visible THEN
            i_Icons[l_Idx].Visible = TRUE
         END IF
      ELSE
         IF i_Icons[l_Idx].Visible THEN
            i_Icons[l_Idx].Visible = FALSE
         END IF
      END IF
   END IF
NEXT

end subroutine

public subroutine fu_showerror (long col_nbr);//******************************************************************
//  PC Module     : w_CC_Main
//  Subroutine    : fu_ShowError
//  Description   : Show the current error in the window objects.
//
//  Parameters    : LONG Col_Nbr -
//                     Column number.
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

RADIOBUTTON  l_RB
STRING       l_ProtectMode

IF col_nbr < 1 THEN
   col_nbr = 1
END IF
IF col_nbr > i_NumCCList THEN
   col_nbr = i_NumCCList
END IF

i_CCError        = col_nbr

cb_First.Enabled = (i_CCError > 1)
cb_Prev.Enabled  = cb_First.Enabled
cb_Next.Enabled  = (i_CCError <> i_NumCCList)
cb_Last.Enabled  = cb_Next.Enabled

IF i_CCError > 0 THEN

   col_nbr = i_CCList[i_CCError]
   fu_SetRectSize(col_nbr)
   fu_DisplayMessage(i_CCService.i_CCColumnErrorCode[col_nbr])

   CHOOSE CASE i_CCService.i_CCColumnValue[col_nbr]
      CASE i_CCService.c_CCUseOldDB
         l_RB = rb_SaveOldDB
      CASE i_CCService.c_CCUseNewDB
         l_RB = rb_SaveNewDB
      CASE i_CCService.c_CCUseDWValue
         l_RB = rb_SaveEntered
      CASE i_CCService.c_CCUseSpecial
         l_RB = rb_SaveSpecial
   END CHOOSE

   l_RB.Checked = TRUE
   l_RB.TriggerEvent("Clicked")
END IF

//gb_ProcCode.Enabled = (i_CCDW.i_CCInfo[Error_Col].Error_Code <> &
//                       c_CCErrorNone)

rb_SaveOldDB.Enabled   = gb_ProcCode.Enabled
rb_SaveNewDB.Enabled   = gb_ProcCode.Enabled
rb_SaveEntered.Enabled = &
   ((i_CCService.i_CCOldDBValue[col_nbr] <> &
     i_CCService.i_CCDWValue[col_nbr]) OR &
    (i_CCService.i_CCColumnValue[col_nbr] = &
     i_CCService.c_CCUseDWValue)) AND &
    gb_ProcCode.Enabled
IF IsNull(i_CCService.i_CCSpecialValue[col_nbr]) <> FALSE THEN
   rb_SaveSpecial.Enabled = FALSE
	dw_1.Modify(i_ProtectMode)
ELSE
   rb_SaveSpecial.Enabled = gb_ProcCode.Enabled
	IF rb_SaveSpecial.Checked THEN
		l_ProtectMode = i_ProtectMode + "#" + String(col_nbr) + ".protect='0'~t"
		l_ProtectMode = l_ProtectMode + "#" + String(col_nbr) + ".tabsequence=10~t"
	ELSE
		l_ProtectMode = i_ProtectMode
	END IF
	dw_1.Modify(l_ProtectMode)
END IF

end subroutine

event open;call super::open;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : Open
//  Description   : Setup the columns with errors.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Idx
LONG     l_I_X,    l_I_Y
LONG     l_S_X,    l_S_Y
LONG     l_E_X,    l_E_Y
LONG     l_Q_X,    l_Q_Y
BLOB     l_Information
BLOB     l_StopSign
BLOB     l_Exclamation
BLOB     l_Question

IF Error.i_FWError <> c_Success THEN
   i_Abort = TRUE
   Close(THIS)
   RETURN
END IF

Title = i_CCDW.i_Window.Title

IF NOT i_RowLevelError THEN

   //---------------------------------------------------------------
   //  Make a list of all the columns that require user
   //  intervention.
   //---------------------------------------------------------------

   FOR l_Idx = 1 TO i_CCDW.i_DWSRV_EDIT.i_NumColumns
      IF i_CCService.i_CCColumnMethod[l_Idx] = i_CCService.c_CCMethodSpecify THEN
         i_NumCCList           = i_NumCCList + 1
         i_CCList[i_NumCCList] = l_Idx
      END IF
   NEXT

END IF

//------------------------------------------------------------------
//  Set up the Icons (e.g. Stopsign).
//------------------------------------------------------------------

i_Icons[1]                = p_Information
i_Icons[2]                = p_StopSign
i_Icons[3]                = p_Exclamation
i_Icons[4]                = p_Question

i_Icons[1].Enabled        = FALSE
i_Icons[1].Visible        = FALSE
i_Icons[1].FocusRectangle = FALSE

FOR l_Idx = 2 TO UpperBound(i_Icons[])
   i_Icons[l_Idx].X              = i_Icons[1].X
   i_Icons[l_Idx].Y              = i_Icons[1].Y
   i_Icons[l_Idx].Enabled        = i_Icons[1].Enabled
   i_Icons[l_Idx].Visible        = i_Icons[1].Visible
   i_Icons[l_Idx].Border         = i_Icons[1].Border
   i_Icons[l_Idx].BorderStyle    = i_Icons[1].BorderStyle
   i_Icons[l_Idx].FocusRectangle = i_Icons[1].FocusRectangle
NEXT

//------------------------------------------------------------------
//  Set up the Information! picture
//------------------------------------------------------------------

fu_GetBitmap(c_InformationBitmap, l_Information, l_I_X, l_I_Y)
p_Information.Resize(PixelsToUnits(l_I_X, XPixelsToUnits!), &
                     PixelsToUnits(l_I_Y, YPixelsToUnits!))
p_Information.SetPicture(l_Information)

//------------------------------------------------------------------
//  Set up the StopSign! picture
//------------------------------------------------------------------

fu_GetBitmap(c_StopSignBitmap, l_StopSign, l_S_X, l_S_Y)
p_StopSign.Resize(PixelsToUnits(l_S_X, XPixelsToUnits!), &
                  PixelsToUnits(l_S_Y, YPixelsToUnits!))
p_StopSign.SetPicture(l_StopSign)

//------------------------------------------------------------------
//  Set up the Exclamation! picture
//------------------------------------------------------------------

fu_GetBitmap(c_ExclamationBitmap, l_Exclamation, l_E_X, l_E_Y)
p_Exclamation.Resize(PixelsToUnits(l_E_X, XPixelsToUnits!), &
                     PixelsToUnits(l_E_Y, YPixelsToUnits!))
p_Exclamation.SetPicture(l_Exclamation)

//------------------------------------------------------------------
//  Set up the Question! picture
//------------------------------------------------------------------

fu_GetBitmap(c_QuestionBitmap, l_Question, l_Q_X, l_Q_Y)
p_Question.Resize(PixelsToUnits(l_Q_X, XPixelsToUnits!), &
                  PixelsToUnits(l_Q_Y, YPixelsToUnits!))
p_Question.SetPicture(l_Question)

//------------------------------------------------------------------
//  Show the first column in error.
//------------------------------------------------------------------

IF i_RowLevelError THEN
   fu_SetRectSize(0)
   fu_DisplayMessage(i_CCService.i_CCErrorCode)
ELSE
   fu_ShowError(1)
END IF
end event

event timer;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : Timer
//  Description   : Flashes the rectangle around the current column.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Result

IF i_RectOn THEN
   l_Result = dw_1.Modify(i_CCRectInvis)
ELSE
   l_Result = dw_1.Modify(i_CCRectVis)
END IF

i_RectOn = (NOT i_RectOn)
end event

event pc_first;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : pc_First
//  Description   : Scroll to the first column error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

fu_ShowError(1)
end event

event pc_last;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : pc_Last
//  Description   : Scroll to the last column error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

fu_ShowError(i_CCDW.i_DWSRV_EDIT.i_NumColumns)
end event

event pc_next;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : pc_Next
//  Description   : Scroll to the next column error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

fu_ShowError(i_CCError + 1)
end event

event pc_previous;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : pc_Previous
//  Description   : Scroll to the previous column error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

fu_ShowError(i_CCError - 1)
end event

event pc_setvariables;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : pc_SetVariables
//  Description   : Make sure we have a valid PowerClass DataWindow
//                  and check for the type of concurrency error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CCDW = Message.PowerObjectParm

IF IsValid(i_CCDW) THEN
	i_CCService = i_CCDW.i_DWSRV_CC
ELSE
   Error.i_FWError = c_Fatal
   RETURN
END IF

i_RowLevelError = (i_CCService.i_CCErrorCode = i_CCService.c_CCErrorNonExistent OR &
                   i_CCService.i_CCErrorCode = i_CCService.c_CCErrorDeleteModified)
end event

on w_cc_main.create
int iCurrent
call w_response_std::create
this.p_exclamation=create p_exclamation
this.p_information=create p_information
this.p_question=create p_question
this.p_stopsign=create p_stopsign
this.st_errortype=create st_errortype
this.gb_errortype=create gb_errortype
this.cb_first=create cb_first
this.cb_prev=create cb_prev
this.cb_next=create cb_next
this.cb_last=create cb_last
this.gb_movement=create gb_movement
this.rb_saveolddb=create rb_saveolddb
this.rb_savenewdb=create rb_savenewdb
this.rb_saveentered=create rb_saveentered
this.rb_savespecial=create rb_savespecial
this.gb_proccode=create gb_proccode
this.cb_yes=create cb_yes
this.cb_no=create cb_no
this.cb_cancel_cl=create cb_cancel_cl
this.dw_1=create dw_1
this.cb_ok=create cb_ok
this.cb_help=create cb_help
this.cb_cancel_rl=create cb_cancel_rl
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=p_exclamation
this.Control[iCurrent+2]=p_information
this.Control[iCurrent+3]=p_question
this.Control[iCurrent+4]=p_stopsign
this.Control[iCurrent+5]=st_errortype
this.Control[iCurrent+6]=gb_errortype
this.Control[iCurrent+7]=cb_first
this.Control[iCurrent+8]=cb_prev
this.Control[iCurrent+9]=cb_next
this.Control[iCurrent+10]=cb_last
this.Control[iCurrent+11]=gb_movement
this.Control[iCurrent+12]=rb_saveolddb
this.Control[iCurrent+13]=rb_savenewdb
this.Control[iCurrent+14]=rb_saveentered
this.Control[iCurrent+15]=rb_savespecial
this.Control[iCurrent+16]=gb_proccode
this.Control[iCurrent+17]=cb_yes
this.Control[iCurrent+18]=cb_no
this.Control[iCurrent+19]=cb_cancel_cl
this.Control[iCurrent+20]=dw_1
this.Control[iCurrent+21]=cb_ok
this.Control[iCurrent+22]=cb_help
this.Control[iCurrent+23]=cb_cancel_rl
end on

on w_cc_main.destroy
call w_response_std::destroy
destroy(this.p_exclamation)
destroy(this.p_information)
destroy(this.p_question)
destroy(this.p_stopsign)
destroy(this.st_errortype)
destroy(this.gb_errortype)
destroy(this.cb_first)
destroy(this.cb_prev)
destroy(this.cb_next)
destroy(this.cb_last)
destroy(this.gb_movement)
destroy(this.rb_saveolddb)
destroy(this.rb_savenewdb)
destroy(this.rb_saveentered)
destroy(this.rb_savespecial)
destroy(this.gb_proccode)
destroy(this.cb_yes)
destroy(this.cb_no)
destroy(this.cb_cancel_cl)
destroy(this.dw_1)
destroy(this.cb_ok)
destroy(this.cb_help)
destroy(this.cb_cancel_rl)
end on

event pc_close;call super::pc_close;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : pc_Close
//  Description   : Cleanup before closing the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Result

IF c_CCBlinkTime > 0 THEN
   Timer(0, THIS)
END IF

//------------------------------------------------------------------
//  Turn off the rectangle used for highlighting the columns in
//  error.
//------------------------------------------------------------------

IF IsValid(i_CCDW) THEN
   l_Result = dw_1.Modify(i_CCRectInvis)
END IF

end event

event pc_closequery;call super::pc_closequery;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : pc_CloseQuery
//  Description   : Determine if it is OK to close.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_ErrorStrings[]

IF i_Abort THEN
   IF IsValid(i_CCDW) THEN
      i_CCService.i_CCUserStatus = i_CCService.c_CCUserCancel
   END IF
   RETURN
END IF

IF NOT i_OkToClose THEN
  	l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = ClassName()
   l_ErrorStrings[4] = ""
   l_ErrorStrings[5] = "pc_CloseQuery"
   IF i_RowLevelError THEN
      l_ErrorStrings[6] = "~"YES~", ~"NO~", ~"CANCEL~""
   ELSE
      l_ErrorStrings[6] = "~"YES~", ~"NO~", ~"CANCEL~""
   END IF
   FWCA.MSG.fu_DisplayMessage("WindowCloseError", &
			                     6, l_ErrorStrings[])
   Error.i_FWError = c_Fatal
END IF
end event

event pc_setoptions;call super::pc_setoptions;//------------------------------------------------------------------
//  Set the window options.
//------------------------------------------------------------------

fw_SetOptions(c_NoLoadCodeTable + &
              c_NoEnablePopup   + &
              c_NoResizeWin     + &
              c_NoAutoMinimize  + &
              c_AutoPosition    + &
              c_NoSavePosition  + &
              c_CloseNoSave     + &
              c_ToolBarNone)

end event

type p_exclamation from picture within w_cc_main
int X=105
int Y=136
int Width=165
int Height=144
boolean Visible=false
boolean Enabled=false
boolean FocusRectangle=false
end type

type p_information from picture within w_cc_main
int X=101
int Y=136
int Width=165
int Height=144
boolean Enabled=false
boolean FocusRectangle=false
end type

type p_question from picture within w_cc_main
int X=101
int Y=136
int Width=165
int Height=144
boolean Visible=false
boolean Enabled=false
boolean FocusRectangle=false
end type

type p_stopsign from picture within w_cc_main
int X=105
int Y=136
int Width=165
int Height=144
boolean Visible=false
boolean Enabled=false
boolean FocusRectangle=false
end type

type st_errortype from statictext within w_cc_main
int X=311
int Y=136
int Width=1353
int Height=144
boolean Enabled=false
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_errortype from groupbox within w_cc_main
int X=46
int Y=24
int Width=1659
int Height=336
string Text="Concurrency Error"
BorderStyle BorderStyle=StyleRaised!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_first from commandbutton within w_cc_main
int X=82
int Y=484
int Width=137
int Height=104
int TabOrder=70
string Text="|<"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Parent.TriggerEvent("pc_First")
end event

type cb_prev from commandbutton within w_cc_main
int X=247
int Y=484
int Width=137
int Height=104
int TabOrder=80
string Text="<"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Parent.TriggerEvent("pc_Previous")
end event

type cb_next from commandbutton within w_cc_main
int X=416
int Y=484
int Width=137
int Height=104
int TabOrder=90
string Text=">"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Parent.TriggerEvent("pc_Next")
end event

type cb_last from commandbutton within w_cc_main
int X=581
int Y=484
int Width=137
int Height=104
int TabOrder=100
string Text=">|"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Parent.TriggerEvent("pc_Last")
end event

type gb_movement from groupbox within w_cc_main
int X=46
int Y=384
int Width=709
int Height=268
string Text="Column Selection"
BorderStyle BorderStyle=StyleRaised!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type rb_saveolddb from radiobutton within w_cc_main
int X=832
int Y=464
int Width=727
int Height=72
string Text="Original Database Value"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PC Module     : w_CC_Main.rb_SaveOldDB
//  Event         : Clicked
//  Description   : Choose the old database value.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1995-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_ErrorNbr

IF i_CCError > 0 THEN
 	dw_1.Modify(i_ProtectMode)
   l_ErrorNbr = i_CCList[i_CCError]
   i_CCService.i_CCColumnValue[l_ErrorNbr] = i_CCService.c_CCUseOldDB
   fu_SetItem(1, l_ErrorNbr, i_CCService.i_CCOldDBValue[l_ErrorNbr])
END IF
end event

type rb_savenewdb from radiobutton within w_cc_main
int X=832
int Y=548
int Width=645
int Height=72
string Text="New Database Value"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PC Module     : w_CC_Main.rb_SaveNewDB
//  Event         : Clicked
//  Description   : Choose the new database value.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1995-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_ErrorNbr

IF i_CCError > 0 THEN
  	dw_1.Modify(i_ProtectMode)
   l_ErrorNbr = i_CCList[i_CCError]
   i_CCService.i_CCColumnValue[l_ErrorNbr] = i_CCService.c_CCUseNewDB
   fu_SetItem(1, l_ErrorNbr, i_CCService.i_CCNewDBValue[l_ErrorNbr])
END IF
end event

type rb_saveentered from radiobutton within w_cc_main
int X=1577
int Y=464
int Width=466
int Height=72
string Text="Entered Value"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PC Module     : w_CC_Main.rb_SaveEntered
//  Event         : Clicked
//  Description   : Choose the entered DataWindow value.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1995-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_ErrorNbr

IF i_CCError > 0 THEN
 	dw_1.Modify(i_ProtectMode)
   l_ErrorNbr = i_CCList[i_CCError]
   i_CCService.i_CCColumnValue[l_ErrorNbr] = i_CCService.c_CCUseDWValue
   fu_SetItem(1, l_ErrorNbr, i_CCService.i_CCDWValue[l_ErrorNbr])
END IF
end event

type rb_savespecial from radiobutton within w_cc_main
int X=1577
int Y=548
int Width=471
int Height=72
string Text="Alternate Value"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PC Module     : w_CC_Main.rb_SaveSpecial
//  Event         : Clicked
//  Description   : Choose an alternate value.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1995-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_ErrorNbr
STRING   l_ProtectMode

IF i_CCError > 0 THEN
	l_ProtectMode = i_ProtectMode + "#" + String(i_CCList[i_CCError]) + ".protect='0'~t"
	l_ProtectMode = l_ProtectMode + "#" + String(i_CCList[i_CCError]) + ".tabsequence=10~t"
	dw_1.Modify(l_ProtectMode)

   l_ErrorNbr = i_CCList[i_CCError]
   i_CCService.i_CCColumnValue[l_ErrorNbr] = i_CCService.c_CCUseSpecial
   fu_SetItem(1, l_ErrorNbr, i_CCService.i_CCSpecialValue[l_ErrorNbr])
END IF
end event

type gb_proccode from groupbox within w_cc_main
int X=777
int Y=384
int Width=1303
int Height=268
string Text="Value to be Saved"
BorderStyle BorderStyle=StyleRaised!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_yes from commandbutton within w_cc_main
int X=1765
int Y=52
int Width=311
int Height=92
int TabOrder=30
string Text="&Yes"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;//******************************************************************
//  PC Module     : w_CC_Main.CB_Yes
//  Event         : Clicked
//  Description   : 
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1995-1996.  All Rights Reserved.
//******************************************************************

i_CCService.i_CCRowValue   = i_CCService.c_CCUseDWValue
i_CCService.i_CCUserStatus = i_CCService.c_CCUserOK
i_OkToClose = TRUE

Close(PARENT)
end on

type cb_no from commandbutton within w_cc_main
int X=1765
int Y=160
int Width=311
int Height=92
int TabOrder=40
string Text="&No"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PC Module     : w_CC_Main.CB_No
//  Event         : Clicked
//  Description   : 
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1995-1996.  All Rights Reserved.
//******************************************************************

i_CCService.i_CCRowValue   = i_CCService.c_CCUseNewDB
i_CCService.i_CCUserStatus = i_CCService.c_CCUserOK
i_Abort = TRUE
i_OkToClose = TRUE

Close(PARENT)
end event

type cb_cancel_cl from commandbutton within w_cc_main
int X=1765
int Y=160
int Width=311
int Height=92
int TabOrder=60
string Text="Cancel"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PC Module     : w_CC_Main.cb_Cancel_cl
//  Event         : pc_Cancel
//  Description   : Cancels the error handling process.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CCService.i_CCUserStatus = i_CCService.c_CCUserCancel
i_OkToClose = TRUE

Close(Parent)
end event

type dw_1 from u_dw_main within w_cc_main
int X=46
int Y=704
int Width=2034
int Height=836
int TabOrder=0
string DataObject=""
boolean HScrollBar=true
boolean VScrollBar=true
end type

event pcd_setoptions;call super::pcd_setoptions;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : pcd_SetOptions
//  Description   : Setup the DataWindow for error handling.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER          l_OrigWidth,   l_OrigHeight
INTEGER          l_Check,       l_NumStyles
INTEGER          l_Idx,         l_Jdx,              l_Kdx
STRING           l_CCRectColor, l_CreateLine,       l_Col
STRING           l_Describe,    l_Modify,           l_Result
STRING           l_EditStyles[], l_Name
BOOLEAN          l_Move
DATAWINDOWCHILD  l_DWC1,        l_DWC2

dw_1.DataObject   = i_CCDW.DataObject

//------------------------------------------------------------------
//  We can not find out what edit style the column is from
//  PowerBuilder.  Therefore, we have to cycle through all the
//  possible types seeing if we get a valid response.  Set up
//  an array containing all known styles.
//------------------------------------------------------------------

l_EditStyles[1] = ".Edit"
l_EditStyles[2] = ".DDDW"
l_EditStyles[3] = ".DDLB"
l_EditStyles[4] = ".EditMask"
//l_EditStyles[5] = ".CheckBox"
//l_EditStyles[6] = ".RadioButton"
l_NumStyles     = UpperBound(l_EditStyles[])

//------------------------------------------------------------------
//  For each edit style that we know about, see if this column
//  will respond to a DESCRIBE().
//------------------------------------------------------------------

i_ProtectMode = ""
FOR l_Idx = 1 TO i_CCDW.i_DWSRV_EDIT.i_NumColumns

   l_Col = "#" + String(l_Idx)
	l_Name = dw_1.Describe(l_Col + ".name")

	IF i_CCDW.Describe(l_Col + ".visible") <> "0" THEN
		i_ProtectMode = i_ProtectMode + l_Col + ".protect='1'~t"
		i_ProtectMode = i_ProtectMode + l_Col + ".tabsequence=0~t"
	END IF

   FOR l_Jdx = 1 TO l_NumStyles
      l_Describe = l_Col + l_EditStyles[l_Jdx] + ".Required"
      l_Result   = Upper(i_CCDW.Describe(l_Describe))
      IF l_Result <> "?" THEN

         //---------------------------------------------------------
         //  The column responded.  Now, load the code tables for
         //  it.
         //---------------------------------------------------------

         CHOOSE CASE l_EditStyles[l_Jdx]

            //------------------------------------------------------
            //  Share the code tables for DDDW's.
            //------------------------------------------------------

            CASE ".DDDW"
               i_CCDW.GetChild(l_Name, l_DWC1)
               GetChild(l_Name, l_DWC2)
               l_DWC2.SetTransObject(i_CCDW.i_DBCA)
               l_DWC1.ShareData(l_DWC2)

            //------------------------------------------------------
            //  Copy the code tables for DDLB's.
            //------------------------------------------------------

            CASE ".DDLB"
               l_Kdx    = 1
               l_Result = i_CCDW.GetValue(l_Idx, l_Kdx)
               DO WHILE l_Result <> ""
                  SetValue(l_Idx, l_Kdx, l_Result)
                  l_Kdx    = l_Kdx + 1
                  l_Result = i_CCDW.GetValue(l_Idx, l_Kdx)
               LOOP

            //------------------------------------------------------
            //  EditMasks have code tables, but PowerBuilder does
            //  not support loading them dynamically.
            //------------------------------------------------------

            CASE ".EditMask"

            //------------------------------------------------------
            //  Edit, CheckBox, and RadioButton styles don't
            //  support code tables.
            //------------------------------------------------------

            //CASE ".Edit"
            CASE ELSE
         END CHOOSE
      END IF
   NEXT
NEXT

//------------------------------------------------------------------
//  We need to create a rectangle on the DataWindow that is used
//  to highlight the current column.
//------------------------------------------------------------------

l_CreateLine = 'Create Line ('         + &
               ' Band=Detail'          + &
               ' X1="-2" Y1="-2"'      + &
               ' X2="-1" Y2="-1"'      + &
               ' Pen.Style="0"'        + &
               ' Pen.Width="5"'        + &
               ' Background.Mode="2"'  + &
               ' Background.Color="0"' + &
               ' Name=CC_Line_'

l_Modify     = ""
FOR l_Idx = 1 TO 4
   l_Modify = l_Modify + l_CreateLine + String(l_Idx) + ') '
NEXT

l_Result = Modify(l_Modify)

i_CCRectVis   = ""
i_CCRectInvis = ""
l_CCRectColor = String(i_CCDW.i_CCErrorColor)

FOR l_Idx = 1 TO 4
   l_Result      = "CC_Line_"  + String(l_Idx)
   i_CCRectVis   = i_CCRectVis + l_Result + &
                   ".Visible='0~tIf(GetRow()=1,1,0)' "
   i_CCRectInvis = i_CCRectInvis + &
                   l_Result + ".Visible=0 "

   //---------------------------------------------------------------
   //  Just in case the color changed, send it down again.
   //---------------------------------------------------------------

   l_Modify = l_Result + ".Pen.Color=" + l_CCRectColor
   l_Result = Modify(l_Modify)
NEXT

l_Check = i_CCDW.RowsCopy(i_CCService.i_CCUserRow, &
                          i_CCService.i_CCUserRow, &
                          Primary!, dw_1, 1, Primary!)

SetItemStatus(1, 0, Primary!, DataModified!)
SetItemStatus(1, 0, Primary!, NotModified!)

//------------------------------------------------------------------
//  Delete the row that was used for user intervention.
//------------------------------------------------------------------

i_CCDW.DeleteRow(i_CCService.i_CCUserRow)

//------------------------------------------------------------------
//  Position the DataWindow.
//------------------------------------------------------------------

l_Move = FALSE
l_OrigHeight = Height
l_OrigWidth  = Width

IF i_CCDW.Height < Height THEN
	Height = i_CCDW.Height
	IF NOT i_CCDW.VScrollBar THEN VScrollBar = FALSE
	l_Move = TRUE
END IF

IF i_CCDW.Width < Width THEN
	Width = i_CCDW.Width
	IF NOT i_CCDW.HScrollBar THEN HScrollBar = FALSE
	l_Move = TRUE
END IF

IF l_Move THEN
   Move(X + ((l_OrigWidth - Width) / 2), Y + ((l_OrigHeight - Height) / 2))
END IF

//------------------------------------------------------------------
//  Set the controls based on the type of error.
//------------------------------------------------------------------

IF i_RowLevelError THEN

   cb_First.Visible       = FALSE
   cb_Prev.Visible        = FALSE
   cb_Next.Visible        = FALSE
   cb_Last.Visible        = FALSE
   gb_Movement.Visible    = FALSE
   rb_SaveOldDB.Visible   = FALSE
   rb_SaveNewDB.Visible   = FALSE
   rb_SaveEntered.Visible = FALSE
   rb_SaveSpecial.Visible = FALSE
   gb_ProcCode.Visible    = FALSE
   cb_Ok.Visible          = FALSE
   cb_Cancel_CL.Visible   = FALSE
   cb_Help.Visible        = FALSE

   st_ErrorType.Height    = st_ErrorType.Height + &
                               (Y - gb_Movement.Y)
   gb_ErrorType.Height    = gb_ErrorType.Height + &
                               (Y - gb_Movement.Y)

   IF i_CCService.i_CCErrorCode = i_CCService.c_CCErrorNonExistent THEN
   	IF NOT i_CCDW.i_EnableCCInsert THEN
      	cb_Yes.Enabled = FALSE
   	END IF
   END IF
ELSE
   cb_Yes.Visible       = FALSE
   cb_No.Visible        = FALSE
   cb_Cancel_RL.Visible = FALSE
END IF
end event

event itemchanged;call super::itemchanged;//******************************************************************
//  PC Module     : w_CC_Main
//  Event         : ItemChanged
//  Description   : Save the alternative value.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF rb_savespecial.Checked THEN
	i_CCService.i_CCSpecialValue[i_CCList[i_CCError]] = data
END IF
end event

type cb_ok from commandbutton within w_cc_main
int X=1765
int Y=52
int Width=311
int Height=92
int TabOrder=50
string Text="OK"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PC Module     : w_CC_Main.CB_Ok
//  Event         : Clicked
//  Description   : Allow the window to close.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1995-1996.  All Rights Reserved.
//******************************************************************

i_CCService.i_CCUserStatus = i_CCService.c_CCUserOK
i_OkToClose = TRUE

Close(PARENT)
end event

type cb_help from commandbutton within w_cc_main
int X=1765
int Y=268
int Width=311
int Height=92
int TabOrder=10
boolean BringToTop=true
string Text="&Help"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PC Module     : w_CC_Main.CB_Help
//  Event         : Clicked
//  Description   : Display help on the type of error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1995-1996.  All Rights Reserved.
//******************************************************************

STRING l_ErrorStrings[]

l_ErrorStrings[1] = "PowerClass Help"
l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
l_ErrorStrings[3] = Parent.ClassName()
l_ErrorStrings[4] = ClassName()
l_ErrorStrings[5] = "Clicked"

IF i_CCError > 0 THEN
   CHOOSE CASE i_CCService.i_CCColumnErrorCode[i_CCList[i_CCError]]
      CASE i_CCService.c_CCErrorNone
    		FWCA.MSG.fu_DisplayMessage("CCNonErrorHelp", &
			                           5, l_ErrorStrings[])
      CASE i_CCService.c_CCErrorNonOverlap
    		FWCA.MSG.fu_DisplayMessage("CCNonOverlapHelp", &
			                           5, l_ErrorStrings[])
      CASE i_CCService.c_CCErrorOverlap, i_CCService.c_CCErrorOverlapMatch
    		FWCA.MSG.fu_DisplayMessage("CCOverlapHelp", &
			                           5, l_ErrorStrings[])
      CASE i_CCService.c_CCErrorKeyConflict
    		FWCA.MSG.fu_DisplayMessage("CCKeyConflictHelp", &
			                           5, l_ErrorStrings[])
      CASE ELSE
   END CHOOSE
END IF
end event

type cb_cancel_rl from commandbutton within w_cc_main
int X=1765
int Y=268
int Width=311
int Height=92
int TabOrder=20
string Text="Cancel"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PC Module     : w_CC_Main.cb_Cancel_rl
//  Event         : pc_Cancel
//  Description   : Cancels the error handling process.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CCService.i_CCUserStatus = i_CCService.c_CCUserCancel
i_OkToClose = TRUE

Close(Parent)
end event

