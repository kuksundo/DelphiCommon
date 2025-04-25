unit UnitIpHelper;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.WinSock2, Winapi.IpHlpApi, // WinSock �߰� (inet_addr)
  Winapi.IpTypes,
  mormot.core.variants, mormot.core.json, mormot.core.base
  ;

const
  // �ʿ��� �����
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_NAME_LENGTH = 256;
  MAX_ADAPTER_ADDRESS_LENGTH = 8;
  ERROR_SUCCESS = 0;
  ERROR_BUFFER_OVERFLOW = 111;
  ERROR_ACCESS_DENIED = 5;
  ERROR_NOT_FOUND = 1168; // GetAdaptersInfo ��� ���� �� ����

type
  time_t = LongInt;

  // --- IP Helper API ����ü ���� ---
  TIPAddressString = array[0..4 * 4 - 1] of AnsiChar;

  PIPAddrString = ^TIPAddrString;
  TIPAddrString = record
    Next: PIPAddrString;
    IpAddress: TIPAddressString;
    IpMask: TIPAddressString;
    Context: DWORD;
  end;

  // Adapter ���� ����ü
  PIPAdapterInfo = ^TIPAdapterInfo;
  TIPAdapterInfo = packed record // packed �߿�
    Next: PIPAdapterInfo;
    ComboIndex: DWORD;
    AdapterName: array[0..MAX_ADAPTER_NAME_LENGTH - 1] of AnsiChar;
    Description: array[0..MAX_ADAPTER_DESCRIPTION_LENGTH - 1] of AnsiChar;
    AddressLength: UINT;
    Address: array[0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of Byte;
    Index: DWORD; // �� Index�� �߿�!
    AdapterType: UINT;
    DhcpEnabled: UINT;
    CurrentIpAddress: PIpAddrString; // ��� ���� (GetIpAddrTable ���)
    IpAddressList: TIPAddrString;   // IP �ּ� ��� ����
    GatewayList: TIPAddrString;     // ����Ʈ���� ��� ����
    DhcpServer: TIPAddrString;      // DHCP ���� ����
    HaveWins: BOOL;
    PrimaryWinsServer: TIPAddrString;
    SecondaryWinsServer: TIPAddrString;
    LeaseObtained: time_t;
    LeaseExpires: time_t;
  end;
  TMaxAdapterInfo = TIPAdapterInfo; // �̸� ���ϼ� ���� ���

  // IP �ּ� ���̺� ����ü
  TMibIpAddrRow = packed record // packed �߿�
    dwAddr: DWORD;        // IP Address
    dwIndex: DWORD;       // Adapter Index (TIPAdapterInfo�� Index�� ��Ī)
    dwMask: DWORD;        // Subnet Mask
    dwBCastAddr: DWORD;   // Broadcast Address
    dwReasmSize: DWORD;   // Reassembly Size
    unused1: Word;
    wType: Word;          // MIB_IPADDR_TYPE (Primary, Dynamic, ...)
    NTEContext: ULONG;    // AddIPAddress, DeleteIPAddress���� ���!
    NTEInstance: ULONG;   // AddIPAddress���� ���
  end;
  PMibIpAddrRow = ^TMibIpAddrRow;

  TMaxIpAddrTable = array[0..0] of TMibIpAddrRow; // ���� ũ�� �迭 �����Ϳ�
  PMibIpAddrTable = ^TMibIpAddrTable;
  TMibIpAddrTable = packed record // packed �߿�
    dwNumEntries: DWORD;
    Table: TMaxIpAddrTable; // �����δ� dwNumEntries ��ŭ�� �迭
  end;

// --- IP Helper API �Լ� ���� ---
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
// MAC �ּҸ� ���ڿ��� ��ȯ�ϴ� ���� �Լ�
function MacAddressToString(MacAddr: PByte; AddrLen: ULONG): string;
// IP �ּҸ� ���ڿ��� ��ȯ�ϴ� ���� �Լ� (IPv4/IPv6)
function IPAddressToString(pSockAddr: PSockAddr): string;
// �̴��� ����� ����� �������� �� �Լ�
// AdapterList: string - ����� ������ ���� JsonAry
// IncludeDetails: Boolean - MAC �ּ� �� IP �ּ� ���� ����
// ��ȯ��: ���� �� True, ���� �� False
function GetEthernetAdapters(var AAdaptorList: string; IncludeDetails: Boolean = False): Boolean;
function PrefixLengthToIPv4Mask(APrefixLen: Byte): string;

function GetIpAddressList2JsonByAdaptorName(const AAdaptorName: string): string;
function GetAdaptorList2JsonUsingIpHelper(): string;

// --- WinSock �Լ� ���� (IP ���ڿ� -> DWORD) ---
// Winapi.WinSock ���ֿ� �̹� ����Ǿ� ���� (inet_addr)
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

// �α� ��� �Լ�
procedure TForm1.Log(const Msg: string);
begin
  MemoLog.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) + Msg);
  OutputDebugString(PChar(Msg)); // ����� ��� â���� ǥ��
