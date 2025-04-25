unit UnitFileType;

interface

uses ActiveX, ShlObj, Registry;

type
  TOfficeFileType = (oftExcel, oftWord, oftPpt, oftPdf, oftSqlite,
    oftJson, oftXml, oftCsv);

const
  ASSOCF_NONE                = $00000000;  // 기본 옵션 (특별한 조건 없음)
  ASSOCF_INIT_NOREMAPCLSID    = $00000001;  // CLSID 매핑 방지
  ASSOCF_INIT_BYEXENAME       = $00000002;  // 실행 파일 이름을 기준으로 초기화
  ASSOCF_OPEN_BYEXENAME       = $00000004;  // 실행 파일 이름으로 연계된 정보를 검색
  ASSOCF_INIT_DEFAULTTOSTAR   = $00000008;  // '*' 기본 연계 사용
  ASSOCF_INIT_DEFAULTTOFOLDER = $00000010;  // 폴더 기본 연계 사용
  ASSOCF_NOUSERSETTINGS       = $00000020;  // 사용자 설정 무시
  ASSOCF_NOTRUNCATE           = $00000040;  // 잘리지 않은 전체 문자열 반환
  ASSOCF_VERIFY               = $00000080;  // 결과가 유효한지 확인
  ASSOCF_REMAPRUNDLL          = $00000200;  // rundll32.exe를 원래 실행 파일로 매핑
  ASSOCF_NOFIXUPS             = $00000400;  // 자동 수정 방지
  ASSOCF_IGNOREBASECLASS      = $00000800;  // 기본 클래스 무시
  ASSOCF_INIT_IGNOREUNKNOWN   = $00001000;  // 알려지지 않은 파일 유형 무시

  ASSOCSTR_COMMAND         = 1;  // 명령어 문자열 (예: "open" 또는 "print" 동작)
  ASSOCSTR_EXECUTABLE      = 2;  // 기본 실행 파일(EXE) 경로
  ASSOCSTR_FRIENDLYDOCNAME = 3;  // 문서의 친숙한 이름
  ASSOCSTR_FRIENDLYAPPNAME = 4;  // 연계된 앱의 친숙한 이름
  ASSOCSTR_NOOPEN          = 5;  // 파일이 열리지 않는 이유
  ASSOCSTR_SHELLNEWVALUE   = 6;  // ShellNew 값
  ASSOCSTR_DDECOMMAND      = 7;  // DDE 명령
  ASSOCSTR_DDEIFEXEC       = 8;  // DDE 실행 조건
  ASSOCSTR_DDEAPPLICATION  = 9;  // DDE 애플리케이션 이름
  ASSOCSTR_DDETOPIC        = 10; // DDE 토픽
  ASSOCSTR_INFOTIP         = 11; // 툴팁 정보
  ASSOCSTR_QUICKTIP        = 12; // 빠른 설명
  ASSOCSTR_TILEINFO        = 13; // 타일 보기 정보
  ASSOCSTR_CONTENTTYPE     = 14; // MIME 유형
  ASSOCSTR_DEFAULTICON     = 15; // 기본 아이콘 경로
  ASSOCSTR_SHELLEXTENSION  = 16; // 셸 확장
  ASSOCSTR_DROPTARGET      = 17; // 드롭 대상 CLSID
  ASSOCSTR_DELEGATEEXECUTE = 18; // DelegateExecute CLSID

function AssocQueryString(flags,str: DWORD;
                 pszAssoc, pszExtra: PChar;
                             pszOut: PChar;
                            pcchOut: PDWORD): HRESULT; stdcall;
                             external 'shlwapi.dll' name 'AssocQueryStringW';

{
  Label1.Caption := GetAssociatedProgram( Button2.Caption );
  Label2.Caption := GetExecutableForExtension( Button3.Caption );
}
function GetAssociatedProgram(const Ext: string): string;
function GetExecutableForExtension(const Ext: string): string;

implementation

function GetAssociatedProgram(const Ext: string): string;
var
  BufSize: DWORD;
  Buffer: array[0..MAX_PATH] of Char;
begin
  Result := '';
  BufSize := MAX_PATH;

  if AssocQueryString(ASSOCF_NONE, ASSOCSTR_EXECUTABLE, PChar(Ext), nil, Buffer, @BufSize) = S_OK then
    Result := Buffer;
end;

function GetExecutableForExtension(const Ext: string): string;
var
  Reg: TRegistry;
  FileType, Command: string;
begin
  Result := '';

  // 레지스트리에서 파일 확장자와 연결된 파일 형식 찾기
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if Reg.OpenKeyReadOnly(Ext) then
    begin
      if Reg.ValueExists('') then
        FileType := Reg.ReadString('');
      Reg.CloseKey;
    end;

    if FileType = '' then Exit;

    // 해당 파일 형식에서 실행 파일 조회
    if Reg.OpenKeyReadOnly(FileType + '\shell\open\command') then
    begin
      if Reg.ValueExists('') then
      begin
        Command := Reg.ReadString('');
        Result := Command;

        // 실행 파일 경로 정리
        if (Length(Command) > 0) and (Command[1] = '"') then
          Result := Copy(Command, 2, Pos('"', Command, 2) - 2);
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

end.
