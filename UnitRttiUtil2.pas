unit UnitRttiUtil2;

interface

uses SysUtils,Classes, Rtti, TypInfo, Forms, Vcl.Controls,
  Delphi.Mocks.Helpers,
  mormot.core.base,
  mormot.core.variants,
  mormot.core.json,
  mormot.core.unicode,
  mormot.core.text,
  mormot.core.datetime,
  mormot.core.rtti,
  mormot.core.collections
  ;

{$TYPEINFO ON}
{$METHODINFO ON}

type
//  TRecordHlpr<T: record> = class
  TRecordHlpr<T> = class
  public
    {Usage:
      var
        rec: TMyRecord;
        s: string;
      begin
        s := TRecordHlpr<TMyRecord>.GetFields(rec);
      end;
    }
    class function GetFields(const ARec: T): string;
    //�ʵ���� ã�Ƽ� ���� �Ҵ� ��(String ���� �Ҵ� ������))
    //AFieldNameList = Field1;Field2...
    //AValueList = Value1;Value2...
    class procedure SetFieldValueByName(var ARec: T; AFieldNameList, AValueList: string);
    class procedure FromJson(const AJson: String; var ARec: T; AIsRemoveFirstChar: Boolean=False);
    class function ToJson(const ARec: T) : String;
    class function ToVariant(const ARec: T) : variant;
    class function GetSize(ARec: T): integer;
    class function GetFieldSize(ARec: T; AField: TRttiField): integer;
    class function ToArrayString(const ARec: T): TArray<string>;
    class function ToArrayInteger(const ARec: T): TArray<integer>;
    class function GetTypeKind(const ARec: T): TTypeKind;
    class function ToStringList(const ARec: T): TStringList;
    //AFieldNameList : Field Name�� ';'�� ���е�
    //AFieldNameList�� Name�� ��ġ�ϴ� Field�� ��ȯ��
    class function ToStringListByFieldNames(const ARec: T; AFieldNameList: string): TStringList;
    class function ToStringListByVariant(const ARec: T; AFieldNameList: variant): TStringList;

    procedure FromString(const FromValue: String);
    //��ȯ��: field Name=value;name=value;...
    function  ToString : String;
  end;

  TRecordHlpr2<T,S> = class
  {Usage:
    LArray := TRecordHlpr2<TStockChegeolRec, String>.ToArray(LKWRealTypeStockInfoRec.FStockChegeolRec);
  }
  public
    class function ToArray(const ARec: T): TArray<S>;
  end;

function ParamByNameAsString(
    const Params     : String;
    const ParamName  : String;
    var   Status     : Boolean;
    const DefValue   : String) : String;
function EscapeQuotes(const S: String) : String;

function IsEqualTypeKind(A,B: TTypeKind): Boolean;
function GetTypeInfoByName(ATypeName: string): PTypeInfo;
function GetTypeInfo2Name(AClass: TObject): string;
function GetTypeInfo2Class(AClass: TObject): TClass;
function SetToInt(const ASet; const ASize: integer): integer;
procedure IntToSet(const AValue: integer; var ASet; const ASize: integer);
function GetValue(var aValue : TValue) : String;
//TValue(aValue)�� ����� �Լ���
procedure SetValue(aData : String; var aValue : TValue; aTypeKind: TTypeKind = TTypeKind(0));
procedure GetValue2(var aValue: TValue; aTargetTypeKind: TTypeKind);
procedure SetValue2(aProp: TRttiProperty; var aValue : TValue);
//AClass�� APropertyName�� AData�� ������, Class Type Field�� SetClassPropertyValue()�� ����� ��
//ex : SetValue3(aButton, 'caption', 'Pressed');
function SetValueByPropertyName(AClass: TObject; AValue: TValue; APropertyName : String): TTypeKind;
function GetValueByPropertyName(AClass: TObject; APropertyName : String): TValue;
procedure SetClassPropertyValue(AClass, AData: TObject; APropertyName : String);
//Class Type�� ���� Edit Field Name ��ȯ
function GetEditFieldNameByClassName(ACompName: string): string;

procedure LoadRecordPropertyFromVariant(AClass: TObject; const ADoc: Variant; AIsPadFirstChar: Boolean=False);
//AIncludeID: True = ID �� ADoc�� ������
procedure LoadRecordPropertyToVariant(const AClass: TObject; var ADoc: Variant; AIsPadFirstChar: Boolean=False; AIsPropertyOnly: Boolean=False; AIncludeID: Boolean=False);
procedure PersistentCopy(const ASrc: TPersistent; var ADest: TPersistent);
procedure ObjectCopyWithRtti(const ASrc: TObject; var ADest: TObject);
procedure CreatePersistentAssignFile(const ASrc: TPersistent; AFileName: string);
function GetVariantFromProperty(const AClass: TObject; AIsPadFirstChar: Boolean=False; AIsPropertyOnly: Boolean=False): Variant;
//procedure LoadRecordPropertyFromVariant2(ARecType: TypeInfo; const ADoc: Variant);
function GetPropertyNameValueList(AObj: TObject; AIsOnlyPublished: Boolean=False): TStringList;
function GetPropertyCount(AObj: TObject; AIsOnlyPublished: Boolean=False): integer;
procedure LoadRecordFieldFromVariant(ATypeInfo, ARecPointer: Pointer; const ADoc: Variant; AIsPadFirstChar: Boolean=False); overload;
procedure LoadRecordFieldFromVariant(var ARec; ATypeInfo: PRttiInfo; const ADoc: Variant; AIsPadFirstChar: Boolean=False); overload;
function FindNSetCompValue(AParentControl: TComponent; const ACompName, APropName, AValue: string): Boolean;
function FindNGetCompStringValue(AParentControl: TComponent; ACompName, APropName: string): string;

function ExecuteMethodByClass(AClass : TClass; AMethodName : String; const AArgs: Array of TValue) : TValue;
//ex)
//procedure TestMethod(const value: string);
//.....
//var
//  LStr: string;
//  tv: array of TValue;
//begin
//  LStr := 'hello';
//  //SOInvoke(Self, 'TestMethod', SO('{value: "hello"}'));
//  SetLength(tv,1);
//  tv[0] := TValue.From(LStr);
//  ExecuteMethodByObject(Self, 'TestMethod', tv);
//}
function ExecuteMethodByObject(AObj : TObject; AMethodName : String; const AArgs: Array of TValue) : TValue;

