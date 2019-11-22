object AFrmSetHint_ZZ: TAFrmSetHint_ZZ
  Left = 363
  Top = 270
  BorderStyle = bsSingle
  Caption = 'KeyWordSet TodayHint_ZZ'
  ClientHeight = 99
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BevelTop: TBevel
    Left = 0
    Top = 0
    Width = 263
    Height = 9
    Align = alTop
  end
  object BevelBottom: TBevel
    Left = 0
    Top = 90
    Width = 263
    Height = 9
    Align = alBottom
  end
  object PanelYear: TPanel
    Left = 0
    Top = 90
    Width = 263
    Height = 0
    Align = alClient
    Enabled = False
    TabOrder = 0
    Visible = False
    object Label4: TLabel
      Left = 23
      Top = 136
      Width = 60
      Height = 13
      Caption = #26684#24335#39044#35272#65306
    end
    object GroupBox1: TGroupBox
      Left = 72
      Top = 1
      Width = 241
      Height = 41
      TabOrder = 0
      object Label1: TLabel
        Left = 124
        Top = 18
        Width = 48
        Height = 13
        Caption = #21547#25991#23383#65306
      end
      object RadioButtonYY: TRadioButton
        Left = 8
        Top = 16
        Width = 41
        Height = 17
        Caption = 'yy'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object RadioButtonYYYY: TRadioButton
        Left = 64
        Top = 16
        Width = 49
        Height = 17
        Caption = 'yyyy'
        TabOrder = 1
      end
      object EditYearWord: TEdit
        Left = 172
        Top = 14
        Width = 49
        Height = 21
        TabOrder = 2
      end
    end
    object GroupBox2: TGroupBox
      Left = 72
      Top = 42
      Width = 241
      Height = 41
      TabOrder = 1
      object Label2: TLabel
        Left = 124
        Top = 18
        Width = 48
        Height = 13
        Caption = #21547#25991#23383#65306
      end
      object RadioButtonMM: TRadioButton
        Left = 8
        Top = 16
        Width = 41
        Height = 17
        Caption = 'mm'
        TabOrder = 0
      end
      object RadioButtonM: TRadioButton
        Left = 64
        Top = 16
        Width = 49
        Height = 17
        Caption = 'm'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object EditMonthWord: TEdit
        Left = 172
        Top = 14
        Width = 49
        Height = 21
        TabOrder = 2
      end
    end
    object GroupBox3: TGroupBox
      Left = 72
      Top = 83
      Width = 241
      Height = 41
      TabOrder = 2
      object Label3: TLabel
        Left = 124
        Top = 18
        Width = 48
        Height = 13
        Caption = #21547#25991#23383#65306
      end
      object RadioButtonDD: TRadioButton
        Left = 8
        Top = 16
        Width = 41
        Height = 17
        Caption = 'dd'
        TabOrder = 0
      end
      object RadioButtonD: TRadioButton
        Left = 64
        Top = 16
        Width = 49
        Height = 17
        BiDiMode = bdLeftToRight
        Caption = 'd'
        Checked = True
        ParentBiDiMode = False
        TabOrder = 1
        TabStop = True
      end
      object EditDayWord: TEdit
        Left = 172
        Top = 14
        Width = 49
        Height = 21
        TabOrder = 2
      end
    end
    object CheckBoxMonth: TCheckBox
      Left = 24
      Top = 58
      Width = 41
      Height = 17
      Caption = #26376#65306
      Enabled = False
      TabOrder = 3
    end
    object CheckBoxYear: TCheckBox
      Left = 24
      Top = 17
      Width = 41
      Height = 17
      Caption = #24180#65306
      Enabled = False
      TabOrder = 4
    end
    object EditFinalFormat: TEdit
      Left = 84
      Top = 132
      Width = 189
      Height = 21
      Enabled = False
      TabOrder = 5
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 9
    Width = 263
    Height = 81
    Align = alTop
    TabOrder = 1
    object BtnOK: TButton
      Left = 112
      Top = 45
      Width = 53
      Height = 25
      Caption = #30830#23450
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnCancel: TButton
      Left = 176
      Top = 45
      Width = 53
      Height = 25
      Caption = #21462#28040
      TabOrder = 1
      OnClick = BtnCancelClick
    end
    object CheckBoxHintWord: TCheckBox
      Left = 11
      Top = 16
      Width = 72
      Height = 17
      Caption = 'HintWord'#65306
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object EditHintWord: TEdit
      Left = 87
      Top = 13
      Width = 142
      Height = 21
      TabOrder = 3
    end
  end
  object CheckBoxDay: TCheckBox
    Left = 24
    Top = 109
    Width = 41
    Height = 17
    Caption = #26085#65306
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 2
  end
end
