unit UnitSynZip2;

interface

uses mormot.core.zip, mormot.core.os, mormot.lib.z;

type
  TAnsiArray = array of AnsiChar;

procedure UnZipUsingSynZip(const AZipName: string; ADestPath: string = 'c:\temp\');
function ZipArrayUsingSynZip(const AOriginalData: array of AnsiChar): TAnsiArray;
function UnZipArrayUsingSynZip(const ACompressedData: array of AnsiChar): TAnsiArray;

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

function ZipArrayUsingSynZip(const AOriginalData: array of AnsiChar): TAnsiArray;
var
  LSize: integer;
//  LCompressed, LDeCompressed: array of AnsiChar;
begin
  LSize := Length(AOriginalData);
  SetLength(Result, LSize + LSize shr 3 + 256);
  LSize := CompressMem(@AOriginalData, @Result, Length(AOriginalData), Length(Result));
end;

function UnZipArrayUsingSynZip(const ACompressedData: array of AnsiChar): TAnsiArray;
var
  LSize: integer;
begin
  LSize := Length(ACompressedData);
  SetLength(Result, LSize);
  LSize := UnCompressMem(@ACompressedData, @Result, LSize, Length(Result));
//  CompareMem();
end;

end.
