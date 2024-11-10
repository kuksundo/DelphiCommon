unit UnitGZipJclUtil;

{
�� ������ ����ϱ� ���ؼ��� 7z.dll ������ ����ȭ�� ������ �����ؾ� ��
�Ǵ� SevenzipLibraryDir�� 7z.dll ��θ� ������ �� ����ؾ� ��
  //UnitGZipJclUtil ������ ����ϱ� ���ؼ� SevenzipLibraryDir�� 7z.dll ��θ� ������
  1. uses sevenzip
  2. SevenzipLibraryDir := ExtractFilePath(Application.ExeName) + 'lib\';
  3. 7zip.dll�� 64bit ������
}

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  JclCompression
  ;

function GetCompressArchiveByGzNameUsingJcl(AGzFileName: string): TJclCompressArchive;
function GetUpdateArchiveByGzNameUsingJcl(AGzFileName: string): TJclUpdateArchive;
function GetDeCompressArchiveByGzNameUsingJcl(AGzFileName: string): TJclCompressionArchive;
//APackedFileName = '' �̸� ��� ������ Extract
//APackedFileName <> '' �̸� APackedFileName ���ϸ� Extract
function DeCompressGzUsingJcl(AGzFileName, ADestDir: string; APackedFileName: string=''): string;
//Tgz���� ������ Ǯ�� .tar ������ Ǯ��-�ٽ��ѹ� ������ Ǯ��� .tar ������ Ǯ��
//Result: APackedFileName Contents
function ExtractFromTgz2DirByPackedName(AGzFileName, ADestDir, APackedFileName: string): string;
//AFileName�� Extention�� �̿��Ͽ� ���� ���� ��
function DeCompressFileUsingJcl(AFileName, ADestDir: string; APackedFileName: string=''): string;
//APackedFileList: ���� ���Ͽ��� ���� ������ ���� �̸� ����Ʈ
//Result: ���� ������ ���� ������ ��ȯ
function DeCompressFileListFromTgzUsingJcl(AFileName, ADestDir: string; AExtractFileList: TStringList): integer;
function DeCompressFromArchiveUsingJcl(AArchive: TJclCompressionArchive; ADestDir: string; AExtractFileList: TStringList): string;
//Result: ���� Ǯ�� .tar ���� �̸� FullPath
function DeCompressTgz2TarUsingJcl(ATgzFileName, ADestDir: string): string;

//ATarFileName: ���� ������ Tar ���� �̸�
//ADestDir: ������ ������ ���
//AAddFileList: Tar�� ������ File List
function CompressFileList2TarUsingJcl(ATarFileName, ADestDir: string; AAddFileList: TStringList): integer;
function UpdateFile2TarUsingJcl(const ATarFileName, AUpdateFileName, APackedName: string): integer;

function CompressFileList2GzUsingJcl(AGzFileName, ADestDir: string; AAddFileList: TStringList): integer;

//���� Ȯ���ڷ� ���� ���� ���θ� �Ǵܸ�.
//Result: True = �������� ������
function CheckIfTgzFile(const AFileName: string): Boolean;

implementation

uses UnitFileUtil;

function GetCompressArchiveByGzNameUsingJcl(AGzFileName: string): TJclCompressArchive;
var
  LFormats: TJclCompressArchiveClass;
begin
  Result := nil;

  LFormats := GetArchiveFormats.FindCompressFormat(AGzFileName);

  Result := LFormats.Create(AGzFileName);
end;

function GetUpdateArchiveByGzNameUsingJcl(AGzFileName: string): TJclUpdateArchive;
var
  LFormats: TJclUpdateArchiveClass;
begin
  Result := nil;

  LFormats := GetArchiveFormats.FindUpdateFormat(AGzFileName);

  Result := LFormats.Create(AGzFileName);
end;

function GetDeCompressArchiveByGzNameUsingJcl(AGzFileName: string): TJclCompressionArchive;
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

  ADestDir := IncludeTrailingPathDelimiter(ADestDir);

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

  ADestDir := IncludeTrailingPathDelimiter(ADestDir);

  LArchive := GetDeCompressArchiveByGzNameUsingJcl(AFileName);
  try
    for j := 0 to LArchive.ItemCount - 1 do
    begin
      LCompressionItem := LArchive.Items[j];

      if APackedFileName = '' then
      begin
        TJclDecompressArchive(LArchive).ExtractAll(ADestDir, True);
//        LCompressionItem.Selected := True;
//        TJclDecompressArchive(LArchive).ExtractSelected(ADestDir, True);
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

function DeCompressFileListFromTgzUsingJcl(AFileName, ADestDir: string; AExtractFileList: TStringList): integer;
var
  LArchive: TJclCompressionArchive;
  LTarFileName, LExtractedFileName: string;
begin
  if ADestDir = '' then
    ADestDir := 'C:\temp\';

  ADestDir := IncludeTrailingPathDelimiter(ADestDir);

  //.tgz ������ ADestDir�� .tar�� Extract��
  LTarFileName := DeCompressTgz2TarUsingJcl(AFileName, ADestDir);

  if LTarFileName = '' then
    exit;

  LArchive := GetDeCompressArchiveByGzNameUsingJcl(LTarFileName);
  try
    DeCompressFromArchiveUsingJcl(LArchive, ADestDir, AExtractFileList);
  finally
    LArchive.Free;

    if FileExists(LTarFileName) then
      DeleteFile(LTarFileName);
  end;
