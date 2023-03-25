unit JHP.Util.Bit;

interface

function GetBitVal(const i, Nth: integer): integer;
//get if a particular bit is 1
function Get_a_Bit(const aValue: Cardinal; const Bit: Byte): Boolean;
//set a particular bit as 1
function Set_a_Bit(const aValue: Cardinal; const Bit: Byte): Cardinal;
//set a particular bit as 0
function Clear_a_Bit(const aValue: Cardinal; const Bit: Byte): Cardinal;
//Enable or disable a bit
function Enable_a_Bit(const aValue: Cardinal; const Bit: Byte; const Flag: Boolean): Cardinal;
//get some bits from value
{
bit number  8  7  6  5  4  3  2  1
176 dec =   1  0  1  1  0  0  0  0
251 dec =   1  1  1  1  1  0  1  1

ex)
  ExtractBitsRL(176, 5, 4) => b1011 = 11, index 5부터 왼쪽으로 4bit 가져옴
  ExtractBitsRL(251, 1, 4) => b1011 = 11, index 1부터 왼쪽으로 4bit 가져옴
}
function ExtractBitsRL(value, bits_start, bits_len: Integer) : Integer;
{
bit number  1  2  3  4  5  6  7  8
176 dec =   1  0  1  1  0  0  0  0
251 dec =   1  1  1  1  1  0  1  1

ex)
  ExtractBitsLRFromByte(176, 1, 4) => b1011 = 11, index 1부터 오른쪽으로 4bit 가져옴
  ExtractBitsLRFromByte(251, 5, 4) => b1011 = 11, index 5부터 오른쪽으로 4bit 가져옴
}
function ExtractBitsLRFromByte(value: Byte; bits_start, bits_len: Integer) : Integer;
{
bit number  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
176 dec =   0  0  0  0  0  0  0  0  1  0  1  1  0  0  0  0

ex)
  ExtractBitsLRFromByte(176, 9, 4) => 1011 = 11, index 9부터 오른쪽으로 4bit 가져옴
}
function ExtractBitsLRFromInt(value, bits_start, bits_len: Integer) : Integer;

implementation

function GetBitVal(const i, Nth: integer): integer;
begin
  Result := (i and (1 shl Nth));
end;

//get if a particular bit is 1
function Get_a_Bit(const aValue: Cardinal; const Bit: Byte): Boolean;
begin
  Result := (aValue and (1 shl Bit)) <> 0;
end;

//set a particular bit as 1
function Set_a_Bit(const aValue: Cardinal; const Bit: Byte): Cardinal;
begin
  Result := aValue or (1 shl Bit);
end;

//set a particular bit as 0
function Clear_a_Bit(const aValue: Cardinal; const Bit: Byte): Cardinal;
begin
  Result := aValue and not (1 shl Bit);
end;

//Enable or disable a bit
function Enable_a_Bit(const aValue: Cardinal; const Bit: Byte; const Flag: Boolean): Cardinal;
begin
  Result := (aValue or (1 shl Bit)) xor (Integer(not Flag) shl Bit);
end;

function ExtractBitsRL(value, bits_start, bits_len: Integer) : Integer;
begin
  Result := ((value shr (bits_start - 1)) and ((1 shl bits_len) - 1));
end;

function ExtractBitsLRFromByte(value: Byte; bits_start, bits_len: Integer) : Integer;
begin
  Result := ((value shr (9 - bits_start - bits_len )) and ((1 shl bits_len) - 1));
  // would be 8 if you started at bit zero
end;

function ExtractBitsLRFromInt(value, bits_start, bits_len: Integer) : Integer;
begin
  Result := ((value shr (17 - bits_start - bits_len )) and ((1 shl bits_len) - 1));
  // would be 16 if you started at bit zero
end;

end.
