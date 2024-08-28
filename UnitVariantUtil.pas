unit UnitVariantUtil;

interface

uses Winapi.Activex, System.Variants, System.VarUtils, System.DateUtils,
  Rtti, TypInfo,
  mormot.core.datetime, mormot.core.variants;

type
  TVariantCls = class
    class function GetAsVariant<T>(const AValue: T): variant;
  end;

function SafeArrayGetVarType(psa: PSafeArray): TVarType; safecall; external 'OleAut32.dll';
function PSafeArrayToVariant(psa: PSafeArray): OleVariant;

function VarToDateWithTimeLog(AVar: Variant): TDateTime;
function VarFromDateWithTimeLog(ADate: TDateTime): Variant;

implementation

uses UnitStringUtil, System.SysUtils;

function PSafeArrayToVariant(psa: PSafeArray): OleVariant;
var
  Features: word;
  Vt: TVarType;
const
  FADF_HAVEVARTYPE = $80;
begin
  Features := psa^.fFeatures;

  if (Features and FADF_UNKNOWN) = FADF_UNKNOWN then
    Vt := VT_UNKNOWN
  else if (Features and FADF_DISPATCH) = FADF_DISPATCH then
    Vt := VT_DISPATCH
  else if (Features and FADF_VARIANT) = FADF_VARIANT then
    Vt := VT_VARIANT
  else if (Features and FADF_BSTR) = FADF_BSTR then
    Vt := VT_BSTR
  else if (Features and FADF_UNKNOWN) = FADF_UNKNOWN then
    Vt := SafeArrayGetVarType(psa)
  else
    Vt := VT_UI4; //assume 4 bytes of "something"

  TVarData(Result).VType := VT_ARRAY or Vt;
  TVarData(Result).VArray := PVarArray(psa);
end;

function VarToDateWithTimeLog(AVar: Variant): TDateTime;
var
  LStr: string;
begin
  LStr := AVar;

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

end.
