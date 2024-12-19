unit UnitFrameFileList2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Winapi.Activex, WinApi.ShellAPI, Vcl.Menus,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.ExtCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, JvExControls, JvLabel, Vcl.ImgList,
  DragDropInternet,DropSource,DragDropFile,DragDropFormats, DragDrop, DropTarget,

  mormot.core.base, mormot.core.os, mormot.core.text, mormot.core.collections,
  mormot.core.datetime,

  FrmFileSelect,
  UnitJHPFileRecord, UnitJHPFileData;

type
  TJHPFileListFrame = class(TFrame)
    JvLabel13: TJvLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    FileName: TNxTextColumn;
    FileSize: TNxTextColumn;
    FilePath: TNxTextColumn;
    DocFormat: TNxTextColumn;
    Panel2: TPanel;
    CloseButton: TAdvGlowButton;
    DeleteButton: TAdvGlowButton;
    AddButton: TAdvGlowButton;
    ApplyButton: TAdvGlowButton;
    ImageList16x16: TImageList;
    DropEmptyTarget1: TDropEmptyTarget;
    VirtualDataAdapter4Target: TDataFormatAdapter;
    FileDataAdapter4Target: TDataFormatAdapter;
    DropEmptySource1: TDropEmptySource;
    VirtualDataAdapter4Source: TDataFormatAdapter;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    DeleteFile1: TMenuItem;
    FileID: TNxTextColumn;
    CompressAlgo: TNxTextColumn;
    FileSaveKind: TNxTextColumn;
    SavedFileName: TNxTextColumn;
    FileDesc: TNxTextColumn;
    FileFromSource: TNxTextColumn;
    BaseDir: TNxTextColumn;
    //Single File Drop시에 사용
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    //Multi File Drop시에 사용
    procedure DropEmptyTarget1Drop2(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure DeleteButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure fileGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure fileGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure DeleteFile1Click(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure DropEmptyTarget1Enter(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure fileGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FFileContent: RawByteString;
    FTempFileList,
    FDocTypeList: TStringList;

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);
    procedure OnGetStream2(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);
    //Drag하여 파일 추가한 경우 AFileName <> ''
    //Drag를 윈도우 탐색기에서 하면 AFromOutLook=Fase,
    //Outlook 첨부 파일에서 하면 AFromOutLook=True임
    procedure ShowFileSelectF(AFileName: string = ''; AFromOutLook: Boolean = False);
    procedure ShowFileSelectF2(AFileName: string = ''; AFromOutLook: Boolean = False);
    procedure ShowFileSelectF3(AFileName: string = ''; AFromOutLook: Boolean = False);
    procedure ShowFileSelectF4(ARec: TJHPDragFileRec);

    procedure AddFile2JHPFiles;
    procedure DeleteFile2JHPFiles;

    function GetFileDataFromGridRow(const ARow: integer): RawByteString;
    function GetDataFromDBByGridRow(const ARow: integer): RawByteString;
    function GetDataFromDragOrDiskJHPFilesByGridRow(const ARow: integer): RawByteString;
    function GetFileContentsFromDragOrDiskJHPFilesBySaveKind(const ARec: TJHPFileRec): RawByteString;
  public
    FDragOrDiskJHPFiles: IKeyValue<integer, TJHPFileRec>;
    FItemID, FTaskID: TID;
    FTaskJson: String;
    FModalResult: integer;

    FIgnoreFileTypePrompt: Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitDragDrop;
    procedure InitDocTypeList2Combo(ADocTypeList: TStrings);
    procedure LoadFiles2GridByTaskID(const ATaskID: TID);
    procedure JHPFileRec2Grid(ARec: TJHPFileRec; ADynIndex: integer;
      AGrid: TNextGrid);
    procedure OrmJHPFile2Grid(ARec: TOrmJHPFile; ARowIdx: integer; AGrid: TNextGrid);

    function IsFromDBFile(const ARow: integer): Boolean;
    function IsFromDragOrDiskFile(const ARow: integer): Boolean;

    function GetJHPFileRecFromSelectedGrid(out ARec: TJHPFileRec): Boolean;
    function GetJHPFileRecFromGridIndex(const AIdx: integer; out ARec: TJHPFileRec): integer;
    function SetNewFileContents2DBorDiskByJHPFileRec(var ARec: TJHPFileRec): TID;

    procedure AddNewFile2JHPFilesNGrid(const ANewFileName: string; const ADocFormat: integer; const AFileContents: RawByteString);
    procedure AddJHPFileRec2JHPFiles(ARec: TJHPFileRec);
    procedure DeleteSelectedFilesFromGrid();
    procedure DeleteFileFromGrid(ARow: integer=-1);
    procedure DeleteFileFromGrid2DB;

    procedure ApplyFileFromGrid2DB(const AKeyId: Int64);
    procedure ApplyDBFileFromGrid2DBByIndex(const AIndex: integer);
    function ApplyNewFileFromGrid2DBByIndex(const AIndex: integer): TID;
    procedure HideFileFromGridSelected();
    procedure HideFileFromGridByIndex(const AIndex: integer);
    procedure DeleteDBFileFromGrid2DBByIndex(const AIndex: integer);
    procedure DeleteNewFileFromGrid2FileListByIndex(const AIndex: integer);
    function AddNewFileFromGrid2DBByIndex(const AIndex: integer): TID;
  end;

implementation

uses UnitDragUtil, UnitStringUtil, UnitNextGridUtil2, UnitBase64Util2,
  UnitFolderUtil2, UnitFileUtil;

{$R *.dfm}

{ TFrame2 }

procedure TJHPFileListFrame.AddButtonClick(Sender: TObject);
var
  LDragFileRec: TJHPDragFileRec;
begin
//  ShowFileSelectF2;
  LDragFileRec := Default(TJHPDragFileRec);
  ShowFileSelectF4(LDragFileRec);
end;

procedure TJHPFileListFrame.DeleteButtonClick(Sender: TObject);
begin
//  DeleteFileFromGrid(fileGrid.SelectedRow);
  DeleteSelectedFilesFromGrid();
end;

procedure TJHPFileListFrame.DeleteFile1Click(Sender: TObject);
begin
//  DeleteFileFromGrid(FileGrid.SelectedRow);
  DeleteSelectedFilesFromGrid();
end;

procedure TJHPFileListFrame.DeleteFile2JHPFiles;
begin

end;

procedure TJHPFileListFrame.DeleteFileFromGrid(ARow: integer);
var
  LKey: integer;
begin
  if ARow = -1 then
    ARow := fileGrid.SelectedRow;

  if ARow = -1 then
    exit;

  with fileGrid do
  begin
    if CellsByName['FileName', ARow] <> '' then
    begin
      //Drag Drop으로 Grid에 추가한 파일인 경우
      if IsFromDragOrDiskFile(ARow) then
      begin
        LKey := Row[ARow].ImageIndex;
        FDragOrDiskJHPFiles.Remove(LKey);
        DeleteRow(ARow);
      end
      else
      begin
        //DB에서 Grid에 불러온 경우
        FileGrid.RowVisible[ARow] := False;
      end;
    end;
  end;
end;

procedure TJHPFileListFrame.DeleteFileFromGrid2DB;
var
  i, li: integer;
  LID: TTimeLog;
begin
  with FileGrid do
  begin
    for i := RowCount - 1 downto 0 do
    begin
      if not RowVisible[i] then
      begin
        LID := StrToInt64Def(CellsByName['FileID',i],0);

        if LID <> 0 then
        begin
          DeleteJHPFilesFromDBByFileID(LID);
        end;
      end;//if
    end;//for
  end;//with
end;

procedure TJHPFileListFrame.DeleteNewFileFromGrid2FileListByIndex(
  const AIndex: integer);
var
  LKey: integer;
begin
  LKey := FileGrid.Row[AIndex].ImageIndex;

  if FDragOrDiskJHPFiles.Remove(LKey) then
  begin
    FileGrid.DeleteRow(AIndex);
  end;
end;

procedure TJHPFileListFrame.DeleteSelectedFilesFromGrid;
var
  i: integer;
begin
  if MessageDlg('Aru you sure delete the selected item?.', mtConfirmation, [mbYes, mbNo],0) = mrYes then
  begin
    with fileGrid do
    begin
      for i := 0 to RowCount - 1 do
      begin
        if Row[i].Selected then
          DeleteFileFromGrid(i);
      end;
    end;
  end;
end;

procedure TJHPFileListFrame.DeleteDBFileFromGrid2DBByIndex
(const AIndex: integer);
var
  LFileID: Int64;
  LFileSaveKind: integer;
  LSavedFileName: string;
begin
  LFIleID := StrToInt64Def(fileGrid.CellsByName['FileID', AIndex], 0);
  LFileSaveKind := StrToIntDef(fileGrid.CellsByName['FileSaveKind', AIndex], 0);

  if TJHPFileSaveKind(LFileSaveKind) = fskDisk then
  begin
    LSavedFileName := fileGrid.CellsByName['SavedFileName', AIndex];

    if FileExists(LSavedFileName) then
      if DeleteFile(LSavedFileName) then
        DeleteJHPFilesFromDBByFileID(LFileID);
  end
  else
    DeleteJHPFilesFromDBByFileID(LFileID);
end;

procedure TJHPFileListFrame.AddFile2JHPFiles;
begin

end;

procedure TJHPFileListFrame.AddNewFile2JHPFilesNGrid(const ANewFileName: string;
  const ADocFormat: integer; const AFileContents: RawByteString);
var
  LJHPFileRec: TJHPFileRec;
  LFilePath, LFileName: string;
  LKey: integer;
begin
  LFilePath := ExtractFilePath(ANewFileName);
  LFileName := ExtractFileName(ANewFileName);

  LJHPFileRec := Default(TJHPFileRec);

  LJHPFileRec.fBaseDir := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');
  LJHPFileRec.fDocFormat := ADocFormat;
  LJHPFileRec.fFileName := LFileName;
  LJHPFileRec.fFilePath := LFilePath;

  //OutLook 첨부파일 추가가 아닌 경우 DB 저장시에만 StringFromFile() 이용함
  if AFileContents = '' then
  begin
    LJHPFileRec.fFileSize := GetFileSizeByName(LFilePath+LFileName);
  end
  else//ARec.fIsFromOutlook
  begin
  //Outlook 첨부 파일인 경우에만 fData에 파일 내용 저장함(Drop시에만 가능함)
    LJHPFileRec.fData := AFileContents;
    LJHPFileRec.fFileSize := Length(AFileContents);//ByteLength(LDoc)
  //ARec.fFileFromSource = 1 인 경우에는 FileSaveKind가 fskDisk일때도 FileContents가 ARec.fData에 존재함
    LJHPFileRec.fFileFromSource := 1;
  end;

  //fFileSize를 이용하여 ARec.fFileSaveKind, ARec.fSavedFileName field를 설정함
  SetFileSaveKind2JHPFileRec(LJHPFileRec);

  LKey := FDragOrDiskJHPFiles.Count+1;
  FDragOrDiskJHPFiles.Add(LKey, LJHPFileRec);
  //Grid.Row[].ImageIndex에 LKey를 저장함
  JHPFileRec2Grid(LJHPFileRec, LKey, fileGrid);
end;

function TJHPFileListFrame.AddNewFileFromGrid2DBByIndex(const AIndex: integer): TID;
var
  LRec: TJHPFileRec;
begin
  GetJHPFileRecFromGridIndex(AIndex, LRec);
  Result := SetNewFileContents2DBorDiskByJHPFileRec(LRec);
//  LRec.fData := GetDataFromDragOrDiskJHPFilesByGridRow(AIndex);
end;

procedure TJHPFileListFrame.AddJHPFileRec2JHPFiles(ARec: TJHPFileRec);
//var
//  LDynArr: TDynArray;
begin
//  LDynArr.Init(TypeInfo(TJHPFileRecs), FDragOrDiskJHPFiles.Files);
//  LDynArr.Add(ARec);
//  FDragOrDiskJHPFiles.Files[High(FDragOrDiskJHPFiles.Files)] := ARec;
end;

procedure TJHPFileListFrame.ApplyDBFileFromGrid2DBByIndex(
  const AIndex: integer);
begin
  with fileGrid do
  begin
    if Row[AIndex].Visible then
    begin
      //DB에 이미 존재하므로 Skip
    end
    else //DB 삭제
    begin
      DeleteDBFileFromGrid2DBByIndex(AIndex);
    end;
  end;//with
end;

procedure TJHPFileListFrame.ApplyFileFromGrid2DB(const AKeyId: Int64);
var
  i: integer;
  LAddDBCnt: integer;
begin
  LAddDBCnt := 0;
  FTaskID := AKeyId;

  with fileGrid do
  begin
    for i := 0 to RowCount - 1 do
    begin
      //신규 추가 파일임-Delete And Add
      if IsFromDragOrDiskFile(i) then
      begin
        if ApplyNewFileFromGrid2DBByIndex(i) <> -1 then
          inc(LAddDBCnt);
      end
      else //DB에서 읽어온 파일임-Delete만 실행
      begin
        ApplyDBFileFromGrid2DBByIndex(i);
      end;
//      Sleep(100);//실행 속도가 너무 빨라서 fileID가 중복될 가능성 배제하기 위함
    end; //for
  end;//with

//  ShowMessage('Added to DB count = ' + IntToStr(LAddDBCnt));
end;

function TJHPFileListFrame.ApplyNewFileFromGrid2DBByIndex(
  const AIndex: integer): TID;
begin
  Result := -1;

  with fileGrid do
  begin
    if Row[AIndex].Visible then
    begin
      Result := AddNewFileFromGrid2DBByIndex(AIndex);
    end
    else //New File 삭제
    begin
      DeleteNewFileFromGrid2FileListByIndex(AIndex);
    end;
  end;//with
end;

procedure TJHPFileListFrame.CloseButtonClick(Sender: TObject);
begin
  FModalResult := mrCancel;
end;

constructor TJHPFileListFrame.Create(AOwner: TComponent);
begin
  inherited;

  FTempFileList := TStringList.Create;
  FDocTypeList := TStringList.Create;
  FDragOrDiskJHPFiles := Collections.NewKeyValue<integer, TJHPFileRec>;
//  g_GSDocType.InitArrayRecord(R_GSDocType);
end;

destructor TJHPFileListFrame.Destroy;
var
  i: integer;
begin
  FDocTypeList.Free;

  inherited;

  try
    for i := 0 to FTempFileList.Count - 1 do
    begin
      try
        DeleteFile(FTempFileList.Strings[i]);
      except

      end;
    end;
  finally
    FTempFileList.Free;
  end;
end;

procedure TJHPFileListFrame.DropEmptyTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  i: integer;
  LDragFileRec: TJHPDragFileRec;
  LTargetStream: TStream;
begin
  LDragFileRec := Default(TJHPDragFileRec);
  // 윈도우 탐색기에서 Drag 했을 경우
  if (FileDataAdapter4Target.DataFormat is TFileDataFormat) then
  begin
    LDragFileRec.fFileNameList := (FileDataAdapter4Target.DataFormat as TFileDataFormat).Files.Text;

    if LDragFileRec.fFileNameList <> '' then
    begin
//      FFileContent := StringFromFile(LFileName);
      LDragFileRec.fIsFromOutlook := False;
    end;
  end
  else// OutLook에서 첨부파일을 Drag 했을 경우
  if FileDataAdapter4Target.DataFormat is TVirtualFileStreamDataFormat then
  begin
    if (TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat).FileNames.Count > 0) then
    begin
      LDragFileRec.fFileNameList := TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat).FileNames.Text;

      if LDragFileRec.fFileNameList <> '' then
      begin
        LDragFileRec.fIsFromOutlook := True;
      end;
