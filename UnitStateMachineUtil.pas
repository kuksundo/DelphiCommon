unit UnitStateMachineUtil;

interface

uses System.Classes, Generics.Collections, Vcl.StdCtrls,
  UnitGenericsStateMachine_pjh, UnitEnumHelper;

type
  TFSMHelper<TState, TTrigger> = class
    class function GetStateNTriggers2StringsUsingEnumHelper(const AFSM: TStateMachine<TState, TTrigger>; const AState: TState): TStrings;
    class function GetAllStates2StringsUsingEnumHelper(const AFSM: TStateMachine<TState, TTrigger>): TStrings;
    class procedure GetStateNTriggers2ComboUsingEnumHelper(
      const AFSM: TStateMachine<TState, TTrigger>; const AState: TState; ACombo: TComboBox);
    class procedure GetAllStates2ComboUsingEnumHelper(
      const AFSM: TStateMachine<TState, TTrigger>; ACombo: TComboBox);

  end;

implementation

class procedure TFSMHelper<TState, TTrigger>.GetAllStates2ComboUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>; ACombo: TComboBox);
var
  LStrList: TStringList;
begin
  LStrList := GetAllStates2StringsUsingEnumHelper(AFSM) as TStringList;
  try
    ACombo.Clear;
    ACombo.Items.AddStrings(LStrList);
  finally
    LStrList.Free;
  end;
end;

class function TFSMHelper<TState, TTrigger>.GetAllStates2StringsUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>): TStrings;
var
  LStr: string;
  LState: TStateHolder<TState, TTrigger>;
  LEnum: TLabelledEnum<TState>;
begin
  Result := TStringList.Create;

  for LState in AFSM.States.Values do
  begin
    LStr := LEnum.ToString(LState.State);

    Result.Add(LStr);
  end;//for
end;

class procedure TFSMHelper<TState, TTrigger>.GetStateNTriggers2ComboUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>; const AState: TState; ACombo: TComboBox);
var
  LStrList: TStringList;
begin
  LStrList := GetStateNTriggers2StringsUsingEnumHelper(AFSM, AState) as TStringList;
  try
    ACombo.Clear;
    ACombo.Items.AddStrings(LStrList);
  finally
    LStrList.Free;
  end;
end;

class function TFSMHelper<TState, TTrigger>.GetStateNTriggers2StringsUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>; const AState: TState): TStrings;
var
  LStr: string;
  LEnumState: TLabelledEnum<TState>;
  LEnumTrigger: TLabelledEnum<TTrigger>;
  LState: TStateHolder<TState, TTrigger>;
  LTrigger: TTriggerHolder<TState, TTrigger>;
begin
  Result := TStringList.Create;

  LState :=  AFSM.GetStateHolder(AState);

  if Assigned(LState) then //특정 State의 Trigger들을 반환함
  begin
    for LTrigger in LState.Triggers.Values do
    begin
      LStr := LEnumState.ToString(LState.State) + ' -> ' +
        LEnumTrigger.ToString(LTrigger.Trigger) + ' -> ' +
        LEnumState.ToString(LTrigger.Destination);

      Result.Add(LStr);
    end;
  end
  else
  begin //State가 Null 이면 State Machine에 있는 모든 State + Trigger를 반환함
    for LState in AFSM.States.Values do
    begin
      for LTrigger in LState.Triggers.Values do
      begin
        LStr := LEnumState.ToString(LState.State) + ' -> ' +
          LEnumTrigger.ToString(LTrigger.Trigger) + ' -> ' +
          LEnumState.ToString(LTrigger.Destination);

        Result.Add(LStr);
      end;
    end;//for
  end;

end;

end.
