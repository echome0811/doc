unit SocketSvrFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp,MyDef,TCommon, ExtCtrls,TSocketClasses;//RCCDeclar   DocMonitorDeclar

type

  TManagerSocket = class
  private
     FASocket : TCustomWinSocket;
     FASocketDNS: ShortString;
     FASocketName : ShortString;
     FStartTime : TTime;
     function GetLiveTime():Integer;
  public
    constructor Create(ASocket:TCustomWinSocket;ASocketName:String);
    destructor  Destroy;

    property ASocket : TCustomWinSocket read FASocket Write FASocket;
    property ASocketName : ShortString read FASocketName;
    property ASocketDNS : ShortString read FASocketDNS Write FASocketDNS;
    property LiveTime : Integer read GetLiveTime;
  End;
  _ArrayManagerSkt = Array of TManagerSocket;

  TASocketSvrFrm = class(TFrame)
    ServerSocket1: TServerSocket;
    TimerOpenServerSocketListen: TTimer;
    TimerSendMsg: TTimer;
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure TimerOpenServerSocketListenTimer(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure TimerSendMsgTimer(Sender: TObject);
  private
    FAcceptSocket: TCustomWinSocket;
  private
    { Private declarations }
    FHandle : HWND;
    FAcceptSocketLst : TList;
    FManagerReceiveString : TManagerReceiveString;

    FPort : Integer;
    StopRunning : Boolean;

    NowIsSendMsg : Boolean;

    procedure RsetTimerSendMsgInterval();
    procedure SetAcceptSocket(Value:TCustomWinSocket;Const SocketName:String);

    procedure SendReceiveString();

    procedure SendWMError(Const ErrorMsg:STring);
    procedure SendWMAppConnect(Const AppDNS,AppID:STring);
    procedure SendWMAppDisConnect(Const AppDNS,AppID:STring);

    Function OpenServerSocketListen():Boolean;
    procedure CloseServerSocketListen();

    procedure CloseAllClientSocket();
    procedure CloseClientSocket(Socket:TCustomWinSocket);
    function  GetClientSocketForSocketName2(Const ASocketName:String):TManagerSocket;
    function  GetClientSocketForSocketName(Const ASocketName:String):_ArrayManagerSkt;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent;Const APort:Integer);
    procedure  ClearObj();

  end;

implementation

{$R *.dfm}

{ TASocketSvrFrm }

constructor TASocketSvrFrm.Create(AOwner: TComponent;Const APort:Integer);
begin



try
  inherited Create(AOwner);
except
end;

  StopRunning := false;

  FHandle := (AOwner as TWinControl).Handle;
  FAcceptSocketLst := TList.Create;
  FManagerReceiveString := TManagerReceiveString.Create;
  FPort := APort;

  TimerOpenServerSocketListen.Interval := 1000;
  TimerOpenServerSocketListen.Enabled  := true;

  RsetTimerSendMsgInterval;

  NowIsSendMsg := false;
  TimerSendMsg.Enabled := True;




end;

procedure TASocketSvrFrm.SetAcceptSocket(Value: TCustomWinSocket;Const SocketName:String);
Var
  i: integer;
  AManagerSocket : TManagerSocket;
begin

try

   if StopRunning Then Exit;
   if FAcceptSocketLst=nil Then exit;

   i := -1;
   for i:=0 to FAcceptSocketLst.Count-1 do
   Begin
     AManagerSocket := FAcceptSocketLst.Items[i];
     if AManagerSocket<>nil Then
     if (AManagerSocket.ASocketName=SocketName) and
        (AManagerSocket.ASocketDNS=Value.RemoteAddress) Then //加入Address的判断，防止不同IP的同一程序登陆
     Begin
        AManagerSocket.ASocket := Value;
        SendWMAppConnect(AManagersocket.ASocketDNS,AManagerSocket.ASocketName);
        Break;
     End;
  End;

  if (i>=FAcceptSocketLst.Count) or (i=-1) Then
  Begin
     AManagerSocket := TManagerSocket.Create(Value,SocketName);
     FAcceptSocketLst.Add(AManagerSocket);
     SendWMAppConnect(AManagersocket.ASocketDNS,SocketName);
  End;

except
end;

end;

procedure TASocketSvrFrm.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   CloseClientSocket(Socket);
   ErrorCode := 0;
End;

Function TASocketSvrFrm.OpenServerSocketListen:Boolean;
begin

Try
Try

  if Not ServerSocket1.Active Then
  Begin
    ServerSocket1.Port := FPort;
    ServerSocket1.Active := True;
  End;

Except
  CloseServerSocketListen;
  //On E:Exception do
  //Begin
  //  SendWMError(E.Message);
  //End;
End;
Finally
  Result := ServerSocket1.Active;
End;