//      LFileName := TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat).FileNames[0];

//      LTargetStream := GetStreamFromDropDataFormat(TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat));
//      try
//        if not Assigned(LTargetStream) then
//          ShowMessage('Not Assigned');
//
//        FFileContent := StreamToRawByteString(LTargetStream);
//        LFromOutlook := True;
//      finally
//        if Assigned(LTargetStream) then
//          LTargetStream.Free;
//      end;
    end;
  end;

  if LDragFileRec.fFileNameList <> '' then
  begin
    LDragFileRec.fFileNameList.Replace('"','');
    ShowFileSelectF4(LDragFileRec);
  end;
end;

procedure TJHPFileListFrame.DropEmptyTarget1Drop2(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  i: integer;
  LFileName: string;
  LFromOutlook: Boolean;
  LTargetStream: TStream;
begin
  LFileName := '';
  // 윈도우 탐색기에서 Drag 했을 경우
  if TFileDataFormat(FileDataAdapter4Target.DataFormat).Files.Count > 0 then
  begin
    if (FileDataAdapter4Target.DataFormat is TFileDataFormat) then
    begin
      LFileName := (FileDataAdapter4Target.DataFormat as TFileDataFormat).Files.Text;
      LFromOutlook := False;
    end;
  end
  else// OutLook에서 첨부파일을 Drag 했을 경우
  if (TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat).FileNames.Count > 0) then
  begin
    if VirtualDataAdapter4Target.DataFormat is TVirtualFileStreamDataFormat then
    begin
      LFileName := TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat).FileNames.Text;
      LFromOutlook := True;
    end;
  end;

  if LFileName <> '' then
  begin
    LFileName.Replace('"','');
