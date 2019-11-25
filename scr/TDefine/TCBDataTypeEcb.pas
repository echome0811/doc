unit TCBDataTypeEcb;

interface
  Uses
    Controls, Classes,SysUtils;

Const
  NoneNum   = -999999999;
  ValueEmpty  = -888888888;
  BlockSize  =  100;

  MARKET_VER  = 'dblst.dat';
  MARKET_DB   = 'market_db.dat';
  BASEDATGUID = 'basedatlst.lst'; 

  HUSHI_CN = 'hushi.dat';
  SHENSHI_CN = 'shenshi.dat';
  GUAPAI_CN = 'guapai.dat';
  PASSAWAY_CN = 'passaway.dat';

  SHANGSHI_TW = 'shangshi.dat';
  SHANGGUI_TW = 'shanggui';
  GUAPAI_TW = 'guapai.dat';
  PASSAWAY_TW = 'passaway.dat';
         
  CBIDX = 'cbidx.dat';
  CBISSUE = 'cbissue2.dat';
  STRIKE2 = 'strike2.dat';
  STRIKE3 = 'strike3.dat';
  BOND='bond.dat';

  CBIDX_TW = 'cbidx.dat';
  CBISSUE_TW = 'cbissue2.dat';
  STRIKE2_TW = 'strike2.dat';
  STRIKE3_TW = 'strike3.dat';
  BOND_TW='bond.dat';

type
//class.dat
TFClass = Record
     CID : String[38];
     MEM : String[38];
End;

TDividend = Packed Record
   DividendDate : TDate;
   S_Rate  : Double;
   D_Rate  : Double;
   D_Price : Double;
   D_Money : Double;
End;

TCBBond = Packed Record
      ID : String[38];
      IDate,LDate : TDate;
      Year : Integer;
      BIR  : Double;
      Option : Integer;
End;
TCBBondP = ^TCBBond;
TCBBondLst  = Array of TCBBond;


//き醱瞳薹ㄛ甡�梪硪創羷阪�(汔蹶)************************************************
  TInterestData = Record
    IR:Array[0..49] of Double; //瞳薹(%)(瞰ㄩ0.01(啎扢峈1%ㄛ褫扢隅))
  End;
