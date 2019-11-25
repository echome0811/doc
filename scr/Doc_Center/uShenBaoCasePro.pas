unit uShenBaoCasePro;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes,ExtCtrls,Forms,Controls,
    TCommon,IniFiles,CSDef,uLevelDataDefine,uLevelDataFun;
type
  TDatasRecThis=record
    Datas:array[0..19] of string[250];
  end;
  
function MakeDiffOfShenBaoCase(aTr1dbPath,aTxtDatFile,aGUID:string;aUptLogSaveDays:Integer;var aErrMsg:string):Boolean;
function SetDataOfShenBaoCase(aTr1dbPath,aTxtDatFile,aThisDatFile,aThisUrlList:string;aUptLogSaveDays:Integer;var aErrMsg:string):Boolean;

implementation

var aComCodeList:array of TShenBaoCaseComRec;
    bChangeComCode:Boolean=false;

function InitComCodeRecList(aTr1dbPath:ShortString):integer;
var xx1,xx2:integer; xxsFile00:string;
    xxf1:File of TShenBaoCaseComRec;
begin
  Result:=0;
  SetLength(aComCodeList,0);
  bChangeComCode:=false;
  xxsFile00:=aTr1dbPath+'CBData\ShenBaoCase\'+_ShenBaoCaseComCodeF;
  if FileExists(xxsFile00) then
  try
    AssignFile(xxf1,xxsFile00);
    FileMode := 0;
    ReSet(xxf1);
    xx1 := FileSize(xxf1);
    SetLength(aComCodeList,xx1);
    BlockRead(xxf1,aComCodeList[0],xx1,xx2);
  finally
    try CloseFile(xxf1); except end;
  end;
  Result:=1;
end;

function IndexOfComCode(aClass,aName:string):integer;
var xx1,xx2,xx1s,xx1e:integer; xb1:boolean;
begin
  result:=-1;
  xx1s:=Low(aComCodeList);
  xx1e:=High(aComCodeList);
  for xx1:=xx1s to xx1e do
  begin
    Application.ProcessMessages;
    xb1:=(sametext(aComCodeList[xx1].ClassCode,aClass)) and
       (sametext(aComCodeList[xx1].Name,aName));
    if xb1 then
    begin
      result:=aComCodeList[xx1].Idx;
      break;
    end;
  end;
end;

function SendToComCode(aClass,aName:string):integer;
var xx1,xx2,xx3,xx4:integer;
begin
  result:=-1;
  xx2:=IndexOfComCode(aClass,aName);
  if xx2=-1 then
  begin
    bChangeComCode:=true;
    xx3:=Length(aComCodeList);
    SetLength(aComCodeList,xx3+1);
    aComCodeList[xx3].Idx:=xx3;
    aComCodeList[xx3].Name:=aName;
    aComCodeList[xx3].ClassCode:=aClass;
    result:=aComCodeList[xx3].Idx;
  end
  else begin
    result:=aComCodeList[xx2].Idx;
  end;
end;

function GetOfComName(aInputIdx:integer):string;
begin
  result:='';
  if (aInputIdx>=0) and (aInputIdx<=High(aComCodeList)) then
  begin
    Result:=aComCodeList[aInputIdx].Name;
  end;
end;

function FreeComCodeRecList(aTr1dbPath:ShortString):integer;
var xx1,xx2,xx3,xx4:integer; xxsFile00,xxsFile01:string;
    xxf1: File  of TShenBaoCaseComRec;
begin
  Result:=0;
  xxsFile00:=aTr1dbPath+'CBData\ShenBaoCase\'+_ShenBaoCaseComCodeF;
  xxsFile01:=ExtractFilePath(xxsFile00)+'~'+ExtractFileName(xxsFile00);
  try
    if Length(aComCodeList)>0 then
    begin
      try
        AssignFile(xxf1,xxsFile01);
        FileMode := 2;
        Rewrite(xxf1);
        xx1 := Length(aComCodeList);
        BlockWrite(xxf1,aComCodeList[0],xx1);
      finally
        try CloseFile(xxf1); except end;
      end;
      if not CpyF(xxsFile01,xxsFile00) then
      begin
        //ShowMsgEx('(warn)'+'copy fail.'+xxsFile01);
        exit;
      end;
    end;
    Result:=1;
  finally
    DelF(xxsFile01);
  end;
