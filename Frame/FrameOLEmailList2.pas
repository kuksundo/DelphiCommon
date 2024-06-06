unit FrameOLEmailList2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.XPStyleActnCtrls, Vcl.ActnMan, Vcl.ComCtrls, Vcl.Buttons, PngBitBtn, Vcl.Menus,
  Vcl.StdCtrls, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ExtCtrls, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  AdvOfficeTabSet, System.Rtti, DateUtils, System.SyncObjs,
  DragDrop, DropTarget,
{$IFDEF USE_OMNITHREAD}
  OtlCommon, OtlComm, OtlTaskControl, OtlContainerObserver, otlTask, OtlParallel,
{$ENDIF}
{$IFDEF USE_CROMIS_IPC}
  // cromis units
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading,
{$ENDIF}
  mormot.core.base, mormot.core.variants, mormot.core.os, mormot.core.buffers,

  UnitHiconisMasterRecord, CommonData2, FrmEditEmailInfo2, UnitOLEmailRecord2,
  UnitStrategy4OLEmailInterface2, UnitOutlookIPCUtil2, UnitSTOMPClass, UnitMQData,
  UnitGAServiceData, UnitOLDataType;

type
  TFrame2 = class(TFrame)
    mailPanel1: TPanel;
    tabMail: TTabControl;
    StatusBar: TStatusBar;
    EmailTab: TAdvOfficeTabSet;
    grid_Mail: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    HullNo: TNxTextColumn;
    Subject: TNxTextColumn;
    RecvDate: TNxDateColumn;
    ProcDirection: TNxTextColumn;
    ContainData: TNxTextColumn;
    Sender: TNxMemoColumn;
    Receiver: TNxMemoColumn;
    CC: TNxMemoColumn;
    BCC: TNxMemoColumn;
    RowID: TNxTextColumn;
    LocalEntryId: TNxTextColumn;
    LocalStoreId: TNxTextColumn;
    SavedOLFolderPath: TNxTextColumn;
    AttachCount: TNxTextColumn;
    panMailButtons: TPanel;
    btnStartProgram: TBitBtn;
    BitBtn1: TBitBtn;
    panProgress: TPanel;
    btnStop: TSpeedButton;
    Progress: TProgressBar;
    Panel1: TPanel;
    Label1: TLabel;
    AutoMove2HullNoCB: TCheckBox;
    MoveFolderCB: TComboBox;
    SubFolderCB: TCheckBox;
    SubFolderNameEdit: TEdit;
    AutoMoveCB: TCheckBox;
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterOutlook: TDataFormatAdapter;
    PopupMenu1: TPopupMenu;
    CreateEMail1: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    N6: TMenuItem;
    N9: TMenuItem;
    SendReply1: TMenuItem;
    APTCoC1: TMenuItem;
    Englisth1: TMenuItem;
    Korean1: TMenuItem;
    N15: TMenuItem;
    N2: TMenuItem;
    SendInvoice1: TMenuItem;
    N4: TMenuItem;
    N10: TMenuItem;
    N14: TMenuItem;
    N12: TMenuItem;
    ForwardEMail1: TMenuItem;
    N11: TMenuItem;
    N13: TMenuItem;
    EditMailInfo1: TMenuItem;
    N1: TMenuItem;
    MoveEmail1: TMenuItem;
    MoveEmailToSelected1: TMenuItem;
    DeleteMail1: TMenuItem;
    N8: TMenuItem;
    ShowMailInfo1: TMenuItem;
    ShowEntryID1: TMenuItem;
    ShowStoreID1: TMenuItem;
    estRemote1: TMenuItem;
    N16: TMenuItem;
    Options1: TMenuItem;
    Send2MQCheck: TMenuItem;
    Timer1: TTimer;
    DBKey: TNxTextColumn;
    SavedMsgFilePath: TNxTextColumn;
    SavedMsgFileName: TNxTextColumn;
    procedure MoveFolderCBDropDown(Sender: TObject);
    procedure SubFolderCBClick(Sender: TObject);
    procedure grid_MailCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure Englisth1Click(Sender: TObject);
    procedure Korean1Click(Sender: TObject);
    procedure EditMailInfo1Click(Sender: TObject);
    procedure MoveEmailToSelected1Click(Sender: TObject);
    procedure DeleteMail1Click(Sender: TObject);
    procedure Send2MQCheckClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FCurrentMailCount: integer;
    FpjhSTOMPClass: TpjhSTOMPClass;
    FEmailDBName: string;
{$IFDEF USE_OMNITHREAD}
    FOLMsg2MQ: TOmniMessageQueue;
{$ENDIF}

