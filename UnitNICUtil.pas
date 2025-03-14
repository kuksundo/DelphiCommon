unit UnitNICUtil;

interface

uses classes,
  ActiveX, ComObj, Variants, SysUtils, Windows, Registry, shellapi, Rtti,
  System.Generics.Collections,
  mormot.core.base, mormot.core.os, mormot.core.text,
  mormot.core.collections, mormot.core.variants, mormot.core.json,
  mormot.core.unicode, WbemScripting_TLB
  ;

type
  TWin32_NetworkAdapterConfiguration = packed record
    MACAddress,
    IPAddressList
    : string;
    FIndex,
    InterfaceIndex
    : Word;
  end;

  TWin32_NetworkAdapter = packed record
  end;

  TMSFT_NetAdapter = packed record
  end;

  TMSFT_NetIPAddress = packed record
  end;

  TMSFT_NetAdapterAdvancedPropertySettingData = packed record
    InstanceID,
    Name,
    InterfcaeDescription,
    DisplayName,
    RegistryKeyword,
    RegistryValueList
    : string;
    RegistryDataType
    : Word;
  end;

  TNIC_Info_Rec = packed record
    W32_NAC: TWin32_NetworkAdapterConfiguration;
  end;

  TGPNIC_WMI = class
    //NIC Index List를 Result에 반환함 : index = IP Addr 형식(1 = 10.8.2.1)
    class function GetNICIndexList(AIpAddr: string=''; AComputerName:
      string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): TStringList;
    //NIC Name List를 Result에 반환함 : 연결이름 = IpAddr 형식(Etherneto=10.8.2.1)
    class function GetNICNameList(AIpAddr: string=''; AComputerName:
      string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): TStringList;
    class procedure EnableNIC_WMI(AIpAddr: string=''; AComputerName:
      string='localhost'; AWinUserID: string=''; AWinPasswd: string='');
    class procedure DisableNIC_WMI(AIpAddr: string=''; AComputerName:
      string='localhost'; AWinUserID: string=''; AWinPasswd: string='');
    class function GetNICAdvProp2JsonAryByDispName_WMI(APropDisplayName: string; AIpAddr: string=''; AComputerName:
      string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): string;
    //ANICName: "Ethernet0"
    //APropDisplayName: "Flow Control"
    //Result : {"Flow Control" : "Tx & Rx Enabled"}
    class function GetNICAdvProp2JsonByNICNameNDispName_WMI(const ANICName, APropDisplayName: string; AComputerName:
      string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): string;
    class function SetNICAdvPropValueByNICNameNDispName_WMI(const ANICName, APropDisplayName: string;
      ANewValue: variant; AComputerName: string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): Boolean;

    //Result: GUID
    class function GetNICInstanceIDByNICName_WMI(const ANICName: string;
      AComputerName: string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): string;


    class function IsIPv4(const IPAddress: string): Boolean;
    class function IsIPv6(const IPAddress: string): Boolean;
  end;

  TGPNIC_REG = class
    //AAdvPropNameList: Registry에서 가져올 Property Name List를 전달함
    class function GetNICAdvPropsJsonFromRegistryByIpAddr(const AIpAddr: string;
      AAdvPropNameList: TStringList; AComputerName: string='localhost';
      AWinUserID: string=''; AWinPasswd: string=''): RawUtf8;
    //AIdx: 0000 형식의 Reg Key 값
    //AAdvPropNameList: Registry에서 가져올 Property Name List를 전달함
    //1개의 NIC에 대한 Advanced Properties 값들을 json Array로 반환 함
    //Result = ["Flow Contro" : "Diabled",...]
    class function GetNICAdvPropsJsonFromRegistryByNICIdx(const AIdx: string;
      AAdvPropNameList: TStringList; AComputerName: string='localhost';
      AWinUserID: string=''; AWinPasswd: string=''): RawUtf8;
    //Result = ParamName=Param Desc : (*Flow Control = Flow Control)
    class function GetNICAdvPropertyListFromRegByIdx(const AIdx: string;
      AComputerName: string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): TStringList;
    class function GetNICAdvProperty2JsonFromRegByIpAddr(const AIpAddr: string;
      AComputerName: string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): string;
    class function SetNetworkAdapterRegistryKeyFromIpAddr(const AIpAddr: string;
      AComputerName: string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): integer;
    class function GetNICGUIDFromRegistryKeyByIpAddr(const AIpAddr: string;
      AComputerName: string='localhost'; AWinUserID: string=''; AWinPasswd: string=''): string;
  end;

