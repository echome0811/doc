unit uLevelDataDefine;

interface
 uses Classes,Controls;
 
const
  BlockSize = 100;
  C_SelectLimit : array[0..4] of String=('>','<','=','>=','<=');
  FmtYYYYMMDD='yyyymmdd';
  FmtYYYYMM='yyyymm';
  _IFRSDatColSize=200;


  _LevelDataF='leveldata.dat';
  _BorrowMoneyF='BorrowMoney.dat';
  _BorrowIDF='BorrowID.dat';
  _BorrowParamF='BorrowParam.dat';
  _IndustryF='StkIndustry.dat';
  _IndustryDifF='StkIndustryDif.dat';
  _StkBase1F='StkBase1.dat';
  _StkBase1DifF='StkBase1Dif.dat';
  _cbbaseinfoF='cbbaseinfo.dat';

  _stockweightdir='stockweight\';
  _stockweightF='stockweight.dat';
  _stockweightDelF='stockweightdel.dat';
  _stockweightguidlstF='stockweightguid.lst';
  

  _TCRIComCodeF='TcriComCode.dat';
  _TCRIComClassCodeF='TcriComClassCode.dat';
  _CodeCYB='CYB';
  _CodeCYB2='CYB2';
  _CodeSZXYou='SZXYou';
  _CodeDLB='DLB';
  _CodeZLB='ZLB';
  _CodeMktClass='MktClass';

  _IFRSTopNodeF='IFRSTopNode.dat';
  _IFRSNodeF='IFRSNode.dat';
  _IFRSColNodeF='IFRSColNode.dat';
  _ZCFZB='1';//資產負債表
  _ZZSYB2='7';
  _ZZSYB='2';//綜合損益表
  _XJLLB='3';//現金流量表
  _ZCFZBStr='資產負債表';
  _ZZSYBStr='綜合損益表';
  _XJLLBStr='現金流量表';
  _IFRSListPkgDat='IFRSListPkgDat';
  _IFRSWorklst='IFRSWork.lst';
  _IFRSWorkHisLst='IFRSWorkHis.lst';

  _ShenBaoCaseComCodeF='shenbaocasecomcode.dat';
  _ShenBaoCaseYearF='shenbaocase.dat';
  _ShenBaoCaseLstF='shenbaocaselist.dat';
  _ThisYUndo='thisyundo';
  _LastYUndo='lastyundo';
  _UnDo='undo';

  _FRBH15TitleF='frbh15title.dat';
  _FRBH15F='frbh15.dat';
