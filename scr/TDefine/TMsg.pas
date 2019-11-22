unit TMsg;

interface
  Uses Forms,Windows,Controls,Dialogs,Classes,SysUtils,
  Menus,StdCtrls,Buttons,TCommon,TypInfo;



type TSystemLanguageType=(sltNone,sltCHS,sltCHT);
var
  sSLType:String;
  SLType:TSystemLanguageType;
{
sltNone:��ֵ
sltCHS:ϵͳ����Ϊ����
sltCHT:ϵͳ����Ϊ����
}


//
{
���º�������Ĳ���msg��Ϊ����,
�����л���Ϊ����ϵͳ��msgת������
�����л���Ϊ����ϵͳ��msg������ת��
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
    PGBCHSStr:   PChar;   //GB����ļ����ַ�
    PGBCHTStr:   PChar;   //GB����ķ����ַ�
    PUnicodeChar:   PWideChar;   //Unicode������ַ�
    PBIG5Str:   PChar;   //BIG5������ַ�
begin
    PGBCHSStr:=PChar(GB2312Str);
    iLen:=MultiByteToWideChar(936,0,PGBCHSStr,-1,nil,0);   //����ת�����ַ���
    GetMem(PGBCHTStr,iLen*2+1);   //�����ڴ�
    LCMapString($0804,LCMAP_TRADITIONAL_CHINESE,PGBCHSStr,-1,PGBCHTStr,iLen*2);   //ת��GB����嵽GB�뷱��
    GetMem(PUnicodeChar,iLen*2);   //�����ڴ�
    MultiByteToWideChar(936,0,PGBCHTStr,-1,PUnicodeChar,iLen);   //ת��GB�뵽Unicode��
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
  vTitle := '��ʾ';
  vMsg := msg;
  vTitle := ConvertStr(vTitle);
  vMsg := ConvertStr(vMsg);
  MessageBox(0,Pchar(vMsg),PChar(vTitle),MB_ICONASTERISK);
end;


procedure MsgWarn(const msg:String);
var
  vMsg,vTitle:String;
begin
  vTitle := '����';
  vMsg := msg;
  vTitle := ConvertStr(vTitle);
  vMsg := ConvertStr(vMsg);
  MessageBox(0,Pchar(vMsg),PChar(vTitle),MB_ICONEXCLAMATION);
end;


function MsgQuery(const msg:String):Boolean;
var
  vMsg,vTitle:String;
begin
  vTitle := 'ѯ��';
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
  vTitle := '����';
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
