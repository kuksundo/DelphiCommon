unit UnitpjhSQLRecord2;

interface

uses
  System.SysUtils, Vcl.Forms, Classes, Rtti, System.TypInfo, Generics.Collections,
  Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  //IniPersist를 Uses에 포함하지 않으면 TIniPersist.GetIniAttribute가 nil을 반환함
  IniPersist,
  UnitNextGridUtil2,
  mormot.core.data, mormot.orm.core, mormot.rest.client, mormot.core.base,
  mormot.rest.sqlite3, mormot.core.os
  ;

type
  TpjhRecords = array of TSQLRecordClass;

  TpjhSQLRecord = class
    FTables: TpjhRecords;
    FDBFileName: RawUTF8;
  protected
    function GetDefaultDBPath: string;
  public
    FSQLDB: TRestClientDB;
    FSQLModel: TSQLModel;

    constructor Create(const ATables: array of TSQLRecordClass); virtual;
    function InitSQLClient(ASQLDBName: string; var ASQLModel: TSQLModel): TRestClientDB; overload;
    function InitSQLClient(ASQLDBName: string=''):TRestClientDB; overload;
    function CreateSQLModel: TSQLModel;
    procedure DestroySQlClient(ASQLDB: IRestOrm; ASQLModel: TSQLModel); overload;
    procedure DestroySQlClient; overload;
    procedure SetTables(const Tables: array of TSQLRecordClass);

    function GetRecordAll: TSQLRecord;
    function AddOrUpdateDB(ARecord: TSQLRecord; AIsUpdate: Boolean): TID;

    //Record Field Attrubute의 TagNo 와 Component Tag가 같으면 값이 할당 됨
    function LoadRecordFieldUsingAttr2Form<T>(AForm: TWinControl; ARecord: T): Boolean;
    function LoadRecordFieldUsingAttrFromForm<T>(AForm: TWinControl; var ARecord: T): Boolean;
    //Record Field Name 과 Component Name이 같으면 값이 할당 됨
    function LoadRecordField2Form<T>(AForm: TWinControl; ARecord: T): Boolean;
    function LoadRecordFieldFromForm<T>(AForm: TWinControl; var ARecord: T): Boolean;
    function GetRecordField2Json<T>(ARecord: T): string;
  published
    property DBFileName: RawUTF8 read FDBFileName write FDBFileName;
//    property Tables: TpjhRecords read FTables write SetTables;
  end;

implementation

uses UnitIniPersistUtil2;

{ TpjhSQLRecord }

function TpjhSQLRecord.AddOrUpdateDB(ARecord: TSQLRecord; AIsUpdate: Boolean): TID;
begin
  Result := -1;

  if AIsUpdate then
  begin
    if FSQLDB.Update(ARecord) then
      Result := ARecord.ID;
  end
  else
  begin
    Result := FSQLDB.Add(ARecord, true);
  end;
end;

constructor TpjhSQLRecord.Create(const ATables: array of TSQLRecordClass);
var
  i: integer;
begin
  SetLength(FTables, Length(FTables));

  for i := Low(FTables) to High(FTables) do
    FTables[i] := ATables[i];
//  SetTables(ATables);
end;

function TpjhSQLRecord.CreateSQLModel: TSQLModel;
begin
  result := TSQLModel.Create(FTables);
end;

procedure TpjhSQLRecord.DestroySQlClient(ASQLDB: IRestOrm;
  ASQLModel: TSQLModel);
begin
  if Assigned(ASQLModel) then
    FreeAndNil(ASQLModel);

  if Assigned(ASQLDB) then
    FreeAndNil(ASQLDB);

  FTables := nil;
end;

procedure TpjhSQLRecord.DestroySQlClient;
begin
  if Assigned(FSQLModel) then
    FreeAndNil(FSQLModel);

  if Assigned(FSQLDB) then
    FreeAndNil(FSQLDB);

  FTables := nil;
end;

function TpjhSQLRecord.GetDefaultDBPath: string;
var
  LStr: string;
begin
  LStr := ExtractFilePath(Application.ExeName);
  Result := IncludeTrailingBackSlash(LStr) + 'db\';
end;

function TpjhSQLRecord.GetRecordAll: TSQLRecord;
begin
  Result := TSQLRecord.CreateAndFillPrepare(FSQLDB.Orm,
    'ID <> ?', [-1]);
end;

function TpjhSQLRecord.GetRecordField2Json<T>(ARecord: T): string;
var
  RttiInfo: pointer;
