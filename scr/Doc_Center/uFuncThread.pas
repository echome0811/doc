unit uFuncThread;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,ExtCtrls,Forms,Controls,
  DateUtils,TDocMgr,uFuncFileCodeDecode,
    TCommon,IniFiles,CSDef,uThreeTraderPro,uLevelDataFun;

type
  TClsBakDataThread=class(TThread)
  private
  protected
    procedure Execute; override;
  public
     constructor Create();
     destructor  Destroy; override;
  end;


  TCBDataWorkHandleThread=class(TThread)
  private
    procedure ProExecute;
  protected
    procedure Execute; override;
  public
    FCBDataAll_PackFile,FCBDataExceptCbdocAll_PackFile:string;
    FCBDataAll_PackTag,FCBDataExceptCbdocAll_PackTag:Boolean;
    FCBDataAry_PackTag:array of Boolean;
    FCBNodeDat_PackTag:Boolean; FLockTimeOut:integer; FCBNodeDat_Token:string; FCBNodeDat_TokenTime:integer;

    FCBNodeDat_PackFile:string;
    FCBDataAry_PackFile:array of string;

    FGUIDOfCBData,FGUIDOfNodeData,FGUIDOfIFRSData:string;
    FLastGUIDOfCBData,FLastGUIDOfNodeData,FLastGUIDOfIFRSData:string;
    
     procedure UptGUIDOfCBData;
     procedure UptGUIDOfNodeData;
     procedure UptGUIDOfIFRSData;
     procedure PackCBDataFile(aFileName:string);
     procedure PackCBNodeFile();

     function LockNodeDat(aLocker:string):boolean;
     function UnLockNodeDat(aLocker:string):boolean;

     constructor Create(aLockTimeOut:integer);
     destructor  Destroy; override;
  end;

  TCBDataWorkHandleThreadEcb=class(TThread)
  private
    procedure ProExecute;
  protected
    procedure Execute; override;
  public
    FCBDataAll_PackFile,FCBDataExceptCbdocAll_PackFile:string;
    FCBDataAll_PackTag,FCBDataExceptCbdocAll_PackTag:Boolean;
    FCBDataAry_PackTag:array of Boolean;
    FCBNodeDat_PackTag:Boolean; FLockTimeOut:integer; FCBNodeDat_Token:string; FCBNodeDat_TokenTime:integer;

    FCBNodeDat_PackFile:string;
    FCBDataAry_PackFile:array of string;

    FGUIDOfCBData,FGUIDOfNodeData:string;
    FLastGUIDOfCBData,FLastGUIDOfNodeData:string;
    
     procedure UptGUIDOfCBData;
     procedure UptGUIDOfNodeData;
     procedure PackCBDataFile(aFileName:string);
     procedure PackCBNodeFile();

     function LockNodeDat(aLocker:string):boolean;
     function UnLockNodeDat(aLocker:string):boolean;

     constructor Create(aLockTimeOut:integer);
     destructor  Destroy; override;
  end;
  
function DelDatF(aDatF:ShortString):boolean;
function CpyDatF(aDatFS,aDatFD:ShortString):boolean;
function GetAnIFRSUploadOpFile(): String;
function GetAnUploadOpFile(NodeOp:boolean): String;
function GetCbpaOpDataPath:string;

function GetAnUploadOpFileEcb(NodeOp:boolean): String;
function GetCbpaOpDataPathEcb:string;

implementation

uses MainFrm;

 
function GetCbpaOpDataPath:string;
begin
  result:=ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\CbpaOpData\';
end;

function GetCbpaOpDataPathEcb:string;
begin
  result:=ExtractFilePath(Application.ExeName)+'DataEcb\DwnDocLog\CbpaOpData\';
end;

function GetAnUploadOpFileEcb(NodeOp:boolean): String;
var sPath,FileName,FileName2,FileExt : String; Index : Integer;
begin
   result:='';
   sPath:=GetCbpaOpDataPathEcb;
   if not DirectoryExists(sPath) then
     Mkdir_Directory(sPath);

   FileName := 'cbpa';
   if NodeOp then 
     FileExt  := '.nodeop'
   else
     FileExt  := '.cbop';
   FileName2 := sPath+FileName+'_'+Get_GUID8+FileExt;
   Result := FileName2;
end;

function GetAnUploadOpFile(NodeOp:boolean): String;
var sPath,FileName,FileName2,FileExt : String; Index : Integer;
begin
   result:='';
   sPath:=GetCbpaOpDataPath;
   if not DirectoryExists(sPath) then
     Mkdir_Directory(sPath);

   FileName := 'cbpa';
   if NodeOp then 
     FileExt  := '.nodeop'
   else
     FileExt  := '.cbop';
   FileName2 := sPath+FileName+'_'+Get_GUID8+FileExt;
   Result := FileName2;
end;

function GetAnIFRSUploadOpFile(): String;
var sPath,FileName,FileName2,FileExt : String; Index : Integer;
begin
   result:='';
   sPath:=GetCbpaOpDataPath;
   if not DirectoryExists(sPath) then
     Mkdir_Directory(sPath);

   FileName := 'cbpa';
   FileExt  := '.ifrsop';
   FileName2 := sPath+FileName+'_'+Get_GUID8+FileExt;
   Result := FileName2;
end;

function CpyDatF(aDatFS,aDatFD:ShortString):boolean;
var i:integer;
begin
  result := false;
  if not FileExists(aDatFS) then
  begin
    //result := true;
    exit;
  end;
  for i:=1 to 5 do
  begin
    if CopyFile(PChar(String(aDatFS)),PChar(String(aDatFD)),false ) then
    if FileExists(aDatFD) then
    begin
      result := true;
      exit;
    end;
    Sleep(500);
  end;
end;


function DelDatF(aDatF:ShortString):boolean;
var i:integer;
begin
  result := false;
  for i:=1 to 5 do
  begin
    if FileExists(aDatF) then
    begin
      if DeleteFile(aDatF) then
      begin
        result := true;
        exit;
      end;
    end
    else begin
      result := true;
      exit;
    end;

    Sleep(50);
  end;
end;

{ TClsBakDataThread }

constructor TClsBakDataThread.Create;
begin
  FreeOnTerminate:=True;
  inherited Create(true);
end;

destructor TClsBakDataThread.Destroy;
begin
  inherited Destroy;
end;

