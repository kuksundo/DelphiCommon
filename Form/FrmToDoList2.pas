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

  UnitTodoCollect2, UnitToDoList
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
    ToDo_Code: TNxTextColumn;
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
    Mail1: TMenuItem;
    Create1: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N6: TMenuItem;
    Invoice4: TMenuItem;
    Invoice3: TMenuItem;
    InvoiceConfirm2: TMenuItem;
    N9: TMenuItem;
    N8: TMenuItem;
    N7: TMenuItem;
    N23: TMenuItem;
    oDOList1: TMenuItem;
    N22: TMenuItem;
    GetHullNoToClipboard1: TMenuItem;
    N1: TMenuItem;
    DeleteTask1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N10: TMenuItem;
    ShowTaskID1: TMenuItem;
    ShowEmailID1: TMenuItem;
    ShowGSFileID1: TMenuItem;
    GetJsonValues1: TMenuItem;
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
    AlarmType: TNxTextColumn;
    Alarm2Msg: TNxCheckBoxColumn;
    Alarm2Note: TNxCheckBoxColumn;
    Alarm2Email: TNxCheckBoxColumn;
    AlarmFlag: TNxCheckBoxColumn;
    AeroButton1: TAeroButton;
    procedure ClearBtnClick(Sender: TObject);
  private
    procedure AddTodoItem2Grid(AItemJson: RawUtf8);
  public
    FToDoCollect: TpjhToDoItemCollection;
    FpjhToDoList: TpjhToDoList;
  end;

  //ATaskId = TaskID
  //AIsDisplayComplete: True = 완료된(Complete = True) 것도 표시
  function Create_ToDoList_Frm2(ATaskId: TID; var AToDoList: TpjhToDoList;
    AIsDisplayComplete: Boolean = False) : integer;

var
  ToDoListF2: TToDoListF2;

implementation

uses UnitNextGridUtil2;

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

      for LpjhTodoItemRec in FpjhToDoList do
      begin
        if not AIsDisplayComplete then
          if LpjhTodoItemRec.Complete then
            Continue;

        LUtf8 := RecordSaveJson(LpjhTodoItemRec, TypeInfo(TpjhTodoItemRec));

        AddTodoItem2Grid(LUtf8);
      end;
    end;//with

  finally

  end;
end;

procedure TToDoListF2.AddTodoItem2Grid(AItemJson: RawUtf8);
var
  LDoc: Variant;
begin
  LDoc := _JSON(AItemJson);
  AddNextGridRowFromVariant(TodoGrid, LDoc);
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

end.
