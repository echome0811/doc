unit MyDef;

interface

uses Windows, Messages, Classes, SysUtils, Forms, Controls, Registry,ZLib,shellapi,TCommon;

const
  KEYNAMET='Proxy';
	CRLF=#13#10;
	
procedure MsgBox(const Msg: string);
procedure ErrBox(const Msg: string);
function YesNoBox(const Msg: string; DefButton: DWORD = MB_DEFBUTTON1): Boolean;
function YesNoCancelBox(const Msg: string): Integer;

procedure DoBusy(Busy: Boolean);

procedure ShowLastError(const Msg: string = 'API Error');
procedure RaiseLastError(const Msg: string = 'API Error');

//function D_GetFileTime(const PathName:string):TDateTime;
function IsHTTPFile(const aUrl:String):boolean;
function GetFileSize(const PathName:String):longword;
procedure SeparateString(const Str,Separator:string;var S1,S2:String);

function Encrypt(const Str : string; const Key : string): string;

function CompressFile(const DestFile,SrcFile:String;const Level: TCompressionLevel):Boolean;
function DeCompressFile(const DestFile,SrcFile:String):boolean;
{将非数字字符置为空,除了ReserveStr指定的字符}
//procedure FilterNoDigit(Var Key:Char;const ReserveStr:String='');
{把'/'转化为 '\'}
procedure WindowsPath(var APath: string;bWindows:Boolean);

procedure GetFolderFiles(const path,FileExt:String;Files:TStrings);

procedure SearchFiles(FilesList: TStringList;TheRootPath: String;TheExtName: String);
{替换字符串}
procedure ReplaceSubString(SubString, ReplaceString : string; var s : string);
function KeyInReg(const KeyName:string;RootName:HKEY):boolean;
procedure WriteKeyToReg(const KeyName:string;RootName:HKEY);
procedure InvokeExe(const aPathName,aCmdLine:String);
procedure Deltree(DirName : shortString);
procedure CloseWindow(const ClassName,WindowName:String);
function IsNumbers(const Str:String):boolean;
function GetDiskFreeSize(RootPath:String):int64;

type
  TAppSetupBase = Class
  private
    FAppName:String;
    FReg:TRegistry;
  protected
    procedure DoReadInfo;virtual;
    procedure DoWriteInfo;virtual;
    procedure DoClear;virtual;
  public
    constructor Create(const aAppName:string);
    destructor Destory; virtual;
    procedure ReadInfo;
    procedure WriteInfo;
    procedure Clear;
    property AppName :string read FAppName write FAppName;
  end;

  TAppSetup = Class(TAppSetupBase)
  private
    FUseIeProxy:boolean;
    FUseProxy:boolean;
    FProxySrv:String;
    FProxyPort:String;
    FProxyUserName:string;
    FProxyPwd:String;
  protected
    procedure DoReadInfo;override;
    procedure DoWriteInfo;override;
    procedure DoClear;override;

  public
    constructor Create(const aAppName:String);
    procedure ReadProxy(var asrv,aport,aname,apwd:string);
    property UseIEProxy:boolean read FUseIeProxy write FUseIeProxy;
    property UseProxy:boolean read FUseProxy write FUseProxy;
    property ProxySrv:String read FProxySrv write FProxySrv;
    property ProxyPort:String read FProxyPort write FProxyPort;
    property ProxyUserName:String read FProxyUserName write FProxyUserName;
    property ProxyPwd:String read FProxyPwd write FProxyPwd;
  end;
var
  Times: Integer = 0;

implementation

procedure MsgBox(const Msg: string);
begin
  Application.MessageBox(PChar(Msg), PChar(Application.Title), MB_ICONINFORMATION);
end;

procedure ErrBox(const Msg: string);
begin
  Application.MessageBox(PChar(Msg), PChar(Application.Title), MB_ICONERROR);
end;

function YesNoBox(const Msg: string; DefButton: DWORD = MB_DEFBUTTON1): Boolean;
begin
  Result := Application.MessageBox(PChar(Msg), PChar(Application.Title), MB_ICONQUESTION or
    MB_YESNO or DefButton) = IDYES;
end;

function YesNoCancelBox(const Msg: string): Integer;
begin
  Result := Application.MessageBox(PChar(Msg),
    PChar(Application.Title), MB_ICONQUESTION or MB_YESNOCANCEL or MB_DEFBUTTON1)
end;

procedure DoBusy(Busy: Boolean);
begin
  if Busy then
  begin
    Inc(Times);
    if Times = 1 then Screen.Cursor := crHourGlass;
  end else
  begin
    dec(Times);
    if Times = 0 then Screen.Cursor := crDefault;
  end;
end;

function GetLastErrorStr: string;
var
  Buf: PChar;
begin
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
    nil, GetLastError, LANG_USER_DEFAULT, Buf, 0, nil);
  try
    Result := StrPas(Buf);
  finally
    LocalFree(HLOCAL(Buf));
  end;