end;

function DeCompressFromArchiveUsingJcl(AArchive: TJclCompressionArchive;
  ADestDir: string; AExtractFileList: TStringList): string;
var
  i,j: integer;
  LCompressionItem: TJclCompressionItem;
  LExtractFileName: string;
begin
    for i := 0 to AArchive.ItemCount - 1 do
    begin
      LCompressionItem := AArchive.Items[i];

      if Assigned(AExtractFileList) then
      begin
        j := AExtractFileList.IndexOf(LCompressionItem.PackedName);

        if j <> -1 then
        begin
          LCompressionItem.Selected := True;
          TJclDecompressArchive(AArchive).ExtractSelected(ADestDir, True);
        end;
      end
      else
        TJclDecompressArchive(AArchive).ExtractAll(ADestDir, True);
    end; //for
end;

function DeCompressTgz2TarUsingJcl(ATgzFileName, ADestDir: string): string;
var
  LArchive: TJclCompressionArchive;
  LCompressionItem: TJclCompressionItem;
  LTarFileName, LExtractedFileName: string;
  i: integer;
begin
  Result := '';

  if ADestDir = '' then
    ADestDir := 'C:\temp\';

  ADestDir := IncludeTrailingPathDelimiter(ADestDir);

  LArchive := GetDeCompressArchiveByGzNameUsingJcl(ATgzFileName);
  try
    for i := 0 to LArchive.ItemCount - 1 do
    begin
      LCompressionItem := LArchive.Items[i];
      TJclDecompressArchive(LArchive).ExtractAll(ADestDir, True);
      Break;
    end;

    LTarFileName := ADestDir + ChangeFileExt(ExtractFileName(ATgzFileName), '.tar');
    LExtractedFileName := ADestDir + ChangeFileExt(ExtractFileName(ATgzFileName), '');

    if FileExists(LTarFileName) then
      DeleteFile(LTarFileName);

    if FileExists(LExtractedFileName) then
    begin
      //MPM11 ������ MPM11.tar ���Ϸ� �̸� ������
      if RenameFile(LExtractedFileName, LTarFileName) then
      begin
        Result := LTarFileName;
      end;
    end;
  finally
    LArchive.Free;
  end;
end;

function ExtractFromTgz2DirByPackedName(AGzFileName, ADestDir, APackedFileName: string): string;
var
  LExtractFileName, LTarFileName: string;
begin
  Result := '';

  if ADestDir = '' then
    ADestDir := 'C:\temp\';

  ADestDir := IncludeTrailingPathDelimiter(ADestDir);

  //MPM11.tgz ������ c:\temp\�� "MPM11" ���Ϸ� Extract��(.tar ������)
  DeCompressFileUsingJcl(AGzFileName, ADestDir);

  LExtractFileName := ADestDir + ChangeFileExt(ExtractFileName(AGzFileName), '');
  //c:\temp\MPM11 ������ �����ϸ�
  if FileExists(LExtractFileName) then
  begin
    LTarFileName := ChangeFileExt(LExtractFileName, '.tar');

    if FileExists(LTarFileName) then
      DeleteFile(LTarFileName);

    //MPM11 ������ MPM11.tar ���Ϸ� �̸� ������
    if RenameFile(LExtractFileName, LTarFileName) then
    begin
      //MPM11.tar ���Ͽ��� "home\db\interface.json" ������ c:\temp\�� Extract
      DeCompressFileUsingJcl(LTarFileName, ADestDir, APackedFileName);

      if APackedFileName <> '' then
      begin
        LExtractFileName := ADestDir + APackedFileName;

        if FileExists(LExtractFileName) then
        begin
          Result := StringFromFile(LExtractFileName);
        end;
      end;
    end;
  end;
end;

function CheckIfTgzFile(const AFileName: string): Boolean;
var
  LFileExt: string;
begin
  LFileExt := UpperCase(ExtractFileExt(AFileName));

  Result := (LFileExt = '.TGZ') or (LFileExt = '.TAR');

end;

function UpdateFile2TarUsingJcl(const ATarFileName, AUpdateFileName, APackedName: string): integer;
var
  LArchive: TJclUpdateArchive;
  LUpdateItem: TJclUpdateItem;
begin
  LArchive := GetUpdateArchiveByGzNameUsingJcl(ATarFileName);
  try
    LArchive.ListFiles;
    Result := LArchive.AddFile(APackedName, AUpdateFileName);
    LArchive.Compress;
  finally
    LArchive.Free;
  end;
end;

function CompressFileList2TarUsingJcl(ATarFileName, ADestDir: string; AAddFileList: TStringList): integer;
begin

end;

function CompressFileList2GzUsingJcl(AGzFileName, ADestDir: string; AAddFileList: TStringList): integer;
var
  LArchive: TJclCompressArchive;
  LCompressionItem: TJclCompressionItem;
  LStr, LFileName: string;
begin
  LArchive := GetCompressArchiveByGzNameUsingJcl(AGzFileName);
  try
    for LStr in AAddFileList do
    begin
      if FileExists(LStr) then
      begin
        LFileName := ExtractFileName(LStr);
        LArchive.AddFile(LFileName, LStr);
      end;
    end;//for

    LArchive.Compress;
  finally
    LArchive.Free;
  end;
end;

end.
