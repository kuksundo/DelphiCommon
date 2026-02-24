unit UnitWebView4DUtil;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Forms, classes, Generics.Collections,
  mormot.core.buffers, //mormot.core.collections,
  uWVBrowserBase, uWVBrowser, uWVTypeLibrary, uWVCoreWebView2Frame;

const
  MSG_LISTNER_4_BTN_CLICK_ON_MAIN_FRAME =
    // iframe에서 오는 메시지 수신
    'window.addEventListener("message", function(event) { '+
        // 보안: origin 검증 (운영환경에서 필수)
        // if (event.origin !== 'https://example.com') return;

        // 버튼 클릭 이벤트 처리
    '    if (event.data.type === "button_click") { '+
            // WebView2를 통해 Delphi로 전달
    '        if (window.chrome && window.chrome.webview) { '+
    '            window.chrome.webview.postMessage({ '+
    '                eventType: "iframe_button_click", '+
    '                buttonId: event.data.buttonId, '+
    '                timestamp: event.data.timestamp, '+
    '                elementInfo: event.data.elementInfo '+
    '            }); '+
    '        } '+
    '    } '+
    '}); ';

  MINIBROWSER_VISITDOM_PARTIAL            = WM_APP + $101;
  MINIBROWSER_VISITDOM_FULL               = WM_APP + $102;
  MINIBROWSER_COPYFRAMEIDS_1              = WM_APP + $103;
  MINIBROWSER_COPYFRAMEIDS_2              = WM_APP + $104;
  MINIBROWSER_SHOWMESSAGE                 = WM_APP + $105;
  MINIBROWSER_SHOWSTATUSTEXT              = WM_APP + $106;
  MINIBROWSER_VISITDOM_JS                 = WM_APP + $107;
  MINIBROWSER_SHOWERROR                   = WM_APP + $108;
  MINIBROWSER_RECEIVEDCONSOLEMSG          = WM_APP + $109;

  DOMVISITOR_MSGNAME_PARTIAL  = 'domvisitorpartial';
  DOMVISITOR_MSGNAME_FULL     = 'domvisitorfull';
  RETRIEVEDOM_MSGNAME_PARTIAL = 'retrievedompartial';
  RETRIEVEDOM_MSGNAME_FULL    = 'retrievedomfull';
  FRAMEIDS_MSGNAME            = 'getframeids';
  CONSOLE_MSG_PREAMBLE        = 'DOMVISITOR';
  FILLUSERNAME_MSGNAME        = 'fillusername';

  NODE_ID = 'keywords';
  GET_VALUE_PREAMBLE = 'GETVALUE:';
  GET_INNERTEXT_PREAMBLE = 'GETINNERTEXT:';
  GET_MULTIPLE_VALUES_PREAMBLE = 'GETMULTIPLEVALUES:';
  GET_MULTIPLE_INNERTEXT_PREAMBLE = 'GETMULTIPLEINNERTEXT:';
  BUTTON_CLICK_EVENT_PREAMBLE = 'CLICK_EVENT:';

  GET_ELEMENT_VALUE_MSG = 'getelementvalue';
  GOT_ELEMENT_VALUE_MSG = 'gotelementvalue';

  //++ Added for "GetFrameByElementID" function
  CHECK_ELEMENT_EXISTS_MSG = 'checkelementexists';
  ELEMENT_EXISTS_MSG = 'elementexists';

  RET_SET_OK = 'ok';
  RET_SET_ELEMENT_NOT_FOUND = 'element_not_found';
  RET_SET_FRAME_NOT_FOUND = 'frame_not_found';

  GET_VALUE_ID = 100;
  GET_INNERTEXT_ID = 101;
  GET_MULTIPLE_VALUES_ID = 102;
  GET_MULTIPLE_INNERTEXT_ID = 103;
  SET_VALUE_ID = 104;
  GET_IFRAME_HTML_ID = 105;
  GET_MULTI_INNERTEXT_IN_IFRAME_ID = 106;
  GET_MULTI_VALUE_IN_IFRAME_ID = 108;
  HAS_IFRAME_ID = 109;
  SYNC_IFRAME_NAMENID_ID = 110;
  GET_MULTI_VALUE_INNERTEXT_IN_IFRAME_ID = 111;
  SET_USER_ID = 112;
  SET_PASSWORD = 113;
  SET_DOM_ID = 114;

  CLICK_ELEMENT_EVENT_ID = 200;
  SELECT_COMBO_EVENT_ID = 201;
  ON_CLICK_SAVE_BUTTON_ID = 202;
  ADD_LISTENER_ON_CLICK_ID = 203;
  CONSOLE_LOG_ID = 204;
  LOG_ENABLE_CMD = 205;
  LOG_ENTRYADDED_EVENT = 206;
  //++                    ;

