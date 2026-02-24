unit UnitmORMotUtil_DateTime;

interface

uses System.SysUtils, UnitStringUtil,
  mormot.core.base, mormot.core.datetime, mormot.core.rtti;

function GetTimeLogFromStr(AStr: string): TTimeLog;
function GetDateStrFromTimeLog(ATimeLog: TTimeLog): string;

implementation

function GetTimeLogFromStr(AStr: string): TTimeLog;
var
  Ly, Lm, Ld: word;
begin
  Result := 0;

  if (AStr <> '') and (Pos('-', AStr) <> 0)then
  begin
    Ly := StrToIntDef(strToken(AStr, '-'),0);
    if Ly <> 0 then
    begin
      Lm := StrToIntDef(strToken(AStr, '-'),0);
      Ld := StrToIntDef(strToken(AStr, '-'),0);
      Result := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
    end;
  end;
end;

function GetDateStrFromTimeLog(ATimeLog: TTimeLog): string;
var
  LDate: TDate;
begin
  LDate := TimeLogToDateTime(ATimeLog);
  Result := DateToStr(LDate);
end;

// Helper to detect TDateTime type by name
function IsDateTimeTypeName(Info: PRttiInfo): boolean;
var
  Name: PShortString;
begin
  Result := False;
  if Info = nil then Exit;
  Name := @Info^.RawName;
  Result := (Name^ = 'TDateTime') or (Name^ = 'TDate') or (Name^ = 'TTime');
end;

// Convert all TDateTime fields in record
procedure ConvertRecordDateTimesToTimezone(var Rec; RecTypeInfo: PRttiInfo; HoursOffset: Double);
var
  RC: TRttiCustom;
  i: Integer;
  DT: PDouble;
begin
  RC := Rtti.RegisterType(RecTypeInfo);
  if (RC = nil) or (RC.Props.Count = 0) then Exit;

  for i := 0 to RC.Props.Count - 1 do
    with RC.Props.List[i] do
      if (Value.Parser in [ptDateTime, ptDateTimeMS]) or
         IsDateTimeTypeName(Value.Info) then
      begin
        DT := PDouble(PAnsiChar(@Rec) + OffsetGet);
        if DT^ <> 0 then
          DT^ := DT^ + (HoursOffset / 24);
      end;
end;

{
type
  TMyRecord = packed record
    ID: Integer;
    Name: RawUtf8;
    CreatedAt: TDateTime;
    ModifiedAt: TDateTime;
    Amount: Double;          // Double - won't be touched
    ExpireDate: TDateTime;
    Count: Int64;
  end;

  var
    Rec: TMyRecord;
  begin
    // ... populate Rec ...
     Rtti.RegisterFromText(TypeInfo(TMyRecord),
      'ID: Integer; ' +
      'Name: RawUtf8; ' +
      'CreatedAt: TDateTime; ' +
      'ModifiedAt: TDateTime; ' +
      'Amount: Double; ' +
      'ExpireDate: TDateTime; ' +
      'Count: Int64');

    // Convert from UTC to GMT+8
    ConvertRecordDateTimesToTimezone(Rec, TypeInfo(TMyRecord), 8);

    // Convert from UTC to EST (GMT-5)
    ConvertRecordDateTimesToTimezone(Rec, TypeInfo(TMyRecord), -5);
  end;
}
end.
