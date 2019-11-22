
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, IdIntercept, IdLogBase, IdLogDebug,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,csDef, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,IniFiles,TCommon,TDocMgr, ImgList,
  SocketClientFrm,TSocketClasses,uDisplayMsg,
  uLevelDataDefine,DateUtils, WinInet,UrlMon,ActiveX, Spin; //TWarningServer

const CAppTopic='DownIndustry';
      CAppTitle='DownIndustry';
      CAppWindow='DownIndustry_Window';
      CNa='na';
  NoneNum     = -999999999;
  ValueEmpty  = -888888888;

  _CDaiXia='0';
  _CXiaing='1';
  _CXiaOK='2';
  _CXiaFail='3';
  _CShen='4';
  _CNoNeedShen='5';
  _CNoCodeExists='6';

type
  TDaClassRec=record
    Items:array[0..3] of ShortString;
  end;
  TAryDaClassRec=array of TDaClassRec;
  
  TDim6Str=record
    Items:array[0..5] of string;
  end;
  TAryDim6Str=array of TDim6Str;

  TColSpanRec=record
    Level:integer;
    Caption:string;
    CaptionInit:string;
    ColSpan:integer;
    Flag:boolean;
  end;
  TColSpanRecLst = array of TColSpanRec;

  TFileDownLoadThread = class;
    TDownLoadProcessEvent = procedure(Sender:TFileDownLoadThread;Progress, ProgressMax:Cardinal;StatusCode: ULONG;StatusText:string) of object;
    TDownLoadCompleteEvent = procedure(Sender:TFileDownLoadThread) of object ;
    TDownLoadFailEvent = procedure(Sender:TFileDownLoadThread;Reason:LongInt) of object ;
    TDownLoadMonitor = class( TInterfacedObject, IBindStatusCallback )
    //TDownLoadMonitor = class( TObject, IBindStatusCallback )
    private
        FShouldAbort: Boolean;
        FThread:TFileDownLoadThread;
    protected
        function OnStartBinding( dwReserved: DWORD; pib: IBinding ): HResult; stdcall;
        function GetPriority( out nPriority ): HResult; stdcall;
        function OnLowResource( reserved: DWORD ): HResult; stdcall;
        function OnProgress( ulProgress, ulProgressMax, ulStatusCode: ULONG;
            szStatusText: LPCWSTR): HResult; stdcall;
        function OnStopBinding( hresult: HResult; szError: LPCWSTR ): HResult; stdcall;
        function GetBindInfo( out grfBINDF: DWORD; var bindinfo: TBindInfo ): HResult; stdcall;
        function OnDataAvailable( grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc;
            stgmed: PStgMedium ): HResult; stdcall;
        function OnObjectAvailable( const iid: TGUID; punk: IUnknown ): HResult; stdcall;
    public
        constructor Create(AThread:TFileDownLoadThread);
        property ShouldAbort: Boolean read FShouldAbort write FShouldAbort;
    end;
    TFileDownLoadThread = class( TThread )
    private
        FSourceURL: string;
        FSaveFileName: string;
        FProgress,FProgressMax:Cardinal;
        FStatusText:string;
        FStatusCode: ULONG;
        FOnProcess: TDownLoadProcessEvent;
        FOnComplete: TDownLoadCompleteEvent;
        FOnFail: TDownLoadFailEvent;
        FMonitor: TDownLoadMonitor;
        FFinish:Boolean;
    protected
        procedure Execute; override;
        procedure UpdateProgress(Progress, ProgressMax, StatusCode: Cardinal; StatusText:string);
        procedure DoUpdateUI;
    public
        constructor Create( ASrcURL, ASaveFileName: string; AProgressEvent:TDownLoadProcessEvent = nil;
          ACompleteEvent:TDownLoadCompleteEvent = nil;AFailEvent:TDownLoadFailEvent=nil;CreateSuspended: Boolean=False );
        property SourceURL: string read FSourceURL;
        property SaveFileName: string read FSaveFileName;
        property OnProcess: TDownLoadProcessEvent read FOnProcess write FOnProcess;
        property OnComplete: TDownLoadCompleteEvent read FOnComplete write FOnComplete;
        property OnFail: TDownLoadFailEvent read FOnFail write FOnFail;
        property Finish:Boolean Read FFinish;
    end;
    
  TAMainFrm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    btnGo: TBitBtn;
    btnStop: TBitBtn;
    IdAntiFreeze1: TIdAntiFreeze;
    LogDebug: TIdLogDebug;
    HTTP: TIdHTTP;
    Timer_StartGetDoc: TTimer;
    PanelCaption_URL: TPanel;
    ImageList1: TImageList;
    StatusBar2: TStatusBar;
    grpStockWeight: TGroupBox;
    lbl1: TLabel;
    seStockWeightYears: TSpinEdit;
    lbl2: TLabel;
    btnGoStokWeightHis: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure LogDebugLogItem(ASender: TComponent; var AText: String);

    procedure Timer_StartGetDocTime(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGoStokWeightHisClick(Sender: TObject);
  private
    FDataPath,FTrlDBPath,FRealTimePath : String;
    FLastDate,FUrl,FStatus,FLastDate2,FUrl2,FStatus2,FLastDate3,FUrl3,FStatus3,FLastDate2OfWeek,FStatus2OfWeek:string;
    FCompanyInfoDownWeekDay:integer;
    FLogFileName : String;
    FNowIsRunning: Boolean;
    StopRunning : Boolean;
    DisplayMsg : TDisplayMsg;
    AppParam : TDocMgrParam;
    FIDLstMgr:TStringList;

    FEndTick : DWord;
    FStartTime,FEndTime,FStartTime2,FEndTime2,FStartTime3,FEndTime3  :TTime;
    FstockweightHisMode:integer; FstockweightHisYears:Integer;
    FOKSleep,FFailSleep:integer;
    FForceDown,FForceDown3:boolean;//每次開啟程序時，或go的時候強制下載一次

    procedure SetNowIsRunning(const Value: Boolean);
    Procedure RefrsehTime(s:Integer);
    procedure DownLoadProcessEvent(  Sender: TFileDownLoadThread;
         Progress, ProgressMax: Cardinal;StatusCode: ULONG; StatusText: string);
    function DownloadFile2(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
  private
    { Private declarations }
    FDownTryTimes,FSleepWhenFrequence,FSleepPerStkCode:integer;
    FProxySrv:ShortString; FProxyPort:Integer;
    
    property NowIsRunning:Boolean Read FNowIsRunning Write SetNowIsRunning;
    function DataFile(aDate:string):string;
    function DataFile2(aDate:string):string;
    function DataFile2OfWeek():string;
    function Data2IsWeekDay():boolean;
    function DataFile3(aDate:string):string;

    function StartGet(aDate:string):Boolean;
    function StartGet2(aDate:string):Boolean;
    function StartGet2OfWeek(aDate:string):Boolean;
    function StartGet3(aDate:string):Boolean;
    Function _GetGuLiTitlesCount(MemoTxt:String;var FLastErrMsg:string;var iIdxStart:integer; var tsOutPut,tsOutPut2:TStringList):Integer;
    procedure SleepWait(Const Value:Double);
    procedure ShowRunBar(const Max,NowP:Integer;Const Msg:String);
    function InWorkTime:Boolean;
    function InWorkTime2:Boolean;
    function InWorkTime3:Boolean;
    //function MkDif(aDate:string):boolean;
    //function MkDif2(aDate:string):boolean;


    procedure HttpStatusEvent(ASender: TObject;AStatusText: string;aKey:string);
    procedure HttpBeginEvent(Sender: TObject;AWorkCountMax: Integer;aKey:string);
    procedure HttpEndEvent(Sender: TObject;aDoneOk:Boolean;aKey,aResult:string);
    procedure HttpWorkEvent(Sender: TObject; AWorkCount,AWorkMax: Integer;aKey:string);
    function GetHttpTextByUrl(aUrl:string; var aOutHtmlText,aErrStr:string):Boolean;
    procedure SaveWindowPos;
    procedure ReadWindowPos;
    procedure AppExcept(Sender: TObject; E: Exception);
    procedure ClearSysLog;

    function StkBaseLstFile:string;
    function StkBaseLstFileOfWeek:string;
    function StkBaseValueStatusCodeFromIni(aCode,aValue:string):boolean;
    function StkBaseValueStatusCodeFromIniOfWeek(aCode,aValue:string):boolean;
    function GetCodeList:boolean;
    function GetCodeListOfWeek:boolean;
  public
    { Public declarations }
    procedure InitObj();
    procedure ShowURL(const msg:String);
    procedure ShowMsgEx(const Msg:String;aConvert:boolean=true);
    procedure ShowMsg(const Msg:String;aConvert:boolean=true);
    procedure SaveMsg(const Msg:String;aConvert:boolean=true);
    procedure ShowSb(aIndex:integer;amsg:String);
    procedure Start();
    procedure Stop();
    procedure InitForm();
    function SetLastDate(aDate,aStatus:String):boolean;
    function SetLastDate2(aDate,aStatus:String):boolean;
    function SetLastDate2OfWeek(aDate,aStatus:String):boolean;
    function SetLastDate3(aDate,aStatus:String):boolean;
    function SetWarnMsg3(aWarnMsg:String):boolean;
    function ReadLastDate():boolean;
    function ReadLastDate2():boolean;
    function ReadLastDate2OfWeek():boolean;
    function ReadLastDate3():boolean;
    function ReadWarnMsg3():string;
  end;

var
  AMainFrm: TAMainFrm;
  GDebug:Boolean=false;
implementation

{$R *.dfm}


function MayBeDigital(sVar:string):boolean;
var i:integer;
begin
  result:=false;
  sVar:=Trim(sVar);
    if sVar='' then exit;
    if sVar='-' then exit;
    for i:=1 to Length(sVar) do
    begin
      if not (sVar[i] in ['0'..'9', '.','-', #08]) then
      begin
        exit;
      end;
    end;
    result:=true;
end;

function CFSEx(sVar:string):double;
var i:integer;
  begin
    result := NoneNum;
    sVar:=StringReplace(sVar,',','',[rfReplaceAll]);
    sVar:=StringReplace(sVar,'，','',[rfReplaceAll]);
    sVar:=trim(sVar);
    if sVar='-' then
      sVar:='';
    if Trim(sVar)='' then
    begin
      result:=ValueEmpty;
      exit;
    end;
    if not MayBeDigital(sVar) then exit;
    try
      result := StrToFloat(Trim(sVar));
    except
      result := NoneNum;
    end;
  end;
  
{TDownLoadMonitor}
constructor TDownLoadMonitor.Create(AThread: TFileDownLoadThread);
begin
    inherited Create;
    FThread:=AThread;
    FShouldAbort:=False;
end;

function TDownLoadMonitor.GetBindInfo( out grfBINDF: DWORD; var bindinfo: TBindInfo ): HResult;
begin
    result := S_OK;
end;

function TDownLoadMonitor.GetPriority( out nPriority ): HResult;
begin
    Result := S_OK;
end;

function TDownLoadMonitor.OnDataAvailable( grfBSCF, dwSize: DWORD; formatetc: PFormatEtc; stgmed: PStgMedium ): HResult;
begin
    Result := S_OK;
end;

function TDownLoadMonitor.OnLowResource( reserved: DWORD ): HResult;
begin
    Result := S_OK;
end;

function TDownLoadMonitor.OnObjectAvailable( const iid: TGUID; punk: IInterface ): HResult;
begin
    Result := S_OK;
end;

function TDownLoadMonitor.OnProgress( ulProgress, ulProgressMax, ulStatusCode: ULONG; szStatusText: LPCWSTR ): HResult;
begin
    if FThread<>nil then
        FThread.UpdateProgress(ulProgress,ulProgressMax,ulStatusCode,szStatusText);
    if FShouldAbort then
        Result := E_ABORT
    else
        Result := S_OK;
end;

function TDownLoadMonitor.OnStartBinding( dwReserved: DWORD; pib: IBinding ): HResult;
begin
    Result := S_OK;
end;

function TDownLoadMonitor.OnStopBinding( hresult: HResult; szError: LPCWSTR ): HResult;
begin
    Result := S_OK;
end;
{ TFileDownLoadThread }
constructor TFileDownLoadThread.Create( ASrcURL, ASaveFileName: string;AProgressEvent:TDownLoadProcessEvent ;
          ACompleteEvent:TDownLoadCompleteEvent;AFailEvent:TDownLoadFailEvent; CreateSuspended: Boolean );
begin
    if (@AProgressEvent=nil) or (@ACompleteEvent=nil) or (@AFailEvent=nil) then
        CreateSuspended:=True;
    inherited Create( CreateSuspended );
    FSourceURL:=ASrcURL;
    FSaveFileName:=ASaveFileName;
    FOnProcess:=AProgressEvent;
    FOnComplete:=ACompleteEvent;
    FOnFail:=AFailEvent;
    FFinish := false;
end;

procedure TFileDownLoadThread.DoUpdateUI;
begin
     if Assigned(FOnProcess) then
        FOnProcess(Self,FProgress,FProgressMax,FStatusCode, FStatusText);
end;

procedure TFileDownLoadThread.Execute;
var
    DownRet:HRESULT;
begin
    inherited;
    FFinish := false;
    FMonitor:=TDownLoadMonitor.Create(Self);
    DownRet:= URLDownloadToFile( nil, PAnsiChar( FSourceURL ), PAnsiChar( FSaveFileName ), 0,FMonitor as IBindStatusCallback);
    FFinish := true;
    if DownRet=S_OK then
    begin
        if Assigned(FOnComplete) then
            FOnComplete(Self);
    end
    else
    begin
        if Assigned(FOnFail) then
            FOnFail(Self,DownRet);
    end;
    FMonitor:=nil;
end;

procedure TFileDownLoadThread.UpdateProgress(Progress, ProgressMax, StatusCode: Cardinal; StatusText: string);
begin
    FProgress:=Progress;
    FProgressMax:=ProgressMax;
    FStatusText:=StatusText;
    FStatusCode:=StatusCode;
    Synchronize(DoUpdateUI);
    if Terminated then
    FMonitor.ShouldAbort:=True;
end;

//-----------------------------------------------------------------------------

procedure SwapTDim6Str(var aRec1,aRec2:TDim6Str);
var i:integer; aTempR:TDim6Str;
begin
  for i:=0 to High(aTempR.Items) do
   aTempR.Items[i]:=aRec1.Items[i];
  for i:=0 to High(aTempR.Items) do
   aRec1.Items[i]:=aRec2.Items[i];
  for i:=0 to High(aTempR.Items) do
   aRec2.Items[i]:=aTempR.Items[i];
end;

function DelDatF(aDatF:ShortString):boolean;
var i:integer;
begin
  result := false;
  for i:=1 to 5 do
  begin
    if FileExists(aDatF) then
    begin
      if DeleteFile(aDatF) then
      begin
        result := true;
        exit;
      end;
    end
    else begin
      result := true;
      exit;
    end;

    Sleep(500);
  end;
end;

function CpyDatF(aDatFS,aDatFD:ShortString):boolean;
var i:integer;
begin
  result := false;
  if not FileExists(aDatFS) then
  begin
    result := true;
    exit;
  end;
  for i:=1 to 5 do
  begin
    if CopyFile(PChar(String(aDatFS)),PChar(String(aDatFD)),false ) then
    if FileExists(aDatFD) then
    begin
      result := true;
      exit;
    end;
    Sleep(500);
  end;
end;

function IsRightStock(aCode:string):Boolean;
  var sCode1_5,sCode2_4:string; iLen,iTemp:integer;
  begin
    Result := False;
    iLen := Length(aCode);
    if iLen=6 then
    begin
      if (aCode[1]='7') then
      begin
        if (aCode[6] in ['0'..'9']) then
        begin
          if TryStrToInt(aCode,iTemp) then
          begin
            result := ( iTemp>=700001) and
                      ( iTemp<=734999);
          end;
        end
        else if (aCode[6] in ['P','p','F','f','Q','q'])  then
        begin
          sCode1_5 := copy(aCode,1,5);
          if TryStrToInt(sCode1_5,iTemp) then
          begin
            result := ( iTemp>=70001) and
                      ( iTemp<=73499);
          end;
        end;
      end
      else if (aCode[1]='0') then begin
        if (aCode[6] in ['0'..'9']) then
        begin
          if TryStrToInt(aCode,iTemp) then
          begin
            result := ( iTemp>=30001) and
                      ( iTemp<=89999);
          end;
        end
        else if (aCode[6] in ['P','p','F','f','Q','q','b','B','c','C'] )  then
        begin
          sCode2_4 := copy(aCode,2,4);
          if TryStrToInt(sCode2_4,iTemp) then
          begin
            result := ( iTemp>=3001) and
                      ( iTemp<=8999);
          end;
        end;
      end;

    end;
  end;

function FmtDt8(aDate:TDate):string;
begin
  result:=FormatDateTime('yyyymmdd',Adate);
end;

function FmtTwDt2(aDate:TDate):string;
var aTwYear:integer;
begin
  if aDate<=1 then
  begin
    result:='';
    Exit;
  end;
  result:=FormatDateTime('yyyy/mm/dd',aDate);
  aTwYear:=YearOf(aDate)-1911;
  result:=IntToStr(aTwYear)+copy(result,5,Length(result));
end;

{TAMainFrm}

function TAMainFrm.SetLastDate(aDate,aStatus:String):boolean;
var inifile:Tinifile; sPath:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  inifile.WriteString(CAppTopic,'LastDate',aDate);
  inifile.WriteString(CAppTopic,'Status',aStatus);
  FLastDate:=aDate;
  FStatus:=aStatus;
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;

function TAMainFrm.SetLastDate2(aDate,aStatus:String):boolean;
var inifile:Tinifile; sPath:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  inifile.WriteString(CAppTopic,'LastDate2',aDate);
  inifile.WriteString(CAppTopic,'Status2',aStatus);
  FLastDate2:=aDate;
  FStatus2:=aStatus;
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;

function TAMainFrm.SetLastDate2OfWeek(aDate,aStatus:String):boolean;
var inifile:Tinifile; sPath:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  inifile.WriteString(CAppTopic,'LastDate2OfWeek',aDate);
  inifile.WriteString(CAppTopic,'Status2OfWeek',aStatus);
  FLastDate2OfWeek:=aDate;
  FStatus2OfWeek:=aStatus;
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;

function TAMainFrm.SetLastDate3(aDate,aStatus:String):boolean;
var inifile:Tinifile; sPath:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  inifile.WriteString(CAppTopic,'LastDate3',aDate);
  inifile.WriteString(CAppTopic,'Status3',aStatus);
  FLastDate3:=aDate;
  FStatus3:=aStatus;
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;

function TAMainFrm.SetWarnMsg3(aWarnMsg:String):boolean;
var inifile:Tinifile; sPath:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  inifile.WriteString(CAppTopic,'WarnMsg3',aWarnMsg);
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;

function TAMainFrm.ReadLastDate():boolean;
var inifile:Tinifile; sPath:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  FLastDate:=inifile.ReadString(CAppTopic,'LastDate','');
  FStatus:=inifile.ReadString(CAppTopic,'Status','0');
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;

function TAMainFrm.ReadLastDate2():boolean;
var inifile:Tinifile; sPath:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  FLastDate2:=inifile.ReadString(CAppTopic,'LastDate2','');
  FStatus2:=inifile.ReadString(CAppTopic,'Status2','0');
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;

function TAMainFrm.ReadLastDate2OfWeek():boolean;
var inifile:Tinifile; sPath:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  FLastDate2OfWeek:=inifile.ReadString(CAppTopic,'LastDate2OfWeek','');
  FStatus2OfWeek:=inifile.ReadString(CAppTopic,'Status2OfWeek','0');
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;

function TAMainFrm.ReadLastDate3():boolean;
var inifile:Tinifile; sPath:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  FLastDate3:=inifile.ReadString(CAppTopic,'LastDate3','');
  FStatus3:=inifile.ReadString(CAppTopic,'Status3','0');
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;

function TAMainFrm.ReadWarnMsg3():string;
var inifile:Tinifile; sPath:string;
begin
  result:='';
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  result:=inifile.ReadString(CAppTopic,'WarnMsg3','');
finally
  FreeAndNil(inifile);
end;
end;

function SetProcessProxy(const aProxyServer: string; const aProxyPort: Integer): Boolean;
var
  vProxyInfo: TInternetProxyInfo;
begin
  vProxyInfo.dwAccessType := INTERNET_OPEN_TYPE_PROXY;
  vProxyInfo.lpszProxy := PChar(Format('http=%s:%d', [aProxyServer, aProxyPort]));
  vProxyInfo.lpszProxyBypass := PChar('');
  Result := UrlMkSetSessionOption(INTERNET_OPTION_PROXY, @vProxyInfo, SizeOf(vProxyInfo),0) = S_OK;
end;

procedure TAMainFrm.InitForm;
var inifile:Tinifile; sPath:string; b:boolean; i:integer;
begin
  sPath:=ExtractFilePath(Application.ExeName);
  AppParam := TDocMgrParam.Create;
  Caption := AppParam.TwConvertStr(CAppTitle);
  FDataPath := sPath+'Data\Industry\';
  Mkdir_Directory(FDataPath);
  FLastDate := '0'; FStatus:='0';
  FLastDate2 := '0'; FStatus2:='0';    FLastDate2OfWeek := '0'; FStatus2OfWeek:='0';  FCompanyInfoDownWeekDay:=0;
  FLastDate3 := '0'; FStatus3:='0';
  FLogFileName := CAppTopic;

  FEndTick := GetTickCount + Round(1000);
  Timer_StartGetDoc.Enabled := True;
  NowIsRunning := false;
  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;

  i:=YearOf(date);
  seStockWeightYears.Value:=i;
  Self.caption:='=down=';

  inifile:=Tinifile.Create(sPath+'setup.ini');
  GDebug :=inifile.ReadBool(CAppTopic,'debug',false);
  FStartTime :=StrToTime(inifile.ReadString(CAppTopic,'StartTime','7:00:00'));
  FEndTime :=StrToTime(inifile.ReadString(CAppTopic,'EndTime','17:30:00'));
  FStartTime2 :=StrToTime(inifile.ReadString(CAppTopic,'StartTime2','7:00:00'));
  FEndTime2 :=StrToTime(inifile.ReadString(CAppTopic,'EndTime2','17:30:00'));
  FStartTime3 :=StrToTime(inifile.ReadString(CAppTopic,'StartTime3','7:00:00'));
  FEndTime3 :=StrToTime(inifile.ReadString(CAppTopic,'EndTime3','17:30:00'));
  FOKSleep :=inifile.ReadInteger(CAppTopic,'OkSleep',180);
  FFailSleep :=inifile.ReadInteger(CAppTopic,'FailSleep',5);
  FUrl:=inifile.ReadString(CAppTopic,'Url','');
  FLastDate :=inifile.ReadString(CAppTopic,'LastDate','');
  FStatus :=inifile.ReadString(CAppTopic,'Status','0');
  FUrl2:=inifile.ReadString(CAppTopic,'Url2','');
  FLastDate2 :=inifile.ReadString(CAppTopic,'LastDate2','');
  FStatus2 :=inifile.ReadString(CAppTopic,'Status2','0');
  FLastDate2OfWeek :=inifile.ReadString(CAppTopic,'LastDate2OfWeek','');
  FStatus2OfWeek :=inifile.ReadString(CAppTopic,'Status2OfWeek','0');
  FCompanyInfoDownWeekDay :=inifile.ReadInteger(CAppTopic,'CompanyInfoDownWeekDay',0);
  FUrl3:=inifile.ReadString(CAppTopic,'Url3','');
  FLastDate3 :=inifile.ReadString(CAppTopic,'LastDate3','');
  FStatus3 :=inifile.ReadString(CAppTopic,'Status3','0');

  FTrlDBPath:=inifile.ReadString('CONFIG','TR1DBPath','');
  FRealTimePath:=inifile.ReadString('CONFIG','RealTimePath','');

  FDownTryTimes:=inifile.ReadInteger('DownIndustry','DownTryTimes',3);
  FSleepWhenFrequence:=inifile.ReadInteger('DownIndustry','SleepWhenFrequence',30);
  FSleepPerStkCode:=inifile.ReadInteger('DownIndustry','SleepPerStkCode',5);

  FProxySrv:= inifile.ReadString('DownIFRS','ProxySrv','');
  FProxyPort:= inifile.ReadInteger('DownIFRS','ProxyPort',808);
  if FProxySrv<>'' then
  begin
    b:=false;
    for i:=1 to 3 do
    begin
      if SetProcessProxy(FProxySrv,FProxyPort) then
      begin
        b:=true;
        break;
      end;
    end;
    if not b then
    begin
      ShowMessage(AppParam.TwConvertStr(Format('代理設定失敗.(%s:%d)',[FProxySrv,FProxyPort])));
    end;
  end;
  
  inifile.Free;
end;

procedure TAMainFrm.AppExcept(Sender: TObject; E: Exception);
begin
  if Pos('pointer',e.Message)>0 then
  begin
    SaveMsg('     ');
  end
  else
  SaveMsg('(AppExcept)'+e.Message);
end;

procedure TAMainFrm.FormCreate(Sender: TObject);
begin
   FForceDown := false;
   FForceDown3 := false;
   FstockweightHisMode:=0;
   FstockweightHisYears:=0;
   
   ReadWindowPos;
   Application.OnException := AppExcept;
   InitForm;
   InitObj;
   ClearSysLog;
   BtnGo.Click;
end;

procedure TAMainFrm.Start;
begin
   StopRunning  := False;
   NowIsRunning := True;
   RefrsehTime(1);
   Timer_StartGetDoc.Interval := 1000;
end;

procedure TAMainFrm.SetNowIsRunning(const Value: Boolean);
begin
   FNowIsRunning := Value;
   btnGo.Enabled := Not Value;
   btnGoStokWeightHis.Enabled := Not Value;
   seStockWeightYears.Enabled := Not Value;
   
   btnStop.Enabled := Value;
   if Value Then
      Screen.Cursor := crHourGlass
   Else Begin
      Screen.Cursor := crDefault;
      ShowMsg('');
   End;
end;

procedure TAMainFrm.btnGoClick(Sender: TObject);
begin
   FstockweightHisMode:=0;
   FstockweightHisYears:=0;
   FForceDown := false;
   Start;
end;

procedure TAMainFrm.btnGoStokWeightHisClick(Sender: TObject);
begin
   FstockweightHisMode:=1;
   FstockweightHisYears:=seStockWeightYears.value;
   FForceDown := false;
   FForceDown3 := true;
   FLastDate3:=FmtDt8(date-1);
   FStatus3:=_CDaiXia;
   SetLastDate3(FLastDate3,FStatus3);
   Start;
end;


procedure TAMainFrm.Stop;
begin
   StopRunning  := True;
   try
      //Http.DisconnectSocket;
   Except
   end;
end;

procedure TAMainFrm.btnStopClick(Sender: TObject);
begin
  Stop;
end;

procedure TAMainFrm.ShowMsgEx(const Msg:String;aConvert:boolean=true);
begin
  ShowMsg(Msg,aConvert);
  SaveMsg(Msg,aConvert);
end;

procedure TAMainFrm.ShowMsg(const Msg: String;aConvert:boolean=true);
begin
    if DisplayMsg<>nil Then
    begin
      if aConvert then DisplayMsg.AddMsg(AppParam.TwConvertStr(Msg))
      else DisplayMsg.AddMsg(Msg);
    end;
end;

procedure TAMainFrm.LogDebugLogItem(ASender: TComponent;
  var AText: String);
begin
   Application.ProcessMessages;
end;


procedure TAMainFrm.Timer_StartGetDocTime(Sender: TObject);
const
  _CDaiXia='0';
  _CXiaing='1';
  _CXiaOK='2';
  _CXiaFail='3';
  _CShen='4';

  _CStrDaiXia='待下載';
  _CStrXiaing='下載中';
  _CStrXiaOK='下載成功';
  _CStrXiaFail='下載失敗';
  _CStrShen='已保存';
  _CTodayD='今日數據--';

Var aDate,sOneFile:STring;  b1,b2,b2OfWeek,bOk,b3,b4,b5,b6:Boolean;

   function Status2StrSub(aInput:string):string;
   begin
     result:='';
     if aInput=_CDaiXia then
       Result:=_CStrDaiXia
     else if aInput=_CXiaing then
       Result:=_CStrXiaing
     else if aInput=_CXiaOK then
       Result:=_CStrXiaOK
     else if aInput=_CXiaFail then
       Result:=_CStrXiaFail
     else if aInput=_CShen then
       Result:=_CStrShen;
   end;

   function Str2StatusOfIni(aDate,aStatus:string):string;
      function Status2StrSub(aInput:string):string;
       begin
         result:='';
         if aInput=_CDaiXia then
           Result:=_CTodayD+_CStrDaiXia
         else if aInput=_CXiaing then
           Result:=_CTodayD+_CStrXiaing
         else if aInput=_CXiaOK then
           Result:=_CTodayD+_CStrXiaOK
         else if aInput=_CXiaFail then
           Result:=_CTodayD+_CStrXiaFail
         else if aInput=_CShen then
           Result:=_CTodayD+_CStrShen;
       end;
  
    var sNowDt:string;
    begin
      result:=_CTodayD+_CStrDaiXia;
      sNowDt:=FmtDt8(now);
      if sNowDt<>aDate then
      begin
        Exit;
      end;
      result:=Status2StrSub(aStatus);
    end;

   function Status2IsOk(aInput:string):boolean;
   begin
     result:=false;
     if (aInput=_CXiaOK) or
        (aInput=_CShen) then
       Result:=True;
   end;
begin
   Timer_StartGetDoc.Enabled := False;
try
Try
   if GetTickCount >= FEndTick Then
   Begin
     aDate:=FmtDt8(date);
     if NowIsRunning Then
     Begin
           if not (ReadLastDate and ReadLastDate2 and ReadLastDate3)  then
           begin
             ShowMsgEx('從setup.ini中讀取狀態信息失敗');
             RefrsehTime(FFailSleep);
             exit;
           end;
           
           bOk:=true;
           b1:=( InWorkTime and
                 ( (FLastDate<>aDate) or (not Status2IsOk(FStatus))
                 )
               )
               or FForceDown;
           b2:=( InWorkTime2 and
                 ((FLastDate2<>aDate) or (not Status2IsOk(FStatus2))
                 )
               )
               or FForceDown;
           b5:=( InWorkTime3 and
                 ((FLastDate3<>aDate) or (not Status2IsOk(FStatus3))
                 )
               )
               or FForceDown or FForceDown3;

           b2OfWeek:=( InWorkTime2 and  Data2IsWeekDay and 
                 ((FLastDate2OfWeek<>aDate) or (not Status2IsOk(FStatus2OfWeek))
                 )
               );
           if b5 Then
           begin
               if (FLastDate3<>aDate) then
               begin
                 sOneFile:=DataFile3(FmtDt8(date));
                 DelDatF(sOneFile);

                 sOneFile:=ChangeFileExt(sOneFile,aDate+ExtractFileExt(sOneFile));
                 DelDatF(sOneFile);
               end;
               
               SetLastDate3(aDate,_CDaiXia);
               try
                 b6:=false;
                 SetLastDate3(aDate,_CXiaing);
                 b6:=StartGet3(aDate);
                 if b6 Then
                 Begin
                    SetLastDate3(aDate,_CXiaOK);
                    FForceDown := false;
                    FForceDown3 := false;
                 End
                 else  begin
                   bOk:=false;
                 end;
               finally
                 if not b6 then SetLastDate3(aDate,_CXiaFail);
               end;
           End;
           
           if b1 Then
           begin
               SetLastDate(aDate,_CDaiXia);
               try
                 b3:=false;
                 SetLastDate(aDate,_CXiaing);
                 b3:=StartGet(aDate);
                 if b3 Then
                 Begin
                    SetLastDate(aDate,_CXiaOK);
                    FForceDown := false;
                 End
                 else  begin
                   bOk:=false;
                 end;
               finally
                 if not b3 then SetLastDate(aDate,_CXiaFail);
               end;
           End;

           if b2 Then
           begin
               if (FLastDate2<>aDate) then
               begin
                 sOneFile:=StkBaseLstFile;
                 DelDatF(sOneFile);
                 
                 sOneFile:=DataFile2(FmtDt8(date));
                 DelDatF(sOneFile);
                 sOneFile:=ChangeFileExt(sOneFile,'.tmp');
                 DelDatF(sOneFile);
               end;
               
               SetLastDate2(aDate,_CDaiXia);
               try
                 b4:=false;
                 SetLastDate2(aDate,_CXiaing);
                 b4:=StartGet2(aDate);
                 if b4 Then
                 Begin
                    SetLastDate2(aDate,_CXiaOK);
                    FForceDown := false;
                 End
                 else  begin
                   bOk:=false;
                 end;
               finally
                 if not b4 then SetLastDate2(aDate,_CXiaFail);
               end;
           End;

           if b2OfWeek Then
           begin
               if (FLastDate2OfWeek<>aDate) then
               begin
                 sOneFile:=StkBaseLstFileOfWeek;
                 DelDatF(sOneFile);
                 if not DirectoryExists(ExtractFilePath(sOneFile)) then
                   Mkdir_Directory(ExtractFilePath(sOneFile));
                 
                 sOneFile:=DataFile2OfWeek();
                 DelDatF(sOneFile);
                 sOneFile:=ChangeFileExt(sOneFile,'.tmp');
                 DelDatF(sOneFile);
                 if not DirectoryExists(ExtractFilePath(sOneFile)) then
                   Mkdir_Directory(ExtractFilePath(sOneFile));
               end;
               
               SetLastDate2OfWeek(aDate,_CDaiXia);
               try
                 b4:=false;
                 SetLastDate2OfWeek(aDate,_CXiaing);
                 b4:=StartGet2OfWeek(aDate);
                 if b4 Then
                 Begin
                    SetLastDate2OfWeek(aDate,_CXiaOK);
                 End
                 else  begin
                   bOk:=false;
                 end;
               finally
                 if not b4 then SetLastDate2OfWeek(aDate,_CXiaFail);
               end;
           End;

           ShowMsgEx( '(產業鏈'+Str2StatusOfIni(FLastDate,FStatus)+')'+
                      '(公司基本資料'+Str2StatusOfIni(FLastDate2,FStatus2)+')'+',每週'+Str2StatusOfIni(FLastDate2OfWeek,FStatus2OfWeek)+')'+
                      '(股利分配資料'+Str2StatusOfIni(FLastDate3,FStatus3)+')');
           if bOk then
           begin
             RefrsehTime(FOKSleep);
           end
           else begin
             RefrsehTime(FFailSleep);
             exit;
           end;
     End;
   End;
Except
  on E:Exception do
  Begin
     RefrsehTime(FFailSleep);
     ShowMsg('Timer_StartGetDocTime:'+e.Message,false);
     SaveMsg('Timer_StartGetDocTime:'+e.Message,false);
  End;
end;
Finally
   ShowRunBar(0,0,'');
   if StopRunning Then
      NowIsRunning := False;
   Timer_StartGetDoc.Enabled := True;
End;
end;


procedure TAMainFrm.InitObj;
var sFile:string;
begin
   DisplayMsg := TDisplayMsg.Create(Label1,FLogFileName);
   FIDLstMgr := TStringList.Create;
end;

procedure TAMainFrm.ShowURL(const msg: String);
begin
  SaveMsg(Msg);
  PanelCaption_URL.Caption := msg;
  Application.ProcessMessages;
end;

procedure TAMainFrm.ShowRunBar(const Max, NowP: Integer;const Msg: String);
begin
  ProgressBar1.Max := Max;
  ProgressBar1.Min := 0;
  ProgressBar1.Position := NowP;
  StatusBar1.Panels[1].Text := Msg;
end;


procedure TAMainFrm.HttpBeginEvent(Sender: TObject; AWorkCountMax: Integer;
  aKey: string);
begin
  if AWorkCountMax > 0 then
    StatusBar1.Panels[2].Text := 'Transfering: ' + IntToStr(AWorkCountMax);
end;

procedure TAMainFrm.HttpEndEvent(Sender: TObject; aDoneOk: Boolean; aKey,
  aResult: string);
begin
  StatusBar1.Panels[2].Text := 'Done';
end;

procedure TAMainFrm.HttpStatusEvent(ASender: TObject; AStatusText,
  aKey: string);
begin
  StatusBar1.Panels[2].Text := AStatusText;
end;

procedure TAMainFrm.HttpWorkEvent(Sender: TObject; AWorkCount,
  AWorkMax: Integer; aKey: string);
begin
  StatusBar1.Panels[2].Text := IntToStr(AworkCount) + ' bytes.';
end;

function TAMainFrm.GetHttpTextByUrl(aUrl:string; var aOutHtmlText,aErrStr:string):Boolean;
var aHttpGet:THttpGet;
    i:integer; sTemp:string;
begin
  result:=false;
  ShowURL(aUrl);
  aErrStr:='';
  aOutHtmlText:='';
  aHttpGet:=THttpGet.Create;
  try
  try
    aHttpGet.OnHttpBegin:=HttpBeginEvent;
    aHttpGet.OnHttpStatus:=HttpStatusEvent;
    aHttpGet.OnHttpWork:=HttpWorkEvent;
    aHttpGet.OnHttpEnd:=HttpEndEvent;
    aHttpGet.SetInit(aUrl);
    aHttpGet.Resume;
    While Not aHttpGet.Idle do
    Begin
       if StopRunning Then Break;
       Application.ProcessMessages;
       SleepWait(1);
       Inc(i);
       if i > 60 then
       begin
         aErrStr:='Read timeout';
         Break;
       end;
    End;
    aErrStr:=aHttpGet.RunErrMsg;
    result:=aHttpGet.DoneSuc;
    if result then aOutHtmlText:=aHttpGet.ResultString;
    if Length(aErrStr)>0 Then
    Begin
      ShowMsg(aErrStr,false);
      SaveMsg(aErrStr,false);
    End;
  except
    on e:Exception do
    begin
      SaveMsg('GetHttpTextByUrl/'+aUrl+'/'+e.Message,false);
      result:=false;
    end;
  end;
  finally
    try
        aHttpGet.Terminate;
        aHttpGet.WaitFor;
        aHttpGet.Destroy;
        aHttpGet := nil;
    except
    end;
  end;
end;

procedure TAMainFrm.SaveMsg(const Msg: String;aConvert:boolean=true);
begin
    if DisplayMsg<>nil Then
    begin
      if aConvert then DisplayMsg.SaveMsg(AppParam.TwConvertStr(Msg))
      else DisplayMsg.SaveMsg(Msg);
    end;
end;

procedure TAMainFrm.ShowSb(aIndex:integer;amsg:String);
var i:integer;
begin
  with StatusBar2 do
  begin
    if aIndex=-1 then
    begin
      for i:=0 to Panels.Count-1 do
        Panels[i].text:='';
    end
    else begin
      if (aIndex>=0) and (aIndex<Panels.Count) then
      begin
        Panels[aIndex].text:=aMsg;
      end;
    end;
    Application.ProcessMessages;
  end;
end;

function RmvHtmlTag(MemoTxt:string):string;
var
  i,StartP,EndP,StartP2,EndP2:integer;
  Str_temp,Str_temp2,Str_temp3:String;
begin
    StartP := Pos('<',MemoTxt);
    i:=0;
    While StartP>0 do
    Begin
      inc(i);
      if(i>10000)then break;
      EndP := Pos('>',MemoTxt);
      if EndP=0 then break;
      Str_temp3:=Copy(MemoTxt,StartP,EndP-StartP+1);
      if (Str_temp3='') or (MemoTxt='') then break;
      ReplaceSubString(Str_temp3,'',MemoTxt);
      StartP := Pos('<',MemoTxt);
    End;
    result:=MemoTxt;
end;

{
function GetSubUrlText(aInputUrl,aHint:string):boolean;
  var x1:integer;
  begin
    Result:=false;
    //HTTP.Intercept := LogDebug;
    ShowURL(aInputUrl);

    for x1:=1 to 3 do
    begin
      if not GetHttpTextByUrl(aInputUrl,ResultStr,vErrMsg) then
      begin
        ShowMsgEx('(warn)'+aHint+'網頁取得失敗');
        exit;
      end;
    end;


    if ( Pos('404 Not Found',vErrMsg)>0 ) or
       ( Pos('404 Not Found',ResultStr)>0 )  Then
    Begin
        ShowMsgEx('(warn)'+aHint+'網頁取得失敗');
        SaveMsg(ResultStr,false);
        Exit;
    End
    Else Begin
      if Length(ResultStr)>0 Then
      Begin
        Result:=true;
      end;
    end;
  end;
}

Procedure SortStkIndustryRecList(var BufferGrid:TAryStkIndustryRec);
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2,lTemp3 : TStkIndustryRec;
  i,Count :Integer;
Begin

  if BufferGrid=nil then exit;
  if Length(BufferGrid)=0 then exit;

  i := Length(BufferGrid);
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin
            lTemp  := BufferGrid[lLoop1];
            lHold  := lLoop1;
            lTemp2 := BufferGrid[lHold - lHValue];
            while (lTemp2.Code > lTemp.Code) or
                  ((lTemp2.Code = lTemp.Code) and
                   (lTemp2.ComClassCode > lTemp.ComClassCode)
                  )
                  do
            Begin
                 BufferGrid[lHold] := BufferGrid[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
                 lTemp2 := BufferGrid[lHold - lHValue];
            End;
            BufferGrid[lHold] := lTemp;
        End;
  Until lHValue = 0;
End;

function  SaveLog(aTag:string;aText:string):Boolean;
var sFile:string;
begin
  sFile:='d:\'+aTag+Get_GUID8+'.log';
  SetTextByTs(sFile,aText);
end;

function TAMainFrm.StartGet(aDate:string): Boolean;
var i,t,t0,t1,t2,t3 : integer;
  aSource,aTemp,aTemp01,aTemp02,aTemp03,aTemp04,aTemp05,sItem:string;  sDownUrl,ResultStr,vErrMsg : String;
  sCLBBegin,sCLBEnd,sCLB01Begin,sCLB01End,sCLB02Begin,sCLB02End,sCLB03Begin,sCLB03End:string;
  sCLBCode,sCLBName:string;
  tsCLB,tsTemp1,tsTemp2,tsTemp3,tsTemp12:TStringList;
  sDLListText,sSZXYou,sDLName,sDLCode,sDLBegin,sDLEnd,
    sDL01Begin,sDL01End,sDL00Begin,sDL00Begin2,sDL00Begin3,sDL02Begin,sDL02End,sDL03Begin,sDL03End,sDLEnd2:string;
  aAryDaClassRec:TAryDaClassRec;
  sDatListText:string;
  sDatBegin,sStkCode,sStkName,sMrtClass,sMrtClassOld,sXL,sXLCode:string;
    sDatEnd,sDat01Begin,sDat01End,sDat02Begin,sDat02End,sDat02End2,sDat03Begin,sDat03End,
    sDat05Begin,sDat05Begin2,sDat05End:string;
  aAryStkIndustry: TAryStkIndustry;
  aAllCList:TAryDaClassRec;//--all lei bie zi leibie

  function GetSubUrlText(aInputUrl,aHint:string):boolean;
  var x1:integer; xb:Boolean;
  begin
    Result:=false;
    //HTTP.Intercept := LogDebug;
    ShowURL(aInputUrl);
    xb:=False;
    for x1:=1 to 3 do
    begin
      if StopRunning then
        exit;
      if GetHttpTextByUrl(aInputUrl,ResultStr,vErrMsg) then
        if not (  ( Pos('404 Not Found',vErrMsg)>0 ) or
           ( Pos('404 Not Found',ResultStr)>0 )  )  Then
         if Length(ResultStr)>0 Then
         begin
           Result:=true;
           xb:= true;
           exit;
         end;
      if StopRunning then
        exit;
      SleepWait(3);
    end;
    if not xb then
    begin
        ShowMsgEx('(warn)'+aHint+'網頁取得失敗');
        exit;
    end;
  end;

  function IndexOfAllCList(aCYC,aSZXYou,aDLB,aZLB:string):integer;
  var x1:integer;
  begin
    result:=-1;
    for x1:=0 to high(aAllCList) do
    begin
      if sametext(trim(aAllCList[x1].items[0]),trim(aCYC)) and
         sametext(trim(aAllCList[x1].items[1]),trim(aSZXYou)) and
         sametext(trim(aAllCList[x1].items[2]),trim(aDLB)) and
         sametext(trim(aAllCList[x1].items[3]),trim(aZLB)) then
      begin
        result:=x1;
        exit;
      end;
    end;
  end;

  procedure AddToAllCList(aCYC,aSZXYou,aDLB,aZLB:string);
  var x1:integer;
  begin
    if IndexOfAllCList(aCYC,aSZXYou,aDLB,aZLB)<>-1 then
      exit;
    x1:=Length(aAllCList);
    SetLength(aAllCList,x1+1);
    aAllCList[x1].Items[0]:=aCYC;
    aAllCList[x1].Items[1]:=aSZXYou;
    aAllCList[x1].Items[2]:=aDLB;
    aAllCList[x1].Items[3]:=aZLB;
  end;


  procedure AddToDaClass(aSZX,aDaLei,aDaLeiCode:string);
  var x1:integer;
  begin
    x1:=Length(aAryDaClassRec);
    SetLength(aAryDaClassRec,x1+1);
    aAryDaClassRec[x1].Items[0]:=aSZX;
    aAryDaClassRec[x1].Items[1]:=aDaLeiCode;
    aAryDaClassRec[x1].Items[2]:=aDaLei;
    aAryDaClassRec[x1].Items[3]:='';
  end;

  function ProStrParam(aInput:string):string;
  begin
    result:=aInput;
    result:=StringReplace(result,#9,'',[rfReplaceAll]);
    result:=StringReplace(result,#13,'',[rfReplaceAll]);
    result:=StringReplace(result,#10,'',[rfReplaceAll]);
  end;

  procedure AddStkIndustry(aParmCode,aParmName,aParmCYB,aParmSZXYou,aParmDLB,aParmZLB,aParmMktClass:string);
  var x1:integer;
  begin
    aParmCode:=ProStrParam(aParmCode);
    aParmName:=ProStrParam(aParmCode);
    aParmCYB:=ProStrParam(aParmCYB);
    aParmSZXYou:=ProStrParam(aParmSZXYou);
    aParmDLB:=ProStrParam(aParmDLB);
    aParmZLB:=ProStrParam(aParmZLB);
    aParmMktClass:=ProStrParam(aParmMktClass);

    x1:=Length(aAryStkIndustry);
    SetLength(aAryStkIndustry,x1+1);
    aAryStkIndustry[x1].Code:='';
    aAryStkIndustry[x1].Code:=aParmCode;
    aAryStkIndustry[x1].CYB:=aParmCYB;
    aAryStkIndustry[x1].SZXYou:=aParmSZXYou;
    aAryStkIndustry[x1].DLB:=aParmDLB;
    aAryStkIndustry[x1].ZLB:=aParmZLB;
    aAryStkIndustry[x1].MktClass:=aParmMktClass;
    SaveMsg(sDownUrl+#9+aParmCode+';'+aParmName+';'+aParmCYB+';'+aParmSZXYou+';'+aParmDLB+';'+aParmZLB+';'+aParmMktClass,false);
  end;


  function WriteToFile():boolean;
  var f: File  of TStkIndustryRec; xrAry:TAryStkIndustryRec;
      xFile,xsDatPath:string;  x1,x2,x3:integer;
      aComCodeList:array of TComCodeRec; aComClassCodeList:array of TComClassCodeRec;
      xx01,xx02,xx03,xx04:integer;  xxs01,xxs02,xxs03,xxs04:string;

    function InitComCodeRecList():integer;
    var xx1,xx2,xx3,xx4:integer; xxsFile00,xxsFile01,xxsFile10,xxsFile11:string;
        xxf1: File  of TComCodeRec; xxf2: File  of TComClassCodeRec ;
    begin
      Result:=0;
      SetLength(aComCodeList,0);
      SetLength(aComClassCodeList,0);
      xxsFile00:=FTrlDBPath+'CBData\tcri\'+_TCRIComCodeF;
      xxsFile01:=xsDatPath+ExtractFileName(xxsFile00);
      xxsFile10:=FTrlDBPath+'CBData\tcri\'+_TCRIComClassCodeF;
      xxsFile11:=xsDatPath+ExtractFileName(xxsFile10);
      DelDatF(xxsFile01);
      DelDatF(xxsFile11);
      if FileExists(xxsFile00) then
      if not CpyDatF(xxsFile00,xxsFile01) then
      begin
        ShowMsgEx('(warn)'+'copy fail.'+xxsFile00);
        exit;
      end;
      if FileExists(xxsFile10) then
      if not CpyDatF(xxsFile10,xxsFile11) then
      begin
        ShowMsgEx('(warn)'+'copy fail.'+xxsFile10);
        exit;
      end;
      try
        if FileExists(xxsFile01) then
        try
          AssignFile(xxf1,xxsFile01);
          FileMode := 0;
          ReSet(xxf1);
          xx1 := FileSize(xxf1);
          SetLength(aComCodeList,xx1);
          BlockRead(xxf1,aComCodeList[0],xx1,xx2);
        finally
          try CloseFile(xxf1); except end;
        end;
        if FileExists(xxsFile11) then
        try
          AssignFile(xxf2,xxsFile11);
          FileMode := 0;
          ReSet(xxf2);
          xx1 := FileSize(xxf2);
          SetLength(aComClassCodeList,xx1);
          BlockRead(xxf2,aComClassCodeList[0],xx1,xx2);
        finally
          try CloseFile(xxf2); except end;
        end;
        Result:=1;
      finally
        DelDatF(xxsFile01);
        DelDatF(xxsFile11);
      end;
    end;
    function SendToComCode(aName,aClassCode:string):integer;
    var xx1,xx2,xx3,xx4:integer;
    begin
      result:=-1;
      xx2:=-1;
      for xx1:=0 to High(aComCodeList) do
      begin
        Application.ProcessMessages;
        if sametext(aComCodeList[xx1].Name,aName) and
           sametext(aComCodeList[xx1].ClassCode,aClassCode) then
        begin
          xx2:=aComCodeList[xx1].Idx;
          break;
        end;
      end;
      if xx2=-1 then
      begin
        xx3:=Length(aComCodeList);
        SetLength(aComCodeList,xx3+1);
        aComCodeList[xx3].Idx:=xx3;
        aComCodeList[xx3].ClassCode:=aClassCode;
        aComCodeList[xx3].Name:=aName;
        result:=aComCodeList[xx3].Idx;
      end
      else begin
        result:=xx2;
      end;
    end;
    function SendToClassComCode(aCYC,aSZXYou,aDLB,aZLB:string):integer;
    var xx1,xx2,xx3,xx4:integer;
    begin
      result:=-1;
      {if not (  SameText(xxs01,aCYC) and
        SameText(xxs02,aSZXYou) and
        SameText(xxs03,aDLB) and
        SameText(xxs04,aZLB)
        ) then
      begin}
        xx01:=SendToComCode(aCYC,_CodeCYB);
        xx02:=SendToComCode(aSZXYou,_CodeSZXYou);
        xx03:=SendToComCode(aDLB,_CodeDLB);
        xx04:=SendToComCode(aZLB,_CodeZLB);
        if (xx01=-1) or  (xx02=-1) or (xx03=-1) or (xx04=-1) then
        begin
          raise Exception.Create('SendToComCode fail.'+aCYC+','+aSZXYou+','+aDLB+','+aZLB);
        end;
        xxs01:=aCYC;
        xxs02:=aSZXYou;
        xxs03:=aDLB;
        xxs04:=aZLB;
      //end;

      xx2:=-1;
      for xx1:=0 to High(aComClassCodeList) do
      begin
        Application.ProcessMessages;
        if (aComClassCodeList[xx1].CYBIdx=xx01) and
           (aComClassCodeList[xx1].SZXYouIdx=xx02) and
           (aComClassCodeList[xx1].DLBIdx=xx03) and
           (aComClassCodeList[xx1].ZLBIdx=xx04)   then
        begin
          xx2:=aComClassCodeList[xx1].Idx;
        end;
      end;
      if xx2=-1 then
      begin
        xx3:=Length(aComClassCodeList);
        SetLength(aComClassCodeList,xx3+1);
        aComClassCodeList[xx3].Idx:=xx3;
        aComClassCodeList[xx3].CYBIdx:=xx01;
        aComClassCodeList[xx3].SZXYouIdx:=xx02;
        aComClassCodeList[xx3].DLBIdx:=xx03;
        aComClassCodeList[xx3].ZLBIdx:=xx04;
        result:=aComClassCodeList[xx3].Idx;
      end
      else begin
        result:=xx2;
      end;
    end;
    function FreeComCodeRecList():integer;
    var xx1,xx2,xx3,xx4:integer; xxsFile00,xxsFile01,xxsFile10,xxsFile11:string;
        xxf1: File  of TComCodeRec; xxf2: File  of TComClassCodeRec ;
    begin
      Result:=0;
      xxsFile00:=FTrlDBPath+'CBData\tcri\'+_TCRIComCodeF;
      xxsFile01:=xsDatPath+ExtractFileName(xxsFile00);
      xxsFile10:=FTrlDBPath+'CBData\tcri\'+_TCRIComClassCodeF;
      xxsFile11:=xsDatPath+ExtractFileName(xxsFile10);
      try
        if Length(aComCodeList)>0 then
        begin
          try
            AssignFile(xxf1,xxsFile01);
            FileMode := 2;
            Rewrite(xxf1);
            xx1 := Length(aComCodeList);
            BlockWrite(xxf1,aComCodeList[0],xx1);
          finally
            try CloseFile(xxf1); except end;
          end;
          if not CpyDatF(xxsFile01,xxsFile00) then
          begin
            ShowMsgEx('(warn)'+'copy fail.'+xxsFile01);
            exit;
          end;
        end;
        if Length(aComClassCodeList)>0 then
        begin
          try
            AssignFile(xxf2,xxsFile11);
            FileMode := 2;
            Rewrite(xxf2);
            xx1 := Length(aComClassCodeList);
            BlockWrite(xxf2,aComClassCodeList[0],xx1);
          finally
            try CloseFile(xxf2); except end;
          end;
          if not CpyDatF(xxsFile11,xxsFile10) then
          begin
            ShowMsgEx('(warn)'+'copy fail.'+xxsFile11);
            exit;
          end;
        end;
        Result:=1;
      finally
        DelDatF(xxsFile01);
        DelDatF(xxsFile11);
        SetLength(aComCodeList,0);
        SetLength(aComClassCodeList,0);
      end;
    end;
  begin
    result:=false;
    x1:=length(aAryStkIndustry);
    if x1=0 then
      exit;
    xFile:=DataFile(aDate);
    xsDatPath:=ExtractFilePath(xFile);
    if not DirectoryExists(xsDatPath) then
      Mkdir_Directory(xsDatPath);


    try
      if InitComCodeRecList<>1 then
        exit;

      SetLength(xrAry,x1);
      for x2:=0 to x1-1 do
      begin
        xrAry[x2].Code:='';
      end;
      for x2:=0 to high(aAllCList) do
      begin
        SendToClassComCode(trim(aAllCList[x2].items[0]),
                     trim(aAllCList[x2].items[1]),
                     trim(aAllCList[x2].items[2]),
                     trim(aAllCList[x2].items[3]));
      end;

      for x2:=0 to x1-1 do
      begin
        x3:=SendToClassComCode(aAryStkIndustry[x2].CYB,aAryStkIndustry[x2].SZXYou,
          aAryStkIndustry[x2].DLB,aAryStkIndustry[x2].ZLB);
        if x3<>-1 then
        begin
          xrAry[x2].Code:=aAryStkIndustry[x2].Code;
          xrAry[x2].ComClassCode:=x3;
        end;
      end;
      SortStkIndustryRecList(xrAry);
      AssignFile(f,xFile);
      FileMode := 1;
      ReWrite(f);
      BlockWrite(f,xrAry[0],x1);
      CloseFile(f);
      result:=True;
    finally
      SetLength(xrAry,0);
      FreeComCodeRecList;
    end;
  end;
  
  function IndexOfDaClass(aDaLeiCode:string):integer;
  var x1:integer;
  begin
    Result:=-1;
    for x1:=0 to High(aAryDaClassRec) do
    begin
      if SameText(aAryDaClassRec[x1].Items[1],aDaLeiCode) then
      begin
        result:=x1;
        exit;
      end;
    end;
  end;
  
begin
  sCLBBegin:='<div class="content-panel-search">';
  sCLBEnd:='</form>';
  sCLB01Begin:='<option';
  sCLB01End:='</option>';
  sCLB02Begin:='value=';
  sCLB02End:='>';
  sCLB03Begin:='>';
  sCLB03End:='</option>';

  sDLBegin:='<div id="main_ic_panel"';
  sDLEnd:='<div id="companyList_';
  sDLEnd2:='"';
  sDL00Begin:='<div class="chain">';
  sDL00Begin2:='<div class="h-div">';
  sDL00Begin3:='<div class="chain-arrow">';

  sDL01Begin:='<div class="chain-title-panel"';
  sDL01End:='</div>';
  sDL02Begin:='<div id="ic_link_';
  sDL02End:='</div>';
  sDL03Begin:='<div id="';
  sDL03End:='"';

  sDatBegin:='<noscript>';
  sDatEnd:='</noscript>';
  sDat01Begin:='<b>';
  sDat01End:='</b>';
  sDat02Begin:='<a href="company_basic.php?stk_code=';
  sDat02End:='"';
  sDat02End2:='</a>';
  sDat03Begin:='title="';
  sDat03End:='"';
  sDat05Begin:='<table id="sc_company_';
  sDat05Begin2:='<table ';
  sDat05End:='</table>';

  Result := false;
  ShowMsgEx('開始取得產業鏈網頁...');
  if StopRunning Then exit;
  try
  try
    SetLength(aAryDaClassRec,0);
    tsCLB:=TStringList.create;
    tsTemp1:=TStringList.create;
    tsTemp12:=TStringList.create;
    tsTemp2:=TStringList.create;
    tsTemp3:=TStringList.create;

    if not GetSubUrlText(FUrl,'產業鏈') then
      exit;

    aSource := GetStr(sCLBBegin,sCLBEnd,ResultStr,true);
    //in case of dead c
    for i:=1 to 1000 do
    begin
      Application.ProcessMessages;
      sItem:=GetStr(sCLB01Begin,sCLB01End,aSource,true,true);
      if sItem='' then
        break;
      sCLBCode:=GetStr(sCLB02Begin,sCLB02End,sItem,false,false);
      sCLBCode:=StringReplace(sCLBCode,chr(39),'',[rfReplaceAll]);
      sCLBCode:=StringReplace(sCLBCode,'"','',[rfReplaceAll]);
      sCLBCode:=Trim(sCLBCode);
      sCLBName:=GetStr(sCLB03Begin,sCLB03End,sItem,false,false);
      sCLBName:=Trim(sCLBName);
      if (sCLBCode='') or (sCLBName='') then
      begin
        ShowMsgEx('(warn)'+'sCLBCode=null or sCLBName=null.'+sItem,false);
      end
      else begin
        tsCLB.Add(sCLBCode);
        tsCLB.Add(sCLBName);
      end;
    end;
    if tsCLB.count=0 then
    begin
      ShowMsgEx('(warn)'+'未找到目標數據，可能是網站資料更新所致，請聯系管理員');
      exit;
    end;
    i:=0;
    while i<tsCLB.count do
    begin
      SetLength(aAryDaClassRec,0);

      sCLBCode:=tsCLB[i];
      sCLBCode:=StringReplace(sCLBCode,'selected','',[rfReplaceAll,rfIgnoreCase]); 
      sCLBName:=tsCLB[i+1];
      showsb(1,Format('%d/%d(%s)',[Trunc(i/2)+1,Trunc(tsCLB.count/2),sCLBName]));
      {if sCLBCode<>'A100' then
      begin
        i:=i+2;
        continue;
      end;}
      sDownUrl:=Format('%s?ic=%s',[FUrl,sCLBCode]);
      if not GetSubUrlText(sDownUrl,sCLBName) then
        exit;

      sDLListText:=GetStr(sDLBegin,sDLEnd,ResultStr,true,false);
      if sDLListText='' then
      begin
        ShowMsgEx('(warn)'+'sDLListText=null');
        SaveMsg(ResultStr,false);
        exit;
      end;
      sDatListText:=GetStr(sDatBegin,sDatEnd,ResultStr,true,false);
      if sDatListText='' then
      begin
        ShowMsgEx('(warn)'+'sDatListText=null');
        SaveMsg(ResultStr,false);
        exit;
      end;

      //----
      sDLListText:=StringReplace(sDLListText,#13#10,'',[rfReplaceAll]);
      sDLListText:=StringReplace(sDLListText,sDL00Begin,#13#10+sDL00Begin,[rfReplaceAll]);
      //sDLListText:=StringReplace(sDLListText,sDL00Begin2,#13#10+sDL00Begin2,[rfReplaceAll]);
      //sDLListText:=StringReplace(sDLListText,sDL00Begin3,#13#10+sDL00Begin3,[rfReplaceAll]);
      tsTemp1.clear;
      tsTemp1.text:=sDLListText;
      //SaveLog('01',tsTemp1.text);
      for t:=0 to tsTemp1.count-1 do
      begin
        if Pos(sDL00Begin,tsTemp1[t])>0 then
        begin
          aTemp01:=Trim(tsTemp1[t]);
          sSZXYou:=GetStr(sDL01Begin,sDL01End,aTemp01,true);
          sSZXYou:=RmvHtmlTag(sSZXYou);
          if sSZXYou='' then
            sSZXYou:=CNa;

          
          aTemp01:=StringReplace(aTemp01,#13#10,'',[rfReplaceAll]);
          aTemp01:=StringReplace(aTemp01,sDL02Begin,#13#10+sDL02Begin,[rfReplaceAll]);
          tsTemp2.clear;
          tsTemp2.text:=aTemp01;
          //SaveLog('02',tsTemp2.text);
          for t0:=0 to tsTemp2.count-1 do
          begin
            if Pos(sDL02Begin,tsTemp2[t0])>0 then
            begin
              aTemp02:=Trim(tsTemp2[t0]);
              aTemp03:=GetStr(sDL02Begin,sDL02End,aTemp02,true,false);
              sDLCode:=GetStr(sDL02Begin,sDL03End,aTemp03,false,false);
              aTemp03:=StringReplace(aTemp03,'<br/>','',[rfReplaceAll]);
              aTemp03:=StringReplace(aTemp03,'<br>','',[rfReplaceAll]);
              sDLName:=RmvHtmlTag(aTemp03);
              if (sDLCode='') or (sDLName='') then
              begin
                SaveMsg('(warn)'+'sDLCode=null or sDLName=null.'+aTemp02,false);
              end
              else begin
                AddToDaClass(sSZXYou,sDLName,sDLCode);
              end;
            end;
          end;
        end
        else if Pos(sDL00Begin2,tsTemp1[t])>0 then
        begin
          aTemp01:=Trim(tsTemp1[t]);
          sSZXYou:=GetStr(sDL01Begin,sDL01End,aTemp01,true,false);
          sSZXYou:=RmvHtmlTag(sSZXYou);
          if sSZXYou='' then
            sSZXYou:=CNa;
          aTemp01:=StringReplace(aTemp01,#13#10,'',[rfReplaceAll]);
          aTemp01:=StringReplace(aTemp01,sDL02Begin,#13#10+sDL02Begin,[rfReplaceAll]);
          tsTemp2.clear;
          tsTemp2.text:=aTemp01;
          for t0:=0 to tsTemp2.count-1 do
          begin
            if Pos(sDL02Begin,tsTemp2[t0])>0 then
            begin
              aTemp02:=Trim(tsTemp2[t0]);
              aTemp03:=GetStr(sDL02Begin,sDL02End,aTemp02,true,false);
              sDLCode:=GetStr(sDL02Begin,sDL03End,aTemp03,false,false);
              aTemp03:=StringReplace(aTemp03,'<br/>','',[rfReplaceAll]);
              aTemp03:=StringReplace(aTemp03,'<br>','',[rfReplaceAll]);
              sDLName:=RmvHtmlTag(aTemp03);
              if (sDLCode='') or (sDLName='') then
              begin
                SaveMsg('(warn)'+'sDLCode=null or sDLName=null.'+aTemp02,false);
              end
              else begin
                AddToDaClass(sSZXYou,sDLName,sDLCode);
              end;
            end;
          end;
        end
        else if Pos(sDL00Begin3,tsTemp1[t])>0 then
        begin
          aTemp01:=Trim(tsTemp1[t]);
          sSZXYou:=GetStr(sDL01Begin,sDL01End,aTemp01,true,false);
          sSZXYou:=RmvHtmlTag(sSZXYou);
          if sSZXYou='' then
            sSZXYou:=CNa;
          aTemp01:=StringReplace(aTemp01,#13#10,'',[rfReplaceAll]);
          aTemp01:=StringReplace(aTemp01,sDL02Begin,#13#10+sDL02Begin,[rfReplaceAll]);
          tsTemp2.clear;
          tsTemp2.text:=aTemp01;
          for t0:=0 to tsTemp2.count-1 do
          begin
            if Pos(sDL02Begin,tsTemp2[t0])>0 then
            begin
              aTemp02:=Trim(tsTemp2[t0]);
              aTemp03:=GetStr(sDL02Begin,sDL02End,aTemp02,true,false);
              sDLCode:=GetStr(sDL02Begin,sDL03End,aTemp03,false,false);
              aTemp03:=StringReplace(aTemp03,'<br/>','',[rfReplaceAll]);
              aTemp03:=StringReplace(aTemp03,'<br>','',[rfReplaceAll]);
              sDLName:=RmvHtmlTag(aTemp03);
              if (sDLCode='') or (sDLName='') then
              begin
                SaveMsg('(warn)'+'sDLCode=null or sDLName=null.'+aTemp02,false);
              end
              else begin
                AddToDaClass(sSZXYou,sDLName,sDLCode);
              end;
            end;
          end;
        end;
      end;
      

      //----
      sDatListText:=StringReplace(sDatListText,#13#10,'',[rfReplaceAll]);
      sDatListText:=StringReplace(sDatListText,sDLEnd,#13#10+sDLEnd,[rfReplaceAll]);
      tsTemp1.clear;
      tsTemp1.text:=sDatListText;
      for t:=0 to tsTemp1.count-1 do
      begin
        //chuli  daleibie
        if Pos(sDLEnd,tsTemp1[t])>0 then
        begin
          aTemp01:=Trim(tsTemp1[t]);
          sDLCode:=GetStr(sDLEnd,sDLEnd2,aTemp01,false,false);
          t2:=IndexOfDaClass(sDLCode);

          aTemp01:=StringReplace(aTemp01,'<div',#13#10+'<div',[rfReplaceAll]);
          aTemp01:=StringReplace(aTemp01,'</table><b>',#13#10+'</table><b>',[rfReplaceAll]);
          aTemp01:=StringReplace(aTemp01,'<div><b>',#13#10+'<div><b>',[rfReplaceAll]);
          aTemp01:=StringReplace(aTemp01,'<table',#13#10+'<table',[rfReplaceAll]);
          tsTemp2.clear;
          tsTemp2.text:=aTemp01;
          for t0:=0 to tsTemp2.count-1 do
            begin
              aTemp02:=Trim(tsTemp2[t0]);
              if (Pos(sDat05Begin,aTemp02)>0) or
                 (Pos(sDat05Begin2,aTemp02)>0) then
              begin
                sXL:=CNa;
                if Pos(sDat05Begin,aTemp02)>0 then
                begin
                  if (t0-1<0) then
                  begin
                    SaveMsg('(warn)'+'t0-1<0.'+aTemp02,false);
                    Continue;
                  end;
                  //get zileibie
                  aTemp03:=Trim(tsTemp2[t0-1]);
                  sXL:=GetStr(sDat01Begin,sDat01End,aTemp03,false,false);
                  if (sXL='') then
                  begin
                    SaveMsg('(warn)'+'sXL=null.'+aTemp02+';'+aTemp03,false);
                    Continue;
                  end;
                end;
                //get detail data
                aTemp02:=StringReplace(aTemp02,'<tr>',#13#10+'<<tr>',[rfReplaceAll]);
                tsTemp3.clear;
                tsTemp3.text:=aTemp02;
                sMrtClassOld:='';
                for t1:=0 to tsTemp3.count-1 do
                begin
                  if Pos('<tr>',tsTemp3[t1])>0 then
                  begin
                    aTemp03:=Trim(tsTemp3[t1]);

                    sMrtClass:=GetStr(sDat01Begin,sDat01End,aTemp03,false,false);
                    if sMrtClass='' then
                    begin
                      sMrtClass:=sMrtClassOld;
                    end
                    else begin
                      aTemp04:=GetStr('(',')',sMrtClass,true,false);
                      sMrtClass:=StringReplace(sMrtClass,aTemp04,'',[rfReplaceAll]);
                      sMrtClass:=Trim(sMrtClass);
                      sMrtClassOld:=sMrtClass;
                    end;

                    if t2=-1 then
                    begin
                      AddToAllCList(sCLBName,CNa,CNa,sXL);
                    end
                    else begin
                      AddToAllCList(sCLBName,aAryDaClassRec[t2].Items[0],aAryDaClassRec[t2].Items[2],sXL);
                    end;
                    // in case of dead c
                    for t3:=1 to 200 do
                    begin
                      aTemp04:=GetStr(sDat02Begin,sDat02End2,aTemp03,True,True);
                      if aTemp04='' then
                        break;

                      sStkCode:=GetStr(sDat02Begin,sDat02End,aTemp04,false,false);
                      sStkName:=GetStr(sDat03Begin,sDat03End,aTemp04,false,false);
                      sStkName:=StringReplace(sStkName,sStkCode,'',[rfReplaceAll]);
                      if (sStkCode='') or (sStkName='') then
                      begin
                        SaveMsg('(warn)'+'sStkCode=null or sStkName=null .'+aTemp03+';'+aTemp04,false);
                        Continue;
                      end
                      else begin
                        if t2=-1 then
                        begin
                          AddStkIndustry(sStkCode,sStkName,sCLBName,CNa,CNa,sXL,sMrtClass);
                        end
                        else begin
                          AddStkIndustry(sStkCode,sStkName,sCLBName,aAryDaClassRec[t2].Items[0],aAryDaClassRec[t2].Items[2],
                            sXL,sMrtClass);
                          aAryDaClassRec[t2].Items[3]:='1';
                        end;
                        //aParmCode,aParmName,aParmCYB,aParmSZXYou,aParmDLB,aParmZLB,aParmMktClass
                      end;
                    end;
                    
                  end;
                end;
                
              end;

            end;
        end;


      end;////chuli  daleibie


      //---check
          for t0:=0 to High(aAryDaClassRec) do
          begin
            if aAryDaClassRec[t0].Items[3]='' then
            begin
              SaveMsg('(warn)'+aAryDaClassRec[t0].Items[1]+','+aAryDaClassRec[t0].Items[2]+
                'not match .',false);
            end;
          end;
      i:=i+2;
    end;
    if WriteToFile then
      Result := true;
    if result then SaveMsg('內容成功取得');
  Except
     On E:Exception do
     Begin
         ShowMsgEx(E.Message,false);
     End;
  End;
  finally
     try SetLength(aAllCList,0);  except end;
     try SetLength(aAryDaClassRec,0);  except end;
     try FreeAndNil(tsCLB); except end;
     try FreeAndNil(tsTemp1); except end;
     try FreeAndNil(tsTemp12); except end;
     try FreeAndNil(tsTemp2); except end;
     try FreeAndNil(tsTemp3); except end;
     ShowURL('');
     StatusBar1.Panels[2].Text := '';
     showsb(-1,'');
  end;
end;


Procedure SortStkBase1RecList(var BufferGrid:TAryStkBase1);
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2,lTemp3 : TStkBase1;
  i,Count :Integer;
Begin
  if BufferGrid=nil then exit;
  if Length(BufferGrid)=0 then exit;

  i := Length(BufferGrid);
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin
            lTemp  := BufferGrid[lLoop1];
            lHold  := lLoop1;
            lTemp2 := BufferGrid[lHold - lHValue];
            while (lTemp2.Code > lTemp.Code)
                  do
            Begin
                 BufferGrid[lHold] := BufferGrid[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
                 lTemp2 := BufferGrid[lHold - lHValue];
            End;
            BufferGrid[lHold] := lTemp;
        End;
  Until lHValue = 0;
End;

procedure TAMainFrm.SleepWait(Const Value:Double);
var
  iEndTick: DWord;
begin
    iEndTick := GetTickCount + Round(Value*1000);
    repeat
      if StopRunning then
        exit;
       Application.ProcessMessages;
       Sleep(10);
    until GetTickCount >= iEndTick;
End;

function RplOfBr(aInput,aRpl:string):string;
begin
  result:=Trim(aInput);
  result:=StringReplace(result,'<br>',aRpl,[rfReplaceAll]);
  result:=StringReplace(result,'</br>',aRpl,[rfReplaceAll]);
  result:=StringReplace(result,'<BR>',aRpl,[rfReplaceAll]);
  result:=StringReplace(result,'</BR>',aRpl,[rfReplaceAll]);

  result:=Trim(result);
end;

function RmvHtmlTag2(MemoTxt:string):string;
var
  i,StartP,EndP,StartP2,EndP2:integer;
  Str_temp,Str_temp2:String;
begin
    StartP := Pos('<',MemoTxt);
    i:=0;
    While StartP>0 do
    Begin
      inc(i);
      if(i>10000)then break;
      EndP := Pos('>',MemoTxt);
      if EndP=0 then break;
      ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP+1),'',MemoTxt);
      StartP := Pos('<',MemoTxt);
    End;
    result:=MemoTxt;
end;

function FileCtrlEnter(aInput:string):string;
var sConst:string;
begin
  sConst:='#13#10';
  result:=aInput;
  result:=StringReplace(result,sConst+sConst,sConst,[rfReplaceAll]);
  if (Copy(result,1,Length(sConst))=sConst) then
    result:= Copy(result,Length(sConst)+1,Length(result)-Length(sConst));
  if (Copy(result,Length(result)-(Length(sConst)-1),Length(sConst))=sConst) then
    result:= Copy(result,1,Length(result)-Length(sConst));
end;

function ClsATagHtml(aBeginTag,aInput:string):string;
var str1,str2:string; i:integer;
begin
  result:=aInput;
  for i:=1 to 1000 do
  begin
    Application.ProcessMessages;
    str1:=GetStrOnly2(aBeginTag,'>',result,false);
    if str1='' then
      exit;
    //str2:=GetStrOnly2(aBeginTag,'>',aInput,True);
    result:=StringReplace(result,str1,'',[rfReplaceAll]);
  end;
end;

function GetRowSpan(aInput:string):integer;
var i,iPos:integer; sNum:string;
begin
  result:=0;
  aInput:=StringReplace(aInput,'"','',[rfReplaceAll]);
  aInput:=StringReplace(aInput,chr(39),'',[rfReplaceAll]);
  sNum:='';
  aInput:=LowerCase(aInput);
  iPos:=Pos('rowspan=',aInput);
  if iPos>0 then
  begin
    for i:=iPos+length('rowspan=') to Length(aInput) do
    begin
      if not (aInput[i] in ['0'..'9']) then
        break;
      sNum:=sNum+aInput[i];
    end;
    if sNum<>'' then
      result:=StrToInt(sNum);
  end;
end;

function GetFieldValue(aInput:string;var aField,aValue:string):boolean;
var i:integer;
begin
  result:=false;
  aField:=''; aValue:='';
  i:=Pos('=',aInput);
  if i>0 then
  begin
    aField:=Copy(aInput,1,i-1);
    aValue:=Copy(aInput,i+1,Length(aInput));
    result:=true;
  end;
end;

function CFFmt(fVar:double):string;
begin
  result:='';
  if not (
     (fVar=NoneNum) or (fVar=ValueEmpty)
    ) then
    result:=FloatToStr(fVar);
end;

function CIFmt(fVar:integer):string;
var i,iLess:integer;
begin
  result:=IntToStr(fVar);
  iLess:=5-Length(result);
  if iLess>0 then
  begin
    for i:=1 to iLess do
      result:='0'+Result;
  end;
end;

function ProValueItem(aInputValue:String):string;
  begin
    result:=aInputValue;
    result:=StringReplace(result,'"','',[rfReplaceAll]);
    result:=StringReplace(result,chr(39),'',[rfReplaceAll]);
    result:=StringReplace(result,#13,'',[rfReplaceAll]);
    result:=StringReplace(result,#10,'',[rfReplaceAll]);
    result:=StringReplace(result,#9,'',[rfReplaceAll]);
    result:=StringReplace(result,' ','',[rfReplaceAll]);
    result:=Trim(result);
  end;


function GetColListOfHtml(aInputHtml:string;var sOutPut:string):boolean;
var ts0,ts1:TStringList;  aRecLst:TColSpanRecLst;
   sText,sInput,sLine,sLine2,sTemp,sTemp1,sDatList:string;
   i,k,j,iLevel,iColSpan,iLen,ic:integer;
begin
  sOutPut:='';
  result:=False;
  SetLength(aRecLst,0);
  ts0:=TStringList.create;
  ts1:=TStringList.create;
  try
      sInput:=aInputHtml;
      sInput:=StringReplace(sInput,#13#10,'',[rfReplaceAll]);
      sInput:=StringReplace(sInput,chr(39),'',[rfReplaceAll]);
      sInput:=StringReplace(sInput,'<tr',#13#10+'<tr',[rfReplaceAll]);
      ts0.text:=sInput;

      iLevel:=-1;
      for i:=0 to ts0.count-1 do
      begin
        if not (
          (Pos('<tr',ts0[i])>0) and
          (Pos('</tr>',ts0[i])>0)
        ) then
        begin
          Continue;
        end;
        Inc(iLevel);
        sText:=Trim(ts0[i]);
        sText:=StringReplace(sText,'<th',#13#10+'<th',[rfReplaceAll]);
        sText:=StringReplace(sText,'</th>','</th>'+#13#10,[rfReplaceAll]);
        ts1.text:=sText;
        for j:=0 to ts1.count-1 do
        begin
          if not (
            (Pos('<th',ts1[j])>0) and
            (Pos('</th>',ts1[j])>0)
          ) then
          begin
            Continue;
          end;
          sLine:=Trim(ts1[j]);
          sTemp:=GetStrOnly2('colspan=','>',sLine,false);
          if sTemp='' then iColSpan:=1
          else iColSpan:=StrToInt(sTemp);
          sTemp:=GetStrOnly2('>','</th>',sLine,false);

          iLen:=Length(aRecLst);
          SetLength(aRecLst,iLen+1);
          aRecLst[iLen].Level:=iLevel;
          aRecLst[iLen].Caption:=sTemp;
          aRecLst[iLen].CaptionInit:=sTemp;
          aRecLst[iLen].ColSpan:=iColSpan;
          if iColSpan=1 then aRecLst[iLen].Flag:=True
          else aRecLst[iLen].Flag:=False;  
        end;
      end;

      for i:=High(aRecLst) downto 0 do
      begin
        if aRecLst[i].Level=-1 then Continue;
        if (aRecLst[i].ColSpan>1) and (not aRecLst[i].Flag) then
        begin
          ic:=0; sDatList:='';
          for j:=High(aRecLst) downto i+1 do
          begin
            if aRecLst[j].Level=-1 then Continue;
            if (aRecLst[j].Level=aRecLst[i].Level+1) then
            begin
              if ic=0 then sDatList:=aRecLst[j].Caption
              else sDatList:=aRecLst[j].Caption+#13#10+sDatList;
              aRecLst[j].Level:=-1;
              ic:=ic+aRecLst[j].ColSpan;
              if ic=aRecLst[i].ColSpan then
              begin
                break;
              end;
            end;
          end;
          if ic=aRecLst[i].ColSpan then
          begin
            aRecLst[i].Caption:=sDatList;
            aRecLst[i].Flag:=true;
          end
          else raise Exception.Create('not matched colspancount.'+inttostr(aRecLst[i].Level)+','+inttostr(aRecLst[i].ColSpan)+','+aRecLst[i].Caption);
        end;
      end;
      
      ts1.clear;
      for i:=0 to High(aRecLst) do
      begin
        if aRecLst[i].Level=-1 then
          Continue;
        ts1.Add(aRecLst[i].Caption);
      end;
      sOutPut:=ts1.text;
      result:=true;
  finally
    SetLength(aRecLst,0);
    FreeAndNil(ts0);
    FreeAndNil(ts1);
  end;
end;

Function TAMainFrm._GetGuLiTitlesCount(MemoTxt:String;var FLastErrMsg:string;var iIdxStart:integer; var tsOutPut,tsOutPut2:TStringList):Integer;
const _FiledSep=';';
     _CompareSep='#CompareSep#';
     _CompareSep2='#CompareSep2#';
     _CompareSep3='#CompareSep3#';
   _NullValue='';
   _FiledsDefine: Array[0..22] of String=(
  '公司代號',
  '公司名稱',
  '股利所屬年度',
  '權利分派基準日',
  '盈餘轉增資配股(元/股)',
  '法定盈餘公積、資本公積轉增資配股(元/股)',
  '除權交易日',
  '配股總股數(股)',
  '配股總金額(元)',
  '配股總股數佔盈餘配股總股數之比例(%)',
  '員工紅利配股率',
  '盈餘分配之股東現金股利(元/股)',
  '法定盈餘公積、資本公積發放之現金(元/股)',
  '除息交易日',
  '現金股利發放日',
  '員工紅利總金額(元)',
  '現金增資總股數(股)',
  '現金增資認股比率(%)',
  '現金增資認購價(元/股)',
  '董監酬勞(元)',
  '公告日期',
  '公告時間',
  '普通股每股面額'
);
var i0,i,i2,i3,i32,i4,i5,i6:integer; sInput:string;
  tsAry:array[0..7] of TStringlist;
  sTempAry:array[0..12] of string;
  sDatAry:array[0..22] of string; iIdxDatAry:array[0..22] of integer;

  function IsHeadTr(aInputHtml:string):boolean;
  begin
    result:=( (Pos('class=tblHead',aInputHtml)>0) and
               (Pos('</th>',aInputHtml)>0) and
               (Pos('<tr',aInputHtml)>0) 
            ) 
  end;
  function IndexOfFiledPos(aInputCaption:string):integer;
  var xi:integer;
  begin
    result:=-1;
    for xi:=0 to High(_FiledsDefine) do
    begin
      if SameText(_FiledsDefine[xi],aInputCaption) then
      begin
        result:=xi;
        exit;
      end;
    end;
  end;
begin
  tsOutPut.clear; tsOutPut2.clear; 
  FLastErrMsg := '';
  Result := 0;

  sInput:=MemoTxt;
  sInput:=StringReplace(sInput,chr(39)+'table01'+chr(39),'table01',[rfReplaceAll]);
  sInput:=StringReplace(sInput,'"table01"','table01',[rfReplaceAll]);
  sInput:=StringReplace(sInput,chr(39)+'hasBorder'+chr(39),'hasBorder',[rfReplaceAll]);
  sInput:=StringReplace(sInput,'"hasBorder"','hasBorder',[rfReplaceAll]);
  sInput:=StringReplace(sInput,chr(39)+'tblHead'+chr(39),'tblHead',[rfReplaceAll]);
  sInput:=StringReplace(sInput,'"tblHead"','tblHead',[rfReplaceAll]);
  sInput:=StringReplace(sInput,#13#10,'',[rfReplaceAll]);
  sInput:=StringReplace(sInput,'<div',#13#10+'<div',[rfReplaceAll]);


  if (Pos('<適用停止過戶期間規定之公司>',sInput)<=0) and
     (Pos('<不適用停止過戶期間規定之公司>',sInput)<=0)  then
  begin
    FLastErrMsg := ('沒有目標數據');
    exit;
  end;

  for i0:=0 to High(tsAry) do
    tsAry[i0]:=TStringList.Create;
  Try
  Try
    //gettext
    if Length(sInput)>0 then
      tsAry[0].Text:=sInput
    else exit;
    for i:=0 to tsAry[0].Count-1 do
    begin
      sTempAry[0]:=Trim(tsAry[0].Strings[i]);
      if sTempAry[0]='' then Continue;
      if not ( (Pos('<div id=table01',sTempAry[0])>0) ) then
        Continue;
      sTempAry[0]:=StringReplace(sTempAry[0],'<table',#13#10+'<table',[rfReplaceAll]);
      sTempAry[0]:=StringReplace(sTempAry[0],'</table>','</table>'+#13#10,[rfReplaceAll]);
      tsAry[1].Text:=sTempAry[0];
      //查找目標table
      for i2:=0 to tsAry[1].Count-1 do
      begin
        sTempAry[1]:=Trim(tsAry[1].Strings[i2]);
        if sTempAry[1]='' then Continue;
        if not ( (Pos('<table class=hasBorder',sTempAry[1])>0) ) then
          Continue;
        for i0:=0 to High(iIdxDatAry) do
          iIdxDatAry[i0]:=-1;

        sTempAry[12]:='';
        if (i2-1>=0) and (i2-1<tsAry[1].Count) then
        begin
          sTempAry[11]:=Trim(tsAry[1].Strings[i2-1]);
          if (Pos('<適用停止過戶期間規定之公司>',sTempAry[11])>0) then
            sTempAry[12]:='0'
          else if (Pos('<不適用停止過戶期間規定之公司>',sTempAry[11])>0) then
            sTempAry[12]:='1';
        end;
        if sTempAry[12]='' then
        begin
          FLastErrMsg := ('非目標數據  網頁源碼可能已經發生變化');
          continue;
        end;
        
        sTempAry[1]:=StringReplace(sTempAry[1],'<tr',#13#10+'<tr',[rfReplaceAll]);
        tsAry[2].Text:=sTempAry[1];
        //查找目標tr
        for i3:=0 to tsAry[2].Count-1 do
        begin
          sTempAry[2]:=Trim(tsAry[2].Strings[i3]);
          if sTempAry[2]='' then Continue;
          if ( (Pos('<tr',sTempAry[2])<=0) 
            ) then
            Continue;

          if IsHeadTr(sTempAry[2]) then
          begin
            //--整理標題存儲位置
            for i0:=0 to High(iIdxDatAry) do
              iIdxDatAry[i0]:=-1;

            tsAry[7].clear;
            for i32:=i3 to tsAry[2].Count-1 do
            begin
              sTempAry[5]:=Trim(tsAry[2].Strings[i32]);
              if sTempAry[5]='' then Continue;
              if not IsHeadTr(sTempAry[5]) then
                break;
              tsAry[7].Add(sTempAry[5]);
              tsAry[2].Strings[i32]:='';
            end;
            GetColListOfHtml(tsAry[7].text,sTempAry[6]);
            tsAry[7].text:=sTempAry[6];
            i5:=-1;
            tsAry[6].Clear;
            for i32:=0 to tsAry[7].count-1 do
            begin
              sTempAry[7]:=tsAry[7][i32];
              if sTempAry[7]='' then Continue;
              if tsAry[6].IndexOf(sTempAry[7])<>-1 then
              begin
                FLastErrMsg := ('重複名稱的欄位'+'('+sTempAry[7]+')');
                exit;
              end;
              tsAry[6].Add(sTempAry[7]);

              i6:=IndexOfFiledPos(sTempAry[7]);
              if i6=-1 then
              begin
                FLastErrMsg := ('未預定義的欄位'+'('+sTempAry[7]+')'+sTempAry[6]);
                exit;
              end;
              Inc(i5);
              if i5>High(iIdxDatAry) then
              begin
                FLastErrMsg := ('欄位數目超出預定義'+'('+sTempAry[7]+')'+sTempAry[6]);
                exit;
              end;
              iIdxDatAry[i5]:=i6;//iIdxDatAry[index]的數值對應寫入到 sDatAry 的位置
            end;
          end
          else begin
            for i0:=0 to High(sDatAry) do
              sDatAry[i0]:=_NullValue;
            //分解目標字段
            sTempAry[2]:=StringReplace(sTempAry[2],'<td',#13#10+'<td',[rfReplaceAll]);
            sTempAry[2]:=StringReplace(sTempAry[2],'</td>','</td>'+#13#10,[rfReplaceAll]);
            tsAry[3].Text:=sTempAry[2];
            i5:=-1;
            for i4:=0 to tsAry[3].count-1 do
            begin
              sTempAry[6]:=Trim(tsAry[3].Strings[i4]);
              if ( (Pos('<td',sTempAry[6])>0) and
                   (Pos('</td>',sTempAry[6])>0)
                ) then
              begin
                sTempAry[7]:=GetStrOnly2('>','</td>',sTempAry[6],false);
                sTempAry[7]:=StringReplace(sTempAry[7],'&NBSP;','',[rfReplaceAll]);
                sTempAry[7]:=StringReplace(sTempAry[7],'&nbsp;','',[rfReplaceAll]);
                Inc(i5);
                i6:=iIdxDatAry[i5];
                if i6=-1 then
                begin
                  FLastErrMsg := ('數據沒有對應的欄位'+sTempAry[6]);
                  exit;
                end;
                sDatAry[i6]:=sTempAry[7];
              end;
            end;
            sTempAry[3]:='';
            for i0:=0 to High(sDatAry) do
            begin
              if i0=1 then sDatAry[i0]:=sTempAry[12];
              sDatAry[i0]:=ProValueItem(sDatAry[i0]);
              if i0=0 then sTempAry[3]:=sDatAry[i0]
              else sTempAry[3]:=sTempAry[3]+_FiledSep+sDatAry[i0];
            end;
            tsOutPut.Add(sTempAry[3]);
            //代碼+股利日期+序號+公告日期+公告時間 開頭，方便後面的排序和比較
            sTempAry[3]:=sDatAry[0]+_FiledSep+
                      sDatAry[3]+_FiledSep+_CompareSep+
                      CIFmt(iIdxStart)+_FiledSep+_CompareSep2+
                      sDatAry[20]+_FiledSep+
                      sDatAry[21]+_FiledSep+_CompareSep3+
                      sTempAry[12]+_FiledSep+
                      sDatAry[2]+_FiledSep+
                      sDatAry[4]+_FiledSep+
                      sDatAry[5]+_FiledSep+
                      sDatAry[6]+_FiledSep+
                      sDatAry[7]+_FiledSep+
                      sDatAry[8]+_FiledSep+
                      sDatAry[9]+_FiledSep+
                      sDatAry[10]+_FiledSep+
                      sDatAry[11]+_FiledSep+
                      sDatAry[12]+_FiledSep+
                      sDatAry[13]+_FiledSep+
                      sDatAry[14]+_FiledSep+
                      sDatAry[15]+_FiledSep+
                      sDatAry[16]+_FiledSep+
                      sDatAry[17]+_FiledSep+
                      sDatAry[18]+_FiledSep+
                      sDatAry[19]+_FiledSep+
                      sDatAry[22];
            tsOutPut2.Add(sTempAry[3]);
            Inc(iIdxStart);
          end;

        end;//查找目標tr
      end;////查找目標table
    end;
    Result := tsOutPut.count;
    //Result := Trunc(tsOutPut.count/17);
  Except
     On E:Exception Do
       FLastErrMsg := (E.Message);
  End;
  Finally
    for i0:=0 to High(tsAry) do
      FreeAndNil(tsAry[i0]);
  End;
end;

function TAMainFrm.StartGet3(aDate:string): Boolean;
const _FiledSep=';';
     _CompareSep='#CompareSep#';
     _CompareSep2='#CompareSep2#';
     _CompareSep3='#CompareSep3#';

var i,i0,i2,iStartIdx,iPos1,iPos2,j : integer; iYear,iMonth,iYearHis,iMonthHis,iDay,iY,iM: Word;
  sOneFile,sDownUrl,ResultStr,vErrMsg,sLine,sFmtUrlStockWeight:String;
  sAryText:array[0..2] of string;  sAryItem:array[0..7] of string;
  tsAry:array[0..11] of TStringList;
  iOpTag: integer;//0追加當前記錄;1忽略當前記錄;2替換歷史記錄
  iRecTag: integer;//0存在歷史資料;1當前列表中存在相同key資料

  function GetHisData:Boolean;
  const BlockSize=50;
  var iThisYear,iLastYear:integer; xi,xj,Remain,ReadCount,GotCount : Integer;
    xf: File  of TWeightAssignRec; xsFiles:_cStrLst; xs,xs2,xs3:string;
    xr: array[0..BlockSize-1] of TWeightAssignRec;
  begin
    result:=false;
    iThisYear:=YearOf(Date)-1911;
    iLastYear:=iThisYear-1;
    tsAry[5].Clear;
    tsAry[7].Clear;
    tsAry[9].Clear;
    
    xs:=FTrlDBPath+'CBData\'+_stockweightdir+_stockweightF;
    FolderAllFiles(FTrlDBPath+'CBData\'+_stockweightdir,'.dat',xsFiles,False);
    for xi:=0 to High(xsFiles) do
    begin
      if SameText(ExtractFileName(xsFiles[xi]),ExtractFileName(_stockweightDelF)) then
        Continue;
      if FileExists(xsFiles[xi]) then
      begin
        try
          AssignFile(xf,xsFiles[xi]);
          FileMode := 0;
          ReSet(xf);
          ReMain := FileSize(xf);
          while ReMain>0 do
          Begin
             if Remain<BlockSize then ReadCount := ReMain
             Else ReadCount := BlockSize;
             BlockRead(xf,xr,ReadCount,GotCount);
             For xj:=0 to GotCount-1 do
             Begin
               with xr[xj] do
               begin
                 xs3:= Code+_FiledSep+
                      IntToStr(DatType)+_FiledSep+
                      IntToStr(BelongYear)+_FiledSep+
                      FmtTwDt2(WeightAssignDate)+_FiledSep+
                      CFFmt(YYZZZPG)+_FiledSep+
                      CFFmt(FDYYGJ_ZBGJZZZPG)+_FiledSep+
                      FmtTwDt2(DivRightDate)+_FiledSep+
                      CFFmt(PGZGS)+_FiledSep+
                      CFFmt(PGZGE)+_FiledSep+
                      CFFmt(PGZGSRate)+_FiledSep+
                      CFFmt(YGHLRate)+_FiledSep+
                      CFFmt(YYFPGDGL)+_FiledSep+
                      CFFmt(FDYYGJ_ZBGJFFXJ)+_FiledSep+
                      FmtTwDt2(DivWeigthDate)+_FiledSep+
                      FmtTwDt2(XJGLDate)+_FiledSep+
                      CFFmt(YGGLZJE)+_FiledSep+
                      CFFmt(XJZZZGS)+_FiledSep+
                      CFFmt(XJZZRate)+_FiledSep+
                      CFFmt(XJZZRGJ)+_FiledSep+
                      CFFmt(DZFee)+_FiledSep+
                      FmtTwDt2(DocDate)+_FiledSep+
                      FormatDateTime('hh:mm:ss',DocTime)+_FiledSep+
                      trim(MGME);
                 tsAry[5].Add(xs3);
                 //代碼+股利日期+序號+公告日期+公告時間 開頭，方便後面的排序和比較
                 xs3:= Code+_FiledSep+
                      FmtTwDt2(WeightAssignDate)+_FiledSep+_CompareSep+
                      CIFmt(Sq)+_FiledSep+_CompareSep2+
                      FmtTwDt2(DocDate)+_FiledSep+
                      FormatDateTime('hh:mm:ss',DocTime)+_FiledSep+_CompareSep3+
                      IntToStr(DatType)+_FiledSep+
                      IntToStr(BelongYear)+_FiledSep+
                      CFFmt(YYZZZPG)+_FiledSep+
                      CFFmt(FDYYGJ_ZBGJZZZPG)+_FiledSep+
                      FmtTwDt2(DivRightDate)+_FiledSep+
                      CFFmt(PGZGS)+_FiledSep+
                      CFFmt(PGZGE)+_FiledSep+
                      CFFmt(PGZGSRate)+_FiledSep+
                      CFFmt(YGHLRate)+_FiledSep+
                      CFFmt(YYFPGDGL)+_FiledSep+
                      CFFmt(FDYYGJ_ZBGJFFXJ)+_FiledSep+
                      FmtTwDt2(DivWeigthDate)+_FiledSep+
                      FmtTwDt2(XJGLDate)+_FiledSep+
                      CFFmt(YGGLZJE)+_FiledSep+
                      CFFmt(XJZZZGS)+_FiledSep+
                      CFFmt(XJZZRate)+_FiledSep+
                      CFFmt(XJZZRGJ)+_FiledSep+
                      CFFmt(DZFee)+_FiledSep+
                      (MGME);
                 tsAry[7].Add(xs3);
               end;
             End;
             Remain:=Remain-GotCount;
          End;
          if tsAry[5].count>0 then
            tsAry[5].sort;
        finally
          try CloseFile(xf); except end;
        end;
      end;
    end;

    xs:=FTrlDBPath+'CBData\'+_stockweightdir+_stockweightDelF;
    if FileExists(xs) then
      begin
        try
          AssignFile(xf,xs);
          FileMode := 0;
          ReSet(xf);
          ReMain := FileSize(xf);
          while ReMain>0 do
          Begin
             if Remain<BlockSize then ReadCount := ReMain
             Else ReadCount := BlockSize;
             BlockRead(xf,xr,ReadCount,GotCount);
             For xj:=0 to GotCount-1 do
             Begin
               with xr[xj] do
               begin
                 xs3:= Code+_FiledSep+
                      FmtTwDt2(WeightAssignDate)+_FiledSep+_CompareSep+
                      CIFmt(Sq)+_FiledSep+_CompareSep2+
                      FmtTwDt2(DocDate)+_FiledSep+
                      FormatDateTime('hh:mm:ss',DocTime)+_FiledSep+_CompareSep3+
                      IntToStr(DatType)+_FiledSep+
                      IntToStr(BelongYear)+_FiledSep+
                      CFFmt(YYZZZPG)+_FiledSep+
                      CFFmt(FDYYGJ_ZBGJZZZPG)+_FiledSep+
                      FmtTwDt2(DivRightDate)+_FiledSep+
                      CFFmt(PGZGS)+_FiledSep+
                      CFFmt(PGZGE)+_FiledSep+
                      CFFmt(PGZGSRate)+_FiledSep+
                      CFFmt(YGHLRate)+_FiledSep+
                      CFFmt(YYFPGDGL)+_FiledSep+
                      CFFmt(FDYYGJ_ZBGJFFXJ)+_FiledSep+
                      FmtTwDt2(DivWeigthDate)+_FiledSep+
                      FmtTwDt2(XJGLDate)+_FiledSep+
                      CFFmt(YGGLZJE)+_FiledSep+
                      CFFmt(XJZZZGS)+_FiledSep+
                      CFFmt(XJZZRate)+_FiledSep+
                      CFFmt(XJZZRGJ)+_FiledSep+
                      CFFmt(DZFee)+_FiledSep+
                      (MGME);
                 tsAry[9].Add(xs3);
               end;
             End;
             Remain:=Remain-GotCount;
          End;
          if tsAry[9].count>0 then
            tsAry[9].sort;
        finally
          try CloseFile(xf); except end;
        end;
      end;
    result:=true;
  end; 

  function GetSubUrlText(aInputUrl,aHint:string):boolean;
  var x1:integer; xb:Boolean; xstr1,xstr2:string;
  begin
    Result:=false;
    //HTTP.Intercept := LogDebug;
    ShowURL(aInputUrl);
    xb:=False;
    for x1:=1 to 3 do
    begin
      if StopRunning then
        exit;
      if DownloadFile2(aInputUrl,ResultStr,vErrMsg) then  
      //if GetHttpTextByUrl(aInputUrl,ResultStr,vErrMsg) then
        if not (  ( Pos('404 Not Found',vErrMsg)>0 ) or
           ( Pos('404 Not Found',ResultStr)>0 )  )  Then
         if Length(ResultStr)>0 Then
         begin
           Result:=true;
           xb:= true;
           xstr2:=UTF8Decode(ResultStr);
           if xstr2<>'' then
             ResultStr:=xstr2;
           xstr2:=ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\DownIndustry\'+Format('%d_%d',[iY,iM])+'_'+Get_GUID8+'.log';
           if GDebug then
           begin
              SetTextByTs(xstr2,ResultStr);
           end;
           exit;
         end;
      if StopRunning then
        exit;
      SleepWait(3);
    end;
    if not xb then
    begin
        ShowMsgEx('(warn)'+aHint+'網頁取得失敗');
        exit;
    end;
  end;

  function DoDownText(aFmtUrl,aInputHint:string;var aFrequence:Boolean):Boolean;
  var xb:boolean; xstr1,xstr2:string;
  begin
      result:=false; aFrequence:=false;
      sDownUrl:=aFmtUrl;
      xb:=GetSubUrlText(sDownUrl,aInputHint);
      if xb then
      begin
        if Pos('查詢過於頻繁',ResultStr)>0 then
        begin
          xb:=false;
          aFrequence:=true;
          SaveMsg('(warn)'+'query frequently.'+sDownUrl);
        end;
      end
      else begin
        SaveMsg('(warn)'+'down fail.'+sDownUrl);
      end;
      result:=xb;
  end;
  function SleepAWhile(aInputSecond:integer):boolean;
  var x1:integer;
  begin
    result:=false;
    for x1:=1 to aInputSecond do
    begin
      StatusBar1.Panels[2].Text := Format('休眠s(%d/%d)...',[x1,aInputSecond]);
      SleepWait(1);
      if StopRunning then
        Exit;
    end;
    result:=true;
  end;
  function DoDownTextEx(aFmtUrl,aInputHint:string):Boolean;
  var aFrequence,xb:Boolean; x1:Integer;
  begin
    result:=false;
    for x1:=1 to FDownTryTimes do
    begin
      if StopRunning then
        exit;
      xb:=DoDownText(aFmtUrl,aInputHint,aFrequence);
      if not xb then
      begin
        if aFrequence then
        begin
          SaveMsg('查詢過於頻繁');
          StatusBar1.Panels[1].Text := Format('查詢過於頻繁(%d/%d)',[x1,FDownTryTimes]);
          SleepAWhile(FSleepWhenFrequence);
          StatusBar1.Panels[2].Text := '';
          StatusBar1.Panels[1].Text := '';
        end
        else SleepAWhile(10);
      end
      else begin
        result:=True;
        break;
      end;
    end;
  end;

  function GetPartTwoData(aInputLine:string;var aOutPart1,aOutPart2:string):boolean;
  var xi1,xi2:integer;
  begin
    aOutPart1:=''; aOutPart2:='';
    xi1:=Pos(_CompareSep,aInputLine);
    if xi1>0 then
      aOutPart1:=Copy(aInputLine,1,xi1-1);
    xi2:=Pos(_CompareSep2,aInputLine);
    if xi2>0 then
      aOutPart2:=Copy(aInputLine,xi2+length(_CompareSep2),Length(aInputLine));
    if (aOutPart1='') or (aOutPart2='') then
    begin
      raise Exception.Create('GetPartTwoData fail.'+aInputLine);
    end;
    aOutPart1:=StringReplace(aOutPart1,',','',[rfReplaceAll]);
    aOutPart2:=StringReplace(aOutPart2,',','',[rfReplaceAll]);
  end;

  function GetPartThreeData(aInputLine:string;var aOutPart1,aOutPart2,aOutPart3:string):boolean;
  var xi1,xi2:integer;
  begin
    aOutPart1:=''; aOutPart2:=''; aOutPart3:='';
    xi1:=Pos(_CompareSep,aInputLine);
    if xi1>0 then
      aOutPart1:=Copy(aInputLine,1,xi1-1);
    xi2:=Pos(_CompareSep2,aInputLine);
    if xi2>0 then
      aOutPart2:=Copy(aInputLine,xi2+length(_CompareSep2),Length(aInputLine));  
    aOutPart3:=GetStrOnly2(_CompareSep2,_CompareSep3,aInputLine,false);
    if (aOutPart1='') or (aOutPart2='') or (aOutPart3='') then
    begin
      raise Exception.Create('GetPartThreeData fail.'+aInputLine);
    end;
    aOutPart1:=StringReplace(aOutPart1,',','',[rfReplaceAll]);
    aOutPart2:=StringReplace(aOutPart2,',','',[rfReplaceAll]);
    aOutPart3:=StringReplace(aOutPart3,',','',[rfReplaceAll]);
  end;

  procedure TsAddDatLine(aInputNew:boolean;aInputLine:string;var tsInput:TStringList);
  begin
    if aInputNew then 
      aInputLine:=StringReplace(aInputLine,_CompareSep,_CompareSep+'new',[rfReplaceAll])
    else
      aInputLine:=StringReplace(aInputLine,_CompareSep,_CompareSep+'old',[rfReplaceAll]);
    tsInput.Add(aInputLine);
  end;

  function CvtOfF(aInputStr:string):string;
  var xf:Double;
  begin
    result:=aInputStr;
    if aInputStr='' then
      exit;
    xf:=CFSEx(aInputStr);
    result:=CFFmt(xf);
  end;
  function CvtOfDT(aInputStr:string):string;
  var xf:TDate;
  begin
    if aInputStr='-' then
      aInputStr:='';
    result:=aInputStr;
    if aInputStr='' then
      exit;
    xf:=TwDateStrToDate(aInputStr);
    result:=FmtTwDt2(xf);
  end;
  procedure ProOfThePart2(var aInputPart2:string);
  var xi:integer; xStrLst2:_cStrLst2; xstr,xsrcstr:string;
  begin
    xsrcstr:=aInputPart2;
    xsrcstr:=StringReplace(xsrcstr,_CompareSep3,'',[rfReplaceAll]);
    xStrLst2:=DoStrArray2_2(xsrcstr,_FiledSep);
    if length(xStrLst2)=21 then
    begin
      xstr:=CvtOfDT(xStrLst2[0])+_FiledSep+
            xStrLst2[1]+_FiledSep+
            xStrLst2[2]+_FiledSep+
            xStrLst2[3]+_FiledSep+
            CvtOfF(xStrLst2[4])+_FiledSep+
            CvtOfF(xStrLst2[5])+_FiledSep+
            CvtOfDT(xStrLst2[6])+_FiledSep+
            CvtOfF(xStrLst2[7])+_FiledSep+
            CvtOfF(xStrLst2[8])+_FiledSep+
            CvtOfF(xStrLst2[9])+_FiledSep+
            CvtOfF(xStrLst2[10])+_FiledSep+
            CvtOfF(xStrLst2[11])+_FiledSep+
            CvtOfF(xStrLst2[12])+_FiledSep+
            CvtOfDT(xStrLst2[13])+_FiledSep+
            CvtOfDT(xStrLst2[14])+_FiledSep+
            CvtOfF(xStrLst2[15])+_FiledSep+
            CvtOfF(xStrLst2[16])+_FiledSep+
            CvtOfF(xStrLst2[17])+_FiledSep+
            CvtOfF(xStrLst2[18])+_FiledSep+
            CvtOfF(xStrLst2[19])+_FiledSep+
            xStrLst2[20];
      aInputPart2:=xstr;
    end;
    setlength(xStrLst2,0);
  end;

  function MakeAnDown():boolean;
  var xi:integer; xInputSrc:string;
  begin
      result:=False;
      sDownUrl:=sFmtUrlStockWeight;
      xInputSrc:='';
      sDownUrl:=StringReplace(sDownUrl,'%year%',IntToStr(iY-1911),[rfReplaceAll]);
      sDownUrl:=StringReplace(sDownUrl,'%month%',IntToStr(iM),[rfReplaceAll]);
      sDownUrl:=StringReplace(sDownUrl,'%typek%','sii',[rfReplaceAll]);
      sDownUrl:=sDownUrl+'&tickcount='+inttostr(GetTickCount);
      if not DoDownTextEx(sDownUrl,'股利分派資料 sii'+Format('%d.%d',[iY,iM])) then
        exit;
      xInputSrc:=ResultStr;

      tsAry[0].clear;
      tsAry[1].clear;
      if Pos('查無符合條件之資料',xInputSrc)<=0 then
      if (_GetGuLiTitlesCount(xInputSrc,vErrMsg,iStartIdx,tsAry[0],tsAry[1])=0) or
        (vErrMsg<>'') then
      begin
        SetWarnMsg3(Format('%d.%d',[iY,iM])+'解析股利分派資料失敗.'+vErrMsg);
        exit;
      end;
      for xi:=0 to tsAry[0].count-1 do
        tsAry[4].Add(tsAry[0][xi]);
      for xi:=0 to tsAry[1].count-1 do
        tsAry[6].Add(tsAry[1][xi]);
      SleepAWhile(FSleepPerStkCode);

      sDownUrl:=sFmtUrlStockWeight;
      xInputSrc:='';
      sDownUrl:=StringReplace(sDownUrl,'%year%',IntToStr(iY-1911),[rfReplaceAll]);
      sDownUrl:=StringReplace(sDownUrl,'%month%',IntToStr(iM),[rfReplaceAll]);
      sDownUrl:=StringReplace(sDownUrl,'%typek%','otc',[rfReplaceAll]);
      sDownUrl:=sDownUrl+'&tickcount='+inttostr(GetTickCount);
      if not GetSubUrlText(sDownUrl,'股利分派資料 otc'+Format('%d.%d',[iY,iM])) then
        exit;
      xInputSrc:=ResultStr;

      tsAry[0].clear;
      tsAry[1].clear;
      if Pos('查無符合條件之資料',xInputSrc)<=0 then 
      if (_GetGuLiTitlesCount(xInputSrc,vErrMsg,iStartIdx,tsAry[0],tsAry[1])=0) or
        (vErrMsg<>'') then
      begin
        SetWarnMsg3(Format('%d.%d',[iY,iM])+'解析股利分派資料失敗.'+vErrMsg);
        exit;
      end;
      for xi:=0 to tsAry[0].count-1 do
        tsAry[4].Add(tsAry[0][xi]);
      for xi:=0 to tsAry[1].count-1 do
        tsAry[6].Add(tsAry[1][xi]);
      SleepAWhile(FSleepPerStkCode); 
      result:=true;
  end;
begin
  Result := false;
  ShowMsgEx('開始取得股利分派資料網頁...');
  if StopRunning Then exit;
  try
  try
    for i0:=0 to High(tsAry) do
      tsAry[i0]:=TStringList.create;
    GetHisData;
    DecodeDate(date, iYear, iMonth, iDay);
    iStartIdx:=0;

    if (FstockweightHisMode=1) and (FstockweightHisYears>0) then
    begin
      sFmtUrlStockWeight:=FUrl3;
      //sFmtUrlStockWeight:=StringReplace(sFmtUrlStockWeight,'&month=%month%','&month=',[]);
      //sFmtUrlStockWeight:=StringReplace(sFmtUrlStockWeight,'b_date=01&e_date=31','b_date=&e_date=',[]);

      //iYearHis:=iYear-FstockweightHisYears;
      iYearHis:=FstockweightHisYears;
      for i0:=iYearHis to iYearHis do
      begin
        {iY:=i0;
        iM:=0;
        showsb(1,Format('year=%d...',[iY]));
        if not MakeAnDown then
          exit;}
        if i0=iYear then iMonthHis:=iMonth
        else iMonthHis:=12;
        for i:=1 to iMonthHis do
        begin
          iY:=i0;
          iM:=i;
          showsb(1,Format('year,month=%d,%d...',[iY,iM]));
          if not MakeAnDown then
              exit;
        end;
      end;
    end
    else begin
      sFmtUrlStockWeight:=FUrl3;
      for i:=2 downto 0 do
      begin
        sDownUrl:=FUrl3;
        case iMonth-i of
          -1:begin
            iY:=iYear-1;
            iM:=11;
          end;
          0:begin
            iY:=iYear-1;
            iM:=12;
          end;
          else begin
            iY:=iYear;
            iM:=iMonth-i;
          end;
        end;
        showsb(1,Format('year,month=%d,%d...',[iY,iM]));
        if not MakeAnDown then
            exit;
      end;
    end;
    
    //先保存一份解析出來的原始文檔，供以後備查之用
    sOneFile:=DataFile3(FmtDt8(date));
    sOneFile:=ChangeFileExt(sOneFile,FmtDt8(date)+ExtractFileExt(sOneFile));
    if not DirectoryExists(ExtractFilePath(sOneFile))  then
      Mkdir_Directory(ExtractFilePath(sOneFile));
    tsAry[4].SaveToFile(sOneFile);

    ShowMsgEx('執行資料比對...',false);
    tsAry[6].Sort;
    tsAry[7].Sort;
    //先將線上已經存在的資料刪除
    for i:=0 to tsAry[6].count-1 do
    begin
      sAryItem[0]:=tsAry[6][i];
      GetPartTwoData(sAryItem[0],sAryItem[1],sAryItem[2]);
      ProOfThePart2(sAryItem[2]);
      for j:=0 to tsAry[7].count-1 do
      begin
        if Pos(sAryItem[1],tsAry[7][j])=1 then
        begin
          sAryItem[3]:=tsAry[7][j];
          GetPartTwoData(sAryItem[3],sAryItem[4],sAryItem[5]);
          sAryItem[5]:=StringReplace(sAryItem[5],_CompareSep3,'',[rfReplaceAll]);
          if (sAryItem[1]=sAryItem[4]) and (sAryItem[2]=sAryItem[5]) then
          begin
            tsAry[6][i]:='';
            Break;
          end;
        end;
      end;
    end;

    //將歷史刪除過的資料剔除
    for i:=0 to tsAry[6].count-1 do
    begin
      sAryItem[0]:=tsAry[6][i];
      if tsAry[6][i]='' then
        Continue;
      {if Pos('2465',sAryItem[0])=1 then
      begin
        WriteLineForApp('','');
      end;  }
      GetPartThreeData(sAryItem[0],sAryItem[1],sAryItem[3],sAryItem[2]);
      for j:=0 to tsAry[9].count-1 do
      begin
        if tsAry[9][j]='' then
          Continue;
        if Pos(sAryItem[1],tsAry[9][j])=1 then
        begin
          sAryItem[4]:=tsAry[9][j];
          GetPartThreeData(sAryItem[4],sAryItem[5],sAryItem[7],sAryItem[6]);
          if (sAryItem[1]=sAryItem[5]) and (sAryItem[3]=sAryItem[7]) then
          begin
            tsAry[6][i]:='';
            Break;
          end;
        end;
      end;
    end;

    //將代碼+權息分派基準日+公告日期+公告時間一樣的資料過濾，只保留最近一條
    for i:=0 to tsAry[6].count-1 do
    begin
      sAryItem[0]:=tsAry[6][i];
      if tsAry[6][i]='' then
        Continue;
      GetPartThreeData(sAryItem[0],sAryItem[1],sAryItem[3],sAryItem[2]);
      for j:=i+1 to tsAry[6].count-1 do
      begin
        if tsAry[6][j]='' then
          Continue;
        if Pos(sAryItem[1],tsAry[6][j])=1 then
        begin
          sAryItem[4]:=tsAry[6][j];
          GetPartThreeData(sAryItem[4],sAryItem[5],sAryItem[7],sAryItem[6]);
          if (sAryItem[1]=sAryItem[5]) and (sAryItem[2]=sAryItem[6]) then
          begin
            if sAryItem[3]>=sAryItem[7] then 
              tsAry[6][j]:=''
            else
              tsAry[6][i]:='';
            Break;
          end;
        end
        else break;
      end;
    end;
    i:=0; 
    while i<tsAry[6].count do
    begin
      if tsAry[6][i]='' then
      begin
         tsAry[6].Delete(i);
         Continue;
      end;  
      Inc(i);
    end;

    tsAry[8].clear;
    //再進行資料比對，生成更新的資料
    for i:=0 to tsAry[6].count-1 do
    begin
      sAryItem[0]:=tsAry[6][i];
      if Trim(sAryItem[0])='' then
        Continue;
      GetPartTwoData(sAryItem[0],sAryItem[1],sAryItem[2]);

      TsAddDatLine(True,tsAry[6][i],tsAry[8]);
      //--找該列表中是否有 代碼+日期 一致的記錄
      for j:=i+1 to tsAry[6].count-1 do
      begin
        if Trim(tsAry[6][j])='' then Continue;
        if Pos(sAryItem[1],tsAry[6][j])=1 then
        begin
          sAryItem[3]:=tsAry[6][j];
          GetPartTwoData(sAryItem[3],sAryItem[4],sAryItem[5]);
          if (sAryItem[1]=sAryItem[4]) then
          begin
            TsAddDatLine(true,tsAry[6][j],tsAry[8]);
            tsAry[6][j]:='';
          end;
        end
        else break;
      end;
      ProOfThePart2(sAryItem[2]);
      //--找線上列表中是否有 代碼+日期 一致的記錄
      for j:=0 to tsAry[7].count-1 do
      begin
        if Pos(sAryItem[1],tsAry[7][j])=1 then
        begin
          sAryItem[3]:=tsAry[7][j];
          GetPartTwoData(sAryItem[3],sAryItem[4],sAryItem[5]);
          if (sAryItem[1]=sAryItem[4]) then
          begin
            TsAddDatLine(false,tsAry[7][j],tsAry[8]);
          end;
        end;
      end;
    end;

    //---標記動作、資料狀態類型 ,并將“0存在歷史資料;1當前列表中存在相同key資料”放置於最前端
    tsAry[10].clear;
    tsAry[11].clear;
    for i:=0 to tsAry[8].count-1 do
    begin
      sLine:=tsAry[8][i];
      if sLine='' then
        Continue;

      iOpTag:=0;//0追加當前記錄;1忽略當前記錄;2替換歷史記錄
      iRecTag:=-1;//0存在歷史資料;1當前列表中存在相同key資料
      if Pos(_CompareSep+'new',sLine)>0 then
      begin
        sAryItem[0]:=sLine;
        GetPartThreeData(sAryItem[0],sAryItem[1],sAryItem[2],sAryItem[3]);
        for i2:=i-1 downto 0 do
        begin
          sAryItem[4]:=tsAry[8][i2];
          if sAryItem[4]='' then
            Continue;
          GetPartThreeData(sAryItem[4],sAryItem[5],sAryItem[6],sAryItem[7]);
          if sAryItem[1]<>sAryItem[5] then
          begin
            break;
          end;
          if sAryItem[3]<>sAryItem[7] then
          begin
            if Pos(_CompareSep+'old',sAryItem[4])>0  then
            begin
              //讓使用者決定如何操作//追加當前記錄
              iOpTag:=-1;
              iRecTag:=0;
            end
            else if Pos(_CompareSep+'new',sAryItem[4])>0 then
            begin
              //讓使用者決定如何操作//追加當前記錄
              iOpTag:=-1;
              iRecTag:=1;
            end;
          end
          else if sAryItem[3]=sAryItem[7] then
          begin
            if Pos(_CompareSep+'old',sAryItem[4])>0  then
            begin
              //直接更新
              iOpTag:=2;
              iRecTag:=-1;
              break;
            end
            else if Pos(_CompareSep+'new',sAryItem[4])>0 then
            begin
              //讓使用者決定如何操作
              iOpTag:=-1;
              iRecTag:=1;
            end;
          end;
        end;

        if not ((iOpTag=2) and (iRecTag=-1)) then
        begin
          for i2:=i+1 to tsAry[8].count-1 do
          begin
            sAryItem[4]:=tsAry[8][i2];
            if sAryItem[4]='' then
              Continue;
            GetPartThreeData(sAryItem[4],sAryItem[5],sAryItem[6],sAryItem[7]);
            if sAryItem[1]<>sAryItem[5] then
            begin
              break;
            end;
            if sAryItem[3]<>sAryItem[7] then
            begin
              if Pos(_CompareSep+'old',sAryItem[4])>0  then
              begin
                //讓使用者決定如何操作//追加當前記錄
                iOpTag:=-1;
                iRecTag:=0;
              end
              else if Pos(_CompareSep+'new',sAryItem[4])>0 then
              begin
                //讓使用者決定如何操作//追加當前記錄
                iOpTag:=-1;
                iRecTag:=1;
              end;
            end
            else if sAryItem[3]=sAryItem[7] then
            begin
              if Pos(_CompareSep+'old',sAryItem[4])>0  then
              begin
                //直接更新
                iOpTag:=2;
                iRecTag:=-1;
                break;
              end
              else if Pos(_CompareSep+'new',sAryItem[4])>0 then
              begin
                //讓使用者決定如何操作
                iOpTag:=-1;
                iRecTag:=1;
              end;
            end;
          end;
        end;

        if (iRecTag in [0,1]) or
           ((iOpTag=2) and (iRecTag=-1))  then
        begin
          tsAry[10].Add(tsAry[8][i]+_FiledSep+inttostr(iOpTag)+_FiledSep+inttostr(iRecTag));
        end
        else begin
          tsAry[11].Add(tsAry[8][i]+_FiledSep+inttostr(iOpTag)+_FiledSep+inttostr(iRecTag));
        end;
      end
      else begin
        tsAry[11].Add(tsAry[8][i]);
      end;
    end;
    tsAry[8].clear;
    tsAry[8].AddStrings(tsAry[10]);
    tsAry[8].AddStrings(tsAry[11]);

    sOneFile:=DataFile3(FmtDt8(date));
    tsAry[8].SaveToFile(sOneFile);
    ShowMsgEx('資料比對完成.',false);
    ShowMsg('',false);
    
    Result := true;
    if result then
    begin
      SaveMsg('內容成功取得');
      SetWarnMsg3('');
    end;
  Except
     On E:Exception do
     Begin
         ShowMsgEx(E.Message,false);
     End;
  End;
  finally
     for i0:=0 to High(tsAry) do
      FreeAndNil(tsAry[i0]);
     ShowURL('');
     StatusBar1.Panels[2].Text := '';
     showsb(-1,'');
  end;
end;


function TAMainFrm.StartGet2(aDate:string): Boolean;
var i,t,t1,t2,t3: integer; tsAry:array[0..6] of TStringList;
    aAryStkIndustry:TAryDim6Str; fini:TStringList;
    aSource,sItem,sCap,sDownUrl,ResultStr,vErrMsg : String;
    aIDLstMgr:TIDLstMgr;

  function GetSubUrlText(aInputUrl,aHint:string):boolean;
  var x1:integer; xb:Boolean;
  begin
    Result:=false;
    //HTTP.Intercept := LogDebug;
    ShowURL(aInputUrl);
    xb:=False;
    for x1:=1 to 3 do
    begin
      if StopRunning then
        exit;
      if DownloadFile2(aInputUrl,ResultStr,vErrMsg) then
      //if GetHttpTextByUrl(aInputUrl,ResultStr,vErrMsg) then
        if not (  ( Pos('404 Not Found',vErrMsg)>0 ) or
           ( Pos('404 Not Found',ResultStr)>0 )  )  Then
         if Length(ResultStr)>0 Then
         begin
           Result:=true;
           xb:= true;
           exit;
         end;
      if StopRunning then
        exit;
      SleepWait(3);
    end;
    if not xb then
    begin
        ShowMsgEx('(warn)'+aHint+'網頁取得失敗');
        exit;
    end;
  end;

  function DoDownText(aFmtUrl,aInCode,aInputHint:string;var aFrequence:Boolean):Boolean;
  var xb:boolean; xstr1,xstr2:string;
  begin
      result:=false; aFrequence:=false;

      sDownUrl:=aFmtUrl;
      sDownUrl:=StringReplace(sDownUrl,'%stkcode%',aInCode,[]);
      xstr2:=ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\DownIndustry\'+aInCode+'_'+Get_GUID8+'.log';
      xb:=GetSubUrlText(sDownUrl,aInCode+' '+aInputHint);
      if xb then
      begin
        xstr1:=ResultStr;
        if GDebug then
        begin
          SetTextByTs(xstr2,ResultStr);
        end;
        ResultStr:=UTF8Decode(ResultStr);
        if (ResultStr='') and (xstr1<>'') then
          ResultStr:=xstr1;
        if Pos('查詢過於頻繁',ResultStr)>0 then
        begin
          xb:=false;
          aFrequence:=true;
          SaveMsg('(warn)'+'query frequently.'+sDownUrl);
        end;
      end
      else begin
        SaveMsg('(warn)'+'down fail.'+sDownUrl);
      end;
      result:=xb;
  end;

  function SleepAWhile(aInputSecond:integer):boolean;
  var x1:integer;
  begin
    result:=false;
    for x1:=1 to aInputSecond do
    begin
      StatusBar1.Panels[2].Text := Format('休眠s(%d/%d)...',[x1,aInputSecond]);
      SleepWait(1);
      if StopRunning then
        Exit;
    end;
    result:=true;
  end;
  
  function DoDownTextEx(aFmtUrl,aInCode,aInputHint:string):Boolean;
  var aFrequence,xb:Boolean; x1:Integer;
  begin
    result:=false;
    for x1:=1 to FDownTryTimes do
    begin
      if StopRunning then
        exit;
      xb:=DoDownText(aFmtUrl,aInCode,aInputHint,aFrequence);
      StkBaseValueStatusCodeFromIni('','');
      if not xb then
      begin
        if aFrequence then
        begin
          SaveMsg('查詢過於頻繁');
          StatusBar1.Panels[1].Text := Format('查詢過於頻繁(%d/%d)',[x1,FDownTryTimes]);
          SleepAWhile(FSleepWhenFrequence);
          StatusBar1.Panels[2].Text := '';
          StatusBar1.Panels[1].Text := '';
        end
        else SleepAWhile(10);
      end
      else begin
        result:=True;
        break;
      end;
    end;
  end;

  Function GetNowPageTitlesCount3(Const MemoTxt:String):Integer;
  const _NullValue='NULLVALUE';
        _BanSep='---';
  var i0,i,i2,iHigh,iSq:integer;
    HtmlTxt0:TStringlist;
    StrLine0,StrLine,StrLine2,sInput,sCodeDatLog:String;
    AddressStr,CaptionStr,MktClass:String;
  begin
    SetLength(aAryStkIndustry,0);
    Result := 0;

    sInput:=MemoTxt;
    StrLine0:=GetStrOnly2('<table','</table>',MemoTxt,false);
    StrLine0:=StringReplace(StrLine0,chr(39),'',[rfReplaceAll]);
    StrLine0:=StringReplace(StrLine0,'"','',[rfReplaceAll]);
    MktClass:=GetStrOnly2('(','公司)',StrLine0,false);
    if (Pos('class=compName',StrLine0)<=0 ) or (MktClass='') then
    begin
      SaveMsg(sItem+'.無法解析上市別'+StrLine0);
      exit;
    end;
    sCodeDatLog:='';
    iHigh := High(aAryStkIndustry)+1;
    SetLength(aAryStkIndustry,iHigh+1);
    aAryStkIndustry[iHigh].Items[0]:='市場別';
    aAryStkIndustry[iHigh].Items[1]:=MktClass;
    aAryStkIndustry[iHigh].Items[2]:='0';
    sCodeDatLog:='市場別'+':'+MktClass;
  
    sInput:=StringReplace(sInput,#13#10,'',[rfReplaceAll]);
    sInput:=StringReplace(sInput,'<th',#13#10+'<th',[rfReplaceAll]);
    sInput:=StringReplace(sInput,'</table>','</table>'+#13#10,[rfReplaceAll]);
    HtmlTxt0:=TStringList.Create;
    Try
    Try
      if Length(sInput)>0 then
        HtmlTxt0.Text:=sInput
      else exit;
      for i0:=0 to HtmlTxt0.Count-1 do
      begin
        StrLine0:=Trim(HtmlTxt0.Strings[i0]);
        if not ( (Pos('<th',StrLine0)>0) and (Pos('</th>',StrLine0)>0) ) then
          Continue;
        iSq:=GetRowSpan(StrLine0);
        StrLine0:=ClsATagHtml('<th',StrLine0);
        CaptionStr:=GetStrOnly2('<th>','</th>',StrLine0,false);
        CaptionStr:=RplOfBr(CaptionStr,'');
        CaptionStr:=FileCtrlEnter(CaptionStr);
        if CaptionStr='' then
        begin
          ShowMsg(sItem+'.CaptionStr is null'+HtmlTxt0.Strings[i0]);
          continue;
        end;
        StrLine2:=GetStrOnly2('<th>','</th>',StrLine0,true);
        StrLine0:=StringReplace(StrLine0,StrLine2,'',[]);
        if Pos('</td>',StrLine0)>0 then
        begin
          StrLine0:=RplOfBr(StrLine0,'#13#10');
          StrLine0:=RmvHtmlTag2(StrLine0);
          StrLine0:=FileCtrlEnter(StrLine0);
          StrLine0:=StringReplace(StrLine0,'&nbsp;','',[rfReplaceAll]);
          StrLine0:=StringReplace(StrLine0,'&nbsp','',[rfReplaceAll]);
          StrLine0:=StringReplace(StrLine0,' ','',[rfReplaceAll]);
          StrLine0:=Trim(StrLine0);
        end
        else
          StrLine0:=_NullValue;
        sCodeDatLog:=sCodeDatLog+#13#10+CaptionStr+':'+StrLine0;
          
        iHigh := High(aAryStkIndustry)+1;
        SetLength(aAryStkIndustry,iHigh+1);
        aAryStkIndustry[iHigh].Items[0]:=CaptionStr;
        aAryStkIndustry[iHigh].Items[1]:=StrLine0;
        aAryStkIndustry[iHigh].Items[2]:=IntToStr(iSq);
      end;
      SaveMsg(sCodeDatLog);
      
      for i0:=0 to High(aAryStkIndustry) do
      begin
        if SameText(aAryStkIndustry[i0].Items[0],'本公司') and
           (i0+1<=High(aAryStkIndustry)) and
           SameText(aAryStkIndustry[i0+1].Items[0],'特別股發行') then
        begin
          aAryStkIndustry[i0].Items[0]:=aAryStkIndustry[i0+1].Items[0];//FTitleLst[i0].Caption+'(?)'+
          aAryStkIndustry[i0+1].Items[0]:='';
        end
        else if SameText(aAryStkIndustry[i0].Items[0],'本公司') and
           (i0+1<=High(aAryStkIndustry)) and
           SameText(aAryStkIndustry[i0+1].Items[0],'公司債發行') then
        begin
          aAryStkIndustry[i0].Items[0]:=aAryStkIndustry[i0+1].Items[0];//FTitleLst[i0].Caption+'(?)'+
          aAryStkIndustry[i0+1].Items[0]:='';
        end
        else if SameText(aAryStkIndustry[i0].Items[0],'本公司採') and
           (i0+1<=High(aAryStkIndustry)) and
           SameText(aAryStkIndustry[i0+1].Items[0],'月制會計年度（空白表曆年制）') then
        begin
          aAryStkIndustry[i0].Items[0]:='採(?)'+aAryStkIndustry[i0+1].Items[0];
          aAryStkIndustry[i0+1].Items[0]:='';
        end
        else if SameText(aAryStkIndustry[i0].Items[0],'本公司於') and
           (i0+2<=High(aAryStkIndustry)) and
           SameText(aAryStkIndustry[i0+1].Items[0],'之前採') and
           SameText(aAryStkIndustry[i0+2].Items[0],'月制會計年度') then
        begin
          aAryStkIndustry[i0].Items[0]:='於(?)'+aAryStkIndustry[i0+1].Items[0]+'(?)'+aAryStkIndustry[i0+2].Items[0];
          aAryStkIndustry[i0].Items[1]:=aAryStkIndustry[i0].Items[1]+'   '+aAryStkIndustry[i0+1].Items[1];
          aAryStkIndustry[i0+1].Items[0]:='';
          aAryStkIndustry[i0+2].Items[0]:='';
        end;
      end;
    
      for i0:=0 to High(aAryStkIndustry) do
      begin
        if (aAryStkIndustry[i0].Items[0]<>'') and
           (StrToInt(aAryStkIndustry[i0].Items[2])>1) and
           SameText(aAryStkIndustry[i0].Items[1],_NullValue) then
        begin
          i2:=0;
          for i:=i0+1 to High(aAryStkIndustry) do
          begin
            if i2<StrToInt(aAryStkIndustry[i0].Items[2]) then
            begin
              if (aAryStkIndustry[i].Items[0]<>'') and
                 (StrToInt(aAryStkIndustry[i].Items[2])<=1) and
                 (not SameText(aAryStkIndustry[i].Items[1],_NullValue)) then
              begin
                aAryStkIndustry[i].Items[0]:=aAryStkIndustry[i0].Items[0]+_BanSep+aAryStkIndustry[i].Items[0];
                Inc(i2);
              end
              else begin
                // 類似1783的情形， “產業風險特性描述(非屬科技事業，不適用)”需要與上面一欄交換位置
                if (i-1>=0) and
                   (   (aAryStkIndustry[i-1].Items[0]<>'') and
                       (StrToInt(aAryStkIndustry[i-1].Items[2])<=1) and
                       (not SameText(aAryStkIndustry[i].Items[1],_NullValue)) and
                       (Pos(_BanSep,aAryStkIndustry[i-1].Items[0])>0)
                   )then
                begin
                  SwapTDim6Str(aAryStkIndustry[i-1],aAryStkIndustry[i]);
                end;
              end;
            end
            else break;
          end;
          aAryStkIndustry[i0].Items[0]:='';
        end;
      end;
      Result := High(aAryStkIndustry)+1;
    Except
       on E:Exception do
       begin
         ShowMsg(sItem+'.GetNowPageTitlesCount3 e:'+E.Message);
       end;
    End;
    Finally
      if Assigned(HtmlTxt0)then
        HtmlTxt0.Free;
    End;
  end;

  function SaveCodeData(aInputCode:string):boolean;
  var sVarTmpFile,sVarTmpFile2:string; xi:integer; xfini:TiniFile; xTs,xTs2,xfini2:TStringList;  xb:Boolean;
  begin
    result:=false;
    sVarTmpFile:=DataFile2(FmtDt8(date));
    sVarTmpFile:=ChangeFileExt(sVarTmpFile,'.tmp');
    if Trim(aInputCode)='' then
      exit;
    if tsAry[5].Count>0 then
    begin
      xTs:=nil; xfini:=nil;
      xTs2:=nil; xfini2:=nil;

      try
        xTs:=TStringList.create;
        xfini:=TiniFile.create(sVarTmpFile);

        xfini.EraseSection('MktClass');
          for xi:=0 to tsAry[1].count-1 do
            xfini.WriteString('MktClass',IntToStr(xi),tsAry[1][xi]);

        xfini.EraseSection('CYB2');
          for xi:=0 to tsAry[2].count-1 do
            xfini.WriteString('CYB2',IntToStr(xi),tsAry[2][xi]);
            
        xfini.EraseSection('Fields');
          for xi:=0 to tsAry[3].count-1 do
            xfini.WriteString('Fields',IntToStr(xi),tsAry[3][xi]);

        xfini.EraseSection(aInputCode);
        xTs.clear;
        xTs.LoadFromFile(sVarTmpFile);
        xTs.Add('['+aInputCode+']');
        for xi:=0 to tsAry[5].count-1 do
        begin
          xTs.Add( tsAry[5][xi] );
        end;
        xTs.SaveToFile(sVarTmpFile);

        //--與tr1db中的資料進行比對，以決定標示狀態
        xb:=false;
        sVarTmpFile2:=FTrlDBPath+'CBData\data\'+_cbbaseinfoF;
        if FileExists(sVarTmpFile2) then
        begin
          xTs2:=TStringList.create;
          xfini2:=TStringList.create;
          xfini2.LoadFromFile(sVarTmpFile2);
          TsIniReadSectionValues(0,xfini2,aInputCode,xTs2);
          if SameText(tsAry[5].text,xTs2.text) then
            xb:=true
          else begin
            if GDebug then
            begin
              tsAry[5].SaveToFile(ExtractFilePath(ParamStr(0))+'Data\DwnDocLog\DownIndustry\'+aInputCode+'_change0_'+Get_GUID8+'.log');
              xTs2.SaveToFile(ExtractFilePath(ParamStr(0))+'Data\DwnDocLog\DownIndustry\'+aInputCode+'_change1_'+Get_GUID8+'.log');
            end;
          end;
        end;

        {if xb then
          StkBaseValueStatusCodeFromIni(aInputCode,_CNoNeedShen)
        else}
          StkBaseValueStatusCodeFromIni(aInputCode,_CXiaOK);
        result:=true;
      finally
        try if Assigned(xTs) then FreeAndNil(xTs); except end;
        try if Assigned(xfini) then FreeAndNil(xfini); except end;
        try if Assigned(xTs2) then FreeAndNil(xTs2); except end;
        try if Assigned(xfini2) then FreeAndNil(xfini2); except end;
      end;

    end;
  end;

  function RefershCodeStatusList:boolean;
  var sVarTmpFile:string; xfini:TiniFile;
  begin
    result:=false;
    tsAry[6].Clear;
    sVarTmpFile:=StkBaseLstFile;
    if not FileExists(sVarTmpFile) then
      exit;
    xfini:=TiniFile.create(sVarTmpFile);
    try
      xfini.ReadSectionValues('list',tsAry[6]);
      result:=true;
    finally
      FreeAndNil(xfini);
    end;
  end;
  function IsNeedDown(aInputCode:string):boolean;
  var sVarTmpFile:string;
  begin
    result:=true;
    if (tsAry[6].IndexOf(aInputCode+'='+_CXiaOK)>=0) or
       (tsAry[6].IndexOf(aInputCode+'='+_CNoNeedShen)>=0) or
       (tsAry[6].IndexOf(aInputCode+'='+_CNoCodeExists)>=0) then
    begin
      result:=false;
    end;
  end;
begin
  Result := false;
  if StopRunning Then exit;
  ShowMsgEx(Format('開始取得公司基本資料...',[]));
  if not GetCodeList then
  begin
    exit;
  end;
  if FIDLstMgr.Count=0 then
  begin
    result:=true;
    exit;
  end; 
  showsb(1,'');
  try
  try
    for t:=0 to High(tsAry) do
      tsAry[t]:=TStringList.create;
    RefershCodeStatusList;
    sDownUrl:=FTrlDBPath+'CBData\data\'+_cbbaseinfoF;
    if FileExists(sDownUrl) then
    begin
      fini:=TStringList.create;
      fini.LoadFromFile(sDownUrl);
      tsAry[1].clear;
      tsAry[0].clear;
      TsIniReadSectionValues(0,fini,'MktClass',tsAry[0]);
      for t:=0 to tsAry[0].count-1 do
      begin
        sItem:=Trim(tsAry[0][t]);
        if GetFieldValue(sItem,ResultStr,vErrMsg) then
        begin
          if not SameText('count',ResultStr) then
            tsAry[1].Add(vErrMsg);
        end;
      end;
      tsAry[2].clear;
      tsAry[0].clear;
      TsIniReadSectionValues(0,fini,'CYB2',tsAry[0]);
      for t:=0 to tsAry[0].count-1 do
      begin
        sItem:=Trim(tsAry[0][t]);
        if GetFieldValue(sItem,ResultStr,vErrMsg) then
        begin
          if not SameText('count',ResultStr) then
            tsAry[2].Add(vErrMsg);
        end;
      end;
      tsAry[3].clear;
      tsAry[0].clear;
      TsIniReadSectionValues(0,fini,'Fields',tsAry[0]);
      for t:=0 to tsAry[0].count-1 do
      begin
        sItem:=Trim(tsAry[0][t]);
        if GetFieldValue(sItem,ResultStr,vErrMsg) then
        begin
          if not SameText('count',ResultStr) then
            tsAry[3].Add(vErrMsg);
        end;
      end;
    end;

    for t:=0 to FIDLstMgr.Count-1 do
    begin
      if StopRunning then
        exit;
      sItem:=Trim(FIDLstMgr[t]);
      showsb(1,Format('取得公司基本資料(%d/%d %s)...',[t+1,FIDLstMgr.Count,sItem]));
      SaveMsg(Format('取得公司基本資料(%d/%d %s)...',[t+1,FIDLstMgr.Count,sItem]));
      if sItem='' then
        Continue;
      if not IsNeedDown(sItem) then
        Continue;
      sDownUrl:=FUrl2;
      if not DoDownTextEx(sDownUrl,sItem,'') then
      begin
        Continue;
      end;
      if (Pos('公司代號輸入錯誤',ResultStr)>0) or
         (Pos('公司不存在',ResultStr)>0) or
         (Pos('代號不存在',ResultStr)>0) or
         (Pos('上市公司已下市',ResultStr)>0) or
         (Pos('不繼續公開發行',ResultStr)>0) then
      begin
        ShowMsg(sItem+'.公司不存在');
        StkBaseValueStatusCodeFromIni(sItem,_CNoCodeExists);
        Continue;
      end;
      tsAry[5].clear;
      if GetNowPageTitlesCount3(ResultStr)>0 then
      begin
        for i:=0 to High(aAryStkIndustry) do
        begin
          sCap:=aAryStkIndustry[i].Items[0];
          if sCap<>'' then
          begin
            //tsAry[5]中為當前代碼的數據列表：  標題索引號=內容
            //--查看其在標題列表tsAry[3]中是否存在，若不存在則加入，并獲取標題索引號碼
            t2:=tsAry[3].IndexOf(sCap);
            if t2=-1 then
              t2:=tsAry[3].Add(sCap);

            //--查看"市場別"標題之內容位於列表tsAry[1]中是否存在，若不存在則加入，并獲取索引號碼
            if SameText(sCap,'市場別') then
            begin
              t1:=tsAry[1].IndexOf(aAryStkIndustry[i].Items[1]);
              if t1=-1 then
                t1:=tsAry[1].Add(aAryStkIndustry[i].Items[1]);
              tsAry[5].Add(Format('%d=%d',[t2,t1]));
            end
            //--查看"產業類別"標題之內容位於列表tsAry[2]中是否存在，若不存在則加入，并獲取索引號碼
            else if SameText(sCap,'產業類別') then
            begin
              t1:=tsAry[2].IndexOf(aAryStkIndustry[i].Items[1]);
              if t1=-1 then
                t1:=tsAry[2].Add(aAryStkIndustry[i].Items[1]);
              tsAry[5].Add(Format('%d=%d',[t2,t1]));
            end
            else begin
              tsAry[5].Add(Format('%d=%s',[t2,aAryStkIndustry[i].Items[1]]));
            end;
          end;
        end;
        //tsAry[4]中所有代碼的數據列表： [代碼] 標題索引號=內容
        if tsAry[5].Count>0 then
        begin
          SaveCodeData(sItem);
          //tsAry[4].Add(Format('[%s]',[sItem]));
          //for i:=0 to tsAry[5].count-1 do
          //  tsAry[4].Add(tsAry[5][i]);
        end;
      end;
      SaveMsg(sItem+' ok.');
      SleepAWhile(FSleepPerStkCode); 
    end;//for idlist each

    //-檢查是否全部下載完成
    RefershCodeStatusList;
    i:=0;
    for t:=0 to FIDLstMgr.Count-1 do
    begin
      if StopRunning then
        exit;
      sItem:=Trim(FIDLstMgr[t]);
      if sItem='' then
        Continue;
      if IsNeedDown(sItem) then
      begin
        Inc(i);
        break;
      end;
    end;
    if i=0 then
    begin
      sItem:=DataFile2(FmtDt8(date));
      sDownUrl:=ChangeFileExt(sItem,'.tmp');
      if CopyFile(PChar(sDownUrl),PChar(sItem),false) or (not FileExists(sDownUrl)) then
      begin
        DelDatF(sDownUrl);
        result:=true;
        SaveMsg('內容成功取得');
      end;
    end;
  Except
     On E:Exception do
     Begin
       ShowMsgEx(E.Message,false);
     End;
  End;
  finally
     for t:=0 to High(tsAry) do
      FreeAndNil(tsAry[t]);
     try SetLength(aAryStkIndustry,0);  except end;
     ShowURL('');
     StatusBar1.Panels[2].Text := '';
     showsb(-1,'');
  end;
end;


function TAMainFrm.StartGet2OfWeek(aDate:string): Boolean;
var i,t,t1,t2,t3: integer; tsAry:array[0..6] of TStringList;
    aAryStkIndustry:TAryDim6Str; fini:TStringList;
    aSource,sItem,sCap,sDownUrl,ResultStr,vErrMsg : String;
    aIDLstMgr:TIDLstMgr;

  function GetSubUrlText(aInputUrl,aHint:string):boolean;
  var x1:integer; xb:Boolean;
  begin
    Result:=false;
    //HTTP.Intercept := LogDebug;
    ShowURL(aInputUrl);
    xb:=False;
    for x1:=1 to 3 do
    begin
      if StopRunning then
        exit;
      if DownloadFile2(aInputUrl,ResultStr,vErrMsg) then
      //if GetHttpTextByUrl(aInputUrl,ResultStr,vErrMsg) then
        if not (  ( Pos('404 Not Found',vErrMsg)>0 ) or
           ( Pos('404 Not Found',ResultStr)>0 )  )  Then
         if Length(ResultStr)>0 Then
         begin
           Result:=true;
           xb:= true;
           exit;
         end;
      if StopRunning then
        exit;
      SleepWait(3);
    end;
    if not xb then
    begin
        ShowMsgEx('(warn)'+aHint+'網頁取得失敗');
        exit;
    end;
  end;

  function DoDownText(aFmtUrl,aInCode,aInputHint:string;var aFrequence:Boolean):Boolean;
  var xb:boolean; xstr1,xstr2:string;
  begin
      result:=false; aFrequence:=false;

      sDownUrl:=aFmtUrl;
      sDownUrl:=StringReplace(sDownUrl,'%stkcode%',aInCode,[]);
      sDownUrl:=sDownUrl+'&tick='+FormatDateTime('yyyymmddhhmmss',now);
      xstr2:=ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\DownIndustry\'+aInCode+'_'+Get_GUID8+'.log';
      xb:=GetSubUrlText(sDownUrl,aInCode+' '+aInputHint);
      if xb then
      begin
        xstr1:=ResultStr;
        if GDebug then
        begin
          SetTextByTs(xstr2,ResultStr);
        end;
        ResultStr:=UTF8Decode(ResultStr);
        if (ResultStr='') and (xstr1<>'') then
          ResultStr:=xstr1;
        if Pos('查詢過於頻繁',ResultStr)>0 then
        begin
          xb:=false;
          aFrequence:=true;
          SaveMsg('(warn)'+'query frequently.'+sDownUrl);
        end;
      end
      else begin
        SaveMsg('(warn)'+'down fail.'+sDownUrl);
      end;
      result:=xb;
  end;

  function SleepAWhile(aInputSecond:integer):boolean;
  var x1:integer;
  begin
    result:=false;
    for x1:=1 to aInputSecond do
    begin
      StatusBar1.Panels[2].Text := Format('休眠s(%d/%d)...',[x1,aInputSecond]);
      SleepWait(1);
      if StopRunning then
        Exit;
    end;
    result:=true;
  end;
  
  function DoDownTextEx(aFmtUrl,aInCode,aInputHint:string):Boolean;
  var aFrequence,xb:Boolean; x1:Integer;
  begin
    result:=false;
    for x1:=1 to FDownTryTimes do
    begin
      if StopRunning then
        exit;
      xb:=DoDownText(aFmtUrl,aInCode,aInputHint,aFrequence);
      StkBaseValueStatusCodeFromIniOfWeek('','');
      if not xb then
      begin
        if aFrequence then
        begin
          SaveMsg('查詢過於頻繁');
          StatusBar1.Panels[1].Text := Format('查詢過於頻繁(%d/%d)',[x1,FDownTryTimes]);
          SleepAWhile(FSleepWhenFrequence);
          StatusBar1.Panels[2].Text := '';
          StatusBar1.Panels[1].Text := '';
        end
        else SleepAWhile(10);
      end
      else begin
        result:=True;
        break;
      end;
    end;
  end;

  Function GetNowPageTitlesCount3(Const MemoTxt:String):Integer;
  const _NullValue='NULLVALUE';
        _BanSep='---';
  var i0,i,i2,iHigh,iSq:integer;
    HtmlTxt0:TStringlist;
    StrLine0,StrLine,StrLine2,sInput,sCodeDatLog:String;
    AddressStr,CaptionStr,MktClass:String;
  begin
    SetLength(aAryStkIndustry,0);
    Result := 0;

    sInput:=MemoTxt;
    StrLine0:=GetStrOnly2('<table','</table>',MemoTxt,false);
    StrLine0:=StringReplace(StrLine0,chr(39),'',[rfReplaceAll]);
    StrLine0:=StringReplace(StrLine0,'"','',[rfReplaceAll]);
    MktClass:=GetStrOnly2('(','公司)',StrLine0,false);
    if (Pos('class=compName',StrLine0)<=0 ) or (MktClass='') then
    begin
      SaveMsg(sItem+'.無法解析上市別'+StrLine0);
      exit;
    end;
    sCodeDatLog:='';
    iHigh := High(aAryStkIndustry)+1;
    SetLength(aAryStkIndustry,iHigh+1);
    aAryStkIndustry[iHigh].Items[0]:='市場別';
    aAryStkIndustry[iHigh].Items[1]:=MktClass;
    aAryStkIndustry[iHigh].Items[2]:='0';
    sCodeDatLog:='市場別'+':'+MktClass;
  
    sInput:=StringReplace(sInput,#13#10,'',[rfReplaceAll]);
    sInput:=StringReplace(sInput,'<th',#13#10+'<th',[rfReplaceAll]);
    sInput:=StringReplace(sInput,'</table>','</table>'+#13#10,[rfReplaceAll]);
    HtmlTxt0:=TStringList.Create;
    Try
    Try
      if Length(sInput)>0 then
        HtmlTxt0.Text:=sInput
      else exit;
      for i0:=0 to HtmlTxt0.Count-1 do
      begin
        StrLine0:=Trim(HtmlTxt0.Strings[i0]);
        if not ( (Pos('<th',StrLine0)>0) and (Pos('</th>',StrLine0)>0) ) then
          Continue;
        iSq:=GetRowSpan(StrLine0);
        StrLine0:=ClsATagHtml('<th',StrLine0);
        CaptionStr:=GetStrOnly2('<th>','</th>',StrLine0,false);
        CaptionStr:=RplOfBr(CaptionStr,'');
        CaptionStr:=FileCtrlEnter(CaptionStr);
        if CaptionStr='' then
        begin
          ShowMsg(sItem+'.CaptionStr is null'+HtmlTxt0.Strings[i0]);
          continue;
        end;
        StrLine2:=GetStrOnly2('<th>','</th>',StrLine0,true);
        StrLine0:=StringReplace(StrLine0,StrLine2,'',[]);
        if Pos('</td>',StrLine0)>0 then
        begin
          StrLine0:=RplOfBr(StrLine0,'#13#10');
          StrLine0:=RmvHtmlTag2(StrLine0);
          StrLine0:=FileCtrlEnter(StrLine0);
          StrLine0:=StringReplace(StrLine0,'&nbsp;','',[rfReplaceAll]);
          StrLine0:=StringReplace(StrLine0,'&nbsp','',[rfReplaceAll]);
          StrLine0:=StringReplace(StrLine0,' ','',[rfReplaceAll]);
          StrLine0:=Trim(StrLine0);
        end
        else
          StrLine0:=_NullValue;
        sCodeDatLog:=sCodeDatLog+#13#10+CaptionStr+':'+StrLine0;
          
        iHigh := High(aAryStkIndustry)+1;
        SetLength(aAryStkIndustry,iHigh+1);
        aAryStkIndustry[iHigh].Items[0]:=CaptionStr;
        aAryStkIndustry[iHigh].Items[1]:=StrLine0;
        aAryStkIndustry[iHigh].Items[2]:=IntToStr(iSq);
      end;
      SaveMsg(sCodeDatLog);
      
      for i0:=0 to High(aAryStkIndustry) do
      begin
        if SameText(aAryStkIndustry[i0].Items[0],'本公司') and
           (i0+1<=High(aAryStkIndustry)) and
           SameText(aAryStkIndustry[i0+1].Items[0],'特別股發行') then
        begin
          aAryStkIndustry[i0].Items[0]:=aAryStkIndustry[i0+1].Items[0];//FTitleLst[i0].Caption+'(?)'+
          aAryStkIndustry[i0+1].Items[0]:='';
        end
        else if SameText(aAryStkIndustry[i0].Items[0],'本公司') and
           (i0+1<=High(aAryStkIndustry)) and
           SameText(aAryStkIndustry[i0+1].Items[0],'公司債發行') then
        begin
          aAryStkIndustry[i0].Items[0]:=aAryStkIndustry[i0+1].Items[0];//FTitleLst[i0].Caption+'(?)'+
          aAryStkIndustry[i0+1].Items[0]:='';
        end
        else if SameText(aAryStkIndustry[i0].Items[0],'本公司採') and
           (i0+1<=High(aAryStkIndustry)) and
           SameText(aAryStkIndustry[i0+1].Items[0],'月制會計年度（空白表曆年制）') then
        begin
          aAryStkIndustry[i0].Items[0]:='採(?)'+aAryStkIndustry[i0+1].Items[0];
          aAryStkIndustry[i0+1].Items[0]:='';
        end
        else if SameText(aAryStkIndustry[i0].Items[0],'本公司於') and
           (i0+2<=High(aAryStkIndustry)) and
           SameText(aAryStkIndustry[i0+1].Items[0],'之前採') and
           SameText(aAryStkIndustry[i0+2].Items[0],'月制會計年度') then
        begin
          aAryStkIndustry[i0].Items[0]:='於(?)'+aAryStkIndustry[i0+1].Items[0]+'(?)'+aAryStkIndustry[i0+2].Items[0];
          aAryStkIndustry[i0].Items[1]:=aAryStkIndustry[i0].Items[1]+'   '+aAryStkIndustry[i0+1].Items[1];
          aAryStkIndustry[i0+1].Items[0]:='';
          aAryStkIndustry[i0+2].Items[0]:='';
        end;
      end;
    
      for i0:=0 to High(aAryStkIndustry) do
      begin
        if (aAryStkIndustry[i0].Items[0]<>'') and
           (StrToInt(aAryStkIndustry[i0].Items[2])>1) and
           SameText(aAryStkIndustry[i0].Items[1],_NullValue) then
        begin
          i2:=0;
          for i:=i0+1 to High(aAryStkIndustry) do
          begin
            if i2<StrToInt(aAryStkIndustry[i0].Items[2]) then
            begin
              if (aAryStkIndustry[i].Items[0]<>'') and
                 (StrToInt(aAryStkIndustry[i].Items[2])<=1) and
                 (not SameText(aAryStkIndustry[i].Items[1],_NullValue)) then
              begin
                aAryStkIndustry[i].Items[0]:=aAryStkIndustry[i0].Items[0]+_BanSep+aAryStkIndustry[i].Items[0];
                Inc(i2);
              end
              else begin
                // 類似1783的情形， “產業風險特性描述(非屬科技事業，不適用)”需要與上面一欄交換位置
                if (i-1>=0) and
                   (   (aAryStkIndustry[i-1].Items[0]<>'') and
                       (StrToInt(aAryStkIndustry[i-1].Items[2])<=1) and
                       (not SameText(aAryStkIndustry[i].Items[1],_NullValue)) and
                       (Pos(_BanSep,aAryStkIndustry[i-1].Items[0])>0)
                   )then
                begin
                  SwapTDim6Str(aAryStkIndustry[i-1],aAryStkIndustry[i]);
                end;
              end;
            end
            else break;
          end;
          aAryStkIndustry[i0].Items[0]:='';
        end;
      end;
      Result := High(aAryStkIndustry)+1;
    Except
       on E:Exception do
       begin
         ShowMsg(sItem+'.GetNowPageTitlesCount3 e:'+E.Message);
       end;
    End;
    Finally
      if Assigned(HtmlTxt0)then
        HtmlTxt0.Free;
    End;
  end;

  function SaveCodeData(aInputCode:string):boolean;
  var sVarTmpFile,sVarTmpFile2:string; xi:integer; xfini:TiniFile; xTs,xTs2,xfini2:TStringList;  xb:Boolean;
  begin
    result:=false;
    sVarTmpFile:=DataFile2OfWeek();
    sVarTmpFile:=ChangeFileExt(sVarTmpFile,'.tmp');
    if Trim(aInputCode)='' then
      exit;
    if tsAry[5].Count>0 then
    begin
      xTs:=nil; xfini:=nil;
      xTs2:=nil; xfini2:=nil;

      try
        xTs:=TStringList.create;
        xfini:=TiniFile.create(sVarTmpFile);

        xfini.EraseSection('MktClass');
          for xi:=0 to tsAry[1].count-1 do
            xfini.WriteString('MktClass',IntToStr(xi),tsAry[1][xi]);

        xfini.EraseSection('CYB2');
          for xi:=0 to tsAry[2].count-1 do
            xfini.WriteString('CYB2',IntToStr(xi),tsAry[2][xi]);
            
        xfini.EraseSection('Fields');
          for xi:=0 to tsAry[3].count-1 do
            xfini.WriteString('Fields',IntToStr(xi),tsAry[3][xi]);

        xfini.EraseSection(aInputCode);
        xTs.clear;
        xTs.LoadFromFile(sVarTmpFile);
        xTs.Add('['+aInputCode+']');
        for xi:=0 to tsAry[5].count-1 do
        begin
          xTs.Add( tsAry[5][xi] );
        end;
        xTs.SaveToFile(sVarTmpFile);

        //--與tr1db中的資料進行比對，以決定標示狀態
        xb:=false;
        sVarTmpFile2:=FTrlDBPath+'CBData\data\'+_cbbaseinfoF;
        if FileExists(sVarTmpFile2) then
        begin
          xTs2:=TStringList.create;
          xfini2:=TStringList.create;
          xfini2.LoadFromFile(sVarTmpFile2);
          TsIniReadSectionValues(0,xfini2,aInputCode,xTs2);
          if SameText(tsAry[5].text,xTs2.text) then
            xb:=true
          else begin
            if GDebug then
            begin
              tsAry[5].SaveToFile(ExtractFilePath(ParamStr(0))+'Data\DwnDocLog\DownIndustry\'+aInputCode+'_change0_'+Get_GUID8+'.log');
              xTs2.SaveToFile(ExtractFilePath(ParamStr(0))+'Data\DwnDocLog\DownIndustry\'+aInputCode+'_change1_'+Get_GUID8+'.log');
            end;
          end;
        end;

        if xb then
          StkBaseValueStatusCodeFromIniOfWeek(aInputCode,_CNoNeedShen)
        else
          StkBaseValueStatusCodeFromIniOfWeek(aInputCode,_CXiaOK);
        result:=true;
      finally
        try if Assigned(xTs) then FreeAndNil(xTs); except end;
        try if Assigned(xfini) then FreeAndNil(xfini); except end;
        try if Assigned(xTs2) then FreeAndNil(xTs2); except end;
        try if Assigned(xfini2) then FreeAndNil(xfini2); except end;
      end;

    end;
  end;

  function RefershCodeStatusList:boolean;
  var sVarTmpFile:string; xfini:TiniFile;
  begin
    result:=false;
    tsAry[6].Clear;
    sVarTmpFile:=StkBaseLstFileOfWeek;
    if not FileExists(sVarTmpFile) then
      exit;
    xfini:=TiniFile.create(sVarTmpFile);
    try
      xfini.ReadSectionValues('list',tsAry[6]);
      result:=true;
    finally
      FreeAndNil(xfini);
    end;
  end;
  function IsNeedDown(aInputCode:string):boolean;
  var sVarTmpFile:string;
  begin
    result:=true;
    if (tsAry[6].IndexOf(aInputCode+'='+_CXiaOK)>=0) or
       (tsAry[6].IndexOf(aInputCode+'='+_CNoNeedShen)>=0) or
       (tsAry[6].IndexOf(aInputCode+'='+_CNoCodeExists)>=0) then
    begin
      result:=false;
    end;
  end;
begin
  Result := false;
  if StopRunning Then exit;
  ShowMsgEx(Format('開始取得公司基本資料(每週)...',[]));
  if not GetCodeListOfWeek then
  begin
    exit;
  end;
  showsb(1,'');
  try
  try
    for t:=0 to High(tsAry) do
      tsAry[t]:=TStringList.create;
    RefershCodeStatusList;
    sDownUrl:=FTrlDBPath+'CBData\data\'+_cbbaseinfoF;
    if FileExists(sDownUrl) then
    begin
      fini:=TStringList.create;
      fini.LoadFromFile(sDownUrl);
      tsAry[1].clear;
      tsAry[0].clear;
      TsIniReadSectionValues(0,fini,'MktClass',tsAry[0]);
      for t:=0 to tsAry[0].count-1 do
      begin
        sItem:=Trim(tsAry[0][t]);
        if GetFieldValue(sItem,ResultStr,vErrMsg) then
        begin
          if not SameText('count',ResultStr) then
            tsAry[1].Add(vErrMsg);
        end;
      end;
      tsAry[2].clear;
      tsAry[0].clear;
      TsIniReadSectionValues(0,fini,'CYB2',tsAry[0]);
      for t:=0 to tsAry[0].count-1 do
      begin
        sItem:=Trim(tsAry[0][t]);
        if GetFieldValue(sItem,ResultStr,vErrMsg) then
        begin
          if not SameText('count',ResultStr) then
            tsAry[2].Add(vErrMsg);
        end;
      end;
      tsAry[3].clear;
      tsAry[0].clear;
      TsIniReadSectionValues(0,fini,'Fields',tsAry[0]);
      for t:=0 to tsAry[0].count-1 do
      begin
        sItem:=Trim(tsAry[0][t]);
        if GetFieldValue(sItem,ResultStr,vErrMsg) then
        begin
          if not SameText('count',ResultStr) then
            tsAry[3].Add(vErrMsg);
        end;
      end;
    end;

    for t:=0 to FIDLstMgr.Count-1 do
    begin
      if StopRunning then
        exit;
      sItem:=Trim(FIDLstMgr[t]);
      showsb(1,Format('取得公司基本資料(每週)(%d/%d %s)...',[t+1,FIDLstMgr.Count,sItem]));
      SaveMsg(Format('取得公司基本資料(每週)(%d/%d %s)...',[t+1,FIDLstMgr.Count,sItem]));
      if sItem='' then
        Continue;
      if not IsNeedDown(sItem) then
        Continue;
      sDownUrl:=FUrl2;
      if not DoDownTextEx(sDownUrl,sItem,'') then
      begin
        Continue;
      end;
      if (Pos('公司代號輸入錯誤',ResultStr)>0) or
         (Pos('公司不存在',ResultStr)>0) or
         (Pos('代號不存在',ResultStr)>0) or
         (Pos('上市公司已下市',ResultStr)>0) or
         (Pos('不繼續公開發行',ResultStr)>0) then
      begin
        ShowMsg(sItem+'.公司不存在');
        StkBaseValueStatusCodeFromIniOfWeek(sItem,_CNoCodeExists);
        Continue;
      end;
      tsAry[5].clear;
      if GetNowPageTitlesCount3(ResultStr)>0 then
      begin
        for i:=0 to High(aAryStkIndustry) do
        begin
          sCap:=aAryStkIndustry[i].Items[0];
          if sCap<>'' then
          begin
            //tsAry[5]中為當前代碼的數據列表：  標題索引號=內容
            //--查看其在標題列表tsAry[3]中是否存在，若不存在則加入，并獲取標題索引號碼
            t2:=tsAry[3].IndexOf(sCap);
            if t2=-1 then
              t2:=tsAry[3].Add(sCap);

            //--查看"市場別"標題之內容位於列表tsAry[1]中是否存在，若不存在則加入，并獲取索引號碼
            if SameText(sCap,'市場別') then
            begin
              t1:=tsAry[1].IndexOf(aAryStkIndustry[i].Items[1]);
              if t1=-1 then
                t1:=tsAry[1].Add(aAryStkIndustry[i].Items[1]);
              tsAry[5].Add(Format('%d=%d',[t2,t1]));
            end
            //--查看"產業類別"標題之內容位於列表tsAry[2]中是否存在，若不存在則加入，并獲取索引號碼
            else if SameText(sCap,'產業類別') then
            begin
              t1:=tsAry[2].IndexOf(aAryStkIndustry[i].Items[1]);
              if t1=-1 then
                t1:=tsAry[2].Add(aAryStkIndustry[i].Items[1]);
              tsAry[5].Add(Format('%d=%d',[t2,t1]));
            end
            else begin
              tsAry[5].Add(Format('%d=%s',[t2,aAryStkIndustry[i].Items[1]]));
            end;
          end;
        end;
        //tsAry[4]中所有代碼的數據列表： [代碼] 標題索引號=內容
        if tsAry[5].Count>0 then
        begin
          SaveCodeData(sItem);
          //tsAry[4].Add(Format('[%s]',[sItem]));
          //for i:=0 to tsAry[5].count-1 do
          //  tsAry[4].Add(tsAry[5][i]);
        end;
      end;
      SaveMsg(sItem+' ok.');
      SleepAWhile(FSleepPerStkCode); 
    end;//for idlist each

    //-檢查是否全部下載完成
    RefershCodeStatusList;
    i:=0;
    for t:=0 to FIDLstMgr.Count-1 do
    begin
      if StopRunning then
        exit;
      sItem:=Trim(FIDLstMgr[t]);
      if sItem='' then
        Continue;
      if IsNeedDown(sItem) then
      begin
        Inc(i);
        break;
      end;
    end;
    if i=0 then
    begin
      sItem:=DataFile2OfWeek();
      sDownUrl:=ChangeFileExt(sItem,'.tmp');
      if CopyFile(PChar(sDownUrl),PChar(sItem),false) then
      begin
        DelDatF(sDownUrl);
        result:=true;
        SaveMsg('內容成功取得');
      end;
    end;
  Except
     On E:Exception do
     Begin
       ShowMsgEx(E.Message,false);
     End;
  End;
  finally
     for t:=0 to High(tsAry) do
      FreeAndNil(tsAry[t]);
     try SetLength(aAryStkIndustry,0);  except end;
     ShowURL('');
     StatusBar1.Panels[2].Text := '';
     showsb(-1,'');
  end;
end;

procedure TAMainFrm.RefrsehTime(s: Integer);
begin
  FEndTick := GetTickCount + Round(s*1000);
end;

function TAMainFrm.DataFile(aDate:string):string;
begin
  result := ExtractFilePath( FDataPath )+aDate+'\'+_IndustryF;
end;

function TAMainFrm.DataFile2(aDate:string):string;
begin
  result := ExtractFilePath( FDataPath )+aDate+'\'+_cbbaseinfoF;
end;

function TAMainFrm.DataFile2OfWeek():string;
begin
  result := ExtractFilePath( FDataPath )+'CompanyInfoDownWeekDay\'+FmtDt8(Date)+_cbbaseinfoF;
end;

function TAMainFrm.Data2IsWeekDay():boolean;
begin
  result:=false;
  if FCompanyInfoDownWeekDay>0 then
    if DayOfTheWeek(date)=FCompanyInfoDownWeekDay then
      result:=true;
end;

function TAMainFrm.DataFile3(aDate:string):string;
begin
  result := ExtractFilePath( FDataPath )+aDate+'\'+_stockweightF;
end;

function TAMainFrm.InWorkTime: Boolean;
begin
Result := ((Now-Date)>=FStartTime ) and
               ((Now-Date)<=FEndTime );
end;

function TAMainFrm.InWorkTime2: Boolean;
begin
  Result := ((Now-Date)>=FStartTime2 ) and
               ((Now-Date)<=FEndTime2 );
end;

function TAMainFrm.InWorkTime3: Boolean;
begin
  Result := ((Now-Date)>=FStartTime3 ) and
               ((Now-Date)<=FEndTime3 );
end;

function TAMainFrm.DownloadFile2(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
var
  tmpFile:String;
  ts:TStringList;
  i:integer;
  aRunThread:TFileDownLoadThread ;
begin
try
try
  Result := false;
  ts:=nil;
  //FMonitor:=TDownLoadMonitor.Create();
  AResultStr:= '';
  AErrMsg := '';
  //tmpFile := GetWinTempPath+Get_GUID8+'.txt';
  tmpFile := ExtractFilePath(ParamStr(0))+Get_GUID8+'.txt';

  //Result := UrlDownloadToFile(nil, PAnsiChar(AUrl),PAnsiChar(tmpFile), 0, FMonitor as IBindStatusCallback) = 0;
  //AMainFrm.StatusBar1.Panels[2].Text := '';
  AUrl := AUrl + Format('&skq=%d',[GetTickCount()]);
  aRunThread := TFileDownLoadThread.Create(AUrl,tmpFile, DownLoadProcessEvent,nil,nil, False);
  aRunThread.Resume;
   i := 0;
    While Not aRunThread.Finish do
    Begin
       if StopRunning Then
       Begin
           aRunThread.Terminate;
           aRunThread.WaitFor;
           Exit;
       End;
       SleepWait(1);
       Inc(i);
       if i > 20 then
       begin
         AErrMsg := 'Read timeout';
         exit;
       end;
    End;

  if not FileExists(tmpFile) then
  begin
    Result := false;
    exit;
  end;
  ts := TStringList.Create;
  ts.LoadFromFile(tmpFile);
  AResultStr := ts.Text;
  ///ChrConvert(AResultStr);
  //FreeAndNilEx(ts);

  Result := true;
except
  on e:Exception do
  begin
    Result := false;
    AErrMsg := e.Message;
    e := nil;
  end;
end;
finally
  try if assigned(ts) then FreeAndNil(ts); except end;
 // try FreeAndNil(FMonitor); except end;
  try
    aRunThread.Terminate;
    aRunThread.WaitFor;
    FreeAndNil(aRunThread);
  except
  end;
  for i:=1 to 5 do
  begin
    try
      if not FileExists(tmpFile) then break;
      DeleteFile(PChar(tmpFile));
    except
    end;
  end;
  StatusBar1.Panels[2].Text := '';
end;
end;

procedure TAMainFrm.DownLoadProcessEvent(
Sender: TFileDownLoadThread; Progress, ProgressMax: Cardinal;StatusCode: ULONG; StatusText: string);
const
  KB_Pagcakge=1024;
var iCurUnit:Single;
begin
    iCurUnit := Progress/KB_Pagcakge;
    if Progress=0 then StatusBar1.Panels[2].Text := Format('StatusCode:%d  %s',[StatusCode,StatusText])
    else StatusBar1.Panels[2].Text := Format('%.2n KB', [iCurUnit]);
end;


procedure TAMainFrm.ReadWindowPos;
var sSec,sFile:string; fini:TIniFile;
    iLeft,iTop,iHeight,iWidth:integer;
begin
  sFile:=ExtractFilePath(Application.ExeName)+'setup.ini';
  sSec:=CAppWindow;
  iLeft:=0; iTop:=0; iHeight:=0; iWidth:=0;
  if FileExists(sFile) then
  begin
    try
      fini:=TIniFile.Create(sFile);
      iLeft:=fini.ReadInteger(sSec,'Left',0);
      iTop:=fini.ReadInteger(sSec,'Top',0);
      iHeight:=fini.ReadInteger(sSec,'Height',0);
      iWidth:=fini.ReadInteger(sSec,'Width',0);
    finally
      FreeAndNil(fini);
    end;
  end;
  if //(iLeft>0) and
     //(iTop>0) and
     (iHeight>0) and
     (iWidth>0) then
  begin
    Self.Left:=iLeft;
    Self.Top:=iTop;
    Self.Height:=iHeight;
    Self.Width:=iWidth;
  end;
end;

procedure TAMainFrm.SaveWindowPos;
var sSec,sFile:string; fini:TIniFile;
    iLeft,iTop,iHeight,iWidth:integer;
begin
  sFile:=ExtractFilePath(Application.ExeName)+'setup.ini';
  sSec:=CAppWindow;
  iLeft:=Self.Left; iTop:=Self.Top; iHeight:=Self.Height; iWidth:=Self.Width;
  if FileExists(sFile) then
  begin
    try
      fini:=TIniFile.Create(sFile);
      fini.WriteInteger(sSec,'Left',iLeft);
      fini.WriteInteger(sSec,'Top',iTop);
      fini.WriteInteger(sSec,'Height',iHeight);
      fini.WriteInteger(sSec,'Width',iWidth);
    finally
      FreeAndNil(fini);
    end;
  end;
end;
procedure TAMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveWindowPos;
end;

procedure TAMainFrm.ClearSysLog;
var LogFileLst : _CStrLst;
  i:integer;
begin
try
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\DownIndustry\',
                 '.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if (DaySpan(now,GetFileDateTimeC(LogFileLst[i]))>30) then
      DeleteFile(LogFileLst[i]);
  End;
  SetLength(LogFileLst,0);
except
end;

try
  FolderAllFiles(FTrlDBPath+'CBData\TCRI\CloseIdList\',
                 '.lst',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if (DaySpan(now,GetFileDateTimeC(LogFileLst[i]))>30) then
      DeleteFile(LogFileLst[i]);
  End;
  SetLength(LogFileLst,0);
except
end;
end;

function TAMainFrm.StkBaseLstFile:string;
begin
  result:=FTrlDBPath+'CBData\TCRI\CloseIdList\'+FormatDateTime('yyyymmdd',date)+'.lst';
end;

function TAMainFrm.StkBaseLstFileOfWeek:string;
begin
  result:=FTrlDBPath+'CBData\TCRI\CloseIdList\ForWeekDay\'+FormatDateTime('yyyymmdd',date)+'.lst';
end;

function TAMainFrm.StkBaseValueStatusCodeFromIni(aCode,aValue:string):boolean;
var xFIni:TIniFile; xstr1,xstr2:string;
begin
  result:=false;
  xstr1:=StkBaseLstFile;
  if not DirectoryExists(ExtractFilePath(xstr1)) then
    exit;
  try
    xFIni:=TIniFile.Create(xstr1);
    if aCode<>'' then
      xFIni.WriteString('list',aCode,aValue);
    xFIni.Writefloat('work','lasttime',now);
    result:=true;
  finally
    try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
  end;
end;

function TAMainFrm.StkBaseValueStatusCodeFromIniOfWeek(aCode,aValue:string):boolean;
var xFIni:TIniFile; xstr1,xstr2:string;
begin
  result:=false;
  xstr1:=StkBaseLstFileOfWeek;
  if not DirectoryExists(ExtractFilePath(xstr1)) then
    exit;
  try
    xFIni:=TIniFile.Create(xstr1);
    if aCode<>'' then
      xFIni.WriteString('list',aCode,aValue);
    xFIni.Writefloat('work','lasttime',now);
    result:=true;
  finally
    try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
  end;
end;
    
function TAMainFrm.GetCodeList: boolean;
var sItem,sCode,sLine,sCodePath1,sCodePath2,sCodeFile1,sCodeFile2,sCodeFile3,sLastOkDate:string;
   i,j,iPos:integer; ts1,ts2,tsLastCode:TStringList; FIni:TIniFile;
begin
  result:=false;
  FIDLstMgr.Clear;
  ts1:=nil; ts2:=nil; FIni:=nil;  
  showsb(1,Format('取得代碼列表...',[]));
  sCodePath1:=FRealTimePath+'CloseIdList\'+FormatDateTime('yyyymmdd',date)+'\';
  sCodePath2:=ExtractFilePath(StkBaseLstFile);
  if not DirectoryExists(sCodePath2) then
    Mkdir_Directory(sCodePath2);
    
  sCodeFile2:=sCodePath2+FormatDateTime('yyyymmdd',date)+'.lst';
  try
  try
    ts1:=TStringList.create;
    ts2:=TStringList.create;
    tsLastCode:=TStringList.create;
    if not FileExists(sCodeFile2) then
    begin
      sCodeFile1:=sCodePath1+'CloseIdList.dat';
      if not FileExists(sCodeFile1) then
      begin
        ShowMsgEx(Format('realtime中代碼列表文檔不存在.'+sCodeFile1,[]));
        exit;
      end;

      //--常規模式下，只下載相對前次增加的代碼的資料
      sLastOkDate:=GetIniValueByT(CAppTopic,'ok2','',ExtractFilePath(ParamStr(0))+'setup.ini');
      sCodeFile3:=sCodePath2+sLastOkDate+'.lst';
      if  FileExists(sCodeFile3) then
        ts2.LoadFromFile(sCodeFile3);
      tsLastCode.clear;
      for i:=0 to ts2.count-1 do
      begin
        if StopRunning then exit;
        showsb(2,Format('%d/%d',[i+1,ts2.count]));
        if SameText('[list]',ts2[i]) then
        begin
          for j:=i+1 to ts2.Count-1 do
          begin
            if StopRunning then exit;
            showsb(2,Format('%d/%d',[j+1,ts2.count]));
            if IsSecLine(ts2[j]) then
              break;
            iPos:=Pos('=',ts2[j]);
            sLine:='';
            if iPos>0 then
              sLine:=Copy(ts2[j],1,iPos-1);
            if sLine<>'' then
              tsLastCode.Add(sLine);
          end;
          Break;
        end;
      end;
      ts2.Clear;

      
      ts2.Add('[list]');
      ts1.LoadFromFile(sCodeFile1);
      for i:=0 to ts1.count-1 do
      begin
        if StopRunning then
          exit;
        showsb(2,Format('%d/%d',[i+1,ts1.count]));
        sCode:=Trim(ts1[i]);
        if (sCode<>'') and
           (Length(sCode)=4) and
           (MayBeDigital(sCode))
           //(not IsRightStock(aTemp02)) and
           //(Copy(aTemp02,1,1)<>'#')
           then
        begin
          FIDLstMgr.Add(sCode);
          if tsLastCode.IndexOf(sCode)=-1 then
            ts2.Add(sCode+'='+_CDaiXia)
          else
            ts2.Add(sCode+'='+_CNoNeedShen);
        end;
      end;
      ts2.Add('[work]');
      ts2.Add('lasttime='+floattostr(now));
      if FIDLstMgr.Count>0 then
        ts2.SaveToFile(sCodeFile2);
    end
    else begin
      FIni:=TIniFile.Create(sCodeFile2);
      ts2.LoadFromFile(sCodeFile2);
      for i:=0 to ts2.count-1 do
      begin
        if StopRunning then
          exit;
        showsb(2,Format('%d/%d',[i+1,ts2.count]));
        sLine:=Trim(ts2[i]);
        if (Pos('=',sLine)>0) and
           (Pos('lasttime',sLine)<=0) then
        begin
          iPos:=Pos('=',sLine);
          sCode:=Copy(sLine,1,iPos-1);
          if sCode<>'' then
          begin
            sItem:=FIni.ReadString('list',sCode,'');
            //if Copy(sItem,1,1)<>_CXiaOK then
            begin
              FIDLstMgr.Add(sCode);
            end;
          end;
        end;
      end;
    end;

    if FIDLstMgr.Count=0 then
    begin
      ShowMsgEx(Format('沒有代碼需要執行下載.',[]));
      //ShowMsgEx(Format('代碼列表為空.',[]));
      //Exit;
    end;
    result:=true;

  except
    on e:Exception do
    begin
      ShowMsgEx('獲取代碼列表出現異常.'+e.Message);
    end;
  end;
  finally
    try if Assigned(ts1) then FreeAndNil(ts1); except end;
    try if Assigned(ts2) then FreeAndNil(ts2); except end;
    try if Assigned(tsLastCode) then FreeAndNil(tsLastCode); except end; 
    try if Assigned(FIni) then FreeAndNil(FIni); except end;
    showsb(2,'');
    showsb(1,'');
  end;
end;


function TAMainFrm.GetCodeListOfWeek: boolean;
var sItem,sCode,sLine,sCodePath1,sCodePath2,sCodeFile1,sCodeFile2,sCodeFile3:string;
   i,j,iPos:integer; ts1,ts2:TStringList; FIni:TIniFile;
begin
  result:=false;
  FIDLstMgr.Clear;
  ts1:=nil; ts2:=nil; FIni:=nil;
  showsb(1,Format('取得代碼列表...',[]));
  sCodePath1:=FRealTimePath+'CloseIdList\'+FormatDateTime('yyyymmdd',date)+'\';
  sCodePath2:=ExtractFilePath(StkBaseLstFileOfWeek);
  if not DirectoryExists(sCodePath2) then
    Mkdir_Directory(sCodePath2);
    
  sCodeFile2:=sCodePath2+FormatDateTime('yyyymmdd',date)+'.lst';
  try
  try
    ts1:=TStringList.create;
    ts2:=TStringList.create;
    if not FileExists(sCodeFile2) then
    begin
      sCodeFile1:=sCodePath1+'CloseIdList.dat';
      if not FileExists(sCodeFile1) then
      begin
        ShowMsgEx(Format('realtime中代碼列表文檔不存在.'+sCodeFile1,[]));
        exit;
      end;

      ts2.Add('[list]');
      ts1.LoadFromFile(sCodeFile1);
      for i:=0 to ts1.count-1 do
      begin
        if StopRunning then
          exit;
        showsb(2,Format('%d/%d',[i+1,ts1.count]));
        sCode:=Trim(ts1[i]);
        if (sCode<>'') and
           (Length(sCode)=4) and
           (MayBeDigital(sCode))
           //(not IsRightStock(aTemp02)) and
           //(Copy(aTemp02,1,1)<>'#')
           then
          begin
            FIDLstMgr.Add(sCode);
            ts2.Add(sCode+'='+_CDaiXia);
          end;
      end;
      ts2.Add('[work]');
      ts2.Add('lasttime='+floattostr(now));
      if FIDLstMgr.Count>0 then
        ts2.SaveToFile(sCodeFile2);
    end
    else begin
      FIni:=TIniFile.Create(sCodeFile2);
      ts2.LoadFromFile(sCodeFile2);
      for i:=0 to ts2.count-1 do
      begin
        if StopRunning then
          exit;
        showsb(2,Format('%d/%d',[i+1,ts2.count]));
        sLine:=Trim(ts2[i]);
        if (Pos('=',sLine)>0) and
           (Pos('lasttime',sLine)<=0) then
        begin
          iPos:=Pos('=',sLine);
          sCode:=Copy(sLine,1,iPos-1);
          if sCode<>'' then
          begin
            sItem:=FIni.ReadString('list',sCode,'');
            //if Copy(sItem,1,1)<>_CXiaOK then
            begin
              FIDLstMgr.Add(sCode);
            end;
          end;
        end;
      end;
    end;

    if FIDLstMgr.Count=0 then
    begin
      ShowMsgEx(Format('代碼列表為空.',[]));
      Exit;
    end;
    result:=true;

  except
    on e:Exception do
    begin
      ShowMsgEx('獲取代碼列表出現異常.'+e.Message);
    end;
  end;
  finally
    try if Assigned(ts1) then FreeAndNil(ts1); except end;
    try if Assigned(ts2) then FreeAndNil(ts2); except end;
    try if Assigned(FIni) then FreeAndNil(FIni); except end;
    showsb(2,'');
    showsb(1,'');
  end;
end;


end.

