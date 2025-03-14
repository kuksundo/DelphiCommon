unit UnitHtmlUtil;

interface

uses SysUtils;

//Tag = 'form'
//Text = '<td><form method=''GET'' action="COM01121.tgz">'#$D#$A'<input type=''submit'' name=& value="Download Backup">'#$D#$A'</form>
//Result = '#$D#$A'<input type=''submit'' name=& value="Download Backup">'#$D#$A'
function ExtractTextInsideGivenTagEx(const Tag, Text: string): string;
function ExtractTextInsideGivenTagNth(const Tag, Text: string; const Nth: integer=1): string;
//Tag = 'form'
//Text = '<td><form method=''GET'' action="COM01121.tgz">'#$D#$A'<input type=''submit'' name=& value="Download Backup">'#$D#$A'</form>
//Result = '<form method=''GET'' action="COM01121.tgz">'#$D#$A'<input type=''submit'' name=& value="Download Backup">'#$D#$A'</form>'
function ExtractTagAndTextInsideGivenTagEx(const Tag, Text: string): string;
function ExtractTagAndTextInsideGivenTagNth(const Tag, Text: string; const Nth: integer): string;
//ATag : '</table>'
function GetTagCountFromHtml(const ATag, AHtml: string): integer;
//Tag내에서 속성 이름에 해당하는 값을 읽어 옴
//ATag : <input type=''text'' name=& size=''16'' maxlength=''16'' value=''MPM11P''>
//AAttrName: "Value"
//Result: "MPM11P"
function GetAttrValueInHtmlTagByAttrName(const ATag, AAttrName, AEndDelim: string): string;

implementation

uses UnitStringUtil;

function ExtractTextInsideGivenTagEx(const Tag, Text: string): string;
var
  StartPos1, StartPos2, EndPos: integer;
  i: Integer;
begin
  result := '';
  StartPos1 := Pos('<' + Tag, Text);
  EndPos := Pos('</' + Tag + '>', Text);
  StartPos2 := 0;
  for i := StartPos1 + length(Tag) + 1 to EndPos do
    if Text[i] = '>' then
    begin
      StartPos2 := i + 1;
      break;
    end;

  if (StartPos2 > 0) and (EndPos > StartPos2) then
    result := Copy(Text, StartPos2, EndPos - StartPos2);
end;

function ExtractTextInsideGivenTagNth(const Tag, Text: string; const Nth: integer=1): string;
var
  StartPos1, StartPos2, EndPos: integer;
  i: Integer;
begin
  result := '';
  StartPos1 := NthPos('<' + Tag, Text, Nth);
  EndPos := NthPos('</' + Tag + '>', Text, Nth);
  StartPos2 := 0;

  for i := StartPos1 + length(Tag) + 1 to EndPos do
    if Text[i] = '>' then
    begin
      StartPos2 := i + 1;
      break;
    end;

  if (StartPos2 > 0) and (EndPos > StartPos2) then
    result := Copy(Text, StartPos2, EndPos - StartPos2);
end;

function ExtractTagAndTextInsideGivenTagEx(const Tag, Text: string): string;
var
  StartPos, EndPos: integer;
begin
  result := '';
  StartPos := Pos('<' + Tag, Text);
  EndPos := Pos('</' + Tag + '>', Text);

  if (StartPos > 0) and (EndPos > StartPos) then
    result := Copy(Text, StartPos, EndPos - StartPos + length(Tag) + 3);
end;

function ExtractTagAndTextInsideGivenTagNth(const Tag, Text: string; const Nth: integer): string;
var
  StartPos, EndPos: integer;
begin
  result := '';

  if Nth < 1 then
    exit;

  StartPos := NthPos('<' + Tag, Text, Nth);
  EndPos := NthPos('</' + Tag + '>', Text, Nth);

  if (StartPos > 0) and (EndPos > StartPos) then
    result := Copy(Text, StartPos, EndPos - StartPos + length(Tag) + 3);
end;

function GetTagCountFromHtml(const ATag, AHtml: string): integer;
begin
  Result := GetWordCountInText(AHtml, ATag);
end;

function GetAttrValueInHtmlTagByAttrName(const ATag, AAttrName, AEndDelim: string): string;
var
  PosStart, PosEnd, AttrLength: integer;
  LStr: string;
begin
  Result := '';

  AttrLength := Length(AAttrName);

  //find the start position of the attr
  PosStart := Pos(LowerCase(AAttrName) + '=', LowerCase(ATag));

  if PosStart = 0 then
    exit; //Attr Not found

  //Move to the actual start of the value
  PosStart := PosStart + AttrLength + 1;

  //Find the ending quote of the attr name
  LStr := Copy(ATag, PosStart, Length(ATag) - PosStart + 1);

  Result := ExtractTextBetweenDelim(LStr, AEndDelim, AEndDelim);

//  PosEnd := Pos(AEndDelim, LStr);
//
//  if PosEnd > 0 then
//    Result := Copy(ATag, PosStart, PosEnd - 1);
end;

end.
