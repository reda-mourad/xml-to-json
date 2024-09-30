# Usage Examples


```4D
//create an xml element "companies"
var $companies:=cs.XmlToJson.Element.new("companies")

//creates a child elemnt through the constructor
var $4d:=cs.XmlToJson.Element.new("company"; $companies)
// adding some attributes
$4d.name:="4D Morocco"
$4d.city:="Rabat"

var $employee:=cs.XmlToJson.Element.new("employee"; $4d)
$employee.first_name:="Reda"
$employee.last_name:="Mourad"

var $apple:=cs.XmlToJson.Element.new("company")
$apple.name:="Apple Inc."
$apple.city:="Cupertino"

//child nodes of an element can also be manipulated through the 'dom_children' property
$companies.dom_children.push($apple)

//finally you can export the xml to text
$xml:=$companies.exportToText()

//or directly into a file
var $exportFile:=Folder(fk desktop folder).file("companies.xml")
$companies.exportToFile($exportFile)
```

Output:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<companies>
  <company city="Rabat" name="4D Morocco">
    <employee first_name="Reda" last_name="Mourad" />
  </company>
  <company city="Cupertino" name="Apple Inc." />
</companies>
```
