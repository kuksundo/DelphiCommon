unit UnitSharedMMUtil;

interface

uses Windows, Messages, SysUtils, mormot.core.base;

const
  WM_SHARED_MEM_DATA_READY = WM_USER + 9999;
  DEFAULT_SHARED_MEM_NAME = 'MySharedMemory';
  DEFAULT_MAX_SHARED_MEM_SIZE = 10 * 1024 * 1024; // 10MB

type
  TJHP_ShareMM_Util = class
  public
    class var FShareMMName: string;
    class var FShareMMMaxSize: int64;
    class var FShareMMStrData: RawByteString;

    class function Encrypt2Base64(const AData: string): RawByteString; overload;
    class function Encrypt2Base64(const AData: RawUtf8): RawByteString; overload;
    class function Encrypt2Base64(const AData: AnsiString): RawByteString; overload;

    class function GetFromBase64(const ABase64: RawByteString; var AData: string): integer; overload;
    class function GetFromBase64(const ABase64: RawByteString; var AData: RawUtf8): integer; overload;
    class function GetFromBase64(const ABase64: RawByteString; var AData: AnsiString): integer; overload;

    class procedure SendData2SMM(TargetWnd: HWND; const Data: RawByteString;
      const AIndex: integer; ASMMName: string='');
    class function RecvDataFromSMM(var Msg: TMessage): integer;
  end;

implementation

class function TJHP_ShareMM_Util.Encrypt2Base64(
  const AData: string): RawByteString;
begin

end;

class function TJHP_ShareMM_Util.Encrypt2Base64(
  const AData: RawUtf8): RawByteString;
begin

end;

class function TJHP_ShareMM_Util.Encrypt2Base64(
  const AData: AnsiString): RawByteString;
begin

end;

class function TJHP_ShareMM_Util.GetFromBase64(const ABase64: RawByteString;
  var AData: string): integer;
begin

end;

class function TJHP_ShareMM_Util.GetFromBase64(const ABase64: RawByteString;
  var AData: RawUtf8): integer;
begin

end;

class function TJHP_ShareMM_Util.GetFromBase64(const ABase64: RawByteString;
  var AData: AnsiString): integer;
begin

end;

class function TJHP_ShareMM_Util.RecvDataFromSMM(var Msg: TMessage): integer;
var
  hMap: THandle;
  pMem: Pointer;
  Data: RawByteString;
begin
  Result := -1;

  if Msg.Msg = WM_SHARED_MEM_DATA_READY then
  begin
    // 1. 메모리 맵 열기
    hMap := OpenFileMapping(FILE_MAP_READ, False, PChar(TJHP_ShareMM_Util.FShareMMName));

    if hMap = 0 then Exit;

    try
      // 2. 읽기 전용 매핑
      pMem := MapViewOfFile(hMap, FILE_MAP_READ, 0, 0, 0);

      if pMem = nil then Exit;

      try
        // 3. 데이터 복사 (Msg.WParam = 데이터 크기)
        SetLength(Data, Msg.WParam);
        Move(pMem^, Data[1], Msg.WParam);
        FShareMMStrData := Data;
        Result := Length(Data);
        // 4. 출력 테스트
//        ShowMessage('Received: ' + Copy(Data, 1, 200)); // 일부만 표시
      finally
        UnmapViewOfFile(pMem);
      end;
    finally
      CloseHandle(hMap);
    end;
  end
  else
    inherited;
end;

class procedure TJHP_ShareMM_Util.SendData2SMM(TargetWnd: HWND; const Data: RawByteString;
  const AIndex: integer; ASMMName: string);
var
  hMap: THandle;
  pMem: Pointer;
begin
  if ASMMName = '' then
    ASMMName := TJHP_ShareMM_Util.FShareMMName;

  if Length(Data) > TJHP_ShareMM_Util.FShareMMMaxSize then
    raise Exception.Create('Data too large');

  // 1. 메모리 맵 생성
  hMap := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE,
                            0, TJHP_ShareMM_Util.FShareMMMaxSize, PChar(ASMMName));

  if hMap = 0 then
    RaiseLastOSError;

  try
    // 2. 매핑된 메모리 주소 획득
    pMem := MapViewOfFile(hMap, FILE_MAP_WRITE, 0, 0, 0);
    if pMem = nil then
      RaiseLastOSError;

    try
      // 3. 데이터 복사
      Move(Data[1], pMem^, Length(Data));

      // 4. 수신자에게 “데이터 준비됨” 메시지 보냄
      PostMessage(TargetWnd, WM_SHARED_MEM_DATA_READY, Length(Data), AIndex);
    finally
      UnmapViewOfFile(pMem);
    end;

  finally
    CloseHandle(hMap);
  end;
end;

end.