//Notice:跺杅迵湔哿ぶ潔眈肮
//******************************************************************************


  TCBBaseFPutData=Packed Record
   //rs6224 Update 311
   //P_DNum : Integer;
   FP_Date : TDate;
   FV_Percent : Double;
   IR_Option  : Integer;
  End;
  TCBBaseFPutDataP = ^TCBBaseFPutData;

  TCBBaseReset2Dat=Packed Record
    ResetDate:TDate;
    R_Percent:Double;
  End;
  TCBBaseReset2DatP = ^TCBBaseReset2Dat;

  TCBBaseReset2DataDat =Packed Record
    CK_Days:Array of Integer;
    Reset2 :TList;
  end;

  TCBInterestData = Packed Record
   SER : Integer;
   Interest : Double;
  End;
  TCBInterestDataLST = Array of TCBInterestData;

  TCBCallData = Packed Record
     Avg : Boolean;
     B_Month : Integer;
     E_Month : Integer;
     C_Dnum  : Integer;
     L_DNum  : Integer;
     C_Percent : Double;
     V_Percent : Double;
     //rs6224 update 311
     A_Return : Double;
     I_Option : Integer;
  End;
  TCBCallDataP = ^TCBCallData;

  TCBPutData = Packed Record
   Avg : Boolean;
   B_Month : Integer;
   E_Month : Integer;
   C_Dnum  : Integer;
   L_DNum  : Integer;
   C_Percent : Double;
   V_Percent : Double;
   I_Option  : Integer;
  End;
  TCBPutDataP = ^TCBPutData;

  TCBBaseCfgData=Packed Record
    Reset_Option: Byte;
    Reset_Check : Boolean;
    Call_Check  : Boolean;
    Put_Check   : Boolean;
    Dividend_Check : Boolean;
    FPut_Check : Boolean;
  End;

 TCBBaseDatData=Packed Record
   Scale : Double;
   TradeCode : string[38];
   TCExg   : string[2];
   StkCode : string[38];
   SCExg : string[2];

   I_Date : TDate;
   Duration : Double;
   P_Date : TDate;
   Spot   : Double;
   Strike : Double;
   Vol : Double;
   IR : Double;
   CR_Premium : Double;
   B_IR : Double;
   LRisk : Double; //流動性風險
   IDateCurncy : Double; //發行匯率
   C_Month   : Integer;

   Interest_Chk : Boolean;
   Interest : Double;

   DateCurncy : Double;
   IPrice : Double; //發行價格
   IAmount: Double; //發行面額
  End;

  TCBBaseResetData=Packed Record
   B_Month   : Integer;
   E_Month   : Integer;
   C_DNum    : Integer;
   L_DNum    : Integer;
   C_Percent : Double;
   R_Percent : Double;
   P_Option  : Integer;
   R_Period  : Integer;
   Avg       : Boolean;
  End;

  TCBClassData =Packed Record
    CID : String[38];   //市場txt轉化后文件的CID
    Name : String[38];  //市場txt轉化后文件的MEM
    //HaveUpdate : Boolean;
    BaseLst   : TList; //TCBBaseP //市場txt轉化后文件的每個ID的單元rec
    //ChartLst  : TList; //TCBChartP
    //RptLst    : TList; //TCBRptP
  End;
  TCBClassDataP = ^TCBClassData;

  TCBBaseData = Packed Record
    BID : String[38];
    Name : String[38];
    //AddNew    : Boolean;
    BaseCfg : TCBBaseCfgData;   //config
    //BasePrice : TCBBasePrice;
    BaseDat : TCBBaseDatData;  //基本資料

    BaseFPut : TList; //TCBBaseFPutDataP //賣回條款
    BaseReset : TCBBaseResetData;        //重設
    BaseReset2 : TCBBaseReset2DataDat;   //定點重設

    InterestLst : TCBInterestDataLST;     //票面利率

    PutLst    : TList;    //TCBPutDataP    //動態回售
    //DividendLst  : TList; //TCBDividendP
    CallLst : TList; //TCBCallDataP   //贖回
    //ChartLst     : TList; //TCBChartP

    //CBDocCount  : Integer;
    //StkDocCount : Integer;

    //ChartOutDataKey : Integer;
    //ChartOutDataOut : Integer;
    //ChartOutData    : TACBHistoryOut;
  End;
  TCBBaseDataP = ^TCBBaseData;

  TCBBaseReset2Rec=Packed Record
    ResetDate:TDate;
    R_Percent:Double;
  End;
  TCBBaseReset2RecP = ^TCBBaseReset2Rec;

  TCBBaseReset2DataRec =Packed Record
    CK_Days:Array[0..15] of Integer;
    Reset2 :Array[0..15] of TCBBaseReset2Rec;
  end;

  TCBBaseRec = Record
    CID : String[38];   //市場txt轉化后文件的CID
    CIDName : String[38];  //市場txt轉化后文件的MEM
    BID : String[38];
    BIDName : String[38];
    BaseCfg : TCBBaseCfgData;   //config                  //全
    BaseDat : TCBBaseDatData;  //基本資料                 //少兩個
    BaseFPut : Array[0..15] of TCBBaseFPutData; //賣回條款
    BaseReset : TCBBaseResetData;        //重設
    BaseReset2 : TCBBaseReset2DataRec;   //定點重設
    InterestLst :  Array[0..15] of TCBInterestData;     //票面利率
    PutLst : Array[0..15] of TCBPutData;    //動態回售
    CallLst : Array[0..15] of TCBCallData;   //贖回
    DivLst : Array[0..15] of TDividend; 
  end;
  TCBBaseRecP = ^TCBBaseRec;
  TCBBaseRecLst = Array of TCBBaseRec;

  TACBIdxData = Packed Record
    BaseDate : TDate;     //日期
    Value : Double;       //值
  End;

  TCBIdxData = Packed Record
    ID : String[38];
    //CloseDate : TDate;
    //PXELst : Array of TACBIdxData;
    MZYELst : Array of TACBIdxData;
  End;
  TCBIdxDataP = ^TCBIdxData;
  //TCBIdxLst  = Array of TCBIdx;

  TCBIdxRec = Packed Record
    ID : string[38];
    BaseDate : TDate;     //日期
    Value : Double;       //值
  end;
  TCBIdxRecLst  = Array of TCBIdxRec;

 TCBIssueData = Packed Record
    ID : String[38];
    CBClass : ShortString;  //信用等級
    Member1 : ShortString;  //主承銷商
    Member2 : ShortString;  //副承銷商
    Member3 : ShortString;  //擔保人
    a1 : Boolean;//原有股東
    a2 : Double;//申購金額
    a3 : Double;//占發行量
    a4 : Double;//配售比例
    b1 : Boolean;//網上
    b2 : Double;//申購金額
    b3 : Double;//占發行量
    b4 : Double;//配售比例
    c1 : Boolean;//網下
    c2 : Double;//申購金額
    c3 : Double;//定金比例
    c4 : Double;//占發行量
    c5 : Double;//配售比例
  End;
  TCBIssueDataP = ^TCBIssueData;
  TCBIssueDataLst  = Array of TCBIssueData;

  TCBStrikeData = Packed Record
    BaseDate : TDate;//調整轉換日
    Price    : Double;
    Memo     : ShortString;
  End;

  TACBStrikeData = Packed Record
    ID : string[38];
    CBStrikeLst : Array of TCBStrikeData;
  End;
  TACBStrikeDataP = ^TACBStrikeData;
  TCBStrikeDataLst = array of TACBStrikeData;

  TAFullCBStrikeData = Packed Record
    ID : string[38];
    CBStrikeLst : Array[0..1] of TACBStrikeDataP;
  End;
  TAFullCBStrikeDataP = ^TAFullCBStrikeData;
  TFullCBStrikeDataLst = array of TAFullCBStrikeData;

  TCBStrikeRec = Packed Record
    ID : string[38];
    BaseDate : TDate;//調整轉換日
    //add by wjh 20120207 5.0.8.1
    BaseDate2 : TDate;//除權除息日
    Price : Double;
    Memo : shortstring;
  end;
  TCBStrikeRecLst = Array of TCBStrikeRec;

  TCBStrike3Data = Packed Record
    ID : String[38];     //ID代碼
    Days : String[50]; //交易日數
    D1   : Double;   //上浮幅度
    //D2   : Double;
  End;
  TCBStrike3DataP = ^TCBStrike3Data;
  TCBStrike3DataLst  = Array of TCBStrike3Data;

  TFAStockData = Packed Record //股票
    StockID   :String[38];
   // Vocation  :String[20];
    Exg       :String[2];
    //Cls       :String[2];
    //Tid       :String[2];
    //Kid       :String[3];
    //Gid       :String[2];
    StockName :String[20];
    //KidName   :String[30];
    //GidName   :String[20];
    //ExgName   :String[10];
  End;
  TFAStockDataP = ^TFAStockData;
  TFStocks = Array of TFAStockData;

 {  TTr1StkRec = Packed Record
      EID : String[2];
      SID : String[6];
      CID : String[2];
      TID : String[2];
      KID : String[2];
      SName : String[8];
    End;   }

  procedure InitRecOfTCBBaseRec(var aRec:TCBBaseRec);
  function SameRecOfTCBBaseRec(r1,r2:TCBBaseRec):boolean;
  function GetTextOfACBClass(aTw:boolean;aPath,aCid:string):string;
  //aFlag=0 (all trcode)
  //aFlag=1 (only passway trcode)
  //aFlag=2(except passway trcode)
  function GetTradeCodeList(aPath:string;aFlag:integer;var ts:TStringList):Boolean;
  
