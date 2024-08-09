unit UnitDateUtil2;

interface

uses Windows, SysUtils, System.DateUtils, Vcl.ComCtrls, Winapi.CommCtrl;

type TDateTimePickerAccess = class(TDateTimePicker);

procedure PopupDateTimePicker(ADateTimePicker: TDateTimePicker; AX, AY: integer);
//Date만 가능함
function GetDateFromFormatStr(AFormat: string; ADateSep: Char; ADateStr: string): TDate;
function GetTimeFromFormatStr(AFormat: string; ATimeSep: Char; ATimeStr: string): TTime;

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

end.
