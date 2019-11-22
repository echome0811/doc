object ACBRedeemDateFrm: TACBRedeemDateFrm
  Left = 0
  Top = 0
  Width = 1028
  Height = 506
  TabOrder = 0
  TabStop = True
  object Splitter1: TSplitter
    Left = 190
    Top = 4
    Width = 3
    Height = 502
    Cursor = crHSplit
  end
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 1028
    Height = 4
    Align = alTop
    Shape = bsSpacer
  end
  object Panel_Left: TPanel
    Left = 0
    Top = 4
    Width = 190
    Height = 502
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel_Left'
    TabOrder = 1
    TabStop = True
    object List_ID: TListBox
      Left = 0
      Top = 72
      Width = 190
      Height = 430
      Align = alClient
      BevelInner = bvNone
      BorderStyle = bsNone
      Color = 8454143
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
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
      TabStop = True
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
        ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
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
      TabOrder = 3
      TabStop = True
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
      TabOrder = 2
      TabStop = True
    end
  end
  object Panel_Right: TPanel
    Left = 193
    Top = 4
    Width = 835
    Height = 502
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    TabStop = True
    object Panel2: TPanel
      Left = 0
      Top = 24
      Width = 835
      Height = 478
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      TabStop = True
      object Bevel4: TBevel
        Left = 0
        Top = 460
        Width = 835
        Height = 18
        Align = alBottom
        Shape = bsSpacer
      end
      object Bevel6: TBevel
        Left = 821
        Top = 32
        Width = 14
        Height = 205
        Align = alRight
        Shape = bsSpacer
      end
      object Bevel5: TBevel
        Left = 0
        Top = 0
        Width = 835
        Height = 32
        Align = alTop
        Shape = bsSpacer
      end
      object Btn_Refresh: TSpeedButton
        Left = 145
        Top = 0
        Width = 62
        Height = 33
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
      object Splitter2: TSplitter
        Left = 0
        Top = 32
        Width = 1
        Height = 205
        Cursor = crHSplit
      end
      object btnAddAlldoc: TSpeedButton
        Left = 25
        Top = 0
        Width = 120
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
      object Btn_RedeemReason: TSpeedButton
        Left = 208
        Top = 0
        Width = 89
        Height = 33
        Caption = '>>'#36174#22238#21407#22240
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Btn_RedeemReasonClick
      end
      object spl1: TSplitter
        Left = 0
        Top = 237
        Width = 835
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object ListValue: TdxTreeList
        Left = 1
        Top = 32
        Width = 820
        Height = 205
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
        HideSelection = False
        Options = [aoColumnSizing, aoEditing, aoTabThrough, aoImmediateEditor]
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
          Width = 35
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A1: TdxTreeListColumn
          Alignment = taRightJustify
          Caption = #24320#22987#26085#26399
          HeaderAlignment = taCenter
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A2: TdxTreeListColumn
          Alignment = taCenter
          Caption = #20572#27490#26085#26399
          HeaderAlignment = taCenter
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A3: TdxTreeListColumn
          Visible = False
          Width = 80
          BandIndex = 0
          RowIndex = 0
        end
        object Column_Price: TdxTreeListColumn
          Caption = #20215#26684
          HeaderAlignment = taCenter
          BandIndex = 0
          RowIndex = 0
        end
        object Column_Reason: TdxTreeListMRUColumn
          Alignment = taLeftJustify
          Caption = #21407#22240
          HeaderAlignment = taCenter
          Width = 150
          BandIndex = 0
          RowIndex = 0
          OnChange = Column_ReasonChange
          DropDownListStyle = True
          ImmediateDropDown = True
          OnButtonClick = Column_ReasonButtonClick
        end
      end
      object ListValue_doc: TdxTreeList
        Left = 0
        Top = 240
        Width = 835
        Height = 220
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
        TabOrder = 1
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
        Left = 312
        Top = 8
        Width = 97
        Height = 17
        Caption = #26174#31034#20844#21578#21015#34920
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = chkVClick
      end
    end
    object Panel_NowID: TPanel
      Left = 0
      Top = 0
      Width = 835
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
      TabStop = True
    end
  end
end