{
 try
    CoInitialize(nil);
    try
      GetWmiPropsSources('root\cimv2', 'Win32_DiskDrive');
    finally
      CoUninitialize;
    end;
 except
    on E:EOleException do
        Writeln(Format('EOleException %s %x', [E.Message,E.ErrorCode]));
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 }
procedure GetWmiPropsSources(Const NameSpace, ClassName: string);

{
// Example command to set Flow Control for a network adapter named "Ethernet"
Set_NetAdapterAdvancedPropertyUsingPowerShell('Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Flow Control" -DisplayValue "Rx & Tx Enabled"');

Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Flow Control" -DisplayValue "Disabled"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Jumbo Packet" -DisplayValue "9014 Bytes"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Receive Buffers" -DisplayValue "512"
Get-NetAdapterAdvancedProperty -DisplayName "*Flow Control"
}
procedure Set_NetAdapterAdvancedPropertyUsingPowerShell(const ACommand: string);

//procedure QueryNetworkAdapterConfiguration;
//procedure QueryNetworkAdapterSettings;

implementation

uses UnitRegistryUtil, UnitWMIUtil, UnitJsonUtil, ArrayHelper, magsubs1,
  UnitStringUtil, UnitOLEVarUtil;

procedure GetWmiPropsSources(Const NameSpace, ClassName: string);
const
  wbemFlagUseAmendedQualifiers = $00020000;
Var
  Properties        : OleVariant;
  Qualifiers        : OleVariant;
  rgvarProp         : OleVariant;
  rgvarQualif       : OleVariant;
  objSWbemLocator   : OleVariant;
  objSWbemObjectSet : OleVariant;
  objWMIService     : OleVariant;
  EnumProps         : IEnumVariant;
  EnumQualif        : IEnumVariant;
  pceltFetched      : Cardinal;
  Lindex            : Integer;
begin
    //create the WMI Scripting object
    objSWbemLocator  := CreateOleObject('WbemScripting.SWbemLocator');
    //connect to the WMi service on the local mahicne
    objWMIService    := objSWbemLocator.ConnectServer('localhost', NameSpace, '', '');
    //get the metadata of the WMI class
    objSWbemObjectSet:= objWMIService.Get(ClassName, wbemFlagUseAmendedQualifiers);
    //get a pointer to the properties
    Properties := objSWbemObjectSet.Properties_;
    //get an enumerator to the properties
    EnumProps         := IUnknown(Properties._NewEnum) as IEnumVariant;
    //iterate over the properties
    while EnumProps.Next(1, rgvarProp, pceltFetched) = 0 do
    begin
      //get a pointer to the qualifiers of the current property
      Qualifiers      := rgvarProp.Qualifiers_;
      //get an enumerator to the qualifiers
      EnumQualif     := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
      //iterate over the qualifiers
      while EnumQualif.Next(1, rgvarQualif, pceltFetched) = 0 do
      begin
        //check the name of the qualifier
        if SameText('MappingStrings',rgvarQualif.Name) then
        begin
           Writeln(rgvarProp.Name);
           //write the value of the qualifier
           if not VarIsNull(rgvarQualif.Value) and  VarIsArray(rgvarQualif.Value) then
            for Lindex := VarArrayLowBound(rgvarQualif.Value, 1) to VarArrayHighBound(rgvarQualif.Value, 1) do
              Writeln(Format('  %s',[String(rgvarQualif.Value[Lindex])]));
        end;
        rgvarQualif:=Unassigned;
      end;
      rgvarProp:=Unassigned;
    end;
end;

procedure Set_NetAdapterAdvancedPropertyUsingPowerShell(const ACommand: string);
var
  PowerShellCmd: string;
begin
  PowerShellCmd := 'powershell.exe -Command ' + ACommand;

  ShellExecute(0, 'open', 'powershell.exe', PChar('-Command ' + ACommand), nil, SW_HIDE);
end;

