unit UnitSystemUtil2;

interface

uses Windows, SysUtils, Winapi.ShellAPI, Vcl.Forms, Vcl.Dialogs;

// ��ǻ�� �̸��� �����ϴ� �Լ�
// NewHostName: ������ �� ��ǻ�� �̸� (DNS ȣ��Ʈ �̸� ���� ����)
// ��ȯ��: ���� �� True, ���� �� False
function ChangeComputerName(const NewHostName: string): Boolean;
// ��� 1: Windows ���� ���� '����' ������ ���� (�ֽ� ���)
procedure OpenSettings_ComputerName_Modern;
// ��� 2: �ý��� �Ӽ��� '��ǻ�� �̸�' �� ���� (Ŭ���� ���)
procedure OpenSettings_ComputerName_Classic;

implementation

// ��ǻ�� �̸��� �����ϴ� �Լ� ����
function ChangeComputerName(const NewHostName: string): Boolean;
var
  NameType: COMPUTER_NAME_FORMAT;
  PNewName: PWideChar; // SetComputerNameEx�� �����ڵ� ���ڿ��� �䱸��
  Success: Boolean;
begin
  Result := False; // �⺻������ ���з� �ʱ�ȭ

  // ��ȿ�� �̸����� �⺻���� �˻� (�� ������ �˻簡 �ʿ��� �� ����)
  if Trim(NewHostName) = '' then
  begin
    // Log or raise an exception for invalid input
    Exit;
  end;

  // ������ �̸� Ÿ�� ����:
  // ComputerNamePhysicalDnsHostname: �������� DNS ȣ��Ʈ �̸�. ����� �ʿ�. �Ϲ������� �� ���� ���.
  // ComputerNamePhysicalNetBIOS: �������� NetBIOS �̸�. ����� �ʿ�.
  // ComputerNameDnsHostname: ���� ������ DNS ȣ��Ʈ �̸�. ����� �� ������� ���ư� �� ����.
  // ... �ٸ� COMPUTER_NAME_FORMAT ���鵵 ���� ...
  NameType := ComputerNamePhysicalDnsHostname;

  // Delphi string�� PWideChar (�����ڵ� ������)�� ��ȯ
  PNewName := PWideChar(NewHostName);

  // SetComputerNameExW �Լ� ȣ�� (W�� Wide/Unicode ���� ���)
  // Kernel32.dll �� ���ǵǾ� ������ Winapi.Windows ���ֿ� �����
//  Success := SetComputerNameEx(NameType, PNewName);

  if Success then
  begin
    Result := True;
    // ���� �޽��� �Ǵ� �α� ��� (����� �ʿ����� �˸�)
    // ��: ShowMessage('��ǻ�� �̸� ���� ��û�� �����߽��ϴ�. ���� ������ �����Ϸ��� ��ǻ�͸� ������ؾ� �մϴ�.');
  end
  else
  begin
    // ���� �� ���� �ڵ� Ȯ�� �� �޽��� ǥ��
    // ��: ShowMessage('��ǻ�� �̸� ���� ����: ' + SysErrorMessage(GetLastError));
    Result := False;
  end;
end;

// ��� 1: Windows ���� ���� '����' ������ ����
procedure OpenSettings_ComputerName_Modern;
var
  ErrorCode: NativeUInt; // ShellExecute ��ȯ�� Ÿ��
begin
  ErrorCode := ShellExecute(Application.Handle, // �θ� ������ �ڵ�
                            'open',             // ���� ����
                            'ms-settings:about',// ������ URI
                            nil,                // �Ķ���� ����
                            nil,                // �۾� ���丮 ����
                            SW_SHOWNORMAL);     // â ǥ�� ���

  // ShellExecute ���� ������ 32���� ū ��
  if ErrorCode <= 32 then
  begin
    // ���� ó�� (���� �ڵ�� ShellExecute ��ü ��ȯ������ �ؼ�)
    ShowMessage('����(����) â�� ���� �� �����߽��ϴ�. ���� �ڵ�: ' + IntToStr(ErrorCode));
  end;
end;

// ��� 2: �ý��� �Ӽ��� '��ǻ�� �̸�' �� ����
procedure OpenSettings_ComputerName_Classic;
var
  ErrorCode: NativeUInt;
begin
  // �ɼ� A: ���� ���� ���� ��� (�� ������)
  ErrorCode := ShellExecute(Application.Handle, 'open', 'SystemPropertiesComputerName.exe', nil, nil, SW_SHOWNORMAL);

  // �ɼ� B: ������ ���ø� ��� (������ ���)
  // ErrorCode := ShellExecute(Application.Handle, 'open', 'sysdm.cpl', nil, nil, SW_SHOWNORMAL);
  // ���� sysdm.cpl ��� �� '��ǻ�� �̸�' ���� �ƴ� �⺻ ���� ���� �� ����

  if ErrorCode <= 32 then
  begin
    ShowMessage('�ý��� �Ӽ�(��ǻ�� �̸�) â�� ���� �� �����߽��ϴ�. ���� �ڵ�: ' + IntToStr(ErrorCode));
  end;
end;

end.
