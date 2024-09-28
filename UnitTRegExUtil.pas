unit UnitTRegExUtil;

interface

uses Classes, RegularExpressions;

const
  REGEX_HANGLE = '.*[¤¡-¤¾|¤¿-¤Ó|°¡-ÆR]+.*';

function ExtractTextBetweenTags(const htmlContent: string): TStringList;
function CheckIfExistHangulUsingRegEx(const AText: string): Boolean;

implementation

function ExtractTextBetweenTags(const htmlContent: string): TStringList;
var
  regex: TRegEx;
  match: TMatch;
  matches: TMatchCollection;
  i: Integer;
begin
  Result := TStringList.Create;
  try
    regex := TRegEx.Create('<[^>]*>(.*?)(?=<|$)', [roMultiLine, roIgnoreCase]);
    matches := regex.Matches(htmlContent);
    for i := 0 to matches.Count - 1 do
    begin
      match := matches.Item[i];
      Result.Add(match.Groups[1].Value); // Add captured text (without tags) to the result list
    end;
  except
    Result.Free;
    raise;
  end;
end;

function CheckIfExistHangulUsingRegEx(const AText: string): Boolean;
begin
  Result := TRegEx.IsMatch(AText, REGEX_HANGLE);
end;

end.
