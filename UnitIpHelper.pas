unit UnitIpHelper;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.WinSock2, Winapi.IpHlpApi, // WinSock 추가 (inet_addr)
  Winapi.IpTypes,
  mormot.core.variants, mormot.core.json, mormot.core.base
  ;

const
  // 필요한 상수들
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_NAME_LENGTH = 256;
  MAX_ADAPTER_ADDRESS_LENGTH = 8;
  ERROR_SUCCESS = 0;
  ERROR_BUFFER_OVERFLOW = 111;
  ERROR_ACCESS_DENIED = 5;
  ERROR_NOT_FOUND = 1168; // GetAdaptersInfo 등에서 사용될 수 있음

type
  time_t = LongInt;

  // --- IP Helper API 구조체 선언 ---
  TIPAddressString = array[0..4 * 4 - 1] of AnsiChar;

  PIPAddrString = ^TIPAddrString;
  TIPAddrString = record
    Next: PIPAddrString;
    IpAddress: TIPAddressString;
    IpMask: TIPAddressString;
    Context: DWORD;
  end;

  // Adapter 정보 구조체
  PIPAdapterInfo = ^TIPAdapterInfo;
  TIPAdapterInfo = packed record // packed 중요
    Next: PIPAdapterInfo;
    ComboIndex: DWORD;
    AdapterName: array[0..MAX_ADAPTER_NAME_LENGTH - 1] of AnsiChar;
    Description: array[0..MAX_ADAPTER_DESCRIPTION_LENGTH - 1] of AnsiChar;
    AddressLength: UINT;
    Address: array[0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of Byte;
    Index: DWORD; // 이 Index가 중요!
    AdapterType: UINT;
    DhcpEnabled: UINT;
    CurrentIpAddress: PIpAddrString; // 사용 안함 (GetIpAddrTable 사용)
    IpAddressList: TIPAddrString;   // IP 주소 목록 시작
    GatewayList: TIPAddrString;     // 게이트웨이 목록 시작
    DhcpServer: TIPAddrString;      // DHCP 서버 정보
    HaveWins: BOOL;
    PrimaryWinsServer: TIPAddrString;
    SecondaryWinsServer: TIPAddrString;
    LeaseObtained: time_t;
    LeaseExpires: time_t;
  end;
  TMaxAdapterInfo = TIPAdapterInfo; // 이름 통일성 위해 사용

  // IP 주소 테이블 구조체
  TMibIpAddrRow = packed record // packed 중요
    dwAddr: DWORD;        // IP Address
    dwIndex: DWORD;       // Adapter Index (TIPAdapterInfo의 Index와 매칭)
    dwMask: DWORD;        // Subnet Mask
    dwBCastAddr: DWORD;   // Broadcast Address
    dwReasmSize: DWORD;   // Reassembly Size
    unused1: Word;
    wType: Word;          // MIB_IPADDR_TYPE (Primary, Dynamic, ...)
    NTEContext: ULONG;    // AddIPAddress, DeleteIPAddress에서 사용!
    NTEInstance: ULONG;   // AddIPAddress에서 사용
  end;
  PMibIpAddrRow = ^TMibIpAddrRow;

  TMaxIpAddrTable = array[0..0] of TMibIpAddrRow; // 동적 크기 배열 포인터용
  PMibIpAddrTable = ^TMibIpAddrTable;
  TMibIpAddrTable = packed record // packed 중요
    dwNumEntries: DWORD;
    Table: TMaxIpAddrTable; // 실제로는 dwNumEntries 만큼의 배열
  end;

// --- IP Helper API 함수 선언 ---
function GetAdaptersInfo(pAdapterInfo: PIPAdapterInfo; var pOutBufLen: ULONG): DWORD; stdcall; external 'iphlpapi.dll' name 'GetAdaptersInfo';
function GetIpAddrTable(pIpAddrTable: PMibIpAddrTable; var pdwSize: ULONG; bOrder: BOOL): DWORD; stdcall; external 'iphlpapi.dll' name 'GetIpAddrTable';
function AddIPAddress(Address: ULONG; IpMask: ULONG; IfIndex: DWORD; var NTEContext: ULONG; var NTEInstance: ULONG): DWORD; stdcall; external 'iphlpapi.dll' name 'AddIPAddress';
function DeleteIPAddress(NTEContext: ULONG): DWORD; stdcall; external 'iphlpapi.dll' name 'DeleteIPAddress';

type
  TEthAdaptorRec = packed record
    FriendlyName,
    AdapterName,
    Description,
    MadAddr,
    IPAddrList //Json ary = ["x.x.x.x","",...]
    : string;
  end;
///////==========
// MAC 주소를 문자열로 변환하는 헬퍼 함수
function MacAddressToString(MacAddr: PByte; AddrLen: ULONG): string;
// IP 주소를 문자열로 변환하는 헬퍼 함수 (IPv4/IPv6)
function IPAddressToString(pSockAddr: PSockAddr): string;
// 이더넷 어댑터 목록을 가져오는 주 함수
// AdapterList: string - 어댑터 정보를 담은 JsonAry
// IncludeDetails: Boolean - MAC 주소 및 IP 주소 포함 여부
// 반환값: 성공 시 True, 실패 시 False
function GetEthernetAdapters(var AAdaptorList: string; IncludeDetails: Boolean = False): Boolean;
function PrefixLengthToIPv4Mask(APrefixLen: Byte): string;

function GetIpAddressList2JsonByAdaptorName(const AAdaptorName: string): string;
function GetAdaptorList2JsonUsingIpHelper(): string;

// --- WinSock 함수 선언 (IP 문자열 -> DWORD) ---
// Winapi.WinSock 유닛에 이미 선언되어 있음 (inet_addr)
// function inet_addr(cp: PAnsiChar): ULONG; stdcall; external 'ws2_32.dll' name 'inet_addr';

// --- TForm ---
type
  TForm1 = class(TForm)
    EditInterfaceDesc: TEdit;
    Label1: TLabel;
    EditIP: TEdit;
    Label2: TLabel;
    EditSubnet: TEdit;
    Label3: TLabel;
    ButtonSetStaticIP: TButton;
    ButtonSetDHCP: TButton;
    MemoLog: TMemo;
    procedure ButtonSetStaticIPClick(Sender: TObject);
    procedure ButtonSetDHCPClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure Log(const Msg: string);
    function GetAdapterIndexByDesc(const Desc: string; out Index: DWORD): Boolean;
    function IPStringToDWord(const IPString: string): DWORD;
    function DeleteIPsForAdapter(AdapterIndex: DWORD): Boolean;
  public
    { Public declarations }
  end;

implementation

uses UnitBase64Util2;

// 로그 출력 함수
procedure TForm1.Log(const Msg: string);
begin
  MemoLog.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) + Msg);
  OutputDebugString(PChar(Msg)); // 디버그 출력 창에도 표시
