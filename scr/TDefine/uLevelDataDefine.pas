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
  _ZCFZB='1';//�겣�t�Ū�
  _ZZSYB2='7';
  _ZZSYB='2';//��X�l�q��
  _XJLLB='3';//�{���y�q��
  _ZCFZBStr='�겣�t�Ū�';
  _ZZSYBStr='��X�l�q��';
  _XJLLBStr='�{���y�q��';
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

  //���ثH��
  TPLevelRec=packed record
    Comp:string[100];//���q����
    //Date:shortstring;//���
    LongLevel:string[10];//�H�ε�������
    ShortLevel:string[10]; //�H�ε����u��
    LookLevel:string[10];//�����i��
    PClass:string[100];//���~�O����ƬO�_�n�[�J�즹�B�A�]���������}�S������ơA�����B����ƬO�q�L��u���J��
  end;
  TAryPLevelRec = array of TPLevelRec;

  TCodeClass=packed record
    Code:string[10];
    PClass:string[100];//�W���O
    CompClass:string[30];//���~�O
    TEJ:string[60];//���~�p��
  end;
  PCodeClass = ^TCodeClass;

  TStkIndustry=packed record
    Code:string[10];//�Ѳ��N�X
    CYB:string[100];//���~���O
    SZXYou:string[100];//�W���U��
    DLB:string[100];//�j��
    ZLB:string[100];//�l��
    MktClass:string[100];//�����O
  end;
  TStkIndustryP = ^TStkIndustry;
  TAryStkIndustry = array of TStkIndustry;
  
  TStkIndustryRec=packed record
    Code:string[10];//�Ѳ��N�X
    ComClassCode:integer;
  end;
  TAryStkIndustryRec = array of TStkIndustryRec;
  
  TStkIndustryRecP = ^TStkIndustryRec;
  TStkIndustryRec2=packed record
    Code:string[10];//�Ѳ��N�X
    AryComClassCode: array of integer;
    Flag:string[2];
  end;
  TStkIndustryRec2P = ^TStkIndustryRec2;
  TAryStkIndustryRec2 = array of TStkIndustryRec2;

  TStkBase1=packed record
    Code:string[10];//�Ѳ��N�X
    MktClass:string[100];//�����O
    CYB:string[100];//���~���O
  end;
  TStkBase1P = ^TStkBase1;
  TAryStkBase1 = array of TStkBase1; 
  TStkBase1Rec=packed record
    Code:string[10];//�Ѳ��N�X
    ComCodeMktClass:integer;
    ComCodeCYB:integer;
  end;
  TStkBase1RecP = ^TStkBase1Rec;
  TAryStkBase1Rec = array of TStkBase1Rec;


  TTCRIRec=packed record
    Code:string[10];
    //����TCRI����
    NowLevel:string[5];
    //�e��TCRI����
    //PreLeve:string[10];
    //�]���̾�_�~/��
    BaseReportDate:string[12];
    //������
    PDate:string[12];
    //TCRI���Ų��ʻ����]�N�䤤���^������H�r��#13#10�s�x�^
    Des: array [0..1024] of Char;
    MktC:string[15];//�W���O
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

//���~�O
TClassRec=record
  CompCode:string[10];//���q�N��
  CompFullName:string[50];//���q����
  Address:string[50];//�a�}
  BinNo:string[15];//��Q�Ʒ~�Τ@�s��
  DSZ:string[10];//���ƪ�
  ZJL:string[10];//�`�g�z
  Sayer:string[10];//�o���H
  SayerInstitute:string[20];//�o���H¾��
  SayerAgent:string[20];//�N�z�o���H
  TopTel:string[20];//�`���q��
  StartDate:string[10];//���ߤ��
  MarketDate:string[10];//�W�����
  PerAmount:string[20];//���q�ѨC�ѭ��B
  FactAccount:string[20];//�ꦬ�ꥻ�B(��)
  IssueCount:string[20];//�w�o�洶�q�ѼƩ�TDR��o��Ѽ�
  PrivateCount:string[20];//�p�Ҵ��q��(��)
  SpecialCount:string[20];//�S�O��(��)
  RptType:string[20];//�s�s�]�ȳ��i����
  TranferInstitute:string[50];//�Ѳ��L����c
  TranferTel:string[20];//�L��q��
  TranferAddress:string[50];//�L��a�}  
  VisaInstitute:string[50];//ñ�ҷ|�p�v�ưȩ�
  VisaPerson1:string[10];//ñ�ҷ|�p�v1
  VisaPerson2:string[10];//ñ�ҷ|�p�v2
  EngCode:string[20];//�^��²��
  EngAddress:string[80];//�^��q�T�a�}
  Fax:string[20];//�ǯu�����X
  EMail:string[50];//�q�l�l��H�c
  WebAddress:string[80];//���}
  GXRWebAddress:string[150];//���}
