unit UnitGeminiUtil;

interface

uses classes, SysUtils, //Vcl.Dialogs,
  mormot.core.base,
  mormot.core.os,
  mormot.core.text,
  mormot.net.client,
  mormot.net.sock,
  mormot.net.http,
  mormot.core.unicode,
  mormot.core.collections,
  mormot.core.variants,
  mormot.core.json,
  mormot.core.buffers;

//AModelName = gemini-2.5-flash
function CallGeminiApiWithMormot_generateContent(const ApiKey, AModelName: string; const Prompt: string; out ARespond: string): integer;
//Gemini Respond로 수신한 Json에서 '#$A', '\n' 및 '\'를 제거함
function AdjustJsonOfJeminiRespond(var ARespond: string): integer;
//Jemini Respond에서 candidates[content{parts[text]}]의 value를 반환함
function GetJsonOfTextNameFromJeminiRespond(const ARespond: string): string;

procedure test();

implementation

uses UnitJsonUtil, UnitStringUtil;

procedure test();
var
  LDocList: IDocList;
begin
  LDocList := DocList('[]');
  LDocList.Append('{"text": "test"}');
//  ShowMessage(LDocList.Json);
end;

function CallGeminiApiWithMormot_generateContent(const ApiKey, AModelName: string; const Prompt: string; out ARespond: string): integer;
const
  DEFAULT_TIMEOUT_MS = 5000;
var
  LHttpClient: THttpClientSocket;
  LHost: RawUTF8;
  LPath: RawUTF8;
  LPort: RawUtf8;
  LUri: TUri;
  LHeaders, LJsonBody: RawUTF8;
  LListParts,
  LListContents: IDocList;
  LDictText,
  LDictParts,
  LDictContents,
  LDictgenerationConfig,
  LDictthinkingConfig: IDocDict;
begin
  ARespond := '';
  Result := 0;

  LListParts := DocList('[]');
  LListContents := DocList('[]');

  LDictText := DocDict('{}');
  LDictParts := DocDict('{}');
  LDictContents := DocDict('{}');

  LDictgenerationConfig := DocDict('{}');
  LDictthinkingConfig := DocDict('{}');

  try
    // 1. URI 파싱
    LUri.From('https://generativelanguage.googleapis.com/v1beta/models/' + AModelName + ':generateContent');
    LHost := RawUTF8(LUri.Server);
    LPath := RawUTF8(LUri.Address);
    LPort := LUri.Port;

    // 2. THttpClientSocket 인스턴스 생성
    LHttpClient := THttpClientSocket.Create(3000);
    try
      LHttpClient.TLS.IgnoreCertificateErrors := True;
      // HTTPS 연결 설정 (필수!)
      LHttpClient.Open(LHost, LPort, nlTcp, 20000, True);

      // 3. JSON 요청 본문 생성
      LDictText.S['text'] := StringToUtf8(Prompt);
      LListParts.AppendDoc(LDictText);
      LDictParts.A['parts'] := LListParts;
      LListContents.AppendDoc(LDictParts);
      LDictContents.A['contents'] := LListContents;

      LDictthinkingConfig.I['thinkingBudget'] := 0;
      LDictgenerationConfig.D['thinkingConfig'] := LDictthinkingConfig;
      LDictContents.D['generationConfig'] := LDictgenerationConfig;
      LJsonBody := LDictContents.Json;
//      LJsonBody := '{"contents":[{"parts": [{"text": "Explain how AI works in a few words"}]}]}';
      // 4. HTTP 헤더 설정
      LHttpClient.HeaderAdd('x-goog-api-key:' + ApiKey);
//      LHttpClient.HeaderAdd('Content-Type: application/json');

      // 6. POST 요청 보내기
      // Post(const APath: RawUTF8; AContentType: RawUTF8; AContent: TStream; var AHeaders: THttpHeaders; ATimeoutMs: Cardinal = DEFAULT_TIMEOUT_MS): Integer;
//      Result := LHttpClient.Post(LPath, LJsonBody, 'application/json', DEFAULT_TIMEOUT_MS, LHttpClient.Headers);
      Result := LHttpClient.Request(LPath, 'POST', DEFAULT_TIMEOUT_MS, LHttpClient.Headers, LJsonBody, 'application/json');
      // 7. 응답 처리
      ARespond := Utf8ToString(LHttpClient.Http.Content); // 응답 본문 가져오기 (RawUTF8 -> string)

      if Result <> 200 then
      begin
        raise Exception.CreateFmt('API 호출 실패: 상태 코드 %d, 메시지: %s', [Result, string(LHttpClient.Http.Content)]);
      end;
    finally
      LHttpClient.Free; // HTTP 클라이언트 소켓 해제
    end;

  except
    on E: Exception do
    begin
      ARespond := '에러 발생: ' + E.Message;
    end;
  end;

end;

function AdjustJsonOfJeminiRespond(var ARespond: string): integer;
begin
  ARespond := StringReplace(ARespond, ''#$A'', '', [rfReplaceAll]);
//  ARespond := replaceString(ARespond, ''#$A'', '');
  ARespond := StringReplace(ARespond, '\n', '', [rfReplaceAll]);
  ARespond := StringReplace(ARespond, '\', '', [rfReplaceAll]);
  ARespond := StringReplace(ARespond, '"```json', '', [rfReplaceAll]);
  ARespond := StringReplace(ARespond, '```"', '', [rfReplaceAll]);
end;

(* ARespond :=
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "```json[  {    "Idx": 9,    "HullNo": "2366",    "ClaimNo": "125",    "Subject": "RE: HLS FLUORITE(Hull No. 2366), GCR-125 MPM/OWS/FBM (ECC,CCR,WH) CAN1, 2 COMM. ERROR",    "Description": "고객 독촉",    "ExistInDB": false  }]```"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP",
      "index": 0
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 122,
    "candidatesTokenCount": 116,
    "totalTokenCount": 238,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 122
      }
    ]
  },
  "modelVersion": "gemini-2.5-flash",
  "responseId": "9TCAaPmzG-HOz7IPy77GuQE"
}
*)
function GetJsonOfTextNameFromJeminiRespond(const ARespond: string): string;
var
  LList: IDocList;
  LDict: IDocDict;
  LRawUtf8: RawUtf8;
begin
  LDict := DocDict(StringToUtf8(ARespond));
  Result := LDict.S['candidates'];
  LList := DocList(LDict.S['candidates']);
  Result := LList.Json;
  LDict.Clear;
  LRawUtf8 := LList[0].content;
  LDict := DocDict(LRawUtf8);
  LList.Clear;
  LList := DocList(LDict.S['parts']);
  LDict.Clear;
  LRawUtf8 := LList[0].text;
  Result := Utf8ToString(LRawUtf8);
//  Result := ExtractTextBetweenDelim(Result, '"```json', '```"');
end;

end.
