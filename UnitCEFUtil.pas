unit UnitCEFUtil;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Forms,
  uCEFChromium, uCEFInterfaces, uCEFConstants, uCefProcessMessage, uCefTypes;

const
  MINIBROWSER_VISITDOM_PARTIAL            = WM_APP + $101;
  MINIBROWSER_VISITDOM_FULL               = WM_APP + $102;
  MINIBROWSER_COPYFRAMEIDS_1              = WM_APP + $103;
  MINIBROWSER_COPYFRAMEIDS_2              = WM_APP + $104;
  MINIBROWSER_SHOWMESSAGE                 = WM_APP + $105;
  MINIBROWSER_SHOWSTATUSTEXT              = WM_APP + $106;
  MINIBROWSER_VISITDOM_JS                 = WM_APP + $107;
  MINIBROWSER_SHOWERROR                   = WM_APP + $108;
  MINIBROWSER_RECEIVEDCONSOLEMSG          = WM_APP + $109;

  MINIBROWSER_CONTEXTMENU_VISITDOM_PARTIAL = MENU_ID_USER_FIRST + 1;
  MINIBROWSER_CONTEXTMENU_VISITDOM_FULL    = MENU_ID_USER_FIRST + 2;
  MINIBROWSER_CONTEXTMENU_COPYFRAMEIDS_1   = MENU_ID_USER_FIRST + 3;
  MINIBROWSER_CONTEXTMENU_COPYFRAMEIDS_2   = MENU_ID_USER_FIRST + 4;
  MINIBROWSER_CONTEXTMENU_VISITDOM_JS      = MENU_ID_USER_FIRST + 5;
  MINIBROWSER_CONTEXTMENU_SETINPUTVALUE_JS = MENU_ID_USER_FIRST + 6;
  MINIBROWSER_CONTEXTMENU_SETINPUTVALUE_DT = MENU_ID_USER_FIRST + 7;
  MINIBROWSER_CONTEXTMENU_SHOWDEVTOOLS     = MENU_ID_USER_FIRST + 8;

  DOMVISITOR_MSGNAME_PARTIAL  = 'domvisitorpartial';
  DOMVISITOR_MSGNAME_FULL     = 'domvisitorfull';
  RETRIEVEDOM_MSGNAME_PARTIAL = 'retrievedompartial';
  RETRIEVEDOM_MSGNAME_FULL    = 'retrievedomfull';
  FRAMEIDS_MSGNAME            = 'getframeids';
  CONSOLE_MSG_PREAMBLE        = 'DOMVISITOR';
  FILLUSERNAME_MSGNAME        = 'fillusername';

  NODE_ID = 'keywords';
  GET_VALUE_PREAMBLE = 'GETVALUE:';
  GET_MULTIPLE_VALUES_PREAMBLE = 'GETMULTIPLEVALUES:';
  GET_MULTIPLE_INNERTEXT_PREAMBLE = 'GETMULTIPLEINNERTEXT:';
  BUTTON_CLICK_EVENT_PREAMBLE = 'CLICK_EVENT:';

  GET_ELEMENT_VALUE_MSG = 'getelementvalue';
  GOT_ELEMENT_VALUE_MSG = 'gotelementvalue';
