unit UnitIniPersistUtil2;

interface

uses System.SysUtils, System.Classes, Rtti, System.TypInfo, Vcl.Controls, Vcl.StdCtrls,
  Vcl.ExtCtrls, AdvGroupBox, Variants,
  //IniPersist를 Uses에 포함하지 않으면 TIniPersist.GetIniAttribute가 nil을 반환함
  IniPersist,
  mormot.core.datetime, mormot.core.variants, mormot.core.base, mormot.core.data,
  mormot.core.unicode
  ;

type
  TMyValueProperty = record
    fValuePropName: string;
    fValuePropType: TTypeKind;
  end;

function Variant2TValue(AVar: Variant): TValue;
function TValue2Variant(AValue: TValue): Variant;
function GetNameOfValuePropertyFromControl(AControl: TControl): string;
function GetNameOfValuePropertyFromControl2(AControl: TControl): string;
function GetNameOfValuePropNameNTypeFromControl(AControl: TControl): TMyValueProperty;
function GetSuffixOfNameFromControl(AControl: TControl): string;
function GetRemovedSuffixNameFromControl(AControl: TControl): string;
procedure SetNameNHintFromProperty2Form(AForm: TComponent; ASQLRecord: TObject; AStrings: TStrings=nil);
procedure LoadPropertyValue2Form(AForm: TComponent; ASQLRecord: TObject);
procedure LoadPropertyValueFromForm(AForm: TComponent; ASQLRecord: TObject);
//AAttrIndex : 1 = Section Name, 2 = Key Name, 3 = Default Value, 4 = Index
//             [{'SectionName':Value}]
function LoadPropertyAttr2Variant(ASQLRecord: TObject; AAttrIndex: integer;
  AIsPropertyOnly: Boolean=False): variant;
//SQLRecord의 Var Type(Json 내용)을 모두 Text형식으로 변환하여 반환 함
//ASQLRecord Parameter는 Var Type을 참조하기 위해 사용됨
//Grid에 Load할 때 사용됨
//DB에 저장된 값을 그대로 Variant로 가져옴 (Date, Enum Type은 Grid에 표시하기위해 변경이 필요함)
function LoadJsonOfPropertyValue2Variant(AJson: Variant; ASQLRecord: TObject): variant;
//Json{Component Name: Component Value,...}으로 부터 Form의 Component로 값을 할당함(Component Name이 같아야 함)
procedure LoadData2FormFromJson(AJson: string; AForm: TComponent;
  ARemoveSuffix: Boolean=False; AIsUsePosFunc: Boolean = False);
//Form의 {Component Name: Component Value,...} 형식으로 Json을 반환 함.
function GetJsonFromForm(AForm: TComponent; ARemoveSuffix: Boolean=False): string;
function GstJson2JsonArray(AJson: string): string;
function GetNameIndexOfJson(ACompName, AJson: string; AIsUsePosFunc: Boolean=False): integer;

implementation

uses UnitEnumHelper2;

function Variant2TValue(AVar: Variant): TValue;
var
  basicType  : Integer;
  IntVal: Int64;
  WordValue: LongWord;
  StrVal: string;
  DoubleValue: Double;
  DateValue: TDateTime;
begin
  basicType := VarType(AVar) and VarTypeMask;

  case basicType of
    varEmpty     : ;
    varNull      : ;
    varByte,
    varSmallInt,
    varInteger,
    varInt64: begin
      IntVal := AVar;
      TValue.Make(@IntVal,TypeInfo(Integer),Result);
    end;
    varSingle,
    varDouble: begin
      DoubleValue := AVar;
      TValue.Make(@DoubleValue,TypeInfo(Double),Result);
    end;
    varCurrency,
    varDate      : begin
      DateValue := AVar;
      TValue.Make(@DateValue,TypeInfo(TDateTime),Result);
    end;
    varOleStr    : ;
    varDispatch  : ;
    varError     : ;
    varBoolean   : ;
    varVariant   : begin
      StrVal := AVar;
      TValue.Make(@StrVal,TypeInfo(String),Result);
    end;
    varUnknown   : ;
    varWord,
    varLongWord  : begin
      WordValue := AVar;
      TValue.Make(@WordValue,TypeInfo(Integer),Result);
    end;
    varStrArg    : ;
    varUString,
    varString    : begin
      StrVal := AVar;
      TValue.Make(@StrVal,TypeInfo(String),Result);
    end;
    varAny       : ;
    varTypeMask  : ;
  end;
