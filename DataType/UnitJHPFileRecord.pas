unit UnitJHPFileRecord;

interface

uses
  Classes, System.SysUtils,
  mormot.core.base, mormot.orm.core, mormot.rest.client, mormot.core.os,
  mormot.rest.sqlite3, mormot.core.variants, mormot.orm.base,
  UnitJHPFileData;

type
  TOrmJHPFile = class;

  TIDList4JHPFile = class
    fTaskId  : TID;
    fJHPFileAction,
    fJHPDocType: integer;
    fJHPFile: TOrmJHPFile;
  public
    property JHPFileAction: integer read fJHPFileAction write fJHPFileAction;
  published
    property TaskId: TID read fTaskId write fTaskId;
    property JHPDocType: integer read fJHPDocType write fJHPDocType;
    property JHPFile: TOrmJHPFile read fJHPFile write fJHPFile;
  end;

  TOrmJHPFile = class(TOrm)
  private
    fTaskID: TID;
    fFileID: TTimeLog;
    fFilename,
    fSavedFullPathFN //파일이름 변경하여 Folder에 저장시 변경된 Full Path 파일 이름
    : RawUTF8;
    fFileFromSource,//1: from outlook attached
    fFileSaveKind, //2: Disk에 파일 저장 됨(UnitJHPFileData.TJHPFileSaveKind)
    fDocFormat,
    fCompressAlgo: integer;
    fFileSize: int64;
    fBaseDir,
    fFilePath,
    fFileDesc //파일 설명
    :RawUTF8;
    fData: RawUTF8;
    fBlobData: RawByteString;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property FileID: TTimeLog read fFileID write fFileID;
    property Filename: RawUTF8 read fFilename write fFilename;
    property SavedFileName: RawUTF8 read fSavedFullPathFN write fSavedFullPathFN;
    property DocFormat: integer read fDocFormat write fDocFormat;
    property FileFromSource: integer read fFileFromSource write fFileFromSource;
    property FileSaveKind: integer read fFileSaveKind write fFileSaveKind;
    property FileSize: int64 read fFileSize write fFileSize;
    property CompressAlgo: integer read fCompressAlgo write fCompressAlgo;
    property FilePath: RawUTF8 read fFilePath write fFilePath;
    property BaseDir: RawUTF8 read fBaseDir write fBaseDir;
    property FileDesc: RawUTF8 read fFileDesc write fFileDesc;
    property Data: RawUTF8 read fData write fData;
    property BlobData: RawByteString read fBlobData write fBlobData;
  end;

procedure InitJHPFileClient(AExeName: string; ADBFileName: string='');
function InitJHPFileClient2(AExeName: string; var AModel: TOrmModel; ADBFileName: string=''): TRestClientDB;
function CreateJHPFilesModel: TOrmModel;
procedure DestroyJHPFile;

function GetJHPFilesFromTaskID(const AID: TID; ADB: TRestClientDB): TOrmJHPFile;
function GetJHPFilesFromFileID(const AFileID: TID; ADB: TRestClientDB): TOrmJHPFile;
function GetJHPFiles(ADB: TRestClientDB): TOrmJHPFile;
function GetFileDataByFileID(const AFileID: TTimeLog; ADB: TRestClientDB): RawByteString;
function GetFileContentsFromDBBySaveKind(const AOrm: TOrmJHPFile): RawByteString;
function GetFileCountFromTaskID(const AID: TID; ADB: TRestClientDB): integer;
function GetFileCountFromFileID(const AID: TID; ADB: TRestClientDB): integer;
function GetFileCountFromTaskNFileID(const ATaskID, AFileID: TID; ADB: TRestClientDB): integer;

