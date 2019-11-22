object AOpRecsQueryFrm: TAOpRecsQueryFrm
  Left = 0
  Top = 0
  Width = 715
  Height = 382
  TabOrder = 0
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 715
    Height = 64
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label3: TLabel
      Left = 69
      Top = 14
      Width = 24
      Height = 13
      Caption = #20195#30721
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object GaugeReadToGrid: TGauge
      Left = 8
      Top = 43
      Width = 669
      Height = 16
      BackColor = clInfoBk
      ForeColor = clLime
      Progress = 0
      Visible = False
    end
    object lbl1: TLabel
      Left = 612
      Top = 14
      Width = 13
      Height = 13
      Caption = '---'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 469
      Top = 14
      Width = 51
      Height = 13
      Caption = #25805#20316#26085#26399' '
    end
    object Label5: TLabel
      Left = 193
      Top = 14
      Width = 36
      Height = 13
      Caption = #25805#20316#20154
    end
    object Label1: TLabel
      Left = 315
      Top = 14
      Width = 48
      Height = 13
      Caption = #25805#20316#39029#31614
    end
    object BtGo: TBitBtn
      Left = 12
      Top = 8
      Width = 52
      Height = 25
      Caption = #21047#26032
      TabOrder = 0
      OnClick = BtGoClick
    end
    object dtpBegin: TDateTimePicker
      Left = 527
      Top = 10
      Width = 84
      Height = 21
      CalAlignment = dtaLeft
      Date = 39735.6149229514
      Time = 39735.6149229514
      DateFormat = dfShort
      DateMode = dmComboBox
      ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
      Kind = dtkDate
      ParseInput = False
      TabOrder = 1
    end
    object dtpEnd: TDateTimePicker
      Left = 626
      Top = 10
      Width = 84
      Height = 21
      CalAlignment = dtaLeft
      Date = 40190.4083045718
      Time = 40190.4083045718
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 2
    end
    object cbbOperator: TComboBox
      Left = 234
      Top = 10
      Width = 77
      Height = 21
      ItemHeight = 13
      TabOrder = 3
    end
    object cbbOpModoule: TComboBox
      Left = 372
      Top = 10
      Width = 96
      Height = 21
      ItemHeight = 13
      TabOrder = 4
    end
    object EdID: TEdit
      Left = 98
      Top = 10
      Width = 90
      Height = 21
      TabOrder = 5
    end
  end
  object LstGrid: TdxTreeList
    Left = 0
    Top = 64
    Width = 715
    Height = 318
    Bands = <
      item
        Alignment = taLeftJustify
      end>
    DefaultLayout = False
    HeaderPanelRowCount = 1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    AutoExpandOnSearch = False
    BandFont.Charset = DEFAULT_CHARSET
    BandFont.Color = clNavy
    BandFont.Height = -12
    BandFont.Name = 'Microsoft Sans Serif'
    BandFont.Style = []
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -12
    HeaderFont.Name = 'Microsoft Sans Serif'
    HeaderFont.Style = []
    HideSelection = False
    MaxRowLineCount = 3
    Options = [aoColumnSizing, aoColumnMoving, aoTabThrough, aoRowSelect, aoMultiSelect, aoAutoWidth, aoAutoSort]
    OptionsEx = [aoUseBitmap, aoBandHeaderWidth, aoAutoCalcPreviewLines, aoBandSizing, aoBandMoving, aoDragScroll, aoAutoCopySelectedToClipboard]
    PreviewFont.Charset = DEFAULT_CHARSET
    PreviewFont.Color = clBlue
    PreviewFont.Height = -12
    PreviewFont.Name = 'Microsoft Sans Serif'
    PreviewFont.Style = []
    HighlightColor = clNavy
    TreeLineColor = clGrayText
    HideSelectionColor = clNavy
    HideSelectionTextColor = clHighlightText
    ShowBands = True
    ShowGrid = True
    ShowRoot = False
    ShowIndicator = True
    object No: TdxTreeListColumn
      Alignment = taCenter
      Caption = 'No'
      HeaderAlignment = taCenter
      Width = 36
      BandIndex = 0
      RowIndex = 0
    end
    object Operator: TdxTreeListColumn
      Caption = 'Operator'
      HeaderAlignment = taCenter
      Width = 78
      BandIndex = 0
      RowIndex = 0
    end
    object Op: TdxTreeListColumn
      Alignment = taLeftJustify
      Caption = 'OP'
      HeaderAlignment = taCenter
      Width = 71
      BandIndex = 0
      RowIndex = 0
    end
    object CodeID: TdxTreeListColumn
      Alignment = taCenter
      Caption = 'CodeID'
      HeaderAlignment = taCenter
      Width = 71
      BandIndex = 0
      RowIndex = 0
    end
    object Modoule: TdxTreeListColumn
      Caption = 'Modoule'
      HeaderAlignment = taCenter
      Width = 231
      BandIndex = 0
      RowIndex = 0
    end
    object OpTime: TdxTreeListColumn
      Alignment = taCenter
      Caption = 'OpTime'
      HeaderAlignment = taCenter
      Sorted = csUp
      Width = 196
      BandIndex = 0
      RowIndex = 0
    end
  end
end
