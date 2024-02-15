unit UnitChatBotTypes;

interface

uses Winapi.Messages,
  mormot.core.json, mormot.core.collections, mormot.core.variants,
  UnitEnumHelper;


type
  TChatBotKind = (cbkNull, cbkTelegram, cbkKakao);
  TTelegramAPIKind = (takNull, takSendMsg, takSendDocument, takSendPhoto);
  TKakaoAPIKind = (kakNull, kakSendMsg, kakSendDocument, kakSendPhoto);

  TtgChatIDRec = record
    FUserID,
    FChatID: string;
    FUserName
    : string;
    FRoomTitle,//Title
    FType //channel or chatroom
    : string;
  end;

  TKakaoChatIDRec = record
    FID: string;
    FUserName: string;
  end;

  ///Key: 방/채널 이름
  TTelegramChatIDDic = IKeyValue<string, TtgChatIDRec>;
  TKakaoChatIDDic = IKeyValue<string, TKakaoChatIDRec>;

const
  R_ChatBotKind : array[Low(TChatBotKind)..High(TChatBotKind)] of string =
    ('', 'Telegram', 'Kakao');
  R_TelegramAPIKind : array[Low(TTelegramAPIKind)..High(TTelegramAPIKind)] of string =
    ('', 'SendMsg', 'SendDocument', 'SendPhoto');
  R_KakaoAPIKind : array[Low(TKakaoAPIKind)..High(TKakaoAPIKind)] of string =
    ('', 'SendMsg', 'SendDocument', 'SendPhoto');

var
  g_ChatBotKind: TLabelledEnum<TChatBotKind>;
  g_TelegramAPIKind: TLabelledEnum<TTelegramAPIKind>;
  g_KakaoAPIKind: TLabelledEnum<TKakaoAPIKind>;

implementation

initialization
//  g_ChatBotKind.InitArrayRecord(R_ChatBotKind);
//  g_TelegramAPIKind.InitArrayRecord(R_TelegramAPIKind);
//  g_KakaoAPIKind.InitArrayRecord(R_TelegramAPIKind);

end.
