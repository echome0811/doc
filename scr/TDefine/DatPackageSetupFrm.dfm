object ADatPackageSetupFrm: TADatPackageSetupFrm
  Left = 298
  Top = 178
  AutoScroll = False
  Caption = #29615#22659#35774#23450
  ClientHeight = 332
  ClientWidth = 446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 7
    Width = 7
    Height = 290
    Align = alLeft
    Shape = bsSpacer
  end
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 446
    Height = 7
    Align = alTop
    Shape = bsSpacer
  end
  object Bevel3: TBevel
    Left = 438
    Top = 7
    Width = 8
    Height = 290
    Align = alRight
    Shape = bsSpacer
  end
  object Bevel4: TBevel
    Left = 0
    Top = 297
    Width = 446
    Height = 35
    Align = alBottom
    Shape = bsSpacer
  end
  object PageControl1: TPageControl
    Left = 7
    Top = 7
    Width = 431
    Height = 290
    ActivePage = TabSheet2
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = #36164#26009#26469#28304#35774#23450
      ImageIndex = 1
      object Label7: TLabel
        Left = 15
        Top = 24
        Width = 242
        Height = 13
        AutoSize = False
        Caption = 'TR1DB'#30340#36335#24452
      end
      object Label1: TLabel
        Left = 15
        Top = 88
        Width = 242
        Height = 13
        AutoSize = False
        Caption = #25171#21253#25968#25454#20445#23384#36335#24452
      end
      object Label2: TLabel
        Left = 15
        Top = 152
        Width = 242
        Height = 13
        AutoSize = False
        Caption = #20854#23427#22522#26412#36164#26009#30340#36335#24452
      end
      object Txt_Tr1DBPath: TEdit
        Left = 15
        Top = 48
        Width = 356
        Height = 21
        TabOrder = 0
        Text = 'Txt_Tr1DBPath'
      end
      object Button1: TButton
        Left = 381
        Top = 47
        Width = 22
        Height = 22
        Caption = '...'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Txt_DBPath: TEdit
        Left = 15
        Top = 112
        Width = 356
        Height = 21
        TabOrder = 2
        Text = 'Txt_DBPath'
      end
      object Button2: TButton
        Left = 381
        Top = 111
        Width = 22
        Height = 22
        Caption = '...'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Txt_CBPAPath: TEdit
        Left = 15
        Top = 176
        Width = 356
        Height = 21
        TabOrder = 4
        Text = 'Txt_CBPAPath'
      end
      object Button3: TButton
        Left = 381
        Top = 175
        Width = 22
        Height = 22
        Caption = '...'
        TabOrder = 5
        OnClick = Button3Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'FTP'#26381#21153#22120#35774#23450
      ImageIndex = 2
      object GroupBox3: TGroupBox
        Left = 14
        Top = 13
        Width = 377
        Height = 236
        Caption = #19978#20256#26381#21153#22120#35774#23450
        TabOrder = 0
        object Label11: TLabel
          Left = 14
          Top = 37
          Width = 88
          Height = 13
          AutoSize = False
          Caption = #26381#21153#22120
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label26: TLabel
          Left = 14
          Top = 65
          Width = 33
          Height = 13
          AutoSize = False
          Caption = #31471#21475
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label29: TLabel
          Left = 14
          Top = 115
          Width = 33
          Height = 13
          AutoSize = False
          Caption = #23494#30721
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label28: TLabel
          Left = 14
          Top = 88
          Width = 45
          Height = 13
          AutoSize = False
          Caption = #29992#25143#21517
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label17: TLabel
          Left = 14
          Top = 164
          Width = 211
          Height = 13
          AutoSize = False
          Caption = #19978#20256#30446#24405'('#35831#20197'"/"'#24320#22987')    '
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Chk_FtpPasv: TCheckBox
          Left = 236
          Top = 33
          Width = 110
          Height = 17
          Caption = 'Use PASV Mode'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Txt_FtpServer: TEdit
          Left = 61
          Top = 31
          Width = 157
          Height = 21
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = 'ftp.traderone.com.cn'
        end
        object Txt_FtpPort: TEdit
          Left = 61
          Top = 56
          Width = 28
          Height = 21
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '21'
        end
        object Txt_FtpPass: TEdit
          Left = 61
          Top = 108
          Width = 156
          Height = 21
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 3
          Text = 'user@host.com'
        end
        object Txt_FtpUser: TEdit
          Left = 61
          Top = 81
          Width = 156
          Height = 21
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 4
          Text = 'anonymous'
        end
        object Txt_FtpUploadDir: TEdit
          Left = 14
          Top = 180
          Width = 351
          Height = 21
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #26032#23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object Button5: TButton
          Left = 344
          Top = 241
          Width = 25
          Height = 23
          Caption = '...'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
      end
    end
  end
  object OKBtn: TBitBtn
    Left = 273
    Top = 302
    Width = 73
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 1
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
    Left = 351
    Top = 302
    Width = 73
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
end
