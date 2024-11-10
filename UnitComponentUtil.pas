unit UnitComponentUtil;

interface

uses Forms, SysUtils, Windows, Classes, Controls, TypInfo, Vcl.Graphics,
  Vcl.StdCtrls, Dialogs,
  Rtti;

//Tag로 컴포넌트 찾아서 색상 변경함
procedure ChangeCompColorByTagOnForm(AForm: TForm; ATag: integer; ANewColor: integer);
procedure ChangeCompColorByPropertyName(AComp: TComponent; ANewColor: integer; APropertyName: string='');
//Tag <> 0 인 입력 필드가 공란인지 확인함
//공란인 Component가 발견되면 Result에 반환함
function CheckRequiredInputByTagOnForm(AForm: TForm): TWinControl;
function CheckCompIfValueIsNull(AControl: TWinControl; ARemoveSpace: Boolean=True): Boolean;

//Tag <> 0 인 입력 필드가 공란인지 확인함
//입력값에 한글이 포함 된 Component가 발견되면 Result에 반환함
function CheckInputExistHangulByTagOnForm(AForm: TForm): TWinControl;
function CheckCompIfValueExistHangul(AControl: TWinControl): Boolean;

//Tag <> 0 인 입력 필드가 공란인지 확인함
//입력 길이가 AMaxLength 이상인 Component가 발견되면 Result에 반환함
function CheckInputLengthByTagOnForm(AForm: TForm; AMaxLength: integer): TWinControl;
function CheckCompIfInputLengthOver(AControl: TWinControl; AMaxLength: integer): Boolean;

function CheckRequiredInput(AForm: TForm): TWinControl;
function CheckExistHangulInput(AForm: TForm): TWinControl;
function CheckInputLengthOver(AForm: TForm; const ALength: integer): TWinControl;

//Hint값을 Text에 자동 입력
procedure InputHint2Component(AForm: TForm);
//Compnoent Name = Hint 리스트 반환
//Next Grid Column Caption을 쉽게 설정하는데 사용함
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
  //입력 안된 Component Value가 있으면 해당 Component 반환함
  Result := CheckRequiredInputByTagOnForm(AForm);

  //True = 입력 안된 Component 존재
  if Assigned(Result) then
  begin
    if Result.ClassName = 'TAdvOfficeCheckGroup' then
      ChangeCompColorByPropertyName(Result, clRed, 'BorderColor')
    else
      //Component Color 변경
      ChangeCompColorByPropertyName(Result, clYellow);
      ShowMessage('필수 항목: [' + Result.Hint + '] 을 입력하세요' );
  end
  else //WorkItemGrid Check
  begin

  end;
end;

function CheckExistHangulInput(AForm: TForm): TWinControl;
begin
  //한글이 포함된 Component Value가 있으면 해당 Component 반환함
  Result := CheckInputExistHangulByTagOnForm(AForm);

  //True = 입력값에 한글이 포함 된 Component 존재
  if Assigned(Result) then
  begin
    //Component Color 변경
    ChangeCompColorByPropertyName(Result, clYellow);
    ShowMessage('한글 사용하면 안됨: [' + Result.Hint + ']' );
  end
end;

function CheckInputLengthOver(AForm: TForm; const ALength: integer): TWinControl;
begin
  //Component Value가 70자 이상이면 해당 Component 반환함
  Result := CheckInputLengthByTagOnForm(AForm, ALength);

  //True = 입력값 길이가 70자 이상인 Component 존재
  if Assigned(Result) then
  begin
    //Component Color 변경
    ChangeCompColorByPropertyName(Result, clYellow);
    ShowMessage('길이가 70자 이내여야 함: [' + Result.Hint + ']' );
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
