unit UnitListBoxUtil;

interface

uses Vcl.StdCtrls, ArrayHelper, System.Generics.Collections;

function GetSelectedIndexs(AListBox: TListBox): TArray<integer>;
procedure MoveUpSelectedItemsFromListBox(AListBox: TListBox);
procedure MoveDownSelectedItemsFromListBox(AListBox: TListBox);

implementation

uses UnitArrayUtil;

function GetSelectedIndexs(AListBox: TListBox): TArray<integer>;
var
  i: integer;
begin
  for i := 0 to AListBox.Count - 1 do
  begin
    if AListBox.Selected[i] then
      TArray.Add<Integer>(Result, i);
  end;
end;

procedure MoveUpSelectedItemsFromListBox(AListBox: TListBox);
var
  i: integer;
begin
  AListBox.Items.BeginUpdate;
  try
    for i := 0 to AListBox.Count - 1 do
    begin
      if AListBox.Selected[i] then
      begin
        if i = 0 then
          Break;

        AListBox.Items.Move(i, i - 1);
        AListBox.Selected[i] := False;
        AListBox.Selected[i-1] := True;
      end;
    end;
  finally
    AListBox.Items.EndUpdate;
  end;
end;

procedure MoveDownSelectedItemsFromListBox(AListBox: TListBox);
var
  i: integer;
begin
  AListBox.Items.BeginUpdate;
  try
    for i := AListBox.Count - 1 downto 0 do
    begin
      if AListBox.Selected[i] then
      begin
        if i = (AListBox.Count - 1) then
          Break;

        AListBox.Items.Move(i, i + 1);
        AListBox.Selected[i] := False;
        AListBox.Selected[i+1] := True;
      end;
    end;
  finally
    AListBox.Items.EndUpdate;
  end;
end;

end.
