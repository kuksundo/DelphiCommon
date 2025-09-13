unit UnitRectHelper;

interface

uses Types;

type
  TRectHelper = record helper for TRect
  private
    function GetTopRight: TPoint;
    procedure SetTopRight(const Value: TPoint);
    function GetBottomLeft: TPoint;
    procedure SetBottomLeft(const Value: TPoint);
  public
    class function GetRect(const Left, Top, Right, Bottom: Integer): TRect; static;
    property TopRight: TPoint read GetTopRight write SetTopRight;
    property BottomLeft: TPoint read GetBottomLeft write SetBottomLeft;
  end;

implementation

{ TRectHelper }

class function TRectHelper.GetRect(const Left, Top, Right,
  Bottom: Integer): TRect;
begin
  Result.Left  := Left;
  Result.Top   := Top;
  Result.Right := Right;
  Result.Bottom:= Bottom;
end;

function TRectHelper.GetTopRight: TPoint;
begin
  Result := Point(Right, Top);
end;

procedure TRectHelper.SetTopRight(const Value: TPoint);
begin
  Right := Value.X;
  Top := Value.Y;
end;

function TRectHelper.GetBottomLeft: TPoint;
begin
  Result := Point(Left, Bottom);
end;

procedure TRectHelper.SetBottomLeft(const Value: TPoint);
begin
  Left := Value.X;
  Bottom := Value.Y;
end;

end.
