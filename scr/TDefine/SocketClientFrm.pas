unit SocketClientFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,TSocketClasses, ScktComp,TCommon, StdCtrls;



Type 
  TOnWM_ReceiveDataInfo=Procedure(ObjWM : PWMReceiveString) of Object;


  TAnalyzeReceiveMsgMgr=class(TThread)
    private
       FOnWM_ReceiveDataInfo : TOnWM_ReceiveDataInfo;
       FManagerReceiveString : TManagerReceiveString;
       Procedure SendWMReceiveString;
    protected
       procedure Execute; override;
    public
      constructor Create(ManagerReceiveString : TManagerReceiveString;
                         OnWM_ReceiveDataInfo : TOnWM_ReceiveDataInfo);
      destructor  Destroy; override;
  End;

  TASocketClientFrm = class
  private
    { Private declarations }
    TimerOpenSocket: TTimer;
    ClientSocket1: TClientSocket;

    FHandle : HWND;
    FOnWM_ReceiveDataInfo : TOnWM_ReceiveDataInfo;
    FManagerReceiveString : TManagerReceiveString;
    FAnalyzeReceiveMsgMgr : TAnalyzeReceiveMsgMgr;
    FPort : Integer;
    FHost : String;
    FAppID : String;
    FBufferText : String;
    StopRunning : Boolean;
    FConnected  : Boolean;

    procedure TimerOpenSocketTimer(Sender: TObject);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);

    procedure SendWMReceiveString();

    procedure OpenClientSocketConnect();
    procedure CloseClientSocketConnect();
    procedure SendToServerConnectInfo();

    procedure RefreshBudfferText();

    procedure OpenShow();

  public
    { Public declarations }
    constructor Create(AOwner: TComponent;
                     Const AppID,AHost:String;Const APort:Integer;
                     OnWM_ReceiveDataInfo : TOnWM_ReceiveDataInfo);
    procedure   ClearObj();

    function  SendText(Const Value:String):boolean;
    procedure SendTextToBuffer(Const Value:String);
    procedure SendToServerLiveInfo();

  end;

implementation

{ TASocketClient }
constructor TASocketClientFrm.Create(AOwner: TComponent;
  Const AppID,AHost:String;const APort: Integer;
  OnWM_ReceiveDataInfo : TOnWM_ReceiveDataInfo);
begin

  //inherited Create(AOwner);

  ClientSocket1 := TClientSocket.Create(nil);
  ClientSocket1.OnError := ClientSocket1Error;
  ClientSocket1.OnConnect := ClientSocket1Connect;
  ClientSocket1.OnDisconnect := ClientSocket1Disconnect;
  ClientSocket1.OnRead := ClientSocket1Read;

  //FHandle := (AOwner as TWinControl).Handle;
  FManagerReceiveString := TManagerReceiveString.Create;  //得到收集链表
  FPort := APort;
  FHost := AHost;
  FAppID := AppID;

  FOnWM_ReceiveDataInfo := OnWM_ReceiveDataInfo;

  FAnalyzeReceiveMsgMgr := TAnalyzeReceiveMsgMgr.Create(FManagerReceiveString,
                            FOnWM_ReceiveDataInfo);
  FAnalyzeReceiveMsgMgr.Resume;

  TimerOpenSocket := TTimer.Create(nil);
  TimerOpenSocket.OnTimer := TimerOpenSocketTimer;
  TimerOpenSocket.Interval := 1000;
  TimerOpenSocket.Enabled := true;



  //TimerAnalyzeReceiveMsg.Interval := 1000;
  //TimerAnalyzeReceiveMsg.Enabled  := true;


end;


procedure TASocketClientFrm.OpenClientSocketConnect;
begin

   if StopRunning Then
    Exit;
Try
  if Not FConnected  Then
  Begin
    ClientSocket1.Host := FHost;
    ClientSocket1.Port := FPort;
    ClientSocket1.Open;
  End;
  TimerOpenSocket.Interval := 5000;
Except
  CloseClientSocketConnect();
end;

end;

procedure TASocketClientFrm.TimerOpenSocketTimer(Sender: TObject);
begin


  if TimerOpenSocket.Tag=1 Then
    Exit;

  TimerOpenSocket.Tag := 1;

try
Try
  if StopRunning Then
     Exit;

  OpenClientSocketConnect;

Except
End;
Finally
  if (StopRunning) Then
     TimerOpenSocket.Enabled := false
  Else Begin
     if  (not FConnected) Then
        TimerOpenSocket.Enabled := True
     Else
        TimerOpenSocket.Enabled := false;
  End;

  TimerOpenSocket.Tag := 0;
End;

end;

procedure TASocketClientFrm.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 Socket.Close;
 ErrorCode := 0;
 if StopRunning Then
    Exit;
Try
   CloseClientSocketConnect();
Except
end;
end;

procedure TASocketClientFrm.SendToServerConnectInfo;
begin

   if StopRunning Then
    Exit;
Try
   if FConnected   Then
   Begin
      ClientSocket1.Socket.SendText('#%B%SocketName='+FAppID+';%E%#');
      RefreshBudfferText;
      //Self.Hide;
   End;
Except
  CloseClientSocketConnect();
end;

end;

procedure TASocketClientFrm.CloseClientSocketConnect();
begin

  Try
     if FConnected  Then
        ClientSocket1.Close;
     FConnected := False;
  except
  end;
  Try
    if Not StopRunning Then
    Begin
      OpenShow;
      TimerOpenSocket.Enabled  := True;
      TimerOpenSocket.Interval := 2000;
    End;
  Except
  end;

end;

procedure TASocketClientFrm.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  FConnected := True;
  SendToServerConnectInfo;
end;