//    ShowFileSelectF2(LFileName, LFromOutlook);
    ShowFileSelectF3(LFileName, LFromOutlook);
  end;
end;

procedure TJHPFileListFrame.DropEmptyTarget1Enter(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
begin
  // Reject the drop unless the source supports *both* the FileContents and
  // FileGroupDescriptor formats in the storage medium we require (IStream).
  // Normally a drop is accepted if just one of our formats is supported.
  with TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat) do
    if not(FileContentsClipboardFormat.HasValidFormats(DropEmptyTarget1.DataObject) and
      (AnsiFileGroupDescriptorClipboardFormat.HasValidFormats(DropEmptyTarget1.DataObject) or
       UnicodeFileGroupDescriptorClipboardFormat.HasValidFormats(DropEmptyTarget1.DataObject))) then
      Effect := DROPEFFECT_NONE;
end;

procedure TJHPFileListFrame.fileGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  LFileName: string;
  LData: RawByteString;
//  LFileID: TTimeLog;
  LUtf8: RawUtf8;
begin
  if ARow = -1 then
    exit;

  LFileName := 'C:\Temp\'+FileGrid.CellByName['FileName', ARow].AsString;
  FTempFileList.Add(LFileName);
//  LFileID := StrToInt64Def(FileGrid.CellsByName['FileID', ARow], 0);
//  LData := GetFileDataByFileID(LFileID);
  LData := GetFileDataFromGridRow(ARow);

  if LData = '' then
    exit;

