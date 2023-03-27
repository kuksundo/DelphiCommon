unit UnitNextGridUtil2;

interface

uses SysUtils, StdCtrls,Classes, Graphics, Grids, ComObj, StrUtils,
    Variants, Dialogs, Forms, Excel2010,
    NxColumnClasses, NxColumns, NxGrid, NxCells,
    mormot.core.base, mormot.core.data, mormot.core.variants, mormot.core.unicode;

procedure NextGridToCsv(AFileName: string; ANextGrid: TNextGrid);
procedure AddNextGridColumnFromVariant(AGrid: TNextGrid; ADoc: Variant; AIsFromValue: Boolean=false; AIsIgnoreSaveFile: Boolean=false);
//ADoc Name이 Grid의 Column Name임
procedure AddNextGridRowFromVariant(AGrid: TNextGrid; ADoc: Variant; AIsFromValue: Boolean=false);
//ADoc Name이 Grid의 Cell Data 임
procedure AddNextGridRowFromVariant2(AGrid: TNextGrid; ADoc: Variant; AIsFromValue: Boolean=false);
procedure AddNextGridRowsFromVariant(AGrid: TNextGrid; ADynAry: TRawUTF8DynArray; AIsFromValue: Boolean=false);
function GetListFromVariant2NextGrid(AGrid: TNextGrid; ADoc: Variant;
  AIsAdd: Boolean; AIsArray: Boolean = False; AIsUsePosFunc: Boolean = False;
  AIsClearRow: Boolean=False): integer;
function NextGrid2Variant(AGrid: TNextGrid; ARemoveUnderBar: Boolean=False): variant;
function GetJsonFromSelectedRow(AGrid: TNextGrid; ARemoveUnderBar: Boolean=False): string;
procedure NextGridScrollToRow(AGrid: TNextGrid; ARow: integer=-1);
procedure DeleteSelectedRow(ANextGrid: TNextGrid);
procedure DeleteCurrentRow(ANextGrid: TNextGrid);
procedure MoveRowDown(ANextGrid: TNextGrid);
procedure MoveRowUp(ANextGrid: TNextGrid);

implementation

uses UnitStringUtil;

procedure NextGridToCsv(AFileName: string; ANextGrid: TNextGrid);
var
  LColCount, i, j: integer;
  LCsv, LHeader: string;
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    for j := 0 to ANextGrid.RowCount - 1 do
    begin
      for i := 0 to ANextGrid.Columns.Count - 1 do
      begin
        if j = 0 then
          LHeader := LHeader + ANextGrid.Columns.Item[i].Header.Caption + ',';

        LCsv := LCsv + ANextGrid.Cells[i,j] + ',';
      end;

      if j = 0 then
      begin
        LHeader := LHeader.Remove(LHeader.Length-1);
        LStrList.Add(LHeader);
      end;

      LCsv := LCsv.Remove(LCsv.Length-1);
      LStrList.Add(LCsv);
      LCsv := '';
    end;

    LStrList.SaveToFile(AFileName);
  finally
    LStrList.Free;
  end;
end;

procedure AddNextGridColumnFromVariant(AGrid: TNextGrid; ADoc: Variant; AIsFromValue: Boolean; AIsIgnoreSaveFile: Boolean);
var
  LnxTextColumn: TnxTextColumn;
  LNxComboBoxColumn: TNxComboBoxColumn;
  LnxIncrementColumn: TnxCustomColumn;
  i: integer;
  LTitle, LCompName: string;
  LStrList: TStringList;

  procedure SetTextColumn(ATitle, AName: string);
  begin
    LnxTextColumn := TnxTextColumn(AGrid.Columns.Add(TnxTextColumn, ATitle));
    LnxTextColumn.Name := RemoveSpaceBetweenStrings(AName);
    LnxTextColumn.Editing := True;
    LnxTextColumn.Header.Alignment := taCenter;
    LnxTextColumn.Alignment := taCenter;
    LnxTextColumn.Options := [coCanClick,coCanInput,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];//,coEditing

    LStrList.Add(AName + ':' + 'TnxTextColumn;');
  end;