//Form�� �ִ� {Component Name = Value} ������ Json���� ���c
//�� Component Hint = Value�� �ִ� Field ���� �Է��ؾ� ��(��: Text/Checked/ItemIndex)
function GetCompNameValue2JsonFromForm(AForm: TForm): string;
//Form�� �ִ� {Component Name = Value} ������ Json���� ���c
//�� Component Hint�� �������� �ʰ� Component.TypeKind�� Field���� �Ǵ���
//Grid�� Column Component�� Skip��
function GetCompNameValue2JsonFromFormByClassType(AForm: TForm): string;
function GetCompNameValue2JsonFromFrameByClassType(AFrame: TFrame; var ADict: IDocDict): string;
//AJson: {Component Name = Value} ���� -
//Form�� Component Hint = Value�� �ִ� Field ���� �Է� �Ǿ� �־�� ��(��: Text/Checked/ItemIndex)
function SetCompNameValueFromJson2Form(AForm: TForm; AJson: string): string;
//AJson: {Component Name = Value} ���� -
//�� Component Hint�� �������� �ʰ� Component.TypeKind�� Field���� �Ǵ���
function SetCompNameValueFromJson2FormByClassType(AForm: TForm; AJson: string): string;
function SetCompNameValueFromJson2FrameByClassType(AFrame: TFrame; ADict: IDocDict): string;

implementation

uses UnitStringUtil;

//function StrIsNumeric(s: string): Boolean;
//var
//  iValue, iCode: integer;
//begin
//  Val(s, iValue, iCode);
//  Result := iCode = 0;
//end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
// This will take an inut string having the format:
//  name1=value1;name2=value2;...
// Value may also be placed between double quotes if it contain spaces.
// Double quotes inside the value is escaped with a backslash
// Backslashes are double. See EscapeQuotes below.
function ParamByNameAsString(
    const Params     : String;
    const ParamName  : String;
    var   Status     : Boolean;
    const DefValue   : String) : String;
var
  I, J  : Integer;
  Ch    : Char;
begin
  Status := FALSE;
  I := 1;

  while I <= Length(Params) do
  begin
    J := I;

    while (I <= Length(Params)) and (Params[I] <> '=')  do
      Inc(I);

    if I > Length(Params) then
    begin
      Result := DefValue;
      Exit;                  // Not found
    end;

    if SameText(ParamName, Trim(Copy(Params, J, I - J))) then
    begin
      // Found parameter name, extract value
      Inc(I); // Skip '='

      if (I <= Length(Params)) and (Params[I] = '"') then
      begin
        // Value is between double quotes
        // Embedded double quotes and backslashes are prefixed
        // by backslash
        Status := TRUE;
        Result := '';
        Inc(I);        // Skip starting delimiter

        while I <= Length(Params) do
        begin
          Ch := Params[I];

          if Ch = '\' then
          begin
            Inc(I);          // Skip escape character

            if I > Length(Params) then
              break;

            Ch := Params[I];
          end
          else if Ch = '"' then
            break;

          Result := Result + Ch;
          Inc(I);
        end;
      end
      else
      begin
        // Value is up to semicolon or end of string
        J := I;

        while (I <= Length(Params)) and (Params[I] <> ';') do
          Inc(I);

        Result := Copy(Params, J, I - J);
        Status := TRUE;
      end;

      Exit;
    end;
    // Not good parameter name, skip to next
    Inc(I); // Skip '='

    if (I <= Length(Params)) and (Params[I] = '"') then
    begin
      Inc(I);        // Skip starting delimiter

      while I <= Length(Params) do
      begin
        Ch := Params[I];

        if Ch = '\' then
        begin
          Inc(I);          // Skip escape character

          if I > Length(Params) then
            break;
        end
        else if Ch = '"' then
          break;

        Inc(I);
      end;

      Inc(I);        // Skip ending delimiter
    end;
    // Param ends with ';'
    while (I <= Length(Params)) and (Params[I] <> ';')  do
      Inc(I);

    Inc(I);  // Skip semicolon
  end;
  Result := DefValue;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function EscapeQuotes(const S: String) : String;
