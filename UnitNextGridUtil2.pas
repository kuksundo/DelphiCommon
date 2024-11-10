unit UnitNextGridUtil2;

interface

uses SysUtils, StdCtrls,Classes, Graphics, Grids, ComObj, StrUtils, System.Types,
    Variants, Dialogs, Forms, Excel2010,
    NxColumnClasses, NxColumns, NxGrid, NxCells, ArrayHelper,
    mormot.core.base, mormot.core.data, mormot.core.variants, mormot.core.unicode,
    mormot.core.text, mormot.core.datetime;

type
  TCellHelper = class helper for TCell
    function AsVariant: variant;
  end;

procedure NextGridToCsv(AFileName: string; ANextGrid: TNextGrid; ASkipHideRow: Boolean=True);
//ADoc : {Column Name: Caption} 형식임
//ACaptionIsFromValue : True = Caption 위치 지정
procedure AddNextGridColumnFromVariant(AGrid: TNextGrid; ADoc: Variant;
  ACaptionIsFromValue: Boolean=false; AIsIgnoreSaveFile: Boolean=false; AAddIncCol: Boolean=False);
//AVarType: Variant Type from VarType()-varInteter/varString...
function AddNextGridColumnByVarType(AGrid: TNextGrid; const AVarType: integer; const ACaption, AName: string): string;
function AddNextGridTextColumn(AGrid: TNextGrid; const ACaption, AName: string): string;
function AddNextGridDateColumn(AGrid: TNextGrid; const ACaption, AName: string): string;
function AddNextGridNumColumn(AGrid: TNextGrid; const ACaption, AName: string): string;
function AddNextGridCheckBoxColumn(AGrid: TNextGrid; const ACaption, AName: string): string;

//ADoc Name이 Grid의 Column Name임
//AIsFromValue : False = Json의 Key 값을 Value로 저장함
//               True = Json의 Value 값을 Value로 저장함
function AddNextGridRowFromVariant(AGrid: TNextGrid; ADoc: Variant; AIsFromValue: Boolean=false; ARow: integer=-1): integer;
//ADoc Name이 Grid의 Cell Data 임
procedure AddNextGridRowFromVariant2(AGrid: TNextGrid; ADoc: Variant; AIsFromValue: Boolean=false);
//첫번쨰 행이 Grid의 Column Name 임
procedure AddNextGridRowsFromVariant(AGrid: TNextGrid; ADynAry: TRawUTF8DynArray; AIsAddColumn: Boolean=false);
//ADoc는 TRawUTF8DynArray에 대한 Json 임
//ADoc Name이 Grid의 Column Name임
procedure AddNextGridRowsFromVariant2(AGrid: TNextGrid; ADoc: Variant; AIsAddColumn: Boolean=false);
//AJsonAry은 복수개의 레코드에 대한 Json Array 임(Orm.FillTable.ToIList<TOrmType>로 만듬-Orm.GetJsonValues는 한개의 레코드에 대한 Json을 반환함)
function AddNextGridRowsFromJsonAry(AGrid: TNextGrid; AJsonAry: RawUtf8; AIsAddColumn: Boolean=false): integer;
function GetListFromVariant2NextGrid(AGrid: TNextGrid; ADoc: Variant;
  AIsAdd: Boolean; AIsArray: Boolean = False; AIsUsePosFunc: Boolean = False;
  AIsClearRow: Boolean=False): integer;
function NextGrid2Variant(AGrid: TNextGrid; ARemoveUnderBar: Boolean=False; ASkipInVisible: Boolean=True; ASelectedOnly: Boolean=False): variant;
function NextGrid2DocList(AGrid: TNextGrid; ARemoveUnderBar: Boolean=False; ASkipInVisible: Boolean=True; ASelectedOnly: Boolean=False): IDocList;
//ARow 행의 데이터만 Variant로 반환함 : '{ColumnName=Value}'
function GetNxGridRow2Variant(AGrid: TNextGrid; ARow: integer): variant;
//ARow에 Variant를 Cell에 표시함
procedure SetNxGridRowFromVar(AGrid: TNextGrid; var ARow: integer; AVar: variant);
//Variant -> Grid :
procedure SetNxGridCellValueFromVar(AColumn: TnxCustomColumn; ACell: TCell; AVar: variant);
//Grid -> Variant :
procedure SetNxGridCellValue2Var(AColumn: TnxCustomColumn; ACell: TCell; var AVar: variant);

