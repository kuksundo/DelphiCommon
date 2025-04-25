unit UnitMenuItemUtil;

interface

uses Vcl.Menus;

procedure SetMenuItemEnableByCaption(const ARootMenuItem: TMenuItem; const ACaption: string);

implementation

procedure SetMenuItemEnableByCaption(const ARootMenuItem: TMenuItem; const ACaption: string);
var
  LMenuItem: TMenuItem;
begin
  if not Assigned(ARootMenuItem) then
    exit;

  LMenuItem := ARootMenuItem.Find(ACaption);

  if Assigned(LMenuItem) then
    LMenuItem.Enabled := True;
end;

end.
