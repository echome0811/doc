//------------------------------------------------------------------------------
//
// File:       CSDef.pas
// Content:    提供常用函数以及常用类
// Author:     codehunter 2002--http://codehunter.126.com
//
//------------------------------------------------------------------------------
unit CSDef;

interface

uses
  Classes,SysUtils,IniFiles,Forms,windows,Messages,Controls,shellapi,filectrl,
  ZLib, Registry,graphics;
const
  SETUP_NAME='XXX.ini';   		//配置文件名
  ENCODE_CODE='CodeHunter';  	//异或加密的key
  WEBADDRESS='http://www.yxgh.com/codehunter/index.html';
  SUPPORTMAIL='codehunter@163.com';

//------------------------------------------------------------------------------
//  TAppSetupBase
//  读写配置文件的类
//  重载ReadIniFile,和SaveIniFile这两个虚函数就能轻松读写配置文件
//------------------------------------------------------------------------------
type
  TAppSetupBase=class
  private
    FPathName:String;
  protected
    FIniFile:TIniFile;
    procedure ReadIniFile;virtual;
    procedure SaveIniFile;virtual;
  public
    procedure ReadFromFile;
    procedure SaveToFile;
    property PathName:String read FPathName write FPathName;
    //property MainFormPosX:integer read FMainFormPosX write FMainFormPosX;
    //property MainFormPosY:integer read FMainFormPosY write FMainFormPosY;
    constructor Create(const aFileName:String);
    //destructor Destory;virtual;;
  end;
  
