unit UnitDateUtil2;

interface

uses Windows, SysUtils, System.DateUtils, Vcl.ComCtrls, Winapi.CommCtrl;

type TDateTimePickerAccess = class(TDateTimePicker);

procedure PopupDateTimePicker(ADateTimePicker: TDateTimePicker; AX, AY: integer);
//Date만 가능함
function GetDateFromFormatStr(AFormat: string; ADateSep: Char; ADateStr: string): TDate;
function GetTimeFromFormatStr(AFormat: string; ATimeSep: Char; ATimeStr: string): TTime;
function AddTimeStrings(const Time1, Time2: string): string;

implementation

procedure PopupDateTimePicker(ADateTimePicker: TDateTimePicker; AX, AY: integer);
var
  ST: TSystemTime;
  CalendarHandle: HWND;
begin
  ADateTimePicker.Date := Date;
  DateTimeToSystemTime(Date, ST);
  CalendarHandle := TDateTimePickerAccess(ADateTimePicker).GetCalendarHandle;
  MonthCal_SetCurSel(CalendarHandle, ST);
end;

function GetDateFromFormatStr(AFormat: string; ADateSep: Char; ADateStr: string): TDate;
var
  LDT: TDateTime;
  LFormat: TFormatSettings;
begin
  LFormat := TFormatSettings.Create;
  LFormat.DateSeparator := ADateSep;//'-';
  LFormat.ShortDateFormat := AFormat;
  Result := StrToDateTime(ADateStr, LFormat);
end;

function GetTimeFromFormatStr(AFormat: string; ATimeSep: Char; ATimeStr: string): TTime;
var
  LDT: TDateTime;
  LFormat: TFormatSettings;
begin
  LFormat := TFormatSettings.Create;
  LFormat.TimeSeparator := ATimeSep;//':';
  LFormat.ShortTimeFormat := AFormat;
  Result := StrToDateTime(ATimeStr, LFormat);
end;

//Time = hh:mm 형식임
//문자열로 된 두개의 시간을 더하여 문자열로 반환 함
function AddTimeStrings(const Time1, Time2: string): string;
var
  Hour1, Min1, Hour2, Min2: Integer;
  TotalMin, TotalHour: Integer;
begin
  // 각 시간 파싱
  Hour1 := StrToInt(Copy(Time1, 1, 2));
  Min1  := StrToInt(Copy(Time1, 4, 2));

  Hour2 := StrToInt(Copy(Time2, 1, 2));
  Min2  := StrToInt(Copy(Time2, 4, 2));

  // 총 시간 계산
  TotalMin := Min1 + Min2;
  TotalHour := Hour1 + Hour2 + (TotalMin div 60);
  TotalMin := TotalMin mod 60;

  // 'hh:mm' 형식으로 반환
  Result := Format('%.2d:%.2d', [TotalHour, TotalMin]);
end;

end.