procedure TClsBakDataThread.Execute;
var sTr1dbCBDataPath,sPathBak:string;
  Procedure ClsFiles();
  var DirInfo: TSearchRec;
    r : Integer;
  begin
    r := FindFirst(sPathBak+'*.*', FaAnyfile, DirInfo);
    while r = 0 do
    begin
      if AMainFrm.FStopRunning then
        break;
      if ((DirInfo.Attr and FaDirectory <> FaDirectory) and
        (DirInfo.Attr and FaVolumeId <> FaVolumeID)) then
      Begin
        if DaySpan(now,GetFileDateTimeC(sPathBak+DirInfo.Name))>AMainFrm.FBakDataSaveDays then
        begin
          DeleteFile(sPathBak+DirInfo.Name);
        end;
      End;
      r := FindNext(DirInfo);
      Sleep(1);
    end;
    SysUtils.FindClose(DirInfo);
  end;
begin
  //inherited;
  if AMainFrm.FBakDataSaveDays<=0 then
    exit;
  with AMainFrm do
   sTr1dbCBDataPath:=FAppParam.Tr1DBPath+'cbdata\';
  sPathBak:=sTr1dbCBDataPath+'data\bak\';
  ClsFiles();
  sPathBak:=sTr1dbCBDataPath+'balancedat\bak\';
  ClsFiles();
  sPathBak:=sTr1dbCBDataPath+'tcri\bak\';
  ClsFiles();

  with AMainFrm do
   sTr1dbCBDataPath:=FAppParamEcb.Tr1DBPath+'cbdata\';
  sPathBak:=sTr1dbCBDataPath+'data\bak\';
  ClsFiles();
end;



{ TCBDataWorkHandleThread }

function TCBDataWorkHandleThread.LockNodeDat(aLocker:string):boolean;
begin
  Result:=false;
  if (not SameText(FCBNodeDat_Token,'')) and
     (not SameText(FCBNodeDat_Token,aLocker))  then
    exit;
  try
    FCBNodeDat_TokenTime:=GetTickCount;
    FCBNodeDat_Token:=aLocker;
    result:=true;
  finally
  end;
end;

function TCBDataWorkHandleThread.UnLockNodeDat(aLocker:string):boolean;
begin
  Result:=false;
  if (not SameText(FCBNodeDat_Token,'')) and
     (not SameText(FCBNodeDat_Token,aLocker))  then
    exit;
  try
    FCBNodeDat_Token:='';
    FCBNodeDat_TokenTime:=0;
    result:=true;
  finally
  end;
end;


procedure TCBDataWorkHandleThread.PackCBNodeFile();
var sNodeDatPath,sZearoFile,sTempUplFile:string; tsNeedTransfer:TStringList;
begin
  AMainFrm.ShowMsg2Tw('start PackCBNodeFile ');
  sNodeDatPath:=FAppParam.Tr1DBPath+'CBData\nodetextforcbpa\';
  try
    tsNeedTransfer:=TStringList.create;
    FolderAllFiles(sNodeDatPath,'.dat',tsNeedTransfer,false);
    try
      FCBNodeDat_PackTag:=true;
      sTempUplFile:=ComparessFileListToFile(tsNeedTransfer,FCBNodeDat_PackFile,'',sZearoFile);
    finally
      FCBNodeDat_PackTag:=False;
    end;
    if (sTempUplFile='') or (not FileExists(sTempUplFile)) then
    begin
      AMainFrm.ShowMsg2Tw('PackCBNodeFile fail.');
    end;
  finally
    try if Assigned(tsNeedTransfer) then FreeAndNil(tsNeedTransfer); except end;
  end;
  AMainFrm.ShowMsg2Tw('end PackCBNodeFile ');
end;

procedure TCBDataWorkHandleThread.PackCBDataFile(aFileName:string);
var sTempName,sTempFile,sZearoFile,sTempUplFile:string;
  i:integer; ts1,ts2,ts3:TStringList; bFind:Boolean;
begin

  with AMainFrm do
  begin
    ShowMsg2Tw('start PackCBDataFile '+aFileName);
    if aFileName<>'' then
    begin
      bFind:=false;
      for i:=0 to High(FCBDataTokenMng.FCBDataList) do
      begin
        sTempName:=FCBDataTokenMng.FCBDataList[i].FileName;
        if PosEx(sTempName,aFileName)>0 then
        begin
          bFind:=true;
          break;
        end;
      end;
      if not bFind then
        Exit;
    end;

    
    try
      ts1:=TStringList.create;
      ts2:=TStringList.create;
      ts3:=TStringList.create;
      
      for i:=0 to High(FCBDataTokenMng.FCBDataList) do
      begin
        sTempName:=FCBDataTokenMng.FCBDataList[i].FileName;
        sTempFile:=CBDataMgr.GetCBDataFile_FullPath(sTempName);
        if FileExists(sTempFile) then
        begin
          if (aFileName='') or
             (
                (aFileName<>'') and
                (PosEx(sTempName,aFileName)>0)
             ) then
          begin
            //if ts3.count=0 then
            begin
              ts3.Clear;
              ts3.Add(sTempFile);
              try
                FCBDataAry_PackTag[i]:=true;
                sTempUplFile:=ComparessFileListToFile(ts3,FCBDataAry_PackFile[i],'',sZearoFile);
              finally
                FCBDataAry_PackTag[i]:=False;
              end;
              if (sTempUplFile='') or (not FileExists(sTempUplFile)) then
              begin
                ShowMsg2Tw('pack fail.'+sTempName);
              end;
            end;
          end;

          ts1.Add(sTempFile);
          if not SameText(sTempName,'cbdoc.dat') then
            ts2.Add(sTempFile);
        end;
      end;
      try
        FCBDataAll_PackTag:=true;
        sTempUplFile:=ComparessFileListToFile(ts1,FCBDataAll_PackFile,'',sZearoFile);
      finally
        FCBDataAll_PackTag:=False;
      end;
      if (sTempUplFile='') or (not FileExists(sTempUplFile)) then
      begin
        ShowMsg2Tw('pack1 fail.');
      end;

      try
        FCBDataExceptCbdocAll_PackTag:=true;
        sTempUplFile:=ComparessFileListToFile(ts2,FCBDataExceptCbdocAll_PackFile,'',sZearoFile);
      finally
        FCBDataExceptCbdocAll_PackTag:=False;
      end;
      if (sTempUplFile='') or (not FileExists(sTempUplFile)) then
      begin
        ShowMsg2Tw('pack2 fail.');
      end;

    finally
      try if Assigned(ts1) then FreeAndNil(ts1); except end;
      try if Assigned(ts2) then FreeAndNil(ts2); except end;
      try if Assigned(ts3) then FreeAndNil(ts3); except end;
    end;
    ShowMsg2Tw('end PackCBDataFile '+aFileName);
  end;
