unit UnitOutlookIPCUtil2;

interface

uses System.Classes, Vcl.Dialogs, SysUtils,
  mormot.core.base,
{$IFDEF USE_MORMOT_WS}
  mormot.rest.http.client, mormot.soa.core,
  OLMailWSCallbackInterface2,
{$ENDIF}

{$IFDEF USE_CROMIS_IPC}
  // cromis units
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading,
{$ENDIF}
  UnitMQData, UnitOLDataType;//CommonData

procedure SetWSInfoRec(AIPAddr,APortNo,ATransKey: string;
  AIsWSEnable: Boolean; var ARec: TWSInfoRec);
procedure SetNamedPipeInfoRec(AComputerName, AServerName: string;
  AIsNPEnable: Boolean; var ARec: TWSInfoRec);

function GetOLCommand4CreateMail(ARecord: TEntryIdRecord): string;

{$IFDEF USE_MORMOT_WS}
function GetOLServerServiceIntf(AWSInfoRec: TWSInfoRec): IOLMailService;
function SendReqOLEmailInfo_WS(var AResultList: TStringList; AWSInfoRec: TWSInfoRec): boolean;
function SendReqAddAppointment_WS(AJsonpjhTodoItem: string; AWSInfoRec: TWSInfoRec): boolean;
//function SendReqOLEmailAccountInfo_WS: TOLAccountInfo;
//function SendReqOLEmail2MagFile_WS(ACommand: string): RawUTF8;
{$ENDIF}

{$IFDEF USE_CROMIS_IPC}
function SendReqOLEmailInfo_NamedPipe_Sync(var AResultList: TStringList; AWSInfoRec: TWSInfoRec): boolean;
{$ENDIF}

function GetCmdList4ReplyMail(AEntryId, AStoreId, AHTMLBody: string): TStringList;

{$IFDEF USE_MORMOT_WS}
procedure SendCmd2OL4CreateMail_WS(ACmdList: String; AWSInfoRec: TWSInfoRec);
procedure SendCmd2OL4ReplyMail_WS(ACmdList: TStringList; AWSInfoRec: TWSInfoRec);
procedure SendCmd2OL4ViewEmail_WS(AEntryID, AStoreID: string; AWSInfoRec: TWSInfoRec);
function SendCmd2OL4MoveFolderEmail_WS(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath, ASubFolderName, AHullNo: string;
  AMovedMailInfo: TStringList; AWSInfoRec: TWSInfoRec): boolean;
{$ENDIF}

{$IFDEF USE_CROMIS_IPC}
//procedure SendCmd2OL4CreateMail_NamedPipe(ACmdList: String; AWSInfoRec: TWSInfoRec);
//procedure SendCmd2OL4ReplyMail_NamedPipe(ACmdList: TStringList; AWSInfoRec: TWSInfoRec);
//procedure SendCmd2OL4ViewEmail_NamedPipe(AEntryID, AStoreID: string; AWSInfoRec: TWSInfoRec);
function SendCmd2OL4MoveFolderEmail_NamedPipe_Sync(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath, ASubFolderName, AHullNo: string;
  AMovedMailInfo: TStringList; AWSInfoRec: TWSInfoRec): boolean;
{$ENDIF}


implementation

uses UnitWebSocketClient2, UnitCommonWSInterface2;

procedure SetWSInfoRec(AIPAddr,APortNo,ATransKey: string;
  AIsWSEnable: Boolean; var ARec: TWSInfoRec);
begin
  ARec.FIPAddr := AIPAddr;
  ARec.FPortNo := APortNo;
  ARec.FTransKey := ATransKey;
  ARec.FIsWSEnabled := AIsWSEnable;
end;

procedure SetNamedPipeInfoRec(AComputerName, AServerName: string;
  AIsNPEnable: Boolean; var ARec: TWSInfoRec);
begin
  ARec.FComputerName := AComputerName;
  ARec.FServerName := AServerName;
  ARec.FNamedPipeEnabled := AIsNPEnable;
end;

