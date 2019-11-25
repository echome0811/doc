
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, IdIntercept, IdLogBase, IdLogDebug,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,csDef, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,IniFiles,TCommon,TDocMgr, ImgList,
  SocketClientFrm,TSocketClasses,uDisplayMsg,
  uLevelDataDefine,uLevelDataFun,
  DateUtils, DB, ADODB,UrlMon,ActiveX, IdTCPServer,WinInet,
  ComObj; //TWarningServer

const CAppTopic='DownShenBaoCase';
      CAppTitle='DownShenBaoCase';
      CAppWindow='DownShenBaoCase_Window';
      CNa='na';

NoneNum     = -999999999;
ValueEmpty  = -888888888;

type
  THtmlParseRec=record
    TagBegin:string;
    TagEnd:string;
  end;
  
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
    PanelCaption_URL: TPanel;
    ImageList1: TImageList;
    StatusBar2: TStatusBar;
    Timer_StartGetDoc: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure LogDebugLogItem(ASender: TComponent; var AText: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer_StartGetDocTimer(Sender: TObject);
  private
    FDataPath,FTrlDBPath : String;
    FEndTick : DWord;
    FUrl:string;  FFailSleep,FUptLogSaveDays:integer;
    FProxySrv:ShortString; FProxyPort:Integer;
    FLogFileName,FKeyWord1,FKeyWord2,FKeyWord3,FKeyWord4,FKeyWord5 : String;
    FNowIsRunning: Boolean;
    StopRunning : Boolean;
    DisplayMsg : TDisplayMsg;
    AppParam : TDocMgrParam;
    FDownTryTimes:integer;
    FUrlFRBH15,FUrlFRBH15Home:string;
    FHtmlParseRecs,FHisHtmlParseRecs:array of THtmlParseRec;
    FIgnoreStrList:array of string;

    procedure SetNowIsRunning(const Value: Boolean);
    function DownloadFile2(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
    function DownloadFile3(AUrl:String; var AResultFile,AErrMsg: string):Boolean;
    procedure DownLoadProcessEvent(  Sender: TFileDownLoadThread;
         Progress, ProgressMax: Cardinal;StatusCode: ULONG; StatusText: string);
    procedure RefrsehTime(s: Integer);
    Function GetShenBaoCaseFromExecl(aThisYear,aSheetType:integer;
      aMon,aExcelFile:String;aIsLastItem:boolean;var RecLst:TAryDatasRec; var aErrMsg:string;FarProc:TFarProc):Boolean;
  private
    { Private declarations }
    property NowIsRunning:Boolean Read FNowIsRunning Write SetNowIsRunning;

    function StartGet():Boolean;
    procedure SleepWait(Const Value:Double);
    procedure ShowRunBar(const Max,NowP:Integer;Const Msg:String);

    procedure HttpStatusEvent(ASender: TObject;AStatusText: string;aKey:string);
    procedure HttpBeginEvent(Sender: TObject;AWorkCountMax: Integer;aKey:string);
    procedure HttpEndEvent(Sender: TObject;aDoneOk:Boolean;aKey,aResult:string);
    procedure HttpWorkEvent(Sender: TObject; AWorkCount,AWorkMax: Integer;aKey:string);
    function GetHttpTextByUrl(aUrl:string; var aOutHtmlText,aErrStr:string):Boolean;
    procedure SaveWindowPos;
    procedure ReadWindowPos;
    procedure AppExcept(Sender: TObject; E: Exception);
    procedure ClearSysLog;
    function ShenBaoCaseLstFile:string;
  public
    { Public declarations }
    procedure InitObj();
    procedure ShowURL(const msg:String);
    procedure ShowMsgEx(const Msg:String;aConvert:boolean=true);
    procedure ShowMsg(const Msg:String;aConvert:boolean=true);
    procedure SaveMsg(const Msg:String;aConvert:boolean=true);
    procedure ShowSb(amsg:String;aIndex:integer);
    procedure Start();
    procedure Stop();
    procedure InitForm();
    procedure ClsUptDatLog;
    
  end;

var
  AMainFrm: TAMainFrm;

implementation

{$R *.dfm}

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

{TAMainFrm}
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
var inifile:Tinifile; sPath:string;  b:Boolean; i,ic:integer;
begin
  sPath:=ExtractFilePath(Application.ExeName);
  AppParam := TDocMgrParam.Create;
  Caption := AppParam.TwConvertStr(CAppTitle);
  FLogFileName := CAppTopic;

  NowIsRunning := false;
  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;
  FEndTick := GetTickCount + Round(1000);

  inifile:=Tinifile.Create(sPath+'setup.ini');
  FUrl:=inifile.ReadString(CAppTopic,'Url','');
  FTrlDBPath:=inifile.ReadString('CONFIG','TR1DBPath','');
  FDataPath := FTrlDBPath+'CBData\ShenBaoCase\';
  Mkdir_Directory(FDataPath);
  //每輪下載完成後休眠的時間(s)
  FFailSleep :=inifile.ReadInteger(CAppTopic,'DoneSleep',180);
  //資料差異的log保存天數
  FUptLogSaveDays :=inifile.ReadInteger(CAppTopic,'UptLogSaveDays',15);
  if FUptLogSaveDays<=0 then
    FUptLogSaveDays:=15;

  FUrlFRBH15:=inifile.ReadString('Rate','UrlFRBH15Home','http://www.federalreserve.gov/releases/h15/data.htm');
  FUrlFRBH15Home:=inifile.ReadString('Rate','UrlFRBH15Home','http://www.federalreserve.gov');

  //下載網頁時最大嘗試次數
  FDownTryTimes:=inifile.ReadInteger(CAppTopic,'DownTryTimes',3);
  FKeyWord1:=inifile.ReadString(CAppTopic,'KeyWord1','年度迄今');
  FKeyWord2:=inifile.ReadString(CAppTopic,'KeyWord2','年申報未結案件');
  FKeyWord3:=inifile.ReadString(CAppTopic,'KeyWord3','申報未結案件');
  FKeyWord4:=inifile.ReadString(CAppTopic,'KeyWord4','本月已結');
  FKeyWord5:=inifile.ReadString(CAppTopic,'KeyWord5','年度');

  Self.Caption:='申報案件下載';

  FProxySrv:= inifile.ReadString('CONFIG','ProxySrv','');
  FProxyPort:= inifile.ReadInteger('CONFIG','ProxyPort',808);
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

  ic:=inifile.ReadInteger(CAppTopic,'HtmlParseCount',0);
  if ic=0 then
  begin
    ShowMessage(AppParam.TwConvertStr('未進行html解析設定.無法啟動運行'));
    Application.Terminate;
    Halt;
  end;
  SetLength(FHtmlParseRecs,ic);
  for i:=1 to ic do
  begin
    FHtmlParseRecs[i-1].TagBegin:=inifile.ReadString(CAppTopic,'Html.'+inttostr(i)+'.Begin','');
    FHtmlParseRecs[i-1].TagEnd:=inifile.ReadString(CAppTopic,'Html.'+inttostr(i)+'.End','');
  end;


  ic:=inifile.ReadInteger(CAppTopic,'HisHtmlParseCount',0);
  if ic=0 then
  begin
    ShowMessage(AppParam.TwConvertStr('未進行Hishtml解析設定.無法啟動運行'));
    Application.Terminate;
    Halt;
  end;
  SetLength(FHisHtmlParseRecs,ic);
  for i:=1 to ic do
  begin
    FHisHtmlParseRecs[i-1].TagBegin:=inifile.ReadString(CAppTopic,'HisHtml.'+inttostr(i)+'.Begin','');
    FHisHtmlParseRecs[i-1].TagEnd:=inifile.ReadString(CAppTopic,'HisHtml.'+inttostr(i)+'.End','');
  end;

  ic:=inifile.ReadInteger(CAppTopic,'IgnoreStrCount',0);
  SetLength(FIgnoreStrList,ic);
  for i:=1 to ic do
  begin
    FIgnoreStrList[i-1]:=inifile.ReadString(CAppTopic,'Ignore.'+inttostr(i),'');
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

procedure TAMainFrm.RefrsehTime(s: Integer);
begin
  FEndTick := GetTickCount + Round(s*1000);
end;

procedure TAMainFrm.FormCreate(Sender: TObject);
begin
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
   Timer_StartGetDoc.Enabled:=True;
   Timer_StartGetDoc.Interval := 1000;
end;

procedure TAMainFrm.SetNowIsRunning(const Value: Boolean);
begin
   FNowIsRunning := Value;
   btnGo.Enabled := Not Value;
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

procedure TAMainFrm.InitObj;
var sFile:string;
begin
   DisplayMsg := TDisplayMsg.Create(Label1,FLogFileName);
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

procedure TAMainFrm.ShowSb(amsg:String;aIndex:integer);
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


function  SaveLog(aTag:string;aText:string):Boolean;
var sFile:string;
begin
  sFile:='d:\'+aTag+Get_GUID8+'.log';
  SetTextByTs(sFile,aText);
end;


Function TAMainFrm.GetShenBaoCaseFromExecl(aThisYear,aSheetType:integer;
  aMon,aExcelFile:String;aIsLastItem:boolean; var RecLst:TAryDatasRec;var aErrMsg:string;FarProc:TFarProc):Boolean;
var i,iType:integer; sTemp,aSheetName,sKey:string;
  aExcelApp : Variant;

  procedure GetDatasFromSheet;
  var iRow,len:integer;
  begin
      iRow := 4;
      while True do
      begin
        Application.ProcessMessages;
        if iRow>10000 then
          break;
        sTemp:=Trim(aExcelApp.Cells[iRow,1].Text);
        if sTemp='' then
          Break;

        len := Length(RecLst);
        Setlength(RecLst,len+1);
        
        RecLst[len].Datas[0]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,2].Text);
        RecLst[len].Datas[1]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,3].Text);
        RecLst[len].Datas[2]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,4].Text);
        RecLst[len].Datas[3]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,5].Text);
        RecLst[len].Datas[4]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,6].Text);
        RecLst[len].Datas[5]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,7].Text);
        RecLst[len].Datas[6]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,8].Text);
        RecLst[len].Datas[7]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,9].Text);
        RecLst[len].Datas[8]:=sTemp;

        sTemp:=Trim(aExcelApp.Cells[iRow,10].Text);
        RecLst[len].Datas[9]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,11].Text);
        RecLst[len].Datas[10]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,12].Text);
        RecLst[len].Datas[11]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,13].Text);
        RecLst[len].Datas[12]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,14].Text);
        RecLst[len].Datas[13]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,15].Text);
        RecLst[len].Datas[14]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,16].Text);
        RecLst[len].Datas[15]:=sTemp;
        sTemp:=Trim(aExcelApp.Cells[iRow,17].Text);
        RecLst[len].Datas[16]:=sTemp;

        sTemp:=Trim(aExcelApp.Cells[iRow,18].Text);
        RecLst[len].Datas[17]:=sTemp;

        RecLst[len].Datas[18]:=sKey;
        Inc(iRow);

        len := len+1;
        Application.ProcessMessages;
        //CB_Msg('loading data',FarProc);
      end;
  end;
