unit JHP.Util.gpSharedMemType;

interface

type
  TGpShMMInfo = record
    FName,
    FNameSpace,
    FEventName: string;
    FMemSize: integer;
    FJHP_gpShM: Pointer;
  end;

implementation

end.