type
  TCefUtil = class
    class var FSyncResult   : string;
    class var FSyncReceived : boolean;

    class function GetMainFrameFromChromium(const AChromium: TChromium): ICefFrame; static;

    //value 속성의 직접 변경
    class procedure SetElementValueByID(const aFrame: ICefFrame; const aElementID, aValue: string); static;
    //value 속성의 직접 변경을 감지하지 못하는 경우 Native Value Setter 구현함
    class procedure SetElementNativeValueByID(const aFrame: ICefFrame; const aElementID, aValue: string);static;
    class procedure SetElementValueByClassName(const aFrame: ICefFrame; const aClassName, aValue: string); static;

    //CEF(Chromium Embedded Framework)는 브라우저 프로세스와 렌더러 프로세스가 분리되어 있어 기본적으로 비동기(Asynchronous) 통신을 합니다.
    //CEF의 비동기 특성상 console.log를 이용해 값을 요청하고, Chromium1ConsoleMessage 이벤트에서 결과를 받아 클립보드에 복사하고 상태 표시줄에 표시하도록 구현했습니다.
    //GETVALUE: 프리앰블을 사용하여 메시지를 식별합니다.
    class procedure GetElementValueByID(const aFrame: ICefFrame; const aElementID: string); static;
    //ConsoleMessage를 사용하지 않고, 프로세스 간 메시지(IPC)와 V8 Context를 사용하여 값을 가져오도록 처리
    //브라우저 프로세스에서 렌더 프로세스로 값 요청 메시지를 보내고, 응답이 올 때까지 메시지 루프를 돌며 대기함 (타임아웃 2초)
    //렌더 프로세스 핸들러: GlobalCEFApp_OnProcessMessageReceived에서 요청을 받아 V8Context를 통해 document.getElementById(id).value를 실행하고 결과를 반환합니다.
    //브라우저 프로세스 핸들러: Chromium1ProcessMessageReceived에서 응답을 받아 대기 중인 함수에 값을 전달합니다.
    class function  GetElementValueByIDSync(const aFrame: ICefFrame; const aElementID: string): string; static;
    //입력받은 ID 목록(aElementIDs)을 JavaScript 배열로 변환
    //JavaScript 내에서 해당 ID들을 순회하며 element.value를 가져와 ;로 연결
    //console.log를 사용하여 GETMULTIPLEVALUES: 프리앰블과 함께 인코딩된 결과 문자열을 출력하는 스크립트를 실행
    class procedure GetElementValuesByIDAry(const aFrame: ICefFrame; const aElementIDs: array of string); static;
    //입력받은 ID 목록(aElementIDs)을 JavaScript 배열로 변환
    //JavaScript 내에서 해당 ID들을 순회하며 element.innerText를 가져와 ;로 연결
    //console.log를 사용하여 GETMULTIPLEVALUES: 프리앰블과 함께 인코딩된 결과 문자열을 출력하는 스크립트를 실행
    class procedure GetElementInnerTextByIDAry(const aFrame: ICefFrame; const aElementIDs: array of string); static;

    class procedure ClickButtonByID(const aFrame: ICefFrame; const aElementID: string); static;
    class procedure ClickButtonByText(const aFrame: ICefFrame; const aButtonText: string); static;
    // 웹 페이지의 DOM(문서 객체 모델)이 완전히 로드된 직후에 실행되어야 함(TChromium.OnLoadEnd)
    //ICefFrame과 Button Text를 인자로 받아, 해당 텍스트를 가진 버튼(또는 input 버튼)에 클릭 이벤트를 심어주는 자바스크립트를 실행
    //"CLICK_EVENT:" 접두어 붙임 - Chromium1ConsoleMessage 함수에서 받음
    class procedure AddBtnClickEventWithConsoleLogByText(const aFrame: ICefFrame; const aButtonText: string); static;
  end;

implementation

{ TCefUtil }

class procedure TCefUtil.AddBtnClickEventWithConsoleLogByText(
  const aFrame: ICefFrame; const aButtonText: string);
var
  TempJSCode: string;
begin
  // 프레임이 유효하지 않으면 종료
  if (aFrame = nil) or (not aFrame.IsValid) then Exit;

  // 자바스크립트 생성
  // QuotedStr을 사용하여 델파이 문자열을 자바스크립트 문자열 리터럴로 안전하게 변환합니다.
  TempJSCode :=
    'var targetText = ' + QuotedStr(aButtonText) + ';' +
    'function addLog(element) {' +
    '    element.addEventListener("click", function() {' +
    '        console.log("CLICK_EVENT:" + targetText);' +
    '    });' +
    '}' +
    // 1. <button> 태그 검색
    'var buttons = document.getElementsByTagName("button");' +
    'for (var i = 0; i < buttons.length; i++) {' +
    '    if (buttons[i].innerText.trim() === targetText) {' +
    '        addLog(buttons[i]);' +
    '    }' +
    '}' +
    // 2. <input type="button|submit|reset"> 태그 검색
    'var inputs = document.getElementsByTagName("input");' +
    'for (var i = 0; i < inputs.length; i++) {' +
    '    if (["button", "submit", "reset"].includes(inputs[i].type) && inputs[i].value === targetText) {' +
    '        addLog(inputs[i]);' +
    '    }' +
    '}';

  // 생성된 자바스크립트를 해당 프레임에서 실행
  aFrame.ExecuteJavaScript(TempJSCode, 'about:blank', 0);