//procedure LoadJHPFileRecFromVariant(var ASQLJHPFileRec: TOrmJHPFileRec; ADoc: variant);
procedure AddOrUpdateJHPFiles(AOrmJHPFile: TOrmJHPFile; ADB: TRestClientDB);
function AddOrUpdate2DBByJHPFileRec(const ARec: TJHPFileRec; ADB: TRestClientDB): TID;
function DeleteJHPFilesFromDBByTaskID(const AID: TID; ADB: TRestClientDB): Boolean;
function DeleteJHPFilesFromDBByFileID(const AFileID: TTimeLog; ADB: TRestClientDB): Boolean;
function SaveJHPFile2DB(ADBName, ASaveFileName: string; AID: TID;
  ADocType: integer): Boolean;
function GetDefaultInvoiceFileName(AFileKind: TJHPFileFormat; AInvNo: string): string;

procedure AssignJHPFileRec2Orm(const ASrcRec: TJHPFileRec; out ADestOrm: TOrmJHPFile);

//File Handling
function GetFilesFromOrmByKeyID(const AKeyID: TTimeLog; ADB: TRestClientDB): TOrmJHPFile;
function GetFiles2JsonAryFromOrmByID(const AKeyID: TTimeLog; ADB: TRestClientDB;
  AIsIncludeDiskFile: Boolean = True): RawUtf8;

var
  g_FileDB: TRestClientDB;//TRestClientDB
  FileModel: TOrmModel;

implementation

uses UnitFolderUtil2, Forms, UnitOrmFileClient, UnitBase64Util2;

procedure InitJHPFileClient(AExeName: string; ADBFileName: string);
var
  LStr, LFileName, LFilePath: string;
begin
  if Assigned(g_FileDB) then
    exit;

  if AExeName = '' then
    AExeName := Application.ExeName;

  LStr := ExtractFileExt(AExeName);
  LFileName := ExtractFileName(AExeName);
  LFilePath := ExtractFilePath(AExeName);

  if LStr = '.exe' then
  begin
    LFileName := ChangeFileExt(ExtractFileName(AExeName),'.sqlite');
    LFileName := LFileName.Replace('.sqlite', '_Files.sqlite');
    LFilePath := GetSubFolderPath(LFilePath, 'db');
  end;

  LFilePath := EnsureDirectoryExists(LFilePath);

  if ADBFileName = '' then
    LStr := LFilePath + LFileName
  else
    LStr := ADBFileName;

  FileModel:= CreateJHPFilesModel;

  g_FileDB:= TRestClientDB.Create(FileModel, CreateJHPFilesModel,
    LStr, TSQLRestServerDB);
  TRestClientDB(g_FileDB).Server.CreateMissingTables;
end;

function InitJHPFileClient2(AExeName: string; var AModel: TOrmModel; ADBFileName: string): TRestClientDB;
var
  LStr, LFileName, LFilePath: string;
begin
  if AExeName = '' then
    AExeName := Application.ExeName;

  LStr := ExtractFileExt(AExeName);
  LFileName := ExtractFileName(AExeName);
  LFilePath := ExtractFilePath(AExeName);

  if LStr = '.exe' then
  begin
    LFileName := ChangeFileExt(ExtractFileName(AExeName),'.sqlite');
    LFileName := LFileName.Replace('.sqlite', '_Files.sqlite');
    LFilePath := GetSubFolderPath(LFilePath, 'db');
  end;

  LFilePath := EnsureDirectoryExists(LFilePath);

  if ADBFileName = '' then
    LStr := LFilePath + LFileName
  else
    LStr := ADBFileName;

  AModel:= CreateJHPFilesModel;

  Result := TRestClientDB.Create(AModel, CreateJHPFilesModel,
    LStr, TSQLRestServerDB);
  TRestClientDB(Result).Server.CreateMissingTables;
end;

function CreateJHPFilesModel: TOrmModel;
begin
  result := TOrmModel.Create([TOrmJHPFile]);
end;

procedure DestroyJHPFile;
begin
  if Assigned(g_FileDB) then
    FreeAndNil(g_FileDB);
  if Assigned(FileModel) then
    FreeAndNil(FileModel);
end;

