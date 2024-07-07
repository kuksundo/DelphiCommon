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
unit UnitIniConfigBase;

interface

uses SysUtils, Vcl.Controls, Classes, Forms, Rtti, TypInfo, UnitIniAttriPersist, AdvGroupBox;

type
  TJHPIniConfigBase = class (TObject)
  private
    FIniFileName: string;
  public
    constructor create(AFileName: string);

    property IniFileName : String read FIniFileName write FIniFileName;

    procedure Load(AFileName: string = '');
    procedure Save(AFileName: string = ''; obj: TObject=nil);
    procedure Save2CsvFile(AFileName: string = ''; obj: TObject=nil);

    class function GetIniAttribute(Obj : TRttiObject) : JHPIniAttribute;

    class procedure LoadConfig2Form(AForm: TForm; ASettings: TObject); virtual;
    class procedure LoadConfigForm2Object(AForm: TForm; ASettings: TObject); virtual;

    class procedure LoadObject2Form(AForm, ASettings: TObject; AIsForm: Boolean);virtual;
    class procedure LoadForm2Object(AForm, ASettings: TObject; AIsForm: Boolean);virtual;

    class procedure SetTagNo2ComponentFromForm(AForm: TObject); virtual;
    class procedure GetValueFromTagNo(var AValue: TValue; const ATagNo: integer); virtual;
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

constructor TJHPIniConfigBase.create(AFileName: string);
begin
  FIniFileName := AFileName;
end;

class function TJHPIniConfigBase.GetIniAttribute(
  Obj: TRttiObject): JHPIniAttribute;
var
 Attr: TCustomAttribute;
begin
 for Attr in Obj.GetAttributes do
 begin
    if Attr is JHPIniAttribute then
    begin
      exit(JHPIniAttribute(Attr));
    end;
 end;

 result := nil;
end;

class procedure TJHPIniConfigBase.GetValueFromTagNo(var AValue: TValue; const ATagNo: integer);
var
 I : Integer;
 LKind: TTypeKind;
begin
  LKind := aValue.Kind;

  case LKind of
    tkWChar,
    tkLString,
    tkWString,
    tkString,
    tkChar,
    tkUString : aValue := IntToStr(ATagNo);
    tkInteger : aValue := ATagNo;
    tkInt64  : aValue := ATagNo;
    tkFloat  : aValue := ATagNo;
    tkEnumeration: begin
      if ATagNo = 0 then
        aValue := False
      else
        aValue := True;
    end;
//    tkSet: begin
//      i :=  StringToSet(aValue.TypeInfo,aData);
//      TValue.Make(@i, aValue.TypeInfo, aValue);
//    end;
//    tkClass: begin
//    end;
    else raise Exception.Create('Type not Supported');
  end;
end;

procedure TJHPIniConfigBase.Load(AFileName: string);
begin
  if AFileName = '' then
    AFileName := FIniFileName;

  TJHPIniPersist.Load(AFileName, Self);
end;

//Component의 Hint에 값이 저장되는 필드명이 저장되어 있어야 함
class procedure TJHPIniConfigBase.LoadConfig2Form(AForm: TForm; ASettings: TObject);
var
  ctx, ctx2 : TRttiContext;
  objType, objType2 : TRttiType;
  Prop, Prop2  : TRttiProperty;
  Value : TValue;
  IniValue : JHPIniAttribute;
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

      //TMenuItem이 Form 에 존재한 경우 LControl.Hint에서 에러 남(For문 빠져 나가버림)
      if not LControl.ClassType.InheritsFrom(TControl) then
        Continue;

      LStr := LControl.Hint; //Caption 또는 Text 또는 Value

      if LStr = '' then
        Continue;

      LTagNo := LControl.Tag;

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
          IniValue := TJHPIniPersist.GetIniAttribute(Prop2);

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

class procedure TJHPIniConfigBase.LoadConfigForm2Object(AForm: TForm; ASettings: TObject);
var
  ctx, ctx2 : TRttiContext;
  objType, objType2 : TRttiType;
  Prop, Prop2  : TRttiProperty;
  Value : TValue;
  IniValue : JHPIniAttribute;
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

      //TMenuItem이 Form 에 존재한 경우 LControl.Hint에서 에러 남(For문 빠져 나가버림)
      if not LControl.ClassType.InheritsFrom(TControl) then
        Continue;

      LStr := LControl.Hint; //Caption 또는 Text 또는 Value 또는 Checked

      if LStr = '' then
        Continue;

      LTagNo := LControl.Tag;

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

