unit UnitLanUtil2;

interface

uses System.SysUtils, Classes, WinSock2;

//아이피주소(IPv4) 문자열을 정수(UInt32)로
function IPAddr2Long(AIpAddr: string): UInt32;
//정수를 아이피주소(IPv4) 문자열로
function Long2IPAddr(AIpLong: UInt32): string;

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

end.
