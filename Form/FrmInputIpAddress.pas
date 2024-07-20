unit FrmInputIpAddress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, JvExControls, JvLabel, JvComCtrls;

type
  TIPAddrInputF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    JvLabel5: TJvLabel;
    IPAddress: TJvIPAddress;
    JvLabel1: TJvLabel;
    Port: TEdit;
    JvLabel2: TJvLabel;
    IPName: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function ShowInputIPAddressForm(var AIp, APort, AName: string;
      const ACaption: string=''; const ALabel: string=''): integer;
var
  IPAddrInputF: TIPAddrInputF;

implementation

{$R *.dfm}

function ShowInputIPAddressForm(var AIp, APort, AName: string;
    const ACaption: string=''; const ALabel: string=''): integer;
begin
  with TIPAddrInputF.Create(nil) do
  begin
    if ACaption <> '' then
      Caption := ACaption;

    if ALabel <> '' then
      JvLabel5.Caption := ALabel;

    IPAddress.Text := AIp;
    Port.Text := APort;
    IPName.Text := AName;

    Result := ShowModal;

    if Result = mrOK then
    begin
      AIp := IPAddress.Text;
      APort := Port.Text;
      AName := IPName.Text;
    end;

    Free;
  end;
end;

end.
