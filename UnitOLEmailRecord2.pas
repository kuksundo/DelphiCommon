unit UnitOLEmailRecord2;

interface

uses System.SysUtils, Classes,
  mormot.orm.core, mormot.core.base, mormot.rest.sqlite3, mormot.core.os,
  mormot.core.data, mormot.orm.base, mormot.core.variants, mormot.core.datetime,
  UnitGAServiceData;

type
  TSQLOLEmailMsg = class(TSQLRecord)
  private
    fDBKey,
    fHullNo: RawUTF8;
    fPrevFolderPath,
    fSavedOLFolderPath,
    fLocalEntryId,
    fLocalStoreId,
    fRemoteEntryId, //원격지의 pst파일에 저장할 때 Id
    fRemoteStoreId,
    fSender,
    fReceiver,
    fCarbonCopy,
    fBlindCC,
    fSubject,
    fSavedMsgFilePath,
    fSavedMsgFileName
    : RawUTF8;
    fAttachCount: integer;
    FContainData: TContainData4Mail;
    //해당 메일이 누구한테 보내는 건지 구분하기 위함
    FProcDirection: TProcessDirection;
    fRecvDate: TTimeLog;
  public
    FIsUpdate: Boolean;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property DBKey: RawUTF8 read fDBKey write fDBKey;// stored AS_UNIQUE;
    property HullNo: RawUTF8 read fHullNo write fHullNo;
    property PrevFolderPath: RawUTF8 read fPrevFolderPath write fPrevFolderPath;
    property SavedOLFolderPath: RawUTF8 read fSavedOLFolderPath write fSavedOLFolderPath;
    property LocalEntryId: RawUTF8 read fLocalEntryId write fLocalEntryId;
    property LocalStoreId: RawUTF8 read fLocalStoreId write fLocalStoreId;
    property RemoteEntryId: RawUTF8 read fRemoteEntryId write fRemoteEntryId;
    property RemoteStoreId: RawUTF8 read fRemoteStoreId write fRemoteStoreId;
    property Sender: RawUTF8 read fSender write fSender;
    property Receiver: RawUTF8 read fReceiver write fReceiver;
    property CarbonCopy: RawUTF8 read fCarbonCopy write fCarbonCopy;
    property BlindCC: RawUTF8 read fBlindCC write fBlindCC;
    property Subject: RawUTF8 read fSubject write fSubject;
    property SavedMsgFilePath: RawUTF8 read fSavedMsgFilePath write fSavedMsgFilePath;
    property SavedMsgFileName: RawUTF8 read fSavedMsgFileName write fSavedMsgFileName;
    property AttachCount: integer read fAttachCount write fAttachCount;
    property ContainData: TContainData4Mail read FContainData write FContainData;
    property ProcDirection: TProcessDirection read FProcDirection write FProcDirection;
    property RecvDate: TTimeLog read fRecvDate write fRecvDate;
  end;

var
  g_OLEmailMsgDB: TRestClientDB;
  OLEmailMsgModel: TSQLModel;
  g_OLEmailMsgDBFileName: string;

procedure InitOLEmailMsgClient(AExeName: string = ''; ADBFileName: string = '');
function CreateOLEmailMsgModel: TSQLModel;
procedure DestroyOLEmailMsg;

function GetEMailDBName(AExeName, AProdType: string): String;
function GetSQLOLEmailMsgFromDBKey(ADBKey: string): TSQLOLEmailMsg;
function GetFirstStoreIdFromDBKey(ADBKey: string): string;
function GetOLEmailList2JSONArrayFromDBKey(ADBKey: string): RawUTF8;
procedure GetContainDataNDirFromID(AID: integer; out AConData, AProcDir: integer);
function GetEmailCountFromDBKey(ADBKey: string): integer;

function AddOLMail2DBFromDroppedMail(ADBKey, AHullNo, AJson: string;
  AAddedMailList: TStringList; AFromRemote: Boolean=False): Boolean;