end;

function TValue2Variant(AValue: TValue): Variant;
begin
  Result := AValue.AsVariant;
end;

function GetNameOfValuePropertyFromControl(AControl: TControl): string;
begin
  //아래 비교문이  AControl.InheritsFrom(TCustomEdit) 보다 먼저 위치 해야 함
  if AControl.ClassName = 'TJvDatePickerEdit' then
    Result := 'Date'
  else
  if AControl.ClassName = 'TDateTimePicker' then
    Result := 'Date'
  else
  if AControl.InheritsFrom(TCustomEdit) then
    Result := 'Text'
  else
  if AControl.InheritsFrom(TCustomComboBox) then
    Result := 'ItemIndex'
  else
  if AControl.InheritsFrom(TCustomMemo) then
    Result := 'Text'
  else
  if AControl.InheritsFrom(TCustomCheckBox) then
    Result := 'Checked'
  else
  if AControl.InheritsFrom(TCustomRadioGroup) then
    Result := 'ItemIndex'
  else
    Result := '';
end;

function GetNameOfValuePropertyFromControl2(AControl: TControl): string;
begin
  if AControl.InheritsFrom(TCustomComboBox) then
    Result := 'Text'
  else
    Result := '';
end;

function GetSuffixOfNameFromControl(AControl: TControl): string;
begin
  if AControl.InheritsFrom(TCustomEdit) then
    Result := 'Edit'
  else
  if AControl.InheritsFrom(TCustomComboBox) then
    Result := 'Combo'
  else
  if AControl.InheritsFrom(TCustomMemo) then
    Result := 'Memo'
  else
  if AControl.InheritsFrom(TCustomCheckBox) then
    Result := 'Check'
  else
  if AControl.InheritsFrom(TCustomRadioGroup) then
    Result := 'RG'
  else
    Result := '';
end;

function GetRemovedSuffixNameFromControl(AControl: TControl): string;
var
  LSuffix: string;
begin
  LSuffix := GetSuffixOfNameFromControl(AControl);
  Result := StringReplace(AControl.Name, LSuffix, '', [rfReplaceAll]);
end;

function GetNameOfValuePropNameNTypeFromControl(AControl: TControl): TMyValueProperty;
begin
  //아래 비교문이  AControl.InheritsFrom(TCustomEdit) 보다 먼저 위치 해야 함
  if AControl.ClassName = 'TJvDatePickerEdit' then
  begin
    Result.fValuePropName := 'Date';
    Result.fValuePropType := tkFloat;
  end
  else
  if AControl.ClassName = 'TDateTimePicker' then
  begin
    Result.fValuePropName := 'Date';
    Result.fValuePropType := tkFloat;
  end
  else
  if AControl.InheritsFrom(TCustomEdit) then
  begin
    Result.fValuePropName := 'Text';
    Result.fValuePropType := tkString;
  end
  else
  if AControl.InheritsFrom(TCustomComboBox) then
  begin
    Result.fValuePropName := 'ItemIndex';
    Result.fValuePropType := tkInteger;
  end
  else
  if AControl.InheritsFrom(TCustomMemo) then
  begin
    Result.fValuePropName := 'Text';
    Result.fValuePropType := tkString;
  end
  else
  if AControl.InheritsFrom(TCustomCheckBox) then
  begin
    Result.fValuePropName := 'Checked';
    Result.fValuePropType := tkEnumeration;
  end
  else
  if AControl.InheritsFrom(TCustomRadioGroup) then
  begin
    Result.fValuePropName := 'ItemIndex';
    Result.fValuePropType := tkInteger;
  end
  else
  begin
    Result.fValuePropName := '';
    Result.fValuePropType := tkUnknown;
  end
end;

