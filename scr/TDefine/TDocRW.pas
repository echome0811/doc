unit TDocRW;

interface
uses SysUtils,Forms,TCommon,Dialogs;

type
  //add by wangjinhua ThreeTrader 091015
  TDAILY_THREETRADER_RPT = Record
    SEC_ID          : String[8]; //证券代号

    FOREIGN_BUY     : Longint	;  //外資及陸資買
    FOREIGN_SALE    : Longint	;  //外資及陸資賣
    FOREIGN_NET     : Longint	;  //外資及陸資淨買

    INVEST_BUY      : Longint	;  //投信買進股數
    INVEST_SALE     : Longint	;  //投信賣股數
    INVEST_NET      : Longint	;  //投信淨買股數

    DEALER_BUY      : Longint	;  //自營商買股數
    DEALER_SALE     : Longint	;  //自營商賣股數
    DEALER_NET      : Longint	;  //自營淨買股數

    THREETRADER_COUTN:Longint	;  //三大法人買賣超股數
  End;
  PDAILY_THREETRADER_RPT = ^TDAILY_THREETRADER_RPT;
  TDAILY_THREETRADER_RPTS = Array of TDAILY_THREETRADER_RPT;
  //--


  TDAILY_TRADE_RPT = Record
    SEC_ID          : String[8]; //证券代号
    SEC_DEALER_ID   : String[5]; //证券商ID
    BUY_COUNT       : Cardinal;  //买进成交量
    BUY_PRICE       : Cardinal;  //买进金额
    SELL_COUNT      : Cardinal;  //买出成交量
    SELL_PRICE      : Cardinal;  //买出金额
  End;
  PDAILY_TRADE_RPT = ^TDAILY_TRADE_RPT;

  TSEC_DEALER = Record
    SEC_DEALER_ID   : String[5];  //证券商ID
    SEC_DEALER_NAME : String[50]; //证券商名称
  End;

  TSTOPCONV_PERIOD_DETAIL = Record
    DOC_FILENAME    : String[50]; //公告文件名称
    START_DATE      : Double;      //开始日期
    END_DATE        : Double ;     //停止日期
  End;

  TSTOPCONV_PERIOD_RPT= Record
    ID                 : String[6]; //证券代号
    ASTOPCONV_DETAILS  : Array[0..15] of TSTOPCONV_PERIOD_DETAIL //期间数值
  End;

  //--DOC4.0.0—N004 huangcq090317 add  赎回、卖回 结构共用----->
  TREDEEMSALE_PERIOD_DETAIL = Record
    DOC_FILENAME    : String[50]; //公告文件名称
    REASON          : String[50]; //原因
    START_DATE      : Double;      //开始日期
    END_DATE        : Double ;     //停止日期
    PRICE           : Double;    //价格
  End;

  TREDEEMSALE_PERIOD_RPT= Record
    ID              : String[6]; //证券代号
    DETAILS         : Array[0..15] of TREDEEMSALE_PERIOD_DETAIL; //期间数值
  End;
  //<----DOC4.0.0—N004 huangcq090317 add---

 {$IFNDEF _DocRW}

  //保存自营商进出资料
  Function _SaveSecDealerData(aRecLst :Array of TDAILY_TRADE_RPT;aFileName:PChar):Boolean;far; external 'DocRW.dll';
  //获得自营商进出资料Record大小
  Function _GetSecDealerDataCount(aFileName:PChar):Integer;far; external 'DocRW.dll';
  //获得某日的资料文件(20060404.dat)中所有自营商进出数据(用于筹码分析c)
  Function _GetSecDealerDataAll(var aRecLst :Array of TDAILY_TRADE_RPT):Boolean;far; external 'DocRW.dll';
  //获得某日的资料文件(20060404.dat)中某一证商对某一转债的买卖信息(用于筹码分析d)(用于筹码分析e)
  Function _GetSecDealerData(var aRec :TDAILY_TRADE_RPT;aSecID,aDealerID,aFileName:PChar):Boolean;far; external 'DocRW.dll';

  //获得自营商ID，若有则返回，否则加到后面
  Function _GetSec_DealerID(aDealerName,aFileName :PChar):Pchar;far; external 'DocRW.dll';
  //获得自营商名称
  Function _GetSec_DealerName(aDealerID,aFileName :PChar):PChar;far; external 'DocRW.dll';

  //获得自营商编号Record大小
  Function _GetSec_DealerIndexCount(aFileName:PChar):Integer;far; external 'DocRW.dll';
  //获得所有的自营商编号资料
  Function _GetSec_DealerIndexAll(var aRecLst :Array of TSEC_DEALER):Boolean;far; external 'DocRW.dll';

  //保存停止转换期间资料到某转换日期资料文件(StopConv.dat)中
  Function _SaveSecStopConvFile(aRecLst:Array of TSTOPCONV_PERIOD_RPT;aFileName :PChar):Boolean;far; external 'DocRW.dll';
  //获得某转换日期资料文件(StopConv.dat)中停止转换期间资料Record大小
  Function _GetSecStopConvDataCount(aFileName:PChar):Integer;far; external 'DocRW.dll';
  //获得某转换日期资料文件(StopConv.dat)中全部的停止转换期间资料
  Function _GetStopConvDataAll(var aRecLst :Array of TSTOPCONV_PERIOD_RPT):Boolean;far; external 'DocRW.dll';
  //获得某转换日期资料文件(StopConv.dat)中某一转债ID的停止转换期间数据
  Function _GetStopConvData(var aRec :TSTOPCONV_PERIOD_RPT;aSecID,aFileName:PChar):Boolean;far; external 'DocRW.dll';

  //--DOC4.0.0—N004 huangcq090317 add ---->
   //获得赎回、卖回资料文件(CBRedeemDate.dat\CBSaleDate.dat)中所有ID的个数
  Function _GetSecRedeemSaleDataCount(aFileName:PChar):Integer;far; external 'DocRW.dll';
   //获得赎回、卖回资料文件(CBRedeemDate.dat\CBSaleDate.dat)中全部的资料
  Function _GetRedeemSaleDataAll(var aRecLst :Array of TREDEEMSALE_PERIOD_RPT):Boolean;far; external 'DocRW.dll';
   //获得赎回、卖回资料文件(CBRedeemDate.dat\CBSaleDate.dat)中某ID的数据
  Function _GetRedeemSaleData(var aRec :TREDEEMSALE_PERIOD_RPT;aSecID,aFileName:PChar):Boolean;far; external 'DocRW.dll';
  //<---DOC4.0.0—N004 huangcq090317 add---  

  //获得证券相关信息
  Function _GetSecID(aFileName,aSecName :PChar):Pchar;far; external 'DocRW.dll';
  Function _GetSecName(aFileName,aSecID :PChar):Pchar;far; external 'DocRW.dll';

  //错误信息返回
  Function _GetLastErrorMsg():PChar;far; external 'DocRW.dll';

 {$ENDIF}
 //add by wangjinhua ThreeTrader 091015
 Function SaveSecThreeTraderData(aRecLst :TDAILY_THREETRADER_RPTS;aFileName:PChar):Boolean;
 Function GetSecThreeTrader(aFileName:PChar;var aRecLst :TDAILY_THREETRADER_RPTS):Integer;
 Function SaveSecThreeTrader(aRecLst :TDAILY_THREETRADER_RPTS;aFileName:PChar):Boolean;
 //--

