object OutlookEmailListFr: TOutlookEmailListFr
  Left = 0
  Top = 0
  Width = 1214
  Height = 651
  TabOrder = 0
  object mailPanel1: TPanel
    Left = 0
    Top = 0
    Width = 1214
    Height = 651
    Margins.Left = 5
    Margins.Right = 5
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 5
    Padding.Right = 5
    ParentBackground = False
    TabOrder = 0
    StyleElements = [seFont, seClient]
    DesignSize = (
      1214
      651)
    object tabMail: TTabControl
      Left = 5
      Top = 57
      Width = 1204
      Height = 561
      Align = alClient
      TabOrder = 0
      object StatusBar: TStatusBar
        Left = 4
        Top = 538
        Width = 1196
        Height = 19
        AutoHint = True
        Panels = <
          item
            Alignment = taCenter
            Bevel = pbRaised
            Text = 'Mail Count'
            Width = 70
          end
          item
            Alignment = taCenter
            Width = 44
          end
          item
            Width = 44
          end
          item
            Width = 44
          end
          item
            Alignment = taCenter
            Width = 50
          end>
        ParentColor = True
        ParentFont = True
        ParentShowHint = False
        ShowHint = True
        SizeGrip = False
        UseSystemFont = False
      end
      object EmailTab: TAdvOfficeTabSet
        Left = 4
        Top = 6
        Width = 1196
        Height = 27
        AdvOfficeTabs = <
          item
            Caption = #51204#52404
            Name = 'TOfficeTabCollectionItem5'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = 'PO#'
            Name = 'cdmPoFromCust'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = 'EmailTab1'
            Name = 'TOfficeTabCollectionItem3'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = 'EmailTab2'
            Name = 'TOfficeTabCollectionItem4'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = 'EmailTab3'
            Name = 'TOfficeTabCollectionItem5'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = 'EmailTab1'
            Name = 'TOfficeTabCollectionItem3'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = 'EmailTab2'
            Name = 'TOfficeTabCollectionItem4'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = 'EmailTab3'
            Name = 'TOfficeTabCollectionItem5'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = #44204#51201#49436
            Name = 'cdmQtn2Cust'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = 'Invoice'
            Name = 'cdmInvoice2Cust'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = 'Service Report'
            Name = 'cdmServiceReport'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end
          item
            Caption = #49464#44552#44228#49328#49436
            Name = 'cdmTaxBillFromSubCon'
            TabAppearance.BorderColor = clNone
            TabAppearance.BorderColorHot = 15383705
            TabAppearance.BorderColorSelected = 14922381
            TabAppearance.BorderColorSelectedHot = 6343929
            TabAppearance.BorderColorDisabled = clNone
            TabAppearance.BorderColorDown = clNone
            TabAppearance.Color = clBtnFace
            TabAppearance.ColorTo = clWhite
            TabAppearance.ColorSelected = 16709360
            TabAppearance.ColorSelectedTo = 16445929
            TabAppearance.ColorDisabled = clWhite
            TabAppearance.ColorDisabledTo = clSilver
            TabAppearance.ColorHot = 14542308
            TabAppearance.ColorHotTo = 16768709
            TabAppearance.ColorMirror = clWhite
            TabAppearance.ColorMirrorTo = clWhite
            TabAppearance.ColorMirrorHot = 14016477
            TabAppearance.ColorMirrorHotTo = 10736609
            TabAppearance.ColorMirrorSelected = 16445929
            TabAppearance.ColorMirrorSelectedTo = 16181984
            TabAppearance.ColorMirrorDisabled = clWhite
            TabAppearance.ColorMirrorDisabledTo = clSilver
            TabAppearance.Font.Charset = DEFAULT_CHARSET
            TabAppearance.Font.Color = clWindowText
            TabAppearance.Font.Height = -11
            TabAppearance.Font.Name = 'Tahoma'
            TabAppearance.Font.Style = []
            TabAppearance.Gradient = ggVertical
            TabAppearance.GradientMirror = ggVertical
            TabAppearance.GradientHot = ggRadial
            TabAppearance.GradientMirrorHot = ggVertical
            TabAppearance.GradientSelected = ggVertical
            TabAppearance.GradientMirrorSelected = ggVertical
            TabAppearance.GradientDisabled = ggVertical
            TabAppearance.GradientMirrorDisabled = ggVertical
            TabAppearance.TextColor = 9126421
            TabAppearance.TextColorHot = 9126421
            TabAppearance.TextColorSelected = 9126421
            TabAppearance.TextColorDisabled = clGray
            TabAppearance.ShadowColor = 15255470
            TabAppearance.HighLightColorSelected = 16775871
            TabAppearance.HighLightColorHot = 16643309
            TabAppearance.HighLightColorSelectedHot = 12451839
            TabAppearance.HighLightColorDown = 16776144
            TabAppearance.BackGround.Color = 16767935
            TabAppearance.BackGround.ColorTo = clNone
            TabAppearance.BackGround.Direction = gdHorizontal
          end>
        Align = alTop
        ActiveTabIndex = 0
        ButtonSettings.CloseButtonPicture.Data = {
          424DA20400000000000036040000280000000900000009000000010008000000
          00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001000001010100000100
          0000000202000100020200000000000202020002020200000000010002020202
          0200010000000101000202020001010000000100020202020200010000000002
          0202000202020000000000020200010002020000000001000001010100000100
          0000}
        ButtonSettings.ClosedListButtonPicture.Data = {
          424DA20400000000000036040000280000000900000009000000010008000000
          00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000101010100
          0000010101000200010101000000010100020202000101000000010002020202
          0200010000000002020200020202000000000002020001000202000000000100
          0001010100000100000001010101010101010100000001010101010101010100
          0000}
        ButtonSettings.TabListButtonPicture.Data = {
          424DA20400000000000036040000280000000900000009000000010008000000
          00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000101010100
          0000010101000200010101000000010100020202000101000000010002020202
          0200010000000002020200020202000000000002020001000202000000000100
          0001010100000100000001010101010101010100000001010101010101010100
          0000}
        ButtonSettings.ScrollButtonPrevPicture.Data = {
          424DA20400000000000036040000280000000900000009000000010008000000
          00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000001010100
          0000010101000202000101000000010100020202000101000000010002020200
          0101010000000002020200010101010000000100020202000101010000000101
          0002020200010100000001010100020200010100000001010101000001010100
          0000}
        ButtonSettings.ScrollButtonNextPicture.Data = {
          424DA20400000000000036040000280000000900000009000000010008000000
          00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010000010101010100
          0000010002020001010101000000010002020200010101000000010100020202
          0001010000000101010002020200010000000101000202020001010000000100
          0202020001010100000001000202000101010100000001010000010101010100
          0000}
        ButtonSettings.ScrollButtonFirstPicture.Data = {
          424DC60400000000000036040000280000001000000009000000010008000000
          000000000000C40E0000C40E00000001000000010000427B84FFDEEFEFFFFFFF
          FFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF01010101010000010101
          0101000001010101010100020200010101000202000101010100020202000101
          0002020200010101000202020001010002020200010101000202020001010002
          0202000101010101000202020001010002020200010101010100020202000101
          0002020200010101010100020200010101000202000101010101010000010101
          010100000101}
        ButtonSettings.ScrollButtonLastPicture.Data = {
          424DC60400000000000036040000280000001000000009000000010008000000
          000000000000C40E0000C40E00000001000000010000427B84FFDEEFEFFFFFFF
          FFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF01010000010101010100
          0001010101010100020200010101000202000101010101000202020001010002
          0202000101010101000202020001010002020200010101010100020202000101
          0002020200010101000202020001010002020200010101000202020001010002
          0202000101010100020200010101000202000101010101010000010101010100
          000101010101}
        ButtonSettings.CloseButtonHint = 'Close'
        ButtonSettings.InsertButtonHint = 'Insert new item'
        ButtonSettings.TabListButtonHint = 'TabList'
        ButtonSettings.ClosedListButtonHint = 'Closed Pages'
        ButtonSettings.ScrollButtonNextHint = 'Next'
        ButtonSettings.ScrollButtonPrevHint = 'Previous'
        ButtonSettings.ScrollButtonFirstHint = 'First'
        ButtonSettings.ScrollButtonLastHint = 'Last'
        TabSettings.Alignment = taCenter
        TabSettings.Width = 110
      end
      object grid_Mail: TNextGrid
        Left = 4
        Top = 33
        Width = 1196
        Height = 505
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        Align = alClient
        AppearanceOptions = [ao3DGridLines, aoAlphaBlendedSelection, aoBoldTextSelection, aoHideFocus, aoHideSelection]
        Caption = ''
        HeaderSize = 23
        HighlightedTextColor = clHotLight
        Options = [goHeader, goSelectFullRow]
        RowSize = 18
        PopupMenu = PopupMenu1
        TabOrder = 2
        TabStop = True
        OnCellDblClick = grid_MailCellDblClick
        OnMouseDown = grid_MailMouseDown
        object Incremental: TNxIncrementColumn
          Alignment = taCenter
          DefaultWidth = 30
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = []
          Header.Caption = 'No'
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 0
          SortType = stAlphabetic
          Width = 30
        end
        object TaskID: TNxTextColumn
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 1
          SortType = stAlphabetic
          Visible = False
        end
        object HullNo: TNxTextColumn
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Hull No'
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
          ParentFont = False
          Position = 2
          SortType = stAlphabetic
        end
        object ProjectNo: TNxTextColumn
          Alignment = taCenter
          Header.Caption = 'ProjectNo'
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
          Position = 3
          SortType = stAlphabetic
          Visible = False
        end
        object ClaimNo: TNxTextColumn
          Alignment = taCenter
          DefaultWidth = 50
          Header.Caption = 'ClaimNo'
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 4
          SortType = stAlphabetic
          Width = 50
        end
        object ExistInDB: TNxCheckBoxColumn
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 5
          SortType = stBoolean
          Visible = False
        end
        object Description: TNxButtonColumn
          Alignment = taCenter
          DefaultWidth = 300
          Header.Caption = #49444#47749
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
          Position = 6
          SortType = stAlphabetic
          Width = 300
          OnButtonClick = DescriptionButtonClick
        end
        object Subject: TNxTextColumn
          DefaultWidth = 150
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = #47700#51068#51228#47785
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 7
          SortType = stAlphabetic
          Width = 150
        end
        object RecvDate: TNxDateColumn
          Alignment = taCenter
          DefaultValue = '2014-01-24'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = []
          Header.Caption = #49688#49888#51068
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 8
          SortType = stDate
          NoneCaption = 'None'
          TodayCaption = 'Today'
        end
        object ProcDirection: TNxTextColumn
          Alignment = taCenter
          DefaultWidth = 121
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = []
          Header.Caption = #47700#51068#49569#48512
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 9
          SortType = stAlphabetic
          Width = 121
        end
        object ContainData: TNxTextColumn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = #52392#48512#51333#47448
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 10
          SortType = stAlphabetic
        end
        object SenderName: TNxMemoColumn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = #48156#49888#51088
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
          ParentFont = False
          Position = 11
          SortType = stAlphabetic
        end
        object Recipients: TNxMemoColumn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = #49688#49888#51088
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 12
          SortType = stAlphabetic
        end
        object CC: TNxMemoColumn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = #52280#51312
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 13
          SortType = stAlphabetic
        end
        object BCC: TNxMemoColumn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = #49704#51008#52280#51312
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 14
          SortType = stAlphabetic
        end
        object RowID: TNxTextColumn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 15
          SortType = stAlphabetic
          Visible = False
        end
        object LocalEntryId: TNxTextColumn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 16
          SortType = stAlphabetic
          Visible = False
        end
        object LocalStoreId: TNxTextColumn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 17
          SortType = stAlphabetic
          Visible = False
        end
        object SavedOLFolderPath: TNxTextColumn
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = #51200#51109#54260#45908
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 18
          SortType = stAlphabetic
        end
        object AttachCount: TNxTextColumn
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Attachments'
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 19
          SortType = stAlphabetic
        end
        object DBKey: TNxTextColumn
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 20
          SortType = stAlphabetic
          Visible = False
        end
        object SavedMsgFilePath: TNxTextColumn
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 21
          SortType = stAlphabetic
          Visible = False
        end
        object SavedMsgFileName: TNxTextColumn
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 22
          SortType = stAlphabetic
          Visible = False
        end
        object SenderEmail: TNxTextColumn
          Header.Caption = #48156#49888#51088' '#51060#47700#51068
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 23
          SortType = stAlphabetic
          Visible = False
        end
        object FolderEntryId: TNxTextColumn
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 24
          SortType = stAlphabetic
          Visible = False
        end
        object FlagRequest: TNxTextColumn
          DefaultWidth = 150
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Flag'
          Header.Alignment = taCenter
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 25
          SortType = stAlphabetic
          Width = 150
        end
      end
    end
    object panMailButtons: TPanel
      Left = 5
      Top = 618
      Width = 1204
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      object btnStartProgram: TBitBtn
        Left = 128
        Top = 6
        Width = 161
        Height = 25
        Caption = 'Run &E-Mail Client'
        Glyph.Data = {
          A6020000424DA6020000000000003600000028000000100000000D0000000100
          18000000000070020000230B0000230B00000000000000000000FFFFFF736B6B
          7B73737B73737B73737B73737B73737B73737B73737B73737B73737B73737B73
          737B73737B7373FFFFFFC6BDC6A59CA5D6D6D6F7F7F7EFE7EFE7E7E7E7DEE7DE
          D6DEDED6DED6CED6D6CED6D6C6D6CEC6CEB5ADB59C9C9C84737BD6CECEF7F7F7
          B5ADB5E7DEE7F7EFEFEFE7EFE7DEE7E7DEE7DED6DED6CED6D6CED6D6CED6C6BD
          C69C9C9CC6BDC68C7B84CECECEFEFEFEF7F7F7B5ADB5F7EFEFEFE7EFEFE7EFE7
          DEE7E7DEE7DED6DED6CED6CEC6CEA59CA5CEC6CECEC6CE8C7B84CECECEFEFEFE
          FEFEFEEFE7EFB5ADB5F7EFF7EFE7EFEFE7EFE7DEE7E7DEE7DED6DEA59CA5C6BD
          C6CEC6CED6C6D68C7B84D6CECEFEFEFEFEFEFEFEFEFEE7DEE7BDBDBDFFF7F7EF
          E7EFEFE7EFE7E7E7B5ADB5C6BDC6D6CED6D6C6D6D6C6D68C7B84D6CECEFEFEFE
          FEFEFEFEFEFEFEFEFEEFE7EFB5ADB5A59CA5A59CA5ADA5ADDED6DEDED6DED6CE
          D6D6C6D6D6C6D68C7B84D6CECEFEFEFEFEFEFEFEFEFEEFEFEFBDB5BDD6CED6EF
          E7EFE7E7E7CEC6CEADA5ADD6CED6DED6DED6CED6D6CED68C7B84D6CECEFEFEFE
          FEFEFEFEFEFEBDB5B5E7E7E7FEFEFEF7EFF7F7EFEFEFE7EFD6D6D6A59CA5D6CE
          D6D6CED6DED6DE8C7B84D6CECEFEFEFEF7EFF7BDB5BDFEFEFEFEFEFEFFF7FFFF
          F7F7F7EFF7EFE7EFEFE7EFE7DEE7A59CA5D6C6D6DED6DE8C7B84D6D6D6E7E7E7
          B5ADB5F7F7F7FEFEFEFEFEFEFEFEFEFFF7F7F7F7F7F7EFF7EFE7EFEFE7EFDED6
          DE949494C6BDC68C848CBDB5BDCECECEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFF
          F7FFFFF7F7F7EFF7F7EFEFEFE7EFE7DEE7E7E7E7BDB5B57B7373FFFFFFC6C6C6
          C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6
          C6C6C6C6CECECEFFFFFF}
        TabOrder = 0
        Visible = False
      end
      object BitBtn1: TBitBtn
        Left = 1115
        Top = 0
        Width = 89
        Height = 33
        Align = alRight
        Cancel = True
        Caption = 'Close'
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        ModalResult = 8
        NumGlyphs = 2
        TabOrder = 1
      end
      object AeroButton1: TAeroButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 94
        Height = 27
        ImageIndex = 0
        Images = ImageList16x16
        Version = '1.0.0.1'
        Align = alLeft
        Caption = 'Save To DB'
        TabOrder = 2
        OnClick = AeroButton1Click
      end
    end
    object panProgress: TPanel
      Left = 997
      Top = 596
      Width = 205
      Height = 18
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 2
      Visible = False
      DesignSize = (
        205
        18)
      object btnStop: TSpeedButton
        Left = 5
        Top = 1
        Width = 18
        Height = 17
        Cursor = crArrow
        Hint = 'Stop and disconnect.'
        Glyph.Data = {
          E6010000424DE60100000000000036000000280000000C0000000C0000000100
          180000000000B0010000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FF0D0D503F3F8B3F3F8F4141903E3E8F10104EFF00FFFF00FFFF00FFFF00
          FFFF00FF0000400000F30D0DFF2B2BFF2B2BFF0A0AFF0101F000003DFF00FFFF
          00FFFF00FF00003E0000C73F3FFB3939E40000E30000E63D3DEA3737FF0000CF
          00003CFF00FF08084E0000962D2DCEFFFFCCEBE9C20000C50000C7F2F2BFFFFF
          CE2020D60000960B0B4D1B1B6700008F090979BFBFB6FFFFD9C9CACECDCDCFFF
          FFD6B8B6B106067300008D24246A23235B00003100004E000063A6A7CCFFFFEA
          FFFFE89F9FC600007200006F00004D27276128285F2020550000790B0BAAE6E6
          F7FFFFFFFFFFFFE0E0F40707BB0000A21D1D8F2B2B6A1A1A690C0CB83939B5FF
          FFFFFFFFFFB6B6DABEBEDCFFFFFFFFFFFF3636C01616D61F1F6F4141716060FF
          2727E3F6F6DFE0E2DA0000DA0303DAE8E8DAEEEEDC3333DF6E6EFC444472FF00
          FF4F4F7E7878FF2A2BDE3130DB5555FF5557FF3535D83636E18787FF50507CFF
          00FFFF00FFFF00FF4E4E85B4B5FFCAC3FFD5C8FFD1CBFFC9CAFFBCBCFF4C4C81
          FF00FFFF00FFFF00FFFF00FFFF00FF5151825B598F626094615D9457588F5252
          82FF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
      end
      object Progress: TProgressBar
        Left = 27
        Top = 1
        Width = 178
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
    end
    object Panel1: TPanel
      Left = 5
      Top = 0
      Width = 1204
      Height = 57
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      object Label1: TLabel
        Left = 8
        Top = 31
        Width = 91
        Height = 16
        Caption = 'Move Folder : '
      end
      object AutoMove2HullNoCB: TCheckBox
        Left = 426
        Top = 14
        Width = 234
        Height = 17
        Caption = 'Auto Move Email To Sub-Folder'
        TabOrder = 0
        Visible = False
      end
      object MoveFolderCB: TComboBox
        Left = 100
        Top = 30
        Width = 320
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft IME 2010'
        ParentFont = False
        TabOrder = 1
      end
      object SubFolderCB: TCheckBox
        Left = 426
        Top = 37
        Width = 115
        Height = 17
        Caption = 'To Sub-Folder :'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = SubFolderCBClick
      end
      object SubFolderNameEdit: TEdit
        Left = 547
        Top = 33
        Width = 146
        Height = 24
        Enabled = False
        ImeName = 'Microsoft IME 2010'
        TabOrder = 3
      end
      object AutoMoveCB: TCheckBox
        Left = 105
        Top = 8
        Width = 272
        Height = 17
        Caption = 'Email To Move Folder when drag drop'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object BitBtn2: TBitBtn
        Left = 694
        Top = 31
        Width = 30
        Height = 25
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000000000000000000000000000000000009DB79A2A8431
          338F3C338E3A338E3A338E3A338E3C34943D34913D328D3B328E3C338D3B338D
          3B338F3C2A82309DB69A27812E33C65633C65633C55633C55633C45633C4562A
          9D3C25AB3F31C25131C25133C55633C55533C65635C65B26802D34954035C65C
          35C65C35C65C35C65C35C65C35C65C257B2B13460A0E8D232DBC4C35C65B35C6
          5B35C65B35C65B33923E34943F35C65B35C65B35C65C35C65C35C65C35C65C22
          8C31F7F6F23966350084152FC05235C65B35C65B33C55733913D33994331BB56
          16942F0A8F230A8F230A8E230A9428005E00FFFDFFFFFFFF315B2B05801834CA
          5C35C65B33C45932923E2F9C451E9031C5DCC4C5DCC4C5DCC4C5DCC4C5DCC4D7
          E4D5FAFBFAFFFFFFFFFEFF45793E0B902534CA6135C95E2F8E3A319F470B8C25
          CFE1CBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4E82
          460C85202ACE5E2F94406DC6872B9C47D7E4D5FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF568B4C38A65077CA8C6FC38863C07F
          D7E4D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF8EB98B76CD957AC79067C3835ABD79D7E4D5FFFFFFFFFFFFFFFFFFFFFFFFF7
          F6F2FFFFFFFFFFFFFFFFFFFFFCFF74AD755FC28082E7B473C28666C48664C383
          D3E7D0D3E7D0D1E5CFCEE1CBCBDDC5D7E4D5FAFBFBFFFFFFF9F7F67AB67E5DCA
          8881E4B182E0B074C68B65C38574DBA866CC9065CC9063CC8F5AC58652C38038
          A556FEF9FBF7F6F267B16F65CE9283E4B684DEB083E3B477CA9168C58777E3B9
          81E7BC83E6BE83E5BD82E5BC7EE9BF67C98CF7F6F266B3705ECE9480E5B982E0
          B481E0B481E3B679CD976CCB9278E4B97FE2B881E2B981E3B981E3B880E7BE72
          CC905FB46D5DD1937EE4BB82E2B781E2B681E1B77FE3BB7BD0996BCB8D79E9C4
          7EE8C17EE6C17FE7C17EE6C07EE8C477DDA96EDFB07AE7C17FE5BE7FE5BF7FE5
          BF80E6BE7CE8C171CC93C0E6C87CD49F7FD9A67DD7A27BD6A07AD69F78D6A079
          D7A279D7A078D59D78D49E78D49E7AD59E7DD6A27AD29BC1E4C8}
        TabOrder = 5
        OnClick = BitBtn2Click
      end
      object Button1: TButton
        Left = 730
        Top = 32
        Width = 75
        Height = 25
        Caption = 'Edit Json'
        TabOrder = 6
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 730
        Top = 1
        Width = 75
        Height = 25
        Caption = 'Add Json'
        TabOrder = 7
        OnClick = Button2Click
      end
    end
  end
  object DropEmptyTarget1: TDropEmptyTarget
    DragTypes = [dtCopy, dtLink]
    OnDrop = DropEmptyTarget1Drop
    Target = grid_Mail
    WinTarget = 0
    Left = 28
    Top = 140
  end
  object DataFormatAdapterOutlook: TDataFormatAdapter
    DragDropComponent = DropEmptyTarget1
    DataFormatName = 'TOutlookDataFormat'
    Left = 60
    Top = 140
  end
  object PopupMenu1: TPopupMenu
    Left = 93
    Top = 141
    object CreateEMail1: TMenuItem
      Caption = 'Create EMail'
      Visible = False
      object N3: TMenuItem
        Tag = 2
        Caption = #47588#52636#52376#47532' '#50836#52397
      end
      object N5: TMenuItem
        Tag = 3
        Caption = #51088#51116' '#51649#53804#51077' '#50836#52397
      end
      object N7: TMenuItem
        Tag = 4
        Caption = #54644#50808' '#47588#52636' '#44256#44061#49324' '#46321#47197'  '#50836#52397
      end
      object N6: TMenuItem
        Tag = 5
        Caption = #51204#51204' '#48708#54364#51456#44277#49324' '#49373#49457' '#50836#52397
      end
      object N9: TMenuItem
        Tag = 7
        Caption = #52636#54616#51648#49884' '#50836#52397
      end
    end
    object SendReply1: TMenuItem
      Caption = 'Reply EMail'
      object APTCoC1: TMenuItem
        Caption = 'APT CoC '#49569#48512
        object Englisth1: TMenuItem
          Caption = 'English'
          OnClick = Englisth1Click
        end
        object Korean1: TMenuItem
          Caption = 'Korean'
        end
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object N2: TMenuItem
        Tag = 6
        Caption = 'PO '#50836#52397
      end
      object SendInvoice1: TMenuItem
        Tag = 1
        Caption = 'Invoice '#49569#48512
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N10: TMenuItem
        Tag = 8
        Caption = #54596#46300#49436#48708#49828#54016' '#51204#45804
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object N12: TMenuItem
        Tag = 10
        Caption = #49436#48708#49828#50724#45908' '#45216#51064' '#50836#52397
      end
    end
    object ForwardEMail1: TMenuItem
      Caption = 'Forward EMail'
      Visible = False
      object N11: TMenuItem
        Tag = 9
        Caption = #44592#49457#54869#51064' '#50836#52397
      end
      object N13: TMenuItem
        Tag = 11
        Caption = #44592#49457#52376#47532' '#50836#52397
      end
    end
    object EditMailInfo1: TMenuItem
      Caption = 'Edit Mail Info'
      OnClick = EditMailInfo1Click
    end
    object CopyHullNoClaimNoSubject1: TMenuItem
      Caption = 'Copy HullNo+ClaimNo+Subject'
      OnClick = CopyHullNoClaimNoSubject1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MoveEmail1: TMenuItem
      Caption = 'Move Email To'
    end
    object MoveEmailToSelected1: TMenuItem
      Caption = 'Move Email To Move Folder'
      OnClick = MoveEmailToSelected1Click
    end
    object MoveSelectedEmail2MoveFolder1: TMenuItem
      Caption = 'Move Selected Email 2 MoveFolder'
      OnClick = MoveSelectedEmail2MoveFolder1Click
    end
    object DeleteMail1: TMenuItem
      Caption = 'Delete Mail'
      OnClick = DeleteMail1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object ShowMailInfo1: TMenuItem
      Caption = 'Show Mail Info'
      Visible = False
      object ShowEntryID1: TMenuItem
        Caption = 'Show Entry ID'
      end
      object ShowStoreID1: TMenuItem
        Caption = 'Show Store ID'
      end
    end
    object estRemote1: TMenuItem
      Caption = 'Test Remote'
      Visible = False
    end
    object N16: TMenuItem
      Caption = '-'
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Send2MQCheck: TMenuItem
        Caption = 'Send Dropped Mail 2 MQ'
        OnClick = Send2MQCheckClick
      end
    end
    object Save2JsonAryFromSelected1: TMenuItem
      Caption = 'Get JsonAry From Selected'
      OnClick = Save2JsonAryFromSelected1Click
    end
    object GetUnReadMailList1: TMenuItem
      Caption = 'Get UnRead Mail List 2 Grid'
      OnClick = GetUnReadMailList1Click
    end
    object UpdateClaimExist1: TMenuItem
      Caption = 'Check If ClaimNo Exist in DB'
      OnClick = UpdateClaimExist1Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 125
    Top = 137
  end
  object ImageList16x16: TImageList
    ColorDepth = cd32Bit
    Left = 155
    Top = 136
    Bitmap = {
      494C010103009800680710001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000001010101010101070303
      03190B0B0B331717174C2020205B2121215C1919194F0D0D0D38734319BD7B58
      15B7694224B400000000000000000000000000000000C8C7C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C4C3C200FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000001010104030303181818184F4A4A
      4A9C787777D6A09F9FF2A09D9CF99F9B9AF9A2A1A0F3818080DDCE7624FFEEA9
      25FFD18148FF010101060000000000000000F6F5F500B3AFB000B6B4B200FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F6F5F500B1ADAC00B1AEAD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000030303172525256C5F5C5CE77671
      6FFFC4C3C2FFDAD8D8FFCACBCAFFCAC9C8FFD7D6D5FFC6C6C6FFCF7924FFEEA9
      25FFD18248FF050505200101010400000000FFFFFF00E8E7E600B5B1B100BBBA
      BA00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7E5E500B2ADAD00B7B7
      B600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000013131353777675F2A8A7A6FFA1A1
      9FFF898687FF91908FFF8D8988FF8C8B88FF939290FF8C8B89FFD07823FFEEA9
      25FFD18248FF1E1E1E6B0000000000000000FFFFFF00FFFFFF00DBDAD900AEAB
      A900C8C6C500FFFFFF00FFFFFF00CCCCCC00626262004A4A4A00D8D8D800FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D9D8D700AAA7
      A900C4C1B200FFFFFF00FFFFFF00D0CFFD006B67FA00534EF900DCDBFE00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003C3C3ABCB7B6B5FF6D6B69FF6F6B
      6AFFCACAC9FFE1E1E0FFCAC9C8FFCF7823FFCF7823FFCF7824FFCF7823FFEEA9
      25FFD18248FFD18248FFD18148FFCC7323FFFFFFFF00FFFFFF00FFFFFF00DBD9
      D700C8C3C200ADACAC004646460002020200020202000202020030303000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D9D6
      D500BCB48600B5B8E4004E50FF001513F500120CF600120CF6003A35F800FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000848281ED9A9897FFA4A3A2FFA6A4
      A3FF8E8D8CFF90918EFF8C8987FF8B8887FFCF7823FFFFC32DFFFFC42DFFEEA9
      25FFDD8F32FFDD9032FFCC7323FF00000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00AEABAA00100E0F000101010001010100000002000202020002020200CFCF
      CF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6CC001F34F3001524F900171DF6001411F800120BF800110BF800D3D2
      FE00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A3A1A0FAB1B0AFFF73706FFF6765
      62FFB5B3B0FFC4C3C2FFB2B1B2FFB2B1B0FFC0BFBEFFCF7823FFFFC42DFFEEA9
      24FFDD9032FFCC7222FF0000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00464645000F0D0C000A09090004030300050404000201010002020200CACA
      CA00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00546DFF002241FE002138F6001624F7001419EE00100AE7001109F200CECD
      FE00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009D9C99F6908D8BFF888685FFA1A0
      9FFFB1B0AFFFAEACAAFFB9B9B7FFBCBDB9FFB2B1B0FFB2B1B0FFCF7823FFEEA9
      24FFCC7222FFB1B0AFFF0000000000000000FFFFFF00FFFFFF00FFFFFF00ABA9
      A90037332F002A2725001511110018171400100F0E000706060009080900E8E8
      E800FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00ADBC
      FE00496EFA004566F9002946FA002B4AF5001A2DEB001316E300140FE400EDEC
      FE00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000939291F7A19F9EFF9F9E9CFFB2B1
      B1FFBBB9B7FFBFBEBCFFC2C0BDFFC3C2BEFFC3C2BFFFC2C0BEFFBDBCB9FFCF78
      23FF9C9B9BFFAAA8A7FF0000000000000000FFFFFF00FFFFFF00FFFFFF00837F
      7D00736D670046423F0081797A00625E5B0012100F0011101000080707006768
      6700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00728D
      FB007294FA005C7EFA004F74F8006F9DFD00294DF7001B2FEE001319E5006F6A
      EC00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000999897F6959391FFA6A4A2FFA7A6
      A3FFAAA8A7FFACABAAFFAFAEACFFB0AFACFFB0AFACFFAEACACFFABABA9FFAFAE
      ABFF9B9898FFABABA9FE0000000000000000FFFFFF00FFFFFF00FFFFFF008D89
      8500716C6900423D3C0087807E00CCC9C700645D5C0016131200100E0D000808
      0700A1A0A000E8E8E800E6E6E600FFFFFF00FFFFFF00FFFFFF00FFFFFF006F88
      FB00476CF9003C5FF9002C4CF7006E9CFD006B97FD002D51F6001B2FEE001217
      E300A8A7F700ECECFF00E9E8FF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008A8887F5ABAAA8FFA7A6A4FFAAA9
      A7FFAEACABFFB0AFAEFFB2B1AFFFB2B2B0FFB2B1AFFFB0B0AEFFAFAEABFFACAB
      A9FFB2B1AEFFA09F9EFE0000000000000000FFFFFF00FFFFFF00FFFFFF00F6F5
      F5007A76750044424100353333008B878200C6C3C20079747100211C1A001211
      0F0025252400222120001E1B1A00C1C1C100FFFFFF00FFFFFF00FFFFFF00F6F8
      FF006980FB003F5AF900374BF8003852FA006A98FD006D9AFD003052F8001C36
      F2002C3DF8002B34F800282CF700CAC9FE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000989695FAC2C0BDFFB6B5B3FFB8B7
      B6FFBBB9B8FFBDBCB9FFBEBDBBFFBEBDBCFFBEBDBBFFBDBCBBFFBCBBB8FFBBB9
      B7FFC4C3BFFFB0AFAEFF0000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F6F6F600F4F3F300F4F3F300A9A5A200B9B5B3005C5756004441
      40003734330034303000484541005F5B5800FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F8F9FF00F7F7FF00F4F5FF00687EFB006490FB00608EFC004C6E
      FB00324AFA003151F900426CFB005977FB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000656563C1C8C8C6FFCBCAC9FFC9C6
      C5FFCAC9C8FFCBCAC9FFCBCBCAFFCCCBCAFFCBCBCAFFCBCAC9FFCAC9C8FFCBCA
      CBFFCFCECCFF848483DC0000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B6B3B0009D9A96001514
      15000A0707001C1717002927260047414000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007C97FC0087ACFD001D20
      F500121FF7002138F7002A4AF8003F68F9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000707072BA8A8A6EDDEDDDCFFE3E3
      E2FFE0E0DEFFDEDEDDFFE0DDDEFFE0E0DEFFE0DEDEFFE1E0E0FFE4E3E3FFE3E2
      E2FFBABAB9F80F0E0E410000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CECBCA004D4B4A000000
      00000C0B0A00121211001E1B1A006C696800FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007893FB003B40F8000500
      F6001A20F6001D2FF700233DF8006E85FB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000006060627666665B1E3E3
      E2FDF7F7F7FFFCFCFCFFFDFDFDFFFDFDFDFFFCFCFCFFF8F8F8FFE9E8E8FF7776
      76BF0A0A0A36000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BBB8B500000000000000
      0000070706000A09090021202000E8E8E700FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008B9AFC00130BF7001009
      F6001617F6001721F700283CF800EBEEFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000808
      082E2D2D2D73656565AA878787C88A8A8ACA6A6A6AAF3434347B0B0B0B370000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00727171000707
      07000E0E0D0074737200EFEFEF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7AFB001309
      F7001A17F7007F7FFB00F3F3FF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object DropTextSource1: TDropTextSource
    DragTypes = [dtCopy]
    Left = 61
    Top = 177
  end
end
