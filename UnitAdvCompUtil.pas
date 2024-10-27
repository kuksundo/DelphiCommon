unit UnitAdvCompUtil;

interface

uses System.Classes, System.SysUtils, WinApi.Windows, clipbrd, Vcl.StdCtrls,
  AdvEdBtn;

procedure ClipboardCopyOrPaste2AdvEditBtn(AEdit: TCustomEdit; AIsPaste: Boolean=False);

implementation

uses UnitKeyBdUtil;

procedure ClipboardCopyOrPaste2AdvEditBtn(AEdit: TCustomEdit; AIsPaste: Boolean);
begin
  if AEdit.Text = '' then
    AEdit.Text := Clipboard.AsText
  else
    Clipboard.AsText := AEdit.Text;

  if AIsPaste then
    SendCtlNChar('V');
end;

end.