//  LUtf8 := MakeBase64ToUTF8(LData);
//  LUtf8 := LData;
  FileFromString(LData, LFileName, True);

  ShellExecute(handle,'open', PChar(LFileName),nil,nil,SW_NORMAL);
//  NextGridScrollToRow(FileGrid);
end;

procedure TJHPFileListFrame.fileGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_delete: begin
      DeleteFileFromGrid();
    end;
  end;
end;

procedure TJHPFileListFrame.fileGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LFileName: string;
begin
  if (DragDetectPlus(fileGrid.Handle, Point(X,Y))) then
  begin
    if fileGrid.SelectedRow = -1 then
      exit;

    TVirtualFileStreamDataFormat(VirtualDataAdapter4Source.DataFormat).FileNames.Clear;

    for i := 0 to FileGrid.RowCount-1 do
    begin
      if (FileGrid.Row[i].Selected) then
      begin
        LFileName := fileGrid.CellsByName['FileName',i];
        //파일 이름에 공란이 들어가면 OnGetStream 함수를 안 탐
//      if LFileName <> '' then
        TVirtualFileStreamDataFormat(VirtualDataAdapter4Source.DataFormat).
              FileNames.Add(LFileName);
      end;
    end;

    DropEmptySource1.Execute;
  end;
end;

function TJHPFileListFrame.GetDataFromDBByGridRow(
  const ARow: integer): RawByteString;
var
  LFileID: int64;
begin
  LFileID := StrToInt64Def(FileGrid.CellsByName['FileID', ARow], 0);
  Result := GetFileDataByFileID(LFileID);
end;

function TJHPFileListFrame.GetDataFromDragOrDiskJHPFilesByGridRow(
  const ARow: integer): RawByteString;
var
  LKey: integer;
  LRec: TJHPFileRec;
begin
  Result := '';

  if Assigned(FDragOrDiskJHPFiles) then
  begin
    LKey := FileGrid.Row[ARow].ImageIndex;

    if FDragOrDiskJHPFiles.TryGetValue(LKey, LRec) then
    begin
      Result := GetFileContentsFromDragOrDiskJHPFilesBySaveKind(LRec);
    end;
  end;
end;

function TJHPFileListFrame.GetFileContentsFromDragOrDiskJHPFilesBySaveKind(const ARec: TJHPFileRec): RawByteString;
begin
  Result := '';

  //Outlook 첨부 파일은 drag시에 file contents도 FileRec.fData에 저장함
  if ARec.fFileFromSource = 1 then
  begin
    case TJHPFileSaveKind(ARec.fFileSaveKind) of
      fskBase64: Result := ARec.fData;
      fskBlob: Result := ARec.fBlobData;
      fskDisk: Result := ARec.fData;
    end;
  end
  else//탐색기에서 추가한 파일은 DB 저장 전 까지는 원본 파일에서 File Contents를 가져와야 함
  begin
    Result := GetFileContentsFromDiskByName(ARec.fFilePath + ARec.fFilename);
  end;
end;

function TJHPFileListFrame.GetFileDataFromGridRow(
  const ARow: integer): RawByteString;
