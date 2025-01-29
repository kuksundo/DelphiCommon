object LogInWithIPAddrF: TLogInWithIPAddrF
  Left = 0
  Top = 0
  Caption = 'LogInWithIPAddrF'
  ClientHeight = 147
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label14: TLabel
    Left = 51
    Top = 11
    Width = 66
    Height = 16
    Caption = 'IP Address:'
    ParentShowHint = False
    ShowHint = False
  end
  object Label15: TLabel
    Left = 59
    Top = 38
    Width = 58
    Height = 16
    Caption = 'Port Num:'
    ParentShowHint = False
    ShowHint = False
  end
  object DBNameLabel: TLabel
    Left = 18
    Top = 68
    Width = 99
    Height = 16
    Caption = 'DataBase Name: '
    ParentShowHint = False
    ShowHint = False
  end
  object JvIPAddress1: TJvIPAddress
    Left = 124
    Top = 11
    Width = 150
    Height = 24
    Address = 0
    ParentColor = False
    TabOrder = 0
  end
  object PortNumEdit: TEdit
    Left = 124
    Top = 38
    Width = 150
    Height = 24
    Alignment = taCenter
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    TabOrder = 1
    Text = '0'
  end
  object Panel2: TPanel
    Left = 0
    Top = 96
    Width = 301
    Height = 51
    Align = alBottom
    Color = clGray
    TabOrder = 2
    ExplicitTop = 112
    object Panel8: TPanel
      Left = 120
      Top = 1
      Width = 180
      Height = 49
      Align = alRight
      TabOrder = 0
      ExplicitHeight = 53
      object Panel9: TPanel
        Left = 123
        Top = 1
        Width = 56
        Height = 47
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitHeight = 46
        object BitBtn1: TBitBtn
          Left = 5
          Top = 2
          Width = 47
          Height = 21
          Caption = 'LogIn'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ModalResult = 1
          ParentFont = False
          TabOrder = 0
          OnClick = BitBtn1Click
        end
        object BitBtn2: TBitBtn
          Left = 5
          Top = 23
          Width = 47
          Height = 21
          Caption = 'Close'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ModalResult = 2
          ParentFont = False
          TabOrder = 1
          OnClick = BitBtn2Click
        end
      end
      object Panel10: TPanel
        Left = 1
        Top = 1
        Width = 122
        Height = 47
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitHeight = 46
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 122
          Height = 23
          Align = alTop
          Caption = 'Panel5'
          TabOrder = 0
          object Panel6: TPanel
            Left = 1
            Top = 1
            Width = 40
            Height = 21
            Align = alLeft
            Caption = 'ID'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            ExplicitLeft = -15
            ExplicitTop = -3
          end
          object UserID: TNxEdit
            Left = 41
            Top = 1
            Width = 80
            Height = 21
            Align = alClient
            TabOrder = 0
            ExplicitHeight = 24
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 23
          Width = 122
          Height = 24
          Align = alClient
          Caption = 'Panel5'
          TabOrder = 1
          ExplicitHeight = 23
          object Panel7: TPanel
            Left = 1
            Top = 1
            Width = 40
            Height = 22
            Align = alLeft
            Caption = 'PW'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #47569#51008' '#44256#46357
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            ExplicitHeight = 21
          end
          object PassWD: TNxEdit
            Left = 41
            Top = 1
            Width = 80
            Height = 22
            Align = alClient
            TabOrder = 1
            PasswordChar = '*'
            ExplicitHeight = 24
          end
        end
      end
    end
  end
  object DBNameEdit: TEdit
    Left = 124
    Top = 65
    Width = 150
    Height = 24
    Alignment = taCenter
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    TabOrder = 3
  end
end
