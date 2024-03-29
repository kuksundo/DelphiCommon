unit JHP.Util.gpSharedMem;

interface

uses Windows, Messages, SysUtils, classes, Generics.Collections,
  mormot.core.json,
  GpSharedMemory, GpSharedEvents,
  JHP.Util.gpSharedMemType
;

const
  gp_SHARED_MAX_SIZE = 50000000;

type
  TgpKind = (gkProducer, gpListener, gpBoth);
  TgpKinds = set of TgpKind;

  TJHP_gpShM = class
  private
    FSMName,
    FNameSpace,
    FEventName: string;
    FMemSize: integer;
  public
    FgpSM: TGpSharedMemory;
    FgpEP: TGpSharedEventProducer;
    FgpEL: TGpSharedEventListener;

    constructor Create(const ASMName: string; ANameSpace: string = ''; AEventName: string=''; AMemSize: integer=gp_SHARED_MAX_SIZE); overload;
    constructor Create(const AGpShMMInfo: TGpShMMInfo; AMemSize: integer=gp_SHARED_MAX_SIZE); overload;
    destructor Destroy; override;

//    procedure GpSEEventReceivedNotify(Sender: TObject;
//      producerHandle: TGpSEHandle; const producerName, eventName,
//      eventData: string);
    function InitgpSMEvent(const ANameSpace, AEventName: string; AgpKinds: TgpKinds; AGpEventRecvNotify: TGpSEEventReceivedNotify=nil): integer;
    procedure FinalgpSMEvent(const ANameSpace, AEventName: string; AgpKinds: TgpKinds);

    function InitgpSM4Producer(const ANameSpace, AEventName: string): integer; overload;
    function InitgpSM4Producer(): integer; overload;
    function InitgpSM4Producer(const AGpShMMInfo: TGpShMMInfo): integer; overload;
    procedure AddEventName2gpSMProducer(const AEventName: string);
    procedure DeleteEventName4gpSMProducer(const AEventName: string);
    procedure FinalgpSM4Producer(const AEventName: string); overload;
    procedure FinalgpSM4Producer(); overload;

    function InitgpSM4Listener(const ANameSpace, AEventName: string;
      AGpEventRecvNotify: TGpSEEventReceivedNotify): integer; overload;
    function InitgpSM4Listener(AGpEventRecvNotify: TGpSEEventReceivedNotify): integer; overload;
    procedure AddEventName2gpSMListener(const AEventName: string);
    procedure DeleteEventName4gpSMListener(const AEventName: string);
    procedure FinalgpSM4Listener(const AEventName: string);

    function RecvDataFromgpSM: string;
    function RecvJsonDataFromgpShMM(var AData: string): integer;
    function SendData2gpSM(const AEventName, AData: string): cardinal; overload;
    function SendData2gpSM(const AData: string): cardinal; overload;
    function SendRecord2gpSM<T>(const AEventName: string; ARec: T; ARecSize: integer): cardinal;

    procedure GetshMMInfo(var ASMName, ANameSpace, AEventName: string; var AMemSize: integer);
    function GetJson4shMMInfoRecFromShMMName(const AShMMName: string;
      ANameSpace: string=''; AEventName: string=''): string;
    function GetshMMInfoRecFromShMMName(const AShMMName: string;
      ANameSpace: string=''; AEventName: string=''): TGpShMMInfo;
  end;

implementation

{ TJHP_gpShM }

procedure TJHP_gpShM.AddEventName2gpSMListener(const AEventName: string);
begin
  if not Assigned(FgpEL) then
    exit;

  if (AEventName <> '') then
    FgpEL.MonitoredEvents.Add(AEventName);
end;

procedure TJHP_gpShM.AddEventName2gpSMProducer(const AEventName: string);
begin
  if not Assigned(FgpEP) then
    exit;

  if (AEventName <> '') then
  begin
    FgpEP.PublishedEvents.Add(AEventName);
    FgpEP.Active := True;
  end;
end;

constructor TJHP_gpShM.Create(const AGpShMMInfo: TGpShMMInfo;
  AMemSize: integer);
