unit FrmSelectRadioBtn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, JvExControls,
  JvLabel, Vcl.ExtCtrls,
  UnitCommonRec4Form;

type
  TSelectRGF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    RG1: TRadioGroup;
    Label1: TLabel;
  private
    { Private declarations }
  public
    procedure LoadList2RG(const AItemList: string);
  end;

  //AItemList : ';'로 구분된 Item List
  function CreateNShowSelectRadioBtnForm(const AItemList: string;
    var ASelectedIndex: integer;
    const ACaption: string=''; const ALabel: string='';
    const AColumns: integer=1): integer;

var
  SelectRGF: TSelectRGF;

implementation

{$R *.dfm}

function CreateNShowSelectRadioBtnForm(const AItemList: string;
  var ASelectedIndex: integer;
  const ACaption: string; const ALabel: string;
  const AColumns: integer): integer;
var
  i: integer;
begin
  with TSelectRGF.Create(nil) do
  begin
    if ACaption <> '' then
      Caption := ACaption;

    if ALabel <> '' then
      Label1.Caption := ALabel;

    //RadioGroup에 ItemList 설정
    LoadList2RG(AItemList);

    RG1.Columns := AColumns;
    RG1.ItemIndex := ASelectedIndex;

    Result := ShowModal;

    if Result = mrOK then
    begin
      ASelectedIndex := RG1.ItemIndex;
    end;

    Free;
  end;
end;

{ TSelectRGF }

procedure TSelectRGF.LoadList2RG(const AItemList: string);
var
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Delimiter := ';';
    LstrList.Text := AItemList;

    RG1.Items.Assign(LstrList);
  finally
    LStrList.Free;
  end;
end;

end.
