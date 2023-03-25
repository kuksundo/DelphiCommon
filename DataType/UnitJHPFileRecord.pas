unit UnitJHPFileRecord;

interface

uses
  Classes, System.SysUtils,
  mormot.core.base, mormot.orm.core, mormot.rest.client, mormot.core.os,
  mormot.rest.sqlite3,
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
    fFiles: TJHPFileRecs;
  public
    fIsUpdate: Boolean;
    property IsUpdate: Boolean read fIsUpdate write fIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property Files: TJHPFileRecs read fFiles write fFiles;
  end;

procedure InitJHPFileClient(AExeName: string = '');
function InitJHPFileClient2(ADBName: string; var AModel: TOrmModel): TRestClientDB;
function CreateJHPFilesModel: TOrmModel;
procedure DestroyJHPFile;

function GetJHPFilesFromID(const AID: TID; ADB: TRestClientDB=nil): TOrmJHPFile;
function GetJHPFiles(ADB: TRestClientDB=nil): TOrmJHPFile;
//procedure LoadJHPFileRecFromVariant(var ASQLJHPFileRec: TOrmJHPFileRec; ADoc: variant);
procedure AddOrUpdateJHPFiles(AOrmJHPFile: TOrmJHPFile; ADB: TRestClientDB=nil);
function DeleteJHPFilesFromTaskID(const AID: TID; ADB: TRestClientDB=nil): Boolean;
function SaveJHPFile2DB(ADBName, ASaveFileName: string; AID: TID;
  ADocType: integer): Boolean;
function GetDefaultInvoiceFileName(AFileKind: TJHPFileFormat; AInvNo: string): string;

var
  g_FileDB: TRestClientDB;//TRestClientURI;
  FileModel: TOrmModel;

implementation

uses UnitFolderUtil2, Forms, UnitOrmFileClient;

procedure InitJHPFileClient(AExeName: string);
var
  LStr: string;
begin
  LStr := ChangeFileExt(ExtractFileName(AExeName),'.sqlite');
  LStr := LStr.Replace('.sqlite', '_Files.sqlite');
  AExeName := GetSubFolderPath(ExtractFilePath(AExeName), 'db');
  AExeName := EnsureDirectoryExists(AExeName);
  LStr := AExeName + LStr;
  FileModel := CreateJHPFilesModel;
  g_FileDB:= TRestClientDB.Create(FileModel, CreateJHPFilesModel,
    LStr, TRestServerDB);
  g_FileDB.Server.CreateMissingTables;
end;

function InitJHPFileClient2(ADBName: string; var AModel: TOrmModel): TRestClientDB;
var
  LStr: string;
begin
  if ADBName = '' then
  begin
    ADBName := ChangeFileExt(ExtractFileName(Application.ExeName),'_Files.sqlite');
    LStr := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
    ADBName := LStr + ADBName;
  end
  else
  begin
    LStr := ExtractFilePath(ADBName);

    if LStr = '' then
      ADBName := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db') + ADBName;
  end;

  AModel:= CreateJHPFilesModel;
  Result := TRestClientDB.Create(AModel, CreateJHPFilesModel,
    ADBName, TRestServerDB);
  Result.Server.CreateMissingTables;
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

function GetJHPFilesFromID(const AID: TID; ADB: TRestClientDB): TOrmJHPFile;
begin
  if not Assigned(ADB) then
    ADB := g_FileDB;

  Result := TOrmJHPFile.Create(ADB.Orm, 'TaskID = ?', [AID]);
  Result.IsUpdate := Result.FillOne;

  if not Result.IsUpdate then
    Result.fTaskID := AID;
end;

function GetJHPFiles(ADB: TRestClientDB): TOrmJHPFile;
begin
  if not Assigned(ADB) then
    ADB := g_FileDB;

  Result := TOrmJHPFile.Create(ADB.Orm, 'TaskID <> ?', [-1]);
  Result.IsUpdate := Result.FillOne;
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

function DeleteJHPFilesFromTaskID(const AID: TID; ADB: TRestClientDB): Boolean;
begin
  if not Assigned(ADB) then
    ADB := g_FileDB;

  ADB.ExecuteFmt('Delete from % where TaskID = ?',[TOrmJHPFile.SQLTableName],[AID]);
end;

function SaveJHPFile2DB(ADBName, ASaveFileName: string; AID: TID;
  ADocType: integer): Boolean;
var
  LDBFile: string;
  LJHPFiles: TOrmJHPFile;
  LJHPFileRec: TJHPFileRec;
  LDoc: RawByteString;
  LFileDBClient: TFileDBClient;
begin
  if not FileExists(ASaveFileName) then
    exit;

  ADBName := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db') + ADBName;
  LFileDBClient := TFileDBClient.Create;
  LFileDBClient.InitDB(ADBName);
  try
    LJHPFiles := GetJHPFilesFromID(AID, LFileDBClient.Client);
    LDoc := StringFromFile(ASaveFileName);
    ASaveFileName := ExtractFileName(ASaveFileName);

    LJHPFileRec.fData := LDoc;
    LJHPFileRec.fDocFormat := ADocType;
    LJHPFileRec.fFilename := ASaveFileName;
    LJHPFileRec.fFileSize := Length(LDoc);

    LJHPFiles.DynArray('Files').Add(LJHPFileRec);

    if High(LJHPFiles.Files) >= 0 then
    begin
      LFileDBClient.Client.Delete(TOrmJHPFile, LJHPFiles.ID);
      LJHPFiles.TaskID := AID;
      LFileDBClient.Client.Add(LJHPFiles, true);
    end;
  finally
    LFileDBClient.FinalizeDB;
  end;
end;

function GetDefaultInvoiceFileName(AFileKind: TJHPFileFormat; AInvNo: string): string;
begin
  case AFileKind of
    gfkEXCEL: Result := 'c:\temp\Invoice_VDR_APT_' + AInvNo + '.ods';
    gfkPDF: Result := 'c:\temp\Invoice_VDR_APT_' + AInvNo + '.pdf';
  end;
end;

initialization

finalization
  DestroyJHPFile;

end.
