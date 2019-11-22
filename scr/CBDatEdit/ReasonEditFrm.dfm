object AReasonEditFrm: TAReasonEditFrm
  Left = 383
  Top = 146
  Width = 548
  Height = 470
  Caption = #21407#22240#32500#25252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PanelLeft: TPanel
    Left = 0
    Top = 0
    Width = 376
    Height = 443
    Align = alClient
    TabOrder = 0
    object dxTreeList1: TdxTreeList
      Left = 1
      Top = 1
      Width = 374
      Height = 441
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      Align = alClient
      TabOrder = 0
      HideSelection = False
      TreeLineColor = clGrayText
      ShowGrid = True
      ShowRoot = False
      OnDblClick = dxTreeList1DblClick
      Data = {
        FFFFFFFF02000000180000000000000000000000FFFFFFFF0000000000000000
        0200000002000000303105000000D4ADD2F231180000000000000000000000FF
        FFFFFF00000000000000000200000002000000303205000000D4ADD2F232}
      object dxTreeLstColNum: TdxTreeListColumn
        Caption = 'Num'
        Width = 50
        BandIndex = 0
        RowIndex = 0
      end
      object dxTreeLstColReason: TdxTreeListColumn
        Caption = 'Reason'
        Width = 300
        BandIndex = 0
        RowIndex = 0
      end
    end
    object PanelShow: TPanel
      Left = 8
      Top = 136
      Width = 361
      Height = 145
      Caption = 'PanelShow'
      Color = clSkyBlue
      TabOrder = 1
      object GroupBox1: TGroupBox
        Left = 4
        Top = 12
        Width = 352
        Height = 122
        Color = clSkyBlue
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        object Label1: TLabel
          Left = 9
          Top = 24
          Width = 34
          Height = 13
          Caption = 'Num'#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 9
          Top = 64
          Width = 49
          Height = 13
          Caption = 'Reason'#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object EditNum: TEdit
          Left = 61
          Top = 16
          Width = 281
          Height = 21
          TabOrder = 0
        end
        object EditReason: TEdit
          Left = 61
          Top = 56
          Width = 281
          Height = 21
          TabOrder = 1
        end
        object BtnShowPnlOk: TButton
          Left = 201
          Top = 89
          Width = 61
          Height = 24
          TabOrder = 2
          OnClick = BtnShowPnlOkClick
        end
        object BtnShowPnlCancel: TButton
          Left = 281
          Top = 89
          Width = 61
          Height = 24
          Caption = 'Cancel'
          TabOrder = 3
          OnClick = BtnShowPnlCancelClick
        end
      end
    end
  end
  object PanelRight: TPanel
    Left = 376
    Top = 0
    Width = 164
    Height = 443
    Align = alRight
    TabOrder = 1
    object BtnAdd: TButton
      Left = 38
      Top = 16
      Width = 94
      Height = 34
      Action = ActnAdd
      Caption = 'NewAdd'
      TabOrder = 0
    end
    object BtnModify: TButton
      Left = 38
      Top = 64
      Width = 94
      Height = 34
      Action = ActnModify
      TabOrder = 1
    end
    object BtnDel: TButton
      Left = 38
      Top = 112
      Width = 94
      Height = 34
      Action = ActnDel
      TabOrder = 2
    end
    object BtnSave: TButton
      Left = 38
      Top = 264
      Width = 94
      Height = 34
      Action = ActnSave
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object BtnCancel: TButton
      Left = 38
      Top = 320
      Width = 94
      Height = 34
      Caption = 'Cancel'
      TabOrder = 4
      OnClick = BtnCancelClick
    end
  end
  object ActionList1: TActionList
    Left = 320
    Top = 320
    object ActnAdd: TAction
      Caption = 'Add'
      OnExecute = ActnAddExecute
    end
    object ActnDel: TAction
      Caption = 'Delete'
      OnExecute = ActnDelExecute
    end
    object ActnModify: TAction
      Caption = 'Modify'
      OnExecute = ActnModifyExecute
    end
    object ActnSave: TAction
      Caption = 'Save'
      OnExecute = ActnSaveExecute
    end
  end
end