procedure NextGrid2JsonFile(AGrid: TNextGrid; ASaveFileName: string);
procedure NextGridFromJsonFile(AGrid: TNextGrid; AFileName: string; AIsClearRow: Boolean=False);
function NextGrid2VariantFromColIndexAry(AGrid: TNextGrid; AColIndexAry: TArrayRecord<integer>): variant;
function GetJsonFromSelectedRow(AGrid: TNextGrid; ARemoveUnderBar: Boolean=False): RawUTF8;
procedure NextGridScrollToRow(AGrid: TNextGrid; ARow: integer=-1);
procedure DeleteSelectedRow(ANextGrid: TNextGrid);
procedure DeleteCurrentRow(ANextGrid: TNextGrid);
procedure MoveRowDown(ANextGrid: TNextGrid);
procedure MoveRowUp(ANextGrid: TNextGrid);
procedure ShowOrHideAllColumn4NextGrid(ANextGrid: TNextGrid; AIsShow: Boolean);
function GetRowFromMouseDown(ANextGrid: TNextGrid; APoint: TPoint): integer;
//AFindFromRow부터 검색 시작, Column[AColIdx]의 내용 중에 AFindText가 있으면 RowNo 반환
//AColIdx: -1 이면 AColName을 사용하여 Column 검색함
function GetRowIndexFromFindNext(const ANextGrid: TNextGrid; AFindText: string;
  AColIdx: integer; var AFindFromRow: integer; AIgnoreCase: Boolean=false; AColName: string=''): integer;
function GetSelectedIndexFromNextGrid(ANextGrid: TNextGrid): integer;
function ChangeRowColorByIndex(AGrid: TNextGrid; ARowIndex: integer; AColor: TColor): TColor;
function ChangeRowFontColorByIndex(AGrid: TNextGrid; ARowIndex: integer; AColor: TColor; AIsBold: Boolean=True): TColor;
procedure CsvFile2NextGrid(ACsvFileName: string; ANextGrid: TNextGrid);

//AJson은 한개의 레코드에 대한 Json임
//AJson Name : Grid의 Column Name
//AJson Value : Grid Cell Value
procedure AddNextGridRowFromVarOnlyColumnExist(AGrid: TNextGrid; AJson: Variant);
//AStrList : Column Name=Caption list
//AGrid에 Column Name이 존재하면 Caption을 변경함
//NextGrid Caption을 변경 후 SaveDFM하여 DFM 파일 내용을 수동으로 변경할 때 사용됨
procedure SetColumnCaptionFromListOnlyColumnExist(AGrid: TNextGrid; AStrList: TStringList);

implementation

uses UnitStringUtil, UnitVariantUtil;

procedure NextGridToCsv(AFileName: string; ANextGrid: TNextGrid; ASkipHideRow: Boolean);
var
  LColCount, i, j: integer;
  LCsv, LHeader: string;
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    for j := 0 to ANextGrid.RowCount - 1 do
    begin
      if ASkipHideRow and (not ANextGrid.Row[j].Visible) then
      begin
        continue;
      end;

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

function AddNextGridColumnByVarType(AGrid: TNextGrid; const AVarType: integer; const ACaption, AName: string): string;
begin
  Result := '';

  case AVarType of
    varEmpty, varNull: ;
    varShortInt,
    varByte,
    varWord,
    varLongWord,
    varInt64,
    varUInt64,
    varSmallint,
    varInteger: Result := AddNextGridNumColumn(AGrid, ACaption, AName);
    varSingle,
    varDouble,
    varCurrency,
    varDate: Result := AddNextGridDateColumn(AGrid, ACaption, AName);
    varOleStr,
    varString,
    varUString: Result := AddNextGridTextColumn(AGrid, ACaption, AName);
    varBoolean: Result := AddNextGridCheckBoxColumn(AGrid, ACaption, AName);
    varUnknown:;
    varRecord:;
  end;
end;

function AddNextGridTextColumn(AGrid: TNextGrid; const ACaption, AName: string): string;
var
  LnxTextColumn: TnxTextColumn;
begin
  LnxTextColumn := TnxTextColumn(AGrid.Columns.Add(TnxTextColumn, ACaption));
  LnxTextColumn.Name := RemoveSpaceBetweenStrings(AName);
  LnxTextColumn.Editing := True;
  LnxTextColumn.Header.Alignment := taCenter;
  LnxTextColumn.Alignment := taCenter;
  LnxTextColumn.Options := [coCanClick,coCanInput,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];//,coEditing

  Result := AName + ':TnxTextColumn;';
end;

function AddNextGridDateColumn(AGrid: TNextGrid; const ACaption, AName: string): string;
var
  LnxDateColumn: TnxDateColumn;
