unit UnitControlMoveResize;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Winapi.Messages,
  Vcl.Controls, Vcl.Graphics, Vcl.Forms;

type
  TResizeDirection = (rdNone, rdLeft, rdRight, rdTop, rdBottom, rdTopLeft, rdTopRight, rdBottomLeft, rdBottomRight);

  TControlMoverResizer = class
  private
    FControl: TWinControl;
    FOldWindowProc: TWndMethod;
    FDragging, FResizing: Boolean;
    FResizeDir: TResizeDirection;
    FOffset: TPoint;

    procedure NewWindowProc(var Message: TMessage);
    procedure SetCursorForEdge(X, Y: Integer);
    function GetResizeDirection(X,Y: integer): TResizeDirection;

    procedure SetControlComponent(AControl: TWinControl);
  public
    constructor Create(AControl: TWinControl);
    destructor Destroy; override;

    property ControlComponent: TWinControl read FControl write SetControlComponent;
  end;

implementation

{ TControlMoverResizer }

constructor TControlMoverResizer.Create(AControl: TWinControl);
begin
  ControlComponent := AControl;
end;

destructor TControlMoverResizer.Destroy;
begin
  if Assigned(FControl) then
    FControl.WindowProc := FOldWindowProc;

  inherited;
end;

function TControlMoverResizer.GetResizeDirection(X,
  Y: integer): TResizeDirection;
begin
  Result := rdNone;

  if (X < 10) and (Y < 10) then
    Result := rdTopLeft
  else if (X > FControl.ClientWidth - 10) and (Y < 10) then
    Result := rdTopRight
  else if (X < 10) and (Y > FControl.ClientHeight - 10) then
    Result := rdBottomLeft
  else if (X > FControl.ClientWidth - 10) and (Y > FControl.ClientWidth - 10) then
    Result := rdBottomRight
  else if (X < 10) then
    Result := rdLeft
  else if (X > FControl.ClientWidth - 10) then
    Result := rdRight
  else if (Y < 10) then
    Result := rdTop
  else if (Y > FControl.ClientHeight - 10) then
    Result := rdBottom;
end;

procedure TControlMoverResizer.NewWindowProc(var Message: TMessage);
var
  X, Y: Integer;
  Pt: TPoint;
begin
  case Message.Msg of
    WM_LBUTTONDOWN:
      begin
        X := LOWORD(Message.LParam);
        Y := HIWORD(Message.LParam);
        FResizeDir := GetResizeDirection(X,Y);

        if FResizeDir <> rdNone then
          FResizing := True
        else
        begin
          FDragging := True;
          FOffset := Point(X, Y);
        end;
        SetCapture(FControl.Handle);
      end;

    WM_MOUSEMOVE:
      begin
        X := LOWORD(Message.LParam);
        Y := HIWORD(Message.LParam);

        if FDragging then
        begin
          Pt := FControl.ClientToScreen(Point(X, Y));
          Pt := FControl.Parent.ScreenToClient(Pt);
          FControl.Left := Pt.X - FOffset.X;
          FControl.Top := Pt.Y - FOffset.Y;
        end
        else if FResizing then
        begin
          case FResizeDir of
            rdLeft: begin
                FControl.Width := FControl.Width - X;
                FControl.Left := FControl.Left + X;
              end;
            rdRight: begin
                FControl.Width := X;
              end;
            rdTop: begin
                FControl.Height := FControl.Height - Y;
                FControl.Top := FControl.Top + Y;
              end;
            rdBottom: begin
                FControl.Height := Y;
              end;
            rdTopLeft: begin
                FControl.Width := FControl.Width - X;
                FControl.Left := FControl.Left + X;
                FControl.Height := FControl.Height - Y;
                FControl.Top := FControl.Top + Y;
              end;
            rdTopRight: begin
                FControl.Width := X;
                FControl.Height := FControl.Height - Y;
                FControl.Top := FControl.Top + Y;
              end;
            rdBottomLeft: begin
                FControl.Width := FControl.Width - X;
                FControl.Left := FControl.Left + X;
                FControl.Height := Y;
              end;
            rdBottomRight: begin
                FControl.Width := X;
                FControl.Height := Y;
              end;
            else
              SetCursorForEdge(X, Y);
          end;

          FControl.Width := X;
          FControl.Height := Y;
        end
        else
          SetCursorForEdge(X, Y);
      end;

    WM_LBUTTONUP:
      begin
        FDragging := False;
        FResizing := False;
        FResizeDir := rdNone;

        ReleaseCapture;
      end;
  end;
  FOldWindowProc(Message);
end;

procedure TControlMoverResizer.SetControlComponent(AControl: TWinControl);
begin
  if Assigned(FControl) then
    FControl.WindowProc := FOldWindowProc;

  FControl := AControl;
  FOldWindowProc := AControl.WindowProc;
  AControl.WindowProc := NewWindowProc;
end;

procedure TControlMoverResizer.SetCursorForEdge(X, Y: Integer);
begin
  case GetResizeDirection(X, Y) of
    rdTopLeft, rdBottomRight: FControl.Cursor := crSizeNWSE;
    rdTopRight, rdBottomLeft: FControl.Cursor := crSizeNESW;
    rdLeft, rdRight: FControl.Cursor := crSizeWE;
    rdTop, rdBottom: FControl.Cursor := crSizeNS;
    else
      FControl.Cursor := crDefault;
  end;
end;

end.