function GetJHPFilesFromTaskID(const AID: TID; ADB: TRestClientDB): TOrmJHPFile;
begin
  if not Assigned(ADB) then
    ADB := g_FileDB;

  Result := TOrmJHPFile.CreateAndFillPrepare(ADB.Orm, 'TaskID = ?', [AID]);
  Result.IsUpdate := Result.FillOne;

  if not Result.IsUpdate then
    Result.fTaskID := AID;
end;

function GetJHPFilesFromFileID(const AFileID: TID; ADB: TRestClientDB): TOrmJHPFile;
begin
  if not Assigned(ADB) then
    ADB := g_FileDB;

  Result := TOrmJHPFile.CreateAndFillPrepare(ADB.Orm, 'FileID = ?', [AFileID]);
  Result.IsUpdate := Result.FillOne;
end;

function GetJHPFiles(ADB: TRestClientDB): TOrmJHPFile;
begin
  if not Assigned(ADB) then
    ADB := g_FileDB;

  Result := TOrmJHPFile.CreateAndFillPrepare(ADB.Orm, 'TaskID <> ?', [-1]);
  Result.IsUpdate := Result.FillOne;
end;

function GetFileDataByFileID(const AFileID: TTimeLog; ADB: TRestClientDB): RawByteString;
var
  LOrm: TOrmJHPFile;
begin
  Result := '';

  if not Assigned(ADB) then
    ADB := g_FileDB;

  LOrm := TOrmJHPFile.CreateAndFillPrepare(ADB.Orm, 'FileID = ?', [AFileID]);
  try
    if LOrm.FillOne then
    begin
      Result := GetFileContentsFromDBBySaveKind(LOrm);
    end;
  finally
    LOrm.Free;
  end;
end;

function GetFileContentsFromDBBySaveKind(const AOrm: TOrmJHPFile): RawByteString;
begin
  Result := '';

  case TJHPFileSaveKind(AOrm.fFileSaveKind) of
    fskBase64: Result := MakeBase64ToRawByteString(AOrm.Data);
    fskBlob: Result := AOrm.BlobData;
    fskDisk: Result := GetFileContentsFromDiskByName(AOrm.SavedFileName);
  end;
end;

function GetFileCountFromTaskID(const AID: TID; ADB: TRestClientDB): integer;
var
  LOrm: TOrmTable;
  LResult: RawUtf8;
begin
  Result := 0;

  if not Assigned(ADB) then
    ADB := g_FileDB;

  //'{"fieldCount":1,"values":["count(*)",3],"rowCount":1}
//  LResult := ADB.ExecuteJson([],'select count(*) from ' + TOrmJHPFile.SQLTableName + ' where TaskID = ' + IntToStr(AID));

  LOrm := ADB.ExecuteList([],'select TaskID from ' + TOrmJHPFile.SQLTableName + ' where TaskID = ' + IntToStr(AID));
  try
    Result := LOrm.RowCount;
  finally
    LOrm.Free;
  end;
end;

function GetFileCountFromFileID(const AID: TID; ADB: TRestClientDB): integer;
var
  LOrm: TOrmTable;
  LResult: RawUtf8;
begin
  Result := 0;

  if not Assigned(ADB) then
    ADB := g_FileDB;

  //'{"fieldCount":1,"values":["count(*)",3],"rowCount":1}
//  LResult := ADB.ExecuteJson([],'select count(*) from ' + TOrmJHPFile.SQLTableName + ' where TaskID = ' + IntToStr(AID));

  LOrm := ADB.ExecuteList([],'select FileID from ' + TOrmJHPFile.SQLTableName + ' where FileID = ' + IntToStr(AID));
  try
    Result := LOrm.RowCount;
  finally
    LOrm.Free;
  end;
end;

function GetFileCountFromTaskNFileID(const ATaskID, AFileID: TID; ADB: TRestClientDB): integer;
var
  LOrm: TOrmTable;
  LResult: RawUtf8;
begin
  Result := 0;

  if not Assigned(ADB) then
    ADB := g_FileDB;

  //'{"fieldCount":1,"values":["count(*)",3],"rowCount":1}
