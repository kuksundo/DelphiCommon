unit UnitFileInfoUtil;

interface

uses  Winapi.Windows, System.Classes, System.SysUtils, System.DateUtils
  ,JclWin32, PJVersionInfo
  ;

//const
//  BUILD_DATE = {$I %DATE%};

function GetBuildDateByPEImage: TDateTime;
function GetBuildDateByPJVerInfo(const AFileName: string=''): TDateTime;
function GetCommentByPJVerInfo(): string;
function GetInternalNameByPJVerInfo(): string;
function IsValidFileName(const AFileName: string): Boolean;
function GetValidFileName(const AFileName: string): string;

implementation

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
  try
    Result := EncodeDate((LPJVerInfo.FixedFileInfo.dwFileDateMS shr 16), //Year
                          (LPJVerInfo.FixedFileInfo.dwFileDateMS and $FFFF), //Month
                          (LPJVerInfo.FixedFileInfo.dwFileDateLS shr 16));//Day

  finally
    LPJVerInfo.Free;
  end;
end;

function GetCommentByPJVerInfo(): string;
var
  LPJVerInfo: TPJVersionInfo;
begin
  LPJVerInfo := TPJVersionInfo.Create(nil);
  try
    Result := LPJVerInfo.Comments;
  finally
    LPJVerInfo.Free;
  end;
end;

function GetInternalNameByPJVerInfo(): string;
var
  LPJVerInfo: TPJVersionInfo;
begin
  LPJVerInfo := TPJVersionInfo.Create(nil);
  try
    Result := LPJVerInfo.InternalName;
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

end.
