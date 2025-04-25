unit UnitLanUtil2;

interface

uses System.SysUtils, Classes, Windows, WinSock2, ShellAPI;

//아이피주소(IPv4) 문자열을 정수(UInt32)로
function IPAddr2Long(AIpAddr: string): UInt32;
//정수를 아이피주소(IPv4) 문자열로
function Long2IPAddr(AIpLong: UInt32): string;
function ExtractHostFromUrl(const AUrl: string): string;

procedure SetStaticIP(const AdapterName, IPAddress, SubnetMask, Gateway: string);
procedure SetDHCP(const AdapterName: string);
procedure OpenNetworkConnectionsUsingCPL();

implementation

function IPAddr2Long(AIpAddr: string): UInt32;
begin
  Result := inet_addr(PAnsiChar(AIpAddr));
  Result := htonl(Result);
end;

function Long2IPAddr(AIpLong: UInt32): string;
var
  LInAddr: in_addr;
begin
  LInAddr.S_addr := AIpLong;
  LInAddr.S_addr := ntohl(LInAddr.S_addr);
  Result := inet_ntoa(LInAddr);
end;

function ExtractHostFromUrl(const AUrl: string): string;
var
  StartPos, EndPos: integer;
  TempUrl: string;
begin
  Result := '';
  TempUrl := AUrl;

  if Pos('://', TempUrl) > 0 then
    Delete(TempUrl, 1, Pos('://', TempUrl) +2);

  StartPos := 1;
  EndPos := Pos('/', TempUrl);

  if EndPos = 0 then
    EndPos := Length(TempUrl) + 1;

  Result := Copy(TempUrl, StartPos, EndPos - StartPos);
end;

procedure SetStaticIP(const AdapterName, IPAddress, SubnetMask, Gateway: string);
var
  Cmd: string;
begin
  // netsh 명령어 구성
  Cmd := Format(
    'netsh interface ip set address name="%s" static %s %s %s 1',
    [AdapterName, IPAddress, SubnetMask, Gateway]);

  ShellExecute(0, 'runas', 'cmd.exe', PChar('/c ' + Cmd), nil, SW_HIDE);
end;

procedure SetDHCP(const AdapterName: string);
var
  Cmd: string;
begin
  Cmd := Format('netsh interface ip set address name="%s" dhcp', [AdapterName]);
  ShellExecute(0, 'runas', 'cmd.exe', PChar('/c ' + Cmd), nil, SW_HIDE);
end;

procedure OpenNetworkConnectionsUsingCPL;
begin
//  ShellExecute(0, 'open', 'ncpa.cpl', nil, nil, SW_SHOWNORMAL);
  ShellExecute(0, 'open',
    'rundll32.exe',
    'shell32.dll,Control_RunDLL ncpa.cpl',
    nil, SW_SHOWNORMAL);
end;

end.
