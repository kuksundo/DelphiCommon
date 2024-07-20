unit UnitHtmlUtil;

interface

function ExtractTextInsideGivenTagEx(const Tag, Text: string): string;
function ExtractTagAndTextInsideGivenTagEx(const Tag, Text: string): string;

implementation

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

end.
