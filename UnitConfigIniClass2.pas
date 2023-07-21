{사용법:
  1. Config Form의 Control.hint = 값이 저장 되는 필드명(예: Caption 또는 Value 또는 Text)을 저장 함
    1) Ini 값을 Config Form(AForm)에 Load시 호출:
      FSettings.LoadConfig2Form(AForm, FSettings);
    2) Config Form의 내용을 Ini에 Save 시 호출:
      FSettings.LoadConfigForm2Object(AForm, FSettings);
  2. Control.Tag를 1부터 중복되지 않게 입력함
  3. Config Class Unit에 반드시 IniPersist를 Uses절에 포함 해야 함
     (포함하지 않으면 Compile은 되지만 GetProperties 호출 시 FASttrubuteGetter=nil로 반환 됨)
}
unit UnitConfigIniClass2;

interface

uses SysUtils, Vcl.Controls, Forms, Rtti, TypInfo, IniPersist, AdvGroupBox;

type
  TINIConfigBase = class (TObject)
  private
    FIniFileName: string;
  public
    constructor create(AFileName: string);

    property IniFileName : String read FIniFileName write FIniFileName;

    procedure Save(AFileName: string = ''; obj: TObject=nil);
    procedure Load(AFileName: string = '');

    class function GetIniAttribute(Obj : TRttiObject) : IniValueAttribute;

    class procedure LoadConfig2Form(AForm: TForm; ASettings: TObject); virtual;
    class procedure LoadConfigForm2Object(AForm: TForm; ASettings: TObject); virtual;

    class procedure LoadObject2Form(AForm, ASettings: TObject; AIsForm: Boolean);virtual;
    class procedure LoadForm2Object(AForm, ASettings: TObject; AIsForm: Boolean);virtual;
  end;

implementation

uses UnitRttiUtil2;

function strToken(var S: String; Seperator: Char): String;
var
  I: Word;
begin
  I:=Pos(Seperator,S);
  if I<>0 then
  begin
    Result:=System.Copy(S,1,I-1);
    System.Delete(S,1,I);
  end else
  begin
    Result:=S;
    S:='';
  end;
end;

{ TINIConfigBase }

constructor TINIConfigBase.create(AFileName: string);
begin
  FIniFileName := AFileName;
end;

class function TINIConfigBase.GetIniAttribute(
  Obj: TRttiObject): IniValueAttribute;
var
 Attr: TCustomAttribute;
begin
 for Attr in Obj.GetAttributes do
 begin
    if Attr is IniValueAttribute then
    begin
      exit(IniValueAttribute(Attr));
    end;
 end;

 result := nil;
end;

procedure TINIConfigBase.Load(AFileName: string);
begin
  if AFileName = '' then
    AFileName := FIniFileName;

  TIniPersist.Load(AFileName, Self);
end;

//Component의 Hint에 값이 저장되는 필드명이 저장되어 있어야 함
class procedure TINIConfigBase.LoadConfig2Form(AForm: TForm; ASettings: TObject);
var
  ctx, ctx2 : TRttiContext;
  objType, objType2 : TRttiType;
  Prop, Prop2  : TRttiProperty;
  Value : TValue;
  IniValue : IniValueAttribute;
//  Data : String;
  LControl: TControl;

  i, LTagNo: integer;
  LStr, s: string;
begin
  ctx := TRttiContext.Create;
  ctx2 := TRttiContext.Create;
  try
    objType2 := ctx2.GetType(ASettings.ClassInfo);

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);
      LStr := LControl.Hint; //Caption 또는 Text 또는 Value
      LTagNo := LControl.Tag;

      if LStr = '' then
        Continue;

      objType := ctx.GetType(LControl.ClassInfo);

      Prop := nil;

      if LStr = 'TAdvGroupBox' then  //TAdvGroupBox일 경우
      begin
        objType := ctx.GetType(TAdvGroupBox(LControl).CheckBox.ClassInfo);
        LStr := 'Checked';
      end;

      Prop := objType.GetProperty(LStr);

      if Assigned(Prop) then
      begin
        for Prop2 in objType2.GetProperties do
        begin
          IniValue := TIniPersist.GetIniAttribute(Prop2);

          if Assigned(IniValue) then
          begin
            if IniValue.TagNo = LTagNo then
            begin
              Value := Prop2.GetValue(ASettings);
