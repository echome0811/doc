object UserMngForm: TUserMngForm
  Left = 331
  Top = 126
  BorderStyle = bsSingle
  Caption = 'UserMng'
  ClientHeight = 417
  ClientWidth = 422
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 398
    Width = 422
    Height = 19
    Panels = <
      item
        Style = psOwnerDraw
        Width = 100
      end
      item
        Width = 150
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object pnl1: TPanel
    Left = 0
    Top = 370
    Width = 422
    Height = 28
    Align = alBottom
    TabOrder = 1
    object btnNewUser: TButton
      Left = 26
      Top = 4
      Width = 65
      Height = 25
      Caption = #24320#26032#29992#25143'(&A)'
      TabOrder = 0
      OnClick = btnNewUserClick
    end
    object btnDelUser: TButton
      Left = 158
      Top = 4
      Width = 65
      Height = 25
      Caption = #21024#38500#29992#25143'(&D)'
      TabOrder = 1
      OnClick = btnDelUserClick
    end
    object btnSave: TButton
      Left = 92
      Top = 4
      Width = 65
      Height = 25
      Caption = #20445#23384'(&S)'
      TabOrder = 2
      OnClick = btnSaveClick
    end
    object btnQuit: TButton
      Left = 224
      Top = 4
      Width = 65
      Height = 25
      Caption = #36864#20986'(&Q])'
      TabOrder = 3
      OnClick = btnQuitClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 422
    Height = 370
    Align = alClient
    TabOrder = 2
    object Label3: TLabel
      Left = 175
      Top = 2
      Width = 42
      Height = 13
      Caption = #26435#38480#65306
      Visible = False
    end
    object Label1: TLabel
      Left = 6
      Top = 4
      Width = 70
      Height = 13
      Caption = #29992#25143#21015#34920#65306
    end
    object Label2: TLabel
      Left = 3
      Top = 343
      Width = 56
      Height = 13
      Caption = #29992#25143#21517#65306
    end
    object Label4: TLabel
      Left = 143
      Top = 343
      Width = 42
      Height = 13
      Caption = #23494#30721#65306
    end
    object PageControl1: TPageControl
      Left = 168
      Top = 22
      Width = 250
      Height = 315
      ActivePage = TabSheet_EditSet
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabIndex = 1
      TabOrder = 0
      object TabSheet_LookSet: TTabSheet
        Caption = #26597#30475#35774#23450
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        object ChkListBoxModouleLook: TCheckListBox
          Left = -2
          Top = -1
          Width = 248
          Height = 290
          OnClickCheck = ChkListBoxModouleLookClickCheck
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ItemHeight = 13
          Items.Strings = (
            #36716#32929#20313#39069
            #36716#32929#20215#26684#35843#25972
            #20132#26131#26085#25968'/'#19978#28014#24133#24230
            #32593#19978'/'#32593#19979
            #32593#19978'/'#32593#19979'('#26087')'
            #26465#27454#21407#25991
            #21215#38598#36164#37329#29992#36884
            #21313#22823#32929#19996
            #22522#26412#38754#36164#26009
            #37325#35201#26085#26399
            #20225#19994#20538
            #20572#21457#20844#21578#35774#23450
            #20170#26085#20132#26131#25552#31034
            #19977#22823#27861#20154
            #33258#33829#21830
            #20572#27490#36716#25442#26399#38388
            #36174#22238#26085#26399
            #21334#22238#26085#26399
            'CB'#36164#26009#19978#20256#26597#30475
            #25805#20316#35760#24405#26597#35810)
          TabOrder = 0
        end
      end
      object TabSheet_EditSet: TTabSheet
        Caption = #36755#20837#35774#23450
        ImageIndex = 1
        object ChkListBoxModouleEdit: TCheckListBox
          Left = 0
          Top = 1
          Width = 248
          Height = 290
          OnClickCheck = ChkListBoxModouleEditClickCheck
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ItemHeight = 13
          Items.Strings = (
            #36716#32929#20313#39069
            #36716#32929#20215#26684#35843#25972
            #20132#26131#26085#25968'/'#19978#28014#24133#24230
            #32593#19978'/'#32593#19979
            #32593#19978'/'#32593#19979'('#26087')'
            #26465#27454#21407#25991
            #21215#38598#36164#37329#29992#36884
            #21313#22823#32929#19996
            #22522#26412#38754#36164#26009
            #37325#35201#26085#26399
            #20225#19994#20538
            #20572#21457#20844#21578#35774#23450
            #20170#26085#20132#26131#25552#31034
            #19977#22823#27861#20154
            #33258#33829#21830
            #20572#27490#36716#25442#26399#38388
            #36174#22238#26085#26399
            #21334#22238#26085#26399
            'CB'#36164#26009#19978#20256#26597#30475
            #25805#20316#35760#24405#26597#35810)
          ParentFont = False
          TabOrder = 0
        end
      end
      object TabSheet_BtnKeyWordSet: TTabSheet
        Caption = #25353#38062#26631#39064#35774#23450
        ImageIndex = 2
        object pnlBtnKeyWordSet: TPanel
          Left = 169
          Top = 0
          Width = 73
          Height = 289
          Align = alRight
          TabOrder = 0
          object btnKWSAdd: TButton
            Left = 6
            Top = 3
            Width = 60
            Height = 25
            Caption = #26032#22686'(&N)'
            TabOrder = 0
            OnClick = btnKWSAddClick
          end
          object btnKWSEdit: TButton
            Left = 6
            Top = 28
            Width = 60
            Height = 25
            Caption = #20462#25913'(&E)'
            TabOrder = 1
            OnClick = btnKWSEditClick
          end
          object btnKWSOmit: TButton
            Left = 6
            Top = 54
            Width = 60
            Height = 25
            Caption = #21024#38500'(&O)'
            TabOrder = 2
            OnClick = btnKWSOmitClick
          end
          object edtTitleSet: TEdit
            Left = 0
            Top = 81
            Width = 71
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
        end
        object lstBtnKeyWord: TListBox
          Left = 0
          Top = 0
          Width = 169
          Height = 289
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ItemHeight = 13
          Items.Strings = (
            #26032#22686
            #21024#38500
            #20462#25913
            #25554#20837
            #36716#32929#21407#22240
            #36174#22238#21407#22240
            #21334#22238#21407#22240
            #21024#38500#26085#26399
            #26032#22686#26085#26399
            #22238#34917#36164#26009
            #19978#31227
            #19979#31227)
          ParentFont = False
          TabOrder = 1
        end
      end
    end
    object ChkBoxSuperUser: TCheckBox
      Left = 216
      Top = 0
      Width = 89
      Height = 17
      Caption = #36229#32423#29992#25143
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Visible = False
      OnClick = ChkBoxSuperUserClick
    end
    object ListBoxUser: TListBox
      Left = 0
      Top = 26
      Width = 164
      Height = 309
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 2
      OnClick = ListBoxUserClick
    end
    object edtUser: TEdit
      Left = 53
      Top = 339
      Width = 85
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 3
    end
    object edtPsw: TEdit
      Left = 179
      Top = 339
      Width = 85
      Height = 21
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      PasswordChar = '*'
      TabOrder = 4
    end
    object chkSelectAll: TCheckBox
      Left = 328
      Top = 0
      Width = 65
      Height = 17
      Caption = #20840#36873
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = chkSelectAllClick
    end
  end
  object IdTCPClient1: TIdTCPClient
    OnStatus = IdTCPClient1Status
    MaxLineAction = maException
    OnWork = IdTCPClient1Work
    OnWorkBegin = IdTCPClient1WorkBegin
    OnWorkEnd = IdTCPClient1WorkEnd
    Port = 0
    Left = 104
    Top = 104
  end
end