begin
  LnxDateColumn := TnxDateColumn(AGrid.Columns.Add(TnxDateColumn, ACaption));
  LnxDateColumn.Name := RemoveSpaceBetweenStrings(AName);
  LnxDateColumn.Editing := True;
  LnxDateColumn.Header.Alignment := taCenter;
  LnxDateColumn.Alignment := taCenter;
  LnxDateColumn.Options := [coCanClick,coCanInput,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];//,coEditing

  Result := AName + ':TnxDateColumn;';
end;

function AddNextGridNumColumn(AGrid: TNextGrid; const ACaption, AName: string): string;
var
  LnxNumColumn: TnxNumberColumn;
begin
  LnxNumColumn := TnxNumberColumn(AGrid.Columns.Add(TnxNumberColumn, ACaption));
  LnxNumColumn.Name := RemoveSpaceBetweenStrings(AName);
  LnxNumColumn.Editing := True;
  LnxNumColumn.Header.Alignment := taCenter;
  LnxNumColumn.Alignment := taCenter;
  LnxNumColumn.Options := [coCanClick,coCanInput,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];//,coEditing

  Result := AName + ':TnxNumberColumn;';
end;

function AddNextGridCheckBoxColumn(AGrid: TNextGrid; const ACaption, AName: string): string;
var
  LnxCheckBoxColumn: TnxCheckBoxColumn;
begin
  LnxCheckBoxColumn := TnxCheckBoxColumn(AGrid.Columns.Add(TnxCheckBoxColumn, ACaption));
  LnxCheckBoxColumn.Name := RemoveSpaceBetweenStrings(AName);
  LnxCheckBoxColumn.Editing := True;
  LnxCheckBoxColumn.Header.Alignment := taCenter;
  LnxCheckBoxColumn.Alignment := taCenter;
  LnxCheckBoxColumn.Options := [coCanClick,coCanInput,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];//,coEditing

  Result := AName + ':TnxCheckBoxColumn;';
end;

procedure AddNextGridColumnFromVariant(AGrid: TNextGrid; ADoc: Variant;
  ACaptionIsFromValue: Boolean; AIsIgnoreSaveFile: Boolean; AAddIncCol: Boolean);
var
  LNxComboBoxColumn: TNxComboBoxColumn;
  LnxIncrementColumn: TnxCustomColumn;
  i, LVarType: integer;
  LTitle, LCompName: string;
  LVarValue: variant;
  LStrList: TStringList;
begin
//
  LStrList := TStringList.Create;
  try
    with AGrid do
    begin
      ClearRows;
      Columns.Clear;

      if AAddIncCol then
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
          LVarValue := TDocVariantData(ADoc).Values[i];

          if ACaptionIsFromValue then
            LTitle := LVarValue
          else
            LTitle := LCompName;

          LVarType := VarType(LVarValue) and VarTypeMask;

          LStrList.Add(AddNextGridColumnByVarType(AGrid, LVarType, LTitle, LCompName));//AddNextGridTextColumn(AGrid, LTitle, LCompName));
        end;
  //    end;
    end;//with
  finally
    //NextGrid Column을 추가하면 TForm 선언부에 ColumnName: ColumnType 이 추가 되므로
    //Column 자동 생성 후 아래 파일 내용을 복사하여 TForm에 추가해 주어야 함
    if not AIsIgnoreSaveFile then
    begin
      LStrList.SaveToFile('c:\temp\NextGridColumnList.txt');
      ShowMessage('c:\temp\NextGridTextColumnList.txt is saved.' + #13#10 +
        'NextGrid Column을 추가하면 TForm 선언부에 ColumnName: ColumnType 이 추가 되므로' + #13#10 +
        'Column 자동 생성 후 아래 파일 내용을 복사하여 TForm에 추가해 주어야 함.');
    end;

    LStrList.Free;
  end;
end;

function AddNextGridRowFromVariant(AGrid: TNextGrid; ADoc: Variant;
  AIsFromValue: Boolean; ARow: integer): integer;
var
  i: integer;
  LColName: string;
  LCellValue: variant;
  LColumn: TnxCustomColumn;
  LCell: TCell;
begin
  with AGrid do
  begin
