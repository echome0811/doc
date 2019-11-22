//------------------------------------------------------------------------------
//Modify by JoySun
//2005/10/19
//�W�[�U�����������\��A���F10/YuanTa/Pola���i�U��
//---Doc3.2.0�ݨD1 huangcq080923 �ק�G���market_db\pulish_db�ؿ��U��txt���
//--DOC4.0.0�XN001 huangcq090407 add Doc�PWarningCenter��X
//*****Doc4.2-N001-sun-090610****** �ק�F�G�U���N�X���_�l���
//------------------------------------------------------------------------------
unit MainFrm;

interface

uses
 // ShareMem,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,TGetDocMgr, ExtCtrls, ActnList, ImgList, Menus, ComCtrls,
  ToolWin, StdCtrls,CsDef,TCommon,TDwnHttp,TParseYuanTaHtm,IniFiles, dxTL,
  dxCntner,SetupFrm,TParseHtmTypes,TDocMgr,
  TParseHtmLib,DateUtils, SocketClientFrm,TSocketClasses; //TWarningServer

type

  TMsgStatus=(MsgNormal,MsgError);
  TDwnMode=(dwnToday,dwnHistory,dwnNone);


  TOnDwnStatus=Procedure (Msg:ShortString) of Object;
  TOnNowDwnID=Procedure (ID:ShortString;DwnSuccess:Byte;
                         DwnMode:TDwnMode;
                         SuccessCount,FailCount,DwnTxtCount:Integer) of Object;
  TOnNowDwnTxt=Procedure (DwnTxtCount,SuccessCount,FailCount:Integer) of Object;
  TOnDwnPBar=Procedure (MaxSize,NowSize:Integer) of Object;
  TOnDwnMsg=Procedure (Status:TMsgStatus;Msg:ShortString) of Object;

  TADocTxt=Record
    ID : String[6];
    DwnStatus : Byte;
    ATitleR : TTitleR;
    HtmlTxt : String;
    AItem   : TdxTreeListNode;
  End;
  TADocTxtP=^TADocTxt;

  TADocTxtLog=Record
     ID : String[6];
     DwnUrl      : ShortString;
     DwnTitleCaption  : ShortString;
     DwnTitleDate  : TDate;
     DwnFailTime : TDateTime;
     DwnFailMsg  : ShortString;
  End;
  PADocTxtLog = ^TADocTxtLog;

  TADocTitleLog=Record
     ID : String[6];
     DwnSuccess  : Byte;
     DwnUrl  : ShortString;
     DwnTitleCount : Integer;
     DwnFailTime : TDateTime;
     DwnFailMsg  : ShortString;
  End;
  PADocTitleLog = ^TADocTitleLog;

  TADocTitle=Record
    ID : String[6];
    DwnStatus : Byte;
    NeedDwnTitleLst : TStringList;
    AItem   : TdxTreeListNode;
  End;


  TAHttpLib=Record
       //FileName : ShortString;
       BeUse : Boolean;
       FLib  : THandle;
  End;

  TAItemAction=Record
    AItem : TdxTreeListNode;
    BeUse : Boolean;
    Value : Array[0..3] of ShortString;
  End;

  TAPackageDocTxt=Record
     ID:String[6];
     FileNameLst : TStringList;
  End;

  TSaveLogMgr=Class
  Private
    FOutPutPath : String;
    ClearDate :TDate;
  public
    Constructor Create(OutPutPath:String);
    Procedure SaveLog(Msg:ShortString);
    procedure ClearSysLog;
  end;

  //�ΨӬ������g���U�Ӫ����D
  TTitleIdxMgr=Class
  private
    FTr1DBPath : ShortString;
    FOutPutHtmlPath : ShortString;
    FID : ShortString;
    FTitleLst : TStringList;
    FNeedSaveTitleLst : TStringList;
    FDocLst : TStringList;
    FResetTitleIdx : TStringList;
    FNeedSave : Boolean;
    Procedure OnGetFile(FileName:String);
    //��z�i�H�q�ݼf�֤��R�������D
    Procedure ResetTitleIdx();
    Procedure FolderAllFiles_idx(DirName : shortString;SpecExt:ShortString;Var Files :TStringList;IncludeSubFolder:Boolean=True);
    Procedure Init();
  public
    Constructor Create(Tr1DBPath,OutPutHtmlPath:ShortString);
    Destructor Destroy();override;
    Function  TitleExists(Const ATitle:ShortString;Const ADate:TDate):Boolean;
    Procedure AddTitleIdx(Const ATitle:ShortString;Const ADate:TDate);
    Procedure ClearTitleIdx();
    Procedure SaveToFile();
    Procedure Refresh(ID:ShortString);
  end;


  TTdxTreeListMgr=Class(TThread)
  protected
       FTdxLst : TdxTreeList;
       FItemBufferLst : Array of TAItemAction;
       //ASection: TRTLCriticalSection;
       procedure Execute; override;
  public
       constructor Create(ATdxLst:TdxTreeList;ItemCount:Integer);
       Destructor Destroy();Override;
       Function Add():TdxTreeListNode;
       Procedure DeleteItem(AItem:TdxTreeListNode);
       Procedure AddString(AItem:TdxTreeListNode;
                           ColIndex:Integer;
                           Value:ShortString);
  End;

  TADwnTxt=Class(TThread)
  protected
       FTdxLst : TTdxTreeListMgr;

       FDocTxtP : TADocTxt;
       FErrMsg  : ShortString;
       FBeUse : Boolean;

       FEndDwn  : Boolean;
       FDwnSuccess  : Boolean;
       //FOutPutHtmlPath : ShortString;
       //FParse : TParseYuanTaHtmMgr;
       FHtmlTxt  : TStringList;
       FStop  : Boolean;
       FRunEnd : Boolean;

       FExecute : Boolean;

       Procedure ShowMsg(Msg:ShortString);
       Procedure ShowPer(MaxSize,NowSize:Integer);
       Procedure OnDwnHttpMessage(AMessage:TDwnHttpWMessage);
       procedure Execute; override;

  public
       constructor Create(ATdxLst : TTdxTreeListMgr);

       Procedure InitData(Const ID: String;
                          Const ATitleR: TTitleR;
                          Const AItem :TdxTreeListNode);
       Procedure Clear();
       Procedure ReStart();
       Destructor Destroy();Override;

  End;

  TADwnTitle=Class(TThread)
  protected
       FTdxLst : TTdxTreeListMgr;
       FDocTitleP : TADocTitle;
       FErrMsg  : ShortString;
       FDwnUrl  : ShortString;
       FEndDwn  : Boolean;
       FDwnSuccess  : Boolean;
       FOutPutHtmlPath : ShortString;
       FTr1DBPath : ShortString;
       FParseHtml : TParseHtmLibMgr;

       //FDocLstDatMgr : TDocLstDatMgr;
       FTitleIdxMgr : TTitleIdxMgr;
       FDwnMode : TDwnMode;
       FBeUse : Boolean;
       FStop  : Boolean;
       FRunEnd : Boolean;

       FHtmlTxt : TStringList;

       FExecute : Boolean;

       Procedure ShowMsg(Msg:ShortString);
       Procedure ShowMsg2(Msg:ShortString);
       Procedure ShowPer(MaxSize,NowSize:Integer);
       Procedure OnDwnHttpMessage(AMessage:TDwnHttpWMessage);
       procedure Execute; override;

  public
       constructor Create(ATdxLst   : TTdxTreeListMgr;
                          Tr1DBPath : ShortString;
                          OutPutDataPath:ShortString;
                          OutPutHtmlPath:ShortString);

       Destructor Destroy();Override;

       Procedure ReStart();
       Procedure Clear();

       Procedure InitData(Const ID : String;
                          AParse: TParseHtmLibMgr;
                          Const DwnStatus : Byte;
                          Const DwnMode : TDwnMode;
                          Const AItem :TdxTreeListNode);

      Procedure RefreshFromIdxFile();
      Procedure SaveToIdxFile();


  End;

  TDwnDocTxtMgr=Class(TThread)
  protected

       FIDLstMgr:TIDLstMgr2;
       FDocTxtLst : TList;
       FDwnFailTitleLst : TList;
       FDwnFailTxtLogLst : TList;
       FNotDwnTitleStrLst  : TStringList;

       FTdxLst : TTdxTreeListMgr;
       FOutPutDataPath : ShortString;
       FOutPutHtmlPath:ShortString;
       FDwnTitleTxtPath:ShortString;
       FDwnFailTitleTxtPath:ShortString;

       FDocTxtThreadCount : Integer;

       FAllThreadFailCount : Integer; //�����u�{���~������

       FOnNowDwnTxt : TOnNowDwnTxt;

       FNowPackageID : ShortString;
       FPackageFileNameLst : TStringList;
       FNeedRefreshIDLst : Boolean;

       AllDwnCount,SuccessCount,FailCount : Integer;

       FDwnThreadList : Array of TADwnTxt;

       function SetDocTxt(Var f:TStringList;
                          Const ID,URL,MemoTitle:ShortString;
                          Const TxtDate : TDate;
                          Const MemoTxt:String):Boolean;

       Function AddTitle(Const ID:String;Const ATitleR: TTitleR):Boolean;

       Procedure AddStringList(Var StrLst:TStringList;Str:String);

       //�N�U�����Ѫ����D�O�s������
       Procedure SaveDwnFailLogTxtLst();
       Procedure GetDwnFailLogTxtLst();
       Procedure ClearDwnFailLogTxtLst();
       //���s�]�w���Ѫ�����
       Function ResetDwnFailTxtLogLst(FailLst,SuccessLst:TList):Boolean;


       //���O�s�٥��U�������D
       Procedure SaveNotDwnTitleLst();

       //�N���ӭn�U�����٥��U�������D�O�s�_ ��
       Procedure SaveDocTxtTitleLst();
       Function GetDocTxtTitleLst(AID:String):Integer;

       //�O�s�U�����Ѫ����D
       Procedure SaveDwnFailTitleLst();
       Function GetDwnFailTitleLst(AID:String):Integer;

       Procedure GetIDAndTitleRStr(var ID,TitleRStr : String;Str:String);

       Procedure OnGetFile(FileName:String);


       Procedure DwnDocTxt();
       Procedure ChangeDwnCountMsg();

       function  GetNewDocTxtFileName():String;

       Procedure FreeThreadDwn();
       Procedure InitThreadDwn();
       Procedure SetThreadDwnNotUse(ADwnTxt:TADwnTxt);
       Function GetThreadDwn():TADwnTxt;

       procedure Execute; override;
  public
       constructor Create(Tr1DBPath,OutPutDataPath:String;
                          IDLstMgr:TIDLstMgr2;
                          DocTxtThreadCount : Integer;
                          ATdxLst : TTdxTreeListMgr;
                          OnNowDwnTxt : TOnNowDwnTxt);
       Destructor Destroy();Override;
       Procedure AddToNotDwnTitleLst(ID:String;ATitleLst:TStringList);
       Procedure RefreshIDLst();
  End;

  TDwnDocTitleMgr=Class(TThread)
  protected

       FDocTitleThreadCount : Integer;
       FDocTitleTdxLst : TTdxTreeListMgr;

       FIDLstMgr:TIDLstMgr2;
       FDwnFailIDLogLst : TList;
       FDwnDocTxtMgr   : TDwnDocTxtMgr;

       FOutPutDataPath : ShortString;
       FTr1DBPath : ShortString;
       FOutPutHtmlPath : ShortString;
       FOnDwnMsg    : TOnDwnMsg;
       FOnNowDwnID  : TOnNowDwnID;

       FDwnIDLst : TList;
       FDwnSuccessIDLst : TStringList;
       FDwnFailIDLst : TStringList;
       FAllThreadFailCount : Integer; //�����u�{���~������

       FNowDwnCount : Integer;

       FNeedDwnTitleCount : Integer;

       FNowDwnMode : TDwnMode;
       FHaveChangeDwnMode : Boolean;

       FDwnThreadList : Array of TADwnTitle;

       FLogIDLstDateStr : ShortString;

       Procedure SaveDwnLogToFile(dwnMode:TDwnMode);
       Procedure GetDwnLogFromFile(dwnMode:TDwnMode);
       Procedure ResetIDStatus();
       Procedure ClearIDStatus();
       Function IsNewID(ID:String):Boolean;
       Function IsSuccessID(ID:String):Boolean;
       Function IsFailID(ID:String):Boolean;
       Procedure DelIDFormFailLst(ID:String);

       Procedure DwnDocTitle();

       Procedure FreeThreadDwn();
       Procedure InitThreadDwn();
       Procedure SetThreadDwnNotUse(ADwnTitle:TADwnTitle);
       Function GetThreadDwn():TADwnTitle;

       //�ˬd�O�_�n���ܤU���Ҧ�
       Function ChangeDwnMode():Boolean;

       //�N�U�����Ѫ��O�s���O��
       Procedure ResetLogIDLstToZero(Var NeedDwnTitleCount:Integer);
       Procedure ResetLogIDLst(ADwnTitle : TADwnTitle;Var NeedDwnTitleCount:Integer);
       Procedure SaveLogIDLst(Var NeedDwnTitleCount:Integer);
       Procedure GetLogIDLst();
       Procedure ClearLogIDLst();
       Procedure InitLogIDLst(Var NeedDwnTitleCount:Integer);

       procedure Execute; override;

  public
       constructor Create(Tr1DBPath,OutPutDataPath:String;
                          IDLstMgr     : TIDLstMgr2;
                          ADwnDocTxtMgr : TDwnDocTxtMgr;
                          DocTitleThreadCount : Integer;
                          ADocTitleTdxLst : TTdxTreeListMgr;
                          OnDwnMsg    : TOnDwnMsg;
                          OnNowDwnID  : TOnNowDwnID);
       Destructor Destroy();Override;
  End;



  TAMainFrm = class(TForm)
    MainMenu2: TMainMenu;
    Mnu_MainMenu: TMenuItem;
    Mnu_Stop: TMenuItem;
    Mnu_Start: TMenuItem;
    N6: TMenuItem;
    Mnu_Exit: TMenuItem;
    ImageList1: TImageList;
    ActionList1: TActionList;
    Act_Cal: TAction;
    Act_Stop: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel5: TPanel;
    Panel1: TPanel;
    Label_CBCount: TLabel;
    Panel7: TPanel;
    Label1: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel7: TBevel;
    TabSheet2: TTabSheet;
    dxTreeList1: TdxTreeList;
    dxTreeList1Column1: TdxTreeListColumn;
    dxTreeList1Column2: TdxTreeListColumn;
    dxTreeList1Column3: TdxTreeListColumn;
    dxTreeList1Column4: TdxTreeListColumn;
    Panel6: TPanel;
    Splitter1: TSplitter;
    ListBox2: TListBox;
    ListBox_ID: TListBox;
    dxTreeList2: TdxTreeList;
    dxTreeListColumn1: TdxTreeListColumn;
    dxTreeListColumn2: TdxTreeListColumn;
    dxTreeListColumn3: TdxTreeListColumn;
    dxTreeListColumn4: TdxTreeListColumn;
    Splitter2: TSplitter;
    Act_Setup: TAction;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Label2: TLabel;
    TabSheet3: TTabSheet;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Panel3: TPanel;
    Label3: TLabel;
    Report_DwnTitle: TdxTreeList;
    dxTreeListColumn5: TdxTreeListColumn;
    dxTreeListColumn6: TdxTreeListColumn;
    dxTreeListColumn7: TdxTreeListColumn;
    dx_TitleCount: TdxTreeListColumn;
    dxTreeList3Column5: TdxTreeListColumn;
    Act_RefreshReport: TAction;
    Report_DwnTxt: TdxTreeList;
    dxTreeListColumn9: TdxTreeListColumn;
    dxTreeListColumn10: TdxTreeListColumn;
    dxTreeListColumn11: TdxTreeListColumn;
    dxTreeListColumn12: TdxTreeListColumn;
    dxTreeListColumn13: TdxTreeListColumn;
    Panel4: TPanel;
    Label4: TLabel;
    Doc_Check_Timer: TTimer;
    ToolBar1: TToolBar;
    ToolButton6: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton7: TToolButton;
    Label5: TLabel;
    TimerStopSevice: TTimer;
    TimerSendLiveToDocMonitor: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Act_StopExecute(Sender: TObject);
    procedure Act_CalExecute(Sender: TObject);
    procedure Act_SetupExecute(Sender: TObject);
    procedure Mnu_ExitClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Act_RefreshReportExecute(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure Report_DwnTitleCustomDrawCell(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
      AColumn: TdxTreeListColumn; ASelected, AFocused,
      ANewItemRow: Boolean; var AText: String; var AColor: TColor;
      AFont: TFont; var AAlignment: TAlignment; var ADone: Boolean);
    procedure Doc_Check_TimerTimer(Sender: TObject);
    Function CheckDoc():Boolean;
    procedure TimerStopSeviceTimer(Sender: TObject);
    procedure TimerSendLiveToDocMonitorTimer(Sender: TObject);
  private
    FNowIsRunning: Boolean;
    FNowIsStartGet : Boolean;
    FNowIsStopGet  : Boolean;
    NewDay  : Boolean;

    FStopRunningSkt : Boolean; //--DOC4.0.0��N001 huangcq090407 add
    ASocketClientFrm : TASocketClientFrm; //--DOC4.0.0��N001 huangcq090407 add
    procedure SendDocMonitorStatusMsg;//--DOC4.0.0��N001 huangcq090407 add
    function SendDocMonitorWarningMsg(const Str: String): boolean;//--DOC4.0.0��N001 huangcq090407 add
    procedure Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);//--DOC4.0.0��N001 huangcq090407 add     

    procedure SetNowIsRunning(const Value: Boolean);
  private
    { Private declarations }
    FDocTxtTdxTreeListMgr : TTdxTreeListMgr;
    FDocTitleTdxTreeListMgr : TTdxTreeListMgr;
    FLogMgr : TSaveLogMgr;
    FIDLstMgr : TIDLstMgr2;
    FParam : TGetDocMgrParam;
    FDwnDocTitleMgr : TDwnDocTitleMgr;
    FDwnDocTxtMgr   : TDwnDocTxtMgr;
    FIDCount: Integer;


    Property NowIsRunning : Boolean Read FNowIsRunning Write SetNowIsRunning;
  public
    { Public declarations }
    Procedure OnAppExcept(Sender: TObject; E: Exception);

    Procedure ShowDwnTitleReport();
    Procedure ShowDwnTxtReport();

    Function GetIDReplaceTag(ID:ShortString):ShortString;
    Function SetIDReplaceTag(ID:ShortString;Success:Byte):ShortString;
    Procedure ResetIDLstBox();

    Procedure OnDwnMsg(Status:TMsgStatus;Msg:ShortString);
    Procedure OnNowDwnID(ID:ShortString;DwnSuccess:Byte;DwnMode:TDwnMode;
                         SuccessCount,FailCount,DwnTxtCount:Integer);
    Procedure OnNowDwnTxt(DwnTxtCount,SuccessCount,FailCount:Integer);

    Procedure ClearMsg();

    Procedure ShowNowDwnIDCountMsg(DwnMode:TDwnMode;SuccessCount,FailCount,DwnTxtCount:Integer);
    Procedure ShowErrStatus(Msg:String);
    Procedure ShowMsgStatus(Msg:String);
    Procedure SaveLogMsg(Msg:String);
    Procedure ShowSysStatus();

    Function  StartGet():Boolean;
    Procedure StopGet();

    Function ReloadIDLst():boolean;
    Function ReloadParam():Boolean;
    Procedure InitObj();
    Procedure FreeObj();
    //****Doc4.2-sun-090610****************
    Procedure GetStartDate(IDList : TStringList);
    function  SearchStartDate(ID:string;FTr1DBPath:shortString;StartDate:String):string;
    //*****************************************************************
  end;

  function TitleRToStr(ATitle: TTitleR): ShortString;
  function StrToTitleR(Const Str: ShortString): TTitleR;

  //���~�����ˬd
  Procedure WarningErrWhenDwnTitleErrorCount(FailCount:Integer);
  Procedure WarningErrWhenDwnTxtErrorCount(FailCount:Integer);

  function GetEndReadTitle(ID,Path: String): String;
  procedure SaveEndReadTitle(ID, TitleStr,Path: String);

  Procedure SaveTodayDwnTitleCount(Var Count:Integer;Path: String);
  Function GetTodayDwnTitleCount(Path: String):Integer;


  //�O�s�ݼf�֪�Log
  Procedure SaveToWaitCheckLog(Path:String;IndexLog:TStringList);
  Procedure GetWaitCheckLog(Path,ID:String;IndexLog:TStringList);


  Procedure WriteToFile(Const FileName,Txt:String);
  //Function ReadFromFile(Const FileName:String):String;

   //**************Doc4.2-N001-sun-090610 ************************
  Function  GetIDStartDate(ID: String): String;
  //***********************************************