procedure TASocketClientFrm.SendWMReceiveString;
Var
  AReceiveString: TAReceiveString;
  ObjWM : TWMReceiveString;
begin

   if StopRunning Then
    Exit;

try
   if FManagerReceiveString<>nil Then
   Begin
       AReceiveString := FManagerReceiveString.GetAReceiveString;
       if AReceiveString<>nil Then
       Begin
         ObjWM.WMType:='DOCPACKAGE'; //RCCPACKAGE
         ObjWM.WMReceiveString := AReceiveString.ReceiveString;

           if Assigned(FOnWM_ReceiveDataInfo) Then
              FOnWM_ReceiveDataInfo(@ObjWM);
         //SendMessage(FHandle,WM_ReceiveDataInfo,0,Integer(@ObjWM));
         if not FManagerReceiveString.FreeAReceiveString(AReceiveString) Then
            Exit;
       End;
   End;
except
end;

end;

function TASocketClientFrm.SendText(const Value: String):boolean;
begin

   Result := false;
   if StopRunning Then
    Exit;
Try
   if FConnected  Then
   Begin
      ClientSocket1.Socket.SendText('#%B%SocketName='+FAppID+';'+Value+';%E%#');
      Result := True;
   End;
Except
  CloseClientSocketConnect();
end;

end;

Procedure TASocketClientFrm.SendTextToBuffer(const Value: String);
begin
   if StopRunning Then
    Exit;
   FBufferText := Value;
end;

procedure TASocketClientFrm.RefreshBudfferText;
begin
   if StopRunning Then
    Exit;
   if Length(FBufferText)>0 Then
     if SendText(FBufferText) Then
         FBufferText := '';
end;

procedure TASocketClientFrm.ClearObj;
begin

  StopRunning := True;


Try

  CloseClientSocketConnect();

  TimerOpenSocket.Interval := 1;
  While TimerOpenSocket.Enabled and
       (TimerOpenSocket.Tag=1) Do
     Application.ProcessMessages;

  if Assigned(FAnalyzeReceiveMsgMgr) Then
  Begin
      FAnalyzeReceiveMsgMgr.Terminate;
      FAnalyzeReceiveMsgMgr.WaitFor;
      FAnalyzeReceiveMsgMgr.Destroy;
      FAnalyzeReceiveMsgMgr := nil;
  End;

  FManagerReceiveString.Destroy;
  FManagerReceiveString := nil;

  if Assigned(ClientSocket1) then
  begin
    ClientSocket1.Free;
    ClientSocket1 := nil;
  end;
  if Assigned(TimerOpenSocket) then
  begin
    TimerOpenSocket.Free;
    TimerOpenSocket := nil;
  end;

except
end;

end;

procedure TASocketClientFrm.OpenShow;
begin

   {if Not FConnected  Then
   Begin
     Self.Left := Round((Self.Parent.Width/2)-(Self.Width/2));
     Self.Top  := Round((Self.Parent.Height/2)-(Self.Height/2));
     Self.Show;
     music('7788');
   End;
   }
end;

procedure TASocketClientFrm.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  FConnected := False;
  if StopRunning Then
     Exit;
Try
   CloseClientSocketConnect();
Except
end;
end;

procedure TASocketClientFrm.SendToServerLiveInfo;
begin
   if StopRunning Then
    Exit;
  SendToServerConnectInfo;
end;

procedure TASocketClientFrm.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
Var
  Str : String;
  StrLst : _CStrLst;
  i : Integer;
begin


Try
Try
   if StopRunning Then
      Exit;

   if FManagerReceiveString=nil then
      exit;

   if Not FConnected  Then
      Exit;

   SetLength(StrLst,0);

   Str := ClientSocket1.Socket.ReceiveText;
   if Length(Str)=0 Then
      Exit;

   StrLst := GetReceiveStrArray(Str);
   for i:=0 to High(StrLst) Do
       FManagerReceiveString.SetAReceiveString(StrLst[i]);
   //SetLength(StrLst,0);

Except
end;
Finally
End;

end;

{ TAnalyzeReceiveMsgMgr }

constructor TAnalyzeReceiveMsgMgr.Create(
  ManagerReceiveString: TManagerReceiveString;
  OnWM_ReceiveDataInfo: TOnWM_ReceiveDataInfo);
begin


  FManagerReceiveString := ManagerReceiveString;
  FOnWM_ReceiveDataInfo := OnWM_ReceiveDataInfo;

  FreeOnTerminate := false;
  inherited Create(true);

end;

destructor TAnalyzeReceiveMsgMgr.Destroy;
begin
   FOnWM_ReceiveDataInfo := nil;
   FManagerReceiveString := nil;

  //inherited;
end;

procedure TAnalyzeReceiveMsgMgr.Execute;
begin
  //inherited;

  While Not Self.Terminated do
  Begin
      Application.ProcessMessages;
      Sleep(10);

      try
        SendWMReceiveString;
      Except
      end;

  end;

end;

procedure TAnalyzeReceiveMsgMgr.SendWMReceiveString;
Var
  AReceiveString: TAReceiveString;
  ObjWM : TWMReceiveString;
begin

   if Self.Terminated Then
    Exit;

try
   if FManagerReceiveString<>nil Then
   Begin
       AReceiveString := FManagerReceiveString.GetAReceiveString;
       if AReceiveString<>nil Then
       Begin
          ObjWM.WMType:='DOCPACKAGE'; //RCCPACKAGE
          ObjWM.WMReceiveString := AReceiveString.ReceiveString;
          if Assigned(FOnWM_ReceiveDataInfo) Then
             FOnWM_ReceiveDataInfo(@ObjWM);
          if Self.Terminated Then
             exit;
          if not FManagerReceiveString.FreeAReceiveString(AReceiveString) Then
             Exit;
       End;
   End;
except
end;

end;

end.