type
  TWebView4DUtil = class
    class var FSyncResult   : string;
    class var FSyncReceived : boolean;

    class function ExtractJavaScriptResult(const AJson: string): string; static;
    //IFrame Id를 Name 속성에 복사함
    class procedure SyncFrameNameNId(const AWVBrowser: TWVBrowser); static;

    class procedure GetDOMelementFromBrowser(const ABrowser: TWVBrowser; const AName: string; const AID: Integer; const AByID: Boolean = True);
    class procedure SetDOMelementFromBrowser(const ABrowser: TWVBrowser; const AName, AValue: string; const AByID: Boolean = True); static;

    class procedure GetElementValueByID(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const aElementID: string); static;
    class procedure GetElementInnerTextByIDFromBrowser(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AElementID: string); static;
    class procedure GetMultipleElementValuesByIDAry(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AIds: TArray<string>; AExecutionID: Integer=GET_MULTIPLE_VALUES_ID); static;
    //입력받은 ID 목록(aElementIDs)을 JavaScript 배열로 변환
    //JavaScript 내에서 해당 ID들을 순회하며 element.innerText를 가져와 ;로 연결
    //console.log를 사용하여 GETMULTIPLEVALUES: 프리앰블과 함께 인코딩된 결과 문자열을 출력하는 스크립트를 실행
    class procedure GetMultipleElementInnerTextByIDAry(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const aElementIDs: TArray<string>); static;
    class procedure GetMultipleElementValueOrInnerTextByIDAry(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const aElementIDs: TArray<string>); static;

    class function GetElementInnerTextByIDFromBrowserSync(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const aElementID: string): string; static;

    //--OnNavigationCompleted 이후 값을 변경할 것

    //특정 ID를 가진 HTML 요소에 값을 할당하는 함수
    //ID를 찾아 해당 요소가 value 속성을 지원하면 value에, 그렇지 않으면 innerText에 값을 할당
    //<input>, <textarea>, <select> 등은 value 속성
    //<div>, <span>, <p> 등은 innerText 속성에 값을 할당
    class procedure SetElementValueById(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AId, AValue: string); static;
    //주로 <input>, <select> 등 폼(Form) 요소에서 많이 사용
    {Ex:
      // Name이 'email'인 모든 입력창의 값을 변경
      SetElementValueByName(WVBrowser1, 'email', 'test@example.com', True);}
    class procedure SetElementValueByName(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AName, AValue: string; AAllElements: Boolean = False); static;
    //지정된 클래스명을 기준으로 요소를 찾음
    {Ex:
      // Class가 'status-label'인 첫 번째 요소의 텍스트를 변경
      SetElementValueByClass(WVBrowser1, 'status-label', '완료');    }
    class procedure SetElementValueByClass(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AClassName, AValue: string; AAllElements: Boolean = False); static;
    //querySelector를 사용하면 ID, Class, Name뿐만 아니라 복잡한 조건(예: 특정 div 안의 input 등)으로 요소를 찾을 수 있어
    {Ex:
      // CSS Selector로 특정 조건의 요소 변경
      SetElementValueBySelector(WVBrowser1, 'form#loginForm input[type="text"]', 'admin');    }
    class procedure SetElementValueBySelector(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const ASelector, AValue: string); static;
    //ID, Class, 또는 CSS Selector를 이용해 요소를 찾아 클릭 이벤트를 발생시킴
    {Ex:
      // 약관 동의 체크박스 클릭
      ClickElement(WVBrowser1, 'input#agree-term');
      // 로그인 버튼 클릭
      ClickElement(WVBrowser1, '.btn-submit-login');      }
    class procedure ClickElementByQrySelector(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const ASelector: string); static;
    //드롭다운은 <select> 태그 내의 특정 <option>을 선택하는 방식임.
    //값을 변경한 후 반드시 change 이벤트를 발생시켜야 브라우저가 변경 사항을 저장함.
    {EX:
      // 국가 선택 드롭다운 (Value 기반)
      SelectDropDownByValue(WVBrowser1, 'select.country-picker', 'KR');    }
    class procedure SelectDropDownByValue(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const ASelector, AValue: string); static;
    //값(Value)이 아닌 0번째, 1번째 등 순서로 선택해야 할 경우
    {EX:
    }
    class procedure SelectDropDownByIndex(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const ASelector: string; AIndex: Integer); static;

    //--- IFrame ---------------
    class procedure HasIFrameById(const AWVBrowser: TWVBrowser; const AFrameId: string); static;
    class procedure GetIFrameHTMLById(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AId: string); static;
    {
      Same-Origin: 메인 페이지와 IFrame의 도메인이 같은 경우 (JavaScript로 직접 접근 가능)
      Cross-Origin: 도메인이 다른 경우 (WebView2의 Frame 인터페이스를 통해 접근해야 함)
    }
    //Same-Origin IFrame 요소 제어 (JavaScript 방식)
    {Ex:
      // 값 읽기 요청 (ID 100번으로 응답 대기)
      GetIFrameElementValue(WVBrowser1, '#myIframe', '#username', 100);
    }
    class procedure GetIFrameElementValue(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AIFrameSelector, AElementSelector: string; AExecutionID: Integer=GET_VALUE_ID); static;
    class procedure GetIFrameElementValue2(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AIFrameSelector, AElementSelector: string; AExecutionID: Integer=GET_VALUE_ID); static;
    {Ex:
      // ID가 'myIframe'인 프레임 내부의 ID가 'username'인 input에 값 입력
      SetIFrameElementValue(WVBrowser1, '#myIframe', '#username', 'delphi_user');
    }
    class procedure SetIFrameElementValue(ABrowser: TWVBrowser; const AIFrameSelector, AElementSelector, AValue: string); static;
    // 특정 프레임 내에서 스크립트를 실행
    class procedure ExecuteScriptByIFrameId(const AWVBrowser: TWVBrowser; const AFrameId: string; const AScript: string; AExecutionID: Integer);
    //특정 Frame 내 복수 ID의 InnerText 요청 함수
    class procedure GetMultipleElementInnerTextByIFrameId(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AFrameId: string; const aElementIDs: TArray<string>); static;
    //특정 Frame 내 복수 ID의 Value 요청 함수
    class procedure GetMultipleElementValueByIFrameId(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AFrameId: string; const aElementIDs: TArray<string>); static;

    class procedure SetElementValueFromIFrameList(ABrowser: TWVBrowser; AFrameList: TObjectList<TCoreWebView2Frame>; const AElementSelector, AValue: string); static;
    class procedure ClickElementByQrySelectorFromIFrameList(ABrowser: TWVBrowser; AFrameList: TObjectList<TCoreWebView2Frame>; const ASelector: string; const AFrameIdx: integer=-1); static;
    class procedure ClickElementFromBrowser(ABrowser: TWVBrowser; const ASelector: string; const AByID: Boolean = True); static;
    class procedure ClickElementByQrySelectorFromIFrame(ABrowser: TWVBrowser; const AIFrameId, ASelector: string); static;

    //모든 프레임(iframe 포함)이 로드될 때 실행될 JavaScript를 등록
    //문서 내에서 "btn_save"라는 ID를 가진 요소를 찾아 클릭 리스너를 추가
    //AfterCreated 메서드에서 실행할 것
    class procedure AddListenerClickUsingAddScriptOnMainFrame(const ABrowser: TWVBrowser; const ABtnId: string); static;
    class procedure AddListenerClickEventByQrySelectorFromIFrame(ABrowser: TWVBrowser;
      AFrameList: TObjectList<TCoreWebView2Frame>; const AFrameIdx: integer; ASelector: string); static;
    class procedure AddListenerMessageUsingAddScriptOnMainFrame(ABrowser: TWVBrowser); static;
    class procedure AddListenerMessageOnMainFrame(ABrowser: TWVBrowser); static;
  end;

implementation

{ TCefUtil }

