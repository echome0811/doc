object ACBTodayHintFrm: TACBTodayHintFrm
  Left = 0
  Top = 0
  Width = 622
  Height = 413
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 0
    Top = 139
    Width = 622
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    ResizeStyle = rsUpdate
  end
  object Splitter2: TSplitter
    Left = 489
    Top = 0
    Width = 5
    Height = 139
    Cursor = crHSplit
    ResizeStyle = rsUpdate
  end
  object TxtBox: TGroupBox
    Left = 0
    Top = 144
    Width = 622
    Height = 269
    Align = alBottom
    Caption = #20170#26085#20132#26131#25552#31034#25972#29702#19978#20256#65306
    TabOrder = 0
    object Txt_Memo: TRichEdit
      Left = 2
      Top = 15
      Width = 618
      Height = 252
      Align = alClient
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HideScrollBars = False
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
      Lines.Strings = (
        'Txt_Memo')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = Txt_MemoChange
    end
  end
  object ZZBox: TGroupBox
    Left = 0
    Top = 0
    Width = 489
    Height = 139
    Align = alLeft
    Caption = #20013#35777#20170#26085#20132#26131#25552#31034#65306
    TabOrder = 1
    object ZZTxt_memo: TRichEdit
      Left = 2
      Top = 15
      Width = 485
      Height = 122
      Align = alClient
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HideScrollBars = False
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
      Lines.Strings = (
        'ZZTxt_memo')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object SZBox: TGroupBox
    Left = 494
    Top = 0
    Width = 128
    Height = 139
    Align = alClient
    Caption = #19978#35777#20170#26085#20132#26131#25552#31034#65306
    TabOrder = 2
    object SZTxt_Memo: TRichEdit
      Left = 2
      Top = 15
      Width = 124
      Height = 122
      Align = alClient
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HideScrollBars = False
      ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
      Lines.Strings = (
        'SZTxt_Memo')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