begin
  try
    RttiInfo := TypeInfo(T);
//    TTextWriter.RegisterCustomJSONSerializerSetOptions(RttiInfo, [soWriteIgnoreDefault], True);
//    Result := String(RecordSaveJson(ARecord, RttiInfo, True));
  except

  end;
end;

function TpjhSQLRecord.InitSQLClient(ASQLDBName: string): TRestClientDB;
var
  LStr: string;
begin
  if ASQLDBName = '' then
  begin
    ASQLDBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(ASQLDBName);
    ASQLDBName := ExtractFileName(ASQLDBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  FDBFileName := LStr + ASQLDBName;
  FSQLModel:= CreateSQLModel;
  FSQLDB := TRestClientDB.Create(CreateSQLModel, nil, FDBFileName, TRestServerDB, false, '');
  FSQLDB.server.Server.CreateMissingTables;

  Result := FSQLDB;
end;

function TpjhSQLRecord.LoadRecordField2Form<T>(AForm: TWinControl;
  ARecord: T): Boolean;
var
  ControlCtx, RecordCtx : TRttiContext;
  ControlType : TRttiType;
  RecordType : TRttiRecordType;
  ControlProp : TRttiProperty;
  RecordField  : TRttiField;
  LControl: TControl;
  i: integer;
  LStr: string;
  Value : TValue;
begin
  ControlCtx := TRttiContext.Create;
  RecordCtx := TRttiContext.Create;
  try
    RecordType := RecordCtx.GetType(TypeInfo(T)).AsRecord;

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);

      if LControl is TPanel then
        LoadRecordFieldUsingAttr2Form<T>(TWinControl(LControl), ARecord);

      LStr := GetNameOfValuePropertyFromControl(LControl); //Caption 또는 Text 또는 Value
      ControlType := ControlCtx.GetType(LControl.ClassInfo);
      ControlProp := ControlType.GetProperty(LStr);

      if Assigned(ControlProp) then
      begin
        for RecordField in RecordType.GetFields do
        begin
          if RecordField.Name = LControl.Name then
          begin
            Value := RecordField.GetValue(@ARecord);
            ControlProp.SetValue(LControl, Value);
            break;
          end;
        end;
      end;
    end;

    Result := True;

  finally
    RecordCtx.Free;
    ControlCtx.Free;
  end;
end;

function TpjhSQLRecord.LoadRecordFieldFromForm<T>(AForm: TWinControl;
  var ARecord: T): Boolean;
var
  ControlCtx, RecordCtx : TRttiContext;
  ControlType : TRttiType;
  RecordType : TRttiRecordType;
  ControlProp : TRttiProperty;
  RecordField  : TRttiField;
  LControl: TControl;
  i: integer;
  LStr: string;
  Value : TValue;
begin
  ControlCtx := TRttiContext.Create;
  RecordCtx := TRttiContext.Create;
  try
    RecordType := RecordCtx.GetType(TypeInfo(T)).AsRecord;

    for i := 0 to AForm.ControlCount - 1 do
    begin
      LControl := AForm.Controls[i];

      if LControl is TPanel then
        LoadRecordFieldUsingAttrFromForm<T>(TWinControl(LControl), ARecord);

      LStr := GetNameOfValuePropertyFromControl(LControl); //Caption 또는 Text 또는 Value
      ControlType := ControlCtx.GetType(LControl.ClassInfo);
      ControlProp := ControlType.GetProperty(LStr);

      if Assigned(ControlProp) then
      begin
        for RecordField in RecordType.GetFields do
        begin
          if RecordField.Name = LControl.Name then
          begin
            Value := ControlProp.GetValue(LControl);
            RecordField.SetValue(@ARecord, Value);
            break;
          end;
        end;
      end;
    end;

    Result := True;
  finally
    RecordCtx.Free;
    ControlCtx.Free;
  end;
end;

function TpjhSQLRecord.LoadRecordFieldUsingAttr2Form<T>(AForm: TWinControl; ARecord: T): Boolean;
var
  ControlCtx, RecordCtx : TRttiContext;
  ControlType : TRttiType;
  RecordType : TRttiRecordType;
  ControlProp : TRttiProperty;
  RecordField  : TRttiField;
  LControl: TControl;
  i, LTagNo: integer;
  LStr, LFieldName: string;
  IniValue : IniValueAttribute;
  Value : TValue;