end;

// IP �ּ� ���ڿ��� DWORD�� ��ȯ
function TForm1.IPStringToDWord(const IPString: string): DWORD;
var
  Addr: AnsiString;
begin
  Addr := AnsiString(IPString); // inet_addr�� PAnsiChar�� ����
  Result := inet_addr(PAnsiChar(Addr));
  if Result = INADDR_NONE then // INADDR_NONE = $FFFFFFFF
    Log('���: IP �ּ� ���� ���� �Ǵ� 255.255.255.255 - ' + IPString);
end;

// ����� ������ ������� ����� �ε��� ã��
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

  // 1. �ʿ��� ���� ũ�� ���
  dwResult := GetAdaptersInfo(nil, OutBufLen);
  if (dwResult <> ERROR_SUCCESS) and (dwResult <> ERROR_BUFFER_OVERFLOW) then
  begin
    Log('GetAdaptersInfo (size query) ����: ' + SysErrorMessage(dwResult));
    Exit;
  end;

  // 2. ���� �Ҵ� �� ���� ���
  GetMem(pAdapterInfo, OutBufLen);
  try
    dwResult := GetAdaptersInfo(pAdapterInfo, OutBufLen);
    if dwResult <> ERROR_SUCCESS then
    begin
      Log('GetAdaptersInfo ����: ' + SysErrorMessage(dwResult));
      Exit;
    end;

    // 3. ����� ��� ��ȸ�ϸ� ���� ��
    pCurrAdapter := pAdapterInfo;
    AdapterDescAnsi := AnsiString(Desc); // �񱳸� ���� AnsiString���� ��ȯ

    while pCurrAdapter <> nil do
    begin
      // AnsiChar �迭�� AnsiString �� (��ҹ��� ���� �� ��)
      if AnsiSameText(Trim(String(pCurrAdapter^.Description)), Trim(AdapterDescAnsi)) then
      begin
        Index := pCurrAdapter^.Index;
        Result := True;
        Log('����� ã��: "' + Desc + '" (�ε���: ' + IntToStr(Index) + ')');
        Break; // ã������ ����
      end;
      pCurrAdapter := pCurrAdapter^.Next; // ���� ����ͷ� �̵�
    end;

    if not Result then
      Log('����� ���� "' + Desc + '"��(��) ã�� �� �����ϴ�.');

  finally
    if pAdapterInfo <> nil then
      FreeMem(pAdapterInfo);
  end;
end;

