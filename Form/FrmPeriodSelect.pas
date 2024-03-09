unit FrmPeriodSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  JvExControls, JvLabel, Vcl.ExtCtrls;

type
  TPeriodSelectF = class(TForm)
    Panel1: TPanel;
    JvLabel5: TJvLabel;
    DateTimePicker1: TDateTimePicker;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function CreateNShowPeriodSeletForm(var ADate1, ADate2: TDate;
    const ACaption: string=''; const ALabel: string=''): string;

var
  PeriodSelectF: TPeriodSelectF;

implementation

{$R *.dfm}

function CreateNShowPeriodSeletForm(var ADate1, ADate2: TDate;
  const ACaption: string=''; const ALabel: string=''): string;
begin
  Result := '';

  with TPeriodSelectF.Create(nil) do
  begin
    if ACaption <> '' then
      Caption := ACaption;

    if ALabel <> '' then
      JvLabel5.Caption := ALabel;

    DateTimePicker1.Date := ADate1;
    DateTimePicker2.Date := ADate2;

    if ShowModal = mrOK then
    begin
      ADate1 := DateTimePicker1.Date;
      ADate2 := DateTimePicker2.Date;
      Result := FormatDateTime('yyyymmdd', ADate1) + ';' + FormatDateTime('yyyymmdd', ADate2);
    end;

    Free;
  end;
end;

end.