begin
//
  LStrList := TStringList.Create;
  try
    with AGrid do
    begin
      ClearRows;
      Columns.Clear;

      if not AIsIgnoreSaveFile then
      begin
        LnxIncrementColumn := Columns.Add(TnxIncrementColumn,'No');
        LnxIncrementColumn.Alignment := taCenter;
        LnxIncrementColumn.Header.Alignment := taCenter;
        LnxIncrementColumn.Width := 30;
      end;

  //    with TDocVariantData(ADoc) do
  //    begin
        for i := 0 to TDocVariantData(ADoc).Count - 1 do
        begin
          LCompName := TDocVariantData(ADoc).Names[i];

          if AIsFromValue then
            LTitle := TDocVariantData(ADoc).Values[i]
          else
            LTitle := LCompName;

          SetTextColumn(LTitle, LCompName);
        end;
  //    end;
    end;//with
  finally
    //NextGrid Column을 추가하면 TForm 선언부에 ColumnName: ColumnType 이 추가 되므로
    //Column 자동 생성 후 아래 파일 내용을 복사하여 TForm에 추가해 주어야 함
    if not AIsIgnoreSaveFile then
    begin
      LStrList.SaveToFile('c:\temp\NextGridTextColumnList.txt');
      ShowMessage('c:\temp\NextGridTextColumnList.txt is saved.' + #13#10 +
        'NextGrid Column을 추가하면 TForm 선언부에 ColumnName: ColumnType 이 추가 되므로' + #13#10 +
        'Column 자동 생성 후 아래 파일 내용을 복사하여 TForm에 추가해 주어야 함.');
    end;

    LStrList.Free;
  end;
end;

procedure AddNextGridRowFromVariant(AGrid: TNextGrid; ADoc: Variant; AIsFromValue: Boolean=false);
var
  i,j: integer;
  LCellValue, LColName: string;
begin
  with AGrid do
  begin
    ClearRows;
    j := AGrid.AddRow();

    for i := 0 to TDocVariantData(ADoc).Count - 1 do
    begin
      LColName := TDocVariantData(ADoc).Names[i];

      if AIsFromValue then
        LCellValue := TDocVariantData(ADoc).Values[i]
      else
        LCellValue := LColName;

      AGrid.CellsByName[LColName, j] := LCellValue;
    end;//for
  end;//with
end;

procedure AddNextGridRowFromVariant2(AGrid: TNextGrid; ADoc: Variant; AIsFromValue: Boolean=false);
var
  i, j: integer;
begin
  with AGrid do
  begin
    j := AddRow;

    for i := 0 to TDocVariantData(ADoc).Count - 1 do
    begin
      if AIsFromValue then
        CellsByName[i, j] := TDocVariantData(ADoc).Values[i]
      else
        CellsByName[i, j] := TDocVariantData(ADoc).Names[i];
    end;
  end;
end;

procedure AddNextGridRowsFromVariant(AGrid: TNextGrid; ADynAry: TRawUTF8DynArray; AIsFromValue: Boolean=false);
var
  i: integer;
  LDoc: variant;
begin
  for i := Low(ADynAry) to High(ADynAry) do
  begin
    LDoc := _JSON(ADynAry[i]);

    AddNextGridRowFromVariant(AGrid, LDoc, AIsFromValue);
  end;//for
end;

//ADoc는 한개의 레코드에 대한 Json 임
//AIsUsePosFunc : True = Pos함수를 사용하여 LCompName이 Column Name에 포함되어 있으면 처리
function GetListFromVariant2NextGrid(AGrid: TNextGrid; ADoc: Variant;
  AIsAdd: Boolean; AIsArray: Boolean; AIsUsePosFunc: Boolean; AIsClearRow: Boolean): integer;
var
  i, j, LRow, LCount: integer;
  LCompName, LValue: string;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LUtf8: RawUTF8;
  LDoc: variant;

  procedure AddRowFromVar(AJson: variant);
  var
    Li, Lj: integer;
  begin
    if AIsAdd then
      LRow := AGrid.AddRow
    else
      LRow := AGrid.SelectedRow;

    for Li := 0 to TDocVariantData(AJson).Count - 1 do
    begin
      LCompName := TDocVariantData(AJson).Names[Li];

      if AIsUsePosFunc then
      begin
        for Lj := 0 to AGrid.Columns.Count - 1 do
        begin
          if POS(LCompName, AGrid.Columns[Lj].Name) > 0 then
          begin
            //반드시 String Type만 대입 할 것
            AGrid.CellsByName[Lj, LRow] := TDocVariantData(AJson).Values[Li];
          end;
        end;
      end
      else if AGrid.Columns.IndexOf(AGrid.ColumnByName[LCompName]) > -1 then
      begin
        //반드시 String Type만 대입 할 것
        AGrid.CellsByName[LCompName, LRow] := TDocVariantData(AJson).Values[Li];
      end;
    end;
  end;
