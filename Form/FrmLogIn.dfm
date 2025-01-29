object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'LogIn'
  ClientHeight = 81
  ClientWidth = 193
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 193
    Height = 51
    Align = alTop
    Color = clGray
    TabOrder = 0
    ExplicitTop = 95
    ExplicitWidth = 301
    object Panel8: TPanel
      Left = 12
      Top = 1
      Width = 180
      Height = 49
      Align = alRight
      TabOrder = 0
      ExplicitLeft = 120
      object Panel9: TPanel
        Left = 123
        Top = 1
        Width = 56
        Height = 47
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
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
          end
          object UserID: TNxEdit
            Left = 41
            Top = 1
            Width = 80
            Height = 21
            Align = alClient
            TabOrder = 0
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
          end
          object PassWD: TNxEdit
            Left = 41
            Top = 1
            Width = 80
            Height = 22
            Align = alClient
            TabOrder = 1
            PasswordChar = '*'
            ExplicitHeight = 21
          end
        end
      end
    end
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 60
    Width = 65
    Height = 17
    Caption = 'Save ID'
    TabOrder = 1
  end
end