//procedure QueryNetworkAdapterConfiguration;
//var
//  WMIService: OLEVariant;
//  AdapterConfigSet: OLEVariant;
//  AdapterConfig: OLEVariant;
//  Enum: IEnumVariant;
//  Value: Cardinal;
//begin
//  try
//    // Initialize COM
//    CoInitialize(nil);
//
//    // Connect to WMI service
//    WMIService := CreateOleObject('WbemScripting.SWbemLocator').ConnectServer(
//      '.', 'root\CIMV2', '', '');
//
//    // Query network adapter configurations
//    AdapterConfigSet := WMIService.ExecQuery(
//      'SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True', 'WQL', 0);
//
//    Enum := IUnknown(AdapterConfigSet._NewEnum) as IEnumVariant;
//
//    // Loop through each network adapter configuration
//    while Enum.Next(1, AdapterConfig, Value) = 0 do
//    begin
//      // Print adapter information
//      Writeln('Description: ' + VarToStr(AdapterConfig.Description));
//      Writeln('MAC Address: ' + VarToStr(AdapterConfig.MACAddress));
//      Writeln('IP Address: ' + VarToStr(AdapterConfig.IPAddress[0]));
//      Writeln('IP Subnet: ' + VarToStr(AdapterConfig.IPSubnet[0]));
//      Writeln('Default Gateway: ' + VarToStr(AdapterConfig.DefaultIPGateway[0]));
//      Writeln('DHCP Enabled: ' + BoolToStr(AdapterConfig.DHCPEnabled, True));
//
//      Writeln('-------------------------------------');
//
//      // Clear the variant for next iteration
//      AdapterConfig := Unassigned;
//    end;
//
//  except
//    on E: Exception do
//      Writeln('Error: ' + E.Message);
//  end;
//
//  // Uninitialize COM
//  CoUninitialize;
//end;
//
//procedure QueryNetworkAdapterSettings;
//var
//  WMIService: OLEVariant;
//  AdapterSettingSet: OLEVariant;
//  AdapterSetting: OLEVariant;
//  Enum: IEnumVariant;
//  Value: Cardinal;
//  Adapter: OLEVariant;
//  AdapterConfig: OLEVariant;
//begin
//  try
//    // Initialize COM
//    CoInitialize(nil);
//
//    // Connect to WMI service
//    WMIService := CreateOleObject('WbemScripting.SWbemLocator').ConnectServer(
//      '.', 'root\CIMV2', '', '');
//
//    // Query the Win32_NetworkAdapterSetting association class
//    AdapterSettingSet := WMIService.ExecQuery(
//      'SELECT * FROM Win32_NetworkAdapterSetting', 'WQL', 0);
//
//    Enum := IUnknown(AdapterSettingSet._NewEnum) as IEnumVariant;
//
//    // Loop through each network adapter setting
//    while Enum.Next(1, AdapterSetting, Value) = 0 do
//    begin
//      // Get the associated NetworkAdapter and NetworkAdapterConfiguration
//      Adapter := AdapterSetting.Antecedent;   // Win32_NetworkAdapter
//      AdapterConfig := AdapterSetting.Dependent; // Win32_NetworkAdapterConfiguration
//
//      // Print network adapter information
//      Writeln('Adapter Name: ' + VarToStr(Adapter.Description));
//      Writeln('MAC Address: ' + VarToStr(Adapter.MACAddress));
//
//      // Check if IP configuration is available
//      if not VarIsNull(AdapterConfig.IPAddress) then
//      begin
//        Writeln('IP Address: ' + VarToStr(AdapterConfig.IPAddress[0]));
//        Writeln('Subnet Mask: ' + VarToStr(AdapterConfig.IPSubnet[0]));
//        Writeln('Default Gateway: ' + VarToStr(AdapterConfig.DefaultIPGateway[0]));
//        Writeln('DHCP Enabled: ' + BoolToStr(AdapterConfig.DHCPEnabled, True));
//      end
//      else
//      begin
//        Writeln('No IP configuration found.');
//      end;
//
//      Writeln('-------------------------------------');
//
//      // Clear the variant for the next iteration
//      AdapterSetting := Unassigned;
//    end;
//
//  except
//    on E: Exception do
//      Writeln('Error: ' + E.Message);
//  end;
//
//  // Uninitialize COM
//  CoUninitialize;
//end;

{ TGPNIC_WMI }

class procedure TGPNIC_WMI.DisableNIC_WMI(AIpAddr, AComputerName, AWinUserID,
  AWinPasswd: string);
var
  LSQL: string ;
  LEnum: IEnumVariant;
  LWbemObject: OleVariant;
  LValue: LongWord;
begin
  System.VarClear(LWbemObject);

  LSQL := 'SELECT * FROM Win32_NetworkAdapter Where NetEnabled=True';

  LEnum := TGPWMI.GetWMIObjectEnum(AComputerName, 'root\CIMV2',
    AWinUserID, AWinPasswd, LSQL);

  while LEnum.Next(1, LWbemObject, LValue) = S_OK do
  begin
    if AIpAddr <> '' then
    begin
      if AIpAddr = LWbemObject.IPAddress[0] then
      begin
        LWbemObject.Enable();
        Break;
      end;
    end
    else
      LWbemObject.Enable();

    System.VarClear(LWbemObject);
  end;//while