end;


constructor TCBDataWorkHandleThread.Create(aLockTimeOut:integer);
var sTempPath,sTempName,sLoc:string;
  i:integer; 
begin
  FLockTimeOut:=aLockTimeOut;
  FCBNodeDat_Token:='';
  FCBNodeDat_TokenTime:=0;

  FGUIDOfCBData:='';
  FGUIDOfNodeData:='';
  FGUIDOfIFRSData:='';
  FLastGUIDOfCBData:='';
  FLastGUIDOfNodeData:='';
  FLastGUIDOfIFRSData:='';

  with AMainFrm do
  begin
    if FCBDataTokenMng.Tw then sLoc:='tw'
    else sLoc:='cn';

    sTempPath:=GetWinTempPath+'doccenter'+sLoc+'\';
    if not DirectoryExists(sTempPath) then
      ForceDirectories(sTempPath);
    FCBDataAll_PackFile:=sTempPath+'CBDataAllPack'+'.upl';
    FCBDataExceptCbdocAll_PackFile:=sTempPath+'CBDataExceptCbdocAllPack'+'.upl';
    SetLength(FCBDataAry_PackFile,Length(FCBDataTokenMng.FCBDataList));
    for i:=0 to High(FCBDataTokenMng.FCBDataList) do
    begin
      sTempName:=FCBDataTokenMng.FCBDataList[i].FileName;
      sTempName:=ChangeFileExt(sTempName,'.upl');
      FCBDataAry_PackFile[i]:=sTempPath+sTempName;
    end;
    FCBNodeDat_PackFile:=sTempPath+'CBNodeDatPack'+'.upl';
    
    FCBDataAll_PackTag:=False;
    FCBDataExceptCbdocAll_PackTag:=False;
    SetLength(FCBDataAry_PackTag,Length(FCBDataTokenMng.FCBDataList));
    for i:=0 to High(FCBDataTokenMng.FCBDataList) do
    begin
      FCBDataAry_PackTag[i]:=false;
    end;
    FCBNodeDat_PackTag:=false;
  end;
  FreeOnTerminate:=True;
  inherited Create(true);
end;

destructor TCBDataWorkHandleThread.Destroy;
begin
  inherited Destroy;
end;

procedure TCBDataWorkHandleThread.UptGUIDOfCBData;
begin
  FGUIDOfCBData:=Get_GUID8;
end;

procedure TCBDataWorkHandleThread.UptGUIDOfNodeData;
begin
  FGUIDOfNodeData:=Get_GUID8;
end;

procedure TCBDataWorkHandleThread.UptGUIDOfIFRSData;
begin
  FGUIDOfIFRSData:=Get_GUID8;
end;

procedure TCBDataWorkHandleThread.Execute;
begin
  //inherited;
  ProExecute;
end;

function GetFieldsOfIfrsop(aIfrsopFile:string;tsTemp:TStringList;var tsDat:TStringList):Boolean;
   function GetFV(aInputF:string):string;
   var xi:integer; xstr,xstr2:String;
   begin
     result:='';
     xstr:=aInputF+'=';
     for xi:=0 to tsTemp.count-1 do
     begin
       xstr2:=tsTemp[xi];
       if Pos(xstr,xstr2)=1 then
       begin
         result:=Copy(xstr2,Length(xstr)+1,Length(xstr2));
       end;  
     end;
   end;
var sLine:string;
begin
  result:=False;
  tsTemp.clear;
  if FileExists(aIfrsopFile) then
  begin
    tsTemp.LoadFromFile(aIfrsopFile);
    sLine:='222'+
           '<1>'+GetFV('year')+'</1>'+
           '<2>'+GetFV('q')+'</2>'+
           '<3>'+GetFV('code')+'</3>'+
           '<4>'+ExtractFileName(aIfrsopFile)+'</4>';
    tsDat.add(sLine);
  end;
  result:=true;
end;

procedure TCBDataWorkHandleThread.ProExecute;

  procedure SleepWhile;
  var x1,x1Sleep,x1Per,x1Count:Integer;
  begin
    x1Sleep:=5000;
    x1Per:=50;
    x1Count:=Trunc(x1Sleep/x1Per);
    for x1:=1  to x1Count do
    begin
      if Self.Terminated then Exit;
      Sleep(x1Per);
      if Self.Terminated then Exit;
    end;
  end;
  procedure AddMsg(aMsg:string);
  begin
    with AMainFrm do
    begin
      ShowMsg2Tw(aMsg);
    end;
  end;