function GetOLCommand4CreateMail(ARecord: TEntryIdRecord): string;
var
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_CREATE_MAIL);
    LStrList.Add('Subject='+ARecord.FSubject);
    LStrList.Add('To='+ARecord.FTo);
    LStrList.Add('HTMLBody='+ARecord.FHTMLBody);
    LStrList.Add('TaskInfoAttached='+ARecord.FAttached);
    LStrList.Add('AttachedFileName='+'.\'+ARecord.FAttachFileName);

    Result := LStrList.Text;
  finally
    LStrList.Free;
  end;
end;

{$IFDEF USE_MORMOT_WS}
//Client를 해제할 방법이 없어서 사용 안함
function GetOLServerServiceIntf(AWSInfoRec: TWSInfoRec): IOLMailService;
var
  Client: TRestHttpClientWebsockets;
  LResult: string;
begin
  Client := GetClientWS(AWSInfoRec.FIPAddr, AWSInfoRec.FPortNo,
    AWSInfoRec.FTransKey, [IOLMailService], LResult);

  if LResult <> '' then
    exit;

  if not Client.Services.Resolve(IOLMailService, Result) then
    raise EServiceException.Create('Service IOLMailService unavailable');
end;

function SendReqOLEmailInfo_WS(var AResultList: TStringList; AWSInfoRec: TWSInfoRec): boolean;
var
  Client: TRestHttpClientWebsockets;
//  OLService: IOLMailService;
  WSService: IOLMailService;
  LStrList: TStringList;
  LCommand, LRespond: String;
begin
  Result := False;

  Client := GetClientWS(AWSInfoRec.FIPAddr, AWSInfoRec.FPortNo, AWSInfoRec.FTransKey, [IOLMailService], LRespond);

  if not Assigned(Client) then
  begin
    AResultList.Add(LRespond);
    AResultList.Add('Server IP Addr : ' + AWSInfoRec.FIPAddr);
    AResultList.Add('Server Port No : ' + AWSInfoRec.FPortNo);
//    AResultList.Add('TransKey : ' + AWSInfoRec.FTransKey);
//    raise EServiceException.Create(AResultList.Text);
    exit;
  end;

  try
    if not Client.Services.Resolve(IOLMailService, WSService) then
    begin
      AResultList.Text := 'Service ''IOLMailService'' unavailable';
      exit;
//      raise EServiceException.Create('Service IOLMailService unavailable');
    end;

    LStrList := TStringList.Create;
    try
      LStrList.Add('ServerName='+WS_SERVER_NAME_4_OUTLOOK);
      LStrList.Add('Command='+CMD_REQ_MAILINFO_SEND2);

      if AWSInfoRec.FIsSendMQ then
        LStrList.Add('IsSendMQ=True')
      else
        LStrList.Add('IsSendMQ=False');

      LCommand := LStrList.Text;
//ShowMessage(LCommand);
      LRespond := WSService.ServerExecute(LCommand);

      if LRespond <> '' then
      begin
        LStrList.Clear;
        LStrList.Text := LRespond;
        LCommand := LStrList.Values['Command'];

        if LCommand = CMD_SEND_MAIL_ENTRYID2 then
        begin
          AResultList.Text := LStrList.Text;
          Result := True;
        end
        else
        begin
          AResultList.Text := LStrList.Text;
          AResultList.Add('**> Respond is empty <**');
          exit;
        end;
      end;
    finally
//ShowMessage(AResultList.Text);
      LStrList.Free;
    end;
  finally
    WSService := nil;
    Client.Free;
  end;
end;

function SendReqAddAppointment_WS(AJsonpjhTodoItem: string; AWSInfoRec: TWSInfoRec): boolean;
var
  Client: TRestHttpClientWebsockets;
  Service: IOLMailService;
  LCommand, LRespond: String;
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+IPC_SERVER_NAME_4_OUTLOOK2);
    LStrList.Add('Command='+CMD_REQ_ADD_APPOINTMENT);
    LStrList.Add('TodoItemsJson='+AJsonpjhTodoItem);
    LCommand := LStrList.Text;

    Client := GetClientWS(AWSInfoRec.FIPAddr, AWSInfoRec.FPortNo, AWSInfoRec.FTransKey, [IOLMailService], LRespond);;
    try
      if not Client.Services.Resolve(IOLMailService,Service) then
        raise EServiceException.Create('Service IOLMailService unavailable');

      LRespond := Service.ServerExecute(LCommand);
    finally
      Service := nil;
      Client.Free;
    end;
  finally
    LStrList.Free;
  end;
end;

{$ENDIF}

{$IFDEF USE_CROMIS_IPC}
function SendReqOLEmailInfo_NamedPipe_Sync(var AResultList: TStringList; AWSInfoRec: TWSInfoRec): boolean;
var
  LResult: IIPCData;
  Request: IIPCData;
  Client: TIPCClient;

  LStrList: TStringList;
  LCommand, LRespond: String;
