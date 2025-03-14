unit UnitLanUtil2;

interface

uses System.SysUtils, Classes, WinSock2;

//�������ּ�(IPv4) ���ڿ��� ����(UInt32)��
function IPAddr2Long(AIpAddr: string): UInt32;
//������ �������ּ�(IPv4) ���ڿ���
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
