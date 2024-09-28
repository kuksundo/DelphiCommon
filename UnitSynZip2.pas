unit UnitSynZip2;

interface

uses mormot.core.zip, mormot.core.os, mormot.lib.z, UnitArrayUtil;

function ZipAnsiArrayUsingSynZip(const AOriginalData: array of AnsiChar): TAnsiArray; overload;
function UnZipAnsiArrayUsingSynZip(const ACompressedData: array of AnsiChar): TAnsiArray; overload;
function ZipArrayUsingSynZip(const AOriginalData: TCharArray): string; overload;
function UnZipArrayUsingSynZip(const ACompressedData: string): TCharArray; overload;

function ZipStringUsingSynZip(const AString: string): string;
function UnZipStringUsingSynZip(const ACompressedData: string): string;

procedure UnZipUsingSynZip(const AZipName: string; ADestPath: string = 'c:\temp\');

implementation

procedure UnZipUsingSynZip(const AZipName: string; ADestPath: string);
var
  vContent : RawByteString;
  vZip :TZipRead;
begin
  vContent := StringFromFile(AZipName);
  vZip := TZipRead.Create(@vContent[1], Length(vContent));
  vZip.UnZipAll(ADestPath);
  vZip.Free;
end;

function ZipAnsiArrayUsingSynZip(const AOriginalData: array of AnsiChar): TAnsiArray;
var
  LSize: integer;
//  LCompressed, LDeCompressed: array of AnsiChar;
begin
  LSize := Length(AOriginalData);
  SetLength(Result, LSize + LSize shr 3 + 256);
  LSize := CompressMem(@AOriginalData, @Result, Length(AOriginalData), Length(Result));
end;

function UnZipAnsiArrayUsingSynZip(const ACompressedData: array of AnsiChar): TAnsiArray;
var
  LSize: integer;
begin
  LSize := Length(ACompressedData);
  SetLength(Result, LSize);
  LSize := UnCompressMem(@ACompressedData, @Result, LSize, Length(Result));
//  CompareMem();
end;

function ZipArrayUsingSynZip(const AOriginalData: TCharArray): string; overload;
var
  LSize: integer;
begin
  LSize := Length(AOriginalData);
  SetLength(Result, LSize + LSize shr 3 + 256);
  LSize := CompressMem(@AOriginalData, @Result, Length(AOriginalData), Length(Result));
end;

function UnZipArrayUsingSynZip(const ACompressedData: string): TCharArray; overload;
var
  LSize: integer;
begin
  LSize := Length(ACompressedData);
  SetLength(Result, LSize);
  LSize := UnCompressMem(@ACompressedData, @Result, LSize, Length(Result));
end;

function ZipStringUsingSynZip(const AString: string): string;
var
  LCharArray: TCharArray;
begin
  LCharArray := StringToArrayOfChar(AString);
  Result := ZipArrayUsingSynZip(LCharArray);
end;

function UnZipStringUsingSynZip(const ACompressedData: string): string;
var
  LCharArray: TCharArray;
begin
  LCharArray := UnZipArrayUsingSynZip(ACompressedData);
  Result := ArrayOfCharToString(LCharArray);
end;

end.
