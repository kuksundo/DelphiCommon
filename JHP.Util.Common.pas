unit JHP.Util.Common;

interface

function IsFloat(AValue: double): Boolean;

implementation

function IsFloat(AValue: double): Boolean;
begin
  Result := Frac(AValue) <> 0;
end;

end.
