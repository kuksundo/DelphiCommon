unit UnitDialogUtil;

interface

uses
  Winapi.Windows, System.Classes, Vcl.Dialogs, Winapi.Messages, Vcl.Consts,
  System.SysUtils;

function GetFileNameFromDialog(AInitDir: string = ''; AFilter: string= ''): string;
function GetFilterFromFileExt(AFileExt: string; AIncludeAllFileFilter: Boolean=False): string;
function GetFileNameFromSaveDialog(AInitDir: string = ''; AFilter: string= ''): string;
function MessageDlgTimed(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; AClosePeriod: integer=3000): Integer;

implementation

function GetFileNameFromDialog(AInitDir: string; AFilter: string): string;
var
  LDialog: TOpenDialog;
begin
  Result := '';

  LDialog := TOpenDialog.Create(nil);
  try
    if AInitDir <> '' then
      LDialog.InitialDir := AInitDir;

    if AFilter <> '' then
      LDialog.Filter := AFilter;

    if LDialog.Execute() then
    begin
      Result := LDialog.FileName;
    end;

  finally
    LDialog.Free;
  end;
end;

function GetFilterFromFileExt(AFileExt: string; AIncludeAllFileFilter: Boolean): string;
begin
  Result := '';

  if UpperCase(AFileExt) = '*' then
    Result := 'All files|*.*'
  else
  if UpperCase(AFileExt) = 'XLS' then
    Result := 'Excel file|*.xls|Excel file2|*.xlsx'
  else
  if UpperCase(AFileExt) = 'PPT' then
    Result := 'Ppt file|*.ppt|Ppt file2|*.pptx'
  else
  if UpperCase(AFileExt) = 'DOC' then
    Result := 'Word file|*.doc|Word file2|*.docx';

  if AIncludeAllFileFilter then
    Result := Result + '|All files|*.*';
end;

function GetFileNameFromSaveDialog(AInitDir: string = ''; AFilter: string= ''): string;
var
  LDialog: TSaveDialog;
begin
  Result := '';

  LDialog := TSaveDialog.Create(nil);
  try
    if AInitDir <> '' then
      LDialog.InitialDir := AInitDir;

    if AFilter <> '' then
      LDialog.Filter := AFilter;

    if LDialog.Execute() then
    begin
      Result := LDialog.FileName;
    end;

  finally
    LDialog.Free;
  end;
end;

function HookResourceString(ResStringRec: pResStringRec; NewStr: pChar) : integer ;
var
  OldProtect: DWORD;
begin
  VirtualProtect(ResStringRec, SizeOf(ResStringRec^), PAGE_EXECUTE_READWRITE, @OldProtect) ;
  result := ResStringRec^.Identifier;
  ResStringRec^.Identifier := Integer(NewStr) ;
  VirtualProtect(ResStringRec, SizeOf(ResStringRec^), OldProtect, @OldProtect) ;
end;

procedure UnHookResourceString(ResStringRec: pResStringRec; oldData: integer);
var
  OldProtect: DWORD;
begin
  VirtualProtect(ResStringRec, SizeOf(ResStringRec^), PAGE_EXECUTE_READWRITE, @OldProtect) ;
  ResStringRec^.Identifier := oldData ;
  VirtualProtect(ResStringRec, SizeOf(ResStringRec^), OldProtect, @OldProtect) ;
end;

function MessageDlgTimed(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; AClosePeriod: integer): Integer;
const
//  closePeriod = 2 * 1000;
  tickPeriod = 250;
var
  timerCloseId, timerTickId: UINT_PTR;
  r : integer;
  peekMsg : TMsg;

  procedure CloseMessageDlgCallback(AWnd: HWND; AMsg: UINT; AIDEvent: UINT_PTR; ATicks: DWORD); stdcall;
  var
    activeWnd: HWND;
  begin
    KillTimer(AWnd, AIDEvent);

    activeWnd := GetActiveWindow;

    if IsWindow(activeWnd) AND IsWindowEnabled(activeWnd) then
      PostMessage(activeWnd, WM_CLOSE, 0, 0);
  end; (*CloseMessageDlgCallback*)

  procedure PingMessageDlgCallback(AWnd: HWND; AMsg: UINT; AIDEvent: UINT_PTR; ATicks: DWORD); stdcall;
  var
    activeWnd: HWND;
    wCaption : string;
    wCaptionLength : integer;
  begin
    activeWnd := GetActiveWindow;
    if IsWindow(activeWnd) AND IsWindowEnabled(activeWnd) AND IsWindowVisible(activeWnd) then
    begin
      wCaptionLength := GetWindowTextLength(activeWnd);
      SetLength(wCaption, wCaptionLength);
      GetWindowText(activeWnd, PChar(wCaption), 1 + wCaptionLength);
      SetWindowText(activeWnd, Copy(wCaption, 1, -1 + Length(wCaption)));
    end
    else
      KillTimer(AWnd, AIDEvent);
  end; (*PingMessageDlgCallback*)
begin
  if (DlgType = mtInformation) AND ([mbOK] = Buttons) then
  begin
    timerCloseId := SetTimer(0, 0, AClosePeriod, @CloseMessageDlgCallback);

    if timerCloseId <> 0 then
    begin
      timerTickId := SetTimer(0, 0, tickPeriod, @PingMessageDlgCallback);

      if timerTickId <> 0 then
        r := HookResourceString(@SMsgDlgInformation, PChar(SMsgDlgInformation + ' ' + StringOfChar('.', AClosePeriod div tickPeriod)));
    end;

    result := MessageDlg(Msg, DlgType, Buttons, HelpCtx);

    if timerTickId <> 0 then
    begin
      KillTimer(0, timerTickId);
      UnHookResourceString(@SMsgDlgInformation, r);
    end;

    if timerCloseId <> 0 then
      KillTimer(0, timerCloseId);
  end
  else
    result := MessageDlg(Msg, DlgType, Buttons, HelpCtx);
end;

end.