implementation


//add by wangjinhua ThreeTrader 091015
Function SaveSecThreeTraderData(aRecLst :TDAILY_THREETRADER_RPTS;aFileName:PChar):Boolean;
var
  Rec :TDAILY_THREETRADER_RPT;
  ThreeTraderFile : File Of TDAILY_THREETRADER_RPT;
  i: Integer;
Begin
  Result :=false;
try
try
  if FileExists(aFileName) Then
    DeleteFile(aFileName);
  Mkdir_Directory(ExtractFilePath(StrPas(aFileName)));
  AssignFile(ThreeTraderFile,StrPas(aFileName));
  FileMode := 2;

  For i:=0 To High(aRecLst) Do
  Begin
    Application.ProcessMessages;
    Rec :=aRecLst[i];

    if Not FileExists(aFileName) Then
    Begin
       ReWrite(ThreeTraderFile);
       Write(ThreeTraderFile,Rec);
    End Else
    Begin
      ReSet(ThreeTraderFile);
      if FileSize(ThreeTraderFile)>0 Then
      Begin
        Seek(ThreeTraderFile,FileSize(ThreeTraderFile));
        Write(ThreeTraderFile,Rec);
      End;
    End;
  End;
  Result :=true;
Except
  On E:Exception Do
  begin
    ShowMessage(e.Message);
    e := nil;
  end;
End;
finally
  try
      CloseFile(ThreeTraderFile);
  except
  end;
end;
End;



Function GetSecThreeTrader(aFileName:PChar;var aRecLst :TDAILY_THREETRADER_RPTS):Integer;
var
  ThreeTraderFile : File Of TDAILY_THREETRADER_RPT;
  i: Integer;
Begin
  Result :=0;
  SetLength(aRecLst,0);
try
try
  if(not FileExists(aFileName))then exit;
  AssignFile(ThreeTraderFile,StrPas(aFileName));
  FileMode := 0;
  ReSet(ThreeTraderFile);
  SetLength(aRecLst,FileSize(ThreeTraderFile));
  BlockRead(ThreeTraderFile,aRecLst[0],Length(aRecLst));
  Result := Length(aRecLst);
Except
  On E:Exception Do
  begin
    ShowMessage(e.Message);
    e := nil;
  end;
End;
finally
  try
      CloseFile(ThreeTraderFile);
  except
  end;
end;
End;


Function SaveSecThreeTrader(aRecLst :TDAILY_THREETRADER_RPTS;aFileName:PChar):Boolean;
var
  Rec :TDAILY_THREETRADER_RPT;
  ThreeTraderFile : File Of TDAILY_THREETRADER_RPT;
  i: Integer;
Begin
  Result :=false;
try
try
  if FileExists(aFileName) Then
    DeleteFile(aFileName);
  Mkdir_Directory(ExtractFilePath(StrPas(aFileName)));
  AssignFile(ThreeTraderFile,StrPas(aFileName));
  FileMode := 2;
  if Length(aRecLst) = 0 then
    exit;
  For i:=0 To High(aRecLst) Do
  Begin
    Application.ProcessMessages;
    Rec :=aRecLst[i];
    if Not FileExists(aFileName) Then
    Begin
       ReWrite(ThreeTraderFile);
       Write(ThreeTraderFile,Rec);
    End Else
    Begin
      ReSet(ThreeTraderFile);
      if FileSize(ThreeTraderFile)>0 Then
      Begin
        Seek(ThreeTraderFile,FileSize(ThreeTraderFile));
        Write(ThreeTraderFile,Rec);
      End;
    End;

  End;
  Result :=true;
Except
  On E:Exception Do
  begin
    ShowMessage(e.Message);
    e := nil;
  end;
End;
finally
  try
      CloseFile(ThreeTraderFile);
  except
  end;
end;
End;
//--


end.
