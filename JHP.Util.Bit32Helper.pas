unit JHP.Util.Bit32Helper;

interface
//»ç¿ë¹ý
{  var x: Integer := 123;
       LpjhBit32: TpjhBit32;

  LpjhBit32 := x;
  Writeln(LpjhBit32.Bit[4]); // read
  LpjhBit32.Bit[6] := False; // write
}
type
  TpjhBit32 = type Integer;

  TpjhBit32Helper = record helper for TpjhBit32
  strict private
    function GetBit(Index: Integer): Boolean;
    procedure SetBit(Index: Integer; const Value: Boolean);
  public
    property Bit[Index: Integer]: Boolean read GetBit write SetBit;
  end;

implementation

function TpjhBit32Helper.GetBit(Index: Integer): Boolean;
begin
  Result := (Self shr Index) and 1 <> 0;
end;

procedure TpjhBit32Helper.SetBit(Index: Integer; const Value: Boolean);
begin
  if Value then
    Self := Self or (1 shl Index)
  else
    Self := Self and not (1 shl Index);
end;

end.
