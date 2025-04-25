unit UnitFileInfoUtil_mormot2;

interface

uses Winapi.Windows, System.Classes, System.SysUtils, System.DateUtils,
  mormot.core.os;

function GetBuildDateByExecutable(): TDateTime;
function GetCommentByExecutable(): string;
function GetInternalNameByExecutable(): string;
//function GetFileVersionByExecutable(const AFileName: string): string;
//function GetFileVersionListByExecutableFromFolder(const AFolder: string; const AIsOnlyExeDll: Boolean = true): TStringList;
//AList : Full Path FileName List
//결과값은 FilaName = version 포맷으로 반환 함
//function GetFileVersionListByExecutableFromList(AList: TStringList): integer;

implementation

function GetBuildDateByExecutable(): TDateTime;
begin
  Result := Executable.Version.BuildDateTime;
end;

function GetCommentByExecutable(): string;
begin
  Result := Executable.Version.Comments;
end;

function GetInternalNameByExecutable(): string;
begin
  Result := Executable.Version.InternalName;
end;

end.
