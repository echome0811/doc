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
    FCBNodeDat_PackTag:Boolean;

    FCBNodeDat_PackFile:string;
    FCBDataAry_PackFile:array of string;

    FGUIDOfCBData,FGUIDOfNodeData,FGUIDOfIFRSData:string;
    FLastGUIDOfCBData,FLastGUIDOfNodeData,FLastGUIDOfIFRSData:string;
    
     procedure UptGUIDOfCBData;
     procedure UptGUIDOfNodeData;
     procedure UptGUIDOfIFRSData;
     procedure PackCBDataFile(aFileName:string);
     procedure PackCBNodeFile();

     constructor Create();
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
    FCBNodeDat_PackTag:Boolean;

    FCBNodeDat_PackFile:string;
    FCBDataAry_PackFile:array of string;

    FGUIDOfCBData,FGUIDOfNodeData:string;
    FLastGUIDOfCBData,FLastGUIDOfNodeData:string;
    
     procedure UptGUIDOfCBData;
     procedure UptGUIDOfNodeData;
     procedure PackCBDataFile(aFileName:string);
     procedure PackCBNodeFile();

     constructor Create();
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
    result := true;
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


constructor TCBDataWorkHandleThread.Create();
var sTempPath,sTempName,sLoc:string;
  i:integer; 
begin
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

var i,iCount,iErrOfProCBData,iErrOfProNodeData,iErrOfProIFRSData:Integer;
    sMsg,sTemp,sOperator,sTimeKey,sUptfile,
    sCode,sYear,sQ,sIDName,sOp,sMName,sMNameEn,sLogFile:string;
    aLogRec:TTrancsationRec;

    tsCBDataWork,tsNodeWork,tsIFRSWork,tsTemp:TStringList;
    StrLst:_cStrLst; bOk:Boolean;

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
begin
  //inherited;
  try
    tsCBDataWork:=TStringList.create;
    tsNodeWork:=TStringList.create;
    tsIFRSWork:=TStringList.create;
    tsTemp:=TStringList.create;
    while not Self.Terminated do
    begin
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
          ( (FLastGUIDOfCBData<>FGUIDOfCBData) or
             (FLastGUIDOfCBData='')
           ) or
           ( (FLastGUIDOfNodeData<>FGUIDOfNodeData) or
             (FLastGUIDOfNodeData='')
           ) or
           ( (FLastGUIDOfIFRSData<>FGUIDOfIFRSData) or
             (FLastGUIDOfIFRSData='')
           )
           )then
           Continue;
        iErrOfProCBData:=0;
        iErrOfProNodeData:=0;
        iErrOfProIFRSData:=0;
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
              if GetParamsOfOp(tsNodeWork[i],sOperator,sTimeKey,sUptfile) then
              begin
                bOk:=CBDataMgr.SetNodeUpload(sOperator,sTimeKey);
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

          
          if tsIFRSWork.Count>0 then
          begin
            for i:=0 to tsIFRSWork.Count-1 do
            begin
              Sleep(5);
              if FileExists(tsIFRSWork[i]) then
              begin
                if GetIFRSParamsOfOp(tsIFRSWork[i],sOperator,sTimeKey,sCode,sYear,sQ,sIDName,sOp,sMName,sMNameEn) then
                begin
                  sLogFile:=ExtractFilePath(ParamStr(0))+IFRSOpLogDir+copy(sTimeKey,1,8)+'.log';
                  if CBDataMgr.SetIFRSTFN(sCode, strtoint(sYear),strtoint(sQ),sOperator,sTimeKey) then
                  begin
                    SetStatusOfIFRS(sCode,_CShen);
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
                    if FileExists(tsIFRSWork[i]) then
                      DeleteFile(tsIFRSWork[i]);
                    Continue;
                  end
                  else begin
                    iErrOfProIFRSData:=1;
                    AddMsg('處理IFRS審核資料失敗.'+tsIFRSWork[i]);
                  end;
                end
                else begin
                  iErrOfProIFRSData:=1;
                  AddMsg('IFRS獲取操作記錄參數失敗.'+tsIFRSWork[i]);
                end;
              end;
            end;
            if iErrOfProIFRSData=0 then
            begin
              if FGUIDOfIFRSData='' then
                UptGUIDOfIFRSData;
              FLastGUIDOfIFRSData:=FGUIDOfIFRSData;
            end;
          end
          else begin
            if FGUIDOfIFRSData='' then
            begin
              UptGUIDOfIFRSData;
              FLastGUIDOfIFRSData:=FGUIDOfIFRSData;
            end;
          end;
          
        end;

    end;//---
  finally
      try if Assigned(tsTemp) then FreeAndNil(tsTemp); except end;
      try if Assigned(tsCBDataWork) then FreeAndNil(tsCBDataWork); except end;
      try if Assigned(tsNodeWork) then FreeAndNil(tsNodeWork); except end;
      try if Assigned(tsIFRSWork) then FreeAndNil(tsIFRSWork); except end;
      try setlength(StrLst,0); except end;
  end;
end;


{ TCBDataWorkHandleThreadEcb }

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


constructor TCBDataWorkHandleThreadEcb.Create();
var sTempPath,sTempName,sLoc:string;
  i:integer; 
begin
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
    sMsg,sTemp,sOperator,sTimeKey,sUptfile,
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
              if GetParamsOfOp(tsNodeWork[i],sOperator,sTimeKey,sUptfile) then
              begin
                bOk:=CBDataMgrEcb.SetNodeUpload(sOperator,sTimeKey);
                
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

