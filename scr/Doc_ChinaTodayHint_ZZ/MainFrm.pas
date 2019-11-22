///////////////////////////////////////////////////////////////////////////////////
// 中正网不能正常下载20070710
//中正网不能正常下载20080103
//界面提示修改20080121
//更换新网址20080128
////Doc_ChinaTodayHint_ZZ-DOC3.0.0需求6-leon-08/8/14;  （修改调用DLLHtmlParser.dll中GetTextAccordingToInifile函数来定位网页脚本中的字符串）
//Problem081029 huangcq --修改缺少 今日交易提示标题关键字没有月仅有日的情况
//problem081125 huangcq --修改 今日交易提示内容解析时，没有考虑<BR/>的情况
//---Doc3.2.0需求1 huangcq080923 修改：获取market_db\pulish_db目录下的txt文件
//--DOC4.0.0—N001 huangcq090407  Doc与WarningCenter整合
///////////////////////////////////////////////////////////////////////////////////

unit MainFrm;

interface

uses
  ShareMem,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, IdIntercept, IdLogBase, IdLogDebug,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,csDef, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,IniFiles,TCommon,TDocMgr, ImgList,
  StrUtils,uDllUrlHandle, Menus, TodayHint_ZZ_Set,SocketClientFrm,TSocketClasses; //TWarningServer



type
  TTokenType=(ttNone,ttP,ttTable,ttTR,ttTD,ttDiv,
              ttImg,ttA,ttB,ttI,ttScript,ttLi,ttHr,
              ttH,ttSpan,ttStyle,ttFont,ttHead,ttTitle,
              ttCenter,ttBody,ttHtml,ttStrong);

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
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    TimerSendLiveToDocMonitor: TTimer;
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
    procedure N2Click(Sender: TObject);
    procedure TimerSendLiveToDocMonitorTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FTodayHintFilePath :String;//更换新网址20080128
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

    InifileName:String;

    FTodayHintDate : TDate;
    //AppParam : TDocMgrParam;

    ASocketClientFrm : TASocketClientFrm; //--DOC4.0.0—N001 huangcq090407 add
    FStopRunningSkt : Boolean; //--DOC4.0.0—N001 huangcq090407 add

    HaveFinished:Boolean; //界面提示修改20080121
    FEndTick : DWord;
    procedure CreateHintFile(Memo:String);
    procedure SetNowIsRunning(const Value: Boolean);
    Procedure RefrsehTime(s:Integer);

    procedure SendDocCenterDownFinish();//--DOC4.0.0—N002 huangcq090617 add
    procedure SendDocMonitorStatusMsg;//--DOC4.0.0—N001 huangcq090407 add
    function SendDocMonitorWarningMsg(const Str: String): boolean;//--DOC4.0.0—N001 huangcq090407 add
    procedure Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);//--DOC4.0.0—N001 huangcq090407 add
  private
    { Private declarations }
    property NowIsRunning:Boolean Read FNowIsRunning Write SetNowIsRunning;

    //將交易提示依照日期保存
    procedure SaveToFile(HintStr:String);

    Procedure  StartGetDocHtml(const TxtUrl:String);
    function  StartGetDocHtml2(const TxtUrl:String):Boolean;//problem081125--huangcq --add
    function StartGetHintIndex():Boolean;
    function GetTheHintKeyWord():String;//Problem081029--huangcq --add
    Function GetTodayHintUrl2(Txt:TStringList):String;//Problem081029--huangcq --add
    Function GetTodayHintUrl(Txt:TStringList):String;
    function GetDocTitle(Txt:TStringList;ID:String):boolean;
    procedure GetAllDocPage(Txt:TStringList;Var AllPage,NowPage:Integer);

    procedure ShowRunBar(const Max,NowP:Integer;Const Msg:String);

