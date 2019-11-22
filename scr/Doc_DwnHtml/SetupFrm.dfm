object ASetupFrm: TASetupFrm
  Left = 224
  Top = 161
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'ASetupFrm'
  ClientHeight = 357
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TBitBtn
    Left = 290
    Top = 324
    Width = 73
    Height = 29
    Caption = #30830#23450
    Default = True
    TabOrder = 0
    OnClick = OKBtnClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object CancelBtn: TBitBtn
    Left = 365
    Top = 324
    Width = 73
    Height = 29
    Caption = #21462#28040
    TabOrder = 1
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
  object PageControl1: TPageControl
    Left = 6
    Top = 9
    Width = 433
    Height = 305
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #31995'??'#23450
      object PageControl2: TPageControl
        Left = 0
        Top = 0
        Width = 425
        Height = 277
        ActivePage = TabSheet6
        Align = alClient
        TabIndex = 2
        TabOrder = 0
        object TabSheet4: TTabSheet
          Caption = #19979'?'#32593#31449
          object Label14: TLabel
            Left = 24
            Top = 25
            Width = 81
            Height = 13
            AutoSize = False
            Caption = #19979'?'#32593#31449'??     '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Bevel3: TBevel
            Left = 104
            Top = 9
            Width = 249
            Height = 26
            Shape = bsBottomLine
          end
          object Label15: TLabel
            Left = 144
            Top = 216
            Width = 228
            Height = 13
            Caption = '('#20462#25913#19979'?'#32593#31449#21518'?'#21516'?'#20462#25913'TR1DB'#30340#36335'?)          '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label7: TLabel
            Left = 21
            Top = 141
            Width = 84
            Height = 13
            AutoSize = False
            Caption = 'Tr1DB'#36335'?'#65306
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Bevel4: TBevel
            Left = 104
            Top = 129
            Width = 249
            Height = 26
            Shape = bsBottomLine
          end
          object DwnMemo_RG: TRadioGroup
            Left = 56
            Top = 48
            Width = 273
            Height = 81
            ItemIndex = 0
            Items.Strings = (
              #22823'?'#65288#20013'??'#21048#32593'-F10'#65289
              #21488'?'#65288#20803#22823#20140#33775'?'#21048#32593'-YuanTa'#65289)
            TabOrder = 0
          end
          object Txt_TR1DBPath: TEdit
            Left = 21
            Top = 173
            Width = 340
            Height = 21
            TabOrder = 1
            Text = 'Txt_TR1DBPath'
          end
          object Button1: TButton
            Left = 368
            Top = 171
            Width = 25
            Height = 23
            Caption = '...'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = Button1Click
          end
        end
        object TabSheet5: TTabSheet
          Caption = '?'#31243#21644#19979'???'
          ImageIndex = 1
          object Label9: TLabel
            Left = 32
            Top = 17
            Width = 91
            Height = 13
            AutoSize = False
            Caption = '?'#31243'?'#37327'?'#23450
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label1: TLabel
            Left = 56
            Top = 50
            Width = 126
            Height = 13
            AutoSize = False
            Caption = #19979'????'#31243'?'#30446#65306
          end
          object Label2: TLabel
            Left = 56
            Top = 82
            Width = 126
            Height = 13
            AutoSize = False
            Caption = #19979'?'#25991#31456'?'#31243'?'#30446#65306
          end
          object Bevel5: TBevel
            Left = 128
            Top = 1
            Width = 241
            Height = 26
            Shape = bsBottomLine
          end
          object Label10: TLabel
            Left = 32
            Top = 117
            Width = 91
            Height = 13
            AutoSize = False
            Caption = #19979'????'#23450
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Bevel6: TBevel
            Left = 128
            Top = 101
            Width = 225
            Height = 26
            Shape = bsBottomLine
          end
          object Label3: TLabel
            Left = 56
            Top = 149
            Width = 126
            Height = 13
            AutoSize = False
            Caption = #19979'?'#26368#26032#20844#21578'??'#65306
          end
          object Label4: TLabel
            Left = 56
            Top = 181
            Width = 126
            Height = 13
            AutoSize = False
            Caption = '?'#26597'?'#21490#32570#28431'??'#65306
          end
          object Txt_DwnTitleThreadCount: TEdit
            Left = 186
            Top = 43
            Width = 73
            Height = 21
            TabOrder = 0
          end
          object Txt_DwnTxtThreadCount: TEdit
            Left = 186
            Top = 75
            Width = 73
            Height = 21
            TabOrder = 1
          end
          object Txt_DwnTodayTxtTime: TDateTimePicker
            Left = 186
            Top = 142
            Width = 121
            Height = 21
            CalAlignment = dtaLeft
            Date = 38589
            Time = 38589
            DateFormat = dfShort
            DateMode = dmComboBox
            Kind = dtkTime
            ParseInput = False
            TabOrder = 2
          end
          object Txt_DwnHistoryTxtTime: TDateTimePicker
            Left = 186
            Top = 174
            Width = 121
            Height = 21
            CalAlignment = dtaLeft
            Date = 38589
            Time = 38589
            DateFormat = dfShort
            DateMode = dmComboBox
            Kind = dtkTime
            ParseInput = False
            TabOrder = 3
          end
          object Chk_AutoDwnGet: TCheckBox
            Left = 31
            Top = 208
            Width = 233
            Height = 17
            Caption = #31243#24207#28608#27963#21518#30452#25509'?'#20837#19979'?'#27169#24335
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
        end
        object TabSheet6: TTabSheet
          Caption = #19979'?'#30340#20844#21578'?'#22987#26085#26399
          ImageIndex = 2
          object Label18: TLabel
            Left = 16
            Top = 17
            Width = 161
            Height = 16
            AutoSize = False
            Caption = #19979'?'#30340#20844#21578'?'#22987#26085#26399'?'#23450
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Bevel8: TBevel
            Left = 16
            Top = 17
            Width = 241
            Height = 26
            Shape = bsBottomLine
          end
          object DateTimePicker_strat: TDateTimePicker
            Left = 24
            Top = 56
            Width = 89
            Height = 25
            CalAlignment = dtaLeft
            Date = 39680.5572245718
            Time = 39680.5572245718
            DateFormat = dfShort
            DateMode = dmComboBox
            Kind = dtkDate
            ParseInput = False
            TabOrder = 0
          end
        end
        object TabSheet7: TTabSheet
          Caption = #19979'??'#38548'??'#21644#36229'??'#32622
          ImageIndex = 3
          object Label19: TLabel
            Left = 30
            Top = 149
            Width = 152
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = #20241#30496'??('#20998'?)'#65306
          end
          object Bevel9: TBevel
            Left = 215
            Top = 101
            Width = 150
            Height = 26
            Shape = bsBottomLine
          end
          object Label20: TLabel
            Left = 9
            Top = 117
            Width = 191
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = #27599'?'#19979'?'#23436#25104#21518#20241#24687'???'#38548
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label21: TLabel
            Left = 30
            Top = 82
            Width = 152
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = #19979'?'#20844#21578#36229'???('#31186')'#65306
          end
          object Label22: TLabel
            Left = 30
            Top = 50
            Width = 152
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = #19979'???'#36229'???('#31186')'#65306
          end
          object Bevel10: TBevel
            Left = 215
            Top = 1
            Width = 150
            Height = 26
            Shape = bsBottomLine
          end
          object Label23: TLabel
            Left = 9
            Top = 17
            Width = 191
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = #19979'?'#36229'??'#23450
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object seTitleDwnTimeOut: TSpinEdit
            Left = 186
            Top = 42
            Width = 73
            Height = 22
            MaxValue = 300
            MinValue = 0
            TabOrder = 0
            Value = 0
          end
          object seTextDwnTimeOut: TSpinEdit
            Left = 186
            Top = 77
            Width = 73
            Height = 22
            MaxValue = 300
            MinValue = 0
            TabOrder = 1
            Value = 0
          end
          object seSleep: TSpinEdit
            Left = 186
            Top = 144
            Width = 73
            Height = 22
            MaxValue = 100000
            MinValue = 0
            TabOrder = 2
            Value = 0
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = '?'#35686'?'#23450
      ImageIndex = 2
      object Bevel2: TBevel
        Left = 40
        Top = 125
        Width = 321
        Height = 26
        Shape = bsBottomLine
      end
      object Bevel1: TBevel
        Left = 40
        Top = 17
        Width = 321
        Height = 26
        Shape = bsBottomLine
      end
      object Label5: TLabel
        Left = 72
        Top = 66
        Width = 81
        Height = 13
        AutoSize = False
        Caption = '?'#35686#26381'?'#22120#65306
      end
      object Label6: TLabel
        Left = 48
        Top = 98
        Width = 126
        Height = 13
        AutoSize = False
        Caption = '?'#35686#26381'?'#22120#31471#21475#65306
      end
      object Label8: TLabel
        Left = 40
        Top = 172
        Width = 190
        Height = 13
        AutoSize = False
        Caption = #19979'???'#21487'?'#29983'??'#30340#27425'?'#65306
      end
      object Label11: TLabel
        Left = 40
        Top = 204
        Width = 193
        Height = 13
        AutoSize = False
        Caption = #19979'?'#25991#31456#21487'?'#29983'??'#30340#27425'?'#65306
      end
      object Label12: TLabel
        Left = 32
        Top = 33
        Width = 91
        Height = 13
        AutoSize = False
        Caption = #26381'?'#22120'?'#23450
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 32
        Top = 141
        Width = 225
        Height = 13
        AutoSize = False
        Caption = '??'#29983'??'#27425'?'#22823#20110'?'#23450#20540'?'#21363'?'#35686
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Txt_SoundPort: TEdit
        Left = 170
        Top = 91
        Width = 47
        Height = 21
        TabOrder = 0
      end
      object Txt_SoundServer: TEdit
        Left = 170
        Top = 59
        Width = 199
        Height = 21
        TabOrder = 1
      end
      object Txt_DwnTxtErrCount: TEdit
        Left = 229
        Top = 197
        Width = 73
        Height = 21
        TabOrder = 2
      end
      object Txt_DwnTitleErrCount: TEdit
        Left = 229
        Top = 165
        Width = 73
        Height = 21
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = #23436#25972#24615'?'#26597'?'#23450
      ImageIndex = 2
      object Label16: TLabel
        Left = 56
        Top = 133
        Width = 126
        Height = 13
        AutoSize = False
        Caption = #20844#21578#23436#25972#24615'?'#26597'??:'
      end
      object Label17: TLabel
        Left = 32
        Top = 73
        Width = 121
        Height = 13
        AutoSize = False
        Caption = #23436#25972#24615'?'#26597'?'#23450'    '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Bevel7: TBevel
        Left = 40
        Top = 65
        Width = 321
        Height = 26
        Shape = bsBottomLine
      end
      object Doc_Check_Time: TDateTimePicker
        Left = 194
        Top = 126
        Width = 121
        Height = 21
        CalAlignment = dtaLeft
        Date = 38589
        Time = 38589
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 0
      end
    end
  end
end
