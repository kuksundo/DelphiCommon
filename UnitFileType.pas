unit UnitFileType;

interface

uses ActiveX, ShlObj, Registry;

type
  TOfficeFileType = (oftExcel, oftWord, oftPpt, oftPdf, oftSqlite,
    oftJson, oftXml, oftCsv);

const
  ASSOCF_NONE                = $00000000;  // �⺻ �ɼ� (Ư���� ���� ����)
  ASSOCF_INIT_NOREMAPCLSID    = $00000001;  // CLSID ���� ����
  ASSOCF_INIT_BYEXENAME       = $00000002;  // ���� ���� �̸��� �������� �ʱ�ȭ
  ASSOCF_OPEN_BYEXENAME       = $00000004;  // ���� ���� �̸����� ����� ������ �˻�
  ASSOCF_INIT_DEFAULTTOSTAR   = $00000008;  // '*' �⺻ ���� ���
  ASSOCF_INIT_DEFAULTTOFOLDER = $00000010;  // ���� �⺻ ���� ���
  ASSOCF_NOUSERSETTINGS       = $00000020;  // ����� ���� ����
  ASSOCF_NOTRUNCATE           = $00000040;  // �߸��� ���� ��ü ���ڿ� ��ȯ
  ASSOCF_VERIFY               = $00000080;  // ����� ��ȿ���� Ȯ��
  ASSOCF_REMAPRUNDLL          = $00000200;  // rundll32.exe�� ���� ���� ���Ϸ� ����
  ASSOCF_NOFIXUPS             = $00000400;  // �ڵ� ���� ����
  ASSOCF_IGNOREBASECLASS      = $00000800;  // �⺻ Ŭ���� ����
  ASSOCF_INIT_IGNOREUNKNOWN   = $00001000;  // �˷����� ���� ���� ���� ����

  ASSOCSTR_COMMAND         = 1;  // ��ɾ� ���ڿ� (��: "open" �Ǵ� "print" ����)
  ASSOCSTR_EXECUTABLE      = 2;  // �⺻ ���� ����(EXE) ���
  ASSOCSTR_FRIENDLYDOCNAME = 3;  // ������ ģ���� �̸�
  ASSOCSTR_FRIENDLYAPPNAME = 4;  // ����� ���� ģ���� �̸�
  ASSOCSTR_NOOPEN          = 5;  // ������ ������ �ʴ� ����
  ASSOCSTR_SHELLNEWVALUE   = 6;  // ShellNew ��
  ASSOCSTR_DDECOMMAND      = 7;  // DDE ���
  ASSOCSTR_DDEIFEXEC       = 8;  // DDE ���� ����
  ASSOCSTR_DDEAPPLICATION  = 9;  // DDE ���ø����̼� �̸�
  ASSOCSTR_DDETOPIC        = 10; // DDE ����
  ASSOCSTR_INFOTIP         = 11; // ���� ����
  ASSOCSTR_QUICKTIP        = 12; // ���� ����
  ASSOCSTR_TILEINFO        = 13; // Ÿ�� ���� ����
  ASSOCSTR_CONTENTTYPE     = 14; // MIME ����
  ASSOCSTR_DEFAULTICON     = 15; // �⺻ ������ ���
  ASSOCSTR_SHELLEXTENSION  = 16; // �� Ȯ��
  ASSOCSTR_DROPTARGET      = 17; // ��� ��� CLSID
  ASSOCSTR_DELEGATEEXECUTE = 18; // DelegateExecute CLSID

function AssocQueryString(flags,str: DWORD;
                 pszAssoc, pszExtra: PChar;
                             pszOut: PChar;
                            pcchOut: PDWORD): HRESULT; stdcall;
                             external 'shlwapi.dll' name 'AssocQueryStringW';

{
  Label1.Caption := GetAssociatedProgram( Button2.Caption );
  Label2.Caption := GetExecutableForExtension( Button3.Caption );
}
function GetAssociatedProgram(const Ext: string): string;
function GetExecutableForExtension(const Ext: string): string;

implementation

function GetAssociatedProgram(const Ext: string): string;
var
  BufSize: DWORD;
  Buffer: array[0..MAX_PATH] of Char;
begin
  Result := '';
  BufSize := MAX_PATH;

  if AssocQueryString(ASSOCF_NONE, ASSOCSTR_EXECUTABLE, PChar(Ext), nil, Buffer, @BufSize) = S_OK then
    Result := Buffer;
end;

function GetExecutableForExtension(const Ext: string): string;
var
  Reg: TRegistry;
  FileType, Command: string;
begin
  Result := '';

  // ������Ʈ������ ���� Ȯ���ڿ� ����� ���� ���� ã��
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if Reg.OpenKeyReadOnly(Ext) then
    begin
      if Reg.ValueExists('') then
        FileType := Reg.ReadString('');
      Reg.CloseKey;
    end;

    if FileType = '' then Exit;

    // �ش� ���� ���Ŀ��� ���� ���� ��ȸ
    if Reg.OpenKeyReadOnly(FileType + '\shell\open\command') then
    begin
      if Reg.ValueExists('') then
      begin
        Command := Reg.ReadString('');
        Result := Command;

        // ���� ���� ��� ����
        if (Length(Command) > 0) and (Command[1] = '"') then
          Result := Copy(Command, 2, Pos('"', Command, 2) - 2);
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

end.
