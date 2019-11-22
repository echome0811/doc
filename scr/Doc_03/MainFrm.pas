/////////////////////////////////////////////////////////////////////////////////
//20070530修改适应于新的网站
//20071212添加网页截取接口-by cody-add
//调用DLLHtmlParser.dll截取公告内容-by cody-add
//20080115界面显示提示修改-by cody-modify
//Doc_03-DOC3.0.0需求4-leon-08/8/15; (修改过会网页无法下载解析，并调用DLLHtmlParser.dll中GetTextAccordingToInifile函数来定位网页脚本中的字符串)
//--DOC4.0.0—N001 huangcq090407 add Doc与WarningCenter整合
/////////////////////////////////////////////////////////////////////////////////
unit MainFrm;

interface

uses
  ShareMem,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, IdIntercept, IdLogBase, IdLogDebug,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,csDef, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,IniFiles,TCommon,TDocMgr, ImgList,
  CoolTrayIcon,SocketClientFrm,TSocketClasses, OleCtrls,UrlMon,ActiveX,
  SHDocVw,mshtml; //TWarningServer,

const S_ABORT = HRESULT($80004004);

type
  TTokenType=(ttNone,ttP,ttTable,ttTR,ttTD,ttDiv,
              ttImg,ttA,ttB,ttI,ttScript,ttLi,ttHr,
              ttH,ttSpan,ttStyle,ttFont,ttHead,ttTitle,
              ttCenter,ttBody,ttHtml,ttStrong);//20071212添加网页截取接口-by cody-add

  TDisplayMsg=Class
  private
    FMsg : TLabel;
    FMsgTmp : String;
    FLogFile :TextFile;
    FLogFileName : String;
    procedure SetInitLogFile();
    procedure SaveToLogFile(Const Msg:String);
  public
      constructor Create(AMsg: TLabel;Const LogFileName:String);
      destructor  Destroy; override;
      procedure AddMsg(Const Msg:String);
      procedure SaveMsg(const Msg:String);
  End;


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
//    CoolTrayIcon: TCoolTrayIcon;
    ImageList1: TImageList;
    CoolTrayIcon: TCoolTrayIcon;
    Label2: TLabel;
    TimerSendLiveToDocMonitor: TTimer;
    PanelCaption_URL: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure LogDebugLogItem(ASender: TComponent; var AText: String);
    procedure HTTPStatus(axSender: TObject; const axStatus: TIdStatus;
      const asStatusText: String);
    procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure HTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure Timer_StartGetDocTime(Sender: TObject);
    procedure CoolTrayIconDblClick(Sender: TObject);
    procedure TimerSendLiveToDocMonitorTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure CoolTrayIconDblClick(Sender: TObject);
  private
    FTeamFilePath:string;  //20071212添加网页截取接口-by cody-add
    FDataPath : String;
    FDocPath  : String;
    FLogFileName : String;
    FTempDocFileName : String;
    FNowIsRunning: Boolean;
    StopRunning : Boolean;
    DisplayMsg : TDisplayMsg;
    DocDataMgr : TDocDataMgr;
    FEndTick : DWord;
    AppParam : TDocMgrParam;
    FMonitor:TDownLoadMonitor;
    FDeadLine:boolean;
    FDocKeyList:TStringList;

    FStopRunningSkt : Boolean;  //--DOC4.0.0—N001 huangcq090407 add
    ASocketClientFrm : TASocketClientFrm; //--DOC4.0.0—N001 huangcq090407 add
    procedure SendDocMonitorStatusMsg;//--DOC4.0.0—N001 huangcq090407 add
    function SendDocMonitorWarningMsg(const Str: String): boolean;//--DOC4.0.0—N001 huangcq090407 add
    procedure Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);//--DOC4.0.0—N001 huangcq090407 add       

    procedure SetNowIsRunning(const Value: Boolean);
  private
    { Private declarations }
    property NowIsRunning:Boolean Read FNowIsRunning Write SetNowIsRunning;

    function ThisMemoIsOk(const Memo:String):Boolean;
    function  StartGetDocHtml(const TxtUrl:String):String;
    function StartGetDocTitle():Boolean;
    function IsDeadLineDate(aDate:TDate):boolean;
    function GetDocTitle(AIntext:String;var ParseOk:boolean):boolean;
    function GetDocTitle0(AIntext:String;var ParseOk:boolean):boolean;
    procedure GetAllDocPage(Txt:TStringList;Var AllPage,NowPage:Integer);

    procedure ShowRunBar(const Max,NowP:Integer;Const Msg:String);

    procedure OnGetLogFile(FileName: String);
  public
    { Public declarations }
    HaveDownFinished:Boolean;
    procedure InitObj();
    procedure ShowURL(const msg:String);
    procedure ShowMsg(const Msg:String);
    procedure SaveMsg(const Msg:String);
    procedure Start();
    procedure Stop();
    procedure InitForm();

    function GetTitles(iFangFa:integer;AUrl:string;var ErrMsg:String;var ParseOk:boolean):Boolean;
    function DownloadFile2(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
    procedure DownLoadProcessEvent(  Sender: TFileDownLoadThread;
         Progress, ProgressMax: Cardinal;StatusCode: ULONG; StatusText: string);

    function GetHttpTextByUrl(aUrl:string; var aOutHtmlText,aErrStr:string):Boolean;
    function GetHtmlText(AHTTP: TIdHTTP;AUrl:String;var OutHtmlText,ErrMsg:String):Boolean;
    procedure HttpStatusEvent(ASender: TObject;AStatusText: string;aKey:string);
    procedure HttpBeginEvent(Sender: TObject;AWorkCountMax: Integer;aKey:string);
    procedure HttpEndEvent(Sender: TObject;aDoneOk:Boolean;aKey,aResult:string);
    procedure HttpWorkEvent(Sender: TObject; AWorkCount,AWorkMax: Integer;aKey:string);

  end;
  //调用DLLHtmlParser.dll截取公告内容-by cody-add
  function GetText(TokenType:TTokenType;site:integer;InText:string;var OutText:string):boolean; stdcall;external  'DLLHtmlParser.dll';
  function SubStringReplace(SubString, ReplaceString:string; var Source:string):boolean;  stdcall;external  'DLLHtmlParser.dll';
  function GetTextAccordingToInifile(InText:string;var OutText:string;InifileName:string):boolean;stdcall;external  'DLLHtmlParser.dll';
  //Doc_03-DOC3.0.0需求4-leon-08/8/15-modify;

var
  AMainFrm: TAMainFrm;
  //20070530修改适应于新的网站
  AllPage_All : Integer;
  ATeamFile:string; //存放路径变量  //20071212添加网页截取接口-by cody-add
implementation

{$R *.dfm}

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
  //FMonitor:=TDownLoadMonitor.Create();
  AResultStr:= '';
  AErrMsg := '';
  //tmpFile := GetWinTempPath+Get_GUID8+'.txt';
  tmpFile := ExtractFilePath(ParamStr(0))+Get_GUID8+'.txt';

  //Result := UrlDownloadToFile(nil, PAnsiChar(AUrl),PAnsiChar(tmpFile), 0, FMonitor as IBindStatusCallback) = 0;
  //AMainFrm.StatusBar1.Panels[2].Text := '';
  AUrl := AUrl + Format('?skq=%d',[GetTickCount()]);
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
       if i > 60 then
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
  try FreeAndNil(ts); except end;
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

function RemoveStr(SToken,EToken,InText:String;var OutText:string):boolean;
var
  beginpos,endpos:integer;
  vToken,vFrontToken,vBehindToken:String;
begin
  result:=false;
  OutText := InText;

  repeat
    beginpos:=pos( UpperCase(SToken),UpperCase(OutText) );
    endpos:=pos( UpperCase(EToken),UpperCase(OutText));
    if (beginpos<>0) and
       (endpos<>0) and
       (beginpos<endpos) then
       delete(OutText,beginpos,endpos-beginpos + Length(EToken));
  until (beginpos=0) or (endpos=0) or (beginpos > endpos) ;
  result:=true;
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
    FFinish := DownRet=S_OK;
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


{TAMainFrm}
procedure TAMainFrm.OnGetLogFile(FileName: String);
Var
  ADate : TDate;
begin
Try
  ADate := FileDateToDateTime(FileAge(FileName));
  //刪除15天之前的紀錄
  if (Date-ADate)>=90 Then
    DeleteFile(FileName);
Except
End;
end;


procedure TAMainFrm.InitForm;
begin
  AppParam := TDocMgrParam.Create;
  self.caption:=AppParam.TwConvertStr('筁穦そ穓栋ㄣ');
  FDataPath := ExtractFilePath(Application.ExeName)+'Data\';
  FTeamFilePath := ExtractFilePath(Application.ExeName)+'Doc03.ini';//20071212添加网页截取接口-by cody-add
  FDocPath  := '';

  Mkdir_Directory(FDataPath);
  Mkdir_Directory(FDocPath);

  FTempDocFileName := FDataPath+'Doc_03.tmp';

  FLogFileName := 'Doc_03';

  FEndTick := GetTickCount + Round(1000);
  Timer_StartGetDoc.Enabled := True;
  NowIsRunning := false;
  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;

  Http.ReadTimeout :=15000;

//  ConnectToSoundServer(AppParam.SoundServer,
//                       AppParam.SoundPort);
  //--DOC4.0.0—N001 huangcq090407 add------>
  FStopRunningSkt := False;
  ASocketClientFrm := TASocketClientFrm.Create(Self,'Doc_03',AppParam.DocMonitorHostName
                                            ,AppParam.DocMonitorPort,Msg_ReceiveDataInfo);

  TimerSendLiveToDocMonitor.Interval := 3000;
  TimerSendLiveToDocMonitor.Enabled  := True;
  //<------DOC4.0.0—N001 huangcq090407 add----

end;


function TAMainFrm.ThisMemoIsOk(const Memo: String): Boolean;
var i:integer;
begin
    Result:=False;
    if FDocKeyList.Count=0 then
    begin
      result:=true;
      exit;
    end;
    for i:=0 to FDocKeyList.Count-1 do
    begin
      if (Pos(FDocKeyList[i],Memo)>0) then
      begin
        result:=true;
        exit;
      end;
    end;
    //Result :=  (Pos('可转债',Memo)>0) or (Pos('可转换公司债',Memo)>0) or(Pos('可分离债',Memo)>0);
    //Result:=(Pos(Doc03List.ReadString('Key','1',''),Memo)>0)or (Pos(Doc03List.ReadString('Key','2',''),Memo)>0)or(Pos(Doc03List.ReadString('Key','3',''),Memo)>0);
end;

procedure TAMainFrm.FormCreate(Sender: TObject);
var Doc03List:TIniFile;  
  i,Count:integer; sTemp:string;
begin
   InitForm;
   InitObj;
   //20071212
   FDocKeyList:=TStringList.create;
   if FileExists(FTeamFilePath) then
   begin
     Doc03List:=TIniFile.Create(FTeamFilePath); //20071212睰呼篒钡-by cody-add
     Count:=Doc03List.ReadInteger('Key','Count',0);
     for i:=1 to Count do
     begin
       sTemp:=Doc03List.ReadString('Key',IntToStr(i),'');
       if sTemp='' then
         Continue;
       FDocKeyList.Add(sTemp);
     end;
   end;
   //************************
   btnGo.Click;
   self.Show;
end;

procedure TAMainFrm.Start;
begin
   StopRunning  := False;
   NowIsRunning := True;
   FEndTick := GetTickCount + Round(1000);
   Timer_StartGetDoc.Interval := 1000;
end;

procedure TAMainFrm.SetNowIsRunning(const Value: Boolean);
begin
   FNowIsRunning := Value;
   btnGo.Enabled := Not Value;
   btnStop.Enabled := Value;

   if Value Then
      Screen.Cursor := crHourGlass
   Else
   Begin
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
      Http.DisconnectSocket;
   Except
   end;

end;

procedure TAMainFrm.btnStopClick(Sender: TObject);
begin
  Stop;
end;

procedure TAMainFrm.ShowMsg(const Msg: String);
begin
    if DisplayMsg<>nil Then
       DisplayMsg.AddMsg(Msg);
end;

procedure TAMainFrm.GetAllDocPage(Txt: TStringList; var AllPage,
  NowPage: Integer);
var
i:integer;
Str_Temp:String;
pos_start,pos_end:integer;
Begin
 if NowPage=0 then
   begin

     i:=0;
     while i< Txt.Count do
       begin

         if StopRunning Then exit;
         Str_Temp := Trim(Txt.Strings[i]);
         if (pos('<a href=/n575458/n776436/n804920/n825306/index_'{<a href=/n575458/n575742/n576144/index_},Str_Temp)>0) then//and (pos('下一页',Str_Temp)>0) then //Doc_03-DOC3.0.0需求4-leon-08/8/15-modify;
           begin
             pos_start:=pos('<a href=/n575458/n776436/n804920/n825306/index_'{<a href=/n575458/n575742/n576144/index_},Str_Temp)+length('<a href=/n575458/n776436/n804920/n825306/index_'{<a href=/n575458/n575742/n576144/index_}); //Doc_03-DOC3.0.0需求4-leon-08/8/15-modify;
             //pos_end:=pos('下一页',Str_Temp);
             pos_end:=pos('.html target="_self">',Str_Temp);
             AllPage:=strtoint(copy(Str_Temp,pos_start,pos_end-pos_start));
           end;
         inc(i,1);
       end;
   end;

end;

function TAMainFrm.IsDeadLineDate(aDate:TDate):boolean;
begin
  result:=(aDate<(date-AppParam.Doc03BeforeM*30))
end;

function TAMainFrm.GetDocTitle(AIntext:String;var ParseOk:boolean):boolean;
var i : integer;
  vInText,vOutText,sTemp1,sLine : String;
  TxtHttp,TxtCaption,TxtDateTime  : String;
  TxtTime  : TTime;TxtDate  : TDate;DateTime : TDateTime;
  Year,Month,Day : Word;  bValidate,b2:Boolean;
  tsAry:array[0..5] of TStringList;
begin
  Result := True;  ParseOk:=False; bValidate:=true;b2:=false;
  vInText :=  AIntext;
  vOutText := GetStrOnly2('<div class="fl_list">','</ul>',vInText,True);
  if vOutText='' then
    exit;
try
try
  for i:=0 to High(tsAry) do
    tsAry[i]:=TStringList.Create;
  vOutText:=StringReplace(vOutText,#13#10,'',[rfReplaceAll]);
  vOutText:=StringReplace(vOutText,#10,'',[rfReplaceAll]);
  vOutText:=StringReplace(vOutText,#13,'',[rfReplaceAll]);
  vOutText:=StringReplace(vOutText,#9,'',[rfReplaceAll]);
  vOutText:=StringReplace(vOutText,'<li>',#13#10+'<li>',[rfReplaceAll]);
  ///SaveMsg('vOutText:'+vOutText); 
  tsAry[0].text:=vOutText;
  for i:=0 to tsAry[0].count-1 do
  begin
    Sleep(100);
    Application.ProcessMessages;
    sLine:=tsAry[0][i];
    if (Pos('<li>',sLine)>0) and (Pos('</li>',sLine)>0) then
    begin
      TxtHttp:=GetStrOnly2('href="','"',sLine,false);
      if Pos('../../../',TxtHttp)>0 then
        TxtHttp:=StringReplace(TxtHttp,'../../../','http://www.csrc.gov.cn/',[rfReplaceAll]);
      TxtCaption:=GetStrOnly2('<a','</a>',sLine,true);
      TxtCaption:=GetStrOnly2('>','</a>',TxtCaption,false);
      TxtDateTime:=GetStrOnly2('<span>','</span>',sLine,false);
      ReplaceSubString('年',DateSeparator,TxtDateTime);
      ReplaceSubString('月',DateSeparator,TxtDateTime);
      ShowMsg(TxtCaption+'('+TxtDateTime+')');
      Application.ProcessMessages;
      SaveMsg(TxtCaption+'('+TxtDateTime+')'+TxtHttp);
      DateTime := StrToDate2(TxtDateTime);
      DeCodeDate(DateTime,Year,Month,Day);
      TxtDate := EncodeDate(Year,Month,Day);
      TxtTime := 0;
      if ((DateTime<=1) or
         (TxtCaption='') or
         (TxtHttp='')) then
      begin
        bValidate:=false;
        Continue;
      end;

      b2:=True;
      if IsDeadLineDate(TxtDate) then
      begin
        FDeadLine:=true;
        Break;
      end;
      Application.ProcessMessages;
      Sleep(10);
      DocDataMgr.AddADoc01(TxtCaption,'','',TxtDate,TxtTime,TxtHttp);
      Application.ProcessMessages;
    end;
    if StopRunning Then exit;
  end;

  ParseOk:=bValidate and b2;
except
  on e:Exception do
  begin
    Result := false;
    e := nil;
  end;
end;
finally
  for i:=0 to High(tsAry) do
    FreeAndNil(tsAry[i]);
end;
end;

function TAMainFrm.GetDocTitle0(AIntext:String;var ParseOk:boolean):boolean;
const
  ConstBaseUrl='http://www.csrc.gov.cn/pub/zjhpublic';
  SFlagUrl='<a href=';
  EFlagUrl='target=';
  SFlagDate='<li class="fbrq"';
  EFlagDate='日</li>';
  RowFlag='<li class="xh">';
Var
  i,iBegin,iEnd : integer;
  vInText,vOutText,sTemp1 : String;
  TxtHttp,TxtCaption,TxtDateTime  : String;
  TxtTime  : TTime;TxtDate  : TDate;DateTime : TDateTime;
  Year,Month,Day : Word;  bValidate,b2:Boolean;
begin
  Result := True;  ParseOk:=False; bValidate:=true;b2:=false;
  vInText :=  AIntext;
  vOutText := '';
try
  if not GetText(ttDiv,1,vInText,vOutText) then
    exit;
  Sleep(100);
  vInText := vOutText;
  if not GetText(ttDiv,4,vInText,vOutText) then
    exit;
  Sleep(100);
  vInText := vOutText;
  if not GetText(ttDiv,2,vInText,vOutText) then
    exit;

  vInText := vOutText;

  i := 1;
  while True do
  begin
    Application.ProcessMessages;
    Sleep(100);
    if not GetText(ttDiv,i,vInText,vOutText) then
      Break;
    //'审核结果'
    //if Pos('可转换公司债券',vOutText)>0 then
    begin
        Sleep(100);
        if GetText(ttA,1,vOutText,TxtCaption) then
        begin
          iBegin := Pos(SFlagUrl,vOutText);
          iEnd := Pos(EFlagUrl,vOutText);
          TxtHttp := Copy(vOutText,iBegin+Length(SFlagUrl),iEnd-(iBegin+Length(SFlagUrl)) );
          ReplaceSubString('"','',TxtHttp);
          ReplaceSubString('../../','/',TxtHttp);
          TxtHttp := ConstBaseUrl + TxtHttp;

          TxtDateTime:=GetStrOnly2(SFlagDate,EFlagDate,vOutText,true);
          TxtDateTime:=GetStrOnly2('>',EFlagDate,TxtDateTime,false);
          ReplaceSubString('年',DateSeparator,TxtDateTime);
          ReplaceSubString('月',DateSeparator,TxtDateTime);
          sTemp1:=GetStrOnly2('<font','>',TxtCaption,true);
          if sTemp1<>'' then
          begin
            TxtCaption:=StringReplace(TxtCaption,sTemp1,'',[rfReplaceAll]);
          end;
          TxtCaption:=StringReplace(TxtCaption,'</font>','',[rfReplaceAll]);
          ShowMsg(TxtCaption+'('+TxtDateTime+')');
          Application.ProcessMessages;
          SaveMsg(TxtCaption+'('+TxtDateTime+')'+TxtHttp);
          DateTime := StrToDate2(TxtDateTime);
          DeCodeDate(DateTime,Year,Month,Day);
          TxtDate := EncodeDate(Year,Month,Day);
          TxtTime := 0;
          if ((DateTime<=1) or
             (TxtCaption='') or
             (TxtHttp='')) then
          begin
            bValidate:=false;
            Continue;
          end;
          
          b2:=True;
          if IsDeadLineDate(TxtDate) then
          begin
            FDeadLine:=true;
            Break;
          end;
          Application.ProcessMessages;
          Sleep(10);
          DocDataMgr.AddADoc01(TxtCaption,'','',TxtDate,TxtTime,TxtHttp);
          Application.ProcessMessages;
          {if DocDataMgr.AddADoc(TxtCaption,'','',TxtDate,TxtTime,TxtHttp)=nil Then
            Begin
                Result := false;
                Break;
            End;}
        end;

        if StopRunning Then exit;
    end;
    Inc(i);
  end;
  ParseOk:=bValidate and b2;
except
  on e:Exception do
  begin
    Result := false;
    e := nil;
  end;
end;
end;


function TAMainFrm.StartGetDocHtml(const TxtUrl: String): String;
var
  Response:TStringList;
  Str : String;
  t1,t2 : integer;
  ResultStr : String;
  vErrMsg : String;
  OUTputText,OUTputText1,OUTputText2,OUTputText3,OUTputText4,OUTputText5,
                  OUTputText6,OUTputText7,OUTputTitle,OUTputStr:String;
  StartPos,EndPos: integer;
  FTokenType:TTokenType;   //调用DLLHtmlParser.dll截取公告内容-by cody-add
begin
  // Add the URL to the combo-box.
  Result := '';
  try
    //if DownloadFile2(TxtURL,ResultStr,vErrMsg) then
    if GetHtmlText(HTTP,TxtURL,ResultStr,vErrMsg) then
    begin
      ResultStr:=UTF8Decode(ResultStr);
    end
    else
      ResultStr:='404 Not Found';

    if Pos('404 Not Found',ResultStr)>0 Then
    Begin
       Result := ResultStr;
    End
    Else Begin
      if Length(ResultStr)>0 Then
      Begin
        Response := TStringList.Create;

        StartPos:=Pos('<title>',ResultStr);    //Doc_03-DOC3.0.0需求4-leon-08/8/15-add;
        EndPos:=Pos('</title>',ResultStr);
        OUTputTitle:=copy(ResultStr,StartPos+7,EndPos-StartPos-7);
         try
                GetTextAccordingToInifile(ResultStr,OutputStr,FTeamFilePath); //Doc_03-DOC3.0.0需求4-leon-08/8/15-modify;
                RemoveStr('<style','</style>',OutputStr,OutputStr);
                ReplaceSubString('&NBSP;','',OutputStr);
                StartPos:=Pos('<',OutputStr);
                EndPos:=Pos('>',OutputStr);

                while (StartPos<>0) and (EndPos<>0) and (EndPos>StartPos) do
                begin
                  Application.ProcessMessages;
                  delete(OutputStr,StartPos,EndPos-StartPos+1);
                  StartPos:=Pos('<',OutputStr);
                  EndPos:=Pos('>',OutputStr);
                end;
                Response.Add(OUTputTitle+' '+OUTputStr);
                Result:=Response.Text;
                // Result := OutputStr;
         except
          showmsg('调用dll函数解析出现异常');
         end;
          if Length(Result)=0 Then
          Result := ResultStr;
//======================================================================
      End;
    End;
  finally
     if (Length(Result)>0) and (Pos('404 Not Found',ResultStr)=0) Then
        SaveMsg('文章内容成功取得  ')
     Else
        SaveMsg('文章内容无法取得');
  end;

End;



function TAMainFrm.GetTitles(iFangFa:integer;AUrl:String;var ErrMsg:String;var ParseOk:boolean):Boolean;
var
  ResultStr : String;
begin
  Result := False; ParseOk:=false;
  ErrMsg := '';
  if not (iFangFa in [0,1]) then
    Exit;
  try
  try
    //HTTP.Request.ContentType := 'text/html; charset=gb2312';
    // HTTP.Intercept := LogDebug;
    //HTTP.ClosedGracefully := False;
    ShowURL(AUrl);
    //if DownloadFile2(AUrl,ResultStr,ErrMsg) then
    if GetHtmlText(HTTP,AUrl,ResultStr,ErrMsg) then
    begin
      if Length(ErrMsg)>0 Then
        raise Exception.Create(ErrMsg);
      if StopRunning Then Exit;
      if (UTF8Decode(ResultStr))<>''  then 
      ResultStr:=UTF8Decode(ResultStr) ;
      if (Length(ResultStr)>0) then 
      //  and ((Pos('可转换公司债券',ResultStr)>0) or (Pos('可转债',ResultStr)>0))
      //  and (Pos('审核结果',ResultStr)>0) then
      Begin
        //if iFangFa=0 then
        //  Result := GetDocTitle0(ResultStr,ParseOk)
        //else
         Result := GetDocTitle(ResultStr,ParseOk);
      End else
        Result := true;
    end else
      raise Exception.Create(ErrMsg);

  Except
     On E:Exception do
     Begin
         ErrMsg := E.Message;
         ShowMsg(E.Message);
         SaveMsg(E.Message);
         if (not (Pos('Socket Error',E.Message)>0)) and
            (not (Pos('HTTP/1.0 404',E.Message)>0)) then
           SendDocMonitorWarningMsg('过会转债收集下载过程出现错误('+E.Message+')$E003');
         E := nil;
     End;
  End;
  finally
      ShowURL('');
      ShowMsg('');
      StatusBar1.Panels[2].Text := '';
  end;
end;

Function TAMainFrm.StartGetDocTitle():Boolean;
const
  //ConstUrl='http://www.csrc.gov.cn/wcm/govsearch/searPage.jsp?page=%s&pubwebsite=zjhpublic&indexPa=2&schn=3621&sinfo=3300&surl=zjhpublic/3300/3621/index_810_14.htm&curpos=';
  //ConstUrl='http://www.csrc.gov.cn/wcm/govsearch/keywordView.jsp?nameID=%E5%8F%AF%E8%BD%AC%E5%80%BA%20or%20%E5%8F%AF%E8%BD%AC%E6%8D%A2%E5%85%AC%E5%8F%B8%E5%80%BA%E5%88%B8&rela=&slID=&pID=keywords&name=%E5%8F%AF%E8%BD%AC%E5%80%BA&page=%pageindex%';
  //ConstUrl='http://www.csrc.gov.cn/wcm/govsearch/keywordView.jsp?nameID=%E5%AE%A1%E6%A0%B8%E7%BB%93%E6%9E%9C&rela=and&slID=subcat=3480&pID=keywords&name=%E5%8F%91%E5%AE%A1%E5%A7%94%E5%AE%A1%E6%A0%B8%E5%85%AC%E5%91%8A&page=%pageindex%';
  //ConstUrl='http://www.csrc.gov.cn/wcm/govsearch/year_gkml_list.jsp?schn=3621&years=ss%year%&sinfo=3300&countpos=1&curpos=%E5%8F%91%E5%AE%A1%E4%BC%9A%E5%85%AC%E5%91%8A&page=%pageindex%';
  //ConstUrl0='http://www.csrc.gov.cn/pub/zjhpublic/3300/3621/index_7401.htm';
  ConstUrl0='http://www.csrc.gov.cn/pub/newsite/fxjgb/fshgg/index.html';
var
  i,AllPage,NowPage : Integer;
  Url,ResultStr ,TxtMemo,vErrMsg: String;
  ADoc : TDocData; bParseOk,b1,b2,bFirstOk:boolean;
  DoneOk:Boolean;aYear, aMonth, aDay:WORD;
begin
  try
  try
      FDeadLine:=false;
      Result := false;
      DecodeDate(date, aYear, aMonth, aDay);
      bParseOk:=true; b1:=False; b2:=false;

      bFirstOk:=true;
      NowPage := 0;
      Url:=ConstUrl0;
      ShowRunBar(0,0,'');
      DoneOk := true;
      AllPage := AppParam.Doc03PageSum;
      {begin
        Application.ProcessMessages;
        ShowRunBar(AllPage,NowPage,IntToStr(NowPage)+'/'+IntToStr(AllPage));
        DoneOk := False;
        for i := 0 to 3 do
        begin
          if StopRunning Then exit;
          DoneOk := GetTitles(0,Url,vErrMsg,b1);
          if DoneOk then
            b2:=True;
          if not b1 then
             bParseOk:=false;
          if FDeadLine then
            break;
          if DoneOk or ((not DoneOk) and (vErrMsg = '')) then
            Break;
        end;
        if FDeadLine then
          bFirstOk:=false;
        if (not DoneOk) and (vErrMsg='')  then
          bFirstOk:=false
        else if not DoneOk then
          bFirstOk:=false;
      end; }

      if bFirstOk then
      begin
        NowPage := 1;
        Url:=ConstUrl0+'?tick='+inttostr(GetTickCount);
        ShowRunBar(0,0,'');
        DoneOk := true;
        AllPage := AppParam.Doc03PageSum;
        while NowPage <= AllPage do
        begin
          Application.ProcessMessages;
          ShowRunBar(AllPage,NowPage,IntToStr(NowPage)+'/'+IntToStr(AllPage));
          DoneOk := False;
          for i := 0 to 3 do
          begin
            if StopRunning Then exit;
            DoneOk := GetTitles(0,Url,vErrMsg,b1);
            if DoneOk then
              b2:=True;
            if not b1 then
               bParseOk:=false;
            if FDeadLine then
              break;
            if DoneOk or ((not DoneOk) and (vErrMsg = '')) then
              Break;
          end;
          if FDeadLine then
              break;
          if (not DoneOk) and (vErrMsg='')  then
            break
          else if not DoneOk then
            exit;
          Inc(NowPage);
          Url:=ConstUrl0;
          Url :=StringReplace(Url,'index.html',Format('index_%d.html',[NowPage-1]),[rfReplaceAll]);
          Url:=Url+'?tick='+inttostr(GetTickCount);
        end;
      end;


      bParseOk:=bParseOk and b2;
      if bParseOk then
      begin
        SaveIniFile(PChar('Doc_03'),PChar('Ok'),
          PChar(floattostr(now)),PChar(ExtractFilePath(ParamStr(0))+'setup.ini'))
      end;
      
      DocDataMgr.SaveNotMemoDocLogFile('NONEDoc3');
      //DocDataMgr.SaveEndReadDocLogFile('NONEDoc3');
      DocDataMgr.WriteLogHistory();

      for i:=0 to DocDataMgr.DocList.Count-1 do
      Begin
        Application.ProcessMessages;
        if StopRunning Then Break;
        Label2.Caption:=' ';
        ShowRunBar(DocDataMgr.DocList.Count,i+1,IntToStr(i)+'/'+IntToStr(DocDataMgr.DocList.Count));
        ADoc := DocDataMgr.DocList.Items[i];
        ShowMsg(ADoc.Title);
        SaveMsg(ADoc.Title);
        TxtMemo := StartGetDocHtml(ADoc.URL);
        if Length(TxtMemo)=0 Then Break;
        //20080115界面显示提示修改-by cody-modify
        //****************************************************
        if ThisMemoIsOk(TxtMemo) Then
        begin
          HaveDownFinished := True;
          DocDataMgr.SetADocMemo(ADoc,TxtMemo)
        end Else
           DocDataMgr.SetADocMemo(ADoc,'DELETE');
        //**********************************************
      End;

      for i:=0 to DocDataMgr.NotGetMemoDocList.Count-1 do
      Begin
        Application.ProcessMessages;
        if StopRunning Then Break;
        Label2.Caption:=' ';
        ShowRunBar(DocDataMgr.NotGetMemoDocList.Count,i+1,IntToStr(i)+'/'+IntToStr(DocDataMgr.NotGetMemoDocList.Count));
        ADoc := DocDataMgr.NotGetMemoDocList.Items[i];
        ShowMsg(ADoc.Title);
        SaveMsg(ADoc.Title);
        TxtMemo := StartGetDocHtml(ADoc.URL);
        if Length(TxtMemo)=0 Then Break;
        //20080115界面显示提示修改-by cody-modify
        //*****************************************
        if ThisMemoIsOk(TxtMemo) Then
        begin
          HaveDownFinished := True;
          DocDataMgr.SetADocMemo(ADoc,TxtMemo)
        end Else
          DocDataMgr.SetADocMemo(ADoc,'DELETE');
        //**************************************************
      End;
      DocDataMgr.SaveToTempDocFile3;
      DocDataMgr.SaveNotMemoDocLogFile('NONEDoc3');

      Result := True;
  Except
     On E:Exception do
     Begin
         ShowMsg(E.Message);
         SaveMsg(E.Message);
         SendDocMonitorWarningMsg('过会转债收集下载过程出现错误('+E.Message+')$E003');
         E := nil;
     End;
  End;
  finally
      ShowURL('');
      ShowMsg('');
      StatusBar1.Panels[2].Text := '';
  end;
End;

procedure TAMainFrm.LogDebugLogItem(ASender: TComponent;
  var AText: String);
begin
   Application.ProcessMessages;
end;

procedure TAMainFrm.HTTPStatus(axSender: TObject;
  const axStatus: TIdStatus; const asStatusText: String);
begin
    StatusBar1.Panels[2].Text := asStatusText;
end;

procedure TAMainFrm.HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
 StatusBar1.Panels[2].Text := IntToStr(AworkCount) + ' bytes.';
end;

procedure TAMainFrm.HTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  if AWorkCountMax > 0 then
    StatusBar1.Panels[2].Text := 'Transfering: ' + IntToStr(AWorkCountMax);
end;

procedure TAMainFrm.HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  StatusBar1.Panels[2].Text := 'Done';
end;

//--DOC4.0.0—N001 huangcq090407 add----------->
procedure TAMainFrm.SendDocMonitorStatusMsg;
begin

  if ASocketClientFrm<>nil Then
  Begin
     ASocketClientFrm.SendText('SendTo=DocMonitor;'+
                                'Message=Doc_03;'
                                );
                                //'UploadUplData='+IntToStr(BoolToInt(FFinishCloseMarket))+';'

  End;
end;

function TAMainFrm.SendDocMonitorWarningMsg(const Str: String): boolean;
var AStrAllowed:String;
begin
  if ASocketClientFrm<>nil Then
    Begin
      //SocketClient sendtext format is '#%B%SocketName='+sendvalue+';%E%#' ,thus,must
      //replace the substring of '#' in the sendvalue
      AStrAllowed:=Str;
      ReplaceSubString('#','',AStrAllowed);
      Result := ASocketClientFrm.SendText('SendTo=DocMonitor;'+
                                        'MsgWarning='+AStrAllowed);
    End;
end;

procedure TAMainFrm.Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);
Var
  WMString: PWMReceiveString;
  Value,Value2 : String;
begin
  if FStopRunningSkt then exit;
  Try
    WMString :=  ObjWM;
    if WMString.WMType='DOCPACKAGE' Then  //RCCPackage
    Begin
     Value2 := GetReceiveStrColumnValue('Broadcast',WMString.WMReceiveString);
     if Length(Value2)>0 Then
     Begin
        if Value2='CloseSystem' Then
        begin
          StopRunning  := True;
          application.Terminate;
        end;
     End;
    End;
  except
  end;
end;

procedure TAMainFrm.TimerSendLiveToDocMonitorTimer(Sender: TObject);
begin
  if TimerSendLiveToDocMonitor.Tag=1 Then
     exit;
  TimerSendLiveToDocMonitor.Tag :=1;
  Try
    if FStopRunningSkt then exit;
    if ASocketClientFrm<>nil Then
       SendDocMonitorStatusMsg(); //向DocMonitor发送'还活着..'

  Finally
    if FStopRunningSkt then TimerSendLiveToDocMonitor.Enabled := False;
    TimerSendLiveToDocMonitor.Tag :=0;
  end;
end;
//<---------DOC4.0.0—N001 huangcq090407 add-------

procedure TAMainFrm.Timer_StartGetDocTime(Sender: TObject);
Var
  i : Integer;
  IDLstMgr : TIDLstMgr;
  IsOk : Boolean;
  vPath:String;
begin
   Timer_StartGetDoc.Enabled := False;

   IDLstMgr := nil;
try
Try
   IDLstMgr := nil;
   if GetTickCount >= FEndTick Then
   Begin
     if NowIsRunning Then
     Begin
       DocDataMgr.ClearData;
       DocDataMgr.LoadFromNotMemoDocLogFile('NONEDoc3');
       DocDataMgr.LoadLogHistory();

       ShowMsg('Begin Search');
       SaveMsg('Begin Search');
       if StartGetDocTitle() Then
       begin
         FEndTick := GetTickCount + AppParam.Doc03_OKSleepTime*1000;
          if HaveDownFinished then
          begin
            if AppParam.Doc03_OKSleepTime mod 60 = 0 then
            begin
              ShowMsg('已下载更新过会公告,'+IntToStr(AppParam.Doc03_OKSleepTime div 60)+'分钟后开始下轮下载'); //20080115界面显示提示修改-by cody-modify
              SaveMsg('已下载更新过会公告,'+IntToStr(AppParam.Doc03_OKSleepTime div 60)+'分钟后开始下轮下载');
            end
            else begin
              ShowMsg('已下载更新过会公告,'+IntToStr(AppParam.Doc03_OKSleepTime)+'秒钟后开始下轮下载'); //20080115界面显示提示修改-by cody-modify
              SaveMsg('已下载更新过会公告,'+IntToStr(AppParam.Doc03_OKSleepTime)+'秒钟后开始下轮下载');
            end;
          end
          else begin
            if AppParam.Doc03_OKSleepTime mod 60 = 0 then
            begin
              ShowMsg('无更新过会公告,'+IntToStr(AppParam.Doc03_OKSleepTime div 60)+'分钟后开始下轮下载'); //20080115界面显示提示修改-by cody-modify
              SaveMsg('无更新过会公告,'+IntToStr(AppParam.Doc03_OKSleepTime div 60)+'分钟后开始下轮下载');
            end
            else begin
              ShowMsg('无更新过会公告,'+IntToStr(AppParam.Doc03_OKSleepTime)+'秒钟后开始下轮下载'); //20080115界面显示提示修改-by cody-modify
              SaveMsg('无更新过会公告,'+IntToStr(AppParam.Doc03_OKSleepTime)+'秒钟后开始下轮下载');
            end;
          end;
       end
       Else begin
         FEndTick := GetTickCount + AppParam.Doc03_ErrSleepTime*1000;
          if AppParam.Doc03_ErrSleepTime mod 60 = 0 then
          begin
            ShowMsg('本轮下载失败,'+IntToStr(AppParam.Doc03_ErrSleepTime div 60)+'分钟后开始下轮下载'); //20080115界面显示提示修改-by cody-modify
            SaveMsg('本轮下载失败,'+IntToStr(AppParam.Doc03_ErrSleepTime div 60)+'分钟后开始下轮下载');
          end
          else begin
            ShowMsg('本轮下载失败,'+IntToStr(AppParam.Doc03_ErrSleepTime)+'秒钟后开始下轮下载'); //20080115界面显示提示修改-by cody-modify
            SaveMsg('本轮下载失败,'+IntToStr(AppParam.Doc03_ErrSleepTime)+'秒钟后开始下轮下载');
          end;
       end;
       DocDataMgr.ClearData;
       //******************************************************
     End;
   End;

Except
   On E:Exception do
   Begin
     FEndTick := GetTickCount + AppParam.Doc03_ErrSleepTime*1000;
     //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError); //--DOC4.0.0—N001 huangcq090407 del
     SendDocMonitorWarningMsg('过会转债收集下载过程出现错误('+E.Message+')$E003');//--DOC4.0.0—N001 huangcq090407 add
   End;
end;

Finally
   ShowRunBar(0,0,'');
   if IDLstMgr<>nil Then
      IDLstMgr.Destroy;
   if StopRunning Then
      NowIsRunning := False;
   vPath := ExtractFilePath(ParamStr(0))+'Data\DwnDocLog\'+FLogFileName+'\';
   FolderAllFiles(vPath,'.log',OnGetLogFile,false);
   Timer_StartGetDoc.Enabled := True;
End;
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

{ TDisplayMsg }
procedure TDisplayMsg.AddMsg(const Msg: String);
begin
    if Length(Msg)=0 Then
       FMsg.Caption := ''
    else
    Begin
       FMsg.Caption := Msg;
    End;
    Application.ProcessMessages;
end;

constructor TDisplayMsg.Create(AMsg: TLabel;Const LogFileName:String);
begin
   FMsg := AMsg;
   FLogFileName := LogFileName;
   SetInitLogFile;
end;

destructor TDisplayMsg.Destroy;
begin
  //inherited;
end;

procedure TDisplayMsg.SaveMsg(const Msg: String);
begin
   if (Length(Msg)>0) and (FMsgTmp <> Msg) Then
   Begin
      SaveToLogFile(Msg);
      FMsgTmp := Msg;
   end;
end;

procedure TDisplayMsg.SaveToLogFile(const Msg: String);
Var
  vMsg,FileName : String;
begin

  FileName := ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\'+FLogFileName+'\'+
              FormatDateTime('yyyymmdd',Date)+'.log';
  Mkdir_Directory(ExtractFilePath(FileName));

  vMsg := Msg;
  ReplaceSubString(#10,'',vMsg);
  ReplaceSubString(#13,'',vMsg);

  AssignFile(FLogFile,FileName);
  FileMode := 2;
  if FileExists(FileName) Then
      Append(FLogFile)
  Else
      ReWrite(FLogFile);
  Writeln(FLogFile,'['+FormatDateTime('hh:mm:ss',Now)+']='+ vMsg);

  CloseFile(FLogFile);

end;

procedure TDisplayMsg.SetInitLogFile;
begin
end;

procedure TAMainFrm.InitObj;
begin
   //FMonitor:=TDownLoadMonitor.Create();
   DisplayMsg := TDisplayMsg.Create(Label1,FLogFileName);
   DocDataMgr := TDocDataMgr.Create(FTempDocFileName,FDocPath);
end;

procedure TAMainFrm.ShowURL(const msg: String);
begin
  SaveMsg(Msg);
  PanelCaption_URL.text := msg;
  Application.ProcessMessages;
end;

procedure TAMainFrm.ShowRunBar(const Max, NowP: Integer;
  const Msg: String);
begin
    ProgressBar1.Max := Max;
    ProgressBar1.Min := 0;
    ProgressBar1.Position := NowP;
    StatusBar1.Panels[1].Text := Msg;
end;

procedure TAMainFrm.SaveMsg(const Msg: String);
begin
    if DisplayMsg<>nil Then
       DisplayMsg.SaveMsg(Msg);
end;


procedure TAMainFrm.CoolTrayIconDblClick(Sender: TObject);
begin
  Self.Show;
end;


procedure TAMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    //--DOC4.0.0—N001 huangcq090407 add--->
    FStopRunningSkt := True;
    TimerSendLiveToDocMonitor.Interval := 1;
    While TimerSendLiveToDocMonitor.Enabled  and
        (TimerSendLiveToDocMonitor.Tag=1) Do
    Application.ProcessMessages;

    if ASocketClientFrm<>nil Then
    Begin
       ASocketClientFrm.ClearObj;
       ASocketClientFrm.Destroy;
       ASocketClientFrm:=nil;
    End;
    AppParam.Destroy;
    //FreeAndNil(FMonitor);
    //<-----DOC4.0.0—N001 huangcq090407 add--
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

function TAMainFrm.GetHttpTextByUrl(aUrl:string; var aOutHtmlText,aErrStr:string):Boolean;
var aHttpGet:THttpGet;
    i:integer;
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
      ShowMsg(aErrStr);
      SaveMsg(aErrStr);
    End;
  except
    on e:Exception do
    begin
      SaveMsg('GetHttpTextByUrl/'+aUrl+'/'+e.Message);
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


function TAMainFrm.GetHtmlText(AHTTP: TIdHTTP;AUrl:String;var OutHtmlText,ErrMsg:String):Boolean;
var
  RunHttp : TRunHttp;
  i:Integer;
begin
  try
  try
    OutHtmlText := '';
    ErrMsg := '';
    RunHttp := TRunHttp.Create(AHTTP,AUrl);
    RunHttp.Resume;
    i := 0;
    While Not RunHttp.HaveRunFinish do
    Begin
       if StopRunning Then
       Begin
           RunHttp.Terminate;
           RunHttp.WaitFor;
           Exit;
       End;
       if Length(RunHttp.RunErrMsg)>0 Then
       Begin
          ShowMsg(RunHttp.RunErrMsg);
          SaveMsg(RunHttp.RunErrMsg);
       End;
       Application.ProcessMessages;
       SleepWait(1);
       Inc(i);
       if i > 60 then
       begin
         ErrMsg := 'Read timeout';
         exit;  
       end;
    End;
    if Length(RunHttp.RunErrMsg)>0 Then
      ErrMsg := RunHttp.RunErrMsg
    else begin
      OutHtmlText := RunHttp.ResultString;
      //ChrConvert(OutHtmlText);
      Result := true;
    end;
  Except
     On E:Exception do
     Begin
         ErrMsg := E.Message;
         SaveMsg(E.Message);
         E := nil;
     End;
  End;
  finally
    try
      if RunHttp<>nil Then
      begin
        RunHttp.Destroy;
        RunHttp := nil;
      end;
    except
    end;
  end;
end;
end.