end;

class procedure TGPNIC_WMI.EnableNIC_WMI(AIpAddr, AComputerName, AWinUserID,
  AWinPasswd: string);
var
  LSQL: string ;
  LEnum: IEnumVariant;
  LWbemObject: OleVariant;
  LValue: LongWord;
begin
  System.VarClear(LWbemObject);

  LSQL := 'SELECT * FROM Win32_NetworkAdapter Where NetEnabled=False';

  LEnum := TGPWMI.GetWMIObjectEnum(AComputerName, 'root\CIMV2',
    AWinUserID, AWinPasswd, LSQL);

  while LEnum.Next(1, LWbemObject, LValue) = S_OK do
  begin
    if AIpAddr <> '' then
    begin
      if AIpAddr = LWbemObject.IPAddress[0] then
      begin
        LWbemObject.Enable();
        Break;
      end;
    end
    else
      LWbemObject.Enable();

    System.VarClear(LWbemObject);
  end;//while
end;

class function TGPNIC_WMI.GetNICAdvProp2JsonAryByDispName_WMI(APropDisplayName,
  AIpAddr, AComputerName, AWinUserID, AWinPasswd: string): string;
var
  LSQL: string ;
  LEnum: IEnumVariant;
  LWbemObject: OleVariant;
  LValue: LongWord;

  WmiResults: T2DimStrArray ;
  instances, rows: integer;
  errstr: string ;
begin
  Result := '';

  System.VarClear(LWbemObject);

  LSQL := 'SELECT * FROM MSFT_NetAdapterAdvancedPropertySettingData Where DisplayName="' + APropDisplayName+'"';//MSFT_NetAdapterAdvancedProperty

//  LEnum := TGPWMI.GetWMIObjectEnum(AComputerName, 'root\StandardCimv2',
//    AWinUserID, AWinPasswd, LSQL);

//  while LEnum.Next(1, LWbemObject, LValue) = S_OK do
//  begin
//    Result := LWbemObject.InterfaceDescription;// + ':' +
//    Result := VarToStr(LWbemObject.RegistryValue[0]);
//    System.VarClear(LWbemObject);
//  end;//while

  rows := TGPWMI.GetWMIInfo(AComputerName, 'root\StandardCimv2',
    AWinUserID, AWinPasswd, LSQL, WmiResults, instances, errstr);

  if rows > 0 then
  begin
    Result := GetJsonAryFromStrAry2D(TStrArray2D(WmiResults));
  end
  else
    Result := errstr;
end;

class function TGPNIC_WMI.GetNICAdvProp2JsonByNICNameNDispName_WMI(
  const ANICName, APropDisplayName: string; AComputerName,
  AWinUserID, AWinPasswd: string): string;
var
  LSQL, LValidValues, LRegValue: string ;
  WmiResults: T2DimStrArray ;
  instances, rows: integer;
  errstr: string ;
begin
  Result := '';

  LSQL := 'SELECT * FROM MSFT_NetAdapterAdvancedPropertySettingData Where Name="' + ANICName + '" and DisplayName="' + APropDisplayName+'"';

  rows := TGPWMI.GetWMIInfo(AComputerName, 'root\StandardCimv2',
    AWinUserID, AWinPasswd, LSQL, WmiResults, instances, errstr);

  if rows > 0 then
  begin
    LValidValues := TGPWMI.GetValueFrom2DStrArrayByFieldName(WmiResults, 'ValidDisplayValues');
    LRegValue := TGPWMI.GetValueFrom2DStrArrayByFieldName(WmiResults, 'RegistryValue');
    Result := TGPWMI.GetDispValueFromValidDisplayValuesByRegistryValue(LValidValues, LRegValue);
  end
  else
    Result := errstr;
end;

class function TGPNIC_WMI.GetNICIndexList(AIpAddr, AComputerName, AWinUserID, AWinPasswd: string): TStringList;
var
  LSQL: string ;
  LEnum: IEnumVariant;
  LWbemObject: OleVariant;
  LValue: LongWord;
