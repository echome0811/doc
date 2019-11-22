unit uCBDataTokenMng;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,ExtCtrls,Forms,TCommon;

type
  TCBDTokenRec=record
    FileName:string;
    GUID:string;
    Token:string;
    TokenTime:DWORD;
  end;
  TCBDTokenRecAry=array of TCBDTokenRec;

  TCBDataTokenMng = Class
  private
     FDoing:boolean;
     FTw:Boolean;
     FCs: TRTLCriticalSection;
     FMonitor:TTimer;
     FTimeOut:integer;
     procedure MonitorTimer(Sender: TObject);
     procedure Init;
     procedure RandGUIDList;
     function Lock:boolean;
     function UnLock:boolean;
     procedure SleepAWhile(aWhile:integer=3000);

  public
      FCBDataList: TCBDTokenRecAry;

      constructor Create(aTimeOut:integer;aRandGUID:boolean;aTw:Boolean);
      destructor  Destroy; override;
      function GetDatGuid(aDatFileName:string):string;
      function SetDatGuid(aDatFileName,aGuid,aLocker:string):Boolean;
      function CheckDatGuid(aDatFileName,aGuid:string):boolean;
      function CheckDatLock(aDatFileName:string):string;
      function LockDat(aDatFileName,aLocker:string):boolean;
      function UnLockDat(aDatFileName,aLocker:string):boolean;
      function LockDatFileList(aDatFileList:_cStrLst2;aLocker:string):boolean;
      function UnLockDatFileList(aDatFileList:_cStrLst2;aLocker:string):boolean;
      function IndexOfDat(aDatFileName:string):integer;
      property Tw:Boolean read FTw;
  end;

  TCBDataTokenMngEcb = Class
  private
     FDoing:boolean;
     FTw:Boolean;
     FCs: TRTLCriticalSection;
     FMonitor:TTimer;
     FTimeOut:integer;
     procedure MonitorTimer(Sender: TObject);
     procedure Init;
     procedure RandGUIDList;
     function Lock:boolean;
     function UnLock:boolean;
     procedure SleepAWhile(aWhile:integer=3000);

  public
      FCBDataList: TCBDTokenRecAry;

      constructor Create(aTimeOut:integer;aRandGUID:boolean;aTw:Boolean);
      destructor  Destroy; override;
      function GetDatGuid(aDatFileName:string):string;
      function SetDatGuid(aDatFileName,aGuid,aLocker:string):Boolean;
      function CheckDatGuid(aDatFileName,aGuid:string):boolean;
      function CheckDatLock(aDatFileName:string):string;
      function LockDat(aDatFileName,aLocker:string):boolean;
      function UnLockDat(aDatFileName,aLocker:string):boolean;
      function LockDatFileList(aDatFileList:_cStrLst2;aLocker:string):boolean;
      function UnLockDatFileList(aDatFileList:_cStrLst2;aLocker:string):boolean;
      function IndexOfDat(aDatFileName:string):integer;
      property Tw:Boolean read FTw;
  end;


implementation

{ TCBDataTokenMng }

constructor TCBDataTokenMng.Create(aTimeOut:integer;aRandGUID:boolean;aTw:Boolean);
begin
  FDoing:=false;
  FTimeOut:=aTimeOut;
  FTw:=aTw;
  Init;
  if aRandGUID then
    RandGUIDList;
  InitializeCriticalSection(FCs);
  FMonitor:=TTimer.Create(nil);
  FMonitor.Tag:=0;
  FMonitor.OnTimer:=MonitorTimer;
  FMonitor.Interval:=15000;
  FMonitor.Enabled:=true;
end;

destructor TCBDataTokenMng.Destroy;
begin
  FMonitor.Tag:=1;
  FMonitor.Enabled:=false;
  FreeAndNil(FMonitor);
  DeleteCriticalSection(FCs);
  SetLength(FCBDataList,0);
  //inherited;
end;

