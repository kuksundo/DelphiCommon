unit FrmTwoInputEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TTwoInputEditF = class(TForm)
    Label1: TLabel;
    InputEdit: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    InputEdit2: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function CreateTwoInputEdit(const ACaption, ALabel, ADefault, ALabel2, ADefault2: string): string;
var
  TwoInputEditF: TTwoInputEditF;

implementation

{$R *.dfm}

function CreateTwoInputEdit(const ACaption, ALabel, ADefault, ALabel2, ADefault2: string): string;
begin
  Result := '';

  if Assigned(TwoInputEditF) then
    FreeAndNil(TwoInputEditF);

  TwoInputEditF := TTwoInputEditF.Create(nil);
  try
    with TwoInputEditF do
    begin
      Caption := ACaption;
      Label1.Caption := ALabel;
      InputEdit.Text := ADefault;
      Label2.Caption := ALabel2;
      InputEdit2.Text := ADefault2;

      if ShowModal = mrOK then
      begin
        Result := InputEdit.Text + ';' + InputEdit2.Text;
      end;
    end;
  finally
    FreeAndNil(TwoInputEditF);
  end;
end;

end.
