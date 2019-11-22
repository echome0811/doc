object ACBStike2Frm: TACBStike2Frm
  Left = 0
  Top = 0
  Width = 806
  Height = 364
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 190
    Top = 4
    Width = 3
    Height = 360
    Cursor = crHSplit
  end
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 806
    Height = 4
    Align = alTop
    Shape = bsSpacer
  end
  object Panel_Left: TPanel
    Left = 0
    Top = 4
    Width = 190
    Height = 360
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel_Left'
    TabOrder = 0
    object List_ID: TListBox
      Left = 0
      Top = 72
      Width = 190
      Height = 288
      Align = alClient
      BevelInner = bvNone
      BorderStyle = bsNone
      Color = 8454143
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 20
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = List_IDClick
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 190
      Height = 24
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 2
      Caption = #25628#23547#20195#30721
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Txt_ID: TEdit
        Left = 68
        Top = 2
        Width = 115
        Height = 20
        BorderStyle = bsNone
        Color = 8454143
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = Txt_IDChange
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 24
      Width = 190
      Height = 24
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 2
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object SpeedButton3: TSpeedButton
        Left = 124
        Top = 2
        Width = 54
        Height = 19
        Caption = #20462#25913
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton3Click
      end
      object SpeedButton1: TSpeedButton
        Left = 1
        Top = 2
        Width = 54
        Height = 19
        Caption = #26032#22686
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TSpeedButton
        Left = 68
        Top = 2
        Width = 51
        Height = 19
        Caption = #21024#38500
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton2Click
      end
    end
    object Panel_Memo: TPanel
      Left = 0
      Top = 48
      Width = 190
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 2
      Caption = #35831#36755#20837#36716#20538#20195#30721
      Color = clMaroon
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object Panel_Right: TPanel
    Left = 193
    Top = 4
    Width = 613
    Height = 360
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 24
      Width = 613
      Height = 336
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object Bevel4: TBevel
        Left = 0
        Top = 318
        Width = 613
        Height = 18
        Align = alBottom
        Shape = bsSpacer
      end
      object Bevel6: TBevel
        Left = 589
        Top = 56
        Width = 24
        Height = 110
        Align = alRight
        Shape = bsSpacer
      end
      object Bevel5: TBevel
        Left = 0
        Top = 24
        Width = 613
        Height = 32
        Align = alTop
        Shape = bsSpacer
      end
      object Btn_Refresh: TSpeedButton
        Left = 115
        Top = 32
        Width = 51
        Height = 19
        Caption = '>>'#21047#26032
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Btn_RefreshClick
      end
      object Btn_Delete: TSpeedButton
        Left = 170
        Top = 32
        Width = 51
        Height = 19
        Caption = '>>'#21024#38500
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Btn_DeleteClick
      end
      object Btn_Insert: TSpeedButton
        Left = 223
        Top = 32
        Width = 51
        Height = 19
        Caption = '>>'#25554#20837
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Btn_InsertClick
      end
      object Btn_MoveUp: TSpeedButton
        Left = 330
        Top = 32
        Width = 51
        Height = 19
        Caption = '>>'#19978#31227
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Btn_MoveUpClick
      end
      object Btn_MoveDwn: TSpeedButton
        Left = 384
        Top = 32
        Width = 51
        Height = 19
        Caption = '>>'#19979#31227
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Btn_MoveDwnClick
      end
      object Btn_Add: TSpeedButton
        Left = 276
        Top = 32
        Width = 51
        Height = 19
        Caption = '>>'#26032#22686
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Btn_AddClick
      end
      object Btn_Strik2Reason: TSpeedButton
        Left = 435
        Top = 32
        Width = 73
        Height = 19
        Caption = '>>'#36716#32929#21407#22240
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Btn_Strik2ReasonClick
      end
      object btnAddAlldoc: TSpeedButton
        Left = 2
        Top = 23
        Width = 111
        Height = 33
        Caption = '>>'#21152#36617#20840#37096#20844#21578
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = btnAddAlldocClick
      end
      object ListValue: TdxTreeList
        Left = 0
        Top = 56
        Width = 589
        Height = 110
        Bands = <
          item
          end>
        DefaultLayout = True
        HeaderPanelRowCount = 1
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        BandFont.Charset = DEFAULT_CHARSET
        BandFont.Color = clWindowText
        BandFont.Height = -11
        BandFont.Name = 'MS Sans Serif'
        BandFont.Style = []
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'MS Sans Serif'
        HeaderFont.Style = []
        Options = [aoColumnSizing, aoEditing, aoTabThrough, aoImmediateEditor, aoAutoWidth]
        OptionsEx = [aoUseBitmap, aoBandHeaderWidth, aoAutoCalcPreviewLines, aoBandSizing, aoBandMoving, aoEnterShowEditor, aoDragScroll, aoDragExpand, aoRowAutoHeight]
        PreviewFont.Charset = DEFAULT_CHARSET
        PreviewFont.Color = clBlue
        PreviewFont.Height = -11
        PreviewFont.Name = 'MS Sans Serif'
        PreviewFont.Style = []
        TreeLineColor = clGrayText
        ShowGrid = True
        ShowRoot = False
        OnClick = ListValueClick
        OnCustomDrawCell = ListValueCustomDrawCell
        OnEditChange = ListValueEditChange
        OnEdited = ListValueEdited
        OnEditing = ListValueEditing
        object Column_Num: TdxTreeListColumn
          Alignment = taCenter
          Caption = #24207#21495
          HeaderAlignment = taCenter
          ReadOnly = True
          Width = 68
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A4: TdxTreeListColumn
          Alignment = taRightJustify
          Caption = #38500#26435#65288#24687#65289#20132#26131#26085
          HeaderAlignment = taCenter
          Width = 110
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A1: TdxTreeListColumn
          Alignment = taRightJustify
          Caption = #20215#26684#35843#25972#26085
          HeaderAlignment = taCenter
          Width = 89
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A2: TdxTreeListColumn
          Alignment = taRightJustify
          Caption = #36716#32929#20215#26684
          HeaderAlignment = taCenter
          Width = 75
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A3: TdxTreeListMRUColumn
          Alignment = taLeftJustify
          Caption = #36716#32929#21407#22240
          HeaderAlignment = taCenter
          Width = 240
          BandIndex = 0
          RowIndex = 0
          OnChange = Column_A3Change
          DropDownListStyle = True
          ImmediateDropDown = True
          OnButtonClick = Column_A3ButtonClick
        end
        object Column_A8: TdxTreeListColumn
          Visible = False
          BandIndex = 0
          RowIndex = 0
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 613
        Height = 24
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        BorderWidth = 2
        Caption = #20462#27491#31354#38388':'
        Color = clGray
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object Txt_LowReset: TEdit
          Left = 76
          Top = 2
          Width = 101
          Height = 20
          BorderStyle = bsNone
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'Txt_LowReset'
          OnChange = Txt_LowResetChange
          OnExit = Txt_LowResetExit
        end
      end
      object ListValue_doc: TdxTreeList
        Left = 0
        Top = 166
        Width = 613
        Height = 152
        Bands = <
          item
          end>
        DefaultLayout = True
        HeaderPanelRowCount = 1
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        BandFont.Charset = DEFAULT_CHARSET
        BandFont.Color = clWindowText
        BandFont.Height = -11
        BandFont.Name = 'MS Sans Serif'
        BandFont.Style = []
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'MS Sans Serif'
        HeaderFont.Style = []
        HideSelection = False
        Options = [aoColumnSizing, aoTabThrough, aoAutoWidth, aoAutoSort]
        OptionsEx = [aoUseBitmap, aoBandHeaderWidth, aoAutoCalcPreviewLines, aoBandSizing, aoBandMoving, aoEnterShowEditor, aoDragScroll, aoDragExpand, aoRowAutoHeight, aoAnsiSort]
        PreviewFont.Charset = DEFAULT_CHARSET
        PreviewFont.Color = clBlue
        PreviewFont.Height = -11
        PreviewFont.Name = 'MS Sans Serif'
        PreviewFont.Style = []
        TreeLineColor = clGrayText
        HideSelectionColor = clNavy
        HideSelectionTextColor = clWhite
        ShowGrid = True
        ShowRoot = False
        OnDblClick = ListValue_docDblClick
        object Column_Num_doc: TdxTreeListColumn
          Alignment = taCenter
          Caption = #24207#21495
          HeaderAlignment = taCenter
          ReadOnly = True
          Width = 59
          BandIndex = 0
          RowIndex = 0
        end
        object Column_Chk: TdxTreeListCheckColumn
          Alignment = taCenter
          Caption = #21246#36873
          HeaderAlignment = taCenter
          MinWidth = 20
          Width = 49
          BandIndex = 0
          RowIndex = 0
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object Column_A5_doc: TdxTreeListColumn
          Caption = #20844#21578#31867#22411
          Sorted = csUp
          Width = 50
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A6_doc: TdxTreeListColumn
          Caption = #31181#31867
          Width = 50
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A1_doc: TdxTreeListColumn
          Alignment = taRightJustify
          Caption = #26085#26399
          HeaderAlignment = taCenter
          Width = 70
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A3_doc: TdxTreeListColumn
          Alignment = taLeftJustify
          Caption = #20844#21578
          HeaderAlignment = taCenter
          Width = 399
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A4_doc: TdxTreeListColumn
          Visible = False
          Width = 96
          BandIndex = 0
          RowIndex = 0
        end
      end
      object chkV: TCheckBox
        Left = 511
        Top = 33
        Width = 93
        Height = 17
        Caption = #26174#31034#20844#21578#21015#34920
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = chkVClick
      end
    end
    object Panel_NowID: TPanel
      Left = 0
      Top = 0
      Width = 613
      Height = 24
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 2
      Caption = #30446#21069#27491#22312#32534#36753#20195#30721':'
      Color = clMaroon
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
end
