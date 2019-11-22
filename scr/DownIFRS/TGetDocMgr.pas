//////////////////////////////////////////////////////////////////////////////////
////Doc_DwnHtml-DOC3.0.0需求3-leon-08/8/18;  (修改Doc_DwnHtml的代码读取机制，使其不再读取下市的证券代码；)
//////////////////////////////////////////////////////////////////////////////////
unit TGetDocMgr;

interface
  Uses Windows,IniFiles,SysUtils,TCommon,Classes,CsDef,Controls;

Type

  TIDLstMgr2 = Class
  private
     FIDList : TStringList;
     FTr1DBPath : ShortString;
     FInitTradeCode,FInitStkCode:Boolean;
     FTxtFileScope:TxtFileScope_MP; //---Doc3.2.0需求1 huangcq080923 add
     Procedure SortID();
     procedure SetAID(const ID:ShortString);
     procedure InitData();
  public
      constructor Create(Const Tr1DBPath:ShortString;InitTradeCode,InitStkCode:Boolean;
                        TxtFileScope:TxtFileScope_MP); //---Doc3.2.0需求1 huangcq080923 modify
      destructor  Destroy; override;
      property IDList : TStringList Read FIDList;
      Procedure Refresh();
  end;

  TDocLstDatMgr=Class
  Private
    FID : String;
    FDocLst   : TStringList;
    FTr1DBPath : String;
  Public
      constructor Create(Const Tr1DBPath:ShortString);
      destructor  Destroy; override;
      function LoadDocTitle(ID:ShortString):Boolean;
      Function ExistDoc(Title:ShortString;ADate:TDate):Boolean;
  End;

  TGetDocMgrParam=Class
  private
      FIniPath : String;
      FTr1DBPath : String;
      FFTPPort : Integer;
      FFTPServer : String;
      FFTPUploadDir : String;
      FFTPUserName : String;
      FFTPPassword : String;
      FFTPPassive  : Boolean;
      FSoundPort: Integer;
      FSoundServer: String;
      FDwnMemo: Integer;//下载网站，0：F10、1：宝来、 2：元大京华

      FDwnDocTitleThreadCount   : Integer;
      FDwnDocTxtThreadCount     : Integer;
      FDwnTodayDocStartTime     : TTime;
      FDwnHistoryDocStartTime   : TTime;
      FDoc_Check_Time  :TTime;
      FStopServiceTime :TTime;
      FStartServiceTime :TTime;
      FAutoDwnGet: Boolean;
      FDwnDocTitleErrCount: Integer;
      FDwnDocTxtErrCount: Integer;
      FStartGetDate: String ;  // by leon 0808
      FDocMonitorPort : Integer; //--DOC4.0.0—N001 huangcq090407 add
      FDocMonitorHostName : String; //--DOC4.0.0—N001 huangcq090407 add

	  //wangjinhua 20110601
      FDocTitleTimeOut:Integer;
      FDocTextTimeOut:Integer;
      FDocSleep:Integer;
      //
  public
     constructor Create(const Path:String);overload;
     destructor Destroy; override;

     Procedure Refresh();
     Procedure SaveToFile();
     Function GetTodayCheckIdx():Boolean;
     procedure SetTodayCheckIdxIsOK();

     property Tr1DBPath : String read FTr1DBPath Write FTr1DBPath;

     property DwnDocTitleThreadCount   : Integer read FDwnDocTitleThreadCount Write FDwnDocTitleThreadCount;
     property DwnDocTxtThreadCount     : Integer read FDwnDocTxtThreadCount Write FDwnDocTxtThreadCount;
     property DwnTodayDocStartTime     : TTime read FDwnTodayDocStartTime Write FDwnTodayDocStartTime;
     property DwnHistoryDocStartTime   : TTime read FDwnHistoryDocStartTime Write FDwnHistoryDocStartTime;
     property Doc_Check_Time   : TTime read FDoc_Check_Time Write FDoc_Check_Time;
     property StopServiceTime  :TTime read FStopServiceTime Write FStopServiceTime;
     property StartServiceTime  :TTime read FStartServiceTime Write FStartServiceTime;
     property DwnMemo   : Integer read FDwnMemo Write FDwnMemo;

     property AutoDwnGet : Boolean read FAutoDwnGet Write FAutoDwnGet;
     property TodayCheckIdxIsOK : Boolean read GetTodayCheckIdx;

     property  SoundPort : Integer read FSoundPort Write FSoundPort;
     property  SoundServer : String read FSoundServer Write FSoundServer;

     property  DwnDocTitleErrCount : Integer read FDwnDocTitleErrCount Write FDwnDocTitleErrCount;
     property  DwnDocTxtErrCount : Integer read FDwnDocTxtErrCount Write FDwnDocTxtErrCount;

     property  StartGetDate : String read FStartGetDate Write FStartGetDate;  // by leon 0808

     property  FTPPort : Integer read FFTPPort;
     property  FTPServer : String read FFTPServer;
     property  FTPUploadDir : String read FFTPUploadDir;
     property  FTPUserName : String read FFTPUserName;
     property  FTPPassword : String read FFTPPassword;
     property  FTPPassive  : Boolean read FFTPPassive;
     //--DOC4.0.0—N001 huangcq090407 add----->
     property  DocMonitorPort : Integer read FDocMonitorPort write FDocMonitorPort;
     property  DocMonitorHostName : String read FDocMonitorHostName write FDocMonitorHostName;
     //<--DOC4.0.0—N001 huangcq090407 add---

	 //wangjinhua 20110601
     property  DocTitleTimeOut : Integer read FDocTitleTimeOut write FDocTitleTimeOut;
     property  DocTextTimeOut : Integer read FDocTextTimeOut write FDocTextTimeOut;
     property  DocSleep : Integer read FDocSleep write FDocSleep;
     //
  end;

  Function ConvertString(Str:ShortString;Const ADwnMemo:String=''):ShortString;
  Function TwConvertStr(Str:ShortString):ShortString;
  //從DocLst.dat清單,建立標題的索引,可用來防止重複
  Procedure CreateIDTitleLstIdx(Tr1DBPath:String);