//    BeginUpdate;
    try
      if ARow = -1 then
        ARow := AddRow();

      for i := 0 to TDocVariantData(ADoc).Count - 1 do
      begin
        LColName := TDocVariantData(ADoc).Names[i];

        if AIsFromValue then
          LCellValue := TDocVariantData(ADoc).Values[i]
        else
          LCellValue := StringToVariant(LColName);

        LColumn := ColumnByName[LColName];

        if Columns.IndexOf(LColumn) > -1 then
        begin
          LCell := CellByName[LColName, ARow];
          SetNxGridCellValueFromVar(LColumn, LCell, LCellValue);
        end;
      end;//for

    finally
//      EndUpdate;
    end;
  end;//with

  Result := ARow;
end;

procedure AddNextGridRowFromVariant2(AGrid: TNextGrid; ADoc: Variant; AIsFromValue: Boolean=false);
var
  i, j: integer;
  LCellValue: variant;
  LColumn: TnxCustomColumn;
  LCell: TCell;
begin
  with AGrid do
  begin
    j := AddRow;

    for i := 0 to TDocVariantData(ADoc).Count - 1 do
    begin
      if AIsFromValue then
        LCellValue := TDocVariantData(ADoc).Values[i]
      else
        LCellValue := TDocVariantData(ADoc).Names[i];

      LColumn := AGrid.Columns.Item[i];
      LCell := Cell[i, j];

      SetNxGridCellValueFromVar(LColumn, LCell, LCellValue);
    end;
  end;
end;

procedure AddNextGridRowsFromVariant(AGrid: TNextGrid; ADynAry: TRawUTF8DynArray; AIsAddColumn: Boolean);
var
  i: integer;
  LDoc: variant;
begin
  AGrid.BeginUpdate;
  try
    for i := Low(ADynAry) to High(ADynAry) do
    begin
      LDoc := _JSON(ADynAry[i]);

      if AIsAddColumn then
      begin
        if i = Low(ADynAry) then
          AddNextGridColumnFromVariant(AGrid, LDoc, False);
      end;

      AddNextGridRowFromVariant(AGrid, LDoc, True);
    end;//for

  finally
    AGrid.EndUpdate();
  end;
end;

procedure AddNextGridRowsFromVariant2(AGrid: TNextGrid; ADoc: Variant; AIsAddColumn: Boolean);
var
  LUtf8: RawUTF8;
//  LDynUtf8: TRawUTF8DynArray;
//  LDynArr: TDynArray;
  LDocList: IDocList;
//  LDocDict: IDocDict;
  LVar: variant;
begin
  if ADoc = null then
    exit;

  LUtf8 := ADoc;
  LDocList := DocList(LUtf8);

  AGrid.BeginUpdate;
  try
    if AIsAddColumn then
    begin
      if LDocList.Value^.Count > 0 then
      begin
        LVar := _JSON(LDocList.Item[0]);
        AddNextGridColumnFromVariant(AGrid, LVar, False, True, True);
      end;
    end;

    for LVar in LDocList do
    begin
      AddNextGridRowFromVariant(AGrid, _JSON(LVar), True);
    end;
  finally
    AGrid.EndUpdate();
  end;

//  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);

//  if LDynArr.LoadFromJSON(LUtf8) then//PUTF8Char(LUtf8));
//  begin
//    if LDynArr.Count = 0 then
//      exit;

//    AddNextGridRowsFromVariant(AGrid, LDynUtf8, AIsAddColumn);
//  end;
end;

function AddNextGridRowsFromJsonAry(AGrid: TNextGrid; AJsonAry: RawUtf8; AIsAddColumn: Boolean=false): integer;
var
  LDocList: IDocList;
  LVar: variant;
  LUtf8: RawUtf8;
  LRow: integer;
begin
  AGrid.ClearRows();

  LDocList := DocList(AJsonAry);

  for LVar in LDocList do
  begin
    if AIsAddColumn then
      AddNextGridColumnFromVariant(AGrid, LVar, False, False, True);
    //LVar Name : Grid의 Column Name
    //LVar Value : Grid Cell Value
    AddNextGridRowFromVarOnlyColumnExist(AGrid, LVar);
  end;//for

  Result :=  LDocList.Len;
end;

//ADoc는 복수개의 레코드에 대한 Json 임
//AIsUsePosFunc : True = Pos함수를 사용하여 LCompName이 Column Name에 포함되어 있으면 처리
function GetListFromVariant2NextGrid(AGrid: TNextGrid; ADoc: Variant;
  AIsAdd: Boolean; AIsArray: Boolean; AIsUsePosFunc: Boolean; AIsClearRow: Boolean): integer;
var
  i, j, LRow, LCount: integer;
  LColName: string;
