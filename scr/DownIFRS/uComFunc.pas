unit uComFunc;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls,IniFiles,ShellAPI, Menus,
  OleCtrls, Spin,TCommon;

const
  //_ColSep='@@@';
  _ColSep='---->';
  _ColSep2='---->';

type
  TIFRSColRecC1=record
    F1:string;
    F2:string;
    KongC:integer;
    ParentIndex:integer;
    Flag:integer;
  end;
  TTIFRSColRecC1Ary=array of TIFRSColRecC1;
  TReplaceRec=record
    Src:string;
    Dst:string;
    All:Integer;
  end;
  TReplaceRecAry=array of TReplaceRec;
  
function IFRSHtmlSourceType(aInput:string):integer;  
function GetKongOfInput(sItem:string):integer;
function Kong2Str(aKongCount:Integer;aInput,aRpl:string):string;
function ProKJLMName(aName:string):string;
function ProKJLMNameEx(aName:string;var aKongCount:integer):string;

function ParseIFRSHtml(aCode,aYear,aQ,aInputHtml: string;
  var aTbl1Col,aTbl1Value,aTbl2Col,aTbl2Value,aTbl2ValueAdd,aTbl3Col,aTbl3Value:string): string;
function HtmlIFRSColList2TextIFRSColList(aInput:string;var aOutPut:string):boolean;
function TextIFRSColListPro1(aInputCol,aInputNum,aInputNum2:string;var aOutputCol,aOutputNum,aOutputNum2:string):boolean;
function TextIFRSColList2IFRSColRecC1(aInput:string;var aOutPut:string):boolean;


function ReadReplaceRecords(aFile,aSection:string;var aRecs:TReplaceRecAry):boolean;
function ReadReplaceRecordsEx(aSection:string;var aRecs:TReplaceRecAry):boolean;
function ReadTblColWarn(aFile,aSection:string;var aRecs:TReplaceRecAry):boolean;
function ReadTblColWarnEx(aSection:string;var aRecs:TReplaceRecAry):boolean;
function WriteTblColWarn(aTbl,aSrc,aKey:string):Boolean;
function WriteExceptionMsg(aMsg:string):Boolean;
function ReadtsTblColWarnAry(var ts1,ts2,ts3:TStringList):boolean;
function ReadIfrsExceptCodeList(aFile:string;var aRecs:TStringList):boolean;
function ReadIfrsExceptCodeListEx(var aRecs:TStringList):boolean;

var FRplRecs,FReflectTbl1,FReflectTbl2,FReflectTbl3:TReplaceRecAry;

implementation

function IFRSHtmlSourceType(aInput:string):integer;
var b1:boolean;
begin
  b1:=(Pos('>資產負債表</th>',aInput)>0) and
      (Pos('>綜合損益表</th>',aInput)>0) and
      (Pos('>現金流量表</th>',aInput)>0);
  if b1 then
  begin
    result:=0;
    exit;
  end;
  if Pos('查詢過於頻繁',aInput)>0 then result:=1
  else if (Pos('>查無資料<',aInput)>0)
         then result:=2
  else if Trim(aInput)='' then result:=3
  //else if (Pos(chr(39)+'下載案例文件'+chr(39),aInput)>0) or
  //        (Pos('"下載案例文件"',aInput)>0) then result:=4
  else if not (b1) then result:=4
  else result:=5;
end;
{
function IFRSHtmlSourceType(aInput:string):integer;
var b1:boolean;
begin
  b1:=(Pos('>資產負債表</th>',aInput)>0) and
      (Pos('>綜合損益表</th>',aInput)>0) and
      (Pos('>現金流量表</th>',aInput)>0);
  if b1 then
  begin
    result:=0;
    exit;
  end;
  if Pos('查詢過於頻繁',aInput)>0 then result:=1
  else if (Pos('查無資料',aInput)>0) or
         (Pos('查無公司資料',aInput)>0) or
         (Pos('查無最新資訊',aInput)>0) or
         (Pos('查無所需資料',aInput)>0) or
         (Pos('公司代號不存在',aInput)>0) or
         (Pos('公司未申報基本資料',aInput)>0) or
         (Pos('以前之財報資料請至採IFRSs前',aInput)>0)
         then result:=2
  else if Trim(aInput)='' then result:=3
  //else if (Pos(chr(39)+'下載案例文件'+chr(39),aInput)>0) or
  //        (Pos('"下載案例文件"',aInput)>0) then result:=4
  else if not (b1) then result:=4
  else result:=0;
end;
}

function GetKongOfInput(sItem:string):integer;
var i,iLen:integer;
begin
  result:=0;
  iLen:=0;
  for i:=1 to Length(sItem) do
  begin
    if sItem[i]<>' ' then
    begin
      break;
    end;
    Inc(iLen);
  end;
  if iLen>0 then 
    result:=trunc((iLen/2));
end;

function Kong2Str(aKongCount:Integer;aInput,aRpl:string):string;
var sAdd:string; i:integer;
begin
  result:=aInput;
  sAdd:='';
  for i:=1 to aKongCount do
  begin
    sAdd:=sAdd+aRpl;
  end;
  result:=sAdd+result;
end;

