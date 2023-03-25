unit UnitFontUtil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, XSuperObject;

function FontStyletoStr(St: TFontStyles): string;
function StrtoFontStyle(St: string): TFontStyles;
function SetFont2Json(AFont: TFont): string;
procedure LoadFontFromJson(AFontJson: string; AFont: TFont);
procedure SaveFont2Ini(FName: string; Section: string; smFont: TFont);
procedure LoadFontFromIni(FName: string; Section: string; smFont: TFont);

implementation

function FontStyletoStr(St: TFontStyles): string;
var
  S: string;
begin
  S := '';
  if St = [fsbold] then S := 'Bold'
  else if St = [fsItalic] then S := 'Italic'
  else if St = [fsStrikeOut] then S := 'StrikeOut'
  else if St = [fsUnderline] then S := 'UnderLine'

  else if St = [fsbold, fsItalic] then S := 'BoldItalic'
  else if St = [fsBold, fsStrikeOut] then S := 'BoldStrike'
  else if St = [fsBold, fsUnderline] then S := 'BoldUnderLine'
  else if St = [fsBold..fsStrikeOut] then S := 'BoldItalicStrike'
  else if St = [fsBold..fsUnderLine] then S := 'BoldItalicUnderLine'
  else if St = [fsbold..fsItalic, fsStrikeOut] then S := 'BoldItalicStrike'
  else if St = [fsBold, fsUnderline..fsStrikeOut] then S := 'BoldStrikeUnderLine'

  else if St = [fsItalic, fsStrikeOut] then S := 'ItalicStrike'
  else if St = [fsItalic..fsUnderline] then S := 'ItalicUnderLine'
  else if St = [fsUnderLine..fsStrikeOut] then S := 'UnderLineStrike'
  else if St = [fsItalic..fsStrikeOut] then S := 'ItalicUnderLineStrike';
  FontStyletoStr := S;
end;
(*----------------------------------------------------*)

function StrtoFontStyle(St: string): TFontStyles;
var
  S: TfontStyles;
begin
  S  := [];
  St := UpperCase(St);
  if St = 'BOLD' then S := [fsBold]
  else if St = 'ITALIC' then S := [fsItalic]
  else if St = 'STRIKEOUT' then S := [fsStrikeOut]
  else if St = 'UNDERLINE' then S := [fsUnderLine]

  else if St = 'BOLDITALIC' then S := [fsbold, fsItalic]
  else if St = 'BOLDSTRIKE' then S := [fsBold, fsStrikeOut]
  else if St = 'BOLDUNDERLINE' then S := [fsBold, fsUnderLine]
  else if St = 'BOLDITALICSTRIKE' then S := [fsBold..fsStrikeOut]
  else if St = 'BOLDITALICUNDERLINE' then S := [fsBold..fsUnderLine]
  else if St = 'BOLDITALICSTRIKE' then S := [fsbold..fsItalic, fsStrikeOut]
  else if St = 'BOLDSTRIKEUNDERLINE' then S := [fsBold, fsUnderline..fsStrikeOut]

  else if St = 'ITALICSTRIKE' then S := [fsItalic, fsStrikeOut]
  else if St = 'ITALICUNDERLINE' then S := [fsItalic..fsUnderline]
  else if St = 'UNDERLINESTRIKE' then S := [fsUnderLine..fsStrikeOut]
  else if St = 'ITALICUNDERLINESTRIKE' then S := [fsItalic..fsStrikeOut];

  StrtoFontStyle := S;
end;
(*----------------------------------------------------*)
//Example for Write Font

function SetFont2Json(AFont: TFont): string;
var
  LSO: ISuperObject;
begin
  LSO := SO;

  with AFont do
  begin
    LSO.S['FontName'] := Name;
    LSO.I['FontSize'] := Size;
    LSO.I['FontColor']:= Color;
    LSO.S['FontStyle']:= FontStyletoStr(Style);;
  end;

  Result := LSO.AsJson;
end;
(*----------------------------------------------------*)
//Example for Read Font

procedure LoadFontFromJson(AFontJson: string; AFont: TFont);
var
  LSO: ISuperObject;
  LStyle: string;
begin
  if AFontJson = '' then
    exit;

  LSO := TSuperObject.Create(AFontJson);

  with AFont do
  begin
    Name  := LSO.S['FontName'];
    Size  := LSO.I['FontSize'];
    Color := LSO.I['FontColor'];
    LStyle := LSO.S['FontStyle'];

    if LStyle <> '' then Style := StrtoFontStyle(LStyle);
  end;
end;
(*----------------------------------------------------*)

procedure SaveFont2Ini(FName: string; Section: string; smFont: TFont);
var
  FStream: TIniFile;
begin
  FStream := TIniFile.Create(FName);
  try
    FStream.WriteString(Section, 'Name', smFont.Name);
    FStream.WriteInteger(Section, 'CharSet', smFont.CharSet);
    FStream.WriteInteger(Section, 'Color', smFont.Color);
    FStream.WriteInteger(Section, 'Size', smFont.Size);
    FStream.WriteInteger(Section, 'Style', Byte(smFont.Style));
  finally
    FStream.Free;
  end;
end;

procedure LoadFontFromIni(FName: string; Section: string; smFont: TFont);
var
  FStream: TIniFile;
begin
  FStream := TIniFile.Create(Fname);
  try
    smFont.Name    := FStream.ReadString(Section, 'Name', smFont.Name);
    smFont.CharSet := TFontCharSet(FStream.ReadInteger(Section, 'CharSet', smFont.CharSet));
    smFont.Color   := TColor(FStream.ReadInteger(Section, 'Color', smFont.Color));
    smFont.Size    := FStream.ReadInteger(Section, 'Size', smFont.Size);
    smFont.Style   := TFontStyles(Byte(FStream.ReadInteger(Section, 'Style', Byte(smFont.Style))));
  finally
    FStream.Free;
  end;
end;

end.
