{*****************************************************************************
 1 承夹ボDocFtp2.0.0.0-Doc2.3.0.0-惠―5-libing-2007/09/20-э
    夹ボ奔Doccbpa4.24肚戈┮Τ钡
 2 承夹ボDocFtp2.0.0.0-Doc2.3.0.0-惠―8-libing-2007/09/20-э
     夹ボCB戈肚狝叭竟
//--DOC4.0.0N001 huangcq090407 add Doc籔WarningCenter俱
//--DOC4.0.0N002 huangcq081223 э肚Θ┪ア毖矗ボ
//--DOC4.0.0N005 huangcq090326 そア拜肈ぇ確
//--Doc4.2.0--N003--sun-20090922  糤癸ゴそ肚
*******************************************************************************}
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActnList, Menus, ImgList, IdIntercept, IdLogBase,
  IdLogDebug, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdFTP, ComCtrls, ToolWin, StdCtrls,TDocMgr,CsDef,TCommon, ZLib,
  IdFTPCommon,TTr1Funs,IniFiles,DateUtils,SocketClientFrm,TSocketClasses,
  TDatPackage,uFuncRateData,TCallBack;//TWarningServer

const
  _SwapOption='SwapOption';
  _SwapYield='SwapYield';
  
type
  TtagCOPYDATASTRUCT = Packed Record
    dwData:DWORD ;
    cbData:DWORD ;
    lpData:Pointer;
  End;

  TDisplayMemo=Class
  private
    FMsg : string; //====DOC4.2-N003-sun-20090922
    FMemo1 : TListBox;
    FMemo2 : TListBox;
    ClearDate :TDate;
  public
      constructor Create(AMemo1,AMemo2: TListBox);
      destructor  Destroy; override;
      procedure AddMsg1(Const Msg:String);
      procedure AddMsg2(Const Msg:String);
      procedure AddMsg(const RunStatus:TRunStatus; Const Msg:String);//====DOC4.2-N003-sun-20090922
      procedure ClearMsg1();
      procedure ClearMsg2();
      procedure SaveToLogFile(Const Msg:String);
      procedure ClearSysLog;
  end;


  TAMainFrm = class(TForm)
    Bevel4: TBevel;
    Bevel3: TBevel;
    Bevel2: TBevel;
    Panel1: TPanel;
    Splitter1: TSplitter;
    ListMemo1: TListBox;
    ListMemo2: TListBox;
    Panel2: TPanel;
    Panel3: TPanel;
    Bevel5: TBevel;
    SBar: TStatusBar;
    Panel4: TPanel;
    Bevel6: TBevel;
    PBar: TProgressBar;
    ToolBar1: TToolBar;
    ToolButton3: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton6: TToolButton;
    IdFTP1: TIdFTP;
    IdLogDebug1: TIdLogDebug;
    ImageList1: TImageList;
    MainMenu2: TMainMenu;
    Menu_Main: TMenuItem;
    Mnu_Stop: TMenuItem;
    Mnu_Start: TMenuItem;
    N4: TMenuItem;
    Mnu_ReStart: TMenuItem;
    N6: TMenuItem;
    Mnu_Exit: TMenuItem;
    ActionList1: TActionList;
    Act_StartServer: TAction;
    Act_StopServer: TAction;
    Timer_Start: TTimer;
    ImageList2: TImageList;
    Mnu_UploadDocLst: TMenuItem;
    N1: TMenuItem;
    TimerSendLiveToDocMonitor: TTimer;
    procedure Act_StopServerExecute(Sender: TObject);
    procedure IdFTP1Status(axSender: TObject; const axStatus: TIdStatus;
      const asStatusText: String);
    procedure IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdFTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdFTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure IdLogDebug1LogItem(ASender: TComponent; var AText: String);
    procedure Timer_StartTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Act_StartServerExecute(Sender: TObject);
    procedure CoolTrayIconDblClick(Sender: TObject);
    procedure Mnu_UploadDocLstClick(Sender: TObject);
    procedure IdLogDebug1Receive(ASender: TIdConnectionIntercept;
      AStream: TStream);
    procedure IdLogDebug1Send(ASender: TIdConnectionIntercept;
      AStream: TStream);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Mnu_ExitClick(Sender: TObject);
    procedure TimerSendLiveToDocMonitorTimer(Sender: TObject);
  private
    FNowIsRunningServer: Boolean;
    FNowIsDowning  : Boolean;
    StopRunning : Boolean;
    NowIsStopOrStart : Boolean;
    DisplayMemo : TDisplayMemo;
    FDataPath : String;
    FDocPath  : String;
    DocDataMgr : TDocDataMgr;
    CBDataMgr  : TCBDataMgr;
    DatPackageParam : TDatPackageParam;//====DOC4.2-N003-sun-20090922
    ASocketClientFrm : TASocketClientFrm; //--DOC4.0.0—N001 huangcq090407 add
    procedure SendDocMonitorStatusMsg;//--DOC4.0.0—N001 huangcq090407 add
    function SendDocMonitorWarningMsg(const Str: String): boolean;//--DOC4.0.0—N001 huangcq090407 add
    procedure Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);//--DOC4.0.0—N001 huangcq090407 add     

    procedure SetNowIsRunningServer(const Value: Boolean);
  private
    { Private declarations }
    AppParam : TDocMgrParam;
    STime : TDateTime;
    AbortTransfer: Boolean;
    TransferrignData: Boolean;
    BytesToTransfer: LongWord;
    FNeedUploadDocLst : Boolean;

    FRateDatTickCount,FRateDatTickCount2:DWORD;
    Property NowIsRunningServer:Boolean Read FNowIsRunningServer write SetNowIsRunningServer;
    function TimeOutRateDatTickCount:boolean;
    function TimeOutRateDatTickCount2:boolean;
    procedure RefreshRateDatTickCount;
    procedure RefreshRateDatTickCount2;
    function FtpDirectoryExists(ADir: string): Boolean;
    function ConnectFtp(AUserName,APassword,AHost,AChangeDir:ShortString;APort:integer;APassive:Boolean):Boolean;
    function DealWithUploadLog(aWorkFile,aTag:string):boolean;
    function FtpRateDat(ADate:TDate;Proc:TFarProc=nil):integer;
    function FtpSwapDat(Proc:TFarProc=nil):integer;
    Procedure ShowSBar(Msg:String);
  public
    { Public declarations }
    procedure InitObj();
    procedure FreeObj();
    function  GetCompressFile(fileName:String):String;
    Function  FtpData(FileName,ToFilePath,ToFileName:string):Boolean;
    Function  FtpCheckUpLoadFileExist(FileName,ToFileName:String):Boolean; //--DOC4.0.0—N005 huangcq090326
    function  FtpDataDoc(index:integer):boolean;
    function  FtpDataDocLst():boolean;
    Function  FtpDocLstToServer(index :integer):Boolean;

    Procedure ModifyGUID(FileName,FID :String);
    Procedure AddToNeedUpLoadIDLst(index :integer;FID :String);overload;
    Procedure AddToNeedUpLoadIDLst(index :integer;UploadIDList:TStringList);overload;
    Procedure GetNeedUpLoadIDLst(index :integer;var UploadIDList:TStringList);
    Procedure DelFromNeedUpLoadIDLst(index :integer;FID :String);
    function  GetNeedUpLoadIDLstCount(index :integer):integer;
    //DocFtp2.0.0.0-Doc2.3.0.0-需求8-libing-2007/09/20
    //----------------------------------------------------------
    function FtpDataCBTxt2(index:integer):boolean;   //睰肚ま絪腹
    //----------------------------------------------------------
    procedure ReStart();
    procedure Start();
    procedure Stop();
    function HaveAllUpload(AFtpFileName:String) : Boolean;
    //================DOC4.2-N001-sun-20090922===========================
    function FtpDocData(Index:Integer):boolean;
    function FtpIDDocListData(Index:Integer):boolean;//modify by wangjinhua DatPackage Problem(20090413)
    Function FilenameisinList(AfileList:TstringList;Afilename:String):boolean;
    function CheckLocalInWeb(var AFtp : TIdFtp;Index:Integer):boolean;//add by wangjinhua DatPackage Problem(20090413)
    procedure ShowMsg(const RunStatus:TRunStatus; Const Msg:String);
    Function ConvertStr(Str:ShortString;Const ADwnMemo:String=''):ShortString;
    //=====================================================================
  end;

var
  AMainFrm: TAMainFrm;
implementation
Var
  AverageSpeed: Double = 0;
  UpLoadDocMark: Boolean = False;  //=====DOC4.2-N001-sun-20090922=========
  FWizDayConvDatRunStatusMsg : string;
{$R *.dfm}

Procedure WizDayConvDatRunStatus1(status,v:Integer;msg:ShortString;Var DoBool:Boolean);
Begin

     //Msg := CGBToBig5(Msg);

     if Status=CALL_BACK_MSG then  //Init
     Begin
       if (Length(Msg)>0 ) and (FWizDayConvDatRunStatusMsg <> Msg) Then
       Begin
           FWizDayConvDatRunStatusMsg := Msg;
           AMainFrm.ShowSBar(Msg);
       End;
        //AMainFrm.ShowMsg(runMsg,Msg);
        Application.ProcessMessages;
     End;

     if Status=CALL_BACK_RUNNING then  //Init
     Begin
        {if _P_UserCancel then
        begin
          if Application.MessageBox('是否要停止?','',MB_YESNO)=IDYES then
             DoBool:=false
          Else
             _P_UserCancel := False;
        end;
        }
        DoBool := Not StopRunning;
        if (Length(Msg)>0 ) and (FWizDayConvDatRunStatusMsg <> Msg) Then
        Begin
           FWizDayConvDatRunStatusMsg := Msg;
           AMainFrm.ShowSBar(Msg);
        End;
        Application.ProcessMessages;
     End;

     //*************
     if Status = CALL_BACK_DOEVENT then //DoEvent
       Application.ProcessMessages;


     if Status = CALL_BACK_STEP then //Runing
     begin
        if (Length(Msg)>0 ) and (FWizDayConvDatRunStatusMsg <> Msg) Then
        Begin
           FWizDayConvDatRunStatusMsg := Msg;
           AMainFrm.ShowSBar(Msg);
        End;
       Application.ProcessMessages;
     end;


    if Status = CALL_BACK_ERROR then
    begin
      if (Length(Msg)>0 ) and (FWizDayConvDatRunStatusMsg <> Msg) Then
        Begin
           FWizDayConvDatRunStatusMsg := Msg;
           AMainFrm.ShowMsg(runError,Msg);
        End;
      Application.ProcessMessages;
    end;

    if Status = CALL_BACK_WARNING then
    begin
      if (Length(Msg)>0 ) and (FWizDayConvDatRunStatusMsg <> Msg) Then
        Begin
           FWizDayConvDatRunStatusMsg := Msg;
           AMainFrm.ShowMsg(runError,Msg);
        End;
      Application.ProcessMessages;
    end;

    if Status = CALL_BACK_FINISH then
    begin
      AMainFrm.ShowSBar('');
      Application.ProcessMessages;
    end;
End;

{ TAMainFrm }

Function TAMainFrm.ConvertStr(Str:ShortString;Const ADwnMemo:String=''):ShortString;
begin
  AppParam.ConvertString(Str);
end;

procedure TAMainFrm.FreeObj;
begin

   if DisplayMemo<>nil Then
      DisplayMemo.Destroy;

   if DocDataMgr<>nil Then
      DocDataMgr.Destroy;

   if AppParam<>nil Then
      AppParam.Destroy;

end;

function TAMainFrm.FtpDataDoc(index:integer):boolean;
Var
  Server,AUserName,Pass,uplDir : String;
  APort : Integer;
  FileLst : _CStrLst;
  FileName : string;
  i,j,k : Integer;
  ADoc : TUploadDoc;
  UploadIDList : TStringList;
begin

  Result := false;
  SetLength(FileLst,0);
  FileLst := DocDataMgr.GetUploadTmpFile;
  if High(FileLst)<0 Then
  begin
    Result := true;
    Exit;
  end;
  Try

    IdFTP1.ChangeDir('document');
    k := index;

    Server    := AppParam.DocFTPInfos[k].FFTPServer;
    uplDir    := AppParam.DocFTPInfos[k].FFTPUploadDir;
    AUserName := AppParam.DocFTPInfos[k].FFTPUserName;
    Pass      := AppParam.DocFTPInfos[k].FFTPPassword;
    APort     := AppParam.DocFTPInfos[k].FFTPPort;

    if Assigned(UploadIDList) Then
      UploadIDList.Free;
    UploadIDList := TStringList.Create;
    For i:=0 to High(FileLst) do
    Begin    
      ADoc := DocDataMgr.GetUploadADoc(FileLst[i],Server+':'+IntToStr(APort));    
      if(Adoc.FTP_Note=1)then Continue;    
        
      FileName := ADoc.FileName;
      if StopRunning Then Exit;

      if Adoc.Del=1 then
      begin
        FileName := '';
      end
      else begin
        for j:=0 to 3 do    
        Begin
          DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') + ExtractFileName(FileName));
          if StopRunning Then Exit;    
          if FtpData(FileName,'',ChangeFileExt(ExtractFileName(FileName),'.rtf')) Then
          Begin
            //--DOC4.0.0—N005 huangcq090326 add 这里插入复核的模块----> 
            if (FtpCheckUpLoadFileExist(FileName,ChangeFileExt(ExtractFileName(FileName),'.rtf'))) then
            begin
              FileName := '';
              Break;
            end;
            //<---DOC4.0.0—N005 huangcq090326 ---
          End;    
        End;
      end;

      if Length(FileName)>0 Then    
      Begin       
        //fail
        DisplayMemo.AddMsg2(FileName+AppParam.ConvertString(' 上传错误.'));
        DocDataMgr.SaveUploadADoc(FileLst[i],Server+':'+IntToStr(APort),0);       
        Exit;       
      End Else
      Begin
        //success
        FNeedUploadDocLst := True;
        DocDataMgr.SaveUploadADoc(FileLst[i],Server+':'+IntToStr(APort),1);       
        if(HaveAllUpload(FileLst[i]))then
          DeleteFile(FileLst[i]);       
        if(UploadIDList.IndexOf(ADoc.ID)=-1)then
          //UploadIDList.Add(ADoc.ID);
          AddToNeedUpLoadIDLst(k,ADoc.ID);
      End;
    End;    
    Result := True;

    if FNeedUploadDocLst Then
    Begin
      //Add To needuploadIDlst
      AddToneeduploadIDlst(k,UploadIDList);
      //AddToNeedUpLoadIDLst(k,'doclst');
      FNeedUploadDocLst := False;
    End;
  Except
    On E: Exception do
    Begin
      Result := false;

      if FNeedUploadDocLst Then
      Begin
        AddToneeduploadIDlst(k,UploadIDList);
        //AddToNeedUpLoadIDLst(k,'doclst');
        FNeedUploadDocLst := False;
      End;

      DisplayMemo.AddMsg2(E.Message);
      //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError); //--DOC4.0.0—N001 huangcq090407 del
      SendDocMonitorWarningMsg(AppParam.ConvertString('公告上传出现错误')+'('+E.Message+')$E009');//--DOC4.0.0—N001 huangcq090407 add
    End;
  end;
  IdFTP1.ChangeDir('..');

  if Assigned(UploadIDList) Then
    UploadIDList.Free;
