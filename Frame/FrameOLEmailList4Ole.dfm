object Frame2: TFrame2
  Left = 0
  Top = 0
  Width = 920
  Height = 705
  TabOrder = 0
  object mailPanel1: TPanel
    Left = 0
    Top = 0
    Width = 920
    Height = 705
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
      920
      705)
    object tabMail: TTabControl
      Left = 5
      Top = 57
      Width = 910
      Height = 615
      Align = alClient
      TabOrder = 0
      object StatusBar: TStatusBar
        Left = 4
        Top = 592
        Width = 902
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
        Width = 902
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
        Width = 902
        Height = 559
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        Align = alClient
        AppearanceOptions = [ao3DGridLines, aoAlphaBlendedSelection, aoBoldTextSelection, aoHideSelection]
        Caption = ''
        HeaderSize = 23
        HighlightedTextColor = clHotLight
        Options = [goHeader, goSelectFullRow]
        RowSize = 18
        PopupMenu = PopupMenu1
        TabOrder = 2
        TabStop = True
        OnCellDblClick = grid_MailCellDblClick
        object NxIncrementColumn1: TNxIncrementColumn
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
          ParentFont = False
          Position = 1
          SortType = stAlphabetic
        end
        object Subject: TNxTextColumn
          DefaultWidth = 300
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
          Position = 2
          SortType = stAlphabetic
          Width = 300
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
          Position = 3
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
          Position = 4
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
          Position = 5
          SortType = stAlphabetic
        end
        object Sender: TNxMemoColumn
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
          Position = 6
          SortType = stAlphabetic
        end
        object Receiver: TNxMemoColumn
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
          Position = 7
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
          Position = 8
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
          Position = 9
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
          Position = 10
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
          Position = 11
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
          Position = 12
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
          Position = 13
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
          Position = 14
          SortType = stAlphabetic
        end
        object DBKey: TNxTextColumn
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 15
          SortType = stAlphabetic
          Visible = False
        end
        object SavedMsgFilePath: TNxTextColumn
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 16
          SortType = stAlphabetic
          Visible = False
        end
        object SavedMsgFileName: TNxTextColumn
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Position = 17
          SortType = stAlphabetic
          Visible = False
        end
      end
    end
    object panMailButtons: TPanel
      Left = 5
      Top = 672
      Width = 910
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      object btnStartProgram: TBitBtn
        Left = 16
        Top = 4
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
      end
      object BitBtn1: TBitBtn
        Left = 821
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
    end
    object panProgress: TPanel
      Left = 703
      Top = 650
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
      Width = 910
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
        Left = 448
        Top = 13
        Width = 234
        Height = 17
        Caption = 'Auto Move Email To HullNo Folder'
        TabOrder = 0
      end
      object MoveFolderCB: TComboBox
        Left = 100
        Top = 30
        Width = 342
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
        OnDropDown = MoveFolderCBDropDown
      end
      object SubFolderCB: TCheckBox
        Left = 448
        Top = 33
        Width = 115
        Height = 17
        Caption = 'To Sub-Folder :'
        TabOrder = 2
        OnClick = SubFolderCBClick
      end
      object SubFolderNameEdit: TEdit
        Left = 569
        Top = 29
        Width = 146
        Height = 24
        Enabled = False
        ImeName = 'Microsoft IME 2010'
        TabOrder = 3
      end
      object AutoMoveCB: TCheckBox
        Left = 102
        Top = 9
        Width = 272
        Height = 17
        Caption = 'Email To Move Folder when drag drop'
        TabOrder = 4
      end
    end
  end
  object DropEmptyTarget1: TDropEmptyTarget
    DragTypes = [dtCopy, dtLink]
    OnDrop = DropEmptyTarget1Drop
    Target = grid_Mail
    WinTarget = 0
    Left = 76
    Top = 108
  end
  object DataFormatAdapterOutlook: TDataFormatAdapter
    DragDropComponent = DropEmptyTarget1
    DataFormatName = 'TOutlookDataFormat'
    Left = 108
    Top = 108
  end
  object PopupMenu1: TPopupMenu
    Left = 141
    Top = 109
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
          OnClick = Korean1Click
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
        Checked = True
        OnClick = Send2MQCheckClick
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 173
    Top = 121
  end
end