end;

// IP 주소 문자열을 DWORD로 변환
function TForm1.IPStringToDWord(const IPString: string): DWORD;
var
  Addr: AnsiString;
begin
  Addr := AnsiString(IPString); // inet_addr은 PAnsiChar를 받음
  Result := inet_addr(PAnsiChar(Addr));
  if Result = INADDR_NONE then // INADDR_NONE = $FFFFFFFF
    Log('경고: IP 주소 형식 오류 또는 255.255.255.255 - ' + IPString);
end;

// 어댑터 설명을 기반으로 어댑터 인덱스 찾기
function TForm1.GetAdapterIndexByDesc(const Desc: string; out Index: DWORD): Boolean;
var
  pAdapterInfo, pCurrAdapter: PIPAdapterInfo;
  OutBufLen: ULONG;
  dwResult: DWORD;
  AdapterDescAnsi: AnsiString;
begin
  Result := False;
  Index := 0;
  pAdapterInfo := nil;
  OutBufLen := 0;

  // 1. 필요한 버퍼 크기 얻기
  dwResult := GetAdaptersInfo(nil, OutBufLen);
  if (dwResult <> ERROR_SUCCESS) and (dwResult <> ERROR_BUFFER_OVERFLOW) then
  begin
    Log('GetAdaptersInfo (size query) 실패: ' + SysErrorMessage(dwResult));
    Exit;
  end;

  // 2. 버퍼 할당 및 정보 얻기
  GetMem(pAdapterInfo, OutBufLen);
  try
    dwResult := GetAdaptersInfo(pAdapterInfo, OutBufLen);
    if dwResult <> ERROR_SUCCESS then
    begin
      Log('GetAdaptersInfo 실패: ' + SysErrorMessage(dwResult));
      Exit;
    end;

    // 3. 어댑터 목록 순회하며 설명 비교
    pCurrAdapter := pAdapterInfo;
    AdapterDescAnsi := AnsiString(Desc); // 비교를 위해 AnsiString으로 변환

    while pCurrAdapter <> nil do
    begin
      // AnsiChar 배열과 AnsiString 비교 (대소문자 구분 안 함)
      if AnsiSameText(Trim(String(pCurrAdapter^.Description)), Trim(AdapterDescAnsi)) then
      begin
        Index := pCurrAdapter^.Index;
        Result := True;
        Log('어댑터 찾음: "' + Desc + '" (인덱스: ' + IntToStr(Index) + ')');
        Break; // 찾았으면 종료
      end;
      pCurrAdapter := pCurrAdapter^.Next; // 다음 어댑터로 이동
    end;

    if not Result then
      Log('어댑터 설명 "' + Desc + '"을(를) 찾을 수 없습니다.');

  finally
    if pAdapterInfo <> nil then
      FreeMem(pAdapterInfo);
  end;
