unit UnitCheckGrpAdvUtil;

interface

uses System.Classes, AdvOfficeButtons, AdvGroupBox, ArrayHelper;

//AEnum: String Array를 CheckBox 생성함
//ACommaStr: Comma(,)로 분류된 String list -> Checked = True로 설정함
procedure FillInCheckGrpByArrayString(AEnum: TArrayRecord<string>; ACheckGrp: TAdvOfficeCheckGroup);
procedure LoadCheckItems2CheckGrpFromCommaStr(AEnum: TArrayRecord<string>; ACommaStr: string; ACheckGrp: TAdvOfficeCheckGroup);
procedure LoadCheckItems2CheckGrpFromIntSet(AEnum: TArrayRecord<string>; ACheckValueSet: integer; ACheckGrp: TAdvOfficeCheckGroup);

//GroupBox에서 Checked = True인 항목들을 Comma로 분류하여 반환함
function GetCommaStrFromCheckGrp(ACheckGrp: TAdvOfficeCheckGroup): string;
//GroupBox에서 Checked = True인 항목들을 Bitwise로 반환함(예: 00101 => 1은 True를 의미)
function GetSetsFromCheckGrp(ACheckGrp: TAdvOfficeCheckGroup): integer;

implementation

uses JHP.Util.Bit32Helper;

procedure FillInCheckGrpByArrayString(AEnum: TArrayRecord<string>; ACheckGrp: TAdvOfficeCheckGroup);
var
  LStr: string;
begin
  ACheckGrp.Items.Clear;

  for LStr in AEnum do
    ACheckGrp.Items.Add(LStr);
end;

procedure LoadCheckItems2CheckGrpFromCommaStr(AEnum: TArrayRecord<string>; ACommaStr: string; ACheckGrp: TAdvOfficeCheckGroup);
var
  LStrList: TStringList;
  i,j: integer;
begin
  FillInCheckGrpByArrayString(AEnum, ACheckGrp);

  LStrList := TStringList.Create;
  try
    LStrList.CommaText := ACommaStr;

    for i := 0 to LStrList.Count - 1 do
    begin
      for j := 0 to ACheckGrp.Items.Count - 1  do
      begin
        if ACheckGrp.Items.Strings[j] = LStrList.Strings[i] then
        begin
          ACheckGrp.Checked[j] := True;
          break;
        end;
      end;
    end;
  finally
    LStrList.Free;
  end;
end;

procedure LoadCheckItems2CheckGrpFromIntSet(AEnum: TArrayRecord<string>; ACheckValueSet: integer;
  ACheckGrp: TAdvOfficeCheckGroup);
var
  j: integer;
  LpjhBit32: TpjhBit32;
begin
  FillInCheckGrpByArrayString(AEnum, ACheckGrp);

  LpjhBit32 := ACheckValueSet;

  for j := 0 to ACheckGrp.Items.Count - 1  do
    ACheckGrp.Checked[j] := LpjhBit32.Bit[j];
end;

function GetCommaStrFromCheckGrp(ACheckGrp: TAdvOfficeCheckGroup) : string;
var
  i: integer;
begin
  Result := '';

  for i := 0 to ACheckGrp.Items.Count - 1  do
  begin
    if ACheckGrp.Checked[i] then
    begin
      Result := Result + ACheckGrp.Items.Strings[i] + ',';
    end;
  end;

  Delete(Result, Length(Result), 1); //마지막 ',' 삭제
end;

function GetSetsFromCheckGrp(ACheckGrp: TAdvOfficeCheckGroup): integer;
var
  i: integer;
begin
  Result := 0;

  for i := 0 to ACheckGrp.Items.Count - 1  do
  begin
    if ACheckGrp.Checked[i] then
    begin
      TpjhBit32(Result).Bit[i] := True;
    end;
  end;
end;

end.
