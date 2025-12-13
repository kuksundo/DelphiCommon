unit UnitSetUtil;

interface

uses System.TypInfo, System.SysUtils;

type
  TgpEnumSet<TSet> = class
  public
    class function SetToInt(const ASet; const ASize: integer): integer;
    class procedure IntToSet(const AValue: integer; var ASet; const ASize: integer);
    //AValue가 Enumeration Index임
    class procedure Int64ToSetByEnumIdx(const AValue: Int64; var ASet: TSet); static;
    class function SetToInt64ByEnumIdx(const ASet: TSet): Int64; static;

    //AValue의 각 비트 위치가 Enum 인덱스와 대응
    class procedure Int64ToSetByBitPos(const AValue: Int64; var ASet: TSet); static;
    class function SetToInt64ByBitPos(const ASet: TSet): Int64; static;

    class function SetValueToInt(ASet: TSet): integer; inline; static;
    class procedure IntToSetValue(var AEnumSet; AInt: Integer); inline; static;
    class function IsIncludedInSet(const AValue: integer; AEnumSet: TSet): Boolean; static;
    class function IsIncludedInSet2(const AValue: integer; AEnumSet: TSet): Boolean; static;
  end;

implementation

{ TgpEnumSet<TSet> }

class procedure TgpEnumSet<TSet>.Int64ToSetByBitPos(const AValue: Int64;
  var ASet: TSet);
var
  BytesDest, BytesSrc: PByte;
  I, ByteCount: Integer;
  Bits: Int64;
begin
  Bits := AValue;
  BytesDest := @ASet;
  BytesSrc := @Bits;

  ByteCount := SizeOf(TSet);

  for I := 0 to ByteCount - 1 do
  begin
    if I < SizeOf(Int64) then
      BytesDest[I] := BytesSrc[I]
    else
      BytesDest[I] := 0; // 64비트 초과 영역은 0으로 초기화
  end;
end;

class procedure TgpEnumSet<TSet>.Int64ToSetByEnumIdx(const AValue: Int64; var ASet: TSet);
var
  BytesDest, BytesSrc: PByte;
  I, ByteCount: Integer;
begin
  // ASet을 메모리로 접근
  BytesDest := @ASet;
  BytesSrc := @AValue;

  // TSet의 실제 크기
  ByteCount := SizeOf(TSet);

  // AValue(8바이트)를 ASet 메모리에 복사
  for I := 0 to ByteCount - 1 do
  begin
    if I < SizeOf(Int64) then
      BytesDest[I] := BytesSrc[I]
    else
      BytesDest[I] := 0; // 8바이트 초과 시 0 초기화
  end;
end;

class procedure TgpEnumSet<TSet>.IntToSet(const AValue: integer; var ASet;
  const ASize: integer);
begin
  Move(AValue, ASet, ASize);
end;

class procedure  TgpEnumSet<TSet>.IntToSetValue(var AEnumSet; AInt: Integer);
var intSet : TIntegerSet;
    b : byte;
begin
//  AEnumSet := []; //Calling Funcion에서 반드시 초기화 해야 함
  intSet := TIntegerSet(AInt);

  for b in intSet do
    include(TIntegerSet(AEnumSet), b);
end;

class function TgpEnumSet<TSet>.IsIncludedInSet(const AValue: integer;
  AEnumSet: TSet): Boolean;
var
  SetTypeInfo, EnumTypeInfo: PTypeInfo;
  EnumData: PTypeData;
  EnumMin, EnumMax: Integer;
  EnumValue: Integer;
  Bytes: PByte;
  NumElements: Integer;
  SetSizeBytes: Integer;
