$PBExportHeader$n_xml.sru
forward
global type n_xml from oleobject
end type
end forward

global type n_xml from oleobject
end type
global n_xml n_xml

forward prototypes
public function boolean appendxml (oleobject parentnode, string s_xml)
public function boolean clonechildnodes (boolean deep, ref oleobject oldparent, ref oleobject newparent)
end prototypes

public function boolean appendxml (oleobject parentnode, string s_xml);boolean b_Result
n_xml XMLDOM
oleobject Node

XMLDOM = CREATE n_xml
	
b_Result = XMLDOM.loadXML( s_xml )
IF NOT b_Result THEN 
	goto EndOfMethod
end if

Node = XMLDOM.documentElement
//Node = XMLDOM.selectSingleNode('*')
IF IsNull(Node) OR NOT IsValid(Node) THEN
	b_Result = FALSE
	goto EndOfMethod
end if

b_Result = cloneChildNodes(TRUE,Node,parentnode)

EndOfMethod:

DESTROY XMLDOM
RETURN b_Result
	

end function

public function boolean clonechildnodes (boolean deep, ref oleobject oldparent, ref oleobject newparent);IF IsNull(oldparent) or NOT IsValid(oldparent) or IsNull(newparent) or NOT IsValid(newparent) THEN RETURN FALSE

integer i, i_length
oleobject NodeList

//NodeList = oldparent.cloneNode(deep).childNodes
NodeList = oldparent.cloneNode(deep).selectNodes('*')
i_length = NodeList.length
IF i_length < 1 THEN RETURN TRUE

FOR i = 0 to i_length -1
	newparent.appendChild(NodeList.item(i))
NEXT

RETURN TRUE
end function

event constructor;//ConnectToNewObject("Microsoft.FreeThreadedXMLDOM")
ConnectToNewObject("Microsoft.XMLDOM")
//this.async = false
end event

on n_xml.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xml.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//GarbageCollect()
end event

