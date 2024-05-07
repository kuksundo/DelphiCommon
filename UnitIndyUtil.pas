unit UnitIndyUtil;

interface

uses System.Classes, System.SysUtils, IdIOHandler
  ;
procedure CopyInputBuffer(Comment: string; Source, Dest: TIdIOHandler);

implementation

procedure CopyInputBuffer(Comment: string; Source, Dest: TIdIOHandler);
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    Source.InputBufferToStream(Stream);
    Stream.Position := 0;
    Dest.Write(Stream, Stream.Size);
//    Log(Comment + ' ' + IntToStr(Stream.Size) + ' bytes');
  finally
    FreeAndNil(Stream);
  end;
end;

end.
