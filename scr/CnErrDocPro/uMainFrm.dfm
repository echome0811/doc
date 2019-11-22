object MainForm: TMainForm
  Left = 227
  Top = 148
  Width = 696
  Height = 480
  Caption = 'MainForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 57
    Align = alTop
    TabOrder = 0
    object lbl1: TLabel
      Left = 104
      Top = 5
      Width = 124
      Height = 19
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Tr1db Document Path'
    end
    object lbl2: TLabel
      Left = 104
      Top = 33
      Width = 124
      Height = 19
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'DocMgr Path'
    end
    object edtDocumentPath: TEdit
      Left = 231
      Top = 4
      Width = 200
      Height = 21
      TabOrder = 0
      Text = 'Z:\CBData\Document\'
    end
    object edtLogFile: TEdit
      Left = 231
      Top = 32
      Width = 200
      Height = 21
      TabOrder = 1
      Text = 'B:\'
    end
    object btnStart: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 2
      OnClick = btnStartClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 423
    Width = 680
    Height = 19
    Panels = <
      item
        Width = 0
      end
      item
        Width = 250
      end
      item
        Width = 250
      end
      item
        Width = 250
      end>
    SimplePanel = False
  end
  object mmo1: TMemo
    Left = 0
    Top = 57
    Width = 680
    Height = 366
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object IdFTP1: TIdFTP
    Intercept = IdLogDebug1
    MaxLineAction = maException
    RecvBufferSize = 8192
    SendBufferSize = 1024
    Password = 'idftp@client.com'
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 240
    Top = 64
  end
  object IdLogDebug1: TIdLogDebug
    Active = True
    LogTime = False
    Left = 280
    Top = 64
  end
end