{$IFDEF USE_CROMIS_IPC}
    FTaskPool: TTaskPool;
{$ENDIF}

    procedure InitFolderListMenu;
    procedure FinilizeFolderListMenu;
    procedure MoveEmailToFolderClick(Sender: TObject);
    procedure MoveEmail2Folder(AOriginalEntryID, AOriginalStoreID, ANewStoreId,
      ANewStorePath: string; AIsShowResult: Boolean = True);
    procedure DeleteMail(ARow: integer);
    function GetEmailIDFromGrid(ARow: integer): TID;
    procedure ShowEmailContentFromRemote(AGrid: TNextGrid; ARow: integer);
    procedure SendOLEmail2MQ(AEntryIdList: TStrings);

    procedure AddFolderListFromOL(AFolder: string);
    procedure SetMoveFolderIndex;
    function AddEmail2GridNList(ADBKey, AJson: string; AList: TStringList; AFromRemote: Boolean=False): Boolean;

    class function MakeEMailHTMLBody<T>(AMailType: integer): string;

    procedure InitSTOMP(AUserId, APasswd, AServerIP, AServerPort, ATopic: string);
    procedure DestroySTOMP;
  public
    //메일을 이동시킬 Outlook 폴더 리스트,
    //HGS Task/Send Folder Name 2 IPC 메뉴에 의해 OL으로 부터 수신함
    FFolderListFromOL,
    //Remote Mode에서 메일 조회시에 temp 폴더에 GUID.msg 파일로 저장되며
    //창이 닫힐 때 이 파일들을 삭제하기 위함
    FTempEmailMsgFileListFromRemote: TStringList;
    FRemoteIPAddress: string;
    FHullNo, FDBKey, FDBNameSuffix: string;
    FOLFolderListFileName: string;
    //Strategy Design Pattern
    FContext4OLEmail: TContext4OLEmail;
    FWSInfoRec: TWSInfoRec;
    FMQInfoRec: TMQInfoRec;
    FIsSaveEmail2DBWhenDropped: Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    constructor Create(AOwner: TComponent); override;
//    constructor CreateWithOLFolderList(AFolderListFileName, AProdCode: string);

    procedure SetMailCount(ACount: integer);
    procedure SetWSInfoRec4OL(AIPAddr,APortNo,ATransKey: string;
      AIsWSEnable: Boolean);
    procedure SetNamedPipeInfoRec4OL(AComputerName, AServerName: string;
      AIsNPEnable: Boolean);
    procedure SetMQInfoRec4OL(AIPAddr,APortNo,AUserId,APasswd,ATopic: string;
      AIsMQEnable: Boolean);
    procedure ReqVDRAPTCoC(ALang: integer);
    //Frame이 메인폼의 서브폼으로 들어갈때는 Close Button이 Hide 되어야 함
    procedure SetEmbededMode;
    function SetDBName4Email(ADBName: string): Boolean;
    function SetDBKey4Email(ADBKey: string): Boolean;
    procedure SaveEmailFromGrid2DB;
    procedure DeleteEmialFromGrid2DB;
    procedure InitEmailClient(AEmailDBName: string='');
    function GetSenderEmailListFromGrid(AContainData4Mails: TContainData4Mails): string;
    procedure AdjustEnumData2Grid(AGrid: TNextGrid);
    function ShowEmailListFromDBKey(AGrid: TNextGrid; ADBKey: string): integer;

    procedure FillInMoveFolderCB;

    property MailCount: integer read FCurrentMailCount write SetMailCount;
  end;

function ShowEmailListFromJson(AGrid: TNextGrid; AJson: RawUTF8): integer;

implementation
uses ShellApi, mormot.core.mustache, UnitStringUtil, UnitIPCModule2,
  DragDropInternet, UnitHttpModule4InqManageServer2,
  //UnitGAMakeReport,
  UnitBase64Util2, UnitMustacheUtil2, UnitMakeReport2, StrUtils, UnitJHPFileData,
  UnitNextGridUtil2;

{$R *.dfm}

{ TFrame2 }

function ShowEmailListFromJson(AGrid: TNextGrid; AJson: RawUTF8): integer;
var
  LDocData: TDocVariantData;
  LVar: variant;
  LStr: string;
  i, LRow: integer;
begin
  AGrid.BeginUpdate;
  try
    //AJson = [] 형식의 Email List임
    LVar := _JSON(AJson);
    Result := GetListFromVariant2NextGrid(AGrid, LVar, True, True);
//    //AJson = [] 형식의 Email List임
//    LDocData.InitJSON(AJson);
//
//    with AGrid do
//    begin
//      ClearRows;
//
//      for i := 0 to LDocData.Count - 1 do
//      begin
//        LVar := _JSON(LDocData.Value[i]);
//        LRow := AddRow;
//
//        CellByName['HullNo', LRow].AsString := LVar.HullNo;
//        CellByName['Subject', LRow].AsString := LVar.Subject;
//        CellByName['RecvDate', LRow].AsDateTime := TimeLogToDateTime(LVar.RecvDate);
//        CellByName['Sender', LRow].AsString := LVar.Sender;
//        CellByName['Receiver', LRow].AsString := LVar.Receiver;
//        CellByName['CC', LRow].AsString := LVar.CarbonCopy;
//        CellByName['BCC', LRow].AsString := LVar.BlindCC;
//        CellByName['EMailId', LRow].AsString := IntToStr(LVar.RowID);
//        CellByName['LocalEntryID', LRow].AsString := LVar.LocalEntryID;
//        CellByName['LocalStoreID', LRow].AsString := LVar.LocalStoreID;
//        CellByName['FolderPath', LRow].AsString := LVar.SavedOLFolderPath;
//        CellByName['AttachCount', LRow].AsString := LVar.AttachCount;
//
//        if LVar.ContainData <> Ord(cdmNone) then
//        begin
//          LStr := TRttiEnumerationType.GetName<TContainData4Mail>(LVar.ContainData);
//          CellByName['ContainData', LRow].AsString := LStr;
//        end;
//
//        if LVar.ParentID = '' then
//        begin
//          MoveRow(LRow, 0);
//          LRow := 0;
//        end;
//      end;
//    end;
  finally
