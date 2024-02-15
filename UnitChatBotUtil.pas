unit UnitChatBotUtil;

interface

uses Winapi.Messages, Vcl.StdCtrls, System.Classes,
  mormot.core.json, mormot.core.collections, mormot.core.variants,
  UnitEnumHelper,
  UnitChatBotTypes;

  procedure SetComboDropDownByEnum(const AChatBotKind: TChatBotKind; ACombo: TComboBox);

implementation

procedure SetComboDropDownByEnum(const AChatBotKind: TChatBotKind; ACombo: TComboBox);
var
  LStrings: TStrings;
begin
  ACombo.Items.Clear;

  case AChatBotKind of
    cbkTelegram: begin
      LStrings := g_TelegramAPIKind.GetTypeLabels;
    end;
    cbkKakao: begin
      LStrings := g_KakaoAPIKind.GetTypeLabels;
    end;
  end;

  ACombo.Items.AddStrings(LStrings);
  LStrings.Free;
end;

end.
