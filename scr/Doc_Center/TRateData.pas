unit TRateData;

interface
uses
  Controls, Windows;

Const
  DefNum = -999999999;
  _BCNameTblFile = 'BCNameTbl.tbl';
  _TYCFile = 'TYC.dat';
  _TSubIndexFile = 'SubIndex.dat';
  _IRDateFile = 'IRDate.idx';
  _CBRefRateFile = 'CBRefRate.dat';
  _RateDateFile = 'RateDate.idx';
  _0RateFile = '0Rate.dat';
  _SwapOptionTag = 'SwapOption';
  _SwapYieldTag = 'SwapYield';

  _GongZhaiZhiRateCaption='そ杜崔瞯Ρ絬';
  _GongZhaiZhiShuRiBaoBiaoCaption='[籓芖そ杜计]ら厨';

  _GongZhaiBasicCaption='杜ㄩ膀セ戈';
  _GongZhaiHangqingCaption='杜ㄩ︽薄';

  _Manner14Caption='崔瞯';
  _Maner0RateCaption='箂崔瞯';
  _Manner2Caption='(犁)崔瞯/κじ基(瓣悔杜)';
  _Manner3Caption='そ杜计妓セ';//'[籓芖そ杜计]ら厨ぇ计妓セ';
  _Manner5Caption='そ杜计';//'[籓芖そ杜计]ら厨ぇだ摸计妓セ';
  _Manner6Caption='そ杜把σ瞯';

  _SwapOptionCaption='匡拒舦︽薄';
  _SwapYieldCaption='㏕﹚Μ痲︽薄';

  _ArySubIndex:array[0..3] of ShortString=(
    '舦キА布瞯',
    '舦キА戳戳',
    '舦キА崔瞯',
    '舦キА尿戳丁');
    
type

TCheckStatus=(chkNone,chkOK,chkDel,chkEsc);

TManner14Rec =  record          //方式一、四
  BondCode : String[10];  //代码
  Rate : Double;         //殖利率利率曲线
  ResidualYear:Double;   //剩余年期
End;
TManner14RecLst = Array of TManner14Rec;

TOne0RateRec =  record          //零息殖利率
  Long :Double;  //期间
  LongType : byte; //期间类型0=年 1=月
  CubicBSpline:Double;   //Cubic B-Spline零息利率
  Svensson:Double;   //Svensson零息利率
End;
T0RateRec =  record          //零息殖利率
  Adate : Tdate;
  Recs:array[0..61] of TOne0RateRec;
End;
T0RateRecLst = Array of T0RateRec;

TManner2Rec =  record            //方式二
  BondCode : String[10];  //代码
  Name : String[20];    //名称
  Currency : String[5];   //币别
  MaturityDate : String[10];   //到期日
  Duration : Double;     //存续期间
  CouponRate : Double;   //票面利率
  CouponCompondFrequency : String[5]; //每年付\计息次数；
  VolumeWeightedAverageYield : Double;  //加权平均殖利率
  VolumeWeightedAveragePrice : Double;  //加权平均百元价
  LastTradeDate : String[10];   //最近成交日
End;
TManner2RecLst = Array of TManner2Rec;

TManner3Rec =  record             //方式三
  BondCode : String[10];  //代码
  PricewithoutaccuredInterest : Double;   //除息价
  PriceSource : integer;   //价格来源；
  AccuredInterest : Double;  //应计息
  Yieldtomaturity: Double;  //殖利率
  Outstanding:Double;  //債券餘額
  SubIndex : String[2];   //分类指数；
End;
TManner3RecLst = Array of TManner3Rec;

TManner5Rec =  record           //方式五
  Subtype : ShortString;    //指数类型
  Yearsall : Double;      //全样本指数
  years1to3 : Double;     //1-3年分类指数
  years3to5 : Double;     //3-5年分类指数
  years5to7 : Double;     //5-7年分类指数
  years7to10 : Double;    //7-10年分类指数
  years10 : Double;       //10年以上分类指数
End;
TManner5RecLst = Array of TManner5Rec;

TTimeDataRec=record
  Time:Double;
  Data:Double;
end;


TManner6BCRec=record
  CBLevel : ShortString;    //公司债等级
  Months1: Double;
  Months3: Double;
  Months6: Double;
  Years1: Double;
  Years2: Double;
  Years3: Double;
  Years4: Double;
  Years5: Double;
  Years6: Double;
  Years7: Double;
  Years8: Double;
  Years9: Double;
  Years10: Double;
end;
TManner6Rec =  record           //方式六  公司债参考利率
  Adate : Tdate;
  BCRecs:array[0..3] of TManner6BCRec;
End;
  TManner6RecLst = Array of TManner6Rec;