//------------------------------------------------------------------------------
//  常用函数
//------------------------------------------------------------------------------
  {获取设置文件路径}
  function GetSetupPathName:String;
  //对密码进行xor加解密
  function XorEncode(const aCode:String):String;
  function XorDecode(const aCode:String):String;
  {常用的对话框函数}
  procedure MsgBox(const Msg: string);
  procedure ErrBox(const Msg: string);
  function YesNoBox(const Msg: string; DefButton: DWORD = MB_DEFBUTTON1): Boolean;
  function YesNoCancelBox(const Msg: string): Integer;
  {将光标设置为忙或恢复 }
  procedure DoBusy(Busy: Boolean);
  {将非数字字符置为空,除了ReserveStr指定的字符}
  procedure FilterNoDigit(Var Key:Char;const ReserveStr:String=''); overload;
  {用shellexecute打开}
  procedure OpenWithIE(const aPath:String);
  procedure InvokeExe(const aPathName,aCmdLine:String);
  {访问网站}
  procedure VisitWeb(const URL:String=WEBADDRESS);
  procedure SendMail(const Mail:String=SUPPORTMAIL);
  {获取文件版本等信息}
  function GetEXEVersion(const aPathName,FieldName:String):String;
  {将多个文件(s)删除到回收站}
  function DeleteFiles(const aFiles:TStrings):integer;
  function DelDir(const Dir:String):boolean;
  {删除一个文件}
  function DelFile(const aFile:String):boolean;
  {替换字符串}
  procedure ReplaceSubString(SubString, ReplaceString : string; var s : string);
  {新的替换字符串过程}
  procedure NewReplaceSubString(SubString, ReplaceString : string; var s : string); //by leon 081009 add
  {删除字符串中'<'与'>'之间的html网页脚本内容，不能容错}
  Function DelHtmlSubString(var S:String):boolean;      //by leon 081013 add
  {替换最前面的一个字符串}
  procedure ReplaceSubString_first(SubString, ReplaceString : string; var s : string);
  {文件创建时间}
  function GetFileTimeEx(const PathName:string):TDateTime;
  {文件大小}
  function GetFileSize(const PathName:String):longint;
  {将一个字符串分离成两个}
  procedure SeparateString(const Str,Separator:string;var S1,S2:String);
  {压缩一个文件}
  function CompressFile(const DestFile,SrcFile:String;const Level: TCompressionLevel):Boolean;
  {解压缩一个文件}
  function DeCompressFile(const DestFile,SrcFile:String):boolean;
  {把'/'转化为 '\',Windows,Unix}
  procedure WindowsPath(var APath: string;bWindows:Boolean);
  {获取一个指定目录中的所有指定扩展名的文件}
  procedure SearchFiles(FilesList: TStringList;TheRootPath: String;TheExtName: String);
  {选择路径}
  function SelDir(const InitPath:String):String;
  {指定的KeyName是否在注册表中}
  function KeyInReg(const KeyName:string;RootName:HKEY):boolean;
  {删除指定的目录}
  procedure Deltree(DirName : shortString);
  {关闭窗口}
  procedure CloseWindow(const ClassName,WindowName:String);
  {判断是否为正确的路径}
  function IsDir(const Dir:String):boolean;
  {获取指定路径的free space}
  function GetDiskFreeSize(RootPath:String):int64;
  {}
  function LeftStr(const astr:String;Count:integer):String;
  function IsNumbers(const Str:String):boolean;

  procedure MakeStartRun(const FileName,sValue:String;UseReg,UseIni,Enable:Boolean);
  Function  HaveMakeStartRun(const FileName,sValue:String;UseReg,UseIni:Boolean):Boolean;

  function GetWindowsDir:String;

  function WindowExists(const ClassName,WindowName:String):boolean;

  function GetProgramVersion(path : string;IncludeDot:boolean) : string;
  {获取product.ver文件的版本号}
  function GetVerFileVersion(const FileName: String):String;

  procedure SaveLog(Const Msg:string);       //leon 100209
var
  Times:integer=0;

implementation


//------------------------------------------------------------------------------
//  常用函数实现
//------------------------------------------------------------------------------

procedure SaveLog(Const Msg:string);       //leon 100209
Var
  DirPath : String;
  FileName : String;
  f : TextFile;
  Str : String;
begin
try
  DirPath := 'c:\';
  if not DirectoryExists(DirPath) then exit;
  FileName := Format(DirPath+'%s(Minute).log',[FormatDateTime('yyyyMMdd_hhmm',now)]);
  Str := Format('[%s]==>'+Msg,[FormatDateTime('hh:mm:ss',now)]);
  AssignFile(f,FileName);
  try
    if Not FileExists(FileName) Then ReWrite(f)
    Else Append(f);
    Flush(f);       //leon 100920
    Writeln(f,Str);
  finally
    Flush(f);       //leon 100920
    CloseFile(f);
  end;
Except
  //on e : exception do
  //  Raise Exception.Create(e.Message);    {raise是把异常继续向上传播}
End;
end;


function GetSetupPathName:String;
begin
  result:=ExtractFilePath(Application.ExeName)+SETUP_NAME;
end;

function LeftStr(const astr:String;Count:integer):String;
begin
  result:=copy(astr,Length(aStr)-Count+1 ,Count);
end;

function XorEncode(const aCode:String):String;
var
  PWD:String;
  ret:String;
  i:integer;
  j:integer;
  t1,t2:integer;
begin
  PWD:=ENCODE_CODE;
  ret:=aCode;
  j:=length(PWD);
  for i := 1  to Length(aCode) do
  begin
    t1:= integer(aCode[i]);
    t2:= integer(PWD[(i mod j)+1]);
    ret[i]:=char(t1 xor t2) ;
  end;
  result:=ret;
end;

function XorDecode(const aCode:String):String;
begin
  result:=XorEncode(aCode);
end;

procedure MsgBox(const Msg: string);
begin
  Application.MessageBox(PChar(Msg), PChar(Application.Title),
             MB_ICONINFORMATION);
end;

procedure ErrBox(const Msg: string);
begin
  Application.MessageBox(PChar(Msg), PChar(Application.Title),
              MB_ICONERROR);
end;

function YesNoBox(const Msg: string; DefButton: DWORD = MB_DEFBUTTON1): Boolean;
begin
  Result := Application.MessageBox(PChar(Msg), PChar(Application.Title),
            MB_ICONQUESTION or MB_YESNO or DefButton) = IDYES;
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

procedure FilterNoDigit(Var Key:Char;const ReserveStr:String);
begin
  if (ReserveStr= '') or
    (not (Key  in [ReserveStr[1]..ReserveStr[Length(ReserveStr)]])) then
    if (Key<'0') and (Key>char(31)) or (Key>'9') then
      Key:=#0;
end;

procedure OpenWithIE(const aPath:String);
begin
  if aPath<>'' then
    ShellExecute(Application.Handle,'open',
                PChar(aPath),
                 nil,nil,SW_SHOWNORMAL);
end;

procedure VisitWeb(const URL:String);
begin
  OpenWithIE(URL);
end;

procedure SendMail(const Mail:String);
begin
  OpenWithIE('mailto:'+ Mail);
end;

function GetEXEVersion(const aPathName,FieldName:String):String;
var
  buf:Pointer;
  LplpBuf:Pointer;
  Len:integer;
  ret:String;
  H:Cardinal;
begin
  ret:='';
  Len:=GetFileVersionInfoSize(PChar(aPathName),H);
  if Len>0 then
  begin
    buf:=AllocMem(Len);
    try
      if GetFileVersionInfo(PChar(aPathName),0,Len,buf) then
      begin
        if VerQueryValue(buf,
              PChar('\StringFileInfo\080403A8\'+ FieldName),LplpBuf,H)then
          ret:=copy(Pchar(LplpBuf),1,H);
      end;
    finally
      FreeMem(buf);
    end;
  end;
  result:=ret;
end;

function DeleteFiles(const aFiles:TStrings):integer;
var
  T:TSHFileOpStruct;
  P:String;
  i,j:integer;
begin



  j:=0;
  FillChar (t, SizeOf (t), #0);//in winnt the line is necessary
  for i :=0  to aFiles.Count-1 do
  begin
    p:=p+aFiles.Strings[i]+#0;
    inc(j);
  end;

  with T do
  begin
    Wnd:=Application.Handle;
    wFunc:=FO_DELETE;
    pFrom:=Pchar(p+#0);
    fFlags:=FOF_ALLOWUNDO;
  end;

  if SHFileOperation(T)=0 then
  begin
    if not T.fAnyOperationsAborted then
      result:=j
    else
      result:=0;
  end;

end;

function DelFile(const aFile:String):boolean;
var
  sl:TStrings;
  ret:integer;
begin
  ret:=0;
  sl := TStringList.Create;
  try
    sl.Add(aFile);
    ret:=DeleteFiles(sl);
  finally
    sl.Free;
    result:=(ret>0);
  end;
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

/////////////////////////////////////////////////////////////////////////////////   by leon 081013
procedure NewReplaceSubString(SubString, ReplaceString : string; var s : string);
var
  CopyLowStr,CopyLowSubStr,result:String;
  i,j,TmpIndex,index,Slength,SubStrlength:integer;
  SameOk,NeedInset:Boolean;
begin
try
   result:='';
   if ReplaceString<>'' then
     NeedInset:=true
   else
     NeedInset:=false;
   CopyLowSubStr:=lowerCase(SubString);
   CopyLowStr:=lowerCase(s);
   Slength:=length(s)+1;
   SubStrlength:=length(SubString)+1;
   index:=1;
   for i := 1 to Slength-SubStrlength+1 do
     begin
        TmpIndex:=i;
        j:=1;
       while j<SubStrlength do
         if CopyLowStr[TmpIndex]=CopyLowSubStr[j] then
           begin
             TmpIndex:=TmpIndex+1;
             j:=j+1;
             SameOk:=true;
           end
         else
           begin
             SameOk:=false;
             break;
           end;
       if SameOk then
         begin
           result:=result+copy(s,index,i-index);
           if NeedInset then
             result :=result+ ReplaceString;
           index:=TmpIndex;
         end;
     end;
   if index<Slength then
     result:=result+copy(s,index,Slength-index);
   s:=result;
except
end;
end;

Function DelHtmlSubString(var S:String):boolean;
var
  CopyStr,Str:String;
  i,Slength,index,TempIndex,MainIndex:integer;
  SameOk,HtmlSameOK:Boolean;
begin
try
  result:=false;
  CopyStr:=S;
  Slength:=length(s);
  index:=1;
  MainIndex:=1;
  Str:='';
  while index<Slength do
    begin
      TempIndex:=index;
      SameOK:=false;
      HtmlSameOK:=false;
        if CopyStr[TempIndex]='<' then
            SameOk:=true
        else
            SameOk:=false;
        TempIndex:=TempIndex+1;
        index:=TempIndex;
        if SameOK then
          begin
            for i:= TempIndex to Slength do
              begin
                index:=i;
                if CopyStr[i]='<'then           //by leon 081119
                  begin
                    HtmlSameOK:=false;
                    break;
                  end;
                if CopyStr[i]='>'then
                  begin
                    HtmlSameOK:=true;
                    break;
                  end
                else
                  HtmlSameOK:=false;
              end;
            if HtmlSameOK then
              begin
                Str:=Str+copy(s,MainIndex,TempIndex-MainIndex-1);
                MainIndex:=index+1;
              end;
          end;
     end;
  if MainIndex<=Slength then
  Str:=Str+Copy(s,MainIndex,Slength-MainIndex+1);
  S:=Str;
  result:=true;
except
end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure ReplaceSubString_first(SubString, ReplaceString : string; var s : string);
var
  nIndex : integer;
begin

  nIndex := Pos(LowerCase(SubString),LowerCase(s));	

  if (nIndex > 0) then	
  begin	
    Delete(s, nIndex, Length(SubString));  //删除指定的字符串	
    Insert(ReplaceString, s, nIndex);      //插入替换的字符串	
  end;	

end;

function GetFileTimeEx(const PathName:string):TDateTime;
var
  f:cardinal;
  FTime,LTime:FILETIME;
  STime:SYSTEMTIME;
begin
  result:=-1;
  f:=CreateFile(Pchar(PathName),GENERIC_READ,FILE_SHARE_READ,
                nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if f>0 then
    if GetFileTime(f,nil,nil,@FTime) then
    begin
      if FileTimeToLocalFileTime(FTime,LTime) then
        if FileTimeToSystemTime(FTime,STime) then
          result:=SystemTimeToDateTime(STime);
    end;
  CloseHandle (f);
end;

function GetFileSize(const PathName:String):longint;
var
  f: file of Byte;
begin
  result:=-1;
  if not FileExists(PathName) then
    exit;
  FileMode := 0;
  AssignFile(f, PathName);
  Reset(f);
  try
    result := FileSize(f);
  finally
    CloseFile(f);
  end;
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
  ret:boolean;
begin
  ret:=false;
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
    ret:=true;
  finally
    des.Free;
    sou.Free;
    result:=ret;
  end;
end;

function DeCompressFile(const DestFile,SrcFile:String):boolean;
var
  des:TFileStream;
  sou:TMemoryStream;
  decs: TDeCompressionStream;
  Buffer: PChar;
  Count: integer;
  ret:boolean;
begin
  Buffer:=nil;
  ret:=false;
  des:=TFileStream.Create(DestFile,fmCreate);
  sou:= TMemoryStream.Create;
  decs:=nil;
  try
    sou.LoadFromFile(SrcFile);
    sou.Seek(0,soFromBeginning);
    sou.ReadBuffer(count,sizeof(count));
    GetMem(Buffer, Count);
    decs:=TDeCompressionStream.Create(sou);
    decs.ReadBuffer(Buffer^, Count);
    Des.WriteBuffer(Buffer^, Count);
    Des.Position := 0;//复位流指针
    ret:=true;
  finally
    FreeMem(Buffer);
    decs.Free;
    des.Free;
    sou.Free;
    result:=ret;
  end;
end;

function SelDir(const InitPath:String):String;
var
  ret:string;
begin
  ret:='';
  if SelectDirectory(InitPath,'',ret) then
    if ret<>'' then
    begin
      ret:=IncludeTrailingBackslash(ret);
    end;
  result:=ret;
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
        FilesList.Append(TheRootPath + SearchRec.Name);
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
  SysUtils.FindClose(SearchRec);
end;

procedure InvokeExe(const aPathName,aCmdLine:String);
begin
  if aPathName<>'' then
    ShellExecute(Application.Handle,'open',
                PChar(aPathName),
                PChar(aCmdLine),nil,SW_SHOWNORMAL);
end;

function KeyInReg(const KeyName:string;RootName:HKEY):boolean;
var
  reg:TRegistry;
begin
  result:=false;
  Reg:=TRegistry.Create;
  try
    Reg.RootKey := RootName;
    result := Reg.OpenKey(KeyName,false);
  finally
    Reg.CloseKey;
    reg.Free;
  end;
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
  Handle:=FindWindow(Pchar(ClassName),PChar(WindowName));
  if(Handle>0) then
    SendMessage(Handle,WM_CLOSE,0,0);
end;

function DelDir(const Dir:String):boolean;
var
   lpFileOp: TSHFileOpStruct;
begin
   FillChar (lpFileOp, SizeOf (TSHFileOpStruct), #0);//in winnt the line is necessary
   with lpFileOp do
     begin
     Wnd := Application.Handle;
     wFunc := FO_DELETE;
     pFrom := pchar(Dir + #0);
     pTo := nil;
     fFlags := FOF_ALLOWUNDO or FOF_SILENT	or  FOF_NOCONFIRMATION	;
     hNameMappings := nil;
     lpszProgressTitle := nil;
     fAnyOperationsAborted := True;
   end;
   result:=(SHFileOperation(lpFileOp) = 0);
end;

function IsDir(const Dir:String):boolean;
begin
  if Dir='' then
    result:=false
  else
    if Pos(':',Dir)<>2 then
      result:=false
    else
      result:=true;
end;

function GetDiskFreeSize(RootPath:String):int64;
var
  FreeCaller,TotalSize,FreeSize:Int64;
begin
  RootPath:=IncludeTrailingBackslash(RootPath);
  ForceDirectories(RootPath);
  if GetDiskFreeSpaceEx(Pchar(RootPath),FreeCaller,TotalSize,@FreeSize) then
    result:=FreeSize
  else
    result:=-1;
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

function GetWindowsDir:String;
var
  s:String;
  il:integer;
begin
  SetLength(s,MAX_PATH);
  il:=GetWindowsDirectory(pchar(s),MAX_PATH);
  result:=copy(s,0,il);
end;

Function  HaveMakeStartRun(const FileName,sValue:String;UseReg,UseIni:Boolean):Boolean;
var
  ini:Tinifile;
  reg:TRegistry;
  swd:String;
Begin
  swd:=GetWindowsDir+'\'+'system.ini';
  Result := False;
  if UseIni then
  begin
    ini := Tinifile.Create(swd);
    try
      if ini.SectionExists('boot') then
      begin
         Result := True;
      end;
    finally
      ini.Free;
    end;
  end;

  if UseReg then
  begin
    reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if(Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', false))then
      begin
        if Reg.ValueExists(sValue)then
           Result := True;
      end;
    finally
      reg.Free;
    end;
  end;
End;

procedure MakeStartRun(const FileName,sValue:String;UseReg,UseIni,Enable:Boolean);
var
  ini:Tinifile;
  reg:TRegistry;
  swd:String;
begin
  swd:=GetWindowsDir+'\'+'system.ini';
  if Enable then
  begin
    if UseReg then
    begin
      reg := TRegistry.Create;
      try
        Reg.RootKey := HKEY_CURRENT_USER;
        if(Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', true))then
        begin
          Reg.WriteString(sValue,Filename);
          Reg.CloseKey;
        end;
      finally
        reg.Free;
      end;
    end;

    if UseIni then
    begin
      if FileExists(swd) then
      begin
        ini := Tinifile.Create(swd);
        try
          if ini.SectionExists('boot') then
          begin
            swd:='Explorer.exe ' + FileName;
            ini.WriteString('boot','shell',swd);
          end;
        finally
          ini.Free;
        end;
      end;
    end;
  end
  else
  begin
    if UseIni then
    begin
      ini := Tinifile.Create(swd);
      try
        if ini.SectionExists('boot') then
        begin
          swd:='Explorer.exe';
          ini.WriteString('boot','shell',swd);
        end;
      finally
        ini.Free;
      end;
    end;

    if UseReg then
    begin
      reg := TRegistry.Create;
      try
        Reg.RootKey := HKEY_CURRENT_USER;
        if(Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', false))then
        begin
          if Reg.ValueExists(sValue)then
            Reg.DeleteValue(sValue);
        end;
      finally
        reg.Free;
      end;
    end;
  end;
end;

function GetShtPathName(const PathName:String):String;
var
  Buffer : array[0..MAX_PATH] Of char;
  Len:integer;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  Len:=GetShortPathName(PChar(PathName), Buffer, SizeOf(Buffer));
  result:=copy(buffer,0,Len);
end;

function WindowExists(const ClassName,WindowName:String):boolean;
var
  Handle:HWND;
begin
  Handle:=FindWindow(Pchar(ClassName),PChar(WindowName));
  result:=(Handle>0);
end;
{TAppSetupBase}
constructor TAppSetupBase.Create(const aFileName:String);
begin
  FPathName:=aFileName;
  ReadFromFile;
end;

procedure TAppSetupBase.ReadFromFile;
begin
  FIniFile := TIniFile.Create(FPathName);
  try
    ReadIniFile;
  finally
    FIniFile.Free;
  end;
end;

procedure TAppSetupBase.SaveToFile;
begin
  FIniFile := TIniFile.Create(FPathName);
  try
    SaveIniFile;
  finally
    FIniFile.Free;
  end;
end;

procedure TAppSetupBase.ReadIniFile;
begin
  //FMainFormPosX:=FIniFile.ReadInteger('窗口位置','X',0);
  //FMainFormPosY:=FIniFile.ReadInteger('窗口位置','Y',0);
end;

procedure TAppSetupBase.SaveIniFile;
begin
  //FIniFile.WriteInteger('窗口位置','X',FMainFormPosX);
  //FIniFile.WriteInteger('窗口位置','Y',FMainFormPosY);
end;

function GetProgramVersion(path : string;IncludeDot:boolean) : string;
var
  nZero,nSize : cardinal;
  lpData      : pointer;
  p           : pointer;
begin
  result:='Unknown';
  nSize:=GetFileVersionInfoSize(pchar(path),nZero);
  if nSize>0 then
  begin
    getmem(lpData,nSize);
    if GetFileVersionInfo(pchar(path),0,nSize,lpData) then
     if VerQueryValue(lpData,'\',p,nZero) then
      begin
      if IncludeDot then
        result:=inttostr(tVSFIXEDFILEINFO(p^).dwFileVersionMS shr 16)+ '.' +
                inttostr(tVSFIXEDFILEINFO(p^).dwFileVersionMS and $FFFF)+ '.' +
                inttostr(tVSFIXEDFILEINFO(p^).dwFileVersionLS shr 16)+ '.' +
                inttostr(tVSFIXEDFILEINFO(p^).dwFileVersionLS and $FFFF)
      else
        result:=inttostr(tVSFIXEDFILEINFO(p^).dwFileVersionMS shr 16)+
                inttostr(tVSFIXEDFILEINFO(p^).dwFileVersionMS and $FFFF)+
                inttostr(tVSFIXEDFILEINFO(p^).dwFileVersionLS shr 16)+
                inttostr(tVSFIXEDFILEINFO(p^).dwFileVersionLS and $FFFF);
      end;
    freemem(lpData,nSize);
  end;
end;

function GetVerFileVersion(const FileName: String):String;
var
  ini:TiniFile;
  ret:String;
begin
  ini:=TiniFile.Create(FileName);
  try
    ret:=ini.ReadString('Version','VER','0');
  finally
    ini.Free;
  end;
  result:=ret;
end;
end.