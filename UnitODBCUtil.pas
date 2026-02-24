unit UnitODBCUtil;

interface

uses
  Windows, SysUtils, Classes, Dialogs,
  UnitODBCDLLLoad;

type
  TODBCRegRec = packed record
    FODBCDriverName,
    FDSNName,
    FIPAddr,
    FDBName: string;
    FIsSystemDSN: Boolean;
  end;

const
  ODBC_INSTALL_INQUIRY  = 1;
  ODBC_INSTALL_COMPLETE = 2;

  ODBC_ADD_DSN    = 1;
  ODBC_CONFIG_DSN = 2;
  ODBC_REMOVE_DSN = 3;

  ODBC_ADD_SYS_DSN    = 4;
  ODBC_CONFIG_SYS_DSN = 5;
  ODBC_REMOVE_SYS_DSN = 6;

const
  SQL_FETCH_FIRST = 2;
  SQL_FETCH_NEXT  = 1;
  SQL_SUCCESS     = 0;
  SQL_SUCCESS_WITH_INFO = 1;

//function SQLConfigDataSource(hwndParent: HWND; fRequest: Word; lpszDriver: PChar; lpszAttributes: PChar): Bool; stdcall; external 'odbcinst.dll';
//function SQLDataSources(hEnv: Pointer; fDirection: Word; szDSN: PChar; cbDSNMax: Word;
//  pcbDSN: PWord; szDescription: PChar; cbDescriptionMax: Word; pcbDescription: PWord): Smallint; stdcall; external 'odbc32.dll';
//
//function SQLAllocEnv(var hEnv: Pointer): Smallint; stdcall; external 'odbc32.dll';
//function SQLFreeEnv(hEnv: Pointer): Smallint; stdcall; external 'odbc32.dll';
//
////관리자 권한으로 실행할 것
////ODBC 드라이버 Installer API 함수
//function SQLInstallDriverEx(lpszDriver: PChar; lpszPathIn: PChar; lpszPathOut: PChar; cbPathOutMax: Word; pcbPathOut: PWord; fRequest: Word; lpdwUsageCount: PDWord): Bool; stdcall; external 'odbcinst.dll';
//
////ODBC 드라이버 제거 함수
//function SQLRemoveDriver(lpszDriver: PChar; fRemoveDSN: Bool; lpdwUsageCount: PDWord): Bool; stdcall; external 'odbcinst.dll';
//
//function SQLGetInstalledDrivers(lpszBuf: PChar; cbBufMax: Word; pcbBufOut: PWord): Bool; stdcall; external 'odbcinst.dll';

type
  TODBCUtil = class
    class var FIsODBCDLLLoaded: Boolean; //True = ODBC Dll Load 됨

    class function LoadODBCDLL(out AErrMsg: string): Boolean; static;
    {사용:
      try
        if RegisterODBCDriver(
          'My Custom ODBC Driver',
          'C:\MyDriver\mydriver.dll'
        ) then
          ShowMessage('ODBC 드라이버 등록 성공!');
      except
        on E: Exception do
          ShowMessage('등록 실패: ' + E.Message);
      end;
    }
    class function RegisterODBCDriver(const DriverName: string; const DriverDLLPath: string): Boolean; static;

    //DSN 등록 함수 (User DSN / System DSN)
    {사용:
    AddODBCDSN(
      'My Custom ODBC Driver',
      'MyTestDSN',
      '127.0.0.1',
      'TestDB',
      True   // System DSN
    );
    }
    class function AddODBCDSN(const DriverName: string; const DSNName: string; const Server: string; const Database: string; SystemDSN: Boolean): Boolean; static;

    //DSN 삭제 함수
    {사용:                                                                                                                                                     static;
    RemoveODBCDSN(
      'My Custom ODBC Driver',
      'MyTestDSN',
      True   // System DSN
    );
    }
    class function RemoveODBCDSN(const DriverName: string; const DSNName: string; SystemDSN: Boolean): Boolean; static;

    class function IsODBCDriverInstalledByName(ADriverName: string): Boolean; static;
    class function GetODBCDriverInstalledList(): TStringList; static;

    class function EnsureMSSQLODBCDriverInstalled: string; static;
    class function EnsureMSSQLODBCDSNRegistered(ARec: TODBCRegRec): Boolean; static;
  end;

implementation

class function TODBCUtil.RegisterODBCDriver(const DriverName: string; const DriverDLLPath: string): Boolean;
var
  DriverSpec: string;
  PathOut: array[0..MAX_PATH] of Char;
  PathOutLen: Word;
  UsageCount: DWORD;
begin
  // ODBC 드라이버 정보 문자열 (NULL 문자로 구분, 마지막은 이중 NULL)
  DriverSpec :=
    Format(
      'Driver=%s'#0 +
      'Setup=%s'#0 +
      'APILevel=1'#0 +
      'ConnectFunctions=YYY'#0 +
      'DriverODBCVer=03.80'#0 +
      'SQLLevel=1'#0#0,
      [DriverDLLPath, DriverDLLPath]
    );

  FillChar(PathOut, SizeOf(PathOut), 0);
  PathOutLen := 0;
  UsageCount := 0;

  Result := SQLInstallDriverEx(
    PChar(DriverSpec),
    nil,
    PathOut,
    SizeOf(PathOut),
    @PathOutLen,
    ODBC_INSTALL_COMPLETE,
    @UsageCount
  );

  if not Result then
    RaiseLastOSError;
