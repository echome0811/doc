object ACBThreeTraderFrm: TACBThreeTraderFrm
  Left = 0
  Top = 0
  Width = 807
  Height = 509
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 0
    Top = 504
    Width = 807
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    ResizeStyle = rsUpdate
  end
  object Panel_Top: TPanel
    Left = 0
    Top = 0
    Width = 807
    Height = 49
    Align = alTop
    Color = clMaroon
    TabOrder = 0
    object Lbl_Caption: TLabel
      Left = 16
      Top = 16
      Width = 303
      Height = 16
      Caption = #36716#25442#20844#21496#20538#19977#22823#27861#20154#36827#20986#20010#32929#26126#32454#34920#25968#25454'                             '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel_Body: TPanel
    Left = 0
    Top = 49
    Width = 807
    Height = 455
    Align = alClient
    Caption = 'Panel_Body'
    TabOrder = 1
    object PageCtl: TPageControl
      Left = 1
      Top = 1
      Width = 805
      Height = 453
      ActivePage = TabSheet1
      Align = alClient
      Style = tsButtons
      TabIndex = 0
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #20170#26085#36164#26009#23457#26680
        object ListValue: TdxTreeList
          Left = 0
          Top = 33
          Width = 797
          Height = 389
          Bands = <
            item
            end>
          DefaultLayout = False
          HeaderPanelRowCount = 1
          Align = alClient
          DragMode = dmAutomatic
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
          LookAndFeel = lfFlat
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
          OnCustomDrawCell = ListValueCustomDrawCell
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
          object Column_SecID: TdxTreeListColumn
            Alignment = taRightJustify
            Caption = #36716#20538#20195#30721
            HeaderAlignment = taCenter
            ReadOnly = True
            Width = 98
            BandIndex = 0
            RowIndex = 0
          end
          object Column_SecName: TdxTreeListColumn
            Alignment = taRightJustify
            Caption = #36716#20538#21517#31216
            HeaderAlignment = taCenter
            ReadOnly = True
            Visible = False
            BandIndex = 0
            RowIndex = 0
          end
          object Column_ForeignBuy: TdxTreeListColumn
            Alignment = taRightJustify
            Caption = #22806#36164#21450#38470#36164#20080
            HeaderAlignment = taCenter
            ReadOnly = True
            Width = 108
            BandIndex = 0
            RowIndex = 0
          end
          object Column_ForeignSale: TdxTreeListPickColumn
            Alignment = taRightJustify
            Caption = #22806#36164#21450#38470#36164#21334
            BandIndex = 0
            RowIndex = 0
            ImmediateDropDown = False
          end
          object Column_ForeignNet: TdxTreeListColumn
            Alignment = taRightJustify
            Caption = #22806#36164#21450#38470#36164#20928#20080
            HeaderAlignment = taCenter
            Width = 120
            BandIndex = 0
            RowIndex = 0
          end
          object Column_InvestBuy: TdxTreeListColumn
            Alignment = taRightJustify
            Caption = #25237#20449#20080#36827#32929#25968
            HeaderAlignment = taCenter
            BandIndex = 0
            RowIndex = 0
          end
          object Column_InvestSale: TdxTreeListColumn
            Alignment = taRightJustify
            Caption = #25237#20449#21334#32929#25968
            HeaderAlignment = taCenter
            BandIndex = 0
            RowIndex = 0
          end
          object Column_InvestNet: TdxTreeListColumn
            Alignment = taRightJustify
            Caption = #25237#20449#20928#20080#32929#25968
            HeaderAlignment = taCenter
            BandIndex = 0
            RowIndex = 0
          end
          object Column_DealerBuy: TdxTreeListColumn
            Caption = #33258#33829#21830#20080#32929#25968
            BandIndex = 0
            RowIndex = 0
          end
          object Column_DealerSale: TdxTreeListColumn
            Caption = #33258#33829#21830#21334#32929#25968
            BandIndex = 0
            RowIndex = 0
          end
          object Column_DealerNet: TdxTreeListColumn
            Caption = #33258#33829#21830#20928#20080#32929#25968
            Width = 120
            BandIndex = 0
            RowIndex = 0
          end
          object Column_ThreeTraderCount: TdxTreeListColumn
            Caption = #19977#22823#27861#20154#20080#21334#36229#32929#25968
            Width = 140
            BandIndex = 0
            RowIndex = 0
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 797
          Height = 33
          Align = alTop
          Color = clMaroon
          TabOrder = 1
          object DateSct: TDateTimePicker
            Left = 4
            Top = 6
            Width = 101
            Height = 21
            CalAlignment = dtaLeft
            Date = 0.371257407401572
            Time = 0.371257407401572
            DateFormat = dfShort
            DateMode = dmComboBox
            Kind = dtkDate
            ParseInput = False
            TabOrder = 0
          end
          object Btn_Apply: TBitBtn
            Left = 116
            Top = 5
            Width = 75
            Height = 25
            Caption = 'Btn_Apply'
            TabOrder = 1
            OnClick = Btn_ApplyClick
            Glyph.Data = {
              66010000424D6601000000000000760000002800000014000000140000000100
              040000000000F000000000000000000000001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              11111133000033330000000099999933000033330FFFFFFF9999933300003331
              10F0F0F09999133300003390000FFFFF9999913300003390FF800000998F9911
              00009910F9FFFFFF9F00099100009910FFFFFFFFFFFFF9910000991300000000
              0000099100009913330000000003399100009913330FFFFFFF03399100009913
              330F00000F03399100009913330F0CCC0F03399100003391330F0CCC0F039911
              00003399130F00000F09913300003339910FFFFFFF0913330000333399000000
              0001333300003333999999999991333300003333333999999333333300003333
              33333333333333330000}
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = #21382#21490#36164#26009#22238#34917
        ImageIndex = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 797
          Height = 49
          Align = alTop
          Color = clMaroon
          TabOrder = 0
          object Label2: TLabel
            Left = 32
            Top = 16
            Width = 210
            Height = 16
            Caption = #21382#21490#36164#26009#22238#34917'                                              '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clYellow
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 49
          Width = 797
          Height = 373
          Align = alClient
          Color = clInfoBk
          TabOrder = 1
          object GroupBox1: TGroupBox
            Left = 120
            Top = 24
            Width = 425
            Height = 329
            Caption = 'DateSelect'
            TabOrder = 0
            object DateGet: TMonthCalendar
              Left = 2
              Top = 15
              Width = 421
              Height = 312
              Align = alClient
              CalColors.BackColor = clInfoBk
              Date = 38818.4473927546
              DragCursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              WeekNumbers = True
              OnClick = DateGetClick
            end
          end
          object GroupBox2: TGroupBox
            Left = 584
            Top = 24
            Width = 257
            Height = 329
            Caption = 'Request'
            TabOrder = 1
            object Label1: TLabel
              Left = 47
              Top = 48
              Width = 174
              Height = 16
              Caption = #24403#21069#36873#25321#30340#26085#26399#20026'                          '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clDefault
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Edt_Date: TEdit
              Left = 48
              Top = 120
              Width = 145
              Height = 21
              Color = clCream
              Enabled = False
              TabOrder = 0
            end
            object Btn_Get: TBitBtn
              Left = 72
              Top = 176
              Width = 105
              Height = 25
              Caption = 'Btn_Get'
              TabOrder = 1
              OnClick = Btn_GetClick
              Glyph.Data = {
                66010000424D6601000000000000760000002800000014000000140000000100
                040000000000F000000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
                00333333000030FFFFFFFFFFF03333330000330F0F0F0F0F0333333300000000
                FFFFFFF00003333300000FF800000008FF03333300000F9FFFFFFFF000033333
                00000FFFFFFFFFFFFF0333330000300000000000003333330000333000000000
                3333333300003330FFFF00703333333300003330F0000B307833333300003330
                F0CCC0BB0078333300003330F0CCC00BB300733300003330F00000F0BBB00733
                00003330FFFFFFF00BBB00830000333000000000BBB008330000333333333330
                0BBB00830000333333333333300BB008000033333333333333300B0000003333
                33333333333330000000}
            end
          end
        end
      end
    end
  end
  object IdTCPClient1: TIdTCPClient
    MaxLineAction = maException
    Port = 0
    Left = 224
    Top = 80
  end
  object Timer_CheckModify: TTimer
    Enabled = False
    Interval = 100
    Left = 472
    Top = 144
  end
end
