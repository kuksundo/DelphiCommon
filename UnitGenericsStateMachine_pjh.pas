{***************************************************************************}
{                                                                           }
{           Generics.StateMachine                                           }
{                                                                           }
{           Copyright (C) Malcolm Groves                                    }
{                                                                           }
{           http://www.malcolmgroves.com                                    }
{                                                                           }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}

unit UnitGenericsStateMachine_pjh;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, Generics.Collections, Vcl.StdCtrls,
  Generics.Nullable, mormot.core.collections;

type
  EStateMachineException = class(Exception);
  EGuardFailure = class(EStateMachineException);
  EUnknownTrigger = class(EStateMachineException);
  EUnknownState = class(EStateMachineException);
  EInvalidStateMachine = class(EStateMachineException);

  TGuardProc<TTrigger> = reference to function(Trigger : TTrigger): boolean;
  TTransitionProc = reference to procedure;

  TTriggerHolder<TState, TTrigger> = class
  strict private
    FTrigger: TTrigger;
    FDestination: TState;
    FGuard: TGuardProc<TTrigger>;
  public
    constructor Create(ATrigger: TTrigger; ADestination: TState;
      AGuard: TGuardProc<TTrigger> = nil); virtual;
    function CanExecute: boolean;

    property Destination: TState read FDestination;
    property Trigger: TTrigger read FTrigger;
  end;

  TStateMachine<TState, TTrigger> = class;

  TStateHolder<TState, TTrigger> = class
  strict private
    FTriggers: IKeyValue<TTrigger, TTriggerHolder<TState, TTrigger>>;
    FState: TState;
    FStateMachine: TStateMachine<TState, TTrigger>;
    FOnEntry: TTransitionProc;
    FOnExit: TTransitionProc;

    function GetTriggerCount: Integer;
    function GetTriggers: IKeyValue<TTrigger, TTriggerHolder<TState, TTrigger>>;
  protected
    procedure Enter;
    procedure Exit;
  public
    constructor Create(AStateMachine: TStateMachine<TState, TTrigger>;
      AState: TState); virtual;
    destructor Destroy; override;
    function Destinations : TList<TState>;
    function AddTrigger(ATrigger: TTrigger; ADestination: TState;
      AGuard: TGuardProc<TTrigger> = nil): TStateHolder<TState, TTrigger>;
    function OnEntry(AOnEntry: TTransitionProc)
      : TStateHolder<TState, TTrigger>;
    function OnExit(AOnExit: TTransitionProc)
      : TStateHolder<TState, TTrigger>;
    function Initial: TStateHolder<TState, TTrigger>;
    procedure Execute(ATrigger: TTrigger);
    function TriggerExists(ATrigger: TTrigger) : boolean;
    function GetTrigger(ATrigger: TTrigger) : TTriggerHolder<TState, TTrigger>;

    property Triggers: IKeyValue<TTrigger, TTriggerHolder<TState, TTrigger>> read GetTriggers;
    property TriggerCount: Integer read GetTriggerCount;
    property State: TState read FState;
  end;

  /// <summary>
  /// TStateMachine is a simple state machine that uses generic types to
  /// specify the different possible states and also the triggers that
  /// transition between the states.
  /// </summary>
  /// <typeparam name="TState">
  /// The type you wish to use to�specify the different possible states of
  /// your state machine.
  /// </typeparam>
  /// <typeparam name="TTrigger">
  /// The type you wish to use to�specify the different triggers in your
  /// state machine. A trigger is how you tell the state machine to
  /// transition from one state to another.
  /// </typeparam>
  TStateMachine<TState, TTrigger> = class
  strict private
    FStates: IKeyValue<TState, TStateHolder<TState, TTrigger>>;
    FCurrentState: TState;
    FInitialState: TNullable<TState>;
    FActive: boolean;
    function GetStateCount: Integer;
    procedure SetActive(const Value: boolean);
    function GetInitialState: TStateHolder<TState, TTrigger>;
    function GetCurrentState: TStateHolder<TState, TTrigger>;
  protected
    procedure TransitionToState(const AState: TState;
      AFirstTime: boolean = False);
    procedure SetInitialState(const AState: TState);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    /// <summary>
    /// Add a new state to the state machine.
    /// </summary>
    /// <param name="AState">
    /// The state you wish to have added.
    /// </param>
    /// <returns>
    /// Returns a TTStateCaddy for the state specified in the AState
    /// parameter.
    /// </returns>
    function AddState(AState: TState): TStateHolder<TState, TTrigger>;
    function GetStateHolder(AState: TState): TStateHolder<TState, TTrigger>;
    //AState���� ATrigger ���� �� Transition�ϴ� StateHolder ��ȯ ��
    function GetNextStateHolderByTrigger(AState: TState; ATrigger: TTrigger): TStateHolder<TState, TTrigger>;

    procedure Validate;
    function GetAllTriggerCount: integer;
    function GetStateNTriggers2Strings(const AState: TState): TStrings;
    function GetAllStates2Strings(): TStrings;
    procedure GetStateNTriggers2Combo(const AState: TState; ACombo: TComboBox);

    property StateCount: Integer read GetStateCount;
    property CurrentState: TStateHolder<TState, TTrigger>
      read GetCurrentState;
    property InitialState: TStateHolder<TState, TTrigger>
      read GetInitialState;
    property Active: boolean read FActive write SetActive;
    property States: IKeyValue<TState, TStateHolder<TState, TTrigger>> read FStates;
  end;

