unit uDwnHttp;

interface
  Uses Forms,Classes,IdHTTP,IdComponent,SysUtils,TCommon,TDwnHttp;

type

  TDwnHttp=Class(TThread)
  private

     FIndex : Integer;
     FHTTP  : TIdHTTP;
     FURL   : shortString;
     FBeUse : Boolean;

     FHaveRunFinish: Boolean;
     FWorkMax:integer;
     FStrLst:TStringList;

     FOnDwnMessage : TOnDwnHttpMessage;
     FStop : Boolean;
     FExecute : Boolean;


     procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode;const AWorkCount: Integer);
     procedure HTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;const AWorkCountMax: Integer);
     procedure HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
     procedure HTTPStatus(axSender: TObject;const axStatus: TIdStatus; const asStatusText: String);

     //procedure LogDebugLogItem(ASender: TComponent; var AText: String);

     Procedure InitMessage(Var AMessage:TDwnHttpWMessage);
     Procedure OnDwnBegin();
     Procedure OnDwnMsg(const Msg:String='');
     Procedure OnDwnError(const Msg:String='');
     Procedure OnDwnSize(MaxSize,NowSize:Integer);
     Procedure OnDwnEnd(Success:Boolean);


  protected
     procedure Execute; override;
  public
      constructor Create(index:Integer);
      destructor Destroy; override;

      Procedure SetURL(AURL:shortString;OnDwnMessage : TOnDwnHttpMessage;Var AStrLst:TStringList);

      procedure StopConnect();
      Procedure ReStart();

  end;

  //export interface
  Function _GetHttpTxt(AURL:PChar;Var AStrLst:TStringList;AOnDwnHttpMessage:TOnDwnHttpMessage):integer;
  function _StopConnect(index:integer):Boolean;
  procedure _ReleaseHttpTxt(index:integer);
  procedure _FreeHttpTxt();
  Procedure _InitDwnHttp(Count:Integer);
  Function  _GetDwnHttp():TDwnHttp;

Var
 FDwnThreadLst : Array of TDwnHttp;
 GProxyEnable:boolean=False;
 GProxSvr:ShortString;
 GProxPort:integer;


implementation

Function  _GetDwnHttp():TDwnHttp;
Var
 i : Integer;
Begin

  Result := nil;
  For i:=0 to High(FDwnThreadLst) Do
  Begin
    if (Not FDwnThreadLst[i].FBeUse)  and
       (FDwnThreadLst[i].FStop)  Then
    Begin
      Result := FDwnThreadLst[i];
      Result.FBeUse := True;
      Break;
    End;
  End;

End;

Procedure _InitDwnHttp(Count:Integer);
Var
 i : Integer;
Begin
  SetLength(FDwnThreadLst,Count);
  For i:=0 to High(FDwnThreadLst) Do
  Begin
    FDwnThreadLst[i] := TDwnHttp.Create(i);
    FDwnThreadLst[i].Resume;
    While Not FDwnThreadLst[i].FExecute Do
       Application.ProcessMessages;
  End;
End;

procedure _FreeHttpTxt();
Var
 i : Integer;
Begin



  For i:=0 to High(FDwnThreadLst) Do
  Begin
    Try
     //Application.ProcessMessages;
     if Assigned(FDwnThreadLst[i]) Then
     Begin
        FDwnThreadLst[i].Terminate;
        //if FDwnThreadLst[i].Suspended Then
        //   FDwnThreadLst[i].Resume;
        FDwnThreadLst[i].WaitFor;
        FDwnThreadLst[i].Destroy;
     End;
    Except
    End;
  End;

  SetLength(FDwnThreadLst,0);

  



End;

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

Procedure TDwnHttp.OnDwnSize(MaxSize,NowSize:Integer);
Var
 AMessage:TDwnHttpWMessage;
Begin

   InitMessage(AMessage);
   AMessage.Status := dwnSize;
   AMessage.MaxSize := MaxSize;
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

constructor TDwnHttp.Create(Index:Integer);
begin
  FIndex := Index;
  FBeUse := False;
  FreeOnTerminate := false;
  FExecute := false;
  inherited Create(true);
end;

destructor TDwnHttp.Destroy;
begin
  inherited;
end;