//  LDynUtf8: TRawUTF8DynArray;
//  LDynArr: TDynArray;
  LDocList: IDocList;
  LUtf8: RawUTF8;
  LVar: variant;

  LCellValue: variant;
  LColumn: TnxCustomColumn;
  LCell: TCell;

  //AJson은 한개의 레코드에 대한 Json임
  procedure AddRowFromVar(AJson: variant);
  var
    Li, Lj: integer;
  begin
    with AGrid do
    begin
      if AIsAdd then
        LRow := AddRow()
      else
        LRow := SelectedRow;

      //한글 깨지면 Count = 0
      for Li := 0 to TDocVariantData(AJson).Count - 1 do
      begin
        LColName := TDocVariantData(AJson).Names[Li];

        if AIsUsePosFunc then
        begin
          for Lj := 0 to Columns.Count - 1 do
          begin
            //Grid에 Column Name이 존재하면
            if POS(LColName, Columns[Lj].Name) > 0 then
            begin
              LColumn := ColumnByName[LColName];
              LCell := CellByName[LColName, LRow];
              LCellValue := TDocVariantData(AJson).Values[Li];

              SetNxGridCellValueFromVar(LColumn, LCell, LCellValue);
            end;
          end;
        end
        else if Columns.IndexOf(ColumnByName[LColName]) > -1 then
        begin
          LColumn := ColumnByName[LColName];
          LCell := CellByName[LColName, LRow];
          LCellValue := TDocVariantData(AJson).Values[Li];

          SetNxGridCellValueFromVar(LColumn, LCell, LCellValue);
        end;
      end;
    end;//with
  end;
begin
  AGrid.BeginUpdate;

  if AIsClearRow then
    AGrid.ClearRows;

  try
    if AIsArray then
    begin
      LUtf8 := ADoc;
      LDocList := DocList(LUtf8);

      for LVar in LDocList do
      begin
        //LVar은 한글 깨짐
        LUtf8 := VariantToUTF8(LVar);
        ADoc := _JSON(LUtf8);
        AddRowFromVar(ADoc);
      end;

    end
    else
    begin
      AddRowFromVar(ADoc);
    end;
  finally
    AGrid.EndUpdate;

    if AIsArray then
      Result :=  LDocList.Len
    else
      Result :=  TDocVariantData(ADoc).Count;
  end;
end;

//Result에 [{"NextGrid.ColumnName": NextGrid.CellsByName}] Array 형식으로 저장됨
function NextGrid2Variant(AGrid: TNextGrid; ARemoveUnderBar, ASkipInVisible, ASelectedOnly: Boolean): variant;
var
  LDocList: IDocList;
begin
  TDocVariant.New(Result);
  LDocList := NextGrid2DocList(AGrid, ARemoveUnderBar, ASkipInVisible);
  Result := LDocList.Json;
end;

function NextGrid2DocList(AGrid: TNextGrid; ARemoveUnderBar,ASkipInVisible,ASelectedOnly: Boolean): IDocList;
var
  i, j: integer;
  LColName: string;
  LUtf8: RawUTF8;

  LCellValue: variant;
  LColumn: TnxCustomColumn;
  LCell: TCell;
begin
  Result := DocList('[]');
  TDocVariant.New(LCellValue);

  with AGrid do
  begin
    for i := 0 to RowCount - 1 do
    begin
      if ASkipInVisible then
        if not Row[i].Visible then
          Continue;

      if ASelectedOnly then
        if not Row[i].Selected then
          Continue;

      for j := 0 to Columns.Count - 1 do
      begin
        LColName := Columns.Item[j].Name;

        //Increment Cell이 자동 추가 된 경우 Name = '' 이므로 Skip
        if LColName = '' then
          Continue;

        if ARemoveUnderBar then
          LColName := strToken(LColName, '_');

        LColumn := ColumnByName[LColName];
        LCell := CellByName[LColName, i];

        SetNxGridCellValue2Var(LColumn, LCell, LCellValue);
      end;

      Result.Append(LCellValue);
    end;//for
  end;//with
end;

function GetNxGridRow2Variant(AGrid: TNextGrid; ARow: integer): variant;
var
  i: integer;
  LColName: string;
  LCellValue: variant;
  LColumn: TnxCustomColumn;
  LCell: TCell;
begin
//  TDocVariant.New(Result);

  with AGrid do
  begin
    for i := 0 to Columns.Count - 1 do
    begin
      LColName := Columns.Item[i].Name;

      LColumn := ColumnByName[LColName];
      LCell := CellByName[LColName, ARow];

      SetNxGridCellValue2Var(LColumn, LCell, Result);
    end;//for
  end;//with