end;

// 특정 어댑터에 할당된 (삭제 가능한 타입의) 모든 IP 주소 삭제
function TForm1.DeleteIPsForAdapter(AdapterIndex: DWORD): Boolean;
var
  pIpAddrTable: PMibIpAddrTable;
  dwSize: ULONG;
  dwResult: DWORD;
  i: Integer;
  bDeleted: Boolean;
  Row: ^TMibIpAddrRow;
  LInAddr: in_addr;
begin
  Result := False; // 기본값 실패
  bDeleted := False; // 하나라도 삭제 성공했는지 추적
  pIpAddrTable := nil;
  dwSize := 0;

  Log(Format('어댑터 인덱스 %d의 기존 IP 주소 삭제 시도...', [AdapterIndex]));

  // 1. 필요한 버퍼 크기 얻기
  dwResult := GetIpAddrTable(nil, dwSize, False);
  if (dwResult <> ERROR_SUCCESS) and (dwResult <> ERROR_BUFFER_OVERFLOW) then
  begin
    Log('GetIpAddrTable (size query) 실패: ' + SysErrorMessage(dwResult));
    Exit;
  end;

  // 2. 버퍼 할당 및 테이블 얻기
  GetMem(pIpAddrTable, dwSize);
  try
    dwResult := GetIpAddrTable(pIpAddrTable, dwSize, False);
    if dwResult <> ERROR_SUCCESS then
    begin
      Log('GetIpAddrTable 실패: ' + SysErrorMessage(dwResult));
      Exit;
    end;

    // 3. 테이블 순회하며 해당 인덱스의 IP 삭제 시도
    Log(Format('총 %d개의 IP 항목 확인 중...', [pIpAddrTable^.dwNumEntries]));
    for i := 0 to pIpAddrTable^.dwNumEntries - 1 do
    begin
      // 배열 포인터 접근 방식 수정
      // PMibIpAddrRow 타입으로 캐스팅 후 인덱스로 접근
      Row := @(pIpAddrTable^.Table[i]);

      if Row^.dwIndex = AdapterIndex then
      begin
        LInAddr.S_addr := Row^.dwAddr;
        LInAddr.S_addr := ntohl(LInAddr.S_addr);
        // 삭제 시도 (NTEContext 사용)
        Log(Format(' - 인덱스 %d의 IP %s (NTE Context: %u) 삭제 시도...',
               [AdapterIndex, inet_ntoa(LInAddr), Row^.NTEContext])); // inet_ntoa 사용을 위해 WinSock 필요

        dwResult := DeleteIPAddress(Row^.NTEContext);
        if dwResult = ERROR_SUCCESS then
        begin
          Log('   -> 삭제 성공.');
          bDeleted := True;
        end
        else if dwResult = ERROR_ACCESS_DENIED then
        begin
          Log('   -> 삭제 실패: 접근 거부 (관리자 권한 필요).');
          // 접근 거부 시 더 이상 시도 의미 없을 수 있으므로 종료 고려
          Exit; // 함수 종료
        end
        else
        begin
          // 다른 오류 (예: 동적 IP는 삭제 불가 등)
          Log(Format('   -> 삭제 실패: 오류 코드 %d (%s)', [dwResult, SysErrorMessage(dwResult)]));
        end;
      end;
    end;

    // 하나라도 성공적으로 삭제했거나, 원래 없었으면 성공으로 간주할 수 있음
    // 여기서는 삭제 시도가 있었고 Access Denied가 아니었다면 일단 성공으로 처리
    Result := True; // 삭제 시도가 정상적으로 이루어졌다면 True 반환 (실제 삭제 성공 여부와는 별개일 수 있음)

  finally
    if pIpAddrTable <> nil then
      FreeMem(pIpAddrTable);
  end;