implementation

procedure InitRecOfTCBBaseRec(var aRec:TCBBaseRec);
var j:Integer;
begin
  aRec.CID:='';
  aRec.CIDName:='';
  aRec.BID:='';
  aRec.BIDName:='';
  with aRec.BaseCfg do
  begin
    Reset_Option:=0;
    Reset_Check :=False;
    Call_Check  :=False;
    Put_Check   :=False;
    Dividend_Check :=False;
    FPut_Check :=False;
  end;
  with aRec.BaseDat do
  begin
    Scale :=NoneNum;
    TradeCode :='';
    TCExg   :='';
    StkCode :='';
    SCExg   :='';
    I_Date  :=0;
    Duration:=NoneNum;
    P_Date :=0;
    Spot   :=NoneNum;
    Strike :=NoneNum;
    Vol :=NoneNum;
    IR :=NoneNum;
    CR_Premium :=NoneNum;
    B_IR :=NoneNum;;
    LRisk :=NoneNum;;
    IDateCurncy :=NoneNum;
    C_Month :=NoneNum;;
    Interest_Chk :=false;
    Interest :=NoneNum;;
    DateCurncy :=NoneNum;;
    IPrice :=NoneNum;;
    IAmount:=NoneNum;;
  end;
  for j:=0 to High(aRec.BaseFPut) do
    with aRec.BaseFPut[j] do
    begin
      FP_Date :=0;
      FV_Percent :=NoneNum;
      IR_Option  :=NoneNum;
    end;
  with aRec.BaseReset do
  begin
    B_Month   :=NoneNum;
    E_Month   :=NoneNum;
    C_DNum    :=NoneNum;
    L_DNum    :=NoneNum;
    C_Percent :=NoneNum;
    R_Percent :=NoneNum;
    P_Option  :=NoneNum;
    R_Period  :=NoneNum;
    Avg       :=false;
  end;
  for j:=0 to High(aRec.BaseReset2.CK_Days) do
    aRec.BaseReset2.CK_Days[j]:=NoneNum;
  for j:=0 to High(aRec.BaseReset2.Reset2) do
    with aRec.BaseReset2.Reset2[j] do
    begin
      ResetDate :=0;
      R_Percent :=NoneNum;
    end;
  for j:=0 to High(aRec.InterestLst) do
    with aRec.InterestLst[j] do
    begin
      SER :=NoneNum;
      Interest :=NoneNum;
    end;
  for j:=0 to High(aRec.PutLst) do
    with aRec.PutLst[j] do
    begin
      Avg :=false;
      B_Month :=NoneNum;
      E_Month :=NoneNum;
      C_Dnum  :=NoneNum;
      L_DNum  :=NoneNum;
      C_Percent :=NoneNum;
      V_Percent :=NoneNum;
      I_Option  :=NoneNum;
    end;
  for j:=0 to High(aRec.CallLst) do
    with aRec.CallLst[j] do
    begin
      Avg :=false;
      B_Month :=NoneNum;
      E_Month :=NoneNum;
      C_Dnum  :=NoneNum;
      L_DNum  :=NoneNum;
      C_Percent :=NoneNum;
      V_Percent :=NoneNum;
      A_Return :=NoneNum;
      I_Option :=NoneNum;
    end;
  for j:=0 to High(aRec.DivLst) do
    with aRec.DivLst[j] do
    begin
      DividendDate :=0;
      S_Rate  :=NoneNum;
      D_Rate  :=NoneNum;
      D_Price :=NoneNum;
      D_Money :=NoneNum;
    end;