Var
  FCharset : String='CHINESEBIG5_CHARSET';
  TGetDocMgrCriticalSection: TRTLCriticalSection;

implementation


Procedure CreateIDTitleLstIdx(Tr1DBPath:String);
Var
  ID,DocFile,IdxFileName : String;
  i,index : Integer;
  f,FDocLst  : TStringList;
  DestPath   : String;
  Str:String;
begin

 f:=nil;
 DocFile := Tr1DBPath+'CBData\Document\doclst.dat';
 if Not FileExists(DocFile) Then
     Raise Exception.Create(DocFile+ConvertString(' 档案不存在.'));

 FDocLst := TStringList.Create;
try

  DestPath := Tr1DBPath+'CBData\Document\DocLstIdx\';
  Mkdir_Directory(DestPath);


  if FileExists(DestPath+'doclst_modifytime.log') Then
  Begin
     FDocLst.LoadFromFile(DestPath+'doclst_modifytime.log');
     if FDocLst.Count>0 then
        if StrToInt(FDocLst.Strings[0])=FileAge(DocFile) Then
           Exit;
  end;

  f := TStringList.Create;
  f.LoadFromFile(DocFile);

  FDocLst.Clear;

  ID := '';
  for index:=0 to f.Count-1 do
  Begin
    Str := f.Strings[index];

    if (Pos('COUNT',Str)>0) Then
       Continue;

    if (Pos('[',Str)>0) and
       (Pos(']',Str)>0) and
       (Pos('=',Str)=0) and
       (Pos(',',Str)=0) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if FDocLst.Count>0 Then
           FDocLst.SaveToFile(IdxFileName);
        FDocLst.Clear;
        ID := Str;
        IdxFileName := DestPath+ID+'.idx';
        //如檔案已存在就不需建立
        if FileExists(IdxFileName) Then
           ID := '';
        Continue;
    End;
    if Length(ID)>0 Then
    Begin
        i := Pos(',',Str);
        Str := Copy(Str,i+1,Length(Str)-i);
        FDocLst.Add(Str);
    End;
  End;

  if FDocLst.Count>0 Then
     FDocLst.SaveToFile(IdxFileName);
  FDocLst.Clear;

  FDocLst.Add(IntToStr(FileAge(DocFile)));
  FDocLst.SaveToFile(DestPath+'doclst_modifytime.log');


Finally
  if Assigned(f) Then
     f.Destroy;
  FDocLst.Destroy;
End;

End;

