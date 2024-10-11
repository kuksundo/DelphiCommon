unit UnitGZipUtil;

interface

uses System.Classes, SysUtils,
  mormot.core.base,
  mormot.core.os,
  mormot.core.text,
  mormot.core.buffers,
  mormot.core.unicode,
  mormot.lib.z,
  mormot.core.zip;
//AbGzTyp, AbTarTyp, AbZipper;

function GUnZipFileWithSyn(ASrcFile, ADestFile: string; AIsFile: Boolean): Boolean;

implementation

function GUnZipFileWithSyn(ASrcFile, ADestFile: string; AIsFile: Boolean): Boolean;
var
  Lgz: TSynZipDeCompressor;
  LSrcStream, LDestStream: TStream;
  LdestFile: string;
begin
  if AIsFile then
    LDestFile := ADestFile
  else
    LDestFile := ADestFile + ExtractFileName(ASrcFile);

  LSrcStream := TFileStreamEx.Create(ASrcFile, fmOpenRead);
  LDestStream := TFileStreamEx.Create(LdestFile, fmCreate);

  try
    Lgz := TSynZipDeCompressor.Create(LDestStream, szcfGZ);
    StreamCopyUntilEnd(LSrcStream, Lgz);
    Result := True;
  finally
    Lgz.Free;
    LSrcStream.Free;
    LDestStream.Free;
  end;
end;

end.
