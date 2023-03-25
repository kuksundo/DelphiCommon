unit UnitFramePdfView2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxEdit6, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.ExtCtrls, UnitCopyData, PdfiumCtrl, PdfiumCore,
  mormot.core.variants, mormot.core.unicode;

type
  TPdfViewFrame = class(TFrame)
    Panel1: TPanel;
    btnPrev: TButton;
    btnNext: TButton;
    btnCopy: TButton;
    btnScale: TButton;
    chkLCDOptimize: TCheckBox;
    chkSmoothScroll: TCheckBox;
    edtZoom: TSpinEdit;
    btnPrint: TButton;
    FindEdit: TNxButtonEdit6;
    PrintDialog1: TPrintDialog;
    OpenDialog1: TOpenDialog;
    procedure FindEditButtonClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnScaleClick(Sender: TObject);
    procedure chkLCDOptimizeClick(Sender: TObject);
    procedure chkSmoothScrollClick(Sender: TObject);
    procedure edtZoomChange(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    FPdfFileName: string;
    FParentFormHandle: THandle;

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WebLinkClick(Sender: TObject; Url: string);
  public
    FCtrl: TPdfControl;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitPDF(AParentHandle: THandle);
    procedure SetArguments(const AJson: string);
    procedure LoadPDFInfoFromObj(AObj: variant);
    procedure LoadPDF2Form(const AFileName, ACaption: string);
  end;

implementation

uses
  System.TypInfo, Vcl.Printers;

{$R *.dfm}

{ TPdfViewFrame }

procedure TPdfViewFrame.btnCopyClick(Sender: TObject);
begin
//  FCtrl.HightlightText('Delphi 2010', False, False);
  FCtrl.LoadFromFile('E:\pjh\project\util\HiMECS\Application\Bin\Doc\Manual\H35DF\8H35DF Sensor List.pdf');
end;

procedure TPdfViewFrame.btnNextClick(Sender: TObject);
begin
  FCtrl.GotoNextPage;
end;

procedure TPdfViewFrame.btnPrevClick(Sender: TObject);
begin
  FCtrl.GotoPrevPage;
end;

procedure TPdfViewFrame.btnPrintClick(Sender: TObject);
begin
//  FCtrl.PageIndex := 1;
  if PrintDialog1.Execute(Handle) then
  begin
    Printer.BeginDoc;
    try
      FCtrl.CurrentPage.Draw(Printer.Canvas.Handle, 0, 0, Printer.PageWidth, Printer.PageHeight, prNormal, [proAnnotations, proPrinting]);
    finally
      Printer.EndDoc;
    end;
  end;
end;

procedure TPdfViewFrame.btnScaleClick(Sender: TObject);
begin
  if FCtrl.ScaleMode = High(FCtrl.ScaleMode) then
    FCtrl.ScaleMode := Low(FCtrl.ScaleMode)
  else
    FCtrl.ScaleMode := Succ(FCtrl.ScaleMode);

  Caption := System.TypInfo.GetEnumName(TypeInfo(TPdfControlScaleMode), Ord(FCtrl.ScaleMode));
end;

procedure TPdfViewFrame.chkLCDOptimizeClick(Sender: TObject);
begin
  if chkLCDOptimize.Checked then
    FCtrl.DrawOptions := FCtrl.DrawOptions + [proLCDOptimized]
  else
    FCtrl.DrawOptions := FCtrl.DrawOptions - [proLCDOptimized];
end;

procedure TPdfViewFrame.chkSmoothScrollClick(Sender: TObject);
begin
  FCtrl.SmoothScroll := chkSmoothScroll.Checked;
end;

constructor TPdfViewFrame.Create(AOwner: TComponent);
begin
//  {$IFDEF CPUX64}
//  PDFiumDllDir := ExtractFilePath(ParamStr(0)) + 'x64';
//  {$ELSE}
//  PDFiumDllDir := ExtractFilePath(ParamStr(0));// + 'x86';
//  {$ENDIF CPUX64}

  FCtrl := TPdfControl.Create(Self);
  FCtrl.Align := alClient;
//  FCtrl.Parent := Self; //TWinControl(AOwner);
  FCtrl.SendToBack; // put the control behind the buttons
  FCtrl.Color := clGray;
  FCtrl.ScaleMode := smFitWidth;
//  FCtrl.PageColor := RGB(255, 255, 200);
  FCtrl.OnWebLinkClick := WebLinkClick;

//  edtZoom.Value := FCtrl.ZoomPercentage;

//  if OpenDialog1.Execute(Handle) then
//    FCtrl.LoadFromFile(OpenDialog1.FileName)
//  else
//  begin
//    Application.ShowMainForm := False;
//    Application.Terminate;
//  end;

  inherited;

end;

destructor TPdfViewFrame.Destroy;
begin
  FCtrl.Free;

  inherited;
end;

procedure TPdfViewFrame.edtZoomChange(Sender: TObject);
begin
  FCtrl.ZoomPercentage := edtZoom.Value;
end;

procedure TPdfViewFrame.FindEditButtonClick(Sender: TObject);
begin
  FCtrl.HightlightText(FindEdit.Text, False, False);
end;

procedure TPdfViewFrame.InitPDF(AParentHandle: THandle);
begin
//  FCtrl := TPdfControl.Create(Self);
//  FCtrl.Align := alClient;
//  FCtrl.Parent := TWinControl(AOwner);
//  FCtrl.SendToBack; // put the control behind the buttons
//  FCtrl.Color := clGray;
//  FCtrl.ScaleMode := smFitWidth;
////  FCtrl.PageColor := RGB(255, 255, 200);
//  FCtrl.OnWebLinkClick := WebLinkClick;
end;

procedure TPdfViewFrame.LoadPDF2Form(const AFileName, ACaption: string);
begin
  if FileExists(AFileName) then
  begin
    FCtrl.Parent := Self;
    FCtrl.LoadFromFile(AFileName);
    Caption := ACaption;
  end
  else
    ShowMessage(AFileName + ' file is not exist.');
end;

procedure TPdfViewFrame.LoadPDFInfoFromObj(AObj: variant);
var
  LFileName: string;
begin
  LFileName := ChangeFileExt(AObj.FileName, '.pdf');
  LoadPDF2Form(LFileName, AObj.SystemDesc_Eng);
end;

procedure TPdfViewFrame.SetArguments(const AJson: string);
var
  i: integer;
  LObj: Variant;
//  LUtf8: RawUTF8;
begin
  LObj := VariantLoadJSON(StringToUTF8(AJson));
  FPdfFileName := LObj[0];
end;

procedure TPdfViewFrame.WebLinkClick(Sender: TObject; Url: string);
begin
  ShowMessage(Url);
end;

procedure TPdfViewFrame.WMCopyData(var Msg: TMessage);
var
  LStr: string;
  LObj: variant;
begin
  case Msg.WParam of
    WParam_DISPLAYMSG: begin
      LStr := PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg;
      TDocVariant.New(LObj);
      LObj := _JSON(StringToUTF8(LStr));

      LoadPDFInfoFromObj(LObj);
    end;
  end;
end;

end.
