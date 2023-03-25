unit UnitBase64Util2;

interface

uses System.Classes, Dialogs, System.Rtti, DateUtils, System.SysUtils,
  mormot.core.base,
  mormot.core.buffers,
  mormot.core.os;

function MakeRawUTF8ToBin64(AUTF8: RawUTF8; AIsCompress: Boolean = True): RawUTF8;
function MakeRawByteStringToBin64(ARaw: RawByteString; AIsCompress: Boolean = True): RawUTF8;
function MakeBase64ToString(AStr: RawUTF8; AIsCompress: Boolean = True): string;
function MakeBase64ToUTF8(AStr: RawUTF8; AIsCompress: Boolean = True): RawUTF8;
function GetBase64ByFileName(AFileName: RawUTF8; AIsCompress: Boolean = True): RawUTF8;
function FileToBase64(const AFileName: RawUTF8): RawUTF8;

implementation

function MakeRawUTF8ToBin64(AUTF8: RawUTF8; AIsCompress: Boolean = True): RawUTF8;
var
  LRaw: RawByteString;
begin
  LRaw := AUTF8;
  Result := MakeRawByteStringToBin64(LRaw, AIsCompress);
end;

function MakeRawByteStringToBin64(ARaw: RawByteString; AIsCompress: Boolean = True): RawUTF8;
var
  LUTF8 : RawUTF8;
  LRaw: RawByteString;
  LStr: string;
begin
  if AIsCompress then
    ARaw := SynLZCompress(ARaw);

  LUTF8 := BinToBase64(ARaw);
  Result := LUTF8;
end;

function MakeBase64ToString(AStr: RawUTF8; AIsCompress: Boolean = True): string;
var
  LRaw: RawByteString;
begin
  LRaw := Base64ToBin(AStr);

  if AIsCompress then
    LRaw := SynLZDecompress(LRaw);

  Result := Utf8ToString(LRaw);
end;

function MakeBase64ToUTF8(AStr: RawUTF8; AIsCompress: Boolean = True): RawUTF8;
var
//  LUTF8 : RawUTF8;
  LRaw: RawByteString;
begin
  LRaw := Base64ToBin(AStr);

  if AIsCompress then
    LRaw := SynLZDecompress(LRaw);

  Result := LRaw;
end;

function GetBase64ByFileName(AFileName: RawUTF8; AIsCompress: Boolean = True): RawUTF8;
var
  LRaw: RawByteString;
begin
  LRaw := StringFromFile(AFileName);
  Result := MakeRawByteStringToBin64(LRaw, AIsCompress);
end;

function FileToBase64(const AFileName: RawUTF8): RawUTF8;
var
  f: TStream;
  bytes: TBytes;
begin
  result := '';

  f := TFileStream.Create(AFileName, fmOpenRead);
  try
    if f.Size > 0 then
    begin
      SetLength(bytes, f.Size);
      f.Read(bytes[0], f.Size);
    end;

    Result := BinToBase64(@bytes[0], f.Size);

  finally
    f.Free;
  end;
end;

end.
