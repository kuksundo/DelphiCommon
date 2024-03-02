unit UnitRttiUtil2;

interface

uses SysUtils,Classes, Rtti, TypInfo,
  Delphi.Mocks.Helpers,
  mormot.core.variants,
  mormot.core.json,
  mormot.core.unicode
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
    class procedure FromJson(const AJson: String; var ARec: T; AIsRemoveFirstChar: Boolean=False);
    class function ToJson(const ARec: T) : String;
    class function ToVariant(const ARec: T) : variant;
    class function GetSize(ARec: T): integer;
    class function GetFieldSize(ARec: T; AField: TRttiField): integer;
    class function ToArrayString(const ARec: T): TArray<string>;
    class function ToArrayInteger(const ARec: T): TArray<integer>;
    class function GetTypeKind(const ARec: T): TTypeKind;
    class function ToStringList(const ARec: T): TStringList;
    //AFieldNameList : Field Name이 ';'로 구분됨
    //AFieldNameList와 Name이 일치하는 Field만 반환함
    class function ToStringListByFieldNames(const ARec: T; AFieldNameList: string): TStringList;
    class function ToStringListByVariant(const ARec: T; AFieldNameList: variant): TStringList;

    procedure FromString(const FromValue: String);
    //반환값: field Name=value;name=value;...
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
//TValue(aValue)를 만드는 함수임
procedure SetValue(aData : String; var aValue : TValue; aTypeKind: TTypeKind = TTypeKind(0));
procedure GetValue2(var aValue: TValue; aTargetTypeKind: TTypeKind);
procedure SetValue2(aProp: TRttiProperty; var aValue : TValue);
//AClass의 APropertyName에 AData를 대입함, Class Type Field는 SetClassPropertyValue()를 사용할 것
//ex : SetValue3(aButton, 'caption', 'Pressed');
function SetValue3(AClass: TObject; AData, APropertyName : String): TTypeKind;
function GetValue3(AClass: TObject; APropertyName : String): TValue;
procedure SetClassPropertyValue(AClass, AData: TObject; APropertyName : String);

procedure LoadRecordPropertyFromVariant(AClass: TObject; const ADoc: Variant; AIsPadFirstChar: Boolean=False);
procedure LoadRecordPropertyToVariant(const AClass: TObject; var ADoc: Variant; AIsPadFirstChar: Boolean=False; AIsPropertyOnly: Boolean=False);
procedure PersistentCopy(const ASrc: TPersistent; var ADest: TPersistent);
procedure ObjectCopyWithRtti(const ASrc: TObject; var ADest: TObject);
procedure CreatePersistentAssignFile(const ASrc: TPersistent; AFileName: string);
function GetVariantFromProperty(const AClass: TObject; AIsPadFirstChar: Boolean=False; AIsPropertyOnly: Boolean=False): Variant;
//procedure LoadRecordPropertyFromVariant2(ARecType: TypeInfo; const ADoc: Variant);
function GetPropertyNameValueList(AObj: TObject; AIsOnlyPublished: Boolean=False): TStringList;
function GetPropertyCount(AObj: TObject; AIsOnlyPublished: Boolean=False): integer;
procedure LoadRecordFieldFromVariant(ATypeInfo, ARecPointer: Pointer; const ADoc: Variant; AIsPadFirstChar: Boolean=False);
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

implementation

function StrIsNumeric(s: string): Boolean;
var
  iValue, iCode: integer;
begin
  Val(s, iValue, iCode);
  Result := iCode = 0;
end;

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

//      if i <> -1 then //aData에 Enumeration 값을 Interger로 변환한 String 값이 옴
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

//aProp: 컴포넌트 또는 Object의 Field 속성(Property) - ex) Text or Caption
//aValue : aProp에 할당 할 TValue
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

function SetValue3(AClass: TObject; AData, APropertyName : String): TTypeKind;
var
 ctx : TRttiContext;
 objType : TRttiType;
 Prop  : TRttiProperty;
 Value : TValue;
 LObj: TObject;
begin
  Result := tkUnknown;

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
        //Property Field Address 가져옴
        Value := Prop.GetValue(AClass);

        if Value.IsObject then
//        if Value.TypeInfo.Kind = tkClass then
        begin
          //Value.Kind가 tkUnKnown으로 반환 되기 때문에 수종으로 tkClass를 할당 함
          Result := tkClass;

//        if Value.Kind = tkClass then
//        begin
          LObj := Prop.GetValue(AClass).AsObject;

          if LObj is TStrings then
          begin
            TStrings(LObj).Text := AData;
            Result := tkUnknown;//값을 할당 하였으면 tkUnknown을 반환하여 성공 하였음을 알린다.
          end;

//            if Assigned(LObj) then
//              Prop.SetValue(LObj, AData);
        end
        else
        begin
          //Field Value에 Data를 Assign함
          SetValue(AData, Value);
          Prop.SetValue(AClass,Value);
//        Prop.SetValue(AClass, TValue.From(AData));
          Result := tkUnknown;//값을 할당 하였으면 tkUnknown을 반환하여 성공 하였음을 알린다.
        end;

        Break;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

function GetValue3(AClass: TObject; APropertyName : String): TValue;
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
        //Property Field Address 가져옴
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

      //Enumeration 값은 값을 스트링으로 변환한 값이어야 함
      Data := TDocVariantData(ADoc).GetValueOrEmpty(LPropName);
      //Property Field Address 가져옴
      Value := Prop.GetValue(AClass);
      //Field Value에 Data를 Assign함
      SetValue(Data, Value);
      Prop.SetValue(AClass,Value);
    end;

//    for Field in objType.GetFields do
//    begin
//      Value := Field.GetValue(AClass);
//      SetValue(Data,Value);
//      Field.SetValue(AClass,Value);
//    end;
  finally
    ctx.Free;
  end;
end;

procedure LoadRecordPropertyToVariant(const AClass: TObject; var ADoc: Variant;
  AIsPadFirstChar: Boolean; AIsPropertyOnly: Boolean);
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
      if not Prop.IsWritable then
        continue;

      if Prop.Visibility <> mvPublished then
        Continue;

      LPropName := Prop.Name;

      //"array of TSQLGSFileRec" type은 Skip함(Field명: Attachments)
      if (LPropName = 'IDValue') or (LPropName = 'InternalState') or
         (LPropName = 'Attachments') then
        continue;

      if AIsPadFirstChar then
        Insert('F', LPropName,1);

      //Value는 무시하고 Property(속성)만 ADoc에 저장함
      if AIsPropertyOnly then
      begin
        TDocVariantData(ADoc).Value[LPropName] := '';
      end
      else
      begin
        Value := Prop.GetValue(AClass);

        //tkSet Type은 value.AsVariant에서 지원 안함 (type cast error 발생함)
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

      //Property Field Address 가져옴
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
//TPersistent Assign 구문을 생성함
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
        //EPItem.MultiStateValues가 array of char 이며 이때문에 나는 에러 회피용
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
var //Name=Value로 반환함
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

procedure LoadRecordFieldFromVariant(ATypeInfo, ARecPointer: Pointer;
  const ADoc: Variant; AIsPadFirstChar: Boolean=False);
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
    LTypeKind := SetValue3(TObject(LComp), AValue, APropName);

    //SetValue에 실패한 경우(tkClass 인 경우)
    if LTypeKind = tkClass then
    begin
      //AValue가 Component를 가리키므로 Form에서 검색함
      LComp2 := AParentControl.FindComponent(AValue);

      //nil을 할당할 경우
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
    LValue := GetValue3(TObject(LComp), APropName);
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
  RttiMethod  : TRttiMethod;
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

end.
