unit FrmToDoList2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ImgList, SBPro,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvOfficeTabSet, Vcl.StdCtrls, AeroButtons,
  Vcl.ExtCtrls, Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons, JvExControls,
  JvLabel, CurvyControls,

  mormot.core.base, mormot.core.collections, mormot.core.json, mormot.core.variants,
  mormot.core.datetime, mormot.core.unicode,

  UnitToDoList, UnitHiASToDoRecord, UnitHiconisMasterRecord
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
    ProductTypeCombo: TComboBox;
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
    AppointmentEntryId: TNxTextColumn;
    AppointmentStoreId: TNxTextColumn;
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
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Invoice1: TMenuItem;
    Invoice2: TMenuItem;
    InvoiceConfirm1: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    N5: TMenuItem;
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
    procedure ClearBtnClick(Sender: TObject);
    procedure TodoGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure btn_CloseClick(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure DeleteTask1Click(Sender: TObject);
  private
    procedure AddTodoItemFromJson2Grid(AItemJson: RawUtf8);
    procedure AddOrUpdateTodoItemRec2TodoListByJson(ARow: integer; AItemJson: string);

    procedure EditToDoList(ARow: integer);
    procedure DeleteToDoItem;
    function GetNewToDoItemRec: TpjhTodoItemRec;
    function GetNewToDoItemRec2Json: string;
  public
    FpjhToDoList: TpjhToDoList;

    procedure ShowHeaderInfoFromTaskId(ATaskId: TID);
  end;

  //ATaskId = TaskID
  //AIsDisplayComplete: True = 완료된(Complete = True) 것도 표시
  function Create_ToDoList_Frm2(ATaskId: TID; var AToDoList: TpjhToDoList;
    AIsDisplayComplete: Boolean = False) : integer;

var
  ToDoListF2: TToDoListF2;

implementation

uses UnitNextGridUtil2, FrmTodo_Detail;

{$R *.dfm}

function Create_ToDoList_Frm2(ATaskId: TID; var AToDoList: TpjhToDoList;
  AIsDisplayComplete: Boolean = False) : integer;
var
  i: integer;
  LToDoListF: TToDoListF2;
  LpjhTodoItemRec: TpjhTodoItemRec;
  LUtf8: RawUtf8;
begin
  LToDoListF := TToDoListF2.Create(nil);
  try
    with LToDoListF do
    begin
      FpjhToDoList := AToDoList;
      ShowHeaderInfoFromTaskId(ATaskId);

      for LpjhTodoItemRec in FpjhToDoList do
      begin
        if not AIsDisplayComplete then
          if LpjhTodoItemRec.Complete then
            Continue;

        LUtf8 := RecordSaveJson(LpjhTodoItemRec, TypeInfo(TpjhTodoItemRec));

        AddTodoItemFromJson2Grid(LUtf8);
      end;

      Result := ShowModal();

      if Result = mrOK then
      begin

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
    Subject := '새 일정';
    Notes := '일정 상세';
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
  end;
end;

function TToDoListF2.GetNewToDoItemRec2Json: string;
var
  LRec: TpjhTodoItemRec;
begin
  LRec := GetNewToDoItemRec;
  Result := RecordSaveJson(LRec, TypeInfo(TpjhTodoItemRec));
end;

procedure TToDoListF2.ShowHeaderInfoFromTaskId(ATaskId: TID);
var
  LOrmHiconisASTask: TOrmHiconisASTask;
begin
  LOrmHiconisASTask := GetLoadTask(ATaskId);
  try
    if LOrmHiconisASTask.IsUpdate then
    begin
      HullNoEdit.Text := LOrmHiconisASTask.HullNo;
      ShipNameEdit.Text := LOrmHiconisASTask.ShipName;
      ClaimNoEdit.Text := LOrmHiconisASTask.ClaimNo;
      OrderNoEdit.Text := LOrmHiconisASTask.Order_No;
    end;
  finally
    LOrmHiconisASTask.Free;
  end;
end;

procedure TToDoListF2.AddOrUpdateTodoItemRec2TodoListByJson(ARow: integer;
  AItemJson: string);
var
  LRec: TpjhTodoItemRec;
begin
  RecordLoadJson(LRec, StringToUtf8(AItemJson), TypeInfo(TpjhTodoItemRec));
  FpjhTodoList.Add(LRec);
end;

procedure TToDoListF2.AddTodoItemFromJson2Grid(AItemJson: RawUtf8);
var
  LDoc: Variant;
begin
  LDoc := _JSON(AItemJson);
  AddNextGridRowFromVariant(TodoGrid, LDoc);
end;

procedure TToDoListF2.AeroButton1Click(Sender: TObject);
begin
  EditToDoList(-1);
end;

procedure TToDoListF2.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TToDoListF2.ClearBtnClick(Sender: TObject);
begin
  PeriodCombo.ItemIndex := -1;
  HullNoEdit.Text := '';
  ClaimNoEdit.Text := '';
  ShipNameEdit.Text := '';
  OrderNoEdit.Text := '';
  CurWorkCB.ItemIndex := -1;
  ProductTypeCombo.ItemIndex := -1;
end;

procedure TToDoListF2.DeleteTask1Click(Sender: TObject);
begin
  DeleteToDoItem();
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
      FpjhToDoList.Delete(TodoGrid.SelectedRow);
    end;
  end;
end;

procedure TToDoListF2.EditToDoList(ARow: integer);
var
  LToDoDetailF: TToDoDetailF;
  LIdx: integer;
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

      SetTodoItemFromJson2Form(LJson);

      if LToDoDetailF.ShowModal = mrOK then
      begin
        LJson := GetTodoItem2JsonFromForm();
        LVar := _JSON(LJson);
        SetNxGridRowFromVar(TodoGrid, ARow, LVar);

        if LIsAdd then
        begin
          AddOrUpdateTodoItemRec2TodoListByJson(ARow, LJson);
        end;
      end;
    end;//with
  finally
    FreeAndNil(LToDoDetailF);
  end;//try
end;

procedure TToDoListF2.TodoGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  EditToDoList(TodoGrid.SelectedRow);
end;

end.
