unit TWarningServer;
{$I Define.inc}

interface


Type

  TWarningServerMsgStatus = (svrMsgError,
               svrMsgWarning,
               svrMsgMsg);

   TOnSoundMsg = Procedure (Msg:ShortString) of Object;
   TOnSoundConnected = Procedure () of Object;
   TOnSoundDisconnected = Procedure () of Object;
             
{$IFNDEF _WarningServer}

 function ConnectToSoundServer(Const Server:ShortString;Const Port:Integer):Boolean;
        far; external 'WarningServer.dll';

 function ConnectToSoundServerUserName(Const UserName,Server:ShortString;
                                         Const Port:Integer;
                                         OnSoundMsg : TOnSoundMsg;
                                         OnSoundConnected:TOnSoundConnected;
                                         OnSoundDisconnected:TOnSoundDisconnected):Boolean;
        far; external 'WarningServer.dll';

 function ConnectToSoundServerOnEvent(Const Server:ShortString;Const Port:Integer;
                                    OnSoundMsg : TOnSoundMsg;
                                    OnSoundConnected:TOnSoundConnected;
                                    OnSoundDisconnected:TOnSoundDisconnected):Boolean;
        far; external 'WarningServer.dll';

 procedure DisConnectSoundServer();
        far; external 'WarningServer.dll';

 Function ConnectOk():Boolean;
        far; external 'WarningServer.dll';

 procedure SendToSoundServer(Const SoundID,Msg:ShortString;MsgStatus:TWarningServerMsgStatus);
        far; external 'WarningServer.dll';

 procedure SendToDisconnectSleepSound();
        far; external 'WarningServer.dll';
 {$ENDIF}


implementation



end.