//Attribute의 TagNo를 읽어서 폼의 콤포넌트 Hint 및 Name을 자동 설정 함
//컴포넌트이 Tag는 수동으로 입력해야 함
procedure SetNameNHintFromProperty2Form(AForm: TComponent; ASQLRecord: TObject; AStrings: TStrings);
var
  ControlCtx, RecordCtx : TRttiContext;
  ControlType, RecordType : TRttiType;
  ControlProp, ControlNameProp, ControlHintProp, RecordProp  : TRttiProperty;
  Value : TValue;
  IniValue : IniValueAttribute;
//  Data : String;
  LControl: TControl;

  i, LTagNo: integer;
  LStr, s: string;
begin
  ControlCtx := TRttiContext.Create;
  RecordCtx := TRttiContext.Create;
  try
    RecordType := RecordCtx.GetType(ASQLRecord.ClassInfo);

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);
//      LStr := LControl.Hint; //Caption 또는 Text 또는 Value
      LTagNo := LControl.Tag;

      if LTagNo = 0 then
        Continue;

      ControlType := ControlCtx.GetType(LControl.ClassInfo);

      ControlProp := nil;

      if LStr = 'TAdvGroupBox' then  //TAdvGroupBox일 경우
      begin
        ControlType := ControlCtx.GetType(TAdvGroupBox(LControl).CheckBox.ClassInfo);
        LStr := 'Checked';
      end;

      LStr := 'Tag';
      ControlProp := ControlType.GetProperty(LStr);

      if Assigned(ControlProp) then
      begin
        for RecordProp in RecordType.GetProperties do
        begin
          if RecordProp.Name = '' then
            Continue;

          IniValue := TIniPersist.GetIniAttribute(RecordProp);

          if Assigned(IniValue) then
          begin
            if IniValue.TagNo = LTagNo then
            begin
              ControlNameProp := ControlType.GetProperty('Name');

              if Assigned(ControlNameProp) then
              begin
                s := RecordProp.Name + GetSuffixOfNameFromControl(LControl);
                Value := s;
                ControlNameProp.SetValue(LControl, Value);

                if Assigned(AStrings) then
                  AStrings.Add(s + ': ' + ControlType.Name + ';');
              end;

              ControlHintProp := ControlType.GetProperty('Hint');

              if Assigned(ControlHintProp) then
              begin
                Value := GetNameOfValuePropertyFromControl(LControl);
                ControlHintProp.SetValue(LControl, Value);
              end;

              //              Data := TIniPersist.GetValue(Value);
//              if LControl.ClassType = TAdvGroupBox then
//                ControlProp.SetValue(TAdvGroupBox(LControl).CheckBox, Value)
//              else
//                ControlProp.SetValue(LControl, Value);
              break;
            end;
          end;
        end;
      end;
    end;
 finally
   ControlCtx.Free;
   RecordCtx.Free;
 end;
end;

procedure LoadPropertyValue2Form(AForm: TComponent; ASQLRecord: TObject);
var
  ControlCtx, RecordCtx : TRttiContext;
  ControlType, RecordType : TRttiType;
  ControlProp, RecordProp  : TRttiProperty;
  Value : TValue;
  IniValue : IniValueAttribute;
  LType: TRttiType;
  LControl: TControl;
  i, LTagNo: integer;
  LControlValueName: string;
