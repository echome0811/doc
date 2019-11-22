unit uForCBOpCom;

interface
  uses Windows,Classes,ComObj,Controls,SysUtils,TCommon;
const
  NoneNum   = -999999999;
  _DftIPrice=100;
  _DftIAmount=100000;
  _ClassFile = 'class.dat';
  _BaseFile  = 'base.dat';
  _BaseCallFile   = 'basecal2.dat';
  _BasePutFile    = 'baseput.dat';
  _BaseDivFile    = 'basediv.dat';
  _BaseInterestFile = 'baseint.dat';
  _BaseDatFile    = 'basedat.dat';
  _BaseLRiskFile    = 'baselrisk.dat'; //瑈笆┦繧
  _BaseIPriceFile    = 'baseiprice.dat'; //祇︽基
  _BaseECBDatsFile    = 'baseecbdats.dat';
  _BaseIDateCurncyFile    = 'baseirate.dat'; //祇︽蹲瞯
  _BaseCfgFile    = 'basecfg.dat';
  _BasePriceFile  = 'basePic.dat';
  _BaseResetFile  = 'baseret.dat';
  _BaseReset2File  = 'baseret2.dat';
  _BaseResetAvgDayFile  = 'baseretavgday.dat';
  _BaseFPutFile   = 'basefpt2.dat';
type
  TFClass = Packed Record
     CID : String[38];
     MEM : String[38];
   End;
   TCBClass =Packed Record
     CID : String[38];
     MEM : String[38];
     HaveUpdate : Boolean;
     BaseLst   : TList; //TCBBaseP
     ChartLst  : TList; //TCBChartP
     //RptLst    : TList; //TCBRptP
  End;
  TCBClassP = ^TCBClass;
   TFBase = Packed Record
     CID : String[38];
     BID : String[38];
     MEM : String[38];
   End;


TCBBasePrice=Packed Record
  //评价参数
   P_NUM  : Integer;
   S_NUM  : Integer;
   C_Vega : Double;
   C_Rho  : Double;

   CB_Price  :Double;
   CB_Cost   :Double;

   CV_Ratio  :Double;
   CV_Premium:Double;
   CV_Value  :Double;

   B_Value   :Double;
   O_Value   :Double;
   C_Value   :Double;
   P_Value   :Double;
   R_Value   :Double;

   Delta     :Double;
   Gamma     :Double;
   Vega      :Double;
   Rho       :Double;
   Theta     :Double;

   B_M_Value :Double;  //到期债券价值
   O_M_Value :Double;  //到期认股权价值
   CP_Value  :Double;  //赎售回权价值
   CPR_Value :Double;  //赎售修正权价值
End;
TCBBaseCfg=Packed Record
  //rs6224 Upadte 311
   Reset_Option: Byte;
   Reset_Check : Boolean;
   Call_Check  : Boolean;
   Put_Check   : Boolean;
   Dividend_Check : Boolean;
   FPut_Check : Boolean;
End;
 
TCBBaseDat=Packed Record
   Scale : Double;
   TradeCode : string[10];
   TCExg   : string[2];
   StkCode : string[6];
   SCExg : string[2];

   I_Date : TDate;
   Duration : Integer;
   P_Date : TDate;
   Spot   : Double;
   Strike : Double;
   Vol : Double;
   IR : Double;
   CR_Premium : Double;
   B_IR : Double;
   LRisk : Double; //流動性風險
   IDateCurncy : Double; //發行匯率
   IPrice : Double; //發行价格
   IAmount: Double; //發行面额
   C_Month   : Integer;

   Interest_Chk : Boolean;
   Interest : Double;

   TraderCodeEcb : string[38];
   DateCurncy : Double;
   StrikeNTD : Double;
   StrikeCurncy : Double;
   StrikeCurncyStyle : byte;//0=dft 1=fix 2=bydate
End;
TCBBaseReset=Packed Record
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
TCBBaseReset2Data =Packed Record
  CK_Days:Array of Integer;
  Reset2 :TList;
end;
TCBInterest = Packed Record
   SER : Integer;
   Interest : Double;
End;
TCBInterestLST = Array of TCBInterest;
//评价结果**********************************************************************
TCBOut = Record
  CB_Price  :Double;  //理论价格
  CB_Cost   :Double;  //对应股票成本

  CV_Ratio  :Double;  //转股比例
  CV_Premium:Double;  //转换溢价
  CV_Value  :Double;  //转换价值

  B_Value   :Double;  //债券价值
  O_Value   :Double;  //认股权价值
  C_Value   :Double;  //赎回权价值
  P_Value   :Double;  //回售权价值
  R_Value   :Double;  //重设权价值

  Delta     :Double;  //Delta
  Gamma     :Double;  //Gamma
  Vega      :Double;  //Vega
  Rho       :Double;  //Rho
  Theta     :Double;  //Theta

  B_M_Value :Double;  //到期债券价值
  O_M_Value :Double;  //到期认股权价值
  CP_Value  :Double;  //赎售回权价值
  CPR_Value :Double;  //赎售修正权价值
End;
TACBOut= Packed Record
   P_Date    : TDate;
   OutData   : TCBOut;
   VolValue  : Double;
   VolValue2  : Double;
   VolValue3  : Double;
   VolValue4  : Double;
End;
TConfig = Record
  P_Num :Integer; //分割期数(期)(例：300 (预设为365  ，可设定))
  S_Num :Integer; //仿真次数(次)(例：1000(预设为100  ，可设定))
  C_Vega:Double;  //Vega(%)     (例：0.01(预设为0.1% ，可设定))
  C_Rho :Double;  //Rho(%)      (例：0.01(预设为0.01%，可设定))
  //add by wjh 20120207 5.0.8.1
  SelDtType:Integer;//获取转股价格的方式(0--依据调整转换日获取  1--依据除权除息日获取)
  //--
End;
TACBData=Packed Record
    RL_IR     :Double;
    CR_Prem   :Double;
    B_IR      :Double;
    ConfigData    : TConfig;
End;
TACBHistoryOut=Packed Record
    AData         : TACBData;
    OutPDateLst   :  Array of TACBOut;
End;
TCBBase = Packed Record
   BID : String[38];
   MEM : String[38];
   AddNew    : Boolean;
   BaseCfg   : TCBBaseCfg;
   BasePrice : TCBBasePrice;
   BaseDat   : TCBBaseDat;

   BaseFPut  : TList; //TCBBaseFPutP

   //rs6224 Update 311
   BaseReset  : TCBBaseReset;
   BaseReset2 : TCBBaseReset2Data;


   InterestLst : TCBInterestLST;

   PutLst    : TList;    //TCBPutP
   DividendLst  : TList; //TCBDividendP
   CallLst      : TList; //TCBCallP
   ChartLst     : TList; //TCBChartP



   CBDocCount  : Integer;
   StkDocCount : Integer;
   ShenBaoDocCount : Integer;
   IsXiaShi:Byte;

   ChartOutDataKey : Integer;
   ChartOutDataOut : Integer;
   ChartOutData    : TACBHistoryOut;
   //HistoryVol   : Array of TACBHistoryVol;

End;
TCBBaseP  = ^TCBBase;

   TFBaseCfg = Packed Record
     BID : String[38];
     Reset_Check : Boolean;
     //rs6224 Upadte 311
     Reset_Option: Byte;
     Call_Check  : Boolean;
     Put_Check   : Boolean;
     Dividend_Check : Boolean;
     FPut_Check : Boolean;
   End;
   TFBasePrice = Packed Record
     BID : String[38];
     //评价参数
     P_NUM  : Integer;
     S_NUM  : Integer;
     C_Vega : Double;
     C_Rho  : Double;

     CB_Price  :Double;
     CB_Cost   :Double;

     CV_Ratio  :Double;
     CV_Premium:Double;
     CV_Value  :Double;

     B_Value   :Double;
     O_Value   :Double;
     C_Value   :Double;
     P_Value   :Double;
     R_Value   :Double;

     Delta     :Double;
     Gamma     :Double;
     Vega      :Double;
     Rho       :Double;
     Theta     :Double;
   End;
   TFBaseCall = Packed Record
     BID : String[38];
     Avg     : Boolean;
     B_Month : Integer;
     E_Month : Integer;
     C_Dnum  : Integer;
     L_DNum  : Integer;
     C_Percent : Double;
     V_Percent : Double;
     //rs6224 Update 311
     A_Return  : Double;
     I_Option  : Integer;
   End;
   TFBaseDiv = Packed Record
     BID : String[38];
     DividendDate : TDate;
     S_Rate  : Double;
     D_Rate  : Double;
     D_Price : Double;
     D_Money : Double;
   End;
   TCBCall = Packed Record
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
TCBCallP = ^TCBCall;
TFBasePut = Packed Record
     BID : String[38];
     Avg     : Boolean;
     B_Month : Integer;
     E_Month : Integer;
     C_Dnum  : Integer;
     L_DNum  : Integer;
     C_Percent : Double;
     V_Percent : Double;
     I_Option  : Integer;
   End;
