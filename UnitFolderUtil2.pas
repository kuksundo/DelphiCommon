unit UnitFolderUtil2;

interface

uses Windows, sysutils, Classes, Forms,
  mormot.core.base, mormot.core.unicode, mormot.core.os;

function GetSubFolderPath(ARootFolder, ASubFolder: string): string;
function GetDefaultDBPath: string;
function GetFolderPathFromEmailPath(AEmailPath: RawUTF8): RawUTF8;
function GetParentFolder(AChildFolder: string): string;
function IsRootFolder(const AFolder: string): Boolean;

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

//AChildFolder = 반드시 '\'가 포함된 Path임
function GetParentFolder(AChildFolder: string): string;
begin
  if AChildFolder <> '' then
    Result := ExtractFilePath(ExcludeTrailingPathDelimiter(AChildFolder));
end;

function IsRootFolder(const AFolder: string): Boolean;
var
  NormalizePath: string;
begin
  NormalizePath := IncludeTrailingPathDelimiter(ExpandFileName(AFolder));

  Result := ExtractFilePath(NormalizePath) = NormalizePath;
end;

end.