function ProKJLMName(aName:string):string;
var i,j:integer;
  function TiDai(aInput,aSrc,aDst:string):string;
  begin
    result:=aInput;
    if SameText(aInput,aSrc) then
      result:=aDst;
  end;
begin
  result:=aName;
  for i:=Low(FRplRecs) to High(FRplRecs) do
  begin
    if FRplRecs[i].All=1 then
      result:=StringReplace(result,FRplRecs[i].Src,FRplRecs[i].Dst,[rfReplaceAll])
    else if FRplRecs[i].All=0 then
      result:=TiDai(result,FRplRecs[i].Src,FRplRecs[i].Dst);
  end;
  result:=Trim(result);
end;

function ProKJLMNameEx(aName:string;var aKongCount:integer):string;
var i,j,iNo:integer; sItem2,sItem22,sRst:string;
begin
    result:=''; aKongCount:=0;

    sItem2:=aName;
    sItem22:='';  sRst:='';
    for i:=1 to Length(sItem2) do
    begin
      iNo:= ord(sItem2[i]);
      if iNo=32 then
      begin
        if sRst='' then sRst:=IntToStr(iNo)
        else sRst:=sRst+','+IntToStr(iNo);
        
        for j:=i+1 to Length(sItem2) do
        begin
          sItem22:=sItem22+sItem2[j];
        end;  
        break;
      end
      else begin
        if not (iNo in [161,64,32]) then
        begin
          raise Exception.Create('ord unexpect.'+aName);
        end;
        if sRst='' then sRst:=IntToStr(iNo)
        else sRst:=sRst+','+IntToStr(iNo);
      end;
    end;
    sItem2:=Trim(sItem22);
    result:=ProKJLMName(sItem2);

    sRst:=StringReplace(sRst,',','',[rfReplaceAll]);
    sRst:=StringReplace(sRst,'16164','-',[rfReplaceAll]);
    sRst:=StringReplace(sRst,'32','-',[rfReplaceAll]);
    aKongCount:=Length(sRst);
end;


function ColAndValueStr(aCol,aValue:string):string;
var iKong:integer;
begin
  aCol:=ProKJLMNameEx(aCol,iKong);
  if aValue<>#9 then
  begin
    if Copy(aValue,1,1)=#9 then 
      aValue:=ProKJLMNameEx(Copy(aValue,2,Length(aValue)),iKong)
    else
      aValue:=ProKJLMNameEx(aValue,iKong);
  end;
  result:=aCol+#9+aValue;
end;

function ParseIFRSHtml(aCode,aYear,aQ,aInputHtml: string;
  var aTbl1Col,aTbl1Value,aTbl2Col,aTbl2Value,aTbl2ValueAdd,aTbl3Col,aTbl3Value:string): string;
