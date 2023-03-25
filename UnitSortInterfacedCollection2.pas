unit UnitSortInterfacedCollection2;

interface

uses classes, Generics.Collections, System.Types,
  mormot.core.data;

type
  TDirection = System.Types.TDirection;

  TSortableInterfacedCollection = class(TInterfacedCollection)
  protected
    FDirection: TDirection;

    function Compare(Item1, Item2 : TCollectionItem) : integer; virtual;
    procedure QuickSort(L, R: Integer);
  public
    procedure Sort(ADirection: TDirection = FromBeginning);
    property SortDirection: TDirection read FDirection write FDirection;
  end;

implementation

type
  // Helper class to allow sorting of a TCollection
  {$HINTS OFF}
  TShadowedCollection = class(TPersistent)
  private
    FItemClass: TCollectionItemClass;
    FItems: TList<TCollectionItem>;
  end;
  {$HINTS ON}

{ TSortableCollection }

function TSortableInterfacedCollection.Compare(Item1, Item2: TCollectionItem): integer;
begin
{
Descendant classes would override this method and cast Item1 and Item2 to the
decendant class's collection item type perform the field comparisions

if item1.MyField < item2.MyField
  return -1
else if item1.MyField > item2.MyField
  return 1
else return 0
}
  result := 0;
end;

procedure TSortableInterfacedCollection.QuickSort(L, R: Integer);
var
  I, J, p: Integer;
  Save: TCollectionItem;
  SortList: TList<TCollectionItem>;
begin
  //This cast allows us to get at the private elements in the base class
  SortList := TShadowedCollection(Self).FItems;

  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;

    repeat
      while Compare(Items[I], Items[P]) < 0 do
        Inc(I);

      while Compare(Items[J], Items[P]) > 0 do
        Dec(J);

      if I <= J then begin
        Save              := SortList.Items[I];
        SortList.Items[I] := SortList.Items[J];
        SortList.Items[J] := Save;

        if P = I then
          P := J
        else if P = J then
          P := I;

        Inc(I);
        Dec(J);
      end;
    until I > J;

    if L < J then
      QuickSort(L, J);
    L := I;
  until I >= R;
end;

procedure TSortableInterfacedCollection.Sort(ADirection: TDirection);
begin
  if Count > 1 then
  begin
    SortDirection := ADirection;
    QuickSort(0, pred(Count));
  end;
end;

end.