//    Result := LDocData.Count;
    AGrid.EndUpdate;
  end;
end;

function TFrame2.AddEmail2GridNList(ADBKey, AJson: string; AList: TStringList; AFromRemote: Boolean): Boolean;
var
  LVarArr: TVariantDynArray;
  i: integer;
  LUtf8: RawUTF8;
  LEmailMsg: TSQLOLEmailMsg;
  LWhere: string;
begin
  Result := False;
  LVarArr := JSONToVariantDynArray(AJson);

  if AFromRemote then
    LWhere := 'RemoteEntryID = ? AND RemoteStoreID = ?'
  else
    LWhere := 'LocalEntryID = ? AND LocalStoreID = ?';

  for i := 0 to High(LVarArr) do
  begin
    if (LVarArr[i].LocalEntryId <> '') and (LVarArr[i].LocalStoreId <> '') then
    begin
      LEmailMsg := TSQLOLEmailMsg.CreateAndFillPrepare(g_OLEmailMsgDB.Orm,
        'DBKey = ? AND ' + LWhere, [ADBKey, LVarArr[i].EntryId, LVarArr[i].StoreId]);
      try
        //DB에 동일한 데이터가 없으면 email을 Grid에 추가
        if not LEmailMsg.FillOne then
        begin
          GetListFromVariant2NextGrid(grid_Mail, LVarArr[i], True, False, True);
          //"jhpark@hyundai-gs.com\VDR\" 형식으로 저장 됨
//          LEmailMsg.SavedMsgFilePath := GetFolderPathFromEmailPath(LUtf8);
          AList.Add(LEmailMsg.LocalEntryId + '=' + LEmailMsg.LocalStoreId);
          Result := True;
        end
        else
          ShowMessage('Email (' + LEmailMsg.Subject  + ') is already exists.');
      finally
        FreeAndNil(LEmailMsg);
      end;
    end;
  end;//for

end;

procedure TFrame2.AddFolderListFromOL(AFolder: string);
begin
  if FFolderListFromOL.IndexOf(AFolder) = -1  then
  begin
    FFolderListFromOL.Add(AFolder);
    SetCurrentDir(ExtractFilePath(Application.ExeName));

    if FileExists(FOLFolderListFileName) then
      DeleteFile(FOLFolderListFileName);

    FFolderListFromOL.SaveToFile(FOLFolderListFileName);
  end
  else
    ShowMessage('동일한 Folder 이름이 존재함 : ' + AFolder);
end;

procedure TFrame2.AdjustEnumData2Grid(AGrid: TNextGrid);
var
  i, LRow: integer;
begin
  for LRow := 0 to AGrid.RowCount - 1 do
  begin
    i := StrToIntDef(AGrid.CellsByName['ProcDirection', LRow],-1);

    if i <> -1 then
      AGrid.CellsByName['ProcDirection', LRow] := g_ProcessDirection.ToString(i);

    i := StrToIntDef(AGrid.CellsByName['ContainData', LRow],-1);

    if i <> -1 then
      AGrid.CellsByName['ContainData', LRow] := g_ContainData4Mail.ToString(i);
  end;
end;

constructor TFrame2.Create(AOwner: TComponent);
begin
  FEmailDBName := '';
  DOC_DIR := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName) + 'Doc');
  FContext4OLEmail := TContext4OLEmail.Create;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  FFolderListFromOL := TStringList.Create;
  FTempEmailMsgFileListFromRemote := TStringList.Create;
  FRemoteIPAddress := '';
  FpjhSTOMPClass := nil;
  FIsSaveEmail2DBWhenDropped := False;
//  FWorker4OLMsg2MQ := TWorker4OLMsg2MQ.Create(FOLMsg2MQ);

  if FOLFolderListFileName = '' then
    FOLFolderListFileName := '.\'+OLFOLDER_LIST_FILE_NAME;

  if FileExists(FOLFolderListFileName) then
    FFolderListFromOL.LoadFromFile(FOLFolderListFileName);

//  MoveFolderCBDropDown(nil);

  if FMQInfoRec.FIsEnableMQ then
  begin
{$IFDEF USE_OMNITHREAD}
    FOLMsg2MQ := TOmniMessageQueue.Create(100);
{$ENDIF}
    InitSTOMP(FMQInfoRec.FUserId,FMQInfoRec.FPasswd,FMQInfoRec.FIPAddr,
      FMQInfoRec.FPortNo,FMQInfoRec.FTopic);
  end;

  inherited;
end;

procedure TFrame2.DeleteEmialFromGrid2DB;
var
  i, LID: integer;
begin
  for i := grid_Mail.RowCount - 1 downto 0 do
  begin
    if not grid_Mail.RowVisible[i] then
    begin
      LID := GetEmailIDFromGrid(i);
      if DeleteOLMail2DBFromID(LID) then
        grid_Mail.DeleteRow(i);
    end;
  end;
end;

