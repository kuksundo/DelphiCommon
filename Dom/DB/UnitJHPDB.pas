unit UnitJHPDB;

interface

uses mormot.db.core, UnitEnumHelper;

type
  TJHDBKind = (jhdbkUnknown,
    jhdbkOracle,
    jhdbkMSSQL,
    jhdbkJet,
    jhdbkMySql,
    jhdbkSqlite,
    jhdbkFirebird,
    jhdbkNexusDB,
    jhdbkPostgreSQL,
    jhdbkDB2,
    jhdbkInformix,
    jhdbkMariaDB,
    jhdbkMSAccess,
    jhdbkFinal);

const
  R_JHDBKind : array[Low(TJHDBKind)..High(TJHDBKind)] of string =
    ('Unknown', 'Oracle', 'MSSQL', 'Jet', 'MySql','Sqlite','Firebird','NexusDB',
     'PostgreSQL', 'DB2', 'Informix', 'MariaDB', 'MSAccess', 'Unknown');

type
  IJHMetaDataBase = interface(IInvokable)
    ['{1D9F32FE-4CCB-4CEB-93B2-F558C105CA41}']
    function GetDBName: string;
    function GetDBFileName: string;
    function GetActive: Boolean;
    function GetDBKind: TJHDBKind;
    function GetHostName: string;
    function GetHostIPAddress: string;
    function GetPortNo: string;
    function GetUserName: string;
    function GetUserPasswd: string;
    function GetAdminName: string;
    function GetAdminPasswd: string;
    function GetConnectionString: string;
    function GetMinConnections: integer;
    function GetMaxConnections: integer;

    procedure SetDBName(const AName: string);
    procedure SetDBFileName(const AName: string);
    procedure SetActive(const AActive: Boolean);
    procedure SetDBKind(const ADBKind: TJHDBKind);
    procedure SetHostName(const AName: string);
    procedure SetHostIPAddress(const AIP: string);
    procedure SetPortNo(const APortNo: string);
    procedure SetUserName(const AUserId: string);
    procedure SetUserPasswd(const APasswd: string);
    procedure SetAdminName(const AName: string);
    procedure SetAdminPasswd(const APasswd: string);
    procedure SetConnectionString(const ACS: string);
    procedure SetMinConnections(const AMin: integer);
    procedure SetMaxConnections(const AMax: integer);

    property DataBaseName: string read GetDBName write SetDBName;
    property DBFileName: string read GetDBFileName write SetDBFileName;
    property Active: Boolean read GetActive write SetActive;
    property DBKind: TJHDBKind read GetDBKind write SetDBKind;
    property HostName: string read GetHostName write SetHostName;
    property HostIPAddress: string read GetHostIPAddress write SetHostIPAddress;
    property PortNo: string read GetPortNo write SetPortNo;
    property UserName: string read GetUserName write SetUserName;
    property UserPasswd: string read GetUserPasswd write SetUserPasswd;
    property AdminName: string read GetAdminName write SetAdminName;
    property AdminPasswd: string read GetAdminPasswd write SetAdminPasswd;
    property ConnectionString: string read GetConnectionString write SetConnectionString;
    property MinConnections: integer read GetMinConnections write SetMinConnections;
    property MaxConnections: integer read GetMaxConnections write SetMaxConnections;
  end;

  IJHDataBase = interface(IInvokable)
    ['{8CA77DC2-4EB7-47ED-A177-2FC8A0C19B15}']
    procedure SetTable(ATable: TObject);
    procedure SetPriorRecord;
    procedure SetNextRecord;
    function GetIsBOF: Boolean;
    function GetIsEOF: Boolean;

    property IsBOF: Boolean read GetIsBOF;
    property IsEOF: Boolean read GetIsEOF;
  end;

  IJHDBQueryResult = interface(IInvokable)
    ['{310FE763-E963-4484-88DF-4DDCAF538DDC}']
    function GetRecordCount: integer;
