//////////////////////////////////////////////////////////////////////////////////
////Doc_01-DOC3.0.0需求4-leon-08/8/14;  (修改拟发网页无法下载解析，并调用DLLHtmlParser.dll中GetTextAccordingToInifile函数来定位网页脚本中的字符串)
//--DOC4.0.0—N001 huangcq090407 add Doc与WarningCenter整合

{
Doc20090306; Modify by wangjinhua  
  1 修改拟发公告重复收集
  2 在解析公告标题对应的公告网址时，有部分网址解析为空
  3 公告解析错误[解析的文字中带有html标记代码],以及对于WML格式的网页中公告内容的解析
引入DLLHtmlParser.dll中方法SubStringReplace，GetText，GetTokenTypeFromString
}
//////////////////////////////////////////////////////////////////////////////////
unit MainFrm;

interface

uses
  
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, IdIntercept, IdLogBase, IdLogDebug,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,csDef, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,TCommon,TDocMgr, ImgList,IniFiles,FastStrings,
  SocketClientFrm,TSocketClasses, SHDocVw,MSHTML,XMLIntf,XMLDoc,
  OleCtrls;//,TWarningServer ,TSocketClasses

type

//add by wangjinhua 20090512 Doc20090306
  TTokenType=(ttNone,ttP,ttTable,ttTR,ttTD,ttDiv,
              ttImg,ttA,ttB,ttI,ttScript,ttLi,ttHr,
              ttH,ttSpan,ttStyle,ttFont,ttHead,ttTitle,
              ttCenter,ttBody,ttHtml,ttStrong);
//--

  TDisplayMsg=Class
  private
    FMsg : TLabel;
    FLogFile :TextFile;
    FLogFileName : String;
    FMsgTmp :  String;
    procedure SetInitLogFile();
    procedure SaveToLogFile(Const Msg:String);
  public
      constructor Create(AMsg: TLabel;Const LogFileName:String);
      destructor  Destroy; override;
      procedure AddMsg(Const Msg:String);
      procedure SaveMsg(const Msg:String);

  End;


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
    TimerSendLiveToDocMonitor: TTimer;
    WebBrowserExtractDoc: TWebBrowser;
    Label2: TLabel;
    wb1: TWebBrowser;
    Timer1: TTimer;
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
    procedure TimerSendLiveToDocMonitorTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private

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

    FQryDays,FLoadCount:integer; FFmtUrl:string;


    FTmpDoc : TDocData;//Doc20090306 wangjinhua 20090505
    FOn_Off : Boolean;//Doc20090306 wangjinhua 20090505
    FHtmlParseOk:Boolean;//add by wangjinhua 0306
    FTempFile:String;//add by wangjinhua 0306

    FStopRunningSkt : Boolean; //--DOC4.0.0—N001 huangcq090407 add
    ASocketClientFrm : TASocketClientFrm; //--DOC4.0.0—N001 huangcq090407 add
    procedure SendDocMonitorStatusMsg;//--DOC4.0.0—N001 huangcq090407 add
    function SendDocMonitorWarningMsg(const Str: String): boolean;//--DOC4.0.0—N001 huangcq090407 add
    procedure Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);//--DOC4.0.0—N001 huangcq090407 add

    procedure SetNowIsRunning(const Value: Boolean);
  private
    { Private declarations }
    property NowIsRunning:Boolean Read FNowIsRunning Write SetNowIsRunning;

    function  StartGetDocHtml(const TxtUrl:String):String;
    function StartGetDocTitle(const NextPageNum:Integer):Boolean;
    function GetDocTitle(Txt:TStringList;ID:String;var ParseOk:boolean):boolean;
    procedure GetAllDocPage(Txt:TStringList;Var AllPage,NowPage:Integer);
    function GetNextPageRNum(Txt:TStringList):Integer;
    function GetIDList(Const Txt:String):string;

    procedure ShowRunBar(const Max,NowP:Integer;Const Msg:String);
    procedure ShowRunBar2(Const Msg:String);

  public
    { Public declarations }
    procedure InitObj();
    procedure ShowURL(const msg:String);
    procedure ShowCaption(const msg:String);
    procedure ShowMsg(const Msg:String);
    procedure SaveMsg(const Msg:String);
    procedure Start();
    procedure Stop();
    procedure InitForm();
 
    //function GetWMLDocInfo(AWMLUrl:String):Boolean;// add by wangjinhua 20090512 Doc20090306
    //add by wangjinhua 0306
    function GetTextFromHtml(ASouce:String;var AOutText:String):Boolean;
    function GetHtmlText(AHTTP: TIdHTTP;AUrl:String;var OutHtmlText,ErrMsg:String):Boolean;
    function GetSourceCode2(AUrl:String;var HtmlText:String;Times:Integer=5):Boolean;
    function GetHtmlDocInfo(AUrl:String):Boolean;
    procedure OnGetLogFile(FileName: String);

     procedure HttpStatusEvent(ASender: TObject;AStatusText: string;aKey:string);
     procedure HttpBeginEvent(Sender: TObject;AWorkCountMax: Integer;aKey:string);
     procedure HttpEndEvent(Sender: TObject;aDoneOk:Boolean;aKey,aResult:string);
     procedure HttpWorkEvent(Sender: TObject; AWorkCount,AWorkMax: Integer;aKey:string);
     function GetHttpTextByUrl(aUrl:string; var aOutHtmlText,aErrStr:string):Boolean;
     function GetHttpTextByUrl_Web(aUrl:string;iPage:integer;var aOutHtmlText,aErrStr:string):Boolean;
     function GoToNextPage(aLastPageIdx:integer):Boolean;
    //--
  end;

function GetTextAccordingToInifile(InText:string;var OutText:string;InifileName:string):boolean;stdcall;external  'DLLHtmlParser.dll';
////Doc_01-DOC3.0.0需求4-leon-08/8/14-modify;

