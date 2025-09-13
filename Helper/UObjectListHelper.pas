unit UObjectListHelper;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections;

type
  TObjectListHelper<T: class> = class(TObjectList<T>)
  public
    type
      TReverseEnumerator = record
      private
        FList: TObjectList<T>;
        FIndex: Integer;
      public
        constructor Create(AList: TObjectList<T>);
        function GetCurrent: T;
        function MoveNext: Boolean;
        property Current: T read GetCurrent;
      end;

      TReverseEnumerable = record
      private
        FList: TObjectList<T>;
      public
        constructor Create(AList: TObjectList<T>);
        function GetEnumerator: TReverseEnumerator;
      end;

    function Reverse: TReverseEnumerable;
  end;

implementation
{ TObjectListHelper<T>.TReverseEnumerator }

constructor TObjectListHelper<T>.TReverseEnumerator.Create(AList: TObjectList<T>);
begin
  FList := AList;
  FIndex := AList.Count; // 마지막 요소 다음부터 시작
end;

function TObjectListHelper<T>.TReverseEnumerator.GetCurrent: T;
begin
  Result := FList[FIndex];
end;

function TObjectListHelper<T>.TReverseEnumerator.MoveNext: Boolean;
begin
  Dec(FIndex);
  Result := (FIndex >= 0);
end;

{ TObjectListHelper<T>.TReverseEnumerable }

constructor TObjectListHelper<T>.TReverseEnumerable.Create(AList: TObjectList<T>);
begin
  FList := AList;
end;

function TObjectListHelper<T>.TReverseEnumerable.GetEnumerator: TReverseEnumerator;
begin
  Result := TReverseEnumerator.Create(FList);
end;

{ TObjectListHelper<T> }

function TObjectListHelper<T>.Reverse: TReverseEnumerable;
begin
  Result := TReverseEnumerable.Create(Self);
end;

end.

