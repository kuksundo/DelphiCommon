unit UnitWMIUtil;

interface

uses classes, ActiveX, ComObj, Variants, SysUtils, Windows, System.Generics.Collections,
  magwmi, magsubs1, WbemScripting_TLB, ArrayHelper;

type
  TGPWMI = class
  public
    class function GetWMIInfo(const Comp, NameSpace, User, Pass, Arg: string ;
       var WmiResults: T2DimStrArray; var instances: integer; var errinfo: string): integer ;
    class function GetWMIObjectEnum(const AComputerName, NameSpace, User, Pass, SQL: string): IEnumVariant;
    //ARowIdx: JsonAry로 변경할 A2DimAry의 Row Index
    class function GetT2DimStrArray2JsonAryByRowIdx(const A2DimAry: T2DimStrArray; const ARowIdx: integer): string;
    //A2DimAry로 부터 1행의 AFieldName을 검색하여 Column Index 가져와서 2행의 Column Index 위치에 있는 Value를 반환 함
    //ex: GetValueFrom2DStrArrayByName(WmiResults, 'RegistryValue') => '3'
    //ex: GetValueFrom2DStrArrayByName(WmiResults, 'ValidDisplayValues') => 'Disabled|Rx Enabled|Tx Enabled|Rx & TX Enabled'
    class function GetValueFrom2DStrArrayByFieldName(const A2DimAry: T2DimStrArray; const AFieldName: string): string;
    //AValidDisplayValues: 'Disabled|Rx Enabled|Tx Enabled|Rx & TX Enabled'
    //ARegistryValue: '3'
    //Result := 'Rx & TX Enabled'
    class function GetDispValueFromValidDisplayValuesByRegistryValue(const AValidDisplayValues, ARegistryValue: string): string;
  end;

implementation

{ TGPWMI }

class function TGPWMI.GetDispValueFromValidDisplayValuesByRegistryValue(
  const AValidDisplayValues, ARegistryValue: string): string;
var
  LStrList: TStringList;
  LIdx: integer;
begin
  Result := '';

  LStrList := TStringList.Create;
  try
    LStrList.Delimiter := '|';
    LStrList.StrictDelimiter := True;
    LStrList.DelimitedText := AValidDisplayValues;

    LIdx := StrToIntDef(ARegistryValue, -1);

    if LIdx <> -1 then
      Result := LStrList.Strings[LIdx];
  finally
    LStrList.Free;
  end;
end;

class function TGPWMI.GetT2DimStrArray2JsonAryByRowIdx(
  const A2DimAry: T2DimStrArray; const ARowIdx: integer): string;
begin

end;

class function TGPWMI.GetValueFrom2DStrArrayByFieldName(
  const A2DimAry: T2DimStrArray; const AFieldName: string): string;
var
  LCaptionAry, LValueAry: TArray<string>;
  i: integer;
begin
  Result := '';

  if Length(A2DimAry) < 2 then
    exit;

  LCaptionAry := nil;
  LValueAry := nil;

  TArray.AddRange<string>(LCaptionAry, A2DimAry[0]);

  i := TArray.IndexOf<string>(LCaptionAry, AFieldName);

  if i >= 0  then
  begin
    TArray.AddRange<string>(LValueAry, A2DimAry[1]);
    Result := LValueAry[i];
  end;
end;

class function TGPWMI.GetWMIInfo(const Comp, NameSpace, User, Pass, Arg: string;
  var WmiResults: T2DimStrArray; var instances: integer;
  var errinfo: string): integer;
begin
  result := MagWmiGetInfoEx (Comp, NameSpace, User, Pass, Arg,
    WmiResults, instances, errinfo);
end;

class function TGPWMI.GetWMIObjectEnum(const AComputerName, NameSpace, User, Pass,
  SQL: string): IEnumVariant;
var
  LSWbemLocator : OLEVariant;
  LWMIService   : OLEVariant;
  LWbemObjectSet: OLEVariant;
begin
  LSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  LWMIService   := LSWbemLocator.ConnectServer(AComputerName, NameSpace, User, Pass); //'localhost', 'root\CIMV2', '', ''
  LWbemObjectSet:= LWMIService.ExecQuery(SQL,'WQL',wbemFlagReturnImmediately); //'SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled=True'
  Result        := IUnknown(LWbemObjectSet._NewEnum) as IEnumVariant;
end;

end.
