unit FrmTimedDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    procedure Execute(Title, Contents: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