//    function GetDataSet: TQuery;
  end;

  IJHDBPlugInHost = interface(IInvokable)
  ['{CBC90B59-D59B-4B99-B26A-BC09911A840C}']
    function RunSql(const ASQL: string): IJHDBQueryResult;
  end;

  TJHDataBase = class(TInterfacedObject, IJHMetaDataBase, IJHDataBase)
  private
    FHostIp, FPort, FDBName, FUserId, FPasswd: string;
    FDBFileName, FHostName, FAdminName, FAdminPasswd: string;
    FConnectionString: string;
    FMinConnections, FMaxConnections: integer;
    FJHDBKind: TJHDBKind;

  protected
    //IJHMetaDataBase
    function GetDBName: string;
    function GetDBFileName: string;
    function GetActive: Boolean;
    function GetDBKind: TJHDBKind;
    function GetHostName: string;
    function GetHostIPAddress: string;
    function GetPortNo: string;
    function GetUserName: string;
    function GetUserPasswd: string;
    function GetAdminName: string;
    function GetAdminPasswd: string;
    function GetConnectionString: string;
    function GetMinConnections: integer;
    function GetMaxConnections: integer;

    procedure SetDBName(const AName: string);
    procedure SetDBFileName(const AName: string);
    procedure SetActive(const AActive: Boolean);
    procedure SetDBKind(const ADBKind: TJHDBKind);
    procedure SetHostName(const AName: string);
    procedure SetHostIPAddress(const AIP: string);
    procedure SetPortNo(const APortNo: string);
    procedure SetUserName(const AUserId: string);
    procedure SetUserPasswd(const APasswd: string);
    procedure SetAdminName(const AName: string);
    procedure SetAdminPasswd(const APasswd: string);
    procedure SetConnectionString(const ACS: string);
    procedure SetMinConnections(const AMin: integer);
    procedure SetMaxConnections(const AMax: integer);

    //IJHDataBase
    procedure SetTable(ATable: TObject);
    procedure SetPriorRecord;
    procedure SetNextRecord;
    function GetIsBOF: Boolean;
    function GetIsEOF: Boolean;
  public
    constructor Create(const AJHDBKind: TJHDBKind;
      const ADBSvrIP, ADBPort, ADBName, AUserId, APasswd: string); virtual;
    destructor Destroy; override;

    function GetMormotDBDefFromJHDBDef(const AJHDB: TJHDBKind): TSqlDBDefinition;

    property DataBaseName: string read GetDBName write SetDBName;
    property DBFileName: string read GetDBFileName write SetDBFileName;
    property Active: Boolean read GetActive write SetActive;
    property DBKind: TJHDBKind read GetDBKind write SetDBKind;
    property HostName: string read GetHostName write SetHostName;
    property HostIPAddress: string read GetHostIPAddress write SetHostIPAddress;
    property PortNo: string read GetPortNo write SetPortNo;
    property UserName: string read GetUserName write SetUserName;
    property UserPasswd: string read GetUserPasswd write SetUserPasswd;
    property AdminName: string read GetAdminName write SetAdminName;
    property AdminPasswd: string read GetAdminPasswd write SetAdminPasswd;
    property ConnectionString: string read GetConnectionString write SetConnectionString;
    property MinConnections: integer read GetMinConnections write SetMinConnections;
    property MaxConnections: integer read GetMaxConnections write SetMaxConnections;

    property IsBOF: Boolean read GetIsBOF;
    property IsEOF: Boolean read GetIsEOF;
  end;

var
  g_JHDBKind: TLabelledEnum<TJHDBKind>;

implementation

{ TJHDataBase }

constructor TJHDataBase.Create(const AJHDBKind: TJHDBKind; const ADBSvrIP,
  ADBPort, ADBName, AUserId, APasswd: string);
begin

end;

destructor TJHDataBase.Destroy;
begin

  inherited;
end;

function TJHDataBase.GetActive: Boolean;
begin

end;

function TJHDataBase.GetAdminName: string;
begin
  Result := FAdminName;
end;

function TJHDataBase.GetAdminPasswd: string;
begin
  Result := FAdminPasswd;
end;

function TJHDataBase.GetConnectionString: string;
begin
  Result := FConnectionString;
end;

function TJHDataBase.GetDBFileName: string;
begin
  Result := FDBFileName;
end;

function TJHDataBase.GetDBKind: TJHDBKind;
begin
  Result := FJHDBKind;
