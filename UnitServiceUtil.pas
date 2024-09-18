unit UnitServiceUtil;

interface

uses SysUtils, Windows, Winapi.Winsvc,
  mormot.core.variants, mormot.core.unicode,
  uServiceManager, SvcUtils.Types, SvcUtils.Contract, SvcUtils.IntF, UnitEnumHelper;

type
  TSvcInfoHelper = class helper for TServiceInfo
  public
    function GetDescription(const ASvcName: string): String;
  end;

  TSvcUtilHelper = class helper for TSvcUtils
  public
    class function GetGlobalSvcUtil(): ISvcUtils;
  end;

const
  R_ServiceState_Eng : array[Low(TServiceState)..High(TServiceState)] of string =
    ('Stopped', 'Start Pending', 'Stop Pending', 'Running',
      'Continue Pending', 'Pause Pending', 'Paused');

  R_ServiceState_Kor : array[Low(TServiceState)..High(TServiceState)] of string =
    ('¡ﬂ¡ˆ', 'Start Pending', 'Stop Pending', 'Ω««‡¡ﬂ',
      'Continue Pending', 'Pause Pending', '∏ÿ√„');

function GetServiceInfoByName(const ASvcName: string): ISvcInfo;
function GetServiceStateByName(const ASvcName: string): TServiceState;
function GetServiceInfo2JsonByName(const ASvcName: string): string;
function SetServiceInfoFromJson(const AJson: string): boolean;
function GetServiceDescription(const ServiceName: string): string;

var
  g_ServiceState: TLabelledEnum<TServiceState>;
  g_ISvcUtils: ISvcUtils;

implementation

function GetServiceInfoByName(const ASvcName: string): ISvcInfo;
begin
  Result:= TSvcUtils.GetGlobalSvcUtil.GetServiceByName(ASvcName);
end;

function GetServiceStateByName(const ASvcName: string): TServiceState;
var
  LSvcInfo: ISvcInfo;
begin
  LSvcInfo:= TSvcUtils.GetGlobalSvcUtil.GetServiceByName(ASvcName);
  Result := LSvcInfo.GetState;
end;

function GetServiceInfo2JsonByName(const ASvcName: string): string;
var
  LSvcInfo: ISvcInfo;
  LVar: variant;
begin
  TDocVariant.New(LVar);
  LSvcInfo:= TSvcUtils.GetGlobalSvcUtil.GetServiceByName(ASvcName);

  LVar.ServiceName := LSvcInfo.ServiceName;
  LVar.DisplayName := LSvcInfo.DisplayName;
  LVar.BinaryPath := LSvcInfo.GetBinaryPath;
  LVar.Status := LSvcInfo.GetState;
  LVar.StartType := LSvcInfo.GetStartType;
  LVar.Description := GetServiceDescription(ASvcName);

  Result := Utf8ToString(LVar);
end;

function SetServiceInfoFromJson(const AJson: string): boolean;
var
  LSvcInfo: ISvcInfo;
  LVar: variant;
begin
  LVar := _Json(StringToUtf8(AJson));

  LSvcInfo:= TSvcUtils.GetGlobalSvcUtil.GetServiceByName(LVar.ServiceName);

//  LSvcInfo.DisplayName := LVar.DisplayName;
  LSvcInfo.ChangeBinaryPath(LVar.BinaryPath);
//  LSvcInfo.GetState := LVar.Status;
  LSvcInfo.ChangeServiceStart(LVar.StartType);
  LSvcInfo.ChangeDescription(LVar.Description);
end;

function TSvcInfoHelper.GetDescription(const ASvcName: string): String;
begin
  Result := GetServiceDescription(ASvcName);
end;

function GetServiceDescription(const ServiceName: string): string;
var
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  {$IFDEF CPUX64}
  ServiceConfig: LPQUERY_SERVICE_CONFIG;
  {$ELSE}
  ServiceConfig: TQueryServiceConfig;
  {$ENDIF}
  BytesNeeded: DWORD;
  Buffer: array[0..1023] of Byte;
begin
  Result := '';
  hSCManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  if hSCManager = 0 then
    RaiseLastOSError;

  try
    hService := OpenService(hSCManager, PChar(ServiceName), SERVICE_QUERY_CONFIG);
    if hService = 0 then
      RaiseLastOSError;

    try
      // Query the size needed for the buffer
      if not QueryServiceConfig(hService, nil, 0, BytesNeeded) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
      begin
        {$IFDEF CPUX64}
        GetMem(ServiceConfig, BytesNeeded);
        try
          if not QueryServiceConfig(hService, ServiceConfig, BytesNeeded, BytesNeeded) then
            RaiseLastOSError;

          Result := ServiceConfig.lpDisplayName;
        finally
          FreeMem(ServiceConfig);
        end;
        {$ELSE}
        // Allocate a buffer for the service configuration
        if not QueryServiceConfig(hService, @Buffer[0], BytesNeeded, BytesNeeded) then
          RaiseLastOSError;

        ServiceConfig := PQueryServiceConfig(@Buffer[0])^;
        // Extract the service description from the buffer
        // Note: In some Windows versions, the description might be stored in another place
        Result := ServiceConfig.lpDisplayName;
        {$ENDIF}
      end;
    finally
      CloseServiceHandle(hService);
    end;
  finally
    CloseServiceHandle(hSCManager);
  end;
end;

{ TSvcUtilHelper }

class function TSvcUtilHelper.GetGlobalSvcUtil: ISvcUtils;
begin
  if not Assigned(g_ISvcUtils) then
    g_ISvcUtils := TSvcUtils.New;

  Result := g_ISvcUtils;
end;

initialization
//  g_ServiceState.InitArrayRecord(R_ServiceState_Eng);

end.