end;

procedure TAMainFrm.InitObj;
begin
   FRateDatTickCount:=0;
   FRateDatTickCount2:=0;
   
   AppParam := TDocMgrParam.Create;
   FDataPath := ExtractFilePath(Application.ExeName)+'Data\';
   FDocPath := AppParam.FTPTr1DBPath  + 'CBData\Document\';

   DisplayMemo := TDisplayMemo.Create(ListMemo1,ListMemo2);
   DocDataMgr := TDocDataMgr.Create(FDataPath,FDocPath);
   CBDataMgr  := TCBDataMgr.Create(AppParam.IsTwSys,AppParam.FTPTr1DBPath);

   Caption :=  AppParam.ConvertString('公告信息上传工具');

   Act_StartServer.Caption :=  AppParam.ConvertString('启动服务');
   Act_StartServer.Hint :=  AppParam.ConvertString('启动服务');
   Act_StopServer.Caption :=  AppParam.ConvertString('停止服务');
   Act_StopServer.Hint :=  AppParam.ConvertString('停止服务');

   Menu_Main.Caption :=  AppParam.ConvertString('功能');
   Mnu_ReStart.Caption :=  AppParam.ConvertString('重新启动');
   Mnu_UploadDocLst.Caption :=  AppParam.ConvertString('上传清单');
   Mnu_Exit.Caption :=  AppParam.ConvertString('离开');

   IdFTP1.ReadTimeout:=8000;

  //ConnectToSoundServer(AppParam.SoundServer,AppParam.SoundPort); //--DOC4.0.0—N001 huangcq090407 del
  //--DOC4.0.0—N001 huangcq090407 add------>
  ASocketClientFrm := TASocketClientFrm.Create(Self,'Doc_Ftp',AppParam.DocMonitorHostName
                                            ,AppParam.DocMonitorPort,Msg_ReceiveDataInfo);

  TimerSendLiveToDocMonitor.Interval := 3000;
  TimerSendLiveToDocMonitor.Enabled  := True;
  //<------DOC4.0.0—N001 huangcq090407 add----

  //========Doc4.2-N003-sun-20090922====================
    DatPackageParam := TDatPackageParam.Create;
  //======================================================

end;

procedure TAMainFrm.ReStart;
begin
   Stop;
   Start;
end;

procedure TAMainFrm.SetNowIsRunningServer(const Value: Boolean);
begin
   FNowIsRunningServer := Value;

   Act_StopServer.Enabled  := Value;
   Act_StartServer.Enabled := Not Value;
   Mnu_ReStart.Enabled     := Value;
   Mnu_UploadDocLst.Enabled  := Value;
end;

procedure TAMainFrm.ShowSBar(Msg: String);
begin
  SBar.Panels[2].text := (Msg);
end;

procedure TAMainFrm.Start;
var sAppIni,sSleep:string;
begin

   if NowIsStopOrStart Then  Exit;
   NowIsStopOrStart := True;
   StopRunning := False;
   InitObj;

   //DocDataMgr.ConvertToNewDocLst('');
   //ShowMessage('ok');
   //Halt;
   sAppIni:=ExtractFilePath(ParamStr(0))+'setup.ini';
   sSleep:=GetIniFile(PChar('CONFIG'),PChar('DocFtpSleepTime'),PChar('5'),PChar(sAppIni));
   if MayBeDigital(sSleep) and (StrToInt(sSleep)>0) then
     Timer_Start.Interval:=StrToInt(sSleep)*1000;
   Timer_Start.Enabled := True;
   NowIsStopOrStart := false;
   NowIsRunningServer := True;

end;

procedure TAMainFrm.Stop;
begin

  if NowIsStopOrStart Then  Exit;
  NowIsStopOrStart := True;

  FreeObj;

  NowIsStopOrStart := false;
  NowIsRunningServer := false;

end;

//DocFtp2.0.0.0-Doc2.3.0.0-需求8-libing-2007/09/20
//****************************************************************************
function TAMainFrm.FtpDataCBTxt2(index:integer): boolean;
Var
  Server,AUserName,Pass,uplDir : String;
  UsePass : Boolean;
  APort : Integer;
  FileLst : _CStrLst;
  FileName ,FTPFileName: string;
  i,j,k : Integer;    //k为服务器编号
  IsTransSuccess,needupload,uploadsuccess:Boolean;

begin
  Result := false;
   //DocFtp2.0.0.0-Doc2.3.0.0-需求8-libing-2007/09/20
//----------------
  needupload:=False;//
  for k:=0 to AppParam.CBFTPCount-1 do
  begin
    if (GetNeedUpLoadIDLstCount(k)>0) then
      needupload:=true;
  end;
//-------------
  FileLst := CBDataMgr.GetUploadTmpFile;
  if High(FileLst)<0 Then Exit;
  //DocFtp2.0.0.0-Doc2.3.0.0-需求8-libing-2007/09/20
 try
    Try
      for k:=0 to AppParam.CBFTPCount-1 do
      begin
         DisplayMemo.AddMsg1(AppParam.ConvertString('开始准备上传CB数据'));
         SetLength(FileLst,0);
         FileLst:=CBDataMgr.GetUploadTmpFile;
        if (High(CBDataMgr.GetUploadTmpFile)>=0)or needupload then
        begin
         Server:=AppParam.CBFTPInfos[k].FFTPServer;
         uplDir:=AppParam.CBFTPInfos[k].FFTPUploadDir;
         AUserName:=AppParam.CBFTPInfos[k].FFTPUserName;
         Pass:=AppParam.CBFTPInfos[k].FFTPPassword;
         APort := AppParam.CBFTPInfos[k].FFTPPort;
         UsePass := AppParam.CBFTPInfos[k].FFTPPassive;
        end;
        with IdFTP1 do
        Begin
            //DisplayMemo.AddMsg1(AppParam.ConvertString('连结服务器 ') + Server);
            if Connected Then
              Disconnect;
            DisplayMemo.AddMsg1(AppParam.ConvertString('连结服务器 ') + Server);
            if Not Connected Then
            Begin
               UserName := AUserName;
               Password := Pass;
               Host     := Server;
               Passive  := UsePass;
               Port     := APort;
               Connect;
               TransferType := ftBinary;
               ChangeDir(AppParam.CBFTPInfos[k].FFTPUploadDir);
               //ChangeDir(uplDir);
            End;

          For i:=0 to High(FileLst) do
          Begin
               if GetFileSize(FileLst[i])=0 then
               begin
                 DeleteFile(FileLst[i]);
                 Continue;
               end;
               uploadsuccess:=False;//--DOC4.0.0—N002 huangcq081223 add 这里应该要赋初值
               ChangeDir(CBDataMgr.GetUploadAFolder(FileLst[i]));

               if StopRunning Then Exit;

               for j:=0 to 3 do
               Begin
                 FileName := CBDataMgr.GetUploadAFileName(FileLst[i]);
                 if StopRunning Then Exit;
                 //如果附檔名是.DAT的就壓縮檔案上傳
                 if (Pos('.DAT',UpperCase(FileName))>0){ And (ExtractFileName(FileName)<>'dealerlst.dat') }Then
                 Begin
                      CompressFile(GetCompressFile(FileName),FileName,clMax);
                      FileName := GetCompressFile(FileName);

                      DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') + ExtractFileName(FileName));
                      if StopRunning Then Exit;
                      if FtpData(FileName,'',LowerCase(ExtractFileName(FileName))) Then
                      Begin
                        DeleteFile(FileName);
                        FileName := '';
                        uploadsuccess:=true;
                        Break;
                      End;
                 End Else
                 Begin
                    DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') + ExtractFileName(FileName));
                    if FtpData(FileName,'',LowerCase(ExtractFileName(FileName))) Then
                    Begin
                        FileName := '';
                        uploadsuccess:=true;
                        Break;
                    End;
                 End;
               End;

               if (Length(FileName)=0) and (Pos('.TXT',UpperCase(CBDataMgr.GetUploadAFileName(FileLst[i])))>0) Then
               Begin
                  uploadsuccess:=False;//--DOC4.0.0N002 huangcq081223 add ňゎ.lstゅン⊿Τ砆肚
                  FileName := ExtractFilePath(CBDataMgr.GetUploadAFileName(FileLst[i]))+'dblst.lst';
                  if Not FileExists(FileName) Then
                     FileName := ExtractFilePath(FileName)+'dblst2.lst';
                  CBDataMgr.ChangeDBLstVer(FileName);

                  for j:=0 to 3 do
                  Begin
                    DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') + ExtractFileName(FileName));
                    if StopRunning Then Exit;
                    if(ExtractFileName(FileName)='dblst2.lst')then
                      FTPFileName := 'dblst311.lst'
                    else
                      FTPFileName := 'dblst.lst';
                    if FtpData(FileName,'',FTPFileName) Then
                    Begin
                      FileName := '';
                      uploadsuccess:=true;
                      Break;
                    End;
                  End;

                  {if(ExtractFileName(FTPFileName)='dblst311.lst')then
                  begin
                    uploadsuccess:=False;
                    FileName := ExtractFilePath(CBDataMgr.GetUploadAFileName(FileLst[i]))+'dblst201508.lst';
                    CBDataMgr.ChangeDBLstVer(FileName);

                    for j:=0 to 3 do
                    Begin
                      DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') + ExtractFileName(FileName));
                      if StopRunning Then Exit;
                      FTPFileName := ExtractFileName(FileName);
                      if FtpData(FileName,'',FTPFileName) Then
                      Begin
                        FileName := '';
                        uploadsuccess:=true;
                        Break;
                      End;
                    End;
                  end;}
                
               End;
               if Length(FileName)>0 Then
               Begin
                 DisplayMemo.AddMsg2(FileName+AppParam.ConvertString(' 上传错误.'));
                 Exit;
               End Else
               Begin
                //if k=1   then    //DocFtp2.0.0.0-Doc2.3.0.0-需求8-libing-2007/09/20
                  if uploadsuccess then
                  begin
                    CBDataMgr.SetCBDataLog('DocFtp_'+IntToStr(k+1),
                                          CBDataMgr.GetUploadAFileName(FileLst[i]),FileLst[i],'','',
                                          AppParam.CBFTPCount,Server+';'+uplDir); //--DOC4.0.0—N002 huangcq081223 add
                    //if k =(AppParam.CBFTPCount-1) then
                    if CBDataMgr.FinishUploadCBDataByLog(CBDataMgr.GetUploadAFileName(FileLst[i]),FileLst[i],AppParam.CBFTPCount) then
                    begin
                      DeleteFile(FileLst[i]);
                      {FileName := CBDataMgr.GetUploadAFileName(FileLst[i]);
                      if SameText(ExtractFileExt(FileName),'.upl') then
                      begin
                        DeleteFile(FileName);
                      end;}
                    end;
                    break;
                  end;
               End;
               ChangeDir('..');
          end;
        End;
        Result := True;
      end;
    Except
      On E: Exception do
        Begin
          DisplayMemo.AddMsg2(E.Message);
          //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError); //--DOC4.0.0—N001 huangcq090407 del
          SendDocMonitorWarningMsg(AppParam.ConvertString('CB数据上传出现错误')+'('+E.Message+')$E009');//--DOC4.0.0—N001 huangcq090407 add
        End;
    end;
  Finally
   if Not Result Then
   Begin
     if IdFTP1.Connected Then
        IdFTP1.Disconnect;
   End;
   if StopRunning Then
   Begin
      DisplayMemo.AddMsg1(AppParam.ConvertString('上传CB数据中断'));
      //SendToSoundServer('GET_DOC_ERROR',AppParam.ConvertString('上传CB数据中断'),svrMsgError); //--DOC4.0.0—N001 huangcq090407 del
   End Else
   Begin
      if Result Then
        DisplayMemo.AddMsg1(AppParam.ConvertString('完成上传CB数据'))
      Else Begin
        DisplayMemo.AddMsg1(AppParam.ConvertString('上传CB数据失败'));
        //SendToSoundServer('GET_DOC_ERROR',AppParam.ConvertString('上传CB数据失败'),svrMsgError); //--DOC4.0.0—N001 huangcq090407 del
      End;
   End;
 end;
end;
//*******************************************************************************

function TAMainFrm.GetCompressFile(fileName: String): String;
begin
   Result := Format('%s_%s',[ExtractFilePath(FileName),
                              ExtractFileName(FileName)]);
end;

function TAMainFrm.FtpData(FileName, ToFilePath,
  ToFileName: string): Boolean;
Var
 tempFileName :  String;
begin
Try
  FileName := LowerCase(FileName);

  if Length(ToFileName)=0 Then    
     ToFileName := FileName;    

  TempFileName := ToFilePath+LowerCase('~'+ExtractFileName(ToFileName));
  IdFTP1.TransferType := ftBinary;
  IdFTP1.Put(FileName,TempFileName);
  BytesToTransfer := IdFTP1.Size(TempFileName);
  if BytesToTransfer=GetFileSize(FileName) Then
  Begin
     if IdFTP1.Size(ToFilePath+ExtractFileName(ToFileName))>=0 Then
         IdFTP1.Delete(ToFilePath+ExtractFileName(ToFileName));
     IdFTP1.Rename(TempFileName,ToFilePath+ExtractFileName(ToFileName));
     Result := True
  End Else
     Result := False;
