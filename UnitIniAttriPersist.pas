unit UnitIniAttriPersist;

interface

uses SysUtils,Classes, Rtti, TypInfo, IniFiles;

type
  JHPIniAttribute = class(TCustomAttribute)
  private
    FSection: string;
    FName: string;
    FTypeKind: TTypeKind;
    FDefaultValue: string;
    FTagNo: integer;
  published
    constructor Create(const aSection : String; const aName : string;
      const aDefaultValue : String; const aTagNo : integer; const ATypeKind: TTypeKind);

    property Section : string read FSection write FSection;
    property Name : string read FName write FName;
    property TypeKind : TTypeKind read FTypeKind write FTypeKind;
    property DefaultValue : string read FDefaultValue write FDefaultValue;
    property TagNo : integer read FTagNo write FTagNo;
  end;

  EJHPIniPersist = class(Exception);

  TJHPIniPersist = class (TObject)
  public
//    class function GetValue();
//    class procedure SetValue();
    class function GetValueFromIni(AIniFile: TIniFile; AAttri: JHPIniAttribute) : TValue;
    class procedure Write2Ini(AIniFile: TIniFile; AAttri: JHPIniAttribute; aValue : TValue);
    class function GetIniAttribute(Obj : TRttiObject) : JHPIniAttribute;
    class procedure Load(FileName : String;obj : TObject);
    class procedure Save(FileName : String;obj : TObject);
  end;

implementation

{ TJHPIniPersist }

class function TJHPIniPersist.GetIniAttribute(
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

class function TJHPIniPersist.GetValueFromIni(AIniFile: TIniFile; AAttri: JHPIniAttribute) : TValue;
begin
  case AAttri.TypeKind of
    tkWChar,
    tkLString,
    tkWString,
    tkString,
    tkChar,
    tkUString    : Result := AIniFile.ReadString(AAttri.Section, AAttri.Name, AAttri.DefaultValue);
    tkInteger    : Result := AIniFile.ReadInteger(AAttri.Section, AAttri.Name, 0);
    tkInt64      : Result := AIniFile.ReadInteger(AAttri.Section, AAttri.Name, 0);
    tkFloat      : Result := AIniFile.ReadFloat(AAttri.Section, AAttri.Name, 0.0);
    tkEnumeration: Result := AIniFile.ReadBool(AAttri.Section, AAttri.Name, False);
//    tkSet: begin
//             i :=  StringToSet(aValue.TypeInfo,aData);
//             TValue.Make(@i, aValue.TypeInfo, aValue);
//          end;
    else
      raise EJHPIniPersist.Create('Type not Supported');
  end;
end;

class procedure TJHPIniPersist.Load(FileName: String; obj: TObject);
var
  ctx : TRttiContext;
  objType : TRttiType;
  Field : TRttiField;
  Prop  : TRttiProperty;
  IniValue, Value : TValue;
  IniAttr : JHPIniAttribute;
  IniFile : TIniFile;
begin
  ctx := TRttiContext.Create;
  try
    IniFile := TIniFile.Create(FileName);
    try
      objType := ctx.GetType(Obj.ClassInfo);

      for Prop in objType.GetProperties do
      begin
        IniAttr := GetIniAttribute(Prop);

        if Assigned(IniAttr) then
        begin
          IniValue := TJHPIniPersist.GetValueFromIni(IniFile, IniAttr);
          Value := Prop.GetValue(Obj);
          Value := IniValue;
          Prop.SetValue(Obj,Value);
        end;
      end;
    finally
      IniFile.Free;
    end;
  finally
    ctx.Free;
  end;
end;

class procedure TJHPIniPersist.Save(FileName: String; obj: TObject);
var
  ctx : TRttiContext;
  objType : TRttiType;
  Field : TRttiField;
  Prop  : TRttiProperty;
  Value : TValue;
  IniAttr : JHPIniAttribute;
  IniFile : TIniFile;
  Data : String;
begin
  ctx := TRttiContext.Create;
  try
    IniFile := TIniFile.Create(FileName);
    try
      objType := ctx.GetType(Obj.ClassInfo);

      for Prop in objType.GetProperties do
      begin
        IniAttr := GetIniAttribute(Prop);

        if Assigned(IniAttr) then
        begin
          Value := Prop.GetValue(Obj);
          TJHPIniPersist.Write2Ini(IniFile, IniAttr, Value);
        end;
      end;
    finally
      IniFile.Free;
    end;
  finally
    ctx.Free;
  end;
end;

class procedure TJHPIniPersist.Write2Ini(AIniFile: TIniFile;
  AAttri: JHPIniAttribute; aValue : TValue);
begin
  case AAttri.TypeKind of
    tkWChar,
    tkLString,
    tkWString,
    tkString,
    tkChar,
    tkUString    : AIniFile.WriteString(AAttri.Section, AAttri.Name, aValue.AsString);
    tkInteger    : AIniFile.WriteInteger(AAttri.Section, AAttri.Name, aValue.AsInteger);
    tkInt64      : AIniFile.WriteInteger(AAttri.Section, AAttri.Name, aValue.AsInt64);
    tkFloat      : AIniFile.WriteFloat(AAttri.Section, AAttri.Name, aValue.AsExtended);
    tkEnumeration: AIniFile.WriteBool(AAttri.Section, AAttri.Name, aValue.AsBoolean);
//    tkSet: begin
//             i :=  StringToSet(aValue.TypeInfo,aData);
//             TValue.Make(@i, aValue.TypeInfo, aValue);
//          end;
    else
      raise EJHPIniPersist.Create('Type not Supported');
  end;
end;

{ JHPIniAttribute }

constructor JHPIniAttribute.Create(const aSection, aName, aDefaultValue: String;
  const aTagNo: integer; const ATypeKind: TTypeKind);
begin
  FSection := aSection;
  FName := aName;
  FTypeKind := ATypeKind;
  FDefaultValue := aDefaultValue;
  FTagNo := aTagNo;
end;

end.