TSwapCBRec=record
  Adate : Tdate;
  BondCode : String[10];  //標的證券代號
  BondName : String[15];  //名稱
  NominalA: Double;   //名目本金(元)
  Volume : Double;   //成交筆數
  H : Double;  //最高
  L: Double;   //最低
  Agv:Double;  //平均
  Y:Double;   //契約期間（年）；
end;
TSwapCBRecP = ^TSwapCBRec;
TSwapCBRecLst = Array of TSwapCBRec;

TSwapCBCountRec=record
  BondCode : String[10];  //標的證券代號
  BondName : String[15];  //名稱
  NominalA: Double;   //名目本金(元)
  Volume : Double;   //成交筆數
end;
TSwapCBCountRecP = ^TSwapCBCountRec;

TBCNameTblRec =  record         //代码表资料
  BondCode : String[10];  //代码
  Name : String[20];    //名称
  Currency : String[5];   //币别
  MaturityDate : Tdate;   //到期日
  CouponRate : Double;   //票面利率
  //Outstanding : Double;  //債券餘額
  //Coupon : integer;   //每年付
  //CompondFrequency : integer; //计息次数；
  CompondFrequency : integer; //每年付/计息次数    1:1/1 、2:1/2 、 3:2/2 、 4:1/4 、5:2/4 、6:4/4 、 7:1/12 、8:12/12;
End;
TBCNameTblRecP=^TBCNameTblRec;
TBCNameTblRecLst = Array of TBCNameTblRec;

  TTYC = record
    BondCode : String[10];  //代码
    Rate : Double;          //殖利率利率曲线
    ResidualYear : Double;  //剩余年限
  End;
TTYCRec =  record          //公債殖利率曲線资料
  Adate : tDate;      //日期
  TYC : Array[0..3] of TTYC;
End;
TTYCRecP=^TTYCRec;
TTYCRecLst = Array of TTYCRec;

  TsubIndex = record
    Yearsall : Double;      //全样本指数
    years1to3 : Double;     //1-3年分类指数
    years3to5 : Double;     //3-5年分类指数
    years5to7 : Double;     //5-7年分类指数
    years7to10 : Double;    //7-10年分类指数
    years10 : Double;       //10年以上分类指数
  End;
TSubIndexRec = record       //分类指数资料
  Adate : Tdate;        //日期
  subIndex : Array[0..3] of TsubIndex;
End;
TSubIndexRecLst = Array of TSubIndexRec;

TIRIDRec = record         //代码内部资料
  Adate : Tdate;     //日期
//  BondCode : String[10];  //代码
  Duration : Double;     //存续期间
  VolumeWeightedAverageYield : Double;  //加权平均殖利率
  VolumeWeightedAveragePrice : Double;  //加权平均百元价
  LastTradeDate : Tdate;   //最近成交日
  PricewithoutaccuredInterest : Double;   //除息价
  PriceSource : integer;   //价格来源
  AccuredInterest : Double;  //应计息
  Yieldtomaturity: Double;  //殖利率
  Outstanding : Double;  //債券餘額
  SubIndex : String[2];   //分类指数；
End;
TIRIDRecLst = Array of TIRIDRec;

////////////////////////////////////////////////////////////

TIRRec = Record
  BondCode : String[20];  //代码
  Rate : Double;          //殖利率利率曲线
  ResidualYear : Double;  //剩余年限

  // Code : String[20];                     //代码
  Name : String[30];                     //名称
  MaturityDate : TDate;              //到期日
  VolumeWeightedAverageYield : Double;   //加权平均殖利率
  LastTradeDate : TDate;             //最近成交日

  // Code : String[20];           //代码
  //Name : String[30];           //名称
  Yieldtomaturity : Double;    //殖利率
  Yearstomaturity : Double;    //距到期
end;
TIRRecLST = Array of TIRRec ;

TIR2Rec = Record
  years1to3 : Double;     //1-3年分类指数
  years3to5 : Double;     //3-5年分类指数
  years5to7 : Double;     //5-7年分类指数
  years7to10 : Double;    //7-10年分类指数
  years10 : Double;       //10年以上分类指数
end;
TIR2RecLST = Array of TIR2Rec;


TECBRate1Rec=record
  Adate : Tdate;
  //CBLevel : string[50];
  Months1: Double;
  Months3: Double;
  Months6: Double;
  Years1: Double;
  Years2: Double;
  Years3: Double;
  Years5: Double;
  Years7: Double;
  Years10: Double;
  Years20: Double;
  Years30: Double;
end;
TECBRate1RecLST = Array of TECBRate1Rec;

TNTDToUSDRec=record
  Adate : Tdate;
  NTDToUSD: Double;
end;
TNTDToUSDRecLST = Array of TNTDToUSDRec;




implementation




end.
