
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, IdIntercept, IdLogBase, IdLogDebug,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,csDef, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,IniFiles,TCommon,TDocMgr, ImgList,
  SocketClientFrm,TSocketClasses,uDisplayMsg,
  uLevelDataDefine,uLevelDataFun,TGetDocMgr,
  DateUtils, DB, ADODB,UrlMon,ActiveX, IdTCPServer,WinInet; //TWarningServer

const CAppTopic='DownIFRS';
      CAppTitle='DownIFRS';
      CAppWindow='DownIFRS_Window';
      CNa='na';
      _IFRSCBDBNodeCaption='IFRS資料維護';
      _OpAutoAudit='AutoAudit';

NoneNum     = -999999999;
ValueEmpty  = -888888888;

type
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
    ADocon: TADOConnection;
    adsNameTbl: TADODataSet;
    btn1: TButton;
    btn2: TButton;
    Timer_StartGetDoc: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure LogDebugLogItem(ASender: TComponent; var AText: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure Timer_StartGetDocTimer(Sender: TObject);
  private
    FParamStrAry:array[0..2] of string;
    FDataPath,FTrlDBPath,FNameTblPath : String;
    FEndTick : DWord;
    FUrl1,FUrl2,FUrl3:string;  FFailSleep:integer;  //FListenPort:integer;
    FProxySrv:ShortString; FProxyPort:Integer;
    FLogFileName : String;
    FNowIsRunning: Boolean;
    StopRunning : Boolean;
    DisplayMsg : TDisplayMsg;
    AppParam : TDocMgrParam;
    FIDLstMgr,FIDNameLstMgr:TStringList;
    FDownTryTimes,FSleepWhenFrequence,FSleepPerStkCode:integer;

    CBDataMgr:TCBDataMgr;
    FTr1DBStkLstMgr:TIDLstMgr2;

    procedure SetNowIsRunning(const Value: Boolean);
    function DownloadFile2(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
    procedure DownLoadProcessEvent(  Sender: TFileDownLoadThread;
         Progress, ProgressMax: Cardinal;StatusCode: ULONG; StatusText: string);
    procedure RefrsehTime(s: Integer);
  private
    { Private declarations }
    property NowIsRunning:Boolean Read FNowIsRunning Write SetNowIsRunning;
    function DataFileByCode(aCode,sYear,sQ:string;aClassIdx:char):string;
    function TrlDataFileByYQ(sYear,sQ:string;aClassIdx:char):string;
    function SameIFRSItem(aCode,sYear,sQ:string;aClassIdx:char):Boolean;
    function SameIFRS(aCode,sYear,sQ:string):Boolean;

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
    function GetCodeList:boolean;
    function CreateWorkLst(aYear,aQ:Integer):Boolean;
    function WorkLstFile:string;
    function ExistsInTr1StkList(aCode:string):boolean;
    function GetIDNameByCode(aCode:string):string;
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

function CFS100(sVar:string):int64;
var i,iPos:integer;
  begin
    result := NoneNum2;
    if Trim(sVar)='' then
    begin
      result := ValueEmpty2;
      exit;
    end;
    sVar:=StringReplace(sVar,',','',[rfReplaceAll]);
    iPos:=Pos('.',sVar);
    if (iPos>0) and ((iPos+2)<Length(sVar)) then
    begin
      raise Exception.Create('no validate.'+sVar);
    end; 

    if not MayBeDigital(sVar) then exit;
    try
      {if Round(StrTofloat(Trim(sVar))*100)>=263 then
      begin
        raise Exception.Create('no validate1.'+sVar);
      end; }
      result :=Round(StrTofloat(Trim(sVar))*100) ;
    except
      result := NoneNum2;
    end;
  end;

function IsNullNum(aNum:double):boolean;
begin
  result:=(aNum=NoneNum) or
          (aNum=ValueEmpty) or
          (aNum=ValueEmpty2) or
          (aNum=NoneNum2);
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
var inifile:Tinifile; sPath:string;  b:Boolean; i:integer;
begin
  sPath:=ExtractFilePath(Application.ExeName);
  AppParam := TDocMgrParam.Create;
  Caption := AppParam.TwConvertStr(CAppTitle);
  FDataPath := sPath+'Data\IFRS\';
  Mkdir_Directory(FDataPath);
  FLogFileName := CAppTopic;

  NowIsRunning := false;
  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;
  FEndTick := GetTickCount + Round(1000);

  inifile:=Tinifile.Create(sPath+'setup.ini');
  FUrl1:=inifile.ReadString(CAppTopic,'Url1','');
  FUrl2:=inifile.ReadString(CAppTopic,'Url2','');
  FUrl3:=inifile.ReadString(CAppTopic,'Url3','');
  FTrlDBPath:=inifile.ReadString('CONFIG','TR1DBPath','');
  FNameTblPath:=inifile.ReadString(CAppTopic,'NameTblPath','');

  CBDataMgr := TCBDataMgr.Create(FTrlDBPath);
  FTr1DBStkLstMgr := TIDLstMgr2.Create(FTrlDBPath,False,True,M_OutPassaway_P_All);
  FTr1DBStkLstMgr.refresh;

  //FListenPort:=inifile.ReadInteger(CAppTopic,'ListenPort',7078);
  FFailSleep :=inifile.ReadInteger(CAppTopic,'FailSleep',180);
  //TCPServer.Bindings.Clear;
  //TCPServer.DefaultPort:=FListenPort;
  //TCPServer.Active := True;

  FDownTryTimes:=inifile.ReadInteger(CAppTopic,'DownTryTimes',3);
  FSleepWhenFrequence:=inifile.ReadInteger(CAppTopic,'SleepWhenFrequence',30);
  FSleepPerStkCode:=inifile.ReadInteger(CAppTopic,'SleepPerStkCode',15);

  FProxySrv:= inifile.ReadString(CAppTopic,'ProxySrv','');
  FProxyPort:= inifile.ReadInteger(CAppTopic,'ProxyPort',808);
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

function TAMainFrm.ExistsInTr1StkList(aCode:string):boolean;
var i:integer;
begin
  result:=(FTr1DBStkLstMgr.IDList.IndexOf(aCode)<>-1);
end;

function TAMainFrm.GetIDNameByCode(aCode:string):string;
var i:integer; sItem:string;
begin
  result:=aCode;
  sItem:=aCode+#9;
  for i:=0 to FIDNameLstMgr.Count-1 do
  begin
    Application.ProcessMessages;
    if pos(sItem,FIDNameLstMgr[i])=1 then
    begin
      result:=FIDNameLstMgr[i];
      exit;
    end;
  end;
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
var str1,str2,str3:string;
begin
   {FParamStrAry[0]:='104';
   FParamStrAry[1]:='1';
   FParamStrAry[2]:='1';}
   if ParamCount=3 Then
   begin
     str1:=ParamStr(1);
     str2:=ParamStr(2);
     str3:=ParamStr(3);
     if not (
       MayBeDigital(str1) and
       MayBeDigital(str2) and
       MayBeDigital(str3)
     ) then
     begin
       ShowMessage('param error');
       Halt;
     end;
     FParamStrAry[0]:=str1;
     FParamStrAry[1]:=str2;
     FParamStrAry[2]:=str3;
   end
   else begin
     if ParamCount>0 then
     begin
       ShowMessage('param error');
       Halt;
     end;
   end;

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
   FIDLstMgr := TStringList.Create;
   FIDNameLstMgr := TStringList.Create;
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


function  SaveLog(aTag:string;aText:string):Boolean;
var sFile:string;
begin
  sFile:='d:\'+aTag+Get_GUID8+'.log';
  SetTextByTs(sFile,aText);
end;


function NoDataInText(ResultStr:string):boolean;
begin
result:=(Pos('查無公司資料',ResultStr)>0) or
         (Pos('查無最新資訊',ResultStr)>0) or
         (Pos('查無所需資料',ResultStr)>0) or
         (Pos('公司代號不存在',ResultStr)>0) or
         (Pos('公司未申報基本資料',ResultStr)>0) or
         (Pos('以前之財報資料請至採IFRSs前',ResultStr)>0); 
end;

function GetCbpaOpDataPath:string;
begin
  result:=ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\CbpaOpData\';
end;

function GetAnIFRSUploadOpFile(): String;
var sPath,FileName,FileName2,FileExt : String; Index : Integer;
begin
   result:='';
   sPath:=GetCbpaOpDataPath;
   if not DirectoryExists(sPath) then
     Mkdir_Directory(sPath);

   FileName := 'cbpa';
   FileExt  := '.ifrsop';
   FileName2 := sPath+FileName+'_'+Get_GUID8+FileExt;
   Result := FileName2;
end;

function UpdateGuidOfWorkList_IFRS(aOperator,aTimeKey,aCode,aYear,aQ,aIDName,aOp,aMName,aMNameEn:string):boolean;
  function CreateAnUplaodFlag:boolean;
  var sFile:string; ts:TStringList;
  begin
    result:=false;
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
      result:=true;
    finally
      FreeAndNil(ts);
    end;
  end;
begin
  result:=CreateAnUplaodFlag;
end;

function TAMainFrm.StartGet(): Boolean;
var aSource,aTemp,aTemp01,aTemp02,aTemp03:string;  sDownUrl,ResultStr,vErrMsg : String;
  tsSuc,tsFail,tsToBe,tsDat1,tsDat2,tsDat3,tsDat0,tsTemp1,tsTemp2,tsTemp3,tsTemp0:TStringList;
  sYear,sQ:string;
  tdStrLst:_cStrLst2;
  aIFRSTopNodeList:array of TIFRSTopNodeRec; aComCodeList:array of TIFRSNodeRec;
  iClassIdx:Char; bChangeComCode:boolean;

      function InitComCodeRecList():integer;
      var xx1,xx2:integer; xxsFile00,xxsFile01:string;
          xxf1: File  of TIFRSNodeRec;
          xxf2: File  of TIFRSTopNodeRec;
      begin
        Result:=0;
        SetLength(aComCodeList,0);
        xxsFile00:=FTrlDBPath+'CBData\IFRS\'+_IFRSNodeF;
        xxsFile01:=FDataPath+ExtractFileName(xxsFile00);
        if FileExists(xxsFile00) then
        if not CpyDatF(xxsFile00,xxsFile01) then
        begin
          ShowMsgEx('(warn)'+'copy fail.'+xxsFile00);
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
          Result:=1;
        finally
          DelDatF(xxsFile01);
        end;

        xxsFile00:=FTrlDBPath+'CBData\IFRS\'+_IFRSTopNodeF;
        try
          if FileExists(xxsFile00) then
          try
            AssignFile(xxf2,xxsFile00);
            FileMode := 0;
            ReSet(xxf2);
            xx1 := FileSize(xxf2);
            SetLength(aIFRSTopNodeList,xx1);
            BlockRead(xxf2,aIFRSTopNodeList[0],xx1,xx2);
          finally
            try CloseFile(xxf2); except end;
          end;
          Result:=1;
        finally
        end;
      end;

      function IndexOfIFRSTopNode(aClassIdx:char;aParentNode:string):integer;
      var xx1,xx2,xx3,xx4:integer;
      begin
        result:=-1;
        for xx1:=0 to High(aIFRSTopNodeList) do
        begin
          Application.ProcessMessages;
          if (sametext(aIFRSTopNodeList[xx1].TblType,aClassIdx)) and
             (sametext(aIFRSTopNodeList[xx1].Name,aParentNode)) then
          begin
            result:=aIFRSTopNodeList[xx1].Idx;
            break;
          end;
        end;
      end;
      
      function IndexOfComCode(aClassIdx:char;aName,aParentNode:string):integer;
      var xx1,xx2,xx1s,xx1e:integer; xb1:boolean;
      begin
        result:=-1;
        xx1s:=Low(aComCodeList);
        xx1e:=High(aComCodeList);
        for xx1:=xx1s to xx1e do
        begin
          Application.ProcessMessages;
          if aParentNode='' then
            xb1:=(sametext(aComCodeList[xx1].TblType,aClassIdx)) and
             (sametext(aComCodeList[xx1].Name,aName)) and
             ( aComCodeList[xx1].ParentNodeIdx=-1 )
          else begin
            xx2:=aComCodeList[xx1].ParentNodeIdx;
            xb1:=(sametext(aComCodeList[xx1].TblType,aClassIdx)) and
             (sametext(aComCodeList[xx1].Name,aName)) and
             ( (xx2<=High(aIFRSTopNodeList)) and
               (sametext(aIFRSTopNodeList[xx2].Name,aParentNode))
             );
          end;
          if xb1 then
          begin
            result:=aComCodeList[xx1].Idx;
            break;
          end;
        end;
      end;
      
      function SendToComCode(aClassIdx:char;aName,aParentNode:string):integer;
      var xx1,xx2,xx3,xx4:integer;
      begin
        result:=-1;
        xx2:=IndexOfComCode(aClassIdx,aName,aParentNode);
        if xx2=-1 then
        begin
          bChangeComCode:=true;
          if aParentNode='' then
          begin
            xx4:=-1;
          end
          else begin
            xx4:=IndexOfIFRSTopNode(aClassIdx,aParentNode);
            if xx4=-1 then
            begin
              raise Exception.Create('TopNode not define.'+aClassIdx+';'+aParentNode);
            end;
          end;
          xx3:=Length(aComCodeList);
          SetLength(aComCodeList,xx3+1);
          aComCodeList[xx3].Idx:=xx3;
          aComCodeList[xx3].ParentNodeIdx:=xx4;
          aComCodeList[xx3].Name:=aName;
          aComCodeList[xx3].ListNo:=-1;
          aComCodeList[xx3].TblType:=aClassIdx;
          result:=aComCodeList[xx3].Idx;
        end
        else begin
          result:=aComCodeList[xx2].Idx;
        end;
      end;

      function FreeComCodeRecList():integer;
      var xx1,xx2,xx3,xx4:integer; xxsFile00,xxsFile01,xxPath:string;
          xxf1: File  of TIFRSNodeRec;
      begin
        Result:=0;
        xxsFile00:=FTrlDBPath+'CBData\IFRS\'+_IFRSNodeF;
        xxPath:=ExtractFilePath(xxsFile00);
        if not DirectoryExists(xxPath) then
          Mkdir_Directory(xxPath);
        xxsFile01:=FDataPath+ExtractFileName(xxsFile00);
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
          //DelDatF(xxsFile01);
        end;
      end;

      procedure DelLocalComCodeFile();
      var xx1,xx2,xx3,xx4:integer; xxsFile00,xxsFile01:string;
      begin
        xxsFile00:=FTrlDBPath+'CBData\IFRS\'+_IFRSNodeF;
        xxsFile01:=FDataPath+ExtractFileName(xxsFile00);
        DelDatF(xxsFile01);
      end;

      
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

  function ValueStatusParasFromIni(aValue:string):boolean;
  var xFIni:TIniFile; xstr1,xstr2:string;
  begin
    result:=false;
    xstr1:=WorkLstFile;
    try
      xFIni:=TIniFile.Create(xstr1);
      xFIni.WriteString('work','status',aValue);
      xFIni.Writefloat('work','lasttime',now);
      result:=true;
    finally
      try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
    end;
  end;

  function SetCodeToLast(aCode:string):boolean;
  var xFIni:TIniFile; xstr1,xstr2,aValue:string;
  begin
    result:=false;
    xstr1:=WorkLstFile;
    try
      xFIni:=TIniFile.Create(xstr1);
      aValue:=xFIni.ReadString('list',aCode,_CDaiXia);
      xFIni.DeleteKey('list',aCode);
      xFIni.Writefloat('work','lasttime',now);
      xFIni.WriteString('list',aCode,aValue);
      result:=true;
    finally
      try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
    end;
  end;
  
  function ValueStatusCodeFromIni(aCode,aValue:string):boolean;
  var xFIni:TIniFile; xstr1,xstr2:string;
  begin
    result:=false;
    xstr1:=WorkLstFile;
    try
      xFIni:=TIniFile.Create(xstr1);
      xFIni.WriteString('list',aCode,aValue);
      xFIni.Writefloat('work','lasttime',now);
      result:=true;
    finally
      try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
    end;
  end;

  function UptLstIni():boolean;
  var xFIni:TIniFile; xstr1,xstr2:string;
  begin
    result:=false;
    xstr1:=WorkLstFile;
    try
      xFIni:=TIniFile.Create(xstr1);
      xFIni.Writefloat('work','lasttime',now);
      result:=true;
    finally
      try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
    end;
  end;

  function GetParasFromIni:boolean;
  var xFIni:TIniFile; xstr1,xstr2,xstr3,xstr4:string;
      xi,xi2,xi3:integer;
      xTs:TStringList;
      xStrLst:_cStrLst;
  begin
    result:=false;
    tsSuc.clear;
    tsFail.clear;
    tsToBe.clear;

    xstr1:=WorkLstFile;
    if not FileExists(xstr1) then
    begin
      ShowMsgEx('WorkLstFile not exists.'+xstr1);
      exit;
    end;
    try
      xTs:=TStringList.create;
      xFIni:=TIniFile.Create(xstr1);
      sYear:=xFIni.ReadString('work','year','');
      sQ:=xFIni.ReadString('work','q','');
      if (sYear='') or (sQ='') then
      begin
        ShowMsgEx('Year or q is null.'+sYear+','+sQ);
        exit;
      end;

      xTs.LoadFromFile(xstr1);
      for xi3:=0 to xTs.count-1 do
      begin
        if SameText(xTs[xi3],'[list]') then
        begin
          for xi:=xi3+1 to xTs.count-1 do
          begin
            xstr4:=Trim(xTs[xi]);
            if xstr4='' then
              Continue;
            if IsSecLine(xstr4) then
              break;
            xStrLst:=DoStrArray(xstr4,'=');
            if (Length(xStrLst)=2) then
            begin
              if (xStrLst[1]=_CDaiXia) or (xStrLst[1]=_CXiaing) then
                tsToBe.Add(xStrLst[0])
              else if (xStrLst[1]=_CXiaOK) or (xStrLst[1]=_CShen) or (xStrLst[1]=_CNoNeedShen) then
                tsSuc.Add(xStrLst[0])
              else if (xStrLst[1]=_CXiaFail) then
                tsFail.Add(xStrLst[0]);
            end;
          end;
          break;
        end;
      end;
    finally
      try SetLength(xStrLst,0); except end;
      try if Assigned(xTs) then FreeAndNil(xTs); except end;
      try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
    end;
    ValueStatusParasFromIni(_CXiaing);
    result:=true;
  end;

  function DivTdItems(aInput:string):_cStrLst2;
  var xstr1,xstr2,xstr3:string; xi,xi2,xi3,xiC:integer;
  begin
    SetLength(Result,0);
    xstr1:=aInput;
    xstr1:=StringReplace(xstr1,#13#10,'',[rfReplaceAll]);
    xstr1:=StringReplace(xstr1,'<td',#13#10+'<td',[rfReplaceAll]);
    tsTemp0.Text:=xstr1;
    SetLength(Result,tsTemp0.Count);
    xiC:=0;
    for xi:=0 to tsTemp0.Count-1 do
    begin
      xstr2:=tsTemp0[xi];
      if Pos('<td',xstr2)>0 then
      begin
        xstr3:=GetStrOnly2('>','</td>',xstr2,false);
        Result[xiC]:=xstr3;
        Inc(xiC);
      end;
    end;
    SetLength(Result,xiC);
  end;

  function WriteToFile(aInputCode:string):boolean;
  var f: File  of TIFRSDatRec; xrAry:TIFRSDatRec;
      xFile,xsDatPath,xParentNode:string;  x2,x3,x4,xiAry:integer;
      xf1:Double;xf2:int64;
  begin
    result:=false;
    bChangeComCode:=False;
    if (
         (tsDat1.Count=0) and
         (tsDat2.Count=0) and
         (tsDat3.Count=0)
       ) or
       (
         ((tsDat1.Count mod 2)<>0) or
         ((tsDat2.Count mod 2)<>0) or
         ((tsDat3.Count mod 2)<>0)
       )
        then
    begin
      result:=true;
      Exit;
    end;

    try
      for x4:=1 to 3 do
      begin
        iClassIdx:=' '; tsDat0:=nil;
        if x4=1 then
        begin
          iClassIdx:=_ZCFZB;
          tsDat0:=tsDat1;
        end
        else if x4=2 then
        begin
          iClassIdx:=_ZZSYB;
          tsDat0:=tsDat2;
        end
        else if x4=3 then
        begin
          iClassIdx:=_XJLLB;
          tsDat0:=tsDat3;
        end;

        Init_TIFRSDatRec(xrAry);
        xiAry:=-1;
        xParentNode:='';
        x2:=0;
        while x2+1<tsDat0.count do
        begin
          //if x2=68 then
          //  ShowMessage(tsDat0[x2]);
          if not IsNullNum(StrToFloat(tsDat0[x2+1])) then
          begin
            x3:=SendToComCode(iClassIdx,tsDat0[x2],xParentNode);
            if (x3=-1)  then
            begin
              raise Exception.Create('SendToComCode fail2.'+tsDat0[x2]+','+(iClassIdx)+','+aInputCode );
            end;
            xrAry.CompCode:=aInputCode;
            try
              xf2:=(StrToInt64(tsDat0[x2+1]));
              xf2:=xf2;
              xf1:=xf2;
              Inc(xiAry);
              if xiAry>299 then
              begin
                raise Exception.Create('items>299.'+(iClassIdx)+','+aInputCode );
              end;
              xrAry.NumAry[xiAry]:=xf1;
              xrAry.IdxAry[xiAry]:=x3;
            except
              ShowMessage(Format('%d,%d,%d,',[x3,x2+1,tsDat0.count])+(iClassIdx));
            end;
          end
          else begin
            xParentNode:=tsDat0[x2];
          end;
          //Format('%s,%s',[sYear,sQ]);  iClassIdx
          x2:=x2+2;
        end;

        xFile:=DataFileByCode(aInputCode,sYear,sQ,iClassIdx);
        xsDatPath:=ExtractFilePath(xFile);
        if not DirectoryExists(xsDatPath) then
          Mkdir_Directory(xsDatPath);
        AssignFile(f,xFile);
        FileMode := 1;
        ReWrite(f);
        Write(f,xrAry);
        CloseFile(f);
      end;

      
      result:=True;
    finally
      if bChangeComCode then
        FreeComCodeRecList;
    end;
  end;

  function DoDownText(aFmtUrl,aInCode,aInputHint:string;var aFrequence:Boolean):Boolean;
  var xb:boolean;
  begin
      result:=false; aFrequence:=false;

      sDownUrl:=aFmtUrl;
      sDownUrl:=StringReplace(sDownUrl,'%stkcode%',aInCode,[]);
      sDownUrl:=StringReplace(sDownUrl,'%year%',sYear,[]);
      sDownUrl:=StringReplace(sDownUrl,'%qnum%',sQ,[]);
      xb:=GetSubUrlText(sDownUrl,aInCode+' '+aInputHint);
      if xb then
      begin
        ResultStr:=UTF8Decode(ResultStr);
        if Pos('查詢過於頻繁',ResultStr)>0 then
        begin
          xb:=false;
          aFrequence:=true;
          SaveMsg('(warn)'+'query frequently.'+sDownUrl,false);
        end;
      end
      else begin
        SaveMsg('(warn)'+'down fail.'+sDownUrl,false);
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
      UptLstIni();
      if not xb then
      begin
        if aFrequence then
        begin
          StatusBar1.Panels[1].Text := Format('查詢過於頻繁(%d/%d)',[x1,FDownTryTimes]);
          SleepAWhile(FSleepWhenFrequence);
          StatusBar1.Panels[2].Text := '';
          StatusBar1.Panels[1].Text := '';
        end
        else
          Break;
      end
      else begin
        result:=True;
        break;
      end;
    end;
  end;

  procedure DoPro(aInputHint:string;aBInputFail:boolean;var tsInPut:TStringList);
  var i,t,t0,t1,t2,t3,t4 : integer;
      xbStart,xb,xb2:boolean; xCode,xSpcstr,xstr1,xstr2,xstr3:string; xSrcTextAry:array[0..2] of string;
      xf2:int64;
      sTimeKey,sLogOpCur,sIDName:string; 
  begin
    i:=0;
    while i<tsInPut.count do
    begin
      tsDat1.Clear;
      tsDat2.Clear;
      tsDat3.Clear;
      xCode:=tsInPut[i];
      if StopRunning Then exit;
      SetCodeToLast(xCode);

      xSpcstr:='value="詳細資料"';
      xSpcstr:=StringReplace(xSpcstr,'"',chr(39),[rfReplaceAll]);
      showsb(1,Format('正處理(%s) 待下載(%d) 成功(%d) 失敗(%d)',
         [xCode,tsToBe.count,tsSuc.count,tsFail.count]));
      for t4:=0 to High(xSrcTextAry) do
        xSrcTextAry[t4]:='';
      xb:=True;
      if xb then
      begin
        xb:=DoDownTextEx(FUrl1,xCode,aInputHint);
        if xb then
        if Pos(xSpcstr,ResultStr)>0 then
        begin
          xstr1:=FUrl1;
          xstr1:=StringReplace(xstr1,'?step=1&','?step=2&',[rfReplaceAll]);
          xb:=DoDownTextEx(xstr1,xCode,aInputHint);
        end;
        xSrcTextAry[0]:=ResultStr;
      end;
      if xb then
      begin
        xb:=DoDownTextEx(FUrl2,xCode,aInputHint);
        if xb then 
        if Pos(xSpcstr,ResultStr)>0 then
        begin
          xstr1:=FUrl2;
          xstr1:=StringReplace(xstr1,'?step=1&','?step=2&',[rfReplaceAll]);
          xb:=DoDownTextEx(xstr1,xCode,aInputHint);
        end;
        xSrcTextAry[1]:=ResultStr;
      end;
      if xb then
      begin
        xb:=DoDownTextEx(FUrl3,xCode,aInputHint);
        if xb then 
        if Pos(xSpcstr,ResultStr)>0 then
        begin
          xstr1:=FUrl3;
          xstr1:=StringReplace(xstr1,'?step=1&','?step=2&',[rfReplaceAll]);
          xb:=DoDownTextEx(xstr1,xCode,aInputHint);
        end;
        xSrcTextAry[2]:=ResultStr;
      end;

      SleepAWhile(FSleepPerStkCode);
      StatusBar1.Panels[2].Text := '';

      if not xb then
      begin
        ValueStatusCodeFromIni(xCode,_CXiaFail);
        if aBInputFail then
        begin
          Inc(i);
          Continue;
        end
        else begin
          tsInPut.Delete(i);
          tsFail.Add(xCode);
          Continue;
        end;
      end;

      for t4:=0 to High(xSrcTextAry) do
      begin
          ResultStr:=xSrcTextAry[t4];
          //SaveLog('TEST',ResultStr);
          if NoDataInText(ResultStr) then
            continue;
          xstr1:='<table class="hasBorder" align="center">';
          xstr1:=StringReplace(xstr1,'"',chr(39),[rfReplaceAll]);
          xstr2:='</table>';
          xstr3:=GetStrOnly2(xstr1,xstr2,ResultStr,false);
          if xstr3='' then
          begin
            raise Exception.Create('html format exception.'+xCode);
          end;
          ResultStr:=xstr3;

          aSource:=ResultStr;
          aSource:=StringReplace(aSource,#13#10,'',[rfReplaceAll]);
          aSource:=StringReplace(aSource,'<tr',#13#10+'<tr',[rfReplaceAll]);

          iClassIdx:=' '; tsDat0:=nil; 
          if t4=0 then
          begin
            iClassIdx:=_ZCFZB;
            tsDat0:=tsDat1;
          end
          else if t4=1 then
          begin
            iClassIdx:=_ZZSYB;
            tsDat0:=tsDat2;
          end
          else if t4=2 then
          begin
            iClassIdx:=_XJLLB;
            tsDat0:=tsDat3;
          end
          else
            raise Exception.Create('programe exception.');

          tsTemp2.Text:=aSource;
          for t:=0 to tsTemp2.Count-1 do
          begin
              Application.ProcessMessages;
              if StopRunning Then exit;
              aTemp02:=tsTemp2[t];
              if (Pos('<td class=',aTemp02)>0) then
              begin
                tdStrLst:=DivTdItems(aTemp02);
                //if t=39 then
                //  ShowMessage(aTemp02);
                if (Length(tdStrLst)>=2) then
                begin
                  aTemp02:=RplNode(tdStrLst[0]);
                  tsDat0.Add(aTemp02);
                  xf2:=cfs100(RplNode(tdStrLst[1]));
                  aTemp02:=floatToStr(xf2);
                  tsDat0.Add(aTemp02);
                end;
              end;
          end;
      end;

      if WriteToFile(xCode) then
      begin
        if ( (tsDat1.Count=0) and (tsDat2.Count=0) and (tsDat3.Count=0) )
           or
           (SameIFRS(xCode,sYear,sQ)) then
          ValueStatusCodeFromIni(xCode,_CNoNeedShen)
        else
          ValueStatusCodeFromIni(xCode,_CXiaOK);
        tsInPut.Delete(i);
        tsSuc.Add(xCode);

        if ExistsInTr1StkList(xCode) then
        begin
          sTimeKey:=FormatDateTime('yyyymmdd_hhmmsszzz',now);
          sLogOpCur:=CAppTopic;
          //sIDName:=GetIDNameByCode(xCode);
          sIDName:=(xCode);
          if UpdateGuidOfWorkList_IFRS(sLogOpCur,sTimeKey,xCode,sYear,sQ,
            sIDName,_OpAutoAudit,_IFRSCBDBNodeCaption,'') then
          begin
            SaveMsg('產生IFRS任務清單ok.'+Format('%s,%s,%s',[xCode,sYear,sQ]),false);
          end
          else begin
            SaveMsg('(warn)'+'產生IFRS任務清單fail.'+Format('%s,%s,%s',[xCode,sYear,sQ]),false);
          end;
        end;

        Continue;
      end
      else begin
        SaveMsg('(warn)'+'WriteToFile fail.'+tsToBe[i],false);
        ValueStatusCodeFromIni(tsToBe[i],_CXiaFail);
        if aBInputFail then
        begin
          Inc(i);
          Continue;
        end
        else begin
          tsInPut.Delete(i);
          tsFail.Add(xCode);
        end;
      end;
      if StopRunning Then exit;
      Inc(i);
    end;
  end;

begin
  Result := false;
  bChangeComCode:=False;
  ShowMsgEx('開始取得IFRS...');
  if StopRunning Then exit;
  try
  try
    tsSuc:=TStringList.create;
    tsFail:=TStringList.create;
    tsToBe:=TStringList.create;
    tsDat1:=TStringList.create;
    tsDat2:=TStringList.create;
    tsDat3:=TStringList.create;
    tsTemp1:=TStringList.create;
    tsTemp2:=TStringList.create;
    tsTemp3:=TStringList.create;
    tsTemp0:=TStringList.create;

    if not GetParasFromIni then
      exit;
    if InitComCodeRecList<>1 then
      exit;
    DoPro('tobelist',false,tsToBe);
    if StopRunning Then exit;
    DoPro('faillist',true,tsFail);
    if StopRunning Then exit;

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
     try SetLength(tdStrLst,0); except end;
     try FreeAndNil(tsSuc); except end;
     try FreeAndNil(tsFail); except end;
     try FreeAndNil(tsToBe); except end;
     try FreeAndNil(tsDat1); except end;
     try FreeAndNil(tsDat2); except end;
     try FreeAndNil(tsDat3); except end;
     try FreeAndNil(tsTemp1); except end;
     try FreeAndNil(tsTemp2); except end;
     try FreeAndNil(tsTemp3); except end;
     try FreeAndNil(tsTemp0); except end;
     
     DelLocalComCodeFile();
     if result then
     begin
       ValueStatusParasFromIni(_CCircleOk);
     end
     else begin
       ValueStatusParasFromIni(_CXiaFail);
     end;
     ShowURL('');
     StatusBar1.Panels[2].Text := '';
     showsb(-1,'');
  end;
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

function TAMainFrm.DataFileByCode(aCode,sYear,sQ:string;aClassIdx:char):string;
var s:string;
begin
  s:=aClassIdx;
  result := Format('%s\%s_%s_%s_%s.dat',[FDataPath,sYear,sQ,aCode,s]);
end;

function TAMainFrm.TrlDataFileByYQ(sYear,sQ:string;aClassIdx:char):string;
var s,sTr1Path:string;
begin
  s:=aClassIdx;
  sTr1Path:=AppParam.Tr1DBPath+'CBData\ifrs';
  result := Format('%s\%s_%s_%s.dat',[sTr1Path,sYear,sQ,s]);
end;

function TAMainFrm.SameIFRSItem(aCode,sYear,sQ:string;aClassIdx:char):Boolean;
var aRec1,aRec2:TIFRSDatRec;  sFile1,sFile2:string;  i:integer;
begin
  result:=false;
  sFile1:=DataFileByCode(aCode,sYear,sQ,aClassIdx);
  sFile2:=TrlDataFileByYQ(sYear,sQ,aClassIdx);
  aRec1:=IFRS_GetRecOfIFRSData(aCode,sFile1);
  aRec2:=IFRS_GetRecOfIFRSData(aCode,sFile2);

  if not SameText(aRec1.CompCode,aRec2.CompCode) then
    exit;
  for i:=0 to high(aRec1.NumAry) do
  begin
    if aRec1.NumAry[i]<>aRec2.NumAry[i] then
      exit;
    if aRec1.IdxAry[i]<>aRec2.IdxAry[i] then
      exit;
  end;
  result:=true;
end;

function TAMainFrm.SameIFRS(aCode,sYear,sQ:string):Boolean;
begin
  result:=SameIFRSItem(aCode,sYear,sQ,_ZCFZB) and
          SameIFRSItem(aCode,sYear,sQ,_ZZSYB) and
          SameIFRSItem(aCode,sYear,sQ,_XJLLB) ;
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
var
  LogFileLst : _CStrLst;
  i:integer;
begin
try
  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\DownIFRS\',
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

function IsRight_PartJudge(aInput:string):boolean;
begin
  Result:=false;
  if (Length(aInput)=4) then
    if (Copy(aInput,1,2)='03') or
       (Copy(aInput,1,2)='04') or
       (Copy(aInput,1,2)='05') or
       (Copy(aInput,1,2)='06') or
       (Copy(aInput,1,2)='07') or
       (Copy(aInput,1,2)='08') then
      result:=True;
end;

function TAMainFrm.GetCodeList: boolean;
const CConStr='Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Jet OLEDB:Database Password=%s';
var sItem,sPsw,sConStr,sSql,sCode,sName:string;
   i,j,ic:integer;
begin
  result:=false;
  ShowMsgEx(Format('取得代碼列表...',[]));
  sItem:=FNameTblPath+'NAMETBL.MDB';
  sSql:='select SID,SName from Stk ';
  sPsw:='';
  FIDLstMgr.Clear;
  FIDNameLstMgr.Clear;
  sConStr:=Format(CConStr,[sItem,sPsw]);
  try
  try
    ADocon.ConnectionString:=sConStr;
    ADocon.Open;
    adsNameTbl.CommandText:=sSql;
    adsNameTbl.Open;
    ic:=adsNameTbl.RecordCount;
    i:=0;
    adsNameTbl.First;
    while not adsNameTbl.Eof do
    begin
      if StopRunning then
        exit;
      Inc(i);
      showsb(2,Format('%d/%d',[i,ic]));
      sCode:=adsNameTbl.fieldbyname('SID').asstring;
      sName:=adsNameTbl.fieldbyname('SName').asstring;
      if (sCode<>'') and
         (Length(sCode)=4) and
         (MayBeDigital(sCode)) and
         (not IsRight_PartJudge(sCode))
         //(not IsRightStock(aTemp02)) and
         //(Copy(aTemp02,1,1)<>'#')
         then
      begin
        FIDLstMgr.Add(sCode);
        FIDNameLstMgr.Add(sCode+#9+sName);
      end;
      adsNameTbl.Next;
    end;
    if FIDLstMgr.Count=0 then
    begin
      ShowMsgEx(Format('代碼列表為空.',[]));
      Exit;
    end;
    FIDLstMgr.Sort;
    result:=true;
  except
    on e:Exception do
    begin
      ShowMsgEx('獲取代碼列表出現異常.'+e.Message);
    end;
  end;
  finally
    showsb(2,'');
    showsb(1,'');
    try  adsNameTbl.close; except end;
    try  ADocon.close; except end;
  end;
end;

function TAMainFrm.CreateWorkLst(aYear, aQ: Integer): Boolean;
var fini:TIniFile;
  i,j:Integer; sFile,sTemp1:string;
begin
  result:=false;
  ShowMsgEx(Format('創建IFRS任務清單...',[]));
  sFile:=WorkLstFile;


  try
  try
    DelDatF(sFile);
    fini:=TIniFile.Create(sFile);
    fini.Writeinteger('work','year',aYear);
    fini.Writeinteger('work','q',aQ);
    fini.WriteString('work','status',_CCreateWorkList);
    fini.Writefloat('work','createtime',now);

    Deltree(FDataPath,false,false);
    if not DirectoryExists(FDataPath) then
      MkDir(FDataPath);

    if not GetCodeList then
    begin
      Exit;
    end;

    j:=0;
    for i:=0 to FIDLstMgr.Count-1 do
    begin
      if StopRunning then
        exit;
      showsb(2,Format('%d/%d',[i+1,FIDLstMgr.Count]));
      sTemp1:=Trim(FIDLstMgr[i]);
      if sTemp1='' then
        Continue;
      Inc(j);
      fini.WriteString('list',sTemp1,_CDaiXia);
    end;
    if j=0 then
    begin
      ShowMsgEx(Format('代碼列表為空.',[]));
      Exit;
    end;
    
    fini.WriteString('work','status',_CDaiXia);
    result:=true;
  except
    on e:Exception do
    begin
      ShowMsgEx('創建IFRS任務清單出現異常.'+e.Message);
    end;
  end;
  finally
    showsb(2,'');
    showsb(1,'');
    try
      if Assigned(fini) then
      begin
        if not Result then
          fini.WriteString('work','status',_CCreateWorkListFail);
        FreeAndNil(fini);
      end;
    except
    end;
  end;
end;

function TAMainFrm.WorkLstFile: string;
begin
  Result:=ExtractFilePath(ParamStr(0))+_IFRSWorklst;
end;

procedure TAMainFrm.btn1Click(Sender: TObject);
begin
  try
    TButton(sender).Enabled:=false;
      CreateWorkLst(2015,3);
  finally
    TButton(sender).Enabled:=true;
  end;
end;

procedure TAMainFrm.btn2Click(Sender: TObject);
begin
  try
    TButton(sender).Enabled:=false;
    if StartGet() then
      ShowMessage('ok')
    else
      ShowMessage('fail');

  finally
    TButton(sender).Enabled:=true;
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
      if (FParamStrAry[0]<>'') and
         (FParamStrAry[1]<>'') then
      begin
          if CreateWorkLst(StrToInt(FParamStrAry[0]),StrToInt(FParamStrAry[1])) then
          begin
            FParamStrAry[0]:='';
            FParamStrAry[1]:='';
            FParamStrAry[2]:='';
          end;
      end;
      StartGet;
      SetLength(AryStatus,3);
      AryStatus[0]:=_CNoNeedShen;
      AryStatus[1]:=_CShen;
      AryStatus[2]:=_CXiaOK;
      if GetIFRSListStatus_ForDownIFS(AryStatus,aOutPut) then
      begin
        try Application.Terminate; except end;
        try Halt; except end;
      end;
      SetLength(AryStatus,0);
      SaveMsg(aOutPut,true);
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


