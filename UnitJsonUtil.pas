unit UnitJsonUtil;

interface

uses SysUtils, Classes,
  mormot.core.base, mormot.core.data, mormot.core.variants, mormot.core.unicode,
  mormot.core.text, mormot.core.datetime;

//function GetDiffBetweenXlsNDB(AXlsJson, ADBJson: RawUtf8): RawUtf8;
function GetValueFromJsonDictByKeyName(AJson, AKeyName: string): string;

implementation

function GetValueFromJsonDictByKeyName(AJson, AKeyName: string): string;
var
  LDict: IDocDict;
begin
  Result := '';

  if AJson = '' then
    exit;

  if AKeyName = '' then
    exit;

  LDict := DocDict(AJson);

  if LDict.Exists(AKeyName) then
    Result := LDict[AKeyName];
end;

end.
