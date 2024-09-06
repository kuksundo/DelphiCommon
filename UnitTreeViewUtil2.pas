unit UnitTreeViewUtil2;

interface

uses Classes, SysUtils, ComCtrls, inifiles,
  mormot.core.variants, mormot.core.collections;

function GetTreeView2Json(const ATV: TTreeView): string;
procedure FillTreeViewFromJson(ATV: TTreeView; AJson: string);
procedure LoadTreeViewFromIni(TreeView: TTreeView; const IniFileName: string);
procedure SaveTreeViewToIni(TreeView: TTreeView; const IniFileName: string);

implementation

function GetTreeView2Json(const ATV: TTreeView): string;
begin

end;

procedure FillTreeViewFromJson(ATV: TTreeView; AJson: string);
begin

end;

procedure LoadTreeViewFromIni(TreeView: TTreeView; const IniFileName: string);
var
  IniFile: TIniFile;
  RootNode, ChildNode, SubChildNode: TTreeNode;
  Sections, NodeNames: TStringList;
  i, j, k, m: Integer;
  NodeName, NodeText: string;
begin
  IniFile := TIniFile.Create(IniFileName);
  Sections := TStringList.Create;
  NodeNames := TStringList.Create;

  TreeView.Items.BeginUpdate;
  try
    TreeView.Items.Clear;
    // Get all the section names in the INI file
    IniFile.ReadSections(Sections);

    // Loop through the sections to add root nodes
    for i := 0 to Sections.Count - 1 do
    begin
      Sections.Objects[i] := TreeView.Items.Add(nil, Sections[i]);

      IniFile.ReadSection(Sections[i], NodeNames);

      for j := 0 to NodeNames.Count - 1 do
      begin
        NodeText := IniFile.ReadString(Sections[i], NodeNames[j], '');

        // Add children of the root node
        NodeNames.Objects[j] := TreeView.Items.AddChild(TTreeNode(Sections.Objects[i]), NodeNames[j] + ' : ' + NodeText);
      end;
    end;//for i

    TreeView.FullExpand; // Optionally expand all nodes
  finally
    IniFile.Free;
    Sections.Free;
    NodeNames.Free;
    TreeView.Items.EndUpdate;
  end;
end;

procedure SaveTreeViewToIni(TreeView: TTreeView; const IniFileName: string);
var
  IniFile: TIniFile;
  Node: TTreeNode;

  procedure SaveNode(Node: TTreeNode; const ParentSection: string);
  var
    ChildNode: TTreeNode;
    SectionName, ChildSection: string;
    ChildIndex: Integer;
  begin
    SectionName := ParentSection;

    // Save the current node
    if ParentSection = '' then
    begin
      // Save root node
      IniFile.WriteString('Nodes', 'Node' + IntToStr(Node.Index + 1), Node.Text);
      SectionName := 'Node' + IntToStr(Node.Index + 1);
    end
    else
    begin
      // Save child nodes
      ChildIndex := Node.Index + 1;
      IniFile.WriteString(ParentSection + 'Children', 'Child' + IntToStr(ChildIndex), Node.Text);
      SectionName := Node.Text;
    end;

    // Recursively save child nodes
    ChildNode := Node.GetFirstChild;
    while ChildNode <> nil do
    begin
      SaveNode(ChildNode, SectionName);
      ChildNode := ChildNode.GetNextSibling;
    end;
  end;

begin
  IniFile := TIniFile.Create(IniFileName);
  try
    IniFile.EraseSection('Nodes'); // Clear previous data in the INI file

    // Traverse and save the tree nodes
    Node := TreeView.Items.GetFirstNode;
    while Node <> nil do
    begin
      SaveNode(Node, '');
      Node := Node.GetNextSibling;
    end;
  finally
    IniFile.Free;
  end;
end;

end.
