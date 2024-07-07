unit UnitMiscUtil;

interface

function IntToBool(AValue: Integer): Boolean;
function BoolToInt(AValue: Boolean): Integer;
function IsFloat(AValue: double): Boolean;
function CalculateCBM(Length, Width, Height: Double): Double;

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

//단위는 Meter임을 주의
function CalculateCBM(Length, Width, Height: Double): Double;
begin
  Result := Length * Width * Height;
end;

end.
