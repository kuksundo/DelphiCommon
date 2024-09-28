unit UnitNICUtil;

interface

uses classes,
  ActiveX, ComObj, Variants, SysUtils, Windows, Registry, shellapi,
  mormot.core.base, mormot.core.os, mormot.core.text,
  mormot.core.collections, mormot.core.variants, mormot.core.json,
  mormot.core.unicode
  ;

procedure DisableNIC_WMI();
procedure EnableNIC_WMI();
//Registry에서 검색할때 사용되는 NIC Index List를 Result에 반환함 : IP Addr = index 형식(10.8.2.1 = 1)
function GetNICIndexList_WMI(AIpAddr: string=''): TStringList;
function GetNICIndexFromIpAddr_WMI(AIpAddr: string): string;
//AAdvPropNameList: Registry에서 가져올 Property Name List를 전달함
function GetNICAdvPropsJsonFromRegistryByIpAddr(const AIpAddr: string;
  AAdvPropNameList: TStringList): RawUtf8;
//AIdx: 0000 형식의 Reg Key 값
//AAdvPropNameList: Registry에서 가져올 Property Name List를 전달함
//1개의 NIC에 대한 Advanced Properties 값들을 json Array로 반환 함
//Result = ["Flow Contro" : "Diabled",...]
function GetNICAdvPropsJsonFromRegistryByNICIdx(const AIdx: string; AAdvPropNameList: TStringList): RawUtf8;
//Result = ParamName=Param Desc : (*Flow Control = Flow Control)
function GetAdvPropertyListFromRegByIdx(const AIdx: string): TStringList;
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

function GetAdvNICProp2JsonFromRegKeyByIpAddr(const AIpAddr: string): string;
function SetNetworkAdapterRegistryKeyFromIpAddr(const AIpAddr: string): integer;
function GetNICGUIDFromRegistryKeyByIpAddr(const AIpAddr: string): string;

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

uses UnitRegistryUtil;

procedure DisableNIC_WMI();
//Disable a NIC
const
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapter Where NetEnabled=True','WQL',wbemFlagForwardOnly);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    FWbemObject.Disable();
    FWbemObject:=Unassigned;
  end;
end;

procedure EnableNIC_WMI();
//Enable a NIC
const
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapter Where NetEnabled=False','WQL',wbemFlagForwardOnly);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    FWbemObject.Enable();
    FWbemObject:=Unassigned;
  end;
end;

function GetNICIndexList_WMI(AIpAddr: string): TStringList;
const
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  LStr: string;
begin
  Result := TStringList.Create;

  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled=True','WQL',wbemFlagForwardOnly);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
//    LStr := FWbemObject.Caption;
    //Intel(R) 82574L Gigabit Network Connection;{949DC1B0-9859-491A-819F-B93CFCC0CDAC};%SystemRoot%\System32\drivers\etc
//    LStr := FWbemObject.Description + ';' + FWbemObject.SettingID + ';' + FWbemObject.DatabasePath;
//    LStr := FWbemObject.DNSDomain + ';' + FWbemObject.MACAddress + ';' + FWbemObject.IPAddress[0];
//    LStr := FWbemObject.DNSDomain + ';' + IntToStr(FWbemObject.InterfaceIndex);
//    LStr := + FWbemObject.DNSHostName + ';' + IntToStr(FWbemObject.Index) + ';' + IntToStr(FWbemObject.InterfaceIndex);

    if AIpAddr <> '' then
    begin
      if AIpAddr = FWbemObject.IPAddress[0] then
      begin
        Result.Add(FWbemObject.IPAddress[0] + '=' + IntToStr(FWbemObject.Index));
        exit;
      end;
    end
    else
      Result.Add(FWbemObject.IPAddress[0] + '=' + IntToStr(FWbemObject.Index));

    FWbemObject:=Unassigned;
  end;//while
end;

function GetNICIndexFromIpAddr_WMI(AIpAddr: string): string;
var
  LStrList: TStringList;
begin
  Result := '';
  LStrList := GetNICIndexList_WMI(AIpAddr);

  if LStrList.Count > 0 then
  begin
    Result := LStrList.Values[AIpAddr];
  end;
end;

function GetNICAdvPropsJsonFromRegistryByIpAddr(const AIpAddr: string;
  AAdvPropNameList: TStringList): RawUtf8;
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
  LStrList := GetNICIndexList_WMI();

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

function GetNICAdvPropsJsonFromRegistryByNICIdx(const AIdx: string; AAdvPropNameList: TStringList): RawUtf8;
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

function GetAdvPropertyListFromRegByIdx(const AIdx: string): TStringList;
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

function GetAdvNICProp2JsonFromRegKeyByIpAddr(const AIpAddr: string): string;
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

function SetNetworkAdapterRegistryKeyFromIpAddr(const AIpAddr: string): integer;
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
      Reg.GetKeyNames(SubKeys);
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

function GetNICGUIDFromRegistryKeyByIpAddr(const AIpAddr: string): string;
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

end.