end;

procedure SetNxGridRowFromVar(AGrid: TNextGrid; var ARow: integer; AVar: variant);
var
  i: integer;
  LColName: string;

  LCellValue: variant;
  LColumn: TnxCustomColumn;
  LCell: TCell;
begin
  with AGrid do
  begin
    if ARow = -1 then
      ARow := AGrid.AddRow();

    for i := 0 to TDocVariantData(AVar).Count - 1 do
    begin
      LColName := TDocVariantData(AVar).Names[i];
      LColumn := ColumnByName[LColName];

      //Grid에 Column이 존재하면
      if Columns.IndexOf(LColumn) > -1 then
      begin
        LCell := CellByName[LColName, ARow];
        LCellValue := TDocVariantData(AVar).Values[i];

        SetNxGridCellValueFromVar(LColumn, LCell, LCellValue);
      end;
    end;//for
  end;//with
end;

procedure SetNxGridCellValueFromVar(AColumn: TnxCustomColumn; ACell: TCell; AVar: variant);
var
  LBool: Boolean;
begin
  if AColumn.ColumnType = ctDate then
    ACell.AsDateTime := VarToDateWithTimeLog(AVar)//TimelogToDateTime(StrToInt64(TDocVariantData(AJson).Values[Li]))
  else
  if AColumn.ColumnType = ctFloat then
  begin
    ACell.AsFloat := StrToFloatDef(VariantToString(AVar), 0.0);
  end
  else
  if AColumn.ColumnType = ctBoolean then //CheckBox Type
  begin
    VariantToBoolean(AVar, LBool);
    ACell.AsBoolean := LBool;
  end
  else //반드시 String Type만 대입 할 것
    ACell.AsString := VariantToString(AVar);
end;

procedure SetNxGridCellValue2Var(AColumn: TnxCustomColumn; ACell: TCell; var AVar: variant);
var
  LColName: string;
begin
  LColName := AColumn.Name;

  if AColumn.ColumnType = ctDate then
    TDocVariantData(AVar).Value[LColName] := VarFromDateWithTimeLog(ACell.AsDateTime) //TimeLogFromDateTime(AGrid.CellByName[LColumnName, ARow].AsDateTime)
  else
  if AColumn.ColumnType = ctFloat then
    TDocVariantData(AVar).Value[LColName] := ACell.AsFloat
  else
  if AColumn.ColumnType = ctBoolean then
    TDocVariantData(AVar).Value[LColName] := ACell.AsBoolean
  else
    TDocVariantData(AVar).Value[LColName] := ACell.AsString;
end;

procedure NextGrid2JsonFile(AGrid: TNextGrid; ASaveFileName: string);
var
  LStrList: TStringList;
  i, j: integer;
  LColName: string;
  LUtf8: RawUTF8;
  LDocList: IDocList;

  LCellValue: variant;
  LColumn: TnxCustomColumn;
  LCell: TCell;
begin
  if ASaveFileName = '' then
    exit;

  LStrList := TStringList.Create;
  try
    TDocVariant.New(LCellValue);
    LDocList := DocList('[]');

    with AGrid do
    begin
      for i := 0 to RowCount - 1 do
      begin
        for j := 0 to Columns.Count - 1 do
        begin
          LColName := AGrid.Columns.Item[j].Name;
          LColumn := ColumnByName[LColName];
          LCell := CellByName[LColName, i];

          SetNxGridCellValue2Var(LColumn, LCell, LCellValue);
        end;

        LDocList.Append(LCellValue);
      end;
    end;

    LCellValue := LDocList.Json;
    LStrList.Text := VariantToUtf8(LCellValue);
    LStrList.SaveToFile(ASaveFileName, TEncoding.UTF8);
  finally
    LStrList.Free;
  end;
end;

procedure NextGridFromJsonFile(AGrid: TNextGrid; AFileName: string; AIsClearRow: Boolean);
var
  LStrList: TStringList;
  LStr: string;
  LDocList: IDocList;
  LUtf8: RawUTF8;
  LVar: variant;
  i: integer;
begin
  LStrList := TStringList.Create;
  try
    LStrList.LoadFromFile(AFileName, TEncoding.UTF8);

    LStr := LStrList.Text;
    LUtf8 := StringToUtf8(LStr);

    LDocList := DocList(LUtf8);

    for LVar in LDocList do
      GetListFromVariant2NextGrid(AGrid, LVar, True);

  finally
    LStrList.Free;
  end;
end;

