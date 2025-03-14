unit UnitOLEVarUtil;

interface

uses Winapi.Activex, System.Variants, System.VarUtils, System.DateUtils,
  Rtti, TypInfo,
  mormot.core.datetime, mormot.core.variants;

function CreateOLEVarFromStrAry(const Strings: array of string): OLEVariant;
function CreateOLEVarFromJsonAry(const AJsonAry: string): OLEVariant;
function CreateOLEVarFromDocList(const ADocList: IDocList; const AVarType: integer=varOleStr): OLEVariant;
function CreateOLEVarFromVariant(const Avar: Variant; const AVarType: integer=varOleStr): OLEVariant;

function SafeArrayGetVarType(psa: PSafeArray): TVarType; safecall; external 'OleAut32.dll';
function PSafeArrayToVariant(psa: PSafeArray): OleVariant;

implementation

function CreateOLEVarFromStrAry(const Strings: array of string): OLEVariant;
var
  I: Integer;
begin
  // Create a one-dimensional variant array (SAFEARRAY of BSTR)
  Result := VarArrayCreate([0, High(Strings)], varOleStr);

  // Assign values to the array
  for I := 0 to High(Strings) do
    Result[I] := WideString(Strings[I]);  // Convert to WideString (BSTR)
end;

function CreateOLEVarFromJsonAry(const AJsonAry: string): OLEVariant;
var
  LList: IDocList;
begin
  LList := DocList(AJsonAry);
  Result := CreateOLEVarFromDocList(LList);
end;

function CreateOLEVarFromDocList(const ADocList: IDocList; const AVarType: integer): OLEVariant;
var
  I, LCount: Integer;
begin
  LCount := ADocList.Len;

  // Create a one-dimensional variant array (SAFEARRAY of BSTR)
  Result := VarArrayCreate([0, LCount - 1], AVarType);

  // Assign values to the array
  for I := 0 to LCount - 1 do
    Result[I] := ADocList.Item[I];
end;

function CreateOLEVarFromVariant(const Avar: Variant; const AVarType: integer): OLEVariant;
begin
  // Create a one-dimensional variant array (SAFEARRAY of BSTR)
  Result := VarArrayCreate([0, 0], AVarType);

  // Assign values to the array
  Result[0] := Avar;
end;

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


end.
