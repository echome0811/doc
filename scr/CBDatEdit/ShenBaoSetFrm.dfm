object AShenBaoSetFrm: TAShenBaoSetFrm
  Left = 0
  Top = 0
  Width = 622
  Height = 413
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 0
    Top = 408
    Width = 622
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    ResizeStyle = rsUpdate
  end
  object TxtBox: TGroupBox
    Left = 0
    Top = 0
    Width = 622
    Height = 408
    Align = alClient
    TabOrder = 0
    object Txt_Memo: TRichEdit
      Left = 2
      Top = 15
      Width = 618
      Height = 391
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
end