Except
  On E: Exception do
    Raise Exception.Create(E.Message);
End;


end;

Function  TAMainFrm.FtpCheckUpLoadFileExist(FileName,ToFileName:String):Boolean; //--DOC4.0.0—N005 huangcq090326
var
  AFileLst:TStrings;
begin
  Result:=False;
  try
    AFileLst:=TStringList.Create;
    try
      IdFTP1.List(AFileLst,ToFileName,False);
      if AFileLst.Count>0 then //ToFileName Exist FtpServer
      begin
        if IdFTP1.Size(ToFileName)=GetFileSize(FileName) then  //same the size of ToFileName
          Result:=True
        else
          Result:=False; //need reUpLoad
      end;
    except
      Result:=False; //the ToFileName not exist in ftpserver
    end;
  finally
    AFileLst.Free;
  end;
end;

function TAMainFrm.FtpDataDocLst: boolean;
Var
  i,k : integer;
  StockLst :TStringList;
  StrTemp : String;
begin
try

  StockLst :=TStringList.Create;
  if not FileExists(DocDataMgr.GetUploadStockDocIdxLst)then
    ShowMEssage('StockIDLst File Not Found!')
  else
    StockLst.LoadFromFile(DocDataMgr.GetUploadStockDocIdxLst);
  //记录下来，下一次轮回时处理
  FOR k:=0 TO AppParam.DocFTPCount-1 DO
  BEGIN
    //AddToNeedUpLoadIDLst(k,'doclst');
    AddToNeedUpLoadIDLst(k,'StockDocIdxLst');
    For i:=0 To StockLst.Count-1 DO
    Begin
      StrTemp := StockLst.Strings[i];
      if(Pos('GUID',StrTemp)>0)then
        continue;
      ReplaceSubString('[','',StrTemp);
      ReplaceSubString(']','',StrTemp);
      AddToNeedUpLoadIDLst(k,StrTemp);
    End;
  END;

  ShowMessage(AppParam.ConvertString('已经加入上传队列，将会在下轮处理'));

except
end;
  if assigned(StockLst)then
    StockLst.Free;
end;

Function TAMainFrm.FtpDocLstToServer(index :integer):Boolean;
Var
  j : Integer;
  DocLstFileName,ID : String;
  NeedUPLIDlst : TStringlist;
  NeedUPLStock : Boolean;
begin

  Result := False;
  NeedUPLStock := False;
  DocLstFileName := '';   
  NeedUPLIDlst := TStringlist.Create;   
  GetNeedUpLoadIDLst(index,NeedUPLIDlst);   
  if(NeedUPLIDlst.Count=0)then   
  begin   
   Result := true;   
   Exit;
  end;   
  {
  IdFTP1.ChangeDir('document');
  }
  //检查上次StockDocIdxLst上传是否成功
  TRY

    IdFTP1.ChangeDir('document');

    if(Pos('StockDocIdxLst',NeedUPLIDlst.Text)>0)then   
    begin   
        if Length(DocLstFileName)=0 Then   
        Begin
          DocLstFileName := DocDataMgr.GetUploadStockDocIdxLst;   
          CompressFile(GetCompressFile(DocLstFileName),DocLstFileName,clMax);   
          DocLstFileName := GetCompressFile(DocLstFileName);
          DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') + ExtractFileName(DocLstFileName));
          for j:=0 to 3 do   
          Begin   
            if FtpData(DocLstFileName,'',ExtractFileName(DocLstFileName)) Then
            Begin   
              DeleteFile(DocLstFileName);
              DelFromNeedUpLoadIDLst(index,'StockDocIdxLst');   
              DocLstFileName := '';   
              Break;   
            End;
          End;   
        End;   
    End;   
  Except
    On E: Exception do
    Begin
      DisplayMemo.AddMsg1('StockDocIdxLst上传数据失败');
      DisplayMemo.AddMsg2(E.Message);
      //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError); //--DOC4.0.0—N001 huangcq090407 del
      SendDocMonitorWarningMsg(AppParam.ConvertString('公告清单(StockDocIdxLst)上传出现错误')+'('+E.Message+')$E009');//--DOC4.0.0—N001 huangcq090407 add
      DocLstFileName := 'error';
    End;
  End;

  //上传 doclst.dat
  {TRY
    if Length(DocLstFileName)=0 Then
    Begin
    if(Pos('doclst',NeedUPLIDlst.Text)>0)then
    begin
     for j:=0 to 3 do
     Begin
      if StopRunning Then Exit;
      DocLstFileName := DocDataMgr.GetUploadDocLst();
      if FileExists(DocLstFileName) Then
      Begin
        CompressFile(GetCompressFile(DocLstFileName),DocLstFileName,clMax);
        DocLstFileName := GetCompressFile(DocLstFileName);
        DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') + ExtractFileName(DocLstFileName));
        if FtpData(DocLstFileName,'',ExtractFileName(DocLstFileName)) Then
        Begin
           //Raise Exception.Create('error123');
           DeleteFile(DocLstFileName);
           DocLstFileName := '';
           DelFromNeedUpLoadIDLst(index,'doclst');
           Break;
        End;
      End;
     End;
    End;
    End;
  Except
    On E: Exception do
    Begin
      DisplayMemo.AddMsg1('doclst上传数据失败');
      DisplayMemo.AddMsg2(E.Message);
      SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError);
      DocLstFileName := 'error';
    End;
  End; }

  //上传ID_DOCLST.dat   
  TRY   
  if Assigned(NeedUPLIDlst) Then   
  if Length(DocLstFileName)=0 Then   
  Begin
      While NeedUPLIDlst.Count>0 do   
      Begin   
          if(NeedUPLIDlst.Strings[0]='StockDocIdxLst')or(NeedUPLIDlst.Strings[0]='doclst')then   
          begin   
            NeedUPLIDlst.Delete(0);   
            continue;   
          end;   
          ID := NeedUPLIDlst.Strings[0];   
          DocLstFileName := DocDataMgr.GetUploadStockDocLst(NeedUPLIDlst.Strings[0]);
          if FileExists(DocLstFileName) Then
          Begin
             CompressFile(GetCompressFile(DocLstFileName),DocLstFileName,clMax);
             DocLstFileName := GetCompressFile(DocLstFileName);
             DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') + ExtractFileName(DocLstFileName))   ;
             for j:=0 to 3 do
             Begin
               if FtpData(DocLstFileName,'',ExtractFileName(DocLstFileName)) Then
               Begin
                 DeleteFile(DocLstFileName);
                 DocLstFileName := '';

                 //modify GUID
                 ModifyGUID(DocDataMgr.GetUploadStockDocIdxLst,NeedUPLIDlst.Strings[0]);

                 //delete from NeedUpLoadIDLst_[Sever].data
                 DelFromNeedUpLoadIDLst(index,NeedUPLIDlst.Strings[0]);

                 NeedUPLStock := true;

                 Break;
               End;
             End;
             if Length(DocLstFileName)>0 Then
                Break;
          End else
          begin
            Raise Exception.Create('Cannot open file '+DocLstFileName);
          end;
          NeedUPLIDlst.Delete(0);
      End;   

      if(NeedUPLStock)then   
      begin   
        AddToNeedUpLoadIDLst(index,'StockDocIdxLst');   
        NeedUPLIDlst.Add('StockDocIdxLst');   
      end;
  End;
  Except
    On E: Exception do
    Begin
      if(NeedUPLStock)then
      begin
        AddToNeedUpLoadIDLst(index,'StockDocIdxLst');
        NeedUPLIDlst.Add('StockDocIdxLst');
      end;

      DisplayMemo.AddMsg1(ID+'_DOCLST上传数据失败');
      DisplayMemo.AddMsg2(E.Message);
      //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError); //--DOC4.0.0—N001 huangcq090407 del
      SendDocMonitorWarningMsg(AppParam.ConvertString('公告清单('+ID+'_DOCLST)上传失败')+'('+E.Message+')$E009');//--DOC4.0.0—N001 huangcq090407 add
      DocLstFileName := 'error';
    End;
  End;

  TRY
    if(Pos('StockDocIdxLst',NeedUPLIDlst.Text)>0)then
    begin
        //if Length(DocLstFileName)=0 Then   
        //Begin   
          DocLstFileName := DocDataMgr.GetUploadStockDocIdxLst;   
          CompressFile(GetCompressFile(DocLstFileName),DocLstFileName,clMax);   
          DocLstFileName := GetCompressFile(DocLstFileName);   
          DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') + ExtractFileName(DocLstFileName));   
          for j:=0 to 3 do   
          Begin   
            if FtpData(DocLstFileName,'',ExtractFileName(DocLstFileName)) Then
            Begin
              DeleteFile(DocLstFileName);   
              DelFromNeedUpLoadIDLst(index,'StockDocIdxLst');   
              DocLstFileName := '';   
              Break;   
            End;   
          End;   
        //End;
    End;
  Except   
    On E: Exception do   
    Begin   
      DisplayMemo.AddMsg1('StockDocIdxLst上传数据失败');   
      DisplayMemo.AddMsg2(E.Message);   
      //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError);//--DOC4.0.0—N001 huangcq090407 del
      SendDocMonitorWarningMsg(AppParam.ConvertString('公告清单(StockDocIdxLst)上传出现错误')+'('+E.Message+')$E009');//--DOC4.0.0—N001 huangcq090407 add
      DocLstFileName := 'error';
    End;   
  End;

  IdFTP1.ChangeDir('..');   
  if Length(DocLstFileName)=0 Then   
    Result := True;   
  if Assigned(NeedUPLIDlst)then   
    NeedUPLIDlst.Free;

end;

function TAMainFrm.HaveAllUpload(AFtpFileName: String): Boolean;
var
  i:integer;
begin
Try
  result :=true;
  FOR i:=0 TO AppParam.DocFTPCount-1 DO
  BEGIN
    if (GetIniFile(PChar('FTP_NOTE'),
                   PChar(Trim(AppParam.DocFTPInfos[i].FFTPServer+':'+IntToStr(AppParam.DocFTPInfos[i].FFTPPort))),
                   PChar('0'),
                   PChar(AFtpFileName)
                   )<>'1')then result :=false;
  END
Except
   On E: Exception do
     result :=false;
End;

end;

Procedure TAMainFrm.AddToNeedUpLoadIDLst(index :integer;UploadIDList: TStringList);
var
  IDLst : TStringlist;
  i : Integer;
  FileName : String;
begin

  FileName:=FDataPath+'NeedUpLoadIDLst.data';
  IDLst := TStringList.Create;
  if(FileExists(FileName))then
    IDLst.LoadFromFile(FileName);
  for i:=0 to UploadIDList.Count-1 do
    if(IDLst.IndexOf(UploadIDList.Strings[i]+'_'
                +AppParam.DocFTPInfos[index].FFTPServer+'('
                +IntToStr(AppParam.DocFTPInfos[index].FFTPPort)+')')=-1)then
      IDLst.Add(UploadIDList.Strings[i]+'_'
                +AppParam.DocFTPInfos[index].FFTPServer+'('
                +IntToStr(AppParam.DocFTPInfos[index].FFTPPort)+')');
  IDLst.SaveToFile(FileName);
  if Assigned(IDLst)then
    IDLst.Free;

end;

procedure TAMainFrm.ModifyGUID(FileName, FID: String);
var
  DocLst : TIniFile;
begin

  if(not FileExists(FileName))then exit;

  DocLst := TIniFile.Create(FileName);
  DocLst.WriteString(FID,'GUID',Get_GUID8);
  DocLst.Free;

end;

procedure TAMainFrm.DelFromNeedUpLoadIDLst(index :integer;FID: String);
var
  IDLst : TStringlist;
  FileName : String;
begin

  FileName:=FDataPath+'NeedUpLoadIDLst.data';
  IDLst := TStringList.Create;
  if(FileExists(FileName))then
    IDLst.LoadFromFile(FileName)
  else
    exit;
  FID:=FID+'_'+AppParam.DocFTPInfos[index].FFTPServer+'('
                         +IntToStr(AppParam.DocFTPInfos[index].FFTPPort)+')';
  if(IDLst.IndexOf(FID)<>-1)then
    IDLst.Delete(IDLst.IndexOf(FID));
  IDLst.SaveToFile(FileName);
  if Assigned(IDLst)then
    IDLst.Free;

end;

procedure TAMainFrm.AddToNeedUpLoadIDLst(index :integer;FID: String);
var
  IDLst : TStringlist;
  FileName : String;
begin

  FileName:=FDataPath+'NeedUpLoadIDLst.data';
  IDLst := TStringList.Create;
  if(FileExists(FileName))then
    IDLst.LoadFromFile(FileName);
  FID:=FID+'_'+AppParam.DocFTPInfos[index].FFTPServer+'('
                         +IntToStr(AppParam.DocFTPInfos[index].FFTPPort)+')';
  if(IDLst.IndexOf(FID)=-1)then
    IDLst.Add(FID);
  IDLst.SaveToFile(FileName);
  if Assigned(IDLst)then
    IDLst.Free;

end;

function TAMainFrm.GetNeedUpLoadIDLstCount(index :integer): integer;
var
  IDLst : TStringlist;
  FileName : String;
  i : integer;
begin

  FileName:=FDataPath+'NeedUpLoadIDLst.data';
  result := 0;

  IDLst := TStringList.Create;
  if(FileExists(FileName))then
  begin
    IDLst.LoadFromFile(FileName);
    For i:=0 to IDLst.Count-1 do
    begin
      if(Pos('_'+AppParam.DocFTPInfos[index].FFTPServer+'('
                +IntToStr(AppParam.DocFTPInfos[index].FFTPPort)+')',
             IDLst.Strings[i])>0)then
      inc(result);
    end;
  end;
  if Assigned(IDLst)then
    IDLst.Free;

