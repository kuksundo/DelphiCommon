unit UnitStringStack;

interface

uses System.Generics.Collections;

type
  TStringStack = class
  private
    FStack: TStack<string>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Push(const AValue: string);
    function Pop: string;
    function Peek: string;
    function IsEmpty: boolean;
    function Count: integer;
  end;

implementation

{ TStringStack }

function TStringStack.Count: integer;
begin
  Result := FStack.Count;
end;

constructor TStringStack.Create;
begin
  FStack := TStack<string>.Create;
end;

destructor TStringStack.Destroy;
begin
  FStack.Free;

  inherited;
end;

function TStringStack.IsEmpty: boolean;
begin
  Result := FStack.Count = 0;
end;

function TStringStack.Peek: string;
begin
  Result := FStack.Peek;
end;

function TStringStack.Pop: string;
begin
  Result := FStack.Pop;
end;

procedure TStringStack.Push(const AValue: string);
begin
  FStack.Push(AValue);
end;

end.