TCBPut = Packed Record
   Avg : Boolean;
   B_Month : Integer;
   E_Month : Integer;
   C_Dnum  : Integer;
   L_DNum  : Integer;
   C_Percent : Double;
   V_Percent : Double;
   I_Option  : Integer;
End;
TCBPutP = ^TCBPut;
TCBDividend = Packed Record
   DividendDate : TDate;
   S_Rate  : Double;
   D_Rate  : Double;
   D_Price : Double;
   D_Money : Double;
End;
TCBDividendP = ^TCBDividend;
  TFBaseInt = Packed Record
     BID : String[38];
     SER : Integer;
     Interest : Double;
   End;
   TFBaseDat = Packed Record
     BID : String[38];
     Scale : Double;
     TradeCode : string[10];
     TCExg   : string[2];
     StkCode : string[6];
     SCExg : string[2];

     I_Date : TDate;
     Duration : Integer;
     P_Date : TDate;
     Spot   : Double;
     Strike : Double;
     Vol : Double;
     IR : Double;
     CR_Premium : Double;
     B_IR : Double;
     C_Month   : Integer;
     Interest_Chk : Boolean;
     Interest : Double;
   End;
   TFBaseLRisk = Packed Record
     BID : String[38];
     LRisk : Double;
   End;
   TFBaseIPrice = Packed Record
     BID : String[38];
     IPrice : Double;
     IAmount : Double;
   End;
   TFBaseECBDats = Packed Record
     BID : String[38];
     TraderCodeEcb : string[38];
     DateCurncy : Double;
     StrikeNTD : Double;
     StrikeCurncy : Double;
     StrikeCurncyStyle : byte;//0=dft 1=fix 2=bydate
   End;
   TFBaseIDateCurncy = Packed Record
     BID : String[38];
     IDateCurncy : Double;
   End;
   TFBaseReset = Packed Record
     BID : String[38];
     B_Month   : Integer;
     E_Month   : Integer;
     C_DNum    : Integer;
     L_DNum    : Integer;
     C_Percent : Double;
     R_Percent : Double;
     P_Option  : Integer;
     R_Period  : Integer;
     Avg : Boolean;
   End;

   //rs6224 Update 311
   TFBaseReset2 = Packed Record
     BID : String[38];
     ResetDate:TDate;
     R_Percent:Double;
   End;
   TFBaseResetAvgDay = Packed Record
     BID : String[38];
     CK_Days : Integer;
   End;
TCBBaseReset2=Packed Record
  ResetDate:TDate;
  R_Percent:Double;
End;
TCBBaseReset2P = ^TCBBaseReset2;
  TFBaseFPut = Packed Record
     BID : String[38];
     //rs6224 update 311
     FP_Date : TDate;
     FV_Percent : Double;
     IR_Option  : Integer;
   End;
TCBBaseFPut=Packed Record
   //rs6224 Update 311
   //P_DNum : Integer;
   FP_Date : TDate;
   FV_Percent : Double;
   IR_Option  : Integer;
End;
TCBBaseFPutP = ^TCBBaseFPut;
TCBChartXY = Packed Record
   X : Double;
   Y : Double;
   Z : Double;
End;
TCBChartXYP = ^TCBChartXY;

TCBChartY = Packed Record
   YName : Integer;
   ChartXY   : Array of TCBChartXY;
End;
TCBChartYLst = Array of TCBChartY;

TCBChartBY = Packed Record
   BID    : String[38];
   ChartY : TCBChartYLst;
End;

TCBChart = Packed Record
   BeLoad : Boolean;
   GID : String[38];
   ChartBelong : Integer; //1 Class 2 Company  3 Rpt 4 Pic
   ChartNeedRefresh : Boolean;
   DNAme  : String[60];
   XName1   : Integer;
   XName2   : Integer;
   Interval : Integer;
   ChartOption : Integer; //1=合并画图 2=分散画图
   MDate : TDate;
   //条件
   AXRange1 : Double;
   AXRange2 : Double;
   BXRange1 : Double;
   BXRange2 : Double;
   ChartBYLst  : Array of TCBChartBY;
End;
TCBChartP = ^TCBChart;

Function  InPutCBFromFile0304_5(InputFile:ShortString;
  Var MyCLassLst:TList;DefIR,DefCRPremium,DefBIR,DefLRisk:Double;
  Var Err:Integer;Proc:TFarProc=nil):Boolean;
Function SaveFClassAllDat(aPath:ShortString;ClassLst:TList):Boolean;
Procedure FreeCBClass(ClassLst:TList);

implementation


Function SaveFClassAllDat(aPath:ShortString;ClassLst:TList):Boolean;
Var
  fFClass: File  of TFClass;
  rFClass: TFClass;
  aClass : TCBClassP;
  fFBase: File  of TFBase;
  rFBase: TFBase;
  aBase : TCBBaseP;
  fFBaseCall: File  of TFBaseCall;
  rFBaseCall: TFBaseCall;
  aCall : TCBCallP;
  fFBasePut: File  of TFBasePut;
  rFBasePut: TFBasePut;
  aPut : TCBPutP;
  fFBaseDiv: File  of TFBaseDiv;
  rFBaseDiv: TFBaseDiv;
  aDiv : TCBDividendP;
  fFBaseInt: File  of TFBaseInt;
  rFBaseInt: TFBaseInt;
  fFBaseDat: File  of TFBaseDat;
  rFBaseDat: TFBaseDat;
  fFBaseLRisk: File  of TFBaseLRisk;
  rFBaseLRisk: TFBaseLRisk;
  fFBaseIPrice: File  of TFBaseIPrice;
  rFBaseIPrice: TFBaseIPrice;
  fFBaseECBDats: File  of TFBaseECBDats;
  rFBaseECBDats: TFBaseECBDats;
  fFBaseIDateCurncy: File  of TFBaseIDateCurncy;
  rFBaseIDateCurncy: TFBaseIDateCurncy;
  fFBaseCfg: File  of TFBaseCfg;
  rFBaseCfg: TFBaseCfg;

  f1: File  of TFBaseReset;
  f2: File  of TFBaseReset2;
  f3: File  of TFBaseResetAvgDay;
  r1: TFBaseReset;
  r2: TFBaseReset2;
  r3: TFBaseResetAvgDay;
  aBaseReset2 : TCBBaseReset2P;

  fFBaseFPut: File  of TFBaseFPut;
  rFBaseFPut: TFBaseFPut;
  aFPut : TCBBaseFPutP;
  fFBasePrice: File  of TFBasePrice;
  rFBasePrice: TFBasePrice;
  
  i,j,k,k2,k3,k4,k5 : Integer;
  b:boolean;
Begin
Try
    Result := False;
