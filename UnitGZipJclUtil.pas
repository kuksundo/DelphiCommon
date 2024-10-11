unit UnitGZipJclUtil;

{
이 유닛을 사용하기 위해서는 7z.dll 파일을 실행화일 폴더에 복사해야 함
또는 SevenzipLibraryDir에 7z.dll 경로를 지정한 후 사용해야 함
}

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  JclCompression
  ;

function GetArchiveByGzNameUsingJcl(AGzFileName: string): TJclCompressionArchive;
//APackedFileName = '' 이면 모든 파일을 Extract
//APackedFileName <> '' 이면 APackedFileName 파일만 Extract
function DeCompressGzUsingJcl(AGzFileName, ADestDir: string; APackedFileName: string=''): string;
//Result: APackedFileName Contents
function ExtractFromTgz2DirByPackedName(AGzFileName, ADestDir, APackedFileName: string): string;
//AFileName의 Extention을 이용하여 압축 해제 함
function DeCompressFileUsingJcl(AFileName, ADestDir: string; APackedFileName: string=''): string;

implementation

uses UnitFileUtil;

function GetArchiveByGzNameUsingJcl(AGzFileName: string): TJclCompressionArchive;
var
  LFormats: TJclDecompressArchiveClassArray;
  i: integer;
begin
  Result := nil;

  LFormats := GetArchiveFormats.FindDecompressFormats(AGzFileName);

  for i := Low(LFormats) to High(LFormats) do
  begin
    Result := LFormats[i].Create(AGzFileName, 0, False);

    if Result is TJclDecompressArchive then
    begin
      //File을 FItems에 채움
      TJclDecompressArchive(Result).ListFiles;
      Break;
    end;
   end;//for
end;

function DeCompressGzUsingJcl(AGzFileName, ADestDir: string; APackedFileName: string=''): string;
var
  LArchive: TJclGZipcompressArchive;
  LCompressionItem: TJclCompressionItem;
  LGzName, LExtractFileName: string;
  i, j: integer;
begin
  if ADestDir = '' then
    ADestDir := 'C:\temp\';

  LArchive := TJclGZipcompressArchive.Create(AGzFileName);
  try
    for j := 0 to LArchive.ItemCount - 1 do
    begin
      LCompressionItem := LArchive.Items[j];

      if APackedFileName = '' then
      begin
        TJclDecompressArchive(LArchive).ExtractAll(ADestDir, True);
        Break;
      end
      else
      begin
        if LCompressionItem.PackedName <> APackedFileName then
          continue;

        LCompressionItem.Selected := True;
        TJclDecompressArchive(LArchive).ExtractSelected(ADestDir, True);
        Break;
      end;
    end;
  finally
    LArchive.Free;
  end;
end;

function DeCompressFileUsingJcl(AFileName, ADestDir: string; APackedFileName: string=''): string;
var
  LArchive: TJclCompressionArchive;
  LCompressionItem: TJclCompressionItem;
  LGzName, LExtractFileName: string;
  i, j: integer;
begin
  if ADestDir = '' then
    ADestDir := 'C:\temp\';

  LArchive := GetArchiveByGzNameUsingJcl(AFileName);
  try
    for j := 0 to LArchive.ItemCount - 1 do
    begin
      LCompressionItem := LArchive.Items[j];

      if APackedFileName = '' then
      begin
        TJclDecompressArchive(LArchive).ExtractAll(ADestDir, True);
        Break;
      end
      else
      begin
        if LCompressionItem.PackedName <> APackedFileName then
          continue;

        LCompressionItem.Selected := True;
        TJclDecompressArchive(LArchive).ExtractSelected(ADestDir, True);
        Break;
      end;
    end;
  finally
    LArchive.Free;
  end;
end;

function ExtractFromTgz2DirByPackedName(AGzFileName, ADestDir, APackedFileName: string): string;
var
  LExtractFileName, LExtractFileName2: string;
begin
  Result := '';

  if ADestDir = '' then
    ADestDir := 'C:\temp\';

  //MPM11.tgz 파일을 c:\temp\에 "MPM11" 파일로 Extract함
  DeCompressFileUsingJcl(AGzFileName, ADestDir);

  LExtractFileName := ADestDir + ChangeFileExt(ExtractFileName(AGzFileName), '');
  //c:\temp\MPM11 파일이 존재하면
  if FileExists(LExtractFileName) then
  begin
    LExtractFileName2 := ChangeFileExt(LExtractFileName, '.tar');

    if FileExists(LExtractFileName2) then
      DeleteFile(LExtractFileName2);

    //MPM11 파일을 MPM11.tar 파일로 이름 변경함
    if RenameFile(LExtractFileName, LExtractFileName2) then
    begin
      //MPM11.tar 파일에서 "home\db\interface.json" 파일을 c:\temp\에 Extract
      DeCompressFileUsingJcl(LExtractFileName2, ADestDir, APackedFileName);
      LExtractFileName := ADestDir + APackedFileName;

      if FileExists(LExtractFileName) then
      begin
        Result := StringFromFile(LExtractFileName);
      end;
    end;
  end;
end;

end.
