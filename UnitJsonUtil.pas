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
function UnescapeJsonString(const AJsonEscapedString: String): String;

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

function UnescapeJsonString(const AJsonEscapedString: String): String;
var
  I: Integer;
  ResultString: TStringBuilder;
begin
  ResultString := TStringBuilder.Create;
  try
    I := 1;
    while I <= Length(AJsonEscapedString) do
    begin
      if AJsonEscapedString[I] = '\' then
      begin
        Inc(I);
        if I <= Length(AJsonEscapedString) then
        begin
          case AJsonEscapedString[I] of
            '"': ResultString.Append('"');
            '\': ResultString.Append('\');
            '/': ResultString.Append('/'); // JSON에서는 '/'도 이스케이프될 수 있음
            'b': ResultString.Append(Chr(8));  // Backspace
            'f': ResultString.Append(Chr(12)); // Form Feed
            'n': ResultString.Append(Chr(10)); // Newline
            'r': ResultString.Append(Chr(13)); // Carriage Return
            't': ResultString.Append(Chr(9));  // Tab
            // \uXXXX (유니코드 이스케이프) 처리는 더 복잡하며, 이 간단한 함수에서는 생략합니다.
            // 필요하다면 추가적인 로직 구현 필요
            else
              // 알 수 없는 이스케이프 시퀀스는 그대로 둠 또는 오류 처리
              ResultString.Append('\');
              ResultString.Append(AJsonEscapedString[I]);
          end;
        end
        else
        begin
          // 문자열 끝에 역슬래시만 있는 경우 (잘못된 JSON)
          ResultString.Append('\');
        end;
      end
      else
      begin
        ResultString.Append(AJsonEscapedString[I]);
      end;
      Inc(I);
    end;
    Result := ResultString.ToString;
  finally
    ResultString.Free;
  end;
end;

end.