begin
  result := false; aErrMsg:='';
  if not FileExists(aExcelFile) then
  begin
    exit;
  end;
  try
    try
      aExcelApp := CreateOleObject('Excel.Application');
      aExcelApp.WorkBooks.Open(aExcelFile);
      //--去年年度
      if aSheetType=0 then
      begin
        sKey:=Format('%d',[aThisYear-1]);
        aExcelApp.WorkSheets[1].Activate;
        GetDatasFromSheet;
      end
      //--年度迄今
      else if aSheetType=1 then
      begin
        sKey:=Format('%d',[aThisYear]);
        aExcelApp.WorkSheets[1].Activate;
        GetDatasFromSheet;
      end
      //--最新的一個月，可解析月度已結、以及申報未結案件；其餘月份僅解析月度已結。
      else if aIsLastItem then
      begin
        for i := aExcelApp.WorkSheets.Count downto 1  do
        begin
          sTemp := aExcelApp.WorkSheets[i].Name;
          if SameText(sTemp,FKeyWord4) then
          begin
            sKey:=Format('%d,%s',[aThisYear,aMon]);
            aExcelApp.WorkSheets[i].Activate;
            GetDatasFromSheet;
          end
          else if (Pos(inttostr(aThisYear),sTemp)>0) and
             ( (Pos(FKeyWord2,sTemp)>0) or
               (Pos(FKeyWord3,sTemp)>0) 
             ) then
          begin
            sKey:=Format('%d,%s',[aThisYear,_UnDo]);
            aExcelApp.WorkSheets[i].Activate;
            GetDatasFromSheet;
          end
          else if (Pos(inttostr(aThisYear-1),sTemp)>0) and
             ( (Pos(FKeyWord2,sTemp)>0) or
               (Pos(FKeyWord3,sTemp)>0) 
             ) then
          begin
            sKey:=Format('%d,%s',[aThisYear-1,_UnDo]);
            aExcelApp.WorkSheets[i].Activate;
            GetDatasFromSheet;
          end;
        end;
      end
      else begin
        for i := aExcelApp.WorkSheets.Count downto 1  do
        begin
          sTemp := aExcelApp.WorkSheets[i].Name;
          if SameText(sTemp,FKeyWord4) then
          begin
            sKey:=Format('%d,%s',[aThisYear,aMon]);
            aExcelApp.WorkSheets[i].Activate;
            GetDatasFromSheet;
          end;
        end;
      end;
    finally
      aExcelApp.WorkBooks.Close;
      aExcelApp.Quit;
    end;
    //Setlength(RecLst,len);
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=aExcelFile+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message;
    end;
  end;