try
    AssignFile(fFClass,aPath+_ClassFile);
    AssignFile(fFBase,aPath+_BaseFile);
    AssignFile(fFBaseCall,aPath+_BaseCallFile);
    AssignFile(fFBasePut,aPath+_BasePutFile);
    AssignFile(fFBaseDiv,aPath+_BaseDivFile);
    AssignFile(fFBaseInt,aPath+_BaseInterestFile);
    AssignFile(fFBaseDat,aPath+_BaseDatFile);
    AssignFile(fFBaseLRisk,aPath+_BaseLRiskFile);
    AssignFile(fFBaseIPrice,aPath+_BaseIPriceFile);
    AssignFile(fFBaseECBDats,aPath+_BaseECBDatsFile);
    AssignFile(fFBaseIDateCurncy,aPath+_BaseIDateCurncyFile);
    AssignFile(fFBaseCfg,aPath+_BaseCfgFile);
    AssignFile(f1,aPath+_BaseResetFile);
    AssignFile(f2,aPath+_BaseReset2File);
    AssignFile(f3,aPath+_BaseResetAvgDayFile);
    AssignFile(fFBaseFPut,aPath+_BaseFPutFile);
    AssignFile(fFBasePrice,aPath+_BasePriceFile);
    FileMode := 1;
    ReWrite(fFClass);
    ReWrite(fFBase);
    ReWrite(fFBaseCall);
    ReWrite(fFBasePut);
    ReWrite(fFBaseDiv);
    ReWrite(fFBaseInt);
    ReWrite(fFBaseDat);
    ReWrite(fFBaseLRisk);
    ReWrite(fFBaseIPrice);
    ReWrite(fFBaseECBDats);
    ReWrite(fFBaseIDateCurncy);
    ReWrite(fFBaseCfg);
    ReWrite(f1);
    ReWrite(f2);
    ReWrite(f3);
    ReWrite(fFBaseFPut);
    ReWrite(fFBasePrice);
    For  i :=0 to ClassLst.Count-1 do
    Begin
        aClass := ClassLst.Items[i];
        rFClass.CID  := aClass.CID;
        rFClass.MEM  := aClass.MEM;
        Write(fFClass,rFClass);

        For  j :=0 to aClass.BaseLst.Count-1 do
        Begin
           aBase := aClass.BaseLst.Items[j];
           rFBase.CID  := aClass.CID;
           rFBase.BID  := aBase.BID;
           rFBase.MEM  := aBase.MEM;
           Write(fFBase,rFBase);

           For  k :=0 to aBase.CallLst.Count-1 do
           Begin
              aCall := aBase.CallLst.Items[k];
              rFBaseCall.BID := aBase.BID;
              rFBaseCall.B_Month := aCall.B_Month;
              rFBaseCall.E_Month := aCall.E_Month;
              rFBaseCall.C_Dnum  := aCall.C_DNum;
              rFBaseCall.L_DNum  := aCall.L_DNum;
              rFBaseCall.C_Percent := aCall.C_Percent;
              rFBaseCall.V_Percent := aCall.V_Percent;
              //rs6224 Update 311
              rFBaseCall.A_Return  := aCall.A_Return;
              rFBaseCall.I_Option  := aCall.I_Option;
              rFBaseCall.Avg       := aCall.Avg;
              Write(fFBaseCall,rFBaseCall);
           End;
           For  k :=0 to aBase.PutLst.Count-1 do
           Begin
              aPut := aBase.PutLst.Items[k];
              rFBasePut.BID := aBase.BID;
              rFBasePut.B_Month := aPut.B_Month;
              rFBasePut.E_Month := aPut.E_Month;
              rFBasePut.C_Dnum  := aPut.C_DNum;
              rFBasePut.L_DNum  := aPut.L_DNum;
              rFBasePut.C_Percent := aPut.C_Percent;
              rFBasePut.V_Percent := aPut.V_Percent;
              rFBasePut.I_Option  := aPut.I_Option;
              rFBasePut.Avg       := aPut.Avg;
              Write(fFBasePut,rFBasePut);
           End;
           For  k:=0 to aBase.DividendLst.Count-1 do
           Begin
              aDiv := aBase.DividendLst.Items[k];
              rFBaseDiv.BID := aBase.BID;
              rFBaseDiv.DividendDate := aDiv.DividendDate;
              rFBaseDiv.S_Rate   := aDiv.S_Rate;
              rFBaseDiv.D_Rate   := aDiv.D_Rate;
              rFBaseDiv.D_Price  := aDiv.D_Price;
              rFBaseDiv.D_Money  := aDiv.D_Money;
              Write(fFBaseDiv,rFBaseDiv);
           End;
           For  k :=0 to High(aBase.InterestLst) do
           Begin
              rFBaseInt.BID := aBase.BID;
              rFBaseInt.SER := aBase.InterestLst[k].SER;
              rFBaseInt.Interest := aBase.InterestLst[k].Interest;
              Write(fFBaseInt,rFBaseInt);
           End;

            rFBaseDat.BID        := aBase.BID;
            rFBaseDat.Scale      := aBase.BaseDat.Scale;
            rFBaseDat.TradeCode  := aBase.BaseDat.TradeCode;
            rFBaseDat.TCExg      := aBase.BaseDat.TCExg;
            rFBaseDat.StkCode    := aBase.BaseDat.StkCode;
            rFBaseDat.SCExg      := aBase.BaseDat.SCExg;

            rFBaseDat.I_Date     := aBase.BaseDat.I_Date;
            rFBaseDat.Duration   := aBase.BaseDat.Duration;
            rFBaseDat.P_Date     := aBase.BaseDat.P_Date;
            rFBaseDat.Spot       := aBase.BaseDat.Spot;
            rFBaseDat.Strike     := aBase.BaseDat.Strike;
            rFBaseDat.Vol        := aBase.BaseDat.Vol;
            rFBaseDat.IR         := aBase.BaseDat.IR;

            rFBaseDat.IR         := aBase.BaseDat.IR;

            rFBaseDat.CR_Premium := aBase.BaseDat.B_IR - aBase.BaseDat.IR;//aBase.BaseDat.CR_Premium;
            if rFBaseDat.CR_Premium<0 then  rFBaseDat.CR_Premium := 0;
            rFBaseDat.B_IR       := aBase.BaseDat.B_IR;
            rFBaseDat.C_Month    := aBase.BaseDat.C_Month;
            rFBaseDat.Interest_Chk := aBase.BaseDat.Interest_Chk;
            rFBaseDat.Interest    := aBase.BaseDat.Interest;
            Write(fFBaseDat,rFBaseDat);

            rFBaseLRisk.BID        := aBase.BID;
            rFBaseLRisk.LRisk      := aBase.BaseDat.LRisk;
            Write(fFBaseLRisk,rFBaseLRisk);

            rFBaseIPrice.BID        := aBase.BID;
            rFBaseIPrice.IPrice      := aBase.BaseDat.IPrice;
            rFBaseIPrice.IAmount      := aBase.BaseDat.IAmount;
            Write(fFBaseIPrice,rFBaseIPrice);

            rFBaseECBDats.BID        := aBase.BID;
            rFBaseECBDats.TraderCodeEcb := aBase.BaseDat.TraderCodeEcb;
            rFBaseECBDats.DateCurncy      := aBase.BaseDat.DateCurncy;
            rFBaseECBDats.StrikeNTD      := aBase.BaseDat.StrikeNTD;
            rFBaseECBDats.StrikeCurncy      := aBase.BaseDat.StrikeCurncy;
            rFBaseECBDats.StrikeCurncyStyle      := aBase.BaseDat.StrikeCurncyStyle;
            Write(fFBaseECBDats,rFBaseECBDats);

            rFBaseIDateCurncy.BID        := aBase.BID;
            rFBaseIDateCurncy.IDateCurncy      := aBase.BaseDat.IDateCurncy;
            Write(fFBaseIDateCurncy,rFBaseIDateCurncy);

            rFBaseCfg.BID       := aBase.BID;
            rFBaseCfg.Reset_Check := aBase.BaseCfg.Reset_Check;
            rFBaseCfg.Call_Check  := aBase.BaseCfg.Call_Check;
            rFBaseCfg.Put_Check   := aBase.BaseCfg.Put_Check;
            rFBaseCfg.Dividend_Check := aBase.BaseCfg.Dividend_Check;
            rFBaseCfg.FPut_Check  := aBase.BaseCfg.FPut_Check;
            rFBaseCfg.Reset_Option := aBase.BaseCfg.Reset_Option;
            Write(fFBaseCfg,rFBaseCfg);

            r1.BID       := aBase.BID;
            r1.B_Month   := aBase.BaseReset.B_Month;
            r1.E_Month   := aBase.BaseReset.E_Month;
            r1.C_DNum    := aBase.BaseReset.C_DNum;
            r1.L_DNum    := aBase.BaseReset.L_DNum;
            r1.C_Percent := aBase.BaseReset.C_Percent;
            r1.R_Percent := aBase.BaseReset.R_Percent;
            r1.P_Option  := aBase.BaseReset.P_Option;
            r1.R_Period  := aBase.BaseReset.R_Period;
            r1.Avg       := aBase.BaseReset.Avg;
            Write(f1,r1);
            r2.BID       := aBase.BID;
            For k := 0 to  aBase.BaseReset2.Reset2.Count-1 do
            Begin
               aBaseReset2  := aBase.BaseReset2.Reset2.Items[k];
               r2.ResetDate := aBaseReset2.ResetDate;
               r2.R_Percent := aBaseReset2.R_Percent;
               Write(f2,r2);
            End;
            r3.BID       := aBase.BID;
            for k:=0 to High(aBase.BaseReset2.CK_Days) do
            Begin
               r3.CK_Days := aBase.BaseReset2.CK_Days[k];
               Write(f3,r3);
            End;

            rFBaseFPut.BID := aBase.BID;
            For k:=0 to  aBase.BaseFPut.Count-1 do
            Begin
               aFPut := aBase.BaseFPut.Items[k];
               rFBaseFPut.FP_Date := aFPut.FP_Date;
               rFBaseFPut.FV_Percent := aFPut.FV_Percent;
               rFBaseFPut.IR_Option  := aFPut.IR_Option;
               Write(fFBaseFPut,rFBaseFPut);
            End;

            rFBasePrice.BID     := aBase.BID;
            rFBasePrice.P_NUM   := aBase.BasePrice.P_NUM;
            rFBasePrice.S_NUM   := aBase.BasePrice.S_NUM;
            rFBasePrice.C_Vega  := aBase.BasePrice.C_Vega;
            rFBasePrice.C_Rho   := aBase.BasePrice.C_Rho;

            rFBasePrice.CB_Price  := aBase.BasePrice.CB_Price;
            rFBasePrice.CB_Cost   := aBase.BasePrice.CB_Cost;

            rFBasePrice.CV_Ratio  := aBase.BasePrice.CV_Ratio;
            rFBasePrice.CV_Premium:= aBase.BasePrice.CV_Premium;
            rFBasePrice.CV_Value  := aBase.BasePrice.CV_Value;

            rFBasePrice.B_Value   := aBase.BasePrice.B_Value;
            rFBasePrice.O_Value   := aBase.BasePrice.O_Value;
            rFBasePrice.C_Value   := aBase.BasePrice.C_Value;
            rFBasePrice.P_Value   := aBase.BasePrice.P_Value;
            rFBasePrice.R_Value   := aBase.BasePrice.R_Value;

            rFBasePrice.Delta     := aBase.BasePrice.Delta;
            rFBasePrice.Gamma     := aBase.BasePrice.Gamma;
            rFBasePrice.Vega      := aBase.BasePrice.Vega;
            rFBasePrice.Rho       := aBase.BasePrice.Rho;
            rFBasePrice.Theta     := aBase.BasePrice.Theta;
            Write(fFBasePrice,rFBasePrice);
        end;
    End;
    result :=true;
