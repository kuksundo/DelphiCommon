unit UnitGR32Helper;

interface

uses System.SysUtils, GR32, GR32.ImageFormats;

type
  // Helper for the 2D array type
  TAryOfAryOfFloatPointHelper = record helper for TArrayOfArrayOfFloatPoint
  public
    // Concatenates rows: Returns NEW array = Self rows + AOther rows
    function Add(const AOther: TArrayOfArrayOfFloatPoint): TArrayOfArrayOfFloatPoint;
    procedure Add1D(var AAryOfAryOfFP: TArrayOfArrayOfFloatPoint; const AOther: TArrayOfFloatPoint);
  end;

  TAryOfFloatHelper = record helper for TArrayOfFloat
  public
    function Add(const AOther: TFloat): TArrayOfFloat;
  end;

  TFileTypesHelper = record helper for TFileTypes
  public
    function Init(AStr: string): TFileTypes;
  end;

var
  TempTFileTypes: TFileTypes;

implementation

uses UnitStringUtil;

{ T2DIntegerDynArrayHelper }

function TAryOfAryOfFloatPointHelper.Add(
  const AOther: TArrayOfArrayOfFloatPoint): TArrayOfArrayOfFloatPoint;
var
  LenSelf, LenOther, TotalLen, I: Integer;
begin
  LenSelf := Length(Self); // Number of rows in Self
  LenOther := Length(AOther); // Number of rows in AOther
  TotalLen := LenSelf + LenOther;

  SetLength(Result, TotalLen); // Set number of rows in the result

  // Copy row references from Self
  for I := 0 to LenSelf - 1 do
    Result[I] := Self[I]; // Assigns reference to the inner array

  // Copy row references from AOther
  for I := 0 to LenOther - 1 do
    Result[LenSelf + I] := AOther[I]; // Assigns reference
end;

procedure TAryOfAryOfFloatPointHelper.Add1D(
  var AAryOfAryOfFP: TArrayOfArrayOfFloatPoint; const AOther: TArrayOfFloatPoint);
begin
  SetLength(AAryOfAryOfFP, Length(AAryOfAryOfFP) + 1);
  AAryOfAryOfFP[Length(AAryOfAryOfFP)] := AOther;
end;

{ TFileTypesHelper }

function TFileTypesHelper.Init(AStr: string): TFileTypes;
var
  LLen,i: integer;
begin
  LLen := strTokenCount(AStr, ';');

  if LLen > 0  then
  begin
    SetLength(Result, LLen);

    for i := 0 to LLen - 1 do
    begin
      Result[i] := StrToken(AStr, ';');
    end;
  end
  else
    SetLength(Result, 0);
end;

{ TAryOfFloatHelper }

function TAryOfFloatHelper.Add(const AOther: TFloat): TArrayOfFloat;
begin
  SetLength(Self, Length(Self) + 1);
  Self[Length(Self)] := AOther;
end;

end.