begin
  ControlCtx := TRttiContext.Create;
  RecordCtx := TRttiContext.Create;
  try
    RecordType := RecordCtx.GetType(ASQLRecord.ClassInfo);

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);
      LTagNo := LControl.Tag;

      if LTagNo = 0 then
        Continue;

      LControlValueName := GetNameOfValuePropertyFromControl(LControl); //Caption 또는 Text 또는 Value
      ControlType := ControlCtx.GetType(LControl.ClassInfo);

      ControlProp := nil;

      if LControl.ClassType = TAdvGroupBox then  //TAdvGroupBox일 경우
      begin
        ControlType := ControlCtx.GetType(TAdvGroupBox(LControl).CheckBox.ClassInfo);
        LControlValueName := 'Checked';
      end;

      ControlProp := ControlType.GetProperty(LControlValueName);

      if Assigned(ControlProp) then
      begin
        for RecordProp in RecordType.GetProperties do
        begin
          IniValue := TIniPersist.GetIniAttribute(RecordProp);

          if Assigned(IniValue) then
          begin
            if IniValue.Name = '' then
              Continue;

            if IniValue.TagNo = LTagNo then
            begin
              if IniValue.Section = 'ConvertFrom' then
              begin
                LControlValueName := GetNameOfValuePropertyFromControl2(LControl);
                ControlProp := ControlType.GetProperty(LControlValueName);
              end;

              Value := RecordProp.GetValue(ASQLRecord);

              if RecordProp.PropertyType.TypeKind = System.TypInfo.tkEnumeration then
              begin
                if RecordProp.PropertyType.QualifiedName <> 'System.Boolean' then
                begin
                  LType := RecordCtx.FindType(RecordProp.PropertyType.QualifiedName);  //QualifiedName = UnitName.TypeName

                  if LType <> nil then
                  begin
//                    Value := EnumOrdValueToTValue(LType.Handle, StrToInt(Value.ToString));
                    Value := GetEnumValue(LType.Handle, Value.ToString);
                  end;
                end;
              end
              else
              if (RecordProp.PropertyType.TypeKind = System.TypInfo.tkInteger) or
                (RecordProp.PropertyType.TypeKind = System.TypInfo.tkInt64) then
              begin//Integer는 TEdit로 입력 받아서 Integer Proporty 에 저장하기 위해서는 StrToInt Type Cast가 필요함
                //TTimeLog = tkInt64이며 JvDateTimePickerEdit는 TEdit를 상속함
                if RecordProp.PropertyType.Name = 'TTimeLog' then
                begin
                  if (LControlValueName = 'Date') then
                    Value := TimeLogToDateTime(Value.AsInt64);
                end
                else
                begin
                  if (LControlValueName = 'Text') then
                    Value := Value.ToString;
                end;
              end;

              if LControl.ClassType = TAdvGroupBox then
                ControlProp.SetValue(TAdvGroupBox(LControl).CheckBox, Value)
              else
                ControlProp.SetValue(LControl, Value);

              break;
            end;
          end;
        end;//for
      end;
    end;
 finally
   ControlCtx.Free;
   RecordCtx.Free;
 end;
end;

procedure LoadPropertyValueFromForm(AForm: TComponent; ASQLRecord: TObject);
var
  ControlCtx, RecordCtx : TRttiContext;
  ControlType, RecordType : TRttiType;
  ControlProp, RecordProp  : TRttiProperty;
  LType: TRttiType;
  OrdinalType: TRttiOrdinalType;
  Instance: TRttiInstanceType;
  Value : TValue;
  IniValue : IniValueAttribute;
  LControl: TControl;
  i, LTagNo, Lint: integer;
  LControlValueName, LTypeName: string;
begin
  ControlCtx := TRttiContext.Create;
  RecordCtx := TRttiContext.Create;
  try
    RecordType := RecordCtx.GetType(ASQLRecord.ClassInfo);

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);
      LTagNo := LControl.Tag;

      if LTagNo = 0 then
        Continue;

      LControlValueName := GetNameOfValuePropertyFromControl(LControl); //Caption 또는 Text 또는 Value
      ControlType := ControlCtx.GetType(LControl.ClassInfo);

      ControlProp := nil;

//      if LStr = 'TAdvGroupBox' then  //TAdvGroupBox일 경우
//      begin
//        ControlType := ControlCtx.GetType(TAdvGroupBox(LControl).CheckBox.ClassInfo);
//        LStr := 'Checked';
//      end;

      ControlProp := ControlType.GetProperty(LControlValueName);

      if Assigned(ControlProp) then
      begin
        for RecordProp in RecordType.GetProperties do
        begin
          IniValue := TIniPersist.GetIniAttribute(RecordProp);

          if Assigned(IniValue) then
          begin
            if IniValue.Name = '' then
              Continue;

            if IniValue.TagNo = LTagNo then
            begin
              if IniValue.Section = 'ConvertFrom' then
              begin
                ControlType := ControlCtx.GetType(LControl.ClassInfo);
                LControlValueName := GetNameOfValuePropertyFromControl2(LControl); //Caption 또는 Text 또는 Value
                ControlProp := ControlType.GetProperty(LControlValueName);
              end;

              if LControl.ClassType = TAdvGroupBox then
                Value := ControlProp.GetValue(TAdvGroupBox(LControl).CheckBox)
              else
                Value := ControlProp.GetValue(LControl);

              if RecordProp.PropertyType.TypeKind = System.TypInfo.tkEnumeration then
