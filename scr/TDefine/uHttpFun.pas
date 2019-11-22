unit uHttpFun;

interface

uses
  SysUtils, Classes,Forms,IdHTTP,Types,
  WinInet,URLMon, ShellApi,Windows,
  zWininetHttp, zWininetHttpGetFiles;
  //uTCommon,uDefine,TMsg ,
const
  ReadTimeOutStr='Read Time Out';
  SocketErr404Str='404 Not Found';
type
  TDwnHttpStatus=(dwnBegin,//开始信息
                  dwnMsg,//状态信息
                  dwnError,//错误信息
                  dwnEnd,//结束信息
                  dwnSize//下载资料量信息
                  );

  TDwnHttpWMessage =Packed record
    Status     : TDwnHttpStatus;//消息类型
    MsgString  : ShortString;//消息内容
    MaxSize    : Integer;//资料总量
    NowSize    : Integer;//当前接收资料量
    DwnSuccess : Boolean;//是否成功{True:成功,False:失败)
  end;

  TOnDwnHttpMessage = procedure (AMessage:TDwnHttpWMessage)of object;

  TRunHttp=Class(TThread)
  private
     FHTTP: TIdHTTP;
     FURL : String;
     FRunErrMsg: String;
     FRsCode:Integer; //
     FHaveRunFinish: Boolean;
     FRuning:Boolean;
     FResultString: String;
     procedure RunHttp();
     function GetHaveRunFinish: Boolean;
  protected
     procedure Execute; override;
  public
      constructor Create(HTTP: TIdHTTP);
      destructor  Destroy; override;
      procedure SetInit(AUrl:String);
      property RunErrMsg : String read FRunErrMsg;
      property HaveRunFinish : Boolean Read GetHaveRunFinish;
      property ResultString:String Read FResultString;
      property RsCode:Integer Read FRsCode;
      property Runing:Boolean Read FRuning Write FRuning;
  end;


  TDwnHttp=Class(TThread)
  private
     FWininetHttpGetFiles: TzWininetHttpGetFiles;
     FURL   : shortString;
     FRsCode:Integer; //
     FHaveRunFinish: Boolean;
     FRuning:Boolean;
     FRSString: String;
     FStop:Boolean;

     FOnDwnMessage : TOnDwnHttpMessage;

     procedure OnConnected(Sender: TObject);
     procedure OnConnecting(Sender: TObject);
     procedure OnConnectionClosed(Sender: TObject);
     procedure OnConnectionClosing(Sender: TObject);
     procedure OnWininetStatus(Sender:TObject;aStatus:DWORD);
     procedure OnError(Sender:TObject;aError:Cardinal);
     procedure OnReceived(Sender:TObject;ByteReceived:Cardinal);
     procedure OnDocumentCompleted(Sender: TObject);
     procedure OnWorkListFinished(Sender: TObject);


     Procedure InitMessage(Var AMessage:TDwnHttpWMessage);
     Procedure OnDwnBegin();
     Procedure OnDwnMsg(const Msg:String='');
     Procedure OnDwnError(const Msg:String='');
     Procedure OnDwnSize(NowSize:Integer);
     Procedure OnDwnEnd(Success:Boolean);
  protected
     procedure Execute; override;
  public
      constructor Create();
      destructor Destroy; override;

      Procedure SetURL(AURL:shortString;OnDwnMessage:TOnDwnHttpMessage);
      procedure StopConnect();
      Procedure ReStart();

  end;

function  CoCreateGuid(var tGUIDStructure:TGUID):longint; stdcall ;external 'ole32.dll';
Function  Get_GUID8():ShortString;

function GetHtmlTextWithIdHttp(IdHttp:TIdHttp;const TxtUrl: String;var OutText,ErrMsg:String;TimeOut:Integer=60):Boolean;
function GetHtmlText(const TxtUrl: String;var OutText,ErrMsg:String;TimeOut:Integer=60):Boolean;