var
  AMainFrm: TAMainFrm;
  FLibLst : Array of TAHttpLib;
  csMyCriticalSection: TRTLCriticalSection;
  FDateStr : String;

  FDwnDocTitleThreadCount   : Integer=0;
  FDwnDocTxtThreadCount     : Integer=0;
  FDwnTodayDocStartTime     : TTime;
  FDwnHistoryDocStartTime   : TTime;

  FDwnDocTitleErrCount   : Integer=-1;
  FDwnDocTxtErrCount   : Integer=-1;

  FStopRunning : Boolean=false;

  //add by JoySun 2005/10/19
  FDwnMemo  : integer; //�U�������A0�GF10�B1�G�_�ӡB 2�G���j�ʵ�

implementation
Var
  LockRefres : Boolean=false;
//add by wangjinhua 4.16 - Problem(20100716)
procedure ChrConvert(var ASource:String);
const
  KeyStr1='<meta';
  KeyStr12='<link';
  KeyStr2='charset=';
var
  i,j,iPos:Integer;
  ts:TStrings;
  vItem,vChrType:String;
begin
  ts:=TStringList.Create;
try
  ts.Text:=ASource;
  for i:=0 to ts.Count-1 do
  begin
    vItem:=ts[i];
    iPos:=Pos(KeyStr2,vItem);
    if ( (Pos(KeyStr1,vItem)>0) or (Pos(KeyStr12,vItem)>0) )
       and (iPos>0) then
    begin
      vChrType:='';
      for j:=iPos+Length(KeyStr2) to Length(vItem) do
      begin
        if //(vItem[j]='"') or
           (vItem[j]=' ') or
           (vItem[j]='/') or
           (vItem[j]='>') or
           (vItem[j]=Chr(39)) then break;
        vChrType:=vChrType+vItem[j];
      end;
      vChrType := StringReplace(vChrType,'"','',[rfReplaceAll]);
      if SameText(vChrType,'UTF-8') then
        ASource:=Utf8Decode(ASource);
      break;
    end;
  end;
finally
  try
    if Assigned(ts) then
      FreeAndNil(ts);
  except
  end;
end;
end;
//--

//**************Doc4.2-N001-sun-090610 ************************
Function  GetIDStartDate(ID: String): String;
var
  inifile : Tinifile;
begin
  Result := '';
  inifile := Tinifile.Create(ExtractFilePath(Application.ExeName)+'ID_StartGetDate.lst');
  Try
    Result := inifile.ReadString(ID,'StartGetDate','1899-12-30');
  Finally
    inifile.Free;
  end;
end;
//***********************************************


Procedure GetWaitCheckLog(Path,ID:String;IndexLog:TStringList);
Var
  Str,FileName : String;
  FLogFile : TStringList;
  i : Integer;
begin

  IndexLog.Clear;
  FileName := Path+'Doc_02.log';
  if Not FileExists(FileName) Then
     Exit;
  FLogFile := TStringList.Create;
try
Try

  FLogFile.LoadFromFile(FileName);

  While FLogFile.Count>0 DO
  Begin
     Str := FLogFile.Strings[0];
     FLogFile.Delete(0);
     Try
       i := Pos('/',Str);
       if i>0 Then
       Begin
         if Copy(Str,1,i-1)=ID Then
            IndexLog.Add(Copy(Str,i+1,Length(Str)-i));
       End;
     Except
     end;
  End;

Except
End;
Finally
 FLogFile.Destroy;
End;

End;

Procedure SaveToWaitCheckLog(Path:String;IndexLog:TStringList);
Var
  FileName : String;
  FLogFile : TextFile;
begin

try
Try

  FileName := Path+'Doc_02.log';

  AssignFile(FLogFile,FileName);
  FileMode := 1;

  if FileExists(FileName) Then
  Begin
      Append(FLogFile);
  End Else
      ReWrite(FLogFile);

  While IndexLog.Count>0 DO
  Begin
     Writeln(FLogFile,IndexLog.Strings[0]);
     IndexLog.Delete(0);
  End;

Except
End;
Finally
  try
    CloseFile(FLogFile);
  Except
  End;
End;

End;

{
Function ReadFromFile(Const FileName:String):String;
Var
  f : TextFile;
  s : String;
begin

  Result := '';
  if Not FileExists(FileName) Then
     Exit;
  EnterCriticalSection(csMyCriticalSection);
try
Try
  AssignFile(f,FileName);
  FileMode := 0;
  ReSet(f);
  //Read(f,Result);

  While Not Eof(f) do
  Begin
    ReadLn(f,s);
    if Length(Result)=0 Then
       Result := s
    Else
       Result := Result +#13#10+ s;
  End;

Except
End;
Finally
  try
    CloseFile(f);
  Except
  End;
  LeaveCriticalSection(csMyCriticalSection);
End;

End;
}

Procedure WriteToFile(Const FileName,Txt:String);
Var
  f : TextFile;
begin
  EnterCriticalSection(csMyCriticalSection);
try
Try
  AssignFile(f,FileName);
  FileMode := 1;
  ReWrite(f);
  Writeln(f,txt);
Except
End;
Finally
  try
    CloseFile(f);
  Except
  End;
  LeaveCriticalSection(csMyCriticalSection);
End;

End;


procedure WarningErrWhenDwnTitleErrorCount(FailCount: Integer);
begin
Try
  if FailCount>FDwnDocTitleErrCount Then            //DwnHtml�U�����D�o�Ϳ��~�ӼƶW�L
     AMainFrm.SendDocMonitorWarningMsg(ConvertString('DwnHtml���ر��ⷢ�������������'+
                        IntToStr(FDwnDocTitleErrCount)+'��')+'$W007');//--DOC4.0.0��N001 huangcq090407 add
Except
End;
end;

procedure WarningErrWhenDwnTxtErrorCount(FailCount: Integer);
begin
try
  if FailCount>FDwnDocTxtErrCount Then
     AMainFrm.SendDocMonitorWarningMsg(ConvertString('DwnHtml�������·��������������'+
                        IntToStr(FDwnDocTxtErrCount)+'��')+'$W007');//--DOC4.0.0��N001 huangcq090407 add
Except
End;
end;

Function GetTodayDwnTitleCount(Path: String):Integer;
Var
  f : TIniFile;
begin

   EnterCriticalSection(csMyCriticalSection);
   Result := 0;
   f := TiniFile.Create(Path+'DwnTitleCount.txt');
Try
Try
   FDateStr:=FormatDateTime('yyyymmdd',Date);
   Result := f.ReadInteger(FDateStr,'Value',0);
Except
End;
Finally
   f.Destroy;
   LeaveCriticalSection(csMyCriticalSection);
End;
End;

Procedure SaveTodayDwnTitleCount(Var Count:Integer;Path: String);
Var
  f : TIniFile;
begin

   EnterCriticalSection(csMyCriticalSection);
   f := TiniFile.Create(Path+'DwnTitleCount.txt');
Try
Try
//�p�G������@��,�N�k0
   if FDateStr<>FormatDateTime('yyyymmdd',Date) Then
   Begin
       Count    := 0;
       FDateStr := FormatDateTime('yyyymmdd',Date);
   End;

   f.WriteInteger(FormatDateTime('yyyymmdd',Date),'Value',Count);

Except
End;
Finally
   f.Destroy;
   LeaveCriticalSection(csMyCriticalSection);
End;
End;

procedure SaveEndReadTitle(ID, TitleStr,Path: String);
Var
  f : TIniFile;
begin
Try
Try
  if Length(TitleStr)>0 Then
  Begin
    f := TiniFile.Create(Path+'EndTitle.txt');
    f.WriteString(ID,'Value',TitleStr);
    f.Destroy;
  End;
Except
End;
Finally
End;
end;

function GetEndReadTitle(ID,Path: String): String;
Var
  f : TIniFile;
begin
   f := TiniFile.Create(Path+'EndTitle.txt');
Try
Try
   Result := f.ReadString(ID,'Value','');
Except
End;
Finally
   f.Destroy;
End;
end;

function TitleRToStr(ATitle: TTitleR): ShortString;
begin

Try
  Result := ATitle.Caption+#9+FloatToStr(ATitle.TitleDate)+#9+
                            ATitle.Address
Except
End;
end;

function StrToTitleR(Const Str: ShortString): TTitleR;
Var
 StrLst : _CStrLst2;
begin
Try
Try

  Result.Caption := '';
  Result.Address := '';
  Result.TitleDate := 0;
  if Length(Str)=0 Then
     exit;
  SetLength(StrLst,0);
  StrLst := DoStrArray2(Str,#9);

  Result.Caption := StrLst[0];
  Result.TitleDate := StrToFloat(StrLst[1]);
  Result.Address := StrLst[2];

Except
End;
Finally
End;

end;


{$R *.dfm}

{ TDwnDocTitleMgr }

function TDwnDocTitleMgr.ChangeDwnMode: Boolean;
Var
  ADwnMode : TDwnMode;
begin

   Result :=  FHaveChangeDwnMode;
   if Result Then
      Exit;
   //           6:00                                18:00
   if(FDwnHistoryDocStartTime>EncodeTime(12,00,00,00))then
   begin
     if (Time>FDwnTodayDocStartTime)and(Time<FDwnHistoryDocStartTime) Then
         ADwnMode := dwnToday
     Else
         ADwnMode := dwnHistory;
   end else
   begin
     if (Time<FDwnTodayDocStartTime) and (Time>FDwnHistoryDocStartTime) Then
         ADwnMode := dwnHistory
     Else
         ADwnMode := dwnToday;
   end;

   Result := FNowDwnMode<>ADwnMode;

   FHaveChangeDwnMode := Result;

   FNowDwnMode := ADwnMode;


end;

procedure TDwnDocTitleMgr.ClearIDStatus;
begin
  FOnNowDwnID('',0,dwnNone,-1,-1,FNeedDwnTitleCount);
end;

procedure TDwnDocTitleMgr.ClearLogIDLst;
begin
  While FDwnFailIDLogLst.Count>0 do          
  Begin        
    Try        
      FreeMem(FDwnFailIDLogLst.Items[0]);        
    Except        
    End;        
    FDwnFailIDLogLst.Delete(0);        
  End;
end;

constructor TDwnDocTitleMgr.Create(Tr1DBPath,OutPutDataPath:String;
                          IDLstMgr     : TIDLstMgr2;
                          ADwnDocTxtMgr : TDwnDocTxtMgr;
                          DocTitleThreadCount : Integer;
                          ADocTitleTdxLst : TTdxTreeListMgr;
                          OnDwnMsg    : TOnDwnMsg;
                          OnNowDwnID  : TOnNowDwnID);
begin

   FOnDwnMsg    := OnDwnMsg;
   FOnNowDwnID  := OnNowDwnID;

   FDwnDocTxtMgr := ADwnDocTxtMgr;

   FDocTitleTdxLst  := ADocTitleTdxLst;
   FDocTitleThreadCount := DocTitleThreadCount;
   FTr1DBPath := Tr1DBPath;
   FIDLstMgr  := IDLstMgr;

   FOutPutDataPath := OutPutDataPath;
   FOutPutHtmlPath := FOutPutDataPath+'Html\';
   Mkdir_Directory(FOutPutHtmlPath);

   FDwnFailIDLogLst := TList.Create;
   FDwnIDLst := TList.Create;

   //һ���o䛳ɹ�һ���o�ʧ��
   FDwnSuccessIDLst := TStringList.Create;
   FDwnFailIDLst := TStringList.Create;

   FreeOnTerminate := false;
   inherited Create(true);

end;

procedure TDwnDocTitleMgr.DelIDFormFailLst(ID: String);
Var
  i : Integer;
begin

   for i:=0 to FDwnFailIDLst.Count-1 do
   Begin
     if FDwnFailIDLst.Strings[i]=ID Then   
     Begin 
         FDwnFailIDLst.Delete(i); 
         Break; 
     End;
   End;

end;

destructor TDwnDocTitleMgr.Destroy;
begin

  ClearLogIDLst;
  FDwnFailIDLogLst.Destroy;

  FDwnIDLst.Destroy;

  FDwnSuccessIDLst.Destroy;
  FDwnFailIDLst.Destroy;

  FreeThreadDwn;

  FIDLstMgr := nil;

  FDwnIDLst := nil;
  FOnDwnMsg    := nil;
  FOnNowDwnID  := nil;
  //inherited;

end;

procedure TDwnDocTitleMgr.DwnDocTitle();
Var
  ADwnTitle : TADwnTitle;
  DelList : TList;
  i : Integer;
  ThreadCount : Integer;
  DwnTitleLst : TList;
begin

  //inherited;

  if FDwnIDLst.Count=0 Then
     Exit;

  FNowDwnCount := 0;
  DelList := TList.Create;
  DwnTitleLst := TList.Create;

Try

  //�Á��Д�˴�ʧ���ľ��̔�
  ThreadCount := FDwnIDLst.Count;

  if Self.Terminated Then
     Exit;

  //��ȫ��Refresh
  for i:=0 to  FDwnIDLst.Count-1 do
  Begin
    ADwnTitle := FDwnIDLst.Items[i];   
    ADwnTitle.RefreshFromIdxFile; 
    DwnTitleLst.Add(ADwnTitle);
  End;

  for i:=0 to  FDwnIDLst.Count-1 do
  Begin
    ADwnTitle := FDwnIDLst.Items[i];
    With ADwnTitle Do    
    Begin    
      FDocTitleTdxLst.AddString(FDocTitleP.AItem,0,FDocTitleP.ID);
      FDocTitleTdxLst.AddString(FDocTitleP.AItem,1,'');
      FDocTitleTdxLst.AddString(FDocTitleP.AItem,2,'');
    End;
  End;

  for i:=0 to  FDwnIDLst.Count-1 do
  Begin
    ADwnTitle := FDwnIDLst.Items[i];      
    With ADwnTitle Do    
    Begin    
      FDocTitleP.DwnStatus := 3; //���M�����dThread    
      //Resume;  
      ReStart;
    End;
  End;

  While FDwnIDLst.Count>0 Do
  Begin
    try

      Application.ProcessMessages;
      Sleep(50);

      //�������d�Y��=================
      for i:=0 to  FDwnIDLst.Count-1 do
      Begin
          Application.ProcessMessages;
          Sleep(10);
          ADwnTitle := FDwnIDLst.Items[i];
          if ADwnTitle.FRunEnd  Then
          Begin
              //�ɹ�
              if (ADwnTitle.FDocTitleP.DwnStatus=1) Then
              Begin
                //�ʂ�h��
                DelList.Add(ADwnTitle);
                //��׃�o�
                ResetLogIDLst(ADwnTitle,FNeedDwnTitleCount);
                try

                   if ADwnTitle.FDocTitleP.NeedDwnTitleLst.Count>0 Then
                   Begin
                      if Assigned(FOnDwnMsg) Then
                         FOnDwnMsg(msgNormal,
                                   Format(ConvertString('%s ���б��� %s ����Ҫ����'),
                                   [ADwnTitle.FDocTitleP.ID,
                                    IntToStr(ADwnTitle.FDocTitleP.NeedDwnTitleLst.Count)]));
                   End;

                   //��FDwnDocTxtMgr�_ʼ���d�@Щ���}
                   if ADwnTitle.FDocTitleP.NeedDwnTitleLst.Count>0 Then
                      FDwnDocTxtMgr.AddToNotDwnTitleLst(ADwnTitle.FDocTitleP.ID,
                                                        ADwnTitle.FDocTitleP.NeedDwnTitleLst);

                   //�o�ID�ɹ�
                   FDwnSuccessIDLst.Add(ADwnTitle.FDocTitleP.ID);

                   //�������d���r��B�@ʾ(ListBox_ID)
                   if Assigned(FOnNowDwnID) Then
                      FOnNowDwnID(ADwnTitle.FDocTitleP.ID,
                                  0,
                                  FNowDwnMode,
                                  FDwnSuccessIDLst.Count,
                                  FDwnFailIDLst.Count,
                                  FNeedDwnTitleCount);
                Except
                  On E:Exception do
                     if Assigned(FOnDwnMsg) Then
                       FOnDwnMsg(msgError,E.Message);
                End;
              end Else
              Begin //ʧ��

                //�ʂ�h��
                DelList.Add(ADwnTitle);

                //��׃�o�
                ResetLogIDLst(ADwnTitle,FNeedDwnTitleCount);

                //�ô��жϴ˴�ʧ�ܵ��߳���
                DEC(ThreadCount);

                try
                   //�o�ʧ����ID (Refresh ListBox_ID)
                   FDwnFailIDLst.Add(ADwnTitle.FDocTitleP.ID);
                   if Assigned(FOnNowDwnID) Then
                   Begin
                     FOnNowDwnID(ADwnTitle.FDocTitleP.ID,1,FNowDwnMode,
                         FDwnSuccessIDLst.Count,FDwnFailIDLst.Count,FNeedDwnTitleCount);
                   End;
                Except
                  On E:Exception do
                     if Assigned(FOnDwnMsg) Then
                        FOnDwnMsg(msgError,E.Message);
                End;
              End;
          End;
      end;

      //̎�e���d�Y����ID
      While DelList.Count>0 Do
      Begin

           ADwnTitle := DelList.Items[0];
           DelList.Delete(0);

           FDwnIDLst.Remove(ADwnTitle);
           SetThreadDwnNotUse(ADwnTitle);

           Dec(FNowDwnCount);

      End;
      //====================

    Except
      On E:Exception Do
      Begin
       if Assigned(FOnDwnMsg) Then
          FOnDwnMsg(msgError,E.Message+'(DwnDocTitle)');
      End;
    End
  End;

Finally

  DelList.Destroy;

  //ȫ������
  if Assigned(DwnTitleLst) Then
  Begin
    for i:=0 to  DwnTitleLst.Count-1 do
    Begin
       ADwnTitle := DwnTitleLst.Items[i];
       ADwnTitle.SaveToIdxFile;
    End;
    DwnTitleLst.Free;
  End;


  //�������d�Y��
  SaveDwnLogToFile(FNowDwnMode);
  //����o�
  SaveLogIDLst(FNeedDwnTitleCount);


  if ThreadCount=0 Then
     inc(FAllThreadFailCount)
  Else
     FAllThreadFailCount := 0; //�����g�гɹ��^,�͚w0���^����
  //�Д��Ƿ�Ҫ�l���e�`��
  WarningErrWhenDwnTitleErrorCount(FAllThreadFailCount);

  //EnterCriticalSection(csMyCriticalSection);
  //ReleaseMemory(50);
  //LeaveCriticalSection(csMyCriticalSection);

End;
end;

procedure TDwnDocTitleMgr.Execute;
Var
  ID: String;
  Index,i : Integer;
  ADwnTitle : TADwnTitle;
  DwnCount : Integer;
  IntervalTime : Integer;
  FStartTime : TDate;
  FIsCreateIDTitleLstIdx : Boolean;
  FParse : TParseHtmLibMgr;
begin

 if Assigned(FOnDwnMsg) Then
     FOnDwnMsg(MsgNormal,ConvertString('���Ժ�,���ڽ���������߳���Ŀ.'));

  InitThreadDwn;
  //��ʼ��Ŀǰ�����dģʽ
  FHaveChangeDwnMode := false;
  ChangeDwnMode;
  FHaveChangeDwnMode := false;

  //ÿһ݆ޒ�z������
  DwnCount := 3;

  FIsCreateIDTitleLstIdx := False;

  //�����ѽ��۷e�����d���攵���ļo�
  FNeedDwnTitleCount := 0;

try
  While True Do
  Begin
   Try
      Application.ProcessMessages;
      Sleep(50);
      //Continue;

      //����������^���Пo���e�Ͳ����ٽ���
      if Not FIsCreateIDTitleLstIdx Then
      Begin
         if Assigned(FOnDwnMsg) Then
           FOnDwnMsg(MsgNormal,ConvertString('��ʼ�������嵥(doclst.dat)�ı�������.'));
         //��DocLst.dat���,�������}������,���Á��ֹ���}
         CreateIDTitleLstIdx(FTr1DBPath);
         //����������^���Пo���e�Ͳ����ٽ���
         FIsCreateIDTitleLstIdx := True;
      End;

      if FIDLstMgr.IDList.Count=0 Then
      Begin
          FOnDwnMsg(MsgError,ConvertString('���κδ���.'));
          //ˢ�´��a���,Ҳ�S�����µĴ��a���F
          FIDLstMgr.Refresh;
          FDwnDocTxtMgr.RefreshIDLst;
          Continue;
      End;

      //ȫ�������e�`�ĴΔ�
      FAllThreadFailCount := 0;

      //�ȳ�ʹ��ÿһ��ID��Log
      InitLogIDLst(FNeedDwnTitleCount);

      //݆ޒ�_ʼ֮ǰ,�xȡ�ϴδ��a�����d��r
      GetDwnLogFromFile(FNowDwnMode);

      //݆ޒ�_ʼ֮ǰ,ˢ�´��a�Ġ�B�@ʾ
      Self.Synchronize(ClearIDStatus);
      Self.Synchronize(ResetIDStatus);

      FStartTime := Now;

      if Assigned(FOnDwnMsg) Then
      Begin
         Case FNowDwnMode of
              dwnHistory : FOnDwnMsg(MsgNormal,ConvertString('============= ��ʼ����"�����ʷ"���� ============='));
              dwnToday   : FOnDwnMsg(MsgNormal,ConvertString('============= ��ʼ����"��������"���� ============='));
         End;
      End;

      FParse := nil;

      //݆ޒ�_ʼ
      For i:=0 to DwnCount-1 do
      Begin
          //FOnDwnMsg(msgNormal,'***'+IntToStr(i)+'***');
          For index:=0 to FIDLstMgr.IDList.Count-1 do
          Begin
              Application.ProcessMessages;
              //Sleep(50);
              if Self.Terminated Then
                Break;
              ID := FIDLstMgr.IDList.Strings[index];
              if Not IsNewID(ID) Then //������������ID,Ҳ���ǳɹ���ID,�Ǿ���ʧ����ID
              Begin
                if IsSuccessID(ID) Then
                   ID := ''
                Else
                   DelIDFormFailLst(ID); //�h��ʧ���� ID �o��������d
              End;

              if Length(ID)>0 Then
              Begin
                  if Not Assigned(FParse) Then
                    //Modify By JoySun 2005/10/20
                    FParse := TParseHtmLibMgr.Create(ExtractFilePath(Application.ExeName),FDwnMemo,PChar(ExtractFilePath(Application.ExeName)+'setup.ini'));
                  ADwnTitle := GetThreadDwn;
                  if Assigned(ADwnTitle) Then
                  Begin
                     ADwnTitle.InitData(ID,FParse,99,FNowDwnMode,FDocTitleTdxLst.Add);
                     FDwnIDLst.Add(ADwnTitle);
                     //ˢ���@ʾ
                     FOnNowDwnID(ID,2,FNowDwnMode,
                                  FDwnSuccessIDLst.Count,
                                  FDwnFailIDLst.Count,
                                  FNeedDwnTitleCount);
                  End;
              End;

              //�Ѽ�����Threadcount(5)��
              if FDwnIDLst.Count=FDocTitleThreadCount Then
              Begin

                //*************************
                DwnDocTitle;
               //*************************

                 //�������dģʽ�Ƿ��и�׃
                 if ChangeDwnMode Then
                   Break;

              End;

          End;
          if Self.Terminated Then
             Break;

          if FDwnIDLst.Count>0 then
             DwnDocTitle;

          //�������dģʽ�Ƿ��и�׃
          if ChangeDwnMode Then
             Break;

      End;
      //݆ޒ�Y��

      if Assigned(FParse) Then
        FParse.Destroy;

      FOnDwnMsg(msgNormal,ConvertString('�˴���Ѱ�������'));
      FOnDwnMsg(msgNormal,Format(ConvertString('������ʱ�� : %s ~  %s'),
                       [FormatDateTime('yyyy-mm-dd hh:mm:ss',FStartTime),FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)]));
      FOnDwnMsg(msgNormal,Format(ConvertString('����Ѱ���� : %s ��,�ɹ� %s ��,ʧ�� %s ��'),[
                       IntToStr(FIDLstMgr.IDList.Count),IntToStr(FDwnSuccessIDLst.Count),
                       IntToStr(FDwnFailIDLst.Count)]));
      FOnDwnMsg(msgNormal,Format(ConvertString('��Ҫ���ع��� : %s ��'),[IntToStr(FNeedDwnTitleCount)]));

      //���o䛱�����
      //SaveTodayDwnTitleCount(FNeedDwnTitleCount,FOutPutHtmlPath);

      if Self.Terminated or ChangeDwnMode Then //���Д�
      Begin
           if Assigned(FOnDwnMsg) Then
              FOnDwnMsg(MsgNormal,ConvertString('============= ���ع����ж� ============='));
      End Else
      Begin
          //�����Y��

          //��һ݆ޒ�Y���t�����һ݆ޒ�Ġ�B
          FDwnSuccessIDLst.Clear;
          FDwnFailIDLst.Clear;
          SaveDwnLogToFile(FNowDwnMode);
          //---------------------

          if Assigned(FOnDwnMsg) Then
             FOnDwnMsg(MsgNormal,ConvertString('============= ���ع������ ============='));



          if Assigned(FOnDwnMsg) Then
             FOnDwnMsg(MsgNormal,
                ConvertString(Format('============= %d���Ӻ�,�������� =============',[AMainFrm.FParam.DocSleep])));


          //�������^�m
          IntervalTime  := 0;
          While  Not Self.Terminated Do
          Begin
                Application.ProcessMessages;
                Sleep(50);
                Inc(IntervalTime);
                if IntervalTime>20*60*AMainFrm.FParam.DocSleep Then
                //if IntervalTime>20*10*0.5 Then
                   Break;
                //�������dģʽ�Ƿ��и�׃
                if ChangeDwnMode Then
                   Break;
          End;
      End;

      //add by wangjinhua 20090602 Doc4.3
      FIDLstMgr.Refresh;
      FDwnDocTxtMgr.RefreshIDLst;
      AMainFrm.ResetIDLstBox;
      AMainFrm.GetStartDate(FIDLstMgr.IDList);//DOC4.2-N001-sun-090610
      FOnDwnMsg(MsgNormal,ConvertString('Initial IDList.'));
      //--

      //���ģʽ��׃�tˢ�´��a��μ��ɣ�����п��������µĴ��a
      if ChangeDwnMode Then
      Begin
          {delete by wangjinhua 20090602 Doc4.3
          //ˢ�´��a���,Ҳ�S�����µĴ��a���F
          FIDLstMgr.Refresh;
          FDwnDocTxtMgr.RefreshIDLst;
          //******DOC4.2-N001-sun-090610********
            AMainFrm.GetStartDate(FIDLstMgr.IDList);
          //*********************************
          }
          //���ÿһ��ID��Log
          ClearLogIDLst;

          //ģʽ��׃�����׃�������
          FHaveChangeDwnMode := false;
      End;

      if Self.Terminated Then
         Break;

   Except
     On E:Exception do
       if Assigned(FOnDwnMsg) Then
          FOnDwnMsg(msgError,E.Message);
   End;

  End;