implementation

{ TTriggerCaddy<TState, TTrigger> }

function TTriggerHolder<TState, TTrigger>.CanExecute: boolean;
begin
  if Assigned(FGuard) then
    Result := FGuard(FTrigger)
  else
    Result := True;
end;

constructor TTriggerHolder<TState, TTrigger>.Create(ATrigger: TTrigger;
  ADestination: TState; AGuard: TGuardProc<TTrigger>);
begin
  inherited Create;
  FTrigger := ATrigger;
  FDestination := ADestination;
  FGuard := AGuard;
end;

{ TTStateCaddy<TState, TTrigger> }

function TStateHolder<TState, TTrigger>.AddTrigger(ATrigger: TTrigger;
  ADestination: TState; AGuard: TGuardProc<TTrigger>): TStateHolder<TState, TTrigger>;
var
  LConfiguredTrigger: TTriggerHolder<TState, TTrigger>;
begin
  LConfiguredTrigger := TTriggerHolder<TState, TTrigger>.Create(ATrigger,
    ADestination, AGuard);
  FTriggers.Add(ATrigger, LConfiguredTrigger);
  Result := self;
end;

constructor TStateHolder<TState, TTrigger>.Create(AStateMachine
  : TStateMachine<TState, TTrigger>; AState: TState);
begin
  inherited Create;
  FStateMachine := AStateMachine;
  FTriggers := Collections.NewKeyValue<TTrigger, TTriggerHolder<TState, TTrigger>>;
  FState := AState;
end;

function TStateHolder<TState, TTrigger>.Destinations: TList<TState>;
var
  LValue: TPair<TTrigger, TTriggerHolder<TState, TTrigger>>;
//  LTriggerHolder: TTriggerHolder<TState, TTrigger>;
begin
  Result := TList<TState>.Create;

  for LValue in FTriggers do
    Result.Add(LValue.Value.Destination);
//    Result.Add(LTriggerHolder.Destination);
end;

destructor TStateHolder<TState, TTrigger>.Destroy;
//var
//  LTrigger: TPair<TTrigger, TTriggerHolder<TState, TTrigger>>;
begin
//  for LTrigger in FTriggers do
//  begin
//    LTrigger.Value.Free;
//  end;

//  FreeAndNil(FTriggers);

  inherited;
end;

procedure TStateHolder<TState, TTrigger>.Enter;
begin
  if Assigned(FOnEntry) then
    FOnEntry;
end;

procedure TStateHolder<TState, TTrigger>.Execute(ATrigger: TTrigger);
var
  LTrigger: TTriggerHolder<TState, TTrigger>;
begin
  if not FStateMachine.Active then
    raise EStateMachineException.Create('StateMachine not active');

  if not FTriggers.TryGetValue(ATrigger, LTrigger) then
    raise EUnknownTrigger.Create('Requested Trigger not found');

  if not LTrigger.CanExecute then
    raise EGuardFailure.Create('Guard on trigger prevented execution');

  FStateMachine.TransitionToState(LTrigger.Destination);
end;

procedure TStateHolder<TState, TTrigger>.Exit;
begin
  if not FStateMachine.Active then
    raise EStateMachineException.Create('StateMachine not active');

  if Assigned(FOnExit) then
    FOnExit;
end;

function TStateHolder<TState, TTrigger>.GetTrigger(
  ATrigger: TTrigger): TTriggerHolder<TState, TTrigger>;
begin
  FTriggers.TryGetValue(ATrigger, Result);
end;

function TStateHolder<TState, TTrigger>.GetTriggerCount: Integer;
begin
  if Assigned(FTriggers) then
    Result := FTriggers.Count;
end;

