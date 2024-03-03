unit FrmDateSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, JvExControls, JvLabel;

type
  TDateSelectF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DateTimePicker1: TDateTimePicker;
    JvLabel5: TJvLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function CreateNShowDateSeletForm(var ADate: TDate;
    const ACaption: string=''; const ALabel: string=''): string;
var
  DateSelectF: TDateSelectF;

implementation

{$R *.dfm}

function CreateNShowDateSeletForm(var ADate: TDate;
    const ACaption: string=''; const ALabel: string=''): string;
begin
  Result := '';

  with TDateSelectF.Create(nil) do
  begin
    if ACaption <> '' then
      Caption := ACaption;

    if ALabel <> '' then
      JvLabel5.Caption := ALabel;

    DateTimePicker1.Date := ADate;

    if ShowModal = mrOK then
    begin
      ADate := DateTimePicker1.Date;
      Result := FormatDateTime('yyyymmdd', ADate);
    end;

    Free;
  end;
end;

end.
