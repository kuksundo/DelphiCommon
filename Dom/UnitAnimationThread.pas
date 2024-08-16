unit UnitAnimationThread;

interface

uses
  Classes, Windows, Controls, Graphics;

type
  TAnimationThread = class(TThread)
  private
    { Private declarations }
    FWnd: HWND;
    FPaintRect: TRect;
    FbkColor, FfgColor: TColor;
    FInterval: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(paintsurface : TWinControl; {Control to paint on }
      paintrect : TRect;          {area for animation bar }
      bkColor, barcolor : TColor; {colors to use }
      interval : integer);       {wait in msecs between paints}
  end;

implementation

constructor TAnimationThread.Create(paintsurface : TWinControl;
  paintrect : TRect; bkColor, barcolor : TColor; interval : integer);
begin
  inherited Create(True);
  FWnd := paintsurface.Handle;
  FPaintRect := paintrect;
  FbkColor := bkColor;
  FfgColor := barColor;
  FInterval := interval;
  FreeOnterminate := True;
  Resume;
end; { TAnimationThread.Create }

procedure TAnimationThread.Execute;
var
  image : TBitmap;
  DC : HDC;
  left, right : integer;
  increment : integer;
  imagerect : TRect;
  state : (incRight, incLeft, decLeft, decRight);
begin
  Image := TBitmap.Create;
  try
    with Image do
    begin
      Width := FPaintRect.Right - FPaintRect.Left;
      Height := FPaintRect.Bottom - FPaintRect.Top;
      imagerect := Rect(0, 0, Width, Height);
    end; { with }
    left := 0;
    right := 0;
    increment := imagerect.right div 50;
    state := Low(State);
    while not Terminated do
    begin
      with Image.Canvas do
      begin
        Brush.Color := FbkColor;
        FillRect(imagerect);
        case state of
          incRight:
          begin
            Inc(right, increment);
            if right > imagerect.right then
            begin
              right := imagerect.right;
              Inc(state);
            end; { if }
          end; { Case incRight }
          incLeft:
          begin
            Inc(left, increment);
            if left >= right then
            begin
              left := right;
              Inc(state);
            end; { if }
          end; { Case incLeft }
          decLeft:
          begin
            Dec(left, increment);
            if left <= 0 then
            begin
              left := 0;
              Inc(state);
            end; { if }
          end; { Case decLeft }
          decRight:
          begin
            Dec(right, increment);
            if right <= 0 then
            begin
              right := 0;
              state := incRight;
            end; { if }
          end; { Case decLeft }
        end; { Case }
        Brush.Color := FfgColor;
        FillRect(Rect(left, imagerect.top, right, imagerect.bottom));
      end; { with }
      DC := GetDC(FWnd);
      if DC <> 0 then
        try
          BitBlt(DC,
            FPaintRect.Left,
            FPaintRect.Top,
            imagerect.right,
            imagerect.bottom,
            Image.Canvas.handle,
            0, 0,
            SRCCOPY);
        finally
          ReleaseDC(FWnd, DC);
        end;
      Sleep(FInterval);
    end; { While }
  finally
    Image.Free;
  end;
  InvalidateRect(FWnd, nil, True);
end; { TAnimationThread.Execute }

end.

{Usage:
 Place a TPanel on a form, size it as appropriate.Create an instance of the
 TanimationThread call like this: procedure TForm1.Button1Click(Sender : TObject);
}
//var
//  ani : TAnimationThread;
//  r : TRect;
//  begin
//  r := panel1.clientrect;
//  InflateRect(r, - panel1.bevelwidth, - panel1.bevelwidth);
//  ani := TanimationThread.Create(panel1, r, panel1.color, clBlue, 25);
//  Button1.Enabled := False;
//  Application.ProcessMessages;
//  Sleep(30000);  // replace with query.Open or such
//  Button1.Enabled := True;
//  ani.Terminate;
//  ShowMessage('Done');
//end;