//              if IniValue.Section <> '' then
              begin
                //Property Type이 Enum인 경우 Form의 Interger Type을 Enum Type으로 변경해 주어야 RecordProp.SetValue 에서 에러가 안 남
//                Instance := RecordCtx.FindType(LTypeName).AsInstance;
                LType := RecordCtx.FindType(RecordProp.PropertyType.QualifiedName);  //QualifiedName = UnitName.TypeName

                if LType <> nil then
                begin
                if RecordProp.PropertyType.QualifiedName <> 'System.Boolean' then
                begin
                    Value := EnumOrdValueToTValue(LType.Handle, StrToInt(Value.ToString));
                end;
//                  Value := EnumNameToTValue(LType.Handle, Value.ToString);
//                  TJHEnumeration<Instance.MetaclassType>.FromOrdinal(Value.AsInteger);
                end;
              end
              else
              if (RecordProp.PropertyType.TypeKind = System.TypInfo.tkInteger) or
                (RecordProp.PropertyType.TypeKind = System.TypInfo.tkInt64) then
              begin//Integer는 TEdit로 입력 받아서 Integer Proporty 에 저장하기 위해서는 StrToInt Type Cast가 필요함
                //TTimeLog = tkInt64이며 JvDateTimePickerEdit는 TEdit를 상속함
                if RecordProp.PropertyType.Name = 'TTimeLog' then
                begin
                  if (LControlValueName = 'Date') then
                    Value := TimeLogFromDateTime(Value.AsExtended);
                end
                else
                begin
                  if (LControlValueName = 'Text') then
                  begin
                    if RecordProp.PropertyType.TypeKind = System.TypInfo.tkInt64 then
                      Value := StrToInt64Def(Value.ToString,0)
                    else
                      Value := StrToIntDef(Value.ToString,0);
                  end;
                end;
              end;

              RecordProp.SetValue(ASQLRecord, Value);
              break;
            end;
          end;
        end;//for
      end;
    end;
  finally
    ControlCtx.Free;
    RecordCtx.Free;
  end;
end;

function LoadPropertyAttr2Variant(ASQLRecord: TObject; AAttrIndex: integer;
  AIsPropertyOnly: Boolean): variant;
var
  RecordCtx : TRttiContext;
  RecordType : TRttiType;
  RecordProp  : TRttiProperty;
  IniValue : IniValueAttribute;
  LPropName, LAttrName: string;
  Value : TValue;
begin
  RecordCtx := TRttiContext.Create;
  try
    RecordType := RecordCtx.GetType(ASQLRecord.ClassInfo);
    TDocVariant.New(Result);

    for RecordProp in RecordType.GetProperties do
    begin
      if not RecordProp.IsWritable then
        continue;

      if RecordProp.Visibility <> mvPublished then
        Continue;

      LPropName := RecordProp.Name;

      //"array of TSQLGSFileRec" type은 Skip함(Field명: Attachments)
      if (LPropName = 'IDValue') or (LPropName = 'InternalState') or
         (LPropName = 'Attachments') then
        continue;

      IniValue := TIniPersist.GetIniAttribute(RecordProp);

      if Assigned(IniValue) then
      begin
        case AAttrIndex of
          1: LAttrName := IniValue.Section;
          2,3,4: LAttrName := IniValue.Name;
        end;

        if LAttrName = '' then
          Continue;

        //Value는 무시하고 Property(속성)만 ADoc에 저장함
        if AIsPropertyOnly then
        begin
          case AAttrIndex of
            3: Value := IniValue.DefaultValue;
            4: Value := IniValue.TagNo;
            else
              Value := ' ';
          end;
          TDocVariantData(Result).Value[LAttrName] := Value.AsVariant;
        end
        else
        begin
          Value := RecordProp.GetValue(ASQLRecord);

          //tkSet Type은 value.AsVariant에서 지원 안함 (type cast error 발생함)
          if RecordProp.PropertyType.TypeKind = System.TypInfo.tkSet then
          begin
    //        TDocVariantData(ADoc).Value[LPropName] := Value.AsInteger;
          end
          else
            TDocVariantData(Result).Value[LAttrName] := Value.AsVariant;
        end;
      end;
    end;//for
 finally
   RecordCtx.Free;
 end;
