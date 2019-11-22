unit TDeclar;

interface


Type
   _ValueLst1 = Array of Double; //[����]
   _ValueLst2 = Array of Array of Double; //[����][��λ]
   _ValueLst3 = Array of Array of Array of Double; //[����][����][��λ]
   _HDaysLst4 = Array[0..3] of Double; //[��������]
   _DateLst   = Array of Double;
   _StringLst = Array of ShortString;

  TFAStock = Packed Record //��Ʊ
     StockID   :String[7];
     Vocation  :String[20];
     Exg       :String[2];
     Cls       :String[2];
     Tid       :String[2];
     Kid       :String[3];
     Gid       :String[2];
     StockName :String[14];
     KidName   :String[30];
     GidName   :String[20];
     ExgName   :String[10];
  End;
  TFStocks = Array of TFAStock;

  TFAKCL=Packed Record
      KID : String[3];
      KNA : String[50];
      GID : String[3];
  End;
  TFKcls = Array of TFAKCL;

  TFAGCL=Packed Record
      GID : String[3];
      GNA : String[50];
  End;
  TFGcls = Array of TFAGCL;

  TFATax = Packed Record //���׳ɱ�
     ABTax1,ABTax2 : Double;     //ӡ��˰,Ӷ��(AB��)
     FundTax1,FundTax2 : Double; //ӡ��˰,Ӷ��(����)
     PATax1,PATax2 : Double;     //���ַ�,Ӷ���ծ�ֻ�)
  End;

  TFARate = Packed Record
    USA,HK : Double;
  End;



Const
  ERR_NOT_FILE = -1;
  ERR_NOT_DATE = -2;
  ERR_NOT_STK  = -3; //�����ڹ�Ʊ

Const
  E_OK = 0;
  E_INPUT_ERROR = -2;
  E_NONE_DEFAULT = -1;
  E_NONE_USERON  = -1003;
  E_BASEDB_DATE  = -4;   //�������ݸ���
  E_ERROR_DLL    = -5;
  E_NOTHAVE_DATE = -6;  //�޴˽�����
  E_ERROR_PATH   = -7;  //·������
  E_ERROR_STK    = -8;  //��Ʊ����������ʽ
  E_ERROR_DATE   = -9;  //���ڸ�ʽ�������
  E_ERROR_PARAM_TurnOver_Days  = -12; //�����������
  E_EXCEL_STOP   = -13; //������ֹ

Const
  NoneNum     = -999999999;
  ValueEmpty  = -888888888;
  BetaPower   = 6;
  VEPower     = 6;
  ROIPower    = 6;
  ERTPower    = 6;
  CovPower    = 6;
  WeightPower = 3; //ȨϢֵ
  CPricePower = 3; //���̼�

Const

  S_Exg_SHA   = '01'; //������
  S_Exg_SZN   = '02';

  S_TYPE_INDEX ='01'; //��Ʊ���
  S_TYPE_STOCK ='02'; //����

  S_CLS_INDEX ='01'; //��Ʊ���
  S_CLS_A     ='02';
  S_CLS_B     ='03';
  S_CLS_C     ='04';//ծȯ
  S_CLS_FUND  ='05';
  S_CLS_OTH   ='06';


Function Dec_Std(v:Double):Double; //��׼�ȷ��
Function Dec_Bdd(v:Double):Double; //�����ɾ�ȷ��
Function Dec_PE(v:Double):Double;
Function Dec_PB(v:Double):Double;
Function Dec_TurnOver(v:Double):Double;

function IsNoneOrEmpty(const Data:Double):Boolean;
function CEmptyToNone(const Data:Double):Double;

implementation
  Uses Math,Tcommon;

function CEmptyToNone(const Data:Double):Double;
Begin
    Result := Data;
    if IsNoneOrEmpty(Data) Then
       Result:=NoneNum;
End;

function IsNoneOrEmpty(const Data:Double):Boolean;
Begin
   Result := (Data=NoneNum) or (Data=ValueEmpty)
end;

Function Dec_TurnOver(v:Double):Double;
Var
  DecPower : Double;
Begin
   if v=NoneNum Then
   Begin
       Result := NoneNum;
       Exit;
   End;
   DecPower := Power(10,4);
   result:=Round2(v*DecPower)/DecPower;
End;

Function Dec_PE(v:Double):Double;
Var
  DecPower : Double;
Begin
   if v=NoneNum Then
   Begin
       Result := NoneNum;
       Exit;
   End;
   DecPower := Power(10,4);
   result:=Round2(v*DecPower)/DecPower;
End;

Function Dec_PB(v:Double):Double;
Var
  DecPower : Double;
Begin
   if v=NoneNum Then
   Begin
       Result := NoneNum;
       Exit;
   End;
   DecPower := Power(10,4);
   result:=Round2(v*DecPower)/DecPower;
End;

Function Dec_Std(v:Double):Double;
Var
  DecPower : Double;
Begin
   if v=NoneNum Then
   Begin
       Result := NoneNum;
       Exit;
   End;
   DecPower := Power(10,4);
   result:=Round2(v*DecPower)/DecPower;
End;


Function Dec_Bdd(v:Double):Double;
Var
  DecPower : Double;
Begin
   if v=NoneNum Then
   Begin
       Result := NoneNum;
       Exit;
   End;
   DecPower := Power(10,4);
   result:=Round2(v*DecPower)/DecPower;
End;


end.
