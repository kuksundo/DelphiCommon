unit UnitWebSocketClient2;

interface

uses System.SysUtils,
  mormot.net.ws.client, mormot.soa.client, mormot.soa.core, mormot.orm.core,
  mormot.rest.http.client;

function GetClientWS(AIPAddrss, APortName, ATransmissionKey: string;
  AServiceInterfaces: array of TGUID; out AResultMsg: string): TRestHttpClientWebsockets;

implementation

function GetClientWS(AIPAddrss, APortName, ATransmissionKey: string;
  AServiceInterfaces: array of TGUID; out AResultMsg: string): TRestHttpClientWebsockets;
begin
  AResultMsg := '';

  if AIPAddrss = '' then
    AIPAddrss := '127.0.0.1';

  Result := TRestHttpClientWebsockets.Create(AIPAddrss,APortName,TSQLModel.Create([]));
  Result.Model.Owner := Result;
  AResultMsg := Result.WebSocketsUpgrade(ATransmissionKey);

  if AResultMsg = 'Impossible to connect to the Server' then
  begin
    FreeAndNil(Result);
    exit;
  end;

  if not Result.ServerTimeStampSynchronize then
  begin
    AResultMsg := 'Error ServerTimeStampSynchronize to the server';
    FreeAndNil(Result);
    exit;
//    raise EServiceException.Create(
//      'Error connecting to the server: please run InqManage.exe');
  end;

  Result.ServiceDefine(AServiceInterfaces, sicShared);//sicClientDriven
end;

end.
