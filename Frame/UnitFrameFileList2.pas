unit UnitFrameFileList2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Winapi.Activex, WinApi.ShellAPI, Vcl.Menus,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.ExtCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, JvExControls, JvLabel, Vcl.ImgList, FrmFileSelect,
  DragDropInternet,DropSource,DragDropFile,DragDropFormats, DragDrop, DropTarget,
  mormot.core.base, mormot.core.os, mormot.core.text,
  UnitJHPFileRecord, UnitJHPFileData;

type
  TJHPFileListFrame = class(TFrame)
    JvLabel13: TJvLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    FileName: TNxTextColumn;
    FileSize: TNxTextColumn;
    FilePath: TNxTextColumn;
    DocType: TNxTextColumn;
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
    procedure ApplyButtonClick(Sender: TObject);
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
  public
    FJHPFiles_: TOrmJHPFile;
    FItemID, FTaskID: TID;
    FTaskJson: String;
    FModalResult: integer;

    FIgnoreFileTypePrompt: Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitDragDrop;
    procedure InitDocTypeList2Combo(ADocTypeList: TStrings);
    procedure LoadFiles2Grid(AIDList: TIDList4JHPFile); overload;
    procedure LoadFiles2Grid; overload;
    procedure JHPFileCopy(ASrc: TOrmJHPFile; out ADest: TOrmJHPFile);
    procedure JHPFileRec2Grid(ARec: TJHPFileRec; ADynIndex: integer;
      AGrid: TNextGrid);
    procedure AddJHPFileRec2JHPFiles(ARec: TJHPFileRec);
    procedure DeleteFileFromGrid(ARow: integer=-1);
    procedure DeleteFileFromGrid2DB;
  end;

implementation

uses UnitDragUtil, UnitStringUtil, UnitNextGridUtil2;//UnitElecServiceData,

{$R *.dfm}

{ TFrame2 }

procedure TJHPFileListFrame.AddButtonClick(Sender: TObject);
begin
//  ShowFileSelectF2;
  ShowFileSelectF3;
end;

procedure TJHPFileListFrame.DeleteButtonClick(Sender: TObject);
var
  li : integer;
begin
  DeleteFileFromGrid(fileGrid.SelectedRow);
end;

procedure TJHPFileListFrame.DeleteFile1Click(Sender: TObject);
begin
  DeleteFileFromGrid(FileGrid.SelectedRow);
end;

procedure TJHPFileListFrame.DeleteFileFromGrid(ARow: integer);
begin
  if ARow = -1 then
    ARow := fileGrid.SelectedRow;

  if ARow = -1 then
    exit;

  with fileGrid do
  begin
    if CellByName['FileName', ARow].AsString <> '' then
    begin
      if MessageDlg('Aru you sure delete the selected item?.', mtConfirmation, [mbYes, mbNo],0) = mrYes then
      begin
        if Assigned(FJHPFiles_) then
        begin
          FJHPFiles_.DynArray('Files').Delete(ARow);
        end;
      end;

        FileGrid.RowVisible[ARow] := False;
//      DeleteRow(SelectedRow);
    end;
  end;
end;

procedure TJHPFileListFrame.DeleteFileFromGrid2DB;
var
  i, li, LID: integer;
begin
  with FileGrid do
  begin
    for i := RowCount - 1 downto 0 do
    begin
      if not RowVisible[i] then
      begin
        if not(CellByName['FileName',SelectedRow].AsString = '') then
        begin
          if Assigned(FJHPFiles_) then
          begin
            li := Row[i].ImageIndex;
            FJHPFiles_.DynArray('Files').Delete(li);
          end;
        end;

        DeleteRow(i);
      end;//if
    end;//for
  end;//with
end;

procedure TJHPFileListFrame.AddJHPFileRec2JHPFiles(ARec: TJHPFileRec);
//var
//  LDynArr: TDynArray;
begin
  if not Assigned(FJHPFiles_) then
    FJHPFiles_ := TOrmJHPFile.Create;

  FJHPFiles_.DynArray('Files').Add(ARec);
//  LDynArr.Init(TypeInfo(TJHPFileRecs), FJHPFiles_.Files);
//  LDynArr.Add(ARec);
//  FJHPFiles_.Files[High(FJHPFiles_.Files)] := ARec;
end;