begin
  Result := '';

  if IsFromDBFile(ARow) then
  begin
    Result := GetDataFromDBByGridRow(ARow);
  end
  else//신규 추가된 파일인 경우
  begin
    Result := GetDataFromDragOrDiskJHPFilesByGridRow(ARow);
  end;
end;

function TJHPFileListFrame.GetJHPFileRecFromGridIndex(const AIdx: integer;
  out ARec: TJHPFileRec): integer;
var
  LDoc: RawByteString;
  LFileName: string;
begin
  Result := 0;

  ARec := Default(TJHPFileRec);

  ARec.fFileID := StrToInt64Def(FileGrid.CellsByName['FileID', AIdx],0);
  ARec.fFilename := FileGrid.CellsByName['FileName', AIdx];
//  ARec.fFileSize := FileGrid.CellsByName['FileSize', AIdx]; //숫자가 아닌 FormatByteString으로 표시됨
  ARec.fFilePath := FileGrid.CellsByName['FilePath', AIdx];
  ARec.fDocFormat := StrToInt64Def(FileGrid.CellsByName['DocFormat', AIdx],0);
  ARec.fFileSaveKind := StrToIntDef(FileGrid.CellsByName['FileSaveKind', AIdx],0);
  ARec.fSavedFileName := FileGrid.CellsByName['SavedFileName', AIdx];
  ARec.fCompressAlgo := StrToIntDef(FileGrid.CellsByName['CompressAlgo', AIdx],0);
  ARec.fFileDesc := FileGrid.CellsByName['FileDesc', AIdx];
  ARec.fBaseDir := FileGrid.CellsByName['BaseDir', AIdx];
  ARec.fFileFromSource := StrToIntDef(FileGrid.CellsByName['FileFromSource', AIdx], 0);

//  if ARec.fFileFromSource = 1 then //from outlook 첨부 파일이면 ARec.Data에 contents 존재함
//  begin
//
//  end
//  else //Diskd 원본 파일에 contents가 존재함
//  begin
//    LFileName := ARec.fFilePath + ARec.fFilename;
//
//    if FileExists(LFileName) then
//    begin
//      LDoc := StringFromFile(LFileName);
//      ARec.fData := MakeRawByteStringToBin64(LDoc);
//      ARec.fFileSize := Length(LDoc);
//    end;
//  end;

  Result := ARec.fFileSize;
end;

function TJHPFileListFrame.GetJHPFileRecFromSelectedGrid(
  out ARec: TJHPFileRec): Boolean;
begin
  Result := False;

  if fileGrid.SelectedRow <> -1 then
  begin
    Result := GetJHPFileRecFromGridIndex(fileGrid.SelectedRow, ARec) > 0;
  end;
end;

procedure TJHPFileListFrame.HideFileFromGridSelected;
var
  i: integer;
begin
  with fileGrid do
  begin
    for i := 0 to RowCount - 1 do
    begin
      if Row[i].Selected then
      begin
        HideFileFromGridByIndex(i);
      end;
    end; //for
  end;//with
end;

procedure TJHPFileListFrame.HideFileFromGridByIndex(const AIndex: integer);
begin
  with fileGrid do
    if CellsByName['FileName', AIndex] <> '' then
    begin
      RowVisible[AIndex] := False;
    end;
end;

procedure TJHPFileListFrame.JHPFileRec2Grid(ARec: TJHPFileRec; ADynIndex: integer;
  AGrid: TNextGrid);
var
  LRow: integer;
begin
  with AGrid do
  begin
    LRow := AddRow();
    Row[LRow].ImageIndex := ADynIndex; //DynArray의 Index를 저장함(Delete시 필요함)

    CellByName['FileID',LRow].AsString := IntToStr(ARec.fFileID);//신규FileID = 0임
    CellByName['FileName',LRow].AsString := ARec.fFilename;
    CellByName['FileSize',LRow].AsString := FormatByteString(ARec.fFileSize);
    CellByName['FilePath',LRow].AsString := ARec.fFilePath;
    CellByName['DocFormat',LRow].AsString := IntToStr(ARec.fDocFormat);
    CellByName['FileSaveKind',LRow].AsString := IntToStr(ARec.fFileSaveKind);
    CellByName['SavedFileName',LRow].AsString := ARec.fSavedFileName;
    CellByName['FileDesc',LRow].AsString := ARec.fFileDesc;
    CellByName['CompressAlgo',LRow].AsString := IntToStr(ARec.fCompressAlgo);
    CellByName['FileFromSource',LRow].AsString := IntToStr(ARec.fFileFromSource);
    CellByName['BaseDir',LRow].AsString := ARec.fBaseDir;
    CellByName['FileDesc',LRow].AsString := ARec.fFileDesc;
  end;
end;

procedure TJHPFileListFrame.InitDocTypeList2Combo(ADocTypeList: TStrings);
begin
  FDocTypeList.Assign(ADocTypeList);
end;

