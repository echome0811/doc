object LogInForm: TLogInForm
  Left = 219
  Top = 118
  Width = 283
  Height = 73
  AutoSize = True
  Caption = 'Login'
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
  object Label1: TLabel
    Left = 0
    Top = 3
    Width = 48
    Height = 13
    Caption = #29992#25143#21517#65306
  end
  object Label2: TLabel
    Left = 0
    Top = 27
    Width = 48
    Height = 13
    Caption = #23494'    '#30721#65306
  end
  object btnLogin: TButton
    Left = 216
    Top = 0
    Width = 59
    Height = 21
    Caption = #30331#38470
    Default = True
    TabOrder = 0
    OnClick = btnLoginClick
  end
  object edtID: TEdit
    Left = 56
    Top = 0
    Width = 154
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    TabOrder = 1
  end
  object edtPsw: TEdit
    Left = 56
    Top = 24
    Width = 154
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    PasswordChar = '*'
    TabOrder = 2
  end
  object btnQuit: TButton
    Left = 216
    Top = 25
    Width = 59
    Height = 21
    Cancel = True
    Caption = #36864#20986
    TabOrder = 3
    OnClick = btnQuitClick
  end
end