procedure TJHPFileListFrame.ApplyButtonClick(Sender: TObject);
begin
  FModalResult := mrOK;
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
  FJHPFiles_ := nil;
//  g_GSDocType.InitArrayRecord(R_GSDocType);
end;

destructor TJHPFileListFrame.Destroy;
var
  i: integer;
begin
  if Assigned(FJHPFiles_) then
    FJHPFiles_.Free;

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
  LFileName: string;
  LFromOutlook: Boolean;
  LTargetStream: TStream;
begin
  LFileName := '';
  // 윈도우 탐색기에서 Drag 했을 경우
  if (FileDataAdapter4Target.DataFormat is TFileDataFormat) then
  begin
    LFileName := (FileDataAdapter4Target.DataFormat as TFileDataFormat).Files.Text;

    if LFileName <> '' then
    begin
      FFileContent := StringFromFile(LFileName);
      LFromOutlook := False;
    end;
  end
  else// OutLook에서 첨부파일을 Drag 했을 경우
  if FileDataAdapter4Target.DataFormat is TVirtualFileStreamDataFormat then
  begin
    if (TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat).FileNames.Count > 0) then
    begin
      LFileName := TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat).FileNames[0];

      LTargetStream := GetStreamFromDropDataFormat(TVirtualFileStreamDataFormat(VirtualDataAdapter4Target.DataFormat));
      try
        if not Assigned(LTargetStream) then
          ShowMessage('Not Assigned');

        FFileContent := StreamToRawByteString(LTargetStream);
        LFromOutlook := True;
      finally
        if Assigned(LTargetStream) then
          LTargetStream.Free;
      end;
    end;
  end;

  if LFileName <> '' then
  begin
    LFileName.Replace('"','');
    ShowFileSelectF3(LFileName, LFromOutlook);
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
  LFileRec: PJHPFileRec;
  LData: RawByteString;
begin
  if ARow = -1 then
    exit;

  if High(FJHPFiles_.Files) >= ARow then
  begin
    LFileName := 'C:\Temp\'+FileGrid.CellByName['FileName', ARow].AsString;
    FTempFileList.Add(LFileName);
    LData := FJHPFiles_.Files[ARow].fData;
//    LFileRec := PSQLInvoiceFileRec(FileGrid.Row[ARow].Data);
    FileFromString(LData, LFileName, True);

    ShellExecute(handle,'open', PChar(LFileName),nil,nil,SW_NORMAL);
    NextGridScrollToRow(FileGrid);
  end;
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

procedure TJHPFileListFrame.JHPFileRec2Grid(ARec: TJHPFileRec; ADynIndex: integer;
  AGrid: TNextGrid);
var
  LRow: integer;
begin
  with AGrid do
  begin
    LRow := AddRow();
    Row[LRow].ImageIndex := ADynIndex; //DynArray의 Index를 저장함(Delete시 필요함)

    CellByName['FileName',LRow].AsString := ARec.fFilename;
    CellByName['FileSize',LRow].AsString := FormatByteString(ARec.fFileSize);
    CellByName['FilePath',LRow].AsString := ARec.fFilePath;
    CellByName['DocType',LRow].AsString := IntToStr(ARec.fDocFormat);
  end;
//  AGrid.Row[LRow].Data := TIDList4Invoice.Create;
//  TIDList4Invoice(AGrid.Row[LRow].Data).ItemAction := -1;
//  AGrid.Row[LRow].ImageIndex := ADynIndex;
//  AGrid.CellByName['FileName', LRow].AsString := ARec.fFilename;
//  AGrid.CellByName['FileSize',LRow].AsString := FormatByteString(ARec.fFileSize);
//  AGrid.CellByName['DocType', LRow].AsString := GSInvoiceItemType2String(ARec.fGSInvoiceItemType);
end;

procedure TJHPFileListFrame.InitDocTypeList2Combo(ADocTypeList: TStrings);
begin
  FDocTypeList.Assign(ADocTypeList);
end;