//class procedure TCefUtil.AddBtnClickEventWithConsoleLogByText(
//  const aFrame: ICefFrame; const aButtonText: string);
//var
//  TempJSCode: string;
//begin
//  // 프레임이 유효하지 않으면 종료
//  if (aFrame = nil) or (not aFrame.IsValid) then Exit;
//
//  // 자바스크립트 생성
//  // QuotedStr을 사용하여 델파이 문자열을 자바스크립트 문자열 리터럴로 안전하게 변환합니다.
//  TempJSCode :=
//    'var targetText = ' + QuotedStr(aButtonText) + ';' +
//    'function addLog(element) {' +
//    '    element.addEventListener("click", function() {' +
//    '        console.log("CLICK_EVENT:" + targetText);' +
//    '    });' +
//    '}' +
//    // 1. <button> 태그 검색
//    'var buttons = document.getElementsByTagName("button");' +
//    'for (var i = 0; i < buttons.length; i++) {' +
//    '    if (buttons[i].innerText.trim() === targetText) {' +
//    '        addLog(buttons[i]);' +
//    '    }' +
//    '}' +
//    // 2. <input type="button|submit|reset"> 태그 검색
//    'var inputs = document.getElementsByTagName("input");' +
//    'for (var i = 0; i < inputs.length; i++) {' +
//    '    if (["button", "submit", "reset"].includes(inputs[i].type) && inputs[i].value === targetText) {' +
//    '        addLog(inputs[i]);' +
//    '    }' +
//    '}';
//
//  // 생성된 자바스크립트를 해당 프레임에서 실행
//  aFrame.ExecuteJavaScript(TempJSCode, 'about:blank', 0);
//end;
//
//class procedure TCefUtil.ClickButtonByID(const aFrame: ICefFrame;
//  const aElementID: string);
//var
//  TempJSCode: string;
//begin
//  if (aFrame <> nil) and aFrame.IsValid then
//  begin
//    TempJSCode := 'var btn = document.getElementById("' + aElementID + '"); if (btn) btn.click();';
//    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
//  end;
//end;
//
//class procedure TCefUtil.ClickButtonByText(const aFrame: ICefFrame;
//  const aButtonText: string);
//var
//  TempJSCode: string;
//begin
//  if (aFrame <> nil) and aFrame.IsValid then
//  begin
//    TempJSCode :=
//      'var buttons = document.getElementsByTagName("button");' +
//      'for (var i = 0; i < buttons.length; i++) {' +
//      '  if (buttons[i].innerText.trim() === "' + aButtonText + '") {' +
//      '    buttons[i].click();' +
//      '    break;' +
//      '  }' +
//      '}';
//    // input type="button"이나 "submit"도 찾아야 한다면 추가 로직 필요
//    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
//  end;
//end;
//
//class procedure TCefUtil.GetElementInnerTextByID(const aFrame: ICefFrame;
//  const aElementID: string);
//var
//  TempJSCode: string;
//begin
//  if (aFrame <> nil) and aFrame.IsValid then
//  begin
//    // Use encodeURIComponent to handle special characters safely
//    TempJSCode := 'console.log("' + GET_INNERTEXT_PREAMBLE + '" + encodeURIComponent(document.getElementById("' + aElementID + '").innerText));';
//    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
//  end;
//end;
//
//class procedure TCefUtil.GetElementInnerTextByIDAry(const aFrame: ICefFrame;
//  const aElementIDs: array of string);
//var
//  TempJSCode, TempIDs: string;
//  i: Integer;
//  TimeOut: Cardinal;
//begin
//  FSyncReceived := False;
//  FSyncResult := '';
//
//  if (aFrame <> nil) and aFrame.IsValid and (Length(aElementIDs) > 0) then
//  begin
//    TempIDs := '';
//    for i := Low(aElementIDs) to High(aElementIDs) do
//    begin
//      if i > Low(aElementIDs) then TempIDs := TempIDs + ',';
//      TempIDs := TempIDs + '"' + aElementIDs[i] + '"';
//    end;
//
//    TempJSCode :=
//      'var ids = [' + TempIDs + '];' +
//      'var result = "";' +
//      'for (var i = 0; i < ids.length; i++) {' +
//      '  var el = document.getElementById(ids[i]);' +
//      '  if (i > 0) result += ";";' +
//      '  if (el) result += el.innerText;' +
//      '}' +
//      'console.log("' + GET_MULTIPLE_INNERTEXT_PREAMBLE + ';' + '" + encodeURIComponent(result));';
////      'console.log("' + GET_MULTIPLE_INNERTEXT_PREAMBLE + ';' + '" + ids[1]);';
//
//    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);   //+ TempIDs + ';' +
//  end;
//end;

class procedure TWebView4DUtil.ClickElementFromBrowser(ABrowser: TWVBrowser;
  const ASelector: string; const AByID: Boolean);
var
  JSCode: string;
begin
  // iframe(win_main_subWindow1_iframe) 내부에서 '조회' 버튼을 찾아 클릭하는 스크립트
//  JSCode :=
//    'var frame = document.getElementById("win_main_subWindow1_iframe"); ' +
//    'if (frame) { ' +
//    '  var frameDoc = frame.contentDocument || frame.contentWindow.document; ' +
//    '  var buttons = frameDoc.querySelectorAll("input, button, a, .w2trigger"); ' +
//    '  for (var i = 0; i < buttons.length; i++) { ' +
//    '    if (buttons[i].value === "조회" || buttons[i].innerText.trim() === "조회") { ' +
//    '      buttons[i].click(); ' +
//    '      console.log("조회 버튼을 클릭했습니다."); ' +
//    '      break; ' +
//    '    } ' +
//    '  } ' +
//    '} else { ' +
//    '  console.error("검사접수 프레임을 찾을 수 없습니다."); ' +
//    '}';

//JSCode :=
//    'function performClick() {' +
//    '  function findAndClick(doc) {' +
//    '    /* 1. 모든 버튼 성격의 요소 추출 */' +
//    '    var targets = doc.querySelectorAll("input, button, a, .w2trigger, .w2textbox"); ' +
//    '    for (var i = 0; i < targets.length; i++) {' +
//    '      var t = targets[i];' +
//    '      /* 2. 텍스트 내용이나 value값이 "조회"인지 확인 */' +
//    '      if (t.value === "조회" || t.innerText.trim() === "조회") {' +
//    '        console.log("Found button in frame, clicking...");' +
//    '        /* 3. 일반 click이 안될 경우를 대비해 마우스 이벤트 시뮬레이션 */' +
//    '        ["mousedown", "mouseup", "click"].forEach(evt => {' +
//    '          var e = new MouseEvent(evt, { bubbles: true, cancelable: true, view: doc.defaultView });' +
//    '          t.dispatchEvent(e);' +
//    '        });' +
//    '        return true;' +
//    '      }' +
//    '    }' +
//    '    /* 4. 현재 문서 내 iframe이 있다면 재귀적으로 탐색 */' +
//    '    var frames = doc.querySelectorAll("iframe");' +
//    '    for (var j = 0; j < frames.length; j++) {' +
//    '      try {' +
//    '        var frameDoc = frames[j].contentDocument || frames[j].contentWindow.document;' +
//    '        if (findAndClick(frameDoc)) return true;' +
//    '      } catch (e) { /* Cross-origin 보안 에러 방지 */ }' +
//    '    }' +
//    '    return false;' +
//    '  }' +
//    '  findAndClick(document);' +
//    '} ' +
//    'performClick();';

//  JSCode :=
//    '(function () { ' +
//    '  var frames = document.getElementsByTagName("iframe");  ' +
//    '  for (var f = 0; f < frames.length; f++) {              ' +
//    '      try {                                              ' +
//    '         var doc = frames[f].contentWindow.document;     ' +
//    '         var btns = doc.querySelectorAll(".w2trigger");  ' +
//    '         for (var i = 0; i < btns.length; i++) {         ' +
//    '            if (btns[i].value && btns[i].value.indexOf("조회") !== -1) {  ' +
//    '                btns[i].click();                         ' +
//    '               return "OK";                              ' +
//    '              }                                          ' +
//    '          }                                              ' +
//    '      } catch (e) {}                                     ' +
//    '  }                                                      ' +
//    '  return "FAIL";                                         ' +
//    '})();                                                    ';

