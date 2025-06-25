unit FrameOLEmailList4Ole;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.XPStyleActnCtrls, Vcl.ActnMan, Vcl.ComCtrls, Vcl.Buttons, PngBitBtn, Vcl.Menus,
  ActiveX, clipbrd,
  Vcl.StdCtrls, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ExtCtrls, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  AdvOfficeTabSet, System.Rtti, DateUtils, System.SyncObjs,
  DragDrop, DropTarget, TimerPool, MapiDefs, AeroButtons, Vcl.ImgList,
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
  DropSource, DragDropText, UnitOLDragDropRecord
//  UnitHiconisASData
  ;

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
    Incremental: TNxIncrementColumn;
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
    AeroButton1: TAeroButton;
    SenderEmail: TNxTextColumn;
    FolderEntryId: TNxTextColumn;
    ClaimNo: TNxTextColumn;
    ProjectNo: TNxTextColumn;
    Description: TNxButtonColumn;
    TaskID: TNxTextColumn;
    BitBtn2: TBitBtn;
    CopyHullNoClaimNoSubject1: TMenuItem;
    Save2JsonAryFromSelected1: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    MoveSelectedEmail2MoveFolder1: TMenuItem;
    GetUnReadMailList1: TMenuItem;
    UpdateClaimExist1: TMenuItem;
    ExistInDB: TNxCheckBoxColumn;
    FlagRequest: TNxTextColumn;
    ImageList16x16: TImageList;
    DropTextSource1: TDropTextSource;

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
    procedure BitBtn2Click(Sender: TObject);
    procedure CopyHullNoClaimNoSubject1Click(Sender: TObject);
    procedure Save2JsonAryFromSelected1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MoveSelectedEmail2MoveFolder1Click(Sender: TObject);
    procedure GetUnReadMailList1Click(Sender: TObject);
    procedure UpdateClaimExist1Click(Sender: TObject);
    procedure grid_MailMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FOLControlWorker: TOLControlWorker;
    FCommandQueue,
    FResponseQueue,
    FSendMsgQueue,
    FOLEmailQueue,

    FIPCMQFromEmail,
    FIPCMQ2Email
    : TOmniMessageQueue;

    FPJHTimerPool: TPJHTimerPool;

    FLogProc: TLogProc;
    FMainFormHandle,
    FFrameOLEmailListWnd: THandle;

    FEntryIdRecord: TEntryIdRecord;

    FCurrentMailCount: integer;
    FEmailDBName: string;
    FEmailDragSource: TOLEmail_DragSourceDataFormat;
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
      ANewStorePath: string; AIsShowResult: Boolean = True; ASubFolder: string='');
    //ADynArry: Move�� Email List��
    function ReqMoveEmailFolder2WorkerFromDynAry(ADynAry: TRawUTF8DynArray): integer;
    function ReqMoveEmailFolder2WorkerFromJsonAry(AJsonAry: RawUTF8; ACheckHullNoIsNull: Boolean=True): integer;
    function ReqMoveEmailFolder2WorkerFromJson(AJson: RawUTF8; ACheckHullNoIsNull: Boolean=True): integer;
    function GetEntryIdFromGridJson(ADoc: variant): TEntryIdRecord;
    function ReqGotoFolder2Worker(): integer;

    procedure DeleteMail(ARow: integer);

    function GetEmailIDFromGrid(ARow: integer): string;
    procedure ShowMailContents(AGrid: TNextGrid; ARow: integer);
    procedure SendOLEmail2MQ(AEntryIdList: TStrings);
    procedure UpdateEmailId2GridFromJson(AJson: string);

    procedure AddFolderListFromOL(AFolder: string);
    procedure SetMoveFolderIndex;
    function AddEmail2GridNList(ADBKey, AJson: string; AList: TStringList; AFromRemote: Boolean=False): Boolean;

    procedure MoveOLEmailData2DragSrcRecFromGrid(const ARow: integer; var ARec: TOLEmail_DragSourceRec);

    class function MakeEMailHTMLBody<T>(AMailType: integer): string;

    procedure InitSTOMP(AUserId, APasswd, AServerIP, AServerPort, ATopic: string);
    procedure DestroySTOMP;

    procedure InitMAPI();
  public
    //������ �̵���ų Outlook ���� ����Ʈ,
    //HGS Task/Send Folder Name 2 IPC �޴��� ���� OL���� ���� ������
    FFolderListFromOL,
    //Remote Mode���� ���� ��ȸ�ÿ� temp ������ GUID.msg ���Ϸ� ����Ǹ�
    //â�� ���� �� �� ���ϵ��� �����ϱ� ����
    FTempEmailMsgFileListFromRemote: TStringList;
    FRemoteIPAddress: string;
    FHullNo, FDBNameSuffix: string;
    FDBKey: TID; //TaskID�� �����
    FOLFolderListFileName,
    FDefaultMoveFolder: string;
    //Strategy Design Pattern
//    FContext4OLEmail: TContext4OLEmail;
//    FWSInfoRec: TWSInfoRec;
//    FMQInfoRec: TMQInfoRec;
    FIsSaveEmail2DBWhenDropped: Boolean;
    //Frame�� Hullno, ClaimNo, ProjectNo�� �����ϱ� ���� ����
    FOLEmailSrchRec: TOLEmailSrchRec;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitVarFromOwner(ARec: TOLEmailSrchRec); //�� Frame�� �����ϴ� Owner�� ȯ�� ���� ���� �� �����ϴ� �Լ�

    //    constructor Create(AOwner: TComponent); override;