class procedure TJHPIniConfigBase.LoadForm2Object(AForm, ASettings: TObject; AIsForm: Boolean);
var
  ctx, ctx2 : TRttiContext;
  objType, objType2 : TRttiType;
  Prop, Prop2  : TRttiProperty;
  Value : TValue;
  IniValue : JHPIniAttribute;
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
      IniValue := TJHPIniPersist.GetIniAttribute(Prop2);

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

          //TMenuItem이 Form 에 존재한 경우 LControl.Hint에서 에러 남(For문 빠져 나가버림)
          if not LControl.ClassType.InheritsFrom(TControl) then
            Continue;

          LStr := LControl.Hint; //Caption 또는 Text 또는 Value 또는 Checked

          if LStr = '' then
            Continue;

          LTagNo := LControl.Tag;

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

              //SetValue시 Prop와 Value의 Data Type이 동일해야 함
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

class procedure TJHPIniConfigBase.LoadObject2Form(AForm, ASettings: TObject; AIsForm: Boolean);
var
  ctx, ctx2: TRttiContext;
  objType, objType2: TRttiType;
  Prop, Prop2: TRttiProperty;
  Value: TValue;
  IniValue: JHPIniAttribute;
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
      LCount := TControl(AForm).ComponentCount;

    objType2 := ctx2.GetType(ASettings.ClassInfo);

    for Prop2 in objType2.GetProperties do
    begin
      IniValue := TJHPIniPersist.GetIniAttribute(Prop2);

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

          //TMenuItem이 Form 에 존재한 경우 LControl.Hint에서 에러 남(For문 빠져 나가버림)
          if not LControl.ClassType.InheritsFrom(TControl) then
            Continue;

          LStr := LControl.Hint; //Caption 또는 Text 또는 Value

          if LStr = '' then
            Continue;

          LTagNo := LControl.Tag;

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
              //SetValue시 Prop와 Value의 Data Type이 동일해야 함
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
    ctx2.Free;
    ctx.Free;
  end;
end;

procedure TJHPIniConfigBase.Save(AFileName: string; obj: TObject);
begin
  if AFileName = '' then
    AFileName := FIniFileName;

  if obj = nil then
    obj := Self;

  // This saves the properties to the INI
  TJHPIniPersist.Save(AFileName ,obj);
end;

procedure TJHPIniConfigBase.Save2CsvFile(AFileName: string; obj: TObject);
var
  ctx : TRttiContext;
  objType : TRttiType;
  Prop  : TRttiProperty;
  Value : TValue;
  Data : String;
//  IniValue : JHPIniAttribute;
//  Field : TRttiField;
begin
  if AFileName = '' then
    AFileName := FIniFileName;

  if obj = nil then
    obj := Self;

  ctx := TRttiContext.Create;
  try
    objType := ctx.GetType(Obj.ClassInfo);

    for Prop in objType.GetProperties do
    begin
      Value := Prop.GetValue(Obj);
      Data := GetValue(Value);
    end;
  finally
    ctx.Free;
  end;
end;

class procedure TJHPIniConfigBase.SetTagNo2ComponentFromForm(AForm: TObject);
var
  ctx: TRttiContext;
  objType: TRttiType;
  Prop: TRttiProperty;
  Value: TValue;
  LControl: TControl;
  LObj: TObject;
  i, LCount, LTagNo: integer;
  LValueFieldName: string;
begin
  ctx := TRttiContext.Create;
  try
    LCount := TForm(AForm).ComponentCount;

    for i := 0 to LCount - 1 do
    begin
      LControl := TControl(TForm(AForm).Components[i]);

      //TMenuItem이 Form 에 존재한 경우 LControl.Hint에서 에러 남(For문 빠져 나가버림)
      if not LControl.ClassType.InheritsFrom(TControl) then
        Continue;

      LValueFieldName := LControl.Hint; //Caption 또는 Text 또는 Value

      if LValueFieldName = '' then
        Continue;

      LTagNo := LControl.Tag;

      if 0 <> LTagNo then
      begin
        objType := ctx.GetType(LControl.ClassInfo);

        if LValueFieldName = 'TAdvGroupBox' then  //TAdvGroupBox일 경우
        begin
          objType := ctx.GetType(TAdvGroupBox(LControl).CheckBox.ClassInfo);
          LValueFieldName := 'Checked';
        end;

        Prop := objType.GetProperty(LValueFieldName);

        if Assigned(Prop) then
        begin
          Value := Prop.GetValue(LControl);
          GetValueFromTagNo(Value, LTagNo);

          //SetValue시 Prop와 Value의 Data Type이 동일해야 함
          if LControl.ClassType = TAdvGroupBox then
            Prop.SetValue(TAdvGroupBox(LControl).CheckBox, Value)
          else
            Prop.SetValue(LControl, Value);
        end;
      end;
    end;//for
  finally
    ctx.Free;
  end;
end;

end.