procedure TJHPFileListFrame.InitDragDrop;
begin
  (VirtualDataAdapter4Source.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;//OnGetStream2;
end;

procedure TJHPFileListFrame.LoadFiles2Grid;
var
  LRow: integer;
begin
  FileGrid.BeginUpdate;
  try
    FileGrid.ClearRows;

    for LRow := Low(FJHPFiles_.Files) to High(FJHPFiles_.Files) do
    begin
      JHPFileRec2Grid(FJHPFiles_.Files[LRow], LRow, FileGrid);
    end;
  finally
    FileGrid.EndUpdate;
  end;
end;

procedure TJHPFileListFrame.LoadFiles2Grid(AIDList: TIDList4JHPFile);
var
//  LSQLGSFileRec: TJHPFileRec;
  LRow: integer;
begin
  FTaskID := AIDList.TaskId;

  FileGrid.BeginUpdate;
  try
    FileGrid.ClearRows;

    for LRow := Low(FJHPFiles_.Files) to High(FJHPFiles_.Files) do
    begin
      JHPFileRec2Grid(FJHPFiles_.Files[LRow], LRow, FileGrid);
    end;
  finally
    FileGrid.EndUpdate;
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
          if Assigned(FJHPFiles_) then
          begin
            Data := FJHPFiles_.Files[i].fData;
            Found := True;
            break;
          end;
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

procedure TJHPFileListFrame.ShowFileSelectF(AFileName: string; AFromOutLook: Boolean);
var
  LRow : integer;
  lfilename, lfilepath : String;
  lExt : String;
//  lSize : int64;
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

          LJHPFileRec.fData := LDoc;
          LJHPFileRec.fFilename := lfilename;
          LJHPFileRec.fFilePath := lfilepath;
          LJHPFileRec.fFileSize := Length(LDoc);

          if not Assigned(FJHPFiles_) then
            FJHPFiles_ := TOrmJHPFile.Create;

          i := FJHPFiles_.DynArray('Files').Add(LJHPFileRec);

          JHPFileRec2Grid(LJHPFileRec, i, fileGrid);

//          LRow := AddRow;
//          Row[LRow].ImageIndex := i; //DynArray의 Index를 저장함(Delete시 필요함)
//
//          CellByName['FileName',LRow].AsString := lfilename;
//          CellByName['FileSize',LRow].AsString := FormatByteString(LJHPFileRec.fFileSize);
//          CellByName['FilePath',LRow].AsString := lfilepath;
//          CellByName['DocType',LRow].AsString := LFileSelectF.DocTypeCombo.Text;
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
  lExt : String;
//  lSize : int64;
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

            LJHPFileRec.fData := LDoc;
            LJHPFileRec.fDocFormat := LFileSelectF.DocTypeCombo.ItemIndex;
//            LJHPFileRec.fGSDocType := g_GSDocType.ToOrdinal(LFileSelectF.DocTypeCombo.Text);
            LJHPFileRec.fFilename := LFileName;
            LJHPFileRec.fFilePath := lfilepath;
            LJHPFileRec.fFileSize := Length(LDoc);//ByteLength(LDoc);//

            if not Assigned(FJHPFiles_) then
              FJHPFiles_ := TOrmJHPFile.Create;

            i := FJHPFiles_.DynArray('Files').Add(LJHPFileRec);

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
  lExt : String;
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

          LJHPFileRec.fData := LDoc;
          LJHPFileRec.fDocFormat := LDocFormat;
          LJHPFileRec.fFileName := LFileName;
          LJHPFileRec.fFilePath := LFilePath;
          LJHPFileRec.fFileSize := Length(LDoc);//ByteLength(LDoc);//

          if not Assigned(FJHPFiles_) then
            FJHPFiles_ := TOrmJHPFile.Create;

          i := FJHPFiles_.DynArray('Files').Add(LJHPFileRec);

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

procedure TJHPFileListFrame.JHPFileCopy(ASrc: TOrmJHPFile;
  out ADest: TOrmJHPFile);
var
  LRow: integer;
  LJHPFileRec: TJHPFileRec;
begin
  while ASrc.FillOne do
  begin
    for LRow := Low(ASrc.Files) to High(ASrc.Files) do
    begin
      LJHPFileRec.fFilename := ASrc.Files[LRow].fFilename;
      LJHPFileRec.fFilePath := ASrc.Files[LRow].fFilePath;
      LJHPFileRec.fDocFormat := ASrc.Files[LRow].fDocFormat;
      LJHPFileRec.fData := ASrc.Files[LRow].fData;

      ADest.DynArray('Files').Add(LJHPFileRec);
    end;
  end;
end;

procedure TJHPFileListFrame.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  InitDragDrop;
//  (VirtualDataAdapter4Source.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;
end;

end.
