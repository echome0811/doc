//--DOC4.0.0—N001 huangcq090407 add Doc与WarningCenter整合
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, IdIntercept, IdLogBase, IdLogDebug,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,csDef, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,IniFiles,TCommon,TDocMgr, ImgList,
  CoolTrayIcon,TDwnHttp,TParsePolaNewsHtm,
  TParseHtmTypes,SocketClientFrm,TSocketClasses,
  WinInet,urlmon,ActiveX; //TWarningServer

type

  TTitleR2 = Packed record
    Caption : String[100];//标题
    Address : String[100];//地址
    Memo    : String;
    TitleDate : Double;//日期
    needsave: Boolean;
  end;

  TTitleRLst2 = array of TTitleR2;

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
    Timer_StartGetDoc: TTimer;
    PanelCaption_URL: TPanel;
    CoolTrayIcon: TCoolTrayIcon;
    ImageList1: TImageList;
    Count_Lbl: TLabel;
    Label2: TLabel;
    TimerSendLiveToDocMonitor: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure LogDebugLogItem(ASender: TComponent; var AText: String);
    procedure Timer_StartGetDocTime(Sender: TObject);
    procedure CoolTrayIconDblClick(Sender: TObject);
    procedure TimerSendLiveToDocMonitorTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

    FDataPath : String;
    FDocPath  : String;
    FLogFileName : String;
    FTempDocFileName : String;
    FNowIsRunning: Boolean;
    StopRunning : Boolean;
    FDwnSuccess :Boolean;
    FDwnEnd :Boolean;
    DisplayMsg : TDisplayMsg;
    DocDataMgr : TDocDataMgr;
    FEndTick : DWord;
    AppParam : TDocMgrParam;
    ParsePolaNewsHtmMgr:TParsePolaNewsHtmMgr;

    FStopRunningSkt : Boolean; //--DOC4.0.0—N001 huangcq090407 add
    ASocketClientFrm : TASocketClientFrm; //--DOC4.0.0—N001 huangcq090407 add
    procedure SendDocMonitorStatusMsg;//--DOC4.0.0—N001 huangcq090407 add
    function SendDocMonitorWarningMsg(const Str: String): boolean;//--DOC4.0.0—N001 huangcq090407 add
    procedure Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);//--DOC4.0.0—N001 huangcq090407 add    

    procedure SetNowIsRunning(const Value: Boolean);
  private
    { Private declarations }
    property NowIsRunning:Boolean Read FNowIsRunning Write SetNowIsRunning;

    function  StartGetDocTitle():Boolean;
    Procedure OnDwnHttpMessage(AMessage:TDwnHttpWMessage);

    Function UpdatePages(Str:String):Boolean;
    function GetIDList(Const Txt:String):string;
    procedure ShowRunBar(const Max,NowP:Integer;Const Msg:String);

  public
    { Public declarations }
    FDocDate:TDateTime;  //add by wjh 20110824 4.1.9.2
    procedure InitObj();
    procedure ShowURL(const msg:String);
    procedure ShowMsg(const Msg:String);
    procedure SaveMsg(const Msg:String);
    procedure Start();
    procedure Stop();
    procedure InitForm();
  end;

var
  AMainFrm: TAMainFrm;

implementation

{$R *.dfm}

