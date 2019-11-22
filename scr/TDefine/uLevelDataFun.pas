unit uLevelDataFun;

interface
 uses Windows,Classes,Controls,IniFiles,SysUtils,TCommon,uLevelDataDefine;
 
const
  _CDaiXia='0';
  _CXiaing='1';
  _CXiaOK='2';
  _CXiaFail='3';
  _CShen='4';
  _CNoNeedShen='5';
  _CCreateWorkList='6';
  _CCreateWorkListFail='7';
  _CCreateWorkListReady='8';
  _CCircleOk='9';

  _CStrDaiXia='待下載';
  _CStrXiaing='下載中';
  _CStrXiaOK='下載成功';
  _CStrXiaFail='下載失敗';
  _CStrShen='已保存';
  _CTodayD='今日數據--';
  _CStrNoNeedShen='無需處理';
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
function UptIFRSRecToTr1db(aSrcF,aDstF:string):integer;
function GetIFRSFile2File(aSrcF,aDstF,aCode:string):boolean;
function IFRSTblChr2Str(aTblChr:char):string;

procedure Init_TIFRSDatRec(var Rec:TIFRSDatRec);
function IFRS_GetRecOfIFRSData(aInputCode,aDataFile:string):TIFRSDatRec;


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
       Result:=_CStrXiaOK
     else if aInput=_CXiaFail then
       Result:=_CStrXiaFail
     else if aInput=_CShen then
       Result:=_CStrShen
     else if aInput=_CNoNeedShen then
       Result:=_CStrNoNeedShen
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
var f: File  of TIFRSDatRec; recs:TIFRSDatRecAry; srcrec:TIFRSDatRec;
 b:boolean;  i,j,ReMain,GotCount:integer;
 sTmpFile,sTemp1:string;
begin
  result:=-1;
  sTmpFile:=ChangeFileExt(aDstF,'.tmp');
try
  if not FileExists(aSrcF) then
  begin
    result:=0;
    exit;
  end;
  try
    AssignFile(f,aSrcF);
    FileMode := 0;
    reset(f);
    read(f,srcrec);
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

  b:=False;
  for i:=0 to High(recs) do
  begin
    if SameText(recs[i].CompCode,srcrec.CompCode) then
    begin
      b:=true;
      for j:=0 to High(srcrec.NumAry) do
      begin
        recs[i].NumAry[j]:=srcrec.NumAry[j];
        recs[i].IdxAry[j]:=srcrec.IdxAry[j];
      end;
      Break;
    end;
  end;
  if not b then
  begin
    GotCount:=Length(recs);
    setLength(recs,GotCount+1);
    recs[GotCount].CompCode:=srcrec.CompCode;
    for i:=0 to High(srcrec.NumAry) do
    begin
      recs[GotCount].NumAry[i]:=srcrec.NumAry[i];
      recs[GotCount].IdxAry[i]:=srcrec.IdxAry[i];
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
  if FileExists(sTmpFile) then
    DeleteFile(sTmpFile);
end;
end;

function IFRSTblChr2Str(aTblChr:char):string;
begin
  if aTblChr=_ZCFZB then
    result:=_ZCFZBStr
  else if aTblChr=_ZZSYB then
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
    for i:=0 to High(NumAry) do
    begin
      NumAry[i]:=NoneNum2;
      IdxAry[i]:=-1;
    end;
  end;
end;

function IFRS_GetRecOfIFRSData(aInputCode,aDataFile:string):TIFRSDatRec;
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
      if SameText(rBCode.CompCode,aInputCode) then
      begin
        result:=rBCode;
        Exit;
      end;
    end;
  finally
    try CloseFile(fBCode); except end;
  end;
end;

end.
