unit UnitSQLUtil;

interface

function GetSQLWhereConditionByFieldName(const AFieldName: string): string;

implementation

function GetSQLWhereConditionByFieldName(const AFieldName: string): string;
begin
  if Pos('%', AFieldName) > 0 then
    Result := ' LIKE "' + AFieldName + '"' //"%' + ATagName + '%"
  else
    Result := ' = "' + AFieldName + '"';
end;

end.