end;
procedure TAMainFrm.GetNeedUpLoadIDLst(index: integer;
  var UploadIDList: TStringList);
var
  FileName : String;
  StrLst : TStringList;
  i : Integer;
begin

  FileName:=FDataPath+'NeedUpLoadIDLst.data';
  UploadIDList.Clear;
  StrLst := TStringList.Create;
  if(FileExists(FileName))then
  begin
    StrLst.LoadFromFile(FileName);
    For i:=0 to StrLst.Count-1 do
    begin
      if(Pos('_'+AppParam.DocFTPInfos[index].FFTPServer+'('
                +IntToStr(AppParam.DocFTPInfos[index].FFTPPort)+')'
             ,StrLst.Strings[i])>0)Then
      begin
        //remove '_server(port)'
        StrLst.Strings[i]:=Copy(StrLst.Strings[i],1,Length(StrLst.Strings[i])-Length('_'+AppParam.DocFTPInfos[index].FFTPServer+'('
                +IntToStr(AppParam.DocFTPInfos[index].FFTPPort)+')'));
        UploadIDList.Add(StrLst.Strings[i]);
      end;
    end;
  end;

  if Assigned(StrLst)then
    StrLst.Free;
end;


//add by wangjinhua DatPackage Problem(20090413)
//CheckLocalInWeb将本地空间存在而对应的网上空间没有的%id%_DOCLST.dat文件上传到网上空间
function TAMainFrm.CheckLocalInWeb(var AFtp: TIdFtp;
  Index: Integer): boolean;                 //******Doc4.2-sun-20090922
var
  i,j:Integer;
  WebExistFileList:TStringList;
  tmpLocalFile,LocalDir,UploadFileName:String;
  NeedUpload,UploadFail:Boolean;
  BytesToTransfer:Integer;
  DocLstFile,vID,tmpFile:String;
  DocLstRec,IDLst:TStringList;
begin
  Result := false;
  LocalDir := DatPackageParam.Tr1DBDataPath[Index] + 'Document\StockDocIdxLst\';
  DocLstFile := LocalDir + 'StockDocIdxLst.dat';
  ShowMsg(runMsg,'开始准备补齐网上缺少的DOCLST.dat');
  if Not FileExists(DocLstFile) Then
  Begin
     ShowMsg(runMsg,'上传失败，缺少文件：' + DocLstFile);
     Exit;
  End;
try
Try
    IDLst := TStringList.Create;
    DocLstRec := TStringList.Create;
    DocLstRec.LoadFromFile(DocLstFile);
    For i:=0 to DocLstRec.Count-1 do
    Begin
      vID := DocLstRec.Strings[i];
      if (Pos('[',vID)>0) and
         (Pos(']',vID)>0) Then
      Begin
          ReplaceSubString('[','',vID);
          ReplaceSubString(']','',vID);
          IDLst.Add(Trim(vID) + '_DOCLST.dat');
      End;
    End;
    IDLst.Add(ExtractFileName(DocLstFile));
    //取得网上存在列表
    WebExistFileList:=TStringList.Create;
    AFtp.List(WebExistFileList,'*_DOCLST.dat',false);

    for i := 0 to IDLst.Count - 1 do
    begin
      UploadFileName := LocalDir + IDLst[i];
      if not FileExists(UploadFileName) then
        continue;
      NeedUpload := true;

      if UploadFileName = DocLstFile then
      begin
        if Aftp.Size('_' + ExtractFileName(DocLstFile))>=0 then
          NeedUpload := false;
      end
      else begin
        for j := 0 to WebExistFileList.Count - 1 do
        begin
          if WebExistFileList[j] = '_' + ExtractFileName(UploadFileName) then
          begin
            NeedUpload := false;
            break;
          end;
        end;
      end;

      if not NeedUpload then continue;
      CompressFile(GetCompressFile(UploadFileName),UploadFileName,clMax);
      UploadFileName := GetCompressFile(UploadFileName);
      UploadFail := true;
      for j:=0 to 3 do
      Begin
        ShowMsg(runMsg,'上传 ' + ExtractFileName(UploadFileName));
        if StopRunning Then Exit;
        AFtp.Put(UploadFileName,ExtractFileName(UploadFileName));
        BytesToTransfer := AFtp.Size(ExtractFileName(UploadFileName));
        if BytesToTransfer=GetFileSize(UploadFileName) Then
        Begin
           DeleteFile(UploadFileName);
           UploadFail := False;
           Break;
        End;
      End;
      if UploadFail Then
      Begin
       ShowMsg(runMsg,ExtractFileName(UploadFileName) + ' 上传错误.');
       //Exit;
      End;
    end;

    Result := True;
Except
   On E: Exception do
   Begin
      ShowMsg(runError,E.Message);
   End;
end;
Finally
   Try
     if Assigned(WebExistFileList) then
       FreeAndNiL(WebExistFileList);
   Except
   End;
   Try
     if Assigned(IDLst) then
       FreeAndNiL(IDLst);
   Except
   End;
   Try
     if Assigned(DocLstRec) then
       FreeAndNiL(DocLstRec);
   Except
   End;
   if StopRunning Then
   Begin
      ShowMsg(runMsg,'补齐网上缺少的DOCLST.dat中断');
   End Else
   Begin
      if Result Then
        ShowMsg(runMsg,'完成补齐网上缺少的DOCLST.dat')
      Else
      Begin
        ShowMsg(runMsg,'补齐网上缺少的DOCLST.dat失败');
      End;
   End;
end;

end;

function TAMainFrm.FilenameisinList(AfileList: TstringList;
  Afilename: String): boolean;                 //******Doc4.2-sun-20090922
Var
i:Integer;
begin
  Result:=False;
  if  AfileList=nil then
    Exit;
  For i:=0 to AfileList.Count-1 do
    if UpperCase(AfileList.Strings[i])=UpperCase(Afilename) then
      begin
        Result:=True;
        Break;
      end;
end;

function TAMainFrm.FtpDocData(Index: Integer): boolean;  //******Doc4.2-sun-20090922
Var
  Server,AUserName,Pass,uplDir : String;
  UsePass : Boolean;
  APort : Integer;
  FileLst : TIniFile;
  FileName : string;
  UploadFileName : String;
  UploadFile : TIniFile;
  Count,i,j : Integer;
  NeedUpLoad : Boolean;
  UploadFail : Boolean;
  AFtp : TIdFtp;

  //by charles 4
  WebExisttxtfilename,ShouldFtpLocalFileName,str:String;
  WebExistfilenamelst:TStringList;
  WebIsinLocal:boolean;
  DeleteNum:integer;
begin
Result := false;
  fileName := DatPackageParam.DBPath[Index] + HistoryDocPath+HistoryFileLst;
  if Not FileExists(FileName) Then
  Begin
     ShowMsg(runMsg,'档案不存在 ' + FileName);
     Exit;
  End;                                 

  FileLst := TIniFile.Create(FileName);
  UploadFile := TIniFile.Create(ExtractFilePath(FileName)+'Upload.log');
  ShowMsg(runMsg,'开始准备上传数据');
  AFtp := TIdFtp.Create(Self);

try
Try

    AFtp.Intercept := IdLogDebug1;
    //AFtp.InterceptEnabled := True;
    AFtp.OnConnected := IdFTP1.OnConnected;
    AFtp.OnDisconnected :=  IdFTP1.OnDisconnected;
    AFtp.OnWork := IdFTP1.OnWork;
    AFtp.OnWorkBegin := IdFTP1.OnWorkBegin;
    AFtp.OnWorkEnd := IdFtp1.OnWorkEnd;
    AFtp.OnStatus := IdFtp1.OnStatus;

    Server := DatPackageParam.FTPServer[Index];
    uplDir := DatPackageParam.FTPUploadDir[Index];
    AUserName := DatPackageParam.FTPUserName[Index];
    Pass     := DatPackageParam.FTPPassword[Index];
    APort    := DatPackageParam.FTPPort[Index];
    UsePass  := DatPackageParam.FTPPassive[Index];

    with AFtp do
    Begin

        ShowMsg(runMsg,'连结服务器 ' + Server);

        UserName := AUserName;
        Password := Pass;
        Host     := Server;
        Passive  := UsePass;
        Port     := APort;
        Connect;
        TransferType := ftBinary;
        ChangeDir(uplDir);
        Try
          AFtp.MakeDir('doc');
        Except
        End;
        AFtp.ChangeDir('doc');

        Count := FileLst.ReadInteger('FileList','Count',0);
        For i:=0 to Count-1 do
        Begin
             if StopRunning Then Exit;
             FileName   := FileLst.ReadString('FileList',IntTostr(i+1),'');
             NeedUpLoad := IntToBool(UploadFile.ReadInteger(FileName,'UpLoad',1));

             FileName := DatPackageParam.DBPath[Index] + HistoryDocPath + FileName;
             UploadFileName := ExtractFilePath(FileName)+'temp.tmp';
             DeleteFile(UploadFileName);
             if Not FileExists(FileName) Then Continue;

             if Not NeedUpLoad Then
             Begin
               if GetFileSize(FileName) <>
                    UploadFile.ReadFloat(ExtractFileName(FileName),'Size',0) Then
                  NeedUpLoad := True;
             End;

             if Not NeedUpLoad Then
             Begin
                if DateTimeToStr(FileDateToDateTime(FileAge(FileName))) <>
                      DateTimeToStr(UploadFile.ReadFloat(ExtractFileName(FileName),'DateTime',0)) Then
                   NeedUpLoad := True;
             End;

             if Not NeedUpLoad Then
               if -1=AFtp.Size(ExtractFileName(FileName)) Then
                  NeedUpLoad := True;

             if Not NeedUpLoad Then Continue;

             //-Upload File -----------------------------------
             CompressFile(UploadFileName,FileName,clMax);

             UploadFail := True;
             for j:=0 to 3 do
             Begin
               ShowMsg(runMsg,'上传 ' + ExtractFileName(FileName));
               if StopRunning Then Exit;
               AFtp.Put(UploadFileName,ExtractFileName(FileName));
               BytesToTransfer := AFtp.Size(ExtractFileName(FileName));
               if BytesToTransfer=GetFileSize(UploadFileName) Then
               Begin
                 UploadFail := False;
                 Break;
               End;
             End;
             if UploadFail Then
             Begin
               ShowMsg(runMsg,FileName+' 上传错误.');
               Exit;
             End Else
             Begin
                UploadFile.WriteInteger(ExtractFileName(FileName),'UpLoad',0);
                UploadFile.WriteInteger(ExtractFileName(FileName),'Size',GetFileSize(FileName));
                UploadFile.WriteFloat(ExtractFileName(FileName),'DateTime',
                                      FileDateToDateTime(FileAge(FileName)));
             End;
             //-------------------------------------------
        end;

        //-Upload File -----------------------------------
        FileName := FileLst.FileName;
        UploadFail := True;
        for j:=0 to 3 do
        Begin
           ShowMsg(runMsg,'上传 ' + ExtractFileName(FileName));
           if StopRunning Then Exit;
           AFtp.Put(FileName, ExtractFileName(FileName));
           BytesToTransfer := AFtp.Size(ExtractFileName(FileName));
           if BytesToTransfer=GetFileSize(FileName) Then
           Begin
               UploadFail := False;
               Break;
           End;
        End;
        if UploadFail Then
        Begin
           ShowMsg(runMsg,FileName+' 上传错误.');
           Exit;
        End;
        //---------------------------------

    End;
    //by charles 4 ******************************************************
    ShowMsg(runMsg,'开始整理网上TXT文件');
    WebExistfilenamelst:=TstringList.Create;
    Aftp.List(WebExistfilenamelst,'*.*',false);
    for i:=0 to WebExistfilenamelst.Count-1 do
      begin
        str:= WebExistfilenamelst.Strings[i];
        //ShowMsg(runMsg,Extractfileext(str));
        if not ((UpperCase(Extractfileext(str))='.TXT') ) then
          continue;
        WebIsinLocal:=false;
        count:=FileLst.ReadInteger('FileList','Count',0);
        for J:=1 to  count do
        begin
          WebExisttxtfilename:=FileLst.ReadString('FileList',inttostr(j),'');
          if str=WebExisttxtfilename then
          begin
            WebIsinLocal:=true;
            break;
          end
        end;

        if not WebIsinLocal then
          begin//删除网上多余的txt文件
            if Aftp.Size(extractfilename(str))>=0 then
            begin
               for DeleteNum:=0 to 3 do
               begin
                 try
                   ShowMsg(runMsg,'第'+inttostr(DeleteNum+1)+'次尝试清除 '+ ExtractFileName(str));
                   Aftp.Delete(str);
                   if Aftp.Size(extractfilename(str))<0 then
                   begin
                     ShowMsg(runMsg,'成功删除'+str);
                     break;
                   end;
                 except
                   continue;
                 end;
               end;//for DeleteNum:=0 to 3 do
             end;
          end;
      end;

    ShowMsg(runMsg,'整理网上TXT文件完毕');
    //by charles 4 ******************************************************
    Result := True;
Except
   On E: Exception do
   Begin
      ShowMsg(runError,E.Message);
   End;
end;
Finally
   FileLst.Free;
   UploadFile.Free;
   Try
     if AFtp.Connected Then
       AFtp.Disconnect;
   Except
   End;
   Try
     AFtp.Destroy;
   Except
   End;

   if StopRunning Then
   Begin
      ShowMsg(runMsg,'上传数据中断');
   End Else
   Begin
      if Result Then
        ShowMsg(runMsg,'完成上传数据')
      Else
      Begin
        ShowMsg(runMsg,'上传数据失败');
        ShowMsg(runMsg,'再一次尝试重新上传');
        Result := FtpDocData(Index);
      End;
   End;

end;


end;