end;

function RecOfTCBBaseRec2Text(rOne:TCBBaseRec):string;
  function FmtDt8(aInputDt:TDate):string;
  begin
    result:=FormatDateTime('yyyy/mm/dd',aInputDt);
  end;

  function BoolToStr(aInput:Boolean):string;
  begin
    if aInput then result:='ture'
    else result:='false';
  end;

var j:integer; sText:string;
begin
  result:='';
  sText:=rOne.CID+';'+rOne.BID+';'+rOne.BIDName+#13#10+
             'Reset_Option='+inttostr(rOne.BaseCfg.Reset_Option)+#13#10+
             'Reset_Check='+BoolToStr(rOne.BaseCfg.Reset_Check)+#13#10+
             'Call_Check='+BoolToStr(rOne.BaseCfg.Call_Check)+#13#10+
             'Put_Check='+BoolToStr(rOne.BaseCfg.Put_Check)+#13#10+
             'Dividend_Check='+BoolToStr(rOne.BaseCfg.Dividend_Check)+#13#10+
             'FPut_Check='+BoolToStr(rOne.BaseCfg.FPut_Check)+#13#10+

             'TradeCode='+(rOne.BaseDat.TradeCode)+#13#10+
             'TCExg='+(rOne.BaseDat.TCExg)+#13#10+
             'StkCode='+(rOne.BaseDat.StkCode)+#13#10+
             'SCExg='+(rOne.BaseDat.SCExg)+#13#10+
             'I_Date='+FmtDt8(rOne.BaseDat.I_Date)+#13#10+
             'P_Date='+FmtDt8(rOne.BaseDat.P_Date)+#13#10+
             'Scale='+FloatToStr(rOne.BaseDat.Scale)+#13#10+
             'Duration='+IntToStr(Trunc(rOne.BaseDat.Duration))+#13#10+
             'Spot='+FloatToStr(rOne.BaseDat.Spot)+#13#10+
             'Strike='+FloatToStr(rOne.BaseDat.Strike)+#13#10+
             'Vol='+FloatToStr(rOne.BaseDat.Vol)+#13#10+
             'IR='+FloatToStr(rOne.BaseDat.IR)+#13#10+
             'B_IR='+FloatToStr(rOne.BaseDat.B_IR)+#13#10+
             'CR_Premium='+FloatToStr(rOne.BaseDat.CR_Premium)+#13#10+
             'LRisk='+FloatToStr(rOne.BaseDat.LRisk)+#13#10+
             'IDateCurncy='+FloatToStr(rOne.BaseDat.IDateCurncy)+#13#10+
             'C_Month='+IntToStr(rOne.BaseDat.C_Month)+#13#10+
             'Interest_Chk='+BoolToStr(rOne.BaseDat.Interest_Chk)+#13#10+
             'Interest='+FloatToStr(rOne.BaseDat.Interest)+#13#10+
             'DateCurncy='+FloatToStr(rOne.BaseDat.DateCurncy)+#13#10+
             'IPrice='+FloatToStr(rOne.BaseDat.IPrice)+#13#10+
             'IAmount='+FloatToStr(rOne.BaseDat.IAmount)+#13#10;
       for j:=0 to High(rOne.InterestLst) do
       begin
         with rOne.InterestLst[j] do
         begin
           if SER>0 then
           begin
             sText:=sText+#13#10+'Interest='+IntToStr(SER)+','+FloatToStr(Interest);
           end;
         end;
       end;
       for j:=0 to High(rOne.DivLst) do
       begin
         with rOne.DivLst[j] do
         begin
           if DividendDate>0 then
           begin
             sText:=sText+#13#10+'DivLst='+FmtDt8(DividendDate)+','+FloatToStr(S_Rate)+','+FloatToStr(D_Rate)+','+FloatToStr(D_Price)+','+FloatToStr(D_Money);
           end;
         end;
       end; 
       for j:=0 to High(rOne.CallLst) do
       begin
         with rOne.CallLst[j] do
         begin
           if (B_Month>0) and (E_Month>0) then
           begin
             sText:=sText+#13#10+Format('CallLst Avg=%s,B_Month=%d,E_Month=%d,C_Dnum=%d,L_DNum=%d,C_Percent=%f,V_Percent=%f,A_Return=%f,I_Option=%d',[
                                      BoolToStr(Avg),B_Month,E_Month,C_Dnum,L_DNum,C_Percent,V_Percent,A_Return,I_Option]);
           end;
         end;
       end;
       for j:=0 to High(rOne.PutLst) do
       begin
         with rOne.PutLst[j] do
         begin
           if (B_Month>0) and (E_Month>0) then
           begin
             sText:=sText+#13#10+Format('PutLst Avg=%s,B_Month=%d,E_Month=%d,C_Dnum=%d,L_DNum=%d,C_Percent=%f,V_Percent=%f,I_Option=%d',[
                                      BoolToStr(Avg),B_Month,E_Month,C_Dnum,L_DNum,C_Percent,V_Percent,I_Option]);
           end;
         end;
       end;
       for j:=0 to High(rOne.BaseFPut) do
       begin
         with rOne.BaseFPut[j] do
         begin
           if (FP_Date>0) then
           begin
             sText:=sText+#13#10+Format('BaseFPut FP_Date=%s,FV_Percent=%f,IR_Option=%d',[
                                      FmtDt8(FP_Date),FV_Percent,IR_Option]);
           end;
         end;
       end;
       with rOne.BaseReset do
       begin
         if (B_Month>0) and (E_Month>0) then
         begin
           sText:=sText+#13#10+Format('BaseReset Avg=%s,B_Month=%d,E_Month=%d,C_Dnum=%d,L_DNum=%d,C_Percent=%f,R_Percent=%f,P_Option=%d,R_Period=%d',[
                                    BoolToStr(Avg),B_Month,E_Month,C_Dnum,L_DNum,C_Percent,R_Percent,P_Option,R_Period]);
         end;
       end;

       for j:=0 to High(rOne.BaseReset2.CK_Days) do
       begin
         with rOne.BaseReset2 do
         begin
           if (CK_Days[j]>0) then
           begin
             sText:=sText+#13#10+Format('CK_Days=%d',[
                                       CK_Days[j]]);
           end;
         end;
       end;
       for j:=0 to High(rOne.BaseReset2.Reset2) do
       begin
         with rOne.BaseReset2 do
         begin
           if (Reset2[j].ResetDate>0) then
           begin
             sText:=sText+#13#10+Format('Reset2 ResetDate=%s,R_Percent=%f',[
                                       FmtDt8(Reset2[j].ResetDate),Reset2[j].R_Percent]);
                   
           end;
         end;
       end;
       result:=sText;