function DownloadFile(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
function GetHtmlByApi(AURL:shortString;var AResultStr,AErrMsg: string;
         OnDwnMessage:TOnDwnHttpMessage=nil):Boolean;


implementation

function FreeAndNilEx(AObj:TObject;AIgnoreExcept:Boolean=true):String;
begin
  Result := '';
try
  if Assigned(AObj) then
    FreeAndNil(AObj);
except
  on E:Exception do
  begin
    if not AIgnoreExcept then
      Result := E.Message;
    e := nil;
  end;
end;
end;

procedure SleepWait(Const Value:Double);
var
  iEndTick: DWord;
begin
    iEndTick := Round((GetTickCount/1000) + Value);
    repeat
       Application.ProcessMessages;
       Sleep(1);
    until (GetTickCount/1000) >= iEndTick;
End;

Function Get_GUID():ShortString;
var
   vGUID:TGUID;
begin
    If CoCreateGuid(vGUID) = 0 Then Result:=GUIDToString(vGUID);
end;

Function  Get_GUID8():ShortString;
Begin
  Result := Copy(Get_GUID,2,8);
End;

function DownloadFile(AUrl:String; var AResultStr,AErrMsg: string):Boolean;
var
  tmpFile:String;
  ts:TStringList;
begin
try
try
  Result := false;
  AResultStr:= '';
  AErrMsg := '';
  //tmpFile := GetWinTempPath+Get_GUID8+'.txt';
  tmpFile := ExtractFilePath(ParamStr(0))+Get_GUID8+'.txt';
  Result := UrlDownloadToFile(nil, PChar(AUrl),PChar(tmpFile), 0, nil) = 0;
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
  try
    DeleteFile(PChar(tmpFile));
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
  FreeAndNilEx(ts);
end;
end;


function GetHtmlByApi(AURL:shortString;var AResultStr,AErrMsg: string;
         OnDwnMessage:TOnDwnHttpMessage=nil):Boolean;
var
  DwnHttp:TDwnHttp;
  RunSec:Integer;
begin
  Result := false;
  AResultStr := '';
  AErrMsg:='';
  try
  try
    DwnHttp := TDwnHttp.Create();
    DwnHttp.SetURL(AURL,OnDwnMessage);
    DwnHttp.Execute;
    AResultStr := DwnHttp.FRSString;
    if Trim(AResultStr)<>'' then
    begin
      ///ChrConvert(AResultStr);
      Result := true;
    end;
  except
    on e:Exception do
    begin
      AErrMsg:=e.Message;
    end;
  end;
  finally
    try
      DwnHttp.FStop:=true;
      DwnHttp.Terminate;
    except
    end;
    FreeAndNilEx(DwnHttp);
  end;
End;


function GetHtmlTextWithIdHttp(IdHttp:TIdHttp;const TxtUrl: String;var OutText,ErrMsg:String;TimeOut:Integer=60):Boolean;
var
  RunHttp:TRunHttp;
  RunSec:Integer;
begin
  Result := false;
  OutText := '';
  ErrMsg:='';
  try
  try
    RunHttp := TRunHttp.Create(IdHttp);
    RunHttp.SetInit(TxtUrl);
    //RunHttp.Resume;
    RunHttp.Execute;
    RunSec:=0;
    While Not RunHttp.HaveRunFinish do
    Begin
       if Length(RunHttp.RunErrMsg)>0 Then
       Begin
          if ErrMsg<> RunHttp.RunErrMsg Then
            ErrMsg := RunHttp.RunErrMsg;
           exit;
       End Else
          ErrMsg := '';
       SleepWait(1);
       Inc(RunSec);
       if RunSec>TimeOut then
       begin
         ErrMsg:=ReadTimeOutStr;
         exit;
       end;
    End;
    OutText := RunHttp.ResultString;
    if Pos(SocketErr404Str,OutText) > 0  then
    begin
      ErrMsg:=SocketErr404Str;
      exit;
    end;
    ///ChrConvert(OutText);
    Result := true;
  except
    on e:Exception do
    begin
      ErrMsg:=e.Message;
    end;
  end;
  finally
    try
      if RunHttp.Runing then
        RunHttp.Terminate;
    except
    end;
    FreeAndNilEx(RunHttp);
  end;
End;


function GetHtmlText(const TxtUrl: String;var OutText,ErrMsg:String;TimeOut:Integer=60):Boolean;
var
  vIdHttp:TIdHttp;
begin
  vIdHttp:=TIdHttp.Create(nil);
try
  Result:=GetHtmlTextWithIdHttp(vIdHttp,TxtUrl,OutText,ErrMsg,TimeOut);
finally
  FreeAndNilEx(vIdHttp);
end;
end;



//-----------------
{ TRunHttp }

constructor TRunHttp.Create(HTTP: TIdHTTP);
begin
   FHTTP := HTTP;
   FRuning := false;
   FreeOnTerminate := false;
   inherited Create(true);
end;

procedure TRunHttp.SetInit(AUrl:String);
begin
   FRuning := false;
   FHaveRunFinish := false;
   FURL := AUrl;
end;

destructor TRunHttp.Destroy;
begin
  inherited;
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


procedure TRunHttp.RunHttp;
Var
  i : integer;
begin
    FRuning := true;
    FHaveRunFinish := false;
    FResultString := '';
    FRsCode := 404;
Try
    SleepWait(1);
    if Self.Terminated Then exit;
    for i:=0 to 10 do
    Begin
      try
         Try
            FHTTP.Disconnect;
            FHTTP.DisconnectSocket;
         Except
         End;
         Application.ProcessMessages;
         FResultString := FHTTP.Get(FUrl);
         FRsCode := FHTTP.ResponseCode;
         FRunErrMsg := '';
         if Self.Terminated Then exit;
         Break;
      Except
        On E:Exception do
        Begin
           FRsCode := FHTTP.ResponseCode;
           try
             FHTTP.Disconnect;
             FHTTP.DisconnectSocket;
           Except
           End;
           FRunErrMsg := E.Message;
           SleepWait(1);
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
Finally
   Try
      FHTTP.Disconnect;
      FHTTP.DisconnectSocket;
   Except
   End;
   FHaveRunFinish := True;
   FRuning := false;
   Application.ProcessMessages;
End;

end;




{ TDwnHttp }
////////////////////////////////////////////////////////////////////////////////

Procedure TDwnHttp.InitMessage(Var AMessage:TDwnHttpWMessage);
Begin
  With AMessage do
  Begin
    MsgString := '';
    MaxSize := -1;
    NowSize := -1;
    DwnSuccess := false;
  End;
End;

Procedure TDwnHttp.OnDwnBegin();
Var
 AMessage:TDwnHttpWMessage;
Begin
   InitMessage(AMessage);
   AMessage.Status := dwnBegin;
   if assigned(FOnDwnMessage) Then
      FOnDwnMessage(AMessage);
End;

Procedure TDwnHttp.OnDwnMsg(const Msg:String='');
Var
  AMessage:TDwnHttpWMessage;
Begin
   InitMessage(AMessage);
   AMessage.Status := dwnMsg;
   AMessage.MsgString := Msg;
   if assigned(FOnDwnMessage) Then
      FOnDwnMessage(AMessage);
End;

Procedure TDwnHttp.OnDwnError(const Msg:String='');
Var
 AMessage:TDwnHttpWMessage;
Begin
   InitMessage(AMessage);
   AMessage.Status := dwnError;
   AMessage.MsgString := Msg;
   if assigned(FOnDwnMessage) Then
      FOnDwnMessage(AMessage);
End;

Procedure TDwnHttp.OnDwnSize(NowSize:Integer);
Var
 AMessage:TDwnHttpWMessage;
Begin
   InitMessage(AMessage);
   AMessage.Status := dwnSize;
   AMessage.NowSize := NowSize;
   if assigned(FOnDwnMessage) Then
      FOnDwnMessage(AMessage);
End;

Procedure TDwnHttp.OnDwnEnd(Success:Boolean);
Var
  AMessage:TDwnHttpWMessage;
Begin
   InitMessage(AMessage);
   AMessage.Status := dwnEnd;
   AMessage.DwnSuccess := Success;
   if assigned(FOnDwnMessage) Then
      FOnDwnMessage(AMessage);
End;

constructor TDwnHttp.Create();
begin
  FreeOnTerminate := false;
  inherited Create(true);
end;


destructor TDwnHttp.Destroy;
begin
  inherited Destroy;
end;

procedure TDwnHttp.Execute;
const
  DwnTimeOut=4000;
var
  i:Integer;
begin
  FStop := False;
  OnDwnBegin();
  FWininetHttpGetFiles:=TzWininetHttpGetFiles.Create(nil);
try
  FWininetHttpGetFiles.OnConnected:=OnConnected;
  FWininetHttpGetFiles.OnConnecting:=OnConnecting;
  FWininetHttpGetFiles.OnConnectionClosed:=OnConnectionClosed;
  FWininetHttpGetFiles.OnConnectionClosing:=OnConnectionClosing;
  FWininetHttpGetFiles.OnWininetStatus:=OnWininetStatus;
  FWininetHttpGetFiles.OnError:=OnError;
  FWininetHttpGetFiles.OnReceived:=OnReceived;
  FWininetHttpGetFiles.OnDocumentCompleted:=OnDocumentCompleted;
  FWininetHttpGetFiles.OnWorkListFinished:=OnWorkListFinished;
  FWininetHttpGetFiles.OpenURLOptions:=[ouNoCookies,ouRELOAD];

  FWininetHttpGetFiles.RequestFile(FUrl);
  i:=0;
  while not FHaveRunFinish do
  begin
    if (Self.Terminated) or FStop Then
    begin
      StopConnect();
      break;
    end;
    Application.ProcessMessages;
    Sleep(50);
    Inc(i);
    if i>DwnTimeOut then
      break;
  end;
  OnDwnEnd(Trim(FRSString)<>'');
finally
  Try
    FWininetHttpGetFiles.StopRun;
    FWininetHttpGetFiles.OnConnected:=nil;
    FWininetHttpGetFiles.OnConnecting:=nil;
    FWininetHttpGetFiles.OnConnectionClosed:=nil;
    FWininetHttpGetFiles.OnConnectionClosing:=nil;
    FWininetHttpGetFiles.OnWininetStatus:=nil;
    FWininetHttpGetFiles.OnError:=nil;
    FWininetHttpGetFiles.OnReceived:=nil;
    FWininetHttpGetFiles.OnDocumentCompleted:=nil;
    FWininetHttpGetFiles.OnWorkListFinished:=nil;
  Except
  End;
  try
     FWininetHttpGetFiles.Destroy;
  Except
  End;
  FWininetHttpGetFiles   := nil;
end;
end;


procedure TDwnHttp.OnConnected(Sender: TObject);
begin
  OnDwnMsg('connected');
end;

procedure TDwnHttp.OnConnecting(Sender: TObject);
begin
  OnDwnMsg('connecting');
end;

procedure TDwnHttp.OnConnectionClosed(Sender: TObject);
begin
  OnDwnMsg('connection closed');
end;

procedure TDwnHttp.OnConnectionClosing(Sender: TObject);
begin
  OnDwnMsg('connection closing');
end;

procedure TDwnHttp.OnWininetStatus(Sender:TObject;aStatus:DWORD);
begin
  FRsCode:=aStatus;
  OnDwnMsg('status code:'+inttostr(aStatus));
end;

procedure TDwnHttp.OnError(Sender:TObject;aError:Cardinal);
begin
  FRsCode:=aError;
  FHaveRunFinish:=true;
  OnDwnError('error code:'+inttostr(aError));
end;

procedure TDwnHttp.OnReceived(Sender:TObject;ByteReceived:Cardinal);
begin
  OnDwnSize(FWininetHttpGetFiles.StreamSize);
end;

procedure TDwnHttp.OnDocumentCompleted(Sender: TObject);
begin
  FRSString:=FWininetHttpGetFiles.AsText;
  FHaveRunFinish:=true;
  OnDwnMsg('document completed');
end;

procedure TDwnHttp.OnWorkListFinished(Sender: TObject);
begin
  OnDwnMsg('worklist finished');
end;

procedure TDwnHttp.SetURL(AURL: shortString;OnDwnMessage : TOnDwnHttpMessage);
begin
  FURL := AURL;
  FHaveRunFinish:=false;
  FRSString:='';
  FOnDwnMessage := OnDwnMessage;
end;

procedure TDwnHttp.StopConnect();
begin
  FWininetHttpGetFiles.StopRun;
end;


procedure TDwnHttp.ReStart;
begin
   FWininetHttpGetFiles.ResumeRun;
end;

end.
