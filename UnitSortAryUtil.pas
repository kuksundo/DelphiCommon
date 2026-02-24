unit UnitSortAryUtil;

interface

uses classes,
  mormot.core.base, mormot.core.variants;

type
  TSortAryUtil = class
    class procedure InitOrder(var Order: array of Integer); static;
    class procedure ApplyMove(var CurrentAry: array of Integer;
                    OldIdx, NewIdx: Integer); static;
    //AColAry의 모든 내용이 같은 SortDataList를 중복 제거한 후 반환함
    class function GetUniqListSortDataList(ASortDataList: IDocList): TStringList; static;
  end;


implementation

{ TSortAryUtil }

class procedure TSortAryUtil.ApplyMove(var CurrentAry: array of Integer;
  OldIdx, NewIdx: Integer);
var
  temp, i, k: Integer;
begin
  if OldIdx = NewIdx then Exit;

  temp := CurrentAry[OldIdx];

  if OldIdx < NewIdx then
  begin
    for k := OldIdx to NewIdx - 1 do
      CurrentAry[k] := CurrentAry[k + 1];
  end
  else
  begin
    for k := OldIdx downto NewIdx + 1 do
      CurrentAry[k] := CurrentAry[k - 1];
  end;

  CurrentAry[NewIdx] := temp;
end;

class function TSortAryUtil.GetUniqListSortDataList(
  ASortDataList: IDocList): TStringList;
var
  LDocDict: IDocDict;
  LFilterStr: RawUtf8;
  LStr: string;
  i: integer;
begin
  Result := nil;

  if ASortDataList.Len > 0 then
  begin
    Result := TStringList.Create;
    //SortData Value 리스트에서 중복을 제거한 리스트 만듬
    for LDocDict in ASortDataList.Objects do
    begin
      if LDocDict.Exists('SortData') then
      begin
        LStr := LDocDict.S['SortData'];
        Result.Add(LStr);
      end;
    end;//for

    Result.Sorted := True;          // 정렬 필요
    Result.Duplicates := dupIgnore; // 중복 자동 제거
  end;
end;

class procedure TSortAryUtil.InitOrder(var Order: array of Integer);
var
  i: Integer;
begin
  for i := Low(Order) to High(Order) do
  begin
    Order[i] := i;   // 현재 위치에 있는 초기 인덱스
  end;
end;

end.