procedure TFrame2.DeleteMail(ARow: integer);
//var
//  LEmailID: integer;
begin
  if ARow = -1 then
    exit;

  if MessageDlg('Aru you sure delete the selected item?.', mtConfirmation, [mbYes, mbNo],0) = mrYes then
    grid_Mail.RowVisible[ARow] := False;

//  LEmailID := GetEmailIDFromGrid(ARow);
//
//  if LEmailID > -1 then
//  begin
//    DeleteOLMail2DBFromID(LEmailID);
//    MailCount := ShowEmailListFromDBKey(grid_Mail, FDBKey);
//  end;
end;

procedure TFrame2.DeleteMail1Click(Sender: TObject);
begin
  DeleteMail(grid_Mail.SelectedRow);
end;

destructor TFrame2.Destroy;
begin
  FFolderListFromOL.Free;
  FTempEmailMsgFileListFromRemote.Free;
  FContext4OLEmail.Free;
  DestroyOLEmailMsg;

  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.DisConnectStomp;
//  if Assigned(FWorker4OLMsg2MQ) then
//  begin
//    FWorker4OLMsg2MQ.Terminate;
//    FWorker4OLMsg2MQ.Stop;
//  end;

{$IFDEF USE_OMNITHREAD}
  if Assigned(FOLMsg2MQ) then
    FreeAndNil(FOLMsg2MQ);
{$ENDIF}

  DestroySTOMP;

  inherited;
end;

procedure TFrame2.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
    FreeAndNil(FpjhSTOMPClass);
end;

procedure TFrame2.DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
var
  OutlookDataFormat: TOutlookDataFormat;
  LIsMultiDrop: boolean;
  i: integer;
  LIds: TIDDynArray;
  LIsNewMailAdded: Boolean;
  LDroppedMailList, LNewAddedEmailList: TStringList;
  LOriginalEntryId, LOriginalStoreId,
  LJson, LNewStoreId, LNewStorePath: string;
begin
  if (DataFormatAdapterOutlook.DataFormat <> nil) then
  begin
    OutlookDataFormat := DataFormatAdapterOutlook.DataFormat as TOutlookDataFormat;
    LIsMultiDrop := OutlookDataFormat.Messages.Count > 1;

    LDroppedMailList := TStringList.Create;
    LNewAddedEmailList := TStringList.Create;
    try
      FWSInfoRec.FIsSendMQ := Send2MQCheck.Checked;
      //OutLook(WevSocket)에게 현재 Drop한 email list 요청
{$IFDEF USE_MORMOT_WS}
      if SendReqOLEmailInfo_WS(LDroppedMailList, FWSInfoRec) then
{$ENDIF}

{$IFDEF USE_CROMIS_IPC}
      if SendReqOLEmailInfo_NamedPipe_Sync(LDroppedMailList, FWSInfoRec) then
{$ENDIF}
      begin
        LJson := LDroppedMailList.Values['MailInfos'];
//ShowMessage('LJson :' + #13#10 + LJson);
        //Email List를 DB에 저장
        if FIsSaveEmail2DBWhenDropped then
          LIsNewMailAdded := AddOLMail2DBFromDroppedMail(FDBKey, FHullNo, LJson, LNewAddedEmailList)
        else
          LIsNewMailAdded := AddEmail2GridNList(FDBKey, LJson, LNewAddedEmailList);
      end
      else
      begin
        ShowMessage(LDroppedMailList.Text);
        Exit;
      end;

      //새 메일이 그리드에 추가 되었으면 Refresh
      if LIsNewMailAdded then
      begin
        if (MoveFolderCB.ItemIndex > -1) and (AutoMoveCB.Checked) then
        begin
          LNewStoreId := FFolderListFromOL.ValueFromIndex[MoveFolderCB.ItemIndex];
          LNewStorePath := FFolderListFromOL.Names[MoveFolderCB.ItemIndex];
        end
        else
        begin
          LNewStoreId := '';
          LNewStorePath := '';
        end;

        if (LNewStoreId <> '') and (LNewStorePath <> '') then
        begin
          for i := 0 to LNewAddedEmailList.Count - 1 do
          begin
            LOriginalEntryId := LNewAddedEmailList.Names[i];
            LOriginalStoreId := LNewAddedEmailList.ValueFromIndex[i];
            MoveEmail2Folder(LOriginalEntryId, LOriginalStoreId, LNewStoreId, LNewStorePath, False);

//            if SendCmd2OL4MoveFolderEmail_WS(LOriginalEntryId, LOriginalStoreId,
//              LStoreId, LStorePath, LSubFolder, LHullNo, LDroppedMailList, FWSInfoRec) then
//            begin
//              UpdateOlMail2DBFromMovedMail(LDroppedMailList);
//            end;
          end;

          ShowMessage('Email move to folder( ' + LNewStorePath + ' ) completed!' + #13#10 +
            '( ' + IntToStr(OutlookDataFormat.Messages.Count) + ' 건 )');
        end;

        SendOLEmail2MQ(LNewAddedEmailList);

        if FIsSaveEmail2DBWhenDropped then
          MailCount := ShowEmailListFromDBKey(grid_Mail, FDBKey);
      end;
    finally
      LNewAddedEmailList.Free;
      LDroppedMailList.Free;
    end;
  end;
end;

