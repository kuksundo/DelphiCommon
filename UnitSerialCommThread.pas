unit UnitSerialCommThread;

interface

uses Windows, classes, Forms, SysUtils, Dialogs, Messages, MyKernelObject4GpSharedMem, CPort,
  UnitCopyData;

const
  WM_RECEIVESTRINGFROMCOMM = WM_USER + 100;

Type
  TCommMode = (cmChar, cmBin);
  TFunctionMode = (CM_DATA_READ, CM_CONFIG_READ, CM_DATA_WRITE, CM_CONFIG_WRITE, CM_CONFIG_WRITE_CONFIRM);

  TSerialCommThread = class(TThread)
    FOwner: TForm;
    FComPort: TComPort;
    FQueryInterval: integer;//Query 간격(mSec)
    FStopComm: Boolean;//통신 일시 중지 = True
    FTimeOut: integer;//통신 Send후 다음 Send까지 Timeout 시간(mSec) - INFINITE
    FCommMode: TCommMode;
    FSendBuf: array[0..255] of byte;//cmBin Mode에서 사용하는 송신 버퍼
    FBufStr: String;//cmChar Mode에서 사용되는 수신버퍼
    FRepeatCount: integer;//반복회수

    FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event
    FSendCommandList: TStringList;//반복적으로 보내는 명령 리스트
    FWriteCommandList: TStringList;//Write 명령 리스트
    FSendCommandOnce: string;//한번만 보내는 명령

    procedure OnReceiveComm(Sender: TObject; Count: Integer);
    procedure SetStopComm(Value: Boolean);
    procedure SetTimeOut(Value: integer);
    procedure SetQueryInterval(Value: integer);
  protected
    procedure Execute; override;
  public
    FIsConfirmAfterWrite: Boolean;//write function 실행 후 return값 확인할 경우  true
    FFunctionMode: TFunctionMode;

    constructor Create(AOwner: TForm; AQureyInterval: integer; ATimeOut: integer=3000);
    destructor Destroy; override;
    function LoiadComPortFromFile(AIniFileName: string=''): Boolean;
    procedure SaveComPortToFile(AIniFileName: string);
    function InitComPort(APortName, ABaudRate: string; ADataBit: string='8'; AStopBit: string='1'; AParity: String='None'): Boolean;

    procedure SendQuery;
    procedure SendBufClear;
  published
    property CommPort: TComPort read FComPort write FComPort;
    property StopComm: Boolean read FStopComm write SetStopComm;
    property TimeOut: integer read FTimeOut write SetTimeOut;
    property QueryInterval: integer read FQueryInterval write SetQueryInterval;
    property RepeatCount: integer read FRepeatCount write FRepeatCount;
    property CommMode: TCommMode read FCommMode write FCommMode;
  end;

implementation

{ TSerialCommThread }

constructor TSerialCommThread.Create(AOwner: TForm; AQureyInterval: integer; ATimeOut: integer);
begin
  inherited Create(True);

  FOwner := AOwner;
  FStopComm := False;
  FTimeOut := ATimeOut; //3초 기다린 후에 계속 명령을 전송함(Default = INFINITE)
  FComport := nil;

  FEventHandle := TEvent.Create('',False);
  FSendCommandList := TStringList.Create;
  FWriteCommandList := TStringList.Create;

//  Resume;
end;

destructor TSerialCommThread.Destroy;
begin
  if Assigned(FComport) then
    FComport.Free;

  FEventHandle.Free;
  FWriteCommandList.Free;
  FSendCommandList.Free;

  inherited;
end;

procedure TSerialCommThread.Execute;
begin
  while not terminated do
  begin
    if FStopComm then
      Suspend;

//    Sleep(FQueryInterval);
    SendQuery();
  end;
end;

function TSerialCommThread.InitComPort(APortName, ABaudRate: string;
  ADataBit: string; AStopBit: string; AParity: String): Boolean;
begin
  Result := False;

  if not Assigned(FComport) then
  begin
    FComport.Create(nil);
    FComport.OnRxChar := OnReceiveComm;
  end;

  with FComport do
  begin
    FlowControl.ControlDTR := dtrEnable;
    Port := APortName;
    BaudRate := StrToBaudRate(ABaudRate);
    StopBits := StrToStopBits(AStopBit);
    DataBits := StrToDataBits(ADataBit);
    Parity.Bits := StrToParity(AParity);
  end;

  Result := True;
end;

function TSerialCommThread.LoiadComPortFromFile(AIniFileName: string): Boolean;
begin
  Result := False;

  if not Assigned(FComport) then
  begin
    FComport.Create(nil);
    FComport.OnRxChar := OnReceiveComm;
  end;

  if AIniFileName = '' then
    AIniFileName := ChangeFileExt(Application.ExeName, '.ini');

  if FileExists(AIniFileName) then
  begin
    FComport.LoadSettings(stIniFile, AIniFileName);
    Result := True;
  end
  else
    ShowMessage('File not found : ' + AIniFIleName);