type
  TComCodeRec=record
    Idx:integer;
    ClassCode:string[10];
    Name:string[100];
  end;
  TAryComCodeRec = array of TComCodeRec;
  TComCodeRecP = ^TComCodeRec;
  TComClassCodeRec=record
    Idx:integer;
    CYBIdx:integer;
    SZXYouIdx:integer;
    DLBIdx:integer;
    ZLBIdx:integer;
  end;
  TAryComClassCodeRec = array of TComClassCodeRec;
  TComClassCodeRec2=record
    Idx:integer;
    CYBIdx:integer;
    SZXYouIdx:integer;
    DLBIdx:integer;
    ZLBIdx:integer;

    CYBS:string[100];
    SZXYouS:string[100];
    DLBS:string[100];
    ZLBS:string[100];
  end;
  TAryComClassCodeRec2 = array of TComClassCodeRec2;
  TComClassCodeRec2P = ^TComClassCodeRec2;

  //中華信評
  TPLevelRec=packed record
    Comp:string[100];//公司全稱
    //Date:shortstring;//日期
    LongLevel:string[10];//信用評等長期
    ShortLevel:string[10]; //信用評等短期
    LookLevel:string[10];//評等展望
    PClass:string[100];//產業別的資料是否要加入到此處，因為網站中并沒有此資料，但此處的資料是通過手工錄入的
  end;
  TAryPLevelRec = array of TPLevelRec;

  TCodeClass=packed record
    Code:string[10];
    PClass:string[100];//上市別
    CompClass:string[30];//產業別
    TEJ:string[60];//產業小類
  end;
  PCodeClass = ^TCodeClass;

  TStkIndustry=packed record
    Code:string[10];//股票代碼
    CYB:string[100];//產業類別
    SZXYou:string[100];//上中下游
    DLB:string[100];//大類
    ZLB:string[100];//子類
    MktClass:string[100];//市場別
  end;
  TStkIndustryP = ^TStkIndustry;
  TAryStkIndustry = array of TStkIndustry;
  
  TStkIndustryRec=packed record
    Code:string[10];//股票代碼
    ComClassCode:integer;
  end;
  TAryStkIndustryRec = array of TStkIndustryRec;
  
  TStkIndustryRecP = ^TStkIndustryRec;
  TStkIndustryRec2=packed record
    Code:string[10];//股票代碼
    AryComClassCode: array of integer;
    Flag:string[2];
  end;
  TStkIndustryRec2P = ^TStkIndustryRec2;
  TAryStkIndustryRec2 = array of TStkIndustryRec2;

  TStkBase1=packed record
    Code:string[10];//股票代碼
    MktClass:string[100];//市場別
    CYB:string[100];//產業類別
  end;
  TStkBase1P = ^TStkBase1;
  TAryStkBase1 = array of TStkBase1; 
  TStkBase1Rec=packed record
    Code:string[10];//股票代碼
    ComCodeMktClass:integer;
    ComCodeCYB:integer;
  end;
  TStkBase1RecP = ^TStkBase1Rec;
  TAryStkBase1Rec = array of TStkBase1Rec;


  TTCRIRec=packed record
    Code:string[10];
    //本期TCRI等級
    NowLevel:string[5];
    //前期TCRI等級
    //PreLeve:string[10];
    //財報依據_年/月
    BaseReportDate:string[12];
    //評等日
    PDate:string[12];
    //TCRI等級異動說明（將其中的回車換行以字串#13#10存儲）
    Des: array [0..1024] of Char;
    MktC:string[15];//上市別
  end;
  PTCRIRec = ^TTCRIRec;
  TAryTCRIRec = array of TTCRIRec;


  TIDRec=record
    EID:string[20];
    SID:string[10];
    SName:string[20];
  end;
  TAryIDRec = array of TIDRec;

  TASelectValueItem= Packed Record
     SelcetColKey : String[20];
     ValueLimit : String[2];
     Value : Variant;
  End;
  PASelectValueItem = ^TASelectValueItem;

TRptCol = Packed Record
    //IsClass : String[20];
    ColKey  : String[50];
    ColName : String[50];
    ColFmtType  : String[1];
    ColFmt  : String[5];
End;
TRptColP = ^TRptCol;

//產業別
TClassRec=record
  CompCode:string[10];//公司代號
  CompFullName:string[50];//公司全稱
  Address:string[50];//地址
  BinNo:string[15];//營利事業統一編號
  DSZ:string[10];//董事長
  ZJL:string[10];//總經理
  Sayer:string[10];//發言人
  SayerInstitute:string[20];//發言人職稱
  SayerAgent:string[20];//代理發言人
  TopTel:string[20];//總機電話
  StartDate:string[10];//成立日期
  MarketDate:string[10];//上市日期
  PerAmount:string[20];//普通股每股面額
  FactAccount:string[20];//實收資本額(元)
  IssueCount:string[20];//已發行普通股數或TDR原發行股數
  PrivateCount:string[20];//私募普通股(股)
  SpecialCount:string[20];//特別股(股)
  RptType:string[20];//編製財務報告類型
  TranferInstitute:string[50];//股票過戶機構
  TranferTel:string[20];//過戶電話
  TranferAddress:string[50];//過戶地址  
  VisaInstitute:string[50];//簽證會計師事務所
  VisaPerson1:string[10];//簽證會計師1
  VisaPerson2:string[10];//簽證會計師2
  EngCode:string[20];//英文簡稱
  EngAddress:string[80];//英文通訊地址
  Fax:string[20];//傳真機號碼
  EMail:string[50];//電子郵件信箱
  WebAddress:string[80];//網址
  GXRWebAddress:string[150];//網址
end;
TAryClassRec = array of TClassRec;
PClassRec = ^TClassRec;

