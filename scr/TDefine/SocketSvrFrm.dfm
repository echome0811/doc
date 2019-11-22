object ASocketSvrFrm: TASocketSvrFrm
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    OnClientError = ServerSocket1ClientError
    Left = 32
    Top = 8
  end
  object TimerOpenServerSocketListen: TTimer
    Enabled = False
    OnTimer = TimerOpenServerSocketListenTimer
    Left = 32
    Top = 40
  end
  object TimerSendMsg: TTimer
    Enabled = False
    OnTimer = TimerSendMsgTimer
    Left = 32
    Top = 72
  end
end
