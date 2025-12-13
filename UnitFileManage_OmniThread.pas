unit UnitFileManage_OmniThread;

interface

uses
  System.SysUtils, System.IOUtils, System.Classes, Winapi.Windows, Winapi.Messages,
  mormot.core.collections, mormot.core.base,//Generics.Collections,
  OtlCommon, OtlParallel, OtlCollections, OtlSync,
  ZipMstr,
  UnitEnumHelper;

type
  TFileActionKind = (fakCopy, fakMove, fakCompress, fakGetVersion);
  TFileActionKinds = set of TFileActionKind;

const
  R_FileActionKind : array[Low(TFileActionKind)..High(TFileActionKind)] of string =
    ('Copy', 'Move', 'Compress', 'GetVersion');
const
  WM_UPDATE_PROGRESS = WM_USER+1;
  WM_UPDATE_FILECOUNT = WM_USER+2;
  WM_NOTIFY_COMPLETE = WM_USER+3;

type
  TFileCopyInfoRec = packed record
    SrcRootFolder,
    SrcFileName,
    DestRootFolder,
    DestFileName: string;

    FileActionSet: integer;//TFileActionKinds
    IsIncludeSubFolder: Boolean;

    CancelToken: IOmniCancellationToken;
    FormHandle4Msg: THandle;
  end;

  TFileCopyInfo = class
    FFileInfoRec: TFileCopyInfoRec;

    class function GetJsonAryFromBase64(const ABase64: string): string; static;
    class function GetBase64FromJsonAry(const AJsonAry: string): string; static;
    class function AdjustTargetFileNameByRule(ARec: TFileCopyInfoRec): TFileCopyInfoRec; static;

    constructor Create(const ARec: TFileCopyInfoRec);
  end;

procedure CopyFilesUsingOtlForEach(AFileCopyInfoList: IList<TFileCopyInfo>; var ACancelToken: IOmniCancellationToken);//TObjectList<TFileCopyInfo>
procedure CopyFilesUsingOtlFor(AFileCopyInfoList: IList<TFileCopyInfo>;
  var ACancelToken: IOmniCancellationToken);

var
  g_FileActionKind: TLabelledEnum<TFileActionKind>;

implementation

uses UnitFileSearchUtil, UnitFileInfoUtil, UnitSharedMMUtil, UnitCryptUtil3,
  UnitStringUtil, UnitSetUtil, UnitFileUtil2;

procedure CopyFilesUsingOtlForEach(AFileCopyInfoList: IList<TFileCopyInfo>; var ACancelToken: IOmniCancellationToken);
var
  LFolder, LFileName: string;
  LFileCopyInfo: TFileCopyInfo;
  LFileList: IOmniBlockingCollection;
begin
//  LCancelToken := CreateOmniCancellationToken;

  LFileList := TOmniBlockingCollection.Create;

  // 모든 FileCopyInfo Class를 큐에 추가
//  for LFileCopyInfo in AFileCopyInfoList do
//  begin
//    LFileList.Add(LFileCopyInfo);
//    if TDirectory.Exists(LFolder) then
//    begin
//      for LFileName in TDirectory.GetFiles(LFolder, '*.*', TSearchOption.soAllDirectories) do
//    end;
//  end;

  LFileList.CompleteAdding;

  // 병렬 복사 실행
  Parallel.ForEach(LFileList)
    .CancelWith(ACancelToken)
    .NumTasks(Environment.Process.Affinity.Count)
    .Execute(
      procedure(const AFileName: TOmniValue)
      var
        SourceRoot: string;
        RelativePath: string;
        DestFile, LScrFN, FileName: string;
      begin
//        try
//          // 소스 루트 찾기 (가장 긴 매칭)
//          SourceRoot := '';
//          FileName := AFileName.AsString;
//
//          for LScrFN in ASourceFolders do
//            if FileName.StartsWith(LScrFN, True) and (Length(LScrFN) > Length(SourceRoot)) then
//              SourceRoot := LScrFN;
//
//          if SourceRoot = '' then
//            Exit;
//
//          // 상대 경로 = 전체경로 - 소스루트
//          RelativePath := FileName.Substring(Length(SourceRoot)).TrimLeft(['\', '/']);
//
//          // 대상 전체 경로
//          DestFile := TPath.Combine(ATargetFolder, TPath.Combine(ExtractFileName(SourceRoot), RelativePath));
//
//          // 대상 디렉토리 없으면 생성
//          TDirectory.CreateDirectory(ExtractFilePath(DestFile));
//
//          // 복사
//          TFile.Copy(FileName, DestFile, True);
//        except
//          on E: Exception do
//            Writeln(Format('파일 복사 실패: %s -> %s (%s)', [FileName, DestFile, E.Message]));
//        end;
      end
    );