begin
  Result := False;
  LRespond := '';

  Client := TIPCClient.Create;
  try
    if AWSInfoRec.FServerName = '' then
      AWSInfoRec.FServerName := IPC_SERVER_NAME_4_OUTLOOK2;

    if AWSInfoRec.FComputerName <> '' then
      Client.ComputerName := AWSInfoRec.FComputerName;

    Client.ServerName := AWSInfoRec.FServerName;
//    ShowMessage('ComputerName: ' + AWSInfoRec.FComputerName + #13#10 +
//      'ServerName : ' + AWSInfoRec.FServerName);
    Client.ConnectClient(cDefaultTimeout);
    try
      if not Client.IsConnected then
      begin
        AResultList.Add('Server Name : ' + AWSInfoRec.FServerName);
        AResultList.Add('Computer Name : ' + AWSInfoRec.FComputerName);
        exit;
      end;

//      ShowMessage('Computer Name : ' + AWSInfoRec.FComputerName + #13#10 + 'Server Name : ' + AWSInfoRec.FServerName);
      LStrList := TStringList.Create;
      try
        LStrList.Add('ServerName='+WS_SERVER_NAME_4_OUTLOOK);
        LStrList.Add('Command='+CMD_REQ_MAILINFO_SEND2);
        LStrList.Add('Kind='+'Synchronous');

        if AWSInfoRec.FIsSendMQ then
          LStrList.Add('IsSendMQ=True')
        else
          LStrList.Add('IsSendMQ=False');

        LCommand := LStrList.Text;

        Request := AcquireIPCData;
        Request.ID := DateTimeToStr(Now);
        Request.Data.WriteUTF8String('Command', LCommand);
//      ShowMessage(LCommand);
        LResult := Client.ExecuteConnectedRequest(Request);
//      ShowMessage('ExecuteConnectedRequest');

        if Client.AnswerValid then
        begin
          LStrList.Clear;
          LStrList.Text := LResult.Data.ReadUTF8String('ResultStr');
          LCommand := LStrList.Values['Command'];

          if LCommand = CMD_SEND_MAIL_ENTRYID2 then
          begin
            AResultList.Text := LStrList.Text;
            Result := True;
          end
          else
          begin
            if Client.LastError <> 0 then
            AResultList.Text := LStrList.Text;
            AResultList.Add('**> Respond has error (Code: ' + IntToStr(Client.LastError) + '<**');
            exit;
          end;
        end;
      finally
        Client.DisconnectClient;
      end;
    finally
      LStrList.Free;
    end;
  finally
    Client.Free;
  end;
end;

function SendCmd2OL4MoveFolderEmail_NamedPipe_Sync(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath, ASubFolderName, AHullNo: string;
  AMovedMailInfo: TStringList; AWSInfoRec: TWSInfoRec): boolean;
begin

end;
{$ENDIF}

function GetCmdList4ReplyMail(AEntryId, AStoreId, AHTMLBody: string): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('ServerName='+WS_SERVER_NAME_4_OUTLOOK);
  Result.Add('Command='+CMD_REQ_REPLY_MAIL);
  Result.Add('EntryId='+AEntryId);
  Result.Add('StoreId='+AStoreId);
  Result.Add('HTMLBody='+AHTMLBody);
end;

{$IFDEF USE_MORMOT_WS}
procedure SendCmd2OL4CreateMail_WS(ACmdList: String; AWSInfoRec: TWSInfoRec);
var
  Client: TRestHttpClientWebsockets;
  Service: IOLMailService;
  LRespond: string;
begin
  Client := GetClientWS(AWSInfoRec.FIPAddr, AWSInfoRec.FPortNo,
    AWSInfoRec.FTransKey, [IOLMailService], LRespond);
  try
    if not Client.Services.Resolve(IOLMailService,Service) then
      raise EServiceException.Create('Service IOLMailService unavailable');

    LRespond := Service.GetOLEmailInfo(ACmdList);
  finally
    Service := nil;
    Client.Free;
  end;
end;

procedure SendCmd2OL4ReplyMail_WS(ACmdList: TStringList; AWSInfoRec: TWSInfoRec);
var
  Client: TRestHttpClientWebsockets;
  Service: IOLMailService;
  LCommand, LRespond: string;