function TStateHolder<TState, TTrigger>.GetTriggers: IKeyValue<TTrigger, TTriggerHolder<TState, TTrigger>>;
begin
  Result := FTriggers;
end;

function TStateHolder<TState, TTrigger>.Initial
  : TStateHolder<TState, TTrigger>;
begin
  FStateMachine.SetInitialState(FState);
  Result := self;
end;

function TStateHolder<TState, TTrigger>.TriggerExists(
  ATrigger: TTrigger): boolean;
var
  LTrigger: TTriggerHolder<TState, TTrigger>;
begin
  Result := FTriggers.TryGetValue(ATrigger, LTrigger);
end;

function TStateHolder<TState, TTrigger>.OnEntry(AOnEntry: TTransitionProc)
  : TStateHolder<TState, TTrigger>;
begin
  FOnEntry := AOnEntry;
  Result := self;
end;

function TStateHolder<TState, TTrigger>.OnExit(AOnExit: TTransitionProc)
  : TStateHolder<TState, TTrigger>;
begin
  FOnExit := AOnExit;
  Result := self;
end;

constructor TStateMachine<TState, TTrigger>.Create;
begin
  inherited Create;
  FStates := Collections.NewKeyValue<TState, TStateHolder<TState, TTrigger>>;
end;

destructor TStateMachine<TState, TTrigger>.Destroy;
//var
//  LStateValue: TPair<TState, TStateHolder<TState, TTrigger>>;
begin
//    for LStateValue in FStates do
//      LStateValue.Value.Free;

//  FStates.Free;
  inherited;
end;

procedure TStateMachine<TState, TTrigger>.GetStateNTriggers2Combo(
  const AState: TState; ACombo: TComboBox);
var
  LStrList: TStringList;
begin
  LStrList := GetStateNTriggers2Strings(AState) as TStringList;
  try
    ACombo.Clear;
    ACombo.Items.AddStrings(LStrList);
  finally
    LStrList.Free;
  end;
end;

function TStateMachine<TState, TTrigger>.GetStateNTriggers2Strings(const AState: TState): TStrings;
var
  LStr: string;
  LState: TStateHolder<TState, TTrigger>;
//  LTrigger: TTriggerHolder<TState, TTrigger>;
  LTrigger: TPair<TTrigger, TTriggerHolder<TState, TTrigger>>;
  LStateValue: TPair<TState, TStateHolder<TState, TTrigger>>;
begin
  Result := TStringList.Create;

  LState :=  GetStateHolder(AState);

  if Assigned(LState) then //Ư�� State�� Trigger���� ��ȯ��
  begin
//    for LTrigger in LState.Triggers.Values do
    for LTrigger in LState.Triggers do
    begin
      LStr := TValue.From<TState>(LState.State).ToString + ' -> ' +
        TValue.From<TTrigger>(LTrigger.Key).ToString + ' -> ' +
        TValue.From<TState>(LTrigger.Value.Destination).ToString;

      Result.Add(LStr);
    end;
  end
  else
  begin //State�� Null �̸� State Machine�� �ִ� ��� State + Trigger�� ��ȯ��
//    for LState in FStates.Values do
    for LStateValue in FStates do
    begin
      for LTrigger in LStateValue.Value.Triggers do
      begin
        LStr := TValue.From<TState>(LStateValue.Key).ToString + ' -> ' +
          TValue.From<TTrigger>(LTrigger.Key).ToString + ' -> ' +
          TValue.From<TState>(LTrigger.Value.Destination).ToString;

        Result.Add(LStr);
      end;
    end;//for
  end;
end;

function TStateMachine<TState, TTrigger>.GetAllStates2Strings: TStrings;
var
  LStr: string;
//  LState: TStateHolder<TState, TTrigger>;
  LStateValue: TPair<TState, TStateHolder<TState, TTrigger>>;
begin
  Result := TStringList.Create;

//  for LState in FStates.Values do
  for LStateValue in FStates do
  begin
    LStr := TValue.From<TState>(LStateValue.Key).ToString;
//    LStr := TValue.From<TState>(LState.State).ToString;

    Result.Add(LStr);
  end;//for
end;

function TStateMachine<TState, TTrigger>.GetAllTriggerCount: integer;
var
//  LState: TStateHolder<TState, TTrigger>;
  LStateValue: TPair<TState, TStateHolder<TState, TTrigger>>;
begin
  Result := 0;

//  for LState in FStates.Values do
  for LStateValue in FStates do
  begin
    Result := Result + LStateValue.Value.TriggerCount;
//    Result := Result + LState.TriggerCount;
  end;
end;