end;


procedure TASocketSvrFrm.TimerOpenServerSocketListenTimer(Sender: TObject);
Var
  OpenServer : Boolean;
begin

  if TimerOpenServerSocketListen.Tag=1 Then
     Exit;

  TimerOpenServerSocketListen.Tag := 1;

  OpenServer := false;

try

  if StopRunning Then
    Exit;

  OpenServer := OpenServerSocketListen ;

Finally
  if StopRunning Then
     TimerOpenServerSocketListen.Enabled := false
  Else Begin
    if Not OpenServer Then
       TimerOpenServerSocketListen.Enabled := True
    Else
       TimerOpenServerSocketListen.Enabled := false;
  End;
  TimerOpenServerSocketListen.Tag := 0;
End;


end;

procedure TASocketSvrFrm.SendWMError(Const ErrorMsg:STring);
begin


end;

procedure TASocketSvrFrm.CloseClientSocket(Socket: TCustomWinSocket);
Var
   AManagerSocket : TManagerSocket;
   i : integer;
begin

try
   if FAcceptSocketLst=nil Then Exit;

   for i:=0 to FAcceptSocketLst.Count-1 do
   Begin
     AManagerSocket := FAcceptSocketLst.Items[i];
     if AManagerSocket<>nil Then
     if (AManagerSocket.ASocket=Socket) Then //(AManagerSocket.ASocketDNS=Socket.RemoteAddress) //加入Address的判断，防止不同IP的同一程序登陆
     Begin
         SendWMAppDisConnect(AManagerSocket.ASocketDNS,AManagerSocket.ASocketName);
         FAcceptSocketLst.Remove(AManagerSocket);
         AManagerSocket.Destroy;
         Break;
     End;
   End;

Except
end;

end;



procedure TASocketSvrFrm.SendWMAppConnect(const AppDNS,AppID: STring);
Var
    ObjWM : TWMAppStatusString;
begin


Try

  ObjWM.WMType  := 'AppStatus';
  objWm.WMDNS   := AppDNS;
  ObjWM.WMAppID := AppID;
  ObjWM.WMAppStatus := appConnect;
  SendMessage(FHandle,WM_AppStatusInfo,0,Integer(@ObjWM));

except
end;

end;

procedure TASocketSvrFrm.SendWMAppDisConnect(const AppDNS,AppID: STring);
Var
    ObjWM : TWMAppStatusString;
begin


Try
  ObjWM.WMType  := 'AppStatus';
  objWm.WMDNS   := AppDNS;
  ObjWM.WMAppID := AppID;
  ObjWM.WMAppStatus := appDisConnect;
  SendMessage(FHandle,WM_AppStatusInfo,0,Integer(@ObjWM));

except
end;

end;

function  TASocketSvrFrm.GetClientSocketForSocketName2(Const ASocketName:String):TManagerSocket;
Var
   AManagerSocket : TManagerSocket;
   i : integer;
begin
   Result := nil;
Try
   for i:=0 to FAcceptSocketLst.Count-1 do
   Begin
     AManagerSocket := FAcceptSocketLst.Items[i];
     if AManagerSocket.ASocketName=ASocketName Then
     Begin
         Result := AManagerSocket;
         Break;
     End;
  End;

Except
  Result := nil;
end;
end;

function TASocketSvrFrm.GetClientSocketForSocketName(const ASocketName: String):_ArrayManagerSkt;
Var
   AManagerSocket : TManagerSocket;
   i : integer;
   ArrayMngrSkt : _ArrayManagerSkt;
begin
   SetLength(ArrayMngrSkt,0);
   Result := ArrayMngrSkt;
Try
   for i:=0 to FAcceptSocketLst.Count-1 do
   Begin
     AManagerSocket := FAcceptSocketLst.Items[i];
     if AManagerSocket.ASocketName=ASocketName Then //返回所有的同名程序的所有Socket，使得同一程序在不同IP均可接到信息
     Begin
         SetLength(ArrayMngrSkt,High(ArrayMngrSkt)+2);
         ArrayMngrSkt[High(ArrayMngrSkt)]:=AManagerSocket;
     End;
   End;
   Result := ArrayMngrSkt;
Except
end;

end;

procedure TASocketSvrFrm.SendReceiveString;
Var
  AReceiveString: TAReceiveString;
  ManagerSocket : TManagerSocket;
  ArrayMngrSkt : _ArrayManagerSkt;
  i : integer;
begin

