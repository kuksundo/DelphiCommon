unit UnitSynPDFUtil;

interface

uses
  Windows, Winapi.WinSpool, Vcl.Forms, Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls,
  Vcl.StdCtrls, System.Classes, SysUtils, Math, Grids,
  SynPDF;

const
  PW_RENDERFULLCONTENT = $00000002;

function CaptureFormWithPrintWindow(AForm: TForm): TBitmap;
procedure SaveFormToPDF_PrintWindow(AForm: TForm; const AFileName: string);
function TryCaptureFormWithPrintWindow(AForm: TForm): TBitmap;
procedure SaveFormToPDF_AutoFit(AForm: TForm; const AFileName: string);

procedure SaveFormToPDF(AForm: TForm; const FileName: string);

implementation

function CaptureFormWithPrintWindow(AForm: TForm): TBitmap;
var
  hDC: UINT_PTR;
  R: TRect;
begin
  Result := TBitmap.Create;
  try
    // 폼 전체 크기 구하기
    GetWindowRect(AForm.Handle, R);
    Result.Width := R.Right - R.Left;
    Result.Height := R.Bottom - R.Top;
    Result.PixelFormat := pf24bit;

    // DC 생성
    hDC := Result.Canvas.Handle;

    // PrintWindow으로 폼 전체 렌더링 (비가시 영역 포함)
    if not PrintWindow(AForm.Handle, hDC, PW_RENDERFULLCONTENT) then
      raise Exception.Create('PrintWindow failed.');

  except
    Result.Free;
    raise;
  end;
end;

procedure SaveFormToPDF_PrintWindow(AForm: TForm; const AFileName: string);
var
  bmp: TBitmap;
  pdf: TPdfDocumentGDI;
begin
  bmp := CaptureFormWithPrintWindow(AForm);
  pdf := TPdfDocumentGDI.Create;
  try
    // PDF 페이지 크기를 비트맵 크기에 맞춤
    pdf.DefaultPageWidth := bmp.Width;
    pdf.DefaultPageHeight := bmp.Height;
    pdf.AddPage;

    // PDF에 비트맵 삽입
    pdf.VCLCanvas.StretchDraw(Rect(0, 0, bmp.Width, bmp.Height), bmp);

    // 저장
    pdf.SaveToFile(AFileName);
  finally
    bmp.Free;
    pdf.Free;
  end;
end;

function TryCaptureFormWithPrintWindow(AForm: TForm): TBitmap;
var
  hDC: UINT_PTR;
  R: TRect;
  Flags: UINT;
  ok: BOOL;
begin
  Result := TBitmap.Create;
  try
    GetWindowRect(AForm.Handle, R);
    Result.Width := R.Right - R.Left;
    Result.Height := R.Bottom - R.Top;
    Result.PixelFormat := pf24bit;

    // 폼이 최소화된 경우 복원
    if IsIconic(AForm.Handle) then
      ShowWindow(AForm.Handle, SW_RESTORE);

    // 창을 앞으로
    BringWindowToTop(AForm.Handle);
    Sleep(50); // 안정화 약간의 딜레이

    hDC := Result.Canvas.Handle;

    // Win8 이상이면 전체 콘텐츠 렌더링
    if TOSVersion.Check(6, 2) then
      Flags := PW_RENDERFULLCONTENT
    else
      Flags := 0;

    ok := PrintWindow(AForm.Handle, hDC, Flags);
    if not ok then
    begin
      // PrintWindow 실패 → PaintTo 대체
      Result.Canvas.Lock;
      try
        Result.Canvas.Brush.Color := AForm.Color;
        Result.Canvas.FillRect(Rect(0, 0, Result.Width, Result.Height));
        AForm.PaintTo(Result.Canvas.Handle, 0, 0);
      finally
        Result.Canvas.Unlock;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure SaveFormToPDF_AutoFit(AForm: TForm; const AFileName: string);
const
  A4Portrait: TPoint = (X: 595; Y: 842);
  A4Landscape: TPoint = (X: 842; Y: 595);
var
  bmp: TBitmap;
  pdf: TPdfDocumentGDI;
  PageWidth, PageHeight: Integer;
  Scale: Double;
  DestRect: TRect;
begin
  bmp := TryCaptureFormWithPrintWindow(AForm);
  pdf := TPdfDocumentGDI.Create;
  try
    // 자동 회전 결정
    if bmp.Width > bmp.Height then
    begin
      PageWidth := A4Landscape.X;
      PageHeight := A4Landscape.Y;
    end
    else
    begin
      PageWidth := A4Portrait.X;
      PageHeight := A4Portrait.Y;
    end;

    pdf.DefaultPageWidth := PageWidth;
    pdf.DefaultPageHeight := PageHeight;
    pdf.AddPage;

    // 크기 자동 축소
    Scale := Min(PageWidth / bmp.Width, PageHeight / bmp.Height);
    DestRect.Right := Round(bmp.Width * Scale);
    DestRect.Bottom := Round(bmp.Height * Scale);
    DestRect.Left := (PageWidth - DestRect.Right) div 2;
    DestRect.Top := (PageHeight - DestRect.Bottom) div 2;

    pdf.VCLCanvas.StretchDraw(DestRect, bmp);
    pdf.SaveToFile(AFileName);
  finally
    bmp.Free;
    pdf.Free;
  end;