//--
//modify by wangjinhua DatPackage Problem(20090413)
//增加函数CheckLocalInWeb:将本地空间存在而对应的网上空间没有的%id%_DOCLST.dat文件上传到网上空间
//优化其本身函数逻辑
function TAMainFrm.FtpIDDocListData(Index: Integer): boolean; //******Doc4.2-sun-20090922
Var
  FileLst : TIniFile;
  FileStrLst : TStringList;
  Str : string;
  UploadFileName : String;
  DeleteFileName : String;
  Count,i,j,number : Integer;
  NeedUpLoad : Boolean;
  UploadFail : Boolean;
  AFtp : TIdFtp;
  FileName:String;
  //by charles 20070327
  WebExistFileList:TStringList;
  //3.增加进行网上公告删除操作"之后的复核工作 by charles 20070327还需修改TDatPackage
  FileLst_Checkdoc : TIniFile;
  FileStrLst_Checkdoc : TStringList;
  FileName_CheckDoc:String;
  ShouldExistFileName:String;
  ShouldExistDocPath:String;
  WebExistfilenamelst:TStringList;
  WebExistfilename:string;
  WebIsinLocal:boolean;
  k:integer;
  _FileExit:boolean;
  DeleteNum:integer;
  _ClearFileExit:boolean;//add by wangjinhua DatPackage Problem(20090413)
