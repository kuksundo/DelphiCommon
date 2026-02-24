unit UnitODBCDLLLoad;

interface

uses
  Windows, SysUtils, Classes;

const
  // DSN도 같이 제거할지 여부
  ODBC_REMOVE_DSN = True;
  ODBC_DONT_REMOVE_DSN = False;

type
  // --- odbcinst.dll ---
  TSQLGetInstalledDrivers = function(
    lpszBuf: PChar;
    cbBufMax: Word;
    pcbBufOut: PWord
  ): Bool; stdcall;

  TSQLConfigDataSource = function(
    hwndParent: HWND;
    fRequest: Word;
    lpszDriver: PChar;
    lpszAttributes: PChar
  ): Bool; stdcall;

  TSQLInstallDriverEx = function(
    lpszDriver: PChar;
    lpszPathIn: PChar;
    lpszPathOut: PChar;
    cbPathOutMax: Word;
    pcbPathOut: PWord;
    fRequest: Word;
    lpdwUsageCount: PDWord
  ): Bool; stdcall;

  TSQLRemoveDriver = function(
    lpszDriver: PChar;
    fRemoveDSN: Bool;
    lpdwUsageCount: PDWord
  ): Bool; stdcall;

  // --- odbc32.dll ---
  TSQLAllocEnv = function(var hEnv: Pointer): Smallint; stdcall;
  TSQLFreeEnv  = function(hEnv: Pointer): Smallint; stdcall;
  TSQLDataSources = function(
    hEnv: Pointer;
    fDirection: Word;
    szDSN: PChar;
    cbDSNMax: Word;
    pcbDSN: PWord;
    szDescription: PChar;
    cbDescriptionMax: Word;
    pcbDescription: PWord
  ): Smallint; stdcall;

var
  SQLGetInstalledDrivers: TSQLGetInstalledDrivers;
  SQLConfigDataSource: TSQLConfigDataSource;
  SQLInstallDriverEx: TSQLInstallDriverEx;
  SQLRemoveDriver: TSQLRemoveDriver;

  SQLAllocEnv: TSQLAllocEnv;
  SQLFreeEnv: TSQLFreeEnv;
  SQLDataSources: TSQLDataSources;

function LoadODBC(out AErrMsg: string): Boolean;
procedure UnloadODBC;
function GetLoadLibraryErrorMsg(const DllName: string): string;

implementation

var
  hODBCInst: HMODULE = 0;
  hODBC32: HMODULE = 0;

function GetLoadLibraryErrorMsg(const DllName: string): string;
var
  Err: DWORD;
begin
  Err := GetLastError;
  Result := Format(
      'LoadLibrary("%s") 실패'#13#10 +
      'ErrorCode = %d'#13#10 +
      '%s',
      [DllName, Err, SysErrorMessage(Err)]
    );
end;

function LoadProc(h: HMODULE; const Name: AnsiString): Pointer;
begin
  Result := GetProcAddress(h, PAnsiChar(Name));
  if not Assigned(Result) then
    raise Exception.CreateFmt('GetProcAddress 실패: %s', [Name]);
end;

function LoadODBC(out AErrMsg: string): Boolean;
begin
  Result := False;

  hODBCInst := LoadLibrary('odbcinst.dll');

  if hODBCInst = 0 then
  begin
    AErrMsg := GetLoadLibraryErrorMsg('odbcinst.dll');
    Exit;
  end;

  hODBC32 := LoadLibrary('odbc32.dll');

  if hODBC32 = 0 then
  begin
    AErrMsg := GetLoadLibraryErrorMsg('odbc32.dll');
    Exit;
  end;

  // odbcinst.dll
  @SQLGetInstalledDrivers :=
    LoadProc(hODBCInst, 'SQLGetInstalledDrivers');
  @SQLConfigDataSource :=
    LoadProc(hODBCInst, 'SQLConfigDataSource');
  @SQLInstallDriverEx :=
      LoadProc(hODBCInst, 'SQLInstallDriverEx');
  @SQLRemoveDriver :=
    LoadProc(hODBCInst, 'SQLRemoveDriver');

  // odbc32.dll
  @SQLAllocEnv :=
    LoadProc(hODBC32, 'SQLAllocEnv');
  @SQLFreeEnv :=
    LoadProc(hODBC32, 'SQLFreeEnv');
  @SQLDataSources :=
    LoadProc(hODBC32, 'SQLDataSources');

  Result := True;
end;

procedure UnloadODBC;
begin
  if hODBCInst <> 0 then FreeLibrary(hODBCInst);
  if hODBC32 <> 0 then FreeLibrary(hODBC32);
end;

end.

