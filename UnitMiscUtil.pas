unit UnitMiscUtil;

interface

function IntToBool(AValue: Integer): Boolean;
function BoolToInt(AValue: Boolean): Integer;
function IsFloat(AValue: double): Boolean;

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

end.
