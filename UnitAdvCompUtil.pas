unit UnitAdvCompUtil;

interface

uses System.Classes, System.SysUtils, WinApi.Windows, clipbrd, Vcl.StdCtrls,
  AdvEdBtn;

procedure ClipboardCopyOrPaste2AdvEditBtn(AEdit: TCustomEdit);

implementation

procedure ClipboardCopyOrPaste2AdvEditBtn(AEdit: TCustomEdit);
begin
  if AEdit.Text = '' then
    AEdit.Text := Clipboard.AsText
  else
    Clipboard.AsText := AEdit.Text;
end;

end.