begin
  with AGrid do
  begin
    BeginUpdate;

    if AIsClearRow then
      ClearRows;

    try
      if AIsArray then
      begin
        LValue := ADoc;
        LUtf8 := StringToUTF8(LValue);
        LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
        LDynArr.LoadFromJSON(PUTF8Char(LUtf8));

        for i := 0 to LDynArr.Count - 1 do
        begin
          LDoc := _JSON(LDynUtf8[i]);
          AddRowFromVar(LDoc);
        end;
      end
      else
      begin
        AddRowFromVar(ADoc);
      end;
    finally
      EndUpdate;

      if AIsArray then
        Result :=  LDynArr.Count
      else
        Result :=  TDocVariantData(ADoc).Count;
    end;
  end;//with
end;

//Result에 [{"NextGrid.ColumnName": NextGrid.CelsByName}] Array 형식으로 저장됨
function NextGrid2Variant(AGrid: TNextGrid; ARemoveUnderBar: Boolean): variant;
var
  i, j: integer;
  LColumnName: string;
  LUtf8: RawUTF8;
  LDynUtf8: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LV: variant;
begin
  TDocVariant.New(Result);
  TDocVariant.New(LV);
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);

  for i := 0 to AGrid.RowCount - 1 do
  begin
    for j := 0 to AGrid.Columns.Count - 1 do
    begin
      LColumnName := AGrid.Columns.Item[j].Name;

      if ARemoveUnderBar then
        LColumnName := strToken(LColumnName, '_');

      TDocVariantData(LV).Value[LColumnName] := AGrid.CellsByName[LColumnName, i];
    end;

    LUtf8 := LV;
    LDynArr.Add(LUtf8);
  end;

  Result := LDynArr.SaveToJSON;
end;

function GetJsonFromSelectedRow(AGrid: TNextGrid; ARemoveUnderBar: Boolean): string;
var
  i, j: integer;
  LColumnName: string;
  LV, LValue: variant;
begin
  TDocVariant.New(LV);

  for j := 0 to AGrid.Columns.Count - 1 do
  begin
    LColumnName := AGrid.Columns.Item[j].Name;

    if ARemoveUnderBar then
      LColumnName := strToken(LColumnName, '_');

    LValue := AGrid.Cells[j, AGrid.SelectedRow];
    TDocVariantData(LV).AddValue(LColumnName, LValue);
  end;//for

  Result := LV;
end;

procedure NextGridScrollToRow(AGrid: TNextGrid; ARow: integer);
begin
  if ARow = -1 then
    ARow := AGrid.SelectedRow;

  if ARow = -1 then
    exit;

  AGrid.ScrollToRow(ARow);
  AGrid.Row[ARow].Selected := True;
end;

procedure DeleteSelectedRow(ANextGrid: TNextGrid);
var
  i: Integer;
begin
  i := 0;
  while i < ANextGrid.RowCount do
  begin
    if ANextGrid.CellByName['check', i].AsBoolean then
    begin
      ANextGrid.DeleteRow(i);
    end else Inc(i);
  end;
end;

procedure DeleteCurrentRow(ANextGrid: TNextGrid);
begin
  ANextGrid.DeleteRow(ANextGrid.SelectedRow);
end;

procedure MoveRowDown(ANextGrid: TNextGrid);
begin
  ANextGrid.MoveRow(ANextGrid.SelectedRow, ANextGrid.SelectedRow + 1);
  ANextGrid.SelectedRow := ANextGrid.SelectedRow + 1;
end;

procedure MoveRowUp(ANextGrid: TNextGrid);
begin
  ANextGrid.MoveRow(ANextGrid.SelectedRow, ANextGrid.SelectedRow - 1);
  ANextGrid.SelectedRow := ANextGrid.SelectedRow - 1;
end;

end.
