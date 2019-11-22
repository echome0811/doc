unit TDocRW;

interface
uses SysUtils,Forms,TCommon,Dialogs;

type
  //add by wangjinhua ThreeTrader 091015
  TDAILY_THREETRADER_RPT = Record
    SEC_ID          : String[8]; //֤ȯ����

    FOREIGN_BUY     : Longint	;  //���Y����Y�I
    FOREIGN_SALE    : Longint	;  //���Y����Y�u
    FOREIGN_NET     : Longint	;  //���Y����Y�Q�I

    INVEST_BUY      : Longint	;  //Ͷ���I�M�ɔ�
    INVEST_SALE     : Longint	;  //Ͷ���u�ɔ�
    INVEST_NET      : Longint	;  //Ͷ�ŜQ�I�ɔ�

    DEALER_BUY      : Longint	;  //�ԠI���I�ɔ�
    DEALER_SALE     : Longint	;  //�ԠI���u�ɔ�
    DEALER_NET      : Longint	;  //�ԠI�Q�I�ɔ�

    THREETRADER_COUTN:Longint	;  //�������I�u���ɔ�
  End;
  PDAILY_THREETRADER_RPT = ^TDAILY_THREETRADER_RPT;
  TDAILY_THREETRADER_RPTS = Array of TDAILY_THREETRADER_RPT;
  //--


  TDAILY_TRADE_RPT = Record
    SEC_ID          : String[8]; //֤ȯ����
    SEC_DEALER_ID   : String[5]; //֤ȯ��ID
    BUY_COUNT       : Cardinal;  //����ɽ���
    BUY_PRICE       : Cardinal;  //������
    SELL_COUNT      : Cardinal;  //����ɽ���
    SELL_PRICE      : Cardinal;  //������
  End;
  PDAILY_TRADE_RPT = ^TDAILY_TRADE_RPT;

  TSEC_DEALER = Record
    SEC_DEALER_ID   : String[5];  //֤ȯ��ID
    SEC_DEALER_NAME : String[50]; //֤ȯ������
  End;

  TSTOPCONV_PERIOD_DETAIL = Record
    DOC_FILENAME    : String[50]; //�����ļ�����
    START_DATE      : Double;      //��ʼ����
    END_DATE        : Double ;     //ֹͣ����
  End;

  TSTOPCONV_PERIOD_RPT= Record
    ID                 : String[6]; //֤ȯ����
    ASTOPCONV_DETAILS  : Array[0..15] of TSTOPCONV_PERIOD_DETAIL //�ڼ���ֵ
  End;

  //--DOC4.0.0��N004 huangcq090317 add  ��ء����� �ṹ����----->
  TREDEEMSALE_PERIOD_DETAIL = Record
    DOC_FILENAME    : String[50]; //�����ļ�����
    REASON          : String[50]; //ԭ��
    START_DATE      : Double;      //��ʼ����
    END_DATE        : Double ;     //ֹͣ����
    PRICE           : Double;    //�۸�
  End;

  TREDEEMSALE_PERIOD_RPT= Record
    ID              : String[6]; //֤ȯ����
    DETAILS         : Array[0..15] of TREDEEMSALE_PERIOD_DETAIL; //�ڼ���ֵ
  End;
  //<----DOC4.0.0��N004 huangcq090317 add---

 {$IFNDEF _DocRW}

  //������Ӫ�̽�������
  Function _SaveSecDealerData(aRecLst :Array of TDAILY_TRADE_RPT;aFileName:PChar):Boolean;far; external 'DocRW.dll';
  //�����Ӫ�̽�������Record��С
  Function _GetSecDealerDataCount(aFileName:PChar):Integer;far; external 'DocRW.dll';
  //���ĳ�յ������ļ�(20060404.dat)��������Ӫ�̽�������(���ڳ������c)
  Function _GetSecDealerDataAll(var aRecLst :Array of TDAILY_TRADE_RPT):Boolean;far; external 'DocRW.dll';
  //���ĳ�յ������ļ�(20060404.dat)��ĳһ֤�̶�ĳһתծ��������Ϣ(���ڳ������d)(���ڳ������e)
  Function _GetSecDealerData(var aRec :TDAILY_TRADE_RPT;aSecID,aDealerID,aFileName:PChar):Boolean;far; external 'DocRW.dll';

  //�����Ӫ��ID�������򷵻أ�����ӵ�����
  Function _GetSec_DealerID(aDealerName,aFileName :PChar):Pchar;far; external 'DocRW.dll';
  //�����Ӫ������
  Function _GetSec_DealerName(aDealerID,aFileName :PChar):PChar;far; external 'DocRW.dll';

  //�����Ӫ�̱��Record��С
  Function _GetSec_DealerIndexCount(aFileName:PChar):Integer;far; external 'DocRW.dll';
  //������е���Ӫ�̱������
  Function _GetSec_DealerIndexAll(var aRecLst :Array of TSEC_DEALER):Boolean;far; external 'DocRW.dll';

  //����ֹͣת���ڼ����ϵ�ĳת�����������ļ�(StopConv.dat)��
  Function _SaveSecStopConvFile(aRecLst:Array of TSTOPCONV_PERIOD_RPT;aFileName :PChar):Boolean;far; external 'DocRW.dll';
  //���ĳת�����������ļ�(StopConv.dat)��ֹͣת���ڼ�����Record��С
  Function _GetSecStopConvDataCount(aFileName:PChar):Integer;far; external 'DocRW.dll';
  //���ĳת�����������ļ�(StopConv.dat)��ȫ����ֹͣת���ڼ�����
  Function _GetStopConvDataAll(var aRecLst :Array of TSTOPCONV_PERIOD_RPT):Boolean;far; external 'DocRW.dll';
  //���ĳת�����������ļ�(StopConv.dat)��ĳһתծID��ֹͣת���ڼ�����
  Function _GetStopConvData(var aRec :TSTOPCONV_PERIOD_RPT;aSecID,aFileName:PChar):Boolean;far; external 'DocRW.dll';

  //--DOC4.0.0��N004 huangcq090317 add ---->
   //�����ء����������ļ�(CBRedeemDate.dat\CBSaleDate.dat)������ID�ĸ���
  Function _GetSecRedeemSaleDataCount(aFileName:PChar):Integer;far; external 'DocRW.dll';
   //�����ء����������ļ�(CBRedeemDate.dat\CBSaleDate.dat)��ȫ��������
  Function _GetRedeemSaleDataAll(var aRecLst :Array of TREDEEMSALE_PERIOD_RPT):Boolean;far; external 'DocRW.dll';
   //�����ء����������ļ�(CBRedeemDate.dat\CBSaleDate.dat)��ĳID������
  Function _GetRedeemSaleData(var aRec :TREDEEMSALE_PERIOD_RPT;aSecID,aFileName:PChar):Boolean;far; external 'DocRW.dll';
  //<---DOC4.0.0��N004 huangcq090317 add---  

  //���֤ȯ�����Ϣ
  Function _GetSecID(aFileName,aSecName :PChar):Pchar;far; external 'DocRW.dll';
  Function _GetSecName(aFileName,aSecID :PChar):Pchar;far; external 'DocRW.dll';

  //������Ϣ����
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
