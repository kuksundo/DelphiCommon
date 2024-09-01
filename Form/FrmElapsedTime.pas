unit FrmElapsedTime;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  iComponent, iVCLComponent, iCustomComponent, iSevenSegmentDisplay,
  iSevenSegmentClock, QProgress;

type
  TElapsedTimeF = class(TForm)
    iSevenSegmentClock1: TiSevenSegmentClock;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure StartWatch();
    procedure UpdateWatch();
  end;

  procedure ShowElapsedTimeForm();
  procedure ShowModalElapsedTimeForm();

var
  ElapsedTimeF: TElapsedTimeF;

implementation

{$R *.dfm}

procedure ShowElapsedTimeForm();
begin
  if not Assigned(ElapsedTimeF) then
    ElapsedTimeF := TElapsedTimeF.Create(nil);

  with ElapsedTimeF do
  begin
    iSevenSegmentClock1.CountTimerEnabled := True;
    Show();
  end;
end;

procedure ShowModalElapsedTimeForm();
begin
  with TElapsedTimeF.Create(nil) do
  begin
    try
      iSevenSegmentClock1.CountTimerEnabled := True;
      ShowModal();
    finally
      Free;
    end;
  end;
end;

{ TElapsedTimeF }

procedure TElapsedTimeF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  QProgress1.Active := False;
//  QProgress1.SetStopEvent;
end;

procedure TElapsedTimeF.FormCreate(Sender: TObject);
begin
//  QProgress1.Active := True;
end;

procedure TElapsedTimeF.StartWatch;
begin
//  iSevenSegmentClock1.
end;

procedure TElapsedTimeF.UpdateWatch;
begin

end;

end.
