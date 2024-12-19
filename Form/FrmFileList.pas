unit FrmFileList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitFrameFileList2, UnitJHPFileData;

type
  TFileListF = class(TForm)
    FileListFrame1: TJHPFileListFrame;
  private
  public
  end;

  function CreatFileListForm(AList: TStrings=nil): integer;

var
  FileListF: TFileListF;

implementation

{$R *.dfm}

function CreatFileListForm(AList: TStrings): integer;
var
  LResult: integer;
begin
  Result := 0;

  if not Assigned(FileListF) then
    FileListF := TFileListF.Create(nil);

  try
    LResult := FileListF.ShowModal;

    if LResult = mrOK then
    begin
      if Assigned(AList) then
      begin
//        for LResult := Low(FileListF.FileListFrame1.FJHPFiles_.Files) to High(FileListF.FileListFrame1.FJHPFiles_.Files) do
//          AList.Add(FileListF.FileListFrame1.FJHPFiles_.Files[LResult].fFilePath +
//            FileListF.FileListFrame1.FJHPFiles_.Files[LResult].fFileName);

        Result := AList.Count;
      end;
    end;
  finally
    FreeAndNil(FileListF);
  end;
end;

end.
