unit JHP.Util.gpSharedMemType;

interface

type
  TGpShMMInfo = record
    FName,
    FNameSpace,
    FEventName,
    FEngParamShMMName: string;
    FMemSize,
    FMainFormHandle,
    FSubFormHandle
    : integer;
    FJHP_gpShM: Pointer;
  end;

implementation

end.