begin
  // Easy but not best performance
  Result := StringReplace(S, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
end;

function IsEqualTypeKind(A,B: TTypeKind): Boolean;
begin
  Result := False;

  case A of
    tkWChar,
    tkLString,
    tkWString,
    tkString,
    tkChar,
    tkUString : Result := (B = tkWChar) or (B = tkLString) or (B = tkWString) or (B = tkString) or
      (B = tkChar) or (B = tkUString);
    tkInteger : Result := (B = tkInteger);
    tkInt64  : Result := (B = tkInt64);
    tkFloat  : Result := (B = tkFloat);
    tkEnumeration: Result := (B = tkEnumeration);
    tkSet: Result := (B = tkSet);
    else raise Exception.Create('Type not Supported');
  end;
end;

function GetTypeInfoByName(ATypeName: string): PTypeInfo;
var
  Ctx: TRttiContext;
  Typ: TRttiType;
begin
  Typ := nil;
  Typ := Ctx.FindType(ATypeName);
  if Assigned(Typ) then
    Result := Typ.Handle
  else
    Result := nil;
end;

function GetTypeInfo2Name(AClass: TObject): string;
var
  Ctx: TRttiContext;
  Typ: TRttiType;
begin
  Result := '';
  Typ := nil;

  ctx := TRttiContext.Create;
  try
    Typ := ctx.GetType(AClass.ClassInfo);
    Result := Typ.ToString;
  finally
    ctx.Free;
  end;
end;

function GetTypeInfo2Class(AClass: TObject): TClass;
var
  Ctx: TRttiContext;
  Typ: TRttiType;
begin
  Typ := nil;

  ctx := TRttiContext.Create;
  try
    Typ := ctx.GetType(AClass.ClassInfo);
    Result := Typ.ClassType;
  finally
    ctx.Free;
  end;
end;

function SetToInt(const ASet; const ASize: integer): integer;
begin
  Move(ASet, Result, ASize);
end;

procedure IntToSet(const AValue: integer; var ASet; const ASize: integer);
begin
  Move(AValue, ASet, ASize);
end;

function GetValue(var aValue : TValue) : String;
var
 I : Integer;
begin
   if aValue.Kind in [tkWChar, tkLString, tkWString, tkString, tkChar,
                    tkUString, tkInteger, tkInt64, tkFloat, tkEnumeration,
                    tkSet]  then
   result := aValue.ToString
   else raise Exception.Create('Type not Supported');
end;

procedure SetValue(aData: String; var aValue : TValue; aTypeKind: TTypeKind = TTypeKind(0));
var
 I : Integer;
 LKind: TTypeKind;
begin
  if aTypeKind <> TTypeKind(0) then
    LKind := aTypeKind
  else
    LKind := aValue.Kind;

  case LKind of
    tkWChar,
    tkLString,
    tkWString,
    tkString,
    tkChar,
    tkUString : aValue := aData;
    tkInteger : aValue := StrToIntDef(aData,0);
    tkInt64  : aValue := StrToInt64Def(aData,0);
    tkFloat  : aValue := StrToFloatDef(aData,0);
    tkEnumeration: begin
      i := StrToIntDef(aData, 0);

      if i = 0 then
        if (SysUtils.UpperCase(AData) = 'TRUE') or (SysUtils.UpperCase(AData) = 'FALSE') then
        begin
          i := Ord(StrToBoolDef(aData, False));
          aData := System.TypInfo.GetEnumName(aValue.TypeInfo,i);
        end;

//      if i <> -1 then //aData�� Enumeration ���� Interger�� ��ȯ�� String ���� ��
//      begin
//        aData := System.TypInfo.GetEnumName(aValue.TypeInfo,i);
      if StrIsNumeric(aData) then
        aValue := TValue.FromOrdinal(aValue.TypeInfo,Ord(StrToIntDef(aData,0)))
      else
        aValue := TValue.FromOrdinal(aValue.TypeInfo,GetEnumValue(aValue.TypeInfo,aData));
//      end;
    end;
    tkSet: begin
      i :=  StringToSet(aValue.TypeInfo,aData);
      TValue.Make(@i, aValue.TypeInfo, aValue);
    end;
    tkClass: begin
//      aValue := TValue.From(aData);
    end;
    else raise Exception.Create('Type not Supported');
  end;
end;

procedure GetValue2(var aValue: TValue; aTargetTypeKind: TTypeKind);
var
  I : Integer;
  LKind: TTypeKind;
  LStr: string;

//  procedure _GetValue(aTypeKind, aTargetTypeKind: TTypeKind);
//  begin
//    case aTypeKind of
//      tkWChar,
//      tkLString,
//      tkWString,
//      tkString,
//      tkChar,
//      tkUString : aValue.AsString;
//    end;
//  end;
begin
  LKind := aValue.Kind;

//  if LKind = aTargetTypeKind then
  if IsEqualTypeKind(LKind, aTargetTypeKind) then
    exit;

//  _GetValue(LKind, aTargetTypeKind);

    case aTargetTypeKind of
      tkWChar,
      tkLString,
      tkWString,
      tkString,
      tkChar,
      tkUString : aValue := IntToStr(aValue.AsInteger);
      tkInteger : aValue := StrToIntDef(aValue.AsString,0);
      tkInt64  : aValue := StrToInt64Def(aValue.AsString, 0);
      tkFloat  : aValue := StrToFloat(aValue.AsString);
      tkEnumeration: begin
        LStr := aValue.AsString;
        i := StrToIntDef(LStr,0);

        if i = 0 then
          if (SysUtils.UpperCase(LStr) = 'TRUE') or (SysUtils.UpperCase(LStr) = 'FALSE') then
            i := Ord(StrToBoolDef(LStr, False));

          LStr := System.TypInfo.GetEnumName(aValue.TypeInfo,i);
          aValue := TValue.FromOrdinal(aValue.TypeInfo,GetEnumValue(aValue.TypeInfo,LStr));
      end;
      tkSet: begin
        LStr := aValue.AsString;
        i :=  StringToSet(aValue.TypeInfo,LStr);
        TValue.Make(@i, aValue.TypeInfo, aValue);
      end;
      else raise Exception.Create('Type not Supported');
    end;
end;

//aProp: ������Ʈ �Ǵ� Object�� Field �Ӽ�(Property) - ex) Text or Caption
//aValue : aProp�� �Ҵ� �� TValue
procedure SetValue2(aProp: TRttiProperty; var aValue : TValue);
var
  I : Integer;
  LKind: TTypeKind;
  LStr: string;
begin
//  LKind := aValue.Kind;
  LKind := aProp.PropertyType.TypeKind;
  GetValue2(aValue, LKind);

//  if aValue.Kind <> LKind then
//  begin
//    case LKind of
//      tkWChar,
//      tkLString,
//      tkWString,
//      tkString,
//      tkChar,
//      tkUString : aValue := IntToStr(aValue.AsInteger);
//      tkInteger : aValue := aValue.AsInteger;
//      tkInt64  : aValue := aValue.AsInt64;
//      tkFloat  : aValue := aValue.AsExtended;
//      tkEnumeration: begin
//        LStr := aValue.AsString;
//        i := StrToIntDef(LStr,0);
//
//        if i = 0 then
//          if (SysUtils.UpperCase(LStr) = 'TRUE') or (SysUtils.UpperCase(LStr) = 'FALSE') then
//            i := Ord(StrToBoolDef(LStr, False));
//
//        LStr := System.TypInfo.GetEnumName(aValue.TypeInfo,i);
//        aValue := TValue.FromOrdinal(aValue.TypeInfo,GetEnumValue(aValue.TypeInfo,LStr));
//      end;
//      tkSet: begin
//        LStr := aValue.AsString;
//        i :=  StringToSet(aValue.TypeInfo,LStr);
//        TValue.Make(@i, aValue.TypeInfo, aValue);
//      end;
//      else raise Exception.Create('Type not Supported');
//    end;
//  end;
end;

function SetValueByPropertyName(AClass: TObject;  AValue: TValue; APropertyName : String): TTypeKind;
var
 ctx : TRttiContext;
 objType : TRttiType;
 Prop  : TRttiProperty;
 LValue : TValue;
 LObj: TObject;
begin
  Result := tkUnknown;

  ctx := TRttiContext.Create;

  try
    objType := ctx.GetType(AClass.ClassInfo);

    Prop := ObjType.GetProperty(APropertyName);

    if Assigned(Prop) then
    begin
      if Prop.IsWritable then
      begin
        LValue := Prop.GetValue(AClass);

        if LValue.Kind = tkClass then
        begin
          LObj := Prop.GetValue(AClass).AsObject;

          if LObj is TStrings then
            TStrings(LObj).Text := AValue.AsString;
        end
        else
        begin
          Prop.SetValue(AClass, AValue);
        end;

        Result := tkUnknown;//���� �Ҵ� �Ͽ����� tkUnknown�� ��ȯ�Ͽ� ���� �Ͽ����� �˸���.
      end;
    end;
  finally
    ctx.Free;
  end;
end;

function GetValueByPropertyName(AClass: TObject; APropertyName : String): TValue;
var
  ctx: TRttiContext;
  rttitype: TRttiType;
  rttiprop: TRttiProperty;
  LObj: TObject;
begin
  rttitype := ctx.GetType(AClass.ClassType);
  rttiprop := rttitype.GetProperty(APropertyName);

  if Assigned(rttiprop) then
  begin
    Result := rttiprop.GetValue(AClass);

    if Result.Kind = tkClass then
    begin
      LObj := rttiprop.GetValue(AClass).AsObject;

      if LObj is TStrings then
        Result := TStrings(LObj).Text;
    end;
  end;
end;

procedure SetClassPropertyValue(AClass, AData: TObject; APropertyName : String);
var
 ctx : TRttiContext;
 objType : TRttiType;
 Prop  : TRttiProperty;
 Value, Value2 : TValue;
 LObj: TObject;
// LObj: TClass;
begin
  ctx := TRttiContext.Create;

  try
    objType := ctx.GetType(AClass.ClassInfo);

    for Prop in objType.GetProperties do
    begin
      if not Prop.IsWritable then
        continue;

      if Prop.Visibility <> mvPublished then
        Continue;

      if Prop.Name = APropertyName then
      begin
        //Property Field Address ������
        Value := Prop.GetValue(AClass);
        Value2 := TValue.From(AData);

//        if Value.Kind = tkClass then
//        begin
          LObj := Prop.GetValue(AClass).AsObject;

          if (Assigned(LObj) or Assigned(Adata)) then
            if not Value.Equals(Value2) then
//            Prop.SetValue(LObj, TValue.From(AData));
              Prop.SetValue(AClass, Value2);
//        end;

        Break;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

function GetEditFieldNameByClassName(ACompName: string): string;
begin
  if ACompName = 'TEdit' then
    Result := 'Text'
  else
  if (ACompName = 'TDateTimePicker') or (ACompName = 'TAdvDateTimePicker') then
    Result := 'DateTime'
  else
  if ACompName = 'TMemo' then
    Result := 'Text'
  else
  if ACompName = 'TComboBox' then
    Result := 'ItemIndex'
  else
  if ACompName = 'TAdvOfficeCheckGroup' then
    Result := 'Value'
  else
  if ACompName = 'TComboBoxInc' then
    Result := 'ItemIndex'
  else
  if ACompName = 'TCheckBox' then
    Result := 'Checked'
  else
  if ACompName = 'TAdvEditBtn' then
    Result := 'Text'
  else
  if ACompName = 'TNxButtonEdit' then
    Result := 'Text'
  else
    Result := '';
end;

procedure LoadRecordPropertyFromVariant(AClass: TObject; const ADoc: Variant; AIsPadFirstChar: Boolean);
var
 ctx : TRttiContext;
 objType : TRttiType;
 Field : TRttiField;
 Prop  : TRttiProperty;
 Value : TValue;
 Data, LPropName : String;
// LVar: variant;
begin
  ctx := TRttiContext.Create;
  try
    objType := ctx.GetType(AClass.ClassInfo);

    for Prop in objType.GetProperties do
    begin
      if not Prop.IsWritable then
        continue;

      if Prop.Visibility <> mvPublished then
        Continue;

      LPropName := Prop.Name;

      if (LPropName = 'IDValue') or (LPropName = 'InternalState') then
        continue;

      if AIsPadFirstChar then
        Insert('F', LPropName,1);

      //LPropName�� ADoc Name�� �����ϸ� Update
      if TDocVariantData(ADoc).Exists(LPropName) then
      begin
        //Enumeration ���� ���� ��Ʈ������ ��ȯ�� ���̾�� ��
        Data := TDocVariantData(ADoc).GetValueOrEmpty(LPropName);
        //Property Field Address ������
        Value := Prop.GetValue(AClass);
        //Field Value�� Data�� Assign��
        SetValue(Data, Value);
        Prop.SetValue(AClass,Value);
      end;
    end;
  finally
    ctx.Free;
  end;
end;

procedure LoadRecordPropertyToVariant(const AClass: TObject; var ADoc: Variant;
  AIsPadFirstChar: Boolean; AIsPropertyOnly: Boolean; AIncludeID: Boolean);
var
 ctx : TRttiContext;
 objType : TRttiType;
 Field : TRttiField;
 Prop  : TRttiProperty;
 Value : TValue;
 LPropName : String;
 LResult: Boolean;
begin
  ctx := TRttiContext.Create;
  try
    objType := ctx.GetType(AClass.ClassInfo);

    for Prop in objType.GetProperties do
    begin
      if not (AIncludeID and (Prop.Name = 'ID'))then
      begin
        if not Prop.IsWritable then
          continue;

        if Prop.Visibility <> mvPublished then
          Continue;
      end;

      LPropName := Prop.Name;

      //"array of TSQLGSFileRec" type�� Skip��(Field��: Attachments)
      if (LPropName = 'IDValue') or (LPropName = 'InternalState') or
         (LPropName = 'Attachments') then
        continue;

      if AIsPadFirstChar then
        Insert('F', LPropName,1);

      //Value�� �����ϰ� Property(�Ӽ�)�� ADoc�� ������
      if AIsPropertyOnly then
      begin
        TDocVariantData(ADoc).Value[LPropName] := '';
      end
      else
      begin
        if LPropName = 'ID' then
          LPropName := 'RowID';

        Value := Prop.GetValue(AClass);

        //tkSet Type�� value.AsVariant���� ���� ���� (type cast error �߻���)
        if Prop.PropertyType.TypeKind = tkSet then
        begin

        end
        else if Prop.PropertyType.TypeKind = tkEnumeration then
        begin
//          if Value.TryAsType<Boolean>(LResult) then
//            TDocVariantData(ADoc).Value[LPropName] := Value.AsInt64
          if Value.TypeInfo = TypeInfo(Boolean) then
            TDocVariantData(ADoc).Value[LPropName] := Value.AsBoolean
          else
          begin
            TDocVariantData(ADoc).Value[LPropName] := GetEnumValue(Value.TypeInfo, Value.ToString);//Value.TypeInfo.Name;
          end;
        end
        else
          TDocVariantData(ADoc).Value[LPropName] := Value.AsVariant;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

procedure PersistentCopy(const ASrc: TPersistent; var ADest: TPersistent);
var
 ctx : TRttiContext;
 objType : TRttiType;
 Field : TRttiField;
 Prop  : TRttiProperty;
 Value : TValue;
 Data, LPropName : String;
begin
  ctx := TRttiContext.Create;
  try
    objType := ctx.GetType(ASrc.ClassInfo);

    for Prop in objType.GetProperties do
    begin
      if Prop.Name = '' then
        continue;

      if not Prop.IsWritable then
        continue;

      if Prop.Visibility <> mvPublished then
        Continue;

      //Property Field Address ������
      Value := Prop.GetValue(ASrc);
      Prop.SetValue(ADest,Value);
    end;

  finally
    ctx.Free;
  end;
end;

procedure ObjectCopyWithRtti(const ASrc: TObject; var ADest: TObject);
begin

end;

procedure CreatePersistentAssignFile(const ASrc: TPersistent; AFileName: string);
//TPersistent Assign ������ ������
var
 ctx : TRttiContext;
 objType : TRttiType;
 Field : TRttiField;
 Prop  : TRttiProperty;
 Value : TValue;
 Data, LPropName : String;
 LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  LStrList.Add('//***This file is created auto by UnitRttiUtil.CreatePersistentAssignFile() ***' + #13#10);

  ctx := TRttiContext.Create;
  try
    objType := ctx.GetType(ASrc.ClassInfo);

    for Prop in objType.GetProperties do
    begin
      if not Prop.IsWritable then
        continue;

      if (Prop.Visibility <> mvPublished) then//and (Prop.Visibility <> mvPublic)
        Continue;

      LPropName := Prop.Name;
      Data := LPropName + ' := ' + ASrc.ClassName + '(Source).' + LPropName + ';';    // TEngineParameterItem
      LStrList.Add(Data);
    end;

    LStrLIst.SaveToFile(AFileName);
  finally
    ctx.Free;
    LStrList.Free;
  end;

end;

//procedure LoadRecordPropertyFromVariant2(ARecType: TypeInfo; const ADoc: Variant);
//var
//  LContext: TRttiContext;
//  LRecord: TRttiRecordType;
//  LField: TRttiField;
//  LFldName: string;
//  LValue: TValue;
//begin
//  LContext := TRttiContext.Create;
//  try
//    LRecord := LContext.GetType(TypeInfo(ARecType)).AsRecord;
//    for LField in LRecord.GetFields do
//    begin
//      LFldName := LField.Name;
//      LValue := LField.GetValue();
//    end;
//  finally
//    LContext.Free;
//  end;
//end;

{ TRecordHlpr<T> }

class procedure TRecordHlpr<T>.FromJson(const AJson: String; var ARec: T; AIsRemoveFirstChar: Boolean);
var
  ndx: integer;
  LDoc, LVar: variant;
  LValue    : TValue;
  LContext  : TRttiContext;
//  LRecord   : TRttiRecordType;
  LField    : TRttiField;
  LStrData, LFieldName  : String;
begin
  if AJson = '' then
      Exit;

  LDoc := _Json(StringToUtf8(AJson));
  LContext := TRttiContext.Create;
  try
//    LRecord := LContext.GetType(TypeInfo(T)).AsRecord;

    with _Safe(LDoc)^ do //note ^ to de-reference into TDocVariantData
    begin
      for LField in LContext.GetType(TypeInfo(T)).GetFields do
      begin
        LFieldName := LField.Name;

        if AIsRemoveFirstChar then
          System.Delete(LFieldName, 1, 1);

        ndx := GetValueIndex(LFieldName);

        if ndx >= 0 then
        begin
          LStrData := GetValueOrEmpty(LFieldName);
          LValue := LField.GetValue(@ARec);
          SetValue(LStrData, LValue);
          LField.SetValue(@ARec,LValue);
        end;
      end;
    end;
  finally
    LContext.Free;
  end;
end;

procedure TRecordHlpr<T>.FromString(const FromValue: String);
var
  Status    : Boolean;
  Value     : String;
  AValue    : TValue;
  AContext  : TRttiContext;
  ARecord   : TRttiRecordType;
  AField    : TRttiField;
  AFldName  : String;
begin
  if FromValue = '' then
      Exit;

  // We use RTTI to iterate thru all fields of THdr and use each field name
  // to get field value from metadata string and then set value into Hdr.
  AContext := TRttiContext.Create;
  try
    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;

    for AField in ARecord.GetFields do
    begin
      AFldName := AField.Name;
      Value    := ParamByNameAsString(FromValue, AFldName, Status, '0');

      if Status then
      begin
        try
          case AField.FieldType.TypeKind of
          tkFloat:               // Also for TDateTime !
            begin
              if Pos('/', Value) >= 1 then
                AValue := StrToDateTime(Value)
              else
                AValue := StrToFloat(Value);

              AField.SetValue(@Self, AValue);
            end;
          tkInteger:
            begin
              AValue := StrToInt(Value);
              AField.SetValue(@Self, AValue);
            end;
          tkUString:
            begin
              AValue := Value;
              AField.SetValue(@Self, AValue);
            end;
          // You should add other types as well
          end;
        except
            // Ignore any exception here. Likely to be caused by
            // invalid value format
        end;
      end
      else begin
          // Do whatever you need if the string lacks a field
          // For example clear the field, or just do nothing
      end;
    end;
  finally
    AContext.Free;
  end;
end;

class function TRecordHlpr<T>.GetFieldSize(ARec: T; AField: TRttiField): integer;
begin
  case AField.FieldType.TypeKind of
    tkLString,
    tkWString,
    tkString,
    tkUString : Result := Length(AField.GetValue(@ARec).AsString);
  else
    Result := SizeOf(AField.GetValue(@ARec).DataSize);
//      tkInteger :
//      tkInt64  : aValue := StrToInt64Def(aValue.AsString, 0);
//      tkFloat  : aValue := StrToFloat(aValue.AsString);
//      tkEnumeration: begin
//        LStr := aValue.AsString;
//        i := StrToIntDef(LStr,0);
//
//        if i = 0 then
//          if (SysUtils.UpperCase(LStr) = 'TRUE') or (SysUtils.UpperCase(LStr) = 'FALSE') then
//            i := Ord(StrToBoolDef(LStr, False));
//
//          LStr := System.TypInfo.GetEnumName(aValue.TypeInfo,i);
//          aValue := TValue.FromOrdinal(aValue.TypeInfo,GetEnumValue(aValue.TypeInfo,LStr));
//      end;
//      tkSet: begin
//        LStr := aValue.AsString;
//        i :=  StringToSet(aValue.TypeInfo,LStr);
//        TValue.Make(@i, aValue.TypeInfo, aValue);
//      end;
//      else raise Exception.Create('Type not Supported');
  end;
end;

class function TRecordHlpr<T>.GetFields(const ARec: T): string;
var
  LContext: TRttiContext;
  LType: TRttiType;
  LField: TRttiField;
begin
  Result := '';
  LContext := TRttiContext.Create;

  for LField in LContext.GetType(TypeInfo(T)).GetFields do
  begin
    LType := LField.FieldType;
    Result := Result + '|' + Format('Field: %s, Type: %s, Value: %s',
      [LField.Name, LField.FieldType.Name, LField.GetValue(@ARec).AsString]);
  end;
end;

class function TRecordHlpr<T>.GetSize(ARec: T): integer;
var
  LContext: TRttiContext;
  LType: TRttiType;
  LField: TRttiField;
  LDataSize: integer;
begin
  Result := 0;
  LContext := TRttiContext.Create;
  try
    for LField in LContext.GetType(TypeInfo(T)).GetFields do
    begin
      LDataSize := GetFieldSize(ARec, LField);
      Result := Result + LDataSize;
    end;
  finally
    LContext.Free;
  end;
end;

class function TRecordHlpr<T>.GetTypeKind(const ARec: T): TTypeKind;
var
  LContext: TRttiContext;
begin
  LContext := TRttiContext.Create;
  try
    Result := LContext.GetType(TypeInfo(T)).TypeKind;
  finally
    LContext.Free;
  end;
end;

class procedure TRecordHlpr<T>.SetFieldValueByName(var ARec: T;
  AFieldNameList, AValueList: string);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LField: TRttiField;
  LFieldName, LValue: string;
  I: integer;
begin
  LContext := TRttiContext.Create;

  while AFieldNameList <> ''  do
  begin
    I:=Pos(';', AFieldNameList);

    if I<>0 then
    begin
      LFieldName:=System.Copy(AFieldNameList,1,I-1);
      System.Delete(AFieldNameList,1,I);
    end else
    begin
      LFieldName:=AFieldNameList;
      AFieldNameList:='';
    end;

    I:=Pos(';', AValueList);

    if I<>0 then
    begin
      LValue:=System.Copy(AValueList,1,I-1);
      System.Delete(AValueList,1,I);
    end else
    begin
      LValue:=AValueList;
      AValueList:='';
    end;

    for LField in LContext.GetType(TypeInfo(T)).GetFields do
    begin
      if LField.Name = LFieldName then
      begin
        LField.SetValue(@ARec, TValue.From(LValue));
        Break;
      end;
    end;
  end;
end;

class function TRecordHlpr<T>.ToArrayInteger(const ARec: T): TArray<integer>;
begin
  Result := TRecordHlpr2<T, integer>.ToArray(ARec);
end;

class function TRecordHlpr<T>.ToArrayString(const ARec: T): TArray<string>;
begin
  Result := TRecordHlpr2<T, string>.ToArray(ARec);
end;

class function TRecordHlpr<T>.ToJson(const ARec: T): String;
begin
  Result := Utf8ToString(RecordSaveJson(ARec, TypeInfo(T)));
end;

function TRecordHlpr<T>.ToString: String;
var
  AContext  : TRttiContext;
  AField    : TRttiField;
  ARecord   : TRttiRecordType;
  AFldName  : String;
  AValue    : TValue;
begin
  Result := '';
  AContext := TRttiContext.Create;
  try
    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;

    for AField in ARecord.GetFields do
    begin
      AFldName := AField.Name;
      AValue := AField.GetValue(@Self);
      Result := Result + AFldName + '="' +
                EscapeQuotes(AValue.ToString) + '";';
    end;
  finally
    AContext.Free;
  end;
end;

class function TRecordHlpr<T>.ToStringList(const ARec: T): TStringList;
var
  AContext  : TRttiContext;
  AField    : TRttiField;
  ARecord   : TRttiRecordType;
  AFldName  : String;
  AValue    : TValue;
begin
  Result := TStringList.Create;

  AContext := TRttiContext.Create;
  try
    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;

    for AField in ARecord.GetFields do
    begin
      AFldName := AField.Name;
      AValue := AField.GetValue(@ARec);
      Result.Add(AFldName + '=' + AValue.ToString);
    end;
  finally
    AContext.Free;
  end;
end;

class function TRecordHlpr<T>.ToStringListByFieldNames(const ARec: T;
  AFieldNameList: string): TStringList;
var
  AContext  : TRttiContext;
  AField    : TRttiField;
  ARecord   : TRttiRecordType;
  AFldName  : String;
  AValue    : TValue;
  LStr: string;
  I: Word;
begin
  Result := TStringList.Create;

  if AFieldNameList = '' then
    exit;

  AContext := TRttiContext.Create;
  try
    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;

    while AFieldNameList <> '' do
    begin
      I:=Pos(';', AFieldNameList);

      if I<>0 then
      begin
        LStr:=System.Copy(AFieldNameList,1,I-1);
        System.Delete(AFieldNameList,1,I);
      end else
      begin
        LStr := AFieldNameList;
        AFieldNameList :='';
      end;

      for AField in ARecord.GetFields do
      begin
        AFldName := AField.Name;

        if AFldName = LStr then
        begin
          AValue := AField.GetValue(@ARec);
          Result.Add(AFldName + '=' + AValue.ToString);
        end;
      end;
    end;
  finally
    AContext.Free;
  end;
end;

class function TRecordHlpr<T>.ToStringListByVariant(const ARec: T;
  AFieldNameList: variant): TStringList;
var
  AContext  : TRttiContext;
  AField    : TRttiField;
  ARecord   : TRttiRecordType;
  AFldName  : String;
  AValue    : TValue;
  LStr: string;
  i: Word;
begin
  Result := TStringList.Create;

  if TDocVariantData(AFieldNameList).Count = 0 then
    exit;

  AContext := TRttiContext.Create;
  try
    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;

    for i := 0 to TDocVariantData(AFieldNameList).Count - 1 do
    begin
      LStr := TDocVariantData(AFieldNameList).Names[i];

      for AField in ARecord.GetFields do
      begin
        AFldName := AField.Name;

        if AFldName = LStr then
        begin
          AValue := AField.GetValue(@ARec);
          Result.Add(AFldName + '=' + AValue.ToString);
          Break;
        end;
      end;
    end;
  finally
    AContext.Free;
  end;
end;

class function TRecordHlpr<T>.ToVariant(const ARec: T): variant;
var
  ndx: integer;
  LDoc, LVar: variant;
  LValue    : TValue;
  LContext  : TRttiContext;
//  LRecord   : TRttiRecordType;
  LField    : TRttiField;
  LStrData  : String;
begin
  TDocVariant.New(Result);
  LContext := TRttiContext.Create;
  try
    for LField in LContext.GetType(TypeInfo(T)).GetFields do
    begin
//      if LField.FieldType <> tkRecord then
      if not ((LField.FieldType.IsRecord) or (LField.FieldType.IsSet))then
      begin
        //EPItem.MultiStateValues�� array of char �̸� �̶����� ���� ���� ȸ�ǿ�
        if Assigned(LField.FieldType) then
        begin
          LValue := LField.GetValue(@ARec);
          TDocVariantData(Result).Value[LField.Name] := LValue.AsVariant;
        end;
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function GetVariantFromProperty(const AClass: TObject; AIsPadFirstChar: Boolean=False; AIsPropertyOnly: Boolean=False): Variant;
begin
  TDocVariant.New(Result);
  LoadRecordPropertyToVariant(AClass, Result, AIsPadFirstChar, AIsPropertyOnly);
end;

function GetPropertyNameValueList(AObj: TObject; AIsOnlyPublished: Boolean): TStringList;
var //Name=Value�� ��ȯ��
  ctx: TRttiContext;
  rt: TRttiType;
  Prop: TRttiProperty;
//  Value: TValue;
begin
  Result := TStringList.Create;
  ctx := TRttiContext.Create;
  try
    rt := ctx.GetType(AObj.ClassType);

    for prop in rt.GetProperties do
    begin
      if (AIsOnlyPublished) and (Prop.Visibility <> mvPublished) then
        Continue;

      Result.Add(prop.Name + '=' + prop.GetValue(AObj).ToString);
    end;
  finally
    ctx.Free;
  end;
end;

function GetPropertyCount(AObj: TObject; AIsOnlyPublished: Boolean=False): integer;
var
  ctx: TRttiContext;
  rt: TRttiType;
  Prop: TRttiProperty;
begin
  Result := 0;
  ctx := TRttiContext.Create;
  try
    rt := ctx.GetType(AObj.ClassType);

    for prop in rt.GetProperties do
    begin
      if (AIsOnlyPublished) and (Prop.Visibility <> mvPublished) then
        Continue;

      Inc(Result);
    end;
  finally
    ctx.Free;
  end;
end;

procedure LoadRecordFieldFromVariant(var ARec; ATypeInfo: PRttiInfo;
  const ADoc: Variant; AIsPadFirstChar: Boolean=False);
var
  rttiContext: TRttiContext;
  rttiType: TRttiType;
  LField : TRTTIField;
  Value : TValue;
  LVar: variant;
//  LStr: string;
begin
  rttiType := rttiContext.GetType(ATypeInfo);//TypeInfo(THiMECSMenuRecord));

  for LField in rttiType.GetFields do
  begin
    if LField.FieldType.TypeKind <> tkMethod then
    begin
//      Value := LField.GetValue(@ARec);
//      Value := Value.FromVariant(TDocVariantData(ADoc).Value[LField.Name]);
//      LStr := TDocVariantData(ADoc).Value[LField.Name];
      LVar := TDocVariantData(ADoc).GetValueOrEmpty(LField.Name);
      Value := TValue.FromVariant(LVar);
      LField.SetValue(@ARec, Value);
//      TDocVariantData(ADoc).Value[LField.Name] := Value.AsVariant;
    end;
  end;
end;

procedure LoadRecordFieldFromVariant(ATypeInfo, ARecPointer: Pointer; const ADoc: Variant; AIsPadFirstChar: Boolean=False); overload;
var
  rttiContext: TRttiContext;
  rttiType: TRttiType;
  LField : TRTTIField;
  Value : TValue;
begin
  rttiType := rttiContext.GetType(ATypeInfo);//TypeInfo(THiMECSMenuRecord));

  for LField in rttiType.GetFields do
  begin
    Value := LField.GetValue(ARecPointer);
    TDocVariantData(ADoc).Value[LField.Name] := Value.AsVariant;
  end;
end;

function FindNSetCompValue(AParentControl: TComponent; const ACompName, APropName, AValue: string): Boolean;
var
  LComp, LComp2: TComponent;
  LTypeKind: TTypeKind;
begin
  Result := False;
  LComp := AParentControl.FindComponent(ACompName);

  if Assigned(LComp) then
  begin
    LTypeKind := SetValueByPropertyName(TObject(LComp), AValue, APropName);

    //SetValue�� ������ ���(tkClass �� ���)
    if LTypeKind = tkClass then
    begin
      //AValue�� Component�� ����Ű�Ƿ� Form���� �˻���
      LComp2 := AParentControl.FindComponent(AValue);

      //nil�� �Ҵ��� ���
      if AValue = '' then
        SetClassPropertyValue(TObject(LComp), nil, APropName)
      else
      if Assigned(LComp2) then
      begin
        SetClassPropertyValue(TObject(LComp), TObject(LComp2), APropName);
      end;
    end;

    Result := True;
  end;
end;

function FindNGetCompStringValue(AParentControl: TComponent; ACompName, APropName: string): string;
var
  LComp: TComponent;
  LValue: TValue;
begin
  Result := '';
  LComp := AParentControl.FindComponent(ACompName);

  if Assigned(LComp) then
  begin
    LValue := GetValueByPropertyName(TObject(LComp), APropName);
    Result := GetValue(LValue);
  end;
end;

function ExecuteMethodByClass(AClass : TClass; AMethodName : String; const AArgs: Array of TValue) : TValue;
var
//  RttiContext : TRttiContext;
//  RttiMethod  : TRttiMethod;
//  RttiType    : TRttiType;
  RttiObject  : TObject;
begin
  RttiObject := AClass.Create;
  try
    Result := ExecuteMethodByObject(RttiObject, AMethodName, AArgs);
//    RttiContext := TRttiContext.Create;
//    RttiType    := RttiContext.GetType(AClass);
//    RttiMethod  := RttiType.GetMethod(AMethodName);
//    Result      := RttiMethod.Invoke(RttiObject,AArgs);
  finally
    RttiObject.Free;
  end;
end;

//AArgs := TValue.From();
function ExecuteMethodByObject(AObj : TObject; AMethodName : String; const AArgs: Array of TValue) : TValue;
var
  RttiContext : TRttiContext;
  RttiMethod  : System.Rtti.TRttiMethod;
  RttiType    : TRttiType;
begin
  if Assigned(AObj) then
  begin
    RttiContext := TRttiContext.Create;
    RttiType    := RttiContext.GetType(AObj.ClassType);
    RttiMethod  := RttiType.GetMethod(AMethodName);
    Result      := RttiMethod.Invoke(AObj,AArgs);
  end;
end;

{ TRecordHlpr2<T, S> }

class function TRecordHlpr2<T, S>.ToArray(const ARec: T): TArray<S>;
var
  LIdx: integer;
  LValue    : TValue;
  LContext  : TRttiContext;
//  LRecord   : TRttiRecordType;
  LField    : TRttiField;
  LFields: TArray<TRttiField>;
//  LKind: TTypeKind;
//  LStrData, LFieldName  : String;
begin
  LContext := TRttiContext.Create;
  try
//    LRecord := LContext.GetType(TypeInfo(T)).AsRecord;
    LFields := LContext.GetType(TypeInfo(T)).GetFields;

    SetLength(Result, High(LFields));
    LIdx := 0;

    for LField in LFields do
    begin
//      LFieldName := LField.Name;
      LValue := LField.GetValue(@ARec);

//      if LField.FieldType.TypeKind = tkString then
        Result[LIdx] := LValue.AsType<S>;
//      else
//      if LField.FieldType.TypeKind = tkInteger then
//        Result[LIdx] := LValue.AsInteger;

      Inc(LIdx);
    end;
  finally
    LContext.Free;
  end;
end;

//Component Date = TDateTime, Record Field Type = TTimeLog ���� �Ʒ� �Լ��� �������� �۵���
function GetCompNameValue2JsonFromForm(AForm: TForm): string;
var
  i: integer;
  LComp: TComponent;
  LDict: IDocDict;
  LValue: TValue;
  LDate: Double;
begin
  Result := '';
  LDict := DocDict('{}');

  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      LComp := AForm.Components[i];

      //Component Hint�� Value Field Name�� �־�� ��
      if TControl(LComp).Hint = '' then
        Continue;

      LValue := GetValueByPropertyName(TObject(LComp), TControl(LComp).Hint);

      // Check the type of value and handle accordingly
      case LValue.Kind of
        tkString, tkLString, tkWString, tkUString: LDict.S[LComp.Name] := LValue.AsString;
        tkInteger, tkInt64: LDict.I[LComp.Name] := LValue.AsInteger;
        tkEnumeration: LDict.B[LComp.Name] := LValue.AsBoolean;
        tkFloat: begin
          LDate := LValue.AsDouble;
          LDict.I[LComp.Name] := TimeLogFromDateTime(LDate);
        end;
      end;
      if LValue.Kind = tkString then
      begin

      end
      else if LValue.Kind = tkInteger then
      begin

      end;
    end;
  end;

  Result := Utf8ToString(LDict.ToJson(jsonUnquotedPropNameCompact));
end;

//Component Date = TDateTime, Record Field Type = TTimeLog ���� �Ʒ� �Լ��� �������� �۵���
function GetCompNameValue2JsonFromFormByClassType(AForm: TForm): string;
var
  i: integer;
  LComp: TComponent;
  LDict: IDocDict;
  LValue: TValue;
  LDate: Double;
  LFieldName: string;
begin
  Result := '';
  LDict := DocDict('{}');

  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      LComp := Components[i];

      if LComp.ClassType.InheritsFrom(TFrame) then
      begin
        GetCompNameValue2JsonFromFrameByClassType(TFrame(LComp), LDict);
        Continue;
      end;

      LFieldName := GetEditFieldNameByClassName(TControl(LComp).ClassName);

      if LFieldName = '' then
        Continue;

      LValue := GetValueByPropertyName(TObject(LComp), LFieldName);

      case LValue.Kind of
        tkString, tkLString, tkWString, tkUString: LDict.S[LComp.Name] := LValue.AsString;
        tkInteger, tkInt64: LDict.I[LComp.Name] := LValue.AsInteger;
        tkEnumeration: LDict.B[LComp.Name] := LValue.AsBoolean;
        tkFloat: begin
          LDate := LValue.AsDouble;
          LDict.I[LComp.Name] := TimeLogFromDateTime(LDate);
        end;
      end;
      if LValue.Kind = tkString then
      begin

      end
      else if LValue.Kind = tkInteger then
      begin

      end;
    end;
  end;

  Result := Utf8ToString(LDict.ToJson(jsonUnquotedPropNameCompact));
end;

function GetCompNameValue2JsonFromFrameByClassType(AFrame: TFrame; var ADict: IDocDict): string;
var
  i: integer;
  LComp: TComponent;
  LValue: TValue;
  LDate: Double;
  LFieldName: string;
begin
  with AFrame do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      LComp := Components[i];

      LFieldName := GetEditFieldNameByClassName(TControl(LComp).ClassName);

      if LFieldName = '' then
        Continue;

      LValue := GetValueByPropertyName(TObject(LComp), LFieldName);

      case LValue.Kind of
        tkString, tkLString, tkWString, tkUString: ADict.S[LComp.Name] := LValue.AsString;
        tkInteger, tkInt64: ADict.I[LComp.Name] := LValue.AsInteger;
        tkEnumeration: ADict.B[LComp.Name] := LValue.AsBoolean;
        tkFloat: begin
          LDate := LValue.AsDouble;
          ADict.I[LComp.Name] := TimeLogFromDateTime(LDate);
        end;
      end;
      if LValue.Kind = tkString then
      begin

      end
      else if LValue.Kind = tkInteger then
      begin

      end;
    end;
  end;
end;

function SetCompNameValueFromJson2Form(AForm: TForm; AJson: string): string;
var
  i: integer;
  LComp: TComponent;
  LDict: IDocDict;
//  LVar: Variant;
  LValue: TValue;
  LUtf8: RawUtf8;
  LDate: TDate;
  LTimeLog: TTimeLog;
begin
  LUtf8 := StringToUtf8(AJson);
//  LVar := TDocVariant.NewJson(LUtf8);
  LDict := DocDict(LUtf8);
  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      LComp := AForm.Components[i];

      //Component Hint�� Value Field Name�� �־�� ��
      if TControl(LComp).Hint = '' then
        Continue;

      if LDict.Exists(LComp.Name) then
      begin
        LValue := GetValueByPropertyName(TObject(LComp), TControl(LComp).Hint);

        // Check the type of value and handle accordingly
        case LValue.Kind of
          tkString, tkLString, tkWString, tkUString: LValue := TValue.From(LDict.S[LComp.Name]);
          tkInteger, tkInt64: LValue := TValue.From(StrToIntDef(LDict.S[LComp.Name],0));
          tkEnumeration: LValue := TValue.From(LDict.B[LComp.Name]);
          tkFloat: begin
            LTimeLog := LDict.I[LComp.Name]; //Json Field Type�� �ݵ�� TTimeLog ���� ��
            LDate := TimeLogToDateTime(LTimeLog);
            LValue := TValue.From(LDate);
          end;
        end;

        SetValueByPropertyName(TObject(LComp), LValue, TControl(LComp).Hint);
      end;
    end;//for
  end;//with
end;

function SetCompNameValueFromJson2FormByClassType(AForm: TForm; AJson: string): string;
var
  i: integer;
  LComp: TComponent;
  LDict: IDocDict;
  LValue: TValue;
  LUtf8: RawUtf8;
  LDate: TDate;
  LTimeLog: TTimeLog;
  LFieldName, LStr: string;
begin
  LUtf8 := StringToUtf8(AJson);
  LDict := DocDict(LUtf8);

  with AForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      LComp := AForm.Components[i];

      if LComp.ClassType.InheritsFrom(TFrame) then
      begin
        SetCompNameValueFromJson2FrameByClassType(TFrame(LComp), LDict);
        Continue;
      end;

      LFieldName := GetEditFieldNameByClassName(TControl(LComp).ClassName);

      if LFieldName = '' then
        Continue;

      if LDict.Exists(LComp.Name) then
      begin
        LValue := GetValueByPropertyName(TObject(LComp), LFieldName);

        case LValue.Kind of
          tkString, tkLString, tkWString, tkUString: begin
            LStr := LDict[LComp.Name];//LDict.S[LComp.Name]
            LValue := TValue.From(LStr);
          end;
          tkInteger, tkInt64: LValue := TValue.From(StrToIntDef(LDict.S[LComp.Name],0));
          tkEnumeration: LValue := TValue.From(LDict.B[LComp.Name]);
          tkFloat: begin
            LTimeLog := LDict.I[LComp.Name]; //Json Field Type�� �ݵ�� TTimeLog ���� ��
            LDate := TimeLogToDateTime(LTimeLog);
            LValue := TValue.From(LDate);
          end;
        end;

        SetValueByPropertyName(TObject(LComp), LValue, LFieldName);
      end;
    end;//for
  end;//with
end;

function SetCompNameValueFromJson2FrameByClassType(AFrame: TFrame; ADict: IDocDict): string;
var
  i: integer;
  LComp: TComponent;
  LValue: TValue;
  LDate: TDate;
  LTimeLog: TTimeLog;
  LFieldName, LStr: string;
begin
  with AFrame do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      LComp := AFrame.Components[i];

      LFieldName := GetEditFieldNameByClassName(TControl(LComp).ClassName);

      if LFieldName = '' then
        Continue;

      if ADict.Exists(LComp.Name) then
      begin
        LValue := GetValueByPropertyName(TObject(LComp), LFieldName);

        case LValue.Kind of
          tkString, tkLString, tkWString, tkUString: begin
            LStr := ADict[LComp.Name];//LDict.S[LComp.Name]
            LValue := TValue.From(LStr);
          end;
          tkInteger, tkInt64: LValue := TValue.From(StrToIntDef(ADict.S[LComp.Name],0));
          tkEnumeration: LValue := TValue.From(ADict.B[LComp.Name]);
          tkFloat: begin
            LTimeLog := ADict.I[LComp.Name]; //Json Field Type�� �ݵ�� TTimeLog ���� ��
            LDate := TimeLogToDateTime(LTimeLog);
            LValue := TValue.From(LDate);
          end;
        end;

        SetValueByPropertyName(TObject(LComp), LValue, LFieldName);
      end;
    end;//for
  end;//with
end;

end.