finally
  try CloseFile(fFClass);except end;
  try CloseFile(fFBase);except end;
  try CloseFile(fFBaseCall);except end;
  try CloseFile(fFBasePut);except end;
  try CloseFile(fFBaseDiv);except end;
  try CloseFile(fFBaseInt);except end;
  try CloseFile(fFBaseDat);except end;
  try CloseFile(fFBaseLRisk);except end;
  try CloseFile(fFBaseIPrice);except end;
  try CloseFile(fFBaseECBDats);except end;
  try CloseFile(fFBaseIDateCurncy);except end;
  try CloseFile(fFBaseCfg);except end;
  try CloseFile(f1);except end;
  try CloseFile(f2);except end;
  try CloseFile(f3);except end;
  try CloseFile(fFBaseFPut);except end;
  try CloseFile(fFBasePrice);except end;
end;
Except
    On E:Exception do
    Begin
        Result := False;
    End;
End;
End;


Function  CheckCBFileVerIsCB200304(FileName:ShortString):Boolean;
Begin
     Result := False;
     if GetIniFile('FILE','VER','NONE',PChar(FileName+''))='CB200304' THen
        Result := True;
End;

Procedure InitACBBase(aBase:TCBBaseP);
Var
   i : Integer;
Begin

     //rs6224 Update 311

     if aBase=Nil Then exit;

     aBase.PutLst       := TList.Create;
     aBase.DividendLst  := TList.Create;
     aBase.CallLst      := TList.Create;
     aBase.ChartLst     := TList.Create;
     aBase.BaseFPut     := TList.Create;
     aBase.BaseReset2.Reset2 := TList.Create;

     //rs6224 Update 311
     SetLength(aBase.BaseReset2.Ck_Days,5);
     For i:=0 to High(aBase.BaseReset2.CK_Days) do
         aBase.BaseReset2.Ck_Days[i] := 0;

     aBase.CBDocCount   := 0;
     aBase.StkDocCount   := 0;

     aBase.AddNew := False;
     aBase.BID := '';
     aBase.MEM := '';
     aBase.BaseCfg.Reset_Check := False;
     aBase.BaseCfg.Call_Check  := False;
     aBase.BaseCfg.Put_Check   := False;
     aBase.BaseCfg.Dividend_Check := False;
     aBase.BaseCfg.FPut_Check     := False;
     aBase.BaseCfg.Reset_Option   := 0;
     aBase.BaseDat.Scale := NoneNum;
     aBase.BaseDat.TradeCode := '';
     aBase.BaseDat.TCExg     := '';
     aBase.BaseDat.StkCode   := '';
     aBase.BaseDat.SCExg     := '';
     aBase.BaseDat.I_Date    := Date;
     aBase.BaseDat.Duration  := 0;
     aBase.BaseDat.P_Date    := Date;
     aBase.BaseDat.Spot      := NoneNum;
     aBase.BaseDat.Strike    := NoneNum;
     aBase.BaseDat.Vol    := NoneNum;
     aBase.BaseDat.IR     := NoneNum;
     aBase.BaseDat.CR_Premium := NoneNum;
     aBase.BaseDat.B_IR := NoneNum;
     aBase.BaseDat.C_Month := 12;
     aBase.BaseDat.IDateCurncy := 0;
     aBase.BaseDat.LRisk := NoneNum;
     aBase.BaseDat.IPrice := _DftIPrice;
     aBase.BaseDat.IAmount := _DftIAmount;

     aBase.BaseDat.Interest_Chk := False;
     aBase.BaseDat.Interest := NoneNum;

     aBase.BaseDat.TraderCodeEcb := '';
     aBase.BaseDat.DateCurncy := NoneNum;
     aBase.BaseDat.StrikeNTD := NoneNum;
     aBase.BaseDat.StrikeCurncy := NoneNum;
     aBase.BaseDat.StrikeCurncyStyle := 0;

     //aBase.BaseFPut.P_DNum := 0;
     //aBase.BaseFPut.FV_Percent := NoneNum;
     //aBase.BaseFPut.IR_Option  := 1;

     aBase.BaseReset.B_Month   := NoneNum;
     aBase.BaseReset.E_Month   := NoneNum;
     aBase.BaseReset.C_DNum    := NoneNum;
     aBase.BaseReset.L_DNum    := NoneNum;
     aBase.BaseReset.C_Percent := NoneNum;
     aBase.BaseReset.R_Percent := NoneNum;
     aBase.BaseReset.P_Option  := 1;
     aBase.BaseReset.R_Period  := 12;
     aBase.BaseReset.Avg  := false;

     aBase.BasePrice.P_NUM  := NoneNum;
     aBase.BasePrice.S_NUM  := NoneNum;
     aBase.BasePrice.C_Vega := NoneNum;
     aBase.BasePrice.C_Rho  := NoneNum;

     aBase.BasePrice.CB_Price   := NoneNum;
     aBase.BasePrice.CB_Cost    := NoneNum;
     aBase.BasePrice.CV_Ratio   := NoneNum;
     aBase.BasePrice.CV_Premium := NoneNum;
     aBase.BasePrice.CV_Value   := NoneNum;

     aBase.BasePrice.B_Value    := NoneNum;
     aBase.BasePrice.O_Value    := NoneNum;
     aBase.BasePrice.C_Value    := NoneNum;
     aBase.BasePrice.P_Value    := NoneNum;
     aBase.BasePrice.R_Value    := NoneNum;

     aBase.BasePrice.Delta      := NoneNum;
     aBase.BasePrice.Gamma      := NoneNum;
     aBase.BasePrice.Vega       := NoneNum;
     aBase.BasePrice.Rho        := NoneNum;
     aBase.BasePrice.Theta      := NoneNum;
     aBase.BasePrice.B_M_Value      := NoneNum;
     aBase.BasePrice.O_M_Value      := NoneNum;
     aBase.BasePrice.CP_Value      := NoneNum;
     aBase.BasePrice.CPR_Value      := NoneNum;

