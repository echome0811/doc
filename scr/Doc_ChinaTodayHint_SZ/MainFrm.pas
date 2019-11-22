//******************************************************************************
//JoySun
//2005/9/8
//修改StartGetHintIndex ，目的：解析不同的网站网页
//---Doc3.2.0需求1 huangcq080923 修改：获取market_db\pulish_db目录下的txt文件
//--DOC4.0.0—N001 huangcq090407 add Doc与WarningCenter整合
//******************************************************************************
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, IdIntercept, IdLogBase, IdLogDebug,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,csDef, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,IniFiles,TCommon,TDocMgr, ImgList,
  SocketClientFrm,TSocketClasses, OleCtrls, SHDocVw
  ; //TWarningServer


type

  THintMsg=Packed Record
     Title : String;
     IDLst : TStringList;
  End;

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
    wbPage: TWebBrowser;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerSendLiveToDocMonitorTimer(Sender: TObject);
    procedure wbPageDocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure wbPageStatusTextChange(Sender: TObject;
      const Text: WideString);
    procedure wbPageProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
  private
    FDataPath : String;
    //FDocPath  : String;
    FLogFileName : String;
    //FTempDocFileName : String;
    FNowIsRunning: Boolean;
    StopRunning : Boolean;
    DisplayMsg : TDisplayMsg;
    //DocDataMgr : TDocDataMgr;
    IDLstMgr : TIDLstMgr;
    AppParam : TDocMgrParam;
    CBDataMgr : TCBDataMgr;

    FTodayHintDate : TDate;
    //AppParam : TDocMgrParam;
    FStopRunningSkt : Boolean; //--DOC4.0.0—N001 huangcq090407 add
    ASocketClientFrm : TASocketClientFrm; //--DOC4.0.0—N001 huangcq090407 add

    FEndTick : DWord;
    procedure SetNowIsRunning(const Value: Boolean);
    Procedure RefrsehTime(s:Integer);
    
    procedure SendDocCenterDownFinish;//--DOC4.0.0—N002 huangcq090617 add
    procedure SendDocMonitorStatusMsg;//--DOC4.0.0—N001 huangcq090407 add
    function SendDocMonitorWarningMsg(const Str: String):Boolean;//--DOC4.0.0—N001 huangcq090407 add
    procedure Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);//--DOC4.0.0—N001 huangcq090407 add
  private
    { Private declarations }
    FWbPageUrl:string;
    property NowIsRunning:Boolean Read FNowIsRunning Write SetNowIsRunning;

    //將交易提示依照日期保存
    procedure SaveToFile(HintStr:String);
    //Joysun
    function StartGetDocMemo(strlst:TStringList):Boolean;
    function StartGetHintIndex():Boolean;

    procedure ShowRunBar(const Max,NowP:Integer;Const Msg:String);
    function DownHtmlByWb(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
  public
    { Public declarations }
    FUpdated:Boolean;
    procedure InitObj();
    procedure ShowURL(const msg:String);
    procedure ShowMsg(const Msg:String);
    procedure SaveMsg(const Msg:String);
    procedure Start();
    procedure Stop();
    procedure InitForm();

    function DownFinish():Boolean; //add by wangjinhua Doc 4.14 - Problem(20100319)
  end;


  function DeleteAToken(TokenType:TTokenType;site:integer;InText:string;var OutText:string;way:byte):boolean;stdcall;external  'DLLHtmlParser.dll';
  function DeleteTokens(TokenType:TTokenType;InText:string;var OutText:string;way:byte):boolean;stdcall;external  'DLLHtmlParser.dll';
  function GetText(TokenType:TTokenType;site:integer;InText:string;var OutText:string):boolean;stdcall;external  'DLLHtmlParser.dll';
  function GetTextAccordingToInifile(InText:string;var OutText:string;InifileName:string):boolean; stdcall;external  'DLLHtmlParser.dll';

var
  AMainFrm: TAMainFrm;

implementation

{$R *.dfm}

procedure TAMainFrm.InitForm;
begin

  AppParam := TDocMgrParam.Create;

  FDataPath := ExtractFilePath(Application.ExeName)+'Data\';
  //FDocPath  := '';

  Mkdir_Directory(FDataPath);
  //Mkdir_Directory(FDocPath);

  //FTempDocFileName := FDataPath+'Doc_02.tmp';

  FLogFileName := 'Doc_ChinaTodayHint';

  FEndTick := GetTickCount + Round(1000);
  Timer_StartGetDoc.Enabled := True;
  NowIsRunning := false;
  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;

  //ConnectToSoundServer(AppParam.SoundServer,AppParam.SoundPort); //--DOC4.0.0—N001 huangcq090407 del

   //--DOC4.0.0—N001 huangcq090407 add------>
   FStopRunningSkt := False;
   ASocketClientFrm := TASocketClientFrm.Create(Self,'Doc_ChinaTodayHint_SZ',AppParam.DocMonitorHostName
                                              ,AppParam.DocMonitorPort,Msg_ReceiveDataInfo);

   TimerSendLiveToDocMonitor.Interval := 3000;
   TimerSendLiveToDocMonitor.Enabled  := True;
   //<------DOC4.0.0—N001 huangcq090407 add----


end;

procedure TAMainFrm.FormCreate(Sender: TObject);
begin
   InitForm;
   InitObj;
   BtnGo.Click;
end;

procedure TAMainFrm.Start;
begin
   StopRunning  := False;
   NowIsRunning := True;
   FTodayHintDate := -1;
   RefrsehTime(1);
   //FEndTick := GetTickCount + Round(1000);
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
procedure TAMainFrm.SendDocCenterDownFinish;
begin
  if (ASocketClientFrm <> nil) then  //--DOC4.0.0—N002 huangcq090617 add
    ASocketClientFrm.SendText('SendTo=DocCenter;'+
                              'Message=Doc_ChinaTodayHint_SZ;'+
                              'DownLoadSZHintData='+IntToStr(BoolToInt(True))+';'
                              );
end;

procedure TAMainFrm.SendDocMonitorStatusMsg;
var AIsEndDownLoad:Boolean;
begin

  if ASocketClientFrm<>nil Then  //发送包括是否完成本日下载的信息 (不在WarningCenter上显示)
  Begin
     if FTodayHintDate <> Date then
       AIsEndDownLoad:=False
     else
       AIsEndDownLoad:=True;
     ASocketClientFrm.SendText('SendTo=DocMonitor;'+
                                'Message=Doc_ChinaTodayHint_SZ;'+
                                'DownLoadSZHintData='+IntToStr(BoolToInt(AIsEndDownLoad))+';'
                                );
                                //'UploadUplData='+IntToStr(BoolToInt(FFinishCloseMarket))+';'

  End;
end;

function TAMainFrm.SendDocMonitorWarningMsg(const Str: String):Boolean;
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
       SendDocMonitorStatusMsg(); //向DocMonitor发送包括是否完成下载等

    //8:00~9:00之间每隔15分钟检测一次是否完成下载
    if ((Now-Date)<=EncodeTime(9,0,0,0)) and ((Now-Date)>EncodeTime(8,0,0,0)) then
    begin
      if (FTodayHintDate <> Date) then
      begin
        //因为该timer间隔是3s,所以与15分钟的间隔相差3s内都允许
        if ((Time1AndTime2Interval(Now-date,EncodeTime(8,0,0,0)) mod 900) in [0,1,2,3]) then
          SendDocMonitorWarningMsg('上证今日交易提示下载尚未完成'+'$W001');
      end;
    end;
  Finally
    if FStopRunningSkt then TimerSendLiveToDocMonitor.Enabled := False;
    TimerSendLiveToDocMonitor.Tag :=0;
  end;
end;



//add by wangjinhua Doc 4.14 - Problem(20100319)
function TAMainFrm.DownFinish():Boolean;
begin
try
  Result := FileExists(AppParam.Tr1DBPath +'CBData\TodayHint\'+
                       'SZ_'+FormatDateTime('yyyymmdd',Date)+'.DAT');
except
  on e:Exception do
    e := nil;
end;
end;
//--
//<---------DOC4.0.0—N001 huangcq090407 add-------

procedure TAMainFrm.Timer_StartGetDocTime(Sender: TObject);
Var
  i : Integer;

  FStartCheckSearchAllDoc : Boolean;
begin
   Timer_StartGetDoc.Enabled := False;
   IDLstMgr := nil;
   //AppParam := nil;
   CBDataMgr := nil;
try
Try
   IDLstMgr := nil;
   if GetTickCount >= FEndTick Then
   Begin
     if NowIsRunning Then
     Begin
        {//delete by wangjinhua Doc 4.14 - Problem(20100319)
        //已完成今日提示的資料
        if FTodayHintDate=Date Then
        Begin
           RefrsehTime(180);
           Exit;
        End;
        }
        //7:00之後才開始下載
        if (Now-Date)<EncodeTime(7,0,0,0) Then
        Begin
           RefrsehTime(180);
           Exit;
        End
        //add by wangjinhua Doc 4.14 - Problem(20100319)
        else if (Now-Date)>EncodeTime(10,0,0,0) Then
        Begin
           if not DownFinish then
           begin
             ShowMsg('今日无交易提示.');
             SendDocMonitorWarningMsg('上证今日无交易提示'+'$W002');
           end
           else begin
             ShowMsg(Format('完成 %s 交易提示的下载!!',[FormatDateTime('yyyy-mm-dd',Date) ]));
           end;
           RefrsehTime(180);
           Exit;
        End ;
        //--


        ShowMsg('正在读取股票代码.');
        SaveMsg('正在读取股票代码.');
        //AppParam := TDocMgrParam.Create;
        IDLstMgr := TIDLstMgr.Create(AppParam.Tr1DBPath,M_OutPassaway_P_None); //---Doc3.2.0需求1 huangcq080923 modify
        CBDataMgr := TCBDataMgr.Create(AppParam.Tr1DBPath);
        SaveMsg('读取股票代码' + IntToStr(IDLstMgr.IDCount)+ '檔.');
        ShowMsg('读取股票代码' + IntToStr(IDLstMgr.IDCount)+ '檔.');
        FUpdated := false;
        if IDLstMgr.IDCount>0 Then
        Begin
           if StartGetHintIndex Then
           Begin
             //add by wangjinhua Doc 4.14 - Problem(20100319)
             if DownFinish then
             begin
               ShowMsg(Format('完成 %s 交易提示的下载!!',[FormatDateTime('yyyy-mm-dd',Date) ]));
               if FUpdated then
               begin
                 SendDocMonitorWarningMsg('上证今日交易提示下载完成'+'$W001');
                 SendDocCenterDownFinish;
               end;
             end;
             //--
              RefrsehTime(180);
           End Else
           Begin
              ShowMsg('上证本轮下载未能成功');
              RefrsehTime(5);
           End;
        End else //--DOC4.0.0—N001 huangcq090407 add --上面的'无法取得股票代码'应移放在这里才对的
        begin
          RefrsehTime(5); //--DOC4.0.0—N001 huangcq090407 add
          SendDocMonitorWarningMsg('上证--无法取得股票代码'+'$W004');//--DOC4.0.0—N001 huangcq090407 add
        end;
     End;
   End;
Except
  on E:Exception do
  Begin
     RefrsehTime(5);
     //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError);//--DOC4.0.0—N001 huangcq090407 del
     SendDocMonitorWarningMsg('上证下载过程出现错误('+E.Message+')$E005');//--DOC4.0.0—N001 huangcq090407 add
  End;
end;

Finally

   ShowRunBar(0,0,'');

   if IDLstMgr<>nil Then
      IDLstMgr.Destroy;
   {if AppParam<>nil Then
      AppParam.Destroy;
    }
   if CBDataMgr<>nil Then
      CBDataMgr.Destroy;
   if StopRunning Then
      NowIsRunning := False;

   Timer_StartGetDoc.Enabled := True;
End;

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
Var
  vMsg,FileName : String;
begin


  vMsg := Msg;

  ReplaceSubString(#10,'',vMsg);
  ReplaceSubString(#13,'',vMsg);

  FileName := ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\'+FLogFileName+'\'+
              FormatDateTime('yyyymmdd',Date)+'.log';
  Mkdir_Directory(ExtractFilePath(FileName));

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
   DisplayMsg := TDisplayMsg.Create(Label1,FLogFileName);
   //DocDataMgr := TDocDataMgr.Create(FTempDocFileName,FDocPath);
end;

procedure TAMainFrm.ShowURL(const msg: String);
begin
  SaveMsg(Msg);
  PanelCaption_URL.Caption := msg;
  Application.ProcessMessages;
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

procedure TAMainFrm.SaveMsg(const Msg: String);
begin
    if DisplayMsg<>nil Then
       DisplayMsg.SaveMsg(Msg);
end;


procedure TAMainFrm.CoolTrayIconDblClick(Sender: TObject);
begin
   Show;
end;

procedure TAMainFrm.wbPageDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  if wbPage.Application = pDisp then
  begin
    if FWbPageUrl=URL then
    begin
      FWbPageUrl := '';
      //StatusBar1.Panels[1].Text := 'Done';
      Application.ProcessMessages;
    end;
  end;
end;

function TAMainFrm.DownHtmlByWb(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
var i:integer;
begin
  Result := false;
  AResultStr:= '';
  AErrMsg := '';
  try
      FWbPageUrl := AUrl;
      wbPage.Navigate(FWbPageUrl);
      i:=0;
      while True do
      begin
        Sleep(1000);
        Application.ProcessMessages;
        if FWbPageUrl='' then break;
        Inc(i); if i>90 then exit;//防止wb无响应而造成的死循环
      end;
      AResultStr := wbPage.OleObject.document.body.innerHTML;
      result := true;
      wbPage.Navigate('about:blank');
  except
    on e:Exception do
    begin
      AErrMsg := e.Message;
    end;
  end;

end;

function TAMainFrm.StartGetHintIndex: Boolean;
var
  ts,Response:TStringList;
  AllPage,NowPage : Integer;
  sIniFile,Url,ResultStr,ErrMsg : String;
  i : integer;
  ADoc : TDocData;
  TxtMemo : String;
  RunHttp : TRunHttp;
begin
  // Add the URL to the combo-box.
  Result := false;
  if StopRunning Then exit;
  Response:= nil;

  try
  try
    sIniFile := ExtractFilePath(ParamStr(0))+'Doc_ChinaTodayHint_SZ.ini';
    Url:='';
    if FileExists(sIniFile) then
    begin
      ts := TStringList.Create;
      ts.LoadFromFile(sIniFile);
      TxtMemo := ts.text;
      Url := Trim(GetStr('<url>','</url>',TxtMemo,false,false));
      Url := StringReplace(Url,#13#10,'',[rfReplaceAll, rfIgnoreCase]);
      FreeAndNil(ts);
    end;
    TxtMemo:='';
    if Url='' then Url := 'http://www.sse.com.cn/disclosure/dealinstruc/index.shtml';
    ShowURL(URL);
    if not DownHtmlByWb(URL,ResultStr,ErrMsg) then
    begin
      if Length(ErrMsg)>0 Then
        SendDocMonitorWarningMsg('上证下载过程出现错误('+ErrMsg+')$E006');
    end;
    if StopRunning Then Exit;

    if Length(ResultStr)>0 Then
    Begin
      Response := TStringList.Create;
      Response.Text := ResultStr;
      Result :=  StartGetDocMemo(Response);
      Response.Free;
      Response := Nil;
    End ;
  Except
     On E:Exception do
     Begin
         ShowMsg(E.Message);
         SaveMsg(E.Message);
         //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError);//--DOC4.0.0—N001 huangcq090407 del
         SendDocMonitorWarningMsg('上证下载过程出现错误('+E.Message+')$E005');//--DOC4.0.0—N001 huangcq090407 add
     End;
  End;
  finally
      ShowURL('');
      ShowMsg('');
      StatusBar1.Panels[2].Text := '';
      if Response<>nil Then
         Response.Free;
  end;
end;




procedure TAMainFrm.RefrsehTime(s: Integer);
begin
  FEndTick := GetTickCount + Round(s*1000);
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


procedure TAMainFrm.SaveToFile(HintStr: String);
Var
  FileName,vLastHintStr,vOutPutStr1,vOutPutStr2,str1,str2 : String;
  f: TStringList;
  j,vcount : integer;
  IsContinue:Boolean;
begin
  //將交易提示依照日期保存

  FileName := AppParam.Tr1DBPath +'CBData\TodayHint\'+'SZ_'+
                   FormatDateTime('yyyymmdd',Date)+'.DAT';
  Mkdir_Directory(ExtractFilePath(FileName));

  f := nil;
Try
Try
  IsContinue := False;
  f := TStringList.Create;
  if FileExists(FileName) then
  begin
    f.LoadFromFile(FileName);
    vLastHintStr := f.Text;

    Str1 := vLastHintStr;
    ReplaceSubString(#13#10,'',Str1);
    ReplaceSubString(#9,'',Str1);
    ReplaceSubString(#$A,'',Str1);
    ReplaceSubString(#$D,'',Str1);

    Str2 := HintStr;
    ReplaceSubString(#13#10,'',Str2);
    ReplaceSubString(#9,'',Str2);
    ReplaceSubString(#$A,'',Str2);
    ReplaceSubString(#$D,'',Str2);


    if SameText(Trim(Str1),Trim(Str2)) then
      Exit
    else
      IsContinue := true;

    
  end else
    IsContinue := True;
  //HintStr:=HintStr+'900535';
  f.Clear;
  For j:=0 to IDLstMgr.IDCount-1 do
  Begin
    if Pos(IDLstMgr.IDItems[j],HintStr)>0 Then
       f.Add(IDLstMgr.IDItems[j]);
    //沪市
    if(Copy(IDLstMgr.IDItems[j],1,3)='600')then
    begin
      //转股代码1
      if Pos(('181'+Copy(IDLstMgr.IDItems[j],4,3)),HintStr)>0 Then
        f.Add('181'+Copy(IDLstMgr.IDItems[j],4,3));
      //转股代码2
      if Pos(('190'+Copy(IDLstMgr.IDItems[j],4,3)),HintStr)>0 Then
        f.Add('190'+Copy(IDLstMgr.IDItems[j],4,3));
      //B股代码
      if Pos(('900'+Copy(IDLstMgr.IDItems[j],4,3)),HintStr)>0 Then
        f.Add('900'+Copy(IDLstMgr.IDItems[j],4,3));
    end;

    //深市
    if(Copy(IDLstMgr.IDItems[j],1,3)='000')then
    begin
      //B股代码
      if Pos(('200'+Copy(IDLstMgr.IDItems[j],4,3)),HintStr)>0 Then
        f.Add('200'+Copy(IDLstMgr.IDItems[j],4,3));
    end;

  End;

  //其他B股代码
  if Pos('900937',HintStr)>0 Then
    f.Add('900937');
  if Pos('200488',HintStr)>0 Then
    f.Add('200488');
  if Pos('200002',HintStr)>0 Then
    f.Add('200002');
  if Pos('200726',HintStr)>0 Then
    f.Add('200726');
  if Pos('900901',HintStr)>0 Then
    f.Add('900901');
  if Pos('200024',HintStr)>0 Then
    f.Add('200024');
  if Pos('200581',HintStr)>0 Then
    f.Add('200581');
  if Pos('900903',HintStr)>0 Then
    f.Add('900903');

  f.SaveToFile(ExtractFilePath(FileName)+'SZ_TodayHintIDLst.DAT');
  f.Clear;
  f.Text := HintStr;
  f.SaveToFile(FileName);
  FUpdated := IsContinue;
Except
End;
Finally
  if Assigned(f) Then
     f.Free;
End;

end;




procedure RemoveTokens(Intext:String;var OutText:String);
var
  StartPos,EndPos:Integer;
  OutputStr:String;
begin
  OutputStr := InText;
  StartPos:=Pos('<',OutputStr);
  EndPos:=Pos('>',OutputStr);

  while (StartPos<>0) and (EndPos<>0) and (EndPos>StartPos) do
  begin
    delete(OutputStr,StartPos,EndPos-StartPos+1);
    OutputStr := Trim(OutPutStr);
    StartPos:=Pos('<',OutputStr);
    EndPos:=Pos('>',OutputStr);
  end;
  OutText := OutputStr;
end;



function TAMainFrm.StartGetDocMemo(strlst: TStringList):Boolean;
const CSBefore='Before';
      CSAfter='After';
var
  startp,endp:integer;
  str,StrR,MemoTxt,sSrc,sSec,sText,sTemp:String;
  Str_Null:Boolean;
  sPath,sIniFile,sIniFileTemp,sIniFileText,sIniFileTempText:string;
  ts:TStringList;

  function DealSec(sIn,sFlagS,sFlagE:string;b:Boolean):string;
  var slTemp,slIn,slInTemp:string;
  begin
    Result:='';
    try
      slIn:=sIn;
      sIniFileTempText := GetStr(sFlagS,sFlagE,sIniFileText,false,false);
      ts.Text := sIniFileTempText;
      ts.SaveToFile(sIniFileTemp);
      if not FileExists(sIniFileTemp) then exit;
      if not GetTextAccordingToInifile(slIn,Result,sIniFileTemp) then exit;
      if FileExists(sIniFileTemp) then DeleteFile(sIniFileTemp);
    finally
      if b then
      begin
        if Trim(Result)='' then Result:='无';
        if (Result<>'无') and (Length(Result)<>0) then  Str_Null:=false;
      end;
    end;
  end;
begin
  Result := false;
  sText:=strlst.Text;
  if(Length(sText)=0)then exit;
  Str_Null:=true; //主要用于判断信息内容是否为空    ture 为空 false为非空
  ts:=TStringList.create;
try
try
  //检查日期
  startP:=Pos(FormatDateTime('yyyy-mm-dd',Date)+'特别提示',sText);
  if(startP=0)then exit;

  sPath := ExtractFilePath(ParamStr(0));
  sIniFile := sPath+'Doc_ChinaTodayHint_SZ.ini';
  sIniFileTemp:= sPath+'Doc_ChinaTodayHint_SZTemp.ini';
  if not FileExists(sIniFile) then exit;
  ts.LoadFromFile(sIniFile);
  sIniFileText := ts.text;

  sText :=DealSec(sText,'<common>','</common>',false);
  //特别提示
  str :=DealSec(sText,'<tbts>','</tbts>',true);
  MemoTxt:=Concat(MemoTxt,'['+Copy(strlst.Text,Pos('特别提示',strlst.Text)-
     Length(FormatDateTime('yyyy-mm-dd',Date)),
     Length(FormatDateTime('yyyy-mm-dd',Date)))
     +' 特别提示]:'+#13);
  MemoTxt:=Concat(MemoTxt,str+#13);
  //停牌一小时
  str :=DealSec(sText,'<pztp>','</pztp>',true);
  MemoTxt:=Concat(MemoTxt,'[盘中停牌提示]:'+#13);
  MemoTxt:=Concat(MemoTxt,str+#13);
  //发行与中签
  str :=DealSec(sText,'<fxyzq>','</fxyzq>',true);
  MemoTxt:=Concat(MemoTxt,'[发行与中签]:'+#13);
  MemoTxt:=Concat(MemoTxt,str+#13);
  //其它提示
  str :=DealSec(sText,'<qtts>','</qtts>',true);
  MemoTxt:=Concat(MemoTxt,'[其它提示]:'+#13);
  MemoTxt:=Concat(MemoTxt,str+#13);

  //只有交易提示中至少有一项内容不为空时保存信息，否则退出
  if not Str_Null then
  begin
    SaveToFile(MemoTxt);
    FTodayHintDate := Date;
    SaveMsg('文章内容成功取得');
    Result := true;
  end else
    exit;
except
  on e:exception do
    ShowMsg(e.Message);
end;
finally
  FreeAndNil(ts);
end;
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




procedure TAMainFrm.wbPageStatusTextChange(Sender: TObject;
  const Text: WideString);
begin
  //StatusBar1.Panels[1].Text := Text;
  Application.ProcessMessages;
end;

procedure TAMainFrm.wbPageProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
  ShowRunBar(ProgressMax,Progress,'');
end;

end.