procedure TCBDataTokenMng.Init;
var i:integer;
begin
  SetLength(FCBDataList,100);
  for i:=0 to High(FCBDataList) do
  begin
    FCBDataList[i].FileName:='';
    FCBDataList[i].GUID:='';
    FCBDataList[i].Token:='';
    FCBDataList[i].TokenTime:=0;
  end;
  i:=-1;
  if FTw then
  begin
    Inc(i);FCBDataList[i].FileName := 'cbidx2.dat';//轉股余額
    Inc(i);FCBDataList[i].FileName := 'strike4.dat';//轉股價格調整
    Inc(i);FCBDataList[i].FileName := 'cbdoc.dat';//條款原文描述
    Inc(i);FCBDataList[i].FileName := 'strike32.dat';//交易日上浮幅度
    Inc(i);FCBDataList[i].FileName := 'cbissue2.dat';//網上網下 承銷商等資料
    Inc(i);FCBDataList[i].FileName := 'cbdate.dat';//重要日期
    Inc(i);FCBDataList[i].FileName := 'cbstopconv.dat';//停止轉換期間
    Inc(i);FCBDataList[i].FileName := 'cbredeemdate.dat';//贖回條款
    Inc(i);FCBDataList[i].FileName := 'cbsaledate.dat';//賣回條款
    
    Inc(i);FCBDataList[i].FileName := 'cbpurpose.dat';//募集資金用途
  end
  else begin
    Inc(i);FCBDataList[i].FileName := 'cbidx2.dat';//轉股余額
    Inc(i);FCBDataList[i].FileName := 'strike4.dat';//轉股價格調整
    Inc(i);FCBDataList[i].FileName := 'cbdoc.dat';//條款原文描述
    Inc(i);FCBDataList[i].FileName := 'strike32.dat';//交易日上浮幅度
    Inc(i);FCBDataList[i].FileName := 'cbissue2.dat';//網上網下 承銷商等資料
    Inc(i);FCBDataList[i].FileName := 'cbpurpose.dat';//募集資金用途
    Inc(i);FCBDataList[i].FileName := 'cbdate.dat';//重要日期
    Inc(i);FCBDataList[i].FileName := 'cbbaseinfo.dat';//基本面資料
    Inc(i);FCBDataList[i].FileName := 'cbstockholder.dat';//十大股東
    Inc(i);FCBDataList[i].FileName := 'stopissuedocidx.dat';//停發公告設定
    Inc(i);FCBDataList[i].FileName := 'cbstopconv.dat';//停止轉換期間
    Inc(i);FCBDataList[i].FileName := 'cbredeemdate.dat';//贖回條款
    Inc(i);FCBDataList[i].FileName := 'cbsaledate.dat';//賣回條款
    Inc(i);FCBDataList[i].FileName := 'bond.dat';//企業債
  end;
  SetLength(FCBDataList,i+1);
end;

procedure TCBDataTokenMng.RandGUIDList;
var i:integer;
begin
  for i:=0 to High(FCBDataList) do
  begin
    FCBDataList[i].GUID:=Get_GUID8;
  end;
  //FCBDataList[0].GUID:='25D1AAEB';
end;

procedure TCBDataTokenMng.MonitorTimer(Sender: TObject);
var i:integer; iTick:DWORD;
begin
try
  FMonitor.Enabled:=false;
  if FDoing then exit;
  for i:=0 to High(FCBDataList) do
  begin
    Application.ProcessMessages;
    if FCBDataList[i].Token<>'' then
    begin
      iTick:=GetTickCount;
      if (iTick-FCBDataList[i].TokenTime>FTimeOut*1000) then
      begin
        if FDoing then exit;
        try
          Lock;
          FCBDataList[i].Token:='';
          FCBDataList[i].TokenTime:=0;
        finally
          UnLock;
        end;
      end;
    end;
  end;
finally
  if FMonitor.Tag=0 then
   FMonitor.Enabled:=True;
end;
end;

function TCBDataTokenMng.Lock:boolean;
begin
  EnterCriticalSection(FCs);
  FDoing:=true;
end;

function TCBDataTokenMng.UnLock:boolean;
begin
  LeaveCriticalSection(FCs);
  FDoing:=false;
end;

procedure TCBDataTokenMng.SleepAWhile(aWhile:integer);
begin
  Sleep(aWhile);
end;

function TCBDataTokenMng.IndexOfDat(aDatFileName:string):integer;
var i:integer; 
begin
  result:=-1;
  for i:=0 to High(FCBDataList) do
  begin
    Application.ProcessMessages;
    if SameText(FCBDataList[i].FileName,aDatFileName) then
    begin
      result:=i;
      break;
    end;
  end;
end;

function TCBDataTokenMng.GetDatGuid(aDatFileName:string):string;
var iIdx:Integer;
begin
  Result:='';
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  result:=FCBDataList[iIdx].GUID;
end;