end;

class function TODBCUtil.AddODBCDSN(const DriverName: string; const DSNName: string; const Server: string;
  const Database: string; SystemDSN: Boolean): Boolean;
var
  Attrs: string;
  Request: Word;
begin
  // DSN 속성 문자열 (NULL로 구분, 마지막은 이중 NULL)
  Attrs :=
    'DSN=' + DSNName + #0 +
    'SERVER=' + Server + #0 +
    'DATABASE=' + Database + #0#0;

  if SystemDSN then
    Request := ODBC_ADD_SYS_DSN
  else
    Request := ODBC_ADD_DSN;

  Result := SQLConfigDataSource(
    0,
    Request,
    PChar(DriverName),
    PChar(Attrs)
  );

  if not Result then
    RaiseLastOSError;
end;

class function TODBCUtil.RemoveODBCDSN(const DriverName: string; const DSNName: string; SystemDSN: Boolean): Boolean;
var
  Attrs: string;
  Request: Word;
begin
  Attrs := 'DSN=' + DSNName + #0#0;

  if SystemDSN then
    Request := ODBC_REMOVE_SYS_DSN
  else
    Request := ODBC_REMOVE_DSN;

  Result := SQLConfigDataSource(
    0,
    Request,
    PChar(DriverName),
    PChar(Attrs)
  );

  if not Result then
    RaiseLastOSError;
end;

class function TODBCUtil.GetODBCDriverInstalledList(): TStringList;
var
  Buffer: array[0..4095] of Char;
  OutLen: Word;
  P: PChar;
begin
  Result := nil;
  FillChar(Buffer, SizeOf(Buffer), 0);
  OutLen := 0;

  if not SQLGetInstalledDrivers(Buffer, SizeOf(Buffer), @OutLen) then
    Exit;

  Result := TStringList.Create;
  P := Buffer;

  while P^ <> #0 do
  begin
    Result.Add(P);
    Inc(P, StrLen(P) + 1);
  end;
end;

class function TODBCUtil.IsODBCDriverInstalledByName(ADriverName: string): Boolean;
var
  I: Integer;
  Drivers: TStringList;
begin
  Result := False;

  Drivers := GetODBCDriverInstalledList();

  if (Drivers = nil) or (Drivers.Count = 0) then
    Exit;

  for I := 0 to Drivers.Count - 1 do
  begin
//    if SameText(Drivers[I], 'ODBC Driver 17 for SQL Server') or
//       SameText(Drivers[I], 'ODBC Driver 18 for SQL Server') then
    if SameText(Drivers[I], ADriverName) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

class function TODBCUtil.LoadODBCDLL(out AErrMsg: string): Boolean;
begin
  FIsODBCDLLLoaded := LoadODBC(AErrMsg);

  Result := FIsODBCDLLLoaded;
end;

class function TODBCUtil.EnsureMSSQLODBCDriverInstalled: string;
var
  Drivers: TStringList;
  Installed: Boolean;
begin
  Result := '';

  Drivers := GetODBCDriverInstalledList;
  try
    Installed := IsODBCDriverInstalledByName('ODBC Driver 17 for SQL Server');

    if Installed then
      Result := 'ODBC Driver 17 for SQL Server'
    else
    begin
      Installed := IsODBCDriverInstalledByName('ODBC Driver 18 for SQL Server');

      if Installed then
        Result := 'ODBC Driver 18 for SQL Server'
    end;
  finally
    Drivers.Free;
  end;

//  if Installed then
//    Exit
//  else
//    raise Exception.Create('MSSQL ODBC Driver 설치를 먼저 설치 하세요');
//

//  //여기서 설치 프로그램 경로 지정
//  if not RunInstallerAndWait(
//    'C:\Installers\msodbcsql17.msi',
//    '/quiet /norestart'
//  ) then
//    raise Exception.Create('MSSQL ODBC Driver 설치 실패');

//  // 설치 후 재확인
//  Drivers := GetInstalledODBCDrivers;
//  try
//    if not IsAnyMSSQLDriverInstalled(Drivers) then
//      raise Exception.Create('MSSQL ODBC Driver 설치 후에도 감지되지 않음');
//  finally
//    Drivers.Free;
//  end;
end;

class function TODBCUtil.EnsureMSSQLODBCDSNRegistered(ARec: TODBCRegRec): Boolean;
var
  LInstalledDriverName: string;
begin
  Result := False;

  LInstalledDriverName := EnsureMSSQLODBCDriverInstalled;

  if LInstalledDriverName <> '' then
    Result := AddODBCDSN(
      ARec.FODBCDriverName, //'ODBC Driver 17 for SQL Server',
      ARec.FDSNName, //'CM_Master_DSN',
      ARec.FIPAddr, //'127.0.0.1',
      ARec.FDBName, //'TestDB',
      ARec.FIsSystemDSN);   // System DSN
end;

end.