end;

procedure TAMainFrm.ClsUptDatLog;
var FIni:TIniFile; ts:TStringList;
  i,ic:integer; sLine,sTime,sFile,sBeginTime,sEndTime:string;
  b:Boolean;
begin
  sFile:=ShenBaoCaseLstFile;
  if not FileExists(sFile) then
    exit;
  sEndTime:=FormatDateTime('yyyymmdd',date+1)+'_000000';
  sBeginTime:=FormatDateTime('yyyymmdd',date-FUptLogSaveDays)+'_000000';
  try
    FIni:=TIniFile.Create(sFile);
    ts:=TStringList.create;
    ic:=FIni.ReadInteger('his','count',0);
    b:=false;
    for i:=1 to ic do
    begin
      sLine:=FIni.ReadString('his',IntToStr(i),'');
      sTime:=GetStrOnly2Ex('thisdir=','@',sLine,false);
      if (sTime>=sBeginTime) then
      begin
        ts.Add(sLine);
      end
      else begin
        b:=true;
      end;
    end;
    if b then
    begin
      FIni.EraseSection('his');
      for i:=0 to ts.count-1 do
      begin
        FIni.WriteString('his',IntToStr(i+1),ts[i]);
      end;
      FIni.WriteInteger('his','count',ts.count);
    end;
  finally
    try if Assigned(FIni) then FreeAndNil(FIni); except end;
    try if Assigned(ts) then FreeAndNil(ts); except end;
  end;
end;

function RplHtmlZhuanYiWithEmpty(aInput:string):string;
begin
  result:=aInput;
  ReplaceSubString('&NBSP;','',result);
  ReplaceSubString('&nbsp;','',result);
  ReplaceSubString('&quot;','',result);
  ReplaceSubString('&QUOT;','',result);
  ReplaceSubString('&amp;','',result);
  ReplaceSubString('&AMP;','',result);
  ReplaceSubString('&lt;','',result);
  ReplaceSubString('&LT;','',result);
  ReplaceSubString('&gt;','',result);
  ReplaceSubString('&GT;','',result);

  ReplaceSubString('&NBSP','',result);
  ReplaceSubString('&nbsp','',result);
  ReplaceSubString('&quot','',result);
  ReplaceSubString('&QUOT','',result);
  ReplaceSubString('&amp','',result);
  ReplaceSubString('&AMP','',result);
  ReplaceSubString('&lt','',result);
  ReplaceSubString('&LT','',result);
  ReplaceSubString('&gt','',result);
  ReplaceSubString('&GT','',result);
end;

function RplHtmlZhuanYi(aInput:string):string;
begin
  result:=aInput;
  ReplaceSubString('&NBSP;',' ',result);
  ReplaceSubString('&nbsp;',' ',result);
  ReplaceSubString('&quot;','"',result);
  ReplaceSubString('&QUOT;','"',result);
  ReplaceSubString('&amp;','&',result);
  ReplaceSubString('&AMP;','&',result);
  ReplaceSubString('&lt;','<',result);
  ReplaceSubString('&LT;','<',result);
  ReplaceSubString('&gt;','>',result);
  ReplaceSubString('&GT;','>',result);

  ReplaceSubString('&NBSP',' ',result);
  ReplaceSubString('&nbsp',' ',result);
  ReplaceSubString('&quot','"',result);
  ReplaceSubString('&QUOT','"',result);
  ReplaceSubString('&amp','&',result);
  ReplaceSubString('&AMP','&',result);
  ReplaceSubString('&lt','<',result);
  ReplaceSubString('&LT','<',result);
  ReplaceSubString('&gt','>',result);
  ReplaceSubString('&GT','>',result);
end;

function GetThisTwYear:Integer;
var aY,aM,aD:Word;
begin
  result:=0;
  DecodeDate(Date,aY,aM,aD);
  result:=aY-1911;
end;


