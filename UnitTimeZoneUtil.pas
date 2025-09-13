unit UnitTimeZoneUtil;

interface

uses
  System.SysUtils, Classes, System.Types,
  System.DateUtils,
  TZDB;

type
  TBundledTimeZoneHelper = class helper for TBundledTimeZone
    class function TimeZones2StrList(var AStrList: TStrings): integer; static;
  end;

function UTCToLocalTime(const ATzName: string; const AUtcDateTime: TDateTime): TDateTime;

implementation

function UTCToLocalTime(const ATzName: string; const AUtcDateTime: TDateTime): TDateTime;
var
  LTimeZone: TBundledTimeZone;
begin
  // IANA Time Zone ID를 이용해 TimeZone 객체 생성
  LTimeZone := TBundledTimeZone.Create(ATzName);
  try
    // UTC → Local 변환
    Result := LTimeZone.ToLocalTime(AUtcDateTime);
  finally
    LTimeZone.Free;
  end;
end;

{ TBundledTimeZoneHelper }

class function TBundledTimeZoneHelper.TimeZones2StrList(
  var AStrList: TStrings): integer;
var
  LStrDynArray: TStringDynArray;
  i: integer;
begin
//  LStrDynArray := TBundledTimeZone.KnownAliases();
  LStrDynArray := TBundledTimeZone.KnownTimeZones(True);

  for i := Low(LStrDynArray) to High(LStrDynArray) do
  begin
    AStrList.Add(LStrDynArray[i]);
  end;
end;

end.