end;

procedure CopyFilesUsingOtlFor(AFileCopyInfoList: IList<TFileCopyInfo>; var ACancelToken: IOmniCancellationToken);
var
  LCancelToken: IOmniCancellationToken;
begin
  LCancelToken := ACancelToken;

  Parallel.For(0, AFileCopyInfoList.Count - 1)
    .CancelWith(ACancelToken)
    .NumTasks(Environment.Process.Affinity.Count)
    .NoWait
    .Execute(
      procedure (idx: integer)
      var
        LFileCopyInfo: TFileCopyInfo;
        LFileCopyInfoRec: TFileCopyInfoRec;
        LSrcFullName: string;
        RelativePath: string;
        DestFile, LSrcPath, LFileName: string;
        LStrList, LVerList: TStringList;
        LCurrentFileCount: integer;
        LFileActionKinds: TFileActionKinds;
        LRaw: RawByteString;
        LIsCompress: Boolean;
        LFileActKinds: TFileActionKinds;
      begin
        try
          LFileCopyInfo := AFileCopyInfoList.Items[idx];
          LFileCopyInfo.FFileInfoRec.CancelToken := LCancelToken;

          if not TDirectory.Exists(LFileCopyInfo.FFileInfoRec.DestRootFolder) then
            TDirectory.CreateDirectory(LFileCopyInfo.FFileInfoRec.DestRootFolder);

          //SrcFileList with Full Path
          LStrList := GetFileListFromFolder(LFileCopyInfo.FFileInfoRec.SrcRootFolder,
                                            LFileCopyInfo.FFileInfoRec.SrcFileName,
                                            LFileCopyInfo.FFileInfoRec.IsIncludeSubFolder);
          try
            LCurrentFileCount := 0;

            PostMessage(LFileCopyInfo.FFileInfoRec.FormHandle4Msg, WM_UPDATE_FILECOUNT, LStrList.Count, idx);

//            LFileActionKinds := TFileActionKinds(LFileCopyInfo.FFileInfoRec.FileActionSet);
            TgpEnumSet<TFileActionKinds>.IntToSet(LFileCopyInfo.FFileInfoRec.FileActionSet, LFileActKinds, SizeOf(LFileCopyInfo.FFileInfoRec.FileActionSet));

            if fakGetVersion in LFileActionKinds then
            begin
              LVerList := TStringList.Create;
              try
                LVerList.Assign(LStrList);
                //filename=version 형식의 LVerList가 반환 됨.
                GetFileVersionListByPJVerInfoFromList(LVerList);
                LRaw := TJHP_ShareMM_Util.Encrypt2Base64(LVerList.Text);
                TJHP_ShareMM_Util.SendData2SMM(LFileCopyInfo.FFileInfoRec.FormHandle4Msg, LRaw, idx);
              finally
                LVerList.Free;
              end;
            end;

            LIsCompress := TgpEnumSet<TFileActionKinds>.IsIncludedInSet(Ord(fakCompress), LFileActKinds);

            for LSrcFullName in LStrList do
            begin
              LFileCopyInfo.FFileInfoRec.SrcFileName := LSrcFullName;
              LFileCopyInfoRec := TFileCopyInfo.AdjustTargetFileNameByRule(LFileCopyInfo.FFileInfoRec);

              CopyOrZipFileUsingSystemZip(LSrcFullName,
                            TPath.Combine(LFileCopyInfoRec.DestRootFolder, LFileCopyInfoRec.DestFileName),
                            LIsCompress);

//              LFileName := ExtractFileName(LSrcFullName);
//              LSrcPath := ExtractFilePath(LSrcFullName);
//              // 상대 경로 = 전체경로 - 소스루트
//              RelativePath := LSrcPath.Substring(Length(LFileCopyInfo.FFileInfoRec.SrcRootFolder)).TrimLeft(['\', '/']);
//
//              // 대상 전체 경로
//              DestFile := TPath.Combine(LFileCopyInfo.FFileInfoRec.DestRootFolder, TPath.Combine(LFileName, RelativePath));
//
//              // 대상 디렉토리 없으면 생성
//              TDirectory.CreateDirectory(ExtractFilePath(DestFile));
//
//              if fakCopy in LFileActionKinds then
//              begin
//                // 복사
//                TFile.Copy(LSrcFullName, DestFile, True);
//              end;

              Inc(LCurrentFileCount);
              PostMessage(LFileCopyInfo.FFileInfoRec.FormHandle4Msg, WM_UPDATE_PROGRESS, Round(LCurrentFileCount / LStrList.Count * 100), idx);
            end; //for

            PostMessage(LFileCopyInfo.FFileInfoRec.FormHandle4Msg, WM_NOTIFY_COMPLETE, 0, idx);

          finally
            FreeAndNil(LStrList);
          end;
        except
          on E: Exception do
          begin
            Writeln(Format('파일 복사 실패: %s -> %s (%s)', [LFileName, DestFile, E.Message]));
            LFileCopyInfo.FFileInfoRec.CancelToken.Signal;
          end;
        end;
      end
    );