begin
  Result := False;

  // 1) TSet이 진짜 set 타입인지 확인
  SetTypeInfo := TypeInfo(TSet);
  if (SetTypeInfo = nil) or (SetTypeInfo^.Kind <> tkSet) then
    Exit(False);

  // 2) set의 구성 요소 타입(CompType)을 얻고 enum인지 확인
  if GetTypeData(SetTypeInfo) = nil then
    Exit(False);

  EnumTypeInfo := GetTypeData(SetTypeInfo)^.CompType^;
  if (EnumTypeInfo = nil) or (EnumTypeInfo^.Kind <> tkEnumeration) then
    Exit(False);

  // 3) enum의 범위 얻기
  EnumData := GetTypeData(EnumTypeInfo);
  EnumMin := EnumData^.MinValue;
  EnumMax := EnumData^.MaxValue;

  // 4) 값이 enum 범위에 있는지 검사
  if (AValue < EnumMin) or (AValue > EnumMax) then
    Exit(False);

  // 5) enum의 offset(0 기반)과 set의 바이트 크기 계산
  EnumValue := AValue - EnumMin; // 0-based index within the enum range
  NumElements := EnumMax - EnumMin + 1;
  SetSizeBytes := (NumElements + 7) div 8;

  // 6) AEnumSet의 바이트 포인터에 안전하게 접근하여 해당 비트 검사
  Bytes := PByte(@AEnumSet);
  // 안전성: enumValue div 8가 set 바이트 범위 안에 있어야 함
  if (EnumValue div 8) >= SetSizeBytes then
    Exit(False);

  Result := (Bytes[EnumValue div 8] and (1 shl (EnumValue mod 8))) <> 0;
end;

class function TgpEnumSet<TSet>.IsIncludedInSet2(const AValue: integer;
  AEnumSet: TSet): Boolean;
var
  SetTypeInfo, EnumTypeInfo: PTypeInfo;
  EnumData: PTypeData;
  EnumMin, EnumMax: Integer;
  EnumValue: Integer;
  BytePtr: PByte;
  BitIndex: Integer;
begin
  Result := False;

  // 1. TSet의 타입 정보 얻기
  SetTypeInfo := TypeInfo(TSet);
  if (SetTypeInfo = nil) or (SetTypeInfo^.Kind <> tkSet) then
    Exit; // set 타입이 아니면 False

  // 2. set 내부의 enum 타입 정보 얻기
  EnumTypeInfo := GetTypeData(SetTypeInfo)^.CompType^;
  if (EnumTypeInfo = nil) or (EnumTypeInfo^.Kind <> tkEnumeration) then
    Exit; // set of enum 타입이 아님

  // 3. enum 범위 확인
  EnumData := GetTypeData(EnumTypeInfo);
  EnumMin := EnumData^.MinValue;
  EnumMax := EnumData^.MaxValue;

  if (AValue < EnumMin) or (AValue > EnumMax) then
    Exit(False); // 범위 밖

  // 4. 실제 메모리에서 비트 단위로 검사
  EnumValue := AValue - EnumMin;  // 첫 값 기준으로 offset 계산
  BytePtr := @AEnumSet;
  Inc(BytePtr, EnumValue div 8);
  BitIndex := EnumValue mod 8;

  Result := (BytePtr^ and (1 shl BitIndex)) <> 0;
end;

class function TgpEnumSet<TSet>.SetToInt(const ASet;
  const ASize: integer): integer;
begin
  Move(ASet, Result, ASize);
end;

class function TgpEnumSet<TSet>.SetToInt64ByBitPos(const ASet: TSet): Int64;
var
  BytesSrc, BytesDest: PByte;
  I, ByteCount: Integer;
  ResultValue: Int64;
begin
  FillChar(ResultValue, SizeOf(ResultValue), 0);

  BytesSrc := @ASet;
  BytesDest := @ResultValue;

  ByteCount := SizeOf(TSet);

  for I := 0 to ByteCount - 1 do
    if I < SizeOf(Int64) then
      BytesDest[I] := BytesSrc[I];

  Result := ResultValue;
end;

class function TgpEnumSet<TSet>.SetToInt64ByEnumIdx(const ASet: TSet): Int64;
var
  BytesSrc, BytesDest: PByte;
  I, ByteCount: Integer;
  ResultValue: Int64;
begin
  BytesSrc := @ASet;
  BytesDest := @ResultValue;

  FillChar(ResultValue, SizeOf(ResultValue), 0);
  ByteCount := SizeOf(TSet);

  for I := 0 to ByteCount - 1 do
    if I < SizeOf(Int64) then
      BytesDest[I] := BytesSrc[I];

  Result := ResultValue;
end;

class function TgpEnumSet<TSet>.SetValueToInt(ASet: TSet): integer;
begin
  Result := SetToInt(ASet, SizeOf(ASet));
end;

end.