function UpdateOLMail2DBFromMovedMail(AMovedMailList: TStringList; AFromRemote: Boolean=False): Boolean;
function DeleteOLMail2DBFromID(AID: integer): Boolean;
function DeleteOLMail2DBFromDBKey(ADBKey: string): Boolean;

implementation

uses UnitFolderUtil2, Forms;

procedure InitOLEmailMsgClient(AExeName: string; ADBFileName: string);
var
  LStr, LFileName: string;
begin
  if Assigned(g_OLEmailMsgDB) then
    DestroyOLEmailMsg;

  LStr := ExtractFileExt(AExeName);
  LFileName := ExtractFileName(AExeName);
  AExeName := ExtractFilePath(AExeName);

  if LStr = '.exe' then
  begin
    LStr := ChangeFileExt(ExtractFileName(AExeName),'.sqlite');
    LStr := LStr.Replace('.sqlite', '_Email.sqlite');
    AExeName := GetSubFolderPath(AExeName, 'db');
  end;

  AExeName := EnsureDirectoryExists(AExeName);

  if ADBFileName = '' then
    g_OLEmailMsgDBFileName := AExeName + LFileName
  else
    g_OLEmailMsgDBFileName := ADBFileName;

  OLEmailMsgModel := CreateOLEmailMsgModel;
  g_OLEmailMsgDB:= TSQLRestClientDB.Create(OLEmailMsgModel, CreateOLEmailMsgModel,
    g_OLEmailMsgDBFileName, TSQLRestServerDB);
  TSQLRestClientDB(g_OLEmailMsgDB).Server.CreateMissingTables;
end;

function CreateOLEmailMsgModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLOLEmailMsg]);
end;

procedure DestroyOLEmailMsg;
begin
  if Assigned(g_OLEmailMsgDB) then
    FreeAndNil(g_OLEmailMsgDB);

  if Assigned(OLEmailMsgModel) then
    FreeAndNil(OLEmailMsgModel);
end;

function GetEMailDBName(AExeName, AProdType: string): String;
begin
  Result := AExeName;
  Result := Result.Replace('.exe', '_' + AProdType + '.exe');
end;

