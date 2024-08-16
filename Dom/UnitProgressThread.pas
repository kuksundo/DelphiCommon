unit UnitProgressThread;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TProgressProc = procedure (aProgress: Integer) of object; // 0 to 100

  TProgressThread = class(TThread)
  private
    FProgressProc: TProgressProc;
    FProgressValue: integer;
    procedure SynchedProgress;
  protected
    procedure Progress(aProgress: integer); virtual;
  public
    constructor Create(aProgressProc: TProgressProc; CreateSuspended: Boolean = False); reintroduce; virtual;
  end;

//  TMyThread = class(TProgressThread)
//  protected
//    procedure Execute; override;
//  end;
//
//  TForm1 = class(TForm)
//    btnStart: TButton;
//    ProgressBar1: TProgressBar;
//    procedure btnStartClick(Sender: TObject);
//  private
//    fMyThread: TMyThread;
//    procedure UpdateProgressBar(aProgress: Integer);
//  end;

implementation

{$R *.dfm}

{ TProgressThread }
constructor TProgressThread.Create(aProgressProc: TProgressProc; CreateSuspended: Boolean = False);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := True;
  FProgressProc := aProgressProc;
end;

procedure TProgressThread.Progress(aProgress: Integer);
begin
  FProgressValue := aProgress;
  Synchronize(SynchedProgress);
end;

procedure TProgressThread.SynchedProgress;
begin
  if Assigned(FProgressProc) then
    FProgressProc(FProgressValue);
end;

//{ TMyThread }
//procedure TMyThread.Execute;
//var I: Integer;
//begin
//  Progress(0);
//  for I := 1 to 100 do
//  begin
//    Sleep(1000);
//    Progress(I);
//  end;
//end;
//
//{ TForm1 }
//procedure TForm1.UpdateProgressBar(aProgress: Integer);
//begin
//  ProgressBar1.Position := aProgress;
//  ProgressBar1.Update; // Make sure to repaint the progressbar
//  if aProgress >= 100 then
//    fMyThread := nil;
//end;
//
//procedure TForm1.btnStartClick(Sender: TObject);
//begin
//  if not Assigned(fMyThread) then
//    fMyThread := TMyThread.Create(UpdateProgressBar);
//end;

end.