Function ConvertString(Str:ShortString;Const ADwnMemo:String=''):ShortString;
Begin
 EnterCriticalSection(TGetDocMgrCriticalSection);
 try
 try
    Result := Str;
    if Length(ADwnMemo)=0 Then
    Begin
       if FCharset='CHINESEBIG5_CHARSET' Then
          Result := CGBToBig5(Str);
    End Else
    Begin
       //如果指定要轉的語言等於目前的語言,就可以轉
       //Modify by JoySun 2005/10/19   用于显示公告标题
       if (FCharset='CHINESEBIG5_CHARSET') Then
       begin
         if (ADwnMemo='0') then
           Result := CGBToBIG5(Str);
       end;

       if (FCharset='GB2312_CHARSET') Then
       begin
         if (ADwnMemo='1')or(ADwnMemo='2') then
           Result := CBIG5ToGB(Str);
       end;

    End;
 Except
   Result := Str;
 End;
 Finally
   LeaveCriticalSection(TGetDocMgrCriticalSection);
 End;
End;

Function TwConvertStr(Str:ShortString):ShortString;
Begin
 EnterCriticalSection(TGetDocMgrCriticalSection);
 try
 try
    Result := Str;
    if FCharset='GB2312_CHARSET' Then
          Result := Big5ToGB2(Str);
 Except
   Result := Str;
 End;
 Finally
   LeaveCriticalSection(TGetDocMgrCriticalSection);
 End;
End;

{ TGetDocMgrParam }

constructor TGetDocMgrParam.Create(const Path: String);
begin

   FIniPath := Path;
   Refresh;
end;

destructor TGetDocMgrParam.Destroy;
begin

  //inherited;
end;



procedure TGetDocMgrParam.Refresh;
Var
 iniFile : TiniFile;
begin

    iniFile    := TiniFile.Create(FIniPath+'Setup.ini');

    FTr1DBPath :=inifile.ReadString('Config','Tr1DBPath','');

    FCharset   :=inifile.ReadString('Config','Charset',FCharset);

    FDwnDocTitleThreadCount  :=6;
    FDwnDocTxtThreadCount    :=30;
    FDwnMemo                 :=2;

    FDwnDocTitleThreadCount  :=inifile.ReadInteger('Config','DwnDocTitleThreadCount',FDwnDocTitleThreadCount);
    FDwnDocTxtThreadCount    :=inifile.ReadInteger('Config','DwnDocTxtThreadCount',FDwnDocTxtThreadCount);
    FDwnMemo                 :=inifile.ReadInteger('Config','DwnMemo',FDwnMemo);
    FDwnTodayDocStartTime    :=StrToTime(inifile.ReadString('Config','DwnTodayDocStartTime','8:0:0'));
    FDwnHistoryDocStartTime  :=StrToTime(inifile.ReadString('Config','DwnHistoryDocStartTime','18:0:0'));
    FDoc_Check_Time  :=StrToTime(inifile.ReadString('Config','Doc_Check_Time','6:0:0'));
    FStartServiceTime :=StrToTime(inifile.ReadString('Config','StartServiceTime','3:0:0'));
    FStopServiceTime :=StrToTime(inifile.ReadString('Config','StopServiceTime','17:0:0'));

    FAutoDwnGet  := IntToBool(inifile.ReadInteger('Config','AutoDwnGet',0));


    FSoundPort := StrToInt(inifile.ReadString('Config','SoundPort','59'));
    FSoundServer := inifile.ReadString('Config','SoundServer','LocalHost');

    FDocMonitorPort := StrToInt(inifile.ReadString('DocMonitor','Port','56')); //--DOC4.0.0—N001 huangcq090407 add
    FDocMonitorHostName := inifile.ReadString('DocMonitor','HostName','LocalHost');//--DOC4.0.0—N001 huangcq090407 add

    FDwnDocTitleErrCount := inifile.ReadInteger('Config','DwnDocTitleErrCount',10);
    FDwnDocTxtErrCount := inifile.ReadInteger('Config','DwnDocTxtErrCount',20);

    FStartGetDate := inifile.ReadString('Config','StartGetDate','');    // by leon 081016
    
	//wangjinhua  20110601
    FDocTitleTimeOut := inifile.ReadInteger('Config','DwnDocTitleTimeOut',60);
    FDocTextTimeOut := inifile.ReadInteger('Config','DwnDocTextTimeOut',60);
    FDocSleep := inifile.ReadInteger('Config','DwnDocSleep',5);
    //--
    {
    FFTPPort := StrToInt(inifile.ReadString('FTP','Port','21'));
    FFTPServer := inifile.ReadString('FTP','Server','LocalHost');
    FFTPUploadDir := inifile.ReadString('FTP','UploadDir','');
    FFTPUserName  := inifile.ReadString('FTP','UserName','');
    FFTPPassword  := inifile.ReadString('FTP','Password','');
    FFTPPassive   := IntToBool(StrToInt(inifile.ReadString('FTP','Passive','1')));
    }

    FTr1DbPath := IncludeTrailingBackslash(FTr1DBPath);
    iniFile.Destroy;