//    constructor CreateWithOLFolderList(AFolderListFileName, AProdCode: string);

    procedure SendCmd2WorkerThrd(const ACmd: TOLCommandKind; const AValue: TOmniValue);

    //Result: Drag�� ������ ���� �� ��ȯ
    //AJson: json array ������ = [{},{}]
    function ShowNMoveEmailListFromJsonAry(AJson: RawUTF8): integer;
    procedure AddDroppedEmail2GridFromDynAry(ADynAry: TRawUTF8DynArray);
    procedure AddEmail2GridFromJsonAry(AJsonAry: RawUTF8);
    //Mail Grid�� HullNo, ClaimNo, ProjectNo �� �����̸� FOLEmailSrchRec ������ ä��
    //DB�� �����ϱ� ���� �� �ʿ��� - Email�� DB����  Load�Ҷ� FOLEmailSrchRec ������ Select �ϱ� ������
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

    //Frame�� �������� ���������� ������ Close Button�� Hide �Ǿ�� ��
    procedure SetEmbededMode;
    function SetDBName4Email(ADBName: string): Boolean;
//    function SetDBKey4Email(ADBKey: string): Boolean;

    procedure SaveEmailFromGrid2DB(const AOnlySelected: Boolean=False);
    //Grid�� EntryID�� �������� DB�� ������
    procedure DeleteEmialFromGrid2DB(const AOnlySelected: Boolean=False);
    procedure InitEmailClient(AEmailDBName: string='');
    function GetSenderEmailListFromGrid(AContainData4Mails: TContainData4Mails): string;
    procedure AdjustEnumData2Grid(AGrid: TNextGrid);
    function ShowEmailListFromDBKey(AGrid: TNextGrid; ADBKey: TID): integer;
    procedure ShowEmailListFromSrchRec();
    procedure UpdateRawID4GridFromAddDBResult(AList: TStringList);

    procedure FillInMoveFolderCB;
    procedure SetMoveFolderCBByFolderPath(AFolderPath: string='');

    //Frame�� �����ǰ� �ٷ� �ܺο��� ȣ����
    procedure SetOLEmailSrchRec(ARec: TOLEmailSrchRec);

    function GetJsonAryFromSelectedEmail(): RawUtf8;
    //AJsonAry�� grid_Mail�� ������(Idx = No ���� Ȱ��)
    procedure UpdateHullNoNClaimNo2GridByJsonAry(AJsonAry: string);
    procedure UpdateExistDB2GridByJsonAry(AJsonAry: string);
    procedure AddHullNoNClaimNo2GridByJsonAry(AJsonAry: string);
    function MoveEmailList2MoveFolderByClaimNoFromSelected(): integer;

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
  UnitNextGridUtil2, UnitOutlookUtil2, FrmStringsEdit, FrmEditEmailInfo2,
  UnitComboBoxUtil, ArrayHelper;

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
    //AJson = [] ������ Email List��
    LVar := _JSON(AJson);
    Result := GetListFromVariant2NextGrid(AGrid, LVar, True, True);
//    //AJson = [] ������ Email List��
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

procedure TOutlookEmailListFr.AddEmail2GridFromJsonAry(
  AJsonAry: RawUTF8);
var
  LRow, LRow2: integer;
  LColName, LFolderPath, LEntryId: string;
  LDoc: variant;
  LDocList: IDocList;
  LDocDict: IDocDict;
  LDocField: TDocDictFields;
begin
  LDocList := DocList(AJsonAry);

  for LDocDict in LDocList.Objects do
  begin