begin
  Result := TStringList.Create;

  System.VarClear(LWbemObject);

  LSQL := 'SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled=True';

  LEnum := TGPWMI.GetWMIObjectEnum(AComputerName, 'root\CIMV2',
    AWinUserID, AWinPasswd, LSQL);

  while LEnum.Next(1, LWbemObject, LValue) = S_OK do
  begin
    if AIpAddr <> '' then
    begin
      if AIpAddr = LWbemObject.IPAddress[0] then
      begin
        Result.Add(IntToStr(LWbemObject.Index) + '=' + LWbemObject.IPAddress[0]);
        exit;
      end;
    end
    else
      Result.Add(IntToStr(LWbemObject.Index) + '=' + LWbemObject.IPAddress[0]);

    System.VarClear(LWbemObject);
  end;//while
end;

class function TGPNIC_WMI.GetNICInstanceIDByNICName_WMI(const ANICName: string;
  AComputerName, AWinUserID, AWinPasswd: string): string;
var
  LSQL: string;
  LEnum: IEnumVariant;
  LWbemObject: OleVariant;
  LValue: LongWord;
begin
  Result := '';
  System.VarClear(LWbemObject);

  LSQL := Format('SELECT InstanceID FROM MSFT_NetAdapter WHERE Name = "%s"', [ANICName]);
  LEnum := TGPWMI.GetWMIObjectEnum(AComputerName, 'root\StandardCimv2',
    AWinUserID, AWinPasswd, LSQL);

  while LEnum.Next(1, LWbemObject, LValue) = S_OK do
  begin
    Result := LWbemObject.InstanceID;
    System.VarClear(LWbemObject);
  end;//while
end;

class function TGPNIC_WMI.GetNICNameList(AIpAddr, AComputerName, AWinUserID,
  AWinPasswd: string): TStringList;
var
  LSQL, LName, LIPAddress: string;
  LIdx: string;
  LEnum: IEnumVariant;
  LWbemObject: OleVariant;
  LValue: LongWord;
  LStrList: TStringList;

//  WmiResults: T2DimStrArray ;
//  instances, rows: integer;
//  errstr: string ;
begin
  Result := TStringList.Create;
  LStrList := TStringList.Create;

//  LStrList := GetNICIndexList();
//
//  if LStrList.Count = 0 then
//  begin
//    LStrList.Free;
//    exit;
//  end;

  System.VarClear(LWbemObject);

  LSQL := 'SELECT * FROM MSFT_NetAdapter';
  LEnum := TGPWMI.GetWMIObjectEnum(AComputerName, 'root\StandardCimv2',
    AWinUserID, AWinPasswd, LSQL);

  while LEnum.Next(1, LWbemObject, LValue) = S_OK do
  begin
    LStrList.Add(IntToStr(LWbemObject.InterfaceIndex) + '=' + LWbemObject.Name);
    System.VarClear(LWbemObject);
  end;//while

  LSQL := 'SELECT * FROM MSFT_NetIPAddress';
  LEnum := TGPWMI.GetWMIObjectEnum(AComputerName, 'root\StandardCimv2',
    AWinUserID, AWinPasswd, LSQL);
  while LEnum.Next(1, LWbemObject, LValue) = S_OK do
  begin
    LIPAddress := LWbemObject.IPAddress;

    if IsIPv6(LIPAddress) then
      Continue;

    LIdx := IntToStr(LWbemObject.InterfaceIndex);
    LName := LStrList.Values[LIdx];

    if LName = '' then
      Continue;

    Result.Add(LName + '=' + LIPAddress);
    System.VarClear(LWbemObject);
  end;//while

  LStrList.Free;

//-------------------------------------------------------
//  LSQL := 'SELECT * FROM MSFT_NetAdapter';
//  rows := TGPWMI.GetWMIInfo(AComputerName, 'root\StandardCimV2',
//    AWinUserID, AWinPasswd, LSQL, WmiResults, instances, errstr);
//
//  if rows > 0 then
//  begin
//    Result.Text := GetJsonAryFromStrAry2D(TStrArray2D(WmiResults));
//  end;

//-----------------------------------------------------------
//  if rows > 0 then
//  begin
//    LValidValues := TGPWMI.GetValueFrom2DStrArrayByFieldName(WmiResults, 'ValidDisplayValues');
//    LRegValue := TGPWMI.GetValueFrom2DStrArrayByFieldName(WmiResults, 'RegistryValue');
//    Result := TGPWMI.GetDispValueFromValidDisplayValuesByRegistryValue(LValidValues, LRegValue);
//  end
//  else
//    Result := errstr;

end;

class function TGPNIC_WMI.IsIPv4(const IPAddress: string): Boolean;
var
  Parts: TArray<string>;
  Part: string;
  I, Num: Integer;