End;

Procedure FreeACBBaseCall(ABase:TCBBaseP;B_Month,E_Month:Integer);
Var
  aCall  : TCBCallP;
  j : Integer;
Begin
Try
   if aBase=Nil Then Exit;
   if aBase.CallLst=nil Then Exit;

   if B_Month=-1 Then
   Begin
     While aBase.CallLst.Count>0 do
     Begin
       aCall := aBase.CallLst.Items[0];
       aBase.CallLst.Remove(aCall);
       FreeMem(aCall);
     End;
   End Else
   Begin
     For j :=0 to aBase.CallLst.Count-1 do
     Begin
       aCall := aBase.CallLst.Items[j];
       if (aCall.B_Month=B_Month) and (aCall.E_Month=E_Month) Then
       Begin
           aBase.CallLst.Remove(aCall);
           FreeMem(aCall);
           Break;
       End;
     End;
   End;
Except
    On E:Exception do
    Begin
        ////ShowMessage(E.Message);
    End;
End;
End;

Procedure FreeACBBasePut(aBase:TCBBaseP;B_Month,E_Month:Integer);
Var
  aPut  : TCBPutP;
  j : Integer;
Begin
Try
   if aBase=Nil Then Exit;
   if aBase.PutLst=nil Then Exit;
   if B_Month=-1 Then
   Begin
     While aBase.PutLst.Count>0 do
     Begin
       aPut := aBase.PutLst.Items[0];
       aBase.PutLst.Remove(aPut);
       FreeMem(aPut);
     End;
   End Else
   Begin
     For j :=0 to aBase.PutLst.Count-1 do
     Begin
       aPut := aBase.PutLst.Items[j];
       if (aPut.B_Month=B_Month) and (aPut.E_Month=E_Month) Then
       Begin
           aBase.PutLst.Remove(aPut);
           FreeMem(aPut);
           Break;
       End;
     End;
   End;
Except
    On E:Exception do
    Begin
        //////ShowMessage(E.Message);
    End;
End;
End;

Procedure FreeACBBaseFPut(aBase:TCBBaseP;FPutDate:TDate);
Var
  aFPut  : TCBBaseFPutP;
  j : Integer;
Begin
Try
   if aBase=Nil Then Exit;
   if aBase.BaseFPut=Nil Then Exit;
   if FPutDate=-1 Then
   Begin
     While aBase.BaseFPut.Count>0 do
     Begin
       aFPut := aBase.BaseFPut.Items[0];
       aBase.BaseFPut.Remove(aFPut);
       FreeMem(aFPut);
     End;
   End Else
   Begin
     For j :=0 to aBase.BaseFPut.Count-1 do
     Begin
       aFPut := aBase.BaseFPut.Items[j];
       if (aFPut.FP_Date =FPutDate) Then
       Begin
           aBase.BaseFPut.Remove(aFPut);
           FreeMem(aFPut);
           Break;
       End;
     End;
   End;
Except
    On E:Exception do
    Begin
        //////ShowMessage(E.Message);
    End;
End;
End;


Procedure FreeACBBaseReset2(aBase:TCBBaseP;ResetDate:TDate);
Var
  aReset2  : TCBBaseReset2P;
  j : Integer;
Begin
Try
   if aBase=Nil Then Exit;
   if aBase.BaseReset2.Reset2=Nil Then Exit;
   if ResetDate=-1 Then
   Begin
     While aBase.BaseReset2.Reset2.Count>0 do
     Begin
       aReset2 := aBase.BaseReset2.Reset2.Items[0];
       aBase.BaseReset2.Reset2.Remove(aReset2);
       FreeMem(aReset2);
     End;
   End Else
   Begin
     For j :=0 to aBase.BaseReset2.Reset2.Count-1 do
     Begin
       aReset2 := aBase.BaseReset2.Reset2.Items[j];
       if (aReset2.ResetDate=ResetDate) Then
       Begin
           aBase.BaseReset2.Reset2.Remove(aReset2);
           FreeMem(aReset2);
           Break;
       End;
     End;
   End;
Except
    On E:Exception do
    Begin
        //////ShowMessage(E.Message);
    End;
End;
End;


Procedure FreeACBBaseDividend(aBase:TCBBaseP;DivDate:TDate);
Var
  aDiv  : TCBDividendP;
  j : Integer;
Begin
Try
   if aBase=Nil Then Exit;
   if aBase.DividendLst=nil Then Exit;
   if DivDate=-1 Then
   Begin
     While aBase.DividendLst.Count>0 do
     Begin
       aDiv := aBase.DividendLst.Items[0];
       aBase.DividendLst.Remove(aDiv);
       FreeMem(aDiv);
     End;
   End Else
   Begin
     For j :=0 to aBase.DividendLst.Count-1 do
     Begin
       aDiv := aBase.DividendLst.Items[j];
       if (aDiv.DividendDate=DivDate) Then
       Begin
           aBase.DividendLst.Remove(aDiv);
           FreeMem(aDiv);
           Break;
       End;
     End;
   End;
Except
    On E:Exception do
    Begin
        //////ShowMessage(E.Message);
    End;
End;
End;

Function  GetACBBaseReset2(ABase:TCBBaseP;ResetDate:TDate):TCBBaseReset2P;
Var
  aBaseReset2  : TCBBaseReset2P;
  j : Integer;
Begin
Try
    Result := nil;
   if aBase=Nil Then Exit;
   if aBase.BaseReset2.Reset2 =nil Then Exit;
   For j :=0 to aBase.BaseReset2.Reset2.Count-1 do
   Begin
       aBaseReset2 := aBase.BaseReset2.Reset2.Items[j];
       if aBaseReset2.ResetDate = ResetDate Then
       Begin
           Result := aBaseReset2;
           Break;
       End;
   End;
Except
    On E:Exception do
    Begin
        Result := Nil;
        ////ShowMessage(E.Message);
    End;
End;
End;

Procedure SortBaseReset2Lst(BufferGrid:TList);
var
  lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2 : TCBBaseReset2P;
  i,Count :Integer;
