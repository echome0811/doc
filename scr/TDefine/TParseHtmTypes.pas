//******************************************************************************
// File:       TParseHtmTypes.pas
// Content:    �ṩ����������ҳ����ʹ�õ�Types
// Author:     JoySun 2005/8/26
//******************************************************************************
unit TParseHtmTypes;

interface

type

  TPageR =Packed record
    NowPage : integer;//��ǰҳ���
    AllPage : integer;//��ҳ���
  end;

  TTitleR = Packed record
    Caption : String[150];//����
    Address : String[120];//��ַ
    TitleDate : Double;//����
  end;

  TTitleRLst = array of TTitleR;

implementation

end.