//              Data := TIniPersist.GetValue(Value);
              if LControl.ClassType = TAdvGroupBox then
                Prop.SetValue(TAdvGroupBox(LControl).CheckBox, Value)
              else
                Prop.SetValue(LControl, Value);
              break;
            end;
          end;
        end;
      end;
    end;
 finally
   ctx.Free;
   ctx2.Free;
 end;
end;

class procedure TINIConfigBase.LoadConfigForm2Object(AForm: TForm; ASettings: TObject);
var
  ctx, ctx2 : TRttiContext;
  objType, objType2 : TRttiType;
  Prop, Prop2  : TRttiProperty;
  Value : TValue;
  IniValue : IniValueAttribute;
  Data : String;
  LControl: TControl;

  i, LTagNo: integer;
  LStr: string;
begin
  ctx := TRttiContext.Create;
  ctx2 := TRttiContext.Create;
  try
    objType2 := ctx2.GetType(ASettings.ClassInfo);

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);
      LStr := LControl.Hint; //Caption 또는 Text 또는 Value 또는 Checked
      LTagNo := LControl.Tag;

      if LStr = '' then
        Continue;

      objType := ctx.GetType(LControl.ClassInfo);

      Prop := nil;

      if (LStr = 'TAdvGroupBox') then  //TAdvGroupBox일 경우
      begin
        objType := ctx.GetType(TAdvGroupBox(LControl).CheckBox.ClassInfo);
        LStr := 'Checked';
      end;

      Prop := objType.GetProperty(LStr);

      if Assigned(Prop) then
      begin
        for Prop2 in objType2.GetProperties do
        begin
          if Prop2.Name = '' then
            exit;

          IniValue := GetIniAttribute(Prop2);

          if Assigned(IniValue) then
          begin
            if IniValue.TagNo = LTagNo then
            begin
              if LControl.ClassType = TAdvGroupBox then
                Value := Prop.GetValue(TAdvGroupBox(LControl).CheckBox)
              else
                Value := Prop.GetValue(LControl);

              Prop2.SetValue(ASettings, Value);
              break;
            end;
          end;
        end;
      end;
    end;
  finally
   ctx.Free;
   ctx2.Free;
  end;
end;

class procedure TINIConfigBase.LoadForm2Object(AForm, ASettings: TObject; AIsForm: Boolean);
var
  ctx, ctx2 : TRttiContext;
  objType, objType2 : TRttiType;
  Prop, Prop2  : TRttiProperty;
  Value : TValue;
  IniValue : IniValueAttribute;
  Data : String;
  LControl: TControl;
  LObj: TObject;

  i, LCount, LTagNo: integer;
  LStr: string;
