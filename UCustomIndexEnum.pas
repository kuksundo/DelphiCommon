unit UCustomIndexEnum;

interface

uses System.SysUtils, System.TypInfo, System.Rtti, System.Classes, Vcl.StdCtrls,
  UnitSimpleGenericEnum;

Type
  TCustomIdxEnumRec<T> = record
    Index       : integer;
    Description : string;
    Value       : T;
  end;

  TCustomIdxEnumEnum<T> = Record
  private
    R_ : array of TCustomIdxEnumRec<T>;
    FInitDone: Boolean;
    FCustomIndexMode: Boolean;//True = Index를 Minus(-) 값으로 설정할 수 있음

    //FCustomIndexMode = True일때 전용 함수들
    function GetMinIndex(ARec: array of TCustomIdxEnumRec<T>): integer;
    function GetMaxIndex(ARec: array of TCustomIdxEnumRec<T>): integer;
    function GetEnumString(const AIndex: integer): string;
    function GetDescByIndex(const AIndex: integer): string;
    function GetTypeByIndex(const AIndex: integer): T;
  public
    procedure CreateArrayRecord(ALength: integer);
    procedure InitArrayRecord(AStringArr: array of string); overload;
    procedure InitArrayRecord(AStringArr: array of string; AIndexArr: array of integer); overload;
    function IsInitArray: Boolean;

    function ToEnumString(AType: integer): string;
    function ToTypeFromEnumString(AType: string): T;
    function ToString(AType: T): string; overload;
    function ToString(AType: integer): string; overload;
    function ToType(AType: string): T; overload;
    function ToType(AType: integer): T; overload;
    function ToOrdinal(AType: T): integer; overload;
    function ToOrdinal(AType: string): integer; overload;
    Function GetTypeLabels(ASkipNull: Boolean = False): TStrings;
    procedure SetType2Combo(ACombo: TComboBox);
    procedure SetType2List(AList: TStrings);
    function IndexInRange(AIndex: integer): Boolean;
    function IsExistStrInArray(AStr: string): Boolean;
    function ToTypeFromSubString(AType: string): T;

    function ToStringByCustomIndex(const AIndex: integer): string;
    function ToTypeByCustomIndex(const AIndex: integer): T;
    function ToCustomIndex(AType: T): integer; overload;
    function ToCustomIndex(AType: string): integer; overload;
  End;

//function SetToInt(const ASet; const ASize: integer): integer;
//procedure IntToSet(const AValue: integer; var ASet; const ASize: integer);

implementation

//function SetToInt(const ASet; const ASize: integer): integer;
//begin
//  Move(ASet, Result, ASize);
//end;
//
//procedure IntToSet(const AValue: integer; var ASet; const ASize: integer);
//begin
//  Move(AValue, ASet, ASize);
//end;

{ TCustomIdxEnumEnum<T, R> }

procedure TCustomIdxEnumEnum<T>.CreateArrayRecord(ALength: integer);
begin
  SetLength(R_, ALength);

  FInitDone := False;
end;

function TCustomIdxEnumEnum<T>.GetDescByIndex(const AIndex: integer): string;
var
  i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := '';
  //FCustomIndexMode에서만 실행됨
  for i := 0 to LEnumGeneric.Count - 1 do
  begin
    if AIndex = R_[i].Index then
    begin
      Result := R_[i].Description;
      Break;
    end;
  end;
end;

function TCustomIdxEnumEnum<T>.GetEnumString(const AIndex: integer): string;
begin

end;

function TCustomIdxEnumEnum<T>.GetMaxIndex(ARec: array of TCustomIdxEnumRec<T>): integer;
var
  i, LMax: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  LMax := -99999;
  //FCustomIndexMode에서만 실행됨
  for i := 0 to LEnumGeneric.Count - 1 do
  begin
    if LMax < R_[i].Index then
    begin
      LMax := R_[i].Index;
    end;
  end;

  Result := LMax;
end;

function TCustomIdxEnumEnum<T>.GetMinIndex(ARec: array of TCustomIdxEnumRec<T>): integer;
var
  i, LMin: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  LMin := 99999;
  //FCustomIndexMode에서만 실행됨
  for i := 0 to LEnumGeneric.Count - 1 do
  begin
    if LMin > R_[i].Index then
    begin
      LMin := R_[i].Index;
    end;
  end;

  Result := LMin;
end;

function TCustomIdxEnumEnum<T>.GetTypeByIndex(const AIndex: integer): T;
var
  i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  //FCustomIndexMode에서만 실행됨
  for i := 0 to LEnumGeneric.Count - 1 do
  begin
    if AIndex = R_[i].Index then
    begin
      Result := R_[i].Value;
      Break;
    end;
  end;
end;

function TCustomIdxEnumEnum<T>.GetTypeLabels(ASkipNull: Boolean): TStrings;
var
  i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := TStringList.Create;

  for i := 0 to LEnumGeneric.Count - 2 do
  begin
    if (ASkipNull) and (i = 0) then
      continue;
    Result.Add(R_[i].Description);
  end;
end;

function TCustomIdxEnumEnum<T>.IndexInRange(AIndex: integer): Boolean;
begin
  if FCustomIndexMode then
    Result := (AIndex >= GetMinIndex(R_)) and (AIndex <= GetMaxIndex(R_))
  else
    Result := (AIndex >= Low(R_)) and (AIndex <= High(R_));
end;