end;

class procedure TCefUtil.ClickButtonByID(const aFrame: ICefFrame;
  const aElementID: string);
var
  TempJSCode: string;
begin
  if (aFrame <> nil) and aFrame.IsValid then
  begin
    TempJSCode := 'var btn = document.getElementById("' + aElementID + '"); if (btn) btn.click();';
    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
  end;
end;

class procedure TCefUtil.ClickButtonByText(const aFrame: ICefFrame;
  const aButtonText: string);
var
  TempJSCode: string;
begin
  if (aFrame <> nil) and aFrame.IsValid then
  begin
    TempJSCode :=
      'var buttons = document.getElementsByTagName("button");' +
      'for (var i = 0; i < buttons.length; i++) {' +
      '  if (buttons[i].innerText.trim() === "' + aButtonText + '") {' +
      '    buttons[i].click();' +
      '    break;' +
      '  }' +
      '}';
    // input type="button"이나 "submit"도 찾아야 한다면 추가 로직 필요
    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
  end;
end;

class procedure TCefUtil.GetElementInnerTextByIDAry(const aFrame: ICefFrame;
  const aElementIDs: array of string);
var
  TempJSCode, TempIDs: string;
  i: Integer;
  TimeOut: Cardinal;
begin
  FSyncReceived := False;
  FSyncResult := '';

  if (aFrame <> nil) and aFrame.IsValid and (Length(aElementIDs) > 0) then
  begin
    TempIDs := '';
    for i := Low(aElementIDs) to High(aElementIDs) do
    begin
      if i > Low(aElementIDs) then TempIDs := TempIDs + ',';
      TempIDs := TempIDs + '"' + aElementIDs[i] + '"';
    end;

    TempJSCode :=
      'var ids = [' + TempIDs + '];' +
      'var result = "";' +
      'for (var i = 0; i < ids.length; i++) {' +
      '  var el = document.getElementById(ids[i]);' +
      '  if (i > 0) result += ";";' +
      '  if (el) result += el.innerText;' +
      '}' +
      'console.log("' + GET_MULTIPLE_INNERTEXT_PREAMBLE + ';' + TempIDs + ';' + '" + encodeURIComponent(result));';

    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
  end;
end;

class procedure TCefUtil.GetElementValueByID(const aFrame: ICefFrame;
  const aElementID: string);
var
  TempJSCode: string;
begin
  if (aFrame <> nil) and aFrame.IsValid then
  begin
    // Use encodeURIComponent to handle special characters safely
    TempJSCode := 'console.log("' + GET_VALUE_PREAMBLE + ';' + aElementID + ';' + '" + encodeURIComponent(document.getElementById("' + aElementID + '").value));';
    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
  end;
end;

class function TCefUtil.GetElementValueByIDSync(const aFrame: ICefFrame;
  const aElementID: string): string;
var
  Msg: ICefProcessMessage;
  TimeOut: Cardinal;
begin
  Result := '';
  FSyncReceived := False;
  FSyncResult := '';

  if (aFrame <> nil) and aFrame.IsValid then
  begin
    Msg := TCefProcessMessageRef.New(GET_ELEMENT_VALUE_MSG);
    Msg.ArgumentList.SetString(0, aElementID);
    aFrame.SendProcessMessage(PID_RENDERER, Msg);

    TimeOut := GetTickCount + 2000; // 2 seconds timeout

    while not FSyncReceived and (GetTickCount < TimeOut) do
    begin
      Application.ProcessMessages;
      Sleep(10);
    end;

    if FSyncReceived then
      Result := FSyncResult;
  end;
end;

class procedure TCefUtil.GetElementValuesByIDAry(const aFrame: ICefFrame;
  const aElementIDs: array of string);
var
  TempJSCode, TempIDs: string;
  i: Integer;