begin
  ctx := TRttiContext.Create;
  ctx2 := TRttiContext.Create;
  try
    if AIsForm then
      LCount := TForm(AForm).ComponentCount
    else
      LCount := TFrame(AForm).ComponentCount;

    objType2 := ctx2.GetType(ASettings.ClassInfo);

    for Prop2 in objType2.GetProperties do
    begin
      IniValue := TIniPersist.GetIniAttribute(Prop2);

      if Assigned(IniValue) then
      begin
        if IniValue.DefaultValue = '->' then
        begin
          LObj := Prop2.GetValue(ASettings).AsType<TObject>;
          LoadForm2Object(AForm, LObj, AIsForm);
        end;

        for i := 0 to LCount - 1 do
        begin
          if AIsForm then
            LControl := TControl(TForm(AForm).Components[i])
          else
            LControl := TControl(TFrame(AForm).Components[i]);

          LStr := LControl.Hint; //Caption 또는 Text 또는 Value 또는 Checked
          LTagNo := LControl.Tag;

          if LStr = '' then
            Continue;

          if IniValue.TagNo = LTagNo then
          begin
            objType := ctx.GetType(LControl.ClassInfo);

            Prop := nil;

            if (LStr = 'TAdvGroupBox') then  //TAdvGroupBox일 경우
            begin
              objType := ctx.GetType(TAdvGroupBox(LControl).CheckBox.ClassInfo);
              LStr := 'Checked';
            end;

            Prop := objType.GetProperty(LStr);

            if Assigned(Prop) then
            begin
              if LControl.ClassType = TAdvGroupBox then
                Value := Prop.GetValue(TAdvGroupBox(LControl).CheckBox)
              else
                Value := Prop.GetValue(LControl);

              SetValue2(Prop2, Value);

              Prop2.SetValue(ASettings, Value);
              break;
            end;
          end;//if Assigned(IniValue)
        end;//for
      end;//if Assigned(IniValue)
    end;//for
  finally
    ctx.Free;
    ctx2.Free;
  end;
end;

class procedure TINIConfigBase.LoadObject2Form(AForm, ASettings: TObject; AIsForm: Boolean);
var
  ctx, ctx2: TRttiContext;
  objType, objType2: TRttiType;
  Prop, Prop2: TRttiProperty;
  Value: TValue;
  IniValue: IniValueAttribute;
  LControl: TControl;
  LObj: TObject;

  i, LCount, LTagNo: integer;
  LStr, s: string;
begin
  ctx := TRttiContext.Create;
  ctx2 := TRttiContext.Create;
  try
    if AIsForm then
      LCount := TForm(AForm).ComponentCount
    else
      LCount := TFrame(AForm).ComponentCount;

    objType2 := ctx2.GetType(ASettings.ClassInfo);

    for Prop2 in objType2.GetProperties do
    begin
      IniValue := TIniPersist.GetIniAttribute(Prop2);

      if Assigned(IniValue) then
      begin
        if IniValue.DefaultValue = '->' then
        begin
          LObj := Prop2.GetValue(ASettings).AsType<TObject>;
          LoadObject2Form(AForm, LObj, AIsForm);
        end;

        for i := 0 to LCount - 1 do
        begin
          if AIsForm then
            LControl := TControl(TForm(AForm).Components[i])
          else
            LControl := TControl(TFrame(AForm).Components[i]);

          LStr := LControl.Hint; //Caption 또는 Text 또는 Value
          LTagNo := LControl.Tag;

          if LStr = '' then
            Continue;

          if IniValue.TagNo = LTagNo then
          begin
            objType := ctx.GetType(LControl.ClassInfo);

            Prop := nil;

            if LStr = 'TAdvGroupBox' then  //TAdvGroupBox일 경우
            begin
              objType := ctx.GetType(TAdvGroupBox(LControl).CheckBox.ClassInfo);
              LStr := 'Checked';
            end;

            Prop := objType.GetProperty(LStr);

            if Assigned(Prop) then
            begin
              Value := Prop2.GetValue(ASettings);
              SetValue2(Prop, Value);
  //              Data := TIniPersist.GetValue(Value);
              if LControl.ClassType = TAdvGroupBox then
                Prop.SetValue(TAdvGroupBox(LControl).CheckBox, Value)
              else
                Prop.SetValue(LControl, Value);

              break;
            end;
          end;
        end;//for
      end;
    end;
  finally
    ctx.Free;
    ctx2.Free;
  end;
end;

procedure TINIConfigBase.Save(AFileName: string; obj: TObject);
begin
  if AFileName = '' then
    AFileName := FIniFileName;

  if obj = nil then
    obj := Self;

  // This saves the properties to the INI
  TIniPersist.Save(AFileName ,obj);
end;

end.