Finally

End;

end;

procedure TDwnDocTitleMgr.FreeThreadDwn;
Var
 i : Integer;
begin

  For i:=0 to High(FDwnThreadList) do
  Begin
    FDwnThreadList[i].Terminate;
    //if FDwnThreadList[i].Suspended Then
    //    FDwnThreadList[i].Resume;
    FDwnThreadList[i].WaitFor;
    FDwnThreadList[i].Destroy;
  End;
  SetLength(FDwnThreadList,0);

end;

procedure TDwnDocTitleMgr.GetDwnLogFromFile(dwnMode:TDwnMode);
Var
  Str : String;
begin

try

  Str := '.log';
  Case dwnMode of
      dwnToday : Str := '_Today.log';
    dwnHistory : Str := '_History.log';
  End;

  FDwnSuccessIDLst.Clear;
  FDwnFailIDLst.Clear;

  if FileExists(FOutPutHtmlPath+'DwnSuccess'+Str) Then
     FDwnSuccessIDLst.LoadFromFile(FOutPutHtmlPath+'DwnSuccess'+Str);

  if FileExists(FOutPutHtmlPath+'DwnFail'+Str) Then
     FDwnFailIDLst.LoadFromFile(FOutPutHtmlPath+'DwnFail'+Str);

Except
End;

end;

procedure TDwnDocTitleMgr.GetLogIDLst();
Var
  ALog : PADocTitleLog;
  FileName : String;
  StrLst : _CStrLst2;
  f : TStringList;
  i,s : Integer;
begin
   if FDwnFailIDLogLst.Count=0 then Exit;

   f := TStringList.Create;
Try

   Filename := FOutPutHtmlPath+'Report\'+FLogIDLstDateStr+'.log';
   if Not FileExists(FileName) Then
      Exit;

   f.LoadFromFile(FileName);
   For s:=0 to f.Count-1 do
   Begin
     StrLst := DoStrArray2(f.Strings[s],#9);
     For i:=0 to FDwnFailIDLogLst.Count-1 do
     Begin
        ALog := FDwnFailIDLogLst.Items[i];
        if ALog.ID = StrLst[0] Then
        Begin
          ALog.DwnSuccess := StrToInt(StrLst[1]);
          ALog.DwnUrl     := StrLst[2];
          ALog.DwnTitleCount := StrToInt(StrLst[3]);
          ALog.DwnFailTime   := StrToDateTime(StrLst[4]);
          ALog.DwnFailMsg    := StrLst[5];
          Break;
        End;
      end;
   End;

Finally
  f.Destroy;
end;

end;

function TDwnDocTitleMgr.GetThreadDwn: TADwnTitle;
Var
 i : Integer;
begin

  Result := nil;
  For i:=0 to High(FDwnThreadList) do
    if (Not FDwnThreadList[i].FBeUse) Then
    Begin
       Result := FDwnThreadList[i];
       Result.FBeUse := True;
       Break;
    End;

  if Result=nil Then
     Sleep(1);

end;

procedure TDwnDocTitleMgr.InitLogIDLst(Var NeedDwnTitleCount:Integer);
Var
  ALog  : PADocTitleLog;
  index : Integer;
begin
  if FDwnFailIDLogLst.Count=0 Then      
  Begin    
    For index:=0 to FIDLstMgr.IDList.Count-1 do    
    Begin    
       New(ALog);    
       ALog.ID := FIDLstMgr.IDList.Strings[index];    
       ALog.DwnSuccess := 0;    
       ALog.DwnUrl := '';    
       ALog.DwnTitleCount := 0;    
       ALog.DwnFailTime := 0;    
       ALog.DwnFailMsg  := '';    
       FDwnFailIDLogLst.Add(ALog);    
    End;    

    //������ڲ�һ��,�͚w0    
    ResetLogIDLstToZero(NeedDwnTitleCount);    

    GetLogIDLst;    

    //Ӌ��������ѽ��۷e�����d���攵���ļo�
    NeedDwnTitleCount := 0;
    For index:=0 to FDwnFailIDLogLst.Count-1 do    
      NeedDwnTitleCount := NeedDwnTitleCount+    
          PADocTitleLog(FDwnFailIDLogLst.Items[index]).DwnTitleCount;    
  End;

end;

procedure TDwnDocTitleMgr.InitThreadDwn;
Var
 i : Integer;
begin
  SetLength(FDwnThreadList,FDocTitleThreadCount);
  For i:=0 to High(FDwnThreadList) do
  Begin
    FDwnThreadList[i] :=  TADwnTitle.Create(FDocTitleTdxLst,   
                                            FTr1DBPath, 
                                            FOutPutDataPath, 
                                            FOutPutHtmlPath); 
    FDwnThreadList[i].Resume; 

    While not (FDwnThreadList[i].FExecute)do 
      Application.ProcessMessages;
  End;
end;

function TDwnDocTitleMgr.IsFailID(ID: String): Boolean;
Var
  i : Integer;
begin

   Result := false;
   for i:=0 to FDwnFailIDLst.Count-1 do
      if FDwnFailIDLst.Strings[i]=ID Then
      Begin
          Result := True;
          Break;
      End;

end;

function TDwnDocTitleMgr.IsNewID(ID: String): Boolean;
begin

   Result := False;
   if IsSuccessID(ID) Then
      Exit;
   if IsFailID(ID) Then
      Exit;
   Result := True;

end;

function TDwnDocTitleMgr.IsSuccessID(ID: String): Boolean;
Var
  i : Integer;
begin

   Result := false;
   for i:=0 to FDwnSuccessIDLst.Count-1 do
      if FDwnSuccessIDLst.Strings[i]=ID Then
      Begin
          Result := True;
          Break;
      End;

end;


procedure TDwnDocTitleMgr.ResetIDStatus;
Var
  Index : Integer;
begin

Try
  For Index:=0 to FDwnSuccessIDLst.Count-1 do
      FOnNowDwnID(FDwnSuccessIDLst.Strings[Index],0,FNowDwnMode,
               FDwnSuccessIDLst.Count,FDwnFailIDLst.Count,FNeedDwnTitleCount);

  For Index:=0 to FDwnFailIDLst.Count-1 do
      FOnNowDwnID(FDwnFailIDLst.Strings[Index],1,FNowDwnMode,
                 FDwnSuccessIDLst.Count,FDwnFailIDLst.Count,FNeedDwnTitleCount);
Except
End;

end;

procedure TDwnDocTitleMgr.ResetLogIDLst(ADwnTitle: TADwnTitle;Var NeedDwnTitleCount:Integer);
Var
   ALog : PADocTitleLog;
   i : Integer;
begin

Try

   if Not Assigned(ADwnTitle) Then
      Exit;

   //������ڲ�һ��,�͚w0
   ResetLogIDLstToZero(NeedDwnTitleCount);

   if ADwnTitle.FDocTitleP.DwnStatus=1 Then
      //��Ӌ���ж��٘��}����d
      NeedDwnTitleCount := FNeedDwnTitleCount
                                  + ADwnTitle.FDocTitleP.NeedDwnTitleLst.Count;

   For i:=0 to FDwnFailIDLogLst.Count-1 do
   Begin
        ALog := FDwnFailIDLogLst.Items[i];
        if ALog.ID = ADwnTitle.FDocTitleP.ID Then
        Begin
            ALog.DwnSuccess := ADwnTitle.FDocTitleP.DwnStatus;
            if ADwnTitle.FDocTitleP.DwnStatus=1 Then
            Begin
                ALog.DwnUrl := '';      //
                ALog.DwnFailTime := 0;
                ALog.DwnFailMsg := '';
            End Else
            Begin
                ALog.DwnUrl := ADwnTitle.FDwnUrl;
                ALog.DwnFailMsg :=ADwnTitle.FErrMsg;
                if ALog.DwnFailTime=0 Then
                   ALog.DwnFailTime := Now;
            End;
            ALog.DwnTitleCount := ALog.DwnTitleCount +
                                      ADwnTitle.FDocTitleP.NeedDwnTitleLst.Count;
            Break;
        End;
   End;
Except
End;
end;

procedure TDwnDocTitleMgr.ResetLogIDLstToZero(Var NeedDwnTitleCount:Integer);
Var
   ALog : PADocTitleLog;
   i : Integer;
begin

   //������ڲ�һ��,�͚w0
   if FLogIDLstDateStr<>FormatDateTime('yymmdd',Date) Then
   Begin
       For i:=0 to FDwnFailIDLogLst.Count-1 do
       Begin
          ALog := FDwnFailIDLogLst.Items[i];
          ALog.DwnTitleCount := 0;
       End;
       NeedDwnTitleCount := 0;
       FLogIDLstDateStr  := FormatDateTime('yymmdd',Date);
   End;

end;

procedure TDwnDocTitleMgr.SaveDwnLogToFile(dwnMode:TDwnMode);
Var
  Str : String;
begin
Try
   Str := '.log';
   Case dwnMode of
      dwnToday : Str := '_Today.log';
    dwnHistory : Str := '_History.log';
   End;
   FDwnSuccessIDLst.SaveToFile(FOutPutHtmlPath+'DwnSuccess'+Str);
   FDwnFailIDLst.SaveToFile(FOutPutHtmlPath+'DwnFail'+Str);
Except
End;
end;

procedure TDwnDocTitleMgr.SaveLogIDLst(Var NeedDwnTitleCount:Integer);
Var
  ALog : PADocTitleLog;
  FileName : String;
  f : TStringList;
  i : Integer;
begin

   if FDwnFailIDLogLst.Count=0 then Exit;

   EnterCriticalSection(csMyCriticalSection);
   f := TStringList.Create;
Try

   //������ڲ�һ��,�͚w0
   ResetLogIDLstToZero(NeedDwnTitleCount);

   Filename := FOutPutHtmlPath+'Report\'+FLogIDLstDateStr+'.log';
   MkDir_Directory(ExtractFilePath(FileName));

   For i:=0 to FDwnFailIDLogLst.Count-1 do
   Begin
     ALog := FDwnFailIDLogLst.Items[i];
     if ALog.DwnSuccess>0 Then //ֻҪ����ɹ���ʧ����
     Begin
      f.Add(ALog.ID+#9   //2305
           +IntToStr(ALog.DwnSuccess)+#9 //1
           +ALog.DwnUrl+#9 //url
           +IntToStr(ALog.DwnTitleCount)+#9   // 0
           +DateTimeToStr(ALog.DwnFailTime)+#9
           +ALog.DwnFailMsg);
     End;
   End;

   f.SaveToFile(FileName);

Finally
  f.Destroy;
  LeaveCriticalSection(csMyCriticalSection);

end;

end;

procedure TDwnDocTitleMgr.SetThreadDwnNotUse(ADwnTitle: TADwnTitle);
begin
   FDocTitleTdxLst.DeleteItem(ADwnTitle.FDocTitleP.AItem);
   ADwnTitle.Clear;
   ADwnTitle.FBeUse := False;
end;

{ TAMainFrm }

function TAMainFrm.ReloadIDLst:Boolean;
begin

    Result := false;

Try

    ListBox_ID.Clear;
    FIDCount   := 0;

    if Assigned(FIDLstMgr) Then
       FIDLstMgr.Destroy;
    FIDLstMgr := nil;

    case FParam.DwnMemo of
      0: FIDLstMgr := TIDLstMgr2.Create(FParam.Tr1DBPath,False,True,M_OutPassaway_P_All);  //---Doc3.2.0����1 huangcq080923 modify
      1: FIDLstMgr := TIDLstMgr2.Create(FParam.Tr1DBPath,False,True,M_OutPassaway_P_All); //---Doc3.2.0����1 huangcq080923 modify
    end;
    

    if FIDLstMgr.IDList.Count=0 Then
       Raise Exception.Create(Format(ConvertString('%s Ŀ¼�����κδ���.'),[FParam.Tr1DBPath]));

    Result := True;

Finally
End;

end;


Procedure TAMainFrm.OnAppExcept(Sender: TObject; E: Exception);
const CFmtFile='%sData\DwnDocLog\Doc_DwnHtml\%s.log';
var aFile:string;
begin
  aFile:=Format(CFmtFile,[
  ExtractFilePath(ParamStr(0)),
  FormatDateTime('yyyymmdd',now)
  ]);
  AddTextToFile(aFile,e.Message);
  E:=nil;
end;

procedure TAMainFrm.FormCreate(Sender: TObject);
begin

Try
  Application.OnException:=OnAppExcept;
  InitializeCriticalSection(csMyCriticalSection);

  NowIsRunning   := False;
  NewDay  :=true;

  InitObj;

  if ReloadParam Then
  Begin
    //--DOC4.0.0��N001 huangcq090407 add------>
    FStopRunningSkt := False;
    ASocketClientFrm := TASocketClientFrm.Create(Self,'Doc_DwnHtml',FParam.DocMonitorHostName
                                              ,FParam.DocMonitorPort,Msg_ReceiveDataInfo);

    TimerSendLiveToDocMonitor.Interval := 3000;
    TimerSendLiveToDocMonitor.Enabled  := True;
    //<------DOC4.0.0��N001 huangcq090407 add----
                 
    Act_RefreshReport.Enabled := False;

    //Caption :=ConvertString('̨�幫���ռ�(Ԫ��֤ȯ��վ)');
    Act_Cal.Caption    := ConvertString('��ʼ����');
    Act_Cal.Hint       := ConvertString('��ʼ����');
    Act_Stop.Caption   := ConvertString('ֹͣ����');
    Act_Stop.Hint      := ConvertString('ֹͣ����');
    Act_Setup.Caption  := ConvertString('�����趨');
    Act_Setup.Hint     := ConvertString('�����趨');
    Act_RefreshReport.Caption  := ConvertString('ˢ�±���');
    Act_RefreshReport.Hint     := ConvertString('ˢ�±���');
    Mnu_MainMenu.Caption :=   ConvertString('����');
    Mnu_Exit.Caption   :=   ConvertString('�뿪');
    TabSheet1.Caption  :=   ConvertString('��������');
    TabSheet2.Caption  :=   ConvertString('��������');
    Label_CBCount.Caption  :=   ConvertString('����תծ 0 �n');

    dxTreeList2.Columns[0].Caption := ConvertString('����');
    dxTreeList2.Columns[1].Caption := ConvertString('����ҳ��');
    dxTreeList2.Columns[2].Caption := ConvertString('״̬');
    dxTreeList2.Columns[3].Caption := ConvertString('����');

    dxTreeList1.Columns[0].Caption := ConvertString('����');
    dxTreeList1.Columns[1].Caption := ConvertString('����');
    dxTreeList1.Columns[2].Caption := ConvertString('״̬')     ;
    dxTreeList1.Columns[3].Caption := ConvertString('����');

    TabSheet3.Caption  :=   ConvertString('��������״������');
    TabSheet4.Caption  :=   ConvertString('����״��');
    Label3.Caption  :=   ConvertString('�ۼ����ش��� 0 �n');
    Report_DwnTitle.Columns[0].Caption := ConvertString('����');
    Report_DwnTitle.Columns[1].Caption := ConvertString('�ۼƱ���');
    Report_DwnTitle.Columns[2].Caption := ConvertString('ʱ��');
    Report_DwnTitle.Columns[3].Caption := ConvertString('״̬');
    Report_DwnTitle.Columns[4].Caption := ConvertString('��ַ');

    TabSheet5.Caption  :=   ConvertString('����״��');
    Label4.Caption  :=   ConvertString('�ۼ����ش��� 0 �n');
    Report_DwnTxt.Columns[0].Caption := ConvertString('����');
    Report_DwnTxt.Columns[1].Caption := ConvertString('ʱ��');
    Report_DwnTxt.Columns[2].Caption := ConvertString('����');
    Report_DwnTxt.Columns[3].Caption := ConvertString('����');
    Report_DwnTxt.Columns[4].Caption := ConvertString('��ַ');

    PageControl1.ActivePageIndex := 0;

    ClearMsg;

    Show;

    if FParam.AutoDwnGet Then //�Ƿ��Ԅ��M�����d
    if StartGet Then
       ClearMsg;
  End Else
  Begin
     ShowMessage(ConvertString('ϵͳ�������ش���.'));
     Halt;
  End;

Except
  on E:Exception Do
  Begin
    ShowMessage(E.Message);
    Halt;
  End;
End;
end;

procedure TAMainFrm.ShowErrStatus(Msg: String);
begin

   //�l���e�`������
   //SendToSoundServer('GET_DOC_ERROR',Msg,svrMsgError);//--DOC4.0.0��N001 huangcq090407 del
   SendDocMonitorWarningMsg('DwnHtml '+Msg+' $E008');//--DOC4.0.0��N001 huangcq090407 add

   if ListBox2.Count>50 Then
      ListBox2.Clear;
   Msg := '[Error]['+FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)+']'+Msg;
   if ListBox2.Count>0 Then
     if ListBox2.Items[ListBox2.Count-1]=Msg Then
        Exit;
   ListBox2.ItemIndex :=
       ListBox2.Items.Add(Msg);
   SaveLogMsg(Msg);

