unit UnitMiscUtil;

interface

uses System.SysUtils;

function IntToBool(AValue: Integer): Boolean;
function BoolToInt(AValue: Boolean): Integer;
function IsFloat(AValue: double): Boolean;
function CalculateCBM(Length, Width, Height: Double): Double;
function CheckBusinessNumber(const ANumber: string): Boolean;
function CheckJuminNumber(const ANumber: string): Boolean;

implementation

function IntToBool(AValue: Integer): Boolean;
begin
  Result := AValue <> 0;
end;

function BoolToInt(AValue: Boolean): Integer;
begin
  Result := Ord(AValue);
end;

function IsFloat(AValue: double): Boolean;
begin
  Result := Frac(AValue) <> 0;
end;

//Parameter 단위는 mm임을 주의
//Result 단위는 Meter임을 주의
function CalculateCBM(Length, Width, Height: Double): Double;
begin
  Result := (Length * Width * Height) / 1e9;
end;

function CheckBusinessNumber(const ANumber: string): Boolean;
const
  DIGIT: array[1..9] of integer = (
    1,3,7,1,3,7,1,3,5
  );
var
  i,
  LDigit,
  LCalc: integer;
begin
  Result := False;

  if Length(ANumber) <> 10 then
    exit;

  LDigit := StrToInt(ANumber[10]);
  LCalc := 0;

  for i := 1 to 9 do
    LCalc := LCalc + StrToInt(ANumber[i]) * DIGIT[i];

  LCalc := LCalc + (StrToInt(ANumber[9]) * DIGIT[9]) div 10;
  LCalc := (10 - (LCalc mod 10));

  Result := (LDigit = LCalc);
end;

function CheckJuminNumber(const ANumber: string): Boolean;
const
  DIGIT: array[1..12] of integer = (
    2,3,4,5,6,7,8,9,2,3,4,5
  );

var
  i,
  LDigit,
  LCalc: integer;
begin
  Result := False;

  if Length(ANumber) <> 13 then
    exit;

  LDigit := StrToInt(ANumber[13]);
  LCalc := 0;

  for i := 1 to 12 do
    LCalc := LCalc + StrToInt(ANumber[i]) * DIGIT[i];

  LCalc := (11-(LCalc mod 11)) mod 10;

  Result := (LDigit = LCalc);
end;

end.
