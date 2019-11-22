//修改拟发行公告不能审核问题20070808-by LB-modify
//--DOC4.0.0—N001 huangcq090617 add Doc与WarningCenter整合
//--DOC4.0.0—N002 huangcq081223 add 保存于上传查看
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,IdComponent,IdTCPConnection,IdException,IdGlobal,IdTCPClient,
  IdHTTP, Buttons, ExtCtrls, ComCtrls, IdIntercept, IdLogBase, IdLogDebug,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, dxCntner, dxTL,csDef,
  TDocMgr,TCommon,ChkDoc2Frm,ChkDoc3Frm,ViewDocFrm,TZipCompress,MSNPopUp,iniFiles,CBDataLogFrm,
  TMsg;//add by wangjinhua 20090626 Doc4.3

type

  TDoc2ChkOKEvent=Procedure (ADoc:TDocData;Var DoOk:Boolean) of Object;
  TDoc2ChkDelEvent=Procedure (ADoc:TDocData;Var DoOk:Boolean) of Object;

  TDoc3ChkOKEvent=Procedure (ADoc:TDocData;Var DoOk:Boolean) of Object;

  TDocIDChkOKEvent=Procedure (ADoc:TDocData;Var DoOk:Boolean) of Object;

  TDocCheckKeyWordEvent = Procedure (Memo:String;Var KeyWordStr:String) of Object;

  TDisplayWWWCSTitleMgr=Class
  private
     FDocDataMgr: TDocDataMgr;
     FMemo1: TdxTreeList;
     FChkTimer : TTimer;
     FOnDocIDChkOK : TDocIDChkOKEvent;
     procedure DblClick(Sender: TObject);
  Public
      constructor Create(AMemo1: TdxTreeList;DocDataMgr: TDocDataMgr;ChkTimer : TTimer);
      destructor  Destroy; override;
      procedure ClearMsg();
      procedure AddCaption(Const GUID,Caption,Code,TxtType,TxtDateTime,ContentTxt:string);
      function Count():Integer;
      Property OnDocIDChkOK:TDocIDChkOKEvent Write FOnDocIDChkOK;
  end;

  TDisplayWWWCSRCTitleMgr=Class
  private
     FDocDataMgr: TDocDataMgr;
     FMemo1: TdxTreeList;
     FChkTimer : TTimer;
     FOnDoc3ChkOK : TDoc3ChkOKEvent;
     procedure DblClick(Sender: TObject);
  Public
      constructor Create(AMemo1: TdxTreeList;DocDataMgr: TDocDataMgr;ChkTimer : TTimer);
      destructor  Destroy; override;
      procedure ClearMsg();
      procedure AddCaption(Const GUID:string);
      function Count():Integer;
      Property OnDoc3ChkOK:TDoc3ChkOKEvent Write FOnDoc3ChkOK;
  end;

  TDisplayWWWF10TitleMgr=Class
  private
     FDocDataMgr: TDocDataMgr;
     FMemo1: TdxTreeList;
     FChkTimer : TTimer;
     FOnDoc2ChkOK : TDoc2ChkOKEvent;
     FOnDoc2ChkDel : TDoc2ChkDelEvent;
     FOnDocCheckKeyWord: TDocCheckKeyWordEvent;

     procedure OnCustomDraw(Sender: TObject;
               ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
               AColumn: TdxTreeListColumn; const AText: String; AFont: TFont;
               var AColor: TColor; ASelected, AFocused: Boolean; var ADone: Boolean);
     procedure DblClick(Sender: TObject);

  Public
      constructor Create(AMemo1: TdxTreeList;DocDataMgr: TDocDataMgr;ChkTimer : TTimer);
      destructor  Destroy; override;
      procedure ClearMsg();
      procedure AddCaption(Const GUID:string);
      function Count():Integer;
      Property OnDoc2ChkOK:TDoc2ChkOKEvent Write FOnDoc2ChkOK;
      Property OnDoc2ChkDel:TDoc2ChkDelEvent Write FOnDoc2ChkDel;
      Property OnDocCheckKeyWord: TDocCheckKeyWordEvent Write FOnDocCheckKeyWord;

  end;

  TViewWWWF10TitleMgr=Class
  private
     FDocDataMgr: TDocDataMgr;
     FMemo1: TdxTreeList;
     FOnDocCheckKeyWord: TDocCheckKeyWordEvent;

     procedure OnCustomDraw(Sender: TObject;
               ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
               AColumn: TdxTreeListColumn; const AText: String; AFont: TFont;
               var AColor: TColor; ASelected, AFocused: Boolean; var ADone: Boolean);
     procedure DblClick(Sender: TObject);

  Public
      constructor Create(AMemo1: TdxTreeList;DocDataMgr: TDocDataMgr);
      destructor  Destroy; override;
      procedure ClearMsg();
      Procedure BeginUpdate();
      Procedure EndUpdate();
      procedure AddCaption(Const GUID:string);
      Property OnDocCheckKeyWord: TDocCheckKeyWordEvent Write FOnDocCheckKeyWord;

  end;


  TAMainFrm = class(TForm)
    Button1: TButton;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Image2: TImage;
    Panel3: TPanel;
    PageControl1: TPageControl;
    TabSheet_Doc1: TTabSheet;
    ProgressBar1: TProgressBar;
    TabSheet_Doc2: TTabSheet;
    dxTreeList2: TdxTreeList;
    WWWF10_Column_Index: TdxTreeListColumn;
    WWWF10_Column_Caption: TdxTreeListColumn;
    WWWF10_Column_Code: TdxTreeListColumn;
    WWWF10_Column_DateTime: TdxTreeListColumn;
    Timer_ChKDoc_2: TTimer;
    WWWF10_Column_GUID: TdxTreeListColumn;
    Timer_ChKDoc_1: TTimer;
    IdTCPClient1: TIdTCPClient;
    WWWF10_Column_ClassTxt: TdxTreeListColumn;
    WWWF10_Column_ClassColor: TdxTreeListColumn;
    TabSheet_Doc3: TTabSheet;
    dxTreeList3: TdxTreeList;
    WWWCSRC_Column_Index: TdxTreeListColumn;
    WWWCSRC_Column_Caption: TdxTreeListColumn;
    WWWCSRC_Column_DateTime: TdxTreeListColumn;
    WWWCSRC_Column_GUID: TdxTreeListColumn;
    Timer_ChKDoc_3: TTimer;
    StatusBar1: TStatusBar;
    TabSheet_CBMgr: TTabSheet;
    PageControl2: TPageControl;
    Open_Dialog: TOpenDialog;
    Panel4: TPanel;
    btnImport: TSpeedButton;
    Panel5: TPanel;
    btnExport: TSpeedButton;
    Bevel5: TBevel;
    WWWF10_Column_KeyWord: TdxTreeListColumn;
    TabSheet_View: TTabSheet;
    dxTreeList1: TdxTreeList;
    WWWCS_Column_Index: TdxTreeListColumn;
    WWWCS_Column_Caption: TdxTreeListColumn;
    WWWCS_Column_Code: TdxTreeListColumn;
    WWWCS_Column_Type: TdxTreeListColumn;
    WWWCS_Column_DateTime: TdxTreeListColumn;
    WWWCS_Column_Txt: TdxTreeListColumn;
    WWWCS_Column_GUID: TdxTreeListColumn;
    dxTreeList4: TdxTreeList;
    View_Column_Index: TdxTreeListColumn;
    View_Column_Code: TdxTreeListColumn;
    View_Column_Caption: TdxTreeListColumn;
    View_Column_DateTime: TdxTreeListColumn;
    View_Column_GUID: TdxTreeListColumn;
    View_Column_ClassTxt: TdxTreeListColumn;
    View_Column_ClassColor: TdxTreeListColumn;
    View_Column_KeyWord: TdxTreeListColumn;
    Txt_ViewDate: TDateTimePicker;
    Btn_RefreshView: TButton;
    Bevel6: TBevel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    TabSheet_CBInfo: TTabSheet;
    mmoCbInfo: TMemo;
    TabSheet_CBUpload: TTabSheet;
    MemoCB_CBInfo: TMemo;
    PBar: TProgressBar;
    Timer_ChKDoc: TTimer;
    Btn_AutoCheck: TButton;
    Panel_Waring: TPanel;
    Image1: TImage;
    Label2: TLabel;
    Mode_Comb: TComboBox;
    WWWCS_Column_KeyWord: TdxTreeListColumn;
    Lbl_waring1: TLabel;
    Lbl_waring2: TLabel;
    TabSheet_CBLog: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure HTTPStatus(axSender: TObject; const axStatus: TIdStatus;
      const asStatusText: String);
    procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure HTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure Timer_ChKDoc_2Timer(Sender: TObject);
    procedure Timer_ChKDoc_1Timer(Sender: TObject);
    procedure Timer_ChKDoc_3Timer(Sender: TObject);
    procedure IdTCPClient1Status(axSender: TObject;
      const axStatus: TIdStatus; const asStatusText: String);
    procedure IdTCPClient1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdTCPClient1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdTCPClient1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Btn_RefreshViewClick(Sender: TObject);
    procedure Timer_ChKDocTimer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Btn_AutoCheckClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    DisplayWWWCSTitleMgr : TDisplayWWWCSTitleMgr;
    DisplayWWWF10TitleMgr : TDisplayWWWF10TitleMgr;
    ViewWWWF10TitleMgr : TViewWWWF10TitleMgr;
    DisplayWWWCSRCTitleMgr : TDisplayWWWCSRCTitleMgr;
    DocDataMgr_1 : TDocDataMgr;
    DocDataMgr_2 : TDocDataMgr;
    ViewDocMgr_2 : TDocDataMgr;
    DocDataMgr_3 : TDocDataMgr;
    //FAppParam : TDocMgrParam;
    ACBDataLogFrm:TACBDataLogFrm;   //--DOC4.0.0—N002 huangcq081223 add-
    FDataPath : String;
    //FDocPath : String;
    FTempDocFile_1:String;
    FTempDocFile_2:String;
    FTempDocFile_3:String;

    procedure  SetStatus(Sender: TObject; var Done: Boolean); //add by wangjinhua 20090626 Doc4.3
  public
    { Public declarations }

    function HaveKeyWord(const KeyWord,Memo:String):Boolean;

    Procedure OnDocIDChkOK(ADoc:TDocData;Var DoOk:Boolean);
    Procedure OnDoc2ChkOK(ADoc:TDocData;Var DoOk:Boolean);
    Procedure OnDoc2ChkDel(ADoc:TDocData;Var DoOk:Boolean);
    Procedure OnDoc3ChkOK(ADoc:TDocData;Var DoOk:Boolean);
    procedure OnDocCheckKeyWord(Memo:String;Var KeyWordStr:String);

    procedure SetInitConnect();

    procedure  LoadCBTxt();
    procedure GetLogDocText();
    function  GetCBText():Boolean;
    function  SetCBText():Boolean;

    Function  SaveCBText(DocTag:String;DocText:String;action:String='SetCBTxt'):Boolean;
    Function  SaveCBInfoText(DocTag:String;DocText:String):Boolean;
    Procedure SetCheckDoc(Status:TChkStatus;ADoc:TDocData;DocTag:String;Var DoOk:Boolean);

    Function ReadCBDataLog(const FileName:String):String;//--DOC4.0.0—N002 huangcq081223 add
    Function ReadNewDoc(const ReadTag:String):String;
    Function ReadCbinfoDoc(const ReadTag:String):String;
    Function ReadLogDoc(const ReadTag:String):String;
    function  GetDoc3List():Boolean;
    function  GetDoc2List():Boolean;
    function  GetDoc1List():Boolean;
    function  GetViewDocList():Boolean;
    procedure InitForm();
    Procedure InitObj();

    //Procedure WinOnDeActivate(Sender: TObject);
    // WinOnActivate(Sender: TObject);
  end;