function TAMainFrm.StartGet(): Boolean;
var ResultStr,ResultFile,vErrMsg,sThisPath,sThisDatFile,sLastYearDatFile,sLastDatFile,sClassName,sThisDir,sLastDir,
    sItemUrl,sItemTitle,sHomeYear,sTxt,sSrcTxt,sLine,sInputErr,sHomeUrl: String;
  tsAry:array[0..5] of TStringList;
  aRecLst,aRecLst2:TAryDatasRec;
  aComCodeList:array of TShenBaoCaseComRec;
  bChangeComCode,bDownFile:boolean;
  i,j1,j2,j3,iThisYear,iType:integer; aIsLastItem,bSection2:Boolean;

      function InitComCodeRecList():integer;
      var xx1,xx2:integer; xxsFile00:string;
          xxf1:File of TShenBaoCaseComRec;
      begin
        Result:=0;
        SetLength(aComCodeList,0);
        xxsFile00:=FTrlDBPath+'CBData\ShenBaoCase\'+_ShenBaoCaseComCodeF;
        if FileExists(xxsFile00) then
        try
          AssignFile(xxf1,xxsFile00);
          FileMode := 0;
          ReSet(xxf1);
          xx1 := FileSize(xxf1);
          SetLength(aComCodeList,xx1);
          BlockRead(xxf1,aComCodeList[0],xx1,xx2);
        finally
          try CloseFile(xxf1); except end;
        end;
        Result:=1;
      end;

      function IndexOfComCode(aClass,aName:string):integer;
      var xx1,xx2,xx1s,xx1e:integer; xb1:boolean;
      begin
        result:=-1;
        xx1s:=Low(aComCodeList);
        xx1e:=High(aComCodeList);
        for xx1:=xx1s to xx1e do
        begin
          Application.ProcessMessages;
          xb1:=(sametext(aComCodeList[xx1].ClassCode,aClass)) and
             (sametext(aComCodeList[xx1].Name,aName));
          if xb1 then
          begin
            result:=aComCodeList[xx1].Idx;
            break;
          end;
        end;
      end;
      
      function SendToComCode(aClass,aName:string):integer;
      var xx1,xx2,xx3,xx4:integer;
      begin
        result:=-1;
        xx2:=IndexOfComCode(aClass,aName);
        if xx2=-1 then
        begin
          bChangeComCode:=true;
          xx3:=Length(aComCodeList);
          SetLength(aComCodeList,xx3+1);
          aComCodeList[xx3].Idx:=xx3;
          aComCodeList[xx3].Name:=aName;
          aComCodeList[xx3].ClassCode:=aClass;
          result:=aComCodeList[xx3].Idx;
        end
        else begin
          result:=aComCodeList[xx2].Idx;
        end;
      end;

      function GetOfComName(aInputIdx:integer):string;
      begin
        result:='';
        if (aInputIdx>=0) and (aInputIdx<=High(aComCodeList)) then
        begin
          Result:=aComCodeList[aInputIdx].Name;
        end;
      end;

      function FreeComCodeRecList():integer;
      var xx1,xx2,xx3,xx4:integer; xxsFile00,xxsFile01:string;
          xxf1: File  of TShenBaoCaseComRec;
      begin
        Result:=0;
        xxsFile00:=FTrlDBPath+'CBData\ShenBaoCase\'+_ShenBaoCaseComCodeF;
        xxsFile01:=ExtractFilePath(xxsFile00)+'~'+ExtractFileName(xxsFile00);
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
          Result:=1;
        finally
          DelDatF(xxsFile01);
        end;
      end;

      
  function GetSubUrlText(aInputUrl,aHint:string):boolean;
  var x1:integer; xb:Boolean;
  begin
    Result:=false;
    //HTTP.Intercept := LogDebug;
    ShowURL(aInputUrl);
    xb:=False;
    for x1:=1 to FDownTryTimes do
    begin
      if StopRunning then
        exit;
      if bDownFile then
      begin
        if DownloadFile3(aInputUrl,ResultFile,vErrMsg) then
          if not  ( Pos('404 Not Found',vErrMsg)>0 ) Then
           if FileExists(ResultFile) Then
           begin
             Result:=true;
             xb:= true;
             exit;
           end;
      end
      else begin
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
      end;

      if StopRunning then
        exit;
      SleepWait(3);
    end;
    if not xb then
    begin
        ShowMsgEx('(warn)'+aHint+'網頁取得失敗.'+vErrMsg);
        exit;
    end;
  end;

    function GetData2(aInputCaption,aUrl,aIndex:string):Boolean;
    var xb:boolean; 
    begin
       result:=false;
       xb:=false;
       if aIndex='0' then
       begin
         bDownFile:=false;
         ResultStr:='';
         xb:=GetSubUrlText(aUrl,aInputCaption);
       end
       else begin
         bDownFile:=true;
         ResultStr:='';
         if not DirectoryExists(sThisPath) then
          Mkdir_Directory(sThisPath);
         ResultFile:=sThisPath+aIndex+'.xls';
         xb:=GetSubUrlText(aUrl,aInputCaption);
       end;
       result:=xb;
    end;
    function LastYearTitleKey:string;
    begin
      result:=IntToStr(GetThisTwYear-1)+FKeyWord5;
    end;
    function InTheKeyWords(aInput:string):boolean;
    var x1:integer;
    begin
      result:=false;
      aInput:=Trim(aInput);
      if not bSection2 then
      begin
        if Pos(FKeyWord1,aInput)>0 then
        begin
          result:=true;
          Exit;
        end;
        for x1:=1 to 12 do
        begin
          if SameText(aInput,IntToStr(x1)) then
          begin
            result:=true;
            Exit;
          end;
        end;
      end
      else begin
        if SameText(LastYearTitleKey,aInput) then
        begin
          result:=true;
          Exit;
        end;
      end;
    end;
    function GetFileNameInUrl(aInput:string):string;
    var x1:Integer;
    begin
      result:=aInput;
      x1:=Pos('file=',aInput);
      if x1>0 then
        result:=Copy(aInput,x1,Length(aInput));
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

  //上次下載的14份資料地址與本次的地址是否一致
  function IsNeedUpt:boolean;
  var xFIni:TIniFile; xi:integer; xstr1:string;
  begin
    result:=false;

    xstr1:=ShenBaoCaseLstFile;
    try
      xFIni:=TIniFile.Create(xstr1);
      sLastDatFile:=FDataPath+xFIni.ReadString('last','datfile','');
      sLastDir:=xFIni.ReadString('last','dir','');
      
      if tsAry[1].Count=0 then
        exit;
      for xi:=1 to 14 do
      begin
        if (tsAry[1].Count>=xi*2) then
        begin
          xstr1:=xFIni.ReadString('last',IntToStr(xi-1),'');
          if not SameText(xstr1,tsAry[1][xi*2-1]) then
          begin
            result:=true;
            Exit;
          end;
        end;
      end;
    finally
      try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
    end;
  end;

  function GetStrFromRecLst2:string;
  const _SepThisSub='@';
        _SepThisSub2=';';
  var x1:integer; xstr1:string;
  begin
    result:='thisdir='+sThisDir+_SepThisSub+
             'lastdir='+sLastDir+_SepThisSub;
    for x1:=0 to High(aRecLst2) do
    begin
      Application.ProcessMessages;
      xstr1:=
             'key='+aRecLst2[x1].Datas[0]+_SepThisSub+
             'add='+aRecLst2[x1].Datas[1]+_SepThisSub+
             'mdf='+aRecLst2[x1].Datas[2]+_SepThisSub+
             'del='+aRecLst2[x1].Datas[3]+_SepThisSub;
      result:=result+_SepThisSub2+xstr1;
    end;
  end;
  procedure AddToRecLst2(aInputKey,aInputCode:string;aType:integer);
  var x1,x2,x3:integer; xstr1:string;
  begin
    x2:=-1;
    for x1:=0 to High(aRecLst2) do
    begin
      Application.ProcessMessages;
      if SameText(aRecLst2[x1].Datas[0],aInputKey) then
      begin
        x2:=x1;
        Break;
      end;
    end;
    if x2=-1 then
    begin
      x2:=Length(aRecLst2);
      setLength(aRecLst2,x2+1);
      aRecLst2[x2].Datas[0]:=aInputKey;
    end;
    xstr1:=aRecLst2[x2].Datas[aType];
    if Pos(aInputCode,xstr1)<=0 then
    begin
      xstr1:=xstr1+','+aInputCode;
      aRecLst2[x2].Datas[aType]:=xstr1;
    end;
  end;

  procedure CompareOldDat;
  const _SepDThis=#9;
  var xxf1: File  of TShenBaoCaseRec; xx1,xx2,xx3:integer;  xAryInt:array[0..5] of integer;
      xOldDatList:array of TShenBaoCaseRec; xARec:TShenBaoCaseRec;
      xstr1,xstr2,xstr3,xstr4,xstr5,xstr6,xstr61,xstr62,xstr63,xstrTempFile,xstrTempFile2:string;
      xFIni:TIniFile;
  begin
    //tsAry[2].Clear;
    //tsAry[3].Clear;
      if FileExists(sLastDatFile) then
      try
        AssignFile(xxf1,sLastDatFile);
        FileMode := 0;
        ReSet(xxf1);
        xx1 := FileSize(xxf1);
        SetLength(xOldDatList,xx1);
        BlockRead(xxf1,xOldDatList[0],xx1,xx2);
      finally
        try CloseFile(xxf1); except end;
      end;

      xstrTempFile:=FDataPath+'~'+sThisDatFile;
      try
        AssignFile(xxf1,xstrTempFile);
        FileMode := 2;
        Rewrite(xxf1);
        for xx1:=0 to High(aRecLst) do
        begin
          Application.ProcessMessages;

          with aRecLst[xx1] do
          begin
            if SameText(IntToStr(iThisYear-1),Datas[18]) then
              Continue;
            xAryInt[0]:=SendToComCode('gsxt',Datas[1]);
            xAryInt[1]:=SendToComCode('jalx',Datas[2]);
            xAryInt[2]:=SendToComCode('cxs',Datas[4]);
            xAryInt[3]:=SendToComCode('ajlb',Datas[5]);
            xAryInt[4]:=SendToComCode('bblx',Datas[7]);
            xAryInt[5]:=SendToComCode('ajlx',Datas[17]);

            Datas[1]:=IntToStr(xAryInt[0]);
            Datas[2]:=IntToStr(xAryInt[1]);
            Datas[4]:=IntToStr(xAryInt[2]);
            Datas[5]:=IntToStr(xAryInt[3]);
            Datas[7]:=IntToStr(xAryInt[4]);
            Datas[17]:=IntToStr(xAryInt[5]);


            with xARec do
            begin
              key:=Datas[18];
              code:=Datas[0];//證券代號
              mkt:=xAryInt[0];//公司型態--gsxt
              closetype:=xAryInt[1];//結案類型--jalx
              stkname:=Datas[3];//公司名稱
              memberclass:=xAryInt[2];//承銷商--cxs
              caseclass:=xAryInt[3];//案件類別--ajlb
              amount:=Datas[6];//金　　　　額(元)
              moneytype:=xAryInt[4];//幣別--bblx
              issueprice:=Datas[8];//發行價格
              swrq:=Datas[9];//收文日期
              zdbzrq:=Datas[10];//自動補正日期
              tzsxrq:=Datas[11];//停止生效日期
              jcsxrq:=Datas[12];//解除生效日期
              sxrq:=Datas[13];//生效日期
              fzcxrq:=Datas[14];//廢止/撤銷日期
              zxcxrq:=Datas[15];//自行撤回日期
              tjrq:=Datas[16];//退件日期
              casetype:=xAryInt[5];//案件性質--ajlx
            end;
            write(xxf1,xARec);

          end;
        end;
      finally
        try CloseFile(xxf1); except end;
      end;

    if bChangeComCode then
      FreeComCodeRecList;

    //第一次，比較本次下載資料中"月份已結"的資料（如key為105,11）
    for xx1:=High(aRecLst) downto 0 do
    begin
      Application.ProcessMessages;
      if (Pos(_UnDo,aRecLst[xx1].Datas[18])>0) then
        Continue;
      if aRecLst[xx1].Datas[18]='' then
        Continue;
      if (Pos(',',aRecLst[xx1].Datas[18])<=0) then
        Continue;
      Application.ProcessMessages;
      xstr3:=aRecLst[xx1].Datas[18];
      xstr4:=aRecLst[xx1].Datas[0];
      xstr5:=GetOfComName(StrToInt(aRecLst[xx1].Datas[5]));
      xx3:=1;//1=add 2=mdf 3=del  4=deng
      xstr6:='';
      for xx2:=High(xOldDatList) downto 0 do
      begin
        Application.ProcessMessages;
        if xOldDatList[xx2].key='' then
          Continue;
        if SameText(aRecLst[xx1].Datas[18],xOldDatList[xx2].key) and
           SameText(aRecLst[xx1].Datas[0],xOldDatList[xx2].code) and
           
           SameText(aRecLst[xx1].Datas[5],IntToStr(xOldDatList[xx2].caseclass) ) and
           SameText(aRecLst[xx1].Datas[6],xOldDatList[xx2].amount) and
           SameText(aRecLst[xx1].Datas[9],xOldDatList[xx2].swrq)then
        begin
          xx3:=2;
          with aRecLst[xx1] do
          begin
            xstr1:=Datas[18]+_SepDThis+Datas[0]+_SepDThis+
                Datas[1]+_SepDThis+Datas[2]+_SepDThis+
                Datas[3]+_SepDThis+Datas[4]+_SepDThis+
                Datas[5]+_SepDThis+Datas[6]+_SepDThis+
                Datas[7]+_SepDThis+Datas[8]+_SepDThis+
                Datas[9]+_SepDThis+Datas[10]+_SepDThis+
                Datas[11]+_SepDThis+Datas[12]+_SepDThis+
                Datas[13]+_SepDThis+Datas[14]+_SepDThis+
                Datas[15]+_SepDThis+Datas[16]+_SepDThis+Datas[17];
          end;

          with xOldDatList[xx2] do
          begin
            xstr2:=key+_SepDThis+code+_SepDThis+
              IntToStr(mkt)+_SepDThis+IntToStr(closetype)+_SepDThis+
              stkname+_SepDThis+IntToStr(memberclass)+_SepDThis+
              IntToStr(caseclass)+_SepDThis+(amount)+_SepDThis+
              IntToStr(moneytype)+_SepDThis+(issueprice)+_SepDThis+
              swrq+_SepDThis+zdbzrq+_SepDThis+
              tzsxrq+_SepDThis+jcsxrq+_SepDThis+
              sxrq+_SepDThis+fzcxrq+_SepDThis+
              zxcxrq+_SepDThis+tjrq+_SepDThis+IntToStr(casetype);
          end;
          if SameText(xstr1,xstr2) then
            xx3:=4
          else begin


          end;
          aRecLst[xx1].Datas[18]:='';
          xOldDatList[xx2].key:='';
          Break;
        end;
      end;//--xunhuanbidui
      if xx3<>4 then
      begin
        AddToRecLst2(xstr3,xstr4+'/'+xstr5,xx3); //+xstr6
      end;
    end;

    //第二次，比較本次下載資料中"未結"的資料（可能包括105,undo、104,undo）
    for xx1:=High(aRecLst) downto 0 do
    begin
      Application.ProcessMessages;
      if not (Pos(_UnDo,aRecLst[xx1].Datas[18])>0) then
        Continue;
      if aRecLst[xx1].Datas[18]='' then
        Continue;
      if (Pos(',',aRecLst[xx1].Datas[18])<=0) then
        Continue;
      Application.ProcessMessages;
      xstr3:=aRecLst[xx1].Datas[18];
      xstr4:=aRecLst[xx1].Datas[0];
      xstr5:=GetOfComName(StrToInt(aRecLst[xx1].Datas[5]));
      xx3:=1;//1=add 2=mdf 3=del  4=deng
      xstr6:='';
      for xx2:=High(xOldDatList) downto 0 do
      begin
        Application.ProcessMessages;
        if xOldDatList[xx2].key='' then
          Continue;
        if SameText(aRecLst[xx1].Datas[18],xOldDatList[xx2].key) and
           SameText(aRecLst[xx1].Datas[0],xOldDatList[xx2].code) and
           
           SameText(aRecLst[xx1].Datas[5],IntToStr(xOldDatList[xx2].caseclass) ) and
           SameText(aRecLst[xx1].Datas[6],xOldDatList[xx2].amount) and
           SameText(aRecLst[xx1].Datas[9],xOldDatList[xx2].swrq)then
        begin
          xx3:=2;
          with aRecLst[xx1] do
          begin
            xstr1:=Datas[18]+_SepDThis+Datas[0]+_SepDThis+
                Datas[1]+_SepDThis+Datas[2]+_SepDThis+
                Datas[3]+_SepDThis+Datas[4]+_SepDThis+
                Datas[5]+_SepDThis+Datas[6]+_SepDThis+
                Datas[7]+_SepDThis+Datas[8]+_SepDThis+
                Datas[9]+_SepDThis+Datas[10]+_SepDThis+
                Datas[11]+_SepDThis+Datas[12]+_SepDThis+
                Datas[13]+_SepDThis+Datas[14]+_SepDThis+
                Datas[15]+_SepDThis+Datas[16]+_SepDThis+Datas[17];
          end;

          with xOldDatList[xx2] do
          begin
            xstr2:=key+_SepDThis+code+_SepDThis+
              IntToStr(mkt)+_SepDThis+IntToStr(closetype)+_SepDThis+
              stkname+_SepDThis+IntToStr(memberclass)+_SepDThis+
              IntToStr(caseclass)+_SepDThis+(amount)+_SepDThis+
              IntToStr(moneytype)+_SepDThis+(issueprice)+_SepDThis+
              swrq+_SepDThis+zdbzrq+_SepDThis+
              tzsxrq+_SepDThis+jcsxrq+_SepDThis+
              sxrq+_SepDThis+fzcxrq+_SepDThis+
              zxcxrq+_SepDThis+tjrq+_SepDThis+IntToStr(casetype);
          end;
          if SameText(xstr1,xstr2) then
            xx3:=4
          else begin
          end;
          aRecLst[xx1].Datas[18]:='';
          xOldDatList[xx2].key:='';
          Break;
        end;
      end;//--xunhuanbidui
      if xx3<>4 then
      begin
        AddToRecLst2(xstr3,xstr4+'/'+xstr5,xx3); //+xstr6
      end;
    end;

    //剩下的都是相對刪除的
    for xx1:=High(xOldDatList) downto 0 do //exg: 105,3
    begin
      Application.ProcessMessages;
      with xOldDatList[xx1] do
      begin
        //if SameText(IntToStr(iThisYear-1),key) then
        //  Continue;
        if (Pos(_UnDo,key)>0) then
          Continue;
        if (Pos(',',key)<=0) then
          Continue;
        if key='' then
          Continue;
        xstr3:=key;
        xstr4:=code;
        xstr5:=GetOfComName(caseclass);
        AddToRecLst2(xstr3,xstr4+'/'+xstr5,3);
      end;
    end;
    for xx1:=High(xOldDatList) downto 0 do
    begin
      Application.ProcessMessages;
      with xOldDatList[xx1] do
      begin
        //if SameText(IntToStr(iThisYear-1),key) then
        //  Continue;
        if (Pos(',',key)<=0) then
          Continue;
        if not (Pos(_UnDo,key)>0) then
          Continue;
        if key='' then
          Continue;
        xstr3:=key;
        xstr4:=code;
        xstr5:=GetOfComName(caseclass);
        AddToRecLst2(xstr3,xstr4+'/'+xstr5,3);
      end;
    end;

    //----------比對去年的匯總申報案件資料
    SetLength(xOldDatList,0);
    if (sLastYearDatFile<>'') and FileExists(FDataPath+sLastYearDatFile) then
    try
      AssignFile(xxf1,FDataPath+sLastYearDatFile);
      FileMode := 0;
      ReSet(xxf1);
      xx1 := FileSize(xxf1);
      SetLength(xOldDatList,xx1);
      BlockRead(xxf1,xOldDatList[0],xx1,xx2);
    finally
      try CloseFile(xxf1); except end;
    end;

    xstrTempFile2:=FDataPath+'~'+sLastYearDatFile;
    try
      AssignFile(xxf1,xstrTempFile2);
      FileMode := 2;
      Rewrite(xxf1);
      for xx1:=0 to High(aRecLst) do
      begin
        Application.ProcessMessages;
        with aRecLst[xx1] do
        begin
          if not SameText(IntToStr(iThisYear-1),Datas[18]) then
            Continue;
          xAryInt[0]:=SendToComCode('gsxt',Datas[1]);
          xAryInt[1]:=SendToComCode('jalx',Datas[2]);
          xAryInt[2]:=SendToComCode('cxs',Datas[4]);
          xAryInt[3]:=SendToComCode('ajlb',Datas[5]);
          xAryInt[4]:=SendToComCode('bblx',Datas[7]);
          xAryInt[5]:=SendToComCode('ajlx',Datas[17]);

          Datas[1]:=IntToStr(xAryInt[0]);
          Datas[2]:=IntToStr(xAryInt[1]);
          Datas[4]:=IntToStr(xAryInt[2]);
          Datas[5]:=IntToStr(xAryInt[3]);
          Datas[7]:=IntToStr(xAryInt[4]);
          Datas[17]:=IntToStr(xAryInt[5]);


          with xARec do
          begin
            key:=Datas[18];
            code:=Datas[0];//證券代號
            mkt:=xAryInt[0];//公司型態--gsxt
            closetype:=xAryInt[1];//結案類型--jalx
            stkname:=Datas[3];//公司名稱
            memberclass:=xAryInt[2];//承銷商--cxs
            caseclass:=xAryInt[3];//案件類別--ajlb
            amount:=Datas[6];//金　　　　額(元)
            moneytype:=xAryInt[4];//幣別--bblx
            issueprice:=Datas[8];//發行價格
            swrq:=Datas[9];//收文日期
            zdbzrq:=Datas[10];//自動補正日期
            tzsxrq:=Datas[11];//停止生效日期
            jcsxrq:=Datas[12];//解除生效日期
            sxrq:=Datas[13];//生效日期
            fzcxrq:=Datas[14];//廢止/撤銷日期
            zxcxrq:=Datas[15];//自行撤回日期
            tjrq:=Datas[16];//退件日期
            casetype:=xAryInt[5];//案件性質--ajlx
          end;
          write(xxf1,xARec);
        end;
      end;
    finally
      try CloseFile(xxf1); except end;
    end;
    if bChangeComCode then
      FreeComCodeRecList;
    //比對去年匯總資料（如key為105）
    for xx1:=High(aRecLst) downto 0 do
    begin
      Application.ProcessMessages;
      if (not SameText(IntToStr(iThisYear-1),aRecLst[xx1].Datas[18])) then
        Continue;

      Application.ProcessMessages;
      xstr3:=aRecLst[xx1].Datas[18];
      xstr4:=aRecLst[xx1].Datas[0];
      xstr5:=GetOfComName(StrToInt(aRecLst[xx1].Datas[5]));
      xx3:=1;//1=add 2=mdf 3=del  4=deng
      xstr6:='';
      for xx2:=High(xOldDatList) downto 0 do
      begin
        Application.ProcessMessages;
        if xOldDatList[xx2].key='' then
          Continue;
        if SameText(aRecLst[xx1].Datas[18],xOldDatList[xx2].key) and
           SameText(aRecLst[xx1].Datas[0],xOldDatList[xx2].code) and
           
           SameText(aRecLst[xx1].Datas[5],IntToStr(xOldDatList[xx2].caseclass) ) and
           SameText(aRecLst[xx1].Datas[6],xOldDatList[xx2].amount) and
           SameText(aRecLst[xx1].Datas[9],xOldDatList[xx2].swrq)then
        begin
          xx3:=2;
          with aRecLst[xx1] do
          begin
            xstr1:=Datas[18]+_SepDThis+Datas[0]+_SepDThis+
                Datas[1]+_SepDThis+Datas[2]+_SepDThis+
                Datas[3]+_SepDThis+Datas[4]+_SepDThis+
                Datas[5]+_SepDThis+Datas[6]+_SepDThis+
                Datas[7]+_SepDThis+Datas[8]+_SepDThis+
                Datas[9]+_SepDThis+Datas[10]+_SepDThis+
                Datas[11]+_SepDThis+Datas[12]+_SepDThis+
                Datas[13]+_SepDThis+Datas[14]+_SepDThis+
                Datas[15]+_SepDThis+Datas[16]+_SepDThis+Datas[17];
          end;

          with xOldDatList[xx2] do
          begin
            xstr2:=key+_SepDThis+code+_SepDThis+
              IntToStr(mkt)+_SepDThis+IntToStr(closetype)+_SepDThis+
              stkname+_SepDThis+IntToStr(memberclass)+_SepDThis+
              IntToStr(caseclass)+_SepDThis+(amount)+_SepDThis+
              IntToStr(moneytype)+_SepDThis+(issueprice)+_SepDThis+
              swrq+_SepDThis+zdbzrq+_SepDThis+
              tzsxrq+_SepDThis+jcsxrq+_SepDThis+
              sxrq+_SepDThis+fzcxrq+_SepDThis+
              zxcxrq+_SepDThis+tjrq+_SepDThis+IntToStr(casetype);
          end;
          if SameText(xstr1,xstr2) then
            xx3:=4
          else begin
          end;
          aRecLst[xx1].Datas[18]:='';
          xOldDatList[xx2].key:='';
          Break;
        end;
      end;//--xunhuanbidui
      if xx3<>4 then
      begin
        AddToRecLst2(xstr3,xstr4+'/'+xstr5,xx3); //+xstr6
      end;
    end;

    xstr1:=ShenBaoCaseLstFile;
    try
      xFIni:=TIniFile.Create(xstr1);
      xx1:=xFIni.ReadInteger('his','count',0);
      xstr3:=GetStrFromRecLst2;
      xFIni.WriteString('his',IntToStr(xx1+1),xstr3);
      xFIni.WriteInteger('his','count',xx1+1);

      xFIni.EraseSection('last');
      xFIni.WriteString('last','datfile',ExtractFileName(sThisDatFile));
      xFIni.WriteString('last','dir',sThisDir);

      for xx1:=1 to 14 do
      begin
        if (tsAry[1].Count>=xx1*2) then
        begin
          xFIni.WriteString('last',IntToStr(xx1-1),tsAry[1][xx1*2-1]);
        end;
      end;
      if CpyDatF(xstrTempFile,FDataPath+sThisDatFile) then
      begin
        DelDatF(xstrTempFile);
        //result:=true;
      end;
      if CpyDatF(xstrTempFile2,FDataPath+sLastYearDatFile) then
      begin
        DelDatF(xstrTempFile2);
        //result:=true;
      end;
    finally
      try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
    end;
    ClsUptDatLog;
  end;

  function IgnoreOfTitileStr(aInput:string):string;
  var xi:integer;
  begin
    Result:=aInput;
    for xi:=0 to High(FIgnoreStrList) do
    begin
      if FIgnoreStrList[xi]<>'' then
      begin
        Result:=StringReplace(Result,FIgnoreStrList[xi],'',[rfReplaceAll]);
      end;
    end;
  end;
