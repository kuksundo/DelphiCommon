unit FrameTimedDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons;

type
  TFrame1 = class(TFrame)
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    FTitle,
    FContents: string;

    procedure Execute(Title, Contents: string);
  end;

implementation

{$R *.dfm}

procedure TFrame1.Execute(Title, Contents: string);
begin
  FTitle := Title;       // set the caption of the form
  FContents := Contents; // set the text of the memo
  Timer1.Enabled := True; // start the timer
  ShowModal;
end;

procedure TFrame1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False; // stop the timer
  ModalResult := mrOK;     // close the form
end;

end.
