object ACBDocFrm: TACBDocFrm
  Left = 0
  Top = 0
  Width = 808
  Height = 413
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
    Height = 409
    Cursor = crHSplit
  end
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 808
    Height = 4
    Align = alTop
    Shape = bsSpacer
  end
  object Panel_Left: TPanel
    Left = 0
    Top = 4
    Width = 190
    Height = 409
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel_Left'
    TabOrder = 0
    object List_ID: TListBox
      Left = 0
      Top = 72
      Width = 190
      Height = 337
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
    Width = 615
    Height = 409
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel_Right'
    TabOrder = 1
    object Panel_NowID: TPanel
      Left = 0
      Top = 0
      Width = 615
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
      TabOrder = 0
    end
    object PageControl1: TPageControl
      Left = 0
      Top = 24
      Width = 615
      Height = 385
      ActivePage = TabSheet1
      Align = alClient
      TabIndex = 0
      TabOrder = 1
      OnChange = PageControl1Change
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        object Txt_Memo: TMemo
          Left = 0
          Top = 0
          Width = 607
          Height = 357
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Lines.Strings = (
            'Txt_Memo')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = Txt_MemoChange
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'TabSheet2'
        ImageIndex = 1
      end
      object TabSheet3: TTabSheet
        Caption = 'TabSheet3'
        ImageIndex = 2
      end
      object TabSheet4: TTabSheet
        Caption = 'TabSheet4'
        ImageIndex = 3
      end
      object TabSheet5: TTabSheet
        Caption = 'TabSheet5'
        ImageIndex = 4
      end
      object TabSheet6: TTabSheet
        Caption = 'TabSheet6'
        ImageIndex = 5
      end
      object TabSheet7: TTabSheet
        Caption = 'TabSheet7'
        ImageIndex = 6
      end
      object TabSheet8: TTabSheet
        Caption = 'TabSheet8'
        ImageIndex = 7
      end
      object TabSheet9: TTabSheet
        Caption = 'TabSheet9'
        ImageIndex = 8
      end
    end
  end
end
