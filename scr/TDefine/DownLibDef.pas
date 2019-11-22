unit DownLibDef;

interface

uses Windows,messages,Controls;

const
{$IFNDEF DwnLib}
  DllName='downLib.dll';
  
  ECreateDir=1;//create dir err
  ENetBlock =2;//network blocked err
  EWebAuthorization=3;//the web access request Authorization
  ECusAuthorization=4;//the customer's username and password isn't in customer list or the servise is out of the times
  EIndyError=5;
  EOtherError=6;
  EObjNotFundError=7;
{$ENDIF}

  WM_DWNBEGIN = WM_APP + 400;
  WM_DWNPRROGRESS =WM_APP + 401;
  WM_DWNERROR = WM_APP + 402;
  WM_DWNEND = WM_APP + 403;
  WM_DWNFILEEND=WM_APP +404;
  WM_DWNFILELIST=WM_APP +405;

type
  TWMDwnBegin =Packed record
    Msg: Cardinal;
    WorkCountMax: DWORD;
    RemoteFile:PChar;
    LocalFile:PChar;
    FileMax:DWORD;
  end;
  TLPWMDwnBegin = ^TWmDwnBegin;

  TWMDwnProgress =Packed record
    Msg:Cardinal;
    WorkCount:DWORD;
    Speed:PChar;
    Position:DWORD;
  end;
  TLPWMDwnProgress = ^TWMDwnProgress;

  TWMDwnFileEnd=Packed record
    Msg:Cardinal;
    RemoteFile:PChar;
    LocalFile:PChar;
    DownOk:BOOL;
    Progress:PChar;
  end;
  TLPWMDwnFileEnd =^TWMDwnFileEnd;

{$IFNDEF DwnLib}
  procedure _CreateBaseDown(Handle:HWND);stdcall;
  procedure _AddURL(const aURL,aDownTo : PChar);stdcall;


  procedure _CreateNewDown2(const AuthRemoteFile,RemoteFileList:PChar;Handle:HWND;InfoFile:PChar);stdcall;
  procedure _CreateNewDown(const AuthRemoteFile,RemoteFileList:PChar;Handle:HWND);stdcall;
  procedure _SetWebAuth(const Name,Password:PChar);stdcall;
  procedure _SetCusAuth(const Name,Password:PChar;Key:PChar);stdcall;
  procedure _SetProxy(const Server,UserName,Password:PChar;Port:integer);stdcall;
  procedure _SetPath(const Log,RemotePath,LocalPath:PChar);stdcall;
  procedure _Run;stdcall;
  procedure _Suspend;stdcall;
  procedure _Abort;stdcall;
  procedure _Clear;stdcall;
  procedure _SetDateRange(SDate,EDate:TDate);stdcall;
  procedure _SetDateLst(DateLst:Pdouble;Count:integer);stdcall;
  procedure _CreateUpgrade( AuthRemoteFile,RemoteFileList:PChar;Handle:HWND);stdcall;
  procedure _SetApp( AppTitle,AppFileName:PChar);stdcall;
{$ENDIF}
implementation
{$IFNDEF DwnLib}
  procedure _CreateBaseDown; external DllName name '_CreateBaseDown';
  procedure _AddURL; external DllName name '_AddURL'


  procedure _CreateNewDown2; external DllName name '_CreateNewDown2';
  procedure _CreateNewDown; external DllName name '_CreateNewDown';
  procedure _SetWebAuth; external DllName name '_SetWebAuth';
  procedure _SetCusAuth; external DllName name '_SetCusAuth';
  procedure _SetProxy; external DllName name '_SetProxy';
  procedure _SetPath; external DllName name '_SetPath';
  procedure _Run; external DllName name '_Run';
  procedure _Suspend; external DllName name '_Suspend';
  procedure _Abort; external DllName name '_Abort';
  procedure _Clear; external DllName name '_Clear';
  procedure _SetDateRange; external DllName name '_SetDateRange';
  procedure _SetDateLst; external DllName name '_SetDateLst';
  procedure _CreateUpgrade; external DllName name '_CreateUpgrade';
  procedure _SetApp; external DllName name '_SetApp';
{$ENDIF}
end.
 