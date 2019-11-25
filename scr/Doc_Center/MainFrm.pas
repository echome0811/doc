///////////////////////////////////////////////////////////////////////////////////////////
////CBDatEdit-DOC3.0.0ª›®D2-leon-08/8/18-add;(≠◊ßÔCBDatEdit™∫°ß∞±§Ó¬‡¥´¥¡∂°°®™∫•NΩX¶b¨dß‰§ΩßiÆ…™∫πÔ¿≥•NΩX¨dß‰≈ﬁøË°A±N≠Ï•ª™∫™Ω±µßR¥Ó°A≈‹¶®¨d∏ﬂtr1db§§™∫txt§Â•Û)
//---Doc3.2.0ª›®D1 huangcq080923 ≠◊ßÔ°G¿Ú®˙market_db\pulish_db•ÿø˝§U™∫txt§Â•Û
//--Doc3.2.0ª›®D3 huangcq080928 §‚∞ ø˝§J§Ωßi°G•ªµ{ß«≥B≤z´»§·∫›(§Ωßiø˝§J∫›)ø˝§Jº∆æ⁄™∫¶s®˙
//--DOC4.0.0°XN001 huangcq090407 add DocªPWarningCenteræ„¶X
//--DOC4.0.0°XN002 huangcq081223 ≠◊ßÔ§W∂«¶®•\©Œ™Ã•¢±—™∫¥£•‹
//--Doc4.0°XN004 huangcq090317  ≈´¶^§È¥¡°BΩÊ¶^§È¥¡ ¿Ú®˙tradeCode&stockCode
//////////////////////////////////////////////////////////////////////////////////////////

unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls,  IdComponent, IdTCPServer,TDocMgr,TCommon, StdCtrls,
  ComCtrls, ImgList, IniFiles, CsDef,IdBaseComponent,ShellAPI,
  TZipCompress, dxTL, dxCntner, SocketSvrFrm, SocketClientFrm, TSocketClasses,
  IdAntiFreezeBase, IdAntiFreeze, IdTCPConnection, IdTCPClient, Dialogs,
  ComObj, Menus,uFuncFileCodeDecode,zlib,
  uLevelDataDefine,uLevelDataFun,DateUtils,
  uCBDataTokenMng,uLogHandleThread,uForUserMoudule,uThreeTraderPro,
  uForCBOpCom,uCBPARateData,uFuncThread,uSetWorkForIFRSFrm,
  uShenBaoCasePro; //TWarningServer,FastStrings
const
//-----------------------
  _CBDBUplFile='cbdb.upl';
  _LogSep=';sep;';
  _LogSecBegin='<LogSec>';
  _LogSecEnd='</LogSec>';
  _ModouleEnALL='all';
  _OpCurBegin='<OpCur>';
  _OpCurEnd='</OpCur>';
  _CmdParamSecBegin='<CmdParams>';
  _CmdParamSecEnd='</CmdParams>';

_NodeM='nodem';
_NodeMCaption='πù¸c≤Ÿ◊˜';

_ThreeTraderM='threetraderm';
_ThreeTraderMCaption='»˝¥Û∑®»À';
_PBankLevelM='plevelbankm';
_PBankLevelMCaption='„y–––≈‘u';
_TCRIM='tcrim';
_TCRIMCaption='tcri';
_IndustryM='industrym';
_IndustryMCaption='ÆaòIÊú';
_StkBase1M='stkbase1m';
_StkBase1MCaption='ÆaòIÓêÑe';
_cbbaseinfoM='cbbaseinfom';
_cbbaseinfoMCaption='ª˘±æŸY¡œ';
_CBBalanceM='cbbalancem';
_CBBalanceMCaption='NÓ~ŸY¡œ';
_PaoMaM='paomam';
_PaoMaMCaption='≈‹ÒRüÙ';
_TodayHintM='todayhinitm';
_TodayHintMCaption='Ωª“◊Ã· æ';
_IRRateM='irratem';
_IRRateMCaption='π´Ç˘¿˚¬ ';
_CBSwapM='cbswapm';
_CBSwapMCaption='ŸYÆaΩªìQ';
_EcbRateM='ecbratem';
_EcbRateMCaption='√¿ΩÖR¬ ¿˚¬ ŸY¡œæS◊o';
_stockweightM='stockweightm';
_stockweightMCaption='π…¿˚∑÷≈‰ŸY¡œæS◊o';

  _OpSave='Save';
  _OpUptAndSave='UptAndSave';
  _OpImportExcel='ImportExcel';
  _OpUptReason='UptReason';
  _OpUpt='Upt';
  _OpAdd='Add';
  _OpMove='Mov';
  _OpUptSub='UptSub';
  _OpAddSub='AddSub';
  _OpDelSub='DelSub';
  _OpCBAdd='CBAdd';
  _OpMdfStk='MdfStk';
  _OpMdfCB='MdfCB';
  _OpMdfCBIssue1='MdfCBIssue1';
  _OpMdfCBIssue2='MdfCBIssue2';
  _OpMdfCBIssue3='MdfCBIssue3';
  _OpMdfCBIssue4='MdfCBIssue4';
  _OpMdfCBIssue5='MdfCBIssue5';
  _OpMdfCBIssue6='MdfCBIssue6';
  _OpMdfCBIssue7='MdfCBIssue7';
  _OpNodeUpload='NodeUpload';
  _OpDataOp='DataOp';
  _OpDel='Del';
  _OpDelCB='DelCB';
  _OpReBack='ReBack';
  _OpAutoAudit='AutoAudit';
  _OpManulAudit='ManulAudit';
  _OpSaveStr='´O¶s';
  _OpUptAndSaveStr='ßÛ∑s¶}´O¶s';
  _OpImportExcelStr='æ…§Jexcel';
  _OpUptReasonStr='≠◊ßÔ≥]©w∂µ';
  _OpUptStr='≠◊ßÔ';
  _OpAddStr='∑sºW';
  _OpDelStr='ßR∞£';
  _OpReBackStr='¥_≠ÏßR∞£';
  _OpAutoAuditStr='¶€∞ ºfÆ÷';
  _OpManulAuditStr='§H§uºfÆ÷';
  _OpUptSubStr='≠◊ßÔ§l∂µ';
  _OpAddSubStr='∑sºW§l∂µ';
  _OpDelSubStr='ßR∞£§l∂µ';
  _OpCBAddStr='∏`¬I∑sºW';
  _OpMoveStr='∏`¬I≤æ∞ ';
  _OpMdfStkStr='≈‹∞ ™—≤º•NΩX';
  _OpMdfCBStr='≈‹∞ ¬‡∂≈•NΩX';
  _OpMdfCBIssue1Str='∫˚≈@∞Ú•ª∏ÍÆ∆';
  _OpMdfCBIssue2Str='∫˚≈@≤º≠±ßQ≤v';
  _OpMdfCBIssue3Str='∫˚≈@≈´¶^±¯¥⁄';
  _OpMdfCBIssue4Str='∫˚≈@≠◊•ø±¯¥⁄';
  _OpMdfCBIssue5Str='∫˚≈@©w¬I≠◊•ø';
  _OpMdfCBIssue6Str='∫˚≈@ΩÊ¶^±¯¥⁄';
  _OpMdfCBIssue7Str='∫˚≈@©w¬IΩÊ¶^';
  
  _OpDelCBStr='ßR∞£¬‡∂≈∏`¬I';
  _OpNodeUploadStr='∏`¬I§W∂«';
  _OpDataOpStr='∏ÍÆ∆∫˚≈@';
  _OpUploadStr='§W∂«';


  _UploadDoneStr='§w§W∂«';
  _UploadUnDoneStr='•ºßπ¶®§W∂«';
  _SepItem='°A';
  _SepItem2='  ';
  _ListItem='°n';

  _CancelDocTag='calcel';
  _DocDoneTag='done';
  _DocNoNeedDoTag='noneeddo';
  _DocUnDoTag='undo';

  Echo_HELLO='HELLO';
  _RplTr1DBPath='%Tr1DBPath%';
  _RplDateTime='%DateTime%';
  TcpIpPerSize = 4096;
  Cmd_RcvFile='Cmd_RcvFile';

  _Manner14Caption='ßtÆß¥ﬁßQ≤v';
  _Maner0RateCaption='πsÆß¥ﬁßQ≤v';
  _Manner2Caption='(¿Á)¥ﬁßQ≤v/¶ §∏ª˘(ßt∞Íª⁄∂≈)';
  _Manner3Caption='§Ω∂≈´¸º∆ºÀ•ª';//'[ªO∆W§Ω∂≈´¸º∆]§È≥¯™Ì§ß´¸º∆ºÀ•ª';
  _Manner5Caption='§Ω∂≈´¸º∆';//'[ªO∆W§Ω∂≈´¸º∆]§È≥¯™Ì§ß§¿√˛´¸º∆ºÀ•ª';
  _Manner6Caption='§Ω•q∂≈∞—¶“ßQ≤v';

  _SwapOptionCaption='øÔæ‹≈v¶Ê±°';
  _SwapYieldCaption='©T©w¶¨Øq¶Ê±°';
  