procedure TFrame2.EditMailInfo1Click(Sender: TObject);
var
  LEmailInfoF: TEmailInfoF;
  LEmailID: integer;
  LContainData, LProcDirection: integer;
  LContainData2, LProcDirection2: string;
begin
  LEmailID := -1;

  if grid_Mail.CellsByName['RowID', grid_Mail.SelectedRow] <> '' then
  begin
    LEmailID := GetEmailIDFromGrid(grid_Mail.SelectedRow);

//    if LEmailID > -1 then
//      GetContainDataNDirFromID(LEmailID, LContainData, LProcDirection);
  end;

  LProcDirection := g_ProcessDirection.ToOrdinal(grid_Mail.CellsByName['ProcDirection', grid_Mail.SelectedRow]);
  LContainData := g_ContainData4Mail.ToOrdinal(grid_Mail.CellsByName['ContainData', grid_Mail.SelectedRow]);

  LEmailInfoF := TEmailInfoF.Create(nil);
  try
    //데이터가 있으면
//    if (LContainData <> -1) and (LProcDirection = -1) then
//    begin
      LEmailInfoF.ContainDataCB.ItemIndex := LContainData;
      LEmailInfoF.EmailDirectionCB.ItemIndex := LProcDirection;
//    end;

    if LEmailInfoF.ShowModal = mrOK then
    begin
      LContainData2 := g_ContainData4Mail.ToString(LEmailInfoF.ContainDataCB.ItemIndex);
      LProcDirection2 := g_ProcessDirection.ToString(LEmailInfoF.EmailDirectionCB.ItemIndex);

      grid_Mail.CellsByName['ProcDirection', grid_Mail.SelectedRow] := LProcDirection2;
      grid_Mail.CellsByName['ContainData', grid_Mail.SelectedRow] := LContainData2;

//      if LEmailID = -1 then
//        UpdateOLMail2DBFromContainDataNProcdir(LEmailID, LContainData2, LProcDirection2);
//
//      ShowEmailListFromDBKey(grid_Mail, FDBKey);
    end;
  finally
    LEmailInfoF.Free;
  end;

//    FTask.EmailMsg.ManyDelete(g_ProjectDB, FTask.ID, LEmailID);
//    g_ProjectDB.Delete(TSQLEmailMsg, LEmailID);
end;

procedure TFrame2.Englisth1Click(Sender: TObject);
begin
  ReqVDRAPTCoC(1);
end;

procedure TFrame2.FillInMoveFolderCB;
var
  i: integer;
begin
  MoveFolderCB.Clear;

  for i := 0 to FFolderListFromOL.Count - 1 do
    MoveFolderCB.Items.Add(FFolderListFromOL.Names[i]);
end;

procedure TFrame2.FinilizeFolderListMenu;
begin

end;

function TFrame2.GetEmailIDFromGrid(ARow: integer): TID;
begin
  if ARow <> -1 then
  begin
    Result := grid_Mail.CellByName['RowID', ARow].AsInteger
  end
  else
    Result := -1;
end;

function TFrame2.GetSenderEmailListFromGrid(
  AContainData4Mails: TContainData4Mails): string;
var
  i: integer;
  LContainData4Mails: TContainData4Mail;
begin
  Result := '';

  for i := 0 to grid_Mail.RowCount - 1 do
  begin
    LContainData4Mails := g_ContainData4Mail.ToType(grid_Mail.CellsByName['ContainData',i]);

    if LContainData4Mails in AContainData4Mails then
    begin
      Result := Result + grid_Mail.CellsByName['Sender',i] + ';';
    end;
  end;
end;

procedure TFrame2.grid_MailCellDblClick(Sender: TObject; ACol, ARow: Integer);
var
  LEntryID, LStoreID: string;
begin
  if ARow = -1 then
    exit;

  LEntryID := grid_Mail.CellsByName['LocalEntryId', ARow];
  LStoreID := grid_Mail.CellsByName['LocalStoreId', ARow];

  if FRemoteIPAddress = '' then
{$IFDEF USE_MORMOT_WS}
    SendCmd2OL4ViewEmail_WS(LEntryID, LStoreID, FWSInfoRec)
{$ELSE}
  {$IFDEF USE_CROMIS_IPC}
//    SendCmd2OL4ViewEmail_NamedPipe(LEntryID, LStoreID, FWSInfoRec)
  {$ENDIF}
{$ENDIF}
  else
    ShowEmailContentFromRemote(grid_Mail, ARow);

  NextGridScrollToRow(grid_Mail);
end;

procedure TFrame2.InitEmailClient(AEmailDBName: string);
begin
  if AEmailDBName = '' then
    AEmailDBName := FEmailDBName;

  InitOLEmailMsgClient(AEmailDBName);
end;

procedure TFrame2.InitFolderListMenu;
var
  i: integer;
  LMenu: TMenuItem;
begin
  MoveEmail1.Clear;

  for i := 0 to FFolderListFromOL.Count - 1 do
  begin
    LMenu := TMenuItem.Create(MoveEmail1);
    LMenu.Caption := FFolderListFromOL.Names[i];
//    ShowMessage(FFolderListFromOL.Names[i]);
    LMenu.Tag := i;
    LMenu.OnClick := MoveEmailToFolderClick;
    MoveEmail1.Add(LMenu);
  end;
end;