end;

// 폼 생성 시 초기화
procedure TForm1.FormCreate(Sender: TObject);
begin
  // 예시 값 (사용자 환경에 맞게 수정 필요)
  EditInterfaceDesc.Text := 'Realtek PCIe GbE Family Controller'; // 장치 관리자 또는 ipconfig /all 에서 확인
  EditIP.Text := '192.168.0.150';
  EditSubnet.Text := '255.255.255.0';
  Log('애플리케이션 시작. 관리자 권한으로 실행했는지 확인하세요.');
end;

// 고정 IP 설정 버튼 클릭
procedure TForm1.ButtonSetStaticIPClick(Sender: TObject);
var
  AdapterDesc: string;
  AdapterIndex: DWORD;
  NewIP, NewMask: DWORD;
  NTEContext, NTEInstance: ULONG;
  dwResult: DWORD;
begin
  AdapterDesc := Trim(EditInterfaceDesc.Text);
  if AdapterDesc = '' then
  begin
    Log('오류: 네트워크 어댑터 설명을 입력하세요.');
    Exit;
  end;

  if (Trim(EditIP.Text) = '') or (Trim(EditSubnet.Text) = '') then
  begin
    Log('오류: IP 주소와 서브넷 마스크를 입력하세요.');
    Exit;
  end;

  Log('고정 IP 설정 시작: ' + AdapterDesc);

  // 1. 어댑터 인덱스 찾기
  if not GetAdapterIndexByDesc(AdapterDesc, AdapterIndex) then
  begin
    Log('오류: 어댑터 인덱스를 찾을 수 없습니다.');
    Exit;
  end;

  // 2. (선택 사항/권장) 기존 IP 주소 삭제
  // 주의: DHCP로 할당된 IP는 보통 DeleteIPAddress로 삭제되지 않습니다.
  //       고정 IP가 여러 개 설정될 수 있으므로, 기존 고정 IP를 먼저 지우는 것이 좋습니다.
  if not DeleteIPsForAdapter(AdapterIndex) then
  begin
     // Access Denied 등의 심각한 오류 시 여기서 중단 가능
     Log('경고: 기존 IP 주소 삭제 중 문제가 발생했습니다. 계속 진행합니다.');
     // Access Denied였으면 AddIPAddress도 실패할 가능성 높음
  end;

  // 3. 새 IP 주소 및 마스크 변환
  NewIP := IPStringToDWord(Trim(EditIP.Text));
  NewMask := IPStringToDWord(Trim(EditSubnet.Text));

  if (NewIP = 0) or (NewIP = INADDR_NONE) or (NewMask = 0) or (NewMask = INADDR_NONE) then
  begin
     Log('오류: 유효하지 않은 IP 주소 또는 서브넷 마스크입니다.');
     Exit;
  end;

  // 4. 새 IP 주소 추가
  Log(Format('AddIPAddress 호출: IP=%s, Mask=%s, Index=%d',
         [EditIP.Text, EditSubnet.Text, AdapterIndex]));

  NTEContext := 0;
  NTEInstance := 0;
  dwResult := AddIPAddress(NewIP, NewMask, AdapterIndex, NTEContext, NTEInstance);

  if dwResult = ERROR_SUCCESS then
  begin
    Log(Format('AddIPAddress 성공! NTE Context: %u, NTE Instance: %u', [NTEContext, NTEInstance]));
    Log('고정 IP 설정 완료. (게이트웨이/DNS는 별도 설정 필요)');
    // 게이트웨이 설정 로직 추가 필요 (CreateIpForwardEntry 등)
    // DNS 설정 로직 추가 필요
  end
  else if dwResult = ERROR_ACCESS_DENIED then
  begin
    Log('AddIPAddress 실패: 접근 거부 (관리자 권한으로 실행되지 않았습니다).');
    ShowMessage('관리자 권한으로 프로그램을 실행해야 합니다!');
  end
  else
  begin
    Log(Format('AddIPAddress 실패: 오류 코드 %d (%s)', [dwResult, SysErrorMessage(dwResult)]));
  end;
