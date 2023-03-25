unit UnitStringListUtil;

interface

uses classes, SysUtils, StrUtils;

procedure CompareStringLists(AList1, AList2: TStringList; AMissing1, AMissing2: TStrings);
function FindMatchStrFromList(AStrings: TStrings; const ASubStr: string; AIsCaseSensitive: Boolean = False): integer;

implementation

procedure CompareStringLists(AList1, AList2: TStringList; AMissing1, AMissing2: TStrings);
var
  i,j: integer;
begin
//  AList1.Sort;
//  AList2.Sort;

  i := 0;
  j := 0;

  AMissing1.Clear;
  AMissing2.Clear;

  while (i < AList1.Count) and (j < AList2.Count) do
  begin
    if AList1[i] <> AList2[j] then
    begin
      AMissing2.Add(AList1[i]+';'+IntToStr(i));
      Inc(i);
    end
    else
    if AList1[i] > AList2[j] then
    begin
      AMissing1.Add(AList2[j]+';'+IntToStr(j));
      Inc(j);
    end
    else begin
      Inc(i);
      Inc(j);
    end;
  end;//while

  for i := i to AList1.Count - 1 do
    AMissing2.Add(AList1[i]+';'+IntToStr(i));

  for j := j to AList2.Count - 1 do
    AMissing1.Add(AList2[j]+';'+IntToStr(j));
end;

function FindMatchStrFromList(AStrings: TStrings; const ASubStr: string; AIsCaseSensitive: Boolean): integer;
begin
  for Result := 0 to AStrings.Count - 1 do
  begin
    if AIsCaseSensitive then
    begin
      if ContainsStr(AStrings[Result], ASubStr) then
        exit;
    end
    else
    begin
      if ContainsText(AStrings[Result], ASubStr) then
        exit;
    end;
  end;

  Result := -1;
end;

end.
