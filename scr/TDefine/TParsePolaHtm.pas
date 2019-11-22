//******************************************************************************
// File:       TParsePolaHtm.pas
// Content:    提供解析寶來(http://www.finairport.com/)公告网页内容的相关接口
// Author:     JoySun 2005/8/12
//******************************************************************************
unit TParsePolaHtm;

interface

Uses Windows,Classes,SysUtils,CSDEF,TCommon,TParseHtmTypes;

//------------------------------------------------------------------------------
// 类型声明
//------------------------------------------------------------------------------
type

  TParsePolaHtmMgr=Class
  private
    FTitleLst:TTitleRLst;
    FLastErrMsg:PChar;
  protected

  public

    constructor Create;
    Destructor Destroy();Override;
    //获得网页的地址
    Function _GetHtmlAddress(ID:PChar;CurrPage:integer):ShortString;
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


  end;


implementation
//------------------------------------------------------------------------------
// 接口实现
//------------------------------------------------------------------------------
{ TDwnHttp }

constructor TParsePolaHtmMgr.Create;
begin
   FLastErrMsg:='';
end;
Function TParsePolaHtmMgr._GetHtmlAddress(ID:PChar;CurrPage:integer):ShortString;
begin
  Result:='http://demand.polaris.com.tw/Z/ZC/ZCV/ZCV_'+StrPas(ID)
                +'_E_'+IntToStr(CurrPage)+'.asp.htm';
end;

Function TParsePolaHtmMgr._GetNowHtmlPage(Const MemoTxt:String;Var PageR:TPageR):Boolean;
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

Function TParsePolaHtmMgr._GetNowPageTitlesCount(Const MemoTxt:String):Integer;
var
  i,j,StartP,EndP:integer;
  HtmlTxt:TStringlist;
  StrLine,tCaption:String;
  Year,Month,Day:Word;
  DateTime:TDateTime;
begin
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
      StartP:=Pos('<td class="t3t1"><a href="',StrLine);
      EndP:=Pos('.asp.htm">',StrLine);
      if(StartP>0)and(EndP>0)then
      begin

        j := High(FTitleLst)+1;
        SetLength(FTitleLst,j+1);

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
        ReplaceSubString(',','，',tCaption);
        ReplaceSubString('/','／',tCaption);
        FTitleLst[j].Caption:=tCaption;

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

Function TParsePolaHtmMgr._GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
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

Function TParsePolaHtmMgr._GetHtmlMemo(Var MemoTxt:String):Boolean;
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

    //gettext
    HtmlTxt:=TStringList.Create;
    if (Length(MemoTxt)<>0)then
      HtmlTxt.Text:=MemoTxt
    else
     exit;

    //Parse
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

    StartP:=Pos('<table border="0" width="600">',MemoTxt)+30;
    MemoTxt:=Copy(MemoTxt,StartP,Length(MemoTxt)-StartP);
    EndP:=Pos('<script language="javascript"><!--',MemoTxt);
    MemoTxt:=Copy(MemoTxt,1,EndP-1);

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
      StartP2 := Pos('<TR>',Str_temp);
      While StartP2>0 do
      Begin
        EndP2 := Pos('</TR>',Str_temp);
        Str_temp2:=Copy(Str_temp,StartP2+Length('<TR>'),EndP2-StartP2-Length('<TR>'));
        ReplaceSubString(#$D#$A,'  ',Str_temp2);
        HtmlTxt.Add(Str_temp2);
        ReplaceSubString(Copy(Str_temp,StartP2,EndP2-StartP2+Length('</TR>')),'',Str_temp);
        StartP2 := Pos('<TR>',Str_temp);
      End;
      Str_temp:=HtmlTxt.Text;
      HtmlTxt.Clear;

      ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP+Length('</TABLE>')),Str_temp,MemoTxt);
    end;
    //---------------------------------------------------


    //add by JoySun 2005/10/24 拆分<P></P> 保持原有的行格式
    //---------------------------------------------------
    HtmlTxt.Clear;
    StartP := Pos('<P>',MemoTxt);
    if(StartP<>1)then
    begin
      Str_temp2:=Copy(MemoTxt,0,StartP-1);
      ReplaceSubString(#$D#$A,'  ',Str_temp2);
      HtmlTxt.Add(Str_temp2);
      ReplaceSubString(Copy(MemoTxt,0,StartP-1),'',MemoTxt);
    end;

    StartP := Pos('<P>',MemoTxt);
    While StartP>0 do
    Begin
      EndP := Pos('</P>',MemoTxt);
      HtmlTxt.Add(Copy(MemoTxt,StartP+Length('<P>'),EndP-StartP-Length('<P>')));
      ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP+Length('</P>')),'',MemoTxt);
      StartP := Pos('<P>',MemoTxt);
    End;

    MemoTxt:=HtmlTxt.Text;
    HtmlTxt.Clear;
    //--------------------------------------------------------

    StartP := Pos('<',MemoTxt);
    While StartP>0 do
    Begin
      EndP := Pos('>',MemoTxt);
      ReplaceSubString(Copy(MemoTxt,StartP,EndP-StartP+1),'',MemoTxt);
      StartP := Pos('<',MemoTxt);
    End;
    ReplaceSubString('&NBSP;',' ',MemoTxt);
    ReplaceSubString('#13#10','',MemoTxt);

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

Function TParsePolaHtmMgr._GetLastErrorMsg():PChar;
begin

  Result  := '';
  if(FLastErrMsg<>'')then
    Result:=FLastErrMsg;

end;

destructor TParsePolaHtmMgr.Destroy;
begin
  SetLength(FTitleLst,0);
  //inherited;
end;

end.
