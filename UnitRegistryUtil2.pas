unit UnitRegistryUtil2;

interface

uses System.SysUtils, Winapi.Windows, Registry, Winapi.Messages, System.Classes,
  Math, mormot.core.collections, mormot.core.variants;

function IsAppInstalledFromRegistry(const ExeName: string): Boolean;

implementation

function IsAppInstalledFromRegistry(const ExeName: string): Boolean;
const
  REG_PATH = '\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\';
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    // 64bit Registry
    Reg.Access := KEY_READ or KEY_WOW64_64KEY;
    if Reg.OpenKeyReadOnly(REG_PATH + ExeName) then
    begin
      Result := True;
      Exit;
    end;

    // 32bit Registry
    Reg.Access := KEY_READ or KEY_WOW64_32KEY;
    if Reg.OpenKeyReadOnly(REG_PATH + ExeName) then
    begin
      Result := True;
      Exit;
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

end.
