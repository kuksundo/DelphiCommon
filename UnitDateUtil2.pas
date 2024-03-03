unit UnitDateUtil2;

interface

uses Windows, SysUtils, System.DateUtils, Vcl.ComCtrls, Winapi.CommCtrl;

type TDateTimePickerAccess = class(TDateTimePicker);

procedure PopupDateTimePicker(ADateTimePicker: TDateTimePicker; AX, AY: integer);

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

end.