function TStateMachine<TState, TTrigger>.GetCurrentState
  : TStateHolder<TState, TTrigger>;
var
  LCurrentState: TStateHolder<TState, TTrigger>;
begin
  if not FStates.TryGetValue(FCurrentState, LCurrentState) then
    raise EUnknownState.Create('Unable to find Current State');

  Result := LCurrentState;
end;

function TStateMachine<TState, TTrigger>.GetInitialState
  : TStateHolder<TState, TTrigger>;
var
  LInitialState: TStateHolder<TState, TTrigger>;
begin
  if not FInitialState.HasValue then
    raise EInvalidStateMachine.Create('StateMachine has no initial state');

  if not FStates.TryGetValue(FInitialState, LInitialState) then
    raise EUnknownState.Create('Unable to find Initial State');

  Result := LInitialState;
end;

function TStateMachine<TState, TTrigger>.GetNextStateHolderByTrigger(
  AState: TState; ATrigger: TTrigger): TStateHolder<TState, TTrigger>;
var
  LCurrentBackup: TState;
begin
  LCurrentBackup := FCurrentState;

  Result := GetStateHolder(AState);
  Result.Execute(ATrigger);

  FCurrentState := LCurrentBackup;
end;

function TStateMachine<TState, TTrigger>.GetStateHolder(
  AState: TState): TStateHolder<TState, TTrigger>;
var
  LState: TStateHolder<TState, TTrigger>;
begin
  try
    if not FStates.TryGetValue(AState, LState) then
      raise EUnknownState.Create('Unable to find State');
  except
    Result := nil;
    exit;
  end;

  Result := LState;
end;

function TStateMachine<TState, TTrigger>.GetStateCount: Integer;
begin
  if Assigned(FStates) then
    Result := FStates.Count;
end;

procedure TStateMachine<TState, TTrigger>.SetActive(const Value: boolean);
begin
  if FActive <> Value then
  begin
    if Value and not FInitialState.HasValue then
      raise EInvalidStateMachine.Create('StateMachine has no initial state specified');

    FActive := Value;
    if FActive then
      TransitionToState(FInitialState, True);
  end;
end;

procedure TStateMachine<TState, TTrigger>.SetInitialState(const AState: TState);
begin
  if FInitialState.HasValue then
    raise EInvalidStateMachine.Create('StatMachine cannot have two Initial States');

  FInitialState := AState;
end;

procedure TStateMachine<TState, TTrigger>.TransitionToState
  (const AState: TState; AFirstTime: boolean);
begin
  if not Active then
    raise EStateMachineException.Create('StateMachine not active');

  if not FStates.ContainsKey(AState) then
    raise EUnknownState.Create('Unable to find Configured State');

  // only exit if not the first transition to initial state
  if not AFirstTime then
    CurrentState.Exit;

  FCurrentState := AState;

  CurrentState.Enter;
end;

procedure TStateMachine<TState, TTrigger>.Validate;
var
  LUnreachableStates : TList<TState>;
  LStateHolder, LInitialState : TStateHolder<TState, TTrigger>;
  LState: TState;
  LDestinations : TList<TState>;
  LValid : boolean;
  LStateValue: TPair<TState, TStateHolder<TState, TTrigger>>;
begin
  // State Machine has initial state?
  LInitialState := InitialState;
  // all states are reachable?
  LUnreachableStates := TList<TState>.Create;
  try
    // fill all states
//    for LState in FStates.Keys do
    for LStateValue in FStates do
    begin
      LUnreachableStates.Add(LStateValue.Key);
    end;
    // remove initial state, as it is valid to have an initial state with
    // no incoming trigger
    LUnreachableStates.Remove(InitialState.State);
    // remove those which are destinations of triggers
//    for LStateHolder in FStates.Values do
    for LStateValue in FStates do
    begin
      LDestinations := LStateValue.Value.Destinations;
      try
        for LState in LDestinations do
          LUnreachableStates.Remove(LState);
      finally
        LDestinations.Free;
      end;
    end;
    if LUnreachableStates.Count > 0 then
    begin
      LValid := False;
      // would be nice to include the states in the message, however will need to
      // research generic way to convert TState to string
      raise EInvalidStateMachine.Create(Format('State Machine has %d unreachable state(s)', [LUnreachableStates.Count]));
    end;
  finally
    LUnreachableStates.Free;
  end;

end;

function TStateMachine<TState, TTrigger>.AddState(AState: TState)
  : TStateHolder<TState, TTrigger>;
begin
  Result := TStateHolder<TState, TTrigger>.Create(self, AState);
  FStates.Add(AState, Result);
end;

end.
