//******************************************************************************
// File:       TParseYuanTaHtm.pas
// Content:    提供解析元大京華(http://www.yuanta.com.tw)公告网页内容的相关接口
// Author:     JoySun 2005/8/5
//Doc_DwnHtml-DOC3.0.0需求5-leon-08/8/14;
//******************************************************************************
unit TParseYuanTaHtm;

interface

Uses Windows,Classes,SysUtils,CSDEF,TCommon,TParseHtmTypes,Dialogs,iniFiles;

//------------------------------------------------------------------------------
// 类型声明
//------------------------------------------------------------------------------
type

  TParseYuanTaHtmMgr=Class
  private
    FTitleLst:TTitleRLst;
    FLastErrMsg:PChar;
    IniFileName :PChar;
    FHtmlTxt,FTempTs:TStringList;

    FContinueDo:Boolean; //是否继续进行接下来的网页的解析活动
  protected

  public
    FDeadLineDate:Double;
    StartGetDate:Double;

    constructor Create(AIniFileName :PChar);
    Destructor Destroy();Override;
    //获得网页的地址
    Function _GetHtmlAddress(ID:PChar;StartDateStr:PChar;CurrPage:integer):ShortString; //***Doc4.2-N001-sun-090610
    //获得网页的当前页面和总页面数
    Function _GetNowHtmlPage(Const MemoTxt:String;Var PageR:TPageR):Boolean;
    //获得当前页面公告标题总数
    Function _GetNowPageTitlesCount(Const MemoTxt:String):Integer;
    //获得当前页面公告标题内容
    Function _GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
    //获得当前页面公告内容
    Function _GetHtmlMemo(Var MemoTxt:String):Boolean;
    //获得当前错误信息
    Function _GetLastErrorMsg():PChar;

    // Function ReadStartGetDate(AIniFileName :PChar):Double; //***Doc4.2-N001-sun-090610
    Function ReadStartGetDate(StartDateStr:PChar):Double;    //***Doc4.2-N001-sun-090610
    function HtmlTableToStrTable(aHtmlTable:string):string;

  end;


implementation


function RplHtmlZhuanYi(aInput:string):string;
begin
  result:=aInput;
  ReplaceSubString('&NBSP;',' ',result);
  ReplaceSubString('&nbsp;',' ',result);
  ReplaceSubString('&quot;','"',result);
  ReplaceSubString('&QUOT;','"',result);
  ReplaceSubString('&amp;','&',result);
  ReplaceSubString('&AMP;','&',result);
  ReplaceSubString('&lt;','<',result);
  ReplaceSubString('&LT;','<',result);
  ReplaceSubString('&gt;','>',result);
  ReplaceSubString('&GT;','>',result);
end;