function TCBDataTokenMng.SetDatGuid(aDatFileName,aGuid,aLocker:string):Boolean;
var iIdx:Integer;
begin
  Result:=false;
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  if not SameText(FCBDataList[iIdx].Token,aLocker) then
    exit;
  try
    Lock;
    FCBDataList[iIdx].GUID:=aGuid;
    result:=True;
  finally
    UnLock;
  end;
end;

function TCBDataTokenMng.CheckDatGuid(aDatFileName,aGuid:string):boolean;
var iIdx:Integer;
begin
  Result:=false;
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  if FCBDataList[iIdx].Guid<>aGuid then
    exit;
  result:=true;
end;

function TCBDataTokenMng.CheckDatLock(aDatFileName:string):string;
var iIdx:Integer;
begin
  Result:='';
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  result:=FCBDataList[iIdx].Token;
end;

function TCBDataTokenMng.LockDat(aDatFileName,aLocker:string):boolean;
var iIdx:Integer;
begin
  Result:=false;
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  if (not SameText(FCBDataList[iIdx].Token,'')) and
     (not SameText(FCBDataList[iIdx].Token,aLocker))  then
    Exit;
  try
    Lock;
    FCBDataList[iIdx].TokenTime:=GetTickCount;
    FCBDataList[iIdx].Token:=aLocker;
    result:=true;
  finally
    Unlock;
  end;
end;

function TCBDataTokenMng.UnLockDat(aDatFileName,aLocker:string):boolean;
var iIdx:Integer;
begin
  Result:=false;
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  if (not SameText(FCBDataList[iIdx].Token,'')) and
     (not SameText(FCBDataList[iIdx].Token,aLocker))  then
    Exit;
  try
    Lock;
    FCBDataList[iIdx].Token:='';
    FCBDataList[iIdx].TokenTime:=0;
    result:=true;
  finally
    Unlock;
  end;
end;

function TCBDataTokenMng.LockDatFileList(aDatFileList:_cStrLst2;aLocker:string):boolean;
var i,iIdx:Integer;
begin
  Result:=false;
  try
    Lock;
    for i:=0 to High(aDatFileList) do
    begin
      iIdx:=IndexOfDat(aDatFileList[i]);
      if iIdx=-1 then
        Exit;
      if (not SameText(FCBDataList[iIdx].Token,'')) and
         (not SameText(FCBDataList[iIdx].Token,aLocker))  then
        Exit;
    end;

    for i:=0 to High(aDatFileList) do
    begin
      iIdx:=IndexOfDat(aDatFileList[i]);
      if iIdx=-1 then
        Exit;
      FCBDataList[iIdx].TokenTime:=GetTickCount;
      FCBDataList[iIdx].Token:=aLocker;
    end;
    result:=true;
  finally
    Unlock;
  end;
end;


function TCBDataTokenMng.UnLockDatFileList(aDatFileList:_cStrLst2;aLocker:string):boolean;
var i,iIdx:Integer;
begin
  Result:=false;
  try
    Lock;
    for i:=0 to High(aDatFileList) do
    begin
      iIdx:=IndexOfDat(aDatFileList[i]);
      if iIdx=-1 then
        Exit;
      if (not SameText(FCBDataList[iIdx].Token,'')) and
         (not SameText(FCBDataList[iIdx].Token,aLocker))  then
        Exit;
    end;

    for i:=0 to High(aDatFileList) do
    begin
      iIdx:=IndexOfDat(aDatFileList[i]);
      if iIdx=-1 then
        Exit;
      FCBDataList[iIdx].Token:='';
      FCBDataList[iIdx].TokenTime:=0;
    end;
    result:=true;
  finally
    Unlock;
  end;
end;


{ TCBDataTokenMngEcb }

constructor TCBDataTokenMngEcb.Create(aTimeOut:integer;aRandGUID:boolean;aTw:Boolean);
begin
  FDoing:=false;
  FTimeOut:=aTimeOut;
  FTw:=aTw;
  Init;
  if aRandGUID then
    RandGUIDList;
  InitializeCriticalSection(FCs);
  FMonitor:=TTimer.Create(nil);
  FMonitor.Tag:=0;
  FMonitor.OnTimer:=MonitorTimer;
  FMonitor.Interval:=15000;
  FMonitor.Enabled:=true;
end;

destructor TCBDataTokenMngEcb.Destroy;
begin
  FMonitor.Tag:=1;
  FMonitor.Enabled:=false;
  FreeAndNil(FMonitor);
  DeleteCriticalSection(FCs);
  SetLength(FCBDataList,0);
  //inherited;
