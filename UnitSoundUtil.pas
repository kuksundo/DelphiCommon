unit UnitSoundUtil;

interface

uses MMSystem;

type
  TSoundType = (stFileName, stResource, stSysSound);

function ExecuteSound(const Sound: string; IsStop: Boolean = False;
  SoundType: TSoundType = stFileName;
  Synchronous: Boolean = False; Module: HMODULE = 0;
  AddFlags: LongWord = 0): Boolean;

implementation

function ExecuteSound(const Sound: string; IsStop: Boolean = False;
  SoundType: TSoundType = stFileName;
  Synchronous: Boolean = False; Module: HMODULE = 0;
  AddFlags: LongWord = 0): Boolean;
var
  Flags: LongWord;
begin
  if IsStop then
  begin
    Result := sndPlaySound(nil, 0);
    exit;
  end;

  Flags := AddFlags;
  case SoundType of
    stFileName: Flags := Flags or SND_FILENAME;
    stResource: Flags := Flags or SND_RESOURCE;
    stSysSound: Flags := Flags or SND_ALIAS;
  end;
  if not Synchronous then
    Flags := Flags or SND_ASYNC;
  if SoundType <> stResource then
    Module := 0;

  //Result := PlaySound(PChar(Sound), Module, Flags);
  Result := sndPlaySound(PChar(Sound), SND_ASYNC or SND_LOOP);
end;

end.