// add by wangjinhua 20090512 Doc20090306
function GetText(TokenType:TTokenType;site:integer;InText:string;var OutText:string):boolean;stdcall;external 'DLLHtmlParser.dll';
function GetTokenTypeFromString(Token:string):TTokenType;stdcall; external 'DLLHtmlParser.dll';
function SubStringReplace(SubString, ReplaceString:string; var Source:string):boolean;  stdcall;external  'DLLHtmlParser.dll';
//--

var
  AMainFrm: TAMainFrm;
  GWaitForWb:integer=30;

implementation

{$R *.dfm}

//-------------

function RplStr(aSource,aSrc,aDst:string):string;
begin
  result:=FastReplace(aSource,aSrc,aDst,false);
end;

function UniCode2GB(S : String):string;
Var I: Integer;
begin
result:='';
I := Length(S);
while I >=4 do begin
  try
    Result :=WideChar(StrToInt('$'+S[I-3]+S[I-2]+S[I-1]+S[I]))+ Result;
  except
  end;
  I := I - 4;
end;
end;

function GetJsonValue(aInput,aName:string;var aValue:string):boolean ;
var iPos,iStart,i,j:integer; sMatch:string;
begin
  result:=false;
  aValue:='';
  if Trim(aName)='' then exit;
  sMatch:=Format('"%s":',[aName]);
  iPos:=Pos(sMatch,aInput);
  if iPos<=0 then
    exit;
  aValue:=GetStrOnly2(sMatch+'"','"',aInput,false);
  result:=true;
end;

