unit UnitFileInfoUtil;

interface

uses  Winapi.Windows, System.Classes, System.SysUtils, System.DateUtils
  ,JclWin32, PJVersionInfo
  ;

//const
//  BUILD_DATE = {$I %DATE%};

function GetBuildDateByPEImage: TDateTime;
function GetBuildDateByPJVerInfo(const AFileName: string=''): TDateTime;
function GetCommentByPJVerInfo(const AFileName: string): string;
function GetInternalNameByPJVerInfo(const AFileName: string): string;
function GetFileVersionByPJVerInfo(const AFileName: string): string;
function GetFileVersionListByPJVerInfoFromFolder(const AFolder: string; const AIsOnlyExeDll: Boolean = true): TStringList;
//AList : Full Path FileName List
//결과값은 FilaName = version 포맷으로 반환 함
function GetFileVersionListByPJVerInfoFromList(AList: TStringList): integer;

function IsValidFileName(const AFileName: string): Boolean;
function GetValidFileName(const AFileName: string): string;

function Isx64PEImage(const AStream: TStream): Boolean; overload;
function Isx64PEImage(const APEImageFileName: string): Boolean; overload;

implementation

uses UnitFileSearchUtil;

function GetBuildDateByPEImage: TDateTime;
var
  LI: TLoadedImage;
  timeStamp: Cardinal;
  utcTime: TDateTime;
  LStr: string;
begin
  LStr := ParamStr(0);
  MapAndLoad(PAnsiChar(LStr), nil, LI, False, True);
  timeStamp := LI.FileHeader.FileHeader.TimeDateStamp;
  UnMapAndLoad(LI);

  utcTime := UnixToDateTime(timeStamp);
  Result := TTimeZone.Local.ToLocalTime(utcTime);
end;

function GetBuildDateByPJVerInfo(const AFileName: string=''): TDateTime;
var
  LPJVerInfo: TPJVersionInfo;
begin
  LPJVerInfo := TPJVersionInfo.Create(nil);
  LPJVerInfo.FileName := AFileName;
  try
    Result := EncodeDate((LPJVerInfo.FixedFileInfo.dwFileDateMS shr 16), //Year
                          (LPJVerInfo.FixedFileInfo.dwFileDateMS and $FFFF), //Month
                          (LPJVerInfo.FixedFileInfo.dwFileDateLS shr 16));//Day

  finally
    LPJVerInfo.Free;
  end;
end;

function GetCommentByPJVerInfo(const AFileName: string): string;
var
  LPJVerInfo: TPJVersionInfo;
begin
  LPJVerInfo := TPJVersionInfo.Create(nil);
  try
    LPJVerInfo.FileName := AFileName;
    Result := LPJVerInfo.Comments;
  finally
    LPJVerInfo.Free;
  end;
end;

function GetInternalNameByPJVerInfo(const AFileName: string): string;
var
  LPJVerInfo: TPJVersionInfo;
begin
  LPJVerInfo := TPJVersionInfo.Create(nil);
  try
    LPJVerInfo.FileName := AFileName;
    Result := LPJVerInfo.InternalName;
  finally
    LPJVerInfo.Free;
  end;
end;

function GetFileVersionByPJVerInfo(const AFileName: string): string;
var
  LPJVerInfo: TPJVersionInfo;
begin
  LPJVerInfo := TPJVersionInfo.Create(nil);
  try
    LPJVerInfo.FileName := AFileName;
    Result := LPJVerInfo.FileVersion;
  finally
    LPJVerInfo.Free;
  end;
end;

function GetFileVersionListByPJVerInfoFromFolder(const AFolder: string; const AIsOnlyExeDll: Boolean = true): TStringList;
var
  LFileList, LFileList2: TStringList;
  LFileMasks: array[0..1] of string;
  i: integer;
