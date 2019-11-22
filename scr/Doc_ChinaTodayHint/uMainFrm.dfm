object MainForm: TMainForm
  Left = 183
  Top = 84
  Width = 762
  Height = 673
  Caption = #20132#26131#25552#31034#19979#36733
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 30
    Width = 754
    Height = 609
    Align = alClient
    TabOrder = 0
    object pgc2: TPageControl
      Left = 1
      Top = 1
      Width = 752
      Height = 607
      ActivePage = ts3
      Align = alClient
      TabIndex = 0
      TabOrder = 0
      object ts3: TTabSheet
        Caption = #20132#26131#25552#31034
        object wb1: TWebBrowser
          Left = 0
          Top = 0
          Width = 744
          Height = 145
          Align = alTop
          TabOrder = 0
          OnNewWindow2 = wb1NewWindow2
          OnDocumentComplete = wb1DocumentComplete
          ControlData = {
            4C000000E54C0000FC0E00000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object wb2: TWebBrowser
          Left = 0
          Top = 145
          Width = 744
          Height = 129
          Align = alTop
          TabOrder = 1
          OnNewWindow2 = wb2NewWindow2
          OnDocumentComplete = wb2DocumentComplete
          ControlData = {
            4C000000E54C0000550D00000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object wb3: TWebBrowser
          Left = 0
          Top = 274
          Width = 744
          Height = 386
          Align = alTop
          TabOrder = 2
          OnNewWindow2 = wb3NewWindow2
          OnDocumentComplete = wb3DocumentComplete
          ControlData = {
            4C000000E54C0000E52700000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object pnl3: TPanel
          Left = 0
          Top = 386
          Width = 744
          Height = 193
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
          object Splitter1: TSplitter
            Left = 385
            Top = 0
            Width = 5
            Height = 193
            Cursor = crHSplit
            ResizeStyle = rsUpdate
          end
          object SZBox: TGroupBox
            Left = 390
            Top = 0
            Width = 354
            Height = 193
            Align = alClient
            Caption = #19978#35777
            TabOrder = 0
            object SZTxt_Memo: TRichEdit
              Left = 2
              Top = 15
              Width = 350
              Height = 176
              Align = alClient
              Font.Charset = GB2312_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object ZZBox: TGroupBox
            Left = 0
            Top = 0
            Width = 385
            Height = 193
            Align = alLeft
            Caption = #20013#35777
            TabOrder = 1
            object ZZTxt_memo: TRichEdit
              Left = 2
              Top = 15
              Width = 381
              Height = 176
              Align = alClient
              Font.Charset = GB2312_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
        end
      end
      object ts4: TTabSheet
        Caption = #20013#35777#20132#26131#25552#31034
        ImageIndex = 1
        TabVisible = False
      end
      object ts5: TTabSheet
        Caption = #20013#35777#20170#26085#25968#25454
        ImageIndex = 2
        TabVisible = False
      end
      object ts1: TTabSheet
        Caption = #20132#26131#25552#31034#25968#25454
        ImageIndex = 3
        TabVisible = False
      end
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 754
    Height = 30
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 304
      Top = 2
      Width = 181
      Height = 25
      AutoSize = False
      Caption = #27491#22312#21152#36733#36164#26009'...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object btnReDown: TButton
      Left = 11
      Top = 2
      Width = 68
      Height = 25
      Caption = #19979#36733#35299#26512
      TabOrder = 0
      OnClick = btnReDownClick
    end
    object btnReParse: TButton
      Left = 81
      Top = 2
      Width = 42
      Height = 25
      Caption = #35299#26512
      TabOrder = 1
      Visible = False
      OnClick = btnReParseClick
    end
    object chkSZ: TCheckBox
      Left = 137
      Top = 6
      Width = 50
      Height = 17
      Caption = #19978#35777
      Checked = True
      State = cbChecked
      TabOrder = 2
      Visible = False
    end
    object chkZZ: TCheckBox
      Left = 189
      Top = 6
      Width = 50
      Height = 17
      Caption = #20013#35777
      Checked = True
      State = cbChecked
      TabOrder = 3
      Visible = False
    end
  end
  object TCPServer: TIdTCPServer
    Bindings = <
      item
        Port = 8090
      end>
    CommandHandlers = <>
    DefaultPort = 8090
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnExecute = TCPServerExecute
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 320
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 472
    Top = 16
  end
end
