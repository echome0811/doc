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

  _GongZhaiZhiRateCaption='���ŴާQ�v���u';
  _GongZhaiZhiShuRiBaoBiaoCaption='[�O�W���ū���]�����';

  _GongZhaiBasicCaption='�Ũ�򥻸��';
  _GongZhaiHangqingCaption='�Ũ�污';

  _Manner14Caption='�t���ާQ�v';
  _Maner0RateCaption='�s���ާQ�v';
  _Manner2Caption='(��)�ާQ�v/�ʤ���(�t��ڶ�)';
  _Manner3Caption='���ū��Ƽ˥�';//'[�O�W���ū���]��������Ƽ˥�';
  _Manner5Caption='���ū���';//'[�O�W���ū���]������������Ƽ˥�';
  _Manner6Caption='���q�ŰѦҧQ�v';

  _SwapOptionCaption='����v�污';
  _SwapYieldCaption='�T�w���q�污';

  _ArySubIndex:array[0..3] of ShortString=(
    '�[�v���������Q�v',
    '�[�v�����������',
    '�[�v�����ާQ�v',
    '�[�v�����s�����');
    
type

TCheckStatus=(chkNone,chkOK,chkDel,chkEsc);

TManner14Rec =  record          //��ʽһ����
  BondCode : String[10];  //����
  Rate : Double;         //ֳ������������
  ResidualYear:Double;   //ʣ������
End;
TManner14RecLst = Array of TManner14Rec;

TOne0RateRec =  record          //��Ϣֳ����
  Long :Double;  //�ڼ�
  LongType : byte; //�ڼ�����0=�� 1=��
  CubicBSpline:Double;   //Cubic B-Spline��Ϣ����
  Svensson:Double;   //Svensson��Ϣ����
End;
T0RateRec =  record          //��Ϣֳ����
  Adate : Tdate;
  Recs:array[0..61] of TOne0RateRec;
End;
T0RateRecLst = Array of T0RateRec;

TManner2Rec =  record            //��ʽ��
  BondCode : String[10];  //����
  Name : String[20];    //����
  Currency : String[5];   //�ұ�
  MaturityDate : String[10];   //������
  Duration : Double;     //�����ڼ�
  CouponRate : Double;   //Ʊ������
  CouponCompondFrequency : String[5]; //ÿ�긶\��Ϣ������
  VolumeWeightedAverageYield : Double;  //��Ȩƽ��ֳ����
  VolumeWeightedAveragePrice : Double;  //��Ȩƽ����Ԫ��
  LastTradeDate : String[10];   //����ɽ���
End;
TManner2RecLst = Array of TManner2Rec;

TManner3Rec =  record             //��ʽ��
  BondCode : String[10];  //����
  PricewithoutaccuredInterest : Double;   //��Ϣ��
  PriceSource : integer;   //�۸���Դ��
  AccuredInterest : Double;  //Ӧ��Ϣ
  Yieldtomaturity: Double;  //ֳ����
  Outstanding:Double;  //��ȯ�N�~
  SubIndex : String[2];   //����ָ����
End;
TManner3RecLst = Array of TManner3Rec;

TManner5Rec =  record           //��ʽ��
  Subtype : ShortString;    //ָ������
  Yearsall : Double;      //ȫ����ָ��
  years1to3 : Double;     //1-3�����ָ��
  years3to5 : Double;     //3-5�����ָ��
  years5to7 : Double;     //5-7�����ָ��
  years7to10 : Double;    //7-10�����ָ��
  years10 : Double;       //10�����Ϸ���ָ��
End;
TManner5RecLst = Array of TManner5Rec;

TTimeDataRec=record
  Time:Double;
  Data:Double;
end;


TManner6BCRec=record
  CBLevel : ShortString;    //��˾ծ�ȼ�
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
TManner6Rec =  record           //��ʽ��  ��˾ծ�ο�����
  Adate : Tdate;
  BCRecs:array[0..3] of TManner6BCRec;
End;
  TManner6RecLst = Array of TManner6Rec;

