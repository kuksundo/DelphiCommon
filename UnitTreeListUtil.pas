unit UnitTreeListUtil;

interface

uses Classes, SysUtils, ComCtrls, inifiles,
  mormot.core.base, mormot.core.os, mormot.core.text,
  mormot.core.collections, mormot.core.variants, mormot.core.json,
  mormot.core.unicode,
  TreeList;

procedure LoadTreeListFromIni(ATreeList: TTreeList; const IniFileName: string);
procedure SaveTreeListToIni(ATreeList: TTreeList; const IniFileName: string);

procedure LoadSecName2TLFromIni(ATreeList: TTreeList; const IniFileName, ASecction, AName: string);

procedure LoadTreeListFromIniJson(ATreeList: TTreeList; const AJson: RawUtf8);
procedure SaveTreeListToIniJson(ATreeList: TTreeList; const AJson: RawUtf8);

//ASrchColIndex: 검색할 Column
//ANthStart: 0,1 = 첫번째로 찾은 노드 Focused, 2 = 2번쨰로 찻은 노드 Focused, 검색을 반환할  빈도수
function FindAndFocusTreeListFromTxt(ASrchText: string; ASrchColIndex, ANthStart: integer; ATreeList: TTreeList): integer;

implementation

procedure LoadTreeListFromIni(ATreeList: TTreeList; const IniFileName: string);
var
  IniFile: TIniFile;
  RootNode: TTreeNode;
  Sections, NodeNames: TStringList;
  i, j, k, m, LWidth: Integer;
  LStr, ValueText: string;
begin
  LWidth := 0;
  IniFile := TIniFile.Create(IniFileName);
  Sections := TStringList.Create;
  NodeNames := TStringList.Create;

  ATreeList.Items.BeginUpdate;
  try
    ATreeList.Items.Clear;
    ATreeList.Columns.Clear;
    ATreeList.Separator := ';';
    ATreeList.Columns.Add.Header := 'Section-Name';
    ATreeList.Columns.Add.Header := 'Value';

    // Get all the section names in the INI file
    IniFile.ReadSections(Sections);

    // Loop through the sections to add root nodes
    for i := 0 to Sections.Count - 1 do
    begin
      Sections.Objects[i] := ATreeList.Items.Add(nil, Sections[i]);

      IniFile.ReadSection(Sections[i], NodeNames);

      for j := 0 to NodeNames.Count - 1 do
      begin
        LStr := Trim(NodeNames[j]);

        if LStr[1] = '#' then
          Continue;

        LStr := Sections[i] + LStr;

        if LWidth < LStr.Length then
        begin
          LWidth := LStr.Length;
          ATreeList.Columns.Items[0].Width := LWidth * ATreeList.Font.Size;
        end;

        NodeNames.Objects[j] := ATreeList.Items.AddChild(TTreeNode(Sections.Objects[i]), NodeNames[j]);
        ValueText := NodeNames[j] + ATreeList.Separator + IniFile.ReadString(Sections[i], NodeNames[j], '');

        if LWidth < ValueText.Length then
        begin
          LWidth := ValueText.Length;
          ATreeList.Columns.Items[1].Width := LWidth;
        end;

        TTreeNode(NodeNames.Objects[j]).Text := ValueText;
        // Add children of the root node
      end;
    end;//for i

    ATreeList.FullExpand; // Optionally expand all nodes
  finally
    IniFile.Free;
    Sections.Free;
    NodeNames.Free;
    ATreeList.Items.EndUpdate;
  end;
end;

procedure SaveTreeListToIni(ATreeList: TTreeList; const IniFileName: string);
begin

end;

procedure LoadSecName2TLFromIni(ATreeList: TTreeList; const IniFileName, ASecction, AName: string);
var
  IniFile: TIniFile;
  RootNode: TTreeNode;
  LStr, LValueText: string;
begin
  IniFile := TIniFile.Create(IniFileName);

  ATreeList.Items.BeginUpdate;
  try
    ATreeList.Items.Clear;
    ATreeList.Columns.Clear;
    ATreeList.Separator := ';';
    ATreeList.Columns.Add.Header := 'Section-Name';
    ATreeList.Columns.Add.Header := 'Value';

    LValueText := IniFile.ReadString(ASecction, AName, '');

  finally
    IniFile.Free;
    ATreeList.Items.EndUpdate;
  end;
end;

function FindAndFocusTreeListFromTxt(ASrchText: string; ASrchColIndex, ANthStart: integer; ATreeList: TTreeList): integer;
var
  i: integer;
  LSearchMode: Boolean;
  LNode: TTreeNode;
  LStr: string;
begin
  LSearchMode := ASrchText <> ''; // true searcxh box not empty
  Result := 0;

  if LSearchMode then
  begin
    if ASrchColIndex = -1 then
      ASrchColIndex := 1;

    if ANthStart = 0 then
      ANthStart := 1;

    ATreeList.Items.BeginUpdate;
    try
      ASrchText:= Lowercase(ASrchText); // insures a case insensitive search
      try
        LNode := ATreeList.Items.GetFirstNode;

        while LNode <> nil do
        begin
          if Pos(ASrchText, LowerCase(LNode.Text)) > 0 then
          begin
            LNode.MakeVisible;
//            LNode.Selected := True;
//            LNode.Focused := True;
            ATreeList.Select(LNode);
//            LNode.Expand(False);
            Inc(Result);

            if Result >= ANthStart then
              Break;
          end;

          LNode := LNode.GetNext;
        end;//while
      finally
        if LSearchMode then
          ATreeList.FullExpand;
      end;
    finally
      ATreeList.Items.EndUpdate;
    end;
  end;//if LSearchMode
end;

procedure LoadTreeListFromIniJson(ATreeList: TTreeList; const AJson: RawUtf8);
var
  LDoc: IDocDict;
  LList: IDocList;
  LRootNode: TTreeNode;
  LStr: string;
begin
//  LDoc := DocDict('{}');
  LList:= DocList(AJson);

  ATreeList.Items.BeginUpdate;
  try
    ATreeList.Items.Clear;
    ATreeList.Columns.Clear;
    ATreeList.Separator := ';';
    ATreeList.Columns.Add.Header := 'Section-Name';
    ATreeList.Columns.Add.Header := 'Value';
    ATreeList.Columns.Add.Header := '기능설명';
    ATreeList.Columns.Add.Header := '설정방법';
    ATreeList.Columns.Add.Header := '대상프로그램';
    ATreeList.Columns.Add.Header := '설정변경후 적용방법';
    ATreeList.Columns.Add.Header := '비고';

    for LDoc in LList do
    begin
      LStr := Utf8ToString(LDoc.S['Section']);

      LRootNode := ATreeList.Items.Add(nil, LStr);
//      LDoc.S['Name']
//      LDoc.S['Value']
//      LDoc.S['기능설명']
//      LDoc.S['설정방법']
//      LDoc.S['대상프로그램']
//      LDoc.S['설정변경후 적용방법']
//      LDoc.S['비고']
    end;
  finally
    ATreeList.Items.EndUpdate;
  end;
end;

procedure SaveTreeListToIniJson(ATreeList: TTreeList; const AJson: RawUtf8);
begin

end;

end.
