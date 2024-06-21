unit UnitToDoList;

interface

uses System.Classes, DateUtils, TodoList,
  mormot.rest.client, mormot.core.base, mormot.core.data, mormot.core.variants,
  mormot.core.text, mormot.core.datetime, mormot.core.collections
  ;

type
  TpjhTodoItemRec = packed record
    TaskID: TID;
    ImageIndex: Integer;
    Notes: TStringList;
    Tag: Integer;
    TotalTime: double;
    Subject: string;
    Completion: integer;//TCompletion;
    DueDate: TTimeLog;
    Priority: integer;//TTodoPriority;
    Status: integer;//TTodoStatus;
    OnChange: TNotifyEvent;
    Complete: Boolean;
    CreationDate: TTimeLog;
    CompletionDate: TTimeLog;
    Resource: string;
    DBKey: string;
    Project: string;
    Category: string;

    TodoCode,
    PlanCode,
    ModId: string;

    AlarmType,
    AlarmTime2, //AlarmType이 2인 경우(분)
    AlarmFlag
    : integer;
    Alarm2Msg,   //문자로 알림 = 1
    Alarm2Note,  //쪽지로 알림 = 1
    Alarm2Email, //이메일로 알림 = 1
    Alarm2Popup //팜업창으로 알림 = 1
    : Boolean;

    AlarmTime1, //AlarmType이 1인 경우 시각
    ModDate: TTimeLog;

    AlarmTime: TTimeLog; //Alarm을 발생 시켜야할 시각
  end;

  TpjhToDoList = IList<TpjhTodoItemRec>;

implementation

end.
