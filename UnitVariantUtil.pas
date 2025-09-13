unit UnitVariantUtil;

interface

uses Winapi.Activex, System.Variants, System.VarUtils, System.DateUtils,
  Rtti, TypInfo,
  mormot.core.datetime, mormot.core.variants;

type
  TVariantCls = class
    class function GetAsVariant<T>(const AValue: T): variant;
  end;

function VarToDateWithTimeLog(AVar: Variant): TDateTime;
function VarFromDateWithTimeLog(ADate: TDateTime): Variant;

//// Record → Variant 변환
//function RecordToVariant<T>(const Rec: T): Variant;
//// Variant → Record 변환
//function VariantToRecord<T>(const V: Variant): T;
//
//// Record → Variant (JSON string 형태)
//function RecordToVariantUsingJson<T>(const Rec: T): Variant;
//// Variant → Record (JSON string에서 역직렬화)
//function VariantToRecordUsingJson<T>(const V: Variant): T;

implementation

uses UnitStringUtil, System.SysUtils;

function VarToDateWithTimeLog(AVar: Variant): TDateTime;
var
  LStr: string;
begin
  if VarIsNull(AVar) then
  begin
    Result := 0;
    exit;
  end;
//    LStr := ''
//  else
//    LStr := VarToStr(AVar);

  LStr := VarToStr(AVar);

  if StrIsNumeric(LStr) then
    Result := TimelogToDateTime(StrToInt64(LStr))
  else
  if VarIsStr(AVar) then
    Result := Iso8601ToDateTime(LStr)
  else
    Result := VarToDateTIme(AVar);
end;

function VarFromDateWithTimeLog(ADate: TDateTime): Variant;
begin
  TDocVariant.New(Result);
  Result := TimeLogFromDateTime(ADate);
end;

{ TVariantCls }

class function TVariantCls.GetAsVariant<T>(const AValue: T): variant;
var
  LValue: TValue;
  LBool: Boolean;
begin
  LValue := TValue.From<T>(AValue);

  case LValue.Kind of
    tkInteger: Result := LValue.AsInteger;
    tkInt64: Result := LValue.AsInt64;
    tkEnumeration: begin
      if LValue.TryAsType<Boolean>(LBool) then
        Result := LBool
      else
        Result := LValue.AsOrdinal;
    end;
    tkFloat: Result := LValue.AsExtended;
    tkChar,
    tkWChar,
    tkLString,
    tkWString,
    tkUString,
    tkString: Result := LValue.AsString;
    tkVariant: Result := LValue.AsVariant;
    tkInterface: Result := LValue.AsInterface;
    else
      raise Exception.Create('Unsupported Type by UnitVariantUtil.TVariantCls.GetAsVariant');
//    tkArray: ;
//    tkRecord: ;
//    tkSet: ;
//    tkClass: ;
//    tkMethod: ;
//    tkDynArray: ;
//    tkClassRef: ;
//    tkPointer: ;
//    tkProcedure: ;
//    tkUnknown: ;
  end;
end;
//
//function RecordToVariant<T>(const Rec: T): Variant;
//var
//  P: Pointer;
//  Size: Integer;
//begin
//  Size := SizeOf(T);
//  Result := VarArrayCreate([0, Size - 1], varByte);
//  P := VarArrayLock(Result);
//  try
//    Move(Rec, P^, Size);
//  finally
//    VarArrayUnlock(Result);
//  end;
//end;
//
//function VariantToRecord<T>(const V: Variant): T;
//var
//  P: Pointer;
//  Size: Integer;
//begin
//  if not VarIsArray(V) or (VarArrayDimCount(V) <> 1) then
//    raise EVariantRecordError.Create('Variant does not contain a valid byte array');
//
//  Size := SizeOf(T);
//  if (VarArrayHighBound(V, 1) - VarArrayLowBound(V, 1) + 1) <> Size then
//    raise EVariantRecordError.Create('Byte array size does not match record size');
//
//  P := VarArrayLock(V);
//  try
//    Move(P^, Result, Size);
//  finally
//    VarArrayUnlock(V);
//  end;
//end;
//
//function RecordToVariantUsingJson<T>(const Rec: T): Variant;
//var
//  JSONStr: string;
//begin
//  JSONStr := ObjectToJson(Rec);
//  Result := JSONStr; // Variant에 문자열 저장
//end;
//
//function VariantToRecordUsingJson<T>(const V: Variant): T;
//var
//  JSONStr: string;
//begin
//  if not VarIsStr(V) then
//    raise EVariantRecordError.Create('Variant does not contain a JSON string');
//
//  JSONStr := V;
//  Result := TJson.JsonToObject<T>(JSONStr);
//end;

end.
