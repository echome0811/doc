object SetWorkForIFRSForm: TSetWorkForIFRSForm
  Left = 508
  Top = 247
  Width = 339
  Height = 123
  Caption = #35373#23450'ifrs'#27511#21490#19979#36617#20219#21209
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
  object lbl1: TLabel
    Left = 85
    Top = 14
    Width = 8
    Height = 13
    Caption = 'Q'
  end
  object lbl2: TLabel
    Left = 138
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
  object lbl3: TLabel
    Left = 216
    Top = 14
    Width = 8
    Height = 13
    Caption = 'Q'
  end
  object seYear: TSpinEdit
    Left = 20
    Top = 9
    Width = 60
    Height = 22
    MaxValue = 1000
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
  object cbbQ: TComboBox
    Left = 96
    Top = 10
    Width = 40
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object seYear2: TSpinEdit
    Left = 151
    Top = 9
    Width = 60
    Height = 22
    MaxValue = 1000
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object cbbQ2: TComboBox
    Left = 227
    Top = 10
    Width = 40
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object btnOk: TButton
    Left = 56
    Top = 48
    Width = 75
    Height = 25
    Caption = #30906#23450
    TabOrder = 4
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 152
    Top = 48
    Width = 75
    Height = 25
    Caption = #38364#38281
    TabOrder = 5
    OnClick = btnCancelClick
  end
end
