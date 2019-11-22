object ACBDataLogFrm: TACBDataLogFrm
  Left = 0
  Top = 0
  Width = 876
  Height = 534
  TabOrder = 0
  object PanelUP: TPanel
    Left = 0
    Top = 0
    Width = 876
    Height = 41
    Align = alTop
    TabOrder = 0
    object BitBtnRefresh: TBitBtn
      Left = 144
      Top = 6
      Width = 65
      Height = 25
      Caption = #21047#26032
      TabOrder = 0
      OnClick = BitBtnRefreshClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000929EA27A8284
        666D70656D70656D706B71747175767778787A82848D908F8B989C926F58B33E
        19DB5B06777878A9BAC1929EA2DEDEDBDEDBD0CDCDC8CACAC4CACAC4D1CFC7D1
        CFC7D7D4C9C5D7D2AB9B8DCE4B24F65400926F5897A6ACACBEC39CACB0EBEAE3
        FFFFFCF4F2EDFCFBF4FEFFF8FEFFF8FEFFF8EDF5F0C9B5A4CE4B24F65400FA72
        00898F93B4C3C9AFC0C5ADBBBEB7C0C0FFFFFFFDFBF9EFF5FACED5D7B5B8B9B4
        C3C9B4C3C9D1755AF65400FA7200EC854891A1A6AFC0C6B2C1C6B3C3C79FA7A9
        FFFFFFFDFFFFB4A294926F58A46D3AA46D3A926F58DBBCB3FDB15FEC7A36EECF
        CE9BA3A6AEBEC1B3C3C7B7C6CA9FA7A9FFFFFFF4F2EDD99124FBC538F9DB4FF9
        DB4FE7B033EFC594EECFCEEECFCEFDFBFC9FA7A9ADBBBEB4C3C9BCCDD29EAAAD
        ECEEEEF5D5B0FBC538FFF259FFF259FFFA68FFFA68E7B033B08C69D3DADDFFFF
        FFABACAAAEBEC1B7C6CABCCDD2A2B1B5D1CFC7FDDC6AF9DB4FFDDC6AFDDC6AFD
        DC6AFFFA68F9DB4FCB8A2FB7A89CF6F9F9ABB2B3ADBBBEB7C6CAC1D0D3ADBBBE
        BFBBADFDB15FFDDC6AFDDC6AFDDC6AFDDC6AFDDC6AF9DB4FD99124B08C69E7ED
        EDACB0AEA7B4B7BBCBCCC7D4D6BBCBCCABACAAFDB15FFAF0A6FAF0A6FEEA96FD
        DC6AFDDC6AFBC538E79216CAA884E1E4E49EA09BA7B4B7C0CDD1CDD9DCC0CDD1
        ACB0AEEFC594EDE2C7FFFFFCFFF8C4FEEA96FDDC6AF4AA19E99725C9B5A4D7D9
        D79EA09BA9B7B9C7D4D6D5E0E0C6D1D5ABB2B3FDF5D5D9A566F0E8D7FDF5D5FA
        F0A6EAAE4EE79216D9A566C5C4BBBFBBAD989B98C0C7C8CDD9DCDBE4E7CED5D7
        ACB0AEFDFEFDD9A566DEA157D9A566DEA157EAAE4EDDB47BBFBBADCACAC4D1CF
        C7989B98D3DADDD5E0E0E1EAEAD3DADDACB0AEFCFBF4F0E8D7F5D5B0EFC594EF
        C594EDE2C7D7D9D7BFBBADD7D4C9FFFFFFACB0AEE1EAEADEE6E6EBF0F1D8DEDE
        ABACAAFCFBF4ECEEEEEFF4F4EFF3F3EFF1F1EDF2F4E5E3DBBFBBADE5E3DBFAFA
        F9DEE2E3EBF0F1E7EDEDF2F5F6DEE2E3B5B8B9FCFBF4EBEAE3EBEAE3EBEAE3F0
        EEE8F4F2EDE5E3DBD7D4C9EBEAE3CDCDC8F2F5F6F2F5F6EFF3F3}
    end
    object dxDateEditLogDate: TdxDateEdit
      Left = 28
      Top = 8
      Width = 101
      ImeName = #24494#36719#25340#38899#36755#20837#27861' 2007'
      TabOrder = 1
      Date = 39746.5865751505
      DateButtons = [btnToday]
      UseEditMask = True
      StoredValues = 4
    end
  end
  object dxTreeListLog2: TdxTreeList
    Left = 0
    Top = 41
    Width = 876
    Height = 493
    Bands = <
      item
      end>
    DefaultLayout = True
    HeaderPanelRowCount = 1
    Align = alClient
    TabOrder = 1
    Options = [aoColumnSizing, aoColumnMoving, aoEditing, aoTabThrough, aoRowSelect, aoAutoSort]
    OptionsEx = [aoUseBitmap, aoBandHeaderWidth, aoAutoCalcPreviewLines, aoBandSizing, aoBandMoving, aoFullSizing, aoDragScroll, aoDragExpand, aoRowAutoHeight, aoMultiSort, aoAutoSortRefresh, aoAnsiSort]
    DefaultRowHeight = 27
    HighlightColor = clLime
    TreeLineColor = clGrayText
    HideSelectionColor = clLime
    HideSelectionTextColor = clBlack
    ShowGrid = True
    ShowRoot = False
    OnCustomDraw = dxTreeListLog2CustomDraw
    Data = {
      FFFFFFFF01000000180000000000000000000000FFFFFFFF0000000000000000
      050000001500000046696C654E616D653AD7AAB9C9D3E0B6EEB5F7D5FB1B0000
      00446F6343656E746572205361766554696D653A31353A33303A32331A000000
      446F634674705F31205361766554696D653A31353A33303A323519000000446F
      634674705F32205361766554696D653A576169742E2E2E13000000446F634674
      702046696E6973683A46616C7365}
    object TL2ColFileName: TdxTreeListColumn
      Caption = 'FileName'
      Width = 181
      BandIndex = 0
      RowIndex = 0
    end
    object TL2ColSaveTime: TdxTreeListColumn
      Caption = 'TL2ColSaveTime'
      Width = 194
      BandIndex = 0
      RowIndex = 0
    end
    object TL2ColFtpUpLoadState: TdxTreeListColumn
      Caption = 'FtpState'
      Width = 207
      BandIndex = 0
      RowIndex = 0
    end
    object TL2ColFileNameEn: TdxTreeListColumn
      Caption = 'FileNameEn'
      Width = 184
      BandIndex = 0
      RowIndex = 0
    end
    object dxTreeListLog2Column5: TdxTreeListColumn
      Width = 151
      BandIndex = 0
      RowIndex = 0
    end
    object dxTreeListLog2Column6: TdxTreeListColumn
      BandIndex = 0
      RowIndex = 0
    end
    object dxTreeListLog2Column7: TdxTreeListColumn
      BandIndex = 0
      RowIndex = 0
    end
    object dxTreeListLog2Column8: TdxTreeListColumn
      BandIndex = 0
      RowIndex = 0
    end
    object dxTreeListLog2Column9: TdxTreeListColumn
      BandIndex = 0
      RowIndex = 0
    end
    object dxTreeListLog2Column10: TdxTreeListColumn
      BandIndex = 0
      RowIndex = 0
    end
    object dxTreeListLog2Column11: TdxTreeListColumn
      BandIndex = 0
      RowIndex = 0
    end
  end
  object IdTCPClient1: TIdTCPClient
    MaxLineAction = maException
    Port = 0
    Left = 736
    Top = 48
  end
end