var i,i0,i1,i2,i3,i4,iTag,iCol,iValueThis,iValueAdd:integer; sAry:array[0..13] of string;  tsAry:array[0..15] of TStringList;
  bCountOk:boolean;

  function SpecTbl2:Boolean;
  begin
    result:=(iTag=2) and ( sametext(aQ,'2') or sametext(aQ,'3') );
  end;
  function SetColIndex(aInputTable:string):Boolean;
  var xstr,xstr2,xstr3:string; xi:integer;
    function TwY():string;
    begin
      result:=aYear;
    end;
    function CnY():string;
    begin
      result:=IntToStr( StrToInt(aYear)+1911 );
    end;
    function IsThisValueCol(aInputKey:string):Boolean;
    begin
      result:=False;
      if SameText(aQ,'1') then
      begin
        if SameText(aInputKey,CnY+'年01月01日至'+CnY+'年03月31日') or
           SameText(aInputKey,TwY+'年01月01日至'+TwY+'年03月31日') or
           SameText(aInputKey,CnY+'年第1季') or
           SameText(aInputKey,TwY+'年第1季') then
          result:=true;
      end
      else if SameText(aQ,'2') then
      begin
        if SameText(aInputKey,CnY+'年04月01日至'+CnY+'年06月30日') or
           SameText(aInputKey,TwY+'年04月01日至'+TwY+'年06月30日') or
           SameText(aInputKey,CnY+'年第2季') or
           SameText(aInputKey,TwY+'年第2季') then
          result:=true;
      end
      else if SameText(aQ,'3') then
      begin
        if SameText(aInputKey,CnY+'年07月01日至'+CnY+'年09月30日') or
           SameText(aInputKey,TwY+'年07月01日至'+TwY+'年09月30日') or
           SameText(aInputKey,CnY+'年第3季') or
           SameText(aInputKey,TwY+'年第3季') then
          result:=true;
      end
      else if SameText(aQ,'4') then
      begin
        if SameText(aInputKey,CnY+'年10月01日至'+CnY+'年12月31日') or
           SameText(aInputKey,TwY+'年10月01日至'+TwY+'年12月31日') then
          result:=true;
      end;
    end;
    function IsThisValueAddCol(aInputKey:string):Boolean;
    begin
      result:=False;
      if SameText(aQ,'2') then
      begin
        if SameText(aInputKey,CnY+'年01月01日至'+CnY+'年06月30日') or
           SameText(aInputKey,TwY+'年01月01日至'+TwY+'年06月30日') or
           SameText(aInputKey,CnY+'年上半年度') or
           SameText(aInputKey,TwY+'年上半年度') then
          result:=true;
      end
      else if SameText(aQ,'3') then
      begin
        if SameText(aInputKey,CnY+'年01月01日至'+CnY+'年09月30日') or
           SameText(aInputKey,TwY+'年01月01日至'+TwY+'年09月30日') then
          result:=true;
      end
      else if SameText(aQ,'4') then
      begin
        if SameText(aInputKey,CnY+'年01月01日至'+CnY+'年12月31日') or
           SameText(aInputKey,TwY+'年01月01日至'+TwY+'年12月31日') or
           SameText(aInputKey,CnY+'年度') or
           SameText(aInputKey,TwY+'年度') then
          result:=true;
      end;
    end;
  begin
    result:=false;
    iCol:=-1; iValueThis:=-1; iValueAdd:=-1; 
    xstr:=GetStrOnly2('<tr','</tr>',aInputTable,false);
    xstr:=StringReplace(xstr,chr(39),'',[rfReplaceAll]);
    xstr:=StringReplace(xstr,'<tr',#13#10+'<tr',[rfReplaceAll]);
    xstr:=StringReplace(xstr,'</tr>',#13#10+'</tr>',[rfReplaceAll]);
    xstr:=StringReplace(xstr,'<th',#13#10+'<th',[rfReplaceAll]);
    tsAry[14].text:=xstr;
    for xi:=0 to tsAry[14].count-1 do
    begin
      xstr2:=tsAry[14][xi];
      if (Pos('<th align=center>',xstr2)>0) and (Pos('</th>',xstr2)>0) then
      begin
        xstr3:=GetStrOnly2('<th align=center>','</th>',xstr2,false);
        xstr3:=Trim(xstr3);
        if not SameText(xstr3,'會計項目') then
          exit;
        iCol:=xi;
      end
      else if (Pos('<th align=center noWrap>',xstr2)>0) and (Pos('</th>',xstr2)>0) then
      begin
        xstr3:=GetStrOnly2('<th align=center noWrap>','</th>',xstr2,false);
        xstr3:=Trim(xstr3);
        if IsThisValueCol(xstr3) then
        begin
          iValueThis:=xi;
        end
        else if IsThisValueAddCol(xstr3) then
        begin
          iValueAdd:=xi;
        end;
      end
    end;
    if (iCol<>-1) and ( (iValueThis<>-1) or (iValueAdd<>-1) ) then
      result:=true;
  end;

  procedure RaiseException(aExceptionMsg:string);
  begin
    raise Exception.Create(Format('%s,%sQ%s',[aCode,aYear,aQ])+aExceptionMsg+
                sAry[1]+#13#10+'----------'+#13#10+
                tsAry[1][i1-1]+#13#10+'----------'+#13#10);
  end;
  procedure RaiseException2(aExceptionMsg:string);
  begin
    raise Exception.Create(Format('%s,%sQ%s',[aCode,aYear,aQ])+aExceptionMsg);
  end;
begin
  result:='000';
  aTbl1Col:=''; aTbl1Value:='';  aTbl2Col:=''; aTbl2Value:=''; aTbl2ValueAdd:=''; aTbl3Col:=''; aTbl3Value:=''; 

  try
    for i:=Low(tsAry) to High(tsAry) do
      tsAry[i]:=TStringList.create;
    sAry[0]:=ExtractFilePath(ParamStr(0))+'Data\DwnDocLog\DownIFRS\';
    if not DirectoryExists(sAry[0]) then
      ForceDirectories(sAry[0]);
    sAry[11]:=sAry[0]+Format('%s_%s_%s_1.txt',[aCode,aYear,aQ]);
    sAry[12]:=sAry[0]+Format('%s_%s_%s_2.txt',[aCode,aYear,aQ]);
    sAry[13]:=sAry[0]+Format('%s_%s_%s_3.txt',[aCode,aYear,aQ]);
    if FileExists(sAry[11]) then
      DeleteFile(sAry[11]);
    if FileExists(sAry[12]) then
      DeleteFile(sAry[12]);
    if FileExists(sAry[13]) then
      DeleteFile(sAry[13]);

    sAry[0]:=aInputHtml;
    sAry[0]:=StringReplace(sAry[0],#13#10,'',[rfReplaceAll]);
    sAry[0]:=StringReplace(sAry[0],'<table',#13#10+'<table',[rfReplaceAll]);
    sAry[0]:=StringReplace(sAry[0],'</table>',#13#10+'</table>',[rfReplaceAll]);

    tsAry[11].Clear; tsAry[7].Clear;//資產負債表 欄位、數值
    tsAry[12].Clear; tsAry[8].Clear; tsAry[10].Clear;//綜合損益表
    tsAry[13].Clear; tsAry[9].Clear;//現金流量表
    
    iTag:=-1;
    tsAry[0].text:=sAry[0];
    for i0:=0 to tsAry[0].count-1 do
    begin
      sAry[0]:=tsAry[0][i0];
      if (Pos('<table',sAry[0])>0) then
      begin
        if (Pos('>資產負債表</th>',sAry[0])>0) then
         iTag:=1
        else if (Pos('>綜合損益表</th>',sAry[0])>0) then
         iTag:=2
        else if (Pos('>現金流量表</th>',sAry[0])>0) then
         iTag:=3
        else
          continue;
        if SpecTbl2 then
        begin
          if not SetColIndex(sAry[0]) then
            RaiseException2('獲取欄位位置失敗.'+Format('名稱欄位=%d,數據欄位=%d,累加數據欄位=%d',[iCol,iValueThis,iValueAdd]));
        end;

        if SpecTbl2 then
        begin
          sAry[0]:=StringReplace(sAry[0],'<tr',#13#10+'<tr',[rfReplaceAll]);
          sAry[0]:=StringReplace(sAry[0],'</tr>',#13#10+'</tr>',[rfReplaceAll]);
          tsAry[15].text:=sAry[0];

          for i1:=0 to tsAry[15].count-1 do
          begin
            sAry[1]:=tsAry[15][i1];
            if (Pos('<tr class='+chr(39)+'even'+chr(39)+'>',sAry[1])>0) or
               (Pos('<tr class='+chr(39)+'odd'+chr(39)+'>',sAry[1])>0) then
            begin
              sAry[1]:=StringReplace(sAry[1],'<td',#13#10+'<td',[rfReplaceAll]);
              tsAry[1].text:=sAry[1];

              sAry[2]:=''; sAry[4]:=''; sAry[5]:='';
              sAry[1]:=StringReplace(tsAry[1][iCol],chr(39),'',[rfReplaceAll]);
              sAry[2]:=GetStrOnly2('<td noWrap>','</td>',sAry[1],false);
              if Trim(sAry[2])='' then
              begin
                tsAry[1].SaveToFile(ExtractFilePath(ParamStr(0))+'err.log');
                RaiseException('未解析到欄位.');
              end;
              tsAry[12].Add(sAry[2]);
              if iValueThis<>-1 then
              begin
                sAry[1]:=StringReplace(tsAry[1][iValueThis],chr(39),'',[rfReplaceAll]);
                sAry[4]:=GetStrOnly2('<td align=right>','</td>',sAry[1],false);
                tsAry[8].Add(sAry[4]);
              end;
              if iValueAdd<>-1 then
              begin
                sAry[1]:=StringReplace(tsAry[1][iValueAdd],chr(39),'',[rfReplaceAll]);
                sAry[5]:=GetStrOnly2('<td align=right>','</td>',sAry[1],false);
                tsAry[10].Add(sAry[5]);
              end;
            end;
          end;
        end
        else begin
          sAry[0]:=StringReplace(sAry[0],'<tr',#13#10+'<tr',[rfReplaceAll]);
          sAry[0]:=StringReplace(sAry[0],'</tr>',#13#10+'</tr>',[rfReplaceAll]);
          sAry[0]:=StringReplace(sAry[0],'<td',#13#10+'<td',[rfReplaceAll]);
          tsAry[1].text:=sAry[0];

          for i1:=0 to tsAry[1].count-1 do
          begin
            sAry[1]:=tsAry[1][i1];
            if (Pos('<td noWrap>',sAry[1])>0) then
            begin
              sAry[2]:=GetStrOnly2('<td noWrap>','</td>',sAry[1],false);
              if Trim(sAry[2])='' then
              begin
                tsAry[1].SaveToFile(ExtractFilePath(ParamStr(0))+'err.log');
                RaiseException('未解析到欄位.');
              end;
              sAry[4]:=''; sAry[5]:='';
              if (i1+1<tsAry[1].count) then
              begin
                sAry[3]:=tsAry[1][i1+1];
                sAry[3]:=StringReplace(sAry[3],chr(39),'',[rfReplaceAll]);
                if (Pos('<td align=right>',sAry[3])>0) and (Pos('</td>',sAry[3])>0) then
                begin
                  sAry[4]:=GetStrOnly2('<td align=right>','</td>',sAry[3],false);
                end else RaiseException('未找到相鄰數據欄位(1).');
              end else RaiseException('未找到相鄰數據欄位(2).');

              if iTag=1 then
              begin
                tsAry[11].Add(sAry[2]);
                tsAry[7].Add(sAry[4]);
              end
              else if iTag=2 then
              begin
                tsAry[12].Add(sAry[2]);
                tsAry[8].Add(sAry[4]);
              end
              else if iTag=3 then
              begin
                tsAry[13].Add(sAry[2]);
                tsAry[9].Add(sAry[4]);
              end;
            end;
          end;
        end;    


        if (iTag=1) then
        begin
          bCountOk:=(tsAry[11].Count>0) and (tsAry[11].Count=tsAry[7].Count);
          if bCountOk then
          begin
            aTbl1Col:=tsAry[11].Text; aTbl1Value:=tsAry[7].Text;
            for i2:=0 to tsAry[11].count-1 do
              tsAry[11][i2]:=ColAndValueStr(tsAry[11][i2],tsAry[7][i2]);
            Result[1]:='1';
            tsAry[11].SaveToFile(sAry[11]);
          end;
        end
        else if (iTag=2) then
        begin
          bCountOk:=false;
          if SpecTbl2 then
          begin
            if (iValueThis<>-1) and (iValueAdd<>-1) then
              bCountOk:=(tsAry[12].Count>0) and (tsAry[12].Count=tsAry[8].Count) and (tsAry[12].Count=tsAry[10].Count)
            else if (iValueThis<>-1) and (iValueAdd=-1) then
              bCountOk:=(tsAry[12].Count>0) and (tsAry[12].Count=tsAry[8].Count)
            else if (iValueThis=-1) and (iValueAdd<>-1) then
              bCountOk:=(tsAry[12].Count>0) and (tsAry[12].Count=tsAry[10].Count);
          end else
            bCountOk:=(tsAry[12].Count>0) and (tsAry[12].Count=tsAry[8].Count);
          if bCountOk then
          begin
            aTbl2Col:=tsAry[12].Text; aTbl2Value:=tsAry[8].Text;  aTbl2ValueAdd:=tsAry[10].Text;
            Result[2]:='1';
            for i2:=0 to tsAry[12].count-1 do
            begin
              if SpecTbl2 then
              begin
                if (iValueThis<>-1) and (iValueAdd<>-1) then
                  tsAry[12][i2]:=ColAndValueStr(tsAry[12][i2],tsAry[8][i2]+#9+tsAry[10][i2])
                else if (iValueThis<>-1) and (iValueAdd=-1) then
                  tsAry[12][i2]:=ColAndValueStr(tsAry[12][i2],tsAry[8][i2])
                else if (iValueThis=-1) and (iValueAdd<>-1) then
                  tsAry[12][i2]:=ColAndValueStr(tsAry[12][i2],tsAry[10][i2]);
              end else
                tsAry[12][i2]:=ColAndValueStr(tsAry[12][i2],tsAry[8][i2]);
            end;
            tsAry[12].SaveToFile(sAry[12]);
          end;
        end
        else if (iTag=3) then
        begin
          bCountOk:=(tsAry[13].Count>0) and (tsAry[13].Count=tsAry[9].Count);
          if bCountOk then
          begin
            aTbl3Col:=tsAry[13].Text; aTbl3Value:=tsAry[9].Text;
            Result[3]:='1';
            for i2:=0 to tsAry[13].count-1 do
              tsAry[13][i2]:=ColAndValueStr(tsAry[13][i2],tsAry[9][i2]);
            tsAry[13].SaveToFile(sAry[13]);
          end;
        end;
              
      end;
    end;
  finally
    for i:=Low(tsAry) to High(tsAry) do
      FreeAndNil(tsAry[i]);
  end;
end;


function HtmlIFRSColList2TextIFRSColList(aInput:string;var aOutPut:string):boolean;
var tsIn,tsOut:TStringList; i,iKong:integer;  sItem,sItem2,sItem22:string;
begin
  result:=false;aOutPut:='';
  try
    tsIn:=TStringList.Create;
    tsOut:=TStringList.Create;

    tsIn.Text:=aInput;
    for i:=0 to tsIn.Count-1 do
    begin
      sItem:=tsIn[i];
      if Trim(sItem)='' then
        Continue;
      sItem2:=ProKJLMNameEx(sItem,iKong);
      sItem22:=Kong2Str(iKong,sItem2,'  ');
      tsOut.Add(sItem22);
    end;
    
    aOutPut:=tsOut.text;
    result:=True;
  finally
    FreeAndNil(tsIn);
    FreeAndNil(tsOut);
  end;
end;

function TextIFRSColListPro1(aInputCol,aInputNum,aInputNum2:string;var aOutputCol,aOutputNum,aOutputNum2:string):boolean;
var tsAry:array[0..7] of TStringList; i,iKong,iB,iE:integer;  sItem,sItem2,sItem22:string;
  function NumIs0(xNum:string):boolean;
  begin
    result:=SameText(xNum,'') or
           SameText(xNum,'0') or
           SameText(xNum,'0.0') or
           SameText(xNum,'0.00') or
           (StrToFloat(xNum)=0);
  end;
  function KongC(aInputIndex:integer):Integer;
  var iLen1,iLen2:integer; xstr,xstr2:string;
  begin
    result:=0;
    xstr:=(tsAry[0][aInputIndex]);
    iLen1:=Length(xstr);
    xstr2:=Trim(tsAry[0][aInputIndex]);
    iLen2:=Length(xstr2);
    if (iLen1-iLen2) mod 2<>0 then
      raise Exception.Create(xstr+' mod 2 is not 0' );
    result:=Trunc((iLen1-iLen2)/2);
  end;
  function GetKong(aInputIndex:integer):integer;
  begin
    result:=StrToInt(tsAry[2][aInputIndex]);
  end;
  function GetIdx(aInputIndex:integer):integer;
  begin
    result:=StrToInt(tsAry[3][aInputIndex]);
  end;
  function GetNum(aInputIndex:integer):string;
  begin
    result:=(tsAry[1][aInputIndex]);
  end;
  function GetNum2(aInputIndex:integer):string;
  begin
    result:=(tsAry[6][aInputIndex]);
  end;
  function ThisNumIs0(aInputIndex:integer):boolean;
  var xsf1:string;
  begin
    result:=true;
    if aInputNum<>'' then
    begin
      xsf1:=GetNum(aInputIndex);
      if not NumIs0(xsf1) then
      begin
        result:=false;
        exit;
      end;
    end;
    if aInputNum2<>'' then
    begin
      xsf1:=GetNum2(aInputIndex);
      if not NumIs0(xsf1) then
      begin
        result:=false;
        exit;
      end;
    end;
  end;
  function GetCol(aInputIndex:integer):string;
  begin
    result:=tsAry[0][aInputIndex];
  end;
  function GetCount():integer;
  begin
    result:=tsAry[0].count;
  end;


  function IsLowLayer(aInputIndex:integer;var iBegin,iEnd:integer):boolean;
  var xi,xc1,xc2,xc3,xc4:integer;
  begin
    result:=false;
    if aInputIndex=GetCount-1 then
      exit;
    xc1:=GetKong(aInputIndex-1);
    xc2:=GetKong(aInputIndex);
    if (xc1<xc2) then
    begin
      for xi:=aInputIndex+1 to GetCount-1 do
      begin
        xc3:=GetKong(xi);
        if xc3<>xc2 then
        begin
          if xc3<xc2 then
          begin
            iBegin:=aInputIndex;
            iEnd:=xi-1;
            result:=true;
          end;
          exit;
        end;
      end;
    end;
  end;
  procedure DelOneIndex(aInputIndex:integer);
  var xIdx:integer;
  begin
    xIdx:=GetIdx(aInputIndex);
    tsAry[0].Delete(aInputIndex);
    if aInputNum<>'' then
    begin
      tsAry[1].Delete(aInputIndex);
      tsAry[5][xIdx]:='del';
    end;
    if aInputNum2<>'' then
    begin
      tsAry[6].Delete(aInputIndex);
      tsAry[7][xIdx]:='del';
    end;
    tsAry[2].Delete(aInputIndex);
    tsAry[3].Delete(aInputIndex);
  end;

  function ProLowLayer(iBegin,iEnd:integer):boolean;
  var xi:Integer; xParent,xNum,xCol:string; xb,xb0,xb1:boolean;
  begin
    result:=false;
    xParent:=Trim(GetCol(iBegin-1));
    //--判斷是否都為0
    xb:=True;
    for xi:=iBegin to iEnd do
    begin
      xb0:=ThisNumIs0(xi);
      if not xb0 then
      begin
        xb:=false;
        Break;
      end;
    end;
    if xb then
    begin
      for xi:=iEnd downto iBegin do
      begin
        DelOneIndex(xi);
        if xi=iBegin then
          result:=true;
      end;
    end
    else begin
      for xi:=iEnd downto iBegin do
      begin
        xCol:=Trim(GetCol(xi));
        xb1:=ThisNumIs0(xi);
        if xb1 then
          if not (
                SameText(xCol,xParent) or
                SameText(xCol+'總計',xParent) or
                SameText(xCol+'總額',xParent) or
                SameText(xCol+'合計',xParent) or
                SameText(xCol+'淨額',xParent)
          ) then
          begin
            DelOneIndex(xi);
            if xi=iBegin then
              result:=true;
          end;
      end;
    end;

  end;
begin
  result:=false; aOutputCol:=''; aOutputNum:='';
  try
    for i:=Low(tsAry) to High(tsAry) do
      tsAry[i]:=TStringList.Create;

    tsAry[4].text:=aInputCol;
    tsAry[5].text:=aInputNum; tsAry[7].text:=aInputNum2;
    tsAry[0].Text:=aInputCol;
    tsAry[1].Text:=StringReplace(aInputNum,',','',[rfReplaceAll]);  tsAry[6].Text:=StringReplace(aInputNum2,',','',[rfReplaceAll]);

    for i:=0 to tsAry[0].Count-1 do
    begin
      tsAry[2].Add(IntToStr(KongC(i)));
      tsAry[3].Add(IntToStr(i));
    end;
    for i:=0 to tsAry[1].Count-1 do
      tsAry[1][i]:=trim(tsAry[1][i]);
    for i:=0 to tsAry[6].Count-1 do
      tsAry[6][i]:=trim(tsAry[6][i]);

    i:=1;
    while i<GetCount do
    begin
      if Trim(GetCol(i))='' then
        Continue;
      if IsLowLayer(i,iB,iE) then
      begin
        if ProLowLayer(iB,iE) then
        Continue;
      end;
      Inc(i);
    end;

    aOutputCol:=tsAry[4].Text; aOutputNum:=tsAry[5].Text; aOutputNum2:=tsAry[7].Text;
    result:=True;
  finally
    for i:=Low(tsAry) to High(tsAry) do
      FreeAndNil(tsAry[i]);
  end;
end;

function TextIFRSColList2IFRSColRecC1(aInput:string;var aOutPut:string):boolean;
var aRecs:TTIFRSColRecC1Ary; tsIn,tsOut:TStringList;
  i,j,k,iKong:integer; sAry:array[0..8] of string;
begin
  result:=false;aOutPut:='';
  try
    tsIn:=TStringList.Create;
    tsOut:=TStringList.Create;

    tsIn.Text:=aInput;
    SetLength(aRecs,tsIn.Count);
    k:=0;
    for i:=0 to tsIn.Count-1 do
    begin
      sAry[0]:=tsIn[i];
      if Trim(sAry[0])='' then
        Continue;

      if SameText(trim(sAry[0]),'待註銷股本股數') or
         SameText(trim(sAry[0]),'預收股款(權益項下)之約當發行股數') or
         SameText(trim(sAry[0]),'母公司暨子公司所持有之母公司庫藏股股數(單位:股)') then
      begin
        sAry[0]:=trim(sAry[0]);
      end;
         
      iKong:=GetKongOfInput(sAry[0]);
      sAry[1]:=ProKJLMName(sAry[0]);
      //if SameText(sAry[1],'負債及權益') then Continue;
      aRecs[k].F1:=sAry[0];
      aRecs[k].F2:=sAry[1];
      aRecs[k].KongC:=iKong;
      Inc(k);
    end;
    SetLength(aRecs,k);


    for i:=High(aRecs) downto Low(aRecs) do
    begin
      iKong:=aRecs[i].KongC;
      sAry[0]:=aRecs[i].F2;

      for j:=i-1 downto Low(aRecs) do
      begin
        if iKong>aRecs[j].KongC then
        begin
          if not SameText(aRecs[j].F2,'負債及權益') then
          begin
            sAry[0]:=sAry[0]+_ColSep+aRecs[j].F2;
          end;
          iKong:=aRecs[j].KongC;
        end;
        if iKong=0 then
        begin
          Break;
        end;
      end;
      tsOut.Add(sAry[0]);
    end;

    tsIn.Text:=tsOut.text;
    tsOut.clear;
    for i:=tsIn.Count-1 downto 0 do
      tsOut.Add(tsIn[i]);
      
    aOutPut:=tsOut.text;
    result:=True;
  finally
    SetLength(aRecs,0);
    FreeAndNil(tsIn);
    FreeAndNil(tsOut);
  end;
end;

function ReadReplaceRecordsEx(aSection:string;var aRecs:TReplaceRecAry):boolean;
begin
  result:=ReadReplaceRecords(ExtractFilePath(ParamStr(0))+'IFRSReflection.ini',aSection,aRecs);
end;

function ReadReplaceRecords(aFile,aSection:string;var aRecs:TReplaceRecAry):boolean;
var fini:TIniFile; ic,i,j:integer; s1,s2:string;
begin
  result:=false;
  SetLength(aRecs,0);
  if not FileExists(aFile) then
    exit;
  if Trim(aSection)='' then
    exit;
  try
    fini:=TIniFile.Create(aFile);
    j:=0;
    ic:=fini.ReadInteger(aSection,'count',0);
    SetLength(aRecs,ic);
    for i:=1 to ic do
    begin
      s1:=fini.ReadString(aSection,Format('%d.src',[i]),'' );
      if s1<>'' then
      begin
        aRecs[j].Src:=s1;
        aRecs[j].Dst:=fini.ReadString(aSection,Format('%d.dst',[i]),'' );
        aRecs[j].All:=fini.ReadInteger(aSection,Format('%d.all',[i]),0 );
        Inc(j);
      end;  
    end;
    SetLength(aRecs,j);
    result:=True;
  finally
    FreeAndNil(fini);
  end;
end;

function ReadTblColWarnEx(aSection:string;var aRecs:TReplaceRecAry):boolean;
begin
  result:=ReadReplaceRecords(ExtractFilePath(ParamStr(0))+'IFRSColWarn.ini',aSection,aRecs);
end;

function ReadTblColWarn(aFile,aSection:string;var aRecs:TReplaceRecAry):boolean;
var fini:TIniFile; ic,i,j:integer; s1,s2:string;
begin
  result:=false;
  SetLength(aRecs,0);
  if not FileExists(aFile) then
    exit;
  if Trim(aSection)='' then
    exit;
  try
    fini:=TIniFile.Create(aFile);
    j:=0;
    ic:=fini.ReadInteger(aSection,'count',0);
    SetLength(aRecs,ic);
    for i:=1 to ic do
    begin
      s1:=fini.ReadString(aSection,Format('%d',[i]),'' );
      if s1<>'' then
      begin
        aRecs[j].Src:=s1;
        aRecs[j].Dst:=fini.ReadString(aSection,Format('%d.key',[i]),'' );
        Inc(j);
      end;  
    end;
    SetLength(aRecs,j);
    result:=True;
  finally
    FreeAndNil(fini);
  end;
end;

function WriteExceptionMsg(aMsg:string):Boolean;
var sFile:string; fini:TIniFile; i,j,ic:integer;
begin
  result:=false;
  sFile:=ExtractFilePath(ParamStr(0))+'IFRSColWarn.ini';
  try
    fini:=TIniFile.Create(sFile);
    fini.WriteString('warn','msg',aMsg);
    fini.WriteFloat('warn','time',now);
    result:=True;
  finally
    FreeAndNil(fini);
  end;
end;

function WriteTblColWarn(aTbl,aSrc,aKey:string):Boolean;
var sFile:string; fini:TIniFile; i,j,ic:integer;
begin
  result:=false;
  sFile:=ExtractFilePath(ParamStr(0))+'IFRSColWarn.ini';
  try
    fini:=TIniFile.Create(sFile);
    ic:=fini.ReadInteger(aTbl,'count',0);
    fini.WriteString(aTbl,Format('%d',[ic+1]),aSrc);
    fini.WriteString(aTbl,Format('%d.key',[ic+1]),aKey);
    fini.WriteInteger(aTbl,'count',ic+1);
    result:=True;
  finally
    FreeAndNil(fini);
  end;
end;

function ReadtsTblColWarnAry(var ts1,ts2,ts3:TStringList):boolean;
  procedure WriteBack(aInputTbl:string;aInputWarnTbl:TReplaceRecAry);
  var sFile:string; fini:TIniFile; i,j:integer;
  begin
    sFile:=ExtractFilePath(ParamStr(0))+'IFRSColWarn.ini';
    try
      fini:=TIniFile.Create(sFile);
      j:=0;
      for i:=Low(aInputWarnTbl) to High(aInputWarnTbl) do
      begin
        with aInputWarnTbl[i] do
        begin
          if Src<>'' then
          begin
            Inc(j);
            fini.WriteString(aInputTbl,Format('%d',[j]),Src);
            fini.WriteString(aInputTbl,Format('%d.key',[j]),Dst);
          end;
        end;
      end;
      if j=0 then
        fini.EraseSection(aInputTbl)
      else
        fini.WriteInteger(aInputTbl,'count',j);
      result:=True;
    finally
      FreeAndNil(fini);
    end;
  end;
  function FindIn(aInput:string;aInputRplTbl:TReplaceRecAry):Boolean;
  var i:integer;
  begin
    result:=false;
    for i:=Low(aInputRplTbl) to High(aInputRplTbl) do
    begin
      with aInputRplTbl[i] do
      begin
        if SameText(Src,aInput) then
        begin
          Result:=true;
          exit;
        end;
      end;
    end;
  end;
var aWarnTbl,aRplTbl:TReplaceRecAry; n:integer; b:boolean; sTbl:string;
begin
  result:=false;
  ts1.Clear; ts2.Clear; ts3.Clear;

  sTbl:='1';
  ReadTblColWarnEx(sTbl,aWarnTbl);
  SetLength(aRplTbl,0);
  if Length(aWarnTbl)>0 then
  begin
    ReadReplaceRecordsEx(sTbl,aRplTbl);
    b:=false;
    for n:=Low(aWarnTbl) to High(aWarnTbl) do
    begin
      with aWarnTbl[n] do
      begin
        if FindIn(Src,aRplTbl) then
        begin
          Src:='';
          b:=true;
        end else
          ts1.Add(Src);
      end;
    end;
    if b then
      WriteBack(sTbl,aWarnTbl);
  end;


  sTbl:='2';
  ReadTblColWarnEx(sTbl,aWarnTbl);
  SetLength(aRplTbl,0);
  if Length(aWarnTbl)>0 then
  begin
    ReadReplaceRecordsEx(sTbl,aRplTbl);
    b:=false;
    for n:=Low(aWarnTbl) to High(aWarnTbl) do
    begin
      with aWarnTbl[n] do
      begin
        if FindIn(Src,aRplTbl) then
        begin
          Src:='';
          b:=true;
        end else
          ts2.Add(Src);
      end;
    end;
    if b then
      WriteBack(sTbl,aWarnTbl);
  end;

  sTbl:='3';
  ReadTblColWarnEx(sTbl,aWarnTbl);
  SetLength(aRplTbl,0);
  if Length(aWarnTbl)>0 then
  begin
    ReadReplaceRecordsEx(sTbl,aRplTbl);
    b:=false;
    for n:=Low(aWarnTbl) to High(aWarnTbl) do
    begin
      with aWarnTbl[n] do
      begin
        if FindIn(Src,aRplTbl) then
        begin
          Src:='';
          b:=true;
        end else
          ts3.Add(Src);
      end;
    end;
    if b then
      WriteBack(sTbl,aWarnTbl);
  end;

  result:=true;
end;

function ReadIfrsExceptCodeListEx(var aRecs:TStringList):boolean;
begin
  result:=ReadIfrsExceptCodeList(ExtractFilePath(ParamStr(0))+'IFRSReflection.ini',aRecs);
end;

function ReadIfrsExceptCodeList(aFile:string;var aRecs:TStringList):boolean;
var fini:TIniFile; ic,i,j:integer; s1,s2,aSection:string;
begin
  result:=false;
  aRecs.Clear;
  if not FileExists(aFile) then
  begin
    result:=true;
    exit; 
  end;
  aSection:='exceptcodelist';
  try
    fini:=TIniFile.Create(aFile);
    j:=0;
    ic:=fini.ReadInteger(aSection,'count',0);
    for i:=1 to ic do
    begin
      s1:=fini.ReadString(aSection,Format('%d',[i]),'' );
      if s1<>'' then
      begin
        aRecs.Add(s1);
      end;  
    end;
    result:=True;
  finally
    FreeAndNil(fini);
  end;
end;

end.