TSwapCBRec=record
  Adate : Tdate;
  BondCode : String[10];  //�˵��Cȯ��̖
  BondName : String[15];  //���Q
  NominalA: Double;   //��Ŀ����(Ԫ)
  Volume : Double;   //�ɽ��P��
  H : Double;  //���
  L: Double;   //���
  Agv:Double;  //ƽ��
  Y:Double;   //���s���g���꣩��
end;
TSwapCBRecP = ^TSwapCBRec;
TSwapCBRecLst = Array of TSwapCBRec;

TSwapCBCountRec=record
  BondCode : String[10];  //�˵��Cȯ��̖
  BondName : String[15];  //���Q
  NominalA: Double;   //��Ŀ����(Ԫ)
  Volume : Double;   //�ɽ��P��
end;
TSwapCBCountRecP = ^TSwapCBCountRec;

TBCNameTblRec =  record         //���������
  BondCode : String[10];  //����
  Name : String[20];    //����
  Currency : String[5];   //�ұ�
  MaturityDate : Tdate;   //������
  CouponRate : Double;   //Ʊ������
  //Outstanding : Double;  //��ȯ�N�~
  //Coupon : integer;   //ÿ�긶
  //CompondFrequency : integer; //��Ϣ������
  CompondFrequency : integer; //ÿ�긶/��Ϣ����    1:1/1 ��2:1/2 �� 3:2/2 �� 4:1/4 ��5:2/4 ��6:4/4 �� 7:1/12 ��8:12/12;
End;
TBCNameTblRecP=^TBCNameTblRec;
TBCNameTblRecLst = Array of TBCNameTblRec;

  TTYC = record
    BondCode : String[10];  //����
    Rate : Double;          //ֳ������������
    ResidualYear : Double;  //ʣ������
  End;
TTYCRec =  record          //����ֳ������������
  Adate : tDate;      //����
  TYC : Array[0..3] of TTYC;
End;
TTYCRecP=^TTYCRec;
TTYCRecLst = Array of TTYCRec;

  TsubIndex = record
    Yearsall : Double;      //ȫ����ָ��
    years1to3 : Double;     //1-3�����ָ��
    years3to5 : Double;     //3-5�����ָ��
    years5to7 : Double;     //5-7�����ָ��
    years7to10 : Double;    //7-10�����ָ��
    years10 : Double;       //10�����Ϸ���ָ��
  End;
TSubIndexRec = record       //����ָ������
  Adate : Tdate;        //����
  subIndex : Array[0..3] of TsubIndex;
End;
TSubIndexRecLst = Array of TSubIndexRec;

TIRIDRec = record         //�����ڲ�����
  Adate : Tdate;     //����
//  BondCode : String[10];  //����
  Duration : Double;     //�����ڼ�
  VolumeWeightedAverageYield : Double;  //��Ȩƽ��ֳ����
  VolumeWeightedAveragePrice : Double;  //��Ȩƽ����Ԫ��
  LastTradeDate : Tdate;   //����ɽ���
  PricewithoutaccuredInterest : Double;   //��Ϣ��
  PriceSource : integer;   //�۸���Դ
  AccuredInterest : Double;  //Ӧ��Ϣ
  Yieldtomaturity: Double;  //ֳ����
  Outstanding : Double;  //��ȯ�N�~
  SubIndex : String[2];   //����ָ����
End;
TIRIDRecLst = Array of TIRIDRec;

////////////////////////////////////////////////////////////

TIRRec = Record
  BondCode : String[20];  //����
  Rate : Double;          //ֳ������������
  ResidualYear : Double;  //ʣ������

  // Code : String[20];                     //����
  Name : String[30];                     //����
  MaturityDate : TDate;              //������
  VolumeWeightedAverageYield : Double;   //��Ȩƽ��ֳ����
  LastTradeDate : TDate;             //����ɽ���

  // Code : String[20];           //����
  //Name : String[30];           //����
  Yieldtomaturity : Double;    //ֳ����
  Yearstomaturity : Double;    //�ൽ��
end;
TIRRecLST = Array of TIRRec ;

TIR2Rec = Record
  years1to3 : Double;     //1-3�����ָ��
  years3to5 : Double;     //3-5�����ָ��
  years5to7 : Double;     //5-7�����ָ��
  years7to10 : Double;    //7-10�����ָ��
  years10 : Double;       //10�����Ϸ���ָ��
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
