object ACBStockHolderFrm: TACBStockHolderFrm
  Left = 0
  Top = 0
  Width = 850
  Height = 319
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
    Height = 315
    Cursor = crHSplit
  end
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 850
    Height = 4
    Align = alTop
    Shape = bsSpacer
  end
  object Panel_Left: TPanel
    Left = 0
    Top = 4
    Width = 190
    Height = 315
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel_Left'
    TabOrder = 0
    object List_ID: TListBox
      Left = 0
      Top = 72
      Width = 190
      Height = 243
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
      object SpeedButton6: TSpeedButton
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
        OnClick = SpeedButton6Click
      end
      object SpeedButton5: TSpeedButton
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
        OnClick = SpeedButton5Click
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
    Width = 657
    Height = 315
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 24
      Width = 657
      Height = 291
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object Bevel4: TBevel
        Left = 0
        Top = 273
        Width = 657
        Height = 18
        Align = alBottom
        Shape = bsSpacer
      end
      object Bevel6: TBevel
        Left = 633
        Top = 32
        Width = 24
        Height = 241
        Align = alRight
        Shape = bsSpacer
      end
      object Bevel5: TBevel
        Left = 0
        Top = 0
        Width = 657
        Height = 32
        Align = alTop
        Shape = bsSpacer
      end
      object Btn_Refresh: TSpeedButton
        Left = 208
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
      object Btn_Delete: TSpeedButton
        Left = 276
        Top = 8
        Width = 62
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
        Left = 344
        Top = 8
        Width = 62
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
        Left = 476
        Top = 8
        Width = 62
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
        Left = 546
        Top = 8
        Width = 62
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
        Left = 410
        Top = 8
        Width = 62
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
      object Bevel1: TBevel
        Left = 0
        Top = 32
        Width = 25
        Height = 241
        Align = alLeft
        Shape = bsSpacer
      end
      object SpeedButton3: TSpeedButton
        Left = 113
        Top = 8
        Width = 88
        Height = 19
        Caption = '>>'#26032#22686#26085#26399
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton3Click
      end
      object SpeedButton4: TSpeedButton
        Left = 24
        Top = 8
        Width = 88
        Height = 19
        Caption = '>>'#21024#38500#26085#26399
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton4Click
      end
      object Splitter2: TSplitter
        Left = 138
        Top = 32
        Width = 6
        Height = 241
        Cursor = crHSplit
        Beveled = True
      end
      object List_Date: TListBox
        Left = 25
        Top = 32
        Width = 113
        Height = 241
        Align = alLeft
        BevelInner = bvNone
        BevelOuter = bvNone
        ItemHeight = 13
        TabOrder = 0
        OnClick = List_DateClick
      end
      object Panel5: TPanel
        Left = 144
        Top = 32
        Width = 489
        Height = 241
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel5'
        TabOrder = 1
        object ListValue: TdxTreeList
          Left = 0
          Top = 24
          Width = 489
          Height = 217
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
          OnEdited = ListValueEdited
          OnEditing = ListValueEditing
          object Column_Num: TdxTreeListColumn
            Alignment = taCenter
            Caption = #21517#27425
            HeaderAlignment = taCenter
            ReadOnly = True
            Width = 34
            BandIndex = 0
            RowIndex = 0
          end
          object Column_A1: TdxTreeListColumn
            Caption = #20538#21048#25345#26377#20154#21517#31216
            HeaderAlignment = taCenter
            Width = 192
            BandIndex = 0
            RowIndex = 0
          end
          object Column_A3: TdxTreeListColumn
            Alignment = taRightJustify
            Caption = #25345#26377#37327'('#24352')'
            HeaderAlignment = taCenter
            Width = 84
            BandIndex = 0
            RowIndex = 0
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 489
          Height = 24
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          BorderWidth = 2
          Caption = #25130#27490'2004'#24180'6'#26376'30'#26085
          Color = clGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnExit = Txt_Info3Exit
          object Txt_Info: TEdit
            Left = 35
            Top = 2
            Width = 124
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
            Text = 'Txt_Info'
            OnChange = Txt_InfoChange
            OnExit = Txt_Info3Exit
          end
        end
      end
    end
    object Panel_NowID: TPanel
      Left = 0
      Top = 0
      Width = 657
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
