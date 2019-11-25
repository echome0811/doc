unit uLevelDataFun;

interface
 uses Windows,Classes,Controls,IniFiles,SysUtils,TCommon,uLevelDataDefine;
 
const
  _CDaiXia='0';
  _CXiaing='1';
  _CXiaOK='2';
  _CXiaFail='3';
  _CShen='4';
  _CShen2='b';
  _CNoNeedShen='5';//無資料
  _CNoNeedShen3='c';//無資料且原因不明
  _CNoNeedShen2='a';//tr1db中已經存在資料
  _CCreateWorkList='6';
  _CCreateWorkListFail='7';
  _CCreateWorkListReady='8';
  _CCircleOk='9';

  _CStrDaiXia='待下載';
  _CStrXiaing='下載中';
  _CStrXiaOK='下載成功';
  _CStrXiaOKIFRS='待審核';
  _CStrXiaFail='下載失敗';
  _CStrShen='已保存';
  _CStrShenIFRS='已保存(手動)';
  _CStrShenIFRS2='已保存(自動)';
  _CTodayD='今日數據--';
  _CStrNoNeedShen='無需處理';
  _CStrNoNeedShenIFRS='無需處理(無資料)';
  _CStrNoNeedShenIFRS2='無需處理(資料已存在)';
  _CStrCreateWorkList='生成任務清單中';
  _CStrCreateWorkListFail='生成任務清單失敗';
  _CStrCreateWorkListReady='正在生成任務清單';
  _CStrCircleOk='本輪下載結束';

  NoneNum2     = 99999;
  ValueEmpty2     = 88888;

type
TRecCount=record
    StatusCode:string[2];
    Status:string[50];
    Count:integer;
  end;

function Status2StrSubForIFRS(aInput:string):string;
function GetIFRSListStatus_ForDownIFS(AryStatus:_cStrLst;var aOutPut:string):boolean;

function LevelsOfIFRS(aInput:string):integer;
function LevelParentStrOfIFRS(aStartLevel:integer;ts:TStringList):string;
function FindNodeOfIFRS(aTblType:integer;aNode,aParentNode:string;ts:TStringList):integer;
function RplNode(aNode:string):string;
function RplNode0(aNode:string):string;
function UptIFRSRecToTr1db(aSrcF,aDstF:string):integer;
function UptIFRSRecToTr1dbBatch(tsSrc:TStringList;aDstF:string;var tsRst:TStringList):boolean;
function GetIFRSFile2File(aSrcF,aDstF,aCode:string):boolean;
function IFRSTblChr2Str(aTblChr:char):string;

procedure Init_TIFRSDatRec(var Rec:TIFRSDatRec);
function IfrsSpecTbl2(aInputTbl:Char;aQ:Integer):boolean;
procedure AssignTIFRSDatRec(aSrc:TIFRSDatRec;var aDst:TIFRSDatRec);
function IFRS_GetRecOfIFRSData(aYear,aQ,aTbl:integer;aInputCode,aDataFile:string):TIFRSDatRec;
function IFRS_GetCodeList(aDataFile:string;var ts:TStringList):boolean;


implementation