//{ColumnName: Cell Value} 형식으로 저장됨
function NextGrid2VariantFromColIndexAry(AGrid: TNextGrid; AColIndexAry: TArrayRecord<integer>): variant;
var
  i, j: integer;
  LColumnName: string;
  LUtf8: RawUTF8;
  LDocList: IDocList;
  LVar: variant;

  LCellValue: variant;
  LColumn: TnxCustomColumn;
  LCell: TCell;
begin
  TDocVariant.New(Result);
  TDocVariant.New(LVar);

  for i := 0 to AGrid.RowCount - 1 do
  begin
    for j := 0 to AColIndexAry.Count - 1 do
    begin
      LColumnName := AGrid.Columns.Item[AColIndexAry[j]].Name;

      TDocVariantData(LVar).Value[LColumnName] := AGrid.CellsByName[LColumnName, i];
    end;

    LDocList.Append(LVar);
  end;

  Result := LDocList.Json;
end;

function GetJsonFromSelectedRow(AGrid: TNextGrid; ARemoveUnderBar: Boolean): RawUTF8;
var
  i, j: integer;
  LColumnName: string;
  LV, LValue: variant;

  LCellValue: variant;
  LColumn: TnxCustomColumn;
  LCell: TCell;
begin
  TDocVariant.New(LV);

  for j := 0 to AGrid.Columns.Count - 1 do
  begin
    LColumnName := AGrid.Columns.Item[j].Name;

    if ARemoveUnderBar then
      LColumnName := strToken(LColumnName, '_');

    LValue := AGrid.Cell[j, AGrid.SelectedRow].AsVariant;
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

procedure ShowOrHideAllColumn4NextGrid(ANextGrid: TNextGrid; AIsShow: Boolean);
var
  j: integer;
  LColumnName: string;
begin
  for j := 0 to ANextGrid.Columns.Count - 1 do
  begin
    ANextGrid.Columns.Item[j].Visible := AIsShow;
  end;//for
end;

function GetRowFromMouseDown(ANextGrid: TNextGrid; APoint: TPoint): integer;
var
  LRowNo,
  LRowY,
  LRowWithHeight: integer;
  LRowRect: TRect;
  i: integer;
begin
  Result := -1;

  with ANextGrid do
  begin
    LRowNo := 0;

    for i := 0 to RowCount - 1 do
    begin
      LRowRect := GetRowRect(LRowNo);

      if PtInRect(LRowRect, APoint) then
      begin
         Result := LRowNo;
         Break;
      end
      else
      begin
        LRowY := GetRowTop(LRowNo);//Row Top Point = Y

        if LRowY > APoint.Y then //현재 row 보다 위쪽을 클릭한 경우 (Row Top Point > Mouse Point)
          Break;

        LRowWithHeight := (APoint.Y - LRowY) div RowSize;
        LRowNo := LRowNo + LRowWithHeight;
      end;
    end;

  end;
end;

function GetRowIndexFromFindNext(const ANextGrid: TNextGrid; AFindText: string;
  AColIdx: integer; var AFindFromRow: integer; AIgnoreCase: Boolean;
  AColName: string): integer;
var
  i: integer;
  LStr: string;
begin
  Result := -1;

  if AIgnoreCase then
    AFindText := UpperCase(AFindText);

  if AFindFromRow > ANextGrid.RowCount - 1 then
    AFindFromRow := 0;

  if AColIdx = -1 then
  begin
    for i := 0 to ANextGrid.Columns.Count - 1 do
    begin
      LStr := ANextGrid.Columns.Item[i].Name;

      if LStr = AColName then
      begin
        AColIdx := i;
        Break;
      end;
    end;
  end;

  if AColIdx = -1 then
    exit;

  for i := AFindFromRow to ANextGrid.RowCount - 1 do
  begin
    LStr := ANextGrid.Cell[AColIdx, i].AsString;

    if AIgnoreCase then
      LStr := UpperCase(LStr);

    if PosEx(AFindText, LStr) > 0 then
    begin
      Result := i;
      AFindFromRow := i + 1;
      Exit;
    end
    else
      AFindFromRow := 0;
  end;//for
end;

function GetSelectedIndexFromNextGrid(ANextGrid: TNextGrid): integer;
begin
  for Result := 0 to ANextGrid.RowCount - 1 do
  begin
    if ANextGrid.Selected[Result] then
      Break;
  end;
end;

function ChangeRowColorByIndex(AGrid: TNextGrid; ARowIndex: integer; AColor: TColor): TColor;
var
  i: integer;
