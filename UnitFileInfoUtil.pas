unit UnitFileInfoUtil;

interface

uses  Winapi.Windows, System.Classes, System.SysUtils, System.DateUtils,
  JclWin32, PJVersionInfo;

//const
//  BUILD_DATE = {$I %DATE%};

function GetBuildDateByPEImage: TDateTime;
function GetBuildDateByPJVerInfo(const AFileName: string=''): TDateTime;
function GetCommentByPJVerInfo(const AFileName: string=''): string;

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

function GetCommentByPJVerInfo(const AFileName: string=''): string;
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

end.