end;

function SameRecOfTCBBaseRec(r1,r2:TCBBaseRec):boolean;
var sText1,sText2:string;
begin
  result:=false;
  if (r1.BID='') and (r2.BID='') then
  begin
    result:=true;
    exit;
  end;
  sText1:=RecOfTCBBaseRec2Text(r1);
  sText2:=RecOfTCBBaseRec2Text(r2);
  if sText1<>sText2 then
    exit;
  result:=True;
end;



//aFlag=0 (all trcode)
//aFlag=1 (only passway trcode)
//aFlag=2(except passway trcode)
function GetTradeCodeList(aPath:string;aFlag:integer;var ts:TStringList):Boolean;
var fDst: File  of TCBBaseRec; rDst:array of TCBBaseRec;
  c,b,ReMain,GotCount : Integer; sFile,sTemp:string; bNeedAdd:boolean;
begin
  result:=false;
  if not Assigned(ts) then
   exit;
  sFile:=aPath+'basebasic.dat';
  if FileExists(sFile) then
  begin
    AssignFile(fDst,sFile);
    try
      FileMode := 0;
      Reset(fDst);
      ReMain := FileSize(fDst);
      SetLength(rDst,ReMain);
      if ReMain>0 then
      begin
        for c:=0 to High(rDst) do
          InitRecOfTCBBaseRec(rDst[c]);
        BlockRead(fDst,rDst[0],ReMain,GotCount);
        for c:=0 to High(rDst) do
        begin
          sTemp:=rDst[c].CID;
          sTemp:=StringReplace(sTemp,'CBDB_ECB_','',[]);
          sTemp:=StringReplace(sTemp,'CBDB_','',[]);
          bNeedAdd:=false;
          if aFlag=1 then
          begin
            if SameText(sTemp,'TW_Stop') or SameText(sTemp,'passaway') then
              bNeedAdd:=true;
          end
          else if aFlag=2 then
          begin
            if not (SameText(sTemp,'TW_Stop') or SameText(sTemp,'passaway')) then
              bNeedAdd:=true;
          end
          else bNeedAdd:=true;

          if bNeedAdd then
          begin
            sTemp:=rDst[c].BID;
            sTemp:=StringReplace(sTemp,'CBDB_ECB_','',[]);
            sTemp:=StringReplace(sTemp,'CBDB_','',[]);
            if sTemp<>'' then
              ts.Add(sTemp);
            sTemp:=rDst[c].BaseDat.TradeCode;
            if sTemp<>'' then
              ts.Add(sTemp);
          end;
        end;
      end;
    finally
      CloseFile(fDst);
    end;
  end;
  result:=true;
