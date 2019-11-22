//******************************************************************************
// File:       TParseF10Htm.pas
// Content:    提供解析F10(中国证券网)公告网页内容的相关接口
// Author:     JoySun 2005/7/28
//Doc_DwnHtml-DOC3.0.0需求5-leon-08/8/14; 修改大陆公告收集逻辑；
//******************************************************************************
unit TParseF10Htm;

interface

Uses Windows,Classes,SysUtils,CSDEF,TParseHtmTypes,Dialogs,iniFiles;

//------------------------------------------------------------------------------
// 类型声明
//------------------------------------------------------------------------------
type

  TParseF10HtmMgr=Class
  private
    FTitleLst:TTitleRLst;
    FLastErrMsg:PChar;
    IniFileName :PChar;

    FFormatUrl:string;
    FContinueDo:Boolean; //是否继续进行接下来的网页的解析活动
  protected

  public
    FTeamFilePath:String;
    FDeadLineDate:Double;
    StartGetDate:Double;
    constructor Create(AIniFileName :PChar);
    Destructor Destroy();Override;

   //------------------------------------------------------------------------------
   // 接口声明
   //------------------------------------------------------------------------------
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

  Function ReadStartGetDate(AIniFileName :PChar):Double;

  end;
 // function GetTextAccordingToInifile(InText:string;var OutText:string;InifileName:string):boolean;stdcall;external  'DLLHtmlParser.dll';

implementation

//add by wangjinhua 4.16 - Problem(20100716)
function GetStr(StartTag,EndTag:string;var ASource:String;IncludeTag:Boolean=false;RmvTag:Boolean=true):string;
var
  iEndPos,iStartPos,i:integer;
  sContent,tmpStr:String;
begin
  //ASource := RemoveBeforeStart(BeginTag,ASource);
  Result:='';
  iStartPos := AnsiPos(LowerCase(StartTag),LowerCase(ASource));
  if iStartPos<=0 then exit;
  tmpStr:= copy(ASource,iStartPos+length(StartTag),Length(ASource)-iStartPos-length(StartTag)+1);
  iEndPos := AnsiPos(LowerCase(EndTag),LowerCase(tmpStr));
  if iEndPos<=0 then exit;
  iEndPos:=iEndPos+iStartPos+length(StartTag)-1;
  if IncludeTag then
  begin
    i := iEndPos + Length(EndTag)-iStartPos;
    result := copy(ASource,iStartPos,i);
  end
  else
    result := copy(ASource,iStartPos + Length(StartTag) ,iEndPos - (iStartPos + Length(StartTag)));
   if RmvTag then
    ASource := copy(ASource,iEndPos + Length(EndTag),Length(ASource) - (iEndPos + Length(EndTag)) + 1);
end;

function GetStrOnly2(StartTag,EndTag:string;ASource:String;IncludeTag:Boolean=true):string;
var
  iEndPos,iStartPos:integer;
  sContent,tmpStr:String;
begin
  Result:='';
  iStartPos := AnsiPos(LowerCase(StartTag),LowerCase(ASource));
  if iStartPos<=0 then exit;
  tmpStr:= copy(ASource,iStartPos,Length(ASource)-iStartPos+1);
  tmpStr:= copy(tmpStr,Length(StartTag)+1,Length(tmpStr)-Length(StartTag));
  iEndPos := AnsiPos(LowerCase(EndTag),LowerCase(tmpStr));
  if iEndPos<=0 then exit;
  if IncludeTag then
    result := StartTag+copy(tmpStr,1,iEndPos + Length(EndTag) - 1)
  else
    result := copy(tmpStr,1,iEndPos - 1);
end;