//產業別
TEPSRec=record
  Year: integer;
  Quarter: integer;
  CompCode:string[10];//公司代號
  YYSR:Double;//營業收入
  YYCB:Double;//營業成本
  YYMLMS:Double;//營業毛利(毛損)
  YSGSJWSXLY:Double;//聯屬公司間未實現利益
  YSGSJYSXLY:Double;//聯屬公司間已實現利益
  YYFY:Double;//營業費用
  YYJLJS:Double;//營業凈利(凈損)
  YYWSRJLY:Double;//營業外收入及利益
  YYWFYJSS:Double;//營業外費用及損失
  JXYYDWSQJLJS:Double;//繼續營業單位稅前凈利(凈損)
  SDSFYLY:Double;//所得稅(費用)利益
  JXYYDWJLJS:Double;//繼續營業單位凈利(凈損)
  TYDWSY:Double;//停業單位損益
  FYSY:Double;//非常損益
  KJYZBDLJYXS:Double;//會計原則變動累計影響數
  BQJLJS:Double;//本期凈利(凈損)
  MGYY:Double;//基本每股盈余
end;
TAryEPSRec = array of TEPSRec;
PEPSRec = ^TEPSRec;


//產業別
TBorrowMoneyRec=record
  Year: Byte;        //年
  Month: Byte;       //月
  CompCode:string[10];//公司代碼
  BorrowBank:string[100];//借款銀行
  BorrowType:Byte;       //長短期借款（借款種類）
  BorrowAmount:Double;   //借款金額（臺幣千元）該筆資料的貸款金額
  BorrowCurrency:Byte;   //借款原幣別
  BorrowInitAmount:Double;//借款原幣值(千元)
  BorrowSDate:TDate;      //借款期間(起)
  BorrowEDate:TDate;      //借款期間(起)
  BorrowDuration:Double;//期間
  RateType:Byte;//利率別		分浮動、變動及固定利率三種
  LowRate:double;//最低利率	  
  HighRate:double;//最高利率	  
  RateRemark:string[200];//利率說明
  GuaranteeType:Byte;//擔保別		有無抵押or擔保品
  GuaranteeRemark:string[200];//擔保品說明
  SyndicatedLoan:Byte;//聯貸（Y/N）		是否為銀行聯貸
  FinancingAmount:double;//融資額度	千元	該筆資料的融資額度
  FinancingType:Byte;//融資幣別		融資額度的幣別

end;
TBorrowMoneyAry= array of TBorrowMoneyRec;
PBorrowMoneyRec = ^TBorrowMoneyRec;



//------------IFRS
{TIFRSTopNodeRec=record
  Idx:integer;//索引序號
  Level:byte;//層次
  ParentNodeIdx:integer;//父節點引序號
  Name:string[50];//名稱
  ListNo:integer;//顯示時的次序號
  TblType:char;//所屬數據表 1=資產負債表 2=綜合損益表 3=現金流量表
end;

TIFRSNodeRec=record
  Idx:integer;//索引序號
  ParentNodeIdx:integer;//父節點引序號
  Name:string[120];//名稱
  ListNo:integer;//顯示時的次序號
  TblType:char;//所屬數據表 1=資產負債表 2=綜合損益表 3=現金流量表
end;}

TIFRSColRec=record
    Idx:integer;//索引序號
    ParentNodeIdx:integer;//父節點引序號
    Name:string[130];//名稱
    ListNo:integer;//顯示時的次序號
    TblType:char;//所屬數據表 1=資產負債表 2=綜合損益表 3=現金流量表
    Kong:Byte;
  end;

TIFRSDatRec=record
    Year:Word;
    Q:Byte;
    Tbl:Byte;
    CompCode:string[4];//代碼
    NumAry:array[0.._IFRSDatColSize] of Double;//會計金額
    IdxAry:array[0.._IFRSDatColSize] of Smallint;//會計項目索引
