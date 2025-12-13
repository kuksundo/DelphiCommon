unit UnitFileSearchEngine;

interface

uses
  System.Classes, System.SysUtils, System.Masks, System.StrUtils, System.IOUtils,
  OtlCommon, OtlCollections, OtlTask, OtlParallel;

type
  TFileFoundEvent = procedure(const FilePath: string) of object;
  TSearchProgressEvent = procedure(const CurrentDir: string; FilesFound: Integer) of object;
  TSearchCompleteEvent = procedure(FilesFound: Integer; WasCancelled: Boolean) of object;

  TFileSearchEngine = class
  private
    FOnFileFound: TFileFoundEvent;
    FOnProgress: TSearchProgressEvent;
    FOnComplete: TSearchCompleteEvent;
    FSearchFileName: string;
    FCaseSensitive: Boolean;
    FUseWildcards: Boolean;
    FMaxResults: Integer;
    FSearchHiddenFolders: Boolean;
    FSearchPipeline: IOmniPipeline;             // OTL pipeline for parallel processing
    FCancelProcessing: Boolean;                  // Flag to signal cancellation to worker threads
    FFilesFound: TOmniAlignedInt32;             // Thread-safe counter for found files
    FDirsInPipeline: TOmniAlignedInt32;         // Thread-safe counter for directories being processed
    function MatchesSearchCriteria(const FileName: string): Boolean;
    procedure FileSearcher_asy(const input, output: IOmniBlockingCollection; const task: IOmniTask);
    procedure ResultCollector_asy(const input, output: IOmniBlockingCollection);
    procedure SearchComplete;
  public
    constructor Create;
    destructor Destroy; override;

    procedure StartSearch(const FileName: string); overload;
    procedure StartSearch(const FileName: string; const Drives: TArray<string>); overload;
    procedure StopSearch;

    property OnFileFound: TFileFoundEvent read FOnFileFound write FOnFileFound;
    property OnProgress: TSearchProgressEvent read FOnProgress write FOnProgress;
    property OnComplete: TSearchCompleteEvent read FOnComplete write FOnComplete;

    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
    property UseWildcards: Boolean read FUseWildcards write FUseWildcards;
    property MaxResults: Integer read FMaxResults write FMaxResults;
    property SearchHiddenFolders: Boolean read FSearchHiddenFolders write FSearchHiddenFolders;
  end;

implementation

constructor TFileSearchEngine.Create;
begin
  inherited;
  FCaseSensitive := False;
  FUseWildcards := False;
  FMaxResults := 0;
  FSearchHiddenFolders := False;
end;

destructor TFileSearchEngine.Destroy;
begin
  StopSearch;  // Ensure any running search is stopped before destruction
  inherited;
end;

function TFileSearchEngine.MatchesSearchCriteria(const FileName: string): Boolean;
var
  SearchTerms: TArray<string>;
  Term: string;
  FileNameToSearch: string;
  TermToSearch: string;
begin
  Result := False;

  // Wildcard matching (e.g., "*.txt")
  if FUseWildcards then
  begin
    Result := MatchesMask(FileName, FSearchFileName);
    Exit;
  end;

  // Split search string into individual terms (space-separated)
  SearchTerms := FSearchFileName.Split([' '], TStringSplitOptions.ExcludeEmpty);
  if Length(SearchTerms) = 0 then
    Exit;

  // Prepare filename for comparison (case-sensitive or not)
  if FCaseSensitive then
    FileNameToSearch := FileName
  else
    FileNameToSearch := LowerCase(FileName);

  // All search terms must be present in the filename (AND logic)
  for Term in SearchTerms do
  begin
    if FCaseSensitive then
      TermToSearch := Term
    else
      TermToSearch := LowerCase(Term);

    if not ContainsStr(FileNameToSearch, TermToSearch) then
      Exit(False);  // Term not found - no match
  end;

  Result := True;  // All terms found
end;

procedure TFileSearchEngine.FileSearcher_asy(const input, output: IOmniBlockingCollection;
  const task: IOmniTask);
var
  inValue: TOmniValue;
  CurrentDir: string;
  Files, Dirs: TArray<string>;
  FilePath: string;
  FileNameOnly: string;
  Attr: TFileAttributes;
  LocalFilesFound: Integer;