begin
  Result := False;

  // IPv4 주소는 '.'로 구분된 4개의 부분으로 구성됨
  Parts := IPAddress.Split(['.']);
  if Length(Parts) <> 4 then
    Exit(False);

  for Part in Parts do
  begin
    // 각 부분이 숫자인지 확인
    if not TryStrToInt(Part, Num) then
      Exit(False);

    // 각 부분이 0에서 255 사이인지 확인
    if (Num < 0) or (Num > 255) then
      Exit(False);
  end;

  Result := True;
end;

class function TGPNIC_WMI.IsIPv6(const IPAddress: string): Boolean;
var
  Parts: TArray<string>;
  Part: string;
  I, Num: Integer;
begin
  Result := False;

  Part := IPAddress;
  Part := StrToken(Part, '%');

  // IPv6 주소는 ':'로 구분된 8개의 부분으로 구성됨 (축약된 형식 제외)
  Parts := Part.Split([':']);

  if (Length(Parts) < 3) or (Length(Parts) > 8) then
    Exit(False);

  for Part in Parts do
  begin
    // 각 부분이 16진수인지 확인
    if Part = '' then
      Continue; // 축약된 형식(예: "::") 허용

    if not TryStrToInt('$' + Part, Num) then
      Exit(False);

    // 각 부분이 0에서 FFFF 사이인지 확인
    if (Num < 0) or (Num > $FFFF) then
      Exit(False);
  end;

  Result := True;
end;

class function TGPNIC_WMI.SetNICAdvPropValueByNICNameNDispName_WMI(
  const ANICName, APropDisplayName: string; ANewValue: variant; AComputerName,
  AWinUserID, AWinPasswd: string): Boolean;
var
  LInstanceID,
  LSQL: string;
  LEnum: IEnumVariant;
  LWbemObject: OleVariant;
  LValue: LongWord;

  LAry: array[0..1] of string;

//  WmiResults: T2DimStrArray ;
//  instances, rows: integer;
  errstr: string ;
begin
  Result := False;
  //Get the InstanceID of the network adapter
  LInstanceID := GetNICInstanceIDByNICName_WMI(ANICName, AComputerName, AWinUserID, AWinPasswd);

  if LInstanceID = '' then
    exit;

  System.VarClear(LWbemObject);
  //Find the property name is APropDisplayName("*FlowControl")
  LSQL := 'SELECT * FROM MSFT_NetAdapterAdvancedPropertySettingData ' +
    'WHERE InstanceID LIKE "' + LInstanceID + '%" AND RegistryKeyword = "' + APropDisplayName + '"';
  LEnum := TGPWMI.GetWMIObjectEnum(AComputerName, 'root\StandardCimv2',
    AWinUserID, AWinPasswd, LSQL);

  if LEnum.Next(1, LWbemObject, LValue) = S_OK then
  begin
    // Map the data type to a human-readable name
//    case LWbemObject.RegistryDataType of
//      1,//'REG_SZ (String)';
//      2: LWbemObject.RegistryValue := ANewValue.AsString;//'REG_EXPAND_SZ (Expandable String)';
//      3: ;//'REG_BINARY (Binary Data)';
//      4: LWbemObject.RegistryValue := ANewValue.AsInteger;//'REG_DWORD (32-bit Integer)';
//      5: ;//'REG_MULTI_SZ (Multi-String)';
//      6: LWbemObject.RegistryValue := ANewValue.AsInt64;//'REG_QWORD (64-bit Integer)';
//    else
//      ;//'Unknown';
//    end;

//    errstr := VariantDynArrayToJson(LWbemObject.RegistryValue);
//    LWbemObject.RegistryValue := CreateOLEVarFromVariant(ANewValue);
//    LWbemObject.Put_(0);   //wbemChangeFlagUpdateOnly
//    Result := True;
//    System.VarClear(LWbemObject);
  end;//while

//  LSQL := 'SELECT * FROM MSFT_NetAdapterAdvancedPropertySettingData ' +
//    'WHERE InstanceID like "' + LInstanceID + '%" and RegistryKeyword = "' + APropDisplayName + '"';
//  rows := TGPWMI.GetWMIInfo(AComputerName, 'root\StandardCimv2',
//    AWinUserID, AWinPasswd, LSQL, WmiResults, instances, errstr);

end;

{ TGPNIC_REG }

class function TGPNIC_REG.GetNICAdvProperty2JsonFromRegByIpAddr(
  const AIpAddr: string; AComputerName, AWinUserID, AWinPasswd: string): string;
var
  Reg, Reg2: TRegistry;
  SubKeys, LProps, LParams: TStringList;
  KeyPath, LKeyPath2, LStr: string;
  I, j, k: Integer;
  LNICClassID, LNetCfgInstanceId: string;
  LDict, LDict2: IDocDict;
  LList: IDocList;
