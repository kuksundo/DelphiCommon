unit UnitFileUtil2;

interface

uses Winapi.Windows, System.Classes, System.SysUtils, System.DateUtils,
  System.IOUtils, Winapi.ShlObj, Math, System.Zip,
  mormot.core.base, mormot.core.os, mormot.core.variants,
  ZipMstr,
  UnitFileInfoUtil;

//AList : Full Path FileName List
//결과값은 [{"Name": "", "Path": "", "Version": ""},...]
function GetFileVersion2JsonAryByPJVerInfoFromList(AList: TStringList): string;
function CopyOrZipFileUsingZipMaster(const ASourceFile, ATargetFile: string; AIsCompress: Boolean): Int64;
function CopyOrZipFileUsingSystemZip(const ASourceFile, ATargetFile: string; AIsCompress: Boolean): Int64;
function TFile_GetSize(const Path: string): Int64;
{
BasePath가 디렉터리인지 파일인지 구분
공통 경로를 찾고 ..\ 로 올라가기
내려가는 경로를 연결하여 상대 경로 생성
드라이브 문자가 다르면 상대경로 사용 불가 → Target의 절대 경로 반환
}
function PathRelativePathToEx(const BasePath: string; const BaseIsDir: Boolean;
                              const TargetPath: string; const TargetIsDir: Boolean): string;
function GetRelativePath(const BasePath, TargetPath: string): string;
{
SourceRoot = 원본 루트 폴더
SourceFile = SourceRoot 기준의 하위 경로를 포함한 파일 경로
예: C:\Src\Root, C:\Src\Root\Images\logo.png
TargetRoot = 대상 루트 폴더
반환 값 = TargetRoot + (SourceRoot 기준 상대 경로)
}
function MapToTargetPath(const SourceRoot, SourceFile, TargetRoot: string): string;

implementation

function GetFileVersion2JsonAryByPJVerInfoFromList(AList: TStringList): string;
var
  i: integer;
  LList: IDocList;
  LDict: IDocDict;
  LName, LPath, LVersion: RawUtf8;
begin
  Result := '';

  i := GetFileVersionListByPJVerInfoFromList(AList);

  if i <> -1 then
  begin
    LList := DocList('[]');
    LDict := DocDict('{}');

    for i := 0 to AList.Count - 1 do
    begin

      LName := ExtractFileName(AList.Names[i]);
      LPath := ExtractFilePath(AList.Names[i]);
      LVersion := AList.ValueFromIndex[i];

      LDict.S['Name'] := LName;
      LDict.S['Path'] := LPath;
      LDict.S['Version'] := LVersion;

      LList.AppendDoc(LDict);
      LDict.Clear;
    end;

    Result := Utf8ToString(LList.Json);
  end;
end;

function CopyOrZipFileUsingZipMaster(const ASourceFile, ATargetFile: string; AIsCompress: Boolean): Int64;
var
  Zip: TZipMaster;
  TargetDir: string;
  FileSize: Int64;
begin
  Result := 0;

  // 소스 파일 체크
  if not FileExists(ASourceFile) then
    Exit;

  // 타겟 디렉토리 생성
  TargetDir := ExtractFilePath(ATargetFile);
  if not DirectoryExists(TargetDir) then
    ForceDirectories(TargetDir);

  // 압축 여부가 True → Zip 처리
  if AIsCompress then
  begin
    // ZIP 파일 처리
    Zip := TZipMaster.Create(nil);
    try
      Zip.ZipFileName := ATargetFile;

      if FileExists(ATargetFile) then
      begin
        // 기존 ZIP에 파일 추가
        if SameText(ExtractFileExt(ATargetFile), '.zip') then
        begin
          Zip.FSpecArgs.Clear;
          Zip.FSpecArgs.Add(ASourceFile);
          Zip.Add;
        end
        else
        begin
          // 압축 옵션인데 Target이 zip이 아님 → zip 생성
          Zip.ZipFileName := ChangeFileExt(ATargetFile, '.zip');
          Zip.FSpecArgs.Add(ASourceFile);
          Zip.Add;
        end;
      end
      else
      begin
        // 새로운 ZIP 생성
        Zip.FSpecArgs.Add(ASourceFile);
        Zip.Add;
      end;
    finally
      Zip.Free;
    end;

    // ZIP 파일 크기 (KB 단위)
    if FileExists(Zip.ZipFileName) then
      Result := TFile_GetSize(Zip.ZipFileName) div 1024;

    Exit;
  end;

  // ZIP이 아니고 Compress=False → 단순 복사
  if FileExists(ATargetFile) then
  begin
    // 기존 파일이 ZIP이면 ZIP에 추가
    if SameText(ExtractFileExt(ATargetFile), '.zip') then
    begin
      Zip := TZipMaster.Create(nil);
      try
        Zip.ZipFileName := ATargetFile;
        Zip.FSpecArgs.Add(ASourceFile);
        Zip.Add;

        FileSize := TFile_GetSize(ATargetFile);
        Result := FileSize div 1024;
      finally
        Zip.Free;
      end;
      Exit;
    end;
  end;

  // 일반 파일 덮어쓰기
  TFile.Copy(ASourceFile, ATargetFile, True);

  // 파일 크기 반환
  if FileExists(ATargetFile) then
    Result := TFile_GetSize(ATargetFile) div 1024;
