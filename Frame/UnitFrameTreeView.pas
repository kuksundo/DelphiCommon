unit UnitFrameTreeView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  CheckComboBox, Vcl.ExtCtrls, Vcl.ComCtrls, JvExComCtrls, JvComCtrls,
  JvCheckTreeView, TimerPool;

type
  TTreeViewFrame = class(TFrame)
    EngModbusTV: TJvCheckTreeView;
    Panel1: TPanel;
    SrchTextEdit: TEdit;
    Panel4: TPanel;
    EngModbusFilterCheck: TCheckBox;
    FilterCheckcb: TCheckComboBox;
    FilterClearBtn: TButton;
    procedure EngModbusFilterCheckClick(Sender: TObject);
    procedure FilterCheckcbCloseUp(Sender: TObject);
    procedure FilterClearBtnClick(Sender: TObject);
    procedure SrchTextEditChange(Sender: TObject);
    procedure EngModbusTVDblClick(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;

    procedure OnParamChange(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
  public
    FMouseClickTV_X, FMouseClickTV_Y: integer;
    FControlPressed: Boolean;
  end;

implementation

{$R *.dfm}

procedure TTreeViewFrame.EngModbusFilterCheckClick(Sender: TObject);
begin
  FilterCheckcb.Enabled := EngModbusFilterCheck.Checked;
  FilterClearBtn.Enabled := EngModbusFilterCheck.Checked;
end;

procedure TTreeViewFrame.EngModbusTVDblClick(Sender: TObject);
var
  LNode: TTreeNode;
  LForm: TForm;
  i,j: integer;
begin
  LNode := EngModbusTV.GetNodeAt( FMouseClickTV_X, FMouseClickTV_Y );

  if FControlPressed then
  begin
    //if LNode.AbsoluteIndex = 0 then
    if Assigned(LNode) then
    begin
      LForm := CreateOrShowMDIChild(TFormParamList);
      if Assigned(LForm) then
      begin
        Add2MultiNode(LNode,False,False,-1,LForm);
      end;
    end
    else
    if Assigned(LNode) then
    begin
      if TObject(LNode.Data) is TEngineParameterItem then
      begin
        LForm := CreateOrShowMDIChild(TFormParamList);
        if Assigned(LForm) then
        begin
          ParameterItem2ParamList(LNode,LForm);
        end;
      end;
    end;

    FControlPressed := False;
  end
  else
    Property1Click(EngModbusTV);
end;

procedure TTreeViewFrame.FilterCheckcbCloseUp(Sender: TObject);
var
  LSensorTypes: TSensorTypes;
begin
  if SensorTypeSelectChanged(LSensorTypes) then
    LoadSearchTreeFromEngParamSensorType(LSensorTypes, FCurrentEngParamSortMethod);
end;

procedure TTreeViewFrame.FilterClearBtnClick(Sender: TObject);
begin
  FilterCheckcb.SetAll(False);
  FilterCheckcbCloseUp(nil);
end;

procedure TTreeViewFrame.SrchTextEditChange(Sender: TObject);
begin
  FPJHTimerPool.AddOneShot(OnParamChange,500);
end;

end.