end;
TAryClassRec = array of TClassRec;
PClassRec = ^TClassRec;

//���~�O
TEPSRec=record
  Year: integer;
  Quarter: integer;
  CompCode:string[10];//���q�N��
  YYSR:Double;//��~���J
  YYCB:Double;//��~����
  YYMLMS:Double;//��~��Q(��l)
  YSGSJWSXLY:Double;//�p�ݤ��q������{�Q�q
  YSGSJYSXLY:Double;//�p�ݤ��q���w��{�Q�q
  YYFY:Double;//��~�O��
  YYJLJS:Double;//��~��Q(��l)
  YYWSRJLY:Double;//��~�~���J�ΧQ�q
  YYWFYJSS:Double;//��~�~�O�Τηl��
  JXYYDWSQJLJS:Double;//�~����~���|�e��Q(��l)
  SDSFYLY:Double;//�ұo�|(�O��)�Q�q
  JXYYDWJLJS:Double;//�~����~�����Q(��l)
  TYDWSY:Double;//���~���l�q
  FYSY:Double;//�D�`�l�q
  KJYZBDLJYXS:Double;//�|�p��h�ܰʲ֭p�v�T��
  BQJLJS:Double;//������Q(��l)
  MGYY:Double;//�򥻨C�ѬէE
end;
TAryEPSRec = array of TEPSRec;
PEPSRec = ^TEPSRec;


//���~�O
TBorrowMoneyRec=record
  Year: Byte;        //�~
  Month: Byte;       //��
  CompCode:string[10];//���q�N�X
  BorrowBank:string[100];//�ɴڻȦ�
  BorrowType:Byte;       //���u���ɴڡ]�ɴں����^
  BorrowAmount:Double;   //�ɴڪ��B�]�O���d���^�ӵ���ƪ��U�ڪ��B
  BorrowCurrency:Byte;   //�ɴڭ���O
  BorrowInitAmount:Double;//�ɴڭ����(�d��)
  BorrowSDate:TDate;      //�ɴڴ���(�_)
  BorrowEDate:TDate;      //�ɴڴ���(�_)
  BorrowDuration:Double;//����
  RateType:Byte;//�Q�v�O		���B�ʡB�ܰʤΩT�w�Q�v�T��
  LowRate:double;//�̧C�Q�v	  
  HighRate:double;//�̰��Q�v	  
  RateRemark:string[200];//�Q�v����
  GuaranteeType:Byte;//��O�O		���L���or��O�~
  GuaranteeRemark:string[200];//��O�~����
  SyndicatedLoan:Byte;//�p�U�]Y/N�^		�O�_���Ȧ��p�U
  FinancingAmount:double;//�ĸ��B��	�d��	�ӵ���ƪ��ĸ��B��
  FinancingType:Byte;//�ĸ���O		�ĸ��B�ת����O

end;
TBorrowMoneyAry= array of TBorrowMoneyRec;
PBorrowMoneyRec = ^TBorrowMoneyRec;



//------------IFRS
{TIFRSTopNodeRec=record
  Idx:integer;//���ާǸ�
  Level:byte;//�h��
  ParentNodeIdx:integer;//���`�I�ާǸ�
  Name:string[50];//�W��
  ListNo:integer;//��ܮɪ����Ǹ�
  TblType:char;//���ݼƾڪ� 1=�겣�t�Ū� 2=��X�l�q�� 3=�{���y�q��
end;

TIFRSNodeRec=record
  Idx:integer;//���ާǸ�
  ParentNodeIdx:integer;//���`�I�ާǸ�
  Name:string[120];//�W��
  ListNo:integer;//��ܮɪ����Ǹ�
  TblType:char;//���ݼƾڪ� 1=�겣�t�Ū� 2=��X�l�q�� 3=�{���y�q��
end;}

TIFRSColRec=record
    Idx:integer;//���ާǸ�
    ParentNodeIdx:integer;//���`�I�ާǸ�
    Name:string[130];//�W��
    ListNo:integer;//��ܮɪ����Ǹ�
    TblType:char;//���ݼƾڪ� 1=�겣�t�Ū� 2=��X�l�q�� 3=�{���y�q��
    Kong:Byte;
  end;