//  JSCode :=
//    '(function () { '+
//    '    var buttons = document.querySelectorAll(".w2trigger");                             ' +
//    '                                                                                       ' +
//    '    for (var i = 0; i < buttons.length; i++) {                                         ' +
//    '        if (buttons[i].value && buttons[i].value.indexOf("조회") !== -1) {           ' +
//    '                                                                                       ' +
//    '            // 표준 click                                                            ' +
//    '            buttons[i].dispatchEvent(new MouseEvent("ousedown", { bubbles: true })); ' +
//    '            buttons[i].dispatchEvent(new MouseEvent("ouseup", { bubbles: true }));    ' +
//    '            buttons[i].dispatchEvent(new MouseEvent("click", { bubbles: true }));      ' +
//    '                                                                                       ' +
//    '            return "WebSquare 조회 버튼 클릭";                                   ' +
//    '        }                                                                              ' +
//    '    }                                                                                  ' +
//    '    return "실패";                                                                   ' +
//    '})();                                                                                  ';

  if AByID then
    JSCode := 'document.getElementById("' + ASelector + '").click()'
  else
  begin

  end;

  ABrowser.ExecuteScript(JSCode, CLICK_ELEMENT_EVENT_ID);
end;

class procedure TWebView4DUtil.AddListenerClickEventByQrySelectorFromIFrame(
  ABrowser: TWVBrowser; AFrameList: TObjectList<TCoreWebView2Frame>;
  const AFrameIdx: integer; ASelector: string);
var
  JSCode: string;
  i: integer;
begin
  JSCode :=
    '(function () { '+
    '  var btn = document.getElementById("' + ASelector + '"); '+  //btn_saved
    '  if (!btn) return "' + ASelector + ' Not Found!"; '+
//    '  else return "Button Found"; '+

    '  btn.addEventListener("click", function () { '+
    '    var data = {' +
    '      type: "iframe_button_click", '+
    '      iframeId: window.frameElement ? window.frameElement.id : "", '+
    '      id: btn.id, '+
    '      className: btn.className || "", '+
    '      text: (btn.innerText || "").trim() '+
    '    };' +
    '    window.parent.postMessage(JSON.stringify(data));' +
//    '    window.chrome.webview.postMessage(JSON.stringify(data));' +
    '    console.log(JSON.stringify(data)); ' +


//    'console.log("체크 시작"); '+
//    'if (window.chrome && window.chrome.webview) { '+
//    '    window.chrome.webview.postMessage(JSON.stringify(data)); '+
//    '    console.log("메시지 전송 시도 완료"); '+
//    '} else { '+
//    '    console.error("오류: window.chrome.webview 객체를 찾을 수 없습니다. (CORS 제한)"); '+
//    '} '+
//    'console.log("체크 종료"); '+


//    '    window.parent.chrome.webview.postMessage({ '+
//    '      type: "iframe_button_click", '+
//    '      iframeId: window.frameElement ? window.frameElement.id : "", '+
//    '      id: btn.id, '+
//    '      className: btn.className || "", '+
//    '      text: (btn.innerText || "").trim() '+
//    '    }); '+

    '  }); '+

//    '  console.log("Add Listener Click"); ' +
    '})(); ';

  if AFrameIdx > -1 then
  begin
    if AFrameIdx < AFrameList.Count then
      AFrameList[AFrameIdx].ExecuteScript(JSCode, ADD_LISTENER_ON_CLICK_ID, ABrowser);
  end
  else
  begin
    for i := 0 to AFrameList.Count - 1 do
    begin
      AFrameList[i].ExecuteScript(JSCode, ADD_LISTENER_ON_CLICK_ID, ABrowser);
    end;
  end;
end;

class procedure TWebView4DUtil.AddListenerMessageOnMainFrame(
  ABrowser: TWVBrowser);
begin
  ABrowser.ExecuteScript(MSG_LISTNER_4_BTN_CLICK_ON_MAIN_FRAME);
end;

class procedure TWebView4DUtil.AddListenerMessageUsingAddScriptOnMainFrame(
  ABrowser: TWVBrowser);
begin
  ABrowser.AddScriptToExecuteOnDocumentCreated(
    MSG_LISTNER_4_BTN_CLICK_ON_MAIN_FRAME
  );
end;

class procedure TWebView4DUtil.AddListenerClickUsingAddScriptOnMainFrame(
  const ABrowser: TWVBrowser; const ABtnId: string);
begin
  // 브라우저 초기화 시점에 스크립트 등록
  // 이 스크립트는 모든 iframe 내부에서도 독립적으로 실행됩니다.
  ABrowser.AddScriptToExecuteOnDocumentCreated(
    'document.addEventListener("click", function(e) {' +
    '  if (e.target && e.target.id === "' + ABtnId + '") {' +
    '    window.chrome.webview.postMessage({ ' +
    '      action: "button_click", ' +
    '      buttonId: "' + ABtnId + '", ' +
    '      url: window.location.href ' + // 어떤 iframe에서 클릭되었는지 확인용
    '    });' +
    '   console.log("Clicked by AddScriptToExecuteOnDocumentCreated"); ' +
    '  }' +
    '  console.log("Add Listener on AddScriptToExecuteOnDocumentCreated"); ' +
    '}, true);');
end;

class procedure TWebView4DUtil.ClickElementByQrySelector(ABrowser: TWVBrowser;
  AFrame: TCoreWebView2Frame; const ASelector: string);
var
  JSCode: string;
begin
  // querySelector를 사용하면 #id, .class, button[type="submit"] 등 모두 대응 가능합니다.
//  JSCode := Format(
////    'var el = document.querySelector(%s); ' +
//    'var el = document.getElementById(%s); ' +
//    'if (el) { ' +
////    '  el.click(); ' +
////    '  el.onclick(); ' +
//    ' return "BUTTON_FOUND";' +
//    '} else return "BUTTON_NOT_FOUND";',
//    [QuotedStr(ASelector)]
//  );

  JSCode :=
       ' (function () {                                                                       ' +
       '     var buttons = document.querySelectorAll(''input[type="button"]'');               ' +
       '                                                                                      ' +
       '     for (var i = 0; i < buttons.length; i++) {                                       ' +
       '         if (buttons[i].id === "' + ASelector + '") {                                 ' +     //btn_search
       '            buttons[i].click();                                                       ' +
       '            console.log(                                                              ' +
       '             i,                                                                       ' +
       '             "id=", buttons[i].id,                                                    ' +
       '             "value=", buttons[i].value,                                              ' +
       '             "class=", buttons[i].className                                           ' +
       '            );                                                                        ' +
       '            return buttons[i].id;                                                           ' +
       '         }                                                                            ' +
       '     }                                                                                ' +
       '                                                                                      ' +
       ' })();                                                                                ' ;

  AFrame.ExecuteScript(JSCode, CLICK_ELEMENT_EVENT_ID, ABrowser);
