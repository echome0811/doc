unit TDwnHttp;

interface
  Uses Classes;
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

{$IFNDEF _DwnHttp}

  Function _GetHttpTxt(AURL:PChar;Var AStrLst:TStringList;AOnDwnHttpMessage:TOnDwnHttpMessage):integer;
           far; external 'DwnHttp.dll';
  procedure _ReleaseHttpTxt(index:integer);
           far; external 'DwnHttp.dll';
  function _StopConnect(index:integer):Boolean;far; external 'DwnHttp.dll';
  procedure _FreeHttpTxt();far; external 'DwnHttp.dll';
  Procedure _InitDwnHttp(Count:Integer);far; external 'DwnHttp.dll';

{$ENDIF}

implementation
end.