procedure TCustomIdxEnumEnum<T>.InitArrayRecord(AStringArr: array of string;
  AIndexArr: array of integer);
var
  LLength, i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  FCustomIndexMode := True;

  if FInitDone then
    exit;

  LLength := Length(AStringArr);
  SetLength(R_, LLength);

  for i := 0 to LLength - 1 do
  begin
    R_[i].Value := LEnumGeneric.Cast(i);
    R_[i].Description := AStringArr[i];
    R_[i].Index := AIndexArr[i];
  end;

  FInitDone := True;
end;

procedure TCustomIdxEnumEnum<T>.InitArrayRecord(AStringArr: array of string);
var
  LLength, i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  if FInitDone then
    exit;

  LLength := Length(AStringArr);
  SetLength(R_, LLength);

  for i := 0 to LLength - 1 do
  begin
    R_[i].Value := LEnumGeneric.Cast(i);
    R_[i].Description := AStringArr[i];
  end;

  FInitDone := True;
end;

function TCustomIdxEnumEnum<T>.IsExistStrInArray(AStr: string): Boolean;
var
  i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := False;

  for i := 0 to LEnumGeneric.Count - 2 do
  begin
    Result := SameText(R_[i].Description, AStr);

    if Result then
      Break;
  end;
end;

function TCustomIdxEnumEnum<T>.IsInitArray: Boolean;
begin
  Result := FInitDone;
end;

procedure TCustomIdxEnumEnum<T>.SetType2Combo(ACombo: TComboBox);
var
  LStrList: TStrings;
begin
  LStrList := GetTypeLabels;
  try
    ACombo.Clear;
    ACombo.Items := LStrList;
  finally
    LStrList.Free;
  end;
end;

procedure TCustomIdxEnumEnum<T>.SetType2List(AList: TStrings);
var
  LStrList: TStrings;
begin
  LStrList := GetTypeLabels;
  try
    AList.Clear;
    AList.AddStrings(LStrList);
  finally
    LStrList.Free;
  end;
end;

function TCustomIdxEnumEnum<T>.ToOrdinal(AType: T): integer;
var
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := LEnumGeneric.Ord(AType);
end;

function TCustomIdxEnumEnum<T>.ToCustomIndex(AType: T): integer;
var
  LEnumGeneric: TEnumGeneric<T>;
  LIndex: integer;
begin
  if FCustomIndexMode then
  begin
    LIndex := LEnumGeneric.Ord(AType);
    Result := R_[LIndex].Index;
  end;
end;

function TCustomIdxEnumEnum<T>.ToCustomIndex(AType: string): integer;
var
  i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := -1;

  if FCustomIndexMode then
  begin
    //FCustomIndexMode에서만 실행됨
    for i := 0 to LEnumGeneric.Count - 1 do
    begin
      if AType = R_[i].Description then
      begin
        Result := R_[i].Index;
        Break;
      end;
    end;
  end;
end;

function TCustomIdxEnumEnum<T>.ToEnumString(AType: integer): string;
//var
//  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := '';

  if IndexInRange(AType) then
    Result := GetEnumName(TypeInfo(T), AType);
end;

function TCustomIdxEnumEnum<T>.ToOrdinal(AType: string): integer;
var
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := ToOrdinal(ToType(AType));
end;

function TCustomIdxEnumEnum<T>.ToString(AType: integer): string;
begin
  Result := '';

  if IndexInRange(AType) then
    Result := R_[AType].Description;
end;

function TCustomIdxEnumEnum<T>.ToStringByCustomIndex(const AIndex: integer): string;
begin
  if IndexInRange(AIndex) then
    if FCustomIndexMode then
      Result := GetDescByIndex(AIndex)
    else
      Result := '';
end;

function TCustomIdxEnumEnum<T>.ToString(AType: T): string;
var
  LEnumGeneric: TEnumGeneric<T>;
  i: integer;
begin
  Result := '';

  i := LEnumGeneric.Ord(AType);

  if IndexInRange(i) then
    Result := R_[i].Description;
end;

function TCustomIdxEnumEnum<T>.ToType(AType: integer): T;
var
  LEnumGeneric: TEnumGeneric<T>;
begin
  if IndexInRange(AType) then
    Result := LEnumGeneric.Cast(AType);
end;

function TCustomIdxEnumEnum<T>.ToTypeByCustomIndex(const AIndex: integer): T;
begin
  if IndexInRange(AIndex) then
  begin
    if FCustomIndexMode then
    begin
      Result := GetTypeByIndex(AIndex);
    end;
  end;
end;

function TCustomIdxEnumEnum<T>.ToTypeFromEnumString(AType: string): T;
var
  i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  i := GetEnumValue(TypeInfo(T), AType);

  if not IndexInRange(i) then
    i := 0;

  Result := LEnumGeneric.Cast(i);
end;

function TCustomIdxEnumEnum<T>.ToTypeFromSubString(AType: string): T;
var
  LLength, i: integer;
begin
  LLength := Length(R_);

  for i := 0 to LLength - 1 do
  begin
    if Pos(R_[i].Description, AType) > 0then
    begin
      Result := R_[i].Value;
      Break;
    end;
  end;
end;

function TCustomIdxEnumEnum<T>.ToType(AType: string): T;
var
  LLength, i: integer;
begin
  LLength := Length(R_);

  for i := 0 to LLength - 1 do
  begin
    if SameText(R_[i].Description, AType) then
    begin
      Result := R_[i].Value;
      Break;
    end;
  end;

end;

end.