end;

function ShenBaoCaseLstFile(aTr1dbPath:ShortString):string;
begin
  Result:=aTr1dbPath+'CBData\ShenBaoCase\'+_ShenBaoCaseLstF;
end;

procedure ClsUptDatLog(aTr1dbPath:ShortString;aUptLogSaveDays:Integer);
var FIni:TIniFile; ts:TStringList;
  i,ic:integer; sLine,sTime,sFile,sBeginTime,sEndTime:string;
  b:Boolean;
begin
  sFile:=ShenBaoCaseLstFile(aTr1dbPath);
  if not FileExists(sFile) then
    exit;
  sEndTime:=FormatDateTime('yyyymmdd',date+1)+'_000000';
  sBeginTime:=FormatDateTime('yyyymmdd',date-aUptLogSaveDays)+'_000000';
  try
    FIni:=TIniFile.Create(sFile);
    ts:=TStringList.create;
    ic:=FIni.ReadInteger('his','count',0);
    b:=false;
    for i:=1 to ic do
    begin
      sLine:=FIni.ReadString('his',IntToStr(i),'');
      sTime:=GetStrOnly2Ex('thisdir=','@',sLine,false);
      if (sTime>=sBeginTime) then
      begin
        ts.Add(sLine);
      end
      else begin
        b:=true;
      end;
    end;
    if b then
    begin
      FIni.EraseSection('his');
      for i:=0 to ts.count-1 do
      begin
        FIni.WriteString('his',IntToStr(i+1),ts[i]);
      end;
      FIni.WriteInteger('his','count',ts.count);
    end;
  finally
    try if Assigned(FIni) then FreeAndNil(FIni); except end;
    try if Assigned(ts) then FreeAndNil(ts); except end;
  end;
end;

function SetDataOfShenBaoCase(aTr1dbPath,aTxtDatFile,aThisDatFile,aThisUrlList:string;aUptLogSaveDays:Integer;var aErrMsg:string):Boolean;
const _SepDThis=#9;
var xxf1,xxf3: File  of TShenBaoCaseRec; xARec:TShenBaoCaseRec; xxf2: File  of TDatasRecThis;
    xx1,xx2,xx3:integer;  xAryInt:array[0..5] of integer;
    xstr1,xstr2,xstr3,xstr4,xstr5,xstrTempFile:string;
    xFIni:TIniFile; ts:TStringList; aRecLst:array of TDatasRecThis;
    sShenBaoCaseLstFile,sLastDatFile,sLastDir,sThisDir,FDataPath,sDiffText:string;
    tsKey:array OF ShortString; bInKey:boolean;

  function InThisKeyList(aInputKey:string):boolean;
  var xi:integer;
  begin
    result:=false;
    for xi:=Low(tsKey) to High(tsKey) do
    begin
      if SameText(aInputKey,tsKey[xi]) then
      begin
        result:=true;
        exit;
      end;
    end;
  end;
