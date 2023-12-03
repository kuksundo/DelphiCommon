unit UnitIPCGpSharedMM;

interface

uses
  GpSharedMemory, GpSharedEvents;

type
  TgpShardMMBase = class
    FgpSharedMM: TGpSharedMemory;
    FSMname, FNameSpace, FEventName: string;
    FSMSize: integer;
  public
    constructor Create(ASMname, ANameSpace, AEventName: string; ASMSize: integer);
    destructor Destroy; override;

    procedure AddEventName(const AEventName: string); virtual; abstract;
  end;

  TgpShardMMProducer = class(TgpShardMMBase)
    FGpSharedEventProducer: TGpSharedEventProducer;

  public
    constructor Create(ASMname, ANameSpace, AEventName: string; ASMSize: integer); override;
    destructor Destroy; override;

    procedure AddEventName(const AEventName: string); override;
    procedure SendData2gpSM(const AEventName, AData: string);
  end;

  TgpShardMMListener = class(TgpShardMMBase)
    FGpSharedEventListener: TGpSharedEventListener;

  public
    constructor Create(ASMname, ANameSpace, AEventName: string; ASMSize: integer); override;
    destructor Destroy; override;

    procedure AddEventName(const AEventName: string); override;
  end;

implementation

{ TgpShardMMBase }

constructor TgpShardMMBase.Create(ASMname, ANameSpace, AEventName: string; ASMSize: integer);
begin
  if ASMSize = 0 then
    ASMSize := gp_SHARED_MAX_SIZE;

  FSMname := ASMname;
  FNameSpace := ANameSpace;
  FEventName := AEventName;
  FSMSize := ASMSize;

  FgpSharedMM := TGpSharedMemory.Create(FSMname, 0, FSMSize);
end;

destructor TgpShardMMBase.Destroy;
begin
  FreeAndNil(FgpSharedMM);

  inherited;
end;

{ TgpShardMMProducer }

procedure TgpShardMMProducer.AddEventName(const AEventName: string);
begin
//  if Assigned(FGpSharedEventProducer) then
    if AEventName <> '' then
      FGpSharedEventProducer.PublishedEvents.Add(AEventName);
end;

constructor TgpShardMMProducer.Create(ASMname, ANameSpace, AEventName: string;
  ASMSize: integer);
begin
  inherited;

  if AEventName <> '' then
  begin
    FGpSharedEventProducer := TGpSharedEventProducer.Create(nil);
    FGpSharedEventProducer.Namespace := ANameSpace;
    FGpSharedEventProducer.PublishedEvents.Add(AEventName);
    FGpSharedEventProducer.Active := True;
  end;

end;

destructor TgpShardMMProducer.Destroy;
begin

  inherited;
end;

procedure TgpShardMMProducer.SendData2gpSM(const AEventName, AData: string);
var
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add(IntToStr(GetCurrentProcessId));
    LStrList.Add(AData);

    if FgpSharedMM.AcquireMemory(True, INFINITE) <> nil then
    begin
      if FgpSharedMM.IsWriting then
        LStrList.SaveToStream(FgpSharedMM.AsStream);
    end;

    if FgpSharedMM.Acquired then
      FgpSharedMM.ReleaseMemory;

    FGpSharedEventProducer.BroadcastEvent(AEventName,
              FormatDateTime('hh:mm:ss.zzz', Now));
  finally
    LStrList.Free;
  end;
end;

{ TgpShardMMListener }

procedure TgpShardMMListener.AddEventName(const AEventName: string);
begin

end;

constructor TgpShardMMListener.Create(ASMname, ANameSpace, AEventName: string;
  ASMSize: integer);
begin
  inherited;

  FGpSharedEventListener := TGpSharedEventListener.Create(Self);
  FGpSharedEventListener.Namespace := ANameSpace;
  FGpSharedEventListener.MonitoredEvents.Add(AEventName);
  FGpSharedEventListener.OnEventReceived := AGpSEEventReceivedNotify;
  FGpSharedEventListener.Active := True;
end;

destructor TgpShardMMListener.Destroy;
begin

  inherited;
end;

end.
