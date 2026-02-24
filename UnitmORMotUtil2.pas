unit UnitmORMotUtil2;

interface

uses System.SysUtils,
  mormot.core.base, mormot.net.client, mormot.net.server;

procedure SendPostUsingSynCrt(AUrl: string; AJson: variant);

implementation

uses UnitStringUtil;

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
