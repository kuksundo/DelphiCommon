unit UnitWindowUtil;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils;

function GetHandleByGlobalFocus(): THandle;
function IsControlDisabledByHandle(AHwnd: HWND): Boolean;
function IsClassNameByHandle(AHwnd: HWND; AClassName: string): Boolean;

implementation

function GetHandleByGlobalFocus(): THandle;
var
  GUIThreadInfo: TGUIThreadInfo;
begin
  GUIThreadInfo.cbSize := SizeOf(TGUIThreadInfo);

  if GetGUIThreadInfo(0, GUIThreadInfo) then
    Result := GUIThreadInfo.hwndFocus
  else
    Result := 0;
end;

function IsControlDisabledByHandle(AHwnd: HWND): Boolean;
var
  LStyle: LongInt;
begin
  LStyle := GetWindowLong(AHwnd, GWL_STYLE);
  Result := (LStyle and WS_DISABLED) <> 0;
end;

function IsClassNameByHandle(AHwnd: HWND; AClassName: string): Boolean;
var
  LClsName: array [0..255] of char;
begin
  GetClassName(AHwnd, LClsName, 255);

  Result := LClsName = AClassName;
end;

end.
