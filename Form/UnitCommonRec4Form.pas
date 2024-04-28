unit UnitCommonRec4Form;

interface

uses
  mormot.core.json, mormot.core.collections;

type
  TRGValueRec = packed record
    Idx, //Radio Group Item Index
    Value: integer; //실제 할당된 값(예: kospi = 10 이지만 radio group 에는 첫번째에 표시됨=> Idx=0)
    //주식의 경우 TrCode List가 저장됨:
    //예: Name = "종목코드"의 경우 OPT10008에서는 000:전체, 001:코스피, 101:코스닥 이고
    //다른 TrCode에서는 회사코드를 의미함)
    Desc, //Name이 중복될 경우 적용할 추가 규칙
    Name  //RG에 표시할 Item Name
    : string;
  end;

  //key: RadioGroup Item Index(실제 Index는 Value에 저장됨)
  TRGValueDict = IKeyValue<integer, TRGValueRec>;
  //key: Desc(Parameter 이름)
  TRGValueOptionDict = IKeyValue<string, TRGValueDict>;

implementation

end.
