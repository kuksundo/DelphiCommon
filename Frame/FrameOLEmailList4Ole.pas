unit FrameOLEmailList4Ole;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.XPStyleActnCtrls, Vcl.ActnMan, Vcl.ComCtrls, Vcl.Buttons, PngBitBtn, Vcl.Menus,
  ActiveX,
  Vcl.StdCtrls, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ExtCtrls, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  AdvOfficeTabSet, System.Rtti, DateUtils, System.SyncObjs,
  DragDrop, DropTarget, MapiDefs, TimerPool,
  OtlCommon, OtlComm, OtlTaskControl, OtlContainerObserver, otlTask, OtlParallel,
{$IFDEF USE_CROMIS_IPC}
  // cromis units
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading,
{$ENDIF}
  mormot.core.base, mormot.core.variants, mormot.core.os, mormot.core.buffers,
  mormot.core.log, mormot.core.unicode, mormot.core.data,

//  FrmEditEmailInfo2,
//  UnitStrategy4OLEmailInterface2, UnitMQData,
  UnitWorker4OmniMsgQ,
  UnitOLControlWorker,
  UnitOutLookDataType, Outlook_TLB, UnitElecServiceData2, UnitOLEmailRecord2,
  AeroButtons, Vcl.ImgList;

type
  TLogProc = procedure(AMsg: string) of object;

  TMessage = class(TObject)
  private
    FMessage: IMessage;
    FStorage: IStorage;
    FAttachments: TInterfaceList;
    FAttachmentsLoaded: boolean;
    function GetAttachments: TInterfaceList;
  public
    constructor Create(const AMessage: IMessage; const AStorage: IStorage);
    destructor Destroy; override;
    procedure SaveToStream(Stream: TStream);
    property Msg: IMessage read FMessage;
    property Attachments: TInterfaceList read GetAttachments;
  end;

  TOutlookEmailListFr = class(TFrame)
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
    SenderName: TNxMemoColumn;
    Recipients: TNxMemoColumn;
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
    ImageList16x16: TImageList;
    AeroButton1: TAeroButton;
    SenderEmail: TNxTextColumn;
    FolderEntryId: TNxTextColumn;
    ClaimNo: TNxTextColumn;
    ProjectNo: TNxTextColumn;
    Description: TNxButtonColumn;
    TaskID: TNxTextColumn;

    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure SubFolderCBClick(Sender: TObject);
    procedure grid_MailCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure Englisth1Click(Sender: TObject);
//    procedure Korean1Click(Sender: TObject);
    procedure EditMailInfo1Click(Sender: TObject);
    procedure MoveEmailToSelected1Click(Sender: TObject);
    procedure DeleteMail1Click(Sender: TObject);
    procedure Send2MQCheckClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure DescriptionButtonClick(Sender: TObject);
  private
    FOLControlWorker: TOLControlWorker;
    FCommandQueue    : TOmniMessageQueue;
    FResponseQueue   : TOmniMessageQueue;
    FSendMsgQueue    : TOmniMessageQueue;
    FPJHTimerPool: TPJHTimerPool;

    FLogProc: TLogProc;
    FMainFormHandle,
    FMyWnd: THandle;

    FEntryIdRecord: TEntryIdRecord;

    FCurrentMailCount: integer;
//    FpjhSTOMPClass: TpjhSTOMPClass;
    FEmailDBName: string;