end;

function LoadJsonOfPropertyValue2Variant(AJson: Variant; ASQLRecord: TObject): variant;
var
  i: integer;
  LPropName: string;
  RecordCtx : TRttiContext;
  RecordType : TRttiType;
  RecordProp  : TRttiProperty;
  LDate: TDateTime;
begin
  TDocVariant.New(Result);

  RecordCtx := TRttiContext.Create;
  try
    RecordType := RecordCtx.GetType(ASQLRecord.ClassInfo);

    for i := 0 to TDocVariantData(AJson).Count - 1 do
    begin
      LPropName := TDocVariantData(AJson).Names[i];

      for RecordProp in RecordType.GetProperties do
      begin
        if RecordProp.Name = LPropName then
        begin
          if RecordProp.PropertyType.TypeKind = System.TypInfo.tkEnumeration then
          begin

          end
          else
          if (RecordProp.PropertyType.TypeKind = System.TypInfo.tkInteger) or
            (RecordProp.PropertyType.TypeKind = System.TypInfo.tkInt64) then
          begin
            //TTimeLog = tkInt64이며
            if RecordProp.PropertyType.Name = 'TTimeLog' then
            begin
              LDate := TimeLogToDateTime(TDocVariantData(AJson).Values[i]);

              if LDate > EncodeDate(1900,1,1) then
                TDocVariantData(AJson).Values[i] := FormatDateTime('yyyy-mm-dd', LDate)
              else
                TDocVariantData(AJson).Values[i] := '';
            end
            else
            begin
//              TDocVariantData(AJson).Values[i] := IntToStr(TDocVariantData(AJson).Values[i]);
            end;
          end;
        end;//if
      end;//for
    end;

    TDocVariantData(Result).InitCopy(AJson, []);
  finally
    RecordCtx.Free;
  end;
end;

//AJson = {"Component Name": Value...} 형식임, 컴포넌트 이름이 같아야 함
procedure LoadData2FormFromJson(AJson: string; AForm: TComponent;
  ARemoveSuffix: Boolean; AIsUsePosFunc: Boolean);
var
  LDoc: TDocVariantData;
  LControl: TControl;
  ControlCtx: TRttiContext;
  ControlType: TRttiType;
  ControlProp: TRttiProperty;
  LControlValue: TMyValueProperty;
  LType: TRttiType;
  Value : TValue;
  LVar: variant;
  i,j: integer;
  LControlName, LCompNameOfJson: string;
begin
  LDoc.InitJSON(AJson);
  ControlCtx := TRttiContext.Create;
  try
    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);

      if LControl.Tag < 0 then
        Continue;

      LControlName := LControl.Name;

      if ARemoveSuffix then
      begin
        if ARemoveSuffix then
          LControlName := GetRemovedSuffixNameFromControl(LControl);
      end;

      if AIsUsePosFunc then
      begin
        j := GetNameIndexOfJson(LControlName, AJson, True);

        if j = -1 then
          Continue;
      end
      else
      begin
        j := LDoc.GetValueIndex(LControlName);

        if j < 0 then
          Continue;
      end;

      LVar := LDoc.Value[j];
