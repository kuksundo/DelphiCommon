unit FrmLogIn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NxEdit, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
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
    CheckBox1: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
