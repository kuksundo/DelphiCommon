unit UnitComponentUtil;

interface

uses Forms, SysUtils, Windows, Classes, Controls, TypInfo, Vcl.Graphics,
  Vcl.StdCtrls, Dialogs,
  Rtti;

//Tag�� ������Ʈ ã�Ƽ� ���� ������
procedure ChangeCompColorByTagOnForm(AForm: TForm; ATag: integer; ANewColor: integer);
procedure ChangeCompColorByPropertyName(AComp: TComponent; ANewColor: integer; APropertyName: string='');
//Tag <> 0 �� �Է� �ʵ尡 �������� Ȯ����
//������ Component�� �߰ߵǸ� Result�� ��ȯ��
function CheckRequiredInputByTagOnForm(AForm: TForm): TWinControl;
function CheckCompIfValueIsNull(AControl: TWinControl; ARemoveSpace: Boolean=True): Boolean;

//Tag <> 0 �� �Է� �ʵ尡 �������� Ȯ����
//�Է°��� �ѱ��� ���� �� Component�� �߰ߵǸ� Result�� ��ȯ��
function CheckInputExistHangulByTagOnForm(AForm: TForm): TWinControl;
function CheckCompIfValueExistHangul(AControl: TWinControl): Boolean;

//Tag <> 0 �� �Է� �ʵ尡 �������� Ȯ����
//�Է� ���̰� AMaxLength �̻��� Component�� �߰ߵǸ� Result�� ��ȯ��
function CheckInputLengthByTagOnForm(AForm: TForm; AMaxLength: integer): TWinControl;
function CheckCompIfInputLengthOver(AControl: TWinControl; AMaxLength: integer): Boolean;

function CheckRequiredInput(AForm: TForm): TWinControl;
function CheckExistHangulInput(AForm: TForm): TWinControl;
function CheckInputLengthOver(AForm: TForm; const ALength: integer): TWinControl;

//Hint���� Text�� �ڵ� �Է�
procedure InputHint2Component(AForm: TForm);
//Compnoent Name = Hint ����Ʈ ��ȯ
//Next Grid Column Caption�� ���� �����ϴµ� �����
function GetNameNHint2Strlist(AForm: TForm): TStringList;

implementation

uses UnitRttiUtil2, UnitTRegExUtil;

procedure ChangeCompColorByTagOnForm(AForm: TForm; ATag: integer; ANewColor: integer);
var
  i:integer;
begin
  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i].Tag <> 0 then
        if Components[i].Tag <> ATag then
          if IsPublishedProp(Components[i], 'Color') then
            SetOrdProp(Components[i], 'Color', ANewColor);
    end;
  end;
end;

procedure ChangeCompColorByPropertyName(AComp: TComponent; ANewColor: integer; APropertyName: string);
begin
  if not Assigned(AComp) then
    exit;

  if APropertyName = '' then
    APropertyName := 'Color';

  if IsPublishedProp(AComp, APropertyName) then
    SetOrdProp(AComp, APropertyName, ANewColor);
end;

function CheckRequiredInputByTagOnForm(AForm: TForm): TWinControl;
var
  i:integer;
  LValue: TValue;
  LControl: TWinControl;
begin
  Result := nil;

  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i].Tag <> 0 then
      begin
        LControl := TWinControl(Components[i]);

        if CheckCompIfValueIsNull(LControl) then
        begin
          if LControl.Visible and LControl.Enabled then
          begin
            Result := LControl;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

function CheckCompIfValueIsNull(AControl: TWinControl; ARemoveSpace: Boolean): Boolean;
var
  LValue: TValue;
  LStr: string;
  LInt: integer;
  LDouble: Double;
begin
  Result := False;

  if IsPublishedProp(AControl, 'Text') then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'Text');
    LStr := LValue.AsString;// GetValue(LValue);

    if ARemoveSpace then
      LStr := Trim(LStr);

    Result := LStr = '';
  end
  else
  if IsPublishedProp(AControl, 'Lines') then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'Text');
    LStr := LValue.AsString;

    if ARemoveSpace then
      LStr := Trim(LStr);

    Result := LStr = '';
  end
  else
  if IsPublishedProp(AControl, 'ItemIndex') then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'ItemIndex');
    LInt := LValue.AsInteger;
    Result := Lint = -1;
  end
  else
  if AControl.ClassName = 'TAdvOfficeCheckGroup' then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'Value');
    LInt := LValue.AsInteger;
    Result := Lint = 0;
  end
  else
  if IsPublishedProp(AControl, 'Date') then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'DateTime');
    LDouble := LValue.AsExtended;
    Result := LDouble = 0;
  end;
end;

function CheckInputExistHangulByTagOnForm(AForm: TForm): TWinControl;
var
  i:integer;
  LValue: TValue;
  LControl: TWinControl;