end;

procedure TCBDataTokenMngEcb.Init;
var i:integer;
begin
  SetLength(FCBDataList,100);
  for i:=0 to High(FCBDataList) do
  begin
    FCBDataList[i].FileName:='';
    FCBDataList[i].GUID:='';
    FCBDataList[i].Token:='';
    FCBDataList[i].TokenTime:=0;
  end;
  i:=-1;
  if FTw then
  begin
    Inc(i);FCBDataList[i].FileName := 'cbidx2.dat';//轉股余額
    Inc(i);FCBDataList[i].FileName := 'strike4.dat';//轉股價格調整
    Inc(i);FCBDataList[i].FileName := 'cbdoc.dat';//條款原文描述
    Inc(i);FCBDataList[i].FileName := 'strike32.dat';//交易日上浮幅度
    Inc(i);FCBDataList[i].FileName := 'cbissue2.dat';//網上網下 承銷商等資料
    Inc(i);FCBDataList[i].FileName := 'cbdate.dat';//重要日期
    Inc(i);FCBDataList[i].FileName := 'cbstopconv.dat';//停止轉換期間
    Inc(i);FCBDataList[i].FileName := 'cbredeemdate.dat';//贖回條款
    Inc(i);FCBDataList[i].FileName := 'cbsaledate.dat';//賣回條款
    
    Inc(i);FCBDataList[i].FileName := 'cbpurpose.dat';//募集資金用途
  end
  else begin
    Inc(i);FCBDataList[i].FileName := 'cbidx2.dat';//轉股余額
    Inc(i);FCBDataList[i].FileName := 'strike4.dat';//轉股價格調整
    Inc(i);FCBDataList[i].FileName := 'cbdoc.dat';//條款原文描述
    Inc(i);FCBDataList[i].FileName := 'strike32.dat';//交易日上浮幅度
    Inc(i);FCBDataList[i].FileName := 'cbissue2.dat';//網上網下 承銷商等資料
    Inc(i);FCBDataList[i].FileName := 'cbpurpose.dat';//募集資金用途
    Inc(i);FCBDataList[i].FileName := 'cbdate.dat';//重要日期
    Inc(i);FCBDataList[i].FileName := 'cbbaseinfo.dat';//基本面資料
    Inc(i);FCBDataList[i].FileName := 'cbstockholder.dat';//十大股東
    Inc(i);FCBDataList[i].FileName := 'stopissuedocidx.dat';//停發公告設定
    Inc(i);FCBDataList[i].FileName := 'cbstopconv.dat';//停止轉換期間
    Inc(i);FCBDataList[i].FileName := 'cbredeemdate.dat';//贖回條款
    Inc(i);FCBDataList[i].FileName := 'cbsaledate.dat';//賣回條款
    Inc(i);FCBDataList[i].FileName := 'bond.dat';//企業債
  end;
  SetLength(FCBDataList,i+1);
end;

procedure TCBDataTokenMngEcb.RandGUIDList;
var i:integer;
begin
  for i:=0 to High(FCBDataList) do
  begin
    FCBDataList[i].GUID:=Get_GUID8;
  end;
  //FCBDataList[0].GUID:='25D1AAEB';
end;

procedure TCBDataTokenMngEcb.MonitorTimer(Sender: TObject);
var i:integer; iTick:DWORD;
begin
try
  FMonitor.Enabled:=false;
  if FDoing then exit;
  for i:=0 to High(FCBDataList) do
  begin
    Application.ProcessMessages;
    if FCBDataList[i].Token<>'' then
    begin
      iTick:=GetTickCount;
      if (iTick-FCBDataList[i].TokenTime>FTimeOut*1000) then
      begin
        if FDoing then exit;
        try
          Lock;
          FCBDataList[i].Token:='';
          FCBDataList[i].TokenTime:=0;
        finally
          UnLock;
        end;
      end;
    end;
  end;
finally
  if FMonitor.Tag=0 then
   FMonitor.Enabled:=True;
end;
end;

function TCBDataTokenMngEcb.Lock:boolean;
begin
  EnterCriticalSection(FCs);
  FDoing:=true;
end;

function TCBDataTokenMngEcb.UnLock:boolean;
begin
  LeaveCriticalSection(FCs);
  FDoing:=false;
end;

procedure TCBDataTokenMngEcb.SleepAWhile(aWhile:integer);
begin
  Sleep(aWhile);
