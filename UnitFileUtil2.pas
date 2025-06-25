unit UnitFileUtil2;

interface

uses Winapi.Windows, System.Classes, System.SysUtils, System.DateUtils,
  mormot.core.base, mormot.core.os, mormot.core.variants,
  UnitFileInfoUtil;

//AList : Full Path FileName List
//결과값은 [{"Name": "", "Path": "", "Version": ""},...]
function GetFileVersion2JsonAryByPJVerInfoFromList(AList: TStringList): string;

implementation

function GetFileVersion2JsonAryByPJVerInfoFromList(AList: TStringList): string;
var
  i: integer;
  LList: IDocList;
  LDict: IDocDict;
  LName, LPath, LVersion: RawUtf8;
begin
  Result := '';

  i := GetFileVersionListByPJVerInfoFromList(AList);

  if i <> -1 then
  begin
    LList := DocList('[]');
    LDict := DocDict('{}');

    for i := 0 to AList.Count - 1 do
    begin

      LName := ExtractFileName(AList.Names[i]);
      LPath := ExtractFilePath(AList.Names[i]);
      LVersion := AList.ValueFromIndex[i];

      LDict.S['Name'] := LName;
      LDict.S['Path'] := LPath;
      LDict.S['Version'] := LVersion;

      LList.AppendDoc(LDict);
      LDict.Clear;
    end;

    Result := Utf8ToString(LList.Json);
  end;
end;

end.