end;

// DHCP 설정 버튼 클릭
procedure TForm1.ButtonSetDHCPClick(Sender: TObject);
var
  AdapterDesc: string;
  AdapterIndex: DWORD;
begin
  AdapterDesc := Trim(EditInterfaceDesc.Text);
  if AdapterDesc = '' then
  begin
    Log('오류: 네트워크 어댑터 설명을 입력하세요.');
    Exit;
  end;

  Log('DHCP 설정 시작 (기존 고정 IP 삭제 시도): ' + AdapterDesc);

  // 1. 어댑터 인덱스 찾기
  if not GetAdapterIndexByDesc(AdapterDesc, AdapterIndex) then
  begin
    Log('오류: 어댑터 인덱스를 찾을 수 없습니다.');
    Exit;
  end;

  // 2. 해당 어댑터의 모든 (삭제 가능한) IP 주소 삭제
  if DeleteIPsForAdapter(AdapterIndex) then
  begin
     Log('기존 IP 주소 삭제 시도 완료. 시스템이 DHCP 서버로부터 새 IP를 받아야 합니다.');
     Log('참고: 이 방법만으로는 DHCP 클라이언트 설정이 완벽하지 않을 수 있습니다.');
     Log('      netsh interface ip set address name="' + AdapterDesc + '" dhcp 명령어가 더 확실할 수 있습니다.');
  end
  else
  {
    // DeleteIPsForAdapter 내부에서 이미 로그 기록됨
    // if GetLastError = ERROR_ACCESS_DENIED then ... 등 추가 처리 가능
  }
end;

function MacAddressToString(MacAddr: PByte; AddrLen: ULONG): string;
var
  I: Integer;
begin
  Result := '';
  if (MacAddr = nil) or (AddrLen = 0) then
    Exit;

  for I := 0 to AddrLen - 1 do
  begin
    Result := Result + IntToHex(MacAddr[I], 2);
    if I < AddrLen - 1 then
      Result := Result + '-';
  end;
end;

// IP 주소를 문자열로 변환하는 헬퍼 함수 (IPv4/IPv6)
function IPAddressToString(pSockAddr: PSockAddr): string;
const
  INET6_ADDRSTRLEN = 46; // IPv6 주소 문자열 최대 길이 (WinSock2.pas에 없을 경우)
var
  Buffer: array[0..INET6_ADDRSTRLEN - 1] of Char; // WSAAddressToString 용 버퍼
  dwLen: DWORD;
  pAddr: PVOID;
