unit UnitPdfiumUtil;

interface

uses System.Classes, System.Types, SysUtils, Vcl.Controls, Vcl.Graphics,
  PdfiumCtrl, PdfiumCore;

const
  DEFAULT_PDFIUM_DLL_DIR = 'E:\pjh\Dev\Lang\Delphi\Project\HiMECS2\Bin\Dlls';

function InitPDFCtrl(APdfDllDir: string=''; AOwner: TComponent=nil): TPdfControl;
//ANthIndex : 0 = 첫번째로 찾은 Text 반환
//AReadCharCount : 10 = 검색한 문자열에서 10문자를 ASearchText에 반환함
function FindTextFromPdfFile(const APdfFileName: string; var ASearchText: string;
  AReadCharCount: integer=-1; ANthIndex: integer=0): TRect;
//ANthIndex : 0 = 첫번째로 찾은 Text 반환
function FindTextFromPdfCtrl(const APdfCtrl: TPdfControl; var ASearchText: string;
  AReadCharCount: integer=-1; ANthIndex: integer=0): TRect;
procedure SavePDFFileFromPageRange(const APdfCtrl: TPdfControl; ASavePdfFileName: string; ABeginPage, AEndPage: integer);

implementation

function InitPDFCtrl(APdfDllDir: string; AOwner: TComponent): TPdfControl;
begin
  if APdfDllDir = '' then
    APdfDllDir := DEFAULT_PDFIUM_DLL_DIR;

  PDFiumDllDir := APdfDllDir;

  Result := TPdfControl.Create(AOwner);
  Result.Align := alClient;
  Result.Parent := TWinControl(AOwner);
  Result.SendToBack; // put the control behind the buttons
  Result.Color := clGray;
  Result.ScaleMode := smFitWidth;
//  Result.PageColor := RGB(255, 255, 200);
//  Result.OnWebLinkClick := WebLinkClick;
end;

function FindTextFromPdfFile(const APdfFileName: string; var ASearchText: string;
  AReadCharCount: integer; ANthIndex: integer): TRect;
var
  LPdfCtrl: TPdfControl;
begin
  LPdfCtrl := InitPDFCtrl();
  try
    LPdfCtrl.LoadFromFile(APdfFileName);
    Result := FindTextFromPdfCtrl(LPdfCtrl, ASearchText, AReadCharCount, ANthIndex);
  finally
    LPdfCtrl.Free;
  end;
end;

function FindTextFromPdfCtrl(const APdfCtrl: TPdfControl; var ASearchText: string;
  AReadCharCount: integer; ANthIndex: integer): TRect;
var
  LPdfPage: TPdfPage;
  LPdfRect: TPdfRect;
  LCharIndex, LCharCount, LRectCount: integer;
begin
  Result := TRect.Empty;

  APdfCtrl.PageIndex := 0;

  LPdfPage := APdfCtrl.CurrentPage;

  if LPdfPage.BeginFind(ASearchText, False, False, False) then
  begin
    try
      if LPdfPage.FindNext(LCharIndex, LCharCount) then
      begin
        //PDF 페이지에서 찾은 갯수를 가져옴
        LRectCount := LPdfPage.GetTextRectCount(LCharIndex, LCharCount);
        //PDF 페이지에서 찾은 N번째 검색한 Rect를 가져옴
        LPdfRect := LPdfPage.GetTextRect(ANthIndex);
        //위에서 가져온 Rect를 TRect(화면좌표))로 변환함
        Result := APdfCtrl.PageToDevice(LPdfRect);
        ASearchText := LPdfPage.ReadText(LCharIndex, AReadCharCount);
      end
      else
        ASearchText := '';
    finally
      LPdfPage.EndFind;
    end;
  end;
end;

procedure SavePDFFileFromPageRange(const APdfCtrl: TPdfControl;
  ASavePdfFileName: string; ABeginPage, AEndPage: integer);
var
  LPdfDocument: TPdfDocument;
begin
  LPdfDocument := TPdfDocument.Create;
  try
    if ABeginPage > 0  then
    begin
      if AEndPage = 0 then
        AEndPage := ABeginPage;

      LPdfDocument.NewDocument;
      LPdfDocument.ImportPages(APdfCtrl.Document, IntToStr(ABeginPage) + '-' + IntToStr(AEndPage));
      LPdfDocument.SaveToFile(ASavePdfFileName);
    end;
  finally
    LPdfDocument.Free;
  end;
end;

end.
