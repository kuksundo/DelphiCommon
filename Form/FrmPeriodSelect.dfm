object PeriodSelectF: TPeriodSelectF
  Left = 0
  Top = 0
  Caption = 'PeriodSelectF'
  ClientHeight = 181
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object JvLabel5: TJvLabel
    AlignWithMargins = True
    Left = 24
    Top = 62
    Width = 137
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = #44396#44036' '#49440#53469
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
  object Label1: TLabel
    Left = 280
    Top = 69
    Width = 8
    Height = 13
    Caption = '~'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 425
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 328
  end
  object DateTimePicker1: TDateTimePicker
    Left = 167
    Top = 64
    Width = 106
    Height = 21
    Date = 45354.467282511580000000
    Time = 45354.467282511580000000
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 117
    Width = 425
    Height = 64
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 106
    ExplicitWidth = 567
    object BitBtn1: TBitBtn
      Left = 48
      Top = 8
      Width = 89
      Height = 41
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 264
      Top = 7
      Width = 89
      Height = 41
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object DateTimePicker2: TDateTimePicker
    Left = 294
    Top = 64
    Width = 106
    Height = 21
    Date = 45354.467282511580000000
    Time = 45354.467282511580000000
    TabOrder = 3
  end
end