try
   if FManagerReceiveString<>nil Then
   Begin
       AReceiveString := FManagerReceiveString.GetAReceiveString;
       if AReceiveString<>nil Then
       Begin
           if UpperCase(AReceiveString.SendTo)='ALLUSER' Then
           Begin
                for i:=0 to FAcceptSocketLst.Count-1 do
                Begin
                     if StopRunning Then Exit;
                     ManagerSocket := FAcceptSocketLst.Items[i];
                     Try
                       //Don't Send Self
                       if ManagerSocket.ASocketName<>AReceiveString.MyName Then
                          ManagerSocket.ASocket.SendText(AReceiveString.SendFormatReceiveString);
                     Except
                     End;      
                End;
           End Else
           Begin
              //ManagerSocket := GetClientSocketForSocketName(AReceiveString.SendTo);
             //if ManagerSocket<>nil Then
                 //ManagerSocket.ASocket.SendText(AReceiveString.SendFormatReceiveString);
              ArrayMngrSkt := GetClientSocketForSocketName(AReceiveString.SendTo);//同一程序在不同IP均可接到信息
              for i:=0 to High(ArrayMngrSkt) do
              begin
                ManagerSocket := ArrayMngrSkt[i];
                if ManagerSocket<>nil Then
                   ManagerSocket.ASocket.SendText(AReceiveString.SendFormatReceiveString);
              end;
              SetLength(ArrayMngrSkt,0);
           End;
           FManagerReceiveString.FreeAReceiveString(AReceiveString);
       End;
   End;
except
end;

end;

procedure TASocketSvrFrm.CloseServerSocketListen;
//Var
//  AManagerSocket : TManagerSocket;
begin

  Try
    if ServerSocket1.Active Then
       ServerSocket1.Active :=false;
  except
  end;

  //CloseAllClientSocket;

end;

procedure TASocketSvrFrm.RsetTimerSendMsgInterval;
begin
Try
   if FManagerReceiveString.ReceiveCount>0 Then
      TimerSendMsg.Interval := 1
   Else
      TimerSendMsg.Interval := 3000;
Except
end;
end;

procedure TASocketSvrFrm.CloseAllClientSocket;
Var
    AManagerSocket : TManagerSocket;
begin

Try
try
   if FAcceptSocketLst=nil Then exit;

   While FAcceptSocketLst.Count>0 do
   Begin
     AManagerSocket := FAcceptSocketLst.Items[0];
     CloseClientSocket(AManagerSocket.ASocket);
   End;

Except
End;
Finally
  FAcceptSocketLst.Free;
  FAcceptSocketLst := nil;
End;

end;

procedure TASocketSvrFrm.ClearObj;
begin
try
try


  StopRunning := true;

  TimerOpenServerSocketListen.Interval := 1;
  While TimerOpenServerSocketListen.Enabled and
        (TimerOpenServerSocketListen.Tag=1) Do
       Application.ProcessMessages;

  TimerSendMsg.Interval := 1;
  While TimerSendMsg.Enabled and NowIsSendMsg Do
       Application.ProcessMessages;


  CloseServerSocketListen;

  CloseAllClientSocket;

  FManagerReceiveString.Destroy;

except
end;

Finally

End;

end;

{ TManagerSocket }

constructor TManagerSocket.Create(ASocket: TCustomWinSocket; ASocketName:String);
begin
   FASocket := ASocket;
   FASocketDNS := Asocket.RemoteAddress;
   FASocketName := ASocketName;
   FStartTime := Now;
end;

destructor TManagerSocket.Destroy;
begin

try
   FASocket := nil;
  //if FASocket<>nil Then
  //   FASocket.Disconnect(0);
except
end;
    //inherited;

end;

procedure TASocketSvrFrm.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
Var
  Str,SocketName : String;
  StrLst : _CStrLst;
  i : Integer;
begin


Try

   if StopRunning Then
   Begin
      Socket.Disconnect(0);
      Exit;
   End;   

   Str := Socket.ReceiveText;

   StrLst := GetReceiveStrArray(Str);
   for i:=0 to High(StrLst) Do
   Begin
     SocketName := GetReceiveStrColumnValue('SocketName',StrLst[i]);
     if Length(SocketName)>0  Then
        SetAcceptSocket(Socket,SocketName);
     FManagerReceiveString.SetAReceiveString(StrLst[i]);
   End;

   RsetTimerSendMsgInterval;


Except
End;

end;

procedure TASocketSvrFrm.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   CloseClientSocket(Socket);
end;

function TManagerSocket.GetLiveTime: Integer;
begin
  Result := Time1AndTime2Interval(Now,FStartTime);
end;

procedure TASocketSvrFrm.TimerSendMsgTimer(Sender: TObject);
begin

   if NowIsSendMsg Then
     exit;
   NowIsSendMsg := true;
Try
Try

   if StopRunning Then
     Exit;

   SendReceiveString;

   RsetTimerSendMsgInterval;

Except
End;
finally
   if StopRunning Then
      TimerSendMsg.Enabled := false;
   NowIsSendMsg := false;
end;


End;

end.
