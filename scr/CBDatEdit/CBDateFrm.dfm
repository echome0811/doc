object ACBDateFrm: TACBDateFrm
  Left = 0
  Top = 0
  Width = 718
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
    Width = 718
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
      Caption = #35831#36755#20837'Key'#20540#25110#36716#20538#20195#30721
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
    Width = 525
    Height = 360
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 24
      Width = 525
      Height = 336
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object Bevel3: TBevel
        Left = 0
        Top = 32
        Width = 25
        Height = 286
        Align = alLeft
        Shape = bsSpacer
      end
      object Bevel4: TBevel
        Left = 0
        Top = 318
        Width = 525
        Height = 18
        Align = alBottom
        Shape = bsSpacer
      end
      object Bevel6: TBevel
        Left = 501
        Top = 32
        Width = 24
        Height = 286
        Align = alRight
        Shape = bsSpacer
      end
      object Bevel5: TBevel
        Left = 0
        Top = 0
        Width = 525
        Height = 32
        Align = alTop
        Shape = bsSpacer
      end
      object Btn_Refresh: TSpeedButton
        Left = 25
        Top = 8
        Width = 62
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
      object ListValue: TdxTreeList
        Left = 25
        Top = 32
        Width = 476
        Height = 286
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
        OnCustomDrawCell = ListValueCustomDrawCell
        OnEditChange = ListValueEditChange
        OnEdited = ListValueEdited
        OnEditing = ListValueEditing
        object Column_Num: TdxTreeListColumn
          Alignment = taCenter
          Caption = #24207#21495
          HeaderAlignment = taCenter
          ReadOnly = True
          Width = 63
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A1: TdxTreeListColumn
          Alignment = taRightJustify
          Caption = #26631#39064
          HeaderAlignment = taCenter
          Width = 161
          BandIndex = 0
          RowIndex = 0
        end
        object Column_A2: TdxTreeListColumn
          Alignment = taLeftJustify
          Caption = #20869#23481
          HeaderAlignment = taCenter
          Width = 367
          BandIndex = 0
          RowIndex = 0
        end
      end
    end
    object Panel_NowID: TPanel
      Left = 0
      Top = 0
      Width = 525
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
