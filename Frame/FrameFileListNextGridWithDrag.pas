unit FrameFileListNextGridWithDrag;

interface
//Search Path:
//E:\pjh\Dev\Lang\Delphi\Common\DataType;
//E:\pjh\Dev\Lang\Delphi\Common\DataType\MAPI;
//E:\pjh\Dev\Lang\Delphi\Common\Form;
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Winapi.Activex, WinApi.ShellAPI, Vcl.Menus, ComObj,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.ExtCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, JvExControls, JvLabel, Vcl.ImgList,
  DragDropInternet,DropSource,DragDropFile,DragDropFormats, DragDrop, DropTarget,
  DragDropGraphics, DragDropPIDL, DragDropText,

  mormot.core.base, mormot.core.os, mormot.core.text, mormot.core.collections,
  mormot.core.datetime,
  MapiDefs,

  FrmFileSelect,
  UnitJHPFileData;

type
  TOnTargetDrop = procedure (Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer; AFileName: string; AFromOutLook: Boolean) of object;

  TOLMessage = class(TObject)
  private
    FMessage: IMessage;
    FStorage: IStorage;
    FAttachments: TInterfaceList;
    FAttachmentsLoaded: boolean;
    function GetAttachments: TInterfaceList;
  public
    constructor Create(const AMessage: IMessage; const AStorage: IStorage);
    destructor Destroy; override;
    procedure SaveToStream(Stream: TStream);
    property Msg: IMessage read FMessage;
    property Attachments: TInterfaceList read GetAttachments;
  end;

  TFileListGridFr = class(TFrame)
    AttachmentLabel: TJvLabel;
    fileGrid: TNextGrid;
    NxIncrementCol: TNxIncrementColumn;
    FileSize: TNxTextColumn;
    FilePath: TNxTextColumn;
    DocFormat: TNxTextColumn;
    FileID: TNxTextColumn;
    CompressAlgo: TNxTextColumn;
    FileSaveKind: TNxTextColumn;
    SavedFileName: TNxTextColumn;
    FileDesc: TNxTextColumn;
    FileFromSource: TNxTextColumn;
    BaseDir: TNxTextColumn;
    Panel2: TPanel;
    CloseButton: TAdvGlowButton;
    DeleteButton: TAdvGlowButton;
    AddButton: TAdvGlowButton;
    ApplyButton: TAdvGlowButton;
    DropEmptyTarget1: TDropEmptyTarget;
    VirtualDataAdapter4Target: TDataFormatAdapter;
    FileDataAdapter4Target: TDataFormatAdapter;
    DropEmptySource1: TDropEmptySource;
    VirtualDataAdapter4Source: TDataFormatAdapter;
    PopupMenu1: TPopupMenu;
    DeleteFile1: TMenuItem;
    OutlookDataAdapter4Target: TDataFormatAdapter;
    FileName: TNxButtonColumn;
    IsNew: TNxCheckBoxColumn;
    IsDelete: TNxCheckBoxColumn;
    IsUpdate: TNxCheckBoxColumn;

    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure DeleteFile1Click(Sender: TObject);
  private
    FFileContent: RawByteString;
    FTempFileList,
    FDocTypeList: TStringList;
    FHasMessageSession: boolean;
    //Key : FilePath + FileName
    FDragOrDiskJHPFiles: IKeyValue<string, TJHPFileRec>;
    FIgnoreFileTypePrompt: Boolean;
    FOnBeforeTargetDrop,
    FOnAfterTargetDrop: TOnTargetDrop;

    procedure OnGetStream(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);
    procedure OnGetStream2(Sender: TFileContentsStreamOnDemandClipboardFormat;
      Index: integer; out AStream: IStream);

    procedure DeleteSelectedFilesFromGrid();
    procedure DeleteFileFromGrid(ARow: integer=-1);
    function CheckExistNSetDeleteFlag2JHFilesDictByKey(const AKey: string; const AIsDelete: Boolean; out AJHPFileRec: TJHPFileRec): Boolean;
    procedure AddNewFile2JHPFilesNGrid(const ANewFileName: string; ADocFormat: integer; const AFileContents: RawByteString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitDragDrop;

    procedure SetVisibleAttachmentLabel(const AIsVisible: Boolean);
    procedure SetVisibleFileSizeColInGrid(const AIsVisible: Boolean);
    procedure SetVisibleFileIDColInGrid(const AIsVisible: Boolean);
    procedure SetVisibleIncColInGrid(const AIsVisible: Boolean);

    procedure SetOnBeforeTargetDrop(AOnTargetDrop: TOnTargetDrop);
    procedure SetOnAfterTargetDrop(AOnTargetDrop: TOnTargetDrop);

    procedure JHPFileRec2Grid(ARec: TJHPFileRec; ADynIndex: integer;
      AGrid: TNextGrid);
    procedure ShowFileSelectF4AddBtn(ARec: TJHPDragFileRec);
    procedure ShowFileSelectF(AFileName: string = ''; AFromOutLook: Boolean = False);
  end;

implementation

uses MapiUtil, MapiTags,
  UnitDragUtil, UnitStringUtil, UnitNextGridUtil2, UnitBase64Util2,
  UnitFolderUtil2, UnitFileUtil;

{$R *.dfm}

type
  TMAPIINIT_0 =
    record
      Version: ULONG;
      Flags: ULONG;
    end;

  PMAPIINIT_0 = ^TMAPIINIT_0;
  TMAPIINIT = TMAPIINIT_0;
  PMAPIINIT = ^TMAPIINIT;

const
  MAPI_INIT_VERSION = 0;
  MAPI_MULTITHREAD_NOTIFICATIONS = $00000001;
  MAPI_NO_COINIT = $00000008;

var
  MapiInit: TMAPIINIT_0 = (Version: MAPI_INIT_VERSION; Flags: 0);

{ TFrame1 }

procedure TFileListGridFr.AddButtonClick(Sender: TObject);
//var
//  LDragFileRec: TJHPDragFileRec;
begin
//  LDragFileRec := Default(TJHPDragFileRec);
  ShowFileSelectF();
end;

procedure TFileListGridFr.AddNewFile2JHPFilesNGrid(const ANewFileName: string;
  ADocFormat: integer; const AFileContents: RawByteString);
var
  LJHPFileRec: TJHPFileRec;
  LFilePath, LFileName: string;
  LKey: integer;
begin
  LFilePath := ExtractFilePath(ANewFileName);
  LFileName := ExtractFileName(ANewFileName);

  LJHPFileRec := Default(TJHPFileRec);

//  LJHPFileRec.fBaseDir := GetSubFolderPath(ExtractFilePath(Application.ExeName), 'db');

  if ADocFormat = -1 then
    ADocFormat := Ord(GetJHPFileFormatFromFileName(ANewFileName));

  LJHPFileRec.fDocFormat := ADocFormat;
  LJHPFileRec.fFileName := LFileName;
  LJHPFileRec.fFilePath := LFilePath;

  //OutLook 첨부파일 추가가 아닌 경우 DB 저장시에만 StringFromFile() 이용함
  if AFileContents = '' then
  begin
    LJHPFileRec.fFileSize := GetFileSizeByName(ANewFileName);
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

  FDragOrDiskJHPFiles.Add(ANewFileName, LJHPFileRec);
  LKey := FDragOrDiskJHPFiles.Count+1;
  //Grid.Row[].ImageIndex에 LKey를 저장함
  JHPFileRec2Grid(LJHPFileRec, LKey, fileGrid);
end;

function TFileListGridFr.CheckExistNSetDeleteFlag2JHFilesDictByKey(
  const AKey: string; const AIsDelete: Boolean; out AJHPFileRec: TJHPFileRec): Boolean;
var
  i: integer;
begin
  Result := FDragOrDiskJHPFiles.TryGetValue(AKey, AJHPFileRec);

  if Result then
  begin
    i := FDragOrDiskJHPFiles.FindKeyIndex(AKey);

    if AIsDelete then
      AJHPFileRec.fIsDelete := AIsDelete
    else
    begin
      //삭제된 파일이면 Reset함
      if AJHPFileRec.fIsDelete then
      begin
        AJHPFileRec.fIsDelete := AIsDelete;
      end;
    end;

    FDragOrDiskJHPFiles.Items[AKey] := AJHPFileRec;
  end;
end;

constructor TFileListGridFr.Create(AOwner: TComponent);
begin
  inherited;

  FTempFileList := TStringList.Create;
  FDocTypeList := TStringList.Create;
  FDragOrDiskJHPFiles := Collections.NewKeyValue<string, TJHPFileRec>;
end;

procedure TFileListGridFr.DeleteButtonClick(Sender: TObject);
begin
  DeleteSelectedFilesFromGrid();
end;

procedure TFileListGridFr.DeleteFile1Click(Sender: TObject);
begin
  DeleteSelectedFilesFromGrid();
end;

procedure TFileListGridFr.DeleteFileFromGrid(ARow: integer);
var
  LIdx: integer;
  LFulPathFileName: string;
  LJHPFileRec: TJHPFileRec;
begin
  if ARow = -1 then
    ARow := fileGrid.SelectedRow;

  if ARow = -1 then
    exit;

  with fileGrid do
  begin
    if not CellByName['IsDelete',ARow].AsBoolean then
    begin
      LFulPathFileName := CellsByName['FilePath', ARow] + CellsByName['FileName', ARow];
      ChangeRowFontColorByIndex(fileGrid, ARow, clRed, True, True);
      CheckExistNSetDeleteFlag2JHFilesDictByKey(LFulPathFileName, True, LJHPFileRec);
    end;
  end;
end;

procedure TFileListGridFr.DeleteSelectedFilesFromGrid;
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

destructor TFileListGridFr.Destroy;
var
  i: integer;
begin
  FDocTypeList.Free;

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

  inherited;
end;

procedure TFileListGridFr.DropEmptyTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  i, LEffect: integer;
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

  LEffect := 0;

  if Assigned(FOnBeforeTargetDrop) then
    FOnBeforeTargetDrop(Sender, ShiftState, APoint, LEffect, LFileName, LFromOutlook);

  if LEffect <> -1 then
  begin
    if LFileName <> '' then
    begin
      LFileName.Replace('"','');
      FIgnoreFileTypePrompt := True;
      ShowFileSelectF(LFileName, LFromOutlook);
      FIgnoreFileTypePrompt := False;
    end;
  end;

  if Assigned(FOnAfterTargetDrop) then
    FOnAfterTargetDrop(Sender, ShiftState, APoint, LEffect, LFileName, LFromOutlook);
end;

procedure TFileListGridFr.InitDragDrop;
begin
  (VirtualDataAdapter4Source.DataFormat as TVirtualFileStreamDataFormat).OnGetStream := OnGetStream;//OnGetStream2;
end;

procedure TFileListGridFr.JHPFileRec2Grid(ARec: TJHPFileRec; ADynIndex: integer;
  AGrid: TNextGrid);
var
  LRow: integer;
begin
  with AGrid do
  begin
    if ADynIndex > RowCount then
      LRow := AddRow()
    else
      LRow := ADynIndex-1;

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
    CellByName['IsNew',LRow].AsBoolean := ARec.fIsNew;
    CellByName['IsDelete',LRow].AsBoolean := ARec.fIsDelete;
    CellByName['IsUpdate',LRow].AsBoolean := ARec.fIsUpdate;

    if ARec.fIsDelete then
      ChangeRowFontColorByIndex(AGrid, LRow, clRed, True, True)
    else
      ChangeRowFontColorByIndex(AGrid, LRow, clBlack, False, False)
  end;
end;

procedure TFileListGridFr.OnGetStream(
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
//          Data := GetFileDataFromGridRow(i);
          Found := Data <> '';
          break;
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

procedure TFileListGridFr.OnGetStream2(
  Sender: TFileContentsStreamOnDemandClipboardFormat; Index: integer;
  out AStream: IStream);
var
  LStream: TStringStream;
begin
  LStream := TStringStream.Create;
  try
//    LStream.WriteString(FTaskJson);
    AStream := nil;
    AStream := TFixedStreamAdapter.Create(LStream, soOwned);
  except
    raise;
  end;
end;

procedure TFileListGridFr.SetOnAfterTargetDrop(AOnTargetDrop: TOnTargetDrop);
begin
  FOnAfterTargetDrop := AOnTargetDrop;
end;

procedure TFileListGridFr.SetOnBeforeTargetDrop(AOnTargetDrop: TOnTargetDrop);
begin
  FOnBeforeTargetDrop := AOnTargetDrop;
end;

procedure TFileListGridFr.SetVisibleAttachmentLabel(const AIsVisible: Boolean);
begin
  AttachmentLabel.Visible := AIsVisible;
end;

procedure TFileListGridFr.SetVisibleFileIDColInGrid(const AIsVisible: Boolean);
begin
  SetColVisibleByColNameFromGrid(fileGrid, 'FileID', AIsVisible);
end;

procedure TFileListGridFr.SetVisibleFileSizeColInGrid(const AIsVisible: Boolean);
begin
  SetColVisibleByColNameFromGrid(fileGrid, 'FileSize', AIsVisible);
end;

procedure TFileListGridFr.SetVisibleIncColInGrid(const AIsVisible: Boolean);
begin
  SetColVisibleByColNameFromGrid(fileGrid, 'NxIncrementCol', AIsVisible);
end;

procedure TFileListGridFr.ShowFileSelectF4AddBtn(ARec: TJHPDragFileRec);
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

          if not FDragOrDiskJHPFiles.ContainsKey(LFileName) then
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

      if FIgnoreFileTypePrompt then
      begin
        LDocFormat := 0;
        _DisplayFileList2Grid();
        exit;
      end
    end;

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
  finally
    LFileNameList.Free;
  end;
end;

procedure TFileListGridFr.ShowFileSelectF(AFileName: string;
  AFromOutLook: Boolean);
var
  lfilename, lfilepath, LFullPathFileName : String;
  LFileSelectF: TFileSelectF;
  LJHPFileRec: TJHPFileRec;
  LDoc: RawByteString;
  LDocFormat: integer;
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
          LFullPathFileName := LFileNameList.Strings[li];

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

          LJHPFileRec := Default(TJHPFileRec);

          LFilePath := ExtractFilePath(LFullPathFileName);
          LFileName := ExtractFileName(LFullPathFileName);

          if CheckExistNSetDeleteFlag2JHFilesDictByKey(LFullPathFileName, False, LJHPFileRec) then
          begin
          end
          else
          begin
            LJHPFileRec.fData := LDoc;
            LJHPFileRec.fDocFormat := LDocFormat;
            LJHPFileRec.fFileName := LFileName;
            LJHPFileRec.fFilePath := LFilePath;
            LJHPFileRec.fFileSize := Length(LDoc);//ByteLength(LDoc);//

            LJHPFileRec.fFileID := FDragOrDiskJHPFiles.Count+1;
            FDragOrDiskJHPFiles.Add(LFullPathFileName, LJHPFileRec);
          end;

          JHPFileRec2Grid(LJHPFileRec, LJHPFileRec.fFileID, fileGrid);
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

{ TOLMessage }

constructor TOLMessage.Create(const AMessage: IMessage;
  const AStorage: IStorage);
begin

end;

destructor TOLMessage.Destroy;
begin

  inherited;
end;

function TOLMessage.GetAttachments: TInterfaceList;
begin

end;

procedure TOLMessage.SaveToStream(Stream: TStream);
begin

end;

end.