function LevelsOfIFRS(aInput:string):integer;
var i:integer;
begin
  Result:=0;
  i:=1;
  while i<Length(aInput) do
  begin
    if (aInput[i]=#9) or (aInput[i]=' ') then
    begin
      Inc(result);
      Inc(i);
      Continue;
    end
    else if (Copy(aInput,i,2)=#161+'@') then
    begin
      Inc(result);
      i:=i+2;
      Continue;
    end
    else begin
      break;
    end;
    Inc(i);
  end;
end;

function FindNodeOfIFRS(aTblType:integer;aNode,aParentNode:string;ts:TStringList):integer;
var i:integer;
begin
  Result:=-1;
  i:=0;
  while i+4<ts.Count do
  begin
    if SameText(ts[i+4],IntToStr(aTblType)) and
       SameText(ts[i],aNode) and
       SameText(ts[i+2],aParentNode) then
    begin
      result:=i;
      exit;
    end;
    i:=i+5;
  end;
end;

{
node
level
parentnode
isnull
tabletype
}

function LevelParentStrOfIFRS_Sub(aLevel:integer;ts:TStringList;var aRst:string):integer;
var i:integer;
begin
  Result:=-1;
  i:=ts.count-1;
  while i-4>=0 do
  begin
    if (ts[i-3]=IntToStr(aLevel)) then
    begin
      if aRst='' then aRst:=ts[i-4]
      else aRst:=aRst+'%;%'+ts[i-4];
      result:=i;
      exit;
    end;
    i:=i-5;
  end;
end; 

function LevelParentStrOfIFRS(aStartLevel:integer;ts:TStringList):string;
var i,j:integer;
begin
  Result:='';
  for i:=aStartLevel-1 downto 2 do
  begin
    j:=LevelParentStrOfIFRS_Sub(i,ts,Result);
    if (j=-1) and (i<>2) then
    begin
      raise Exception.Create('not find parentnode');
    end;
  end;
end; 

function Status2StrSubForIFRS(aInput:string):string;
   begin
     result:='';
     if aInput=_CDaiXia then
       Result:=_CStrDaiXia
     else if aInput=_CXiaing then
       Result:=_CStrXiaing
     else if aInput=_CXiaOK then
       Result:=_CStrXiaOKIFRS
     else if aInput=_CXiaFail then
       Result:=_CStrXiaFail
     else if aInput=_CShen then
       Result:=_CStrShenIFRS
     else if aInput=_CShen2 then
       Result:=_CStrShenIFRS2
     else if aInput=_CNoNeedShen then
       Result:=_CStrNoNeedShenIFRS
     else if aInput=_CNoNeedShen2 then
       Result:=_CStrNoNeedShenIFRS2
     else if aInput=_CCreateWorkList then
       Result:=_CStrCreateWorkList
     else if aInput=_CCreateWorkListFail then
       Result:=_CStrCreateWorkListFail
     else if aInput=_CCreateWorkListReady then
       Result:=_CStrCreateWorkListReady
     else if aInput=_CCircleOk then
       Result:=_CStrCircleOk;
   end;

   
function GetIFRSListStatus_ForDownIFS(AryStatus:_cStrLst;var aOutPut:string):boolean;
  function IFRSWorkLstFile:string;
  begin
    result:=ExtractFilePath(ParamStr(0))+_IFRSWorklst;
  end;
  function InStatus(aInput:string):boolean;
  var jx:integer;
  begin
    Result:=false;
    for jx:=0 to High(AryStatus) do
    begin
      if SameText(aInput,AryStatus[jx]) then
      begin
        Result:=true;
        break;
      end;
    end;
  end;
var ts:TStringList;  aParamStrLst:_cStrLst; aAryCount:array of TRecCount;
   ix,ix1,ix2,ix3:integer; xstr1,xstr2,xstr3:string; xdt:TDateTime;
   xFini:TIniFile;
begin
  result:=true;
  aOutPut:='';
  xstr1:=IFRSWorkLstFile;
  if not FileExists(xstr1) then
  begin
    exit;
  end;
  try
    xFini:=nil;
    ts:=TStringList.create;
    ts.LoadFromFile(xstr1);
    for ix:=0 to ts.Count-1 do
    begin
      if SameText(ts[ix],'[list]') then
      begin
        for ix1:=ix+1 to ts.Count-1 do
        begin
          xstr1:=Trim(ts[ix1]);
          if xstr1='' then
            continue;
          if IsSecLine(xstr1) then
            break;
          aParamStrLst:=DoStrArray(xstr1,'=');
          if length(aParamStrLst)=2 then
          begin
            if aParamStrLst[1]='' then
              aParamStrLst[1]:=_CDaiXia;
            if not InStatus(aParamStrLst[1]) then 
            begin
              result:=false;
            end;
            ix2:=-1;
            for ix3:=0 to High(aAryCount) do
            begin
              if SameText(aAryCount[ix3].StatusCode,aParamStrLst[1]) then
              begin
                ix2:=ix3;
                Break;
              end;
            end;
            if ix2=-1 then
            begin
              ix2:=Length(aAryCount);
              setLength(aAryCount,ix2+1);
              aAryCount[ix2].StatusCode:=aParamStrLst[1];
              aAryCount[ix2].Status:=Status2StrSubForIFRS(aParamStrLst[1]);
              aAryCount[ix2].Count:=0;
            end;
            Inc(aAryCount[ix2].Count);
          end;
        end;
        Break;
      end;
    end;
    if not result then
    begin
      xFini:=TIniFile.create(IFRSWorkLstFile);
      aOutPut:='當前任務沒有處理完畢.';
      aOutPut:=aOutPut+';'+'會計季度='+xFini.ReadString('work','year','')+','+xFini.ReadString('work','q','');
      xdt:=xFini.ReadFloat('work','createtime',0);
      aOutPut:=aOutPut+';'+'任務產生時間='+FormatDateTime('yyyy/mm/dd hh:mm:ss',xdt);
      for ix3:=0 to High(aAryCount) do
      begin
        xstr2:=aAryCount[ix3].Status+'='+inttostr(aAryCount[ix3].count);
        aOutPut:=aOutPut+';'+xstr2;
      end;
    end;
  finally
    try SetLength(aAryCount,0); except end;
    try SetLength(aParamStrLst,0); except end;
    try if Assigned(ts) then FreeAndNil(ts); except end;
    try if Assigned(xFini) then FreeAndNil(xFini); except end;
  end;
end;

function RplNode0(aNode:string):string;
begin
  result:=aNode;
  result:=StringReplace(result,#161+'@',' ',[rfReplaceAll]);
end;

function RplNode(aNode:string):string;
begin
  result:=aNode;
  result:=StringReplace(result,#161+'@',' ',[rfReplaceAll]);
  //result:=TrimRight(result);
  //result:=Trim(result);
  result:=StringReplace(result,' ','',[rfReplaceAll]);
end;

Procedure SortIFRSDatRecAry(var BufferGrid:TIFRSDatRecAry);
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2,lTemp3 : TIFRSDatRec;
  i,Count :Integer;
Begin

  if Length(BufferGrid)<=1 then exit;

  i := Length(BufferGrid);
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin
            lTemp  := BufferGrid[lLoop1];
            lHold  := lLoop1;
            lTemp2 := BufferGrid[lHold - lHValue];
            while  (lTemp2.CompCode > lTemp.CompCode)
                  do
            Begin
                 lTemp3:=BufferGrid[lHold];
                 BufferGrid[lHold] := BufferGrid[lHold - lHValue];
                 BufferGrid[lHold - lHValue]:=lTemp3;
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
                 lTemp2 := BufferGrid[lHold - lHValue];
            End;
            BufferGrid[lHold] := lTemp;
        End;
  Until lHValue = 0;
End;

function GetIFRSFile2File(aSrcF,aDstF,aCode:string):boolean;
const BlockSize=50;
var f,f2: File  of TIFRSDatRec;
   r: array[0..BlockSize-1] of TIFRSDatRec;
    k,ReMain,ReadCount,GotCount:integer;
begin
  result:=false;
  if not FileExists(aSrcF) then
  begin
    result:=True;
    exit;
  end;
  try
    AssignFile(f,aSrcF);
    AssignFile(f2,aDstF);
    FileMode:=2;
    ReSet(f);
    Rewrite(f2);
    ReMain := FileSize(f);
    while ReMain>0 do
    Begin
         if Remain<BlockSize then ReadCount:=ReMain
         else ReadCount:=BlockSize;
         BlockRead(f,r,ReadCount,GotCount);
         For k:=0 to GotCount-1 do
         Begin
           if (sameText(r[k].CompCode,aCode)) then
           begin
             write(f2,r[k]);
           end;
         End;
         Remain:=Remain-GotCount;
    End;
    result:=True;
  finally
    try CloseFile(f); except end;
    try CloseFile(f2); except end;
  end;
end;

//0==no need upt -1=upt fail 1=upt ok 
function UptIFRSRecToTr1db(aSrcF,aDstF:string):integer;
var f: File  of TIFRSDatRec; recs:TIFRSDatRecAry; srcrec:TIFRSDatRecAry;
 b:boolean;  i,j,ReMain,GotCount,n:integer;
 sTmpFile,sTemp1:string;
begin
  result:=-1;
  sTmpFile:=ChangeFileExt(aDstF,'.temp');
try
  if not FileExists(aSrcF) then
  begin
    result:=0;
    exit;
  end;
  SetLength(srcrec,0);
  try
    AssignFile(f,aSrcF);
    FileMode := 0;
    reset(f);
    ReMain := FileSize(f);
    SetLength(srcrec,ReMain);
    if ReMain>0 then
      BlockRead(f,srcrec[0],ReMain,GotCount);
  finally
    try CloseFile(f); except end;
  end;
  SetLength(recs,0);
  if FileExists(aDstF) then
  begin
    try
      AssignFile(f,aDstF);
      FileMode := 0;
      reset(f);
      ReMain := FileSize(f);
      SetLength(recs,ReMain);
      if ReMain>0 then
        BlockRead(f,recs[0],ReMain,GotCount);
    finally
      try CloseFile(f); except end;
    end;
  end;

  for n:=0 to High(srcrec) do
  begin
    b:=False;
    for i:=0 to High(recs) do
    begin
      if SameText(recs[i].CompCode,srcrec[n].CompCode) and
         (recs[i].Year=srcrec[n].Year) and
         (recs[i].Q=srcrec[n].Q) and
         (recs[i].Tbl=srcrec[n].Tbl)  then
      begin
        b:=true;
        AssignTIFRSDatRec(srcrec[n],recs[i]);
        Break;
      end;
    end;
    if not b then
    begin
      GotCount:=Length(recs);
      setLength(recs,GotCount+1);
      AssignTIFRSDatRec(srcrec[n],recs[GotCount]);
    end;
  end;

  SortIFRSDatRecAry(recs);
  try
    AssignFile(f,sTmpFile);
    FileMode := 2;
    Rewrite(f);
    GotCount:=Length(recs);
    BlockWrite(f,recs[0],GotCount);
  finally
    try CloseFile(f); except end;
  end;
  CopyFile(PChar(sTmpFile),PChar(aDstF),False);
  result:=1;
finally
  try SetLength(recs,0); except end;
  try SetLength(srcrec,0); except end;
  if FileExists(sTmpFile) then
    DeleteFile(sTmpFile);
end;
end;

//--批量更新到某個年季檔案中
function UptIFRSRecToTr1dbBatch(tsSrc:TStringList;aDstF:string;var tsRst:TStringList):boolean;
var f: File  of TIFRSDatRec; recs:TIFRSDatRecAry; srcrec:TIFRSDatRecAry;
 b:boolean;  i,j,k,n,ReMain,ReMain2,ReMain3,GotCount,ic,ReMain4,GotCount4:integer;
 sTmpFile,sTemp1,sOneRst:string;
begin
  result:=false;
  sTmpFile:=ChangeFileExt(aDstF,'.temp');
try
  ReMain2:=tsSrc.count*2; ReMain:=0; GotCount:=0; SetLength(recs,0);
  if FileExists(aDstF) then
  begin
    try
      AssignFile(f,aDstF);
      FileMode := 0;
      reset(f);
      ReMain := FileSize(f);
      ReMain2:=ReMain+tsSrc.count*2;
      SetLength(recs,ReMain2);
      if ReMain>0 then
        BlockRead(f,recs[0],ReMain,GotCount);
    finally
      try CloseFile(f); except end;
    end;
  end
  else begin
    SetLength(recs,ReMain2);
  end;
  for k:=GotCount to High(recs) do
    recs[k].CompCode:='';
  //WriteLineForApp(aDstF+'ReMain2='+inttostr(ReMain2));

  tsRst.clear;
  for k:=0 to tsSrc.count-1 do
  begin
    sOneRst:='0';
    if FileExists(tsSrc[k]) then
    begin
      SetLength(srcrec,0);
      try
        AssignFile(f,tsSrc[k]);
        FileMode := 0;
        reset(f);
        ReMain4 := FileSize(f);
        SetLength(srcrec,ReMain4);
        if ReMain4>0 then
          BlockRead(f,srcrec[0],ReMain4,GotCount4);
      finally
        try CloseFile(f); except end;
      end;

      for n:=0 to High(srcrec) do
      begin
        //--如果是相同的代碼，則只更新數據，否則新增一筆
        b:=False;
        for i:=0 to High(recs) do
        begin
          if SameText(recs[i].CompCode,srcrec[n].CompCode) and
             (recs[i].Year=srcrec[n].Year) and
             (recs[i].Q=srcrec[n].Q) and
             (recs[i].Tbl=srcrec[n].Tbl)  then
          begin
            b:=true;
            AssignTIFRSDatRec(srcrec[n],recs[i]);
            Break;
          end;
        end;
        if not b then
        begin
          //WriteLineForApp(Format('%d/%d GotCount=%d.%s.  n=%d,%s,%dQ%d,%d',[k+1,tsSrc.count,GotCount,tsSrc[k],
          // n,srcrec[n].CompCode,srcrec[n].Year,srcrec[n].Q,srcrec[n].Tbl    ]) );
          AssignTIFRSDatRec(srcrec[n],recs[GotCount]);
          Inc(GotCount);
        end;
      end;
      sOneRst:='1';
    end;
    tsRst.Add(sOneRst);
  end;
  if tsRst.Count<>tsSrc.Count then
    exit;
  if Length(recs)<>GotCount then
    SetLength(recs,GotCount);

  SortIFRSDatRecAry(recs);
  try
    AssignFile(f,sTmpFile);
    FileMode := 2;
    Rewrite(f);
    GotCount:=Length(recs);
    BlockWrite(f,recs[0],GotCount);
  finally
    try CloseFile(f); except end;
  end;
  b:=false;
  for i:=1 to 5 do
  begin
    b:=CopyFile(PChar(sTmpFile),PChar(aDstF),False);
    if b then
      Break
    else
      Sleep(1500);
  end;

  result:=true;
finally
  try SetLength(recs,0); except end;
  try SetLength(srcrec,0); except end;
  if FileExists(sTmpFile) then
    DeleteFile(sTmpFile);
end;
end;

function IFRSTblChr2Str(aTblChr:char):string;
begin
  if aTblChr=_ZCFZB then
    result:=_ZCFZBStr
  else if (aTblChr=_ZZSYB) or (aTblChr=_ZZSYB2) then
    result:=_ZZSYBStr
  else if aTblChr=_XJLLB then
    result:=_XJLLBStr;
end;

procedure Init_TIFRSDatRec(var Rec:TIFRSDatRec);
var i:integer;
begin
  with Rec do
  begin
    CompCode:='';
    Year:=0;
    Q:=0;
    Tbl:=0;
    for i:=0 to High(NumAry) do
    begin
      NumAry[i]:=NoneNum2;
      IdxAry[i]:=-1;
    end;
  end;
end;

procedure AssignTIFRSDatRec(aSrc:TIFRSDatRec;var aDst:TIFRSDatRec);
var i:integer;
begin
  aDst.CompCode:=aSrc.CompCode;
  aDst.Year:=aSrc.Year;
  aDst.Q:=aSrc.Q;
  aDst.Tbl:=aSrc.Tbl;
  for i:=0 to High(aSrc.NumAry) do
  begin
    aDst.NumAry[i]:=aSrc.NumAry[i];
    aDst.IdxAry[i]:=aSrc.IdxAry[i];
  end;
end;

function IFRS_GetRecOfIFRSData(aYear,aQ,aTbl:integer;aInputCode,aDataFile:string):TIFRSDatRec;
var fBCode: File  of TIFRSDatRec; rBCode: TIFRSDatRec;
  ReMain,GotCount,j:integer;
begin
  Init_TIFRSDatRec(result);
  if FileExists(aDataFile) then
  try
    AssignFile(fBCode,aDataFile);
    FileMode := 0;
    ReSet(fBCode);
    while not Eof(fBCode) do
    begin
      read(fBCode,rBCode);
      if SameText(rBCode.CompCode,aInputCode) and
         (rBCode.Year=aYear) and
         (rBCode.Q=aQ) and
         (rBCode.Tbl=aTbl)
          then
      begin
        result:=rBCode;
        Exit;
      end;
    end;
  finally
    try CloseFile(fBCode); except end;
  end;
end;

function IfrsSpecTbl2(aInputTbl:Char;aQ:Integer):boolean;
begin
  result:=(aInputTbl=_ZZSYB) and ( aQ in [2,3] );
end;

function IFRS_GetCodeList(aDataFile:string;var ts:TStringList):boolean;
var fBCode: File  of TIFRSDatRec; rBCode: TIFRSDatRec;
  ReMain,GotCount,j:integer;
begin
  result:=False;
  ts.clear;
  if FileExists(aDataFile) then
  try
    AssignFile(fBCode,aDataFile);
    FileMode := 0;
    ReSet(fBCode);
    while not Eof(fBCode) do
    begin
      read(fBCode,rBCode);
      ts.Add(rBCode.CompCode);
    end;
  finally
    try CloseFile(fBCode); except end;
  end;
  result:=true;
end;

end.
