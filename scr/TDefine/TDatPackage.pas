//by charles 20070327 增加制作Check.dat功能
//DatPackage2.0.0-leon-2009/4/21(修改DatPackage Problem(20090408)代办问题。)
unit TDatPackage;

interface
   Uses Windows,Forms,Messages,Controls,SysUtils,Classes,TCTTF,CsDef,MyDef,TCommon,
   IniFiles,TPtr1,ActiveX;

Const
    WM_DatPackageInfo = WM_APP+3001;

    HistoryDatPath = 'History\Dat\';
    HistoryIDPath  = 'History\Id\';
    HistoryDocPath = 'History\Doc\';
    HistoryBasePath = 'History\Base\';
    HistoryFileLst = 'historyfile.lst';

    MaxFileSize = 20000000;

Type



   TRunStatus = (runError,
                 runWarning,
                 runMsg,
                 runDwnMsg);


   TWMDatPackageString=Record
     WMType : TRunStatus;
     WMString1  : String;
     WMString2  : String;
     WMString3  : String;
     WMMaxCount : Integer;
     WMNowCount : Integer;
   End;
   PWMDatPackageString = ^TWMDatPackageString;


   TTr1Basrec = Packed Record
       BaseDate : TDate;
       MGSY     : Double;
       ZZC: Double;
       GDQY: Double;
       MGJZC: Double;
       LRZE: Double;
       JLR: Double;
       ZYSR: Double;
       JZCSYL: Double;
       ZCFZB: Double;
       ZBGJJ: Double;
       FBRQ: Double;
       CWRQ: Double;
       LDZC: Double;
       CQTZ: Double;
       GDZC: Double;
       WXDY: Double;
       QTZC: Double;
       ZFZ: Double;
       LDFZ: Double;
       CQFZ: Double;
       QTFZ: Double;
       GB: Double;
       YYGJJ: Double;
       ZYYWLR: Double;
       YYFY: Double;
       GLFY: Double;
       CWFY: Double;
       YYLR: Double;
       TZSY: Double;
       BTSR: Double;
       YYWSR: Double;
       YJSDS: Double;
       QCWFPLR: Double;
       TFPLR: Double;
       WFPLR1: Double;
       JYSCXJLR: Double;
       JYHDXJZC: Double;
       JYHDXJLL: Double;
       TZHDXJSR: Double;
       TZHDXJZC: Double;
       TZHDXJLL: Double;
       CZXJSR: Double;
       CZHDXJZC: Double;
       CZHDXJLL: Double;
       HLBDXJBH: Double;
       XJZJJE: Double;
       TZHMGJZC: Double;
       MGGJJ: Double;
       TBHMGSY: Double;
       MGWFPLR: Double;
       ZYYWLRL: Double;
       XSJLL: Double;
       ZZCBCL: Double;
       YSZKZZ: Double;
       CHZZ: Double;
       ZZCZZ: Double;
       LDBL: Double;
       SDBL: Double;
       GDQYB: Double;
       ZYYWZZL: Double;
       SHLRZZL: Double;
       JZCZZL: Double;
       ZZCZZL: Double;
       XGRQ: Double;
       YSZK: Double;
       CH: Double;
   End;
   TTr1BasRecLst = Array of TTr1BasRec;

   TTr1WgtRec = packed record
        vDate      : String[8];
        SGRatio    : longword;
        PGRatio    : longword;
        PGPrice    : longword;
        CDividends : longword;
        ZFVolume   : longword;
        ZZRatio    : longword;
        ZGB        : longword;
        LTGB       : longword;
   end;
   TTr1WgtRecLst = Array of TTr1WgtRec;


   TDATStockRec= Packed  record     //转换的DAT格式
      vDATE  :String[8];           //日期
      Flag   :Boolean;             //旗标 false 正常资料 true 补出来的资料
      OPEN   :longint;             //开3
      HIGH   :longint;             //高3
      LOW    :longint;             //低3
      CLOSE  :longint;             //收3
      VOLUME :longWord;            //量
      AMOUNT :longWord;            //成交值
      DE     :Double;
      GB     :longWord;
      OGB    :longWord;            //流通股本
      vRECORD:longWord;            //成交比数
      RISE   :Word;                //上涨家数
      DOWN   :Word;                //下跌家数
      BASE   :Longint;             //指数基准3
      ROI      :Double;           //报酬率 8
      ROIB     :Double;           //LN报酬率8
      ROI_5    :Double;           //报酬率 8
      ROIB_5   :Double;           //LN报酬率8
      ROI_10   :Double;           //报酬率 8
      ROIB_10  :Double;           //LN报酬率8
      ROI_20   :Double;           //报酬率 8
      ROIB_20  :Double;           //LN报酬率8
   end;
   TDatStockRecLst = Array of TDATStockRec;

   TDATHistoryStockRec= Packed  record     //转换的DAT格式
      vDATE  :String[8];           //日期
      Flag   :Boolean;             //旗标 false 正常资料 true 补出来的资料
      OPEN   :longint;             //开3
      HIGH   :longint;             //高3
      LOW    :longint;             //低3
      CLOSE  :longint;             //收3
      VOLUME :longWord;            //量
      AMOUNT :longWord;            //成交值
      DE     :Double;
      ROI      :longint;           //报酬率 8
      ROIB     :longint;           //LN报酬率8
      ROI_5    :longint;           //报酬率 8
      ROIB_5   :longint;           //LN报酬率8
      ROI_10   :longint;           //报酬率 8
      ROIB_10  :longint;           //LN报酬率8
      ROI_20   :longint;           //报酬率 8
      ROIB_20  :longint;           //LN报酬率8
   end;

   TADocRec=Packed record
       DocCaption  : String;
       DocFileName : String;
       DocDate : TDate;
   End;



   TADocPackageFile=Packed Record
       ID : String;
       DocLst : Array of TADocRec;
   End;


   TBasePackageFile=Packed Record
       ID : String[6];
       ABase : TTr1Basrec;
   End;

   TDatPackageFile=Packed Record
       ID   : String[6];
       EXG  : Byte;
       ADat : TDATHistoryStockRec;
       AWgt : TTr1WgtRec;
   end;

   TPackageFileList=class
   private
     FLogFile : TIniFile;
   public
      constructor Create(const Filename:string);
      destructor Destroy; override;
      procedure SaveFileLog(Const FileName:String);
   end;



   TDatPackageParam=Class
   private
      FTr1DBPath : Array of String;
      FDBPath : Array of String;
      FTr1DBDataPath : Array of String;
      FFTPPort : Array of Integer;
      FFTPServer : Array of String;
      FFTPUploadDir : Array of String;
      FFTPUserName : Array of String;
      FFTPPassword : Array of String;
      FFTPPassive : Array of Boolean;
      FDailyDocFTPPort : Array of Integer;
      FDailyDocFTPServer : Array of String;
      FDailyDocFTPUploadDir : Array of String;
      FDailyDocFTPUserName : Array of String;
      FDailyDocFTPPassword : Array of String;
      FDailyDocFTPPassive : Array of Boolean;
      FSaveDailyDocDays : Array of Integer;
      FDataSource : Array of String;
      FCharSet:Array of String;
      FSoundPort: Integer;
      FSoundServer: String;
      FDatPackageTime: String; //Doc4.1-sun-20090922
      function GetFTr1DBPath(Index: Integer): String;
      function GetFDBPath(Index: Integer): String;
      function GetFTr1DBDataPath(Index: Integer): String;
      function GetFFTPPassive(Index: Integer): Boolean;
      function GetFFTPPassword(Index: Integer): String;
      function GetFFTPPort(Index: Integer): Integer;
      function GetFFTPServer(Index: Integer): String;
      function GetFFTPUploadDir(Index: Integer): String;
      function GetFFTPUserName(Index: Integer): String;
      function GetDataSource(Index: Integer): String;
      function GetDataSourceCount: Integer;
      function GetCharSet(Index: Integer): String;
      function GetFDailyDocFTPPassive(Index: Integer): Boolean;
      function GetFDailyDocFTPPassword(Index: Integer): String;
      function GetFDailyDocFTPPort(Index: Integer): Integer;
      function GetFDailyDocFTPServer(Index: Integer): String;
      function GetFDailyDocFTPUploadDir(Index: Integer): String;
      function GetFDailyDocFTPUserName(Index: Integer): String;
      function GetSaveDailyDocDays(Index: Integer): Integer;
   public
      constructor Create();
      destructor Destroy; override;
      function OpenSetupFrom():boolean;
      property CharSet[Index:Integer]:String read GetCharSet;

      property Tr1DBPath[Index:Integer]:String read GetFTr1DBPath;
      property DBPath[Index:Integer]:String read GetFDBPath;
      property Tr1DBDataPath[Index:Integer]:String read GetFTr1DBDataPath;
      property DataSource[Index:Integer]:String read GetDataSource;
      property DataSourceCount:Integer read GetDataSourceCount;


      property  SoundPort : Integer read FSoundPort;
      property  SoundServer : String read FSoundServer;
      property  FTPPort[Index:Integer]:Integer read GetFFTPPort;
      property  FTPServer[Index:Integer]:String read GetFFTPServer;
      property  FTPUploadDir[Index:Integer]:String read GetFFTPUploadDir;
      property  FTPUserName[Index:Integer]:String read GetFFTPUserName;
      property  FTPPassword[Index:Integer]:String read GetFFTPPassword;
      property  FTPPassive[Index:Integer]:Boolean read GetFFTPPassive;

      property  DailyDocFTPPort[Index:Integer]:Integer read GetFDailyDocFTPPort;
      property  DailyDocFTPServer[Index:Integer]:String read GetFDailyDocFTPServer;
      property  DailyDocFTPUploadDir[Index:Integer]:String read GetFDailyDocFTPUploadDir;
      property  DailyDocFTPUserName[Index:Integer]:String read GetFDailyDocFTPUserName;
      property  DailyDocFTPPassword[Index:Integer]:String read GetFDailyDocFTPPassword;
      property  DailyDocFTPPassive[Index:Integer]:Boolean read GetFDailyDocFTPPassive;

      property  SaveDailyDocDays[Index:Integer]:Integer read GetSaveDailyDocDays;

   end;

   TStanderIDMgr=Class
   private
      FTr1DBDataPath : String;
      FIDLst:Array of String;
      procedure SetAID(const ID:String);
      procedure InitData();
   public
      constructor Create(Const Tr1DBDataPath:String);
      destructor  Destroy; override;
      function IDExists(const ID:String):Boolean;
   end;

   TPackageID=Class(TThread)
   private
      FHandle : HWND;
      FIDPath : String;
      FHistoryIDPath : String;
      FHaveFinishRunning : Boolean;
      FFileNameLst : Array of String;
      FStopRunning: Boolean;
      procedure SetFileNameList(const FileName:String);
      procedure PackageID();
   protected
      procedure Execute; override;
   Public
      constructor Create(AHandle:HWND;IDPath,OutDataPath:String);
      destructor  Destroy; override;
      property StopRunning:Boolean read FStopRunning;
      property HaveFinishRunning:boolean read FHaveFinishRunning;
   End;


   TPackageBase=Class(TThread)
   private
      FHandle : HWND;
      FBasePath : String;
      FHistoryBasePath : String;
      FHaveFinishRunning : Boolean;
      FFileNameLst : Array of String;
      FCBPAFileNameLst : Array of String;
      FStopRunning: Boolean;
      FIDMgr:TStanderIDMgr;
      procedure SetFileNameList(const FileName:String);
      procedure SetCBPAFileNameList(const FileName:String);
      procedure SaveToFile(Const fileName:String;
                           r: Array of TBasePackageFile);
      function SaveToMonth(const ID:String;
                          const Year,Month:Word;
                          RecLst:TTr1BasRecLst):Boolean;
      procedure PackageBase();
      function PackageHistoryBase(const ID,FileName: String): Boolean;overload;
   protected
      procedure Execute; override;
   Public
      constructor Create(AHandle:HWND;BasePath,OutDataPath:String;IDMgr:TStanderIDMgr);
      destructor  Destroy; override;
      property StopRunning:Boolean read FStopRunning;
      property HaveFinishRunning:boolean read FHaveFinishRunning;
   End;

   TPackageDoc=Class(TThread)
   private
      FHandle : HWND;
      FDocPath : String;
      FHistoryDocPath : String;
      FHaveFinishRunning : Boolean;
      FFileNameLst : Array of String;
      FStopRunning: Boolean;
      FSaveDailyDocDays:Integer;
      function GetDocMemo(FileName:String):String;
      procedure SetFileNameList(const FileName:String);
      procedure SaveToFile(AIDDoc : TADocPackageFile);
      Procedure MakeClearDocList();
      procedure PackageDoc();
   protected
      procedure Execute; override;
   Public
      constructor Create(AHandle:HWND;DocPath,OutDataPath:String;
                          SaveDailyDocDays:Integer);
      destructor  Destroy; override;
      property StopRunning:Boolean read FStopRunning;
      property HaveFinishRunning:boolean read FHaveFinishRunning;
   End;

   TPackageData=Class(TThread)
   private
      FHandle : HWND;
      FSDataPath : String;
      FHistoryDatPath : String;
      FHaveFinishRunning : Boolean;
      FStopRunning: Boolean;
      FFileNameLst : Array of String;
      FCBPAFileNameLst : Array of String;
      FIDMgr:TStanderIDMgr;
      FDataSource : String;
      procedure GetYMD(const DateStr:String;Var Year,Month,Day:Word);
      Function GetDate(const DateStr:String):TDate;
      procedure CopyToValue(Var Dest:TDATHistoryStockRec;Var source:TDATStockRec);
      function RecDatIsTheSame(Const Dat1,Dat2:TDatPackageFile):Boolean;
      function  GetFileName(const fileName:String):String;
      procedure SetFileNameList(const FileName:String);
      procedure SetCBPAFileNameList(const FileName:String);
      function SaveToFile(const ID : String;
                           Const EXG : Byte;
                           Const fileName:String;
                           r: Array of TDatPackageFile):string;

      function SaveToYear(const ID,EXG:String;
                          const Year:Word;
                          RecLst:TDatStockRecLst;
                          RecWgtLst:TTr1WgtRecLst):Boolean;
      function SaveToMonth(const ID,EXG:String;
                          const Year,Month:Word;
                          RecLst:TDatStockRecLst;
                          RecWgtLst:TTr1WgtRecLst):Boolean;
      function SaveToWeek(const ID,EXG:String;
                          const Year,Month:Word;
                          const Week:Integer;
                          RecLst:TDatStockRecLst;
                          RecWgtLst:TTr1WgtRecLst):Boolean;
      procedure PackageData();
      function PackageHistoryDat(const Exg:String):boolean;overload;
      function PackageHistoryDat(const ID, EXG, DatFileName,WgtFileName: String): Boolean;overload;

   protected
      procedure Execute; override;
   Public
      constructor Create(AHandle:HWND;DataSource:String;SDataPath,OutDataPath:String;IDMgr:TStanderIDMgr);
      destructor  Destroy; override;
      property StopRunning:Boolean read FStopRunning;
      property HaveFinishRunning:boolean read FHaveFinishRunning;
   end;



   TConvertTr1Data=Class(TThread)
   private
      FHandle : HWND;
      FTR1DBPath : String;
      FSDataPath : String;
      FBasePath : String;
      FIDPath : String;
      FHaveFinishRunning : Boolean;
      FDayToDatProc:TFarProc;
      FStopRunning: Boolean;
      FPackDat,FPackID,FPackBase:Boolean;
      FDataSource : String;
      function ConvertTr1DayToDat():Boolean;
      function ConvertTr1DayToDatTWN():Boolean;
      function ConvertTr1BaseToBas():Boolean;
      function ConvertTr1IDToID():Boolean;
   protected
      procedure Execute; override;
   Public
      constructor Create(AHandle:HWND;
                         DataSource:String;
                         TR1DBPath,SDataPath,BasePath,IDPath:String;
                         const PackDat,PackID,PackBase:Boolean;
                         DayToDatProc:TFarProc=nil);
      destructor  Destroy; override;
      property StopRunning:Boolean read FStopRunning;
      property HaveFinishRunning:boolean read FHaveFinishRunning;
   end;

   TPackageManager=Class(TObject)
   private
      FHandle : HWND;
      FTR1DBPath : String;
      FOutDataPath : String;
      FSDataPath : String;
      FBasePath : String;
      FIDPath : String;
      FTr1DBDataPath : String;
      FDocPath : String;
      FDayToDatProc : TFarProc;
      FStopRunning  : Boolean;
      FNowIsRunning : Boolean;
   Public
      constructor Create(AHandle:HWND;
                         Tr1DBDataPath,TR1DBPath,OutDataPath:String;
                         DayToDatProc:TFarProc=nil);
      destructor  Destroy; override;
     // function PackageData(Caption:String;
    //          const PackDat,PackID,PackBase,PackDoc:Boolean;
    //          SaveDailyDocDays:Integer):Boolean;
    function PackageData(Caption:String;
                  const  PackDoc:Boolean;
            SaveDailyDocDays:Integer):Boolean;
      procedure StopExec();

      Property NowIsRunning:Boolean read FNowIsRunning;

   End;

   function  GetSDataPath(const EXG,DataPath:String):String;

   function NextPackageWeekData(Const StartDate:TDate):TDate;
   function NextPackageMonthData(Const StartDate:TDate):TDate;
   function NextPackageYearData(Const StartDate:TDate):TDate;


