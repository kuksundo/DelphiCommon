unit UnitJsonUtil;

interface

uses SysUtils, Classes,
  mormot.core.base, mormot.core.data, mormot.core.variants, mormot.core.unicode,
  mormot.core.text, mormot.core.datetime, mormot.core.json,
  ArrayHelper;

//function GetDiffBetweenXlsNDB(AXlsJson, ADBJson: RawUtf8): RawUtf8;
function GetValueFromJsonDictByKeyName(AJson, AKeyName: string): string;
function GetJsonAryFromStrAry(const AAry: array of string): string;
function GetJsonAryFromStrAry2D(const AAry: TStrArray2D): string;

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

function GetJsonAryFromStrAry(const AAry: array of string): string;
var
  LDoc: TDocVariantData;
  i: integer;
begin
  LDoc.InitArray([], mFast); //Json 배열 초기화

  for i := Low(AAry) to High(AAry) do
    LDoc.AddItemText(AAry[i]);

  Result := LDoc.ToJson;
end;

function GetJsonAryFromStrAry2D(const AAry: TStrArray2D): string;
var
  LList: IDocList;
  LJsonAry: RawUtf8;
  LRowCount, i: integer;
begin
  LList := DocList('[]');
  LRowCount := Length(AAry);

  for i := 0 to LRowCount - 1 do
  begin
    LJsonAry := GetJsonAryFromStrAry(AAry[i]);
    LList.Append(LJsonAry);
  end;

  Result := LList.Json;
end;

end.