//  LResult := ADB.ExecuteJson([],'select count(*) from ' + TOrmJHPFile.SQLTableName + ' where TaskID = ' + IntToStr(AID));
  LOrm := ADB.ExecuteList([],'select FileID from ' + TOrmJHPFile.SQLTableName + ' where TaskID = ' + IntToStr(ATaskID) + ' and FileID = ' + IntToStr(AFileID));
  try
    Result := LOrm.RowCount;
  finally
    LOrm.Free;
  end;
end;

//procedure LoadJHPFileRecFromVariant(var AOrmJHPFileRec: TOrmJHPFileRec; ADoc: variant);
//begin
//  if ADoc <> '[]' then
//  begin
//    AOrmJHPFileRec.fFilename := ADoc.fFilename;
//    AOrmJHPFileRec.fFileSize := ADoc.fFileSize;
//    AOrmJHPFileRec.fGSDocType := ADoc.fGSDocType;
//    AOrmJHPFileRec.fData := ADoc.fData;
//  end;
//end;

procedure AddOrUpdateJHPFiles(AOrmJHPFile: TOrmJHPFile; ADB: TRestClientDB);
begin
  if not Assigned(ADB) then
    ADB := g_FileDB;

  if AOrmJHPFile.IsUpdate then
  begin
    ADB.Update(AOrmJHPFile);
  end
  else
  begin
    ADB.Add(AOrmJHPFile, true);
  end;
end;

function AddOrUpdate2DBByJHPFileRec(const ARec: TJHPFileRec; ADB: TRestClientDB): TID;
var
  LOrm: TOrmJHPFile;
begin
  Result := -1;

  if not Assigned(ADB) then
    ADB := g_FileDB;

  LOrm := GetJHPFilesFromFileID(ARec.fFileID, ADB);
  try
    AssignJHPFileRec2Orm(ARec, LOrm);

    if LOrm.IsUpdate then
    begin
      ADB.Update(LOrm);
    end
    else
    begin
      Result := ADB.Add(LOrm, true);
    end;
  finally
    LOrm.Free;
  end;
end;

function DeleteJHPFilesFromDBByTaskID(const AID: TID; ADB: TRestClientDB): Boolean;
var
  LOrm: TOrmJHPFile;
begin
  if not Assigned(ADB) then
    ADB := g_FileDB;

  LOrm := GetJHPFilesFromTaskID(AID, ADB);
  try
    if LOrm.FillRewind then
    begin
      while LOrm.FillOne do
      begin
        if LOrm.SavedFileName <> '' then
          DeleteFileFromDiskByName(LOrm.SavedFileName);
      end;
    end;
  finally
    LOrm.Free;
  end;

  ADB.ExecuteFmt('Delete from % where TaskID = ?',[TOrmJHPFile.SQLTableName],[AID]);
end;

function DeleteJHPFilesFromDBByFileID(const AFileID: TTimeLog; ADB: TRestClientDB): Boolean;
begin
  if not Assigned(ADB) then
    ADB := g_FileDB;

  ADB.Delete(TOrmJHPFile, 'FileID = ?', [AFileID]);

//  ADB.ExecuteFmt('Delete from % where FileID = ?',[TOrmJHPFile.SQLTableName],[AID]);
end;

function SaveJHPFile2DB(ADBName, ASaveFileName: string; AID: TID;
  ADocType: integer): Boolean;