//  ABrowser.ExecuteScript(Script, CLICK_ELEMENT_EVENT_ID);
end;

class procedure TWebView4DUtil.ClickElementByQrySelectorFromIFrame(
  ABrowser: TWVBrowser; const AIFrameId, ASelector: string);
begin

end;

class procedure TWebView4DUtil.ClickElementByQrySelectorFromIFrameList(
  ABrowser: TWVBrowser; AFrameList: TObjectList<TCoreWebView2Frame>;
  const ASelector: string; const AFrameIdx: integer);
var
  i: integer;
begin
  if AFrameIdx > -1 then
  begin
    if AFrameIdx < AFrameList.Count then
      TWebView4DUtil.ClickElementByQrySelector(ABrowser, AFrameList[AFrameIdx], ASelector)
  end
  else
  begin
    for i := 0 to AFrameList.Count - 1 do
    begin
      TWebView4DUtil.ClickElementByQrySelector(ABrowser, AFrameList[i], ASelector);
    end;
  end;
end;

class procedure TWebView4DUtil.ExecuteScriptByIFrameId(
  const AWVBrowser: TWVBrowser; const AFrameId, AScript: string; AExecutionID: Integer);
var
  JS: string;
begin
  JS :=
    '(function() {' +
    '  try {' +
    '    var f = document.getElementById("' + AFrameId + '");' +
    '    if (!f || !f.contentWindow) return "FRAME_NOT_FOUND";' +
    '    ' +
    '    // eval의 결과를 상위 함수로 리턴(return)해야 합니다. ' + #13#10 +
    '    return f.contentWindow.eval(' + QuotedStr(AScript) + ');' +
    '  } catch (e) {' +
    '    return "ERROR: " + e.message;' +
    '  }' +
    '})();';

  AWVBrowser.ExecuteScript(JS, AExecutionID);
//  AWVBrowser.ExecuteScript(JS, AExecutionID);
end;

class function TWebView4DUtil.ExtractJavaScriptResult(
  const AJson: string): string;