begin
  Result := nil;

  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i].Tag <> 0 then
      begin
        LControl := TWinControl(Components[i]);

        if CheckCompIfValueExistHangul(LControl) then
        begin
          if LControl.Visible and LControl.Enabled then
          begin
            Result := LControl;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

function CheckCompIfValueExistHangul(AControl: TWinControl): Boolean;
var
  LValue: TValue;
  LStr: string;
  LInt: integer;
  LDouble: Double;
begin
  Result := False;

  if IsPublishedProp(AControl, 'Text') then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'Text');
    LStr := LValue.AsString;// GetValue(LValue);

    Result := CheckIfExistHangulUsingRegEx(LStr);
  end
  else
  if IsPublishedProp(AControl, 'Lines') then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'Text');
    LStr := LValue.AsString;

    Result := CheckIfExistHangulUsingRegEx(LStr);
  end;
end;

function CheckInputLengthByTagOnForm(AForm: TForm; AMaxLength: integer): TWinControl;
var
  i:integer;
  LValue: TValue;
  LControl: TWinControl;
begin
  Result := nil;

  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i].Tag <> 0 then
      begin
        LControl := TWinControl(Components[i]);

        if CheckCompIfInputLengthOver(LControl, AMaxLength) then
        begin
          if LControl.Visible and LControl.Enabled then
          begin
            Result := LControl;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

function CheckCompIfInputLengthOver(AControl: TWinControl; AMaxLength: integer): Boolean;
var
  LValue: TValue;
  LStr: string;
  LInt: integer;
  LDouble: Double;
begin
  Result := False;

  if IsPublishedProp(AControl, 'Text') then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'Text');
    LStr := LValue.AsString;// GetValue(LValue);

    Result := Length(LStr) > AMaxLength;
  end
  else
  if IsPublishedProp(AControl, 'Lines') then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'Text');
    LStr := LValue.AsString;

    Result := Length(LStr) > AMaxLength;
  end;
end;

function CheckRequiredInput(AForm: TForm): TWinControl;
begin
  //�Է� �ȵ� Component Value�� ������ �ش� Component ��ȯ��
  Result := CheckRequiredInputByTagOnForm(AForm);

  //True = �Է� �ȵ� Component ����
  if Assigned(Result) then
  begin
    if Result.ClassName = 'TAdvOfficeCheckGroup' then
      ChangeCompColorByPropertyName(Result, clRed, 'BorderColor')
    else
      //Component Color ����
      ChangeCompColorByPropertyName(Result, clYellow);
      ShowMessage('�ʼ� �׸�: [' + Result.Hint + '] �� �Է��ϼ���' );
  end
  else //WorkItemGrid Check
  begin

  end;
end;

function CheckExistHangulInput(AForm: TForm): TWinControl;
begin
  //�ѱ��� ���Ե� Component Value�� ������ �ش� Component ��ȯ��
  Result := CheckInputExistHangulByTagOnForm(AForm);

  //True = �Է°��� �ѱ��� ���� �� Component ����
  if Assigned(Result) then
  begin
    //Component Color ����
    ChangeCompColorByPropertyName(Result, clYellow);
    ShowMessage('�ѱ� ����ϸ� �ȵ�: [' + Result.Hint + ']' );
  end
end;

function CheckInputLengthOver(AForm: TForm; const ALength: integer): TWinControl;
begin
  //Component Value�� 70�� �̻��̸� �ش� Component ��ȯ��
  Result := CheckInputLengthByTagOnForm(AForm, ALength);

  //True = �Է°� ���̰� 70�� �̻��� Component ����
  if Assigned(Result) then
  begin
    //Component Color ����
    ChangeCompColorByPropertyName(Result, clYellow);
    ShowMessage('���̰� 70�� �̳����� ��: [' + Result.Hint + ']' );
  end
end;

procedure InputHint2Component(AForm: TForm);
var
  i:integer;
  LControl: TWinControl;
begin
  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i].Tag <> 0 then
      begin
        LControl := TWinControl(Components[i]);

        if LControl.Hint <> '' then
        begin
//          if LControl.Visible and LControl.Enabled then
//          begin
            if IsPublishedProp(LControl, 'Text') then
            begin
              SetValueByPropertyName(TObject(LControl), LControl.Hint, 'Text');
            end
            else
            if IsPublishedProp(LControl, 'Lines') then
            begin
              SetValueByPropertyName(TObject(LControl), LControl.Hint, 'Text');
            end;
//          end;
        end;
      end;
    end; //for
  end;//with
end;

function GetNameNHint2Strlist(AForm: TForm): TStringList;
var
  i:integer;
  LControl: TWinControl;
begin
  Result := TStringList.Create;

  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i].Tag <> 0 then
      begin
        LControl := TWinControl(Components[i]);

        if LControl.Hint <> '' then
        begin
          Result.Add(LControl.Name + '=' + LControl.Hint);
        end;
      end;
    end; //for
  end;//with
end;

end.