end;

function CopyOrZipFileUsingSystemZip(const ASourceFile, ATargetFile: string; AIsCompress: Boolean): Int64;
var
  Zip: TZipFile;
  TargetDir: string;
  FileSize: Int64;
begin
  Result := 0;

  // 소스 파일 체크
  if not FileExists(ASourceFile) then
    Exit;

  // 타겟 디렉토리 생성
  TargetDir := ExtractFilePath(ATargetFile);
  if not DirectoryExists(TargetDir) then
    ForceDirectories(TargetDir);

  // 압축 여부가 True → Zip 처리
  if AIsCompress then
  begin
    // ZIP 파일 처리
    Zip := TZipFile.Create;
    try
      Zip.Open(ATargetFile, zmWrite);
      Zip.Add(ASourceFile);
      Zip.Close;
    finally
      Zip.Free;
    end;

    // ZIP 파일 크기 (KB 단위)
    if FileExists(ATargetFile) then
      Result := TFile_GetSize(ATargetFile) div 1024;

    Exit;
  end;

  // ZIP이 아니고 Compress=False → 단순 복사
  if FileExists(ATargetFile) then
  begin
    // 기존 파일이 ZIP이면 ZIP에 추가
    if SameText(ExtractFileExt(ATargetFile), '.zip') then
    begin
      Zip := TZipFile.Create;
      try
        Zip.Open(ATargetFile, zmWrite);
        Zip.Add(ASourceFile);
        Zip.Close;
      finally
        Zip.Free;
      end;

      // ZIP 파일 크기 (KB 단위)
      if FileExists(ATargetFile) then
        Result := TFile_GetSize(ATargetFile) div 1024;

      Exit;
    end;
  end;

  // 일반 파일 덮어쓰기
  TFile.Copy(ASourceFile, ATargetFile, True);

  // 파일 크기 반환
  if FileExists(ATargetFile) then
    Result := TFile_GetSize(ATargetFile) div 1024;
end;

function TFile_GetSize(const Path: string): Int64;
{$IFDEF MSWINDOWS}
var
  LPath: string;
  LInfo: TWin32FileAttributeData;
begin
  if (Length(Path) < MAX_PATH) or TPath.IsExtendedPrefixed(Path) then
    LPath := Path
  else
    LPath := {TPath.FCExtendedPrefix}'\\?\' + Path;
  if GetFileAttributesEx(PChar(LPath), GetFileExInfoStandard, @LInfo) then
  begin
    Result := LInfo.nFileSizeHigh;
    Result := Result shl 32 + LInfo.nFileSizeLow;
  end
  else begin
    Result := -1;
  end;
end;
{$ELSE}
var
  LFileName: UTF8String;
  LStatBuf: _stat;
begin
  LFileName := UTF8Encode(Path);
  if stat(PAnsiChar(LFileName), LStatBuf) = 0 then
    Result := LStatBuf.st_size
  else
    Result := -1;
end;
{$ENDIF}

function PathRelativePathToEx(const BasePath: string; const BaseIsDir: Boolean;
                              const TargetPath: string; const TargetIsDir: Boolean): string;
var
  BaseParts, TargetParts: TStringList;
  I, CommonCount: Integer;
  Base, Target, Rel: string;