// Ư�� ����Ϳ� �Ҵ�� (���� ������ Ÿ����) ��� IP �ּ� ����
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
  Result := False; // �⺻�� ����
  bDeleted := False; // �ϳ��� ���� �����ߴ��� ����
  pIpAddrTable := nil;
  dwSize := 0;

  Log(Format('����� �ε��� %d�� ���� IP �ּ� ���� �õ�...', [AdapterIndex]));

  // 1. �ʿ��� ���� ũ�� ���
  dwResult := GetIpAddrTable(nil, dwSize, False);
  if (dwResult <> ERROR_SUCCESS) and (dwResult <> ERROR_BUFFER_OVERFLOW) then
  begin
    Log('GetIpAddrTable (size query) ����: ' + SysErrorMessage(dwResult));
    Exit;
  end;

  // 2. ���� �Ҵ� �� ���̺� ���
  GetMem(pIpAddrTable, dwSize);
  try
    dwResult := GetIpAddrTable(pIpAddrTable, dwSize, False);
    if dwResult <> ERROR_SUCCESS then
    begin
      Log('GetIpAddrTable ����: ' + SysErrorMessage(dwResult));
      Exit;
    end;

    // 3. ���̺� ��ȸ�ϸ� �ش� �ε����� IP ���� �õ�
    Log(Format('�� %d���� IP �׸� Ȯ�� ��...', [pIpAddrTable^.dwNumEntries]));
    for i := 0 to pIpAddrTable^.dwNumEntries - 1 do
    begin
      // �迭 ������ ���� ��� ����
      // PMibIpAddrRow Ÿ������ ĳ���� �� �ε����� ����
      Row := @(pIpAddrTable^.Table[i]);

      if Row^.dwIndex = AdapterIndex then
      begin
        LInAddr.S_addr := Row^.dwAddr;
        LInAddr.S_addr := ntohl(LInAddr.S_addr);
        // ���� �õ� (NTEContext ���)
        Log(Format(' - �ε��� %d�� IP %s (NTE Context: %u) ���� �õ�...',
               [AdapterIndex, inet_ntoa(LInAddr), Row^.NTEContext])); // inet_ntoa ����� ���� WinSock �ʿ�

        dwResult := DeleteIPAddress(Row^.NTEContext);
        if dwResult = ERROR_SUCCESS then
        begin
          Log('   -> ���� ����.');
          bDeleted := True;
        end
        else if dwResult = ERROR_ACCESS_DENIED then
        begin
          Log('   -> ���� ����: ���� �ź� (������ ���� �ʿ�).');
          // ���� �ź� �� �� �̻� �õ� �ǹ� ���� �� �����Ƿ� ���� ���
          Exit; // �Լ� ����
        end
        else
        begin
          // �ٸ� ���� (��: ���� IP�� ���� �Ұ� ��)
          Log(Format('   -> ���� ����: ���� �ڵ� %d (%s)', [dwResult, SysErrorMessage(dwResult)]));
        end;
      end;
    end;

    // �ϳ��� ���������� �����߰ų�, ���� �������� �������� ������ �� ����
    // ���⼭�� ���� �õ��� �־��� Access Denied�� �ƴϾ��ٸ� �ϴ� �������� ó��
    Result := True; // ���� �õ��� ���������� �̷�����ٸ� True ��ȯ (���� ���� ���� ���οʹ� ������ �� ����)

  finally
    if pIpAddrTable <> nil then
      FreeMem(pIpAddrTable);
  end;
end;

// �� ���� �� �ʱ�ȭ
procedure TForm1.FormCreate(Sender: TObject);
begin
  // ���� �� (����� ȯ�濡 �°� ���� �ʿ�)
  EditInterfaceDesc.Text := 'Realtek PCIe GbE Family Controller'; // ��ġ ������ �Ǵ� ipconfig /all ���� Ȯ��
  EditIP.Text := '192.168.0.150';
  EditSubnet.Text := '255.255.255.0';
  Log('���ø����̼� ����. ������ �������� �����ߴ��� Ȯ���ϼ���.');
end;