//    for LDocField in LDocDict do
//    begin
//      LColName := LDocField.Key;
//
//      if LColName = 'SavedOLFolderPath' then
//      begin
//        LFolderPath := LDocField.Value;
//      end
//      else if LColName = 'LocalEntryId' then
//      begin
//        LEntryId := LDocField.Value;
//      end;
//    end;//for

    LEntryId := LDocDict.S['LocalEntryId'];
    LFolderPath := LDocDict.S['SavedOLFolderPath'];

    LRow := GetRowIndexFromFindNext(grid_Mail, LEntryId, -1, LRow2, false, 'LocalEntryId');
    LDoc := LDocDict.AsVariant;

    //������ EntryId�� Grid�� �����ϸ�
    if LRow <> -1 then
    begin
      if MessageDlg('EntryId�� ���� Mail�� �����մϴ�. RowNo = [' + IntToStr(LRow) + ']' +
        #13#10 + 'Overwrite �� ���ϸ� Yes�� ���� �ּ���.' , mtConfirmation, [mbYes, mbNo],0) = mrYes then
      begin
        AddNextGridRowFromVariant(grid_Mail, LDoc, True, LRow);
      end;
    end
    else
      AddNextGridRowFromVariant(grid_Mail, LDoc, True);
  end;//for
end;

procedure TOutlookEmailListFr.AddDroppedEmail2GridFromDynAry(
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

    //������ EntryId�� Grid�� �����ϸ�
    if LRow <> -1 then
    begin
      if MessageDlg('EntryId�� ���� Mail�� �����մϴ�. RowNo = [' + IntToStr(LRow) + ']' +
        #13#10 + 'Overwrite �� ���ϸ� Yes�� ���� �ּ���.' , mtConfirmation, [mbYes, mbNo],0) = mrYes then
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
        //DB�� ������ �����Ͱ� ������ email�� Grid�� �߰�
        if not LEmailMsg.FillOne then
        begin
          GetListFromVariant2NextGrid(grid_Mail, LVarArr[i], True, False, True);
          //"jhpark@hyundai-gs.com\VDR\" �������� ���� ��
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

procedure TOutlookEmailListFr.AddHullNoNClaimNo2GridByJsonAry(AJsonAry: string);
var
  LIdx, LRow: integer;
  LDocList: IDocList;
  LDocDict: IDocDict;
begin
  LDocList := DocList(StringToUtf8(AJsonAry));

  for LDocDict in LDocList do
  begin
    LIdx := LDocDict.I['Idx'];

    if (LIdx <= 0) then
    begin
      LRow := grid_Mail.AddRow();

      grid_Mail.CellsByName['HullNo', LRow] := LDocDict.S['HullNo'];
      grid_Mail.CellsByName['ClaimNo', LRow] := LDocDict.S['ClaimNo'];
      grid_Mail.CellsByName['Subject', LRow] := LDocDict.S['Subject'];
//      grid_Mail.CellsByName['Description', LIdx] := LDocDict.S['Description'];
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
    ShowMessage('������ Folder �̸��� ������ : ' + AFolder);
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

procedure TOutlookEmailListFr.BitBtn2Click(Sender: TObject);
begin
  ReqGotoFolder2Worker();
end;

procedure TOutlookEmailListFr.Button1Click(Sender: TObject);
var
  LStr: string;
begin
  if TpjhStringsEditorDlg.Execute(LStr) then
  begin
    UpdateHullNoNClaimNo2GridByJsonAry(LStr);
  end;
end;

procedure TOutlookEmailListFr.Button2Click(Sender: TObject);
var
  LStr: string;
begin
  if TpjhStringsEditorDlg.Execute(LStr) then
  begin
    AddHullNoNClaimNo2GridByJsonAry(LStr);
  end;
end;

procedure TOutlookEmailListFr.CopyHullNoClaimNoSubject1Click(Sender: TObject);
begin
  Clipboard.AsText := grid_Mail.CellsByName['HullNo', grid_Mail.SelectedRow] + '-' +
    grid_Mail.CellsByName['ClaimNo', grid_Mail.SelectedRow] + ' : ' +
    grid_Mail.CellsByName['Subject', grid_Mail.SelectedRow]
end;

constructor TOutlookEmailListFr.Create(AOwner: TComponent);
begin
  FMainFormHandle := TWinControl(AOwner).Handle;

  InitVar();

  FEmailDBName := '';
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  FFolderListFromOL := TStringList.Create;
  FTempEmailMsgFileListFromRemote := TStringList.Create;
  FRemoteIPAddress := '';
  FIsSaveEmail2DBWhenDropped := False;

  if FileExists(FOLFolderListFileName) then
    FFolderListFromOL.LoadFromFile(FOLFolderListFileName);

  inherited;
end;

procedure TOutlookEmailListFr.DeleteEmialFromGrid2DB(const AOnlySelected: Boolean);
var
  i: integer;
  LEntryID: string;
begin
  for i := grid_Mail.RowCount - 1 downto 0 do
  begin
    if not grid_Mail.RowVisible[i] then
    begin
      LEntryID := GetEmailIDFromGrid(i);

      if DeleteOLMail2DBFromEntryID(LEntryID) then
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
  FEmailDragSource.Free;
//  MAPIUninitialize;
  DeallocateHWnd(FFrameOLEmailListWnd);

  FPJHTimerPool.RemoveAll();
  FPJHTimerPool.Free;

  if FOLEmailSrchRec.FTaskEditConfig.IsUseOLControlWorkerFromEmailList then
    StopWorker();

//  DestroyOLEmailMsg(); //UnitOLEmailRecord2.finalization���� ���� ��
end;

procedure TOutlookEmailListFr.DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
var
  OutlookDataFormat: TOutlookDataFormat;
//  LIsMultiDrop: boolean;
  i, LDroppedCount: integer;
  LOLRespondRec: TOLRespondRec;
  LOmniValue: TOmniValue;
//  LIds: TIDDynArray;
//  LIsNewMailAdded: Boolean;
//  LDroppedMailList, LNewAddedEmailList: TStringList;
//  LOriginalEntryId, LOriginalStoreId,
//  LJson, LNewStoreId, LNewStorePath: string;
//
//  LMessage: IMessage;
//  LMailItem: _MailItem;
begin
  // ������ Ž���⿡�� Drag ���� ��� LFileName�� Drag�� File Name�� ������
  // OutLook���� Drag�� ��쿡�� LFileName = '' ��
  if (DataFormatAdapterOutlook.DataFormat <> nil) then
  begin
    OutlookDataFormat := DataFormatAdapterOutlook.DataFormat as TOutlookDataFormat;
    LDroppedCount := OutlookDataFormat.Messages.Count; //Drop�� ���� ����
//    LIsMultiDrop := LDroppedCount > 1;

    LOLRespondRec.FID := LDroppedCount;
    LOLRespondRec.FSenderHandle := FFrameOLEmailListWnd;
    LOmniValue := TOmniValue.FromRecord(LOLRespondRec);

    //Outlook ���� ���õ� ���� ���� OLControlWorker �� ��û��
    //�� ��û�� ���� ���� �Լ�����(ProcessRespondFromWorker.olrkSelMail4Explore) Grid�� ǥ��
    SendCmd2WorkerThrd(olckGetSelectedMailItemFromExplorer, LOmniValue);
  end;
end;

procedure TOutlookEmailListFr.EditMailInfo1Click(Sender: TObject);
var
  LEmailInfoF: TEmailInfoF;
  LContainData, LProcDirection: integer;
  LContainData2, LProcDirection2,
  LStr: string;
  Li: integer;
  LStrList: TStringList;
begin
  LEmailInfoF := TEmailInfoF.Create(nil);
  try
    with LEmailInfoF do
    begin
      LStrList := g_ContainData4Mail.GetTypeLabels();
      try
        ContainDataCB.Items.Assign(LStrList);
      finally
        LStrList.Free;
      end;
      Li := StrToIntDef(grid_Mail.CellsByName['ContainData', grid_Mail.SelectedRow], 0);
      SetCheckBoxBySetValue(ContainDataCB, Li);
//      ContainDataCB.ItemIndex := StrToIntDef(LStr,0);//g_ContainData4Mail.ToOrdinal(
      LStr := grid_Mail.CellsByName['ProcDirection', grid_Mail.SelectedRow];
      EmailDirectionCB.ItemIndex := StrToIntDef(LStr,0);//g_ProcessDirection.ToOrdinal(
      Description.Text := grid_Mail.CellsByName['Description', grid_Mail.SelectedRow];;

      if LEmailInfoF.ShowModal = mrOK then
      begin
        grid_Mail.CellsByName['ProcDirection', grid_Mail.SelectedRow] := IntToStr(EmailDirectionCB.ItemIndex);
        Li := GetSetFromCheckCombo(ContainDataCB);
        grid_Mail.CellsByName['ContainData', grid_Mail.SelectedRow] := IntToStr(Li);
        grid_Mail.CellsByName['Description', grid_Mail.SelectedRow] := Description.Text;
      end;
    end;//with
  finally
    LEmailInfoF.Free;
  end;
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
    //"\\jhpark@hd.com(2024)\HiCONIS(2024)=EntryId;StoreId;"
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
  i,
  LItemIndex: integer;
begin
  MoveFolderCB.Clear;
  LItemIndex := -1;
  for i := 0 to FFolderListFromOL.Count - 1 do
  begin
    MoveFolderCB.Items.Add(FFolderListFromOL.Names[i]);

    if FDefaultMoveFolder <> '' then
    begin
      if FFolderListFromOL.Names[i] = FDefaultMoveFolder then
        LItemIndex := i;
    end;
  end;

  MoveFolderCB.ItemIndex := LItemIndex;
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
    Message.Result := DefWindowProc(FFrameOLEmailListWnd, Message.Msg, Message.WParam, Message.LParam);
end;

function TOutlookEmailListFr.GetEmailIDFromGrid(ARow: integer): string;
begin
  if ARow <> -1 then
  begin
    Result := grid_Mail.CellsByName['LocalEntryID', ARow]
  end
  else
    Result := '';
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

procedure TOutlookEmailListFr.GetUnReadMailList1Click(Sender: TObject);
var
  LOLRespondRec: TOLRespondRec;
  LOmniValue: TOmniValue;
begin
  if MoveFolderCB.ItemIndex <> -1 then
  begin
    LOLRespondRec.FID := Ord(olcGetUnReadMailListFromFolder);
    LOLRespondRec.FSenderHandle := FFrameOLEmailListWnd;
    LOLRespondRec.FMsg := MoveFolderCB.Text;
    LOmniValue := TOmniValue.FromRecord(LOLRespondRec);

    //Outlook ���� ���� ���� ���� ���� OLControlWorker �� ��û��
    //�� ��û�� ���� ���� �Լ�����(ProcessRespondFromWorker.olrkUnReadMailList4Folder) Grid�� ǥ��
    SendCmd2WorkerThrd(olcGetUnReadMailListFromFolder, LOmniValue);
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

procedure TOutlookEmailListFr.grid_MailMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LRect: TRect;
  LPoint: TPoint;
  LOLED: TOLEmail_DragSourceRec;
begin
  LRect := grid_Mail.GetHeaderRect;
  LPoint.X := X;
  LPoint.Y := Y;

  if PtInRect(LRect, LPoint) then
    exit;

  if grid_Mail.SelectedCount > 0 then
  begin
    if (DragDetectPlus(TWinControl(Sender).Handle, Point(X,Y))) then
    begin
      if grid_Mail.SelectedCount = 1 then
      begin
        i := grid_Mail.SelectedRow;
        MoveOLEmailData2DragSrcRecFromGrid(i, LOLED);
        FEmailDragSource.OLED := LOLED;

        //Matrix Data Move�� ������. ���߿� �߰��� ��.
      end
      else
      begin
      end;

      DropTextSource1.Execute;
    end;
  end;
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
  FFrameOLEmailListWnd := AllocateHWnd(FrameWndProc);

  FPJHTimerPool := TPJHTimerPool.Create(Self);

  InitEmailClient();
  FEmailDragSource := TOLEmail_DragSourceDataFormat.Create(DropTextSource1);
//  InitMAPI();
end;

procedure TOutlookEmailListFr.InitVarFromOwner(ARec: TOLEmailSrchRec);
begin
  SetOLEmailSrchRec(ARec);

  //OLControlWorker�� Frame���� ������
  if ARec.FTaskEditConfig.IsUseOLControlWorkerFromEmailList then
  begin
    StartWorker();
    FPJHTimerPool.AddOneShot(OnInitVarTimer,1000);
  end
  else
  //OLControlWorker�� HiconisASManager���� ������
  begin

  end;

  FPJHTimerPool.AddOneShot(OnGetOLFolderListTimer,2000);

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
//    10: Result := '[���� ���� ���� �� ȸ�� ��û] / ' + ATask.HullNo + ', �����ȣ: ' + ATask.Order_No;
//    11: Result := MakeForwardPayCheckSubConEmailBody(ATask, AMyNameSig);//'[��ü �⼺ Ȯ�� ��û] / ' + ATask.HullNo + ', �����ȣ: ' + ATask.Order_No;
//    12: Result := '[��ü �⼺ ó�� ��û] / ' + ATask.HullNo + ', �����ȣ: ' + ATask.Order_No;
  end;
end;

procedure TOutlookEmailListFr.MoveEmail2Folder(AOriginalEntryID, AOriginalStoreID,
  ANewStoreId, ANewStorePath: string; AIsShowResult: Boolean; ASubFolder: string);
var
  LOmniValue: TOmniValue;
  LOriginalEntryId, LOriginalStoreId,
  LSubFolder: string;
  LMovedMailList: TStringList;
begin
  LSubFolder := '';

//  if AutoMove2HullNoCB.Checked then
//    LHullNo := FHullNo
//  else
//    LHullNo := AHullNo;

  if SubFolderCB.Checked then
    LSubFolder := SubFolderNameEdit.Text
  else
    LSubFolder := ASubFolder;

  LMovedMailList := TStringList.Create;
  try
    if (ANewStoreId <> '') and (ANewStorePath <> '') then
    begin
      FEntryIdRecord.FEntryId := AOriginalEntryID;
      FEntryIdRecord.FStoreId := ANewStoreId;
      FEntryIdRecord.FFolderPath4Move := LSubFolder;
      FEntryIdRecord.FSenderHandle := FFrameOLEmailListWnd;

      LOmniValue := TOmniValue.FromRecord(FEntryIdRecord);
      //LDoc : {grid_Mail Column Name, vaule} �� Json ������
      SendCmd2WorkerThrd(olckMoveMail2Folder, LOmniValue);

//      SendCmd2WorkerThrd(olckMoveMail2Folder, TOmniValue.CastFrom(FFrameOLEmailListWnd));

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

function TOutlookEmailListFr.MoveEmailList2MoveFolderByClaimNoFromSelected: integer;
var
  i: integer;
  LOriginalEntryId, LOriginalStoreId, LHullNo, LClaimNo: string;
//  LDocList: IDocList;
  LDocDict: IDocDict;
  LUtf8: RawUtf8;
begin
  if MoveFolderCB.Text = '' then
  begin
    ShowMessage('Please select move folder!');
    exit;
  end;

//  LDocList := DocList('[]');
  LDocDict := DocDict('{}');

  for i := 0 to grid_Mail.RowCount - 1 do
  begin
    LDocDict.Clear;

    if grid_Mail.Row[i].Selected then
    begin
      if not grid_Mail.CellByName['ExistInDB', i].AsBoolean then
        Continue;

      LHullNo := grid_Mail.CellsByName['HullNo', i];

      if LHullNo = '' then
        Continue;

      LDocDict.S['HullNo'] := LHullNo;

      LClaimNo := grid_Mail.CellsByName['ClaimNo', i];

      if LClaimNo = '' then
        Continue;

      LDocDict.S['ClaimNo'] := LClaimNo;

      LClaimNo := MoveFolderCB.Text + ';' + LHullNo + '\' + LClaimNo;

      LDocDict.S['SubFolderPath'] := LClaimNo;
      LDocDict.S['LocalEntryId'] := grid_Mail.CellsByName['LocalEntryId', i];
      LDocDict.S['LocalStoreId'] := grid_Mail.CellsByName['LocalStoreId', i];
      LDocDict.S['SavedOLFolderPath'] := grid_Mail.CellsByName['SavedOLFolderPath', i];

      LOriginalEntryId := grid_Mail.CellByName['LocalEntryId', i].AsString;
      LOriginalStoreId := grid_Mail.CellByName['LocalStoreId', i].AsString;

      LUtf8 := LDocDict.Json;

      ReqMoveEmailFolder2WorkerFromJson(LUtf8);
//      MoveEmail2Folder(LOriginalEntryId, LOriginalStoreId,
//        FFolderListFromOL.ValueFromIndex[MoveFolderCB.ItemIndex],
//        FFolderListFromOL.Names[MoveFolderCB.ItemIndex], True, LClaimNo);
    end;
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

procedure TOutlookEmailListFr.MoveOLEmailData2DragSrcRecFromGrid(
  const ARow: integer; var ARec: TOLEmail_DragSourceRec);
begin
  with grid_Mail, ARec do
  begin
    FTaskID := CellsByName['TaskID', ARow];
    FHullNo := CellsByName['HullNo', ARow];
    FClaimNo := CellsByName['ClaimNo', ARow];
    FOrderNo := CellsByName['ProjectNo', ARow];
    FSubject := CellsByName['Subject', ARow];
  end;
end;

procedure TOutlookEmailListFr.MoveSelectedEmail2MoveFolder1Click(
  Sender: TObject);
begin
  MoveEmailList2MoveFolderByClaimNoFromSelected();
end;

procedure TOutlookEmailListFr.OnGetOLFolderListTimer(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  SendCmd2WorkerThrd(olckGetFolderList, TOmniValue.CastFrom(FFrameOLEmailListWnd));
end;

procedure TOutlookEmailListFr.OnInitVarTimer(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  SendCmd2WorkerThrd(olckInitVar, TOmniValue.CastFrom(FFrameOLEmailListWnd));
end;

procedure TOutlookEmailListFr.OnWorkerResult(var Msg: Winapi.Messages.TMessage);
var
  LOLRespondRec: TOLRespondRec;
  LMsg  : TOmniMessage;
//  LMsgQ: TOmniMessageQueue;
begin
  if FOLEmailSrchRec.FTaskEditConfig.IsUseOLControlWorkerFromEmailList then
  begin
    //OLControlWorker���� ���� ������
    if FResponseQueue.TryDequeue(LMsg) then
    begin
      LOLRespondRec := LMsg.MsgData.ToRecord<TOLRespondRec>;

      ProcessRespondFromWorker(LMsg.MsgID, LOLRespondRec);
    end;
  end
  else
  begin
    //HiconisASManage���� ���� ����
    while FOLEmailSrchRec.FTaskEditConfig.IPCMQ2RespondOLEmail.TryDequeue(LMsg) do
    begin
      LOLRespondRec := LMsg.MsgData.ToRecord<TOLRespondRec>;

      ProcessRespondFromWorker(LMsg.MsgID, LOLRespondRec);
    end;//while
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
      //FolderList�� ComboBox�� ä������ Grid�� FolderPath�� �����Ͽ� ComboBox ItmeIndex ������
//      SetMoveFolderCBByFolderPath();
      FLogProc(ARec.FMsg);
    end;
    olrkLog: begin
      if Assigned(FLogProc) then
        FLogProc(ARec.FMsg);
    end;
    //Outlook ���� DragDrop �Ǿ����� ���� Outlook���� Select�� Mail ������ Json Array�� ������
    olrkSelMail4Explore: begin
      LUtf8 := StringToUtf8(ARec.FMsg);
      ShowNMoveEmailListFromJsonAry(LUtf8);
//      ShowEmailListFromJson(grid_Mail, LUtf8);
      FLogProc(ARec.FMsg);
    end;
    //Email Move ��(Mail Drop��) ����(New EntryId�� StoreId�� Json���� ��ȯ��)
    olrkMoveMail2Folder: begin
      //grid_Maai�� New EntryId �� StoreId�� ������
      UpdateEmailId2GridFromJson(ARec.FMsg);
      //HullNo Update
      UpdateHullNo2GridIfCellEmpty();
    end;
    olrkUnReadMailList4Folder: begin
      if ARec.FMsg <> '' then
      begin
        LUtf8 := StringToUtf8(ARec.FMsg);
        AddEmail2GridFromJsonAry(LUtf8);
      end;
    end;
    olrkUpdateExistClaimNo2Grid: begin
      UpdateExistDB2GridByJsonAry(ARec.FMsg);
    end;
  end;
end;

//ADynAry: Grid�� Drag Drop �Ǿ� OL���� Selected�� Email List�� Json Array�� ����
function TOutlookEmailListFr.ReqGotoFolder2Worker: integer;
var
  LOmniValue: TOmniValue;
begin
  if MoveFolderCB.ItemIndex <> -1 then
  begin
    //�̵��� Folder Path�� ����: RootFolder + ';' + SubFolder
    FEntryIdRecord.FFolderPath4Move := FFolderListFromOL.Names[MoveFolderCB.ItemIndex] + ';' + SubFolderNameEdit.Text;;
    FEntryIdRecord.FSenderHandle := FFrameOLEmailListWnd;

    LOmniValue := TOmniValue.FromRecord(FEntryIdRecord);
    SendCmd2WorkerThrd(olcGotoFolder, LOmniValue);
  end;
end;

function TOutlookEmailListFr.ReqMoveEmailFolder2WorkerFromDynAry(
  ADynAry: TRawUTF8DynArray): integer;
var
  i, LFolderIdx: integer;
  LDoc: variant;
  LOmniValue: TOmniValue;
  LDestFolder: string;
//  LUtf8: RawUtf8;
begin
  Result := -1;
  LFolderIdx := MoveFolderCB.ItemIndex;

  if LFolderIdx < 0 then
    exit;

  for i := Low(ADynAry) to High(ADynAry) do
  begin
    LDoc := _JSON(ADynAry[i]);
//    LUtf8 := LDoc;

    //Move Folder�� ���� ���� ������(Mail.EntryID, Mail.StoreID, FFolderPath)
    FEntryIdRecord := GetEntryIdFromGridJson(LDoc);

    //�̵��� Root Folder = EntryId + ';' + Folder StoreId�� �����
    LDestFolder := FFolderListFromOL.ValueFromIndex[MoveFolderCB.ItemIndex];

    FEntryIdRecord.FEntryId4MoveRoot := StrToken(LDestFolder, ';');
    FEntryIdRecord.FStoreId4MoveRoot := StrToken(LDestFolder, ';');

    //�̵��� Folder Path�� ����: RootFolder + ';' + SubFolder
    LDestFolder := FFolderListFromOL.Names[MoveFolderCB.ItemIndex] + ';' + SubFolderNameEdit.Text;;
    FEntryIdRecord.FFolderPath4Move := LDestFolder;
    FEntryIdRecord.FSenderHandle := FFrameOLEmailListWnd;

    LOmniValue := TOmniValue.FromRecord(FEntryIdRecord);
    //LDoc : {grid_Mail Column Name, vaule} �� Json ������
    SendCmd2WorkerThrd(olckMoveMail2Folder, LOmniValue);

//    FLogProc(FEntryIdRecord.FFolderPath4Move);
  end;//for

  Result := 1;
end;

function TOutlookEmailListFr.ReqMoveEmailFolder2WorkerFromJson(AJson: RawUTF8;
  ACheckHullNoIsNull: Boolean): integer;
var
  LDoc: variant;
  LOmniValue: TOmniValue;
  LDestFolder, LSubFolder, LHullNo, LClaimNo: string;

  LDocDict: IDocDict;
//  LDocField: TDocDictFields;
begin
  LDocDict := DocDict(AJson);

  LHullNo := LDocDict.S['HullNo'];
  LClaimNo := LDocDict.S['ClaimNo'];
  LSubFolder := LDocDict.S['SubFolderPath'];

  if ACheckHullNoIsNull then
  begin
    if (LHullNo = '') or (LClaimNo = '') then
      exit;

    LSubFolder := LHullNo + '\' + LClaimNo;
  end
  else
    LSubFolder := SubFolderNameEdit.Text;

  LDoc := LDocDict.AsVariant;

  FEntryIdRecord := GetEntryIdFromGridJson(LDoc);

  //�̵��� Root Folder = EntryId + ';' + Folder StoreId�� �����
  LDestFolder := FFolderListFromOL.ValueFromIndex[MoveFolderCB.ItemIndex];

  FEntryIdRecord.FEntryId4MoveRoot := StrToken(LDestFolder, ';');
  FEntryIdRecord.FStoreId4MoveRoot := StrToken(LDestFolder, ';');

  //�̵��� Folder Path�� ����: RootFolder + ';' + SubFolder
  LDestFolder := FFolderListFromOL.Names[MoveFolderCB.ItemIndex] + ';' + LSubFolder;
  FEntryIdRecord.FFolderPath4Move := LDestFolder;
  FEntryIdRecord.FSenderHandle := FFrameOLEmailListWnd;

  LOmniValue := TOmniValue.FromRecord(FEntryIdRecord);
  //LDoc : {grid_Mail Column Name, vaule} �� Json ������
  SendCmd2WorkerThrd(olckMoveMail2Folder, LOmniValue);
end;

function TOutlookEmailListFr.ReqMoveEmailFolder2WorkerFromJsonAry(
  AJsonAry: RawUTF8; ACheckHullNoIsNull: Boolean): integer;
var
  LUtf8: RawUtf8;
  LDocList: IDocList;
  LDocDict: IDocDict;
begin
  Result := -1;

  if MoveFolderCB.ItemIndex < 0 then
    exit;

  LDocList := DocList(AJsonAry);

  for LDocDict in LDocList do
  begin
    LUtf8 := LDocDict.Json;
    ReqMoveEmailFolder2WorkerFromJson(LUtf8);
  end;//for

  Result := 1;
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

function TOutlookEmailListFr.GetJsonAryFromSelectedEmail: RawUtf8;
var
  i: integer;
  LDocList: IDocList;
  LDocDict: IDocDict;
  LVar: Variant;
  LDocVar: Variant;
  LJson: RawUtf8;
begin
  Result := '';
  LDocList := DocList('[]');
  LDocDict := DocDict('{}');
  TDocVariant.New(LDocVar);

  for i := 0 to grid_Mail.RowCount - 1 do
  begin
    if grid_Mail.Row[i].Selected then
    begin
      LDocDict.Clear;
      TDocVariantData(LDocVar).Clear;
      LVar := GetNxGridRow2Variant(grid_Mail, i);
      LDocVar := TDocVariant.NewJson(LVar);
//      LDocDict := DocDictFrom(LVar);
      LDocDict.I['Idx'] := LDocVar.Incremental;
      LDocDict.S['HullNo'] := LDocVar.HullNo;
      LDocDict.S['ClaimNo'] := LDocVar.ClaimNo;
      LDocDict.S['Subject'] := LDocVar.Subject;
      LDocDict.S['Description'] := LDocVar.Description;
      LDocDict.B['ExistInDB'] := False;

      LDocList.AppendDoc(LDocDict);
    end;
  end;

  Result := LDocList.Json;
end;

procedure TOutlookEmailListFr.Save2JsonAryFromSelected1Click(Sender: TObject);
var
  LStr: string;
begin
  LStr := Utf8ToString(GetJsonAryFromSelectedEmail());
  Clipboard.AsText := LStr;
end;

procedure TOutlookEmailListFr.SaveEmailFromGrid2DB(const AOnlySelected: Boolean);
var
  LDoc: variant;
  LJsonArray: string;
  LStrList: TStringList;
begin
  if grid_Mail.RowCount = 0 then
    exit;

  LStrList := TStringList.Create;
  try
    //Grid�� EntryID�� �������� DB�� ������
    DeleteEmialFromGrid2DB(AOnlySelected);
    LDoc := NextGrid2Variant(grid_Mail, False, True, AOnlySelected);
    LJsonArray := LDoc;

    if AddOLMail2DBFromDroppedMail(LJsonArray, LStrList) then
    begin
      //RowID�� DB�� ������ ���Ŀ� �˼� �����Ƿ� DB ���� �Ϸ� �� Grid�� RowID�� Update �ؾ� ��
      //LStrList: LocalEntryId=TID �������� �����
      //Mail �߰� �� grid â�� Close���� ���� ����(DB���� �ڷḦ ���� �о���� ���� ����)���� Mail Delete �ҋ� RowID �� �ʿ���
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
var
  LMsgQ: TOmniMessageQueue;
begin
  if FOLEmailSrchRec.FTaskEditConfig.IsUseOLControlWorkerFromEmailList then
  begin
    if not FCommandQueue.Enqueue(TOmniMessage.Create(Ord(ACmd), AValue)) then
      raise System.SysUtils.Exception.Create('TOutlookEmailListFr.SendCmd2WorkerThrd->Command queue is full!');
  end
  else
  begin
    LMsgQ := FOLEmailSrchRec.FTaskEditConfig.IPCMQCommandOLEmail;

    if not LMsgQ.Enqueue(TOmniMessage.Create(Ord(ACmd), AValue)) then
      raise System.SysUtils.Exception.Create('TOutlookEmailListFr.SendCmd2WorkerThrd->IPCMQCommandOLEmail queue is full!');
  end;
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
  LEntryIdRecord.FSenderHandle := FFrameOLEmailListWnd;
//  LEntryIdRecord.FFolderPath := AGrid.CellsByName['SavedOLFolderPath', ARow];

  LValue := TOmniValue.FromRecord(LEntryIdRecord);

  SendCmd2WorkerThrd(olckShowMailContents, LValue);
end;

function TOutlookEmailListFr.ShowNMoveEmailListFromJsonAry(
  AJson: RawUTF8): integer;
var
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LVar: variant;
  LDestFolder: string;
  LReqResult: integer;
begin
  //AJson = [] ������ Email List��
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LDynArr.LoadFromJSON(PUTF8Char(AJson));

  //OL���κ��� ���� ���� Selected Email List�� Grid�� ǥ��: Move �� EnttryID ǥ�õ�
  AddDroppedEmail2GridFromDynAry(LDynUtf8);

  if AutoMoveCB.Checked then
  begin
    LReqResult := ReqMoveEmailFolder2WorkerFromDynAry(LDynUtf8);//Move �Ϸ� �� ������ EntryId�� Grid�� �����ؾ� ��

    if LReqResult = -1 then
    begin
      UpdateHullNo2GridIfCellEmpty();
      ShowMessage('Email Move fail.');
    end;
  end
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
  //Grid Column Name�� Ȯ���Ͽ� Json Name�� ���ϸ鼭 Grid Insert ��
  GetListFromVariant2NextGrid(grid_Mail, LVar, True, True, True, True);
//  AddNextGridRowsFromVariant2(OLEmailListFr.grid_Mail, LVar);
end;

procedure TOutlookEmailListFr.StartWorker;
begin
  FCommandQueue := TOmniMessageQueue.Create(1000);
  FResponseQueue := TOmniMessageQueue.Create(1000, false);
  FSendMsgQueue := TOmniMessageQueue.Create(1000);

  FOLControlWorker := TOLControlWorker.Create(FCommandQueue, FResponseQueue, FSendMsgQueue, FFrameOLEmailListWnd);
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
  //EMailDBName�� �����ϰ� ������ SetDBName4Email()�Լ��� ������ ��
//  if FEmailDBName = '' then
//  begin
//    FEmailDBName := Application.ExeName;
//    FEmailDBName := FEmailDBName.Replace('.exe', '_' + FDBNameSuffix + '.exe');
//  end;
//
//  InitOLEmailMsgClient(FEmailDBName);
  Timer1.Enabled := False;
end;

procedure TOutlookEmailListFr.UpdateClaimExist1Click(Sender: TObject);
var
  LOLRespondRec: TOLRespondRec;
  LOmniValue: TOmniValue;
begin
  LOLRespondRec.FID := Ord(olcCheckExistClaimNoInDB);
  LOLRespondRec.FSenderHandle := FFrameOLEmailListWnd;
  LOLRespondRec.FMsg := Utf8ToString(GetJsonAryFromSelectedEmail());
  LOmniValue := TOmniValue.FromRecord(LOLRespondRec);

  //Outlook ���� ���� ���� ���� ���� OLControlWorker �� ��û��
  //�� ��û�� ���� ���� �Լ�����(ProcessRespondFromWorker.olrkUnReadMailList4Folder) Grid�� ǥ��
  SendCmd2WorkerThrd(olcCheckExistClaimNoInDB, LOmniValue);
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

procedure TOutlookEmailListFr.UpdateExistDB2GridByJsonAry(AJsonAry: string);
var
  LUtf8: RawUtf8;
  LDocList, LResultList: IDocList;
  LDocDict: IDocDict;
  LHullNo, LClaimNo, LTaskID: string;
  LIntAry, LRowAry: TArrayRecord<integer>;
  LStrAry: TArrayRecord<string>;
  LRow: integer;
  LVar: variant;
begin
  LResultList := DocList('[]');
  LDocList := DocList('[]');
  LDocDict := DocDict('{}');

  LDocList := DocList(StringToUtf8(AJsonAry));

//  LIntAry := TArrayRecord<integer>.Create(2);
//  LStrAry := TArrayRecord<string>.Create(2);

  LIntAry.Add(1);
  LIntAry.Add(2);
  LIntAry.Add(4);

  for LDocDict in LDocList.Objects do
  begin
    LStrAry.Clear;

    LHullNo := LDocDict.S['HullNo'];
    LClaimNo := LDocDict.S['ClaimNo'];
    LTaskID := LDocDict.S['LTaskID'];
    LVar := LDocDict.B['ExistInDB'];

    LStrAry.Add(LTaskID);
    LStrAry.Add(LHullNo);
    LStrAry.Add(LClaimNo);

    LRowAry.Items := GetRowIndexByColIndexAryFromFindStrAry(grid_Mail, LStrAry.Items, LIntAry.Items);

    SetNxGridCellValueByRowAryFromVar(grid_Mail, 'ExistInDB', LRowAry.Items, LVar);
    ChangeRowColorByRowAry(grid_Mail, LRowAry.Items, clInfoBk);
  end;
end;

procedure TOutlookEmailListFr.UpdateHullNoNClaimNo2GridByJsonAry(AJsonAry: string);
var
  LIdx: integer;
  LDocList: IDocList;
  LDocDict: IDocDict;
  LStr: string;
  LBool: Boolean;
begin
  LDocList := DocList(StringToUtf8(AJsonAry));

  for LDocDict in LDocList.ObjectsDicts do
  begin
    LIdx := LDocDict.I['Idx'] - 1;

    if (LIdx >= 0) and (LIdx < grid_Mail.RowCount) then
    begin
      LStr := LDocDict.S['HullNo'];
      grid_Mail.CellsByName['HullNo', LIdx] := AdjustHullNo(LStr);
      LStr := LDocDict.S['ClaimNo'];
      grid_Mail.CellsByName['ClaimNo', LIdx] := RemoveSpace2String(LStr);
      LStr := LDocDict.S['TaskID'];
      grid_Mail.CellsByName['TaskID', LIdx] := RemoveSpace2String(LStr);
      LBool := LDocDict.B['ExistInDB'];
      grid_Mail.CellByName['ExistInDB', LIdx].AsBoolean := LBool;
//      grid_Mail.CellsByName['Subject', LIdx] := LDocDict.S['Subject'];
//      grid_Mail.CellsByName['Description', LIdx] := LDocDict.S['Description'];
    end;
  end;
end;

procedure TOutlookEmailListFr.UpdateHullNo2GridIfCellEmpty;
var
  i: integer;
begin
  if FOLEmailSrchRec.FTaskEditConfig.IsAllowUpdateHullNo2Grid then
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

        if grid_Mail.CellsByName['Description', i] = '' then
          grid_Mail.CellsByName['Description', i] := grid_Mail.CellsByName['FlagRequest', i];

        if grid_Mail.CellsByName['TaskID', i] = '' then
          grid_Mail.CellsByName['TaskID', i] := IntToStr(FOLEmailSrchRec.FTaskID);
      end;
    finally
      grid_Mail.EndUpdate();
    end;
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
