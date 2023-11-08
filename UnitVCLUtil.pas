unit UnitVCLUtil;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg;

//콘트롤을 비트맵에 그리는 프로시져
procedure DrawControl2Bitmap(AControl: TWinControl; AAlpha: Byte; ABitmap: TBitmap);
procedure MakeAlphaOnRect2Bitmap(ABitmap: TBitmap; ARect: TRect; AAlpha: Byte);
procedure MakeAlphaOnRect2Canvas(ACanvas: TCanvas; ARect: TRect; AAlpha: Byte);
procedure CopyParentImage2Canvas(AControl: TControl; ADest: TCanvas);
procedure CopyControlImage2Canvas(AControl: TControl; ADest: TCanvas);
procedure SetAlpha2Bitmap(ABitmap: TBitmap);
procedure ReSetAlpha2Bitmap(ABitmap: TBitmap);

implementation

type
  PPixels = ^TPixels;
  TPixels = array[0..0] of TRGBQuad;

procedure MakeAlphaOnRect2Bitmap(ABitmap: TBitmap; ARect: TRect; AAlpha: Byte);
var
  Pixels: PPixels;
  Col, Row: Integer;
begin
  if ARect.Bottom > ABitmap.Height then
    ARect.Bottom := ABitmap.Height;

  if ARect.Right > ABitmap.Width then
    ARect.Right := ABitmap.Width;

  SetAlpha2Bitmap(ABitmap);

  for Row := ARect.Top to ARect.Bottom - 1 do
  begin
    Pixels := ABitmap.ScanLine[ Row ];

    for Col := ARect.Left to ARect.Right - 1 do
    begin
      if AAlpha = 255 then
        Pixels[ Col ].rgbReserved := AAlpha
      else
      begin
        //혹은, 이 영역을 반투명하게 하려면 (예컨대 Alpha 값을 128로)
        Pixels[ Col ].rgbRed := ( Pixels[ Col ].rgbRed * AAlpha div $FF ) and $FF;
        Pixels[ Col ].rgbGreen := ( Pixels[ Col ].rgbGreen * AAlpha div $FF ) and $FF;
        Pixels[ Col ].rgbBlue := ( Pixels[ Col ].rgbBlue * AAlpha div $FF ) and $FF;
        Pixels[ Col ].rgbReserved := AAlpha;
      end;
    end;
  end;
end;

procedure MakeAlphaOnRect2Canvas(ACanvas: TCanvas; ARect: TRect; AAlpha: Byte);
var
  Pixels: TRGBQuad;
  Col, Row: Integer;
begin
  for Row := ARect.Top to ARect.Bottom - 1 do
  begin
    for Col := ARect.Left to ARect.Right - 1 do
    begin
      Pixels := TRGBQuad(ACanvas.Pixels[Col, Row]);

      if AAlpha = 255 then
        Pixels.rgbReserved := AAlpha
      else
      begin
        //혹은, 이 영역을 반투명하게 하려면 (예컨대 Alpha 값을 128로)
        Pixels.rgbRed := ( Pixels.rgbRed * AAlpha div $FF ) and $FF;
        Pixels.rgbGreen := ( Pixels.rgbGreen * AAlpha div $FF ) and $FF;
        Pixels.rgbBlue := ( Pixels.rgbBlue * AAlpha div $FF ) and $FF;
        Pixels.rgbReserved := AAlpha;
      end;
    end;
  end;
end;

procedure DrawControl2Bitmap(AControl: TWinControl; AAlpha: Byte; ABitmap: TBitmap);
var
  Rect: TRect;
begin
  //콘트롤을 비트맵에 그린다
  AControl.PaintTo( ABitmap.Canvas, AControl.Left, AControl.Top );

  Rect := AControl.BoundsRect;

  //콘트롤 영역의 Bitmap 영역 투명도를 Alpha로 세팅한다
  MakeAlphaOnRect2Bitmap(ABitmap, Rect, AAlpha);
end;

type
  TAccessWinControl = class(TWinControl);

procedure CopyParentImage2Canvas(AControl: TControl; ADest: TCanvas);
var
  I, Count, SaveIndex: Integer;
  DC: HDC;
  R, SelfR, CtlR: TRect;
  ViewPortOrg: TPoint;
begin
  if (AControl = nil) or (AControl.Parent = nil) then
    Exit;
  Count := AControl.Parent.ControlCount;
  DC := ADest.Handle;
  AControl.Parent.ControlState := AControl.Parent.ControlState + [csPaintCopy];
  try
    // The view port may already be set. This is especially true when
    // a control using CopyParentImage is placed inside a control that
    // calls it as well. Best example is a TJvSpeeButton in a TJvPanel,
    // both with Transparent set to True (discovered while working on
    // Mantis 3624)
    GetViewPortOrgEx(DC, ViewPortOrg);

    SelfR := Bounds(AControl.Left, AControl.Top, AControl.Width, AControl.Height);

    ViewPortOrg.X := ViewPortOrg.X-AControl.Left;
    ViewPortOrg.Y := ViewPortOrg.Y-AControl.Top;

    // Copy parent control image
    SaveIndex := SaveDC(DC);
    try
      SetViewPortOrgEx(DC, ViewPortOrg.X, ViewPortOrg.Y, nil);
      IntersectClipRect(DC, 0, 0, AControl.Parent.ClientWidth,
        AControl.Parent.ClientHeight);
      TAccessWinControl(AControl.Parent).Perform(WM_ERASEBKGND, WPARAM(DC), 0);
      TAccessWinControl(AControl.Parent).PaintWindow(DC);
    finally
      RestoreDC(DC, SaveIndex);
    end;

    // Copy images of control's siblings
    // Note: while working on Mantis 3624 it was decided that there was no
    // real reason to limit this to controls derived from TGraphicControl.
    for I := 0 to Count - 1 do
    begin
      if AControl.Parent.Controls[I] = AControl then
        Break
      else
      if (AControl.Parent.Controls[I] <> nil) then
      begin
        with AControl.Parent.Controls[I] do
        begin
          CtlR := Bounds(Left, Top, Width, Height);

          if IntersectRect(R, SelfR, CtlR) and Visible then
          begin
            ControlState := ControlState + [csPaintCopy];
            SaveIndex := SaveDC(DC);
            try
              SetViewPortOrgEx(DC, Left + ViewPortOrg.X, Top + ViewPortOrg.Y, nil);
              IntersectClipRect(DC, 0, 0, Width, Height);
              Perform(WM_PAINT, DC, 0);
            finally
              RestoreDC(DC, SaveIndex);
              ControlState := ControlState - [csPaintCopy];
            end;
          end;
        end;
      end;
    end;
  finally
    AControl.Parent.ControlState := AControl.Parent.ControlState - [csPaintCopy];
  end;
end;

procedure CopyControlImage2Canvas(AControl: TControl; ADest: TCanvas);
begin

end;

procedure SetAlpha2Bitmap(ABitmap: TBitmap);
begin
  ABitmap.AlphaFormat := afDefined;
  ABitmap.PixelFormat := pf32bit;
//  ABitmap.HandleType :=  bmDIB;
end;

procedure ReSetAlpha2Bitmap(ABitmap: TBitmap);
begin
  ABitmap.AlphaFormat := afIgnored;
end;

end.
