unit UnitAdvCompUtil;

interface

uses System.Classes, System.SysUtils, WinApi.Windows, clipbrd, Vcl.StdCtrls,
  AdvEdBtn;

procedure ClipboardCopyOrPaste2AdvEditBtn(AEdit: TAdvEditBtn);

implementation

procedure ClipboardCopyOrPaste2AdvEditBtn(AEdit: TAdvEditBtn);
begin
  if AEdit.Text = '' then
    AEdit.Text := Clipboard.AsText
  else
    Clipboard.AsText := AEdit.Text;
end;

end.