function GetStrOnly2Ex(StartTag,EndTag:string;ASource:String;IncludeTag:Boolean=true):string;
var s:string;
begin
Result:=GetStrOnly2(StartTag,EndTag,ASource,IncludeTag);
if (Copy(Result,1,2) =#13#10) then
  result := Copy(Result,3,Length(result)-2);
if (Copy(Result,Length(result)-1,2) =#13#10) then
  result := Copy(Result,1,Length(result)-2);
end;


function PosEx(aSubStr,aSrcStr:string):Integer;
begin
  Result:=Pos(UpperCase(aSubStr),UpperCase(aSrcStr));
end;

function GetStrToEnd(aTag,aSource:string):string;
var
  iPos:integer;
begin
  Result:='';
  iPos:=Pos(aTag,aSource);
  if iPos>0 then
  begin
    Result:=Copy(aSource,iPos+length(aTag),length(aSource)-(iPos+length(aTag))+1 );
  end;
end;

function MayBeInt(sVar:string):boolean;
var i:integer;
begin
  result:=false;
  sVar:=Trim(sVar);
    if sVar='' then exit;
    if sVar='-' then exit;
    for i:=1 to Length(sVar) do
    begin
      if not (sVar[i] in ['0'..'9']) then
      begin
        exit;
      end;
    end;
    result:=true;
end;

//--

//------------------------------------------------------------------------------
// 接口实现
//------------------------------------------------------------------------------
{ TParseF10HtmMgr }

constructor TParseF10HtmMgr.Create(AIniFileName :PChar);
const CFormatUrl='http://data.eastmoney.com/Notice/NoticeStock.aspx?type=0&stockcode=%s&pn=%d';
var f : TInifile;
begin
   FLastErrMsg:='';
   IniFileName :=AIniFileName;
   FTeamFilePath := ExtractFilePath(IniFileName)+'TParse163Htm.ini';
   FDeadLineDate := ReadStartGetDate(IniFileName);  //***Doc4.2-N001-sun-090610
   try
     f := TIniFile.Create(StrPas(IniFileName));
     FFormatUrl:=f.ReadString('HTMLADDRESS','cn',CFormatUrl);
   finally
     try FreeAndNil(f); except end;
   end;
end;

Function TParseF10HtmMgr._GetHtmlAddress(ID:PChar;StartDateStr:PChar;CurrPage:integer):ShortString; //***Doc4.2-N001-sun-090610

Var
  Year,Month,Day:word;
  DateTime:TDateTime;
begin
  {Result:='http://www.f10.com.cn/ggzx/gsgg.asp?ZQDM='+StrPas(ID)
                 +'&CurrPage='+IntToStr(CurrPage);  }

  FContinueDo := true;
  //***Doc4.2-N001-sun-090610****************
  DateTime:=StrToDate(strpas(StartDateStr));
  DeCodeDate(DateTime,Year,Month,Day);
  StartGetDate:=EncodeDate(Year,Month,Day);
  if StartGetDate<FDeadLineDate then
    StartGetDate := FDeadLineDate;

  //*******************************************
  Result:=Format(FFormatUrl,[StrPas(ID),CurrPage]);
end;

//add by wangjinhua 4.16 - Problem(20100716)
Function TParseF10HtmMgr._GetNowHtmlPage(Const MemoTxt:String;Var PageR:TPageR):Boolean;
const
  SecBeginStr='<div class="Page" id="PageCont">';
  SecEndStr='</div>';
var i,aNum:integer;
  aSec,aItem,aSrcText,aTempStr:string;
  ts:TStringList;
begin
  PageR.NowPage:=0;
  PageR.AllPage:=0;
  aSrcText:=MemoTxt;
  aSrcText:=StringReplace(aSrcText,#13#10,'',[rfReplaceAll]);
  ts:=TStringList.create;
  Try
  Try
      aSec:=GetStrOnly2(SecBeginStr,SecEndStr,aSrcText,false);
      if aSec<>'' then
      begin
        aItem:=GetStrOnly2('<span','</span>',aSec,true);
        aItem:=Trim(GetStrOnly2('>','</span>',aItem,false));
        if MayBeInt(aItem) then
          if TryStrToInt(Trim(aItem),aNum) then
            PageR.NowPage:=aNum;

        aSec:=StringReplace(aSec,'<a',#13#10+'<a',[rfReplaceAll]);
        aSec:=StringReplace(aSec,'</a>','</a>'+#13#10,[rfReplaceAll]);
        ts.text:=aSec;
        for i:=0 to ts.count-1 do
        begin
          if (Pos('<a',ts[i])>0) and
             (Pos('</a>',ts[i])>0) then
          begin
            aTempStr:=ts[i];
            aItem:=Trim(GetStr('>','</a>',aTempStr,false));
            if MayBeInt(aItem) then
              if TryStrToInt(Trim(aItem),aNum) then
              begin
                if (PageR.AllPage<aNum) then
                  PageR.AllPage:=aNum;
              end;
          end;
        end;
      end;

      if (PageR.AllPage = 0) and (PageR.NowPage = 0) then
      begin
        PageR.AllPage := 1;
        PageR.NowPage := 1;
      end;
      Result := (PageR.AllPage > 0) ;
  Except
     On E:Exception Do
       FLastErrMsg := PChar(E.Message);
  End;
  Finally
    FreeAndNil(ts);
  End;
end;


Function TParseF10HtmMgr._GetNowPageTitlesCount(Const MemoTxt:String):Integer;
Const
  ConstStartKeyLine='<div class="cont">';
  ConstEndKeyLine='</div>';
var
  i0,i,j,k:integer;
  tsAry:array[0..3] of TStringlist;
  StrLine,StrLine2:String;
  AddressStr,CaptionStr,DocDateStr:String;
  TitleDate :Double;
  vSource,vAItemSource,vStr:string;
begin
  FLastErrMsg := '';
  Result := 0;
  for i0:=0 to High(tsAry) do
    tsAry[i0]:=TStringList.Create;
  Try
  Try
    //gettext
    if (MemoTxt='')then
    begin
      Result:=0;
      exit;
    end;

    vStr:=MemoTxt;
    vStr:=StringReplace(vStr,#13#10,'',[rfReplaceAll]);
    vSource:=GetStrOnly2(ConstStartKeyLine,ConstEndKeyLine,vStr,true);

    vSource:=StringReplace(vSource,'<li>',#13#10+'<li>',[rfReplaceAll]);
    vSource:=StringReplace(vSource,'</li>','</li>'+#13#10,[rfReplaceAll]);
    tsAry[0].Text:=vSource;
    SetLength(FTitleLst,0);

    for i:=0 to tsAry[0].count-1 do
    begin
      StrLine:=tsAry[0][i];
      if (Pos('<li>',StrLine)>0) and
         (Pos('</li>',StrLine)>0) then
      begin
        StrLine:=StringReplace(StrLine,'<span',#13#10+'<span',[rfReplaceAll]);
        StrLine:=StringReplace(StrLine,'</span>','</span>'+#13#10,[rfReplaceAll]);
        tsAry[1].Text:=StrLine;
        j:=0;
        while j<tsAry[1].Count do
        begin
          //Application.ProcessMessages;
          if not (
            (Pos('<span',tsAry[1][j])>0) and
            (Pos('</span>',tsAry[1][j])>0)
          ) then
          begin
            tsAry[1].Delete(j);
            Continue;
          end;
          Inc(j);
        end;
        if tsAry[1].Count<>3 then
        begin
          FLastErrMsg := PChar('獶箇戳逆计ヘ:'+inttostr(tsAry[1].Count)+'.'+StrLine);
          exit;
        end;

          
        AddressStr:='';
        CaptionStr:='';
        TitleDate:=0;

        AddressStr:=GetStrOnly2('href="','"',tsAry[1][0],false);
        ReplaceSubString('"','',AddressStr);
        if Trim(AddressStr)<>'' then
        begin
          AddressStr:='http://data.eastmoney.com'+AddressStr;
        end;

        CaptionStr:=GetStrOnly2('title="','"',tsAry[1][0],false);
        ReplaceSubString('"','',CaptionStr);
        ReplaceSubString('/','-',CaptionStr);
        ReplaceSubString('〇','0',CaptionStr);

        DocDateStr:= GetStrOnly2('>','</span>',tsAry[1][2],false);
        if Trim(DocDateStr)<>'' then
        begin
          ReplaceSubString('-',DateSeparator,DocDateStr);
          TitleDate:=StrToDate(DocDateStr);
        end;

        if  TitleDate < StartGetDate then
        begin
          FContinueDo := False;
          Break;
        end;

        k := length(FTitleLst);
        SetLength(FTitleLst,k+1);

        FTitleLst[k].Address:=AddressStr;
        FTitleLst[k].Caption:=CaptionStr;
        FTitleLst[k].TitleDate:=TitleDate;
      end;
    end;

    Result := Length(FTitleLst);
  Except
     On E:Exception Do
       FLastErrMsg := PChar(E.Message);
  End;
  Finally
    try
      for i0:=0 to High(tsAry) do
        FreeAndNil(tsAry[i0]);
    except
    end;
  End;
end;

//--

Function TParseF10HtmMgr._GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
Var
 i : Integer;
begin
  FLastErrMsg := '';
  Result := false;
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

Function TParseF10HtmMgr._GetHtmlMemo(Var MemoTxt:String):Boolean;
var
  HtmlTxt:TStringList;
  i,StartP,EndP:integer;
  vSource,vStr,sTitle,sMemo,sLine:string;
begin
  FLastErrMsg := '';
  Result := false;
  Try
  Try
      if (Length(MemoTxt)=0)then exit;
      vStr:=MemoTxt;

      sMemo:=GetStrOnly2Ex('<pre>','</pre>',vStr,false);
      
      vSource:=GetStrOnly2Ex('</pre>','</a>',vStr,true);
      vSource:=GetStrOnly2Ex('<a','</a>',vSource,true);
      sLine:=GetStrOnly2Ex('href="','"',vSource,false);
      sTitle:=GetStrOnly2Ex('<b>','</b>',vSource,false);
      if Pos('点击查看PDF原文',sTitle)>0 then
      begin
        sMemo:=sMemo+#13#10+sTitle+sLine;
      end;
      ReplaceSubString('〇','0',sMemo);
      MemoTxt := sMemo;
      Result := true;
  Except
     On E:Exception Do
       FLastErrMsg := PChar(E.Message);
  End;
  Finally
  End;
end;


Function TParseF10HtmMgr._GetLastErrorMsg():PChar;
begin
  if(FLastErrMsg<>'')then
    Result:=FLastErrMsg;
end;


Function TParseF10HtmMgr.ReadStartGetDate(AIniFileName :PChar):Double;
var
  f:TiniFile;
  Str:string;
  Year,Month,Day:Word;
  DateTime:TDateTime;
begin
try
  f := TIniFile.Create(StrPas(IniFileName));
  Str:=f.ReadString('CONFIG','StartGetDate','1999-01-01');
  DateTime:=StrToDate(Trim(Str));
  DeCodeDate(DateTime,Year,Month,Day);
  result:=EncodeDate(Year,Month,Day);
finally
  f.Free;                                            //by leon 081016
end;
end;



destructor TParseF10HtmMgr.Destroy;
begin
  SetLength(FTitleLst,0);
  //inherited;
end;

end.
