unit UnitSetUtil;

interface

uses System.SysUtils;

type
  TgpEnumSet<TSet> = class
  public
    class function SetToInt(const ASet; const ASize: integer): integer;
    class procedure IntToSet(const AValue: integer; var ASet; const ASize: integer);
    class function SetValueToInt(ASet: TSet): integer; inline; static;
    class procedure IntToSetValue(var AEnumSet; AInt: Integer); inline; static;
  end;

implementation

{ TgpEnumSet<TSet> }

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

class function TgpEnumSet<TSet>.SetToInt(const ASet;
  const ASize: integer): integer;
begin
  Move(ASet, Result, ASize);
end;

class function TgpEnumSet<TSet>.SetValueToInt(ASet: TSet): integer;
begin
  Result := SetToInt(ASet, SizeOf(ASet));
end;

end.