//      LVar := LDoc.Value[LControl.Name];
      Value := Variant2TValue(LVar);

      LControlValue := GetNameOfValuePropNameNTypeFromControl(LControl); //Caption 또는 Text 또는 Value
      ControlType := ControlCtx.GetType(LControl.ClassInfo);
      ControlProp := ControlType.GetProperty(LControlValue.fValuePropName);

      if Assigned(ControlProp) then
      begin
        if ControlProp.PropertyType.TypeKind = System.TypInfo.tkEnumeration then
        begin
          if ControlProp.PropertyType.QualifiedName <> 'System.Boolean' then
          begin
            LType := ControlCtx.FindType(ControlProp.PropertyType.QualifiedName);  //QualifiedName = UnitName.TypeName

            if LType <> nil then
            begin
              Value := GetEnumValue(LType.Handle, Value.ToString);
            end;
          end;
        end
        else
        if (ControlProp.PropertyType.TypeKind = System.TypInfo.tkInteger) or
          (ControlProp.PropertyType.TypeKind = System.TypInfo.tkInt64) then
        begin//Integer는 TEdit로 입력 받아서 Integer Proporty 에 저장하기 위해서는 StrToInt Type Cast가 필요함
          //TTimeLog = tkInt64이며 JvDateTimePickerEdit는 TEdit를 상속함
          if ControlProp.PropertyType.Name = 'TTimeLog' then
          begin
            if (LControlValue.fValuePropName = 'Date') then
              Value := TimeLogToDateTime(Value.AsInt64);
          end
          else
          begin
            if (LControlValue.fValuePropName = 'Text') then
              Value := Value.ToString
            else
              Value := StrToIntDef(Value.ToString,-1);
          end;
        end;

        if LControl.ClassType = TAdvGroupBox then
          ControlProp.SetValue(TAdvGroupBox(LControl).CheckBox, Value)
        else
          ControlProp.SetValue(LControl, Value);
      end; //for
    end;
  finally
   ControlCtx.Free;
  end;
end;

function GetJsonFromForm(AForm: TComponent; ARemoveSuffix: Boolean): string;
var
  ControlCtx : TRttiContext;
  ControlType : TRttiType;
  ControlProp  : TRttiProperty;
  Value : TValue;
  LControl: TControl;
  i: integer;
  LControlValueName: string;
  LDoc: TDocVariantData;
begin
  LDoc.Init();
  ControlCtx := TRttiContext.Create;
  try
    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);

      LControlValueName := GetNameOfValuePropertyFromControl(LControl); //Caption 또는 Text 또는 Value
      ControlType := ControlCtx.GetType(LControl.ClassInfo);
      ControlProp := ControlType.GetProperty(LControlValueName);

      if Assigned(ControlProp) then
      begin
        if LControl.ClassType = TAdvGroupBox then
          Value := ControlProp.GetValue(TAdvGroupBox(LControl).CheckBox)
        else
          Value := ControlProp.GetValue(LControl);

        if ARemoveSuffix then
          LControlValueName := GetRemovedSuffixNameFromControl(LControl)
        else
          LControlValueName := LControl.Name;

        LDoc.AddValue(LControlValueName, Value.AsVariant);
      end;
    end;//for

    Result := LDoc.ToJSON();
  finally
    ControlCtx.Free;
  end;
end;

function GstJson2JsonArray(AJson: string): string;
var
//  LDoc: Variant;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
//  LDoc := AJson;
  LUtf8 := StringToUTF8(AJson);
  LDynArr.Add(LUtf8);
  Result := LDynArr.SaveToJSON;
end;

function GetNameIndexOfJson(ACompName, AJson: string; AIsUsePosFunc: Boolean): integer;
var
  LDoc: variant;
  i: integer;
  LJsonName: string;
begin
  Result := -1;
  LDoc := _JSON(AJson);

  for i := 0 to TDocVariantData(LDoc).Count - 1 do
  begin
    LJsonName := TDocVariantData(LDoc).Names[i];

    if AIsUsePosFunc then
    begin
      if POS(LJsonName, ACompName) > 0 then
      begin
        Result := i;
        Break;
      end;
    end
    else if LJsonName = ACompName then
    begin
      Result := i;
      Break;
    end;
  end;
end;

end.