var i,i1,i2,i3,iCount,iErrOfProCBData,iErrOfProNodeData,iErrOfProIFRSData:Integer; sTempGuidOfProIFRSData:string;
    sMsg,sTemp,sOperator,sTimeKey,sUptfile,sCid,sOldCid,sNodeOp,sOnePath,
    sCode,sYear,sQ,sIDName,sOp,sMName,sMNameEn,sLogFile,sStatus:string;
    aLogRec:TTrancsationRec; iTick:DWORD;

    tsCBDataWork,tsNodeWork,tsIFRSWork,tsTemp,tsIFRSCache:TStringList;  tsAry:array[0..9] of TStringList;
    StrLst:_cStrLst; bOk:Boolean; sDstFile,sSrFile:array[0..2] of string;

    function GetDataWorkList:Boolean;
    var x1,x2:integer; xstr1,xstr2,xstr3:string;
    begin
      result:=false;
      tsCBDataWork.Clear;
      tsNodeWork.Clear;
      xstr1:=GetCbpaOpDataPath;
      if DirectoryExists(xstr1) then
      begin
        FolderAllFiles(xstr1,'.cbop',tsCBDataWork,False);
        FolderAllFiles(xstr1,'.nodeop',tsNodeWork,False);
        FolderAllFiles(xstr1,'.ifrsop',tsIFRSWork,False);
      end;
      result:=true;
    end;
    function GetParamsOfOp(aInputFile:string;var aOperator,aTimeKey,aUptfile:string):boolean;
    var xfini:TIniFile;
    begin
      result:=false;
      if not FileExists(aInputFile) then
        exit;
      xfini:=TIniFile.Create(aInputFile);
      try
        aOperator:=xfini.ReadString('data','operator','');
        aTimeKey:=xfini.ReadString('data','timekey','');
        aUptfile:=xfini.ReadString('data','uptfile','');
        if (aOperator<>'') and (aTimeKey<>'') and (aUptfile<>'') then
          result:=true;
      finally
        try if Assigned(xfini) then FreeAndNil(xfini); except end;
      end;
    end;
    function GetParamsOfOpNode(aInputFile:string;var aOperator,aTimeKey,aCid,aOldCid,aNodeOp:string):boolean;
    var xfini:TIniFile;
    begin
      result:=false;
      if not FileExists(aInputFile) then
        exit;
      xfini:=TIniFile.Create(aInputFile);
      try
        aOperator:=xfini.ReadString('data','operator','');
        aTimeKey:=xfini.ReadString('data','timekey','');
        aCid:=xfini.ReadString('data','uptfile','');
        aOldCid:=xfini.ReadString('data','cidold','');
        aNodeOp:=xfini.ReadString('data','nodeop','');
        if (aOperator<>'') and (aTimeKey<>'') and (aCid<>'') and (aNodeOp<>'') then
          result:=true;
      finally
        try if Assigned(xfini) then FreeAndNil(xfini); except end;
      end;
    end;
    function GetIFRSParamsOfOp(aInputFile:string;var aOperator,aTimeKey,aCode,aYear,aQ,aIDName,aOp,aMName,aMNameEn:string):boolean;
    var xfini:TIniFile;
    begin
      result:=false;
      if not FileExists(aInputFile) then
      begin
        Exit;
      end;
      xfini:=TIniFile.Create(aInputFile);
      try
        aOperator:=xfini.ReadString('data','operator','');
        aTimeKey:=xfini.ReadString('data','timekey','');
        aCode:=xfini.ReadString('data','code','');
        aYear:=xfini.ReadString('data','year','');
        aQ:=xfini.ReadString('data','q','');
        aIDName:=xfini.ReadString('data','idname','');
        aOp:=xfini.ReadString('data','op','');
        aMName:=xfini.ReadString('data','mname','');
        aMNameEn:=xfini.ReadString('data','mnameen','');
        if (aOperator<>'') and (aTimeKey<>'') and
           (aYear<>'') and (aQ<>'') and (aOp<>'') then
          result:=true;
      finally
        try if Assigned(xfini) then FreeAndNil(xfini); except end;
      end;
    end;
    function IFRSStatusSet(aInputStr1,aStatusStr:string;aInputSite:integer):string;
    begin
      Result:=aInputStr1;
      Result[aInputSite]:=aStatusStr[1];
    end;