begin
  Create(AGpShMMInfo.FName, AGpShMMInfo.FNameSpace, AGpShMMInfo.FEventName, AMemSize);
end;

constructor TJHP_gpShM.Create(const ASMName: string; ANameSpace: string; AEventName: string; AMemSize: integer);
begin
  FSMName := ASMName;
  FNameSpace := ANameSpace;
  FEventName := AEventName;
  FMemSize := AMemSize;

  try
    FgpSM := TGpSharedMemory.Create(ASMName, 0, AMemSize); //gp_SHARED_MAX_SIZE
  except
    if not Assigned(FgpSM) then
    begin
      if ERROR_ALREADY_EXISTS = GetLastError() then
      begin

      end;
    end;
  end;
end;

procedure TJHP_gpShM.DeleteEventName4gpSMListener(const AEventName: string);
var
  i: integer;
begin
  if FgpEL.MonitoredEvents.Find(AEventName, i) then
    FgpEL.MonitoredEvents.Add(AEventName);
end;

procedure TJHP_gpShM.DeleteEventName4gpSMProducer(const AEventName: string);
var
  i: integer;
begin
  if FgpEP.PublishedEvents.find(AEventName, i) then
    FgpEP.PublishedEvents.delete(i);
end;

destructor TJHP_gpShM.Destroy;
begin
  if Assigned(FgpEP) then
    FreeAndNil(FgpEP);

  if Assigned(FgpEL) then
    FreeAndNil(FgpEL);

  if Assigned(FgpSM) then
    FreeAndNil(FgpSM);
end;

procedure TJHP_gpShM.FinalgpSMEvent(const ANameSpace, AEventName: string; AgpKinds: TgpKinds);
var
  LgpKinds: TgpKinds;
begin
  if gpBoth in AgpKinds then
  begin
    LgpKinds := [gkProducer, gpListener];
  end;

  if gkProducer in AgpKinds then
    FinalgpSM4Producer(AEventName);

  if gpListener in AgpKinds then
    FinalgpSM4Listener(AEventName);
end;

function TJHP_gpShM.GetJson4shMMInfoRecFromShMMName(
  const AShMMName: string; ANameSpace: string; AEventName: string): string;
var
  LGpShMMInfo: TGpShMMInfo;
begin
  LGpShMMInfo := GetshMMInfoRecFromShMMName(AShMMName, ANameSpace, AEventName);
  Result := RecordSaveJson(LGpShMMInfo, TypeInfo(TGpShMMInfo));
end;

procedure TJHP_gpShM.GetshMMInfo(var ASMName, ANameSpace, AEventName: string;
  var AMemSize: integer);
begin
  ASMName := FSMName;
  ANameSpace := FNameSpace;
  AEventName := FEventName;
  AMemSize := FMemSize;
end;

function TJHP_gpShM.GetshMMInfoRecFromShMMName(const AShMMName: string;
  ANameSpace, AEventName: string): TGpShMMInfo;
begin
  Result.FName := AShMMName;
  Result.FNameSpace := ANameSpace;
  Result.FEventName := AEventName;
end;

procedure TJHP_gpShM.FinalgpSM4Listener(const AEventName: string);
begin
  if Assigned(FgpEL) then
    FreeAndNil(FgpEL);
end;

procedure TJHP_gpShM.FinalgpSM4Producer;
begin
  FinalgpSM4Producer(FEventName);
end;

procedure TJHP_gpShM.FinalgpSM4Producer(const AEventName: string);
begin
  if Assigned(FgpEP) then
    FreeAndNil(FgpEP);
end;

function TJHP_gpShM.InitgpSMEvent(const ANameSpace, AEventName: string; AgpKinds: TgpKinds;
  AGpEventRecvNotify: TGpSEEventReceivedNotify): integer;
var
  LgpKinds: TgpKinds;
begin
  if gpBoth in AgpKinds then
  begin
    LgpKinds := [gkProducer, gpListener];
  end;

  if gkProducer in AgpKinds then
    InitgpSM4Producer(ANameSpace, AEventName);

  if gpListener in AgpKinds then
    InitgpSM4Listener(ANameSpace, AEventName, AGpEventRecvNotify);