begin
  Result := '';
  LList := DocList('[]');
  LDict := DocDict('{}');
  LDict2 := DocDict('{}');

  LNICClassID := GetNICGUIDFromRegistryKeyByIpAddr(AIpAddr);

  if LNICClassID <> '' then
  begin
    KeyPath := 'SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}';

    Reg := TRegistry.Create(KEY_READ);
    Reg2 := TRegistry.Create(KEY_READ);
    SubKeys := TStringList.Create;
    LProps := TStringList.Create;
    LParams := TStringList.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg2.RootKey := HKEY_LOCAL_MACHINE;

      if Reg.OpenKey(KeyPath, False) then
      begin
        Reg.GetKeyNames(SubKeys);
        Reg.CloseKey;

        //SubKeys = 0000/0001...
        for I := 0 to SubKeys.Count - 1 do
        begin
          LKeyPath2 := KeyPath + '\' + SubKeys.Strings[I];

          if Reg.OpenKey(LKeyPath2, False) then
          begin
            if Reg.ValueExists('NetCfgInstanceId') then
            begin
              LNetCfgInstanceId := Reg.ReadString('NetCfgInstanceId');

              if SameText(LNetCfgInstanceId, LNICClassID) then
              begin
                LProps.Clear;

                Reg.GetValueNames(LProps);

                //Adv Properties (*Flow Control ...)
                for j := 0 to LProps.Count - 1 do
                begin
                  LStr := LProps.Strings[j];

                  LDict.S['Name'] := LStr;
                  LDict.S['Value'] := Reg.GetDataAsString(LStr);

                  LKeyPath2 := KeyPath + '\' + SubKeys.Strings[I] + '\Ndi\Params\' + LStr;
                  LDict.S['Params'] := Reg.GetValues2Json(LKeyPath2);

                  LKeyPath2 := KeyPath + '\' + SubKeys.Strings[I] + '\Ndi\Params\' + LStr + '\Enum';
                  LDict.S['Enum'] := Reg.GetValues2Json(LKeyPath2);

                  LList.Append(LDict.Json);
                  LDict.Clear;
                end;//for j

                Result := Utf8ToString(LList.Json);
                Exit;
              end;
            end;

            Reg.CloseKey;
          end;
        end;//for i
      end;
    finally
      SubKeys.Free;
      LProps.Free;
      LParams.Free;
      Reg.Free;
      Reg2.Free;
    end;
  end;
end;

class function TGPNIC_REG.GetNICAdvPropertyListFromRegByIdx(const AIdx: string;
  AComputerName, AWinUserID, AWinPasswd: string): TStringList;
var
  Reg: TRegistry;
  KeyPath: string;
  LStrValue: string;
  i, LIntValue: integer;
  LRegDataType: TRegDataType;