begin
  Result := AGrid.Cell[0, ARowIndex].Color;

  for i := 0 to AGrid.Columns.Count - 1 do
  begin
    AGrid.Cell[i, ARowIndex].Color := AColor;
  end;
end;

function ChangeRowFontColorByIndex(AGrid: TNextGrid; ARowIndex: integer;
  AColor: TColor; AIsBold: Boolean): TColor;
var
  i: integer;
begin
  Result := AGrid.Cell[0, ARowIndex].TextColor;

  for i := 0 to AGrid.Columns.Count - 1 do
  begin
    AGrid.Cell[i, ARowIndex].TextColor := AColor;

    if AIsBold then
      AGrid.Cell[i, ARowIndex].FontStyle := [fsBold];
  end;
end;

procedure CsvFile2NextGrid(ACsvFileName: string; ANextGrid: TNextGrid);
var
  csv : TextFile;
  csvLine: String;
  vList: TStringList;
  iy, icnt, ix: Integer;
begin
  if not FileExists(ACsvFileName) then
    exit;

  vList := TStringList.Create;
  AssignFile(csv, ACsvFileName);
  Reset(csv);
  iy := 0;
  ix := 0;

  with ANextGrid do
  begin
    BeginUpdate;
    ClearRows;

    while not eof(csv) do
    Begin
      AddRow();
      Readln(csv, csvLine);
      csvLine := StringReplace(csvLine, ',', '","', [rfReplaceAll]);
      csvLine := '"' + csvLine;

      if csvLine[Length(csvLine)] <> '"' Then
        csvLine := csvLine + '"';

      vList.CommaText := csvLine;

      if (vLIst.Count+1) > ix Then
        ix := vLIst.Count+1;

      for icnt := 0 to vLIst.Count - 1 do
        Cells[icnt+1, iy] := vLIst.Strings[icnt];
      inc(iy);
    end;

  end;

  CloseFile(csv);
  vList.Free;
end;

procedure AddNextGridRowFromVarOnlyColumnExist(AGrid: TNextGrid; AJson: Variant);
var
  LRow, Li, Lj: integer;
  LColName: string;
  LColumn: TnxCustomColumn;
  LCell: TCell;
  LCellValue: Variant;
begin
  with AGrid do
  begin
    LRow := AddRow();

    //한글 깨지면 Count = 0
    for Li := 0 to TDocVariantData(AJson).Count - 1 do
    begin
      LColName := TDocVariantData(AJson).Names[Li];

      for Lj := 0 to Columns.Count - 1 do
      begin
        //Grid에 Column Name이 존재하면
        if POS(LColName, Columns[Lj].Name) > 0 then
        begin
          LColumn := ColumnByName[LColName];
          LCell := CellByName[LColName, LRow];
          LCellValue := TDocVariantData(AJson).Values[Li];

          SetNxGridCellValueFromVar(LColumn, LCell, LCellValue);
        end;
      end;
    end;//for
  end;//with
end;

{ TCellHelper }

function TCellHelper.AsVariant: variant;
begin
  if ClassName = 'TStringCell' then
    Result := TVariantCls.GetAsVariant<String>(AsString)
  else
  if ClassName = 'TDateTimeCell' then
    Result := TVariantCls.GetAsVariant<TDateTime>(AsDateTime)
  else
  if ClassName = 'TIntegerCell' then
    Result := TVariantCls.GetAsVariant<Integer>(AsInteger)
  else
  if ClassName = 'TBooleanCell' then
    Result := TVariantCls.GetAsVariant<Boolean>(AsBoolean)
  else
  if ClassName = 'TFloatCell' then
    Result := TVariantCls.GetAsVariant<Double>(AsFloat)
  else
  if ClassName = 'TIncrementCell' then
    Result := TVariantCls.GetAsVariant<Integer>(AsInteger);
end;

procedure SetColumnCaptionFromListOnlyColumnExist(AGrid: TNextGrid; AStrList: TStringList);
var
  Li, Lj: integer;
  LColName, LCaption: string;
  LColumn: TnxCustomColumn;
begin
  with AGrid do
  begin
    for Li := 0 to AStrList.Count - 1 do
    begin
      LColName := AStrList.Names[Li];
      LCaption := AStrList.ValueFromIndex[Li];

      for Lj := 0 to Columns.Count - 1 do
      begin
        //Grid에 Column Name이 존재하면
        if POS(LColName, Columns[Lj].Name) > 0 then
        begin
          LColumn := ColumnByName[LColName];
          LColumn.Header.Caption := LCaption;
        end;
      end;
    end;//for
  end;//with
end;

end.