end;

procedure TGetDocMgrParam.SaveToFile;
Var
 iniFile : TiniFile;
begin

    iniFile    := TiniFile.Create(FIniPath+'Setup.ini');


    inifile.WriteString('Config','Tr1DBPath',FTr1DBPath);

    inifile.WriteInteger('Config','DwnDocTitleThreadCount',FDwnDocTitleThreadCount);
    inifile.WriteInteger('Config','DwnDocTxtThreadCount',FDwnDocTxtThreadCount);
    inifile.WriteString('Config','DwnTodayDocStartTime',FormatDateTime('hh:mm:ss',FDwnTodayDocStartTime));
    inifile.WriteString('Config','DwnHistoryDocStartTime',FormatDateTime('hh:mm:ss',FDwnHistoryDocStartTime));
    inifile.WriteString('Config','Doc_Check_Time',FormatDateTime('hh:mm:ss',FDoc_Check_Time));
    inifile.WriteString('Config','StartServiceTime',FormatDateTime('hh:mm:ss',FStartServiceTime));
    inifile.WriteString('Config','StopServiceTime',FormatDateTime('hh:mm:ss',FStopServiceTime));

    inifile.WriteInteger('Config','AutoDwnGet',BoolToInt(AutoDwnGet));

    inifile.WriteInteger('Config','SoundPort',FSoundPort);
    inifile.WriteString('Config','SoundServer',FSoundServer);

    inifile.WriteInteger('Config','DwnDocTitleErrCount',DwnDocTitleErrCount);
    inifile.WriteInteger('Config','DwnDocTxtErrCount',DwnDocTxtErrCount);

    //add by JoySun 2005/10/19
    inifile.WriteInteger('Config','DwnMemo',DwnMemo);

    inifile.WriteString('Config','StartGetDate',StartGetDate);// by leon 0808

	//wangjinhua  20110601
    inifile.WriteInteger('Config','DwnDocTitleTimeOut',FDocTitleTimeOut);
    inifile.WriteInteger('Config','DwnDocTextTimeOut',FDocTextTimeOut);
    inifile.WriteInteger('Config','DwnDocSleep',FDocSleep);
    //--
	
    FTr1DbPath := IncludeTrailingBackslash(FTr1DBPath);
    iniFile.Destroy;

end;

{ TIDLstMgr }

constructor TIDLstMgr2.Create(const Tr1DBPath: ShortString;InitTradeCode,InitStkCode:Boolean;
                        TxtFileScope:TxtFileScope_MP); //---Doc3.2.0需求1 huangcq080923 modify
begin
  FIDList := TStringList.Create;
  FTr1DBPath := Tr1DBPath;
  FInitTradeCode := InitTradeCode;
  FInitStkCode := InitStkCode;
  FTxtFileScope:=TxtFileScope; //---Doc3.2.0需求1 huangcq080923 add
  InitData();
end;

destructor TIDLstMgr2.Destroy;
begin
  FTr1DBPath := '';
  FIDList.Destroy;
  //inherited;
end;


procedure TIDLstMgr2.InitData();
Var
  i,j : Integer;
  Str : String;
  ID,FilePath : String;
  FileLst : _CstrLst;
  f : TStringList;

begin

    FIDList.Clear;
    {
    FilePath := FTr1DBPath + 'CBData\market_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);

    FilePath := FTr1DBPath + 'CBData\publish_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);
    } //---Doc3.2.0需求1 huangcq080923 del
    FilePath := FTr1DBPath + 'CBData\';  //---Doc3.2.0需求1 huangcq080923 add
    GetTxtFilesFromDblst(FilePath,FileLst,FTxtFileScope); //---Doc3.2.0需求1 huangcq080923 add

    f := TStringList.Create;

Try
Try
    ID := '';
    For i:=0 to High(fileLst) do
    Begin
      if FileExists(fileLst[i]) Then
      Begin
        //modify by wjh 2011-10-14
        if Pos(UpperCase('stopissue'),UpperCase(fileLst[i]))=0 then //---Doc3.2.0需求1 huangcq080923 del  (已经通过FTxtFileScope过滤了txt)
        begin
             f.LoadFromFile(FileLst[i]);
             for j:=0 to f.Count-1 do
             Begin
                 Str := UpperCase(f.Strings[j]);
                 if FInitTradeCode Then
                 if Pos('TRADECODE=',Str)>0 Then
                 Begin
                   ReplaceSubString('TRADECODE=','',Str);
                   ID := Str;
                 End;
                 if FInitStkCode Then
                 if Pos('STKCODE=',Str)>0 Then
                 Begin
                   ReplaceSubString('STKCODE=','',Str);
                   ID := Str;
                 End;
                 if Length(ID)>0 Then
                 Begin
                    SetAID(ID);
                    ID := '';
                 End;
             End;
             f.Clear;
        end; ////The end if pos('stopissue',..)
      End;
    End;

