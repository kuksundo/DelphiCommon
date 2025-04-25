unit UnitSystemUtil2;

interface

uses Windows, SysUtils, Winapi.ShellAPI, Vcl.Forms, Vcl.Dialogs;

// 컴퓨터 이름을 변경하는 함수
// NewHostName: 설정할 새 컴퓨터 이름 (DNS 호스트 이름 형식 권장)
// 반환값: 성공 시 True, 실패 시 False
function ChangeComputerName(const NewHostName: string): Boolean;
// 방법 1: Windows 설정 앱의 '정보' 페이지 열기 (최신 방식)
procedure OpenSettings_ComputerName_Modern;
// 방법 2: 시스템 속성의 '컴퓨터 이름' 탭 열기 (클래식 방식)
procedure OpenSettings_ComputerName_Classic;

implementation

// 컴퓨터 이름을 변경하는 함수 구현
function ChangeComputerName(const NewHostName: string): Boolean;
var
  NameType: COMPUTER_NAME_FORMAT;
  PNewName: PWideChar; // SetComputerNameEx는 유니코드 문자열을 요구함
  Success: Boolean;
begin
  Result := False; // 기본적으로 실패로 초기화

  // 유효한 이름인지 기본적인 검사 (더 엄격한 검사가 필요할 수 있음)
  if Trim(NewHostName) = '' then
  begin
    // Log or raise an exception for invalid input
    Exit;
  end;

  // 설정할 이름 타입 지정:
  // ComputerNamePhysicalDnsHostname: 영구적인 DNS 호스트 이름. 재부팅 필요. 일반적으로 이 값을 사용.
  // ComputerNamePhysicalNetBIOS: 영구적인 NetBIOS 이름. 재부팅 필요.
  // ComputerNameDnsHostname: 현재 세션의 DNS 호스트 이름. 재부팅 시 원래대로 돌아갈 수 있음.
  // ... 다른 COMPUTER_NAME_FORMAT 값들도 있음 ...
  NameType := ComputerNamePhysicalDnsHostname;

  // Delphi string을 PWideChar (유니코드 포인터)로 변환
  PNewName := PWideChar(NewHostName);

  // SetComputerNameExW 함수 호출 (W는 Wide/Unicode 버전 명시)
  // Kernel32.dll 에 정의되어 있으며 Winapi.Windows 유닛에 선언됨
//  Success := SetComputerNameEx(NameType, PNewName);

  if Success then
  begin
    Result := True;
    // 성공 메시지 또는 로그 기록 (재부팅 필요함을 알림)
    // 예: ShowMessage('컴퓨터 이름 변경 요청이 성공했습니다. 변경 사항을 적용하려면 컴퓨터를 재부팅해야 합니다.');
  end
  else
  begin
    // 실패 시 오류 코드 확인 및 메시지 표시
    // 예: ShowMessage('컴퓨터 이름 변경 실패: ' + SysErrorMessage(GetLastError));
    Result := False;
  end;
end;

// 방법 1: Windows 설정 앱의 '정보' 페이지 열기
procedure OpenSettings_ComputerName_Modern;
var
  ErrorCode: NativeUInt; // ShellExecute 반환값 타입
begin
  ErrorCode := ShellExecute(Application.Handle, // 부모 윈도우 핸들
                            'open',             // 실행 동작
                            'ms-settings:about',// 실행할 URI
                            nil,                // 파라미터 없음
                            nil,                // 작업 디렉토리 없음
                            SW_SHOWNORMAL);     // 창 표시 방법

  // ShellExecute 성공 기준은 32보다 큰 값
  if ErrorCode <= 32 then
  begin
    // 오류 처리 (오류 코드는 ShellExecute 자체 반환값으로 해석)
    ShowMessage('설정(정보) 창을 여는 데 실패했습니다. 오류 코드: ' + IntToStr(ErrorCode));
  end;
end;

// 방법 2: 시스템 속성의 '컴퓨터 이름' 탭 열기
procedure OpenSettings_ComputerName_Classic;
var
  ErrorCode: NativeUInt;
begin
  // 옵션 A: 직접 실행 파일 사용 (더 직접적)
  ErrorCode := ShellExecute(Application.Handle, 'open', 'SystemPropertiesComputerName.exe', nil, nil, SW_SHOWNORMAL);

  // 옵션 B: 제어판 애플릿 사용 (동일한 결과)
  // ErrorCode := ShellExecute(Application.Handle, 'open', 'sysdm.cpl', nil, nil, SW_SHOWNORMAL);
  // 만약 sysdm.cpl 사용 시 '컴퓨터 이름' 탭이 아닌 기본 탭이 열릴 수 있음

  if ErrorCode <= 32 then
  begin
    ShowMessage('시스템 속성(컴퓨터 이름) 창을 여는 데 실패했습니다. 오류 코드: ' + IntToStr(ErrorCode));
  end;
end;

end.
