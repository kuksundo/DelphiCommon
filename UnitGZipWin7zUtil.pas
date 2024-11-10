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
//Tgz파일 압축을 풀면 .tar 파일이 풀림-다시한번 압축을 풀어야 .tar 파일이 풀림
//APackedFileName: ''이면 모든 파일 Decompress
//Result: APackedFileName Contents
//        APackedFileName = ''이면 return = ''
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

  //MPM11.tgz 파일을 c:\temp\에 "MPM11" 파일로 Extract함(.tar 파일임)
  LTarFileName := ChangeFileExt(ExtractFileName(ATgzFileName), '');
  DeCompressFileWithWin7zip(ATgzFileName, ADestDir+LTarFileName, ADllFullPathName);

  LExtractFileName := ADestDir + ChangeFileExt(ExtractFileName(ATgzFileName), '');
  //c:\temp\MPM11 파일이 존재하면
  if FileExists(LExtractFileName) then
  begin
    LTarFileName := ChangeFileExt(LExtractFileName, '.tar');

    if FileExists(LTarFileName) then
      DeleteFile(LTarFileName);

    //MPM11 파일을 MPM11.tar 파일로 이름 변경함
    if RenameFile(LExtractFileName, LTarFileName) then
    begin
      //MPM11.tar 파일에서 "home\db\interface.json" 파일을 c:\temp\에 Extract
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
