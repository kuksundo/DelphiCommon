unit FrmSelectCheckBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGroupBox,
  AdvOfficeButtons, Vcl.ExtCtrls, Vcl.Buttons,
  ArrayHelper, UnitCheckGrpAdvUtil;

type
  TSelectChcekBoxF = class(TForm)
    Panel1: TPanel;
    CheckBoxGrp: TAdvOfficeCheckGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    //AEnum: String Array를 CheckBox 생성함
    //ACommaStr: Comma(,)로 분류된 String list -> Checked = True로 설정함
    procedure LoadCheckItems2CheckGrpFromCSV(AEnum: TArrayRecord<string>; ACommaStr: string);
    procedure LoadCheckItems2CheckGrpFromInt(AEnum: TArrayRecord<string>; ACheckValueSet: integer; ALabelName: string='');
    //GroupBox에서 Checked = True인 항목들을 Comma로 분류하여 반환함
    function GetCSVFromCheckGrp : string;
    //GroupBox에서 Checked = True인 항목들을 Bitwise로 반환함(예: 00101 => 1은 True를 의미)
//    function GetSetsFromCheckGrp: integer;
    procedure FillCheckGrpByArrayString(AEnum: TArrayRecord<string>);
  end;

//ACheckValueList: Comma로 분류된 String
//Result: Checked = True인 Item List를 Comma로 분류하여 반환함
function EditCheckBoxGrp(AEnum: TArrayRecord<string>; ACheckValueList: string): string;
//Result : Set Type 값(Bitwise)
function GetSetFromCheckBoxGrp(AEnum: TArrayRecord<string>; ACheckValueList: string): integer; overload;
//ACheckValueList: Set Type 값: 1이면 True, 0이면 False로 설정 됨
function GetSetFromCheckBoxGrp(AEnum: TArrayRecord<string>; ACheckValueList: integer; ALabelName: string=''): integer; overload;
function GetSetFromCheckBoxGrp(AEnum: TStringList; ACheckValueList: integer; ALabelName: string=''): integer; overload;

var
  SelectChcekBoxF: TSelectChcekBoxF;

implementation

uses JHP.Util.Bit32Helper;

{$R *.dfm}

function EditCheckBoxGrp(AEnum: TArrayRecord<string>; ACheckValueList: string): string;
var
  LSelectChcekBoxF: TSelectChcekBoxF;
begin//ACkeckBoxList: 콤마로 분리된 Item list임
  Result := '';

  LSelectChcekBoxF := TSelectChcekBoxF.Create(nil);
  try
    with LSelectChcekBoxF do
    begin
      LoadCheckItems2CheckGrpFromCSV(AEnum, ACheckValueList);

      if ShowModal = mrOK then
      begin
        Result := GetCSVFromCheckGrp;
      end
      else
        Result := 'No Change';
    end;
  finally
    LSelectChcekBoxF.Free;
  end;
end;

function GetSetFromCheckBoxGrp(AEnum: TArrayRecord<string>; ACheckValueList: string): integer;
var
  LSelectChcekBoxF: TSelectChcekBoxF;
begin//ACheckValueList: 콤마로 분리된 Item list임
  Result := -1;

  LSelectChcekBoxF := TSelectChcekBoxF.Create(nil);
  try
    with LSelectChcekBoxF do
    begin
      LoadCheckItems2CheckGrpFromCSV(AEnum, ACheckValueList);

      if ShowModal = mrOK then
      begin
        Result := GetSetsFromCheckGrp(CheckBoxGrp);
      end;
    end;
  finally
    LSelectChcekBoxF.Free;
  end;
end;

function GetSetFromCheckBoxGrp(AEnum: TArrayRecord<string>; ACheckValueList: integer; ALabelName: string=''): integer;
var
  LSelectChcekBoxF: TSelectChcekBoxF;
begin//ACheckValueList: Bitwise value list임
  Result := ACheckValueList;

  LSelectChcekBoxF := TSelectChcekBoxF.Create(nil);
  try
    with LSelectChcekBoxF do
    begin
      Label1.Caption := ALabelName;

      LoadCheckItems2CheckGrpFromIntSet(AEnum, ACheckValueList, LSelectChcekBoxF.CheckBoxGrp);

      if ShowModal = mrOK then
      begin
        Result := GetSetsFromCheckGrp(CheckBoxGrp);
      end;
    end;
  finally
    LSelectChcekBoxF.Free;
  end;
end;

function GetSetFromCheckBoxGrp(AEnum: TStringList; ACheckValueList: integer; ALabelName: string): integer;
var
  LArray: TArrayRecord<String>;
  LStr: string;
begin
  for LStr in AEnum do
  begin
    if LStr <> '' then
    begin
      LArray.Add(LStr);
    end;
  end;

  Result := GetSetFromCheckBoxGrp(LArray, ACheckValueList, ALabelName);
end;

procedure TSelectChcekBoxF.FillCheckGrpByArrayString(AEnum: TArrayRecord<string>);
begin
  FillInCheckGrpByArrayString(AEnum, CheckBoxGrp);
end;

function TSelectChcekBoxF.GetCSVFromCheckGrp: string;
var
  i: integer;
begin
  Result := GetCommaStrFromCheckGrp(CheckBoxGrp);
end;

//function TSelectChcekBoxF.GetSetsFromCheckGrp: integer;
//var
//  i: integer;
//begin
//  Result := 0;
//
//  for i := 0 to CheckBoxGrp.Items.Count - 1  do
//  begin
//    if CheckBoxGrp.Checked[i] then
//    begin
//      TpjhBit32(Result).Bit[i] := True;
//    end;
//  end;
//end;

procedure TSelectChcekBoxF.LoadCheckItems2CheckGrpFromCSV(
  AEnum: TArrayRecord<string>; ACommaStr: string);
var
  LStrList: TStringList;
  i,j: integer;
begin
  FillCheckGrpByArrayString(AEnum);

  LStrList := TStringList.Create;
  try
    LStrList.CommaText := ACommaStr;

    for i := 0 to LStrList.Count - 1 do
    begin
      for j := 0 to CheckBoxGrp.Items.Count - 1  do
      begin
        if CheckBoxGrp.Items.Strings[j] = LStrList.Strings[i] then
        begin
          CheckBoxGrp.Checked[j] := True;
          break;
        end;
      end;
    end;
  finally
    LStrList.Free;
  end;
end;

procedure TSelectChcekBoxF.LoadCheckItems2CheckGrpFromInt(
  AEnum: TArrayRecord<string>; ACheckValueSet: integer; ALabelName: string='');
var
  j: integer;
  LpjhBit32: TpjhBit32;
begin
  Label1.Caption := ALabelName;

  FillCheckGrpByArrayString(AEnum);

  LpjhBit32 := ACheckValueSet;

  for j := 0 to CheckBoxGrp.Items.Count - 1  do
    CheckBoxGrp.Checked[j] := LpjhBit32.Bit[j];
end;

end.
