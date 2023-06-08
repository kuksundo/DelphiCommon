unit UnitJHPFileData;

interface

uses
  Classes, System.SysUtils,
  mormot.core.base, mormot.core.data, mormot.core.json, mormot.core.variants,
  UnitEnumHelper;

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
    fFilename: RawUTF8;
    fDocFormat: integer;
    fFileSize: integer;
    fData: RawByteString;
    fFilePath: RawUTF8;
  end;

  TJHPFileRecs = array of TJHPFileRec;

  TJHPFileFormat = (gfkNull, gfkPDF, gfkEXCEL, gfkWORD, gfkPPT, gfkPJH, gfkPJH2, gfkPJH3,
    gfkPng, gfkJpg, gfkFinal);

const
  R_JHPFileFormat : array[Low(TJHPFileFormat)..High(TJHPFileFormat)] of string =
    ('', 'PDF', 'MSEXCEL', 'MSWORD', 'MSPPT', 'PJH', 'PJH2', 'PJH3', 'PNG', 'JPG', '');

var
  g_JHPFileFormat: TLabelledEnum<TJHPFileFormat>;

function MakeGSFileRecs2JSON(ASQLGSFiles: TSQLGSFileRecs): RawUTF8;
function MakeJHPFileRecs2JSON(AJHPFiles: TJHPFileRecs): RawUTF8;
function GetJHPFileFormatFromFileName(const AFileName: string): TJHPFileFormat;

implementation

//VDR File¿¡¸¸ »ç¿ëµÊ
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
  if POS('.XLS', LExt) <> 0 then
    result := gfkEXCEL
  else
  if POS('.PDF', LExt) <> 0 then
    result := gfkPDF
  else
  if LExt = '.PJH2' then
    result := gfkPJH2
  else
//  if LExt = '.PJH' then
    result := gfkPJH
end;

//initialization
//  g_JHPFileFormat.InitArrayRecord(R_JHPFileFormat);

end.