Begin
  if BufferGrid=nil then exit;
  if BufferGrid.Count=0 then exit;

  i := BufferGrid.Count;
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);
  repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin
            lTemp  := BufferGrid.Items[lLoop1];
            lHold  := lLoop1;
            lTemp2 := BufferGrid.Items[lHold - lHValue];
            while lTemp2.ResetDate  > lTemp.ResetDate do
            Begin
                 BufferGrid.Items[lHold] := BufferGrid.Items[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
                 lTemp2 := BufferGrid.Items[lHold - lHValue];
            End;
            BufferGrid.Items[lHold] := lTemp;
        End;
  Until lHValue = 0;
End;

Function AddACBBaseReset2(ABase:TCBBaseP;ResetDate:TDate;R_Percent:Double):Boolean;
Var
  aBaseReset2  : TCBBaseReset2P;
Begin
Try
    Result := False;
    if aBase=Nil Then  Exit;
    if aBase.BaseReset2.Reset2=nil then
       aBase.BaseReset2.Reset2 := TList.Create;
    aBaseReset2 := GetACBBaseReset2(ABase,ResetDate);
    if aBaseReset2=nil Then
    Begin
      New(aBaseReset2);
      aBase.BaseReset2.Reset2.Add(aBaseReset2);
    End;
    aBaseReset2.ResetDate := ResetDate;
    aBaseReset2.R_Percent := R_Percent;
    SortBaseReset2Lst(aBase.BaseReset2.Reset2);
    Result := True;
Except
    On E:Exception do
    Begin
        Result := False;
        //////ShowMessage(E.Message);
    End;
End;
End;

Function  GetACBBaseFPut(ABase:TCBBaseP;FPDate:TDate):TCBBaseFPutP;
Var
  aFPut : TCBBaseFPutP;
  j : Integer;
Begin
Try
    Result := nil;
   if aBase=Nil Then Exit;
   if aBase.BaseFPut =nil Then Exit;
   For j :=0 to aBase.BaseFPut.Count-1 do
   Begin
       aFPut := aBase.BaseFPut.Items[j];
       if aFPut.FP_Date=FPDate  Then
       Begin
           Result := aFPut;
           Break;
       End;
   End;
Except
    On E:Exception do
    Begin
        Result := Nil;
        ////ShowMessage(E.Message);
    End;
End;
End;

Procedure SortBaseFPutLst(BufferGrid:TList);
var
  //逼ノ
  lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2 : TCBBaseFPutP;
  i,Count :Integer;
Begin
  if BufferGrid=nil then exit;
  if BufferGrid.Count=0 then exit;
  i := BufferGrid.Count;
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);
  repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin
            lTemp  := BufferGrid.Items[lLoop1];
            lHold  := lLoop1;
            lTemp2 := BufferGrid.Items[lHold - lHValue];
            while lTemp2.FP_Date > lTemp.FP_Date do
            Begin
                 BufferGrid.Items[lHold] := BufferGrid.Items[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
                 lTemp2 := BufferGrid.Items[lHold - lHValue];
            End;
            BufferGrid.Items[lHold] := lTemp;
        End;
  Until lHValue = 0;
End;

Function GetACBBasePut(ABase:TCBBaseP;B_Month,E_Month:Integer):TCBPutP;
Var
  aPut   : TCBPutP;
  j : Integer;
Begin
Try
    Result := nil;
    if aBase=Nil Then Exit;
    if aBase.PutLst=nil Then Exit;
    For j :=0 to aBase.PutLst.Count-1 do
    Begin
         aPut := aBase.PutLst.Items[j];
         if (aPut.B_Month=B_Month) and (aPut.E_Month=E_Month) Then
         Begin
            Result := aPut;
            Break;
         End;
    End;
Except
    On E:Exception do
    Begin
        Result := Nil;
        //////ShowMessage(E.Message);
    End;
End;
End;



Function AddACBBaseFPut(ABase:TCBBaseP;
                          FP_Date:TDate;FV_Percent:Double;
                          IR_Option:Integer):Boolean;
Var
  aFPut  : TCBBaseFPutP;
Begin
Try
    Result := False;
    if aBase=Nil Then  Exit;
    if aBase.BaseFPut=Nil Then
       aBase.BaseFPut := TList.Create;
    aFPut := GetACBBaseFPut(ABase,FP_Date);
    if aFPut=nil Then
    Begin
      New(aFPut);
      aBase.BaseFPut.Add(aFPut);
    End;
    aFPut.FP_Date := FP_Date;
    aFPut.FV_Percent := FV_Percent;
    aFPut.IR_Option  := IR_Option;
    SortBaseFPutLst(aBase.BaseFPut);
    Result := True;
Except
    On E:Exception do
    Begin
        Result := False;
        //////ShowMessage(E.Message);
    End;
End;
End;

Procedure SortPutLst(BufferGrid:TList);
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2 : TCBPutP;
  i,Count :Integer;
Begin
  if BufferGrid=nil then exit;
  if BufferGrid.Count=0 then exit;
  i := BufferGrid.Count;
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin
            lTemp  := BufferGrid.Items[lLoop1];
            lHold  := lLoop1;
            lTemp2 := BufferGrid.Items[lHold - lHValue];
            while lTemp2.B_Month > lTemp.B_Month do
            Begin
                 BufferGrid.Items[lHold] := BufferGrid.Items[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
                 lTemp2 := BufferGrid.Items[lHold - lHValue];
            End;
            BufferGrid.Items[lHold] := lTemp;
        End;
  Until lHValue = 0;
End;

Function AddACBBasePut(ABase:TCBBaseP;
                       B_Month,E_Month,C_DNum,L_DNum:Integer;
                       C_Percent,V_Percent:Double;
                       I_Option:Integer;Avg:Boolean):Boolean;
Var
  aPut  : TCBPutP;
Begin
Try
    Result := False;
    if aBase=Nil Then  Exit;
    if aBase.PutLst=nil then
       aBase.PutLst := TList.Create;
    aPut := GetACBBasePut(ABase,B_Month,E_Month);
    if aPut=nil Then
    Begin
      New(aPut);
      aBase.PutLst.Add(aPut);
    End;
    aPut.B_Month := B_Month;
    aPut.E_Month := E_Month;
    aPut.C_Dnum  := C_DNum;
    aPut.L_DNum  := L_DNum;
    aPut.C_Percent := C_Percent;
    aPut.V_Percent := V_Percent;
    aPut.I_Option  := I_Option;
    aPut.Avg       := Avg;
    SortPutLst(aBase.PutLst);

    Result := True;
Except
    On E:Exception do
    Begin
        Result := False;
        //////ShowMessage(E.Message);
    End;
End;
End;

Function GetACBBaseCall(ABase:TCBBaseP;B_Month,E_Month:Integer):TCBCallP;
Var
  aCall  : TCBCallP;
  j : Integer;
Begin
Try
    Result := nil;
   if aBase=Nil Then Exit;
   if aBase.CallLst=nil Then Exit;
   For j :=0 to aBase.CallLst.Count-1 do
   Begin
       aCall := aBase.CallLst.Items[j];
       if (aCall.B_Month=B_Month) and (aCall.E_Month=E_Month) Then
       Begin
           Result := aCall;
           Break;
       End;
   End;
Except
    On E:Exception do
    Begin
        Result := Nil;
        ////ShowMessage(E.Message);
    End;
End;
End;

Procedure SortCallLst(BufferGrid:TList);    //0 递增 1 递减
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2 : TCBCallP;
  i,Count :Integer;
Begin
  if BufferGrid=nil then exit;
  if BufferGrid.Count=0 then exit;

  i := BufferGrid.Count;
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin
            lTemp  := BufferGrid.Items[lLoop1];
            lHold  := lLoop1;
            lTemp2 := BufferGrid.Items[lHold - lHValue];
            while lTemp2.B_Month > lTemp.B_Month do
            Begin
                 BufferGrid.Items[lHold] := BufferGrid.Items[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
                 lTemp2 := BufferGrid.Items[lHold - lHValue];
            End;
            BufferGrid.Items[lHold] := lTemp;
        End;
  Until lHValue = 0;
End;

Function AddACBBaseCall(ABase:TCBBaseP;
                         B_Month,E_Month,C_DNum,L_DNum:Integer;
                         C_Percent,V_Percent,A_Return:Double;
                         I_Option:Integer;Avg:Boolean):Boolean;
Var
  aCall  : TCBCallP;
Begin
Try
    Result := False;
    if aBase=Nil Then  Exit;
    if aBase.CallLst=nil then
       aBase.CallLst := TList.Create;
    aCall := GetACBBaseCall(ABase,B_Month,E_Month);
    if aCall=nil Then
    Begin
      New(aCall);
      aBase.CallLst.Add(aCall);
    End;
    aCall.B_Month := B_Month;
    aCall.E_Month := E_Month;
    aCall.C_Dnum  := C_DNum;
    aCall.L_DNum  := L_DNum;
    aCall.C_Percent := C_Percent;
    aCall.V_Percent := V_Percent;
    aCall.I_Option  := I_Option;
    aCall.A_Return  := A_Return;
    aCall.Avg       := Avg;
    SortCallLst(aBase.CallLst);
    Result := True;
Except
    On E:Exception do
    Begin
        Result := False;
        //////ShowMessage(E.Message);
    End;
End;
End;

Function  InPutCBFromFile0304_5(InputFile:ShortString;
  Var MyCLassLst:TList;DefIR,DefCRPremium,DefBIR,DefLRisk:Double;
  Var Err:Integer;Proc:TFarProc=nil):Boolean;
Var
  aClass : TCBClassP;
  aBase  : TCBBaseP;
  ValStr,sFileN,sHint : ShortString;
  Section : string;
  b,i,j,iEnd,iBegin : Integer;
  InterestLst : TCBInterestLST;
  CkDays : Array of Integer;
  ts:TStringList; StrLst:_cStrLst;

  function GetIniCacheME(aStartLine:integer;aField,aDft:string):string;
  var x1:integer; xstr1:string;
  begin
    result:=aDft;
    for x1:=aStartLine to ts.count-1 do
    begin
      if iEnd<x1 then
        iEnd:=x1;
      if IsSecLine(ts[x1]) then
        break;
      if Pos(aField+'=',ts[x1])=1 then
      begin
        xstr1:=ts[x1];
        xstr1:=StringReplace(xstr1,aField+'=','',[rfReplaceAll]);
        xstr1:=trim(xstr1);
        if xstr1<>'' then
          result:=xstr1;
        break;
      end;
    end;
  end;
Begin
    Result := False;
    Err := 0;
    if Not CheckCBFileVerIsCB200304(InputFile) Then
    Begin
        Err := 1;//格式错误
        exit;
    End;
    if not FileExists(InputFile) then
    Begin
        Err := 1;//格式错误
        exit;
    End;
    sFileN:=ExtractFileName(InputFile);

  ts:=TStringList.Create;
try
  try
    ts.LoadFromFile(InputFile);
    i:=0;
    while i<ts.count do
    begin
      sHint:=Format('%s(%d/%d)',[sFileN,i+1,ts.count]);
      //CB_Msg(sHint+'加载资料...',Proc);
      if IsSecLine(ts[i]) then
      begin
        iBegin:=i;
        iEnd:=-1;
        if sametext(ts[i],'[CLASS]') then
        begin
          ValStr := GetIniCacheME(i+1,('CID'),'NONE');
          if ValStr='NONE' Then exit;
          New(aClass);
          aClass.BaseLst   := TList.Create;
          aClass.ChartLst  := TList.Create;
          aClass.CID := ValStr;
          MyClassLst.Add(aClass);

          aClass.HaveUpdate := True;
          aClass.MEM := GetIniCacheME(i+1,('MEM'),'');
        end
        else begin
          if Pos('[BASE',ts[i])=1 then
          begin
            ValStr := GetIniCacheME(i+1,('BID'),'NONE');
            if ValStr='NONE' Then Break;

            New(aBase);
            InitACBBase(aBase);
            aBase.BID := ValStr;
            aClass.BaseLst.Add(ABase);

            FreeACBBaseCall(ABase,-1,-1);
            FreeACBBasePut(ABase,-1,-1);
            FreeACBBaseFPut(ABase,-1);
            FreeACBBaseReset2(ABase,-1);
            SetLength(aBase.InterestLst,0);
            SetLength(aBase.BaseReset2.CK_Days,0);

            //-------------
            aBase.MEM := GetIniCacheME(i+1,('MEM'),'');
            aBase.BaseDat.I_Date      := StrToFloat(GetIniCacheME(i+1,('I_Date'),''));
            aBase.BaseDat.P_Date:=aBase.BaseDat.I_Date ;
            aBase.BaseCfg.Dividend_Check := IntToBool(StrToInt(GetIniCacheME(i+1,('Dividend_Check'),'')));
            aBase.BaseDat.Scale       := StrToFloat(GetIniCacheME(i+1,('Scale'),'-999999999'));
            aBase.BaseDat.TradeCode   := GetIniCacheME(i+1,('TradeCode'),'');
            aBase.BaseDat.TCExg       := GetIniCacheME(i+1,('TCExg'),'');
            aBase.BaseDat.StkCode     := GetIniCacheME(i+1,('StkCode'),'');
            aBase.BaseDat.SCExg       := GetIniCacheME(i+1,('SCExg'),'');
            aBase.BaseDat.Duration    := StrToInt(GetIniCacheME(i+1,('Duration'),'-999999999'));
            aBase.BaseDat.C_Month     := StrToInt(GetIniCacheME(i+1,('C_Month'),'-999999999'));
            aBase.BaseDat.Interest_Chk:= IntToBool(StrToInt(GetIniCacheME(i+1,('Interest_Chk'),'0')));
            aBase.BaseDat.Interest    := StrToFloat(GetIniCacheME(i+1,('Interest'),'-999999999'));

            aBase.BaseDat.TraderCodeEcb:= GetIniCacheME(i+1,('TraderCodeEcb'),'');
            aBase.BaseDat.DateCurncy    := StrToFloat(GetIniCacheME(i+1,('DateCurncy'),'-999999999'));
            aBase.BaseDat.StrikeNTD:= StrToFloat(GetIniCacheME(i+1,('StrikeNTD'),'-999999999'));
            aBase.BaseDat.StrikeCurncy    := StrToFloat(GetIniCacheME(i+1,('StrikeCurncy'),'-999999999'));
            aBase.BaseDat.StrikeCurncyStyle:= StrToInt(GetIniCacheME(i+1,('StrikeCurncyStyle'),'0'));

            aBase.BaseDat.IPrice    := StrToFloat(GetIniCacheME(i+1,('IPrice'),'-999999999'));
            aBase.BaseDat.IAmount    := StrToFloat(GetIniCacheME(i+1,('IAmount'),'-999999999'));
            aBase.BaseDat.DateCurncy    := StrToFloat(GetIniCacheME(i+1,('DateCurncy'),'-999999999'));

            aBase.BaseCfg.Reset_Option := StrToInt(GetIniCacheME(i+1,('Reset_Option'),'0'));
            aBase.BaseCfg.Reset_Check := IntToBool(StrToInt(GetIniCacheME(i+1,('Reset_Check'),'0')));
            aBase.BaseCfg.Call_Check := IntToBool(StrToInt(GetIniCacheME(i+1,('Call_Check'),'0')));
            aBase.BaseCfg.Put_Check := IntToBool(StrToInt(GetIniCacheME(i+1,('Put_Check'),'0')));
            aBase.BaseCfg.FPut_Check := IntToBool(StrToInt(GetIniCacheME(i+1,('FPut_Check'),'0')));

            aBase.BaseReset.B_Month  :=StrToInt(GetIniCacheME(i+1,('B_Month'),'-999999999'));
            aBase.BaseReset.E_Month  :=StrToInt(GetIniCacheME(i+1,('E_Month'),'-999999999'));
            aBase.BaseReset.C_DNum   :=StrToInt(GetIniCacheME(i+1,('C_DNum'),'-999999999'));
            aBase.BaseReset.L_DNum   :=StrToInt(GetIniCacheME(i+1,('L_DNum'),'-999999999'));
            aBase.BaseReset.C_Percent:=StrToFloat(GetIniCacheME(i+1,('C_Percent'),'-999999999'));
            aBase.BaseReset.R_Percent:=StrToFloat(GetIniCacheME(i+1,('R_Percent'),'-999999999'));
            aBase.BaseReset.P_Option :=StrToInt(GetIniCacheME(i+1,('P_Option'),'1'));
            aBase.BaseReset.R_Period :=StrToInt(GetIniCacheME(i+1,('R_Period'),'-999999999'));
            aBase.BaseReset.Avg      :=IntToBool(StrToInt(GetIniCacheME(i+1,('Avg'),'0')));

            j := 0;
            While true do
            Begin
                ValStr := GetIniCacheME(i+1,('Reset_CkDays'+IntToStr(j)),'NONE');
                if ValStr='NONE' Then Break;
                SetLength(CkDays,j+1);
                CkDays[j] := StrToInt(ValStr);
                j := j+1;
            End;
            aBase.BaseReset2.CK_Days :=  @CkDays[0];
            //-----------------------------------


            j := 0;
            While true do
            Begin
                ValStr := GetIniCacheME(i+1,('Base_Reset2'+IntToStr(j)),'NONE');
                if ValStr='NONE' Then Break;
                StrLst := DoStrArray(ValStr,',');
                AddACBBaseReset2(aBase,StrToDate2(StrLst[0]),StrToFloat(StrLst[1]));
                j := j+1;
            End;


            //rs6224 Update 311

            j := 0;
            While true do
            Begin
                ValStr := GetIniCacheME(i+1,('Base_FPut'+IntToStr(j)),'NONE');
                if ValStr='NONE' Then Break;
                StrLst := DoStrArray(ValStr,',');
                AddACBBaseFPut(aBase,StrToDate2(StrLst[0]),StrToFloat(StrLst[1]),StrToInt(StrLst[2]));
                j := j+1;
            End;

            j := 0;
            While true do
            Begin
                ValStr := GetIniCacheME(i+1,('Base_Interest'+IntToStr(j)),'NONE');
                if ValStr='NONE' Then Break;
                SetLength(InterestLst,j+1);
                StrLst := DoStrArray(ValStr,',');
                InterestLst[j].SER := StrToInt(StrLst[0]);
                InterestLst[j].Interest := StrToFloat(StrLst[1]);
                j := j+1;
            End;
            ABase.InterestLst :=  InterestLst;



            j := 0;
            While true do
            Begin
                ValStr := GetIniCacheME(i+1,('Base_Put'+IntToStr(j)),'NONE');
                if ValStr='NONE' Then Break;
                StrLst := DoStrArray(ValStr,',');

                AddACBBasePut(aBase,StrToInt(StrLst[1]),StrToInt(StrLst[2]),
                              StrToInt(StrLst[3]),StrToInt(StrLst[4]),StrToFloat(StrLst[5]),
                              StrToFloat(StrLst[6]),StrToInt(StrLst[7]),IntToBool(StrToInt(StrLst[0])));
                j := j+1;
            End;


            //rs6224 UPdate 311

            j := 0;
            While true do
            Begin
                ValStr := GetIniCacheME(i+1,('Base_Call'+IntToStr(j)),'NONE');
                if ValStr='NONE' Then Break;
                StrLst := DoStrArray(ValStr,',');
                if High(StrLst)=8 Then
                Begin
                  AddACBBaseCall(aBase,StrToInt(StrLst[1]),StrToInt(StrLst[2]),
                              StrToInt(StrLst[3]),StrToInt(StrLst[4]),StrToFloat(StrLst[5]),
                              StrToFloat(StrLst[6]),StrToFloat(StrLst[8]),StrToInt(StrLst[7]),IntToBool(StrToInt(StrLst[0])));
                ENd;
                if High(StrLst)=7 Then
                Begin
                  AddACBBaseCall(aBase,StrToInt(StrLst[1]),StrToInt(StrLst[2]),
                              StrToInt(StrLst[3]),StrToInt(StrLst[4]),StrToFloat(StrLst[5]),
                              StrToFloat(StrLst[6]),0,StrToInt(StrLst[7]),IntToBool(StrToInt(StrLst[0])));
                ENd;
                j := j+1;
            End;
          end;
        end;
        if iEnd<>-1 then
        begin
          i:=iEnd-1;
        end;
      end;
      inc(i);
    end;
  Except
      On E: Exception do
      Begin
        //Sleep(1);
        //WriteLineForTimeCBPA('e:'+e.Message+InputFile,'InPutCBFromFile0304Debug');
      End;
  End;
finally
    try if Assigned(ts) then FreeAndNil(ts); except end;
end;
End;


Function GetACBClass(ClassLst:TList;CID:ShortString):TCBClassP;
Var
  aClass : TCBClassP;
  i : Integer;
Begin
Try
    Result := nil;
    if Length(CID)=0 Then Exit;
    if ClassLst=Nil  Then Exit;
    For i :=0 to ClassLst.Count-1 do
    Begin
        aClass := ClassLst.Items[i];
        if lowerCase(aClass.CID)=lowerCase(CID) Then
        Begin
           Result := aClass;
           Break;
        End;
    End;
Except
    On E:Exception do
    Begin
        Result := Nil;
        ////ShowMessage(E.Message);
    End;
End;
End;

Function GetACBChart(ChartLst:TList;GID:ShortString):TCBChartP;
Var
  aChart  : TCBChartP;
  i : Integer;
Begin
Try
    Result := nil;
    if Length(GID)=0 Then Exit;
    if ChartLst=nil Then Exit;
    For i :=0 to ChartLst.Count-1 do
    Begin
        aChart := ChartLst.Items[i];
        if aChart.GID=GID Then
        Begin
           Result := aChart;
           Break;
        End;
    End;
Except
    On E:Exception do
    Begin
        Result := Nil;
        ////ShowMessage(E.Message);
    End;
End;
End;

Procedure FreeACBChart(ChartLst:TList;GID:ShortString);
Var aChart : TCBChartP;
    i,j,k:integer;
Begin
     aChart := GetACBChart(ChartLst,GID);
    if aChart=nil Then exit;
    for i:=Low(aChart.ChartBYLst) to High(aChart.ChartBYLst) do
    begin
      for j:=Low(aChart.ChartBYLst[i].ChartY) to High(aChart.ChartBYLst[i].ChartY) do
      begin
        SetLength(aChart.ChartBYLst[i].ChartY[j].ChartXY,0);
      end;
      SetLength(aChart.ChartBYLst[i].ChartY,0);
    end;
    SetLength(aChart.ChartBYLst,0);
    ChartLst.Remove(aChart);
    FreeMem(aChart);
End;

Function GetACBBase(BaseLst:TList;BID:ShortString):TCBBaseP;
Var
  aBase  : TCBBaseP;
  i : Integer;
Begin
Try
    Result := nil;
    if Length(BID)=0 Then Exit;
    if BaseLst=nil Then Exit;

    For i :=0 to BaseLst.Count-1 do
    Begin
        aBase := BaseLst.Items[i];
        if SameText(aBase.BID,BID) or SameText(aBase.BaseDat.TradeCode,BID)  Then
        Begin
           Result := aBase;
           Break;
        End;
    End;
Except
    On E:Exception do
    Begin
        Result := Nil;
        ////ShowMessage(E.Message);
    End;
End;
End;

Procedure FreeACBBase(BaseLst:TList;BID:ShortString);
Var
  aChart : TCBChartP;
  aBase  : TCBBaseP;
  RemoveID : Array of String[38];
  g : Integer;
Begin
    aBase := GetACBBase(BaseLst,BID);
    if aBase=nil Then exit;
    SetLength(RemoveID,aBase.ChartLst.Count);
    For g:=0 to aBase.ChartLst.Count-1 do
    Begin
      aChart := aBase.ChartLst.Items[g];
      RemoveID[g] := aChart.GID;
    End;
    For g:=0 to High(RemoveID) do
      FreeACBChart(aBase.ChartLst,RemoveID[g]);

    FreeACBBaseCall(ABase,-1,-1);
    FreeACBBasePut(ABase,-1,-1);
    FreeACBBaseDividend(ABase,-1);
    FreeACBBaseFPut(ABase,-1);
    FreeACBBaseReset2(ABase,-1);

    SetLength(aBase.InterestLst,0);
    SetLength(aBase.BaseReset2.Ck_Days,0);

    aBase.CallLst.free;
    aBase.DividendLst.Free;
    aBase.PutLst.Free;
    aBase.BaseFPut.Free;
    aBase.ChartLst.free;
    aBase.BaseReset2.Reset2.free;
    SetLength(ABase.ChartOutData.OutPDateLst,0);

    BaseLst.Remove(aBase);
    FreeMem(aBase);
    SetLength(RemoveID,0);
End;

Procedure FreeACBClass(ClassLst:TList;CID:ShortString);
Var
  aClass : TCBClassP;
  aChart : TCBChartP;
  aBase  : TCBBaseP;
  RemoveID : Array of String[38];
  g : Integer;
Begin

   aClass := GetACBClass(ClassLst,CID);
   if aClass=Nil Then Exit;
try
try
   SetLength(RemoveID,aClass.ChartLst.Count);
   For g:=0 to aClass.ChartLst.Count-1 do
   Begin
     aChart := aClass.ChartLst.Items[g];
     RemoveID[g] := aChart.GID;
   End;
   For g:=0 to High(RemoveID) do
     FreeACBChart(aClass.ChartLst,RemoveID[g]);
   aClass.ChartLst.Free;

   SetLength(RemoveID,aClass.BaseLst.Count);
   For g:=0 to aClass.BaseLst.Count-1 do
   Begin
     aBase := aClass.BaseLst.Items[g];
     RemoveID[g] := aBase.BID;
   End;
   For g:=0 to High(RemoveID) do
     FreeACBBase(aClass.BaseLst,RemoveID[g]);
   aClass.BaseLst.Free;
   FreeMem(aClass);
   SetLength(RemoveID,0);
Except
End;
Finally
   ClassLst.Remove(aClass);
End;
End;

Procedure FreeCBClass(ClassLst:TList);
Var
  aClass : TCBClassP;
  RemoveID : Array of String[38];
  g : Integer;
Begin
   if ClassLst=Nil Then Exit;
   SetLength(RemoveID,ClassLst.Count);
   For g:=0 to ClassLst.Count-1 do
   Begin
     aClass := ClassLst.Items[g];
     RemoveID[g] := aClass.CID;
   End;
   For g:=0 to High(RemoveID) do
     FreeACBClass(ClassLst,RemoveID[g]);
   ClassLst.Free;
   SetLength(RemoveID,0);
End;

end.
