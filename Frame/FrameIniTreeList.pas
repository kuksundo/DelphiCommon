unit FrameIniTreeList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, TreeList, Vcl.Buttons, TimerPool;

type
  TIniTreeListFr = class(TFrame)
    Panel2: TPanel;
    SearchEdit: TEdit;
    Panel3: TPanel;
    SectionRB: TRadioButton;
    NameRB: TRadioButton;
    DescRB: TRadioButton;
    TreeList1: TTreeList;
    BitBtn1: TBitBtn;
    procedure SearchEditChange(Sender: TObject);
    procedure SearchEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure TreeList1DblClick(Sender: TObject);
  private
    FNthStart,
    FLongestWidth: integer;
    FPJHTimerPool: TPJHTimerPool;

    procedure OnSearchEditChange(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    function GetNodeFromSelected(): TTreeNode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SearchAndFocusItemsFromTxt();
  end;

implementation

uses UnitTreeListUtil, UnitStringUtil, FrmInputEdit;

{$R *.dfm}

{ TIniTreeListFr }

procedure TIniTreeListFr.BitBtn1Click(Sender: TObject);
begin
  OnSearchEditChange(Sender, 0, 0, 0);
end;

constructor TIniTreeListFr.Create(AOwner: TComponent);
begin
  inherited;

  FNthStart := 0;

  if not Assigned(FPJHTimerPool) then
    FPJHTimerPool := TPJHTimerPool.Create(nil);
end;

destructor TIniTreeListFr.Destroy;
begin
  if Assigned(FPJHTimerPool) then
  begin
    FPJHTimerPool.RemoveAll;
    FreeAndNil(FPJHTimerPool);
  end;

  inherited;
end;

function TIniTreeListFr.GetNodeFromSelected: TTreeNode;
var
  i: integer;
begin
  Result := nil;

  for i := 0 to TreeList1.Items.Count - 1 do
  begin
    Result := TreeList1.Items[i];

    if Result.Selected then
      Break;
  end;
end;

procedure TIniTreeListFr.OnSearchEditChange(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  SearchAndFocusItemsFromTxt();
end;

procedure TIniTreeListFr.SearchAndFocusItemsFromTxt;
var
  LIdx, LNthSrch: integer;
begin
  if SectionRB.Checked then
    LIdx := 0
  else
  if NameRB.Checked then
    LIdx := 0
  else
  if DescRB.Checked then
    LIdx := 1;

  LNthSrch := FindAndFocusTreeListFromTxt(SearchEdit.Text, LIdx, FNthStart, TreeList1);

  if LNthSrch < FNthStart then
  begin
    FnthStart := 1;
    ShowMessage('더 이상 없습니다.');
  end
  else
    Inc(FNthStart);
end;

procedure TIniTreeListFr.SearchEditChange(Sender: TObject);
begin
  FNthStart := 1;
  FPJHTimerPool.AddOneShot(OnSearchEditChange,500);
end;

procedure TIniTreeListFr.SearchEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    OnSearchEditChange(Sender, 0, 0, 0);
end;

procedure TIniTreeListFr.TreeList1DblClick(Sender: TObject);
var
  LTreeNode: TTreeNode;
  LResult, LCaption, LLabel, LDefault: string;
begin
  LTreeNode := GetNodeFromSelected();

  if Assigned(LTreeNode) then
  begin
    if LTreeNode.Level = 0 then
    exit;

    LResult := LTreeNode.Text;
    LLabel := StrToken(LResult, ';');
    LDefault := StrToken(LResult, ';');

    if Assigned(LTreeNode.Parent) then
      LCaption := LTreeNode.Parent.Text
    else
      LCaption := LTreeNode.Text;

    LResult := CreateInputEdit(LCaption, LLabel, LDefault);

    if LResult <> '' then
    begin
      LTreeNode.Text := LLabel + ';' + LResult;
    end;
  end;
end;

end.