procedure TDwnHttp.Execute;
begin

  FStop := True;
  FExecute := True;
  While True do
  Begin
    try
      While FStop Do
      Begin
             if (Self.Terminated) Then
                 FStop := False;
             Application.ProcessMessages;
             Sleep(50);
      End;
      if (Self.Terminated) Then
          Break;

      OnDwnBegin();

      FHTTP:=TIdHTTP.Create(nil);
      FHTTP.Request.ContentType := 'text/html; charset=gb2312';
      FHTTP.HandleRedirects:=true; //add by wangjinhua 4.16 - Problem(20100716)

      FHttp.OnWork:= HTTPWork;
      FHttp.OnWorkBegin:= HTTPWorkBegin;
      FHttp.OnWorkEnd:= HTTPWorkEnd;
      FHttp.OnStatus:= HTTPStatus;

      FHaveRunFinish:=false;
      Try
         FHttp.ReadTimeout := 60000;
         FHttp.ConnectTimeout := 10000;
         FStrLst.Text := FHTTP.Get(FURL);
         if Not Self.Terminated Then
           FHaveRunFinish:=true;
      Except
        on e:Exception do
        begin
         if Not Self.Terminated Then
           OnDwnError(e.Message);
        end;
      End;


      Try
      FHttp.Request.Clear;
      FHttp.OnWork     := nil;
      FHttp.OnWorkBegin:= nil;
      FHttp.OnWorkEnd  := nil;
      FHttp.OnStatus   := nil;
      Except
      End;
      try
         FHTTP.Destroy;
      Except
      End;

      FHTTP   := nil;
      FStrLst := nil;
      FURL    := '';

      //發現一種奇怪的錯
      //如果線程執行太多太快可能會導致Suspend失效
      //但如果Break一下可以避免
      //Sleep(50);

      FStop := True; //要先暫停
      OnDwnEnd(FHaveRunFinish); //然後通知結束

      //if (Not Self.Terminated) Then
      //   Self.Suspend
      //Else
      //   Break;

      //if Self.Terminated Then
      //   Break;
    except
    end;
  End;

end;

{
procedure TDwnHttp.LogDebugLogItem(ASender: TComponent; var AText: String);
begin
  OnDwnMsg(AText);
end;
}


procedure TDwnHttp.HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin

  OnDwnSize(FWorkMax,AWorkCount);

end;

procedure TDwnHttp.HTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin

  FWorkMax:=AWorkCountMax;
  OnDwnSize(FWorkMax,0);
end;

procedure TDwnHttp.HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin

  OnDwnSize(FWorkMax,FWorkMax);

end;

procedure TDwnHttp.HTTPStatus(axSender: TObject; const axStatus: TIdStatus;
  const asStatusText: String);
begin

  OnDwnMsg(asStatusText);

end;

procedure TDwnHttp.StopConnect;
begin

  try
    if Assigned(FHttp) Then
    Begin
       FHttp.OnWork:= nil;
       FHttp.OnWorkBegin:= nil;
       FHttp.OnWorkEnd:= nil;
       FHttp.OnStatus:= nil;
       if FHttp.Connected Then
          FHttp.DisconnectSocket;
    End;
  except
    {
    on e:Exception do
    begin
      if Assigned(OnError)then
        OnError(e.Message);
      Exit;
    end;
    }
  end;

end;

////////////////////////////////////////////////////////////////////////////////
//interface
Function _GetHttpTxt(AURL:PChar;Var AStrLst:TStringList;AOnDwnHttpMessage:TOnDwnHttpMessage):Integer;
Var
 ADwnObj : TDwnHttp;
begin

Try

  Result := -1;

  ADwnObj := _GetDwnHttp;
  if Assigned(ADwnObj) Then
  Begin
     ADwnObj.SetURL(AURL,AOnDwnHttpMessage,AStrLst);
     Result := ADwnObj.FIndex;
     ADwnObj.ReStart; 
  End;

Except
  Result := -1;
End;

end;

procedure _ReleaseHttpTxt(index:integer);
Begin
try
  if Assigned(FDwnThreadLst[index]) Then
       FDwnThreadLst[index].FBeUse := False;
except
end;
End;

function _StopConnect(Index : Integer):Boolean;
Begin

  Result := False;
try
  if Assigned(FDwnThreadLst[index]) Then
  Begin

    if FDwnThreadLst[index].FStop or
       (Not FDwnThreadLst[index].FBeUse) Then
       Result := True;
    if FDwnThreadLst[index].FBeUse Then
       FDwnThreadLst[index].StopConnect;
  End;
except
end;

End;

////////////////////////////////////////////////////////////////////////////////


procedure TDwnHttp.SetURL(AURL: shortString;OnDwnMessage : TOnDwnHttpMessage; var AStrLst: TStringList);
begin
  FURL := AURL;
  FOnDwnMessage := OnDwnMessage;
  FStrLst:=AStrLst;
  FStrLst.Clear;
end;






procedure TDwnHttp.ReStart;
begin
   FStop := False;
end;




initialization
begin
  Application.OnException:=nil;
  GetWin_ProxyEnable(GProxyEnable,GProxSvr,GProxPort);
end;

end.





