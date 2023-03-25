unit UnitMustacheUtil2;

interface

uses System.Classes, Dialogs, System.Rtti,
  mormot.core.base, mormot.core.os, mormot.core.buffers, mormot.core.text,
  mormot.core.mustache;

function GetMustacheJSONFromFile(ADoc: variant; AMustacheFile: string): string;
function GetMustacheJSONFromStr(ADoc: variant; AMustacheStr: string): string;

implementation

function GetMustacheJSONFromFile(ADoc: variant;
  AMustacheFile: string): string;
var
  LJSON: RawUTF8;
  LMustache: TSynMustache;
  LFile: RawByteString;
begin
  LJSON := Utf8ToString(VariantSaveJson(ADoc));
  LFile := StringFromFile(AMustacheFile);
  LMustache := TSynMustache.Parse(LFile);
  Result := Utf8ToString(BinToBase64(LMustache.RenderJSON(LJSON)));
//  Result := Utf8ToString(LMustache.RenderJSON(LJSON));
end;

function GetMustacheJSONFromStr(ADoc: variant; AMustacheStr: string): string;
var
  LJSON: RawUTF8;
  LMustache: TSynMustache;
//  LStr: RawUTF8;
begin
  LJSON := Utf8ToString(VariantSaveJson(ADoc));
  LMustache := TSynMustache.Parse(AMustacheStr);
  Result := LMustache.RenderJSON(LJSON);
end;

end.