//var
//  LDBFile: string;
//  LJHPFiles: TOrmJHPFile;
//  LJHPFileRec: TJHPFileRec;
//  LDoc: RawByteString;
//  LFileDBClient: TFileDBClient;
begin
//  if not FileExists(ASaveFileName) then
//    exit;
//
//  ADBName := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db') + ADBName;
//  LFileDBClient := TFileDBClient.Create;
//  LFileDBClient.InitDB(ADBName);
//  try
//    LJHPFiles := GetJHPFilesFromTaskID(AID, LFileDBClient.Client);
//    LDoc := StringFromFile(ASaveFileName);
//    ASaveFileName := ExtractFileName(ASaveFileName);
//
//    LJHPFileRec.fData := LDoc;
//    LJHPFileRec.fDocFormat := ADocType;
//    LJHPFileRec.fFilename := ASaveFileName;
//    LJHPFileRec.fFileSize := Length(LDoc);
//
//    LJHPFiles.DynArray('Files').Add(LJHPFileRec);
//
//    if High(LJHPFiles.Files) >= 0 then
//    begin
//      LFileDBClient.Client.Delete(TOrmJHPFile, LJHPFiles.ID);
//      LJHPFiles.TaskID := AID;
//      LFileDBClient.Client.Add(LJHPFiles, true);
//    end;
//  finally
//    LFileDBClient.FinalizeDB;
//  end;
end;

function GetDefaultInvoiceFileName(AFileKind: TJHPFileFormat; AInvNo: string): string;
begin
  case AFileKind of
    gfkNull: ;
    gfkPDF: Result := 'c:\temp\Invoice_VDR_APT_' + AInvNo + '.pdf';
    gfkEXCEL: Result := 'c:\temp\Invoice_VDR_APT_' + AInvNo + '.ods';
    gfkWORD: ;
    gfkPPT: ;
    gfkPJH: ;
    gfkPJH2: ;
    gfkPJH3: ;
    gfkPng: ;
    gfkJpg: ;
    gfkFinal: ;
  end;
end;

function GetFilesFromOrmByKeyID(const AKeyID: TTimeLog; ADB: TRestClientDB): TOrmJHPFile;
begin
  Result := GetJHPFilesFromTaskID(AKeyID, ADB);
end;

function GetFiles2JsonAryFromOrmByID(const AKeyID: TTimeLog; ADB: TRestClientDB; AIsIncludeDiskFile: Boolean): RawUtf8;
var
  LOrm: TOrmJHPFile;
  LList: IDocList;
//  LDict: IDocDict;
  LJson: RawUtf8;
begin
  Result := '';
  LList := DocList('[]');

  LOrm := GetJHPFilesFromTaskID(AKeyID, ADB);

  if LOrm.FillRewind then
  begin
    while LOrm.FillOne do
    begin
      case TJHPFileSaveKind(LOrm.fFileSaveKind) of
        fskBase64:;
        fskBlob:;
        fskDisk: begin
          if FileExists(LOrm.SavedFileName) then
          begin
            LOrm.Data := MakeRawUTF8ToBin64(StringFromFile(LOrm.SavedFileName));
          end;
        end;
      end;//case

      LJson := LOrm.GetJsonValues(true, false, soSelect);
//      LDict := DocDict(LJson);
      LList.Append(LJson)
    end;//while

    Result := LList.Json;
  end;
end;

procedure AssignJHPFileRec2Orm(const ASrcRec: TJHPFileRec; out ADestOrm: TOrmJHPFile);
begin
  ADestOrm.TaskID := ASrcRec.fTaskID;
  ADestOrm.FileID := ASrcRec.fFileID;
  ADestOrm.Filename := ASrcRec.fFilename;
  ADestOrm.DocFormat := ASrcRec.fDocFormat;
  ADestOrm.FileFromSource := ASrcRec.fFileFromSource;
  ADestOrm.FileSaveKind := ASrcRec.fFileSaveKind;
  ADestOrm.SavedFileName := ASrcRec.fSavedFileName;
  ADestOrm.FileSize := ASrcRec.fFileSize;
  ADestOrm.CompressAlgo := ASrcRec.fCompressAlgo;
  ADestOrm.FilePath := ASrcRec.fFilePath;
  ADestOrm.FileDesc := ASrcRec.fFileDesc;
  ADestOrm.BaseDir := ASrcRec.fBaseDir;
  ADestOrm.Data := ASrcRec.fData;
  ADestOrm.BlobData := ASrcRec.fBlobData;
end;
initialization

finalization
  DestroyJHPFile;

end.