end;


procedure TAMainFrm.ShowMsgStatus(Msg: String);
begin
  
   if ListBox2.Count>50 Then
      ListBox2.Clear;
   Msg := '[Message]['+FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)+'] '+Msg;
   if ListBox2.Count>0 Then
     if ListBox2.Items[ListBox2.Count-1]=Msg Then
        Exit;
   ListBox2.ItemIndex :=
      ListBox2.Items.Add(Msg);
   SaveLogMsg(Msg);

end;

procedure TAMainFrm.SetNowIsRunning(const Value: Boolean);
begin

  Act_Cal.Enabled    := Not Value;
  Act_Stop.Enabled   := Value;
  Act_Setup.Enabled  := Not Value;

  FNowIsRunning := Value;
  
end;

procedure TAMainFrm.ClearMsg;
begin
  ListBox2.Clear;
  ShowNowDwnIDCountMsg(dwnNone,0,0,0);
  OnNowDwnTxt(0,0,0);
end;

procedure TAMainFrm.FreeObj;
begin

     if Assigned(FDwnDocTitleMgr) Then
     Begin
        FDwnDocTitleMgr.Terminate;
        FDwnDocTitleMgr.WaitFor;
        FDwnDocTitleMgr.Destroy;
        FDwnDocTitleMgr := nil;
     End;

     if Assigned(FIDLstMgr) Then
        FIDLstMgr.Destroy;
     FIDLstMgr := nil;

     if Assigned(FParam) Then
        FParam.Destroy;
     FParam := nil;

     if Assigned(FDocTxtTdxTreeListMgr) Then
     Begin
         FDocTxtTdxTreeListMgr.Terminate;
         FDocTxtTdxTreeListMgr.WaitFor;
         FDocTxtTdxTreeListMgr.Destroy;
     End;
     FDocTxtTdxTreeListMgr := nil;

     if Assigned(FDocTitleTdxTreeListMgr) Then
     Begin
         FDocTitleTdxTreeListMgr.Terminate;
         FDocTitleTdxTreeListMgr.WaitFor;
         FDocTitleTdxTreeListMgr.Destroy;
     End;
     FDocTitleTdxTreeListMgr := nil;

     if Assigned(FLogMgr) Then
        FLogMgr.Destroy;
     FLogMgr := nil;

    // DisConnectSoundServer; //--DOC4.0.0��N001 huangcq090407 del

    //--DOC4.0.0��N001 huangcq090407 add--->
    FStopRunningSkt := True;
    TimerSendLiveToDocMonitor.Interval := 1;
    While TimerSendLiveToDocMonitor.Enabled  and
        (TimerSendLiveToDocMonitor.Tag=1) Do
    Application.ProcessMessages;

    if ASocketClientFrm<>nil Then
    Begin
       ASocketClientFrm.ClearObj;
       ASocketClientFrm.Destroy;
       ASocketClientFrm:=nil;
    End;
    //<-----DOC4.0.0��N001 huangcq090407 add--     


end;

procedure TAMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

   if NowIsRunning Then
   Begin
       ShowMessage(ConvertString('Ŀǰ����ִ���޷��뿪.'));
       Action := caNone;
   End Else
   Begin
       FreeObj;
       Action:=caFree;
   End;

end;

procedure TAMainFrm.Act_StopExecute(Sender: TObject);
begin
  StopGet;
end;

procedure TAMainFrm.OnDwnMsg(Status: TMsgStatus; Msg: ShortString);
begin
   Case Status of
     MsgNormal : ShowMsgStatus(Msg);
     MsgError  : ShowErrStatus(Msg);
   End;
end;

procedure TAMainFrm.OnNowDwnID(ID: ShortString;DwnSuccess:Byte;DwnMode:TDwnMode;
SuccessCount,FailCount,DwnTxtCount:Integer);
Var
  i : Integer;
begin

Try

  if Length(ID)=0 Then
  Begin
     ResetIDLstBox;
     Exit;
  End Else
  Begin
     For i := 0 to ListBox_ID.Count-1 do
     if GetIDReplaceTag(ListBox_ID.Items[i])=ID Then
     Begin
         ListBox_ID.Items[i] :=
              SetIDReplaceTag(ListBox_ID.Items[i],DwnSuccess);
         ListBox_ID.ItemIndex := i;
         Break;
     End;
  End;

 ShowNowDwnIDCountMsg(DwnMode,SuccessCount,FailCount,DwnTxtCount);

Except;
End;

end;

function TAMainFrm.GetIDReplaceTag(ID: ShortString): ShortString;
Var
 AID : String;
begin
  AID := ID;
  ReplaceSubString(' (OK)','',AID);
  ReplaceSubString(' (FAIL)','',AID);
  Result := AID;
end;

function TAMainFrm.SetIDReplaceTag(ID: ShortString; Success: Byte): ShortString;
begin
   Case Success of
      0: Result := GetIDReplaceTag(ID)+' (OK)';
      1: Result := GetIDReplaceTag(ID)+' (FAIL)';
      2: Result := ID;
   End;
end;

procedure TAMainFrm.ShowNowDwnIDCountMsg(DwnMode:TDwnMode;SuccessCount,FailCount,DwnTxtCount:Integer);
//Var
// ErrRate : Double;
begin

Try

  {ErrRate := 0;
  if FIDCount>0 Then
     ErrRate := Round((FailCount/FIDCount)*100);
  }
  if FailCount>=0 Then
  Begin
     Label1.Caption := Format(ConvertString('�˴����ش��룺�ɹ� %s �������� %s ��  /  ���������ع��棺%s ��'),
                        [IntToStr(SuccessCount),IntToStr(FailCount),
                         IntTostr(DwnTxtCount)]);
  End Else
     Label1.Caption := '';

Except
End;
end;

procedure TAMainFrm.SaveLogMsg(Msg: String);
begin
  FLogMgr.SaveLog(Msg);
end;


procedure TAMainFrm.ResetIDLstBox;
Var
 i : Integer;
begin

     ListBox_ID.Clear;
     FIDCount := 0;

     if Assigned(FIDLstMgr) Then
        For i:=0 to FIDLstMgr.IDList.Count-1 do
           ListBox_ID.Items.Add(FIDLstMgr.IDList.Strings[i]);

     Label_CBCount.Caption := Format(ConvertString('���д��� %s �n'),[IntToStr(ListBox_ID.Count)]);

     FIDCount   := ListBox_ID.Count;

     ShowNowDwnIDCountMsg(dwnNone,0,0,0);

end;

Function  TAMainFrm.StartGet:Boolean;
Var
  OutPutDataPath : String;
begin

  Result := false;

  if NowIsRunning Then
     Exit;
  if FNowIsStartGet Then
     Exit;

  FNowIsStartGet := True;
  FStopRunning   := False;
  NowIsRunning   := True;

  ClearMsg;

Try
Try
   //add by wjh 2011-10-14
   if not ReloadIDLst Then
   begin
     ShowMsgStatus(ConvertString('���ش����б�ʧ��'));
     exit;
   end;
   //--
   if(not FParam.TodayCheckIdxIsOK)then
   begin
     ShowMsgStatus(ConvertString('����������������Ժ�...'));
     if CheckDoc then
     begin
       FParam.SetTodayCheckIdxIsOK;
       ShowMsgStatus(ConvertString('���������Լ��ɹ�'));
     end
     else
       ShowMsgStatus(ConvertString('���������Լ��ʧ��'));

   end;

   ShowMsgStatus(ConvertString('��ʼ���������Ժ�...'));

   OutPutDataPath      := ExtractFilePath(Application.ExeName)+'Data\';
   Mkdir_Directory(OutPutDataPath);

   While Not  Result Do
   Begin
      Try

       if FStopRunning Then
          Exit;
       if ReloadIDLst Then
       Begin

         if Assigned(FDwnDocTitleMgr) Then
         Begin
            FDwnDocTitleMgr.Terminate;
            FDwnDocTitleMgr.WaitFor;
            FDwnDocTitleMgr.Destroy;
         End;
         FDwnDocTitleMgr := nil;

         if Assigned(FDwnDocTxtMgr) Then
         Begin
           FDwnDocTxtMgr.Terminate;
           FDwnDocTxtMgr.WaitFor;
           FDwnDocTxtMgr.Destroy;
           FDwnDocTxtMgr := nil;
         End;


         if Assigned(FDocTxtTdxTreeListMgr) Then
         Begin
            FDocTxtTdxTreeListMgr.Terminate;
            FDocTxtTdxTreeListMgr.WaitFor;
            FDocTxtTdxTreeListMgr.Destroy;
         End;
         FDocTxtTdxTreeListMgr := nil;

         if Assigned(FDocTitleTdxTreeListMgr) Then
         Begin
            FDocTitleTdxTreeListMgr.Terminate;
            FDocTitleTdxTreeListMgr.WaitFor;
            FDocTitleTdxTreeListMgr.Destroy;
         End;
         FDocTitleTdxTreeListMgr := nil;

         //Free���е�Http Lib
         _FreeHttpTxt;

         FDocTxtTdxTreeListMgr := TTdxTreeListMgr.Create(dxTreeList1,FDwnDocTxtThreadCount);
         FDocTxtTdxTreeListMgr.Resume;

         FDocTitleTdxTreeListMgr := TTdxTreeListMgr.Create(dxTreeList2,FDwnDocTitleThreadCount);
         FDocTitleTdxTreeListMgr.Resume;

         //��ʼ���������ʼ�������� �� �б��ļ�
         GetStartDate(FIDLstMgr.IDList);//Doc4.2-N001-sun-090610

         //��ʼ�����е�Http Lib
         _InitDwnHttp(FDwnDocTxtThreadCount+FDwnDocTitleThreadCount);


         //���d�����ݵľ���
         FDwnDocTxtMgr := TDwnDocTxtMgr.Create(FParam.Tr1DBPath,OutPutDataPath,
                               FIDLstMgr,FDwnDocTxtThreadCount,
                               FDocTxtTdxTreeListMgr,OnNowDwnTxt);
         FDwnDocTxtMgr.Resume;


         //���d���}
         FDwnDocTitleMgr := TDwnDocTitleMgr.Create(FParam.Tr1DBPath,OutPutDataPath,
                                   FIDLstMgr,FDwnDocTxtMgr,FDwnDocTitleThreadCount,
                                   FDocTitleTdxTreeListMgr,OnDwnMsg,OnNowDwnID);

         FDwnDocTitleMgr.Resume;

         Result := True;

       End;
      Except
         On E:Exception Do
           ShowErrStatus(E.Message);
      End;
      if Not Result Then
      Begin
         ShowErrStatus(ConvertString('��ʼ��ʧ��.5������³�ʼ��...'));
         //Application.ProcessMessages; //DOC4.0.0��N001 huangcq090407 add ��ֹһֱִ�б�ѭ��ʱû�д��� Msg_ReceiveDataInfo ��ص������¼�
         SleepWait(5);
      End;
   End;

Except
End;
Finally

  FNowIsStartGet := False; //��Ɇ���

  if Not Result Then
     if FStopRunning Then
        StopGet;

End;

end;

procedure TAMainFrm.StopGet;
begin
     if FNowIsStopGet Then
        Exit;

     FNowIsStopGet := True;
     FStopRunning := True;

Try
Try
     if  FNowIsStartGet Then
         Exit;

     ShowMsgStatus(ConvertString('����ֹͣ��������,���Ժ�..'));
     if Assigned(FDwnDocTitleMgr) Then
     Begin
         FDwnDocTitleMgr.Terminate;
         FDwnDocTitleMgr.WaitFor;
         FDwnDocTitleMgr.Destroy;
         FDwnDocTitleMgr := nil;
     End;

     ShowMsgStatus(ConvertString('����ֹͣ��������,���Ժ�..'));
     if Assigned(FDwnDocTxtMgr) Then
     Begin
           FDwnDocTxtMgr.Terminate;
           FDwnDocTxtMgr.WaitFor;
           FDwnDocTxtMgr.Destroy;
           FDwnDocTxtMgr := nil;
     End;

     if Assigned(FDocTxtTdxTreeListMgr) Then
     Begin
         FDocTxtTdxTreeListMgr.Terminate;
         FDocTxtTdxTreeListMgr.WaitFor;
         FDocTxtTdxTreeListMgr.Destroy;
     End;
     FDocTxtTdxTreeListMgr := nil;

     if Assigned(FDocTitleTdxTreeListMgr) Then
     Begin
         FDocTitleTdxTreeListMgr.Terminate;
         FDocTitleTdxTreeListMgr.WaitFor;
         FDocTitleTdxTreeListMgr.Destroy;
     End;
     FDocTitleTdxTreeListMgr := nil;

     //Free���е�Http Lib
     ShowMsgStatus(ConvertString('����ֹͣ���е������߳�,���Ժ�..'));
     _FreeHttpTxt;

     NowIsRunning := false;

     ShowMsgStatus(ConvertString('ֹͣ�ɹ�'));

Except
  On E: Exception Do
    ShowMessage(E.Message);
End;
Finally
  FNowIsStopGet := False;;
End;

end;

function TAMainFrm.ReloadParam: Boolean;
begin
    Result := false;
Try
try

    if Not Assigned(FParam) Then
    Begin
       FParam := TGetDocMgrParam.Create(ExtractFilePath(Application.ExeName))
    End  Else
       FParam.Refresh;


    //�B�򾯸������
    //ConnectToSoundServer(FParam.SoundServer,FParam.SoundPort); //--DOC4.0.0��N001 huangcq090407  del

    FDwnDocTitleThreadCount   := FParam.DwnDocTitleThreadCount;
    FDwnDocTxtThreadCount     := FParam.DwnDocTxtThreadCount;
    FDwnTodayDocStartTime     := FParam.DwnTodayDocStartTime;
    FDwnHistoryDocStartTime   := FParam.DwnHistoryDocStartTime;
    FDwnDocTitleErrCount      := FParam.DwnDocTitleErrCount;
    FDwnDocTxtErrCount        := FParam.DwnDocTxtErrCount;
    FDwnMemo                  := FParam.DwnMemo;

    //ˢ���@ʾ��B
    ShowSysStatus;

    Result := True;

Except
  On E:Exception Do
    ShowMessage(E.Message);
End;
Finally
end;
end;

procedure TAMainFrm.ShowSysStatus;
begin

  //add by JoySun 2005/10/19
  Case FDwnMemo of
    0: Caption := ConvertString('��½�����ռ�(�й�֤ȯ��-F10)');
    1: Caption := ConvertString('̨�幫���ռ�(Ԫ���A֤ȯ��-YuanTa)');
  end;

  StatusBar1.SimpleText :=
     Format(ConvertString('���ر����߳���Ŀ��%s ���������߳���Ŀ��%s �������¹���ʱ�䣺%s ������ʷ����ʱ�䣺%s'),
            [IntToStr(FParam.DwnDocTitleThreadCount),IntToStr(FParam.DwnDocTxtThreadCount),
            TimeToStr(FParam.DwnTodayDocStartTime),TimeToStr(FParam.DwnHistoryDocStartTime)]);