procedure TJHPFileListFrame.InitDragDrop;
begin
  (VirtualDataAdapter4Source.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;//OnGetStream2;
end;

function TJHPFileListFrame.IsFromDBFile(const ARow: integer): Boolean;
begin
  Result := FileGrid.CellsByName['FileID', ARow] <> '0';
end;

function TJHPFileListFrame.IsFromDragOrDiskFile(const ARow: integer): Boolean;
begin
  Result := FileGrid.CellsByName['FileID', ARow] = '0';
end;

procedure TJHPFileListFrame.LoadFiles2GridByTaskID(const ATaskID: TID);
var
//  LRow: integer;
  LOrm: TOrmJHPFile;
begin
  LOrm := GetJHPFilesFromID(ATaskID);
  try
    if LOrm.IsUpdate then
    begin
      if LOrm.FillRewind then
      begin
        FileGrid.BeginUpdate;
        try
          FileGrid.ClearRows;

          while LOrm.FillOne do
          begin
//            LRow := FileGrid.AddRow();
            OrmJHPFile2Grid(LOrm, 0, FileGrid);
          end;
        finally
          FileGrid.EndUpdate;
        end;
      end;
    end;
  finally
    LOrm.Free;
  end;
end;

procedure TJHPFileListFrame.OnGetStream(
  Sender: TFileContentsStreamOnDemandClipboardFormat; Index: integer;
  out AStream: IStream);
var
  Stream: TMemoryStream;
  Data: AnsiString;
  i: integer;
  SelIndex: integer;
  Found: boolean;
begin
  Stream := TMemoryStream.Create;
  try
    AStream := nil;
    SelIndex := 0;
    Found := False;

    for i := 0 to FileGrid.RowCount-1 do
      if (FileGrid.Row[i].Selected) then
      begin
        if (SelIndex = Index) then
        begin
          Data := GetFileDataFromGridRow(i);
          Found := Data <> '';
          break;
//          if IsFromDBFile(i) then
//          begin
//            Data := GetDataFromDBByGridRow(i);
//            Found := Data <> '';
//            break;
//          end
//          else//신규 추가된 파일인 경우
//          begin
//            Data := GetDataFromDragOrDiskJHPFilesByGridRow(i);
//            Found := Data <> '';
//            break;
//          end;
        end;
        inc(SelIndex);
      end;

    if (not Found) then
      exit;

    Stream.Write(PAnsiChar(Data)^, Length(Data));
    AStream := TFixedStreamAdapter.Create(Stream, soOwned);
  except
    Stream.Free;
    raise;
  end;
end;

procedure TJHPFileListFrame.OnGetStream2(
  Sender: TFileContentsStreamOnDemandClipboardFormat; Index: integer;
  out AStream: IStream);
var
  LStream: TStringStream;
begin
  LStream := TStringStream.Create;
  try
    LStream.WriteString(FTaskJson);
    AStream := nil;
    AStream := TFixedStreamAdapter.Create(LStream, soOwned);
  except
    raise;
  end;
end;

procedure TJHPFileListFrame.OrmJHPFile2Grid(ARec: TOrmJHPFile; ARowIdx: integer;
  AGrid: TNextGrid);
var
  LRow: integer;
begin
  with AGrid do
  begin
    LRow := AddRow();
    Row[LRow].ImageIndex := ARowIdx; //DynArray의 Index를 저장함(Delete시 필요함)

    CellByName['FileID',LRow].AsString := IntToStr(ARec.FileID);//신규FileID = 0임
    CellByName['FileName',LRow].AsString := ARec.Filename;
    CellByName['FileSize',LRow].AsString := FormatByteString(ARec.FileSize);
    CellByName['FilePath',LRow].AsString := ARec.FilePath;
    CellByName['DocFormat',LRow].AsString := IntToStr(ARec.DocFormat);
    CellByName['FileSaveKind',LRow].AsString := IntToStr(ARec.FileSaveKind);
    CellByName['SavedFileName',LRow].AsString := ARec.SavedFileName;
    CellByName['FileDesc',LRow].AsString := ARec.FileDesc;
    CellByName['CompressAlgo',LRow].AsString := IntToStr(ARec.CompressAlgo);
    CellByName['FileFromSource',LRow].AsString := IntToStr(ARec.FileFromSource);
    CellByName['BaseDir',LRow].AsString := ARec.BaseDir;
    CellByName['FileDesc',LRow].AsString := ARec.FileDesc;
  end;
end;

function TJHPFileListFrame.SetNewFileContents2DBorDiskByJHPFileRec(var ARec: TJHPFileRec): TID;
var
  LOriginFN: string;
begin
  Result := -1;

  ARec.fFileID := TimeLogFromDateTime(now)+Random(100);
  ARec.fTaskID := FTaskID;

  LOriginFN := ARec.fFilePath + ARec.fFilename;

  if ARec.fSavedFileName <> '' then
  begin
    //ARec.fFileFromSource = 1 인 경우에는 FileSaveKind가 fskDisk일때도 FileContents가 ARec.fData에 존재함
    if ARec.fFileFromSource = 1 then
    begin
      if TJHPFileSaveKind(ARec.fFileSaveKind) = fskDisk then
      begin
        if not FileFromString(ARec.fData, ARec.fSavedFileName) then
          exit;//복사 실패 시 DB 저장 Skip

        ARec.fFileSize := Length(ARec.fData);
        ARec.fData := '';
      end;
    end
    else//탐색기에서 추가한 파일은 DB 저장 전 까지는 원본 파일에서 File Contents를 가져와야 함
    begin
      if CopyFile(LOriginFN, ARec.fSavedFileName, False) then
        ARec.fFileSize := GetFileSizeByName(LOriginFN)
      else
      begin
        ShowMessage('File Copy Fail ' + #13#10 + 'From <' + LOriginFN + '>' + #13#10 +'To <' + ARec.fSavedFileName + '>');
        exit;//복사 실패 시 DB 저장 Skip
      end;
    end;
  end
  else
  begin
    if FileExists(LOriginFN) then
    begin
      ARec.fData := MakeRawByteStringToBin64(StringFromFile(LOriginFN));
      ARec.fFileSize := GetFileSizeByName(LOriginFN);
     end
    else
    begin
      ShowMessage('File dos not exist : ' + LOriginFN);
      exit;//파일이 존재하지 않으면 DB 저장 Skip
    end;
  end;

  Result := AddOrUpdate2DBByJHPFileRec(ARec);
end;

procedure TJHPFileListFrame.ShowFileSelectF(AFileName: string; AFromOutLook: Boolean);
var
  LRow : integer;
  lfilename, lfilepath : String;
  LFileSelectF: TFileSelectF;
  LJHPFileRec: TJHPFileRec;
  LDoc: RawByteString;
  i: integer;
begin
  LFileSelectF := TFileSelectF.Create(nil);
  try
    //Drag 했을 경우 AFileName <> ''이고
    //Task Edit 화면에서 추가 버튼을 눌렀을 경우 AFileName = ''임
    if AFileName <> '' then
      LFileSelectF.JvFilenameEdit1.FileName := AFileName;

    LFileSelectF.DocTypeCombo.Visible := False;
    LFileSelectF.Label1.Visible := False;

    if LFileSelectF.ShowModal = mrOK then
    begin
      if LFileSelectF.JvFilenameEdit1.FileName = '' then
        exit;

      lfilename := ExtractFileName(LFileSelectF.JvFilenameEdit1.FileName);
      lfilepath := ExtractFilePath(LFileSelectF.JvFilenameEdit1.FileName);

      with fileGrid do
      begin
        BeginUpdate;
        try
          if AFileName <> '' then
            LDoc := FFileContent
          else
            LDoc := StringFromFile(LFileSelectF.JvFilenameEdit1.FileName);

          LJHPFileRec := Default(TJHPFileRec);
          LJHPFileRec.fData := LDoc;
          LJHPFileRec.fFilename := lfilename;
          LJHPFileRec.fFilePath := lfilepath;
          LJHPFileRec.fFileSize := Length(LDoc);

          i := FDragOrDiskJHPFiles.Count+1000;
          FDragOrDiskJHPFiles.Add(i, LJHPFileRec);
          JHPFileRec2Grid(LJHPFileRec, i, fileGrid);
        finally
          EndUpdate;
        end;
      end;
    end;
  finally
    LFileSelectF.Free;
  end;
end;

procedure TJHPFileListFrame.ShowFileSelectF2(AFileName: string;
  AFromOutLook: Boolean);
var
  li,LRow : integer;
  lfilename, lfilepath : String;
  LFileSelectF: TFileSelectF;
  LJHPFileRec: TJHPFileRec;
  LDoc: RawByteString;
  i: integer;
  LFileNameList: TStringList;
  LTargetStream: TStream;
begin
  LFileSelectF := TFileSelectF.Create(nil);
  LFileNameList := TStringList.Create;
  try
    //Drag 했을 경우 AFileName <> ''이고
    //Task Edit 화면에서 추가 버튼을 눌렀을 경우 AFileName = ''임
    if AFileName <> '' then
    begin
      LFileNameList.Text := AFileName;
      LFileSelectF.JvFilenameEdit1.FileName := AFileName;
    end;

//    g_GSDocType.SetType2Combo(LFileSelectF.DocTypeCombo);

    if LFileSelectF.ShowModal = mrOK then
    begin
      if LFileSelectF.JvFilenameEdit1.FileName = '' then
        exit
      else
        LFileNameList.Text := LFileSelectF.JvFilenameEdit1.FileName;

      with fileGrid do
      begin
        BeginUpdate;
        try
          for li := 0 to LFileNameList.Count - 1 do
          begin
            LFileName := LFileNameList.Strings[li];

            if AFromOutLook then
            begin
              LTargetStream := GetStreamFromDropDataFormat2(TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat),li);
              try
                if not Assigned(LTargetStream) then
                  ShowMessage('Not Assigned');

                LDoc := StreamToRawByteString(LTargetStream);
              finally
                if Assigned(LTargetStream) then
                  LTargetStream.Free;
              end;
            end
            else
              LDoc := StringFromFile(LFileName);

            lfilepath := ExtractFilePath(LFileName);
            LFileName := ExtractFileName(LFileName);

            LJHPFileRec := Default(TJHPFileRec);
            LJHPFileRec.fData := LDoc;
            LJHPFileRec.fDocFormat := LFileSelectF.DocTypeCombo.ItemIndex;
//            LJHPFileRec.fGSDocType := g_GSDocType.ToOrdinal(LFileSelectF.DocTypeCombo.Text);
            LJHPFileRec.fFilename := LFileName;
            LJHPFileRec.fFilePath := lfilepath;
            LJHPFileRec.fFileSize := Length(LDoc);//ByteLength(LDoc);//

            i := FDragOrDiskJHPFiles.Count;
            FDragOrDiskJHPFiles.Add(i, LJHPFileRec);
            JHPFileRec2Grid(LJHPFileRec, i, fileGrid);

//            LRow := AddRow;
//            Row[LRow].ImageIndex := i; //DynArray의 Index를 저장함(Delete시 필요함)
//
//            CellByName['FileName',LRow].AsString := LFileName;
//            CellByName['FileSize',LRow].AsString := FormatByteString(LJHPFileRec.fFileSize);
//            CellByName['FilePath',LRow].AsString := lfilepath;
//            CellByName['DocType',LRow].AsString := LFileSelectF.DocTypeCombo.Text;
          end;

        finally
          EndUpdate;
        end;
      end;
    end;
  finally
    LFileNameList.Free;
    LFileSelectF.Free;
  end;
end;

procedure TJHPFileListFrame.ShowFileSelectF3(AFileName: string; AFromOutLook: Boolean);
var
  lfilename, lfilepath : String;
  LFileSelectF: TFileSelectF;
  LJHPFileRec: TJHPFileRec;
  LDoc: RawByteString;
  i, LDocFormat: integer;
  LFileNameList: TStringList;
  LTargetStream: TStream;

  procedure _DisplayFileList2Grid();
  var
    li: integer;
  begin
    with fileGrid do
    begin
      BeginUpdate;
      try
        for li := 0 to LFileNameList.Count - 1 do
        begin
          LFileName := LFileNameList.Strings[li];

          if AFromOutLook then
          begin
            LTargetStream := GetStreamFromDropDataFormat2(TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat),li);
            try
              if not Assigned(LTargetStream) then
                ShowMessage('Not Assigned');

              LDoc := StreamToRawByteString(LTargetStream);
            finally
              if Assigned(LTargetStream) then
                LTargetStream.Free;
            end;
          end
          else
            LDoc := StringFromFile(LFileName);

          LFilePath := ExtractFilePath(LFileName);
          LFileName := ExtractFileName(LFileName);

          LJHPFileRec := Default(TJHPFileRec);

          LJHPFileRec.fData := LDoc;
          LJHPFileRec.fDocFormat := LDocFormat;
          LJHPFileRec.fFileName := LFileName;
          LJHPFileRec.fFilePath := LFilePath;
          LJHPFileRec.fFileSize := Length(LDoc);//ByteLength(LDoc);//

          i := FDragOrDiskJHPFiles.Count+1;
          FDragOrDiskJHPFiles.Add(i, LJHPFileRec);
          JHPFileRec2Grid(LJHPFileRec, i, fileGrid);
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
begin
  LFileSelectF := nil;
  LFileNameList := TStringList.Create;
  try
    //Drag 했을 경우 AFileName <> ''이고
    //Task Edit 화면에서 추가 버튼을 눌렀을 경우 AFileName = ''임
    if AFileName <> '' then
    begin
      LFileNameList.Text := AFileName;
    end;

    if FIgnoreFileTypePrompt then
    begin
      LDocFormat := 0;
      _DisplayFileList2Grid();
    end
    else
    begin
      LFileSelectF := TFileSelectF.Create(nil);
      try
        if LFileSelectF.ShowModal = mrOK then
        begin
          if AFileName <> '' then
          begin
            LFileSelectF.JvFilenameEdit1.FileName := AFileName;
            LFileSelectF.JvFilenameEdit1.DialogFiles.Text := AFileName;
          end;

          LDocFormat := LFileSelectF.DocTypeCombo.ItemIndex;

          if LFileSelectF.JvFilenameEdit1.FileName = '' then
            exit
          else
            LFileNameList.Text := LFileSelectF.JvFilenameEdit1.DialogFiles.Text;

          _DisplayFileList2Grid();
        end;
      finally
        LFileSelectF.Free;
      end;
    end;
  finally
    LFileNameList.Free;
  end;