var
  AMainFrm: TAMainFrm;
  AutoCheckDoc : Boolean;
  IsHaveError : Boolean;

implementation

uses ChkDoc1Frm;

{$R *.dfm}


function UnicodeEncode(Str:string;CodePage:integer):WideString;
var
  Len:integer;
begin
  Len:=Length(Str)+1;
  SetLength(Result,Len);
  Len:=MultiByteToWideChar(CodePage,0,PChar(Str),-1,PWideChar(Result),Len);
  SetLength(Result,Len-1); //end is #0
end;

procedure TAMainFrm.Button1Click(Sender: TObject);
begin
  LoadCBTxt;
end;


{ TDisplayWWWCSTitleMgr }

procedure TDisplayWWWCSTitleMgr.AddCaption(Const GUID,Caption,Code,TxtType,
TxtDateTime,ContentTxt:string);
Var
  AItem : TdxTreeListNode;
  DocID,KeyWord : String;
  inifile:TiniFile;
  k : Integer;
begin
   //if Length(Caption)=0 Then Exit;
   DocID := Code;
   ReplaceSubString(',',#10#13,DocID);
   inifile:=TiniFile.Create(ExtractFilePath(application.ExeName)+'setup.ini');

   For k:=1 To inifile.ReadInteger('Doc_01_TW','MarkCount',0) do
       if (Pos(inifile.ReadString('Doc_01_TW',IntToStr(k),''),ContentTxt)>0) then
         if(Length(KeyWord)=0)then
           KeyWord:=inifile.ReadString('Doc_01_TW',IntToStr(k),'')
         else
           KeyWord:=KeyWord+','+inifile.ReadString('Doc_01_TW',IntToStr(k),'');

   AItem := FMemo1.Add;
   AItem.Strings[FMemo1.ColumnByName('WWWCS_Column_Index').Index] := IntToStr(FMemo1.Count);
   AItem.Strings[FMemo1.ColumnByName('WWWCS_Column_Caption').Index] := Caption;
   AItem.Strings[FMemo1.ColumnByName('WWWCS_Column_Code').Index] := DocID;
   AItem.Strings[FMemo1.ColumnByName('WWWCS_Column_Type').Index] := TxtType;
   AItem.Strings[FMemo1.ColumnByName('WWWCS_Column_KeyWord').Index] := KeyWord;
   AItem.Strings[FMemo1.ColumnByName('WWWCS_Column_DateTime').Index] := TxtDateTime;
   AItem.Strings[FMemo1.ColumnByName('WWWCS_Column_Txt').Index] := ContentTxt;
   AItem.Strings[FMemo1.ColumnByName('WWWCS_Column_GUID').Index] := GUID;
   FMemo1.Refresh;

   inifile.Free;
end;

procedure TDisplayWWWCSTitleMgr.ClearMsg;
begin
   FMemo1.ClearNodes;
end;

function TDisplayWWWCSTitleMgr.Count: Integer;
begin
   Result := FMemo1.Count;
end;

constructor TDisplayWWWCSTitleMgr.Create(AMemo1: TdxTreeList;DocDataMgr: TDocDataMgr;ChkTimer : TTimer);
begin
   FMemo1 := AMemo1;
   FDocDataMgr := DocDataMgr;
   FChkTimer := ChkTimer;
   FMemo1.OnDblClick := DblClick;
   ClearMsg;
end;

procedure TDisplayWWWCSTitleMgr.DblClick(Sender: TObject);
Var
  aNode : TdxTreeListNode;
  AChkDoc1Frm : TAChkDoc1Frm;
  GUID : String;
  ADoc : TDocData;
  Status : TChkStatus;
  //StrLst : _CStrLst;
  DoOk : Boolean;
begin



   aNode := FMemo1.FocusedNode;
   if aNode=nil Then Exit;
   FMemo1.Enabled := False;
try
   GUID := aNode.Strings[FMemo1.ColumnByName('WWWCS_Column_GUID').Index];

   ADoc := FDocDataMgr.GetADoc(GUID);

   AChkDoc1Frm := TAChkDoc1Frm.Create(nil);

   application.ProcessMessages;      //by leon 0808

   Status :=  AChkDoc1Frm.OpenChkFrm(ADoc.Memo,ADOC.DOCID,ADoc.Title,aNode.Strings[FMemo1.ColumnByName('WWWCS_Column_KeyWord').Index]);

   if Status=chkOk Then
   Begin

     if Length(AChkDoc1Frm.FMemo)>0 Then
     Begin
        ADoc.Memo := AChkDoc1Frm.FMemo;
        ADoc.DOCID   := AChkDoc1Frm.FID;
     End;

   End;

   Case Status of
      chkOK :Begin
                if Assigned(FOnDocIDChkOK) Then
                Begin
                    FOnDocIDChkOK(ADoc,DoOk);
                    if DoOk Then
                    Begin
                     FDocDataMgr.FreeADoc(ADoc.GUID);
                     aNode.Free;
                    End;
                End;
             End;
    End;


finally
   AChkDoc1Frm.Destroy;
   if Self.Count=0 Then
      FChkTimer.Enabled := true;
   FMemo1.Enabled := True;
end;

end;

destructor TDisplayWWWCSTitleMgr.Destroy;
begin
  ClearMsg;
  //inherited;
end;

procedure TAMainFrm.HTTPStatus(axSender: TObject;
  const axStatus: TIdStatus; const asStatusText: String);
begin
  StatusBar1.Panels[1].Text := asStatusText;
end;

procedure TAMainFrm.HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  if ProgressBar1.Max > 0 then
  begin
    StatusBar1.Panels[1].Text := IntToStr(AWorkCount) + ' bytes of ' +
      IntToStr(ProgressBar1.Max) + ' bytes.';
    //ProgressBar1.Position := AWorkCount;
  end
  else
    StatusBar1.Panels[1].Text := IntToStr(AworkCount) + ' bytes.';

end;

procedure TAMainFrm.HTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  //ProgressBar1.Position := 0;
  //ProgressBar1.Max := AWorkcountMax;
  if AWorkCountMax > 0 then
    StatusBar1.Panels[1].Text := 'Transfering: ' + IntToStr(AWorkCountMax);

end;

procedure TAMainFrm.HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  StatusBar1.Panels[1].Text := 'Done';
  //ProgressBar1.Position := 0;

end;

procedure TAMainFrm.InitForm;
begin

  FDataPath := ExtractFilePath(Application.ExeName)+'Data\';
  //FDocPath  := FDataPath + 'Doc\';

  FTempDocFile_1 := FDataPath+'Doc_01.tmp';
  FTempDocFile_2 := FDataPath+'Doc_02.tmp';
  FTempDocFile_3 := FDataPath+'Doc_03.tmp';

  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;

//modify by wangjinhua 20090626 Doc4.3
  MemoCB_CBInfo.Clear;
  mmoCbInfo.Clear;
  {
  MemoCB_Ready.Clear;
  MemoCB_Pass.Clear;
  MemoCB_SH.Clear;
  MemoCB_SZ.Clear;
  MemoCB_PassAway.Clear;
  MemoCB_Stop.Clear;
  MemoCB_CBInfo.Clear;
  MemoCB_shangshi.Clear;
  MemoCB_shanggui.Clear;
  MemoCB_song.Clear;
  }
//

  Txt_ViewDate.Date := Date;

end;

procedure TAMainFrm.InitObj;
begin

  DocDataMgr_1 := TDocDataMgr.Create(FTempDocFile_1,'');
  DocDataMgr_2 := TDocDataMgr.Create(FTempDocFile_2,'');
  ViewDocMgr_2 := TDocDataMgr.Create(FTempDocFile_2,'');
  DocDataMgr_3 := TDocDataMgr.Create(FTempDocFile_3,'');

  FAppParam := TDocMgrParam.Create;

  DisplayWWWCSTitleMgr  := TDisplayWWWCSTitleMgr.Create(dxTreeList1,DocDataMgr_1,Timer_ChKDoc_1);
  DisplayWWWF10TitleMgr := TDisplayWWWF10TitleMgr.Create(dxTreeList2,DocDataMgr_2,Timer_ChKDoc_2);
  ViewWWWF10TitleMgr := TViewWWWF10TitleMgr.Create(dxTreeList4,ViewDocMgr_2);
  DisplayWWWCSRCTitleMgr := TDisplayWWWCSRCTitleMgr.Create(dxTreeList3,DocDataMgr_3,Timer_ChKDoc_3);

  DisplayWWWF10TitleMgr.OnDoc2ChkOK := OnDoc2ChkOK;
  DisplayWWWF10TitleMgr.OnDoc2ChkDel := OnDoc2ChkDel;
  DisplayWWWF10TitleMgr.OnDocCheckKeyWord := OnDocCheckKeyWord;
  ViewWWWF10TitleMgr.OnDocCheckKeyWord := OnDocCheckKeyWord;

  DisplayWWWCSTitleMgr.OnDocIDChkOK  := OnDocIDChkOK;
  DisplayWWWCSRCTitleMgr.OnDoc3ChkOK  := OnDoc3ChkOK;

end;

procedure TAMainFrm.FormCreate(Sender: TObject);
begin
   InitForm();
   InitObj();

   Caption := FAppParam.ConvertString('网上发行公告搜寻');
   Caption := FAppParam.ConvertString('网上发行公告搜寻(手动)');
   TabSheet_Doc1.Caption := FAppParam.ConvertString('拟发行公告代码收集');
   TabSheet_Doc3.Caption := FAppParam.ConvertString('过会转债公告');
   TabSheet_Doc2.Caption := FAppParam.ConvertString('公告信息');
   TabSheet_CBMgr.Caption := FAppParam.ConvertString('条款上传');
   TabSheet_View.Caption := FAppParam.ConvertString('已审核通过纪录');
   Label1.Caption := FAppParam.ConvertString('');
   Label2.Caption := FAppParam.ConvertString('网上发行公告搜寻');


   dxTreeList1.Columns[1].Caption := FAppParam.ConvertString('标题');
   dxTreeList1.Columns[2].Caption := FAppParam.ConvertString('代码');
   dxTreeList1.Columns[3].Caption := FAppParam.ConvertString('关键字');
   dxTreeList1.Columns[4].Caption := FAppParam.ConvertString('栏 目');
   dxTreeList1.Columns[5].Caption := FAppParam.ConvertString('时 间');
   dxTreeList1.Columns[6].Caption := FAppParam.ConvertString('备注');

   dxTreeList3.Columns[1].Caption := FAppParam.ConvertString('标题');
   dxTreeList3.Columns[2].Caption := FAppParam.ConvertString('时 间');


   dxTreeList2.Columns[1].Caption := FAppParam.ConvertString('代码');
   dxTreeList2.Columns[2].Caption := FAppParam.ConvertString('标题');
   dxTreeList2.Columns[3].Caption := FAppParam.ConvertString('时 间');
   dxTreeList2.Columns[4].Caption := FAppParam.ConvertString('执行事件');
   dxTreeList2.Columns[5].Caption := FAppParam.ConvertString('内文关键字');


   dxTreeList4.Columns[1].Caption := FAppParam.ConvertString('代码');
   dxTreeList4.Columns[2].Caption := FAppParam.ConvertString('标题');
   dxTreeList4.Columns[3].Caption := FAppParam.ConvertString('时 间');
   dxTreeList4.Columns[4].Caption := FAppParam.ConvertString('执行事件');
   dxTreeList4.Columns[5].Caption := FAppParam.ConvertString('内文关键字');
   RadioButton1.Caption := FAppParam.ConvertString('通过');
   RadioButton2.Caption := FAppParam.ConvertString('未通过');
   Btn_RefreshView.Caption := FAppParam.ConvertString('刷      新');

   Panel5.Caption  := FAppParam.ConvertString('功能列表');
   btnImport.Caption  := FAppParam.ConvertString('导入文件');
   btnExport.Caption  := FAppParam.ConvertString('上传文件');
   //modify by wangjinhua 20090626 Doc4.2
   TabSheet_CBUpload.Caption := FAppParam.ConvertString('条款上传');
   TabSheet_CBInfo.Caption := FAppParam.ConvertString('删除转债');
   TabSheet_CBLog.Caption:=FAppParam.ConvertString('CB资料上传查看');
   //--

   Btn_AutoCheck.Caption := FAppParam.ConvertString('自动检查公告');

   Mode_Comb.Items.Clear;
   Mode_Comb.Items.Add(FAppParam.ConvertString('公告'));
   Mode_Comb.Items.Add(FAppParam.ConvertString('拟发'));
   Mode_Comb.Items.Add(FAppParam.ConvertString('过会'));
   Mode_Comb.ItemIndex:=0;

   AutoCheckDoc := false;
   IsHaveError := false;
   Panel_Waring.Visible :=false;

   //add by wangjinhua 20090626 Doc4.3
   Application.OnIdle:=SetStatus;
   //--
end;

//add by wangjinhua 20090626 Doc4.3
procedure TAMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.OnIdle:=nil;
end;

procedure  TAMainFrm.SetStatus(Sender: TObject; var Done: Boolean);
begin
  btnImport.Enabled :=  (PageControl2.ActivePage = TabSheet_CBUpload);
  btnExport.Enabled :=  (PageControl2.ActivePage = TabSheet_CBUpload) or
                         (PageControl2.ActivePage = TabSheet_CBInfo) ;
end;
//--

procedure TAMainFrm.btnGoClick(Sender: TObject);
begin
   DisplayWWWCSTitleMgr.ClearMsg;
end;





{ TDisplayWWWF10TitleMgr }

procedure TDisplayWWWF10TitleMgr.AddCaption(Const GUID:string);
Var
  AItem : TdxTreeListNode;
  ADoc:TDocData;
  KeyWordStr : String;
begin

   ADoc := FDocDataMgr.GetADoc(GUID);
   if Not Assigned(ADoc) Then exit;

   if Assigned(FOnDocCheckKeyWord) Then
      FOnDocCheckKeyWord(ADoc.Memo,KeyWordStr);

   AItem := FMemo1.Add;
   AItem.Strings[FMemo1.ColumnByName('WWWF10_Column_Index').Index] := IntToStr(FMemo1.Count);
   AItem.Strings[FMemo1.ColumnByName('WWWF10_Column_Caption').Index] := ADoc.Title;
   AItem.Strings[FMemo1.ColumnByName('WWWF10_Column_Code').Index] := ADoc.ID;
   AItem.Strings[FMemo1.ColumnByName('WWWF10_Column_DateTime').Index] := ADoc.FmtDate;
   AItem.Strings[FMemo1.ColumnByName('WWWF10_Column_GUID').Index] := GUID;
   AItem.Strings[FMemo1.ColumnByName('WWWF10_Column_ClassTxt').Index] := ADoc.DocClassTxt;
   AItem.Strings[FMemo1.ColumnByName('WWWF10_Column_ClassColor').Index] := IntToStr(ADoc.DocClassColor);
   AItem.Strings[FMemo1.ColumnByName('WWWF10_Column_KeyWord').Index] := KeyWordStr;

   FMemo1.Refresh;

end;

procedure TDisplayWWWF10TitleMgr.ClearMsg;
begin
   FMemo1.ClearNodes;
   //if Assigned(FChkTimer) Then
   //FChkTimer.Enabled := true;
end;

function TDisplayWWWF10TitleMgr.Count: Integer;
begin
   Result := FMemo1.Count;
end;

constructor TDisplayWWWF10TitleMgr.Create(AMemo1: TdxTreeList;DocDataMgr: TDocDataMgr;ChkTimer : TTimer);
begin
   FMemo1 := AMemo1;
   FDocDataMgr := DocDataMgr;
   FChkTimer := ChkTimer;
   FMemo1.OnDblClick := DblClick;
   FMemo1.OnCustomDraw := OnCustomDraw;
   ClearMsg;
end;

procedure TDisplayWWWF10TitleMgr.DblClick(Sender: TObject);
Var
  aNode : TdxTreeListNode;
  AChkDoc2Frm : TAChkDoc2Frm;
  GUID : String;
  ADoc : TDocData;
  Status : TChkStatus;
  DoOk : Boolean;
  KeyWord : string;
begin

   aNode := FMemo1.FocusedNode;
   if aNode=nil Then Exit;




   GUID := aNode.Strings[FMemo1.ColumnByName('WWWF10_Column_GUID').Index];
   KeyWord := aNode.Strings[FMemo1.ColumnByName('WWWF10_Column_KeyWord').Index];

   ADoc := FDocDataMgr.GetADoc(GUID);
   AChkDoc2Frm := TAChkDoc2Frm.Create(nil);

   FMemo1.Enabled := False;
Try

  Status :=  AChkDoc2Frm.OpenChkFrm(ADoc.DocClassIndex,
                                    ADoc.CBID,ADoc.Memo,ADoc.Title,KeyWord,ADoc.URL);

   if Length(AChkDoc2Frm.FMemo)>0 Then
      ADoc.Memo := AChkDoc2Frm.FMemo;

   Case Status of
      chkOK :Begin
               if Assigned(FOnDoc2ChkOK) Then
                  FOnDoc2ChkOK(ADoc,DoOk);
               FDocDataMgr.FreeADoc(ADoc.GUID);
               aNode.Free;
             End;
      chkDel:Begin
                if Assigned(FOnDoc2ChkDel) Then
                Begin
                    FOnDoc2ChkDel(ADoc,DoOk);
                    if DoOk Then
                    Begin
                      FDocDataMgr.FreeADoc(ADoc.GUID);
                      aNode.Free;
                    End;
                End;
             End;
    End;

Finally
   AChkDoc2Frm.Destroy;

   if Assigned(FChkTimer) Then
     if Self.Count=0 Then
        FChkTimer.Enabled := true;
   FMemo1.Enabled := True;
End;
end;

destructor TDisplayWWWF10TitleMgr.Destroy;
begin
  FMemo1.ClearNodes;
end;

procedure TAMainFrm.Timer_ChKDoc_2Timer(Sender: TObject);
Var
   ADoc:TDocData;
   i : Integer;
begin
Try
   if PageControl1.ActivePage=TabSheet_Doc2 Then
   Begin
      Timer_ChKDoc_2.Enabled := false;
      if(DisplayWWWF10TitleMgr.Count>0)then
        exit;
      if GetDoc2List Then
      Begin
        if(DocDataMgr_2.DocList.Count>0)then
           DisplayWWWF10TitleMgr.ClearMsg;
        for i:=0 to DocDataMgr_2.DocList.Count-1 do
        Begin
          ADoc := DocDataMgr_2.DocList.Items[i];
          DisplayWWWF10TitleMgr.AddCaption(ADoc.GUID);
        End;
      End;
     Timer_ChKDoc_2.Interval := 5000;
     if DisplayWWWF10TitleMgr.Count=0 Then
        Timer_ChKDoc_2.Enabled := true;
   End;
Except
End;
end;

procedure TAMainFrm.Timer_ChKDoc_1Timer(Sender: TObject);
Var
   ADoc:TDocData;
   i : Integer;
begin
Try
   if PageControl1.ActivePage=TabSheet_Doc1 Then
   Begin
     Timer_ChKDoc_1.Enabled := false;
     if(DisplayWWWCSTitleMgr.Count>0)then
        exit;
     if GetDoc1List Then
     Begin
        if(DocDataMgr_1.DocList.Count>0)then
           DisplayWWWCSTitleMgr.ClearMsg;
        for i:=0 to DocDataMgr_1.DocList.Count-1 do
        Begin
          ADoc := DocDataMgr_1.DocList.Items[i];
          DisplayWWWCSTitleMgr.AddCaption(ADoc.GUID ,ADoc.Title,ADoc.DOCID,ADoc.DocType,
                                         ADoc.FmtDateTime,Adoc.Memo);
        End;
     End;
     Timer_ChKDoc_1.Interval := 5000;
     if DisplayWWWCSTitleMgr.Count=0 Then
        Timer_ChKDoc_1.Enabled := true;
    End;

Except
End;
end;

function TAMainFrm.GetDoc2List:Boolean;
begin


  Result := false;
Try
Try
  DocDataMgr_2.DocListText  := ReadNewDoc('ReadNewDoc2');
  Result := True;
Except
end;
finally
end;

end;

procedure TAMainFrm.SetInitConnect;
begin
  //add by JoySun 2005/10/24
  //连接超时进行响应
  IdTCPClient1.ReadTimeout:=90000;
  IdTCPClient1.Port := 8090;
  IdTCPClient1.Host := FAppParam.DocServer;

end;

procedure TAMainFrm.OnDoc2ChkOK(ADoc: TDocData;Var DoOk:Boolean);
begin
   SetCheckDoc(chkOK,ADoc,'DOC2',DoOK);
end;


procedure TAMainFrm.OnDoc2ChkDel(ADoc: TDocData; var DoOk: Boolean);
begin
   SetCheckDoc(chkDel,ADoc,'DOC2',DoOK);
end;

procedure TAMainFrm.OnDocIDChkOK(ADoc: TDocData; var DoOk: Boolean);
begin
   SetCheckDoc(chkOK,ADoc,'DOC1',DoOK);
end;


function TAMainFrm.GetDoc1List: Boolean;
begin


  Result := false;
Try
Try
  DocDataMgr_1.DocListText  := ReadNewDoc('ReadNewDoc1');
  Result := True;
Except
end;
finally
end;

end;

procedure TDisplayWWWF10TitleMgr.OnCustomDraw(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; const AText: String; AFont: TFont;
  var AColor: TColor; ASelected, AFocused: Boolean; var ADone: Boolean);
Var
  Color : TColor;
begin
   if Not ASelected Then
   Begin
     Color := StrToInt(ANode.Strings[FMemo1.ColumnByName('WWWF10_Column_ClassColor').Index]);
     if Color>=0 Then
     Begin
        AColor := Color;
        AFont.Color := clWhite;
     End;
   End;
end;

{ TDisplayWWWCSRCTitleMgr }

procedure TDisplayWWWCSRCTitleMgr.AddCaption(const GUID: string);
Var
  AItem : TdxTreeListNode;
  ADoc:TDocData;
begin

   ADoc := FDocDataMgr.GetADoc(GUID);
   if Not Assigned(ADoc) Then exit;

   AItem := FMemo1.Add;
   AItem.Strings[FMemo1.ColumnByName('WWWCSRC_Column_Index').Index] := IntToStr(FMemo1.Count);
   AItem.Strings[FMemo1.ColumnByName('WWWCSRC_Column_Caption').Index] := ADoc.Title;
   AItem.Strings[FMemo1.ColumnByName('WWWCSRC_Column_DateTime').Index] := ADoc.FmtDate;
   AItem.Strings[FMemo1.ColumnByName('WWWCSRC_Column_GUID').Index] := GUID;

   FMemo1.Refresh;
   
end;

procedure TDisplayWWWCSRCTitleMgr.ClearMsg;
begin
   FMemo1.ClearNodes;

end;

function TDisplayWWWCSRCTitleMgr.Count: Integer;
begin
   Result := FMemo1.Count;

end;

constructor TDisplayWWWCSRCTitleMgr.Create(AMemo1: TdxTreeList;
  DocDataMgr: TDocDataMgr; ChkTimer: TTimer);
begin
   FMemo1 := AMemo1;
   FDocDataMgr := DocDataMgr;
   FChkTimer := ChkTimer;
   FMemo1.OnDblClick := DblClick;
   ClearMsg;
end;

procedure TDisplayWWWCSRCTitleMgr.DblClick(Sender: TObject);
Var
  aNode : TdxTreeListNode;
  AChkDoc3Frm : TAChkDoc3Frm;
  GUID : String;
  ADoc : TDocData;
  Status : TChkStatus;
  //StrLst : _CStrLst;
  //i : Integer;
  //IsOK : Boolean;
  DoOk : Boolean;
begin
   aNode := FMemo1.FocusedNode;
   if aNode=nil Then Exit;
    FMemo1.Enabled := False;
try
   GUID := aNode.Strings[FMemo1.ColumnByName('WWWCSRC_Column_GUID').Index];

   ADoc := FDocDataMgr.GetADoc(GUID);

   AChkDoc3Frm := TAChkDoc3Frm.Create(nil);

   Status :=  AChkDoc3Frm.OpenChkFrm(ADoc.Memo,ADoc.Title);


   Case Status of
      chkOK :Begin
                if Assigned(FOnDoc3ChkOK) Then
                Begin
                    FOnDoc3ChkOK(ADoc,DoOk);
                    if DoOk Then
                    Begin
                      FDocDataMgr.FreeADoc(ADoc.GUID);
                      aNode.Free;
                    End;
                End;
             End;
    End;
finally
   AChkDoc3Frm.Destroy;
   if Self.Count=0 Then
      FChkTimer.Enabled := true;
   FMemo1.Enabled := true;
end;

end;

destructor TDisplayWWWCSRCTitleMgr.Destroy;
begin
  ClearMsg;
end;

procedure TAMainFrm.OnDoc3ChkOK(ADoc: TDocData; var DoOk: Boolean);
begin
   SetCheckDoc(chkOK,ADoc,'DOC3',DoOK);
end;


function TAMainFrm.GetDoc3List: Boolean;
begin

  Result := false;
Try
Try
  DocDataMgr_3.DocListText  := ReadNewDoc('ReadNewDoc3');
  Result := True;
Except
end;
finally
end;

end;

procedure TAMainFrm.Timer_ChKDoc_3Timer(Sender: TObject);
Var
   ADoc:TDocData;
   i : Integer;
begin
Try
   if PageControl1.ActivePage=TabSheet_Doc3 Then
   Begin
      Timer_ChKDoc_3.Enabled := false;
      if(DisplayWWWCSTitleMgr.Count>0)then
        exit;
      if GetDoc3List Then
      Begin
        if(DocDataMgr_3.DocList.Count>0)then
           DisplayWWWCSRCTitleMgr.ClearMsg;
        for i:=0 to DocDataMgr_3.DocList.Count-1 do
        Begin
          ADoc := DocDataMgr_3.DocList.Items[i];
          DisplayWWWCSRCTitleMgr.AddCaption(ADoc.GUID);
        End;
     End;
     Timer_ChKDoc_3.Interval := 5000;
     if DisplayWWWCSRCTitleMgr.Count=0 Then
        Timer_ChKDoc_3.Enabled := true;
   End;
Except
End;

End;

function TAMainFrm.ReadNewDoc(const ReadTag: String):String;
var
  SResponse: string;
  AStream: TMemoryStream;
  AStrStream: TStringStream;
  //f : TStringList;
  Msner: TMSNPopUp;
  //BitMap:TBitMap;
begin

  SetInitConnect;

  AStream := nil;
  Result := '';
  Msner:=TMSNPopUp.Create(self);
        {Bitmap := TBitmap.Create;
        Bitmap.LoadFromFile('PopUp.bmp'); }

Try
Try

  with IdTCPClient1 do
  begin
    Connect;
    while Connected do
    begin

        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then Break;

        WriteLn(ReadTag);

        AStrStream := TStringStream.Create('');
        AStream := TMemoryStream.Create();
        ReadStream(AStream, -1, True);

        DeCompressStream(AStream);
        AStream.SaveToStream(AStrStream);

        Result := AStrStream.DataString;

        AStrStream.Free;

        Disconnect;

    end;
  end;
  Panel_Waring.Visible :=false;
  IsHaveError := false;


Except
   //add by JoySun 2005/10/24
   On E : Exception do
   Begin

      if(Pos('Stream',Trim(E.Message))=0) then
      begin
        Panel_Waring.Visible :=true;
        {
        Lbl_waring1.Caption :=FAppParam.ConvertString('Connecting Error,Retry Again And Check The DocSever!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('Error Message:'+Trim(E.Message));
        }

        Lbl_waring1.Caption :=FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('错误信息:'+Trim(E.Message));

        if(AutoCheckDoc)and(not IsHaveError)then
        begin
        Msner.BackgroundImage:=image1.Picture.Bitmap;
        Msner.Title := FAppParam.ConvertString('DocMgr错误信息');
        Msner.Text := FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Msner.ShowPopUp;
        IsHaveError := true;
        end;

     end;

   End;
end;

finally
   IdTCPClient1.Disconnect;
   if AStream<>nil Then
      AStream.Free;

   if Assigned(Msner) then
    Msner.Free;
   {if Assigned(Bitmap) then
    Bitmap.Free; }
end;

end;

//--DOC4.0.0—N002 huangcq081223 add ---------------------------->
Function TAMainFrm.ReadCBDataLog(const FileName:String):String;
var
  AMemoryStream: TMemoryStream;
  AStream: TStringStream;
  SResponse,DstFile1: string;
begin
  SetInitConnect;
  AStream := nil;
  Result := '';
  Try
    Try
      with AMainFrm.IdTCPClient1 do
      begin
        Connect;
        while Connected do
        begin
          SResponse := UpperCase(ReadLn);
          if Pos('CONNECTOK', SResponse) = 0 then Break;

          WriteLn('GetCBDataLog');
          SResponse := UpperCase(ReadLn);
          if Pos('HELLO', SResponse) > 0 then
          Begin
            WriteLn(FileName); //Eg:'20081022.log'
            AMemoryStream :=TMemoryStream.Create;
            AStream :=TStringStream.Create('');

            ReadStream(AMemoryStream,-1,True);
            AMemoryStream.Position:=0;
            DeCompressStream(AMemoryStream);

            {
            AMemoryStream.SaveToStream(AStream);
            AMemoryStream.Free;
            AMemoryStream :=nil;
            }

            DstFile1 := GetWinTempPath+FileName;
            DeleteFile(DstFile1);
            if FileExists(DstFile1) Then Exit;

            AMemoryStream.SaveToFile(DstFile1);
            AMemoryStream.Free;
            AMemoryStream :=nil;

            Result := DstFile1;

            //将返回的Log显示到界面
            //AddLogToTreeList(MnulReadAllLog,AStream.DataString,DocTag);
          End;
          Disconnect;
        end;
      end;
    Except
    end;
  finally
     AMainFrm.IdTCPClient1.Disconnect;
     if AStream<>nil Then AStream.Free;
  end;
end;
//<--DOC4.0.0—N002 huangcq081223 add ---------------------------

procedure TAMainFrm.SetCheckDoc(Status: TChkStatus; ADoc: TDocData;
  DocTag:String;var DoOk: Boolean);
Var
  AStream: TMemoryStream;
  SResponse: string;
  Msner: TMSNPopUp;
  //BitMap:TBitMap;
begin

   SetInitConnect;
   AStream := nil;

   DoOK := False;
 Msner:=TMSNPopUp.Create(self);
        {Bitmap := TBitmap.Create;
        Bitmap.LoadFromFile('PopUp.bmp'); }
try
try

   with IdTCPClient1 do
   begin
     Connect;
     while Connected do
     begin

        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then
           Break;

        Case Status of
         chkOK :Begin
                 WriteLn('DOCOK');
                End;
         chkDel:Begin
                 WriteLn('DOCDEL');
                End;
        End;

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
          WriteLn(DocTag);

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
        Begin

          AStream := TMemoryStream.Create;
          CompressStream(ADoc.Text,AStream);

          OpenWriteBuffer;
          WriteStream(AStream);
          CloseWriteBuffer;

          //AStream := TStringStream.Create(ADoc.Text);
          //OpenWriteBuffer;
          //WriteStream(AStream);
          //CloseWriteBuffer;
          //AStream.Free;
        End;

        Disconnect;

     end;

   end;

   DoOk := True;
   Panel_Waring.Visible :=false;
   IsHaveError := false;

Except
   //add by JoySun 2005/10/24
   On E : Exception do
   Begin
      
      if(Pos('Stream',Trim(E.Message))=0) then
      begin
      Panel_Waring.Visible :=true;
      {
        Lbl_waring1.Caption :=FAppParam.ConvertString('Connecting Error,Retry Again And Check The DocSever!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('Error Message:'+Trim(E.Message));
        }

        Lbl_waring1.Caption :=FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('错误信息:'+Trim(E.Message));

      if(AutoCheckDoc)and(not IsHaveError)then
      begin

        Msner.BackgroundImage:=image1.Picture.Bitmap;
        Msner.Title := FAppParam.ConvertString('DocMgr错误信息');
        Msner.Text := FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Msner.ShowPopUp;
        IsHaveError := true;
      end;

      end;


   End;
End;

Finally
   if Assigned(AStream) Then
      AStream.Free;
   IdTCPClient1.Disconnect;
   if Assigned(Msner) then                 
    Msner.Free;
  {if Assigned(Bitmap) then
    Bitmap.Free;  }
end;

end;

procedure TAMainFrm.IdTCPClient1Status(axSender: TObject;
  const axStatus: TIdStatus; const asStatusText: String);
begin
  StatusBar1.Panels[2].Text := asStatusText;
end;

procedure TAMainFrm.IdTCPClient1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
StatusBar1.Panels[2].Text := IntToStr(AworkCount) + ' bytes.';
end;

procedure TAMainFrm.IdTCPClient1WorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
  if AWorkCountMax > 0 then
    StatusBar1.Panels[2].Text := 'Transfering: ' + IntToStr(AWorkCountMax);
end;

procedure TAMainFrm.IdTCPClient1WorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
  StatusBar1.Panels[2].Text := 'Done';
end;

function TAMainFrm.GetCBText(): Boolean;
begin
  Result := false;
  if PageControl1.ActivePage<>TabSheet_CBMgr Then
     Exit;
Try
Try
//modify by wangjinhua 20090626 Doc4.3
  if PageControl2.ActivePage = TabSheet_CBInfo then
  begin
    if Length(mmoCbInfo.text)=0 Then
       mmoCbInfo.Text :=  ReadCbinfoDoc('cbinfo.dat');
  end
  else if PageControl2.ActivePage = TabSheet_CBLog then
  begin
    if Assigned(ACBDataLogFrm) then
      ACBDataLogFrm.RefreshLog()
    else begin
      ACBDataLogFrm:=TACBDataLogFrm.Create(self);
      ACBDataLogFrm.SetInit(TabSheet_CBLog,ReadCBDataLog(FormatDateTime('yymmdd',Date)+'.log'));
    end;
  end;
  {
  if PageControl2.ActivePage=TabSheet_CBInfo Then
  Begin
     if Length(MemoCB_CBInfo.text)=0 Then
       MemoCB_CBInfo.Text :=  ReadCbinfoDoc('cbinfo.dat');
  End;
  if PageControl2.ActivePage=TabSheet_CBReady Then
  Begin
     //MemoCB_Ready.Clear;
     //MemoCB_Ready.Lines.Text := ReadNewDoc('Readnifaxing');
  End;
  if PageControl2.ActivePage=TabSheet_CBPass Then
  Begin
     //MemoCB_Pass.Clear;
     //MemoCB_Pass.Lines.Text := ReadNewDoc('Readpass');
  End;
  if PageControl2.ActivePage=TabSheet_CBSh Then
  Begin
     //MemoCB_SH.Clear;
     //MemoCB_SH.Lines.Text := ReadNewDoc('Readhushi');
  End;
  if PageControl2.ActivePage=TabSheet_CBSZ Then
  Begin
     //MemoCB_SZ.Clear;
     //MemoCB_SZ.Lines.Text := ReadNewDoc('Readshenshi');
  End;
  if PageControl2.ActivePage=TabSheet_CBpassaway Then
  Begin
     //MemoCB_PassAway.Clear;
     //MemoCB_PassAway.Lines.Text := ReadNewDoc('Readpassaway');
  End;
  }
//--
  Result := True;
Except
end;
finally
end;
end;


procedure TAMainFrm.PageControl1Change(Sender: TObject);
begin
try
   GetCBText;
except
end;
end;

procedure TAMainFrm.PageControl2Change(Sender: TObject);
begin
try
  GetCBText;
except
end;
end;

function TAMainFrm.SetCBText: Boolean;
var
  i,iPos:Integer;
  aLine,vCID:String;
begin
  Result := false;
  if PageControl1.ActivePage<>TabSheet_CBMgr Then
     Exit;
Try
Try
  //modify by wangjinhua 20090626 Doc4.2
  vCID := '';

  if PageControl2.ActivePage = TabSheet_CBInfo then
  begin
    with mmoCbInfo do
    begin
      for i := 0 to Lines.Count - 1 do
      begin
        aLine := Lines[i];
        if SameText('[System_CBPA]',aLine) then
        begin
          vCID := 'cbinfo';
          break;
        end;
      end;
    end;
  end
  else if PageControl2.ActivePage = TabSheet_CBUpload then
  begin
    with MemoCB_CBInfo do
    begin
      for i := 0 to Lines.Count - 1 do
      begin
        aLine := Lines[i];
        iPos := Pos('CID=',UpperCase(aLine));
        if iPos > 0 then
        begin
          vCID := Copy(aLine,
                      iPos + Length('CID='),
                      Length(aLine) - iPos - Length('CID=') + 1 );
          break;
        end;
      end;
    end;
  end  else
    exit;




  if vCID = '' then
  begin
    MsgHint('上传文件失败,请校验导入文件是否正确');
    exit;
  end;

  case SLType of
      sltCHS: begin
                if (not SameText(vCID,'cbinfo')) and
                   (not SameText(vCID,'Announce')) and
                   (not SameText(vCID,'pass')) and
                   (not SameText(vCID,'market_sh')) and
                   (not SameText(vCID,'market_sz')) and
                   (not SameText(vCID,'passaway')) and
                   (not SameText(vCID,'Stop_Issue')) and
                   (not SameText(vCID,'Prepare_List_china')) then
                begin
                  MsgHint('上传文件失败,请校验导入文件是否正确');
                  exit;
                end;
              end;
      sltCHT: begin
                if (not SameText(vCID,'cbinfo')) and
                   (not SameText(vCID,'Announce_tw')) and
                   (not SameText(vCID,'Pass_tw')) and
                   (not SameText(vCID,'TW_Stop')) and
                   (not SameText(vCID,'StopIssue_tw')) and
                   (not SameText(vCID,'TW_OTC')) and
                   (not SameText(vCID,'TW_Market')) and
                   (not SameText(vCID,'Send_tw')) and
                   (not SameText(vCID,'Prepare_List_tw')) then
                begin
                  MsgHint('上传文件失败,请校验导入文件是否正确');
                  exit;
                end;
              end;
      else raise Exception.create('System language  can not be found !');
  end;


  if SameText(vCID,'cbinfo')  Then
  begin
    SaveCBInfoText('cbinfo.dat',mmoCbInfo.Lines.Text);
    //mmoCbInfo.Clear;
  end
  else if SameText(vCID,'Announce_tw') or SameText(vCID,'Announce') Then
    SaveCBText('nifaxing',MemoCB_CBInfo.Lines.Text)
  else if SameText(vCID,'Pass_tw') or SameText(vCID,'Pass') Then
    SaveCBText('pass',MemoCB_CBInfo.Lines.Text)
  else if SameText(vCID,'market_sh') Then
    SaveCBText('hushi',MemoCB_CBInfo.Lines.Text)
  else if SameText(vCID,'market_sz') Then
    SaveCBText('shenshi',MemoCB_CBInfo.Lines.Text)
  else if SameText(vCID,'TW_Stop') or SameText(vCID,'passaway') Then
    SaveCBText('passaway',MemoCB_CBInfo.Lines.Text)
  else if SameText(vCID,'StopIssue_tw') or SameText(vCID,'Stop_Issue') Then
    SaveCBText('stop',MemoCB_CBInfo.Lines.Text)
  else if SameText(vCID,'TW_OTC') Then
    SaveCBText('shanggui',MemoCB_CBInfo.Lines.Text)
  else if SameText(vCID,'TW_Market') Then
    SaveCBText('shangshi',MemoCB_CBInfo.Lines.Text)
  else if SameText(vCID,'Send_tw') Then
    SaveCBText('song',MemoCB_CBInfo.Lines.Text)
  else if SameText(vCID,'Prepare_List_tw') or SameText(vCID,'Prepare_List_china') Then
    SaveCBText('guapai',MemoCB_CBInfo.Lines.Text);
{
  if PageControl2.ActivePage=TabSheet_CBReady Then
     SaveCBText('nifaxing',MemoCB_Ready.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBPass Then
     SaveCBText('pass',MemoCB_Pass.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBSH Then
     SaveCBText('hushi',MemoCB_SH.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBSZ Then
     SaveCBText('shenshi',MemoCB_SZ.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBPassAway Then
     SaveCBText('passaway',MemoCB_PassAway.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBStop Then
     SaveCBText('stop',MemoCB_Stop.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBshanggui Then
     SaveCBText('shanggui',MemoCB_shanggui.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBshangshi Then
     SaveCBText('shangshi',MemoCB_shangshi.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBSong Then
     SaveCBText('song',MemoCB_Song.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBguapai Then
     SaveCBText('guapai',MemoCB_guapai.Lines.Text);
  if PageControl2.ActivePage=TabSheet_CBInfo Then
     SaveCBInfoText('cbinfo.dat',MemoCB_CBinfo.Lines.Text);
}
  MsgHint('上传文件成功');
  Result := True;

Except
  On E:Exception do
    ShowMessage(E.Message);
end;
finally
end;
end;



function TAMainFrm.SaveCBText(DocTag, DocText: String;action:String='SetCBTxt'): Boolean;
Var
  AStream: TMemoryStream;
  SResponse: string;
  Msner: TMSNPopUp;
  //BitMap:TBitMap;
  ASaveError:Boolean; //--DOC4.0.0—N002 huangcq081223 add
begin
   AStream := nil;
   Result := False;

   if Length(Trim(DocText))<=0 then //--DOC4.0.0—N002 huangcq081223 add
   begin
     Raise Exception.Create(FAppParam.ConvertString('内容为空，无法上传!'));
     exit;
   end;

   SetInitConnect;
   Msner:=TMSNPopUp.Create(self);
        {Bitmap := TBitmap.Create;
        Bitmap.LoadFromFile('PopUp.bmp'); }

try
try

   with IdTCPClient1 do
   begin
     Connect;
     while Connected do
     begin

        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then
           Break;

        WriteLn(action);

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
          WriteLn(DocTag);

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
        Begin

          AStream := TMemoryStream.Create;
          CompressStream(DocText,AStream);

          OpenWriteBuffer;
          //WriteStream(AStream); //--DOC4.0.0—N002 huangcq081223 del
          WriteStream(AStream,True,True); //--DOC4.0.0—N002 huangcq081223 add
          CloseWriteBuffer;

          //AStream := TStringStream.Create(DocText);
          //OpenWriteBuffer;
          //WriteStream(AStream);
          //CloseWriteBuffer;
          //AStream.Free;
        End;

        //--DOC4.0.0—N002 huangcq081223 add--------->
          //服务器端多了一个如果保存成功，则WriteLn('SAVEOK'),如果没有保存成功则没有执行个写入语句,
          //客户端这里ReadLn若出现异常，则表示服务器端没有保存成功,
          //即ASaveError被赋为True，但此时与服务器的连接仍然是正常的，所以在下文的Panel_Waring.Visible要避开此情况
        try
          if UpperCase(ReadLn)='SAVEOK' then
            ASaveError:=False
          else
            ASaveError:=True;
        except
          ASaveError:=True;
        end;
        if ASaveError then
          Raise Exception.Create(FAppParam.ConvertString('服务器端保存出错，请检查DocCenter!'));
        //<--DOC4.0.0—N002 huangcq081223 add---------

        Disconnect;

     end;

   end;

   Result := True;
   Panel_Waring.Visible :=false;
   IsHaveError := false;

Except
   //add by JoySun 2005/10/24
   On E : Exception do
   Begin
      //--DOC4.0.0—N002 huangcq081223 add //这里增加了ASaveError
      if(Pos('Stream',Trim(E.Message))=0) and (not ASaveError) then
      begin
        Panel_Waring.Visible :=true;
        {
        Lbl_waring1.Caption :=FAppParam.ConvertString('Connecting Error,Retry Again And Check The DocSever!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('Error Message:'+Trim(E.Message));
        }

        Lbl_waring1.Caption :=FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('错误信息:'+Trim(E.Message));

        if(AutoCheckDoc)and(not IsHaveError)then
        begin
          Msner.BackgroundImage:=image1.Picture.Bitmap;
          Msner.Title := FAppParam.ConvertString('DocMgr错误信息');
          Msner.Text := FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
          Msner.ShowPopUp;
          IsHaveError := true;
        end;
      end;
      Raise; //--DOC4.0.0—N002 huangcq081223 add //异常信息也返回给上一层处理，避免没有保存成功但仍然提示'保存成功'
   End;
End;

Finally
   if Assigned(AStream) Then
      AStream.Free;
   IdTCPClient1.Disconnect;
   if Assigned(Msner) then                 
    Msner.Free;
  {if Assigned(Bitmap) then
    Bitmap.Free;  }
end;

end;

procedure TAMainFrm.btnExportClick(Sender: TObject);
begin
Try
   if SetCBText Then
      DisplayWWWF10TitleMgr.ClearMsg;
Except
End;
end;

procedure TAMainFrm.LoadCBTxt;
Var
  f : TStringList;
  vIniDir,vTitle,vMsg:String;
begin
  if DirectoryExists(FAppParam.Tr1DBPath + 'CBData\publish_db\') then
    Open_Dialog.InitialDir := FAppParam.Tr1DBPath + 'CBData\publish_db\'
  else if DirectoryExists(FAppParam.Tr1DBPath) then
    Open_Dialog.InitialDir := FAppParam.Tr1DBPath;
  //else      //--Doc4.4.0.0 del by pqx 20120207
    //raise Exception.Create(FAppParam.Tr1DBPath + 'not exists');


     if Open_Dialog.Execute Then
     Begin
       if FileExists(Open_Dialog.FileName) Then
       Begin
        vTitle := ConvertStr('询问');
        vMsg := ConvertStr('您当前操作的文件是:')+
           ExtractFileName(Open_Dialog.FileName)+ #13#10 + ConvertStr('确定吗?');
        if MessageBox(0,Pchar(vMsg),PChar(vTitle),MB_YESNO) <> 7     then
         begin
           f := TStringList.Create;
           f.LoadFromFile(Open_Dialog.FileName);
           //modify by wangjinhua 20090626 Doc4.3
           MemoCB_CBInfo.Lines.Text := f.Text;
           f.Free;
           PageControl2.ActivePage := TabSheet_CBUpload;
         end;
       End;
     End;
end;

procedure TAMainFrm.Button2Click(Sender: TObject);
begin
  LoadCBTxt;
end;

function TAMainFrm.HaveKeyWord(const KeyWord, Memo: String): Boolean;
begin
    Result := Pos(KeyWord,Memo)>0;
end;

procedure TAMainFrm.OnDocCheckKeyWord(Memo: String;
  var KeyWordStr: String);
Var
  i : Integer;  
begin
    KeyWordStr := '';
    For i:=0 to FAppParam.MarketKeyWordCount-1 do
    Begin
        if HaveKeyWord(FAppParam.MarketKeyWord[i],Memo) Then
        Begin
          if Length(KeyWordStr)=0 Then
             KeyWordStr := FAppParam.MarketKeyWord[i]
          Else
             KeyWordStr := KeyWordStr + '; ' + FAppParam.MarketKeyWord[i];
        End;
    End;

end;

function TAMainFrm.ReadLogDoc(const ReadTag: String): String;
Var
  AStream: TMemoryStream;
  AStrStream: TStringStream;
  SResponse: string;
  Msner: TMSNPopUp;
  //BitMap:TBitMap;
begin

   SetInitConnect;
   AStream := nil;

   Result := '';

    Msner:=TMSNPopUp.Create(self);
        {Bitmap := TBitmap.Create;
        Bitmap.LoadFromFile('PopUp.bmp'); }

try
try

   with IdTCPClient1 do
   begin
     Connect;
     while Connected do
     begin

        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then
           Break;

        if(mode_comb.Text=FAppParam.ConvertString('公告'))then
        begin
          if RadioButton1.Checked  Then
             WriteLn('READLOGDOC_02')
          Else
             WriteLn('READDELLOGDOC_02');
        end else
        if(mode_comb.Text=FAppParam.ConvertString('拟发'))then
        begin
          if RadioButton1.Checked  Then
             WriteLn('READLOGDOC_01')
          Else
             WriteLn('READDELLOGDOC_01');
        end else
        if(mode_comb.Text=FAppParam.ConvertString('过会'))then
        begin
          if RadioButton1.Checked  Then
             WriteLn('READLOGDOC_03')
          Else
             WriteLn('READDELLOGDOC_03');
        end;

       {   if RadioButton1.Checked  Then
             WriteLn('READLOGDOC')
          Else
             WriteLn('READDELLOGDOC');
       }
        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
          WriteLn(ReadTag);

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
        Begin

          AStrStream := TStringStream.Create('');

          AStream := TMemoryStream.Create();
          ReadStream(AStream, -1, True);

          DeCompressStream(AStream);
          AStream.SaveToStream(AStrStream);

          Result := AStrStream.DataString;

          AStrStream.Free;

          Disconnect;

        End;

     end;

   end;
   Panel_Waring.Visible :=false;
   IsHaveError := false;

Except
   //add by JoySun 2005/10/24
   On E : Exception do
   Begin
      
      if(Pos('Stream',Trim(E.Message))=0) then
      begin
      Panel_Waring.Visible :=true;
      {
        Lbl_waring1.Caption :=FAppParam.ConvertString('Connecting Error,Retry Again And Check The DocSever!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('Error Message:'+Trim(E.Message));
        }

        Lbl_waring1.Caption :=FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('错误信息:'+Trim(E.Message));

      if(AutoCheckDoc)and(not IsHaveError)then
      begin

        Msner.BackgroundImage:=image1.Picture.Bitmap;
        Msner.Title := FAppParam.ConvertString('DocMgr错误信息');
        Msner.Text := FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Msner.ShowPopUp;
        IsHaveError := true;
      end;

      end;


   End;
End;

Finally
   IdTCPClient1.Disconnect;
   if Assigned(Msner) then                 
    Msner.Free;
  {if Assigned(Bitmap) then
    Bitmap.Free;  }
end;

end;

procedure TAMainFrm.GetLogDocText;
Var
   ADoc:TDocData;
   i : Integer;
begin


   Btn_RefreshView.Enabled := False;


   if PageControl1.ActivePage=TabSheet_View Then
   Begin

     ViewWWWF10TitleMgr.ClearMsg;
     if GetViewDocList Then
     Begin

        if ViewDocMgr_2.DocList.Count>0 Then
        Begin
            PBar.Visible := True;
            PBar.Max := ViewDocMgr_2.DocList.Count-1;
            PBar.Min := 0;
        End;
        ViewWWWF10TitleMgr.BeginUpdate;
        Try
        for i:=0 to ViewDocMgr_2.DocList.Count-1 do
        Begin
          PBar.Position := i;
          Application.ProcessMessages; 
          ADoc := ViewDocMgr_2.DocList.Items[i];
          ViewWWWF10TitleMgr.AddCaption(ADoc.GUID);
        End;
        Except
          On E:Exception Do
            ShowMessage(E.Message); 
        End;
        PBar.Visible := false;
        ViewWWWF10TitleMgr.EndUpdate;
     End;
    End;

    Btn_RefreshView.Enabled := True;

end;

function TAMainFrm.GetViewDocList: Boolean;
begin

  Result := false;
Try
Try
  ViewDocMgr_2.DocListText  := ReadLogDoc(formatDateTime('yymmdd',Txt_ViewDate.Date));
  Result := True;
Except
end;
finally
end;

end;

{ TViewWWWF10TitleMgr }

procedure TViewWWWF10TitleMgr.AddCaption(const GUID: string);
Var
  AItem : TdxTreeListNode;
  ADoc:TDocData;
  KeyWordStr ,Strtemp: String;
begin

   ADoc := FDocDataMgr.GetADoc(GUID);
   if Not Assigned(ADoc) Then exit;

   if Assigned(FOnDocCheckKeyWord) Then
      FOnDocCheckKeyWord(ADoc.Memo,KeyWordStr);

   AItem := FMemo1.Add;

   Strtemp := IntToStr(FMemo1.Count);
   case Length(Strtemp) of
     1 : Strtemp := '000'+Strtemp;
     2 : Strtemp := '00'+Strtemp;
     3 : Strtemp := '0'+Strtemp;
     4 : Strtemp := Strtemp;
   end;
   //AItem.Strings[FMemo1.ColumnByName('View_Column_Index').Index] := IntToStr(FMemo1.Count);
   AItem.Strings[FMemo1.ColumnByName('View_Column_Index').Index] := Strtemp;
   AItem.Strings[FMemo1.ColumnByName('View_Column_Caption').Index] := ADoc.Title;
   AItem.Strings[FMemo1.ColumnByName('View_Column_Code').Index] := ADoc.ID;
   AItem.Strings[FMemo1.ColumnByName('View_Column_DateTime').Index] := ADoc.FmtDate;
   AItem.Strings[FMemo1.ColumnByName('View_Column_GUID').Index] := GUID;
   AItem.Strings[FMemo1.ColumnByName('View_Column_ClassTxt').Index] := ADoc.DocClassTxt;
   AItem.Strings[FMemo1.ColumnByName('View_Column_ClassColor').Index] := IntToStr(ADoc.DocClassColor);
   AItem.Strings[FMemo1.ColumnByName('View_Column_KeyWord').Index] := KeyWordStr;

   //FMemo1.Refresh;


end;

procedure TViewWWWF10TitleMgr.BeginUpdate;
begin
  FMemo1.BeginUpdate; 
end;

procedure TViewWWWF10TitleMgr.ClearMsg;
begin
   FMemo1.ClearNodes;
end;


constructor TViewWWWF10TitleMgr.Create(AMemo1: TdxTreeList;
  DocDataMgr: TDocDataMgr);
begin
   FMemo1 := AMemo1;
   FDocDataMgr := DocDataMgr;
   FMemo1.OnDblClick := DblClick;
   FMemo1.OnCustomDraw := OnCustomDraw;
   ClearMsg;

end;

procedure TViewWWWF10TitleMgr.DblClick(Sender: TObject);
Var
  aNode : TdxTreeListNode;
  AChkDoc2Frm : TAViewDocFrm;
  GUID : String;
  ADoc : TDocData;
  Status : TChkStatus;
 // DoOk : Boolean;
  KeyWord : string;
begin

   aNode := FMemo1.FocusedNode;
   if aNode=nil Then Exit;

   GUID := aNode.Strings[FMemo1.ColumnByName('View_Column_GUID').Index];
   KeyWord := aNode.Strings[FMemo1.ColumnByName('View_Column_KeyWord').Index];

   ADoc := FDocDataMgr.GetADoc(GUID);


   AChkDoc2Frm := TAViewDocFrm.Create(nil);
   //FMemo1.Enabled := False;
Try

  Status :=  AChkDoc2Frm.OpenChkFrm(ADoc.DocClassIndex,
                                    ADoc.CBID,ADoc.Memo,ADoc.Title,KeyWord);

Finally
   aNode.Focused := True;
   AChkDoc2Frm.Destroy;
   //FMemo1.Enabled := True;
End;

end;

destructor TViewWWWF10TitleMgr.Destroy;
begin
  FMemo1.ClearNodes;
end;

procedure TViewWWWF10TitleMgr.EndUpdate;
begin
  FMemo1.EndUpdate;
end;

procedure TViewWWWF10TitleMgr.OnCustomDraw(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; const AText: String; AFont: TFont;
  var AColor: TColor; ASelected, AFocused: Boolean; var ADone: Boolean);
Var
  Color : TColor;
begin
   if Not ASelected Then
   Begin
     Color := StrToInt(ANode.Strings[FMemo1.ColumnByName('View_Column_ClassColor').Index]);
     if Color>=0 Then
     Begin
        AColor := Color;
        AFont.Color := clWhite;
     End;
   End;

end;

procedure TAMainFrm.Btn_RefreshViewClick(Sender: TObject);
begin
Try

  GetLogDocText;
  
Except
End;
end;

function TAMainFrm.ReadCbinfoDoc(const ReadTag: String): String;
var
  SResponse: string;
  AStream: TMemoryStream;
  AStrStream: TStringStream;
  //decs: TDeCompressionStream;
  //f : TStringList;
  //DstFile1 : String;
 // Buffer: PChar;
  //Count: integer;
  Msner: TMSNPopUp;
  //BitMap:TBitMap;
begin

  SetInitConnect;

  AStream := nil;
  Result := '';
  Msner:=TMSNPopUp.Create(self);
        {Bitmap := TBitmap.Create;
        Bitmap.LoadFromFile('PopUp.bmp');  }

Try
Try

  with IdTCPClient1 do
  begin
    Connect;
    while Connected do
    begin

        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then Break;

        WriteLn(ReadTag);



        AStrStream := TStringStream.Create('');
        AStream := TMemoryStream.Create();
        ReadStream(AStream, -1, True);

        DeCompressStream(AStream);
        AStream.SaveToStream(AStrStream);

        //AStream.Seek(0, soFromBeginning);
        //AStream.ReadBuffer(count,sizeof(count));
        //GetMem(Buffer, Count);

        //decs := TDeCompressionStream.Create(AStream);
        //decs.ReadBuffer(Buffer^, Count);

        //AStream.Clear;
        //AStream.WriteBuffer(Buffer^, Count);
        //AStream.Position := 0;//复位流指针

        //AStream.LoadFromStream(decs);

        //DstFile1 := GetWinTempPath+ReadTag;
        //DstFile2 := GetWinTempPath+'_'+ReadTag;
        //AStream.SaveToFile(DstFile1);

        //f := TStringList.Create;
        //f.Text :=  AStrStream.DataString
        //f.LoadFromFile(DstFile1);

        //DeCompressFile(DstFile1,DstFile2);

        Result := AStrStream.DataString;

        //f.Free;
        AStrStream.Free;

        //DeleteFile(DstFile2);

        Disconnect;

    end;
  end;
  Panel_Waring.Visible :=false;
  IsHaveError := false;

Except
   //add by JoySun 2005/10/24
   On E : Exception do
   Begin
      
      if(Pos('Stream',Trim(E.Message))=0) then
      begin
      Panel_Waring.Visible :=true;
      {
        Lbl_waring1.Caption :=FAppParam.ConvertString('Connecting Error,Retry Again And Check The DocSever!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('Error Message:'+Trim(E.Message));
        }

        Lbl_waring1.Caption :=FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('错误信息:'+Trim(E.Message));

      if(AutoCheckDoc)and(not IsHaveError)then
      begin

        Msner.BackgroundImage:=image1.Picture.Bitmap;
        Msner.Title := FAppParam.ConvertString('DocMgr错误信息');
        Msner.Text := FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Msner.ShowPopUp;
        IsHaveError := true;
        
      end;

      end;


   End;
end;

finally
   IdTCPClient1.Disconnect;
   if AStream<>nil Then
      AStream.Free;
   if Assigned(Msner) then                 
    Msner.Free;
  {if Assigned(Bitmap) then
    Bitmap.Free;}
end;

end;

function TAMainFrm.SaveCBInfoText(DocTag, DocText: String): Boolean;
Var
  AStream: TMemoryStream;
  SResponse: string;
  Msner: TMSNPopUp;
  //BitMap:TBitMap;
  ASaveError:Boolean; //--DOC4.0.0—N002 huangcq081223 add
begin
   AStream := nil;
   Result := False;

   if Length(Trim(DocText))<=0 then //--DOC4.0.0—N002 huangcq081223 add
   begin
     Raise Exception.Create(FAppParam.ConvertString('内容为空，无法上传!'));
     exit;
   end;

   SetInitConnect;
   Msner:=TMSNPopUp.Create(self);
        {Bitmap := TBitmap.Create;
        Bitmap.LoadFromFile('PopUp.bmp');  }

try
try

   with IdTCPClient1 do
   begin
     Connect;
     while Connected do
     begin

        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then
           Break;

        WriteLn('SetCBDat');

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
          WriteLn(DocTag);

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
        Begin

          AStream := TMemoryStream.Create;
          CompressStream(DocText,AStream);

          OpenWriteBuffer;
          //WriteStream(AStream); //--DOC4.0.0—N002 huangcq081223 del
          WriteStream(AStream,True,True); //--DOC4.0.0—N002 huangcq081223 add
          CloseWriteBuffer;

        End;

        //--DOC4.0.0—N002 huangcq081223 add--------->
          //服务器端多了一个如果保存成功，则WriteLn('SAVEOK'),如果没有保存成功则没有执行个写入语句,
          //客户端这里ReadLn若出现异常，则表示服务器端没有保存成功,
          //即ASaveError被赋为True，但此时与服务器的连接仍然是正常的，所以在下文的Panel_Waring.Visible要避开则情况
        try
          if UpperCase(ReadLn)='SAVEOK' then
            ASaveError:=False
          else
            ASaveError:=True;
        except
          ASaveError:=True;
        end;
        if ASaveError then
          Raise Exception.Create(FAppParam.ConvertString('服务器端保存出错，请检查DocCenter!'));
        //<--DOC4.0.0—N002 huangcq081223 add---------

        Disconnect;

     end;

   end;

   Result := True;
   Panel_Waring.Visible :=false;
   IsHaveError := false;
Except
   //add by JoySun 2005/10/24
   On E : Exception do
   Begin
      //--DOC4.0.0—N002 huangcq081223 add //这里增加了ASaveError
      if(Pos('Stream',Trim(E.Message))=0) and (not ASaveError) then
      begin
        Panel_Waring.Visible :=true;
        {
        Lbl_waring1.Caption :=FAppParam.ConvertString('Connecting Error,Retry Again And Check The DocSever!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('Error Message:'+Trim(E.Message));
        }

        Lbl_waring1.Caption :=FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
        Lbl_waring2.Caption :=FAppParam.ConvertString('错误信息:'+Trim(E.Message));

        if(AutoCheckDoc)and(not IsHaveError) then
        begin

          Msner.BackgroundImage:=image1.Picture.Bitmap;
          Msner.Title := FAppParam.ConvertString('DocMgr错误信息');
          Msner.Text := FAppParam.ConvertString('连接DocCenter失败，请重试或联系技术人员!');
          Msner.ShowPopUp;
          IsHaveError := true;
        end;
      end;
      Raise; //--DOC4.0.0—N002 huangcq081223 add //异常信息也返回给上一层处理，避免没有保存成功但仍然提示'保存成功'
   End;
End;

Finally
   if Assigned(AStream) Then
      AStream.Free;
   IdTCPClient1.Disconnect;
   if Assigned(Msner) then                 
    Msner.Free;
  {if Assigned(Bitmap) then
    Bitmap.Free; }
end;

end;


procedure TAMainFrm.Timer_ChKDocTimer(Sender: TObject);
Var
   Msner: TMSNPopUp;
   //BitMap:TBitMap;
   ADoc:TDocData;
   i : Integer;
   HaveNewDoc : Boolean;
begin
  Timer_ChKDoc.Enabled:=false;
Try
  HaveNewDoc := false;

  Msner:=TMSNPopUp.Create(self);
  //Msner.Options :=
  {Bitmap := TBitmap.Create;
  Bitmap.LoadFromFile('PopUp.bmp');
  Msner.BackgroundImage:=Bitmap; }
  Msner.BackgroundImage:=image1.Picture.Bitmap;

  //Doc1
  if not HaveNewDoc then
  begin
  if GetDoc1List Then
  Begin
    if(DocDataMgr_1.DocList.Count>0)then
      DisplayWWWCSTitleMgr.ClearMsg;
    for i:=0 to DocDataMgr_1.DocList.Count-1 do
    Begin
      ADoc := DocDataMgr_1.DocList.Items[i];
      DisplayWWWCSTitleMgr.AddCaption(ADoc.GUID ,ADoc.Title,ADoc.DOCID,ADoc.DocType,
                                         ADoc.FmtDateTime,Adoc.Memo);
    End;

    if (DocDataMgr_1.DocList.Count>0) Then
    begin
      Msner.Title := FAppParam.ConvertString('DocMgr提示');
      Msner.Text := FAppParam.ConvertString('有新拟发公告信息');
      Msner.ShowPopUp;

      PageControl1.Enabled := true;
      PageControl1.ActivePage:=TabSheet_Doc1;

      HaveNewDoc := true;
    end;
  End;

  end;

  //Doc2
  if not HaveNewDoc then
  begin
  if GetDoc2List Then
  Begin
    if(DocDataMgr_2.DocList.Count>0)then
      DisplayWWWF10TitleMgr.ClearMsg;
    for i:=0 to DocDataMgr_2.DocList.Count-1 do
    Begin
      ADoc := DocDataMgr_2.DocList.Items[i];
      DisplayWWWF10TitleMgr.AddCaption(ADoc.GUID);
    End;

    if (DocDataMgr_2.DocList.Count>0) Then
    begin
      Msner.Title := FAppParam.ConvertString('DocMgr提示');
      Msner.Text := FAppParam.ConvertString('有新公告信息');
      Msner.ShowPopUp;

      PageControl1.Enabled := true;
      PageControl1.ActivePage:=TabSheet_Doc2;

      HaveNewDoc := true;
    end;
  End;

  end;

  //Doc3
  if not HaveNewDoc then
  begin
  if GetDoc3List Then
  Begin
    if(DocDataMgr_3.DocList.Count>0)then
      DisplayWWWCSRCTitleMgr.ClearMsg;
    for i:=0 to DocDataMgr_3.DocList.Count-1 do
    Begin
      ADoc := DocDataMgr_3.DocList.Items[i];
      DisplayWWWCSRCTitleMgr.AddCaption(ADoc.GUID);
    End;

    if (DocDataMgr_3.DocList.Count>0) Then
    begin
      Msner.Title := FAppParam.ConvertString('DocMgr提示');
      Msner.Text := FAppParam.ConvertString('有新过会公告信息');
      Msner.ShowPopUp;

      PageControl1.Enabled := true;
      PageControl1.ActivePage:=TabSheet_Doc3;

      HaveNewDoc := true;
    end;
  End;

  end;

  if Assigned(Msner) then
    Msner.Free;
  {if Assigned(Bitmap) then
    Bitmap.Free;}

  if not HaveNewDoc then
    Timer_ChKDoc.Enabled:=true
  else
  begin
    Btn_AutoCheck.Caption := FAppParam.ConvertString('自动检查公告');
    Caption := FAppParam.ConvertString('网上发行公告搜寻(手动)');
    Label1.Caption := FAppParam.ConvertString('当前状态：(手动)');

    Timer_ChKDoc_1.Enabled:=true;
    Timer_ChKDoc_2.Enabled:=true;
    Timer_ChKDoc_3.Enabled:=true;

    AutoCheckDoc := false;
  end;
Except
end;

end;

procedure TAMainFrm.Button4Click(Sender: TObject);
begin
  Timer_ChKDoc.Enabled:=true;
end;

{procedure TAMainFrm.WinOnActivate(Sender: TObject);
begin

end;

procedure TAMainFrm.WinOnDeActivate(Sender: TObject);
begin

end;}

procedure TAMainFrm.Btn_AutoCheckClick(Sender: TObject);
begin
Try
  if(not AutoCheckDoc)then
  begin
    //开始check
    PageControl1.Enabled := false;
    Btn_AutoCheck.Caption := FAppParam.ConvertString('停止检查公告');
    Caption := FAppParam.ConvertString('网上发行公告搜寻(自动)');
    Label1.Caption := FAppParam.ConvertString('当前状态：(自动)');
    //Btn_AutoCheck.Font.Color :=clRed;

    Timer_ChKDoc_1.Enabled:=false;
    Timer_ChKDoc_2.Enabled:=false;
    Timer_ChKDoc_3.Enabled:=false;
    Timer_ChKDoc.Enabled:=true;

    AutoCheckDoc := true;
  end    
  else
  begin
    //结束
    PageControl1.Enabled := true;
    Btn_AutoCheck.Caption := FAppParam.ConvertString('自动检查公告');
    Caption := FAppParam.ConvertString('网上发行公告搜寻(手动)');
    Label1.Caption := FAppParam.ConvertString('当前状态：(手动)');

    Timer_ChKDoc_1.Enabled:=true;
    Timer_ChKDoc_2.Enabled:=true;
    Timer_ChKDoc_3.Enabled:=true;
    Timer_ChKDoc.Enabled:=false;

    AutoCheckDoc := false;
  end;
except
end;
end;




end.