implementation
uses
   MainFrm;


function NextPackageYearData(Const StartDate:TDate):TDate;
var
   D, M, Y : Word;
begin

  DecodeDate(StartDate, Y, M, D);
  DecodeDate(IncMonth(EncodeDate(Y, 12, 1), 1), Y, M, D);
  Result := EncodeDate(Y, M, 1) - 1;

End;

function NextPackageMonthData(Const StartDate:TDate):TDate;
var
   D, M, Y : Word;
begin
  DecodeDate(IncMonth(StartDate, 1), Y, M, D);
  Result := EncodeDate(Y, M, 1) - 1;

End;

function NextPackageWeekData(Const StartDate:TDate):TDate;
Var
  NowWeek,Day : Integer;
Begin

   NowWeek := DayOfWeek(StartDate);
   if NowWeek=7 Then
      Day := 6
   Else
      Day := 6-NowWeek;
   result := StartDate+Day;

End;

function  GetSDataPath(const EXG,DataPath:String):String;
Begin

 Result := DataPath;
 if Exg='01' Then
    Result := DataPath + 'shase\dat\';
 if Exg='02' Then
    Result := DataPath + 'sznse\dat\';
 if Exg='03' Then
    Result := DataPath + 'twn\dat\';

End;

{ TPackageManager }

constructor TPackageManager.Create(AHandle:HWND;
                         Tr1DBDataPath,TR1DBPath,OutDataPath:String;
                         DayToDatProc:TFarProc=nil);
begin
    FHandle := AHandle;
    FTR1DBPath   := IncludeTrailingBackslash(TR1DBPath);
    FOutDataPath := IncludeTrailingBackslash(OutDataPath);
    FSDataPath   := FOutDataPath + 'Data\';
    FBasePath    := FOutDataPath + 'Base\';
    FIDPath   := FOutDataPath + 'ID\';
    FTr1DBDataPath := Tr1DBDataPath;
    FDocPath  := FTr1DBDataPath+'Document\';
    FDayToDatProc := DayToDatProc;

    MkDir_Directory(FOutDataPath);
    MkDir_Directory(FSDataPath);
    MkDir_Directory(FBasePath);
    MkDir_Directory(FIDPath);
end;

destructor TPackageManager.Destroy;
begin
  StopExec;
  //inherited;
end;

function TPackageManager.PackageData(Caption:String;
const PackDoc:Boolean;SaveDailyDocDays:Integer): Boolean; //Doc4.2-sun-20090922

//function TPackageManager.PackageData(Caption:String;
//const PackDat,PackID,PackBase,PackDoc:Boolean;SaveDailyDocDays:Integer): Boolean;
Var
  aConvertObj : TConvertTr1Data;
  aPackageObj : TPackageData;
  aPackageDoc : TPackageDoc;
  aPackageID : TPackageID;
  aPackageBase : TPackageBase;
  IDMgr : TStanderIDMgr;
Var
 ObjWM : TWMDatPackageString;
begin
   Result := false;
   if FNowIsRunning Then exit;
   FNowIsRunning := True;
   FStopRunning := false;
   aConvertObj := nil;
   aPackageObj := nil;
   aPackageDoc := nil;
   aPackageID  := nil;
   aPackageBase  := nil;
   IDMgr := nil;
