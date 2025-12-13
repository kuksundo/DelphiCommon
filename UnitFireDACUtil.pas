unit UnitFireDACUtil;

interface

uses Windows, SysUtils, DateUtils, Dialogs, DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.IB,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client,  //MemDS, DBAccess,
  FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.IBBase, FireDAC.Comp.DataSet;

type
  TFDACUtil = class
    class function OpenQuery(mQry: TFDQuery; mSQL, DispMsg: String): Integer; static;
    class function ExecQuery(mQry: TFDQuery; mSQL, DispMsg: String): Boolean; static;
    class function ExecQueryEx(mQry: TFDQuery; mSQL, DispMsg: String; var AError: String): Boolean; static;
  end;

implementation

uses UnitLogUtil;

function Make_DelSpecialChar(SrcSQL: String): String;
begin
  Result := StringReplace(SrcSQL, #$0D + #$0A, ' ', [rfReplaceAll, rfIgnoreCase]);
end;

{ TFDACUtil }

class function TFDACUtil.ExecQuery(mQry: TFDQuery; mSQL,
  DispMsg: String): Boolean;
begin
  Result := True;

  try
    with mQry do begin
      Close;
      Active := False;
      SQL.Clear;
      SQL.Text := mSQL;
      Execute;
    end;
  except
    on E: Exception do begin
      Result := False;
      File_AddLog(Format('[%s] 실패   SQL [%s]   EXCEPTION [%s]', [DispMsg, mSQL, Trim(E.Message)]), False);

//      if (GH_MainFrm > 0) then begin
//        if (Pos('Access violation', Trim(E.Message)) < 0) or (Pos('OLE DB error occured', Trim(E.Message)) < 0) or
//           (Pos('TCP 공급자: 현재 연결은 원격 호스트에 의해 강제로 끊겼습니다', Trim(E.Message)) < 0) then SendMessage(GH_MainFrm, WM_EXCEPTION_RESTART, 0, 0);
//      end;
    end;
  end;
end;

class function TFDACUtil.ExecQueryEx(mQry: TFDQuery; mSQL, DispMsg: String;
  var AError: String): Boolean;
begin
  Result := True;

  try
    with mQry do begin
      Close;
      Active := False;
      SQL.Clear;
      SQL.Text := mSQL;
      Execute;
    end;
  except
    on E: Exception do begin
      Result := False;
      AError := Trim(E.Message);
      File_AddLog(Format('[%s] 실패   SQL [%s]   EXCEPTION [%s]', [DispMsg, mSQL, Trim(E.Message)]), False);

//      if (GH_MainFrm > 0) then begin
//        if (Pos('Access violation', Trim(E.Message)) < 0) or (Pos('OLE DB error occured', Trim(E.Message)) < 0) or
//           (Pos('TCP 공급자: 현재 연결은 원격 호스트에 의해 강제로 끊겼습니다', Trim(E.Message)) < 0) then SendMessage(GH_MainFrm, WM_EXCEPTION_RESTART, 0, 0);
//      end;
    end;
  end;
end;

class function TFDACUtil.OpenQuery(mQry: TFDQuery; mSQL,
  DispMsg: String): Integer;
var
  ls_mSQL: String;
begin
  Result := -1;
  ls_mSQL := Make_DelSpecialChar(mSQL);

  try
    with mQry do begin
      Close;
      Active := False;
      SQL.Clear;
      SQL.Text := ls_mSQL;
      Open;

      Result := RecordCount;

      if (Result > 0) then First;
    end;
  except
    on E: Exception do begin
      File_AddLog(Format('[%s] 실패   SQL [%s]   EXCEPTION [%s]', [DispMsg, mSQL, Trim(E.Message)]), False);

//      if (GH_MainFrm > 0) then begin
//        if (Pos('Access violation', Trim(E.Message)) < 0) or (Pos('OLE DB error occured', Trim(E.Message)) < 0) or
//           (Pos('TCP 공급자: 현재 연결은 원격 호스트에 의해 강제로 끊겼습니다', Trim(E.Message)) < 0) then SendMessage(GH_MainFrm, WM_EXCEPTION_RESTART, 0, 0);
//      end;
    end;
  end;
end;

end.