begin
  Result := false;
  FileName := DatPackageParam.Tr1DBDataPath[Index]+
              'Document\StockDocIdxLst\ClearFtpDocLst.dat';
  //modify by wangjinhua DatPackage Problem(20090413)
  {if Not FileExists(FileName) Then
  Begin
     Result := True;
     Exit;
  End;}
  if Not FileExists(FileName) Then
    _ClearFileExit := false
  Else
    _ClearFileExit := true;
  //
  //by charles

  FileName_CheckDoc := DatPackageParam.Tr1DBDataPath[Index]+
                    'Document\StockDocIdxLst\CheckFtpDocLst.dat';
  if Not FileExists(FileName_CheckDoc) Then
    _FileExit := False
  else
    _FileExit := True;

  {FileLst := TIniFile.Create(FileName);
  FileStrLst := TStringList.Create();
  FileStrLst.LoadFromFile(FileName);
  ShowMsg(runMsg,'开始准备清除网上多余的rtf');
  AFtp := TIdFtp.Create(Self);
  //position moved by wangjinhua DatPackage Problem(20090413)}
  ShowMsg(runMsg,'开始准备清除网上多余的rtf');
try
Try
    AFtp := TIdFtp.Create(Self);
    AFtp.Intercept := IdLogDebug1;
    AFtp.OnConnected := IdFTP1.OnConnected;
    AFtp.OnDisconnected :=  IdFTP1.OnDisconnected;
    AFtp.OnWork := IdFTP1.OnWork;
    AFtp.OnWorkBegin := IdFTP1.OnWorkBegin;
    AFtp.OnWorkEnd := IdFtp1.OnWorkEnd;
    AFtp.OnStatus := IdFtp1.OnStatus;
    ShowMsg(runMsg,'连结服务器 ' + DatPackageParam.DailyDocFTPServer[Index]);
    AFtp.UserName := DatPackageParam.DailyDocFTPUserName[Index];
    AFtp.Password := DatPackageParam.DailyDocFTPPassword[Index];
    AFtp.Host     := DatPackageParam.DailyDocFTPServer[Index];
    AFtp.Passive  := DatPackageParam.DailyDocFTPPassive[Index];
    AFtp.Port     := DatPackageParam.DailyDocFTPPort[Index];
    AFtp.Connect;
    AFtp.TransferType := ftBinary;
    AFtp.ChangeDir(DatPackageParam.DailyDocFTPUploadDir[Index]);
    //AFtp.ChangeDir('document');
    //取得网上存在列表    //1. 修改发出delete需网上存在by charles 20070321
    if _ClearFileExit then  //add by wangjinhua DatPackage Problem(20090413) 将以前的部分逻辑块移动到里面来了
    begin
      FileLst := TIniFile.Create(FileName);
      FileStrLst := TStringList.Create();
      FileStrLst.LoadFromFile(FileName);
      WebExistFileList:=TstringList.Create;
      AFtp.List(WebExistFileList,'',false);
      For i:=0 to FileStrLst.Count-1 do
      Begin
               Str := FileStrLst.Strings[i];
               UploadFileName := '';
               if (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
               Begin
                    ReplaceSubString('[','',Str);
                    ReplaceSubString(']','',Str);
                    UploadFileName := ExtractFilePath(FileName)+Str+'_DOCLST.dat';
                    CompressFile(GetCompressFile(UploadFileName),UploadFileName,clMax);
                    UploadFileName := GetCompressFile(UploadFileName);
               End;
               DeleteFileName := '';
               if Pos('.rtf=1',Str)>0 Then
               Begin
                   ReplaceSubString('=1','',Str);
                   DeleteFileName := Str;
               End;
               if StopRunning Then Exit;

               //-Upload File -----------------------------------
               if Length(UploadFileName)>0 Then
               Begin
                 UploadFail := True;
                 for j:=0 to 3 do
                 Begin
                    ShowMsg(runMsg,'上传 ' + ExtractFileName(UploadFileName));
                    if StopRunning Then Exit;
                    AFtp.Put(UploadFileName,ExtractFileName(UploadFileName));
                    BytesToTransfer := AFtp.Size(ExtractFileName(UploadFileName));
                    if BytesToTransfer=GetFileSize(UploadFileName) Then
                    Begin
                       DeleteFile(UploadFileName);
                       UploadFail := False;
                       Break;
                    End;
                 End;
                 if UploadFail Then
                 Begin
                   ShowMsg(runMsg,UploadFileName+' 上传错误.');
                   Exit;
                 End;
               End;
               //-------------------------------------------
               {  //1. 修改发出delete需网上存在by charles 20070321
               //-Upload File -----------------------------------
               if Length(DeleteFileName)>0 Then
               Begin
                 //for j:=0 to 3 do
                 //Begin
                    //if StopRunning Then Exit;
                    //if AFtp.Size(ExtractFileName(DeleteFileName))>=0 Then
                    //Begin
                     ShowMsg(runMsg,'清除 ' + ExtractFileName(DeleteFileName));
                     Try
                        AFtp.Delete(ExtractFileName(DeleteFileName))
                     Except
                     End;
                    //End;
                 //End;
               End;
               //-------------------------------------------      }

               //-Upload File -----------------------------------
               if Length(DeleteFileName)>0 Then
               Begin//2.修改发出delete时四次循环 by charles 20070321
                 for number:=0 to 3 do
                 Begin
                    if StopRunning Then Exit;
                     //存在于网上空间
                     if FilenameisinList(WebExistFileList,DeleteFileName) then
                     begin
                       ShowMsg(runMsg,'第'+inttostr(number+1)+'次尝试清除 '+ ExtractFileName(DeleteFileName));
                       Try
                        AFtp.Delete(ExtractFileName(DeleteFileName)) ;
                        if  AFtp.Size(ExtractFileName(DeleteFileName))<0 then
                        begin
                          ShowMsg(runMsg,'清除 '+ExtractFileName(DeleteFileName)+'成功');
                          break;
                        end;
                       Except
                         ShowMsg(runMsg,inttostr(number+1)+'次清除 '+ ExtractFileName(DeleteFileName)+'失败');
                       End;
                     end else
                       ShowMsg(runMsg,DeleteFileName+'文件不在网上，故不发出Delete命令');
                 End;
               End;
               //-------------------------------------------
      end;
      if StopRunning Then Exit;
      DeleteFile(FileName);
    end;

   //by charles 2
   //*************************************************************
   ShowMsg(runMsg,'开始复核网上rtf文件');
   //&$&$&$&$&$&$&$&$&$&$&
   if _FileExit then
   begin
     FileLst_CheckDoc := TIniFile.Create(FileName_CheckDoc);
     FileStrLst_CheckDoc := TStringList.Create();
     FileStrLst_CheckDoc.LoadFromFile(FileName_CheckDoc);

     ShowMsg(runMsg,'开始复核本地rtf文件是否全部上传');
     ShouldExistDocPath:='';
     for i:=0 to FileStrLst_CheckDoc.Count-1 do //检查check.dat中的文件
     begin
       str:=FileStrLst_CheckDoc.Strings[i];
       if (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
       begin
         ReplaceSubString('[','',Str);
         ReplaceSubString(']','',Str);
         ShouldExistDocPath:=DatPackageParam.Tr1DBDataPath[Index]+
                  'Document\'+str+'\';
         continue;
       end;
       ShouldExistFileName:='';
       if Pos('.rtf=1',Str)>0 Then
       Begin
         ReplaceSubString('=1','',Str);
         ShouldExistFileName := ShouldExistDocPath+Str;
       End;
       if StopRunning Then Exit;
       if  length(ShouldExistFileName)>0 then
       begin
         //判断网上是否存在
         if Aftp.Size(ExtractFileName(ShouldExistFileName))<0 then
         begin
           //重新上传
           UploadFail := True;
           for j:=0 to 3 do
           Begin
              if StopRunning Then Exit;
              AFtp.Put(ChangeFileExt(ShouldExistFileName,'.txt'),LowerCase(ExtractFileName(ShouldExistFileName)));
              BytesToTransfer := AFtp.Size(ExtractFileName(ShouldExistFileName));
              if BytesToTransfer=GetFileSize(ChangeFileExt(ShouldExistFileName,'.txt')) Then
              Begin
                 UploadFail := False;
                 Break;
              End;
           End;
           if UploadFail Then
           Begin
             ShowMsg(runMsg,ExtractFileName(ShouldExistFileName)+' 重新上传错误.');
             //Exit ;
           End
           else begin
             ShowMsg(runMsg,ExtractFileName(ShouldExistFileName)+' 重新上传成功.');
            // Exit ;
           end;
         end else
           ShowMsg(runMsg,ExtractFileName(ShouldExistFileName)+' 已经存在于网上.');
       end; //if length(ShouldExistFileName)>0 then
     end; //for i:=0 to FileStrLst_CheckDoc.Count-1 do
     ShowMsg(runMsg,'复核本地rtf文件完成');


     //by charles 2检查网上存在得文件名
     ShowMsg(runMsg,'开始复核网上是否存在多余rtf文件');
     WebExistFileNamelst:=TstringList.Create;
     Aftp.List(WebExistFileNamelst,'*.rtf',false);

     for j:=0 to WebExistFileNamelst.Count-1 do
     begin
       WebExistFileName:=WebExistFileNamelst.Strings[j];
       WebIsinLocal:=false;
       for k:=0 to FileStrLst_CheckDoc.Count-1 do  //循环检查是否存在本地
       begin
         str:=FileStrLst_CheckDoc.Strings[k];
         if ((pos('[',str)>0) and (pos(']',str)>0)) then
           continue;
         if pos('=1',str)>0 then
         begin
           ReplaceSubString('=1','',str);
           if WebExistFileName=str then
           begin
             WebIsinLocal:=true;
             break;
           end;
         end;
       end; //for k:=0 to FileStrLst_CheckDoc.Count-1 do

       if not WebIsinLocal then
       begin//删除
         ShowMsg(runMsg,'发现网上存在多余的文件'+WebExistFileName);
         if Aftp.Size(extractfilename(WebExistFileName))>=0 then
         begin
           for DeleteNum:=0 to 3 do
           begin
             ShowMsg(runMsg,'第'+inttostr(DeleteNum+1)+'次尝试清除 '+ ExtractFileName(WebExistFileName));
             Aftp.Delete(WebExistFileName);
             if Aftp.Size(extractfilename(WebExistFileName))<0 then
             begin
               ShowMsg(runMsg,'成功删除'+WebExistFileName);
               break;
             end;
           end;
         end;
       end; //if not WebIsinLocal then
     end; //for j:=0 to WebExistFileNamelst.Count-1 do
       ShowMsg(runMsg,'网上是否存在多余rtf文件复核完毕');
     end else
       ShowMsg(runMsg,'本轮网上没有需复核文件');
     //&$&$&$&$&$&$&$&$&$&$&
     ShowMsg(runMsg,'完成复核rtf文件工作');
     DeleteFile(FileName_CheckDoc);
   //*************************************************************
   CheckLocalInWeb(Aftp,Index);//add by wangjinhua DatPackage Problem(20090413)
   Result := True;
Except
   On E: Exception do
   Begin
      ShowMsg(runError,E.Message);
   End;
end;
Finally
   //by charles 20070327
   //modify by wangjinhua DatPackage Problem(20090413)
   {WebExistFileList.Free;
   FileLst.Free;
   FileStrLst.Free; }
   Try
     if Assigned(WebExistFileList) Then
       FreeAndNil(WebExistFileList);
   Except
   End;
   Try
     if Assigned(FileLst) Then
       FreeAndNil(FileLst);
   Except
   End;
   Try
     if Assigned(FileStrLst) Then
       FreeAndNil(FileStrLst);
   Except
   End;
   //--
   Try
     if AFtp.Connected Then
       AFtp.Disconnect;
   Except
   End;
   Try
     AFtp.Destroy;
   Except
   End;
   if StopRunning Then
   Begin
      ShowMsg(runMsg,'清除网上多余的rtf中断');
   End Else
   Begin
      if Result Then
        ShowMsg(runMsg,'完成清除网上多余的rtf')
      Else
      Begin
        ShowMsg(runMsg,'清除网上多余的rtf失败');
        FtpIDDocListData(Index);
      End;
   End;
end;

end;

procedure TAMainFrm.ShowMsg(const RunStatus: TRunStatus;   //******Doc4.2-sun-20090922
  const Msg: String);
begin
  if DisplayMemo <> nil  then
     DisplayMemo.AddMsg(RunStatus,Msg);
end;

{ TDisplayMemo }

procedure TDisplayMemo.AddMsg1(const Msg: String);
begin
  if(FMemo1.Count>100)then
    FMemo1.Clear;
  FMemo1.ItemIndex := FMemo1.Items.Add(Msg);
  SaveToLogFile(Msg);
end;

procedure TDisplayMemo.AddMsg2(const Msg: String);
begin
  if(FMemo2.Count>100)then
    FMemo2.Clear;
  FMemo2.ItemIndex := FMemo2.Items.Add(Msg);
end;

procedure TDisplayMemo.ClearMsg1;
begin
   FMemo1.Clear;
end;

procedure TDisplayMemo.ClearMsg2;
begin
   FMemo2.Clear;
end;

constructor TDisplayMemo.Create(AMemo1, AMemo2: TListBox);
begin
    FMemo1 := AMemo1;
    FMemo2 := AMemo2;
end;

destructor TDisplayMemo.Destroy;
begin
  //inherited;
  ClearMsg1;
  ClearMsg2;
end;

procedure TDisplayMemo.SaveToLogFile(const Msg: String);
Var
  vMsg,FileName : String;
  FLogFile :TextFile;
begin


  vMsg := Msg;

  FileName := ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\Doc_Ftp\'+
              FormatDateTime('yyyymmdd',Date)+'.log';
  Mkdir_Directory(ExtractFilePath(FileName));

  AssignFile(FLogFile,FileName);
  FileMode := 2;
  if FileExists(FileName) Then
      Append(FLogFile)
  Else
      ReWrite(FLogFile);
  Writeln(FLogFile,'['+FormatDateTime('hh:mm:ss',Now)+']='+ vMsg);

  CloseFile(FLogFile);

  if (ClearDate<>Date)then
  begin
    ClearSysLog;
    ClearDate:=Date;
  end;

end;
procedure TDisplayMemo.ClearSysLog;
var
  LogFileLst : _CStrLst;
  i:integer;
begin
try

  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\Doc_Ftp\',
                 '.log',LogFileLst,false);
  For i:=0 To High(LogFileLst)Do
  Begin
    if(DaysBetween(StrToDate(Copy(ExtractFileName(LogFileLst[i]),1,4)+DateSeparator
             +Copy(ExtractFileName(LogFileLst[i]),5,2)+DateSeparator
             +Copy(ExtractFileName(LogFileLst[i]),7,2)),Date)>30)then
    DeleteFile(LogFileLst[i]);
  End;

except
end;
end;

procedure TDisplayMemo.AddMsg(const RunStatus: TRunStatus;
  const Msg: String);
Var
  vMsg : String;
begin
   if FMsg=Msg Then Exit;

   FMsg := Msg;
   Case RunStatus of
        runError   : vMsg := '[Error]  '+Msg;
        runWarning : vMsg := '[Warning]  '+Msg;
        runMsg     : vMsg := '[Message]  '+Msg;
   End;
   vMsg := '['+FormatDateTime('yy-mm-dd hh:mm:ss',Now)+'] '+vMsg;

   FMemo1.ItemIndex := FMemo1.Items.Add(vMsg);

   if FMemo1.Count>100 Then
      FMemo1.Clear;
   SaveToLogFile(vMsg);
end;

procedure TAMainFrm.Act_StopServerExecute(Sender: TObject);
begin
  StopRunning := True;
end;

procedure TAMainFrm.IdFTP1Status(axSender: TObject;
  const axStatus: TIdStatus; const asStatusText: String);
begin
    Application.ProcessMessages;
end;

procedure TAMainFrm.IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
Var
  S: String;
  TotalTime: TDateTime;
  H, M, Sec, MS: Word;
  DLTime: Double;
begin

  Application.ProcessMessages;
  TotalTime :=  Now - STime;
  DecodeTime(TotalTime, H, M, Sec, MS);
  Sec := Sec + M * 60 + H * 3600;
  DLTime := Sec + MS / 1000;
  if DLTime > 0 then
  AverageSpeed := {(AverageSpeed + }(AWorkCount / 1024) / DLTime{) / 2};

  S := FormatFloat('0.00 KB/s', AverageSpeed);
  case AWorkMode of
  wmRead: SBar.Panels[2].Text := 'Download speed ' + S;
  wmWrite: SBar.Panels[2].Text := 'Uploade speed ' + S;
  end;

  if AbortTransfer then IdFTP1.Abort;

  PBar.Position := AWorkCount;
  AbortTransfer := false;
end;

procedure TAMainFrm.IdFTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
Begin
  Application.ProcessMessages;

  TransferrignData := true;
  AbortTransfer := false;
  STime := Now;
  if AWorkCountMax > 0 then PBar.Max := AWorkCountMax
  else PBar.Max := BytesToTransfer;
  AverageSpeed := 0;
end;

procedure TAMainFrm.IdFTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  Application.ProcessMessages;

  SBar.Panels[2].Text := 'Transfer complete.';
  BytesToTransfer := 0;
  TransferrignData := false;
  PBar.Position := 0;
  AverageSpeed := 0;

end;

procedure TAMainFrm.IdLogDebug1LogItem(ASender: TComponent;
  var AText: String);
begin
  Application.ProcessMessages;
  DisplayMemo.AddMsg2(AText);

end;

procedure TAMainFrm.Timer_StartTimer(Sender: TObject);
var k,i,ftpcount : integer;  //穝糤ftpcount
  FileLst : _CStrLst; ADoc : TUploadDoc;
  con,needupload,UPLSuccess_DataDoc,UPLSuccess_DocLst,IsSuccess_CBData : boolean;//穝糤IsSuccess_CBData

  sUploadWorkDir,sFile:string; DtTemp:TDate;
  UploadFiles :_cStrLst; bDealWithLog:boolean;
begin
Try
   if Not StopRunning Then
   Begin
     if FNowIsDowning Then
        Exit;
     FNowIsDowning := True;
     Timer_Start.Enabled := False;
     UPLSuccess_DocLst := False;
     UPLSuccess_DataDoc := False;

     //肚DOC戈
     //-------------------------------------------------------------------------
     needupload :=false;
     FOR k:=0 TO AppParam.DocFTPCount-1 DO
       if (GetNeedUpLoadIDLstCount(k)>0) then
         needupload :=true;
     if(High(DocDataMgr.GetUploadTmpFile)>-1) or needupload then
     begin
       DisplayMemo.AddMsg1(AppParam.ConvertString('开始准备上传DOC数据'));
       FOR k:=0 TO AppParam.DocFTPCount-1 DO
       BEGIN
         //耞赣FTPserver琌タ絋肚筁,璝琌玥铬
         SetLength(FileLst,0);
         FileLst := DocDataMgr.GetUploadTmpFile;
         Con := false;
         For i:=0 to High(FileLst) do
         Begin
           if(HaveAllUpload(FileLst[i]))then
           begin
             DeleteFile(FileLst[i]);
             Continue;
           end;  
           ADoc := DocDataMgr.GetUploadADoc(FileLst[i],AppParam.DocFTPInfos[k].FFTPServer+':'
                                             +IntToStr(AppParam.DocFTPInfos[k].FFTPPort));
           if(Adoc.FTP_Note<>1)then
           begin
             Con:=true;
             break;
           end;
         end;
         if not Con and (GetNeedUpLoadIDLstCount(k)=0) then
         begin
           continue
         end;
         //﹍てFTP把计 硈钡狝叭竟
         DisplayMemo.AddMsg1(AppParam.ConvertString('连接服务器'
                              +AppParam.DocFTPInfos[k].FFTPServer+':'
                              +IntToStr(AppParam.DocFTPInfos[k].FFTPPort)));
         TRY
         with IdFTP1 do
         Begin
          if Connected Then
            Disconnect;
          UserName := AppParam.DocFTPInfos[k].FFTPUserName;
          Password := AppParam.DocFTPInfos[k].FFTPPassword;
          Host     := AppParam.DocFTPInfos[k].FFTPServer;
          Passive  := AppParam.DocFTPInfos[k].FFTPPassive;
          Port     := AppParam.DocFTPInfos[k].FFTPPort;
          Connect;
          TransferType := ftBinary;
          ChangeDir(AppParam.DocFTPInfos[k].FFTPUploadDir);
         End;
         Except
           on E:Exception do
           begin
             DisplayMemo.AddMsg1(AppParam.ConvertString('服务器')
                                 +AppParam.DocFTPInfos[k].FFTPServer+':'
                                 +IntToStr(AppParam.DocFTPInfos[k].FFTPPort)
                                 +AppParam.ConvertString('连接失败'));
             DisplayMemo.AddMsg2(E.Message);
             SendDocMonitorWarningMsg(AppParam.ConvertString('服务器连接失败')+'('+E.Message+')$E009');//--DOC4.0.0—N001 huangcq090407 add
             continue;
           end;
         End;
         //************************************************************##

         //肚そrtfゅン
         Try
           UPLSuccess_DataDoc := FtpDataDoc(k);
         Except
           On E: Exception do
             UPLSuccess_DataDoc := false;
         End;

         //肚そ睲虫
         Try
           UPLSuccess_DocLst  := FtpDocLstToServer(k);
         Except
           On E: Exception do
             UPLSuccess_DocLst := false;
         End;

         if UPLSuccess_DataDoc and UPLSuccess_DocLst Then
           DisplayMemo.AddMsg1(AppParam.ConvertString('服务器')
                               +AppParam.DocFTPInfos[k].FFTPServer+':'
                               +IntToStr(AppParam.DocFTPInfos[k].FFTPPort)
                               +AppParam.ConvertString(' 上传成功'))
         else
         if UPLSuccess_DataDoc and not UPLSuccess_DocLst Then
           DisplayMemo.AddMsg1(AppParam.ConvertString('服务器')
                               +AppParam.DocFTPInfos[k].FFTPServer+':'
                               +IntToStr(AppParam.DocFTPInfos[k].FFTPPort)
                               +AppParam.ConvertString(' 公告清单上传失败'))
         else
         if not UPLSuccess_DataDoc and UPLSuccess_DocLst Then
           DisplayMemo.AddMsg1(AppParam.ConvertString('服务器')
                               +AppParam.DocFTPInfos[k].FFTPServer+':'
                               +IntToStr(AppParam.DocFTPInfos[k].FFTPPort)
                               +AppParam.ConvertString(' 公告rtf文件上传失败'))
         else
         if not UPLSuccess_DataDoc and not UPLSuccess_DocLst Then
           DisplayMemo.AddMsg1(AppParam.ConvertString('服务器')
                               +AppParam.DocFTPInfos[k].FFTPServer+':'
                               +IntToStr(AppParam.DocFTPInfos[k].FFTPPort)
                               +AppParam.ConvertString(' 公告rtf文件与公告清单均上传失败'));

       END;
       DisplayMemo.AddMsg1(AppParam.ConvertString('一轮DOC上传结束'));
     end;
     //-------------------------------------------------------------------------

     //肚CB戈
     if ftpcount<AppParam.CBFTPCount then
     begin
       //肚CB戈
       Try
         IsSuccess_CBData:=FtpDataCBTxt2(k);      //睰肚ま
         inc(ftpcount);
         //FtpDataCBTxt;   //DocFtp2.0.0.0-Doc2.3.0.0-惠―5-libing-2007/09/20
       Except
         On E: Exception do
            IsSuccess_CBData:=false;
       End;
     end;

     //==============******Doc4.2-sun-20090922==================
     if UpLoadDocMark then
     begin
       UpLoadDocMark := false;
       for i:=0 to DatPackageParam.DataSourceCount-1 do
       Begin
          FtpDocData(i);  //肚DatapackageゴDOC
          FtpIDDocListData(i); //確呼丁.Rtfゅン
       end;
     end;
     //=============================================

      if TimeOutRateDatTickCount then
      begin
        sUploadWorkDir:=ExtractFilePath(ParamStr(0))+'Data\RateDatUpload\';
        FolderAllFiles(sUploadWorkDir,'.upload',UploadFiles,False);
        if Length(UploadFiles)>0 then
        begin
          for i:=0 to High(UploadFiles) do
          begin
            if FileExists(UploadFiles[i]) then
            begin
              sFile:=ExtractFileName(UploadFiles[i]);
              sFile:=ChangeFileExt(sFile,'');
              dtTemp:=DateStr8ToDate(sFile);
              if dtTemp<>0 then
              begin
                ftpcount:=FtpRateDat(dtTemp,@WizDayConvDatRunStatus1);
                if ftpcount=1 then
                begin
                  bDealWithLog:=DealWithUploadLog(UploadFiles[i],'irrate');
                  if bDealWithLog then
                  begin
                    DisplayMemo.AddMsg1(AppParam.ConvertString('更新上传log记录成功'));
                    if FileExists(UploadFiles[i])  then
                      DeleteFile(UploadFiles[i]);
                  end
                  else 
                    DisplayMemo.AddMsg1(AppParam.ConvertString('更新上传log记录失败'));
                end;
              end;
            end;
          end;
        end;
        RefreshRateDatTickCount;
      end;

      if TimeOutRateDatTickCount2 then
      begin
        FtpSwapDat(@WizDayConvDatRunStatus1);
        RefreshRateDatTickCount2;
      end;

     FNowIsDowning := False;
   end else
      exit;
Finally
   FNowIsDowning := False;
   if(idFTP1.Connected)then
     idFTP1.Disconnect;
   if StopRunning Then
   Begin
      DisplayMemo.AddMsg1(AppParam.ConvertString('上传数据中断'));
      //SendToSoundServer('GET_DOC_ERROR',AppParam.ConvertString('上传数据中断'),svrMsgError);//--DOC4.0.0—N001 huangcq090407 del
      Stop;
   End
   Else
      Timer_Start.Enabled := True;
End;
end;

procedure TAMainFrm.FormCreate(Sender: TObject);
begin
   Start;
end;

procedure TAMainFrm.Act_StartServerExecute(Sender: TObject);
begin
  Start;
end;

procedure TAMainFrm.CoolTrayIconDblClick(Sender: TObject);
begin
  Show;
end;

procedure TAMainFrm.Mnu_UploadDocLstClick(Sender: TObject);
begin

   if FNowIsDowning Then
   Begin
      ShowMessage(AppParam.ConvertString('目前正在上传.请稍后处理'));
      Exit;
   End;

   FNowIsDowning := True;
   Mnu_UploadDocLst.Enabled := False;
   FtpDataDocLst;
   Mnu_UploadDocLst.Enabled := True;
   FNowIsDowning := False;

end;

procedure TAMainFrm.IdLogDebug1Receive(ASender: TIdConnectionIntercept;
  AStream: TStream);
Var
  s : string;
begin

  Application.ProcessMessages;
Try
try
  s := GetStreamString(AStream);
  ReplaceSubString(#13#10,'',s);
  DisplayMemo.AddMsg2(s);
Except
End;
Finally
end;

end;

procedure TAMainFrm.IdLogDebug1Send(ASender: TIdConnectionIntercept;
  AStream: TStream);
Var
  s : string;
begin

  Application.ProcessMessages;
Try
try
  s := GetStreamString(AStream);
  ReplaceSubString(#13#10,'',s);
  DisplayMemo.AddMsg2(s);
Except
End;
Finally
end;

end;

procedure TAMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {if FNowIsDowning or NowIsRunningServer Then
    ShowMessage(AppParam.ConvertString('服务正在运行，请先停止！'))
  else  }
  //close;
    Halt;
end;

procedure TAMainFrm.Mnu_ExitClick(Sender: TObject);
begin
  {if FNowIsDowning or NowIsRunningServer Then
    ShowMessage(AppParam.ConvertString('服务正在运行，请先停止！'))
  else  }
  //close;
    Halt;
end;

//--DOC4.0.0—N001 huangcq090407 add----------->
procedure TAMainFrm.SendDocMonitorStatusMsg;
begin

  if ASocketClientFrm<>nil Then
  Begin
     ASocketClientFrm.SendText('SendTo=DocMonitor;'+
                                'Message=Doc_03;'
                                );
                                //'UploadUplData='+IntToStr(BoolToInt(FFinishCloseMarket))+';'

  End;
end;

function TAMainFrm.SendDocMonitorWarningMsg(const Str: String): boolean;
var AStrAllowed:String;
begin
  if ASocketClientFrm<>nil Then
    Begin
      //SocketClient sendtext format is '#%B%SocketName='+sendvalue+';%E%#' ,thus,must
      //replace the substring of '#' in the sendvalue
      AStrAllowed:=Str;
      ReplaceSubString('#','',AStrAllowed);
      Result := ASocketClientFrm.SendText('SendTo=DocMonitor;'+
                                        'MsgWarning='+AStrAllowed);
    End;
end;

procedure TAMainFrm.Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);
Var
  WMString: PWMReceiveString;
  Value,Value2 : String;
begin
  Try
    WMString :=  ObjWM;
    if WMString.WMType='DOCPACKAGE' Then  //RCCPackage
    Begin
     Value2 := GetReceiveStrColumnValue('Broadcast',WMString.WMReceiveString);
     if Length(Value2)>0 Then
     Begin
        if Value2='CloseSystem' Then
        begin
          StopRunning := True;
          application.Terminate;
        end;
     End;
     //===******Doc4.2-sun-20090922============================================
      Value2 := GetReceiveStrColumnValue('MsgWarning',WMString.WMReceiveString);
      if Value2='DOCDATAPACKAGE OVER' then
           UpLoadDocMark := True;//打包上传

      //=================================================================
    End;

  except
  end;
end;

procedure TAMainFrm.TimerSendLiveToDocMonitorTimer(Sender: TObject);
begin
  if TimerSendLiveToDocMonitor.Tag=1 Then
     exit;
  TimerSendLiveToDocMonitor.Tag :=1;
  Try
    if ASocketClientFrm<>nil Then
       SendDocMonitorStatusMsg(); //向DocMonitor发送'还活着..'

  Finally
    TimerSendLiveToDocMonitor.Tag :=0;
  end;
end;
//<---------DOC4.0.0—N001 huangcq090407 add-------


procedure TAMainFrm.RefreshRateDatTickCount;
begin
  FRateDatTickCount:=GetTickCount;
end;

procedure TAMainFrm.RefreshRateDatTickCount2;
begin
  FRateDatTickCount2:=GetTickCount;
end;

function TAMainFrm.TimeOutRateDatTickCount:boolean;
begin
  result:=
   (FRateDatTickCount=0) or
   ( ((GetTickCount-FRateDatTickCount)/(1000*60) )>=AppParam.RateDatInterval );
end;

function TAMainFrm.TimeOutRateDatTickCount2:boolean;
begin
  result:=
   (FRateDatTickCount2=0) or
   ( ((GetTickCount-FRateDatTickCount2)/(1000*60) )>=AppParam.RateDatInterval2 );
end;

function TAMainFrm.FtpDirectoryExists(ADir: string): Boolean; 
begin 
Result := True;
try
IdFtp1.ChangeDir(ADir);
except
Result := False; 
end;
end;

function TAMainFrm.ConnectFtp(AUserName,APassword,AHost,AChangeDir:ShortString;APort:integer;APassive:Boolean):Boolean;
begin
  Result:=false;
  //初始化FTP参数 连接服务器
  DisplayMemo.AddMsg1(AppParam.ConvertString('连接服务器'
                      +AHost+':'
                      +IntToStr(APort)));
  TRY
    with IdFTP1 do
    Begin
      if Connected Then
        Disconnect;
      UserName := AUserName;
      Password := APassword;
      Host     := AHost;
      Passive  := APassive;
      Port     := APort;
      Connect;
      TransferType := ftBinary;
      ChangeDir(AChangeDir);
      Result:=Connected;
    End;
  Except
   on E:Exception do
   begin
     DisplayMemo.AddMsg1(AppParam.ConvertString('服务器')
                         +AHost+':'
                         +IntToStr(APort)
                         +AppParam.ConvertString('连接失败'));
     DisplayMemo.AddMsg2(E.Message);
     //SendToSoundServer('GET_DOC_ERROR',E.Message,svrMsgError);//--DOC4.0.0—N001 huangcq090407 del
     SendDocMonitorWarningMsg(AppParam.ConvertString('服务器连接失败')+'('+E.Message+')$E009');//--DOC4.0.0—N001 huangcq090407 add
   end;
  End;
end;

function TAMainFrm.DealWithUploadLog(aWorkFile,aTag:string):boolean;
var sUploadLogFile,sSec,sTemp,sSvrName,sDocMgrPath:string; aDt:TDateTime; t1,t2:integer;
  fini:TIniFile;
begin
  result:=false;
  if not FileExists(aWorkFile) then
    Exit;
  sDocMgrPath:=ExtractFilePath(ParamStr(0));
  aDt := FileDateToDateTime(FileAge(aWorkFile));
  sUploadLogFile:=sDocMgrPath+'data\DwnDocLog\uploadCBData\'+FormatDateTime('yymmdd',aDt)+'.log';
  if not FileExists(sUploadLogFile) then
    Exit;
  sSec:=aTag+ExtractFileName(aWorkFile)+'@'+IntToStr(FileAge(aWorkFile));
  fini:=TIniFile.create(sUploadLogFile);
  try
    sTemp:=fini.ReadString(sSec,'FileNameEN','');
    if sTemp='' then
      exit;
    for t1:=1 to AppParam.RateDatFTPCount do
    begin
      sSvrName:=AppParam.RateDatFTPInfos[t1-1].FFTPServer;
      if Length(sSvrName)<=0 then exit;
      sSvrName:=sSvrName+';'+AppParam.RateDatFTPInfos[t1-1].FFTPUploadDir;
      fini.WriteString(sSec,'DocFtp_'+IntToStr(t1),FormatDateTime('hh:mm:ss',Now)+#9+sSvrName);
    end;
    fini.WriteInteger(sSec,'CBFtpServerCount',AppParam.RateDatFTPCount);
  finally
    FreeAndNil(fini);
  end;
  result:=true;
end;

function TAMainFrm.FtpRateDat(ADate:TDate;Proc:TFarProc=nil):integer;
Var
  FileLst : _CStrLst;
  FileName ,FTPFileName: string;
  i,j,k,n,iOKCount : Integer;    //k狝叭竟絪腹
  IsTransSuccess,needupload,uploadsuccess:Boolean;
  sFile,sTemp:string;  b:boolean;


  Function  PackageFile(Tr1Path:ShortString;ADate:TDate;Proc:TFarProc=nil):Boolean;
  var i : Integer;
    PackFile,sDt8,aFile3,sTFile,sFile:string;
    MyDeCodeF:DeCodeF;
    f : File of DeCodeF;
    BCNameTblFile : File of TBCNameTblRec;
    AryBCNameTbl : array of TBCNameTblRec;
    ReMain : integer;

    function CPF(APackFile,AExt:string):string;
    begin
      result:=ExtractFilePath(APackFile)+ ChangeFileExt(ExtractFileName(APackFile),AExt);
    end;
  Begin
     Result   := False;
  Try
  Try
     //StatusProc := Proc;
     DoPathSep(Tr1Path);
     Mkdir_Directory(Tr1Path);

     CB_Step('ゴ溃罽计沮...',Proc);
     For i:=0 to High(MyDeCodeF.FileNames) do
     Begin
        MyDeCodeF.FileNames[i] := '';
        MyDeCodeF.FileSize [i] := 0;
     End;
     if StopRunning then exit;
     MyDeCodeF.FileCount := 0;
     PackFile := Tr1Path+ '_'+FormatDateTime('yyyymmdd',ADate)+'.dec';
     sDt8:=FormatDateTime('yyyymmdd',aDate);

     sFile:=AppParam.RateDatPath+_RateDateFile;
     CB_Step(Format('溃罽%s(%s) ...',[_RateDateFile,sDt8]),Proc);
     if not PackRateDate(AppParam.RateDatPath,Tr1Path, ADate,@WizDayConvDatRunStatus1) then
     begin
       DisplayMemo.AddMsg1(AppParam.TwConvertStr('PackRateDate ア毖'));
       exit;
     end;
     DeCodeFile(Tr1Path+'_'+_RateDateFile,PackFile,MyDeCodeF);

     CB_Step(Format('溃罽%s(%s) ...',[_BCNameTblFile,sDt8]),Proc);
     if not PackBCNameTbl(AppParam.RateDatPath,Tr1Path, ADate,@WizDayConvDatRunStatus1) then
     begin
       DisplayMemo.AddMsg1(AppParam.TwConvertStr('PackBCNameTbl ア毖'));
       exit;
     end;
     DeCodeFile(Tr1Path+'_'+_BCNameTblFile,PackFile,MyDeCodeF);
     //if FileExists(Tr1Path+'_'+_BCNameTblFile) then DeleteFile(Tr1Path+'_'+_BCNameTblFile);
     CB_Step(Format('溃罽%s(%s) ...',[_TYCFile,sDt8]),Proc);
     if not PackTYC(AppParam.RateDatPath,Tr1Path, ADate,@WizDayConvDatRunStatus1) then
     begin
       DisplayMemo.AddMsg1(AppParam.TwConvertStr('PackTYC ア毖'));
       exit;
     end;
     DeCodeFile(Tr1Path+'_'+_TYCFile,PackFile,MyDeCodeF);

     CB_Step(Format('溃罽%s(%s) ...',[_0RateFile,sDt8]),Proc);
     if not Pack0Rate(AppParam.RateDatPath,Tr1Path, ADate,@WizDayConvDatRunStatus1) then
     begin
       DisplayMemo.AddMsg1(AppParam.TwConvertStr('Pack0Rate e”u'));
       exit;
     end;
     DeCodeFile(Tr1Path+'_'+_0RateFile,PackFile,MyDeCodeF);

     //if FileExists(Tr1Path+'_'+_TYCFile) then DeleteFile(Tr1Path+'_'+_TYCFile);
     CB_Step(Format('溃罽%s(%s) ...',[_TSubIndexFile,sDt8]),Proc);
     if not PackSubIndex(AppParam.RateDatPath,Tr1Path, ADate,@WizDayConvDatRunStatus1) then
     begin
       DisplayMemo.AddMsg1(AppParam.TwConvertStr('PackSubIndex ア毖'));
       exit;
     end;
     DeCodeFile(Tr1Path+'_'+_TSubIndexFile,PackFile,MyDeCodeF);
     //if FileExists(Tr1Path+'_'+_TSubIndexFile) then DeleteFile(Tr1Path+'_'+_TSubIndexFile);
     CB_Step(Format('溃罽%s(%s) ...',[_CBRefRateFile,sDt8]),Proc);
     if not PackCBRefRate(AppParam.RateDatPath,Tr1Path, ADate,@WizDayConvDatRunStatus1) then
     begin
       DisplayMemo.AddMsg1(AppParam.TwConvertStr('PackCBRefRate ア毖'));
       exit;
     end;
     DeCodeFile(Tr1Path+'_'+_CBRefRateFile,PackFile,MyDeCodeF);
     //if FileExists(Tr1Path+'_'+_CBRefRateFile) then DeleteFile(Tr1Path+'_'+_CBRefRateFile);
     if StopRunning then exit;
     if not PackIRID(AppParam.RateDatPath,Tr1Path, ADate,@WizDayConvDatRunStatus1) then
     begin
       DisplayMemo.AddMsg1(AppParam.TwConvertStr('PackIRID ア毖'));
       exit;
     end;
     if StopRunning then exit;
     aFile3 := AppParam.RateDatPath+_BCNameTblFile;
     if FileExists(aFile3) Then
     begin
        AssignFile(BCNameTblFile,aFile3);
        try
          FileMode := 2;
          ReSet(BCNameTblFile);
          ReMain := FileSize(BCNameTblFile);
          if Remain=0 Then Exit;
          SetLength(AryBCNameTbl,Remain);
          BlockRead(BCNameTblFile,AryBCNameTbl[0],ReMain);
        finally
          CloseFile(BCNameTblFile);
        end;
        for i:=0 to High(AryBCNameTbl) do
        begin
          if StopRunning then exit;
          CB_Step(Format('溃罽そ杜%s(%s)  (%d/%d)...',
              [AryBCNameTbl[i].BondCode,sDt8,i+1,Remain]),Proc);
          sTFile:=Format('%s_%s.dat',[Tr1Path,AryBCNameTbl[i].BondCode]);
          DeCodeFile(sTFile,PackFile,MyDeCodeF);
        end;
     end;
     if StopRunning then exit;
     For i:=0 to High(MyDeCodeF.FileNames) do
     Begin
       if StopRunning then exit;
        if Length(MyDeCodeF.FileNames[i])=0 Then Break;
        if FileExists(Tr1Path+MyDeCodeF.FileNames[i]) Then
           DeleteFile(Tr1Path+MyDeCodeF.FileNames[i]);
     End;

     if FileExists(PackFile) Then
     Begin
       AssignFile(f,CPF(PackFile,'.ini'));
       FileMode := 1;
       ReWrite(f);
       Write(f,MyDeCodeF);
       CloseFile(f);
       DeleteFile(CPF(PackFile,'.txt'));

       FileToOneFile(CPF(PackFile,'.ini'),CPF(PackFile,'.txt'));
       FileToOneFile(CPF(PackFile,'.dec'),CPF(PackFile,'.txt'));
       CompressFile(CPF(PackFile,'.upl'),CPF(PackFile,'.txt'),clMax);
       Result := True;
     End;
  Except
      On E:Exception do
      Begin
      End;
  End;
  Finally
    if FileExists(CPF(PackFile,'.ini')) then DeleteFile(CPF(PackFile,'.ini'));
    if FileExists(PackFile) then DeleteFile(PackFile);
    if FileExists(CPF(PackFile,'.txt')) then DeleteFile(CPF(PackFile,'.txt'));
    CB_Finish('',Proc);
  End;
  End;

  function RecordUpl(AOneDate:TDate):Boolean;
  var fini:TIniFile; aDt:TDateTime;
      sIniFile,sUplFile,sUplFileName:string;
  begin
    try
    try
      result:=false;
      sIniFile:=Format('%sRateDatUpload\RateDatUpl.lst',[FDataPath]);
      sUplFileName:=Format('_%s.upl',[FormatDateTime('yyyymmdd',AOneDate)]);
      sUplFile:=Format('%sRateDatUpload\%s\%s',
        [FDataPath,FormatDateTime('yyyymmdd',AOneDate),sUplFileName]);

      fini:=TIniFile.Create(sIniFile);
      fini.WriteInteger(sUplFileName,'Size',GetFileSize(sUplFile));
      aDt:=FileDateToDateTime(FileAge(sUplFile));
      //aDt:=Now;
      fini.WriteFloat(sUplFileName,'DateTime',aDt);
      fini.WriteString('File','GUID',Get_GUID8);
      result:=true;
    except
    end;
    finally
      try FreeAndNil(fini) except end;
    end;
  end;

  function RecordUpl2(AOneDate:TDate):Boolean;
  var fini:TIniFile; aDt:TDateTime;
      sIniFile,sUplFile,sUplFileName:string;
  begin
    try
    try
      result:=false;
      sIniFile:=Format('%sRateDatUpload\RateDatUpl.lst',[FDataPath]);
      sUplFileName:=Format('_%s.upl',[FormatDateTime('yyyymmdd',AOneDate)]);
      sUplFile:=Format('%sRateDatUpload\%s\%s',
        [FDataPath,FormatDateTime('yyyymmdd',AOneDate),sUplFileName]);

      fini:=TIniFile.Create(sIniFile);
      fini.WriteInteger(sUplFileName,'upload',1);  
      result:=true;
    except
    end;
    finally
      try FreeAndNil(fini) except end;
    end;
  end;

  function AddDateToRateDate(ADate:TDate):Boolean;
  var sFile,sDate:string;
      ts:TStringList;
  begin
    result:=true;
    //sFile:=FDataPath+'RateDatUpload\'+_RateDateFile;
    sFile:=AppParam.RateDatPath+_RateDateFile;
    ts:=TStringList.create;
    sDate:=FloatToStr(ADate);
    try
    try
      if FileExists(sFile) then
        ts.LoadFromFile(sFile);
      if ts.IndexOf(sDate)=-1 then
      begin
        ts.Add(sDate);
        ts.Sort;
        ts.SaveToFile(sFile);
      end;
      //result:=CpyDatF(sFile,AppParam.RateDatPath+_RateDateFile);
    except
      result:=false;
    end;
    finally
      try  FreeAndNil(ts); except end;
    end;
  end;

begin
  Result := 0;
try
Try
        DisplayMemo.AddMsg1(AppParam.TwConvertStr('非称浪琩'
         +FormatDateTime('yyyymmdd',aDate)+'Rate肚计沮'));
        needupload:=False;
        sTemp:=FDataPath+'RateDatUpload\'+FormatDateTime('yyyymmdd',aDate)+'\' ;
        Deltree(sTemp);
        needupload:=RateExistsDate(AppParam.RateDatPath,trunc(ADate));

        if needupload then
        begin
          if not DirectoryExists(sTemp) then ForceDirectories(sTemp);
           DisplayMemo.AddMsg1(AppParam.TwConvertStr('秨﹍RateDatゴ计沮'));
           if not AddDateToRateDate(ADate) then
           begin
             DisplayMemo.AddMsg1(AppParam.TwConvertStr('穝ら戳睲虫ア毖'));
             exit;
           end;
           if not PackageFile(sTemp,ADate,Proc) then
           begin
             DisplayMemo.AddMsg1(AppParam.TwConvertStr('ゴRateDat计沮ア毖'));
             exit;
           end;
           if not RecordUpl(ADate) then
           begin
             DisplayMemo.AddMsg1(AppParam.TwConvertStr('穝睲虫ア毖'));
             exit;
           end;


           b:=true;  
           for k:=0 to AppParam.RateDatFTPCount-1 do
           begin
             DisplayMemo.AddMsg1(AppParam.TwConvertStr('秨﹍非称肚RateDat计沮'));
             with AppParam.RateDatFTPInfos[k] do
             if not ConnectFtp(FFTPUserName,FFTPPassword,FFTPServer,FFTPUploadDir,
                FFTPPort,FFTPPassive) then
               exit;
             if not FtpDirectoryExists('ratedata') then
             begin
               IdFtp1.MakeDir('ratedata');
               IdFtp1.ChangeDir('ratedata');
             end;


              setlength(FileLst,2);
              FileLst[0]:=Format('%sRateDatUpload\%s\_%s.upl',
                [FDataPath,FormatDateTime('yyyymmdd',aDate),FormatDateTime('yyyymmdd',aDate)]);
              FileLst[1]:=Format('%sRateDatUpload\RateDatUpl.lst',[FDataPath]);
              iOKCount:=0;
              For n:=0 to High(FileLst) do
              Begin
                   if StopRunning Then Exit;
                   for j:=0 to 3 do
                   Begin
                     FileName := FileLst[n];
                     if StopRunning Then Exit;

                     if SameText(ExtractFileName(FileName),'RateDatUpl.lst') or
                        SameText(ExtractFileName(FileName),'_SwapAssetslist.lst') then 
                       FTPFileName:=ExtractFileName(FileName)
                     else
                       FTPFileName:=LowerCase(ExtractFileName(FileName));
                     DisplayMemo.AddMsg1(AppParam.TwConvertStr('肚 ') +FTPFileName );
                      if FtpData(FileName,'',FTPFileName) Then
                      Begin
                          FileName := '';
                          inc(iOKCount);
                          Break;
                      End;
                   End;

                   if Length(FileName)>0 Then
                   Begin
                     DisplayMemo.AddMsg2(FileName+AppParam.TwConvertStr(' 肚岿粇.'));
                     Exit;
                   End
                   else DisplayMemo.AddMsg1(AppParam.TwConvertStr('肚 ')+ExtractFileName(FileLst[n])+' ok.');
              end;
              //狦讽玡ら戳癸莱计沮肚Ok
              b:=b and (iOKCount=length(FileLst));
           end;
            //狦讽玡ら戳癸莱计沮肚Ok
           if b then
           begin
             DeleteFile(FileLst[0]);
             Deltree(sTemp);
             if DirectoryExists(sTemp) then
               RemoveDirectory(pchar(sTemp+''));
           end;
           RecordUpl2(adate);
           Result := 1;
        end else result:=-1;
Except
      On E: Exception do
        Begin
          DisplayMemo.AddMsg2(E.Message);
          SendDocMonitorWarningMsg(AppParam.TwConvertStr('RateDat计沮肚瞷岿粇')+'('+E.Message+')$E009');
        End;
end;
Finally
   try
     if IdFTP1.Connected Then
        IdFTP1.Disconnect;
   except
   end;
   if StopRunning Then
   Begin
      DisplayMemo.AddMsg1(AppParam.TwConvertStr('肚RateDat计沮い耞'));
   End Else
   Begin
      if Result=1 Then
        DisplayMemo.AddMsg1(AppParam.TwConvertStr('ЧΘ肚RateDat计沮'))
      Else if result=0  then Begin
        DisplayMemo.AddMsg1(AppParam.TwConvertStr('肚RateDat计沮ア毖'));
      End
      Else if result=-1  then
        DisplayMemo.AddMsg1(AppParam.TwConvertStr('⊿Τ惠璶肚RateDat计沮'));
   End;
end;
end;

function TAMainFrm.FtpSwapDat(Proc:TFarProc=nil):integer;
var sPath:ShortString;aFiles :_cStrLst;
    i:integer;

    function ChangeGuidOfThis(aTag,aGuid:string):Boolean;
    var fini:TiniFile;
        sVarFile1:string;
    begin
      Result:=false;
      if aTag='' then exit;
      sVarFile1:=AppParam.RateDatPath+'SwapAssetslist.lst';
      try
        fini:=TIniFile.Create(sVarFile1);
        fini.WriteString('list',aTag,aGuid);
        fini.WriteString('list','guid',Get_GUID8);
        result:=True;
      finally
        try FreeAndNil(fini); except end;
      end;
    end;

    function FtpListFile():integer;
    var k,k1,j:Integer; b,b1:boolean;
        sTemp1,sTemp2,sFileName,sAFile,sFileName2,sAFile2,FTPFileName:string;
    begin
      result:=-1;
         sAFile:=AppParam.RateDatPath+'SwapAssetslist.lst';
         sFileName:=ExtractFileName(sAFile);
         sAFile2:=GetCompressFile(sAFile);
         sFileName2:=ExtractFileName(sAFile2);
         CompressFile(sAFile2,sAFile,clMax);
         b:=true;
         for k:=0 to AppParam.RateDatFTPCount-1 do
         begin
           b1:=false;
           with AppParam.RateDatFTPInfos[k] do
           if not ConnectFtp(FFTPUserName,FFTPPassword,FFTPServer,FFTPUploadDir,
              FFTPPort,FFTPPassive) then
             exit;
           if not FtpDirectoryExists('ratedata') then
           begin
             IdFtp1.MakeDir('ratedata');
             IdFtp1.ChangeDir('ratedata');
           end;

           if StopRunning Then Exit;
           for j:=0 to 3 do
           Begin
              if StopRunning Then Exit;
              DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') +sFileName);
              if SameText(sFileName2,'RateDatUpl.lst') or
                 SameText(sFileName2,'_SwapAssetslist.lst') then
                 FTPFileName:=sFileName2
              else
                 FTPFileName:=LowerCase(sFileName2);
              if FtpData(sAFile2,'',FTPFileName) Then
              Begin
                  b1:=true;
                  Break;
              End;
           End;
           if not b1 then b:=false;
         end;
         if b then Result:=1;
         if FileExists(sAFile2) then
             DeleteFile(sAFile2);
    end;

    function DealWithFtp(aTag:string):integer;
    var k,k1,j:Integer; b,b1,b2,b3:boolean;
        sTemp1,sTemp2,sFileName,sAFile,sAFile2,sFileName2:string;
    begin
      for k1:=0 to High(aFiles) do
      begin
         sAFile:=aFiles[k1];
         sAFile2:=ExtractFilePath(sAFile)+aTag+ExtractFileName(sAFile);
         sAFile2:=GetCompressFile(sAFile2);

         sFileName:=ExtractFileName(sAFile);
         sFileName2:=ExtractFileName(sAFile2);
         CompressFile(sAFile2,sAFile,clMax);

         b:=false;
         //材顶琿 肚.dat
         b2:=true;
         for k:=0 to AppParam.RateDatFTPCount-1 do
         begin
           b1:=false;
           with AppParam.RateDatFTPInfos[k] do
           if not ConnectFtp(FFTPUserName,FFTPPassword,FFTPServer,FFTPUploadDir,
              FFTPPort,FFTPPassive) then
             exit;
           if not FtpDirectoryExists('ratedata') then
           begin
             IdFtp1.MakeDir('ratedata');
             IdFtp1.ChangeDir('ratedata');
           end;

           if StopRunning Then Exit;
           for j:=0 to 3 do
           Begin
              if StopRunning Then Exit;
              DisplayMemo.AddMsg1(AppParam.ConvertString('上传 ') +sFileName);
              if FtpData(sAFile2,'',LowerCase(sFileName2)) Then
              Begin
                  b1:=true;
                  Break;
              End;
           End;
           if not b1 then b2:=false;
         end;
         //材顶琿 肚.睲虫
         if b2 then
         begin
           if ChangeGuidOfThis(LowerCase(sFileName2),IntToStr(FileAge(sAFile))) then
           begin
             if FtpListFile=1 then
              b:=true;
           end;
         end;
        if FileExists(sAFile2) then
             DeleteFile(sAFile2);
         //材顶琿 埃.dat
         if b then
         begin
           b3:=True;
           if aTag=_SwapYield then
             b3:=DealWithUploadLog(sAFile,'swapyield')
           else if aTag=_SwapOption then
             b3:=DealWithUploadLog(sAFile,'swapoption');
           
           if b3 then
           begin
             DisplayMemo.AddMsg1(AppParam.ConvertString('更新上传log记录成功'));
             if FileExists(sAFile) then
               DeleteFile(sAFile);
           end
           else begin
             DisplayMemo.AddMsg1(AppParam.ConvertString('更新上传log记录失败'));
           end;
         end;
      end;

    end;
begin
  //检查SwapOption
  sPath:=AppParam.RateDatPath+'SwapOption\Date\';
  FolderAllFiles(sPath,'.dat',aFiles,False);
  if Length(aFiles)>0 then
  begin
    DisplayMemo.AddMsg1(AppParam.ConvertString('准备上传数据 资产交换选择权端交易行情日报表'));
    DealWithFtp(_SwapOption);
    SetLength(aFiles,0);
  end;

  //先检查SwapOption
  sPath:=AppParam.RateDatPath+'SwapYield\Date\';
  FolderAllFiles(sPath,'.dat',aFiles,False);
  if Length(aFiles)>0 then
  begin
    DisplayMemo.AddMsg1(AppParam.ConvertString('准备上传数据 资资产交换固定收益端交易行情日报表'));
    DealWithFtp(_SwapYield);
    SetLength(aFiles,0);
  end;
end;

end.