end;

procedure TAMainFrm.InitObj;
begin
   FLogMgr := TSaveLogMgr.Create(ExtractFilePath(Application.ExeName));
end;

procedure TAMainFrm.OnNowDwnTxt(DwnTxtCount, SuccessCount,
  FailCount: Integer);
begin

Try
     //Label2.Caption := Format(ConvertString('Ŀǰ�������أ����� %s  ���ɹ� %s  ��ʧ�� %s '),
     //                   [IntTostr(DwnTxtCount),IntToStr(SuccessCount),IntToStr(FailCount)]);
     Label2.Caption := Format(ConvertString('Ŀǰ�������أ�ʧ�� %s '),
                        [IntToStr(FailCount)]);
Except
End;

end;


procedure TAMainFrm.ShowDwnTitleReport;
Var
  ALogLst : Array of TADocTitleLog;
  FileName : String;
  StrLst : _CStrLst2;
  f : TStringList;
  TitleCount,s : Integer;
  AItem : TdxTreeListNode;

begin

   f := TStringList.Create;
   Report_DwnTitle.BeginUpdate;
   EnterCriticalSection(csMyCriticalSection);

Try

   Report_DwnTitle.ClearNodes;
   Filename := ExtractFilePath(Application.ExeName)+'Data\Html\Report\'+
        FormatDateTime('yymmdd',Date)+'.log';
   if Not FileExists(FileName) Then
      Exit;

   TitleCount := 0;
   f.LoadFromFile(FileName);
   SetLength(ALogLst,f.Count);
   For s:=0 to f.Count-1 do
   Begin
     StrLst := DoStrArray2(f.Strings[s],#9);
     ALogLst[s].ID := StrLst[0];
     ALogLst[s].DwnSuccess := StrToInt(StrLst[1]);
     ALogLst[s].DwnUrl     := StrLst[2];
     ALogLst[s].DwnTitleCount := StrToInt(StrLst[3]);
     ALogLst[s].DwnFailTime   := StrToDateTime(StrLst[4]);
     ALogLst[s].DwnFailMsg    := StrLst[5];

     TitleCount := TitleCount + ALogLst[s].DwnTitleCount;

   End;

   //��Show��ʧ����
   for s:=0 to High(ALogLst) Do
   Begin
     if ALogLst[s].DwnSuccess=2 Then    
     Begin  
       AItem := Report_DwnTitle.Add;  
       AItem.Strings[0] := ALogLst[s].ID;  
       AItem.Strings[1] := IntToStr(ALogLst[s].DwnTitleCount);  
       AItem.Strings[2] := DateTimeToStr(ALogLst[s].DwnFailTime);  
       AItem.Strings[3] := ALogLst[s].DwnFailMsg;  
       AItem.Strings[4] := ALogLst[s].DwnUrl;  
     End;
   End;

   Label3.Caption := Format(ConvertString('�ۼ����ش��� %s �n,�ۼƱ��� %s ��'),
          [IntToStr(Report_DwnTitle.Count),IntToStr(TitleCount)]);

   //��Show���ɹ���
   for s:=0 to High(ALogLst) Do
   Begin
     if ALogLst[s].DwnSuccess=1 Then
     Begin  
       AItem := Report_DwnTitle.Add;  
       AItem.Strings[0] := ALogLst[s].ID;  
       AItem.Strings[1] := IntToStr(ALogLst[s].DwnTitleCount);  
     End;
   End;

Finally
  SetLength(ALogLst,0);
  f.Destroy;
  Report_DwnTitle.EndUpdate;
  LeaveCriticalSection(csMyCriticalSection);
end;

end;

procedure TAMainFrm.ShowDwnTxtReport;
Var
  ALogLst : Array of TADocTxtLog;
  FileName : String;
  StrLst : _CStrLst2;
  f : TStringList;
  s : Integer;
  AItem : TdxTreeListNode;

begin

   f := TStringList.Create;
   Report_DwnTxt.BeginUpdate;
   EnterCriticalSection(csMyCriticalSection);

Try

   Report_DwnTxt.ClearNodes;
   Filename := ExtractFilePath(Application.ExeName)+'Data\Html\Report\DwnTxtFail.log';
   if Not FileExists(FileName) Then
      Exit;

   f.LoadFromFile(FileName);
   SetLength(ALogLst,f.Count);
   For s:=0 to f.Count-1 do
   Begin

     StrLst := DoStrArray2(f.Strings[s],#9);

     ALogLst[s].ID := StrLst[0];
     ALogLst[s].DwnUrl     := StrLst[1];

     //Modify By JoySun 2005/10/20
     ALogLst[s].DwnTitleCaption := ConvertString(StrLst[2],IntToStr(FDwnMemo));
     //ALogLst[s].DwnTitleCaption := StrLst[2];

     ALogLst[s].DwnTitleDate    := StrToFloat(StrLst[3]);
     ALogLst[s].DwnFailTime     := StrToDateTime(StrLst[4]);
     ALogLst[s].DwnFailMsg      := StrLst[5];
   End;

   //��Show��ʧ����
   for s:=0 to High(ALogLst) Do
   Begin
         AItem := Report_DwnTxt.Add;
         AItem.Strings[0] := ALogLst[s].ID;
         AItem.Strings[1] := DateTimeToStr(ALogLst[s].DwnFailTime);
         AItem.Strings[2] := FormatDateTime('yyyy-mm-dd',ALogLst[s].DwnTitleDate);
         AItem.Strings[3] := ALogLst[s].DwnTitleCaption;
         AItem.Strings[4] := ALogLst[s].DwnUrl;
   End;

   Label4.Caption := Format(ConvertString('�ۼ����ش��� %s ��'),
          [IntToStr(Report_DwnTxt.Count)]);


Finally
  SetLength(ALogLst,0);
  f.Destroy;
  Report_DwnTxt.EndUpdate;
  LeaveCriticalSection(csMyCriticalSection);
end;

end;

//*****Doc4.2-N001-sun-090610******
//*****�������ܣ��Ѵ����б��е�ÿһ���������ʼ�������ڼ�¼��ID_StartGetDate.lst��
procedure TAMainFrm.GetStartDate(IDList: TStringList);
var
  i,j,k : Integer;
  FIDStartGetLst,FTr1DBPath : String;
  ID:String;
  Strlst:TStringList;
  inifile,myinifile:Tinifile;
  F:Textfile;
  FStartDate : String;
begin

  //����������ʼ�������ڵ��ļ��Ƿ���ڣ������ڣ��򴴽�
  FIDStartGetLst := ExtractFilePath(Application.ExeName)+'ID_StartGetDate.lst';
  if not fileExists(FIDStartGetLst) then
  begin
    AssignFile(F,FIDStartGetLst);
    rewrite(F);  //����䴴��һ���ļ�
    closeFile(F);
  end;

  myinifile := Tinifile.create(ExtractFilePath(Application.ExeName)+'Setup.ini');
  FTr1DBPath := myinifile.ReadString('CONFIG','Tr1DBPath','');
  FStartDate := myinifile.ReadString('CONFIG','StartGetDate','');
  FStartDate := FormatDateTime('yyyy-mm-dd',StrToDate(FStartDate));

  StrLst := TStringList.Create;
  inifile := Tinifile.create(FIDStartGetLst);
  try
    StrLst.LoadFromFile(FIDStartGetLst);
    //�������д��� ���鿴��������ʼ�����Ƿ������ ID_StartGetDate.lst��
    //���û�У��ҵ���д���ļ�
    for i:=0 to IDList.Count-1 do
    begin
      ID := IDList.Strings[i];
      if inifile.ReadString(ID,'StartGetDate','')='' then
         inifile.writestring(ID,'StartGetDate',SearchStartDate(ID,FTr1DBPath,FStartDate));
    end;
  finally
    myinifile.Free;
    inifile.Free ;
    StrLst.Free ;
  end;


end;

//*****Doc4.2-N001-sun-090610*************************************
//*****�������ܣ���Ѱ�������ʼ��������****

function TAMainFrm.SearchStartDate(ID: string;
  FTr1DBPath: shortString;StartDate:String): string;
var
   DocDataLst: TStringList ;
   i:Integer;
   MaxDate,IDxPath:string;
   inifile: Tinifile;
begin
  Result := '' ;
  MaxDate := '' ;
  IDxPath := FTr1DBPath+'CBData\Document\DocLstIdx\'+ID+'.idx';
  if  fileExists(IDxPath) then
  begin
    DocDataLst := TStringList.Create ;
    DocDataLst.LoadFromFile(IDxPath);
    for i:=0 to DocDataLst.count-1 do
    begin
      if(pos('[D]',DocDataLst.Strings[i])=0) and (pos('/',DocDataLst.Strings[i])>0) then
      begin
        DocDataLst.Strings[i]:= copy(DocDataLst.Strings[i],length(DocDataLst.Strings[i])+1-10,10);
        if  DocDataLst.Strings[i] > MaxDate  then
            MaxDate := DocDataLst.Strings[i];
      end;
    end;
    if StartDate > MaxDate then    MaxDate :=  StartDate;
  end;
  if MaxDate='' then MaxDate := '1899-12-30' ;
  if StartDate > MaxDate then MaxDate :=  StartDate;
  Result := MaxDate;
end;



{ TDwnDocTxtMgr }

Function TDwnDocTxtMgr.AddTitle(Const ID: String; Const ATitleR: TTitleR):Boolean;
Var
 ADwnTxt : TADwnTxt;
begin

   Result := false;
   ADwnTxt := GetThreadDwn;
   if Assigned(ADwnTxt) Then
   Begin
      ADwnTxt.InitData(ID,ATitleR,FTdxLst.Add);
      FDocTxtLst.Add(ADwnTxt);
      Result := True;
   End;

end;

procedure TDwnDocTxtMgr.AddToNotDwnTitleLst(ID: String; ATitleLst: TStringList);
begin

  Try
  While ATitleLst.Count>0 do
  Begin
    FNotDwnTitleStrLst.Add(ID+'='+ATitleLst.Strings[0]);
    ATitleLst.Delete(0);
  End;
  Finally
  End;

end;

constructor TDwnDocTxtMgr.Create(Tr1DBPath,OutPutDataPath:String;
                          IDLstMgr:TIDLstMgr2;
                          DocTxtThreadCount : Integer;
                          ATdxLst : TTdxTreeListMgr;
                          OnNowDwnTxt : TOnNowDwnTxt);
begin

   FOnNowDwnTxt := OnNowDwnTxt;
   FIDLstMgr   := IDLstMgr;
   FDocTxtLst  := TList.Create;
   FDwnFailTxtLogLst := TList.Create;
   FDwnFailTitleLst := TList.Create;
   FNotDwnTitleStrLst  := TStringList.Create;
   FPackageFileNameLst := TStringList.Create;
   FDocTxtThreadCount := DocTxtThreadCount;
   FTdxLst := ATdxLst;

   FOutPutDataPath      := OutPutDataPath;
   FOutPutHtmlPath      := FOutPutDataPath+'Html\';
   FDwnTitleTxtPath     := FOutPutHtmlPath+'DocTxt\DwnTitleTxt\';
   FDwnFailTitleTxtPath := FOutPutHtmlPath+'DocTxt\DwnFailTitleTxt\';
   //FOutPutHtmlPath      := FOutPutHtmlPath+'DocTxt\HtmlTxt\';

   Mkdir_Directory(FOutPutHtmlPath);
   Mkdir_Directory(FDwnTitleTxtPath);
   Mkdir_Directory(FDwnFailTitleTxtPath);

   FreeOnTerminate := false;
   inherited Create(true);

end;

destructor TDwnDocTxtMgr.Destroy;
begin

   //�ȱ���߀δ���d�Ę��}
   SaveNotDwnTitleLst;
   FNotDwnTitleStrLst.Destroy;

   //������Ҫ���d��߀δ���d�Ę��}������ ��
   SaveDocTxtTitleLst;
   FDocTxtLst.Destroy;

   ClearDwnFailLogTxtLst;
   FDwnFailTxtLogLst.Destroy;

   FDwnFailTitleLst.Destroy;
   FPackageFileNameLst.Destroy;

   FreeThreadDwn;


end;

procedure TDwnDocTxtMgr.Execute;
Var
  Index : Integer;
  ID : String;
  IDLst : TStringList;
begin
  InitThreadDwn;
  IDLst  := TStringList.Create;
Try

  For index:=0 to FIDLstMgr.IDList.Count-1 do
     IDLst.Add(FIDLstMgr.IDList.Strings[index]);
  FNeedRefreshIDLst := False;

  //���o��x��
  GetDwnFailLogTxtLst; //Data\Html\Report\DwnTxtFail.log
  ChangeDwnCountMsg;

  While Not Self.Terminated Do
  Begin
  try
     //-----------------
     Application.ProcessMessages;
     Sleep(50);
     //Continue;

     AllDwnCount  := 0;
     SuccessCount := 0;
     FailCount    := 0;
     FAllThreadFailCount := 0;
     //ChangeDwnCountMsg;

     For index:=0 to IDLst.Count-1 do
     Begin
        //����յ�ˢ��ID��֪ͨ�t�ж�Ŀǰ�Ą���
        if FNeedRefreshIDLst Then
           Break;

        Application.ProcessMessages;
        Sleep(10);

        if Self.Terminated Then
           Break;

        ID := IDLst.Strings[index];

        //�ȱ���߀δ���d�Ę��}
        SaveNotDwnTitleLst;

        //ȡ����δ���d�Ę��}
        While GetDocTxtTitleLst(ID)>0 do
        Begin
           DwnDocTxt;
           if Self.Terminated Then
              Break;
        End;

        //��ʧ�������dȡ���ڴ����d
        if Not Self.Terminated Then
        Begin
          if GetDwnFailTitleLst(ID)>0 Then
              DwnDocTxt;
        End;

        //���Y�ϴ���錏�˵ĸ�ʽ
        //PackageDocTxt(ID);
     End;
     //----------------

     if Not Self.Terminated Then
     Begin
       if FNeedRefreshIDLst Then
       Begin
          IDLst.Clear;
          For index:=0 to FIDLstMgr.IDList.Count-1 do
              IDLst.Add(FIDLstMgr.IDList.Strings[index]);
          FNeedRefreshIDLst := False;
       End;
    End;

  Except
  End;
  End;

Finally
  IDLst.Destroy;
End;


end;

Function TDwnDocTxtMgr.GetDocTxtTitleLst(AID:String):Integer;
Var
 FileName : String;
 f : TStringList;
begin

   Result := 0;
   f := TStringList.Create;
try
try

   FileName := FDwnTitleTxtPath + AID+'_Title.txt';
   if FileExists(FileName) Then
   Begin
      f.LoadFromFile(FileName);
      While f.Count>0 do
      Begin
        if Not AddTitle(AID,StrToTitleR(f.Strings[0])) Then
           Break;
        f.Delete(0);
      End;
      if f.Count>0 Then
         f.SaveToFile(FileName)
      Else
         DeleteFile(FileName);
   End;
   Result := FDocTxtLst.Count;

except
End;
Finally
  if Assigned(f) Then
     f.Destroy;
End;



end;



procedure TDwnDocTxtMgr.SaveNotDwnTitleLst;
Var
  AID,ID,Str,FileName : string;
  f : TStringList;
begin

      if (FNotDwnTitleStrLst.Count=0) Then
          exit;

     f := TStringList.Create;
Try
try

      ID := '';
      FileName := '';
      While FNotDwnTitleStrLst.Count>0 do
      Begin
         GetIDAndTitleRStr(AID,Str,FNotDwnTitleStrLst.Strings[0]);
         if ID<>AID Then
         Begin
             if Length(ID)>0 Then
             Begin
                if f.Count>0 Then
                Begin
                   f.SaveToFile(FileName);
                End;
             End;
             f.Clear;
             ID := AID;
             FileName := FDwnTitleTxtPath + ID+'_Title.txt';
             if FileExists(FileName) Then
                f.LoadFromFile(FileName);
         End;
         if Length(ID)>0 Then
            AddStringList(f,Str);
            //f.Add(Str);
         FNotDwnTitleStrLst.Delete(0);
      End;

      if Length(ID)>0 Then
         if f.Count>0 Then
            f.SaveToFile(FileName);
      f.Clear;

Except
End;
Finally
  f.Destroy;
end;

end;

procedure TDwnDocTxtMgr.SaveDocTxtTitleLst;
Var
  f : TStringList;
  ID,FileName : string;
  ADwnTxt : TADwnTxt;
begin

      if (FDocTxtLst.Count=0) Then
          Exit;

      f := TStringList.Create;
Try
Try
      ID := '';
      FileName := '';
      While FDocTxtLst.Count>0 do
      Begin
         ADwnTxt :=  FDocTxtLst.Items[0];
         if ID<>ADwnTxt.FDocTxtP.ID Then
         Begin
             if Length(ID)>0 Then
             Begin
                if f.Count>0 Then
                   f.SaveToFile(FileName);
             End;
             f.Clear;
             ID := ADwnTxt.FDocTxtP.ID;
             FileName := FDwnTitleTxtPath + ID+'_Title.txt';
             if FileExists(FileName) Then
                f.LoadFromFile(FileName);
         End;
         if Length(ID)>0 Then
         Begin
            AddStringList(f,TitleRToStr(ADwnTxt.FDocTxtP.ATitleR));
         End;
            //f.Add(TitleRToStr(ADocTxtP.ATitleR));
         FDocTxtLst.Delete(0);
         SetThreadDwnNotUse(ADwnTxt);
      End;
      if Length(ID)>0 Then
         if f.Count>0 Then
            f.SaveToFile(FileName);
      f.Clear;

Except
End;
Finally
  f.Destroy;
end;


end;


procedure TDwnDocTxtMgr.GetIDAndTitleRStr(var ID,TitleRStr : String;Str:String);
Var
 j : Integer;
begin

      ID := '';
      TitleRStr := '';
      j:= Pos('=',Str);
      if j>0 Then
      Begin
          ID  := Copy(Str,1,j-1);
          TitleRStr := Copy(Str,j+1,Length(Str)-j);
      End;

end;

procedure TDwnDocTxtMgr.DwnDocTxt;
Var
  ADwnTxt : TADwnTxt;
  DelList : TList;
  i : Integer;
  HtmlTxt  : TStringList;
  MemoTxt : String;
  FParse : TParseHtmLibMgr;
  NeedSaveFailLog : Boolean;
  ThreadCount : Integer;
begin
  //inherited;

  if FDocTxtLst.Count=0 Then
     Exit;

  DelList  := TList.Create;
  HtmlTxt  := TStringList.Create;

  //ReleaseMemory(50);
   FParse := nil;
  NeedSaveFailLog := False;
Try                      

  //�Á��Д�˴�ʧ���ľ��̔�
  ThreadCount := FDocTxtLst.Count;

  if Self.Terminated Then
     Exit;

  //Modify By JoySun 2005/10/20
  FParse := TParseHtmLibMgr.Create(ExtractFilePath(Application.ExeName),FDwnMemo,PChar(ExtractFilePath(Application.ExeName)+'setup.ini'));

  for i:=0 to FDocTxtLst.Count-1 do
  Begin
        ADwnTxt := FDocTxtLst.Items[i];
        With ADwnTxt Do
        Begin
            FTdxLst.AddString(FDocTxtP.AItem,0,FDocTxtP.ID);
            //Modify By JoySun 2005/10/19
            FTdxLst.AddString(FDocTxtP.AItem,1,ConvertString(FDocTxtP.ATitleR.Caption,IntToStr(FDwnMemo)));
            FTdxLst.AddString(FDocTxtP.AItem,2,FDocTxtP.ATitleR.Address);
        End;
  End;

  for i:=0 to  FDocTxtLst.Count-1 do
  Begin
        ADwnTxt := FDocTxtLst.Items[i];
        With ADwnTxt Do
        Begin
            FDocTxtP.DwnStatus := 3; //���M�����dThread
            inc(AllDwnCount);
            //Resume;
            ReStart;
        End;
  End;
  //ChangeDwnCountMsg;

  While FDocTxtLst.Count>0 Do
  Begin
    try

      Application.ProcessMessages;
      Sleep(50);

      //�������d�Y��=================
      for i:=0 to  FDocTxtLst.Count-1 do
      Begin
          Application.ProcessMessages;
          Sleep(10);
          ADwnTxt := FDocTxtLst.Items[i];
          if ADwnTxt.FRunEnd Then
          Begin
            if (ADwnTxt.FDocTxtP.DwnStatus=1)and
               (Pos('500 Server Error',ADwnTxt.FDocTxtP.HtmlTxt)=0) Then
            Begin
                EnterCriticalSection(csMyCriticalSection);
                MemoTxt := ADwnTxt.FDocTxtP.HtmlTxt;
                FParse._GetHtmlMemo(MemoTxt);
                //MemoTxt:=Utf8Decode(MemoTxt);
                With ADwnTxt Do
                Begin
                  SetDocTxt(HtmlTxt,FDocTxtP.ID,FDocTxtP.ATitleR.Address,
                            FDocTxtP.ATitleR.Caption,FDocTxtP.ATitleR.TitleDate,
                            MemoTxt);
                End;
                LeaveCriticalSection(csMyCriticalSection);
                DelList.Add(ADwnTxt);
                //��Ӌ�ɹ�����
                inc(SuccessCount);
                //ChangeDwnCountMsg;
            end Else
            Begin
               FDwnFailTitleLst.Add(ADwnTxt);
               //�Á��Д�˴�ʧ���ľ��̔�
               Dec(ThreadCount);
               //��Ӌʧ������
               inc(FailCount);
               //ChangeDwnCountMsg;
            End;
          End;
      end;

      //�����O��ʧ���ļo�
      NeedSaveFailLog:=
         ResetDwnFailTxtLogLst(FDwnFailTitleLst,DelList);


      //̎�e���dʧ��
      for i:=0 to FDwnFailTitleLst.Count-1 do
          FDocTxtLst.Remove(FDwnFailTitleLst.Items[i]);
      SaveDwnFailTitleLst;
      //-------------

      //̎�e���d�ɹ�
      While DelList.Count>0 Do
      Begin
           ADwnTxt := DelList.Items[0];
           DelList.Delete(0);
           FDocTxtLst.Remove(ADwnTxt);
           SetThreadDwnNotUse(ADwnTxt);
      End;
      //====================
    Except
    End
  End;

Finally

  if HtmlTxt.Count>0 Then
     HtmlTxt.SaveToFile(GetNewDocTxtFileName);

  HtmlTxt.Text := '';
  HtmlTxt.Destroy;

  //����ʧ���o�
  if NeedSaveFailLog Then
  Begin
     SaveDwnFailLogTxtLst;
     ChangeDwnCountMsg;
  End;

  if Assigned(FParse) Then
    FParse.Destroy;

  DelList.Destroy;

  if ThreadCount=0 Then
     inc(FAllThreadFailCount)
  Else
     FAllThreadFailCount := 0; //�����g�гɹ��^,�͚w0���^����
  //�Д��Ƿ�Ҫ�l���e�`��
  WarningErrWhenDwnTxtErrorCount(FailCount);
  //EnterCriticalSection(csMyCriticalSection);
  //ReleaseMemory(50);
  //LeaveCriticalSection(csMyCriticalSection);
End;



end;

procedure TDwnDocTxtMgr.AddStringList(Var StrLst:TStringList;Str:String);
Var
  i : integer;
begin

Try
  For i:=0 to StrLst.Count-1 do
     if StrLst.Strings[i]=Str Then
        Exit;
  StrLst.Add(Str);
Except
End;

end;

procedure TDwnDocTxtMgr.SaveDwnFailTitleLst;
Var
  ID,FileName : string;
  ADwnTxt : TADwnTxt;
  f : TStringList;
begin

      if (FDwnFailTitleLst.Count=0) Then
          exit;


      f := TStringList.Create;
Try
try
      //�����dʧ�����}�ı�������

      ID := '';
      FileName := '';
      While FDwnFailTitleLst.Count>0 do
      Begin
         ADwnTxt :=  FDwnFailTitleLst.Items[0];
         if ID<>ADwnTxt.FDocTxtP.ID Then
         Begin
             if Length(ID)>0 Then
             Begin
                if f.Count>0 Then
                   f.SaveToFile(FileName);
             End;
             f.Clear;
             ID := ADwnTxt.FDocTxtP.ID;
             FileName := FDwnFailTitleTxtPath + ID+'_Title.txt';
             if FileExists(FileName) Then
                f.LoadFromFile(FileName);
         End;
         if Length(ID)>0 Then
            AddStringList(f,TitleRToStr(ADwnTxt.FDocTxtP.ATitleR));
         FDwnFailTitleLst.Delete(0);
         SetThreadDwnNotUse(ADwnTxt);
      End;

      if Length(ID)>0 Then
         if f.Count>0 Then
            f.SaveToFile(FileName);
      f.Clear;

Except
End;
Finally
  f.Destroy;
end;

end;

function TDwnDocTxtMgr.GetDwnFailTitleLst(AID: String): Integer;
Var
 FileName : String;
 f : TStringList;
begin

   Result := 0;
   f := TStringList.Create;
try
try

   FileName := FDwnFailTitleTxtPath + AID+'_Title.txt';
   if FileExists(FileName) Then
   Begin
      f.LoadFromFile(FileName);
      While f.Count>0 do
      Begin
        if Not AddTitle(AID,StrToTitleR(f.Strings[0])) Then
           Break;
        f.Delete(0);
     End;
      if f.Count>0 Then
         f.SaveToFile(FileName)
      Else
         DeleteFile(FileName);
   End;

   Result := FDocTxtLst.Count;

except
End;
Finally
   f.Destroy;
End;



end;

procedure TDwnDocTxtMgr.OnGetFile(FileName: String);
Var
 TmpFile,ID : String;
 index : Integer;
begin

Try

  Application.ProcessMessages;

  if Self.Terminated Then
     Exit;

  TmpFile := ExtractFileName(FileName);

  index := Pos('_',TmpFile);
  if Index>0 Then
  Begin
      ID := Copy(TmpFile,1,Index-1);
      if FNowPackageID=ID Then
         FPackageFileNameLst.Add(TmpFile);
  End;

Except
End;

end;

function TDwnDocTxtMgr.GetNewDocTxtFileName: String;
begin
   Result := ExtractFilePath(FOutPutDataPath)+'Doc_02_'+Get_GUID8+'.tmp';
   //�������}
   While FileExists(Result) Do
       Result := ExtractFilePath(FOutPutDataPath)+'Doc_02_'+Get_GUID8+'.tmp';

end;


procedure TDwnDocTxtMgr.RefreshIDLst;
begin
   FNeedRefreshIDLst := True;
end;

procedure TDwnDocTxtMgr.ChangeDwnCountMsg;
begin

  if Assigned(FOnNowDwnTxt) Then
     //FOnNowDwnTxt(AllDwnCount,SuccessCount,FailCount);
     FOnNowDwnTxt(AllDwnCount,SuccessCount,FDwnFailTxtLogLst.Count);

end;

procedure TDwnDocTxtMgr.FreeThreadDwn;
Var
 i : Integer;
begin

  For i:=0 to High(FDwnThreadList) do
  Begin
    FDwnThreadList[i].Terminate;
    //if FDwnThreadList[i].Suspended Then
    //    FDwnThreadList[i].Resume;
    FDwnThreadList[i].WaitFor;
    FDwnThreadList[i].Destroy;
  End;
  SetLength(FDwnThreadList,0);

end;

function TDwnDocTxtMgr.GetThreadDwn: TADwnTxt;
Var
 i : Integer;
begin

  Result := nil;
  For i:=0 to High(FDwnThreadList) do
    //if (Not FDwnThreadList[i].FBeUse) and
    //   FDwnThreadList[i].Suspended Then
    if (Not FDwnThreadList[i].FBeUse) Then
    Begin
       Result := FDwnThreadList[i];
       Result.FBeUse := True;
       Break;
    End;

end;

procedure TDwnDocTxtMgr.InitThreadDwn;
Var
 i : Integer;
begin

  SetLength(FDwnThreadList,FDocTxtThreadCount);

  For i:=0 to High(FDwnThreadList) do
  Begin
     FDwnThreadList[i] :=  TADwnTxt.Create(FTdxLst);
     FDwnThreadList[i].Resume;

     While not (FDwnThreadList[i].FExecute)do
       Application.ProcessMessages;

  End;

End;

function TDwnDocTxtMgr.SetDocTxt(var f: TStringList; const ID, URL,
  MemoTitle: ShortString; const TxtDate: TDate;
  const MemoTxt: String): Boolean;
begin
     Result := False;
Try
Try
     f.Add('<ID='+ID+'>');
     f.Add('<GUID>');
     f.Add(Get_GUID8);
     f.Add('</GUID>');
     f.Add('<DOCID>');
     f.Add('');
     f.Add('</DOCID>');
     f.Add('<CBID>');
     f.Add('');
     f.Add('</CBID>');
     f.Add('<CBSTATUS>');
     f.Add('');
     f.Add('</CBSTATUS>');
     f.Add('<CBNAME>');
     f.Add('');
     f.Add('</CBNAME>');
     f.Add('<URL>');
     f.Add(URL);
     f.Add('</URL>');
     f.Add('<Title>');
     f.Add(MemoTitle);
     f.Add('</Title>');
     f.Add('<DocType>');
     f.Add('');
     f.Add('</DocType>');
     f.Add('<Date>');
     f.Add(FloatToStr(TxtDate));
     f.Add('</Date>');
     f.Add('<Time>');
     f.Add('0');
     f.Add('</Time>');
     f.Add('<Memo>');
     f.Add(MemoTxt);
     f.Add('</Memo>');
     f.Add('</ID>');
     Result := True;
Except
End;
Finally
End;
end;

procedure TDwnDocTxtMgr.SetThreadDwnNotUse(ADwnTxt: TADwnTxt);
begin
   FTdxLst.DeleteItem(ADwnTxt.FDocTxtP.AItem);
   ADwnTxt.Clear;
   ADwnTxt.FBeUse := False;
end;


function TDwnDocTxtMgr.ResetDwnFailTxtLogLst(FailLst, SuccessLst: TList):Boolean;
Var
 i,c : Integer;
 ADwnTxt : TADwnTxt;
 ALog : PADocTxtLog;
 ALog2 : PADocTxtLog;
begin

      Result := False;

      //����ʧ����Log
      For i:=0 to  FailLst.Count-1 do
      Begin
         ADwnTxt :=  FailLst.Items[i];
         ALog2    := nil;
         For c := 0 to FDwnFailTxtLogLst.Count-1 do
         Begin
            ALog := FDwnFailTxtLogLst.Items[c];
            if ADwnTxt.FDocTxtP.ATitleR.Address =ALog.DwnUrl Then
            Begin
               ALog2 := ALog;
               Break;
            End;
         End;

         if Not Assigned(ALog2) Then
         Begin
            New(ALog2);
            ALog2.ID := ADwnTxt.FDocTxtP.ID;
            ALog2.DwnUrl := ADwnTxt.FDocTxtP.ATitleR.Address;
            ALog2.DwnTitleCaption := ADwnTxt.FDocTxtP.ATitleR.Caption;
            ALog2.DwnTitleDate := ADwnTxt.FDocTxtP.ATitleR.TitleDate;
            ALog2.DwnFailTime  := Now;
            FDwnFailTxtLogLst.Add(ALog2);
         End;

         ALog2.DwnFailMsg   := ADwnTxt.FErrMsg;

         Result := True;

      End;

      //��Log��ȥ���ɹ���
      For i:=0 to  SuccessLst.Count-1 do
      Begin
         ADwnTxt :=  SuccessLst.Items[i];
         For c := 0 to FDwnFailTxtLogLst.Count-1 do
         Begin
            ALog := FDwnFailTxtLogLst.Items[c];
            if ADwnTxt.FDocTxtP.ATitleR.Address =ALog.DwnUrl Then
            Begin
               ALog.ID := '';
               ALog.DwnUrl := '';
               ALog.DwnTitleCaption := '';
               ALog.DwnFailMsg   := '';
               FreeMem(ALog);
               FDwnFailTxtLogLst.Delete(c);
               Result := True;
               Break;
            End;
         End;
      End;
end;

procedure TDwnDocTxtMgr.SaveDwnFailLogTxtLst;
Var
  FileName : String;
  f : TStringList;
  i : Integer;
  ALog : PADocTxtLog;
begin

   EnterCriticalSection(csMyCriticalSection);
   f := TStringList.Create;
Try

   Filename := FOutPutHtmlPath+'Report\DwnTxtFail.log';
   MkDir_Directory(ExtractFilePath(FileName));

   For i:=0 to FDwnFailTxtLogLst.Count-1 do
   Begin
     ALog := FDwnFailTxtLogLst.Items[i];
     f.Add(ALog.ID+#9+ALog.DwnUrl
           +#9+ALog.DwnTitleCaption+#9+FloatToStr(ALog.DwnTitleDate)
           +#9+DateTimeToStr(ALog.DwnFailTime)+#9+ALog.DwnFailMsg);
   End;
   f.SaveToFile(FileName);

Finally
  f.Destroy;
  LeaveCriticalSection(csMyCriticalSection);

end;

end;

procedure TDwnDocTxtMgr.GetDwnFailLogTxtLst;
Var
  ALog : PADocTxtLog;
  FileName : String;
  StrLst : _CStrLst2;
  f : TStringList;
  i : Integer;
begin

   f := TStringList.Create;
Try

   Filename :=  FOutPutHtmlPath+'Report\DwnTxtFail.log';
   if Not FileExists(FileName) Then
      Exit;

   f.LoadFromFile(FileName);
   For i:=0 to f.Count-1 do
   Begin
     StrLst := DoStrArray2(f.Strings[i],#9);
     New(ALog);
     ALog.ID := StrLst[0];
     ALog.DwnUrl     := StrLst[1];
     ALog.DwnTitleCaption := StrLst[2];
     ALog.DwnTitleDate    := StrToFloat(StrLst[3]);
     ALog.DwnFailTime     := StrToDateTime(StrLst[4]);
     ALog.DwnFailMsg      := StrLst[5];
     FDwnFailTxtLogLst.Add(ALog);
   End;

Finally
  f.Destroy;
end;

end;

procedure TDwnDocTxtMgr.ClearDwnFailLogTxtLst;
begin
   While FDwnFailTxtLogLst.Count>0 Do
   Begin
       FreeMem(FDwnFailTxtLogLst.Items[0]);
       FDwnFailTxtLogLst.Delete(0);
   End;
end;

{ TADwnTxt }

constructor TADwnTxt.Create(ATdxLst : TTdxTreeListMgr);
begin

   FTdxLst := ATdxLst;
   FHtmlTxt := TStringList.Create;
   FBeUse  := false;
   FExecute := false;

   FreeOnTerminate := false;
   inherited Create(true);

end;

destructor TADwnTxt.Destroy;
begin

  try
    FHtmlTxt.Destroy;
    Clear;
  Except
  End;

end;

procedure TADwnTxt.Execute;
Var
  AUrl,vSrcHtml : String;
  //MemoTxt  : String;
  LibIndex : Integer;
  TryTimes : DWord;
begin
   FStop   := True;
   FRunEnd := False;
   FExecute := True;

   While True Do
   Begin
      try
      While FStop Do
      Begin
             if (Self.Terminated) Then
                 FStop := False;
             Application.ProcessMessages;
             Sleep(50);
      End;
      if (Self.Terminated) Then
          Break;
      FRunEnd := false;
      FEndDwn := false;
      FDwnSuccess := false;

      if Not Self.Terminated Then
      Begin
          Application.ProcessMessages;
          Sleep(50);
          AUrl := FDocTxtP.ATitleR.Address;
          //Raise Exception.Create(ConvertString('�����ص���ҳ.'));
          EnterCriticalSection(csMyCriticalSection);
          LibIndex := _GetHttpTxt(PChar(AUrl),
                                  FHtmlTxt,
                                  OnDwnHttpMessage);
          LeaveCriticalSection(csMyCriticalSection);
          if LibIndex<0 Then
             Continue;

          TryTimes := GetTickCount+AMainFrm.FParam.DocTextTimeOut*1000;
          While Not FEndDwn Do
          Begin
              if Self.Terminated or FStopRunning or
                     (TryTimes<=GetTickCount) Then
              Begin
                EnterCriticalSection(csMyCriticalSection);
                if _StopConnect(LibIndex) Then
                      FEndDwn := True;
                LeaveCriticalSection(csMyCriticalSection);
              End;
              Application.ProcessMessages;
              Sleep(10);
          End;
          EnterCriticalSection(csMyCriticalSection);
          _ReleaseHttpTxt(LibIndex);
          LeaveCriticalSection(csMyCriticalSection);

          if Not FDwnSuccess Then
             Raise Exception.Create(ConvertString('�����ص���ҳ.'))
          Else Begin
             if FHtmlTxt.Count>0 Then
             Begin
                //modify by wangjinhua 4.16 - Problem(20100716)
                 //FDocTxtP.HtmlTxt := FHtmlTxt.Text;
                vSrcHtml:=FHtmlTxt.Text;
                ChrConvert(vSrcHtml);
                FHtmlTxt.Text:=vSrcHtml;
                FDocTxtP.HtmlTxt := FHtmlTxt.Text;
                //--
                 FHtmlTxt.Clear;
             End;
          End;
      End;
      Except
          On E:Exception do
          Begin
             FErrMsg := E.Message;
             ShowMsg(E.Message);
          End;
      End;

      //�l�Fһ�N��ֵ��e
      //������̈���̫��̫����ܕ�����SuspendʧЧ
      //�����Breakһ�¿��Ա���
      //Sleep(50);
      FHtmlTxt.Text := '';

      if FDwnSuccess Then
        FDocTxtP.DwnStatus := 1
      Else
        FDocTxtP.DwnStatus := 2;

      FStop := True; //Ҫ�ȕ�ͣ
      FRunEnd := True; //Ȼ��֪ͨ�Y��
      {
      if (Not Self.Terminated) and
         (Not FStopRunning) Then
      Begin
         While FStop Do
         Begin
             if (Self.Terminated) and
                FStop := False;
             Application.ProcessMessages;
             Sleep(100);
         End;
         //Self.Suspend
      End Else
         Break;
      }
   End;

   FRunEnd := True;
end;


procedure TADwnTxt.OnDwnHttpMessage(AMessage: TDwnHttpWMessage);
begin

Try

  Case  AMessage.Status of
    dwnBegin : Begin
       ShowPer(0,0);
    End;
    dwnMsg : Begin
         ShowMsg(AMessage.MsgString);
    End;
    dwnError : Begin
         ShowMsg(AMessage.MsgString);
    End;
    dwnSize : Begin
       ShowPer(AMessage.MaxSize,AMessage.NowSize);
    End;
    dwnEnd : Begin
        FEndDwn := True;
        FDwnSuccess := AMessage.DwnSuccess;
        //ShowPer(0,0);
    End;
  End;
Except
end;

end;

procedure TADwnTxt.InitData(Const ID: String; Const ATitleR: TTitleR;
Const AItem :TdxTreeListNode);
begin
   FDocTxtP.ID := ID;
   FDocTxtP.DwnStatus := 99;
   FDocTxtP.ATitleR := ATitleR;
   FDocTxtP.HtmlTxt := '';
   FDocTxtP.AItem   := AItem;

   FEndDwn := false;
   FDwnSuccess := false;
end;

procedure TADwnTxt.ShowMsg(Msg: ShortString);
begin
try
  if Self.Terminated or FStopRunning Then
    Exit;
  FTdxLst.AddString(FDocTxtP.AItem,2,Msg);
Except
End;


end;

procedure TADwnTxt.ShowPer(MaxSize, NowSize: Integer);
Var
  PStr : String;
begin

try
  if Self.Terminated or FStopRunning Then
     Exit;
  if (MaxSize=0) or (NowSize=0) Then
     PStr := '0%'
  Else
     PStr := FloatToStr(Round((NowSize/MaxSize)*100))+'%';

  FTdxLst.AddString(FDocTxtP.AItem,3,PStr);
Except
End;

end;

procedure TADwnTxt.Clear;
begin
  FDocTxtP.ID := '';
  FDocTxtP.ATitleR.Caption := '';
  FDocTxtP.ATitleR.Address := '';
  FDocTxtP.HtmlTxt := '';
  FDocTxtP.AItem := nil;
  FErrMsg := '';
end;


procedure TADwnTxt.ReStart;
begin
  FRunEnd := false;
  FStop   := False;
end;

{ TTdxTreeListMgr }

function TTdxTreeListMgr.Add: TdxTreeListNode;
Var
  i : Integer;
begin
   Result := nil;
Try
   For i:=0 to High(FItemBufferLst) do
   Begin
      if Not FItemBufferLst[i].BeUse Then
      Begin
         FItemBufferLst[i].BeUse := True;
         Result := FItemBufferLst[i].AItem;
         Break;
      End;
   End;
Except
  Result := nil;
End;
end;

procedure TTdxTreeListMgr.AddString(AItem: TdxTreeListNode;
  ColIndex: Integer; Value: ShortString);
Var
  i : Integer;
begin
Try
  for i:=0 to High(FItemBufferLst) do
    if FItemBufferLst[i].AItem = AItem Then
       FItemBufferLst[i].Value[ColIndex] := Value;
Except
end;

end;

constructor TTdxTreeListMgr.Create(ATdxLst: TdxTreeList;ItemCount:Integer);
Var
  i,c : Integer;
begin

   FTdxLst := ATdxLst;

   SetLength(FItemBufferLst,ItemCount);
   For i:=0 to High(FItemBufferLst) do
   Begin
      FItemBufferLst[i].AItem :=  FTdxLst.Add;
      FItemBufferLst[i].BeUse := false;
      For c:=0 to High(FItemBufferLst[i].Value) do
         FItemBufferLst[i].Value[c] := '';
   End;

   FreeOnTerminate := false;
   inherited Create(true);

end;


procedure TTdxTreeListMgr.DeleteItem(AItem: TdxTreeListNode);
Var
  i : Integer;
begin
  if Assigned(AItem) Then
  Begin
     For i:=0 to High(FItemBufferLst) do
     Begin
      if FItemBufferLst[i].AItem = AItem Then
      Begin
         FItemBufferLst[i].BeUse := false;
         AddString(AItem,0,'DELETE');
         Break;
      End;
    End;
  End;
end;

destructor TTdxTreeListMgr.Destroy;
Var
  i,c : Integer;
begin

Try
  For i:=0 to High(FItemBufferLst) Do
    for c:=0 to High(FItemBufferLst[i].Value) do
    Begin
       FItemBufferLst[i].AItem := nil;
       FItemBufferLst[i].Value[c] := '';
    End;
  FTdxLst.ClearNodes;
  SetLength(FItemBufferLst,0);
Except
End;


  //inherited;
end;

procedure TTdxTreeListMgr.Execute;
Var
  NeedRepaint : Boolean;
  i,c : Integer;
begin
  //inherited;

  While Not Self.Terminated Do
  Begin
    Application.ProcessMessages;
    Sleep(50);
    NeedRepaint := False;
    Try

    For i:=0 to High(FItemBufferLst) do
    Begin
        if Self.Terminated Then
           Break;

        Try
          if FItemBufferLst[i].Value[0]='DELETE' Then
          Begin

              if Not NeedRepaint Then
                 Self.Synchronize(FTdxLst.BeginUpdate);
               NeedRepaint := True;

               for c:=0 to High(FItemBufferLst[i].Value) do
                  FItemBufferLst[i].AItem.Strings[c] := '';
          End
          Else Begin

             if FItemBufferLst[i].BeUse Then
             Begin
               for c:=0 to High(FItemBufferLst[i].Value) do
                 if FItemBufferLst[i].Value[c] <> FItemBufferLst[i].AItem.Strings[c] Then
                 Begin
                    if Not NeedRepaint Then
                      Self.Synchronize(FTdxLst.BeginUpdate);
                    NeedRepaint := True;
                    FItemBufferLst[i].AItem.Strings[c] := FItemBufferLst[i].Value[c];
                 End;
             End;

          End;
        Except
        End;
    End;
    Except
    End;
    if NeedRepaint Then
       Synchronize(FTdxLst.EndUpdate);
  End;

end;


{ TADwnTitle }

constructor TADwnTitle.Create(ATdxLst   : TTdxTreeListMgr;
                          Tr1DBPath : ShortString;
                          OutPutDataPath : ShortString;
                          OutPutHtmlPath:ShortString);
begin

   FTdxLst := ATdxLst;
   FExecute := false;

   FOutPutHtmlPath := OutPutHtmlPath;
   FTr1DBPath := Tr1DBPath;
   FHtmlTxt   := TStringList.Create;
   FTitleIdxMgr := TTitleIdxMgr.Create(Tr1DBPath,OutPutDataPath);
   FBeUse := False;


   FParseHtml := TParseHtmLibMgr.Create(ExtractFilePath(Application.ExeName),FDwnMemo,PChar(ExtractFilePath(Application.ExeName)+'setup.ini'));

   FreeOnTerminate := false;
   inherited Create(true);

end;

destructor TADwnTitle.Destroy;
begin
  try

    FHtmlTxt.Destroy;

    FOutPutHtmlPath := '';
    FTr1DBPath := '';

    if Assigned(FTitleIdxMgr) Then
       FTitleIdxMgr.Destroy;

    Clear;
    if Assigned(FDocTitleP.NeedDwnTitleLst) Then
       FDocTitleP.NeedDwnTitleLst.Destroy;

    FTitleIdxMgr := nil;
    FParseHtml.Destroy;
    FParseHtml := nil;

  Except
  End;
end;

procedure TADwnTitle.Execute;
Var
  PageIndex,TitleCount : integer;
  ATitleLst:TTitleRLst;
  ReadEndTitle : String;
  NewReadEndTitle : String;
  Str,AUrl : String; //sLog,sLog1,sLog2,sLog3
  i : Integer;
  AHtmlPage : TPageR;
  FExit : Boolean;
  LibIndex  : Integer;
  TryTimes  : DWord;
  StartDateStr,vSrcHtml :String;// Doc4.2-N001-sun-090610

  function DownTextOfUrl(aItemUrl,aHintTag:string):Boolean;
  begin
      result := false;
      FDwnUrl := aItemUrl;
      While Not Self.Terminated  do
      begin
        ShowMsg2(Format(ConvertString('����')+'%s',[aHintTag]));
        FEndDwn := false;
        FDwnSuccess := false;
        Try
            EnterCriticalSection(csMyCriticalSection);
            LibIndex :=  _GetHttpTxt(PChar(aItemUrl),FHtmlTxt,OnDwnHttpMessage);
            LeaveCriticalSection(csMyCriticalSection);

            //GET FAIL
            if LibIndex<0 Then
            Begin
                Application.ProcessMessages;
                Sleep(50);
                Continue;
            End;

            TryTimes := GetTickCount+AMainFrm.FParam.DocTitleTimeOut*1000;
            While Not FEndDwn Do
            Begin
              if Self.Terminated or FStopRunning or
                 (TryTimes<=GetTickCount) Then
              Begin
                 EnterCriticalSection(csMyCriticalSection);
                 if _StopConnect(LibIndex) Then
                   FEndDwn := True;
                 LeaveCriticalSection(csMyCriticalSection);
              End;
              Application.ProcessMessages;Sleep(10);
            End;
            EnterCriticalSection(csMyCriticalSection);
            _ReleaseHttpTxt(LibIndex);
            LeaveCriticalSection(csMyCriticalSection);
        Except
            On E:Exception do
               ShowMsg(E.Message);
        End;
        if Self.Terminated Then Break;

        if Not FDwnSuccess Then
        Begin
           Raise Exception.Create(ConvertString('�����ص���ҳ.'));
           //Break;
        End
        else begin
          vSrcHtml:=FHtmlTxt.Text;
          ChrConvert(vSrcHtml);
          FHtmlTxt.Text:=vSrcHtml;
          result := true;
          break;
        end;
      end;
  end;

begin
   FStop   := True;
   FRunEnd := False;
   FExecute := True;

   While True Do
   Begin
      try
         //waiting until restart
         While FStop Do
         Begin
             if (Self.Terminated) Then FStop := False;
             Application.ProcessMessages;
             Sleep(50);
         End;
         if (Self.Terminated) Then  Break;

         FRunEnd := False;
         PageIndex := 0;
         FExit := false;
         FDwnSuccess := false;

         if Not Self.Terminated  Then
         Begin
            EnterCriticalSection(csMyCriticalSection);
            Try
              //ȡ���ϴ����µĘ��}
              ReadEndTitle := GetEndReadTitle(FDocTitleP.ID,FOutPutHtmlPath);
              NewReadEndTitle := '';
              LeaveCriticalSection(csMyCriticalSection);
            Except
               On E:Exception Do
               Begin
                  LeaveCriticalSection(csMyCriticalSection);
                  Raise Exception.Create(E.Message);
               End;
            End;
         End;

         //**************Doc4.2-N001-sun-090610************************
         StartDateStr := GetIDStartDate(FDocTitleP.ID);
         //************************************************************


         While Not Self.Terminated  do
         Begin
            inc(PageIndex);
            EnterCriticalSection(csMyCriticalSection);
            AUrl := FParseHtml._GetHtmlAddress(PChar(String(FDocTitleP.ID)),PChar(String(StartDateStr)),PageIndex);
            LeaveCriticalSection(csMyCriticalSection);
            if DownTextOfUrl(AUrl,Format(ConvertString('�� %s ҳ'),[IntToStr(PageIndex)]) ) then
            begin
               if Self.Terminated Then Break;
               AHtmlPage.NowPage := 0;
               AHtmlPage.AllPage := 0;
               Try
                 if FHtmlTxt.Count>0 Then
                 Begin
                    EnterCriticalSection(csMyCriticalSection);
                    Try    
                      {sLog:=ExtractFilePath(ParamStr(0))+'TestLog\';
                      if not DirectoryExists(sLog) then
                      begin
                        ForceDirectories(sLog);
                      end;
                      sLog2:=FormatDateTime('hhmmsszzz',now);
                      sLog1:=sLog+FDocTitleP.ID+'_'+inttostr(PageIndex)+'_'+sLog2+'.dat';
                      WriteToFile(sLog1,'------------'+#13#10+FHtmlTxt.Text);  }
                      FParseHtml._GetNowHtmlPage(FHtmlTxt.Text,AHtmlPage);
                      TitleCount := FParseHtml._GetNowPageTitlesCount(FHtmlTxt.Text);
                      SetLength(ATitleLst,TitleCount);
                      if not FParseHtml._GetNowPageTitles(ATitleLst) then
                      begin
                        FExit := True; //ֹͣһ���ь�
                        //WriteToFile(sLog1,'not FParseHtml._GetNowPageTitles.'+inttostr(TitleCount));
                      end;
                      FHtmlTxt.Clear;
                      LeaveCriticalSection(csMyCriticalSection);
                    Except
                       On E:Exception do
                       Begin
                         LeaveCriticalSection(csMyCriticalSection);
                         Raise Exception.Create(ConvertString('��������ʱ��������(')+E.Message+')');
                       End;
                    End;


                    if TitleCount>0 Then
                    Begin
                      //�O�����µĘ��},�´ξ�ֻȡ���˞�ֹ
                      if PageIndex=1 Then
                         NewReadEndTitle := TitleRToStr(ATitleLst[0]);

                      //��ȡ���Ę��}�ռ��� AllTitleLst
                      for i:=0 to  High(ATitleLst) do
                      Begin
                        Str := TitleRToStr(ATitleLst[i]);
                        //ֻ�����dģʽ��������²��д�����
                        if FDwnMode=dwnToday Then
                        Begin
                            //ֻȡ���ϴ����µĘ��}��ֹ
                            if ReadEndTitle=Str Then
                            Begin
                               FExit := True; //ֹͣһ���ь�
                               Break;
                            End;
                        End;

                        //����@���Wַ�����d�^,�t���^�˾Wַ
                        if FTitleIdxMgr.TitleExists(ATitleLst[i].Caption,ATitleLst[i].TitleDate) Then
                           Continue;

                        FDocTitleP.NeedDwnTitleLst.Add(Str);
                        //���˾Wַ�o���,�����´����}�ь�
                        FTitleIdxMgr.AddTitleIdx(ATitleLst[i].Caption,ATitleLst[i].TitleDate);

                      End;
                      //--------------------------
                    End;
                    SetLength(ATitleLst,0);
                 End;
               Except
                  On E:Exception do
                  Begin
                     Raise Exception.Create(ConvertString('��������ʱ��������(')+E.Message+')');
                  End;
               End;

               //���ь�����
               if (AHtmlPage.AllPage=AHtmlPage.NowPage) Then
                  FExit := True;

               if FExit Then
               Begin
                   //������d
                  EnterCriticalSection(csMyCriticalSection);

                  //�����@�����µĘ��}
                  try
                    if NewReadEndTitle<>ReadEndTitle Then
                       SaveEndReadTitle(FDocTitleP.ID,NewReadEndTitle,FOutPutHtmlPath);
                    LeaveCriticalSection(csMyCriticalSection);
                  Except
                    On E:Exception Do
                    Begin
                       LeaveCriticalSection(csMyCriticalSection);
                       Raise Exception.Create(E.Message);
                    End;
                  End;
                  Break;
               End Else
                  Continue;
            end;

         End;

      Except
       On E:Exception do
       Begin
         FDwnSuccess := false;
         ShowMsg(E.Message);
         //Log
         FErrMsg := E.Message;
       End;
      End;

      FHtmlTxt.Text   := '';
      SetLength(ATitleLst,0);

      if FDwnSuccess Then
      Begin
           FDocTitleP.DwnStatus := 1;
      End Else
      Begin
           FDocTitleP.NeedDwnTitleLst.Clear;
           //add 2005/12/2
           FTitleIdxMgr.ClearTitleIdx;
           FDocTitleP.DwnStatus := 2;
      End;

      FStop := True; //Ҫ�ȕ�ͣ
      FRunEnd := True; //Ȼ��֪ͨ�Y��
   End;
   FRunEnd := True;
end;

procedure TADwnTitle.OnDwnHttpMessage(AMessage: TDwnHttpWMessage);
begin
Try
  Case  AMessage.Status of
    dwnBegin : Begin
       ShowPer(0,0);
    End;
    dwnMsg : Begin
         ShowMsg(AMessage.MsgString);
    End;
    dwnError : Begin
         ShowMsg(AMessage.MsgString);
    End;
    dwnSize : Begin
       ShowPer(AMessage.MaxSize,AMessage.NowSize);
    End;
    dwnEnd : Begin
        FEndDwn := True;
        FDwnSuccess := AMessage.DwnSuccess;
        //ShowPer(0,0);
    End;
  End;
Except
end;
end;

procedure TADwnTitle.InitData(Const ID : String;
                          AParse: TParseHtmLibMgr;
                          Const DwnStatus : Byte;
                          Const DwnMode : TDwnMode;
                          Const AItem :TdxTreeListNode);
begin

   //FParseHtml := AParse;
   FDocTitleP.ID := ID;
   FDocTitleP.DwnStatus := DwnStatus;
   if Not Assigned(FDocTitleP.NeedDwnTitleLst) Then
      FDocTitleP.NeedDwnTitleLst := TStringList.Create;
   FDocTitleP.AItem := AItem;

   FDwnMode := DwnMode;

   FEndDwn := false;
   FDwnSuccess := false;


end;

procedure TADwnTitle.ShowMsg(Msg: ShortString);
begin
try
  if Self.Terminated or FStopRunning Then
     Exit;
  FTdxLst.AddString(FDocTitleP.AItem,2,Msg);
Except
End;
end;

procedure TADwnTitle.ShowMsg2(Msg: ShortString);
begin
try
  if Self.Terminated or FStopRunning Then
     Exit;
  FTdxLst.AddString(FDocTitleP.AItem,1,Msg);
Except
End;
end;

procedure TADwnTitle.ShowPer(MaxSize, NowSize: Integer);
Var
  PStr : String;
begin

try
  if Self.Terminated or FStopRunning Then
     Exit;
  if (MaxSize=0) or (NowSize=0) Then
     PStr := '0%'
  Else
     PStr := FloatToStr(Round((NowSize/MaxSize)*100))+'%';

  FTdxLst.AddString(FDocTitleP.AItem,3,PStr);
Except
End;


end;

procedure TADwnTitle.Clear;
begin

  FDocTitleP.ID := '';
  if Assigned(FDocTitleP.NeedDwnTitleLst) Then
     FDocTitleP.NeedDwnTitleLst.Clear;
  FDocTitleP.AItem := nil;
  FErrMsg  := '';
  FDwnUrl  := '';


end;



procedure TADwnTitle.ReStart;
begin
  FRunEnd := false;
  FStop   := False;
end;

procedure TADwnTitle.RefreshFromIdxFile;
begin
   //ˢ���������d�^�Ę��}�Wַ���
   FTitleIdxMgr.Refresh(FDocTitleP.ID);
end;

procedure TADwnTitle.SaveToIdxFile;
begin
   //���ь���ľWַ������
   FTitleIdxMgr.SaveToFile;
end;

{ TTitleIdxMgr }

procedure TTitleIdxMgr.AddTitleIdx(Const ATitle:ShortString;Const ADate:TDate);
begin
  //FTitleLst.Add(ATitle+'/'+FormatDateTime('yyyy-mm-dd',ADate));
  FNeedSaveTitleLst.Add(ATitle+'/'+FormatDateTime('yyyy-mm-dd',ADate));
  FNeedSave := True;
end;

constructor TTitleIdxMgr.Create(Tr1DBPath,OutPutHtmlPath: ShortString);
begin
   FTr1DBPath  := Tr1DBPath;
   FOutPutHtmlPath := OutPutHtmlPath;
   FDocLst   := TStringList.Create;
   FTitleLst := TStringList.Create;
   FNeedSaveTitleLst := TStringList.Create;
End;

destructor TTitleIdxMgr.Destroy;
begin
  FTitleLst.Destroy;
  FDocLst.Destroy;
  FID := '';
  FNeedSaveTitleLst.Destroy;
  //inherited;
end;

procedure TTitleIdxMgr.Init;
Var
  StrTemp,Str,FileName : String;
  i : Integer;
  f : TStringList;
begin
  f := TStringList.Create;
Try

  //������ԏĴ������Єh���Ę��}
  ResetTitleIdx;

  //�d���������^�Ę��}
  FTitleLst.Clear;
  FileName := FOutPutHtmlPath+'Doc_02.idx';
  if FileExists(FileName) Then
  Begin
     f.LoadFromFile(FileName);

     While f.Count>0 DO
     Begin
       Str := f.Strings[0];
       f.Delete(0);
       i := Pos('=',Str);
       if i>0 Then
       Begin
         if Copy(Str,1,i-1)=FID Then
            FTitleLst.Add(Copy(Str,i+1,Length(Str)-i));
       End;
     End;
  End;

  //�d�빫����ε�����
  FDocLst.Clear;
  FileName := FTr1DBPath+'CBData\Document\DocLstIdx\'+FID+'.idx';
  if FileExists(FileName) Then
  begin
     FDocLst.LoadFromFile(FileName);

     //add by JoySun 2005/10/28  ɾ�������е�'[D]'
     For i:=0 to FDocLst.Count-1 do
     begin
      if(Pos('[D]',FDocLst.Strings[i])>0)then
      begin
        StrTemp:=FDocLst.Strings[i];
        ReplaceSubString('[D]','',StrTemp);
        FDocLst.Strings[i]:=StrTemp;
      end;
    end;
  end;

Finally
  f.Destroy;
End;

end;

procedure TTitleIdxMgr.OnGetFile(FileName: String);
begin
   if FStopRunning Then
      exit;
   if Pos('Doc_02_'+FID,ExtractFileName(FileName))>0 Then
      FResetTitleIdx.Add(FileName);
end;

procedure TTitleIdxMgr.Refresh(ID:ShortString);
begin
   FID := ID;
   FNeedSave := False;
   FNeedSaveTitleLst.Clear;
   Init;
end;

Procedure TTitleIdxMgr.FolderAllFiles_idx(DirName : shortString;SpecExt:ShortString;Var Files :TStringList;IncludeSubFolder:Boolean=True);
var
  DirInfo: TSearchRec;
  r : Integer;
begin

  Files:=TStringList.Create;
  DoPathSep(DirName);
  SpecExt := UpperCase(SpecExt);
  r := FindFirst(DirName+'*.*', FaAnyfile, DirInfo);
  while r = 0 do
  begin
    if IncludeSubFolder Then
     if ((DirInfo.Attr and FaDirectory) = FaDirectory) and (DirInfo.Name<>'.')
        and (DirInfo.Name<>'..') then
       FolderAllFiles_idx(DirName + DirInfo.Name,SpecExt,Files,IncludeSubFolder);
    if ((DirInfo.Attr and FaDirectory <> FaDirectory) and
      (DirInfo.Attr and FaVolumeId <> FaVolumeID)) then
    Begin
        if (UpperCase(ExtractFileExt(DirInfo.Name))=SpecExt) or (SpecExt='*.*') Then
        Begin
          if Pos('Doc_02_'+FID,DirName+DirInfo.Name)>0 Then
            Files.Add(DirName+DirInfo.Name);
        End;
    End;
    r := FindNext(DirInfo);
  end;
  SysUtils.FindClose(DirInfo);
end;

procedure TTitleIdxMgr.ResetTitleIdx;
Var
  f,idxf : TStringlist;
  FileName : String;
  i,c :  Integer;
begin

  FileName := FOutPutHtmlPath+'Doc_02.idx';
  if not FileExists(FileName) Then
     Exit;
  FResetTitleIdx := TStringList.Create;
  f := TStringList.Create;
  idxf := TStringList.Create;
Try

  FolderAllFiles(FOutPutHtmlPath,'.idx',OnGetFile,false);
  //FolderAllFiles_idx(FOutPutHtmlPath,'.idx',FResetTitleIdx,false);

  if FStopRunning Then
      Exit;

  if FResetTitleIdx.Count=0 Then
     Exit;

  idxf.LoadFromFile(FileName);

  for c:=0 to  FResetTitleIdx.Count-1 do
  Begin
     if FStopRunning Then
       Exit;
     //if(Pos('Doc_02.idx',FResetTitleIdx.Strings[c])>0)then
       //continue;

     f.Clear;
     f.LoadFromFile(FResetTitleIdx.Strings[c]);
     if f.Count>0 Then
     Begin
       for i:=0 to idxf.Count-1 do
       Begin
         if FStopRunning Then
            Exit;
         if idxf.Strings[i]=f.Strings[0] Then
         Begin
            idxf.Delete(i);
            Break;
         end;
       End;
       {
       i:=0;
       while i<=idxf.Count-1 do
       Begin
         if FStopRunning Then
            Exit;
         if idxf.Strings[i]=f.Strings[0] Then
         Begin
            idxf.Delete(i);
            dec(i);
         end;
         inc(i);
       End;
       }
     End;
  End;

  if idxf.Count>0 Then
     idxf.SaveToFile(FileName)
  Else
     DeleteFile(FileName);

  While FResetTitleIdx.Count>0 do
  Begin
      DeleteFile(FResetTitleIdx.Strings[0]);
      FResetTitleIdx.Delete(0);
  End;

Finally
  idxf.Destroy;
  f.Destroy;
  FResetTitleIdx.Destroy;
end;

end;

procedure TTitleIdxMgr.SaveToFile;
Var
  FileName : String;
  FLogFile : TextFile;
  {LstIdx:TStringList;
  needadd:Boolean;
  i:integer; }
begin

  FileName := FOutPutHtmlPath+'Doc_02.idx';
  //LstIdx:=TStringList.Create;

try

  if FNeedSave Then
  Begin
     AssignFile(FLogFile,FileName);
     FileMode := 1;
     if FileExists(FileName) Then
     Begin
        Append(FLogFile);
     End Else
        ReWrite(FLogFile);

     While FNeedSaveTitleLst.Count>0 DO
     Begin
        Writeln(FLogFile,FID+'='+FNeedSaveTitleLst.Strings[0]);
        FNeedSaveTitleLst.Delete(0);
     End;
  End;

  {if FNeedSave Then
  Begin
     if FileExists(FileName) Then
     Begin
        LstIdx.LoadFromFile(FileName);
        While FTitleLst.Count>0 DO
        Begin
          for i:=0 to  LstIdx.Count-1 do
          Begin
            if(LstIdx.Strings[i]=FID+'='+FTitleLst.Strings[0])then
            begin
              needadd:=false;
              break;
            end
            else
              needadd:=true;
          End;

          if(needadd)then
            LstIdx.Add(FID+'='+FTitleLst.Strings[0]);
          FTitleLst.Delete(0);
       End;
     End Else
     Begin
        While FTitleLst.Count>0 DO
        Begin
          LstIdx.Add(FID+'='+FTitleLst.Strings[0]);
          FTitleLst.Delete(0);
        End;
     End;
  End;

  LstIdx.SaveToFile(FileName); }

Finally
  if FNeedSave Then
  Begin
    try
      CloseFile(FLogFile);
    Except
    End;
  End;
  FNeedSave := False;
  //LstIdx.Free;
End;

end;

function TTitleIdxMgr.TitleExists(Const ATitle:ShortString;Const ADate:TDate): Boolean;
Var
  i :  Integer;
  Str : String;
begin

   Result := False;
   Str := ATitle+'/'+FormatDateTime('yyyy-mm-dd',ADate);

   //�z���Լ�������
   for i:=0 to FTitleLst.Count-1 do
     if FTitleLst.Strings[i]=Str Then
     Begin
        Result := True;
        Exit;
     End;

   //�z�����
   for i:=0 to FDocLst.Count-1 do
     if FDocLst.Strings[i]=Str Then
     Begin
        Result := True;
        Exit;
     End;

end;

procedure TAMainFrm.Act_CalExecute(Sender: TObject);
begin
  StartGet;
end;

procedure TAMainFrm.Act_SetupExecute(Sender: TObject);
Var
  Afrm : TASetupFrm;
begin

  AFrm := TASetupFrm.Create(Self);
  if AFrm.ShowWin(FParam) Then
     ReloadParam;
  AFrm.Destroy;

end;

procedure TAMainFrm.Mnu_ExitClick(Sender: TObject);
begin
   Close;
end;

procedure TTitleIdxMgr.ClearTitleIdx;
begin
  FNeedSaveTitleLst.Clear;
  FNeedSave := False;
end;

{ TSaveLogMgr }

procedure TSaveLogMgr.ClearSysLog;
var
  LogFileLst : _CStrLst;
  i:integer;
begin
try

  FolderAllFiles(ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\'+
                 ChangeFileExt(ExtractFileName(Application.ExeName),'')+'\',
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

constructor TSaveLogMgr.Create(OutPutPath: String);
begin
  FOutPutPath := OutPutPath+'Data\DwnDocLog\'+
                 ChangeFileExt(ExtractFileName(Application.ExeName),'')+'\';
  Mkdir_Directory(FOutPutPath);
end;

procedure TSaveLogMgr.SaveLog(Msg: ShortString);
Var
  FileName : String;
  FLogFile : TextFile;
begin

try
Try

  FileName := FOutPutPath+FormatDateTime('yyyymmdd',Date)+'.log';

  AssignFile(FLogFile,FileName);
  FileMode := 1;

  if FileExists(FileName) Then
  Begin
      Append(FLogFile);
  End Else
      ReWrite(FLogFile);

  Writeln(FLogFile,Msg);

Except
End;
Finally
  try
    CloseFile(FLogFile);

    if (ClearDate<>Date)then
    begin
      ClearSysLog;
      ClearDate:=Date;
    end;
  Except
  End;

End;

end;

procedure TAMainFrm.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePageIndex=2 Then
  Begin
     Act_RefreshReport.Enabled := True;
     Act_RefreshReport.Execute;
  End Else
     Act_RefreshReport.Enabled := false;
end;

procedure TAMainFrm.Act_RefreshReportExecute(Sender: TObject);
begin
  if PageControl1.ActivePageIndex=2 Then
    if PageControl2.ActivePageIndex=0 Then
       ShowDwnTitleReport
    Else
       ShowDwnTxtReport;
end;

procedure TAMainFrm.PageControl2Change(Sender: TObject);
begin
  Act_RefreshReport.Execute;
end;

procedure TAMainFrm.Report_DwnTitleCustomDrawCell(
              Sender: TObject;
              ACanvas: TCanvas;
              ARect: TRect;
              ANode: TdxTreeListNode;
              AColumn: TdxTreeListColumn;
              ASelected, AFocused,
              ANewItemRow: Boolean;
              var AText: String;
              var AColor: TColor;
              AFont: TFont;
              var AAlignment: TAlignment;
              var ADone: Boolean);
begin

    if ASelected Then
       Exit;

    //��Ӌ���}
    if AColumn.Name='dx_TitleCount' Then
      if Length(ANode.Strings[AColumn.Index])>0 Then
      Begin
          if StrToInt(ANode.Strings[AColumn.Index])>0 Then
             AColor := clYellow
          Else
             AColor := clWhite;
      End;


end;

procedure TAMainFrm.Doc_Check_TimerTimer(Sender: TObject);
var
  NowTime:TTime;
begin
{  Doc_Check_Timer.Enabled :=false;
TRY
   NowTime:=Now-Date;
   if(NowTime>EncodeTime(0,0,0,0))and (NowTime<EncodeTime(0,0,1,0))then
     NewDay :=true;
   if NewDay and (NowTime>FParam.Doc_Check_Time) then
   begin
     if CheckDoc then
     begin
       Label6.Caption :=ConvertString('���������� ');
       Label6.Font.Color :=clred;
     end
     else
     begin
       Label6.Caption :=ConvertString('û������  ');
       Label6.Font.Color :=clgreen;
     end;
     NewDay :=false;
   end;
Except
  On E: Exception do
    ShowMessage(E.message);
End;
  Doc_Check_Timer.Enabled :=true;
}
end;


function TAMainFrm.CheckDoc: Boolean;
var
  DataPath,DocIdxFile,StrMemo,FailFileName : String;
  IDIdxFileLst,TempFileLst:_cStrLst;
//add by wjh 2011-10-14
  DwnFailTxtLst : _cStrLst;
  aID:string;
//
  i,j,k:integer;
  StrLst,IdxStrLst,IdxStrLst2,DwnFailTxtLogLst : TStringList;
  DocDataMgr_1 : TDocDataMgr;
  ADoc:TDocData;
  ALog : PADocTxtLog;
  StrLst2 : _CStrLst2;
begin
TRY
  StrLst := TStringList.Create;
  IdxStrLst := TStringList.Create;
  IdxStrLst2 := TStringList.Create;
  DwnFailTxtLogLst := TStringList.Create;
  Result := false;
  TRY
  DataPath := ExtractFilePath(Application.ExeName)+'Data\';
  FolderAllFiles(DataPath,'.tmp',TempFileLst,false);
  FolderAllFiles(DataPath,'.idx',IDIdxFileLst,false);
  FolderAllFiles(DataPath+'Html\DocTxt\','.txt',DwnFailTxtLst,true);
  DocIdxFile := DataPath+'Doc_02.idx';
  FailFileName:= DataPath+'Html\Report\DwnTxtFail.log';

  if(not FileExists(DocIdxFile))then exit
  else
  begin
    IdxStrLst.LoadFromFile(DocIdxFile);
    if(IdxStrLst.Count<1)then exit;

    //����TEMP
    /////////////////////////////////////////////////////////
    if(High(TempFileLst)>=0)then
    begin
      For i:=0 to High(TempFileLst) do
      Begin
        Strlst.LoadFromFile(TempFileLst[i]);
        if(Strlst.Count<0)then exit;
        DocDataMgr_1 := TDocDataMgr.Create(DataPath+'Doc_02.tmp','');
        DocDataMgr_1.DocListText  :=Strlst.Text;
        for k:=0 to DocDataMgr_1.DocList.Count-1 do
        Begin
          ADoc := DocDataMgr_1.DocList.Items[k];
          StrMemo:=ADoc.ID+'='+ADoc.Title+'/'+FormatDateTime('yyyy-mm-dd',ADoc.date);
          //ShowMessage(StrMemo+#13#10+IdxStrLst.Text);
          For j:=0 to IdxStrLst.Count-1 do
          begin
            if(IdxStrLst.Strings[j]=StrMemo)then
            begin
              IdxStrLst.Delete(j);
              break;
            end;
          end;
        End;
      End;
    end;
    /////////////////////////////////////////////////////////

    //����ID_idx
    /////////////////////////////////////////////////////////
    if(High(IDIdxFileLst)>=1)then
    begin
      For i:=0 to High(IDIdxFileLst) do
      Begin
        if(IDIdxFileLst[i]=DocIdxFile)then
          continue
        else
        begin
          Strlst.LoadFromFile(IDIdxFileLst[i]);
          For j:=0 to IdxStrLst.Count-1 do
          begin
            if(IdxStrLst.Strings[j]=Strlst.Strings[0])then
            begin
              IdxStrLst.Delete(j);
              break;
            end;
          end;

        end;
      End;
    end;
    /////////////////////////////////////////////////////////
//modify by wjh 2011-10-14
{
    //����DwnTxtFail.log
    /////////////////////////////////////////////////////////
    if FileExists(FailFileName) Then
    begin
      DwnFailTxtLogLst.LoadFromFile(FailFileName);
      For i:=0 to DwnFailTxtLogLst.Count-1 do
      Begin
       StrLst2 := DoStrArray2(DwnFailTxtLogLst.Strings[i],#9);
       StrMemo :=StrLst2[0]+'='+StrLst2[2]+'/'+FormatDateTime('yyyy-mm-dd',StrToFloat(StrLst2[3]));
       For j:=0 to IdxStrLst.Count-1 do
       begin
         if(IdxStrLst.Strings[j]=StrMemo)then
         begin
           IdxStrLst.Delete(j);
           break;
         end;
       end;
      End;
    end; }
    /////////////////////////////////////////////////////////
//��ԭ����Html\Report\DwnTxtFail.log��У��ķ�ʽ��ΪHtml\DocTxt\�µ�.txt�ļ�
for k:=low(DwnFailTxtLst) to high(DwnFailTxtLst) do
    begin
      aId := ExtractFileName(DwnFailTxtLst[k]);
      ReplaceSubString(' (_Title.txt','',aId);

      DwnFailTxtLogLst.LoadFromFile(DwnFailTxtLst[k]);
      For i:=0 to DwnFailTxtLogLst.Count-1 do
      Begin
       StrLst2 := DoStrArray2(DwnFailTxtLogLst.Strings[i],#9);
       StrMemo :=aId+'='+StrLst2[0]+'/'+FormatDateTime('yyyy-mm-dd',StrToFloat(StrLst2[1]));
       For j:=0 to IdxStrLst.Count-1 do
       begin
         if(IdxStrLst.Strings[j]=StrMemo)then
         begin
           IdxStrLst.Delete(j);
           break;
         end;
       end;
      End;
    end;
//   ---
    //if(IdxStrLst.Count>0)then       //delete by wjh 2011-10-14
    begin
      IdxStrLst2.LoadFromFile(DocIdxFile);
      //if(IdxStrLst.Count<1)then exit;   //delete by wjh 2011-10-14

      For i:=0 to IdxStrLst.Count-1 do
      Begin
        StrMemo := IdxStrLst.Strings[i];
        For j:=0 to IdxStrLst2.Count-1 do
        begin
          if(IdxStrLst2.Strings[j]=StrMemo)then
          begin
            IdxStrLst2.Delete(j);
            break;
          end;
        end;
      End;

      //add by wjh 2011-10-14
      //����ID_idx    ��ֹ���������д���Ĺ����޷�������
      /////////////////////////////////////////////////////////
      if(High(IDIdxFileLst)>=1)then
      begin
        For i:=0 to High(IDIdxFileLst) do
        Begin
          if(IDIdxFileLst[i]=DocIdxFile)then
            continue
          else
          begin
            Strlst.LoadFromFile(IDIdxFileLst[i]);
            For j:=0 to IdxStrLst2.Count-1 do
            begin
              if(IdxStrLst2.Strings[j]=Strlst.Strings[0])then
              begin
                IdxStrLst2.Delete(j);
                break;
              end;
            end;
            if FileExists(IDIdxFileLst[i]) then DeleteFile(IDIdxFileLst[i]);
          end;
        End;
      end;
      /////////////////////////////////////////////////////////
      //�������д�������Ĺ���
      j:=0;
      while j<IdxStrLst2.Count-1 do
      begin
        StrMemo := Copy(IdxStrLst2[j],1,Pos('=',IdxStrLst2[j])-1 );
        if FIDLstMgr.IDList.IndexOf(StrMemo)=-1 then
        begin
          IdxStrLst2.Delete(j);
          Continue;
        end;
        Inc(j);
      end;
      ///------
      IdxStrLst2.SaveToFile(DocIdxFile);
    end;
    Result := true;
  end;
  Except
    On E: Exception do
    begin
      ShowMessage(E.message);
      Result := false;
    end;
  End;
Finally
  StrLst.Free;
  IdxStrLst.Free;
  IdxStrLst2.Free;
  DwnFailTxtLogLst.Free;
  setlength(DwnFailTxtLst,0);
END;
end;


procedure TAMainFrm.TimerStopSeviceTimer(Sender: TObject);
begin
  TimerStopSevice.Enabled := false;
  try
    if (((Time>=FParam.StopServiceTime) and (Time<=EncodeTime(23,59,59,0))) or
       ((Time>=EncodeTime(0,0,0,0)) and (Time<=FParam.StartServiceTime)))
    Then
      if NowIsRunning then
        StopGet;

    if (((Time>=FParam.StartServiceTime) and (Time<=FParam.StopServiceTime)))
    Then
      if not NowIsRunning then
        StartGet;
  except
    //
  end;

  TimerStopSevice.Enabled := true;
end;

//--DOC4.0.0��N001 huangcq090407 add----------->
procedure TAMainFrm.SendDocMonitorStatusMsg;
begin

  if ASocketClientFrm<>nil Then
  Begin
     ASocketClientFrm.SendText('SendTo=DocMonitor;'+
                                'Message=Doc_DwnHtml;'
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
  if FStopRunningSkt then exit;
  Try
    WMString :=  ObjWM;
    if WMString.WMType='DOCPACKAGE' Then  //RCCPackage
    Begin
     Value2 := GetReceiveStrColumnValue('Broadcast',WMString.WMReceiveString);
     if Length(Value2)>0 Then
     Begin
        if Value2='CloseSystem' Then
        begin
          FStopRunning := True;
          application.Terminate;
        end;
     End;
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
    if FStopRunningSkt then exit;
    if ASocketClientFrm<>nil Then
       SendDocMonitorStatusMsg(); //��DocMonitor����'������..'

  Finally
    if FStopRunningSkt then TimerSendLiveToDocMonitor.Enabled := False;
    TimerSendLiveToDocMonitor.Tag :=0;
  end;
end;
//<---------DOC4.0.0��N001 huangcq090407 add-------


end.
