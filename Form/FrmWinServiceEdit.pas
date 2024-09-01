unit FrmWinServiceEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  mormot.core.variants, mormot.core.unicode,

  uServiceManager, SvcUtils.Types, SvcUtils.IntF;

type
  TWinServiceEditF = class(TForm)
    Image1: TImage;
    ServiceName: TLabel;
    DisplayName: TLabel;
    BinaryPath: TLabel;
    StartType: TComboBox;
    Status: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Description: TMemo;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FServiceInfo: ISvcInfo;
  public
    procedure LoadSvcData2FormFromJson(ASvcJson: string);
    function GetSvcDataJsonFromForm: string;

    procedure RefreshForm();
  end;

  function ShowWinServiceEditForm(ASvcJson: string): integer;

var
  WinServiceEditF: TWinServiceEditF;

implementation

uses FrmElapsedTime,
  UnitServiceUtil;

{$R *.dfm}

function ShowWinServiceEditForm(ASvcJson: string): integer;
begin
  with TWinServiceEditF.Create(nil) do
  begin
    try
      LoadSvcData2FormFromJson(ASvcJson);

      Result := ShowModal();

      if Result = mrOK then
      begin

      end;
    finally
      Free;
    end;
  end;
end;

{ TWinServiceEditF }

procedure TWinServiceEditF.Button1Click(Sender: TObject);
begin
  ShowElapsedTimeForm();
  FServiceInfo.ServiceStart(True);
  ElapsedTimeF.Close;
end;

procedure TWinServiceEditF.Button2Click(Sender: TObject);
begin
  FServiceInfo.ServiceStop(True);
end;

procedure TWinServiceEditF.Button3Click(Sender: TObject);
begin
  FServiceInfo.ServicePause(True);
end;

procedure TWinServiceEditF.Button4Click(Sender: TObject);
begin
  FServiceInfo.ServiceContinue(True);
end;

procedure TWinServiceEditF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(ElapsedTimeF) then
    FreeAndNil(ElapsedTimeF);
end;

function TWinServiceEditF.GetSvcDataJsonFromForm: string;
begin

end;

procedure TWinServiceEditF.LoadSvcData2FormFromJson(ASvcJson: string);
var
  LVar: variant;
  LServiceState: TServiceState;
begin
  TDocVariantData(LVar).InitJson(StringToUtf8(ASvcJson));
  ServiceName.Caption := LVar.ServiceName;
  DisplayName.Caption := LVar.DisplayName;
  BinaryPath.Caption := LVar.BinaryPath;
  LServiceState := TServiceState(LVar.Status);
  Status.Caption := LServiceState.ToString;
  StartType.ItemIndex := LVar.StartType;
  Description.Lines.Text := LVar.Description;

  FServiceInfo := GetServiceInfoByName(ServiceName.Caption);
end;

procedure TWinServiceEditF.RefreshForm;
var
  LServiceState: TServiceState;
  LJson: string;
begin
  LJson := GetServiceInfo2JsonByName(FServiceInfo.ServiceName);
  LoadSvcData2FormFromJson(LJson);
end;

end.
