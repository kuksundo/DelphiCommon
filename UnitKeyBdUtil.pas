unit UnitKeyBdUtil;
//KeyBoard 관련 함수는 DelphiDabbleer/Sendkey32.pas를 참조 할 것.
interface

Uses System.SysUtils, Windows, Messages;

function GetCharFromVKey(vkey: Word): string;
function GetVKeyFromChar(AChar: string): Cardinal;
function KeyToString(aCode: Cardinal): string;
function StringToKey(S: string): Cardinal;

procedure SendAltNChar(AChar: Char);


implementation

function GetCharFromVKey(vkey: Word): string;
var
  keystate: TKeyboardState;
  retcode: Integer;
begin
  Result := '';
  Win32Check(GetKeyboardState(keystate));
{$IFDEF UNICODE}
  SetLength(Result, 256);
  ZeroMemory(@Result[1], SizeOf(Result));
  retcode := ToUnicode(vkey, MapVirtualKey(vkey, 0), keystate, @Result[1], Length(Result), 0);
{$ELSE}
  SetLength(Result, 2);
  retcode := ToAsciiEx(vkey,
    MapVirtualKey(vkey, 0),
    keystate, @Result[1],
    0,0);
{$ENDIF}
  case retcode of
    0: Result := ''; // no character
    1: SetLength(Result, 1);
    2:;
    else
      Result := ''; // retcode < 0 indicates a dead key
  end;
end;

function GetVKeyFromChar(AChar: string): Cardinal;
begin
  Result := MapVirtualKey(Ord(AChar[1]), 0);
end;

function KeyToString(aCode: Cardinal): string;
begin
  case aCode of
    7745: Result := 'a';
    12354: Result := 'b';
    11843: Result := 'c';
    8260: Result := 'd';
    4677: Result := 'e';
    8518: Result := 'f';
    8775: Result := 'g';
    9032: Result := 'h';
    5961: Result := 'i';
    9290: Result := 'j';
    9547: Result := 'k';
    9804: Result := 'l';
    12877: Result := 'm';
    12622: Result := 'n';
    6223: Result := 'o';
    6480: Result := 'p';
    4177: Result := 'q';
    4946: Result := 'r';
    8019: Result := 's';
    5204: Result := 't';
    5717: Result := 'u';
    12118: Result := 'v';
    4439: Result := 'w';
    11608: Result := 'x';
    5465: Result := 'y';
    11354: Result := 'z';
  else
    Result := IntToStr(aCode);
  end;
end;

function StringToKey(S: string): Cardinal;
var
  c: Char;
begin
  if length(S) = 1 then
  begin
    c := S[1];
    case c of
      'a': Result := 7745;
      'b': Result := 12354;
      'c': Result := 11843;
      'd': Result := 8260;
      'e': Result := 4677;
      'f': Result := 8518;
      'g': Result := 8775;
      'h': Result := 9032;
      'i': Result := 5961;
      'j': Result := 9290;
      'k': Result := 9547;
      'l': Result := 9804;
      'm': Result := 12877;
      'n': Result := 12622;
      'o': Result := 6223;
      'p': Result := 6480;
      'q': Result := 4177;
      'r': Result := 4946;
      's': Result := 8019;
      't': Result := 5204;
      'u': Result := 5717;
      'v': Result := 12118;
      'w': Result := 4439;
      'x': Result := 11608;
      'y': Result := 5465;
      'z': Result := 11354;
    else
      Result := StrToInt(S);
    end;
  end
  else
  begin
    Result := StrToInt(S);
  end;
end;

procedure SendAltNChar(AChar: Char);
var
  LKeyInputs: array of TInput;

  procedure KeyBdInput(AKey: Byte; AFlags: DWORD);
  begin
    SetLength(LKeyInputs, Length(LKeyInputs)+1);
    LKeyInputs[High(LKeyInputs)].Itype := INPUT_KEYBOARD;

    with LKeyInputs[High(LKeyInputs)].ki do
    begin
      wVk := AKey;
      wScan := MapVirtualKey(wVk, 0);
      dwFlags := AFlags;
    end;
  end;
begin
  KeyBdInput(VK_MENU, 0); //Alt Key
  KeyBdInput(Ord(AChar), 0);
  KeyBdInput(Ord(AChar), KEYEVENTF_KEYUP);
  KeyBdInput(VK_MENU, KEYEVENTF_KEYUP);
  SendInput(Length(LKeyInputs), LKeyInputs[0], SizeOf(LKeyInputs[0]));
end;


end.
