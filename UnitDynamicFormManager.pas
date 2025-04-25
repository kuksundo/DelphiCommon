unit UnitDynamicFormManager;

interface

uses
  System.Classes, Vcl.Forms, TimerPool, System.Generics.Collections,
  mormot.core.collections, mormot.core.os;

type
  TGPFormManager = class
  private
    FFormList: IKeyValue<THandle, TForm>;
    FPJHTimerPool: TPJHTimerPool;
    FHandleQ4DestroyForm: TQueue<THandle>;

    procedure OnDestroyForm(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
  public
    Safe: TLightLock;

    constructor Create;
    destructor Destroy; override;

    function CreateNewForm(AOwner: TComponent; AFormClass: TFormClass; AIsShowForm: Boolean=True): TForm;
    procedure CloseAllForms;

    function DestroyForm(const AHandle: THandle): integer;
    function DestroyFormFromHandleQ(): integer;
  end;

var
  g_GPFormManager: TGPFormManager;

implementation

{ TGPFormManager }

procedure TGPFormManager.CloseAllForms;
var
  i: integer;
begin
  for i := FFormList.Count - 1 downto 0 do
    FFormList.Value[i].Close;
end;

constructor TGPFormManager.Create;
begin
  inherited Create;

  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FHandleQ4DestroyForm := TQueue<THandle>.Create;
  FFormList := Collections.NewKeyValue<THandle, TForm>;
end;

function TGPFormManager.CreateNewForm(AOwner: TComponent;
  AFormClass: TFormClass; AIsShowForm: Boolean): TForm;
var
  NewForm: TForm;
begin
  NewForm := AFormClass.Create(AOwner);

  Safe.Lock;
  try
    FFormList.Add(NewForm.Handle, NewForm);
  finally
    Safe.UnLock;
  end;

  if AIsShowForm then
    NewForm.Show;

  Result := NewForm;
end;

destructor TGPFormManager.Destroy;
begin
  FHandleQ4DestroyForm.Free;

  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;

  FFormList.Clear;  //Form Memory ¿⁄µø «ÿ¡¶«ÿ¡‹
//  CloseAllForms; //∏µÁ ∆˚ ¥›±‚

  inherited Destroy;
end;

function TGPFormManager.DestroyForm(const AHandle: THandle): integer;
begin
  Safe.Lock();
  try
    FHandleQ4DestroyForm.Enqueue(AHandle);
    FPJHTimerPool.AddOneTime(OnDestroyForm, 500);
  finally
    Safe.UnLock;
  end;
end;

function TGPFormManager.DestroyFormFromHandleQ: integer;
var
  LHandle: THandle;
begin
  Safe.Lock;
  try
    if FHandleQ4DestroyForm.Count = 0 then
      exit;

    while FHandleQ4DestroyForm.Count > 0 do
    begin
      LHandle := FHandleQ4DestroyForm.Dequeue;

      if FFormList.ContainsKey(LHandle) then
      begin
//        FFormList.Items[LHandle].Free;
        FFormList.Remove(LHandle);  //Form Memory ¿⁄µø «ÿ¡¶«ÿ¡‹
      end;
    end;
  finally
    Safe.UnLock;
  end;
end;

procedure TGPFormManager.OnDestroyForm(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  DestroyFormFromHandleQ();
end;

initialization
finalization
  if Assigned(g_GPFormManager) then
    g_GPFormManager.Free;
end.
