unit FrmEthernetAdaptorList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, AdvMenus, NxColumns,
  NxColumnClasses, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Vcl.StdCtrls, Vcl.Buttons, AdvToolBtn, Vcl.ExtCtrls,
  mormot.core.variants, mormot.core.unicode, mormot.core.collections,
  mormot.core.base
  ;

type
  TEthAdaptorListRec = packed record
    AdaptorName,
    IPAddr,
    SubnetMask,
    Gateway,
    DESCRIPTION
    : string;
  end;

  TEtherAdaptorF = class(TForm)
    Panel1: TPanel;
    AdvToolButton1: TAdvToolButton;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    EthAdaptorGrid: TNextGrid;
    FriendlyName: TNxTextColumn;
    SubnetMask: TNxTextColumn;
    GateWayAddr: TNxTextColumn;
    IpAddr: TNxTextColumn;
    Description: TNxTextColumn;
    MadAddr: TNxTextColumn;
    AdapterName: TNxTextColumn;
    procedure FormCreate(Sender: TObject);
    procedure EthAdaptorGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure AdvToolButton1Click(Sender: TObject);
  private
    FEthAdaptorDic: IKeyValue<string, TEthAdaptorListRec>;

    function GetJsonAryFromEthAdaptorDic(AEthAdaptorDic: IKeyValue<string, TEthAdaptorListRec>): string;
    procedure SetEthAdaptorList2GridFromJsonAry(const AJsonAry: string);
    function GetEthAdaptor2JsonFromGrid(const ASelectedOnly: Boolean=False): string;

    procedure SetEthAdaptorList2GridFromIPHelper();
  public
    { Public declarations }
  end;

function ShowEthernetAdaptorListForm(var AJson: string): integer;

implementation

uses UnitNextGridUtil2, UnitIpHelper, UnitLanUtil2;

{$R *.dfm}

function ShowEthernetAdaptorListForm(var AJson: string): integer;
var
  LEtherAdaptorF: TEtherAdaptorF;
  LJson: string;
  LList: IList<TEthAdaptorListRec>;
  LRec: TEthAdaptorListRec;
begin
  LEtherAdaptorF := TEtherAdaptorF.Create(nil);
  try
    with LEtherAdaptorF do
    begin
      if AJson <> '' then
      begin
        FEthAdaptorDic.Data.LoadFromJson(StringToUtf8(AJson));
        LJson := Utf8ToString(GetJsonAryFromEthAdaptorDic(FEthAdaptorDic));
        SetEthAdaptorList2GridFromJsonAry(LJson);
      end;

      Result := ShowModal;

      if Result = mrOK then //OK Button�� ������ ���� ���� ���
      begin
      end
      else
      if Result = mrYes then //Grid�� Double Click�Ͽ� ���� ���� ���
      begin
        AJson := GetEthAdaptor2JsonFromGrid(True);
        //Network Setting â�� open��
        OpenNetworkConnectionsUsingCPL();
      end;
    end;
  finally
    LEtherAdaptorF.Free;
  end;
end;

procedure TEtherAdaptorF.AdvToolButton1Click(Sender: TObject);
begin
  SetEthAdaptorList2GridFromIPHelper();
end;

procedure TEtherAdaptorF.EthAdaptorGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  ModalResult := mrYes;
end;

procedure TEtherAdaptorF.FormCreate(Sender: TObject);
begin
  FEthAdaptorDic := Collections.NewKeyValue<string, TEthAdaptorListRec>;
end;

function TEtherAdaptorF.GetEthAdaptor2JsonFromGrid(
  const ASelectedOnly: Boolean): string;
var
  LVar: variant;
begin
  LVar := NextGrid2Variant(EthAdaptorGrid, False, True, ASelectedOnly);
  Result := Utf8ToString(LVar);
end;

function TEtherAdaptorF.GetJsonAryFromEthAdaptorDic(AEthAdaptorDic: IKeyValue<string, TEthAdaptorListRec>): string;
var
  LEthAdaptorList: IList<TEthAdaptorListRec>;
  i: integer;
begin
  Result := '';
  LEthAdaptorList := Collections.NewList<TEthAdaptorListRec>;

  for i := 0 to AEthAdaptorDic.Count - 1 do
  begin
    LEthAdaptorList.Add(AEthAdaptorDic.Value[i]);
  end;

  Result := LEthAdaptorList.Data.SaveToJson();
end;

procedure TEtherAdaptorF.SetEthAdaptorList2GridFromIPHelper;
var
  LJsonAry: string;
  LAdaptorList: IDocList;
  LDocDict: IDocDict;
  LEthAdaptorRec: TEthAdaptorRec;
  LRow, i: integer;
begin
  LJsonAry := '';
  GetEthernetAdapters(LJsonAry, True);

  if LJsonAry <> '' then
  begin
    EthAdaptorGrid.BeginUpdate;
    EthAdaptorGrid.ClearRows;
    try
      LAdaptorList := DocList(LJsonAry);

//      for LDocDict in LAdaptorList.Objects do
      for i := 0 to LAdaptorList.Len - 1 do
      begin
        LJsonAry := LAdaptorList.S[i];
        LDocDict := DocDict(LJsonAry);
        LRow := EthAdaptorGrid.AddRow();
        EthAdaptorGrid.CellsByName['FriendlyName', LRow] := LDocDict.S['FriendlyName'];
        EthAdaptorGrid.CellsByName['AdapterName', LRow] := LDocDict.S['AdapterName'];
        EthAdaptorGrid.CellsByName['IpAddr', LRow] := LDocDict.S['IPAddrList'];
        EthAdaptorGrid.CellsByName['MadAddr', LRow] := LDocDict.S['MadAddr'];
        EthAdaptorGrid.CellsByName['Description', LRow] := LDocDict.S['Description'];
      end;
    finally
      EthAdaptorGrid.EndUpdate();
    end;
  end;

  ShowMessage(LJsonAry);
end;

procedure TEtherAdaptorF.SetEthAdaptorList2GridFromJsonAry(
  const AJsonAry: string);
var
  LVar: variant;
begin
  LVar := _JSON(StringToUtf8(AJsonAry));

  if EthAdaptorGrid.RowCount > 0 then
  begin
    if MessageDlg('���� Data�� �߰��ұ��?' + #13#10 +
      '"No" �� �����ϸ� ����⸦ �մϴ�.' , mtConfirmation, [mbYes, mbNo],0) = mrNo then
      EthAdaptorGrid.ClearRows;
  end;

  AddNextGridRowsFromVariant2(EthAdaptorGrid, LVar);
end;

end.