begin
  Result := '';
  if pSockAddr = nil then Exit;

  dwLen := INET6_ADDRSTRLEN; // 버퍼 크기 초기화

  // 주소 패밀리에 따라 실제 주소 포인터 설정
  if pSockAddr.sa_family = AF_INET then // IPv4
  begin
    pAddr := @(PSockAddrIn(pSockAddr).sin_addr);
    // inet_ntop 사용 (WS2_32.dll 필요, 최신 윈도우 권장)
    // Result := Winapi.WinSock2.inet_ntop(AF_INET, pAddr, Buffer, dwLen);
    // 또는 WSAAddressToString 사용 (더 안전하고 유연함)
    if WSAAddressToString(TSockAddr(pSockAddr^), SizeOf(TSockAddrIn), nil, Buffer, dwLen) = 0 then
      Result := string(Buffer)
    else
      Result := '(IPv4 변환 오류)';
  end
  else if pSockAddr.sa_family = AF_INET6 then // IPv6
  begin
//    pAddr := @(PSockAddrIn6(pSockAddr).sin6_addr);
//    // inet_ntop 사용
//    // Result := Winapi.WinSock2.inet_ntop(AF_INET6, pAddr, Buffer, dwLen);
//     // 또는 WSAAddressToString 사용
//    if WSAAddressToString(pSockAddr, SizeOf(TSockAddrIn6), nil, Buffer, @dwLen) = 0 then
//      Result := string(Buffer)
//    else
//      Result := '(IPv6 변환 오류)';
  end
  else
    Result := '(알 수 없는 주소 형식)';
end;

function GetEthernetAdapters(var AAdaptorList: string; IncludeDetails: Boolean = False): Boolean;
var
  pAdapterAddresses, pCurrAddresses: PIP_ADAPTER_ADDRESSES;
  ulOutBufLen: ULONG;
  dwRetVal: DWORD;
  pUnicastAddr: PIP_ADAPTER_UNICAST_ADDRESS;
  MacStr, IPStr, LMask: string;
  LEthAdaptorRec: TEthAdaptorRec;
  LIPList, LAdaptorList: IDocList;
  LUtf8: RawUtf8;
  LPrefixLen: Byte;
