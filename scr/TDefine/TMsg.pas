unit TMsg;

interface
  Uses Forms,Windows,Controls,Dialogs,Classes,SysUtils,
  Menus,StdCtrls,Buttons,TCommon,TypInfo;



type TSystemLanguageType=(sltNone,sltCHS,sltCHT);
var
  sSLType:String;
  SLType:TSystemLanguageType;
{
sltNone:空值
sltCHS:系统环境为简体
sltCHT:系统环境为繁体
}


//
{
以下函数传入的参数msg须为简体,
当运行环境为繁体系统则msg转化繁体
当运行环境为简体系统则msg不进行转化
}

  function ConvertStr(msg:string):String;
  procedure MsgHint(const msg:String);
  procedure MsgWarn(const msg:String);
  procedure MsgError(const msg:String);
  function MsgQuery(const msg:String):Boolean;
//--

implementation




function GB2312ToBIG5(GB2312Str:   string):   AnsiString;
var
    iLen:   Integer;
    PGBCHSStr:   PChar;   //GB编码的简体字符
    PGBCHTStr:   PChar;   //GB编码的繁体字符
    PUnicodeChar:   PWideChar;   //Unicode编码的字符
    PBIG5Str:   PChar;   //BIG5编码的字符
begin
    PGBCHSStr:=PChar(GB2312Str);
    iLen:=MultiByteToWideChar(936,0,PGBCHSStr,-1,nil,0);   //计算转换的字符数
    GetMem(PGBCHTStr,iLen*2+1);   //分配内存
    LCMapString($0804,LCMAP_TRADITIONAL_CHINESE,PGBCHSStr,-1,PGBCHTStr,iLen*2);   //转换GB码简体到GB码繁体
    GetMem(PUnicodeChar,iLen*2);   //分配内存
    MultiByteToWideChar(936,0,PGBCHTStr,-1,PUnicodeChar,iLen);   //转换GB码到Unicode码
    iLen:=WideCharToMultiByte(950,0,PUnicodeChar,-1,nil,0,nil,nil);
    GetMem(PBIG5Str,iLen);   
    WideCharToMultiByte(950,0,PUnicodeChar,-1,PBIG5Str,iLen,nil,nil);   
    Result:=string(PBIG5Str);
    FreeMem(PBIG5Str);
    FreeMem(PUnicodeChar);   
    FreeMem(PGBCHTStr);   
end;


function ConvertStr(msg:string):String;
begin
    case SLType of
      sltCHS: Result := msg;
      sltCHT: Result := CGBtoBIG5(msg);
      else raise Exception.create('System language  can not be found !');
    end;
end;


procedure MsgHint(const msg:String);
var
  vMsg,vTitle:String;
begin
  vTitle := '提示';
  vMsg := msg;
  vTitle := ConvertStr(vTitle);
  vMsg := ConvertStr(vMsg);
  MessageBox(0,Pchar(vMsg),PChar(vTitle),MB_ICONASTERISK);
end;


procedure MsgWarn(const msg:String);
var
  vMsg,vTitle:String;
begin
  vTitle := '警告';
  vMsg := msg;
  vTitle := ConvertStr(vTitle);
  vMsg := ConvertStr(vMsg);
  MessageBox(0,Pchar(vMsg),PChar(vTitle),MB_ICONEXCLAMATION);
end;


function MsgQuery(const msg:String):Boolean;
var
  vMsg,vTitle:String;
begin
  vTitle := '询问';
  vMsg := msg;
  vTitle := ConvertStr(vTitle);
  vMsg := ConvertStr(vMsg);
  Result := true;
  if MessageBox(0,Pchar(vMsg),PChar(vTitle),MB_YESNO) = 7     then
    Result := false;
end;


procedure MsgError(const msg:String);
var
  vMsg,vTitle:String;
begin
  vTitle := '错误';
  vMsg := msg;
  vTitle := ConvertStr(vTitle);
  vMsg := ConvertStr(vMsg);
  MessageBox(0,Pchar(vMsg),PChar(vTitle),MB_ICONHAND);
end;


initialization
begin
  sSLType := GetLocaleInformation(LOCALE_SABBREVLANGNAME);
  if sSLType = 'CHS' then
    SLType := sltCHS
  else if sSLType = 'CHT' then
    SLType := sltCHT
  else
    SLType := sltNone;
end;


end.