begin
  //inherited;
  try
    tsCBDataWork:=TStringList.create;
    tsNodeWork:=TStringList.create;
    tsIFRSWork:=TStringList.create;
    tsIFRSCache:=TStringList.create;
    tsTemp:=TStringList.create;
    for i:=Low(tsAry) to High(tsAry) do
      tsAry[i]:=TStringList.create;

    while not Self.Terminated do
    begin              
        if FCBNodeDat_Token<>'' then
        begin
          iTick:=GetTickCount;
          if (iTick-FCBNodeDat_TokenTime>FLockTimeOut*1000) then
          begin
            try
              FCBNodeDat_Token:='';
              FCBNodeDat_TokenTime:=0;
            finally
            end;
          end;
        end;

        SleepWhile;
        if (Time>=AMainFrm.FSendMailOfOpLogTime) and
           (AMainFrm.FSendMailOfOpLogFlag<FmtDt8(date)) then
        begin
          if AMainFrm.ColloectUploadLog then
          begin
            SaveIniFile(PChar('doccenter'),PChar('SendMailDate'),PChar(FmtDt8(date)),PChar(ExtractFilePath(ParamStr(0))+'setup.ini'));
            AMainFrm.FSendMailOfOpLogFlag:=FmtDt8(date);
          end;
        end;

        if not (
           ( (FLastGUIDOfCBData<>FGUIDOfCBData) or (FLastGUIDOfCBData='') ) or
           ( (FLastGUIDOfNodeData<>FGUIDOfNodeData) or (FLastGUIDOfNodeData='') ) or
           ( (FLastGUIDOfIFRSData<>FGUIDOfIFRSData) or (FLastGUIDOfIFRSData='') )
           )then
           Continue;
        iErrOfProCBData:=0;
        iErrOfProNodeData:=0;
        iErrOfProIFRSData:=0;
        sTempGuidOfProIFRSData:=FGUIDOfIFRSData;
        GetDataWorkList;
        
        with AMainFrm do
        begin
          if tsCBDataWork.Count>0 then
          begin
            for i:=0 to tsCBDataWork.Count-1 do
            begin
              Sleep(5);
              if GetParamsOfOp(tsCBDataWork[i],sOperator,sTimeKey,sUptfile) then
              begin
                if CBDataMgr.SetCBDataUpload(sOperator,sTimeKey,sUptfile) then
                begin
                  if FileExists(tsCBDataWork[i]) then
                    DeleteFile(tsCBDataWork[i]);
                  Continue;
                end
                else begin
                  iErrOfProCBData:=1;
                  AddMsg('生成cb上傳任務失敗.'+tsCBDataWork[i]);
                end;
              end
              else begin
                iErrOfProCBData:=1;
                AddMsg('獲取操作記錄參數失敗.'+tsCBDataWork[i]);
              end;
            end;
            if iErrOfProCBData=0 then
            begin
              if FGUIDOfCBData='' then
                UptGUIDOfCBData;
              FLastGUIDOfCBData:=FGUIDOfCBData;
            end;
          end
          else begin
              if FGUIDOfCBData='' then
              begin
                UptGUIDOfCBData;
                FLastGUIDOfCBData:=FGUIDOfCBData;
              end;
          end;

          if tsNodeWork.Count>0 then
          begin
            for i:=0 to tsNodeWork.Count-1 do
            begin
              Sleep(5);
              if GetParamsOfOpNode(tsNodeWork[i],sOperator,sTimeKey,sCid,sOldCid,sNodeOp) then
              begin
                bOk:=CBDataMgr.SetNodeUpload(sNodeOp,sOldCid,sCid,sOperator,sTimeKey);
                if bOk then 
                begin
                  if FileExists(tsNodeWork[i]) then
                    DeleteFile(tsNodeWork[i]);
                  Continue;
                end
                else begin
                  iErrOfProNodeData:=1;
                  AddMsg('生成node上傳任務失敗.'+tsNodeWork[i]);
                end;
              end
              else begin
                iErrOfProCBData:=1;
                AddMsg('獲取操作記錄參數失敗.'+tsNodeWork[i]);
              end;
            end;
            if iErrOfProNodeData=0 then
            begin
              if FGUIDOfNodeData='' then
                UptGUIDOfNodeData;
              FLastGUIDOfNodeData:=FGUIDOfNodeData;
            end;
          end
          else begin
            if FGUIDOfNodeData='' then
            begin
              UptGUIDOfNodeData;
              FLastGUIDOfNodeData:=FGUIDOfNodeData;
            end;
          end;

          try

          if tsIFRSWork.Count>0 then
          begin
            for i:=Low(tsAry) to High(tsAry) do
              tsAry[i].clear;
            //--將任務年、季、代碼、ifrsop文件名添加到緩存列表tsIFRSCache，并按照年、季排序
            tsIFRSCache.clear;
            sOnePath:=ExtractFilePath(tsIFRSWork[0]);
            for i:=0 to tsIFRSWork.Count-1 do
            begin
              GetFieldsOfIfrsop(tsIFRSWork[i],tsTemp,tsIFRSCache);
            end;
            tsIFRSCache.Sort;
            //
            i:=0;
            while i<tsIFRSCache.count do
            begin
              sYear:=GetStrOnly2('<1>','</1>',tsIFRSCache[i],false);
              sQ:=GetStrOnly2('<2>','</2>',tsIFRSCache[i],false);
              sCode:=GetStrOnly2('<3>','</3>',tsIFRSCache[i],false);
              if (sYear='') or (sQ='') or (sCode='') then
              begin
                tsIFRSCache.delete(i);
                continue;
              end;
              //--將與當前年、季相同的任務集合起來，執行批量的tr1db數據更新
              sSrFile[0] := Format('%sData\IFRS\%s_%s_%s_1.dat',[ExtractFilePath(ParamStr(0)),sYear,sQ,sCode]);
              sSrFile[0] := LowerCase(sSrFile[0]);
              sSrFile[1] := Format('%sData\IFRS\%s_%s_%s_2.dat',[ExtractFilePath(ParamStr(0)),sYear,sQ,sCode]);
              sSrFile[1] := LowerCase(sSrFile[1]);
              sSrFile[2] := Format('%sData\IFRS\%s_%s_%s_3.dat',[ExtractFilePath(ParamStr(0)),sYear,sQ,sCode]);
              sSrFile[2] := LowerCase(sSrFile[2]);
              tsAry[0].Add(sSrFile[0]);
              tsAry[1].Add(sSrFile[1]);
              tsAry[2].Add(sSrFile[2]);
              
              sDstFile[0] := Format('%sCBData\ifrs\%s_%s_1.dat',[CBDataMgr.GetTr1DBPath,sYear,sQ]);
              sDstFile[0] := LowerCase(sDstFile[0]);
              sDstFile[1] := Format('%sCBData\ifrs\%s_%s_2.dat',[CBDataMgr.GetTr1DBPath,sYear,sQ]);
              sDstFile[1] := LowerCase(sDstFile[1]);
              sDstFile[2] := Format('%sCBData\ifrs\%s_%s_3.dat',[CBDataMgr.GetTr1DBPath,sYear,sQ]);
              sDstFile[2] := LowerCase(sDstFile[2]);

              i2:=i;           
              for i1:=i+1 to tsIFRSCache.count-1 do
              begin
                if (GetStrOnly2('<1>','</1>',tsIFRSCache[i1],false)<>sYear) or
                   (GetStrOnly2('<2>','</2>',tsIFRSCache[i1],false)<>sQ) then
                begin
                  break;
                end;
                sCode:=GetStrOnly2('<3>','</3>',tsIFRSCache[i1],false);
                if (sCode='') then
                begin
                  break;
                end;

                sSrFile[0] := Format('%sData\IFRS\%s_%s_%s_1.dat',[ExtractFilePath(ParamStr(0)),sYear,sQ,sCode]);
                sSrFile[0] := LowerCase(sSrFile[0]);
                sSrFile[1] := Format('%sData\IFRS\%s_%s_%s_2.dat',[ExtractFilePath(ParamStr(0)),sYear,sQ,sCode]);
                sSrFile[1] := LowerCase(sSrFile[1]);
                sSrFile[2] := Format('%sData\IFRS\%s_%s_%s_3.dat',[ExtractFilePath(ParamStr(0)),sYear,sQ,sCode]);
                sSrFile[2] := LowerCase(sSrFile[2]);
                tsAry[0].Add(sSrFile[0]);
                tsAry[1].Add(sSrFile[1]);
                tsAry[2].Add(sSrFile[2]);

                i2:=i1; 
              end;
              bOk:=true;
              bOk:=bOk and UptIFRSRecToTr1dbBatch(tsAry[0],sDstFile[0],tsAry[3]);
              if bOk then
              begin
                for i1:=0 to tsAry[3].Count-1 do
                  tsIFRSCache[i+i1]:=IFRSStatusSet(tsIFRSCache[i+i1],tsAry[3][i1],1);
              end;
              bOk:=bOk and UptIFRSRecToTr1dbBatch(tsAry[1],sDstFile[1],tsAry[4]);
              if bOk then
              begin
                for i1:=0 to tsAry[4].Count-1 do
                  tsIFRSCache[i+i1]:=IFRSStatusSet(tsIFRSCache[i+i1],tsAry[4][i1],2);
              end;
              bOk:=bOk and UptIFRSRecToTr1dbBatch(tsAry[2],sDstFile[2],tsAry[5]);
              if bOk then
              begin
                for i1:=0 to tsAry[5].Count-1 do
                  tsIFRSCache[i+i1]:=IFRSStatusSet(tsIFRSCache[i+i1],tsAry[5][i1],3);
              end;
              //--批量數據更新成功后，逐一審核任務
              if bOk then
              begin
                for i1:=i to i2 do
                begin
                  sUptfile:=GetStrOnly2('<4>','</4>',tsIFRSCache[i1],false);
                  sStatus:=Copy(tsIFRSCache[i1],1,3);
                  if (sUptfile<>'') and (Length(sStatus)=3) then
                  begin
                      sUptfile:=sOnePath+sUptfile;
                      if FileExists(sUptfile) then
                      begin
                        if GetIFRSParamsOfOp(sUptfile,sOperator,sTimeKey,sCode,sYear,sQ,sIDName,sOp,sMName,sMNameEn) then
                        begin
                          AddMsg('處理....'+Format('%s(%s,%sQ%s),%s',[sOperator,sCode,sYear,sQ,sTimeKey]));
                          sLogFile:=ExtractFilePath(ParamStr(0))+IFRSOpLogDir+copy(sTimeKey,1,11)+'.log';
                          if CBDataMgr.SetIFRSTFN(sCode, strtoint(sYear),strtoint(sQ),sOperator,sTimeKey,sStatus,sDstFile[0],sDstFile[1],sDstFile[2]) then
                          begin
                            {if SameText('DownIFRS',sOperator) then
                              SetStatusOfIFRS(sCode,_CShen2)
                            else
                              SetStatusOfIFRS(sCode,_CShen);}
                            with aLogRec do
                            begin
                               ID := Format('%s,%s',[sYear,sQ]);
                               IDName := sIDName;
                               Op := sOp;
                               OpTime := sTimeKey;
                               Operator := sOperator;
                               ModouleName := sMName;
                               ModouleNameEn := sMNameEn;
                               BeSave := False;
                            end;
                            WriteARecToFile(aLogRec,sLogFile);
                            if FileExists(sUptfile) then
                              DeleteFile(sUptfile);
                            AddMsg('處理IFRS審核資料ok.'+Format('%s(%s,%sQ%s),%s',[sOperator,sCode,sYear,sQ,sTimeKey]));
                            Continue;
                          end
                          else begin
                            iErrOfProIFRSData:=1;
                            AddMsg('處理IFRS審核資料失敗.'+sUptfile);
                          end;
                        end
                        else begin
                          iErrOfProIFRSData:=1;
                          AddMsg('IFRS獲取操作記錄參數失敗.'+sUptfile);
                        end;
                      end;
                  end;

                end;
              end;
              //--準備下一批，批量更新數據，并執行審核
              i:=i2+1;
            end;


            
            if iErrOfProIFRSData=0 then
            begin
              if sTempGuidOfProIFRSData=FGUIDOfIFRSData then
              begin
                if FGUIDOfIFRSData='' then
                  UptGUIDOfIFRSData;
                FLastGUIDOfIFRSData:=FGUIDOfIFRSData;
              end;
            end;
          end
          else begin
            if sTempGuidOfProIFRSData=FGUIDOfIFRSData then
            if FGUIDOfIFRSData='' then
            begin
              UptGUIDOfIFRSData;
              FLastGUIDOfIFRSData:=FGUIDOfIFRSData;
            end;
          end;
          except
            on e:Exception do
            begin
              AddMsg('IFRS do exception.'+e.Message);
              e:=nil;
            end;
          end;
          
        end;

    end;//---
  finally
      try if Assigned(tsTemp) then FreeAndNil(tsTemp); except end;
      try if Assigned(tsCBDataWork) then FreeAndNil(tsCBDataWork); except end;
      try if Assigned(tsNodeWork) then FreeAndNil(tsNodeWork); except end;
      try if Assigned(tsIFRSWork) then FreeAndNil(tsIFRSWork); except end;
      try if Assigned(tsIFRSCache) then FreeAndNil(tsIFRSCache); except end;
      for i:=Low(tsAry) to High(tsAry) do
        FreeAndNil(tsAry[i]);
      try setlength(StrLst,0); except end;
  end;