end;

const
  _DftIPrice=100;
  _DftIAmount=100000;
  _DftIAmountCn=100;

Function  BoolToInt(nBool:Boolean):Integer;
Begin
     if nBool Then
        Result := 1
     Else
        Result := 0;
end;
function IsNoneOrEmpty(const Data:Double):Boolean;
Begin
   Result := (Data=NoneNum) or (Data=ValueEmpty);
end;

function GetTextOfACBClass(aTw:boolean;aPath,aCid:string):string;
var fDst: File  of TCBBaseRec; rDst:array of TCBBaseRec;
    f16: File  of TFClass; r16:array of TFClass;
  c,ic,j,ReMain,GotCount : Integer;  bNeedAdd:boolean;
  sFile,sTemp,sText,aSep:string;
  
  function GetClassMem(aInputId:string):string;
  var ix:integer;
  begin
    result:='';
    for ix:=0 to High(r16) do
    begin
      if SameText(r16[ix].CID,aInputId) or
         SameText(r16[ix].CID,'CBDB_ECB_'+aInputId) or
         SameText(r16[ix].CID,'CBDB_'+aInputId)   then
      begin
        result:=r16[ix].MEM;
        break;
      end;
    end;
  end;
  function DtToStr(aDt:TDate):shortstring;
  var Year, Month, Day: Word;
  begin
    Result :='';
    DecodeDate(aDt, Year, Month, Day);
    Result := Format('%d%s%d%s%d',[Year,aSep, Month,aSep, Day]);
  end;
  procedure tsAdd(aInput:string);
  begin
    if Result='' then result:=aInput
    else result:=result+#13#10+aInput;
  end;
begin
  result:='';
  if aCid='' then
    exit;
  tsAdd('[FILE]');
  tsAdd('VER=CB200304');
  tsAdd('[CLASS]');
  sTemp :=Format('CID=%s',[aCid]);
  tsAdd(sTemp);

