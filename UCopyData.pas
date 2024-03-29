unit UCopyData;

interface

uses Windows, Messages, SysUtils, System.Classes;

Const
  WParam_SENDWINHANDLE = 100;
  WParam_RECVHANDLEOK =  101;
  WParam_DISPLAYMSG = 102;
  WParam_FORMCLOSE = 103;
  WParam_REQMULTIRECORD = 104;
  WParam_CHANGECOPYMODE = 105;
  WM_MULTICOPY_BEGIN = 106;
  WM_MULTICOPY_END = 107;
  WM_CABLEROUTEFORMCLOSE = 108;

type
  PCopyDataStruct = ^TCopyDataStruct;
  TCopyDataStruct = record
    dwData: LongInt;
    cbData: LongInt;
    lpData: Pointer;
  end;

  PRecToPass = ^TRecToPass;
  TRecToPass = record
    StrMsg : array[0..255] of char;
    StrSrcFormName : array[0..255] of char;
    iHandle : integer;
  end;

  PKbdShiftRec = ^TKbdShiftRec;
  TKbdShiftRec = record
    iHandle : THandle;
    MyHandle: THandle;
    FKbdShift: TShiftState;
    ParamDragMode: integer;
  end;

  function SendCopyData(FromFormName, ToFormName, Msg: string; MsgType: integer):integer;
  procedure SendCopyData2(ToHandle: integer; Msg: string; MsgType: integer);
  procedure SendHandleCopyData(AToHandle: integer; AMyHandle: THandle;
    AWaram: integer);
  procedure SendHandleCopyDataWithShift(AToHandle: integer; AMyHandle: THandle;
    AWaram: integer; AShift: TShiftState; ADragMode: integer);

var
  FormName: string;   //메세지를 수신할 폼 이름
  msgHandle: THandle; //메세지를 보낼 폼 핸들

implementation

//메세지 디스플레이에 필요한 폼 이름과 핸들을 할당한다.
//본 Unit을 사용하는 Unit애서 한번은 꼭 시행해야 함
//FormName: 메세지를 받을 Form Name
//msgHandle: 메세지를 보내는 놈의 Form Handle(통상 0로 함)
procedure UnitInit(_FormName: string; _msgHandle: THandle);
begin
  FormName := _FormName;
  msgHandle := _msgHandle;
end;

//FromFormName: 메세지를 보내는 폼의 이름, 널값 가능
//ToFormName: 메세지를 받는 폼의 이름, 널값 불가
//Msg: 보내고자 하는 메세지
//SrcHandle:메세지를 보내는 폼의 핸들,Form1.Handle
//Result: ToForm Handle
function SendCopyData(FromFormName, ToFormName, Msg: string; MsgType: integer):integer;
var
  h : THandle;
  fname:array[0..255] of char;
  pfName: PChar;
  cd : TCopyDataStruct;
  rec : TRecToPass;
begin
  if ToFormName = '' then
    exit;
  pfName := @fname[0];
  StrPCopy(pfName,ToFormName);
  h := FindWindow(nil, pfName);
  if h <> 0 then
  begin
    with rec, cd do
    begin
      if Msg <> '' then
        StrPCopy(StrMsg,Msg);

      if FromFormName <> '' then
        StrPCopy(StrSrcFormName,FromFormName);

      iHandle := MsgType;
      dwData := 3232;
      cbData := sizeof(rec);
      lpData := @rec;
    end;//with

    SendMessage(h, WM_COPYDATA, 0, LongInt(@cd));
    Result := h;
  end;//if
end;

//ToHandle: 메세지를 수신할 폼의 핸들
//Msg: 전달할 문자열
//iMag: 전달할 정수
procedure SendCopyData2(ToHandle: integer; Msg: string; MsgType: integer);
var
  cd : TCopyDataStruct;
  rec : TRecToPass;
begin
  with rec, cd do
  begin
    if Msg <> '' then
      StrPCopy(StrMsg,Msg);

    iHandle := MsgType;

    dwData := 3232;
    cbData := sizeof(rec);
    lpData := @rec;
  end;//with

  SendMessage(ToHandle, WM_COPYDATA, WParam_DISPLAYMSG, LongInt(@cd));
end;

//상단 const 참조
procedure SendHandleCopyData(AToHandle: integer; AMyHandle: THandle;
  AWaram: integer);
var
  cd : TCopyDataStruct;
  rec : TKbdShiftRec;
begin
  with cd do
  begin
    dwData := AToHandle;
    cbData := sizeof(rec);//AMyHandle;
    rec.MyHandle := AMyHandle;
    lpData := @rec;
  end;//with

  SendMessage(AToHandle, WM_COPYDATA, AWaram, LongInt(@cd));
end;

//키 상태를 전송함
procedure SendHandleCopyDataWithShift(AToHandle: integer; AMyHandle: THandle;
    AWaram: integer; AShift: TShiftState; ADragMode: integer);
var
  cd : TCopyDataStruct;
  rec : TKbdShiftRec;
begin
  with cd do
  begin
    dwData := AToHandle;
    cbData := sizeof(rec);//AMyHandle;
    rec.FKbdShift := AShift;
    rec.MyHandle := AMyHandle;
    rec.ParamDragMode := ADragMode;
//    rec.iHandle := 1;
    lpData := @rec;
  end;//with

  SendMessage(AToHandle, WM_COPYDATA, AWaram, LongInt(@cd));
end;

end.
