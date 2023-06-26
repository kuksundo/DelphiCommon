unit UnitPanelUtil;

interface

Uses SysUtils, Windows, Vcl.Controls, Vcl.ExtCtrls;

procedure SetEnableComponentsOnPanel(APanel: TPanel; AEnable: Boolean);

implementation

procedure SetEnableComponentsOnPanel(APanel: TPanel; AEnable: Boolean);
var
  i: integer;
begin
  for i := 0 to APanel.ControlCount - 1 do
  begin
    if APanel.Controls[i] is TWinControl then
      TControl(APanel.Controls[i]).Enabled := AEnable;
  end;
end;

end.