begin
  Result := '';

  // 드라이브 문자 비교 (예: C:\ D:\)
  if (ExtractFileDrive(BasePath).ToLower <> ExtractFileDrive(TargetPath).ToLower) then
  begin
    Result := TargetPath;
    Exit;
  end;

  // 디렉터리 기준으로 정규화
  Base := BasePath;
  Target := TargetPath;

  if BaseIsDir then
    Base := IncludeTrailingPathDelimiter(Base);
  if TargetIsDir then
    Target := IncludeTrailingPathDelimiter(Target);

  // 경로를 폴더 단위로 분해
  BaseParts := TStringList.Create;
  TargetParts := TStringList.Create;
  try
    BaseParts.StrictDelimiter := True;
    TargetParts.StrictDelimiter := True;
    BaseParts.Delimiter := '\';
    TargetParts.Delimiter := '\';

    BaseParts.DelimitedText := StringReplace(Base, ':', '', [rfReplaceAll]);
    TargetParts.DelimitedText := StringReplace(Target, ':', '', [rfReplaceAll]);

    // 공통 경로 깊이 계산
    CommonCount := 0;
    for I := 0 to Min(BaseParts.Count, TargetParts.Count) - 1 do
    begin
      if SameText(BaseParts[I], TargetParts[I]) then
        Inc(CommonCount)
      else
        Break;
    end;

    // 공통 경로가 끝난 후 Base에서 빠져나가기 (..\ 생성)
    Rel := '';
    for I := CommonCount to BaseParts.Count - 2 do
      Rel := Rel + '..\';

    // Target으로 내려가기
    for I := CommonCount to TargetParts.Count - 1 do
    begin
      Rel := Rel + TargetParts[I];
      if I < TargetParts.Count - 1 then
        Rel := Rel + '\';
    end;

    Result := Rel;
  finally
    BaseParts.Free;
    TargetParts.Free;
  end;
end;

function GetRelativePath(const BasePath, TargetPath: string): string;
var
  RelPath: array [0..MAX_PATH] of Char;
  Base, Target: string;
begin
  // 경로 끝에 '\', '/' 혼용되는 상황 방지
  Base := IncludeTrailingPathDelimiter(BasePath);
  Target := TargetPath;

  Result := PathRelativePathToEx(Base, True, Target, False);

  // 실패 시 절대 경로 반환
  if Result = '' then
    Result := TargetPath;
end;

function MapToTargetPath(const SourceRoot, SourceFile, TargetRoot: string): string;
var
  RelPath: string;
begin
  // SourceRoot 기준 상대 경로 계산
  RelPath := GetRelativePath(SourceRoot, SourceFile);

  // TargetRoot + 상대 경로 반환
  Result := TPath.Combine(TargetRoot, RelPath);

  // 경로 정규화
  Result := TPath.GetFullPath(Result);
end;

procedure ZipFileUsingZipMaster(const ASourceFile, ATargetFile: string);
var
  Zip: TZipMaster;
begin
  Zip := TZipMaster.Create(nil);
  try
    // 1. 항상 FSpecArgs 목록을 초기화하여 이전 실행의 잔여물이 남지 않도록 함
    Zip.FSpecArgs.Clear;
    Zip.ZipFileName := ATargetFile;

    if FileExists(ATargetFile) then
    begin
      // A. 기존 ZIP에 파일 추가 (TargetFile이 .zip인 경우)
      if SameText(ExtractFileExt(ATargetFile), '.zip') then
      begin
        // FSpecArgs.Clear는 이미 상단에서 처리됨
        Zip.FSpecArgs.Add(ASourceFile);
        Zip.Add; // 파일 추가 실행
      end
      else
      begin
        // B. TargetFile이 ZIP이 아니지만 파일이 존재하는 경우 → 확장자를 변경하여 새로운 ZIP 생성
        Zip.ZipFileName := ChangeFileExt(ATargetFile, '.zip');
        // FSpecArgs.Clear는 이미 상단에서 처리됨
        Zip.FSpecArgs.Add(ASourceFile);
        Zip.Add; // 새로운 ZIP 파일 생성 및 파일 추가 실행
      end;
    end
    else
    begin
      // C. 새로운 ZIP 생성 (TargetFile이 존재하지 않는 경우)
      // FSpecArgs.Clear는 이미 상단에서 처리됨
      Zip.FSpecArgs.Add(ASourceFile);
      Zip.Add; // 새로운 ZIP 파일 생성 및 파일 추가 실행
    end;

    // 2. 중요: Zip 작업을 완료하고 파일을 디스크에 기록(저장)하는 메서드 호출
    // TZipMaster에서 'Add' 작업 후 명시적으로 파일을 닫아주어야 작업이 완료됨
//    Zip.Close;

    // 3. 작업 성공 여부 확인 (옵션: 필요 시 예외 발생 또는 로그 기록)
    if Zip.ErrCode <> 0 then
    begin
      // 예: 오류 메시지 표시
      raise Exception.Create(Format('압축 작업 실패: 오류 코드 %d', [Zip.ErrCode]));
    end;

  finally
    Zip.Free;
  end;
end;

end.