begin
Result := AJson;
  if (Result.StartsWith('"')) and (Result.EndsWith('"')) then
  begin
    Result := Copy(Result, 2, Length(Result) - 2);
    // JSON 이스케이프 문자 처리 (필요시)
    Result := URLDecode(Result); // 혹은 직접 Replace 처리
    Result := Result.Replace('\"', '"').Replace('\\', '\');
  end;
end;

class procedure TWebView4DUtil.GetMultipleElementInnerTextByIDAry(
  const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const aElementIDs: TArray<string>);
var
  IdListJson, Script: string;
  I: Integer;
begin
  if Length(aElementIDs) = 0 then Exit;

  // Delphi 배열을 JS 배열 문자열로 변환: ["id1", "id2"]
  IdListJson := '[';

  for I := Low(aElementIDs) to High(aElementIDs) do
  begin
    IdListJson := IdListJson + QuotedStr(aElementIDs[I]);
    if I < High(aElementIDs) then IdListJson := IdListJson + ',';
  end;

  IdListJson := IdListJson + ']';

  // innerText를 추출하여 세미콜론(;)으로 합치는 스크립트
  Script :=
    '(function(ids) {' +
    '  return ids.map(id => {' +
    '    const el = document.getElementById(id);' +
//    '    return el ? el.innerText.trim() : "";' + // innerText 추출 및 공백 제거
//    '    return (el.value !== undefined ? el.value : el.innerText.trim()) || ""; ' +
//    '    return (el.value ? el.value : (el.innerText ? el.innerText.trim() : "")) || "";' +

      '   if (el.tagName === "INPUT" || el.tagName === "TEXTAREA") { ' +
      '     return el.value || ""; ' +
      '   } else { ' +
      '     return el.innerText ? el.innerText.trim() : "";  ' +
      '   } ' +

//    '    return el ? el.innerText.trim() : "";' +
    '  }).join(";");' +
    '})(' + IdListJson + ');';

  AFrame.ExecuteScript(Script, GET_MULTI_INNERTEXT_IN_IFRAME_ID, AWVBrowser);
//  AWVBrowser.ExecuteScript(Script, GET_MULTIPLE_INNERTEXT_ID);
end;

class procedure TWebView4DUtil.GetMultipleElementInnerTextByIFrameId(
  const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AFrameId: string;
  const aElementIDs: TArray<string>);
var
  i: Integer;
  JsIds, JsCode: string;
begin
  // 1. Delphi 배열을 JS 배열 형태의 문자열로 변환 (예: ["id1", "id2"])
  JsIds := '[';

  for i := Low(aElementIDs) to High(aElementIDs) do
  begin
    JsIds := JsIds + '"' + aElementIDs[i] + '"';

    if i < High(aElementIDs) then
      JsIds := JsIds + ',';
  end;

  JsIds := JsIds + ']';

  // 2. JS 실행 코드 구성: map을 사용하여 각 ID의 innerText를 추출하고 ";"로 join
  JsCode := Format(
    '(function(ids) {' +
    '  return ids.map(id => {' +
    '    var el = document.getElementById(id);' +
    '    return el ? el.innerText : "";' +
    '  }).join(";");' +
    '})(%s);', [JsIds]);

  ExecuteScriptByIFrameId(AWVBrowser, AFrameId, JsCode, GET_MULTI_INNERTEXT_IN_IFRAME_ID);
end;

class procedure TWebView4DUtil.GetDOMelementFromBrowser(const ABrowser: TWVBrowser;
  const AName: string; const AID: Integer; const AByID: Boolean);
var
  LScript: string;
begin
  if AByID then
    LScript := Format('document.getElementById("%s").value;', [AName])
  else
    LScript := Format('document.querySelector("%s").value;', [AName]);

  // 비동기식으로 구현되어 있어서, 실행한 스크립트의 결과가 이벤트로 넘어온다.
  // 따라서 OnWExecuteScriptCompleted 이벤트에서 처리해야 한다
  ABrowser.ExecuteScript(LScript, AID);
end;

class procedure TWebView4DUtil.GetElementInnerTextByIDFromBrowser(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const AElementID: string);
var
  LJSCode: string;
begin
  // 해당 ID가 없을 경우를 대비해 예외 처리를 포함하는 것이 좋습니다.
  LJSCode := Format('var el = document.getElementById("%s"); el ? el.innerText : "";', [AElementID]);

  AFrame.ExecuteScript(LJSCode, GET_INNERTEXT_ID, AWVBrowser);
//  AWVBrowser.ExecuteScript(LJSCode, GET_INNERTEXT_ID);
end;

class function TWebView4DUtil.GetElementInnerTextByIDFromBrowserSync(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const aElementID: string): string;
var
  JSCode: string;
  Done: Boolean;
  ResultValue: string;
begin
  Result := '';
  Done := False;

  JSCode := Format('document.getElementById("%s").innerText', [AElementID]);

//  // 스크립트 실행 및 콜백 익명 메소드 활용
//  AWVBrowser.ExecuteScript(JSCode,
//    procedure(aErrorCode: HRESULT; const aresultObjectAsJson: System.WideString)
//    begin
//      ResultValue := aresultObjectAsJson;
//      Done := True;
//    end);
//
//  // 메시지 루프를 돌리며 대기 (타임아웃 처리를 추가하는 것이 안전합니다)
//  while not Done do
//  begin
//    Forms.Application.ProcessMessages;
//    Sleep(10);
//  end;

  // WebView2는 결과값을 JSON 문자열로 반환하므로 앞뒤 따옴표 등을 제거해야 합니다.
  Result := ResultValue;
end;

class procedure TWebView4DUtil.GetElementValueByID(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const aElementID: string);
var
  LScript: string;
begin
  LScript := 'document.getElementById("' + AElementID + '").value';

  AFrame.ExecuteScript(LScript, GET_VALUE_ID, AWVBrowser);
end;

class procedure TWebView4DUtil.GetIFrameHTMLById(const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AId: string);
var
  JsCode: string;
begin
  // JavaScript를 통해 해당 ID의 iframe 존재 여부를 확인하고 outerHTML을 반환
  JsCode := Format(
    'var elem = document.getElementById("%s"); ' +
    'if (elem && elem.tagName === "IFRAME") { elem.outerHTML; } ' +
    'else { "NOT_FOUND"; }', [AId]);

  // 비동기 실행 (결과는 OnExecuteScriptCompleted 이벤트에서 수신)
  AFrame.ExecuteScript(JsCode, GET_IFRAME_HTML_ID, AWVBrowser);// GET_IFRAME_HTML_ID은 ExecutionID (결과 식별용)
end;

class procedure TWebView4DUtil.GetIFrameElementValue(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const AIFrameSelector, AElementSelector: string; AExecutionID: Integer);
var
  Script: string;
begin
  Script := Format(
    '(function() { ' +
    '  var frame = document.querySelector(%s); ' +
    '  if (frame) { ' +
    '    var doc = frame.contentDocument || frame.contentWindow.document; ' +
    '    var el = doc.querySelector(%s); ' +
    '    if (el) return ("value" in el) ? el.value : el.innerText; ' +
    '  } ' +
    '  return "FRAME_OR_ELEMENT_NOT_FOUND"; ' +
    '})();',
    [QuotedStr(AIFrameSelector), QuotedStr(AElementSelector)]
  );

  AFrame.ExecuteScript(Script, AExecutionID, ABrowser);
//  ABrowser.ExecuteScript(Script, AExecutionID);
end;

class procedure TWebView4DUtil.GetIFrameElementValue2(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const AIFrameSelector, AElementSelector: string; AExecutionID: Integer);
var
  Script: string;
begin
  Script :=
    '(function() { ' +
    'var iframe = document.getElementById("win_main_subWindow1_iframe"); ' +
    '     iframe.addEventListener("load", function () { ' +
    '       console.log(iframe.contentWindow.document); ' +
//    '     if (iframe.contentWindow && iframe.contentWindow.document) { ' +
//    '     return "FRAME_FOUND"; ' +
    '     }); ' +
//      '   iframe.contentWindow.location.href; ' +
//      '  if (iframe.contentWindow.document) { ' +
//    '  if (iframe.contentWindow && iframe.contentWindow.document) { ' +
//    '     return "FRAME_FOUND"; ' +
//    '    var doc = iframe.contentWindow.document; ' +
//    '    if (doc) return "Doc_FOUND"; ' +
//    '    var element = doc.querySelector("tbx_kcar"); ' +
//    '    if (element) return "Element_FOUND"; ' +
//    '     if (element) return ("value" in element) ? element.value : "Element Not Found"; ' +
//    '  } ' +
    '  return "FRAME_OR_ELEMENT_NOT_FOUND"; ' +
    '})();';

  AFrame.ExecuteScript(Script, AExecutionID, ABrowser);
//  ABrowser.ExecuteScript(Script, AExecutionID);
end;

class procedure TWebView4DUtil.GetMultipleElementValueByIFrameId(
  const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AFrameId: string;
  const aElementIDs: TArray<string>);
var
  i: Integer;
  JsIds, JsCode: string;
begin
  // 1. Delphi 배열을 JS 배열 형태의 문자열로 변환 (예: ["id1", "id2"])
  JsIds := '[';

  for i := Low(aElementIDs) to High(aElementIDs) do
  begin
    JsIds := JsIds + '"' + aElementIDs[i] + '"';

    if i < High(aElementIDs) then
      JsIds := JsIds + ',';
  end;

  JsIds := JsIds + ']';

  // 2. JS 실행 코드 구성: map을 사용하여 각 ID의 innerText를 추출하고 ";"로 join
  JsCode := Format(
    '(function(ids) {' +
    '  return ids.map(id => {' +
    '    var el = document.getElementById(id);' +
    '    return el ? el.value : "";' +
    '  }).join(";");' +
    '})(%s);', [JsIds]);

  ExecuteScriptByIFrameId(AWVBrowser, AFrameId, JsCode, GET_MULTI_VALUE_IN_IFRAME_ID);
end;

class procedure TWebView4DUtil.GetMultipleElementValueOrInnerTextByIDAry(
  const AWVBrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const aElementIDs: TArray<string>);
var
  Script: string;
  IdListJson: string;
  i: integer;
begin
  if Length(aElementIDs) = 0 then Exit;

  // 델파이 배열을 JS 배열 형태의 문자열로 변환 ["id1", "id2"]
  IdListJson := '[';

  for I := Low(aElementIDs) to High(aElementIDs) do
  begin
    IdListJson := IdListJson + QuotedStr(aElementIDs[I]);
    if I < High(aElementIDs) then IdListJson := IdListJson + ',';
  end;
  IdListJson := IdListJson + ']';

  Script := Format(
    '(function(ids) {' +
    '  return ids.map(id => {' +
    '    const el = document.getElementById(id);' +
//    '    return el ? el.innerText.trim() : "";' + // innerText 추출 및 공백 제거
    '    return (el.value !== undefined ? el.value : el.innerText.trim()) || ""; ' +
    '  }).join(";");' +
    '})(%s);',
    [IdListJson]
  );

  AFrame.ExecuteScript(Script, GET_MULTI_VALUE_INNERTEXT_IN_IFRAME_ID, AWVBrowser);
end;

class procedure TWebView4DUtil.GetMultipleElementValuesByIDAry(
  ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame; const AIds: TArray<string>; AExecutionID: Integer);
var
  IdListJson: string;
  I: Integer;
  Script: string;
begin
  if Length(AIds) = 0 then Exit;

  // 델파이 배열을 JS 배열 형태의 문자열로 변환 ["id1", "id2"]
  IdListJson := '[';
  for I := Low(AIds) to High(AIds) do
  begin
    IdListJson := IdListJson + QuotedStr(AIds[I]);
    if I < High(AIds) then IdListJson := IdListJson + ',';
  end;
  IdListJson := IdListJson + ']';

  // 각 ID의 value를 찾아 배열로 만들고 세미콜론(;)으로 join하는 JS 코드
  Script :=
    '(function(ids) { ' +
    '  return ids.map(id => { ' +
    '    const el = document.getElementById(id); ' +
    '    if (!el) return ""; ' +   // 엘리먼트가 없으면 빈 문자열
//    '    return (el.value ? el.value : (el.innerText ? el.innerText.trim() : "")) || ""; ' +
    '    return el ? el.value : "";' +
//    '    return el.value.trim() === "" ? null : el.value;' +
//      '   if (el.tagName === "INPUT" || el.tagName === "TEXTAREA") { ' +
//      '     return el.value || ""; ' +
//      '   } else { ' +
//      '     return el.innerText ? el.innerText.trim() : "";  ' +
//      '   } ' +
//    '     return (el.value !== undefined && el.value !== "" ? el.value : el.innerText.trim()) || ""; ' +
//    '     return el.value || el.innerText.trim() || ""; ' +
    '  }).join(";"); ' +

//      '(function(ids) { ' +
//      '  const values = ids.map(id => { ' +
//      '    const el = document.getElementById(id); ' +
//          // 요소가 없거나 value가 Falsy(빈 값)이면 빈 문자열 반환
//      '    return (el && el.value) ? el.value : ""; ' +
//      '  }); ' +
//
//        // 모든 요소가 빈 문자열인지 확인
//      '  const isEmpty = values.every(val => val === ""); ' +
//
//        // 모두 비어있으면 null, 아니면 세미콜론으로 연결하여 반환
//      '  return isEmpty ? null : values.join(";"); ' +
    '})(' + IdListJson + ');';
//    '})([''ibx_carRgsrNo'', ''ibx_carNm'', ''ica_acapDt_input'', ''ibx_yiwy'', ''ibx_clph'', ''ibx_vdno'', ''ibx_addr'', ''ibx_issForm'']);';

  // 스크립트 실행 (결과는 OnExecuteScriptCompleted 이벤트에서 수신)
  AFrame.ExecuteScript(Script, AExecutionID, ABrowser);
//  ABrowser.ExecuteScript(Script, AExecutionID);
end;

class procedure TWebView4DUtil.HasIFrameById(const AWVBrowser: TWVBrowser;
  const AFrameId: string);
begin
  AWVBrowser.ExecuteScript(
    '(function(){' +
    ' var f=document.getElementById("' + AFrameId + '");' +
    ' return !!(f && f.tagName==="IFRAME");' +
    '})();',HAS_IFRAME_ID
  );
end;

class procedure TWebView4DUtil.SelectDropDownByIndex(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const ASelector: string; AIndex: Integer);
var
  Script: string;
begin
  Script := Format(
    'var el = document.querySelector(%s); ' +
    'if (el && el.tagName === "SELECT" && el.options[%d]) { ' +
    '  el.selectedIndex = %d; ' +
    '  el.dispatchEvent(new Event("change", { bubbles: true })); ' +
    '}',
    [QuotedStr(ASelector), AIndex, AIndex]
  );

  AFrame.ExecuteScript(Script, SELECT_COMBO_EVENT_ID, ABrowser);
//  ABrowser.ExecuteScript(Script, SELECT_COMBO_EVENT_ID);
end;

class procedure TWebView4DUtil.SelectDropDownByValue(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const ASelector, AValue: string);
var
  Script: string;
begin
  // AValue는 <option value="여기">에 해당하는 값입니다.
  Script := Format(
    'var el = document.querySelector(%s); ' +
    'if (el && el.tagName === "SELECT") { ' +
    '  el.value = %s; ' +
    '  el.dispatchEvent(new Event("change", { bubbles: true })); ' +
    '  el.dispatchEvent(new Event("input", { bubbles: true })); ' +
    '}',
    [QuotedStr(ASelector), QuotedStr(AValue)]
  );

  AFrame.ExecuteScript(Script, SELECT_COMBO_EVENT_ID, ABrowser);
//  ABrowser.ExecuteScript(Script, SELECT_COMBO_EVENT_ID);
end;

class procedure TWebView4DUtil.SetDOMelementFromBrowser(const ABrowser: TWVBrowser; const AName, AValue: string;
  const AByID: Boolean);
var
  LScript: string;
begin
  if AByID then
    LScript := Format('document.getElementById("%s").value = "%s";', [AName, AValue])
  else
    LScript := Format('document.querySelector("%s").value = "%s";', [AName, AValue]);

  ABrowser.ExecuteScript(LScript);
end;

class procedure TWebView4DUtil.SetElementValueByClass(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const AClassName, AValue: string; AAllElements: Boolean);
var
  Script: string;
begin
  Script := Format(
    'var els = document.getElementsByClassName(%s); ' +
    'if (els.length > 0) { ' +
    '  var targetEls = %s ? Array.from(els) : [els[0]]; ' +
    '  targetEls.forEach(el => { ' +
    '    if ("value" in el) { el.value = %s; } ' +
    '    else { el.innerText = %s; } ' +
    '    el.dispatchEvent(new Event("input", { bubbles: true })); ' +
    '    el.dispatchEvent(new Event("change", { bubbles: true })); ' +
    '  }); ' +
    '}',
    [QuotedStr(AClassName), BoolToStr(AAllElements, True).ToLower, QuotedStr(AValue), QuotedStr(AValue)]
  );

  AFrame.ExecuteScript(Script, SET_VALUE_ID, ABrowser);
//  ABrowser.ExecuteScript(Script, SET_VALUE_ID);
end;

class procedure TWebView4DUtil.SetElementValueById(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const AId, AValue: string);
var
  Script: string;
begin
  // QuotedStr을 사용하여 문자열 내의 특수 문자나 따옴표를 안전하게 처리합니다.
  Script := Format(
    'var el = document.getElementById(%s); ' +
    'if (el) { ' +
    '  if ("value" in el) { ' +
    '    el.value = %s; ' +
    '  } else { ' +
    '    el.innerText = %s; ' +
    '  } ' +
    '  el.dispatchEvent(new Event("input", { bubbles: true })); ' + // 입력 후 변경 이벤트 강제 발생 (React, Vue 등 연동용)
    '  el.dispatchEvent(new Event("change", { bubbles: true })); ' +
    '}',
    [QuotedStr(AId), QuotedStr(AValue), QuotedStr(AValue)]
  );

  // 스크립트 실행
  AFrame.ExecuteScript(Script, SET_VALUE_ID, ABrowser);
//  ABrowser.ExecuteScript(Script, SET_VALUE_ID);
end;

class procedure TWebView4DUtil.SetElementValueByName(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const AName, AValue: string; AAllElements: Boolean);
var
  Script: string;
begin
  // AAllElements가 True면 해당 name을 가진 모든 요소 변경, False면 첫 번째만 변경
  Script := Format(
    'var els = document.getElementsByName(%s); ' +
    'if (els.length > 0) { ' +
    '  var targetEls = %s ? Array.from(els) : [els[0]]; ' +
    '  targetEls.forEach(el => { ' +
    '    if ("value" in el) { el.value = %s; } ' +
    '    else { el.innerText = %s; } ' +
    '    el.dispatchEvent(new Event("input", { bubbles: true })); ' +
    '    el.dispatchEvent(new Event("change", { bubbles: true })); ' +
    '  }); ' +
    '}',
    [QuotedStr(AName), BoolToStr(AAllElements, True).ToLower, QuotedStr(AValue), QuotedStr(AValue)]
  );

  AFrame.ExecuteScript(Script, SET_VALUE_ID, ABrowser);
//  ABrowser.ExecuteScript(Script, SET_VALUE_ID);
end;

class procedure TWebView4DUtil.SetElementValueBySelector(ABrowser: TWVBrowser; AFrame: TCoreWebView2Frame;
  const ASelector, AValue: string);
var
  Script: string;
begin
  // ASelector 예시: '.my-class', '[name="user_email"]', 'div > p.title'
  Script := Format(
    'var el = document.querySelector(%s); ' +
    'if (el) { ' +
    '  if ("value" in el) { el.value = %s; } ' +
    '  else { el.innerText = %s; } ' +
    '  el.dispatchEvent(new Event("input", { bubbles: true })); ' +
    '  el.dispatchEvent(new Event("change", { bubbles: true })); ' +
    '}',
    [QuotedStr(ASelector), QuotedStr(AValue), QuotedStr(AValue)]
  );

  AFrame.ExecuteScript(Script, SET_VALUE_ID, ABrowser);
//  ABrowser.ExecuteScript(Script, SET_VALUE_ID);
end;

class procedure TWebView4DUtil.SetElementValueFromIFrameList(
  ABrowser: TWVBrowser; AFrameList: TObjectList<TCoreWebView2Frame>;
  const AElementSelector, AValue: string);
var
  i: integer;
begin
  for i := 0 to AFrameList.Count - 1 do
  begin
    TWebView4DUtil.SetElementValueById(ABrowser, AFrameList[i], AElementSelector, AValue);
  end;
end;

class procedure TWebView4DUtil.SetIFrameElementValue(ABrowser: TWVBrowser;
  const AIFrameSelector, AElementSelector, AValue: string);
var
  Script: string;
begin
  // JavaScript returns "ok", "element_not_found", or "frame_not_found"
//  Script := Format(
//    '(function() {' +
//    '  var frame = document.querySelector(%s); ' +
////    '  var frame = document.getElementById(%s); ' +
//    '  if (frame && (frame.contentDocument || frame.contentWindow.document)) { ' +
//    '    var doc = frame.contentDocument || frame.contentWindow.document; ' +
//    '    var el = doc.querySelector(%s); ' +
//    '    if (el) { ' +
//    '      if ("value" in el) { el.value = %s; } ' +
//    '      else { el.innerText = %s; } ' +
//    '      el.dispatchEvent(new Event("input", { bubbles: true })); ' +
//    '      el.dispatchEvent(new Event("change", { bubbles: true })); ' +
//    '      return "' + RET_SET_OK + '";' +
//    '    } else { return "' + RET_SET_ELEMENT_NOT_FOUND + '"; }' +
//    '  } else { return "' + RET_SET_FRAME_NOT_FOUND + '"; }' +
//    '})()',
//    [QuotedStr(AIFrameSelector), QuotedStr(AElementSelector), QuotedStr(AValue), QuotedStr(AValue)]
//  );

  Script := Format(
    '(function() {' +
    '  var iframes = document.querySelectorAll("iframe"); ' +
//    '    return iframes.length;                          ' +
    '    for (let i = 0; i < iframes.length; i++) {      ' +
    '        const frame = iframes[i];                  ' +
    '        try {                                       ' +
//    '           if (frame && (frame.contentDocument || frame.contentWindow.document)) {  ' +
    '           if (frame.id === %s) {  ' +
    '             try {                                       ' +
    '               var doc = frame.contentDocument || frame.contentWindow.document;       ' +
//    '               return frame.id;                                   ' +
    '               var el = doc.querySelector(%s); ' +
    '                 if (el) { ' +
    '                   if ("value" in el) { el.value = %s; } ' +
    '                   else { el.innerText = %s; } ' +

//    '                 el.dispatchEvent(new Event("input", { bubbles: true })); ' +
//    '                 el.dispatchEvent(new Event("change", { bubbles: true })); ' +
    '                   return "' + RET_SET_OK + '";' +
    '                 } else { return "' + RET_SET_ELEMENT_NOT_FOUND + '"; }' +
    '             } catch (e) {                               ' +
    '               console.warn(`iframe ${i} 접근 불가 (CORS 제한):`, e.message); ' +
    '             }                                                                  ' +
    '           } ' +
//    '           else { return "' + RET_SET_FRAME_NOT_FOUND + '"; }' +

    '        } catch (e) {                               ' +
//    '            console.warn(`iframe ${i} 접근 불가 (CORS 제한):`, e.message); ' +
//    '            iframeResults.push({                                           ' +
//    '                documentName: `iframe_${i + 1}`,                           ' +
//    '                error: "CORS 제한으로 접근 불가",                          ' +
//    '                isIframe: true                                             ' +
//    '            });                                                            ' +
    '        }                                                                  ' +
    '    }                                                                      ' +

    '})()',
    [QuotedStr(AIFrameSelector), QuotedStr(AElementSelector), QuotedStr(AValue), QuotedStr(AValue)]
  );

  ABrowser.ExecuteScript(Script, SET_VALUE_ID);
end;

class procedure TWebView4DUtil.SyncFrameNameNId(const AWVBrowser: TWVBrowser);
var
  JsCode: string;
begin
  // id는 있지만 name이 없는 iframe을 찾아 name에 id를 할당
  JsCode := 'document.querySelectorAll("iframe").forEach(f => { ' +
            '  if(!f.name && f.id) f.name = f.id; ' +
            '});';

  AWVBrowser.ExecuteScript(JsCode, SYNC_IFRAME_NAMENID_ID);
end;

end.
