unit UnitGZipWin7zUtil;

interface

uses System.Classes, SysUtils,
  mormot.core.base,
  mormot.core.os,
  mormot.core.text,
  mormot.core.buffers,
  mormot.core.unicode,
  mormot.lib.z,
  mormot.core.zip,
  mormot.lib.win7zip;

function DeCompressFileWithWin7zip(ASrcFile, ADestFile, ADllFullPathName: string; Anosubfolder: Boolean=False): Boolean;
//Tgz���� ������ Ǯ�� .tar ������ Ǯ��-�ٽ��ѹ� ������ Ǯ��� .tar ������ Ǯ��
//APackedFileName: ''�̸� ��� ���� Decompress
//Result: APackedFileName Contents
//        APackedFileName = ''�̸� return = ''
function ExtractFromTgz2DirByPackedNameWin7Zip(ATgzFileName, ADestDir, ADllFullPathName: string; APackedFileName: string=''): string;

implementation

function DeCompressFileWithWin7zip(ASrcFile, ADestFile, ADllFullPathName: string; Anosubfolder: Boolean): Boolean;
var
  L7zip: I7zReader;
//  LSrcStream, LDestStream: TStream;
//  LdestFile: string;
begin
//  if AIsFile then
//    LDestFile := ADestFile
//  else
//    LDestFile := ADestFile + ExtractFileName(ASrcFile);

  L7zip := New7zReader(ASrcFile, fhUndefined, ADllFullPathName);
  L7Zip.ExtractAll(ADestFile, Anosubfolder);
end;

function ExtractFromTgz2DirByPackedNameWin7Zip(ATgzFileName, ADestDir, ADllFullPathName, APackedFileName: string): string;
var
  LExtractFileName, LTarFileName: string;
begin
  Result := '';

  if ADestDir = '' then
    ADestDir := 'C:\temp\';

  //MPM11.tgz ������ c:\temp\�� "MPM11" ���Ϸ� Extract��(.tar ������)
  LTarFileName := ChangeFileExt(ExtractFileName(ATgzFileName), '');
  DeCompressFileWithWin7zip(ATgzFileName, ADestDir+LTarFileName, ADllFullPathName);

  LExtractFileName := ADestDir + ChangeFileExt(ExtractFileName(ATgzFileName), '');
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
      DeCompressFileWithWin7zip(LTarFileName, ADestDir, APackedFileName);

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

end.