end;

function TJHDataBase.GetDBName: string;
begin
  Result := FDBName;
end;

function TJHDataBase.GetHostIPAddress: string;
begin
  Result := FHostIp;
end;

function TJHDataBase.GetHostName: string;
begin
  Result := FHostName;
end;

function TJHDataBase.GetIsBOF: Boolean;
begin

end;

function TJHDataBase.GetIsEOF: Boolean;
begin

end;

function TJHDataBase.GetMaxConnections: integer;
begin
  Result := FMaxConnections;
end;

function TJHDataBase.GetMinConnections: integer;
begin
  Result := FMinConnections;
end;

function TJHDataBase.GetMormotDBDefFromJHDBDef(
  const AJHDB: TJHDBKind): TSqlDBDefinition;
begin
  Result := dUnknown;

  case AJHDB of
    jhdbkOracle: Result := dOracle;
    jhdbkMSSQL: Result := dMSSQL;
    jhdbkJet: Result := dJet;
    jhdbkMySql: Result := dMySQL;
    jhdbkSqlite: Result := dSQLite;
    jhdbkFirebird: Result := dFirebird;
    jhdbkNexusDB: Result := dNexusDB;
    jhdbkPostgreSQL: Result := dPostgreSQL;
    jhdbkDB2: Result := dDB2;
    jhdbkInformix: Result := dInformix;
    jhdbkMariaDB: Result := dMariaDB;
    jhdbkMSAccess: Result := dUnknown;
  end;
end;

function TJHDataBase.GetPortNo: string;
begin
  Result := FPort;
end;

function TJHDataBase.GetUserName: string;
begin
  Result := FUserId;
end;

function TJHDataBase.GetUserPasswd: string;
begin
  Result := FPasswd;
end;

procedure TJHDataBase.SetActive(const AActive: Boolean);
begin

end;

procedure TJHDataBase.SetAdminName(const AName: string);
begin
  if FAdminName <> AName then
    FAdminName := AName;
end;

procedure TJHDataBase.SetAdminPasswd(const APasswd: string);
begin
  if FPasswd <> APasswd then
    FPasswd := APasswd;
end;

procedure TJHDataBase.SetConnectionString(const ACS: string);
begin
  if FConnectionString <> ACS then
    FConnectionString := ACS;
end;

procedure TJHDataBase.SetDBFileName(const AName: string);
begin
  if FDBFileName <> AName then
    FDBFileName := AName;
end;

procedure TJHDataBase.SetDBKind(const ADBKind: TJHDBKind);
begin
  if FJHDBKind <> ADBKind then
    FJHDBKind := ADBKind;
end;

procedure TJHDataBase.SetDBName(const AName: string);
begin
  if FDBName <> AName then
    FDBName := AName;
end;

procedure TJHDataBase.SetHostIPAddress(const AIP: string);
begin
  if FHostIp <> AIP then
    FHostIp := AIP;
end;

procedure TJHDataBase.SetHostName(const AName: string);
begin
  if FHostName <> AName then
    FHostName := AName;
end;

procedure TJHDataBase.SetMaxConnections(const AMax: integer);
begin
  if FMaxConnections <> AMax then
    FMaxConnections := AMax;
end;

procedure TJHDataBase.SetMinConnections(const AMin: integer);
begin
  if FMinConnections <> AMin then
    FMinConnections := AMin;
end;

procedure TJHDataBase.SetNextRecord;
begin

end;

procedure TJHDataBase.SetPortNo(const APortNo: string);
begin
  if FPort <> APortNo then
    FPort := APortNo;
end;

procedure TJHDataBase.SetPriorRecord;
begin

end;

procedure TJHDataBase.SetTable(ATable: TObject);
begin

end;

procedure TJHDataBase.SetUserName(const AUserId: string);
begin
  if FUserId <> AUserId then
    FUserId := AUserId;
end;

procedure TJHDataBase.SetUserPasswd(const APasswd: string);
begin
  if FPasswd <> APasswd then
    FPasswd := APasswd;
end;

initialization
  g_JHDBKind.InitArrayRecord(R_JHDBKind);

end.
