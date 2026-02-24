unit UnitOutlookUtil2;

interface

uses System.SysUtils;

Type
  TJHEmailUtil = class
    //AOLFolderFullPath: '\\aaa@hd.com\f1\f2\f3'
    //ANthLevel: 2 => Result = '\\aaa@hd.com\f1\f2\'
    //           3 => Result = '\\aaa@hd.com\f1\f2\f3\'
    class function GetFolderNameOfNthLevel(AOLFolderFullPath: string; ANthLevel: integer): string; static;
    //메일 본문을 문자열로 입력받아, 가장 최근에 수신된 메일의 내용만 반환하는 함수
    class function ExtractLatestMailContent(const FullBody: string): string; static;
  end;

implementation

uses UnitStringUtil;

{ TJHEmailUtil }

class function TJHEmailUtil.ExtractLatestMailContent(
  const FullBody: string): string;
const
  // Outlook 메일에서 이전 메일이 시작될 때 자주 나오는 패턴들
  ThreadMarkers: array[0..6] of string = (
    '-----Original Message-----',
    'From:',
    'Sent:',
    'To:',
    'Subject:',
    '보낸 사람:',
    '날짜:'
  );
var
  MarkerPos, MinPos, I: Integer;
begin
  MinPos := Length(FullBody) + 1;

  // 가장 먼저 등장하는 마커 위치 찾기
  for I := Low(ThreadMarkers) to High(ThreadMarkers) do
  begin
    MarkerPos := Pos(ThreadMarkers[I], FullBody);
    if (MarkerPos > 0) and (MarkerPos < MinPos) then
      MinPos := MarkerPos;
  end;

  // 이전 메일이 있다면 그 전까지만 추출
  if MinPos <= Length(FullBody) then
    Result := Copy(FullBody, 1, MinPos - 1)
  else
    Result := FullBody;

  // 앞뒤 공백 및 불필요한 줄 정리
  Result := Trim(Result);
end;

class function TJHEmailUtil.GetFolderNameOfNthLevel(AOLFolderFullPath: string;
  ANthLevel: integer): string;
var
  LStr: string;
  i: integer;
begin
  for i := 0 to ANthLevel do
  begin
    if i = 0 then
    begin
      LStr := StrToken(AOLFolderFullPath, '\');
      LStr := StrToken(AOLFolderFullPath, '\');
      LStr := StrToken(AOLFolderFullPath, '\');//메일주소
      Result := '\\' + LStr;
    end;

    LStr := StrToken(AOLFolderFullPath, '\');

    if LStr <> '' then
      Result := Result + '\' + LStr;
  end;
end;

end.