procedure TFrame2.InitSTOMP(AUserId, APasswd, AServerIP, AServerPort,
  ATopic: string);
begin
  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(AUserId,
                                            APasswd,
                                            AServerIP,
                                            AServerPort,
                                            ATopic,
                                            Self.Handle,False,False);
  end;
end;

procedure TFrame2.Korean1Click(Sender: TObject);
begin
  ReqVDRAPTCoC(2);
end;

class function TFrame2.MakeEMailHTMLBody<T>(AMailType: integer): string;
begin
  case AMailType of
    0:;
//    1: Result := MakeInvoiceEmailBody(ATask);
//    2: Result := MakeSalesReqEmailBody(ATask, ASalesPICSig, AMyNameSig);
//    3: Result := MakeDirectShippingEmailBody(ATask);
//    4: Result := MakeForeignRegEmailBody(ATask);
//    5: Result := MakeElecHullRegReqEmailBody(ATask, AElecHullRegPICSig, AMyNameSig);
//    6: Result := MakePOReqEmailBody(ATask);
//    7: Result := MakeShippingReqEmailBody(ATask, ATaskAShippingPICSig, AMyNameSig);
//    8: Result := MakeForwardFieldServiceEmailBody(ATask, AFieldServicePICSig, AMyNameSig);
////    9: Result := MakeSubConQuotationReqEmailBody(ATask, ASubConPICSig, AMyNameSig);
//    10: Result := '[서비스 오더 날인 및 회신 요청] / ' + ATask.HullNo + ', 공사번호: ' + ATask.Order_No;
//    11: Result := MakeForwardPayCheckSubConEmailBody(ATask, AMyNameSig);//'[업체 기성 확인 요청] / ' + ATask.HullNo + ', 공사번호: ' + ATask.Order_No;
//    12: Result := '[업체 기성 처리 요청] / ' + ATask.HullNo + ', 공사번호: ' + ATask.Order_No;
  end;
end;

procedure TFrame2.MoveEmail2Folder(AOriginalEntryID, AOriginalStoreID,
  ANewStoreId, ANewStorePath: string; AIsShowResult: Boolean);
var
  LOriginalEntryId, LOriginalStoreId,
  LSubFolder, LHullNo: string;
  LMovedMailList: TStringList;
