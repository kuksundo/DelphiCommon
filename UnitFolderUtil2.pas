unit UnitFolderUtil2;

interface

uses Windows, sysutils, Classes, Forms,
  mormot.core.base, mormot.core.unicode, mormot.core.os;

function GetSubFolderPath(ARootFolder, ASubFolder: string): string;
function GetDefaultDBPath: string;
function GetFolderPathFromEmailPath(AEmailPath: RawUTF8): RawUTF8;
function GetFileListFromFolder(Path, Mask: string; IncludeSubDir: boolean; Attr: integer = faAnyFile - faDirectory): TStringList;
function GetParentFolder(AChildFolder: string): string;

implementation

function GetSubFolderPath(ARootFolder, ASubFolder: string): string;
begin
  Result := IncludeTrailingBackSlash(ARootFolder);
  Result := IncludeTrailingBackSlash(Result + ASubFolder);
  EnsureDirectoryExists(Result);
end;

function GetDefaultDBPath: string;
begin
  Result := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
end;

function GetFolderPathFromEmailPath(AEmailPath: RawUTF8): RawUTF8;
var
  LStr: string;
begin
  LStr := Utf8ToString(AEmailPath);
  LStr.Replace('\\', '');
  LStr := IncludeTrailingPathDelimiter(LStr);
  Result := StringToUTF8(LStr);
end;

function GetFileListFromFolder(Path, Mask: string; IncludeSubDir: boolean; Attr: integer = faAnyFile - faDirectory): TStringList;
var
  FindResult: integer;
  SearchRec : TSearchRec;
begin
  result := TStringList.Create;
  result.Sorted := True;
  try
    Path := IncludeTrailingPathDelimiter(Path);
    FindResult := FindFirst(Path + Mask, Attr, SearchRec);
    while FindResult = 0 do
    begin
      { do whatever you'd like to do with the files found }
      result.Add(Path + SearchRec.Name);
      FindResult := FindNext(SearchRec);
    end;
    { free memory }
    FindClose(SearchRec);

    if not IncludeSubDir then
      Exit;

    FindResult := FindFirst(Path + '*.*', faDirectory, SearchRec);
    while FindResult = 0 do
    begin
      if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        GetFileListFromFolder (Path + SearchRec.Name + '\', Mask, TRUE);

      FindResult := FindNext(SearchRec);
    end;
    { free memory }
    FindClose(SearchRec);
  finally
//    result.CustomSort(StringListAnsiCompareDesc);
//    result.Sorted := True;
  end;
end;

//AChildFolder = 반드시 '\'가 포함된 Path임
function GetParentFolder(AChildFolder: string): string;
begin
  if AChildFolder <> '' then
    Result := ExtractFilePath(ExcludeTrailingPathDelimiter(AChildFolder));
end;

end.