begin
  result:=false; aErrMsg:='';
  FDataPath:=aTr1dbPath+'CBData\ShenBaoCase\';

  sShenBaoCaseLstFile:=ShenBaoCaseLstFile(aTr1dbPath);
  if not FileExists(sShenBaoCaseLstFile) then
  begin
    aErrMsg:='申報案件清單文件不存在.'+sShenBaoCaseLstFile;
    exit;
  end;
  xFIni:=TIniFile.Create(sShenBaoCaseLstFile);
  sDiffText:=xFIni.ReadString('diff','text','');
  FreeAndNil(xFIni);

  if sDiffText='' then
  begin
    aErrMsg:='無資料變更,無需保存數據.';
    exit;
  end;
  if aThisDatFile='' then
  begin
    aErrMsg:='參數錯誤,操作文檔名為空.';
    exit;
  end;
  if aThisUrlList='' then
  begin
    aErrMsg:='參數錯誤,網址列表為空.';
    exit;
  end;

  if InitComCodeRecList(aTr1dbPath)<>1 then
  begin
    aErrMsg:='初始化數據字典失敗.';
    exit;
  end;

  SetLength(aRecLst,0);
  if FileExists(aTxtDatFile) then
  try
    AssignFile(xxf2,aTxtDatFile);
    FileMode := 0;
    ReSet(xxf2);
    xx1 := FileSize(xxf2);
    SetLength(aRecLst,xx1);
    ReSet(xxf2);
    xx2:=0; xstr5:='';
    while not Eof(xxf2) do
    begin
      read(xxf2,aRecLst[xx2]);
      //將所有的key都添加到tsKey中中；下面也只比對這些key的資料
      if not SameText(xstr5,aRecLst[xx2].Datas[18]) then
      begin
        xstr5:=aRecLst[xx2].Datas[18];
        if not InThisKeyList(xstr5) then
        begin
          xx3:=Length(tsKey);
          SetLength(tsKey,xx3+1);
          tsKey[xx3]:=xstr5;
        end;
      end;
      Inc(xx2);
    end;
  finally
    try CloseFile(xxf2); except end;
  end;
  if Length(aRecLst)=0 then
  begin
    aErrMsg:='沒有讀取到任何提交資料.';
    exit;
  end;

  //將歷史的資料預先存儲到臨時文檔中
  xstrTempFile:=FDataPath+'~'+aThisDatFile;
  xstr1:=FDataPath+aThisDatFile;
  if FileExists(xstr1) then
  begin
    try
      AssignFile(xxf1,xstrTempFile);
      AssignFile(xxf3,xstr1);
      FileMode := 2;
      Rewrite(xxf1);
      ReSet(xxf3); xstr5:=''; bInKey:=false;
      while not Eof(xxf3) do
      begin
        read(xxf3,xARec);
        if not SameText(xstr5,xARec.key) then
        begin
          xstr5:=xARec.key;
          bInKey:=InThisKeyList(xstr5);
        end;
        if not bInKey then
        begin
          write(xxf1,xARec);
        end;
      end;
    finally
      CloseFile(xxf1);
    end;
  end;

      try
        AssignFile(xxf1,xstrTempFile);
        FileMode := 2;
        if not FileExists(xstrTempFile) then
          ReWrite(xxf1)
        else begin
          ReSet(xxf1);
          Seek(xxf1,filesize(xxf1));
        end;
        for xx1:=0 to High(aRecLst) do
        begin
          Application.ProcessMessages;
          with aRecLst[xx1] do
          begin
            xAryInt[0]:=SendToComCode('gsxt',Datas[1]);
            xAryInt[1]:=SendToComCode('jalx',Datas[2]);
            xAryInt[2]:=SendToComCode('cxs',Datas[4]);
            xAryInt[3]:=SendToComCode('ajlb',Datas[5]);
            xAryInt[4]:=SendToComCode('bblx',Datas[7]);
            xAryInt[5]:=SendToComCode('ajlx',Datas[17]);

            Datas[1]:=IntToStr(xAryInt[0]);
            Datas[2]:=IntToStr(xAryInt[1]);
            Datas[4]:=IntToStr(xAryInt[2]);
            Datas[5]:=IntToStr(xAryInt[3]);
            Datas[7]:=IntToStr(xAryInt[4]);
            Datas[17]:=IntToStr(xAryInt[5]);


            with xARec do
            begin
              key:=Datas[18];
              code:=Datas[0];//證券代號
              mkt:=xAryInt[0];//公司型態--gsxt
              closetype:=xAryInt[1];//結案類型--jalx
              stkname:=Datas[3];//公司名稱
              memberclass:=xAryInt[2];//承銷商--cxs
              caseclass:=xAryInt[3];//案件類別--ajlb
              amount:=Datas[6];//金　　　　額(元)
              moneytype:=xAryInt[4];//幣別--bblx
              issueprice:=Datas[8];//發行價格
              swrq:=Datas[9];//收文日期
              zdbzrq:=Datas[10];//自動補正日期
              tzsxrq:=Datas[11];//停止生效日期
              jcsxrq:=Datas[12];//解除生效日期
              sxrq:=Datas[13];//生效日期
              fzcxrq:=Datas[14];//廢止/撤銷日期
              zxcxrq:=Datas[15];//自行撤回日期
              tjrq:=Datas[16];//退件日期
              casetype:=xAryInt[5];//案件性質--ajlx
            end;
            write(xxf1,xARec);
          end;
        end;
      finally
        try CloseFile(xxf1); except end;
      end;
      SetLength(aRecLst,0);

    if bChangeComCode then
      if FreeComCodeRecList(aTr1dbPath)<>1 then
      begin
        aErrMsg:='存儲數據字典失敗.';
        exit;
      end;

    if CpyF(xstrTempFile,FDataPath+aThisDatFile) then
    begin
      DelF(xstrTempFile);
    end
    else begin
      aErrMsg:='保存數據失敗.';
      exit;
    end;
    try
      xFIni:=TIniFile.Create(sShenBaoCaseLstFile);
      xx1:=xFIni.ReadInteger('his','count',0);
      xFIni.WriteString('his',IntToStr(xx1+1),sDiffText);
      xFIni.WriteInteger('his','count',xx1+1);


      xFIni.EraseSection('last');
      xFIni.WriteString('last','datfile',ExtractFileName(aThisDatFile));
      xstr2:=xFIni.ReadString('diff','thisdir','');
      xFIni.WriteString('last','dir',xstr2);

      ts:=TStringList.Create;
      ts.Text:=StringReplace(aThisUrlList,'#13#10',#13#10,[rfReplaceAll]);
      xx2:=-1;
      for xx1:=0 to ts.count-1 do
      begin
        if trim(ts[xx1])<>'' then
        begin
          Inc(xx2);
          xFIni.WriteString('last',IntToStr(xx2),trim(ts[xx1]));
        end;
      end;
      FreeAndNil(ts);
    finally
      try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
    end;
    ClsUptDatLog(aTr1dbPath,aUptLogSaveDays);
    result:=true;
end;


function MakeDiffOfShenBaoCase(aTr1dbPath,aTxtDatFile,aGUID:string;aUptLogSaveDays:Integer;var aErrMsg:string):Boolean;
const _SepDThis=#9;
var xxf1: File  of TShenBaoCaseRec;  xxf2: File  of TDatasRecThis;
    xx1,xx2,xx3:integer;  xAryInt:array[0..5] of integer;
    xOldDatList:array of TShenBaoCaseRec; xARec:TShenBaoCaseRec;
    xstr1,xstr2,xstr3,xstr4,xstr5:string;
    xFIni:TIniFile; aRecLst:array of TDatasRecThis; aRecLst2:TAryDatasRec;
    sShenBaoCaseLstFile,sLastDatFile,sLastDir,sThisDir,FDataPath:string;
    tsKey:array OF ShortString; bInKey:boolean;


  function GetStrFromRecLst2:string;
  const _SepThisSub='@';
        _SepThisSub2=';';
  var x1:integer; xstr1:string;
  begin
    result:='thisdir='+sThisDir+_SepThisSub+
             'lastdir='+sLastDir+_SepThisSub;
    for x1:=0 to High(aRecLst2) do
    begin
      Application.ProcessMessages;
      xstr1:=
             'key='+aRecLst2[x1].Datas[0]+_SepThisSub+
             'add='+aRecLst2[x1].Datas[1]+_SepThisSub+
             'mdf='+aRecLst2[x1].Datas[2]+_SepThisSub+
             'del='+aRecLst2[x1].Datas[3]+_SepThisSub;
      result:=result+_SepThisSub2+xstr1;
    end;
  end;
  procedure AddToRecLst2(aInputKey,aInputCode:string;aType:integer);
  var x1,x2,x3:integer; xstr1:string;
  begin
    x2:=-1;
    for x1:=0 to High(aRecLst2) do
    begin
      Application.ProcessMessages;
      if SameText(aRecLst2[x1].Datas[0],aInputKey) then
      begin
        x2:=x1;
        Break;
      end;
    end;
    if x2=-1 then
    begin
      x2:=Length(aRecLst2);
      setLength(aRecLst2,x2+1);
      aRecLst2[x2].Datas[0]:=aInputKey;
    end;
    xstr1:=aRecLst2[x2].Datas[aType];
    if Pos(aInputCode,xstr1)<=0 then
    begin
      xstr1:=xstr1+','+aInputCode;
      aRecLst2[x2].Datas[aType]:=xstr1;
    end;
  end;
  function InThisKeyList(aInputKey:string):boolean;
  var xi:integer;
  begin
    result:=false;
    for xi:=Low(tsKey) to High(tsKey) do
    begin
      if SameText(aInputKey,tsKey[xi]) then
      begin
        result:=true;
        exit;
      end;
    end;
  end;
begin
  result:=false; aErrMsg:='';
  sThisDir:=FormatDateTime('yyyymmdd_hhmmss',now);
  FDataPath:=aTr1dbPath+'CBData\ShenBaoCase\';

  sShenBaoCaseLstFile:=ShenBaoCaseLstFile(aTr1dbPath);
  if not FileExists(sShenBaoCaseLstFile) then
  begin
    aErrMsg:='申報案件清單文件不存在.'+sShenBaoCaseLstFile;
    exit;
  end;

  xFIni:=TIniFile.Create(sShenBaoCaseLstFile);
  try
    sLastDatFile:=FDataPath+xFIni.ReadString('last','datfile','');
    sLastDir:=xFIni.ReadString('last','dir','');
  finally
    FreeAndNil(xFIni);
  end;
  
  if InitComCodeRecList(aTr1dbPath)<>1 then
  begin
    aErrMsg:='初始化數據字典失敗.';
    exit;
  end;
  //xstr4:='';
  SetLength(aRecLst,0);
  SetLength(aRecLst2,0);
  if FileExists(aTxtDatFile) then
  try
    AssignFile(xxf2,aTxtDatFile);
    FileMode := 0;
    ReSet(xxf2);
    xx1 := FileSize(xxf2);
    SetLength(aRecLst,xx1);
    ReSet(xxf2);
    xx2:=0; xstr5:='';
    while not Eof(xxf2) do
    begin
      read(xxf2,aRecLst[xx2]);
      //將所有的key都添加到tsKey中中；下面也只比對這些key的資料
      if not SameText(xstr5,aRecLst[xx2].Datas[18]) then
      begin
        xstr5:=aRecLst[xx2].Datas[18];
        if not InThisKeyList(xstr5) then
        begin
          xx3:=Length(tsKey);
          SetLength(tsKey,xx3+1);
          tsKey[xx3]:=xstr5;
        end;
      end;
      //xstr4:=xstr4+#13#10+aRecLst[xx2].Datas[18]+';'+aRecLst[xx2].Datas[0];
      Inc(xx2);
    end;
  finally
    try CloseFile(xxf2); except end;
  end;
  //WriteLineForApp(xstr4,'2');
  if Length(aRecLst)=0 then
  begin
    aErrMsg:='沒有讀取到任何提交資料.';
    exit;
  end;  

    SetLength(xOldDatList,0);
    if FileExists(sLastDatFile) then
    try
      AssignFile(xxf1,sLastDatFile);
      FileMode := 0;
      ReSet(xxf1);
      xx1 := FileSize(xxf1);
      SetLength(xOldDatList,xx1);
      ReSet(xxf1);
      xx2:=0; xstr5:=''; bInKey:=false;
      while not Eof(xxf1) do
      begin
        read(xxf1,xOldDatList[xx2]);
        if not SameText(xstr5,xOldDatList[xx2].key) then
        begin
          xstr5:=xOldDatList[xx2].key;
          bInKey:=InThisKeyList(xstr5);
        end;
        //非tsKey中的資料不讀取，也不做比對
        if not bInKey then
        begin
          Continue;
        end;
        Inc(xx2);
      end;
      SetLength(xOldDatList,xx2);
    finally
      try CloseFile(xxf1); except end;
    end;
    {xstr4:='';
    for xx1:=0 to High(xOldDatList) do
    begin  
      with xOldDatList[xx1] do
      begin
        xstr4:=xstr4+#13#10+key+';'+code;
      end;
    end;
    WriteLineForApp(xstr4,'3');  }
    SetLength(tsKey,0);
    
    for xx1:=0 to High(aRecLst) do
    begin
      Application.ProcessMessages;
      with aRecLst[xx1] do
      begin
        xAryInt[0]:=SendToComCode('gsxt',Datas[1]);
        xAryInt[1]:=SendToComCode('jalx',Datas[2]);
        xAryInt[2]:=SendToComCode('cxs',Datas[4]);
        xAryInt[3]:=SendToComCode('ajlb',Datas[5]);
        xAryInt[4]:=SendToComCode('bblx',Datas[7]);
        xAryInt[5]:=SendToComCode('ajlx',Datas[17]);

        Datas[1]:=IntToStr(xAryInt[0]);
        Datas[2]:=IntToStr(xAryInt[1]);
        Datas[4]:=IntToStr(xAryInt[2]);
        Datas[5]:=IntToStr(xAryInt[3]);
        Datas[7]:=IntToStr(xAryInt[4]);
        Datas[17]:=IntToStr(xAryInt[5]);
      end;
    end;
    if bChangeComCode then
      if FreeComCodeRecList(aTr1dbPath)<>1 then
      begin
        aErrMsg:='存儲數據字典失敗.';
        exit;
      end;

  //第一次，比較本次下載資料中"月份已結"的資料（如key為105,11）
  for xx1:=High(aRecLst) downto 0 do
  begin
    if (Pos(_UnDo,aRecLst[xx1].Datas[18])>0) then
    begin
      Continue;
    end;
    if aRecLst[xx1].Datas[18]='' then
      Continue;
    if (Pos(',',aRecLst[xx1].Datas[18])<=0) then
        Continue;
    Application.ProcessMessages;
    xstr3:=aRecLst[xx1].Datas[18];
    xstr4:=aRecLst[xx1].Datas[0];
    xstr5:=GetOfComName(StrToInt(aRecLst[xx1].Datas[5]));
    xx3:=1;//1=add 2=mdf 3=del  4=deng
    for xx2:=High(xOldDatList) downto 0 do
    begin
      if xOldDatList[xx2].key='' then
        Continue;
      if SameText(aRecLst[xx1].Datas[18],xOldDatList[xx2].key) and
         SameText(aRecLst[xx1].Datas[0],xOldDatList[xx2].code) and
           
         SameText(aRecLst[xx1].Datas[5],IntToStr(xOldDatList[xx2].caseclass) ) and
         SameText(aRecLst[xx1].Datas[6],xOldDatList[xx2].amount) and
         SameText(aRecLst[xx1].Datas[9],xOldDatList[xx2].swrq)then
      begin
        xx3:=2;
        with aRecLst[xx1] do
        begin
          xstr1:=Datas[18]+_SepDThis+Datas[0]+_SepDThis+
              Datas[1]+_SepDThis+Datas[2]+_SepDThis+
              Datas[3]+_SepDThis+Datas[4]+_SepDThis+
              Datas[5]+_SepDThis+Datas[6]+_SepDThis+
              Datas[7]+_SepDThis+Datas[8]+_SepDThis+
              Datas[9]+_SepDThis+Datas[10]+_SepDThis+
              Datas[11]+_SepDThis+Datas[12]+_SepDThis+
              Datas[13]+_SepDThis+Datas[14]+_SepDThis+
              Datas[15]+_SepDThis+Datas[16]+_SepDThis+Datas[17];
        end;

        with xOldDatList[xx2] do
        begin
          xstr2:=key+_SepDThis+code+_SepDThis+
            IntToStr(mkt)+_SepDThis+IntToStr(closetype)+_SepDThis+
            stkname+_SepDThis+IntToStr(memberclass)+_SepDThis+
            IntToStr(caseclass)+_SepDThis+(amount)+_SepDThis+
            IntToStr(moneytype)+_SepDThis+(issueprice)+_SepDThis+
            swrq+_SepDThis+zdbzrq+_SepDThis+
            tzsxrq+_SepDThis+jcsxrq+_SepDThis+
            sxrq+_SepDThis+fzcxrq+_SepDThis+
            zxcxrq+_SepDThis+tjrq+_SepDThis+IntToStr(casetype);
        end;
        if SameText(xstr1,xstr2) then
          xx3:=4
        else begin
        end;
        aRecLst[xx1].Datas[18]:='';
        xOldDatList[xx2].key:='';
        Break;
      end;
    end;//--xunhuanbidui
    if xx3<>4 then
    begin
      AddToRecLst2(xstr3,xstr4+'/'+xstr5,xx3); //+xstr6
    end;
  end;

  //第二次，比較本次下載資料中"未結"的資料（可能包括105,undo、104,undo）
  for xx1:=High(aRecLst) downto 0 do
  begin
    if not (Pos(_UnDo,aRecLst[xx1].Datas[18])>0) then
    begin
      Continue;
    end;
    if aRecLst[xx1].Datas[18]='' then
      Continue;
    if (Pos(',',aRecLst[xx1].Datas[18])<=0) then
        Continue;
    Application.ProcessMessages;
    xstr3:=aRecLst[xx1].Datas[18];
    xstr4:=aRecLst[xx1].Datas[0];
    xstr5:=GetOfComName(StrToInt(aRecLst[xx1].Datas[5]));
    xx3:=1;//1=add 2=mdf 3=del  4=deng
    for xx2:=High(xOldDatList) downto 0 do
    begin
      if xOldDatList[xx2].key='' then
        Continue;
      if SameText(aRecLst[xx1].Datas[18],xOldDatList[xx2].key) and
         SameText(aRecLst[xx1].Datas[0],xOldDatList[xx2].code) and
           
         SameText(aRecLst[xx1].Datas[5],IntToStr(xOldDatList[xx2].caseclass) ) and
         SameText(aRecLst[xx1].Datas[6],xOldDatList[xx2].amount) and
         SameText(aRecLst[xx1].Datas[9],xOldDatList[xx2].swrq)then
      begin
        xx3:=2;
        with aRecLst[xx1] do
        begin
          xstr1:=Datas[18]+_SepDThis+Datas[0]+_SepDThis+
              Datas[1]+_SepDThis+Datas[2]+_SepDThis+
              Datas[3]+_SepDThis+Datas[4]+_SepDThis+
              Datas[5]+_SepDThis+Datas[6]+_SepDThis+
              Datas[7]+_SepDThis+Datas[8]+_SepDThis+
              Datas[9]+_SepDThis+Datas[10]+_SepDThis+
              Datas[11]+_SepDThis+Datas[12]+_SepDThis+
              Datas[13]+_SepDThis+Datas[14]+_SepDThis+
              Datas[15]+_SepDThis+Datas[16]+_SepDThis+Datas[17];
        end;

        with xOldDatList[xx2] do
        begin
          xstr2:=key+_SepDThis+code+_SepDThis+
            IntToStr(mkt)+_SepDThis+IntToStr(closetype)+_SepDThis+
            stkname+_SepDThis+IntToStr(memberclass)+_SepDThis+
            IntToStr(caseclass)+_SepDThis+(amount)+_SepDThis+
            IntToStr(moneytype)+_SepDThis+(issueprice)+_SepDThis+
            swrq+_SepDThis+zdbzrq+_SepDThis+
            tzsxrq+_SepDThis+jcsxrq+_SepDThis+
            sxrq+_SepDThis+fzcxrq+_SepDThis+
            zxcxrq+_SepDThis+tjrq+_SepDThis+IntToStr(casetype);
        end;
        if SameText(xstr1,xstr2) then
          xx3:=4
        else begin
        end;
        aRecLst[xx1].Datas[18]:='';
        xOldDatList[xx2].key:='';
        Break;
      end;
    end;//--xunhuanbidui
    if xx3<>4 then
    begin
      AddToRecLst2(xstr3,xstr4+'/'+xstr5,xx3); //+xstr6
    end;
  end;
    
  //剩下的都是相對刪除的
  for xx1:=High(xOldDatList) downto 0 do
  begin
    Application.ProcessMessages;
    with xOldDatList[xx1] do
    begin
      if (Pos(_UnDo,key)>0) then
      begin
        Continue;
      end;
      if (Pos(',',key)<=0) then
        Continue;
      if key='' then
        Continue;
      xstr3:=key;
      xstr4:=code;
      xstr5:=GetOfComName(caseclass);
      AddToRecLst2(xstr3,xstr4+'/'+xstr5,3);
    end;
  end;
  for xx1:=High(xOldDatList) downto 0 do
  begin
    Application.ProcessMessages;
    with xOldDatList[xx1] do
    begin
      if (Pos(',',key)<=0) then
        Continue;
      if not (Pos(_UnDo,key)>0) then
      begin
        Continue;
      end;
      if key='' then
        Continue;
      xstr3:=key;
      xstr4:=code;
      xstr5:=GetOfComName(caseclass);
      AddToRecLst2(xstr3,xstr4+'/'+xstr5,3);
    end;
  end;

  try
    xFIni:=TIniFile.Create(sShenBaoCaseLstFile);
    xstr3:=GetStrFromRecLst2;
    xFIni.WriteString('diff','guid',aGUID);
    xFIni.WriteString('diff','text',xstr3);
    xFIni.WriteString('diff','thisdir',sThisDir);
  finally
    try if Assigned(xFIni) then FreeAndNil(xFIni); except end;
  end;
  result:=true;

  SetLength(aRecLst,0);
  SetLength(aRecLst2,0);
  SetLength(xOldDatList,0);
end;

end.