end;

procedure TSerialCommThread.OnReceiveComm(Sender: TObject; Count: Integer);
var
  TmpBufStr: String;
  LBufByte: Array[0..255] of Byte;
begin
  try
    SendCopyData2(FOwner.Handle, 'RxTrue', 0);

    if FCommMode = cmChar then
    begin
      //버퍼 초기화
      TmpBufStr := '';
      //버퍼에 문자열을 수신함
      FComPort.ReadStr(TmpBufStr, Count);
      FBufStr := FBufStr + TmpBufStr;

      //CRLF가 없으면 아직 완성되지 않은 패킷임
      if System.Pos(#13#10, FBufStr) = 0 then
        exit;

      FOwner.Hint := FBufStr;
      FBufStr := '';
      SendMessage(FOwner.Handle, WM_RECEIVESTRINGFROMCOMM, 0, 0);
    end
    else
    if FCommMode = cmBin then
    begin
      //버퍼 초기화
      FillChar(LBufByte, SizeOf(LBufByte),0);
      //버퍼에 헥사값을 수신함
      FComPort.Read(LBufByte, Count);

    end;
  finally
    SendCopyData2(FOwner.Handle, 'RxFalse', 0);
  end;
end;

procedure TSerialCommThread.SaveComPortToFile(AIniFileName: string);
begin
  FComport.StoreSettings(stIniFile, AIniFileName);
end;

procedure TSerialCommThread.SendBufClear;
begin
  FillChar(FSendBuf, Length(FSendBuf), #0);
end;

procedure TSerialCommThread.SendQuery;
var
  i: integer;

  procedure InternalSendQuery(ACommand: string; Aindex: integer);
  var
    Li: integer;
  begin
    if StopComm then
      exit;

    SendCopyData2(FOwner.Handle, ' ', 1);
    //SystemBase사의 컨버터에서는 Send시에 RTS를 High로 해야함
    FComport.SetRTS(True);
    //Char Mode인 경우
    if FCommMode = cmChar then
    begin
      FComPort.Writestr(ACommand);
      SendCopyData2(FOwner.Handle, ACommand, 1);
    end
    else if FCommMode = cmBin then// Bin Mode인 경우
    begin
//      SendLength := String2HexByteAry(tmpStr, FSendBuf);
//      FReqByteCount := FSendBuf[5];

//      FComport.Write(FSendBuf[0], SendLength);
//      SendBufClear();
//      SendCopyData2(FOwner.Handle, tmpStr, 1);
    end;

    FOwner.Tag := Aindex;
    FComport.SetRTS(False);
    Sleep(FQueryInterval);

//    if FEventHandle.Wait(FTimeOut) then
//    begin
//      if terminated then
//        exit;
//    end;
  end;
begin
  //Thread가 Suspend되면 종료시에 Resume을 한번 해 주므로
  //종료시에 이 루틴이 실행되지 않게 하기 위함
  if FStopComm then
    exit;

  if FWriteCommandList.Count > 0 then
  begin
    if FIsConfirmAfterWrite then
    begin
      FFunctionMode := CM_CONFIG_WRITE_CONFIRM;
      FIsConfirmAfterWrite := False;
    end
    else
      FFunctionMode := CM_CONFIG_WRITE;

    try
      i := 0;

      while i < FWriteCommandList.Count do
      begin
        SendCopyData2(FOwner.Handle, '=== Write Command ===', 1);
        InternalSendQuery(FWriteCommandList.Strings[i],i);
        Inc(i);

//        FWriteCommandList.Delete(0);
      end;
    finally
      if FRepeatCount = 0 then
        FWriteCommandList.Clear;
    end;
  end;

  if FSendCommandOnce <> '' then
  begin
    FFunctionMode := CM_CONFIG_READ;
    SendCopyData2(FOwner.Handle, '=== Once Read Command ===', 1);
    InternalSendQuery(FSendCommandOnce, -1);
    FSendCommandOnce := '';
  end;

  for i := 0 to FSendCommandList.Count - 1 do
  begin
    FFunctionMode := CM_DATA_READ;

    InternalSendQuery(FSendCommandList.Strings[i],i);
  end;//for
end;

procedure TSerialCommThread.SetQueryInterval(Value: integer);
begin
  if FQueryInterval <> Value then
    FQueryInterval := Value;
end;

procedure TSerialCommThread.SetStopComm(Value: Boolean);
begin
  if FStopComm <> Value then
  begin
    FStopComm := Value;

    if FStopComm then
      //Suspend
    else
      if Suspended then
        Resume;
  end;
end;

procedure TSerialCommThread.SetTimeOut(Value: integer);
begin
  if FTimeOut <> Value then
    FTimeOUt := Value;
end;

end.