end;

function TCBDataTokenMngEcb.IndexOfDat(aDatFileName:string):integer;
var i:integer; 
begin
  result:=-1;
  for i:=0 to High(FCBDataList) do
  begin
    Application.ProcessMessages;
    if SameText(FCBDataList[i].FileName,aDatFileName) then
    begin
      result:=i;
      break;
    end;
  end;
end;

function TCBDataTokenMngEcb.GetDatGuid(aDatFileName:string):string;
var iIdx:Integer;
begin
  Result:='';
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  result:=FCBDataList[iIdx].GUID;
end;

function TCBDataTokenMngEcb.SetDatGuid(aDatFileName,aGuid,aLocker:string):Boolean;
var iIdx:Integer;
begin
  Result:=false;
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  if not SameText(FCBDataList[iIdx].Token,aLocker) then
    exit;
  try
    Lock;
    FCBDataList[iIdx].GUID:=aGuid;
    result:=True;
  finally
    UnLock;
  end;
end;

function TCBDataTokenMngEcb.CheckDatGuid(aDatFileName,aGuid:string):boolean;
var iIdx:Integer;
begin
  Result:=false;
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  if FCBDataList[iIdx].Guid<>aGuid then
    exit;
  result:=true;
end;

function TCBDataTokenMngEcb.CheckDatLock(aDatFileName:string):string;
var iIdx:Integer;
begin
  Result:='';
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  result:=FCBDataList[iIdx].Token;
end;

function TCBDataTokenMngEcb.LockDat(aDatFileName,aLocker:string):boolean;
var iIdx:Integer;
begin
  Result:=false;
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  if (not SameText(FCBDataList[iIdx].Token,'')) and
     (not SameText(FCBDataList[iIdx].Token,aLocker))  then
    Exit;
  try
    Lock;
    FCBDataList[iIdx].TokenTime:=GetTickCount;
    FCBDataList[iIdx].Token:=aLocker;
    result:=true;
  finally
    Unlock;
  end;
end;

function TCBDataTokenMngEcb.UnLockDat(aDatFileName,aLocker:string):boolean;
var iIdx:Integer;
begin
  Result:=false;
  iIdx:=IndexOfDat(aDatFileName);
  if iIdx=-1 then
    Exit;
  if (not SameText(FCBDataList[iIdx].Token,'')) and
     (not SameText(FCBDataList[iIdx].Token,aLocker))  then
    Exit;
  try
    Lock;
    FCBDataList[iIdx].Token:='';
    FCBDataList[iIdx].TokenTime:=0;
    result:=true;
  finally
    Unlock;
  end;
end;

function TCBDataTokenMngEcb.LockDatFileList(aDatFileList:_cStrLst2;aLocker:string):boolean;
var i,iIdx:Integer;
begin
  Result:=false;
  try
    Lock;
    for i:=0 to High(aDatFileList) do
    begin
      iIdx:=IndexOfDat(aDatFileList[i]);
      if iIdx=-1 then
        Exit;
      if (not SameText(FCBDataList[iIdx].Token,'')) and
         (not SameText(FCBDataList[iIdx].Token,aLocker))  then
        Exit;
    end;

    for i:=0 to High(aDatFileList) do
    begin
      iIdx:=IndexOfDat(aDatFileList[i]);
      if iIdx=-1 then
        Exit;
      FCBDataList[iIdx].TokenTime:=GetTickCount;
      FCBDataList[iIdx].Token:=aLocker;
    end;
    result:=true;
  finally
    Unlock;
  end;
end;


function TCBDataTokenMngEcb.UnLockDatFileList(aDatFileList:_cStrLst2;aLocker:string):boolean;
var i,iIdx:Integer;
begin
  Result:=false;
  try
    Lock;
    for i:=0 to High(aDatFileList) do
    begin
      iIdx:=IndexOfDat(aDatFileList[i]);
      if iIdx=-1 then
        Exit;
      if (not SameText(FCBDataList[iIdx].Token,'')) and
         (not SameText(FCBDataList[iIdx].Token,aLocker))  then
        Exit;
    end;

    for i:=0 to High(aDatFileList) do
    begin
      iIdx:=IndexOfDat(aDatFileList[i]);
      if iIdx=-1 then
        Exit;
      FCBDataList[iIdx].Token:='';
      FCBDataList[iIdx].TokenTime:=0;
    end;
    result:=true;
  finally
    Unlock;
  end;
end;

end.