// ���� IP ���� ��ư Ŭ��
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
    Log('����: ��Ʈ��ũ ����� ������ �Է��ϼ���.');
    Exit;
  end;

  if (Trim(EditIP.Text) = '') or (Trim(EditSubnet.Text) = '') then
  begin
    Log('����: IP �ּҿ� ����� ����ũ�� �Է��ϼ���.');
    Exit;
  end;

  Log('���� IP ���� ����: ' + AdapterDesc);

  // 1. ����� �ε��� ã��
  if not GetAdapterIndexByDesc(AdapterDesc, AdapterIndex) then
  begin
    Log('����: ����� �ε����� ã�� �� �����ϴ�.');
    Exit;
  end;

  // 2. (���� ����/����) ���� IP �ּ� ����
  // ����: DHCP�� �Ҵ�� IP�� ���� DeleteIPAddress�� �������� �ʽ��ϴ�.
  //       ���� IP�� ���� �� ������ �� �����Ƿ�, ���� ���� IP�� ���� ����� ���� �����ϴ�.
  if not DeleteIPsForAdapter(AdapterIndex) then
  begin
     // Access Denied ���� �ɰ��� ���� �� ���⼭ �ߴ� ����
     Log('���: ���� IP �ּ� ���� �� ������ �߻��߽��ϴ�. ��� �����մϴ�.');
     // Access Denied������ AddIPAddress�� ������ ���ɼ� ����
  end;

  // 3. �� IP �ּ� �� ����ũ ��ȯ
  NewIP := IPStringToDWord(Trim(EditIP.Text));
  NewMask := IPStringToDWord(Trim(EditSubnet.Text));

  if (NewIP = 0) or (NewIP = INADDR_NONE) or (NewMask = 0) or (NewMask = INADDR_NONE) then
  begin
     Log('����: ��ȿ���� ���� IP �ּ� �Ǵ� ����� ����ũ�Դϴ�.');
     Exit;
  end;

  // 4. �� IP �ּ� �߰�
  Log(Format('AddIPAddress ȣ��: IP=%s, Mask=%s, Index=%d',
         [EditIP.Text, EditSubnet.Text, AdapterIndex]));

  NTEContext := 0;
  NTEInstance := 0;
  dwResult := AddIPAddress(NewIP, NewMask, AdapterIndex, NTEContext, NTEInstance);

  if dwResult = ERROR_SUCCESS then
  begin
    Log(Format('AddIPAddress ����! NTE Context: %u, NTE Instance: %u', [NTEContext, NTEInstance]));
    Log('���� IP ���� �Ϸ�. (����Ʈ����/DNS�� ���� ���� �ʿ�)');
    // ����Ʈ���� ���� ���� �߰� �ʿ� (CreateIpForwardEntry ��)
    // DNS ���� ���� �߰� �ʿ�
  end
  else if dwResult = ERROR_ACCESS_DENIED then
  begin
    Log('AddIPAddress ����: ���� �ź� (������ �������� ������� �ʾҽ��ϴ�).');
    ShowMessage('������ �������� ���α׷��� �����ؾ� �մϴ�!');
  end
  else
  begin
    Log(Format('AddIPAddress ����: ���� �ڵ� %d (%s)', [dwResult, SysErrorMessage(dwResult)]));
  end;
end;

// DHCP ���� ��ư Ŭ��
procedure TForm1.ButtonSetDHCPClick(Sender: TObject);
var
  AdapterDesc: string;
  AdapterIndex: DWORD;
