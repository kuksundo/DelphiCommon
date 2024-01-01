unit UnitProcessManager;

interface

uses
  Windows, System.SysUtils, TlHelp32,
  Spring, Spring.Collections;

type
  TProcessInfo = class
  private
    FExeNameWithPath: string;
    FPID: string;
    FPriority: string;
    FThread: string;
  public
    constructor Create(aExeName: string; aPID: string; aPriority: string; aThread: string);

    property ExeNameWithPath: string read FExeNameWithPath write FExeNameWithPath;
    property PID: string read FPID write FPID;
    property Priority: string read FPriority write FPriority;
    property Thread: string read FThread write FThread;
  end;

  TProcessManager = class(TObject)
  private
  public
    FProcessInfoList: IList<TProcessInfo>;

    constructor Create;

    procedure ListProcesses;
    procedure KillProcessByPID(PID: string);
    procedure KillProcessByExePath(ExePath: string);
  end;

implementation

function SetTokenPrivileges: Boolean;
var
  hToken1, hToken2, hToken3: THandle;
  TokenPrivileges: TTokenPrivileges;
  Version: OSVERSIONINFO;
  ReturnLength: DWord;
begin
  Version.dwOSVersionInfoSize := SizeOf(OSVERSIONINFO);
  GetVersionEx(Version);

  if Version.dwPlatformId <> VER_PLATFORM_WIN32_WINDOWS then
  begin
    try
      OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, hToken1);
      hToken2 := hToken1;

      if LookupPrivilegeValue(nil, 'SeDebugPrivilege', TokenPrivileges.Privileges[0].luid) then
      begin
        TokenPrivileges.PrivilegeCount := 1;
        TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        hToken3 := 0;
        Result := AdjustTokenPrivileges(hToken1, False, TokenPrivileges, 0, nil, ReturnLength);//PTokenPrivileges(nil)^
//        TokenPrivileges.PrivilegeCount := 1;
//        TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
//        hToken3 := 0;
//        AdjustTokenPrivileges(hToken2, False, TokenPrivileges, 0, nil, ReturnLength);//PTokenPrivileges(nil)^
      end;

      CloseHandle(hToken1);
    except;
    end;
  end;
end;

function Split(Input: string; Deliminator: string; Index: integer): string;
var
  StringLoop, StringCount: integer;
  Buffer: string;
begin
  StringCount := 0;
  for StringLoop := 1 to Length(Input) do
  begin
    if (Copy(Input, StringLoop, 1) = Deliminator) then
    begin
      Inc(StringCount);
      if StringCount = Index then
      begin
        Result := Buffer;
        Exit;
      end
      else
      begin
        Buffer := '';
      end;
    end
    else
    begin
      Buffer := Buffer + Copy(Input, StringLoop, 1);
    end;
  end;
  Result := Buffer;
end;

constructor TProcessManager.Create;
begin
  inherited Create;

  FProcessInfoList := TCollections.CreateObjectList<TProcessInfo>(True);
  SetTokenPrivileges;
end;

procedure TProcessManager.ListProcesses;
var
  Process32: TProcessEntry32;
  Module32: TModuleEntry32;
  ProcessSnapshot: THandle;
  ModuleSnapshot: THandle;
  SystemDirectory: array[0..261] of char;
  LProcessInfo: TProcessInfo;
  LExePath, LPid, LThread, LPriority: string;
begin
  if Assigned(FProcessInfoList) then
    FProcessInfoList.Clear;

  GetWindowsDirectory(@SystemDirectory, 261);
  ProcessSnapshot := CreateToolHelp32SnapShot(TH32CS_SNAPALL, 0);
  Process32.dwSize := SizeOf(TProcessEntry32);
  Process32First(ProcessSnapshot, Process32);

  repeat
    ModuleSnapshot := CreateToolHelp32SnapShot(TH32CS_SNAPMODULE, Process32.th32ProcessID);
    Module32.dwSize := SizeOf(TModuleEntry32);
    Module32First(ModuleSnapshot, Module32);

    if Copy(string(Module32.szExePath), 1, 4) = '\??\' then
    begin
      LExePath := Copy(string(Module32.szExePath), 5, Length(string(Module32.szExePath)) - 4);
    end
    else if Copy(string(Module32.szExePath), 1, 11) = '\SystemRoot' then
    begin
      LExePath := string(SystemDirectory) + Copy(string(Module32.szExePath), 12, Length(string(Module32.szExePath)) - 11);
    end
    else
    begin
      LExePath := string(Module32.szExePath);
    end;

    if Process32.th32ProcessID = 0 then
    begin
      LPid := IntToStr(GetCurrentProcessID);
    end
    else
    begin
      LPid := IntToStr(Process32.th32ProcessID);
    end;

    LPriority := IntToStr(Process32.pcPriClassBase);
    LThread := IntToStr(Process32.cntThreads);

    LProcessInfo := TProcessInfo.Create(LExePath, LPid, LPriority, LThread);
    FProcessInfoList.Add(LProcessInfo);

    CloseHandle(ModuleSnapshot);
  until not (Process32Next(ProcessSnapshot, Process32));

  CloseHandle(ProcessSnapshot);
end;

procedure TProcessManager.KillProcessByExePath(ExePath: string);
var
  iLoop: integer;
begin
  ListProcesses;

  for iLoop := 0 to FProcessInfoList.Count - 1 do
  begin
    if ExePath = FProcessInfoList[iLoop].FExeNameWithPath then
    begin
      KillProcessByPID(FProcessInfoList[iLoop].FPID);
    end;
  end;
end;

procedure TProcessManager.KillProcessByPID(PID: string);
var
  ProcessHandle: THandle;
begin
  ProcessHandle := OpenProcess(PROCESS_TERMINATE, False, StrToInt(PID));
  TerminateProcess(ProcessHandle, 0);
end;

{ TProcessInfo }

constructor TProcessInfo.Create(aExeName, aPID, aPriority, aThread: string);
begin
  FExeNameWithPath := aExeName;
  FPID := aPID;
  FPriority := aPriority;
  FThread := aThread;
end;

end.