begin
  Result := TStringList.Create;

  LFileMasks[0] := '*.exe';
  LFileMasks[1] := '*.dll';

  if AIsOnlyExeDll then
  begin
    for i := Low(LFileMasks) to High(LFileMasks) do
    begin
      LFileList := GetFileListFromFolder(AFolder, LFileMasks[i], False);
      try
        Result.AddStrings(LFileList);
      finally
        LFileList.Free;
      end;
    end;
  end
  else
  begin
    LFileList := GetFindFileList('*.*');
    try
      Result.AddStrings(LFileList);
    finally
      LFileList.Free;
    end;
  end;

  GetFileVersionListByPJVerInfoFromList(Result);
end;

function GetFileVersionListByPJVerInfoFromList(AList: TStringList): integer;
var
  LPJVerInfo: TPJVersionInfo;
  i: integer;
  LFileName: string;
begin
  Result := -1;

  LPJVerInfo := TPJVersionInfo.Create(nil);
  try
    for i := 0 to AList.Count - 1 do
    begin
      LFileName := AList.Strings[i];
      LPJVerInfo.FileName := LFileName;

      if FileExists(LFileName) then
        AList.Strings[i] := LFileName + '=' + LPJVerInfo.FileVersion
      else
        AList.Strings[i] := LFileName + '=';
    end;

    Result := AList.Count;
  finally
    LPJVerInfo.Free;
  end;
end;

function IsValidFileName(const AFileName: string): Boolean;
const
  InvalidChars: set of Char = ['\', '/', ':', '*', '?', '"', '<', '>', '|'];
var
  i: integer;
begin
  Result := (AFileName <> '') and (Length(AFileName) <= MAX_PATH);

  if Result then
  begin
    for i := 1 to Length(AFileName) do
    begin
      if AFileName[i] in InvalidChars then
      begin
        Result := False;
        Break;
      end;
    end;
  end;
end;

function GetValidFileName(const AFileName: string): string;
const
  InvalidChars: set of Char = ['\', '/', ':', '*', '?', '"', '<', '>', '|'];
var
  i: integer;
  LStr, LFilePath, LFileName: string;
  LIsModified: Boolean;
begin
  Result := '';
  LIsModified := False;

  LFilePath := ExtractFilePath(AFileName);
  LFileName := ExtractFileName(AFileName);

  if (LFileName <> '') and (Length(LFileName) <= MAX_PATH) then
  begin
    for i := 1 to Length(LFileName) do
    begin
      if LFileName[i] in InvalidChars then
      begin
        LStr := StringReplace(LFileName, LFileName[i], '_', [rfReplaceAll]);
        LIsModified := True;
      end;
    end;//for

    if LIsModified then
      Result := LFilePath + LStr
    else
      Result := AFileName;
  end;
end;

function Isx64PEImage(const AStream: TStream): Boolean; overload;
var
  LDOSHeader: TImageDosHeader;
  LImageNtHeaders: TImageNtHeaders;
begin
//  if AStream.Read(LDOSHeader, SizeOf(TImageDosHeader)) <> SizeOf(TImageDosHeader) then
//    RaiseInvalidExecutrable;
//
//  if (LDOSHeader.e_magic <> IMAGE_DOS_SIGNATURE) or (LDOSHeader._lfanew = 0) then
//    RaiseInvalidExecutrable;
//
//  if AStream.Size < LDOSHeader._lfanew then
//    RaiseInvalidExecutrable;
//
//  AStream.Position := LDOSHeader._lfanew;
//  if AStream.Read(LImageNtHeaders, SizeOf(TImageNtHeaders)) <> SizeOf(TImageNtHeaders) then
//    RaiseInvalidExecutrable;
//
//  if LImageNtHeaders.Signature <> IMAGE_NT_SIGNATURE then
//    RaiseInvalidExecutrable;
//
//  Result := LImageNtHeaders.FileHeader.Machine <> IMAGE_FILE_MACHINE_I386;
end;

function Isx64PEImage(const APEImageFileName: string): Boolean; overload;
//var
//  LPEImageStream: TBufferedFileStream;
begin
//  LPEImageStream := TBufferedFileStream.Create(APEImageFileName, fmOpenRead);
//  try
//    Result := Isx64PEImage(LPEImageStream);
//  finally
//    LPEImageStream.Free;
//  end;
end;

end.
