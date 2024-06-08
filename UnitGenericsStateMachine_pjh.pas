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
  Generics.Nullable;

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
    FTriggers: TObjectDictionary<TTrigger, TTriggerHolder<TState, TTrigger>>;
    FState: TState;
    FStateMachine: TStateMachine<TState, TTrigger>;
    FOnEntry: TTransitionProc;
    FOnExit: TTransitionProc;

    function GetTriggerCount: Integer;
    function GetTriggers: TObjectDictionary<TTrigger, TTriggerHolder<TState, TTrigger>>;
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

    property Triggers: TObjectDictionary<TTrigger, TTriggerHolder<TState, TTrigger>> read GetTriggers;
    property TriggerCount: Integer read GetTriggerCount;
    property State: TState read FState;
  end;

  /// <summary>
  /// TStateMachine is a simple state machine that uses generic types to
  /// specify the different possible states and also the triggers that
  /// transition between the states.
  /// </summary>
  /// <typeparam name="TState">
  /// The type you wish to use to specify the different possible states of
  /// your state machine.
  /// </typeparam>
  /// <typeparam name="TTrigger">
  /// The type you wish to use to specify the different triggers in your
  /// state machine. A trigger is how you tell the state machine to
  /// transition from one state to another.
  /// </typeparam>
  TStateMachine<TState, TTrigger> = class
  strict private
    FStates: TObjectDictionary<TState, TStateHolder<TState, TTrigger>>;
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
    function GetState(AState: TState): TStateHolder<TState, TTrigger>;
    procedure Validate;
    function GetAllTriggerCount: integer;
    function GetStateNTriggers2Strings(const AState: TState): TStrings;
    procedure GetStateNTriggers2Combo(const AState: TState; ACombo: TComboBox);

    property StateCount: Integer read GetStateCount;
    property CurrentState: TStateHolder<TState, TTrigger>
      read GetCurrentState;
    property InitialState: TStateHolder<TState, TTrigger>
      read GetInitialState;
    property Active: boolean read FActive write SetActive;
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
  FTriggers := TObjectDictionary < TTrigger, TTriggerHolder < TState,
    TTrigger >>.Create([doOwnsValues]);
  FState := AState;
end;

function TStateHolder<TState, TTrigger>.Destinations: TList<TState>;
var
  LTriggerHolder: TTriggerHolder<TState, TTrigger>;
begin
  Result := TList<TState>.Create;
  for LTriggerHolder in FTriggers.Values do
    Result.Add(LTriggerHolder.Destination);
end;

destructor TStateHolder<TState, TTrigger>.Destroy;
begin
  FreeAndNil(FTriggers);
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

function TStateHolder<TState, TTrigger>.GetTriggers: TObjectDictionary<TTrigger, TTriggerHolder<TState, TTrigger>>;
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
  FStates := TObjectDictionary <TState, TStateHolder<TState, TTrigger>>.Create([doOwnsValues]);
end;

destructor TStateMachine<TState, TTrigger>.Destroy;
begin
  FStates.Free;
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
  LTrigger: TTriggerHolder<TState, TTrigger>;
begin
  Result := TStringList.Create;

  LState :=  GetState(AState);

  if Assigned(LState) then
  begin
    LStr := TValue.From<TState>(LState.State).ToString + ' -> ' +
      TValue.From<TTrigger>(LTrigger.Trigger).ToString + ' -> ' +
      TValue.From<TState>(LTrigger.Destination).ToString;

    Result.Add(LStr);
  end
  else
  begin
    for LState in FStates.Values do
    begin
      for LTrigger in LState.Triggers.Values do
      begin
        LStr := TValue.From<TState>(LState.State).ToString + ' -> ' +
          TValue.From<TTrigger>(LTrigger.Trigger).ToString + ' -> ' +
          TValue.From<TState>(LTrigger.Destination).ToString;

        Result.Add(LStr);
      end;
    end;//for
  end;
end;

function TStateMachine<TState, TTrigger>.GetAllTriggerCount: integer;
var
  LState: TStateHolder<TState, TTrigger>;
begin
  Result := 0;

  for LState in FStates.Values do
  begin
    Result := Result + LState.TriggerCount;
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

function TStateMachine<TState, TTrigger>.GetState(
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
begin
  // State Machine has initial state?
  LInitialState := InitialState;
  // all states are reachable?
  LUnreachableStates := TList<TState>.Create;
  try
    // fill all states
    for LState in FStates.Keys do
    begin
      LUnreachableStates.Add(LState);
    end;
    // remove initial state, as it is valid to have an initial state with
    // no incoming trigger
    LUnreachableStates.Remove(InitialState.State);
    // remove those which are destinations of triggers
    for LStateHolder in FStates.Values do
    begin
      LDestinations := LStateHolder.Destinations;
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