begin
  ControlCtx := TRttiContext.Create;
  RecordCtx := TRttiContext.Create;
  try
    RecordType := RecordCtx.GetType(TypeInfo(T)).AsRecord;

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);

      if LControl is TPanel then
        LoadRecordFieldUsingAttr2Form<T>(TWinControl(LControl), ARecord);

      LTagNo := LControl.Tag;

      if LTagNo = 0 then
        Continue;

      LStr := GetNameOfValuePropertyFromControl(LControl); //Caption 또는 Text 또는 Value
      ControlType := ControlCtx.GetType(LControl.ClassInfo);
      ControlProp := ControlType.GetProperty(LStr);

      if Assigned(ControlProp) then
      begin
        for RecordField in RecordType.GetFields do
        begin
          IniValue := TIniPersist.GetIniAttribute(RecordField);

          if Assigned(IniValue) then
          begin
            if IniValue.Name = '' then
              Continue;

            if IniValue.TagNo = LTagNo then
            begin
              Value := RecordField.GetValue(@ARecord);
              ControlProp.SetValue(LControl, Value);
              break;
            end;
          end;
        end;
      end;
    end;

    Result := True;

  finally
    RecordCtx.Free;
    ControlCtx.Free;
  end;
end;

function TpjhSQLRecord.LoadRecordFieldUsingAttrFromForm<T>(AForm: TWinControl;
  var ARecord: T): Boolean;
var
  ControlCtx, RecordCtx : TRttiContext;
  ControlType : TRttiType;
  RecordType : TRttiRecordType;
  ControlProp : TRttiProperty;
  RecordField  : TRttiField;
  LControl: TControl;
  i, LTagNo: integer;
  LStr, LFieldName: string;
  IniValue : IniValueAttribute;
  Value : TValue;
begin
  ControlCtx := TRttiContext.Create;
  RecordCtx := TRttiContext.Create;
  try
    RecordType := RecordCtx.GetType(TypeInfo(T)).AsRecord;

    for i := 0 to AForm.ControlCount - 1 do
    begin
      LControl := AForm.Controls[i];

      if LControl is TPanel then
        LoadRecordFieldUsingAttrFromForm<T>(TWinControl(LControl), ARecord);  //Recursive

      LTagNo := LControl.Tag;

      if LTagNo = 0 then
        Continue;

      LStr := GetNameOfValuePropertyFromControl(LControl); //Caption 또는 Text 또는 Value
      ControlType := ControlCtx.GetType(LControl.ClassInfo);
      ControlProp := ControlType.GetProperty(LStr);

      if Assigned(ControlProp) then
      begin
        for RecordField in RecordType.GetFields do
        begin
//          LFieldName := RecordProp.Name;

          IniValue := TIniPersist.GetIniAttribute(RecordField);

          if Assigned(IniValue) then
          begin
            if IniValue.Name = '' then
              Continue;

            if IniValue.TagNo = LTagNo then
            begin
              Value := ControlProp.GetValue(LControl);
              RecordField.SetValue(@ARecord, Value);
              break;
            end;
          end;
        end;
      end;
    end;

    Result := True;
  finally
    RecordCtx.Free;
    ControlCtx.Free;
  end;
end;

function TpjhSQLRecord.InitSQLClient(ASQLDBName: string;
  var ASQLModel: TSQLModel): TRestClientDB;
var
  LStr: string;
begin
  if ASQLDBName = '' then
  begin
    ASQLDBName := ChangeFileExt(ExtractFileName(Application.ExeName),'.sqlite');
    LStr := GetDefaultDBPath;
  end
  else
  begin
    LStr := ExtractFilePath(ASQLDBName);
    ASQLDBName := ExtractFileName(ASQLDBName);

    if LStr = '' then
      LStr := GetDefaultDBPath;
  end;

  LStr := EnsureDirectoryExists(LStr);
  FDBFileName := LStr + ASQLDBName;
  ASQLModel:= CreateSQLModel;
  FSQLDB := TRestClientDB.Create(CreateSQLModel, nil, FDBFileName, TRestServerDB, false, '');
  Result.server.Server.CreateMissingTables;
  FSQLModel := ASQLModel;
  Result := FSQLDB;
end;

procedure TpjhSQLRecord.SetTables(const Tables: array of TSQLRecordClass);
var
  i: integer;
begin
  SetLength(FTables, Length(Tables));

  for i := Low(FTables) to High(FTables) do
    FTables[i] := Tables[i];
end;

end.