begin
  AdapterDesc := Trim(EditInterfaceDesc.Text);
  if AdapterDesc = '' then
  begin
    Log('����: ��Ʈ��ũ ����� ������ �Է��ϼ���.');
    Exit;
  end;

  Log('DHCP ���� ���� (���� ���� IP ���� �õ�): ' + AdapterDesc);

  // 1. ����� �ε��� ã��
  if not GetAdapterIndexByDesc(AdapterDesc, AdapterIndex) then
  begin
    Log('����: ����� �ε����� ã�� �� �����ϴ�.');
    Exit;
  end;

  // 2. �ش� ������� ��� (���� ������) IP �ּ� ����
  if DeleteIPsForAdapter(AdapterIndex) then
  begin
     Log('���� IP �ּ� ���� �õ� �Ϸ�. �ý����� DHCP �����κ��� �� IP�� �޾ƾ� �մϴ�.');
     Log('����: �� ��������δ� DHCP Ŭ���̾�Ʈ ������ �Ϻ����� ���� �� �ֽ��ϴ�.');
     Log('      netsh interface ip set address name="' + AdapterDesc + '" dhcp ��ɾ �� Ȯ���� �� �ֽ��ϴ�.');
  end
  else
  {
    // DeleteIPsForAdapter ���ο��� �̹� �α� ��ϵ�
    // if GetLastError = ERROR_ACCESS_DENIED then ... �� �߰� ó�� ����
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

// IP �ּҸ� ���ڿ��� ��ȯ�ϴ� ���� �Լ� (IPv4/IPv6)
function IPAddressToString(pSockAddr: PSockAddr): string;
const
  INET6_ADDRSTRLEN = 46; // IPv6 �ּ� ���ڿ� �ִ� ���� (WinSock2.pas�� ���� ���)
var
  Buffer: array[0..INET6_ADDRSTRLEN - 1] of Char; // WSAAddressToString �� ����
  dwLen: DWORD;
  pAddr: PVOID;
begin
  Result := '';
  if pSockAddr = nil then Exit;

  dwLen := INET6_ADDRSTRLEN; // ���� ũ�� �ʱ�ȭ

  // �ּ� �йи��� ���� ���� �ּ� ������ ����
  if pSockAddr.sa_family = AF_INET then // IPv4
  begin
    pAddr := @(PSockAddrIn(pSockAddr).sin_addr);
    // inet_ntop ��� (WS2_32.dll �ʿ�, �ֽ� ������ ����)
    // Result := Winapi.WinSock2.inet_ntop(AF_INET, pAddr, Buffer, dwLen);
    // �Ǵ� WSAAddressToString ��� (�� �����ϰ� ������)
    if WSAAddressToString(TSockAddr(pSockAddr^), SizeOf(TSockAddrIn), nil, Buffer, dwLen) = 0 then
      Result := string(Buffer)
    else
      Result := '(IPv4 ��ȯ ����)';
  end
  else if pSockAddr.sa_family = AF_INET6 then // IPv6
  begin
//    pAddr := @(PSockAddrIn6(pSockAddr).sin6_addr);
//    // inet_ntop ���
//    // Result := Winapi.WinSock2.inet_ntop(AF_INET6, pAddr, Buffer, dwLen);
//     // �Ǵ� WSAAddressToString ���
//    if WSAAddressToString(pSockAddr, SizeOf(TSockAddrIn6), nil, Buffer, @dwLen) = 0 then
//      Result := string(Buffer)
//    else
//      Result := '(IPv6 ��ȯ ����)';
  end
  else
    Result := '(�� �� ���� �ּ� ����)';
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

  // 1�ܰ�: �ʿ��� ���� ũ�� ��������
  dwRetVal := GetAdaptersAddresses(AF_UNSPEC, // ��� �ּ� �йи� (IPv4, IPv6)
                                   GAA_FLAG_INCLUDE_PREFIX or GAA_FLAG_SKIP_ANYCAST or GAA_FLAG_SKIP_MULTICAST or GAA_FLAG_SKIP_DNS_SERVER, // �÷��� ����
                                   nil, // �����
                                   pAdapterAddresses, // nil ����
                                   @ulOutBufLen);     // ���� ũ�� ���� ���� �ּ�

  if dwRetVal = ERROR_BUFFER_OVERFLOW then
  begin
    // 2�ܰ�: �ʿ��� ũ�⸸ŭ ���� �Ҵ�
    GetMem(pAdapterAddresses, ulOutBufLen);
    try
      // 3�ܰ�: ����� ���� ��������
      dwRetVal := GetAdaptersAddresses(AF_UNSPEC,
                                       GAA_FLAG_INCLUDE_PREFIX or GAA_FLAG_SKIP_ANYCAST or GAA_FLAG_SKIP_MULTICAST or GAA_FLAG_SKIP_DNS_SERVER,
                                       nil,
                                       pAdapterAddresses, // �Ҵ�� ���� ����
                                       @ulOutBufLen);

      if dwRetVal = NO_ERROR then
      begin
        LIPList := DocList('[]');
        LAdaptorList := DocList('[]');

        // 4�ܰ�: ���� ����Ʈ ��ȸ�ϸ� ���� ����
        pCurrAddresses := pAdapterAddresses;
        while pCurrAddresses <> nil do
        begin
          // �̴��� Ÿ��(IF_TYPE_ETHERNET_CSMACD = 6)�̰�, �۵� ��(IfOperStatusUp = 1)�� ����͸� ���͸�
          if (pCurrAddresses.IfType = 6) then// and (pCurrAddresses.OperStatus = IfOperStatusUp) then
          begin
            LEthAdaptorRec := Default(TEthAdaptorRec);
            LEthAdaptorRec.FriendlyName := WideCharToString(pCurrAddresses.FriendlyName);
            LEthAdaptorRec.AdapterName := pCurrAddresses.AdapterName;//MakeStringToBin64(, False);
            LEthAdaptorRec.Description := WideCharToString(pCurrAddresses.Description); // �Ǵ� FriendlyName ���

            if IncludeDetails then
            begin
               // MAC �ּ� �߰�
              MacStr := MacAddressToString(@pCurrAddresses.PhysicalAddress[0], pCurrAddresses.PhysicalAddressLength);
              LEthAdaptorRec.MadAddr :=MacStr;

              LIPList.Clear;
              // IP �ּ� �߰� (ù ��° ����ĳ��Ʈ �ּҸ� ���÷� �߰�)
              pUnicastAddr := pCurrAddresses.FirstUnicastAddress;
              while pUnicastAddr <> nil do
              begin
                IPStr := IPAddressToString(pUnicastAddr.Address.lpSockaddr);

                //�ּ� ü�� Ȯ�� (IPv4 / IPv6)
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
                // �ʿ��ϴٸ� ��� IP �ּҸ� �����ϵ��� �ݺ��� ����
                pUnicastAddr := pUnicastAddr.Next;
              end;
              LEthAdaptorRec.IPAddrList := LIPList.Json;
            end;

            LUtf8 := RecordSaveJson(LEthAdaptorRec, TypeInfo(TEthAdaptorRec));
            LAdaptorList.Append(LUtf8);
          end;
          pCurrAddresses := pCurrAddresses.Next; // ���� ����ͷ� �̵�
        end;

        AAdaptorList := LAdaptorList.Json;
        Result := True; // ����
      end
      else
      begin
        // GetAdaptersAddresses ��ȣ�� ���� ó��
        // (��: �α� ���, ���� �޽��� ǥ�� ��)
        OutputDebugString(PWideChar('GetAdaptersAddresses ��ȣ�� ����: ' + IntToStr(dwRetVal)));
      end;
    finally
      // 5�ܰ�: �Ҵ�� �޸� ����
      if pAdapterAddresses <> nil then
        FreeMem(pAdapterAddresses);
    end;
  end
  else if dwRetVal = NO_ERROR then
  begin
     // ����Ͱ� �ϳ��� ���� ��� (ulOutBufLen�� 0�� �� ����)
     Result := True;
  end
  else
  begin
    // GetAdaptersAddresses ù ȣ�� ���� ó��
    OutputDebugString(PWideChar('GetAdaptersAddresses ù ȣ�� ���� (���� ũ�� ���): ' + IntToStr(dwRetVal)));
  end;
end;

function PrefixLengthToIPv4Mask(APrefixLen: Byte): string;
var
  Mask: Cardinal;//32��Ʈ ������ ����ũ
  i: integer;
  Bytes: array[0..3] of Byte absolute Mask;  //Cardinal ������ ����Ʈ �迭ó�� ����
begin
  if APrefixLen > 32 then //��ȿ ���� �˻�
    APrefixLen := 32;

  if APrefixLen = 0 then
    Mask := 0
  else
  begin
    //���1: ��Ʈ ����Ʈ ���
    Mask := -$FFFFFFFF;
    Mask := $FFFFFFFF shl (32-APrefixLen); // ��� ��Ʈ�� 1�� ������ ������ ��Ʈ
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
//  // Winsock �ʱ�ȭ (���α׷� ���� �� �� ��)
//  var WSAData: TWSAData;
//  WSAStartup(MakeWord(2, 2), WSAData);

finalization
//  // Winsock ���� (���α׷� ���� �� �� ��)
//  WSACleanup;

end.