function RplHtmlHuanHang(MemoTxt:string):string;
begin
  result:=MemoTxt;
  ReplaceSubString('</tr>',#13#10,MemoTxt);
  ReplaceSubString('</Tr>',#13#10,MemoTxt);
  ReplaceSubString('</TR>',#13#10,MemoTxt);
  ReplaceSubString('</tR>',#13#10,MemoTxt);
  ReplaceSubString('<P>',#13#10,MemoTxt);
  ReplaceSubString('<p>',#13#10,MemoTxt);
  ReplaceSubString('</P>',#13#10,MemoTxt);
  ReplaceSubString('</p>',#13#10,MemoTxt);
  ReplaceSubString('<h3>',#13#10,MemoTxt);
  ReplaceSubString('</h3>',#13#10,MemoTxt);
  ReplaceSubString('<H3>',#13#10,MemoTxt);
  ReplaceSubString('</H3>',#13#10,MemoTxt);

  ReplaceSubString('<br>',#13#10,MemoTxt);
  ReplaceSubString('<Br>',#13#10,MemoTxt);
  ReplaceSubString('<BR>',#13#10,MemoTxt);
  ReplaceSubString('<bR>',#13#10,MemoTxt);
  result:=MemoTxt;
end;

function RmvHtmlTag2(MemoTxt:string):string;
var
  i,StartP,EndP,StartP2,EndP2:integer;
  Str_temp,Str_temp2:String;
begin
    StartP := Pos('<',MemoTxt);
    i:=0;
    While StartP>0 do
    Begin
      inc(i);
      if(i>10000)then break;
      EndP := Pos('>',MemoTxt);
      if EndP=0 then break;
      ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP+1),'',MemoTxt);
      StartP := Pos('<',MemoTxt);
    End;
    result:=MemoTxt;
end;


//------------------------------------------------------------------------------
// 接口实现
//------------------------------------------------------------------------------
{ TDwnHttp }

constructor TParseYuanTaHtmMgr.Create(AIniFileName :PChar);
var
  f:TiniFile;
  Str:string;
  Year,Month,Day:Word;
  DateTime:TDateTime;
begin
  FLastErrMsg:='';
  FDeadLineDate:=StrToDate('1999/01/01'); 
  IniFileName :=AIniFileName;
  FHtmlTxt:=TStringList.create;
  FTempTs:=TStringList.create;
try
  f := TIniFile.Create(StrPas(IniFileName));
  Str:=f.ReadString('CONFIG','StartGetDate','1999/01/01');   //by leon 081016
  DateTime:=StrToDate(Trim(Str));
  DeCodeDate(DateTime,Year,Month,Day);
  FDeadLineDate:=EncodeDate(Year,Month,Day);
Finally
  f.Free;
end;
end;
 {
begin
   FLastErrMsg:='';
   IniFileName :=AIniFileName;
   FDeadLineDate := ReadStartGetDate(IniFileName);
   //StartGetDate:= ReadStartGetDate(IniFileName);  //***Doc4.2-N001-sun-090610
end;  }


Function TParseYuanTaHtmMgr._GetHtmlAddress(ID:PChar;StartDateStr:PChar;CurrPage:integer):ShortString;   //***Doc4.2-N001-sun-090610****************
Var
  f : TInifile;
begin
  FContinueDo := true;
  //***Doc4.2-N001-sun-090610****************
  StartGetDate := ReadStartGetDate(StartDateStr);
  if StartGetDate<FDeadLineDate then
    StartGetDate := FDeadLineDate;
  //*******************************************
  f := TIniFile.Create(StrPas(IniFileName));
  Try
    Result:='http://'+f.ReadString('HTMLADDRESS','YUANTA','justdata.yuanta.com.tw')+'/Z/ZC/ZCV/ZCV_'+StrPas(ID)
                +'_E_'+IntToStr(CurrPage)+'.asp.htm';
  Finally

   f.Free;
  end;
end;


Function TParseYuanTaHtmMgr._GetNowHtmlPage(Const MemoTxt:String;Var PageR:TPageR):Boolean;
var
  i,StartP,EndP:integer;
  HtmlTxt:TStringlist;
  Str_temp:String;
begin

  FLastErrMsg := '';
  Result := false;
  PageR.NowPage := 0;
  PageR.AllPage := 0;
  HtmlTxt:=TStringList.Create;
  Try
  Try
    //gettext
    if Length(MemoTxt)<>0 then
      HtmlTxt.Text:=MemoTxt
    else
     exit;

    for i:=0 to HtmlTxt.Count-1 do
    begin
      HtmlTxt.Strings[i]:=Trim(HtmlTxt.Strings[i]);
      StartP:=Pos(CGBToBIg5('页次:<FONT COLOR="Red">'),HtmlTxt.Strings[i]);
      EndP:=Pos('</FONT>',HtmlTxt.Strings[i]);
      if(StartP>0)and(EndP>0)then
      begin
        Str_temp:=Trim(Copy(HtmlTxt.Strings[i],StartP+23,EndP-StartP-23));
        PageR.NowPage:=StrToInt(Trim(Copy(Str_temp,0,Pos('/',Str_temp)-1)));
        PageR.AllPage:=StrToInt(Trim(Copy(Str_temp,Pos('/',Str_temp)+1,Length(Str_temp)-Pos('/',Str_temp))));
      end;
    end;

    Result := true;

  Except
     On E:Exception Do
       FLastErrMsg := PChar(E.Message);
  End;
  Finally
    if Assigned(HtmlTxt)then
      HtmlTxt.Free;
  End;

end;



Function TParseYuanTaHtmMgr._GetNowPageTitlesCount(Const MemoTxt:String):Integer;
var
  i,j,StartP,EndP:integer;
  HtmlTxt:TStringlist;
  StrLine,tCaption:String;
  Year,Month,Day:Word;
  DateTime:TDateTime;
  f : TInifile;
  AddressStr,CaptionStr:String;
  TitleDate :Double;

  StartTag,EndTag:String; //add by wangjinhua 091007
  StartTagLen,EndTagLen:Integer; //add by wangjinhua 091007
begin
  //add by wangjinhua 091007
  StartTag := '<td class="t3t1"><a href="';
  EndTag := '.djhtm">';
  StartTagLen := Length(StartTag);
  EndTagLen := Length(EndTag);
  //--

  FLastErrMsg := '';
  Result := 0;
  HtmlTxt:=TStringList.Create;
  Try
  Try
    //gettext
    if Length(MemoTxt)>0 then
      HtmlTxt.Text:=MemoTxt
    else
      exit;

    SetLength(FTitleLst,0);
    for i:=0 to HtmlTxt.Count-1 do
    begin
      StrLine:=Trim(HtmlTxt.Strings[i]);
      //modify by wangjinhua 091007
      {StartP:=Pos('<td class="t3t1"><a href="',StrLine);
      EndP:=Pos('.asp.htm">',StrLine);}
      StartP:=Pos(StartTag,StrLine);
      EndP:=Pos(EndTag,StrLine);
      //--

      if(StartP>0)and(EndP>0)then
      begin
       // j := High(FTitleLst)+1;
       // SetLength(FTitleLst,j+1);

        //Address
        f := TIniFile.Create(StrPas(IniFileName));
        {FTitleLst[j].Address}
        //modify by wangjinhua 091007
        {
        AddressStr:='http://'+f.ReadString('HTMLADDRESS','YUANTA','justdata.yuanta.com.tw')
                      +Trim(Copy(StrLine,StartP+26,EndP-StartP-26))+'.asp.htm';
        //Caption
        tCaption:=Trim(Copy(StrLine,EndP+10,Pos('</a>',StrLine)-EndP-10));
        //*******
        //判断格式中</a></td></tr>是否换行 2005/9/29
        if(Length(tCaption)=0) and (Pos(Trim(HtmlTxt.Strings[i+1]),'</a></td></tr>')=1)then
          tCaption:=Trim(Copy(StrLine,EndP+10,Length(StrLine)-EndP-10+1));
        }
        AddressStr:='http://'+f.ReadString('HTMLADDRESS','YUANTA','justdata.yuanta.com.tw')
                      +Trim(Copy(StrLine,StartP+StartTagLen,EndP-StartP-StartTagLen))+'.djhtm';
        //Caption
        tCaption:=Trim(Copy(StrLine,EndP+EndTagLen,Pos('</a>',StrLine)-EndP-EndTagLen));
        //*******
        //判断格式中</a></td></tr>是否换行 2005/9/29
        if(Length(tCaption)=0) and (Pos(Trim(HtmlTxt.Strings[i+1]),'</a></td></tr>')=1)then
          tCaption:=Trim(Copy(StrLine,EndP+EndTagLen,Length(StrLine)-EndP-EndTagLen+1));
        //*******
        //--

        ReplaceSubString(',','，',tCaption);
        ReplaceSubString('/','／',tCaption);
        {FTitleLst[j].Caption}CaptionStr:=tCaption;

        //TiltleDate
        StrLine:=Trim(HtmlTxt.Strings[i-1]);
        StartP:=Pos('<tr><td class="t3t1">',StrLine);
        EndP:=Pos('</td>',StrLine);
        StrLine:=Trim(Copy(StrLine,StartP+21,EndP-StartP-21));

        StartP:=Pos('/',StrLine);
        StrLine:=IntToStr(StrToInt(Trim(Copy(StrLine,1,StartP-1)))+1911)
                      +Trim(Copy(StrLine,StartP,Length(StrLine)-StartP+1));
        DateSeparator:='/';
        DateTime:=StrToDate(StrLine);
        DeCodeDate(DateTime,Year,Month,Day);
        {FTitleLst[j].TitleDate}TitleDate:=EncodeDate(Year,Month,Day);
//--------------------------------------------------------------------------- //Doc_DwnHtml-DOC3.0.0需求5-leon-08/8/14-add;
      if  TitleDate >= StartGetDate then
      begin
        j := High(FTitleLst)+1;
        SetLength(FTitleLst,j+1);
        FTitleLst[j].Address:=AddressStr;
        FTitleLst[j].Caption:=CaptionStr;
        FTitleLst[j].TitleDate:=TitleDate;
      end
      else begin
        FContinueDo := False;
        break;
      end;
//---------------------------------------------------------------------------
      end;
    end;

    Result := High(FTitleLst)+1;

  Except
     On E:Exception Do
       FLastErrMsg := PChar(E.Message);
  End;
  Finally
    if Assigned(HtmlTxt)then
      HtmlTxt.Free;
    if Assigned(f)then
      f.Free;
  End;
end;


Function TParseYuanTaHtmMgr._GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
Var
 i : Integer;
begin
  FLastErrMsg := '';
  Result := False;

  Try
    if High(FTitleLst)<>High(TitleLst) Then exit;
    for i:=0 to High(FTitleLst) do
      TitleLst[i]:=FTitleLst[i];
    SetLength(FTitleLst,0);
    Result := FContinueDo;
  Except
    on e:Exception Do
      FLastErrMsg := PChar(E.Message);
  End;
end;

Function TParseYuanTaHtmMgr._GetHtmlMemo(Var MemoTxt:String):Boolean;
var  i,StartP,EndP,StartP2,EndP2,iCycle:integer;
  Str_temp,Str_temp2,sMem,sLine,sTagBegin,sTagEnd:String;
begin
  FLastErrMsg := '';
  Result := False;
  Try
  Try
    if (Length(MemoTxt)=0)then exit;
    
    //gettext
    StartP:=Pos('<table border="0" width="600">',MemoTxt)+30;
    MemoTxt:=Copy(MemoTxt,StartP,Length(MemoTxt)-StartP);
    if(Pos('<a href="javascript:',MemoTxt)>0)then
      EndP:=Pos('<a href="javascript:',MemoTxt)
    else if (Pos('<script language="javascript"><!--',MemoTxt)>0)then
      EndP:=Pos('<script language="javascript"><!--',MemoTxt);
    MemoTxt:=Copy(MemoTxt,1,EndP-1);

    //Parse
    FHtmlTxt.clear;
    if (Length(MemoTxt)<>0)then
      FHtmlTxt.Text:=MemoTxt
    else
     exit;
    for i:=0 to FHtmlTxt.Count-1 do
    begin
      if Pos('闽:',FHtmlTxt.Strings[i])>0 Then
      Begin
        FHtmlTxt.Delete(i);
        Break;
      End;
    end;
    MemoTxt := FHtmlTxt.Text;
    FHtmlTxt.Clear;

    //Replace
    StartP:=Pos('<tr><td class="p1"><P>'+'弘龟穝籇',MemoTxt);
    EndP:=Pos('厨旧</P>',MemoTxt)+Length('厨旧</P>');
    if Length(MemoTxt)>0 then
    begin
      if(StartP>0)and(EndP>0)then
        ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP),'',MemoTxt);
    end;

    MemoTxt:=StringReplace(MemoTxt,#13#10,'',[rfReplaceAll]);
    for iCycle:=1 to 30 do
    begin
      sTagBegin:='<TBODY>';
      sTagEnd:='</TBODY>';
      sMem:=GetStrOnly2(sTagBegin,sTagEnd,MemoTxt,false);
      if sMem='' then
        break;
      sLine:=HtmlTableToStrTable(sTagBegin+sMem+sTagEnd);
      Str_temp:=sTagBegin+sMem+sTagEnd;
      MemoTxt:=StringReplace(MemoTxt,Str_temp,sLine,[rfReplaceAll]);
      Str_temp:=LowerCase(sTagBegin)+sMem+LowerCase(sTagEnd);
      MemoTxt:=StringReplace(MemoTxt,Str_temp,sLine,[rfReplaceAll]);
    end;

    MemoTxt:=RplHtmlZhuanYi(MemoTxt);
    MemoTxt:=RplHtmlHuanHang(MemoTxt);
    MemoTxt:=StringReplace(MemoTxt,'<div class="p01">',#13#10+'<div class="p01">',[rfReplaceAll]);
    //MemoTxt:=RmvHtmlTag_SaveUrl(MemoTxt);
    MemoTxt:=RmvHtmlTag2(MemoTxt);

    FHtmlTxt.text:=MemoTxt;
    while FHtmlTxt.Count>0 do
    begin
      if Trim(FHtmlTxt[FHtmlTxt.Count-1])='' then
        FHtmlTxt.delete(FHtmlTxt.Count-1)
      else
        break;
    end;
    MemoTxt:=FHtmlTxt.text;

    //奔材︽
    if(Pos(#13#10,MemoTxt)=1)then
      MemoTxt := Copy(MemoTxt,Length(#13#10)+1,Length(MemoTxt)-Length(#13#10));
    Result := True;
  Except
    On E:Exception Do
      FLastErrMsg := PChar(E.Message);
  End;
  //free
  Finally
  End;
end;

Function TParseYuanTaHtmMgr._GetLastErrorMsg():PChar;
begin

  Result  := '';
  if(FLastErrMsg<>'')then
    Result:=FLastErrMsg;

end;

//***Doc4.2-N001-sun-090610**********************************************
{
Function TParseYuanTaHtmMgr.ReadStartGetDate(AIniFileName :PChar):Double;
var
  f:TiniFile;
  Str:string;
  Year,Month,Day:Word;
  DateTime:TDateTime;
begin
try
  f := TIniFile.Create(StrPas(IniFileName));
  Str:=f.ReadString('CONFIG','StartGetDate','1999/01/01');   //by leon 081016
  DateTime:=StrToDate(Trim(Str));
  DeCodeDate(DateTime,Year,Month,Day);
  result:=EncodeDate(Year,Month,Day);
Finally
  f.Free;
end;
end;  }

Function TParseYuanTaHtmMgr.ReadStartGetDate(StartDateStr:PChar):Double;
var
  Str:string;
  Fstr : Char;
  Year,Month,Day:Word;
  DateTime:TDateTime;
begin
    Str := StartDateStr;
    Fstr := DateSeparator;
    try
      DateSeparator:='-';
      DateTime:=StrToDate(Trim(Str));
      DeCodeDate(DateTime,Year,Month,Day);
      result:=EncodeDate(Year,Month,Day);
    Finally
      DateSeparator := Fstr;
    end;
end;

function TParseYuanTaHtmMgr.HtmlTableToStrTable(aHtmlTable:string):string;
var i,j,k,iCol:integer;
  sLine,sMem:string; aAryLen:array of integer;  cStrLst:_cStrLst2;

  procedure SetColLen(aInputCol:integer;aInputColStr:string);
  var ix:integer;
  begin
    if aInputCol>=High(aAryLen) then
    begin
      SetLength(aAryLen,aInputCol+1);
      aAryLen[aInputCol]:=0;
    end;
    if aAryLen[aInputCol]<Length(aInputColStr) then
      aAryLen[aInputCol]:=Length(aInputColStr);
  end;
  function GetColLenStr(aInputCol:integer;aInputColStr:string):string;
  var ix,ix2:integer;
  begin
    result:=aInputColStr;
    ix2:=aAryLen[aInputCol]-Length(aInputColStr);
    if ix2>0 then
    begin
      for ix:=1 to ix2 do
        result:=result+' ';
    end;
  end;
begin
  try
    result:=aHtmlTable;
    sMem:=aHtmlTable;
    while True do
    begin
      if Pos('  ',sMem)<=0 then
        break;
      sMem:=StringReplace(sMem,'  ',' ',[rfReplaceAll]);
    end;
    sMem:=StringReplace(sMem,#13#10,'',[rfReplaceAll]);
    sMem:=StringReplace(sMem,'<tr',#13#10+'<tr',[rfReplaceAll]);
    sMem:=StringReplace(sMem,'<TR',#13#10+'<TR',[rfReplaceAll]);
    sMem:=StringReplace(sMem,'</td>','%tagtd%',[rfReplaceAll]);
    sMem:=StringReplace(sMem,'</TD>','%tagtd%',[rfReplaceAll]);
    sMem:=RplHtmlZhuanYi(sMem);
    sMem:=RmvHtmlTag2(sMem);

    FTempTs.clear;
    FTempTs.text:=sMem;
    for i:=0 to FTempTs.count-1 do
    begin
      if Pos('%tagtd%',FTempTs[i])>0 then
      begin
        sLine:=FTempTs[i];
        //sLine:=StringReplace(sLine,'%tagtd%',#13#10,[rfReplaceAll]);
        cStrLst:=DoStrArray2(sLine,'%tagtd%');
        for j:=0 to High(cStrLst) do
          SetColLen(j,cStrLst[j]);
      end;
    end;

    for i:=0 to FTempTs.count-1 do
    begin
      if Pos('%tagtd%',FTempTs[i])>0 then
      begin
        sLine:=FTempTs[i];
        //sLine:=StringReplace(sLine,'%tagtd%',#13#10,[rfReplaceAll]);
        cStrLst:=DoStrArray2(sLine,'%tagtd%');
        for j:=0 to High(cStrLst) do
        begin
          if j=0 then sLine:=GetColLenStr(j,cStrLst[j])
          else sLine:=sLine+#9+GetColLenStr(j,cStrLst[j]);
        end;
        FTempTs[i]:=sLine;
      end;
    end;
    while FTempTs.count>0 do
    begin
      if Trim(FTempTs[0])='' then
        FTempTs.Delete(0)
      else
        break;
    end;
    while FTempTs.count>0 do
    begin
      if Trim(FTempTs[FTempTs.count-1])='' then
        FTempTs.Delete(FTempTs.count-1)
      else
        break;
    end;

    result:=FTempTs.text;
  finally
    SetLength(aAryLen,0);
  end;
end;

destructor TParseYuanTaHtmMgr.Destroy;
begin
  SetLength(FTitleLst,0);
  FreeAndNil(FHtmlTxt);
  FreeAndNil(FTempTs);
  //inherited;
end;

end.