TIFRSDatRec=record
    Year:Word;
    Q:Byte;
    Tbl:Byte;
    CompCode:string[4];//�N�X
    NumAry:array[0.._IFRSDatColSize] of Double;//�|�p���B
    IdxAry:array[0.._IFRSDatColSize] of Smallint;//�|�p���د���
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
    code:ShortString;//�Ҩ�N��
    mkt:integer;//���q���A--gsxt
    closetype:Integer;//��������--jalx
    stkname:ShortString;//���q�W��
    memberclass:Integer;//�ӾP��--cxs
    caseclass:Integer;//�ץ����O--ajlb
    amount:ShortString;//���@�@�@�@�B(��)
    moneytype:integer;//���O--bblx
    issueprice:ShortString;//�o�����
    swrq:ShortString;//������
    zdbzrq:ShortString;//�۰ʸɥ����
    tzsxrq:ShortString;//����ͮĤ��
    jcsxrq:ShortString;//�Ѱ��ͮĤ��
    sxrq:ShortString;//�ͮĤ��
    fzcxrq:ShortString;//�o��/�M�P���
    zxcxrq:ShortString;//�ۦ�M�^���
    tjrq:ShortString;//�h����
    casetype:Integer;//�ץ�ʽ�--ajlx
  end;
  TAryShenBaoCaseRec = array of TShenBaoCaseRec;
  TShenBaoCaseRecP = ^TShenBaoCaseRec;

  //�C�ت��ĸ겣�S�ʴy�z
  TFRBH15Title=record
    TitleID:integer;//�۰ʽs��
    SeriesDescription:string[100];//�����A�p: 60��AA�D���İӷ~���ڧQ�v 60-Day AA Nonfinancial Commercial Paper Interest Rate�c
    AUnit: string[50];//�p: �ʤ���Percent 
    Multiplier: string[50];//�p: 1
    Currency: string[50];// �p: NA
    UniqueIdentifier: string[50];// �ߤ@���Ѳ�, �p: H15/H15/RIFSPPNAAD60_N.B 
    TimePeriod: string[50];// �ɶ��g��, �p: RIFSPPNAAD60_N.B  60��AA�D���İӷ~���ڧQ�v��"business day"
  End;

  //�C�ت��ĸ겣�Ҧ�������Q�v
  TFRBH15 =record
    TitleID:integer;//�۰ʽs�� �PTFRBH15Title���p
    ADate:TDate;//���
    Rate:Double;//
  End;

  //���q�ѧQ�������i��ƷJ�`�� 
  TWeightAssignRec =record
    Code:string[10];//���q�N��
    DatType:Byte;//���q�W��--������<�A�ΰ���L������W�w�����q>=0  <���A�ΰ���L������W�w�����q>=1
    BelongYear:integer;//�ѧQ���ݦ~��
    WeightAssignDate:TDate;//�v�Q������Ǥ�
    YYZZZPG:Double;//�վl��W��t��(��/��)
    FDYYGJ_ZBGJZZZPG:Double;//�k�w�վl���n�B�ꥻ���n��W��t��(��/��)
    DivRightDate:TDate;//���v�����
    PGZGS:Double;//�t���`�Ѽ�(��)
    PGZGE:Double;//�t���`���B(��)
    PGZGSRate:Double;//�t���`�ѼƦ��վl�t���`�ѼƤ����(%)
    YGHLRate:Double;//���u���Q�t�Ѳv
    YYFPGDGL:Double;//�վl���t���ѪF�{���ѧQ(��/��)
    FDYYGJ_ZBGJFFXJ:Double;//�k�w�վl���n�B�ꥻ���n�o�񤧲{��(��/��)
    DivWeigthDate:TDate;//���������
    XJGLDate:TDate;//�{���ѧQ�o���
    YGGLZJE:Double;//���u���Q�`���B(��)
    XJZZZGS:Double;//�{���W���`�Ѽ�(��)
    XJZZRate:Double;//�{���W��{�Ѥ�v(%)
    XJZZRGJ:Double;//�{���W��{�ʻ�(��/��)
    DZFee:Double;//���ʹS��(��)
    DocDate:TDate;//���i���
    DocTime:TTime;//���i�ɶ�
    MGME:string[50];//���q�ѨC�ѭ��B
    Sq:byte; //�Ϥ��ۦP�N�X�B�v�Q������Ǥ�O�����Ǹ�
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