Except
End;
Finally
  f.Destroy;
  //排序
  SortID;
End;

end;


procedure TIDLstMgr2.Refresh;
begin
  InitData;
end;

procedure TIDLstMgr2.SetAID(const ID: ShortString);
Var
  i : Integer;
begin
  For i:=0 to FIDList.Count-1 do
     if FIDList.Strings[i]=ID Then
        exit; 
  FIDList.Add(ID);
end;

procedure TIDLstMgr2.SortID;
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2 : String;
  i,Count :Integer;
Begin

  if FIDList.Count=0 then exit;

  i := FIDList.Count;
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin
            lTemp  := FIDList.Strings[lLoop1];
            lHold  := lLoop1;
            lTemp2 := FIDList.Strings[lHold - lHValue];
            while lTemp2 > lTemp do
            Begin
                 FIDList.Strings[lHold] := FIDList.Strings[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
                 lTemp2 := FIDList.Strings[lHold - lHValue];
            End;
            FIDList.Strings[lHold] := lTemp;
        End;
  Until lHValue = 0;


end;

procedure TGetDocMgrParam.SetTodayCheckIdxIsOk;
Var
 iniFile : TiniFile;
Begin

    iniFile    := TiniFile.Create(FIniPath+'Setup.ini');
    iniFile.WriteString('Config','CheckIdxDate',FormatDateTime('yyyymmdd',Date));
    iniFile.Free;

end;

function TGetDocMgrParam.GetTodayCheckIdx:Boolean;
Var
 iniFile : TiniFile;
Begin

    Result :=false;
    iniFile    := TiniFile.Create(FIniPath+'Setup.ini');
    if(iniFile.ReadString('Config','CheckIdxDate','')
        =FormatDateTime('yyyymmdd',Date)) then
      Result :=true;
    iniFile.Free;

end;

{ TDocLstDatMgr }

constructor TDocLstDatMgr.Create(const Tr1DBPath: ShortString);
begin
   FTr1DBPath := Tr1DBPath;
   FDocLst := TStringList.Create;
end;

destructor TDocLstDatMgr.Destroy;
begin
  FDocLst.Destroy;
  //inherited;
end;

function TDocLstDatMgr.ExistDoc(Title: ShortString; ADate: TDate): Boolean;
Var
  Str : String;
  i : Integer;
begin

   Result := false;
   Str := Title+'/'+FormatDateTime('yyyy-mm-dd',ADate);
   For i:=0 to FDocLst.Count-1 do
   Begin
       if FDocLst.Strings[i]=Str Then
       Begin
           Result := True;
           Break;
       End;
   End;

end;

function TDocLstDatMgr.LoadDocTitle(ID: ShortString):Boolean;
Var
  DocFile : String;
  IDBeSeek : Boolean;
  i,index : Integer;
  f  : TStringList;
  Str:String;
begin

 f:=nil;
 FID := ID;
 FDocLst.Clear;
 Result := false;
try
try

  DocFile := FTr1DBPath+'CBData\Document\doclst.dat';
  if Not FileExists(DocFile) Then
     Exit;

  f := TStringList.Create;
  f.LoadFromFile(DocFile);

  IDBeSeek := False;
  for index:=0 to f.Count-1 do
  Begin
    Str := f.Strings[index];
    if (Pos('[',Str)>0) and
       (Pos(']',Str)>0) and
       (Pos('=',Str)=0) and
       (Pos(',',Str)=0) Then
    Begin
        ReplaceSubString('[','',Str);
        ReplaceSubString(']','',Str);
        if ID=Str Then
        Begin
           if IDBeSeek Then
              Break;
           IDBeSeek := True;
           Continue;
        End;
    End;
    if IDBeSeek Then
    Begin
        i := Pos(',',Str);
        Str := Copy(Str,i+1,Length(Str)-i);
        FDocLst.Add(Str);
    End;
  End;


  Result := True;


Except
End;
Finally
  if Assigned(f) Then
     f.Destroy;
End;
end;

initialization
  InitializeCriticalSection(TGetDocMgrCriticalSection);


end.