end;

function TJHP_gpShM.RecvDataFromgpSM: string;
var
  LStrList: TStringList;
begin
  Result := '';

  LStrList := TStringList.Create;
  try
    if FgpSM.AcquireMemory(False, INFINITE) <> nil then
    begin
      LStrList.LoadFromStream(FgpSM.AsStream);
      Result := LStrList.Strings[1];
    end;

    if FgpSM.Acquired then
      FgpSM.ReleaseMemory;
  finally
    LStrList.Free;
  end;
end;

function TJHP_gpShM.RecvJsonDataFromgpShMM(var AData: string): integer;
begin
  Result := -1;
  AData := RecvDataFromgpSM();
  Result := Length(AData);
end;

function TJHP_gpShM.InitgpSM4Listener(const ANameSpace,
  AEventName: string; AGpEventRecvNotify: TGpSEEventReceivedNotify): integer;
begin
  FgpEL := TGpSharedEventListener.Create(nil);
  FgpEL.Namespace := ANameSpace;
//  FGpSharedEventListener.MonitorEvent(gp_EventName4SimEditData);
  FgpEL.MonitoredEvents.Add(AEventName);
  FgpEL.OnEventReceived := AGpEventRecvNotify;
  FgpEL.Active := True;
end;

function TJHP_gpShM.InitgpSM4Listener(
  AGpEventRecvNotify: TGpSEEventReceivedNotify): integer;
begin
  InitgpSM4Listener(FNameSpace, FEventName, AGpEventRecvNotify);
end;

function TJHP_gpShM.InitgpSM4Producer: integer;
begin
  InitgpSM4Producer(FNameSpace, FEventName);
end;

function TJHP_gpShM.InitgpSM4Producer(const ANameSpace, AEventName: string): integer;
begin
  if Assigned(FgpEP) then
    exit;

  if (AEventName <> '') then
  begin
    FgpEP := TGpSharedEventProducer.Create(nil);
    FgpEP.Namespace := ANameSpace;
    FgpEP.PublishedEvents.Add(AEventName);
    FgpEP.Active := True;
  end;
end;

function TJHP_gpShM.SendData2gpSM(const AEventName, AData: string): cardinal;
var
  LStrList: TStringList;
begin
  Result := 0;
  LStrList := TStringList.Create;
  try
    LStrList.Add(IntToStr(GetCurrentProcessId));
    LStrList.Add(AData);

    if FgpSM.AcquireMemory(True, INFINITE) <> nil then
    begin
      if FgpSM.IsWriting then
        LStrList.SaveToStream(FgpSM.AsStream);
    end;

    if FgpSM.Acquired then
      FgpSM.ReleaseMemory;

    Result := FgpEP.BroadcastEvent(AEventName,
              FormatDateTime('hh:mm:ss.zzz', Now));
//    FgpEP.PublishEvent(AEventName);
  finally
    LStrList.Free;
  end;
end;

function TJHP_gpShM.SendData2gpSM(const AData: string): cardinal;
begin
  Result := SendData2gpSM(FEventName, AData);
end;

function TJHP_gpShM.SendRecord2gpSM<T>(const AEventName: string; ARec: T; ARecSize: integer): cardinal;
begin
  Result := 0;

  if FgpSM.AcquireMemory(True, INFINITE) <> nil then
  begin
    if FgpSM.IsWriting then
      FgpSM.AsStream.Write(ARec, ARecSize);
  end;

  if FgpSM.Acquired then
    FgpSM.ReleaseMemory;

  Result := FgpEP.BroadcastEvent(AEventName,
            FormatDateTime('hh:mm:ss.zzz', Now));
end;

function TJHP_gpShM.InitgpSM4Producer(const AGpShMMInfo: TGpShMMInfo): integer;
begin
  Result := InitgpSM4Producer(AGpShMMInfo.FNameSpace, AGpShMMInfo.FEventName);
end;

end.
