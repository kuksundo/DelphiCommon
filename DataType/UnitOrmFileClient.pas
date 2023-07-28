unit UnitOrmFileClient;

interface

{$I mormot.defines.inc}
uses
  SysUtils,
  mormot.rest.sqlite3, mormot.orm.core, mormot.core.os,
  UnitJHPFileRecord;

type
  TFileDBClient = class
  public
    Client: TRestClientDB;
    Model: TOrmModel;

    procedure InitDB(ADBName: string);
    procedure FinalizeDB;
  end;



implementation

{ TFileDBClient }

procedure TFileDBClient.FinalizeDB;
begin
  if Assigned(Client) then
    Client.Free;

  if Assigned(Model) then
    Model.Free;
end;

procedure TFileDBClient.InitDB(ADBName: string);
begin
  Model := CreateJHPFilesModel;
  Client := TRestClientDB.Create(Model, nil, ADBName, TRestServerDB, false, '');
  Client.Server.Server.CreateMissingTables;
end;

end.
