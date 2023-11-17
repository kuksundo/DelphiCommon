unit IntfJHPDB;

interface

type
  TJHDBKind = (jhdbkNull,jhdbkOracle, jhdbkDB2, jhdbkMSSQL, jhdbkPostgreSQL, jhdbkSqlite,
    jhdbkMSAccess, jhdbk, jhdbkFinal);

  IJHMetaDataBase = interface ['{1D9F32FE-4CCB-4CEB-93B2-F558C105CA41}']
    function GetDBFileName: string;
    function GetActive: Boolean;
    function GetDBKind: TJHDBKind;
    function GetHostName: string;
    function GetHostIPAddress: string;
    function GetPortNo: string;
    function GetUserName(const AUserId: integer): string;
    function GetUserPasswd(const AUserName: string): string;
    function GetAdminName: string;
    function GetAdminPasswd: string;
    function GetConnectionString: string;
    function GetMinConnections: integer;
    function GetMaxConnections: integer;

    property DBFileName: string read GetDBFileName;
    property Active: Boolean read GetActive;
    property DBKind: TJHDBKind read GetDBKind;
    property HostName: string read GetHostName;
    property HostIPAddress: string read GetHostIPAddress;
    property PortNo: string read GetPortNo;
    property UserName: string read GetUserName;
    property UserPasswd: string read GetUserPasswd;
    property AdminName: string read GetAdminName;
    property AdminPasswd: string read GetAdminPasswd;
    property ConnectionString: string read GetConnectionString;
    property MinConnections: integer read GetMinConnections;
    property MaxConnections: integer read GetMaxConnections;
  end;

  IJHDBProvider = interface ['{8CA77DC2-4EB7-47ED-A177-2FC8A0C19B15}']
    procedure CreateDB();
    procedure OpenDB();
    procedure CloseDB();
    procedure ClearDB();
    procedure SetTable(ATable: TObject);
    procedure SetPriorRecord;
    procedure SetNextRecord;
    function GetRowCount: integer;
    function GetColCount: integer;
    //Delete ANumOfRow rows from the table starting at AStartOfRow, return Number of deleted rows
    function DeleteRows(AStartOfRow: integer; ANumOfRow: integer): integer;
    //Insert ANumOfRow rows begining at AStartOfRow, return Number of inserted rows
    function InsertRows(AStartOfRow: integer; ANumOfRow: integer): integer;
    procedure Append();
    procedure First();
    procedure Last();
    procedure Next();

    function GetIsBOF: Boolean;
    function GetIsEOF: Boolean;

    property IsBOF: Boolean read GetIsBOF;
    property IsEOF: Boolean read GetIsEOF;
  end;

  IJHDBQueryResult = interface ['{310FE763-E963-4484-88DF-4DDCAF538DDC}']
    function GetRecordCount: integer;
//    function GetDataSet: TQuery;
  end;

  IJHDBPlugInHost = interface ['{CBC90B59-D59B-4B99-B26A-BC09911A840C}']
    function RunSql(const ASQL: string): IJHDBQueryResult;
  end;

  TJHDataBase = class(TInterfacedObject, IJHMetaDataBase, IJHDataBase)
  private
    //IJHMetaDataBase
    FDBFileName: string;
    FActive: Boolean;
    FDBKind: TJHDBKind;
    FHostName: string;
    FHostIPAddress: string;
    FPortNo: string;
    FUserName: string;
    FUserPasswd: string;
    FAdminName: string;
    FAdminPasswd: string;
    FConnectionString: string;
    FMinConnections: integer;
    FMaxConnections: integer;


    //IJHDataBase
    FIsBOF: Boolean;
    FIsEOF: Boolean;
  protected
    //IJHMetaDataBase
    function GetDBFileName: string;
    function GetActive: Boolean;
    function GetDBKind: TJHDBKind;
    function GetHostName: string;
    function GetHostIPAddress: string;
    function GetPortNo: string;
    function GetUserName(const AUserId: integer): string;
    function GetUserPasswd(const AUserName: string): string;
    function GetAdminName: string;
    function GetAdminPasswd: string;
    function GetConnectionString: string;
    function GetMinConnections: integer;
    function GetMaxConnections: integer;

    //IJHDataBase
    procedure SetTable(ATable: TObject);
    procedure SetPriorRecord;
    procedure SetNextRecord;
    function GetIsBOF: Boolean;
    function GetIsEOF: Boolean;
  published
    //IJHMetaDataBase
    property DBFileName: string read GetDBFileName;
    property Active: Boolean read GetActive;
    property DBKind: TJHDBKind read GetDBKind;
    property HostName: string read GetHostName;
    property HostIPAddress: string read GetHostIPAddress;
    property PortNo: string read GetPortNo;
    property UserName: string read GetUserName;
    property UserPasswd: string read GetUserPasswd;
    property AdminName: string read GetAdminName;
    property AdminPasswd: string read GetAdminPasswd;
    property ConnectionString: string read GetConnectionString;
    property MinConnections: integer read GetMinConnections;
    property MaxConnections: integer read GetMaxConnections;

    //IJHDataBase
    property IsBOF: Boolean read GetIsBOF;
    property IsEOF: Boolean read GetIsEOF;
  end;

implementation

end.
