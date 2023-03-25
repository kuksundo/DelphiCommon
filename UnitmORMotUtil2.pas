unit UnitmORMotUtil2;

interface

uses System.SysUtils,
  mormot.core.base, mormot.core.datetime, mormot.net.client, UnitStringUtil;

function GetTimeLogFromStr(AStr: string): TTimeLog;
procedure SendPostUsingSynCrt(AUrl: string; AJson: variant);

implementation

function GetTimeLogFromStr(AStr: string): TTimeLog;
var
  Ly, Lm, Ld: word;
begin
  Result := 0;

  if (AStr <> '') and (Pos('-', AStr) <> 0)then
  begin
    Ly := StrToIntDef(strToken(AStr, '-'),0);
    if Ly <> 0 then
    begin
      Lm := StrToIntDef(strToken(AStr, '-'),0);
      Ld := StrToIntDef(strToken(AStr, '-'),0);
      Result := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
    end;
  end;
end;

{Usage:
var t: variant
begin
  TDocVariant.new(t);
  t.name := 'jhon';
  t.year := 1982;
  SendPostUsingSynCrt('http://servername/resourcename',t);
end}
procedure SendPostUsingSynCrt(AUrl: string; AJson: variant);
begin
  TWinHttp.Post(AUrl, AJson, 'Content-Type: application/json');
end;

end.