type
  TTrancLogRec = packed record
    Dats:array[0..5] of string;
  end;
  TTrancLogRecs = Array of TTrancLogRec;
  
  TTCRIRec=packed record
    Code:string[10];
    //•ª¥¡TCRIµ•Ø≈
    NowLevel:string[5];
    //´e¥¡TCRIµ•Ø≈
    //PreLeve:string[10];
    //∞]≥¯®Ãæ⁄_¶~/§Î
    BaseReportDate:string[12];
    //µ˚µ•§È
    PDate:string[12];
    //TCRIµ•Ø≈≤ß∞ ª°©˙°]±N®‰§§™∫¶^®Æ¥´¶Ê•H¶r¶Í#13#10¶s¿x°^
    Des: array [0..1024] of Char;
    MktC:string[15];//§W•´ßO
  end;
  PTCRIRec = ^TTCRIRec;
  TAryTCRIRec = array of TTCRIRec;
  
  TRecCount=record
    StatusCode:string[2];
    Status:string[50];
    Count:integer;
  end;

  TAMainFrm = class(TForm)
    TCPServer: TIdTCPServer;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    ImageList1: TImageList;
    Timer1: TTimer;
    TimerSendLiveToDocMonitor: TTimer;
    ImageList2: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ListBox1: TListBox;
    dxTreeListAppStatus: TdxTreeList;
    AppDNS: TdxTreeListColumn;
    AppCaption: TdxTreeListColumn;
    AppID: TdxTreeListColumn;
    MsgTime: TdxTreeListColumn;
    ConnectTime: TdxTreeListColumn;
    BarCount: TdxTreeListColumn;
    IdTCPClient1: TIdTCPClient;
    OpenDialog1: TOpenDialog;
    pm1: TPopupMenu;
    miInitData1: TMenuItem;
    Timer2: TTimer;
    ListBox2: TListBox;
    Splitter1: TSplitter;
    TCPServer2: TIdTCPServer;
    TimerInitObj: TTimer;
    btn1: TButton;
    TCPServerEcb: TIdTCPServer;
    TCPServer2Ecb: TIdTCPServer;
    chkAutoAuditDoc: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure TCPServerExecute(AThread: TIdPeerThread);
    procedure Timer1Timer(Sender: TObject);
    procedure dxTreeListAppStatusCustomDraw(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
      AColumn: TdxTreeListColumn; const AText: String; AFont: TFont;
      var AColor: TColor; ASelected, AFocused: Boolean;
      var ADone: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerSendLiveToDocMonitorTimer(Sender: TObject);

    //add by wangjinhua ThreeTrader 091015
    procedure miInitData1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TCPServer2Execute(AThread: TIdPeerThread);
    procedure TimerInitObjTimer(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure TCPServerEcbExecute(AThread: TIdPeerThread);
    procedure TCPServer2EcbExecute(AThread: TIdPeerThread);
    //--
  private
    { Private declarations }
    FPerSize:integer;//FIndyMaxLineLength
    FIndustryWorkLstTime:TDateTime;FIndustryWorkLstTick:DWORD;
    FIFRSWorkLstTime:TDateTime;FIFRSWorkLstTick:DWORD;//®Cπj3§¿ƒ¡≈˝Ωuµ{πMæ˙§@¶∏∑Ì´e¨Oß_¶s¶bIFRSDown≤£•Õ™∫¶€∞ §W∂«•Ù∞»
    DocDataMgr_2 : TDoc02DataMgr;
    DocDataMgr_1 : TDocDataMgr;
    DocDataMgr_3 : TDocDataMgr;
    DocManualMgr_2 :TDocManualMgr;//Doc3.2.0ª›®D3 huangcq080928 add--

    //DOC4.0.0°™N002 huangcq081223 add---->
    FSocketSvrFrm : TASocketSvrFrm;
    FSocketClientFrm : TASocketClientFrm;
    FSocketClient_MonitorFrm : TASocketClientFrm;//--DOC4.0.0°™N001 huangcq090407 add

    FBC14Path,FBC2Path,FBC3Path,FBC5Path,FBC6Path,
    FSwapOptionPath,FSwapYieldPath,FRateLogPath:string;
    FIRSavePathList:TStringList;
    FIRSavePathListEcb:TStringList;
    FRateDatUploadWorkDir:string;
    FShenbaoCase_UptLogSaveDays:integer;

    FLoadCountOfIFRS:integer;
    FDataPath : String;
    FDocPath : String;
    FTempDocFile_1:String;
    FTempDocFile_2:String;
    FTempDocFile_3:String;
    NowIsRunning : Boolean;
    NowIsLoading : Boolean;
    FIDLstMgr : TIDLstMgr;
    FLog1,FLog2:TLogHandleThread;

    FCBDataWorkHandle:TCBDataWorkHandleThread; FCBDataWorkHandleEcb:TCBDataWorkHandleThreadEcb;
    FClsBakDataThread:TClsBakDataThread;


    Function CompressOutPutFile(SourceFile:String):String;
    Procedure InitObj();
    function UpdateGuidOfWorkList_CBData(aTrl:boolean;aCBDataFile:string;
        aVisible:Boolean;aOperator,aTimeKey:string):boolean;
    function UpdateGuidOfWorkList_CBDataEcb(aTrl:boolean;aCBDataFile:string;
        aVisible:Boolean;aOperator,aTimeKey:string):boolean;
    function UpdateGuidOfWorkList_IFRS(aOperator,aTimeKey,aCode,aYear,aQ,aIDName,aOp,aMName,aMNameEn:string):boolean;
    function UpdateGuidOfWorkList_NodeData(aTrl:boolean;aCBDataFile:string;aOperator,aTimeKey:string):boolean;
    function UpdateGuidOfWorkList_NodeDataEcb(aTrl:boolean;aCBDataFile:string;aOperator,aTimeKey:string):boolean;
    //DOC4.0.0°™N002 huangcq081223 add---->
    procedure SendDocMonitorStatusMsg;
    function SendDocMonitorWarningMsg(const Str: String): boolean;
    Procedure Msg_AppStatusInfo(Var Message:TMessage);Message WM_AppStatusInfo;
    Procedure Msg_ReceiveDataInfo(ObjWM : PWMReceiveString);
    Procedure Msg_ReceiveDataInfo_Monitor(ObjWM : PWMReceiveString);
    procedure RefreshAppStatus(Const AppDNS,AppID:String; Const AppStatus:TAppStatus);
    procedure RefreshActiveClients(Const AppStatus:TAppStatus);
    function InitTCRIData():boolean;
    //<---DOC4.0.0°™N002 huangcq081223 add--
    function Pro_RequestListIFRS(aConnect:TIdTCPConnection):Integer;
    function Pro_RequestUserVlidate(aConnect:TIdTCPConnection):Integer;
    function Pro_RequestUPTLOGRECSFILE(SRequest,sTimeKey:string):Integer;
    function Pro_RequestUPTLOGRECSFILEEcb(SRequest,sTimeKey:string):Integer;
    function Pro_RequestUPTOPLOGRECS(aConnect:TIdTCPConnection;SRequest:string;aEcb:boolean):Integer;

    function Pro_RequestMANUALDOCREADDELTMPLOG(aConnect:TIdTCPConnection):Integer;
    function Pro_RequestMANUALDOCDELBACKUPTMP(aConnect:TIdTCPConnection):Integer;
    function Pro_RequestMANUALDOCREADTMP(aConnect:TIdTCPConnection):Integer;
    function Pro_RequestMANUALDOCREADALLLOG(aConnect:TIdTCPConnection):Integer;
    function Pro_RequestMANUALDOCREADNEWLOG(aConnect:TIdTCPConnection):Integer;
    function Pro_RequestMANUALDOCSAVETMP(aConnect:TIdTCPConnection):Integer;
    function Pro_Request_DOCOK_DOCDEL(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function AutoDOCOK02(aDocOk:boolean;ADoc2:TDocData):Boolean;
    function Pro_Request_DOCCancel(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_Request_DOCDone(aConnect:TIdTCPConnection;aDocStatus,SRequest:string):Integer;
    
    function Pro_RequestGETZZSZHINT(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestDOC01OKTIME(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestDOC03OKTIME(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_Request_StkIndustryStatus_StkBase1Status(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestDOCCOUNT(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestINITREADNEWDOC1(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestREADNEWDOC1(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestREADDELLOGDOC_01(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestREADDELLOGDOC_02(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestREADDELCancelLOGDOC_02(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestREADDELLOGDOC_03(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestREADLOGDOC_01(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestREADLOGDOC_02(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestREADCancelLOGDOC_02(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestREADLOGDOC_03(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestGETTcriOPLOG(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestGETCBDATAOPLOG(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestGETCBDATAOPLOGEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestGETIFRSOPLOG(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestGETIFRSTr1dbData(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestAuditIFRSData(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestSetIFRSWork(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestSetIFRSWorkHis(aSY,aSQ,aEY,aEQ:Integer):Integer;
    function Pro_RequestSetDealer(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestSetThreeTrader(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestGetDocRtf(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestGetShenBaoDocText(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestGetShenBaoDoc2Text(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestGetNodeText(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestSetCBDat(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestSetCBDatEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestSetcbinfoDat(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestSetCBTxt(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestSetCBTxtEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_Request_Dat(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_Request_DatEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;

    function Pro_Request_RecvFile(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function NodeText2BinDat(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function NodeText2BinDatEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;

    function CheckIRSavePathList:string;
    function CheckIReExcekSavePath1:string;
    function CheckIReExcekSavePath2:string;
    function GetIRRateStatusString(aDate:TDate):string;
    function Pro_RequestIRRateStatusString(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestIRRateFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestSetIRRateFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestSetEcbRateFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestSetStockWeightFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestSetTcriFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestTr1dbStockWeightFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestTr1dbStockWeightDelFile(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestDelOfTr1dbStockWeight(aConnect:TIdTCPConnection;SRequest:string):Integer;
    function Pro_RequestReBackOfTr1dbStockWeight(aConnect:TIdTCPConnection;SRequest:string):Integer;

    function Pro_RequestDiffOfLastShenBaoCase(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestSubmitShenBaoCase(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    
    function Pro_RequestReadNodeFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    //function Pro_RequestSetCBDBFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestReadCBDataFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestSetCBDataFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;

    function Pro_RequestReadNodeFilesEcb(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestReadCBDataFilesEcb(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    function Pro_RequestSetCBDataFilesEcb(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
    
    function Pro_RecvFile_CBDataFiles(sFileName:string;aConnect:TIdTCPConnection;aShow2Tw:boolean=true):Integer;
    function Pro_TransferFile_ForCBDataFiles(aConnect:TIdTCPConnection;aSrc:string;aShow2Tw:boolean=true):boolean;

    procedure ShowSb(aIndex:Integer;aMsg:string);
    procedure ClearSysLog(aSaveDay:integer);
    procedure AppExcept(Sender: TObject; E: Exception);
    procedure chkAutoAuditDocOnClick(Sender: TObject);
    function LoadOfDocDataMgr_2DocList(aChkDocListCount,aChkNowIsLoading:Boolean):Boolean;
  public
    { Public declarations }
    FStopRunning: Boolean;
    FBakDataSaveDays:integer;
    FCBDataLockTimeOut:integer;
    FCBDataTokenMng:TCBDataTokenMng;  FCBDataTokenMngEcb:TCBDataTokenMngEcb;
    CBDataMgr:TCBDataMgr; CBDataMgrEcb:TCBDataMgrEcb; 
    FSendMailOfOpLogFlag:string; FSendMailOfOpLogTime:TTime;
    //FSendMailOfOpLogFlagEcb:string; FSendMailOfOpLogTimeEcb:TTime;

    procedure ShowMsg(const Msg:String;AutoConvert:Boolean=true);
    procedure ShowMsgTw(const Msg:String;AutoConvert:Boolean=true);
    procedure ShowMsgTwEcb(const Msg:String;AutoConvert:Boolean=true);
    procedure ShowMsg2(const Msg:String;AutoConvert:Boolean=true);
    procedure ShowMsg2Tw(const Msg:String;AutoConvert:Boolean=true);
    procedure ShowMsg2TwEcb(const Msg:String;AutoConvert:Boolean=true);

    function ColloectUploadLog:boolean;
    function CreateAMail(AWarn: Boolean; AEvent,ABody: String): Boolean;
  end;

var
  AMainFrm: TAMainFrm;
  CriticalSection,CriticalSection2,FCsMmo1,FCsMmo2: TRTLCriticalSection;
  Handle:HWND; //--DOC4.0.0°XN001 huangcq090407  DocªPWarningCenteræ„¶X
  G_Caption: String;//--DOC4.0.0°XN001 huangcq090407  DocªPWarningCenteræ„¶X

const
  _Section_CBData='cbdata';
  _Section_NodeData='nodedata';
  _FileName_Tr1='tr1work.lst';
  _FileName_Local='Localwork.lst';
  
implementation
{$R *.dfm}

function AppPath():string;
begin
  result:=ExtractFilePath(ParamStr(0));
end;

function IsPassWayFile(aFile:string):boolean;
begin
  Result:=false;
  aFile:=ExtractFileName(aFile);
  if SameText(aFile,'passaway.txt') or
     SameText(aFile,'stopissue.txt') then
    result:=true;
end;

function GetStrLst2Text(aInputStrLst2:_cStrLst2):string;
  var x1:integer;
  begin
    result:='';
    for x1:=0 to High(aInputStrLst2) do
    begin
      if Result='' then result:=aInputStrLst2[x1]
      else result:=result+','+aInputStrLst2[x1];
    end;
  end;

function GetFileListByDBLstFile(aDBLstFile:string;var ts:TStringList):Boolean;
var i:integer;  sTemp,sPath:string;  cStrLst:_cStrLst2;
begin
  result:=False;
  ts.Clear;
  if not FileExists(aDBLstFile) then
    exit;
  sTemp:=GetIniFileEx('dblst','filename','',aDBLstFile);
  if sTemp='' then
  begin
     result:=true;
     exit;
  end;
  sPath:=ExtractFilePath(aDBLstFile);
  try
    cStrLst:=DoStrArray2(sTemp,',');
    for i:=0 to High(cStrLst) do
    begin
      ts.Add(sPath+cStrLst[i]);
    end;
  finally
    SetLength(cStrLst,0);
  end;
  result:=true;
end;

procedure ShowMsgMmo1(const Msg: String; Const User: String=''; IsNowSave:boolean=false);
begin
  if Assigned(AMainFrm) then
  with AMainFrm.ListBox1 do
  begin
    ItemIndex:=Items.Add(Msg);
    if ItemIndex>100 Then
      Clear;
  end;
end;

procedure ShowMsgMmo2(const Msg: String; Const User: String=''; IsNowSave:boolean=false);
begin
  if Assigned(AMainFrm) then
  with AMainFrm.ListBox2 do
  begin
    ItemIndex:=Items.Add(Msg);
    if ItemIndex>100 Then
      Clear;
  end;
end;

function TAMainFrm.UpdateGuidOfWorkList_CBData(aTrl:boolean;aCBDataFile:string;
  aVisible:Boolean;aOperator,aTimeKey:string):boolean;
  procedure CreateAnUplaodFlag;
  var sFile:string; ts:TStringList;
  begin
    sFile:=GetAnUploadOpFile(false);
    ts:=TStringList.create;
    try
      ts.Add('[data]');
      ts.Add('operator='+aOperator);
      ts.Add('timekey='+aTimeKey);
      ts.Add('uptfile='+aCBDataFile);
      ts.Add('visible='+IntToStr(BoolToInt(aVisible)));
      ts.SaveToFile(sFile); 
    finally
      FreeAndNil(ts);
    end;
  end;
begin
  CreateAnUplaodFlag;
  begin
    if Assigned(FCBDataWorkHandle) then
      FCBDataWorkHandle.UptGUIDOfCBData;
  end;
  result:=true;
end;


function TAMainFrm.UpdateGuidOfWorkList_CBDataEcb(aTrl:boolean;aCBDataFile:string;
  aVisible:Boolean;aOperator,aTimeKey:string):boolean;
  procedure CreateAnUplaodFlag;
  var sFile:string; ts:TStringList;
  begin
    sFile:=GetAnUploadOpFileEcb(false);
    ts:=TStringList.create;
    try
      ts.Add('[data]');
      ts.Add('operator='+aOperator);
      ts.Add('timekey='+aTimeKey);
      ts.Add('uptfile='+aCBDataFile);
      ts.Add('visible='+IntToStr(BoolToInt(aVisible)));
      ts.SaveToFile(sFile); 
    finally
      FreeAndNil(ts);
    end;
  end;
begin
  CreateAnUplaodFlag;
  begin
    if Assigned(FCBDataWorkHandleEcb) then
      FCBDataWorkHandleEcb.UptGUIDOfCBData;
  end;
  result:=true;
end;

function TAMainFrm.UpdateGuidOfWorkList_IFRS(aOperator,aTimeKey,aCode,aYear,aQ,aIDName,aOp,aMName,aMNameEn:string):boolean;
  procedure CreateAnUplaodFlag;
  var sFile:string; ts:TStringList;
  begin
    sFile:=GetAnIFRSUploadOpFile();
    ts:=TStringList.create;
    try
      ts.Add('[data]');
      ts.Add('operator='+aOperator);
      ts.Add('timekey='+aTimeKey);
      ts.Add('code='+aCode);
      ts.Add('year='+aYear);
      ts.Add('q='+aQ);
      ts.Add('idname='+aIDName);
      ts.Add('op='+aOp);
      ts.Add('mname='+aMName);
      ts.Add('mnamee='+aMNameEn);
      ts.SaveToFile(sFile); 
    finally
      FreeAndNil(ts);
    end;
  end;
begin
  CreateAnUplaodFlag;
  begin
    if Assigned(FCBDataWorkHandle) then
      FCBDataWorkHandle.UptGUIDOfIFRSData;
  end;
  result:=true;
end;

{
function NodeTag2NodeStr(NodeTag:string):string;
  begin
    result:='';
    if SameText(NodeTag,'stop') then
    begin
      if FAppParam.IsTwSys then
        result:='∞±µo(•x∆W)'
      else
        result:=FAppParam.TwToGBConvertStr('∞±µo');
    end
    else if SameText(NodeTag,'xunquan') then
    begin
      if FAppParam.IsTwSys then
        result:='∏ﬂ∞È(•x∆W)'
      else
        result:=FAppParam.TwToGBConvertStr('');
    end
    else if SameText(NodeTag,'song') then
    begin
      if FAppParam.IsTwSys then
        result:='∞e•Û(•x∆W)'
      else
        result:=FAppParam.TwToGBConvertStr('');
    end
    else if SameText(NodeTag,'pass') then
    begin
      if FAppParam.IsTwSys then
        result:='Æ÷≠„(•x∆W)'
      else
        result:=FAppParam.TwToGBConvertStr('πL∑|(∫≠≤`•´)');
    end
    else if SameText(NodeTag,'Nifaxing') then
    begin
      if FAppParam.IsTwSys then
        result:='¿¿µo¶Ê(•x∆W)'
      else
        result:=FAppParam.TwToGBConvertStr('¿¿µo¶Ê(∫≠≤`•´)');
    end
    else if SameText(NodeTag,'passaway') then
    begin
      if FAppParam.IsTwSys then
        result:='•x∆W§U•´'
      else
        result:=FAppParam.TwToGBConvertStr('§U•´');
    end
    else if SameText(NodeTag,'hushi') then
    begin
      if FAppParam.IsTwSys then
        result:=''
      else
        result:=FAppParam.TwToGBConvertStr('∫≠•´');
    end
    else if SameText(NodeTag,'shenshi') then
    begin
      if FAppParam.IsTwSys then
        result:=''
      else
        result:=FAppParam.TwToGBConvertStr('≤`•´');
    end
    else if SameText(NodeTag,'shanggui') then
    begin
      if FAppParam.IsTwSys then
        result:='•x∆W§W¬d'
      else
        result:=FAppParam.TwToGBConvertStr('');
    end
    else if SameText(NodeTag,'shangshi') then
    begin
      if FAppParam.IsTwSys then
        result:='•x∆W§W•´'
      else
        result:=FAppParam.TwToGBConvertStr('');
    end
    else if SameText(NodeTag,'guapai') then
    begin
      if FAppParam.IsTwSys then
        result:='•x∆Wµo¶Ê'
      else
        result:=FAppParam.TwToGBConvertStr('§§∞Íµo¶Ê');
    end;
  end;
}

function TAMainFrm.UpdateGuidOfWorkList_NodeData(aTrl:boolean;aCBDataFile:string;
  aOperator,aTimeKey:string):boolean;
  procedure CreateAnUplaodFlag;
  var sFile:string; ts:TStringList;
  begin
    sFile:=GetAnUploadOpFile(true);
    ts:=TStringList.create;
    try
      ts.Add('[data]');
      ts.Add('operator='+aOperator);
      ts.Add('timekey='+aTimeKey);
      ts.Add('uptfile='+aCBDataFile);
      ts.Add('visible=1');
      ts.SaveToFile(sFile);
    finally
      FreeAndNil(ts);
    end;
  end;
var sLogOpLst:String;
begin
  CreateAnUplaodFlag;
  sLogOpLst:=''+_LogSep+''+_LogSep+_OpNodeUpload+_LogSep+''+_LogSep+aOperator+_LogSep+
             ''+_LogSep+''+_LogSep+'0';
             //NodeTag2NodeStr(aCBDataFile)+_LogSep+NodeTag2FileName(aCBDataFile)+_LogSep+'0';
  Pro_RequestUPTLOGRECSFILE(sLogOpLst,aTimeKey);
  begin
    if Assigned(FCBDataWorkHandle) then
      FCBDataWorkHandle.UptGUIDOfNodeData;
  end;
  result:=true;
end;

function TAMainFrm.UpdateGuidOfWorkList_NodeDataEcb(aTrl:boolean;aCBDataFile:string;
  aOperator,aTimeKey:string):boolean;
  procedure CreateAnUplaodFlag;
  var sFile:string; ts:TStringList;
  begin
    sFile:=GetAnUploadOpFileEcb(true);
    ts:=TStringList.create;
    try
      ts.Add('[data]');
      ts.Add('operator='+aOperator);
      ts.Add('timekey='+aTimeKey);
      ts.Add('uptfile='+aCBDataFile);
      ts.Add('visible=1');
      ts.SaveToFile(sFile);
    finally
      FreeAndNil(ts);
    end;
  end;
var sLogOpLst:String;
begin
  CreateAnUplaodFlag;
  sLogOpLst:=''+_LogSep+''+_LogSep+_OpNodeUpload+_LogSep+''+_LogSep+aOperator+_LogSep+
             ''+_LogSep+''+_LogSep+'0';
             //NodeTag2NodeStr(aCBDataFile)+_LogSep+NodeTag2FileName(aCBDataFile)+_LogSep+'0';
  Pro_RequestUPTLOGRECSFILEEcb(sLogOpLst,aTimeKey);
  begin
    if Assigned(FCBDataWorkHandleEcb) then
      FCBDataWorkHandleEcb.UptGUIDOfNodeData;
  end;
  result:=true;
end;

procedure TAMainFrm.InitObj;
var aLogPath:string;
begin
  aLogPath:=ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\doccenter\';
  if not DirectoryExists(aLogPath) then
    Mkdir_Directory(aLogPath);
  FLog1:=TLogHandleThread.Create(true,'_doc',aLogPath,ShowMsgMmo1);
  FLog2:=TLogHandleThread.Create(true,'_cbdata',aLogPath,ShowMsgMmo2);
  FLog1.Resume;
  FLog2.Resume;
  
  FAppParam := TDocMgrParam.Create;
  FAppParamEcb := TDocMgrParam.Create(ExtractFilePath(Application.ExeName)+'ecbsetup.ini');
  FCBDataTokenMng:=TCBDataTokenMng.Create(FCBDataLockTimeOut,True,FAppParam.IsTwSys);
  FCBDataTokenMngEcb:=TCBDataTokenMngEcb.Create(FCBDataLockTimeOut,True,FAppParamEcb.IsTwSys);
  FLoadCountOfIFRS:=StrToInt( GetIniFileEx('DownIFRS','LoadCount','20',
    ExtractFilePath(Application.ExeName)+'setup.ini') );
  FClsBakDataThread:=TClsBakDataThread.Create;
  FClsBakDataThread.Resume;

  chkAutoAuditDoc.Caption:=FAppParam.TwConvertStr('¶€∞ ºfÆ÷§Ωßi');

  CBDataMgr := TCBDataMgr.Create(FAppParam.IsTwSys,FAppParam.Tr1DBPath);
  CBDataMgrEcb := TCBDataMgrEcb.Create(FAppParamEcb.IsTwSys,FAppParamEcb.Tr1DBPath);
  FDataPath:=CBDataMgrEcb.LoaclDatDir;
  if (FDataPath<>'') and (not DirectoryExists(FDataPath)) then
    Mkdir_Directory(FDataPath);
  FDataPath:=CBDataMgr.LoaclDatDir;
  if (FDataPath<>'') and (not DirectoryExists(FDataPath)) then
    Mkdir_Directory(FDataPath);

  FDocPath := FAppParam.Tr1DBPath+'CBData\Document\';
  Mkdir_Directory(FDataPath);
  Mkdir_Directory(FDocPath);
  FTempDocFile_1 := FDataPath+'Doc_01.tmp';
  FTempDocFile_2 := FDataPath+'Doc_02.tmp';
  FTempDocFile_3 := FDataPath+'Doc_03.tmp';

  DocDataMgr_1 := TDocDataMgr.Create(FTempDocFile_1,FDocPath);
  DocDataMgr_1.SetCheckDocLogSaveDays(FAppParam.CheckDocLogSaveDays_NiFang);
  DocDataMgr_2 := TDoc02DataMgr.Create(FTempDocFile_2,FDocPath);
  DocDataMgr_2.SetCheckDocLogSaveDays(FAppParam.CheckDocLogSaveDays_ShangShi);
  DocDataMgr_3 := TDocDataMgr.Create(FTempDocFile_3,FDocPath);
  DocDataMgr_3.SetCheckDocLogSaveDays(FAppParam.CheckDocLogSaveDays_GuoHui);

  DocManualMgr_2 := TDocManualMgr.Create(FTempDocFile_2,FDataPath);//--Doc3.2.0ª›®D3 huangcq080928 add--
  FIDLstMgr := TIDLstMgr.Create3(FAppParam.Tr1DBPath,M_OutPassaway_P_All); //---Doc3.2.0ª›®D1 huangcq080923 modify
  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;
end;

procedure TAMainFrm.FormCreate(Sender: TObject);
var sFile,sTemp:String; fini:TIniFile; j,jc,iPort,iPort2,aSaveDays:integer;
begin
  Application.OnException := AppExcept;
    
  FIRSavePathList:=TStringList.Create;
  sFile:=ExtractFilePath(ParamStr(0))+'setup.ini';
  try
    fini:=TIniFile.create(sFile);
    FCBDataLockTimeOut:=fini.ReadInteger('doccenter','CBDataLockTimeOut',120);
    FBakDataSaveDays:=fini.ReadInteger('doccenter','BakDataSaveDays',90);
    FSendMailOfOpLogTime:= StrToTime(fini.ReadString('doccenter','SendMailOfOpLogTime','17:00:00'));
    FSendMailOfOpLogFlag:= fini.ReadString('doccenter','SendMailDate','');
    //FRateDatUploadWorkDir:= fini.ReadString('Rate','UploadWorkDir','');
    FRateDatUploadWorkDir:=ExtractFilePath(ParamStr(0))+'data\RateDatUpload\';
    if not DirectoryExists(FRateDatUploadWorkDir) then
      Mkdir_Directory(FRateDatUploadWorkDir);


    FBC14Path    := fini.ReadString('Rate','Manner14','');
    FBC2Path     := fini.ReadString('Rate','Manner2','');
    FBC3Path     := fini.ReadString('Rate','Manner3','');
    FBC5Path     := fini.ReadString('Rate','Manner5','');
    FBC6Path     := fini.ReadString('Rate','Manner6','');
    FSwapOptionPath     := fini.ReadString('Rate','SwapOption','');
    FSwapYieldPath     := fini.ReadString('Rate','SwapYield','');
    FRateLogPath := fini.ReadString('Rate','RateLogPath','');
    jc:= fini.Readinteger('Examine','Count',0);
    for j:=1 to jc do
    begin
      sTemp:= fini.ReadString('Examine',IntToStr(j),'');
      if Trim(sTemp)<>'' then
      begin
        FIRSavePathList.Add(sTemp);
      end;
    end;

    FShenbaoCase_UptLogSaveDays:= fini.Readinteger('DownShenBaoCase','UptLogSaveDays',90);
    
    iPort:=fini.ReadInteger('doccenter','DocServerPort',8100);
    iPort2:=fini.ReadInteger('doccenter','CBDataServerPort',8101);
    aSaveDays:=fini.ReadInteger('doccenter','LogSaveDays',90);
    FPerSize:=fini.ReadInteger('doccenter','PerSize',8192);
    //FIndyMaxLineLength:=fini.ReadInteger('doccenter','IndyMaxLineLength',1024*100);
    //TCPServer.Active:=false;
    TCPServer.Bindings.Clear;
    TCPServer.DefaultPort:=iPort;
    //showMessage(IntToStr(TCPServer.DefaultPort))) ;

    //TCPServer2.Active:=false;
    TCPServer2.Bindings.Clear;
    TCPServer2.DefaultPort:=iPort2;
    //showMessage(IntToStr(TCPServer2.DefaultPort))) ;

    chkAutoAuditDoc.Checked := fini.ReadBool('DocCenter','AutoAuditDoc',False);
    chkAutoAuditDoc.OnClick:=chkAutoAuditDocOnClick;
  finally
    FreeAndNil(fini);
  end;

  FIRSavePathListEcb:=TStringList.Create;
  sFile:=ExtractFilePath(ParamStr(0))+'ecbsetup.ini';
  try
    fini:=TIniFile.create(sFile);
    jc:= fini.Readinteger('Examine','Count',0);
    for j:=1 to jc do
    begin
      sTemp:= fini.ReadString('Examine',IntToStr(j),'');
      if Trim(sTemp)<>'' then
      begin
        FIRSavePathListEcb.Add(sTemp);
      end;
    end;

    //FSendMailOfOpLogTimeEcb:= StrToTime(fini.ReadString('doccenter','SendMailOfOpLogTime','17:00:00'));
    //FSendMailOfOpLogFlagEcb:= fini.ReadString('doccenter','SendMailDate','');
    
    iPort:=fini.ReadInteger('doccenter','DocServerPort',8102);
    iPort2:=fini.ReadInteger('doccenter','CBDataServerPort',8103);
    //TCPServerEcb.Active:=false;
    TCPServerEcb.Bindings.Clear;
    TCPServerEcb.DefaultPort:=iPort;

    //TCPServer2Ecb.Active:=false;
    TCPServer2Ecb.Bindings.Clear;
    TCPServer2Ecb.DefaultPort:=iPort2;
  finally
    FreeAndNil(fini);
  end;
  
  Caption :=('Doc Center Ver['+GetFileVer(Application.ExeName)+']');
  ClearSysLog(aSaveDays);
  InitObj;
  TimerInitObj.Enabled:=true;
end;


procedure TAMainFrm.TimerInitObjTimer(Sender: TObject);
begin
try
  TimerInitObj.Enabled:=false;
  DocDataMgr_2.InitStockDocIdxLstDat;
  FCBDataWorkHandle:=TCBDataWorkHandleThread.Create;
  FCBDataWorkHandle.PackCBDataFile('');
  FCBDataWorkHandle.PackCBNodeFile;
  FCBDataWorkHandle.Resume;

  FCBDataWorkHandleEcb:=TCBDataWorkHandleThreadEcb.Create;
  if FAppParam.IsTwSys then
  begin
    FCBDataWorkHandleEcb.PackCBDataFile('');
    FCBDataWorkHandleEcb.PackCBNodeFile;
  end;
  FCBDataWorkHandleEcb.Resume;

  //--DOC4.0.0°™N002 huangcq090617 add----->
  FStopRunning := False;
   if FSocketSvrFrm=nil Then
      FSocketSvrFrm := TASocketSvrFrm.Create(Self,FAppParam.DocCenterSktPort);
   if FSocketClientFrm=nil Then
   Begin
      FSocketClientFrm := TASocketClientFrm.Create(Self,'DocCenter',FAppParam.DocServer
                                                 ,FAppParam.DocCenterSktPort,Msg_ReceiveDataInfo);
   End;
   dxTreeListAppStatus.ClearNodes;
   RefreshActiveClients(appDisConnect);
   //--DOC4.0.0°™N001 huangcq090407 add----->
   if FSocketClient_MonitorFrm=nil then
   begin
      FSocketClient_MonitorFrm := TASocketClientFrm.Create(Self,'DocCenter',FAppParam.DocMonitorHostName
                                              ,FAppParam.DocMonitorPort,Msg_ReceiveDataInfo_Monitor);
   end;
   TimerSendLiveToDocMonitor.Interval := 3000;
   TimerSendLiveToDocMonitor.Enabled  := True;

  FIndustryWorkLstTick:=0; FIndustryWorkLstTime:=GetTickCount;  
  FIFRSWorkLstTime:=0; FIFRSWorkLstTick:=GetTickCount;
  Timer1.Enabled:=true;
  Timer2.Enabled:=true;
  
  TCPServer.Active := True;
  TCPServer2.Active := True;
  miInitData1.Visible:=false;
  if FAppParam.IsTwSys then
  begin
    TCPServerEcb.Active := True;
    TCPServer2Ecb.Active := True;
    miInitData1.Caption:=FAppParam.TwConvertStr('≥]©wifrsæ˙•v§U∏¸•Ù∞»');
    miInitData1.Visible:=true;
  end;
  ShowMsg2Tw('™A∞»∫›∞ª≈•§w∏g∂}±“.');
finally
end;
end;

procedure TAMainFrm.ShowSb(aIndex:Integer;aMsg:string);
var i:integer;
begin
  with StatusBar1 do
  begin
    if aIndex=-1 then
    begin
      for i:=0 to Panels.count-1 do
        Panels[i].Text:='';
    end
    else begin
      if (aIndex>=0) and (aIndex<Panels.count) then
        Panels[aIndex].Text:=aMsg;
    end;
    Application.ProcessMessages;
  end;
end;

function TAMainFrm.Pro_Request_Dat(aConnect:TIdTCPConnection;SRequest:string):Integer;
var AMemoryStream:TMemoryStream; AStream: TStringStream; ACompressFile:TFileStream; sTEMP:string;
begin
  with aConnect do
  begin
    AMemoryStream:=nil; AStream:=nil; ACompressFile:=nil;
    try
        ShowMsgTW('∑«≥∆∂«øÈ∏ÍÆ∆');
        if lowercase(SRequest)='marketidlst.dat' Then
          SRequest := CompressOutPutFile(OutPutIDFile(FAppParam.Tr1DBPath))
        Else if LowerCase(SRequest)='trade_stockcode.dat' Then   //--Doc4.0°™N004 huangcq090317 add
          SRequest := CompressOutPutFile(OutPutTradeAndStockCode(FAppParam.Tr1DBPath))
        else if (SRequest = UpperCase('Date@StkIndustry.dat')) Then
        begin
          sTEMP:=CBDataMgr.GetDateStkIndustryTFN(SRequest);
          ShowMsg('f:'+sTEMP);
          SRequest := CompressOutPutFile(sTEMP);
          if GetFileSize(sTEMP)=0 then
          begin
            if FileExists(sTemp) then DeleteFile(sTEMP);
          end;
        end
        else if (SRequest = UpperCase('Date@StkIndustryDif.dat')) Then
        begin
          sTEMP:=CBDataMgr.GetDateStkIndustryDifTFN(SRequest);
          ShowMsg('f:'+sTEMP);
          SRequest := CompressOutPutFile(sTEMP);
          if GetFileSize(sTEMP)=0 then
          begin
            if FileExists(sTemp) then DeleteFile(sTEMP);
          end;
        end
        else if (SRequest = UpperCase('Date@StkBase1.dat')) Then
        begin
          sTEMP:=CBDataMgr.GetDateStkBase1TFN(SRequest);
          ShowMsg('f:'+sTEMP);
          SRequest := CompressOutPutFile(sTEMP);
          if GetFileSize(sTEMP)=0 then
          begin
            if FileExists(sTemp) then DeleteFile(sTEMP);
          end;
        end
        else if (SRequest = UpperCase('Date@StkBase1Dif.dat')) Then
        begin
          sTEMP:=CBDataMgr.GetDateStkBase1DifTFN(SRequest);
          ShowMsg('f:'+sTEMP);
          SRequest := CompressOutPutFile(sTEMP);
          if GetFileSize(sTEMP)=0 then
          begin
            if FileExists(sTemp) then DeleteFile(sTEMP);
          end;
        end
        else if (PosEx('WeekOf@cbbaseinfo.dat',SRequest)>0) Then
        begin
            sTEMP:=CBDataMgr.GetDatecbbaseinfoOfWeek(SRequest);
            ShowMsg('f:'+sTEMP);
            SRequest := CompressOutPutFile(sTEMP);
            if GetFileSize(sTEMP)=0 then
            begin
              if FileExists(sTemp) then DeleteFile(sTEMP);
            end;
        end
        else if (SRequest = UpperCase('Date@cbbaseinfo.dat')) Then
        begin
          sTEMP:=CBDataMgr.GetDatecbbaseinfo(SRequest);
          ShowMsg('f:'+sTEMP);
          SRequest := CompressOutPutFile(sTEMP);
          if GetFileSize(sTEMP)=0 then
          begin
            if FileExists(sTemp) then DeleteFile(sTEMP);
          end;
        end
        else if (SRequest = UpperCase('Date@closeidlist.lst')) Then
        begin
          sTEMP:=CBDataMgr.GetDatecloseidlist(SRequest);
          ShowMsg('f:'+sTEMP);
          SRequest := CompressOutPutFile(sTEMP);
          if GetFileSize(sTEMP)=0 then
          begin
            if FileExists(sTemp) then DeleteFile(sTEMP);
          end;
        end
        else if (PosEx('WeekOf@closeidlist.lst',SRequest)>0) Then
        begin
            sTEMP:=CBDataMgr.GetWeekOfcloseidlistEx(SRequest);
            ShowMsg('f:'+sTEMP);
            SRequest := CompressOutPutFile(sTEMP);
            if GetFileSize(sTEMP)=0 then
            begin
              if FileExists(sTemp) then DeleteFile(sTEMP);
            end;
        end

        else if (SRequest = UpperCase('Date@stockweight.dat')) Then
        begin
            sTEMP:=CBDataMgr.GetDateStockweight(SRequest);
            ShowMsg('f:'+sTEMP);
            SRequest := CompressOutPutFile(sTEMP);
            if GetFileSize(sTEMP)=0 then
            begin
              if FileExists(sTemp) then DeleteFile(sTEMP);
            end;
        end
        else if (PosEx('log@stockweight.dat',SRequest)>0) Then
        begin
            sTEMP:=CBDataMgr.GetLogStockweight(SRequest);
            ShowMsg('f:'+sTEMP);
            SRequest := CompressOutPutFile(sTEMP);
            if GetFileSize(sTEMP)=0 then
            begin
              if FileExists(sTemp) then DeleteFile(sTEMP);
            end;
        end
        else if (PosEx('log@cbbaseinfo.dat',SRequest)>0) Then
        begin
            sTEMP:=CBDataMgr.GetLogcbbaseinfo(SRequest);
            ShowMsg('f:'+sTEMP);
            SRequest := CompressOutPutFile(sTEMP);
            if GetFileSize(sTEMP)=0 then
            begin
              if FileExists(sTemp) then DeleteFile(sTEMP);
            end;
        end
        
        else begin
          sTEMP:=CBDataMgr.GetCBDataTextFileName(SRequest);
          ShowMsg('f:'+sTEMP);
          SRequest := CompressOutPutFile(sTEMP);
          if GetFileSize(sTEMP)=0 then
          begin
            if FileExists(sTemp) then DeleteFile(sTEMP);
          end;
        end;

        if FileExists(SRequest) Then
        Begin
          ACompressFile := TFileStream.Create(SRequest,fmOpenRead);
          OpenWriteBuffer;
          WriteStream(ACompressFile);
          CloseWriteBuffer;
        End;
        if Assigned(ACompressFile) Then
           ACompressFile.Free;
        ACompressFile := nil;
        DeleteFile(SRequest);
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_Request_DatEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;
var AMemoryStream:TMemoryStream; AStream: TStringStream; ACompressFile:TFileStream; sTEMP:string;
begin
  with aConnect do
  begin
    AMemoryStream:=nil; AStream:=nil; ACompressFile:=nil;
    try
        ShowMsgTwEcb('∑«≥∆∂«øÈ∏ÍÆ∆');

          sTEMP:=CBDataMgrEcb.GetCBDataTextFileName(SRequest);
          ShowMsg('f:'+sTEMP);
          SRequest := CompressOutPutFile(sTEMP);
          if GetFileSize(sTEMP)=0 then
          begin
            if FileExists(sTemp) then DeleteFile(sTEMP);
          end;

        if FileExists(SRequest) Then
        Begin
          ACompressFile := TFileStream.Create(SRequest,fmOpenRead);
          OpenWriteBuffer;
          WriteStream(ACompressFile);
          CloseWriteBuffer;
        End;
        if Assigned(ACompressFile) Then
           ACompressFile.Free;
        ACompressFile := nil;
        DeleteFile(SRequest);
        ShowMsgTwEcb('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_Request_RecvFile(aConnect:TIdTCPConnection;SRequest:string):Integer;
var str,str2,sFileName,sTempFile,sPath:string;
  rByte:array[0..TcpIpPerSize-1] of byte;
  fs:TFileStream; ts:TStringList;
  cnt,iPos,iFileSize,iSize:integer; i,j:integer;

  procedure ShowProgress(aCur,aMax:integer);
  begin
    Application.ProcessMessages;
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
begin
  with aConnect do
  begin
        WriteLn(Echo_HELLO);
        ShowMsgTw('∑«≥∆RecvFile');
        str:=readln;
        ShowMsgTw(str);
        str:=FAppParam.TwConvertStr(str);
    ts:=TStringList.create;
    try
        DoStrArrayTs(str,';',ts);
        if ts.count>=2 then
        begin
              sFileName:=ts[1];
              sFileName:=StringReplace(sFileName,_RplTr1DBPath,FAppParam.Tr1DBPath,[rfReplaceAll]);
              sFileName:=StringReplace(sFileName,_RplDateTime,FormatDateTime('yyyymmddhhmmss',now),[rfReplaceAll]);
              iFileSize:=Strtoint(ts[0]);
              sPath:=ExtractFilePath(sFileName);
              if not DirectoryExists(sPath) then
                Mkdir_Directory(sPath);
              if DirectoryExists(sPath) then
              begin
                try
                      sTempFile:=GetWinTempPath+'tcpip'+Get_GUID8+'.rev';
                      fs:=TFileStream.create(sTempFile,fmCreate);
                      try
                        cnt:=0;
                        ShowProgress(iFileSize,-1);
                        while iFileSize>0 do
                        begin
                          if iFileSize>TcpIpPerSize then iSize:=TcpIpPerSize
                          else iSize:=iFileSize;
                          aConnect.ReadBuffer(rByte,iSize);
                          fs.Write(rByte,iSize);
                          inc(cnt,iSize);
                          ShowProgress(-1,cnt);
                          iFileSize:=iFileSize-iSize;
                        end;
                      finally
                        try freeAndNil(fs); except end;
                      end;

                      if CpyDatF((sTempFile),(sFileName) ) then
                      begin
                        WriteLn(Echo_HELLO);
                      end
                      else WriteLnErrEx('§Â¿…•iØ‡≥Q¶˚•Œ,µL™kºg§J.');
                finally
                  try DelDatF(sTempFile) except end;
                  ShowProgress(-1,-1);
                end;
              end;
        end;
        ShowMsgTw('ßπ¶®--RecvFile');
    finally
      FreeAndNil(ts);
    end;
  end;


end;

function TAMainFrm.NodeText2BinDat(aConnect:TIdTCPConnection;SRequest:string):Integer;
var i,Err:integer; MyCLassLst:TList;DefIR,DefCRPremium,DefBIR,DefLRisk:Double;
  ts:TStringList; sTemp:string;
begin
  MyCLassLst:=TList.create;
  ts:=TStringList.create;
  DefIR:=NoneNum;
  DefBIR:=NoneNum;
  DefCRPremium:=NoneNum;
  DefLRisk:=NoneNum;
  try
     sTemp:=FAppParam.Tr1DBPath+'CBData\market_db\dblst2.lst';
     ts.clear;
     GetFileListByDBLstFile(sTemp,ts);
     for i:=0 to ts.count-1 do
     begin
        if IsPassWayFile(ts[i]) then
          Continue;
        if FileExists(ts[i]) then
        begin
          InPutCBFromFile0304_5(ts[i],
            MyCLassLst,DefIR,DefCRPremium,DefBIR,DefLRisk,
            Err,nil);
        end;
     end;
     sTemp:=FAppParam.Tr1DBPath+'CBData\publish_db\dblst.lst';
     ts.clear;
     GetFileListByDBLstFile(sTemp,ts);
     for i:=0 to ts.count-1 do
     begin
        if IsPassWayFile(ts[i]) then
          Continue;
        if FileExists(ts[i]) then
        begin
          InPutCBFromFile0304_5(ts[i],
            MyCLassLst,DefIR,DefCRPremium,DefBIR,DefLRisk,
            Err,nil);
        end;
     end;
     sTemp:=FAppParam.Tr1DBPath+'CBData\nodetextforcbpa\';
     if not DirectoryExists(sTemp) then
       Mkdir_Directory(sTemp);
     SaveFClassAllDat(sTemp,MyCLassLst);
     FCBDataWorkHandle.PackCBNodeFile();
  finally
    if Assigned(ts) then FreeAndNil(ts);
    FreeCBClass(MyCLassLst);
  end;
end;

function TAMainFrm.NodeText2BinDatEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;
var i,Err:integer; MyCLassLst:TList;DefIR,DefCRPremium,DefBIR,DefLRisk:Double;
  ts:TStringList; sTemp:string;
begin
  MyCLassLst:=TList.create;
  ts:=TStringList.create;
  DefIR:=NoneNum;
  DefBIR:=NoneNum;
  DefCRPremium:=NoneNum;
  DefLRisk:=NoneNum;
  try
     sTemp:=FAppParamEcb.Tr1DBPath+'CBData\market_db\dblst2.lst';
     ts.clear;
     GetFileListByDBLstFile(sTemp,ts);
     for i:=0 to ts.count-1 do
     begin
        if IsPassWayFile(ts[i]) then
          Continue;
        if FileExists(ts[i]) then
        begin
          InPutCBFromFile0304_5(ts[i],
            MyCLassLst,DefIR,DefCRPremium,DefBIR,DefLRisk,
            Err,nil);
        end;
     end;
     sTemp:=FAppParamEcb.Tr1DBPath+'CBData\publish_db\dblst.lst';
     ts.clear;
     GetFileListByDBLstFile(sTemp,ts);
     for i:=0 to ts.count-1 do
     begin
        if IsPassWayFile(ts[i]) then
          Continue;
        if FileExists(ts[i]) then
        begin
          InPutCBFromFile0304_5(ts[i],
            MyCLassLst,DefIR,DefCRPremium,DefBIR,DefLRisk,
            Err,nil);
        end;
     end;
     sTemp:=FAppParamEcb.Tr1DBPath+'CBData\nodetextforcbpa\';
     if not DirectoryExists(sTemp) then
       Mkdir_Directory(sTemp);
     SaveFClassAllDat(sTemp,MyCLassLst);
     if Assigned(FCBDataWorkHandleEcb) then 
       FCBDataWorkHandleEcb.PackCBNodeFile();
  finally
    if Assigned(ts) then FreeAndNil(ts);
    FreeCBClass(MyCLassLst);
  end;
end;

function GetMySectionDat(aInputSrc,aSecBegin,sSecEnd:string;var ts:TStringList; var ts2:TStringList):string;
   var x1,x2:integer;
   begin
     result:='';
     ts2.clear;
     ts.text:=aInputSrc;
     for x1:=0 to ts.count-1 do
     begin
       if PosEx(aSecBegin,ts[x1])>0 then
       begin
         for x2:=x1+1 to ts.count-1 do
         begin
           if PosEx(sSecEnd,ts[x2])>0 then
           begin
             break;
           end;
           ts2.Add(ts[x2]);
         end;
         break;
       end;
     end;
     result:=Trim(ts2.text);
   end;

function SetLogOfCBBaseInfoDat(aInputFile:string):boolean;
var sPath,sLogFile,sLine:string; ts,ts2:TStringList; i,j,iBegin,iEnd:integer;
begin
  result:=false;
  if not FileExists(aInputFile) then
    exit;
  sPath:=ExtractFilePath(ParamStr(0))+'Data\Industry\Audit\cbbaseinfo\'+FmtDt8(date)+'\';
  if not DirectoryExists(sPath) then
    Mkdir_Directory(sPath);
  sLogFile:=sPath+FormatDateTime('yyyymmdd_hhmmss',now)+'.dat';
  ts:=TStringList.create;
  ts2:=TStringList.create;
  try
    ts.LoadFromFile(aInputFile);
    iBegin:=-1; iEnd:=-1;
    for i:=0 to ts.count-1 do
    begin
      if SameText('<log>',ts[i]) then
      begin
        iBegin:=i;
        for j:=i+1 to ts.count-1 do
        begin
          if SameText('</log>',ts[j]) then
          begin
            iEnd:=j;
            Break;
          end;
          ts2.Add(ts[j]);
        end;
      end;
    end;
    if (iBegin>=0) and (iEnd>=0) then
    begin
      for i:=iEnd downto iBegin do
        ts.Delete(i);
      ts2.SaveToFile(sLogFile);
      ts.SaveToFile(aInputFile);
      result:=True;
    end;
  finally
    FreeAndNil(ts);
    FreeAndNil(ts2);
  end;
end;

function TAMainFrm.Pro_RequestSetCBTxt(aConnect:TIdTCPConnection;SRequest:string):Integer;
var AMemoryStream:TMemoryStream; AStream: TStringStream; ts,ts2:TStringList;
   DocTag,sTemp,aNodeText,sDatText,aNodeTextForCBPA,sLogOpCur,sTimeKey:string;
   bToBin,bEcb:boolean;
begin
  with aConnect do
  begin
    bEcb:=false;
    AMemoryStream:=nil; AStream:=nil; ts:=nil; ts2:=nil;
    try
        sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');

        ShowMsgTw('∑«≥∆±µ¶¨∏ÍÆ∆');
        AStream := TStringStream.Create('');
        AMemoryStream := TMemoryStream.Create();
        //ReadStream(AMemoryStream, -1, True); //--DOC4.0.0°XN002 huangcq081223 del
        ReadStream(AMemoryStream, -1, False); //--DOC4.0.0°XN002 huangcq081223 add
        AMemoryStream.Position := 0;
        DeCompressStream(AMemoryStream);
        AMemoryStream.SaveToStream(AStream);
        AMemoryStream.Free;
        AMemoryStream := nil;
        sTemp:=AStream.DataString;
        aNodeText:=sTemp;
        sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,aNodeText,true);
        //aNodeText:=StringReplace(aNodeText,sLogOpCur,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);
        //--
        //SetTextByTs('d:\123.txt',aNodeText);

        ts:=TStringList.create;
        ts2:=TStringList.create;
        ShowMsgTw('ßπ¶®±µ¶¨∏ÍÆ∆');
        if not FAppParam.IsTwSys then
        begin
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_Announce>','</CBDB_Announce>',ts,ts2);
          CBDataMgr.NifaxingCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_Pass>','</CBDB_Pass>',ts,ts2);
          CBDataMgr.PassCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_market_sh>','</CBDB_market_sh>',ts,ts2);
          CBDataMgr.hushiCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_market_sz>','</CBDB_market_sz>',ts,ts2);
          CBDataMgr.shenshiCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_passaway>','</CBDB_passaway>',ts,ts2);
          CBDataMgr.PassawayCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_Stop_Issue>','</CBDB_Stop_Issue>',ts,ts2);
          CBDataMgr.stopCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_Prepare_List_china>','</CBDB_Prepare_List_china>',ts,ts2);
          CBDataMgr.guapaiCBText := sDatText;
        end
        else begin
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_Announce_tw>','</CBDB_Announce_tw>',ts,ts2);
          CBDataMgr.NifaxingCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_Send_tw>','</CBDB_Send_tw>',ts,ts2);
          CBDataMgr.songCBText  := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_Pass_tw>','</CBDB_Pass_tw>',ts,ts2);
          CBDataMgr.PassCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_TW_OTC>','</CBDB_TW_OTC>',ts,ts2);
          CBDataMgr.shangguiCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_TW_Market>','</CBDB_TW_Market>',ts,ts2);
          CBDataMgr.shangshiCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_TW_Stop>','</CBDB_TW_Stop>',ts,ts2);
          CBDataMgr.PassawayCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_StopIssue_tw>','</CBDB_StopIssue_tw>',ts,ts2);
          CBDataMgr.stopCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_Prepare_List_tw>','</CBDB_Prepare_List_tw>',ts,ts2);
          CBDataMgr.guapaiCBText := sDatText;
          sDatText:=GetMySectionDat(aNodeText,'<CBDB_QueryList_tw>','</CBDB_QueryList_tw>',ts,ts2);
          CBDataMgr.xunquanCBText := sDatText;
        end;
        
        ShowMsg2Tw('∞ı¶Ênodetext2bindat...');
        NodeText2BinDat(aConnect,SRequest);
        ShowMsg2Tw('nodetext2bindat ∞ı¶Êßπ≤¶.');

        if (not UpdateGuidOfWorkList_NodeData(True,'passaway',sLogOpCur,sTimeKey)) then //DocTag,
        begin
          ShowMsg2Tw('≤£•Õ§W∂«•Ù∞»≤M≥Ê•¢±—.'+DocTag);
        end;
        WriteLn('SAVEOK'); //--DOC4.0.0°™N002 huangcq081223 add

        AStream.Free;
        AStream := nil;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
      try
        if Assigned(ts) then
          FreeAndNil(ts);
      except
      end;
      try
        if Assigned(ts2) then
          FreeAndNil(ts2);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestSetCBTxtEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;
var AMemoryStream:TMemoryStream; AStream: TStringStream; ts,ts2:TStringList;
   DocTag,sTemp,aNodeText,sDatText,aNodeTextForCBPA,sLogOpCur,sTimeKey:string;
   bToBin,bEcb:boolean;
begin
  with aConnect do
  begin
    bEcb:=false;
    AMemoryStream:=nil; AStream:=nil; ts:=nil; ts2:=nil;
    try
        sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');

        ShowMsgTwEcb('∑«≥∆±µ¶¨∏ÍÆ∆');
        AStream := TStringStream.Create('');
        AMemoryStream := TMemoryStream.Create();
        //ReadStream(AMemoryStream, -1, True); //--DOC4.0.0°XN002 huangcq081223 del
        ReadStream(AMemoryStream, -1, False); //--DOC4.0.0°XN002 huangcq081223 add
        AMemoryStream.Position := 0;
        DeCompressStream(AMemoryStream);
        AMemoryStream.SaveToStream(AStream);
        AMemoryStream.Free;
        AMemoryStream := nil;
        sTemp:=AStream.DataString;
        aNodeText:=sTemp;
        sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,aNodeText,true);
        //aNodeText:=StringReplace(aNodeText,sLogOpCur,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);
        //--
        //SetTextByTs('d:\123.txt',aNodeText);

        ts:=TStringList.create;
        ts2:=TStringList.create;
        ShowMsgTwEcb('ßπ¶®±µ¶¨∏ÍÆ∆');
        sDatText:=GetMySectionDat(aNodeText,'<CBDB_ECB_Market>','</CBDB_ECB_Market>',ts,ts2);
        if sDatText<>'' then 
          CBDataMgrEcb.SetshangshiCBTxt(sDatText);

        ShowMsg2TwEcb('∞ı¶Êecbnodetext2bindat...');
        NodeText2BinDatEcb(aConnect,SRequest);
        ShowMsg2TwEcb('ecbnodetext2bindat ∞ı¶Êßπ≤¶.');

        if (not UpdateGuidOfWorkList_NodeDataEcb(True,'ecbpassaway',sLogOpCur,sTimeKey)) then //DocTag,
        begin
          ShowMsg2TwEcb('≤£•Õ§W∂«•Ù∞»≤M≥Ê•¢±—.'+DocTag);
        end;
        WriteLn('SAVEOK'); //--DOC4.0.0°™N002 huangcq081223 add

        AStream.Free;
        AStream := nil;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
      try
        if Assigned(ts) then
          FreeAndNil(ts);
      except
      end;
      try
        if Assigned(ts2) then
          FreeAndNil(ts2);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestSetcbinfoDat(aConnect:TIdTCPConnection;SRequest:string):Integer;
var AMemoryStream:TMemoryStream; DocTag,DstFile1:string;
begin
  
end;

function TAMainFrm.Pro_RequestSetCBDat(aConnect:TIdTCPConnection;SRequest:string):Integer;
var AMemoryStream:TMemoryStream; DocTag,DstFile1,sLogOpCur,sTimeKey,sLogOpLst,sLine :string;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        ShowMsgTw(DocTag);
        WriteLn('HELLO');
        sLine :=(ReadLn);
        ShowMsgTw(sLine);

        sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,sLine,true);
        sLine:=StringReplace(sLine,sLogOpCur,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);
        
        sLogOpLst:=GetStrOnly2(_LogSecBegin,_LogSecEnd,sLine,false);
        if sLogOpLst<>'' then
        begin
          sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
          Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
        end;
        
        WriteLn('HELLO');
        ShowMsgTw('∑«≥∆±µ¶¨∏ÍÆ∆');
        DstFile1 := GetWinTempPath+Get_GUID8+'.dat';

        AMemoryStream := TMemoryStream.Create();
        //ReadStream(AMemoryStream, -1, True); //--DOC4.0.0°™N002 huangcq081223 del
        ReadStream(AMemoryStream, -1, False); //--DOC4.0.0°™N002 huangcq081223 add
        AMemoryStream.Position := 0;
        DeCompressStream(AMemoryStream);
        AMemoryStream.SaveToFile(DstFile1);
        AMemoryStream.Free;
        AMemoryStream := nil;

        if SameText(LowerCase(DocTag),'cbinfo.dat') Then
        begin
           if CBDataMgr.SetCBDataTextFileName(DocTag,DstFile1,sLogOpCur,sTimeKey) then
           begin
             sLogOpLst:=''+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
               FAppParam.ConvertString(_PaoMaMCaption)+_LogSep+_PaoMaM+_LogSep+'0';
             Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
           end;
        end
        else if DocTag=UpperCase('cbtodayhint.dat') Then
        begin
           if CBDataMgr.SetCBTodayHintTextFileName(DocTag,DstFile1,sLogOpCur,sTimeKey) then
           begin
             sLogOpLst:=''+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
               FAppParam.ConvertString(_TodayHintMCaption)+_LogSep+_TodayHintM+_LogSep+'0';
             Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
           end;
        end
        Else if (Pos(UpperCase('cbthreetrader@'),DocTag)=1)then
        begin
           sLine:=DocTag;
           sLine:=StringReplace(sLine,'cbthreetrader@','',[rfReplaceAll, rfIgnoreCase]);
           sLine:=StringReplace(sLine,'.dat','',[rfReplaceAll, rfIgnoreCase]);
           if CBDataMgr.SetCBThreeTraderFileName(DocTag,DstFile1,sLogOpCur,sTimeKey) then
           begin
             sLogOpLst:=sLine+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                FAppParam.ConvertString(_ThreeTraderMCaption)+_LogSep+_ThreeTraderM+_LogSep+'0';
             Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
           end;
        end
        Else if (Pos(UpperCase('balancedat@'),DocTag)=1)then
        begin
           CBDataMgr.SetCBBalanceDatFileName(DocTag,DstFile1,sLogOpCur,sTimeKey);
        end
        else if DocTag=UpperCase('shenbaoset.dat') Then
           CBDataMgr.SetCBDataTextFileName_10(DocTag,DstFile1,sLogOpCur,sTimeKey)
        else if (DocTag=UpperCase('tcridata.dat')) or
                (DocTag=UpperCase('StkIndustry.dat')) or
                (DocTag=UpperCase('StkBase1.dat')) or
                (DocTag=UpperCase('bankplevel.dat')) or
                (DocTag=UpperCase('plevelcomcode.dat')) Then
        begin
           if CBDataMgr.SetTCRITFN(DocTag,DstFile1,sLogOpCur,sTimeKey) then
           begin
             if (DocTag=UpperCase('StkIndustry.dat')) or
                (DocTag=UpperCase('StkBase1.dat'))  Then
             begin
               SetStatusOfTCRI(DocTag,'4');
             end;
             if (DocTag=UpperCase('tcridata.dat')) then
             begin
               {sLogOpLst:=''+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                FAppParam.ConvertString(_TCRIMCaption)+_LogSep+_TCRIM+_LogSep+'0';
               Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);  }
             end
             else if (DocTag=UpperCase('StkIndustry.dat')) then
             begin
               sLogOpLst:=''+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                FAppParam.ConvertString(_IndustryMCaption)+_LogSep+_IndustryM+_LogSep+'0';
               Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
             end
             else if (DocTag=UpperCase('StkBase1.dat')) then
             begin
               sLogOpLst:=''+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                FAppParam.ConvertString(_StkBase1MCaption)+_LogSep+_StkBase1M+_LogSep+'0';
               Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
             end
             else if (DocTag=UpperCase('bankplevel.dat')) then
             begin
               sLogOpLst:=''+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                FAppParam.ConvertString(_PBankLevelMCaption)+_LogSep+_PBankLevelM+_LogSep+'0';
               Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
             end;
           end;
        end
        else if (DocTag=UpperCase('CBBASEINFO.DAT')) then
        begin
           if FAppParam.IsTwSys then
           begin
             if not SetLogOfCBBaseInfoDat(DstFile1) then
               exit;
             SetStatusOfTCRI(DocTag,'4');
           end;
           if CBDataMgr.SetCBDataTextFileName(DocTag,DstFile1,sLogOpCur,sTimeKey) then
           begin
             sLogOpLst:=''+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                FAppParam.ConvertString(_cbbaseinfoMCaption)+_LogSep+_cbbaseinfoM+_LogSep+'0';
             Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
           end;
        end
        else if (DocTag=UpperCase('WeekOfCBBASEINFO.DAT')) then
        begin
           if FAppParam.IsTwSys then
           begin
             if not SetLogOfCBBaseInfoDat(DstFile1) then
               exit;
             SetStatusOfTCRI(DocTag,'4');
           end;
           DocTag:='CBBASEINFO.DAT';
           if CBDataMgr.SetCBDataTextFileName(DocTag,DstFile1,sLogOpCur,sTimeKey) then
           begin
             sLogOpLst:=''+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                FAppParam.ConvertString(_cbbaseinfoMCaption)+_LogSep+_cbbaseinfoM+_LogSep+'0';
             Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
           end;
        end else
           raise Exception.Create(DocTag+'SetCBDat can not be dealwith.');
        ShowMsgTw('ßπ¶®±µ¶¨∏ÍÆ∆');
        WriteLn('SAVEOK');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestSetCBDatEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;
var AMemoryStream:TMemoryStream; DocTag,DstFile1,sLogOpCur,sTimeKey,sLogOpLst,sLine :string;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        ShowMsgTwEcb(DocTag);
        WriteLn('HELLO');
        sLine :=(ReadLn);
        ShowMsgTwEcb(sLine);
        
        sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,sLine,true);
        sLine:=StringReplace(sLine,sLogOpCur,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);
        
        sLogOpLst:=GetStrOnly2(_LogSecBegin,_LogSecEnd,sLine,false);
        if sLogOpLst<>'' then
        begin
          sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
          Pro_RequestUPTLOGRECSFILEEcb(sLogOpLst,sTimeKey);
        end;
        
        WriteLn('HELLO');
        ShowMsgTwEcb('∑«≥∆±µ¶¨∏ÍÆ∆');
        DstFile1 := GetWinTempPath+Get_GUID8+'.dat';

        AMemoryStream := TMemoryStream.Create();
        //ReadStream(AMemoryStream, -1, True); //--DOC4.0.0°™N002 huangcq081223 del
        ReadStream(AMemoryStream, -1, False); //--DOC4.0.0°™N002 huangcq081223 add
        AMemoryStream.Position := 0;
        DeCompressStream(AMemoryStream);
        AMemoryStream.SaveToFile(DstFile1);
        AMemoryStream.Free;
        AMemoryStream := nil;

        raise Exception.Create(DocTag+'SetCBDatEcb can not be dealwith.');
        ShowMsgTwEcb('ßπ¶®±µ¶¨∏ÍÆ∆');
        WriteLn('SAVEOK');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestGetNodeText(aConnect:TIdTCPConnection;SRequest:string):Integer;
var ACompressFile:TFileStream; sTEMP:string;
begin
  with aConnect do
  begin
    ACompressFile:=nil;
    try
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        if  OutPutDBFile(FAppParam.Tr1DBPath,SRequest) then
        SRequest := CompressOutPutFile(SRequest); //CompressOutPutFile(CBDataMgr.GetCBDataTextFileName(SRequest));
        if FileExists(SRequest) Then
        Begin
          ACompressFile := TFileStream.Create(SRequest,fmOpenRead);
          OpenWriteBuffer;
          WriteStream(ACompressFile);
          CloseWriteBuffer;
        End;
        if Assigned(ACompressFile) Then
         ACompressFile.Free;
        ACompressFile := nil;
        DeleteFile(SRequest);
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestGetDocRtf(aConnect:TIdTCPConnection;SRequest:string):Integer;
var ACompressFile:TFileStream; sTEMP:string;
begin
  with aConnect do
  begin
    ACompressFile:=nil;
    try
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        sTEMP:=CBDataMgr.GetADocRtfFileName(SRequest);
        ShowMsg('f:'+sTEMP);
        SRequest := CompressOutPutFile(sTEMP);
        if GetFileSize(sTEMP)=0 then
        begin
          if FileExists(sTemp) then DeleteFile(sTEMP);
        end;
        if FileExists(SRequest) Then
        Begin
          ACompressFile := TFileStream.Create(SRequest,fmOpenRead);
          OpenWriteBuffer;
          WriteStream(ACompressFile);
          CloseWriteBuffer;
        End;
        if Assigned(ACompressFile) Then
           ACompressFile.Free;
        ACompressFile := nil;
        DeleteFile(SRequest);
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestGetShenBaoDocText(aConnect:TIdTCPConnection;SRequest:string):Integer;
var ACompressFile:TFileStream; sTEMP:string;
begin
  with aConnect do
  begin
    ACompressFile:=nil;
    try
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        sTEMP:=CBDataMgr.GetADocTextFileName(SRequest);
        ShowMsg('f:'+sTEMP);
        SRequest := CompressOutPutFile(sTEMP);
        if GetFileSize(sTEMP)=0 then
        begin
          if FileExists(sTemp) then DeleteFile(sTEMP);
        end;
        if FileExists(SRequest) Then
        Begin
          ACompressFile := TFileStream.Create(SRequest,fmOpenRead);
          OpenWriteBuffer;
          WriteStream(ACompressFile);
          CloseWriteBuffer;
        End;
        if Assigned(ACompressFile) Then
           ACompressFile.Free;
        ACompressFile := nil;
        DeleteFile(SRequest);
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestGetShenBaoDoc2Text(aConnect:TIdTCPConnection;SRequest:string):Integer;
var ACompressFile:TFileStream; sTEMP:string;
begin
  with aConnect do
  begin
    ACompressFile:=nil;
    try
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        sTEMP:=CBDataMgr.GetADoc2TextFileName(SRequest);
        ShowMsg('f:'+sTEMP);
        SRequest := CompressOutPutFile(sTEMP);
        if GetFileSize(sTEMP)=0 then
        begin
          if FileExists(sTemp) then DeleteFile(sTEMP);
        end;
        if FileExists(SRequest) Then
        Begin
          ACompressFile := TFileStream.Create(SRequest,fmOpenRead);
          OpenWriteBuffer;
          WriteStream(ACompressFile);
          CloseWriteBuffer;
        End;
        if Assigned(ACompressFile) Then
           ACompressFile.Free;
        ACompressFile := nil;
        DeleteFile(SRequest);
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestSetDealer(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string;
begin
  with aConnect do
  begin
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        if(SaveNewDate(DocTag))then
          WriteLn('HELLO');
    finally
    end;
  end;
end;

function TAMainFrm.Pro_RequestSetThreeTrader(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string;
begin
  with aConnect do
  begin
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        if(SaveNewThreeTraderDate(DocTag))then
          WriteLn('HELLO');
    finally
    end;
  end;
end;

function TAMainFrm.Pro_RequestSetIFRSWorkHis(aSY,aSQ,aEY,aEQ:Integer):Integer;
var FileLst2:_cStrLst; b1:boolean; sIdFile,sRst:string; aIFRSHandle : HWND;
begin
  try
    sIdFile:=GetIniFileByTiniFile('CONFIG','RealTimePath','',ExtractFilePath(ParamStr(0))+'setup.ini');
    sIdFile:=sIdFile+'CloseIdList\'+FormatDateTime('yyyymmdd',date)+'\'+'CloseIdList.dat';
    if not FileExists(sIdFile) then
    begin
      ShowMessage(Format('realtime§§•NΩX¶C™Ì§Â¿…§£¶s¶b.'+sIdFile,[]));
      exit;
    end;
    {if not ((aEY>=aSY) and (aEQ>=aSQ)) then
    begin
      ShowMessage();
      exit;
    end; }
    SetLength(FileLst2,4);
    FileLst2[0]:=_CNoNeedShen;
    FileLst2[1]:=_CNoNeedShen2;
    FileLst2[2]:=_CShen;
    FileLst2[3]:=_CShen2;
    b1:=GetIFRSListStatus_ForDownIFS(FileLst2,sRst);
    SetLength(FileLst2,0);
    if not b1 then
    begin
      if IDOK<>MessageBox(Self.Handle ,PChar('•ÿ´e´·•x®ÃµM¶≥•ºßπ¶®™∫•Ù∞»,¨Oß_≠nƒ~ƒÚ?'+#13#10+'≠Yƒ~ƒÚ´h§§¬_¶}ßR∞£´·•x•ø¶b∂i¶Ê™∫•Ù∞»'),
              PChar('∏ﬂ∞›'),
              MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)  then
      begin
         if not CheckTask('DownIFRS.exe') then
         begin
            StartIFRSDownExe2();
         end
         else begin
            aIFRSHandle:=FindWindow('TAMainFrm',PChar('DownIFRS'));
            if aIFRSHandle<>0 then
              SendMessage (aIFRSHandle, WM_ToDownIFRS, aIFRSHandle,0);
         end;
         exit;
      end
      else begin
        //ShowMessage('11');
      end;
    end;
    KillTask('DownIFRS.exe');
    StartIFRSDownHisExe(Format('%d,%d;%d,%d',[aSY,aSQ,aEY,aEQ]),false);
  finally
    SetLength(FileLst2,0);
  end;
end;


function TAMainFrm.Pro_RequestSetIFRSWork(aConnect:TIdTCPConnection;SRequest:string):Integer;
var FileLst,FileLst2:_cStrLst;DocTag:string;  b1,bForceCreateIFRSW:boolean; sRst:String;
  aIFRSHandle : HWND;
begin
  with aConnect do
  begin
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        ShowMsg(DocTag);
        FileLst:=DoStrArray(DocTag,',');
        if (Length(FileLst)=4) and
           (
             MayBeDigital(FileLst[0]) and
             MayBeDigital(FileLst[1]) and
             MayBeDigital(FileLst[2]) and
             MayBeDigital(FileLst[3])
           ) then
        begin
          bForceCreateIFRSW:=FileLst[2]='1';
          if bForceCreateIFRSW then
          begin
            KillTask('DownIFRS.exe');
            CreateIFRSListing(StrToInt(FileLst[0]),StrToInt(FileLst[1]),StrToInt(FileLst[3]));
            StartIFRSDownExe(StrToInt(FileLst[0]),StrToInt(FileLst[1]),bForceCreateIFRSW,StrToInt(FileLst[3]));
            WriteLn('HELLO');
          end
          else begin
            SetLength(FileLst2,4);
            FileLst2[0]:=_CNoNeedShen;
            FileLst2[1]:=_CNoNeedShen2;
            FileLst2[2]:=_CShen;
            FileLst2[3]:=_CShen2;
            b1:=GetIFRSListStatus_ForDownIFS(FileLst2,sRst);
            SetLength(FileLst2,0);
            if not b1 then
            begin
              if not CheckTask('DownIFRS.exe') then
              begin
                StartIFRSDownExe2();
              end
              else begin
                aIFRSHandle:=FindWindow('TAMainFrm',PChar('DownIFRS'));
                if aIFRSHandle<>0 then
                  SendMessage (aIFRSHandle, WM_ToDownIFRS, aIFRSHandle,0);
              end;
              WriteLn(sRst);
            end
            else begin
              KillTask('DownIFRS.exe');
              CreateIFRSListing(StrToInt(FileLst[0]),StrToInt(FileLst[1]),StrToInt(FileLst[3]));
              StartIFRSDownExe(StrToInt(FileLst[0]),StrToInt(FileLst[1]),bForceCreateIFRSW,StrToInt(FileLst[3]));
              WriteLn('HELLO');
            end;
          end;
        end
        else begin
          WriteLn('ParamError');
        end;
    finally
      try
        SetLength(FileLst,0);
        SetLength(FileLst2,0);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestAuditIFRSData(aConnect:TIdTCPConnection;SRequest:string):Integer;
var FileLst,StrLst:_cStrLst;DocTag,sTimeKey,sLogOpCur,sCmdParams,sLogOpLst:string;
begin
  with aConnect do
  begin
    try
        sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
        WriteLn('HELLO');
        DocTag :=(ReadLn);
        ShowMsg(DocTag);

        sCmdParams:=GetStrOnly2(_CmdParamSecBegin,_CmdParamSecEnd,DocTag,false);
        sLogOpLst:=GetStrOnly2(_LogSecBegin,_LogSecEnd,DocTag,false);
        sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,sLogOpLst,true);
        sLogOpLst:=StringReplace(sLogOpLst,sLogOpCur,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);
        sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
      
        //sLogOpCur:='-';
        {WriteLn('HELLO');
        sLogOpCur := (ReadLn);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
        sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);}

        FileLst:=DoStrArray(sCmdParams,',');
        StrLst:=DoStrArray(sLogOpLst,_LogSep);
        if (Length(FileLst)=3) and
           (
             (FileLst[2]<>'') and 
             MayBeDigital(FileLst[0]) and
             MayBeDigital(FileLst[1])
           ) and
           (Length(StrLst)>=8) then
        begin
          if UpdateGuidOfWorkList_IFRS(sLogOpCur,sTimeKey,FileLst[2],FileLst[0],FileLst[1],
            StrLst[1],StrLst[2],StrLst[5],StrLst[6]) then
          begin
            SetStatusOfIFRS(FileLst[2],_CShen);
            ShowMsgTw('ok.');
            WriteLn('HELLO');
          end
          else begin
            //WriteLn('FAIL');
            ShowMsgTw('•Õ¶®IFRS§W∂«•Ù∞»≤M≥Ê•¢±—.');
            WriteLn('•Õ¶®IFRS§W∂«•Ù∞»≤M≥Ê•¢±—');
          end;
        end
        else begin
          WriteLn('ParamError');
        end;
    finally
      try SetLength(FileLst,0); except end;
      try SetLength(StrLst,0); except end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestGETTcriOPLOG(aConnect:TIdTCPConnection;SRequest:string):Integer;
var vInfo,DstFile1,DstFile2,sUplFile,sTemp:string;  vInfoLst : _CstrLst;
  AMemoryStream:TMemoryStream;tsNeedTransfer,tsTimeKey:TStringList; i:integer;
begin
  with aConnect do
  begin
    AMemoryStream:=nil; tsNeedTransfer:=nil; tsTimeKey:=nil; 
    try
        WriteLn('HELLO');
        vInfo:=ReadLn;
        ShowMsgTw('TcriOPLOG∑«≥∆∂«∞e'+vInfo);
        vInfoLst:=DoStrArray(vInfo,',');
        AMemoryStream:=nil;
        try
          tsNeedTransfer:=TStringList.create;
          tsTimeKey:=TStringList.create;
          
          DstFile1:=GetWinTempPath+'TcriOPLOG'+'.log';
          if FileExists(DstFile1) then
            DeleteFile(DstFile1); 
          sUplFile:=GetWinTempPath+Get_GUID8+'.upl';
          if Length(vInfoLst)>=2 then
          begin
            CBDataMgr.GetCBDataOpLogByM(vInfoLst[0],vInfoLst[1],DstFile1,'tcrim',tsTimeKey);
          end;
          if not FileExists(DstFile1) then
            CreateAnEmptFile(DstFile1);


          tsNeedTransfer.add(DstFile1);
          for i:=0 to tsTimeKey.count-1 do
          begin
            DstFile2:=FAppParam.Tr1DBPath+'CBData\tcri\pic\'+tsTimeKey[i]+'tcripic.dat';
            if FileExists(DstFile2) then
              tsNeedTransfer.add(DstFile2); 
          end;
          
          sUplFile:=ComparessFileListToFile(tsNeedTransfer,sUplFile,'tw',sTemp);

          AMemoryStream := TMemoryStream.Create();
          AMemoryStream.LoadFromFile(sUplFile);
          CompressStream(AMemoryStream);
          OpenWriteBuffer;
          WriteStream(AMemoryStream);
          CloseWriteBuffer;
        finally
          if FileExists(DstFile1) then
             DeleteFile(DstFile1);
          if FileExists(sUplFile) then
             DeleteFile(sUplFile);
          SetLength(vInfoLst,0);
          try if Assigned(AMemoryStream) then FreeAndNil(AMemoryStream); except end;
        end;
        ShowMsgTw('GETTcriOPLOGßπ¶®∂«∞e');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
      try
        if Assigned(tsTimeKey) then
          FreeAndNil(tsTimeKey);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestGETCBDATAOPLOG(aConnect:TIdTCPConnection;SRequest:string):Integer;
var vInfo,DstFile1,DstFile2,sUplFile,sTemp:string;  vInfoLst : _CstrLst;
  AMemoryStream:TMemoryStream;tsNeedTransfer:TStringList;
begin
  with aConnect do
  begin
    AMemoryStream:=nil; tsNeedTransfer:=nil;
    try
        WriteLn('HELLO');
        vInfo:=ReadLn;
        ShowMsgTw('CBDATAOPLOG∑«≥∆∂«∞e'+vInfo);
        vInfoLst:=DoStrArray(vInfo,',');
        AMemoryStream:=nil;
        try
          DstFile1:=GetWinTempPath+'CBDATAOPLOG'+'.log';
          DstFile2:=GetWinTempPath+'CBDATALOG'+'.log';
          sUplFile:=GetWinTempPath+Get_GUID8+'.upl';

          if Length(vInfoLst)>=2 then
          begin
            CBDataMgr.GetCBDataOpLog(vInfoLst[0],vInfoLst[1],DstFile1);
            CBDataMgr.GetCBDataLog(vInfoLst[0],vInfoLst[1],DstFile2);
          end;
          if not FileExists(DstFile1) then
            CreateAnEmptFile(DstFile1);
          if not FileExists(DstFile2) then
            CreateAnEmptFile(DstFile2);
          tsNeedTransfer:=TStringList.create;
          tsNeedTransfer.add(DstFile1);
          tsNeedTransfer.add(DstFile2);
          sUplFile:=ComparessFileListToFile(tsNeedTransfer,sUplFile,'tw',sTemp);

          AMemoryStream := TMemoryStream.Create();
          AMemoryStream.LoadFromFile(sUplFile);
          CompressStream(AMemoryStream);
          OpenWriteBuffer;
          WriteStream(AMemoryStream);
          CloseWriteBuffer;
        finally
          if FileExists(DstFile1) then
             DeleteFile(DstFile1);
          if FileExists(DstFile2) then
             DeleteFile(DstFile2);
          if FileExists(sUplFile) then
             DeleteFile(sUplFile);
          SetLength(vInfoLst,0);
          try if Assigned(AMemoryStream) then FreeAndNil(AMemoryStream); except end;
        end;
        ShowMsgTw('GETCBDATAOPLOGßπ¶®∂«∞e');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestGETCBDATAOPLOGEcb(aConnect:TIdTCPConnection;SRequest:string):Integer;
var vInfo,DstFile1,DstFile2,sUplFile,sTemp:string;  vInfoLst : _CstrLst;
  AMemoryStream:TMemoryStream;tsNeedTransfer:TStringList;
begin
  with aConnect do
  begin
    AMemoryStream:=nil; tsNeedTransfer:=nil;
    try
        WriteLn('HELLO');
        vInfo:=ReadLn;
        ShowMsgTwEcb('CBDATAOPLOGEcb∑«≥∆∂«∞e'+vInfo);
        vInfoLst:=DoStrArray(vInfo,',');
        AMemoryStream:=nil;
        try
          DstFile1:=GetWinTempPath+'CBDATAOPLOGEcb'+'.log';
          DstFile2:=GetWinTempPath+'CBDATALOGEcb'+'.log';
          sUplFile:=GetWinTempPath+Get_GUID8+'.upl';

          if Length(vInfoLst)>=2 then
          begin
            CBDataMgrEcb.GetCBDataOpLog(vInfoLst[0],vInfoLst[1],DstFile1);
            CBDataMgrEcb.GetCBDataLog(vInfoLst[0],vInfoLst[1],DstFile2);
          end;
          if not FileExists(DstFile1) then
            CreateAnEmptFile(DstFile1);
          if not FileExists(DstFile2) then
            CreateAnEmptFile(DstFile2);
          tsNeedTransfer:=TStringList.create;
          tsNeedTransfer.add(DstFile1);
          tsNeedTransfer.add(DstFile2);
          sUplFile:=ComparessFileListToFile(tsNeedTransfer,sUplFile,'ecb',sTemp);

          AMemoryStream := TMemoryStream.Create();
          AMemoryStream.LoadFromFile(sUplFile);
          CompressStream(AMemoryStream);
          OpenWriteBuffer;
          WriteStream(AMemoryStream);
          CloseWriteBuffer;
        finally
          if FileExists(DstFile1) then
             DeleteFile(DstFile1);
          if FileExists(DstFile2) then
             DeleteFile(DstFile2);
          if FileExists(sUplFile) then
             DeleteFile(sUplFile);
          SetLength(vInfoLst,0);
          try if Assigned(AMemoryStream) then FreeAndNil(AMemoryStream); except end;
        end;
        ShowMsgTwEcb('GETCBDATAOPLOGEcbßπ¶®∂«∞e');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestGETIFRSOPLOG(aConnect:TIdTCPConnection;SRequest:string):Integer;
var vInfo,DstFile1,DstFile2,sUplFile,sTemp:string;  vInfoLst : _CstrLst;
  AMemoryStream:TMemoryStream;tsNeedTransfer:TStringList;
begin
  with aConnect do
  begin
    AMemoryStream:=nil; tsNeedTransfer:=nil;
    try
        WriteLn('HELLO');
        vInfo:=ReadLn;
        ShowMsgTw('IFRSOPLOG∑«≥∆∂«∞e'+vInfo);
        vInfoLst:=DoStrArray(vInfo,',');
        AMemoryStream:=nil;
        try
          DstFile1:=GetWinTempPath+'IFRSOPLOG'+'.log';
          DstFile2:=GetWinTempPath+'IFRSLOG'+'.log';
          sUplFile:=GetWinTempPath+Get_GUID8+'.upl';

          if Length(vInfoLst)>=2 then
          begin
            CBDataMgr.GetIFRSOpLog(vInfoLst[0],vInfoLst[1],DstFile1);
            CBDataMgr.GetCBDataLog(vInfoLst[0],vInfoLst[1],DstFile2);
          end;
          if not FileExists(DstFile1) then
            CreateAnEmptFile(DstFile1);
          if not FileExists(DstFile2) then
            CreateAnEmptFile(DstFile2);
          tsNeedTransfer:=TStringList.create;
          tsNeedTransfer.add(DstFile1);
          tsNeedTransfer.add(DstFile2);
          sUplFile:=ComparessFileListToFile(tsNeedTransfer,sUplFile,'tw',sTemp);

          AMemoryStream := TMemoryStream.Create();
          AMemoryStream.LoadFromFile(sUplFile);
          CompressStream(AMemoryStream);
          OpenWriteBuffer;
          WriteStream(AMemoryStream);
          CloseWriteBuffer;
        finally
          if FileExists(DstFile1) then
             DeleteFile(DstFile1);
          if FileExists(DstFile2) then
             DeleteFile(DstFile2);
          if FileExists(sUplFile) then
             DeleteFile(sUplFile);
          SetLength(vInfoLst,0);
          try if Assigned(AMemoryStream) then FreeAndNil(AMemoryStream); except end;
        end;
        ShowMsgTw('GETIFRSOPLOGßπ¶®∂«∞e');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestGETIFRSTr1dbData(aConnect:TIdTCPConnection;SRequest:string):Integer;
var vInfo,sUplFile,sTemp,sDatPath:string;  vInfoLst : _CstrLst;
  AMemoryStream:TMemoryStream;tsNeedTransfer:TStringList;
  AryDstFile:array[0..4] of string; i:integer;
begin
  with aConnect do
  begin
    AMemoryStream:=nil; tsNeedTransfer:=nil;
    try
        WriteLn('HELLO');
        vInfo:=ReadLn;
        ShowMsgTw('IFRSTr1dbData∑«≥∆∂«∞e'+vInfo);
        vInfoLst:=DoStrArray(vInfo,',');
        AMemoryStream:=nil;
        try
          sDatPath:=FAppParam.Tr1DBPath+'CBData\IFRS\';
          AryDstFile[0]:=sDatPath+'IFRSNode.dat';
          AryDstFile[1]:=sDatPath+'IFRSTopNode.dat';
          sUplFile:=GetWinTempPath+Get_GUID8+'.upl';

          if Length(vInfoLst)=3 then
          begin
            AryDstFile[2]:=GetWinTempPath+Format('%s_%s_%s_1.dat',[vInfoLst[1],vInfoLst[2],vInfoLst[0]]);
            AryDstFile[3]:=GetWinTempPath+Format('%s_%s_%s_2.dat',[vInfoLst[1],vInfoLst[2],vInfoLst[0]]);
            AryDstFile[4]:=GetWinTempPath+Format('%s_%s_%s_3.dat',[vInfoLst[1],vInfoLst[2],vInfoLst[0]]);
            for i:=2 to 4 do
            begin
              if FileExists(AryDstFile[i]) then
                DelDatF(AryDstFile[i])
            end;
            if CBDataMgr.GetIFRSTr1dbData(vInfoLst[1],vInfoLst[2],vInfoLst[0],sDatPath,
              AryDstFile[2],AryDstFile[3],AryDstFile[4] ) then
            begin
              //if not FileExists(DstFile1) then  CreateAnEmptFile(DstFile1);
              tsNeedTransfer:=TStringList.create;
              for i:=0 to High(AryDstFile) do
              begin
                if FileExists(AryDstFile[i]) then
                  tsNeedTransfer.add(AryDstFile[i]);
              end;
              sUplFile:=ComparessFileListToFile(tsNeedTransfer,sUplFile,'ifrslog',sTemp);

              AMemoryStream := TMemoryStream.Create();
              AMemoryStream.LoadFromFile(sUplFile);
              CompressStream(AMemoryStream);
              OpenWriteBuffer;
              WriteStream(AMemoryStream);
              CloseWriteBuffer;
            end;  
          end
          else
            exit;
        finally
          for i:=2 to High(AryDstFile) do
          begin
            if FileExists(AryDstFile[i]) then
              DelDatF(AryDstFile[i]);
          end;
          if FileExists(sUplFile) then
             DelDatF(sUplFile);
          SetLength(vInfoLst,0);
          try if Assigned(AMemoryStream) then FreeAndNil(AMemoryStream); except end;
        end;
        ShowMsgTw('IFRSTr1dbDataßπ¶®∂«∞e');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestREADLOGDOC_01(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string; 
  AMemoryStream:TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        //
        AMemoryStream := TMemoryStream.Create();
        CompressStream(DocDataMgr_1.LoadLogDocFile(DocTag,1,0),AMemoryStream);

        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;

        AMemoryStream.Free;
        AMemoryStream := nil;
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestREADCancelLOGDOC_02(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string; 
  AMemoryStream:TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');

        AMemoryStream := TMemoryStream.Create();
        CompressStream(DocDataMgr_1.LoadLogDocFile(DocTag,2,2),AMemoryStream);

        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;

        AMemoryStream.Free;
        AMemoryStream := nil;
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestREADLOGDOC_02(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string; 
  AMemoryStream:TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');

        AMemoryStream := TMemoryStream.Create();
        CompressStream(DocDataMgr_1.LoadLogDocFile(DocTag,2,0),AMemoryStream);

        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;

        AMemoryStream.Free;
        AMemoryStream := nil;
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestREADLOGDOC_03(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string; 
  AMemoryStream:TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        AMemoryStream := TMemoryStream.Create();
        CompressStream(DocDataMgr_1.LoadLogDocFile(DocTag,3,0),AMemoryStream);

        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;

        AMemoryStream.Free;
        AMemoryStream := nil;
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestREADDELLOGDOC_01(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string; 
  AMemoryStream:TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        AMemoryStream := TMemoryStream.Create();
        CompressStream(DocDataMgr_1.LoadLogDocFile(DocTag,1,1),AMemoryStream);

        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;

        AMemoryStream.Free;
        AMemoryStream := nil;
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestREADDELCancelLOGDOC_02(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string; 
  AMemoryStream:TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');

        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        AMemoryStream := TMemoryStream.Create();
        CompressStream(DocDataMgr_1.LoadLogDocFile(DocTag,2,3),AMemoryStream);

        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;

        AMemoryStream.Free;
        AMemoryStream := nil;
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestREADDELLOGDOC_02(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string; 
  AMemoryStream:TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');

        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        AMemoryStream := TMemoryStream.Create();
        CompressStream(DocDataMgr_1.LoadLogDocFile(DocTag,2,1),AMemoryStream);

        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;

        AMemoryStream.Free;
        AMemoryStream := nil;
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestREADDELLOGDOC_03(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag:string; 
  AMemoryStream:TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
        AMemoryStream := TMemoryStream.Create();
        CompressStream(DocDataMgr_1.LoadLogDocFile(DocTag,3,1),AMemoryStream);

        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;

        AMemoryStream.Free;
        AMemoryStream := nil;
        ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;
    

function TAMainFrm.Pro_RequestREADNEWDOC1(aConnect:TIdTCPConnection;SRequest:string):Integer;
var sFileOutList:string; 
  AMemoryStream:TMemoryStream; AStream:TStringStream; 
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    AStream:=nil;
    try
        //•ø¶b∏¸§J∏ÍÆ∆
        if NowIsLoading Then exit;
        AMemoryStream := nil;

        if SRequest = 'READNEWDOC1' Then
        Begin
          try
            NowIsLoading := True;
            //if DocDataMgr_1.DocList.Count=0 Then
            Begin
              if DocDataMgr_1.TempDocFileNameExists Then
              Begin
                ShowMsgTw('•[∏¸¿¿µo´HÆß¿…Æ◊...');
                DocDataMgr_1.LoadFromTempDocFile;
                ShowMsgTw('•[∏¸ßπ¶®,¶@¶≥¿¿µo§Ωßi' + IntToStr(DocDataMgr_1.DocList.Count) + ' ´›ºfÆ÷');
              End;
            End;
          finally
            NowIsLoading   := false;
          end;
           AMemoryStream := TMemoryStream.Create();
           CompressStream(DocDataMgr_1.DocListText,AMemoryStream);
        End;

        if SRequest = 'READNEWDOC2' Then
        Begin
          LoadOfDocDataMgr_2DocList(false,true);
          AMemoryStream := TMemoryStream.Create();
          if chkAutoAuditDoc.Checked then
            CompressStream('',AMemoryStream)
          else
            CompressStream(DocDataMgr_2.DocListText,AMemoryStream);
        End;

        if SRequest = 'READNEWDOC3' Then
        Begin
           AMemoryStream := TMemoryStream.Create();
           CompressStream(DocDataMgr_3.DocListText,AMemoryStream);
        End;

        if Assigned(AMemoryStream)Then
        Begin
          ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
          OpenWriteBuffer;
          WriteStream(AMemoryStream);
          CloseWriteBuffer;
          AMemoryStream.Free;
          AMemoryStream := nil;
          ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
        End;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
    end;
  end;
end;


function TAMainFrm.Pro_RequestDOCCOUNT(aConnect:TIdTCPConnection;SRequest:string):Integer;
var sTEMP:string; 
begin
  with aConnect do
  begin
    //if chkAutoAuditDoc.Checked then
    //  sTEMP:='0/0'
    //else
      sTEMP:=inttostr(DocDataMgr_2.TodayDocCount)+'/'+inttostr(DocDataMgr_2.CurDocCount);
    ShowMsgTw('´›ºfÆ÷§Ωßiº∆•ÿ:'+sTEMP);
    if chkAutoAuditDoc.Checked then
      WriteLn('<hint>'+'∑Ì´e≥B©Û¶€∞ ºfÆ÷§Ωßiº“¶°,µLª›∞ı¶Ê§ΩßiºfÆ÷'+'</hint>'+'count='+sTEMP)
    else
      WriteLn('count='+sTEMP);
  end;
end;

function TAMainFrm.Pro_RequestINITREADNEWDOC1(aConnect:TIdTCPConnection;SRequest:string):Integer;
var sFileOutList:string; 
  AMemoryStream:TMemoryStream; AStream:TStringStream; 
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    AStream:=nil;
    try
        //•ø¶b∏¸§J∏ÍÆ∆
        if NowIsLoading Then exit;
        AMemoryStream := nil;
        if SRequest = 'INITREADNEWDOC1' Then
        Begin
          try
            NowIsLoading := True;
            if DocDataMgr_1.DocList.Count=0 Then
            Begin
              if DocDataMgr_1.TempDocFileNameExists Then
              Begin
                ShowMsgTw('•[∏¸¿¿µo´HÆß¿…Æ◊...');
                DocDataMgr_1.LoadFromTempDocFile;
                ShowMsgTw('•[∏¸ßπ¶®,¶@¶≥¿¿µo§Ωßi' + IntToStr(DocDataMgr_1.DocList.Count) + ' ´›ºfÆ÷');
              End;
            End;
          finally
            NowIsLoading   := false;
          end;

           AMemoryStream := TMemoryStream.Create();
           CompressStream(DocDataMgr_1.DocListText,AMemoryStream);
        End;

        if SRequest = 'INITREADNEWDOC2' Then
        Begin
          if DocDataMgr_2.DocList.Count=0 Then
            LoadOfDocDataMgr_2DocList(True,True);
          AMemoryStream := TMemoryStream.Create();
          if chkAutoAuditDoc.Checked then
            CompressStream('',AMemoryStream)
          else 
            CompressStream(DocDataMgr_2.DocListText,AMemoryStream);
        End;

        if SRequest = 'INITREADNEWDOC3' Then
        Begin
           AMemoryStream := TMemoryStream.Create();
           CompressStream(DocDataMgr_3.DocListText,AMemoryStream);
        End;

        if Assigned(AMemoryStream)Then
        Begin
          ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
          OpenWriteBuffer;
          WriteStream(AMemoryStream);
          CloseWriteBuffer;
          AMemoryStream.Free;
          AMemoryStream := nil;
          ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
        End;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_Request_StkIndustryStatus_StkBase1Status(aConnect:TIdTCPConnection;SRequest:string):Integer;
var sTEMP:string; 
begin
  with aConnect do
  begin
    sTEMP:=GetStatusOfTCRI(SRequest);
    ShowMsg('rsp='+sTEMP);
    WriteLn(''+sTEMP);
  end;
end;

function TAMainFrm.Pro_RequestGETZZSZHINT(aConnect:TIdTCPConnection;SRequest:string):Integer;
var sTEMP:string;  i:integer;
   AStream:TStringStream;
begin
  with aConnect do
  begin
    AStream:=nil;
    try
        sTEMP:=ExtractFilePath(ParamStr(0))+'Doc_ChinaTodayHint.exe';
        //ShellExecute(nil,('open'),PChar(sTEMP),nil,nil,SW_SHOWNORMAL);
        //'start '+
        if not FileExists(ExtractFilePath(ParamStr(0))+'StartChinaTodayHint.cmd') then
          SetTextByTs(ExtractFilePath(ParamStr(0))+'StartChinaTodayHint.cmd','start Doc_ChinaTodayHint.exe "gb"');
        sTEMP:=ExtractFilePath(ParamStr(0))+'StartChinaTodayHint.cmd';
        WinExec(PChar(sTEMP), SW_SHOW);
        for i:=1 to 3 do
        begin
          try
            if IdTCPClient1.Connected then
            begin
              IdTCPClient1.Disconnect;
            end;
            IdTCPClient1.Host:='127.0.0.1';
            IdTCPClient1.Port:=FAppParam.TodayHintListenPort;
            IdTCPClient1.Connect(3000);
            if IdTCPClient1.Connected then
              break;
          except
            on e:exception do
            begin
              ShowMsg('IdTCPClient connect e.'+e.Message);
            end;
          end;
          SleepWait(1);
        end;
        if not IdTCPClient1.Connected then
        begin
          WriteLn('FAIL'+'¡¨Ω” ß∞‹');
        end
        else begin
          sTEMP := UpperCase(IdTCPClient1.ReadLn);
          if Pos('CONNECTOK', sTEMP) = 0 then
          begin
            IdTCPClient1.Disconnect;
            WriteLn('FAIL'+'¡¨Ω” ß∞‹.');
          end
          else begin
            IdTCPClient1.WriteLn('start');
            sTEMP := UpperCase(IdTCPClient1.ReadLn);
            if Pos('HELLO', sTEMP) > 0 then
            Begin
              WriteLn('HELLO');
              sTEMP := UpperCase(ReadLn);
              if Pos('HELLO', sTEMP) > 0 then
              begin
                ShowMsgTw('∑«≥∆™¶^§§√“§W√“•Ê©ˆ¥£•‹');
                //AMemoryStream :=TMemoryStream.Create();
                sTEMP:=GetZZSZHintText;
                AStream := TStringStream.Create(sTEMP);
                //CompressStream(sTEMP,AMemoryStream);
                OpenWriteBuffer;
                WriteStream(AStream);
                //AStream.SaveToFile('c:\test1.dat');
                CloseWriteBuffer;
                FreeAndNil(AStream);
                ShowMsgTw('ßπ¶®™¶^§§√“§W√“•Ê©ˆ¥£•‹');
              end;
            End
            else begin
              WriteLn(sTEMP);
            end;
          end;
        end;
    finally
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestDOC01OKTIME(aConnect:TIdTCPConnection;SRequest:string):Integer;
var sTEMP:string; 
begin
  with aConnect do
  begin
    sTEMP:=GetLastOkTime(1,FAppParam.IsTwSys);
    ShowMsgTw('¿¿µo≥Ã™Ò¶®•\∑jØ¡Æ…∂°:'+sTEMP);
    if MayBeDigital(sTEMP) then
      WriteLn('TIME='+sTEMP);
  end;
end;

function TAMainFrm.Pro_RequestDOC03OKTIME(aConnect:TIdTCPConnection;SRequest:string):Integer;
var sTEMP:string; 
begin
  with aConnect do
  begin
    sTEMP:=GetLastOkTime(3,FAppParam.IsTwSys);
    ShowMsgTw('πL∑|≥Ã™Ò¶®•\∑jØ¡Æ…∂°:'+sTEMP);
    WriteLn('TIME='+sTEMP);
  end;
end;

function TAMainFrm.Pro_Request_DOCDone(aConnect:TIdTCPConnection;aDocStatus,SRequest:string):Integer;
var DocTag,aRecvStr,sDocText,aTempStr,aTempStr2,sGUID,sRst:string; ADoc : TDocData;
    AStream :TStringStream;  AMemoryStream : TMemoryStream;
begin
  with aConnect do
  begin
    ADoc:=nil; sRst:='';
    AStream:=nil; AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTW('∑«≥∆±µ¶¨∏ÍÆ∆');

        {sDocText:=ReadLn;
        sDocText:=FastAnsiReplace(sDocText, '#13#10',#13#10 ,[rfReplaceAll]);}
        AStream := TStringStream.Create('');
        AMemoryStream := TMemoryStream.Create();
        ReadStream(AMemoryStream);
        AMemoryStream.Position := 0;
        DeCompressStream(AMemoryStream);
        AMemoryStream.SaveToStream(AStream);
        sDocText:=AStream.DataString;
        
        aRecvStr:=sDocText;
        aTempStr:=GetStrOnly2('<LogFile>','</LogFile>',aRecvStr,true);
        aTempStr2:=GetStrOnly2('<LogFile>','</LogFile>',aTempStr,false);
        if aTempStr2='' then
        begin
          ShowMsgTW('LogFile¨∞™≈!');
          Exit;
        end;
        aTempStr2:=ExtractFilePath(ParamStr(0))+'Data\CheckDocLog\'+aTempStr2;
        aRecvStr:=StringReplace(aRecvStr,aTempStr,'',[rfReplaceAll]);
        sGUID:=GetStrOnly2('<GUID>','</GUID>',aRecvStr,false);

        ADoc := TDocData.Create(aRecvStr);
        ADoc.DocStatus:=aDocStatus;
        ShowMsgTW('ßπ¶®±µ¶¨∏ÍÆ∆');

        if FAppParam.IsTwSys then 
          ShowMsgTw(FAppParam.TwConvertStr('≥]©w§Ωßi™¨∫A'+aDocStatus+'  ')+ADoc.Title)
        else
          ShowMsg('…Ë∂®π´∏Ê◊¥Ã¨'+ADoc.Title,false);
        
        DocDataMgr_2.SetADocStatus(ADoc,aTempStr2,sRst);
        ShowMsgTW('ßπ¶®§Ωßi™¨∫A≥]©w.');
        ADoc.Free;
        ADoc:=nil;

        if sRst='' then
          WriteLn('HELLO')
        else
          WriteLn('<ErrMsg>'+sRst+'</ErrMsg>');
    finally
      try
        if Assigned(ADoc) then
        begin
          ADoc.Free;
          ADoc:=nil;
        end;
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

    
function TAMainFrm.Pro_Request_DOCCancel(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag,aRecvStr,sDocText,aTempStr,aTempStr2,sGUID,sRst:string; ADoc : TDocData;
    AStream :TStringStream;  AMemoryStream : TMemoryStream;
begin
  with aConnect do
  begin
    ADoc:=nil; sRst:='';
    AStream:=nil; AMemoryStream:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTW('∑«≥∆±µ¶¨∏ÍÆ∆');

        {sDocText:=ReadLn;
        sDocText:=FastAnsiReplace(sDocText, '#13#10',#13#10 ,[rfReplaceAll]);}
        AStream := TStringStream.Create('');
        AMemoryStream := TMemoryStream.Create();
        ReadStream(AMemoryStream);
        AMemoryStream.Position := 0;
        DeCompressStream(AMemoryStream);
        AMemoryStream.SaveToStream(AStream);
        sDocText:=AStream.DataString;
        
        aRecvStr:=sDocText;
        aTempStr:=GetStrOnly2('<LogFile>','</LogFile>',aRecvStr,true);
        aTempStr2:=GetStrOnly2('<LogFile>','</LogFile>',aTempStr,false);
        if aTempStr2='' then
        begin
          ShowMsgTW('LogFile¨∞™≈!');
          Exit;
        end;
        aTempStr2:=ExtractFilePath(ParamStr(0))+'Data\CheckDocLog\'+aTempStr2;
        aRecvStr:=StringReplace(aRecvStr,aTempStr,'',[rfReplaceAll]);
        sGUID:=GetStrOnly2('<GUID>','</GUID>',aRecvStr,false);

        ADoc := TDocData.Create(aRecvStr);
        ShowMsgTW('ßπ¶®±µ¶¨∏ÍÆ∆');

        if FAppParam.IsTwSys then 
          ShowMsgTw(FAppParam.TwConvertStr('ß@ºo§Ωßi ')+ADoc.Title)
        else
          ShowMsg('◊˜∑œπ´∏Ê'+ADoc.Title,false);
        
        DocDataMgr_2.CancelADoc(ADoc,aTempStr2,sRst);
        ShowMsgTW('ßπ¶®§Ωßiß@ºo.');
        ADoc.Free;
        ADoc:=nil;

        if sRst='' then
          WriteLn('HELLO')
        else
          WriteLn('<ErrMsg>'+sRst+'</ErrMsg>');
    finally
      try
        if Assigned(ADoc) then
        begin
          ADoc.Free;
          ADoc:=nil;
        end;
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_Request_DOCOK_DOCDEL(aConnect:TIdTCPConnection;SRequest:string):Integer;
var DocTag,sDocText:string; ADoc,ADoc2 : TDocData;
  AMemoryStream:TMemoryStream; AStream:TStringStream; 
begin
  with aConnect do
  begin
    AMemoryStream:=nil; AStream:=nil; ADoc:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTW('∑«≥∆±µ¶¨∏ÍÆ∆');

        {sDocText:=ReadLn;
        sDocText:=FastAnsiReplace(sDocText, '#13#10',#13#10 ,[rfReplaceAll]);}
        //
        AStream := TStringStream.Create('');
        AMemoryStream := TMemoryStream.Create();
        ReadStream(AMemoryStream);
        AMemoryStream.Position := 0;
        DeCompressStream(AMemoryStream);
        AMemoryStream.SaveToStream(AStream);
        sDocText:=AStream.DataString;
        //

        ADoc := TDocData.Create(sDocText);
        ShowMsgTW('ßπ¶®±µ¶¨∏ÍÆ∆');

        ADoc2 := nil;
        if (DocTag = 'DOC2') Then
            ADoc2 := DocDataMgr_2.GetADoc(ADoc.GUID);
        if (DocTag = 'DOC1') then
            ADoc2 := DocDataMgr_1.GetADoc(ADoc.GUID);
        if (DocTag = 'DOC3') then
            ADoc2 := DocDataMgr_3.GetADoc(ADoc.GUID);
        if ADoc2<>nil then
        begin
          ADoc2.Operator:=ADoc.Operator;
          ADoc2.OpTime:=ADoc.OpTime;
        end;

        ShowMsg(FAppParam.TwConvertStr('ºfÆ÷§Ωßi ')+ADoc.Title,false);
        if Assigned(ADoc2) Then
        Begin
          if (DocTag = 'DOC1') Then
          Begin
            ADoc2.Memo    := ADoc.Memo;
            ADoc2.DOCID   := ADoc.DOCID;
            if SRequest = 'DOCOK'  Then
               DocDataMgr_1.SetChkDocIDIsOk(DocTag,ADoc2.GUID);
          End;

          if (DocTag = 'DOC2') Then
          Begin
            if chkAutoAuditDoc.Checked then
            begin
              ShowMsg(FAppParam.TwConvertStr('∑Ì´e¨∞¶€∞ ºfÆ÷º“¶°,©ø≤§§‚∞ ºfÆ÷. ')+ADoc.Title,false);
            end
            else begin
              ADoc2.Memo    := ADoc.Memo;
              ADoc2.DOCID   := ADoc.DOCID;
              if SRequest = 'DOCDEL' Then
                DocDataMgr_2.DelADoc(DocTag,ADoc2.GUID);
              if SRequest = 'DOCOK'  Then
              begin
                ADoc2.DocStatus:=_DocUnDoTag;
                DocDataMgr_2.SetChkDocIsOk(DocTag,ADoc2.GUID);
              end;
            end;
          End;

          if (DocTag = 'DOC3') Then
          Begin
            if SRequest = 'DOCOK'  Then
                DocDataMgr_3.SetChkDocIDIsOk(DocTag,ADoc2.GUID);
          End;
          ShowMsgTW('ßπ¶®§ΩßiºfÆ÷.');
        End Else
           ShowMsgTW('§Ωßi§£¶s¶b.');
        WriteLn('HELLO');
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
      try
        if Assigned(ADoc) then
          ADoc.Destroy;
      except
      end;
    end;
  end;
end;

function TAMainFrm.AutoDOCOK02(aDocOk:boolean;ADoc2 : TDocData):Boolean;
const DocTag = 'DOC2';
begin
  Result:=false;
  if ADoc2<>nil then
  begin
    ADoc2.Operator:='doccenter';
    ADoc2.OpTime:=now;

    ShowMsg(FAppParam.TwConvertStr('¶€∞ ºfÆ÷§Ωßi ')+ADoc2.Title,false);
    if aDocOk then
    begin
      ADoc2.DocStatus:=_DocUnDoTag;
      DocDataMgr_2.SetChkDocIsOk(DocTag,ADoc2.GUID);
      ShowMsgTW('ßπ¶®§ΩßiºfÆ÷.');
    end
    else begin
      DocDataMgr_2.DelADoc(DocTag,ADoc2.GUID);
      ShowMsgTW('ßπ¶®§ΩßißR∞£.');
    end;
    Result:=true;
  end
  else begin
    ShowMsgTW('AutoDOCOK02,§Ωßi§£¶s¶b');
  end;
end;

function TAMainFrm.Pro_RequestMANUALDOCSAVETMP(aConnect:TIdTCPConnection):Integer;
var DocTag:string;
  AMemoryStream:TMemoryStream; AStream:TStringStream;  AManualDocData:TStringList;//--Doc3.2.0ª›®D3 huangcq080928 
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    AStream:=nil;
    AManualDocData:=nil;
    try
        WriteLn('HELLO');
        DocTag := UpperCase(ReadLn);
        WriteLn('HELLO');
        ShowMsgTW('∑«≥∆±µ¶¨∏ÍÆ∆');

        AStream := TStringStream.Create('');
        AMemoryStream := TMemoryStream.Create();
        ReadStream(AMemoryStream, -1, True);
        AMemoryStream.Position := 0;

        DeCompressStream(AMemoryStream);

        AMemoryStream.SaveToStream(AStream);
        AMemoryStream.Free;
        AMemoryStream := nil;      

        AManualDocData:=TStringList.Create;
        AManualDocData.Text := AStream.DataString;
        AStream.Free;
        AStream:=nil;
        ShowMsgTW('ßπ¶®±µ¶¨∏ÍÆ∆');

        if (DocTag = 'DOC2') Then
        begin
          if DocManualMgr_2.SetDocManual(AManualDocData) then //´O¶s±µ¶¨§∫Æe®Ïtmp§Â•Û
            ShowMsgTW('ManualDoc2SaveTmp¶®•\')
          else
            ShowMsgTW('ManualDoc2SaveTmp•¢±—');
        end;

        AManualDocData.Free;
        AManualDocData :=nil;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
      try
        if Assigned(AStream) then
          FreeAndNil(AStream);
      except
      end;
      try
        if Assigned(AManualDocData) then
          FreeAndNil(AManualDocData);
      except
      end;
    end;
  end;
end;


function TAMainFrm.Pro_RequestMANUALDOCREADNEWLOG(aConnect:TIdTCPConnection):Integer;
var DocTag,ManualDstFile1:string; AMemoryStream : TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
      WriteLn('HELLO');
      DocTag := UpperCase(ReadLn);
      WriteLn('HELLO');
      //ShowMsg('ManualDocSave∑«≥∆™¶^Log');
      if (DocTag = 'DOC2') Then
      begin
        ShowMsgTw('ManualDoc2SaveTmp∑«≥∆™¶^Log');
        AMemoryStream :=TMemoryStream.Create();
        //™¶^Log§Â•Û¶VIDTCPServerºg§J¨y
        CompressStream(DocManualMgr_2.ReturnNewManualLogText,AMemoryStream);
        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;
        AMemoryStream.Free;
        AMemoryStream:=nil;
        ShowMsgTw('ManualDoc2SaveTmpßπ¶®™¶^Log');
      end;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestMANUALDOCREADALLLOG(aConnect:TIdTCPConnection):Integer;
var DocTag,ManualDstFile1:string; AMemoryStream : TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
      WriteLn('HELLO');
      DocTag := UpperCase(ReadLn);
      WriteLn('HELLO');
      if (DocTag = 'DOC2') then
      begin
        ManualDstFile1:=ReadLn;
        ShowMsgTw('ManualDoc2∑«≥∆∂«∞e'+ManualDstFile1);

        AMemoryStream :=TMemoryStream.Create();
        //ReadLn±o®Ï≠n¿Ú®˙™∫Log§Â•Û¶W(¶p'20081022.log'),™¶^§Â•Û¶VIDTCPServerºg§J¨y
        CompressStream(DocManualMgr_2.GetManualLogText(ManualDstFile1),AMemoryStream);
        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;
        AMemoryStream.Free;
        AMemoryStream:=nil;

        ShowMsgTw('ManualDoc2ßπ¶®∂«∞e'+ManualDstFile1);
      end;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestMANUALDOCREADTMP(aConnect:TIdTCPConnection):Integer;
var DocTag,ManualDstFile1:string; AMemoryStream : TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
      WriteLn('HELLO');
      DocTag := UpperCase(ReadLn);
      WriteLn('HELLO');
      if (DocTag = 'DOC2') then
      begin
        ManualDstFile1:=ReadLn;
        ShowMsgTw('ManualDoc2∑«≥∆∂«∞e≥∆•˜'+ManualDstFile1);

        AMemoryStream :=TMemoryStream.Create();
        //ReadLn±o®Ï≠n¿Ú®˙™∫Tmp§Â•Û¶W(¶p'Doc_02_7D26B510.tmp'),™¶^§Â•Û¶VIDTCPServerºg§J¨y
        CompressStream(DocManualMgr_2.GetManualBackupTmpFile(ManualDstFile1),AMemoryStream);
        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;
        AMemoryStream.Free;
        AMemoryStream:=nil;

        ShowMsgTw('ManualDoc2ßπ¶®∂«∞e≥∆•˜'+ManualDstFile1);
      end;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestMANUALDOCDELBACKUPTMP(aConnect:TIdTCPConnection):Integer;
var DocTag,ManualDstFile1:string; AMemoryStream : TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
      WriteLn('HELLO');
      DocTag := UpperCase(ReadLn);
      WriteLn('HELLO');
      if (DocTag = 'DOC2') then
      begin
        ManualDstFile1:=ReadLn;
        ShowMsgTw('ManualDoc2∑«≥∆ßR∞£≥∆•˜Tmp§Â•Û:'+ManualDstFile1);

        AMemoryStream :=TMemoryStream.Create();
        //ReadLn±o®Ï≠nßR∞£≥∆•˜§Â•Û™∫∞_§Ó§È¥¡(¶p'20081022~20081122'),™¶^ßR∞£¶Z≤£•Õ™∫Log´HÆß¶VIDTCPServerºg§J¨y
        //©ŒReadLn±o®Ï'AutoDel'¶r≤≈¶Í°A™Ì•‹¶€∞ ßR∞£´OØd•b≠”§Î§∫™∫≥∆•˜
        CompressStream(DocManualMgr_2.DelManualBackupTmpFile(ManualDstFile1),AMemoryStream);
        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;
        AMemoryStream.Free;
        AMemoryStream:=nil;

        ShowMsgTw('ManualDoc2ßπ¶®ßR∞£≥∆•˜Tmp§Â•Û:'+ManualDstFile1);
      end;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestMANUALDOCREADDELTMPLOG(aConnect:TIdTCPConnection):Integer;
var DocTag:string; AMemoryStream : TMemoryStream;
begin
  with aConnect do
  begin
    AMemoryStream:=nil;
    try
      WriteLn('HELLO');
      DocTag := UpperCase(ReadLn);
      WriteLn('HELLO');
      if (DocTag = 'DOC2') then
      begin
        //ManualDstFile1:=ReadLn;
        ShowMsgTw('ManualDoc2∑«≥∆∂«∞eDelBackupTmpLog');

        AMemoryStream :=TMemoryStream.Create();
        CompressStream(DocManualMgr_2.ReturnTheDelTmpFileLog,AMemoryStream);
        OpenWriteBuffer;
        WriteStream(AMemoryStream);
        CloseWriteBuffer;
        AMemoryStream.Free;
        AMemoryStream:=nil;

        ShowMsgTw('ManualDoc2ßπ¶®∂«∞eDelBackupTmpLog');
      end;
    finally
      try
        if Assigned(AMemoryStream) then
          FreeAndNil(AMemoryStream);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestUPTOPLOGRECS(aConnect:TIdTCPConnection;SRequest:string;aEcb:boolean):Integer;
var sLogOpLst,sLogOpCur,sTimeKey:string;
begin
  result:=0;
  sLogOpLst:=GetStrOnly2(_LogSecBegin,_LogSecEnd,SRequest,false);
  sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,sLogOpLst,true);
  sLogOpLst:=StringReplace(sLogOpLst,sLogOpCur,'',[rfReplaceAll]);
  sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
  sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);
  sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
  if aEcb then
    Pro_RequestUPTLOGRECSFILEEcb(sLogOpLst,sTimeKey)
  else 
    Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
  aConnect.WriteLn('HELLO');
  result:=1;
end;

function TAMainFrm.Pro_RequestUPTLOGRECSFILE(SRequest,sTimeKey:string):Integer;
var ts:TStringList; StrLst: _cStrLst;
    i:integer; sLine:string; ARec:TTrancsationRec;
begin
    try
      ts := TStringList.Create;
      SRequest:=StringReplace(SRequest,'#13#10',#13#10,[rfReplaceAll]);
      ts.text:=SRequest;
      for i:=0 to ts.count-1 do
      begin
        sLine:=trim(ts[i]);
        if sLine='' then
          continue;
        StrLst:=DoStrArray(sLine,_LogSep);
        if (Length(StrLst)>=8) then
        begin
           ARec.ID := StrLst[0];
           ARec.IDName := StrLst[1];
           ARec.Op := StrLst[2];
           ARec.OpTime := sTimeKey;
           ARec.Operator := StrLst[4];
           ARec.ModouleName := StrLst[5];
           ARec.ModouleNameEn := StrLst[6];
           if StrLst[7]='1' then
             ARec.BeSave := True
           else
             ARec.BeSave := False;
            WriteARec(ARec);
        end;
      end;
    finally
      try
        if Assigned(ts) then
          FreeAndNil(ts);
      except
      end;
      try
        SetLength(StrLst,0);
      except
      end;
    end;
end;

function TAMainFrm.Pro_RequestUPTLOGRECSFILEEcb(SRequest,sTimeKey:string):Integer;
var ts:TStringList; StrLst: _cStrLst;
    i:integer; sLine,sTheSep:string; ARec:TTrancsationRec;
begin
    try
      ts := TStringList.Create;
      SRequest:=StringReplace(SRequest,'#13#10',#13#10,[rfReplaceAll]);
      ts.text:=SRequest;
      for i:=0 to ts.count-1 do
      begin
        sLine:=trim(ts[i]);
        if sLine='' then
          continue;
        if Pos(_LogSep,sLine)>0 then sTheSep:=_LogSep
        else if Pos(UpperCase(_LogSep),sLine)>0 then sTheSep:=UpperCase(_LogSep)
        else exit;
        StrLst:=DoStrArray(sLine,sTheSep);
        if (Length(StrLst)>=8) then
        begin
           ARec.ID := StrLst[0];
           ARec.IDName := StrLst[1];
           ARec.Op := StrLst[2];
           ARec.OpTime := sTimeKey;
           ARec.Operator := StrLst[4];
           ARec.ModouleName := StrLst[5];
           ARec.ModouleNameEn := StrLst[6];
           if StrLst[7]='1' then
             ARec.BeSave := True
           else
             ARec.BeSave := False;
            WriteARecEcb(ARec);
        end;
      end;
    finally
      try
        if Assigned(ts) then
          FreeAndNil(ts);
      except
      end;
      try
        SetLength(StrLst,0);
      except
      end;
    end;
end;

function TAMainFrm.Pro_RequestUserVlidate(aConnect:TIdTCPConnection):Integer;
var vInfo,vUserID,vPsw,vOp:String;
  vInfoLst : _CstrLst;vUser:TUser;vOpType:TUserOpType;
  DocTag:string; AMemoryStream : TMemoryStream;
begin
  //add by wangjinhua 20090602 Doc4.2
  with aConnect do
  Begin
      WriteLn('HELLO');
      DocTag := UpperCase(ReadLn);
      if DocTag = '' then
      begin
        ShowMsgTw('±µ¶¨•Œ§·∫ﬁ≤z•\Ø‡´¸•O•¢±—!');
        WriteLn('FAIL');
      end
      else if SameText(DocTag,'InitUser') Then
      begin
         if InitUser() then
         begin
           ShowMsgTw('ßπ¶®™Ï©l§∆•Œ§·∏ÍÆ∆');
           WriteLn('HELLO');
         end
         else begin
           ShowMsgTw('™Ï©l§∆•Œ§·∏ÍÆ∆•¢±—');
           WriteLn('FAIL');
         end;
      end
      else if SameText(DocTag,'CheckLogin') Then
      begin
        WriteLn('HELLO');
        vInfo := ReadLn;
        SetLength(vInfoLst,0);
        vInfoLst := DoStrArray(vInfo,',');
        if Length(vInfoLst) = 2 then
        begin
          ShowMsgTw(vInfo + '[' + vInfoLst[0] + '][' + vInfoLst[1] + ']');
          if not CheckLogin(vInfoLst[0],vInfoLst[1],vInfo) then
          begin
            ShowMsgTw('•Œ§·®≠•˜≈Á√“•¢±—!');
            WriteLn('FAIL');
          end
          else begin
            ShowMsgTw('•Œ§·®≠•˜≈Á√“¶®•\!');
            WriteLn('HELLO');
            ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
            AMemoryStream := TMemoryStream.Create();
            CompressStream(vInfo,AMemoryStream);
            OpenWriteBuffer;
            WriteStream(AMemoryStream);
            CloseWriteBuffer;
            AMemoryStream.Free;
            AMemoryStream := nil;
            ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
          end;
        end
        else begin
          ShowMsgTw('∂«øÈ∞—º∆ø˘ª~!');
          WriteLn('FAIL');
        end;
      end
      else if SameText(DocTag,'RequestUserInfo') Then
      begin
        WriteLn('HELLO');
        vInfo := ReadLn;
        ShowMsgTw('RequestUserInfo User:' + vInfo); //wang test
        if RequestUserInfo(vInfo,vInfo) then
        begin
          if vInfo = '' then
          begin
            ShowMsgTw('¿Ú®˙•Œ§·´HÆß•¢±—!');
            WriteLn('FAIL');
          end
          else begin
            ShowMsgTw('¿Ú®˙•Œ§·´HÆß¶®•\!');
            WriteLn('HELLO');
            ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆');
            AMemoryStream := TMemoryStream.Create();
            CompressStream(vInfo,AMemoryStream);
            OpenWriteBuffer;
            WriteStream(AMemoryStream);
            CloseWriteBuffer;
            AMemoryStream.Free;
            AMemoryStream := nil;
            ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');
          end;
        end
        else begin
          ShowMsgTw('∂«øÈ∞—º∆ø˘ª~!');
          WriteLn('FAIL');
        end;
      end
      else if SameText(DocTag,'EditBtnKWSet')  Then
      begin
        WriteLn('HELLO');
        vInfo := ReadLn;
        ShowMsgTw('EditBtnKWSet readln:' + vInfo); //wang test
        if EditBtnInfo(vInfo) then
        begin
          ShowMsgTw('EditBtnKWSet ok!');
          WriteLn('HELLO');
        end
        else begin
          ShowMsgTw('EditBtnKWSet ok fail!');
          WriteLn('FAIL');
        end;
      end
      else if SameText(DocTag,'EditUserInfo')  Then
      begin
        WriteLn('HELLO');
        vInfo := ReadLn;
        ShowMsgTw('EditUserInfo readln:' + vInfo); //wang test
        if ConvertInfo(vInfo,vUser,vOpType) then
        begin
          case vOpType of
            opAdd: vOp := '∑sºW';
            opEdit: vOp := '≠◊ßÔ';
            opDelete: vOp := 'ßR∞£';
          end;
          if EditUser(vUser,vOpType) then
          begin
            ShowMsgTw('±b§·[' + vUser.ID + ']' + vOp + '¶®•\!');
            WriteLn('HELLO');
          end
          else begin
            ShowMsgTw('±b§·[' + vUser.ID + ']' + vOp + '•¢±—!');
            WriteLn('FAIL');
          end;
        end
        else begin
          ShowMsgTw('∂«øÈ∞—º∆ø˘ª~!');
          WriteLn('FAIL');
        end;
      end
      else if SameText(DocTag,'ResetUserInfo') Then
      begin
         DeleteFile(ExtractFilePath(Application.Exename)+'User.dat');
         if InitUser() then
         begin
           ShowMsgTw('ßπ¶®•Œ§·∏ÍÆ∆≠´∏m');
           WriteLn('HELLO');
         end
         else begin
           ShowMsgTw('•Œ§·∏ÍÆ∆≠´∏m•¢±—');
           WriteLn('FAIL');
         end;
      end
      else if SameText(DocTag,'CheckModouleList') Then
      begin
         WriteLn('HELLO');
         vInfo := ReadLn;
         if CheckModouleList(vInfo) then
         begin
           ShowMsgTw('ßπ¶®º“∂Ù∏ÍÆ∆¿À¨d');
           WriteLn('HELLO');
         end
         else begin
           ShowMsgTw('º“∂Ù∏ÍÆ∆¿À¨d•¢±—');
           WriteLn('FAIL');
         end;
      end;
  End;
//--
end;


function TAMainFrm.Pro_RequestListIFRS(aConnect:TIdTCPConnection):Integer;
var ts:TStringList;  aParamStrLst:_cStrLst; AStream:TFileStream;
  sFile,sFile01,sFile02,sFile03,sFile1,sLine,
    sDecFile,sList,sAppPath,sTr1DBPath,sSendFile,sTmpCodeListFile,
    sYear,sQ:string;
  i,j,ic:integer;
  MyDeCodeF:DeCodeF2;

    procedure InitMyDeCodeF;
    var iLoc:integer;
    begin
      For iLoc:=0 to High(MyDeCodeF.FileNames) do
      Begin
        MyDeCodeF.FileNames[iLoc] := '';
        MyDeCodeF.FileDir[iLoc] := '';
        MyDeCodeF.FileSize [iLoc] := 0;
      End;
      MyDeCodeF.FileCount := 0;
    end;
    function PageTheFiles(APakeFile:string):string;
    var f : File of DeCodeF2;
    begin
      result:='';
      try
        if FileExists(APakeFile) Then
        Begin
          ShowSb(0,FAppParam.TwConvertStr('¿£¡Y '+ExtractFileName(APakeFile)+'...') );
          AssignFile(f,CPF(APakeFile,'.ini'));
          FileMode := 1;
          ReWrite(f);
          Write(f,MyDeCodeF);
          CloseFile(f);
          DeleteFile(CPF(APakeFile,'.txt'));
          FileToOneFile(CPF(APakeFile,'.ini'),CPF(APakeFile,'.txt'));
          FileToOneFile(CPF(APakeFile,'.dec'),CPF(APakeFile,'.txt'));
          CompressFile(CPF(APakeFile,'.upl'),CPF(APakeFile,'.txt'),clMax);
          Result := CPF(APakeFile,'.upl');
        End;
      finally
        if FileExists(CPF(APakeFile,'.ini')) then DeleteFile(CPF(APakeFile,'.ini'));
        if FileExists(APakeFile) then DeleteFile(APakeFile);
        if FileExists(CPF(APakeFile,'.txt')) then DeleteFile(CPF(APakeFile,'.txt'));
      end;
    end;
    
begin
  result:=1;
  sFile:=IFRSWorkLstFile;
  sAppPath:=ExtractFilePath(ParamStr(0));
  sTr1DBPath:=FAppParam.Tr1DBPath;
  sDecFile:=sAppPath+_IFRSListPkgDat+'.dec';
  if FileExists(sDecFile) then
    DeleteFile(sDecFile);
try
  sTmpCodeListFile:=sAppPath+'TempIFRSCodeList.dat';
  InitMyDeCodeF;
  DeCodeFile2(sFile,sDecFile,'IFRS','',MyDeCodeF);
  sFile1:=Format('%sCBData\IFRS\IFRSNode.dat',[sTr1DBPath]);
  DeCodeFile2(sFile1,sDecFile,'IFRS','',MyDeCodeF);
  sFile1:=Format('%sCBData\IFRS\IFRSTopNode.dat',[sTr1DBPath]);
  DeCodeFile2(sFile1,sDecFile,'IFRS','',MyDeCodeF);
  sList:='';
  if FileExists(sFile) then
  begin
    sLine:=GetIniFileEx('work','status',_CCreateWorkListFail,sFile);
    if (sLine=_CCreateWorkListFail) or
       (sLine=_CCreateWorkList) or
       (sLine=_CCreateWorkListReady) then
    begin
      sList:=Status2StrSubForIFRS(sLine);
      aConnect.WriteLn(sList);
      exit;
    end;
    sYear:=GetIniFileEx('work','year','',sFile);
    sQ:=GetIniFileEx('work','q','',sFile);

    sFile1:=Format('%sCBData\IFRS\%s_%s_1.dat',[sTr1DBPath,sYear,sQ]);
    DeCodeFile2(sFile1,sDecFile,'IFRS','',MyDeCodeF);
    sFile1:=Format('%sCBData\IFRS\%s_%s_2.dat',[sTr1DBPath,sYear,sQ]);
    DeCodeFile2(sFile1,sDecFile,'IFRS','',MyDeCodeF);
    sFile1:=Format('%sCBData\IFRS\%s_%s_3.dat',[sTr1DBPath,sYear,sQ]);
    DeCodeFile2(sFile1,sDecFile,'IFRS','',MyDeCodeF);

    ic:=0;
    try
      ts:=TStringList.create;
      ts.LoadFromFile(sFile);
      for i:=0 to ts.Count-1 do
      begin
        if SameText(ts[i],'[list]') then
        begin
          for j:=i+1 to ts.Count-1 do
          begin
            sLine:=Trim(ts[j]);
            if sLine='' then
              continue;
            if IsSecLine(sLine) then
              break;
            aParamStrLst:=DoStrArray(sLine,'=');
            if length(aParamStrLst)=2 then
            begin
              if (aParamStrLst[1]=_CXiaOK) and (aParamStrLst[0]<>'') then
              begin
                sFile01:=Format('%sData\IFRS\%s_%s_%s_1.dat',[sAppPath,sYear,sQ,aParamStrLst[0]]);
                sFile02:=Format('%sData\IFRS\%s_%s_%s_2.dat',[sAppPath,sYear,sQ,aParamStrLst[0]]);
                sFile03:=Format('%sData\IFRS\%s_%s_%s_3.dat',[sAppPath,sYear,sQ,aParamStrLst[0]]);

                if (GetFileSize(sFile01)<=0) and
                   (GetFileSize(sFile02)<=0) and
                   (GetFileSize(sFile03)<=0) then
                begin
                  continue;
                end;
                if sList='' then sList:=aParamStrLst[0]
                else sList:=sList+','+aParamStrLst[0];
                DeCodeFile2(sFile01,sDecFile,'IFRS','',MyDeCodeF);
                DeCodeFile2(sFile02,sDecFile,'IFRS','',MyDeCodeF);
                DeCodeFile2(sFile03,sDecFile,'IFRS','',MyDeCodeF);
                Inc(ic);
                if ic>FLoadCountOfIFRS then
                begin
                  break;
                end;
              end;
            end;
          end;
          Break;
        end;
      end;
      with aConnect do
      begin
        ShowMsgTw('∂«∞e•NΩX'+sList);
        SetTextByTs(sTmpCodeListFile,sList);
        DeCodeFile2(sTmpCodeListFile,sDecFile,'IFRS','',MyDeCodeF);
        sSendFile:=PageTheFiles(sDecFile);
        if (sSendFile='') or (not FileExists(sSendFile))  then
        begin
          WriteLn('DocCenter•¥•]•¢±—');
          ShowMsgTw('•¥•]•¢±—');
          exit;
        end
        else begin
          WriteLn('HELLO');
          sLine:=ReadLn;
          if sLine='HELLO' then
          begin
            ShowMsgTw('∑«≥∆∂«∞e...');
            AStream:=TFileStream.Create(sSendFile,fmOpenRead);
            OpenWriteBuffer;
            WriteStream(AStream);
            CloseWriteBuffer;
            AStream.Free;
            AStream := nil;
            DeleteFile(sSendFile);
            ShowMsgTw('ßπ¶®∂«∞e');
          end
          else
            exit;
        end;
      end;

      result:=0;
    finally
      try SetLength(aParamStrLst,0); except end;
      try if Assigned(ts) then FreeAndNil(ts); except end;
    end;
  end
  else begin
    aConnect.WriteLn('µL™k¿Ú®˙¶C™Ì,®S¶≥¶C™Ì≤M≥Ê§Â•Û');
    //aConnect.WriteLn('FAIL');
  end;
finally
  if FileExists(sTmpCodeListFile) then
    DeleteFile(sTmpCodeListFile);
  if FileExists(sDecFile) then
    DeleteFile(sDecFile);
  sDecFile:=CPF(sDecFile,'.upl');
  if FileExists(sDecFile) then
    DeleteFile(sDecFile);
end;
end;

procedure TAMainFrm.TCPServerEcbExecute(AThread: TIdPeerThread);
var SRequest,SRequestInit,ReadStr,ErrMsg: string;
begin
  EnterCriticalSection(CriticalSection);
  NowIsRunning := True;
Try
try
  with AThread.Connection do
  begin
      ShowMsgTwEcb('¶≥§H≠n®D¡pæ˜.');
      //AThread.Connection.MaxLineLength:=FIndyMaxLineLength;
      WriteLn('ConnectOk');
      ReadStr := ReadLn;
      SRequestInit:=ReadStr;
      if (PosEx('<Cmd>',ReadStr)>0) and
         (PosEx('</Cmd>',ReadStr)>0) then
        SRequest:=GetStrOnly2('<Cmd>','</Cmd>',ReadStr,false)
      else if SameText(ReadStr,Cmd_RcvFile) Then
        SRequest := ReadStr
      else
        SRequest := UpperCase(ReadStr);
        
      ShowMsgTWEcb('≠n∞µ™∫∞ ß@¨O ' + SRequest);
      if (Pos('.DAT',SRequest)>0)  Then
        Pro_Request_DatEcb(AThread.Connection,SRequest)
      else if (SRequest = UpperCase('SetCBDat')) Then
        Pro_RequestSetCBDatEcb(AThread.Connection,SRequest)
      else if (SRequest = UpperCase('SetCBTxt')) Then
        Pro_RequestSetCBTxtEcb(AThread.Connection,SRequest)
      else if SameText(SRequest,'GETCBDATAOPLOG') then
        Pro_RequestGETCBDATAOPLOGEcb(AThread.Connection,SRequest)
      else if (PosEx('EcbRateDateDatWrite',SRequest)=1) then
         Pro_RequestSetEcbRateFiles(AThread.Connection,SRequest,ReadStr);
  end;
Except
   On E : Exception do
   Begin
      ErrMsg := E.Message;
      SendDocMonitorWarningMsg('DocCenter Error'+'('+E.Message+')$E004');//--DOC4.0.0°XN001 huangcq090407 add
      ShowMsgTwEcb('µo•Õø˘ª~ecb '+ ErrMsg);
   End;
End;
Finally
   Try
      AThread.Connection.Disconnect;
   Except
   end;
   ShowMsgTwEcb('§¡¬_¡pæ˜');
   LeaveCriticalSection(CriticalSection);
   NowIsRunning := false;
End;
end;


procedure TAMainFrm.TCPServerExecute(AThread: TIdPeerThread);
var SRequest,SRequestInit,ReadStr,ErrMsg: string;
begin
  EnterCriticalSection(CriticalSection);
  NowIsRunning := True;
Try
try
  with AThread.Connection do
  begin
      ShowMsgTW('¶≥§H≠n®D¡pæ˜.');
      //AThread.Connection.MaxLineLength:=FIndyMaxLineLength;
      WriteLn('ConnectOk');
      ReadStr := ReadLn;
      SRequestInit:=ReadStr;
      if (PosEx('<Cmd>',ReadStr)>0) and
         (PosEx('</Cmd>',ReadStr)>0) then
        SRequest:=GetStrOnly2('<Cmd>','</Cmd>',ReadStr,false)
      else if Pos('UPTLOGRECSFILE:', ReadStr)>0 then //≤{¶b¿≥∏”§£¶A•Œ§F
         SRequest := ReadStr
      else if (Pos('UPTOPLOGRECS:', ReadStr)=1) or (Pos('ECBUPTOPLOGRECS:', ReadStr)=1) then
         SRequest := ReadStr
      else if SameText(ReadStr,Cmd_RcvFile) Then
        SRequest := ReadStr
      else if (PosEx('DelOfTr1dbStockWeight', ReadStr)=1) or
              (PosEx('ReBackOfTr1dbStockWeight', ReadStr)=1) or
              (PosEx('TcriDatWrite',ReadStr)=1) then
         SRequest := ReadStr
      else
        SRequest := UpperCase(ReadStr);
      ShowMsgTW('≠n∞µ™∫∞ ß@¨O ' + SRequest);
      if (Pos('UPTOPLOGRECS:', SRequest)=1) then
        Pro_RequestUPTOPLOGRECS(AThread.Connection,SRequest,false)
      else if (Pos('ECBUPTOPLOGRECS:', SRequest)=1) then
        Pro_RequestUPTOPLOGRECS(AThread.Connection,SRequest,true)
      else if SameText(SRequest,'UserMng') Then
        Pro_RequestUserVlidate(AThread.Connection)
      else if (Pos('.DAT',SRequest)>0) or (SRequest = UpperCase('Date@closeidlist.lst')) or (PosEx('weekof@closeidlist.lst',SRequest)>0)  Then
        Pro_Request_Dat(AThread.Connection,SRequest)
      else if SameText(Cmd_RcvFile,SRequest) Then
        Pro_Request_RecvFile(AThread.Connection,SRequest)
      else if (Pos('.RTF',SRequest)>0) Then
         Pro_RequestGetDocRtf(AThread.Connection,SRequest)
      //CBDatEdit-DOC3.0.0ª›®D2-leon-08/8/18-add;
      else if (Pos('.TXT',SRequest)>0) and ((Pos('DOC_',SRequest)>0) ) Then
         Pro_RequestGetShenBaoDocText(AThread.Connection,SRequest)
      else if (Pos('.TXT',SRequest)>0) and ((Pos('DOC2_',SRequest)>0) ) Then
         Pro_RequestGetShenBaoDoc2Text(AThread.Connection,SRequest)
      else if Pos('.TXT',SRequest)>0 Then
         Pro_RequestGetNodeText(AThread.Connection,SRequest)
      //--
      else if (SRequest = UpperCase('SetDealer')) Then
        Pro_RequestSetDealer(AThread.Connection,SRequest)
      //add by wangjinhua ThreeTrader 091015
      else if (SRequest = UpperCase('SetThreeTrader')) Then
        Pro_RequestSetThreeTrader(AThread.Connection,SRequest)
      else if (SRequest = UpperCase('SetIFRSWork')) Then
        Pro_RequestSetIFRSWork(AThread.Connection,SRequest)
      else if (SRequest = UpperCase('AuditIFRSData')) Then
        Pro_RequestAuditIFRSData(AThread.Connection,SRequest)
      else if (SRequest = UpperCase('SetCBDat')) Then
        Pro_RequestSetCBDat(AThread.Connection,SRequest)
      else if (SRequest = UpperCase('SetCBTxt')) Then
        Pro_RequestSetCBTxt(AThread.Connection,SRequest)
      else if SameText(SRequest,'GETCBDATAOPLOG') then
        Pro_RequestGETCBDATAOPLOG(AThread.Connection,SRequest)
      else if SameText(SRequest,'GETIFRSOPLOG') then
        Pro_RequestGETIFRSOPLOG(AThread.Connection,SRequest)
      else if SameText(SRequest,'GETIFRSTR1DBDATA') then
        Pro_RequestGETIFRSTr1dbData(AThread.Connection,SRequest)
      else if (SRequest = 'READLOGDOC_01') Then
        Pro_RequestREADLOGDOC_01(AThread.Connection,SRequest)
      else if (SRequest = 'READLOGDOC_02') Then
        Pro_RequestREADLOGDOC_02(AThread.Connection,SRequest)
      else if (SRequest = 'READLOGDOC_03') Then
        Pro_RequestREADLOGDOC_03(AThread.Connection,SRequest)
      else if (SRequest = 'READDELLOGDOC_01') Then
        Pro_RequestREADDELLOGDOC_01(AThread.Connection,SRequest)
      else if (SRequest = 'READDELLOGDOC_02') Then
        Pro_RequestREADDELLOGDOC_02(AThread.Connection,SRequest)
      else if (SRequest = 'READDELLOGDOC_03') Then
        Pro_RequestREADDELLOGDOC_03(AThread.Connection,SRequest)
      else if SameText(SRequest,'READCANCELLOGDOC_02') Then
        Pro_RequestREADCancelLOGDOC_02(AThread.Connection,SRequest)
      else if SameText(SRequest,'READDELCANCELLOGDOC_02') Then
        Pro_RequestREADDELCancelLOGDOC_02(AThread.Connection,SRequest)
      else if (SRequest = UpperCase(_IFRSListPkgDat)) then 
        Pro_RequestListIFRS(AThread.Connection)
      else if (SRequest = 'READNEWDOC2')
         or (SRequest = 'READNEWDOC1')
         or (SRequest = 'READNEWDOC3') then
        Pro_RequestREADNEWDOC1(AThread.Connection,SRequest)
      else if (SRequest = 'INITREADNEWDOC2')
         or (SRequest = 'INITREADNEWDOC1')
         or (SRequest = 'INITREADNEWDOC3') then
        Pro_RequestINITREADNEWDOC1(AThread.Connection,SRequest)
      else if (SRequest = 'DOCCOUNT')  then
        Pro_RequestDOCCOUNT(AThread.Connection,SRequest)
      else if (SRequest = UpperCase('StkIndustryStatus')) or
              (SRequest = UpperCase('StkBase1Status')) or
              (SRequest = UpperCase('StkBase1StatusOfWeek')) or
              (SRequest = UpperCase('stockweightStatus'))  then
        Pro_Request_StkIndustryStatus_StkBase1Status(AThread.Connection,SRequest)
      else if (SRequest = 'DOC01OKTIME')  then
        Pro_RequestDOC01OKTIME(AThread.Connection,SRequest)
      else if (SRequest = 'DOC03OKTIME')  then
        Pro_RequestDOC03OKTIME(AThread.Connection,SRequest)
      else if (SRequest = 'GETZZSZHINT')  then
        Pro_RequestGETZZSZHINT(AThread.Connection,SRequest)
      else if (SRequest = 'DOCOK') or (SRequest = 'DOCDEL') then
        Pro_Request_DOCOK_DOCDEL(AThread.Connection,SRequest)
      else if SameText(SRequest,'DOCCANCEL') then
        Pro_Request_DOCCancel(AThread.Connection,SRequest)
      else if SameText(SRequest,'DOCDONE') then
        Pro_Request_DOCDone(AThread.Connection,_DocDoneTag,SRequest)
      else if SameText(SRequest,'DOCNONEEDDO') then
        Pro_Request_DOCDone(AThread.Connection,_DocNoNeedDoTag,SRequest)
      else if (SRequest = 'MANUALDOCSAVETMP') then
        Pro_RequestMANUALDOCSAVETMP(AThread.Connection)
      else if SRequest ='MANUALDOCREADNEWLOG' then
        Pro_RequestMANUALDOCREADNEWLOG(AThread.Connection)
      else if SRequest ='MANUALDOCREADALLLOG' then
        Pro_RequestMANUALDOCREADALLLOG(AThread.Connection)
      else if SRequest ='MANUALDOCREADTMP' then
        Pro_RequestMANUALDOCREADTMP(AThread.Connection)
      else if SRequest ='MANUALDOCDELBACKUPTMP' then
        Pro_RequestMANUALDOCDELBACKUPTMP(AThread.Connection)
      else if SRequest ='MANUALDOCREADDELTMPLOG' then
        Pro_RequestMANUALDOCREADDELTMPLOG(AThread.Connection)
      //----DOC4.4.0.0  add by pqx 20120204----------------------
      else if PosEx('IRRateStatusString', SRequest)>0 then
       Pro_RequestIRRateStatusString(AThread.Connection,SRequest,'')
      else if (PosEx('IRRateExcelRead',SRequest)=1)  then
         Pro_RequestIRRateFiles(AThread.Connection,SRequest,ReadStr)
      else if (PosEx('Tr1dbStockWeightRead',SRequest)=1)  then
         Pro_RequestTr1dbStockWeightFiles(AThread.Connection,SRequest,ReadStr)
      else if (PosEx('Tr1dbDelStockWeightRead',SRequest)=1)  then
         Pro_RequestTr1dbStockWeightDelFile(AThread.Connection,SRequest,ReadStr)
      else if (PosEx('IRRateDateDatWrite',SRequest)=1) then
         Pro_RequestSetIRRateFiles(AThread.Connection,SRequest,ReadStr)
      else if (PosEx('DiffOfLastShenBaoCase',SRequest)=1) then
         Pro_RequestDiffOfLastShenBaoCase(AThread.Connection,SRequest,ReadStr)
      else if (PosEx('SubmitShenBaoCase',SRequest)=1) then
         Pro_RequestSubmitShenBaoCase(AThread.Connection,SRequest,ReadStr)
      else if (PosEx('EcbRateDateDatWrite',SRequest)=1) then
         Pro_RequestSetEcbRateFiles(AThread.Connection,SRequest,ReadStr)
      else if (PosEx('StockWeightDateDatWrite',SRequest)=1) then
         Pro_RequestSetStockWeightFiles(AThread.Connection,SRequest,ReadStr)
      else if (PosEx('DelOfTr1dbStockWeight',SRequest)=1) then
         Pro_RequestDelOfTr1dbStockWeight(AThread.Connection,SRequest)
      else if (PosEx('ReBackOfTr1dbStockWeight',SRequest)=1) then
         Pro_RequestReBackOfTr1dbStockWeight(AThread.Connection,SRequest)
      else if (PosEx('TcriDatWrite',SRequest)=1) then
         Pro_RequestSetTcriFiles(AThread.Connection,SRequest,ReadStr)
      else if SameText(SRequest,'GETTCRIOPLOG') then
        Pro_RequestGETTcriOPLOG(AThread.Connection,SRequest);
  end;
Except
   On E : Exception do
   Begin
      ErrMsg := E.Message;
      //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError);  //--DOC4.0.0°™N001 huangcq090407 del
      SendDocMonitorWarningMsg('DocCenter Error'+'('+E.Message+')$E004');//--DOC4.0.0°XN001 huangcq090407 add
      ShowMsgTw('µo•Õø˘ª~ '+ ErrMsg);
   End;
End;
Finally
   Try
      AThread.Connection.Disconnect;
   Except
   end;
   ShowMsgTw('§¡¬_¡pæ˜');
   LeaveCriticalSection(CriticalSection);
   NowIsRunning := false;
End;
end;


function TAMainFrm.Pro_RequestDelOfTr1dbStockWeight(aConnect:TIdTCPConnection;SRequest:string):Integer;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
var sData,sDelCodeField,sLogOpCur,sTimeKey,sDstPath,sErr,sLogOpLst:string;
    bPro:boolean; ts:TStringList;
begin
  with aConnect do
  begin
    try
      ts:=TStringList.create;
      sDstPath:=FAppParam.Tr1DBPath+'CBData\stockweight\';
      if not DirectoryExists(sDstPath) then
        ForceDirectories(sDstPath);

      sData:=GetStrOnly2('<data>','</data>',SRequest,false);
      sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,SRequest,false);

        bPro:=true; sDelCodeField:='';
        if not (DelStockWeightData(sData,sDstPath,sErr,ts,sDelCodeField) and (sErr='')) then
        begin
          bPro:=false;
        end
        else ShowMsgTw('ßR∞£∏ÍÆ∆¶®•\');

        if not bPro then
          WriteLnErrEx('´·•x≥B≤z•¢±—.'+sErr)
        else begin
          sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
          if CBDataMgr.Setstockweight(ts,sDstPath,sLogOpCur,sTimeKey) then
          begin
            sLogOpLst:=sDelCodeField+_LogSep+''+_LogSep+_OpDel+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
              FAppParam.ConvertString(_stockweightMCaption)+_LogSep+_stockweightM+_LogSep+'0';
            Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
            WriteLnEx('ok');
          end else
            WriteLnErrEx('≤£•Õ§W∂«•Ù∞»•¢±—.');
        end;

    finally
      FreeAndNil(ts);
    end;
  end;
end;

function TAMainFrm.Pro_RequestReBackOfTr1dbStockWeight(aConnect:TIdTCPConnection;SRequest:string):Integer;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
var sData,sDelCodeField,sLogOpCur,sTimeKey,sDstPath,sErr,sLogOpLst:string;
    bPro:boolean; ts:TStringList;
begin
  with aConnect do
  begin
    try
      ts:=TStringList.create;
      sDstPath:=FAppParam.Tr1DBPath+'CBData\stockweight\';
      if not DirectoryExists(sDstPath) then
        ForceDirectories(sDstPath);

      sData:=GetStrOnly2('<data>','</data>',SRequest,false);
      sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,SRequest,false);


        bPro:=true; sDelCodeField:='';
        if not (ReBackStockWeightData(sData,sDstPath,sErr,ts,sDelCodeField) and (sErr='')) then
        begin
          bPro:=false;
        end
        else ShowMsgTw('¥_≠ÏßR∞£•\');

        if not bPro then
          WriteLnErrEx('´·•x≥B≤z•¢±—.'+sErr)
        else begin
          sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
          if CBDataMgr.Setstockweight(ts,sDstPath,sLogOpCur,sTimeKey) then
          begin
            sLogOpLst:=sDelCodeField+_LogSep+''+_LogSep+_OpReBack+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
              FAppParam.ConvertString(_stockweightMCaption)+_LogSep+_stockweightM+_LogSep+'0';
            Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
            WriteLnEx('ok');
          end else
            WriteLnErrEx('≤£•Õ§W∂«•Ù∞»•¢±—.');
        end;

    finally
      FreeAndNil(ts);
    end;
  end;
end;

function TAMainFrm.Pro_RequestTr1dbStockWeightFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var ACompressFile:TFileStream; tsNeedTransfer,ts:TStringList;
    i:integer;
    sTemp,sErrMsg,sZearoFiles,sUplFile:string;

  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;

begin
  with aConnect do
  begin
    ACompressFile:=nil; tsNeedTransfer:=nil; ts:=nil;
    try
      sUplFile:='';
      tsNeedTransfer:=TStringList.create;
      ts:=TStringList.create;
      FolderAllFiles(FAppParam.Tr1DBPath+'CBData\stockweight\','.dat',ts,False);

      for i:=0 to ts.count-1 do
      begin
        sTemp:=ExtractFileName(ts[i]);
        sTemp:=StringReplace(sTemp,'stockweight','',[rfReplaceAll, rfIgnoreCase]);
        sTemp:=StringReplace(sTemp,'.dat','',[rfReplaceAll, rfIgnoreCase]);
        if MayBeDigital(sTemp) then
          tsNeedTransfer.Add(ts[i]);
      end;

      sUplFile:=GetWinTempPath+sCmd+'.upl';//+Get_GUID8
      if FileExists(sUplFile) then
        DeleteFile(sUplFile);
      sUplFile:=ComparessFileListToFile(tsNeedTransfer,sUplFile,'',sZearoFiles);
      if sUplFile='' then
      begin
        WriteLnErrEx('upl§Â¿…•¥•]•¢±—.');
        exit;
      end;

      WriteLnEx('HELLO');
      sTemp:=ReadLn;
      if not SameText(sTemp,'HELLO') then
      begin
        WriteLnEx('rsp error.'+sTemp);
        exit;
      end;

      ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆.');
      if FileExists(sUplFile) Then
      begin
        if not Pro_TransferFile_ForCBDataFiles(aConnect,sUplFile,false) then
        begin
          ShowMsgTw('∂«øÈ∏ÍÆ∆•¢±—.');
          exit;
        end;
      end
      else begin
        ShowMsgTw('∂«øÈ∏ÍÆ∆•¢±—,file not exists,'+sUplFile);
        exit;
      end;
      DeleteFile(sUplFile);
      ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');

    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
      try
        if Assigned(ts) then
          FreeAndNil(ts);
      except
      end;
    end;
  end;
end;

{
function TAMainFrm.Pro_RequestReadNodeFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var ACompressFile:TFileStream; tsNeedTransfer,ts:TStringList;
    i,j:integer;
    sTemp,sUplFile,sOneFile,sTempFile:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;

begin
  with aConnect do
  begin
    ACompressFile:=nil; tsNeedTransfer:=nil; ts:=nil;
    try
      sUplFile:='';
      sTemp:=CBDataMgr.GetCBDB_FullPath;
      if not DirectoryExists(sTemp) then
        Mkdir_Directory(sTemp);
      sUplFile:=sTemp+_CBDBUplFile;
      if not FileExists(sUplFile) then
      begin
        tsNeedTransfer:=TStringList.create;
        ts:=TStringList.create;
        FolderAllFiles(sTemp,'.dat',ts,false);
        for i:=0 to ts.count-1 do
        begin
          if FileExists(ts[i]) then
            tsNeedTransfer.Add(ts[i]);
        end;

        sUplFile:=ComparessFileListToFile(tsNeedTransfer,sUplFile,'');
        //InputDatFileFmt2(sUplFile,'e:\',sTemp);
        if sUplFile='' then
        begin
          WriteLnErrEx('upl§Â¿…•¥•]•¢±—.');
          exit;
        end;
      end;

      WriteLnEx('HELLO');
      sTemp:=ReadLn;
      if not SameText(sTemp,'HELLO') then
      begin
        WriteLnEx('rsp error.'+sTemp);
        exit;
      end;

      ShowMsg2Tw('∑«≥∆∂«øÈ∏ÍÆ∆.');
      if FileExists(sUplFile) Then
      begin
        if not Pro_TransferFile_ForCBDataFiles(aConnect,sUplFile) then
        begin
          ShowMsg2Tw('∑«≥∆∂«øÈ∏ÍÆ∆•¢±—.');
          exit;
        end;
      end;
      DeleteFile(sUplFile);
      ShowMsg2Tw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
      try
        if Assigned(ts) then
          FreeAndNil(ts);
      except
      end;
    end;
  end;
end; }


function TAMainFrm.CheckIRSavePathList:string;
  procedure AddRst(aLog:string);
  begin
    if Result='' then result:=aLog
    else result:=result+#13#10+aLog;
  end;
var i:integer;
begin
try
  result:='';
  if FIRSavePathList.count=0 then
    AddRst('§Ω∂≈ßQ≤v¶s¿x∏ÙÆ|•º≥]©w°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚');
  if FRateLogPath='' then
    AddRst('§Ω∂≈ßQ≤vº∆æ⁄Log¶s¿x∏ÙÆ|•º≥]©w°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚');
  if Result<>'' then
    exit;
  for i:=0 to FIRSavePathList.count-1 do
  begin
    if not DirectoryExists(FIRSavePathList[i]) then
      AddRst('§Ω∂≈ßQ≤v¶s¿x∏ÙÆ|('+FIRSavePathList[i]+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
  end;
  if not DirectoryExists(FRateLogPath) then
    AddRst('§Ω∂≈ßQ≤vº∆æ⁄Log¶s¿x∏ÙÆ|('+FRateLogPath+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
    
  if not DirectoryExists(FRateDatUploadWorkDir) then
    AddRst('§Ω∂≈ßQ≤v§W∂«•Ù∞»¿x∏ÙÆ|('+FRateDatUploadWorkDir+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
finally
  if Result<>'' then
    Result:=(result);
end;
end;

function TAMainFrm.CheckIReExcekSavePath1:string;
  procedure AddRst(aLog:string);
  begin
    if Result='' then result:=aLog
    else result:=result+#13#10+aLog;
  end;
begin
try
  result:='';   
  if (FBC14Path='') or
     (FBC2Path='') or
     (FBC3Path='') or
     (FBC5Path='') or
     (FBC6Path='')  then
  begin
    AddRst('§Ω∂≈ßQ≤vexcel¶s¿x∏ÙÆ|•º≥]©w°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
  end;
  if Result<>'' then
    exit;
  if (not DirectoryExists(FBC14Path)) then
    AddRst('§Ω∂≈ßQ≤vexcel¶s¿x∏ÙÆ|('+FBC14Path+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
  if (not DirectoryExists(FBC2Path)) then
    AddRst('§Ω∂≈ßQ≤vexcel¶s¿x∏ÙÆ|('+FBC2Path+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
  if (not DirectoryExists(FBC3Path)) then
    AddRst('§Ω∂≈ßQ≤vexcel¶s¿x∏ÙÆ|('+FBC3Path+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
  if (not DirectoryExists(FBC5Path)) then
    AddRst('§Ω∂≈ßQ≤vexcel¶s¿x∏ÙÆ|('+FBC5Path+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
  if (not DirectoryExists(FBC6Path)) then
    AddRst('§Ω∂≈ßQ≤vexcel¶s¿x∏ÙÆ|('+FBC6Path+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
finally
  if Result<>'' then
    Result:=(result);
end;
end;

function TAMainFrm.CheckIReExcekSavePath2:string;
  procedure AddRst(aLog:string);
  begin
    if Result='' then result:=aLog
    else result:=result+#13#10+aLog;
  end;
begin
try
  result:='';
  if (FSwapOptionPath='') then
  begin
    AddRst('øÔæ‹≈vexcel¶s¿x∏ÙÆ|•º≥]©w°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
  end;
  if FSwapYieldPath='' then
  begin
    AddRst('©T©w¶¨Øqexcel¶s¿x∏ÙÆ|•º≥]©w°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
  end;
  if Result<>'' then
    exit;
  if not DirectoryExists(FSwapOptionPath) then
    AddRst('øÔæ‹≈vexcel¶s¿x∏ÙÆ|('+FSwapOptionPath+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
  if not DirectoryExists(FSwapYieldPath) then
    AddRst('©T©w¶¨Øqexcel¶s¿x∏ÙÆ|('+FSwapYieldPath+')µL™k≥s±µ°AΩ–¡p√¥®t≤Œ∫ﬁ≤z≠˚.');
finally
  if Result<>'' then
    Result:=(result);
end;
end;

function TAMainFrm.GetIRRateStatusString(aDate:TDate):string;
var i:integer; s,s1,s2,sIniFile:string; 
begin
  result:='';
  s:=CheckIRSavePathList;
  s1:=CheckIReExcekSavePath1;
  s2:=CheckIReExcekSavePath2;

  if (s1<>'') or (s<>'') then
  begin
    result:='[DocCenterÆ¯Æß]'+#13#10+s1+#13#10+s+#13#10+s2;
    exit;
  end;
  
  s:='';
  for i:=0 to FIRSavePathList.count-1 do
  begin
    if not DirectoryExists(FIRSavePathList[i]) then
    begin
      s1:='∏ÙÆ|§£¶s¶b.';
    end
    else begin
      s1:=RateExistsDateLoacal(FIRSavePathList[i],aDate);
    end;
    if s1<>'' then
    begin
      s:=s+#13#10+FIRSavePathList[i]+#13#10+s1;
    end;
  end;
  if s<>'' then
  begin
    s:=FmtDt8(aDate)+'µL™k§W∂«,Ω–ΩTª{§U¶C∏ÍÆ∆¨Oß_§w∏g¶®•\´O¶s[DocCenterÆ¯Æß].'+#13#10+s;
  end;
  {else begin
    if RecordedUpl(aDate) then
      s:=fmtdt8(aDate)+'§w§W∂«.'
    else
      s:=fmtdt8(aDate)+'´›§W∂«.';
  end; }
  result:=(s);
end;

function TAMainFrm.Pro_RequestIRRateStatusString(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var sDate,sTemp:string; dtDate:TDate;
begin
  with aConnect do
  begin
    sDate:=StringReplace(sCmd,'IRRateStatusString','',[rfReplaceAll, rfIgnoreCase]);
    if Length(sDate)<>8 then
    begin
      sTemp:='¶VdoccenterΩ–®D©R•OÆÊ¶°ø˘ª~.';
    end
    else begin
      dtDate:=DateStr8ToDate(sDate);
      sTemp:=GetIRRateStatusString(dtDate);
    end;
    ShowMsgTw('§Ω∂≈ßQ≤v™¨∫A´HÆß:'+sTEMP);
    sTEMP:=StringReplace(sTEMP,#13#10,'#13#10',[rfReplaceAll]);
    WriteLn('status='+sTEMP);
  end;
end;

function TAMainFrm.Pro_RequestTr1dbStockWeightDelFile(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var ACompressFile:TFileStream; tsNeedTransfer:TStringList;
    i:integer;
    sTemp,sErrMsg,sZearoFiles,sUplFile:string;

  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;

begin
  with aConnect do
  begin
    ACompressFile:=nil; tsNeedTransfer:=nil;
    try
      sUplFile:='';
      tsNeedTransfer:=TStringList.create;
      tsNeedTransfer.Add(FAppParam.Tr1DBPath+'CBData\stockweight\'+_stockweightDelF);
      sUplFile:=GetWinTempPath+sCmd+'.upl';//+Get_GUID8
      if FileExists(sUplFile) then
        DeleteFile(sUplFile);
      sUplFile:=ComparessFileListToFile(tsNeedTransfer,sUplFile,'',sZearoFiles);
      if sUplFile='' then
      begin
        WriteLnErrEx('upl§Â¿…•¥•]•¢±—.');
        exit;
      end;

      WriteLnEx('HELLO');
      sTemp:=ReadLn;
      if not SameText(sTemp,'HELLO') then
      begin
        WriteLnEx('rsp error.'+sTemp);
        exit;
      end;

      ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆.');
      if FileExists(sUplFile) Then
      begin
        if not Pro_TransferFile_ForCBDataFiles(aConnect,sUplFile,false) then
        begin
          ShowMsgTw('∂«øÈ∏ÍÆ∆•¢±—.');
          exit;
        end;
      end
      else begin
        ShowMsgTw('∂«øÈ∏ÍÆ∆•¢±—,file not exists,'+sUplFile);
        exit;
      end;
      DeleteFile(sUplFile);
      ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');

    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestIRRateFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var ACompressFile:TFileStream; tsNeedTransfer,ts:TStringList;
    i,j:integer;
    sTemp,sErrMsg,sZearoFiles,sDate,sUplFile,
    sDatPath,sExcelPath:string;

    aTempErr:string; aLogDt:TDate;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;

begin
  with aConnect do
  begin
    ACompressFile:=nil; tsNeedTransfer:=nil; ts:=nil;
    try
      sUplFile:='';
      tsNeedTransfer:=TStringList.create;
      ts:=TStringList.create;
        sDate:=StringReplace(sCmd,'IRRateExcelRead','',[rfReplaceAll, rfIgnoreCase]);
        sTemp:=FBC14Path + sDate+'.xls';
        if FileExists(sTemp) then
        begin
          tsNeedTransfer.Add(sTemp);
          ts.Add('Yield Curve');
        end;
        sTemp:=FBC2Path + sDate+'.xls';
        if FileExists(sTemp) then
        begin
          tsNeedTransfer.Add(sTemp);
          ts.Add('Daily Price');
        end;
        sTemp:=FBC3Path + sDate+'.xls';
        if FileExists(sTemp) then
        begin
          tsNeedTransfer.Add(sTemp);
          ts.Add('Daily Index');
        end;
        sTemp:=FBC6Path + sDate+'.xls';
        if FileExists(sTemp) then
        begin
          tsNeedTransfer.Add(sTemp);
          ts.Add('CbRefRate');
        end;
        sTemp:=FSwapOptionPath + sDate+'.xls';
        if FileExists(sTemp) then
        begin
          tsNeedTransfer.Add(sTemp);
          ts.Add('SwapOption');
        end;
        sTemp:=FSwapYieldPath + sDate+'.xls';
        if FileExists(sTemp) then
        begin
          tsNeedTransfer.Add(sTemp);
          ts.Add('SwapYield');
        end;

      sUplFile:=GetWinTempPath+sCmd+'.upl';//+Get_GUID8
      if FileExists(sUplFile) then
        DeleteFile(sUplFile);
      sUplFile:=ComparessFileListToFile2(tsNeedTransfer,ts,sUplFile,sZearoFiles);
      //InputDatFileFmt2(sUplFile,'e:\',sTemp);
      if sUplFile='' then
      begin
        WriteLnErrEx('upl§Â¿…•¥•]•¢±—.');
        exit;
      end;

      WriteLnEx('HELLO');
      sTemp:=ReadLn;
      if not SameText(sTemp,'HELLO') then
      begin
        WriteLnEx('rsp error.'+sTemp);
        exit;
      end;

      ShowMsgTw('∑«≥∆∂«øÈ∏ÍÆ∆.');
      if FileExists(sUplFile) Then
      begin
        if not Pro_TransferFile_ForCBDataFiles(aConnect,sUplFile,false) then
        begin
          ShowMsgTw('∂«øÈ∏ÍÆ∆•¢±—.');
          exit;
        end;
      end
      else begin
        ShowMsgTw('∂«øÈ∏ÍÆ∆•¢±—,file not exists,'+sUplFile);
        exit;
      end;
      DeleteFile(sUplFile);
      ShowMsgTw('ßπ¶®∂«øÈ∏ÍÆ∆');

    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
      try
        if Assigned(ts) then
          FreeAndNil(ts);
      except
      end;
    end;
  end;
end;


function TAMainFrm.Pro_RequestReadNodeFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var ACompressFile:TFileStream; tsNeedTransfer,ts:TStringList;
    i,j:integer;
    sTemp,sUplFile,sOneFile,sTempFile,sZearoFiles:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;

begin
  with aConnect do
  begin
    ACompressFile:=nil; tsNeedTransfer:=nil;
    try
      sUplFile:='';
      //InputDatFileFmt2(sUplFile,'e:\',sTemp);
      for i:=1 to 3 do
      begin
        if FCBDataWorkHandle.FCBNodeDat_PackTag then
        begin
          Sleep(1000);
        end
        else break;
      end;
      if FCBDataWorkHandle.FCBNodeDat_PackTag then
      begin
        WriteLnErrEx('Tr1db∏`¬I∏ÍÆ∆•ø¶b•¥•]ßÛ∑s§§.');
        exit;
      end;
      if SameText(sCmd,'ReadEcbNodeFiles') then
      begin
        if Assigned(FCBDataWorkHandleEcb) then 
        sUplFile:=FCBDataWorkHandleEcb.FCBNodeDat_PackFile;
      end
      else begin
        sUplFile:=FCBDataWorkHandle.FCBNodeDat_PackFile;
      end;
      if sUplFile='' then
      begin
        WriteLnErrEx('upl§Â¿…•¥•]•¢±—.');
        exit;
      end;

      WriteLnEx('HELLO');
      sTemp:=ReadLn;
      if not SameText(sTemp,'HELLO') then
      begin
        WriteLnEx('rsp error.'+sTemp);
        exit;
      end;

      ShowMsg2Tw('∑«≥∆∂«øÈ∏ÍÆ∆.');
      if FileExists(sUplFile) Then
      begin
        if not Pro_TransferFile_ForCBDataFiles(aConnect,sUplFile) then
        begin
          ShowMsg2Tw('∂«øÈ∏ÍÆ∆•¢±—.');
          exit;
        end;
      end
      else begin
        ShowMsg2Tw('∂«øÈ∏ÍÆ∆•¢±—,file not exists,'+sUplFile);
        exit;
      end;
      //DeleteFile(sUplFile);
      ShowMsg2Tw('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
      try
        if Assigned(ts) then
          FreeAndNil(ts);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestReadNodeFilesEcb(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var ACompressFile:TFileStream; tsNeedTransfer,ts:TStringList;
    i,j:integer;
    sTemp,sUplFile,sOneFile,sTempFile,sZearoFiles:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsg2TwEcb(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsg2TwEcb(amsg);
    aConnect.WriteLn(amsg);
  end;

begin
  with aConnect do
  begin
    ACompressFile:=nil; tsNeedTransfer:=nil;
    try
      sUplFile:='';
      for i:=1 to 3 do
      begin
        if FCBDataWorkHandleEcb.FCBNodeDat_PackTag then
        begin
          Sleep(1000);
        end
        else break;
      end;
      if FCBDataWorkHandleEcb.FCBNodeDat_PackTag then
      begin
        WriteLnErrEx('Tr1db∏`¬I∏ÍÆ∆•ø¶b•¥•]ßÛ∑s§§.');
        exit;
      end;
      sUplFile:=FCBDataWorkHandleEcb.FCBNodeDat_PackFile;
      if sUplFile='' then
      begin
        WriteLnErrEx('upl§Â¿…•¥•]•¢±—.');
        exit;
      end;

      WriteLnEx('HELLO');
      sTemp:=ReadLn;
      if not SameText(sTemp,'HELLO') then
      begin
        WriteLnEx('rsp error.'+sTemp);
        exit;
      end;

      ShowMsg2TwEcb('∑«≥∆∂«øÈ∏ÍÆ∆.');
      if FileExists(sUplFile) Then
      begin
        if not Pro_TransferFile_ForCBDataFiles(aConnect,sUplFile) then
        begin
          ShowMsg2TwEcb('∂«øÈ∏ÍÆ∆•¢±—.');
          exit;
        end;
      end
      else begin
        ShowMsg2TwEcb('∂«øÈ∏ÍÆ∆•¢±—,file not exists,'+sUplFile);
        exit;
      end;
      //DeleteFile(sUplFile);
      ShowMsg2TwEcb('ßπ¶®∂«øÈ∏ÍÆ∆');
    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
      try
        if Assigned(ts) then
          FreeAndNil(ts);
      except
      end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestReadCBDataFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var ACompressFile:TFileStream; tsNeedTransfer:TStringList;
    sTemp,sLock,sLocker:string; DatFileList,GuidList,RspDatFileList,RspGuidList:_cStrLst2;
    i,j:integer;
    sUplFile,sOneFile,sTempLock,sTempGuid,sTempFile,sZearoFiles:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure AddToRsp(aRspGuid,aRspFileName:string);
  var x1:integer;
  begin
     x1:=Length(RspDatFileList);
     SetLength(RspDatFileList,x1+1);
     SetLength(RspGuidList,x1+1);
     RspDatFileList[x1]:=aRspFileName;
     RspGuidList[x1]:=aRspGuid;
  end;
  function GetRspDatFileListText:string;
  begin
    result:=GetStrLst2Text(RspDatFileList);
  end;
  function GetRspGUIDListText:string;
  begin
    result:=GetStrLst2Text(RspGuidList);
  end;

  function ProOfWork_1:string;
  var x1:Integer;
  begin
    result:='';
    tsNeedTransfer.clear;
    SetLength(RspDatFileList,0);
    SetLength(RspGuidList,0);

      for x1:=0 to High(DatFileList) do
      begin
        sOneFile:=DatFileList[x1];
        sTempLock:=FCBDataTokenMng.CheckDatLock(sOneFile);
        if (sTempLock<>'') and (not SameText(sTempLock,sLocker)) then
        begin
          result:=(sOneFile+'§Â¿…≥Q®‰•L®œ•Œ™Ã¬Í©w.'+sTempLock);
          exit;
        end;
        sTempGuid:=FCBDataTokenMng.GetDatGuid(sOneFile);
        if (not SameText(sTempGuid,GuidList[x1])) then
        begin
          sTempFile:=CBDataMgr.GetCBDataFile_FullPath(sOneFile);
          if FileExists(sTempFile) then
          begin
            AddToRsp(sTempGuid,sOneFile);
            tsNeedTransfer.Add(sTempFile);
          end;
        end;
      end;
  end;

  function ProOfWork_2:string;
  begin
    result:='';
    if not FCBDataTokenMng.LockDatFileList(DatFileList,sLocker) then 
    begin
      result:=('§Â¿…¬Í©w•¢±—.'+sLocker);
      exit;
    end;
  end;
begin
  with aConnect do
  begin
    ACompressFile:=nil; tsNeedTransfer:=nil;
    try
      sLock:=GetStrOnly2('<Lock>','</Lock>',SRequest,false);
      sLocker:=GetStrOnly2('<Locker>','</Locker>',SRequest,false);
      sTemp:=GetStrOnly2('<DatFileList>','</DatFileList>',SRequest,false);
      DatFileList:=DoStrArray2(sTemp,',');
      sTemp:=GetStrOnly2('<GuidList>','</GuidList>',SRequest,false);
      GuidList:=DoStrArray2(sTemp,',');
      if (not SameText(sLock,'0')) and (not SameText(sLock,'1'))  then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Lock='+sLock);
        exit;
      end;
      if sLocker='' then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Locker=null');
        exit;
      end;
      if Length(GuidList)=0 then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Length(GuidList)=0');
        exit;
      end;
      if Length(GuidList)<>Length(DatFileList) then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Length(GuidList)<>Length(DatFileList)');
        exit;
      end;

      sUplFile:='';
      tsNeedTransfer:=TStringList.create;
      sTemp:='';
      for i:=1 to 5 do
      begin
        sTemp:=ProOfWork_1;
        if sTemp='' then
          break;
        Sleep(2000);
      end;
      if sTemp<>'' then
      begin
        WriteLnErrEx(sTemp);
        exit;
      end;
        
      //ª›≠n¬Í©w§Â¿…
      if SameText(sLock,'1') then
      begin
        for i:=1 to 5 do
        begin
          sTemp:=ProOfWork_2;
          if sTemp='' then
            break;
          Sleep(2000);
        end;
        if sTemp<>'' then
        begin
          WriteLnErrEx(sTemp);
          exit;
        end;
      end;

      if tsNeedTransfer.Count=1 then
      begin
        j:=FCBDataTokenMng.IndexOfDat(ExtractFileName(tsNeedTransfer[0]));
        for i:=1 to 3 do
        begin
          if FCBDataWorkHandle.FCBDataAry_PackTag[j] then
          begin
            Sleep(1000);
          end
          else break;
        end;
        if FCBDataWorkHandle.FCBDataAry_PackTag[j] then
        begin
          WriteLnErrEx(ExtractFileName(tsNeedTransfer[0])+'•ø¶b•¥•]ßÛ∑s§§.');
          exit;
        end;
        sUplFile:=FCBDataWorkHandle.FCBDataAry_PackFile[j];
      end
      else begin
        for i:=1 to 3 do
        begin
          if FCBDataWorkHandle.FCBDataAll_PackTag or
             FCBDataWorkHandle.FCBDataExceptCbdocAll_PackTag then
          begin
            Sleep(1000);
          end
          else break;
        end;
        if FCBDataWorkHandle.FCBDataAll_PackTag or
           FCBDataWorkHandle.FCBDataExceptCbdocAll_PackTag then
        begin
          WriteLnErrEx('cbdata∏ÍÆ∆•ø¶b•¥•]ßÛ∑s§§.');
          exit;
        end;
        j:=-1;
        for i:=0 to tsNeedTransfer.Count-1 do
        begin
          if SameText(ExtractFileName(tsNeedTransfer[i]),'cbdoc.dat') then
          begin
            j:=i;
            break;
          end;
        end;
        if j=-1 then
          sUplFile:=FCBDataWorkHandle.FCBDataExceptCbdocAll_PackFile
        else
          sUplFile:=FCBDataWorkHandle.FCBDataAll_PackFile;
      end;
      {sUplFile:=GetWinTempPath+sCmd+Get_GUID8+'.upl';//
      if FileExists(sUplFile) then
        DeleteFile(sUplFile);
      sUplFile:=ComparessFileListToFile(tsNeedTransfer,sUplFile,'',sZearoFiles); }
      //InputDatFileFmt2(sUplFile,'e:\',sTemp);
      if sUplFile='' then
      begin
        WriteLnErrEx('upl§Â¿…•¥•]•¢±—.');
        exit;
      end;

      sTemp:='<RspGuidList>'+GetRspGUIDListText+'</RspGuidList>'+
             '<RspDatFileList>'+GetRspDatFileListText+'</RspDatFileList>';
      WriteLnEx(sTemp);
      sTemp:=ReadLn;
      if not SameText(sTemp,'HELLO') then
      begin
        WriteLnEx('rsp error.'+sTemp);
        exit;
      end;

      ShowMsg2Tw('∑«≥∆∂«øÈ∏ÍÆ∆.');
      if FileExists(sUplFile) Then
      begin
        if not Pro_TransferFile_ForCBDataFiles(aConnect,sUplFile) then
        begin
          ShowMsg2Tw('∂«øÈ∏ÍÆ∆•¢±—.');
          exit;
        end;
      end
      else begin
        ShowMsg2Tw('∂«øÈ∏ÍÆ∆•¢±—,file not exists,'+sUplFile);
        exit;
      end;
      //DeleteFile(sUplFile);
      ShowMsg2Tw('ßπ¶®∂«øÈ∏ÍÆ∆');

    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
      try SetLength(DatFileList,0); except end;
      try SetLength(GuidList,0); except end;
      try SetLength(RspDatFileList,0); except end;
      try SetLength(RspGuidList,0); except end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestReadCBDataFilesEcb(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var ACompressFile:TFileStream; tsNeedTransfer:TStringList;
    sTemp,sLock,sLocker:string; DatFileList,GuidList,RspDatFileList,RspGuidList:_cStrLst2;
    i,j:integer;
    sUplFile,sOneFile,sTempLock,sTempGuid,sTempFile,sZearoFiles:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsg2TwEcb(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsg2TwEcb(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure AddToRsp(aRspGuid,aRspFileName:string);
  var x1:integer;
  begin
     x1:=Length(RspDatFileList);
     SetLength(RspDatFileList,x1+1);
     SetLength(RspGuidList,x1+1);
     RspDatFileList[x1]:=aRspFileName;
     RspGuidList[x1]:=aRspGuid;
  end;
  function GetRspDatFileListText:string;
  begin
    result:=GetStrLst2Text(RspDatFileList);
  end;
  function GetRspGUIDListText:string;
  begin
    result:=GetStrLst2Text(RspGuidList);
  end;

  function ProOfWork_1:string;
  var x1:Integer;
  begin
    result:='';
    tsNeedTransfer.clear;
    SetLength(RspDatFileList,0);
    SetLength(RspGuidList,0);

      for x1:=0 to High(DatFileList) do
      begin
        sOneFile:=DatFileList[x1];
        sTempLock:=FCBDataTokenMngEcb.CheckDatLock(sOneFile);
        if (sTempLock<>'') and (not SameText(sTempLock,sLocker)) then
        begin
          result:=(sOneFile+'§Â¿…≥Q®‰•L®œ•Œ™Ã¬Í©w.'+sTempLock);
          exit;
        end;
        sTempGuid:=FCBDataTokenMngEcb.GetDatGuid(sOneFile);
        if (not SameText(sTempGuid,GuidList[x1])) then
        begin
          sTempFile:=CBDataMgrEcb.GetCBDataFile_FullPath(sOneFile);
          if FileExists(sTempFile) then
          begin
            AddToRsp(sTempGuid,sOneFile);
            tsNeedTransfer.Add(sTempFile);
          end;
        end;
      end;
  end;

  function ProOfWork_2:string;
  begin
    result:='';
    if not FCBDataTokenMngEcb.LockDatFileList(DatFileList,sLocker) then 
    begin
      result:=('§Â¿…¬Í©w•¢±—.'+sLocker);
      exit;
    end;
  end;
begin
  with aConnect do
  begin
    ACompressFile:=nil; tsNeedTransfer:=nil;
    try
      sLock:=GetStrOnly2('<Lock>','</Lock>',SRequest,false);
      sLocker:=GetStrOnly2('<Locker>','</Locker>',SRequest,false);
      sTemp:=GetStrOnly2('<DatFileList>','</DatFileList>',SRequest,false);
      DatFileList:=DoStrArray2(sTemp,',');
      sTemp:=GetStrOnly2('<GuidList>','</GuidList>',SRequest,false);
      GuidList:=DoStrArray2(sTemp,',');
      if (not SameText(sLock,'0')) and (not SameText(sLock,'1'))  then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Lock='+sLock);
        exit;
      end;
      if sLocker='' then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Locker=null');
        exit;
      end;
      if Length(GuidList)=0 then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Length(GuidList)=0');
        exit;
      end;
      if Length(GuidList)<>Length(DatFileList) then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Length(GuidList)<>Length(DatFileList)');
        exit;
      end;

      sUplFile:='';
      tsNeedTransfer:=TStringList.create;
      sTemp:='';
      for i:=1 to 5 do
      begin
        sTemp:=ProOfWork_1;
        if sTemp='' then
          break;
        Sleep(2000);
      end;
      if sTemp<>'' then
      begin
        WriteLnErrEx(sTemp);
        exit;
      end;
        
      //ª›≠n¬Í©w§Â¿…
      if SameText(sLock,'1') then
      begin
        for i:=1 to 5 do
        begin
          sTemp:=ProOfWork_2;
          if sTemp='' then
            break;
          Sleep(2000);
        end;
        if sTemp<>'' then
        begin
          WriteLnErrEx(sTemp);
          exit;
        end;
      end;

      if tsNeedTransfer.Count=1 then
      begin
        j:=FCBDataTokenMngEcb.IndexOfDat(ExtractFileName(tsNeedTransfer[0]));
        for i:=1 to 3 do
        begin
          if FCBDataWorkHandleEcb.FCBDataAry_PackTag[j] then
          begin
            Sleep(1000);
          end
          else break;
        end;
        if FCBDataWorkHandleEcb.FCBDataAry_PackTag[j] then
        begin
          WriteLnErrEx(ExtractFileName(tsNeedTransfer[0])+'•ø¶b•¥•]ßÛ∑s§§.');
          exit;
        end;
        sUplFile:=FCBDataWorkHandleEcb.FCBDataAry_PackFile[j];
      end
      else begin
        for i:=1 to 3 do
        begin
          if FCBDataWorkHandleEcb.FCBDataAll_PackTag or
             FCBDataWorkHandleEcb.FCBDataExceptCbdocAll_PackTag then
          begin
            Sleep(1000);
          end
          else break;
        end;
        if FCBDataWorkHandleEcb.FCBDataAll_PackTag or
           FCBDataWorkHandleEcb.FCBDataExceptCbdocAll_PackTag then
        begin
          WriteLnErrEx('cbdata∏ÍÆ∆•ø¶b•¥•]ßÛ∑s§§.');
          exit;
        end;
        j:=-1;
        for i:=0 to tsNeedTransfer.Count-1 do
        begin
          if SameText(ExtractFileName(tsNeedTransfer[i]),'cbdoc.dat') then
          begin
            j:=i;
            break;
          end;
        end;
        if j=-1 then
          sUplFile:=FCBDataWorkHandleEcb.FCBDataExceptCbdocAll_PackFile
        else
          sUplFile:=FCBDataWorkHandleEcb.FCBDataAll_PackFile;
      end;
      
      //InputDatFileFmt2(sUplFile,'e:\',sTemp);
      if sUplFile='' then
      begin
        WriteLnErrEx('upl§Â¿…•¥•]•¢±—.');
        exit;
      end;

      sTemp:='<RspGuidList>'+GetRspGUIDListText+'</RspGuidList>'+
             '<RspDatFileList>'+GetRspDatFileListText+'</RspDatFileList>';
      WriteLnEx(sTemp);
      sTemp:=ReadLn;
      if not SameText(sTemp,'HELLO') then
      begin
        WriteLnEx('rsp error.'+sTemp);
        exit;
      end;

      ShowMsg2TwEcb('∑«≥∆∂«øÈ∏ÍÆ∆.');
      if FileExists(sUplFile) Then
      begin
        if not Pro_TransferFile_ForCBDataFiles(aConnect,sUplFile) then
        begin
          ShowMsg2TwEcb('∂«øÈ∏ÍÆ∆•¢±—.');
          exit;
        end;
      end
      else begin
        ShowMsg2TwEcb('∂«øÈ∏ÍÆ∆•¢±—,file not exists,'+sUplFile);
        exit;
      end;
      //DeleteFile(sUplFile);
      ShowMsg2TwEcb('ßπ¶®∂«øÈ∏ÍÆ∆');

    finally
      try
        if Assigned(ACompressFile) then
          FreeAndNil(ACompressFile);
      except
      end;
      try
        if Assigned(tsNeedTransfer) then
          FreeAndNil(tsNeedTransfer);
      except
      end;
      try SetLength(DatFileList,0); except end;
      try SetLength(GuidList,0); except end;
      try SetLength(RspDatFileList,0); except end;
      try SetLength(RspGuidList,0); except end;
    end;
  end;
end;

function TAMainFrm.Pro_TransferFile_ForCBDataFiles(aConnect:TIdTCPConnection;aSrc:string;aShow2Tw:boolean):boolean;
    function StartShow(aMax:integer):Boolean;
    begin
      Application.ProcessMessages;
    end;
    function UptShow(aPos,aMax:integer):Boolean;
    begin
      Application.ProcessMessages;
    end;
    procedure WriteLnEx(amsg:string);
    begin
      if aShow2Tw then ShowMsg2Tw(amsg)
      else ShowMsgTw(amsg);
      aConnect.WriteLn(amsg);
    end;
const CBDataFilesPerSize = 4096;
var iFileHandle,iFileLen,cnt,iSize,iPerSize:integer;
    //buf:array[0..CBDataFilesPerSize-1] of byte;
    buf:array of byte;
    sTemp1,SResponse:string;
begin
  result:=false;
  with aConnect do
  begin
        //iPerSize:=8192;
        iPerSize:=FPerSize;
        try
          setlength(buf,iPerSize);
          iFileHandle:=FileOpen(aSrc,fmOpenRead);
          iFileLen:=FileSeek(iFileHandle,0,2);
          FileSeek(iFileHandle,0,0);
          sTemp1:='<FileLen>'+ Inttostr(iFileLen) +'</FileLen>'+
                  '<PerSize>'+ Inttostr(iPerSize) +'</PerSize>';
          WriteLn(sTemp1);
          SResponse := (ReadLn);
          if not sametext('HELLO', SResponse) then exit;
          cnt:=0;
          StartShow(iFileLen);

          while true do
          begin
            iSize:=FileRead(iFileHandle,buf[0],iPerSize);
            if iSize<=0 then break;
            writeBuffer(buf[0],iSize);
            Inc(cnt,iSize);
            UptShow(cnt,iFileLen);
          end;
          result:=true;
        finally
          try FileClose(iFileHandle); except end;
          try SetLength(buf,0); except end;
        end;
  end;
end;

function TAMainFrm.Pro_RecvFile_CBDataFiles(sFileName:string;aConnect:TIdTCPConnection;aShow2Tw:boolean):Integer;
  procedure ShowProgress(aCur,aMax:integer);
  begin
    Application.ProcessMessages;
  end;
  procedure WriteLnEx(amsg:string);
  begin
    if aShow2Tw then ShowMsg2Tw(amsg)
    else ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
//const CBDataFilesPerSize = 4096;
var
  //rByte:array[0..CBDataFilesPerSize-1] of byte;
  rByte:array of byte;
  fs:TFileStream; ts:TStringList;
  cnt,iPos,iFileSize,iSize,iPerSize:integer; i,j:integer;
  sTemp,sSize:string;
begin
  with aConnect do
  begin
    sTemp:=ReadLn;
    if aShow2Tw then ShowMsg2Tw(sTemp)
    else ShowMsgTw(sTemp);
    sSize:=GetStrOnly2('<FileLen>','</FileLen>',sTemp,false);
    if not MayBeDigital(sSize) then
      exit;
    iFileSize:=strtoint(sSize);
    sSize:=GetStrOnly2('<PerSize>','</PerSize>',sTemp,false);
    if not MayBeDigital(sSize) then
      exit;
    iPerSize:=strtoint(sSize);

    WriteLnEx('HELLO');
    try
          setlength(rByte,iPerSize);
          fs:=TFileStream.create(sFileName,fmCreate);
          cnt:=0;
          ShowProgress(iFileSize,-1);
          while iFileSize>0 do
          begin
            if iFileSize>iPerSize then iSize:=iPerSize
            else iSize:=iFileSize;
            ReadBuffer(rByte[0],iSize);
            fs.Write(rByte[0],iSize);
            inc(cnt,iSize);
            ShowProgress(-1,cnt);
            iFileSize:=iFileSize-iSize;
          end;
    finally
      try setlength(rByte,0); except end;
      try if assigned(fs) then  freeAndNil(fs); except end;
      ShowProgress(-1,-1);
    end;
  end;
end;


function TAMainFrm.Pro_RequestSubmitShenBaoCase(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var sTemp,sLocker,sErr,sUplFile,sLogOpCur,sTimeKey,sLogOpLst,sPath,sPath2,sThisDir,aThisDatFile,aThisUrlList:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  function doccentertwTempPath():string;
  begin
    result:=GetWinTempPath+'doccentertw\shenbaocasetemp\';
  end;
begin
  with aConnect do
  begin
    try
      WriteLnEx('HELLO');
      sUplFile:=doccentertwTempPath+sCmd+'.upl';
      ShowMsgTw('∑«≥∆±µ¶¨∏ÍÆ∆');
      Pro_RecvFile_CBDataFiles(sUplFile,aConnect,false);
      ShowMsgTw('ßπ¶®±µ¶¨∏ÍÆ∆');

      sPath:=FAppParam.Tr1DBPath+'CBData\ShenBaoCase\';
      sThisDir:=GetIniFileByTiniFile('diff','thisdir','',sPath+_ShenBaoCaseLstF);
      if sThisDir='' then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~,•ºØ‡ß‰®Ïthisdir∞—º∆');
      end
      else begin
        sPath2:=sPath+sThisDir+'\';
        Mkdir_Directory(sTemp);
        if InputDatFileFmt2_ForSetCBData(sUplFile,sPath2,sErr) then
        begin
          if DirectoryExists(sPath2+'Bak\') then 
            TCommon.Deltree(sPath2+'Bak\',True,True);
          ShowMsgTw('∏ÍÆ∆∏—¿£¶®•\');
          aThisDatFile:=GetStrOnly2('<ThisDatFile>','</ThisDatFile>',SRequest,false);
          aThisUrlList:=GetStrOnly2('<ThisUrlList>','</ThisUrlList>',SRequest,false);
          sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,SRequest,false);
          sTemp:=sPath2+'shenbaocasetemp.dat';
          if SetDataOfShenBaoCase(FAppParam.Tr1DBPath,sTemp,aThisDatFile,aThisUrlList,FShenbaoCase_UptLogSaveDays,sErr) then
          begin
            WriteLnEx('HELLO');
            DelDatF(sPath2+'shenbaocasetemp.dat');  
          end
          else WriteLnErrEx(sErr);
        end else
          WriteLnErrEx('∏ÍÆ∆∏—¿£≥B≤z•¢±—.'+sErr);
      end;
      ShowMsgTw('ßπ¶®∏ÍÆ∆≥B≤z');
    finally
    end;
  end;
end;

function TAMainFrm.Pro_RequestDiffOfLastShenBaoCase(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var sTemp,sLocker,sErr,sUplFile,sLogOpCur,sGUID,sTimeKey,sLogOpLst:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  function doccentertwTempPath():string;
  begin
    result:=GetWinTempPath+'doccentertw\shenbaocasetemp\';
  end;
begin
  with aConnect do
  begin
    try
      WriteLnEx('HELLO');
      sUplFile:=doccentertwTempPath;
      DelAllFiles(sUplFile,false);
      if not DirectoryExists(sUplFile) then
        Mkdir_Directory(sUplFile);
      sUplFile:=sUplFile+sCmd+'.upl';
      ShowMsgTw('∑«≥∆±µ¶¨∏ÍÆ∆');
      Pro_RecvFile_CBDataFiles(sUplFile,aConnect,false);
      ShowMsgTw('ßπ¶®±µ¶¨∏ÍÆ∆');
      
      sLogOpLst:=doccentertwTempPath+'shenbaocasetemp.dat';
      DelDatF(sLogOpLst);
      sTemp:=doccentertwTempPath;
      if InputDatFileFmt2_ForSetCBData(sUplFile,sTemp,sErr) then
      begin
        ShowMsgTw('∏ÍÆ∆∏—¿£¶®•\');
        sGUID:=GetStrOnly2('<DiffGUID>','</DiffGUID>',SRequest,false);
        sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,SRequest,false);
        sTemp:=doccentertwTempPath+'shenbaocasetemp.dat';
        if MakeDiffOfShenBaoCase(FAppParam.Tr1DBPath,sTemp,sGUID,FShenbaoCase_UptLogSaveDays,sErr) then
        begin
          WriteLnEx('HELLO');
        end
        else WriteLnErrEx(sErr);
      end else
        WriteLnErrEx('∏ÍÆ∆∏—¿£≥B≤z•¢±—.'+sErr);
      ShowMsgTw('ßπ¶®∏ÍÆ∆≥B≤z');
    finally
    end;
  end;
end;


function TAMainFrm.Pro_RequestSetIRRateFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var sTemp,sLocker,sErr,sUplFile,sDate,sLogOpCur,sCurDataType,sTimeKey,sLogOpLst:string;
    i,j:integer; dtItem:TDate;  ts:TStringList;
    bPro:boolean;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  function ExcelDatPath():string;
  begin
    result:=ExtractFilePath(FBC14Path);
    if (Length(result)>0) and
       (result[Length(result)]='\') then
    begin
      result:=Copy(Result,1,Length(Result)-1);
      result:=ExtractFilePath(result);
    end;
  end;
  function doccentertwTempPath():string;
  begin
    result:=GetWinTempPath+'doccentertw\irratetemp\';
  end;
  function CreateUploadWork(aInputDate:TDate):Boolean;
  var xstr1:string;
  begin
    result:=false;
    if not DirectoryExists(FRateDatUploadWorkDir) then
    begin
      exit;
    end;
    xstr1:=FRateDatUploadWorkDir+FmtDt8(aInputDate)+'.upload';
    if SetTextByTs(xstr1,FmtDt8(aInputDate)) then 
      result:=true;
  end;
  function SwapOptionDateUploadFile(aInputDT8:string):string;
  begin
    Result:='';
    if FIRSavePathList.Count>0 then
    begin
      Result:=FIRSavePathList[0]+'SwapOption\Date\'+aInputDT8+'.dat';
    end;
  end;
  function SwapYieldDateUploadFile(aInputDT8:string):string;
  begin
    Result:='';
    if FIRSavePathList.Count>0 then
    begin
      Result:=FIRSavePathList[0]+'SwapYield\Date\'+aInputDT8+'.dat';
    end;
  end;
  function IRateDataDateUploadFile(aInputDT8:string):string;
  begin
    Result:=FRateDatUploadWorkDir+aInputDT8+'.upload';
  end;
begin
  with aConnect do
  begin
    try
      WriteLnEx('HELLO');
      sUplFile:=GetWinTempPath+'doccentertw\irratetemp\';
      DelAllFiles(sUplFile,false);
      if not DirectoryExists(sUplFile) then
        Mkdir_Directory(sUplFile);
      sUplFile:=sUplFile+sCmd+'.upl';
      ShowMsgTw('∑«≥∆±µ¶¨∏ÍÆ∆');
      Pro_RecvFile_CBDataFiles(sUplFile,aConnect,false);
      ShowMsgTw('ßπ¶®±µ¶¨∏ÍÆ∆');
      if SameText(sCmd,'IRRateDateDatWrite') then
      begin
        sTemp:=doccentertwTempPath;
        if InputDatFileFmt2_ForSetIRRateData2(sUplFile,sTemp,FBC14Path,FBC2Path,FBC3Path,FBC5Path,FBC6Path,FSwapOptionPath,FSwapYieldPath,sErr)
           and (sErr='') then
        begin
          ShowMsgTw('∏ÍÆ∆∏—¿£¶®•\');
          sDate:=GetStrOnly2('<Date>','</Date>',SRequest,false);
          sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,SRequest,false);
          sCurDataType:=GetStrOnly2('<CurData>','</CurData>',SRequest,false);
          
          dtItem:=DateStr8ToDate(sDate);
          sTemp:=doccentertwTempPath;
          ts:=TStringList.create;
          FolderAllFiles(sTemp,'.dat',ts,False);
          bPro:=true;
          for i:=0 to ts.count-1 do
          begin
            sErr:='';
            if SameText(ExtractFileName(ts[i]),'IR14.dat') then
            begin

              for j:=0 to FIRSavePathList.Count-1 do
              begin
                if not (SaveIR14Data(FIRSavePathList[j],ExtractFilePath(ts[i]),dtItem,sErr) and (sErr='')) then
                begin
                  bPro:=false;
                end
                else ShowMsgTw(_Manner14Caption+'¶®•\ßÛ∑s¶‹'+FIRSavePathList[j]);
                if not bPro then
                  break;
              end;
              //if bPro then SaveIRRateOpLog(FRateLogPath,datManner14,true,sDate);
            end
            else if SameText(ExtractFileName(ts[i]),'IR0Rate.dat') then
            begin
              for j:=0 to FIRSavePathList.Count-1 do
              begin
                if not (SaveIR0RateData(FIRSavePathList[j],ExtractFilePath(ts[i]),dtItem,sErr) and (sErr='')) then
                begin
                  bPro:=false;
                end
                else ShowMsgTw(_Maner0RateCaption+'¶®•\ßÛ∑s¶‹'+FIRSavePathList[j]);
                if not bPro then
                  break;
              end;
              //if bPro then SaveIRRateOpLog(FRateLogPath,datManer0Rate,true,sDate);
            end
            else if SameText(ExtractFileName(ts[i]),'IR2.dat') then
            begin
              for j:=0 to FIRSavePathList.Count-1 do
              begin
                if not (SaveIR2Data(FIRSavePathList[j],ExtractFilePath(ts[i]),dtItem,sErr,nil) and (sErr='')) then
                begin
                  bPro:=false;
                end
                else ShowMsgTw(_Manner2Caption+'¶®•\ßÛ∑s¶‹'+FIRSavePathList[j]);
                if not bPro then
                  break;
              end;
              //if bPro then SaveIRRateOpLog(FRateLogPath,datManner2,true,sDate);
            end
            else if SameText(ExtractFileName(ts[i]),'IR3.dat') then
            begin
              for j:=0 to FIRSavePathList.Count-1 do
              begin
                if not (SaveIR3Data(FIRSavePathList[j],ExtractFilePath(ts[i]),dtItem,sErr) and (sErr='')) then
                begin
                  bPro:=false;
                end
                else ShowMsgTw(_Manner3Caption+'¶®•\ßÛ∑s¶‹'+FIRSavePathList[j]);
                if not bPro then
                  break;
              end;
              //if bPro then SaveIRRateOpLog(FRateLogPath,datManner3,true,sDate);
            end
            else if SameText(ExtractFileName(ts[i]),'IR5.dat') then
            begin
              for j:=0 to FIRSavePathList.Count-1 do
              begin
                if not (SaveIR5Data(FIRSavePathList[j],ExtractFilePath(ts[i]),dtItem,sErr) and (sErr='')) then
                begin
                  bPro:=false;
                end
                else ShowMsgTw(_Manner5Caption+'¶®•\ßÛ∑s¶‹'+FIRSavePathList[j]);
                if not bPro then
                  break;
              end;
              //if bPro then SaveIRRateOpLog(FRateLogPath,datManner5,true,sDate);
            end
            else if SameText(ExtractFileName(ts[i]),'IR6.dat') then
            begin
              for j:=0 to FIRSavePathList.Count-1 do
              begin
                if not (SaveIR6Data(FIRSavePathList[j],ExtractFilePath(ts[i]),dtItem,sErr) and (sErr='')) then
                begin
                  bPro:=false;
                end
                else ShowMsgTw(_Manner6Caption+'¶®•\ßÛ∑s¶‹'+FIRSavePathList[j]);
                if not bPro then
                  break;
              end;
              //if bPro then SaveIRRateOpLog(FRateLogPath,datManner6,true,sDate);
            end
            else if SameText(ExtractFileName(ts[i]),'SwapOption.dat') then
            begin
              for j:=0 to FIRSavePathList.Count-1 do
              begin
                if not (SaveSwapOptionAFileData(FIRSavePathList[j],ExtractFilePath(ts[i]),dtItem,sErr,nil) and (sErr='')) then
                begin
                  bPro:=false;
                end
                else ShowMsgTw(_SwapOptionCaption+'¶®•\ßÛ∑s¶‹'+FIRSavePathList[j]);
                if not bPro then
                  break;
              end;
              //if bPro then SaveIRRateOpLog(FRateLogPath,datSwapOption,true,sDate);
            end
            else if SameText(ExtractFileName(ts[i]),'SwapYield.dat') then
            begin
              for j:=0 to FIRSavePathList.Count-1 do
              begin
                if not (SaveSwapYieldAFileData(FIRSavePathList[j],ExtractFilePath(ts[i]),dtItem,sErr,nil) and (sErr='')) then
                begin
                  bPro:=false;
                end
                else ShowMsgTw(_SwapYieldCaption+'¶®•\ßÛ∑s¶‹'+FIRSavePathList[j]);
                if not bPro then
                  break;
              end;
              //if bPro then SaveIRRateOpLog(FRateLogPath,datSwapYield,true,sDate);
            end;
            
            if not bPro then
              break;
          end;
          Freeandnil(ts);
          if not bPro then
            WriteLnErrEx('ßÛ∑s∏ÍÆ∆•¢±—.'+sErr)
          else begin
            sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);

            if SameText(sCurDataType,'irrate') then
            begin
              if CreateUploadWork(dtItem) then
              begin
                sLogOpLst:=sDate+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                  FAppParam.ConvertString(_IRRateMCaption)+_LogSep+_IRRateM+_LogSep+'0';
                Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
                CBDataMgr.SetCBDataLog('DocCenter','irrate'+sDate+'.upload',IRateDataDateUploadFile(sDate)
                  ,sLogOpCur,sTimeKey,1,'','irrate'+sDate);
                WriteLnEx('HELLO');
              end else
                WriteLnErrEx('≤£•Õ§W∂«•Ù∞»•¢±—.');
            end
            else begin
              if SameText(sCurDataType,'swap') then
              begin
                sLogOpLst:=sDate+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                  FAppParam.ConvertString(_CBSwapMCaption)+_LogSep+_CBSwapM+_LogSep+'0';
                Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
                CBDataMgr.SetCBDataLog('DocCenter','swapyield'+sDate+'.dat',SwapYieldDateUploadFile(sDate)
                  ,sLogOpCur,sTimeKey,1,'','swapyield'+sDate);
                CBDataMgr.SetCBDataLog('DocCenter','swapoption'+sDate+'.dat',SwapOptionDateUploadFile(sDate)
                  ,sLogOpCur,sTimeKey,1,'','swapoption'+sDate);
              end;
              WriteLnEx('HELLO');
            end;
          end;
        end else
          WriteLnErrEx('∏ÍÆ∆∏—¿£≥B≤z•¢±—.'+sErr);
      end;
      ShowMsgTw('ßπ¶®∏ÍÆ∆≥B≤z');
    finally
    end;
  end;
end;

function TAMainFrm.Pro_RequestSetTcriFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
const _tcridata='tcridata.dat';
      _tcripic='tcripic.dat';
      _tcrixls='tcrixls.dat';
var sTemp,sErr,sUplFile,sLogOpCur,sTimeKey,sLogOpLst,sDstPath,sTmpDstPath,sBakFile:string;
    i,j:integer;  ts:TStringList;
    bPro,b1:boolean;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  function doccentertwTempPath():string;
  begin
    result:=GetWinTempPath+'doccentertw\tcritemp\';
  end;
begin

  with aConnect do
  begin
    try
      ts:=TStringList.create;
      WriteLnEx('HELLO');
      sDstPath:=FAppParam.Tr1DBPath+'CBData\tcri\';
      if not DirectoryExists(sDstPath) then
        ForceDirectories(sDstPath);
      sTmpDstPath:=doccentertwTempPath;
      TCommon.Deltree(sTmpDstPath,false,false);
      if not DirectoryExists(sTmpDstPath) then
        ForceDirectories(sTmpDstPath);
      sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
      sUplFile:=sTmpDstPath+sTimeKey+'.upl';
      ShowMsgTw('∑«≥∆±µ¶¨∏ÍÆ∆');
      Pro_RecvFile_CBDataFiles(sUplFile,aConnect,false);
      ShowMsgTw('ßπ¶®±µ¶¨∏ÍÆ∆');
      if SameText(sCmd,'TcriDatWrite') then
      begin
        sTemp:=sTmpDstPath;
        b1:=InputDatFileFmt2_ForSetCBData(sUplFile,sTemp,sErr);
        if b1 and (sErr='') then
        begin
          DeleteFile(sUplFile);
          ShowMsgTw('∏ÍÆ∆∏—¿£¶®•\');
          sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,SRequest,true);
          SRequest:=StringReplace(SRequest,sLogOpCur,'',[rfReplaceAll]);
          sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
          sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);

          sLogOpLst:=GetStrOnly2(_LogSecBegin,_LogSecEnd,SRequest,false);
          if sLogOpLst='' then
          begin
            WriteLnErrEx('¥£•Ê∏ÍÆ∆•¢±—.®S¶≥logº∆æ⁄');
            exit;
          end;

          if not FileExists(sTmpDstPath+_tcridata) then
          begin
            WriteLnErrEx('¥£•Ê∏ÍÆ∆•¢±—.®S¶≥tcridata§Â¿…');
            exit;
          end;
          if not FileExists(sTmpDstPath+_tcripic) then
          begin
            WriteLnErrEx('¥£•Ê∏ÍÆ∆•¢±—.®S¶≥µe≠±§Â¿…');
            exit;
          end;
          if not DirectoryExists(sDstPath+'bak\') then
              Mkdir_Directory(sDstPath+'bak\');
          if FileExists(sDstPath+_tcridata) then
          begin
            sBakFile:=sDstPath+'bak\'+'Bak'+sTimeKey+'_'+_tcridata;
            if not CpyDatF(sDstPath+_tcridata,sBakFile) then
            begin
              WriteLnErrEx('¥£•Ê∏ÍÆ∆•¢±—.≥∆•˜tcridata§Â¿…•¢±—');
              exit;
            end;
          end;
          if not CpyDatF(sTmpDstPath+_tcridata,sDstPath+_tcridata) then
          begin
            WriteLnErrEx('¥£•Ê∏ÍÆ∆•¢±—.ßÛ∑stcridata§Â¿…•¢±—');
            exit;
          end;
          if not DirectoryExists(sDstPath+'pic\') then
            Mkdir_Directory(sDstPath+'pic\');
          if not CpyDatF(sTmpDstPath+_tcripic,sDstPath+'pic\'+sTimeKey+_tcripic) then
          begin
            WriteLnErrEx('¥£•Ê∏ÍÆ∆•¢±—.ºg§Jµe≠±§Â¿…•¢±—');
            exit;
          end;
          if FileExists(sTmpDstPath+_tcrixls) then
          begin
            if not CpyDatF(sTmpDstPath+_tcrixls,sDstPath+'bak\'+'Bak'+sTimeKey+'_tcridata'+sLogOpCur+'.xls') then
            begin
              WriteLnErrEx('¥£•Ê∏ÍÆ∆•¢±—.ºg§Jxls¿…Æ◊•¢±—');
              exit;
            end;
          end;

          if CBDataMgr.SetTCRIUploadWork(_tcridata,sTmpDstPath+_tcridata,sLogOpCur,sTimeKey) then
          begin
            Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
            WriteLnEx('HELLO');
          end else
            WriteLnErrEx('≤£•Õ§W∂«•Ù∞»•¢±—.');
        end else
          WriteLnErrEx('∏ÍÆ∆∏—¿£≥B≤z•¢±—.'+sErr);
      end;
      ShowMsgTw('ßπ¶®∏ÍÆ∆≥B≤z');
    finally
      FreeAndNil(ts);
    end;
  end;
end;


function TAMainFrm.Pro_RequestSetStockWeightFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var sTemp,sOutFile,sLocker,sErr,sLog,sUplFile,sDate,sLogOpCur,sCurDataType,sTimeKey,sLogOpLst,sDstPath:string;
    i,j:integer;  ts:TStringList;
    bPro,b1:boolean;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  function doccentertwTempPath():string;
  begin
    result:=GetWinTempPath+'doccentertw\ecbratetemp\';
  end;
begin

  with aConnect do
  begin
    try
      ts:=TStringList.create;
      WriteLnEx('HELLO');
      sDstPath:=FAppParam.Tr1DBPath+'CBData\stockweight\';
      if not DirectoryExists(sDstPath) then
        ForceDirectories(sDstPath);
        
       sUplFile:=ExtractFilePath(ParamStr(0))+'Data\Industry\Audit\stockweight\'+FmtDt8(date)+'\';
      if not DirectoryExists(sUplFile) then
        Mkdir_Directory(sUplFile);
      sUplFile:=sUplFile+FormatDateTime('yyyymmdd_hhmmss',now)+'.upl';
      ShowMsgTw('∑«≥∆±µ¶¨∏ÍÆ∆');
      Pro_RecvFile_CBDataFiles(sUplFile,aConnect,false);
      ShowMsgTw('ßπ¶®±µ¶¨∏ÍÆ∆');
      if SameText(sCmd,'StockWeightDateDatWrite') then
      begin
        sTemp:=ExtractFilePath(sUplFile);
        b1:=InputDatFileFmt3_ForSetCBData(sUplFile,sTemp,sOutFile,sErr);
        if b1
           and (sErr='') and (sOutFile<>'') then
        begin
          DeleteFile(sUplFile);
          ShowMsgTw('∏ÍÆ∆∏—¿£¶®•\');
          sDate:=GetStrOnly2('<Date>','</Date>',SRequest,false);
          sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,SRequest,false);
          sCurDataType:=GetStrOnly2('<CurData>','</CurData>',SRequest,false);

          bPro:=true;
          bPro:=SaveStockWeightData(sOutFile,sDstPath,sErr,sLog,ts);
          ShowMsgTw(sLog);
          if not (bPro and (sErr='')) then
          begin
            bPro:=false;
          end
          else ShowMsgTw('stockweight.dat'+'¶®•\ßÛ∑s');
          

          if not bPro then
            WriteLnErrEx('ßÛ∑s∏ÍÆ∆•¢±—.'+sErr)
          else begin
            sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
            if CBDataMgr.Setstockweight(ts,sDstPath,sLogOpCur,sTimeKey) then
            begin
              sLogOpLst:=sDate+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                FAppParam.ConvertString(_stockweightMCaption)+_LogSep+_stockweightM+_LogSep+'0';
              Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
              SetStatusOfTCRI('stockweight.dat','4');
              WriteLnEx('HELLO');
            end else
              WriteLnErrEx('≤£•Õ§W∂«•Ù∞»•¢±—.');
          end;
        end else
          WriteLnErrEx('∏ÍÆ∆∏—¿£≥B≤z•¢±—.'+sErr);
      end;
      ShowMsgTw('ßπ¶®∏ÍÆ∆≥B≤z');
    finally
      FreeAndNil(ts);
    end;
  end;
end;

function TAMainFrm.Pro_RequestSetEcbRateFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var sTemp,sLocker,sErr,sUplFile,sDate,sLogOpCur,sCurDataType,sTimeKey,sLogOpLst,sOneCmd:string;
    i,j:integer;  ts:TStringList;
    bPro:boolean;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsgTw(amsg);
    aConnect.WriteLn(amsg);
  end;
  function ExcelDatPath():string;
  begin
    result:=ExtractFilePath(FBC14Path);
    if (Length(result)>0) and
       (result[Length(result)]='\') then
    begin
      result:=Copy(Result,1,Length(Result)-1);
      result:=ExtractFilePath(result);
    end;
  end;
  function doccentertwTempPath():string;
  begin
    result:=GetWinTempPath+'doccentertw\ecbratetemp\';
  end;
begin

  with aConnect do
  begin
    try
      WriteLnEx('HELLO');
      sUplFile:=GetWinTempPath+'doccentertw\ecbratetemp\';
      DelAllFiles(sUplFile,false);
      if not DirectoryExists(sUplFile) then
        Mkdir_Directory(sUplFile);
      sUplFile:=sUplFile+sCmd+'.upl';
      ShowMsgTw('∑«≥∆±µ¶¨∏ÍÆ∆');
      Pro_RecvFile_CBDataFiles(sUplFile,aConnect,false);
      ShowMsgTw('ßπ¶®±µ¶¨∏ÍÆ∆');
      if SameText(sCmd,'EcbRateDateDatWrite') then
      begin
        sOneCmd:='00';
        sTemp:=doccentertwTempPath;
        //sTemp:=FIRSavePathListEcb[0];
        if InputDatFileFmt2_ForSetCBData(sUplFile,sTemp,sErr)
           and (sErr='') then
        begin
          ShowMsgTw('∏ÍÆ∆∏—¿£¶®•\');
          sDate:=GetStrOnly2('<Date>','</Date>',SRequest,false);
          sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,SRequest,false);
          sCurDataType:=GetStrOnly2('<CurData>','</CurData>',SRequest,false);

          bPro:=true;
          if FileExists(sTemp+'ntd2usd.dat') then 
          if bPro then 
          for j:=0 to FIRSavePathListEcb.Count-1 do
          begin
            if not (Saventd2usdData(sTemp,FIRSavePathListEcb[j],sErr) and (sErr='')) then
            begin
              bPro:=false;
            end
            else ShowMsgTw('ntd2us.dat'+'¶®•\ßÛ∑s¶‹'+FIRSavePathListEcb[j]);
            if not bPro then
              break;
            sOneCmd[1]:='1';
          end;

          if FileExists(sTemp+'fed.dat') then 
          if bPro then 
          for j:=0 to FIRSavePathListEcb.Count-1 do
          begin
            if not (SavfedData(sTemp,FIRSavePathListEcb[j],sErr) and (sErr='')) then
            begin
              bPro:=false;
            end
            else ShowMsgTw('fed.dat'+'¶®•\ßÛ∑s¶‹'+FIRSavePathListEcb[j]);
            if not bPro then
              break;
            sOneCmd[2]:='1';
          end;
          
          if not bPro then
            WriteLnErrEx('ßÛ∑s∏ÍÆ∆•¢±—.'+sErr)
          else begin
            sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
            if CBDataMgrEcb.SetECBRate(FIRSavePathListEcb[0],sLogOpCur,sTimeKey,sOneCmd) then
            begin
              sLogOpLst:=sDate+_LogSep+''+_LogSep+_OpDataOp+_LogSep+''+_LogSep+sLogOpCur+_LogSep+
                FAppParam.ConvertString(_EcbRateMCaption)+_LogSep+_EcbRateM+_LogSep+'0';
              Pro_RequestUPTLOGRECSFILEEcb(sLogOpLst,sTimeKey);
              WriteLnEx('HELLO');
            end else
              WriteLnErrEx('≤£•Õ§W∂«•Ù∞»•¢±—.');
          end;
        end else
          WriteLnErrEx('∏ÍÆ∆∏—¿£≥B≤z•¢±—.'+sErr);
      end;
      ShowMsgTw('ßπ¶®∏ÍÆ∆≥B≤z');
    finally
    end;
  end;
end;


function TAMainFrm.Pro_RequestSetCBDataFilesEcb(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var sTemp,sLocker,sErr,sDatFileLst,sLogOpLst,sLogOpCur,sTimeKey:string; DatFileList,GuidList:_cStrLst2;
    i,j:integer;
    sUplFile,sOneFile,sTempLock,sTempGuid,sTempFile:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsg2TwEcb(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsg2TwEcb(amsg);
    aConnect.WriteLn(amsg);
  end;
begin
  with aConnect do
  begin
    try
      sLogOpLst:=GetStrOnly2(_LogSecBegin,_LogSecEnd,SRequest,false);
      sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,sLogOpLst,true);
      sLogOpLst:=StringReplace(sLogOpLst,sLogOpCur,'',[rfReplaceAll]);
      sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
      sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);
      sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
      
      sLocker:=GetStrOnly2('<Locker>','</Locker>',SRequest,false);
      sTemp:=GetStrOnly2('<DatFileList>','</DatFileList>',SRequest,false);
      sDatFileLst:=sTemp;
      DatFileList:=DoStrArray2(sTemp,',');
      sTemp:=GetStrOnly2('<GuidList>','</GuidList>',SRequest,false);
      GuidList:=DoStrArray2(sTemp,',');
      if sLocker='' then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Locker=null');
        exit;
      end;
      if Length(GuidList)=0 then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Length(GuidList)=0');
        exit;
      end;
      if Length(GuidList)<>Length(DatFileList) then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Length(GuidList)<>Length(DatFileList)');
        exit;
      end;

      for i:=0 to High(DatFileList) do
      begin
        sOneFile:=DatFileList[i];
        sTempLock:=FCBDataTokenMngEcb.CheckDatLock(sOneFile);
        if (not SameText(sTempLock,sLocker)) then
        begin
          WriteLnErrEx(sOneFile+'§Â¿…¬Í©w•¢Æƒ.'+sTempLock);
          exit;
        end;
        sTempGuid:=FCBDataTokenMngEcb.GetDatGuid(sOneFile);
        if (not SameText(sTempGuid,GuidList[i])) then
        begin
          WriteLnErrEx(sOneFile+' guid§w∏gßÔ≈‹.'+sTempGuid+';'+GuidList[i]);
          exit;
        end;
      end; 

      WriteLnEx('HELLO');
      sUplFile:=CBDataMgrEcb.GetCBData_FullPath+Get_GUID8+'.upl';
      ShowMsg2TwEcb('∑«≥∆±µ¶¨∏ÍÆ∆');
      Pro_RecvFile_CBDataFiles(sUplFile,aConnect);
      ShowMsg2TwEcb('ßπ¶®±µ¶¨∏ÍÆ∆');
      sTemp:=CBDataMgrEcb.GetCBData_FullPath; sErr:='';
      if InputDatFileFmt2_ForSetCBData(sUplFile,sTemp,sErr) and (sErr='') then
      begin
        WriteLnEx('HELLO')
      end else
        WriteLnErrEx('∏ÍÆ∆≥B≤z•¢±—.'+sErr);

      for i:=0 to High(DatFileList) do
      begin
        sOneFile:=DatFileList[i];
        FCBDataTokenMngEcb.SetDatGuid(sOneFile,Get_GUID8,sLocker);
        if not UpdateGuidOfWorkList_CBDataEcb(True,sOneFile,True,sLogOpCur,sTimeKey) then
        begin
          ShowMsg2TwEcb('≤£•Õ§W∂«•Õ•Ù∞»≤M≥Ê•¢±—.'+sOneFile);
        end;
      end;
      FCBDataWorkHandleEcb.PackCBDataFile(sDatFileLst);

      if FCBDataTokenMngEcb.UnLockDatFileList(DatFileList,sLocker) then
        ShowMsg2TwEcb('∏—¬Í¶®•\.'+sLocker)
      else
        ShowMsg2TwEcb('∏—¬Í•¢±—.'+sLocker);

      Pro_RequestUPTLOGRECSFILEEcb(sLogOpLst,sTimeKey);
      ShowMsg2TwEcb('ßπ¶®∏ÍÆ∆≥B≤z');
    finally
      try SetLength(DatFileList,0); except end;
      try SetLength(GuidList,0); except end;
    end;
  end;
end;

function TAMainFrm.Pro_RequestSetCBDataFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var sTemp,sLocker,sErr,sDatFileLst,sLogOpLst,sLogOpCur,sTimeKey:string; DatFileList,GuidList:_cStrLst2;
    i,j:integer;
    sUplFile,sOneFile,sTempLock,sTempGuid,sTempFile:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;
begin
  with aConnect do
  begin
    try
      sLogOpLst:=GetStrOnly2(_LogSecBegin,_LogSecEnd,SRequest,false);
      sLogOpCur:=GetStrOnly2(_OpCurBegin,_OpCurEnd,sLogOpLst,true);
      sLogOpLst:=StringReplace(sLogOpLst,sLogOpCur,'',[rfReplaceAll]);
      sLogOpCur:=StringReplace(sLogOpCur,_OpCurBegin,'',[rfReplaceAll]);
      sLogOpCur:=StringReplace(sLogOpCur,_OpCurEnd,'',[rfReplaceAll]);
      sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
      
      sLocker:=GetStrOnly2('<Locker>','</Locker>',SRequest,false);
      sTemp:=GetStrOnly2('<DatFileList>','</DatFileList>',SRequest,false);
      sDatFileLst:=sTemp;
      DatFileList:=DoStrArray2(sTemp,',');
      sTemp:=GetStrOnly2('<GuidList>','</GuidList>',SRequest,false);
      GuidList:=DoStrArray2(sTemp,',');
      if sLocker='' then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Locker=null');
        exit;
      end;
      if Length(GuidList)=0 then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Length(GuidList)=0');
        exit;
      end;
      if Length(GuidList)<>Length(DatFileList) then
      begin
        WriteLnErrEx('∞—º∆ø˘ª~.Length(GuidList)<>Length(DatFileList)');
        exit;
      end;

      for i:=0 to High(DatFileList) do
      begin
        sOneFile:=DatFileList[i];
        sTempLock:=FCBDataTokenMng.CheckDatLock(sOneFile);
        if (not SameText(sTempLock,sLocker)) then
        begin
          WriteLnErrEx(sOneFile+'§Â¿…¬Í©w•¢Æƒ.'+sTempLock);
          exit;
        end;
        sTempGuid:=FCBDataTokenMng.GetDatGuid(sOneFile);
        if (not SameText(sTempGuid,GuidList[i])) then
        begin
          WriteLnErrEx(sOneFile+' guid§w∏gßÔ≈‹.'+sTempGuid+';'+GuidList[i]);
          exit;
        end;
      end; 

      WriteLnEx('HELLO');
      sUplFile:=CBDataMgr.GetCBData_FullPath+Get_GUID8+'.upl';
      ShowMsg2Tw('∑«≥∆±µ¶¨∏ÍÆ∆');
      Pro_RecvFile_CBDataFiles(sUplFile,aConnect);
      ShowMsg2Tw('ßπ¶®±µ¶¨∏ÍÆ∆');
      sTemp:=CBDataMgr.GetCBData_FullPath; sErr:='';
      if InputDatFileFmt2_ForSetCBData(sUplFile,sTemp,sErr) and (sErr='') then
      begin
        WriteLnEx('HELLO')
      end else
        WriteLnErrEx('∏ÍÆ∆≥B≤z•¢±—.'+sErr);

      for i:=0 to High(DatFileList) do
      begin
        sOneFile:=DatFileList[i];
        FCBDataTokenMng.SetDatGuid(sOneFile,Get_GUID8,sLocker);
        if not UpdateGuidOfWorkList_CBData(True,sOneFile,True,sLogOpCur,sTimeKey) then
        begin
          ShowMsg2Tw('≤£•Õ§W∂«•Õ•Ù∞»≤M≥Ê•¢±—.'+sOneFile);
        end;
      end;
      FCBDataWorkHandle.PackCBDataFile(sDatFileLst);

      if FCBDataTokenMng.UnLockDatFileList(DatFileList,sLocker) then
        ShowMsg2Tw('∏—¬Í¶®•\.'+sLocker)
      else
        ShowMsg2Tw('∏—¬Í•¢±—.'+sLocker);

      Pro_RequestUPTLOGRECSFILE(sLogOpLst,sTimeKey);
      ShowMsg2Tw('ßπ¶®∏ÍÆ∆≥B≤z');
    finally
      try SetLength(DatFileList,0); except end;
      try SetLength(GuidList,0); except end;
    end;
  end;
end;
{
function TAMainFrm.Pro_RequestSetCBDBFiles(aConnect:TIdTCPConnection;sCmd,SRequest:string):Integer;
var sTemp,sErr:string; 
    i,j:integer;
    sUplFile,sTempFile:string;
  procedure WriteLnEx(amsg:string);
  begin
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;
  procedure WriteLnErrEx(amsg:string);
  begin
    amsg:='<ErrMsg>'+amsg+'</ErrMsg>' ;
    ShowMsg2Tw(amsg);
    aConnect.WriteLn(amsg);
  end;
begin
  with aConnect do
  begin
    try
      WriteLnEx('HELLO');
      sTemp:=CBDataMgr.GetCBDB_FullPath;
      if not DirectoryExists(sTemp) then
        Mkdir_Directory(sTemp);
      sUplFile:=sTemp+_CBDBUplFile;
      ShowMsg2Tw('∑«≥∆±µ¶¨∏ÍÆ∆');
      Pro_RecvFile_CBDataFiles(sUplFile,aConnect);
      ShowMsg2Tw('ßπ¶®±µ¶¨∏ÍÆ∆');
      sErr:='';
      if InputDatFileFmt2(sUplFile,sTemp,sErr) and (sErr='') then
      begin
        WriteLnEx('HELLO')
      end else
        WriteLnErrEx('∏ÍÆ∆≥B≤z•¢±—.'+sErr);

      ShowMsg2Tw('ßπ¶®∏ÍÆ∆≥B≤z');
    finally
    end;
  end;
end; }

procedure TAMainFrm.TCPServer2EcbExecute(AThread: TIdPeerThread);
var ReadStr,ErrMsg,sIp,sCmd: string;
begin
  EnterCriticalSection(CriticalSection2);
  NowIsRunning := True;
Try
try
  with AThread.Connection do
  begin
    //AThread.Connection.MaxLineLength:=FIndyMaxLineLength;
    sIp:=Socket.Binding.PeerIP;
    ShowMsg2TwEcb('¶≥§H≠n®D¡pæ˜.'+sIp);
    WriteLn('ConnectOk');
    ReadStr := ReadLn;
    ShowMsg2TwEcb('≠n∞µ™∫∞ ß@¨O ' + ReadStr);
    sCmd:=GetStrOnly2('<Cmd>','</Cmd>',ReadStr,false);

    if SameText(sCmd,'ReadCBDataFiles') Then
      Pro_RequestReadCBDataFilesEcb(AThread.Connection,sCmd,ReadStr)
    else if SameText(sCmd,'SetCBDataFiles') Then
      Pro_RequestSetCBDataFilesEcb(AThread.Connection,sCmd,ReadStr)
    else if SameText(sCmd,'ReadNodeFiles') or SameText(sCmd,'ReadEcbNodeFiles') Then
      Pro_RequestReadNodeFilesEcb(AThread.Connection,sCmd,ReadStr);
  end;
Except
   On E : Exception do
   Begin
      ErrMsg := E.Message;
      ShowMsg2TwEcb('µo•Õø˘ª~ '+ ErrMsg);
   End;
End;
Finally
   Try
      AThread.Connection.Disconnect;
   Except
   end;
   ShowMsg2TwEcb('§¡¬_¡pæ˜.'+sIp);
   LeaveCriticalSection(CriticalSection2);
   NowIsRunning := false;
End;
end;

procedure TAMainFrm.TCPServer2Execute(AThread: TIdPeerThread);
var ReadStr,ErrMsg,sIp,sCmd: string;
begin
  EnterCriticalSection(CriticalSection2);
  NowIsRunning := True;
Try
try
  with AThread.Connection do
  begin
    //AThread.Connection.MaxLineLength:=FIndyMaxLineLength;
    sIp:=Socket.Binding.PeerIP;
    ShowMsg2Tw('¶≥§H≠n®D¡pæ˜.'+sIp);
    WriteLn('ConnectOk');
    ReadStr := ReadLn;
    ShowMsg2Tw('≠n∞µ™∫∞ ß@¨O ' + ReadStr);
    sCmd:=GetStrOnly2('<Cmd>','</Cmd>',ReadStr,false);

    if SameText(sCmd,'ReadCBDataFiles') Then
      Pro_RequestReadCBDataFiles(AThread.Connection,sCmd,ReadStr)
    else if SameText(sCmd,'SetCBDataFiles') Then
      Pro_RequestSetCBDataFiles(AThread.Connection,sCmd,ReadStr)
    else if SameText(sCmd,'ReadNodeFiles') or SameText(sCmd,'ReadEcbNodeFiles') Then
      Pro_RequestReadNodeFiles(AThread.Connection,sCmd,ReadStr)
    else if SameText(sCmd,Cmd_RcvFile) Then
      Pro_Request_RecvFile(AThread.Connection,sCmd);
    {else if SameText(sCmd,'SetCBDBFiles') Then
      Pro_RequestSetCBDBFiles(AThread.Connection,sCmd,ReadStr);}
  end;
Except
   On E : Exception do
   Begin
      ErrMsg := E.Message;
      ShowMsg2Tw('µo•Õø˘ª~ '+ ErrMsg);
   End;
End;
Finally
   Try
      AThread.Connection.Disconnect;
   Except
   end;
   ShowMsg2Tw('§¡¬_¡pæ˜.'+sIp);
   LeaveCriticalSection(CriticalSection2);
   NowIsRunning := false;
End;
end;

function TimeMsg():string;
begin
  result:='['+FormatDateTime('MMDD-hh:nn:ss',Now)+']';
end;

procedure TAMainFrm.ShowMsg(const Msg: String;AutoConvert:Boolean=true);
begin
   if not Assigned(FLog1) then
     exit;
   if AutoConvert Then
     FLog1.AddLog(TimeMsg+FAppParam.ConvertString(Msg))
   Else
     FLog1.AddLog(Msg);
end;

procedure TAMainFrm.ShowMsgTw(const Msg: String;AutoConvert:Boolean=true);
begin
   if not Assigned(FLog1) then
     exit;
   if AutoConvert Then
     FLog1.AddLog(TimeMsg+FAppParam.TwConvertStr(Msg))
   Else
     FLog1.AddLog(Msg);
end;

procedure TAMainFrm.ShowMsgTwEcb(const Msg: String;AutoConvert:Boolean=true);
begin
   if not Assigned(FLog1) then
     exit;
   if AutoConvert Then
     FLog1.AddLog(TimeMsg+FAppParam.TwConvertStr('(ecb)'+Msg))
   Else
     FLog1.AddLog('(ecb)'+Msg);
end;

procedure TAMainFrm.ShowMsg2(const Msg: String;AutoConvert:Boolean=true);
begin
  if not Assigned(FLog2) then
     exit;
   if AutoConvert Then
     FLog2.AddLog(TimeMsg+FAppParam.ConvertString(Msg))
   Else
     FLog2.AddLog(Msg);
end;

procedure TAMainFrm.ShowMsg2Tw(const Msg: String;AutoConvert:Boolean=true);
begin
  if not Assigned(FLog2) then
     exit;
   if AutoConvert Then
     FLog2.AddLog(TimeMsg+FAppParam.TwConvertStr(Msg))
   Else
     FLog2.AddLog(Msg);
end;

procedure TAMainFrm.ShowMsg2TwEcb(const Msg: String;AutoConvert:Boolean=true);
begin
  if not Assigned(FLog2) then
     exit;
   if AutoConvert Then
     FLog2.AddLog(TimeMsg+FAppParam.TwConvertStr('(ecb)'+Msg))
   Else
     FLog2.AddLog('(ecb)'+Msg);
end;

procedure TAMainFrm.Timer1Timer(Sender: TObject);
var sFileOutList:string; ADoc2:TDocData; i:integer;
begin
  if NowIsRunning Then //•ø¶b∞ı¶ÊºfÆ÷©Œ®‰•L∞ ß@
    Exit;
  Timer1.Enabled := False;
  NowIsLoading := True;
try
try
  if DocDataMgr_3.DocList.Count=0 Then
  Begin
    if DocDataMgr_3.TempDocFileNameExists Then
    Begin
      ShowMsg('º”‘ÿπ˝ª·–≈œ¢µµ∞∏ '+ ExtractFileName(DocDataMgr_3.NowTempDocFileName));
      DocDataMgr_3.LoadFromTempDocFile;
      ShowMsg('º”‘ÿÕÍ≥…,π≤”–π´∏Ê' + IntToStr(DocDataMgr_3.DocList.Count) + ' ¥˝…Û∫À');
    End;
  End;

  if chkAutoAuditDoc.Checked then
  begin
    if DocDataMgr_2.DocList.Count=0 Then
      LoadOfDocDataMgr_2DocList(true,false);
    if DocDataMgr_2.DocList.Count>0 Then
    begin
      ShowMsgTw('∞ı¶ÊßÂ∂q§Ωßi¶€∞ ºfÆ÷,º∆∂q:'+IntToStr(DocDataMgr_2.DocList.Count));
      for i:=DocDataMgr_2.DocList.Count-1 downto 0 do
      begin
        ADoc2:=DocDataMgr_2.DocList.Items[i];
        AutoDOCOK02(true,ADoc2);
      end;
    end;
  end;
Except
   ON E: Exception do
     ShowMsg(E.Message);
end;
Finally
  Timer1.Enabled := True;
  NowIsLoading   := false;
End;
end;

function TAMainFrm.CompressOutPutFile(SourceFile: String): String;
Var
  DstFile : String;
  AStream : TMemoryStream;
begin
  Result := '';
Try
Try
  if FileExists(SourceFile) Then
  Begin
    DstFile := GetWinTempPath+Get_GUID8+'.dat';
    CopyFile(PChar(SourceFile),PChar(DstFile),False);
    AStream := TMemoryStream.Create;
    AStream.LoadFromFile(DstFile);
    CompressStream(AStream);
    //ShowMessage(DeCompressStream(AStream));
    AStream.SaveToFile(DstFile); 
    Result := DstFile;
  End;
Except
  On E:Exception Do
    ShowMsg(E.Message+'(CompressFile)');
End;
Finally
  if Assigned(AStream) then
    FreeAndNil(AStream);
End;
end;

//--DOC4.0.0°™N002 huangcq090407 add--------->
procedure TAMainFrm.RefreshAppStatus(Const AppDNS,AppID:String; Const AppStatus:TAppStatus);
Var
  aItem : TdxTreeListNode;
  i,j : integer;
  Str : String;
  aAppIDExists: Boolean;
begin
  try
    if (UpperCase(AppID)='DOCCENTER') then exit; //◊‘…Ì≤ª”√º”»ÎµΩ¡–±Ì
    aAppIDExists := False;
    For i:=0 to dxTreeListAppStatus.Count-1 do
    Begin
        aItem := dxTreeListAppStatus.Items[i];
        if (aItem.Strings[dxTreeListAppStatus.ColumnByName('APPID').Index]=AppID) and
           (aItem.Strings[dxTreeListAppStatus.ColumnByName('APPDNS').Index]=AppDNS) Then
        Begin
           aAppIDExists := True;
           Case AppStatus of
             appConnect: begin
                aItem.StateIndex := 0;
                j := StrToInt(aItem.Strings[dxTreeListAppStatus.ColumnByName('BarCount').Index]);
                if j>2 then j := 0;
                Case j of
                 0: Str:='---';
                 1: Str:='|';
                 2: Str:='---';
                End;
                aItem.Strings[dxTreeListAppStatus.ColumnByName('MsgTime').Index]:= FormatDateTime('hh:mm:ss',Now);
                aItem.Strings[dxTreeListAppStatus.ColumnByName('ConnectTime').Index]:= Str;
                j := j+1;
                aItem.Strings[dxTreeListAppStatus.ColumnByName('BarCount').Index] := IntToStr(j);
             end; //end appConnect
             appDisConnect: begin
                //aItem.StateIndex := 1;
                //j := 0;
                aItem.Destroy;
                RefreshActiveClients(appDisConnect);
             end; //end appDisConnect
           End;//end case
           dxTreeListAppStatus.Repaint;
           Break;
        End;
    End; //end for
    if not aAppIDExists then
    begin
      aItem := dxTreeListAppStatus.Add;
      aItem.StateIndex := 1;
      aItem.Strings[dxTreeListAppStatus.ColumnByName('AppDNS').Index] := AppDNS;
      aItem.Strings[dxTreeListAppStatus.ColumnByName('AppCaption').Index] := AppID;
      aItem.Strings[dxTreeListAppStatus.ColumnByName('AppID').Index] := AppID;
      aItem.Strings[dxTreeListAppStatus.ColumnByName('BarCount').Index] := '0';
      aItem.Strings[dxTreeListAppStatus.ColumnByName('ConnectTime').Index] := '---';
      aItem.Strings[dxTreeListAppStatus.ColumnByName('MsgTime').Index]:= FormatDateTime('hh:mm:ss',Now);
      RefreshActiveClients(appConnect);
    end;
  except
  end; 
end;

procedure TAMainFrm.RefreshActiveClients(Const AppStatus:TAppStatus);
var
  CurCount: Integer;
  ACurStr: String;
begin
  ACurStr := Trim(StatusBar1.Panels.Items[2].Text);
  if (Length(ACurStr)<=0) then
    CurCount := 0
  else
    CurCount := StrToInt(Copy(ACurStr,Pos(':',ACurStr) + 1,Length(ACurStr) - Pos(':',ACurStr)));
  if (AppStatus = appConnect) then
    Inc(CurCount)
  else
    if (CurCount >0) then  Dec(CurCount);
  ACurStr := 'Connecting Users:'+IntToStr(CurCount);
  Statusbar1.Panels.Items[2].Text := ACurStr;
end;

procedure TAMainFrm.Msg_AppStatusInfo(var Message: TMessage);
Var
  WMString: PWMAppStatusString;
begin
  if FStopRunning Then Exit;
  Try
     WMString :=  PWMAppStatusString(Message.LParam);

     if WMString.WMType='AppStatus' Then
     Begin
       RefreshAppStatus(WMString.WMDNS,WMString.WMAppID,WMString.WMAppStatus);
     End;
  Except
  End;
end;

{ReceiveData From SocketServer--DocCenter}
procedure TAMainFrm.Msg_ReceiveDataInfo(ObjWM : PWMReceiveString);
Var
  WMString: PWMReceiveString;
  Value,Value2 : String;
begin
  if FStopRunning Then Exit;
  Try
     WMString := ObjWM;
     if WMString.WMType='DOCPACKAGE' Then //RCCPACKAGE
     Begin

        Value := GetReceiveStrColumnValue('Message',WMString.WMReceiveString);
        if Length(Value)>0 Then
        Begin
           if Value='CBDatEdit' then
           Begin
              //Value2:=GetReceiveStrColumnValue('DownLoadSZHintData',WMString.WMReceiveString);
           End;
        End;

        Value2 := GetReceiveStrColumnValue('Broadcast',WMString.WMReceiveString);
        if Length(Value2)>0 Then
        Begin
            if Value2='ReStartMarket' Then
            Begin
            End;
        End;
     End;
  Except
  end;
end;

{ReceiveData From SocketServer--DocMonitor}
Procedure TAMainFrm.Msg_ReceiveDataInfo_Monitor(ObjWM : PWMReceiveString);
Var
  WMString: PWMReceiveString;
  Value,Value2 : String;
begin
  if FStopRunning Then Exit;
  Try
     WMString := ObjWM;

     if WMString.WMType='DOCPACKAGE' Then //RCCPACKAGE
     Begin

        Value := GetReceiveStrColumnValue('Message',WMString.WMReceiveString);
        if Length(Value)>0 Then
        Begin
           if Value='Doc_ChinaTodayHint_SZ' then
           Begin
              Value2:=GetReceiveStrColumnValue('DownLoadSZHintData',WMString.WMReceiveString);
              if (FSocketClientFrm <> nil) then
                 FSocketClientFrm.SendText('SendTo=CBDatEdit;'+
                                           'Message=Doc_ChinaTodayHint_SZ;'+
                                           'DownLoadSZHintData='+Value2+';');
           End;
           if Value='Doc_ChinaTodayHint_ZZ' then
           Begin
              Value2:=GetReceiveStrColumnValue('DownLoadZZHintData',WMString.WMReceiveString);
              if (FSocketClientFrm <> nil) then
                 FSocketClientFrm.SendText('SendTo=CBDatEdit;'+
                                           'Message=Doc_ChinaTodayHint_ZZ;'+
                                           'DownLoadZZHintData='+Value2+';');
           End;
           if Value='Doc_Dealer_TW' then
           Begin
              Value2:=GetReceiveStrColumnValue('DownLoadTWDealerData',WMString.WMReceiveString);
              if (FSocketClientFrm <> nil) then
                 FSocketClientFrm.SendText('SendTo=CBDatEdit;'+
                                           'Message=Doc_Dealer_TW;'+
                                           'DownLoadTWDealerData='+Value2+';');
           End;
           //add by wangjinhua ThreeTrader 091015
           if Value='Doc_ThreeTrader_TW' then
           Begin
              Value2:=GetReceiveStrColumnValue('DownLoadTWThreeTraderData',WMString.WMReceiveString);
              if (FSocketClientFrm <> nil) then
                 FSocketClientFrm.SendText('SendTo=CBDatEdit;'+
                                           'Message=Doc_ThreeTrader_TW;'+
                                           'DownLoadTWThreeTraderData='+Value2+';');
           End;
           //--
        End;

        Value2 := GetReceiveStrColumnValue('Broadcast',WMString.WMReceiveString);
        if Length(Value2)>0 Then
        Begin
            if Value2='CloseSystem' Then
            Begin
              FStopRunning := True;
              application.Terminate;
            End;
        End;
     End;

  Except
  end;
end;

procedure TAMainFrm.SendDocMonitorStatusMsg;
var AIsEndDownLoad:Boolean;
begin
  if FSocketClient_MonitorFrm<>nil Then  //
  Begin
     FSocketClient_MonitorFrm.SendText('SendTo=DocMonitor;'+
                                'Message=DocCenter;');

  End;
end;

function TAMainFrm.SendDocMonitorWarningMsg(const Str: String): boolean;
var AStrAllowed:String;
begin
  if FSocketClient_MonitorFrm<>nil Then
    Begin
      //SocketClient sendtext format is '#%B%SocketName='+sendvalue+';%E%#' ,thus,must
      //replace the substring of '#' in the sendvalue
      AStrAllowed:=FAppParam.ConvertString(Str);
      ReplaceSubString('#','',AStrAllowed);
      Result := FSocketClient_MonitorFrm.SendText('SendTo=DocMonitor;'+
                                        'MsgWarning='+AStrAllowed);
    End;
end;

procedure TAMainFrm.TimerSendLiveToDocMonitorTimer(Sender: TObject);
begin
  if TimerSendLiveToDocMonitor.Tag=1 Then
     exit;
  TimerSendLiveToDocMonitor.Tag :=1;
  Try
    if FStopRunning then exit;
    if FSocketClient_MonitorFrm<>nil Then
       SendDocMonitorStatusMsg(); //¶VDocMonitorµo∞e•]¨A¨Oß_ßπ¶®§U∏¸µ•
  Finally
    if FStopRunning then
      TimerSendLiveToDocMonitor.Enabled := False;
    TimerSendLiveToDocMonitor.Tag :=0;
  end;
end;

procedure TAMainFrm.dxTreeListAppStatusCustomDraw(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; const AText: String; AFont: TFont;
  var AColor: TColor; ASelected, AFocused: Boolean; var ADone: Boolean);
begin
    if ANode.StateIndex=0 Then
       AFont.Color := clLime;

    if ANode.StateIndex=1 Then
       AFont.Color := clRed;
end;

//<--DOC4.0.0°™N002 huangcq090407 add

procedure TAMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);//<--DOC4.0.0°™N002 huangcq081223 add
begin
  FStopRunning := True;

  TimerSendLiveToDocMonitor.Interval := 1;
  While TimerSendLiveToDocMonitor.Enabled  and
      (TimerSendLiveToDocMonitor.Tag=1) Do
  Application.ProcessMessages;

  if FSocketSvrFrm<>nil Then
  Begin
     FSocketSvrFrm.ClearObj;
     FSocketSvrFrm.Destroy;
     FSocketSvrFrm := nil;
  End;

  if FSocketClientFrm<>nil Then
  Begin
     FSocketClientFrm.ClearObj;
     FSocketClientFrm.Destroy;
     FSocketClientFrm := nil;
  End;

  if FSocketClient_MonitorFrm<>nil Then
  Begin
     FSocketClient_MonitorFrm.ClearObj;
     FSocketClient_MonitorFrm.Destroy;
     FSocketClient_MonitorFrm := nil;
  End;

  if (FAppParam <>nil) then
  begin
    FAppParam.Free;
    FAppParam :=nil;
  end;
  if (FAppParamEcb <>nil) then
  begin
    FAppParamEcb.Free;
    FAppParamEcb :=nil;
  end;
  
  FCBDataWorkHandle.Terminate;
  FCBDataWorkHandleEcb.Terminate;

  FLog1.Terminate;
  FLog2.Terminate;
  FCBDataTokenMng.Destroy;
  FCBDataTokenMngEcb.Destroy;
end;


Function  StrToDate2(StrDate:ShortString):TDate;
Var
  Sep : Char;
Begin

   Sep := DateSeparator;
   result := 0;
Try
Try
    if Pos('-',StrDate)>0 Then
    Begin
       DateSeparator:='-';
       Result := StrToDate(StrDate);
       Exit;
    End;
    if Pos('/',StrDate)>0 Then
    Begin
       DateSeparator:='/';
       Result := StrToDate(StrDate);
       Exit;
    End;
Except
End;    
Finally
   DateSeparator:=Sep;
End;
End;

Function  StrToDate3(StrDate:ShortString):TDate;
begin
  if (Length(StrDate)=8) and
     (Pos('-',StrDate)<=0) and
     (Pos('/',StrDate)<=0) and
     (Pos('\',StrDate)<=0)   then
  begin
    StrDate:=Copy(StrDate,1,4)+DateSeparator+Copy(StrDate,5,2)+DateSeparator+Copy(StrDate,7,2);
  end;
  result:=StrToDate2(StrDate);
end;

Procedure SortTRCIRecList(BufferGrid:TList);
var
  //±∆ß«•Œ
  lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2 : PTCRIRec; 
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
            while (lTemp2.Code > lTemp.Code) or
                  (  (lTemp2.Code = lTemp.Code) and
                     (StrToDate3(lTemp2.PDate) <  StrToDate3(lTemp.PDate))
                  ) do
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

procedure AssignTCRIRec(aSrcRec:PTCRIRec;var aDstRec:TTCRIRec);
var Temp:string;
begin
  aDstRec.Code:=aSrcRec.Code;
  aDstRec.NowLevel:=aSrcRec.NowLevel;
  //aDstRec.PreLeve:=aSrcRec.PreLeve;
  aDstRec.BaseReportDate:=aSrcRec.BaseReportDate;
  aDstRec.PDate:=aSrcRec.PDate;
  Temp := aSrcRec.Des;
  StrPCopy(aDstRec.Des,Temp);
  aDstRec.MktC:=aSrcRec.MktC;
  //aDstRec.CYB:=aSrcRec.CYB;
  //aDstRec.TEJ:=aSrcRec.TEJ;
end;

function CvtStr(str:string;const AutoConvString: Boolean=True):string;
begin
  result := str;
  if AutoConvString then
  begin
    if Assigned(FAppParam) then
    begin
      Result := FAppParam.ConvertString(str);
    end;
  end;

end;

function MsgQuery(const msg:String;const AutoConvString: Boolean=True):Boolean;
var
  vMsg,vTitle:String;
begin
  vTitle := '—ØŒ ';
  vMsg := msg;
  vTitle := CvtStr(vTitle);
  vMsg := CvtStr(vMsg,AutoConvString);
  Result := true;
  if MessageBox(0,Pchar(vMsg),PChar(vTitle),MB_YESNO) = 7     then
    Result := false;
end;

procedure AssignTCRIRec2(aSrcRec:TTCRIRec;var aDstRec:PTCRIRec);
var Temp:string;
begin
  aDstRec.Code:=aSrcRec.Code;
  aDstRec.NowLevel:=aSrcRec.NowLevel;
  //aDstRec.PreLeve:=aSrcRec.PreLeve;
  aDstRec.BaseReportDate:=aSrcRec.BaseReportDate;
  aDstRec.PDate:=aSrcRec.PDate;
  Temp := aSrcRec.Des;
  StrPCopy(aDstRec.Des,Temp);
  aDstRec.MktC:=aSrcRec.MktC;
end;

function TAMainFrm.InitTCRIData: boolean;
  procedure ShowPer(aMsg,aMsg2:string;aNow,aMax:Integer);
  begin
    if aMsg='Null' then
    begin
       StatusBar1.Panels[0].text := '';
       StatusBar1.Panels[1].text := '';
    end
    else begin
       StatusBar1.Panels[0].text := aMsg2;
       StatusBar1.Panels[1].text := Format('==%s==  %d/%d  [%s] ',[aMsg2,aNow,aMax,aMsg]);
    end;
    Application.ProcessMessages;
  end;
const Ctcridata='tcridata.dat';
      BlockSize=100;
var aFile,aTCRIFile:string;
    v,Sheet:Variant;
    i,j,k:integer;
    f: File  of TTCRIRec;
    aDatList:TList; aTCRIRecP:PTCRIRec;
    rone:TTCRIRec;
    //r: array[0..BlockSize-1] of TTCRIRec;
    aTemp,aTempName:string;
    aDbl:Double; b:boolean;

    r: array[0..BlockSize-1] of TTCRIRec;
    aFileSize,Remain,ReadCount,GotCount : Cardinal;

    function ExistsTrciRec(aCode,aTcri,aPDate:string):boolean;
    var x1:Integer;
    begin
      result:=false;
      for x1:=0 to aDatList.count-1 do
      begin
         aTCRIRecP:=aDatList.Items[x1];
         if SameText(Trim(aTCRIRecP.Code),Trim(aCode)) and
            (StrToDate3(aTCRIRecP.PDate)=StrToDate3(aPDate)) and
            SameText(Trim(aTCRIRecP.NowLevel),Trim(aTcri)) then
         begin
           Result:=True;
           exit;
         end;
      end;
    end;
begin
  try
  try
    Result := false;
    aDatList:=TList.Create;
    v := Unassigned; b:=false;
    aTCRIFile := FAppParam.Tr1DBPath+'cbdata\tcri\'+Ctcridata;

    if FileExists(aTCRIFile) then
    begin
      try
        AssignFile(f,aTCRIFile);
        FileMode := 0;
        ReSet(f);
        ReMain := FileSize(f);
        while ReMain>0 do
        Begin
          if Remain<BlockSize then ReadCount := ReMain
          Else ReadCount := BlockSize;
          BlockRead(f,r,ReadCount,GotCount);
          For k:=0 to GotCount-1 do
          Begin
            New(aTCRIRecP);
            AssignTCRIRec2(r[k],aTCRIRecP);
            aDatList.Add(aTCRIRecP);
          End;
          Remain:=Remain-GotCount;
        End;
      finally
        try CloseFile(f); except end;
      end;
    end;


    if OpenDialog1.Execute then
    begin
      aFile := OpenDialog1.FileName;
      v:= CreateOleObject('Excel.Application');
      v.Visible := false;
      v.WorkBooks.Open(aFile);

      Sheet:= v.Workbooks[1].WorkSheets[1];
      Try

          aTempName := aTCRIFile;
          AssignFile(f,aTempName);
          FileMode := 1;


          k := 0;
          j := Sheet.UsedRange.Rows.Count;
          For i:=3 to j do
          Begin
            ShowPer(Sheet.cells.item[i,1].Text,Sheet.Name,i,j);
            if FStopRunning then break;
            if (Sheet.cells.item[i,1].Text='') and
               (Sheet.cells.item[i,2].Text='') then Break;
            if (Sheet.cells.item[i,1].Text='') or
               (Sheet.cells.item[i,2].Text='') then
            begin
              Continue;
            end;
            if ExistsTrciRec( Trim(Sheet.cells.item[i,2].Text),
                             Trim(Sheet.cells.item[i,6].Text),
                             Trim(Sheet.cells.item[i,8].Text) ) then

              Continue;
            New(aTCRIRecP);
            aTCRIRecP.Code := Trim(Sheet.cells.item[i,2].Text);
            aTCRIRecP.NowLevel := Trim(Sheet.cells.item[i,6].Text);
            aTCRIRecP.BaseReportDate := Trim(Sheet.cells.item[i,7].Text);
            aTCRIRecP.PDate := Trim(Sheet.cells.item[i,8].Text);
            if aTCRIRecP.PDate='' then
            begin
              aTCRIRecP.PDate:='na';
            end;

            aTemp := Trim(Sheet.cells.item[i,14].Text);
            StrPCopy(aTCRIRecP.Des,aTemp);
            aTCRIRecP.MktC := Trim(Sheet.cells.item[i,5].Text);
            aDatList.Add(aTCRIRecP);
          End;

          if aDatList.count>0 then
          begin
            SortTRCIRecList(aDatList);
            ReWrite(f);
            for i:=0 to aDatList.count-1 do
            begin
               aTCRIRecP:=aDatList.Items[i];
               AssignTCRIRec(aTCRIRecP,rone);
               Write(f,rone);
            end;
          end;
      Finally
         try CloseFile(f); except end;

      End;

      Result := true;
      v.DisplayAlerts := false;//åÎ¥·ñêå¥‰’æ
      v.Quit;//?èïµÃ‘¸åuÿXµÃ
      v:=Unassigned;
    end;
  except
    on e:Exception do
    begin
      Showmessage(CvtStr('Ω{?ñf¿ﬁáÍ‡¢:')+e.message);
    end;
  end;
  finally
    for i:=0 to aDatList.count-1 do
         begin
           aTCRIRecP:=aDatList.Items[i];
           Dispose(aTCRIRecP);
           aTCRIRecP:=nil;
         end;
         aDatList.Clear;
         FreeAndNil(aDatList);

      ShowPer('Null','',0,0);
  end;
  //Application.Restore;
  //Application.BringToFront;
end;

procedure TAMainFrm.miInitData1Click(Sender: TObject);
var aSY,aSQ,aEY,aEQ:integer;
begin
try
  TMenuItem(Sender).Enabled := false;
  //InitTCRIData;
  if FuncSetWorkForIFRS(aSY,aSQ,aEY,aEQ) then
    Pro_RequestSetIFRSWorkHis(aSY,aSQ,aEY,aEQ);
finally
  TMenuItem(Sender).Enabled := true;
end;
end;

function FStr2Dt(ainput:string):TDateTime;
begin
  result:=0;
  try
    if ainput<>'0' then
      result:=StrToFloat(ainput);
  except
  end;
end;

var iCountForIndustry:integer=0;
procedure TAMainFrm.Timer2Timer(Sender: TObject);
var sFile,sFile2,sFile2OfWeek,sStatus,sStatusOfWeek,sTemp:string; dtNow:TDateTime;
begin
  Timer2.Enabled := False;
try
try
  if CheckTask('DownIFRS.exe') then
  begin
    if GetTickCount-FIFRSWorkLstTick>10*1000 then
    begin
      FIFRSWorkLstTick:=GetTickCount;
      if Assigned(FCBDataWorkHandle) then
        FCBDataWorkHandle.UptGUIDOfIFRSData; 
    end;

    sFile:=IFRSWorkLstFile;
    sStatus:=GetIniFileEx('work','status',_CDaiXia,sFile);
    if sStatus=_CXiaing then
    begin
      sTemp:=GetIniFileEx('work','lasttime','0',sFile);
      FIFRSWorkLstTime:=StrToFloat(sTemp);
      if FIFRSWorkLstTime>0 then
      begin
        //FIFRSWorkLstTime:=GetFileTimeEx(sFile);
        dtNow:=now;
        if SecondsBetween(dtNow,FIFRSWorkLstTime)>=120 then
        begin
          KillTask('DownIFRS.exe');
          StartIFRSDownExe2();
        end;
      end;
    end
    else begin
      FIFRSWorkLstTime:=0;
    end;
  end
  else begin
    FIFRSWorkLstTime:=0;
  end;

  Inc(iCountForIndustry);
  if iCountForIndustry>=4 then
  begin
    iCountForIndustry:=0;
    if CheckTask('DownIndustry.exe') then
    begin
      sFile2:=FAppParam.Tr1DBPath+'CBData\TCRI\CloseIdList\'+FmtDt8(Date)+'.lst';
      sFile2OfWeek:=FAppParam.Tr1DBPath+'CBData\TCRI\CloseIdList\ForWeekDay\'+FmtDt8(Date)+'.lst';
      if FileExists(sFile2) or FileExists(sFile2OfWeek)  then
      begin
          sFile:=ExtractFilePath(ParamStr(0))+'setup.ini';
          sStatus:='';
          if FileExists(sFile2) then 
          sStatus:=GetIniFileEx('DownIndustry','Status2',_CDaiXia,sFile);
          sStatusOfWeek:='';
          if FileExists(sFile2OfWeek) then 
          sStatusOfWeek:=GetIniFileEx('DownIndustry','Status2OfWeek',_CDaiXia,sFile);
          if (sStatus=_CXiaing) or (sStatusOfWeek=_CXiaing) then
          begin
            if (sStatus=_CXiaing) then
            begin
              sFile:=FAppParam.Tr1DBPath+'CBData\TCRI\CloseIdList\'+FmtDt8(Date)+'.lst';
              sTemp:=GetIniFileEx('work','lasttime','0',sFile);
              FIndustryWorkLstTime:=StrToFloat(sTemp);
              if FIndustryWorkLstTime>0 then
              begin
                dtNow:=now;
                if SecondsBetween(dtNow,FIndustryWorkLstTime)>=120 then
                begin
                  KillTask('DownIndustry.exe');
                  StartIndustryDownExe2();
                end;
              end;
            end
            else if (sStatusOfWeek=_CXiaing) then
            begin
              sFile:=FAppParam.Tr1DBPath+'CBData\TCRI\CloseIdList\ForWeekDay\'+FmtDt8(Date)+'.lst';
              sTemp:=GetIniFileEx('work','lasttime','0',sFile);
              FIndustryWorkLstTime:=StrToFloat(sTemp);
              if FIndustryWorkLstTime>0 then
              begin
                dtNow:=now;
                if SecondsBetween(dtNow,FIndustryWorkLstTime)>=120 then
                begin
                  KillTask('DownIndustry.exe');
                  StartIndustryDownExe2();
                end;
              end;
            end;

          end else FIndustryWorkLstTime:=0;
      end else FIndustryWorkLstTime:=0;
    end else FIndustryWorkLstTime:=0;
  end;
Except
  ON E: Exception do
  begin
    ShowMsg(E.Message);
  end;
end;
Finally
  Timer2.Enabled := True;
End;
end;

procedure TAMainFrm.ClearSysLog(aSaveDay:integer);
var
  LogFileLst : _CStrLst;
  i:integer;
begin
  if aSaveDay<=0 then
    exit;
try
  SetLength(LogFileLst,0);
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\doccenter\','.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if (DaySpan(now,GetFileDateTimeC(LogFileLst[i]))>aSaveDay) then
      DeleteFile(LogFileLst[i]);
  End;

  SetLength(LogFileLst,0);
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\Doc_CBDataEdit\','.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if (DaySpan(now,GetFileDateTimeC(LogFileLst[i]))>aSaveDay) then
      DeleteFile(LogFileLst[i]);
  End;

  SetLength(LogFileLst,0);
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\uploadCBData\','.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if (DaySpan(now,GetFileDateTimeC(LogFileLst[i]))>aSaveDay) then
      DeleteFile(LogFileLst[i]);
  End;

  ///---------
  SetLength(LogFileLst,0);
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'DataEcb\DwnDocLog\doccenter\','.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if (DaySpan(now,GetFileDateTimeC(LogFileLst[i]))>aSaveDay) then
      DeleteFile(LogFileLst[i]);
  End;

  SetLength(LogFileLst,0);
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'DataEcb\DwnDocLog\Doc_CBDataEdit\','.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if (DaySpan(now,GetFileDateTimeC(LogFileLst[i]))>aSaveDay) then
      DeleteFile(LogFileLst[i]);
  End;

  SetLength(LogFileLst,0);
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'DataEcb\DwnDocLog\uploadCBData\','.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if (DaySpan(now,GetFileDateTimeC(LogFileLst[i]))>aSaveDay) then
      DeleteFile(LogFileLst[i]);
  End;
except
end;
end;


procedure TAMainFrm.AppExcept(Sender: TObject; E: Exception);
var sFile,sPath : string;
    CLogPath:string;
begin
    CLogPath  := ExtractFilePath(ParamStr(0))+'data\DwnDocLog\doccenter\';
    if not DirectoryExists(CLogPath) then Exit;
    sPath:=CLogPath;
    sFile := sPath+Format('%s_%s.log',[FormatDateTime('yyyymmdd',now),'warn']);
    WriteFileLine(sFile,E.Message);
end;

function TimeKey2TimeStr(aTimeKey:string):string;
var xstr1,xstr2:string;
begin
  //xstr1:=Copy(aTimeKey,Length(aTimeKey)-9,Length(aTimeKey));
  //result:=Copy(xstr1,1,2)+':'+Copy(xstr1,3,2)+':'+Copy(xstr1,5,2);
  xstr2:=DateSeparator;
  xstr1:=aTimeKey;
  result:=Copy(xstr1,1,4)+xstr2+Copy(xstr1,5,2)+xstr2+Copy(xstr1,7,2)+' '+
    Copy(xstr1,10,2)+':'+Copy(xstr1,12,2)+':'+Copy(xstr1,14,2)+':'+Copy(xstr1,16,3);
end;

function TAMainFrm.CreateAMail(AWarn: Boolean; AEvent,
  ABody: String): Boolean;
var sFile,sDir:string;  ts:TStringList;
begin
  Result:=False;
  sDir:=ExtractFilePath(ParamStr(0))+'data\MailSchedule\';
  if not DirectoryExists(sDir) then
    Mkdir_Directory(sDir);
  sFile:=sDir+Get_GUID8+'.dat';
  try
    ts:=TStringlist.create;
    ts.Add('<warn>');
    if AWarn then ts.Add('1')
    else ts.Add('0');
    ts.Add('</warn>');
    ts.Add('<time>');
    ts.Add(FormatDateTime('yyyymmdd hh:mm:ss:zzz',now));
    ts.Add('</time>');
    ts.Add('<owner>');
    ts.Add('(doccenter.exe)');
    ts.Add('</owner>');
    ts.Add('<event>');
    ts.Add(AEvent);
    ts.Add('</event>');
    ts.Add('<body>');
    ts.Add(ABody);
    ts.Add('</body>');
    ts.SaveToFile(sFile);
    Result:=true;
  finally
    try FreeAndNil(ts); except end;
  end;
end;

function TAMainFrm.ColloectUploadLog:boolean;
  function Op2OpStr(aInput:string):string;
  begin
    if SameText(aInput,_OpSave) then
      result := FAppParam.TwConvertStr(_OpSaveStr)
    else if SameText(aInput,_OpUptAndSave) then
      result := FAppParam.TwConvertStr(_OpUptAndSaveStr)
    else if SameText(aInput,_OpImportExcel) then
      result := FAppParam.TwConvertStr(_OpImportExcelStr)
    else if SameText(aInput,_OpUptReason) then
      result := FAppParam.TwConvertStr(_OpUptReasonStr)
    else if SameText(aInput,_OpAddSub) then
    result := FAppParam.TwConvertStr(_OpAddSubStr)
  else if SameText(aInput,_OpUptSub) then
    result := FAppParam.TwConvertStr(_OpUptSubStr)
  else if SameText(aInput,_OpDelSub) then
    result := FAppParam.TwConvertStr(_OpDelSubStr)
  else if SameText(aInput,_OpReBack) then
      result := FAppParam.TwConvertStr(_OpReBackStr)
    
    else if SameText(aInput,_OpAdd) then
      result := FAppParam.TwConvertStr(_OpAddStr)
    else if SameText(aInput,_OpUpt) then
      result := FAppParam.TwConvertStr(_OpUptStr)
    else if SameText(aInput,_OpDel) then
      result := FAppParam.TwConvertStr(_OpDelStr)
    else if SameText(aInput,_OpDelCB) then
      result := FAppParam.TwConvertStr(_OpDelCBStr)
    else if SameText(aInput,_OpMove) then
      result := FAppParam.TwConvertStr(_OpMoveStr)
    else if SameText(aInput,_OpCBAdd) then
      result := FAppParam.TwConvertStr(_OpCBAddStr)
    else if SameText(aInput,_OpMdfStk) then
      result := FAppParam.TwConvertStr(_OpMdfStkStr)
    else if SameText(aInput,_OpMdfCB) then
      result := FAppParam.TwConvertStr(_OpMdfCBStr)
    else if SameText(aInput,_OpDataOp) then
      result := FAppParam.TwConvertStr(_OpDataOpStr)
    else if SameText(aInput,_OpNodeUpload) then
      result := FAppParam.TwConvertStr(_OpNodeUploadStr)
    else if SameText(aInput,_OpMdfCBIssue1) then
      result := FAppParam.TwConvertStr(_OpMdfCBIssue1Str)
    else if SameText(aInput,_OpMdfCBIssue2) then
      result := FAppParam.TwConvertStr(_OpMdfCBIssue2Str)
    else if SameText(aInput,_OpMdfCBIssue3) then
      result := FAppParam.TwConvertStr(_OpMdfCBIssue3Str)
    else if SameText(aInput,_OpMdfCBIssue4) then
      result := FAppParam.TwConvertStr(_OpMdfCBIssue4Str)
    else if SameText(aInput,_OpMdfCBIssue5) then
      result := FAppParam.TwConvertStr(_OpMdfCBIssue5Str)
    else if SameText(aInput,_OpMdfCBIssue6) then
      result := FAppParam.TwConvertStr(_OpMdfCBIssue6Str)
    else if SameText(aInput,_OpMdfCBIssue7) then
      result := FAppParam.TwConvertStr(_OpMdfCBIssue7Str)
    else
      result := 'None';
  end;

  function FtpStatus2Str(aInput:string):string;
  begin
    if SameText(aInput,'False') then
      result := FAppParam.TwConvertStr(_UploadUnDoneStr)
    else if SameText(aInput,'True') then
      result := FAppParam.TwConvertStr(_UploadDoneStr)
    else
      result := 'None';
  end;

  function FtpStatusBool2Str(aInput:Boolean):string;
  begin
    if aInput then
      result := FAppParam.TwConvertStr(_UploadDoneStr)
    else
      result := FAppParam.TwConvertStr(_UploadUnDoneStr);
  end;


const BlockSize=20;
var sOpLogFile,sLogFile,sOpLogFileEcb,sLogFileEcb,sLine,sLine2,sLine3,sLine4,sDt8S,sDt8E,sDtTimeS,sDtTimeE,sSameList,sLogForCbpa,sLogForCbpaEcb:String;
    Remain,ReadCount,GotCount,k,i,j : Integer;
    bUpload:boolean;
    f:file of TTrancsationRec; r: array[0..BlockSize-1] of TTrancsationRec;
    ts,ts2,ts3:TStringList; StrLst2,StrLst3:_cStrLst2; FRecLogs:TTrancLogRecs;
    ANode:TdxTreeListNode;

    function ZuoFang():string;
    begin
      result:=FAppParam.TwConvertStr2('°i');
    end;
    function YouFang():string;
    begin
      result:=FAppParam.TwConvertStr2('°j');
    end;
    function SepItemStr():string;
    begin
      result:=FAppParam.TwConvertStr2(_SepItem);
    end;
    function SepItem2Str():string;
    begin
      result:=FAppParam.TwConvertStr2(_SepItem2);
    end;
    function ListItemStr():string;
    begin
      result:=FAppParam.TwConvertStr2(_ListItem);
    end;
    
    function FillUploadRelative(aTimeKey:string;var sOutLogList:string):boolean;
    var x1,x2,x3:integer; xstr:string;
    begin
      result:=false; sOutLogList:='';
      x2:=0;x3:=0;
      for x1:=0 to High(FRecLogs) do
      begin
        Application.ProcessMessages;
        if FRecLogs[x1].Dats[0]='' then
          continue;
        if SameText(aTimeKey,'null') or SameText(aTimeKey,FRecLogs[x1].Dats[0]) then
        begin
          if SameText(FRecLogs[x1].Dats[4],'False') then
            Inc(x2)
          else if SameText(FRecLogs[x1].Dats[4],'True') then
            Inc(x3);
          xstr:=ListItemStr+FRecLogs[x1].Dats[2]+FRecLogs[x1].Dats[5]+_SepItem+FtpStatus2Str(FRecLogs[x1].Dats[4]);
          if sOutLogList='' then sOutLogList:=xstr
          else sOutLogList:=sOutLogList+#13#10+xstr;

          FRecLogs[x1].Dats[0]:='';
        end;
      end;
      result:=(x2=0) and (x3>=0);
    end;

begin
  result:=false;
  sLogForCbpa:='';
  sLogForCbpaEcb:='';
  ShowMsg2Tw('∂}©l∞ı¶Ê ≤£•Õæﬁß@∞Oø˝¶}∂l±H.');
  sLine:='_'+FormatDateTime('hhmmss',FSendMailOfOpLogTime)+'000';
  sDt8S:=FmtDt8(date-1);
  //sDt8S:='20160203';
  sDt8E:=FmtDt8(date);
  sDtTimeS:=FormatDateTime('yyyymmdd',date-1)+sLine;
  //sDtTimeS:='20160203'+sLine;
  sDtTimeE:=FormatDateTime('yyyymmdd',date)+sLine;
  sOpLogFile:=GetWinTempPath+'TempCBDataOpLog.log';
  if FileExists(sOpLogFile) then
    DeleteFile(sOpLogFile);
  sLogFile:=GetWinTempPath+'TempCBDataLog.log';
  if FileExists(sLogFile) then
    DeleteFile(sLogFile);

  sOpLogFileEcb:=GetWinTempPath+'TempCBDataOpLogEcb.log';
  if FileExists(sOpLogFileEcb) then
    DeleteFile(sOpLogFileEcb);
  sLogFileEcb:=GetWinTempPath+'TempCBDataLogEcb.log';
  if FileExists(sLogFileEcb) then
    DeleteFile(sLogFileEcb);


  ts:=nil; ts2:=nil; ts3:=nil;
    try
    try
      ts:=TStringList.create;
      ts2:=TStringList.create;
      ts3:=TStringList.create;

      //----------- •x∆Wor§j≥∞∏ÍÆ∆Æw™∫æﬁß@∞Oø˝¬k¡`
      ts.clear; ts2.clear; ts3.clear;
      CBDataMgr.GetCBDataOpLog(sDt8S,sDt8E,sOpLogFile);
      CBDataMgr.GetCBDataLog(sDt8S,sDt8E,sLogFile);
      setlength(FRecLogs,0);
      
      if FileExists(sLogFile) then
        ts.LoadFromFile(sLogFile);
      SetLength(FRecLogs,ts.count);
      ReMain:=0;
      for i:=0 to ts.count-1 do
      begin
        sLine:=Trim(ts[i]);
        if sLine='' then
          continue;
        StrLst2:=DoStrArray2(sLine,#9);
        if Length(StrLst2)=6 then
        begin
          for j:=Low(StrLst2) to High(StrLst2) do
            FRecLogs[ReMain].Dats[j]:=StrLst2[j];
          Inc(ReMain);
        end;
      end;
      SetLength(FRecLogs,ReMain);

       ts2.clear;
       ts3.clear;
       ts.clear;
       if FileExists(sOpLogFile) then
       try
         AssignFile(f,sOpLogFile);
         FileMode:=0;
         Reset(f);
         ReMain := FileSize(f);
         while ReMain>0 do
         Begin
             if Remain<BlockSize then  ReadCount := ReMain
             else ReadCount := BlockSize;
             BlockRead(f,r[0],ReadCount,GotCount);
             For k:=0 to GotCount-1 do
             Begin
                Application.ProcessMessages;
                if (r[k].OpTime>sDtTimeS) and (r[k].OpTime<sDtTimeE) then
                begin
                  sLine:=r[k].Operator+#9+r[k].ID+r[k].IDName+#9+
                    r[k].OpTime+#9+
                    Op2OpStr(r[k].Op)+#9+r[k].ModouleName+#9+r[k].OpTime;
                  //TimeKey2TimeStr(r[k].OpTime)
                  ts.Add(sLine);
                end;
             End;
             Remain:=Remain-GotCount;
         End;
       finally
         try
           CloseFile(f);
         except
           on e:Exception do
             e := nil;
         end;
       end;

       if ts.Count>0 then
       begin
         ts.Sort;
         for i:=0 to ts.count-1 do
         begin
            sLine:=(ts[i]);
            if sLine='' then
              continue;
            StrLst2:=DoStrArray2(sLine,#9);
            if Length(StrLst2)>=6 then
            begin
              sSameList:='';
              for j:=i+1 to ts.count-1 do
              begin
                sLine2:=(ts[j]);
                if sLine2='' then
                  continue;
                StrLst3:=DoStrArray2(sLine2,#9);
                if Length(StrLst3)>=5 then
                begin
                  if (StrLst2[5]=StrLst3[4]) then //≥o¨qßP¬_≈ﬁøË¿≥∏”¨Oø˘ª~µL•Œ™∫°Aº»Æ…•˝Ødµ€ßa
                  begin
                    sLine3:=ZuoFang+StrLst3[0]+SepItem2Str+StrLst3[1]+YouFang+SepItemStr+StrLst3[2]+SepItemStr+StrLst3[3]+SepItemStr+TimeKey2TimeStr(StrLst3[4])+SepItemStr+FAppParam.TwConvertStr('¶P§W');
                    if sSameList='' then sSameList:=sLine3
                    else sSameList:=sSameList+#13#10+sLine3;
                    ts[j]:='';
                  end
                  else if ( (Length(StrLst3)>=6) and
                       (StrLst2[5]=StrLst3[5])
                     ) then
                  begin
                    sLine3:=ZuoFang+StrLst3[0]+SepItem2Str+StrLst3[1]+YouFang+SepItemStr+StrLst3[3]+SepItemStr+StrLst3[4]+SepItemStr+TimeKey2TimeStr(StrLst3[5])+SepItemStr+FAppParam.TwConvertStr('¶P§W');
                    if sSameList='' then sSameList:=sLine3
                    else sSameList:=sSameList+#13#10+sLine3;
                    ts[j]:='';
                  end;
                end;
              end;

              bUpload:=FillUploadRelative(StrLst2[5],sLine2);
              sLine3:=ZuoFang+StrLst2[0]+SepItem2Str+StrLst2[1]+YouFang+SepItemStr+StrLst2[3]+SepItemStr+StrLst2[4]+SepItemStr+TimeKey2TimeStr(StrLst2[5])+SepItemStr+FtpStatusBool2Str(bUpload);
              if sSameList<>'' then
                sLine3:=sLine3+#13#10+sSameList;
              if bUpload then
              begin
                ts2.Add(sLine3);
                //ts2.Add('');
              end
              else begin
                ts3.Add(sLine3);
                //ts3.Add('');
              end;
            end;
         end;
       end;
       if (ts2.Count>0) or (ts3.Count>0) then
       begin
         sLine3:='°iæﬁß@§H,•NΩX°j'+_SepItem+'°iæﬁß@√˛´¨°j'+_SepItem+'°iæﬁß@≠∂≠±°j'+_SepItem+'°iÆ…∂°°j'+_SepItem+'°i§W∂«™¨∫A°j';
         sLine:=sLine3;
         if (ts3.Count>0) then
         begin
           sLine:=sLine+#13#10+#13#10+'<h2 color="red">========§W∂«•ºßπ¶®========</h2>'+#13#10+#13#10+FAppParam.ToTwIfCnSys(ts3.text);
         end;
         if (ts2.Count>0) then
         begin
           sLine:=sLine+#13#10+#13#10+'<h2>========§W∂«§wßπ¶®========</h2>'+#13#10+#13#10+FAppParam.ToTwIfCnSys(ts2.text);
         end;
         sLogForCbpa:=sLine;
       end
       else begin
         //sLine:='µL∏ÍÆ∆∫˚≈@∞Oø˝';
       end;


        //----------- ecb∏ÍÆ∆Æw™∫æﬁß@∞Oø˝¬k¡`
      if FAppParam.IsTwSys then
      begin
          ts.clear; ts2.clear; ts3.clear;
          CBDataMgrEcb.GetCBDataOpLog(sDt8S,sDt8E,sOpLogFileEcb);
          CBDataMgrEcb.GetCBDataLog(sDt8S,sDt8E,sLogFileEcb);
          setlength(FRecLogs,0);
      
          if FileExists(sLogFileEcb) then
            ts.LoadFromFile(sLogFileEcb);
          SetLength(FRecLogs,ts.count);
          ReMain:=0;
          for i:=0 to ts.count-1 do
          begin
            sLine:=Trim(ts[i]);
            if sLine='' then
              continue;
            StrLst2:=DoStrArray2(sLine,#9);
            if Length(StrLst2)=6 then
            begin
              for j:=Low(StrLst2) to High(StrLst2) do
                FRecLogs[ReMain].Dats[j]:=StrLst2[j];
              Inc(ReMain);
            end;
          end;
          SetLength(FRecLogs,ReMain);

           ts2.clear;ts3.clear;ts.clear;
           if FileExists(sOpLogFileEcb) then
           try
             AssignFile(f,sOpLogFileEcb);
             FileMode:=0;
             Reset(f);
             ReMain := FileSize(f);
             while ReMain>0 do
             Begin
                 if Remain<BlockSize then  ReadCount := ReMain
                 else ReadCount := BlockSize;
                 BlockRead(f,r[0],ReadCount,GotCount);
                 For k:=0 to GotCount-1 do
                 Begin
                    Application.ProcessMessages;
                    if (r[k].OpTime>sDtTimeS) and (r[k].OpTime<sDtTimeE) then
                    begin
                      sLine:=r[k].Operator+#9+r[k].ID+r[k].IDName+#9+
                        r[k].OpTime+#9+
                        Op2OpStr(r[k].Op)+#9+r[k].ModouleName+#9+r[k].OpTime;
                      //TimeKey2TimeStr(r[k].OpTime)
                      ts.Add(sLine);
                    end;
                 End;
                 Remain:=Remain-GotCount;
             End;
           finally
             try
               CloseFile(f);
             except
               on e:Exception do
                 e := nil;
             end;
           end;

           if ts.Count>0 then
           begin
             ts.Sort;
             for i:=0 to ts.count-1 do
             begin
                sLine:=(ts[i]);
                if sLine='' then
                  continue;
                StrLst2:=DoStrArray2(sLine,#9);
                if Length(StrLst2)>=6 then
                begin
                  sSameList:='';
                  for j:=i+1 to ts.count-1 do
                  begin
                    sLine2:=(ts[j]);
                    if sLine2='' then
                      continue;
                    StrLst3:=DoStrArray2(sLine2,#9);
                    if Length(StrLst3)>=5 then
                    begin
                      if (StrLst2[5]=StrLst3[4]) then //≥o¨qßP¬_≈ﬁøË¿≥∏”¨Oø˘ª~µL•Œ™∫°Aº»Æ…•˝Ødµ€ßa
                      begin
                        sLine3:=ZuoFang+StrLst3[0]+SepItem2Str+StrLst3[1]+YouFang+SepItemStr+StrLst3[2]+SepItemStr+StrLst3[3]+SepItemStr+TimeKey2TimeStr(StrLst3[4])+SepItemStr+FAppParam.TwConvertStr('¶P§W');
                        if sSameList='' then sSameList:=sLine3
                        else sSameList:=sSameList+#13#10+sLine3;
                        ts[j]:='';
                      end
                      else if ( (Length(StrLst3)>=6) and
                           (StrLst2[5]=StrLst3[5])
                         ) then
                      begin
                        sLine3:=ZuoFang+StrLst3[0]+SepItem2Str+StrLst3[1]+YouFang+SepItemStr+StrLst3[3]+SepItemStr+StrLst3[4]+SepItemStr+TimeKey2TimeStr(StrLst3[5])+SepItemStr+FAppParam.TwConvertStr('¶P§W');
                        if sSameList='' then sSameList:=sLine3
                        else sSameList:=sSameList+#13#10+sLine3;
                        ts[j]:='';
                      end;
                    end;
                  end;

                  bUpload:=FillUploadRelative(StrLst2[5],sLine2);
                  sLine3:=ZuoFang+StrLst2[0]+SepItem2Str+StrLst2[1]+YouFang+SepItemStr+StrLst2[3]+SepItemStr+StrLst2[4]+SepItemStr+TimeKey2TimeStr(StrLst2[5])+SepItemStr+FtpStatusBool2Str(bUpload);
                  if sSameList<>'' then
                    sLine3:=sLine3+#13#10+sSameList;
                  if bUpload then
                  begin
                    ts2.Add(sLine3);
                    //ts2.Add('');
                  end
                  else begin
                    ts3.Add(sLine3);
                    //ts3.Add('');
                  end;
                end;
             end;
           end;
           if (ts2.Count>0) or (ts3.Count>0) then
           begin
             sLine3:='Ecb°iæﬁß@§H,•NΩX°j'+_SepItem+'°iæﬁß@√˛´¨°j'+_SepItem+'°iæﬁß@≠∂≠±°j'+_SepItem+'°iÆ…∂°°j'+_SepItem+'°i§W∂«™¨∫A°j';
             sLine:=sLine3;
             if (ts3.Count>0) then
             begin
               sLine:=sLine+#13#10+#13#10+'<h2 color="red">========§W∂«•ºßπ¶®========</h2>'+#13#10+#13#10+FAppParam.ToTwIfCnSys(ts3.text);
             end;
             if (ts2.Count>0) then
             begin
               sLine:=sLine+#13#10+#13#10+'<h2>========§W∂«§wßπ¶®========</h2>'+#13#10+#13#10+FAppParam.ToTwIfCnSys(ts2.text);
             end;
             sLogForCbpaEcb:=sLine;
           end
           else begin
             //sLine:='µL∏ÍÆ∆∫˚≈@∞Oø˝';
           end;
      end;


       if (sLogForCbpaEcb='') and (sLogForCbpa='') then
       begin
         sLine:='µL∏ÍÆ∆∫˚≈@∞Oø˝';
       end
       else begin
         sLine:=sLogForCbpa+#13#10+#13#10+#13#10+sLogForCbpaEcb;
       end;
       CreateAMail(false, 'cbpa∏ÍÆ∆∫˚≈@'+FormatDateTime('yyyy/mm/dd',date),sLine);
       ShowMsg2Tw('ok.');
       result:=true;
    except
      on e:Exception do
      begin
        ShowMsg2Tw('≤£•Õæﬁß@∞Oø˝¶}∂l±H e:'+e.message);
      end;
    end;
    finally
      try if Assigned(ts) then FreeAndNil(ts); except end;
      try if Assigned(ts2) then FreeAndNil(ts2); except end;
      try setlength(FRecLogs,0); except end;
      ShowMsg2Tw('∞ı¶Êµ≤ßÙ.');
    end;
end;

procedure TAMainFrm.btn1Click(Sender: TObject);
begin
  ColloectUploadLog;
end;

procedure TAMainFrm.chkAutoAuditDocOnClick(Sender: TObject);
var bChkAutoAudit:boolean; s:string;
begin
  bChkAutoAudit:=chkAutoAuditDoc.Checked;
  if bChkAutoAudit then s:='1'
  else s:='0';   
  SaveIniFile2('DocCenter','AutoAuditDoc',s,AppPath+'setup.ini');
end;

function TAMainFrm.LoadOfDocDataMgr_2DocList(aChkDocListCount,aChkNowIsLoading:Boolean):Boolean;
var bLoad:Boolean; sFileOutList:string;
begin
  result:=false;
  if aChkNowIsLoading then
  begin
    if NowIsLoading then
      exit;
  end;
  
  try
    if aChkNowIsLoading then NowIsLoading := True;
    bLoad:=(not aChkDocListCount) or
           ( (aChkDocListCount) and
             (DocDataMgr_2.DocList.Count=0)
           ) ;
    if bLoad then
    Begin
      if DocDataMgr_2.TempDocFileNameExists Then
      Begin
        ShowMsgTw('•[∏¸§Ωßi´HÆß¿…Æ◊...');
        sFileOutList:=DocDataMgr_2.LoadFromTempDocFile2;
        ShowMsg(sFileOutList);

        if DocDataMgr_2.DocList.Count>0 Then
        Begin
          //©w∏q•NΩX™∫•´≥ı© ΩË©M¶W∫Ÿ
          FIDLstMgr.Refresh;
          DocDataMgr_2.SetDocLstCBID(FIDLstMgr);
        End;
        ShowMsgTw('•[∏¸ßπ¶®,¶@¶≥§Ωßi' + IntToStr(DocDataMgr_2.DocList.Count) + ' ´›ºfÆ÷');
      End;
      result:=true;
    End;
  finally
    if aChkNowIsLoading then NowIsLoading   := false;
  end;
end;

initialization
begin
//--DOC4.0.0°XN001 huangcq090407  DocªPWarningCenteræ„¶X  -->
  G_Caption :=('Doc Center Ver['+GetFileVer(Application.ExeName)+']');
  Handle:=FindWindow('TAMainFrm',PChar(G_Caption));
  if Handle<>0 then Halt;
  //<--DOC4.0.0°XN001 huangcq090407  DocªPWarningCenteræ„¶X

  InitializeCriticalSection(CriticalSection);
  InitializeCriticalSection(CriticalSection2);
  InitializeCriticalSection(FCsMmo1);
  InitializeCriticalSection(FCsMmo2);
end;

end.
