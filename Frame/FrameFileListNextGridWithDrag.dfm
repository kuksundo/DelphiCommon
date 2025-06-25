object FileListGridFr: TFileListGridFr
  Left = 0
  Top = 0
  Width = 660
  Height = 472
  Ctl3D = True
  ParentBackground = False
  ParentCtl3D = False
  TabOrder = 0
  object AttachmentLabel: TJvLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 92
    Height = 428
    Align = alLeft
    Alignment = taCenter
    AutoSize = False
    Caption = 'Attachments'
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
    ExplicitLeft = 12
    ExplicitTop = 8
    ExplicitHeight = 153
  end
  object fileGrid: TNextGrid
    Left = 98
    Top = 0
    Width = 562
    Height = 434
    Margins.Left = 40
    Margins.Top = 0
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Align = alClient
    Caption = ''
    Options = [goGrid, goHeader, goMultiSelect, goSelectFullRow]
    PopupMenu = PopupMenu1
    SelectionColor = 12615680
    TabOrder = 0
    TabStop = True
    object NxIncrementCol: TNxIncrementColumn
      Alignment = taCenter
      DefaultWidth = 32
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
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
      Width = 32
    end
    object FileName: TNxButtonColumn
      DefaultWidth = 200
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'File Name'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coAutoSize, coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Width = 200
      ButtonCaption = '...'
      ButtonWidth = 25
    end
    object FileSize: TNxTextColumn
      Alignment = taRightJustify
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'File Size'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 2
      SortType = stAlphabetic
    end
    object FilePath: TNxTextColumn
      DefaultWidth = 200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Path'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
      Visible = False
      Width = 200
    end
    object DocFormat: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'Doc Format'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 4
      SortType = stAlphabetic
      Visible = False
      Width = 120
    end
    object FileID: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'FileID'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 5
      SortType = stAlphabetic
      Width = 120
    end
    object CompressAlgo: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'CompressAlgo'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 6
      SortType = stAlphabetic
      Visible = False
      Width = 120
    end
    object FileSaveKind: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'FileSaveKind'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 7
      SortType = stAlphabetic
      Visible = False
      Width = 120
    end
    object SavedFileName: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'SavedFileName'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 8
      SortType = stAlphabetic
      Visible = False
      Width = 120
    end
    object FileDesc: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'FileDesc'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 9
      SortType = stAlphabetic
      Visible = False
      Width = 120
    end
    object FileFromSource: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'FileFromSource'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 10
      SortType = stAlphabetic
      Visible = False
      Width = 120
    end
    object BaseDir: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'BaseDir'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 11
      SortType = stAlphabetic
      Visible = False
      Width = 120
    end
    object IsNew: TNxCheckBoxColumn
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 12
      SortType = stBoolean
      Visible = False
    end
    object IsDelete: TNxCheckBoxColumn
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 13
      SortType = stBoolean
      Visible = False
    end
    object IsUpdate: TNxCheckBoxColumn
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 14
      SortType = stBoolean
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 434
    Width = 660
    Height = 38
    Align = alBottom
    TabOrder = 1
    object CloseButton: TAdvGlowButton
      AlignWithMargins = True
      Left = 531
      Top = 4
      Width = 125
      Height = 30
      Align = alRight
      Caption = 'Close'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ImageIndex = 4
      ModalResult = 2
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Picture.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000002BA4944415478DA75926D48535118C7FFF7ECC56D6E53A738DD142903
        2DCB8C2249A9D98B36F305DD270BB1572A09AC1034A82F1115459F85C8220A42
        A340C23ED4874828294B332A9B953672BAB9DADDDCDD74DEDDDDDBC917C46ACF
        F9F69CC3EFFCCEF33F0C6254F5C3892FD1703093E738213C1D023F1D44786616
        09A64CE80C4948D26B9840880F30B100151D1ED7606B599A021C561557206B6D
        01D2576422D1B4920252B0224D877B2F9CB33101D63B4E67EF894DE6F26B0F50
        B7B7182C0BC8E4004F2D22B311E835048F5EBB823101059DA1891F8DB9E985AD
        EDB0D6EC82DFEB05A4A57D7DBC12CFDFFD05600D198A24D669A7CDEC351DA121
        CFF19CD579A7DA506A2B83CFCB8261E68F4B14A4D32AD037F01F037F49B19420
        063F986ABB03812B96E2F5072F616B6D15A6A8C12280A14B470DFA07C7838C6F
        7F5D9424EA084411924C06C637067D9E098F47B251D97E19B9CD37515A6D85FF
        173520809C104822E0112478ECD420D87A342C63BFC74944011039A25C109263
        04BA9D163CEDECC1B1928B5867AB843AC8825083A9B0002FC723A25042E67453
        83C6FAB0E2E59338687540548248AF89525022E1E9D83528333620FFDC69F4BD
        B2634A9423C247E74044AD0471D027B80AF3A30CE723209448A439C5442280E7
        22D8FC751C9F4FDEC7CFB345C8B96A8736CB049924CCA521AA94881B1DFB7788
        C329A99209E1C9426B9B30F4ECBC59BFA51106CB1E48FC0CE432663E491A83A8
        5241FDCDB11CF02621994444DE5DC471A9C967FA0754D7776FF0EF6881B1A21E
        51D64DC7BF707C01A01A1E89FD918C4D3D2ED95D5B9A6F5B33D22A1A20F82731
        17C32240A381F2933D1413603ED0352D761D52FB8B9A60B41D86E0752F03205E
        03667008310119FB3AAAC4EE2360B75FB86DACAA31087FBEF2D213DE42AB798F
        FE8FDD31018B1557736BD85C6E51857DBE1B0C617A696B74BC65A36371FF37BB
        A7236C7053B8330000000049454E44AE426082}
      TabOrder = 0
      Visible = False
      Appearance.ColorChecked = 16111818
      Appearance.ColorCheckedTo = 16367008
      Appearance.ColorDisabled = 15921906
      Appearance.ColorDisabledTo = 15921906
      Appearance.ColorDown = 16111818
      Appearance.ColorDownTo = 16367008
      Appearance.ColorHot = 16117985
      Appearance.ColorHotTo = 16372402
      Appearance.ColorMirrorHot = 16107693
      Appearance.ColorMirrorHotTo = 16775412
      Appearance.ColorMirrorDown = 16102556
      Appearance.ColorMirrorDownTo = 16768988
      Appearance.ColorMirrorChecked = 16102556
      Appearance.ColorMirrorCheckedTo = 16768988
      Appearance.ColorMirrorDisabled = 11974326
      Appearance.ColorMirrorDisabledTo = 15921906
    end
    object DeleteButton: TAdvGlowButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 117
      Height = 30
      Align = alLeft
      Caption = 'Delete'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ImageIndex = 2
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Picture.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000002A54944415478DA8D536D4B536118BE9EF3E6399EA933DD2CD15C8D6C
        441924151442F9929B34855110F4CDE84B1FFB0F7D0AFA07FAC58F91A446BA84
        30AC240389244B69852F4DB7B9B6E5CECE713B2F3DDBCC9728F13A3CF0709EFB
        BAEEFBBA9FE726F80BE9E696AE6C4E0F58754EBF2970B205FAA959C55A898E88
        25C2A07DE6F5F3DDF1649BD8D22EE92965889CF374B06DCDE09DE5204C31C2D0
        012D9A4432380DFEC3FC78D5A1CA1E69F285BA2D90B8DC2A929416126E5FABE5
        CFD703CB4B30D67F0266519CA1424C751548830BE1B7F3480F04C32EA7C32D4D
        06B58240BCE9D2987CABAD937195C2985F00388132382A6F01965510B14C03D0
        73903C1E7C9F5D05F3F44DD035F7DE4BD69A5BBCB653C74685F6E3301642005F
        524C9907CBEEECF330A8889681D8E8C6DCB3595487223E12BDD8D667F79FE935
        3663B052992D570416CD66FD4A02D94D9A3EEF832EA914ACCD0EBEA61249CE8E
        E4E04C3F8979FD91F2B3654E335B0DE1EE3D6A9B762C9EA4620910B2A7CF856A
        082F22F7F001B24708D6D7A428895DEF56CB4F0A622622C23E30808320DE7A15
        B6C83B7C4D5468241C08A8953FA6C4A8780247275E1D4860C9E7C3E1D5297C5B
        6634F2A5BE21E296D3CE4F4639A4EE1B2026B5609AFF66520B16BD1D75F8094E
        CB2A3E2F66A3648A93FA9A1A1DBD30B2C8C5E228766C3F10F08E2A7A43023E86
        12FD6494485E8F531EADAB10A1E8263D26FBD2F34F5BE618ACA4342C44155F21
        7A9811C7AED4547496702C54D3FCAF44BE3689DAD8D40D4C4452C16E53F31662
        1F3382C8B34CA8B5ACACD646453296899CF587B255368D2CA5C391A6E4971B1B
        E19C61BA6F9A596D3B591F3889B668E8826CEB68E038C80CBB27BB429FF2A2AE
        635A498FD31A7BEE40DF19A6DD7804D2E500139059D62F8191F3FF54988A6218
        23319883F761ED19E7DF9DE00B5A1C2131D10000000049454E44AE426082}
      TabOrder = 1
      OnClick = DeleteButtonClick
      Appearance.ColorChecked = 16111818
      Appearance.ColorCheckedTo = 16367008
      Appearance.ColorDisabled = 15921906
      Appearance.ColorDisabledTo = 15921906
      Appearance.ColorDown = 16111818
      Appearance.ColorDownTo = 16367008
      Appearance.ColorHot = 16117985
      Appearance.ColorHotTo = 16372402
      Appearance.ColorMirrorHot = 16107693
      Appearance.ColorMirrorHotTo = 16775412
      Appearance.ColorMirrorDown = 16102556
      Appearance.ColorMirrorDownTo = 16768988
      Appearance.ColorMirrorChecked = 16102556
      Appearance.ColorMirrorCheckedTo = 16768988
      Appearance.ColorMirrorDisabled = 11974326
      Appearance.ColorMirrorDisabledTo = 15921906
    end
    object AddButton: TAdvGlowButton
      AlignWithMargins = True
      Left = 127
      Top = 4
      Width = 125
      Height = 30
      Align = alLeft
      Caption = 'Add'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ImageIndex = 1
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Picture.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000003264944415478DA8D935D6C53651CC67F6F4FDB9DD26E5D194559619B
        9B0337BF264AD0A14125EDA6817D7921C131A30425042EC444634C144D085E41
        0C0461485486860B65A32CCAB6882C866982289A089165848DB4A454E8C7DA9D
        D3F69CD6C359B26C5EF15CBD79FFCFFB4BFE799F47F07FB5D04C396D95B2BBDD
        ED713BEF5C256289F4B89AE8254C1F414ECFB68B99531776B2F477B53EE9DFD0
        D8C41315F5B829354709E2FC3671896F4606387AF2D721C3B996A3867B06B005
        1B3AA19EB7B67B3BEA5EE4B63AC985C808DF5E0B9AE397AB3B78CCBB128FECE2
        C4E5EFD9B8775F14091F07C94D033A193CBEF37D7F53CD2A46C267B99D1D253C
        E5E59DFA43E678C3D95A5A6B96532C55D158FE2C0363E758BF73D710C708085E
        25B0A5BD65E0E3D6D7F861BC97BC5051F51849E5BE1940E7F0FDACA97A1821EC
        580A322F54B6F3C1C92F38D81B6C12E26DA9FBF48EDD9B15DB2837D25163173B
        092DCA1FA1717A568F99808DC335AC5CBC0C87544CCE587D91D38B23574BF39E
        F70E8BFA4F2A238776742E1CBC348CA4ACE01FF53B2C4222998D10F4A74D40C7
        8F1E9CD6F9E8058D65F24BE88EF304EA57F3E69E633745C3A73EE5F36D5BE503
        E7BEE6C8337F7337DAF4F3836C5DF50AAFEF3FA08AA7BFAC537677AE97BB4E7D
        C8D5B6C25D01AAFB043DEB3EE2DDAF8EABE2A1CF16475A5AEF5978EAE205C2CA
        5CE3BF1DD3C00527040B8C4868C6391E877207AC6B789CFE60E4A6B877AFDCFD
        D4F3EECD259283A81A2593CF1057346239185B330D78E08C01B041A95C8AB0E4
        2993E793D4157E3993382C3CBB9C814756B8067C55F350923A16AB8598728BEB
        CA24579E9B062CFD49B0C4518CC751465ECBE32891085D9BE2AFF3A92633484B
        F63B071B1ACBFC4536894C268F6A44F7F7F1C49C159657BA918D68171559C8E4
        742E8EDC1ABABE2D1D300115FB9CB6792596D0D2473DDE229B15F2052E872608
        C7741350EE91A8F35560FCAFF158E3CA9FB1E85432EF9BD89ECECD94A9BADB61
        B759ADFD8B6A5C7E57B11D57890DAB91873BD20A3AA9648ED464961B63A9A19C
        A6ADBDFA8632AB4CB3547BC4D9EC2AB5B65925A9DD6217669DF3D9425AD3F5DE
        545CEB1BDD949E53E7FF00E0CB305493330DEC0000000049454E44AE426082}
      TabOrder = 2
      OnClick = AddButtonClick
      Appearance.ColorChecked = 16111818
      Appearance.ColorCheckedTo = 16367008
      Appearance.ColorDisabled = 15921906
      Appearance.ColorDisabledTo = 15921906
      Appearance.ColorDown = 16111818
      Appearance.ColorDownTo = 16367008
      Appearance.ColorHot = 16117985
      Appearance.ColorHotTo = 16372402
      Appearance.ColorMirrorHot = 16107693
      Appearance.ColorMirrorHotTo = 16775412
      Appearance.ColorMirrorDown = 16102556
      Appearance.ColorMirrorDownTo = 16768988
      Appearance.ColorMirrorChecked = 16102556
      Appearance.ColorMirrorCheckedTo = 16768988
      Appearance.ColorMirrorDisabled = 11974326
      Appearance.ColorMirrorDisabledTo = 15921906
    end
    object ApplyButton: TAdvGlowButton
      AlignWithMargins = True
      Left = 400
      Top = 4
      Width = 125
      Height = 30
      Align = alRight
      Caption = 'Apply'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ImageIndex = 3
      ModalResult = 1
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Picture.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000001FC4944415478DAC5924F48937118C7BFEF84E97486AF465BAFFB9F98
        7FA89C11D13AD925B63AA4E4A53C2881D531A4831E3A88151D32FA03DE9228B0
        20886AA6081E8268064692522D37B3ADB61F6EF56ECEBDEB5DEF7A6A3B0CCC46
        4A879ECBC3EFF9F379BE3CCF8FC33F1AF75F00875FEDA7E9B0BF8FB9D8C50D03
        4CE35BA8C5E8809DDF89A1999B1B53609B10E880E08053706222F108CFE666D6
        0F308FE9E8584D2BDA8C4770237C0D73E17760F3D2FA00DA91723AB3BB2B75D4
        DCAAB9143C0F9FB888903709A592FA7280D261EDE5AC97BA567A7E6F2EBBA5A5
        F61D0771B2BE13578283084A9FC1BC12127119D1EE08C7ED79DA48A71BDAF192
        CD6378FA61169257553EB2891C96A6D439FB59CD50E03A7CD202BEF815889124
        A2A722B93AAEC5D34475028FBAE2664C065E6372760AC91309AEE2364F36A301
        837BFBF180DD8727E6415A2C02F3C5C1BA97F24338FD137D6F73B5FE42955683
        EA925A4C2D7A312B7AB1B984C7D57D0378F1F5391E4747910C0119F907DEB77D
        5CB5B7DCC3E436D02E8B0E6AB50A82DA8A34F71DCE0A17FCBF24DF0DDF832CAA
        10631202C7436B969E0FD4B84D546BA9028A085B8B0598D4DB30BA340E394E48
        4B19BC3DF4E18F175B15DCEEB690D5CA4326052BB20439A6822267F0C6B550F0
        DC6B128D6336AAD4956139F60DE9945270724140D60C7704CAFA4F1DA1BF7EB4
        9F60D4C73924D0A57C0000000049454E44AE426082}
      TabOrder = 3
      Visible = False
      Appearance.ColorChecked = 16111818
      Appearance.ColorCheckedTo = 16367008
      Appearance.ColorDisabled = 15921906
      Appearance.ColorDisabledTo = 15921906
      Appearance.ColorDown = 16111818
      Appearance.ColorDownTo = 16367008
      Appearance.ColorHot = 16117985
      Appearance.ColorHotTo = 16372402
      Appearance.ColorMirrorHot = 16107693
      Appearance.ColorMirrorHotTo = 16775412
      Appearance.ColorMirrorDown = 16102556
      Appearance.ColorMirrorDownTo = 16768988
      Appearance.ColorMirrorChecked = 16102556
      Appearance.ColorMirrorCheckedTo = 16768988
      Appearance.ColorMirrorDisabled = 11974326
      Appearance.ColorMirrorDisabledTo = 15921906
    end
  end
  object DropEmptyTarget1: TDropEmptyTarget
    DragTypes = [dtCopy, dtLink]
    OnDrop = DropEmptyTarget1Drop
    Target = fileGrid
    Left = 12
    Top = 60
  end
  object VirtualDataAdapter4Target: TDataFormatAdapter
    DragDropComponent = DropEmptyTarget1
    DataFormatName = 'TVirtualFileStreamDataFormat'
    Left = 48
    Top = 60
  end
  object FileDataAdapter4Target: TDataFormatAdapter
    DragDropComponent = DropEmptyTarget1
    DataFormatName = 'TFileDataFormat'
    Left = 82
    Top = 60
  end
  object DropEmptySource1: TDropEmptySource
    DragTypes = [dtCopy, dtMove]
    Left = 12
    Top = 108
  end
  object VirtualDataAdapter4Source: TDataFormatAdapter
    DragDropComponent = DropEmptySource1
    DataFormatName = 'TVirtualFileStreamDataFormat'
    Left = 52
    Top = 111
  end
  object PopupMenu1: TPopupMenu
    Left = 120
    Top = 112
    object DeleteFile1: TMenuItem
      Caption = 'Delete Selected File(s)'
      OnClick = DeleteFile1Click
    end
  end
  object OutlookDataAdapter4Target: TDataFormatAdapter
    DragDropComponent = DropEmptyTarget1
    DataFormatName = 'TOutlookDataFormat'
    Left = 114
    Top = 60
  end
end