function UniCode2GBEx(S : String):string;
var i,iLen,j:Integer; sTemp,sTemp2:string;
begin
  result:='';
  iLen:=Length(s);
  i:=1; j:=0;
  while i<=iLen do
  begin
    Application.ProcessMessages;
    if (s[i]='\') and
       (i+1<=iLen) and
       (s[i+1]='u') and
       ( Length(copy(s,i+2,4))=4 )  then
    begin
      sTemp:=copy(s,i+2,4);
      sTemp2:=UniCode2GB(sTemp);
      result:=result+sTemp2;
      i:=i+6;
    end
    else begin
      result:=result+s[i];
      Inc(i);
    end;

    Inc(j);
    if j>10000 then
    begin
      Break;
    end;
  end;
end;

function GetJsonValueEx(aInput,aName:string;var aValue:string):boolean ;
var iPos,iStart,i,j:integer; sMatch:string; b:Boolean;
begin
  result:=GetJsonValue(aInput,aName,aValue);
  if result then
  begin
    b:=(Pos('\u',aValue)>0);
    if b then
    begin
      aValue:=UniCode2GBEx(aValue);
    end;
  end;
end;


procedure WriteLine(sFileName : string; sLine : string);
var fp : TextFile;
    s : string;
begin
    try
        AssignFile(fp, sFileName);
        if not FileExists(sFileName) then
            Rewrite(fp);
        Append(fp);
        s := sLine;
        Writeln(fp, s);
        Flush(fp);
        CloseFile(fp);
    except
        Flush(fp);
        CloseFile(fp);
        raise;
    end;
end;

function RemoveScript(var HTMLText:string):boolean;
var
  beginpos,endpos:integer;
begin
  result:=false;
  repeat
    beginpos:=pos('<script ',HTMLText);
    endpos:=pos('</script>',HTMLText);

    if (beginpos<>0) AND (endpos<>0)AND(beginpos<endpos) then
       delete(HTMLText,beginpos,endpos-beginpos+10);
  until (beginpos=0)OR(endpos=0)OR(beginpos > endpos) ;
  result:=true;
end;


function GetSourceCode(ABaseDataUrl:String):String;
var
  tmpIdHttp:TIdHttp;
  ts:TStrings;
begin
  Result := 'null';
try
try
  tmpIdHttp := TIdHttp.Create(nil);
  tmpIdHttp.ReadTimeout := 30000;
  Result := tmpIdHttp.Get(ABaseDataUrl);
except
  on e:Exception do
  begin
    e := nil;
    exit;
  end;
end;
finally
  try
    if Assigned(tmpIdHttp) then
      FreeAndNil(tmpIdHttp);
  except
    ;
  end;
end;
end;

function FilterWMLDoc(strEntityEnginefile:String):Boolean;
var
  ts:TStrings;
  vText:String;
begin
try
try
  ts := TStringList.Create;
  ts.LoadFromFile(strEntityEnginefile);
  vText := ts.Text;
  SubStringReplace('&nbsp;','',vText);
  ts.Text := vText;
  ts.SaveToFile(strEntityEnginefile);
except
  on e:Exception do
  begin
    e := nil;
  end;
end;
finally
  try
    if Assigned(ts) then
      FreeAndNil(ts);
  except
    on e:Exception do
    begin
      e := nil;
    end;
  end;
end;
end;

function GetXMLNodevalue(strEntityEnginefile:String):String;
var
 xmlDocument :IXMLDocument;
 node        :IXMLNode;
 xmlnodeList :TStrings;
 i          :Integer;
 urlcount    :Integer;
 vContent,vText:String;
begin
   //xml对象
   Result := '';
   FilterWMLDoc(strEntityEnginefile);
   xmlDocument :=TXMLDocument.Create(nil);
   xmlDocument.LoadFromFile(strEntityEngineFile);
   xmlDocument.Active:=true;
   node:= xmlDocument.DocumentElement;
   node := node.ChildNodes[2];
   for i :=1  to node.ChildNodes.Count do
   begin
      vText := node.ChildNodes.Get(i-1).Text;
      if Pos('债',vText) > 0 then
      begin
        vContent := vContent + #13#10 + vText;
      end;
   end;
   Result := vContent;
   xmlDocument.Active:=false;
end;

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

{
function TAMainFrm.GetWMLDocInfo(AWMLUrl:String):Boolean;
var
  ts:TStrings;
  tmpTxt,txtMemo,ErrMsg:String;
  vFile:String;
  i:Integer;
begin
  Result := false;

  i := 0;
  while i < 10 do
  begin
    //tmpTxt := GetWebPageText(AWMLUrl,ErrMsg);
    //if ( Length(ErrMsg)=0 ) and
    //   (not SameText(tmpTxt,NullStr) ) Then
    //Break;
    if DownloadFile(AWMLUrl,tmpTxt,ErrMsg) then
      if ( Trim(ErrMsg)='' ) and
          ( Trim(tmpTxt)<>'') then  Break;

    //if GetHtmlText(HTTP,AWMLUrl,tmpTxt,ErrMsg) then
    //   if ( Trim(ErrMsg)='' ) and
    //      ( Trim(tmpTxt)<>'') then  Break;
    SleepWait(1);
    //tmpTxt := GetSourceCode(AWMLUrl);
    //if tmpTxt <> 'null' then
    //  break;
    inc(i);
  end;
  SaveMsg('Wml Url: ' + FTmpDoc.URL + ' === ' + tmpTxt);

  if ( Trim(ErrMsg)<>'' ) or
     ( Trim(tmpTxt)='') then
     exit;
try
try
  vFile := ExtractFilePath(ParamStr(0)) + 'temp.wml';
  ts := TStringList.Create;
  ts.Text := tmpTxt;
  ts.SaveToFile(vFile);
  txtMemo := GetXMLNodevalue(vFile);
  if FileExists(vFile) then
    DeleteFile(vFile);
  if (Length(txtMemo) <> 0) and (Uppercase(Trim(txtMemo)) <> 'NULL') Then
  begin
    DocDataMgr.SetADocMemo(FTmpDoc,txtMemo);
    DocDataMgr.SetADocID(FTmpDoc,GetIDList(txtMemo));
    ShowMsg('(搜索完成)  ' + FTmpDoc.Title);
    SaveMsg('(搜索完成)  ' + FTmpDoc.Title);
    Result := true;
  end
  else begin
    ShowMsg('(搜索失败)  ' + FTmpDoc.Title);
    SaveMsg('(搜索失败)  ' + FTmpDoc.Title);
  end;
except
  on e:Exception do
  begin
    e := nil;
    exit;
  end;
end;
finally
  ParseOk := true;
  try
    if Assigned(ts) then
      FreeAndNil(ts);
  except
    ;
  end;
end;
end; }


function TAMainFrm.GetHtmlDocInfo(AUrl:String):Boolean;
var
  tmpTxt,txtMemo,ErrMsg:String;
  i,k :Integer;
begin
  Result := false;

try
try
  WebBrowserExtractDoc.Navigate('about:blank');
       WebBrowserExtractDoc.Silent := true;
       WebBrowserExtractDoc.Navigate(AUrl);
       k := 0;

       while( (not( WebBrowserExtractDoc.ReadyState = READYSTATE_COMPLETE)) )do
       begin
           if StopRunning Then
           begin
             WebBrowserExtractDoc.Refresh;
             Exit;
           end;
           SleepWait(1);
           Inc(k);
           StatusBar1.Panels[2].Text := IntToStr(k) + 's...';
           if k > 120 then // 搜索超过两分钟，则跳过
             exit;
       end;
       //or (not AWebBroswer.Busy)

       txtMemo := IHtmlDocument2(WebBrowserExtractDoc.Document).Body.OuterText;
       WebBrowserExtractDoc.Refresh;
 { if (not GetHtmlText(HTTP,AUrl,txtMemo,ErrMsg)) or
       (Length(ErrMsg)>0) Then
  begin
    SendDocMonitorWarningMsg('拟发行公告下载过程出现错误('+ErrMsg+')$E010');//--DOC4.0.0—N001 huangcq090407 add
     //SendToSoundServer('GET_DOC_ERROR',RunHttp.RunErrMsg,svrMsgError);   //--DOC4.0.0—N001 huangcq090407 del
    txtMemo:='';
  end; }

  if (Length(txtMemo) <> 0) Then
  begin

    DocDataMgr.SetADocMemo(FTmpDoc,txtMemo);
    DocDataMgr.SetADocID(FTmpDoc,GetIDList(txtMemo));
    ShowMsg('(搜索完成)  ' + FTmpDoc.Title);
    SaveMsg('(搜索完成)  ' + FTmpDoc.Title);
    Result := true;
  end
  else begin
    ShowMsg('(搜索失败)  ' + FTmpDoc.Title);
    SaveMsg('(搜索失败)  ' + FTmpDoc.Title);
  end;
except
  on e:Exception do
  begin
    SaveMsg(e.Message);
    e := nil;
  end;
end;
finally
  FHtmlParseOk := true;
end;
end;

function TAMainFrm.GetTextFromHtml(ASouce:String;var AOutText:String):Boolean;
var
  ts:TStringList;
  k:Integer;
begin
  Result := false;
  //AOutText := ASouce;
  AOutText := '';
try
try
    try
       ts := TStringList.Create;
       ts.Text := ASouce;
       ts.SaveToFile(FTempFile);
     finally
       try
          if Assigned(ts) then
           FreeAndNil(ts);
       except
       end;
     end;

       WebBrowserExtractDoc.Navigate('about:blank');
       WebBrowserExtractDoc.Silent := true;
       WebBrowserExtractDoc.Navigate(FTempFile);
       k := 0;
       while( (not( WebBrowserExtractDoc.ReadyState = READYSTATE_COMPLETE))  )do
       begin
           if StopRunning Then
           begin
             WebBrowserExtractDoc.Refresh;
             Exit;
           end;
           SleepWait(1);
           Inc(k);
           StatusBar1.Panels[2].Text := IntToStr(k) + 's...';
       end;
       //or (not AWebBroswer.Busy)

       AOutText := IHtmlDocument2(WebBrowserExtractDoc.Document).Body.OuterText;
       WebBrowserExtractDoc.Refresh;
       Result := true;
except
  On e:Exception Do
  begin
    SaveMsg(e.Message);
    e := nil;
  end;
end;
finally
  FHtmlParseOk := true;
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
      ChrConvert(OutHtmlText);
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
//--

procedure TAMainFrm.InitForm;
const _FmtUrl='http://quotes.money.163.com/hs/marketdata/service/gsgg.php?host=/hs/marketdata/service/gsgg.php&page=0&query=leixing:00;start:%DateS%;end:%DateE%&sort=PUBLISHDATE&order=desc&count=%LoadC%&type=query';
var i:integer;
  fini:TIniFile; sfile:string;
begin
  AppParam := TDocMgrParam.Create;
  GWaitForWb:=AppParam.Doc01_WaitForWeb;
  for i:=low(AppParam.FDoc01TextParseTokens) to High(AppParam.FDoc01TextParseTokens) do
    if AppParam.FDoc01TextParseTokens[i]='' then
      raise Exception.Create('Doc01TextParseTokens Params Invalid');
  Label2.caption:=AppParam.TwConvertStr('览祇︽そ穓栋ㄣ');
  self.caption:=AppParam.TwConvertStr('览祇︽そ穓栋ㄣ');

  FTempFile := GetWinTempPath + 'DocTmpHtml.htm';
  FDataPath := ExtractFilePath(Application.ExeName)+'Data\';
  FDocPath  := '';

  Mkdir_Directory(FDataPath);
  Mkdir_Directory(FDocPath);

  FTempDocFileName := FDataPath+'Doc_01.tmp';
  FLogFileName := 'Doc_01';


  NowIsRunning := false;
  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;

  HTTP.ReadTimeout := 60*1000;

  sfile:=ExtractFilePath(ParamStr(0))+'setup.ini';
  fini:=TIniFile.Create(sfile);
  try
    FQryDays:=fini.ReadInteger('Doc_01','QryDays',30);
    FLoadCount:=fini.ReadInteger('Doc_01','LoadCount',2000);
    FFmtUrl:=fini.ReadString('Doc_01','Url',_FmtUrl);
  finally
    try  if Assigned(fini) then FreeAndNil(fini); except end;
  end;
  
  //ConnectToSoundServer(AppParam.SoundServer,AppParam.SoundPort); //--DOC4.0.0—N001 huangcq090407 del
  //--DOC4.0.0—N001 huangcq090407 add------>
  FStopRunningSkt := False;
  ASocketClientFrm := TASocketClientFrm.Create(Self,'Doc_01',AppParam.DocMonitorHostName ,AppParam.DocMonitorPort,Msg_ReceiveDataInfo);

  //TimerSendLiveToDocMonitor.Interval := 3000;
  //TimerSendLiveToDocMonitor.Enabled  := True;
  //<------DOC4.0.0—N001 huangcq090407 add----
  Timer1.Enabled:=true;
  //Timer_StartGetDoc.Enabled := True;
end;

procedure TAMainFrm.FormCreate(Sender: TObject);
begin
   InitForm;
   InitObj;
end;

procedure TAMainFrm.Start;
begin
   StopRunning := False;
   NowIsRunning := True;
   FEndTick := GetTickCount + Round(1000);
   Timer_StartGetDoc.Interval := 1000;
   Timer_StartGetDoc.Enabled:=true;
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

   StopRunning := True;
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
Var
  t1,i,aTempNowPage,aTempAllPage: Integer;
  Str,aTemp : String;
Begin
        AllPage:=0;
        NowPage:=1;

end;

//add by wangjinhua 20090512 Doc20090306
function GetUrlFromStr(AStr:String;var AUrl:String):Boolean;
const
  cstKey = 'href=';
var
  iPos,iStartPos:Integer;
  i,vLen:Integer;
begin
  Result := true;
  AUrl := '';
  iPos := Pos(cstKey,AStr);
  if iPos = 0 then
  begin
    Result := false;
    exit;
  end;
  iStartPos := iPos + Length(cstKey);
  vLen := Length(AStr);
  for i := iStartPos to vLen do
  begin
    if (AStr[i] = ' ') then
      if Trim(AUrl) <> '' then
      break;

    if (AStr[i] = '>') then
      break;
    AUrl := AUrl + AStr[i];
    SubStringReplace('"','',AUrl);
  end;
  AUrl := Trim(AUrl);
end;


function RmvHtmlTag(MemoTxt:string):string;
var
  i,StartP,EndP,StartP2,EndP2:integer;
  Str_temp,Str_temp2,Str_temp3:String;
begin
  try
    StartP := Pos('<',MemoTxt);
    i:=0;
    While StartP>0 do
    Begin
      inc(i);
      if(i>10000)then break;
      EndP := Pos('>',MemoTxt);
      if EndP=0 then break;
      //保持原有的换行
      if(Pos('<br',Copy(MemoTxt,StartP,EndP-StartP+1))=1) or
        (Pos('<BR',Copy(MemoTxt,StartP,EndP-StartP+1))=1) then
      begin
        Str_temp3:=Copy(MemoTxt,StartP,EndP-StartP+1);
        if Str_temp3='' then break;
        MemoTxt:=RplStr(MemoTxt,Str_temp3,#13#10)
      end
      else begin
        Str_temp3:=Copy(MemoTxt,StartP,EndP-StartP+1);
        if Str_temp3='' then break;
        MemoTxt:=RplStr(MemoTxt,Str_temp3,'');
      end;
      StartP := Pos('<',MemoTxt);
    End;
    MemoTxt:=RplStr(MemoTxt,'&NBSP;',' ');
    MemoTxt:=RplStr(MemoTxt,'&nbsp;',' ');

    //去掉第一行的空格
    if(Pos(#13#10,MemoTxt)=1)then
      MemoTxt := Copy(MemoTxt,Length(#13#10)+1,Length(MemoTxt)-Length(#13#10));
    result:=MemoTxt;
  finally

  end;
end;

//--
//modify by wangjinhua 20090512 Doc20090306
function TAMainFrm.GetDocTitle(Txt: TStringList;ID:String;var ParseOk:boolean):Boolean;
  procedure ClearHtmlTokens(var aSource:string);
  begin
    while True do
    begin
      if GetStr('<','>',aSource,false,True)=''  then break;
      Application.ProcessMessages;
    end;
  end;

Const
  Token_TR = 'tr';
  Token_TD = 'td';
  Token_A = 'a';
  Token_Table = 'table';
var ts1,ts2:TStringList;
  vSource,tmpSource,vSubSource,vItem,tmpStr:String;
  i:Integer;
  TxtID,TxtCaption,TxtType,TxtHttp,TxtDateTime : String;
  TxtTime: TTime;TxtDate  : TDate;DateTime : TDateTime;
  Year,Month,Day : Word;H,M,S,MS : Word;
  bValidate,b2:Boolean;
begin
try
try
  ts1:=TStringList.create; ts2:=TStringList.create;
  Result := true; ParseOk:=False; bValidate:=true;b2:=false;
  tmpSource := Txt.Text;
  //Txt.SaveToFile('c:\123.txt');
  vSource := tmpSource;
  Application.ProcessMessages;
  vSource:=RplStr(vSource,#13#10,'');
  vSource:=RplStr(vSource,'{',#13#10+'{');
  
    Txt.text:=vSource;
    for i:=0 to Txt.count-1 do
        begin
          Application.ProcessMessages;
          if StopRunning Then Exit;
          tmpStr:=Trim(Txt[i]);
          if Pos('"SYMBOL"',tmpStr)>0 then
          begin
            if not GetJsonValueEx(tmpStr,'PUBLISHDATE',TxtDateTime) then
            begin
              SaveMsg('GetJsonValueEx PUBLISHDATE fail.'+tmpStr);
              continue;
            end;
            DateTime:=0;
            if TxtDateTime<>'' then
              DateTime:=StrToDate2(TxtDateTime);
            DeCodeDate(DateTime,Year,Month,Day);
            TxtDate := EncodeDate(Year,Month,Day);
            DeCodeTime(DateTime,H,M,S,MS);
            TxtTime := EncodeTime(H,M,S,MS);
            if not GetJsonValueEx(tmpStr,'SYMBOL',TxtID) then
            begin
              SaveMsg('GetJsonValueEx SYMBOL fail.'+tmpStr);
              continue;
            end;
            if not GetJsonValueEx(tmpStr,'ANNOUNMT2',TxtCaption) then
            begin
              SaveMsg('GetJsonValueEx ANNOUNMT2 fail.'+tmpStr);
              continue;
            end;
            if not GetJsonValueEx(tmpStr,'ANNOUNMT1',TxtType) then
            begin
              SaveMsg('GetJsonValueEx ANNOUNMT1 fail.'+tmpStr);
              continue;
            end;
            if not GetJsonValueEx(tmpStr,'ANNOUNMTID',vItem) then
            begin
              SaveMsg('GetJsonValueEx ANNOUNMTID fail.'+tmpStr);
              continue;
            end;
            TxtHttp:=Format('http://quotes.money.163.com/f10/ggmx_%s_%s.html',[TxtID,vItem]);
            if (vItem='') or
               (TxtID='') or
               (DateTime<=1) or
               (TxtHttp='') or
               (TxtCaption='') or
               (TxtType='') then
            begin
              bValidate:=false;
            end
            else begin
              b2:=True;
              ShowCaption(TxtID+';'+TxtDateTime+';'+TxtType+';'+TxtCaption+';'+TxtHttp);
              SaveMsg('parse:'+TxtID+';'+TxtDateTime+';'+TxtType+';'+TxtCaption+';'+TxtHttp);
              if( (Pos('转债',TxtCaption)>0) or
                  (Pos('可转换公司债',TxtCaption)>0)
                ) and
                ( (Pos('拟发',TxtCaption)>0) or
                  (Pos('发行',TxtCaption)>0)
                ) then
              begin
                if StopRunning Then Exit;
                if DocDataMgr.AddADoc01(TxtCaption,TxtID,TxtType,TxtDate,TxtTime,TXTHttp) <> nil then
                  SaveMsg('  Add Success' + TxtHttp);
              end;
            end;
          end;
        end;

    ParseOk:=bValidate and b2;
    result:=true;
except
  on e:Exception do
  begin
    SaveMsg('GetDocTitle Except:  '+e.Message);
    e := nil;
    Result := false;
  end;
end;
finally
  FreeAndNil(ts1);
  FreeAndNil(ts2);
end;
end;


function TAMainFrm.GetNextPageRNum(Txt: TStringList): Integer;
Var
  i,t1,t2 : Integer;
  Str : String;
Begin

 result := -1;
 for i:=0 to Txt.Count-1 do
 Begin
     if (Pos('>下一页<',Txt.Strings[i])>0) and
        (Pos('<td><a href="outline.jsp?searchWhere=',Txt.Strings[i])>0) Then
     Begin
        Str := Txt.Strings[i];
        t1 := Pos('rsnum=',Str);
        t2 := Pos('">下一页</a></td>',Str);
        t1 := t1+Length('rsnum=');
        str := Copy(Str,t1,t2-t1);
        /////////////////////////////
        //add by joysun 2006/4/6 
        t2 := Pos('&',Str);
        str := Copy(Str,1,t2-1);
        //////////////////////////////
        Result  := StrToInt(Str);
     End;
 End;
end;

function TAMainFrm.StartGetDocHtml(const TxtUrl: String): String;
var
  Response:TStringList;
  Str,tmpStr : String;
  t1,t2,StartPos,EndPos : integer;
  ResultStr,OutputStr : String;
  RunHttp : TRunHttp;
  vErrMsg : String;
  aDownResult:Boolean;
begin
  // Add the URL to the combo-box.
  Result := '';
  try
    aDownResult:=GetHttpTextByUrl(TxtUrl,ResultStr,vErrMsg);
    if aDownResult then
    begin
      try
              OutputStr:=ResultStr;
              RemoveScript(OutputStr);
              if Length(OutputStr)>0 then
              begin
                tmpStr:='';
                for t1:=0 to (Length(AppParam.FDoc01TextParseTokens) div 2)-1 do
                begin
                  Str:=GetStrOnly2(AppParam.FDoc01TextParseTokens[t1*2+0],
                  AppParam.FDoc01TextParseTokens[t1*2+1],OutputStr,True);
                  if Length(Str)>0 then
                  begin
                    tmpStr:=Str;
                    Break;
                  end;
                end;
                OutputStr:=tmpStr;
              end;

              //GetStr('<style','</style>',OutputStr,false,True);
              OutputStr:=RplStr(OutputStr,'<BR>',#13#10);     //Doc_01-DOC3.0.0需求4-leon-08/8/14-modify;
              OutputStr:=RplStr(OutputStr,'<br/>',#13#10);
              OutputStr:=RplStr(OutputStr,'<br>',#13#10);
              OutputStr:=RplStr(OutputStr,'&NBSP;',' ');
              OutputStr:=RplStr(OutputStr,'&ensp;',' ');
              OutputStr:=RplStr(OutputStr,'<P>',#13#10);
              OutputStr:=RplStr(OutputStr,'</P>','');
              OutputStr:=RplStr(OutputStr,'<p>',#13#10);
              OutputStr:=RplStr(OutputStr,'</p>','');

              StartPos:=Pos('<',OutputStr);
              EndPos:=Pos('>',OutputStr);

             while (StartPos<>0) and (EndPos<>0) and (EndPos>StartPos) do
             begin
               delete(OutputStr,StartPos,EndPos-StartPos+1);
               StartPos:=Pos('<',OutputStr);
               EndPos:=Pos('>',OutputStr);
             end;
             Result := OutputStr;
           //end;
         except
           ShowMsg('调用dll解析时出现异常');
         end;
//======================================================================
      if Length(result)=0 Then result := ResultStr;
      SaveMsg('文章内容成功取得');
    end
    else SaveMsg('文章内容无法取得');

    try
      if (Length(result)>0) or
         (Pos(UpperCase(E404NotFound),UpperCase(vErrMsg))>0) then
      begin
        DocDataMgr.SetADocMemo(FTmpDoc,Result);
        DocDataMgr.SetADocID(FTmpDoc,GetIDList(Result));
        ShowMsg('(搜索完成)  ' + FTmpDoc.Title);
        SaveMsg('(搜索完成)  ' + FTmpDoc.Title);
      end
      else begin
        ShowMsg('(搜索失败)  ' + FTmpDoc.Title);
        SaveMsg('(搜索失败)  ' + FTmpDoc.Title);
      end;
    except
      on e:Exception do SaveMsg('StartGetDocHtml/'+TxtUrl+'/'+ e.Message);
    end;
  finally
    FHtmlParseOk := true;
  end;
End;


function TAMainFrm.GetSourceCode2(AUrl:String;var HtmlText:String;Times:Integer=5):Boolean;
var
  k:Integer;
begin
  Result:= false;
  HtmlText := '';
try
try
  for k := 1 to Times do
  begin
      Application.ProcessMessages;
      if StopRunning Then Break;
      try
        HtmlText := HTTP.Get(AUrl);
      except
        on e:Exception do
        begin
          e := nil;
          HtmlText := '';
          break;
        end;
      end;

      if (Trim(HtmlText) <> '') and (Uppercase(Trim(HtmlText)) <> 'NULL')  then
      begin
        Result:= True ;
        break;
      end;
  end;
except
  on e:Exception do
  begin
    ShowMessage(e.Message);
    e := nil;
    exit;
  end;
end;
finally
  try
    HTTP.Disconnect;
  except
  end;
end;
end;



function TAMainFrm.StartGetDocTitle(const NextPageNum: Integer):boolean;
var
  Response:TStringList;
  AllPage,NowPage : Integer;
  Url,ResultStr,ErrMsg,TxtMemo,txtSource : String;
  i,j,iXunHuan: integer;
  ADoc : TDocData; bParseOk,b1,b2:boolean;
  List:Array[0..1] of TList;
  dt1,dt2:TDate;
begin
  Result := false;
  NowPage:=0;
  if StopRunning Then exit;
  Response := nil;
  try
  try
    Url := 'http://quotes.money.163.com/#query=GGDQ';
    iXunHuan:=0;
    bParseOk:=true; b1:=False; b2:=false;
    AllPage:=1;
    NowPage:=0;
    dt2:=date;
    dt1:=dt2-FQryDays;
    //ňゎ碻吏
    while iXunHuan<100 do
    begin
        Inc(iXunHuan);
        Inc(NowPage);
        if NowPage>AllPage then
        begin
          NowPage := -1;
          break;
        end;
        Url:=FFmtUrl;
        Url:=RplStr(Url,'%pagec%',IntToStr(NowPage-1));
        Url:=RplStr(Url,'%DateS%',FmtDt10(dt1));
        Url:=RplStr(Url,'%DateE%',FmtDt10(dt2));
        Url:=RplStr(Url,'%LoadC%',IntToStr(FLoadCount));

        if NowPage=1 then
          ShowRunBar2(Format('第%d页',[NowPage]))
        else
          ShowRunBar2(Format('第%d/%d页',[NowPage,AllPage]));
        if not GetHttpTextByUrl(Url,ResultStr,ErrMsg) then
        begin
          SendDocMonitorWarningMsg('拟发行公告下载过程出现错误('+ErrMsg+')$E010');
          break;
        end;
        if StopRunning Then Exit;

        if Length(ResultStr)>0 Then
        Begin
          if NowPage=1 then
          begin
            TxtMemo:=GetStrOnly2('"pagecount":',',',ResultStr,false);
            if MayBeDigital(TxtMemo) then
              AllPage:=StrToInt(TxtMemo);
          end;
          try
           Response := TStringList.Create;
           Response.Text := ResultStr;
           if Not GetDocTitle(Response,'NONE',b1) Then
           begin
              NowPage := -1;
              break;
           end
           else b2:=true;
           if not b1 then
             bParseOk:=false;
           if StopRunning Then Exit;
          finally
            try
              if Assigned(Response) then
                FreeAndNil(Response);
            except
            end;
          end;
        End Else
           break;
    end; 
    //bParseOk:=bParseOk and b2;
    //if bParseOk then
    begin
      SaveIniFile(PChar('Doc_01'),PChar('Ok'),
        PChar(floattostr(now)),PChar(ExtractFilePath(ParamStr(0))+'setup.ini'))
    end;

    if StopRunning Then exit;
    //Modify by wangjinhua Doc20090306
    if NowPage=-1 Then
    Begin
       DocDataMgr.SaveNotMemoDocLogFile('NONEDoc1');
       DocDataMgr.WriteLogHistory();

       List[0] := DocDataMgr.DocList;
       List[1] := DocDataMgr.NotGetMemoDocList;

       For j:= 0 to 1 do
       begin
         For i:=0 to List[j].Count-1 do
         begin
           if StopRunning Then Break;
           FTmpDoc := List[j].Items[i];
           if FTmpDoc.URL='' then
           begin
             List[j].delete(i);
             FTmpDoc.Destroy;
             FTmpDoc:=nil;
           end;
         end;
       end;

       //FHtmlParseOk := true;
       For j:= 0 to 1 do
       begin
         if StopRunning Then Break;
         if j = 0 then
           StatusBar1.Panels[2].Text := 'DocList'
         else if j = 1 then
           StatusBar1.Panels[2].Text := 'NotGetMemoDocList';

         For i:=0 to List[j].Count-1 do
         begin
           if StopRunning Then Break;
           //while not FHtmlParseOk do
           // SleepWait(1);
           //FHtmlParseOk := false;
           ShowRunBar(List[j].Count,i+1,IntToStr(i)+'/'+IntToStr(List[j].Count));
           FTmpDoc := List[j].Items[i];
           ShowURL(FTmpDoc.URL);
           SaveMsg('Search Url ' + FTmpDoc.URL);
           StartGetDocHtml(FTmpDoc.URL);
         end;
       end;

       SaveMsg('(===搜索完成===)  ');
       //-- modify by wangjinhua Doc20090306 20090508
       DocDataMgr.FilterADocInDocList();
       try
         ShowURL('');
         ShowMsg('');
         StatusBar1.Panels[2].Text := '';
         ShowMsg('开始保存成功获得公告信息的公告  ');
         SaveMsg('开始保存成功获得公告信息的公告  ');
         DocDataMgr.SaveToTempDocFile; //init code
         ShowMsg('保存成功获得公告信息的公告,执行完毕  ');
         SaveMsg('保存成功获得公告信息的公告,执行完毕  ');
         ShowMsg('开始保存获得公告信息失败的公告  ');
         SaveMsg('开始保存获得公告信息失败的公告  ');
         DocDataMgr.SaveNotMemoDocLogFile('NONEDoc1'); //init code
         ShowMsg('保存获得公告信息失败的公告,执行完毕  ');
         SaveMsg('保存获得公告信息失败的公告,执行完毕  ');
       except
         SaveMsg('生成最后文件时出错');
       end;
       ShowMsg('');
       Result := true;
       //--
       Exit;
    End;
    //Result :=  StartGetDocTitle(NowPage);
  Except
     On E:Exception do
     Begin
         ShowMsg(E.Message);
         SaveMsg(E.Message);
         SendDocMonitorWarningMsg('拟发行公告下载过程出现错误('+E.Message+')$E010');//--DOC4.0.0—N001 huangcq090407 add
     End;
  End;
  finally
      ShowCaption('');
      ShowURL('');
      ShowMsg('');
      StatusBar1.Panels[2].Text := '';
      try
        if Assigned(Response) then
          FreeAndNil(Response);
      except
      end;
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
                                'Message=Doc_01;'
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
          StopRunning := True;
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
var
  CollectOk:Boolean;
begin
   Timer_StartGetDoc.Enabled := False;
Try
   if GetTickCount >= FEndTick Then
   Begin
     if NowIsRunning Then
     Begin
       DocDataMgr.ClearData;
       DocDataMgr.LoadFromNotMemoDocLogFile('NONEDoc1');
       //modify by wangjinhua 0306
       {
       DocDataMgr.LoadFromEndReadDocLogFile('NONEDoc1');
       if StartGetDocTitle(-1) Then
         FEndTick := GetTickCount + Round(10*60*1000)
       Else
         FEndTick := GetTickCount + Round(5000);}
       DocDataMgr.LoadLogHistory();
       CollectOk := StartGetDocTitle(-1);
       DocDataMgr.ClearData;
       if CollectOk Then
         FEndTick := GetTickCount + Round(AppParam.Doc01_OKSleepTime * 1000)
       Else
         FEndTick := GetTickCount + Round(AppParam.Doc01_ErrSleepTime * 1000);
       //--
     End;
   End;

Finally
   ShowRunBar(0,0,'');
   if StopRunning Then
      NowIsRunning := false;
   FolderAllFiles(ExtractFilePath(ParamStr(0))+'Data\DwnDocLog\'+FLogFileName+'\','.log',OnGetLogFile,false);
   Timer_StartGetDoc.Enabled := True;
End;

end;

{ TDisplayMsg }

procedure TDisplayMsg.AddMsg(const Msg: String);
begin

    if Length(Msg)=0 Then
       FMsg.Caption := '拟发行公告代码收集工具'
    else
    Begin
       FMsg.Caption := Msg;
    End;

end;

constructor TDisplayMsg.Create(AMsg: TLabel;Const LogFileName:String);
begin
   FMsg := AMsg;
   FLogFileName := LogFileName;
   SetInitLogFile;
end;

destructor TDisplayMsg.Destroy;
begin

  inherited;
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
var vMsg,FileName : String;
begin
  vMsg := Msg;
  ReplaceSubString(#10,'',vMsg);
  ReplaceSubString(#13,'',vMsg);
  FileName := ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\'+FLogFileName+'\'+
              FormatDateTime('yyyymmddhh',now)+'.log';
  Mkdir_Directory(ExtractFilePath(FileName));
  WriteLine(FileName,'['+FormatDateTime('hh:mm:ss',Now)+']='+ vMsg);
end;

procedure TDisplayMsg.SetInitLogFile;
begin
end;

procedure TAMainFrm.InitObj;
begin
   DisplayMsg := TDisplayMsg.Create(Label1,FLogFileName);
   DocDataMgr := TDocDataMgr.Create(FTempDocFileName,FDocPath);
end;

procedure TAMainFrm.ShowRunBar(const Max, NowP: Integer;
  const Msg: String);
begin
    ProgressBar1.Max := Max;
    ProgressBar1.Min := 0;
    ProgressBar1.Position := NowP;
    StatusBar1.Panels[1].Text := Msg;
    Application.ProcessMessages;
end;

procedure TAMainFrm.ShowRunBar2(const Msg: String);
begin
    StatusBar1.Panels[1].Text := Msg;
    Application.ProcessMessages;
end;

procedure TAMainFrm.ShowCaption(const msg:String);
const CMsgLen=65;
var i:integer;
begin
  Label1.Caption := msg;
  Application.ProcessMessages;
end;

procedure TAMainFrm.ShowURL(const msg: String);
const CMsgLen=65;
var i:integer;
    aTempMsg:string;
begin
  SaveMsg(msg);
  //PanelCaption_URL.Caption := msg;
  aTempMsg:='';
  for i:=1 to (Length(msg) div CMsgLen)+1 do
  begin
	if i=1 then aTempMsg:=Copy(msg,(i-1)*CMsgLen+1,CMsgLen )
	else aTempMsg:=aTempMsg+#10+Copy(msg,(i-1)*CMsgLen+1,CMsgLen );
  end;
  Label2.Caption := aTempMsg;
  Application.ProcessMessages;
end;

procedure TAMainFrm.SaveMsg(const Msg: String);
begin
    if DisplayMsg<>nil Then
       DisplayMsg.SaveMsg(Msg);
end;


function TAMainFrm.GetIDList(Const Txt: String): string;
Var
  StrLst : _CStrLst2;
  ID,Txt2 : String;
  i,t1 : Integer;
begin

   Result := '';

   Txt2 := Txt;
   ReplaceSubString('（','(',Txt2);
   ReplaceSubString('）',')',Txt2);

   StrLst := DoStrArray2(Txt2,'(');
   for i:=0 to High(StrLst) do
   Begin
       if Length(StrLst[i])>=6 Then
       Begin
          t1 := Pos(')',StrLst[i]);
          if t1>0 Then
          Begin
            ID := Copy(StrLst[i],1,t1-1);
            if isInteger(PChar(ID)) Then
                Result := Result + ID + ',';
          End;
       end;
   End;

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
    //<-----DOC4.0.0—N001 huangcq090407 add--
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

function TAMainFrm.GetHttpTextByUrl_Web(aUrl:string;iPage:integer; var aOutHtmlText,aErrStr:string):Boolean;
var j:integer; ts:TStringList;
begin
  result:=false;
  aErrStr:='';
  aOutHtmlText:='';
try
  if aUrl<>'' then
  begin
    ShowURL(aUrl);
    wb1.Navigate('about:blank');
    for j:=1 to 5 do
     SleepWait(1);
    wb1.Navigate(aUrl);
    try
        for j:=1 to GWaitForWb do
        begin
          StatusBar1.Panels[2].Text := Format('wait %d. ',[j]);
          SleepWait(1);
          if StopRunning then
           exit;
        end;
    finally
      StatusBar1.Panels[2].Text :='';
    end;
  end;
  aOutHtmlText := wb1.OleObject.document.body.InnerHtml;
  //aOutHtmlText:=UTF8Decode(aOutHtmlText);
  ts:=TStringList.create;
  ts.text := wb1.OleObject.document.body.InnerHtml;
  //ts.SaveToFile('c:\1.txt');
  ts.text := wb1.OleObject.document.body.outerHtml;
  //ts.SaveToFile('c:\2.txt');
  ts.free;
  result:=Trim(aOutHtmlText)<>'';
except
    on e:Exception do
    begin
      aErrStr:=e.Message;
      SaveMsg('GetHttpTextByUrl_Web/'+inttostr(iPage)+'/'+e.Message);
      result:=false;
    end;
end;
end;

function TAMainFrm.GoToNextPage(aLastPageIdx:integer):Boolean;
var i,j,i1,i2:integer; sText1,sText2,sTemp1:string;
begin
  result:=false;
  for i := wb1.OleObject.Document.links.Length - 1 downto 0 do
  begin
    sText1:=wb1.OleObject.Document.Links.Item(i);
    sText2:=wb1.OleObject.Document.Links.Item(i).innertext;
    //SaveMsg('test--------'+sText1+'@@@'+sText2);
    if ( (pos( 'http://quotes.money.163.com/#page=',sText1)>0) or
         (pos( 'http://quotes.money.163.com/old/#page=',sText1)>0) 
       ) then
    SaveMsg('--------'+sText1+'@@@'+sText2);
  end;
  for i := wb1.OleObject.Document.links.Length - 1 downto 0 do
  begin
    sText1:=wb1.OleObject.Document.Links.Item(i);
    sText2:=wb1.OleObject.Document.Links.Item(i).innertext;
    if ( (pos( 'http://quotes.money.163.com/#page=',sText1)>0) or
         (pos( 'http://quotes.money.163.com/old/#page=',sText1)>0) 
       ) and
       (
         Pos('下一页',sText2)>0
       )then
    begin
      i1:=PosEx('#page=',sText1);
      sTemp1:=Copy(sText1,i1+length('#page='),Length(sText1));
      if MayBeDigital(sTemp1) then
      begin
        if StrToInt(sTemp1)>aLastPageIdx then
        begin
          SaveMsg(sText1+'@@@'+sText2);
          wb1.OleObject.Document.Links.Item(i).click;
          result:=true;
          try
            for j:=1 to GWaitForWb do
            begin
              StatusBar1.Panels[2].Text := Format('wait %d. ',[j]);
              SleepWait(1);
              if StopRunning then
               exit;
            end;
          finally
            StatusBar1.Panels[2].Text :='';
          end;
        end;
      end;

      break;
    end;
  end;
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


procedure TAMainFrm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  btnGo.Click;
end;

end.
