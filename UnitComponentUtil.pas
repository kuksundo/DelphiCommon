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
function CheckCompIfValueIsNull(AControl: TWinControl): Boolean;

implementation

uses UnitRttiUtil2;

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

function CheckCompIfValueIsNull(AControl: TWinControl): Boolean;
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
    Result := LStr = '';
  end
  else
  if IsPublishedProp(AControl, 'Lines') then
  begin
    LValue := GetValueByPropertyName(TObject(AControl), 'Text');
    LStr := LValue.AsString;
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

end.
