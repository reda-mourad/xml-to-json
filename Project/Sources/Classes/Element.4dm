property dom_name:=""
property dom_children:=[]


Class constructor($name : Text; $parent : cs.Element)
	This.dom_name:=$name
	If ($parent#Null)
		$parent.dom_children.push(This)
	End if 
	
	
Function exportToFile($file : 4D.File)
	$file.setText(This.exportToText())
	
	
Function exportToText() : Text
	var $child : cs.Element
	var $xml; $refChild; $ref; $key : Text
	var $fn : 4D.Function
	
	$ref:=DOM Create XML Ref(This.dom_name)
	
	$fn:=This.convertType
	If ($fn#Null)
		$fn.call(This)
	End if 
	
	For each ($key; OB Keys(This).filter(Formula(($1.value#"dom_@") && ($1.value#"_@"))))
		DOM SET XML ATTRIBUTE($ref; $key; This[$key])
	End for each 
	
	For each ($child; This.dom_children)
		$xml:=$child.exportToText()
		$refChild:=DOM Parse XML variable($xml)
		$refChild:=DOM Append XML element($ref; $refChild)
	End for each 
	
	DOM EXPORT TO VAR($ref; $xml)
	DOM CLOSE XML($ref)
	return $xml
	
	
Function parseXML($ref : Text)
	var $att; $val : Text
	var $child : cs.Element
	
	DOM GET XML ELEMENT NAME($ref; $val)
	This.dom_name:=$val
	
	For ($i; 1; DOM Count XML attributes($ref))
		
		DOM GET XML ATTRIBUTE BY INDEX($ref; $i; $att; $val)
		This[$att]:=$val
		
	End for 
	
	ARRAY INTEGER($_types; 0)
	ARRAY TEXT($_nodes; 0)
	DOM GET XML CHILD NODES($ref; $_types; $_nodes)
	
	For ($i; 1; Size of array($_nodes))
		
		If ($_types{$i}=XML ELEMENT)
			
			$child:=cs.Element.new()
			$child.parseXML($_nodes{$i})
			This.dom_children.push($child)
			
		End if 
		
	End for 
	
	
Function parseFile($file : 4D.File)
	var $ref:=DOM Parse XML source($file.platformPath)
	This.parseXML($ref)
	DOM CLOSE XML($ref)