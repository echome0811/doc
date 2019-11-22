object ACBStopConvFrm: TACBStopConvFrm
  Left = 0
  Top = 0
  Width = 889
  Height = 366
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
    Height = 362
    Cursor = crHSplit
  end
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 889
    Height = 4
    Align = alTop
    Shape = bsSpacer
  end
  object Panel_Left: TPanel
    Left = 0
    Top = 4
    Width = 190
    Height = 362
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel_Left'
    TabOrder = 0
    object List_ID: TListBox
      Left = 0
      Top = 72
      Width = 190
      Height = 290
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
      TabOrder = 2
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
      TabOrder = 3
    end
  end
  object Panel_Right: TPanel
    Left = 193
    Top = 4
    Width = 696
    Height = 362
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 24
      Width = 696
      Height = 338
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object Bevel3: TBevel
        Left = 0
        Top = 32
        Width = 25
        Height = 288
        Align = alLeft
        Shape = bsSpacer
      end
      object Bevel4: TBevel
        Left = 0
        Top = 320
        Width = 696
        Height = 18
        Align = alBottom
        Shape = bsSpacer
      end
      object Bevel6: TBevel
        Left = 672
        Top = 32
        Width = 24
        Height = 288
        Align = alRight
        Shape = bsSpacer
      end
      object Bevel5: TBevel
        Left = 0
        Top = 0
        Width = 696
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
        Left = 289
        Top = 32
        Width = 1
        Height = 288
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
      object ListValue: TdxTreeList
        Left = 25
        Top = 32
        Width = 264
        Height = 288
        Bands = <
          item
          end>
        DefaultLayout = True
        HeaderPanelRowCount = 1
        Align = alLeft
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
          Width = 40
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A1: TdxTreeListColumn
          Alignment = taRightJustify
          Caption = #24320#22987#26085#26399
          HeaderAlignment = taCenter
          Width = 110
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A2: TdxTreeListColumn
          Alignment = taCenter
          Caption = #20572#27490#26085#26399
          HeaderAlignment = taCenter
          Width = 110
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A3: TdxTreeListColumn
          Visible = False
          BandIndex = 0
          RowIndex = 0
        end
      end
      object ListValue_doc: TdxTreeList
        Left = 290
        Top = 32
        Width = 382
        Height = 288
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
        OnCustomDrawCell = ListValueCustomDrawCell
        object Column_Num_doc: TdxTreeListColumn
          Alignment = taCenter
          Caption = #24207#21495
          HeaderAlignment = taCenter
          ReadOnly = True
          Width = 25
          BandIndex = 0
          RowIndex = 0
        end
        object Column_Chk: TdxTreeListCheckColumn
          Alignment = taCenter
          Caption = #21246#36873
          HeaderAlignment = taCenter
          MinWidth = 20
          Width = 20
          BandIndex = 0
          RowIndex = 0
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object Column_A5_doc: TdxTreeListColumn
          Caption = #20844#21578#31867#22411
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
          Width = 131
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A4_doc: TdxTreeListColumn
          Visible = False
          Width = 82
          BandIndex = 0
          RowIndex = 0
        end
      end
    end
    object Panel_NowID: TPanel
      Left = 0
      Top = 0
      Width = 696
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