try
  sFile:=aPath+'class.dat';
  if FileExists(sFile) then
  begin
    AssignFile(f16,sFile);
    try
      FileMode := 0;
      ReSet(f16);
      ReMain := FileSize(f16);
      SetLength(r16,ReMain);
      if ReMain>0 then
        BlockRead(f16,r16[0],ReMain,GotCount);
    finally
      CloseFile(f16);
    end;
  end;

  sTemp :=GetClassMem(aCid);
  tsAdd(Format('MEM=%s',[sTemp]));

  sFile:=aPath+'basebasic.dat';
  if FileExists(sFile) then
  begin
    AssignFile(fDst,sFile);
    try
      FileMode := 0;
      Reset(fDst);
      ReMain := FileSize(fDst);
      SetLength(rDst,ReMain);
      if ReMain>0 then
      begin
        for c:=0 to High(rDst) do
          InitRecOfTCBBaseRec(rDst[c]);
        BlockRead(fDst,rDst[0],ReMain,GotCount);

        ic:=-1;
        for c:=0 to High(rDst) do
        begin
          sTemp:=rDst[c].CID;
          sTemp:=StringReplace(sTemp,'CBDB_','',[]);

          bNeedAdd:=SameText(sTemp,aCid);
          if bNeedAdd then
          begin
            Inc(ic);

            if (rDst[c].BaseDat.SCExg='03') or(rDst[c].BaseDat.SCExg='3') then
              aSep := '/'
            else
              aSep := '-';
            tsAdd(Format('[BASE%d]',[ic]));
            sTemp:=rDst[c].BID;
            sTemp:=StringReplace(sTemp,'CBDB_ECB_','',[]);
            sTemp:=StringReplace(sTemp,'CBDB_','',[]);
            sTemp :=Format('BID=%s',[sTemp]);
            tsAdd(sTemp);
            tsAdd(Format('MEM=%s',[rDst[c].BIDName]));
            tsAdd(Format('Reset_Option=%d',[rDst[c].BaseCfg.Reset_Option]));
            tsAdd(Format('Reset_Check=%d',[BoolToInt(rDst[c].BaseCfg.Reset_Check ) ]));
            tsAdd(Format('Call_Check=%d',[BoolToInt(rDst[c].BaseCfg.Call_Check ) ]));
            tsAdd(Format('Put_Check=%d',[BoolToInt(rDst[c].BaseCfg.Put_Check ) ]));
            tsAdd(Format('Dividend_Check=%d',[BoolToInt(rDst[c].BaseCfg.Dividend_Check ) ]));
            tsAdd(Format('FPut_Check=%d',[BoolToInt(rDst[c].BaseCfg.FPut_Check ) ]));
            tsAdd('P_NUM=0');
            tsAdd('S_NUM=0');
            tsAdd('C_Vega=0');
            tsAdd('C_Rho=0');
            tsAdd('CB_Price=-999999999');
            tsAdd('CB_Cost=-999999999');
            tsAdd('CV_Ratio=-999999999');
            tsAdd('CV_Premium=-999999999');
            tsAdd('CV_Value=-999999999');
            tsAdd('B_Value=-999999999');
            tsAdd('O_Value=-999999999');
            tsAdd('C_Value=-999999999');
            tsAdd('P_Value=-999999999');
            tsAdd('R_Value=-999999999');
            tsAdd('Delta=-999999999');
            tsAdd('Gamma=-999999999');
            tsAdd('Vega=-999999999');
            tsAdd('Rho=-999999999');
            tsAdd('Theta=-999999999');

            tsAdd(Format('Scale=%s',[FloatToStr(rDst[c].BaseDat.Scale) ]));
            tsAdd(Format('TradeCode=%s',[rDst[c].BaseDat.TradeCode]));
            tsAdd(Format('TCExg=%s',[rDst[c].BaseDat.TCExg]));
            tsAdd(Format('StkCode=%s',[rDst[c].BaseDat.StkCode]));
            tsAdd(Format('SCExg=%s',[rDst[c].BaseDat.SCExg]));
            tsAdd(Format('I_Date=%s',[Floattostr(rDst[c].BaseDat.I_Date) ]));
            tsAdd(Format('Duration=%d',[Trunc(rDst[c].BaseDat.Duration)]));

            tsAdd(Format('P_Date=%s',[Floattostr(rDst[c].BaseDat.I_Date) ]));
            tsAdd('Spot=-999999999');
            tsAdd('Strike=-999999999');
            tsAdd('Vol=-999999999');
            tsAdd('IR=-999999999');
            tsAdd('CR_Premium=-999999999');
            tsAdd('B_IR=-999999999'); //20140822否決    20140911chongxinok

            if IsNoneOrEmpty(rDst[c].BaseDat.IPrice) then
              tsAdd(Format('IPrice=%f',[_DftIPrice]))
            else
              tsAdd(Format('IPrice=%f',[rDst[c].BaseDat.IPrice]));
            if IsNoneOrEmpty(rDst[c].BaseDat.IAmount) then
            begin
              if not aTw then
                tsAdd(Format('IAmount=%f',[_DftIAmountCn]))
              else
                tsAdd(Format('IAmount=%f',[_DftIAmount]));
            end else
              tsAdd(Format('IAmount=%f',[rDst[c].BaseDat.IAmount]));
            if IsNoneOrEmpty(rDst[c].BaseDat.DateCurncy) or (rDst[c].BaseDat.DateCurncy=-1) then
            begin
              if not aTw then
                tsAdd(Format('DateCurncy=%s',['2']))
              else
                tsAdd(Format('DateCurncy=%s',['0']));
            end else
              tsAdd(Format('DateCurncy=%f',[rDst[c].BaseDat.DateCurncy]));
            tsAdd(Format('TraderCodeEcb=%s',[rDst[c].BaseDat.TradeCode]));
            tsAdd(Format('C_Month=%d',[rDst[c].BaseDat.C_Month]));
            tsAdd(Format('Interest_Chk=%d',[booltoint(rDst[c].BaseDat.Interest_Chk)  ]));
            tsAdd(Format('Interest=%s',[FloatToStr(rDst[c].BaseDat.Interest) ]));

            tsAdd(Format('B_Month=%d',[rDst[c].BaseReset.B_Month]));
            tsAdd(Format('E_Month=%d',[rDst[c].BaseReset.E_Month]));
            tsAdd(Format('C_DNum=%d',[rDst[c].BaseReset.C_DNum]));
            tsAdd(Format('L_DNum=%d',[rDst[c].BaseReset.L_DNum]));
            tsAdd(Format('C_Percent=%s',[FloatToStr(rDst[c].BaseReset.C_Percent) ]));
            tsAdd(Format('R_Percent=%s',[FloatToStr(rDst[c].BaseReset.R_Percent) ]));
            tsAdd(Format('P_Option=%d',[rDst[c].BaseReset.P_Option ]));
            tsAdd(Format('R_Period=%d',[rDst[c].BaseReset.R_Period ]));
            tsAdd(Format('Avg=%d',[booltoint(rDst[c].BaseReset.Avg) ]));

            GotCount:=-1;
            for j:=0 to High(rDst[c].InterestLst) do
            if (rDst[c].InterestLst[j].SER>0) then
            begin
              Inc(GotCount);
              tsAdd(Format('Base_Interest%d=%d,%s',
                [GotCount,rDst[c].InterestLst[j].SER,FloatToStr(rDst[c].InterestLst[j].Interest) ]));
            end;

            GotCount:=-1;
            for j:=0 to High(rDst[c].BaseReset2.CK_Days) do
            if (rDst[c].BaseReset2.CK_Days[j]>0) then
            begin
              Inc(GotCount);
              tsAdd(Format('Reset_CkDays%d=%d',[GotCount,rDst[c].BaseReset2.CK_Days[j] ]));
            end;
            
            GotCount:=-1;
            for j:=0 to High(rDst[c].BaseReset2.Reset2) do
            with rDst[c].BaseReset2.Reset2[j] do
            begin
              if (ResetDate>0) and (R_Percent>0) then
              begin
                Inc(GotCount);
                tsAdd(Format('Base_Reset2%d=%s,%s',[GotCount,DtToStr(ResetDate),FloatToStr(R_Percent) ]));
              end;
            end;

            GotCount:=-1;
            for j:=0 to High(rDst[c].BaseFPut) do
            with rDst[c].BaseFPut[j] do
            begin
              if (FP_Date>0) then
              begin
                Inc(GotCount);
                tsAdd(Format('Base_FPut%d=%s,%s,%d',[GotCount,DtToStr(FP_Date),FloatToStr(FV_Percent),IR_Option ]));
              end;
            end;

            GotCount:=-1;
            for j:=0 to High(rDst[c].PutLst) do
            with rDst[c].PutLst[j] do
            begin
              if (B_Month>0) and (E_Month>0) then
              begin
                Inc(GotCount);
                tsAdd(Format('Base_Put%d=%d,%d,%d,%d,%d,%s,%s,%d',
                  [GotCount,booltoint(Avg),B_Month,E_Month,C_Dnum,L_DNum,FloatToStr(C_Percent),FloatToStr(V_Percent),I_Option ]));
              end;
            end;
        
            GotCount:=-1;
            for j:=0 to High(rDst[c].CallLst) do
            with rDst[c].CallLst[j] do
            begin
              if (B_Month>0) and (E_Month>0) then
              begin
                Inc(GotCount);
                tsAdd(Format('Base_Call%d=%d,%d,%d,%d,%d,%s,%s,%d,%s',
                  [GotCount,booltoint(Avg),B_Month,E_Month,C_Dnum,L_DNum,FloatToStr(C_Percent),FloatToStr(V_Percent),I_Option,FloatToStr(A_Return) ]));
              end;
            end;

          end;
        end;
      end;
    finally
      CloseFile(fDst);
    end;
  end;
finally
  SetLength(r16,0);
  SetLength(rDst,0);
end;
end;

end.