end;

procedure ShowLastError(const Msg: string = 'API Error');
begin
  MsgBox(Msg + ': ' + GetLastErrorStr);
end;

procedure RaiseLastError(const Msg: string = 'API Error');
var
  S: string;
begin
  S := GetLastErrorStr;
  if S = '' then S := IntToStr(GetLastError);
  raise Exception.Create(Msg + ': ' + S);
end;

{function D_GetFileTime(const PathName:string):TDateTime;
var
  f:cardinal;
  FTime:FILETIME;
  STime:SYSTEMTIME;
begin
  result:=0;
  f:=CreateFile(Pchar(PathName),GENERIC_READ,FILE_SHARE_READ,
                nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if f>0 then
    if GetFileTime(f,@FTime,nil,nil) then
    begin
      FileTimeToSystemTime(FTime,STime);
      result:=SystemTimeToDateTime(STime);
    end;
  CloseHandle (f);
end;}

function IsHTTPFile(const aUrl:String):boolean;
begin
  result:=true;
  if Pos('HTTP://',AnsiUpperCase(aUrl))<>1 then
  begin
    result:=false;
  end
end;

function GetFileSize(const PathName:String):longword;
var
  f: file of Byte;
begin
  Result := 0;
  if FileExists(PathName) Then
  Begin
    AssignFile(f, PathName);
    fileMode := 0;
    Reset(f);
    try
      result := FileSize(f);
    finally
      CloseFile(f);
    end;
  End;
end;

function Encrypt(const Str : string; const Key : string): string;
var
  X, Y : Integer;
  A : Byte;
  ret:string;
begin
  ret:=str;
  Y := 1;
  if key<>'' then
  for X := 1 to length(Str) do
  begin
    A := (ord(Str[X]) and $0f) xor (ord(Key[Y]) and $0f);
    ret[X] := char((ord(Str[X]) and $f0) + A);
    inc(Y);
    if Y > length(Key) then
      Y := 1;
  end;
  Result := ret;
end;

procedure SeparateString(const Str,Separator:string;var S1,S2:String);
var
  i:integer;
begin
  if Str='' then exit;
  if Separator='' then S1:=Str;
  i:=pos(Separator,Str);
  S1:=Copy(Str,1,i-1);
  i:=i+Length(Separator);
  S2:=Copy(Str,i,length(Str)-i+1);
end;

procedure WindowsPath(var APath: string;bWindows:Boolean);
var
  i: Integer;
  a,b:char;
begin
  i := 1;
  if bWindows then
  begin
    a:='/';
    b:='\';
  end
  else
  begin
    a:='\';
    b:='/';
  end;

  while i <= Length(APath) do
  begin
    if APath[i] = a then
    begin
      APath[i] := b;
      inc(i, 1);
    end
    else
    begin
      inc(i, 1);
    end;
  end;
end;

function CompressFile(const DestFile,SrcFile:String;const Level: TCompressionLevel):Boolean;
var
  des:TMemoryStream;
  sou:TMemoryStream;
  cs: TCompressionStream;
  Count: Integer;
begin
  result:=false;
  des:=TMemoryStream.Create;
  sou:= TMemoryStream.Create;
  cs:=TCompressionStream.Create(level,des);
  try
    sou.LoadFromFile(SrcFile);
    Count:=sou.Size;
    sou.SaveToStream(cs);
    cs.Free;

    sou.Clear;
    sou.WriteBuffer(Count, SizeOf(Count));
    sou.CopyFrom(des,0);

    des.Clear;

    des.Seek(0,soFromBeginning);
    des.CopyFrom(sou,0);
    des.SaveToFile(DestFile);
    result:=true;
  finally
    des.Free;
    sou.Free;
  end;
end;

function DeCompressFile(const DestFile,SrcFile:String):boolean;
var
  des:TFileStream;
  sou:TMemoryStream;
  decs: TDeCompressionStream;
  Buffer: PChar;
  Count: integer;
begin
  Buffer:=nil;
  decs:=nil;
  result:=false;
  des:=TFileStream.Create(DestFile,fmCreate);
  sou:= TMemoryStream.Create;
  try
    sou.LoadFromFile(SrcFile);
    sou.Seek(0,soFromBeginning);
    sou.ReadBuffer(count,sizeof(count));
    GetMem(Buffer, Count);
    decs:=TDeCompressionStream.Create(sou);
    decs.ReadBuffer(Buffer^, Count);
    Des.WriteBuffer(Buffer^, Count);
    Des.Position := 0;//复位流指针
    result:=true;
  finally
    FreeMem(Buffer);
    decs.Free;
    des.Free;
    sou.Free;
  end;
end;

procedure GetFolderFiles(const path,FileExt:String;Files:TStrings);
var
  DirInfo: TSearchRec;
  r: Integer;
  dirname:String;
begin
  dirname:=IncludeTrailingBackslash(Path);
  r := FindFirst(dirname+'*.*', FaAnyfile, DirInfo);
  while r = 0 do
  begin
    if ((DirInfo.Attr and FaDirectory) = FaDirectory) and (DirInfo.Name<>'.')
       and (DirInfo.Name<>'..') then
      GetFolderFiles(path + DirInfo.Name,FileExt,Files);
    if ((DirInfo.Attr and FaDirectory <> FaDirectory) and
      (DirInfo.Attr and FaVolumeId <> FaVolumeID)) then
    Begin
        if (CompareText(ExtractFileExt(DirInfo.Name),FileExt)=0) or (FileExt='*.*') Then
        Begin
          Files.Add(dirname+DirInfo.Name);
        End;
    End;
    r := FindNext(DirInfo);
  end;
  SysUtils.FindClose(DirInfo);
end;


procedure SearchFiles(FilesList: TStringList;
                      TheRootPath: String;
                      TheExtName: String);
var
  SearchRec: TSearchRec;
  procedure GetFile;
  begin
    if ((SearchRec.Attr and faDirectory) > 0) then
    begin
      if (SearchRec.Name <> '.') and
         (SearchRec.Name <> '..') then  //若不是本级或上级目录则需要搜索
        SearchFiles(FilesList, TheRootPath + SearchRec.Name + '\', TheExtName);
    end
    else if (TheExtName = '*.*') or (UpperCase(ExtractFileExt(SearchRec.Name)) = TheExtName) then
        FilesList.Append(UpperCase(TheRootPath + SearchRec.Name));
  end;
begin
  if FindFirst(TheRootPath + '*.*',
      faReadOnly +
      faHidden +
      faSysFile +
      faVolumeID +
      faDirectory +
      faArchive +
      faAnyFile,
      SearchRec) <> 0 then
    exit;
  TheExtName := UpperCase(TheExtName);
  GetFile;
  while FindNext(SearchRec) = 0 do
    GetFile;
  FindClose(SearchRec);
end;


procedure ReplaceSubString(SubString, ReplaceString : string; var s : string);
var
	nIndex, nPos : integer;
begin
	nPos := 1;
	nIndex := Pos(LowerCase(SubString),
        LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));

	while (nIndex > 0) do
	begin
		Delete(s, nIndex + nPos - 1, Length(SubString));  //删除指定的字符串
		Insert(ReplaceString, s, nIndex + nPos - 1);      //插入替换的字符串
		inc(nPos, nIndex - 1 + Length(ReplaceString));    //重新定位起始点

		nIndex := Pos(LowerCase(SubString),
        LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
	end;
end;

function KeyInReg(const KeyName:string;RootName:HKEY):boolean;
var
  reg:TRegistry;
begin
  result:=false;
  Reg:=TRegistry.Create;
  try
    Reg.RootKey := RootName;
    result := Reg.OpenKey(Format('\Software\TraderOne\FEDB\N\news\%s',[KeyName]),false);
  finally
    Reg.CloseKey;
    reg.Free;
  end;
end;

procedure WriteKeyToReg(const KeyName:string;RootName:HKEY);
var
  reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey := RootName;
    if Reg.OpenKey(Format('\Software\TraderOne\FEDB\N\news\%s',[KeyName]),true) then
    begin
      Reg.WriteDate('DATE',Now);
      Reg.WriteString('TYPE','Message');
    end;
  finally
    Reg.CloseKey;
    reg.Free;
  end;
end;

procedure InvokeExe(const aPathName,aCmdLine:String);
begin
  if aPathName<>'' then
    ShellExecute(Application.Handle,'open',
                PChar(aPathName),
                PChar(aCmdLine),nil,SW_SHOWNORMAL);
end;

procedure Deltree(DirName : shortString);
var
  DirInfo: TSearchRec;
  r : Integer;
begin
  r := FindFirst(DirName+'*.*', FaAnyfile, DirInfo);
  while r = 0 do
  begin
    if ((DirInfo.Attr and FaDirectory) = FaDirectory) and (DirInfo.Name<>'.')
       and (DirInfo.Name<>'..') then
      Deltree(DirName +  DirInfo.Name);
   if ((DirInfo.Attr and FaDirectory <> FaDirectory) and
      (DirInfo.Attr and FaVolumeId <> FaVolumeID)) then
      DeleteFile(pChar(DirName + DirInfo.Name));
    r := FindNext(DirInfo);
  end;
  SysUtils.FindClose(DirInfo);
  RemoveDirectory(pchar(DirName+''));
end;

procedure CloseWindow(const ClassName,WindowName:String);
var
  Handle:HWND;
begin
  Handle:=FindWindow('TFormMain','Update');
  if(Handle>0) then
    SendMessage(Handle,WM_CLOSE,0,0);
end;

function IsNumbers(const Str:String):boolean;
var
  i:integer;
begin
  result:=true;
  for i :=1  to length(Str)  do
  begin
    if not (Str[i] in ['0'..'9']) then
    begin
      result:=false;
      break;
    end;
  end;
end;

function GetDiskFreeSize(RootPath:String):int64;
var
  FreeCaller,TotalSize,FreeSize:Int64;
begin
  RootPath:=IncludeTrailingBackslash(RootPath);
  Mkdir_Directory(RootPath);
  if GetDiskFreeSpaceEx(Pchar(RootPath),FreeCaller,TotalSize,@FreeSize) then
    result:=FreeSize
  else
    result:=-1;
end;

{TAppSetupBase}
procedure TAppSetupBase.DoReadInfo;
begin
  Doclear;
end;

procedure TAppSetupBase.DoWriteInfo;
begin
end;

constructor TAppSetupBase.Create(const aAppName:string);
begin
  FReg:=TRegistry.Create;
  FAppName:=aAppName;
  DoReadInfo;
end;

destructor TAppSetupBase.Destory;
begin
  FReg.Free;
end;

procedure TAppSetupBase.ReadInfo;
begin
  DoReadInfo;
end;

procedure TAppSetupBase.WriteInfo;
begin
  DoWriteInfo;
end;

procedure TAppSetupBase.Clear;
begin
  doClear;
end;

procedure TAppSetupBase.DoClear;
begin
end;

{TAppSetup}
constructor TAppSetup.Create(const aAppName:String);
begin
  FUseIeProxy:=true;
  FUseProxy:=false;
  FProxySrv:='';
  FProxyPort:='';
  FProxyUserName:='';
  FProxyPwd:='';
  inherited Create(aAppName);
end;

procedure TAppSetup.ReadProxy(var asrv,aport,aname,apwd:string);
begin
  FReg.RootKey := HKEY_CURRENT_CONFIG;
  if FReg.OpenKey(Format('\Software\TraderOne\FEDB\N\%s',[FAppName]),false) then
  begin
    if FReg.ValueExists('ProxyServer')then
      asrv:= FReg.ReadString('ProxyServer');
    if FReg.ValueExists('ProxyPort')then
      aport:= FReg.ReadString('ProxyPort');
    if FReg.ValueExists('ProxyUserName')then
      aname:= FReg.ReadString('ProxyUserName');
    if FReg.ValueExists('ProxyPwd')then
      apwd:= FReg.ReadString('ProxyPwd');
    Freg.CloseKey;
  end;
end;

procedure TAppSetup.DoReadInfo;
var
  s:String;
begin
  inherited;
  FReg.RootKey := HKEY_CURRENT_CONFIG;
  if FReg.OpenKey(Format('\Software\TraderOne\FEDB\N\%s',[FAppName]),false) then
  begin
    if FReg.ValueExists('UserIEProxy') then
      FUseIeProxy:= FReg.ReadBool('UserIEProxy');
    if FReg.ValueExists('ProxyEnable') then
      FUseProxy:= FReg.ReadBool('ProxyEnable');
    FReg.CloseKey;
    if FUseProxy then
    begin
      if FUseIeProxy then
      begin
        FReg.RootKey := HKEY_CURRENT_USER;
        if FReg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings',false)then
        begin
          if FReg.ReadBool('ProxyEnable') then
          begin
            s:=FReg.ReadString('ProxyServer');
            if s <>'' then
            SeparateString(s,':',FProxySrv,FProxyPort);
          end;
          Freg.CloseKey;
        end;
      end
      else
      begin
        FReg.RootKey := HKEY_CURRENT_CONFIG;
        if FReg.OpenKey(Format('\Software\TraderOne\FEDB\N\%s',[FAppName]),false) then
        begin
          if FReg.ValueExists('ProxyServer')then
            FProxySrv:= FReg.ReadString('ProxyServer');
          if FReg.ValueExists('ProxyPort')then
            FProxyPort:= FReg.ReadString('ProxyPort');
          if FReg.ValueExists('ProxyUserName')then
            FProxyUserName:= FReg.ReadString('ProxyUserName');
          if FReg.ValueExists('ProxyPwd')then
            FProxyPwd:= FReg.ReadString('ProxyPwd');
          Freg.CloseKey;
        end;
      end;
    end;
  end;
end;

procedure TAppSetup.DoWriteInfo;
begin
  inherited;
  FReg.RootKey := HKEY_CURRENT_CONFIG;
  if FReg.OpenKey(Format('\Software\TraderOne\FEDB\N\%s',[FAppName]),true) then
    begin
      FReg.WriteBool('UserIEProxy',FUseIeProxy);
      FReg.WriteBool('ProxyEnable',FUseProxy);
      FReg.WriteString('ProxyServer',FProxySrv);
      FReg.WriteString('ProxyPort',FProxyPort);
      FReg.WriteString('ProxyUserName',FProxyUserName);
      FReg.WriteString('ProxyPwd',FProxyPwd);
      Freg.CloseKey;
  end;
end;

procedure TAppSetup.DoClear;
begin
  inherited;
  FUseIeProxy:=true;
  FUseProxy:=false;
  FProxySrv:='';
  FProxyPort:='';
  FProxyUserName:='';
  FProxyPwd:='';
end;

end.

