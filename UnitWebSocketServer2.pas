unit UnitWebSocketServer2;

interface

uses System.SysUtils,//System.Classes, DateUtils,
  mormot.orm.core, mormot.rest.http.server, mormot.soa.server, mormot.rest.memserver,
  mormot.soa.core, mormot.core.interfaces;

type
  TpjhHttpWSServer = class
  public
    FModel: TSQLModel;
    FHTTPServer: TRestHttpServer;
    FRestServer: TRestServerFullMemory;
    FServiceFactoryServer: TServiceFactoryServer;
    FPortName,
    FTransmissionKey: string;
    FIsServerActive : Boolean;

    procedure CreateHttpServer4WS(APort, ATransmissionKey: string;
      aClient: TInterfacedClass; const aInterfaces: array of TGUID);
    procedure DestroyHttpServer;
  end;

implementation

{ TpjhHttpWSServer }

//사용예: CreateHttpServer4WS(TDTF.FPortName, TDTF.FTransmissionKey, TServiceIM4WS, [IInqManageService]);
procedure TpjhHttpWSServer.CreateHttpServer4WS(APort, ATransmissionKey: string;
  aClient: TInterfacedClass; const aInterfaces: array of TGUID);
begin
  if not Assigned(FRestServer) then
  begin
    // initialize a TObjectList-based database engine
    FRestServer := TRestServerFullMemory.CreateWithOwnModel([]);
    // register our Interface service on the server side
    FRestServer.CreateMissingTables;
    FServiceFactoryServer := TServiceFactoryServer(FRestServer.ServiceDefine(aClient, aInterfaces , sicShared));  //sicClientDriven, sicShared
    FServiceFactoryServer.SetOptions([], [optExecLockedPerInterface]). // thread-safe fConnected[]
      ByPassAuthentication := true;
  end;

  if not Assigned(FHTTPServer) then
  begin
    // launch the HTTP server
//    FPortName := APort;
    FHTTPServer := TRestHttpServer.Create(APort, [FRestServer], '+' , useBidirSocket);

    if ATransmissionKey = '' then
      ATransmissionKey := 'OL_PrivateKey';

    FHTTPServer.WebSocketsEnable(FRestServer, ATransmissionKey);
    FIsServerActive := True;
  end;
end;

procedure TpjhHttpWSServer.DestroyHttpServer;
begin
  if Assigned(FHTTPServer) then
    FHTTPServer.Free;

  if Assigned(FRestServer) then
  begin
    //에러가 나서 주석 처리함(향후 원인 분석해야 함 - 2019.3.4
//    FRestServer.Free;
  end;

  if Assigned(FModel) then
    FreeAndNil(FModel);
end;

end.
