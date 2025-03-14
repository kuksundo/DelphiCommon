unit FrmNextGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGroupBox,
  AdvOfficeButtons, Vcl.ExtCtrls, Vcl.Buttons,
  ArrayHelper, UnitCheckGrpAdvUtil, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid,
  mormot.core.base, mormot.core.variants, mormot.core.collections;

type
  TNextGridF = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Label1: TLabel;
    NextGrid1: TNextGrid;
  private
  public
    procedure SetDocList2Grid(ADocList: string);
    procedure SetNextGridColumnByJsonList(const AColList: string);//["a","b",...]
  end;

  //ADocList: array of array = [[column name list,],[value1,],[value2,]...]
  function CreateNextGridForm(const ACaption, ALabel, ADocList: string): string;

var
  NextGridF: TNextGridF;

implementation

uses UnitNextGridUtil2;

{$R *.dfm}

function CreateNextGridForm(const ACaption, ALabel, ADocList: string): string;
begin
  Result := '';

  if Assigned(NextGridF) then
    FreeAndNil(NextGridF);

  NextGridF := TNextGridF.Create(nil);
  try
    with NextGridF do
    begin
      Caption := ACaption;
      Label1.Caption := ALabel;

      SetDocList2Grid(ADocList);

      if ShowModal = mrOK then
      begin
      end;
    end;
  finally
    FreeAndNil(NextGridF);
  end;
end;

{ TNextGridF }

procedure TNextGridF.SetDocList2Grid(ADocList: string);
var
  LList, LList2: IDocList;
  Lvar, LVar2: variant;
  LUtf8: RawUtf8;
  LRow: integer;
begin
  ADocList := StringReplace(ADocList, ' ', '', [rfReplaceAll]);

  LList := DocList(ADocList);

  NextGrid1.BeginUpdate;
  try
    for Lvar in LList do
    begin
      LUtf8 := LVar;
      LList2 := DocList(LUtf8);

      LVar2 := LList2.Pop(0);

      if VarIsNull(LVar2) then
        Break;

      if NextGrid1.Columns.Count = 0 then
      begin
        SetNextGridColumnByJsonList(LUtf8);//["a","b",...]
        Continue;
      end;

      AddNextGridRowFromJsonAry(NextGrid1, LUtf8);

//      LRow := NextGrid1.AddRow();
//
//      NextGrid1.CellsByName['IPAddr', LRow] := AIpAddr;
//      NextGrid1.CellsByName['Ch', LRow] := LVar2;
//      NextGrid1.CellsByName['Ftype', LRow] := LList2.Pop(0);
//      NextGrid1.CellsByName['filter', LRow] := LList2.Pop(0);
//      NextGrid1.CellsByName['offset', LRow] := LList2.Pop(0);
//      NextGrid1.CellsByName['slope', LRow] := LList2.Pop(0);
//      NextGrid1.CellsByName['sf_low', LRow] := LList2.Pop(0);
//      NextGrid1.CellsByName['sf_high', LRow] := LList2.Pop(0);
//      NextGrid1.CellsByName['tag', LRow] := LList2.Pop(0);
//      NextGrid1.CellsByName['value', LRow] := LList2.Pop(0);
    end;
  finally
    NextGrid1.EndUpdate();
  end;
end;

procedure TNextGridF.SetNextGridColumnByJsonList(const AColList: string);
begin
  AddNextGridTextColumnFromJsonAry(NextGrid1, AColList);
end;

end.
