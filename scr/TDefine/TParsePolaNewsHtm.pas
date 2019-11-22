    //******************************************************************************
// File:       TParsePolaNewsHtm.pas
// Content:    提供解析寶來新闻(http://www.finairport.com/)公告网页内容的相关接口
// Author:     JoySun 2006/2/12
//******************************************************************************
unit TParsePolaNewsHtm;

interface

Uses Windows,Classes,SysUtils,CSDEF,TCommon,TParseHtmTypes,Dialogs;

//------------------------------------------------------------------------------
// 类型声明
//------------------------------------------------------------------------------
type

  TParsePolaNewsHtmMgr=Class
  private
    FTitleLst:TTitleRLst;
    FLastErrMsg:PChar;
  protected

  public

    constructor Create;
    Destructor Destroy();Override;
    //获得当前页面公告标题总数
    Function _GetNowPageTitlesCount(Const MemoTxt:String):Integer;
    //获得当前页面公告标题内容
    Function _GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
    //获得当前页面公告内容
    Function _GetHtmlMemo(Var MemoTxt:String):Boolean;
    //获得当前错误信息
    Function _GetLastErrorMsg():PChar;


  end;


implementation
//------------------------------------------------------------------------------
// 接口实现
//------------------------------------------------------------------------------
{ TDwnHttp }

constructor TParsePolaNewsHtmMgr.Create;
begin
   FLastErrMsg:='';
end;

Function TParsePolaNewsHtmMgr._GetNowPageTitlesCount(Const MemoTxt:String):Integer;
var
  i,j,StartP,EndP:integer;
  HtmlTxt:TStringlist;
  StrLine,tCaption:String;
  Year,Month,Day:Word;
  DateTime:TDateTime;
  iPos:Integer;

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
    iPos:=Pos(CGBToBIg5('<div class="t11">日期:'),HtmlTxt.Text);
    if(iPos>0)then
    begin
      StrLine:=GetStrOnly2(CGBToBIg5('<div class="t11">日期:'),'&nbsp;',HtmlTxt.Text,false);
      {StrLine:=Trim(Copy(HtmlTxt.Text,
                         Pos(,HtmlTxt.Text)+Length(CGBToBIg5('<div class="t11">日期:')),
                         8
                         )); }
      //showmessage('StrLine:'+StrLine);
      //StrLine:=IntToStr(StrToInt(Trim(Copy(StrLine,1,2)))+1911)+Trim('-'+Copy(StrLine,4,2)+'-'+Copy(StrLine,7,2));
      //DateSeparator:='-';
      DateTime:=TwDateStrToDate(StrLine);
      DeCodeDate(DateTime,Year,Month,Day);
    end;

    SetLength(FTitleLst,0);
    for i:=0 to HtmlTxt.Count-1 do
    begin
      StrLine:=Trim(HtmlTxt.Strings[i]);
      //modify by wangjinhua 091007
      {StartP:=Pos('<td class="t3t1"><a href="',StrLine);
      EndP:=Pos('.asp.htm">',StrLine);}
      StartP:=Pos(StartTag,StrLine);
      EndP:=Pos(EndTag,StrLine);
      ///--

      if(StartP>0)and(EndP>0)then
      begin
        j := High(FTitleLst)+1;
        SetLength(FTitleLst,j+1);

        //modify by wangjinhua 091007
        {
        //Address
        FTitleLst[j].Address:='http://demand.polaris.com.tw'
                      +Trim(Copy(StrLine,StartP+26,EndP-StartP-26))+'.asp.htm';
        //Caption
        tCaption:=Trim(Copy(StrLine,EndP+10,Pos('</a>',StrLine)-EndP-10));
        //*******
        //判断格式中</a></td></tr>是否换行 2005/9/29
        if(Length(tCaption)=0) and (Pos(Trim(HtmlTxt.Strings[i+1]),'</a></td></tr>')=1)then
          tCaption:=Trim(Copy(StrLine,EndP+10,Length(StrLine)-EndP-10+1));
        //*******
        }
        //Address
        FTitleLst[j].Address:='http://jdata.yuanta.com.tw'
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
        FTitleLst[j].Caption:=tCaption;
        //TiltleDate
        FTitleLst[j].TitleDate:=EncodeDate(Year,Month,Day);
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
  End;
end;



Function TParsePolaNewsHtmMgr._GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
Var
 i : Integer;
begin
  FLastErrMsg := '';
  Result := False;

  Try

    if High(FTitleLst)<>High(TitleLst) Then
      exit;

    for i:=0 to High(FTitleLst) do
      TitleLst[i]:=FTitleLst[i];

    SetLength(FTitleLst,0);
    
    Result := True;

  Except
    on e:Exception Do
      FLastErrMsg := PChar(E.Message);
  End;

end;

Function TParsePolaNewsHtmMgr._GetHtmlMemo(Var MemoTxt:String):Boolean;
var
  HtmlTxt:TStringList;
  i,StartP,EndP,StartP2,EndP2:integer;
  Str_temp,Str_temp2:String;
