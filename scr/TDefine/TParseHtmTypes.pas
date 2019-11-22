//******************************************************************************
// File:       TParseHtmTypes.pas
// Content:    提供解析公告网页内容使用的Types
// Author:     JoySun 2005/8/26
//******************************************************************************
unit TParseHtmTypes;

interface

type

  TPageR =Packed record
    NowPage : integer;//当前页面号
    AllPage : integer;//总页面号
  end;

  TTitleR = Packed record
    Caption : String[150];//标题
    Address : String[120];//地址
    TitleDate : Double;//日期
  end;

  TTitleRLst = array of TTitleR;

implementation

end.
