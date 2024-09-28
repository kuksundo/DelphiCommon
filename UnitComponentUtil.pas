unit UnitComponentUtil;

interface

uses Forms, SysUtils, Windows, Classes, Controls, TypInfo, Vcl.Graphics, Vcl.StdCtrls,
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
          Result := LControl;
          Break;
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
          Result := LControl;
          Break;
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
          Result := LControl;
          Break;
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

end.
