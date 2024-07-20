object IPAddrInputF: TIPAddrInputF
  Left = 0
  Top = 0
  Caption = 'IPAddrInputF'
  ClientHeight = 268
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object JvLabel5: TJvLabel
    AlignWithMargins = True
    Left = 24
    Top = 62
    Width = 105
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'IP Address'
    Color = 14671839
    FrameColor = clGrayText
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    Layout = tlCenter
    ParentColor = False
    ParentFont = False
    RoundedFrame = 3
    Transparent = True
    HotTrackFont.Charset = ANSI_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -13
    HotTrackFont.Name = #47569#51008' '#44256#46357
    HotTrackFont.Style = []
  end
  object JvLabel1: TJvLabel
    AlignWithMargins = True
    Left = 24
    Top = 110
    Width = 105
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'Port'
    Color = 14671839
    FrameColor = clGrayText
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    Layout = tlCenter
    ParentColor = False
    ParentFont = False
    RoundedFrame = 3
    Transparent = True
    HotTrackFont.Charset = ANSI_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -13
    HotTrackFont.Name = #47569#51008' '#44256#46357
    HotTrackFont.Style = []
  end
  object JvLabel2: TJvLabel
    AlignWithMargins = True
    Left = 24
    Top = 158
    Width = 105
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'Name'
    Color = 14671839
    FrameColor = clGrayText
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    Layout = tlCenter
    ParentColor = False
    ParentFont = False
    RoundedFrame = 3
    Transparent = True
    HotTrackFont.Charset = ANSI_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -13
    HotTrackFont.Name = #47569#51008' '#44256#46357
    HotTrackFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 328
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 204
    Width = 328
    Height = 64
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 117
    object BitBtn1: TBitBtn
      Left = 48
      Top = 16
      Width = 89
      Height = 41
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 184
      Top = 15
      Width = 89
      Height = 41
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object IPAddress: TJvIPAddress
    Left = 144
    Top = 64
    Width = 150
    Height = 21
    Hint = 'Text'
    Address = 0
    ParentColor = False
    TabOrder = 2
  end
  object Port: TEdit
    Left = 144
    Top = 114
    Width = 81
    Height = 21
    Hint = 'Text'
    TabOrder = 3
  end
  object IPName: TEdit
    Left = 144
    Top = 162
    Width = 150
    Height = 21
    Hint = 'Text'
    TabOrder = 4
  end
end
