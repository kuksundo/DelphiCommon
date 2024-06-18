unit UnitOutlookUtil2;

interface

//AOLFolderFullPath: '\\aaa@hd.com\f1\f2\f3'
//ANthLevel: 2 => Result = '\\aaa@hd.com\f1\f2\'
//           3 => Result = '\\aaa@hd.com\f1\f2\f3\'
function GetFolderNameOfNthLevel(AOLFolderFullPath: string; ANthLevel: integer): string;

implementation

uses UnitStringUtil;

function GetFolderNameOfNthLevel(AOLFolderFullPath: string; ANthLevel: integer): string;
var
  LStr: string;
  i: integer;
begin
  for i := 0 to ANthLevel do
  begin
    if i = 0 then
    begin
      LStr := StrToken(AOLFolderFullPath, '\');
      LStr := StrToken(AOLFolderFullPath, '\');
      LStr := StrToken(AOLFolderFullPath, '\');//메일주소
      Result := '\\' + LStr;
    end;

    LStr := StrToken(AOLFolderFullPath, '\');

    if LStr <> '' then
      Result := Result + '\' + LStr;
  end;
end;

end.