end;
TIFRSDatRecAry=array of TIFRSDatRec;


  TShenBaoCaseComRec=record
    Idx:integer;
    ClassCode:string[10];
    Name:string[100];
  end;
  TAryShenBaoCaseComRec = array of TShenBaoCaseComRec;
  TShenBaoCaseComRecP = ^TShenBaoCaseComRec;
  
  TDatasRec=record
    Datas:array[0..19] of string;
  end;
  TAryDatasRec = array of TDatasRec;
  
  TShenBaoCaseRec=record
    key:ShortString;
    code:ShortString;//證券代號
    mkt:integer;//公司型態--gsxt
    closetype:Integer;//結案類型--jalx
    stkname:ShortString;//公司名稱
    memberclass:Integer;//承銷商--cxs
    caseclass:Integer;//案件類別--ajlb
    amount:ShortString;//金　　　　額(元)
    moneytype:integer;//幣別--bblx
    issueprice:ShortString;//發行價格
    swrq:ShortString;//收文日期
    zdbzrq:ShortString;//自動補正日期
    tzsxrq:ShortString;//停止生效日期
    jcsxrq:ShortString;//解除生效日期
    sxrq:ShortString;//生效日期
    fzcxrq:ShortString;//廢止/撤銷日期
    zxcxrq:ShortString;//自行撤回日期
    tjrq:ShortString;//退件日期
    casetype:Integer;//案件性質--ajlx
  end;
  TAryShenBaoCaseRec = array of TShenBaoCaseRec;
  TShenBaoCaseRecP = ^TShenBaoCaseRec;

  //每種金融資產特性描述
  TFRBH15Title=record
    TitleID:integer;//自動編號
    SeriesDescription:string[100];//說明，如: 60天AA非金融商業票據利率 60-Day AA Nonfinancial Commercial Paper Interest Rate�c
    AUnit: string[50];//如: 百分比Percent 
    Multiplier: string[50];//如: 1
    Currency: string[50];// 如: NA
    UniqueIdentifier: string[50];// 唯一標識符, 如: H15/H15/RIFSPPNAAD60_N.B 
    TimePeriod: string[50];// 時間週期, 如: RIFSPPNAAD60_N.B  60天AA非金融商業票據利率的"business day"
  End;

  //每種金融資產所有日期的利率
  TFRBH15 =record
    TitleID:integer;//自動編號 與TFRBH15Title關聯
    ADate:TDate;//日期
    Rate:Double;//
  End;

  //公司股利分派公告資料彙總表 
  TWeightAssignRec =record
    Code:string[10];//公司代號
    DatType:Byte;//公司名稱--替換為<適用停止過戶期間規定之公司>=0  <不適用停止過戶期間規定之公司>=1
    BelongYear:integer;//股利所屬年度
    WeightAssignDate:TDate;//權利分派基準日
    YYZZZPG:Double;//盈餘轉增資配股(元/股)
    FDYYGJ_ZBGJZZZPG:Double;//法定盈餘公積、資本公積轉增資配股(元/股)
    DivRightDate:TDate;//除權交易日
    PGZGS:Double;//配股總股數(股)
    PGZGE:Double;//配股總金額(元)
    PGZGSRate:Double;//配股總股數佔盈餘配股總股數之比例(%)
    YGHLRate:Double;//員工紅利配股率
    YYFPGDGL:Double;//盈餘分配之股東現金股利(元/股)
    FDYYGJ_ZBGJFFXJ:Double;//法定盈餘公積、資本公積發放之現金(元/股)
    DivWeigthDate:TDate;//除息交易日
    XJGLDate:TDate;//現金股利發放日
    YGGLZJE:Double;//員工紅利總金額(元)
    XJZZZGS:Double;//現金增資總股數(股)
    XJZZRate:Double;//現金增資認股比率(%)
    XJZZRGJ:Double;//現金增資認購價(元/股)
    DZFee:Double;//董監酬勞(元)
    DocDate:TDate;//公告日期
    DocTime:TTime;//公告時間
    MGME:string[50];//普通股每股面額
    Sq:byte; //區分相同代碼、權利分派基準日記錄的序號
  End;
  TWeightAssignRecP = ^TWeightAssignRec;

procedure AssignWeightAssignRec(aSrcRec:TWeightAssignRec;var aDstRec:TWeightAssignRecP);
procedure AssignWeightAssignRec2(aSrcRec:TWeightAssignRecP;var aDstRec:TWeightAssignRec);