end;

procedure SaveControlsToPDF(const FileName: string; const Controls: array of TControl);
var
  PDF: TPdfDocumentGDI;
  PageHeight: Integer;
  YPos: Integer;

  procedure CheckNewPage;
  begin
    // 현재 페이지의 높이 가져오기
    PageHeight := PDF.DefaultPageHeight;// - 50; // 하단 여백
    if YPos > PageHeight then
    begin
      PDF.AddPage;
      YPos := 50; // 새 페이지 상단 마진
    end;
  end;

  procedure DrawMemo(Memo: TMemo);
  var
    I: Integer;
    LineHeight: Integer;
  begin
    PDF.VCLCanvas.Font.Assign(Memo.Font);
    LineHeight := PDF.VCLCanvas.TextHeight('A') + 2;
    for I := 0 to Memo.Lines.Count - 1 do
    begin
      CheckNewPage;
      PDF.VCLCanvas.TextOut(50, YPos, Memo.Lines[I]);
      Inc(YPos, LineHeight);
    end;
    Inc(YPos, 20);
  end;

  procedure DrawStringGrid(Grid: TStringGrid);
  var
    Col, Row: Integer;
    CellWidth, CellHeight, X: Integer;
  begin
    CellWidth := 80;
    CellHeight := 20;
    PDF.VCLCanvas.Font.Assign(Grid.Font);

    for Row := 0 to Grid.RowCount - 1 do
    begin
      X := 50;
      CheckNewPage;
      for Col := 0 to Grid.ColCount - 1 do
      begin
        PDF.VCLCanvas.Rectangle(X, YPos, X + CellWidth, YPos + CellHeight);
        PDF.VCLCanvas.TextOut(X + 3, YPos + 3, Grid.Cells[Col, Row]);
        Inc(X, CellWidth);
      end;
      Inc(YPos, CellHeight);
    end;
    Inc(YPos, 20);
  end;

  procedure DrawPanel(Panel: TPanel);
  var
    C: TControl;
    I: Integer;
  begin
    PDF.VCLCanvas.Font.Assign(Panel.Font);
    CheckNewPage;
    PDF.VCLCanvas.TextOut(50, YPos, 'Panel: ' + Panel.Name);
    Inc(YPos, 15);

    for I := 0 to Panel.ControlCount - 1 do
    begin
      C := Panel.Controls[I];
      if C is TLabel then
      begin
        PDF.VCLCanvas.Font.Assign(TLabel(C).Font);
        CheckNewPage;
        PDF.VCLCanvas.TextOut(60, YPos, 'Label: ' + TLabel(C).Caption);
        Inc(YPos, PDF.VCLCanvas.TextHeight('A') + 5);
      end
      else if C is TEdit then
      begin
        PDF.VCLCanvas.Font.Assign(TEdit(C).Font);
        CheckNewPage;
        PDF.VCLCanvas.TextOut(60, YPos, 'Edit: ' + TEdit(C).Text);
        Inc(YPos, PDF.VCLCanvas.TextHeight('A') + 5);
      end
      else if C is TMemo then
        DrawMemo(TMemo(C));
    end;
    Inc(YPos, 20);
  end;

  procedure DrawScrollBox(Box: TScrollBox);
  var
    I: Integer;
    C: TControl;
  begin
    CheckNewPage;
    PDF.VCLCanvas.TextOut(50, YPos, 'ScrollBox: ' + Box.Name);
    Inc(YPos, 20);

    for I := 0 to Box.ControlCount - 1 do
    begin
      C := Box.Controls[I];
      if C is TMemo then
        DrawMemo(TMemo(C))
      else if C is TStringGrid then
        DrawStringGrid(TStringGrid(C))
      else if C is TPanel then
        DrawPanel(TPanel(C))
      else if C is TLabel then
      begin
        CheckNewPage;
        PDF.VCLCanvas.TextOut(60, YPos, 'Label: ' + TLabel(C).Caption);
        Inc(YPos, 15);
      end;
    end;
  end;

var
  Ctrl: TControl;
begin
  PDF := TPdfDocumentGDI.Create;
  try
    PDF.Info.Author := 'Delphi Exporter';
    PDF.Info.Title := 'Form Controls Export';
    PDF.AddPage;
    YPos := 50;
    PDF.VCLCanvas.Font.Name := 'Arial';
    PDF.VCLCanvas.Font.Size := 10;
    PageHeight := PDF.DefaultPageHeight;// - 50;

    for Ctrl in Controls do
    begin
      if Ctrl is TMemo then
        DrawMemo(TMemo(Ctrl))
      else if Ctrl is TStringGrid then
        DrawStringGrid(TStringGrid(Ctrl))
      else if Ctrl is TPanel then
        DrawPanel(TPanel(Ctrl))
      else if Ctrl is TScrollBox then
        DrawScrollBox(TScrollBox(Ctrl));
    end;

    PDF.SaveToFile(FileName);
  finally
    PDF.Free;
  end;
end;

procedure SaveFormToPDF(AForm: TForm; const FileName: string);
var
  Controls: array of TControl;
  I: Integer;
begin
  SetLength(Controls, AForm.ControlCount);
  for I := 0 to AForm.ControlCount - 1 do
    Controls[I] := AForm.Controls[I];

  SaveControlsToPDF(FileName, Controls);
end;

end.