begin
  Result := false;
  bChangeComCode:=False;
  ShowMsgEx('開始取得ShenBaoCase...');
  if StopRunning Then exit;
  sThisDir:=FormatDateTime('yyyymmdd_hhmmss',now);
  sLastDir:='';
  sThisPath:=FDataPath+sThisDir+'\';
  sLastDatFile:=''; sLastYearDatFile:='';
  sThisDatFile:='';
  iThisYear:=0;
  try
  try
    for i:=Low(tsAry) to High(tsAry) do
      tsAry[i]:=TStringList.create;
    if InitComCodeRecList<>1 then
      exit;
    ShowSb('下載申報案件資料首頁...',1);
    sHomeUrl:=FUrl;
    if Pos('?',sHomeUrl)>0 then
      sHomeUrl:=sHomeUrl+'&tick='+Formatdatetime('yymmddhhmmss',now)
    else
      sHomeUrl:=sHomeUrl+'?tick='+Formatdatetime('yymmddhhmmss',now);
    if not GetData2('申報案件資料首頁',sHomeUrl,'0') then
    begin
      exit;
    end;
    ShowSb('下載申報案件資料首頁ok.',1);

    sTxt:=ResultStr;
    sTxt:=Utf8Decode(sTxt);
    sSrcTxt:=sTxt;
    //sSrcTxt:=GetStrOnly2('<div class="c001"','</div>',sTxt,true);
    for i:=0 to High(FHtmlParseRecs) do
    begin
      sSrcTxt:=GetStrOnly2(FHtmlParseRecs[i].TagBegin,FHtmlParseRecs[i].TagEnd,sSrcTxt,true);
    end;
    if sSrcTxt='' then
    begin
      raise Exception.Create('無法解析到目標數據塊.');
    end;

    sLine:=sTxt;
    for i:=0 to High(FHisHtmlParseRecs) do
    begin
      sLine:=GetStrOnly2(FHisHtmlParseRecs[i].TagBegin,FHisHtmlParseRecs[i].TagEnd,sLine,true);
    end;
    if sLine='' then
    begin
      raise Exception.Create('無法解析到目標數據塊(歷史資料).');
    end;
    sSrcTxt:=sSrcTxt+'<sectionsep/>'+sLine;

    sSrcTxt:=StringReplace(sSrcTxt,#13#10,'',[rfReplaceAll]);
    sSrcTxt:=StringReplace(sSrcTxt,'<a',#13#10+'<a',[rfReplaceAll]);
    sSrcTxt:=StringReplace(sSrcTxt,'</a>','</a>'+#13#10,[rfReplaceAll]);
    tsAry[0].text:=sSrcTxt;
    //tsAry[0].SaveToFile('d:\shenbaocase.txt');
    tsAry[1].Clear;
    tsAry[2].Clear;

    //---遍歷網頁中的a，從"XXX年度迄今”開始取得最多14個鏈接的地址(今年、去年、以及12個月份資料)
    bSection2:=false;
    for j1:=0 to tsAry[0].count-1 do
    begin
      sLine:=tsAry[0][j1];
      if (Pos('<a',sLine)>0) and
         (Pos('</a>',sLine)>0) and
         (Pos(FKeyWord1,sLine)>0)    then
      begin
        for j2:=j1 to tsAry[0].count-1 do
        begin
          sLine:=tsAry[0][j2];//FKeyWord5
          if Pos('<sectionsep/>',sLine)>0 then
            bSection2:=true;
          if (Pos('<a',sLine)>0) and
             (Pos('</a>',sLine)>0) then
          begin
            sItemUrl:=GetStrOnly2('href="','"',sLine,false);
            sItemUrl:=RplHtmlZhuanYi(sItemUrl);
            sItemTitle:=GetStrOnly2('>','</a>',sLine,false);
            //sItemTitle:=RplHtmlZhuanYiWithEmpty(sItemTitle); IgnoreOfTitileStr
            sItemTitle:=IgnoreOfTitileStr(sItemTitle);
            sItemTitle:=Trim(sItemTitle);
            if (sItemUrl<>'') and (InTheKeyWords(sItemTitle)) then
            begin
              sItemTitle:=StringReplace(sItemTitle,FKeyWord1,'',[rfReplaceAll]);
              sItemTitle:=Trim(sItemTitle);
              if (j2=j1) then
              begin
                if (MayBeDigital(sItemTitle)) then
                begin
                  iThisYear:=StrToInt(sItemTitle);
                  if GetThisTwYear<>iThisYear then
                    raise Exception.Create('年度迄今 非當前年份.');  
                  sThisDatFile:=sItemTitle+_ShenBaoCaseYearF;
                end
                else raise Exception.Create('年份解析出錯.');
              end;
              if SameText(sItemTitle,LastYearTitleKey) then
              begin
                sLastYearDatFile:=IntToStr(iThisYear-1)+_ShenBaoCaseYearF;
                tsAry[1].Clear;
                tsAry[1].Add(sItemTitle);
                tsAry[1].Add(sItemUrl);
                for j3:=0 to tsAry[2].count-1 do
                  tsAry[1].Add(tsAry[2][j3]);
                tsAry[2].clear;
                break;
              end
              else begin
                tsAry[2].Add(sItemTitle);
                tsAry[2].Add(sItemUrl);
              end;
            end;
            //if SameText(sItemTitle,'12') then
            if SameText(sItemTitle,LastYearTitleKey) then
              break;
          end;
        end;
        Break;
      end;
    end;

    if IsNeedUpt then
    begin
      SetLength(aRecLst,0);
      j1:=0;
      while j1+1<tsAry[1].Count do
      begin
        sItemTitle:=tsAry[1][j1];
        sItemUrl:=tsAry[1][j1+1];
        //是否還有下一個輪迴(是否最新月份的資料)
        if (j1+2)+1<tsAry[1].Count then
          aIsLastItem:=false
        else
          aIsLastItem:=true;    

        ShowSb('下載申報案件資料 '+sItemTitle,1);
        if not GetData2('申報案件資料 '+sItemTitle,sItemUrl,sItemTitle) then
        begin
          exit;
        end;
        ShowSb('下載申報案件資料 '+sItemTitle+'ok.',1);
        if (ResultFile<>'') and (FileExists(ResultFile)) then
        begin
          if j1=0 then iType:=0
          else if j1=2 then iType:=1
          else iType:=2;
          if (not GetShenBaoCaseFromExecl(iThisYear,iType,sItemTitle,ResultFile,aIsLastItem,aRecLst,sInputErr,nil)) or
             (sInputErr<>'') then
          begin
            raise Exception.Create(ExtractFileName(ResultFile)+','+'input error:'+sInputErr);
          end;
        end;
        j1:=j1+2;
      end;
      CompareOldDat;
    end;

    Result := true;
    if result then SaveMsg('內容成功取得');
  Except
     On E:Exception do
     Begin
         ShowMsgEx(E.Message,false);
     End;
  End;
  finally
     ShowMsgEx('');
     try SetLength(aComCodeList,0); except end;
     for i:=Low(tsAry) to High(tsAry) do
      if Assigned(tsAry[i]) then
        FreeAndNil(tsAry[i]);
     ShowURL('');
     StatusBar1.Panels[2].Text := '';
     showsb('',-1);
  end;
end;

function TAMainFrm.ShenBaoCaseLstFile:string;
begin
  Result:=FDataPath+_ShenBaoCaseLstF;
end;

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
var
  LogFileLst : _CStrLst;
  i:integer;
begin
try
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\DownShenBaoCase\',
                 '.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if(DaysBetween(StrToDate(Copy(ExtractFileName(LogFileLst[i]),1,4)+DateSeparator
             +Copy(ExtractFileName(LogFileLst[i]),5,2)+DateSeparator
             +Copy(ExtractFileName(LogFileLst[i]),7,2)),Date)>30)then
    DeleteFile(LogFileLst[i]);
  End;
except
end;
end;

function TAMainFrm.DownloadFile3(AUrl:String; var AResultFile,AErrMsg: string):Boolean;
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
  AErrMsg := '';
  tmpFile := AResultFile;
  if not DirectoryExists(ExtractFilePath(tmpFile)) then
    Mkdir_Directory(ExtractFilePath(tmpFile));

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
  StatusBar1.Panels[2].Text := '';
end;
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

procedure TAMainFrm.Timer_StartGetDocTimer(Sender: TObject);
var aOutPut:string; AryStatus:_cStrLst;
begin
  Timer_StartGetDoc.Enabled := False;
try
Try
  if GetTickCount >= FEndTick Then
  Begin
    if NowIsRunning Then
    Begin
      StartGet;
      RefrsehTime(FFailSleep);
    End;
  End;
Except
  on E:Exception do
  Begin
     RefrsehTime(FFailSleep);
     ShowMsgEx('Timer_StartGetDocTime:'+e.Message,false);
  End;
end;
Finally
   ShowRunBar(0,0,'');
   if StopRunning Then
      NowIsRunning := False;
   Timer_StartGetDoc.Interval := 1000;
   Timer_StartGetDoc.Enabled := True;
End;
end;
end.