{///////////////////////////////////////////////////////////////////////////add by Leon 080613
    function ReadTodayHintCount(FTokenType:TTokenType):integer;
    function ReadTodayHintContent(FTokenType:TTokenType;Index:integer):integer;
    function GetAllText(FTokenType:TTokenType;AStr:String):String;
//////////////////////////////////////////////////////////////////////////  }
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

    procedure HttpStatusEvent(ASender: TObject;AStatusText: string;aKey:string);
     procedure HttpBeginEvent(Sender: TObject;AWorkCountMax: Integer;aKey:string);
     procedure HttpEndEvent(Sender: TObject;aDoneOk:Boolean;aKey,aResult:string);
     procedure HttpWorkEvent(Sender: TObject; AWorkCount,AWorkMax: Integer;aKey:string);
     function GetHttpTextByUrl(aUrl:string; var aOutHtmlText,aErrStr:string):Boolean;

  end;

function GetTextAccordingToInifile(InText:string;var OutText:string;InifileName:string):boolean;export;stdcall;external  'DLLHtmlParser.dll'; //Doc_ChinaTodayHint_ZZ-DOC3.0.0需求6-leon-08/8/14-add; 
//function GetText(TokenType:TTokenType;site:integer;InText:string;var OutText:string):boolean; stdcall;external  'DLLHtmlParser.dll';
function DeleteTokens(TokenType:TTokenType;InText:string;var OutText:string;way:byte):boolean;  stdcall;external  'DLLHtmlParser.dll';
function SubStringReplace(SubString, ReplaceString:string; var Source:string):boolean;  stdcall;external  'DLLHtmlParser.dll';


var
  AMainFrm: TAMainFrm;
  TodayHintLst:TIniFile;//更换新网址20080128
implementation

{$R *.dfm}

procedure TAMainFrm.InitForm;
begin

  AppParam := TDocMgrParam.Create;

  FDataPath := ExtractFilePath(Application.ExeName)+'Data\';
  //FDocPath  := '';
  FTodayHintFilePath:=ExtractFilePath(Application.ExeName)+'TodayHint.ini'; //更换新网址20080128

  InifileName := ExtractFilePath(Application.ExeName)+'Doc_ChinaTodayHint_ZZ.ini';//Doc_ChinaTodayHint_ZZ-DOC3.0.0需求6-leon-08/8/14-add;

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

//  ConnectToSoundServer(AppParam.SoundServer,
//                       AppParam.SoundPort);

   //--DOC4.0.0—N001 huangcq090407 add------>
   FStopRunningSkt := False;
   ASocketClientFrm := TASocketClientFrm.Create(Self,'Doc_ChinaTodayHint_ZZ',AppParam.DocMonitorHostName
                                              ,AppParam.DocMonitorPort,Msg_ReceiveDataInfo);

   TimerSendLiveToDocMonitor.Interval := 3000;
   TimerSendLiveToDocMonitor.Enabled  := True;
   //<------DOC4.0.0—N001 huangcq090407 add----

end;

procedure TAMainFrm.FormCreate(Sender: TObject);
begin
   InitForm;
   InitObj;
   TodayHintLst:=TIniFile.Create(FTodayHintFilePath);//20080128
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

procedure TAMainFrm.GetAllDocPage(Txt: TStringList; var AllPage,
  NowPage: Integer);
Var
  t1,t2 : Integer;
  Str,Str2 : String;
Begin

 Str := Txt.Text;
 t1 := Pos('条信息，共',Str)+Length('条信息，共');
 t2 := Pos('页，本页为第',Str);
 Str2  := Trim(Copy(Str,t1,t2-t1));
 AllPage := StrToInt(Str2);


 t1 := t2+Length('页，本页为第');
 t2 := Pos('页</td></tr>',Str);
 Str2  := Trim(Copy(Str,t1,t2-t1));
 NowPage := StrToInt(Str2);
end;

function TAMainFrm.GetDocTitle(Txt: TStringList;ID:String):boolean;
Var
  t1,t2,i : integer;
  Str : String;
  ParamStr : String;
  TxtHttp  : String;
  TxtCaption  : String;
  TxtDateTime : String;
  TxtTime  : TTime;
  TxtDate  : TDate;
  DateTime : TDateTime;
  Year,Month,Day : Word;
begin

 Result := True;

 ParamStr := '<tr><td>·<a class=bodyw target="blank" href="gsgg_pop.asp?ZQDM=' + ID;

 for i:=0 to Txt.Count-1 do
 Begin
     if StopRunning Then exit;
     Str := Trim(Txt.Strings[i]);
     if (Pos(ParamStr,Str)>0) Then
     Begin

        t1 := Pos('&GGBH=',Str)+Length('&GGBH=');
        t2 := Pos('">',Str);
        TxtHttp := 'http://www.f10.com.cn/ggzx/gsgg_pop.asp?ZQDM=' + ID+'&GGBH='+Copy(str,t1,t2-t1);

        ReplaceSubString(ParamStr,'',Str);
        t1 :=  Pos('">',Str)+Length('">');
        t2 :=  Pos('</a>',Str);
        TxtCaption := Trim(Copy(str,t1,t2-t1));

        t1 :=  Pos('</a><span class=rq>',Str)+Length('</a><span class=rq>');
        t2 :=  Pos('<span></td></tr>',Str);
        Str := Copy(str,t1,t2-t1);
        TxtDateTime := Trim(Str);

        ShowMsg(TxtCaption+'('+TxtDateTime+')');
        SaveMsg(TxtCaption+'('+TxtDateTime+')');

        DateTime := StrToDate2(TxtDateTime);
        DeCodeDate(DateTime,Year,Month,Day);
        TxtDate := EncodeDate(Year,Month,Day);
        TxtTime := 0;

        if StopRunning Then exit;
       {
        if DocDataMgr.NowActionIsCheckAllDoc Then
        Begin
           //現在正在進行檢查是否有公告缺漏
           DocDataMgr.AppendADoc(TxtCaption,ID,'',TxtDate,TxtTime,TxtHttp);
        End Else
        Begin
          if DocDataMgr.AddADoc(TxtCaption,ID,'',TxtDate,TxtTime,TxtHttp)=nil Then
          Begin
              Result := false;
              Break;
          End;
        End;
        }
     End;
 End;

end;


function RmvHtmlTag(MemoTxt:string):string;
var
  i,StartP,EndP,StartP2,EndP2:integer;
  Str_temp,Str_temp2,Str_temp3:String;
  HtmlTxt:TStringList;
begin
  try
    HtmlTxt:=TStringList.Create;
    //add by JoySun 2005/10/24 处理Table格式
    //---------------------------------------------------
    MemoTxt:=StringReplace(MemoTxt,#13#10,'',[rfReplaceAll]);
    MemoTxt:=StringReplace(MemoTxt,'<table',#13#10+'<table',[rfReplaceAll]);
    MemoTxt:=StringReplace(MemoTxt,'<tr',#13#10+'<tr',[rfReplaceAll]);
    StartP := Pos('<table',MemoTxt);
    if(StartP>0)then
    begin
      EndP := Pos('</table>',MemoTxt);
      Str_temp:=Copy(MemoTxt,StartP,EndP-StartP+Length('</table>'));

      HtmlTxt.Clear;
      StartP2 := Pos('<tr',Str_temp);
      i:=0;
      While StartP2>0 do
      Begin
        inc(i);
        if(i>1000)then break;
        EndP2 := Pos('</tr>',Str_temp);
        if EndP2=0 then break;
        Str_temp2:=Copy(Str_temp,StartP2,EndP2-StartP2);
        ReplaceSubString(#13#10,'  ',Str_temp2);
        HtmlTxt.Add(Str_temp2);
        Str_temp3:=Copy(Str_temp,StartP2,EndP2-StartP2+Length('</tr>'));
        if Str_temp3='' then break; 
        ReplaceSubString_first(Str_temp3,'',Str_temp);
        StartP2 := Pos('<tr',Str_temp);
      End;
      Str_temp:=HtmlTxt.Text;
      HtmlTxt.Clear;

      Str_temp3:=Copy(MemoTxt,StartP,EndP-StartP+Length('</table>'));
      if Str_temp3<>'' then
        ReplaceSubString_first(Str_temp3,Str_temp,MemoTxt);
    end;

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
        ReplaceSubString(Str_temp3,#13#10,MemoTxt)
      end
      else begin
        Str_temp3:=Copy(MemoTxt,StartP,EndP-StartP+1);
        if Str_temp3='' then break;
        ReplaceSubString(Str_temp3,'',MemoTxt);
      end;
      StartP := Pos('<',MemoTxt);
    End;
    ReplaceSubString('&NBSP;',' ',MemoTxt);
    ReplaceSubString('&nbsp;',' ',MemoTxt);

    //去掉第一行的空格
    if(Pos(#13#10,MemoTxt)=1)then
      MemoTxt := Copy(MemoTxt,Length(#13#10)+1,Length(MemoTxt)-Length(#13#10));
    result:=MemoTxt;
  finally
    FreeAndNil(HtmlTxt);
  end;
end;

//problem081125 huangcq 该函数StartGetDocHtml是替换StartGetDocHtml2函数，
//主逻辑保持不变，仅是将旧函数中没有用的去掉，因为旧的这个函数的部分逻辑是在网站更换之前使用的
function TAMainFrm.StartGetDocHtml2(const TxtUrl: String):Boolean;//problem081125  huangcq--add
var
  RunHttp : TRunHttp;
  OUTputText,ResultStr,ErrMsg,sTemp1:String;
  FTokenType:TTokenType;
  vTimes:Integer;
begin
  HaveFinished:=False; //界面提示修改20080121
  Result := false;
  try
      ShowURL(TxtURL);
      if not GetHttpTextByUrl(TxtURL,ResultStr,ErrMsg) then
      begin
        SendDocMonitorWarningMsg('中证下载过程出现错误('+ErrMsg+')$E006');
         //SendToSoundServer('GET_DOC_ERROR',RunHttp.RunErrMsg,svrMsgError);   //--DOC4.0.0—N001 huangcq090407 del
        exit;
      end;
      if StopRunning Then Exit;
      if Length(ErrMsg)>0 Then
        SendDocMonitorWarningMsg('中证下载过程出现错误('+ErrMsg+')$E006');
      if StopRunning Then Exit;

    {HTTP.ProxyParams.ProxyUsername := '';
    HTTP.ProxyParams.ProxyPassword := '';
    HTTP.ProxyParams.ProxyServer:='';
    HTTP.ProxyParams.ProxyPort := 80;
    HTTP.Request.ContentType := 'text/html; charset=gb2312';
    HTTP.Intercept := LogDebug;

    ShowURL(TxtURL);

    RunHttp := TRunHttp.Create(HTTP,TxtURL);
    RunHttp.Resume;
    vTimes:=0;
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
          if StopRunning Then Exit;
       End;
       Application.ProcessMessages;
       Sleep(10);
       {Inc(vTimes);
       if vTimes>1000 then
       begin
         //RunHttp.ResultString:='';
         break;
       end;}
   { End;
    ResultStr := RunHttp.ResultString;
    RunHttp.Destroy; }

    if Pos('404 Not Found',ResultStr)>0 Then
        SaveMsg(ResultStr)
    Else
    Begin
      if Length(ResultStr)<=0 then exit;
      if not GetTextAccordingToInifile(ResultStr,OUTputText,InifileName) then exit;
      OUTputText:=RmvHtmlTag(OUTputText);
      sTemp1:=GetStrOnly2('script>','</script>',OUTputText,true);
      SubStringReplace(sTemp1,'',OUTputText);
      {FTokenType:=ttP;
      DeleteTokens(FTokenType,OUTputText,OUTputText,1);
      FTokenType:=ttStrong;
      DeleteTokens(FTokenType,OUTputText,OUTputText,1);
      SubStringReplace('&nbsp;','',OUTputText);
      SubStringReplace(' />','/>',OUTputText);
      SubStringReplace('<BR>',#13,OUTputText);
      SubStringReplace('<br>',#13,OUTputText);
      SubStringReplace('<BR/>',#13,OUTputText);//problem081125  huangcq--add
      SubStringReplace('<br/>',#13,OUTputText);//problem081125  huangcq--add   }
      if Length(OUTputText)<=0 then exit;
      SaveToFile(OUTputText);
      Result := true;
      FTodayHintDate := Date;
      HaveFinished:=True;   //20080121
    end;
  finally
  end;
end;

Procedure TAMainFrm.StartGetDocHtml(const TxtUrl: String);
var
  //Response:TStringList;
  Str : TStringList;
  i,t1,j,StartP,EndP,k : integer;
  ResultStr : String;
  //wS : WideString;
  RunHttp : TRunHttp;
  vErrMsg : String;
  HintMsgLst : Array of THintMsg;
  HaveHintMemo : Boolean;
  OUTputText,OUTputText2,OUTputText3,OUTputText4,OUTputText5,OUTputText6,OUTputText7,
  OUTputText8,OUTputText9,OUTputText10,OUTputText11:String;
  FTokenType:TTokenType;
  pos_start:integer;
begin
  // Add the URL to the combo-box.
  Str := TStringList.Create;
  HaveHintMemo := False;
  HaveFinished:=False; //界面提示修改20080121
  try
    HTTP.ProxyParams.ProxyUsername := '';
    HTTP.ProxyParams.ProxyPassword := '';
    HTTP.ProxyParams.ProxyServer:='';
    HTTP.ProxyParams.ProxyPort := 80;
    HTTP.Request.ContentType := 'text/html; charset=gb2312';
    HTTP.Intercept := LogDebug;

    ShowURL(TxtURL);

    RunHttp := TRunHttp.Create(HTTP,TxtURL);
    RunHttp.Resume;
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
          //Wait Doc Be Client Check
          if vErrMsg<> RunHttp.RunErrMsg Then
            vErrMsg := RunHttp.RunErrMsg;
          if StopRunning Then Exit;
          //-----------------------
       End Else
          vErrMsg := '';
       Application.ProcessMessages;
       Sleep(10);
    End;
    ResultStr := RunHttp.ResultString;

    RunHttp.Destroy;

    if Pos('404 Not Found',ResultStr)>0 Then
    Begin
        SaveMsg(ResultStr)
    End
    Else
    Begin
      if Length(ResultStr)>0 Then
      Begin
        if not GetTextAccordingToInifile(ResultStr,OUTputText8,InifileName) then  //Doc_ChinaTodayHint_ZZ-DOC3.0.0需求6-leon-08/8/14-modify;
           exit;
{        //中正网不能正常下载20070710 by LB             ////Doc_ChinaTodayHint_ZZ-DOC3.0.0需求6-leon-08/8/14-delete;
        FTokenType :=ttTable;
//----------------------------------------------------add by leon 080613
        OUTputText5:= GetAllText(FTokenType,ResultStr);
        {GetText(FTokenType,1,ResultStr,OUTputText);
        GetText(FTokenType,2,OUTputText,OUTputText2);
        GetText(FTokenType,4,OUTputText2,OUTputText3);
        GetText(FTokenType,1,OUTputText3,OUTputText4);
        GetText(FTokenType,2,OUTputText4,OUTputText5); }
        //GetText(FTokenType,1,OUTputText5,OUTputText6);  //中正网不能正常下载20080103

 {       FTokenType:=ttTR;
        OUTputText6:= GetAllText(FTokenType,OUTputText5);
       // GetText(FTokenType,8,OUTputText5,OUTputText6);  //delete by leon 080613

        //GetText(FTokenType,6,OUTputText5,OUTputText6); //中正网不能正常下载20080103
        FTokenType:=ttTD;
        OUTputText7:= GetAllText(FTokenType,OUTputText6);
       // GetText(FTokenType,1,OUTputText6,OUTputText7);  //delete by leon 080613
        FTokenType:=ttDiv;
        OUTputText8:= GetAllText(FTokenType,OUTputText7);
       // GetText(FTokenType,1,OUTputText7,OUTputText8);  //delete by leon 080613
//------------------------------------------------------------------------------  }
        pos_start:=pos('</style>',OUTputText8);
        if   pos_start>0 then
          begin
            OUTputText9:=copy(OUTputText8,pos_start+8,Length(OUTputText8)-pos_start-7);
            FTokenType:=ttP;
            DeleteTokens(FTokenType,OUTputText9,OUTputText10,1);
            FTokenType:=ttStrong;
            DeleteTokens(FTokenType,OUTputText10,OUTputText11,1);
            SubStringReplace('&nbsp;','',OUTputText11);
            SubStringReplace('<BR>',#13,OUTputText11);
            SubStringReplace('<br>',#13,OUTputText11);
          end
        else
          begin
            OUTputText9:=OUTputText8;
            FTokenType:=ttP;
            //OUTputText5:='<P>558</P>' ;
            DeleteTokens(FTokenType,OUTputText9,OUTputText10,1);
            FTokenType:=ttStrong;
            DeleteTokens(FTokenType,OUTputText10,OUTputText11,1);
            SubStringReplace('&nbsp;','',OUTputText11);
            SubStringReplace('<BR>',#13,OUTputText11);
            SubStringReplace('<br>',#13,OUTputText11);

            SubStringReplace('<BR/>',#13,OUTputText11);//problem081125  huangcq--add
            SubStringReplace('<br/>',#13,OUTputText11);//problem081125  huangcq--add
          end;
        //ShowMessage(ResultStr);

        //Response.Text := ResultStr;

        {t1 := Pos('<td valign=''top'' class=''ztyw1''>',ResultStr)+
                  Length('<td valign=''top'' class=''ztyw1''>');
        ResultStr := Copy(ResultStr,t1,Length(ResultStr)-t1);}

        t1 := Pos('字体：',ResultStr)+Length('字体：');
        ResultStr := Copy(ResultStr,t1,Length(ResultStr)-t1);

        t1 := Pos('中证网',ResultStr);
        ResultStr := Copy(ResultStr,1,t1+Length('中证网')+1);

        StartP := Pos('<',ResultStr);
        i:=0;
        While StartP>0 do
        Begin
          inc(i);
          if(i>10000)then break;
          EndP := Pos('>',ResultStr);
          if EndP=0 then break;
          //保持原有的换行
          if(Pos('<br',Copy(ResultStr,StartP,EndP-StartP+1))=1)then
            ReplaceSubString(Copy(ResultStr,StartP,EndP-StartP+1),#13#10,ResultStr)
          else
            ReplaceSubString(Copy(ResultStr,StartP,EndP-StartP+1),'',ResultStr);
          StartP := Pos('<',ResultStr);
        End;

        ReplaceSubString(#$A,'',ResultStr);
        //將交易提示依照日期保存
        ReplaceSubString('<BR>',#13#10,ResultStr);
        ReplaceSubString('<P>','',ResultStr);
        ReplaceSubString('</P>',#13#10,ResultStr);
        ReplaceSubString('&nbsp;','',ResultStr);
        ReplaceSubString('</div>','',ResultStr);
        ReplaceSubString('<!--/enpcontent-->','',ResultStr);

        //SaveToFile(ResultStr);
        SaveToFile(OUTputText11);

        //SaveToFile('600196$^181196#@900196$)*(@200002&#_@!#)000002');

        {

        Str.Text := ResultStr;

        i := -1;
        For t1:=0 to Str.Count-1 do
        Begin
            ResultStr := Trim(Str.Strings[t1]);
            if Length(ResultStr)=0 Then
               Continue;
            if (Pos('因',ResultStr)>0) or (Pos('。',ResultStr)>0) Then
            Begin
                i := High(HintMsgLst)+1;
                SetLength(HintMsgLst,i+1);
                HintMsgLst[i].Title := ResultStr;
                HintMsgLst[i].IDLst := TStringList.Create;
            End Else
            Begin
                if i>=0 Then
                Begin
                   For j:=0 to IDLstMgr.IDCount-1 do
                   Begin
                     if Pos(IDLstMgr.IDItems[j],ResultStr)>0 Then
                     Begin
                        HintMsgLst[i].IDLst.Add(ResultStr);
                        Break;
                     End;
                   End;
                End;
            End;
        End;

        Str.Clear;
        }
        //for t1:=0 to High(HintMsgLst) do
        //Begin
        //   if HintMsgLst[t1].IDLst.Count>0 Then
        //   Begin
        //     Str.Add('');
        //     Str.Add(HintMsgLst[t1].Title);
        //     For i:=0 to HintMsgLst[t1].IDLst.Count-1 do
        //        Str.Add(HintMsgLst[t1].IDLst.Strings[i]);
        //     HaveHintMemo := True;
        //   End Else
        //   Begin
             //其他主題
         //    For j:=0 to IDLstMgr.IDCount-1 do
         //    Begin
                //如果裡面含有需要的代碼
         //       if Pos(IDLstMgr.IDItems[j],HintMsgLst[t1].Title)>0 Then
         //       Begin
         //           Str.Add('');
         //           Str.Add(HintMsgLst[t1].Title);
         //           HaveHintMemo := True;
         //           Break;
         //       End;
         //    End;
         //  End;
        //End;

        SaveMsg('文章内容成功取得');

        //CreateHintFile(Str.Text);

        FTodayHintDate := Date;
        HaveFinished:=True;   //20080121
      End;
    End;
  finally
     for t1:=0 to High(HintMsgLst) do
         HintMsgLst[t1].IDLst.Free;
     SetLength(HintMsgLst,0);
     Str.Free;
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
procedure TAMainFrm.SendDocCenterDownFinish;
begin
  if (ASocketClientFrm <> nil) then  //--DOC4.0.0—N002 huangcq090617 add
    ASocketClientFrm.SendText('SendTo=DocCenter;'+
                              'Message=Doc_ChinaTodayHint_ZZ;'+
                              'DownLoadZZHintData='+IntToStr(BoolToInt(True))+';'
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
                                'Message=Doc_ChinaTodayHint_ZZ;'+
                                'DownLoadZZHintData='+IntToStr(BoolToInt(AIsEndDownLoad))+';'
                                );
                                //'UploadUplData='+IntToStr(BoolToInt(FFinishCloseMarket))+';'

  End;
end;

function TAMainFrm.SendDocMonitorWarningMsg(const Str: String): boolean;
var AStrAllowed:String;
begin
  if ASocketClientFrm<>nil Then
    Begin
      //SocketClient sendtext format is '#%B%SocketName='+value+';%E%#' ,thus,must
      //replace the substring of '#' in the sendcontent
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
                       'ZZ_'+FormatDateTime('yyyymmdd',Date)+'.DAT');
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
        else if (Now-Date)>EncodeTime(12,0,0,0) Then
        Begin
           if not DownFinish then
           begin
             ShowMsg('今日无交易提示.');
             SendDocMonitorWarningMsg('中证今日无交易提示'+'$W002');
           end
           else begin
             ShowMsg(Format('完成 %s 交易提示的下载!!',[FormatDateTime('yyyy-mm-dd',Date) ]));
           end;
           RefrsehTime(180);
           Exit;
        End ;
        //--
        FUpdated := false;
        ShowMsg('正在读取股票代码.');
        SaveMsg('正在读取股票代码.');
        //AppParam := TDocMgrParam.Create;
        IDLstMgr := TIDLstMgr.Create(AppParam.Tr1DBPath,M_OutPassaway_P_None); //---Doc3.2.0需求1 huangcq080923
        CBDataMgr := TCBDataMgr.Create(AppParam.Tr1DBPath);
        SaveMsg('读取股票代码' + IntToStr(IDLstMgr.IDCount)+ '檔.');
        ShowMsg('读取股票代码' + IntToStr(IDLstMgr.IDCount)+ '檔.');
      //showMessage( IntToStr(IDLstMgr.IDCount) );
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
                 SendDocMonitorWarningMsg('中证今日交易提示下载完成'+'$W002');
                 SendDocCenterDownFinish;
               end;
             end;
             //--
              RefrsehTime(180);

               { delete by wangjinhua Doc 4.14 - Problem(20100319)
              //假如下載正常,但是在10:00之後,還是沒有資料
              //則停止下載
              if FTodayHintDate<>Date Then
              Begin
                 if (Now-Date)>EncodeTime(15,0,0,0) Then
                 Begin
                    //CreateHintFile('');
                    FTodayHintDate := Date; //停止下載
                    ShowMsg('今日无交易提示.');
                    SendDocMonitorWarningMsg('中证今日无交易提示'+'$W002');//--DOC4.0.0—N001 huangcq090407 add
                 End Else
                    ShowMsg(Format('尚未下载到 %s 的交易提示!!',[DateToStr(Date)]));
              End Else
              if HaveFinished then    //界面提示修改20080121
                begin
                  ShowMsg(Format('完成 %s 交易提示的下载!!',[DateToStr(FTodayHintDate)]));
                  SendDocMonitorWarningMsg('中证今日交易提示下载完成'+'$W002');//--DOC4.0.0—N001 huangcq090407 add
                  SendDocCenterDownFinish;//--DOC4.0.0—N002 huangcq090617 add
                end else
                   ShowMessage('不能正常下载交易提示，若持续出现此种情况，请系统工程师处理！！');
                // ShowMsg(Format('完成 %s 交易提示的下载!!',[DateToStr(FTodayHintDate)]))}
           End
           else begin
             ShowMsg('中证本轮下载未能成功');
             RefrsehTime(5);
           end;
           {Else //--DOC4.0.0—N001 huangcq090407 del --delete the else section
           Begin
              RefrsehTime(5);
              SendToSoundServer('GET_DOC_ERROR','无法取得股票代码',svrMsgError);
           End;}
        End else ////--DOC4.0.0—N001 huangcq090407 add --上面的'无法取得股票代码'应移放在这里才对的
        begin
          RefrsehTime(5);//--DOC4.0.0—N001 huangcq090407 add
          SendDocMonitorWarningMsg('中证--无法取得股票代码'+'$W005');//--DOC4.0.0—N001 huangcq090407 add
        end;
     End;
   End;
Except
  on E:Exception do
  Begin
     RefrsehTime(5);
     //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError);//--DOC4.0.0—N001 huangcq090407 del
     SendDocMonitorWarningMsg('中证下载过程出现错误('+E.Message+')$E006');//--DOC4.0.0—N001 huangcq090407 add
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
 //  DocDataMgr := TDocDataMgr.Create(FTempDocFileName,FDocPath);
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

function TAMainFrm.StartGetHintIndex: Boolean;
var
  Response:TStringList;
  AllPage,NowPage : Integer;
  Url,ResultStr,ErrMsg : String;
  i,vTimes : integer;
  RunHttp : TRunHttp;
  ADoc : TDocData;
  TxtMemo : String;
begin
  // Add the URL to the combo-box.
    Result := false;
    if StopRunning Then exit;




  {RunHttp := nil;
  Response:= nil; }
  try
  try
    {HTTP.ProxyParams.ProxyUsername := '';
    HTTP.ProxyParams.ProxyPassword := '';
    HTTP.ProxyParams.ProxyServer:='';
    HTTP.ProxyParams.ProxyPort := 80;
    HTTP.Request.ContentType := 'text/html; charset=gb2312';
    HTTP.Intercept := LogDebug;

    //Url := 'http://www.cs.com.cn/sylm/01/index.htm';
    //Url := 'http://www.cs.com.cn/ssgs/09/index.htm';  //中正网不能正常下载20070710
    Url := TodayHintLst.ReadString('TodayHint_ZZ','URL','');  //更换新网址20080128
    ShowURL(URL);
    RunHttp := TRunHttp.Create(HTTP,URL);
    RunHttp.Resume;
    vTimes:=0;
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
       Sleep(10);
       {Inc(vTimes);
       if vTimes>1000 then
       begin
         //RunHttp.ResultString:='';
         Break;
       end;}
    {End;
    if Length(RunHttp.RunErrMsg)>0 Then
      SendDocMonitorWarningMsg('中证下载过程出现错误('+RunHttp.RunErrMsg+')$E006'); //--DOC4.0.0—N001 huangcq090407 add
      //SendToSoundServer('GET_DOC_ERROR',RunHttp.RunErrMsg,svrMsgError);//--DOC4.0.0—N001 huangcq090407 del

    ResultStr := RunHttp.ResultString;
    RunHttp.Destroy;
    RunHttp := nil;
    if StopRunning Then Exit;
    if Length(ResultStr)>0 Then
    Begin
      Response := TStringList.Create;
      Response.Text := ResultStr;
      //Url := GetTodayHintUrl(Response);//Problem081029--huangcq--del
      Url := GetTodayHintUrl2(Response);//Problem081029--huangcq--add
      Response.Free;
      Response := Nil;
      if Length(Url)>0 Then
      begin
        //StartGetDocHtml(Url);
        Result := StartGetDocHtml2(Url);
      end;
    End;}
      Url := TodayHintLst.ReadString('TodayHint_ZZ','URL','');  //更换新网址20080128
      ShowURL(URL);

      if not GetHttpTextByUrl(Url,ResultStr,ErrMsg) then
      begin
        SendDocMonitorWarningMsg('中证下载过程出现错误('+ErrMsg+')$E006');//--DOC4.0.0—N001 huangcq090407 add
         //SendToSoundServer('GET_DOC_ERROR',RunHttp.RunErrMsg,svrMsgError);   //--DOC4.0.0—N001 huangcq090407 del
        exit;
      end;
      if StopRunning Then Exit;
      if Length(ErrMsg)>0 Then
        SendDocMonitorWarningMsg('中证下载过程出现错误('+ErrMsg+')$E006');
      if StopRunning Then Exit;
      if Length(ResultStr)=0 Then exit;

      Response := TStringList.Create;
      Response.Text := ResultStr;
      //Url := GetTodayHintUrl(Response);//Problem081029--huangcq--del
      Url := GetTodayHintUrl2(Response);//Problem081029--huangcq--add
      Response.Free;
      Response := Nil;
      if Length(Url)>0 Then
      begin
        //StartGetDocHtml(Url);
        Result := StartGetDocHtml2(Url);
      end;
  Except
     On E:Exception do
     Begin
         ShowMsg(E.Message);
         SaveMsg(E.Message);
         //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError);//--DOC4.0.0—N001 huangcq090407 del
         SendDocMonitorWarningMsg('中证下载过程出现错误('+E.Message+')$E006');//--DOC4.0.0—N001 huangcq090407 add
     End;
  End;
  finally
      ShowURL('');
      ShowMsg('');
      StatusBar1.Panels[2].Text := '';
      if RunHttp<>nil Then
         RunHttp.Destroy;
      if Response<>nil Then
         Response.Free;
  end;
end;

//------Problem081029--huangcq add-------------------->
function TAMainFrm.GetTheHintKeyWord():String; //Problem081029--huangcq --add 
var
  //lYearFormat,lYearWord:String;
  //lMonthFormat,lMonthWord:String;
  //lDayFormat,lDayWord:String;
  lHintWord:String;
  lCurDate:String;
  //lCurYear,lCurMonth,lCurDay:String;
begin
  Result:='';

  {
  lYearFormat:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','YearFormat','');
  lYearWord:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','YearWord','');

  lMonthFormat:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','MonthFormat','');
  lMOnthWord:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','MonthWord','');

  lDayFormat:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','DayFormat','');
  lDayWord:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','DayWord','');
  }
  lHintWord:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','HintWord','交易提示');


  lCurDate:='';
  {
  if Length(lYearFormat)>0 then
  begin
    lCurYear:=FormatDateTime(lYearFormat,Now);
    lCurDate:=lCurYear+lYearWord;
  end;
  if Length(lMonthFormat)>0 then
  begin
    lCurMonth:=FormatDateTime(lMonthFormat,Now);
    lCurDate:=lCurDate+lCurMonth+lMonthWord;
  end;
  if Length(lDayFormat)>0 then
  begin
    lCurDay:=FormatDateTime(lDayFormat,Now);
    lCurDate:=lCurDate+lCurDay+lDayWord;
  end;
  }
  Result:=lCurDate+lHintWord;
end;

Function TAMainFrm.GetTodayHintUrl2(Txt:TStringList):String;//Problem081029--huangcq --add
  function GetHrefStr(pStr:String):String;
  var n1,n2:integer;
  begin
    Result:=GetStr('<a href=','>',pStr,false,false);
    if Length(Result)>0 then
    begin
      SubStringReplace('<a href=','',Result);
      SubStringReplace('"','',Result);
      Result:=Trim(Result);
      //Result:=StringReplace(Result,'" target="_blank">','',[rfIgnoreCase]);
    end;
  end;
var
  SubStr,URL:String;
  CurD,CurDD,CurM,CurMM,CurHintWord:String;
  i:integer;
  AFindHintLst:TStringList;
  AIsFindWithM:Boolean;
begin
  Result:='';
  SubStr:='';
  AIsFindWithM:=False;

  //CurHintWord:=GetTheHintKeyWord;
  CurHintWord:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','HintWord','交易提示');
  CurD:=FormatDatetime('d',Date)+'日'+CurHintWord;
  CurDD:=FormatDatetime('dd',Date)+'日'+CurHintWord;
  CurM:=FormatDatetime('m',Date)+'月';
  CurMM:=FormatDatetime('mm',Date)+'月';

  AFindHintLst:=TStringList.Create;
  for i:=0 to Txt.Count -1 do
  begin
    if (Pos(CurD,Txt.Strings[i])>0) or (Pos(CurDD,Txt.Strings[i])>0) then
    begin
      AFindHintLst.Add(Txt.Strings[i]);
      if (Pos(CurM,Txt.Strings[i])>0) or (Pos(CurMM,Txt.Strings[i])>0) then
      begin
        AIsFindWithM:=True;
        break;
      end; 
    end;
  end;


  if AIsFindWithM then
    SubStr:=GetHrefStr(AFindHintLst.Strings[AFindHintLst.count-1])
  else if AFindHintLst.Count>0 then
      SubStr:=GetHrefStr(AFindHintLst.Strings[0]);

  if Length(SubStr)>0 then
    SynthesisUrlAddress(TodayHintLst.ReadString('TodayHint_ZZ','URL',''),SubStr,URL);

  Result:=URL;
  AFindHintLst.Free;
end;
//<------Problem081029--huangcq add--------------------

Function TAMainFrm.GetTodayHintUrl(Txt: TStringList):String;
Var
  t1,t2,t3,n1,n2 : Integer;
  Str,DateStr,Substr,URL : String;
  FTokenType:TTokenType;
Begin
//*****************中正网不能正常下载20070710****************************//
  Result := '';
  Str := Txt.Text;

  DateStr:=FormatDateTime('m-d',Date);
  DateStr:=StringReplace(DateStr,'-','月',[rfIgnoreCase]); //20071009  
  //DateStr:=FormatDateTime()
  //if  FormatDateTime('mm',Date)>='10' then
//    begin
//      if FormatDateTime('dd',Date)>='10' then
//      begin
//        DateStr:=StringReplace(DateStr,'-','月',[rfIgnoreCase]);
//      end else
//      begin
//        Delete(DateStr,4,1);  //20071008
//        DateStr:=StringReplace(DateStr,'-','月',[rfIgnoreCase]);
//
//      end;
//    end else
//    begin
//      if FormatDateTime('dd',Date)>='10' then
//      begin
//        DateStr:=StringReplace(DateStr,'-','月',[rfIgnoreCase]);
//        DateStr:=StringReplace(DateStr,'0','',[rfIgnoreCase]);
//      end else
//      begin
//        DateStr:=StringReplace(DateStr,'-','月',[rfIgnoreCase]);
//        DateStr:=StringReplace(DateStr,'0','',[rfIgnoreCase]);
//        DateStr:=StringReplace(DateStr,'0','',[rfIgnoreCase]);
//      end;
//    end;
  DateStr:=DateStr+'日交易提示';  //DateStr:=DateStr+'日交易提示';
  if (Pos(DateStr,Str)>0) then
    begin
      FTokenType :=ttFont;
      DeleteTokens(FTokenType,Str,Str,1);
      t1:=Pos(DateStr,Str);
      delete(Str,t1,length(Str)-t1+1);
      Str:=ReverseString(Str);
      DateStr:=ReverseString(DateStr);
      n1:=Pos('>"knalb_"=tegrat "',Str);
      n2:=Pos('"=ferh a<',Str);
      Substr:=copy(Str,n1,n2-n1+9);
      Substr:=ReverseString(Substr);
    // Substr:=copy(Str,t1-71,71);
      if Length(Substr)>0  then
        begin
        SubStringReplace('<a href="','',Substr);
        SubStringReplace('" target="_blank">','',Substr);
        SynthesisUrlAddress(TodayHintLst.ReadString('TodayHint_ZZ','URL',''),Substr,URL);
          {if pos('../..',Substr)>0 then
           begin
             t1  := Pos('a href="../..',Substr)+Length('<a href=''../..');
             t2  := Pos('" target="_blank">',Substr);
             //Substr := 'http://www.cs.com.cn/'+Trim(Copy(Substr,t1,t2-t1));
             Substr:=TodayHintLst.ReadString('TodayHint_ZZ','SubUrl1','')+Trim(Copy(Substr,t1,t2-t1)); //更换新网址20080128
           end
         else
           begin
              if Pos('../',Substr)>0 then   //更换新网址20080128
              begin
                t1  := Pos('a href="..',Substr)+Length('<a href=''..');
                t2  := Pos('" target="_blank">',Substr);
                Substr := TodayHintLst.ReadString('TodayHint_ZZ','SubUrl2','')+Trim(Copy(Substr,t1,t2-t1));
              end else
              begin
                t1  := Pos('a href=".',Substr)+Length('<a href=''.');
                t2  := Pos('" target="_blank">',Substr);
                Substr := TodayHintLst.ReadString('TodayHint_ZZ','SubUrl3','')+Trim(Copy(Substr,t1,t2-t1));
              end;  
             //t1  := Pos('a href=".',Substr)+Length('<a href=''.');
//             t2  := Pos('" target="_blank">',Substr);
//              //Substr := 'http://www.cs.com.cn/ssgs/09/'+Trim(Copy(Substr,t1,t2-t1));
           end; }
        end;
    end;
 //Result := Substr;
 Result := URL;
end;


procedure TAMainFrm.RefrsehTime(s: Integer);
begin
  FEndTick := GetTickCount + Round(s*1000);
end;

procedure TAMainFrm.CreateHintFile(Memo:String);
Var
 Str : TStringList;
begin
  Str := nil;
  Try
  Try
    Memo := Trim(Memo);
    Str := TStringList.Create;
    Str.Clear;
    Str.Add(Format('<DATE=%s>',[FormatDateTime('yyyymmdd',Date)]));
    Str.Add('<HINT>');
    if Length(Memo)>0 Then
       Str.Add(Memo);
    Str.Add('</HINT>');
    Str.Add('</DATE>');
    CBDataMgr.SetCBDataText('cbtodayhint.dat',Str.Text);
  Except
  End;
  Finally
    if Assigned(Str) Then
       Str.Free;
  End;
end;

procedure TAMainFrm.SaveToFile(HintStr: String);
Var
  FileName,vLastHintStr,str1,str2 : String;
  f : TStringList;
  j : integer;
  IsContinue:Boolean;
begin
  //將交易提示依照日期保存
  FileName := AppParam.Tr1DBPath +'CBData\TodayHint\'+'ZZ_'+
                   FormatDateTime('yyyymmdd',Date)+'.DAT';
  Mkdir_Directory(ExtractFilePath(FileName));
  f := nil;
  Try
    Try
      f := TStringList.Create;
      IsContinue := false;
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
        {if Trim(vLastHintStr)='无' then
          IsContinue := true;}
      end else
        IsContinue := true;
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
      f.SaveToFile(ExtractFilePath(FileName)+'ZZ_TodayHintIDLst.DAT');
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

{///////////////////////////////////////////////////////////////////////add by Leon 080613
// 从TodayHint.ini配置文件中查找各种类型标识的取得位置的数量；
/////////////////////////////////////////////////////////////////////////
function TAMainFrm.ReadTodayHintCount(FTokenType:TTokenType):integer;
var
  inifile:Tinifile;
  FileName,str:String;
begin
  case FTokenType of
    ttTable : str:='ttTable';
    ttTR    : str:= 'ttTR';
    ttTD    : str:= 'ttTD';
    ttDiv   : str:= 'ttDiv';
   end;
  // FileName:='F:\cndoc\TodayHint.ini';
  FileName := PChar(ExtractFilePath(Application.ExeName))+'TodayHint.ini';
  inifile := Tinifile.Create(FileName);
  result := inifile.ReadInteger(str,'count',0);
  inifile.Free;
end;
/////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////add by Leon 080613
// 从TodayHint.ini配置文件中查找各种类型标识的取得位置；
///////////////////////////////////////////////////////////////////////////
function TAMainFrm.ReadTodayHintContent(FTokenType:TTokenType;Index:integer):integer;
var
  inifile:Tinifile;
  FileName,Str:String;
begin
  case FTokenType of
    ttTable : str:='ttTable';
    ttTR    : str:= 'ttTR';
    ttTD    : str:= 'ttTD';
    ttDiv   : str:= 'ttDiv';
   end;
//   FileName:='F:\cndoc\TodayHint.ini';
  FileName := PChar(ExtractFilePath(Application.ExeName))+'TodayHint.ini';
  inifile := Tinifile.Create(FileName);
  result := inifile.ReadInteger(str,inttostr(Index),0);
  inifile.Free;
end;
//////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////add by Leon 080613
// ;解析网页内容；
////////////////////////////////////////////////////////////////////////////
function TAMainFrm.GetAllText(FTokenType:TTokenType;AStr:String):String;
var
  Acount,AIndex,i : integer;
  ResultStr,OUTputText:String;
begin
  ResultStr:= AStr;
  Acount := ReadTodayHintCount(FTokenType);
  for i:=1 to Acount do
    begin
      AIndex:= ReadTodayHintContent(FTokenType,i);
      GetText(FTokenType,AIndex,ResultStr,OUTputText);
      ResultStr:=OUTputText;
    end;
  result:= ResultStr;
end;
//////////////////////////////////////////////////////////////////////////// }


procedure TAMainFrm.N2Click(Sender: TObject); //Doc_ChinaTodayHint_ZZ Problem081029-- huangcq 081029 --add
begin
  try
    AFrmSetHint_ZZ:=TAFrmSetHint_ZZ.Create(self);
    AFrmSetHint_ZZ.ShowModal;
  finally
    AFrmSetHint_ZZ.Free;
  end;

end;


procedure TAMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
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
  except 
  end;
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

end.