begin
  Result := False;

  pAdapterAddresses := nil;
  ulOutBufLen := 0;

  // 1단계: 필요한 버퍼 크기 가져오기
  dwRetVal := GetAdaptersAddresses(AF_UNSPEC, // 모든 주소 패밀리 (IPv4, IPv6)
                                   GAA_FLAG_INCLUDE_PREFIX or GAA_FLAG_SKIP_ANYCAST or GAA_FLAG_SKIP_MULTICAST or GAA_FLAG_SKIP_DNS_SERVER, // 플래그 설정
                                   nil, // 예약됨
                                   pAdapterAddresses, // nil 전달
                                   @ulOutBufLen);     // 버퍼 크기 받을 변수 주소

  if dwRetVal = ERROR_BUFFER_OVERFLOW then
  begin
    // 2단계: 필요한 크기만큼 버퍼 할당
    GetMem(pAdapterAddresses, ulOutBufLen);
    try
      // 3단계: 어댑터 정보 가져오기
      dwRetVal := GetAdaptersAddresses(AF_UNSPEC,
                                       GAA_FLAG_INCLUDE_PREFIX or GAA_FLAG_SKIP_ANYCAST or GAA_FLAG_SKIP_MULTICAST or GAA_FLAG_SKIP_DNS_SERVER,
                                       nil,
                                       pAdapterAddresses, // 할당된 버퍼 전달
                                       @ulOutBufLen);

      if dwRetVal = NO_ERROR then
      begin
        LIPList := DocList('[]');
        LAdaptorList := DocList('[]');

        // 4단계: 연결 리스트 순회하며 정보 추출
        pCurrAddresses := pAdapterAddresses;
        while pCurrAddresses <> nil do
        begin
          // 이더넷 타입(IF_TYPE_ETHERNET_CSMACD = 6)이고, 작동 중(IfOperStatusUp = 1)인 어댑터만 필터링
          if (pCurrAddresses.IfType = 6) then// and (pCurrAddresses.OperStatus = IfOperStatusUp) then
          begin
            LEthAdaptorRec := Default(TEthAdaptorRec);
            LEthAdaptorRec.FriendlyName := WideCharToString(pCurrAddresses.FriendlyName);
            LEthAdaptorRec.AdapterName := pCurrAddresses.AdapterName;//MakeStringToBin64(, False);
            LEthAdaptorRec.Description := WideCharToString(pCurrAddresses.Description); // 또는 FriendlyName 사용

            if IncludeDetails then
            begin
               // MAC 주소 추가
              MacStr := MacAddressToString(@pCurrAddresses.PhysicalAddress[0], pCurrAddresses.PhysicalAddressLength);
              LEthAdaptorRec.MadAddr :=MacStr;

              LIPList.Clear;
              // IP 주소 추가 (첫 번째 유니캐스트 주소만 예시로 추가)
              pUnicastAddr := pCurrAddresses.FirstUnicastAddress;
              while pUnicastAddr <> nil do
              begin
                IPStr := IPAddressToString(pUnicastAddr.Address.lpSockaddr);

                //주소 체계 확인 (IPv4 / IPv6)
                if IPStr <> '' then
                begin
                  if pUnicastAddr.Address.lpSockaddr.sa_family = AF_INET then//IPv4
                  begin
                    LPrefixLen := pUnicastAddr.OnLinkPrefixLength;
                    LMask := PrefixLengthToIPv4Mask(LPrefixLen);
                    LIPList.Append(IPStr + ';' + LMask);
                  end
                  else
                  if pUnicastAddr.Address.lpSockaddr.sa_family = AF_INET6 then//IPv6
                  begin

                  end;
                end;
                // 필요하다면 모든 IP 주소를 나열하도록 반복문 수정
                pUnicastAddr := pUnicastAddr.Next;
              end;
              LEthAdaptorRec.IPAddrList := LIPList.Json;
            end;

            LUtf8 := RecordSaveJson(LEthAdaptorRec, TypeInfo(TEthAdaptorRec));
            LAdaptorList.Append(LUtf8);
          end;
          pCurrAddresses := pCurrAddresses.Next; // 다음 어댑터로 이동
        end;

        AAdaptorList := LAdaptorList.Json;
        Result := True; // 성공
      end
      else
      begin
        // GetAdaptersAddresses 재호출 실패 처리
        // (예: 로그 기록, 오류 메시지 표시 등)
        OutputDebugString(PWideChar('GetAdaptersAddresses 재호출 실패: ' + IntToStr(dwRetVal)));
      end;
    finally
      // 5단계: 할당된 메모리 해제
      if pAdapterAddresses <> nil then
        FreeMem(pAdapterAddresses);
    end;
  end
  else if dwRetVal = NO_ERROR then
  begin
     // 어댑터가 하나도 없는 경우 (ulOutBufLen이 0일 수 있음)
     Result := True;
  end
  else
  begin
    // GetAdaptersAddresses 첫 호출 실패 처리
    OutputDebugString(PWideChar('GetAdaptersAddresses 첫 호출 실패 (버퍼 크기 얻기): ' + IntToStr(dwRetVal)));
  end;
end;

function PrefixLengthToIPv4Mask(APrefixLen: Byte): string;
var
  Mask: Cardinal;//32비트 정수형 마스크
  i: integer;
  Bytes: array[0..3] of Byte absolute Mask;  //Cardinal 변수를 바이트 배열처럼 접근
begin
  if APrefixLen > 32 then //유효 범위 검사
    APrefixLen := 32;

  if APrefixLen = 0 then
    Mask := 0
  else
  begin
    //방법1: 비트 쉬프트 사용
    Mask := -$FFFFFFFF;
    Mask := $FFFFFFFF shl (32-APrefixLen); // 모든 비트가 1인 값에서 오른쪽 비트
  end;

  Result := Format('%d.%d.%d.%d', [Bytes[3], Bytes[2], Bytes[1], Bytes[0]]);
end;

function GetIpAddressList2JsonByAdaptorName(const AAdaptorName: string): string;
begin

end;

function GetAdaptorList2JsonUsingIpHelper(): string;
begin

end;

initialization
//  // Winsock 초기화 (프로그램 시작 시 한 번)
//  var WSAData: TWSAData;
//  WSAStartup(MakeWord(2, 2), WSAData);

finalization
//  // Winsock 정리 (프로그램 종료 시 한 번)
//  WSACleanup;

end.