begin
//    if AMailType = 8 then
//    begin
//      LStrList.Add('TaskInfoAttached='+MakeTaskInfoEmailAttached(ATask, LFileName));
//      LStrList.Add('AttachedFileName='+'.\'+LFileName);
//    end;

  LCommand := ACmdList.Text;
  Client := GetClientWS(AWSInfoRec.FIPAddr, AWSInfoRec.FPortNo,
    AWSInfoRec.FTransKey, [IOLMailService], LRespond);
  try
    if not Client.Services.Resolve(IOLMailService,Service) then
      raise EServiceException.Create('Service IOLMailService unavailable');

    LRespond := Service.GetOLEmailInfo(LCommand);
  finally
    Service := nil;
    Client.Free;
  end;
end;

procedure SendCmd2OL4ViewEmail_WS(AEntryID, AStoreID: string; AWSInfoRec: TWSInfoRec);
var
  Client: TRestHttpClientWebsockets;
  OLService: IOLMailService;
  LStrList: TStringList;
  LEntryId, LStoreId: string;
  LCommand, LRespond: string;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+WS_SERVER_NAME_4_OUTLOOK);
    LStrList.Add('Command='+CMD_REQ_MAIL_VIEW);
    LStrList.Add('EntryId='+AEntryID);
    LStrList.Add('StoreId='+AStoreID);
    LCommand := LStrList.Text;

    Client := GetClientWS(AWSInfoRec.FIPAddr, AWSInfoRec.FPortNo,
      AWSInfoRec.FTransKey, [IOLMailService], LRespond);
    try
      if not Client.Services.Resolve(IOLMailService, OLService) then
        raise EServiceException.Create('Service IOLMailService unavailable');

      LRespond := OLService.GetOLEmailInfo(LCommand);
    finally
      OLService := nil;
      Client.Free;
    end;
  finally
    LStrList.Free;
  end;
end;

function SendCmd2OL4MoveFolderEmail_WS(AOriginalEntryId, AOriginalStoreId,
  AMoveStoreId, AMoveStorePath, ASubFolderName, AHullNo: string;
  AMovedMailInfo: TStringList; AWSInfoRec: TWSInfoRec): boolean;
var
  Client: TRestHttpClientWebsockets;
  WSService: IOLMailService;
  LStrList: TStringList;
//  LEmailMsg: TSQLEmailMsg;
  LCommand, LRespond: string;
  LIds: TIDDynArray;
begin
  Result := False;
  LStrList := TStringList.Create;
  try
    LStrList.Add('ServerName='+WS_SERVER_NAME_4_OUTLOOK);
    LStrList.Add('Command='+CMD_REQ_MOVE_FOLDER_MAIL);
    LStrList.Add('EntryId='+AOriginalEntryId);
    LStrList.Add('StoreId='+AOriginalStoreId);
    LStrList.Add('MoveStoreId='+AMoveStoreId);
    LStrList.Add('MoveStorePath='+AMoveStorePath);

    LStrList.Add('HullNo='+AHullNo);

    LStrList.Add('IsCreateHullNoFolder='+'True');
    LStrList.Add('SubFolderName=' + ASubFolderName);
    LCommand := LStrList.Text;

    Client := GetClientWS(AWSInfoRec.FIPAddr, AWSInfoRec.FPortNo, AWSInfoRec.FTransKey, [IOLMailService], LRespond);
    try
      if not Client.Services.Resolve(IOLMailService, WSService) then
        raise EServiceException.Create('Service IOLMailService unavailable');

      LRespond := WSService.ServerExecute(LCommand);
    finally
      WSService := nil;
      Client.Free;
    end;

    if LRespond <> '' then
    begin
      AMovedMailInfo.Text := LRespond;
      LCommand := AMovedMailInfo.Values['Command'];

      if LCommand = CMD_RESPONDE_MOVE_FOLDER_MAIL then
      begin
        AMovedMailInfo.Add('OriginalEntryId='+AOriginalEntryId);
        AMovedMailInfo.Add('OriginalStoreId='+AOriginalStoreId);
        Result := True;
//        LEmailMsg := TSQLEmailMsg.CreateAndFillPrepare(g_ProjectDB,
//            'EntryID = ? AND StoreID = ?', [LEntryId,LStoreId]);
//
//        try
//          if LEmailMsg.FillOne then
//          begin
//            LEmailMsg.EntryID := LStrList.Values['NewEntryId'];
//            LEmailMsg.StoreID := LStrList.Values['MovedStoreId'];
//            LEmailMsg.SavedOLFolderPath := LStrList.Values['MovedFolderPath'];
//            g_ProjectDB.Update(LEmailMsg);
//            Result := True;
//          end;
//        finally
//          FreeAndNil(LEmailMsg);
//        end;
      end;
    end;
  finally
    LStrList.Free;
  end;
end;
{$ENDIF}

end.