end;


{ TCBDataWorkHandleThreadEcb }

function TCBDataWorkHandleThreadEcb.LockNodeDat(aLocker:string):boolean;
begin
  Result:=false;
  if (not SameText(FCBNodeDat_Token,'')) and
     (not SameText(FCBNodeDat_Token,aLocker))  then
    exit;
  try
    FCBNodeDat_TokenTime:=GetTickCount;
    FCBNodeDat_Token:=aLocker;
    result:=true;
  finally
  end;
end;

function TCBDataWorkHandleThreadEcb.UnLockNodeDat(aLocker:string):boolean;
begin
  Result:=false;
  if (not SameText(FCBNodeDat_Token,'')) and
     (not SameText(FCBNodeDat_Token,aLocker))  then
    exit;
  try
    FCBNodeDat_Token:='';
    FCBNodeDat_TokenTime:=0;
    result:=true;
  finally
  end;
end;


procedure TCBDataWorkHandleThreadEcb.PackCBNodeFile();
var sNodeDatPath,sZearoFile,sTempUplFile:string; tsNeedTransfer:TStringList;
begin
  AMainFrm.ShowMsg2TwEcb('start PackCBNodeFileEcb ');
  sNodeDatPath:=FAppParamEcb.Tr1DBPath+'CBData\nodetextforcbpa\';
  try
    tsNeedTransfer:=TStringList.create;
    FolderAllFiles(sNodeDatPath,'.dat',tsNeedTransfer,false);
    try
      FCBNodeDat_PackTag:=true;
      sTempUplFile:=ComparessFileListToFile(tsNeedTransfer,FCBNodeDat_PackFile,'',sZearoFile);
    finally
      FCBNodeDat_PackTag:=False;
    end;
    if (sTempUplFile='') or (not FileExists(sTempUplFile)) then
    begin
      AMainFrm.ShowMsg2TwEcb('PackCBNodeFileEcb fail.');
    end;
  finally
    try if Assigned(tsNeedTransfer) then FreeAndNil(tsNeedTransfer); except end;
  end;
  AMainFrm.ShowMsg2TwEcb('end PackCBNodeFileEcb ');
end;

procedure TCBDataWorkHandleThreadEcb.PackCBDataFile(aFileName:string);
var sTempName,sTempFile,sZearoFile,sTempUplFile:string;
  i:integer; ts1,ts2,ts3:TStringList; bFind:Boolean;