begin
  if (aFrame <> nil) and aFrame.IsValid and (Length(aElementIDs) > 0) then
  begin
    TempIDs := '';
    for i := Low(aElementIDs) to High(aElementIDs) do
    begin
      if i > Low(aElementIDs) then TempIDs := TempIDs + ',';
      TempIDs := TempIDs + '"' + aElementIDs[i] + '"';
    end;

    TempJSCode :=
      'var ids = [' + TempIDs + '];' +
      'var result = "";' +
      'for (var i = 0; i < ids.length; i++) {' +
      '  var el = document.getElementById(ids[i]);' +
      '  if (i > 0) result += ";";' +
      '  if (el) result += el.value;' +
      '}' +
      'console.log("' + GET_MULTIPLE_VALUES_PREAMBLE + ';' + TempIDs + ';' + '" + encodeURIComponent(result));';

    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
  end;
end;

class function TCefUtil.GetMainFrameFromChromium(
  const AChromium: TChromium): ICefFrame;
begin
  Result := nil;
  if (AChromium <> nil) and (AChromium.Browser <> nil) then
    Result := AChromium.Browser.MainFrame;
end;

class procedure TCefUtil.SetElementNativeValueByID(const aFrame: ICefFrame;
  const aElementID, aValue: string);
var
  TempJSCode: string;
begin
  if (aFrame <> nil) and aFrame.IsValid then
  begin
    TempJSCode :=
      'var el = document.getElementById("' + aElementID + '");' +
      'if (el) {' +
      '  var nativeInputValueSetter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, "value").set;' +
      '  nativeInputValueSetter.call(el, "' + aValue + '");' +
      '  el.dispatchEvent(new Event("input", { bubbles: true }));' +
      '  el.dispatchEvent(new Event("change", { bubbles: true }));' +
      '}';
    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
  end;
end;

class procedure TCefUtil.SetElementValueByClassName(const aFrame: ICefFrame;
  const aClassName, aValue: string);
var
  TempJSCode: string;
begin
  if (aFrame <> nil) and aFrame.IsValid then
  begin
    TempJSCode :=
      'var els = document.getElementsByClassName("' + aClassName + '");' +
      'if (els.length > 0) {' +
      '  var el = els[0];' +
      '  var nativeInputValueSetter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, "value").set;' +
      '  if (nativeInputValueSetter) {' +
      '    nativeInputValueSetter.call(el, "' + aValue + '");' +
      '  } else {' +
      '    el.value = "' + aValue + '";' +
      '  }' +
//프로그램이 값을 넣었지만, 마치 사람이 직접 키보드로 입력한 것처럼 웹 페이지를 완벽하게 속이기 위한 마무리 작업
//사람이 키보드로 입력하면 브라우저는 자동으로 input이나 change 이벤트를 발생시킵니다.
//웹 페이지의 자바스크립트는 이 이벤트를 감지하여 "아, 사용자가 값을 바꿨구나!"라고 인식하고 내부 데이터를 업데이트합니다.
//하지만 코드로 값을 강제 변경(element.value = "abc")할 때는 브라우저가 이벤트를 자동으로 발생시키지 않습니다.
//그 결과, 화면에는 글자가 채워진 것처럼 보이지만, 실제 웹 사이트 내부(React State 등)에서는 값이 비어있는 것으로 인식하여
//로그인 버튼을 눌러도 반응이 없거나 "값을 입력하세요"라는 에러가 뜨는 문제가 발생합니다.
//이를 해결하기 위해 "이벤트가 발생했다"고 **강제로 신호를 보내주는 것(Dispatch)**입니다.
      '  el.dispatchEvent(new Event("input", { bubbles: true }));' +
      '  el.dispatchEvent(new Event("change", { bubbles: true }));' +
      '}';
    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
  end;
end;

class procedure TCefUtil.SetElementValueByID(const aFrame: ICefFrame;
  const aElementID, aValue: string);
var
  TempJSCode: string;
begin
  if (aFrame <> nil) and aFrame.IsValid then
  begin
    TempJSCode :=
      'var el = document.getElementById("' + aElementID + '");' +
      'if (el) {' +
      '  el.value = "' + aValue + '";' +
      '  el.dispatchEvent(new Event("input", { bubbles: true }));' +
      '  el.dispatchEvent(new Event("change", { bubbles: true }));' +
      '}';
    aFrame.ExecuteJavaScript(TempJSCode, aFrame.Url, 0);
  end;
end;

end.
