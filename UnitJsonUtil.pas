unit UnitJsonUtil;

interface

uses SysUtils, Classes,
  mormot.core.base, mormot.core.data, mormot.core.variants, mormot.core.unicode,
  mormot.core.text, mormot.core.datetime, mormot.core.json,
  ArrayHelper;

//function GetDiffBetweenXlsNDB(AXlsJson, ADBJson: RawUtf8): RawUtf8;
function GetValueFromJsonDictByKeyName(AJson, AKeyName: string): string;
function GetJsonAryFromStrAry(const AAry: array of string): string;
function GetJsonAryFromTArray(const AAry: TArray<string>): string;
function GetJsonAryFromStrAry2D(const AAry: TStrArray2D): string;
function GetJsonAryFromStringList(const StrList: TStringList; const AUseName: Boolean=False): string;
//AUseName : True => Name=Value 형식으로 저장 되므로 Name만 TArray에 저장함
function StringListToArray(const StrList: TStringList; const AUseName: Boolean=False): TArray<string>;

function GetFieldValueFromJsonAry(AJsonAry, AKeyName: RawUtf8; ARowIndex: integer=0): RawUtf8;

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

function GetJsonAryFromTArray(const AAry: TArray<string>): string;
begin
  Result := GetJsonAryFromStrAry(AAry);
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

function GetJsonAryFromStringList(const StrList: TStringList; const AUseName: Boolean): string;
var
  LAry: TArray<string>;
begin
  LAry := StringListToArray(StrList, AUseName);
  Result := GetJsonAryFromTArray(LAry);
end;

function StringListToArray(const StrList: TStringList; const AUseName: Boolean): TArray<string>;
var
  I: Integer;
begin
  SetLength(Result, StrList.Count);
  for I := 0 to StrList.Count - 1 do
  begin
    if AUseName then
      Result[I] := StrList.Names[I]
    else
      Result[I] := StrList[I];
  end;
end;

function GetFieldValueFromJsonAry(AJsonAry, AKeyName: RawUtf8; ARowIndex: integer): RawUtf8;
var
  LDocDict: IDocDict;
  LDocList: IDocList;
begin
  Result := '';

  LDocList := DocList(AJsonAry);

  if LDocList.Len > 0 then
  begin
    LDocDict := DocDict(LDocList.S[ARowIndex]);
    Result := LDocDict.S[AKeyName];
  end;
end;

end.