begin
  // Process each directory from the input queue
  for inValue in input do
  begin
    // Check if search was cancelled
    if FCancelProcessing then
      Exit;

    // Check if we've reached the maximum number of results
    if (FMaxResults > 0) and (FFilesFound.Value >= FMaxResults) then
    begin
      // Signal completion - last directory decrements counter to 0
      if FDirsInPipeline.Decrement = 0 then
        FSearchPipeline.Input.CompleteAdding;
      Exit;
    end;

    CurrentDir := inValue.AsString;
    LocalFilesFound := 0;

    try
      // Search all files in current directory
      Files := TArray<string>(TDirectory.GetFiles(CurrentDir));
      for FilePath in Files do
      begin
        if FCancelProcessing then
          Break;

        if (FMaxResults > 0) and (FFilesFound.Value >= FMaxResults) then
          Break;

        // Extract only the filename (without path) for matching
        FileNameOnly := ExtractFileName(FilePath);

        // Check if file matches search criteria
        if MatchesSearchCriteria(FileNameOnly) then
        begin
          // Send full path to result collector stage
          if not output.TryAdd(FilePath) then
            Exit; // Pipeline stopped externally

          FFilesFound.Increment;
          Inc(LocalFilesFound);
        end;
      end;

      // Add subdirectories to pipeline for recursive search
      if not FCancelProcessing and ((FMaxResults = 0) or (FFilesFound.Value < FMaxResults)) then
      begin
        Dirs := TArray<string>(TDirectory.GetDirectories(CurrentDir));
        for FilePath in Dirs do
        begin
          // Skip hidden folders if option is not set
          if not FSearchHiddenFolders then
          begin
            try
              Attr := TDirectory.GetAttributes(FilePath);
              if TFileAttribute.faHidden in Attr then
                Continue;
            except
              Continue;  // Skip directories with access errors
            end;
          end;

          // Add subdirectory to pipeline and increment counter
          FDirsInPipeline.Increment;
          if not FSearchPipeline.Input.TryAdd(FilePath) then
          begin
            FDirsInPipeline.Decrement;  // Rollback if pipeline is stopped
            Exit; // Pipeline stopped externally
          end;
        end;
      end;

    except
      // Skip access denied and other file system errors
    end;

    // Decrement directory counter - when it reaches 0, all directories have been processed
    if FDirsInPipeline.Decrement = 0 then
      FSearchPipeline.Input.CompleteAdding;  // Signal that search is complete
  end;
end;

procedure TFileSearchEngine.ResultCollector_asy(const input, output: IOmniBlockingCollection);
var
  inValue: TOmniValue;
  FilePath: string;
  Count: Integer;
begin
  Count := 0;

  // Collect results from FileSearcher stage and notify UI
  for inValue in input do
  begin
    FilePath := inValue.AsString;

    // Notify UI thread about found file (thread-safe)
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(FOnFileFound) then
          FOnFileFound(FilePath);
      end);

    Inc(Count);

    // Update progress every 10 files to avoid flooding the UI
    if Count mod 10 = 0 then
    begin
      TThread.Queue(nil,
        procedure
        begin
          if Assigned(FOnProgress) then
            FOnProgress('', Count);
        end);
    end;
  end;
end;

procedure TFileSearchEngine.SearchComplete;
begin
  // Notify UI thread that search is complete (thread-safe)
  TThread.Queue(nil,
    procedure
    begin
      if Assigned(FOnComplete) then
        FOnComplete(FFilesFound.Value, FCancelProcessing);
    end);
end;

procedure TFileSearchEngine.StartSearch(const FileName: string);
var
  Drives: TArray<string>;
begin
  // Search all logical drives by default
  Drives := TArray<string>(TDirectory.GetLogicalDrives);
  StartSearch(FileName, Drives);
end;

procedure TFileSearchEngine.StartSearch(const FileName: string; const Drives: TArray<string>);
var
  Drive: string;
begin
  // Stop any existing search before starting a new one
  StopSearch;

  // Initialize search parameters
  FSearchFileName := FileName;
  FCancelProcessing := False;
  FFilesFound.Value := 0;
  FDirsInPipeline.Value := Length(Drives); // Start with number of root directories (drives)

  // Create OTL pipeline with two stages:
  // Stage 1: FileSearcher (4 parallel workers) - searches directories and finds matching files
  // Stage 2: ResultCollector (1 worker) - collects results and notifies UI
  FSearchPipeline := Parallel.Pipeline
    .NoThrottling  // Don't limit queue size - let it grow as needed
    .Stage(FileSearcher_asy)
      .NumTasks(4)  // 4 parallel search threads for better performance on multi-core systems
    .Stage(ResultCollector_asy,
      Parallel.TaskConfig.OnTerminated(SearchComplete))  // Call SearchComplete when pipeline finishes
    .Run;

  // Add initial directories (drives) to pipeline
  for Drive in Drives do
    FSearchPipeline.Input.Add(Drive);

  // IMPORTANT: Don't call CompleteAdding here!
  // The worker threads will call it when FDirsInPipeline reaches 0
  // (i.e., when all directories have been processed)
end;

procedure TFileSearchEngine.StopSearch;
begin
  if Assigned(FSearchPipeline) then
  begin
    // Signal all worker threads to stop processing
    FCancelProcessing := True;

    // Signal that no more input will be added to the pipeline
    FSearchPipeline.Input.CompleteAdding;

    // Wait for pipeline to finish (max 5 seconds)
    FSearchPipeline.WaitFor(5000);

    // Release pipeline resources
    FSearchPipeline := nil;
  end;
end;

end.
