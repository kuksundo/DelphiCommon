unit UnitXMLUtil;

interface

uses Xml.XmlIntf, XMLDoc, System.SysUtils;

function ExtractSpecificXmlTag(const AFileName: string; const ATagName: string): string;

implementation

function ExtractSpecificXmlTag(const AFileName: string; const ATagName: string): string;
var
  LXMLDoc: IXMLDocument;
  LRoot, LChild: IXMLNode;
  i, j: integer;
begin
  LXMLDoc := LoadXMLDocument(AFileName);
  LXMLDoc.Active := True;

  LRoot := LXMLDoc.DocumentElement;

  for i := 0 to LRoot.ChildNodes.Count - 1 do
  begin
    LChild := LRoot.ChildNodes[i];

    if SameText(LChild.NodeName, ATagName) then
    begin
//      Result := LChild.NodeName;
      Result := LChild.Text;

//      if LChild.HasAttribute() then
//      begin
//        for j := 0 to LChild.AttibuteNodes.Count - 1 do
//        begin
//          Result := Result + LChild.AttibuteNodes[j].NodeName +
//                LChild.AttibuteNodes[j].Text;
//        end;
//      end;
    end;
  end;

end;

end.