begin
  with AMainFrm do
  begin
    ShowMsg2TwEcb('start PackCBDataFileEcb '+aFileName);
    if aFileName<>'' then
    begin
      bFind:=false;
      for i:=0 to High(FCBDataTokenMngEcb.FCBDataList) do
      begin
        sTempName:=FCBDataTokenMngEcb.FCBDataList[i].FileName;
        if PosEx(sTempName,aFileName)>0 then
        begin
          bFind:=true;
          break;
        end;
      end;
      if not bFind then
        Exit;
    end;

    
    try
      ts1:=TStringList.create;
      ts2:=TStringList.create;
      ts3:=TStringList.create;
      
      for i:=0 to High(FCBDataTokenMngEcb.FCBDataList) do
      begin
        sTempName:=FCBDataTokenMngEcb.FCBDataList[i].FileName;
        sTempFile:=CBDataMgrEcb.GetCBDataFile_FullPath(sTempName);
        CBDataMgrEcb.CreateCBDataFileIfNotExists(sTempFile);
        if FileExists(sTempFile) then
        begin
          if (aFileName='') or
             (
                (aFileName<>'') and
                (PosEx(sTempName,aFileName)>0)
             ) then
          begin
            //if ts3.count=0 then
            begin
              ts3.Clear;
              ts3.Add(sTempFile);
              try
                FCBDataAry_PackTag[i]:=true;
                sTempUplFile:=ComparessFileListToFile(ts3,FCBDataAry_PackFile[i],'',sZearoFile);
              finally
                FCBDataAry_PackTag[i]:=False;
              end;
              if (sTempUplFile='') or (not FileExists(sTempUplFile)) then
              begin
                ShowMsg2TwEcb('pack fail.'+sTempName);
              end;
            end;
          end;

          ts1.Add(sTempFile);
          if not SameText(sTempName,'cbdoc.dat') then
            ts2.Add(sTempFile);
        end;
      end;
      try
        FCBDataAll_PackTag:=true;
        sTempUplFile:=ComparessFileListToFile(ts1,FCBDataAll_PackFile,'',sZearoFile);
      finally
        FCBDataAll_PackTag:=False;
      end;
      if (sTempUplFile='') or (not FileExists(sTempUplFile)) then
      begin
        ShowMsg2TwEcb('pack1 fail.');
      end;

      try
        FCBDataExceptCbdocAll_PackTag:=true;
        sTempUplFile:=ComparessFileListToFile(ts2,FCBDataExceptCbdocAll_PackFile,'',sZearoFile);
      finally
        FCBDataExceptCbdocAll_PackTag:=False;
      end;
      if (sTempUplFile='') or (not FileExists(sTempUplFile)) then
      begin
        ShowMsg2TwEcb('pack2 fail.');
      end;

    finally
      try if Assigned(ts1) then FreeAndNil(ts1); except end;
      try if Assigned(ts2) then FreeAndNil(ts2); except end;
      try if Assigned(ts3) then FreeAndNil(ts3); except end;
    end;
    ShowMsg2TwEcb('end PackCBDataFileEcb '+aFileName);
  end;
end;


constructor TCBDataWorkHandleThreadEcb.Create(aLockTimeOut:integer);
var sTempPath,sTempName,sLoc:string;
  i:integer; 
begin
  FLockTimeOut:=aLockTimeOut;
  FCBNodeDat_Token:='';
  FCBNodeDat_TokenTime:=0;

  FGUIDOfCBData:='';
  FGUIDOfNodeData:='';
  FLastGUIDOfCBData:='';
  FLastGUIDOfNodeData:='';

  with AMainFrm do
  begin
    sLoc:='ecb';

    sTempPath:=GetWinTempPath+'doccenter'+sLoc+'\';
    if not DirectoryExists(sTempPath) then
      ForceDirectories(sTempPath);
    FCBDataAll_PackFile:=sTempPath+'CBDataAllPack'+'.upl';
    FCBDataExceptCbdocAll_PackFile:=sTempPath+'CBDataExceptCbdocAllPack'+'.upl';
    SetLength(FCBDataAry_PackFile,Length(FCBDataTokenMngEcb.FCBDataList));
    for i:=0 to High(FCBDataTokenMngEcb.FCBDataList) do
    begin
      sTempName:=FCBDataTokenMngEcb.FCBDataList[i].FileName;
      sTempName:=ChangeFileExt(sTempName,'.upl');
      FCBDataAry_PackFile[i]:=sTempPath+sTempName;
    end;
    FCBNodeDat_PackFile:=sTempPath+'CBNodeDatPack'+'.upl';
    
    FCBDataAll_PackTag:=False;
    FCBDataExceptCbdocAll_PackTag:=False;
    SetLength(FCBDataAry_PackTag,Length(FCBDataTokenMngEcb.FCBDataList));
    for i:=0 to High(FCBDataTokenMngEcb.FCBDataList) do
    begin
      FCBDataAry_PackTag[i]:=false;
    end;
    FCBNodeDat_PackTag:=false;
  end;
  FreeOnTerminate:=True;
  inherited Create(true);
end;

destructor TCBDataWorkHandleThreadEcb.Destroy;
begin
  inherited Destroy;
end;

procedure TCBDataWorkHandleThreadEcb.UptGUIDOfCBData;
begin
  FGUIDOfCBData:=Get_GUID8;
end;

procedure TCBDataWorkHandleThreadEcb.UptGUIDOfNodeData;
begin
  FGUIDOfNodeData:=Get_GUID8;
end;

procedure TCBDataWorkHandleThreadEcb.Execute;
begin
  //inherited;
  ProExecute;
end;

procedure TCBDataWorkHandleThreadEcb.ProExecute;

  procedure SleepWhile;
  var x1,x1Sleep,x1Per,x1Count:Integer;
  begin
    x1Sleep:=5000;
    x1Per:=50;
    x1Count:=Trunc(x1Sleep/x1Per);
    for x1:=1  to x1Count do
    begin
      if Self.Terminated then Exit;
      Sleep(x1Per);
      if Self.Terminated then Exit;
    end;
  end;
  procedure AddMsg(aMsg:string);
  begin
    with AMainFrm do
    begin
      ShowMsg2TwEcb(aMsg);
    end;
  end;