end;

procedure TJHPFileListFrame.ShowFileSelectF4(ARec: TJHPDragFileRec);
var
  lfilename, lfilepath : String;
  LFileSelectF: TFileSelectF;
  LDoc: RawByteString;
  i, LDocFormat: integer;
  LFileNameList: TStringList;
  LTargetStream: TStream;

  procedure _DisplayFileList2Grid();
  var
    li: integer;
  begin
    with fileGrid do
    begin
      BeginUpdate;
      try
        for li := 0 to LFileNameList.Count - 1 do
        begin
          LFileName := LFileNameList.Strings[li];

          if ARec.fIsFromOutlook then
          begin
            LDoc := '';

            LTargetStream := GetStreamFromDropDataFormat2(TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat),li);
            try
              if not Assigned(LTargetStream) then
                ShowMessage('Not Assigned');

              LDoc := StreamToRawByteString(LTargetStream);
            finally
              if Assigned(LTargetStream) then
                LTargetStream.Free;
            end;
          end
          else
            LDoc := '';//StringFromFile(LFileName);


          AddNewFile2JHPFilesNGrid(LFileName, LDocFormat, LDoc);
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
begin
  LFileSelectF := nil;
  LFileNameList := TStringList.Create;
  try
    //Drag 했을 경우 AFileName <> ''이고
    //Task Edit 화면에서 추가 버튼을 눌렀을 경우 AFileName = ''임
    if ARec.fFileNameList <> '' then
    begin
      LFileNameList.Text := ARec.fFileNameList;
    end;

    if FIgnoreFileTypePrompt then
    begin
      LDocFormat := 0;
      _DisplayFileList2Grid();
    end
    else
    begin
      LFileSelectF := TFileSelectF.Create(nil);
      try
        if LFileSelectF.ShowModal = mrOK then
        begin
          if ARec.fFileNameList <> '' then
          begin
            LFileSelectF.JvFilenameEdit1.FileName := ARec.fFileNameList;
            LFileSelectF.JvFilenameEdit1.DialogFiles.Text := ARec.fFileNameList;
          end;

          LDocFormat := LFileSelectF.DocTypeCombo.ItemIndex;

          if LFileSelectF.JvFilenameEdit1.FileName = '' then
            exit
          else
            LFileNameList.Text := LFileSelectF.JvFilenameEdit1.DialogFiles.Text;

          _DisplayFileList2Grid();
        end;
      finally
        LFileSelectF.Free;
      end;
    end;
  finally
    LFileNameList.Free;
  end;
end;

procedure TJHPFileListFrame.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  InitDragDrop;
//  (VirtualDataAdapter4Source.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;
end;

end.
