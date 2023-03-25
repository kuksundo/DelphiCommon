unit JHP.BaseCommandLineOption;

interface
{GpCommandLine은 상속이 안되므로 복사하여 사용할 것}
uses classes, SysUtils, GpCommandLineParser, Generics.Legacy;

type
{ /DelRegistry /rip:"10.1.1.1" /SkipReg /DecKind=123 /Masterpw:"xxxx"}
{Masterpw 는 Reg Server의 RegcodeEdit 화면에서 MasterPasswd Label을 우클릭하여 Popup에서 클리보드 복사하여 얻음}
  TJHPBaseCommandLineOption = class
    FRCSIPAddress, //Reg Code Server IP Address
    FRCSPort, //Reg Code Server Port No
    FMasterPwd //Master Pwd ()
    : string;

    FSkipRegCheck, //Reg check skip을 위해서는 Master Passwd를 전달해 주어야 함
    FDeleteRegInfo
    : Boolean;

    FDecryptKind4SkipRegCheck //Skip Reg Check 시 암호를 Decrypt하는 방법 선택
    : integer;
  public
//    class function CommandLineParse(var AWatchCLO: TWatchCommandLineOption;
//      var AErrMsg: string): boolean;

    [CLPLongName('rip'), CLPDescription('/rip:"xx.xx.xx.xx"'), CLPDefault('127.0.0.1')]
    property RCSIPAddress: string read FRCSIPAddress write FRCSIPAddress;
    [CLPLongName('rport'), CLPDescription('Reg Code Server Port No'), CLPDefault('')]
    property RCSPort: string read FRCSPort write FRCSPort;
    [CLPLongName('Masterpw'), CLPDescription('Master Pwd'), CLPDefault('')]
    property MasterPwd: string read FMasterPwd write FMasterPwd;
    [CLPLongName('DelRegistry'), CLPDescription('Delete Reginfo from registry')]
    property DeleteRegInfo: boolean read FDeleteRegInfo write FDeleteRegInfo;
    [CLPLongName('SkipReg'), CLPDescription('Skip Reginfo check')]
    property SkipRegCheck: Boolean read FSkipRegCheck write FSkipRegCheck;
    [CLPName('DecKind'), CLPDescription('Decrypt Method for master passwd of Skip Reg Check'), CLPDefault('0')]
    property DecryptKind4SkipRegCheck: integer read FDecryptKind4SkipRegCheck write FDecryptKind4SkipRegCheck;
  end;

implementation

end.