begin
  Result := TStringList.Create;
  KeyPath := 'SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}';

  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyPath := KeyPath + '\' + AIdx + '\Ndi\Params';

    if Reg.OpenKey(KeyPath, False) then
    begin
      Reg.GetKeyNames(Result);
      Reg.CloseKey;

      for i := 0 to Result.Count - 1 do
      begin
        if Reg.OpenKey(KeyPath + '\' + Result.Strings[i], False) then
        begin
          if Reg.ValueExists('ParamDesc') then
          begin
            Result.Strings[i] := Result.Strings[i] + '=' + Reg.ReadString('ParamDesc');
          end;

          Reg.CloseKey;
        end;
      end;

      Reg.CloseKey;
    end;//if
  finally
    Reg.Free;
  end;
end;

class function TGPNIC_REG.GetNICAdvPropsJsonFromRegistryByIpAddr(
  const AIpAddr: string; AAdvPropNameList: TStringList;
    AComputerName, AWinUserID, AWinPasswd: string): RawUtf8;
var
  LStrList: TStringList;
  i: integer;
  LDict: IDocDict;
  LList, LList2: IDocList;
  LRegIndex, LAdvPropAry, LIpAddr: string;
begin
  LList := DocList('[]');
  LDict := DocDict('{}');

  //NIC Index List를 가져옴
  LStrList := TGPNIC_WMI.GetNICIndexList(AIpAddr, AComputerName, AWinUserID, AWinPasswd);

  //모든 NIC를 표시함
  if AIpAddr = '' then
  begin
    for i := 0 to LStrList.Count - 1 do
    begin
      LIpAddr := LStrList.Names[i];
      LRegIndex := Format('%.4s', [LStrList.ValueFromIndex[i]]);
      LAdvPropAry := GetNICAdvPropsJsonFromRegistryByNICIdx(LRegIndex, AAdvPropNameList);
      LList2 := DocList(LAdvPropAry);

      LDict.A[LIpAddr] := LList2;
      LList.Append(LDict);

      LDict.Clear;
    end;
  end
  else
  begin

  end;

  Result := LList.ToJson(jsonUnquotedPropNameCompact);
end;

class function TGPNIC_REG.GetNICAdvPropsJsonFromRegistryByNICIdx(
  const AIdx: string; AAdvPropNameList: TStringList; AComputerName, AWinUserID,
  AWinPasswd: string): RawUtf8;
var
  Reg: TRegistry;
  KeyPath: string;
  LPropName, LStrValue: string;
  i, LIntValue: integer;
  LRegDataType: TRegDataType;
begin
  Result := '';
  KeyPath := 'SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}';

  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(KeyPath, False) then
    begin
      if Reg.OpenKey(KeyPath + '\' + AIdx, False) then
      begin
        for i := 0 to AAdvPropNameList.Count - 1 do
        begin
          LPropName := AAdvPropNameList.Names[i];
//          if Reg.ValueExists('*FlowControl') then
          if Reg.ValueExists(LPropName) then
          begin
            LRegDataType := Reg.GetDataType(LPropName);

            case LRegDataType of
              rdUnknown, rdString, rdExpandString: LStrValue := Reg.ReadString(LPropName);
              rdInteger: Reg.ReadInteger(LPropName);
//              rdBinary: LIntValue := Reg.ReadBinaryData(LPropName);
            end;//case
          end;
        end;

        Reg.CloseKey;
      end;
    end;//if
  finally
//    SubKeys.Free;
    Reg.Free;
  end;
end;

class function TGPNIC_REG.GetNICGUIDFromRegistryKeyByIpAddr(
  const AIpAddr: string; AComputerName, AWinUserID, AWinPasswd: string): string;
var
  Reg: TRegistry;
  SubKeys: TStringList;
  LIpAddrValues: TStringList;
  KeyPath, LIpAddr: string;
  I, j: Integer;
begin
  Result := '';
  KeyPath := 'SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces';

  Reg := TRegistry.Create(KEY_READ);
  SubKeys := TStringList.Create;
  LIpAddrValues := TStringList.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    if Reg.OpenKey(KeyPath, False) then
    begin
      Reg.GetKeyNames(SubKeys);
      Reg.CloseKey;

      for I := 0 to SubKeys.Count - 1 do
      begin
        if Reg.OpenKey(KeyPath + '\' + SubKeys[I], False) then
        begin
          if Reg.ValueExists('IPAddress') then
          begin
            if Reg.ReadMultiSz('IPAddress', TStrings(LIpAddrValues)) then
            begin
              for j := 0 to LIpAddrValues.Count - 1 do

              if SameText(LIpAddrValues[j], AIpAddr) then
              begin
                Result := SubKeys[I];
                Exit;
              end;
            end;
          end;
          Reg.CloseKey;
        end;
      end;//for i
    end;
  finally
    SubKeys.Free;
    LIpAddrValues.Free;
    Reg.Free;
  end;
end;

class function TGPNIC_REG.SetNetworkAdapterRegistryKeyFromIpAddr(
  const AIpAddr: string; AComputerName, AWinUserID,
  AWinPasswd: string): integer;
var
  Reg: TRegistry;
  SubKeys: TStringList;
  KeyPath: string;
  I: Integer;
  DriverDesc: string;
begin
  KeyPath := 'SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}';

  Reg := TRegistry.Create(KEY_READ);
  SubKeys := TStringList.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    if Reg.OpenKey(KeyPath, False) then
    begin
      Reg.GetKeyNames(SubKeys);//0000~0013 리스트를 가져욤
      Reg.CloseKey;
      for I := 0 to SubKeys.Count - 1 do
      begin
        if Reg.OpenKey(KeyPath + '\' + SubKeys[I], False) then
        begin
          if Reg.ValueExists('DriverDesc') then
          begin
            DriverDesc := Reg.ReadString('DriverDesc');
            if SameText(DriverDesc, AIpAddr) then
            begin
//              Result := KeyPath + '\' + SubKeys[I];
              Exit;
            end;
          end;
          Reg.CloseKey;
        end;
      end;
    end;
  finally
    SubKeys.Free;
    Reg.Free;
  end;
end;

end.


