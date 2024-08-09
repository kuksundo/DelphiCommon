unit FrmToDoList2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ImgList, SBPro,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvOfficeTabSet, Vcl.StdCtrls, AeroButtons,
  Vcl.ExtCtrls, Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons, JvExControls,
  JvLabel, CurvyControls, OtlCommon, OtlComm,

  mormot.core.base, mormot.core.collections, mormot.core.json, mormot.core.variants,
  mormot.core.datetime, mormot.core.unicode, mormot.orm.base, mormot.core.rtti,

  UnitToDoList, UnitHiASToDoRecord, UnitHiconisMasterRecord, UnitOLEmailRecord2,
  UnitOutLookDataType
  ;

type
  TToDoListF2 = class(TForm)
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel10: TJvLabel;
    PeriodPanel: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    PeriodCombo: TComboBox;
    ClaimServiceKindCB: TComboBox;
    HullNoEdit: TEdit;
    ShipNameEdit: TEdit;
    BefAftCB: TComboBox;
    CurWorkCB: TComboBox;
    Panel1: TPanel;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    WorkKindCB: TComboBox;
    ClaimNoEdit: TEdit;
    OrderNoEdit: TEdit;
    DisplayFinalCheck: TCheckBox;
    ClearBtn: TButton;
    PICCB: TComboBox;
    TaskTab: TAdvOfficeTabSet;
    TodoGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    TaskID: TNxTextColumn;
    EntryId: TNxTextColumn;
    StoreId: TNxTextColumn;
    EmailEntryId: TNxTextColumn;
    EmailStoreId: TNxTextColumn;
    UniqueID: TNxTextColumn;
    Plan_Code: TNxTextColumn;
    Subject: TNxTextColumn;
    ToDoReourece: TNxTextColumn;
    ModId: TNxTextColumn;
    Category: TNxTextColumn;
    Project: TNxTextColumn;
    Notes: TNxMemoColumn;
    StatusBarPro1: TStatusBarPro;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    PopupMenu1: TPopupMenu;
    DeleteTask1: TMenuItem;
    N2: TMenuItem;
    ImageList32x32: TImageList;
    CreationDate: TNxDateColumn;
    DueDate: TNxDateColumn;
    CompletionDate: TNxDateColumn;
    ModDate: TNxDateColumn;
    Resource: TNxTextColumn;
    AlarmTime1: TNxDateColumn;
    AlarmTime2: TNxTextColumn;
    ImageIndex: TNxTextColumn;
    Tag: TNxTextColumn;
    Completion: TNxCheckBoxColumn;
    Status: TNxTextColumn;
    Priority: TNxTextColumn;
    TotalTime: TNxTextColumn;
    Alarm2Msg: TNxCheckBoxColumn;
    Alarm2Note: TNxCheckBoxColumn;
    Alarm2Email: TNxCheckBoxColumn;
    AeroButton1: TAeroButton;
    RowID: TNxTextColumn;
    Alarm2Popup: TNxCheckBoxColumn;
    AlarmFlag: TNxTextColumn;
    AlarmType: TNxComboBoxColumn;
    TaskIDEdit: TEdit;
    ShowFromOL1: TMenuItem;
    OLObjectKind: TNxTextColumn;
    procedure ClearBtnClick(Sender: TObject);
    procedure TodoGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure btn_CloseClick(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure DeleteTask1Click(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure ShowFromOL1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AddTodoItemFromJson2Grid(AItemJson: RawUtf8; const AIsRowClear: Boolean=False);
    procedure AddOrUpdateTodoItemRec2TodoListByJson(ARow: integer; AItemJson: string);

    procedure EditToDoList(ARow: integer);
    procedure DeleteToDoItem;
    function GetNewToDoItemRec: TpjhTodoItemRec;
    function GetNewToDoItemRec2Json: string;
    function GetTodoBodyWithHullnoFromForm: string;
    procedure ReqDisplayTodoItem2OL(AEntryId: string);
  public
    FpjhToDoList: TpjhToDoList;
    FSrchRec: TToDoSearchRec;
    FTaskEditConfig: THiconisASTaskEditConfig;

    procedure InitEnum;
    procedure GetSrchRecFromForm();
    procedure ShowHeaderInfoFromTaskId(ATaskId: TID);
    procedure ShowTodolist2GridFromSrchRec();
    procedure ShowTodoItemBySelected2OL();
  end;

  //ATaskId = TaskID
  //AIsDisplayComplete: True = 완료된(Complete = True) 것도 표시
  function Create_ToDoList_Frm2(ATaskId: TID; var AToDoList: TpjhToDoList;
    ATaskEditConfig: THiconisASTaskEditConfig;
    AIsDisplayComplete: Boolean = False) : integer;

var
  ToDoListF2: TToDoListF2;

implementation

uses UnitNextGridUtil2, FrmTodo_Detail, UnitStringUtil, UnitIPCMsgQUtil,
  UnitElecServiceData2;

{$R *.dfm}

function Create_ToDoList_Frm2(ATaskId: TID; var AToDoList: TpjhToDoList;
  ATaskEditConfig: THiconisASTaskEditConfig;
  AIsDisplayComplete: Boolean = False) : integer;
var
  i: integer;
  LToDoListF: TToDoListF2;
  LpjhTodoItemRec: TpjhTodoItemRec;
  LUtf8: RawUtf8;
  LTodoPair: TPair<string, TpjhTodoItemRec>;
begin
  LToDoListF := TToDoListF2.Create(nil);
  try
    with LToDoListF do
    begin
      FpjhToDoList := AToDoList;
      RecordCopy(FTaskEditConfig, ATaskEditConfig, TypeInfo(THiconisASTaskEditConfig));
      ShowHeaderInfoFromTaskId(ATaskId);

      for LTodoPair in FpjhToDoList do
      begin
        if not AIsDisplayComplete then
          if LTodoPair.Value.Complete then
            Continue;

        LUtf8 := RecordSaveJson(LTodoPair.Value, TypeInfo(TpjhTodoItemRec));

        AddTodoItemFromJson2Grid(LUtf8);
      end;

      Result := ShowModal();

      if Result = mrOK then
      begin
//        if FpjhToDoList.Count then

      end;
    end;//with

  finally
    LToDoListF.Free;
  end;
end;

function TToDoListF2.GetNewToDoItemRec: TpjhTodoItemRec;
begin
  Result := Default(TpjhTodoItemRec);

  with Result do
  begin
    TaskID := StrToIntDef(TaskIDEdit.Text,0);
    Plan_Code := HullNoEdit.Text + '-' + ClaimNoEdit.Text;
    Subject := Plan_Code + ': ';
    Notes := GetTodoBodyWithHullnoFromForm();
    UniqueID := NewGUID(True, True);
    DueDate := TimeLogFromDateTIme(Now + 60);
    CreationDate := TimeLogFromDateTIme(Now);
    BeginDate := TimeLogFromDateTIme(Now);;
    BeginTime := TimeLogFromDateTIme(Now);;
    EndDate := TimeLogFromDateTIme(Now);;
    EndTime := TimeLogFromDateTIme(Now);;
    CompletionDate := TimeLogFromDateTIme(Now);;
    AlarmTime1 := TimeLogFromDateTIme(Now);;
    ModDate := TimeLogFromDateTIme(Now);;
    AlarmTime := TimeLogFromDateTIme(Now);;
    Priority := Ord(tpNormal);
    Resource := 'Unassigned';
//    Categories := ClaimServiceKindCB.Text;
  end;
end;

function TToDoListF2.GetNewToDoItemRec2Json: string;
var
  LRec: TpjhTodoItemRec;
begin
  LRec := GetNewToDoItemRec;
  Result := RecordSaveJson(LRec, TypeInfo(TpjhTodoItemRec));
end;

procedure TToDoListF2.GetSrchRecFromForm;
begin
  FSrchRec := Default(TToDoSearchRec);

  FSrchRec.From := dt_begin.Date;
  FSrchRec.FTo := dt_end.Date;

  FSrchRec.QueryDate := TTodoQueryDateType(PeriodCombo.ItemIndex);
  FSrchRec.TaskID := 0;
  FSrchRec.HullNo := HullNoEdit.Text;
  FSrchRec.ShipName := ShipNameEdit.Text;
  FSrchRec.OrderNo := OrderNoEdit.Text;
  FSrchRec.ClaimNo := ClaimNoEdit.Text;
//  FSrchRec.Subject :=
//  FSrchRec.CreationDate :=
//  FSrchRec.DueDate :=
//  FSrchRec.CompletionDate :=
//  FSrchRec.ModDate :=
//  FSrchRec.AlarmTime1 :=
end;

function TToDoListF2.GetTodoBodyWithHullnoFromForm: string;
begin
  Result := HullNoEdit.Text + '-' + ClaimNoEdit.Text + '-' + ShipNameEdit.Text + '-' + OrderNoEdit.Text;
end;

procedure TToDoListF2.InitEnum;
begin
  g_TodoQueryDateType.InitArrayRecord(R_TodoQueryDateType);
  g_TodoQueryDateType.SetType2Combo(PeriodCombo);
  g_ClaimServiceKind.SetType2Combo(ClaimServiceKindCB);
  g_TodoCategory.InitArrayRecord(R_TodoCategory);
end;

procedure TToDoListF2.ReqDisplayTodoItem2OL(AEntryId: string);
var
  LOLObjRec: TOLObjectRec;
  LValue: TOmniValue;
  LMsgQ: TOmniMessageQueue;
begin
  LOLObjRec.EntryID := AEntryId;

  LOLObjRec.FSenderHandle := Handle;
  LValue := TOmniValue.FromRecord(LOLObjRec);
  LMsgQ := FTaskEditConfig.IPCMQCommandOLCalendar;

  SendCmd2OmniMsgQ(Ord(olckShowObject), LValue, LMsgQ);
end;

procedure TToDoListF2.ShowFromOL1Click(Sender: TObject);
begin
  ShowTodoItemBySelected2OL();
end;

procedure TToDoListF2.ShowHeaderInfoFromTaskId(ATaskId: TID);
var
  LOrmHiconisASTask: TOrmHiconisASTask;
begin
  //특정 Task가 아닌 여러 Task를 표시함
  if ATaskId = -1 then
    exit;

  LOrmHiconisASTask := GetLoadTask(ATaskId);
  try
    if LOrmHiconisASTask.IsUpdate then
    begin
      HullNoEdit.Text := LOrmHiconisASTask.HullNo;
      ShipNameEdit.Text := LOrmHiconisASTask.ShipName;
      ClaimNoEdit.Text := LOrmHiconisASTask.ClaimNo;
      OrderNoEdit.Text := LOrmHiconisASTask.Order_No;
      ClaimServiceKindCB.ItemIndex := LOrmHiconisASTask.ClaimServiceKind;
    end;

    TaskIDEdit.Text := IntToStr(ATaskId);
  finally
    LOrmHiconisASTask.Free;
  end;
end;

procedure TToDoListF2.ShowTodoItemBySelected2OL;
var
  LEntryID: string;
begin
  if TodoGrid.SelectedRow <> -1 then
  begin
    LEntryID :=TodoGrid.CellsByName['EntryId', TodoGrid.SelectedRow];

    if LEntryID <> '' then
    begin
      ReqDisplayTodoItem2OL(LEntryID);
    end;
  end;
end;

procedure TToDoListF2.ShowTodolist2GridFromSrchRec;
var
  LSQLToDoItem: TSQLToDoItem;
  LJson: RawUtf8;
begin
  GetSrchRecFromForm();

  LSQLToDoItem := GetTodoListOrmFromSearchRec(FSrchRec);
  try
    LSQLToDoItem.FillRewind;
    TodoGrid.ClearRows;

    while LSQLToDoItem.FillOne do
    begin
      LJson := LSQLToDoItem.GetJsonValues(True, True, ooSelect);
      AddTodoItemFromJson2Grid(LJson);
    end;//while
  finally
    LSQLToDoItem.Free;
  end;
//  if LSQLToDoItem.IsUpdate then
//  begin
//    LSQLToDoItem.FillRewind;
//
//    while LSQLToDoItem.FillOne do
//    begin
//
//    end;//while
//  end;
end;

procedure TToDoListF2.AddOrUpdateTodoItemRec2TodoListByJson(ARow: integer;
  AItemJson: string);
var
  LRec: TpjhTodoItemRec;
begin
  RecordLoadJson(LRec, StringToUtf8(AItemJson), TypeInfo(TpjhTodoItemRec));

  FpjhTodoList.Data.AddOrUpdate(LRec.UniqueID, LRec);
end;

procedure TToDoListF2.AddTodoItemFromJson2Grid(AItemJson: RawUtf8; const AIsRowClear: Boolean);
var
  LDoc: Variant;
begin
  LDoc := _JSON(AItemJson);
  TodoGrid.BeginUpdate;
  try
    if AIsRowClear then
      TodoGrid.ClearRows;

    AddNextGridRowFromVariant(TodoGrid, LDoc, True);
  finally
    TodoGrid.EndUpdate();
  end;
end;

procedure TToDoListF2.AeroButton1Click(Sender: TObject);
begin
  EditToDoList(-1);
end;

procedure TToDoListF2.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TToDoListF2.btn_SearchClick(Sender: TObject);
begin
  ShowTodolist2GridFromSrchRec();
end;

procedure TToDoListF2.ClearBtnClick(Sender: TObject);
begin
  PeriodCombo.ItemIndex := -1;
  HullNoEdit.Text := '';
  ClaimNoEdit.Text := '';
  ShipNameEdit.Text := '';
  OrderNoEdit.Text := '';
  CurWorkCB.ItemIndex := -1;
  ClaimServiceKindCB.ItemIndex := -1;
end;

procedure TToDoListF2.DeleteTask1Click(Sender: TObject);
begin
  DeleteToDoItem();
  ShowTodolist2GridFromSrchRec();
end;

procedure TToDoListF2.DeleteToDoItem;
var
  LUniqueID: string;
begin
  if TodoGrid.SelectedRow <> -1 then
  begin
    if MessageDlg('선택한 항목을 삭제 하시겠습니까?', mtConfirmation, [mbYes, mbNo],
      0) = mrYes then
    begin
      LUniqueID := TodoGrid.CellsByName['UniqueID', TodoGrid.SelectedRow];
      DeleteToDoRecFromDBByUniqueID(LUniqueID);
      FpjhToDoList.Remove(LUniqueID);
    end;
  end;
end;

procedure TToDoListF2.EditToDoList(ARow: integer);
var
  LToDoDetailF: TToDoDetailF;
  LVar: Variant;
  LJson: String;
  LIsAdd: Boolean;
begin
  LIsAdd := ARow = -1;

  LToDoDetailF := TToDoDetailF.Create(Self);
  try
    with LToDoDetailF do
    begin
      if LIsAdd then
      begin
        LJson := GetNewToDoItemRec2Json();
      end
      else
      begin
        LVar := GetNxGridRow2Variant(TodoGrid, ARow);
        LJson := LVar;
      end;

      RecordCopy(LToDoDetailF.FTaskEditConfig, Self.FTaskEditConfig, TypeInfo(THiconisASTaskEditConfig));
      SetTodoItemFromJson2Form(LJson);

      if LToDoDetailF.ShowModal = mrOK then
      begin
        LVar := _JSON(LJson);
        //ShowModal 전 데이터를 먼저 Grid에 Write
        SetNxGridRowFromVar(TodoGrid, ARow, LVar);

        LJson := GetTodoItem2JsonFromForm();
        LVar := _JSON(LJson);
        //변경된 데이터만 Grid에 Overwrite
        SetNxGridRowFromVar(TodoGrid, ARow, LVar);
        //Overwrite된 값을 Grid로 부터 가져옴
        LVar := GetNxGridRow2Variant(TodoGrid, ARow);
        LJson := LVar;

//        if LIsAdd then
//        begin
          AddOrUpdateTodoItemRec2TodoListByJson(ARow, LJson);
          AddOrUpdateToDoItem2DBByJson(LJson);
//        end;
      end;
    end;//with
  finally
    FreeAndNil(LToDoDetailF);
  end;//try
end;

procedure TToDoListF2.FormCreate(Sender: TObject);
begin
  InitEnum();
end;

procedure TToDoListF2.TodoGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  EditToDoList(TodoGrid.SelectedRow);
end;

end.
