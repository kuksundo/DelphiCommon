unit UnitToDoList;

interface

uses System.Classes, DateUtils, TodoList,
  mormot.rest.client, mormot.core.base, mormot.core.data, mormot.core.variants,
  mormot.core.text, mormot.core.datetime, mormot.core.collections,
  UnitEnumHelper
  ;

type
  TTodoQueryDateType = (tdqdtNull, tdqdtCreation, tdqdtDuedate, tdqdtCompletion,
    tdqdtModDate, tdqdtAlarmTime, tdqdtFinal);

  TpjhTodoItemRec = packed record
    RowID: TID; //DB ID
    TaskID: TID;
    ImageIndex: Integer;
    UniqueID: string;
    Notes: string;
    Tag: Integer;
    TotalTime: double;
    Subject: string;
    Completion: integer;//TCompletion;
    DueDate: TTimeLog;//만료일자
    Priority: integer;//TTodoPriority;
    Status: integer;//TTodoStatus;
    OnChange: TNotifyEvent;
    Complete: Boolean;
    CreationDate: TTimeLog;//생성일자
    BeginDate, //시작일자(계획)
    BeginTime, //시작시각(계획)
    EndDate,   //종료일자(계획)
    EndTime,   //종료시각(계획)
    CompletionDate: TTimeLog; //완료한 일자
    Resource: string;
    Project: string;
    Category: string;

    PlanCode,
    ModId: string;

    AlarmType,  //미리알림유형
    AlarmTime2, //AlarmType이 2인 경우(분)
    AlarmFlag
    : integer;
    Alarm2Msg,   //문자로 알림
    Alarm2Note,  //쪽지로 알림
    Alarm2Email, //이메일로 알림
    Alarm2Popup //팜업창으로 알림
    : Boolean;

    AlarmTime1, //AlarmType이 1인 경우 시각
    ModDate: TTimeLog;

    AlarmTime: TTimeLog; //Alarm을 발생 시켜야할 시각
  end;

  //key = UniqueID
  TpjhToDoList = IKeyValue<string, TpjhTodoItemRec>;//IList<TpjhTodoItemRec>;

const
  R_TodoQueryDateType : array[Low(TTodoQueryDateType)..High(TTodoQueryDateType)] of string =
    ('',
      '일정생성일자기준', '만료일기준', '완료일기준', '일정수정일자기준', '알람발생시각기준',
    '');

var
  g_TodoQueryDateType: TLabelledEnum<TTodoQueryDateType>;

implementation

initialization
//  g_TodoQueryDateType.InitArrayRecord(R_TodoQueryDateType);

end.
