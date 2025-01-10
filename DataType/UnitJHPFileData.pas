unit UnitJHPFileData;

interface

uses
  Classes, System.SysUtils,
  mormot.core.base, mormot.core.data, mormot.core.json, mormot.core.variants,
  mormot.core.os, mormot.core.datetime,
  UnitEnumHelper;

const
  MIN_BLOB_SIZE = 2000000; //1MB�̻��̸� BlobData�� �����ϱ� ���� �ּ� ũ��
  MIN_DISK_SIZE = 2000000; //2MB�̻��̸� Disk�� �����ϱ� ���� �ּ� ũ��

type
  PSQLGSFileRec = ^TSQLGSFileRec;
  TSQLGSFileRec = Packed Record
    fFilename: RawUTF8;
    fGSDocType: integer;//TGSDocType;
    fFileSize: integer;
    fData: RawByteString;
  end;

  TSQLGSFileRecs = array of TSQLGSFileRec;

  PJHPFileRec = ^TJHPFileRec;
  TJHPFileRec = Packed Record
    fTaskID,
    fFileID: TID;
    fFilename,
    fSavedFileName: RawUTF8;
    fFileFromSource, //1: from outlook attached
    fFileSaveKind,   //TJHPFileSaveKind
    fDocFormat: integer;
    fFileSize: int64;
    fCompressAlgo: integer;
    fData: RawUTF8;
    fBlobData: RawByteString;
    fBaseDir,
    fFilePath,
    fFileDesc //���� ����
    : RawUTF8;
  end;

  TJHPFileRecs = array of TJHPFileRec;

  TJHPDragFileRec = packed record
    fFileNameList: string;
    fIsFromOutlook,
    fIsMail
    : Boolean;
  end;

  TJHPFileFormat = (gfkNull, gfkPDF, gfkEXCEL, gfkWORD, gfkPPT, gfkPJH, gfkPJH2, gfkPJH3,
    gfkPng, gfkJpg, gfkOLMAIL, gfkFinal);

  TJHPFileSaveKind = (fskBase64, //Base64�� ��ȯ�Ͽ� Data Field�� ������
                      fskBlob,   //RawByteString ���� BlobData Field�� ������
                      fskDisk,   //���� �̸��� �����Ͽ� Folder�� ������
                      fskFinal);

const
  R_JHPFileFormat : array[Low(TJHPFileFormat)..High(TJHPFileFormat)] of string =
    ('', 'PDF', 'MSEXCEL', 'MSWORD', 'MSPPT', 'PJH', 'PJH2', 'PJH3', 'PNG', 'JPG', 'MSG','');

var
  g_JHPFileFormat: TLabelledEnum<TJHPFileFormat>;

function MakeGSFileRecs2JSON(ASQLGSFiles: TSQLGSFileRecs): RawUTF8;
function MakeJHPFileRecs2JSON(AJHPFiles: TJHPFileRecs): RawUTF8;
function GetJHPFileFormatFromFileName(const AFileName: string): TJHPFileFormat;
function GetFileExtFromFileFormat(AFileFormat:TJHPFileFormat; AIsSenondFormat: Boolean=False): string;
function GetFileContentsFromDiskByName(const AFileName: string): RawByteString;

procedure SetFileSaveKind2JHPFileRec(var ARec: TJHPFileRec);
function GetFolderPath4SaveKind(const ABaseDir: string): string;

procedure DeleteFileFromDiskByName(const AFN: string);

implementation

uses UnitFolderUtil2;

//VDR File���� ����
function MakeGSFileRecs2JSON(ASQLGSFiles: TSQLGSFileRecs): RawUTF8;
var
  LRow: integer;
  LSQLGSFileRec: TSQLGSFileRec;
  LUtf8: RawUTF8;
  LVar: variant;
  LDynUtf8File: TRawUTF8DynArray;
  LDynArrFile: TDynArray;