var i,iCount,iErrOfProCBData,iErrOfProNodeData:Integer;
    sMsg,sTemp,sOperator,sTimeKey,sUptfile,sCid,sOldCid,sNodeOp,
    sCode,sYear,sQ,sIDName,sOp,sMName,sMNameEn,sLogFile:string;
    aLogRec:TTrancsationRec;

    tsCBDataWork,tsNodeWork,tsTemp:TStringList;
    StrLst:_cStrLst; bOk:Boolean;

    function GetDataWorkList:Boolean;
    var x1,x2:integer; xstr1,xstr2,xstr3:string;
    begin
      result:=false;
      tsCBDataWork.Clear;
      tsNodeWork.Clear;
      xstr1:=GetCbpaOpDataPathEcb;
      if DirectoryExists(xstr1) then
      begin
        FolderAllFiles(xstr1,'.cbop',tsCBDataWork,False);
        FolderAllFiles(xstr1,'.nodeop',tsNodeWork,False);
      end;
      result:=true;
    end;
    function GetParamsOfOp(aInputFile:string;var aOperator,aTimeKey,aUptfile:string):boolean;
    var xfini:TIniFile;
    begin
      result:=false;
      if not FileExists(aInputFile) then
        exit;
      xfini:=TIniFile.Create(aInputFile);
      try
        aOperator:=xfini.ReadString('data','operator','');
        aTimeKey:=xfini.ReadString('data','timekey','');
        aUptfile:=xfini.ReadString('data','uptfile','');
        if (aOperator<>'') and (aTimeKey<>'') and (aUptfile<>'') then
          result:=true;
      finally
        try if Assigned(xfini) then FreeAndNil(xfini); except end;
      end;
    end;
    function GetParamsOfOpNode(aInputFile:string;var aOperator,aTimeKey,aCid,aOldCid,aNodeOp:string):boolean;
    var xfini:TIniFile;
    begin
      result:=false;
      if not FileExists(aInputFile) then
        exit;
      xfini:=TIniFile.Create(aInputFile);
      try
        aOperator:=xfini.ReadString('data','operator','');
        aTimeKey:=xfini.ReadString('data','timekey','');
        aCid:=xfini.ReadString('data','uptfile','');
        aOldCid:=xfini.ReadString('data','cidold','');
        aNodeOp:=xfini.ReadString('data','nodeop','');
        if (aOperator<>'') and (aTimeKey<>'') and (aCid<>'') and (aNodeOp<>'') then
          result:=true;
      finally
        try if Assigned(xfini) then FreeAndNil(xfini); except end;
      end;
    end;
    
begin
  //inherited;
  try
    tsCBDataWork:=TStringList.create;
    tsNodeWork:=TStringList.create;
    tsTemp:=TStringList.create;
    while not Self.Terminated do
    begin
        SleepWhile;
        {if (Time>=AMainFrm.FSendMailOfOpLogTimeEcb) and
           (AMainFrm.FSendMailOfOpLogFlagEcb<FmtDt8(date)) then
        begin
          if AMainFrm.ColloectUploadLogEcb then
          begin
            SaveIniFile(PChar('doccenter'),PChar('SendMailDate'),PChar(FmtDt8(date)),PChar(ExtractFilePath(ParamStr(0))+'ecbsetup.ini'));
            AMainFrm.FSendMailOfOpLogFlagEcb:=FmtDt8(date);
          end;
        end; }

        if not (
          ( (FLastGUIDOfCBData<>FGUIDOfCBData) or
             (FLastGUIDOfCBData='')
           ) or
           ( (FLastGUIDOfNodeData<>FGUIDOfNodeData) or
             (FLastGUIDOfNodeData='')
           ) 
           )then
           Continue;
        iErrOfProCBData:=0;
        iErrOfProNodeData:=0;
        GetDataWorkList;
        
        with AMainFrm do
        begin
          if tsCBDataWork.Count>0 then
          begin
            for i:=0 to tsCBDataWork.Count-1 do
            begin
              Sleep(5);
              if GetParamsOfOp(tsCBDataWork[i],sOperator,sTimeKey,sUptfile) then
              begin
                if CBDataMgrEcb.SetCBDataUpload(sOperator,sTimeKey,sUptfile) then
                begin
                  if FileExists(tsCBDataWork[i]) then
                    DeleteFile(tsCBDataWork[i]);
                  Continue;
                end
                else begin
                  iErrOfProCBData:=1;
                  AddMsg('生成ecb上傳任務失敗.'+tsCBDataWork[i]);
                end;
              end
              else begin
                iErrOfProCBData:=1;
                AddMsg('獲取ecb操作記錄參數失敗.'+tsCBDataWork[i]);
              end;
            end;
            if iErrOfProCBData=0 then
            begin
              if FGUIDOfCBData='' then
                UptGUIDOfCBData;
              FLastGUIDOfCBData:=FGUIDOfCBData;
            end;
          end
          else begin
            if FGUIDOfCBData='' then
            begin
              UptGUIDOfCBData;
              FLastGUIDOfCBData:=FGUIDOfCBData;
            end;
          end;

          if tsNodeWork.Count>0 then
          begin
            for i:=0 to tsNodeWork.Count-1 do
            begin
              Sleep(5);
              if GetParamsOfOpNode(tsNodeWork[i],sOperator,sTimeKey,sCid,sOldCid,sNodeOp) then
              begin
                bOk:=CBDataMgrEcb.SetNodeUpload(sNodeOp,sOldCid,sCid,sOperator,sTimeKey);
                
                if bOk then 
                begin
                  if FileExists(tsNodeWork[i]) then
                    DeleteFile(tsNodeWork[i]);
                  Continue;
                end
                else begin
                  iErrOfProNodeData:=1;
                  AddMsg('生成ecbnode上傳任務失敗.'+tsNodeWork[i]);
                end;
              end
              else begin
                iErrOfProCBData:=1;
                AddMsg('獲取ecb操作記錄參數失敗.'+tsNodeWork[i]);
              end;
            end;
            if iErrOfProNodeData=0 then
            begin
              if FGUIDOfNodeData='' then
                UptGUIDOfNodeData;
              FLastGUIDOfNodeData:=FGUIDOfNodeData;
            end;
          end
          else begin
            if FGUIDOfNodeData='' then
            begin
              UptGUIDOfNodeData;
              FLastGUIDOfNodeData:=FGUIDOfNodeData;
            end;
          end;

        end;

    end;//---
  finally
      try if Assigned(tsTemp) then FreeAndNil(tsTemp); except end;
      try if Assigned(tsCBDataWork) then FreeAndNil(tsCBDataWork); except end;
      try if Assigned(tsNodeWork) then FreeAndNil(tsNodeWork); except end;
      try setlength(StrLst,0); except end;
  end;
end;

end.

