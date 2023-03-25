object TreeViewFrame: TTreeViewFrame
  Left = 0
  Top = 0
  Width = 295
  Height = 352
  TabOrder = 0
  object EngModbusTV: TJvCheckTreeView
    Left = 0
    Top = 54
    Width = 295
    Height = 298
    Align = alClient
    Indent = 19
    TabOrder = 0
    OnDblClick = EngModbusTVDblClick
    CheckBoxOptions.Style = cbsNone
    ExplicitWidth = 279
    ExplicitHeight = 141
  end
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 295
    Height = 27
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 279
    object SrchTextEdit: TEdit
      Left = 1
      Top = 1
      Width = 293
      Height = 25
      Align = alClient
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
      OnChange = SrchTextEditChange
      ExplicitWidth = 277
      ExplicitHeight = 21
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 295
    Height = 27
    Hint = 'ParentBackground'#47484' False'#47196' '#54616#47732' '#44160#51221#49353#51060' '#49324#46972#51664
    Align = alTop
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 2
    ExplicitWidth = 279
    object EngModbusFilterCheck: TCheckBox
      Left = 1
      Top = 1
      Width = 44
      Height = 25
      Align = alLeft
      Alignment = taLeftJustify
      Caption = 'Filter'
      TabOrder = 0
      OnClick = EngModbusFilterCheckClick
    end
    object FilterCheckcb: TCheckComboBox
      Left = 45
      Top = 1
      Width = 208
      Height = 22
      Align = alClient
      AutoComplete = False
      Enabled = False
      TabOrder = 1
      OnCloseUp = FilterCheckcbCloseUp
      Items.Strings = (
        'Sensor'
        'Param'
        'Alarm'
        'Actuator')
      Caption = ''
      ExplicitWidth = 192
    end
    object FilterClearBtn: TButton
      Left = 253
      Top = 1
      Width = 41
      Height = 25
      Align = alRight
      Caption = 'Clear'
      Enabled = False
      TabOrder = 2
      OnClick = FilterClearBtnClick
      ExplicitLeft = 237
    end
  end
end