begin
  LDynArrFile.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8File);

  for LRow := Low(ASQLGSFiles) to High(ASQLGSFiles) do
  begin
    LSQLGSFileRec := ASQLGSFiles[LRow];
    LUtf8 := RecordSaveJson(LSQLGSFileRec, TypeInfo(TSQLGSFileRec));
    LDynArrFile.Add(LUtf8);
  end;

  LVar := _JSON(LDynArrFile.SaveToJSON);
  Result := LVar;
end;

function MakeJHPFileRecs2JSON(AJHPFiles: TJHPFileRecs): RawUTF8;
var
  LRow: integer;
  LJHPFileRec: TJHPFileRec;
  LUtf8: RawUTF8;
  LVar: variant;
  LDynUtf8File: TRawUTF8DynArray;
  LDynArrFile: TDynArray;
begin
  LDynArrFile.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8File);

  for LRow := Low(AJHPFiles) to High(AJHPFiles) do
  begin
    LJHPFileRec := AJHPFiles[LRow];
    LUtf8 := RecordSaveJson(LJHPFileRec, TypeInfo(TJHPFileRec));
    LDynArrFile.Add(LUtf8);
  end;

  LVar := _JSON(LDynArrFile.SaveToJSON);
  Result := LVar;
end;

function GetJHPFileFormatFromFileName(const AFileName: string): TJHPFileFormat;
var
  LExt: string;
begin
  LExt := System.SysUtils.UpperCase(ExtractFileExt(AFileName));

  if POS('.DOC', LExt) <> 0 then
    result := gfkWORD
  else
  if POS('.PPT', LExt) <> 0 then
    result := gfkPPT
  else
  if (POS('.XLS', LExt) <> 0) or (POS('.XLSX', LExt) <> 0) then
    result := gfkEXCEL
  else
  if POS('.PDF', LExt) <> 0 then
    result := gfkPDF
  else
  if LExt = '.PJH2' then
    result := gfkPJH2
  else
  if LExt = '.MSG' then
    result := gfkOLMAIL
  else
//  if LExt = '.PJH' then
    result := gfkPJH
end;

function GetFileExtFromFileFormat(AFileFormat:TJHPFileFormat; AIsSenondFormat: Boolean): string;
begin
  Result := '';

  case AFileFormat of
    gfkWORD, gfkPJH: Result := 'doc';
    gfkPDF: Result := 'pdf';
    gfkPPT, gfkPJH2: begin
      if AIsSenondFormat then
        Result := 'pjh2'
      else
        Result := 'ppt';
    end;
  end;
end;

function GetFileContentsFromDiskByName(const AFileName: string): RawByteString;
begin
  Result := '';

  if not FileExists(AFileName) then
    exit;

  Result := StringFromFile(AFileName);
end;

procedure SetFileSaveKind2JHPFileRec(var ARec: TJHPFileRec);
begin
  //ARec.fFileFromSource = 1 �� ��쿡�� FileSaveKind�� fskDisk�϶��� FileContents�� ARec.fData�� ������
  if ARec.fFileSize > MIN_DISK_SIZE then
  begin
    ARec.fFileSaveKind := Ord(fskDisk);
    ARec.fSavedFileName := GetFolderPath4SaveKind(ARec.fBaseDir) + IntToStr(TimeLogFromDateTime(now)) + '.jhp';
  end
  else
  if ARec.fFileSize > MIN_BLOB_SIZE then
    ARec.fFileSaveKind := Ord(fskBlob)
  else
    ARec.fFileSaveKind := Ord(fskBase64)
end;

function GetFolderPath4SaveKind(const ABaseDir: string): string;
begin
  Result := GetSubFolderPath(ABaseDir, 'jhpfiles');
end;

procedure DeleteFileFromDiskByName(const AFN: string);
begin
  if FileExists(AFN) then
    DeleteFile(AFN);
end;

//initialization
//  g_JHPFileFormat.InitArrayRecord(R_JHPFileFormat);

end.