function GetSQLOLEmailMsgFromDBKey(ADBKey: string): TSQLOLEmailMsg;
begin
  Result := TSQLOLEmailMsg.CreateAndFillPrepare(g_OLEmailMsgDB.Orm,
    'DBKey = ?', [ADBKey]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetFirstStoreIdFromDBKey(ADBKey: string): string;
var
  LIds: TIDDynArray;
  LSQLEmailMsg: TSQLOLEmailMsg;
begin
  LSQLEmailMsg:= TSQLOLEmailMsg.CreateAndFillPrepare(g_OLEmailMsgDB.Orm, 'DBKey = ?', [ADBKey]);

  try
    if LSQLEmailMsg.FillOne then
    begin
      Result := LSQLEmailMsg.LocalStoreId;
    end;
  finally
    FreeAndNil(LSQLEmailMsg);
  end;
end;

function GetOLEmailList2JSONArrayFromDBKey(ADBKey: string): RawUTF8;
var
  LSQLEmailMsg: TSQLOLEmailMsg;
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
  LSQLEmailMsg := GetSQLOLEmailMsgFromDBKey(ADBKey);

  try
    LSQLEmailMsg.FillRewind;

    while LSQLEmailMsg.FillOne do
    begin
      LUtf8 := LSQLEmailMsg.GetJSONValues(true, true, soSelect);
      LDynArr.Add(LUtf8);
    end;

    LUtf8 := LDynArr.SaveToJSON;
    Result := LUtf8;
  finally
    FreeAndNil(LSQLEmailMsg);
  end;
end;

procedure GetContainDataNDirFromID(AID: integer; out AConData, AProcDir: integer);
var
  i: integer;
  LEmailMsg: TSQLOLEmailMsg;
begin
  AConData := -1;
  AProcDir := -1;

  LEmailMsg := TSQLOLEmailMsg.Create(g_OLEmailMsgDB.Orm, 'ID = ?', [AID]);

  try
    if LEmailMsg.FillOne then
    begin
      AConData := Ord(LEmailMsg.ContainData);
      AProcDir := Ord(LEmailMsg.ProcDirection);
    end;
  finally
    FreeAndNil(LEmailMsg);
  end;
end;

function GetEmailCountFromDBKey(ADBKey: string): integer;
var
  LSQLEmailMsg: TSQLOLEmailMsg;
begin
  Result := 0;
  LSQLEmailMsg := GetSQLOLEmailMsgFromDBKey(ADBKey);
  try
    if LSQLEmailMsg.IsUpdate then
    begin
      Result := LSQLEmailMsg.fFill.Table.RowCount;
    end;
  finally
    FreeAndNil(LSQLEmailMsg);
  end;
end;

function AddOLMail2DBFromDroppedMail(ADBKey, AHullNo, AJson: string;
  AAddedMailList: TStringList; AFromRemote: Boolean): Boolean;
var
  LVarArr: TVariantDynArray;
  LVar: Variant;
  i: integer;
  LEmailMsg: TSQLOLEmailMsg;
  LUtf8: RawUTF8;
  LEntryId, LStoreId, LWhere, LStr: string;
begin
  Result := False;
  LEntryId := '';
  LStoreId := '';

  if AFromRemote then
    LWhere := 'RemoteEntryID = ? AND RemoteStoreID = ?'
  else
    LWhere := 'LocalEntryID = ? AND LocalStoreID = ?';

  LVarArr := JSONToVariantDynArray(AJson);

  for i := 0 to High(LVarArr) do
  begin
    LVar := _JSON(LVarArr[i]);

    if LVar.EntryId <> Null then
      LEntryId := LVar.EntryId
    else
    if LVar.LocalEntryId <> Null then
      LEntryId := LVar.LocalEntryId
    else
    if LVar.RemoteEntryId <> Null then
      LEntryId := LVar.RemoteEntryId;

    if LVar.StoreId  <> Null then
      LStoreId := LVar.StoreId
    else
    if LVar.LocalStoreId  <> Null then
      LStoreId := LVar.LocalStoreId
    else
    if LVar.RemoteStoreId  <> Null then
      LStoreId := LVar.RemoteStoreId;

    if (LEntryId <> '') and (LStoreId <> '') then
    begin
      LEmailMsg := TSQLOLEmailMsg.CreateAndFillPrepare(g_OLEmailMsgDB.Orm,
        'DBKey = ? AND ' + LWhere, [ADBKey, LEntryId, LStoreId]);
      try
        if LEmailMsg.FillOne then
          LEmailMsg.IsUpdate := True
        else
          LEmailMsg.IsUpdate := False;

        LEmailMsg.DBKey := ADBKey;
        LEmailMsg.HullNo := AHullNo;

        if AFromRemote then
        begin
          LEmailMsg.RemoteEntryId := LEntryId;
          LEmailMsg.RemoteStoreId := LStoreId;
        end
        else
        begin
          LEmailMsg.LocalEntryID := LEntryId;
          LEmailMsg.LocalStoreId := LStoreId;
        end;

        LEmailMsg.Sender := LVar.Sender;
        LEmailMsg.Receiver := LVar.Receiver;
        LEmailMsg.CarbonCopy := LVar.CC;
        LEmailMsg.BlindCC := LVar.BCC;
        LEmailMsg.Subject := LVar.Subject;
        LUtf8 := LVar.SavedOLFolderPath;
        LEmailMsg.SavedOLFolderPath := LUtf8;
        //"jhpark@hyundai-gs.com\VDR\" 형식으로 저장 됨
        LEmailMsg.SavedMsgFilePath := GetFolderPathFromEmailPath(LUtf8);
        //GUID.msg 형식으로 저장됨
        LEmailMsg.SavedMsgFileName := LVar.SavedMsgFileName;
        LEmailMsg.AttachCount := LVar.AttachCount;
        LEmailMsg.RecvDate := TimeLogFromDateTime(StrToDateTime(LVar.RecvDate));
        LStr := LVar.ContainData;
        LEmailMsg.ContainData := g_ContainData4Mail.ToType(LStr);
        LStr := LVar.ProcDirection;
        LEmailMsg.ProcDirection := g_ProcessDirection.ToType(LStr);

        if LEmailMsg.IsUpdate then
          g_OLEmailMsgDB.Update(LEmailMsg)
        else
        //DB에 동일한 데이터가 없으면 email을 DB에 추가
        begin
          g_OLEmailMsgDB.Add(LEmailMsg, true);

          if Assigned(AAddedMailList) then
            AAddedMailList.Add(LEmailMsg.LocalEntryId + '=' + LEmailMsg.LocalStoreId);
        end;

        Result := True;
      finally
        FreeAndNil(LEmailMsg);
      end;
    end;
  end;//for
end;

function UpdateOlMail2DBFromMovedMail(AMovedMailList: TStringList; AFromRemote: Boolean): Boolean;
var
  LEmailMsg: TSQLOLEmailMsg;
  LUtf8, LOldPath: RawUTf8;
  LSrcFile, LDestFile, LWhere: string;
begin
  Result := False;

  if AFromRemote then
    LWhere := 'RemoteEntryID = ? AND RemoteStoreID = ?'
  else
    LWhere := 'LocalEntryID = ? AND LocalStoreID = ?';

  LEmailMsg := TSQLOLEmailMsg.CreateAndFillPrepare(g_OLEmailMsgDB.Orm,
    LWhere, [AMovedMailList.Values['OriginalEntryId'],
                                    AMovedMailList.Values['OriginalStoreId']]);
  try
    if LEmailMsg.FillOne then
    begin
      LEmailMsg.LocalEntryId := AMovedMailList.Values['NewEntryId'];
      LEmailMsg.LocalStoreID := AMovedMailList.Values['MovedStoreId'];
      LUtf8 := AMovedMailList.Values['MovedFolderPath'];
      LOldPath := LEmailMsg.SavedOLFolderPath;

      if LUtf8 <> LOldPath then
      begin
        LEmailMsg.SavedOLFolderPath := LUtf8;
        LEmailMsg.SavedMsgFilePath := GetFolderPathFromEmailPath(LUtf8);
        LSrcFile := ExtractFilePath(g_OLEmailMsgDBFileName) + LOldPath + LEmailMsg.SavedMsgFileName;
        LDestFile := ExtractFilePath(g_OLEmailMsgDBFileName) + LEmailMsg.SavedMsgFilePath + LEmailMsg.SavedMsgFileName;

        if FileExists(LSrcFile) then
        begin
          if CopyFile(LSrcFile, LDestFile, True) then
            DeleteFile(LSrcFile);
        end;
      end;

      Result := g_OLEmailMsgDB.Update(LEmailMsg);
    end;
  finally
    FreeAndNil(LEmailMsg);
  end;
end;

function UpdateOLMail2DBFromContainDataNProcdir(AID: integer;
  AConData: TContainData4Mail; AProcDir: TProcessDirection): Boolean;
var
  LEmailMsg: TSQLOLEmailMsg;
begin
  Result := False;

  LEmailMsg := TSQLOLEmailMsg.CreateAndFillPrepare(g_OLEmailMsgDB.Orm, 'ID = ?', [AID]);

  try
    if LEmailMsg.FillOne then
    begin
      LEmailMsg.ContainData := AConData;
      LEmailMsg.ProcDirection := AProcDir;
      Result := g_OLEmailMsgDB.Update(LEmailMsg);
    end;
  finally
    FreeAndNil(LEmailMsg);
  end;
end;

function DeleteOLMail2DBFromID(AID: integer): Boolean;
begin
  Result := g_OLEmailMsgDB.Delete(TSQLOLEmailMsg, AID);
end;

function DeleteOLMail2DBFromDBKey(ADBKey: string): Boolean;
begin
  Result := g_OLEmailMsgDB.Delete(TSQLOLEmailMsg, 'DBKey = ?', [ADBKey]);
end;

initialization
  g_OLEmailMsgDB := nil;

finalization
  DestroyOLEmailMsg;

end.