implementation

procedure AssignWeightAssignRec(aSrcRec:TWeightAssignRec;var aDstRec:TWeightAssignRecP);
begin
  aDstRec.Code:=aSrcRec.Code;
  aDstRec.DatType:=aSrcRec.DatType;
  aDstRec.BelongYear:=aSrcRec.BelongYear;
  aDstRec.WeightAssignDate:=aSrcRec.WeightAssignDate;
  aDstRec.YYZZZPG:=aSrcRec.YYZZZPG;
  aDstRec.FDYYGJ_ZBGJZZZPG:=aSrcRec.FDYYGJ_ZBGJZZZPG;
  aDstRec.DivRightDate:=aSrcRec.DivRightDate;
  aDstRec.PGZGS:=aSrcRec.PGZGS;
  aDstRec.PGZGE:=aSrcRec.PGZGE;
  aDstRec.PGZGSRate:=aSrcRec.PGZGSRate;
  aDstRec.YGHLRate:=aSrcRec.YGHLRate;
  aDstRec.YYFPGDGL:=aSrcRec.YYFPGDGL;
  aDstRec.FDYYGJ_ZBGJFFXJ:=aSrcRec.FDYYGJ_ZBGJFFXJ;
  aDstRec.DivWeigthDate:=aSrcRec.DivWeigthDate;
  aDstRec.XJGLDate:=aSrcRec.XJGLDate;
  aDstRec.YGGLZJE:=aSrcRec.YGGLZJE;
  aDstRec.XJZZZGS:=aSrcRec.XJZZZGS;
  aDstRec.XJZZRate:=aSrcRec.XJZZRate;
  aDstRec.XJZZRGJ:=aSrcRec.XJZZRGJ;
  aDstRec.DZFee:=aSrcRec.DZFee;
  aDstRec.DocDate:=aSrcRec.DocDate;
  aDstRec.DocTime:=aSrcRec.DocTime;
  aDstRec.MGME:=aSrcRec.MGME;
  aDstRec.Sq:=aSrcRec.Sq;
end;

procedure AssignWeightAssignRec2(aSrcRec:TWeightAssignRecP;var aDstRec:TWeightAssignRec);
begin
  aDstRec.Code:=aSrcRec.Code;
  aDstRec.DatType:=aSrcRec.DatType;
  aDstRec.BelongYear:=aSrcRec.BelongYear;
  aDstRec.WeightAssignDate:=aSrcRec.WeightAssignDate;
  aDstRec.YYZZZPG:=aSrcRec.YYZZZPG;
  aDstRec.FDYYGJ_ZBGJZZZPG:=aSrcRec.FDYYGJ_ZBGJZZZPG;
  aDstRec.DivRightDate:=aSrcRec.DivRightDate;
  aDstRec.PGZGS:=aSrcRec.PGZGS;
  aDstRec.PGZGE:=aSrcRec.PGZGE;
  aDstRec.PGZGSRate:=aSrcRec.PGZGSRate;
  aDstRec.YGHLRate:=aSrcRec.YGHLRate;
  aDstRec.YYFPGDGL:=aSrcRec.YYFPGDGL;
  aDstRec.FDYYGJ_ZBGJFFXJ:=aSrcRec.FDYYGJ_ZBGJFFXJ;
  aDstRec.DivWeigthDate:=aSrcRec.DivWeigthDate;
  aDstRec.XJGLDate:=aSrcRec.XJGLDate;
  aDstRec.YGGLZJE:=aSrcRec.YGGLZJE;
  aDstRec.XJZZZGS:=aSrcRec.XJZZZGS;
  aDstRec.XJZZRate:=aSrcRec.XJZZRate;
  aDstRec.XJZZRGJ:=aSrcRec.XJZZRGJ;
  aDstRec.DZFee:=aSrcRec.DZFee;
  aDstRec.DocDate:=aSrcRec.DocDate;
  aDstRec.DocTime:=aSrcRec.DocTime;
  aDstRec.MGME:=aSrcRec.MGME;
  aDstRec.Sq:=aSrcRec.Sq;
end;



end.