end;

{ TFileCopyInfo }

class function TFileCopyInfo.AdjustTargetFileNameByRule(
  ARec: TFileCopyInfoRec): TFileCopyInfoRec;
var
  LExt: string;
begin
  Result := ARec;

  Result.FileActionSet := 0;
  LExt := TPath.GetExtension(Result.DestFileName);

  if Result.DestFileName.IsEmpty then
  begin
    // 1. "TargetFileName" 값이 공란이면 원본 파일 이름과 동일하게 복사한다
    Result.DestFileName := MapToTargetPath(Result.SrcRootFolder, Result.SrcFileName, Result.DestRootFolder);
  end
  else if TextStartsWith(Result.DestFileName, '*.') then
  begin
    if SameText(LExt, '.zip') then
    begin
      // 2. "TargetFileName" 값이 "*.zip"형식으로 파일 이름이 '*' 이고 확장자가 Zip으로 명시된 경우 "원본파일명.zip" 파일 이름에 압축하여 복사하는 조건을 추가해 줘
      Result.DestFileName := TPath.ChangeExtension(TPath.GetFileNameWithoutExtension(Result.SrcFileName), '.zip');
      Result.FileActionSet := 1; // 1 = Zip Action
    end
    else
    begin
      // 3. "TargetFileName" 값이 "*.xxx"형식으로 확장자만 명시된 경우 원본 파일 이름.xxx 파일이름으로 복사한다
      Result.DestFileName := TPath.ChangeExtension(Result.SrcFileName, TPath.GetExtension(Result.DestFileName));
    end;
  end
  else if AnsiSameText(TPath.GetExtension(Result.DestFileName), '.zip') then
  begin
    // 4. "TargetFileName" 값이 "x.zip"형식으로 확장자가 Zip으로 명시된 경우 원본의 모든 파일을 x.zip 파일 이름에 압축하여 복사한다
    Result.FileActionSet := 1; // 1 = Zip Action
  end
  else
  begin
    // 5. "TargetFileName" 값이 공란이 아니고 *.으로 시작하지 않고 .zip이 아닌 경우
    // (사용자 규칙 설명은 2번과 유사하지만, 실제 의도는 파일명 전체 변경으로 해석)
//    Result.DestFileName := LTargetFileName;
  end;
end;

constructor TFileCopyInfo.Create(const ARec: TFileCopyInfoRec);
begin
  FFileInfoRec := ARec;
end;

class function TFileCopyInfo.GetBase64FromJsonAry(
  const AJsonAry: string): string;
begin
  Result := MakeEncrypNBase64String(AJsonAry);
end;

class function TFileCopyInfo.GetJsonAryFromBase64(
  const ABase64: string): string;
begin
  Result := MakeUnBase64NDecryptString(ABase64);
end;

initialization
  g_FileActionKind.InitArrayRecord(R_FileActionKind);

end.