begin

  FLastErrMsg := '';
  Result := False;
  //create
  HtmlTxt:=TStringList.Create;
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
    HtmlTxt:=TStringList.Create;
    if (Length(MemoTxt)<>0)then
      HtmlTxt.Text:=MemoTxt
    else
     exit;

    for i:=0 to HtmlTxt.Count-1 do
    begin
      if Pos(CGbToBig5('相关个股:'),HtmlTxt.Strings[i])>0 Then
      Begin
        HtmlTxt.Delete(i);
        Break;
      End;
    end;

    MemoTxt := HtmlTxt.Text;
    HtmlTxt.Clear;

    //Replace
    StartP:=Pos('<tr><td class="p1"><P>'+CGBToBIg5('精实新闻'),MemoTxt);
    EndP:=Pos(CGBToBIg5('报导</P>'),MemoTxt)+Length(CGBToBIg5('报导</P>'));
    if Length(MemoTxt)>0 then
    begin
      if(StartP>0)and(EndP>0)then
        ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP),'',MemoTxt);
    end;

    //add by JoySun 2005/10/24 处理Table格式
    //---------------------------------------------------
    StartP := Pos('<TABLE',MemoTxt);
    if(StartP>0)then
    begin
      EndP := Pos('</TABLE>',MemoTxt);
      Str_temp:=Copy(MemoTxt,StartP,EndP-StartP+Length('</TABLE>'));

      HtmlTxt.Clear;
      StartP2 := Pos('<TR',Str_temp);
      i:=0;
      While StartP2>0 do
      Begin
        inc(i);
        if(i>1000)then break;
        EndP2 := Pos('</TR>',Str_temp);
        if EndP2=0 then break;
        Str_temp2:=Copy(Str_temp,StartP2,EndP2-StartP2);
        ReplaceSubString(#13#10,'  ',Str_temp2);
        HtmlTxt.Add(Str_temp2);
        ReplaceSubString_first(Copy(Str_temp,StartP2,EndP2-StartP2+Length('</TR>')),'',Str_temp);
        StartP2 := Pos('<TR',Str_temp);
      End;
      Str_temp:=HtmlTxt.Text;
      HtmlTxt.Clear;

      ReplaceSubString_first(Copy(MemoTxt,StartP,EndP-StartP+Length('</TABLE>')),Str_temp,MemoTxt);
    end;
    //---------------------------------------------------


    //add by JoySun 2005/10/24 拆分<P></P> 保持原有的行格式
    //---------------------------------------------------
    {HtmlTxt.Clear;
    StartP := Pos('<P>',MemoTxt);
    if(StartP>0)and(StartP<>1)then
    begin
      Str_temp2:=Copy(MemoTxt,0,StartP-1);
      ReplaceSubString(#$D#$A,'  ',Str_temp2);
      HtmlTxt.Add(Str_temp2);
      ReplaceSubString(Copy(MemoTxt,0,StartP-1),'',MemoTxt);
    end;

    StartP := Pos('<P',MemoTxt);
    While StartP>0 do
    Begin
      EndP := Pos('</P>',MemoTxt);
      HtmlTxt.Add(Copy(MemoTxt,StartP+Length('<P'),EndP-StartP-Length('<P')));
      ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP+Length('</P>')),'',MemoTxt);
      StartP := Pos('<P',MemoTxt);
    End;

    if(Length(HtmlTxt.Text)>0)then            
      MemoTxt:=HtmlTxt.Text;
    HtmlTxt.Clear;   }
    //--------------------------------------------------------

    StartP := Pos('<',MemoTxt);
    i:=0;
    While StartP>0 do
    Begin
      inc(i);
      if(i>10000)then break;
      EndP := Pos('>',MemoTxt);
      if EndP=0 then break;
      //保持原有的换行
      if(Pos('<BR',Copy(MemoTxt,StartP,EndP-StartP+1))=1)then
        ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP+1),#13#10,MemoTxt)
      else
        ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP+1),'',MemoTxt);
      StartP := Pos('<',MemoTxt);
    End;
    ReplaceSubString('&NBSP;',' ',MemoTxt);

    //去掉第一行的空格
    if(Pos(#13#10,MemoTxt)=1)then
      MemoTxt := Copy(MemoTxt,Length(#13#10)+1,Length(MemoTxt)-Length(#13#10));

    Result := True;

  Except
    On E:Exception Do
      FLastErrMsg := PChar(E.Message);
  End;

  //free
  Finally
    if Assigned(HtmlTxt)then
      HtmlTxt.Free;
  End;

end;

Function TParsePolaNewsHtmMgr._GetLastErrorMsg():PChar;
begin

  Result  := '';
  if(FLastErrMsg<>'')then
    Result:=FLastErrMsg;

end;

destructor TParsePolaNewsHtmMgr.Destroy;
begin
  SetLength(FTitleLst,0);
  //inherited;
end;

end.