//{$IFDEF USE_OMNITHREAD}
//    FOLMsg2MQ: TOmniMessageQueue;
//{$ENDIF}
//
//{$IFDEF USE_CROMIS_IPC}
//    FTaskPool: TTaskPool;
//{$ENDIF}

    procedure StartWorker;
    procedure StopWorker;

    procedure OnInitVarTimer(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnGetOLFolderListTimer(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure FrameWndProc(var Message: Winapi.Messages.TMessage);
    procedure OnWorkerResult(var Msg: Winapi.Messages.TMessage);
//    procedure OnWorkerResult(var Msg: TMessage); message MSG_RESULT;

    procedure ProcessRespondFromWorker(AMsgId: integer; ARec: TOLRespondRec);

    procedure InitVar();
    procedure DestroyVar();

    procedure InitFolderListMenu;
    procedure FinilizeFolderListMenu;
    procedure FillFolderListFromRespRec(ARec: TOLRespondRec);

    procedure MoveEmailToFolderClick(Sender: TObject);
    procedure MoveEmail2Folder(AOriginalEntryID, AOriginalStoreID, ANewStoreId,
      ANewStorePath: string; AIsShowResult: Boolean = True);
      //ADynArry: Move할 Email List임
    procedure ReqMoveEmailFolder2Worker(ADynAry: TRawUTF8DynArray);
    function GetEntryIdFromGridJson(ADoc: variant): TEntryIdRecord;

    procedure DeleteMail(ARow: integer);

    function GetEmailIDFromGrid(ARow: integer): TID;
    procedure ShowMailContents(AGrid: TNextGrid; ARow: integer);
    procedure SendOLEmail2MQ(AEntryIdList: TStrings);
    procedure UpdateEmailId2GridFromJson(AJson: string);

    procedure AddFolderListFromOL(AFolder: string);
    procedure SetMoveFolderIndex;
    function AddEmail2GridNList(ADBKey, AJson: string; AList: TStringList; AFromRemote: Boolean=False): Boolean;

    class function MakeEMailHTMLBody<T>(AMailType: integer): string;

    procedure InitSTOMP(AUserId, APasswd, AServerIP, AServerPort, ATopic: string);
    procedure DestroySTOMP;

    procedure InitMAPI();
  public
    //메일을 이동시킬 Outlook 폴더 리스트,
    //HGS Task/Send Folder Name 2 IPC 메뉴에 의해 OL으로 부터 수신함
    FFolderListFromOL,
    //Remote Mode에서 메일 조회시에 temp 폴더에 GUID.msg 파일로 저장되며
    //창이 닫힐 때 이 파일들을 삭제하기 위함
    FTempEmailMsgFileListFromRemote: TStringList;
    FRemoteIPAddress: string;
    FHullNo, FDBNameSuffix: string;
    FDBKey: TID; //TaskID를 사용함
    FOLFolderListFileName: string;
    //Strategy Design Pattern
//    FContext4OLEmail: TContext4OLEmail;
//    FWSInfoRec: TWSInfoRec;
//    FMQInfoRec: TMQInfoRec;
    FIsSaveEmail2DBWhenDropped: Boolean;
    //Frame에 Hullno, ClaimNo, ProjectNo를 전달하기 위한 변수
    FOLEmailSrchRec: TOLEmailSrchRec;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    constructor Create(AOwner: TComponent); override;
//    constructor CreateWithOLFolderList(AFolderListFileName, AProdCode: string);

    procedure SendCmd2WorkerThrd(const ACmd: TOLCommandKind; const AValue: TOmniValue);

    //Result: Drag로 수신한 메일 수 반환
    //AJson: json array 형식임 = [{},{}]
    function ShowNMoveEmailListFromJsonAry(AJson: RawUTF8): integer;
    procedure AddDroppedEmail2GridFromVariant(ADynAry: TRawUTF8DynArray);
    //Mail Grid의 HullNo, ClaimNo, ProjectNo 가 공란이면 FOLEmailSrchRec 값으로 채움
    //DB에 저장하기 전에 꼭 필요함 - Email을 DB에서  Load할때 FOLEmailSrchRec 값으로 Select 하기 때문임
    procedure UpdateHullNo2GridIfCellEmpty();

    procedure SetLogProc(ALogProc: TLogProc);

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
//    function SetDBKey4Email(ADBKey: string): Boolean;

    procedure SaveEmailFromGrid2DB;
    //RowID를 기준으로 삭제함
    procedure DeleteEmialFromGrid2DB;
    procedure InitEmailClient(AEmailDBName: string='');
    function GetSenderEmailListFromGrid(AContainData4Mails: TContainData4Mails): string;
    procedure AdjustEnumData2Grid(AGrid: TNextGrid);
    function ShowEmailListFromDBKey(AGrid: TNextGrid; ADBKey: TID): integer;
    procedure ShowEmailListFromSrchRec();
    procedure UpdateRawID4GridFromAddDBResult(AList: TStringList);

    procedure FillInMoveFolderCB;
    procedure SetMoveFolderCBByFolderPath(AFolderPath: string='');

    //Frame이 생성되고 바로 외부에서 호출함
    procedure SetOLEmailSrchRec(ARec: TOLEmailSrchRec);

    property MailCount: integer read FCurrentMailCount write SetMailCount;
  end;

function ShowEmailListFromJson(AGrid: TNextGrid; AJson: RawUTF8): integer;

implementation
uses
  ShellApi, mormot.core.mustache, UnitStringUtil, //UnitIPCModule2,
  DragDropInternet, //UnitHttpModule4InqManageServer2,
  MapiUtil,
  MapiTags,
  ComObj,
  //UnitGAMakeReport,
  UnitBase64Util2, UnitMustacheUtil2, StrUtils, UnitJHPFileData, //UnitMakeReport2,
  UnitNextGridUtil2, UnitOutlookUtil2, FrmStringsEdit;

{$R *.dfm}

type
  TMAPIINIT_0 =
    record
      Version: ULONG;
      Flags: ULONG;
    end;

  PMAPIINIT_0 = ^TMAPIINIT_0;
  TMAPIINIT = TMAPIINIT_0;
  PMAPIINIT = ^TMAPIINIT;

const
  MAPI_INIT_VERSION = 0;
  MAPI_MULTITHREAD_NOTIFICATIONS = $00000001;
  MAPI_NO_COINIT = $00000008;

var
  MapiInit: TMAPIINIT_0 = (Version: MAPI_INIT_VERSION; Flags: 0); //https://docs.microsoft.com/de-de/office/client-developer/outlook/mapi/mapiinit_0

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

procedure TOutlookEmailListFr.AddDroppedEmail2GridFromVariant(
  ADynAry: TRawUTF8DynArray);
var
  i,j, LRow, LRow2: integer;
  LDoc: variant;
  LColName, LFolderPath, LEntryId: string;
begin
  for j := Low(ADynAry) to High(ADynAry) do
  begin
    LDoc := _JSON(ADynAry[j]);

    for i := 0 to TDocVariantData(LDoc).Count - 1 do
    begin
      LColName := TDocVariantData(LDoc).Names[i];

      if LColName = 'SavedOLFolderPath' then
      begin
        LFolderPath := TDocVariantData(LDoc).Values[i];
      end;

      if LColName = 'LocalEntryId' then
      begin
        LEntryId := TDocVariantData(LDoc).Values[i];
      end;
    end;//for

    LRow := GetRowIndexFromFindNext(grid_Mail, LEntryId, -1, LRow2, false, 'LocalEntryId');

    //동일한 EntryId가 Grid에 존재하면
    if LRow <> -1 then
    begin
      if MessageDlg('EntryId가 같은 Mail이 존재합니다. RowNo = [' + IntToStr(LRow) + ']' +
        #13#10 + 'Overwrite 를 원하면 Yes를 눌러 주세요.' , mtConfirmation, [mbYes, mbNo],0) = mrYes then
      begin
        AddNextGridRowFromVariant(grid_Mail, LDoc, True, LRow);
      end;
    end
    else
      AddNextGridRowFromVariant(grid_Mail, LDoc, True);
  end;//for
end;

function TOutlookEmailListFr.AddEmail2GridNList(ADBKey, AJson: string; AList: TStringList; AFromRemote: Boolean): Boolean;
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

procedure TOutlookEmailListFr.AddFolderListFromOL(AFolder: string);
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

procedure TOutlookEmailListFr.AdjustEnumData2Grid(AGrid: TNextGrid);
var
  i, LRow: integer;
begin
  for LRow := 0 to AGrid.RowCount - 1 do
  begin
    i := StrToIntDef(AGrid.CellsByName['ProcDirection', LRow],-1);

    if i <> -1 then
//      AGrid.CellsByName['ProcDirection', LRow] := g_ProcessDirection.ToString(i);

    i := StrToIntDef(AGrid.CellsByName['ContainData', LRow],-1);

    if i <> -1 then
//      AGrid.CellsByName['ContainData', LRow] := g_ContainData4Mail.ToString(i);
  end;
end;

procedure TOutlookEmailListFr.AeroButton1Click(Sender: TObject);
begin
  SaveEmailFromGrid2DB();
end;

constructor TOutlookEmailListFr.Create(AOwner: TComponent);
begin
  FMainFormHandle := TWinControl(AOwner).Handle;

  InitVar();

  FEmailDBName := '';
//  DOC_DIR := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName) + 'Doc');
//  FContext4OLEmail := TContext4OLEmail.Create;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  FFolderListFromOL := TStringList.Create;
  FTempEmailMsgFileListFromRemote := TStringList.Create;
  FRemoteIPAddress := '';
//  FpjhSTOMPClass := nil;
  FIsSaveEmail2DBWhenDropped := False;
//  FWorker4OLMsg2MQ := TWorker4OLMsg2MQ.Create(FOLMsg2MQ);

//  if FOLFolderListFileName = '' then
//    FOLFolderListFileName := '.\'+OLFOLDER_LIST_FILE_NAME;

  if FileExists(FOLFolderListFileName) then
    FFolderListFromOL.LoadFromFile(FOLFolderListFileName);

//  MoveFolderCBDropDown(nil);

//  if FMQInfoRec.FIsEnableMQ then
//  begin
//{$IFDEF USE_OMNITHREAD}
//    FOLMsg2MQ := TOmniMessageQueue.Create(100);
//{$ENDIF}
//    InitSTOMP(FMQInfoRec.FUserId,FMQInfoRec.FPasswd,FMQInfoRec.FIPAddr,
//      FMQInfoRec.FPortNo,FMQInfoRec.FTopic);
//  end;

  inherited;
end;

procedure TOutlookEmailListFr.DeleteEmialFromGrid2DB;
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

procedure TOutlookEmailListFr.DeleteMail(ARow: integer);
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

procedure TOutlookEmailListFr.DeleteMail1Click(Sender: TObject);
begin
  DeleteMail(grid_Mail.SelectedRow);
end;

procedure TOutlookEmailListFr.DescriptionButtonClick(Sender: TObject);
var
  LStr: string;
begin
  LStr := grid_Mail.CellsByName['Description', grid_Mail.SelectedRow];
  TpjhStringsEditorDlg.Execute(LStr);
//  grid_Mail.CellsByName['Description', grid_Mail.SelectedRow] := LStr;
  TNxButtonColumn(grid_Mail.ColumnByName['Description']).Editor.Text := LStr;
end;

destructor TOutlookEmailListFr.Destroy;
begin
  FFolderListFromOL.Free;
  FTempEmailMsgFileListFromRemote.Free;
//  FContext4OLEmail.Free;
//  DestroyOLEmailMsg;

//  if Assigned(FpjhSTOMPClass) then
//    FpjhSTOMPClass.DisConnectStomp;
//  if Assigned(FWorker4OLMsg2MQ) then
//  begin
//    FWorker4OLMsg2MQ.Terminate;
//    FWorker4OLMsg2MQ.Stop;
//  end;

//{$IFDEF USE_OMNITHREAD}
//  if Assigned(FOLMsg2MQ) then
//    FreeAndNil(FOLMsg2MQ);
//{$ENDIF}
//
//  DestroySTOMP;

  DestroyVar();

  inherited;
end;

procedure TOutlookEmailListFr.DestroySTOMP;
begin
//  if Assigned(FpjhSTOMPClass) then
//    FreeAndNil(FpjhSTOMPClass);
end;

procedure TOutlookEmailListFr.DestroyVar;
begin
//  MAPIUninitialize;
  DeallocateHWnd(FMyWnd);

  FPJHTimerPool.RemoveAll();
  FPJHTimerPool.Free;

  StopWorker();
//  DestroyOLEmailMsg(); //UnitOLEmailRecord2.finalization에서 실행 함
end;

procedure TOutlookEmailListFr.DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
var
  OutlookDataFormat: TOutlookDataFormat;
  LIsMultiDrop: boolean;
  i, LDroppedCount: integer;
  LIds: TIDDynArray;
  LIsNewMailAdded: Boolean;
  LDroppedMailList, LNewAddedEmailList: TStringList;
  LOriginalEntryId, LOriginalStoreId,
  LJson, LNewStoreId, LNewStorePath: string;

  LMessage: IMessage;
  LMailItem: _MailItem;
begin
  // 윈도우 탐색기에서 Drag 했을 경우 LFileName에 Drag한 File Name이 존재함
  // OutLook에서 Drag한 경우에는 LFileName = '' 임
  if (DataFormatAdapterOutlook.DataFormat <> nil) then
  begin
    OutlookDataFormat := DataFormatAdapterOutlook.DataFormat as TOutlookDataFormat;
    LDroppedCount := OutlookDataFormat.Messages.Count; //Drop한 파일 갯수
    LIsMultiDrop := LDroppedCount > 1;

//    LDroppedMailList := TStringList.Create;
//    LNewAddedEmailList := TStringList.Create;
//    try
      // Get all the dropped messages
//      for i := 0 to LDroppedCount - 1 do
//      begin
        //Outlook 에서 선택된 메일 들을 OLControlWorker 에 요청함
        //위 요청에 대한 응답 함수에서(ProcessRespondFromWorker.olrkSelMail4Explore) Grid에 표시
        SendCmd2WorkerThrd(olckGetSelectedMailItemFromExplorer, TOmniValue.CastFrom(LDroppedCount));

        // Get an IMessage interface
//        if (Supports(OutlookDataFormat.Messages[i], IMessage, LMessage)) then
//        begin
//          try
//
//          finally
//
//          end;
//        end;

//        LJson := LDroppedMailList.Values['MailInfos'];
//ShowMessage('LJson :' + #13#10 + LJson);
        //Email List를 DB에 저장
//        if FIsSaveEmail2DBWhenDropped then
//          LIsNewMailAdded := AddOLMail2DBFromDroppedMail(FDBKey, FHullNo, LJson, LNewAddedEmailList)
//        else
//          LIsNewMailAdded := AddEmail2GridNList(FDBKey, LJson, LNewAddedEmailList);
//      end;//for

      //새 메일이 그리드에 추가 되었으면 Refresh
//      if LIsNewMailAdded then
//      begin
//        if (MoveFolderCB.ItemIndex > -1) and (AutoMoveCB.Checked) then
//        begin
//          LNewStoreId := FFolderListFromOL.ValueFromIndex[MoveFolderCB.ItemIndex];
//          LNewStorePath := FFolderListFromOL.Names[MoveFolderCB.ItemIndex];
//        end
//        else
//        begin
//          LNewStoreId := '';
//          LNewStorePath := '';
//        end;
//
//        if (LNewStoreId <> '') and (LNewStorePath <> '') then
//        begin
//          for i := 0 to LNewAddedEmailList.Count - 1 do
//          begin
//            LOriginalEntryId := LNewAddedEmailList.Names[i];
//            LOriginalStoreId := LNewAddedEmailList.ValueFromIndex[i];
//            MoveEmail2Folder(LOriginalEntryId, LOriginalStoreId, LNewStoreId, LNewStorePath, False);
//
////            if SendCmd2OL4MoveFolderEmail_WS(LOriginalEntryId, LOriginalStoreId,
////              LStoreId, LStorePath, LSubFolder, LHullNo, LDroppedMailList, FWSInfoRec) then
////            begin
////              UpdateOlMail2DBFromMovedMail(LDroppedMailList);
////            end;
//          end;
//
//          ShowMessage('Email move to folder( ' + LNewStorePath + ' ) completed!' + #13#10 +
//            '( ' + IntToStr(OutlookDataFormat.Messages.Count) + ' 건 )');
//        end;

//        SendOLEmail2MQ(LNewAddedEmailList);

//        if FIsSaveEmail2DBWhenDropped then
//          MailCount := ShowEmailListFromDBKey(grid_Mail, FDBKey);
//      end;
//    finally
//      LNewAddedEmailList.Free;
//      LDroppedMailList.Free;
//    end;
  end;
end;

procedure TOutlookEmailListFr.EditMailInfo1Click(Sender: TObject);
var
//  LEmailInfoF: TEmailInfoF;
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

//  LProcDirection := g_ProcessDirection.ToOrdinal(grid_Mail.CellsByName['ProcDirection', grid_Mail.SelectedRow]);
//  LContainData := g_ContainData4Mail.ToOrdinal(grid_Mail.CellsByName['ContainData', grid_Mail.SelectedRow]);
//
//  LEmailInfoF := TEmailInfoF.Create(nil);
//  try
//    //데이터가 있으면
////    if (LContainData <> -1) and (LProcDirection = -1) then
////    begin
//      LEmailInfoF.ContainDataCB.ItemIndex := LContainData;
//      LEmailInfoF.EmailDirectionCB.ItemIndex := LProcDirection;
////    end;
//
//    if LEmailInfoF.ShowModal = mrOK then
//    begin
//      LContainData2 := g_ContainData4Mail.ToString(LEmailInfoF.ContainDataCB.ItemIndex);
//      LProcDirection2 := g_ProcessDirection.ToString(LEmailInfoF.EmailDirectionCB.ItemIndex);
//
//      grid_Mail.CellsByName['ProcDirection', grid_Mail.SelectedRow] := LProcDirection2;
//      grid_Mail.CellsByName['ContainData', grid_Mail.SelectedRow] := LContainData2;
//
////      if LEmailID = -1 then
////        UpdateOLMail2DBFromContainDataNProcdir(LEmailID, LContainData2, LProcDirection2);
////
////      ShowEmailListFromDBKey(grid_Mail, FDBKey);
//    end;
//  finally
//    LEmailInfoF.Free;
//  end;

//    FTask.EmailMsg.ManyDelete(g_ProjectDB, FTask.ID, LEmailID);
//    g_ProjectDB.Delete(TSQLEmailMsg, LEmailID);
end;

procedure TOutlookEmailListFr.Englisth1Click(Sender: TObject);
begin
  ReqVDRAPTCoC(1);
end;

procedure TOutlookEmailListFr.FillFolderListFromRespRec(ARec: TOLRespondRec);
var
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Text := ARec.FMsg;
    FFolderListFromOL.Assign(LStrList);
    FillInMoveFolderCB();
    InitFolderListMenu();
  finally
    LStrList.Free;
  end;
end;

procedure TOutlookEmailListFr.FillInMoveFolderCB;
var
  i: integer;
begin
  MoveFolderCB.Clear;

  for i := 0 to FFolderListFromOL.Count - 1 do
    MoveFolderCB.Items.Add(FFolderListFromOL.Names[i]);
end;

procedure TOutlookEmailListFr.FinilizeFolderListMenu;
begin

end;

procedure TOutlookEmailListFr.FrameWndProc(var Message: Winapi.Messages.TMessage);
begin
  if Message.Msg = MSG_RESULT then
  begin
    OnWorkerResult(Message);
  end else
    Message.Result := DefWindowProc(FMyWnd, Message.Msg, Message.WParam, Message.LParam);
end;

function TOutlookEmailListFr.GetEmailIDFromGrid(ARow: integer): TID;
begin
  if ARow <> -1 then
  begin
    Result := grid_Mail.CellByName['RowID', ARow].AsInteger
  end
  else
    Result := -1;
end;

function TOutlookEmailListFr.GetEntryIdFromGridJson(
  ADoc: variant): TEntryIdRecord;
var
  i: integer;
  LColName: string;
begin
  Result := Default(TEntryIdRecord);

  for i := 0 to TDocVariantData(ADoc).Count - 1 do
  begin
    LColName := TDocVariantData(ADoc).Names[i];

    if LColName = 'LocalEntryId' then
      Result.FEntryId := TDocVariantData(ADoc).Values[i]
    else
    if LColName = 'LocalStoreId' then
      Result.FStoreId := TDocVariantData(ADoc).Values[i]
    else
    if LColName = 'SavedOLFolderPath' then
      Result.FFolderPath := TDocVariantData(ADoc).Values[i];
  end;
end;

function TOutlookEmailListFr.GetSenderEmailListFromGrid(
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

procedure TOutlookEmailListFr.grid_MailCellDblClick(Sender: TObject; ACol, ARow: Integer);
//var
//  LEntryID, LStoreID: string;
begin
  if ARow = -1 then
    exit;

//  LEntryID := grid_Mail.CellsByName['LocalEntryId', ARow];
//  LStoreID := grid_Mail.CellsByName['LocalStoreId', ARow];

  ShowMailContents(grid_Mail, ARow);

//  NextGridScrollToRow(grid_Mail);
end;

procedure TOutlookEmailListFr.InitEmailClient(AEmailDBName: string);
begin
  if AEmailDBName = '' then
    AEmailDBName := FEmailDBName;

  InitOLEmailMsgClient(AEmailDBName);
end;

procedure TOutlookEmailListFr.InitFolderListMenu;
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

procedure TOutlookEmailListFr.InitMAPI;
begin
  LoadMAPI;

  try
    // It appears that for for Win XP and later it is OK to let MAPI call
    // coInitialize.
    // V5.1 = WinXP.
//    if ((Win32MajorVersion shl 16) or Win32MinorVersion < $00050001) then
//      MapiInit.Flags := MapiInit.Flags or MAPI_NO_COINIT;

   {$IFDEF WIN64}
   MAPIInitialize don't works under Win64???
   {$ENDIF}
    OleCheck(MAPIInitialize(@MapiInit));
  except
    on E: System.SysUtils.Exception do
      ShowMessage(Format('Failed to initialize MAPI: %s', [E.Message]));
  end;
end;

procedure TOutlookEmailListFr.InitSTOMP(AUserId, APasswd, AServerIP, AServerPort,
  ATopic: string);
begin
//  if not Assigned(FpjhSTOMPClass) then
//  begin
//    FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(AUserId,
//                                            APasswd,
//                                            AServerIP,
//                                            AServerPort,
//                                            ATopic,
//                                            Self.Handle,False,False);
//  end;
end;

procedure TOutlookEmailListFr.InitVar;
begin
  FMyWnd := AllocateHWnd(FrameWndProc);

  FPJHTimerPool := TPJHTimerPool.Create(Self);
  FPJHTimerPool.AddOneShot(OnInitVarTimer,1000);
  FPJHTimerPool.AddOneShot(OnGetOLFolderListTimer,2000);

  InitEmailClient();
  StartWorker();
//  InitMAPI();
end;

//procedure TOutlookEmailListFr.Korean1Click(Sender: TObject);
//begin
//  ReqVDRAPTCoC(2);
//end;

class function TOutlookEmailListFr.MakeEMailHTMLBody<T>(AMailType: integer): string;
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

procedure TOutlookEmailListFr.MoveEmail2Folder(AOriginalEntryID, AOriginalStoreID,
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
      FEntryIdRecord := Default(TEntryIdRecord);

      SendCmd2WorkerThrd(olckMoveMail2Folder, TOmniValue.CastFrom(''));

//      if (AOriginalEntryID, AOriginalStoreID, ANewStoreId, ANewStorePath, LSubFolder, LHullNo, LMovedMailList) then
      begin
        UpdateOlMail2DBFromMovedMail(LMovedMailList, False);

        if AIsShowResult then
          ShowMessage('Email move to folder( ' + ANewStorePath + ' ) completed!');
      end;
    end;
  finally
    LMovedMailList.Free;
  end;
end;

procedure TOutlookEmailListFr.MoveEmailToFolderClick(Sender: TObject);
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

procedure TOutlookEmailListFr.MoveEmailToSelected1Click(Sender: TObject);
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

procedure TOutlookEmailListFr.OnGetOLFolderListTimer(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  SendCmd2WorkerThrd(olckGetFolderList, TOmniValue.CastFrom(''));
end;

procedure TOutlookEmailListFr.OnInitVarTimer(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  SendCmd2WorkerThrd(olckInitVar, TOmniValue.CastFrom(''));
end;

procedure TOutlookEmailListFr.OnWorkerResult(var Msg: Winapi.Messages.TMessage);
var
  LOLRespondRec: TOLRespondRec;
  LMsg  : TOmniMessage;
begin
  if FResponseQueue.TryDequeue(LMsg) then
  begin
    LOLRespondRec := LMsg.MsgData.ToRecord<TOLRespondRec>;

    ProcessRespondFromWorker(LMsg.MsgID, LOLRespondRec);
  end;
end;

procedure TOutlookEmailListFr.ProcessRespondFromWorker(AMsgId: integer;
  ARec: TOLRespondRec);
var
  LValue: TOmniValue;
  LUtf8: RawUTF8;
begin
  case TOLRespondKind(AMsgId) of
    olrkMAPIFolderList: begin
      FillFolderListFromRespRec(ARec);
      //FolderList가 ComboBox에 채워지면 Grid의 FolderPath를 참조하여 ComboBox ItmeIndex 조정함
      SetMoveFolderCBByFolderPath();
      FLogProc(ARec.FMsg);
    end;
    olrkLog: FLogProc(ARec.FMsg);
    //Outlook 에서 DragDrop 되었을때 현재 Outlook에서 Select된 Mail 정보를 Json Array로 가져옴
    olrkSelMail4Explore: begin
      LUtf8 := StringToUtf8(ARec.FMsg);
      ShowNMoveEmailListFromJsonAry(LUtf8);
//      ShowEmailListFromJson(grid_Mail, LUtf8);
      FLogProc(ARec.FMsg);
    end;
    //Email Move 후(Mail Drop시) 응답(New EntryId와 StoreId가 Json으로 반환됨)
    olrkMoveMail2Folder: begin
      //grid_Maai의 New EntryId 및 StoreId를 갱신함
      UpdateEmailId2GridFromJson(ARec.FMsg);
      //HullNo Update
      UpdateHullNo2GridIfCellEmpty();
    end;
  end;
end;

//ADynAry: Grid에 Drag Drop 되어 OL에서 Selected된 Email List를 Json Array로 전달
procedure TOutlookEmailListFr.ReqMoveEmailFolder2Worker(
  ADynAry: TRawUTF8DynArray);
var
  i, LFolderIdx: integer;
  LDoc: variant;
  LOmniValue: TOmniValue;
  LDestFolder: string;
//  LUtf8: RawUtf8;
begin
  LFolderIdx := MoveFolderCB.ItemIndex;

  if LFolderIdx < 0 then
    exit;

  for i := Low(ADynAry) to High(ADynAry) do
  begin
    LDoc := _JSON(ADynAry[i]);
//    LUtf8 := LDoc;

    //Move Folder를 위한 정보 가져옴(Mail.EntryID, Mail.StoreID, FFolderPath)
    FEntryIdRecord := GetEntryIdFromGridJson(LDoc);

    //이동할 폴더 명 :
//    LDestFolder := MoveFolderCB.Text + ';' + SubFolderNameEdit.Text;

    //이동할 Root Folder EntryId + ';' + Folder StoreId로 저장됨
    LDestFolder := FFolderListFromOL.ValueFromIndex[MoveFolderCB.ItemIndex];

    FEntryIdRecord.FEntryId4MoveRoot := StrToken(LDestFolder, ';');
    FEntryIdRecord.FStoreId4MoveRoot := StrToken(LDestFolder, ';');

    //이동할 Folder Path를 저장: RootFolder + ';' + SubFolder
    LDestFolder := FFolderListFromOL.Names[MoveFolderCB.ItemIndex] + ';' + SubFolderNameEdit.Text;;
    FEntryIdRecord.FFolderPath4Move := LDestFolder;

    LOmniValue := TOmniValue.FromRecord(FEntryIdRecord);
    //LDoc : {grid_Mail Column Name, vaule} 의 Json 형식임
    SendCmd2WorkerThrd(olckMoveMail2Folder, LOmniValue);
  end;//for
end;

procedure TOutlookEmailListFr.ReqVDRAPTCoC(ALang: integer);
var
  LEntryId, LStoreId, LHTMLBody, LAttachment: string;
  LCmdList: TStringList;
  LFileContents: RawUTF8;
  LRaw: RawByteString;
//  LOLEmailActionRec: TOLEmailActionRecord;
begin
  LEntryId := grid_Mail.CellByName['LocalEntryId', grid_Mail.SelectedRow].AsString;
  LStoreId := grid_Mail.CellByName['LocalStoreId', grid_Mail.SelectedRow].AsString;

//  LOLEmailActionRec.FEmailAction := ACTION_MakeEmailHTMLBody;
//  LOLEmailActionRec.FMailKind := MAILKIND_VDRAPT_REPLY_WITHNOMAKEZIP;
//
//  if ALang = 1 then
//    LOLEmailActionRec.FTemplateFileName := DOC_DIR + VDR_APT_COC_ENG_SEND_MUSTACHE_FILE_NAME
//  else
//  if ALang = 2 then
//    LOLEmailActionRec.FTemplateFileName := DOC_DIR + VDR_APT_COC_KOR_SEND_MUSTACHE_FILE_NAME;
//
//  LHTMLBody := FContext4OLEmail.Algorithm4EmailAction(LOLEmailActionRec);
//
//  LCmdList := GetCmdList4ReplyMail(LEntryId, LStoreId, LHTMLBody);
//  try
//    LOLEmailActionRec.FEmailAction := ACTION_MakeAttachFile;
//    LOLEmailActionRec.FMailKind := MAILKIND_VDRAPT_REPLY_IFZIPEXIST;
//    LOLEmailActionRec.FFileKind := g_JHPFileFormat.ToOrdinal(gfkWORD);
//    LAttachment := FContext4OLEmail.Algorithm4EmailAction(LOLEmailActionRec);
//
//    if FileExists(LAttachment) then
//    begin
//      LRaw := StringFromFile(LAttachment);
//      LFileContents := MakeRawUTF8ToBin64(LRaw);
//
//      LCmdList.Add('AttachedFileName='+ExtractFileName(LAttachment));
//      LCmdList.Add('MakeBase64ToString='+'True');
//      LCmdList.Add('FileContent='+UTF8ToString(LFileContents));
//    end;
//
//    LCmdList.Add('To=REPLYALL');
//
//{$IFDEF USE_MORMOT_WS}
//    SendCmd2OL4ReplyMail_WS(LCmdList, FWSInfoRec);
//{$ELSE}
//  {$IFDEF USE_CROMIS_IPC}
////    SendCmd2OL4ReplyMail_WS(LCmdList, FWSInfoRec);
//  {$ENDIF}
//{$ENDIF}
//  finally
//    LCmdList.Free;
//  end;
end;

procedure TOutlookEmailListFr.SaveEmailFromGrid2DB;
var
  LDoc: variant;
  LJsonArray: string;
  LStrList: TStringList;
begin
  if grid_Mail.RowCount = 0 then
    exit;

  LStrList := TStringList.Create;
  try
    //Grid의 RowID를 기준으로 삭제함
    DeleteEmialFromGrid2DB;
    LDoc := NextGrid2Variant(grid_Mail);
    LJsonArray := LDoc;

    if AddOLMail2DBFromDroppedMail(LJsonArray, LStrList) then
    begin
      //RowID는 DB에 저장한 이후에 알수 있으므로 DB 저장 완료 후 Grid의 RowID를 Update 해야 함
      //LStrList: LocalEntryId=TID 형식으로 저장됨
      //Mail 추가 후 grid 창을 Close하지 않은 상태(DB에서 자료를 새로 읽어오지 않은 상태)에서 Mail Delete 할떄 RowID 가 필요함
      UpdateRawID4GridFromAddDBResult(LStrList);
      ShowMessage('Email in the grid is saved to DB');
    end;
  finally
    LStrList.Free;
  end;
end;

procedure TOutlookEmailListFr.Send2MQCheckClick(Sender: TObject);
begin
  Send2MQCheck.Checked := not Send2MQCheck.Checked;
end;

procedure TOutlookEmailListFr.SendCmd2WorkerThrd(const ACmd: TOLCommandKind;
  const AValue: TOmniValue);
begin
  if not FCommandQueue.Enqueue(TOmniMessage.Create(Ord(ACmd), AValue)) then
    raise System.SysUtils.Exception.Create('Command queue is full!');
end;

procedure TOutlookEmailListFr.SendOLEmail2MQ(AEntryIdList: TStrings);
var
{$IFDEF USE_OMNITHREAD}
  LOmniValue: TOmniValue;
{$ENDIF}
//  LRec: TOLMsgFile4STOMP;
  LRaw: RawByteString;
  LMsgFileName: string;
  LUtf8: RawUTF8;
begin
//  if not FMQInfoRec.FIsEnableMQ then
//    exit;
//
//  LRaw := StringFromFile(LMsgFileName);
//  LRaw := SynLZCompress(LRaw);
//  LUtf8 := BinToBase64(LRaw);
//  LRec.FMsgFile := UTF8ToString(LUtf8);
//  LRec.FHost := FMQInfoRec.FIPAddr;
//  LRec.FUserId := FMQInfoRec.FUserId;
//  LRec.FPasswd := FMQInfoRec.FPasswd;
//  LRec.FTopic := FMQInfoRec.FTopic;
////  LOmniValue := TOmniValue.FromRecord<TOLMsgFile4STOMP>(LRec);
////  FOLMsg2MQ.Enqueue(TOmniMessage.Create(1, LOmniValue));
//
//  FpjhSTOMPClass.StompSendMsgThread(LRec.FMsgFile, LRec.FTopic);
end;

//function TOutlookEmailListFr.SetDBKey4Email(ADBKey: string): Boolean;
//begin
//  if ADBKey = '' then
//    exit;
//
//  Result := FDBKey <> ADBKey;
//
//  if Result then
//    FDBKey := ADBKey;
//end;

function TOutlookEmailListFr.SetDBName4Email(ADBName: string) : Boolean;
begin
  if ADBName = '' then
    exit;

  Result := FEmailDBName <> ADBName;

  if Result then
    FEmailDBName := ADBName;
end;

procedure TOutlookEmailListFr.SetEmbededMode;
begin
  panMailButtons.Visible := False;
end;

procedure TOutlookEmailListFr.SetLogProc(ALogProc: TLogProc);
begin
  FLogProc := ALogProc;
end;

procedure TOutlookEmailListFr.SetMailCount(ACount: integer);
begin
  if FCurrentMailCount <> ACount then
  begin
    FCurrentMailCount := ACount;
    StatusBar.Panels[1].Text := IntToStr(ACount);
  end;
end;

procedure TOutlookEmailListFr.SetMoveFolderCBByFolderPath(AFolderPath: string);
var
  i,j,k: integer;
begin
  if AFolderPath = '' then
  begin
    for i := 0 to grid_Mail.RowCount - 1 do
    begin
      AFolderPath := grid_Mail.CellsByName['SavedOLFolderPath', grid_Mail.RowCount-1];
      AFolderPath := GetFolderNameOfNthLevel(AFolderPath, 2);

      for j := 0 to MoveFolderCB.Items.Count - 1 do
      begin
//        k := Pos(MoveFolderCB.Items.Strings[j], AFolderPath);
          k := MoveFolderCB.Items.IndexOf(AFolderPath);
//        if k > 0 then

        if k > -1  then
        begin
          MoveFolderCB.ItemIndex := k;
          Exit;
        end;
      end;//for
    end;//for
  end;
end;

procedure TOutlookEmailListFr.SetMoveFolderIndex;
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

procedure TOutlookEmailListFr.SetMQInfoRec4OL(AIPAddr, APortNo, AUserId, APasswd,
  ATopic: string; AIsMQEnable: Boolean);
begin
//  SetMQInfoRec(AIPAddr, APortNo, AUserId, APasswd,ATopic,AIsMQEnable,FMQInfoRec);
//  FMQInfoRec.FIPAddr := AIPAddr;
//  FMQInfoRec.FPortNo := APortNo;
//  FMQInfoRec.FUserId := AUserId;
//  FMQInfoRec.FPasswd := APasswd;
//  FMQInfoRec.FTopic := ATopic;
//  FMQInfoRec.FIsEnableMQ := AIsMQEnable;

  Send2MQCheck.Checked := AIsMQEnable;
  Send2MQCheck.Enabled := AIsMQEnable;
end;

procedure TOutlookEmailListFr.SetNamedPipeInfoRec4OL(AComputerName, AServerName: string; AIsNPEnable: Boolean);
begin
//  SetNamedPipeInfoRec(AComputerName, AServerName,AIsNPEnable,FWSInfoRec);
//  FWSInfoRec.FComputerName := AComputerName;
//  FWSInfoRec.FServerName := AServerName;
//  FWSInfoRec.FNamedPipeEnabled := AIsNPEnable;
end;

procedure TOutlookEmailListFr.SetOLEmailSrchRec(ARec: TOLEmailSrchRec);
begin
  FOLEmailSrchRec := ARec;
end;

procedure TOutlookEmailListFr.SetWSInfoRec4OL(AIPAddr, APortNo, ATransKey: string; AIsWSEnable: Boolean);
begin
//  SetWSInfoRec(AIPAddr, APortNo, ATransKey,AIsWSEnable,FWSInfoRec);
//  FWSInfoRec.FIPAddr := AIPAddr;
//  FWSInfoRec.FPortNo := APortNo;
//  FWSInfoRec.FTransKey := ATransKey;
//  FWSInfoRec.FIsWSEnabled := AIsWSEnable;
end;

procedure TOutlookEmailListFr.ShowMailContents(AGrid: TNextGrid; ARow: integer);
var
  LEntryIdRecord: TEntryIdRecord;
  LValue: TOmniValue;
begin
  LEntryIdRecord.FEntryId := AGrid.CellsByName['LocalEntryId', ARow];
  LEntryIdRecord.FStoreId := AGrid.CellsByName['LocalStoreId', ARow];
//  LEntryIdRecord.FFolderPath := AGrid.CellsByName['SavedOLFolderPath', ARow];

  LValue := TOmniValue.FromRecord(LEntryIdRecord);

  SendCmd2WorkerThrd(olckShowMailContents, LValue);
end;

function TOutlookEmailListFr.ShowNMoveEmailListFromJsonAry(
  AJson: RawUTF8): integer;
var
  LVar: variant;
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LDestFolder: string;
begin
  //AJson = [] 형식의 Email List임
//  LVar := _JSON(AJson);

  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LDynArr.LoadFromJSON(PUTF8Char(AJson));

  //OL으로부터 전달 받은 Selected Email List를 Grid에 표시: Move 전 EnttryID 표시됨
  AddDroppedEmail2GridFromVariant(LDynUtf8);
//  AddNextGridRowsFromVariant(grid_Mail, LDynUtf8, False);

  if AutoMoveCB.Checked then
    ReqMoveEmailFolder2Worker(LDynUtf8)//Move 완료 후 수정된 EntryId를 Grid에 갱신해야 함
  else
  begin
    UpdateHullNo2GridIfCellEmpty();
  end;
//  Result := GetListFromVariant2NextGrid(grid_Mail, LVar, True, True);
end;

function TOutlookEmailListFr.ShowEmailListFromDBKey(AGrid: TNextGrid;
  ADBKey: TID): integer;
var
  LSQLEmailMsg: TSQLOLEmailMsg;
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

procedure TOutlookEmailListFr.ShowEmailListFromSrchRec;
var
  LUtf8: RawUtf8;
  LVar: variant;
begin
  LUtf8 := GetEmailList2JSONArrayFromSearchRec(FOLEmailSrchRec);
  LVar := _JSON(LUtf8);
  //Grid Column Name을 확인하여 Json Name과 비교하면서 Grid Insert 함
  GetListFromVariant2NextGrid(grid_Mail, LVar, True, True, True, True);
//  AddNextGridRowsFromVariant2(OLEmailListFr.grid_Mail, LVar);
end;

procedure TOutlookEmailListFr.StartWorker;
begin
  FCommandQueue := TOmniMessageQueue.Create(1000);
  FResponseQueue := TOmniMessageQueue.Create(1000, false);
  FSendMsgQueue := TOmniMessageQueue.Create(1000);

  FOLControlWorker := TOLControlWorker.Create(FCommandQueue, FResponseQueue, FSendMsgQueue, FMyWnd);
end;

procedure TOutlookEmailListFr.StopWorker;
begin
  if Assigned(FOLControlWorker) then
  begin
    TWorker(FOLControlWorker).Stop;
    FOLControlWorker.WaitFor;
    FreeAndNil(FOLControlWorker);
  end;

  FCommandQueue.Free;
  FResponseQueue.Free;
  FSendMsgQueue.Free;
end;

procedure TOutlookEmailListFr.SubFolderCBClick(Sender: TObject);
begin
  if SubFolderCB.Checked then
    AutoMoveCB.Checked := True;

  SubFolderNameEdit.Enabled := SubFolderCB.Checked;
end;

procedure TOutlookEmailListFr.Timer1Timer(Sender: TObject);
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

procedure TOutlookEmailListFr.UpdateEmailId2GridFromJson(AJson: string);
var
  LDoc: IDocDict;
  LRow, LRow2: integer;
  LOldEntryId: string;
begin
  LDoc := DocDict(AJson);

  LOldEntryId := LDoc['OldEntryId'];

  LRow2 := 0;
  LRow := GetRowIndexFromFindNext(grid_Mail, LOldEntryId, -1, LRow2, false, 'LocalEntryId');

  if LRow <> -1 then
  begin
    LOldEntryId := LDoc['NewEntryId'];
    grid_Mail.CellsByName['LocalEntryId', LRow] := LOldEntryId;
    LOldEntryId := LDoc['NewStoreId'];
    grid_Mail.CellsByName['LocalStoreId', LRow] := LOldEntryId;
    grid_Mail.CellsByName['FolderEntryId', LRow] := LDoc['NewEntryId4Folder'];
    grid_Mail.CellsByName['SavedOLFolderPath', LRow] := LDoc['SavedOLFolderPath'];
  end;
end;

procedure TOutlookEmailListFr.UpdateHullNo2GridIfCellEmpty;
var
  i: integer;
begin
  grid_Mail.BeginUpdate;
  try
    for i := 0 to grid_Mail.RowCount - 1 do
    begin
      if grid_Mail.CellsByName['HullNo', i] = '' then
      begin
        grid_Mail.CellsByName['HullNo', i] := FOLEmailSrchRec.FHullNo;
        grid_Mail.CellsByName['ProjectNo', i] := FOLEmailSrchRec.FProjectNo;
        grid_Mail.CellsByName['ClaimNo', i] := FOLEmailSrchRec.FClaimNo;
      end;

      if grid_Mail.CellsByName['TaskID', i] = '' then
        grid_Mail.CellsByName['TaskID', i] := IntToStr(FOLEmailSrchRec.FTaskID);
    end;
  finally
    grid_Mail.EndUpdate();
  end;
end;

procedure TOutlookEmailListFr.UpdateRawID4GridFromAddDBResult(
  AList: TStringList);
var
  i, j: integer;
  LEntryId: string;
begin
  for i := 0 to AList.Count - 1 do
  begin
    LEntryId := AList.Names[i];

    for j := 0 to grid_Mail.RowCount - 1 do
    begin
      if grid_Mail.CellsByName['LocalEntryId',j] = LEntryId then
      begin
        grid_Mail.CellsByName['RowId', j] := AList.ValueFromIndex[i];
        Break;
      end;
    end;
  end;
end;

{ TMessage }

constructor TMessage.Create(const AMessage: IMessage; const AStorage: IStorage);
begin
  FMessage := AMessage;
  FStorage := AStorage;
  FAttachments := TInterfaceList.Create;
end;

destructor TMessage.Destroy;
begin
  FAttachments.Free;
  FMessage := nil;
  inherited Destroy;
end;

function TMessage.GetAttachments: TInterfaceList;
const
  AttachmentTags: packed record
    Values: ULONG;
    PropTags: array[0..0] of ULONG;
  end = (Values: 1; PropTags: (PR_ATTACH_NUM));

var
  Table: IMAPITable;
  Rows: PSRowSet;
  i: integer;
  Attachment: IAttach;
begin
  if (not FAttachmentsLoaded) then
  begin
    FAttachmentsLoaded := True;
    (*
    ** Get list of attachment interfaces from message
    **
    ** Note: This will only succeed the first time it is called for an IMessage.
    ** The reason is probably that it is illegal (according to MSDN) to call
    ** IMessage.OpenAttach more than once for a given attachment. However, it
    ** might also be a bug in my code, but, whatever the reason, the solution is
    ** beyond the scope of this demo.
    **
    ** Let me know if you find a solution.
    *)
    if (Succeeded(FMessage.GetAttachmentTable(0, Table))) then
    begin
      if (Succeeded(HrQueryAllRows(Table, PSPropTagArray(@AttachmentTags), nil, nil, 0, Rows))) then
        try
          for i := 0 to integer(Rows.cRows)-1 do
          begin
            // Get one attachment at a time
            if (Rows.aRow[i].lpProps[0].ulPropTag and PROP_TYPE_MASK <> PT_ERROR) and
              (Succeeded(FMessage.OpenAttach(Rows.aRow[i].lpProps[0].Value.l, IAttach, 0, Attachment))) then
              FAttachments.Add(Attachment);
          end;

        finally
          FreePRows(Rows);
        end;
      Table := nil;
    end;
  end;
  Result := FAttachments;
end;

procedure TMessage.SaveToStream(Stream: TStream);
const
  CLSID_MailMessage:TGUID='{00020D0B-0000-0000-C000-000000000046}';
var
  LockBytes: ILockBytes;
  Storage: IStorage;
(*
  Malloc: IMalloc;
  MsgSession: pointer;
  NewMsg: IUnknown;
  ExcludeTags: PSPropTagArray;
*)
//  ProblemArray: PSPropProblemArray;
  Memory: HGLOBAL;
  Buffer: pointer;
  Size: integer;
begin
  (*
  ** This implementation is based, in part, on the Microsoft knowledgebase
  ** article:
  ** Save Message to MSG Compound File
  ** http://support.microsoft.com/kb/171907
  *)
  Memory := GlobalAlloc(GMEM_MOVEABLE, 0);
  try

    OleCheck(CreateILockBytesOnHGlobal(Memory, True, LockBytes));
    try

      // Create compound file
      OleCheck(StgCreateDocfileOnILockBytes(LockBytes,
        STGM_TRANSACTED or STGM_READWRITE or STGM_CREATE, 0, Storage));
      try

        Storage.Commit(STGC_DEFAULT);
        FStorage.CopyTo(0, nil, nil, Storage);
        Storage.Commit(STGC_DEFAULT);
(*
        Malloc := IMalloc(MAPIGetDefaultMalloc);
        try

          // Open an IMessage session.
          OleCheck(OpenIMsgSession(Malloc, 0, MsgSession));
          try

            // Open an IMessage interface on an IStorage object
            OleCheck(OpenIMsgOnIStg(MsgSession,
              @MAPIAllocateBuffer, @MAPIAllocateMore, @MAPIFreeBuffer, Malloc,
              nil, Storage, nil, 0, 0, NewMsg));
            try

              // write the CLSID to the IStorage instance - pStorage. This will
              // only work with clients that support this compound document type
              // as the storage medium. If the client does not support
              // CLSID_MailMessage as the compound document, you will have to use
              // the CLSID that it does support.
              OleCheck(WriteClassStg(Storage, CLSID_MailMessage));

              GetMem(ExcludeTags, SizeOf(TSPropTagArray)+SizeOf(ULONG)*6);
              try

                // Exclude a few properties - just like the MSDN sample
                ExcludeTags.cValues := 7;
                ExcludeTags.aulPropTag[0] := PR_ACCESS;
                ExcludeTags.aulPropTag[ExcludeTags.cValues-6] := PR_BODY;
                ExcludeTags.aulPropTag[ExcludeTags.cValues-5] := PR_RTF_SYNC_BODY_COUNT;
                ExcludeTags.aulPropTag[ExcludeTags.cValues-4] := PR_RTF_SYNC_BODY_CRC;
                ExcludeTags.aulPropTag[ExcludeTags.cValues-3] := PR_RTF_SYNC_BODY_TAG;
                ExcludeTags.aulPropTag[ExcludeTags.cValues-2] := PR_RTF_SYNC_PREFIX_COUNT;
                ExcludeTags.aulPropTag[ExcludeTags.cValues-1] := PR_RTF_SYNC_TRAILING_COUNT;

                // Copy message properties
//                Msg.CopyTo(0, TGUID(nil^), ExcludeTags, 0, nil, IMessage, pointer(NewMsg), 0, ProblemArray);
                OleCheck(Msg.CopyTo(0, TGUID(nil^), ExcludeTags, 0, nil, IMessage, pointer(NewMsg), 0, PSPropProblemArray(nil^)));

              finally
                FreeMem(ExcludeTags);
              end;

              IMessage(NewMsg).SaveChanges(0);
              Storage.Commit(STGC_DEFAULT);

            finally
              pointer(NewMsg) := nil;
            end;

          finally
            CloseIMsgSession(MsgSession);
          end;

        finally
          Malloc := nil;
        end;
  *)
      finally
        Storage := nil;
      end;

      Size := GlobalSize(Memory);
      Buffer := Winapi.Windows.GlobalLock(Memory);
      try
        Stream.Write(Buffer^, Size);
      finally
        Winapi.Windows.GlobalUnlock(Memory);
      end;

    finally
      LockBytes := nil;
    end;

  finally
    GlobalFree(Memory);
  end;
end;

end.
