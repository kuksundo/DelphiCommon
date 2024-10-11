unit UnitGZipJclUtil;

{
�� ������ ����ϱ� ���ؼ��� 7z.dll ������ ����ȭ�� ������ �����ؾ� ��
�Ǵ� SevenzipLibraryDir�� 7z.dll ��θ� ������ �� ����ؾ� ��
}

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  JclCompression
  ;

function GetArchiveByGzNameUsingJcl(AGzFileName: string): TJclCompressionArchive;
//APackedFileName = '' �̸� ��� ������ Extract
//APackedFileName <> '' �̸� APackedFileName ���ϸ� Extract
function DeCompressGzUsingJcl(AGzFileName, ADestDir: string; APackedFileName: string=''): string;
//Result: APackedFileName Contents
function ExtractFromTgz2DirByPackedName(AGzFileName, ADestDir, APackedFileName: string): string;
//AFileName�� Extention�� �̿��Ͽ� ���� ���� ��
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
      //File�� FItems�� ä��
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

  //MPM11.tgz ������ c:\temp\�� "MPM11" ���Ϸ� Extract��
  DeCompressFileUsingJcl(AGzFileName, ADestDir);

  LExtractFileName := ADestDir + ChangeFileExt(ExtractFileName(AGzFileName), '');
  //c:\temp\MPM11 ������ �����ϸ�
  if FileExists(LExtractFileName) then
  begin
    LExtractFileName2 := ChangeFileExt(LExtractFileName, '.tar');

    if FileExists(LExtractFileName2) then
      DeleteFile(LExtractFileName2);

    //MPM11 ������ MPM11.tar ���Ϸ� �̸� ������
    if RenameFile(LExtractFileName, LExtractFileName2) then
    begin
      //MPM11.tar ���Ͽ��� "home\db\interface.json" ������ c:\temp\�� Extract
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
