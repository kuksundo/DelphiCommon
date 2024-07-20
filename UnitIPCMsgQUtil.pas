unit UnitIPCMsgQUtil;

interface

uses SysUtils, OtlCommon, OtlComm;

procedure SendCmd2OmniMsgQ(const ACmd: integer; const AValue: TOmniValue;
  const AOmniMsgQueue: TOmniMessageQueue);

implementation

procedure SendCmd2OmniMsgQ(const ACmd: integer; const AValue: TOmniValue;
  const AOmniMsgQueue: TOmniMessageQueue);
begin
  if not AOmniMsgQueue.Enqueue(TOmniMessage.Create(ACmd, AValue)) then
    raise Exception.Create('SendCmd2OmniMsgQ queue is full!');
end;

end.