function GetHTMLFile(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
var
  tmpFile:String;
  ts:TStringList;
  status : IBindStatusCallback ;
begin
try
try
  Result := false;
  ts:=nil;
  AErrMsg := '';AResultStr:='';
  tmpFile := GetWinTempPath+Get_GUID8+'.dat';
  DeleteUrlCacheEntry(PChar(AUrl));
  //status := IBindStatusCallback(self); //設定。
  //Result := UrlDownloadToFile(nil, PChar(AUrl),PChar(tmpFile), 0,Status) = 0;
  Result := UrlDownloadToFile(nil, PChar(AUrl),PChar(tmpFile), 0,nil) = 0;
  if not FileExists(tmpFile) then
  begin
    Result := false;
    exit;
  end;
  ts := TStringList.Create;
  ts.LoadFromFile(tmpFile);
  AResultStr := ts.Text;
  try
    if Assigned(ts) then
      FreeAndNil(ts);
  except
  end;
  try
    //DeleteFile(tmpFile);
  except
  end;  
except
  on e:Exception do
  begin
    Result := false;
    AErrMsg := e.Message;
    e := nil;
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


procedure TAMainFrm.InitForm;
begin

  AppParam := TDocMgrParam.Create;

  FDataPath := ExtractFilePath(Application.ExeName)+'Data\';
  FDocPath  := '';

  Mkdir_Directory(FDataPath);
  Mkdir_Directory(FDocPath);

  FTempDocFileName := FDataPath+'Doc_01.tmp';

  FLogFileName := 'Doc_01';

  Timer_StartGetDoc.Enabled := True;
  NowIsRunning := false;
  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;

  Label1.Caption :=appParam.ConvertString('台湾新闻收集工具(包含拟发公告)');
  Caption :=appParam.ConvertString('台湾新闻收集工具(包含拟发公告)');


  //ConnectToSoundServer(AppParam.SoundServer,AppParam.SoundPort);//--DOC4.0.0—N001 huangcq090407 del
  //--DOC4.0.0—N001 huangcq090407 add------>
  FStopRunningSkt := False;
  ASocketClientFrm := TASocketClientFrm.Create(Self,'Doc_01_TW',AppParam.DocMonitorHostName
                                            ,AppParam.DocMonitorPort,Msg_ReceiveDataInfo);

  TimerSendLiveToDocMonitor.Interval := 3000;
  TimerSendLiveToDocMonitor.Enabled  := True;
  //<------DOC4.0.0—N001 huangcq090407 add----
end;

procedure TAMainFrm.FormCreate(Sender: TObject);
begin
   InitForm;
   InitObj;
   btnGo.Click;
   show; 
end;

procedure TAMainFrm.Start;
begin
   FDwnEnd:=false;
   FDwnSuccess:=false;
   StopRunning := False;
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
      ShowMsg(appParam.ConvertString('台湾新闻收集工具(包含拟发公告)'));
   End;

end;

procedure TAMainFrm.btnGoClick(Sender: TObject);
begin
   Start;
end;

procedure TAMainFrm.Stop;
begin
   StopRunning := True;
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

{
function TAMainFrm.StartGetDocTitle():boolean;
var
  Response,DocExist:TStringList;
  AllPage,NowPage ,nowcount,lastcount: Integer;
  Url,ResultStr,sErrMsg : String;
  i : integer;
  ADoc : TDocData;
  TxtMemo,MemoTxt ,FileName: String;
  index:integer;                    
  TitleRA:TTitleRLst;
  TitleRA2:TTitleRLst2;
  inifile :Tinifile;
begin
  Result := false;
  if StopRunning Then exit;
  if Response<>nil Then
    Response.Free;
  Response := nil;
  Response :=TStringList.Create;

  try
  try
    //Url := 'http://www.yuanta.com.tw/pages/content/Frame.aspx?Node=9d7c6e39-de01-41ee-a4b1-f0b6b1f4ac87';
    Url := 'http://jdata.yuanta.com.tw/z/zf/zf_H_E.djhtm';
    ShowURL(URL);
    if GetHTMLFile(Url,ResultStr,sErrMsg) then
      ShowMsg(AppParam.ConvertString('正在下载标题页面'))
    else
    begin
      ShowMsg(AppParam.ConvertString('下载标题fail.')+sErrMsg);
      exit;
    end;
    if StopRunning Then Exit;
    Response.text:=sErrMsg;
    if(Response.Count>0)then
    Begin
      ShowMessage(Response.Text);
      AddTextToFile(ExtractFilePath(ParamStr(0))+'log.log','+++++++++'+#13#10+Response.Text);
      if not UpdatePages(Response.Text) then exit;
      ShowMessage('1');
      SetLength(TitleRA,ParsePolaNewsHtmMgr._GetNowPageTitlesCount(Response.Text));
      ShowMessage('2');
      if not ParsePolaNewsHtmMgr._GetNowPageTitles(TitleRA) then
      begin
         ShowMsg(ParsePolaNewsHtmMgr._GetLastErrorMsg);
         exit;
      end;
      Count_Lbl.Caption :=AppParam.ConvertString('当前新闻总数['+IntToStr(High(TitleRA)+1)+']         ');

      ///////////////////////////////////////////////////////////////////
      DocExist:=TStringlist.Create;
      inifile:=TiniFile.Create(ExtractFilePath(application.ExeName)+'setup.ini');
      FileName:=inifile.ReadString('Doc_01_TW','NewsPath','c:\')+FormatDateTime('yyyymmdd',date)+'.News';
      inifile.Free;

      if FileExists(FileName)then
        DocExist.LoadFromFile(FileName);

      SetLength(TitleRA2,0);
      for i:=0 to High(TitleRA) do
      begin
        if(Pos(TitleRA[i].Caption,DocExist.Text)=0)or
          (Pos(TitleRA[i].Address,DocExist.Text)=0)then
        begin
          SetLength(TitleRA2,High(TitleRA2)+2);
          TitleRA2[High(TitleRA2)].Caption:=TitleRA[i].Caption;
          TitleRA2[High(TitleRA2)].Address:=TitleRA[i].Address;
          TitleRA2[High(TitleRA2)].TitleDate:=TitleRA[i].TitleDate;
          TitleRA2[High(TitleRA2)].Memo:='NONE';
        end;
      end;

      for i:=0 to High(TitleRA2) do
      begin
        ShowRunBar(High(TitleRA2)+1,i+1,IntToStr(i+1)+'/'+IntToStr(High(TitleRA2)+1));
        if StopRunning Then Break;
        StatusBar1.Panels[1].Text := IntToStr(i+1)+'/'+IntToStr(High(TitleRA2)+1);
        application.ProcessMessages;

        ShowMsg(TitleRA2[i].Caption);
        SaveMsg(TitleRA2[i].Caption);

        Response.Text:='';
        FDwnEnd:=false;
        FDwnSuccess:=false;
        _InitDwnHttp(1);
        index:=_GetHttpTxt(PChar(String(TitleRA2[i].Address)),Response,OnDwnHttpMessage);
        if (index=-1)then
          break;

        while not FDwnEnd do
        begin
          if StopRunning Then
          Begin
              _FreeHttpTxt;
              Exit;
          End;
          Application.ProcessMessages;
          Sleep(1);
        end;
        if (index<>-1)then
        begin
          _StopConnect(index);
          _FreeHttpTxt;
        end;

        if(FDwnSuccess)and (Response.Count>0)then
        begin
          MemoTxt:=Response.Text;
          ParsePolaNewsHtmMgr._GetHtmlMemo(MemoTxt);

          //Process the special_char
          ReplaceSubString('∽ ','=',MemoTxt);
          ReplaceSubString('⊙','*',MemoTxt);
          ReplaceSubString('∠','+',MemoTxt);
          ReplaceSubString('','',MemoTxt);

          TitleRA2[i].Memo:=MemoTxt;

          ADoc :=DocDataMgr.AddADoc(TitleRA2[i].Caption,'NONE','NONE',TitleRA2[i].TitleDate,0,TitleRA2[i].Address);
          if  ADoc=nil Then
          Begin
              Result := false;
              Break;
          End;
          DocDataMgr.SetADocMemo(ADoc,MemoTxt);
          DocDataMgr.SetADocID(ADoc,GetIDList(MemoTxt));

        end

      end;
      ////////////////////////////////////////////////////////////////////
      //save all news
      for i:=0 to High(TitleRA2) do
      begin
        if TitleRA2[i].Memo<>'NONE' then
        begin
         DocExist.Add('<CAPTION>');
         DocExist.Add(TitleRA2[i].Caption);
         DocExist.Add('</CAPTION>');

         DocExist.Add('<ADDRESS>');
         DocExist.Add(TitleRA2[i].Address);
         DocExist.Add('</ADDRESS>');

         DocExist.Add('<MEMO>');
         DocExist.Add(TitleRA2[i].Memo);
         DocExist.Add('</MEMO>');
        end;
      end;
      DocExist.SaveToFile(FileName);

      //save pbulish news
      DocDataMgr.SaveToTempDocFile_News_TW;
      DocDataMgr.ClearData;

    End Else
    begin
      ShowMsg(AppParam.ConvertString('标题页面下载失败'));
      Exit;
    end;

    Result := True;
  Except
     On E:Exception do
     Begin
         ShowMsg(E.Message);
         SaveMsg(E.Message);
         SendDocMonitorWarningMsg(AppParam.ConvertString('台湾新闻下载过程出现错误')+'('+E.Message+')$E002');//--DOC4.0.0—N001 huangcq090407 add
     End;
  End;
  finally
      ShowURL('');
      ShowMsg(AppParam.ConvertString('一轮下载已完成，等待下轮'));
      StatusBar1.Panels[1].Text := '';
      StatusBar1.Panels[2].Text:= '';
      if Response<>nil Then
         Response.Free;
      if Assigned(DocExist) Then
      begin
         DocExist.Clear;
         DocExist.Free;
      end;
  end;
End; }

function TAMainFrm.StartGetDocTitle():boolean;
var
  Response,DocExist:TStringList;
  AllPage,NowPage ,nowcount,lastcount: Integer;
  Url,ResultStr : String;
  i : integer;
  ADoc : TDocData;
  TxtMemo,MemoTxt ,FileName: String;
  index:integer;                    
  TitleRA:TTitleRLst;
  TitleRA2:TTitleRLst2;
  inifile :Tinifile;
begin

  Result := false;

  FDwnEnd:=false;
  FDwnSuccess:=false;
  if StopRunning Then exit;
  _FreeHttpTxt;
  if Response<>nil Then
    Response.Free;
  Response := nil;
  Response :=TStringList.Create;

  try
  try
    //Url := 'http://www.yuanta.com.tw/pages/content/Frame.aspx?Node=9d7c6e39-de01-41ee-a4b1-f0b6b1f4ac87';
    Url := 'http://jdata.yuanta.com.tw/z/zf/zf_H_E.djhtm';
    //Url := 'http://demand.polaris.com.tw/z/zf/zf_H_E.asp.htm';
    ShowURL(URL);

    _InitDwnHttp(1);
    index:=_GetHttpTxt(PChar(Url),Response,OnDwnHttpMessage);
    if (index<>-1)then
      ShowMsg(AppParam.ConvertString('正在下载标题页面'))
    else
    begin
      ShowMsg(AppParam.ConvertString('下载标题fail'));
      exit;
    end;

    while not FDwnEnd do
    begin
      if StopRunning Then
      Begin
          _FreeHttpTxt;
          Exit;
      End;
      Application.ProcessMessages;
      Sleep(1);
    end;
    if (index<>-1)then
    begin
      _StopConnect(index);
      _FreeHttpTxt;
    end;

    if StopRunning Then Exit;

    if(FDwnSuccess)and (Response.Count>0)then
    Begin
      //ShowMessage(Response.Text);
      //AddTextToFile(ExtractFilePath(ParamStr(0))+'log.log','+++++++++'+#13#10+Response.Text);
      if not UpdatePages(Response.Text) then exit;
      //ShowMessage('1');
      SetLength(TitleRA,ParsePolaNewsHtmMgr._GetNowPageTitlesCount(Response.Text));
      //ShowMessage('2');
      if not ParsePolaNewsHtmMgr._GetNowPageTitles(TitleRA) then
      begin
         ShowMsg(ParsePolaNewsHtmMgr._GetLastErrorMsg);
         exit;
      end;
      Count_Lbl.Caption :=AppParam.ConvertString('当前新闻总数['+IntToStr(High(TitleRA)+1)+']         ');

      ///////////////////////////////////////////////////////////////////
      DocExist:=TStringlist.Create;
      inifile:=TiniFile.Create(ExtractFilePath(application.ExeName)+'setup.ini');
      FileName:=inifile.ReadString('Doc_01_TW','NewsPath','c:\')+FormatDateTime('yyyymmdd',date)+'.News';
      inifile.Free;

      if FileExists(FileName)then
        DocExist.LoadFromFile(FileName);

      SetLength(TitleRA2,0);
      for i:=0 to High(TitleRA) do
      begin
        if(Pos(TitleRA[i].Caption,DocExist.Text)=0)or
          (Pos(TitleRA[i].Address,DocExist.Text)=0)then
        begin
          SetLength(TitleRA2,High(TitleRA2)+2);
          TitleRA2[High(TitleRA2)].Caption:=TitleRA[i].Caption;
          TitleRA2[High(TitleRA2)].Address:=TitleRA[i].Address;
          TitleRA2[High(TitleRA2)].TitleDate:=TitleRA[i].TitleDate;
          TitleRA2[High(TitleRA2)].Memo:='NONE';
        end;
      end;

      for i:=0 to High(TitleRA2) do
      begin
        ShowRunBar(High(TitleRA2)+1,i+1,IntToStr(i+1)+'/'+IntToStr(High(TitleRA2)+1));
        if StopRunning Then Break;
        StatusBar1.Panels[1].Text := IntToStr(i+1)+'/'+IntToStr(High(TitleRA2)+1);
        application.ProcessMessages;

        ShowMsg(TitleRA2[i].Caption);
        SaveMsg(TitleRA2[i].Caption);

        Response.Text:='';
        FDwnEnd:=false;
        FDwnSuccess:=false;
        _InitDwnHttp(1);
        index:=_GetHttpTxt(PChar(String(TitleRA2[i].Address)),Response,OnDwnHttpMessage);
        if (index=-1)then
          break;

        while not FDwnEnd do
        begin
          if StopRunning Then
          Begin
              _FreeHttpTxt;
              Exit;
          End;
          Application.ProcessMessages;
          Sleep(1);
        end;
        if (index<>-1)then
        begin
          _StopConnect(index);
          _FreeHttpTxt;
        end;

        if(FDwnSuccess)and (Response.Count>0)then
        begin
          MemoTxt:=Response.Text;
          ParsePolaNewsHtmMgr._GetHtmlMemo(MemoTxt);

          //Process the special_char
          ReplaceSubString('∽ ','=',MemoTxt);
          ReplaceSubString('⊙','*',MemoTxt);
          ReplaceSubString('∠','+',MemoTxt);
          ReplaceSubString('','',MemoTxt);

          TitleRA2[i].Memo:=MemoTxt;

          ADoc :=DocDataMgr.AddADoc(TitleRA2[i].Caption,'NONE','NONE',TitleRA2[i].TitleDate,0,TitleRA2[i].Address);
          if  ADoc=nil Then
          Begin
              Result := false;
              Break;
          End;
          DocDataMgr.SetADocMemo(ADoc,MemoTxt);
          DocDataMgr.SetADocID(ADoc,GetIDList(MemoTxt));
        end

      end;
      ////////////////////////////////////////////////////////////////////
      //save all news
      for i:=0 to High(TitleRA2) do
      begin
        if TitleRA2[i].Memo<>'NONE' then
        begin
         DocExist.Add('<CAPTION>');
         DocExist.Add(TitleRA2[i].Caption);
         DocExist.Add('</CAPTION>');

         DocExist.Add('<ADDRESS>');
         DocExist.Add(TitleRA2[i].Address);
         DocExist.Add('</ADDRESS>');

         DocExist.Add('<MEMO>');
         DocExist.Add(TitleRA2[i].Memo);
         DocExist.Add('</MEMO>');
        end;
      end;
      DocExist.SaveToFile(FileName);

      //save pbulish news
      DocDataMgr.SaveToTempDocFile_News_TW;
      DocDataMgr.ClearData;
    End Else
    begin
      ShowMsg(AppParam.ConvertString('标题页面下载失败'));
      Exit;
    end;

    Result := True;
  Except
     On E:Exception do
     Begin
         ShowMsg(E.Message);
         SaveMsg(E.Message);
         //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError); //--DOC4.0.0—N001 huangcq090407 del
         SendDocMonitorWarningMsg(AppParam.ConvertString('台湾新闻下载过程出现错误')+'('+E.Message+')$E002');//--DOC4.0.0—N001 huangcq090407 add
     End;
  End;
  finally
      ShowURL('');
      ShowMsg(AppParam.ConvertString('一轮下载已完成，等待下轮'));
      StatusBar1.Panels[1].Text := '';
      StatusBar1.Panels[2].Text:= '';
      if Response<>nil Then
         Response.Free;

      if Assigned(DocExist) Then
      begin
         DocExist.Clear;
         DocExist.Free;
      end;
      _FreeHttpTxt;
  end;
End;


procedure TAMainFrm.LogDebugLogItem(ASender: TComponent;
  var AText: String);
begin
   Application.ProcessMessages;
end;

//--DOC4.0.0—N001 huangcq090407 add----------->
procedure TAMainFrm.SendDocMonitorStatusMsg;
begin

  if ASocketClientFrm<>nil Then
  Begin
     ASocketClientFrm.SendText('SendTo=DocMonitor;'+
                                'Message=Doc_01_TW;'
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
begin

   Timer_StartGetDoc.Enabled := False;

Try
  if (Time>=EncodeTime(00,30,00,00)) and (Time<=EncodeTime(23,50,00,00)) then
  begin
    if GetTickCount >= FEndTick Then
    Begin
      if NowIsRunning Then
      Begin
        DocDataMgr.ClearData;
        DocDataMgr.LoadFromNotMemoDocLogFile('NONEDoc1');
        DocDataMgr.LoadFromEndReadDocLogFile('NONEDoc1');
        if StartGetDocTitle Then
          FEndTick := GetTickCount + Round(5*60*1000)
        Else
          FEndTick := GetTickCount + Round(5000);
      End;
    End;
  end;
Finally
   ShowRunBar(0,0,'');
   if StopRunning Then
      NowIsRunning := false;
   Timer_StartGetDoc.Enabled := True;
End;

end;

{ TDisplayMsg }

procedure TDisplayMsg.AddMsg(const Msg: String);
begin

    FMsg.Caption := Msg;

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
   DocDataMgr := TDocDataMgr.Create(FTempDocFileName,FDocPath);
   ParsePolaNewsHtmMgr:=TParsePolaNewsHtmMgr.Create;
end;

procedure TAMainFrm.ShowRunBar(const Max, NowP: Integer; const Msg: String);
var iMax:integer;
begin
    if Max<0 then iMax:=0
    else iMax:=Max;
    ProgressBar1.Max := iMax;
    ProgressBar1.Min := 0;
    ProgressBar1.Position := NowP;

    //StatusBar1.Panels[1].Text := Msg;
    //StatusBar1.Panels[2].Text := DateToStr(Date);

    Application.ProcessMessages; 

end;

procedure TAMainFrm.ShowURL(const msg: String);
begin
  SaveMsg(msg); 
  PanelCaption_URL.Caption := msg;
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
            if isInteger(PChar(ID))and (Length(ID)>2) Then
                Result := Result + ID + ',';
          End;
       end;
   End;

end;

procedure TAMainFrm.CoolTrayIconDblClick(Sender: TObject);
begin
  Self.Show;
end;

procedure TAMainFrm.OnDwnHttpMessage(AMessage: TDwnHttpWMessage);
begin

Try

  Case  AMessage.Status of
    dwnBegin : Begin
       ShowRunBar(AMessage.MaxSize,0,'');
    End;
    dwnMsg : Begin
         StatusBar1.Panels[2].Text:= AMessage.MsgString;
    End;
    dwnError : Begin
         StatusBar1.Panels[2].Text := AMessage.MsgString;
         SendDocMonitorWarningMsg(AppParam.ConvertString('台湾新闻下载过程出现错误')+'('+AMessage.MsgString+')$E002');//--DOC4.0.0—N001 huangcq090407 add
    End;
    dwnSize : Begin
       //ShowRunBar(AMessage.MaxSize,AMessage.NowSize,'');
    End;
    dwnEnd : Begin
        FDwnEnd :=true;
        FDwnSuccess := AMessage.DwnSuccess;
    End;
  End;
Except
end;

end;


//voerride by wjh 20110824 4.1.9.2
function TAMainFrm.UpdatePages(Str:String): Boolean;
var dateStr,t:string;
  ts:TStringList;
begin
  result:=false;
  ts:=nil;
  ts:=TStringList.Create;
try
try
  dateStr:=Copy(Str,Pos(CGBToBIG5('日期:'),Str)+Length('日期:'),9);
  ts.Delimiter := '/';
  ts.DelimitedText := dateStr;
  if ts.count=3 then
  t:= Format('%d%s%s%s%s',[
  StrToInt('1911')+StrToInt(ts[0]), DateSeparator,
  ts[1], DateSeparator,ts[2]
  ]) ;

  Label2.Caption:=AppParam.ConvertString('当前页面日期：')+t+'                 ';
  if StrToDate(t)=Date then
  begin
    FDocDate := StrToDate(t);
    result:=true;
  end;
except
end;
finally
  try if Assigned(ts) then FreeAndNil(ts); except end;
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

end.
