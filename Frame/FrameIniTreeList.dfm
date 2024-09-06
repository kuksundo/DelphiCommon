object IniTreeListFr: TIniTreeListFr
  Left = 0
  Top = 0
  Width = 386
  Height = 489
  TabOrder = 0
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 386
    Height = 45
    Align = alTop
    Color = clWhite
    TabOrder = 0
    object SearchEdit: TEdit
      Left = 1
      Top = 21
      Width = 359
      Height = 23
      Align = alClient
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
      OnChange = SearchEditChange
      OnKeyDown = SearchEditKeyDown
      ExplicitHeight = 21
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 384
      Height = 20
      Align = alTop
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      object SectionRB: TRadioButton
        Left = 1
        Top = 1
        Width = 88
        Height = 18
        Align = alLeft
        Caption = 'Section'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object NameRB: TRadioButton
        Left = 89
        Top = 1
        Width = 76
        Height = 18
        Align = alLeft
        Caption = 'Name'
        TabOrder = 1
      end
      object DescRB: TRadioButton
        Left = 165
        Top = 1
        Width = 80
        Height = 18
        Align = alLeft
        Caption = 'Desc'
        TabOrder = 2
      end
    end
    object BitBtn1: TBitBtn
      Left = 360
      Top = 21
      Width = 25
      Height = 23
      Align = alRight
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF4D74AB234179C5ABA7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF4173AF008EEC009AF41F4B80FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFF2F6EB22BA7
        F516C0FF00A0F3568BC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFEFFFF2974BB68C4F86BD4FF279CE66696C8FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3D8FD5A4E3FEB5EEFF4CAA
        E7669DD2FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEA188898A6A6A93736E866567B0
        9595BAA8B1359EE8BDF5FF77C4EF63A1DAFFFFFFFFFFFFFFFFFFFFFFFFD7CDCD
        7E5857DFD3CBFFFFF7FFFFE7FFFEDBD6BB9E90584D817B8E1794E46BB5E9FFFF
        FFFFFFFFFFFFFFFFFFFFEDE9E9886565FFFFFFFFFFFFFDF8E8FAF2DCF8EDCFFF
        F1CFF6DEBA9F5945C0C7D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA38889F6EFEA
        FFFFFFFEFBF5FBF7E8F9F4DAF5EBCCE6CEACF3DAB8E2BD99AB8B8EFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF937674FFFFFFFDFBF1FCF8EEFAF3E1FCF5E3F7F0D7F0
        DFC1E7C9A9F0D1ABA87E75F8F6F6FFFFFFFFFFFFFFFFFFFFFFFF997D7AFFFFFC
        F9F2E1FAF3DEFAF7E5FAF1DCF1DFC0EDD9BAECD8B9EDCAA5AF8679EDE8E9FFFF
        FFFFFFFFFFFFFFFFFFFF9C807BFFFFEBF9EED5FAF1D7F9F2DAF2E3C6FEFBF9FF
        FFF0EFDFC0E9C69EB0857BF5F2F3FFFFFFFFFFFFFFFFFFFFFFFFAF9596F7EAC8
        F9EBCCEFDCBEF4E4C7F0E1C5FDFCECFAF5DDEFDCBCDFB087B59A9AFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFDED4D7BA998CFDECC4EDD4B0E5CAA8EFDBBFF2E3C4F2
        DEBCEABF93BB8E7DE7DFE2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCEBFC5
        BE9A8DE6C7A5EFCBA3ECC8A2E8BE94DCAA86BE9585DFD6D7FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E4E6C9B3B4B99C93C3A097BF9F96CC
        B9B7F1EEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      TabOrder = 2
      OnClick = BitBtn1Click
    end
  end
  object TreeList1: TTreeList
    Left = 0
    Top = 61
    Width = 386
    Height = 428
    Align = alClient
    HideSelection = False
    Indent = 19
    MultiSelectStyle = [msControlSelect, msShiftSelect]
    TabOrder = 1
    Visible = True
    OnDblClick = TreeList1DblClick
    Columns = <>
    Separator = ';'
    ItemHeight = 16
    HeaderSettings.AllowResize = True
    HeaderSettings.Color = clBtnFace
    HeaderSettings.Font.Charset = DEFAULT_CHARSET
    HeaderSettings.Font.Color = clWindowText
    HeaderSettings.Font.Height = -11
    HeaderSettings.Font.Name = 'Tahoma'
    HeaderSettings.Font.Style = []
    HeaderSettings.Height = 18
    Version = '1.1.1.2'
  end
end
