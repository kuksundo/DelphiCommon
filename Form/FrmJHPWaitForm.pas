unit FrmJHPWaitForm;
{
  EventWaitShow('Creating report: ' + DataMod3.pCurrentOrder, false); //1st
  try
    CreateReport;
    EventWaitShow('Loading orders, false); //2nd
    LoadOrders;
  finally
    EventWaitHide;  //kill 2nd
  end;
  EventWaitHide;  //kill 1st
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  JvExControls, JvAnimatedImage, JvGIFCtrl;

type
  TWaitForm = class(TForm)
    WaitPanel: TPanel;
    JvGIFAnimator1: TJvGIFAnimator;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WaitPanelClick(Sender: TObject);
  private
    { Private declarations }
    MsgList: TStringList;
  public
    procedure StartAnimate;
    procedure StopAnimate;
  end;

procedure EventLogger(const amessage: string);
function EventDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
procedure EventWaitShow(const amessage: string; Log: boolean);
procedure EventWaitHide;
procedure EventWaitHideAll;
procedure EventWaitShowOnly;
procedure EventWaitHideOnly;

implementation

{$R *.DFM}

var
  WaitForm: TWaitForm;

//------------------------------ eventlog ----------------------------------------//

procedure EventLogger(const amessage: string);
var
  Header: string;
  s: string;
begin
  s:= amessage;
  Header:= FormatDateTime('MM/DD/YY HH:NN:SS ', Now);
  s:= StringReplace(s, #13, #32, [rfReplaceAll]);
  //WriteToLogFile(s)
end;

function EventDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
begin
  EventLogger(Msg);
  EventWaitHideOnly;
  result:= MessageDlg(Msg, DlgType, Buttons, HelpCtx);
  EventWaitShowOnly;
end;

//----------------------------- TWaitForm ------------------------------------/

procedure TWaitForm.FormCreate(Sender: TObject);
begin
  MsgList:= TStringList.Create;
  FormStyle:= fsStayOnTop;
end;

procedure TWaitForm.FormDestroy(Sender: TObject);
begin
  MsgList.Free
end;

procedure TWaitForm.StartAnimate;
begin
  JvGIFAnimator1.Animate := True;
end;

procedure TWaitForm.StopAnimate;
begin
  JvGIFAnimator1.Animate := False;
end;

//------------------------------ event wait ----------------------------------------//

procedure EventWaitShowOnly;
begin
  if WaitForm <>nil then WaitForm.Show;
end;

procedure EventWaitHideOnly;
begin
  if WaitForm <>nil then WaitForm.Hide;
end;

procedure EventWaitShow(const amessage: string; Log: boolean);
begin
  WaitForm:= TWaitForm.Create(nil); // else WaitForm.Hide;

  with WaitForm do
  begin
    StartAnimate();
    MsgList.Add(aMessage);
    WaitPanel.Caption:= aMessage + 'please wait...';
    WaitPanel.Refresh;
    Show;
    Update;
  end;

  if Log then
    EventLogger(amessage)
end; //EventWaitShow

procedure EventWaitHide;
begin
  if WaitForm <> nil then
    with WaitForm do begin
      StopAnimate();
      if MsgList.Count <> 0 then
        MsgList.Delete(MsgList.Count -1);
      if MsgList.Count <> 0 then begin
        WaitPanel.Caption:= MsgList.Strings[MsgList.Count -1] + ', please wait...';
        WaitPanel.Refresh;
      end else
        FreeAndNil(WaitForm)
    end
end;

procedure EventWaitHideAll;
begin
  repeat EventWaitHide until WaitForm = nil
end;

procedure TWaitForm.WaitPanelClick(Sender: TObject);
begin
  Hide;
  Sleep(1000);
  Show
end;

end.