unit TDwnHttp;

interface
  Uses Classes;
type

  TDwnHttpStatus=(dwnBegin,//��ʼ��Ϣ
                  dwnMsg,//״̬��Ϣ
                  dwnError,//������Ϣ
                  dwnEnd,//������Ϣ
                  dwnSize//������������Ϣ
                  );

  TDwnHttpWMessage =Packed record
    Status     : TDwnHttpStatus;//��Ϣ����
    MsgString  : ShortString;//��Ϣ����
    MaxSize    : Integer;//��������
    NowSize    : Integer;//��ǰ����������
    DwnSuccess : Boolean;//�Ƿ�ɹ�{True:�ɹ�,False:ʧ��)
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
