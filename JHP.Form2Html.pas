unit JHP.Form2Html;

interface

uses SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, JvFormToHtml;

type
  TJHFormToHtml = class(TJvFormToHtml)
  public
    procedure DFMFileToHtml(const ADFMFileName, ASaveFilename: string);
  end;

implementation

uses UnitDFMUtil;

{ TJHFormToHtml }

procedure TJHFormToHtml.DFMFileToHtml(const ADFMFileName,
  ASaveFilename: string);
var
  LForm: TForm;
begin
  if FileExists(ADFMFileName) then
  begin
    LForm := TFormClass.Create();
    try
      LoadFromDFM(ADFMFileName,
    finally
      LForm.Free;
    end;
  end;
end;

end.
