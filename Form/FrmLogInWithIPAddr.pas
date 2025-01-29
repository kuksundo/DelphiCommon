unit FrmLogInWithIPAddr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvComCtrls,
  NxEdit, Vcl.Buttons, Vcl.ExtCtrls;

type
  TLogInWithIPAddrF = class(TForm)
    JvIPAddress1: TJvIPAddress;
    PortNumEdit: TEdit;
    Panel2: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel10: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    UserID: TNxEdit;
    Panel3: TPanel;
    Panel7: TPanel;
    PassWD: TNxEdit;
    Label14: TLabel;
    Label15: TLabel;
    DBNameLabel: TLabel;
    DBNameEdit: TEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    fModalResult : TModalResult;

    class function Execute(var AUserID, APasswd, AIPAddr, APortNo, ADBName: string; AUseDBName: Boolean) : TModalResult;
  end;

var
  LogInWithIPAddrF: TLogInWithIPAddrF;

implementation

{$R *.dfm}

procedure TLogInWithIPAddrF.BitBtn1Click(Sender: TObject);
begin
  fModalResult := mrOK;
end;

procedure TLogInWithIPAddrF.BitBtn2Click(Sender: TObject);
begin
  fModalResult := mrCancel;
end;

class function TLogInWithIPAddrF.Execute(var AUserID, APasswd,
  AIPAddr, APortNo, ADBName: string; AUseDBName: Boolean): TModalResult;
var
  LLogin: TLogInWithIPAddrF;
begin
  LLogin := TLogInWithIPAddrF.Create(nil);

  with LLogin do
  begin
    try
      UserID.Text := AUserID;
      PassWD.Text := APassWd;
      JvIPAddress1.Text := AIPAddr;
      PortNumEdit.Text := APortNo;
      DBNameEdit.Text := ADBName;

      DBNameLabel.Visible := AUseDBName;
      DBNameEdit.Visible := AUseDBName;

      ShowModal;

      Result := fModalResult;

      AUserID := UserID.Text;
      APassWd := PassWD.Text;
      AIPAddr := JvIPAddress1.Text;
      APortNo := PortNumEdit.Text;
      ADBName := DBNameEdit.Text;
    finally
      FreeAndNil(LLogin);
    end;
  end;
end;

end.
