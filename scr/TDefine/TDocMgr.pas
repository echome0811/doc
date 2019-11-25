{******************************************************************************
修改人员：董霏
修改时间：2005/9/9
1. function TCBDataMgr.GetCBDataTextFileName(const FileName: String): String;
   调整接收文件名称前加上zz_(中证)  。Sz_（上证）
2、Doc_Ftp-doc2.3.0需求8-libing-2007/9/19
//--DOC4.0.0—N001 huangcq090617 add Doc与WarningCenter整合
//--Doc091120-sun CB资料查看的问题
//--Doc20090306  公告重复收集的问题  wangjinhua
*******************************************************************************}
unit TDocMgr;

interface
Uses Windows,IniFiles,Controls,Classes,Forms,SysUtils,CsDef,TCommon,IdHTTP,
   Graphics,ADODB,DateUtils,Dialogs,StdCtrls,StrUtils,IdComponent,TDocRW,
   uLevelDataFun,uFuncFileCodeDecode,FReplace;//FastStrings
const
  CHttpSleep=5;
  CParamSep=';';
  CDftReadTimeout=60000;
  CDftConnectTimeout=10000;
  CDftUserAgent='Mozilla/4.0 (compatible; MSIE 5.5; Windows.NT.5.0)' ;
  CPtStr='1';
  CPtInt='2';
  CPtBool='3';
  CParamFmt='(%s)%s=%s';
  EInterrupt='Interrupt';
  E404NotFound='404 Not Found';

  CReadTimeout='ReadTimeout';
  CConnectTimeout='ConnectTimeout';
  CUserName='UserName';
  CPassword='Password';
  CUserAgent='UserAgent';
  CPServerName='PServerName';
  CPServerPort='PServerPort';
  CPServerUserName='PServerUserName';
  CPServerPwd='PServerPwd';
  CTagDataBeginFlag='%TagB';
  CTagDataEndFlag='TagE%';
  CNew='_new';
  CNewStop='_newstop';

  _PasswayTxt='passaway.txt';
  //_PasswayTxt201508='passaway201508.txt';

type
  TParamType=(ptStr,ptInt,ptBool);
  TChkStatus=(chkNone,chkOK,chkDel,chkEsc);

  TDLst=record
    GUID:String[8];
    MEMO:String[10];
    FNAME:String[100];
  End;
  PTDLst=^TDLst;
  
  TFTPINFO = record
    FFTPPort : Integer;
    FFTPServer : String;
    FFTPUploadDir : String;
    FFTPUserName : String;
    FFTPPassword : String;
    FFTPPassive  : Boolean;
  end;

  TDocMgrParam=Class
  private
      FTr1DBPath : String;
      FDocServer : String;
      FFTPTr1DBPath : String;
      {FFTPPort : Integer;
      FFTPServer : String;
      FFTPUploadDir : String;
      FFTPUserName : String;
      FFTPPassword : String;
      FFTPPassive  : Boolean;  }
      FCBFTPPort : Integer;
      FCBFTPServer : String;
      FCBFTPUploadDir : String;
      FCBFTPUserName : String;
      FCBFTPPassword : String;
      FCBFTPPassive  : Boolean;

      FCBFTP2Port : Integer;
      FCBFTP2Server : String;
      FCBFTP2UploadDir : String;
      FCBFTP2UserName : String;
      FCBFTP2Password : String;
      FCBFTP2Passive  : Boolean;
      //Doc_Ftp-doc2.3.0需求8-libing-2007/9/19
      //***************************************
      FCBFTPCount : Integer; //存放CB资料服务器数目
      FCBFTPInfos : Array of TFTPINFO;
      //***************************************
      FDocFTPCount : Integer;
      FDocFTPInfos : Array of TFTPINFO;

      FMarkKeyWord : Array of string;
      FCaptionKeyWord : Array of string;
      FGetNeverCheckDoc: Boolean;
      FCaption: String;
      FNameTblServer: String;
      FCharSet : String;
      FDwnMemo:integer;//--Doc3.2.0需求3 huangcq080928 add
      FAutoDelManualBackupTmpFile:Boolean; //--Doc3.2.0需求3 huangcq080928 add
      FCheckDocLogSaveDays_NiFang:Integer;
      FCheckDocLogSaveDays_GuoHui:Integer;
      FCheckDocLogSaveDays_ShangShi:Integer;

      //--DOC4.0.0—N001 huangcq090407 add----->
      FDocMonitorStartOtherApp : Boolean;
      FDocMonitorCloseOtherApp : Boolean;
      FDocMonitorBeepWhenError : Boolean;
      FDocMonitorBeepCodeErrorMsg :  String;
      FDocMonitorPort : Integer;
      FDocMonitorHostName : String;
      FDocMonitorAutoStart : Boolean;
      FDocMonitorMessage :Boolean;
      FDocMonitorError :Boolean;
      FDocMonitorWarning :Boolean;
      //<-----DOC4.0.0—N001 huangcq090407 add---
      //--DOC4.0.0—N002 huangcq090617 add----->
      FDocCenterSktPort : Integer;
      //<--DOC4.0.0—N002 huangcq090617 add--

      FSoundPort: Integer;
      FSoundServer: String;
      //add by wangjinhua 0306
      FDoc01_WaitForWeb:Integer;
      FDoc01_OKSleepTime:Integer;
      FDoc01_ErrSleepTime:Integer;
      //--

      //add by wangjinhua 20090602 Doc4.3
      FRunMode:Integer;
      FUserMngModouleListCount:Integer;
      FUserMngBtnKeyWordListCount:Integer;
      FUserMngModouleList : Array of string;
      FUserMngBtnKeyWordList : Array of string;
      //--

	   //add by wjh 2011-10-14
      FDoc03PageSum:integer;//设定过会公告搜索最大页面数目
      FDoc03_OKSleepTime:integer; //设定成功下载后每轮的休眠间隔时间
      FDoc03_ErrSleepTime:integer; //设定下载失败后每轮的休眠间隔时间
      FDoc03BeforeM:integer;
      //--
      FTodayHintListenPort:integer;

      FRateDatInterval:integer;
      FRateDatInterval2:integer;
      FRateDatFTPCount : Integer; 
      FRateDatFTPInfos : Array of TFTPINFO;
      FRateDatPath:string;
	  
      function GetMarketKeyWord(index: integer): String;
      function GetFDocFTPInfos(index: integer): TFTPINFO;
      //Doc_Ftp-doc2.3.0需求8-libing-2007/9/19
      //----------Cb资料
      function GetFCBFTPInfos(index: integer): TFTPINFO;
      function GetFRateDatFTPInfos(index: integer): TFTPINFO;
      //-----------
      function GetMarketKeyWordCount: integer;
      procedure Init(const FileName:String);
      function GetCaptionKeyWord(index: integer): String;
      function GetCaptionKeyWordCount: integer;

//add by wangjinhua 20090602 Doc4.3
      function GetUserMngModoule(index: integer): String;
      function GetUserMngBtnKeyWord(index: integer): String;
//--
  public
     //add by wangjinhua 20090602 Doc4.3
     FUserMngBtnKWList : Array of string;
     //--
     //add by wangjinhua 0306
     FDoc01TextParseTokens:array of string;
     //--

     constructor Create();overload;
     constructor Create(const FileName:String);overload;
     destructor Destroy; override;
     Procedure Refresh(); //<-----DOC4.0.0—N001 huangcq090407 add

     function IsTwSys:boolean;
     Function ConvertString(Const Msg:String):String;
     Function TwConvertStr(Const Msg:String):String;
     Function TwConvertStr2(Const Msg:String):String;
     Function ToTwIfCnSys(Const Msg:String):String;
     //Function ToCnIfTwSys(Const Msg:String):String;

     Function TwToGBConvertStr(Const Msg:String):String;
     function ConvertStringGB(Msg:String):String;//繁体转换成简体

     property Tr1DBPath : String read FTr1DBPath;
     property DocServer : String read FDocServer;
     property NameTblServer : String read FNameTblServer;
     property DwnMemo :integer read FDwnMemo;//--Doc3.2.0需求3 huangcq080928 add
     property AutoDelManualBackupTmpFile :Boolean read FAutoDelManualBackupTmpFile write FAutoDelManualBackupTmpFile;
                         //--Doc3.2.0需求3 huangcq080928 add     

     property GetNeverCheckDoc:Boolean read FGetNeverCheckDoc;

     property  SoundPort : Integer read FSoundPort;
     property  SoundServer : String read FSoundServer;

     property  FTPTr1DBPath : String read FFTPTr1DBPath;

     property  CBFTPPort : Integer read FCBFTPPort;
     property  CBFTPServer : String read FCBFTPServer;
     property  CBFTPUploadDir : String read FCBFTPUploadDir;
     property  CBFTPUserName : String read FCBFTPUserName;
     property  CBFTPPassword : String read FCBFTPPassword;
     property  CBFTPPassive  : Boolean read FCBFTPPassive;

     property  CBFTP2Port : Integer read FCBFTP2Port;
     property  CBFTP2Server : String read FCBFTP2Server;
     property  CBFTP2UploadDir : String read FCBFTP2UploadDir;
     property  CBFTP2UserName : String read FCBFTP2UserName;
     property  CBFTP2Password : String read FCBFTP2Password;
     property  CBFTP2Passive  : Boolean read FCBFTP2Passive;

     property  DocFTPCount  : Integer read FDocFTPCount;
     property  DocFTPInfos[index:integer] : TFTPINFO read GetFDocFTPInfos;

     property MarketKeyWordCount:integer read GetMarketKeyWordCount;
     property MarketKeyWord[index:integer]:String read GetMarketKeyWord;
     property CaptionKeyWordCount:integer read GetCaptionKeyWordCount;
     property CaptionKeyWord[index:integer]:String read GetCaptionKeyWord;
     property Caption:String Read FCaption;
     //Doc_Ftp-doc2.3.0需求8-libing-2007/9/19
     //*******************************************
     property  CBFTPCount  : Integer read FCBFTPCount;//CB资料
     property  CBFTPInfos[index:integer] : TFTPINFO read GetFCBFTPInfos;
     //*********************************************
     //--DOC4.0.0—N001 huangcq090407 add----->
     property  DocMonitorBeepWhenError : Boolean read FDocMonitorBeepWhenError write FDocMonitorBeepWhenError;
     property  DocMonitorBeepCodeErrorMsg :  String read FDocMonitorBeepCodeErrorMsg write FDocMonitorBeepCodeErrorMsg;
     property  DocMonitorPort : Integer read FDocMonitorPort write FDocMonitorPort;
     property  DocMonitorHostName : String read FDocMonitorHostName write FDocMonitorHostName;
     property  DocMonitorStartOtherApp : Boolean read FDocMonitorStartOtherApp write FDocMonitorStartOtherApp;
     property  DocMonitorCloseOtherApp : Boolean read FDocMonitorCloseOtherApp write FDocMonitorCloseOtherApp;
     property  DocMonitorAutoStart : Boolean read FDocMonitorAutoStart write FDocMonitorAutoStart;
     property  DocMonitorMessage : Boolean read FDocMonitorMessage write FDocMonitorMessage;
     property  DocMonitorError :Boolean read FDocMonitorError write FDocMonitorError;
     property  DocMonitorWarning : Boolean read FDocMonitorWarning write FDocMonitorWarning;
     //<-----DOC4.0.0—N001 huangcq090407 add---
     //--DOC4.0.0—N002 huangcq090617 add----->
     property  DocCenterSktPort : Integer read FDocCenterSktPort write FDocCenterSktPort;
     //<--DOC4.0.0—N002 huangcq090617 add--

     //add by wangjinhua 0306
     property Doc01_WaitForWeb : Integer read FDoc01_WaitForWeb;
     property Doc01_OKSleepTime : Integer read FDoc01_OKSleepTime;
     property Doc01_ErrSleepTime : Integer read FDoc01_ErrSleepTime;
     //--

     property CheckDocLogSaveDays_NiFang : Integer read FCheckDocLogSaveDays_NiFang;
     property CheckDocLogSaveDays_GuoHui : Integer read FCheckDocLogSaveDays_GuoHui;
     property CheckDocLogSaveDays_ShangShi : Integer read FCheckDocLogSaveDays_ShangShi;
	 //add by wjh 2011-10-14
     property  Doc03PageSum : Integer read FDoc03PageSum write FDoc03PageSum;
     property  Doc03_OKSleepTime : Integer read FDoc03_OKSleepTime write FDoc03_OKSleepTime;
     property  Doc03_ErrSleepTime : Integer read FDoc03_ErrSleepTime write FDoc03_ErrSleepTime;
     property  Doc03BeforeM : Integer read FDoc03BeforeM write FDoc03BeforeM;
     //--
     property  TodayHintListenPort : Integer read FTodayHintListenPort write FTodayHintListenPort;
     //add by wangjinhua 20090602 Doc4.3
      property  RunMode:Integer  read FRunMode;
      property  UserMngModouleListCount:Integer  read FUserMngModouleListCount;
      property  UserMngBtnKeyWordListCount:Integer  read FUserMngBtnKeyWordListCount;
      property  UserMngModouleList[index:integer]:String read GetUserMngModoule;
      property  UserMngBtnKeyWordList[index:integer]:String read GetUserMngBtnKeyWord;
      property  CharSet:String read FCharSet;

      property  RateDatFTPCount  : Integer read FRateDatFTPCount;
      property  RateDatFTPInfos[index:integer] : TFTPINFO read GetFRateDatFTPInfos;
      property  RateDatInterval  : Integer read FRateDatInterval;
      property  RateDatInterval2  : Integer read FRateDatInterval2;
      property  RateDatPath :string read FRateDatPath;
      //--
  end;

  TDocData=Class
  Private
    FGUID : String;
    FTitle : String;
    FID : String;
    FDOCID : String;
    FCBID  : String;
    FCBNAME: String;
    FCBStatus: String;
    FDocType : String;
    FDate : TDate;
    FTime : TTime;
    FMemo: String;
    FURL : String;

    FOperator,FDocStatus:string; FOpTime:TDateTime;

    FTempFileName:string;
    function GetFmtDate: String;
    function GetFmtDateTime: String;
    function GetText: String;
    Function GetSection(Var StratIndex:Integer;Const f:TStringList;Const Section:String):String;
    procedure SetText(const Value: String);
    procedure GetDocClassTxtAndColor(var ClassTxt:String;Var ClassColor:TColor;Var ClassIndex:Integer);
    function GetDocClass: String;
    function GetDocColor: TColor;
    function GetDocClassIndex: Integer;
    procedure SetMemo(const Value: String);
  Public
    constructor Create(const Checked : boolean;
                       const Title : String;
                       const ID : String;
                       const DocType : String;
                       const Date : TDate;
                       const Time : TTime;
                       const Memo:String;
                       const URL:String);OverLoad;
    constructor Create(const GUID : String;
                       const Title : String;
                       const ID : String;
                       const Date : TDate;
                       const Time : TTime;
                       const Memo:String;
                       const URL:String
                       );OverLoad;
     constructor Create(const GUID : String;
                       const Title : String;
                       const ID : String;
                       const Date : TDate;
                       const Time : TTime;
                       const Memo:String;
                       const URL:String;
                       const ATempFileName:String
                       );OverLoad;
    constructor Create(const Text:String);OverLoad;
    constructor Create(const Text:String;const ATempFileName:String);OverLoad;
    destructor  Destroy; override;

    Property FmtDate : String read GetFmtDate;
    Property FmtDateTime : String read GetFmtDateTime;

    function DocExist(ADoc:TDocData):Boolean;

    function SaveToDataBase(const DBFileName:String):Boolean;
    function SaveToFile(const FilePath:String):string;
    function SaveToFile_DEl(const FilePath:String):Boolean;
    property Text:String read GetText write SetText;
    Property GUID:String read FGUID write FGUID;
    Property Title : String read FTitle Write FTitle;
    Property ID : String read FID write FID;
    Property DOCID : String read FDOCID write FDOCID;
    Property CBID:String read FCBID Write FCBID;
    Property CBNAME:String read FCBNAME Write FCBNAME;
    Property CBStatus:String read FCBStatus Write FCBStatus;
    Property DocType : String read FDocType write FDocType;
    Property Date : TDate read FDate Write FDate;
    Property Time : TTime read FTime Write FTime;
    Property Memo:String read FMemo Write SetMemo;
    Property URL:String read FURl Write FURL;

    property DocClassTxt:String Read GetDocClass;
    property DocClassIndex:Integer Read GetDocClassIndex;
    property DocClassColor:TColor Read GetDocColor;
    property TempFileName:string Read FTempFileName;

    Property Operator:String read FOperator Write FOperator;
    Property OpTime:TDateTime read FOpTime Write FOpTime;
    Property DocStatus:String read FDocStatus Write FDocStatus;
  End;

  TDocID=Record
      ID:String;
      CBID:String;
      CBNAME:String;
      CBStatus:String;
      Date1:TDate;
  End;
  PDocID = ^TDocID;

  TUploadDoc=Record
    ID:String;
    Date : TDate;
    Title : string;
    FileName : String;
    FTP_Note : Integer;
    Del:integer;
  End;
  PUploadDoc = ^TUploadDoc;

  TRunHttp=Class(TThread)
  private
     FHTTP: TIdHTTP;
     FURL : String;
     FRunErrMsg: String;
     FHaveRunFinish: Boolean;
     FResultString: String;
     FTimeOut : DWord;
     procedure RefreshTimeOut();
     function GetTimeOut():Boolean;
     procedure SleepWait(Const Value:Double);
     procedure RunHttp();
     function GetHaveRunFinish: Boolean;
  protected
     procedure Execute; override;
  public
      constructor Create(HTTP: TIdHTTP;URL:String);
      destructor  Destroy; override;
      property RunErrMsg : String read FRunErrMsg;
      property HaveRunFinish : Boolean Read GetHaveRunFinish;
      property ResultString:String Read FResultString;
  end;

  THttpStatusEvent = procedure(ASender: TObject;AStatusText: string;aKey:string) of object;
  THttpBeginEvent = procedure(Sender: TObject;AWorkCountMax: Integer;aKey:string) of object;
  THttpEndEvent = procedure(Sender: TObject;aDoneOk:Boolean;aKey,aResult:string) of object;
  THttpWorkEvent = procedure(Sender: TObject; AWorkCount,AWorkMax: Integer;aKey:string) of object;
  THttpDownEndEvent = procedure(Sender: TObject;aDoneOk:Boolean;aKey,aResult:string) of object;


  {HttpGet}
  THttpGet=Class(TThread)
  private
      FHTTP: TIdHTTP;
      FHttpStatusEvent: THttpStatusEvent;
      FHttpWorkEvent: THttpWorkEvent;
      FHttpBeginEvent: THttpBeginEvent;
      FHttpEndEvent: THttpEndEvent;
      FHttpDownEndEvent:THttpDownEndEvent;


      FWorkMax:integer;     //要传送的字节
      FWorkCurrent:integer; //当前传送的字节

      FTryErrTimes:Integer; //当前下载可以允许失败重试的次数(默认为3次)
      FIndex:integer; // index,Url,Guid用作当前任务的标示关键字，一般情况下用Url就可以，但是在这里我选用了index来配合显示线程进行消息显示
      FGuid:string;
      FURL : String;
      FSaveToFile:string; //标示下载成功后的结果保存的文件路径，在Setint中初始化；如果为空则表示不保存
      FKey:string;//标示当前任务,在SetInit中初始化，可以为index,Url,Guid
      FTag:string;

      FRunErrMsg: String;
      FResultString: TStringList;
      FStop:Boolean;

      function GetResultString:string;
      procedure SetStop(aValue:Boolean);
      procedure CreateHttp;
      procedure DestroyHttp;
      procedure DisconnctHttp;
      procedure ClsUrl;

      procedure DoHttpStatus(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
      procedure DoHttpWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
      //procedure DoHttpEnd(Sender: TObject; AWorkMode: TWorkMode); overload;
      procedure DoHttpEnd();
      procedure DoHttpBegin(Sender: TObject; AWorkMode: TWorkMode;const AWorkCountMax: Integer);
      procedure DoHttpDownEnd();

      procedure ShowMsg(aMsg:string);
      function GetIdle:Boolean;
  protected
      procedure Execute; override;
  public
      constructor Create();
      destructor  Destroy; override;
      procedure SetInit(aUrl:String;aIndex:integer=-1;aGuid:string='';
           aSaveToFile:string='';aTryErrTimes:integer=3;aHttpParamSet:string='';aTag:string='');
      function DoneFinish: Boolean;
      function DoneSuc:Boolean;

      property RunErrMsg : String read FRunErrMsg;
      property ResultString:String Read GetResultString;

      property Index:integer read FIndex;
      property GUID:string read FGuid;
      property Url:string read FUrl;
      property Stop:Boolean Read FStop Write SetStop;

      property OnHttpStatus: THttpStatusEvent read FHttpStatusEvent write FHttpStatusEvent;
      property OnHttpWork: THttpWorkEvent read FHttpWorkEvent write FHttpWorkEvent;
      property OnHttpBegin: THttpBeginEvent read FHttpBeginEvent write FHttpBeginEvent;
      property OnHttpEnd: THttpEndEvent read FHttpEndEvent write FHttpEndEvent;
      property OnHttpDownEnd: THttpDownEndEvent read FHttpDownEndEvent write FHttpDownEndEvent;
      property Idle:Boolean read GetIdle;

  end;


  TIDLstMgr = Class
  private
     FIDList : TList;
     FIDListPath : String;
     FileAgeStr : String;
     FTxtFileScope:TxtFileScope_MP; //---Doc3.2.0需求1 huangcq080923 add
     procedure SstIDDocStartDate();
     procedure SetAID(const ID,CBID,CBNAME,CBStatus:String);
     Procedure InitData();
     Procedure InitData2();
     Procedure InitData3();
     function GetIDItems(Index: Integer): String;
     function GetIDCount(): Integer;
     function GetCBIDItems(Index: Integer): String;
     function GetCBNameItems(Index: Integer): String;
     function GetCBStatusItems(Index: Integer): String;
     function GetID(Index: Integer):PDocID;
  public
      constructor Create(Const IDListPath:String;TxtFileScope_MP: TxtFileScope_MP);//---Doc3.2.0需求1 huangcq080923 modify
      constructor Create2(Const IDListPath:String;TxtFileScope_MP: TxtFileScope_MP);//---Doc3.2.0需求1 huangcq080923 modify
      constructor Create3(Const IDListPath:String;TxtFileScope_MP: TxtFileScope_MP);//---Doc3.2.0需求1 huangcq080923 modify
      constructor Create4(Const IDListPath:String;TxtFileScope_MP: TxtFileScope_MP);//---Doc3.2.0需求1 huangcq080923 modify
      constructor Create5(Const IDListPath:String;TxtFileScope_MP: TxtFileScope_MP);
      destructor  Destroy; override;
      Procedure Refresh();
      property IDCount:Integer read GetIDCount;
      property IDItems[Index:Integer]:String read GetIDItems;
      property CBIDItems[Index:Integer]:String read GetCBIDItems;
      property CBNameItems[Index:Integer]:String read GetCBNameItems;
      property CBStatusItems[Index:Integer]:String read GetCBStatusItems;
      property IDLst[Index:Integer]:PDocID read GetID;
  end;

  TDocDataMgr = Class
  private
     FDocPath : String;
     FTempDocFileName : String;
     FLogPath : String;
     FTempTag : String;
     FNowTempDocFileName : String;
     FDocList : TList;
     FNotGetMemoDocList : TList;
     FEndReadDocList : TList;
     FExistDocTitle  : TStringList; //已存在的公告抬頭
     FLogDocList : TList;
     FCheckDocLogSaveDays:Integer;

     FQueryString : string;
     FConnectString : String;
     FDocID : String;
     FDocAppID : String;
     FSeekDate : String;
     ClearDate :TDate;
     FLogHistory :TStringList;//add by wangjinhua 0306
     Procedure OnGetFile(FileName:String);

     procedure SaveDocToLog(Tag:String;ADoc:TDocData;ChkStatus:TChkStatus);
     procedure SaveDocToUpLoad(ADoc:TDocData;Const FileName:String);
     procedure ClearSysLog(aTag:string);

     //產生一個完成的idx檔案,用以消除待審核的紀錄
     procedure SaveDocToFinishIdx(ADoc:TDocData);

     function GetUploadLogFile():String;
     function GetTempDocFileName():String;
     function GetNotMemoDocLogFile(Const Tag:string):String;
     function GetEndReadDocLogFile(Const Tag:string):String;
     Function GetSection(var StratIndex:Integer;Const f:TStringList;Const Section:String):String;

     Procedure SetDocDataStringList(f:TStringList;ADoc:TDocData);
     Procedure GetDocDataStringList(FileStr:TStringList;List:TList);
     function GetText: String;
     procedure SetText(const Value: String);
     function GetLogDocText: String;
     procedure SetLogDocText(const Value: String);

  public
      constructor Create(Const TempDocFileName:String;Const DocPath:String);
      destructor  Destroy; override;
      procedure SetCheckDocLogSaveDays(aValue:integer);
      procedure ClearData();
      procedure ClearLogDocList();
      procedure ClearDataDocList();
      procedure ClearDataNotGetMemoList();
      procedure ClearDataEndReadDocList();
      procedure ClearDataExistDocTitleList();

      //現在正在進行檢查是否有公告缺漏
      function NowActionIsCheckAllDoc():Boolean;

      function AddADoc(const Title : String;
                       const ID : String;
                       const DocType : String;
                       const Date : TDate;
                       const Time : TTime;
                       const URL : String):TDocData;

      function AppendADoc(const Title : String;
                       const ID : String;
                       const DocType : String;
                       const Date : TDate;
                       const Time : TTime;
                       const URL : String):TDocData;

      procedure SetADocMemo(Const ADoc:TDocData;const Memo:String);
      procedure SetADocID(Const ADoc:TDocData;const ID:String);

      function GetADoc(const GUID:String):TDocData;
      function GetANotGetMemoDoc(const GUID:String):TDocData;

      procedure SetDocLstCBID(IDLst:TIDLstMgr);

      property DocListText:String read GetText write SetText;

      property DocList:TList read FDocList;
      property LogDocList:TList read FLogDocList;

      property LogDocListText:String read GetLogDocText write SetLogDocText;

      property NotGetMemoDocList:TList read FNotGetMemoDocList;
      property NowTempDocFileName:String Read FNowTempDocFileName;

      procedure SetChkDocIsOk(const Tag,GUID:String);overload;
      procedure SetChkDocIsOk(ADoc:TDocData;Const AppID:String);overload;
      procedure SetChkDocIDIsOk(const Tag, GUID:String);
      procedure DelADoc(const Tag,GUID:String);
      procedure FreeADoc(Const GUID:String);
      procedure FreeANotGetMemoDoc(Const GUID:String);

      Function GetUploadTmpFile():_cStrLst;
      Function GetUploadADoc(Const FileName:String;Const SeverName :String):TUploadDoc;
      procedure SaveUploadADoc(Const FileName:String;Const SeverName :String;Const i:integer);
      Function ThisUploadDocNeedUpload(Const Tr1DBPath:String;ADoc:TUploadDoc):Boolean;

      procedure ConvertToNewDocLst(const SourceLstFileName:String);

      Function SetUploadDocLst(ADoc:TUploadDoc):String;
      Function GetUploadDocLst():String;
      Function GetUploadStockDocLst(ID:String):String;
      Function GetUploadStockDocIdxLst():String;


      Function LoadLogDocFile(const ADate:String;const mode:Integer;const Option:Integer):String;

      Function SetQueryData(const AppID,ID,WhereStr:String):Boolean;
      procedure LoadFromDataBase();

      Function SetQueryData2(const AppID,SeekDate:String):Boolean;
      procedure LoadFromDataBase2();


      Procedure InitStockDocIdxLstDat();


      function  TempDocFileNameExists():Boolean;
      function SaveToDocDatabase():Boolean;
      procedure SaveToTempDocFile();
      procedure SaveToTempDocFile3();
      procedure SaveToTempDocFile_News03();
      procedure SaveToTempDocFile_News_TW();
      procedure SaveToNewsDocFile(aNewsDocPath:String);
      procedure SaveNotMemoDocLogFile(const tag:string);
      procedure SaveNotMemoDocLogFile2(const tag:string);
      procedure SaveEndReadDocLogFile(const tag:string);
      procedure LoadFromTempDocFile();
      procedure LoadFromTempDocFile2();
      procedure LoadFromNotMemoDocLogFile(const tag:string);
      procedure LoadFromEndReadDocLogFile(const tag:string);
      //將公告清單載入,裡面記錄有已存在的公告信息
      procedure LoadExistDocFromDocLstFile(const ID:string);
      //確認是否可以開始搜尋檢查所有公告確認是否有遺漏
      //function StartCheckSearchAllDoc():Boolean;
   
      //add by wangjinhua Doc20090306 20090324
      function IsDocExists(f,f2:TStringList;ADoc:TDocData):Boolean;
      procedure FilterADocInDocList();
      function GetDocsNum(f:TStringList):Integer;
      procedure DelAnDoc(var f:TStringList);

      procedure WriteLogHistory();
      procedure LoadLogHistory();
      Function AddADoc01(const Title : String;
                       const ID : String;
                       const DocType : String;
                       const Date : TDate;
                       const Time : TTime;
                       const URL  : String):TDocData;
      //--
  end;

  TDoc02DataMgr = Class
  private
     FDocPath : String;
     FTempDocFileName : String;
     FLogPath : String;
     FTempTag : String;
     FNowTempDocFileNameList:TStringList;
     FDocList : TList;
     FNotGetMemoDocList : TList;
     FEndReadDocList : TList;
     FExistDocTitle  : TStringList; //已存在的公告抬頭
     FLogDocList : TList;
     FCurDocCount,FTodayDocCount:Integer;
     FCheckDocLogSaveDays:Integer;

     FDocID : String;
     FDocAppID : String;
     FSeekDate : String;
     ClearDate :TDate;
     Procedure OnGetFile(FileName:String);

     procedure SaveDocToLog(Tag:String;ADoc:TDocData;ChkStatus:TChkStatus);
     procedure SaveDocToUpLoad(ADoc:TDocData;Const FileName:String);
     procedure ClearSysLog(aTag:string);

     //產生一個完成的idx檔案,用以消除待審核的紀錄
     procedure SaveDocToFinishIdx(ADoc:TDocData);

     function GetUploadLogFile():String;
     function GetTempDocFileName():String;
     Function GetSection(var StratIndex:Integer;Const f:TStringList;Const Section:String):String;

     Procedure SetDocDataStringList(f:TStringList;ADoc:TDocData);
     Procedure GetDocDataStringList(FileStr:TStringList;List:TList);
     function GetText: String;
     procedure SetText(const Value: String);
     function GetLogDocText: String;
     procedure SetLogDocText(const Value: String);

  public
      constructor Create(Const TempDocFileName:String;Const DocPath:String);
      destructor  Destroy; override;
      procedure SetCheckDocLogSaveDays(aValue:integer);
      procedure ClearData();
      procedure ClearLogDocList();
      procedure ClearDataDocList();
      procedure ClearDataNotGetMemoList();
      procedure ClearDataEndReadDocList();
      procedure ClearDataExistDocTitleList();

      //現在正在進行檢查是否有公告缺漏
      function NowActionIsCheckAllDoc():Boolean;

      function AddADoc(const Title : String;
                       const ID : String;
                       const DocType : String;
                       const Date : TDate;
                       const Time : TTime;
                       const URL : String):TDocData;

      function AppendADoc(const Title : String;
                       const ID : String;
                       const DocType : String;
                       const Date : TDate;
                       const Time : TTime;
                       const URL : String):TDocData;

      procedure SetADocMemo(Const ADoc:TDocData;const Memo:String);
      procedure SetADocID(Const ADoc:TDocData;const ID:String);

      function GetADoc(const GUID:String):TDocData;
      function GetANotGetMemoDoc(const GUID:String):TDocData;

      procedure SetDocLstCBID(IDLst:TIDLstMgr);

      property DocListText:String read GetText write SetText;

      property DocList:TList read FDocList;
      property LogDocList:TList read FLogDocList;

      property LogDocListText:String read GetLogDocText write SetLogDocText;

      property NotGetMemoDocList:TList read FNotGetMemoDocList;

      function DelDocLst(aID:String;aTitle,aDate:String):Boolean;
      function DelIDLst(aID:String;aTitle,aDate:String;var sRtfFile:string):Boolean;
      function MakeUploadFile(aID,aTitle,aFilePath:String):Boolean;
      function MakeUploadFileDel(aID,aTitle,aFilePath:String):Boolean;
      function CancelADoc(ADoc:TDocData;aDocLogFile:string;var aRst:string):boolean;
      function SetADocStatus(ADoc:TDocData;aDocLogFile:string;var aRst:string):boolean;
      procedure SetChkDocIsOk(const Tag,GUID:String);overload;
      procedure SetChkDocIsOk(ADoc:TDocData;Const AppID:String);overload;
      procedure SetChkDocIDIsOk(const Tag, GUID:String);
      procedure DelADoc(const Tag,GUID:String);
      procedure FreeADoc(Const GUID:String);
      procedure FreeANotGetMemoDoc(Const GUID:String);

      Function GetUploadTmpFile():_cStrLst;
      Function GetUploadADoc(Const FileName:String;Const SeverName :String):TUploadDoc;
      procedure SaveUploadADoc(Const FileName:String;Const SeverName :String;Const i:integer);
      Function ThisUploadDocNeedUpload(Const Tr1DBPath:String;ADoc:TUploadDoc):Boolean;

      procedure ConvertToNewDocLst(const SourceLstFileName:String);

      Function SetUploadDocLst(ADoc:TUploadDoc):String;
      Function GetUploadDocLst():String;
      Function GetUploadStockDocLst(ID:String):String;
      Function GetUploadStockDocIdxLst():String;


      Function LoadLogDocFile(const ADate:String;const mode:Integer;const Option:Integer):String;
      Procedure InitStockDocIdxLstDat();


      function  TempDocFileNameExists():Boolean;
      procedure DelToTempDocFile(aGUID,aTmpFileName:string);
      function LoadFromTempDocFile2():string;
      //將公告清單載入,裡面記錄有已存在的公告信息
      procedure LoadExistDocFromDocLstFile(const ID:string);
      //確認是否可以開始搜尋檢查所有公告確認是否有遺漏
      //function StartCheckSearchAllDoc():Boolean;

      //--
      property CurDocCount:Integer read FCurDocCount;
      property TodayDocCount:Integer read FTodayDocCount;
  end;

  TCBDataMgrBase = Class
  private
    FIsTw:Boolean;
    FTr1DBPath : String;
    FExceptCodeList:TStringList;//惠璶盢癘魁眖タΑ计沮ゅンだ瞒ㄓ絏
    FShangShiCodeList:TStringList;

    function GetUploadLogFileRateData():String;
    function GetUploadLogFile():String;
    function GetUploadLogFile2(aTag:string):String;
    function GetUploadLogFile3():String;
    function GetUploadLogFile4():String;
    function GetUploadLogFile5():String;
    function GetUploadLogFile6(aAdd,aFileName:string):String;
    function GetUploadLogFile7():String;
    function GetUploadLogFile7RateData():String;
    function CodeInType(aCode:string):integer;
  public
      constructor Create(aTw:boolean;Tr1DBPath:String);
      destructor  Destroy; override;
      procedure RefreshExceptList;
      procedure RefreshShangShiCodeList;
      function LoaclDatDir():string;virtual;
      function LoaclDatDirRateData():string;

      Function GetUploadTmpFile():_cStrLst;
      Function GetUploadTmpFileRateData():_cStrLst;
      Function GetUploadAFileName(Const FileName:String):String;
      Function GetUploadAFolder(Const FileName:String):String;

      procedure ChangeDBLstVer(const FileName:String);
      Function GetCBDataFile_FullPath(FileName:String):String;
      Function GetCBData_FullPath():String;
      Function GetCBDataTextFileName(FileName:String):String;
      function CreateCBDataFileIfNotExists(FileName:String):boolean;
      function CreateEmptyTextFile(aInputFile:string):Boolean;
      function CreateEmptycbstopconvdat(aInputFile:string):Boolean;virtual;


      Function GetCBDataText(Const FileName:String):String;
      function GetCBNameFromConfig(pCBkeyName:string):string;
      Function GetCBDataLog(Const sDateS,aDateE,DstFileName:String):Boolean;
      function GetCBDataOpLog(sDateS,aDateE,aDstFile:String):boolean;
      function GetCBDataOpLogByM(sDateS,aDateE,aDstFile,aM:String;var ts:TStringList):boolean;
      function GetNewDatFile(aSrcFile:string):string;
      function GetNewStopDatFile(aSrcFile:string):string;

      function ProSep_cbidx(aFtpXiaShi,aFtpNotXiaShi:boolean):string; //锣肂 cvtBin
      function ProSep_cbidx2(aFtpXiaShi,aFtpNotXiaShi:boolean):string; //锣肂 cvtBin
      function ProSep_Cbidx2OrCbidx(sTagFile:string;aFtpXiaShi,aFtpNotXiaShi:boolean): string;
      function ProSep_strike2(aFtpXiaShi,aFtpNotXiaShi:boolean):string; //锣基秸俱 cvtBin
      function ProSep_strike32(aFtpXiaShi,aFtpNotXiaShi:boolean):string;  //ユら疊碩 cvtBin
      function ProSep_strike3(aFtpXiaShi,aFtpNotXiaShi:boolean):string;  //ユら疊碩 cvtBin
      function ProSep_strike32Orstrike3(sTagFile:string;aFtpXiaShi,aFtpNotXiaShi:boolean): string;
      function ProSep_cbissue2(aFtpXiaShi,aFtpNotXiaShi:boolean):string; //呼呼 cvtBin
      function ProSep_cbpurpose(aFtpXiaShi,aFtpNotXiaShi:boolean):string;  //兑栋戈ノ硚
      function ProSep_cbdoc(aFtpXiaShi,aFtpNotXiaShi:boolean):string;  //兵蹿ゅ
      function ProSep_cbstockholder(aFtpXiaShi,aFtpNotXiaShi:boolean):string;
      function ProSep_cbstopconv(aFtpXiaShi,aFtpNotXiaShi:boolean):string;virtual;  //氨ゎ锣传戳丁 InitBin
      function ProSep_cbredeemdate(aFtpXiaShi,aFtpNotXiaShi:boolean):string;  //奴兵蹿
      function ProSep_cbsaledate(aFtpXiaShi,aFtpNotXiaShi:boolean):string;  //芥兵蹿
      function ProSep_cbdate(aFtpXiaShi,aFtpNotXiaShi:boolean):string;  //璶ら戳

      function ProSepPassHis_cbidx(aExtractYear:string):string; //锣肂 cvtBin
      function ProSepPassHis_strike2(aExtractYear:string):string; //锣基秸俱 cvtBin
      function ProSepPassHis_strike3(aExtractYear:string):string; //ユら疊碩 cvtBin
      function ProSepPassHis_cbissue2(aExtractYear:string):string; //呼呼 cvtBin
      function ProSepPassHis_cbpurpose(aExtractYear:string):string;  //兑栋戈ノ硚
      function ProSepPassHis_cbdoc(aExtractYear:string):string;  //兵蹿ゅ
      function ProSepPassHis_cbstockholder(aExtractYear:string):string;
      function ProSepPassHis_cbstopconv(aExtractYear:string):string;virtual;  //氨ゎ锣传戳丁 InitBin
      function ProSepPassHis_cbredeemdate(aExtractYear:string):string;  //奴兵蹿
      function ProSepPassHis_cbsaledate(aExtractYear:string):string;  //芥兵蹿
      function ProSepPassHis_cbdate(aExtractYear:string):string;  //璶ら戳
  End;
  
  TCBDataMgr = Class(TCBDataMgrBase)
  private
    function GetNifaxingCBText: String;
    procedure SetNifaxingCBText(const Value: String);
    function GetPassCBText: String;
    procedure SetPassCBText(const Value: String);
    function GetHushiCBText: String;
    function GetPassawayCBText: String;
    function GetShenshiCBText: String;
    procedure SetHushiCBText(const Value: String);
    procedure SetShenshiCBText(const Value: String);
    function GetStopCBText: String;
    procedure SetStopCBText(const Value: String);

    function GetshangguiCBText: String;
    function GetshangshiCBText: String;
    function GetSongCBText: String;
    function GetguapaiCBText: String;
    function GetxunquanCBText: String;
    procedure SetshangguiCBTxt(const Value: String);
    procedure SetshangshiCBTxt(const Value: String);
    procedure SetSongCBTxt(const Value: String);
    procedure SetguapaiCBTxt(const Value: String);
    procedure SetxunquanCBTxt(const Value: String);

    procedure SaveCBTxtToUpLoad(FileFolder,FileName,aOperator,aTimeKey:String;TypeFlag: String ='');//DOC091120-sun cb资料查看问题
    procedure SaveCBTxtToUpLoad2(Const aTag,FileFolder,FileName,Operator,aTimeKey:String; TypeFlag:String='');
    procedure SaveCBTxtToUpLoad3(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
    procedure SaveCBTxtToUpLoad4(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
    procedure SaveCBTxtToUpLoad5(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
    procedure SaveCBTxtToUpLoad6(Const FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
    procedure SaveCBTxtToUpLoad7(Const FileFolder,FileName,Operator,aTimeKey:String;TypeFlag,TypeFlag2:String);
    procedure SaveCBTxtToUpLoad8(Const FileFolder,FileName,Operator,aTimeKey:String;TypeFlag,TypeFlag2:String);
    procedure SaveCBTxtToUpLoad9(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
  public
      function CreateEmptycbstopconvdat(aInputFile:string):Boolean;override;
      function ProSep_cbstopconv(aFtpXiaShi,aFtpNotXiaShi:boolean): string;override;
      function ProSepPassHis_cbstopconv(aExtractYear:string):string;override;

      function LoaclDatDir():string;override;
      procedure SetPassawayCBText(const Value: String);
      Function GetDateStkIndustryTFN(FileName:String):String;
      Function GetDateStkIndustryDifTFN(FileName:String):String;
      Function GetDatecbbaseinfo(FileName:String):String;
      Function GetDatecbbaseinfoOfWeek(FileName:String):String;
      Function GetDatecloseidlist(FileName:String):String;
      Function closeidlistComapre(aCloseidListFile,aDateBaseInfoFile,aTr1BaseInfoFile:String):string;
      Function GetDatecloseidlistEx(FileName:String):String;
      Function GetWeekOfcloseidlist(FileName:String):String;
      Function GetWeekOfcloseidlistEx(FileName:String):String;

      Function GetDateStkBase1TFN(FileName:String):String;
      Function GetDateStockweight(FileName:String):String;
      Function GetLogStockweight(FileName:String):String;
      Function GetLogcbbaseinfo(FileName:String):String;
      
      Function GetDateStkBase1DifTFN(FileName:String):String;
      Function GetADocRtfFileName(FileName:String):String;
      Function GetADocTextFileName(FileName:String):String;
      Function GetADoc2TextFileName(FileName:String):String;
      Function SetCBDataText(Const FileName,Value,aOperator,aTimeKey :String):String;
      function SetCBBaseInfoIdListIsOk:Boolean;
      Function SetCBDataTextFileName(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
      Function SetCBDataUpload(Const aOperator,aTimeKey,DstFileName:String):Boolean;
      Function SetTCRIUploadWork(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
      Function SetTCRITFN(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
      Function SetIFRSTFN(aCode:string;aYear,aQ:integer;aOperator,aTimeKey:string):Boolean;
      Function Setstockweight(aUptFiles:TStringList;aDstDatPath,aOperator,aTimeKey:string):Boolean;
      Function SetCBDataTextFileName_10(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
      function SetNodeUpload(const aOperator,aTimeKey: String):boolean;
      //--DOC4.4.0.0   pqx 20120208
      procedure Strike4ConvToResetLst(aOperator,aTimeKey:string);
      //---
      procedure ResetLstConvToStrike2(aOperator,aTimeKey:string);
      Function SetCBTodayHintTextFileName(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;

      Function SetCBThreeTraderFileName(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
      Function SetCBBalanceDatFileName(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
      procedure ModifyThreeTraderLst(aFileName,aDate:String);//add by wangjinhua ThreeTrader 091015
      procedure ModifyDealerLst(aFileName,aDate:String);
      procedure SetCBDataLog(Const AppName,FileName,UpLoadCBFileName,aOperator,aTimeKey:String;
        FtpServerCount:Integer=1;FtpServerName:String='';TypeFlag:string ='');
      function FinishUploadCBDataByLog(FileName,UpLoadCBFileName:String;FtpServerCount:Integer):Boolean;
      Function GetIFRSOpLog(sDateS,aDateE,aDstFile:String):boolean;
      Function GetIFRSTr1dbData(aYear,aQ,aCode,aTr1dbDatPath,aDstFile1,aDstFile2,aDstFile3:String):boolean;

      function ConvertcbidxTocbidx3:string;
      function ConvertCbidx2ToCbidx():Boolean;
      function ConvertStrike32ToStrike3():Boolean;
      function ProAfterNodeChanged(aRefreshExceptList,aRefreshShangShiCodeList:boolean;
         aFtpXiaShi,aFtpNotXiaShi:boolean;aOperator,aTimeKey:string):boolean;

      property NifaxingCBText:String Read GetNifaxingCBText Write SetNifaxingCBText;
      property PassCBText:String Read GetPassCBText Write SetPassCBText;
      property HushiCBText:String Read GetHushiCBText Write SetHushiCBText;
      property ShenshiCBText:String Read GetShenshiCBText Write SetShenshiCBText;
      property PassawayCBText:String Read GetPassawayCBText Write SetPassawayCBText;
      property StopCBText:String Read GetStopCBText Write SetStopCBText;
      property shangguiCBText:String Read GetshangguiCBText write SetshangguiCBTxt;
      property shangshiCBText:String Read GetshangshiCBText write SetshangshiCBTxt;
      property SongCBText:String Read GetSongCBText write SetSongCBTxt;
      property guapaiCBText:String Read GetguapaiCBText write SetguapaiCBTxt;
      property xunquanCBText:String Read GetxunquanCBText write SetxunquanCBTxt;
  End;

  TCBDataMgrEcb = Class(TCBDataMgrBase)
  private
    function GetNifaxingCBText: String;
    procedure SetNifaxingCBText(const Value: String);
    function GetPassCBText: String;
    procedure SetPassCBText(const Value: String);
    function GetPassawayCBText: String;
    function GetStopCBText: String;
    procedure SetStopCBText(const Value: String);

    function GetshangguiCBText: String;
    function GetshangshiCBText: String;
    function GetSongCBText: String;
    function GetguapaiCBText: String;
    function GetxunquanCBText: String;
    procedure SetshangguiCBTxt(const Value: String);
    procedure SetSongCBTxt(const Value: String);
    procedure SetguapaiCBTxt(const Value: String);
    procedure SetxunquanCBTxt(const Value: String);

    procedure SaveCBTxtToUpLoad(FileFolder,FileName,aOperator,aTimeKey:String;TypeFlag: String ='');
    procedure SaveCBTxtToUpLoadRateData(FileFolder,FileName,aOperator,aTimeKey:String;TypeFlag: String ='');
    procedure SaveCBTxtToUpLoad3(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
    procedure SaveCBTxtToUpLoad9(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
    procedure SaveCBTxtToUpLoad9RateData(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
  public
      function CreateEmptycbstopconvdat(aInputFile:string):Boolean;override;
      function ProSep_cbstopconv(aFtpXiaShi,aFtpNotXiaShi:boolean): string;override;
      function ProSepPassHis_cbstopconv(aExtractYear:string):string;override;
      
      function LoaclDatDir():string;override;
      procedure SetPassawayCBText(const Value: String);

      Function SetCBDataText(Const FileName,Value,aOperator,aTimeKey :String):String;
      Function SetCBDataTextFileName(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
      Function SetCBDataUpload(Const aOperator,aTimeKey,DstFileName:String):Boolean;
      function SetNodeUpload(const aOperator,aTimeKey: String):boolean;

      procedure SetCBDataLog(Const AppName,FileName,UpLoadCBFileName,aOperator,aTimeKey:String;
        FtpServerCount:Integer=1;FtpServerName:String='';TypeFlag:string ='');
      function FinishUploadCBDataByLog(FileName,UpLoadCBFileName:String;FtpServerCount:Integer):Boolean;

      function ProAfterNodeChanged(aRefreshExceptList,aRefreshShangShiCodeList:boolean;
         aFtpXiaShi,aFtpNotXiaShi:boolean;aOperator,aTimeKey:string):boolean;
      Function SetECBRate(aEcbRatePath,aOperator,aTimeKey,sCmd:string):Boolean;

      procedure SetshangshiCBTxt(const Value: String);
      property NifaxingCBText:String Read GetNifaxingCBText Write SetNifaxingCBText;
      property PassCBText:String Read GetPassCBText Write SetPassCBText;
      property PassawayCBText:String Read GetPassawayCBText Write SetPassawayCBText;
      property StopCBText:String Read GetStopCBText Write SetStopCBText;
      property shangguiCBText:String Read GetshangguiCBText write SetshangguiCBTxt;
      property SongCBText:String Read GetSongCBText write SetSongCBTxt;
      property guapaiCBText:String Read GetguapaiCBText write SetguapaiCBTxt;
      property xunquanCBText:String Read GetxunquanCBText write SetxunquanCBTxt;
  End;

  //--Doc3.2.0需求3 huangcq080928 add--------------------->
  TDocManualMgr =class
  private
    FOutPutDataPath :String;
    FOutPutHtmlPath :String;
    FDwnTitleTxtPath :String;
    FDwnFailTitleTxtPath :String;
    FManualLogPath :String;
    FManualBackupTmpFilePath :String;
    FTempDocFileName :String;
    FTempTag :String; //Doc_01 Doc_02 Doc_03
    FDelBackupTmpLogName:String;//删除tmp备份文件的日志文件名

    FTitle : String;
    FID : String;
    FDate : TDate;
    FURL : String;
    FSaveTime:String;

    FNewDocTmpFileName:String; //是全路径,新的tmp文件名将用于备份
    FDocBackupTmpFileName:String; //最终备份的文件名， Data\下的文件在审核之后会别删除,但备份的没有被删除，可能出现同名的
    Function GetNewDocTmpFileName():String;
    Function SaveToDocTmpFile(ManualDocTxtLst:TStringList):Boolean;
    Function SaveToDocBackupTmpFile():Boolean;

    function GetSection(Var StratIndex: Integer;const f: TStringList; const Section: String): String;
    procedure SetText(const Value: String);//

    Function SetDwnTitleTxt():Boolean;
    Function SetDwnFailTitleTxt():Boolean;
    Function SetTitleTxt(Const AID,ATitle,AIDTitleFileName:String;ATxtDate:TDate):Boolean;

    Function SetIdxFile():Boolean;

    Function SetManualLogText():Boolean;

    Procedure ClearTheSuccessDelTmpFileLog();
    Function GetTheDelTmpFileList(BeginAndEndDate:String):Boolean;
    Function GetDelFileLstByBeginEndDate(BeginAndEndDate:String):Boolean;
    Function GetDelFileLstByAuto():Boolean;
    Function DelByTheTmpFileList():Boolean;
    Function AddTmpToFileList(ManualLogFile:String):Boolean;
  public
    Constructor Create(Const TempDocFileName:string;Const DocDataPath:String);
    //Destructor Destroy; Override;

    Function SetDocManual(ManualDocTxtLst:TStringList):Boolean;
    Function GetManualLogText(pLogName:String):String;
    Function ReturnNewManualLogText():String; //该函数返回新增公告而更新的Log对应记录
    Function GetManualBackupTmpFile(pTmpFileName:String):String;

    Function DelManualBackupTmpFile(BeginAndEndDate:String):String;
    Function ReturnTheDelTmpFileLog():String; 
    //Property Title : String read FTitle Write FTitle;
    //Property ID : String read FID Write FID;
    //Property Date : TDate read FDate Write FDate;
    //Property URL : String read FURL Write FURL;
  end;
  //<--Doc3.2.0需求3 huangcq080928 add---------------------  

  Function GetItemIndex({ID:String;}IDLst:TListBox):Integer;
  function InRightList(AComponentName:String):Boolean;//add by wangjinhua 20090602 Doc4.3
  procedure ChrConvert(var ASource:String);
Var
  FAppParam: TDocMgrParam=nil;
  FAppParamEcb: TDocMgrParam=nil;
  F_SearchID:String;
implementation

const _TryCpyTimes=15;
function TryToCopyFile(aTmpFile,aDstFileName:string;TryTimes:integer):boolean;
var i:integer;
begin
  result:=false;
  if not FileExists(aTmpFile) then
    exit;
  for i:=1 to TryTimes do
  begin
    if CopyFile(PChar(aTmpFile),PChar(aDstFileName),false) then
    begin
      result:=true;
      break;
    end;
    SleepWait(1);
    //Sleep(1000);
  end;
end;

function GetCancelLogFile(aLogFile:string):string;
var sPath,sName:string;
begin
  result:=aLogFile;
  result:=StringReplace(result,'.log','Cancel.log',[rfReplaceAll,rfIgnoreCase]);
  result:=StringReplace(result,'CancelCancel','Cancel',[rfReplaceAll,rfIgnoreCase]);
end;

function DelDocDatInLog(aLogFile,aGuid:string):boolean;
var i,j,iLineS,iLineE:integer;
  sLine,sTemp1,sTemp2:string;
  ts:TStringList;
begin
  result:=false;
  if aGuid='' then
    exit;
  if not FileExists(aLogFile) then
    exit;
  ts:=TStringList.create;
  try
    ts.LoadFromFile(aLogFile);
    if Pos(aGuid,ts.text)<=0 then
      exit;
    iLineS:=-1;
    iLineE:=-1;
    for i:=0 to ts.count-1 do
    begin
      Application.ProcessMessages;
      sLine:=Trim(ts[i]);
      if Pos('<ID=',sLine)=1 then
        iLineS:=i;
      if SameText(sLine,'<GUID>') then
      begin
        if (i+1<ts.count) and
           (SameText(ts[i+1],aGuid)) then
        begin
          for j:=i+1 to ts.Count-1 do
          begin
            if Pos('</ID>',ts[j])=1 then
            begin
              iLineE:=j;
              Break;
            end;
          end;
          break;
        end;
      end;
    end;
    if (iLineS<>-1) and (iLineE<>-1) then
    begin
      for i:=iLineS to iLineE do
        ts.Delete(iLineS);
      ts.SaveToFile(aLogFile);
      result:=true;
    end;
  finally
    try if Assigned(ts) then FreeAndNil(ts); except end;
  end;
end;

function AddDocDatInLog(aLogFile,aDocDatText,aGuid:string):boolean;
var i,j:integer;
  ts:TStringList;
begin
  result:=false;
  if aGuid='' then
    exit;
  if aDocDatText='' then
    exit;
  ts:=TStringList.create;
  try
    if FileExists(aLogFile) then
      ts.LoadFromFile(aLogFile);
    if Pos(aGuid,ts.text)>0 then
    begin
      Exit;
    end;
    ts.Add(aDocDatText);
    ts.SaveToFile(aLogFile);
    result:=true;
  finally
    try if Assigned(ts) then FreeAndNil(ts); except end;
  end;
end;

function DelDocInIdx(aIdxFile,aTitle:string;aDate:TDate;aDelDoc:Boolean):boolean;
var i,j,iLineS,iLineE:integer;
  sLine,sTemp1,sTemp2,sItemLine,sDelIdxFile:string;
  ts:TStringList; bChange:Boolean;
begin
  result:=false;
  if aTitle='' then
    exit;
  if not FileExists(aIdxFile) then
    exit;
  ts:=TStringList.create;
  try
    ts.LoadFromFile(aIdxFile);
    sItemLine:=aTitle+'/'+FormatDateTime('yyyy-mm-dd',aDate);
    if aDelDoc then
      sItemLine:='[D]'+sItemLine;
    if Pos(sItemLine,ts.text)<=0 then
      exit;
    bChange:=false;
    i:=0;
    while i<ts.count do
    begin
      Application.ProcessMessages;
      if SameText(ts[i],sItemLine) then
      begin
        ts.delete(i);
        bChange:=true;
        continue;
      end
      else begin
        Inc(i);
      end;
    end;
    if bChange then
    begin
      ts.SaveToFile(aIdxFile);
    end;

    if aDelDoc then
    begin
      sTemp1:=ExtractFilePath(aIdxFile);
      sTemp2:=ExtractFileName(aIdxFile);
      sDelIdxFile:=sTemp1+ChangeFileExt(sTemp2,'Del.txt');
      ts.Clear;
      if FileExists(sDelIdxFile) then
      begin
        ts.LoadFromFile(sDelIdxFile);
        sItemLine:='<Doc='+aTitle+'/'+FormatDateTime('yyyymmdd',aDate)+'>';

        iLineS:=-1;
        iLineE:=-1;
        for i:=0 to ts.count-1 do
        begin
          Application.ProcessMessages;
          sLine:=(ts[i]);
          if SameText(sItemLine,sLine) then
          begin
            iLineS:=i;
            for j:=i+1 to ts.Count-1 do
            begin
              if SameText('</Doc>',ts[j]) then
              begin
                iLineE:=j;
                Break;
              end;
            end;
            break;
          end;
        end;
        if (iLineS<>-1) and (iLineE<>-1) then
        begin
          for i:=iLineS to iLineE do
            ts.Delete(iLineS);
          if SameText(ts.Text,'') then
            DeleteFile(sDelIdxFile)
          else
            ts.SaveToFile(sDelIdxFile);
        end;
      end;
    end;
    result:=true;
  finally
    try if Assigned(ts) then FreeAndNil(ts); except end;
  end;
end;

//add by wangjinhua 20090602 Doc4.3
function InRightList(AComponentName:String):Boolean;
var
  j:Integer;
begin
  Result := false;
  if not Assigned(FAppParam) then
    exit;
  with FAppParam do
  begin
    for j := 0 to UserMngBtnKeyWordListCount - 1 do
      if SameText(UserMngBtnKeyWordList[j],AComponentName) then
      begin
        Result := true;
        break;
      end;
  end;
end;
//--

//add by wangjinhua Doc20090306
function EnCodeTheDateTime(ADate:TDate;ATime:TTime):String;
var
  ADateTime:TDateTime;
  Year,Month,Day : Word;
  H,M,S,MS : Word;
begin
  Result := '';
  DeCodeTime(ATime,H,M,S,MS);
  DeCodeDate(ADate,Year,Month,Day);
  ADateTime := EncodeDateTime(Year,Month,Day,H,M,S,MS);
  Result := DateTimeToStr(ADateTime);
end;


function GetAFileName(Suf:ShortString):ShortString;
var
  i:Integer;
  AppPath,tmpFile:ShortString;
begin
  AppPath := ExtractFilePath(ParamStr(0)) + 'Data\';
  i := 1;
  tmpFile := AppPath + Suf + IntToStr(i) + '.txt';
  while FileExists(tmpFile) do
  begin
    Inc(i);
    tmpFile := AppPath + Suf + IntToStr(i) + '.txt';
  end;
  Result := tmpFile;
end;
//--

{ TIDLstMgr }


constructor TIDLstMgr.Create(const IDListPath: String;TxtFileScope_MP: TxtFileScope_MP);//---Doc3.2.0需求1 huangcq080923 modify
begin
   FIDList := TList.Create;
   FIDListPath := IDListPath;
   FTxtFileScope :=TxtFileScope_MP;//---Doc3.2.0需求1 huangcq080923 add
   InitData;
end;

constructor TIDLstMgr.Create2(const IDListPath: String;TxtFileScope_MP: TxtFileScope_MP);//---Doc3.2.0需求1 huangcq080923 modify
begin
   FIDListPath := IDListPath;
   FTxtFileScope :=TxtFileScope_MP;//---Doc3.2.0需求1 huangcq080923 add
end;

constructor TIDLstMgr.Create3(const IDListPath: String;TxtFileScope_MP: TxtFileScope_MP);//---Doc3.2.0需求1 huangcq080923 modify
begin
   FIDList := TList.Create;
   FIDListPath := IDListPath;
   FTxtFileScope :=TxtFileScope_MP;//---Doc3.2.0需求1 huangcq080923 add
end;

constructor TIDLstMgr.Create4(const IDListPath: String;TxtFileScope_MP: TxtFileScope_MP);//---Doc3.2.0需求1 huangcq080923 modify
begin
   FIDList := TList.Create;
   FIDListPath := IDListPath;
   FTxtFileScope :=TxtFileScope_MP;//---Doc3.2.0需求1 huangcq080923 add
   InitData2;
end;

constructor TIDLstMgr.Create5(const IDListPath: String;TxtFileScope_MP: TxtFileScope_MP);
begin
   FIDList := TList.Create;
   FIDListPath := IDListPath;
   FTxtFileScope :=TxtFileScope_MP;//---Doc3.2.0需求1 huangcq080923 add
   InitData3;
end;

destructor TIDLstMgr.Destroy;
begin

  While FIDList.Count>0 do
  Begin
     FreeMem(FIDList.Items[0]);
     FIDList.Delete(0);
  End;
  FIDList.Free;

  inherited;
end;

function TIDLstMgr.GetCBIDItems(Index: Integer): String;
Var
  AID : PDocID;
begin

   AID := FIDList.Items[index];
   Result := AID.CBID;

end;

function TIDLstMgr.GetCBNameItems(Index: Integer): String;
Var
  AID : PDocID;
begin

   AID := FIDList.Items[index];
   Result := AID.CBName;

end;

function TIDLstMgr.GetCBStatusItems(Index: Integer): String;
Var
  AID : PDocID;
begin

   AID := FIDList.Items[index];
   Result := LowerCase(AID.CBStatus);

end;

function TIDLstMgr.GetID(Index: Integer): PDocID;
begin
   Result := FIDList.Items[index];
end;

function TIDLstMgr.GetIDCount: Integer;
begin
   Result := FIDList.Count;
end;

function TIDLstMgr.GetIDItems(Index: Integer): String;
Var
  AID : PDocID;
begin
   AID := FIDList.Items[index];
   Result := AID.ID;
end;

procedure TIDLstMgr.InitData;
Var
  i,j : Integer;
  ID,CBID,MEM,Status : String;
  fileLst : _cStrLst;
  FilePath : String;
  aInifile : TiniFile;
  AFileAgeStr : String;
begin

    SetLength(FileLst,0);
    {
    FilePath := FIDListPath + 'CBData\market_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);

    FilePath := FIDListPath + 'CBData\publish_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);
    } //---Doc3.2.0需求1 huangcq080923 del
    FilePath := FIDListPath + 'CBData\';  //---Doc3.2.0需求1 huangcq080923 add
    GetTxtFilesFromDblst(FilePath,FileLst,FTxtFileScope); //---Doc3.2.0需求1 huangcq080923 add

    AFileAgeStr := '';
    For i:=0 to High(fileLst) do
    Begin
       if FileExists(fileLst[i]) Then
          AFileAgeStr := AFileAgeStr+IntToStr(FileAge(fileLst[i]));
    End;
    if AFileAgeStr= FileAgeStr Then
       Exit;
    FileAgeStr := AFileAgeStr;

    For i:=0 to High(fileLst) do
    Begin
       if FileExists(fileLst[i]) Then
       Begin
           j := 0;
           aInifile := Tinifile.Create(fileLst[i]);
           While True do
           Begin
             Application.ProcessMessages;
             Sleep(10);
             CBID := aIniFile.ReadString('BASE'+IntToStr(j),'TRADECODE','NONE');
             MEM  := aIniFile.ReadString('BASE'+IntToStr(j),'MEM','');
             Status :=  LowerCase(ExtractFileName(fileLst[i]));
             ReplaceSubString('.txt','',Status);
             if CBID='NONE' Then Break;
             SetAID(CBID,CBID,MEM,Status);
             ID := aIniFile.ReadString('BASE'+IntToStr(j),'STKCODE','');
             SetAID(ID,CBID,MEM,Status);
             j:=j+1;
           End;
           aIniFile.Free;
       End;
    End;
    SstIDDocStartDate;
end;

procedure TIDLstMgr.InitData2;
Var
  i,j : Integer;
  ID,CBID,MEM,Status : String;
  fileLst : _cStrLst;
  FilePath : String;
  aInifile : TiniFile;
  AFileAgeStr : String;
begin

    SetLength(FileLst,0);
    {
    FilePath := FIDListPath + 'CBData\market_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);

    FilePath := FIDListPath + 'CBData\publish_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);
    } //---Doc3.2.0需求1 huangcq080923 del
    FilePath := FIDListPath + 'CBData\';  //---Doc3.2.0需求1 huangcq080923 add
    GetTxtFilesFromDblst(FilePath,FileLst,FTxtFileScope); //---Doc3.2.0需求1 huangcq080923 add

    AFileAgeStr := '';
    For i:=0 to High(fileLst) do
    Begin
       if FileExists(fileLst[i]) Then
          AFileAgeStr := AFileAgeStr+IntToStr(FileAge(fileLst[i]));
    End;
    if AFileAgeStr= FileAgeStr Then
       Exit;
    FileAgeStr := AFileAgeStr;

    For i:=0 to High(fileLst) do
    Begin
      if FileExists(fileLst[i]) Then
      Begin
        j := 0;
        aInifile := Tinifile.Create(fileLst[i]);
        While True do
        Begin
          Application.ProcessMessages;
          Sleep(10);
          CBID := aIniFile.ReadString('BASE'+IntToStr(j),'TRADECODE','NONE');
          MEM  := aIniFile.ReadString('BASE'+IntToStr(j),'MEM',''); 
          Status :=  LowerCase(ExtractFileName(fileLst[i]));
          ReplaceSubString('.txt','',Status); 
          if CBID='NONE' Then Break;
          SetAID(CBID,CBID,MEM,Status);   
          {ID := aIniFile.ReadString('BASE'+IntToStr(j),'STKCODE','');
          SetAID(ID,CBID,MEM,Status);  }
          j:=j+1;
        End;
        aIniFile.Free; 
      End;
    End;
    SstIDDocStartDate;
end;

procedure TIDLstMgr.InitData3;
Var
  i,j : Integer;
  ID,CBID,MEM,Status : String;
  fileLst : _cStrLst;
  FilePath : String;
  aInifile : TiniFile;
  AFileAgeStr : String;
begin
    SetLength(FileLst,0);
    FilePath := FIDListPath + 'CBData\';
    GetTxtFilesFromDblst(FilePath,FileLst,FTxtFileScope);
    AFileAgeStr := '';
    For i:=0 to High(fileLst) do
    Begin
       if FileExists(fileLst[i]) Then
          AFileAgeStr := AFileAgeStr+IntToStr(FileAge(fileLst[i]));
    End;
    if AFileAgeStr= FileAgeStr Then
       Exit;
    FileAgeStr := AFileAgeStr;

    For i:=0 to High(fileLst) do
    Begin
      if FileExists(fileLst[i]) Then
      Begin
        j := 0;
        aInifile := Tinifile.Create(fileLst[i]);
        While True do
        Begin
          Application.ProcessMessages;
          Sleep(10);
          CBID := aIniFile.ReadString('BASE'+IntToStr(j),'StkCode','NONE');
          MEM  := CBID;
          Status :=  LowerCase(ExtractFileName(fileLst[i]));
          ReplaceSubString('.txt','',Status);
          if CBID='NONE' Then Break;
          SetAID(CBID,CBID,MEM,Status);
          j:=j+1;
        End;
        aIniFile.Free; 
      End;
    End;
end;

procedure TIDLstMgr.Refresh;
begin
  InitData;
end;

procedure TIDLstMgr.SetAID(const ID,CBID,CBNAME,CBStatus: String);
Var
  AID : PDocID;
  i : Integer;
begin

   if Length(ID)=0 Then Exit;

   for i:=0 to FIDList.Count-1 do
   Begin
       AID := FIDList.Items[i];
       if AID.ID=ID Then exit;
   End;

   New(AID);
   AID.ID    := ID;
   AID.CBID  := CBID;
   AID.CBNAME  := CBNAME;
   AID.CBStatus  := CBStatus;
   AID.Date1 := 0;
   FIDList.Add(AID);

end;

procedure TIDLstMgr.SstIDDocStartDate;
{Var
  f : TiniFile;
  AID : PDocID;
  i : Integer;
  StrDate:String;
  Year,Day,Month : Word;
  StrLst : _cStrLst;
  }
begin

Exit;

{ f := TIniFile.Create(FIDListPath + 'CBData\Data\date.dat');
Try

 For i:=0 to FIDList.Count-1 do
 Begin
   Application.ProcessMessages;
   AID := FIDList.Items[i];
   StrDate := f.ReadString('Date',AID.ID,'');
   StrLst := DoStrArray(StrDate,',');
   StrDate := '';
   if High(StrLst)=2 Then
      StrDate := StrLst[0];
   if Length(StrDate)=8 Then
      if IsInteger(PChar(StrDate)) Then
      Begin
          Year := StrToInt(Copy(StrDate,1,4));
          Day := StrToInt(Copy(StrDate,5,2));
          Month := StrToInt(Copy(StrDate,7,2));
          AID.Date1 := EncodeDate(Year,Month,Day);
      End;
 End;

Finally
 f.Free;
end;
}

end;

{ TRunHttp }

constructor TRunHttp.Create(HTTP: TIdHTTP; URL: String);
begin
   FHTTP := HTTP;
   FURL := URL;
   RefreshTimeOut;//初始化TimeOut
   FreeOnTerminate := false;
   inherited Create(true);
end;

destructor TRunHttp.Destroy;
begin
  //inherited;
end;

procedure TRunHttp.Execute;
begin
  //inherited;

  RunHttp;

end;

function TRunHttp.GetHaveRunFinish: Boolean;
begin
  Result := FHaveRunFinish;

  {//如果超過連線時間
  if Not Self.Terminated Then
  Begin
    //如果時間太久就自動斷線
    if FHTTP.Connected  Then
    Begin
      if GetTimeOut Then
      Begin
       Try
         FHTTP.Disconnect;
         FHTTP.DisconnectSocket;
       Except
       End;
        RefreshTimeOut;
      End;
    End;
  End;
  }
end;

function TRunHttp.GetTimeOut: Boolean;
begin
    Result := GetTickCount>FTimeOut;
end;

procedure TRunHttp.RefreshTimeOut;
begin
   FTimeOut := GetTickCount+30000;
end;

procedure TRunHttp.RunHttp;
Var
  i : integer;
begin
    //RefreshTimeOut;
    FHaveRunFinish := false;
    FResultString := '';
Try
    SleepWait(3);
    if Self.Terminated Then exit;

    Try
      FHTTP.Disconnect;
      FHTTP.DisconnectSocket;
    Except
    End;

    for i:=0 to 3 do
    Begin
      try
         //RefreshTimeOut; //設定Get資料一段時間後,一直無反應就需中斷重新連線
         FResultString := FHTTP.Get(FUrl);
         FRunErrMsg := '';
         if Self.Terminated Then exit;
         Break;
      Except
        On E:Exception do
        Begin
           {try
             FHTTP.Disconnect;
             FHTTP.DisconnectSocket;
           Except
           End; }
           FRunErrMsg := E.Message;
           SleepWait(3);
           if Pos('404 Not Found',FRunErrMsg)>0 Then
           Begin
              FResultString := '404 Not Found';
              Exit;
           End;
           if Self.Terminated Then exit;
         End;
      end;
    End;

    if Length(FRunErrMsg)>0 Then
       FResultString := '';
   { if Length(FResultString)>0 then
      begin
        showmessage(inttostr(Length(FResultString))+'ok');
        //SaveMsg(FRunErrMsg)
      end
    else
      showmessage(FUrl+'bad') ;  }

Finally
   Try
      FHTTP.Disconnect;
      FHTTP.DisconnectSocket;
   Except
   End;
   FHaveRunFinish := True;
   Application.ProcessMessages;
End;

end;

procedure TRunHttp.SleepWait(const Value: Double);
Var
  iEndTick : DWord;
begin

     iEndTick := GetTickCount + Round(Value*1000);
     repeat
          if Self.Terminated Then exit;
          Application.ProcessMessages;
     until GetTickCount >= iEndTick;


end;



procedure ChrConvert(var ASource:String);
const
  KeyStr1='<meta';
  KeyStr2='charset=';
var
  i,j,iPos:Integer;
  ts:TStrings;
  vItem,vChrType:String;
begin
  ts:=TStringList.Create;
try
  ts.Text:=ASource;
  for i:=0 to ts.Count-1 do
  begin
    Sleep(5);
    vItem:=ts[i];
    iPos:=Pos(KeyStr2,vItem);
    if (Pos(KeyStr1,vItem)>0) and (iPos>0) then
    begin
      vChrType:='';
      for j:=iPos+Length(KeyStr2) to Length(vItem) do
      begin
        if (vItem[j]='"') or
           (vItem[j]=' ') or
           (vItem[j]='/') or
           (vItem[j]='>') or
           (vItem[j]=Chr(39)) then break;
        vChrType:=vChrType+vItem[j];
      end;
      if SameText(vChrType,'UTF-8') then
        ASource:=Utf8Decode(ASource);
      break;
    end;
  end;
finally
  try
    if Assigned(ts) then
      FreeAndNil(ts);
  except
  end;
end;
end;
{ THttpGet }

procedure SetParam(aParam,aValue:Variant;var aHttp:TIdHttp);
  begin
    if not assigned(aHttp) then exit;
    if SameText(aParam,CReadTimeout) then
    begin
      aHttp.ReadTimeout:=aValue;
    end
    else if SameText(aParam,CConnectTimeout) then
    begin
      //aHttp.ConnectTimeout:=aValue;
    end
    else if SameText(aParam,CUserName) then
    begin
      aHttp.Request.Username:=aValue;
    end
    else if SameText(aParam,CPassword) then
    begin
      aHttp.Request.Password:=aValue;
    end
    else if SameText(aParam,CUserAgent) then
    begin
      aHttp.Request.UserAgent:=aValue;
    end
    else if SameText(aParam,CPServerName) then
    begin
      aHttp.ProxyParams.ProxyServer:=aValue;
    end
    else if SameText(aParam,CPServerPort) then
    begin
      aHttp.ProxyParams.ProxyPort:=aValue;
    end
    else if SameText(aParam,CPServerUserName) then
    begin
      aHttp.ProxyParams.ProxyUsername:=aValue;
    end
    else if SameText(aParam,CPServerPwd) then
    begin
      aHttp.ProxyParams.ProxyPassword:=aValue;
    end;
end;

procedure AddHttpParam(aParam:string;aValue:Variant;aParamType:TParamType;var aParamSet:string);
  procedure AppendToParamSet(aParamStr:string;var aParamSet:string);
  begin
    if aParamSet='' then aParamSet:=aParamStr
    else aParamSet:=aParamSet+CParamSep+aParamStr;
  end;

  function CovertPtToStr(aParamType:TParamType):string;
  begin
    case aParamType of
      ptStr:Result:=CPtStr;
      ptInt:Result:=CPtInt;
      ptBool:Result:=CPtBool;
    end;
  end;

  function CovertValueToStr(aValue:Variant;aParamType:TParamType):string;
  var aInt:integer;
      aBool:Boolean;
  begin
    case aParamType of
      ptStr:Result:=aValue;
      ptInt:begin 
        aInt:=aValue;
        Result:=IntToStr(aInt);
      end;
      ptBool:begin 
        aBool:=aValue;
        Result:=BoolToStr(aBool);
      end;
    end;
  end;
  
begin
  AppendToParamSet(
      Format(CParamFmt,[
             CovertPtToStr(aParamType),
             aParam,
             CovertValueToStr(aValue,aParamType)
      ]),aParamSet);
end;



procedure SetHttpParams(aParamSet:string; var aHttp:TIdHttp);
  function GetParamType(var aInPut:string;var aParamType:TParamType):Boolean;
  begin
    if length(aInput)<4 then
    begin
      Result:=false;
      exit;
    end;
    Result:=true;
    if Pos(Format('(%s)',[CPtStr]),aInput)=1 then aParamType:=ptStr
    else if Pos(Format('(%s)',[CPtInt]),aInput)=1 then aParamType:=ptInt
    else if Pos(Format('(%s)',[CPtBool]),aInput)=1 then aParamType:=ptBool
    else begin
      Result:=false;
      exit;
    end;
    aInput:=Copy(aInput,4,length(aInput)-3);
  end;

  function SetValueByParamType(aInput:string;aParamType:TParamType;var aValue:Variant):Boolean;
  var aInt:integer;
      aBool:Boolean;
  begin
    Result:=false;
    case aParamType of
      ptStr:aValue:=aInput;
      ptInt:begin
              aInt:=StrToInt(aInput);
              aValue:=aInt;
            end;
      ptBool:begin
              aBool:=StrToBool(aInput);
              aValue:=aBool;
            end;
    end;
    Result:=true;
  end;
var ts,ts2:TStringList;
    i:integer;
    aParamType:TParamType;
    aItem:string;
    aValue:Variant;
begin
  if not assigned(aHttp) then exit;
  if Trim(aParamSet)='' then exit;
  ts:=TStringList.Create;
  ts2:=TStringList.Create;
  try
    ts.Delimiter:=CParamSep;
    ts.DelimitedText:=aParamSet;
    for i:=0 to ts.Count-1 do
    begin
      aItem:=ts[i];
      if GetParamType(aItem,aParamType) then
      begin
        ts2.Delimiter:='=';
        ts2.DelimitedText:=aItem;
        if (ts2.count=2) and SetValueByParamType(ts2[1],aParamType,aValue)  then
          SetParam(ts2[0],aValue,aHttp);
      end;
    end;
  finally
    FreeAndNil(ts2);
    FreeAndNil(ts);
  end;
end;


procedure ClsParam(var aHttp:TIdHttp;aClsEvent:Boolean=false);
begin
  if aClsEvent then
  begin
    aHttp.OnStatus:=nil;
    aHttp.OnWork:=nil;
    aHttp.OnWorkBegin:=nil;
    aHttp.OnWorkEnd:=nil;
  end;
  aHttp.ReadTimeout:=CDftReadTimeout;
  aHttp.Request.Clear;
  aHttp.Request.Username:='';
  aHttp.Request.Password:='';
  aHttp.Request.UserAgent:=CDftUserAgent;


  aHttp.ProxyParams.ProxyServer:='';
  aHttp.ProxyParams.ProxyPort:=0;
  aHttp.ProxyParams.ProxyUsername:='';
  aHttp.ProxyParams.ProxyPassword:='';
end;

constructor THttpGet.Create();
begin
   FStop := false;
   FreeOnTerminate := false;
   inherited Create(true);
   FHttpStatusEvent:=nil;
   FHttpWorkEvent:=nil;
   FHttpBeginEvent:=nil;
   FHttpEndEvent:=nil;
   FHttpDownEndEvent:=nil;

   FUrl:='';
   FKey:='';
   FResultString:=TStringList.Create;
   CreateHttp;
end;

destructor THttpGet.Destroy;
begin
  FreeAndNil(FResultString);
  DestroyHttp;
  inherited;
end;


procedure THttpGet.SetInit(aUrl:String;aIndex:integer=-1;aGuid:string='';
           aSaveToFile:string='';aTryErrTimes:integer=3;aHttpParamSet:string='';aTag:string='');
begin
   Stop:=true;
   Stop:=false;
   //FDoneFinish:=false;
   FKey:=IntToStr(aIndex);  //选择index作为关键字 ，可根据实际情况选择其他关键字
   
   FRunErrMsg:='';
   FResultString.Text:='';
   FWorkMax:=0;
   FWorkCurrent:=0;
   FTag:=aTag;
   FURL:=aUrl;
   FIndex:=aIndex;
   FGuid:=aGuid;
   FSaveToFile:=aSaveToFile;
   FTryErrTimes:=aTryErrTimes;
   ClsParam(FHttp);
   SetHttpParams(aHttpParamSet,FHttp);
end;


procedure THttpGet.Execute;
const CWaitForTime=5*60*1000;
var i:integer;
    aTempStr:string;
begin
  //inherited;
  while not Self.Terminated do
  begin
    Sleep(CHttpSleep); application.ProcessMessages; if FStop then  continue;
    //if (not FDoneFinish) and (Trim(FUrl)<>'') then
    if (Trim(FUrl)<>'') then
    begin
      Try
        for i:=1 to 1 do
        Begin
          if FUrl='' then break;
          Sleep(CHttpSleep); application.ProcessMessages; if FStop or Self.Terminated then  break;
          DisconnctHttp;
          try
             DoHttpBegin(FHTTP, wmRead,0);
             DoHttpStatus(FHTTP,hsStatusText,'start get');
             FResultString.Text := FHTTP.Get(FUrl);
             DoHttpStatus(FHTTP,hsStatusText,'end get');
             //FRsCode := FHTTP.ResponseCode;
             FRunErrMsg:='';
             Break;
          Except
            On E:Exception do
            Begin
               DisconnctHttp;
               FRunErrMsg := E.Message;
               if Pos(UpperCase(E404NotFound),UpperCase(FRunErrMsg))>0 Then
               Begin
                  FResultString.Text := E404NotFound;
                  break;
               End;
             End;
          end;
        End;// for i:=1 to FTryErrTimes do
        if Length(FRunErrMsg)>0 Then FResultString.Text := '';
      Finally
        if FUrl<>'' then
        begin
          try
            DisconnctHttp;
          except
          end;
          //DoHttpDownEnd();
          try
            if DoneSuc then
            begin
              aTempStr:=FResultString.Text;
              ChrConvert(aTempStr);
              FResultString.Text:=aTempStr;
            end;
          except

          end;
          FUrl:='';
          DoHttpEnd();
        end;
      End;
    end;
  end;

end;




procedure THttpGet.CreateHttp;
begin
  FHttp:=TidHttp.Create(nil);
  FHttp.ReadTimeout:=CDftReadTimeout;
  FHttp.ConnectTimeout:=CDftConnectTimeout;
  FHttp.OnWork:= DoHttpWork;
  FHttp.OnWorkBegin:=DoHttpBegin;
  //FHttp.OnWorkEnd:=DoHttpEnd;
  FHttp.OnStatus:=DoHttpStatus;
  FHttp.HandleRedirects := True;
  FHttp.Request.UserAgent := CDftUserAgent;
end;

procedure THttpGet.DestroyHttp;
begin
  try
  DisconnctHttp;
  except
  end;
  Try
     if assigned(FHttp) Then
     Begin
        FHttp.OnWork:= nil;
        FHttp.OnWorkBegin:=nil;
        FHttp.OnWorkEnd:=nil;
        FHttp.OnStatus:=nil;
        FreeAndNil(FHttp);
      End;
  Except
  end;
end;


procedure THttpGet.DisconnctHttp;
begin
  Try
     if assigned(FHttp) Then
     begin
       FHttp.DisconnectSocket;
       FHttp.Disconnect;
     end;
  Except
  End;
end;

procedure THttpGet.ClsUrl;
begin
  FUrl:='';
end;

procedure THttpGet.DoHttpStatus(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
begin
  if assigned(FHttpStatusEvent) then
    FHttpStatusEvent(Self,AStatusText,Fkey);
end;

procedure THttpGet.DoHttpWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
  FWorkCurrent:=AWorkCount;
  if assigned(FHttpWorkEvent) then
    FHttpWorkEvent(Self,AWorkCount,FWorkMax,Fkey);
end;


{procedure THttpGet.DoHttpEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  DoHttpEnd();
end;}

procedure THttpGet.DoHttpEnd();
var aDoneSuc:Boolean;
begin
try
try
  aDoneSuc:=DoneSuc;
  if aDoneSuc and ( Trim(FSaveToFile)<>'' ) then
  begin
    FResultString.SaveToFile(Format(FSaveToFile,[Get_GUID8]));
  end;
except
  aDoneSuc:=false;
end;
finally
  if assigned(FHttpEndEvent) then
    FHttpEndEvent(Self,aDoneSuc,Fkey,ResultString);
end;
end;


procedure THttpGet.DoHttpDownEnd();
var aDoneSuc:Boolean;
begin
try
try
  aDoneSuc:=DoneSuc;
  if aDoneSuc and ( Trim(FSaveToFile)<>'' ) then
  begin
    FResultString.SaveToFile(Format(FSaveToFile,[Get_GUID8]));
  end;
except
  aDoneSuc:=false;
end;
finally
  if assigned(FHttpDownEndEvent) then
    FHttpDownEndEvent(Self,aDoneSuc,Fkey,ResultString);
end;
end;

procedure THttpGet.DoHttpBegin(Sender: TObject; AWorkMode: TWorkMode;const AWorkCountMax: Integer);
begin
  FWorkMax:=AWorkCountMax;
  if assigned(FHttpBeginEvent) then
    FHttpBeginEvent(Self,AWorkCountMax,
    Format('%s%s%s%s',[CTagDataBeginFlag,FTag,CTagDataEndFlag,Fkey]) );
end;

function THttpGet.DoneFinish: Boolean;
begin
  //Result := FDoneFinish;
  Result :=Length(FRunErrMsg)=0;
  {//如果超過連線時間
  if Not Self.Terminated Then
  Begin
    //如果時間太久就自動斷線
    if FHTTP.Connected  Then
    Begin
      if GetTimeOut Then
      Begin
       Try
         FHTTP.Disconnect;
         FHTTP.DisconnectSocket;
       Except
       End;
        RefreshTimeOut;
      End;
    End;
  End;
  }
end;


procedure THttpGet.ShowMsg(aMsg:string);
begin
  DoHttpStatus(FHTTP, hsStatusText,aMsg);
end;

function THttpGet.GetIdle:Boolean;
begin
  Result:=FURL='';
end;


procedure THttpGet.SetStop(aValue: Boolean);
begin
  if FStop<>aValue then
  begin
    FStop:=aValue;
    if FStop then
    begin
      if not DoneFinish then FRunErrMsg:=EInterrupt;
      DisconnctHttp;
    end;
  end;
end;

function THttpGet.GetResultString: string;
begin
  Result:=FResultString.Text;
end;

function THttpGet.DoneSuc:Boolean;
begin
  //Result:=(FUrl<>'') and  (FDoneFinish=true) and  (FRunErrMsg='') and (Trim(GetResultString)<>'');
  Result:=(FRunErrMsg='') and (Trim(GetResultString)<>'');
end;

{ TDocData }

constructor TDocData.Create(const Checked : boolean;const Title, ID, DocType:String;
  Const Date:TDate;Const Time:TTime;const Memo:string;const URL:String);
begin

    FGUID := Get_GUID;

    FTitle := Title;
    ReplaceSubString(',','',FTitle);

    FID := ID;
    FCBID := '';
    FCBNAME := '';
    FCBStatus := '';
    FDocType := DocType;
    FDate := Date;
    FTime := Time;
    FMemo := Memo;
    FURL  := URL;

    FOperator:='';
    FOpTime:=0;
    FDocStatus:='';
end;

constructor TDocData.Create(const GUID : String;
                       const Title : String;
                       const ID : String;
                       const Date : TDate;
                       const Time : TTime;
                       const Memo:String;
                       const URL:String;
                       const ATempFileName:String
                       );
begin

    FGUID := GUID;

    FTitle := Title;
    FID := ID;
    FCBID := '';
    FCBNAME := '';
    FCBStatus := '';
    FDocType := '';
    FDate := Date;
    FTime := Time;
    FMemo := Memo;
    FURL  := URL;
    FTempFileName:=ATempFileName;

    FOperator:='';
    FOpTime:=0;
    FDocStatus:='';
end;

constructor TDocData.Create(const Text:String;const ATempFileName:String);
begin
  FTempFileName:=ATempFileName;
  SetText(Text);
end;

constructor TDocData.Create(const Text:String);
begin
   SetText(Text);
end;

constructor TDocData.Create(const GUID, Title, ID: String;
  const Date: TDate; const Time: TTime; const Memo, URL: String);
begin

    FGUID := GUID;

    FTitle := Title;
    FID := ID;
    FCBID := '';
    FCBNAME := '';
    FCBStatus := '';
    FDocType := '';
    FDate := Date;
    FTime := Time;
    FMemo := Memo;
    FURL  := URL;

    FOperator:='';
    FOpTime:=0;
    FDocStatus:='';
end;

destructor TDocData.Destroy;
begin
  inherited;
end;

function TDocData.DocExist(ADoc: TDocData): Boolean;
begin

   Result := false;

   if {(ADoc.ID=FID) and} (DateTimeToStr(ADoc.Date)=DateTimeToStr(FDate))
      and (DateTimeToStr(ADoc.Time)=DateTimeToStr(FTime))
      And (ADoc.Title=FTitle) Then
      Result := True;        


end;

function TDocData.GetDocClass: String;
Var
  ClassTxt : String;
  ClassColor : TColor;
  ClassIndex : Integer;
begin
  GetDocClassTxtAndColor(ClassTxt,ClassColor,ClassIndex);
  Result := ClassTxt;
end;

function TDocData.GetDocClassIndex: Integer;
Var
  ClassTxt : String;
  ClassColor : TColor;
  ClassIndex : Integer;
begin

  GetDocClassTxtAndColor(ClassTxt,ClassColor,ClassIndex);
  Result := ClassIndex;

end;

procedure TDocData.GetDocClassTxtAndColor(var ClassTxt: String;
  var ClassColor: TColor;Var ClassIndex:Integer);
begin

   ClassTxt := '';
   ClassColor := -1;
   ClassIndex := -1;

   if Pos('摘牌',FTitle)>0 Then
   Begin
      ClassTxt := '下市';
      ClassColor := clRed;
      ClassIndex := 0;
   End;


   if (FCBStatus='hushi') or (FCBStatus='shenshi') Then
   Begin

       if (Pos('转股价',FTitle)>0) and (Pos('调整',FTitle)>0) Then
       Begin
         ClassTxt := '转股价('+FCBID+' '+FCBNAME+')';
         ClassColor := clGreen;
         ClassIndex := 1;
      End;

     if ((Pos('第一季',FTitle)>0) and (Pos('报告',FTitle)>0)) or
        (Pos('半年报告',FTitle)>0) or
        ((Pos('年',FTitle)>0) and (Pos('报告',FTitle)>0)) or
        ((Pos('中期',FTitle)>0) and (Pos('报告',FTitle)>0)) or
        ((Pos('第二季',FTitle)>0) and (Pos('报告',FTitle)>0)) or
        ((Pos('第二季',FTitle)>0) and (Pos('报告',FTitle)>0)) or
        (Pos('股份变动',FTitle)>0) Then
     Begin
        ClassTxt := '转股余额('+FCBID+' '+FCBNAME+')';
        ClassColor := clBlue;
        ClassIndex := 2;
     End;

     {if ((Pos('可转债',FTitle)>0) or (Pos('可转换公司债',FTitle)>0))
        and (Pos('中签',FTitle)>0) Then
     Begin
        ClassTxt := '中签率('+FCBID+' '+FCBNAME+')';
        ClassColor := clFuchsia;
        ClassIndex := 5;
     End;
      }
   End;

   if Pos('未通过',FTitle)>0 Then
   Begin
      ClassTxt := '停止发行';
      ClassColor := clteal;
      ClassIndex := 3;
   End;

   if ((Pos('可转债',FTitle)>0) and (Pos('发行',FTitle)>0)) or
      ((Pos('可转换公司债',FTitle)>0) and (Pos('发行',FTitle)>0)) or
      ((Pos('可转债',FTitle)>0) and (Pos('募集',FTitle)>0)) or
      ((Pos('可转换公司债',FTitle)>0) and (Pos('募集',FTitle)>0)) or
      ((Pos('可转债',FTitle)>0) and (Pos('上市',FTitle)>0)) or
      ((Pos('可转换公司债',FTitle)>0) and (Pos('上市',FTitle)>0)) or
      ((Pos('可转债',FTitle)>0) and (Pos('中签',FTitle)>0)) or
      ((Pos('可转换公司债',FTitle)>0) and (Pos('中签',FTitle)>0)) or
      ((Pos('可转债',FTitle)>0) and (Pos('发行结果',FTitle)>0)) or
      ((Pos('可转换公司债',FTitle)>0) and (Pos('发行结果',FTitle)>0)) Then
   Begin
      ClassTxt := '通过上市';
      ClassColor := clMaroon;
      ClassIndex := 4;
   End;


end;

function TDocData.GetDocColor: TColor;
Var
  ClassTxt : String;
  ClassColor : TColor;
  ClassIndex : Integer;
begin
  GetDocClassTxtAndColor(ClassTxt,ClassColor,ClassIndex);
  Result := ClassColor;

end;

function TDocData.GetFmtDate: String;
begin
   Result := FormatDateTime('yyyy-mm-dd',FDate);
end;


function TDocData.GetFmtDateTime: String;
begin
   Result := FormatDateTime('yyyy-mm-dd',FDate)+' '+
             FormatDateTime('hh:mm:ss',FTime);
end;

function TDocData.GetSection(Var StratIndex: Integer;
  const f: TStringList; const Section: String): String;
Var
     i : integer;
     s,ts : String;
Begin
         ts := '';
         For i:=StratIndex+1 to f.Count-1 do
         Begin
                s := f.Strings[i];
                if Pos(Section,UpperCase(S))>0 Then
                Begin
                   StratIndex := i;
                   Break;
                End;
                if Length(ts)>0 Then
                   ts := ts + #13#10;
                ts := ts + s ;
         End;
         Result := ts;

end;

function TDocData.GetText: String;
Var
  f : TStringList;
begin

     f:=TStringList.Create;

     f.Add('<ID='+ID+'>');
     f.Add('<GUID>');
     f.Add(GUID);
     f.Add('</GUID>');
     f.Add('<DOCID>');
     f.Add(DOCID);
     f.Add('</DOCID>');
     f.Add('<CBID>');
     f.Add(CBID);
     f.Add('</CBID>');
     f.Add('<CBSTATUS>');
     f.Add(CBSTATUS);
     f.Add('</CBSTATUS>');
     f.Add('<CBNAME>');
     f.Add(CBNAME);
     f.Add('</CBNAME>');
     f.Add('<URL>');
     f.Add(URL);
     f.Add('</URL>');
     f.Add('<Title>');
     f.Add(Title);
     f.Add('</Title>');
     f.Add('<DocType>');
     f.Add(DocType);
     f.Add('</DocType>');
     f.Add('<Date>');
     f.Add(FloatToStr(Date));
     f.Add('</Date>');
     f.Add('<Time>');
     f.Add(FloatToStr(Time));
     f.Add('</Time>');
     f.Add('<Memo>');
     f.Add(Memo);
     f.Add('</Memo>');


     f.Add('<Operator>');
     f.Add(Operator);
     f.Add('</Operator>');
     f.Add('<OpTime>');
     f.Add(FloatToStr(OpTime));
     f.Add('</OpTime>');
     f.Add('<DocStatus>');
     f.Add(DocStatus);
     f.Add('</DocStatus>');
     
     f.Add('</ID>');

     Result := f.Text;

     f.Free;


end;

function TDocData.SaveToDataBase(const DBFileName: String): Boolean;
Var
  aTbl : TAdoTable;
Begin

  Result := False;

  if Not FileExists(DBFileName) Then exit;

  aTbl := TADoTable.Create(nil);
  aTbl.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+
                           DBFileName+
                           ';Jet OLEDB:Database Password=tr1';;

  aTbl.TableName := 'DocData';
  aTbl.Open;
  aTbl.Append;

  aTbl.FieldValues['DocGUID']    := GUID;
  aTbl.FieldValues['DocStkID']   := ID;
  aTbl.FieldValues['DocTitle']   := Title;
  aTbl.FieldValues['DocDate']    := Date ;
  aTbl.FieldValues['DocTime']    := Time;
  aTbl.FieldValues['DocURL']     := URL;
  aTbl.FieldValues['DocMemo']    := Memo;
  aTbl.Post;

  aTbl.Close;
  aTbl.Free;

  Result := True;


end;

function TDocData.SaveToFile(const FilePath: String):string;
Var
  rtfFileName,FileName  : string;
  f : TStringList;
  idxf : TextFile;
  Index : Integer;
  DocLst : TIniFile;
  Count : Integer;
begin

   FileName := FilePath+FID+'\'+FID+'_'+FormatDateTime('yyyymmdd',FDate);

   Index := 1;
   While FileExists(FileName+'_'+IntToStr(Index)+'.Txt') do
       Inc(Index);

   FileName := FileName+'_'+IntToStr(Index)+'.Txt';

   Mkdir_Directory(ExtractFilePath(FileName));

   f := TStringList.Create;
   f.Text := Self.FMemo;
   f.SaveToFile(FileName);
   f.Free;

   DocLst := TIniFile.Create(FilePath+'doclst.dat');
   Count := DocLst.ReadInteger('COUNT',FID,0);
   if Count=0 Then
   Begin
        Index := 1;
        While Not (DocLst.ReadString(FID,IntToStr(Index),'NONE')='NONE') Do
             Inc(Index);
   End Else
         Index := Count+1;

   rtfFileName := ExtractFileName(ChangeFileExt(FileName,'.rtf'));

   DocLst.WriteInteger('COUNT',FID,Index);
   DocLst.WriteString(FID,IntToStr(Index),
                      rtfFileName+','+FTitle+'/'+
                      FormatDateTime('yyyy-mm-dd',FDate));

   DocLst.Free;

   //回傳要上傳的檔案
   Result := filename;

   //保存進StockDocIdxLst
   FileName := FilePath+'StockDocIdxLst\'+FID+'_DOCLST.dat';
   DocLst := TIniFile.Create(FileName);
   DocLst.WriteString(FID,IntToStr(Index),rtfFileName+','+FTitle+'/'+
                      FormatDateTime('yyyy-mm-dd',FDate));
   DocLst.WriteString('DownLoad',rtfFileName,'1');
   DocLst.Free;

   //改由Doc_Ftp做  2005/11/24 JoySun
   {FileName := FilePath+'StockDocIdxLst\StockDocIdxLst.dat';
   DocLst := TIniFile.Create(FileName);
   DocLst.WriteString(FID,'GUID',Get_GUID8);
   DocLst.Free; }
   ///

   //保存進索引
   FileName := FilePath+'DocLstIdx\'+FID+'.idx';
   AssignFile(idxf,FileName);
   FileMode := 1;
   if FileExists(FileName) Then
      Append(idxf)
   Else Begin
      Mkdir_Directory(ExtractFilePath(FileName));
      ReWrite(idxf);
   End;
   WriteLn(idxf,FTitle+'/'+ FormatDateTime('yyyy-mm-dd',FDate));
   CloseFile(idxf);

end;

function TDocData.SaveToFile_DEl(const FilePath: String): Boolean;
Var
  {rtfFileName,}FileName  : string;
  idxf : TextFile;
  {f : TStringList;
  Index : Integer;
  DocLst : TIniFile;
  Count : Integer;}
begin
  result:=false;

try
   {//保存到doclst
   DocLst := TIniFile.Create(FilePath+'doclst.dat');
   DocLst.WriteString('DOC_DEL','MEMO',
                      FID+':'+FTitle+'/'+FormatDateTime('yyyy-mm-dd',FDate));
   DocLst.Free;  }

   //保存到索引
   FileName := FilePath+'DocLstIdx\'+FID+'.idx';
   AssignFile(idxf,FileName);
   FileMode := 1;
   if FileExists(FileName) Then
      Append(idxf)
   Else Begin
      Mkdir_Directory(ExtractFilePath(FileName));
      ReWrite(idxf);
   End;
   WriteLn(idxf,'[D]'+FTitle+'/'+FormatDateTime('yyyy-mm-dd',FDate));
   CloseFile(idxf);
   result:=true;
Except
   On E : Exception do
   Begin
   End;
End;

end;


procedure TDocData.SetMemo(const Value: String);
Var
  f:TStringList;
  i : Integer;
begin

  f := TStringList.Create;
  f.Text := Value;
  i := 0;
  While True do
  Begin
      if i>=f.Count Then Break;
      f.Strings[i] := Trim(f.Strings[i]);
      if (Length(f.Strings[i])=0) or (Length(f.Strings[i])=10) Then
      Begin
         f.Delete(i);
         Continue;
      End Else
         Break;
      inc(i);
  End;

  FMemo := f.Text;

  f.Free;
  
end;

procedure TDocData.SetText(const Value: String);
var sLine,s : String;
  GetID : Boolean;
  FileStr : TStringList;
  i :  integer;
begin
  FOperator:='';
  FOpTime:=0;
  FDocStatus:='';

  GetID := False;
  FileStr := TStringList.Create;
  FileStr.Text := Value;
  i := -1;
  While True do
  Begin
      Inc(i);
      If i>=FileStr.Count Then Break;

      S := FileStr.Strings[i];
      S := FileStr.Strings[i];
      if Pos('<ID=',UpperCase(S))>0 Then
      Begin
           ReplaceSubString('<','',S);
           ReplaceSubString('ID','',S);
           ReplaceSubString('=','',S);
           ReplaceSubString('>','',S);
           ID := Trim(s);
           GetID := True;
           Continue;
      End;

      if GetID Then
      Begin
          if Pos('</ID>',UpperCase(S))>0 Then
             GetID := False;

          if Pos('<GUID>',UpperCase(S))>0 Then
          Begin
            GUID := GetSection(i,FileStr,'</GUID>');
            Continue;
          End;
          if Pos('<DOCID>',UpperCase(S))>0 Then
          Begin
            DOCID := GetSection(i,FileStr,'</DOCID>');
            Continue;
          End;
          if Pos('<CBID>',UpperCase(S))>0 Then
          Begin
            CBID := GetSection(i,FileStr,'</CBID>');
            Continue;
          End;
          if Pos('<CBSTATUS>',UpperCase(S))>0 Then
          Begin
            CBStatus := GetSection(i,FileStr,'</CBSTATUS>');
            Continue;
          End;
          if Pos('<CBNAME>',UpperCase(S))>0 Then
          Begin
            CBNAME := GetSection(i,FileStr,'</CBNAME>');
            Continue;
          End;
          if Pos('<URL>',UpperCase(S))>0 Then
          Begin
            Url := GetSection(i,FileStr,'</URL>');
            Continue;
          End;
          if Pos('<TITLE>',UpperCase(S))>0 Then
          Begin
            Title := GetSection(i,FileStr,'</TITLE>');
            Continue;
          End;
          if Pos('<DOCTYPE>',UpperCase(S))>0 Then
          Begin
            DocType := GetSection(i,FileStr,'</DOCTYPE>');
            Continue;
          End;
          if Pos('<DATE>',UpperCase(S))>0 Then
          Begin
            Date:= StrToFloat(GetSection(i,FileStr,'</DATE>'));
            Continue;
          End;
          if Pos('<TIME>',UpperCase(S))>0 Then
          Begin
            Time:= StrToFloat(GetSection(i,FileStr,'</TIME>'));
            Continue;
          End;
          if Pos('<MEMO>',UpperCase(S))>0 Then
          Begin
            Memo := GetSection(i,FileStr,'</MEMO>');
            Continue;
          End;

          if Pos(UpperCase('<Operator>'),UpperCase(S))>0 Then
          Begin
            Operator := GetSection(i,FileStr,UpperCase('</Operator>'));
            Continue;
          End;
          if Pos(UpperCase('<OpTime>'),UpperCase(S))>0 Then
          Begin
            sLine:=Trim(GetSection(i,FileStr,UpperCase('</OpTime>')));
            if sLine<>'' then
              OpTime:= StrToFloat(sLine);
            Continue;
          End;
          if Pos(UpperCase('<DocStatus>'),UpperCase(S))>0 Then
          Begin
            DocStatus := GetSection(i,FileStr,UpperCase('</DocStatus>'));
            Continue;
          End;
          
      End;
  End;
  FileStr.Free;

end;

{ TDocDataMgr }

Function TDocDataMgr.AddADoc(const Title : String;
                       const ID : String;
                       const DocType : String;
                       const Date : TDate;
                       const Time : TTime;
                       const URL  : String):TDocData;
Var
  ADoc:TDocData;
  ADoc2:TDocData;
  i : integer;
begin

  ADoc := TDocData.Create(False,Title,ID,DocType,Date,Time,'',URL);

  For i:=0 to  FEndReadDocList.Count-1 do
  Begin
      ADoc2 := FEndReadDocList.Items[i];
      if ADoc.DocExist(ADoc2) Then
      Begin
        ADoc.Destroy;
        ADoc := Nil;
        break;
      End;
  end;

  if ADoc<>nil Then
     FDocList.Add(ADoc);

  //if Not ThisDocExists(ADoc) Then
  //   FDocList.Add(ADoc);
  //Else
  //Begin
  //   ADoc.Destroy;
  //   ADoc := Nil;
  //End;

  Result := ADoc;

end;

procedure TDocDataMgr.SetChkDocIsOk(const Tag,GUID: String);
Var
  ADoc : TDocData;
  FileName : String;
begin

   ADoc := GetADoc(GUID);
   if ADoc=nil Then exit;

   //紀錄
   SaveDocToLog(Tag,ADoc,chkOk);

   //刪除
   FDocList.Remove(ADoc);
   SaveToTempDocFile;

   //保存
   FileName := ADoc.SaveToFile(FDocPath);

   //產生一個完成的idx檔案,用以消除待審核的紀錄
   SaveDocToFinishIdx(ADoc);

   //上傳
   SaveDocToUpLoad(ADoc,FileName);

   //Free
   ADoc.Destroy;
end;

procedure TDocDataMgr.ClearData;
Begin
   ClearDataDocList;
   ClearDataNotGetMemoList;
   ClearDataEndReadDocList;
   ClearDataExistDocTitleList;
   FLogHistory.Clear;//add by wangjinhua 0306
end;

constructor TDocDataMgr.Create(const TempDocFileName: String;Const DocPath:String);
begin

   FTempDocFileName := TempDocFileName;
   FLogPath := ExtractFilePath(FTempDocFileName)+'CheckDocLog\';
   FTempTag := ChangeFileExt(ExtractFileName(FTempDocFileName),'');

   FNowTempDocFileName := '';

   FDocPath := DocPath;
   FLogDocList := TList.Create;
   FDocList := TList.Create;
   FNotGetMemoDocList := TList.Create;
   FEndReadDocList := TList.Create;
   FExistDocTitle  := TStringList.Create;
   FLogHistory := TStringList.Create;//add by wangjinhua 0306
end;

procedure TDocDataMgr.SetCheckDocLogSaveDays(aValue:integer);
begin
  //if aValue>0 then
  begin
    FCheckDocLogSaveDays:=aValue;
  end;
end;

procedure TDocDataMgr.DelADoc(const Tag,GUID: String);

function AddDocDel(aTr1IdxPath,aCode,aDocTitle,aDocText:string;aDocDate:TDate):Boolean;
var aDocTxtFile,aDocDateStr:string;
    ts:TStringList;
begin
  result:=false;
  if not DirectoryExists(aTr1IdxPath) then exit;
  aDocDateStr:=FormatDateTime('yyyymmdd',aDocDate);
  aDocTxtFile:=Format('%s%sDel.txt',[aTr1IdxPath,aCode]);
  ts:=TStringList.Create;
  try
    if FileExists(aDocTxtFile) then
      ts.LoadFromFile(aDocTxtFile);
    ts.Add( Format('<Doc=%s/%s>',[aDocTitle,aDocDateStr]) );
    ts.Add( aDocText );
    ts.Add( '</Doc>' );
    ts.SaveToFile(aDocTxtFile);
  finally
    try FreeAndNil(ts); except end;
  end;
  result:=true;
end;
Var
  ADoc : TDocData;
  aTempStr:shortstring;
begin

   ADoc := GetADoc(GUID);
   if ADoc=nil Then exit;

   SaveDocToLog(Tag,ADoc,chkDel);

   FDocList.Remove(ADoc);
   SaveToTempDocFile;

   //add by JoySun 2005/10/24
   //保存失败记录，防止重复搜索
   ADoc.SaveToFile_DEl(FDocPath);

   aTempStr:=FDocPath;
   DoPathSep(aTempStr);
   aTempStr:=aTempStr+'DocLstIdx'+'\';
   AddDocDel(aTempStr, ADoc.FID,ADoc.FTitle,ADoc.FMemo,ADoc.FDate);

   //產生一個完成的idx檔案,用以消除待審核的紀錄
   SaveDocToFinishIdx(ADoc);

   ADoc.Destroy;



end;

destructor TDocDataMgr.Destroy;
Begin

  ClearData;
  FDocList.Free;
  FNotGetMemoDocList.Free;
  FEndReadDocList.Free;
  FLogDocList.Free;

  FExistDocTitle.Free;

  FLogHistory.Free;//add by wangjinhua 0306
  //inherited;
end;

function TDocDataMgr.GetADoc(const GUID: String): TDocData;
Var
  ADoc:TDocData;
  i : Integer;
begin

  Result := nil;
  For i:=0 to FDocList.Count-1 do
  Begin
     ADoc := FDocList.Items[i];
     if ADoc.GUID=GUID Then
     Begin
         Result := ADoc;
         Break;
     End;
  End;

end;



procedure TDocDataMgr.LoadFromTempDocFile;
Var
  f : TextFile;
  s : String;
  FileStr : TStringList;

Begin

Try

  ClearDataDocList;

  if Not FileExists(FNowTempDocFileName) Then Exit;

  FileStr := TStringList.Create;
  AssignFile(f,FNowTempDocFileName);
  FileMode := 0;
  Reset(F);
  While Not Eof(f) do
  Begin
      Readln(f,s);
      FileStr.Add(s);
  End;
  CloseFile(f);

  GetDocDataStringList(FileStr,FDocList);
  FileStr.Free;
Finally
End;
End;

procedure TDocDataMgr.SaveToTempDocFile;
Var
  f : TStringList;
  ADoc:TDocData;
  i,j : Integer;
  List : Array[0..1] of TList;
  FileName: String;
  Age,fh: Integer;
Begin
try

  f := TStringList.Create;


  List[0] := FDocList;
  List[1] := FNotGetMemoDocList;
  For j:=0 to High(List) do
  For i:=0 to List[j].Count-1 do
  Begin
     ADoc := List[j].Items[i];
     if (Length(ADoc.Memo)=0) or (Pos('DELETE',ADoc.Memo)>0) Then
        Continue;
     SetDocDataStringList(f,ADoc);
  End;

  if Length(FNowTempDocFileName)>0 Then
     FileName := FNowTempDocFileName
  Else
     FileName := GetTempDocFileName;

   if Length(f.Text)>0 Then
   Begin
      Age := 0;
      //先取出原來檔案的時間
      if FileExists(FileName) Then
         Age := FileAge(FileName);

      f.SaveToFile(FileName);

      //把檔案原來的時間寫進去
      if Age>0 Then
      Begin
        fh := FileOpen(FileName,fmOpenWrite);
        Try
          FileSetDate(fh,Age);
        Except
        End;
        Try
          if fh>0 Then
            FileClose(fh);
        Except
        End;
      End;

   End Else
      DeleteFile(FileName);

  f.Free;
except
end;

end;

procedure TDocDataMgr.SaveToTempDocFile_News03();
Var
  f : TStringList;
  ADoc:TDocData;
  i,j,k : Integer;
  List : Array[0..1] of TList;
  FileName : String;
  Age,fh: Integer;
  //inifile:TiniFile;
  //aMarkKeyWord : Array of string;
Begin
try
  f := TStringList.Create;

  List[0] := FDocList;
  List[1] := FNotGetMemoDocList;
  For j:=0 to High(List) do
  For i:=0 to List[j].Count-1 do
  Begin
     ADoc := List[j].Items[i];
     if (Length(ADoc.Memo)=0) or (Pos('DELETE',ADoc.Memo)>0) Then
       Continue;

     SetDocDataStringList(f,ADoc);
  End;

  //FileName:=

   if Length(f.Text)>0 Then
   Begin
      Age := 0;
      //先取出原來檔案的時間
      if FileExists(FileName) Then
         Age := FileAge(FileName);

      f.SaveToFile(FileName);

      //把檔案原來的時間寫進去
      if Age>0 Then
      Begin
        fh := FileOpen(FileName,fmOpenWrite);
        Try
          FileSetDate(fh,Age);
        Except
        End;
        Try
          if fh>0 Then
            FileClose(fh);
        Except
        End;
      End;

   End Else
      DeleteFile(FileName);

  f.Free;
finally
end;
end;


procedure TDocDataMgr.SaveToTempDocFile3;
Var
  f,f2 : TStringList;
  ADoc:TDocData;
  i,j : Integer;
  List : Array[0..1] of TList;
  FileName ,FileName3: String;
  Age,fh: Integer;
Begin
try

  f := TStringList.Create;
  f2:= TStringList.Create;

  if Length(FNowTempDocFileName)>0 Then
     FileName := FNowTempDocFileName
  Else
     FileName := GetTempDocFileName;
  FileName3:=ExtractFilePath(FileName)+'doc03.dat';

  List[0] := FDocList;
  List[1] := FNotGetMemoDocList;
  For j:=0 to High(List) do
  For i:=0 to List[j].Count-1 do
  Begin
     ADoc := List[j].Items[i];
     if (Length(ADoc.Memo)=0) or (Pos('DELETE',ADoc.Memo)>0) Then
        Continue;
     if FileExists(FileName3) Then
     begin
       f2.LoadFromFile(FileName3);
       if(Pos(ADoc.Title,f2.Text)=0)and(Pos(ADoc.URL,f2.Text)=0)then
         SetDocDataStringList(f,ADoc);
     end else
       SetDocDataStringList(f,ADoc);
  End;

   if Length(f.Text)>0 Then
   Begin
      Age := 0;
      //先取出原來檔案的時間
      if FileExists(FileName) Then
         Age := FileAge(FileName);

      f.SaveToFile(FileName);

      //把檔案原來的時間寫進去
      if Age>0 Then
      Begin
        fh := FileOpen(FileName,fmOpenWrite);
        Try
          FileSetDate(fh,Age);
        Except
        End;
        Try
          if fh>0 Then
            FileClose(fh);
        Except
        End;
      End;

   End Else
      DeleteFile(FileName);

   if Length(f.Text)>0 Then
   Begin
      f2.Clear;
      if FileExists(FileName3) Then
        f2.LoadFromFile(FileName3);
      f2.Text := f2.Text + f.Text;
      f2.SaveToFile(FileName3);
   End;

  f.Free;
  f2.Free;
except
end;
end;

procedure TDocDataMgr.SaveToTempDocFile_News_TW;
Var
  f : TStringList;
  ADoc:TDocData;
  i,j,k : Integer;
  List : Array[0..1] of TList;
  FileName : String;
  Age,fh: Integer;
  inifile:TiniFile;
  aMarkKeyWord : Array of string;
Begin
try
  inifile:=TiniFile.Create(ExtractFilePath(application.ExeName)+'setup.ini');
  j:=inifile.ReadInteger('Doc_01_TW','MarkCount',0);
  SetLength(aMarkKeyWord,j);
  For k:=1 To j do
    aMarkKeyWord[k-1]:=inifile.ReadString('Doc_01_TW',IntToStr(k),'');

  f := TStringList.Create;

  List[0] := FDocList;
  List[1] := FNotGetMemoDocList;
  For j:=0 to High(List) do
  For i:=0 to List[j].Count-1 do
  Begin
     ADoc := List[j].Items[i];
     if (Length(ADoc.Memo)=0) or (Pos('DELETE',ADoc.Memo)>0) Then
       Continue;

     For k:=0 To high(aMarkKeyWord) do
       if (Pos(aMarkKeyWord[k],Adoc.FTitle)>0) or (Pos(aMarkKeyWord[k],Adoc.FMemo)>0) then
       begin
         SetDocDataStringList(f,ADoc);
         //break;
       end;
  End;

  if Length(FNowTempDocFileName)>0 Then
     FileName := FNowTempDocFileName
  Else
     FileName := GetTempDocFileName;

   if Length(f.Text)>0 Then
   Begin
      Age := 0;
      //先取出原來檔案的時間
      if FileExists(FileName) Then
         Age := FileAge(FileName);

      f.SaveToFile(FileName);

      //把檔案原來的時間寫進去
      if Age>0 Then
      Begin
        fh := FileOpen(FileName,fmOpenWrite);
        Try
          FileSetDate(fh,Age);
        Except
        End;
        Try
          if fh>0 Then
            FileClose(fh);
        Except
        End;
      End;

   End Else
      DeleteFile(FileName);

  f.Free;
finally
  SetLength(aMarkKeyWord,0);
  inifile.Free;
end;
end;

procedure TDocDataMgr.SaveToNewsDocFile(aNewsDocPath:String);
Var
  f : TStringList;
  ADoc:TDocData;
  i,j : Integer;
  List : Array[0..1] of TList;
  FileName : String;
  Age,fh: Integer;
Begin

  f := TStringList.Create;

  FileName:=aNewsDocPath+FormatDateTime('yyyymmdd',date)+'.News';

  if FileExists(FileName)then
    f.LoadFromFile(FileName);

  List[0] := FDocList;
  List[1] := FNotGetMemoDocList;
  For j:=0 to High(List) do
  For i:=0 to List[j].Count-1 do
  Begin
     ADoc := List[j].Items[i];
     if (Length(ADoc.Memo)=0) or (Pos('DELETE',ADoc.Memo)>0) Then
        Continue;
     SetDocDataStringList(f,ADoc);
  End;

   if Length(f.Text)>0 Then
   Begin
      Age := 0;
      //先取出原來檔案的時間
      if FileExists(FileName) Then
         Age := FileAge(FileName);

      f.SaveToFile(FileName);

      //把檔案原來的時間寫進去
      if Age>0 Then
      Begin
        fh := FileOpen(FileName,fmOpenWrite);
        Try
          FileSetDate(fh,Age);
        Except
        End;
        Try
          if fh>0 Then
            FileClose(fh);
        Except
        End;
      End;

   End Else
      DeleteFile(FileName);

  f.Free;

end;

function TDocDataMgr.TempDocFileNameExists: Boolean;
begin
    FNowTempDocFileName := '';
    FolderAllFiles(ExtractFilePath(FTempDocFileName),'.TMP',OnGetFile,False);
    result := Length(FNowTempDocFileName)>0;
end;

procedure TDocDataMgr.SaveDocToLog(Tag:String;ADoc: TDocData;ChkStatus:TChkStatus);
Var
  f : TextFile;
  FileName : String;
  fStringLst : TStringList;
  DateStr : String;
  i : Integer;
begin

    if ADoc=nil Then Exit;

    DateStr := FormatDateTime('yymmdd',Date);

    Mkdir_Directory(FLogPath);
    Case ChkStatus of
       chkOk  : FileName := FLogPath+Tag+'_'+DateStr+'_Pass.log';
       chkDel : FileName := FLogPath+Tag+'_'+DateStr+'_Fail.log';
    End;
    //Mkdir_Directory(ExtractFilePath(FileName));

    {
    f := TIniFile.Create(FileName);
    Count := f.ReadInteger(DateStr,'Count',0)+1;
    f.WriteInteger(DateStr,'Count',Count);
    f.WriteString(DateStr,IntToStr(Count),ADoc.GUID);
    f.Free;
    }


    fStringLst := nil;
    Try
      fStringLst := TStringList.Create;
      SetDocDataStringList(fStringLst,ADoc);
      AssignFile(f,FileName);
      FileMode:=1;

      if FileExists(FileName) Then
         Append(f)
      Else
         ReWrite(f);
      for i:=0 to fStringLst.Count-1 do
         WriteLn(f,fStringLst.Strings[i]);
    Finally
      try
        CloseFile(f);
      Except
      end;
      if (ClearDate<>Date)then
      begin
         ClearSysLog(Tag+'_');
         ClearDate:=Date;
      end;
      if Assigned(fStringLst) Then
         fStringLst.Free;
    End;
end;

procedure TDocDataMgr.SetADocMemo(const ADoc: TDocData;
  const Memo: String);
begin
   if ADoc=nil Then Exit;
   ADoc.Memo := Memo;
end;

procedure TDocDataMgr.SetADocID(const ADoc: TDocData; const ID: String);
begin
   if ADoc=nil Then Exit;
   ADoc.DOCID := ID;
end;

procedure TDocDataMgr.SetChkDocIDIsOk(const Tag,GUID: String);
Var
  ADoc : TDocData;
begin
   ADoc := GetADoc(GUID);
   if ADoc=nil Then exit;
try
   SaveDocToLog(Tag,ADoc,chkOk);
   FDocList.Remove(ADoc);
   SaveToTempDocFile;
   //產生一個完成的idx檔案,用以消除待審核的紀錄
   //SaveDocToFinishIdx(ADoc);
finally
   ADoc.Destroy;
end;
end;

function TDocDataMgr.GetTempDocFileName: String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin

   FileName := ExtractFileName(FTempDocFileName);
   FileExt  := ExtractFileExt(FileName);

   ReplaceSubString(FileExt,'',FileName);

   Index := 1;
   FileName2 := ExtractFilePath(FTempDocFileName)+FileName+'_'+IntToStr(Index)+FileExt;
   While FileExists(FileName2) do
   Begin
       inc(Index);
       FileName2 := ExtractFilePath(FTempDocFileName)+FileName+'_'+IntToStr(Index)+FileExt;
   End;

   Result := FileName2;


end;

procedure TDocDataMgr.SaveNotMemoDocLogFile(Const Tag:string);
Var
  f : TStringList;
  ADoc:TDocData;
  i,j : Integer;
  List : Array[0..1] of TList;
begin

  f := TStringList.Create;
  List[0] := FDocList;
  List[1] := FNotGetMemoDocList;
  For j:=0 to High(List) do
  For i:=0 to List[j].Count-1 do
  Begin
     ADoc := List[j].Items[i];
     if Length(ADoc.Memo)>0 Then Continue;
     SetDocDataStringList(f,ADoc);
  End;
  if Length(f.Text)>0 Then
    f.SaveToFile(GetNotMemoDocLogFile(Tag))
  Else
    DeleteFile(GetNotMemoDocLogFile(Tag));
  f.Free;


end;

procedure TDocDataMgr.SaveNotMemoDocLogFile2(Const Tag:string);
Var
  f : TStringList;
  ADoc:TDocData;
  i,j : Integer;
begin

  f := TStringList.Create;

  For i:=0 to FDocList.Count-1 do
  Begin
     ADoc := FDocList.Items[i];
     if Length(ADoc.Memo)>0 Then Continue;
     SetDocDataStringList(f,ADoc);
  End;

  if Length(f.Text)>0 Then
    f.SaveToFile(GetNotMemoDocLogFile(Tag))
  Else
    DeleteFile(GetNotMemoDocLogFile(Tag));
  f.Free;


end;

function TDocDataMgr.GetNotMemoDocLogFile(Const Tag:string): String;
begin
Result := ExtractFilePath(FTempDocFileName)+Tag+'NotGetMemo.log';
end;

procedure TDocDataMgr.LoadFromNotMemoDocLogFile(const tag: string);
Var
  f : TextFile;
  s,FileName : String;
  FileStr : TStringList; j:integer;
Begin
Try
  ClearDataNotGetMemoList;
  FileName := GetNotMemoDocLogFile(Tag);
  if Not FileExists(FileName) Then Exit;
  FileStr := TStringList.Create;
  AssignFile(f,FileName);
  FileMode := 0;
  Reset(F); j:=0;
  While Not Eof(f) do
  Begin
    Inc(j);
    if j>100 then
    begin
      sleep(1);
      j:=0;
    end;
    Readln(f,s);
    FileStr.Add(s);
  End;
  CloseFile(f);
  GetDocDataStringList(FileStr,FNotGetMemoDocList);
  FileStr.Free;
Finally
End;
End;

function TDocDataMgr.GetSection(Var StratIndex: Integer;
  const f: TStringList; const Section: String): String;
Var
     i : integer;
     s,ts : String;
Begin
         ts := '';
         For i:=StratIndex to f.Count-1 do
         Begin
                s := f.Strings[i];
                if Pos(Section,UpperCase(S))>0 Then
                Begin
                   StratIndex := i;
                   Break;
                End;
                if Length(ts)>0 Then
                   ts := ts + #13#10;
                ts := ts + s ;
         End;
         Result := ts;
End;


//add by wangjinhua Doc20090306
procedure TDocDataMgr.DelAnDoc(var f:TStringList);
var
  j,i:Integer;
  breakFlag:Boolean;
begin
    breakFlag := false;
    j := f.Count - 1 ;
    while (j >= 0) and (not breakFlag) do
    begin
      if f[j] = '<ID=NONE>' then
      begin
        i := j;
        while (i < f.Count) and (not breakFlag) do
        begin
          if f[i] = '</ID>' then
          begin
            f.Delete(i);
            breakFlag := true;
            break;
          end else
            f.Delete(i);
        end;
      end;
      j := j - 1;
    end;
end;


function TDocDataMgr.GetDocsNum(f:TStringList):Integer;
var
  i:Integer;
begin
  Result := 0;
  for i := 0 to f.Count - 1 do
  begin
    if f[i] = '<ID=NONE>' then
      Inc(Result);
  end;
end;

procedure TDocDataMgr.FilterADocInDocList();
var
  i,v : Integer;
  curDoc,tmpDoc:TDocData;
begin
  For i := 0 to FDocList.Count - 1 do
  begin
    //add by wangjinhua Doc20090306
    if i >= FDocList.Count then break;
   //--
    curDoc := FDocList.Items[i];
    v := i + 1;
    while v < FDocList.Count do
    begin
      tmpDoc := FDocList.Items[v];
      if (tmpDoc.FTitle = curDoc.FTitle) and
         (tmpDoc.FDate = curDoc.FDate) and
         (tmpDoc.FTime = curDoc.FTime) then
      begin
        //modify by wangjinhua Doc20090306
        {
        //FDocList.Delete(v);
        //FDocList.Items[v]
        tmpDoc.FTitle := '';
        FDocList.Items[v] := tmpDoc;
        //Continue;
        }
        FreeMem(FDocList.Items[v]);
        FDocList.Delete(v);
        Continue;
        //--
      end;
      Inc(v);
    end;
  end;

  For i := 0 to FNotGetMemoDocList.Count - 1 do
  begin
    if i >= FNotGetMemoDocList.Count then break;
    curDoc := FNotGetMemoDocList.Items[i];
    v := i + 1;
    while v < FNotGetMemoDocList.Count do
    begin
      tmpDoc := FNotGetMemoDocList.Items[v];
      if (tmpDoc.FTitle = curDoc.FTitle) and
         (tmpDoc.FDate = curDoc.FDate) and
         (tmpDoc.FTime = curDoc.FTime) then
      begin
        //modify by wangjinhua Doc20090306
        {//FNotGetMemoDocList.Delete(v);
        tmpDoc.FTitle := '';
        FNotGetMemoDocList.Items[v] := tmpDoc;
        //Continue;}
        FreeMem(FNotGetMemoDocList.Items[v]);
        FNotGetMemoDocList.Delete(v);
        Continue;
        //--
      end;
      Inc(v);
    end;
  end;

end;



function TDocDataMgr.IsDocExists(f,f2:TStringList;ADoc:TDocData):Boolean;
var
  j:Integer;
  vTitle,vDateTime1,vDateTime2:String;
  vDate:TDate;
  vTime:TTime;
begin
  Result := true;
  j := 0;
  while j < f.Count do
  begin
    if (f[j] = '<Title>') and
       (f[j + 2] = '</Title>')  then
    begin
      Inc(j);
      vTitle := f[j];
      j := j + 6;
      vDate := StrToFloat(f[j]);
      j := j + 3;
      vTime := StrToFloat(f[j]);
      vDateTime1 := EnCodeTheDateTime(vDate,vTime);
      vDateTime2 := EnCodeTheDateTime(ADoc.FDate,ADoc.FTime);
      if ( ADoc.FTitle = vTitle ) and
         ( vDateTime1 = vDateTime2 ) then
      begin
        Result := false;
        exit;
      end;
    end;
    Inc(j);
  end;

  j := 0;
  while j < f2.Count do
  begin
    if (f2[j] = '<Title>') and
       (f2[j + 2] = '</Title>')  then
    begin
      Inc(j);
      vTitle := f2[j];
      j := j + 6;
      vDate := StrToFloat(f2[j]);
      j := j + 3;
      vTime := StrToFloat(f2[j]);
      vDateTime1 := EnCodeTheDateTime(vDate,vTime);
      vDateTime2 := EnCodeTheDateTime(ADoc.FDate,ADoc.FTime);
      if ( ADoc.FTitle = vTitle) and
         ( vDateTime1 = vDateTime2) then
      begin
        Result := false;
        exit;
      end;
    end;
    Inc(j);
  end;

end;

//--

//Modify by wangjinhua Doc20090306 将公告收集时候的挡板公告数目由1改为10
procedure TDocDataMgr.SaveEndReadDocLogFile(const tag: string);
Var
  f,f2: TStringList;
  ADoc:TDocData;
  i,iCount:Integer;
  vTmpFile,FileName:String;
begin
try
try
  FileName := GetEndReadDocLogFile(tag);
  f := TStringList.Create;
  f2 := TStringList.Create;
  if FileExists(FileName) Then
     f2.LoadFromFile(FileName);
  { add by wangjinhua Doc20090306 Doc代办 }
  iCount := FDocList.Count;
  if iCount = 0 then
    exit
  else if iCount > 10 then
    iCount := 10;

  for i := 0 to iCount - 1 do
  begin
    ADoc := FDocList.Items[i];
    if IsDocExists(f,f2,ADoc) then
      SetDocDataStringList(f,ADoc);
  end;

  f.Add(f2.Text);
  i := 0;
  while i < f.Count do
  begin
    if f[i] = '' then
      f.Delete(i)
    else
      Inc(i);
  end;

  while true do
  begin
    if GetDocsNum(f) >= 10 then
      DelAnDoc(f)
    else
      break;
  end;

  {delete by wangjinhua 20090310 Doc代办
  if FDocList.Count>0 Then
  Begin
    f := TStringList.Create;
    ADoc := FDocList.Items[0];
    SetDocDataStringList(f,ADoc);
  End;}
  i := 0;
  while i < f.Count do
  begin
    if f[i] = '' then
      f.Delete(i)
    else
      Inc(i);
  end;
  if Length(f.Text)>0 Then
    f.SaveToFile(FileName);
except
  on e:Exception do
  begin
    e := nil;
  end;
end;
finally
  try
    if Assigned(f) then
      FreeAndNil(f);
    if Assigned(f2) then
      FreeAndNil(f2);
  except
    on e:Exception do
    begin
      e := nil;
    end;
  end;
end;

end;




//add by wangjinhua 0306
procedure TDocDataMgr.WriteLogHistory();
var
  i:Integer;
  fIni:TIniFile;
  vItem,vFile:String;
  ADoc:TDocData;
begin
try
try
  vFile := ExtractFilePath(FTempDocFileName) + FTempTag + 'History.log';
  fIni := TIniFile.Create(vFile);

  for i := 0 to DocList.Count - 1 do
  begin
    ADoc := DocList[i];
    fIni.WriteString(ADoc.DocType + '_' + ADoc.Title,'Type',ADoc.DocType);
    ADoc := nil;
  end;
except
  on e:Exception do
  begin
    ShowMessage(e.Message);
    e := nil;
  end;
end;
finally
  try
    if Assigned(fIni) then
      FreeAndNil(fIni);
  except
  end;
end;
end;


procedure TDocDataMgr.LoadLogHistory();
var
  i,j:Integer;
  vLine,vFile:String;
  ts:TStrings;
begin
try
try
  FLogHistory.Clear;
  vFile := ExtractFilePath(FTempDocFileName) + FTempTag + 'History.log';
  if not FileExists(vFile) then
    exit;
  ts := TStringList.Create;
  ts.LoadFromFile(vFile);
  j:=0;
  for i := 0 to ts.Count - 1 do
  begin
    vLine := ts[i];
    if length(vLine)>1 then 
    if (vLine[1] = '[') and (vLine[Length(vLine)] = ']') then
    begin
      Inc(j);
      if j>100 then
      begin
        j:=0;
        Sleep(1);
      end;
      FLogHistory.Add(vLine);
    end;
  end;

except
  on e:Exception do
    e := nil;
end;
finally
  try
    if Assigned(ts) then
      FreeAndNil(ts);
  except
  end;
end;
end;


Function TDocDataMgr.AddADoc01(const Title : String;
                       const ID : String;
                       const DocType : String;
                       const Date : TDate;
                       const Time : TTime;
                       const URL  : String):TDocData;
Var
  i,j : integer;
  ts:TStringList;
begin
try
  Result := nil;  j:=0;
  for i := 0 to FLogHistory.Count - 1 do
  begin
    Inc(j);
    if j>20 then
    begin
      j:=0;
      Sleep(1);
    end;
    Application.ProcessMessages;
    if '[' + Trim(DocType) + '_' + Trim(Title) + ']' = FLogHistory[i] then
      exit;
  end;
  FLogHistory.Add('[' + Trim(DocType) + '_' + Trim(Title) + ']');
  {ts := TStringList.Create;
  ts.Assign(FLogHistory);
  ts.Text := DocType + #13#10 + Title + #13#10 + ts.Text;
  ts.SaveToFile(ExtractFilePath(FTempDocFileName) + DocType + '_' + Title + '.txt');
  ts.Free;}
  Result := TDocData.Create(False,Title,ID,DocType,Date,Time,'',URL);
  FDocList.Add(Result);
except
  on e:Exception do
    showMessage(e.Message);
end;
end;
//--



function TDocDataMgr.GetEndReadDocLogFile(const Tag: string): String;
begin
   Result := ExtractFilePath(FTempDocFileName)+Tag+'EndReadDoc.log';
end;


procedure TDocDataMgr.ClearDataDocList;
Var
  ADoc:TDocData;
Begin

  While FDocList.Count>0 do
  Begin
     ADoc := FDocList.Items[0];
     ADoc.Destroy;
     FDocList.Delete(0);
  End;

end;

procedure TDocDataMgr.ClearDataNotGetMemoList;
Var
  ADoc:TDocData;
Begin

  While FNotGetMemoDocList.Count>0 do
  Begin
     ADoc := FNotGetMemoDocList.Items[0];
     ADoc.Destroy;
     FNotGetMemoDocList.Delete(0);
  End;

end;

procedure TDocDataMgr.LoadFromEndReadDocLogFile(const tag: string);
Var
  f : TextFile;
  s,FileName : String;
  FileStr : TStringList;
Begin

Try

  ClearDataEndReadDocList;

  FileName := GetEndReadDocLogFile(Tag);

  if Not FileExists(FileName) Then Exit;

  FileStr := TStringList.Create;
  AssignFile(f,FileName);
  FileMode := 0;
  Reset(F);
  While Not Eof(f) do
  Begin
      Readln(f,s);
      FileStr.Add(s);
  End;
  CloseFile(f);

  GetDocDataStringList(FileStr,FEndReadDocList);

  FileStr.Free;


Finally
End;



End;

procedure TDocDataMgr.ClearDataEndReadDocList;
Var
  ADoc:TDocData;
Begin

  While FEndReadDocList.Count>0 do
  Begin
     ADoc := FEndReadDocList.Items[0];
     ADoc.Destroy;
     FEndReadDocList.Delete(0);
  End;


end;

procedure TDocDataMgr.SetDocDataStringList(f: TStringList; ADoc: TDocData);
begin
     f.Add(ADoc.Text);
end;

procedure TDocDataMgr.GetDocDataStringList(FileStr:TStringList;List: TList);
Var
  s : String;
  ADoc:TDocData;
  i :  integer;
begin

  i := -1;
  While True do
  Begin
      Inc(i);
      If i>=FileStr.Count Then Break;
      S := FileStr.Strings[i];
      if Pos('<ID',UpperCase(S))>0 Then
      Begin
           s := GetSection(i,FileStr,'</ID>');
           ADoc := TDocData.Create(s);
           List.Add(ADoc);
           Continue;
      End;
  End;
End;

function TDocDataMgr.GetUploadLogFile: String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin

   FileName := 'upload';
   FileExt  := '.ftp';

   Index := 1;
   FileName2 := ExtractFilePath(FTempDocFileName)+FileName+'_'+IntToStr(Index)+FileExt;
   While FileExists(FileName2) do
   Begin
       inc(Index);
       FileName2 := ExtractFilePath(FTempDocFileName)+FileName+'_'+IntToStr(Index)+FileExt;
   End;

   Result := FileName2;


end;

procedure TDocDataMgr.SaveDocToUpLoad(ADoc: TDocData;Const FileName:String);
Var
  f : TStringList;
begin

   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('ID='+ADOC.ID);
   f.Add('FileName='+FileName);
   f.Add('Title='+ADoc.Title);
   f.Add('Date='+FloatToStr(ADoc.Date));
   f.SaveToFile(GetUploadLogFile);
   f.Free;

end;

function TDocDataMgr.GetUploadADoc(const FileName: String;Const SeverName :String): TUploadDoc;
Var
  f : TiniFile;
begin

   f := TIniFile.Create(FileName);
   Result.ID := f.ReadString('File','ID','');
   Result.FileName := FDocPath+Result.ID+'\'+ExtractFileName(f.ReadString('File','FileName',''));
   Result.Title := f.ReadString('File','Title','');
   Result.Date := f.ReadFloat('File','Date',0);
   Result.Del := f.ReadInteger('File','Del',0);
   Result.FTP_Note := f.ReadInteger('FTP_Note',SeverName,0);
   f.Free;
end;

procedure TDocDataMgr.SaveUploadADoc(const FileName: String;Const SeverName :String;Const i:integer);
Var
  f : TiniFile;
begin

   f := TIniFile.Create(FileName);
   f.WriteString('FTP_Note',SeverName,IntToStr(i));
   f.Free;

end;

function TDocDataMgr.ThisUploadDocNeedUpload(Const Tr1DBPath:String;ADoc: TUploadDoc): Boolean;
Var
  f : TiniFile;
  StrDate:String;
  Year,Day,Month : Word;
  StrLst : _cStrLst;
  Date : TDate;
begin

 f := TIniFile.Create(Tr1DBPath + 'CBData\Data\date.dat');

Try

   Result := false;
   Date := 0;
   StrDate := f.ReadString('Date',ADoc.ID,'');
   StrLst := DoStrArray(StrDate,',');
   StrDate := '';
   if High(StrLst)=2 Then
      StrDate := StrLst[0];
   if Length(StrDate)=8 Then
      if IsInteger(PChar(StrDate)) Then
      Begin
          Year := StrToInt(Copy(StrDate,1,4));
          Day := StrToInt(Copy(StrDate,5,2));
          Month := StrToInt(Copy(StrDate,7,2));
          Date := EncodeDate(Year,Month,Day);
      End;

   if ADoc.Date>=Date Then
      Result := True;

Finally
 f.Free;
end;
end;

function TDocDataMgr.GetUploadTmpFile: _cStrLst;
begin
    FolderAllFiles(ExtractFilePath(FTempDocFileName),'.ftp',Result,false);
end;

function TDocDataMgr.SetUploadDocLst(ADoc: TUploadDoc): String;
Var
  DocLst : TiniFile;
  Index  :  Integer;
begin

   Result := GetUploadDocLst;
   //Result := FDocPath;
   DocLst := TIniFile.Create(Result);
   Index := 1;
   While Not (DocLst.ReadString(ADoc.ID,IntToStr(Index),'NONE')='NONE') Do
        Inc(Index);

   DocLst.WriteString(ADoc.ID,IntToStr(Index),
                  ChangeFileExt(ExtractFileName(ADoc.FileName),'.rtf')+','+ADoc.Title+'/'+
                  FormatDateTime('yyyy-mm-dd',ADoc.Date));

   DocLst.Free;


end;

function TDocDataMgr.GetText: String;
Var
 aDoc : TDocData;
 i : Integer;

begin
   Result := '';
   For i:=0  To FDocList.Count-1 do
   Begin
       ADoc := FDocList.Items[i];
       Result := Result + #13#10 + ADoc.Text;
   End;
end;

procedure TDocDataMgr.SetText(const Value: String);
Var
  f : TStringList;
begin

   ClearDataDocList;

   f := TStringList.Create;
   f.Text := Value;
   GetDocDataStringList(f,FDocList);
   f.Free;
    
end;

procedure TDocDataMgr.FreeADoc(const GUID: String);
Var
  ADoc : TDocData;
begin

   ADoc := GetADoc(GUID);
   if ADoc=nil Then exit;
   FDocList.Remove(ADoc);
   ADoc.Destroy;

end;

function TDocDataMgr.GetANotGetMemoDoc(const GUID: String): TDocData;
Var
  ADoc:TDocData;
  i : Integer;
begin

  Result := nil;
  For i:=0 to FNotGetMemoDocList.Count-1 do
  Begin
     ADoc := FNotGetMemoDocList.Items[i];
     if ADoc.GUID=GUID Then
     Begin
         Result := ADoc;
         Break;
     End;
  End;

end;

procedure TDocDataMgr.FreeANotGetMemoDoc(const GUID: String);
Var
  ADoc : TDocData;
begin

   ADoc := GetANotGetMemoDoc(GUID);
   if ADoc=nil Then exit;
   FNotGetMemoDocList.Remove(ADoc);
   ADoc.Destroy;

end;

procedure TDocDataMgr.SetDocLstCBID(IDLst: TIDLstMgr);
Var
 aDoc : TDocData;
 i,j : Integer;
begin

   For i:=0  To FDocList.Count-1 do
   Begin
       ADoc := FDocList.Items[i];
       For j:=0 to IDLst.IDCount-1 do
       Begin
         if ADOC.ID = IDLst.IDItems[j] Then
         Begin
            ADOC.CBID := IDLst.CBIDItems[j];
            ADOC.CBName   := IDLst.CBNameItems[j];
            ADOC.CBStatus := IDLst.CBStatusItems[j];
            Break;
         End;
       ENd;
   End;
end;

Function TDocDataMgr.LoadLogDocFile(const ADate: String;const mode:Integer;const Option:Integer):String;
Var
  //f : TInifile;
  //ft : TextFile;
  FileStr : TStringList;
  //s : String;
  FileName : String;
  //Count,i : Integer;
  //DateStr : String;
begin

    //ClearLogDocList;

    Result := '';

    if mode=1 then
    begin
      if Option=0 Then
         FileName := FLogPath+'Doc1_'+ADate+'_Pass.log'
      Else
         FileName := FLogPath+'Doc1_'+ADate+'_Fail.log';
    end;

    if mode=2 then
    begin
      if Option=0 Then
         FileName := FLogPath+'Doc2_'+ADate+'_Pass.log'
      Else if Option=1 Then
         FileName := FLogPath+'Doc2_'+ADate+'_Fail.log'
      Else if Option=2 Then
         FileName := FLogPath+'Doc2_'+ADate+'_PassCancel.log'
      Else if Option=3 Then
         FileName := FLogPath+'Doc2_'+ADate+'_FailCancel.log';
    end;

    if mode=3 then
    begin
      if Option=0 Then
         FileName := FLogPath+'Doc3_'+ADate+'_Pass.log'
      Else
         FileName := FLogPath+'Doc3_'+ADate+'_Fail.log';
    end;


    if FileExists(FileName) Then
    Begin
      FileStr := TStringList.Create;
      FileStr.LoadFromFile(FileName);
      Result := FileStr.Text;
      FileStr.Free;
    End;
end;

procedure TDocDataMgr.ClearLogDocList;
Var
  ADoc:TDocData;
Begin

  While FLogDocList.Count>0 do
  Begin
     ADoc := FLogDocList.Items[0];
     ADoc.Destroy;
     FLogDocList.Delete(0);
  End;

end;

function TDocDataMgr.GetLogDocText: String;
Var
 aDoc : TDocData;
 i : Integer;

begin
   Result := '';
   For i:=0  To FLogDocList.Count-1 do
   Begin
       ADoc := FLogDocList.Items[i];
       Result := Result + #13#10 + ADoc.Text;
   End;
end;

procedure TDocDataMgr.SetLogDocText(const Value: String);
Var
  f : TStringList;
begin

   ClearLogDocList;

   f := TStringList.Create;
   f.Text := Value;
   GetDocDataStringList(f,FLogDocList);
   f.Free;

end;

procedure TDocDataMgr.ConvertToNewDocLst(const SourceLstFileName:String);
Var
  SourceDocLst : TStringList;
  DestDocLst : TStringList;
  Index,i,t1,t2  :  Integer;
  FileName,Str,StrDate : string;
begin

   //if Not FileExists(SourceLstFileName) Then Exit;

   FileName := ExtractFilePath(FTempDocFileName)+'doclst2.dat';

   DeleteFile(FileName);

   SourceDocLst := TStringList.Create;
   DestDocLst := TStringList.Create;

   Index := -1;
   SourceDocLst.LoadFromFile(ExtractFilePath(FTempDocFileName)+'doclst.dat');
   For i:=0 to SourceDocLst.Count-1 do
   Begin
        Str :=  SourceDocLst.Strings[i];
        if (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
        Begin
           DestDocLst.Add(Str);
           Index := 0;
        End Else
        Begin
           if Index>=0 Then
           if (Pos('=',Str)>0) and (Pos(',',Str)>0) and (Pos('/',Str)>0) Then
           Begin
               t1  := Pos('/',Str);
               t2  := Length(Str);
               StrDate := Copy(Str,t1+1,t2-t1);
               if StrDate>='2003-01-01' Then
               Begin
                   inc(Index);
                   t1  := Pos('=',Str);
                   t2  := Length(Str);
                   Str := Copy(Str,t1+1,t2-t1);
                   DestDocLst.Add(intToStr(Index)+'='+Str);
               End;
           End;
        End;
   End;

   SourceDocLst.Free;
   DestDocLst.SaveToFile(FileName);
end;

function TDocDataMgr.SaveToDocDatabase():Boolean;
Var
  ADoc:TDocData;
  i,j : Integer;
  List : Array[0..1] of TList;
  FileName : String;
Begin

  Result := False;

  List[0] := FDocList;
  List[1] := FNotGetMemoDocList;
  For j:=0 to High(List) do
  For i:=0 to List[j].Count-1 do
  Begin
     ADoc := List[j].Items[i];
     if (Length(ADoc.Memo)=0) or (Pos('DELETE',ADoc.Memo)>0) Then
        Continue;

     FileName := FDocPath+ADoc.FID + '.mdb';
     if Not FileExists(FileName) Then
        CopyFile(PChar(ExtractFilePath(Application.ExeName)+'Document.mdb'),PChar(FileName),False);

     if Not ADoc.SaveToDataBase(FileName) Then Exit;

  End;

  Result := True;


end;

procedure TDocDataMgr.LoadFromDataBase();
Var
  ADoc : TDocData;
  AQL  : TADOQuery;
  f :TStringList;
  FileName : String;
begin

   ClearDataDocList;
   AQL := Nil;
Try

   AQL  := TADOQuery.Create(nil);

   Aql.ConnectionString := FConnectString;
   Aql.SQL.Clear;
   Aql.SQL.Add(FQueryString);
   Aql.Open;

   FileName := FDocPath + 'Log\'+FDocAppID+'\'+FDocID+'.log';
   f := TStringList.Create;
   if FileExists(FileName) Then
     f.LoadFromFile(FileName);

   While Not Aql.Eof  Do
   Begin

      if Pos(Aql.FieldByName('DocGUID').AsString,f.Text)=0 Then
      Begin
        ADoc := TDocData.Create(Aql.FieldByName('DocGUID').AsString,
                                Aql.FieldByName('DocTitle').AsString,
                                Aql.FieldByName('DocStkID').AsString,
                                Aql.FieldByName('DocDate').AsFloat,
                                Aql.FieldByName('DocTime').AsFloat,
                                Aql.FieldByName('DocMemo').AsString,
                                Aql.FieldByName('DocURL').AsString);
         FDocList.Add(ADoc);
      End;

      Aql.Next;

   End;
   f.Free;

Finally
  if AQL<>nil Then
  Begin
     if AQL.Active  Then
        AQL.Close;
     AQL.Free;
  End;
End;

end;

Function TDocDataMgr.SetQueryData(const AppID,ID, WhereStr: String):Boolean;
Var
  FileName : String;
begin

   Result := false;

   FileName := FDocPath+ID + '.mdb';

   if not FileExists(FileName) Then exit;

   FDocAppID := AppID;
   FDocID := ID;
   FQueryString := 'Select * From DocData Where '+WhereStr;
   FConnectString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+FileName+
                     ';Jet OLEDB:Database Password=tr1';
   Result := True;

end;

procedure TDocDataMgr.SetChkDocIsOk(ADoc:TDocData;Const AppID:String);
Var
  FileName :  String;
  f : TextFile;
begin

    FileName := FDocPath + 'Log\'+AppID+'\'+ADoc.ID+'.log';

    Mkdir_Directory(ExtractFilePath(FileName));

    AssignFile(f,FileName);
    FileMode:=2;
    if Not FileExists(FileName) Then
       ReWrite(f)
    Else
       Append(f);

    Writeln(f,ADoc.ID+'#'+ADoc.GUID+'#'+FormatDateTime('yyyy-mm-dd',Date));

    CloseFile(f);


end;

procedure TDocDataMgr.LoadFromDataBase2;
Var
  FileLst : _CStrLst;
  FileName : String;
  AQL  : TADOQuery;
  f : TStringList;
  i,j : Integer;
  StrLst : _CStrLst;
  ADoc : TDocData;
begin

   ClearDataDocList;

   Setlength(StrLst,0);
   AQL := Nil;
   f := nil;
Try

   AQL  := TADOQuery.Create(nil);

   FolderAllFiles(FDocPath + 'Log\'+FDocAppID+'\','.log',FileLst,false);

   For j:=0 to High(FileLst) do
   Begin
     FileName := FileLst[j];
     f := TStringList.Create;
     if FileExists(FileName) Then
       f.LoadFromFile(FileName);
     For i:=0 to f.Count-1 do
     Begin
         if Pos('#',f.Strings[i])>0 Then
         Begin
             if Pos(FSeekDate,f.Strings[i])>0 Then
             Begin
                StrLst := DoStrArray(f.Strings[i],'#');
                FileName := (FDocPath+StrLst[0]+'.mdb');
                Aql.ConnectionString  := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+FileName+
                                    ';Jet OLEDB:Database Password=tr1';
                Aql.SQL.Clear;
                Aql.SQL.Add('Select * From DocData Where DocGUID='''+StrLst[1]+'''');
                Aql.Open;
                if Not Aql.Eof Then
                Begin
                   ADoc := TDocData.Create(Aql.FieldByName('DocGUID').AsString,
                                           Aql.FieldByName('DocTitle').AsString,
                                           Aql.FieldByName('DocStkID').AsString,
                                           Aql.FieldByName('DocDate').AsFloat,
                                           Aql.FieldByName('DocTime').AsFloat,
                                           Aql.FieldByName('DocMemo').AsString,
                                           Aql.FieldByName('DocURL').AsString);
                   FDocList.Add(ADoc);
                End;
                Aql.Close;
             End;
         End;
     End;
   End;


   if Assigned(f) Then
   f.Free;

Finally
  if AQL<>nil Then
  Begin
     if AQL.Active  Then
        AQL.Close;
     AQL.Free;
  End;
End;

end;

function TDocDataMgr.SetQueryData2(const AppID,SeekDate: String): Boolean;
begin

   FDocAppID := AppID;
   FSeekDate := SeekDate;
   Result := True;

end;

procedure TDocDataMgr.LoadExistDocFromDocLstFile(const ID: string);
Var
  f : TStringList;
  DocLst : _CstrLst;
  Str,FileName : ShortString;
  i,t1,t2 : Integer;
  Index : Integer;
Begin

  ClearDataExistDocTitleList;

  Setlength(DocLst,0);

  //加入一個測試的字串,
  //因為這可以用來判斷現在正在進行檢查所有公告的的狀態
  FExistDocTitle.Add('TEST_TITLE');

  //FileName  := ExtractFilePath(FTempDocFileName) + 'DocLst.Dat';
  FileName := GetUploadDocLst;
  if Not FileExists(FileName) Then Exit;

  try

  f := TStringList.Create;
  f.LoadFromFile(FileName);

  index := Pos('['+ID+']',f.Text);
  if index>0 Then
  Begin
    index := index+Length('['+ID+']');
    f.Text:=Copy(f.text,index+1,Length(f.text)-index);
    for i:=0 to f.Count-1 do
    Begin
      Str := f.Strings[i];
      if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
          Break;
      if Pos(',',Str)>0 Then
      Begin
          t1 := Pos('=',Str);
          t2 := Length(Str);
          Str := Copy(Str,t1+1,t2-t1);
          DocLst := DoStrArray(Str,',');
          //DocLst := DoStrArray(DocLst[1],'/');
          //if High(DocLst)>=1 Then
            FExistDocTitle.Add(DocLst[1]);
      End;
    End;
  End;
  f.Free;
 
  Except
  End;

end;

{
function TDocDataMgr.StartCheckSearchAllDoc: Boolean;
Var
  NowTime : TTime;
begin

    NowTime := Now-Date;
    Result  := False;
    if (NowTime>=EnCodeTime(14,0,0,0)) and
       (NowTime<=EnCodeTime(23,59,0,0)) Then
     Result := True;

    if Result Then //還要確認應該上傳的公告已上傳完畢
      Result := (Not FolderExistFiles(ExtractFilePath(FTempDocFileName),'.ftp',''));

    if Result Then //還要確認應該上傳的公告已審核完畢
      Result := (Not FolderExistFiles(ExtractFilePath(FTempDocFileName),'.tmp','Doc_02'));

end;
}
procedure TDocDataMgr.ClearDataExistDocTitleList;
begin
  FExistDocTitle.Clear;
end;

function TDocDataMgr.NowActionIsCheckAllDoc: Boolean;
begin
    Result := FExistDocTitle.Count>0;
end;

function TDocDataMgr.AppendADoc(const Title, ID, DocType: String;
  const Date: TDate; const Time: TTime; const URL: String): TDocData;
Var
  ADoc:TDocData;
  ADoc2:TDocData;
  i : integer;
begin

  ADoc := TDocData.Create(False,Title,ID,DocType,Date,Time,'',URL);

  for i:=0 to FExistDocTitle.Count-1 do
  Begin

        if (ADoc.Title+'/'+FormatDateTime('yyyy-mm-dd',ADoc.FDate))
           =FExistDocTitle.Strings[i] Then
        Begin
           //表此標題已存在
          ADoc.Destroy;
          ADoc := Nil;
          Break;
        End;
  End;

  if Assigned(ADoc) Then
  Begin
   For i:=0 to  FNotGetMemoDocList.Count-1 do
   Begin
      ADoc2 := FNotGetMemoDocList.Items[i];
      if ADoc.DocExist(ADoc2) Then
      Begin
        ADoc.Destroy;
        ADoc := Nil;
        Break;
      End;
   End;
  End;




  if ADoc<>nil Then
     FDocList.Add(ADoc);

  //if Not ThisDocExists(ADoc) Then
  //   FDocList.Add(ADoc);
  //Else
  //Begin
  //   ADoc.Destroy;
  //   ADoc := Nil;
  //End;

  Result := ADoc;

end;

function TDocDataMgr.GetUploadDocLst: String;
begin
   //Result := ExtractFilePath(FTempDocFileName)+'doclst.dat';
   Result := FDocPath+'doclst.dat';
end;

procedure TDocDataMgr.LoadFromTempDocFile2;
Var
  f : TextFile;
  s : String;
  FileStr : TStringList;
  t1,t2,j,i : Integer;
  ADoc : TDocData;
  DelList : TList;

  DocLst : _CstrLst;
  Str : ShortString;
  Index : Integer;
Begin
Try
  ClearDataDocList;
  Setlength(DocLst,0);
  if Not FileExists(FNowTempDocFileName) Then Exit;

  FileStr := TStringList.Create;
  AssignFile(f,FNowTempDocFileName);
  FileMode := 0;
  Reset(F);
  While Not Eof(f) do
  Begin
      Readln(f,s);
      FileStr.Add(s);
  End;
  CloseFile(f);

  GetDocDataStringList(FileStr,FDocList);
  FileStr.Free;

  //----
   if FileExists(GetUploadDocLst) Then
   Begin
      DelList := TList.Create;
      FileStr := TStringList.Create;
      FileStr.LoadFromFile(GetUploadDocLst);

      For j:=0 to FDocList.Count-1 do
      Begin
         ADoc := FDocList.Items[j];
         index := Pos('['+ADoc.ID+']',FileStr.Text);
         if index>0 Then
         Begin
            index := index+Length('['+ADoc.ID+']');
            FileStr.Text:=Copy(FileStr.text,index+1,Length(FileStr.text)-index);
            for i:=0 to FileStr.Count-1 do
            Begin
               Str := FileStr.Strings[i];
               if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
                  Break;
               if Pos(',',Str)>0 Then
               Begin
                  t1 := Pos('=',Str);
                  t2 := Length(Str);
                  Str := Copy(Str,t1+1,t2-t1);
                  DocLst := DoStrArray(Str,',');
                  if (ADoc.Title+'/'+FormatDateTime('yyyy-mm-dd',ADoc.Date))
                     =DocLst[1] Then
                  Begin
                     DelList.Add(ADoc);
                     Break;
                  End;
               End;
             End;
         End;
      End;

      FileStr.Free;
      While DelList.Count>0 do
      Begin
          ADoc := DelList.Items[0];
          FDocList.Remove(ADoc);
          DelList.Delete(0);
          aDoc.Destroy;
      End;
      DelList.Free;
      if FDocList.Count=0 Then
      Begin
          DeleteFile(FNowTempDocFileName);
          FNowTempDocFileName := '';
      End;
  End;
  //---
Finally
End;
end;

procedure TDocDataMgr.OnGetFile(FileName: String);
begin
    //if Length(FNowTempDocFileName)>0 Then
    //   Exit;
    if Pos(FTempTag,ExtractFileName(FileName))>0 then
    Begin
      if Length(FNowTempDocFileName)=0 then
         FNowTempDocFileName := FileName
      Else Begin
        if FileAge(FileName)<FileAge(FNowTempDocFileName) Then
           FNowTempDocFileName := FileName;
      End;
    End;
end;

procedure TDocDataMgr.SaveDocToFinishIdx(ADoc: TDocData);
Var
 f : TStringList;
begin

 f := TStringList.Create;
Try
  f.Add(ADoc.FID+'='+ADoc.FTitle+'/'+FormatDateTime('yyyy-mm-dd',ADoc.FDate));
  f.SaveToFile(ExtractFilePath(FTempDocFileName)+FTempTag+'_'+ADoc.FID+'_'+Get_GUID8+'.idx');
Finally
  f.Free;
End;

end;

procedure TDocDataMgr.InitStockDocIdxLstDat;
Var
  Path,ID: String;
  i,index : Integer;
  f,FDocLst,StockDocIdxLst  : TStringList;
  Str:String;
begin

  Path := FDocPath + 'StockDocIdxLst\';
  if FileExists(Path+'StockDocIdxLst.dat') Then
     Exit;
  Mkdir_Directory(Path);

  f := nil;
  FDocLst := nil;
Try
Try

  f := TStringList.Create;
  FDocLst := TStringList.Create;
  StockDocIdxLst := TStringList.Create;

  f.LoadFromFile(FDocPath+'doclst.dat');
  ID := '';
  for index:=0 to f.Count-1 do
  Begin
    Str := f.Strings[index];
    if Pos('COUNT',Str)>0 Then
       Continue;
    if (Pos('[',Str)>0) and
       (Pos(']',Str)>0) and
       (Pos('=',Str)=0) and
       (Pos(',',Str)=0) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
              FDocLst.SaveToFile(Path+ID+'_DOCLST.dat');
              FDocLst.Clear;
              ID := '';
           End;
           ID := Str;
           FDocLst.Add('['+ID+']');
           StockDocIdxLst.Add('['+ID+']');
           //StockDocIdxLst.Add('GUID='+Get_GUID8);

           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
          if (Pos('=',Str)>0) and (Pos(',',Str)>0) and (Pos('/',Str)>0) Then
            FDocLst.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
     FDocLst.SaveToFile(Path+ID+'_DOCLST.dat');
  StockDocIdxLst.SaveToFile(Path+'StockDocIdxLst.dat');
Except
End;
Finally
  if Assigned(FDocLst) Then
     FDocLst.Free;
  if Assigned(f) Then
     f.Free;
  if Assigned(StockDocIdxLst) Then
     StockDocIdxLst.Free;
End;


end;

function TDocDataMgr.GetUploadStockDocLst(ID:String): String;
begin
   Result := FDocPath+'StockDocIdxLst\'+ID+'_DOCLST.dat';
end;

function TDocDataMgr.GetUploadStockDocIdxLst: String;
begin
   Result := FDocPath+'StockDocIdxLst\StockDocIdxLst.dat';
end;

procedure TDocDataMgr.ClearSysLog(aTag:string);
var
  LogFileLst : _CStrLst;
  i:integer; aDt:TDate; sLine:string;
begin
try
  if FCheckDocLogSaveDays<=0 then
    exit;
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\CheckDocLog\',
                 '.log',LogFileLst,false);
                 
  For i:=0 To High(LogFileLst)Do
  Begin
    sLine:=ExtractFileName(LogFileLst[i]);
    if Pos(aTag,sLine)>0 then
    begin
      if Pos('DOC',UpperCase(sLine))=1 then
        aDt:=StrToDate('20'+Copy(sLine,6,2)+DateSeparator
                 +Copy(sLine,8,2)+DateSeparator
                 +Copy(sLine,10,2))
      else
        aDt:=StrToDate('20'+Copy(sLine,1,2)+DateSeparator
                 +Copy(sLine,3,2)+DateSeparator
                 +Copy(sLine,5,2));
               
      if(DaysBetween(aDt,Date)>FCheckDocLogSaveDays)then
      //if(DaysBetween(FileDateToDate(FileAge(FileName)),Date)>30)then
      DeleteFile(LogFileLst[i]);
    end;
  End;
except
end;
end;

{ TDocMgrParam }

constructor TDocMgrParam.Create;
begin
    Init(ExtractFilePath(Application.ExeName)+'Setup.ini');
end;

function TDocMgrParam.IsTwSys:boolean;
begin
  result:=FCharset='CHINESEBIG5_CHARSET';
  //result:=True;
end;

function TDocMgrParam.ConvertString(const Msg: String): String;
begin
  Result := Msg;
  if FCharset='CHINESEBIG5_CHARSET' Then
     Result := GBToBig5(Msg);
end;

Function TDocMgrParam.TwConvertStr(Const Msg:String):String;
begin
  Result := Msg;
  if FCharset='GB2312_CHARSET' Then
     Result := Big5ToGB2(Msg);
end;

Function TDocMgrParam.TwConvertStr2(Const Msg:String):String;
begin
  Result := Msg;
  if FCharset='GB2312_CHARSET' Then
     Result := Big5ToGB(Msg);
end;

Function TDocMgrParam.ToTwIfCnSys(Const Msg:String):String;
begin
  Result := Msg;
  if FCharset='GB2312_CHARSET' Then
     Result := GBToBig5(Msg);
end;

Function TDocMgrParam.TwToGBConvertStr(Const Msg:String):String;
begin
  Result := Big5ToGB2(Msg);
end;

function TDocMgrParam.ConvertStringGB(Msg: String): String;
begin
  Try
   if FCharset='CHINESEBIG5_CHARSET' Then
     Result := CBIG5ToGB(Msg)
   Else
     Result := Msg;
  except
  end;
end;

constructor TDocMgrParam.Create(const FileName: String);
begin
   Init(FileName);
end;

destructor TDocMgrParam.Destroy;
begin

  //inherited;
end;

function TDocMgrParam.GetCaptionKeyWord(index: integer): String;
begin
    Result := FCaptionKeyWord[index];
end;

function TDocMgrParam.GetCaptionKeyWordCount: integer;
begin
   Result := High(FCaptionKeyWord)+1;
end;

function TDocMgrParam.GetMarketKeyWord(index: integer): String;
begin
    Result := FMarkKeyWord[index];
end;

function TDocMgrParam.GetMarketKeyWordCount: integer;
begin
   Result := High(FMarkKeyWord)+1;
end;

procedure TDocMgrParam.Init(const FileName: String);
Var
 iniFile : TiniFile;
 i,Count,Count1,Count2,j : Integer;
begin

    iniFile    := TiniFile.Create(FileName);
    FCheckDocLogSaveDays_NiFang:=inifile.ReadInteger('Config','CheckDocLogSaveDays_NiFang',30);
    FCheckDocLogSaveDays_GuoHui:=inifile.ReadInteger('Config','CheckDocLogSaveDays_GuoHui',30);
    FCheckDocLogSaveDays_ShangShi:=inifile.ReadInteger('Config','CheckDocLogSaveDays_ShangShi',30);

    FCharSet :=inifile.ReadString('Config','Charset','GB2312_CHARSET');

    FDwnMemo :=StrToInt(inifile.ReadString('Config','DwnMemo','0')); //--Doc3.2.0需求3 huangcq080928 add
    FAutoDelManualBackupTmpFile :=IntToBool(inifile.ReadInteger('Config','AutoDelManualBackupTmpFile',0)); //--Doc3.2.0需求3 huangcq080928 add

    //--DOC4.0.0—N001 huangcq090407------>
    FDocMonitorBeepCodeErrorMsg := inifile.ReadString('DocMonitor','BeepCodeErrorMsg','1234');
    FDocMonitorBeepWhenError := IntToBool(StrToInt(inifile.ReadString('DocMonitor','BeepWhenError','1')));
    FDocMonitorPort := StrToInt(inifile.ReadString('DocMonitor','Port','56'));
    FDocMonitorHostName := inifile.ReadString('DocMonitor','HostName','LocalHost');
    FDocMonitorStartOtherApp := IntToBool(StrToInt(inifile.ReadString('DocMonitor','StartOtherApp','1')));
    FDocMonitorCloseOtherApp := IntToBool(StrToInt(inifile.ReadString('DocMonitor','CloseOtherApp','1')));
    FDocMonitorAutoStart := IntToBool(StrToInt(inifile.ReadString('DocMonitor','AutoStart','1')));
    FDocMonitorMessage := IntToBool(StrToInt(inifile.ReadString('DocMonitor','Message','1')));
    FDocMonitorError := IntToBool(StrToInt(inifile.ReadString('DocMonitor','Error','1')));
    FDocMonitorWarning := IntToBool(StrToInt(inifile.ReadString('DocMonitor','Warning','1')));
    //<-----DOC4.0.0—N001 huangcq090407---
    //--DOC4.0.0—N002 huangcq090617------>
    FDocCenterSktPort := StrToInt(inifile.ReadString('Config','DocCenterSktPort','57'));
    //<--DOC4.0.0—N002 huangcq090617--

    FTr1DBPath :=inifile.ReadString('Config','Tr1DBPath','');
    FRateDatPath:=FTr1DBPath+'RateData\';

    FDocServer :=inifile.ReadString('Config','DocServer','LocalHost');
    FGetNeverCheckDoc :=IntToBool(inifile.ReadInteger('Config','GetNeverCheckDoc',1));

    FCaption  :=inifile.ReadString('Config','Caption','');

    FNameTblServer := inifile.ReadString('Config','NameTblServer','');

    FSoundPort := StrToInt(inifile.ReadString('Config','SoundPort','59'));
    FSoundServer := inifile.ReadString('Config','SoundServer','LocalHost');

    FFTPTr1DBPath :=inifile.ReadString('TR1DBPath','Tr1DBPath','');

    FCBFTPPort := StrToInt(inifile.ReadString('CBFtp','Port','21'));
    FCBFTPServer := inifile.ReadString('CBFtp','Server','LocalHost');
    FCBFTPUploadDir := inifile.ReadString('CBFtp','UploadDir','');
    FCBFTPUserName  := inifile.ReadString('CBFtp','UserName','');
    FCBFTPPassword  := inifile.ReadString('CBFtp','Password','');
    FCBFTPPassive   := IntToBool(StrToInt(inifile.ReadString('CBFtp','Passive','1')));

    FCBFTP2Port := StrToInt(inifile.ReadString('CBFtp2','Port','21'));
    FCBFTP2Server := inifile.ReadString('CBFtp2','Server','LocalHost');
    FCBFTP2UploadDir := inifile.ReadString('CBFtp2','UploadDir','');
    FCBFTP2UserName  := inifile.ReadString('CBFtp2','UserName','');
    FCBFTP2Password  := inifile.ReadString('CBFtp2','Password','');
    FCBFTP2Passive   := IntToBool(StrToInt(inifile.ReadString('CBFtp2','Passive','1')));
    //Doc_Ftp-doc2.3.0需求8-libing-2007/9/19
    //*******************************获取CB资料上传服务器数目
    FCBFTPCount:=iniFile.ReadInteger('CBFTP_COUNT','Count',0);
    SetLength(FCBFTPInfos,FCBFTPCount);
    for i:=0 to FCBFTPCount-1 do
    begin
      FCBFTPInfos[i].FFTPPort := StrToInt(inifile.ReadString('CBFTP_'+IntToStr(i+1),'Port','21'));
      FCBFTPInfos[i].FFTPServer := inifile.ReadString('CBFTP_'+IntToStr(i+1),'Server','LocalHost');
      FCBFTPInfos[i].FFTPUploadDir := inifile.ReadString('CBFTP_'+IntToStr(i+1),'UploadDir','');
      FCBFTPInfos[i].FFTPUserName  := inifile.ReadString('CBFTP_'+IntToStr(i+1),'UserName','');
      FCBFTPInfos[i].FFTPPassword  := inifile.ReadString('CBFTP_'+IntToStr(i+1),'Password','');
      FCBFTPInfos[i].FFTPPassive   := IntToBool(StrToInt(inifile.ReadString('CBFTP_'+IntToStr(i+1),'Passive','1')));
    end;
    //*************************************

    //-------------------读取服务器信息
    FDocFTPCount := inifile.ReadInteger('DOCFTP_COUNT','Count',0);
    SetLength(FDocFTPInfos,FDocFTPCount);
    for i:=0 to FDocFTPCount-1 do
    begin
      FDocFTPInfos[i].FFTPPort := StrToInt(inifile.ReadString('DOCFTP_'+IntToStr(i+1),'Port','21'));
      FDocFTPInfos[i].FFTPServer := inifile.ReadString('DOCFTP_'+IntToStr(i+1),'Server','LocalHost');
      FDocFTPInfos[i].FFTPUploadDir := inifile.ReadString('DOCFTP_'+IntToStr(i+1),'UploadDir','');
      FDocFTPInfos[i].FFTPUserName  := inifile.ReadString('DOCFTP_'+IntToStr(i+1),'UserName','');
      FDocFTPInfos[i].FFTPPassword  := inifile.ReadString('DOCFTP_'+IntToStr(i+1),'Password','');
      FDocFTPInfos[i].FFTPPassive   := IntToBool(StrToInt(inifile.ReadString('DOCFTP_'+IntToStr(i+1),'Passive','1')));
    end;

    FRateDatInterval:=inifile.ReadInteger('RateDat','Interval',5);
    FRateDatInterval2:=inifile.ReadInteger('RateDat','IntervalForSwap',5);
    FRateDatFTPCount:=inifile.ReadInteger('RateDatFTP_COUNT','Count',0);
    SetLength(FRateDatFTPInfos,FRateDatFTPCount);
    for i:=0 to FRateDatFTPCount-1 do
    begin
      FRateDatFTPInfos[i].FFTPPort := StrToInt(inifile.ReadString('RateDatFTP_'+IntToStr(i+1),'Port','21'));
      FRateDatFTPInfos[i].FFTPServer := inifile.ReadString('RateDatFTP_'+IntToStr(i+1),'Server','LocalHost');
      FRateDatFTPInfos[i].FFTPUploadDir := inifile.ReadString('RateDatFTP_'+IntToStr(i+1),'UploadDir','');
      FRateDatFTPInfos[i].FFTPUserName  := inifile.ReadString('RateDatFTP_'+IntToStr(i+1),'UserName','');
      FRateDatFTPInfos[i].FFTPPassword  := inifile.ReadString('RateDatFTP_'+IntToStr(i+1),'Password','');
      FRateDatFTPInfos[i].FFTPPassive   := IntToBool(StrToInt(inifile.ReadString('RateDatFTP_'+IntToStr(i+1),'Passive','1')));
    end;

    FTr1DbPath := IncludeTrailingBackslash(FTr1DBPath);
    FFTPTr1DbPath := IncludeTrailingBackslash(FFTPTr1DBPath);

    Count := inifile.ReadInteger('MarkKeyWord','Count',0);
    SetLength(FMarkKeyWord,Count);
    for i:=1 to Count do
      FMarkKeyWord[i-1] := inifile.ReadString('MarkKeyWord',IntToStr(i),'');

    Count := inifile.ReadInteger('CaptionKeyWord','Count',0);
    SetLength(FCaptionKeyWord,Count);
    for i:=1 to Count do
      FCaptionKeyWord[i-1] := inifile.ReadString('CaptionKeyWord',IntToStr(i),'');

     //add by wangjinhua 0306
    FDoc01_OKSleepTime := inifile.ReadInteger('CONFIG','Doc01_OKSleepTime',600);
    FDoc01_ErrSleepTime := inifile.ReadInteger('CONFIG','Doc01_ErrSleepTime',5);
    FDoc01_WaitForWeb := inifile.ReadInteger('CONFIG','Doc01_WaitForWeb',30);
    //--

    //add by wangjinhua 20090602 Doc4.3
      FRunMode := inifile.ReadInteger('CONFIG','RunMode',1);

      FUserMngModouleListCount := inifile.ReadInteger('CBDataEditModouleList','Count',0);
      SetLength(FUserMngModouleList,0);
      SetLength(FUserMngModouleList,FUserMngModouleListCount);
      for i := 0 to FUserMngModouleListCount - 1 do
        FUserMngModouleList[i] := inifile.ReadString('CBDataEditModouleList',IntToStr(i+1),'');

      Count1:=inifile.ReadInteger('CBDataBtnKeyWordList','Count',0);
      Count2:=inifile.ReadInteger('CBDataEditKeyWordList','Count',0);
      FUserMngBtnKeyWordListCount := Count1+Count2;
      SetLength(FUserMngBtnKeyWordList,0);
      SetLength(FUserMngBtnKWList,0);
      SetLength(FUserMngBtnKeyWordList,FUserMngBtnKeyWordListCount);
      SetLength(FUserMngBtnKWList,Count1);
      j := 0;
      for i := 1 to Count1 do
      begin
        FUserMngBtnKeyWordList[j] := inifile.ReadString('CBDataBtnKeyWordList',IntToStr(i),'');
        FUserMngBtnKWList[j] := FUserMngBtnKeyWordList[j];
        Inc(j);
      end;
      for i := 1 to Count2 do
      begin
        FUserMngBtnKeyWordList[j] := inifile.ReadString('CBDataEditKeyWordList',IntToStr(i),'');
        Inc(j);
      end;


      Count1:=inifile.ReadInteger('Doc01Text_Parse','Count',0);
      SetLength(FDoc01TextParseTokens,Count1*2);
      j:=0;
      for i:=1 to Count1 do
      begin
        FDoc01TextParseTokens[j] :=
                inifile.ReadString('Doc01Text_Parse',Format('%d_Start',[i]),'');
        FDoc01TextParseTokens[j+1] :=
                inifile.ReadString('Doc01Text_Parse',Format('%d_End',[i]),'');
        j:=j+2;
      end;

//--
    //add by wjh 2011-10-14
    FDoc03PageSum := inifile.ReadInteger('Config','Doc03_PageSum',5);
    FDoc03_OKSleepTime := inifile.ReadInteger('Config','Doc03_OKSleepTime',300);
    FDoc03_ErrSleepTime := inifile.ReadInteger('Config','Doc03_ErrSleepTime',5);
    FDoc03BeforeM := inifile.ReadInteger('Config','Doc03BeforeMonth',3);
    //--
    FTodayHintListenPort := inifile.ReadInteger('TodayHint','ListenPort',7077);
    iniFile.Free;

end;

//add by wangjinhua 20090602 Doc4.3
function TDocMgrParam.GetUserMngModoule(index: integer): String;
begin
    Result := FUserMngModouleList[index];
end;

function TDocMgrParam.GetUserMngBtnKeyWord(index: integer): String;
begin
    Result := FUserMngBtnKeyWordList[index];
end;
//--

function TDocMgrParam.GetFDocFTPInfos(index: integer): TFTPINFO;
begin
  Result := FDocFTPInfos[index];
end;

function TDocMgrParam.GetFCBFTPInfos(index: integer): TFTPINFO;
begin
  Result:=FCBFTPInfos[index];
end;

function TDocMgrParam.GetFRateDatFTPInfos(index: integer): TFTPINFO;
begin
  Result:=FRateDatFTPInfos[index];
end;

procedure TDocMgrParam.Refresh; //<-----DOC4.0.0—N001 huangcq090407 add
begin
  Init(ExtractFilePath(Application.ExeName)+'Setup.ini');
end;

{ TDocManualMgr }

constructor TDocManualMgr.Create(const TempDocFileName,
  DocDataPath: String);
begin
   FOutPutDataPath      := DocDataPath;
   FOutPutHtmlPath      := FOutPutDataPath+'Html\';
   FDwnTitleTxtPath     := FOutPutHtmlPath+'DocTxt\DwnTitleTxt\';
   FDwnFailTitleTxtPath := FOutPutHtmlPath+'DocTxt\DwnFailTitleTxt\';

   FManualLogPath       := FOutPutDataPath+'DwnDocLog\Doc_ByManual\Log\';
   FManualBackupTmpFilePath := FOutPutDataPath+'DwnDocLog\Doc_ByManual\DataBackup\';
   Mkdir_Directory(FManualLogPath);
   Mkdir_Directory(FManualBackupTmpFilePath);

   FTempDocFileName     := TempDocFileName;
   FTempTag := ChangeFileExt(ExtractFileName(FTempDocFileName),'');
   FDelBackupTmpLogName:=FTempTag+'_DelBackupTmp.log';

end;

function TDocManualMgr.SetDocManual(ManualDocTxtLst: TStringList): Boolean;
begin
  Result:=False;
  if SaveToDocTmpFile(ManualDocTxtLst) then //保存接收内容到tmp文件
  begin
    SetText(ManualDocTxtLst.Text); //分析得到FID FTItle FDate FURL 

    SetDwnTitleTxt; //更新待下载的ID_Title.txt
    SetDwnFailTitleTxt; //更新下载失败的ID_Title.txt
    SetIdxFile;//更新Doc_02.idx文件

    SaveToDocBackupTmpFile;//备份tmp文件
    SetManualLogText;//保存Log文件
    Result:=True;
  end;
end;

function TDocManualMgr.SaveToDocTmpFile(ManualDocTxtLst:TStringList): Boolean;
begin
  Result:=False;
  if ManualDocTxtLst.Count>0 then
  begin
    FNewDocTmpFileName:=GetNewDocTmpFileName;
    ManualDocTxtLst.SaveToFile(FNewDocTmpFileName);
    Result:=True;
  end;
end;

function TDocManualMgr.SaveToDocBackupTmpFile: Boolean;
var
  lDestFile,lSourceFile:String;
  i:Integer;
begin
  try
    Result:=True;

    FDocBackupTmpFileName :=ExtractFileName(FNewDocTmpFileName);
    lSourceFile :=FNewDocTmpFileName;
    lDestFile:=ExtractFilePath(FManualBackupTmpFilePath) + FDocBackupTmpFileName;
    i:=0;
    While FileExists(lDestFile) do
    begin
      Inc(i);
      FDocBackupTmpFileName:=ChangeFileExt(ExtractFileName(FNewDocTmpFileName),'')
                                +'_'+IntToStr(i)+'.tmp';
      lDestFile :=ExtractFilePath(FManualBackupTmpFilePath) + FDocBackupTmpFileName;
    end;
    CopyFile(PChar(lSourceFile),PChar(lDestFile),False);
  except
    Result:=False;
    raise Exception.Create('ManualDocBackupTmpFile'+' Error');
  end;
end;

Function TDocManualMgr.GetManualBackupTmpFile(pTmpFileName:String):String;
var
  lBackupTmpFileName:string;
  lFileStrLst:TStringList;
begin
  Result:='';
  lFileStrLst:=nil;
  
  lBackupTmpFileName:=ExtractFilePath(FManualBackupTmpFilePath)+pTmpFileName;
  if Not FileExists(lBackupTmpFileName) then exit;
  try
    lFileStrLst:=TStringList.Create;
    lFileStrLst.LoadFromFile(lBackupTmpFileName);
    Result:=lFileStrLst.Text;
  finally
    if Assigned(lFileStrLst) then
      lFileStrLst.Free;
  end;
end;

Function TDocManualMgr.DelManualBackupTmpFile(BeginAndEndDate:String):String;
begin
  Result:='';
  try
    ClearTheSuccessDelTmpFileLog;//先将上次删除成功的信息(放在DelBackupTmp.log)删除掉
    GetTheDelTmpFileList(BeginAndEndDate);//根据删除期间搜寻Log，得到删除列表(放在DelBackupTmp.log)
    DelByTheTmpFileList;//根据列表DelBackupTmp.log，删除对应文件，并记录删除结果
    Result:=ReturnTheDelTmpFileLog;//返回DelBackupTmp.log文件的内容
  except
    On E:Exception do
      Raise Exception.Create('DelManualBackupTmpFile '+E.Message);
  end;
end;

//先将上次删除成功的信息(在DelBackupTmpFile.log)删除掉
Procedure TDocManualMgr.ClearTheSuccessDelTmpFileLog();
var
  AFileName:String;
  ADelFileLst,ADelResultLst:TStringList;
  i:Integer;
  AFile:TIniFile;
begin
  ADelFileLst:=nil;
  ADelResultLst:=nil;
  AFileName:=ExtractFilePath(FManualLogPath)+FDelBackupTmpLogName;
  If Not FileExists(AFileName) then exit;
  try
    ADelFileLst:=TStringList.Create;
    ADelResultLst:=TStringList.Create;
    AFile:=TIniFile.Create(AFileName);
    AFile.ReadSection('DelFileLst',ADelFileLst); //key
    AFile.ReadSectionValues('DelFileLst',ADelResultLst); //key=value

    For i:=0 to ADelFileLst.Count-1 do
    begin
      if ADelResultLst.Values[ADelFileLst[i]]='1' then //删除成功的记录去掉
        AFile.DeleteKey('DelFileLst',ADelFileLst[i]);
    end;
    AFile.WriteString('DelResult','OkCount','0');
  finally
    if Assigned(ADelFileLst) then ADelFileLst.Free;
    if Assigned(ADelResultLst) then ADelResultLst.Free;
    if Assigned(AFile) then AFile.Free;
  end;
end;

//根据删除期间搜寻Log，得到删除列表(放在DelBacupTmpFile.log)
Function TDocManualMgr.GetTheDelTmpFileList(BeginAndEndDate:String):Boolean;
var
  ABeginDate,AEndDate:TDate;
  AManualLogFile:String;
  i,ADateDiff:Integer;
begin
  Result:=False;
   //内容为'AutoDel'时，表示自动删除，保留近半个月内的备份文件即可
  if Pos('autodel',LowerCase(BeginAndEndDate))>0 then
    Result:=GetDelFileLstByAuto
  else  //BeginAndEndDate的数据格式是:yyyymmdd~yyyymmdd
    Result:=GetDelFileLstByBeginEndDate(BeginAndEndDate);
end;

Function TDocManualMgr.GetDelFileLstByAuto():Boolean;
var
  AcStrLst:_cStrLst;
  i,ADateDiff:Integer;
  ASep:ShortString;
  AFileName,ALogDateStr:String;
  ALogDate:TDateTime;
begin
  Result:=False;
  FolderAllFiles(ExtractFilePath(FManualLogPath),'.log',AcStrLst,false);
  For i:=0 to High(AcStrLst) do
  begin
    AFileName:=ExtractFileName(AcStrLst[i]);
    if Pos(LowerCase(FDelBackupTmpLogName),LowerCase(AFileName))>0 then //Doc_02_DelBackupTmp.log时跳过
      Continue; 
    ALogDateStr:=Copy(AFileName,Length(FTempTag)+2,Length('yyyymmdd')); //Doc_02_20081205.log
    try
      ASep:=DateSeparator;
      Insert(Asep,ALogDateStr,5); //yyyymmdd --> yyyy-mmdd
      Insert(ASep,ALogDateStr,8); //yyyy-mmdd -->yyyy-mm-dd
      if not TryStrToDate(ALogDateStr,ALogDate) then Continue; //不是时间的则跳过
      ADateDiff:=DaysBetween(ALogDate,Now);
      if ADateDiff >15 then AddTmpToFileList(AcStrLst[i]); //保留15日内的
    except
      On E:Exception do
        Raise Exception.Create(e.Message);
    end;
  end; //end For
  SetLength(AcStrLst,0);
  Result:=True;
end;

Function TDocManualMgr.GetDelFileLstByBeginEndDate(BeginAndEndDate:String):Boolean;
var
  ABeginDate,AEndDate:TDate;
  AManualLogFile:String;
  i,ADateDiff:Integer;
begin
  Result:=False;
  //BeginAndEndDate的数据格式是:yyyymmdd~yyyymmdd
  ABeginDate:=StrToDate(Copy(BeginAndEndDate,0,4)+DateSeparator+
                        Copy(BeginAndEndDate,5,2)+DateSeparator+
                        Copy(BeginAndEndDate,7,2));
  AEndDate:=StrToDate(Copy(BeginAndEndDate,10,4)+DateSeparator+
                      Copy(BeginAndEndDate,14,2)+DateSeparator+
                      Copy(BeginAndEndDate,16,2));
  ADateDiff:=DaysBetween(ABeginDate,AEndDate);

  For i:=0 to ADateDiff do //搜寻在ABeginDate与AEndDate之间的Log文件
  begin
    AManualLogFile:=ExtractFilePath(FManualLogPath)+FTempTag+'_'+FormatDateTime('yyyymmdd',ABeginDate+i)+'.log';
    if FileExists(AManualLogFile) then
      AddTmpToFileList(AManualLogFile);
  end;
  Result:=True;
end;

Function TDocManualMgr.AddTmpToFileList(ManualLogFile:String):Boolean; //将Log中对应Tmp备份文件写入到列表中
var
  AFileName:String;
  AFileStrLst:TStringList;
  i:Integer;
  AcStr:_cStrLst;
  AFile:TIniFile;
begin
  Result:=False;
  AFileStrLst:=nil;
  AFileName:=ExtractFilePath(FManualLogPath)+FDelBackupTmpLogName;
  //AValue:='0,'+FormatDateTime('yyyymmdd',Now);
  try
    AFileStrLst:=TStringList.Create;
    AFile:=TIniFile.Create(AFileName);
    AFileStrLst.LoadFromFile(ManualLogFile);
    AFile.WriteString('DelFileLst',ExtractFileName(ManualLogFile),'0');//LogFileName=0这样形式写入
    For i:=0 to AFileStrLst.Count-1 do
    begin
      AcStr:=DoStrArray(AFileStrLst[i],#9);
      if High(AcStr)>=5 then //公告录入的Log里第6个是备份文件名
        AFile.WriteString('DelFileLst',AcStr[5],'0');//TmpFileName=0这样的形式写入
    end;
    Result:=True;
  finally
    If Assigned(AFileStrLst) then AFileStrLst.Free;
    If Assigned(AFile) then AFile.Free;
  end;
end; 

//根据列表DelBackupTmpFile.log，删除对应文件，并记录删除结果
Function TDocManualMgr.DelByTheTmpFileList():Boolean;
var
  AFile:TIniFile;
  AFileNameDelTmpLog,AFileName:String;
  //AValueOk,AValueFail:String;
  AFileLst:TStringList;
  i,AOkCount,AFailCount:Integer;
begin
  Result:=False;
  AFileLst:=nil;
  AFileNameDelTmpLog:=ExtractFilePath(FManualLogPath)+FDelBackupTmpLogName;
  //AValueOk:='1,'+FormatDateTime('yyyymmdd',Now);
  //AValueFail:='0,'+FormatDateTime('yyyymmdd',Now);
  AOkCount:=0;
  AFailCount:=0;
  try
    try
      AFile:=TIniFile.Create(AFileNameDelTmpLog);
      AFileLst:=TStringList.Create;
      AFile.ReadSectionValues('DelFileLst',AFileLst);
      For i:=0 to AFileLst.Count-1 do
      begin
        AFileName:=Copy(AFileLst[i],0,Pos('=',AFileLst[i])-1);
        if LowerCase(ExtractFileExt(AFileName))='.log' then
          AFileName:=ExtractFilePath(FManualLogPath)+AFileName  //公告录入Log文件的全称
        else if LowerCase(ExtractFileExt(AFileName))='.tmp' then
          AFileName:=ExtractFilePath(FManualBackupTmpFilePath)+AFileName; //Tmp备份文件的全称

        try
          if not FileExists(AFileName) then
          begin
            AFile.WriteString('DelFileLst',ExtractFileName(AFileName),'1'); // FileName=1 AValueOk
            Inc(AOkCount);
            Continue;
          end;
          if DeleteFile(AFileName) then  //DeleteFile:if file is not exists then would return false;
          begin
            AFile.WriteString('DelFileLst',ExtractFileName(AFileName),'1'); // FileName=1
            Inc(AOkCount);
          end
          else begin
            AFile.WriteString('DelFileLst',ExtractFileName(AFileName),'0'); // FileName=0
            Inc(AFailCount);
          end;
        except
          on E:Exception do
          Raise Exception.Create(E.Message);
        end;
      end; //end for

      AFile.WriteString('DelResult','DelDate',FormatDateTime('yyyymmdd',Now));
      AFile.WriteString('DelResult','OkCount',IntToStr(AOkCount));
      AFile.WriteString('DelResult','FailCount',IntToStr(AFailCount));
      Result:=True;
    finally
      AFile.Free;
      If Assigned(AFileLst) then AFileLst.Free;
    end;
  except
    On E:Exception do
    Raise Exception.Create(E.Message);
  end;
end;

//返回DelBackupTmpFile.log文件的内容
Function TDocManualMgr.ReturnTheDelTmpFileLog():String;
var
  AFileLst:TStringList;
  AFileNameDelTmpLog:String;
begin
  Result:='';
  AFileLst:=nil;
  AFileNameDelTmpLog:=ExtractFilePath(FManualLogPath)+FDelBackupTmpLogName;
  if not FileExists(AFileNameDelTmpLog) then exit; 
  try
    AFileLst:=TStringList.Create;
    AFileLst.LoadFromFile(AFileNameDelTmpLog);
    Result:=AFileLst.Text;
  finally
    if Assigned(AFileLst) then AFileLst.Free;
  end;
end; 

procedure TDocManualMgr.SetText(const Value: String);
Var
  s : String;
  GetID : Boolean;
  FileStr : TStringList;
  i :  integer;
begin
  try
    GetID := False;
    FileStr := TStringList.Create;
    FileStr.Text := Value;
    i := -1;
    While True do
    Begin
        Inc(i);
        If i>=FileStr.Count Then Break;

        S := FileStr.Strings[i];
        S := FileStr.Strings[i];
        if Pos('<ID=',UpperCase(S))>0 Then
        Begin
             ReplaceSubString('<','',S);
             ReplaceSubString('ID','',S);
             ReplaceSubString('=','',S);
             ReplaceSubString('>','',S);
             FID := Trim(s);
             GetID := True;
             Continue;
        End;

        if GetID Then
        Begin
            if Pos('</ID>',UpperCase(S))>0 Then
               GetID := False;

            if Pos('<URL>',UpperCase(S))>0 Then
            Begin
              FUrl := GetSection(i,FileStr,'</URL>');
              Continue;
            End;
            if Pos('<TITLE>',UpperCase(S))>0 Then
            Begin
              FTitle := GetSection(i,FileStr,'</TITLE>');
              Continue;
            End;
            if Pos('<DATE>',UpperCase(S))>0 Then
            Begin
              FDate:= StrToFloat(GetSection(i,FileStr,'</DATE>'));
              Continue;
            End;
        End;
    End; //end While True do
    FileStr.Free;
  except
    Raise Exception.Create('ManualSetText Error');
  end;
end;

function TDocManualMgr.SetDwnTitleTxt: Boolean; //更新待下载的ID_Title.txt
begin
  Result:=SetTitleTxt(FID,FTitle,FDwnTitleTxtPath,FDate);
end;

function TDocManualMgr.SetDwnFailTitleTxt: Boolean; //更新下载失败的ID_Title.txt
begin
  Result:=SetTitleTxt(FID,FTitle,FDwnFailTitleTxtPath,FDate);
end;

//如Doc_02.idx不存在则创建; 存在则将相同ID对应的Title+'/'+Date比较，不存在该记录则加入
function TDocManualMgr.SetIdxFile: Boolean;
var
  lFileIdxLst:TStringList;
  lIdxFileName, lTempStr1,lTempStr2:String;
  lIdxTextFile:TextFile;
  i,j:Integer;
  lNeedWrite:Boolean;
begin
  Result:=True;
  lNeedWrite:=True;
  lFileIdxLst:=nil;
  try
    try
      lTempStr1:=FTitle+'/'+FormatDateTime('yyyy-mm-dd',FDate);
      lIdxFileName:=ExtractFilePath(FOutPutDataPath) + FTempTag +'.idx'; //如D:\Data\Doc_02.idx

      AssignFile(lIdxTextFile,lIdxFileName);

      if not FileExists(lIdxFileName) then //不存在则创建
      begin
        ReWrite(lIdxTextFile);
        Writeln(lIdxTextFile,FID+'='+lTempStr1);
        CloseFile(lIdxTextFile);
        lNeedWrite:=False;
        exit;
      end else
      begin    //idx文件存在的
        lFileIdxLst:=TStringList.Create;
        lFileIdxLst.LoadFromFile(lIdxFileName);
        i:=0;
        While i<lFileIdxLst.Count do
        begin
          lTempStr2:=lFileIdxLst.Strings[i];
          j:=Pos('=',lTempStr2);
          if j>0 then
          begin
            if Copy(lTempStr2,1,j-1)=FID then //先判断ID以减少比对次数提高效率
              if Copy(lTempStr2,j+1,Length(lTempStr2)-j) = lTempStr1 then
              begin
                 lNeedWrite:=False; //存在该录入记录，则不需要再写入该记录
                 Break;
              end;
          end;//end j>0
          Inc(i);
        end;//end while i<lFileIdxLst
      end; //end if not FileExists

      if lNeedWrite then //存在文件且记录不存在的
      begin
        Append(lIdxTextFile);
        Writeln(lIdxTextFile,FID+'='+lTempStr1);
        CloseFile(lIdxTextFile);
      end;
    except
      Result:=False;
      Raise Exception.Create('ManualSet'+FTempTag+'.idx'+' Error');
    end; //end try except
  finally
    if Assigned(lFileIdxLst) then
      lFileIdxLst.Destroy;
  end; //end try finally
end;

function TDocManualMgr.GetManualLogText(pLogName:String): String;
var
  lLogFileName:String;
  lLogStrLst:TStringList;
begin
  Result:='';
  lLogStrLst:=nil;
  lLogFileName:=ExtractFilePath(FManualLogPath)+FTempTag+'_'+pLogName;
  if Not FileExists(lLogFileName) then exit;
  try
    lLogStrLst:=TStringList.Create;
    lLogStrLst.LoadFromFile(lLogFileName);
    Result:=lLogStrLst.Text;
  finally
    if Assigned(lLogStrLst) then
      lLogStrLst.Destroy;
  end;
end;

//该函数返回新增公告而更新的Log对应记录
Function TDocManualMgr.ReturnNewManualLogText():String;
begin
  Result:=FSaveTime+#9+FID+#9+FTitle+#9+
                   FloatToStr(FDate)+#9+FURL+#9+FDocBackupTmpFileName;

end;

Function TDocManualMgr.SetManualLogText():Boolean;
var
  lLogTextFile:TextFile;
  lTempStr1,lLogFileName:String;
begin
  try
    try
      Result:=True;

      lLogFileName :=ExtractFilePath(FManualLogPath)+FTempTag+'_'+ FormatDateTime('yyyymmdd',Now)+'.log';
      AssignFile(lLogTextFile,lLogFileName);
      
      if FileExists(lLogFileName) then
        Append(lLogTextFile)
      else
        ReWrite(lLogTextFile);

      //使用服务器的保存时间作为更新时间，也作为客户端作为录入时间
      FSaveTime :=FormatDateTime('yyyy-mm-dd hh:nn',Now);
      lTempStr1:=FSaveTime+#9+FID+#9+FTitle+#9+
                   FloatToStr(FDate)+#9+FURL+#9+FDocBackupTmpFileName;
      Writeln(lLogTextFile,lTempStr1);
    except
      Result:=False;
      Raise Exception.Create('ManualSetLog Error');
    end;
  finally
    CloseFile(lLogTextFile);
  end;
end;

function TDocManualMgr.SetTitleTxt(const AID, ATitle,AIDTitleFileName: String;
  ATxtDate: TDate): Boolean;
var
  lFileStr:TStringList;
  cStrLst:_CStrLst2;
  lDwnTitleFileName:String;
  lTmpStr1,lTmpStr2:String;
  i:integer;
begin
  Result:=True;
  lFileStr:=nil;
  try
    try
      lDwnTitleFileName:=ExtractFilePath(AIDTitleFileName)+AID+'_Title.txt';
      if not FileExists(lDwnTitleFileName) then exit;

      lFileStr:=TStringList.Create;
      lFileStr.LoadFromFile(lDwnTitleFileName);
      lTmpStr1:=ATitle+#9+FloatToStr(ATxtDate);

      i:=-1;
      while true do
      begin
         inc(i);
         if i>= lFileStr.Count then break;

         SetLength(CStrLst,0);
         CStrLst:=DoStrArray2(lFileStr.Strings[i],#9);
         if High(CStrLSt)<1 then
           lTmpStr2:=''
         else
           lTmpStr2:=CStrLst[0]+#9+CStrLst[1];

         if lTmpStr1=lTmpStr2 then
         begin
           lFileStr.Delete(i);
           Break;
         end;
      end;
      if lFileStr.Count>0 then
        lFileStr.SaveToFile(lDwnTitleFileName)
      else
        DeleteFile(lDwnTitleFileName);

    except
      Result:=False;
      Raise Exception.Create('ManualSetDwnTitleTxt Error');
    end;  //end try except
    
  finally
    if Assigned(lFileStr) then
      lFileStr.Destroy;
  end; //end try finally
end;

function TDocManualMgr.GetNewDocTmpFileName: String;
begin
  //比如 D:\DocMgrTW\Data\Doc_02_0A8C6E1D.tmp
  Result:= ExtractFilePath(FOutPutDataPath)+FTempTag+'_'+Get_GUID8+'.tmp';
  //避免重复
  While FileExists(Result) do
    Result:= ExtractFilePath(FOutPutDataPath)+FTempTag+'_'+Get_GUID8+'.tmp';
end;

function TDocManualMgr.GetSection(Var StratIndex: Integer;
  const f: TStringList; const Section: String): String;
Var
   i : integer;
   s,ts : String;
Begin
   ts := '';
   For i:=StratIndex+1 to f.Count-1 do
   Begin
    s := f.Strings[i];
    if Pos(Section,UpperCase(S))>0 Then
    Begin
       StratIndex := i;
       Break;
    End;
    if Length(ts)>0 Then
       ts := ts + #13#10;
    ts := ts + s ;
   End;
   Result := ts;
end;



  
{ TDoc02DataMgr }

Function TDoc02DataMgr.AddADoc(const Title : String;
                       const ID : String;
                       const DocType : String;
                       const Date : TDate;
                       const Time : TTime;
                       const URL  : String):TDocData;
Var
  ADoc:TDocData;
  ADoc2:TDocData;
  i : integer;
begin

  ADoc := TDocData.Create(False,Title,ID,DocType,Date,Time,'',URL);

  For i:=0 to  FEndReadDocList.Count-1 do
  Begin
      ADoc2 := FEndReadDocList.Items[i];
      if ADoc.DocExist(ADoc2) Then
      Begin
        ADoc.Destroy;
        ADoc := Nil;
        break;
      End;
  end;

  if ADoc<>nil Then
     FDocList.Add(ADoc);
  Result := ADoc;
end;

procedure TDoc02DataMgr.SetChkDocIsOk(const Tag,GUID: String);
Var
  ADoc : TDocData;
  FileName : String;
begin

   ADoc := GetADoc(GUID);
   if ADoc=nil Then exit;
try
   //魁
   SaveDocToLog(Tag,ADoc,chkOk);

   //埃
   FDocList.Remove(ADoc);
   if FCurDocCount>0 then
     Dec(FCurDocCount);
   if FmtDt8(ADoc.date)=FmtDt8(date) then
     Dec(FTodayDocCount);
   DelToTempDocFile(ADoc.GUID,ADoc.TempFileName);

   //玂
   FileName := ADoc.SaveToFile(FDocPath);

   //玻ネЧΘidx郎,ノ埃糵魁
   SaveDocToFinishIdx(ADoc);

   //肚
   SaveDocToUpLoad(ADoc,FileName);
finally
   //Free
   ADoc.Destroy;
end;
end;

procedure TDoc02DataMgr.ClearData;
Begin
   ClearDataDocList;
   ClearDataNotGetMemoList;
   ClearDataEndReadDocList;
   ClearDataExistDocTitleList;
end;

constructor TDoc02DataMgr.Create(const TempDocFileName: String;Const DocPath:String);
begin

   FTempDocFileName := TempDocFileName;
   FLogPath := ExtractFilePath(FTempDocFileName)+'CheckDocLog\';
   FTempTag := ChangeFileExt(ExtractFileName(FTempDocFileName),'');

   FNowTempDocFileNameList:=TStringList.create;

   FDocPath := DocPath;
   FLogDocList := TList.Create;
   FDocList := TList.Create;
   FNotGetMemoDocList := TList.Create;
   FEndReadDocList := TList.Create;
   FExistDocTitle  := TStringList.Create;
end;

procedure TDoc02DataMgr.SetCheckDocLogSaveDays(aValue:integer);
begin
  //if aValue>0 then
  begin
    FCheckDocLogSaveDays:=aValue;
  end;
end;

function TDoc02DataMgr.DelDocLst(aID:String;aTitle,aDate:String):Boolean;
var DocLstFile :TiniFile;
  DocCount ,i,j,index: integer;
  StrLst,StrLst1:TStringList;
  Str,sTr1dbDocumentPath,sRftFile:String;
  bedel:Boolean;
begin
  result:=false;
  sTr1dbDocumentPath:=FDocPath;
  DoPathSep2(sTr1dbDocumentPath);

  bedel:=false;
  StrLst1:=TStringList.Create;
  StrLst:=TStringList.Create;
  DocLstFile := TiniFile.Create(sTr1dbDocumentPath+'doclst.dat');
  try
    DocCount := DocLstFile.ReadInteger('COUNT',aID,0);
    if(DocCount=0)then exit;

    StrLst1.LoadFromFile(sTr1dbDocumentPath+'doclst.dat');
    index := Pos('['+aID+']',Strlst1.Text);
    if index>0 Then
    Begin
      index := index+Length('['+aID+']');
      Strlst.Text:=Copy(Strlst1.text,index+1,Length(Strlst1.text)-index);
      if (Strlst.Count>0) and (Strlst[0]='') then
        Strlst.Delete(0); 
      Strlst1.Text:=Copy(Strlst1.text,1,index);
    End Else
      Strlst.Clear;

    i:=0;
    j:=Strlst.Count;
    While i<Strlst.Count do
    Begin
      Application.ProcessMessages;
      Str := Strlst.Strings[i];
      if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
          Break;
      if (not bedel)and(Pos(aTitle,Str)>0)and (Pos(aDate,Str)>0)Then
      Begin
        sRftFile:=GetStrOnly2('=',',',Str,false);
        if sRftFile<>'' then
        begin
          sRftFile:=StringReplace(sRftFile,'.rtf','.txt',[rfReplaceAll]);
          sRftFile:=sTr1dbDocumentPath+aID+'\'+sRftFile;
          if FileExists(sRftFile) then
            DeleteFile(sRftFile);
        end;
        j:=i;
        Strlst.Delete(i);
        bedel:=true;
        continue;
      End;

      if(i>=j)then
      begin
        Str:=IntToStr(StrToInt(Copy(Str,1,Pos('=',Str)-1))-1)
             +Copy(Str,Pos('=',Str),Length(Str)-Pos('=',Str)+1);
        Strlst.Strings[i]:=Str;
      end;
      inc(i);
    End;

    Strlst.Text:=Strlst1.Text+Strlst.Text;
    Strlst.SaveToFile(sTr1dbDocumentPath+'doclst.dat');
    DocLstFile.WriteString('Count',aID,IntToStr(StrToInt(DocLstFile.ReadString('Count',aID,'1'))-1));
    result:=true;
  finally
    try if Assigned(Strlst) then FreeAndNil(strlst); except end;
    try if Assigned(Strlst1) then FreeAndNil(strlst1); except end;
    try if Assigned(DocLstFile) then FreeAndNil(DocLstFile); except end;
  end;
end;

function TDoc02DataMgr.DelIDLst(aID:String;aTitle,aDate:String;var sRtfFile:string):Boolean;
var
  DocCount ,i,j,index: integer;
  StrLst,StrLst1:TStringList; DocLstFile :TiniFile;
  sItemRtf,Str,sTr1dbDocumentPath:String;

  function GetTitle(aInputStr: String; var aVarRtfFile: string): Boolean;
  var ix1:integer;
  begin
    result:=false;
    if(Length(aInputStr)=0)then exit;
    aVarRtfFile:=GetStrOnly2('=',',',aInputStr,false);
    aVarRtfFile:=Trim(aVarRtfFile);
    if aVarRtfFile<>'' then
    begin
      aVarRtfFile:=ChangeFileExt(aVarRtfFile,'.txt');
      aVarRtfFile:=sTr1dbDocumentPath+aID+'\'+aVarRtfFile;
    end;
    result:=True;
  end;

begin
  result:=false;  sRtfFile:='';
  sTr1dbDocumentPath:=FDocPath;
  DoPathSep2(sTr1dbDocumentPath);

  DocLstFile:=nil;
  StrLst1:=TStringList.Create;
  StrLst:=TStringList.Create;
  StrLst1.LoadFromFile(sTr1dbDocumentPath+'StockDocIdxLst\'+aID+'_DOCLST.dat');
  try
    index := Pos('['+aID+']',Strlst1.Text);
    if index>0 Then
    Begin
      index := index+Length('['+aID+']');
      Strlst.Text:=Copy(Strlst1.text,index+1,Length(Strlst1.text)-index);
      if (Strlst.Count>0) and (Strlst[0]='') then
        Strlst.Delete(0); 
      Strlst1.Text:=Copy(Strlst1.text,1,index);
    End Else
      Strlst.Clear;

    sRtfFile:='';sItemRtf:='';
    i:=0;
    j:=Strlst.Count;
    While i<Strlst.Count do
    Begin
      Str := Strlst.Strings[i];
      if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
      begin
        Break;
      end;

      if (Pos(aTitle,Str)>0) and (Pos(aDate,Str)>0)Then
      Begin
        j:=i;
        GetTitle(Strlst.Strings[i],sItemRtf);
        if FileExists(sItemRtf) then
          DeleteFile(sItemRtf);
        sRtfFile:=sItemRtf;
        Strlst.Delete(i);
        continue;
      End;

      if(i>=j)then
      begin
        Str:=IntToStr(StrToInt(Copy(Str,1,Pos('=',Str)-1))-1)
             +Copy(Str,Pos('=',Str),Length(Str)-Pos('=',Str)+1);
        Strlst.Strings[i]:=Str;
      end;

      {if (Trim(Strlst.Strings[i])<>'') and
         ( (sRtfFile='') or (not FileExists(sRtfFile)) ) then
        GetTitle(Strlst.Strings[i],sRtfFile); }
      inc(i);
    End;

    Strlst.Text:=Strlst1.Text+Strlst.Text;
    Strlst.SaveToFile(sTr1dbDocumentPath+'StockDocIdxLst\'+aID+'_DOCLST.dat');

    sItemRtf:=ExtractFileName(sItemRtf);
    sItemRtf:=ChangeFileExt(sItemRtf,'.rtf');
    if sItemRtf<>'' then
    begin
      DocLstFile := TiniFile.Create(sTr1dbDocumentPath+'StockDocIdxLst\'+aID+'_DOCLST.dat');
      DocLstFile.DeleteKey('DownLoad',sItemRtf);
    end;
    result:=true;
  finally
    try if Assigned(Strlst) then FreeAndNil(strlst); except end;
    try if Assigned(Strlst1) then FreeAndNil(strlst1); except end;
    try if Assigned(DocLstFile) then FreeAndNil(DocLstFile); except end;
  end; 
end;

function TDoc02DataMgr.MakeUploadFile(aID,aTitle,aFilePath:String):Boolean;
var
  StrLst :TStringList;
  i:integer;
begin
  Result:=false;
  StrLst :=TStringList.Create;
  try
    StrLst.Add('[FILE]');
    StrLst.Add('ID='+aID);
    StrLst.Add('FileName='+aFilePath);
    StrLst.Add('Title='+aTitle);
    StrLst.Add('Date='+FloatToStr(Date));

    Mkdir_Directory(ExtractFilePath(application.ExeName)+'\Data\');
    i:=1;
    while Fileexists(ExtractFilePath(application.ExeName)+'\Data\upload_'+IntToStr(i)+'.ftp') do
      inc(i);
    StrLst.SaveToFile(ExtractFilePath(application.ExeName)+'\Data\upload_'+IntToStr(i)+'.ftp');
    Result:=true;
  except
  end;
  if Assigned(Strlst)then
    Strlst.Free;
end;

function TDoc02DataMgr.MakeUploadFileDel(aID,aTitle,aFilePath:String):Boolean;
var
  StrLst :TStringList;
  i:integer;
begin
  Result:=false;
  StrLst :=TStringList.Create;
  try
    StrLst.Add('[FILE]');
    StrLst.Add('ID='+aID);
    StrLst.Add('FileName='+aFilePath);
    StrLst.Add('Title='+aTitle);
    StrLst.Add('Date='+FloatToStr(Date));
    StrLst.Add('Del=1');

    Mkdir_Directory(ExtractFilePath(application.ExeName)+'\Data\');
    i:=1;
    while Fileexists(ExtractFilePath(application.ExeName)+'\Data\upload_'+IntToStr(i)+'.ftp') do
      inc(i);
    StrLst.SaveToFile(ExtractFilePath(application.ExeName)+'\Data\upload_'+IntToStr(i)+'.ftp');
    Result:=true;
  except
  end;
  if Assigned(Strlst)then
    Strlst.Free;
end;

function TDoc02DataMgr.SetADocStatus(ADoc:TDocData;aDocLogFile:string;var aRst:string):boolean;
begin
  result:=False;
  aRst:='';
try
  if not DelDocDatInLog(aDocLogFile,ADoc.GUID) then
  begin
    aRst:='埃logい癘魁ア毖';
    exit;
  end;
  if not AddDocDatInLog(aDocLogFile,ADoc.text,ADoc.GUID) then
  begin
    aRst:='睰穝篈癘魁ア毖';
    exit;
  end;
  result:=true;
except
  on e:Exception do
  begin
     aRst:='矪瞶そ篈砞﹚ア毖:'+e.Message;
  end;
end;
end;

function TDoc02DataMgr.CancelADoc(ADoc:TDocData;aDocLogFile:string;var aRst:string):boolean;
const _CancelDocTag='calcel';
var sTemp,sCancelLogFile,sIdxFile,sRtfFile:string;  aDelDoc:boolean;
begin
  result:=False;
  aRst:='';
try
  sTemp:=ExtractFileName(aDocLogFile);
  aDelDoc:=Pos('_Fail',sTemp)>0;
  sCancelLogFile:=GetCancelLogFile(aDocLogFile);
  if not DelDocDatInLog(aDocLogFile,ADoc.GUID) then
  begin
    aRst:='埃logい癘魁ア毖';
    exit;
  end;
  ADoc.DocType:=_CancelDocTag;
  if not AddDocDatInLog(sCancelLogFile,ADoc.text,ADoc.GUID) then
  begin
    aRst:='睰紀log癘魁ア毖';
    exit;
  end;
  if not aDelDoc then
  begin
    if not DelDocLst(ADoc.ID,ADoc.Title,FormatDateTime('yyyy-mm-dd',ADoc.Date)) then
    begin
      aRst:='矪瞶そ羆睲虫ア毖';
      exit;
    end;
    if not DelIDLst(ADoc.ID,ADoc.Title,FormatDateTime('yyyy-mm-dd',ADoc.Date),sRtfFile) then
    begin
      aRst:='矪瞶そ絏睲虫ア毖';
      exit;
    end;
  end;
  sIdxFile:=FDocPath+'DocLstIdx\'+ADoc.ID+'.idx';
  if not DelDocInIdx(sIdxFile,ADoc.Title,ADoc.Date,aDelDoc) then
  begin
    aRst:='矪瞶idx睲虫ア毖';
    exit;
  end;
  MakeUploadFileDel(ADoc.ID,ADoc.Title,(sRtfFile));
  result:=true;
except
  on e:Exception do
  begin
     aRst:='矪瞶紀ア毖:'+e.Message;
  end;
end;

end;

procedure TDoc02DataMgr.DelADoc(const Tag,GUID: String);

function AddDocDel(aTr1IdxPath,aCode,aDocTitle,aDocText:string;aDocDate:TDate):Boolean;
var aDocTxtFile,aDocDateStr:string;
    ts:TStringList;
begin
  result:=false;
  if not DirectoryExists(aTr1IdxPath) then exit;
  aDocDateStr:=FormatDateTime('yyyymmdd',aDocDate);
  aDocTxtFile:=Format('%s%sDel.txt',[aTr1IdxPath,aCode]);
  ts:=TStringList.Create;
  try
    if FileExists(aDocTxtFile) then
      ts.LoadFromFile(aDocTxtFile);
    ts.Add( Format('<Doc=%s/%s>',[aDocTitle,aDocDateStr]) );
    ts.Add( aDocText );
    ts.Add( '</Doc>' );
    ts.SaveToFile(aDocTxtFile);
  finally
    try FreeAndNil(ts); except end;
  end;
  result:=true;
end;
Var
  ADoc : TDocData;
  aTempStr:shortstring;
begin

   ADoc := GetADoc(GUID);
   if ADoc=nil Then exit;
try
   SaveDocToLog(Tag,ADoc,chkDel);

   FDocList.Remove(ADoc);
   if FCurDocCount>0 then
     Dec(FCurDocCount);
   if FmtDt8(ADoc.date)=FmtDt8(date) then
     Dec(FTodayDocCount);
   //SaveToTempDocFile(ADoc.TempFileName);
   DelToTempDocFile(ADoc.GUID,ADoc.TempFileName);

   //add by JoySun 2005/10/24
   //保存失败记录，防止重复搜索
   ADoc.SaveToFile_DEl(FDocPath);

   aTempStr:=FDocPath;
   DoPathSep(aTempStr);
   aTempStr:=aTempStr+'DocLstIdx'+'\';
   AddDocDel(aTempStr, ADoc.FID,ADoc.FTitle,ADoc.FMemo,ADoc.FDate);

   //產生一個完成的idx檔案,用以消除待審核的紀錄
   SaveDocToFinishIdx(ADoc);
finally
   ADoc.Destroy;
end;
end;

destructor TDoc02DataMgr.Destroy;
Begin

  ClearData;
  FDocList.Free;
  FNotGetMemoDocList.Free;
  FEndReadDocList.Free;
  FLogDocList.Free;

  FExistDocTitle.Free;
  //inherited;
end;

function TDoc02DataMgr.GetADoc(const GUID: String): TDocData;
Var
  ADoc:TDocData;
  i : Integer;
begin

  Result := nil;
  For i:=0 to FDocList.Count-1 do
  Begin
     ADoc := FDocList.Items[i];
     if ADoc.GUID=GUID Then
     Begin
         Result := ADoc;
         Break;
     End;
  End;
end;

procedure TDoc02DataMgr.DelToTempDocFile(aGUID,aTmpFileName:string);
Var
  f1,f2 : TStringList; f : TextFile;
  i,j : Integer;
  FileName,s: String;
  Age,fh: Integer;
Begin
try
try
  f1 := TStringList.Create;
  f2 := TStringList.Create;
  if not FileExists(aTmpFileName) then
    Exit;
  f2.Clear;
  AssignFile(f,aTmpFileName);
  FileMode := 0;
  Reset(f);
  f1.Clear;
  While Not Eof(f) do
  Begin
      Readln(f,s);
      f1.Add(s);
      if SameText('</ID>',s) then
      begin
        if not (Pos(aGUID,f1.text)>0) then
        begin
          f2.Add(f1.text);
        end;
        f1.Clear;
      end;
  End;
  CloseFile(f);

  FileName := aTmpFileName;
   if Length(f2.Text)>0 Then
   Begin
      Age := 0;
      //先取出原來檔案的時間
      if FileExists(FileName) Then
         Age := FileAge(FileName);

      f2.SaveToFile(FileName);

      //把檔案原來的時間寫進去
      if Age>0 Then
      Begin
        fh := FileOpen(FileName,fmOpenWrite);
        Try
          FileSetDate(fh,Age);
        Except
        End;
        Try
          if fh>0 Then
            FileClose(fh);
        Except
        End;
      End;

   End Else begin
     if FileExists(FileName) then
       DeleteFile(FileName);
     i:=FNowTempDocFileNameList.IndexOf(FileName);
     if i<>-1 then
       FNowTempDocFileNameList.Delete(i);
   end;
except
end;
finally
  f1.Free;
  f2.Free;
end;
end;

function TDoc02DataMgr.TempDocFileNameExists: Boolean;
begin
    FNowTempDocFileNameList.clear;
    FolderAllFiles(ExtractFilePath(FTempDocFileName),'.TMP',OnGetFile,False);
    result := FNowTempDocFileNameList.count>0;
end;

procedure TDoc02DataMgr.SaveDocToLog(Tag:String;ADoc: TDocData;ChkStatus:TChkStatus);
Var
  f : TextFile;
  FileName : String;
  fStringLst : TStringList;
  DateStr : String;
  i : Integer;
begin

    if ADoc=nil Then Exit;

    DateStr := FormatDateTime('yymmdd',Date);

    Mkdir_Directory(FLogPath);
    Case ChkStatus of
       chkOk  : FileName := FLogPath+Tag+'_'+DateStr+'_Pass.log';
       chkDel : FileName := FLogPath+Tag+'_'+DateStr+'_Fail.log';
    End;
    //Mkdir_Directory(ExtractFilePath(FileName));


    fStringLst := nil;
    Try
      fStringLst := TStringList.Create;
      SetDocDataStringList(fStringLst,ADoc);
      AssignFile(f,FileName);
      FileMode:=1;

      if FileExists(FileName) Then
         Append(f)
      Else
         ReWrite(f);
      for i:=0 to fStringLst.Count-1 do
         WriteLn(f,fStringLst.Strings[i]);
    Finally
      try
        CloseFile(f);
      Except
      end;
      if (ClearDate<>Date)then
        begin
         ClearSysLog(Tag+'_');
         ClearDate:=Date;
        end;
      if Assigned(fStringLst) Then
         fStringLst.Free;
    End;
end;

procedure TDoc02DataMgr.SetADocMemo(const ADoc: TDocData;
  const Memo: String);
begin
   if ADoc=nil Then Exit;
   ADoc.Memo := Memo;
end;

procedure TDoc02DataMgr.SetADocID(const ADoc: TDocData; const ID: String);
begin
   if ADoc=nil Then Exit;
   ADoc.DOCID := ID;
end;

procedure TDoc02DataMgr.SetChkDocIDIsOk(const Tag,GUID: String);
Var
  ADoc : TDocData;
begin

   ADoc := GetADoc(GUID);
   if ADoc=nil Then exit;

   SaveDocToLog(Tag,ADoc,chkOk);
   FDocList.Remove(ADoc);
   //SaveToTempDocFile(ADoc.TempFileName);
   DelToTempDocFile(ADoc.GUID,ADoc.TempFileName);

   //產生一個完成的idx檔案,用以消除待審核的紀錄
   //SaveDocToFinishIdx(ADoc);

   ADoc.Destroy;


end;

function TDoc02DataMgr.GetTempDocFileName: String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin

   FileName := ExtractFileName(FTempDocFileName);
   FileExt  := ExtractFileExt(FileName);

   ReplaceSubString(FileExt,'',FileName);

   Index := 1;
   FileName2 := ExtractFilePath(FTempDocFileName)+FileName+'_'+IntToStr(Index)+FileExt;
   While FileExists(FileName2) do
   Begin
       inc(Index);
       FileName2 := ExtractFilePath(FTempDocFileName)+FileName+'_'+IntToStr(Index)+FileExt;
   End;
   Result := FileName2;
end;

function TDoc02DataMgr.GetSection(Var StratIndex: Integer;
  const f: TStringList; const Section: String): String;
Var
     i : integer;
     s,ts : String;
Begin
         ts := '';
         For i:=StratIndex to f.Count-1 do
         Begin
                s := f.Strings[i];
                if Pos(Section,UpperCase(S))>0 Then
                Begin
                   StratIndex := i;
                   Break;
                End;
                if Length(ts)>0 Then
                   ts := ts + #13#10;
                ts := ts + s ;
         End;
         Result := ts;
End;


procedure TDoc02DataMgr.ClearDataDocList;
Var
  ADoc:TDocData;
Begin
  While FDocList.Count>0 do
  Begin
     ADoc := FDocList.Items[0];
     ADoc.Destroy;
     FDocList.Delete(0);
  End;
  FCurDocCount:=0;
  FTodayDocCount:=0;
end;

procedure TDoc02DataMgr.ClearDataNotGetMemoList;
Var
  ADoc:TDocData;
Begin
  While FNotGetMemoDocList.Count>0 do
  Begin
     ADoc := FNotGetMemoDocList.Items[0];
     ADoc.Destroy;
     FNotGetMemoDocList.Delete(0);
  End;
end;

procedure TDoc02DataMgr.ClearDataEndReadDocList;
Var
  ADoc:TDocData;
Begin

  While FEndReadDocList.Count>0 do
  Begin
     ADoc := FEndReadDocList.Items[0];
     ADoc.Destroy;
     FEndReadDocList.Delete(0);
  End;
end;

procedure TDoc02DataMgr.SetDocDataStringList(f: TStringList; ADoc: TDocData);
begin
     f.Add(ADoc.Text);
end;

procedure TDoc02DataMgr.GetDocDataStringList(FileStr:TStringList;List: TList);
Var
  s : String;
  ADoc:TDocData;
  i :  integer;
begin
  i := -1;
  While True do
  Begin
      Inc(i);
      If i>=FileStr.Count Then Break;
      S := FileStr.Strings[i];
      if Pos('<ID',UpperCase(S))>0 Then
      Begin
           s := GetSection(i,FileStr,'</ID>');
           ADoc := TDocData.Create(s);
           List.Add(ADoc);
           Continue;
      End;
  End;

End;

function TDoc02DataMgr.GetUploadLogFile: String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin

   FileName := 'upload';
   FileExt  := '.ftp';

   Index := 1;
   FileName2 := ExtractFilePath(FTempDocFileName)+FileName+'_'+IntToStr(Index)+FileExt;
   While FileExists(FileName2) do
   Begin
       inc(Index);
       FileName2 := ExtractFilePath(FTempDocFileName)+FileName+'_'+IntToStr(Index)+FileExt;
   End;

   Result := FileName2;


end;

procedure TDoc02DataMgr.SaveDocToUpLoad(ADoc: TDocData;Const FileName:String);
Var
  f : TStringList;
begin

   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('ID='+ADOC.ID);
   f.Add('FileName='+FileName);
   f.Add('Title='+ADoc.Title);
   f.Add('Date='+FloatToStr(ADoc.Date));
   f.SaveToFile(GetUploadLogFile);
   f.Free;

end;

function TDoc02DataMgr.GetUploadADoc(const FileName: String;Const SeverName :String): TUploadDoc;
Var
  f : TiniFile;
begin

   f := TIniFile.Create(FileName);
   Result.ID := f.ReadString('File','ID','');
   Result.FileName := FDocPath+Result.ID+'\'+ExtractFileName(f.ReadString('File','FileName',''));
   Result.Title := f.ReadString('File','Title','');
   Result.Date := f.ReadFloat('File','Date',0);
   Result.FTP_Note := f.ReadInteger('FTP_Note',SeverName,0);
   f.Free;

end;

procedure TDoc02DataMgr.SaveUploadADoc(const FileName: String;Const SeverName :String;Const i:integer);
Var
  f : TiniFile;
begin

   f := TIniFile.Create(FileName);
   f.WriteString('FTP_Note',SeverName,IntToStr(i));
   f.Free;

end;

function TDoc02DataMgr.ThisUploadDocNeedUpload(Const Tr1DBPath:String;ADoc: TUploadDoc): Boolean;
Var
  f : TiniFile;
  StrDate:String;
  Year,Day,Month : Word;
  StrLst : _cStrLst;
  Date : TDate;
begin

 f := TIniFile.Create(Tr1DBPath + 'CBData\Data\date.dat');

Try

   Result := false;
   Date := 0;
   StrDate := f.ReadString('Date',ADoc.ID,'');
   StrLst := DoStrArray(StrDate,',');
   StrDate := '';
   if High(StrLst)=2 Then
      StrDate := StrLst[0];
   if Length(StrDate)=8 Then
      if IsInteger(PChar(StrDate)) Then
      Begin
          Year := StrToInt(Copy(StrDate,1,4));
          Day := StrToInt(Copy(StrDate,5,2));
          Month := StrToInt(Copy(StrDate,7,2));
          Date := EncodeDate(Year,Month,Day);
      End;

   if ADoc.Date>=Date Then
      Result := True;

Finally
 f.Free;
end;


end;

function TDoc02DataMgr.GetUploadTmpFile: _cStrLst;
begin
    FolderAllFiles(ExtractFilePath(FTempDocFileName),'.ftp',Result,false);
end;

function TDoc02DataMgr.SetUploadDocLst(ADoc: TUploadDoc): String;
Var
  DocLst : TiniFile;
  Index  :  Integer;
begin

   Result := GetUploadDocLst;
   //Result := FDocPath;
   DocLst := TIniFile.Create(Result);
   Index := 1;
   While Not (DocLst.ReadString(ADoc.ID,IntToStr(Index),'NONE')='NONE') Do
        Inc(Index);

   DocLst.WriteString(ADoc.ID,IntToStr(Index),
                  ChangeFileExt(ExtractFileName(ADoc.FileName),'.rtf')+','+ADoc.Title+'/'+
                  FormatDateTime('yyyy-mm-dd',ADoc.Date));

   DocLst.Free;


end;

function TDoc02DataMgr.GetText: String;
Var
 aDoc : TDocData;
 i : Integer;

begin
   Result := '';
   For i:=0  To FDocList.Count-1 do
   Begin
       ADoc := FDocList.Items[i];
       Result := Result + #13#10 + ADoc.Text;
   End;

end;

procedure TDoc02DataMgr.SetText(const Value: String);
Var
  f : TStringList;
begin

   ClearDataDocList;

   f := TStringList.Create;
   f.Text := Value;
   GetDocDataStringList(f,FDocList);
   f.Free;
    
end;

procedure TDoc02DataMgr.FreeADoc(const GUID: String);
Var
  ADoc : TDocData;
begin

   ADoc := GetADoc(GUID);
   if ADoc=nil Then exit;
   FDocList.Remove(ADoc);
   ADoc.Destroy;

end;

function TDoc02DataMgr.GetANotGetMemoDoc(const GUID: String): TDocData;
Var
  ADoc:TDocData;
  i : Integer;
begin

  Result := nil;
  For i:=0 to FNotGetMemoDocList.Count-1 do
  Begin
     ADoc := FNotGetMemoDocList.Items[i];
     if ADoc.GUID=GUID Then
     Begin
         Result := ADoc;
         Break;
     End;
  End;

end;

procedure TDoc02DataMgr.FreeANotGetMemoDoc(const GUID: String);
Var
  ADoc : TDocData;
begin

   ADoc := GetANotGetMemoDoc(GUID);
   if ADoc=nil Then exit;
   FNotGetMemoDocList.Remove(ADoc);
   ADoc.Destroy;

end;

procedure TDoc02DataMgr.SetDocLstCBID(IDLst: TIDLstMgr);
Var
 aDoc : TDocData;
 i,j : Integer;
begin

   For i:=0  To FDocList.Count-1 do
   Begin
       ADoc := FDocList.Items[i];
       For j:=0 to IDLst.IDCount-1 do
       Begin
         if ADOC.ID = IDLst.IDItems[j] Then
         Begin
            ADOC.CBID := IDLst.CBIDItems[j];
            ADOC.CBName   := IDLst.CBNameItems[j];
            ADOC.CBStatus := IDLst.CBStatusItems[j];
            Break;
         End;
       ENd;
   End;

end;

Function TDoc02DataMgr.LoadLogDocFile(const ADate: String;const mode:Integer;const Option:Integer):String;
Var
  //f : TInifile;
  //ft : TextFile;
  FileStr : TStringList;
  //s : String;
  FileName : String;
  //Count,i : Integer;
  //DateStr : String;
begin

    //ClearLogDocList;

    Result := '';

    if mode=1 then
    begin
      if Option=0 Then
         FileName := FLogPath+'Doc1_'+ADate+'_Pass.log'
      Else
         FileName := FLogPath+'Doc1_'+ADate+'_Fail.log';
    end;

    if mode=2 then
    begin
      if Option=0 Then
         FileName := FLogPath+'Doc2_'+ADate+'_Pass.log'
      Else
         FileName := FLogPath+'Doc2_'+ADate+'_Fail.log';
    end;

    if mode=3 then
    begin
      if Option=0 Then
         FileName := FLogPath+'Doc3_'+ADate+'_Pass.log'
      Else
         FileName := FLogPath+'Doc3_'+ADate+'_Fail.log';
    end;


    if FileExists(FileName) Then
    Begin
      FileStr := TStringList.Create;
      FileStr.LoadFromFile(FileName);
      Result := FileStr.Text;
      FileStr.Free;
    End;
end;

procedure TDoc02DataMgr.ClearLogDocList;
Var
  ADoc:TDocData;
Begin

  While FLogDocList.Count>0 do
  Begin
     ADoc := FLogDocList.Items[0];
     ADoc.Destroy;
     FLogDocList.Delete(0);
  End;

end;

function TDoc02DataMgr.GetLogDocText: String;
Var
 aDoc : TDocData;
 i : Integer;

begin
   Result := '';
   For i:=0  To FLogDocList.Count-1 do
   Begin
       ADoc := FLogDocList.Items[i];
       Result := Result + #13#10 + ADoc.Text;
   End;
end;

procedure TDoc02DataMgr.SetLogDocText(const Value: String);
Var
  f : TStringList;
begin

   ClearLogDocList;

   f := TStringList.Create;
   f.Text := Value;
   GetDocDataStringList(f,FLogDocList);
   f.Free;

end;

procedure TDoc02DataMgr.ConvertToNewDocLst(const SourceLstFileName:String);
Var
  SourceDocLst : TStringList;
  DestDocLst : TStringList;
  Index,i,t1,t2  :  Integer;
  FileName,Str,StrDate : string;
begin

   //if Not FileExists(SourceLstFileName) Then Exit;

   FileName := ExtractFilePath(FTempDocFileName)+'doclst2.dat';

   DeleteFile(FileName);

   SourceDocLst := TStringList.Create;
   DestDocLst := TStringList.Create;

   Index := -1;
   SourceDocLst.LoadFromFile(ExtractFilePath(FTempDocFileName)+'doclst.dat');
   For i:=0 to SourceDocLst.Count-1 do
   Begin
        Str :=  SourceDocLst.Strings[i];
        if (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
        Begin
           DestDocLst.Add(Str);
           Index := 0;
        End Else
        Begin
           if Index>=0 Then
           if (Pos('=',Str)>0) and (Pos(',',Str)>0) and (Pos('/',Str)>0) Then
           Begin
               t1  := Pos('/',Str);
               t2  := Length(Str);
               StrDate := Copy(Str,t1+1,t2-t1);
               if StrDate>='2003-01-01' Then
               Begin
                   inc(Index);
                   t1  := Pos('=',Str);
                   t2  := Length(Str);
                   Str := Copy(Str,t1+1,t2-t1);
                   DestDocLst.Add(intToStr(Index)+'='+Str);
               End;
           End;
        End;
   End;

   SourceDocLst.Free;
   DestDocLst.SaveToFile(FileName);
end;

procedure TDoc02DataMgr.SetChkDocIsOk(ADoc:TDocData;Const AppID:String);
Var
  FileName :  String;
  f : TextFile;
begin

    FileName := FDocPath + 'Log\'+AppID+'\'+ADoc.ID+'.log';

    Mkdir_Directory(ExtractFilePath(FileName));

    AssignFile(f,FileName);
    FileMode:=2;
    if Not FileExists(FileName) Then
       ReWrite(f)
    Else
       Append(f);

    Writeln(f,ADoc.ID+'#'+ADoc.GUID+'#'+FormatDateTime('yyyy-mm-dd',Date));

    CloseFile(f);


end;


procedure TDoc02DataMgr.LoadExistDocFromDocLstFile(const ID: string);
Var
  f : TStringList;
  DocLst : _CstrLst;
  Str,FileName : ShortString;
  i,t1,t2 : Integer;
  Index : Integer;
Begin

  ClearDataExistDocTitleList;

  Setlength(DocLst,0);

  //加入一個測試的字串,
  //因為這可以用來判斷現在正在進行檢查所有公告的的狀態
  FExistDocTitle.Add('TEST_TITLE');

  //FileName  := ExtractFilePath(FTempDocFileName) + 'DocLst.Dat';
  FileName := GetUploadDocLst;
  if Not FileExists(FileName) Then Exit;

  try

  f := TStringList.Create;
  f.LoadFromFile(FileName);

  index := Pos('['+ID+']',f.Text);
  if index>0 Then
  Begin
    index := index+Length('['+ID+']');
    f.Text:=Copy(f.text,index+1,Length(f.text)-index);
    for i:=0 to f.Count-1 do
    Begin
      Str := f.Strings[i];
      if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
          Break;
      if Pos(',',Str)>0 Then
      Begin
          t1 := Pos('=',Str);
          t2 := Length(Str);
          Str := Copy(Str,t1+1,t2-t1);
          DocLst := DoStrArray(Str,',');
          //DocLst := DoStrArray(DocLst[1],'/');
          //if High(DocLst)>=1 Then
            FExistDocTitle.Add(DocLst[1]);
      End;
    End;
  End;
  f.Free;
 
  Except
  End;

end;


procedure TDoc02DataMgr.ClearDataExistDocTitleList;
begin
  FExistDocTitle.Clear;
end;

function TDoc02DataMgr.NowActionIsCheckAllDoc: Boolean;
begin
    Result := FExistDocTitle.Count>0;
end;

function TDoc02DataMgr.AppendADoc(const Title, ID, DocType: String;
  const Date: TDate; const Time: TTime; const URL: String): TDocData;
Var
  ADoc:TDocData;
  ADoc2:TDocData;
  i : integer;
begin

  ADoc := TDocData.Create(False,Title,ID,DocType,Date,Time,'',URL);

  for i:=0 to FExistDocTitle.Count-1 do
  Begin

        if (ADoc.Title+'/'+FormatDateTime('yyyy-mm-dd',ADoc.FDate))
           =FExistDocTitle.Strings[i] Then
        Begin
           //表此標題已存在
          ADoc.Destroy;
          ADoc := Nil;
          Break;
        End;
  End;

  if Assigned(ADoc) Then
  Begin
   For i:=0 to  FNotGetMemoDocList.Count-1 do
   Begin
      ADoc2 := FNotGetMemoDocList.Items[i];
      if ADoc.DocExist(ADoc2) Then
      Begin
        ADoc.Destroy;
        ADoc := Nil;
        Break;
      End;
   End;
  End;




  if ADoc<>nil Then
     FDocList.Add(ADoc);

  //if Not ThisDocExists(ADoc) Then
  //   FDocList.Add(ADoc);
  //Else
  //Begin
  //   ADoc.Destroy;
  //   ADoc := Nil;
  //End;

  Result := ADoc;

end;

function TDoc02DataMgr.GetUploadDocLst: String;
begin
   //Result := ExtractFilePath(FTempDocFileName)+'doclst.dat';
   Result := FDocPath+'doclst.dat';
end;

function TDoc02DataMgr.LoadFromTempDocFile2:string;

  
  function GetDocDataStringListLocal(aInputName:string;FileStr:TStringList;List: TList;
        aInputC:Integer;var aInputC2:Integer; var aFileOutList:string):Integer;
  Var s,stmpDate : String; dtTmp:TDate;
    ADoc:TDocData;
    i,j,j1,j2 :  integer;
  begin
    result:=aInputC;
    i := -1;
    While True do
    Begin
        Inc(i);
        If i>=FileStr.Count Then Break;
        S := FileStr.Strings[i];
        if Pos('<ID',UpperCase(S))>0 Then
        Begin
               s := GetSection(i,FileStr,'</ID>');
               stmpDate:=GetStrOnly2Ex('<Date>','</Date>',s,false);
               if MayBeDigital(stmpDate) then
               begin
                 dtTmp:=StrToFloat(stmpDate);
                 if FmtDt8(dtTmp)=FmtDt8(date) then
                   Inc(aInputC2);
                 Inc(result);
                 if List.Count=0 then
                 begin
                   ADoc := TDocData.Create(s,aInputName);
                   List.Add(ADoc);
                 end
                 else if (List.Count>=10) and (TDocData(List.items[0]).Date>=dtTmp) then
                 begin
                   continue;
                 end
                 else begin
                   j2:=-1;
                   for j1:=List.Count-1 downto 0 do
                   begin
                     ADoc:=List.items[j1];
                     if ADoc.Date<dtTmp then
                     begin
                       j2:=j1;
                       Break;
                     end;
                   end;
                   ADoc := TDocData.Create(s,aInputName);
                   if j2+1>=List.Count then
                     List.add(ADoc)
                   else
                     List.Insert(j2+1,ADoc);
                   if List.Count>10 then
                   begin
                     ADoc:=List.items[0];
                     ADoc.Destroy;
                     ADoc:=nil;
                     List.Delete(0);
                   end;
                 end;
               end;
        End;
    End;
  End;

Var
  f : TextFile;
  s : String;
  FileStr : TStringList;
  t1,t2,t3 : Integer;
  ADoc : TDocData;
  DelList : TList;

  DocLst : _CstrLst;
  Str : ShortString;
  Index : Integer;
Begin
Try
  result:='';
  ClearDataDocList;
  Setlength(DocLst,0);
  if FNowTempDocFileNameList.Count=0 then exit;
  t2:=0; t1:=0; t3:=0;
  FileStr := TStringList.Create;
  while t1<FNowTempDocFileNameList.Count do
  begin
    if FileExists(FNowTempDocFileNameList[t1]) then
    begin
      FileStr.Clear;
      AssignFile(f,FNowTempDocFileNameList[t1]);
      FileMode := 0;
      Reset(F);
      While Not Eof(f) do
      Begin
          Readln(f,s);
          FileStr.Add(s);
      End;
      CloseFile(f);
      t2:=GetDocDataStringListLocal(FNowTempDocFileNameList[t1],FileStr,FDocList,t2,t3,result);
      Inc(t1);
    end
    else begin
      FNowTempDocFileNameList.Delete(t1);
      continue;
    end;
  end;
  result:='';
  for Index:=0 to FDocList.count-1 do
  begin
    ADoc:=FDocList.items[Index];
    Str:=ExtractFileName(ADoc.TempFileName);
    if Pos(Str,result)<=0 then
    begin
      if Result='' then result:=Str
      else result:=result+','+Str;
    end;
  end;
  FCurDocCount:=t2;
  FTodayDocCount:=t3;
  FileStr.Free;
  //---
Finally
End;
end;

procedure TDoc02DataMgr.OnGetFile(FileName: String);
begin
    if Pos(FTempTag,ExtractFileName(FileName))>0 then
    Begin
      if FNowTempDocFileNameList.IndexOf(FileName)=-1 then
        FNowTempDocFileNameList.add(FileName);
    End;
end;

procedure TDoc02DataMgr.SaveDocToFinishIdx(ADoc: TDocData);
Var
 f : TStringList;
begin

 f := TStringList.Create;
Try
  f.Add(ADoc.FID+'='+ADoc.FTitle+'/'+FormatDateTime('yyyy-mm-dd',ADoc.FDate));
  f.SaveToFile(ExtractFilePath(FTempDocFileName)+FTempTag+'_'+ADoc.FID+'_'+Get_GUID8+'.idx');
Finally
  f.Free;
End;

end;

procedure TDoc02DataMgr.InitStockDocIdxLstDat;
Var
  Path,ID: String;
  i,index : Integer;
  f,FDocLst,StockDocIdxLst  : TStringList;
  Str:String;
begin

  Path := FDocPath + 'StockDocIdxLst\';
  if FileExists(Path+'StockDocIdxLst.dat') Then
     Exit;
  Mkdir_Directory(Path);

  f := nil;
  FDocLst := nil;
Try
Try

  f := TStringList.Create;
  FDocLst := TStringList.Create;
  StockDocIdxLst := TStringList.Create;

  f.LoadFromFile(FDocPath+'doclst.dat');
  ID := '';
  for index:=0 to f.Count-1 do
  Begin
    Str := f.Strings[index];
    if Pos('COUNT',Str)>0 Then
       Continue;
    if (Pos('[',Str)>0) and
       (Pos(']',Str)>0) and
       (Pos('=',Str)=0) and
       (Pos(',',Str)=0) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
              FDocLst.SaveToFile(Path+ID+'_DOCLST.dat');
              FDocLst.Clear;
              ID := '';
           End;
           ID := Str;
           FDocLst.Add('['+ID+']');
           StockDocIdxLst.Add('['+ID+']');
           //StockDocIdxLst.Add('GUID='+Get_GUID8);

           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
          if (Pos('=',Str)>0) and (Pos(',',Str)>0) and (Pos('/',Str)>0) Then
            FDocLst.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
     FDocLst.SaveToFile(Path+ID+'_DOCLST.dat');
  StockDocIdxLst.SaveToFile(Path+'StockDocIdxLst.dat');
Except
End;
Finally
  if Assigned(FDocLst) Then
     FDocLst.Free;
  if Assigned(f) Then
     f.Free;
  if Assigned(StockDocIdxLst) Then
     StockDocIdxLst.Free;
End;


end;

function TDoc02DataMgr.GetUploadStockDocLst(ID:String): String;
begin
   Result := FDocPath+'StockDocIdxLst\'+ID+'_DOCLST.dat';
end;

function TDoc02DataMgr.GetUploadStockDocIdxLst: String;
begin
   Result := FDocPath+'StockDocIdxLst\StockDocIdxLst.dat';
end;

procedure TDoc02DataMgr.ClearSysLog(aTag:string);
var
  LogFileLst : _CStrLst;
  i:integer; aDt:TDate; sLine:string;
begin
try
  if FCheckDocLogSaveDays<=0 then
    exit;
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\CheckDocLog\',
                 '.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    sLine:=ExtractFileName(LogFileLst[i]);
    if Pos(aTag,sLine)>0 then
    begin
      if Pos('DOC',UpperCase(sLine))=1 then
        aDt:=StrToDate('20'+Copy(sLine,6,2)+DateSeparator
                 +Copy(sLine,8,2)+DateSeparator
                 +Copy(sLine,10,2))
      else
        aDt:=StrToDate('20'+Copy(sLine,1,2)+DateSeparator
                 +Copy(sLine,3,2)+DateSeparator
                 +Copy(sLine,5,2));

      if(DaysBetween(aDt,Date)>30)then
      //if(DaysBetween(FileDateToDate(FileAge(FileName)),Date)>30)then
      DeleteFile(LogFileLst[i]);
    end;
  End;
except
end;
end;



{ TCBDataMgrBase }
Function GetItemIndex({ID:String;}IDLst:TListBox):Integer;
var
  i:integer;
Begin
  Result:=0;
try
  if(Length(F_SearchID)=0)then exit;
  For i:=0 To IDlst.Count-1 Do
  Begin
    if(IDLst.Items[i]=F_SearchID)then
    Begin
      Result:=i;
      break;
    End;
  End;
except
end;
End;


function TCBDataMgrBase.GetCBDataText(const FileName: String): String;
Var
  FileName2 : String;
  f : TStringList;
begin
    Result := '';
    FileName2 := FTr1DBPath+'CBData\Data\'+FileName;
    if FileExists(FileName2) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName2);
       Result := f.Text;
       f.Free;
    End;
end;

constructor TCBDataMgrBase.Create(aTw:boolean;Tr1DBPath:String);
begin
   FIsTw:=aTw;
   FTr1DBPath := Tr1DBPath;
   FExceptCodeList:=TStringList.create;
   FShangShiCodeList:=TStringList.create;
   //FPassHisCodeList:=TStringList.create;
   RefreshExceptList;
   RefreshShangShiCodeList;
end;

destructor TCBDataMgrBase.Destroy;
begin
  FreeAndNil(FExceptCodeList);
  FreeAndNil(FShangShiCodeList);
  //FreeAndNil(FPassHisCodeList);
  inherited;
end;

function TCBDataMgrBase.GetUploadAFileName(const FileName: String): String;
Var
  f : TiniFile;
begin
   f := TIniFile.Create(FileName);
   Result := lowercase(f.ReadString('File','FileName',''));
   f.Free;
end;

function TCBDataMgrBase.GetUploadAFolder(const FileName: String): String;
Var
  f : TiniFile;
begin
   f := TIniFile.Create(FileName);
   Result := lowercase(f.ReadString('File','Folder',''));
   f.Free;
end;

function TCBDataMgrBase.LoaclDatDir():string;
begin
   result:='';
end;

function TCBDataMgrBase.LoaclDatDirRateData():string;
begin
   result:=LoaclDatDir+'RateDatUpload\';
end;

function TCBDataMgrBase.GetUploadLogFile2(aTag:string):String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin
   FileName := 'upload'+aTag;
   FileExt  := '.cb';
   Index := 1;
   FileName2 := LoaclDatDir()+FileName+'_'+IntToStr(Index)+FileExt;
   While FileExists(FileName2) do
   Begin
       inc(Index);
       FileName2 := LoaclDatDir()+FileName+'_'+IntToStr(Index)+FileExt;
   End;
   Result := FileName2;
end;

function TCBDataMgrBase.GetUploadLogFile: String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin
   FileName := 'upload';
   FileExt  := '.cb';

   Index := 1;
   FileName2 := LoaclDatDir()+FileName+'_'+IntToStr(Index)+FileExt;
   While FileExists(FileName2) do
   Begin
       inc(Index);
       FileName2 := LoaclDatDir()+FileName+'_'+IntToStr(Index)+FileExt;
   End;
   Result := FileName2;
end;

function TCBDataMgrBase.GetUploadLogFileRateData: String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin
   FileName := 'upload';
   FileExt  := '.rate';

   Index := 1;
   FileName2 := LoaclDatDirRateData()+FileName+'_'+IntToStr(Index)+FileExt;
   While FileExists(FileName2) do
   Begin
       inc(Index);
       FileName2 := LoaclDatDirRateData()+FileName+'_'+IntToStr(Index)+FileExt;
   End;
   Result := FileName2;
end;

function TCBDataMgrBase.GetUploadLogFile3():String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin
   FileName := 'upload';
   FileExt  := '.cb';
   FileName2 := LoaclDatDir()+FileName+'_lst0'+FileExt;
   Result := FileName2;
end;

function TCBDataMgrBase.GetUploadLogFile4():String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin
   FileName := 'upload';
   FileExt  := '.cb';
   FileName2 := LoaclDatDir()+FileName+'_lst1'+FileExt;
   Result := FileName2;
end;

function TCBDataMgrBase.GetUploadLogFile5():String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin
   FileName := 'upload';
   FileExt  := '.cb';
   FileName2 := LoaclDatDir()+FileName+'_lst2'+FileExt;
   Result := FileName2;
end;

function TCBDataMgrBase.GetUploadLogFile7():String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin
   FileName := 'upload';
   FileExt  := '.cb';
   FileName2 := LoaclDatDir()+FileName+'_lst3'+FileExt;
   Result := FileName2;
end;

function TCBDataMgrBase.GetUploadLogFile7RateData():String;
Var
  FileName,FileName2 : String;
  FileExt : String;
  Index : Integer;
begin
   FileName := 'upload';
   FileExt  := '.rate';
   FileName2 := LoaclDatDirRateData()+FileName+'_lst3'+FileExt;
   Result := FileName2;
end;

function TCBDataMgrBase.GetUploadLogFile6(aAdd,aFileName:string):String;
Var
  FileName,FileName2,sFN : String;
  FileExt : String;
  Index : Integer;
begin
   sFN:=ExtractFileName(aFileName);
   sFN:=ChangeFileExt(sFN,'');
   sFN:=LowerCase(sFN);
   FileName := 'upload';
   FileExt  := '.cb';
   FileName2 := LoaclDatDir()+FileName+'_'+aAdd+sFN+FileExt;
   Result := FileName2;
end;

function TCBDataMgrBase.GetUploadTmpFile: _cStrLst;
begin
    FolderAllFiles(LoaclDatDir(),'.cb',Result,false);
end;

function TCBDataMgrBase.GetUploadTmpFileRateData: _cStrLst;
begin
    FolderAllFiles(LoaclDatDirRateData(),'.rate',Result,false);
end;

function TCBDataMgrBase.GetCBNameFromConfig(pCBkeyName:string):string;
Var aF: TiniFile;
  aFilePath,aFileName2:String;
begin
  Result:=pCBkeyName;
  aFilePath:=Format('%sDwnDocLog\uploadCBData\%s',
                  [LoaclDatDir(),
                  'CBNameConfig.ini']);
  if not FileExists(aFilePath) then exit;
  try
    aF:=TiniFile.Create(aFilePath);
    aFileName2 :=aF.ReadString('CBName',pCBkeyName,pCBkeyName);
    if aFileName2=pCBKeyName then
    begin
      if Pos('_',Copy(pCBKeyName,1,1))<1 then //若不是以_开头则尝试查找以_开头的值
        pCBKeyName:='_'+pCBKeyName
      else
        pCBKeyName:=Copy(pCBKeyName,2,Length(pCBKeyName)-1);  //若以_开头则尝试查找无_的值
        
      aFileName2 :=aF.ReadString('CBName',pCBkeyName,pCBkeyName);
    end;
    Result :=aFileName2;///FAppParam.ConvertString(aFileName2);
  finally
    aF.Free;
  end;
end;

Function TCBDataMgrBase.GetCBDataOpLog(sDateS,aDateE,aDstFile:String):boolean;
var dtTemp,dtS,dtE:TDate; sPath,sLogFile:string;
begin
  result:=false;
  dtS:=DateStr8ToDate(sDateS);
  dtE:=DateStr8ToDate(aDateE);
  dtTemp:=dtS;
  sPath:=LoaclDatDir()+'DwnDocLog\Doc_CBDataEdit\';
  while dtTemp<=dtE do
  begin
    sLogFile:=FormatDateTime('yyyymmdd',dtTemp)+'.log';
    if FileExists(sPath+sLogFile) then
      AddTrancsationDatToFile(sPath+sLogFile,aDstFile);
    dtTemp:=dtTemp+1;
  end;
  result:=true;
end;

Function TCBDataMgrBase.GetCBDataOpLogByM(sDateS,aDateE,aDstFile,aM:String;var ts:TStringList):boolean;
var dtTemp,dtS,dtE:TDate; sPath,sLogFile:string;
begin
  result:=false;
  dtS:=DateStr8ToDate(sDateS);
  dtE:=DateStr8ToDate(aDateE);
  dtTemp:=dtS;
  sPath:=LoaclDatDir()+'DwnDocLog\Doc_CBDataEdit\';
  while dtTemp<=dtE do
  begin
    sLogFile:=FormatDateTime('yyyymmdd',dtTemp)+'.log';
    if FileExists(sPath+sLogFile) then
      AddTrancsationDatToFileByM(sPath+sLogFile,aDstFile,aM,ts);
    dtTemp:=dtTemp+1;
  end;
  result:=true;
end;


Function TCBDataMgrBase.GetCBDataLog(Const sDateS,aDateE,DstFileName:String):Boolean;
var ALogFileName,aCBFileName,aLogStr,aFtpStr,aFtpLogStr,bCBFileName,sCurSec,
   sTemp1,sTemp2:String;
  ALogStrLst,aCBFileLst,tsNodeIndex,tsOne:TStringList; aF: TIniFile;
  i,j,k,aCBFtpCount: Integer; dtTemp,dtS,dtE:TDate;
  aUpLoadSucc,b1,b2: Boolean;

  function CBFileUploadIsOk(aInputCbFile:string):boolean;
  var x1,x2:integer; xStr1:string;
  begin
    result:=false;
    x2 := aF.ReadInteger(aInputCbFile,'CBFtpServerCount',1);
    For x1:=1 to x2 do
    begin
      xStr1 := aF.ReadString(aInputCbFile,'DocFtp_'+IntToStr(x1),'None'); //SaveTime #9 server;upldir
      if (xStr1 = 'None') then
      begin
         result := False;
         exit;
      end;
    end;
    result:=true;
  end;
  function GetSecValue(aInput:string):string;
  begin
    result:=aInput;
    result:=StringReplace(result,'[','',[rfReplaceAll]);
    result:=StringReplace(result,']','',[rfReplaceAll]);
  end;

begin
  Result:=false;
  ALogStrLst:=nil;
  try
    ALogStrLst:=TStringList.Create;
    tsNodeIndex:=TStringList.Create;
    tsOne:=TStringList.Create;
    dtS:=DateStr8ToDate(sDateS);
    dtE:=DateStr8ToDate(aDateE);
    dtTemp:=dtS;
    while dtTemp<=dtE do
    begin
      tsOne.Clear;
      tsNodeIndex.clear;
      aLogFileName :=LoaclDatDir()+'DwnDocLog\uploadCBData\'+FormatDateTime('yymmdd',dtTemp)+'.log';
      if FileExists(ALogFileName) then
      begin
        try
          aF := TIniFile.Create(ALogFileName);
          aCBFileLst := TStringList.Create;
          aCBFileLst.LoadFromFile(ALogFileName);

          For i:=0 to aCBFileLst.Count -1 do
          begin
            if IsSecLine(aCBFileLst[i]) and
               (Pos('@',aCBFileLst[i])>0) and
               (Pos('upload_lst0.cb',aCBFileLst[i])<=0) and
               (Pos('upload_lst1.cb',aCBFileLst[i])<=0) then
            begin
              sCurSec:=GetSecValue(aCBFileLst[i]);
              aLogStr := '';

              aCBFileName := sCurSec;
              aUpLoadSucc := CBFileUploadIsOk(aCBFileName);
              
              aLogStr := aF.ReadString(aCBFileName,'timekey','None');
              aLogStr := aLogStr + #9 +aF.ReadString(aCBFileName,'operator','None');
              aLogStr := aLogStr + #9 +aF.ReadString(aCBFileName,'FileNameCN','None');
              aLogStr := aLogStr + #9 +aF.ReadString(aCBFileName,'DocCenter','None');
              aLogStr := aLogStr + #9 + SysUtils.BoolToStr(aUpLoadSucc,True);
              aLogStr := aLogStr + #9 + aF.ReadString(aCBFileName,'FileNameEN','None');
              tsOne.Add(aLogStr);
              //狦琌竊翴肚癸莱cb戈肚癘魁玥硂ㄇ肚癘魁ぃ陪ボ讽硂ㄇ肚癘魁Аok玥竊翴肚Ok
              sTemp1:=aF.ReadString(aCBFileName,'node','None');
              if sTemp1='1' then
              begin
                tsNodeIndex.add(aLogStr);
              end;
            end;
          end;
        finally
          try if Assigned(aF) then FreeAndNil(aF); except end;
          try if Assigned(aCBFileLst) then FreeAndNil(aCBFileLst); except end;
        end;
      end;
      //狦琌竊翴肚癸莱cb戈肚癘魁玥硂ㄇ肚癘魁ぃ陪ボ讽硂ㄇ肚癘魁Аok玥竊翴肚Ok
      if tsNodeIndex.Count>0 then
      begin
        For i:=0 to tsNodeIndex.Count-1 do
        begin
          j:=tsOne.IndexOf(tsNodeIndex[i]);
          if j>=0 then
          begin
            aLogStr:=tsOne[j];
            k:=Pos(#9,aLogStr);
            if k>0 then
            begin
              aLogStr:=Copy(aLogStr,1,k-1);
              aUpLoadSucc:=Pos('True',tsOne[j])>0;
              b1:=aUpLoadSucc;

              for k:=j+1 to tsOne.count-1 do
              begin
                if Trim(tsOne[k])='' then
                  Continue;
                if (Pos(aLogStr,tsOne[k])>0) and (Pos('.txt',tsOne[k])<=0) then
                begin
                  b2:=Pos('True',tsOne[k])>0;
                  b1:=b1 and b2;
                  tsOne[k]:='';
                end
                else begin
                  break;
                end;
              end;
              if b1<>aUpLoadSucc then
              begin
                aLogStr:=tsOne[j];
                aLogStr:=StringReplace(aLogStr,'True','False',[]);
                tsOne[j]:=aLogStr
              end;
            end;
          end;
        end;
      end;
      if tsOne.count>0 then
      begin
        For i:=0 to tsOne.Count -1 do
        begin
          if Trim(tsOne[i])='' then
            continue;
          ALogStrLst.Add(tsOne[i]);
        end;
      end;

      dtTemp:=dtTemp+1;
    end;
    ALogStrLst.SaveToFile(DstFileName);
    result:=True;
  finally
    try if Assigned(ALogStrLst) then FreeAndNil(ALogStrLst); except end;
    try if Assigned(tsNodeIndex) then FreeAndNil(tsNodeIndex); except end;
    try if Assigned(tsOne) then FreeAndNil(tsOne); except end;
  end;
end;

procedure TCBDataMgrBase.ChangeDBLstVer(const FileName: String);
Var
  f : TiniFile;
begin
    if FileExists(FileName) Then
    Begin
       f:=TiniFile.Create(FileName);
       f.WriteString('dblst','Ver',Get_GUID);
       f.Free;
    End;
end;

function TCBDataMgrBase.CodeInType(aCode:string):integer;
begin
  result:=-1;
  {if FPassHisCodeList.IndexOf(aCode)>=0 then
    Result:=2
  else}
  if FExceptCodeList.IndexOf(aCode)>=0 then
    Result:=1
  else if FShangShiCodeList.IndexOf(aCode)>=0 then
    Result:=0;
end;


Function TCBDataMgrBase.GetCBData_FullPath():String;
begin
  result := FTr1DBPath+'CBData\Data\';
end;

Function TCBDataMgrBase.GetCBDataFile_FullPath(FileName:String):String;
begin
  result := GetCBData_FullPath+FileName;
end;

function TCBDataMgrBase.CreateEmptyTextFile(aInputFile:string):Boolean;
var xts:TStringList; xPath:string; 
begin
  result:=false;
  xPath:=ExtractFilePath(aInputFile);
  if not DirectoryExists(xPath) then
    exit;
  xts:=TStringList.create;
  try
    xts.SaveToFile(aInputFile);
    result:=true;
  finally
    try FreeAndNil(xts); except end;
  end;
end;

function TCBDataMgrBase.CreateEmptycbstopconvdat(aInputFile:string):Boolean;
begin
  result:=false;
end;

function TCBDataMgrBase.CreateCBDataFileIfNotExists(FileName:String):boolean;
var sFN:string; 
begin
  result:=false;
  if FileExists(FileName) then
  begin
    result:=true;
    exit;
  end;
  sFN:=ExtractFileName(FileName);
  if SameText(sFN,'cbstopconv.dat') then
  begin
    result:=CreateEmptycbstopconvdat(FileName);
  end
  else begin
    result:=CreateEmptyTextFile(FileName);
  end;
end;

function TCBDataMgrBase.GetCBDataTextFileName(FileName: String): String;
Var
  FileName2,sPath : String;
  F :TextFile;
begin
Try
    result:='';
    if lowercase(FileName)='shenbaoset.dat' Then
       FileName2 := FTr1DBPath+'CBData\Document\'+FileName
    else if lowercase(FileName)='shenbaoset4.dat' Then
       FileName2 := FTr1DBPath+'CBData\Document\'+FileName
    else if (pos('shenbaocase',lowercase(FileName))>0) Then
       FileName2 := FTr1DBPath+'CBData\ShenBaoCase\'+FileName
    else if lowercase(FileName)=lowercase('tcridata.dat') Then
       FileName2 := FTr1DBPath+'CBData\tcri\'+FileName
    else if lowercase(FileName)=lowercase('StkIndustry.dat') Then
       FileName2 := FTr1DBPath+'CBData\tcri\'+FileName
    else if lowercase(FileName)=lowercase('TcriComClassCode.dat') Then
       FileName2 := FTr1DBPath+'CBData\tcri\'+FileName
    else if lowercase(FileName)=lowercase('TcriComCode.dat') Then
       FileName2 := FTr1DBPath+'CBData\tcri\'+FileName
    else if lowercase(FileName)=lowercase('stkbase1.dat') Then
       FileName2 := FTr1DBPath+'CBData\tcri\'+FileName
    else if lowercase(FileName)=lowercase('bankplevel.dat') Then
       FileName2 := FTr1DBPath+'CBData\tcri\'+FileName
    else if lowercase(FileName)=lowercase('plevelcomcode.dat') Then
       FileName2 := FTr1DBPath+'CBData\tcri\'+FileName

    else if lowercase(FileName)=lowercase('fed.dat') Then
       FileName2 := FTr1DBPath+'RateData\'+FileName
    else if lowercase(FileName)=lowercase('ntd2usd.dat') Then
       FileName2 := FTr1DBPath+'RateData\'+FileName
       
    else if lowercase(FileName)='doclst.dat' Then
       FileName2 := FTr1DBPath+'CBData\Document\'+FileName
    else if lowercase(FileName)='zz_cbtodayhint.dat' Then
       FileName2 := FTr1DBPath+'CBData\TodayHint\'+'zz_'+
                         FormatDateTime('yyyymmdd',Date)+'.DAT'
    else if lowercase(FileName)='zz_todayhintidlst.dat' Then
       FileName2 := FTr1DBPath+'CBData\TodayHint\'+fileName
    else if lowercase(FileName)='sz_cbtodayhint.dat' Then
       FileName2 := FTr1DBPath+'CBData\TodayHint\'+'sz_'+
                         FormatDateTime('yyyymmdd',Date)+'.DAT'
    else if lowercase(FileName)='sz_todayhintidlst.dat' Then
       FileName2 := FTr1DBPath+'CBData\TodayHint\'+fileName
    else if (Pos('cbdealer@',lowercase(FileName))=1) Then
       FileName2 := FTr1DBPath+'CBData\Dealer\'+Copy(FileName,10,12)
    else if lowercase(FileName)='cbdealerindex.dat' Then
       FileName2 := FTr1DBPath+'CBData\Dealer\'+fileName
    else if lowercase(FileName)='secindex.dat' Then
       FileName2 := FTr1DBPath+'CBData\Dealer\'+fileName
    else if (Pos('threetrader@',lowercase(FileName))=1) Then
       FileName2 := FTr1DBPath+'CBData\ThreeTrader\'+Copy(FileName,Length('threetrader@') + 1,12)
    else if (Pos('balancedat@',lowercase(FileName))=1) Then
    begin
       FileName2 := FTr1DBPath+'CBData\balancedat\'+Copy(FileName,Length('balancedat@') + 1,Length(FileName));
       if not DirectoryExists(ExtractFilePath(FileName2)) then
       begin
         ForceDirectories(ExtractFilePath(FileName2));
       end;
    end
    else if lowercase(FileName)='threetraderlst.dat' Then
       FileName2 := FTr1DBPath+'CBData\ThreeTrader\'+fileName
    else if lowercase(FileName)='stkindex.dat' Then
       FileName2 := FTr1DBPath+'CBData\ThreeTrader\'+fileName
    else if (pos('shenbao',lowercase(FileName))>0) and
            (pos('_doclst.dat',lowercase(FileName))>0)then
    begin
       FileName:=StringReplace(FileName,'shenbao','',[rfReplaceAll, rfIgnoreCase]);
       FileName2 := FTr1DBPath+'CBData\Document\ShenBaoDoc\'+FileName;
    end
    else if pos('_doclst.dat',lowercase(FileName))>0 then
       FileName2 := FTr1DBPath+'CBData\Document\StockDocIdxLst\'+FileName
    else
       FileName2 := FTr1DBPath+'CBData\Data\'+FileName;
       
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);  //粂承ゅン
       closeFile(F)
     end;

     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;

function GetAEnableIFRSUploadNo:string;
var i:integer; sNo,sPath,sFile:string;
begin
  Result:='';
  sPath:=ExtractFilePath(ParamStr(0))+'data\';
  for i:=20 to 10000 do
  begin
    Application.ProcessMessages;
    sFile:=sPath+'upload_ifrs'+inttostr(i)+'.cb';
    if not FileExists(sFile) then
    begin
      result:=inttostr(i);
      exit;
    end;
  end;
end;

procedure Sort(Var aRecLst:TList);
var
  i,j:integer;
  Rec_tmp,Reci,Recj :PTDLst;
begin
try
  if(aRecLst.Count<0)then exit;
  For i:=0 To aRecLst.Count-2 Do
  Begin
    For j:=i+1 To aRecLst.Count-1 Do
    begin
      Reci:=aRecLst[i];
      Recj:=aRecLst[j];
      if((Reci.MEMO)>(Recj.MEMO))then
      begin
        Rec_tmp:=Reci;
        Reci:=Recj;
        Recj:=Rec_tmp;
      end;
      aRecLst[i]:=Reci;
      aRecLst[j]:=Recj;
    end;
  End;
except
end;
end;

function TCBDataMgrBase.GetNewDatFile(aSrcFile:string):string;
var spath,sname,sext:string;
begin
  result:='';
  spath:=ExtractFilePath(aSrcFile);
  sname:=ExtractFileName(aSrcFile);
  sname:=ChangeFileExt(sname,'');
  sext:=ExtractFileExt(aSrcFile);
  Result:=sPath+sname+CNew+sext;
end;

function TCBDataMgrBase.GetNewStopDatFile(aSrcFile:string):string;
var spath,sname,sext:string;
begin
  result:='';
  spath:=ExtractFilePath(aSrcFile);
  sname:=ExtractFileName(aSrcFile);
  sname:=ChangeFileExt(sname,'');
  sext:=ExtractFileExt(aSrcFile);
  Result:=sPath+sname+CNewStop+sext;
end;
{
function TCBDataMgrBase.GetPassHisDatFile(aSrcFile,aExtractYear:string):string;
var spath,sname,sext:string;
begin
  result:='';
  spath:=ExtractFilePath(aSrcFile)+aExtractYear+'\';
  sname:=ExtractFileName(aSrcFile);
  sname:=ChangeFileExt(sname,'');
  sext:=ExtractFileExt(aSrcFile);
  Result:=sPath+sname+sext;
end;

procedure TCBDataMgrBase.RefreshPassHisList(aSrcText:string);
var i,j:integer;
    sFile,sLine,sName:string;
    ts:TStringList;
begin
  try
    FPassHisCodeList.clear;
    ts:=TStringList.create;
      ts.Clear;
      ts.Text:=aSrcText;
      for j:=0 to ts.Count-1 do
      begin
        sLine:=Trim(ts[j]);
          if Pos('TradeCode=',sLine)=1 then
          begin
            ReplaceSubString('TradeCode=','',sLine);
            sLine:=Trim(sLine);
            if (sLine<>'') and
               (FPassHisCodeList.IndexOf(sLine)=-1) then
              FPassHisCodeList.Add(sLine);
          end
          else if Pos('BID=',sLine)=1 then
          begin
            ReplaceSubString('BID=','',sLine);
            sLine:=Trim(sLine);
            if (sLine<>'') and
               (FPassHisCodeList.IndexOf(sLine)=-1) then
              FPassHisCodeList.Add(sLine);
          end;
      end;
  finally
    FreeAndNil(ts);
  end;
end; }

procedure TCBDataMgrBase.RefreshExceptList;
var sAryCodeFile:array of string;
    i,j:integer;
    sFile,sLine,sName:string;
    ts:TStringList;
    bIsPassWay:boolean;
begin
  //RefreshPassHisList('');
  try
    FExceptCodeList.clear;
    ts:=TStringList.create;
    SetLength(sAryCodeFile,1);
    sAryCodeFile[0]:=FTr1DBPath+'CBData\market_db\'+_PasswayTxt;

    for i:=0 to High(sAryCodeFile) do
    begin
      ts.Clear;
      if FileExists(sAryCodeFile[i]) then
        ts.LoadFromFile(sAryCodeFile[i])
      else Continue;
      sname:=ExtractFileName(sAryCodeFile[i]);
      bIsPassWay:=SameText('passaway.txt',sname);
      for j:=0 to ts.Count-1 do
      begin
        sLine:=Trim(ts[j]);
          if Pos('TradeCode=',sLine)=1 then
          begin
            ReplaceSubString('TradeCode=','',sLine);
            sLine:=Trim(sLine);
            if sLine<>'' then FExceptCodeList.Add(sLine);
          end
          else if Pos('TraderCodeEcb=',sLine)=1 then
          begin
            ReplaceSubString('TraderCodeEcb=','',sLine);
            sLine:=Trim(sLine);
            if sLine<>'' then FExceptCodeList.Add(sLine);
          end
          else if Pos('BID=',sLine)=1 then
          begin
            ReplaceSubString('BID=','',sLine);
            sLine:=Trim(sLine);
            if sLine<>'' then FExceptCodeList.Add(sLine);
          end;
      end;
    end;
  finally
    SetLength(sAryCodeFile,0);
    FreeAndNil(ts);
  end;
end;

procedure TCBDataMgrBase.RefreshShangShiCodeList;
var sAryCodeFile:array of string;
    i,j:integer;
    sFile,sLine,sName:string;
    ts:TStringList;

    function Getmarket_dbFileList(sIniFile:string):boolean;
    var fini:TiniFile; sVarFiles:string;
        tsVar:TStringList; iVar1,iVar2,iVar3:integer;
    begin
      Result:=false;
      fini:=nil; tsVar:=nil;
      if not FileExists(sIniFile) then exit;
      try
        fini:=TIniFile.create(sIniFile);
        tsVar:=TStringList.create;
        sVarFiles:=fini.ReadString('dblst','filename','');
        sVarFiles:=StringReplace(sVarFiles,',',#13#10,[rfReplaceAll]);
        tsVar.text:=sVarFiles;
        if tsVar.Count>0 then
        begin
          iVar1:=Length(sAryCodeFile);
          iVar2:=iVar1+tsVar.Count;
          SetLength(sAryCodeFile,iVar2);
          for iVar3:=0 to tsVar.Count-1 do
          begin
            sAryCodeFile[iVar1+iVar3]:='';
            if SameText('passaway.txt',tsVar[iVar3]) then continue;
            sAryCodeFile[iVar1+iVar3]:=ExtractFilePath(sIniFile)+tsVar[iVar3];
          end;
        end;
      finally
        try if fini<>nil then FreeAndNil(fini); except end;
        try if tsVar<>nil then FreeAndNil(tsVar); except end;
      end;
      result:=true;
    end;

begin
  try
    FShangShiCodeList.clear;
    ts:=TStringList.create;
    SetLength(sAryCodeFile,0);
    Getmarket_dbFileList(FTr1DBPath+'CBData\publish_db\dblst.lst');
    Getmarket_dbFileList(FTr1DBPath+'CBData\market_db\dblst2.lst');

    for i:=0 to High(sAryCodeFile) do
    begin
      ts.Clear;
      if sAryCodeFile[i]='' then continue;
      if FileExists(sAryCodeFile[i]) then
        ts.LoadFromFile(sAryCodeFile[i])
      else continue;
      sname:=ExtractFileName(sAryCodeFile[i]);
      for j:=0 to ts.Count-1 do
      begin
          sLine:=Trim(ts[j]);
          if Pos('TradeCode=',sLine)=1 then
          begin
            ReplaceSubString('TradeCode=','',sLine);
            sLine:=Trim(sLine);
            if sLine<>'' then FShangShiCodeList.Add(sLine);
          end
          else if Pos('TraderCodeEcb=',sLine)=1 then
          begin
            ReplaceSubString('TraderCodeEcb=','',sLine);
            sLine:=Trim(sLine);
            if sLine<>'' then FShangShiCodeList.Add(sLine);
          end
          else if Pos('BID=',sLine)=1 then
          begin
            ReplaceSubString('BID=','',sLine);
            sLine:=Trim(sLine);
            if sLine<>'' then FShangShiCodeList.Add(sLine);
          end;
      end;
    end;
  finally
    SetLength(sAryCodeFile,0);
    FreeAndNil(ts);
  end;
end;

function TCBDataMgrBase.ProSep_Cbidx2OrCbidx(sTagFile:string;aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4:TStringList;
    sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             iCodeType:=CodeInType(ID);
             if iCodeType=1 then
               ts3.Add(ts4.text)
             else if iCodeType=0 then 
               ts2.Add(ts4.text);
               
              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
    iCodeType:=CodeInType(ID);
    if iCodeType=1 then
     ts3.Add(ts4.text)
    else if iCodeType=0 then 
     ts2.Add(ts4.text);
    ts4.Clear;
    ID := '';
  End;
  if aFtpNotXiaShi then
  ts2.SaveToFile(sFile2);
  if aFtpXiaShi then
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSep_cbidx(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
begin
  result:=ProSep_Cbidx2OrCbidx('cbidx.dat',aFtpXiaShi,aFtpNotXiaShi);
end;

function TCBDataMgrBase.ProSep_cbidx2(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
begin
  result:=ProSep_Cbidx2OrCbidx('cbidx2.dat',aFtpXiaShi,aFtpNotXiaShi);
end;

function TCBDataMgrBase.ProSepPassHis_cbidx(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbidx.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;

  ts1:=nil; ts2:=nil; ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             iCodeType:=CodeInType(ID);
             if iCodeType=2 then
               ts2.Add(ts4.text);

              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
    iCodeType:=CodeInType(ID);
    if iCodeType=2 then 
     ts2.Add(ts4.text);
    ts4.Clear;
    ID := '';
  End;
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSepPassHis_cbissue2(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID,sLine:string;
    i,j,k,index,i2,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbissue2.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;
  
  ts1:=nil; ts2:=nil; ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  i2:=0;
  ts2.Add('[ISSUE]');
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    k:=Pos('=',str);
    if k<=0 then Continue;
    sTemp1:=Copy(Str,1,k-1);
    sTemp2:=Copy(Str,k+1,Length(str));
    j:=Pos(',',sTemp2);
    if j<=0 then Continue;
    sTemp3:=Copy(sTemp2,1,j-1);
    ID:=Trim(sTemp3);
    if Length(ID)>0 Then
    Begin
       iCodeType:=CodeInType(ID);
       if iCodeType=2 then
       begin
         Inc(i2);
         sLine:=inttostr(i2)+'='+sTemp2;
         ts2.Add(sLine);
       end;
    End;

  End;
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSep_cbissue2(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID,sLine:string;
    i,j,k,index,i2,i3,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbissue2.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  i2:=0; i3:=0;
  ts2.Add('[ISSUE]');
  ts3.Add('[ISSUE]');
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    k:=Pos('=',str);
    if k<=0 then Continue;
    sTemp1:=Copy(Str,1,k-1);
    sTemp2:=Copy(Str,k+1,Length(str));
    j:=Pos(',',sTemp2);
    if j<=0 then Continue;
    sTemp3:=Copy(sTemp2,1,j-1);
    ID:=Trim(sTemp3);
    if Length(ID)>0 Then
    Begin
       iCodeType:=CodeInType(ID);
       if iCodeType=1 then
       begin
         Inc(i3);
         sLine:=inttostr(i3)+'='+sTemp2;
         ts3.Add(sLine);
       end
       else if iCodeType=0 then
       begin
         Inc(i2);
         sLine:=inttostr(i2)+'='+sTemp2;
         ts2.Add(sLine);
       end;
    End;

  End;
  if aFtpNotXiaShi then 
  ts2.SaveToFile(sFile2);
  if aFtpXiaShi then 
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSepPassHis_cbpurpose(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbpurpose.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;
  
  ts1:=nil; ts2:=nil; ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('<ID=',Str)=1) and
       (Pos('>',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('<ID=','',Str);
        ReplaceSubString('>','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             iCodeType:=CodeInType(ID);
             if iCodeType=2 then
               ts2.Add(ts4.text);
              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('<ID='+ID+'>');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
    iCodeType:=CodeInType(ID);
    if iCodeType=2 then
     ts2.Add(ts4.text);
    ts4.Clear;
    ID := '';
  End;
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSep_cbpurpose(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbpurpose.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('<ID=',Str)=1) and
       (Pos('>',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('<ID=','',Str);
        ReplaceSubString('>','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             iCodeType:=CodeInType(ID);
             if iCodeType=1 then
               ts3.Add(ts4.text)
             else if iCodeType=0 then
               ts2.Add(ts4.text);
              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('<ID='+ID+'>');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
    iCodeType:=CodeInType(ID);
    if iCodeType=1 then
     ts3.Add(ts4.text)
    else if iCodeType=0 then
     ts2.Add(ts4.text);
    ts4.Clear;
    ID := '';
  End;
  if aFtpNotXiaShi then 
  ts2.SaveToFile(sFile2);
  if aFtpXiaShi then 
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;


function TCBDataMgrBase.ProSepPassHis_cbdoc(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbdoc.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  
  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;

  ts1:=nil; ts2:=nil; ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('<ID=',Str)=1) and
       (Pos('>',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('<ID=','',Str);
        ReplaceSubString('>','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             iCodeType:=CodeInType(ID);
             if iCodeType=2 then
               ts2.Add(ts4.text);
              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('<ID='+ID+'>');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
    iCodeType:=CodeInType(ID);
    if iCodeType=2 then
      ts2.Add(ts4.text);
    ts4.Clear;
    ID := '';
  End;
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSep_cbdoc(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbdoc.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('<ID=',Str)=1) and
       (Pos('>',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('<ID=','',Str);
        ReplaceSubString('>','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             iCodeType:=CodeInType(ID);
             if iCodeType=1 then
               ts3.Add(ts4.text)
             else if iCodeType=0 then 
               ts2.Add(ts4.text);
              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('<ID='+ID+'>');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
    iCodeType:=CodeInType(ID);
    if iCodeType=1 then
     ts3.Add(ts4.text)
    else if iCodeType=0 then 
     ts2.Add(ts4.text);
    ts4.Clear;
    ID := '';
  End;
  if aFtpNotXiaShi then 
  ts2.SaveToFile(sFile2);
  if aFtpXiaShi then 
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSepPassHis_cbstockholder(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID,ID2:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbstockholder.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  
  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;

  ts1:=nil; ts2:=nil; ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
		sametext(ID,'GUID') then
             begin
               ts2.Add(ts4.text);
             end
             else begin
               ID2:=ID;
               if (Pos('D',ID2)=1) and (Pos('_',ID2)>0) then
                 ID2:=GetStrOnly2('D','_',ID2,false);
               iCodeType:=CodeInType(ID2);
               if iCodeType=2 then
                 ts2.Add(ts4.text);
             end;
             ts4.Clear;
             ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
      sametext(ID,'GUID') then
   begin
     ts2.Add(ts4.text);
   end
   else begin
     ID2:=ID;
     if (Pos('D',ID2)=1) and (Pos('_',ID2)>0) then
       ID2:=GetStrOnly2('D','_',ID2,false);
     iCodeType:=CodeInType(ID2);
     if iCodeType=2 then
       ts2.Add(ts4.text);
   end;
   ts4.Clear;
   ID := '';
  End;
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSep_cbstockholder(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID,ID2:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbstockholder.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
			    sametext(ID,'GUID') then
             begin
               ts3.Add(ts4.text);
               ts2.Add(ts4.text);
             end
             else begin
               ID2:=ID;
               if (Pos('D',ID2)=1) and (Pos('_',ID2)>0) then
                 ID2:=GetStrOnly2('D','_',ID2,false);
               iCodeType:=CodeInType(ID2);
               if iCodeType=1 then
                 ts3.Add(ts4.text)
               else if iCodeType=0 then
                 ts2.Add(ts4.text);
             end;
             ts4.Clear;
             ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
                  sametext(ID,'GUID') then
   begin
     ts3.Add(ts4.text);
     ts2.Add(ts4.text);
   end
   else begin
     ID2:=ID;
     if (Pos('D',ID2)=1) and (Pos('_',ID2)>0) then
       ID2:=GetStrOnly2('D','_',ID2,false);
     iCodeType:=CodeInType(ID2);
     if iCodeType=1 then
       ts3.Add(ts4.text)
     else if iCodeType=0 then
       ts2.Add(ts4.text);
   end;
   ts4.Clear;
   ID := '';
  End;
  if  aFtpNotXiaShi then 
  ts2.SaveToFile(sFile2);
  if  aFtpXiaShi then 
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSepPassHis_cbredeemdate(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbredeemdate.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sNewGuid:=Get_GUID8;
  SaveIniFile(PChar('GUID'),PChar('GUID'),PChar(sNewGuid),PChar(sFile1));

  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;

  ts1:=nil; ts2:=nil; ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
                sametext(ID,'GUID') then
             begin
               ts2.Add(ts4.text);
             end
             else begin
               iCodeType:=CodeInType(ID);
               if iCodeType=2 then
                 ts2.Add(ts4.text);
             end;
              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
      sametext(ID,'GUID') then
   begin
     ts2.Add(ts4.text);
   end
   else begin
     iCodeType:=CodeInType(ID);
     if iCodeType=2 then
       ts2.Add(ts4.text);
   end;
    ts4.Clear;
    ID := '';
  End;
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSep_cbredeemdate(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbredeemdate.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sNewGuid:=Get_GUID8;
  SaveIniFile(PChar('GUID'),PChar('GUID'),PChar(sNewGuid),PChar(sFile1));

  
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
                sametext(ID,'GUID') then
             begin
               ts3.Add(ts4.text);
               ts2.Add(ts4.text);
             end
             else begin
               iCodeType:=CodeInType(ID);
               if iCodeType=1 then
                 ts3.Add(ts4.text)
               else if iCodeType=0 then 
                 ts2.Add(ts4.text);
             end;
              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
      sametext(ID,'GUID') then
   begin
     ts3.Add(ts4.text);
     ts2.Add(ts4.text);
   end
   else begin
     iCodeType:=CodeInType(ID);
     if iCodeType=1 then
       ts3.Add(ts4.text)
     else if iCodeType=0 then 
       ts2.Add(ts4.text);
   end;
    ts4.Clear;
    ID := '';
  End;
  if aFtpNotXiaShi then
  ts2.SaveToFile(sFile2);
  if aFtpXiaShi then
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSepPassHis_cbsaledate(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbsaledate.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sNewGuid:=Get_GUID8;
  SaveIniFile(PChar('GUID'),PChar('GUID'),PChar(sNewGuid),PChar(sFile1));

  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;

  ts1:=nil; ts2:=nil; ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;


  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
                sametext(ID,'GUID') then
             begin
               ts2.Add(ts4.text);
             end
             else begin
               iCodeType:=CodeInType(ID);
               if iCodeType=2 then
                 ts2.Add(ts4.text);
             end;
              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
      sametext(ID,'GUID') then
   begin
     ts2.Add(ts4.text);
   end
   else begin
     iCodeType:=CodeInType(ID);
     if iCodeType=2 then
       ts2.Add(ts4.text);
   end;
    ts4.Clear;
    ID := '';
  End;
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSep_cbsaledate(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbsaledate.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sNewGuid:=Get_GUID8;
  SaveIniFile(PChar('GUID'),PChar('GUID'),PChar(sNewGuid),PChar(sFile1));

  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
                sametext(ID,'GUID') then
             begin
               ts3.Add(ts4.text);
               ts2.Add(ts4.text);
             end
             else begin
               iCodeType:=CodeInType(ID);
               if iCodeType=1 then
                 ts3.Add(ts4.text)
               else if iCodeType=0 then 
                 ts2.Add(ts4.text);
             end;
              ts4.Clear;
              ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
      sametext(ID,'GUID') then
   begin
     ts3.Add(ts4.text);
     ts2.Add(ts4.text);
   end
   else begin
     iCodeType:=CodeInType(ID);
     if iCodeType=1 then
       ts3.Add(ts4.text)
     else if iCodeType=0 then 
       ts2.Add(ts4.text);
   end;
    ts4.Clear;
    ID := '';
  End;
  if aFtpNotXiaShi then 
  ts2.SaveToFile(sFile2);
  if aFtpXiaShi then 
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSepPassHis_cbstopconv(aExtractYear:string):string;
begin
  result:='';
end;

function TCBDataMgrBase.ProSep_cbstopconv(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
begin
  result:='';
end;

function TCBDataMgrBase.ProSepPassHis_strike2(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='strike4.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  sNewGuid:=Get_GUID8;
  SaveIniFile(PChar('GUID'),PChar('GUID'),PChar(sNewGuid),PChar(sFile1));
  
  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;
  
  ts1:=nil; ts2:=nil; ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
			    sametext(ID,'GUID') then
             begin
               ts2.Add(ts4.text);
             end
             else begin
               iCodeType:=CodeInType(ID);
               if iCodeType=2 then
                 ts2.Add(ts4.text);
             end;
             ts4.Clear;
             ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
                  sametext(ID,'GUID') then
   begin
     ts2.Add(ts4.text);
   end
   else begin
     iCodeType:=CodeInType(ID);
     if iCodeType=2 then
       ts2.Add(ts4.text);
   end;
   ts4.Clear;
   ID := '';
  End;
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSep_strike2(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
const
  _TempFlag='temp_';
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID,sTempID:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='strike4.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sNewGuid:=Get_GUID8;
  SaveIniFile(PChar('GUID'),PChar('GUID'),PChar(sNewGuid),PChar(sFile1));
  
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
                sametext(ID,'ReasonList2') or
		sametext(ID,'GUID') then
             begin
               ts3.Add(ts4.text);
               ts2.Add(ts4.text);
             end
             else begin
               sTempID:=ID;
               if Pos(_TempFlag,sTempID)>0 then
               begin
                 ReplaceSubString(_TempFlag,'',sTempID);
               end;
               iCodeType:=CodeInType(sTempID);
               if iCodeType=1 then
                 ts3.Add(ts4.text)
               else if iCodeType=0 then 
                 ts2.Add(ts4.text);
             end;
             ts4.Clear;
             ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
                  sametext(ID,'GUID') then
   begin
     ts3.Add(ts4.text);
     ts2.Add(ts4.text);
   end
   else begin
     sTempID:=ID;
     if Pos(_TempFlag,sTempID)>0 then
     begin
       ReplaceSubString(_TempFlag,'',sTempID);
     end;
     iCodeType:=CodeInType(sTempID);
     if iCodeType=1 then
       ts3.Add(ts4.text)
     else if iCodeType=0 then 
       ts2.Add(ts4.text);
   end;
   ts4.Clear;
   ID := '';
  End;
  if aFtpNotXiaShi then
  ts2.SaveToFile(sFile2);
  if aFtpXiaShi then 
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSepPassHis_strike3(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID,sLine:string;
    i,j,k,index,i2,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='strike3.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;

  ts1:=nil; ts2:=nil; ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  i2:=0;
  ts2.Add('[STRIKE]');
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    k:=Pos('=',str);
    if k<=0 then Continue;
    sTemp1:=Copy(Str,1,k-1);
    sTemp2:=Copy(Str,k+1,Length(str));
    j:=Pos(',',sTemp2);
    if j<=0 then Continue;
    sTemp3:=Copy(sTemp2,1,j-1);
    ID:=Trim(sTemp3);
    if Length(ID)>0 Then
    Begin
       iCodeType:=CodeInType(ID);
       if iCodeType=2 then begin
         Inc(i2);
         sLine:=inttostr(i2)+'='+sTemp2;
         ts2.Add(sLine);
       end;
    End;
  End;
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSep_strike32(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
begin
  result:=ProSep_strike32Orstrike3('strike32.dat',aFtpXiaShi,aFtpNotXiaShi);
end;

function TCBDataMgrBase.ProSep_strike3(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
begin
  result:=ProSep_strike32Orstrike3('strike3.dat',aFtpXiaShi,aFtpNotXiaShi);
end;

function TCBDataMgrBase.ProSep_strike32Orstrike3(sTagFile:string;aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4:TStringList;
    sTemp1,sTemp2,sTemp3,sPath,Str,ID,sLine:string; 
    i,j,k,index,i2,i3,iCodeType:integer;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  i2:=0; i3:=0;
  ts2.Add('[STRIKE]');
  ts3.Add('[STRIKE]');
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    k:=Pos('=',str);
    if k<=0 then Continue;
    sTemp1:=Copy(Str,1,k-1);
    sTemp2:=Copy(Str,k+1,Length(str));
    j:=Pos(',',sTemp2);
    if j<=0 then Continue;
    sTemp3:=Copy(sTemp2,1,j-1);
    ID:=Trim(sTemp3);
    if Length(ID)>0 Then
    Begin
       iCodeType:=CodeInType(ID);
       if iCodeType=1 then
       begin
         Inc(i3);
         sLine:=inttostr(i3)+'='+sTemp2;
         ts3.Add(sLine);
       end
       else if iCodeType=0 then begin
         Inc(i2);
         sLine:=inttostr(i2)+'='+sTemp2;
         ts2.Add(sLine);
       end;
    End;
  End;
  if aFtpNotXiaShi then
  ts2.SaveToFile(sFile2);
  if aFtpXiaShi then 
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
End;
end;

function TCBDataMgrBase.ProSepPassHis_cbdate(aExtractYear:string):string;
var sFile1,sFile2:string;
    ts1,ts2,ts4,ts5:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbdate.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;

  ts1:=nil; ts2:=nil; ts4:=nil; ts5:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts4 := TStringList.Create;
  ts5 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if pos('-->',str)>0 then
    begin
      ts5.Add(str);
      continue;
    end;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
			    sametext(ID,'GUID') then
             begin
               ts2.Add(ts4.text);
             end
             else begin
               iCodeType:=CodeInType(ID);
               if iCodeType=2 then
                 ts2.Add(ts4.text);
             end;
             ts4.Clear;
             ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
                  sametext(ID,'GUID') then
   begin
     ts2.Add(ts4.text);
   end
   else begin
     iCodeType:=CodeInType(ID);
     if iCodeType=2 then
       ts2.Add(ts4.text);
   end;
   ts4.Clear;
   ID := '';
  End;
  ts2.Insert(0,ts5.text);
  ts2.SaveToFile(sFile2);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts4) Then
     ts4.Free;
  if Assigned(ts5) Then
     ts5.Free;
End;
end;

function TCBDataMgrBase.ProSep_cbdate(aFtpXiaShi,aFtpNotXiaShi:boolean):string;  //重要日期
var sFile1,sFile2,sFile3:string;
    ts1,ts2,ts3,ts4,ts5:TStringList;
    sTagFile,sTemp1,sTemp2,sTemp3,sPath,Str,ID:string;
    i,j,k,index,iCodeType:integer;
    sNewGuid:string;
begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbdate.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
  ts1:=nil; ts2:=nil; ts3:=nil;ts4:=nil;
Try
Try
  ts1 := TStringList.Create;
  ts2 := TStringList.Create;
  ts3 := TStringList.Create;
  ts4 := TStringList.Create;
  ts5 := TStringList.Create;

  ts1.LoadFromFile(sFile1);
  ID := '';
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if Trim(str)='' then Continue;
    if pos('-->',str)>0 then
    begin
      ts5.Add(str);
      continue;
    end;
    if (Pos('[',Str)=1) and
       (Pos(']',Str)=Length(Str)) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID<>Str Then
        Begin
           if Length(ID)>0 Then
           Begin
             if sametext(ID,'ReasonList') or
			    sametext(ID,'GUID') then
             begin
               ts3.Add(ts4.text);
               ts2.Add(ts4.text);
             end
             else begin
               iCodeType:=CodeInType(ID);
               if iCodeType=1 then
                 ts3.Add(ts4.text)
               else if iCodeType=0 then 
                 ts2.Add(ts4.text);
             end;
             ts4.Clear;
             ID := '';
           End;
           ID := Str;
           ts4.Add('['+ID+']');
           Continue;
        End;
    End;
    if Length(ID)>0 Then
    Begin
        ts4.Add(Str);
    End;
  End;
  if Length(ID)>0 Then
  Begin
   if sametext(ID,'ReasonList') or
                  sametext(ID,'GUID') then
   begin
     ts3.Add(ts4.text);
     ts2.Add(ts4.text);
   end
   else begin
     iCodeType:=CodeInType(ID);
     if iCodeType=1 then
       ts3.Add(ts4.text)
     else if iCodeType=0 then 
       ts2.Add(ts4.text);
   end;
   ts4.Clear;
   ID := '';
  End;
  ts2.Insert(0,ts5.text);
  ts3.Insert(0,ts5.text);
  if aFtpNotXiaShi then
  ts2.SaveToFile(sFile2);
  if aFtpXiaShi then 
  ts3.SaveToFile(sFile3);
  result:=sFile1;
Except
End;
Finally
  if Assigned(ts1) Then
     ts1.Free;
  if Assigned(ts2) Then
     ts2.Free;
  if Assigned(ts3) Then
     ts3.Free;
  if Assigned(ts4) Then
     ts4.Free;
  if Assigned(ts5) Then
     ts5.Free;
End;
end;


function GetdbFileList(adbLstFile:string; var ts:TStringList):boolean;
var fini:TiniFile; sIniFile,sVarFiles,sVarOneF:string;
    iVar1:integer;
begin
  Result:=false;
  if not Assigned(ts) then
    exit;
  fini:=nil; ts.Clear;
  sIniFile:=adbLstFile;
  if not FileExists(sIniFile) then exit;
  try
    fini:=TIniFile.create(sIniFile);
    sVarFiles:=fini.ReadString('dblst','filename','');
    sVarFiles:=StringReplace(sVarFiles,',',#13#10,[rfReplaceAll]);
    ts.text:=sVarFiles;
    for iVar1:=0 to ts.count-1 do
    begin
      sVarOneF:=Trim(ts[iVar1]);
      if sVarOneF='' then
        continue;
      ts[iVar1]:=ExtractFilePath(adbLstFile)+sVarOneF;
    end;
  finally
    try if fini<>nil then FreeAndNil(fini); except end;
  end;
  result:=true;
end;



{ TCBDataMgr }

function TCBDataMgr.CreateEmptycbstopconvdat(aInputFile:string):Boolean;
var xPath:string; f1 : File Of TSTOPCONV_PERIOD_RPT;
begin
  result:=false;
  xPath:=ExtractFilePath(aInputFile);
  if not DirectoryExists(xPath) then
    exit;
  AssignFile(f1,aInputFile);
  try
    ReWrite(f1);
    result:=true;
  finally
    try CloseFile(f1); except end;
  end;
end;

function TCBDataMgr.ProSep_cbstopconv(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var
  Rec :TSTOPCONV_PERIOD_RPT;
  f1,f2,f3 : File Of TSTOPCONV_PERIOD_RPT;
  sFile1,sFile2,sFile3:string;
  sTagFile,sTemp1,sTemp2,sTemp3,sPath:string;
  i,iCount,iCodeType: Integer;
Begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbstopconv.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
try
  AssignFile(f1,sFile1);
  if aFtpNotXiaShi then AssignFile(f2,sFile2);
  if aFtpXiaShi then AssignFile(f3,sFile3);
  FileMode := 2;
  ReSet(f1);
  if aFtpNotXiaShi then ReWrite(f2);
  if aFtpXiaShi then ReWrite(f3);
  iCount:=FileSize(f1);
  For i:=0 To iCount-1 Do
  Begin
    Seek(f1,i);
    Read(f1,Rec);
    iCodeType:=CodeInType(Rec.ID);
    if iCodeType=1 then
    begin
      if aFtpXiaShi then Write(f3,Rec);
    end
    else if iCodeType=0 then
    begin
      if aFtpNotXiaShi then Write(f2,Rec);
    end;
  End;
  result:=sFile1;
  try CloseFile(f1); except Result:=''; end;
  if aFtpNotXiaShi then try CloseFile(f2); except result:=''; end;
  if aFtpXiaShi then try CloseFile(f3); except Result:=''; end;
Except
  On E:Exception Do
  begin
    e:=nil;
  end;
End;
End;

function TCBDataMgr.ProSepPassHis_cbstopconv(aExtractYear:string):string;
var
  Rec :TSTOPCONV_PERIOD_RPT;
  f1,f2 : File Of TSTOPCONV_PERIOD_RPT;
  sFile1,sFile2:string;
  sTagFile,sTemp1,sTemp2,sTemp3,sPath:string;
  i,iCount,iCodeType: Integer;
Begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbstopconv.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;
try
  AssignFile(f1,sFile1);
  AssignFile(f2,sFile2);

  FileMode := 2;
  ReSet(f1);
  ReWrite(f2);

  iCount:=FileSize(f1);
  For i:=0 To iCount-1 Do
  Begin
    Seek(f1,i);
    Read(f1,Rec);
    iCodeType:=CodeInType(Rec.ID);
    if iCodeType=2 then
    begin
      Write(f2,Rec);
    end;
  End;
  result:=sFile1;
  try CloseFile(f1); except Result:=''; end;
  try CloseFile(f2); except result:=''; end;
Except
  On E:Exception Do
  begin
    e:=nil;
  end;
End;
End;

function TCBDataMgr.LoaclDatDir():string;
begin
  result:=ExtractFilePath(Application.ExeName)+'Data\';
end;

function TCBDataMgr.GetHushiCBText: String;
Var
  FileName : String;
  f : TStringList;
begin

    Result := '';
    FileName := FTr1DBPath+'CBData\Market_db\hushi.txt';
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;

end;

function TCBDataMgr.GetNifaxingCBText: String;
Var
  FileName : String;
  f : TStringList;
begin

    Result := '';
    FileName := FTr1DBPath+'CBData\Publish_db\nifaxing.txt';
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;
end;

function TCBDataMgr.GetPassawayCBText: String;
Var
  FileName : String;
  f : TStringList;
begin
    Result := '';
    FileName := FTr1DBPath+'CBData\Market_db\'+_PasswayTxt;
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;
end;

function TCBDataMgr.GetPassCBText: String;
Var
  FileName : String;
  f : TStringList;
begin
    Result := '';
    FileName := FTr1DBPath+'CBData\Publish_db\pass.txt';
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;
end;

function TCBDataMgr.GetShenshiCBText: String;
Var
  FileName : String;
  f : TStringList;
begin
    Result := '';
    FileName := FTr1DBPath+'CBData\Market_db\Shenshi.txt';
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;
end;

procedure TCBDataMgr.SaveCBTxtToUpLoad(FileFolder,FileName,aOperator,aTimeKey:String;TypeFlag: String ='');  //Doc091120-sun
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile;
   f.SaveToFile(aCBFileName); //--DOC4.0.0—N002 huangcq081223 add
   f.Free;
  //Doc091120-sun------------------------------------------------
   if (TypeFlag = '')  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey)
   else if TypeFlag = 'stockweight' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey,1,'',TypeFlag)
   else if SameText(TypeFlag,'publish_db') or  SameText(TypeFlag,'market_db') then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey,1,'',TypeFlag)
   else if  pos('cbthreetrader',TypeFlag)>0  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey,1,'','cbthreetrader@')
   else if  pos('cbdealer',TypeFlag)>0  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey,1,'','cbdealer@')
  //-----------------------------------------------------------------------------------
end;

procedure TCBDataMgr.SaveCBTxtToUpLoad2(Const aTag,FileFolder,FileName,Operator,aTimeKey: String; TypeFlag:String='');
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile2(aTag);
   f.SaveToFile(aCBFileName); //--DOC4.0.0—N002 huangcq081223 add
   f.Free;

   if TypeFlag = '' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey)
   else if  pos('cbthreetrader',TypeFlag)>0  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey,1,'','cbthreetrader@')
   else if  pos('cbdealer',TypeFlag)>0  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey,1,'','cbdealer@')
end;

procedure TCBDataMgr.SaveCBTxtToUpLoad9(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile7();
   f.SaveToFile(aCBFileName);
   f.Free;
   if (TypeFlag = '') then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey)
   else if  pos('cbthreetrader',TypeFlag)>0  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey,1,'','cbthreetrader@')
   else if  pos('cbdealer',TypeFlag)>0  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey,1,'','cbdealer@')
end;

procedure TCBDataMgr.SaveCBTxtToUpLoad3(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile3();
   f.SaveToFile(aCBFileName); 
   f.Free;
   if TypeFlag = '' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey)
   else if  pos('cbthreetrader',TypeFlag)>0  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey,1,'','cbthreetrader@')
   else if  pos('cbdealer',TypeFlag)>0  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey,1,'','cbdealer@')
end;

procedure TCBDataMgr.SaveCBTxtToUpLoad4(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile4();
   f.SaveToFile(aCBFileName);
   f.Free;
   if TypeFlag = '' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey);
end;

procedure TCBDataMgr.SaveCBTxtToUpLoad5(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile5();
   f.SaveToFile(aCBFileName);
   f.Free;
   if TypeFlag = '' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey); 
end;

procedure TCBDataMgr.SaveCBTxtToUpLoad6(Const FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile6('0',FileName);
   f.SaveToFile(aCBFileName);
   f.Free;
   if TypeFlag = '' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey);
end;

procedure TCBDataMgr.SaveCBTxtToUpLoad7(Const FileFolder,FileName,Operator,aTimeKey:String;TypeFlag,TypeFlag2:String);
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile6(TypeFlag,TypeFlag2);
   f.SaveToFile(aCBFileName);
   f.Free;
   if TypeFlag = '' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey);
end;

procedure TCBDataMgr.SaveCBTxtToUpLoad8(Const FileFolder,FileName,Operator,aTimeKey:String;TypeFlag,TypeFlag2:String);
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile6(TypeFlag,TypeFlag2);
   f.SaveToFile(aCBFileName);
   f.Free;
   SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey);
end;


{ For Example: SetCBDataLog('DocCenter','guapai.txt','..\upload_1.cb',FtpCount,FtpServerName)   }
procedure TCBDataMgr.SetCBDataLog(Const AppName,FileName,UpLoadCBFileName,aOperator,aTimeKey:String;
  FtpServerCount:Integer=1;FtpServerName:String='';TypeFlag:string ='');
var aLogFileName,FileNameEN,FileNameCN,CBFileName,aLogPath:String;
  aF:TIniFile; aDt:TDateTime;
  function TimeKey2TimeStr():string;
  var xstr1,xstr2:string;
  begin
    //xstr1:=Copy(aTimeKey,Length(aTimeKey)-9,Length(aTimeKey));
    //result:=Copy(xstr1,1,2)+':'+Copy(xstr1,3,2)+':'+Copy(xstr1,5,2);
    xstr2:=DateSeparator;
    xstr1:=aTimeKey;
    result:=Copy(xstr1,1,4)+xstr2+Copy(xstr1,5,2)+xstr2+Copy(xstr1,7,2)+' '+
      Copy(xstr1,10,2)+':'+Copy(xstr1,12,2)+':'+Copy(xstr1,14,2)+':'+Copy(xstr1,16,3);
  end;
begin
  if not Assigned(FAppParam) then 
    FAppParam  := TDocMgrParam.Create;
  try
    if Length(FileName)<=0 then exit;
    if not FileExists(UpLoadCBFileName) then exit;
    aDt:=FileDateToDateTime(FileAge(UpLoadCBFileName));
    aLogPath:=LoaclDatDir()+'DwnDocLog\uploadCBData\';
    if not DirectoryExists(aLogPath) then 
      Mkdir_Directory(aLogPath);
    aLogFileName:=aLogPath+Format('%s.log',[FormatDateTime('yymmdd',aDt)]);
    try
      aF := TIniFile.Create(aLogFileName);
      CBFileName := ExtractFileName(UpLoadCBFileName)+'@'+IntToStr(FileAge(UpLoadCBFileName));
      FileNameEN:=ExtractFileName(FileName);
       //--------Doc091120-sun------------------------
       if  pos('cbthreetrader',TypeFlag)>0  then //狦琌猭
          FileNameCN:= FAppParam.TwConvertStr ('猭计沮')+ StrUtils.LeftStr(FileNameEN,8)
       else if  pos('cbdealer',TypeFlag)>0  then  // 犁坝
          FileNameCN:= FAppParam.TwConvertStr ('犁坝计沮')+ StrUtils.LeftStr(FileNameEN,8)
       else if  pos('cbdealer',TypeFlag)>0  then  // 犁坝
          FileNameCN:= FAppParam.TwConvertStr ('犁坝计沮')+ StrUtils.LeftStr(FileNameEN,8)
       else if  pos('irrate',TypeFlag)>0  then  // そ杜瞯
       begin
         CBFileName:='irrate'+CBFileName;
         FileNameCN:= FAppParam.TwConvertStr ('そ杜瞯')+ StringReplace(TypeFlag,'irrate','',[rfIgnoreCase]);
       end
       else if  pos('swapyield',TypeFlag)>0  then  //㏕﹚Μ痲︽薄
       begin
         CBFileName:='swapyield'+CBFileName;
         FileNameCN:= FAppParam.TwConvertStr ('㏕﹚Μ痲︽薄')+ StringReplace(TypeFlag,'swapyield','',[rfIgnoreCase]);
       end
       else if  pos('swapoption',TypeFlag)>0  then  //匡拒舦︽薄
       begin
         CBFileName:='swapoption'+CBFileName;
         FileNameCN:= FAppParam.TwConvertStr ('匡拒舦︽薄')+ StringReplace(TypeFlag,'swapoption','',[rfIgnoreCase]);
       end
       else if  pos('stockweight',TypeFlag)>0  then
       begin
         CBFileName:=CBFileName;
         FileNameCN:= FAppParam.TwConvertStr ('だ皌戈')+ ExtractFileName(FileName);
       end
       else FileNameCN:= GetCBNameFromConfig(FileNameEN);
      //---------------------------------------------

      if UpperCase(AppName)='DOCCENTER' then
      begin
        //aF.WriteString('DocCenter',FileNameEN,CBFileName);
        aF.WriteString(CBFileName,'operator',aOperator);
        aF.WriteString(CBFileName,'timekey',aTimeKey);

        aF.WriteString(CBFileName,'FileNameCN',FileNameCN);
        aF.WriteString(CBFileName,'FileNameEN',FileNameEN);
        aF.WriteString(CBFileName,AppName,TimeKey2TimeStr);
        if SameText(TypeFlag,'publish_db') or  SameText(TypeFlag,'market_db') then
          aF.WriteString(CBFileName,'node','1');
      end;//end if DocCenter

      //if  UpperCase(AppName)='DOCFTP' then
      if PosEx('DOCFTP',UpperCase(AppName))>0 then
      begin
        if Length(FtpServerName)<=0 then exit;
        aF.WriteInteger(CBFileName,'CBFtpServerCount',FtpServerCount);
        aF.WriteString(CBFileName,AppName,FormatDateTime('hh:mm:ss',Now)+#9+FtpServerName);
      end;//end if DocFtp

    finally
      aF.Free;
    end;
  except
    //on E:Exception do
      //Showmessage(e.Message);
  end;
end;


function TCBDataMgr.FinishUploadCBDataByLog(FileName,UpLoadCBFileName:String;FtpServerCount:Integer):Boolean;
var aLogFileName,FileNameEN,CBFileName:String;
  aF:TIniFile; ic,i:integer; aDt:TDateTime;
begin
  result:=false;
  if FtpServerCount=0 then
  begin
    result:=true;
    exit;
  end;
  if not FileExists(UpLoadCBFileName) then
  begin
    result:=true;
    exit;
  end;
  try
    aDt := FileDateToDateTime(FileAge(UpLoadCBFileName));
    aLogFileName := LoaclDatDir()+'DwnDocLog\uploadCBData\'+
                    Format('%s.log',[FormatDateTime('yymmdd',aDt)]);
    if not FileExists(aLogFileName) then
      exit;
    try
      aF := TIniFile.Create(aLogFileName);
      CBFileName := ExtractFileName(UpLoadCBFileName)+'@'+IntToStr(FileAge(UpLoadCBFileName));
      FileNameEN:=ExtractFileName(FileName);
      for i:=1 to FtpServerCount do
      begin
        if aF.ReadString(CBFileName,Format('DocFtp_%d',[i]),'')='' then
        begin
          exit;
        end;
      end;
      result:=true;
    finally
      aF.Free;
    end;
  except
    //on E:Exception do
      //Showmessage(e.Message);
  end;
end;

Function TCBDataMgr.GetIFRSTr1dbData(aYear,aQ,aCode,aTr1dbDatPath,aDstFile1,aDstFile2,aDstFile3:String):boolean;
var sFile1,sFile2,sFile3:string;
begin
  result:=false;
  sFile1:=Format('%s%s_%s_1.dat',[aTr1dbDatPath,aYear,aQ]);
  sFile2:=Format('%s%s_%s_2.dat',[aTr1dbDatPath,aYear,aQ]);
  sFile3:=Format('%s%s_%s_3.dat',[aTr1dbDatPath,aYear,aQ]);
  if GetIFRSFile2File(sFile1,aDstFile1,aCode) and
     GetIFRSFile2File(sFile2,aDstFile2,aCode) and
     GetIFRSFile2File(sFile3,aDstFile3,aCode) then
    result:=true;
end;

Function TCBDataMgr.GetIFRSOpLog(sDateS,aDateE,aDstFile:String):boolean;
var dtTemp,dtS,dtE:TDate; sPath,sLogFile:string;
begin
  result:=false;
  dtS:=DateStr8ToDate(sDateS);
  dtE:=DateStr8ToDate(aDateE);
  dtTemp:=dtS;
  sPath:=ExtractFilePath(ParamStr(0))+IFRSOpLogDir;
  while dtTemp<=dtE do
  begin
    sLogFile:=FormatDateTime('yyyymmdd',dtTemp)+'.log';
    if FileExists(sPath+sLogFile) then
      AddTrancsationDatToFile(sPath+sLogFile,aDstFile);
    dtTemp:=dtTemp+1;
  end;
  result:=true;
end;

function TCBDataMgr.SetCBDataText(const FileName,Value,aOperator,aTimeKey : String): String;
Var
  FileName2 : String;
  f : TStringList;
begin
    FileName2 := LowerCase(FTr1DBPath+'CBData\Data\'+FileName);
    if not DirectoryExists(ExtractFilePath(FileName2)) then //--DOC4.0.0—N002 huangcq081223 add
      Raise Exception.Create('Cannot find Directory '+ExtractFilePath(FileName2));
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName2);
    f.Free;
    SaveCBTxtToUpLoad('data',FileName2,aOperator,aTimeKey);
end;


procedure TCBDataMgr.SetguapaiCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\guapai.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetHushiCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\Hushi.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetShenshiCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\Shenshi.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetshangguiCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\shanggui.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetshangshiCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\shangshi.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetPassawayCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\passaway.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetNifaxingCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Publish_db\nifaxing.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetPassCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Publish_db\pass.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetSongCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\publish_db\song.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetxunquanCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\publish_db\xunquan.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgr.SetStopCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\publish_db\stopissue.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;


function TCBDataMgr.SetNodeUpload(const aOperator,aTimeKey: String):boolean;
var bParam1,bParam2:boolean; sMkt,sFileName,sPath,sOneF:string;
    ts:TStringList; i:Integer;
begin
  Result:=false;
  sPath:=LowerCase(FTr1DBPath+'CBData\');
  ts:=TStringList.Create;
  try
    sMkt:='publish_db';
    sPath:=LowerCase(FTr1DBPath+'CBData\publish_db\dblst.lst');
    GetdbFileList(sPath,ts);
    for i:=0 to ts.count-1 do
    begin
      sOneF:=Trim(ts[i]);
      if sOneF='' then
        continue;
      SaveCBTxtToUpLoad(sMkt,sOneF,aOperator,aTimeKey,sMkt);
    end;

    
    sMkt:='market_db';
    sPath:=LowerCase(FTr1DBPath+'CBData\market_db\dblst2.lst');
    GetdbFileList(sPath,ts);
    for i:=0 to ts.count-1 do
    begin
      sOneF:=Trim(ts[i]);
      if sOneF='' then
        continue;
      SaveCBTxtToUpLoad(sMkt,sOneF,aOperator,aTimeKey,sMkt);
    end;

    bParam1:=true;
    bParam2:=true;
    ProAfterNodeChanged(bParam1,bParam2,bParam1,bParam2,aOperator,aTimeKey);
    Strike4ConvToResetLst(aOperator,aTimeKey);
    ResetLstConvToStrike2(aOperator,aTimeKey);
    result:=True;
  finally
    FreeAndNil(ts);
  end;
end;

function TCBDataMgr.GetStopCBText: String;
var FileName : String;
  f : TStringList;
begin
    Result := '';
    FileName := FTr1DBPath+'CBData\publish_db\stopissue.txt';
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;
end;

function TCBDataMgr.GetshangguiCBText: String;
begin
end;

function TCBDataMgr.GetshangshiCBText: String;
begin

end;

function TCBDataMgr.GetSongCBText: String;
begin

end;

function TCBDataMgr.GetguapaiCBText: String;
begin

end;

function TCBDataMgr.GetxunquanCBText: String;
begin

end;

Function TCBDataMgr.GetADocRtfFileName(FileName:String):String;
Var FileName2,sCode : String;
  F :TextFile;
begin
Try
    result:='';
    FileName:=StringReplace(FileName,'.rtf','.txt',[rfReplaceAll, rfIgnoreCase]);
    sCode:=Copy(FileName,1,4);
    FileName2 := FTr1DBPath+'CBData\Document\'+sCode+'\'+FileName;
    if  NOT  FileExists(FileName2) Then
    begin
     AssignFile(F,FileName2);
     rewrite(F);  //′?ó???′′?¨ò??????t
     closeFile(F)
    end;
    if FileExists(FileName2) Then
     Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetADoc2TextFileName(FileName:String):String;
Var FileName2 : String;
  F :TextFile;
begin
Try
    result:='';
    FileName:=StringReplace(FileName,'DOC2_','',[rfReplaceAll, rfIgnoreCase]);
    FileName2 := FTr1DBPath+'CBData\Document\ShenBaoDoc4\'+FileName;
    if  NOT  FileExists(FileName2) Then
    begin
     AssignFile(F,FileName2);
     rewrite(F);  
     closeFile(F)
    end;
    if FileExists(FileName2) Then
     Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetADocTextFileName(FileName:String):String;
var FileName2,sDir : String;
  F :TextFile;
begin
Try
    result:='';
    FileName:=StringReplace(FileName,'DOC_','',[rfReplaceAll, rfIgnoreCase]);
    FileName2 := FTr1DBPath+'CBData\Document\ShenBaoDoc\'+FileName;
    sDir:=ExtractFilePath(FileName2);
    if not DirectoryExists(sDir) then
      Mkdir_Directory(sDir);
    if  NOT  FileExists(FileName2) Then
    begin
       AssignFile(F,FileName2);
       rewrite(F);  
       closeFile(F)
    end;
    if FileExists(FileName2) Then
     Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetDatecloseidlist(FileName:String):String;
var FileName2,sPath : String;
  F :TextFile;
begin
Try
    result:='';
    FileName2 := FTr1DBPath+'CBData\TCRI\CloseIdList\'+FmtDt8(Date)+'.lst';
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);
       closeFile(F)
     end;
     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;

function MyRplStr(aInput,aTo,aRpl:string):string;
begin
  result:=Q_ReplaceStr(aInput,aTo,aRpl);
  //result:=FastAnsiReplace(aInput,aTo,aRpl,[rfReplaceAll]);
  //result:=FastReplace(aInput,aTo,aRpl,True);
end;

Function TCBDataMgr.closeidlistComapre(aCloseidListFile,aDateBaseInfoFile,aTr1BaseInfoFile:String):string;
var ts,ts1,ts2,tsCode:TStringList;
    i,j,k,iPos,iIdx1,iIdx2: Integer;
    sField,sValue,s0,s1,s2,sCode,sNewFile:string;
begin
  result:='';
  sNewFile:=ExtractFilePath(aCloseidListFile)+'~'+ExtractFileName(aCloseidListFile);
  if FileExists(sNewFile) then
     DeleteFile(sNewFile);
  if not FileExists(aCloseidListFile) then
  begin
    result:=aCloseidListFile;
    exit;
  end;
  ts:=nil; ts1:=nil; ts2:=nil; tsCode:=nil; 
try
  ts:=TStringList.create;
  ts1:=TStringList.create;
  ts2:=TStringList.create;
  tsCode:=TStringList.create;
  ts.LoadFromFile(aCloseidListFile);
  if FileExists(aDateBaseInfoFile) then
    ts1.LoadFromFile(aDateBaseInfoFile);
  if ts1.Count>0 then
  begin
    For i:=0 to ts1.count-1 do
    begin
      if IsSecLine(ts1[i]) then
        ts1[i]:='#enter#'+ts1[i];
    end;
    ts1.text:=MyRplStr(ts1.text,#13#10,'');
    ts1.text:=MyRplStr(ts1.text,'#enter#[',#13#10+'[');
  end;
  {if ts1.Count>0 then
  begin
    ts1.text:=MyRplStr(ts1.text,#13#10,'');
    ts1.text:=MyRplStr(ts1.text,'[MktClass]',#13#10+'[MktClass]');
    ts1.text:=MyRplStr(ts1.text,'[CYB2]',#13#10+'[CYB2]');
    ts1.text:=MyRplStr(ts1.text,'[Fields]',#13#10+'[Fields]');

    //ts1.text:=MyRplStr(ts1.text,'[',#13#10+'[');
  end;}


  if FileExists(aTr1BaseInfoFile) then
    ts2.LoadFromFile(aTr1BaseInfoFile);
  if ts2.Count>0 then
  begin
    For i:=0 to ts2.count-1 do
    begin
      if IsSecLine(ts2[i]) then
        ts2[i]:='#enter#'+ts2[i];
    end;
    ts2.text:=MyRplStr(ts2.text,#13#10,'');
    ts2.text:=MyRplStr(ts2.text,'#enter#[',#13#10+'[');
  end;
  {if ts2.Count>0 then
  begin
    ts2.text:=MyRplStr(ts2.text,#13#10,'');
    ts2.text:=MyRplStr(ts2.text,'[MktClass]',#13#10+'[MktClass]');
    ts2.text:=MyRplStr(ts2.text,'[CYB2]',#13#10+'[CYB2]');
    ts2.text:=MyRplStr(ts2.text,'[Fields]',#13#10+'[Fields]');
    //ts2.text:=MyRplStr(ts2.text,'[',#13#10+'[');
  end;}


  For i:=0 to ts.count-1 do
  begin
    if SameText('[list]',ts[i]) then
    begin
      For k:=i+1 to ts.count-1 do
      begin
        iPos:=Pos('=',ts[k]);
        if iPos<=0 then
          Break;
        if GetFieldValue(ts[k],sField,sValue) then
        begin
          //if (sValue='2') and (sField<>'') then
          if (sField<>'') then
          begin
            {if ts1.Count>0 then
            begin
              ts1.text:=MyRplStr(ts1.text,'['+sField+']',#13#10+'['+sField+']');
            end;
            if ts2.Count>0 then
              ts2.text:=MyRplStr(ts2.text,'['+sField+']',#13#10+'['+sField+']');}
            tsCode.Add(sField+'='+sValue);
          end;
        end;
      end;
    end;
  end;
  tsCode.sort;
  ts1.sort;
  //ts1.SaveToFile('E:\Apps\Bak183Doc\TestLog\20161109\1.txt');
  ts2.sort;
  //ts2.SaveToFile('E:\Apps\Bak183Doc\TestLog\20161109\2.txt');
  iIdx1:=0; iIdx2:=0;
  for i:=0 to tsCode.Count-1 do
  begin
    sCode:=Copy(tsCode[i],1,4);
    if sCode='' then
      Continue;
    sField:='['+sCode+']';
    s1:='';
    s2:='';
    for j:=iIdx1 to ts1.count-1 do
    begin
      s0:=Copy(ts1[j],1,6);
      if s0=sField then
      begin
        s1:=ts1[j];
        iIdx1:=j+1;
        break;
      end
      else if s0>sField then
        break;
    end;
    if s1<>'' then
    begin
      for j:=iIdx2 to ts2.count-1 do
      begin
        s0:=Copy(ts2[j],1,6);
        if s0=sField then
        begin
          s2:=ts2[j];
          iIdx2:=j+1;
          break;
        end
        else if s0>sField then
          break;
      end;
      {if sCode='8261' then
      begin
        WriteLineForApp(s1,'');
        WriteLineForApp(s2,'');
      end;}
      if not (sametext(s1,s2)) then
      begin
        tsCode[i]:=sCode+'='+_CXiaOK;
      end
      else begin
        if (sametext(tsCode[i],sCode+'='+_CXiaOK)) then
          tsCode[i]:=sCode+'='+_CNoNeedShen;
      end;
    end;
  end;
  tsCode.Insert(0,'[list]');
  tsCode.SaveToFile(sNewFile);
  result:=sNewFile;
finally
  try if Assigned(ts) then FreeAndNil(ts); except end;
  try if Assigned(ts1) then FreeAndNil(ts1); except end;
  try if Assigned(ts2) then FreeAndNil(ts2); except end;
  try if Assigned(tsCode) then FreeAndNil(tsCode); except end;
end;
end;

Function TCBDataMgr.GetDatecloseidlistEx(FileName:String):String;
var aCloseidListFile,aDateBaseInfoFile,aTr1BaseInfoFile:String;
begin
  result:='';
  aCloseidListFile:=GetDatecloseidlist(FileName);
  aDateBaseInfoFile:=GetDatecbbaseinfo(FileName);
  aTr1BaseInfoFile:=FTr1DBPath+'CBData\data\cbbaseinfo.dat';
  result:=closeidlistComapre(aCloseidListFile,aDateBaseInfoFile,aTr1BaseInfoFile);
end;

Function TCBDataMgr.GetWeekOfcloseidlistEx(FileName:String):String;
var aCloseidListFile,aDateBaseInfoFile,aTr1BaseInfoFile:String;
begin
  result:='';
  aCloseidListFile:=GetWeekOfcloseidlist(FileName);
  aDateBaseInfoFile:=GetDatecbbaseinfoOfWeek(FileName);
  aTr1BaseInfoFile:=FTr1DBPath+'CBData\data\cbbaseinfo.dat';
  result:=closeidlistComapre(aCloseidListFile,aDateBaseInfoFile,aTr1BaseInfoFile);
end;

Function TCBDataMgr.GetWeekOfcloseidlist(FileName:String):String;
var FileName2,sPath,sDate8 : String;
  F :TextFile;
begin
Try
    result:='';
    sDate8:=Copy(FileName,1,8);
    if Length(sDate8)<>8 then
      exit; 
    FileName2 := FTr1DBPath+'CBData\TCRI\CloseIdList\ForWeekDay\'+sDate8+'.lst';
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);
       closeFile(F)
     end;
     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;


Function TCBDataMgr.GetDatecbbaseinfo(FileName:String):String;
var FileName2,sPath : String;
  F :TextFile;
begin
Try
    result:='';
    FileName2 := ExtractFilePath(ParamStr(0))+'Data\Industry\'+FmtDt8(Date)+'\cbbaseinfo.dat';
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);
       closeFile(F)
     end;
     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetDateStockweight(FileName:String):String;
var FileName2,sPath : String;
  F :TextFile;
begin
Try
    result:='';
    FileName2 := ExtractFilePath(ParamStr(0))+'Data\Industry\'+FmtDt8(Date)+'\stockweight.dat';
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);
       closeFile(F)
     end;
     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetLogStockweight(FileName:String):String;
var FileName2,sPath,sDate8,sText,sTextAll,sOneFileName : String;
  F :TextFile;  aFiles :_cStrLst; i:integer;
begin
Try
  result:='';
  sDate8:=Copy(FileName,1,8);
  if Length(sDate8)<>8 then
    exit;
  FileName2 := ExtractFilePath(ParamStr(0))+'Data\Industry\Audit\stockweight\'+sDate8+'\stockweightlog.log';
  sPath:=ExtractFilePath(FileName2);
   if not DirectoryExists(sPath) then
     Mkdir_Directory(sPath);
  FolderAllFiles(sPath,'.dat',aFiles,false);
  for i:=0 to High(aFiles) do
  begin
    sOneFileName:=ExtractFileName(aFiles[i]);
    GetTextByTs(aFiles[i],sText);
    sText:='<'+sOneFileName+'>'+#13#10+sText+#13#10+'</'+sOneFileName+'>';
    if sTextAll='' then
      sTextAll:=sText
    else
      sTextAll:=sTextAll+#13#10+sText;
  end;
  SetLength(aFiles,0);
  SetTextByTs(FileName2,sTextAll);
  
  if  NOT  FileExists(FileName2) Then
  begin
    AssignFile(F,FileName2);
    rewrite(F);
    closeFile(F);
  end;
  if FileExists(FileName2) Then
   Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetLogcbbaseinfo(FileName:String):String;
var FileName2,sPath,sDate8,sText,sTextAll,sOneFileName : String;
  F :TextFile;  aFiles :_cStrLst; i:integer;
begin
Try
  result:='';
  sDate8:=Copy(FileName,1,8);
  if Length(sDate8)<>8 then
    exit;
  FileName2 := ExtractFilePath(ParamStr(0))+'Data\Industry\Audit\cbbaseinfo\'+sDate8+'\cbbaseinfolog.log';
  sPath:=ExtractFilePath(FileName2);
  if not DirectoryExists(sPath) then
    Mkdir_Directory(sPath);
  FolderAllFiles(sPath,'.dat',aFiles,false);
  for i:=0 to High(aFiles) do
  begin
    sOneFileName:=ExtractFileName(aFiles[i]);
    GetTextByTs(aFiles[i],sText);
    sText:='<'+sOneFileName+'>'+#13#10+sText+#13#10+'</'+sOneFileName+'>';
    if sTextAll='' then
      sTextAll:=sText
    else
      sTextAll:=sTextAll+#13#10+sText;
  end;
  SetLength(aFiles,0);
  SetTextByTs(FileName2,sTextAll);
  
  if not FileExists(FileName2) Then
  begin
    AssignFile(F,FileName2);
    rewrite(F);
    closeFile(F);
  end;
  if FileExists(FileName2) Then
   Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetDateStkBase1TFN(FileName:String):String;
var FileName2,sPath : String;
  F :TextFile;
begin
Try
    result:='';
    FileName2 := ExtractFilePath(ParamStr(0))+'Data\Industry\'+FmtDt8(Date)+'\StkBase1.dat';
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);
       closeFile(F)
     end;
     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetDatecbbaseinfoOfWeek(FileName:String):String;
var FileName2,sPath,sDate8 : String;
  F :TextFile;
begin
Try
    result:='';
    sDate8:=Copy(FileName,1,8);
    if Length(sDate8)<>8 then
      exit;              
    FileName2 := ExtractFilePath(ParamStr(0))+'Data\Industry\CompanyInfoDownWeekDay\'+sDate8+'cbbaseinfo.dat';
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);
       closeFile(F)
     end;
     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetDateStkBase1DifTFN(FileName:String):String;
Var
  FileName2,sPath : String;
  F :TextFile;
begin
Try
    result:='';                                                               
    FileName2 := ExtractFilePath(ParamStr(0))+'Data\Industry\'+FmtDt8(Date)+'\StkBase1Dif.dat';
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);
       closeFile(F)
     end;
     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetDateStkIndustryTFN(FileName:String):String;
Var
  FileName2,sPath : String;
  F :TextFile;
begin
Try
    result:='';
    FileName2 := ExtractFilePath(ParamStr(0))+'Data\Industry\'+FmtDt8(Date)+'\StkIndustry.dat';
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);
       closeFile(F)
     end;
     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;

Function TCBDataMgr.GetDateStkIndustryDifTFN(FileName:String):String;
Var
  FileName2,sPath : String;
  F :TextFile;
begin
Try
    result:='';
    FileName2 := ExtractFilePath(ParamStr(0))+'Data\Industry\'+FmtDt8(Date)+'\StkIndustryDif.dat';
     sPath:=ExtractFilePath(FileName2);
     if not DirectoryExists(sPath) then
       Mkdir_Directory(sPath);
     if  NOT  FileExists(FileName2) Then
     begin
       AssignFile(F,FileName2);
       rewrite(F);
       closeFile(F)
     end;
     if FileExists(FileName2) Then
       Result := FileName2;
Except
End;
end;

Function TCBDataMgr.Setstockweight(aUptFiles:TStringList;aDstDatPath,aOperator,aTimeKey:string):Boolean;
var sListFile,sGuid,sUploadFile:string; i:integer;
begin
  result:=false;
  sListFile:=aDstDatPath+'stockweightguid.lst';
  sGuid:=Get_GUID8;
  for i:=0 to aUptFiles.count-1 do
  begin
    sUploadFile:=ExtractFileName(aUptFiles[i]);
    SaveIniFile(PChar('list'),PChar(sUploadFile),PChar(sGuid),PChar(sListFile));
    SaveCBTxtToUpLoad('stockweight',aUptFiles[i],aOperator,aTimeKey,'stockweight');
  end;

  SaveCBTxtToUpLoad9('lst','stockweight',sListFile,aOperator,aTimeKey,'stockweight');
  result:=true;
end;


Function TCBDataMgr.SetIFRSTFN(aCode:string;aYear,aQ:integer;aOperator,aTimeKey:string):Boolean;
Var
  sListFile,sDstName,
   sTemp,sTemp1,sTemp2,sTemp3,sDelF,sDelF2,sBaseF1,sBaseF2,sFirstAdd : String;
  f1,i : Integer;
  FileStr : TStringList;
  sDstFile,sSrFile:array[0..2] of string;
  bAry:array[0..2] of integer; 
begin
    Result := False;
    sListFile := Format('%sCBData\ifrs\ifrsguid.lst',[FTr1DBPath]);
    sListFile := LowerCase(sListFile);
    sBaseF1:= Format('%sCBData\ifrs\IFRSTopNode.dat',[FTr1DBPath]);
    sBaseF1:= LowerCase(sBaseF1);
    sBaseF2:= Format('%sCBData\ifrs\IFRSNode.dat',[FTr1DBPath]);
    sBaseF2:= LowerCase(sBaseF2);

    sTemp:=ExtractFilePath(sBaseF1);
    if not DirectoryExists(sTemp) then
      Raise Exception.Create('Cannot find Directory '+sTemp);

    sSrFile[0] := Format('%sData\IFRS\%d_%d_%s_1.dat',[ExtractFilePath(ParamStr(0)),aYear,aQ,aCode]);
    sSrFile[0] := LowerCase(sSrFile[0]);
    sSrFile[1] := Format('%sData\IFRS\%d_%d_%s_2.dat',[ExtractFilePath(ParamStr(0)),aYear,aQ,aCode]);
    sSrFile[1] := LowerCase(sSrFile[1]);
    sSrFile[2] := Format('%sData\IFRS\%d_%d_%s_3.dat',[ExtractFilePath(ParamStr(0)),aYear,aQ,aCode]);
    sSrFile[2] := LowerCase(sSrFile[2]);
    sDstFile[0] := Format('%sCBData\ifrs\%d_%d_1.dat',[FTr1DBPath,aYear,aQ]);
    sDstFile[0] := LowerCase(sDstFile[0]);
    sDstFile[1] := Format('%sCBData\ifrs\%d_%d_2.dat',[FTr1DBPath,aYear,aQ]);
    sDstFile[1] := LowerCase(sDstFile[1]);
    sDstFile[2] := Format('%sCBData\ifrs\%d_%d_3.dat',[FTr1DBPath,aYear,aQ]);
    sDstFile[2] := LowerCase(sDstFile[2]);

    bAry[0]:=UptIFRSRecToTr1db(sSrFile[0] ,sDstFile[0]);
    bAry[1]:=UptIFRSRecToTr1db(sSrFile[1] ,sDstFile[1]);
    bAry[2]:=UptIFRSRecToTr1db(sSrFile[2] ,sDstFile[2]);

    sFirstAdd:='0';
    sTemp:=GetUploadLogFile6('ifrs',sFirstAdd+'6');
    if FileExists(sTemp) then
    begin
      sFirstAdd:='1';
    end;

    if (bAry[0]=0) and
       (bAry[1]=0) and
       (bAry[2]=0) then
    begin
      result:=true;
    end
    else if (bAry[0]<>-1) and
       (bAry[1]<>-1) and
       (bAry[2]<>-1) then
    begin
      if (bAry[0]=1) then
      begin
        sTemp:=Get_GUID8;
        SaveIniFile(PChar(ExtractFileName(sDstFile[0])),PChar('guid'),PChar(sTemp),PChar(sListFile));
        SaveCBTxtToUpLoad7('ifrs',sDstFile[0],aOperator,aTimeKey,'ifrs',sFirstAdd+'1');
      end;
      if (bAry[1]=1) then
      begin
        sTemp:=Get_GUID8;
        SaveIniFile(PChar(ExtractFileName(sDstFile[1])),PChar('guid'),PChar(sTemp),PChar(sListFile));
        SaveCBTxtToUpLoad7('ifrs',sDstFile[1],aOperator,aTimeKey,'ifrs',sFirstAdd+'2');
      end;
      if (bAry[2]=1) then
      begin
        sTemp:=Get_GUID8;
        SaveIniFile(PChar(ExtractFileName(sDstFile[2])),PChar('guid'),PChar(sTemp),PChar(sListFile));
        SaveCBTxtToUpLoad7('ifrs',sDstFile[2],aOperator,aTimeKey,'ifrs',sFirstAdd+'3');
      end;

      sTemp:=Get_GUID8;
      SaveIniFile(PChar(ExtractFileName(sBaseF1)),PChar('guid'),PChar(sTemp),PChar(sListFile));
      sTemp:=Get_GUID8;
      SaveIniFile(PChar(ExtractFileName(sBaseF2)),PChar('guid'),PChar(sTemp),PChar(sListFile));

      SaveCBTxtToUpLoad7('ifrs',sBaseF1,aOperator,aTimeKey,'ifrs',sFirstAdd+'4');
      SaveCBTxtToUpLoad7('ifrs',sBaseF2,aOperator,aTimeKey,'ifrs',sFirstAdd+'5');
      SaveCBTxtToUpLoad7('ifrs',sListFile,aOperator,aTimeKey,'ifrs',sFirstAdd+'6');

      sTemp:=GetAEnableIFRSUploadNo;
      if sTemp='' then
      begin
        exit;
      end;
      SaveCBTxtToUpLoad8('ifrs',sDstFile[0],aOperator,aTimeKey,'ifrs',sTemp);
      Result := True;
    end;
end;

Function TCBDataMgr.SetTCRIUploadWork(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
Var  FileName2,sListFile,sTemp,sBaseF1,sBaseF2 : String;
begin
    Result := False;
    FileName2 := LowerCase(FTr1DBPath+'CBData\tcri\'+DstFileName);
    sListFile := LowerCase(FTr1DBPath+'CBData\tcri\'+'tcriguid.lst');
    sBaseF1:= LowerCase(FTr1DBPath+'CBData\tcri\'+'TcriComClassCode.dat');
    sBaseF2:= LowerCase(FTr1DBPath+'CBData\tcri\'+'TcriComCode.dat');

    sTemp:=Get_GUID8;
    SaveIniFile(PChar(ExtractFileName(FileName2)),PChar('guid'),PChar(sTemp),PChar(sListFile));
    SaveIniFile(PChar(ExtractFileName(sBaseF1)),PChar('guid'),PChar(sTemp),PChar(sListFile));
    SaveIniFile(PChar(ExtractFileName(sBaseF2)),PChar('guid'),PChar(sTemp),PChar(sListFile));

    SaveCBTxtToUpLoad('tcri',FileName2,aOperator,aTimeKey);
    SaveCBTxtToUpLoad4('lst','tcri',sListFile,aOperator,aTimeKey);
    Result := True;
end;

Function TCBDataMgr.SetTCRITFN(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
Var
  FileName2,sListFile,sDstName,sTemp,sPath,sBakDatFile,sDelF,sDelF2,sBaseF1,sBaseF2,sBaseF3 : String;
  f1,i : Integer;
  FileStr : TStringList;
begin
    Result := False;
    FileName2 := LowerCase(FTr1DBPath+'CBData\tcri\'+DstFileName);
    sListFile := LowerCase(FTr1DBPath+'CBData\tcri\'+'tcriguid.lst');
    sBaseF1:= LowerCase(FTr1DBPath+'CBData\tcri\'+'TcriComClassCode.dat');
    sBaseF2:= LowerCase(FTr1DBPath+'CBData\tcri\'+'TcriComCode.dat');
    sBaseF3:= LowerCase(FTr1DBPath+'CBData\tcri\'+'plevelcomcode.dat');
    sDstName := LowerCase(ExtractFileName(DstFileName));
    sPath:=ExtractFilePath(FileName2);
    if not DirectoryExists(sPath) then
      Raise Exception.Create('Cannot find Directory '+sPath);

    if not DirectoryExists(sPath+'Bak\') then
      Mkdir_Directory(sPath+'Bak\');
    if FileExists(FileName2) then
    begin
      sBakDatFile:='Bak'+FormatDateTime('yyyymmddhhmmss',now)+'_'+ExtractFileName(FileName2);
      TrytoCopyFile((FileName2),(sPath+'Bak\'+sBakDatFile),3);
    end;

    f1 := FileAge(FileName2);
    TrytoCopyFile((SrcFileName),(FileName2),3);

    if f1=FileAge(FileName2) Then
       Exit;
    sTemp:=Get_GUID8;
    SaveIniFile(PChar(sDstName),PChar('guid'),PChar(sTemp),PChar(sListFile));
    sDelF:=Get_GUID8;
    SaveIniFile(PChar(ExtractFileName(sBaseF1)),PChar('guid'),PChar(sDelF),PChar(sListFile));
    sDelF:=Get_GUID8;
    SaveIniFile(PChar(ExtractFileName(sBaseF2)),PChar('guid'),PChar(sDelF),PChar(sListFile));

    //--狦琌獺蝶蝗︽comゅ郎玥玂獺蝶蝗︽戈ネΘㄤ肚癘魁ヘ琌ㄏ硂ㄢ肚筁祘そノtimekey
    if (LowerCase(ExtractFileName(FileName2))=LowerCase('plevelcomcode.dat')) then
    begin
      result:=true;
      exit;
    end;
    
    SaveCBTxtToUpLoad('tcri',FileName2,aOperator,aTimeKey);
    if (LowerCase(ExtractFileName(FileName2))=LowerCase('StkIndustry.dat')) or
       (LowerCase(ExtractFileName(FileName2))=LowerCase('StkBase1.dat')) then
    begin
      SaveCBTxtToUpLoad('tcri',sBaseF1,aOperator,aTimeKey);
      SaveCBTxtToUpLoad('tcri',sBaseF2,aOperator,aTimeKey);
    end
    else if (LowerCase(ExtractFileName(FileName2))=LowerCase('bankplevel.dat')) then
    begin
      SaveCBTxtToUpLoad('tcri',sBaseF3,aOperator,aTimeKey);
    end;
    SaveCBTxtToUpLoad4('lst','tcri',sListFile,aOperator,aTimeKey);
    Result := True;
end;

function TCBDataMgr.SetCBBaseInfoIdListIsOk:Boolean;
var sFile:string; ts:TStringList; i:integer;
begin
  result:=false;
  sFile:=FTr1DBPath+'CBData\TCRI\CloseIdList\'+FmtDt8(date)+'.lst';
  if not FileExists(sFile) then
  begin
    result:=True;
  end
  else begin
    ts:=TStringList.create;
    try
      ts.LoadFromFile(sFile);
      
    finally
      FreeAndNil(ts);
    end;
  end;
end;

function TCBDataMgr.SetCBDataTextFileName(const DstFileName,SrcFileName,aOperator,aTimeKey: String): Boolean;
Var
  FileName2,sListFile,sDstName,sPath,sBakDatFile,sTemp : String;
  f1,i : Integer;
  FileStr : TStringList;
begin
    Result := False;
    FileName2 := LowerCase(FTr1DBPath+'CBData\Data\'+DstFileName);
    sListFile := LowerCase(FTr1DBPath+'CBData\Data\'+'cbdataguid.lst');
    sDstName := LowerCase(ExtractFileName(DstFileName));
    sPath:=ExtractFilePath(FileName2);
    if not DirectoryExists(sPath) then 
      Raise Exception.Create('Cannot find Directory '+sPath);

      
    if not DirectoryExists(sPath+'Bak\') then
      Mkdir_Directory(sPath+'Bak\');
    if FileExists(FileName2) then
    begin
      sBakDatFile:='Bak'+FormatDateTime('yyyymmddhhmmss',now)+'_'+ExtractFileName(FileName2);
      TryToCopyFile((FileName2),(sPath+'Bak\'+sBakDatFile),3);
    end;

    f1 := FileAge(FileName2);
    TryToCopyFile((SrcFileName),(FileName2),3);
    if f1=FileAge(FileName2) Then
       Exit;
    sTemp:=Get_GUID8;
    SaveIniFile(PChar(sDstName),PChar('guid'),PChar(sTemp),PChar(sListFile));

    SaveCBTxtToUpLoad('data',FileName2,aOperator,aTimeKey);
    SaveCBTxtToUpLoad3('lst','data',sListFile,aOperator,aTimeKey);
    Result := True;
end;

Function TCBDataMgr.SetCBDataUpload(Const aOperator,aTimeKey,DstFileName:String):Boolean;
Var
  FileName2,sListFile,sDstName,sTemp,sTemp1,sTemp11,sTemp2,sTemp3 : String;
  i : Integer;
begin
    Result := False;
    FileName2 := LowerCase(FTr1DBPath+'CBData\Data\'+DstFileName);
    sListFile := LowerCase(FTr1DBPath+'CBData\Data\'+'cbdataguid.lst');
    sDstName := LowerCase(ExtractFileName(DstFileName));
    if not DirectoryExists(ExtractFilePath(FileName2)) then
      Raise Exception.Create('Cannot find Directory '+ExtractFilePath(FileName2));

    //if(DstFileName='STRIKE2.DAT')then
    //if(DstFileName='RESETLST.DAT') or
    if SameText(DstFileName,'STRIKE4.DAT') or  //--DOC4.4.0.0 pqx 20120207
       SameText(DstFileName,'CBREDEEMDATE.DAT') or
       SameText(DstFileName,'CBSALEDATE.DAT') then 
    begin
      sTemp:=Get_GUID8;
      SaveIniFile(PChar('GUID'),PChar('GUID'),PChar(sTemp),PChar(FileName2));
      //if (DstFileName='RESETLST.DAT') then //--Doc4.0.0 惠―3 huangcq090209 add 锣传ネΘstrike2.dat
      if SameText(DstFileName,'STRIKE4.DAT') then  //--DOC4.4.0.0 穝糤惠―7 pqx 20120207
      begin
        Strike4ConvToResetLst(aOperator,aTimeKey);
        ResetLstConvToStrike2(aOperator,aTimeKey);
      end;
    end;

    sTemp:=Get_GUID8;
    if SameText(DstFileName,'STRIKE4.DAT') or
       SameText(DstFileName,'STRIKE2.DAT') then
    begin
      SaveIniFile(PChar('strike2.dat'),PChar('guid'),PChar(sTemp),PChar(sListFile));
      SaveIniFile(PChar('strike4.dat'),PChar('guid'),PChar(sTemp),PChar(sListFile));
    end
    else if SameText(DstFileName,'STRIKE3.DAT') or
       SameText(DstFileName,'STRIKE32.DAT') then
    begin
      SaveIniFile(PChar('strike32.dat'),PChar('guid'),PChar(sTemp),PChar(sListFile));
      SaveIniFile(PChar('strike3.dat'),PChar('guid'),PChar(sTemp),PChar(sListFile));
    end
    else if SameText(DstFileName,'cbidx.dat') or
       SameText(DstFileName,'cbidx2.dat') then
    begin
      SaveIniFile(PChar('cbidx2.dat'),PChar('guid'),PChar(sTemp),PChar(sListFile));
      SaveIniFile(PChar('cbidx.dat'),PChar('guid'),PChar(sTemp),PChar(sListFile));
    end
    else
      SaveIniFile(PChar(sDstName),PChar('guid'),PChar(sTemp),PChar(sListFile));
      
    sTemp:=LowerCase(DstFileName);
    sTemp1:='';sTemp2:='';sTemp3:='';
    if SameText(sTemp,'cbidx2.dat') then
    begin
      sTemp2:=ConvertcbidxTocbidx3;
      SaveCBTxtToUpLoad('data',sTemp2,aOperator,aTimeKey);
      
      ConvertCbidx2ToCbidx();
      sTemp1:=ProSep_cbidx2(true,true);
      if sTemp1<>'' then
      begin
        sTemp2:=GetNewDatFile(sTemp1);
        sTemp3:=GetNewStopDatFile(sTemp1);
        if (sTemp2<>'') and (FileExists(sTemp2)) then
          SaveCBTxtToUpLoad('data',sTemp2,aOperator,aTimeKey);
        if (sTemp3<>'') and (FileExists(sTemp3)) then
          SaveCBTxtToUpLoad('data',sTemp3,aOperator,aTimeKey);
      end;
      sTemp1:=ProSep_cbidx(true,true);
      if sTemp1<>'' then
      begin
        sTemp2:=GetNewDatFile(sTemp1);
        sTemp3:=GetNewStopDatFile(sTemp1);
        if (sTemp2<>'') and (FileExists(sTemp2)) then
          SaveCBTxtToUpLoad('data',sTemp2,aOperator,aTimeKey);
        if (sTemp3<>'') and (FileExists(sTemp3)) then
          SaveCBTxtToUpLoad('data',sTemp3,aOperator,aTimeKey);
      end;
      //SaveCBTxtToUpLoad('data',ExtractFilePath(FileName2)+'cbidx.dat',aOperator,aTimeKey);
      sTemp1:='';
    end
    else if SameText(sTemp,'strike2.dat') or SameText(sTemp,'strike4.dat') then
      sTemp1:=ProSep_strike2(true,true)
    else if SameText(sTemp,'strike32.dat') then
    begin
      ConvertStrike32ToStrike3();
      sTemp1:=ProSep_strike32(true,true);
      if sTemp1<>'' then
      begin
        sTemp2:=GetNewDatFile(sTemp1);
        sTemp3:=GetNewStopDatFile(sTemp1);
        if (sTemp2<>'') and (FileExists(sTemp2)) then
          SaveCBTxtToUpLoad('data',sTemp2,aOperator,aTimeKey);
        if (sTemp3<>'') and (FileExists(sTemp3)) then
          SaveCBTxtToUpLoad('data',sTemp3,aOperator,aTimeKey);
      end;
      sTemp1:=ProSep_strike3(true,true);
      if sTemp1<>'' then
      begin
        sTemp2:=GetNewDatFile(sTemp1);
        sTemp3:=GetNewStopDatFile(sTemp1);
        if (sTemp2<>'') and (FileExists(sTemp2)) then
          SaveCBTxtToUpLoad('data',sTemp2,aOperator,aTimeKey);
        if (sTemp3<>'') and (FileExists(sTemp3)) then
          SaveCBTxtToUpLoad('data',sTemp3,aOperator,aTimeKey);
      end;
      SaveCBTxtToUpLoad('data',ExtractFilePath(FileName2)+'strike3.dat',aOperator,aTimeKey);
      sTemp1:='';
    end
    else if SameText(sTemp,'cbissue2.dat') then
      sTemp1:=ProSep_cbissue2(true,true)
    else if SameText(sTemp,'cbpurpose.dat') then
      sTemp1:=ProSep_cbpurpose(true,true)
    else if SameText(sTemp,'cbstopconv.dat') then
      sTemp1:=ProSep_cbstopconv(true,true)
    else if SameText(sTemp,'cbredeemdate.dat') then
      sTemp1:=ProSep_cbredeemdate(true,true)
    else if SameText(sTemp,'cbsaledate.dat') then
      sTemp1:=ProSep_cbsaledate(true,true)
    else if SameText(sTemp,'cbdoc.dat') then
      sTemp1:=ProSep_cbdoc(true,true)
    else if SameText(sTemp,'cbstockholder.dat') then
      sTemp1:=ProSep_cbstockholder(true,true)
    else if SameText(sTemp,'cbdate.dat') then
      sTemp1:=ProSep_cbdate(true,true);
    if sTemp1<>'' then
    begin
      sTemp2:=GetNewDatFile(sTemp1);
      sTemp3:=GetNewStopDatFile(sTemp1);
      if (sTemp2<>'') and (FileExists(sTemp2)) then
        SaveCBTxtToUpLoad('data',sTemp2,aOperator,aTimeKey);
      if (sTemp3<>'') and (FileExists(sTemp3)) then
        SaveCBTxtToUpLoad('data',sTemp3,aOperator,aTimeKey);
    end;

    if (not SameText(LowerCase(DstFileName),'cbidx.dat'))  then
      SaveCBTxtToUpLoad('data',FileName2,aOperator,aTimeKey);
    SaveCBTxtToUpLoad3('lst','data',sListFile,aOperator,aTimeKey);
    Result := True;
end;

function TCBDataMgr.SetCBDataTextFileName_10(const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
Var
  FileName2,sListFile,sDstName,sTemp,sTemp2 : String;
  f1,i : Integer;
  FileStr : TStringList;
begin

    Result := False;
    sTemp2:=ChangeFileExt(ExtractFileName(DstFileName),'');
    FileName2 := LowerCase(FTr1DBPath+'CBData\Document\'+DstFileName);
    sListFile := LowerCase(FTr1DBPath+'CBData\Document\ShenBaoDoc\'+'StockDocIdxLst.dat');
    sDstName := LowerCase(ExtractFileName(DstFileName));

    if not DirectoryExists(ExtractFilePath(FileName2)) then
    begin
      ForceDirectories(ExtractFilePath(FileName2))
    end;
      //Raise Exception.Create('Cannot find Directory '+ExtractFilePath(FileName2));
    if not DirectoryExists(ExtractFilePath(sListFile)) then
    begin
      ForceDirectories(ExtractFilePath(sListFile))
    end;

    f1 := FileAge(FileName2);
    TryToCopyFile((SrcFileName),(FileName2),3);
    if f1=FileAge(FileName2) Then
       Exit;
    sTemp:=Get_GUID8;
    SaveIniFile(PChar(sTemp2),PChar('guid'),PChar(sTemp),PChar(sListFile));
    SaveCBTxtToUpLoad('shenbaodocument',FileName2,aOperator,aTimeKey);
    SaveCBTxtToUpLoad('shenbaodocument',sListFile,aOperator,aTimeKey);
    Result := True;
end;

procedure TCBDataMgr.ResetLstConvToStrike2(aOperator,aTimeKey:string);
var
  aTmpFile, aDstFileName, aSrcFileName, aTmpValues :String;
  f: TIniFile;
  i,j: Integer;
  SectionLst,ValueLst, ReasonLst: TStringList;
  _StrLst: _cStrLst;
begin
  aSrcFileName:=FTr1DBPath+'CBData\Data\'+'ResetLst.dat';
  aDstFileName:=FTr1DBPath+'CBData\Data\'+'Strike2.dat';
  if not FileExists(aSrcFileName) then exit;
  aTmpFile := GetWinTempPath + '~Strike2.dat';
  if FileExists(aTmpFile) then DeleteFile(aTmpFile);
  TryToCopyFile((aSrcFileName),(aTmpFile),_TryCpyTimes);
  try
     f := TIniFile.Create(aTmpFile);
     SectionLst := TStringList.Create;
     ValueLst := TStringList.Create;
     ReasonLst := TStringList.Create;

     f.ReadSectionValues('ReasonList',ReasonLst); //index=content
     f.ReadSections(SectionLst);
     for i:=0 to SectionLst.Count-1 do
     begin
       if (Trim(UpperCase(SectionLst[i])) ='GUID') or
          (Trim(UpperCase(SectionLst[i])) ='REASONLIST') then Continue;
       f.ReadSectionValues(SectionLst[i],ValueLst); //i=date,value,index
       while (ValueLst.Count>0) do
       begin
         _StrLst := DoStrArray((ValueLst.Values[ValueLst.Names[0]]),',');// ValueLst.Names[0] is i;  ValueLst.Values[i] is date,value,index
         if (High(_StrLst)>=2) then
         begin
           _StrLst[2] :=ReasonLst.Values[_StrLst[2]]; //_StrLst[2] is index of content
           aTmpValues := '';
           For j:=0 to High(_StrLst) do
           begin
              if j=0 then
                aTmpValues := _StrLst[j]
              else
                aTmpValues := aTmpValues +','+ _StrLst[j];
           end;
           f.WriteString(SectionLst[i],ValueLst.Names[0],aTmpValues);
         end; //end if (High(_StrLst)>=2)
         ValueLst.Delete(0);
       end; //end while valueLst.count>0
     end; //end for i:=0
     TryToCopyFile((aTmpFile),(aDstFileName),_TryCpyTimes);
     SaveCBTxtToUpLoad('data',aDstFileName,aOperator,aTimeKey);
     DeleteFile(aTmpFile);
  finally
     if Assigned(f) then f.Free;
     if Assigned(SectionLst) then  SectionLst.Free;
     if Assigned(ValueLst) then  ValueLst.Free;
     if Assigned(ReasonLst) then ReasonLst.Free;
  end;
end;


//add by wangjinhua ThreeTrader 091015
Function TCBDataMgr.SetCBThreeTraderFileName(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;

  function MakeThreeTraderLst(aFileName,aDate: String;var NeedSort:boolean): Boolean;
  Var
    j,k : Integer;
    memo,vDwnHttp : String;
    f : TIniFile;
  begin
     result := false; NeedSort:=false;
  Try
  try
      f := TIniFile.Create(aFileName);
      f.WriteString('GUID','GUID',Get_GUID8);
      j:=1;
      while True  do
      Begin
         memo := f.ReadString(IntToStr(j),'MEMO','');
         if memo=Copy(aDate,1,4)+'-'+Copy(aDate,5,2)+'-'+Copy(aDate,7,2) Then
           Break;
         if Length(Memo)=0 then
         Begin
           NeedSort:=true;
           Break;
         End;
         j:=j+1;
      End;

      f.WriteString(IntToStr(j),'GUID',Get_GUID8);
      f.WriteString(IntToStr(j),'MEMO',Copy(aDate,1,4)+'-'+Copy(aDate,5,2)+'-'+Copy(aDate,7,2));
      f.WriteString(IntToStr(j),'FILELIST','_'+aDate+'.dat|');

      Result := True;
  Except
    On E: Exception Do
       //ShowMsg(runError,E.Message);
  End;
  Finally
    try
      if Assigned(f) then
        FreeAndNil(f);
    except
    end;
  End;
  end;


  function SortThreeTraderLst(aFileName:String): Boolean;
  Var
    j,k : Integer;
    memo,vDwnHttp : String;
    f : TIniFile;
    aLst:PTDLst;
    FLst:TList ;
    Rec_tmp:PTDLst;
  begin
     result := false;
  try
  try
      f := TIniFile.Create(aFileName);
      FLst:=TList.Create;

      j:=1;
      while True  do
      Begin
         memo := f.ReadString(IntToStr(j),'MEMO','');
         if Length(Memo)=0 then Break
         else
         begin
           New(aLst);
           alst.GUID:=f.ReadString(IntToStr(j),'GUID','');
           alst.MEMO:=memo;
           aLst.FNAME:=f.ReadString(IntToStr(j),'FILELIST','');
           FLst.Add(aLst);
         end;
         j:=j+1;
      End;

      Sort(FLst);

      For k:=0 To Flst.Count-1 do
      Begin
        Rec_tmp:=FLst[k];
        f.WriteString(IntToStr(k+1),'GUID',Rec_tmp.GUID);
        f.WriteString(IntToStr(k+1),'MEMO',Rec_tmp.MEMO);
        f.WriteString(IntToStr(k+1),'FILELIST',Rec_tmp.FNAME);
      End;

  except
  end;
  finally
    try
      For k:=0 To Flst.Count-1 do
        FreeMem(FLst[k]);
    except
    end;
    try
      if Assigned(FLst) then
        FreeAndNil(FLst);
    except
    end;
    try
      if Assigned(f) then
        FreeAndNil(f);
    except
    end;
  end;
  end;

Var
  FileName2,sDate : String;
  f1 : Integer; NeedSort:boolean;
begin
    Result := False;
    //Save cbDealer
    FileName2 := LowerCase(FTr1DBPath+'CBData\ThreeTrader\'+Copy(DstFileName,Length('cbthreetrader@') + 1,12));

    if not DirectoryExists(ExtractFilePath(FileName2)) then
      Raise Exception.Create('Cannot find Directory '+ExtractFilePath(FileName2));

    f1 := FileAge(FileName2);
    TryToCopyFile((SrcFileName),(FileName2),3);
    if f1=FileAge(FileName2) Then
       Exit;
    //Upl cbThreeTrader
    SaveCBTxtToUpLoad('data/threetrader',FileName2,aOperator,aTimeKey,'cbthreetrader@');  //Doc091120-sun

    //Upl cbindexThreeTrader
    FileName2:= LowerCase(FTr1DBPath+'CBData\ThreeTrader\threetraderlst.dat');
    sDate:=Copy(DstFileName,Length('cbthreetrader@') + 1,8);
    NeedSort:=false;
    MakeThreeTraderLst(FileName2,sDate,NeedSort);
    ModifyThreeTraderLst(FileName2,sDate);
    SaveCBTxtToUpLoad('data/threetrader',FileName2,aOperator,aTimeKey);

    Result := True;
end;
//--

Function TCBDataMgr.SetCBBalanceDatFileName(Const DstFileName,SrcFileName,aOperator,aTimeKey:String):Boolean;
Var
  FileName2,sPath,sFile1,sBakDatFile : String;
  f1,f2 : Integer;
  fini:TIniFile;
begin
    Result := False;
    FileName2 := LowerCase(FTr1DBPath+'CBData\balancedat\'+Copy(DstFileName,Length('balancedat@') + 1,Length(DstFileName)));
    sPath:=ExtractFilePath(FileName2);
    sFile1:=ExtractFileName(FileName2);
    if not DirectoryExists(sPath) then
      ForceDirectories(sPath);

    if not DirectoryExists(sPath+'Bak\') then
      Mkdir_Directory(sPath+'Bak\');
    if FileExists(FileName2) then
    begin
      sBakDatFile:='Bak'+FormatDateTime('yyyymmddhhmmss',now)+'_'+ExtractFileName(FileName2);
      TryToCopyFile((FileName2),(sPath+'Bak\'+sBakDatFile),3);
    end;

    f1 := FileAge(FileName2);
    TryToCopyFile((SrcFileName),(FileName2),3);
    f2 :=FileAge(FileName2);
    if f1=f2 Then
       Exit;
    //Upl cbindexThreeTrader
    FileName2:= LowerCase(FTr1DBPath+'CBData\balancedat\balancedatlist.lst');
    try
      fini:=TIniFile.Create(FileName2);
      fini.WriteInteger('list',sFile1,f2);
      fini.WriteString('list','guid',Get_GUID8);
    finally
      fini.Free;
    end;
    //SaveCBTxtToUpLoad('data/balancedat',FileName2);
    Result := True;
end;


function TCBDataMgr.SetCBTodayHintTextFileName(const DstFileName,SrcFileName,aOperator,aTimeKey: String): Boolean;
Var
  FileName2,memo : String;
  f : TStringList;
begin
    result:=false;
    f := TStringList.Create;
    f.LoadFromFile(SrcFileName);
    Memo := f.Text;
    f.Clear;
    f.Add(Format('<DATE=%s>',[FormatDateTime('yyyymmdd',Date)]));
    f.Add('<HINT>');
    if Length(Memo)>0 Then
      f.Add(Memo);
    f.Add('</HINT>');
    f.Add('</DATE>');
    SetCBDataText('cbtodayhint.dat',f.Text,aOperator,aTimeKey);
    f.Free;
    result:=true;
end;

//add by wangjinhua ThreeTrader 091015
procedure TCBDataMgr.ModifyThreeTraderLst(aFileName,aDate:String);
Var
  j: Integer;
  memo : String;
  f : TIniFile;
  behave:Boolean;
begin
Try
try
    behave:=false;
    f := TIniFile.Create(aFileName);
    j:=1;
    while True  do
    Begin
       memo := f.ReadString(IntToStr(j),'MEMO','');
       if memo=Copy(aDate,1,4)+'-'+Copy(aDate,5,2)+'-'+Copy(aDate,7,2) Then
       begin
         behave:=true;
         Break;
       end;
       if Length(Memo)=0 then
         Break;
       j:=j+1;
    End;
    if(behave)then
      f.WriteString(IntToStr(j),'GUID',Get_GUID8);
Except
  On E: Exception Do
     //ShowMsg(runError,E.Message);
End;
Finally
  try
    if Assigned(f) then
      FreeAndNil(f);
  except
  end;
End;
end;
//--


procedure TCBDataMgr.ModifyDealerLst(aFileName,aDate:String);
Var
  j: Integer;
  memo : String;
  f : TIniFile;
  behave:Boolean;
begin

Try
try
   behave:=false;
    f := TIniFile.Create(aFileName);

    f.WriteString('GUID','GUID',Get_GUID8);
    f.WriteString('1','GUID',Get_GUID8);
    f.WriteString('1','MEMO',FormatDateTime('yyyy-mm-dd',Date));

    j:=2;
    while True  do
    Begin
       memo := f.ReadString(IntToStr(j),'MEMO','');
       if memo=Copy(aDate,1,4)+'-'+Copy(aDate,5,2)+'-'+Copy(aDate,7,2) Then
       begin
         behave:=true;
         Break;
       end;
       if Length(Memo)=0 then
         Break;
       j:=j+1;
    End;

    if(behave)then
      f.WriteString(IntToStr(j),'GUID',Get_GUID8);
    f.Free;

Except
  On E: Exception Do
     //ShowMsg(runError,E.Message);
End;
Finally
End;
end;

procedure TCBDataMgr.Strike4ConvToResetLst(aOperator,aTimeKey:string);
var
  aTmpFile, aDstFileName, aSrcFileName, aTmpValues :String;
  f: TIniFile;
  i,j: Integer;
  SectionLst,ValueLst: TStringList;
  _StrLst: _cStrLst;
begin
  aSrcFileName:=FTr1DBPath+'CBData\Data\'+'strike4.dat';
  aDstFileName:=FTr1DBPath+'CBData\Data\'+'ResetLst.dat';
  if not FileExists(aSrcFileName) then exit;
  aTmpFile := GetWinTempPath + '~ResetLst.dat';
  if FileExists(aTmpFile) then DeleteFile(aTmpFile);
  TryToCopyFile((aSrcFileName),(aTmpFile),_TryCpyTimes);
  try
     f := TIniFile.Create(aTmpFile);
     SectionLst := TStringList.Create;
     ValueLst := TStringList.Create;

     f.ReadSections(SectionLst);
     for i:=0 to SectionLst.Count-1 do
     begin
       if (Trim(UpperCase(SectionLst[i])) ='GUID') or
          (Trim(UpperCase(SectionLst[i])) ='REASONLIST') then Continue;
       f.ReadSectionValues(SectionLst[i],ValueLst); //i=date,value,index
       while (ValueLst.Count>0) do
       begin
         _StrLst := DoStrArray((ValueLst.Values[ValueLst.Names[0]]),',');// ValueLst.Names[0] is i;  ValueLst.Values[i] is date,value,index
         if (High(_StrLst)>=2) then
         begin
           aTmpValues := '';
           For j:=0 to 2 do
           begin
              if j=0 then
                aTmpValues := _StrLst[j]
              else
                aTmpValues := aTmpValues +','+ _StrLst[j];
           end;
           f.WriteString(SectionLst[i],ValueLst.Names[0],aTmpValues);
         end; //end if (High(_StrLst)>=2)
         ValueLst.Delete(0);
       end; //end while valueLst.count>0
     end; //end for i:=0
     TryToCopyFile((aTmpFile),(aDstFileName),_TryCpyTimes);
     SaveCBTxtToUpLoad('data',aDstFileName,aOperator,aTimeKey);
     DeleteFile(aTmpFile);
  finally
     if Assigned(f) then f.Free;
     if Assigned(SectionLst) then  SectionLst.Free;
     if Assigned(ValueLst) then  ValueLst.Free;
  end;
end;

function TCBDataMgr.ConvertcbidxTocbidx3:string;
var sFile1,sFile11,sTagFile,Str,strJoin,sPath:string; ts1:TStringList;
  StrLst : _CStrLst;  i,j,index:integer;
begin
  result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbidx.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  if not DirectoryExists(sPath+'bak\') then
    ForceDirectories(sPath+'bak\');
  sFile11:=sPath+'bak\'+sTagFile;
Try
  ts1 := TStringList.Create;
  ts1.LoadFromFile(sFile1);
  for index:=0 to ts1.Count-1 do
  Begin
    Str := ts1.Strings[index];
    if (Pos('=',Str)>0) and (PosEx('GGR',Str)>0) then
    begin
      StrLst := DoStrArray(Str,',');
      strJoin:='';
      for i:=0 to High(StrLst) do
      begin
        if i>=2 then
          Break;
        if i=0 then strJoin:=StrLst[i]
        else strJoin:=strJoin+','+StrLst[i];
      end;
      SetLength(StrLst,0);
       ts1.Strings[index] := strJoin;
    end;
  End;

  ts1.SaveToFile(sFile11);
  result:=sFile11;
Finally
  if Assigned(ts1) Then
     ts1.Free;
End;
end;

function TCBDataMgr.ConvertCbidx2ToCbidx():Boolean;
var sPath,sFile1,sFile2,sLine,sLine2:string;
   i,j:integer; f1,f2:Double;
   ts:TStringList; StrLst2:_cStrLst2;
begin
  result:=false;
  sPath:=FTr1DBPath+'CBData\data\';
  sFile1:=sPath+'cbidx2.dat';
  sFile2:=sPath+'cbidx.dat';
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  ts:=TStringList.Create;
  try
    ts.LoadFromFile(sFile1);
    for i:=0 to ts.count-1 do
    begin
      sLine:=ts[i];
      if Pos('GGR',sLine)=1  then
      begin
        StrLst2:=DoStrArray2_2(sLine,',');
        if Length(StrLst2)>=2 then
        begin
          if MayBeDigital(StrLst2[1]) then
          begin
            f1:=StrToFloat(StrLst2[1]);
            if f1>0 then
            begin
              if FIsTw then
                f2:=f1*10
              else
                f2:=f1/100;
              StrLst2[1]:=FloatToStr(f2);
              sLine2:='';
              for j:=Low(StrLst2) to High(StrLst2) do
              begin
                if j=0 then sLine2:=StrLst2[j]
                else sLine2:=sLine2+','+StrLst2[j];
              end;
              ts[i]:=sLine2;
            end;
          end;
        end;
      end;
      
    end;
    ts.SaveToFile(sFile2);
  finally
    FreeAndNil(ts);
  end;
  result:=true;
end;

function TCBDataMgr.ConvertStrike32ToStrike3():Boolean;
var sPath,sFile1,sFile2,sLine:string;
   i,j:integer; f1,f2:Double;
   ts:TStringList; StrLst2:_cStrLst2;
begin
  result:=false;
  sPath:=FTr1DBPath+'CBData\data\';
  sFile1:=sPath+'strike32.dat';
  sFile2:=sPath+'strike3.dat';
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  ts:=TStringList.Create;
  try
    ts.LoadFromFile(sFile1);
    for i:=0 to ts.count-1 do
    begin
      sLine:=ts[i];
      StrLst2:=DoStrArray2_2(sLine,',');
      if (Length(StrLst2)=3) then
      begin
        if MayBeDigital(StrLst2[2]) then
        begin
          f1:=StrToFloat(StrLst2[2]);
          if f1>=0 then
          begin
            //f2:=(1+f1)*100;
            f2:=f1/100-1;
            ts[i]:=StrLst2[0]+','+StrLst2[1]+','+floattostr(f2);
          end;
        end;
      end;
    end;
    ts.SaveToFile(sFile2);
  finally
    FreeAndNil(ts);
  end;
  result:=true;
end;

function  TCBDataMgr.ProAfterNodeChanged(aRefreshExceptList,aRefreshShangShiCodeList:boolean;
  aFtpXiaShi,aFtpNotXiaShi:boolean;aOperator,aTimeKey:string):boolean;
var sListFile,sFileName,sTemp,sTemp1,sTemp2,sTemp3,sGuid,sPath:string;
  procedure DoSomeChange;
  begin
    if (sTemp1<>'') and (FileExists(sTemp1)) then
    begin
        sTemp2:=GetNewDatFile(sTemp1);
        sTemp3:=GetNewStopDatFile(sTemp1);
        if aFtpNotXiaShi then 
        if (sTemp2<>'') and (FileExists(sTemp2)) then
          SaveCBTxtToUpLoad('data',sTemp2,aOperator,aTimeKey);
        if aFtpXiaShi then 
        if (sTemp3<>'') and (FileExists(sTemp3)) then
          SaveCBTxtToUpLoad('data',sTemp3,aOperator,aTimeKey);
        SaveCBTxtToUpLoad('data',sTemp1,aOperator,aTimeKey);
        sGuid:=Get_GUID8;
        if SameText(sFileName,'strike2.dat') or
           SameText(sFileName,'strike4.dat') then
        begin
          SaveIniFile(PChar('strike2.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile));
          SaveIniFile(PChar('strike4.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile));
        end
        else if SameText(sFileName,'strike3.dat') or
           SameText(sFileName,'strike32.dat') then
        begin
          SaveIniFile(PChar('strike3.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile));
          SaveIniFile(PChar('strike32.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile));
        end
        else if SameText(sFileName,'cbidx.dat') or
           SameText(sFileName,'cbidx2.dat') then
        begin
          SaveIniFile(PChar('cbidx.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile));
          SaveIniFile(PChar('cbidx2.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile));
        end
        else
          SaveIniFile(PChar(sFileName),PChar('guid'),PChar(sGuid),PChar(sListFile));
    end;
  end;
begin
  Result:=false;
  //if aRefreshExceptList then RefreshExceptList;
  //if aRefreshShangShiCodeList then RefreshShangShiCodeList;
  RefreshExceptList;
  RefreshShangShiCodeList;

  sPath:=FTr1DBPath+'CBData\Data\';
  sListFile := LowerCase(sPath+'cbdataguid.lst');

  ConvertCbidx2ToCbidx;
  sFileName:='cbidx2.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbidx2(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;
  sFileName:='cbidx.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbidx(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='strike2.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_strike2(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  ConvertStrike32ToStrike3;
  sFileName:='strike32.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_strike32(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;
  sFileName:='strike3.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_strike3(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbissue2.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbissue2(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbpurpose.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbpurpose(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbdoc.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbdoc(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbstopconv.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbstopconv(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbstockholder.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbstockholder(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbredeemdate.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbredeemdate(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbsaledate.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbsaledate(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbdate.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbdate(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  SaveCBTxtToUpLoad3('lst','data',sListFile,aOperator,aTimeKey);
end;

{TCBDataMgrEcb}
 function TCBDataMgrEcb.CreateEmptycbstopconvdat(aInputFile:string):Boolean;
var xPath:string; f1 : File Of TSTOPCONV_PERIOD_RPTEcb;
begin
  result:=false;
  xPath:=ExtractFilePath(aInputFile);
  if not DirectoryExists(xPath) then
    exit;
  AssignFile(f1,aInputFile);
  try
    ReWrite(f1);
    result:=true;
  finally
    try CloseFile(f1); except end;
  end;
end;

function TCBDataMgrEcb.ProSep_cbstopconv(aFtpXiaShi,aFtpNotXiaShi:boolean): string;
var
  Rec :TSTOPCONV_PERIOD_RPTEcb;
  f1,f2,f3 : File Of TSTOPCONV_PERIOD_RPTEcb;
  sFile1,sFile2,sFile3:string;
  sTagFile,sTemp1,sTemp2,sTemp3,sPath:string;
  i,iCount,iCodeType: Integer;
Begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbstopconv.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;
  sFile2:=GetNewDatFile(sFile1);
  sFile3:=GetNewStopDatFile(sFile1);
try
  AssignFile(f1,sFile1);
  if aFtpNotXiaShi then AssignFile(f2,sFile2);
  if aFtpXiaShi then AssignFile(f3,sFile3);
  FileMode := 2;
  ReSet(f1);
  if aFtpNotXiaShi then ReWrite(f2);
  if aFtpXiaShi then ReWrite(f3);
  iCount:=FileSize(f1);
  For i:=0 To iCount-1 Do
  Begin
    Seek(f1,i);
    Read(f1,Rec);
    iCodeType:=CodeInType(Rec.ID);
    if iCodeType=1 then
    begin
      if aFtpXiaShi then Write(f3,Rec);
    end
    else if iCodeType=0 then
    begin
      if aFtpNotXiaShi then Write(f2,Rec);
    end;
  End;
  result:=sFile1;
  try CloseFile(f1); except Result:=''; end;
  if aFtpNotXiaShi then try CloseFile(f2); except result:=''; end;
  if aFtpXiaShi then try CloseFile(f3); except Result:=''; end;
Except
  On E:Exception Do
  begin
    e:=nil;
  end;
End;
End;

function TCBDataMgrEcb.ProSepPassHis_cbstopconv(aExtractYear:string):string;
var
  Rec :TSTOPCONV_PERIOD_RPT;
  f1,f2 : File Of TSTOPCONV_PERIOD_RPT;
  sFile1,sFile2:string;
  sTagFile,sTemp1,sTemp2,sTemp3,sPath:string;
  i,iCount,iCodeType: Integer;
Begin
  Result:='';
  sPath:=FTr1DBPath+'CBData\data\';
  sTagFile:='cbstopconv.dat';
  sFile1:=sPath+sTagFile;
  if not FileExists(sFile1) then
  begin
    exit;
  end;

  sPath:=FTr1DBPath+'CBData\data\'+aExtractYear+'\';
  Mkdir_Directory(sPath);
  sFile2:=sPath+sTagFile;
try
  AssignFile(f1,sFile1);
  AssignFile(f2,sFile2);

  FileMode := 2;
  ReSet(f1);
  ReWrite(f2);

  iCount:=FileSize(f1);
  For i:=0 To iCount-1 Do
  Begin
    Seek(f1,i);
    Read(f1,Rec);
    iCodeType:=CodeInType(Rec.ID);
    if iCodeType=2 then
    begin
      Write(f2,Rec);
    end;
  End;
  result:=sFile1;
  try CloseFile(f1); except Result:=''; end;
  try CloseFile(f2); except result:=''; end;
Except
  On E:Exception Do
  begin
    e:=nil;
  end;
End;
End;

function TCBDataMgrEcb.LoaclDatDir():string;
begin
  result:=ExtractFilePath(Application.ExeName)+'DataEcb\';
end;

procedure TCBDataMgrEcb.SaveCBTxtToUpLoad(FileFolder,FileName,aOperator,aTimeKey:String;TypeFlag: String ='');  //Doc091120-sun
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile;
   f.SaveToFile(aCBFileName); //--DOC4.0.0—N002 huangcq081223 add
   f.Free;
  //Doc091120-sun------------------------------------------------
   if (TypeFlag = '')  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey)
   else if TypeFlag = 'ecbrate' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey,1,'',TypeFlag)
   else if SameText(TypeFlag,'publish_db') or  SameText(TypeFlag,'market_db') then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey,1,'',TypeFlag)
  //-----------------------------------------------------------------------------------
end;

procedure TCBDataMgrEcb.SaveCBTxtToUpLoadRateData(FileFolder,FileName,aOperator,aTimeKey:String;TypeFlag: String ='');
var f : TStringList;
  aCBFileName,sPath:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFileRateData;
   sPath:=ExtractFilePath(aCBFileName);
   if not DirectoryExists(sPath) then
     Mkdir_Directory(sPath);
   f.SaveToFile(aCBFileName); //--DOC4.0.0—N002 huangcq081223 add
   f.Free;
  //Doc091120-sun------------------------------------------------
   if (TypeFlag = '')  then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey)
   else if TypeFlag = 'ecbrate' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey,1,'',TypeFlag)
   else if SameText(TypeFlag,'publish_db') or  SameText(TypeFlag,'market_db') then
     SetCBDataLog('DocCenter',FileName,aCBFileName,aOperator,aTimeKey,1,'',TypeFlag)
  //-----------------------------------------------------------------------------------
end;

procedure TCBDataMgrEcb.SaveCBTxtToUpLoad3(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
var f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile3();
   f.SaveToFile(aCBFileName); 
   f.Free;
   if TypeFlag = '' then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey);
end;

procedure TCBDataMgrEcb.SaveCBTxtToUpLoad9(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
Var
  f : TStringList;
  aCBFileName:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile7();
   f.SaveToFile(aCBFileName);
   f.Free;
   if (TypeFlag = '') then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey)
   else if (TypeFlag = 'ecbrate') then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey,1,'',TypeFlag)
end;

procedure TCBDataMgrEcb.SaveCBTxtToUpLoad9RateData(Const aTag,FileFolder,FileName,Operator,aTimeKey:String;TypeFlag:String='');
var f : TStringList;
  aCBFileName,sPath:string;
begin
   f := TStringList.Create;
   f.Add('[FILE]');
   f.Add('Folder='+FileFolder);
   f.Add('FileName='+FileName);
   aCBFileName := GetUploadLogFile7RateData();
   sPath:=ExtractFilePath(aCBFileName);
   if not DirectoryExists(sPath) then
     Mkdir_Directory(sPath);
   f.SaveToFile(aCBFileName);
   f.Free;
   if (TypeFlag = '') then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey)
   else if (TypeFlag = 'ecbrate') then
     SetCBDataLog('DocCenter',FileName,aCBFileName,Operator,aTimeKey,1,'',TypeFlag)
end;

{ For Example: SetCBDataLog('DocCenter','guapai.txt','..\upload_1.cb',FtpCount,FtpServerName)   }
procedure TCBDataMgrEcb.SetCBDataLog(Const AppName,FileName,UpLoadCBFileName,aOperator,aTimeKey:String;
  FtpServerCount:Integer=1;FtpServerName:String='';TypeFlag:string ='');
var aLogFileName,FileNameEN,FileNameCN,CBFileName,aLogPath:String;
  aF:TIniFile; aDt:TDateTime;
  function TimeKey2TimeStr():string;
  var xstr1,xstr2:string;
  begin
    //xstr1:=Copy(aTimeKey,Length(aTimeKey)-9,Length(aTimeKey));
    //result:=Copy(xstr1,1,2)+':'+Copy(xstr1,3,2)+':'+Copy(xstr1,5,2);
    xstr2:=DateSeparator;
    xstr1:=aTimeKey;
    result:=Copy(xstr1,1,4)+xstr2+Copy(xstr1,5,2)+xstr2+Copy(xstr1,7,2)+' '+
      Copy(xstr1,10,2)+':'+Copy(xstr1,12,2)+':'+Copy(xstr1,14,2)+':'+Copy(xstr1,16,3);
  end;
begin
  if not Assigned(FAppParamEcb) then
    FAppParamEcb := TDocMgrParam.Create(ExtractFilePath(Application.ExeName)+'EcbSetup.ini');
  try
    if Length(FileName)<=0 then exit;
    if not FileExists(UpLoadCBFileName) then exit;
    aDt:=FileDateToDateTime(FileAge(UpLoadCBFileName));
    
    aLogPath:=LoaclDatDir+'DwnDocLog\uploadCBData\';
    if not DirectoryExists(aLogPath) then 
      Mkdir_Directory(aLogPath);
    aLogFileName:=aLogPath+Format('%s.log',[FormatDateTime('yymmdd',aDt)]);
    try
      aF := TIniFile.Create(aLogFileName);
      CBFileName := ExtractFileName(UpLoadCBFileName)+'@'+IntToStr(FileAge(UpLoadCBFileName));
      FileNameEN:=ExtractFileName(FileName);
       //--------Doc091120-sun------------------------
       if  pos('irrate',TypeFlag)>0  then  // そ杜瞯
       begin
         CBFileName:='irrate'+CBFileName;
         FileNameCN:= FAppParamEcb.TwConvertStr ('そ杜瞯')+ StringReplace(TypeFlag,'irrate','',[rfIgnoreCase]);
       end
       else if  pos('ecbrate',TypeFlag)>0  then
       begin
         CBFileName:=CBFileName;
         if SameText(ExtractFileName(FileName),'ntd2usd.dat') then
           FileNameCN:= FAppParamEcb.TwConvertStr ('穝籓刽/じ蹲瞯')+ ExtractFileName(FileName)
         else if SameText(ExtractFileName(FileName),'fed.dat') then
           FileNameCN:= FAppParamEcb.TwConvertStr ('fed瞯戈')+ ExtractFileName(FileName)
         else if SameText(ExtractFileName(FileName),'stockq.dat') then
           FileNameCN:= FAppParamEcb.TwConvertStr ('瓣そ杜崔瞯')+ ExtractFileName(FileName)
         else
           FileNameCN:= FAppParamEcb.TwConvertStr ('蹲瞯瞯')+ ExtractFileName(FileName);
       end
       else FileNameCN:= GetCBNameFromConfig(FileNameEN);
      //---------------------------------------------

      if UpperCase(AppName)='DOCCENTER' then
      begin
        //aF.WriteString('DocCenter',FileNameEN,CBFileName);
        aF.WriteString(CBFileName,'operator',aOperator);
        aF.WriteString(CBFileName,'timekey',aTimeKey);

        aF.WriteString(CBFileName,'FileNameCN',FileNameCN);
        aF.WriteString(CBFileName,'FileNameEN',FileNameEN);
        aF.WriteString(CBFileName,AppName,TimeKey2TimeStr);
        if SameText(TypeFlag,'publish_db') or  SameText(TypeFlag,'market_db') then
          aF.WriteString(CBFileName,'node','1');
      end;//end if DocCenter

      //if  UpperCase(AppName)='DOCFTP' then
      if PosEx('DOCFTP',UpperCase(AppName))>0 then
      begin
        if Length(FtpServerName)<=0 then exit;
        aF.WriteInteger(CBFileName,'CBFtpServerCount',FtpServerCount);
        aF.WriteString(CBFileName,AppName,FormatDateTime('hh:mm:ss',Now)+#9+FtpServerName);
      end;//end if DocFtp

    finally
      aF.Free;
    end;
  except
    //on E:Exception do
      //Showmessage(e.Message);
  end;
end;

function TCBDataMgrEcb.FinishUploadCBDataByLog(FileName,UpLoadCBFileName:String;FtpServerCount:Integer):Boolean;
var aLogFileName,FileNameEN,CBFileName:String;
  aF:TIniFile; ic,i:integer; aDt:TDateTime;
begin
  result:=false;
  if FtpServerCount=0 then
  begin
    result:=true;
    exit;
  end;
  if not FileExists(UpLoadCBFileName) then
  begin
    result:=true;
    exit;
  end;
  try
    aDt := FileDateToDateTime(FileAge(UpLoadCBFileName));
    aLogFileName := LoaclDatDir()+'DwnDocLog\uploadCBData\'+
                    Format('%s.log',[FormatDateTime('yymmdd',aDt)]);
    if not FileExists(aLogFileName) then
      exit;
    try
      aF := TIniFile.Create(aLogFileName);
      CBFileName := ExtractFileName(UpLoadCBFileName)+'@'+IntToStr(FileAge(UpLoadCBFileName));
      FileNameEN:=ExtractFileName(FileName);
      for i:=1 to FtpServerCount do
      begin
        if aF.ReadString(CBFileName,Format('DocFtp_%d',[i]),'')='' then
        begin
          exit;
        end;
      end;
      result:=true;
    finally
      aF.Free;
    end;
  except
    //on E:Exception do
      //Showmessage(e.Message);
  end;
end;


function TCBDataMgrEcb.SetCBDataText(const FileName,Value,aOperator,aTimeKey : String): String;
var FileName2 : String;
  f : TStringList;
begin
    FileName2 := LowerCase(FTr1DBPath+'CBData\Data\'+FileName);
    if not DirectoryExists(ExtractFilePath(FileName2)) then //--DOC4.0.0—N002 huangcq081223 add
      Raise Exception.Create('Cannot find Directory '+ExtractFilePath(FileName2));
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName2);
    f.Free;
    SaveCBTxtToUpLoad('data',FileName2,aOperator,aTimeKey);
end;

procedure TCBDataMgrEcb.SetguapaiCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\guapai.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgrEcb.SetshangguiCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\shanggui.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgrEcb.SetshangshiCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\shangshi.txt');
    Mkdir_Directory(ExtractFilePath(FileName));
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgrEcb.SetPassawayCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Market_db\passaway.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgrEcb.SetNifaxingCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Publish_db\nifaxing.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgrEcb.SetPassCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\Publish_db\pass.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgrEcb.SetSongCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\publish_db\song.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgrEcb.SetxunquanCBTxt(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\publish_db\xunquan.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;

procedure TCBDataMgrEcb.SetStopCBText(const Value: String);
var FileName : String;
  f : TStringList;
begin
    if Pos('[CLASS]',Value)=0 Then Exit;
    FileName := LowerCase(FTr1DBPath+'CBData\publish_db\stopissue.txt');
    f := TStringList.Create;
    f.Text := Value;
    f.SaveToFile(FileName);
    f.Free;
end;


function TCBDataMgrEcb.SetNodeUpload(const aOperator,aTimeKey: String):boolean;
var bParam1,bParam2:boolean; sMkt,sFileName,sPath,sOneF:string;
    ts:TStringList; i:Integer;
begin
  Result:=false;
  sPath:=LowerCase(FTr1DBPath+'CBData\');
  ts:=TStringList.Create;
  try
    sMkt:='publish_db';
    sPath:=LowerCase(FTr1DBPath+'CBData\publish_db\dblst.lst');
    GetdbFileList(sPath,ts);
    for i:=0 to ts.count-1 do
    begin
      sOneF:=Trim(ts[i]);
      if sOneF='' then
        continue;
      SaveCBTxtToUpLoad(sMkt,sOneF,aOperator,aTimeKey,sMkt);
    end;

    
    sMkt:='market_db';
    sPath:=LowerCase(FTr1DBPath+'CBData\market_db\dblst2.lst');
    GetdbFileList(sPath,ts);
    for i:=0 to ts.count-1 do
    begin
      sOneF:=Trim(ts[i]);
      if sOneF='' then
        continue;
      SaveCBTxtToUpLoad(sMkt,sOneF,aOperator,aTimeKey,sMkt);
    end;

    bParam1:=true;
    bParam2:=true;
    ProAfterNodeChanged(bParam1,bParam2,bParam1,bParam2,aOperator,aTimeKey);
    result:=True;
  finally
    FreeAndNil(ts);
  end;
end;

function TCBDataMgrEcb.GetStopCBText: String;
var FileName : String;
  f : TStringList;
begin
    Result := '';
    FileName := FTr1DBPath+'CBData\publish_db\stopissue.txt';
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;
end;


function TCBDataMgrEcb.GetshangguiCBText: String;
begin
end;

function TCBDataMgrEcb.GetshangshiCBText: String;
begin

end;

function TCBDataMgrEcb.GetSongCBText: String;
begin

end;

function TCBDataMgrEcb.GetguapaiCBText: String;
begin

end;

function TCBDataMgrEcb.GetxunquanCBText: String;
begin

end;


Function TCBDataMgrEcb.SetECBRate(aEcbRatePath,aOperator,aTimeKey,sCmd:string):Boolean;
var sListFile,sGuid,sUploadFile:string;
begin
  result:=false;
  sListFile:=aEcbRatePath+'ecbrate.lst';
  sGuid:=Get_GUID8;
  SaveIniFile(PChar('list'),PChar('guid'),PChar(sGuid),PChar(sListFile));

  if sCmd[1]='1' then
  begin
    sUploadFile:=aEcbRatePath+'ntd2usd.dat';
    SaveCBTxtToUpLoadRateData('ratedata',sUploadFile,aOperator,aTimeKey,'ecbrate');
  end;

  if sCmd[2]='1' then
  begin
    sUploadFile:=aEcbRatePath+'fed.dat';
    SaveCBTxtToUpLoadRateData('ratedata',sUploadFile,aOperator,aTimeKey,'ecbrate');
  end;

  SaveCBTxtToUpLoad9RateData('lst','ratedata',sListFile,aOperator,aTimeKey,'ecbrate');
  result:=true;
end;


function TCBDataMgrEcb.SetCBDataTextFileName(const DstFileName,SrcFileName,aOperator,aTimeKey: String): Boolean;
Var
  FileName2,sListFile,sDstName,sPath,sBakDatFile,sTemp : String;
  f1,i : Integer;
  FileStr : TStringList;
begin
    Result := False;
    FileName2 := LowerCase(FTr1DBPath+'CBData\Data\'+DstFileName);
    sListFile := LowerCase(FTr1DBPath+'CBData\Data\'+'cbdataguid.lst');
    sDstName := LowerCase(ExtractFileName(DstFileName));
    sPath:=ExtractFilePath(FileName2);
    if not DirectoryExists(sPath) then 
      Raise Exception.Create('Cannot find Directory '+sPath);

      
    if not DirectoryExists(sPath+'Bak\') then
      Mkdir_Directory(sPath+'Bak\');
    if FileExists(FileName2) then
    begin
      sBakDatFile:='Bak'+FormatDateTime('yyyymmddhhmmss',now)+'_'+ExtractFileName(FileName2);
      CopyFile(PChar(FileName2),PChar(sPath+'Bak\'+sBakDatFile),false);
    end;

    f1 := FileAge(FileName2);
    CopyFile(PChar(SrcFileName),PChar(FileName2),False);
    if f1=FileAge(FileName2) Then
       Exit;
    sTemp:=Get_GUID8;
    SaveIniFile(PChar(sDstName),PChar('guid'),PChar(sTemp),PChar(sListFile));

    SaveCBTxtToUpLoad('data',FileName2,aOperator,aTimeKey);
    SaveCBTxtToUpLoad3('lst','data',sListFile,aOperator,aTimeKey);
    Result := True;
end;


Function TCBDataMgrEcb.SetCBDataUpload(Const aOperator,aTimeKey,DstFileName:String):Boolean;
Var
  FileName2,sListFile,sDstName,sTemp,sTemp1,sTemp11,sTemp2,sTemp3,sGuid : String;
  i : Integer;
begin
    Result := False;
    FileName2 := LowerCase(FTr1DBPath+'CBData\Data\'+DstFileName);
    sListFile := LowerCase(FTr1DBPath+'CBData\Data\'+'cbdataguid.lst');
    sDstName := LowerCase(ExtractFileName(DstFileName));
    if not DirectoryExists(ExtractFilePath(FileName2)) then
      Raise Exception.Create('Cannot find Directory '+ExtractFilePath(FileName2));

    if SameText(DstFileName,'STRIKE4.DAT') or  //--DOC4.4.0.0 pqx 20120207
       SameText(DstFileName,'CBREDEEMDATE.DAT') or
       SameText(DstFileName,'CBSALEDATE.DAT') then 
    begin
      sTemp:=Get_GUID8;
      SaveIniFile(PChar('GUID'),PChar('GUID'),PChar(sTemp),PChar(FileName2));
    end;

    sGuid:=Get_GUID8;
    SaveIniFile(PChar(sDstName),PChar('guid'),PChar(sGuid),PChar(sListFile));
      
    sTemp:=LowerCase(DstFileName);
    sTemp1:='';sTemp2:='';sTemp3:='';
    if SameText(sTemp,'cbidx2.dat') then
    begin
      sTemp1:=ProSep_cbidx2(true,true);
      SaveIniFile(PChar('cbidx.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile));
    end
    else if SameText(sTemp,'strike2.dat') or SameText(sTemp,'strike4.dat') then
      sTemp1:=ProSep_strike2(true,true)
    else if SameText(sTemp,'strike32.dat') then
    begin
      sTemp1:=ProSep_strike32(true,true);
      SaveIniFile(PChar('strike3.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile));
    end
    else if SameText(sTemp,'cbissue2.dat') then
      sTemp1:=ProSep_cbissue2(true,true)
    else if SameText(sTemp,'cbpurpose.dat') then
      sTemp1:=ProSep_cbpurpose(true,true)
    else if SameText(sTemp,'cbstopconv.dat') then
      sTemp1:=ProSep_cbstopconv(true,true)
    else if SameText(sTemp,'cbredeemdate.dat') then
      sTemp1:=ProSep_cbredeemdate(true,true)
    else if SameText(sTemp,'cbsaledate.dat') then
      sTemp1:=ProSep_cbsaledate(true,true)
    else if SameText(sTemp,'cbdoc.dat') then
      sTemp1:=ProSep_cbdoc(true,true)
    else if SameText(sTemp,'cbstockholder.dat') then
      sTemp1:=ProSep_cbstockholder(true,true)
    else if SameText(sTemp,'cbdate.dat') then
      sTemp1:=ProSep_cbdate(true,true);
    if sTemp1<>'' then
    begin
      sTemp2:=GetNewDatFile(sTemp1);
      sTemp3:=GetNewStopDatFile(sTemp1);
      if (sTemp2<>'') and (FileExists(sTemp2)) then
        SaveCBTxtToUpLoad('data',sTemp2,aOperator,aTimeKey);
      if (sTemp3<>'') and (FileExists(sTemp3)) then
        SaveCBTxtToUpLoad('data',sTemp3,aOperator,aTimeKey);
    end;

    SaveCBTxtToUpLoad3('lst','data',sListFile,aOperator,aTimeKey);
    Result := True;
end;


function  TCBDataMgrEcb.ProAfterNodeChanged(aRefreshExceptList,aRefreshShangShiCodeList:boolean;
  aFtpXiaShi,aFtpNotXiaShi:boolean;aOperator,aTimeKey:string):boolean;
var sListFile,sFileName,sTemp,sTemp1,sTemp2,sTemp3,sGuid,sPath:string;
  procedure DoSomeChange;
  begin
    if (sTemp1<>'') and (FileExists(sTemp1)) then
    begin
        sTemp2:=GetNewDatFile(sTemp1);
        sTemp3:=GetNewStopDatFile(sTemp1);
        if aFtpNotXiaShi then 
        if (sTemp2<>'') and (FileExists(sTemp2)) then
          SaveCBTxtToUpLoad('data',sTemp2,aOperator,aTimeKey);
        if aFtpXiaShi then 
        if (sTemp3<>'') and (FileExists(sTemp3)) then
          SaveCBTxtToUpLoad('data',sTemp3,aOperator,aTimeKey);
        sGuid:=Get_GUID8;
        SaveIniFile(PChar(sFileName),PChar('guid'),PChar(sGuid),PChar(sListFile));
        if SameText(sFileName,'cbidx2.dat') then
           SaveIniFile(PChar('cbidx.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile))
        else if SameText(sFileName,'strike32.dat') then
           SaveIniFile(PChar('strike3.dat'),PChar('guid'),PChar(sGuid),PChar(sListFile));
    end;
  end;
begin
  Result:=false;
  //if aRefreshExceptList then RefreshExceptList;
  //if aRefreshShangShiCodeList then RefreshShangShiCodeList;
  RefreshExceptList;
  RefreshShangShiCodeList;

  sPath:=FTr1DBPath+'CBData\Data\';
  sListFile := LowerCase(sPath+'cbdataguid.lst');

  sFileName:='cbidx2.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbidx2(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='strike2.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_strike2(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='strike32.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_strike32(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbissue2.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbissue2(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbpurpose.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbpurpose(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbdoc.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbdoc(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbstopconv.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbstopconv(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbstockholder.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbstockholder(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbredeemdate.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbredeemdate(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbsaledate.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbsaledate(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  sFileName:='cbdate.dat';
  sTemp1:='';sTemp2:='';sTemp3:='';
  sTemp1:=ProSep_cbdate(aFtpXiaShi,aFtpNotXiaShi);
  DoSomeChange;

  SaveCBTxtToUpLoad3('lst','data',sListFile,aOperator,aTimeKey);
end;


function TCBDataMgrEcb.GetNifaxingCBText: String;
var FileName : String;  f : TStringList;
begin
    Result := '';
    FileName := FTr1DBPath+'CBData\Publish_db\nifaxing.txt';
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;
end;

function TCBDataMgrEcb.GetPassawayCBText: String;
var FileName : String;  f : TStringList;
begin
    Result := '';
    FileName := FTr1DBPath+'CBData\Market_db\'+_PasswayTxt;
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;
end;

function TCBDataMgrEcb.GetPassCBText: String;
var FileName : String;  f : TStringList;
begin
    Result := '';
    FileName := FTr1DBPath+'CBData\Publish_db\pass.txt';
    if FileExists(FileName) Then
    Begin
       f := TStringList.Create;
       f.LoadFromFile(FileName);
       Result := f.Text;
       f.Free;
    End;
end;


end.