begin
  LSubFolder := '';
  LHullNo := '';

  if AutoMove2HullNoCB.Checked then
    LHullNo := FHullNo;

  if SubFolderCB.Checked then
    LSubFolder := SubFolderNameEdit.Text;

  LMovedMailList := TStringList.Create;
  try
    if (ANewStoreId <> '') and (ANewStorePath <> '') then
    begin
{$IFDEF USE_MORMOT_WS}
      if SendCmd2OL4MoveFolderEmail_WS(AOriginalEntryID, AOriginalStoreID,
{$ELSE}
  {$IFDEF USE_CROMIS_IPC}
      if SendCmd2OL4MoveFolderEmail_NamedPipe_Sync(AOriginalEntryID, AOriginalStoreID,
  {$ENDIF}
{$ENDIF}
        ANewStoreId, ANewStorePath, LSubFolder, LHullNo, LMovedMailList, FWSInfoRec) then
      begin
        UpdateOlMail2DBFromMovedMail(LMovedMailList, False);

        if AIsShowResult then
          ShowMessage('Email move to folder( ' + ANewStorePath + ' ) completed!');
      end;
    end;

//    if Assigned(Sender) then
//    begin
//      if SendCmd2OL4MoveFolderEmail_WS(AOriginalEntryID, AOriginalStoreID,
//        FFolderListFromOL.ValueFromIndex[TMenuItem(Sender).Tag],
//        FFolderListFromOL.Names[TMenuItem(Sender).Tag], LSubFolder, LHullNo,
//        LMovedMailList, FWSInfoRec) then
//      begin
//        UpdateOlMail2DBFromMovedMail(LMovedMailList);
//        ShowMessage('Email move to folder( ' +
//          FFolderListFromOL.Names[TMenuItem(Sender).Tag] + ' ) completed!');
//      end;
//    end
//    else
//    begin
//      if SendCmd2OL4MoveFolderEmail_WS(AOriginalEntryID, AOriginalStoreID,
//        FFolderListFromOL.ValueFromIndex[MoveFolderCB.ItemIndex],
//        FFolderListFromOL.Names[MoveFolderCB.ItemIndex], LSubFolder, LHullNo,
//        LMovedMailList, FWSInfoRec) then
//      begin
//        UpdateOlMail2DBFromMovedMail(LMovedMailList);
//        ShowMessage('Email move to Selected folder( ' +
//          FFolderListFromOL.Names[MoveFolderCB.ItemIndex] + ' ) completed!');
//      end;
//    end;
  finally
    LMovedMailList.Free;
  end;
end;

procedure TFrame2.MoveEmailToFolderClick(Sender: TObject);
var
  LOriginalEntryId, LOriginalStoreId: string;
begin
  if grid_Mail.SelectedRow = -1 then
    exit;

  LOriginalEntryId := grid_Mail.CellByName['LocalEntryId', grid_Mail.SelectedRow].AsString;
  LOriginalStoreId := grid_Mail.CellByName['LocalStoreId', grid_Mail.SelectedRow].AsString;

  MoveEmail2Folder(LOriginalEntryId, LOriginalStoreId,
    FFolderListFromOL.ValueFromIndex[TMenuItem(Sender).Tag],
    FFolderListFromOL.Names[TMenuItem(Sender).Tag]);
  ShowEmailListFromDBKey(grid_Mail, FDBKey);
end;

procedure TFrame2.MoveEmailToSelected1Click(Sender: TObject);
var
  LOriginalEntryId, LOriginalStoreId, LNewStoreId, LNewStorePath: string;
begin
  if MoveFolderCB.ItemIndex = -1 then
  begin
    ShowMessage('Select Move Folder First!');
    exit;
  end;

  LOriginalEntryId := grid_Mail.CellByName['LocalEntryId', grid_Mail.SelectedRow].AsString;
  LOriginalStoreId := grid_Mail.CellByName['LocalStoreId', grid_Mail.SelectedRow].AsString;
  LNewStoreId := FFolderListFromOL.ValueFromIndex[MoveFolderCB.ItemIndex];
  LNewStorePath := FFolderListFromOL.Names[MoveFolderCB.ItemIndex];

  MoveEmail2Folder(LOriginalEntryId, LOriginalStoreId, LNewStoreId, LNewStorePath);
  ShowEmailListFromDBKey(grid_Mail, FDBKey);
end;

procedure TFrame2.MoveFolderCBDropDown(Sender: TObject);
begin
  FillInMoveFolderCB;
end;

procedure TFrame2.ReqVDRAPTCoC(ALang: integer);
var
  LEntryId, LStoreId, LHTMLBody, LAttachment: string;
  LCmdList: TStringList;
  LFileContents: RawUTF8;
  LRaw: RawByteString;
  LOLEmailActionRec: TOLEmailActionRecord;
begin
  LEntryId := grid_Mail.CellByName['LocalEntryId', grid_Mail.SelectedRow].AsString;
  LStoreId := grid_Mail.CellByName['LocalStoreId', grid_Mail.SelectedRow].AsString;

  LOLEmailActionRec.FEmailAction := ACTION_MakeEmailHTMLBody;
  LOLEmailActionRec.FMailKind := MAILKIND_VDRAPT_REPLY_WITHNOMAKEZIP;

  if ALang = 1 then
    LOLEmailActionRec.FTemplateFileName := DOC_DIR + VDR_APT_COC_ENG_SEND_MUSTACHE_FILE_NAME
  else
  if ALang = 2 then
    LOLEmailActionRec.FTemplateFileName := DOC_DIR + VDR_APT_COC_KOR_SEND_MUSTACHE_FILE_NAME;

  LHTMLBody := FContext4OLEmail.Algorithm4EmailAction(LOLEmailActionRec);

  LCmdList := GetCmdList4ReplyMail(LEntryId, LStoreId, LHTMLBody);
  try
    LOLEmailActionRec.FEmailAction := ACTION_MakeAttachFile;
    LOLEmailActionRec.FMailKind := MAILKIND_VDRAPT_REPLY_IFZIPEXIST;
    LOLEmailActionRec.FFileKind := g_JHPFileFormat.ToOrdinal(gfkWORD);
    LAttachment := FContext4OLEmail.Algorithm4EmailAction(LOLEmailActionRec);

    if FileExists(LAttachment) then
    begin
      LRaw := StringFromFile(LAttachment);
      LFileContents := MakeRawUTF8ToBin64(LRaw);

      LCmdList.Add('AttachedFileName='+ExtractFileName(LAttachment));
      LCmdList.Add('MakeBase64ToString='+'True');
      LCmdList.Add('FileContent='+UTF8ToString(LFileContents));
    end;

    LCmdList.Add('To=REPLYALL');

{$IFDEF USE_MORMOT_WS}
    SendCmd2OL4ReplyMail_WS(LCmdList, FWSInfoRec);
{$ELSE}
  {$IFDEF USE_CROMIS_IPC}
//    SendCmd2OL4ReplyMail_WS(LCmdList, FWSInfoRec);
  {$ENDIF}
{$ENDIF}
  finally
    LCmdList.Free;
  end;
end;

procedure TFrame2.SaveEmailFromGrid2DB;
var
  LDoc: variant;
  LJsonArray: string;
begin
  if grid_Mail.RowCount = 0 then
    exit;

  DeleteEmialFromGrid2DB;
  LDoc := NextGrid2Variant(grid_Mail);
  LJsonArray := LDoc;
  AddOLMail2DBFromDroppedMail(FDBKey, '', LJsonArray, nil);
end;

procedure TFrame2.Send2MQCheckClick(Sender: TObject);
begin
  Send2MQCheck.Checked := not Send2MQCheck.Checked;
end;

procedure TFrame2.SendOLEmail2MQ(AEntryIdList: TStrings);
var
{$IFDEF USE_OMNITHREAD}
  LOmniValue: TOmniValue;
{$ENDIF}
  LRec: TOLMsgFile4STOMP;
  LRaw: RawByteString;
  LMsgFileName: string;
  LUtf8: RawUTF8;
begin
  if not FMQInfoRec.FIsEnableMQ then
    exit;

  LRaw := StringFromFile(LMsgFileName);
  LRaw := SynLZCompress(LRaw);
  LUtf8 := BinToBase64(LRaw);
  LRec.FMsgFile := UTF8ToString(LUtf8);
  LRec.FHost := FMQInfoRec.FIPAddr;
  LRec.FUserId := FMQInfoRec.FUserId;
  LRec.FPasswd := FMQInfoRec.FPasswd;
  LRec.FTopic := FMQInfoRec.FTopic;
//  LOmniValue := TOmniValue.FromRecord<TOLMsgFile4STOMP>(LRec);
//  FOLMsg2MQ.Enqueue(TOmniMessage.Create(1, LOmniValue));

  FpjhSTOMPClass.StompSendMsgThread(LRec.FMsgFile, LRec.FTopic);
end;

function TFrame2.SetDBKey4Email(ADBKey: string): Boolean;
begin
  if ADBKey = '' then
    exit;

  Result := FDBKey <> ADBKey;

  if Result then
    FDBKey := ADBKey;
end;

function TFrame2.SetDBName4Email(ADBName: string) : Boolean;
begin
  if ADBName = '' then
    exit;

  Result := FEmailDBName <> ADBName;

  if Result then
    FEmailDBName := ADBName;
end;

procedure TFrame2.SetEmbededMode;
begin
  panMailButtons.Visible := False;
end;

procedure TFrame2.SetMailCount(ACount: integer);
begin
  if FCurrentMailCount <> ACount then
  begin
    FCurrentMailCount := ACount;
    StatusBar.Panels[1].Text := IntToStr(ACount);
  end;
end;

procedure TFrame2.SetMoveFolderIndex;
var
  i: integer;
  LStr: RawUTF8;
begin
  LStr := GetFirstStoreIdFromDBKey(FDBKey);
  for i := 0 to FFolderListFromOL.Count - 1 do
    if FFolderListFromOL.ValueFromIndex[i] = UTF8ToString(LStr) then
    begin
      MoveFolderCB.ItemIndex := i;
      Break;
    end;
end;

procedure TFrame2.SetMQInfoRec4OL(AIPAddr, APortNo, AUserId, APasswd,
  ATopic: string; AIsMQEnable: Boolean);
begin
  SetMQInfoRec(AIPAddr, APortNo, AUserId, APasswd,ATopic,AIsMQEnable,FMQInfoRec);
//  FMQInfoRec.FIPAddr := AIPAddr;
//  FMQInfoRec.FPortNo := APortNo;
//  FMQInfoRec.FUserId := AUserId;
//  FMQInfoRec.FPasswd := APasswd;
//  FMQInfoRec.FTopic := ATopic;
//  FMQInfoRec.FIsEnableMQ := AIsMQEnable;

  Send2MQCheck.Checked := AIsMQEnable;
  Send2MQCheck.Enabled := AIsMQEnable;
end;

procedure TFrame2.SetNamedPipeInfoRec4OL(AComputerName, AServerName: string; AIsNPEnable: Boolean);
begin
  SetNamedPipeInfoRec(AComputerName, AServerName,AIsNPEnable,FWSInfoRec);
//  FWSInfoRec.FComputerName := AComputerName;
//  FWSInfoRec.FServerName := AServerName;
//  FWSInfoRec.FNamedPipeEnabled := AIsNPEnable;
end;

procedure TFrame2.SetWSInfoRec4OL(AIPAddr, APortNo, ATransKey: string; AIsWSEnable: Boolean);
begin
  SetWSInfoRec(AIPAddr, APortNo, ATransKey,AIsWSEnable,FWSInfoRec);
//  FWSInfoRec.FIPAddr := AIPAddr;
//  FWSInfoRec.FPortNo := APortNo;
//  FWSInfoRec.FTransKey := ATransKey;
//  FWSInfoRec.FIsWSEnabled := AIsWSEnable;
end;

procedure TFrame2.ShowEmailContentFromRemote(AGrid: TNextGrid; ARow: integer);
begin

end;

function TFrame2.ShowEmailListFromDBKey(AGrid: TNextGrid;
  ADBKey: string): integer;
var
  LSQLEmailMsg: TSQLEmailMsg;
  LRow: integer;
  LUtf8: RawUTF8;
begin
  if AGrid.RowCount <> 0 then
    AGrid.ClearRows;

  LUtf8 := GetOLEmailList2JSONArrayFromDBKey(ADBKey);

//  if LUtf8 <> '[]' then
//  begin
    Result := ShowEmailListFromJson(AGrid, LUtf8);
    AdjustEnumData2Grid(AGrid);
//  end;
end;

procedure TFrame2.SubFolderCBClick(Sender: TObject);
begin
  if SubFolderCB.Checked then
    AutoMoveCB.Checked := True;

  SubFolderNameEdit.Enabled := SubFolderCB.Checked;
end;

procedure TFrame2.Timer1Timer(Sender: TObject);
begin
  //EMailDBName을 변경하고 싶으면 SetDBName4Email()함수를 실행할 것
//  if FEmailDBName = '' then
//  begin
//    FEmailDBName := Application.ExeName;
//    FEmailDBName := FEmailDBName.Replace('.exe', '_' + FDBNameSuffix + '.exe');
//  end;
//
//  InitOLEmailMsgClient(FEmailDBName);
  Timer1.Enabled := False;
end;

end.
