unit UnitStateMachineUtil;

interface

uses System.Classes, Generics.Collections, Vcl.StdCtrls,
  mormot.core.collections,
  UnitGenericsStateMachine_pjh, UnitEnumHelper;

type
  TFSMHelper<TState, TTrigger> = class
    class function GetStateNTriggers2StringsUsingEnumHelper(const AFSM: TStateMachine<TState, TTrigger>;
      const AState: TState; const AEnumState: TLabelledEnum<TState>; const AEnumTrigger: TLabelledEnum<TTrigger>): TStrings;
    class function GetTriggers2StringsByStateUsingEnumHelper(const AFSM: TStateMachine<TState, TTrigger>;
      const AState: TState; const AEnum: TLabelledEnum<TTrigger>): TStrings;
    class function GetAllStates2StringsUsingEnumHelper(const AFSM: TStateMachine<TState, TTrigger>;
      const AEnum: TLabelledEnum<TState>): TStrings;
    class procedure GetStateNTriggers2ComboUsingEnumHelper(const AFSM: TStateMachine<TState, TTrigger>;
      const AState: TState; const AEnumState: TLabelledEnum<TState>; const AEnumTrigger: TLabelledEnum<TTrigger>; ACombo: TComboBox);
    class procedure GetAllStates2ComboUsingEnumHelper(const AFSM: TStateMachine<TState, TTrigger>;
      const AEnum: TLabelledEnum<TState>; ACombo: TComboBox);
    class procedure GetTriggers2ComboByStateUsingEnumHelper(const AFSM: TStateMachine<TState, TTrigger>;
      const AState: TState; const AEnum: TLabelledEnum<TTrigger>; ACombo: TComboBox);
  end;

implementation

class procedure TFSMHelper<TState, TTrigger>.GetAllStates2ComboUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>; const AEnum: TLabelledEnum<TState>; ACombo: TComboBox);
var
  LStrList: TStringList;
begin
  LStrList := GetAllStates2StringsUsingEnumHelper(AFSM, AEnum) as TStringList;
  try
    ACombo.Clear;
    ACombo.Items.AddStrings(LStrList);
  finally
    LStrList.Free;
  end;
end;

class function TFSMHelper<TState, TTrigger>.GetAllStates2StringsUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>; const AEnum: TLabelledEnum<TState>): TStrings;
var
  LStr: string;
//  LState: TStateHolder<TState, TTrigger>;
  LStateValue: TPair<TState, TStateHolder<TState, TTrigger>>;
begin
  Result := TStringList.Create;

  for LStateValue in AFSM.States do
  begin
    LStr := AEnum.ToString(LStateValue.Key);

    Result.Add(LStr);
  end;//for
end;

class procedure TFSMHelper<TState, TTrigger>.GetStateNTriggers2ComboUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>; const AState: TState;
  const AEnumState: TLabelledEnum<TState>; const AEnumTrigger: TLabelledEnum<TTrigger>; ACombo: TComboBox);
var
  LStrList: TStringList;
begin
  LStrList := GetStateNTriggers2StringsUsingEnumHelper(AFSM, AState, AEnumState, AEnumTrigger) as TStringList;
  try
    ACombo.Clear;
    ACombo.Items.AddStrings(LStrList);
  finally
    LStrList.Free;
  end;
end;

class function TFSMHelper<TState, TTrigger>.GetStateNTriggers2StringsUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>; const AState: TState;
  const AEnumState: TLabelledEnum<TState>; const AEnumTrigger: TLabelledEnum<TTrigger>): TStrings;
var
  LStr: string;
  LState: TStateHolder<TState, TTrigger>;
//  LTrigger: TTriggerHolder<TState, TTrigger>;
  LTrigger: TPair<TTrigger, TTriggerHolder<TState, TTrigger>>;
  LStateValue: TPair<TState, TStateHolder<TState, TTrigger>>;
begin
  Result := TStringList.Create;

  LState :=  AFSM.GetStateHolder(AState);

  if Assigned(LState) then //특정 State의 Trigger들을 반환함
  begin
    for LTrigger in LState.Triggers do
    begin
      LStr := AEnumState.ToString(LState.State) + ' -> ' +
        AEnumTrigger.ToString(LTrigger.Key) + ' -> ' +
        AEnumState.ToString(LTrigger.Value.Destination);

      Result.Add(LStr);
    end;
  end
  else
  begin //State가 Null 이면 State Machine에 있는 모든 State + Trigger를 반환함
    for LStateValue in AFSM.States do
    begin
      for LTrigger in LStateValue.Value.Triggers do
      begin
        LStr := AEnumState.ToString(LState.State) + ' -> ' +
          AEnumTrigger.ToString(LTrigger.Key) + ' -> ' +
          AEnumState.ToString(LTrigger.Value.Destination);

        Result.Add(LStr);
      end;
    end;//for
  end;

end;

class procedure TFSMHelper<TState, TTrigger>.GetTriggers2ComboByStateUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>; const AState: TState; const AEnum: TLabelledEnum<TTrigger>;
  ACombo: TComboBox);
var
  LStrList: TStringList;
begin
  LStrList := GetTriggers2StringsByStateUsingEnumHelper(AFSM, AState, AEnum) as TStringList;
  try
    ACombo.Clear;
    ACombo.Items.AddStrings(LStrList);
  finally
    LStrList.Free;
  end;
end;

class function TFSMHelper<TState, TTrigger>.GetTriggers2StringsByStateUsingEnumHelper(
  const AFSM: TStateMachine<TState, TTrigger>; const AState: TState; const AEnum: TLabelledEnum<TTrigger>): TStrings;
var
  LStr: string;
  LState: TStateHolder<TState, TTrigger>;
//  LTrigger: TTriggerHolder<TState, TTrigger>;
  LTrigger: TPair<TTrigger, TTriggerHolder<TState, TTrigger>>;
  LStateValue: TPair<TState, TStateHolder<TState, TTrigger>>;
begin
  Result := TStringList.Create;

  LState :=  AFSM.GetStateHolder(AState);

  if Assigned(LState) then //특정 State의 Trigger들을 반환함
  begin
    for LTrigger in LState.Triggers do
    begin
      LStr := AEnum.ToString(LTrigger.Key);
      Result.Add(LStr);
    end;
  end
  else
  begin //State가 Null 이면 State Machine에 있는 모든 State + Trigger를 반환함
    for LStateValue in AFSM.States do
    begin
      for LTrigger in LState.Triggers do
      begin
        LStr := AEnum.ToString(LTrigger.Key);
        Result.Add(LStr);
      end;
    end;//for
  end;
end;

end.