try
try
   IDMgr := TStanderIDMgr.Create(FTr1DBDataPath);
   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('开始 ') +Caption+AMainFrm.ConvertStr(' 数据的打包.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   if PackDoc Then
   Begin
     aPackageDoc := TPackageDoc.Create(FHandle,FDocPath,FOutDataPath,
                 SaveDailyDocDays);
     aPackageDoc.Resume;
     While Not aPackageDoc.StopRunning do
     Begin
         if Self.FStopRunning Then
         Begin
            aPackageDoc.Terminate;
            aPackageDoc.WaitFor;
         End;
         Application.ProcessMessages;
         Sleep(10);
     End;
     if Not aPackageDoc.HaveFinishRunning Then Exit;
   End;

   {
   if Not Self.FStopRunning Then
   if (PackID) or (PackBase) or (PackDat) Then
   Begin
     aConvertObj := TConvertTr1Data.Create(FHandle,Caption,FTR1DBPath,
                                           FSDataPath,FBasePath,FIDPath,
                                           PackDat,PackID,PackBase,
                                           FDayToDatProc);
     aConvertObj.Resume;
     While Not aConvertObj.StopRunning do
     Begin
         if Self.FStopRunning Then
         Begin
            aConvertObj.Terminate;
            aConvertObj.WaitFor;
         End;
         Application.ProcessMessages;
         Sleep(10);
     End;
     if Not aConvertObj.HaveFinishRunning Then Exit;
   End;

   if Not Self.FStopRunning Then
   if PackDat Then
   Begin
     aPackageObj := TPackageData.Create(FHandle,Caption,FSDataPath,FOutDataPath,IDMgr);
     aPackageObj.Resume;
     While Not aPackageObj.StopRunning do
     Begin
       if Self.FStopRunning Then
       Begin
          aPackageObj.Terminate;
          aPackageObj.WaitFor;
       End;
       Application.ProcessMessages;
       Sleep(10);
     End;
     if Not aPackageObj.HaveFinishRunning Then Exit;
   End;

   if Not Self.FStopRunning Then
   if PackBase Then
   Begin
     aPackageBase := TPackageBase.Create(FHandle,FBasePath,FOutDataPath,IDMgr);
     aPackageBase.Resume;
     While Not aPackageBase.StopRunning do
     Begin
         if Self.FStopRunning Then
         Begin
            aPackageBase.Terminate;
            aPackageBase.WaitFor;
         End;
         Application.ProcessMessages;
         Sleep(10);
     End;
     if Not aPackageBase.HaveFinishRunning Then Exit;
   End;

   if Not Self.FStopRunning Then
   if PackID Then
   Begin
     aPackageID := TPackageID.Create(FHandle,FIDPath,FOutDataPath);
     aPackageID.Resume;
     While Not aPackageID.StopRunning do
     Begin
         if Self.FStopRunning Then
         Begin
            aPackageID.Terminate;
            aPackageID.WaitFor;
         End;
         Application.ProcessMessages;
         Sleep(10);
     End;
     if Not aPackageID.HaveFinishRunning Then Exit;
   End;
   }

   if Self.FStopRunning Then
      Exit;

   result := True;
   IDMgr.Destroy;
   IDMgr := nil;

except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(PackageData)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end
finally


   if Result Then
   Begin
       ObjWM.WMType := runMsg;
       ObjWM.WMString1 := AMainFrm.ConvertStr('完成数据的打包.');
       SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End Else
   Begin
       if Self.FStopRunning Then
       Begin
          ObjWM.WMType := runMsg;
          ObjWM.WMString1 := AMainFrm.ConvertStr('中断打包.');
          SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
       End;
   End;

   if IDMgr<>nil Then
      IDMgr.Destroy;

   if aConvertObj<>nil Then
      aConvertObj.Destroy;
   if aPackageObj<>nil Then
      aPackageObj.Destroy;
   if aPackageDoc<>nil Then
      aPackageDoc.Destroy;
   if aPackageBase<>nil Then
      aPackageBase.Destroy;
   if aPackageID<>nil Then
      aPackageID.Destroy;

   FNowIsRunning := false;

end;

end;

procedure TPackageManager.StopExec();
begin
  FStopRunning := True;
end;

{ TConvertTr1Data }

function TConvertTr1Data.ConvertTr1BaseToBas:Boolean;
Var
   FileLst : _CStrLst;
   Tr1DBPath : String;
   i : Integer;
 ObjWM : TWMDatPackageString;
begin

   Result := False;
   CoInitialize(nil);
try
try
   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('正在转换财务数据.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   DelTree(FBasePath,True);

   Tr1DBPath := FTr1DBPath+'Base\';
   FolderAllFiles(Tr1DBPath,'.MDB',FileLst,False);
   for i:=0 to High(FileLst) do
   Begin
     if Terminated Then Exit;
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('正在复制')+ ExtractFileName(FileLst[i]) + AMainFrm.ConvertStr('.');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     CopyFile(PChar(FileLst[i]+''),PChar(FBasePath+ExtractFileName(FileLst[i])),false);
   End;

   SetLength(FileLst,0);
   {FolderAllFiles(Tr1DBPath,'.PX',FileLst,False);
   for i:=0 to High(FileLst) do
   Begin
     if Terminated Then Exit;
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('正在复制')+ ExtractFileName(FileLst[i]) + AMainFrm.ConvertStr('.');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     CopyFile(PChar(FileLst[i]+''),PChar(FBasePath+ExtractFileName(FileLst[i])),false);
   End;
  }
   if Not ConvDBFBasToTxt(FBasePath,FDayToDatProc) Then
      Exit;
   if Terminated Then
      Exit;
   Result := True;
except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(ConvertTr1BaseToBas)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

     //----------------------------
     {ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新转换');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     ConvertTr1BaseToBas;
     }
     //------------------------------
   End;
end;
finally

   if Result Then
   Begin
      ObjWM.WMType := runMsg;
      ObjWM.WMString1 := AMainFrm.ConvertStr('转换完成.');
      SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
   CoUnInitialize();
end;

end;

function TConvertTr1Data.ConvertTr1DayToDat:Boolean;
Var
 ObjWM : TWMDatPackageString;
 i : Integer;
 Files : _CStrLst;
begin
   Result := False;
try
try

   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('正在将TR1Day格式转成Dat格式.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   DelTree(FSDataPath,True);
   if Not ConvTr1DayToDatALL(FTr1DBPath,FSDataPath,FDayToDatProc) Then
      Exit;

   Mkdir_Directory(FSDataPath+'Shase\Wgt\');
   Mkdir_Directory(FSDataPath+'Sznse\Wgt\');

   SetLength(Files,0);
   FolderAllFiles(FTr1DBPath+'Wgt\sh\','.wgt',Files);
   For i := 0 to  High(Files) do
   begin
      Application.ProcessMessages;
      if Terminated Then Exit;
      ObjWM.WMType := runMsg;
      ObjWM.WMString1 := AMainFrm.ConvertStr('正在复制')+ ExtractFileName(Files[i]) + AMainFrm.ConvertStr('.');
      SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
      CopyFile(PChar(Files[i]+''),PChar(FSDataPath+'Shase\Wgt\'+ExtractFileName(Files[i])),false);
   end;

   SetLength(Files,0);
   FolderAllFiles(FTr1DBPath+'Wgt\sz\','.wgt',Files);
   For i := 0 to  High(Files) do
   begin
      Application.ProcessMessages;
      if Terminated Then Exit;
      ObjWM.WMType := runMsg;
      ObjWM.WMString1 := AMainFrm.ConvertStr('正在复制')+ ExtractFileName(Files[i]) + AMainFrm.ConvertStr('.');
      SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
      CopyFile(PChar(Files[i]+''),PChar(FSDataPath+'Sznse\Wgt\'+ExtractFileName(Files[i])),false);
   end;

   if Terminated Then Exit;

   Result := True;

except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(ConvertTr1DayToDat)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

     //----------------------------
     {ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新转换');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     ConvertTr1DayToDat;
     }
     //------------------------------

   End;
end;
finally

   if Result Then
   Begin
      ObjWM.WMType := runMsg;
      ObjWM.WMString1 := AMainFrm.ConvertStr('转换完成.');
      SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;

end;

end;

function TConvertTr1Data.ConvertTr1DayToDatTWN: Boolean;
Var
 ObjWM : TWMDatPackageString;
 i : Integer;
 Files : _CStrLst;
begin
   Result := False;
try
try
   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('正在将TR1Day格式转成Dat格式.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   DelTree(FSDataPath,True);
   if Not ConvTr1DayToDatALL_TWN(FTr1DBPath,FSDataPath,FDayToDatProc) Then
      Exit;
   Mkdir_Directory(FSDataPath+'TWN\Wgt\');
   SetLength(Files,0);
   FolderAllFiles(FTr1DBPath+'Wgt\Twn\','.wgt',Files);
   For i := 0 to  High(Files) do
   begin
      Application.ProcessMessages;
      if Terminated Then Exit;
      ObjWM.WMType := runMsg;
      ObjWM.WMString1 := AMainFrm.ConvertStr('正在复制')+ ExtractFileName(Files[i]) + AMainFrm.ConvertStr('.');
      SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
      CopyFile(PChar(Files[i]+''),PChar(FSDataPath+'TWN\Wgt\'+ExtractFileName(Files[i])),false);
   end;
   if Terminated Then Exit;
   Result := True;
except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(ConvertTr1DayToDatTWN)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

     //----------------------------
     {ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新转换');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     ConvertTr1DayToDat;
     }
     //------------------------------

   End;
end;
finally
   if Result Then
   Begin
      ObjWM.WMType := runMsg;
      ObjWM.WMString1 := AMainFrm.ConvertStr('转换完成.');
      SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;

end;

function TConvertTr1Data.ConvertTr1IDToID:Boolean;
Var
   FileLst : _CStrLst;
   Tr1DBPath : String;
   i : Integer;
 ObjWM : TWMDatPackageString;
begin

    Result := False;
    CoInitialize(nil);
try
try

   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('正在转换股票代码.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   Tr1DBPath := FTr1DBPath+'ID\';
   FolderAllFiles(Tr1DBPath,'.MDB',FileLst,False);
   for i:=0 to High(FileLst) do
   Begin
     if Terminated Then Exit;
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('正在复制')+ ExtractFileName(FileLst[i]) + AMainFrm.ConvertStr('.');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     CopyFile(PChar(FileLst[i]+''),PChar(FIDPath+ExtractFileName(FileLst[i])),false);
   End;

   {
   SetLength(FileLst,0);
   FolderAllFiles(Tr1DBPath,'.PX',FileLst,False);
   for i:=0 to High(FileLst) do
   Begin
     if Terminated Then Exit;
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('正在复制')+ ExtractFileName(FileLst[i]) + AMainFrm.ConvertStr('.');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     CopyFile(PChar(FileLst[i]+''),PChar(FIDPath+ExtractFileName(FileLst[i])),false);
   End;
   }
   if Not ConvDBFIDToTxt(FIDPath,FDayToDatProc) Then
      exit;

   if Terminated Then Exit;

   Result := True;

except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(ConvertTr1IDToID)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

     //----------------------------
     {ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新转换');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     ConvertTr1IDToID;
     }
     //------------------------------

   End;
end;
finally

   if Result Then
   Begin
      ObjWM.WMType := runMsg;
      ObjWM.WMString1 := AMainFrm.ConvertStr('转换完成.');
      SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
   CoUnInitialize();
end;

end;

constructor TConvertTr1Data.Create(AHandle: HWND; DataSource:String;TR1DBPath,
  SDataPath,BasePath,IDPath: String;const PackDat,PackID,PackBase:Boolean;
  DayToDatProc:TFarProc);
begin



   FHandle := AHandle;
   FDataSource := DataSource;
   FTR1DBPath  := TR1DBPath;
   FSDataPath  := SDataPath;
   FBasePath   := BasePath;
   FIDPath     := IDPath;
   FDayToDatProc := DayToDatProc;
   FHaveFinishRunning  := False;
   FStopRunning := False;

   FPackDat :=PackDat;
   FPackID  := PackID;
   FPackBase:= PackBase;

   FreeOnTerminate := false;
   inherited Create(true);

end;

destructor TConvertTr1Data.Destroy;
begin
  
  //inherited;
end;

procedure TConvertTr1Data.Execute;
begin

Try
Try

  if FPackDat Then
  Begin
    if lowercase(FDataSource)='taiwan' Then
    Begin
       if Not ConvertTr1DayToDatTWN Then
          Exit;
    End Else
    Begin
       if Not ConvertTr1DayToDat Then
          Exit;
    End;
  End;

  if FPackBase Then
    if Not ConvertTr1BaseToBas Then
       Exit;

  if FPackID Then
    if Not ConvertTr1IDToID Then
       Exit;

  FHaveFinishRunning := True;

Except
End;
Finally
  FStopRunning := True;
End;

end;

{ TPackageData }

constructor TPackageData.Create(AHandle: HWND;DataSource:String;
SDataPath,OutDataPath: String;IDMgr:TStanderIDMgr);
begin

   FHandle := AHandle;
   FSDataPath := SDataPath;
   FIDMgr := IDMgr;
   FDataSource := LowerCase(DataSource);
   FHistoryDatPath := OutDataPath+HistoryDatPath;

   FHaveFinishRunning  := False;
   FStopRunning := False;

   MkDir_Directory(FHistoryDatPath);

   FreeOnTerminate := false;
   inherited Create(true);

end;

destructor TPackageData.Destroy;
begin

  //inherited;
end;

procedure TPackageData.Execute;
begin
  //inherited;
  PackageData;
end;

procedure TPackageData.PackageData;
Var
  ObjWM : TWMDatPackageString;
  PackageFileList : TPackageFileList;
  i : integer;
begin

try
try

   Deltree(FHistoryDatPath,true,false);

   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('正在将日线数据打包.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   if FDataSource='taiwan' Then
   Begin
     if Not PackageHistoryDat('03') Then  Exit;
     if Terminated Then Exit;
   End Else
   Begin
     if Not PackageHistoryDat('01') Then  Exit;
     if Terminated Then Exit;
     if Not PackageHistoryDat('02') Then  Exit;
     if Terminated Then Exit;          
   End;


   PackageFileList :=
          TPackageFileList.Create(FHistoryDatPath+HistoryFileLst);
   for i:=0 to High(FFileNameLst) do
        PackageFileList.SaveFileLog(FFileNameLst[i]);
   PackageFileList.Destroy;

   PackageFileList :=
          TPackageFileList.Create(FHistoryDatPath+'cbpa\'+HistoryFileLst);
   for i:=0 to High(FCBPAFileNameLst) do
        PackageFileList.SaveFileLog(FCBPAFileNameLst[i]);

   PackageFileList.Destroy;


   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('日线数据打包完成.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   FHaveFinishRunning := True;


except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(PackageData)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     {//----------------------------
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新打包');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     PackageData;
     //------------------------------
     }
   End;
end;
finally



   FStopRunning := True;


end;

end;

function TPackageData.PackageHistoryDat(const Exg: String): boolean;
Var
  ID,SDataPath : String;
  ObjWM : TWMDatPackageString;
  FileLst : _CStrLst;
  i : Integer;
  DatFileName,WgtFileName : String;
begin


   Result := False;

try
try

   SDataPath := GetSDataPath(Exg,FSDataPath);

   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('正在收集交易所 (')+ Exg + AMainFrm.ConvertStr(') 的日线档案.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   FolderAllFiles(SDataPath,'.DAT',FileLst);

   for i:=0 to High(FileLst) do
   Begin
      DatFileName := FileLst[i];
      WgtFileName := DatFileName;
      ReplaceSubString('.DAT','.WGT',WgtFileName);
      ReplaceSubString('\Dat\','\Wgt\',WgtFileName);
      ID := ExtractFileName(DatFileName);
      ReplaceSubString('.DAT','',ID);
      if not PackageHistoryDat(ID,EXG,DatFileName,WgtFileName) Then Exit;
      if Terminated Then Exit;
   end;

   if Terminated Then Exit;

   Result := True;

except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(PackageHistoryDat)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

     {//----------------------------
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新打包');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     Result := PackageHistoryDat(EXG);
     //------------------------------
     }
   End;
end;
finally

   SetLength(FileLst,0);

   if Result Then
   Begin
      ObjWM.WMType := runMsg;
      ObjWM.WMString1 := AMainFrm.ConvertStr('交易所 (')+ Exg + AMainFrm.ConvertStr(')打包完成.');
      SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;

end;

end;

{ TAPackageDatRec }


function TPackageData.GetDate(const DateStr: String): TDate;
Var
  Year,Month,Day:Word;
Begin
      Year  := StrToInt(Copy(DateStr,1,4));
      Month := StrToInt(Copy(DateStr,5,2));
      Day   := StrToInt(Copy(DateStr,7,2));
      Result := EncodeDate(Year,Month,Day);
End;

procedure TPackageData.GetYMD(const DateStr: String; var Year, Month,
  Day: Word);
Begin
      Year  := StrToInt(Copy(DateStr,1,4));
      Month := StrToInt(Copy(DateStr,5,2));
      Day   := StrToInt(Copy(DateStr,7,2));
End;


function TPackageData.PackageHistoryDat(const ID, EXG, DatFileName,WgtFileName: String): Boolean;
Var
  r  : TDatStockRecLst;
  f  : file of TDATStockRec;
  WgtR  : TTr1WgtRecLst;
  WgtF  : file of TTr1WgtRec;

  i  : Word;
  NowYear,NowMonth,NowDay : Word;
  Year,Month,Day : Word;
  ObjWM : TWMDatPackageString;
begin

   Result := false;
   if Not FileExists(DatFileName) Then exit;

try
try

    Try
      if ((GetFileSize(DatFileName) mod SizeOf(TDATStockRec))<>0) or (GetFileSize(DatFileName)=0)Then
      Begin
         ObjWM.WMType := runError;
         ObjWM.WMString1 := ExtractFileName(DatFileName) +AMainFrm.ConvertStr(' 档案格式错误');
         SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
         Exit;
      End;

      if FileExists(WgtFileName) Then
      if ((GetFileSize(WgtFileName) mod SizeOf(TTr1WgtRec))<>0) or (GetFileSize(WgtFileName)=0)Then
      Begin
         if GetFileSize(WgtFileName)=0 Then
            DeleteFile(WgtFileName)
         Else  Begin
           ObjWM.WMType := runError;
           ObjWM.WMString1 := ExtractFileName(WgtFileName) +AMainFrm.ConvertStr(' 档案格式错误');
           SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
           Exit;
         End;
      End;

    Except
    End;

    DecodeDate(Date,NowYear,NowMonth,NowDay);

    ObjWM.WMType := runMsg;
    ObjWM.WMString1 := AMainFrm.ConvertStr('打包 ') + ExtractFileName(DatFileName);
    SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

    Assignfile(f,DatFileName);
    FileMode := 0;
    Reset(f);
    Setlength(r,FileSize(f));
    BlockRead(f,r[0],High(r)+1);
    CloseFile(f);

    Setlength(WgtR,0);
    if FileExists(WgtFileName) Then
    Begin
      Assignfile(WgtF,WgtFileName);
      FileMode := 0;
      Reset(WgtF);
      Setlength(WgtR,FileSize(WgtF));
      BlockRead(WgtF,WgtR[0],High(WgtR)+1);
      CloseFile(WgtF);
    End;

    GetYMD(r[0].vDate,Year,Month,Day);


    for i:=Year to NowYear-1 do
       if Not SaveToYear(ID,EXG,i,r,WgtR) Then Exit;
    for i:=1 to NowMonth-1 do
      if Not SaveToMonth(ID,EXG,NowYear,i,r,WgtR) Then Exit;
    for i:=1 to 4 do
      if Not SaveToWeek(ID,EXG,NowYear,NowMonth,i,r,WgtR) Then Exit;

    if Self.Terminated Then Exit;


    Result := true;

except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(PackageHistoryDat)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     {
     //----------------------------
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新打包');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     Result := PackageHistoryDat(ID, EXG, DatFileName,WgtFileName);
     //------------------------------
     }
   End;
end;
finally
   if Result Then
   Begin
      //ObjWM.WMType := runMsg;
      //ObjWM.WMString1 := AMainFrm.ConvertStr('打包 ') + ExtractFileName(FileName) +AMainFrm.ConvertStr(' 完成.');
      //SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;

End;





function TPackageData.SaveToMonth(const ID, EXG: String;
  const Year,Month: Word; RecLst: TDatStockRecLst;RecWgtLst:TTr1WgtRecLst): Boolean;
Var
  r  : Array of TDatPackageFile;
  i,j,g  : integer;
  NowYear,NowMonth,NowDay : Word;
  ObjWM : TWMDatPackageString;
  FileName : String;
begin

   Result := false;

try
try
   //ObjWM.WMType := runMsg;
   //ObjWM.WMString1 := AMainFrm.ConvertStr('正在打包 ') + IntToStr(Year)+AMainFrm.ConvertStr('年')+ IntToStr(Month)+ AMainFrm.ConvertStr('月的数据');
   //SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));


   SetLength(r,0);

   for i:=0 to High(RecLst) do
   Begin
       if Self.Terminated Then Exit;
       GetYMD(RecLst[i].vDATE,NowYear,NowMonth,NowDay);
       if (NowYear=Year) and (NowMonth=Month) Then
       Begin
          j := High(r)+1;
          SetLength(r,j+1);
          r[j].ID   := ID;
          r[j].EXG  := StrToInt(EXG);
          CopyToValue(r[j].ADat,RecLst[i]);
          for g:=0 to High(RecWgtLst) do
             if RecWgtLst[g].vDATE=RecLst[i].vDATE Then
                 r[j].AWgt := RecWgtLst[g];
       End;
   End;


   fileName := format('%2s',[IntToStr(Month)]);
   ReplaceSubString(' ' ,'0',FileName);
   FileName := FHistoryDatPath+'_'+IntToStr(Year)+FileName+'.DAT';
   SetFileNameList(SaveToFile(ID,StrToInt(EXG),GetFileName(FileName),r));

   if FIDMgr.IDExists(ID) Then
   Begin
      FileName := ExtractFilePath(FileName)+'cbpa\'+ExtractFileName(FileName);
      Mkdir_Directory(ExtractFilePath(FileName));
      SetCBPAFileNameList(SaveToFile(ID,StrToInt(EXG),GetFileName(FileName),r));
   End;

   Result := True;

Except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(SaveToYear)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;

Finally
   if Result Then
   Begin
     //ObjWM.WMType := runMsg;
     //ObjWM.WMString1 := AMainFrm.ConvertStr('完成打包 ') + IntToStr(Year)+AMainFrm.ConvertStr('年')+ IntToStr(Month)+ AMainFrm.ConvertStr('月的数据');
     //SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;


end;

function TPackageData.SaveToWeek(const ID, EXG: String; const Year,
  Month: Word;const Week:Integer; RecLst: TDatStockRecLst;RecWgtLst:TTr1WgtRecLst): Boolean;
Var
  r  : Array of TDatPackageFile;
  i,j,t,g  : integer;
  NowWeek,NowYear,NowMonth,NowDay : Word;
  ObjWM : TWMDatPackageString;
  fileName : String;
begin

   Result := false;

try
try
   //ObjWM.WMType := runMsg;
   //ObjWM.WMString1 := AMainFrm.ConvertStr('正在打包 ') + IntToStr(Year)+AMainFrm.ConvertStr('年')+
   //                   IntToStr(Month)+ '月 ' +
   //                   '第 ' + IntToStr(Week)+' 周的数据';
   //SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));


   SetLength(r,0);

   NowWeek := 1;
   t := 0;
   for i:=0 to High(RecLst) do
   Begin
       if Self.Terminated Then Exit;
       GetYMD(RecLst[i].vDATE,NowYear,NowMonth,NowDay);
       if (NowYear=Year) and (NowMonth=Month) Then
       Begin
          NowDay := DayOfWeek(GetDate(RecLst[i].vDATE));
          if NowDay<t Then
            Inc(NowWeek);
          t := NowDay;
          if (NowWeek=Week) Then
          Begin
            j := High(r)+1;
            SetLength(r,j+1);
            r[j].ID   := ID;
            r[j].EXG  := StrToInt(EXG);
            CopyToValue(r[j].ADat,RecLst[i]);
            for g:=0 to High(RecWgtLst) do
               if RecWgtLst[g].vDATE=RecLst[i].vDATE Then
                   r[j].AWgt := RecWgtLst[g];
          End;
       End;
   End;


   fileName := format('%2s',[IntToStr(Month)])+'W'+format('%2s',[IntToStr(Week)]);
   ReplaceSubString(' ' ,'0',FileName);
   FileName := FHistoryDatPath+'_'+IntToStr(Year)+FileName+'.DAT';
   SetFileNameList(SaveToFile(ID,StrToInt(EXG),GetFileName(FileName),r));

   if FIDMgr.IDExists(ID) Then
   Begin
      FileName := ExtractFilePath(FileName)+'cbpa\'+ExtractFileName(FileName);
      Mkdir_Directory(ExtractFilePath(FileName));
      SetCBPAFileNameList(SaveToFile(ID,StrToInt(EXG),GetFileName(FileName),r));
   End;

   Result := True;

Except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(SaveToYear)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;

Finally
   if Result Then
   Begin
     //ObjWM.WMType := runMsg;
     //ObjWM.WMString1 := AMainFrm.ConvertStr('完成打包 ') + IntToStr(Year)+AMainFrm.ConvertStr('年')+
     //                             IntToStr(Month)+ '月 ' +
     //                             '第 ' + IntToStr(Week)+' 周的数据完成';
     //SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;


end;

function TPackageData.SaveToYear(const ID, EXG: String;
  const Year: Word;RecLst:TDatStockRecLst;RecWgtLst:TTr1WgtRecLst): Boolean;
Var
  r  : Array of TDatPackageFile;
  i,j,g  : integer;
  NowYear,NowMonth,NowDay : Word;
  ObjWM : TWMDatPackageString;
  FileName : String;
begin

   Result := false;

try
try
   //ObjWM.WMType := runMsg;
   //ObjWM.WMString1 := AMainFrm.ConvertStr('正在打包 ') + IntToStr(Year)+AMainFrm.ConvertStr(' 年的数据');
   //SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));


   SetLength(r,0);

   for i:=0 to High(RecLst) do
   Begin
       if Self.Terminated Then Exit;
       GetYMD(RecLst[i].vDATE,NowYear,NowMonth,NowDay);
       if NowYear=Year Then
       Begin
          j := High(r)+1;
          SetLength(r,j+1);
          r[j].ID   := ID;
          r[j].EXG  := StrToInt(EXG);
          CopyToValue(r[j].ADat,RecLst[i]);
          for g:=0 to High(RecWgtLst) do
             if RecWgtLst[g].vDATE=RecLst[i].vDATE Then
                 r[j].AWgt := RecWgtLst[g];
       End;
   End;


   FileName := FHistoryDatPath+'_'+IntToStr(Year)+'.DAT';
   SetFileNameList(SaveToFile(ID,StrToInt(EXG),GetFileName(FileName),r));

   if FIDMgr.IDExists(ID) Then
   Begin
      FileName := ExtractFilePath(FileName)+'cbpa\'+ExtractFileName(FileName);
      Mkdir_Directory(ExtractFilePath(FileName));
      SetCBPAFileNameList(SaveToFile(ID,StrToInt(EXG),GetFileName(FileName),r));
   End;


   Result := True;

Except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(SaveToYear)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;

Finally
   if Result Then
   Begin
     //ObjWM.WMType := runMsg;
     //ObjWM.WMString1 := AMainFrm.ConvertStr('完成打包 ') + IntToStr(Year)+AMainFrm.ConvertStr(' 年的数据');
     //SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;


end;


procedure TPackageData.CopyToValue(var Dest: TDATHistoryStockRec;
  var source: TDATStockRec);
begin

          Dest.vDATE  := Source.vDATE;
          Dest.Flag   := Source.flag;
          Dest.OPEN   := Source.OPEN;
          Dest.HIGH   := Source.HIGH;
          Dest.LOW    := Source.LOW;
          Dest.CLOSE  := Source.CLOSE;
          Dest.VOLUME := Source.VOLUME;
          Dest.AMOUNT := Source.AMOUNT;
          Dest.DE     := Source.DE;
          Dest.ROI    := Round(Source.ROI);
          Dest.ROIB   := Round(Source.ROIB);
          Dest.ROI_5  := Round(Source.ROI_5);
          Dest.ROIB_5 := Round(Source.ROIB_5);
          Dest.ROI_10 := Round(Source.ROI_10);
          Dest.ROIB_10:= Round(Source.ROIB_10);
          Dest.ROI_20 := Round(Source.ROI_20);
          Dest.ROIB_20:= Round(Source.ROIB_20);

end;

function TPackageData.SaveToFile(const ID : String;
                                  Const EXG : Byte;
                                  Const fileName:String;
                                  r: Array of TDatPackageFile):string;

  Procedure SortDatLst(Var BufferGrid: Array of TDatPackageFile);    //0 递增 1 递减
  var
    lLoop1,lHold,lHValue       :Longint;
    lTemp                      :TDatPackageFile;
    Count :Integer;
  Begin



    if High(BufferGrid) < 0 then exit;

    //取出所有的 Record 准备排序
    Count   := High(BufferGrid)+1;
    lHValue :=Count-1;
    repeat
        lHValue := 3 * lHValue + 1;
    Until lHValue > (Count-1);

    repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (Count-1) do
        Begin

            lTemp := BufferGrid[lLoop1];

            lHold := lLoop1;
            while BufferGrid[lHold - lHValue].ADat.vDATE
                        > lTemp.ADat.vDATE do
            Begin
                 BufferGrid[lHold] := BufferGrid[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
            End;
            BufferGrid[lHold] := lTemp;

        end;
     Until lHValue = 0;

  End;
Var
  //Rec1  : Array of TDatPackageFile;
  //Rec2  : Array of TDatPackageFile;
  f  : file of TDatPackageFile;
  HaveExistData : Boolean;
  //RecCount,GetCount,StartRec,EndRec,NowRecCount : integer;
  AFileSize : Integer;
begin


   Result := FileName;
   HaveExistData := false;


   //SetLength(Rec1,0);
   //SetLength(Rec2,0);

   //StartRec := -1;
   //NowRecCount := 0;
   if FileExists(FileName) Then
   Begin
      AFileSize := GetFileSize(FileName);
      if ((AFileSize mod SizeOf(TDatPackageFile))=0)
          and (AFileSize>0)Then
      Begin
        //Assignfile(f,FileName);
        //FileMode := 0;
        //Reset(f);
        //RecCount := FileSize(f);
        HaveExistData := True;
        //StartRec := RecCount;
        {While RecCount>0 Do
        Begin
          SetLength(Rec1,500);
          BlockRead(f,Rec1[0],500,GetCount);
          for i:=0 to GetCount-1 do
          Begin
             Inc(NowRecCount);
             if (Rec1[i].ID=ID) and (Rec1[i].EXG=EXG) Then
             Begin
                j := High(Rec2)+1;
                SetLength(Rec2,j+1);
                Rec2[j] := Rec1[i];
                if j=0 Then
                   StartRec := NowRecCount-1;
             End Else
             Begin
                if High(Rec2)>=0 Then
                Begin
                    RecCount := 0;
                    Break;
                End;
             End;
          End;
          RecCount := RecCount-GetCount;
          SetLength(Rec1,0);
        End;
        CloseFile(f);
        EndRec := StartRec+High(Rec2)+1;
        }
      End;

   End;

   //NeedSaveToFile := False;
   {for i:=0 to High(r) do
   Begin
      HaveTheSame := False;
      for j:=0 to High(Rec2) do
      Begin
        HaveTheSame :=RecDatIsTheSame(r[i],Rec2[j]);
        if HaveTheSame Then Break;
      end;
      If Not HaveTheSame Then
      Begin
          j := High(Rec2)+1;
          SetLength(Rec2,j+1);
          Rec2[j] := r[i];
          NeedSaveToFile := True;
      End;
   End;

   if Not NeedSaveToFile Then
      SetLength(Rec2,0);

   SortDatLst(Rec2);
   }
   //if High(Rec2)>=0 Then
   if High(r)>=0 Then
   Begin
     AssignFile(f,FileName);
     FileMode := 2;
     if HaveExistData Then
     Begin
        ReSet(f);
        //Seek(f,EndRec);
        Seek(f,FileSize(f));
        {if Not Eof(f) Then
        Begin
          GetCount := FileSize(f)-EndRec;
          RecCount := High(Rec2)+1;
          SetLength(Rec2,RecCount+GetCount);
          SetLength(Rec1,GetCount);
          BlockRead(f,Rec1[0],GetCount);
          For i:=RecCount to RecCount+GetCount-1 do
              Rec2[i] := Rec1[i-RecCount];

          SetLength(Rec1,0);
          Seek(f,StartRec);
          Truncate(f);
          Seek(f,FileSize(f));
        End;}
     End Else
        ReWrite(f);
     //BlockWrite(f,Rec2[0],High(Rec2)+1);
     BlockWrite(f,r[0],High(r)+1);
     CloseFile(f);
   End;




end;

function TPackageData.RecDatIsTheSame(const Dat1,
  Dat2: TDatPackageFile): Boolean;
begin

   Result := false;
   if (Dat1.ADat.vDATE=Dat2.ADat.vDATE)  and
      (Dat1.ADat.Flag=Dat2.ADat.flag)  and
      (Dat1.ADat.OPEN   = Dat2.ADat.OPEN)  and
      (Dat1.ADat.HIGH   = Dat2.ADat.HIGH)  and
      (Dat1.ADat.LOW    = Dat2.ADat.LOW)  and
      (Dat1.ADat.CLOSE  = Dat2.ADat.CLOSE)  and
      (Dat1.ADat.VOLUME = Dat2.ADat.VOLUME)  and
      (Dat1.ADat.AMOUNT = Dat2.ADat.AMOUNT)  and
      (Dat1.ADat.DE     = Dat2.ADat.DE)  and
      (Dat1.ADat.ROI    = Dat2.ADat.ROI)  and
      (Dat1.ADat.ROIB   = Dat2.ADat.ROIB)  and
      (Dat1.ADat.ROI_5  = Dat2.ADat.ROI_5)  and
      (Dat1.ADat.ROIB_5 = Dat2.ADat.ROIB_5)  and
      (Dat1.ADat.ROI_10 = Dat2.ADat.ROI_10)  and
      (Dat1.ADat.ROIB_10= Dat2.ADat.ROIB_10)  and
      (Dat1.ADat.ROI_20 = Dat2.ADat.ROI_20)  and
      (Dat1.ADat.ROIB_20= Dat2.ADat.ROIB_20)  Then
      Result := True;

end;

procedure TPackageData.SetFileNameList(const FileName: String);
Var
  j : Integer;
begin

     for j:=0 to High(FFileNameLst) do
        if FFileNameLst[j]=FileName Then Exit;

     j := High(FFileNameLst)+1;
     SetLength(FFileNameLst,j+1);
     FFileNameLst[j] := FileName;

end;


procedure TPackageData.SetCBPAFileNameList(const FileName: String);
Var
  j : Integer;
begin

     for j:=0 to High(FCBPAFileNameLst) do
        if FCBPAFileNameLst[j]=FileName Then Exit;

     j := High(FCBPAFileNameLst)+1;
     SetLength(FCBPAFileNameLst,j+1);
     FCBPAFileNameLst[j] := FileName;

end;

function TPackageData.GetFileName(const fileName: String): String;
Var
  Index : Integer;
  FileExt,fileName2 : String;
begin

   Result := FileName;
   if Not FileExists(FileName) Then exit;

   if GetFileSize(FileName)>MaxFileSize Then
   Begin
     Index := 1;
     FileName2 := ExtractFileName(FileName);
     FileExt   := ExtractFileExt(FileName);
     ReplaceSubString(FileExt,'',FileName2);
     Result := ExtractFilePath(FileName)+FileName2+'#'+IntToStr(Index)+FileExt;
     While FileExists(Result) and (GetFileSize(Result)>MaxFileSize) do
     Begin
        Inc(Index);
        Result := ExtractFilePath(FileName)+FileName2+'#'+IntToStr(Index)+FileExt;
     End;
   End;

end;

{ TDatPackageParam }

constructor TDatPackageParam.Create;
Var
 iniFile : TiniFile;
 i,Count : Integer;
 Str : String;
begin

   iniFile := TiniFile.Create(ExtractFilePath(Application.ExeName)+'Docdatpackage.ini');


   Count := inifile.ReadInteger('DataSource','Count',0);

   SetLength(FTr1DBPath,Count);
   SetLength(FDBPath,Count);
   SetLength(FTr1DBDataPath,Count);
   SetLength(FFTPPort,Count);
   SetLength(FFTPServer,Count);
   SetLength(FFTPUploadDir,Count);
   SetLength(FFTPUserName,Count);
   SetLength(FFTPPassword,Count);
   SetLength(FFTPPassive,Count);
   SetLength(FDataSource,Count);
   SetLength(FCharSet,Count);

   SetLength(FDailyDocFTPPort,Count);
   SetLength(FDailyDocFTPServer,Count);
   SetLength(FDailyDocFTPUploadDir,Count);
   SetLength(FDailyDocFTPUserName,Count);
   SetLength(FDailyDocFTPPassword,Count);
   SetLength(FDailyDocFTPPassive,Count);
   SetLength(FSaveDailyDocDays,Count);

   FSoundPort := StrToInt(inifile.ReadString('Setup','SoundPort','59'));
   FSoundServer := inifile.ReadString('Setup','SoundServer','LocalHost');

   for i:=0 to Count-1 do
   Begin

      Str :=  inifile.ReadString('DataSource',IntToStr(i+1),'');


      FDataSource[i] := Str;

      FCharSet[i] := inifile.ReadString(Str+'_Path','Charset','GB2312_CHARSET');

      FTr1DBPath[i] := inifile.ReadString(Str+'_Path','Tr1DBPath','');
      FDBPath[i] := inifile.ReadString(Str+'_Path','DBPath',ExtractFilePath(Application.ExeName));
      FTr1DBDataPath[i] := inifile.ReadString(Str+'_Path','Tr1DBDataPath','');


      FFTPPort[i] := StrToInt(inifile.ReadString(Str+'_FTP','Port','21'));
      FFTPServer[i] := inifile.ReadString(Str+'_FTP','Server','LocalHost');
      FFTPUploadDir[i] := inifile.ReadString(Str+'_FTP','UploadDir','');
      FFTPUserName[i]  := inifile.ReadString(Str+'_FTP','UserName','');
      FFTPPassword[i]  := inifile.ReadString(Str+'_FTP','Password','');
      FFTPPassive[i]   := IntToBool(StrToInt(inifile.ReadString(Str+'_FTP','Passive','1')));

      FDailyDocFTPPort[i] := StrToInt(inifile.ReadString(Str+'_DailyDoc_FTP','Port','21'));
      FDailyDocFTPServer[i] := inifile.ReadString(Str+'_DailyDoc_FTP','Server','LocalHost');
      FDailyDocFTPUploadDir[i] := inifile.ReadString(Str+'_DailyDoc_FTP','UploadDir','');
      FDailyDocFTPUserName[i]  := inifile.ReadString(Str+'_DailyDoc_FTP','UserName','');
      FDailyDocFTPPassword[i]  := inifile.ReadString(Str+'_DailyDoc_FTP','Password','');
      FDailyDocFTPPassive[i]   := IntToBool(StrToInt(inifile.ReadString(Str+'_DailyDoc_FTP','Passive','1')));

      FSaveDailyDocDays[i] := inifile.ReadInteger(Str+'_DailyDoc_FTP','SaveDailyDocDays',7);


      FTr1DBPath[i] := IncludeTrailingBackslash(FTr1DBPath[i]);
      FDBPath[i] := IncludeTrailingBackslash(FDBPath[i]);
      FTr1DBDataPath[i] := IncludeTrailingBackslash(FTr1DBDataPath[i]);

      //==========Doc4.2-N003-sun-20090922================================
      //每周、每月、每年 打包的具体时间点
      FDatPackageTime := inifile.ReadString('DatePackageSetup','PackCycTime','17:30:00');
      //=========================================================
   End;

   iniFile.Free;

end;

destructor TDatPackageParam.Destroy;
begin

  //inherited;
end;

function TDatPackageParam.GetCharSet(Index: Integer): String;
begin
   Result := FCharSet[Index];
end;

function TDatPackageParam.GetDataSource(Index: Integer): String;
begin
    Result := FDataSource[Index];
end;

function TDatPackageParam.GetDataSourceCount: Integer;
begin
 Result := High(FDataSource)+1;
end;

function TDatPackageParam.GetFDailyDocFTPPassive(Index: Integer): Boolean;
begin

   Result := FDailyDocFTPPassive[Index];

end;

function TDatPackageParam.GetFDailyDocFTPPassword(Index: Integer): String;
begin
   Result := FDailyDocFTPPassword[Index];
end;

function TDatPackageParam.GetFDailyDocFTPPort(Index: Integer): Integer;
begin
   Result := FDailyDocFTPPort[Index];
end;

function TDatPackageParam.GetFDailyDocFTPServer(Index: Integer): String;
begin
   Result := FDailyDocFTPServer[Index];
end;

function TDatPackageParam.GetFDailyDocFTPUploadDir(Index: Integer): String;
begin
   Result := FDailyDocFTPUploadDir[Index];
end;

function TDatPackageParam.GetFDailyDocFTPUserName(Index: Integer): String;
begin
   Result := FDailyDocFTPUserName[Index];
end;

function TDatPackageParam.GetFDBPath(Index: Integer): String;
begin
 Result := FDBPath[Index];
end;

function TDatPackageParam.GetFFTPPassive(Index: Integer): Boolean;
begin
 Result := FFTPPassive[Index];
end;

function TDatPackageParam.GetFFTPPassword(Index: Integer): String;
begin
 Result := FFTPPassword[Index];
end;

function TDatPackageParam.GetFFTPPort(Index: Integer): Integer;
begin
 Result := FFTPPort[Index];
end;

function TDatPackageParam.GetFFTPServer(Index: Integer): String;
begin
 Result := FFTPServer[Index];
end;

function TDatPackageParam.GetFFTPUploadDir(Index: Integer): String;
begin
 Result := FFTPUploadDir[Index];
end;

function TDatPackageParam.GetFFTPUserName(Index: Integer): String;
begin
 Result := FFTPUserName[Index];
end;

function TDatPackageParam.GetFTr1DBDataPath(Index: Integer): String;
begin
 Result := FTr1DBDataPath[Index];
end;

function TDatPackageParam.GetFTr1DBPath(Index: Integer): String;
begin
 Result := FTr1DBPath[Index];
end;

function TDatPackageParam.GetSaveDailyDocDays(Index: Integer): Integer;
begin
   Result := FSaveDailyDocDays[Index];
end;

function TDatPackageParam.OpenSetupFrom: boolean;
{
Var
  ASetupFrm : TADatPackageSetupFrm;
  inifile : TiniFile;
  }
begin
  {
    Result := false;
   //RCC
   ASetupFrm := TADatPackageSetupFrm.Create(nil);

   With ASetupFrm do
   Begin

        Txt_FTPPort.Text := IntToStr(FFTPPort);
        Txt_FTPServer.Text := FFTPServer;
        Txt_FTPUploadDir.Text := FFTPUploadDir;
        Txt_FtpUser.Text := FFTPUserName;
        Txt_FtpPass.Text := FFTPPassword;
        Chk_FtpPasv.Checked := FFTPPassive;

        Txt_Tr1DBPath.Text := FTr1DBPath;
        Txt_DBPath.Text := FDBPath;
        Txt_CBPAPath.Text := FTr1DBDataPath;
   End;

   if ASetupFrm.Open Then
   Begin

      With ASetupFrm do
      Begin

        FFTPPort := StrToInt(Txt_FTPPort.Text);
        FFTPServer := Txt_FTPServer.Text;
        FFTPUploadDir := Txt_FTPUploadDir.Text;
        FFTPUserName  := Txt_FtpUser.Text;
        FFTPPassword  := Txt_FtpPass.Text;
        FFTPPassive   := Chk_FtpPasv.Checked;


        FTr1DBPath := Txt_Tr1DBPath.Text;
        FDBPath := Txt_DBPath.Text;
        FTr1DBDataPath := Txt_CBPAPath.Text;

      End;

      inifile := TiniFile.Create(ExtractFilePath(Application.ExeName)+'Setup.ini');


      inifile.WriteString('PATH','Tr1DBPath', FTr1DBPath);
      inifile.WriteString('PATH','DBPath', FDBPath);
      inifile.WriteString('PATH','Tr1DBDataPath', FTr1DBDataPath);

      inifile.WriteString('FTP','Port',IntToStr(FFTPPort));
      inifile.WriteString('FTP','Server',FFTPServer);
      inifile.WriteString('FTP','UploadDir',FFTPUploadDir);
      inifile.WriteString('FTP','UserName',FFTPUserName);
      inifile.WriteString('FTP','Password',FFTPPassword);
      inifile.WriteString('FTP','Passive',IntToStr(BoolToInt(FFTPPassive)));

      inifile.free;

      Result := True;

   End;
   ASetupFrm.Free;

   }
end;

{ TPackageFileList }


constructor TPackageFileList.Create(const Filename: string);
begin

   Mkdir_Directory(ExtractFilePath(FileName));

   DeleteFile(FileName);
   FLogFile    := TIniFile.Create(FileName);
   FLogFile.WriteInteger('FileList','Count',0);

end;

destructor TPackageFileList.Destroy;
begin
  FLogFile.Free;
  //inherited;
end;

procedure TPackageFileList.SaveFileLog(const FileName: String);
Var
  FileSize : longword;
  FileDateTime  : TDateTime;
  Count : Integer;
begin
  if Not FileExists(FileName) Then Exit;
  FileSize     := GetFileSize(FileName);
  FileDateTime := FileDateToDateTime(FileAge(FileName));
  Count := FLogFile.ReadInteger('FileList','Count',0)+1;
  FLogFile.WriteInteger('FileList','Count',Count);
  FLogFile.WriteString('FileList',IntToStr(Count),ExtractFileName(FileName));
  FLogFile.WriteString(ExtractFileName(FileName),'Size',IntToStr(FileSize));
  FLogFile.WriteString(ExtractFileName(FileName),'DateTime',FloatToStr(FileDateTime));
end;

{ TPackageDoc }

constructor TPackageDoc.Create(AHandle: HWND; DocPath,
  OutDataPath: String;SaveDailyDocDays:Integer);
begin
   FHandle := AHandle;
   FDocPath   := DocPath;
   FHistoryDocPath := OutDataPath + HistoryDocPath;
   FSaveDailyDocDays := SaveDailyDocDays;
   FHaveFinishRunning  := False;
   FStopRunning := False;
   MkDir_Directory(FHistoryDocPath);
   FreeOnTerminate := false;
   inherited Create(true);
end;

destructor TPackageDoc.Destroy;
begin
  //inherited;
end;

procedure TPackageDoc.Execute;
begin
  //inherited;
  PackageDoc;
end;

function TPackageDoc.GetDocMemo(FileName: String): String;
Var
  Doc :TStringList;
begin
    FileName := ChangeFileExt(FileName,'.txt');
    if Not FileExists(FileName) Then Exit;
    Doc := TStringList.Create;
    Doc.LoadFromFile(FileName);
    Result := Doc.Text;
    Doc.Free;
end;

procedure TPackageDoc.MakeClearDocList;
Var    //by charles 20070123 增加制作Check.dat功能
  Str,IdxDocFile,SDate,EDate : String;
  f : TStringList;
  Lstf : TIniFile;
  ClearDocLstf : TIniFile;
  //by charle
  CheckDocLstf : TIniFile;

  IDLst : TStringList;
  i,j : Integer;
  DownLoadSection : Boolean;
  StrLst : _CStrLst;
begin
   f := TStringList.Create;
   IDLst := TStringList.Create;
   SDate := FormatDateTime('yyyymmdd',Date-FSaveDailyDocDays);
   EDate := FormatDateTime('yyyymmdd',Date);
Try
Try
   IdxDocFile := FDocPath+'StockDocIdxLst\StockDocIdxLst.dat';
   If Not FileExists(IdxDocFile) Then
      Exit;

   //先取出代碼
   f.LoadFromFile(IdxDocFile);
   for i:=0 to f.Count-1 do
   Begin
       Str := f.Strings[i];
       if (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
       Begin
          ReplaceSubString('[','',Str);
          ReplaceSubString(']','',Str);
          IDLst.Add(Str);
       End;
   End;

   ClearDocLstf := TIniFile.Create(ExtractFilePath(IdxDocFile)+'ClearFtpDocLst.dat');
   //by charles 2
   CheckDocLstf := TIniFile.Create(ExtractFilePath(IdxDocFile)+'CheckFtpDocLst.dat');

   for j:=0 to IDLst.Count-1 do
   Begin
       if FileExists(ExtractFilePath(IdxDocFile)+IDLst.Strings[j]+'_DOCLST.Dat') Then
       Begin
           DownLoadSection := False;
           f.Clear;
           f.LoadFromFile(ExtractFilePath(IdxDocFile)+IDLst.Strings[j]+'_DOCLST.Dat');
           Lstf := TIniFile.Create(ExtractFilePath(IdxDocFile)+IDLst.Strings[j]+'_DOCLST.Dat');

           for i:=0 to f.Count-1 do
           Begin
               Str := f.Strings[i];
               if Pos('[DownLoad]',Str)>0 Then
               Begin
                  DownLoadSection := True;
                  Continue;
               End;
               if DownLoadSection Then
               Begin
                   if Pos('.rtf=1',Str)>0 Then
                   Begin
                      StrLst := DoStrArray(Str,'_');
                      if High(StrLst)=2 Then
                      Begin
                         //只要不是這七天的範圍都是要刪除的
                         if Not ((SDate<=StrLst[1]) and (EDate>=StrLst[1])) Then
                         Begin
                            ReplaceSubString('=1','',Str);
                            Lstf.DeleteKey('DownLoad',Str);
                            ClearDocLstf.WriteString(StrLst[0],Str,'1');
                         End
                         //by charles 2
                         else begin
                             //生成Check.dat
                             ReplaceSubString('=1','',Str);
                             CheckDocLstf.WriteString(StrLst[0],Str,'1');
                         end;
                      End;
                   end;
               End;
           End;
           Lstf.Free;
       End;
   End;
  ClearDocLstf.Free;
  //by charles
  CheckDocLstf.Free;
  //先重新上傳清單
Except
End;
Finally
  f.Free;
  IDLst.Free;
End;
end;

procedure TPackageDoc.PackageDoc;
Var
  DocLstFile  : String;
  DocLstRec  : TStringList;
  i,j,t1,t2  : Integer;
  Str : String;
  AIDDoc : TADocPackageFile;
  ObjWM : TWMDatPackageString;
  PackageFileList : TPackageFileList;
begin
    DocLstFile := FDocPath+'doclst.dat';
try
try
    if Not FileExists(DocLstFile) Then
    Begin
       Raise Exception.Create('Can''t find file '+DocLstFile);
       Exit;
    End;

    Deltree(FHistoryDocPath,false,false);
    DocLstRec := TStringList.Create;
    DocLstRec.LoadFromFile(DocLstFile);
    For i:=0 to DocLstRec.Count-1 do
    Begin
        if Self.Terminated Then Exit;
        Str := DocLstRec.Strings[i];
        if (Pos('[',Str)>0) and (Pos(']',Str)>0) and (Pos(',',Str)=0)
           and (Pos('/',Str)=0) Then
        Begin
            //保存起來
            SaveToFile(AIDDoc);
            ReplaceSubString('[','',Str);
            ReplaceSubString(']','',Str);
            AIDDoc.ID := Str;
            SetLength(AIDDoc.DocLst,0);

            ObjWM.WMType := runMsg;
            ObjWM.WMString1 := AMainFrm.ConvertStr('打包 ')+ Str +AMainFrm.ConvertStr(' 公告信息.');
            SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
            Continue;
        End;
        if (Pos('=',Str)>0) and (Pos(',',Str)>0) and (Pos('/',Str)>0) Then
        Begin
            j := High(AIDDoc.DocLst)+1;
            SetLength(AIDDoc.DocLst,j+1);
            t1 := Pos('=',Str);
            t2 := Pos(',',Str);
            AIDDoc.DocLst[j].DocFileName  := Copy(Str,t1+1,t2-t1-1);
            t1 := t2;
            t2 := Pos('/',Str);
            AIDDoc.DocLst[j].DocCaption := Copy(Str,t1+1,t2-t1-1);
            t1 := t2;
            t2 := Length(Str);
            Try
              AIDDoc.DocLst[j].DocDate := StrToDate2(Copy(Str,t1+1,t2-t1));
            Except
              AIDDoc.DocLst[j].DocDate := -1;
            End;
        End;
    End;

    //保存起來
    SaveToFile(AIDDoc);
    DocLstRec.Free;
    if Self.Terminated Then Exit;

    PackageFileList :=
          TPackageFileList.Create(FHistoryDocPath+HistoryFileLst);
    for i:=0 to High(FFileNameLst) do
        PackageFileList.SaveFileLog(FFileNameLst[i]);
    PackageFileList.Destroy;

    //重新整理刪除需要的清單
    MakeClearDocList;

    ObjWM.WMType := runMsg;
    ObjWM.WMString1 := AMainFrm.ConvertStr('公告信息打包完成.');
    SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
    FHaveFinishRunning := True;
except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(PackageDoc)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     {
     //----------------------------
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新打包');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     PackageDoc;
     //------------------------------
     }
   End;
end;
finally
   FStopRunning := True;
end;

end;

procedure TPackageDoc.SaveToFile(AIDDoc: TADocPackageFile);
Var
   f : TextFile;
   PackageFile : TStringList;
   FileName : String;
   i : Integer;
   Year,Month,Day : Word;
   ObjWM : TWMDatPackageString;
begin
   if High(AIDDoc.DocLst)<0 Then Exit;
   PackageFile := TStringList.Create();
Try
Try
   For i:=0 to High(AIDDoc.DocLst) do
   Begin
      Application.ProcessMessages;
      Try
      if Self.Terminated Then Exit;
      ObjWM.WMType := runMsg;
      ObjWM.WMString1 := AMainFrm.ConvertStr('打包 ')+ AIDDoc.DocLst[i].DocCaption;
      SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

      DeCodeDate(AIDDoc.DocLst[i].DocDate,Year,Month,Day);

      fileName := format('%2s',[IntToStr(Month)]);
      ReplaceSubString(' ' ,'0',FileName);
      FileName := FHistoryDocPath+'_'+IntTostr(Year)+fileName+'.TXT';
      AssignFile(f,FileName);
      fileMode := 1;
      if FileExists(FileName) Then
         Append(f)
      Else
         ReWrite(f);
         //PackageFile.LoadFromFile(FileName);
      PackageFile.Add('<ID='+AIDDoc.ID+'>');
      PackageFile.Add('<FILENAME>');
      PackageFile.Add(ChangeFileExt(AIDDoc.DocLst[i].DocFileName,'.rtf'));
      PackageFile.Add('</FILENAME>');
      PackageFile.Add('<CAPTION>');
      PackageFile.Add(AIDDoc.DocLst[i].DocCaption);
      PackageFile.Add('</CAPTION>');
      PackageFile.Add('<DATE>');
      PackageFile.Add(FloatToStr(AIDDoc.DocLst[i].DocDate));
      PackageFile.Add('</DATE>');
      PackageFile.Add('<MEMO>');
      PackageFile.Add(GetDocMemo(FDocPath+AIDDoc.ID+'\'+AIDDoc.DocLst[i].DocFileName));
     // PackageFile.Add('</MEMO>');     //DatPackage2.0.0-leon-2009/4/21
     // PackageFile.Add('</ID>');        //DatPackage2.0.0-leon-2009/4/21

      Writeln(f,PackageFile.Text);

      Except
        On E:Exception do
        Begin
          ObjWM.WMType := runError;
          ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(SaveToFile ')+ AIDDoc.DocLst[i].DocFileName+AMainFrm.ConvertStr(')');
          SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
        End;
      End;
      Try
        CloseFile(f);
      Except
      End;

//DatPackage2.0.0-leon-2009/4/21
//------------------------------------------------------------------------------
      AssignFile(f,FileName);
      if not  FileExists(FileName) Then  exit;
      Append(f);
      Writeln(f,' ');
      Writeln(f,'</MEMO>');
      Writeln(f,'</ID>');

      Try
        CloseFile(f);
      Except
      End;
//------------------------------------------------------------------------------
      SetFileNameList(FileName);

      PackageFile.Clear;
      //PackageFile.SaveToFile(FileName);
   End;

Except
   On E:Exception do
   Begin
          ObjWM.WMType := runError;
          ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(SaveToFile ')+ AMainFrm.ConvertStr(')');
          SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
End;

Finally
   PackageFile.Free;
End;

end;

procedure TPackageDoc.SetFileNameList(const FileName: String);
Var
  j : Integer;
begin

     for j:=0 to High(FFileNameLst) do
        if FFileNameLst[j]=FileName Then Exit;

     j := High(FFileNameLst)+1;
     SetLength(FFileNameLst,j+1);
     FFileNameLst[j] := FileName;

end;

{ TPackageBase }

constructor TPackageBase.Create(AHandle: HWND; BasePath,
  OutDataPath: String;IDMgr:TStanderIDMgr);
begin
   FHandle := AHandle;
   FBasePath   := BasePath;
   FIDMgr := IDMgr;
   FHistoryBasePath := OutDataPath+HistoryBasePath;
   FHaveFinishRunning  := False;
   FStopRunning := False;
   MkDir_Directory(FHistoryBasePath);
   FreeOnTerminate := false;
   inherited Create(true);
end;

destructor TPackageBase.Destroy;
begin

  inherited;
end;

procedure TPackageBase.Execute;
begin
  //inherited;

  PackageBase;

end;

procedure TPackageBase.PackageBase;
Var
  ID : String;
  ObjWM : TWMDatPackageString;
  PackageFileList : TPackageFileList;
  FileLst : _CStrLst;
  i : Integer;
  FileName : String;
begin



try
try
   Deltree(FHistoryBasePath,true,false);

   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('正在打包财务数据.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   FolderAllFiles(FBasePath,'.BAS',FileLst);

   {
   if High(FileLst)<0 Then
   Begin
       Raise Exception.Create('无任何财务数据可打包');
       Exit;
   End;
   }

   for i:=0 to High(FileLst) do
   Begin
      FileName := FileLst[i];
      ID := ExtractFileName(FileName);
      ReplaceSubString('.BAS','',ID);
      if not PackageHistoryBase(ID,FileName) Then Exit;
      if Terminated Then Exit;
   end;

   if Terminated Then Exit;


   PackageFileList :=
          TPackageFileList.Create(FHistoryBasePath+HistoryFileLst);
   for i:=0 to High(FFileNameLst) do
        PackageFileList.SaveFileLog(FFileNameLst[i]);
   PackageFileList.Destroy;

   PackageFileList :=
          TPackageFileList.Create(FHistoryBasePath+'cbpa\'+HistoryFileLst);
   for i:=0 to High(FCBPAFileNameLst) do
        PackageFileList.SaveFileLog(FCBPAFileNameLst[i]);
   PackageFileList.Destroy;

   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('财务数据打包完成.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   FHaveFinishRunning := True;



except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(PackageBase)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     //----------------------------
{     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新打包');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     PackageBase;
     //------------------------------
     }
   End;
end;
finally


   FStopRunning := True;
   
end;

end;

function TPackageBase.PackageHistoryBase(const ID,
  FileName: String): Boolean;
Var
  r  : TTr1BasRecLst;
  f  : file of TTr1BasRec;
  i,y  : Word;
  NowYear,NowMonth,NowDay : Word;
  Year,Month,Day : Word;
  ObjWM : TWMDatPackageString;
begin

   Result := false;
   if Not FileExists(FileName) Then exit;

try
try

    Try
      if ((GetFileSize(FileName) mod SizeOf(TTr1BasRec))<>0) or (GetFileSize(FileName)=0) Then
      Begin
         ObjWM.WMType := runError;
         ObjWM.WMString1 := ExtractFileName(FileName) +AMainFrm.ConvertStr(' 档案格式错误');
         SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
         Exit;
      End;

    Except
    End;

    DecodeDate(Date,NowYear,NowMonth,NowDay);

    ObjWM.WMType := runMsg;
    ObjWM.WMString1 := AMainFrm.ConvertStr('打包 ') + ExtractFileName(FileName);
    SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

    Assignfile(f,FileName);
    FileMode := 0;
    Reset(f);
    Setlength(r,FileSize(f));
    BlockRead(f,r[0],High(r)+1);
    CloseFile(f);

    DeCodeDate(r[0].BaseDate,Year,Month,Day);
    DecodeDate(Date,NowYear,NowMonth,NowDay);

    for y:=Year to NowYear do
     for i:=1 to 12 do
         if Not SaveToMonth(ID,y,i,r) Then Exit;

    if Self.Terminated Then Exit;

    Result := true;

except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(PackageHistoryDat)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     {
     //----------------------------
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新打包');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     Result := PackageHistoryBase(ID,FileName);
     //------------------------------
     }
   End;
end;
finally
   if Result Then
   Begin
      //ObjWM.WMType := runMsg;
      //ObjWM.WMString1 := AMainFrm.ConvertStr('打包 ') + ExtractFileName(FileName) +AMainFrm.ConvertStr(' 完成.');
      //SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;

End;

procedure TPackageBase.SaveToFile(Const fileName:String;
                           r: Array of TBasePackageFile);
Var
  f  : file of TBasePackageFile;
  HaveExistData : Boolean;
  AFileSize : Integer;
begin


   HaveExistData := false;
   if FileExists(FileName) Then
   Begin
      AFileSize := GetFileSize(FileName);
      if ((AFileSize mod SizeOf(TBasePackageFile))=0)
          and (AFileSize>0)Then
        HaveExistData := True;
   End;

   if High(r)>=0 Then
   Begin
     AssignFile(f,FileName);
     FileMode := 2;
     if HaveExistData Then
     Begin
        ReSet(f);
        Seek(f,FileSize(f));
     End Else
        ReWrite(f);
     BlockWrite(f,r[0],High(r)+1);
     CloseFile(f);
   End;


end;

function TPackageBase.SaveToMonth(const ID: String; const Year,
  Month: Word; RecLst: TTr1BasRecLst): Boolean;
Var
  r  : Array of TBasePackageFile;
  i,j  : integer;
  NowYear,NowMonth,NowDay : Word;
  ObjWM : TWMDatPackageString;
  FileName : String;
begin

   Result := false;

try
try
   SetLength(r,0);

   for i:=0 to High(RecLst) do
   Begin
       if Self.Terminated Then Exit;
       DeCodeDate(RecLst[i].BaseDate,NowYear,NowMonth,NowDay);
       if (NowYear=Year) and (NowMonth=Month) Then
       Begin
          j := High(r)+1;
          SetLength(r,j+1);
          r[j].ID := ID;
          r[j].ABase := RecLst[i];
       End;
   End;

   fileName := format('%2s',[IntToStr(Month)]);
   ReplaceSubString(' ' ,'0',FileName);
   FileName := FHistoryBasePath+'_'+IntToStr(Year)+FileName+'.BAS';
   SaveToFile(fileName,r);
   SetFileNameList(FileName);

   if FIDMgr.IDExists(ID) Then
   Begin
      FileName := ExtractFilePath(FileName)+'cbpa\'+ExtractFileName(FileName);
      Mkdir_Directory(ExtractFilePath(FileName));
      SaveToFile(fileName,r);
      SetCBPAFileNameList(FileName);
   End;

   Result := True;

Except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(SaveToMonth)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;

Finally
   if Result Then
   Begin
     //ObjWM.WMType := runMsg;
     //ObjWM.WMString1 := AMainFrm.ConvertStr('完成打包 ') + IntToStr(Year)+AMainFrm.ConvertStr('年')+ IntToStr(Month)+ AMainFrm.ConvertStr('月的数据');
     //SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
   End;
end;


end;

procedure TPackageBase.SetCBPAFileNameList(const FileName: String);
Var
  j : Integer;
begin

     for j:=0 to High(FCBPAFileNameLst) do
        if FCBPAFileNameLst[j]=FileName Then Exit;

     j := High(FCBPAFileNameLst)+1;
     SetLength(FCBPAFileNameLst,j+1);
     FCBPAFileNameLst[j] := FileName;

end;

procedure TPackageBase.SetFileNameList(const FileName: String);
Var
  j : Integer;
begin

     for j:=0 to High(FFileNameLst) do
        if FFileNameLst[j]=FileName Then Exit;

     j := High(FFileNameLst)+1;
     SetLength(FFileNameLst,j+1);
     FFileNameLst[j] := FileName;


end;

{ TPackageID }

constructor TPackageID.Create(AHandle: HWND; IDPath, OutDataPath: String);
begin
   FHandle := AHandle;
   FIDPath := IDPath;
   FHistoryIDPath := OutDataPath+HistoryIDPath;
   FHaveFinishRunning  := False;
   FStopRunning := False;
   MkDir_Directory(FHistoryIDPath);
   FreeOnTerminate := false;
   inherited Create(true);
end;

destructor TPackageID.Destroy;
begin

  inherited;
end;

procedure TPackageID.Execute;
begin
  //inherited;

  PackageID;

end;

procedure TPackageID.PackageID;
Var
  ObjWM : TWMDatPackageString;
  PackageFileList : TPackageFileList;
  i : integer;
  FileLst : _CStrLst;
begin

try
try

   Deltree(FHistoryIDPath,false,false);

   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('正在将股票代码打包.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));

   FolderAllFiles(FIDPath,'.DAT',FileLst,False);

   if High(FileLst)<0 Then
   Begin
       Raise Exception.Create('无任何股票代码可打包');
       Exit;
   End;

   For i:=0 to High(FileLst) do
   Begin
       if Self.Terminated Then exit;
       CopyFile(PChar(FileLst[i]+''),PChar(FHistoryIDPath+ExtractFileName(FileLst[i])),False);
       if Not FileExists(FHistoryIDPath+ExtractFileName(FileLst[i])) Then
       Begin
           ObjWM.WMType := runError;
           ObjWM.WMString1 := AMainFrm.ConvertStr('档案打包失败 ') + ExtractFileName(FileLst[i]) + AMainFrm.ConvertStr('(PackageID)');
           SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
           Exit;
       End;
       SetFileNameList(FHistoryIDPath+ExtractFileName(FileLst[i]));
   End;


   if Self.Terminated Then exit;

   PackageFileList :=
          TPackageFileList.Create(FHistoryIDPath+HistoryFileLst);
   for i:=0 to High(FFileNameLst) do
        PackageFileList.SaveFileLog(FFileNameLst[i]);
   PackageFileList.Destroy;


   ObjWM.WMType := runMsg;
   ObjWM.WMString1 := AMainFrm.ConvertStr('股票代码打包完成.');
   SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));


   FHaveFinishRunning := True;


except
   On E:Exception do
   Begin
     ObjWM.WMType := runError;
     ObjWM.WMString1 := E.Message+AMainFrm.ConvertStr('(PackageID)');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     {
     //----------------------------
     ObjWM.WMType := runMsg;
     ObjWM.WMString1 := AMainFrm.ConvertStr('再一次尝试重新打包');
     SendMessage(FHandle,WM_DatPackageInfo,0,Integer(@ObjWM));
     PackageID;
     //------------------------------
     }
   End;
end;
finally
   FStopRunning := True;
end;

End;

procedure TPackageID.SetFileNameList(const FileName: String);
Var
  j : Integer;
begin

     for j:=0 to High(FFileNameLst) do
        if FFileNameLst[j]=FileName Then Exit;

     j := High(FFileNameLst)+1;
     SetLength(FFileNameLst,j+1);
     FFileNameLst[j] := FileName;

end;

{ TStanderIDMgr }

constructor TStanderIDMgr.Create(const Tr1DBDataPath: String);
begin
   FTr1DBDataPath := Tr1DBDataPath;
   InitData;
end;

destructor TStanderIDMgr.Destroy;
begin
  SetLength(FIDLst,0);
  //inherited;
end;

function TStanderIDMgr.IDExists(const ID: String): Boolean;
Var
  i : Integer;
begin

   Result := False;
   for i:=0 to High(FIDLst) do
      if FIDLst[i]=ID Then
      Begin
         Result := True;
         Break;
      End;

end;

procedure TStanderIDMgr.InitData;
Var
  i,j,t1,t2 : Integer;
  Str : String;
  fileLst : _cStrLst;
  FilePath : String;
  f : TStringList;
  StrLst : _CStrLst;
  bf : TextFile;
begin

    SetLength(StrLst,0);

    FilePath := FTr1DBDataPath + 'market_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);

    FilePath := FTr1DBDataPath + 'publish_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);

    f := TStringList.Create;

    if FileExists(ExtractFilePath(Application.ExeName)+'idlst.ini') Then
    Begin
        f.LoadFromFile(ExtractFilePath(Application.ExeName)+'idlst.ini');
        for i:=0 to f.Count-1 do
        Begin
           if Length(f.Strings[i])>0 Then
              SetAID(f.Strings[i]);
        End;
    End;
    f.Clear; 


    For i:=0 to High(fileLst) do
    Begin
       if FileExists(fileLst[i]) Then
       Begin
           //j := 0;
           f.Clear;
           f.LoadFromFile(fileLst[i]);
           for j:=0 to f.Count-1 do
           Begin
               Application.ProcessMessages;
               f.Strings[j] := UpperCase(f.Strings[j]);
               if Pos('TRADECODE=',f.Strings[j])>0 Then
               Begin
                   t1 := Pos('=',f.Strings[j]);
                   t2 := Length(f.Strings[j]);
                   Str := Copy(f.Strings[j],t1+1,t2-t1);
                   SetAID(Str);
               End;
               if Pos('STKCODE=',f.Strings[j])>0 Then
               Begin
                   t1 := Pos('=',f.Strings[j]);
                   t2 := Length(f.Strings[j]);
                   Str := Copy(f.Strings[j],t1+1,t2-t1);
                   SetAID(Str);
               End;
           End;
       End;
    End;
    f.Free;

   FilePath := FTr1DBDataPath + 'data\';
   if FileExists(FilePath+'bond.dat') Then
   Begin
      AssignFile(bf,FilePath+'bond.dat');
      FileMode := 0;
      Reset(bf);
      While Not Eof(bf) do
      Begin
       ReadLn(bf,str);
       Str := Trim(Str);
       if Length(Str)=0 Then Continue;
       StrLst := DoStrArray(Str,',');
       if High(StrLst)<>5 Then Continue;

       SetAID( StrLst[0]);
     End;
     CloseFile(bf);
   End;

    //SstIDDocStartDate;



end;

procedure TStanderIDMgr.SetAID(const ID: String);
Var
  i : Integer;
begin

   if Length(ID)=0 Then Exit;
   i := High(FIDLst)+1;
   SetLength(FIDLst,i+1);
   FIDLst[i] := ID;

end;

end.
